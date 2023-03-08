unit GKEasyComptage.Form.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ImgList, Vcl.Menus, Vcl.ExtCtrls,
  Vcl.Buttons, Vcl.ComCtrls, Vcl.StdCtrls, System.Math, System.StrUtils,
  GKEasyComptage.methodes,GKEasyComptage.Ressources{, System.ImageList{,uLog};

type
  TFormMain = class(TForm)
    LblHeure: TLabel;
    LblArret: TLabel;
    LblProchain: TLabel;
    BtnParametrage: TButton;
    StbStatut: TStatusBar;
    BtnQuitter: TBitBtn;
    TrayTache: TTrayIcon;
    PopTache: TPopupMenu;
    Restaurer1: TMenuItem;
    N1: TMenuItem;
    Quitter1: TMenuItem;
    ImlIcones: TImageList;
    TimerScan: TTimer;
    lblerrorparam: TLabel;
    TimerClose: TTimer;

    procedure BtnQuitterClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Quitter1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Restaurer1Click(Sender: TObject);
    procedure BtnParametrageClick(Sender: TObject);
    procedure TimerScanTimer(Sender: TObject);
    procedure TrayTacheDblClick(Sender: TObject);
    procedure TimerCloseTimer(Sender: TObject);

  private
    iSecondes   : integer;
    iStopSecondes : integer;
    iTentatives : integer;
    bPeuFermer  : Boolean;
//    bIsRunning  : Boolean;

    function InitParams:boolean;

  public

  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

uses GKEasyComptage.DataModule.Main, GKEasyComptage.Form.Param;

procedure TFormMain.BtnParametrageClick(Sender: TObject);
var IsOk, IsFtpActif:boolean;
begin
 // Lance le paramètrage
  Application.CreateForm(TFormParam, FormParam);
  try
    Journaliser('Ouverture Ecran Parametrage');
    // Désactive les traitements
    DataModuleMain.TimTraitement.Enabled  := False;
    StbStatut.Panels[2].text:='En Pause';

    FormMain.TimerClose.Enabled           := False;
    StbStatut.Panels[0].text:='';
    iStopSecondes := 60;

    FormParam.TxtRepertoire.Text          := GCONFIGAPP.DestPath;
    FormParam.SpnJours.Value              := GCONFIGAPP.Jours;
    FormParam.DtpDemarrage.Time           := Frac(GCONFIGAPP.tHeureDemarrage);
    FormParam.DtpArret.Time               := Frac(GCONFIGAPP.tHeureArret);
    FormParam.SpnPeriodicite.Value        := GCONFIGAPP.Periodicite;
    FormParam.rgType.ItemIndex            := GCONFIGAPP.iType;
    if GCONFIGAPP.FtpActif = 1 then
      IsFtpActif := True
    else
      IsFtpActif := False;
    FormParam.chkFtpActif.Checked         := IsFtpActif;
    FormParam.edtFtpUrl.Text              := GCONFIGAPP.FtpUrl;
    FormParam.edtFtpLogin.Text            := GCONFIGAPP.FtpLogin;
    FormParam.edtFtpMdp.Text              := GCONFIGAPP.FtpMdp;
    FormParam.edtFtpDossier.Text        := GCONFIGAPP.FtpDossier;


    if FormParam.ShowModal() = mrOk then
    begin
      try
        GCONFIGAPP.DestPath           := FormParam.TxtRepertoire.Text;
        GCONFIGAPP.Jours              := FormParam.SpnJours.Value;
        GCONFIGAPP.tHeureDemarrage    := Frac(FormParam.DtpDemarrage.Time);
        GCONFIGAPP.tHeureArret        := Frac(FormParam.DtpArret.Time);
        GCONFIGAPP.Periodicite        := FormParam.SpnPeriodicite.Value;
        GCONFIGAPP.iType              := FormParam.rgType.ItemIndex;
        if FormParam.chkFtpActif.Checked then
          GCONFIGAPP.FtpActif := 1
        else
          GCONFIGAPP.FtpActif := 0;
        GCONFIGAPP.FtpUrl             := FormParam.edtFtpUrl.Text;
        GCONFIGAPP.FtpLogin           := FormParam.edtFtpLogin.Text;
        GCONFIGAPP.FtpMdp             := FormParam.edtFtpMdp.Text;
        GCONFIGAPP.FtpDossier       := FormParam.edtFtpDossier.Text;

        EnregistreParametres();
        ChargerParametres();

        Journaliser('Validation du parametrage [OK]');
        Except on E:Exception do
          begin
            Journaliser('Validation du parametrage [ERREUR]', NivErreur);
          end;
      end;

      LblHeure.Caption          := FormatDateTime('DD/MM/YYYY hh:mm:ss', GCONFIGAPP.dNextAction);
      // Affichage de l'heure de fin
      LblArret.Caption          := Format(RS_LIB_ARRET, [FormatDateTime('hh:nn', GCONFIGAPP.tHeureArret)]);
      // Paramétrage de la tâche planifiée
    end;
  finally
    // Dans tous les cas il faut réactiver le Timer !
    IsOk:=CheckParams;
    lblerrorParam.Visible:= not(IsOk);
    DataModuleMain.TimTraitement.Enabled  := IsOk;
    //-----------------------------------------------------------------------
    If IsOk and (Frac(Now())>Frac(GCONFIGAPP.tHeureArret))
      then
         begin
            FormMain.TimerClose.Enabled:=true;
         end;
    if DataModuleMain.TimTraitement.Enabled
      then StbStatut.Panels[2].text:='En Marche'
      else StbStatut.Panels[2].text:='En Pause';
    Journaliser('Fermeture du Parametrage');
    DataModuleMain.FDConnection.Close;
    FormParam.Free();
  end;
end;

procedure TFormMain.BtnQuitterClick(Sender: TObject);
begin
 //   BtnQuitter.Enabled:=false;
    Close();
//    BtnQuitter.Enabled:=True;
end;

procedure TFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Si l'application peut être fermée
  if bPeuFermer then
  begin
    if Assigned(DataModuleMain.ThreadTraitement) then
    begin
      if not(DataModuleMain.ThreadTraitement.Finished) then
      begin
        Journaliser(RS_INF_ARRET, NivArret);
        DataModuleMain.FFermeture  := True;
        DataModuleMain.ThreadTraitement.Terminate();
      end
      else begin
        Journaliser(RS_INF_ARRET, NivArret);
        Action := caFree;
      end;
    end
    else begin
      Journaliser(RS_INF_ARRET, NivArret);
      Action := caFree;
    end;
  end
  else begin
    // Minimise l'application et cache l'icône
    Journaliser('Fermeture Interface : (Retour en TrayIco)');
    Self.Hide;
    ShowWindow(Application.Handle, SW_HIDE);
    SetWindowLong(Application.Handle, GWL_EXSTYLE, getWindowLong(Application.Handle, GWL_EXSTYLE) or WS_EX_TOOLWINDOW) ;
    Application.ProcessMessages;
    TrayTache.Visible:=true;
    TrayTache.Hint          := Self.Caption;
    // TrayTache.BalloonTitle  := Self.Caption;
    // TrayTache.BalloonHint   := RS_INFO_EN_COURS;
    // TrayTache.ShowBalloonHint();
    Application.ProcessMessages;
    Action := caNone;
  end;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin

  // Suppression des Icones Morts
  RemoveDeadIcons;

  // Journaliser('FormMain.FormCreate_0');
  bPeuFermer:=false;
  iTentatives   := 0;
  iStopSecondes := 60;
  // FLoadingParams := false;
  GINIFILE := ChangeFileExt(Application.ExeName, '.ini');

  // Chargement des paramètres de connexion
  GCONNEXION := ParamsBase();
  if GCONNEXION.BaseDonnees = '' then
  begin
    Journaliser(RS_ERR_PARAM_INI, NivArret);
    Fermeture_Differe(RS_ERR_PARAM_INI);
    // MessageDlg(RS_ERR_PARAM_INI, mtError, [mbOk], 0);
    Application.Terminate();
    Exit;
  end;

  // Journaliser('FormMain.FormCreate_1');
  // Vérifie la connexion à la base de données et charge les paramètres
  GINIT:=InitParams();

  if GINIT then
    begin
       if FindCmdLineSwitch('PARAM') then
          begin
              // Ouvre la fenêtre de paramètrage au besoin
              Journaliser(RS_INF_PARAM);
              BtnParametrage.Click();
          end
       //-----------------------------------------------------------------------
       else
           begin
              // Cache la fenêtre en mode auto
              Self.Hide;
              ShowWindow(Application.Handle, SW_HIDE);
              SetWindowLong(Application.Handle, GWL_EXSTYLE, getWindowLong(Application.Handle, GWL_EXSTYLE) or WS_EX_TOOLWINDOW) ;
              Application.ProcessMessages;
              // TrayTache.Visible := false;
              TrayTache.Visible := true;
              TrayTache.Hint    := Self.Caption;
              // TrayTache.BalloonTitle  := Self.Caption;
              // TrayTache.BalloonHint   := RS_INFO_EN_COURS;
              // TrayTache.ShowBalloonHint();
              Application.ProcessMessages;
           end;
       FormMain.LblProchain.Enabled         := true;
       FormMain.LblHeure.Enabled            := True;
       DataModuleMain.TimTraitement.Enabled := True;
       //-----------------------------------------------------------------------
       If (Frac(Now())>Frac(GCONFIGAPP.tHeureArret))
         then
           begin
              FormMain.TimerClose.Enabled:=true;
           end;
    end;
    if DataModuleMain.TimTraitement.Enabled
      then StbStatut.Panels[2].text:='En Marche'
      else StbStatut.Panels[2].text:='En Pause';
end;


procedure TFormMain.FormDestroy(Sender: TObject);
begin
//    Log.SaveIni();//
end;

function TFormMain.InitParams:boolean;
var bmapping:byte;
begin
  Journaliser('InitParams');
  result:=false;
  try
    try
      bmapping:=Mapping();
      If (bmapping<>0) then
         begin
            // Journaliser('Mapping en cours', NivErreur);
            Journaliser(ErrorMapping(bMapping), NivErreur);
            raise Exception.Create('Mapping en cours');
         end;
       DataModuleMain.FDConnection.Close;
       DataModuleMain.FDConnection.Params.Clear();
       DataModuleMain.FDConnection.Params.Add('Port=3050');
       DataModuleMain.FDConnection.Params.Add('DriverID=IB');
       DataModuleMain.FDConnection.Params.Add('User_Name=ginkoia');
       DataModuleMain.FDConnection.Params.Add('Password=ginkoia');
       DataModuleMain.FDConnection.Params.Add('Protocol=TCPIP');
       DataModuleMain.FDConnection.Params.Add(Format('Database=%s', [GCONNEXION.BaseDonnees]));
       DataModuleMain.FDConnection.open();
       if DataModuleMain.FDConnection.Connected then
       begin
               // ----------------------------------------------------------------
               Journaliser('Connexion : [OK]');
               ChargerParametres();
               Caption:='Easy Comptage - ' + GCONNEXION.NomMag + ' - ' + InfoSurExe(Application.ExeName).FileVersion;
               LblHeure.Caption := FormatDateTime('DD/MM/YYYY hh:mm:ss', GCONFIGAPP.dNextAction);
               LblArret.Caption := Format(RS_LIB_ARRET, [FormatDateTime('hh:nn', GCONFIGAPP.tHeureArret)]);
               // ----------------------------------------------------------------
               // Si les Paramètres sont mal renseignés .....
               If not(CheckParams) and not(FindCmdLineSwitch('PARAM')) then
                  begin
                      // on ouvre les paramètres avec flag validation obligatoire
                      BtnParametrage.Click();
                      result:=false;
                      exit;
                   end;
               StbStatut.Panels[0].text             := 'Connexion : [OK]';
               FormMain.LblProchain.Enabled         := true;
               FormMain.LblHeure.Enabled            := True;
               DataModuleMain.TimTraitement.Enabled := True;
               result:=true;
       end;
    except
      on E: Exception do
      begin
        Journaliser(RS_ERR_CONNEXION + ' :  ' + E.Message, NivErreur);
        LblHeure.Caption := '???';
        LblArret.Caption := Format(RS_LIB_ARRET, ['???']);
        iSecondes:=60;
        inc(iTentatives);
        StbStatut.Panels[0].text:=Format(RS_ERR_CONNEXION + ' %d  - nouvelle tentative dans %d s',[iTentatives, iSecondes]);
        DataModuleMain.TimTraitement.Enabled := False;
        TimerScan.Enabled:=true;
        result:=false;
      end;
    end;
  finally
      DataModuleMain.FDConnection.Close;
      if DataModuleMain.TimTraitement.Enabled then
         StbStatut.Panels[2].text:='En Marche'
      else
         StbStatut.Panels[2].text:='En Pause';
  end;
end;


procedure TFormMain.Quitter1Click(Sender: TObject);
var Etat:boolean;
begin
  Etat:=DataModuleMain.TimTraitement.Enabled;
  DataModuleMain.TimTraitement.Enabled:=false;
  if MessageBox(Self.Handle, PChar(RS_QUES_QUITTER), 'Question', MB_YESNO + MB_ICONQUESTION Or MB_DEFBUTTON2) = IDYES then
  begin
    Journaliser('Reponse Fermeture = OUI');
    bPeuFermer := True;
    Close();
  end
  else
   DataModuleMain.TimTraitement.Enabled:=Etat;

   if DataModuleMain.TimTraitement.Enabled
     then StbStatut.Panels[2].text:='En Marche'
     else StbStatut.Panels[2].text:='En Pause';
end;

procedure TFormMain.Restaurer1Click(Sender: TObject);
begin
  Journaliser('Ouverture Interface : (Restaurer)');
  ShowWindow(Self.Handle, SW_SHOW);
  Show();
end;

procedure TFormMain.TimerCloseTimer(Sender: TObject);
var
   fProchain: integer;
begin
    //--------------------------------------------------------------------------
    try
       TTimer(Sender).Enabled:=false;
       // arret des autres timers !
       TimerScan.Enabled:=false;
       DataModuleMain.TimTraitement.Enabled:=false;
       //
       dec(iStopSecondes);
       StbStatut.Panels[0].text:=Format('C''est tout pour aujourd''hui - Fermeture de l''application dans %d s',[ iStopSecondes]);
       Journaliser(StbStatut.Panels[0].text);
       if (iStopSecondes<=0) then
          begin
             // Round((GCONFIGAPP.dNextAction-Now())*86400);
             // lendemain + 1 itération
             fProchain := Round((GCONFIGAPP.dNextAction+GCONFIGAPP.Periodicite /1440 - Now())*86400);
             // C'est en Notice (4) pas en Info...
             StbStatut.Panels[0].text:='Bye Bye...';
             Journaliser('Bye Bye...');
             bPeuFermer := True;
             Close();
             // ForceClose;
             // Application.Terminate();
          end;
    finally
       TTimer(Sender).Enabled:=True;
    end;
    //--------------------------------------------------------------------------
end;

procedure TFormMain.TimerScanTimer(Sender: TObject);
begin
    // Journaliser('TimerScan');
    try
      TTimer(Sender).Enabled:=false;
      if (GINIT) then
        begin
            Journaliser('Msg GINIT=true => exit');
            exit;
        end;
      dec(iSecondes);
      if (iSecondes<0) then
          begin
            GINIT:=InitParams;
          end;
      if not(GINIT) then
        begin
           StbStatut.Panels[0].text:=Format(RS_ERR_CONNEXION + ' %d  - nouvelle tentative dans %d s',[iTentatives, iSecondes]);
           // Journaliser(StbStatut.Panels[0].text);
        end;
    Finally
       lblerrorParam.Visible:= not(CheckParams);
       TTimer(Sender).Enabled:=not(GINIT);
       if DataModuleMain.TimTraitement.Enabled
         then StbStatut.Panels[2].text:='En Marche'
         else StbStatut.Panels[2].text:='En Pause';
    End;
end;

procedure TFormMain.TrayTacheDblClick(Sender: TObject);
begin
   Journaliser('Ouverture Interface : (TrayTacheDblClick)');
   ShowWindow(Self.Handle, SW_SHOW);
   Show();
end;

end.

