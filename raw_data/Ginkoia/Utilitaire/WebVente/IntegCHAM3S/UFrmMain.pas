unit UFrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, UGestDossiers, UfrmConfig, UFrmConfigBdd,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Taskbar, System.Win.TaskbarCore,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnPopup, Vcl.Menus, UVersion, System.DateUtils;
  

type
  TFrmMain = class(TForm)
    btnConfig: TButton;
    btnBdd: TButton;
    btnTraitement: TButton;
    memLog: TMemo;
    pbElement: TProgressBar;
    pbGlobal: TProgressBar;
    Taskbar1: TTaskbar;
    btnStop: TButton;
    gbConfig: TGroupBox;
    gbTraitement: TGroupBox;
    lblPourcentElement: TLabel;
    lblPourcentGlobal: TLabel;
    gbMaintenance: TGroupBox;
    btnBackupRestore: TButton;
    TmrStart: TTimer;
    gbInformation: TGroupBox;
    lblTitreTraitement: TLabel;
    lblDateTraitement: TLabel;
    lblModeTitre: TLabel;
    lblMode: TLabel;
    BtnArticles: TButton;
    btnRazLiens: TButton;
    TrayIcon1: TTrayIcon;
    PopupTray: TPopupMenu;
    popOuvrir: TMenuItem;
    popQuitter: TMenuItem;
    lblDateLancement: TLabel;
    lblTitreLancement: TLabel;
    N1: TMenuItem;
    N2: TMenuItem;
    popGestiondesarticles: TMenuItem;

    procedure btnConfigClick(Sender: TObject);
    procedure btnBddClick(Sender: TObject);
    procedure btnTraitementClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure TmrStartTimer(Sender: TObject);
    procedure BtnArticlesClick(Sender: TObject);
    procedure btnRazLiensClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure TrayIcon1DblClick(Sender: TObject);
    procedure popOuvrirClick(Sender: TObject);
    procedure popQuitterClick(Sender: TObject);
    procedure popGestiondesarticlesClick(Sender: TObject);

  private
    FGestDossiers: TGestDossiers;

    procedure MajPourcentGlobal(Sender: TObject);
    procedure MajPourcentElement(Sender: TObject);
    procedure MajLog(Sender: TObject);
    procedure MajStart(Sender: TObject);
    procedure MajFin(Sender: TObject);
    procedure MajButton(Sender: TObject);

  public
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.dfm}

uses UArticlesDisponibles;

procedure TFrmMain.btnConfigClick(Sender: TObject);
begin
  if InputBox('Administration', #31'Mot de Passe : ', '') = '1082' then
  begin
    FrmConfig := TFrmConfig.Create(Self,FGestDossiers);
    FrmConfig.ShowModal;
    FrmConfig.Free;
  end;
  MajButton(nil);
end;

procedure TFrmMain.btnRazLiensClick(Sender: TObject);
begin
  if InputBox('Administration', #31'Mot de Passe : ', '') = '1082' then
  begin
    FGestDossiers.BddDossier.RazLinks;
  end;
end;

procedure TFrmMain.btnStopClick(Sender: TObject);
begin
  FGestDossiers.StopTraitement;
  btnStop.Enabled := false;
end;

procedure TFrmMain.btnTraitementClick(Sender: TObject);
begin
  FGestDossiers.StartTraitement;
end;

procedure TFrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := false;
  self.Hide;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  FGestDossiers := TGestDossiers.Create;
  FGestDossiers.OnPourcentElement := MajPourcentElement;
  FGestDossiers.OnPourcentGlobal  := MajPourcentGlobal;
  FGestDossiers.OnLog   := MajLog;
  FGestDossiers.OnStart := MajStart;
  FGestDossiers.OnFin   := MajFin;
  TmrStart.Enabled := true;
end;

procedure TFrmMain.FormDestroy(Sender: TObject);
begin
  FGestDossiers.Terminate;
  FGestDossiers.WaitFor;
  FGestDossiers.Free;
end;

procedure TFrmMain.popGestiondesarticlesClick(Sender: TObject);
begin
  BtnArticlesClick(Sender);
end;

procedure TFrmMain.MajButton(Sender: TObject);
var
  lDate: TDateTime;
  lDateLancement: TDateTime;
begin
  btnConfig.Enabled := (FGestDossiers.BaseDossierOk and not(FGestDossiers.TraitementEnCours));
  btnBdd.Enabled := not(FGestDossiers.TraitementEnCours);
  btnTraitement.Enabled := (FGestDossiers.BaseDossierOk and FGestDossiers.BaseMaitreOk and not(FGestDossiers.TraitementEnCours));
  btnRazLiens.Enabled := (FGestDossiers.BaseDossierOk and not(FGestDossiers.TraitementEnCours));
  BtnArticles.Enabled := (FGestDossiers.BaseDossierOk and not(FGestDossiers.TraitementEnCours));
  //btnBackupRestore.Enabled := (FGestDossiers.BaseDossierOk and not(FGestDossiers.TraitementEnCours));
  
  
  btnStop.Visible := FGestDossiers.TraitementEnCours;
  btnStop.Enabled := FGestDossiers.TraitementEnCours;

  lDate := FGestDossiers.GestIni.DateUpdate;
  if lDate = 0 then
    lblDateTraitement.Caption := 'Jamais'
  else
    lblDateTraitement.Caption := DateTimeToStr(lDate);

  if FGestDossiers.GestIni.Auto then
  begin
    lDateLancement := FGestDossiers.GestIni.DateLancement ;
    if lDateLancement = 0 then
      lblDateLancement.Caption := 'Jamais'
    else
      lblDateLancement.Caption := DateTimeToStr(IncMinute(lDateLancement,FGestDossiers.GestIni.Frequence));
    lblMode.Caption := 'Automatique'
  end
  else
  begin
    lblDateLancement.Caption := 'N/A';
    lblMode.Caption := 'Manuel';
  end;
end;

procedure TFrmMain.MajFin(Sender: TObject);
begin
  Taskbar1.ProgressState := TTaskBarProgressState.None;
  lblPourcentElement.Caption := '-- %';
  lblPourcentGlobal.Caption := '-- %';
  MajButton(nil);
end;

procedure TFrmMain.MajLog;
var
  lLog: string;
begin
  lLog := FGestDossiers.Log;
  if lLog <> '' then
    memLog.Lines.Add(lLog);
end;

procedure TFrmMain.MajPourcentElement;
var
  lPourcent: integer;
begin
  lPourcent := FGestDossiers.PourcentElement;
  pbElement.Position := lPourcent;
  lblPourcentElement.Caption := IntToStr(lPourcent)+' %';
end;

procedure TFrmMain.MajPourcentGlobal;
var
  lPourcent: integer;
begin
  lPourcent := FGestDossiers.PourcentGlobal;
  pbGlobal.Position := lPourcent;
  Taskbar1.ProgressValue := lPourcent;
  lblPourcentGlobal.Caption := IntToStr(lPourcent)+' %';
end;

procedure TFrmMain.MajStart(Sender: TObject);
begin
  Taskbar1.ProgressState := TTaskBarProgressState.Normal;
  memLog.Clear;
  MajButton(nil);
end;

procedure TFrmMain.popOuvrirClick(Sender: TObject);
begin
  self.Show;
end;

procedure TFrmMain.popQuitterClick(Sender: TObject);
begin
  if MessageDlg('Vraiment quitter l''application IntegCHAM3S ?',mtWarning,[mbYes,mbCancel],0,mbCancel) = mrYes then
  begin
    Application.Terminate;
  end;
end;

procedure TFrmMain.TmrStartTimer(Sender: TObject);
begin
  TmrStart.Enabled := false;
  FrmMain.Caption := 'IntegCHAM3S - Intégration Web - V'+ GetNumVersionSoft;
  MajButton(nil);
end;

procedure TFrmMain.TrayIcon1DblClick(Sender: TObject);
begin
  popGestiondesarticlesClick(Sender);
end;

procedure TFrmMain.BtnArticlesClick(Sender: TObject);
begin
  BtnArticles.Enabled := False;
  popOuvrir.Enabled := false;
  popGestiondesarticles.Enabled := false;
  try
      FormArticlesDisponibles := TFormArticlesDisponibles.Create(Self);
      try
        FormArticlesDisponibles.ShowModal;
      finally
        FormArticlesDisponibles.Free;
      end;
  finally
    BtnArticles.Enabled := True;
    popOuvrir.Enabled := True;
    popGestiondesarticles.Enabled := True;
  end;

  MajButton(nil);
end;

procedure TFrmMain.btnBddClick(Sender: TObject);
begin
  if InputBox('Administration', #31'Mot de Passe : ', '') = '1082' then
  begin
    FrmConfigBdd := TFrmConfigBdd.Create(Self,FGestDossiers);
    FrmConfigBdd.ShowModal;
    FrmConfigBdd.Free;
  end;
  MajButton(nil);
end;

end.

