unit Service;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.SvcMgr, Vcl.Dialogs, Data.DB, Registry, ShellAPI,
  RepriseChequeCadeauService, RepriseFideliteInterSportService, RepriseFideliteComarchInterSportService, RepriseReservationSkiset, RepriseCCGlobalPOSService,
  RepriseFideliteSport2000, RepriseMarketPlaceSport2000, RepriseCCIllicadoService;

type
  TGinkoiaServiceReprises = class(TService)
    procedure ServiceAfterInstall(Sender: TService);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure ServiceShutdown(Sender: TService);
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceCreate(Sender: TObject);
    procedure ServiceDestroy(Sender: TObject);
    procedure ServiceBeforeUninstall(Sender: TService);

  private
    FRepriseChequeCadeauService: TRepriseChequeCadeauService;
    FRepriseCCGlobalPOSService: TRepriseCCGlobalPOSService;
    FRepriseFideliteInterSportService: TRepriseFideliteInterSportService;
    FRepriseFideliteComarchInterSportService: TRepriseFideliteComarchInterSportService;
    FRepriseReservationSkiset: TRepriseReservationSkiset;
    FRepriseFideliteSport2000: TRepriseFideliteSport2000;
    FRepriseMarketPlaceSport2000: TRepriseMarketPlaceSport2000Service;
    FRepriseCCIllicadoService: TRepriseCCIllicadoService;

    FDataBaseFile: String;

    procedure InitLogs;
    procedure PurgeLogFiles;
    function GetBaseGUID: String;

  public
    function GetServiceController: TServiceController;   override;

    procedure ServiceStopShutDown;
  end;

var
  GinkoiaServiceReprises: TGinkoiaServiceReprises;

implementation

uses ulog, uRegistryUtils, uGestionBDD, UVersion;

{$R *.dfm}

procedure ServiceController(CtrlCode: DWord);   stdcall;
begin
  GinkoiaServiceReprises.Controller(CtrlCode);
end;

//procedure AjoutLog(const sLigne: String);
//var
//  sFichier: String;
//  F: TextFile;
//begin
//  sFichier := ExtractFilePath(ParamStr(0)) + 'ServiceReprises.log';
//  AssignFile(F, sFichier);
//  try
//    if FileExists(sFichier) then
//      Append(F)
//    else
//      Rewrite(F);
//
//    Writeln(F, '[' + FormatDateTime('', Now) + ']  ' + sLigne);
//  finally
//    CloseFile(F);
//  end;
//end;

function TGinkoiaServiceReprises.GetBaseGUID: String;
var
  query: TMyQuery;
  vCnx: TMyConnection;
begin
  vCnx := GetNewConnexion(FDataBaseFile, CST_GINKOIA_LOGIN, CST_GINKOIA_PASSWORD);
  try
    query := GetNewQuery(vCnx);
    query.SQL.Text :=
      'SELECT BAS_GUID ' +
      'FROM ' +
      '   GENBASES ' +
      '   JOIN GENPARAMBASE ON GENPARAMBASE.PAR_STRING = GENBASES.BAS_IDENT AND ' +
      '     GENPARAMBASE.PAR_NOM = ''IDGENERATEUR'' ' +
      '   JOIN K ON K.K_ID = GENBASES.BAS_ID AND K.K_ENABLED = 1';
    query.Open;

    if not query.IsEmpty then
      Result := query.FieldByName('BAS_GUID').AsString;

    query.Close;
    FreeAndNil(query);
  finally
    vCnx.DisposeOf;
  end;
end;

function TGinkoiaServiceReprises.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TGinkoiaServiceReprises.InitLogs;
begin
  log.readIni;
  log.App := 'ReprisesService';
  log.Ref := GetBaseGuid;
  log.Open;
  log.saveIni;
end;

procedure TGinkoiaServiceReprises.PurgeLogFiles;
var
  path: string;
  info : TSearchRec;
  files: TStrings;
  i: Integer;
begin
  path := ExtractFilePath(ParamStr(0)) + 'logs\';

  files := TStringList.Create;

  { Recherche de la première entrée du répertoire }
  If FindFirst(path + '*.*', faAnyFile, Info) = 0 Then
  Begin
    Repeat
      { Les fichiers sont affichés dans ListBox1 }
      { Les répertoires sont affichés dans ListBox2 }
      If not(Info.Attr = faDirectory) and ((Now - Info.TimeStamp) > 90)
        and ((pos('reprisefideliteintersportlogs', Info.Name) <> 0) or (pos('reprisechequecadeauservicelogs', Info.Name) <> 0)) then
      begin
        files.Add(info.Name);
      end;

      { Il faut ensuite rechercher l'entrée suivante }
      Until FindNext(Info)<>0;

    { Dans le cas ou une entrée au moins est trouvée il faut }
    { appeler FindClose pour libérer les ressources de la recherche }
    FindClose(Info);
  End;

  for i := 0 to files.Count - 1 do
  begin
    if not DeleteFile(path+files[i]) then
      log.Log('TST', log.Ref, '', 'status', files[i], logInfo, True);
  end;
end;

procedure TGinkoiaServiceReprises.ServiceAfterInstall(Sender: TService);
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_LOCAL_MACHINE;
    if reg.OpenKey('SYSTEM\CurrentControlSet\Services\' + Name, False) then
    begin
      Reg.WriteString('Description', 'Service mutualisé Ginkoia pour la gestion des chèques cadeaux et la fidélité INTERSPORT saisies en mode déconnecté');
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;

  log.Log('Main', 'Status', 'Service installé', logInfo, False, -1, ltBoth);
end;

procedure TGinkoiaServiceReprises.ServiceBeforeUninstall(Sender: TService);
begin
  log.Log('Main', 'Status', 'Service désinstallé', logInfo, False, -1, ltBoth);
end;

procedure TGinkoiaServiceReprises.ServiceCreate(Sender: TObject);
begin
  FDataBaseFile := uRegistryUtils.GetBaseFilePath;
  {$IFDEF DEBUG}
//    FDataBaseFile := 'C:\Documents\BASES\Piguet_crosscanal\GINKOIA.IB';
  {$ENDIF}

//  AjoutLog(FDataBaseFile);
end;

procedure TGinkoiaServiceReprises.ServiceDestroy(Sender: TObject);
begin
  Log.Close;
end;

procedure TGinkoiaServiceReprises.ServiceShutdown(Sender: TService);
begin
  ServiceStopShutDown;
end;

procedure TGinkoiaServiceReprises.ServiceStart(Sender: TService; var Started: Boolean);
begin
{$IFDEF DEBUG}
//  Sleep(10000);
{$ENDIF}

  try
    InitLogs;

    PurgeLogFiles;

    log.Log('Main', 'Version', uversion.GetNumVersionSoft, logInfo, False, -1, ltBoth);

    FRepriseChequeCadeauService := TRepriseChequeCadeauService.Create(FDataBaseFile);
    if FRepriseChequeCadeauService.CanExecute then
      FRepriseChequeCadeauService.Start
    else
    begin
      log.Log('DEMAT', log.Ref, '', 'status', 'Module "DEMAT" non actif', logInfo, True);
      FreeAndNil(FRepriseChequeCadeauService);
    end;

    FRepriseFideliteInterSportService := TRepriseFideliteInterSportService.Create(FDataBaseFile);
    if FRepriseFideliteInterSportService.CanExecute then
      FRepriseFideliteInterSportService.Start
    else
    begin
      log.Log('FIDISF', log.Ref, '', 'status', 'Module "Fidélité ISF Maxxing" non actif', logInfo, True);
      FreeAndNil(FRepriseFideliteInterSportService);
    end;

    FRepriseFideliteComarchInterSportService := TRepriseFideliteComarchInterSportService.Create(FDataBaseFile);
    if FRepriseFideliteComarchInterSportService.CanExecute then
      FRepriseFideliteComarchInterSportService.Start
    else
    begin
      Log.Log('FIDISF', log.Ref, '', 'status', 'Module "Fidélité ISF Comarch" non actif', logInfo, True);
      FreeAndNil(FRepriseFideliteComarchInterSportService);
    end;

    FRepriseReservationSkiset := TRepriseReservationSkiset.Create(FDataBaseFile);
    if FRepriseReservationSkiset.CanExecute then
      FRepriseReservationSkiset.Start
    else
    begin
      log.Log('WSSKISET', log.Ref, '', 'status', 'Module "Réservation Skiset" non actif', logInfo, True);
      FreeAndNil(FRepriseReservationSkiset);
    end;

    FRepriseCCGlobalPOSService := TRepriseCCGlobalPOSService.Create(FDataBaseFile);
    if FRepriseCCGlobalPOSService.CanExecute then
      FRepriseCCGlobalPOSService.Start
    else
    begin
      log.Log('CARTECADEAU', log.Ref, '', 'status', 'Module "CARTECADEAU" non actif', logInfo, True);
      FreeAndNil(FRepriseCCGlobalPOSService);
    end;

    FRepriseFideliteSport2000 := TRepriseFideliteSport2000.Create(FDataBaseFile);
    if FRepriseFideliteSport2000.CanExecute then
      FRepriseFideliteSport2000.Start
    else
    begin
      log.Log('FIDSPORT2000', log.Ref, '', 'status', 'Module "FIDELITE SPORT2000" non actif', logInfo, True);
      FreeAndNil(FRepriseFideliteSport2000);
    end;

    FRepriseMarketPlaceSport2000 := TRepriseMarketPlaceSport2000Service.Create(FDataBaseFile);
    if FRepriseMarketPlaceSport2000.CanExecute then
      FRepriseMarketPlaceSport2000.Start
    else
    begin
      log.Log('MP-SP2K', log.Ref, '', 'status', 'Module "MARKET PLACE SPORT2000" non actif', logInfo, True);
      FreeAndNil(FRepriseMarketPlaceSport2000);
    end;

    FRepriseCCIllicadoService := TRepriseCCIllicadoService.Create(FDataBaseFile);
    if FRepriseCCIllicadoService.CanExecute then
      FRepriseCCIllicadoService.Start
    else
    begin
      log.Log('CARTECADEAU', log.Ref, '', 'status', 'Module "CARTECADEAU_GLOBALPOS_ILLICADO" non actif', logInfo, True);
      FreeAndNil(FRepriseCCIllicadoService);
    end;
  except
    on E: Exception do
      LogMessage(E.message);
  end;
end;

procedure TGinkoiaServiceReprises.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
  ServiceStopShutDown;
end;

procedure TGinkoiaServiceReprises.ServiceStopShutDown;
begin
  if Assigned(FRepriseChequeCadeauService) then
  begin
    FRepriseChequeCadeauService.Terminate;
    FRepriseChequeCadeauService.WaitFor;

    FreeAndNil(FRepriseChequeCadeauService);
  end;

  if Assigned(FRepriseFideliteInterSportService) then
  begin
    FRepriseFideliteInterSportService.Terminate;
    FRepriseFideliteInterSportService.WaitFor;

    FreeAndNil(FRepriseFideliteInterSportService);
  end;

  if Assigned(FRepriseFideliteComarchInterSportService) then
  begin
    FRepriseFideliteComarchInterSportService.Terminate;
    FRepriseFideliteComarchInterSportService.WaitFor;

    FreeAndNil(FRepriseFideliteComarchInterSportService);
  end;

  if Assigned(FRepriseReservationSkiset) then
  begin
    FRepriseReservationSkiset.Terminate;
    FRepriseReservationSkiset.WaitFor;

    FreeAndNil(FRepriseReservationSkiset);
  end;

  if Assigned(FRepriseCCGlobalPOSService) then
  begin
    FRepriseCCGlobalPOSService.Terminate;
    FRepriseCCGlobalPOSService.WaitFor;

    FreeAndNil(FRepriseCCGlobalPOSService);
  end;

  if Assigned(FRepriseFideliteSport2000) then
  begin
    FRepriseFideliteSport2000.Terminate;
    FRepriseFideliteSport2000.WaitFor;

    FreeAndNil(FRepriseFideliteSport2000);
  end;

  if Assigned(FRepriseMarketPlaceSport2000) then
  begin
    FRepriseMarketPlaceSport2000.Terminate;
    FRepriseMarketPlaceSport2000.WaitFor;

    FreeAndNil(FRepriseMarketPlaceSport2000);
  end;

  if Assigned(FRepriseCCIllicadoService) then
  begin
    FRepriseCCIllicadoService.Terminate;
    FRepriseCCIllicadoService.WaitFor;

    FreeAndNil(FRepriseCCIllicadoService);
  end;
end;

end.

