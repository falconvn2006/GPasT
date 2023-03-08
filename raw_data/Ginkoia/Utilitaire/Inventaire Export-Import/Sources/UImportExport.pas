unit UImportExport;

interface

uses Windows, IBQuery, IBDatabase, IBODataset, IBSQL, SysUtils, Classes, Dialogs, StdCtrls, LMDCustomComponent, LMDFileGrep, Forms;

procedure GetPlage(AQuery: TIBQuery; ASQLExec: TIBSQL; AInv_ID: integer; var ADebutPlage, AFinPlage: Integer);
function SaveQueryToFileSaveFile(var ATString: TStringList; AFileNameToExport: string): boolean;
function SaveQueryToFile(AQuery: TIBQuery; ATableName, AFileNameToExport: string; Alocation : Boolean; AlocationDate : string): boolean;
function ExportInventaire(AQuery: TIBQuery; AInv_ID: integer; APathExport: string; Alocation : Boolean; AlocationDate : string; AExportStock: boolean = true): boolean;
function ImportInventaire(AQuery: TIBSQL; APathFiles: string; AImportStock: boolean = true): boolean;
function ImportFileToDatabase(AQuery: TIBSQL; sFileImport: string): boolean;
procedure FileNameToTableAndNumber(AFileName: string; var ATable: string);
function RecalcSTC_ID(AQuery: TIBQuery; ASQLExec: TIBSQL; AMag_Id: integer): boolean;
function SetGenerators(AQuery: TIBQuery; ASQLExec: TIBSQL; AInv_Id: integer): boolean;
function ScriptExecute(ASQLExec: TIBSQL; AFile: string): boolean;


implementation

uses UCommon, FileCtrl, Math, DB, StrUtils;

const NbLigMaxParFichier: integer = 30000;
const NbLigAvCommitWork: integer = 500;

procedure FileNameToTableAndNumber(AFileName: string; var ATable: string);
var
  sTmpFileName: string;
  i, j: integer;
begin
//   08_INVIMGSTK_0001.txt
  try
    sTmpFileName := ChangeFileExt(AFileName, '');
    i := pos('_', sTmpFileName);
    j := LastDelimiter('_', sTmpFileName);
    ATable := copy(sTmpFileName, i + 1, j - (i + 1));
//    ANumber := StrToInt(copy(sTmpFileName, j + 1, 4));
  except
    on E: exception do
    begin
      LogAction('**   --> : Exception : ' + StringReplace(E.Message, #13#10, ' | ', [rfReplaceAll]) + ' **');
    end;
  end;
end;

function ImportFileToDatabase(AQuery: TIBSQL; sFileImport: string): boolean;

var
  sMyTable: string;
//  iMyNum: integer;
  TS: TStringList;
  i: integer;
begin
  result := true;

  // On extrait le nom de la table, et le n° du fichier (pas utilisé mais on sait jamais).
  FileNameToTableAndNumber(sFileImport, sMyTable);

  // On commence par créer l'insert
  AQuery.SQL.Clear;
  TS := TSTringList.Create;
  try
    TS.LoadFromFile(sFileImport);

    for i := 0 to TS.Count - 1 do
    begin
      try
        if pos('COMMIT WORK;', TS[i]) <= 0 then
        begin
          // On ne concatene que les lignes de requete.
          AQuery.SQL.Add(TS[i]);
          if pos(';', AQuery.SQL.Text) > 0 then
          begin
            AQuery.ExecQuery;
            AQuery.SQL.Clear;
          end;
        end
        else
        begin
          Progress;
          AQuery.Transaction.Commit;
          AQuery.Transaction.StartTransaction;
        end;
      except
        on E: exception do
        begin
//          AQuery.Transaction.rollback;
          LogAction('**   --> : Exception : ' + StringReplace(E.Message, #13#10, ' | ', [rfReplaceAll]) + ' **');
          AQuery.SQL.Clear;
          result := false;
        end;
      end;
    end;
  except
    on E: exception do
    begin
      LogAction('**   --> : Exception : ' + StringReplace(E.Message, #13#10, ' | ', [rfReplaceAll]) + ' **');
      result := false;
    end;
  end;
  ts.free
end;

function ImportInventaire(AQuery: TIBSQL; APathFiles: string; AImportStock: boolean = true): boolean;
var
  FGrep_Scripts: TLMDFileGrep;

  sFileImport: string;

  bAllWasOk: boolean;

  sMyTable: string;
//  iMyNum: integer;
  i: integer;
begin
//  result := true;
  bAllWasOk := true;

  FGrep_Scripts := TLMDFileGrep.Create(nil);
  try
    AQuery.Transaction.StartTransaction;

    // On recherche tous les fichiers .SQL du dossier voulu
    FGrep_Scripts.FileMasks := '*.sql';
    FGrep_Scripts.RecurseSubDirs := false;
    FGrep_Scripts.ReturnDelimiter := ';';
    FGrep_Scripts.ThreadedSearch := False;
    FGrep_Scripts.ThreadPriority := tpHighest;
    FGrep_Scripts.Dirs := IncludeTrailingBackslash(APathFiles);
    FGrep_Scripts.ReturnValues := [rvDir, rvFilename];

    FGrep_Scripts.Grep;

    // On trie le résultat par nom de fichier
    QuickSort(FGrep_Scripts.Files);

    for i := 0 to (FGrep_Scripts.Files.Count - 1) do
    begin
      sFileImport := StringReplace(FGrep_Scripts.Files[i], ';', '', [rfReplaceAll]);

      // On Vérifie si on doit bien le traiter
      FileNameToTableAndNumber(sFileImport, sMyTable);
      if (UpperCase(sMyTable) = 'INVIMGSTK') and (AImportStock = false) then
      begin
        LogAction('** Non importé sur demande utilisateur : ' + sFileImport + ' **');
        LogAction('**   --> : OK **');
      end
      else
      begin
        // On l'importe
        LogAction('** Importation : ' + ExtractFileName(sFileImport) + ' **');
        if ImportFileToDatabase(AQuery, sFileImport) then
        begin
          LogAction('**   --> : OK **');
        end
        else
        begin
//          LogAction('** Erreur : Importation échouée ' + ExtractFileName(sFileImport) + ' **');
          bAllWasOk := false;
          BREAK; // on sort à la premiere erreur, pas la peine de continuer;
        end;
      end;

    end;

    // Si tout s'est bien passé, commit, Si on est sorti sur une erreur, on rollback
    if bAllWasOk then
    begin
      AQuery.Transaction.commit;
    end
    else
    begin
      AQuery.Transaction.rollback;
    end;

  except
    on E: exception do
    begin
      LogAction('**   --> : Exception : ' + StringReplace(E.Message, #13#10, ' | ', [rfReplaceAll]) + ' **');
      AQuery.Transaction.rollback;
      bAllWasOk := false;
    end;
  end;
  FGrep_Scripts.Free;

  result := bAllWasOk;
end;

function ExportInventaire(AQuery: TIBQuery; AInv_ID: integer; APathExport: string; Alocation : Boolean; AlocationDate : string; AExportStock: boolean = true): boolean;

var
  FGrep_Scripts: TLMDFileGrep;
  sFileQuery: string;
  sFileExport: string;
  sNomFic: string;
  sNomTbl: string;
  i: integer;
begin
  result := true;

  FGrep_Scripts := TLMDFileGrep.Create(nil);
  try
    // On recherche tous les fichiers .SQL du dossier voulu
    FGrep_Scripts.FileMasks := '*.sql';
    FGrep_Scripts.RecurseSubDirs := false;
    FGrep_Scripts.ReturnDelimiter := ';';
    FGrep_Scripts.ThreadedSearch := False;
    FGrep_Scripts.ThreadPriority := tpHighest;
    if Alocation then
      FGrep_Scripts.Dirs := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) + 'Scripts\04-Location\'
    else
      FGrep_Scripts.Dirs := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) + 'Scripts\02-Export\';
    FGrep_Scripts.ReturnValues := [rvDir, rvFilename];

    FGrep_Scripts.Grep;

    // On trie le résultat par nom de fichier
    QuickSort(FGrep_Scripts.Files);

    // Si on a trouvé les scripts....
    if FGrep_Scripts.Files.Count > 0 then
    begin
      // On s'assure que le chemin complet existe (sinon il est créée)
      Forcedirectories(APathExport);

      LogAction('** Debut export dans ' + APathExport + ' **');


      for i := 0 to (FGrep_Scripts.Files.Count - 1) do
      begin
        // On execute chaque script

        // 1 - Récup du fichier texte
        sFileQuery := StringReplace(FGrep_Scripts.Files[i], ';', '', [rfReplaceAll]);
        // 2 - On check le cas de l'export du stock si on a décoché la case d'export du stock.
        if not ((pos('INVIMGSTK', sFileQuery) > 0) and (AExportStock = false)) then
        begin
          AQuery.SQL.LoadFromFile(sFileQuery);
          if AQuery.Params.Count > 0 then
          begin
            if UpperCase(AQuery.Params[0].Name) = 'INV_ID' then
            begin
              AQuery.Params[0].AsInteger := AInv_ID;
            end;
          end;
          // 3 - Chemin ou le fichier sera exporté
          sFileExport := IncludeTrailingBackslash(APathExport) + ExtractFileName(sFileQuery);
          // Extraction du nom de la table dans laquelle on insere
          sNomFic := ChangeFileExt(ExtractFileName(sFileQuery), '');
          sNomTbl := Copy(sNomFic, pos('_', sNomFic) + 1, length(sNomFic));
          // Sauvegarde dans le fichier des instructions insert
          if not (SaveQueryToFile(AQuery, sNomTbl, sFileExport, Alocation, AlocationDate)) then
          begin
            result := false;
          end;
        end
        else
        begin
          LogAction('** Non exporte (User Rqst) ' + ExtractFileName(sFileQuery) + ' **');
          LogAction('**   --> : OK **');

        end;
      end;
    end;
  except
    on E: exception do
    begin
      LogAction('**   --> : Exception : ' + StringReplace(E.Message, #13#10, ' | ', [rfReplaceAll]) + ' **');
      result := false;
    end;
  end;
  FGrep_Scripts.Free;
end;

function SaveQueryToFile(AQuery: TIBQuery; ATableName, AFileNameToExport: string; Alocation : Boolean; AlocationDate : string): boolean;
var
  TS: TStringList;
  i, j: integer;
  sFileName: string;
  iNumPage: integer;
  sMyFields, sMyVals, vVal, Vtmp: string;
begin
  // Sauvegarde une query préchargée dans un fichier SQL de type Insert
  // On écrit un max de xxxxx lignes par fichier pour éviter de trop gros fichiers
  // xxxxx défini par "const NbLigMaxParFichier: integer = xxxxx;"
//  k := 0;
  result := true;
  AQuery.Open;
  TS := TStringList.Create;
  try
    AQuery.First;
    j := 0;
    iNumPage := 0;
    TS.clear;

    AQuery.FetchAll;
    while not (AQuery.Eof) do
    begin
//      inc(k);
      inc(j);

      if (j = 1) and (Alocation) then
      begin
        Vtmp := 'create procedure IMPORT_INV_LOCATION (NEWDATE varchar(10)) as declare variable DOSID integer; declare variable maxgen integer; declare variable currentgen integer; begin  DOSID=-1;  select DOS_ID from gendossier where DOS_NOM = ''LOCINV'' rows 1 into ';
        Vtmp := Vtmp + ':DOSID;  if (DOSID=-1) then  begin    INSERT INTO GENDOSSIER (DOS_ID, DOS_NOM, DOS_STRING, DOS_FLOAT, DOS_CODE) select ID, ''LOCINV'', :NEWDATE, 0, 0 from pr_newk(''GENDOSSIER'');  end  else  begin    update gendossier set DOS_STRING = :NEWDATE where ';
        Vtmp := Vtmp + 'DOS_ID=:DOSID;    execute procedure pr_updatek(:DOSID, 0);  end  select max(lin_id)+1 from locinventaire into :maxgen;  currentgen=GEN_ID(NUM_INVLIGNES, 0);  if (currentgen < maxgen) then  begin    execute statement ''set generator NUM_INVLIGNES ';
        Vtmp := Vtmp + 'to '' || cast(:maxgen as integer) ||'';'';  end end;';

        TS.Add(Vtmp);
        TS.add('COMMIT WORK;');
        TS.Add('execute procedure IMPORT_INV_LOCATION(' + QuotedStr(AlocationDate) + ');');
        TS.add('COMMIT WORK;');
        TS.Add('drop procedure IMPORT_INV_LOCATION;');
        TS.add('COMMIT WORK;');
      end;


      sMyFields := '';
      sMyVals := '';
      for i := 0 to AQuery.Fields.Count - 1 do
      begin
        // Les champs
        sMyFields := sMyFields + ',' + AQuery.Fields[i].FieldName;

        // Les valeurs
        if (UpperCase(AQuery.Fields[i].FieldName) <> 'LIN_ID') then
        begin
          if AQuery.Fields[i].Asstring = '' then
          begin
            sMyVals := sMyVals + ',null';
          end
          else
          begin
            case AQuery.Fields[i].DataType of
              ftFloat : vVal := ReplaceStr(AQuery.Fields[i].Asstring, ',', '.');
              ftMemo, ftString, ftWideMemo, ftWideString : vVal := QuotedStr(AQuery.Fields[i].Asstring);
              else vVal := AQuery.Fields[i].Asstring;
            end;
            sMyVals := sMyVals + ',' + vVal;
          end;
        end;

      end;
      if (Alocation) then
        TS.add('INSERT INTO ' + ATableName + ' (' + copy(sMyFields, 2, length(sMyFields)) + ') SELECT GEN_ID(num_invlignes, 1)' + sMyVals + ' FROM RDB$DATABASE;')
      else
        TS.add('INSERT INTO ' + ATableName + ' (' + copy(sMyFields, 2, length(sMyFields)) + ') VALUES (' + copy(sMyVals, 2, length(sMyVals)) + ');');
      AQuery.Next;

      // Un commit work toutes les x lignes (constante déclarée plus haut : NbLigAvCommitWork)
      if (j mod NbLigAvCommitWork = 0) then
      begin
        TS.add('COMMIT WORK;');
      end;

      // A la fin de chaque page, ou à la fin du fichier, on sauve
      if (j mod NbLigMaxParFichier = 0) or (AQuery.Eof) then
      begin
        inc(iNumPage);

        // on remet j à 0
        j := 0;

        // Construction du nom de fichier sous la forme NomDuFichierRequete_Num.csvs
        // Le num est composé de 4 chiffres 0001, 0002, 0010 etc... Afin de permettre un tri sur le nom du fichier
        sFileName := ChangeFileExt(AFileNameToExport, '_' + format('%.4d', [iNumPage]) + ExtractFileExt(AFileNameToExport));
        if not (SaveQueryToFileSaveFile(TS, sFileName)) then
        begin
          // erreur
          result := false;
        end;

      end;
    end;
  except
    on E: exception do
    begin
      LogAction('**   --> : Exception : ' + StringReplace(E.Message, #13#10, ' | ', [rfReplaceAll]) + ' **');
//      LogAction(' k : ' + inttostr(k));
      // Erreur lors du parcours de la requete
      result := false;
    end;
  end;
  if TS <> nil then TS.free;
  AQuery.Close;
//  LogAction(' k : ' + inttostr(k));
end;

function SaveQueryToFileSaveFile(var ATString: TStringList; AFileNameToExport: string): boolean;
begin

  LogAction('** Export fichier : ' + ExtractFileName(AFileNameToExport) + ' **');
  try
    ForceDirectories(ExtractFilePath(AFileNameToExport));
    // Svg dans le fichier teste
    ATString.SaveToFile(AFileNameToExport);
    // Clear de la stringlist
    ATString.Clear;

    // ajouté pour essaie, semble que cela soit inutile finalement...
    {    ATString.Free;
    ATString := TStringList.Create;}

    LogAction('**   --> : OK **');

    // Ok, ca s'est bien passé
    Result := True;

  except
    on E: Exception do
    begin
      Result := False;
//      LogAction('** Erreur : Export fichier : ' + ExtractFileName(AFileNameToExport) + ' **');
      LogAction('**   --> : Exception : ' + StringReplace(E.Message, #13#10, ' | ', [rfReplaceAll]) + ' **');
    end;
  end;
end;


procedure GetPlage(AQuery: TIBQuery; ASQLExec: TIBSQL; AInv_ID: integer; var ADebutPlage, AFinPlage: Integer);
var
  sFileCreate, sFileExec, sFileDrop: string;
begin
  ADebutPlage := -1;
  AFinPlage := -1;

  // Utilisation de variable string pour plus de lisibilité
  sFileCreate := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) + 'Scripts\01-Verif\01_CREATE_PROCEDURE_TEMPO.sql';
  sFileExec := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) + 'Scripts\01-Verif\02_SELECT_MIN_MAX.SQL';
  sFileDrop := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) + 'Scripts\01-Verif\03_DROP_PROCEDURE_TEMPO.SQL';

  // Delete la procédure
  ASQLExec.SQL.LoadFromFile(sFileDrop);
  try
    if NOT ASQLExec.Transaction.Active then
      ASQLExec.Transaction.StartTransaction;

    ASQLExec.ExecQuery;
    ASQLExec.Transaction.Commit;
  except
    on E: Exception do
    begin
      ASQLExec.Transaction.Rollback;
    end;
  end;
  ASQLExec.Close;

  // Crée la procédure
  LogAction('** Création procédure FC_TEMPO_GET_ID_INVENTAIRES **');
  ASQLExec.SQL.LoadFromFile(sFileCreate);
  try
    if NOT ASQLExec.Transaction.Active then
      ASQLExec.Transaction.StartTransaction;

    ASQLExec.ExecQuery();
    ASQLExec.Transaction.Commit;
    LogAction('**   --> : OK **');
  except
    on E: Exception do
    begin
      ASQLExec.Transaction.Rollback;
      LogAction('**   --> : Exception : ' + StringReplace(E.Message, #13#10, ' | ', [rfReplaceAll]) + ' **');
    end;
  end;
  ASQLExec.Close;


  // Recup des deux valeurs
  LogAction('** Récupération de la plage **');
  AQuery.SQL.LoadFromFile(sFileExec);
  try
    AQuery.Open;

    // Dans le 1 le plus petit, dans le 2 le plus grand
    ADebutPlage := Min(AQuery.Fields[0].asinteger, AQuery.Fields[1].asinteger);
    AFinPlage := Max(AQuery.Fields[0].asinteger, AQuery.Fields[1].asinteger);
    AQuery.Transaction.Rollback;;
    LogAction('**   --> : OK **');
  except
    on E: Exception do
    begin
      AQuery.Transaction.Rollback;;
      LogAction('**   --> : Exception : ' + E.Message + ' **');
    end;
  end;
  AQuery.Close;

  LogAction('** Suppression procédure FC_TEMPO_GET_ID_INVENTAIRES**');
  ASQLExec.SQL.LoadFromFile(sFileDrop);
  try
    if NOT ASQLExec.Transaction.Active then
      ASQLExec.Transaction.StartTransaction;

    ASQLExec.ExecQuery;
    ASQLExec.Transaction.Commit;
    LogAction('**   --> : OK **');
  except
    on E: Exception do
    begin
      ASQLExec.Transaction.Rollback;
      LogAction('**   --> : Exception : ' + StringReplace(E.Message, #13#10, ' | ', [rfReplaceAll]) + ' **');
    end;
  end;
  ASQLExec.Close;

end;

function RecalcSTC_ID(AQuery: TIBQuery; ASQLExec: TIBSQL; AMag_Id: integer): boolean;
var
  sFileCreate, sFileExec, sFileDrop: string;
  bAllWasOk: boolean;
begin
  bAllWasOk := true;
  // Utilisation de variable string pour plus de lisibilité
  sFileCreate := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) + 'Scripts\03-Recalc\01-PROC_FC_INV_STCID.sql';
  sFileDrop := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) + 'Scripts\03-Recalc\05-DROP-PROC.SQL';


  // Delete la procédure
  ASQLExec.SQL.LoadFromFile(sFileDrop);
  try
    if NOT ASQLExec.Transaction.Active then
      ASQLExec.Transaction.StartTransaction;

    ASQLExec.ExecQuery;
    ASQLExec.Transaction.Commit;
  except
    on E: Exception do
    begin
      ASQLExec.Transaction.Rollback;
//      LogAction('**   --> : Exception : ' + StringReplace(E.Message, #13#10, ' | ', [rfReplaceAll]) + ' **');
    end;
  end;
  ASQLExec.Close;

  // Crée la procédure
  LogAction('** Création procédure FC_INV_STCID **');
  ASQLExec.SQL.LoadFromFile(sFileCreate);
  try
    if NOT ASQLExec.Transaction.Active then
      ASQLExec.Transaction.StartTransaction;

    ASQLExec.ExecQuery;
    ASQLExec.Transaction.Commit;
    LogAction('**   --> OK **');
  except
    on E: Exception do
    begin
      ASQLExec.Transaction.Rollback;
      LogAction('**   --> : Exception : ' + E.Message + ' **');
      bAllWasOk := false;
    end;
  end;
  ASQLExec.Close;


  // Recalcul de EnteteL
  LogAction('** Recalcul de STC_ID dans InvEnteteL... **');
  sFileExec := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) + 'Scripts\03-Recalc\02-Recalcul_EnteteL.sql';
  AQuery.SQL.LoadFromFile(sFileExec);
  try
    AQuery.ParamByName('MAG_ID').AsInteger := AMag_ID;
    if NOT AQuery.Transaction.Active then
      AQuery.Transaction.StartTransaction;

    AQuery.ExecSQL;
    LogAction('**   --> OK **');
    AQuery.Transaction.Commit;
  except
    on E: Exception do
    begin
      AQuery.Transaction.Rollback;
      LogAction('**   --> : Exception : ' + StringReplace(E.Message, #13#10, ' | ', [rfReplaceAll]) + ' **');
      bAllWasOk := false;
    end;
  end;
  AQuery.Close;

  // Recalcul de SessionL
  LogAction('** Recalcul de STC_ID dans InvSessionL... **');
  sFileExec := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) + 'Scripts\03-Recalc\03-Recalcul_SESSIONL.sql';
  AQuery.SQL.LoadFromFile(sFileExec);
  try
    AQuery.ParamByName('MAG_ID').AsInteger := AMag_ID;
    if NOT AQuery.Transaction.Active then
      AQuery.Transaction.StartTransaction;

    AQuery.ExecSQL;
    LogAction('**   --> : OK **');
    AQuery.Transaction.Commit;
  except
    on E: Exception do
    begin
      AQuery.Transaction.Rollback;
      LogAction('**   --> : Exception : ' + StringReplace(E.Message, #13#10, ' | ', [rfReplaceAll]) + ' **');
      bAllWasOk := false;
    end;
  end;
  AQuery.Close;

  LogAction('** Recalcul de STC_ID dans InvImgStk... **');
  sFileExec := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) + 'Scripts\03-Recalc\04-Recalcul_IMGSTK.sql';
  // Recalcul de ImgStock
  AQuery.SQL.LoadFromFile(sFileExec);
  try
    AQuery.ParamByName('MAG_ID').AsInteger := AMag_ID;
    if NOT AQuery.Transaction.Active then
      AQuery.Transaction.StartTransaction;

    AQuery.ExecSQL;
    AQuery.Transaction.Commit;
    LogAction('**   --> : OK **');
  except
    on E: Exception do
    begin
      AQuery.Transaction.Rollback;
      LogAction('**   --> : Exception : ' + StringReplace(E.Message, #13#10, ' | ', [rfReplaceAll]) + ' **');
      bAllWasOk := false;
    end;
  end;
  AQuery.Close;

  // Re Drop la procédure
  LogAction('** Suppression procédure FC_INV_STCID **');
  ASQLExec.SQL.LoadFromFile(sFileDrop);
  try
    if NOT ASQLExec.Transaction.Active then
      ASQLExec.Transaction.StartTransaction;

    ASQLExec.ExecQuery;
    ASQLExec.Transaction.Commit;
    LogAction('**   --> : OK **');
  except
    on E: Exception do
    begin
      ASQLExec.Transaction.Rollback;
      LogAction('**   --> : Exception : ' + StringReplace(E.Message, #13#10, ' | ', [rfReplaceAll]) + ' **');
      bAllWasOk := false;
    end;
  end;
  ASQLExec.Close;
  result := bAllWasOk;

end;

function SetGenerators(AQuery: TIBQuery; ASQLExec: TIBSQL; AInv_Id: integer): boolean;

var
  sChrono: string;
  sNumGen: string;
  bAllWasOk: boolean;
  iPlageDeb, iPlageFin: integer;
begin
  bAllWasOk := True;


  // recuperer l'id max de ce qu'on vient d'inserer. -> get plage
  GetPlage(AQuery, ASQLExec, AInv_id, iPlageDeb, iPlageFin);

  if iPlageFin > 0 then
  begin
    // 1 - INVLIGNES
    LogAction('** Set du generateur de NUM_INVLIGNES (' + inttostr(iPlageFin) + ') **');

    // Set du generateur
    ASQLExec.SQL.Text := 'SET GENERATOR NUM_INVLIGNES TO ' + inttostr(iPlageFin);
    try
      if NOT ASQLExec.Transaction.Active then
        ASQLExec.Transaction.StartTransaction;
      ASQLExec.ExecQuery;
      ASQLExec.Transaction.Commit;
      LogAction('**   --> : OK **');
    except
      on E: Exception do
      begin
        ASQLExec.Transaction.Rollback;
        LogAction('**   --> : Exception : ' + StringReplace(E.Message, #13#10, ' | ', [rfReplaceAll]) + ' **');
        bAllWasOk := false;
      end;
    end;
    ASQLExec.Close;
  end
  else
  begin
    bAllWasOk := false;
  end;

  // Récupération des chronos actuels
  // 2 - sur INVENTETE
  LogAction('** Récupération du chrono de INVENTETE **');
  AQuery.SQL.Text := 'SELECT max(inv_chrono) FROM inventete';
  try
    if NOT AQuery.Transaction.Active then
      AQuery.Transaction.StartTransaction;

    AQuery.Open;
    AQuery.First;
    sChrono := AQuery.Fields[0].asstring;
    AQuery.Transaction.commit;
    if sChrono <> '' then
    begin
      // Double conversion pour vérifier que c'est un entier qui ressort
      sNumGen := inttostr(strtoint(copy(sChrono, Pos('-', sChrono) + 1, length(sChrono))));
      LogAction('**   --> : OK **');
      LogAction('** Set du generateur de NUM_INVENTETE (' + sNumGen + ') **');
      // Set du generateur
      ASQLExec.SQL.Text := 'SET GENERATOR NUM_INVENTETE TO ' + sNumGen;
      try
       if NOT ASQLExec.Transaction.Active then
          ASQLExec.Transaction.StartTransaction;

        ASQLExec.ExecQuery;
        ASQLExec.Transaction.Commit;
        LogAction('**   --> : OK **');
      except
        on E: Exception do
        begin
          ASQLExec.Transaction.Rollback;
          LogAction('**   --> : Exception : ' + StringReplace(E.Message, #13#10, ' | ', [rfReplaceAll]) + ' **');
          bAllWasOk := false;
        end;
      end;
      ASQLExec.Close;
    end
    else
    begin
      bAllWasOk := false;
    end;
  except
    on E: Exception do
    begin
      AQuery.Transaction.Rollback;
      LogAction('**   --> : Exception : ' + StringReplace(E.Message, #13#10, ' | ', [rfReplaceAll]) + ' **');
      bAllWasOk := false;
    end;
  end;
  AQuery.Close;

  // 3 - sur INVSESSION
  LogAction('** Récupération du chrono de INVSESSION **');
  AQuery.SQL.Text := 'SELECT max(sai_chrono) FROM invsession';
  try
    if NOT AQuery.Transaction.Active then
      AQuery.Transaction.StartTransaction;

    AQuery.Open;
    AQuery.First;
    sChrono := AQuery.Fields[0].asstring;
    AQuery.Transaction.Commit;
    if sChrono <> '' then
    begin
      // Double conversion pour vérifier que c'est un entier qui ressort
      sNumGen := inttostr(strtoint(copy(sChrono, Pos('-', sChrono) + 1, length(sChrono))));
      LogAction('**   --> : OK **');
      LogAction('** Set du generateur de NUM_INVSESSION (' + sNumGen + ') **');

      // Set du generateur
      ASQLExec.SQL.Text := 'SET GENERATOR NUM_INVSESSION TO ' + sNumGen;
      try
        if NOT ASQLExec.Transaction.Active then
          ASQLExec.Transaction.StartTransaction;

        ASQLExec.ExecQuery;
        ASQLExec.Transaction.Commit;
        LogAction('**   --> : OK **');
      except
        on E: Exception do
        begin
          ASQLExec.Transaction.Rollback;
          LogAction('**   --> : Exception : ' + StringReplace(E.Message, #13#10, ' | ', [rfReplaceAll]) + ' **');
          bAllWasOk := false;
        end;
      end;
      ASQLExec.Close;
    end
    else
    begin
      bAllWasOk := false;
    end;
  except
    on E: Exception do
    begin
      AQuery.Transaction.Rollback;
      LogAction('**   --> : Exception : ' + StringReplace(E.Message, #13#10, ' | ', [rfReplaceAll]) + ' **');
      bAllWasOk := false;
    end;
  end;
  AQuery.Close;

  result := bAllWasOk;
end;


function ScriptExecute(ASQLExec: TIBSQL; AFile: string): boolean;
var
  sFile: string;
begin
  sFile := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) + AFile;
  // Exécution du script
  LogAction('** Exécution script ' + Afile + ' **');
  ASQLExec.SQL.LoadFromFile(sFile);
  try
    if NOT ASQLExec.Transaction.Active then
      ASQLExec.Transaction.StartTransaction;

    ASQLExec.ExecQuery;
    ASQLExec.Transaction.Commit;
    LogAction('**   --> : OK **');
    result := true
  except
    on E: Exception do
    begin
      ASQLExec.Transaction.Rollback;
      LogAction('**   --> : Exception : ' + StringReplace(E.Message, #13#10, ' | ', [rfReplaceAll]) + ' **');
      result := false
    end;
  end;
  ASQLExec.Close;
end;

end.

