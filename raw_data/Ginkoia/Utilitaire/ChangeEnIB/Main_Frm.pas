// ==================================================================
// ChangeEnIB
//
// Renommage d'une base Ginkoia.gdb en Ginkoia.ib
//
// Etapes :
//   1. Arret du service Interbase Guardian
//   2. Kill du process LauncherV7.exe
//   3. Renommage du fichier .gdb en .ib
//   4. Redemarrage du service Interbase Guardian
//   5. MAJ DB - Tables GENREPLICATION et K
//   6. MAJ des fichiers DelosQPMAgent.DataSources.xml
//   7. MAJ de la base de registre
//   8. MAJ des fichiers *.ini
//   9. Redemarrage du process LauncherV7.exe
//
// F.TEYSSEIRE - JANVIER 2008
// ==================================================================

unit Main_Frm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  LMDCustomControl, LMDCustomPanel, LMDCustomBevelPanel, LMDBaseEdit,
  LMDCustomEdit,
  LMDCustomBrowseEdit, LMDCustomFileEdit, LMDFileOpenEdit, LMDCustomButton,
  LMDButton,
  LMDCustomComponent, LMDFileGrep, StdCtrls, IBDatabase, Db,
  IBDataset, Registry, TlHelp32, WinSvc, IBSQL;

type
  TFrm_Main = class(TForm)
    Nbt_Ok: TLMDButton;
    Nbt_Abandon: TLMDButton;
    OpCmb_BD: TLMDFileOpenEdit;
    IBDB_DB1: TIBDatabase;
    Custom_Req1: TIBTransaction;
    IBSql_Req1: TIBSQL;
    procedure FormCreate(Sender: TObject);
    procedure OpCmb_BDChange(Sender: TObject);
    procedure Nbt_AbandonClick(Sender: TObject);
    procedure Nbt_OkClick(Sender: TObject);
    procedure OpCmb_BDBeforeBrowse(Sender: TObject);
  private
    { Déclarations privées }
    function ServiceIsRunning(hSCService: SC_HANDLE): boolean;
    function DoStartService(hSCService: SC_HANDLE): boolean;
    function DoStopService(hSCService: SC_HANDLE): boolean;
    function DoKillProcess(ProcessName: string): boolean;
    function DoUpdateDB(sIBName: string): boolean;
    function DoUpdateFiles(sFileMasks: string; sGDBName: string;
      sIBName: string; bRecursSubDirs: boolean): boolean;
    function FileStringReplace(sFile: string; sOldPattern: string;
      sNewPattern: string): boolean;
    function ReadStringRegisterValue(cRootKey: Cardinal; sKey: string;
      sData: string): string;
    function WriteStringRegisterValue(cRootKey: Cardinal; sKey: string;
      sData: string; sValue: string): boolean;
  public
    { Déclarations publiques }
  end;

var
  Frm_Main: TFrm_Main;
  gsAppli: string; // Nom Application

const
  ksProg2Stop = 'LaunchV7.exe';
  ksServiceName = 'Interbase Guardian';
  ksDBUsername = 'SYSDBA';
  ksDBPassword = 'masterkey';
  ksGinkoiaDir = 'C:\Ginkoia';
  ksXMLFiles = 'DelosQPMAgent.DataSources.xml';
  ksIniFiles = '*.ini';
  ksGinkoiaRegKey = 'SOFTWARE\ALGOL\GINKOIA';
  ksGinkoiaRegData = 'base0';
  ksProg2Run = ksGinkoiaDir + '\' + ksProg2Stop;
  kiMaxLen = 255;

implementation

{$R *.DFM}

// ===== FormCreate =====

procedure TFrm_Main.FormCreate(Sender: TObject);
begin
  Nbt_Ok.enabled := false;
  gsAppli := ExtractFileName(Application.ExeName);
  gsAppli := Copy(gsAppli, 1,
    Length(gsAppli) - Length(ExtractFileExt(gsAppli)));
end;

// ===== OpCmb_BDBeforeBrowse =====

procedure TFrm_Main.OpCmb_BDBeforeBrowse(Sender: TObject);
begin
  OpCmb_BD.InitialDir := ExtractFileDir(OpCmb_BD.Filename);
end;

// ===== OpCmb_BDChange =====

procedure TFrm_Main.OpCmb_BDChange(Sender: TObject);
begin
  if FileExists(OpCmb_BD.Filename) then
  begin
    Nbt_Ok.enabled := true;
  end
  else
  begin
    Nbt_Ok.enabled := false;
    MessageDlg('Erreur - Fichier ' + OpCmb_BD.Filename + ' inexistant.',
      mtError, [mbOK], 0);
  end;
end;

// ===== Nbt_AbandonClick =====

procedure TFrm_Main.Nbt_AbandonClick(Sender: TObject);
begin
  Application.Terminate;
  ModalResult := mrCancel;
end;

// ===== Nbt_OkClick =====

procedure TFrm_Main.Nbt_OkClick(Sender: TObject);
var
  bFine: boolean;
  hSCManager: SC_HANDLE;
  hSCService: SC_HANDLE;
  psServiceSystemName: PChar;
  dwLongMax: DWORD;
  sIBName: string;
  sRegGinkoiaBase0: string;
begin
  bFine := false;
  hSCManager := 0;
  hSCService := 0;
  psServiceSystemName := nil;

  // Ceinture + Bretelle
  if not FileExists(OpCmb_BD.Filename) then
  begin
    MessageDlg(gsAppli + #13#10#13#10 +
      'Le fichier ' + OpCmb_BD.Filename + ' n''existe pas.',
      mtError, [mbOK], 0);
    Nbt_Ok.enabled := false;
    exit;
  end;

  if UpperCase(ExtractFileExt(OpCmb_BD.Filename)) <> '.GDB' then
  begin
    MessageDlg(gsAppli + #13#10#13#10 +
      'Extension "' + ExtractFileExt(OpCmb_BD.Filename) +
      '" non supporté par cet outil.', mtError, [mbOK], 0);
    Nbt_Ok.enabled := false;
    exit;
  end;

  try
    Screen.Cursor := crHourGlass;

    // Connection au controleur de services Windows
    hSCManager := OpenSCManager(nil, nil, SC_MANAGER_CONNECT);
    if hSCManager = 0 then
    begin
      MessageDlg(gsAppli + #13#10#13#10 + 'Erreur OpenSCManager() : ' +
        SysErrorMessage(GetLastError), mtError, [mbOK], 0);
      exit;
    end;

    // Recherche du nom systeme du service
    dwLongMax := kiMaxLen;
    GetMem(psServiceSystemName, kiMaxLen);
    if not GetServiceKeyName(hSCManager, PChar(ksServiceName),
      psServiceSystemName, dwLongMax) then
    begin
      MessageDlg(gsAppli + #13#10#13#10 + 'Erreur GetServiceKeyName() : ' +
        SysErrorMessage(GetLastError), mtError, [mbOK], 0);
      exit;
    end;

    // Ouverture du service
    hSCService := OpenService(hSCManager, psServiceSystemName,
      SERVICE_QUERY_STATUS or SERVICE_START or SERVICE_STOP);
    if hSCService = 0 then
    begin
      MessageDlg(gsAppli + #13#10#13#10 + 'Erreur OpenService() : ' +
        SysErrorMessage(GetLastError), mtError, [mbOK], 0);
      exit;
    end;

    // Arret d'Interbase
    if ServiceIsRunning(hSCService) then
    begin
      if not DoStopService(hSCService) then
      begin
        // Message d'erreur dans DoStopService
        exit;
      end;
    end;

    // Arret du Launcher
    DoKillProcess(ksProg2Stop);

    // Renommage du fichier
    sIBName := Copy(OpCmb_BD.Filename, 1,
      Length(OpCmb_BD.Filename)
      - Length(ExtractFileExt(OpCmb_BD.Filename))) + '.ib';
    if not RenameFile(OpCmb_BD.Filename, sIBName) then
    begin
      MessageDlg(gsAppli + #13#10#13#10 +
        'Erreur RenameFile(' + OpCmb_BD.Filename + ', ' + sIBName + ').',
        mtError, [mbOK], 0);
      exit;
    end;

    // Redemarrage d'Interbase
    if not DoStartService(hSCService) then
    begin
      // Message d'erreur dans DoStartService
      exit;
    end;

    // Sandrine le 11/02/2008:
    //  attention la requette suivante va se connecter sur la base,
    //  il faut lui laisser un peu de temps pour être prêt !!
    sleep(500);

    // Modification DB
    if not DoUpdateDB(sIBName) then
    begin
      // Message d'erreur dans DoUpdateDB
      exit;
    end;

    // Modification des fichiers XML
    if not DoUpdateFiles(ksXMLFiles, OpCmb_BD.Filename, sIBName, true) then
    begin
      // Message d'erreur dans DoUpdateDB
      exit;
    end;

    // Modification des fichiers INI
    if not DoUpdateFiles(ksIniFiles, OpCmb_BD.Filename, sIBName, false) then
    begin
      // Message d'erreur dans DoUpdateDB
      exit;
    end;

    // Modification de la base de registre
    sRegGinkoiaBase0 := ReadStringRegisterValue(HKEY_LOCAL_MACHINE,
      ksGinkoiaRegKey,
      ksGinkoiaRegData);
    if UpperCase(sRegGinkoiaBase0) <> UpperCase(sIBName) then
    begin
      WriteStringRegisterValue(HKEY_LOCAL_MACHINE, ksGinkoiaRegKey,
        ksGinkoiaRegData, sIBName);
    end;

    // Redémarrage du Launcher
    WinExec(PChar(ksProg2Run), 0);

    bFine := true;

  finally
    FreeMem(psServiceSystemName, kiMaxLen);
    if hSCService <> 0 then
    begin
      CloseServiceHandle(hSCService);
    end;

    if hSCManager <> 0 then
    begin
      CloseServiceHandle(hSCManager);
    end;

    Screen.Cursor := crDefault;

    if not bFine then
    begin
      MessageDlg(gsAppli + #13#10#13#10
        + 'Echec renommage de la DB en ' + sIBName + '.' + #13#10#13#10
        + 'Veuillez vérifier l''état de la DB.', mtError, [mbOK], 0);
    end;
  end;

  Nbt_Ok.enabled := false;
  MessageDlg('Renommage de la DB en ' + sIBName + ' effectué avec succès.',
    mtInformation, [mbOK], 0);
  ModalResult := mrOk;
end;

// ==== ServiceIsRunning =====

function TFrm_Main.ServiceIsRunning(hSCService: SC_HANDLE): boolean;
var
  ServiceStatus: SERVICE_STATUS;
begin
  result := false;

  // Interrogation état du service
  if not QueryServiceStatus(hSCService, ServiceStatus) then
  begin
    MessageDlg(gsAppli + ' - ServiceIsRunning()' + #13#10#13#10
      + 'Erreur QueryServiceStatus() : ' +
      SysErrorMessage(GetLastError), mtError, [mbOK], 0);
    exit;
  end;

  if ServiceStatus.dwCurrentState = SERVICE_RUNNING then
  begin
    result := true;
  end
  else
    if ServiceStatus.dwCurrentState = SERVICE_STOPPED then
    begin
      result := false;
    end
    else
    begin
      MessageDlg(gsAppli + ' - ServiceIsRunning()' + #13#10#13#10
        + 'Etat du service non supporté.', mtError, [mbOK], 0);
      result := false;
      exit;
    end;
end;

// ==== StartService =====

function TFrm_Main.DoStartService(hSCService: SC_HANDLE): boolean;
var
  ServiceStatus: TServiceStatus;
  ServiceArgs: PChar;
begin
  result := false;

  // Interrogation état du service
  if not QueryServiceStatus(hSCService, ServiceStatus) then
  begin
    MessageDlg(gsAppli + ' - DoStartService()' + #13#10#13#10
      + 'Erreur QueryServiceStatus() : ' +
      SysErrorMessage(GetLastError), mtError, [mbOK], 0);
    exit;
  end;
  if ServiceStatus.dwWaitHint <> 0 then
  begin
    Sleep(ServiceStatus.dwWaitHint);
    QueryServiceStatus(hSCService, ServiceStatus);
  end;

  // Vérification service arrété
  if ServiceStatus.dwCurrentState <> SERVICE_STOPPED then
  begin
    MessageDlg(gsAppli + ' - StartService()' + #13#10#13#10
      + 'Le service n''est pas arreté', mtError, [mbOK], 0);
    exit;
  end;

  // Démarrage du service
  ServiceArgs := nil;
  if not StartService(hSCService, 0, ServiceArgs) then
  begin
    MessageDlg(gsAppli + ' - StartService()' + #13#10#13#10
      + 'Erreur StartService() : ' +
      SysErrorMessage(GetLastError), mtError, [mbOK], 0);
    exit;
  end;

  result := true;
end;

// ==== StopService =====

function TFrm_Main.DoStopService(hSCService: SC_HANDLE): boolean;
var
  ServiceStatus: TServiceStatus;
begin
  result := false;

  // Interrogation état du service
  if not QueryServiceStatus(hSCService, ServiceStatus) then
  begin
    MessageDlg(gsAppli + ' - DoStopService()' + #13#10#13#10
      + 'Erreur QueryServiceStatus() : ' +
      SysErrorMessage(GetLastError), mtError, [mbOK], 0);
    exit;
  end;
  if ServiceStatus.dwWaitHint <> 0 then
  begin
    Sleep(ServiceStatus.dwWaitHint);
    QueryServiceStatus(hSCService, ServiceStatus);
  end;

  // Vérification service démarré
  if ServiceStatus.dwCurrentState <> SERVICE_RUNNING then
  begin
    MessageDlg(gsAppli + ' - DoStopService()' + #13#10#13#10
      + 'Le service n''est pas démarré.', mtError, [mbOK], 0);
    exit;
  end;

  // Arret du service
  if not ControlService(hSCService, SERVICE_CONTROL_STOP, ServiceStatus) then
  begin
    MessageDlg(gsAppli + ' - DoStopService()' + #13#10#13#10
      + 'Erreur ControlService() : ' +
      SysErrorMessage(GetLastError), mtError, [mbOK], 0);
    exit;
  end;

  result := true;
end;

// ===== DoKillProcess =====

function TFrm_Main.DoKillProcess(ProcessName: string): boolean;
var
  ProcessEntry32: TProcessEntry32;
  HSnapShot: THandle;
  HProcess: THandle;
begin
  Result := False;

  HSnapShot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if HSnapShot = 0 then
  begin
    MessageDlg(gsAppli + ' - DoKillProcess()' + #13#10#13#10
      + 'Erreur CreateToolhelp32Snapshot() : ' +
      SysErrorMessage(GetLastError), mtError, [mbOK], 0);
    exit;
  end;

  ProcessEntry32.dwSize := sizeof(ProcessEntry32);
  if Process32First(HSnapShot, ProcessEntry32) then
    repeat
      if CompareText(ProcessEntry32.szExeFile, ProcessName) = 0 then
      begin
        HProcess := OpenProcess(PROCESS_TERMINATE, False,
          ProcessEntry32.th32ProcessID);
        if HProcess <> 0 then
        begin
          Result := TerminateProcess(HProcess, 0);
          CloseHandle(HProcess);
        end;
        Break;
      end;
    until not Process32Next(HSnapShot, ProcessEntry32);

  CloseHandle(HSnapshot);
end;

// ===== DoUpdateDB =====

function TFrm_Main.DoUpdateDB(sIBName: string): boolean;
var
  iRepId: integer;
begin
  result := false;

  // Pourquoi on est connecté ???
  if IBDB_DB1.Connected then
  begin
    MessageDlg('DoUpdateDB() - Déjà connecté sur la DB.', mtWarning, [mbOK], 0);
  end;

  IBDB_DB1.DatabaseName := sIBName;
  IBDB_DB1.LoginPrompt := false;
  IBDB_DB1.Params.Clear;
  IBDB_DB1.Params.Add('User_Name=' + ksDBUserName);
  IBDB_DB1.Params.Add('Password=' + ksDBPassword);
  IBDB_DB1.Open;
  Custom_Req1.Active := true;

  IBSql_Req1.Sql.Clear;
  IBSql_Req1.Sql.Add('select REP_ID');
  IBSql_Req1.Sql.Add('from GENBASES');
  IBSql_Req1.Sql.Add('join GENPARAMBASE on(PAR_STRING = BAS_IDENT)');
  IBSql_Req1.Sql.Add('join GENLAUNCH on(LAU_BASID = BAS_ID)');
  IBSql_Req1.Sql.Add('join K KLAU on(KLAU.K_ID = LAU_ID and KLAU.K_ENABLED = 1)');
  IBSql_Req1.Sql.Add('join GENREPLICATION on(REP_LAUID = LAU_ID)');
  IBSql_Req1.Sql.Add('join K KREP on(KREP.K_ID = REP_ID and KREP.K_ENABLED = 1)');
  IBSql_Req1.Sql.Add('where REP_ID <> 0');
  IBSql_Req1.Sql.Add('  and PAR_NOM = ''IDGENERATEUR''');
  try
    IBSql_Req1.ExecQuery;
  except
    on E: Exception do
    begin
      MessageDlg(GsAppli + ' - DoUpdateDb()' + #13#10#13#10
        + 'Erreur "select from GENBASES"' + #10#13#10#13
        + e.Message + #10#13#10#13 + 'Abandon procedure.', mtError, [mbOK], 0);
      Custom_Req1.Rollback;
      exit;
    end;
  end;
  iRepId := IBSql_Req1.Fields[0].AsInteger;
  IBSql_Req1.Close;

  if iRepId = 0 then
  begin
    MessageDlg(GsAppli + ' - DoUpdateDb()' + #13#10#13#10
      + 'Erreur iRepId = 0' + #10#13#10#13
      + 'Abandon procedure.', mtError, [mbOK], 0);
    exit;
  end;

  IBSql_Req1.Sql.Clear;
  IBSql_Req1.Sql.Add('update GENREPLICATION');
  IBSql_Req1.Sql.Add('set REP_PLACEBASE = ''' + sIBName + '''');
  IBSql_Req1.Sql.Add('where REP_ID = ' + IntToStr(iRepId));
  try
    IBSql_Req1.ExecQuery;
  except
    on E: Exception do
    begin
      MessageDlg(GsAppli + ' - DoUpdateDb()' + #13#10#13#10
        + 'Erreur "update GENREPLICATION"' + #10#13#10#13
        + e.Message + #10#13#10#13 + 'Abandon procedure.', mtError, [mbOK], 0);
      Custom_Req1.Rollback;
      exit;
    end;
  end;
  IBSql_Req1.Close;

  IBSql_Req1.Sql.Clear;
  IBSql_Req1.Sql.Add('update k');
  IBSql_Req1.Sql.Add('set k_version = gen_id(general_id, 1)');
  IBSql_Req1.Sql.Add('where k_id = ' + IntToStr(iRepId));
  try
    IBSql_Req1.ExecQuery;
  except
    on E: Exception do
    begin
      MessageDlg(GsAppli + ' - DoUpdateDb()' + #13#10#13#10
        + 'Erreur "update K"' + #10#13#10#13
        + e.Message + #10#13#10#13 + 'Abandon procedure.', mtError, [mbOK], 0);
      Custom_Req1.Rollback;
      exit;
    end;
  end;
  IBSql_Req1.Close;

  Custom_Req1.Commit;
  IBDB_DB1.Close;
  Custom_Req1.Active := false;
  IBDB_DB1.Connected := false;

  result := true;
end;

// ===== DoUpdateFiles =====

function TFrm_Main.DoUpdateFiles(sFileMasks: string; sGDBName: string;
  sIBName: string; bRecursSubDirs: boolean): boolean;
var
  i: integer;
  iErreur: integer;
  FileGrep_IniFiles: TLMDFileGrep;
  ReturnValues: TLMDReturnValues;
begin
  result := false;
  iErreur := 0;

  // Modification des fichiers XML
  FileGrep_IniFiles := TLMDFileGrep.Create(nil);
  FileGrep_IniFiles.RecurseSubDirs := bRecursSubDirs;
  FileGrep_IniFiles.ReturnDelimiter := '¤';
  ReturnValues := [rvDir, rvFilename];
  FileGrep_IniFiles.ReturnValues := ReturnValues;
  FileGrep_IniFiles.ThreadedSearch := false;
  FileGrep_IniFiles.Dirs := ksGinkoiaDir;
  FileGrep_IniFiles.FileMasks := sFileMasks;
  FileGrep_IniFiles.Grep;

  for i := 0 to FileGrep_IniFiles.Files.Count - 1 do
  begin
    FileGrep_IniFiles.Files[i] :=
      StringReplace(FileGrep_IniFiles.Files[i], '¤', '', [rfReplaceAll]);
    if not FileStringReplace(FileGrep_IniFiles.Files[i], sGDBName, sIBName) then
    begin
      inc(iErreur);
    end;
  end;
  FileGrep_IniFiles.Destroy();

  if iErreur = 0 then
  begin
    result := true;
  end;
end;

// ===== FileStringReplace =====

function TFrm_Main.FileStringReplace(sFile: string; sOldPattern: string;
  sNewPattern: string): boolean;
var
  tfSrc: TextFile;
  tfDest: TextFile;
  sTmpFile: string;
  sLine: string;
begin
  if not FileExists(sFile) then
  begin
    MessageDlg(GsAppli + ' - FileStringReplace()' + #13#10#13#10
      + 'Erreur, fichier ' + OpCmb_BD.Filename + ' inexistant.',
      mtError, [mbOK], 0);
    result := false;
    exit;
  end;

  sTmpFile := PChar(ChangeFileExt(sFile, '.tmp'));
  AssignFile(tfSrc, sFile);
  Reset(tfSrc);
  AssignFile(tfDest, sTmpFile);
  Rewrite(tfDest);
  repeat
    ReadLn(tfSrc, sLine);
    sLine := StringReplace(sLine, sOldPattern, sNewPattern,
      [rfReplaceAll, rfIgnoreCase]);
    WriteLn(tfDest, sLine);
  until EOF(tfSrc);
  CloseFile(tfSrc);
  CloseFile(tfDest);
  DeleteFile(sFile);
  RenameFile(sTmpFile, sFile);
  result := true;
end;

// ===== ReadStringRegisterValue =====

function TFrm_Main.ReadStringRegisterValue(cRootKey: Cardinal; sKey: string;
  sData: string): string;
var
  TReg: TRegistry;
begin
  result := '';

  TReg := TRegistry.Create;
  TReg.RootKey := cRootKey;

  if not TReg.OpenKey(sKey, false) then
  begin
    exit
  end;

  if TReg.ValueExists(sData) then
  begin
    result := TReg.ReadString(sData);
  end;
  TReg.CloseKey;
  TReg.Free;
end;

// ===== WriteStringRegisterValue =====

function TFrm_Main.WriteStringRegisterValue(cRootKey: Cardinal; sKey: string;
  sData: string; sValue: string): boolean;
var
  TReg: TRegistry;
begin
  result := false;

  TReg := TRegistry.Create;
  TReg.RootKey := cRootKey;

  if not TReg.OpenKey(sKey, false) then
  begin
    exit;
  end;

  if TReg.ValueExists(sData) then
  begin
    TReg.WriteString(sData, sValue);
  end;
  TReg.CloseKey;
  TReg.Free;
  result := true;
end;

end.

