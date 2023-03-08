//$Log:
// 12   Utilitaires1.11        04/06/2019 17:51:03    Florian Louis  
//      Correction de la gestion des dates dans GENVERSION
// 11   Utilitaires1.10        08/11/2018 11:21:25    Ludovic MASSE   test
//      am?lioration pour ne plus corrompre les bases
// 10   Utilitaires1.9         10/08/2018 18:14:52    Sylvain CORBELETTA
//      Modification pour pouvoir appliquer ou non une <RELEASE>... suivant le
//      type de r?plication de la base de donn?e
// 9    Utilitaires1.8         10/03/2017 12:28:42    Sylvain CORBELETTA
//      Recommit pour assignement au bon CR
//      Comment d'origine :
//      Suite erreur al?atoire
//      Il manquait des DBReconnect lors de :
//        - Cr?ation des valeurs par d?faut
//        - statistics
//        - Update du K ? 0
// 8    Utilitaires1.7         10/03/2017 12:27:05    Sylvain CORBELETTA Suite
//      erreur al?atoire
//      Il manquait des DBReconnect lors de :
//        - Cr?ation des valeurs par d?faut
//        - statistics
//        - Update du K ? 0
// 7    Utilitaires1.6         06/03/2017 10:06:41    Gilles Riand    Erreur
//      al?atoire dans Script.exe : erreur de connexion : on tente 3 fois
// 6    Utilitaires1.5         11/10/2013 15:38:43    Gr?gory BEN HAMZA Ajout
//      des logs
// 5    Utilitaires1.4         13/06/2013 15:11:42    Python Benoit   Code
//      retour + refresh
// 4    Utilitaires1.3         19/04/2013 15:20:39    Thierry Fleisch Version
//      12.1.0.1 : Modification du texte d'affichage de r?g?n?ration du K 
// 3    Utilitaires1.2         19/04/2013 12:23:31    Thierry Fleisch
//      Modification de l'activation/d?sactivation des index K_1 en mettant un
//      Set Statistic ? la place
// 2    Utilitaires1.1         17/04/2013 12:29:36    Thierry Fleisch Ajout de
//      la gestion du Set Statistic
//      Modification de l'affichage de la version du logiciel
// 1    Utilitaires1.0         04/05/2012 12:09:46    Christophe HENRAT 
//$
//$NoKeywords$
//

//------------------------------------------------------------------------------
// Nom de l'unité :   UnitfMain
// Rôle           :   Unité principale
// Auteur         :   Laurent BERNE
// Historique     :
// 26/11/2001     :   Création
// 27/11/2001     : Pascal - Corrections et amélioration
//------------------------------------------------------------------------------

UNIT UnitfMain;

INTERFACE

USES
    Umapping,
    Windows,
    Messages,
    SysUtils,
    // Variants,
    Classes,
    Graphics,
    Controls,
    Forms,
    Dialogs,
    DB,
    jpeg,
    ExtCtrls,
    StdCtrls,
    Math,
    Registry,
    Inifiles,
    erreur_frm,
    ComCtrls,
    RzLabel,
    uVersion, uLog, IBQuery;

TYPE
    TReplicationType = (rtAll, rtDelos, rtEasy);

    TComparedRelease = (crLower, crEqual, crHigher);
    TfMain = CLASS(TForm)
        Image1: TImage;
        Label1: TLabel;
        ListView1: TListView;
        Button1: TButton;
        Lab_EnCours: TRzLabel;
        Button2: TButton;
        Timer1: TTimer;
        Button3: TButton;
        OD: TOpenDialog;

        PROCEDURE FormActivate(Sender: TObject);
        PROCEDURE Button1Click(Sender: TObject);
        PROCEDURE Button2Click(Sender: TObject);
        PROCEDURE Timer1Timer(Sender: TObject);
        PROCEDURE FormCreate(Sender: TObject);
        PROCEDURE FormDestroy(Sender: TObject);
        PROCEDURE Button3Click(Sender: TObject);
        PROCEDURE FormCloseQuery(Sender: TObject; VAR CanClose: Boolean);
    PRIVATE
    { Déclarations privées }
        fermeture: boolean;
        LesRelease: TStringlist;
        GNKRelease: STRING;
        ScriptFileName: STRING;
        LABase0: STRING;
        FPrmAuto : boolean;
        FPrmAuto1 : boolean;
        FPrmBase : boolean;
        FPrmUneBase : boolean;
        FPrmManu : boolean;
        // FUNCTION CompareRelease ( AOld, ANew: STRING ) : TComparedRelease;
        // FUNCTION GetScript ( Release: STRING ) : STRING;
        // FUNCTION GetNeededReleases ( OldRelease: STRING ) : TStringlist;
        PROCEDURE GetNeededReleases(aReplicationType: TReplicationType);

        function GetBaseReplicationType: TReplicationType;

        FUNCTION UpgradeDataBase(FileName: STRING): boolean;
        procedure DBDisconnect(const aNumRelease:string='');
        procedure DBConnect(const aNumRelease:string='');
        procedure DBReConnect(const aNumRelease:string='');
        procedure AddToLogs(aLog : string; aLvl : TlogLevel = logInfo);
        procedure SaveQuery(aQryText : String);
    PUBLIC
    { Déclarations publiques }

    END;

VAR
    fMain: TfMain;

IMPLEMENTATION

USES UnitdmMainModule;

{$R *.dfm}

PROCEDURE TfMain.FormActivate(Sender: TObject);

VAR
  DataPathName: STRING;
  Registry: TRegistry;
  GNKIni: TIniFile;
  BufferValue: STRING;
  BufferPath: STRING;
  incrementBufferValue: integer;
  BufferListItem: TListItem;

BEGIN
  LABase0 := '';
  ScriptFileName := ExtractFileDir(Application.ExeName);
  IF ScriptFileName[length(ScriptFileName)] <> '\' THEN
      ScriptFileName := ScriptFileName + '\';
  ScriptFileName := ScriptFileName + 'script.scr';
  // code pour simuler la connexion à Ginkoia.gdb
  GNKRelease := '0.0.0.1';
  Registry := TRegistry.Create();
  Registry.RootKey := HKEY_LOCAL_MACHINE;
  Registry.OpenKey('Software\Algol\Ginkoia', False);
  LABase0 := Registry.ReadString('Base0');
  Registry.free;

  DataPathName := LABase0;
  IF DataPathName <> '' THEN
  BEGIN
    DataPathName := ExcludeTrailingBackslash(ExtractFilePath(DataPathName));
    WHILE DataPathName[length(DataPathName)] <> '\' DO
      delete(DataPathName, length(DataPathName), 1);
  END;
  DataPathName := IncludeTrailingBackslash(DataPathName);
  IF NOT fileexists(DataPathName + 'Ginkoia.ini') THEN
    DataPathName := IncludeTrailingBackslash(extractfilepath(application.exename));
  IF NOT fileexists(DataPathName + 'Ginkoia.ini') THEN
    DataPathName := 'C:\Ginkoia\';
  IF NOT fileexists(DataPathName + 'Ginkoia.ini') THEN
    DataPathName := 'D:\Ginkoia\';


  FPrmAuto := (ParamCount > 0) AND (Uppercase(ParamStr(1)) = 'AUTO');
  FPrmAuto1 := (ParamCount > 0) AND (Uppercase(ParamStr(1)) = 'AUTO1');
  FPrmBase := (ParamCount > 0) AND (Uppercase(ParamStr(1)) = 'BASE');
  FPrmUneBase := (ParamCount > 0) AND (Uppercase(ParamStr(1)) = 'UNEBASE');
  FPrmManu := (ParamCount > 0) AND (Uppercase(ParamStr(1)) = 'MANU');

  if FPrmAuto then AddToLogs('Param:Auto');
  if FPrmAuto1 then AddToLogs('Param:Auto1');
  if FPrmBase then AddToLogs('Param:Base');
  if FPrmUneBase then AddToLogs('Param:UneBase');;
  if FPrmManu then AddToLogs('Param:Manu');
  AddToLogs('Base0:' + LABase0);

  IF FPrmUneBase THEN
  BEGIN
    BufferListItem := ListView1.Items.Add;
    BufferListItem.Caption := ParamStr(2);
    ListView1.Items[ListView1.Items.count - 1].Checked := true;
  END
  ELSE IF FPrmBase THEN
  BEGIN
    DBDisconnect('');
    dmMainModule.IBDatabase1.DatabaseName := LABase0;
    DBConnect('');
    dmMainModule.QUE_LESBASES.Open;
    dmMainModule.QUE_LESBASES.First;
    WHILE NOT dmMainModule.QUE_LESBASES.EOF DO
    BEGIN
      BufferListItem := ListView1.Items.Add;
      BufferListItem.Caption := dmMainModule.QUE_LESBASESREP_PLACEBASE.AsString;
      ListView1.Items[ListView1.Items.count - 1].Checked := true;
      dmMainModule.QUE_LESBASES.Next;
    END;
    dmMainModule.QUE_LESBASES.Close;
    dmMainModule.IBDatabase1.Close;
  END
  ELSE
  BEGIN
    GNKIni := TIniFile.Create(DataPathName + 'Ginkoia.ini');
    IncrementBufferValue := 0;
    REPEAT
      BufferValue := 'PATH' + inttostr(incrementBufferValue);
      BufferPath := GNKIni.ReadString('DATABASE', 'PATH' + inttostr(incrementBufferValue), 'Error');
      inc(IncrementBufferValue);
      IF BufferPath <> 'Error' THEN
      BEGIN
        BufferListItem := ListView1.Items.Add();
        BufferListItem.Caption := BufferPath;
        IF FPrmAuto or FPrmAuto1 THEN
          ListView1.Items[ListView1.Items.count - 1].Checked := true;
      END;
    UNTIL IncrementBufferValue > 10;
  END;
  IF (FPrmAuto OR FPrmAuto1 OR FPrmBase OR FPrmUneBase) THEN
  BEGIN
    Timer1.enabled := true;
  END
  ELSE IF FPrmManu THEN
  BEGIN
    button3.visible := true;
  END
END;

FUNCTION TransformRelease(Release: STRING): STRING;
VAR
    S1, S2, S3, S4: STRING;
BEGIN
  if Pos('<', Release) > 0 then
    Release := Copy( Release, 0, Pos('<', Release) - 1 );

  IF trim(Release) = '' THEN Release := '0.0.0.0';
  S1 := trim(Copy(Release, 1, Pos('.', Release) - 1));
  delete(Release, 1, Pos('.', Release));
  WHILE length(S1) < 5 DO S1 := '0' + S1;
  S2 := trim(Copy(Release, 1, Pos('.', Release) - 1));
  delete(Release, 1, Pos('.', Release));
  WHILE length(S2) < 5 DO S2 := '0' + S2;
  S3 := trim(Copy(Release, 1, Pos('.', Release) - 1));
  delete(Release, 1, Pos('.', Release));
  WHILE length(S3) < 5 DO S3 := '0' + S3;
  S4 := trim(Release);
  WHILE length(S4) < 5 DO S4 := '0' + S4;
  Result := s1 + '.' + s2 + '.' + s3 + '.' + s4;
END;

FUNCTION ReleaseVisu(Release: STRING): STRING;
VAR
    S1, S2, S3, S4: STRING;
BEGIN
  IF trim(Release) = '' THEN Release := '0.0.0.0';
  S1 := trim(Copy(Release, 1, Pos('.', Release) - 1));
  delete(Release, 1, Pos('.', Release));
  WHILE (length(S1) > 1) AND (S1[1] = '0') DO delete(S1, 1, 1);
  S2 := trim(Copy(Release, 1, Pos('.', Release) - 1));
  delete(Release, 1, Pos('.', Release));
  WHILE (length(S2) > 1) AND (S2[1] = '0') DO delete(S2, 1, 1);
  S3 := trim(Copy(Release, 1, Pos('.', Release) - 1));
  delete(Release, 1, Pos('.', Release));
  WHILE (length(S3) > 1) AND (S3[1] = '0') DO delete(S3, 1, 1);
  S4 := trim(Release);
  WHILE (length(S4) > 1) AND (S4[1] = '0') DO delete(S4, 1, 1);
  Result := s1 + '.' + s2 + '.' + s3 + '.' + s4;
END;

function TfMain.GetBaseReplicationType: TReplicationType;
begin
  Result := rtDelos;

  dmMainModule.IBQue_EasyDataBase.Open;

  try
    if (not dmMainModule.IBQue_EasyDataBase.IsEmpty) and (dmMainModule.IBQue_EasyDataBase.FieldByName('PRM_STRING').asString <> '') then
    begin
      Result := rtEasy;
    end;
  finally
    dmMainModule.IBQue_EasyDataBase.Close;
  end;
end;

PROCEDURE TfMain.GetNeededReleases(aReplicationType: TReplicationType);
VAR
  ThisFile: TextFile;
  // Releases: TStringList;
  Buffer: STRING;
  Release: STRING;

  LaStringList: TstringList;

  function ReleaseReplicationType(Release: string): TReplicationType;
  begin
    if Pos('<EASY>', Release) > 0 then
      Result := rtEasy
    else if Pos('<DELOS>', Release) > 0 then
      Result := rtDelos
    else
      Result := rtAll;
  end;

BEGIN
  LesRelease := TStringlist.Create;
  LaStringList := NIL;

  AssignFile(ThisFile, ScriptFileName);

  Reset(thisfile);
  WHILE NOT Eof(ThisFile) DO
  BEGIN
    ReadLn(ThisFile, Buffer);
    IF Pos('<RELEASE>', Buffer) > 0 THEN
    BEGIN
      LaStringList := TstringList.Create;

      if ReleaseReplicationType(Buffer) in [rtAll, aReplicationType] then
      begin
        Release := TransformRelease(Copy(Buffer, 10, 255));
        LesRelease.AddObject(Release, LaStringList);
      end
      else
      begin
        AddToLogs(Format('RELEASE %s ignore cause of base replication type', [Buffer]));
      end;
    END
    ELSE
      LaStringList.Add(Buffer);
  END;
  CloseFile(thisfile);

    // Result := Releases;
END;

procedure TfMain.SaveQuery(aQryText: String);
  function MyWrapText(S : string; Chars : integer) : TStringList;
  var
    StringList : TStringList;
    hs : string;
    P, Line : integer;
  begin
    StringList := TStringList.Create;
    StringList.Clear;
    Line := 0;
    S := S + ' ';
    if Length(S) = 0 then
      Exit;
    StringList.Add('');
    P := Pos(' ', S);
    while P <> 0 do
    begin
      hs := Copy(S, 1, P);
      if (Length(StringList.Strings[Line]) + Length(hs)) < (Chars + 1) then
        StringList.Strings[Line] := StringList.Strings[Line] + hs
      else
      begin
        StringList.Add(hs);
        Line := Line + 1;
      end;
      Delete(S, 1, P);
      P := Pos(' ', S);
    end;
    Result := StringList;
  end;
var
  i : integer;
  sl : TStringList;
begin
  // opti
  text := aQryText;
  try
    sl := MyWrapText(text, 250);
    for I := 0 to sl.Count - 1 do
      AddToLogs(sl.Strings[i]);
  finally
    FreeAndNil(sl);
  end;
end;

procedure TfMain.AddToLogs(aLog: string; aLvl: TlogLevel);
begin
  Log.Log('Script', 'Log', aLog, aLvl, false, -1, ltLocal) ;
end;

PROCEDURE TfMain.Button1Click(Sender: TObject);
VAR
    DataBaseList: TStringList;
    IncrementListView: integer;
//    ok: Boolean;
BEGIN
  // executer
  AddToLogs(Self.Name + '.Button1Click : Started');
  MapGinkoia.Script := true;
  MapGinkoia.ScriptOK := true;
  TRY
    DataBaseList := TStringList.Create();
    TRY
      FOR IncrementListView := 0 TO ListView1.Items.Count - 1 DO
      BEGIN
        IF ListView1.Items.Item[IncrementListView].Checked THEN
        BEGIN
          DataBaseList.Add(ListView1.Items[IncrementListView].Caption);
          // ok :=
          IF NOT UpgradeDataBase(DataBaseList.Strings[DataBaseList.Count - 1]) THEN
          BEGIN
            MapGinkoia.ScriptOK := FALSE;
            ExitCode := 1;
            AddToLogs(ListView1.Items[IncrementListView].Caption + ' : NOK', logError);
          END
          else
            AddToLogs(ListView1.Items[IncrementListView].Caption + ' : OK');
          IF fermeture THEN Exit;
          ListView1.Items.Item[IncrementListView].Checked := false;
          ListView1.Update;
        END;
      END;
    FINALLY
      DataBaseList.Free;
    END;
  FINALLY
    MapGinkoia.Script := false;
    AddToLogs(Self.Name + '.Button1Click : Terminate');
    IF (FPrmAuto1 OR FPrmBase OR FPrmUneBase) THEN
    begin
      AddToLogs('Auto close');
      Close;
    end
    ELSE
    BEGIN
      MessageBox(Handle, 'La mise à jour est terminée', 'Fin du traitement', MB_OK OR MB_ICONEXCLAMATION);
      IF FPrmAuto THEN
        Close;
    END;
  END;

END;

procedure TfMain.DBDisconnect(const aNumRelease:string='');
var
  i:Integer;
begin
  AddToLogs('Try Disconnect:'+aNumRelease);
  try
    i:=0;
    while (dmMainModule.IBDatabase1.Connected) and (i<3) do
    begin
      if i>0 then
      begin
        Sleep(15);
        AddToLogs('DBDisconnect:N' + IntToStr(i) + ' Release='+aNumRelease);
      end;
      try
        dmMainModule.IBDatabase1.Close;
        AddToLogs('Disconnect OK('+dmMainModule.IBDatabase1.DatabaseName+'):'+aNumRelease);
      Except
        On E:Exception
        do AddToLogs('DBDisconnect:Close ' + E.Message, logError);
      end;
      inc(i);
    end;
  Except
    on E:Exception do
    begin
      AddToLogs('DBDisconnect:Block ' + E.Message, logError);
    end;
  end;
end;

procedure TfMain.DBConnect(const aNumRelease:string='');
var
  i:integer;
begin
  AddToLogs('Try Connect:'+aNumRelease);
  try
    i:=0;
    while not(dmMainModule.IBDatabase1.Connected) and (i<3) do
    begin
      if i>0 then
      begin
        Sleep(15);
        AddToLogs('DBConnect:N' + IntToStr(i) + ' Release='+aNumRelease);
      end;
      try
        dmMainModule.IBDatabase1.open;
        if dmMainModule.IBDatabase1.Connected then
        AddToLogs('Connect OK('+dmMainModule.IBDatabase1.DatabaseName+'):'+aNumRelease);
      Except
        On E:Exception do
          AddToLogs('DBConnect:Open ' + E.Message, logError);
      end;
      Inc(i);
    end;
  Except
    on E:Exception do
    begin
      AddToLogs('DBConnect:Block ' + E.Message, logError);
    end;
  end;
end;

procedure TfMain.DBReConnect(const aNumRelease:string);
begin
  try
    dmMainModule.IBTransaction1.Active := False;
    dmMainModule.IBTransaction2.Active := False;
    DBDisconnect(aNumRelease);
    DBConnect(aNumRelease);
    if dmMainModule.IBDatabase1.Connected then
    begin
      dmMainModule.IBTransaction1.Active := true;
      dmMainModule.IBTransaction2.Active := true;
    end
    else raise Exception.Create('Erreur DBReConnect !');
  Except
    on E:Exception do
    begin
      Raise Exception.Create('DBReConnect ' + E.MEssage);
    end;
  end;
end;

FUNCTION TfMain.UpgradeDataBase(FileName: STRING): boolean;
VAR
  DataBaseRelease: STRING;
  DataBaseReleaseEx: STRING;

  // NeededReleases: TStringList;
  IncrementReleases: integer;

  GrantAFaire, GrantAFaire2, S, s2, S3: STRING;
  Num: Integer;
  ProcName: STRING;

  ContinueAuto: Boolean;

  toutOk: Boolean;
  NbInsertion: Integer;

  EstOk: Boolean;
  ii: integer;
  Pass: STRING;
  vReleaseVisu: String;

BEGIN

  IF Pos(':', FileName) > 2 THEN
  BEGIN
    result := true;
    exit;
  END;
  IF NOT FileExists(FileName) THEN
  BEGIN
    result := true;
    exit;
  END;

  ContinueAuto := False;
  fermeture := false;

  TRY
    Result := true;
    DBDisconnect;
    dmMainModule.IBDatabase1.DatabaseName := FileName;
    DBConnect;
    dmMainModule.IBTransaction1.Active := true;
    dmMainModule.IBTransaction2.Active := true;
  EXCEPT
    on E: Exception do
      begin
      AddToLogs(Self.Name + '.UpgradeDataBase (1) : FileName = ' + FileName + #13#10 +  E.Message, logError);

      IF FPrmAuto1 THEN
      BEGIN
        S := 'Impossible de ce connecter à la base ' + FileName;
        MessageBox(Handle, Pchar(S), 'Erreur', MB_OK OR MB_ICONSTOP);
        MapGinkoia.ScriptOK := False;
        RAISE;
      END
      ELSE
      BEGIN
        MapGinkoia.ScriptOK := False;
        MapGinkoia.ScriptErreur := 'Voir yyyy_mm_dd_script.log pour plus de détail';
        result := false;
        EXIT;
      END;
    end;
  END;

  { Si LesReleases est déjà assigné on le réinitialise pour qu'il soit regénéré avec le bon type de réplication
    de la BDD }
  if Assigned(LesRelease) then
  begin
    LesRelease.Clear;
    LesRelease.Free;
    LesRelease := nil;
  end;
  GetNeededReleases(GetBaseReplicationType);
  LesRelease.Sort;

  dmMainModule.IBQue_Insproc.Open;
  dmMainModule.IBQue_Insproc.First;
  WHILE NOT dmMainModule.IBQue_Insproc.Eof DO
  BEGIN
    dmMainModule.IBSQLDivers.Sql.Text := 'DROP PROCEDURE ' + trim(dmMainModule.IBQue_Insproc.Fields[0].AsString) + ';';
    dmMainModule.IBSQLDivers.ExecQuery;
    dmMainModule.IBQue_Insproc.Next;
  END;
  IF dmMainModule.IBSQLDivers.Transaction.InTransaction THEN
    dmMainModule.IBSQLDivers.Transaction.commit;

  dmMainModule.IBQueryTableExist.Active := true;
  IF dmMainModule.IBQueryTableExistCOUNT.Value = 0 THEN
  begin
    TRY
      dmMainModule.IBSQLCreateTableVersion.ExecQuery();
      dmMainModule.IBSQLCreateTableVersion.Transaction.Commit()
    EXCEPT
      on E: Exception do
      begin
        AddToLogs(Self.Name + '.UpgradeDataBase (2) : IBSQLCreateTableVersion.ExecQuery' + #13#10 +  E.Message, logError);
        SaveQuery(DmMainModule.IBSQLCreateTableVersion.SQL.Text);
        MapGinkoia.ScriptOK := False;
        MapGinkoia.ScriptErreur := 'Voir yyyy_mm_dd_script.log pour plus de détail';
        dmMainModule.IBSQLCreateTableVersion.Transaction.Rollback();
        IF (ParamCount > 0) AND (Uppercase(ParamStr(1)) = 'AUTO1') THEN
            MessageBox(Handle, 'Erreur pendant la création de la table', 'Erreur', MB_OK OR MB_ICONSTOP);
        result := false;
        exit;
      end;
    END;
  end;

// ouverture de la table de version et récupération du numéro de la version
  TRY
    dmMainModule.IBQueryRelease.Open();
    DataBaseRelease := dmMainModule.IBQueryRelease.FieldByName('VER_VERSION').AsString;
    IF DataBaseRelease = '' THEN
    BEGIN
      try
        dmMainModule.IBQueryGENPARAMBASE.Open();
      except
        SaveQuery(DmMainModule.IBQueryGENPARAMBASE.SQL.Text);
      end;
      DataBaseRelease := dmMainModule.IBQueryGENPARAMBASEPAR_STRING.AsString + '.9999';
    END;
  EXCEPT
    SaveQuery(DmMainModule.IBQueryRelease.SQL.Text);
    DataBaseRelease := '0.0.0.0';
  END;

  vReleaseVisu:= '';
  TRY
    DataBaseReleaseEx := TransformRelease(DataBaseRelease);
    IncrementReleases := 0;

    // Seek to current Database release
    WHILE (IncrementReleases < LesRelease.count) AND (LesRelease[IncrementReleases] <= DataBaseReleaseEx) DO
    begin
        Inc(IncrementReleases);
    end;

    IF IncrementReleases < LesRelease.count THEN
    BEGIN
      dmMainModule.IBQueryRelease.Active := true ;
      dmMainModule.IBQueryRelease.Insert ;
      dmMainModule.IBQueryRelease.FieldByName('VER_DATE').AsDateTime := Now ;
      dmMainModule.IBQueryRelease.FieldByName('VER_VERSION').AsString := DataBaseRelease ;
      dmMainModule.IBQueryRelease.Post ;

      WHILE IncrementReleases < LesRelease.Count DO
      BEGIN
        GrantAFaire := '';
        TRY
          Lab_EnCours.Caption := ReleaseVisu(LesRelease[IncrementReleases]);
          vReleaseVisu:= ReleaseVisu(LesRelease[IncrementReleases]);
          MapGinkoia.ScriptEnCours := FileName + ' ' + vReleaseVisu;
          Lab_EnCours.Update;
          Application.ProcessMessages();
          dmMainModule.IBSQLEngine.SQL.text := TstringList(LesRelease.Objects[IncrementReleases]).Text;
          IF Copy(Uppercase(trim(dmMainModule.IBSQLEngine.SQL.Text)), 1, 9) = 'DECONNECT' THEN
          BEGIN
            DBReConnect(vReleaseVisu);
            dmMainModule.IBSQLEngine.SQL.Text := '';
          END
          ELSE IF Copy(Uppercase(trim(dmMainModule.IBSQLEngine.SQL.Text)), 1, 8) = 'INSERT2 ' THEN
          BEGIN
            S := dmMainModule.IBSQLEngine.SQL.Text;
            delete(S, 1, 8);
            s2 := trim(Copy(S, 1, Pos('INTO', S) - 1));
            delete(S, 1, Pos('INTO', S) + 4);
            S3 := trim(Copy(S, 1, Pos('(', S) - 1));
            dmMainModule.IBQue_Insert2.Sql.Text := 'SELECT COUNT(*) FROM ' + S3 + ' WHERE ' + S2;
            dmMainModule.IBQue_Insert2.Open;
            IF dmMainModule.IBQue_Insert2.Fields[0].AsInteger = 0 THEN
            BEGIN
              dmMainModule.IBSQLEngine.SQL.Text := 'INSERT INTO ' + S;
              dmMainModule.IBSQLEngine.ExecQuery;
              S := dmMainModule.IBSQLEngine.SQL.Text;
              Delete(S, 1, Pos('VALUES', S));
              Delete(S, 1, Pos('(', S));
              S := trim(Copy(S, 1, Pos(',', S) - 1));
              dmMainModule.IBSQLEngine.SQL.Text := 'INSERT INTO K (K_ID, K_ENABLED) VALUES (' + S + ', 1) ;';
              dmMainModule.IBSQLEngine.ExecQuery;
            END;
            dmMainModule.IBQue_Insert2.Close;
            dmMainModule.IBSQLEngine.SQL.Text := '';
          END
          ELSE IF Copy(Uppercase(trim(dmMainModule.IBSQLEngine.SQL.Text)), 1, 11) = 'DROP TABLE ' THEN
          BEGIN
            ProcName := Copy(Uppercase(trim(dmMainModule.IBSQLEngine.SQL.Text)), 1, 11 + 255);
            delete(ProcName, 1, 11);
            ProcName := trim(ProcName);
            Num := Pos(' ', ProcName);
            IF Num = 0 THEN num := 9999;
            IF (Pos('(', ProcName) > 0) AND (Pos('(', ProcName) < Num) THEN
              num := Pos('(', ProcName);
            IF (Pos(#$D, ProcName) > 0) AND (Pos(#$D, ProcName) < Num) THEN
              num := Pos(#$D, ProcName);
            ProcName := Copy(ProcName, 1, Num - 1);
            dmMainModule.IBQue_ProcExist.ParamByName('NAME').AsString := 'INS_' + ProcName;
            dmMainModule.IBQue_ProcExist.Open;
            IF dmMainModule.IBQue_ProcExistCOUNT.AsInteger = 1 THEN
            BEGIN
              dmMainModule.IBSQLDivers.Sql.Text := 'DROP PROCEDURE INS_' + ProcName;
              dmMainModule.IBSQLDivers.ExecQuery;
              IF dmMainModule.IBSQLDivers.Transaction.InTransaction THEN
                dmMainModule.IBSQLDivers.Transaction.commit;
            END;
          END
          ELSE IF Copy(Uppercase(trim(dmMainModule.IBSQLEngine.SQL.Text)), 1, 12) = 'ALTER TABLE ' THEN
          BEGIN
                // Evitons les effet de bord deconnexion de la table
            IF dmMainModule.IBSQLDivers.Transaction.InTransaction THEN
              dmMainModule.IBSQLDivers.Transaction.commit;
            DBReConnect(vReleaseVisu);
            ProcName := Copy(Uppercase(trim(dmMainModule.IBSQLEngine.SQL.Text)), 1, 12 + 255);
            delete(ProcName, 1, 12);
            ProcName := trim(ProcName);
            Num := Pos(' ', ProcName);
            IF Num = 0 THEN num := 9999;
            IF (Pos('(', ProcName) > 0) AND (Pos('(', ProcName) < Num) THEN
              num := Pos('(', ProcName);
            IF (Pos(#$D, ProcName) > 0) AND (Pos(#$D, ProcName) < Num) THEN
              num := Pos(#$D, ProcName);
            ProcName := Copy(ProcName, 1, Num - 1);
            dmMainModule.IBQue_ProcExist.ParamByName('NAME').AsString := 'INS_' + ProcName;
            dmMainModule.IBQue_ProcExist.Open;
            IF dmMainModule.IBQue_ProcExistCOUNT.AsInteger = 1 THEN
            BEGIN
              dmMainModule.IBSQLDivers.Sql.Text := 'DROP PROCEDURE INS_' + ProcName;
              dmMainModule.IBSQLDivers.ExecQuery;
              IF dmMainModule.IBSQLDivers.Transaction.InTransaction THEN
                dmMainModule.IBSQLDivers.Transaction.commit;
            END;
          END
          ELSE IF Copy(Uppercase(trim(dmMainModule.IBSQLEngine.SQL.Text)), 1, 13) = 'CREATE TABLE ' THEN
          BEGIN
            ProcName := Copy(Uppercase(trim(dmMainModule.IBSQLEngine.SQL.Text)), 1, 13 + 255);
            delete(ProcName, 1, 13);
            ProcName := trim(ProcName);
            Num := Pos(' ', ProcName);
            IF Num = 0 THEN num := 9999;
            IF (Pos('(', ProcName) > 0) AND (Pos('(', ProcName) < Num) THEN
              num := Pos('(', ProcName);
            IF (Pos(#$D, ProcName) > 0) AND (Pos(#$D, ProcName) < Num) THEN
              num := Pos(#$D, ProcName);
            ProcName := Copy(ProcName, 1, Num - 1);

            dmMainModule.IBQue_ProcExist.ParamByName('NAME').AsString := ProcName;
            dmMainModule.IBQue_ProcExist.Open;
            IF dmMainModule.IBQue_ProcExistCOUNT.AsInteger > 0 THEN
            BEGIN
              dmMainModule.IBSQLEngine.SQL.Text := '';
              dmMainModule.IBQue_ProcExist.Close;
            END
            ELSE
            BEGIN
              dmMainModule.IBQue_ProcExist.Close;
              GrantAFaire := 'GRANT ALL ON ' + ProcName + ' TO GINKOIA';
              GrantAFaire2 := 'GRANT ALL ON ' + ProcName + ' TO REPL';
              dmMainModule.IBQue_ProcExist.ParamByName('NAME').AsString := 'INS_' + ProcName;
              dmMainModule.IBQue_ProcExist.Open;
              IF dmMainModule.IBQue_ProcExistCOUNT.AsInteger = 1 THEN
              BEGIN
                dmMainModule.IBSQLDivers.Sql.Text := 'DROP PROCEDURE INS_' + ProcName;
                dmMainModule.IBSQLDivers.ExecQuery;
                IF dmMainModule.IBSQLDivers.Transaction.InTransaction THEN
                  dmMainModule.IBSQLDivers.Transaction.commit;
              END;
            END;
          END
          ELSE IF Copy(Uppercase(trim(dmMainModule.IBSQLEngine.SQL.Text)), 1, 15) = 'DROP PROCEDURE ' THEN
          BEGIN
            ProcName := Copy(Uppercase(trim(dmMainModule.IBSQLEngine.SQL.Text)), 1, 15 + 255);
            delete(ProcName, 1, 15);
            ProcName := trim(ProcName);
            Num := Pos(' ', ProcName);
            IF Num = 0 THEN num := 9999;
            IF (Pos('(', ProcName) > 0) AND (Pos('(', ProcName) < Num) THEN
              num := Pos('(', ProcName);
            IF (Pos(';', ProcName) > 0) AND (Pos(';', ProcName) < Num) THEN
              num := Pos(';', ProcName);
            IF (Pos(#$D, ProcName) > 0) AND (Pos(#$D, ProcName) < Num) THEN
              num := Pos(#$D, ProcName);
            ProcName := Copy(ProcName, 1, Num - 1);
            dmMainModule.IBQue_ProcExist.ParamByName('NAME').AsString := ProcName;
            dmMainModule.IBQue_ProcExist.Open;
            IF dmMainModule.IBQue_ProcExistCOUNT.AsInteger < 1 THEN
            BEGIN
              dmMainModule.IBSQLEngine.SQL.Text := '';
            END ;
            dmMainModule.IBQue_ProcExist.Close ;
          END
          ELSE IF Copy(Uppercase(trim(dmMainModule.IBSQLEngine.SQL.Text)), 1, 17) = 'CREATE PROCEDURE ' THEN
          BEGIN
            ProcName := Copy(Uppercase(trim(dmMainModule.IBSQLEngine.SQL.Text)), 1, 17 + 255);
            delete(ProcName, 1, 17);
            ProcName := trim(ProcName);
            Num := Pos(' ', ProcName);
            IF Num = 0 THEN num := 9999;
            IF (Pos('(', ProcName) > 0) AND (Pos('(', ProcName) < Num) THEN
              num := Pos('(', ProcName);
            IF (Pos(#$D, ProcName) > 0) AND (Pos(#$D, ProcName) < Num) THEN
              num := Pos(#$D, ProcName);
            ProcName := Copy(ProcName, 1, Num - 1);
            dmMainModule.IBQue_ProcExist.ParamByName('NAME').AsString := ProcName;
            GrantAFaire := 'GRANT EXECUTE ON PROCEDURE ' + ProcName + ' TO GINKOIA';
            GrantAFaire2 := 'GRANT EXECUTE ON PROCEDURE ' + ProcName + ' TO REPL';
            dmMainModule.IBQue_ProcExist.Open;
            IF dmMainModule.IBQue_ProcExistCOUNT.AsInteger = 1 THEN
            BEGIN
              ProcName := dmMainModule.IBSQLEngine.SQL.Text;
              Num := Pos('CREATE', Uppercase(ProcName));
              Delete(ProcName, Num, 6);
              Insert('ALTER', ProcName, Num);
              dmMainModule.IBSQLEngine.SQL.Text := ProcName;

              ii := 0;
              dmMainModule.IBSQLDivers.Sql.Clear;
              WHILE ii < dmMainModule.IBSQLEngine.SQL.Count - 1 DO
              BEGIN
                PASS := TRIM(dmMainModule.IBSQLEngine.SQL[ii]);
                IF uppercase(PASS) = 'AS' THEN
                BEGIN
                  dmMainModule.IBSQLDivers.Sql.ADD('AS');
                  dmMainModule.IBSQLDivers.Sql.ADD('BEGIN');
                  dmMainModule.IBSQLDivers.Sql.ADD('EXIT ;');
                  dmMainModule.IBSQLDivers.Sql.ADD('END');
                  BREAK;
                END
                ELSE
                  dmMainModule.IBSQLDivers.Sql.ADD(PASS);
                inc(ii);
              END;

              dmMainModule.IBSQLDivers.ExecQuery;
              IF dmMainModule.IBSQLDivers.Transaction.InTransaction THEN
                dmMainModule.IBSQLDivers.Transaction.commit;
              DBReConnect(vReleaseVisu);
            END;
            dmMainModule.IBQue_ProcExist.CLose;
          END
          ELSE IF Copy(Uppercase(trim(dmMainModule.IBSQLEngine.SQL.Text)), 1, 13) = 'DROP TRIGGER ' THEN
          BEGIN
            ProcName := trim(dmMainModule.IBSQLEngine.SQL.Text);
            delete(ProcName, 1, length('DROP TRIGGER '));
            ProcName := trim(ProcName);
            IF Pos(';', ProcName) > 0 THEN
              procName := trim(Copy(procName, 1, Pos(';', ProcName) - 1));
            ProcName := Uppercase(ProcName);
            WHILE Pos('"', ProcName) > 0 DO
              delete(ProcName, Pos('"', ProcName), 1);
            estOk := False;
            dmMainModule.IBQue_TRIGGER.Open;
            dmMainModule.IBQue_TRIGGER.first;
            WHILE NOT dmMainModule.IBQue_TRIGGER.EOF DO
            BEGIN
              IF Uppercase(Trim(dmMainModule.IBQue_TRIGGER.Fields[0].AsString)) = ProcName THEN
              BEGIN
                estOk := True;
                Break;
              END;
              dmMainModule.IBQue_TRIGGER.Next;
            END;
            dmMainModule.IBQue_TRIGGER.Close;
            IF NOT estOk THEN
              dmMainModule.IBSQLEngine.SQL.Text := '';
          END
          ELSE IF Copy(Uppercase(trim(dmMainModule.IBSQLEngine.SQL.Text)), 1, 15) = 'CREATE TRIGGER ' THEN
          BEGIN
            ProcName := trim(dmMainModule.IBSQLEngine.SQL.Text);
            delete(ProcName, 1, length('CREATE TRIGGER '));
            ProcName := trim(ProcName);
            IF Pos(';', ProcName) > 0 THEN
              procName := trim(Copy(procName, 1, Pos(';', ProcName) - 1));
            ProcName := Uppercase(ProcName);
            WHILE Pos('"', ProcName) > 0 DO
              delete(ProcName, Pos('"', ProcName), 1);
            estOk := False;
            dmMainModule.IBQue_TRIGGER.Open;
            dmMainModule.IBQue_TRIGGER.first;
            WHILE NOT dmMainModule.IBQue_TRIGGER.EOF DO
            BEGIN
              IF Uppercase(Trim(dmMainModule.IBQue_TRIGGER.Fields[0].AsString)) = ProcName THEN
              BEGIN
                estOk := True;
                Break;
              END;
              dmMainModule.IBQue_TRIGGER.Next;
            END;
            dmMainModule.IBQue_TRIGGER.Close;
            IF estOk THEN
              dmMainModule.IBSQLEngine.SQL.Text := '';
          END
          ELSE IF Copy(Uppercase(trim(dmMainModule.IBSQLEngine.SQL.Text)), 1, length('CREATE GENERATOR ')) = 'CREATE GENERATOR ' THEN
          BEGIN
            ProcName := trim(dmMainModule.IBSQLEngine.SQL.Text);
            delete(ProcName, 1, length('CREATE GENERATOR '));
            ProcName := trim(ProcName);
            IF Pos(';', ProcName) > 0 THEN
              procName := trim(Copy(procName, 1, Pos(';', ProcName) - 1));
            dmMainModule.IBQue_GenExists.ParamByName('GENE').AsString := ProcName;
            dmMainModule.IBQue_GenExists.Open;
            IF dmMainModule.IBQue_GenExistsCOUNT.AsInteger > 0 THEN
            BEGIN
              dmMainModule.IBSQLEngine.SQL.Text := '';
            END;
            dmMainModule.IBQue_GenExists.Close;
          END
          ELSE IF Copy(Uppercase(trim(dmMainModule.IBSQLEngine.SQL.Text)), 1, 11) = 'DROP INDEX ' THEN
          BEGIN
            ProcName := Copy(Uppercase(trim(dmMainModule.IBSQLEngine.SQL.Text)), 1, 11 + 255);
            delete(ProcName, 1, 11);
            ProcName := trim(ProcName);
            IF (Pos(' ', ProcName) > 0) AND (Pos(';', ProcName) > Pos(' ', ProcName)) THEN
              ProcName := Copy(ProcName, 1, Pos(' ', ProcName) - 1)
            ELSE IF (Pos(';', ProcName) > 0) AND (Pos(' ', ProcName) > Pos(';', ProcName)) THEN
              ProcName := Copy(ProcName, 1, Pos(';', ProcName) - 1)
            ELSE IF Pos(' ', ProcName) > 0 THEN
              ProcName := Copy(ProcName, 1, Pos(' ', ProcName) - 1)
            ELSE IF (Pos(';', ProcName) > 0) THEN
              ProcName := Copy(ProcName, 1, Pos(';', ProcName) - 1);

            dmMainModule.IBQue_IndexExist.ParamByName('NAME').AsString := ProcName;
            dmMainModule.IBQue_IndexExist.Open;
            IF dmMainModule.IBQue_IndexExistCOUNT.AsInteger = 0 THEN
            BEGIN
              dmMainModule.IBSQLEngine.SQL.Text := '';
            END
            ELSE
            BEGIN
              DBReConnect(vReleaseVisu);
            END;
            dmMainModule.IBQue_IndexExist.CLose;
          END
          ELSE IF Copy(Uppercase(trim(dmMainModule.IBSQLEngine.SQL.Text)), 1, 13) = 'CREATE INDEX ' THEN
          BEGIN
            ProcName := Copy(Uppercase(trim(dmMainModule.IBSQLEngine.SQL.Text)), 1, 13 + 255);
            delete(ProcName, 1, 13);
            ProcName := trim(ProcName);
            IF (Pos(' ', ProcName) > 0) AND (Pos(';', ProcName) > Pos(' ', ProcName)) THEN
              ProcName := Copy(ProcName, 1, Pos(' ', ProcName) - 1)
            ELSE IF (Pos(';', ProcName) > 0) AND (Pos(' ', ProcName) > Pos(';', ProcName)) THEN
              ProcName := Copy(ProcName, 1, Pos(';', ProcName) - 1)
            ELSE IF Pos(' ', ProcName) > 0 THEN
              ProcName := Copy(ProcName, 1, Pos(' ', ProcName) - 1)
            ELSE IF (Pos(';', ProcName) > 0) THEN
              ProcName := Copy(ProcName, 1, Pos(';', ProcName) - 1);

            dmMainModule.IBQue_IndexExist.ParamByName('NAME').AsString := ProcName;
            dmMainModule.IBQue_IndexExist.Open;
            IF dmMainModule.IBQue_IndexExistCOUNT.AsInteger > 0 THEN
            BEGIN
              dmMainModule.IBSQLEngine.SQL.Text := '';
            END
            ELSE
            BEGIN
              DBReConnect(vReleaseVisu);
            END;
            dmMainModule.IBQue_IndexExist.CLose;
          END;

          IF NOT (dsInsert = dmMainModule.IBQueryRelease.State) THEN
          BEGIN
            dmMainModule.IBQueryRelease.Open ;
            dmMainModule.IBQueryRelease.Edit();
          END;

          dmMainModule.IBQueryReleaseVER_VERSION.AsString := ReleaseVisu(LesRelease[IncrementReleases]);
          dmMainModule.IBQueryReleaseVER_DATE.AsDateTime := Now();
          dmMainModule.IBQueryRelease.Post();

          IF trim(dmMainModule.IBSQLEngine.SQL.text) <> '' THEN
          BEGIN
            dmMainModule.IBSQLEngine.ExecQuery();
            IF GrantAFaire <> '' THEN
            BEGIN
              dmMainModule.IBQueryRelease.Transaction.Commit();
              DBReConnect(vReleaseVisu);
              dmMainModule.IBSQLEngine.SQL.text := GrantAFaire;
              dmMainModule.IBSQLEngine.ExecQuery;
              dmMainModule.IBSQLEngine.SQL.text := GrantAFaire2;
              dmMainModule.IBSQLEngine.ExecQuery;
              GrantAFaire := '';
              GrantAFaire2 := '';
            END;
          END;
          dmMainModule.IBQueryRelease.Transaction.Commit();
          IF Copy(Uppercase(trim(dmMainModule.IBSQLEngine.SQL.Text)), 1, 14) = 'ALTER TRIGGER ' THEN
          BEGIN
              // Déconnexion aubligatoire après modification d'un trigger
              DBReConnect(vReleaseVisu);
          END;
          Inc(IncrementReleases);
        EXCEPT
          ON E: Exception DO
          BEGIN
            AddToLogs(Self.Name + '.UpgradeDataBase (3) : ' +  E.Message + #13#10 + 'Release : ' + vReleaseVisu, logError);

            MapGinkoia.ScriptOK := False;
            dmMainModule.IBSQLEngine.Transaction.Rollback();
            IF dmMainModule.IBQueryRelease.Transaction.InTransaction THEN
                dmMainModule.IBQueryRelease.Transaction.Rollback();
            IF FPrmBase THEN
            BEGIN
             // Stocker le problème
              MapGinkoia.ScriptEnCours := FileName + ' ERREUR';
              MapGinkoia.ScriptErreur := E.Message;
              fermeture := true;
              result := false;
              Exit;
            END
            ELSE IF FPrmAuto THEN
            BEGIN
              WinExec('RFG Regression', 0);
              fermeture := true;
              Close;
              Exit;
            END;
            IF FPrmAuto1 THEN
            BEGIN
              fermeture := true;
              result := false;
              Exit;
            END;
            IF ContinueAuto THEN
              Inc(IncrementReleases)
            ELSE
            BEGIN
              application.createForm(TFrm_Erreur, Frm_Erreur);
              TRY
                Frm_Erreur.Lab_Erreur.Caption := ReleaseVisu(LesRelease[IncrementReleases]);
                Frm_Erreur.Memo_Erreur.Text := E.Message;
                Frm_Erreur.Memo_Query.Text := dmMainModule.IBSQLEngine.SQL.text;
                Frm_Erreur.showModal;
                IF Frm_Erreur.modalresult = MrOk THEN
                BEGIN
                  result := false;
                  exit;
                END
                ELSE
                begin
                  IF Frm_Erreur.modalresult = MrRetry THEN
                  BEGIN
                    TstringList(LesRelease.Objects[IncrementReleases]).Text := Frm_Erreur.Memo_Query.Text;
                  END
                  ELSE
                  BEGIN
                    IF Frm_Erreur.Chp_Err.Checked THEN
                        ContinueAuto := true;
                    Inc(IncrementReleases);
                  END;
                end;
              FINALLY
                frm_erreur.release;
              END;
            END;
          END;
        END;
      END;
    END;
  FINALLY
    Lab_EnCours.Caption := '';
    Lab_EnCours.Update;
  END;

  // Passage de toutes les tables avec un Enr 0
  Lab_EnCours.Caption := 'Création des valeurs par défaut';
  Lab_EnCours.Update;
  DmMainModule.IBQue_Divers.Close;

  DBReConnect;
  DmMainModule.IBQue_Divers.Sql.Clear;
  DmMainModule.IBQue_Divers.Sql.Add('Select rdb$Relation_Name, rdb$Field_Name, rdb$Field_Source');
  DmMainModule.IBQue_Divers.Sql.Add('  from rdb$relation_fields');
  DmMainModule.IBQue_Divers.Sql.Add(' where rdb$system_flag = 0');
  DmMainModule.IBQue_Divers.Sql.Add('   And rdb$Field_Position = 0');
  DmMainModule.IBQue_Divers.Sql.Add(' Order by rdb$Relation_Name');
  DmMainModule.IBQue_Divers.Open;
  NbInsertion := 0;
  REPEAT
    Inc(NbInsertion);
    DmMainModule.IBQue_Divers.First;
    toutOk := true;
    WHILE NOT DmMainModule.IBQue_Divers.Eof DO
    BEGIN
      IF trim(DmMainModule.IBQue_Divers.fields[2].AsString) = 'ALGOL_KEY' THEN
      BEGIN
        TRY
          DmMainModule.IBQue_Test.Sql.Clear;
          DmMainModule.IBQue_Test.Sql.Add('Select Count(*)');
          DmMainModule.IBQue_Test.Sql.Add('  From ' + DmMainModule.IBQue_Divers.fields[0].AsString);
          DmMainModule.IBQue_Test.Sql.Add(' Where ' + DmMainModule.IBQue_Divers.fields[1].AsString + '=0');
        EXCEPT
          On E: Exception do
          begin
            AddToLogs('Erreur sur "création des valeurs par défaut" : ' + E.Message, logError);
            SaveQuery(DmMainModule.IBQue_Test.SQL.Text);
            IF (ParamCount > 0) AND (Uppercase(ParamStr(1)) = 'AUTO1') THEN
              result := false
            ELSE
              RAISE;
          end;
        END;
        TRY
            DmMainModule.IBQue_Test.Open;
        EXCEPT
          On E: Exception do
          begin
            AddToLogs('Erreur sur "création des valeurs par défaut" : ' + E.Message, logError);
            SaveQuery(DmMainModule.IBQue_Test.SQL.Text);
            IF (ParamCount > 0) AND (Uppercase(ParamStr(1)) = 'AUTO1') THEN
                result := false
            ELSE
              RAISE;
          end;
        END;
        IF DmMainModule.IBQue_Test.fields[0].AsInteger = 0 THEN
        BEGIN
          DmMainModule.IBQue_NomChp.Sql.Clear;
          DmMainModule.IBQue_NomChp.Sql.Add('Select rdb$Field_Name, rdb$Field_Source');
          DmMainModule.IBQue_NomChp.Sql.Add('  from rdb$relation_fields');
          DmMainModule.IBQue_NomChp.Sql.Add(' where rdb$system_flag = 0');
          DmMainModule.IBQue_NomChp.Sql.Add('   And rdb$Relation_Name = ''' + DmMainModule.IBQue_Divers.fields[0].AsString + '''');
          DmMainModule.IBQue_NomChp.Sql.Add(' Order by rdb$Field_Position');
          DmMainModule.IBQue_NomChp.Open;
          s := '';
          S2 := '';
          WHILE NOT DmMainModule.IBQue_NomChp.Eof DO
          BEGIN
            IF s = '' THEN
                S := trim(DmMainModule.IBQue_NomChp.Fields[0].AsString)
            ELSE
              S := S + ', ' + trim(DmMainModule.IBQue_NomChp.Fields[0].AsString);
            IF trim(DmMainModule.IBQue_NomChp.Fields[1].AsString) = 'ALGOL_DOUBLE' THEN
              S3 := '0'
            ELSE IF trim(DmMainModule.IBQue_NomChp.Fields[1].AsString) = 'ALGOL_FLOAT' THEN
              S3 := '0'
            ELSE IF trim(DmMainModule.IBQue_NomChp.Fields[1].AsString) = 'ALGOL_INTEGER' THEN
              S3 := '0'
            ELSE IF trim(DmMainModule.IBQue_NomChp.Fields[1].AsString) = 'ALGOL_KEY' THEN
              S3 := '0'
            ELSE IF Copy(DmMainModule.IBQue_NomChp.Fields[1].AsString, 1, 13) = 'ALGOL_VARCHAR' THEN
              S3 := ''''''
            ELSE
              S3 := 'NULL';
            IF S2 = '' THEN
              s2 := S3
            ELSE
              S2 := S2 + ', ' + S3;
            DmMainModule.IBQue_NomChp.Next;
          END;
          DmMainModule.IBQue_NomChp.Close;
          DmMainModule.IBSQLDivers.sql.Clear;
          DmMainModule.IBSQLDivers.Sql.Add('INSERT INTO ' + DmMainModule.IBQue_Divers.fields[0].AsString);
          DmMainModule.IBSQLDivers.Sql.Add('(' + S + ')');
          DmMainModule.IBSQLDivers.Sql.Add('VALUES (' + S2 + ')');
          TRY
            DmMainModule.IBSQLDivers.ExecQuery;
            DmMainModule.IBSQLDivers.Transaction.Commit;
          EXCEPT
            On E: Exception do
            begin
              AddToLogs('Erreur sur "création des valeurs par défaut" : ' + E.Message, logError);
              SaveQuery(DmMainModule.IBSQLDivers.SQL.Text);
              toutOk := false;
              DmMainModule.IBSQLDivers.Transaction.rollback;
            end;
          END
        END;
        DmMainModule.IBQue_Test.Close;
      END;
      DmMainModule.IBQue_Divers.Next;
    END;
  UNTIL toutOk OR (NbInsertion > 3);

  Screen.Cursor := CrHourGlass;
  Try
    TRY
      DBReConnect;
      Lab_EnCours.Caption := 'Statistics';
      Lab_EnCours.Update;
//        DmMainModule.IBQue_Divers.Close;
//        DmMainModule.IBQue_Divers.Sql.Clear;
//        DmMainModule.IBQue_Divers.Sql.Add('ALTER INDEX K_1 INACTIVE ;');
//        DmMainModule.IBQue_Divers.ExecSQL;
//        IF dmMainModule.IBQue_Divers.Transaction.InTransaction THEN
//            dmMainModule.IBQue_Divers.Transaction.commit;

      DmMainModule.IBQue_Divers.Close;
      DmMainModule.IBQue_Divers.Sql.Clear;
      DmMainModule.IBQue_Divers.Sql.Add('SET STATISTICS INDEX K_1;');
      DmMainModule.IBQue_Divers.ExecSQL;
      IF dmMainModule.IBQue_Divers.Transaction.InTransaction THEN
          dmMainModule.IBQue_Divers.Transaction.commit;

//        Lab_EnCours.Caption := 'Regénération de K Active '; Lab_EnCours.Update;
//        DmMainModule.IBQue_Divers.Sql.Clear;
//        DmMainModule.IBQue_Divers.Sql.Add('ALTER INDEX K_1 ACTIVE ;');
//        DmMainModule.IBQue_Divers.ExecSQL;
//        IF dmMainModule.IBQue_Divers.Transaction.InTransaction THEN
//            dmMainModule.IBQue_Divers.Transaction.commit;

      DBReConnect;
      Lab_EnCours.Caption := 'Update du K à Zero '; Lab_EnCours.Update;

      DmMainModule.IBQue_Divers.Sql.Clear;
      DmMainModule.IBQue_Divers.Sql.Add('UPDATE K SET K_VERSION=0, K_ENABLED=1 WHERE K_ID=0 ;');
      DmMainModule.IBQue_Divers.ExecSQL;
      IF dmMainModule.IBQue_Divers.Transaction.InTransaction THEN
        dmMainModule.IBQue_Divers.Transaction.commit;
      Lab_EnCours.Caption := '';
      Lab_EnCours.Update;
    FINALLY
      Screen.Cursor := CrDefault;
    END;
  Except on E:exception do
    begin
      AddToLogs(E.Message, logError);
      MapGinkoia.ScriptOK := False;
      MapGinkoia.ScriptErreur := 'Voir yyyy_mm_dd_script.log pour plus de détail';
      result := false;
      EXIT;
    end;
  End;

  IF NOT toutok THEN
  BEGIN
    AddToLogs('Un problème existe dans la base toutes les tables' +
      'n''ont pas un enregistrement par défaut', logError);
    IF FPrmAuto1 THEN
      MessageBox(Handle, '         Un problème existe dans votre base '#10#13 +
          ' toutes les tables n''ont pas un enregistrement par défaut'#10#13 +
          '    Contacter la sociétée ALGOL ', '  Problème ', MB_OK OR MB_ICONEXCLAMATION)
    ELSE
      result := false;
  END;
  DmMainModule.IBTransaction1.Active := false;
  DmMainModule.IBTransaction2.Active := false;
  DmMainModule.IBDatabase1.Connected := false;
END;

PROCEDURE TfMain.Button2Click(Sender: TObject);
BEGIN
  Close;
END;

PROCEDURE TfMain.Timer1Timer(Sender: TObject);
BEGIN
  timer1.enabled := false;
  IF FPrmBase THEN
  BEGIN
      Visible := false;
  END;
  Button1Click(NIL);
END;

PROCEDURE TfMain.FormCreate(Sender: TObject);
BEGIN
//  Path:= ExtractFilePath(Application.ExeName);
//  FileName:= FormatDateTime('yyyy_mm_dd', Now) + '_' + ChangeFileExt(ExtractFileName(Application.ExeName), '.log');

//  if not DirectoryExists(IncludeTrailingBackslash(Logs.Path) + 'Logs') then
//    ForceDirectories(IncludeTrailingBackslash(Logs.Path) + 'Logs');
  if not Log.Opened then
  begin
    Log.Open;
    Log.readIni;
    Log.saveIni;
  end;

  Caption := Caption + ' Ver. ' + GetNumVersionSoft;
  LesRelease := NIL;
  IF FPrmBase THEN
  BEGIN
      Visible := false;
  END;
END;

PROCEDURE TfMain.FormDestroy(Sender: TObject);
VAR
    I: Integer;
BEGIN
  // Vérification de l'existance de l'utilisateur Ginkoia
  TRY
    IF Lesrelease <> NIL THEN
    BEGIN
      FOR i := 0 TO LesRelease.Count - 1 DO
        tstringList(LesRelease.objects[i]).free;
      LesRelease.free;
    END;
  EXCEPT
  END;
END;

PROCEDURE TfMain.Button3Click(Sender: TObject);
BEGIN
  IF Od.execute THEN
    UpgradeDataBase(Od.FileName);
END;

FUNCTION PlaceDeInterbase: STRING;
VAR
    Reg: Tregistry;
BEGIN
  reg := Tregistry.Create;
  TRY
    reg.Access := KEY_READ;
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    Reg.OpenKey('\Software\Borland\Interbase\CurrentVersion', False);
    result := Reg.ReadString('RootDirectory');
  FINALLY
    reg.free;
  END;
END;

PROCEDURE TfMain.FormCloseQuery(Sender: TObject; VAR CanClose: Boolean);
VAR
    s: STRING;
BEGIN
  CanClose := true;
  TRY
    S := PlaceDeInterbase;
    IF FileExists(S + 'ISC4.GDB') THEN
    BEGIN
      DmMainModule.IBDatabase1.Connected := false;
      DmMainModule.IBDatabase1.DataBaseName := S + 'ISC4.GDB';
      DmMainModule.IBDatabase1.Connected := True;
      DmMainModule.IBQue_Test.Sql.text := 'Select count(*) from USERS where User_Name = ''GINKOIA''';
      DmMainModule.IBQue_Test.Open;
      IF DmMainModule.IBQue_Test.fields[0].AsInteger = 0 THEN
      BEGIN
        DmMainModule.IBSQLDivers.Sql.Clear;
        DmMainModule.IBSQLDivers.Sql.Add('INSERT INTO USERS (USER_NAME, UID, GID, PASSWD, FIRST_NAME, MIDDLE_NAME, LAST_NAME) ');
        DmMainModule.IBSQLDivers.Sql.Add('           VALUES (''GINKOIA'', 0, 0, ''yvWQB8NqTO2'',  '''', '''', ''''); ');
        DmMainModule.IBSQLDivers.ExecQuery;
        dmMainModule.IBSQLDivers.Transaction.Commit;
      END;
      DmMainModule.IBQue_Test.Close;

      DmMainModule.IBQue_Test.Sql.text := 'Select count(*) from USERS where User_Name = ''REPL''';
      DmMainModule.IBQue_Test.Open;
      IF DmMainModule.IBQue_Test.fields[0].AsInteger = 0 THEN
      BEGIN
        DmMainModule.IBSQLDivers.Sql.Clear;
        DmMainModule.IBSQLDivers.Sql.Add('INSERT INTO USERS (USER_NAME, UID, GID, PASSWD, FIRST_NAME, MIDDLE_NAME, LAST_NAME) ');
        DmMainModule.IBSQLDivers.Sql.Add('           VALUES (''REPL'', 0, 0, ''I6RvbvTyOAY'',  '''', '''', ''''); ');
        DmMainModule.IBSQLDivers.ExecQuery;
        dmMainModule.IBSQLDivers.Transaction.Commit;
      END;
      DmMainModule.IBQue_Test.Close;
      DmMainModule.IBDatabase1.Connected := false;
    END;

    IF FileExists(S + 'admin.ib') THEN
    BEGIN
      DmMainModule.IBDatabase1.Connected := false;
      DmMainModule.IBDatabase1.DataBaseName := S + 'admin.ib';
      DmMainModule.IBDatabase1.Connected := True;
      DmMainModule.IBQue_Test.Sql.text := 'Select count(*) from USERS where User_Name = ''GINKOIA''';
      DmMainModule.IBQue_Test.Open;
      IF DmMainModule.IBQue_Test.fields[0].AsInteger = 0 THEN
      BEGIN
        DmMainModule.IBSQLDivers.Sql.Clear;
        DmMainModule.IBSQLDivers.Sql.Add('INSERT INTO USERS (USER_NAME, UID, GID, PASSWD, FIRST_NAME, MIDDLE_NAME, LAST_NAME) ');
        DmMainModule.IBSQLDivers.Sql.Add('           VALUES (''GINKOIA'', 0, 0, ''yvWQB8NqTO2'',  '''', '''', ''''); ');
        DmMainModule.IBSQLDivers.ExecQuery;
        dmMainModule.IBSQLDivers.Transaction.Commit;
      END;
      DmMainModule.IBQue_Test.Close;

      DmMainModule.IBQue_Test.Sql.text := 'Select count(*) from USERS where User_Name = ''REPL''';
      DmMainModule.IBQue_Test.Open;
      IF DmMainModule.IBQue_Test.fields[0].AsInteger = 0 THEN
      BEGIN
        DmMainModule.IBSQLDivers.Sql.Clear;
        DmMainModule.IBSQLDivers.Sql.Add('INSERT INTO USERS (USER_NAME, UID, GID, PASSWD, FIRST_NAME, MIDDLE_NAME, LAST_NAME) ');
        DmMainModule.IBSQLDivers.Sql.Add('           VALUES (''REPL'', 0, 0, ''I6RvbvTyOAY'',  '''', '''', ''''); ');
        DmMainModule.IBSQLDivers.ExecQuery;
        dmMainModule.IBSQLDivers.Transaction.Commit;
      END;
      DmMainModule.IBQue_Test.Close;
      DmMainModule.IBDatabase1.Connected := false;
    END;

    DmMainModule.IBDatabase1.Connected := false;
  EXCEPT
  END;
END;

//
//CstProbTrfPort = 'Problème de transfert tous les articles ne sont pas récupérés '+#13#10+'Concerver la saisie ?' ;
//

END.

