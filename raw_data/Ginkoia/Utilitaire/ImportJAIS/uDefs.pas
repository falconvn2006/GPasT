unit uDefs;

interface

uses ShellApi, Windows, Forms, Dialogs, SysUtils, XMLIntf, ComCtrls,Classes,
     uTypes, StdCtrls,Db, shlobj, ComObj, ActiveX;

Const
  CERROR        =  -1;
  CRESULTOK     =   0;
  CFILENOTFOUND = 101;
  CHFERROR      = 102;
  CCANNOTOPENHF = 103;
  CCONVERTERROR = 104;
  CVERSION      = '1.3c';

  // GenParam
  CGENPTYPE = 12;
  CGENPCODETVA = 1; // TVA
  CGENPCODEGAR = 2; // GARANTIE
  CGENPCODETCP = 3; // Type Comptable
  CGENPCODEEXC = 4; // Exercice commercial
  CGENPCODEFOU = 5; // Fournisseur
  CGENPCODEVER = 6; // Verrou
  CGENPCODECOL = 7; // Collection Obligatoire
  CGENPCODEACH = 8; // Acheteur  

var
  GAPPPATH        ,
  GINIFILE        ,
  GPATHDATA       ,
  GPATHDATASTRUCT ,
  GPATHFILETMP    ,
  GPATHSOURCE     ,
  GPATHARCHIVEZIP ,
  GPATHARCHIVEJA  ,
  GFILEHFTOXML    ,
  GFILEDEST       ,
  GFILEFEDAS      : String;
  GPARAMDEFAUT    : TParamDefaut;
  BCONNECTED      : Boolean;
  BINPROGRESS     : Boolean;
  BDOCONVERT      : Boolean;
  GJADIR          : String;
  TableList       : TListTableHF;


  // Exécute un programme exterieur et attend qu'il finisse
  function ExecuteAndWait (sExeName : String;Param : String = '') : Integer;
  // Permet de récupérer la liste des tables à gérer et à mettre en place les dataset avec les champs
  function GetTableList(sTableFile : String) : TListTableHF;
  // Fonction qui converti les fichiers fic en fichier XML par rapport à la liste des tables à traiter
  function ConvertTbHF(ListTbHF : TListTableHF) : Boolean;
  // Rempli les données d'un mémo en formattant sText
  Procedure AddToMemo (Memo : TMemo;sText : String);
  // Convertie une valeur string en float (converti le . ou la , en celui par défaut
  function XmlStrToFloat(Value : String) : Extended;
  // fonction qui convertie la valeur date du fichier xml en valeur Tdatetime
  function XmlStrToDate(Value : String) : TDateTime;
  // fonction qui va copier le répertoire source des JA puis faire un raccourci
  function CopyFileAndCreateLink(ListTbHF : TListTableHF) : Boolean;
  // fonction récursive qui récupère la liste des fichiers d'un répertoire
  function GetFileList(sDir : String; var lst : TStringList) : boolean;

implementation

function ExecuteAndWait (sExeName : String;Param : String) : Integer;
Var  StartInfo   : TStartupInfo;
     ProcessInfo : TProcessInformation;
     Fin         : Boolean;
     ExitCode    : Cardinal;
begin
  Result := -1;
  { Mise à zéro de la structure StartInfo }
  FillChar(StartInfo,SizeOf(StartInfo),#0);
  { Seule la taille est renseignée, toutes les autres options }
  { laissées à zéro prendront les valeurs par défaut }
  StartInfo.cb     := SizeOf(StartInfo);

  { Lancement de la ligne de commande }
  If CreateProcess(PChar(sExeName),PChar(Param) ,nil , Nil, False,
                0, Nil, Nil, StartInfo,ProcessInfo) Then
  Begin
    { L'application est bien lancée, on va en attendre la fin }
    { ProcessInfo.hProcess contient le handle du process principal de l'application }
    Fin:=False;
    Repeat
      { On attend la fin de l'application }
      Case WaitForSingleObject(ProcessInfo.hProcess, 200)Of
        WAIT_OBJECT_0 :Fin:=True; { L'application est terminée, on sort }
        WAIT_TIMEOUT  :;          { elle n'est pas terminée, on continue d'attendre }
      End;
      { Mise à jour de la fenêtre pour que l'application ne paraisse pas bloquée. }
      Application.ProcessMessages;
    Until Fin;

    GetExitCodeProcess(ProcessInfo.hProcess,ExitCode);
    Result := ExitCode;
    { C'est fini }
  End
  Else RaiseLastOSError;
end;

function GetTableList(sTableFile : String) : TListTableHF;
var
  TbHF : TTableHF;
  lstTable,lstDecoupe,lstFieldFile,lstTmp : TStringList;
  i, j : integer;
begin
  Result := TListTableHF.Create;
  Result.OwnsObjects := True;
  lstTable       := TStringList.Create;
  lstDecoupe     := TStringList.Create;
  lstFieldFile   := TStringList.Create;
  lstTmp         := TStringList.Create;
  try
    try
      lstTable.LoadFromFile(sTableFile); //GPATHDATA + 'tablelist.txt');

      for i  := 0 to lstTable.Count - 1 do
      begin
       if (Trim(lstTable[i]) <> '') then
         if (lstTable[i][1] <> ';') then
         begin
           TbHF := TTableHF.Create;
           lstDecoupe.Text := StringReplace(lstTable[i],';',#13#10,[rfReplaceAll]);
           // récupération du nom de la table
           if Pos('@JADIR@',lstDecoupe[0]) > 0 then
             lstDecoupe[0] := StringReplace(lstDecoupe[0],'@JADIR@',GJADIR,[rfReplaceAll]);
           
           TbHF.TableName := Trim(lstDecoupe[0]);
           // récupération du pseudo de la table
           TbHF.TablePseudo := Trim(lstDecoupe[2]);
           // Récupération de la liste des champs de la table
           lstFieldFile.LoadFromFile(GPATHDATASTRUCT + Trim(lstDecoupe[1]) + '.txt');
           // séparation des champs table et champ pseudo
           for j := 0 to lstFieldFile.Count - 1 do
           begin
             if Trim(lstFieldFile[j]) <> '' then
             begin
               if Trim(lstFieldFile[j][1]) <> '+' then
               begin
                 lstDecoupe.text := StringReplace(lstFieldFile[j],';',#13#10,[rfReplaceAll]);
                 TbHF.FieldList.add(Trim(lstDecoupe[0]));
                 TbHF.FieldPseudoList.Add(Trim(lstDecoupe[1]));
               end
               else begin
                 lstDecoupe.Text := StringReplace(Copy(lstFieldFile[j],2,Length(lstFieldFile[j]) -1),';',#13#10,[rfReplaceAll]);
                 lstDecoupe[1] := UpperCase(Trim(lstDecoupe[1][1]));
                 // Ajoute des champs si + est trouvé comme premier caractère de la ligne
                 // [0] = Nom du champs
                 // [1] = Type du champ (I = Integer; F = Float; S = String
                 // [2] = taille du champs
                 case lstDecoupe[1][1] of
                   'I' : TbHF.CDataSet.FieldDefs.Add(Trim(lstDecoupe[0]),ftInteger);
                   'F' : TbHF.CDataSet.FieldDefs.Add(Trim(lstDecoupe[0]),ftFloat,StrToIntDef(Trim(lstDecoupe[2]),0));
                   'S' : TbHF.CDataSet.FieldDefs.Add(Trim(lstDecoupe[0]),ftString,StrToIntDef(Trim(lstDecoupe[2]),0));
                 end;
               end;
             end;
           end; // for

  //         TbHF.FieldList.LoadFromFile(GPATHDATASTRUCT + lstDecoupe[1] + '.txt');
           // Configuration du dataset
           for j := 0 to TbHF.FieldList.Count - 1 do
           begin
             if Trim(TbHF.FieldList[j]) <> '' then
                 TbHF.CDataSet.FieldDefs.Add(TbHF.FieldList[j],ftString,50)
           end; // for

           // On créer le dataset
           TbHF.CDataSet.CreateDataSet;

           Result.Add(TbHF);
         end; // if
      end; // for
    Except on E:Exception do
      raise Exception.Create('GetTableList -> ' + E.Message);
    end;
  finally
    lstTable.Free;
    lstDecoupe.free;
    lstTmp.Free;
  end;
end;

function ConvertTbHF(ListTbHF : TListTableHF) : Boolean;
var
  i : integer;
  sDestName : String;
  sTableName : String;
  sTmp : String;
  sParams : String;
  iPos : Integer;
begin
  Result := False;
  try
    for i := 0 to ListTbHF.Count - 1 do
    begin
      if Pos('@JADIR@',ListTbHF.Items[i].TableName) > 1  then
        ListTbHF.Items[i].TableName := StringReplace(ListTbHF.Items[i].TableName,'@JADIR@',GJADIR,[rfReplaceAll]);

      sTableName := ListTbHF.Items[i].TableName + '.fic';

      iPos := Pos('\',ListTbHF.Items[i].TableName) + 1;
      sDestName  := Copy(ListTbHF.Items[i].TableName,iPos,Length(ListTbHF.Items[i].TableName)) + '.xml';
      sTmp := '  Convertion : ' + ListTbHF.Items[i].TableName;
      // Laisser l'espace devant sinon la conversion ne se fera pas
      sParams := ' ' + AnsiQuotedStr(GPATHSOURCE + sTableName,'"') + ' ' + AnsiQuotedStr(GPATHFILETMP + sDestName,'"');
      if BDOCONVERT then
        case ExecuteAndWait(GFILEHFTOXML,sParams) of
          CRESULTOK: begin
            AddToMemo(ListTbHF.Memo, sTmp + ' >> OK');
            Result := True;
          end;
          CFILENOTFOUND : AddToMemo(ListTbHF.Memo,sTmp + ' >> Fichier non trouvé');
          CHFERROR      : AddToMemo(ListTbHF.Memo,sTmp + ' >> Impossible de convertir la table');
          CCANNOTOPENHF : AddToMemo(ListTbHF.Memo,sTmp + ' >> Erreur d''ouverture de la table');
          CCONVERTERROR : AddToMemo(ListTbHF.Memo,sTmp + ' >> Erreur lors de la convertion');
          else begin
            AddToMemo(ListTbHF.Memo,sTmp + ' >> Erreur inconnue');
            Result := False;
          end;
        end
      else begin
        AddToMemo(ListTbHF.Memo, sTmp + ' >> CONVERTION ANNULEE');
        Result := True;
      end;

      if Assigned(ListTbHF.Progress) then
        ListTbHF.Progress.Position := (i + 1) * 100 Div (ListTbHF.Count);

      Application.ProcessMessages;
    end;
  Except on E:Exception do
    raise Exception.Create('ConvertTbHF -> ' + E.Message);
  end;
end;

Procedure AddToMemo (Memo : TMemo;sText : String);
begin
  if Memo <> nil then
    Memo.Lines.Add(FormatDateTime('[DD/MM/YYYY hh:mm:ss] -> ',Now) + sText);
end;

function XmlStrToFloat(Value : String) : Extended;
begin
  try
    if Trim(Value) <> '' then
    begin
      if Pos('.',Value) > 0 then
        Result := StrToFloat(StringReplace(Value,'.',DecimalSeparator,[rfReplaceAll]))
      else begin
        if Pos(',',Value) > 0 then
          Result := StrToFloat(StringReplace(Value,',',DecimalSeparator,[rfReplaceAll]))
        else
          Result := StrToFloat(Value);
      end;
    end
    else
      Result := 0;
  Except on E:Exception do
    raise Exception.create('XmlStrTofloat -> ' + E.Message);
  end;
end;

function XmlStrToDate(Value : String) : TDateTime;
var
  sDate : String;
begin
  sDate := Copy(Value,7,2) + '/' + Copy(Value,5,2) + '/' + Copy(Value,1,4);
  Try
    Result := StrToDAte(sDate);
  Except on E:Exception do
    raise Exception.Create('XmlStrToDate -> ' + E.Message);
  End;
end;

function CopyFileAndCreateLink(ListTbHF : TListTableHF) : Boolean;
var
//  TbJA : TTableHF;
  sDirDestination : String;
  sFileDestination : String;
  lst : TStringList;
  i : integer;
  sDirTmp : String;
  bError : Boolean;
  ShellLink : IShellLink;
  sDirDesktop : Array [0..MAX_PATH] of char;
begin
  Result := False;
//  TbJA := ListTbHF.GetTable('JA');
//  TbJA.CDataSet.Last; // Positionnement sur le dernier enregistrement (Il semble que parfois il y ait tous les JA dans la table mais il sont dans l'ordre)
  sDirDestination := GPATHARCHIVEJA + GJADIR + '\'; // TbJA.NFieldByName('JACODE').AsString + '\';
  if not DirectoryExists(sDirDestination) then
  begin
    AddToMemo(ListTbHF.Memo,'  Copie du répertoire des JA');

    ForceDirectories(sDirDestination);
    lst := TStringList.Create;
    try
      if GetFileList(GPATHSOURCE,lst) then
      begin
        bError := False;
        for i := 0 to lst.Count - 1 do
        begin
          sFileDestination := StringReplace(lst[i],GPATHSOURCE,sDirDestination,[rfReplaceAll]);
          sDirTmp := ExtractFilePath(sFileDestination);
          if not DirectoryExists(sDirTmp)  then
            ForceDirectories(sDirTmp);

          ListTbHF.Lab.Caption := 'Copie de ' + ExtractFileName(lst[i]) + ' vers ' + sDirTmp;
          if not CopyFile(PChar(lst[i]),PChar(sFileDestination),False) then
          begin
            AddToMemo(ListTbHF.Memo,'Erreur de copie de :' + lst[i]);
            AddToMemo(ListTbHF.Memo,'Vers :' + sFileDestination);
            bError := True;
            Break;
          end;

          ListTbHF.Progress.Position := (i + 1) * 100 Div lst.Count;
          Application.ProcessMessages;
        end;

        // On a eu une erreur lors de la copie des fichiers
        if bError then
        begin
          lst.Clear;
          GetFileList(sDirDestination,lst);
          for i  := 0 to lst.Count - 1 do
            DeleteFile(lst[i]);

          for I := 0 to lst.Count - 1 do
            if DirectoryExists(ExtractFilePath(lst[i])) then
              removeDir(ExtractFilePath(lst[i]));
          raise Exception.Create('CopyFileAndCreateLink -> : Erreur de copie des fichiers');
        end;

        // création du link pour cet archivage des JA
        // Récupération du répertoire du bureau du poste
        if ShGetSpecialFolderPath(0, sDirDesktop, CSIDL_DESKTOPDIRECTORY , False) then
        begin
          sDirTmp := IncludeTrailingBackslash(sDirDesktop) + 'Archives JA\';
          if not DirectoryExists(sDirTmp) then
            ForceDirectories(sDirTmp);
          
          ShellLink:=CreateComObject(CLSID_ShellLink) as IShellLink; //Création du raccourcis
          With ShellLink do
          begin
            SetDescription(PChar('Raccourcis Vers JA ' + GJADIR)); //Description du raccourcis (visible dans les propriétés du raccourcis)
            SetWorkingDirectory(Pchar(sDirDestination)); //Direction de l'execution du raccourcis (important si il un a des composants qui appelle des fichiers externes avec un chemin relatif)
            SetPath(PChar(sDirDestination + '\JA.exe')); //Chemin du .exe
            SetShowCmd(SW_SHOW); //?? mais ne marche pas quand on le met pas
            (ShellLink as IPersistFile).Save(StringToOleStr(sDirTmp +'JA ' + GJADIR + '.lnk'), true); //creation du raccourcis sur le bureau
          end;
        end;
      end;
    finally
      lst.free;
    end;
  end;
end;

function GetFileList(sDir : String; var lst : TStringList) : boolean;
var
   i : integer;
   Rec : TSearchRec;
begin
  Result := False;
  i := FindFirst(sDir + '*.*',faAnyFile,Rec);
  try
    while i = 0 do
    begin
      if (Rec.Name <> '.') and (Rec.Name <> '..') then
      begin
        if (Rec.Attr and faDirectory) = 0 then
          lst.Add(sDir + Rec.Name)
        else
          GetFileList(IncludeTrailingBackslash(sDir + Rec.Name),lst);
      end;
      i := FindNext(Rec);
    end;
    Result := True;
  finally
    sysutils.FindClose(Rec);
  end;
end;


end.
