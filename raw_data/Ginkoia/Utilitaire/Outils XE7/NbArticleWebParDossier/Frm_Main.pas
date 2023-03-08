unit Frm_Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.StdCtrls, FMX.Memo, UThreadProcess,
  UThreadMail, Frm_Config, FMX.edit, UConstantes, IdExplicitTLSClientServerBase,
  IdSSLOpenSSL, System.TypInfo, UConfigIni, FMX.ScrollBox,
  FMX.Controls.Presentation;

type
  TMain_Frm = class(TForm)
    MemoLog: TMemo;
    lo_Top: TLayout;
    lo_Memo: TLayout;
    pb_Generale: TProgressBar;
    lbl_Titre: TLabel;
    btn_Config: TButton;
    btn_Executer: TButton;
    procedure FormDestroy(Sender: TObject);
    procedure btn_ExecuterClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn_ConfigClick(Sender: TObject);
  private
    FConfigIni: TConfigIni;
    FNomFichier: string;
    FThreadProcess : TThreadProcess;
    FThreadMail : TThreadMail;
    FModeAuto: boolean;
    FEnCours: boolean;
    FArretDemande: boolean;
    procedure RunThread;
    procedure SaveCSV;
    procedure SaveLog;
    procedure SendEmail;
    procedure OnThreadMessage(Sender: TObject; Text: string);
    procedure OnThreadProgress(Sender: TObject; Progress: integer);
    procedure OnThreadTerminate(Sender: TObject);
    procedure OnEmailDone(Sender: TObject);
    procedure StopProcess;
  public
    procedure TestEmail;
  end;

var
  Main_Frm: TMain_Frm;

implementation

{$R *.fmx}

procedure TMain_Frm.btn_ConfigClick(Sender: TObject);
var
  iEmail: integer;
  lParamMail: TParamMail;
begin
  Config_Frm := TConfig_Frm.Create(self);
  //load inutile mais bon quand même ...
  FConfigIni.Load;
  Config_Frm.cb_Email.IsChecked := FConfigIni.EmailActif;
  Config_Frm.edt_Base.Text :=  FConfigIni.PathBDD;
  Config_Frm.edt_Csv.Text :=  FConfigIni.PathCSV;
  Config_Frm.edt_Log.Text :=  FConfigIni.PathLOG;
  Config_Frm.edt_Monitoring.Text := IntToStr(FConfigIni.TempsMonitoring);
  Config_Frm.memo_email.Text := FConfigIni.ListeEmail.DelimitedText;
  Config_Frm.edt_SmtpFromAdr.Text := FConfigIni.ParamMail.FromAddress;
  Config_Frm.edt_SmtpHost.Text := FConfigIni.ParamMail.SmtpHost;
  Config_Frm.edt_SmtpPort.Text := IntToStr(FConfigIni.ParamMail.SmtpPort);
  Config_Frm.edt_SmtpUser.Text := FConfigIni.ParamMail.SmtpUsername;
  Config_Frm.edt_SmtpPwd.Text := FConfigIni.ParamMail.SmtpPassword;
  Config_Frm.cb_SmtpUseTls.ItemIndex := ord(FConfigIni.ParamMail.SmtpUseTLS);
  Config_Frm.cb_SmtpSSLVersion.ItemIndex := Ord(FConfigIni.ParamMail.SSLVersion);
  if Assigned(FThreadMail) then
    Config_Frm.SetBtnEmail((not FThreadMail.EnCours) and FConfigIni.EmailActif)
  else
    Config_Frm.SetBtnEmail(FConfigIni.EmailActif);

  if Config_Frm.ShowModal = mrOk then
  begin
    FConfigIni.EmailActif := Config_Frm.cb_Email.IsChecked;
    FConfigIni.PathBDD := Config_Frm.edt_Base.Text;
    FConfigIni.PathCSV := Config_Frm.edt_Csv.Text;
    FConfigIni.PathLOG := Config_Frm.edt_Log.Text;
    FConfigIni.TempsMonitoring := StrToInt(Config_Frm.edt_Monitoring.Text);
    FConfigIni.ListeEmail.DelimitedText := Config_Frm.memo_email.Text;

    FConfigIni.ListeEmail.DelimitedText := Config_Frm.memo_email.Text;

    lParamMail.FromAddress := Config_Frm.edt_SmtpFromAdr.Text;
    lParamMail.SmtpHost := Config_Frm.edt_SmtpHost.Text;
    try
      lParamMail.SmtpPort := StrToInt(Config_Frm.edt_SmtpPort.Text);
    except
      lParamMail.SmtpPort := 587;
    end;
    lParamMail.SmtpUsername := Config_Frm.edt_SmtpUser.Text;
    lParamMail.SmtpPassword := Config_Frm.edt_SmtpPwd.Text;
    lParamMail.SmtpUseTLS := TIdUseTLS(Config_Frm.cb_SmtpUseTls.ItemIndex);
    lParamMail.SSLVersion := TIdSSLVersion(Config_Frm.cb_SmtpSSLVersion.ItemIndex);
    FConfigIni.ParamMail := lParamMail;
    FConfigIni.Save;
  end;
  FreeAndNil(Config_Frm);
end;

procedure TMain_Frm.btn_ExecuterClick(Sender: TObject);
begin
  if FEnCours then
    StopProcess
  else
    RunThread;
end;

procedure TMain_Frm.OnEmailDone(Sender: TObject);
begin
  try
    //fin de l'exécution
    OnThreadMessage(self,'Terminé');
    //on réenregistre le log après l'envoi de mail
    //SaveLog;
    if FModeAuto then
    begin
      OnThreadMessage(self,'Mode Auto - Fermeture du programme');
      self.Close;
    end;
    if assigned(Config_Frm) then
      if Assigned(FThreadMail) then
        Config_Frm.SetBtnEmail(not FThreadMail.EnCours)
      else
        Config_Frm.SetBtnEmail(true);
  finally
    FEnCours := false;
    FArretDemande := false;
    btn_Executer.Text := 'Exécuter';
    btn_Config.Enabled := true;
  end;

end;

procedure TMain_Frm.OnThreadMessage(Sender: TObject; Text: string);
begin
  //on ajoute le message dans le mémo et on fait défiler les lignes
  MemoLog.Lines.Add(DateTimeToStr(Now)+' - '+Text);
  MemoLog.GoToTextEnd;
  SaveLog;
  //SaveCSV;
end;

procedure TMain_Frm.OnThreadProgress(Sender: TObject; Progress: integer);
begin
  //affichage de la progression dans la barre
  pb_Generale.Value := Progress;
end;

procedure TMain_Frm.OnThreadTerminate(Sender: TObject);
begin
  OnThreadMessage(self,'Analyse Terminée');
  //SaveLog;
  SaveCSV;
  SendEmail;
end;

procedure TMain_Frm.FormCreate(Sender: TObject);
var
  iParam: integer;
begin
  FConfigIni := TConfigIni.Create;
  for iParam := 0 to ParamCount do
  begin
    if UpperCase(ParamStr(iParam)) = 'AUTO' then
    begin
      FModeAuto := true;
      RunThread;
    end
    else
      FModeAuto := false;
  end;

end;

procedure TMain_Frm.FormDestroy(Sender: TObject);
begin
  if Assigned(FThreadProcess) then
    FThreadProcess.Free;
  if Assigned(FThreadMail) then
    FThreadMail.Free;
end;

procedure TMain_Frm.RunThread;
begin
  if FEnCours then
    exit;

  FEnCours := true;

  FNomFichier := FormatDateTime('yyyymmdd_hhmmss',Now)+'_'+GetCompName+'_NbArticleWebActifs';
  btn_Executer.Enabled := false;
  btn_Config.Enabled := false;
  MemoLog.Lines.Clear;

  if FModeAuto then
    OnThreadMessage(self,'Mode Auto - Démarrage')
  else
    OnThreadMessage(self,'Démarrage');
  if Assigned(FThreadProcess) then
    FreeAndNil(FThreadProcess);
  FThreadProcess := TThreadProcess.Create(FConfigIni.PathBDD,FConfigIni);
  FThreadProcess.OnMessage := OnThreadMessage;
  FThreadProcess.OnProgress := OnThreadProgress;
  FThreadProcess.OnTerminate := OnThreadTerminate;
  FThreadProcess.Start;

  btn_Executer.Text := 'Stop';
  btn_Executer.Enabled := true;

end;

procedure TMain_Frm.SaveCSV;
begin
  try
    FThreadProcess.CSV.SaveToFile(FConfigIni.PathCSV+FNomFichier+'.csv');
  except
    on E:Exception do
      OnThreadMessage(self,'Erreur enregistrement CSV : '+E.Message);
  end;
end;

procedure TMain_Frm.SaveLog;
begin
  try
    MemoLog.Lines.SaveToFile(FConfigIni.PathLOG+FNomFichier+'.log');
  except
    on E:Exception do
      OnThreadMessage(self,'Erreur enregistrement log : '+E.Message);
  end;
end;

procedure TMain_Frm.SendEmail;
var
  lSection: TStringList;
  lListMail: TStringList;
  lListeFIchiers: TStringList;
  iMail: integer;
begin
  if FArretDemande then
  begin
    OnEmailDone(self);
    exit;
  end;
  FEnCours := true;
  if FConfigIni.EmailActif then
  begin
    OnThreadMessage(self,'Envoi des Emails');
    lSection := TStringList.Create;
    lListMail := TStringList.Create;
    lListeFIchiers := TStringList.Create;
    lListeFIchiers.Add(FConfigIni.PathCSV+FNomFichier+'.csv');
    lListeFIchiers.Add(FConfigIni.PathLOG+FNomFichier+'.log');
    if Assigned(FThreadMail) then
      FreeAndNil(FThreadMail);

    FThreadMail := TThreadMail.Create(FConfigIni.ListeEmail,lListeFIchiers,FConfigIni.ParamMail);
    FThreadMail.OnTerminate := OnEmailDone;
    FThreadMail.OnMessage := OnThreadMessage;
    FThreadMail.Start;
    lSection.Free;
    lListMail.Free;
    lListeFIchiers.Free;
  end
  else
  begin
    OnThreadMessage(self,'Pas d''envoi d''Emails');
    OnEmailDone(nil);
  end;
end;

procedure TMain_Frm.StopProcess;
begin
  FArretDemande := true;
  if Assigned(FThreadProcess) then
    FThreadProcess.Terminate
  else if Assigned(FThreadMail) then
    FThreadMail.Terminate;
end;

procedure TMain_Frm.TestEmail;
var
  lList: TStringList;
begin
  OnThreadMessage(self,'Email de Test - NbArtWebParDossier');
  lList := TStringList.Create;
  lList.Add('Email de Test - NBArtWebParDossier');
  lList.SaveToFile(FConfigIni.PathCSV+FNomFichier+'.csv');
  SendEmail;
end;

end.
