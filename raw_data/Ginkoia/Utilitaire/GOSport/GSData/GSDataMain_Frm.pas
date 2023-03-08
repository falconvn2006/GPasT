unit GSDataMain_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, StdCtrls, ComCtrls, ActnList, ExtCtrls, CategoryButtons,  GSData_MainClass,
  Grids, DBGrids, MidasLib, DbClient, GSData_TErreur, GSData_TNomenclature,
  GSDataMain_DM, GSDataImport_DM, GSDataCFG_Frm, GSData_Types, GSDataDbCfg_DM,
   Buttons, Generics.Collections, IBODataset, StrUtils,DateUtils, Types, UVersion,
  Menus, RzButton, LMDPNGImage;

type
  Tfrm_GSDataMain = class(TForm)
    CategoryButtons1: TCategoryButtons;
    Pan_ALL: TPanel;
    Pan_Top: TPanel;
    Pan_Client: TPanel;
    Pan_Bottom: TPanel;
    ActLst_Btn: TActionList;
    Gbx_Dossiers: TGroupBox;
    Gbx_Logs: TGroupBox;
    ProgressBar1: TProgressBar;
    Lab_Progress: TLabel;
    mmLogs: TMemo;
    Ax_BtnImport: TAction;
    Ax_BtnActiveTimer: TAction;
    Ax_BtnStopTimer: TAction;
    Ax_BtnParams: TAction;
    Ds_Dossiers: TDataSource;
    DBGrid1: TDBGrid;
    dbgridDebug: TDBGrid;
    Ds_Debug: TDataSource;
    cbo_cds: TComboBox;
    Tim_Auto: TTimer;
    Ax_BtnExport: TAction;
    TrayIcon: TTrayIcon;
    popMenu: TPopupMenu;
    mnuOpen: TMenuItem;
    N1: TMenuItem;
    mnuClose: TMenuItem;
    Ax_BtnExtract: TAction;
    Ax_BtnWebService: TAction;
    Lab_NbErr: TLabel;
    Ax_BtnPXADATE: TAction;
    ds_cds_Dossiers: TDataSource;
    ds_cds_Magasin: TDataSource;
    ds_cds_Horaire: TDataSource;
    ds_cds_Fichier: TDataSource;
    CPG_ClientDataSet: TCategoryPanelGroup;
    CPan_Fichier: TCategoryPanel;
    DBGrid4: TDBGrid;
    CPan_HorFic: TCategoryPanel;
    DBGrid10: TDBGrid;
    CPan_Horaire: TCategoryPanel;
    DBGrid5: TDBGrid;
    CPan_Magasin: TCategoryPanel;
    DBGrid3: TDBGrid;
    CPan_Dossiers: TCategoryPanel;
    DBGrid2: TDBGrid;
    ds_cds_HorFic: TDataSource;
    Img_Connection: TImage;
    Ax_BtnExportMagasin: TAction;
    Ax_BtnImportMagasin: TAction;
    procedure Ax_BtnParamsExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Ax_BtnImportExecute(Sender: TObject);
    procedure cbo_cdsChange(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Tim_AutoTimer(Sender: TObject);
    procedure Ax_BtnActiveTimerExecute(Sender: TObject);
    procedure Ax_BtnStopTimerExecute(Sender: TObject);
    procedure Ax_BtnExportExecute(Sender: TObject);
    procedure ActLst_BtnExecute(Action: TBasicAction; var Handled: Boolean);
    procedure TrayIconDblClick(Sender: TObject);
    procedure mnuOpenClick(Sender: TObject);
    procedure mnuCloseClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Ax_BtnExtractExecute(Sender: TObject);
    procedure Ax_BtnWebServiceExecute(Sender: TObject);
    procedure Ax_BtnPXADATEExecute(Sender: TObject);
    procedure Ax_BtnExportMagasinExecute(Sender: TObject);
    procedure Ax_BtnImportMagasinExecute(Sender: TObject);
  private
    { Déclarations privées }

    vgClassNomenclature : TNomenclature;
    AppHandle : THandle;

    procedure Debugmode;

    procedure ListFileFromDir( ADir : String; Lst : TStringList; ADateMax : TDateTime);

    procedure Archivage;
    // fonction de vérification si le logiciel est déjà démarré
    function IsPrevInstance: Boolean;
  public
    { Déclarations publiques }
  end;

var
  frm_GSDataMain: Tfrm_GSDataMain;

implementation

uses
  GSDataExport_DM, uLog,
  ShellAPI;

{$R *.dfm}

procedure Tfrm_GSDataMain.Archivage;
var
  lstFile : TStringList;
  i : Integer;
begin
  lstFile := TStringList.Create;
  With DM_GSDataMain do
  try
    Try
      // récupération des fichiers à archiver
      ListFileFromDir(GAPPRAPPORT,lstFile,(Now - IniStruct.Archivage.NbJours));
      ListFileFromDir(GAPPDOSSIER,lstFile,(Now - IniStruct.Archivage.NbJours));
      ListFileFromDir(GAPPPATH + 'Logs\',lstFile,(Now - IniStruct.Archivage.NbJours));

      if lstFile.Count > 0 then
      begin
        // Zip des fichiers
        ZipMaster191.ZipFileName := GARCHIVAGEDIR + 'Zip-' + FormatDateTime('YYYYMMDDhhmmsszzz',Now);
        for i := 0 to lstFile.Count -1 do
          ZipMaster191.FSpecArgs.Add(lstFile[i]);

        ZipMaster191.Add;

        // Suppression des fichiers archivés
//        for i := 0 to lstFile.Count -1 do
//          DeleteFile(lstFile[i]);

      end;
      // Calcul du prochain archivage
      IniStruct.Archivage.NextArch := Now + 7;
      IniStruct.SaveIni;
    Except on E:Exception do
      AddToMemo('Archivage -> ' + E.Message);
    End;
  finally
    lstFile.Free;
  end;
end;

procedure Tfrm_GSDataMain.ActLst_BtnExecute(Action: TBasicAction;
  var Handled: Boolean);
begin
  Handled := GWORKINPROGRESS;
end;

procedure Tfrm_GSDataMain.Ax_BtnActiveTimerExecute(Sender: TObject);
begin
  if not Tim_Auto.Enabled then
    Log.Log( '', 'Main', '', '', '', 'Automation', 'Enabled', logInfo, True, 0, DM_GSDataMain.LogType );

  GSTOPTIME := False;
  Tim_Auto.Enabled := True;
end;

procedure Tfrm_GSDataMain.Ax_BtnExportExecute(Sender: TObject);
begin
  Tim_Auto.Enabled := False;
  GWORKINPROGRESS := True;
  Try
    Dm_GSDataMain.ExportFiles(etEveryStores);//true, True);
  Finally
    GWORKINPROGRESS := False;
    Tim_Auto.Enabled := not GSTOPTIME;
  End;
end;

procedure Tfrm_GSDataMain.Ax_BtnExportMagasinExecute(Sender: TObject);
begin
  Tim_Auto.Enabled := False;
  GWORKINPROGRESS := True;
  Try
    Dm_GSDataMain.ExportFiles(etSelectStores);
  Finally
    GWORKINPROGRESS := False;
    Tim_Auto.Enabled := not GSTOPTIME;
  End;
end;

procedure Tfrm_GSDataMain.Ax_BtnExtractExecute(Sender: TObject);
begin
  //Procédure servant à l'extraction des offres de réduction
  Tim_Auto.Enabled   := False;
  GWORKINPROGRESS    := True;
  try
    DM_GSDataMain.ExecuteProcessExtract(true);
  finally
    GWORKINPROGRESS  := False;
    Tim_Auto.Enabled := not GSTOPTIME;
  end;
end;

procedure Tfrm_GSDataMain.Ax_BtnImportExecute(Sender: TObject);
begin
  Tim_Auto.Enabled := False;
  GWORKINPROGRESS := True;
  Try
    DM_GSDataMain.ExecuteProcessImport( True );
  Finally
   GWORKINPROGRESS := False;
    Tim_Auto.Enabled := not GSTOPTIME;
  End;
end;

procedure Tfrm_GSDataMain.Ax_BtnImportMagasinExecute(Sender: TObject);
begin
  Tim_Auto.Enabled := False;
  GWORKINPROGRESS := True;
  try
    DM_GSDataMain.ExecuteProcessImport(true, false);
  finally
    GWORKINPROGRESS := False;
    Tim_Auto.Enabled := not GSTOPTIME;
  end;
end;

procedure Tfrm_GSDataMain.Ax_BtnParamsExecute(Sender: TObject);
begin
  With Tfrm_GSDataCfg.Create(Self) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure Tfrm_GSDataMain.Ax_BtnPXADATEExecute(Sender: TObject);
begin
  // Mantis [Ginkoia 0000389]
  DM_GSDataMain.InitPxADate;
end;

procedure Tfrm_GSDataMain.Ax_BtnStopTimerExecute(Sender: TObject);
begin
  if Tim_Auto.Enabled then
    Log.Log( '', 'Main', '', '', '', 'Automation', 'Disabled', logWarning, True, 0, DM_GSDataMain.LogType );

  GSTOPTIME := True;
  Tim_Auto.Enabled := False;
  Lab_Progress.Visible := True;
  Lab_Progress.Caption := 'Déclenchement automatique stoppé';
  TrayIcon.Hint := Format('GsData - ID : %s - %s',[IniStruct.Others.IdGsData, Lab_Progress.Caption]);
end;

procedure Tfrm_GSDataMain.Ax_BtnWebServiceExecute(Sender: TObject);
begin
  Tim_Auto.Enabled := False;
  GWORKINPROGRESS := True;
  Try
    DM_GSDataMain.ExecuteProcessWebService(true);
  Finally
    GWORKINPROGRESS := False;
    Tim_Auto.Enabled := not GSTOPTIME;
  End;
end;

procedure Tfrm_GSDataMain.cbo_cdsChange(Sender: TObject);
begin
  Ds_Debug.DataSet := TClientDataset(DM_GSDataImport.FindComponent(cbo_cds.Text));
end;

procedure Tfrm_GSDataMain.Debugmode;
var
  i : Integer;
begin
  if Not IniStruct.DebugMode then
    Exit;

  With DM_GSDataImport do
  begin
    cbo_cds.Clear;
    for i := 0 to ComponentCount -1 do
      if Components[i] is TclientDataset then
        cbo_cds.Items.Add(Components[i].Name);
  end;

  cbo_cds.Visible := True;
  dbgridDebug.Visible := True;
  CPG_ClientDataSet.Visible := True;
end;

procedure Tfrm_GSDataMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  GERREURS.Free;
  IniStruct.FreeObject;
  DM_GsDataDbCfg.Free;
  DM_GSDataImport.Free;
  DM_GSDataMain.Free;
end;

procedure Tfrm_GSDataMain.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  TrayIcon.Hint := Format('GsData - ID : %s',[IniStruct.Others.IdGsData]);
  TrayIcon.Visible := True;
  Hide;
  CanClose := not GWORKINPROGRESS and DoCloseApp;
end;

procedure Tfrm_GSDataMain.FormCreate(Sender: TObject);
begin
  DoCloseApp := False;

  vgIteration := 0;    // CBR à virer - pour les tests

  // Initialisation des variables globales
  GAPPPATH := ExtractFilePath(Application.ExeName);
  GAPPNAME := ExtractFileName(Application.ExeName);
  GAPPFILE := GAPPPATH + 'Files\';
  GAPPFTP  := GAPPPATH + 'FTP\';
  GAPPRAPPORT := GAPPPATH + 'Rapports\';
  GAPPDOSSIER := GAPPPATH + 'Dossiers\';
  GARCHIVAGEDIR := GAPPPATH + 'Archives\';
  GERREURS := TList<TErreur>.Create;

  // Création des répertoires s'il n'existe pas
  DoDir(GAPPFILE);
  DoDir(GAPPFTP);
  DoDir(GAPPRAPPORT);
  DoDir(GAPPDOSSIER);
  DoDir(GARCHIVAGEDIR);

  // Chargement du fichier Ini
  IniStruct.LoadIni;

  // Création des DM
  DM_GSDataMain := TDM_GSDataMain.Create(Self);
  DM_GSDataMain.Memo := mmLogs;
  DM_GSDataMain.LabelMain := Lab_Progress;
  DM_GSDataMain.ProgressBMain := ProgressBar1;
  DM_GSDataMain.LabelError    := Lab_NbErr ;
  DM_GSDataImport := TDM_GSDataImport.Create(Self);
  DM_GSDataExport := TDM_GSDataExport.Create(Self);
  DM_GsDataDbCfg := TDM_GsDataDbCfg.Create(Self);

  Log.Log( '', 'Main', '', '', '', 'Version', GetNumVersionSoft, logInfo, True, 0, DM_GSDataMain.LogType );
  Log.Log( '', 'Main', '', '', '', 'Automation', 'Enabled', logInfo, True, 0, DM_GSDataMain.LogType );

  // connexion à la base de données de configuration des bases
  With DM_GsDataDbCfg do
  begin
    if ConnectToDbCfg(IniStruct.BasePath) then
    begin
      cds_Dossiers.ChangeFilter( 'DOS_IDGS = %s', [ QuotedStr( IniStruct.Others.IdGsData ) ] );
    end;
  end;

  DebugMode;

  GSTARTTIME := Now;
  GSTOPTIME := False;
  GWORKINPROGRESS := False;

  Caption := Format('Module de communication GOSport - Id : %s - Version %s',[IniStruct.Others.IdGsData, GetNumVersionSoft]);
  Application.Title := Format('Module de communication GOSport - Id : %s',[IniStruct.Others.IdGsData]);
  if not IsPrevInstance then
  begin
    if not DM_GSDataMain.BypassInstance then
    begin
      DoCloseApp := True;
      Application.Terminate;
    end;
  end;
end;

procedure Tfrm_GSDataMain.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(Key) = VK_Escape then
    Close;
end;

function Tfrm_GSDataMain.IsPrevInstance: Boolean;
var
  Erreur: Integer;
begin
  Result := False;
  SetLastError(NO_ERROR);
  AppHandle := CreateMutex (nil, False, PWideChar(Application.Title));
  Erreur := GetLastError;
  if ( Erreur = ERROR_ALREADY_EXISTS ) or ( Erreur = ERROR_ACCESS_DENIED ) then
    Exit;
  Result := True;
end;

procedure Tfrm_GSDataMain.ListFileFromDir(ADir: String; Lst : TStringList; ADateMax : TDateTime);
var
  i : Integer;
  FSearch : TSearchRec;
begin
  i := FindFirst(ADir + '*.*',faAnyFile,FSearch);
  try
    while i = 0 do
    begin
      if (FSearch.Name <> '.') and (FSearch.Name <> '..') then
      begin
        if (FSearch.Attr = faDirectory) then
          ListFileFromDir(ADir + IncludeTrailingPathDelimiter(FSearch.Name),Lst, ADateMax)
        else begin
          if FSearch.TimeStamp < ADateMax then
            lst.Add(ADir + FSearch.Name);
        end;
      end;

      i := FindNext(FSearch);
    end
  finally
    Findclose(FSearch);
  end;
end;

procedure Tfrm_GSDataMain.mnuCloseClick(Sender: TObject);
begin
  DoCloseApp := True;
  Close;
end;

procedure Tfrm_GSDataMain.mnuOpenClick(Sender: TObject);
begin
  Show;
  TrayIcon.Visible := False;
end;

procedure Tfrm_GSDataMain.Tim_AutoTimer(Sender: TObject);
var
  tmp, Next : TDateTime;

  diff : Int64;
  sParam : string;
  i : Integer;
  si : TStartUpInfo;
  pi : TProcessInformation ;
begin

  tmp := Now();
  Next := DM_GsDataDbCfg.SeekNextHoraireFor(tmp, GSTARTTIME, IniStruct.Others.Timer);

  if Next = tmp then
  begin
    GSTARTTIME := Now;
    Lab_Progress.Visible := False;

    Tim_Auto.Enabled := False;
    Log.Log( '', 'Main', '', '', '', 'Status', 'Ok', logInfo, True, IniStruct.Others.Timer * 60, DM_GSDataMain.LogType );
    case DM_GsDataDbCfg.cds_Horaire.FieldByName('hor_type').AsInteger of
      1: DM_GSDataMain.ExecuteProcessImport();
      2: Dm_GSDataMain.ExportFiles(etAuto);
      3: DM_GSDataMain.ExecuteProcessExtract();
      4: DM_GSDataMain.ExecuteProcessWebService();
    end;

    // Archivage des données
    if CompareDate(Now,IniStruct.Archivage.NextArch) = EqualsValue then
      Archivage;

    if (DM_GSDataMain.RestartNeed) then
    begin
      sParam := ' /RESTART';
      for i := 1 to ParamCount do
        sParam := sParam + ' ' + ParamStr(i);

      ZeroMemory(@si, SizeOf(TStartUpInfo));
      si.cb := SizeOf(TStartUpInfo);
      si.dwFlags     := STARTF_USESTDHANDLES + STARTF_USESHOWWINDOW;
      si.wShowWindow := SW_SHOW ;

      DM_GSDataMain.AddToMemo('Fermeture et relance du programme suite à un probleme de connexion');
      if (CreateProcess(PChar(ParamStr(0)), PChar(ParamStr(0) + sParam), nil, nil, False, 0, nil, PChar(ExtractFilePath(ParamStr(0))), si, pi)) then
      begin
        Log.Log( '', 'Main', '', '', '', 'Status', 'Relance du programme apres traitement auto', logInfo, false, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
        Sleep(3000);
        TerminateProcess(GetCurrentProcess, 777);
      end
      else
      begin
        Log.Log( '', 'Main', '', '', '', 'Status', 'Erreur lors de la relance de l''exe apres traitement', logError, false, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
      end;
    end;

    Tim_Auto.Enabled := not GSTOPTIME;
  end
  else
  begin
    diff := MinutesBetween(Next, tmp);
    if (diff > 0) and (diff <= 5) and (DM_GSDataMain.RestartNeed) then
    begin
      DM_GSDataMain.RestartNeed := False;
      sParam := ' /RESTART';
      for i := 1 to ParamCount do
      begin
        if (ParamStr(i) <> '/RESTART') then
          sParam := sParam + ' ' + ParamStr(i);
      end;

      ZeroMemory(@si, SizeOf(TStartUpInfo));
      si.cb := SizeOf(TStartUpInfo);
      si.dwFlags     := STARTF_USESTDHANDLES + STARTF_USESHOWWINDOW;
      si.wShowWindow := SW_SHOW ;

      DM_GSDataMain.AddToMemo('Fermeture et relance du programme suite à un probleme de connexion');
      if (CreateProcess(PChar(ParamStr(0)), PChar(ParamStr(0) + sParam), nil, nil, False, 0, nil, PChar(ExtractFilePath(ParamStr(0))), si, pi)) then
      begin
        Log.Log( '', 'Main', '', '', '', 'Status', 'Relance du programme avant traitement auto', logInfo, false, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
        Sleep(3000);
        TerminateProcess(GetCurrentProcess, 777);
      end
      else
      begin
        Log.Log( '', 'Main', '', '', '', 'Status', 'Erreur lors de la relance de l''exe avant traitement', logError, false, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
      end;
    end;
    Lab_Progress.Caption := Format('Prochain déclenchement dans : %s', [LeftStr(FormatMS(MilliSecondsBetween(tmp, Next)),8)]);
    TrayIcon.Hint := Format('GsData - ID : %s - %s',[IniStruct.Others.IdGsData, Lab_Progress.Caption]);
    Lab_Progress.Visible := True;
  end;
end;

procedure Tfrm_GSDataMain.TrayIconDblClick(Sender: TObject);
begin
  Show;
  TrayIcon.Visible := False;
end;

end.
