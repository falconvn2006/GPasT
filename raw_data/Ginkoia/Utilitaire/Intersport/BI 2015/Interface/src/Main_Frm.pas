unit Main_Frm;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.Buttons,
  Vcl.ExtCtrls,
  Vcl.Samples.Spin,
  Vcl.ComCtrls;

type
  Tfrm_Main = class(TForm)
    lbl_BaseGnk: TLabel;
    lbl_BaseTpn: TLabel;
    edt_BaseGnk: TEdit;
    edt_BaseTpn: TEdit;
    btn_BaseGnk: TSpeedButton;
    btn_Quitter: TButton;
    btn_Parametrage: TButton;
    btn_Aide: TButton;
    pnl_StopTrt: TGridPanel;
    btn_Stop: TButton;
    btn_Kill: TButton;
    pnl_Sep1: TPanel;
    Panel1: TPanel;
    lbl_NomClient: TLabel;
    lbl_NomSiteReplique: TLabel;
    pnl_Service: TGridPanel;
    chk_Service: TCheckBox;
    pgc_TypeControl: TPageControl;
    ts_SimpleTraitements: TTabSheet;
    ts_AdvancedTraitements: TTabSheet;
    pnl_AdvancedTraitements: TGridPanel;
    pnl_GestionBase: TPanel;
    btn_CreationBase: TButton;
    btn_NettoyageBase: TButton;
    btn_MajBase: TButton;
    pnl_GestionTraitement: TPanel;
    btn_Initialisation: TButton;
    btn_DeltaExtract: TButton;
    pnl_GestionReset: TPanel;
    pnl_SimpleTraitements: TGridPanel;
    btn_SmpInitialisation: TButton;
    btn_SmpResetStock: TButton;
    btn_ResetStock: TButton;
    cbx_NivLog: TComboBox;
    btn_TraitementManuel: TButton;
    chk_Magasins: TCheckBox;
    grp_Type: TGroupBox;
    GridPanel1: TGridPanel;
    rb_Delta: TRadioButton;
    rb_Complet: TRadioButton;
    rb_ReInit: TRadioButton;
    chk_Tickets: TCheckBox;
    chk_Factures: TCheckBox;
    chk_Mouvements: TCheckBox;
    grp_Stock: TGroupBox;
    chk_HistoStk: TCheckBox;
    chk_ResetStk: TCheckBox;
    lst_Magasins: TListBox;
    lbl_Magasins: TLabel;
    btn_Purges: TButton;
    chk_Commandes: TCheckBox;
    chk_Receptions: TCheckBox;
    chk_Retours: TCheckBox;
    chk_Fournisseurs: TCheckBox;
    btn_DeltaImport: TButton;
    GridPanel2: TGridPanel;
    btn_SmpDeltaExtract: TButton;
    btn_SmpDeltaImport: TButton;
    lbl_NbYearVte: TLabel;
    sed_NbYearVte: TSpinEdit;
    lbl_NbYearMvt: TLabel;
    sed_NbYearMvt: TSpinEdit;
    lbl_NbYearCmd: TLabel;
    sed_NbYearCmd: TSpinEdit;
    lbl_NbYearRap: TLabel;
    sed_NbYearRap: TSpinEdit;
    lbl_NbYearStk: TLabel;
    sed_NbYearStk: TSpinEdit;
    chk_Articles: TCheckBox;
    chk_Collections: TCheckBox;
    chk_Exercices: TCheckBox;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);

    procedure edt_BaseGnkChange(Sender: TObject);
    procedure btn_BaseGnkClick(Sender: TObject);

    procedure btn_CreationBaseClick(Sender: TObject);
    procedure btn_MajBaseClick(Sender: TObject);
    procedure btn_NettoyageBaseClick(Sender: TObject);

    procedure btn_SmpInitialisationClick(Sender: TObject);
    procedure btn_InitialisationClick(Sender: TObject);
    procedure btn_DeltaExtractClick(Sender: TObject);
    procedure btn_ResetStockClick(Sender: TObject);
    procedure btn_PurgesClick(Sender: TObject);

    procedure btn_TraitementManuelClick(Sender: TObject);

    procedure btn_ParametrageClick(Sender: TObject);
    procedure btn_AideClick(Sender: TObject);
    procedure btn_StopClick(Sender: TObject);
    procedure btn_KillClick(Sender: TObject);
    procedure chk_ServiceClick(Sender: TObject);

    procedure btn_QuitterClick(Sender: TObject);
    procedure btn_DeltaImportClick(Sender: TObject);
    procedure btn_ReinitialisationClick(Sender: TObject);
  private
    { Déclarations privées }
    FExtractName, FImportName : string;
    FExtractPrc, FImportPrc : THandle;
    FLoading : boolean;
    FIsDebug : boolean;
    FTimeReset : TTime;

    // Gestion du traitement !!
    function TraitementExtract(Param : string) : THandle;
    function TraitementImport(Param : string) : THandle;
    // Gestion de l'interface
    procedure GestionInterface(Enabled : Boolean);
    function CanConnect(Serveur, DataBaseFile : string) : boolean;
    function GetInfosBase(DataBaseFile : string; var ClientName, SiteName, BaseTpn : string; var MinVte, MinMvt, MinCmd, MinRap, MinStk : integer; var TimeReset : TTime; var IsSiteRappro : boolean; var ListeMagasin : TStringList) : boolean;
    // gestion du drag and drop
    procedure MessageDropFiles(var msg : TWMDropFiles); message WM_DROPFILES;

    // boite de dialogue
    function MessageDlg(const Msg : string; DlgType : TMsgDlgType; Buttons : TMsgDlgButtons) : Integer;
  public
    { Déclarations publiques }
    procedure MyExtractPrcNotify(Resultat : Cardinal; Error : string);
    procedure MyImportPrcNotify(Resultat : Cardinal; Error : string);
  end;

var
  frm_Main: Tfrm_Main;

implementation

uses
  System.Math,
  System.DateUtils,
  System.UITypes,
  System.Win.Registry,
  Winapi.ShellAPI,
  Winapi.WinSvc,
  FireDAC.Comp.Client,
  Vcl.Clipbrd,
  LaunchProcess,
  uGestionBDD,
  uMessage,
  Param_Frm,
  uGetWindowsList,
  UVersion,
  ServiceControler;

{$R *.dfm}

const
  EXTRACT_NAME = 'ExtractBI.exe';
  IMPORT_NAME = 'ImportBI.exe';
  POS_MARGIN = 50;
  SERVICE_NAME = 'Service_BI_Ginkoia';
  SERVICE_TIME = 5 * 60 * 1000; // 5 minutes

{ Tfrm_Main }

procedure Tfrm_Main.FormCreate(Sender: TObject);
var
  i : integer;
  Reg : TRegistry;
  PrcInfo : TProcessInfo;
begin
  // Gestion du drag ans drop
  DragAcceptFiles(Handle, True);

  // version ?
  Caption := Caption + ' (v' + GetNumVersionSoft() + ')';

  FIsDebug := false;
  for i := 1 to ParamCount() do
  begin
    if UpperCase(Trim(ParamStr(i))) = 'DEBUG' then
      FIsDebug := true;
  end;

  // recherche de la base
  try
    Reg := TRegistry.Create(KEY_READ);
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKeyReadOnly('\Software\Algol\Ginkoia\') then
    begin
      if FileExists(Reg.ReadString('Base0')) then
      begin
        edt_BaseGnk.Text := Reg.ReadString('Base0');
        if FileExists(ExtractFilePath(edt_BaseGnk.Text) + 'Tampon.ib') then
          edt_BaseTpn.Text := ExtractFilePath(edt_BaseGnk.Text) + 'Tampon.ib';
      end;
    end;
  finally
    FreeAndNil(Reg);
  end;

  // programme d'extraction
  PrcInfo := FindProcess(EXTRACT_NAME);
  if PrcInfo.PID = 0 then
  begin
    // executable ?
    if FileExists(ExtractFilePath(ParamStr(0)) + EXTRACT_NAME) then
      FExtractName := ExtractFilePath(ParamStr(0)) + EXTRACT_NAME
    else if FileExists(ExtractFilePath(ParamStr(0)) + '..\..\..\ExtractBI\Win32\Debug\' + EXTRACT_NAME) then
      FExtractName := ExtractFilePath(ParamStr(0)) + '..\..\..\ExtractBI\Win32\Debug\' + EXTRACT_NAME;
    FExtractName := ExpandFileName(FExtractName);
  end
  else
  begin
    FExtractName := PrcInfo.Cmd;
    FExtractPrc := OpenProcess(PROCESS_TERMINATE or PROCESS_QUERY_INFORMATION or SYNCHRONIZE, true, PrcInfo.PID);
    if not (FExtractPrc = 0) then
      NotifyEndOfProcess(FExtractPrc, MyExtractPrcNotify);
  end;

  // programme d'import
  PrcInfo := FindProcess(IMPORT_NAME);
  if PrcInfo.PID = 0 then
  begin
    // executable ?
    if FileExists(ExtractFilePath(ParamStr(0)) + IMPORT_NAME) then
      FImportName := ExtractFilePath(ParamStr(0)) + IMPORT_NAME
    else if FileExists(ExtractFilePath(ParamStr(0)) + '..\..\..\ImportBI\Win32\Debug\' + IMPORT_NAME) then
      FImportName := ExtractFilePath(ParamStr(0)) + '..\..\..\ImportBI\Win32\Debug\' + IMPORT_NAME;
    FImportName := ExpandFileName(FImportName);
  end
  else
  begin
    FImportName := PrcInfo.Cmd;
    FImportPrc := OpenProcess(PROCESS_TERMINATE or PROCESS_QUERY_INFORMATION or SYNCHRONIZE, true, PrcInfo.PID);
    if not (FImportPrc = 0) then
      NotifyEndOfProcess(FImportPrc, MyImportPrcNotify);
  end;

  // le service ??
  try
    FLoading := true;
    if ServiceExist('', SERVICE_NAME) then
    begin
      if ServiceGetStatus('', SERVICE_NAME) = SERVICE_RUNNING then
        chk_Service.State := cbChecked
      else
        chk_Service.State := cbUnchecked;
    end
    else
      chk_Service.State := cbGrayed;
  finally
    FLoading := false;
  end;

  // Gestion de l'interface !
  GestionInterface((FExtractPrc = 0) or (FImportPrc = 0));
end;

procedure Tfrm_Main.FormShow(Sender: TObject);
begin
  if FIsDebug then
    pgc_TypeControl.ActivePage := ts_AdvancedTraitements
  else
    pgc_TypeControl.ActivePage := ts_SimpleTraitements;
  Constraints.MinHeight := IfThen(FIsDebug, 556, 270);
  Height := Constraints.MinHeight;
end;

procedure Tfrm_Main.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := btn_Quitter.Enabled;
end;

procedure Tfrm_Main.FormDestroy(Sender: TObject);
begin
  // eurf
end;

// evenement

procedure Tfrm_Main.edt_BaseGnkChange(Sender: TObject);
begin
  GestionInterface(True);
end;

procedure Tfrm_Main.btn_BaseGnkClick(Sender: TObject);
var
  Open : TOpenDialog;
begin
  try
    Open := TOpenDialog.Create(Self);
    Open.FileName := ExtractFileName(edt_BaseGnk.Text);
    Open.InitialDir := ExtractFilePath(edt_BaseGnk.Text);
    Open.Filter := 'IB Database|*.IB';
    Open.FilterIndex := 0;
    Open.DefaultExt := 'IB';
    edt_BaseGnk.Text := '';
    if Open.Execute() then
      edt_BaseGnk.Text := Open.FileName;
  finally
    FreeAndNil(Open);
  end;
end;

// lancement de traitement !

procedure Tfrm_Main.btn_CreationBaseClick(Sender: TObject);
var
  Params : string;
begin
  GestionInterface(false);
  Params := '-CreateBase';
  FExtractPrc := TraitementExtract(Params);
end;

procedure Tfrm_Main.btn_MajBaseClick(Sender: TObject);
var
  Params : string;
begin
  GestionInterface(false);
  Params := '-UpdateBase';
  FExtractPrc := TraitementExtract(Params);
end;

procedure Tfrm_Main.btn_NettoyageBaseClick(Sender: TObject);
var
  Params : string;
begin
  GestionInterface(false);
  Params := '-ClearBase';
  FExtractPrc := TraitementExtract(Params);
end;

procedure Tfrm_Main.btn_SmpInitialisationClick(Sender: TObject);
var
  Params, error : string;
  Resultat : Cardinal;
begin
  GestionInterface(false);

  if not FileExists(edt_BaseTpn.Text) then
  begin
    if (not (FExtractName = '')) and FileExists(FExtractName) then
    begin
      Params := '-LogLevel:' + cbx_NivLog.Text + ' -NbYearMvt:' + IntToStr(sed_NbYearMvt.Value) + ' -NbYearStk:' + IntToStr(sed_NbYearStk.Value) + ' -BaseGin:"' + edt_BaseGnk.Text + '" -BaseTpn:"' + edt_BaseTpn.Text + '" -CreateBase';
      Resultat := ExecAndWaitProcess(error, FExtractName, Params);
      if Resultat <> 0 then
      begin
        MessageDlg('Erreur lors du traitement (code : ' + IntToStr(Resultat) +') : ' + Error, mtError, [mbOK]);
        GestionInterface(true);
        Exit;
      end;
    end
    else
    begin
      MessageDlg('Erreur lors du traitement (code : ' + IntToStr(High(Cardinal)) +') : Executable non trouvé', mtError, [mbOK]);
      GestionInterface(true);
      Exit;
    end;
  end;

  Params := '-Init';
  FExtractPrc := TraitementExtract(Params);
end;

procedure Tfrm_Main.btn_InitialisationClick(Sender: TObject);
var
  Params : string;
begin
  GestionInterface(false);
  Params := '-Init';
  FExtractPrc := TraitementExtract(Params);
end;

procedure Tfrm_Main.btn_ReinitialisationClick(Sender: TObject);
begin
  // eurf
end;

procedure Tfrm_Main.btn_DeltaExtractClick(Sender: TObject);
var
  Params : string;
begin
  GestionInterface(false);
  Params := '-Delta';
  FExtractPrc := TraitementExtract(Params);
end;

procedure Tfrm_Main.btn_DeltaImportClick(Sender: TObject);
var
  Params : string;
begin
  GestionInterface(false);
  Params := '-ImpRapp';
  FImportPrc := TraitementImport(Params);
end;

procedure Tfrm_Main.btn_ResetStockClick(Sender: TObject);
var
  Params : string;
begin
  GestionInterface(false);
  // Tous les jours (+15 minutes de battement)
  if Frac(Now()) > FTimeReset then
    Params := Params + ' -ResetStock -LogInterval:' + IntToStr(SecondsBetween(Now(), IncMinute(IncDay(Trunc(Now())) + FTimeReset, 15) ))
  else
    Params := Params + ' -ResetStock -LogInterval:' + IntToStr(SecondsBetween(Now(), IncMinute(Trunc(Now()) + FTimeReset, 15) ));
  FExtractPrc := TraitementExtract(Params);
end;

procedure Tfrm_Main.btn_PurgesClick(Sender: TObject);
var
  Params : string;
begin
  GestionInterface(false);
  Params := '-Purges';
  FExtractPrc := TraitementExtract(Params);
end;


procedure Tfrm_Main.btn_TraitementManuelClick(Sender: TObject);
var
  Params : string;
begin
  GestionInterface(false);
  Params := '';
  if chk_Magasins.Checked then
    Params := Params + ' -GestionMagasins';
  if chk_Exercices.Checked then
    Params := Params + ' -GestionExercices';
  if chk_Collections.Checked then
    Params := Params + ' -GestionCollections';
  if chk_Fournisseurs.Checked then
    Params := Params + ' -GestionFournisseurs';
  if rb_ReInit.Checked then
  begin
    Params := Params + ' -ReInitialisation';
    if chk_Articles.Checked then
      Params := Params + ' -CompletArticles';
    if chk_Tickets.Checked then
      Params := Params + ' -CompletTickets';
    if chk_Factures.Checked then
      Params := Params + ' -CompletFactures';
    if chk_Mouvements.Checked then
      Params := Params + ' -CompletMouvements';
    if chk_Commandes.Checked then
      Params := Params + ' -CompletCommandes';
    if chk_Receptions.Checked then
      Params := Params + ' -CompletReceptions';
    if chk_Retours.Checked then
      Params := Params + ' -CompletRetours';
  end
  else if rb_Complet.Checked then
  begin
    // tout coché
    if chk_Magasins.Checked and chk_Exercices.Checked and chk_Collections.Checked and chk_Fournisseurs.Checked and chk_Articles.Checked and chk_Tickets.Checked and chk_Factures.Checked and chk_Mouvements.Checked and chk_Commandes.Checked and (not chk_Receptions.Enabled or chk_Receptions.Checked) and (not chk_Retours.Enabled or chk_Retours.Checked) then
      Params := '-Init'
    // rien coché
    else if not (chk_Magasins.Checked or chk_Exercices.Checked or chk_Collections.Checked or chk_Fournisseurs.Checked or chk_Articles.Checked or chk_Tickets.Checked or chk_Factures.Checked or chk_Mouvements.Checked or chk_Commandes.Checked or chk_Receptions.Checked or chk_Retours.Checked) then
      Params := '-Init'
    // sinon...
    else
    begin
      if chk_Articles.Checked then
        Params := Params + ' -CompletArticles';
      if chk_Tickets.Checked then
        Params := Params + ' -CompletTickets';
      if chk_Factures.Checked then
        Params := Params + ' -CompletFactures';
      if chk_Mouvements.Checked then
        Params := Params + ' -CompletMouvements';
      if chk_Commandes.Checked then
        Params := Params + ' -CompletCommandes';
      if chk_Receptions.Checked then
        Params := Params + ' -CompletReceptions';
      if chk_Retours.Checked then
        Params := Params + ' -CompletRetours';
    end;
  end
  else if rb_Delta.Checked then
  begin
    // tout coché
    if chk_Magasins.Checked and chk_Exercices.Checked and chk_Collections.Checked and chk_Fournisseurs.Checked and chk_Articles.Checked and chk_Tickets.Checked and chk_Factures.Checked and chk_Mouvements.Checked and chk_Commandes.Checked and (not chk_Receptions.Enabled or chk_Receptions.Checked) and (not chk_Retours.Enabled or chk_Retours.Checked) then
      Params := '-Delta'
    // rien coché
    else if not (chk_Magasins.Checked or chk_Exercices.Checked or chk_Collections.Checked or chk_Fournisseurs.Checked or chk_Articles.Checked or chk_Tickets.Checked or chk_Factures.Checked or chk_Mouvements.Checked or chk_Commandes.Checked or chk_Receptions.Checked or chk_Retours.Checked) then
      Params := '-Delta'
    else
    begin
      if chk_Articles.Checked then
        Params := Params + ' -DeltaArticles';
      if chk_Tickets.Checked then
        Params := Params + ' -DeltaTickets';
      if chk_Factures.Checked then
        Params := Params + ' -DeltaFactures';
      if chk_Mouvements.Checked then
        Params := Params + ' -DeltaMouvements';
      if chk_Commandes.Checked then
        Params := Params + ' -DeltaCommandes';
      if chk_Receptions.Checked then
        Params := Params + ' -DeltaReceptions';
      if chk_Retours.Checked then
        Params := Params + ' -DeltaRetours';
    end;
  end;
  if chk_HistoStk.Checked then
    Params := Params + ' -HistoStock';
  if chk_ResetStk.Checked then
  begin
    // Tous les jours (+15 minutes de battement)
    if Frac(Now()) > FTimeReset then
      Params := Params + ' -ResetStock -LogInterval:' + IntToStr(SecondsBetween(Now(), IncMinute(IncDay(Trunc(Now())) + FTimeReset, 15) ))
    else
      Params := Params + ' -ResetStock -LogInterval:' + IntToStr(SecondsBetween(Now(), IncMinute(Trunc(Now()) + FTimeReset, 15) ));
  end;
  // Gestion des durées de rétentions
  Params := Params + ' -NbYearVte:' + IntToStr(sed_NbYearVte.Value)
                   + ' -NbYearMvt:' + IntToStr(sed_NbYearMvt.Value)
                   + ' -NbYearCmd:' + IntToStr(sed_NbYearCmd.Value)
                   + ' -NbYearRap:' + IntToStr(sed_NbYearRap.Value)
                   + ' -NbYearStk:' + IntToStr(sed_NbYearStk.Value);
  FExtractPrc := TraitementExtract(Params);
end;


procedure Tfrm_Main.btn_ParametrageClick(Sender: TObject);
var
  Password : string;
  HasToRefresh : boolean;
begin
  try
    GestionInterface(false);
    DoParametrage(Self, edt_BaseGnk.Text, HasToRefresh);
  finally
    GestionInterface(true);
  end;
end;

procedure Tfrm_Main.btn_AideClick(Sender: TObject);
var
  ExeParam, Error, Output : string;
  Res : Cardinal;
begin
  try
    GestionInterface(false);

    if (not (FExtractName = '')) and FileExists(FExtractName) then
    begin
      ExeParam := '-?';
      Res := ExecAndWaitProcess(Error, Output, FExtractName, ExeParam);
      if Res = 1 then
      begin
        if MessageDlg(Output + #13#10#13#10 + 'Copier ces information dans le presse-papiers ?', mtInformation, [mbYes, mbNo]) = mrYes then
          Clipboard.AsText := Output;
      end
      else
        MessageDlg('Erreur : ' + Error + #13#10 + Output, mtError, [mbOK]);
    end;
  finally
    GestionInterface(true);
  end;
end;

procedure Tfrm_Main.btn_StopClick(Sender: TObject);
var
  WinInfo : TWindowsInfo;
begin
  if not (FExtractPrc = 0) then
  begin
    WinInfo := FindWindowsByClass(GetProcessId(FExtractPrc), 'Tfrm_Main');
    PostMessage(WinInfo.HWND, WM_ASK_TO_KILL, 0, 0)
  end;
  if not (FImportPrc = 0) then
  begin
    WinInfo := FindWindowsByClass(GetProcessId(FImportPrc), 'Tfrm_Main');
    PostMessage(WinInfo.HWND, WM_ASK_TO_KILL, 0, 0)
  end;
end;

procedure Tfrm_Main.btn_KillClick(Sender: TObject);
begin
  if not (FExtractPrc = 0) then
    TerminateProcess(FExtractPrc, High(Cardinal));
  if not (FImportPrc = 0) then
    TerminateProcess(FImportPrc, High(Cardinal));
end;

procedure Tfrm_Main.chk_ServiceClick(Sender: TObject);
begin
  if FLoading then
    Exit;

  if not (ServiceGetStatus('', SERVICE_NAME) = SERVICE_RUNNING) then
  begin
    // on demare le service
    try
      try
        GestionInterface(false);
        ServiceWaitStart('', SERVICE_NAME, SERVICE_TIME);
      finally
        GestionInterface(true);
      end;
    except
    end;
  end
  else if (ServiceGetStatus('', SERVICE_NAME) = SERVICE_RUNNING) then
  begin
    // on arrete le service
    try
      try
        GestionInterface(false);
        ServiceWaitStop('', SERVICE_NAME, SERVICE_TIME);
      finally
        GestionInterface(true);
      end;
    except
    end;
  end;
  // affichage
  try
    FLoading := true;
    chk_Service.Checked := ServiceGetStatus('', SERVICE_NAME) = SERVICE_RUNNING;
  finally
    FLoading := false;
  end;
end;

// quitter !

procedure Tfrm_Main.btn_QuitterClick(Sender: TObject);
begin
  Close();
end;

// Gestion du traitement !!

function Tfrm_Main.TraitementExtract(Param : string) : THandle;
var
  ListeMag, ExeParam : string;
  i : integer;
begin
  Result := 0;

  if (not (FExtractName = '')) and FileExists(FExtractName) then
  begin
    ListeMag := '';
    if not (lst_Magasins.SelCount = lst_Magasins.Count) then
      for i := 0 to lst_Magasins.Count -1 do
        if lst_Magasins.Selected[i] then
          if ListeMag = '' then
            ListeMag := ' -Magasins:' + IntToStr(Integer(Pointer(lst_Magasins.Items.Objects[i])))
          else
            ListeMag := ListeMag + ';' + IntToStr(Integer(Pointer(lst_Magasins.Items.Objects[i])));

    ExeParam := '-LogLevel:' + cbx_NivLog.Text
              + ' -NbYearVte:' + IntToStr(sed_NbYearVte.Value)
              + ' -NbYearMvt:' + IntToStr(sed_NbYearMvt.Value)
              + ' -NbYearCmd:' + IntToStr(sed_NbYearCmd.Value)
              + ' -NbYearRap:' + IntToStr(sed_NbYearRap.Value)
              + ' -NbYearStk:' + IntToStr(sed_NbYearStk.Value)
              + ' -BaseGin:"' + edt_BaseGnk.Text
              + '" -BaseTpn:"' + edt_BaseTpn.Text + '" ' + Param + ListeMag;
    Result := ExecProcessAndNotify(FExtractName, ExeParam, MyExtractPrcNotify);
  end
  else
    MyExtractPrcNotify(High(Cardinal), 'Executable non trouvé');
  btn_Stop.Enabled := not (Result = 0);
  btn_Kill.Enabled := not (Result = 0);
end;

function Tfrm_Main.TraitementImport(Param : string) : THandle;
var
  ListeMag, ExeParam : string;
  i : integer;
begin
  Result := 0;

  if (not (FImportName = '')) and FileExists(FImportName) then
  begin
    ListeMag := '';
    if not (lst_Magasins.SelCount = lst_Magasins.Count) then
      for i := 0 to lst_Magasins.Count -1 do
        if lst_Magasins.Selected[i] then
          if ListeMag = '' then
            ListeMag := ' -Magasins:' + IntToStr(Integer(Pointer(lst_Magasins.Items.Objects[i])))
          else
            ListeMag := ListeMag + ';' + IntToStr(Integer(Pointer(lst_Magasins.Items.Objects[i])));

    ExeParam := '-LogLevel:' + cbx_NivLog.Text + ' -NbYearMvt:' + IntToStr(sed_NbYearMvt.Value) + ' -NbYearStk:' + IntToStr(sed_NbYearStk.Value) + ' -BaseGin:"' + edt_BaseGnk.Text + '" -BaseTpn:"' + edt_BaseTpn.Text + '" ' + Param + ListeMag;
    Result := ExecProcessAndNotify(FImportName, ExeParam, MyImportPrcNotify);
  end
  else
    MyImportPrcNotify(High(Cardinal), 'Executable non trouvé');
  btn_Stop.Enabled := not (Result = 0);
  btn_Kill.Enabled := not (Result = 0);
end;

// Gestion de l'interface

procedure Tfrm_Main.GestionInterface(Enabled : Boolean);
var
  BaseGnk, BaseTpn : boolean;
  TpnFile, ClientNom, SiteNom : string;
  IsSiteRappro, ExistsExeExtract, ExistsExeImport : boolean;
  MinVte, MinMvt, MinCmd, MinRap, MinStk : integer;
  ListeMagasin : TStringList;
begin
  if not Enabled then
    Screen.Cursor := crHourGlass;
  Application.ProcessMessages();

  BaseGnk := false;
  BaseTpn := false;
  IsSiteRappro := false;
  ExistsExeExtract := false;
  ExistsExeImport := false;

  try
    // blocage temporaire
    Self.Enabled := False;

    // Get des variable
    if Enabled then
    begin
      lst_Magasins.Clear();
      BaseGnk := FileExists(edt_BaseGnk.Text) and CanConnect('localhost', edt_BaseGnk.Text);
      if BaseGnk then
      begin
        try
          ListeMagasin := TStringList.Create();
          if GetInfosBase(edt_BaseGnk.Text, ClientNom, SiteNom, TpnFile, MinVte, MinMvt, MinCmd, MinRap, MinStk, FTimeReset, IsSiteRappro, ListeMagasin) then
          begin
            edt_BaseTpn.Text := TpnFile;
            lbl_NomClient.Caption := ClientNom;
            lbl_NomSiteReplique.Caption := SiteNom;
            // Durée de rétention
            sed_NbYearVte.Value := MinVte;
            sed_NbYearMvt.Value := MinMvt;
            sed_NbYearCmd.Value := MinCmd;
            sed_NbYearRap.Value := MinRap;
            sed_NbYearStk.Value := MinStk;
            // gestion des magasins !
            lst_Magasins.Items.AddStrings(ListeMagasin);
            lst_Magasins.SelectAll();
          end;
        finally
          FreeAndNil(ListeMagasin);
        end;
      end;
      BaseTpn := FileExists(edt_BaseTpn.Text) and CanConnect('localhost', edt_BaseTpn.Text);
    end;

    if not (Trim(FExtractName) = '') and FileExists(FExtractName) then
      ExistsExeExtract := true;
    if not (Trim(FImportName) = '') and FileExists(FImportName) then
      ExistsExeImport := true;


    // gestion de l'interface
    lbl_BaseGnk.Enabled := Enabled;
    edt_BaseGnk.Enabled := Enabled;
    btn_BaseGnk.Enabled := Enabled;

    lbl_BaseTpn.Enabled := Enabled;
    edt_BaseTpn.Enabled := Enabled;

    // interface complete
    btn_CreationBase.Enabled := Enabled and BaseGnk and not (Trim(edt_BaseTpn.Text) = '') and ExistsExeExtract;
    btn_MajBase.Enabled := Enabled and BaseGnk and BaseTpn and ExistsExeExtract;
    btn_NettoyageBase.Enabled := Enabled and BaseGnk and BaseTpn and ExistsExeExtract;
    cbx_NivLog.Enabled := Enabled;

    btn_Initialisation.Enabled := Enabled and BaseGnk and BaseTpn and ExistsExeExtract;
    btn_DeltaExtract.Enabled := Enabled and BaseGnk and BaseTpn and ExistsExeExtract;
    btn_DeltaImport.Enabled := Enabled and BaseGnk and BaseTpn and ExistsExeImport;
    btn_ResetStock.Enabled := Enabled and BaseGnk and BaseTpn and ExistsExeExtract;
    btn_Purges.Enabled := Enabled and BaseGnk and BaseTpn and ExistsExeExtract;
    lbl_Magasins.Enabled := Enabled;
    lst_Magasins.Enabled := Enabled;
    btn_TraitementManuel.Enabled := Enabled and BaseGnk and BaseTpn and ExistsExeExtract;
    chk_Magasins.Enabled := Enabled;
    chk_Exercices.Enabled := Enabled;
    chk_Collections.Enabled := Enabled;
    chk_Fournisseurs.Enabled := Enabled;
    rb_Complet.Enabled := Enabled;
    rb_ReInit.Enabled := Enabled;
    rb_Delta.Enabled := Enabled;
    chk_Articles.Enabled := Enabled;
    chk_Tickets.Enabled := Enabled;
    chk_Factures.Enabled := Enabled;
    chk_Mouvements.Enabled := Enabled;
    chk_Commandes.Enabled := Enabled;
    chk_Receptions.Enabled := Enabled and IsSiteRappro;
    chk_Retours.Enabled := Enabled and IsSiteRappro;
    chk_ResetStk.Enabled := Enabled;
    chk_HistoStk.Enabled := Enabled;
    lbl_NbYearVte.Enabled := Enabled;
    sed_NbYearVte.Enabled := Enabled;
    lbl_NbYearMvt.Enabled := Enabled;
    sed_NbYearMvt.Enabled := Enabled;
    lbl_NbYearCmd.Enabled := Enabled;
    sed_NbYearCmd.Enabled := Enabled;
    lbl_NbYearRap.Enabled := Enabled;
    sed_NbYearRap.Enabled := Enabled;
    lbl_NbYearStk.Enabled := Enabled;
    sed_NbYearStk.Enabled := Enabled;

    // interface simple
    btn_SmpInitialisation.Enabled := ((Enabled and BaseGnk and BaseTpn) or
                                      (Enabled and BaseGnk and not (Trim(edt_BaseTpn.Text) = ''))) and ExistsExeExtract;
    btn_SmpDeltaExtract.Enabled := Enabled and BaseGnk and BaseTpn and ExistsExeExtract;
    btn_SmpDeltaImport.Enabled := Enabled and BaseGnk and BaseTpn and ExistsExeImport;
    btn_SmpResetStock.Enabled := Enabled and BaseGnk and BaseTpn and ExistsExeExtract;

    // autre fonctionnalité
    btn_Parametrage.Enabled := Enabled and BaseGnk;
    btn_Aide.Enabled := Enabled;

    // gestion du controlm de l'extracteur
    btn_Stop.Enabled := not ((FExtractPrc = 0) and (FImportPrc = 0));
    btn_Kill.Enabled := not ((FExtractPrc = 0) and (FImportPrc = 0));

    // service ?
    chk_Service.Enabled := Enabled and CanManageService('') and ServiceExist('', SERVICE_NAME);

    btn_Quitter.Enabled := Enabled;
  finally
    // deblocage
    Self.Enabled := True;
  end;

  if Enabled then
    Screen.Cursor := crDefault;
  Application.ProcessMessages();
end;

function Tfrm_Main.CanConnect(Serveur, DataBaseFile : string) : boolean;
var
  Connexion : TFDConnection;
begin
  Result := false;

  if (Trim(Serveur) <> '') and (Trim(DataBaseFile) <> '') then
  begin
    try
      try
        Connexion := GetNewConnexion(Serveur, DataBaseFile, 'ginkoia', 'ginkoia');
        if Connexion.Connected then
          Result := true;
      finally
        Connexion.Close();
        FreeAndNil(Connexion);
      end;
    except
      Result := false;
    end;
  end;
end;

function Tfrm_Main.GetInfosBase(DataBaseFile : string; var ClientName, SiteName, BaseTpn : string; var MinVte, MinMvt, MinCmd, MinRap, MinStk : integer; var TimeReset : TTime; var IsSiteRappro : boolean; var ListeMagasin : TStringList) : boolean;
var
  Connexion : TFDConnection;
  Query : TFDQuery;
  SiteId : integer;
begin
  Result := false;

  if Assigned(ListeMagasin) then
    ListeMagasin.Clear()
  else
    ListeMagasin := TStringList.Create();

  TimeReset := 0 + EncodeTime(20, 30, 0, 0);
  IsSiteRappro := false;
  MinVte := 3;
  MinMvt := 3;
  MinCmd := 3;
  MinRap := 3;
  MinStk := 1;

  if (Trim(DataBaseFile) <> '') then
  begin
    try
      try
        Connexion := GetNewConnexion(DataBaseFile, 'ginkoia', 'ginkoia', false);
        Query := GetNewQuery(Connexion);
        Connexion.Open();
        if Connexion.Connected then
        begin
          // recup du nom de dossier
          Query.SQL.Text := 'select bas_nompournous, count(*) '
                          + 'from genbases join k on k_id = bas_id and k_enabled = 1 '
                          + 'where bas_nompournous != '''' '
                          + 'group by bas_nompournous '
                          + 'order by 2 desc '
                          + 'rows 1;';
          try
            Query.Open();
            if not Query.Eof then
              ClientName := Query.FieldByName('bas_nompournous').AsString
            else
              Exit;
          finally
            Query.Close();
          end;

          // recup du site de replication
          try
            Query.SQL.Text := 'select bas_id, bas_sender '
                            + 'from genbases join k on k_id = bas_id and k_enabled = 1 '
                            + 'join genparambase on bas_ident = par_string '
                            + 'where par_nom = ''IDGENERATEUR'';';
            Query.Open();
            if Query.Eof then
              Exit
            else
            begin
              SiteId := Query.FieldByName('bas_id').AsInteger;
              SiteName := Query.FieldByName('bas_sender').AsString;
            end;
          finally
            Query.Close();
          end;

          // date pour le reset
          Query.SQL.Text := 'select prm_code, prm_integer, prm_float '
                          + 'from genparam join k on k_id = prm_id and k_enabled = 1 '
                          + 'where prm_type = 25 and prm_code in (3, 8, 9, 10, 11, 12, 13);';
          try
            Query.Open();
            while not Query.Eof do
            begin
              case Query.FieldByName('prm_code').AsInteger of
                03 : TimeReset := 0 + Frac(TDateTime(Query.FieldByName('prm_float').AsFloat));
                08 : IsSiteRappro := Query.FieldByName('prm_integer').AsInteger = SiteId;
                09 : MinVte := Query.FieldByName('prm_integer').AsInteger;
                10 : MinMvt := Query.FieldByName('prm_integer').AsInteger;
                11 : MinCmd := Query.FieldByName('prm_integer').AsInteger;
                12 : MinRap := Query.FieldByName('prm_integer').AsInteger;
                13 : MinStk := Query.FieldByName('prm_integer').AsInteger;
              end;
              Query.Next();
            end;
          finally
            Query.Close();
          end;

          // base tampon ?
          Query.SQL.Text := 'select mag_id, mag_codeadh, mag_nom, prmactif.prm_integer as actif, prmbase.prm_string as basetpn '
                          + 'from genmagasin join k on k_id = mag_id and k_enabled = 1 '
                          + 'join genparam prmafect join k on k_id = prmafect.prm_id and k_enabled = 1 on prmafect.prm_type = 25 and prmafect.prm_code = 2 and prmafect.prm_magid = mag_id '
                          + 'join genparam prmactif join k on k_id = prmactif.prm_id and k_enabled = 1 on prmactif.prm_type = 25 and prmactif.prm_code = 1 and prmactif.prm_magid = mag_id '
                          + 'join genparam prmbase join k on k_id = prmbase.prm_id and k_enabled = 1 on prmbase.prm_type = 25 and prmbase.prm_code = 5 and prmbase.prm_magid = mag_id '
                          + 'where prmafect.prm_integer = ' + IntToStr(SiteId) + ';';
          try
            Query.Open();
            if Query.Eof then
              BaseTpn := ''
            else
            begin
              while not Query.Eof do
              begin
                if Query.FieldByName('actif').AsInteger = 1 then
                  ListeMagasin.AddObject(Query.FieldByName('mag_codeadh').AsString + ' - ' + Query.FieldByName('mag_nom').AsString, Pointer(Query.FieldByName('mag_id').AsInteger));
                if (Trim(BaseTpn) = '') then
                  BaseTpn := Query.FieldByName('basetpn').AsString
                else if not (BaseTpn = Query.FieldByName('basetpn').AsString) then
                  Raise Exception.Create('Difference de base tampon !!');
                Query.Next();
              end;
            end;
          finally
            Query.Close();
          end;

          // si on arrive ici
          Result := true;
        end;
      finally
        FreeAndNil(Query);
        Connexion.Close();
        FreeAndNil(Connexion);
      end;
    except
      Result := false;
    end;
  end;
end;

// Gestion du drag and drop

procedure Tfrm_Main.MessageDropFiles(var msg : TWMDropFiles);
const
  MAXFILENAME = 255;
var
  i, Count : integer;
  FileName : array [0..MAXFILENAME] of char;
  FileExt : string;
begin
  try
    // le nb de fichier
    Count := DragQueryFile(msg.Drop, $FFFFFFFF, FileName, MAXFILENAME);
    // Recuperation des fichier (nom)
    for i := 0 to Count -1 do
    begin
      DragQueryFile(msg.Drop, i, FileName, MAXFILENAME);
      FileExt := UpperCase(ExtractFileExt(FileName));
      if FileExt = '.IB' then
      begin
        edt_BaseGnk.Text := FileName
      end;
    end;
  finally
    DragFinish(msg.Drop);
  end;
end;

// dialogue

function Tfrm_Main.MessageDlg(const Msg : string; DlgType : TMsgDlgType; Buttons : TMsgDlgButtons): Integer;
begin
  with CreateMessageDialog(Msg, DlgType, Buttons) do
    try
      Position := poOwnerFormCenter;
      Result := ShowModal();
    finally
      Free;
    end;
end;

// notification de fin de process

procedure Tfrm_Main.MyExtractPrcNotify(Resultat : Cardinal; Error : string);
begin
  try
    if Resultat = 0 then
      MessageDlg('Traitement d''extraction effectué correctement.', mtInformation, [mbOK])
    else
      MessageDlg('Erreur lors du traitement d''extraction (code : ' + IntToStr(Resultat) +') : ' + Error, mtError, [mbOK]);
    CloseHandle(FExtractPrc);
    FExtractPrc := 0;
  finally
    GestionInterface(true);
  end;
end;

procedure Tfrm_Main.MyImportPrcNotify(Resultat : Cardinal; Error : string);
begin
  try
    if Resultat = 0 then
      MessageDlg('Traitement d''import effectué correctement.', mtInformation, [mbOK])
    else
      MessageDlg('Erreur lors du traitement d''import (code : ' + IntToStr(Resultat) +') : ' + Error, mtError, [mbOK]);
    CloseHandle(FImportPrc);
    FImportPrc := 0;
  finally
    GestionInterface(true);
  end;
end;

end.
