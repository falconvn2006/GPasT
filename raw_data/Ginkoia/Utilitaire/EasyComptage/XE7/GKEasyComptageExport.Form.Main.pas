unit GKEasyComptageExport.Form.Main;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.DateUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  Vcl.ExtCtrls,
  Vcl.Menus, 
  Vcl.Buttons,
  GKEasyComptageExport.Ressources,
  GKEasyComptageExport.Methodes,
  GKEasyComptageExport.Thread.Connexion, Vcl.ImgList;

type
  TFormMain = class(TForm)
    LblHeure: TLabel;
    LblArret: TLabel;
    BtnParametrage: TButton;
    BtnExportPeriode: TButton;
    DtpDebut: TDateTimePicker;
    DtpFin: TDateTimePicker;
    StbStatut: TStatusBar;
    LblProchain: TLabel;
    TrayTache: TTrayIcon;
    PopTache: TPopupMenu;
    Restaurer1: TMenuItem;
    N1: TMenuItem;
    Quitter1: TMenuItem;
    BtnQuitter: TBitBtn;
    BtnExportTranche: TButton;
    DtpTrancheDate: TDateTimePicker;
    DtpTrancheHeure: TDateTimePicker;
    ImlIcones: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Restaurer1Click(Sender: TObject);
    procedure Quitter1Click(Sender: TObject);
    procedure BtnParametrageClick(Sender: TObject);
    procedure BtnExportPeriodeClick(Sender: TObject);
    procedure BtnExportTrancheClick(Sender: TObject);
    procedure Journaliser(const AMessage: String; const ANiveau: TNiveau = NivDetail);
    procedure StbStatutMouseEnter(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure DemarrerThreadConnexion();
    procedure FinThreadConnexion(Sender: TObject);
  end;

var
  FormMain        : TFormMain;
  ThreadConnexion : TThreadConnexion;
  bPeuFermer      : Boolean = False;

implementation

uses
  GKEasyComptageExport.DataModule.Main,
  GKEasyComptageExport.Form.Param;

{$R *.dfm}

procedure TFormMain.FormCreate(Sender: TObject);
begin
  Journaliser(RS_INF_DEMARRAGE);

  // Vérifie si on est en mode Test
  GTESTMODE   := FindCmdLineSwitch('TEST');
  if GTESTMODE then
    Journaliser(RS_INF_TEST);

  // Initialisation du chemin global de l'application
  GAPPPATH := ExtractFilePath(Application.ExeName);
  GINIFILE := ChangeFileExt(Application.ExeName, '.ini');

  // Chargement des paramètres de connexion
  ParamsConnexion := ParamsBase();
  if ParamsConnexion.BaseDonnees = '' then
  begin
    Journaliser(RS_ERR_PARAM_INI, NivArret);
    MessageDlg(RS_ERR_PARAM_INI, mtError, [mbOk], 0);
    Application.Terminate();
    Exit;
  end;

  // Vérifie la connexion à la base de données
  DemarrerThreadConnexion();
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
        Journaliser(RS_INF_ARRET);
        DataModuleMain.FFermeture  := True;
        DataModuleMain.ThreadTraitement.Terminate();
      end
      else begin
        Action := caFree;
        Journaliser(RS_INF_ARRET);
      end;
    end
    else begin
      Action := caFree;
      Journaliser(RS_INF_ARRET);
    end;
  end
  else begin
    // Minimise l'application et cache l'icône
    ShowWindow(Self.Handle, SW_HIDE);
    TrayTache.BalloonTitle  := Self.Caption;
    TrayTache.BalloonHint   := RS_INFO_EN_COURS;
    TrayTache.ShowBalloonHint();
    Action := caNone;
  end;
end;

procedure TFormMain.Quitter1Click(Sender: TObject);
begin
  if MessageBox(Self.Handle, PChar(RS_QUES_QUITTER), 'Question', MB_YESNO + MB_ICONQUESTION) = IDYES then
  begin
    bPeuFermer := True;
    Close();
  end;
end;

procedure TFormMain.Restaurer1Click(Sender: TObject);
begin
  ShowWindow(Self.Handle, SW_SHOW);
  Show();
end;

procedure TFormMain.StbStatutMouseEnter(Sender: TObject);
begin
  StbStatut.Hint := StbStatut.Panels[0].Text;
end;

procedure TFormMain.BtnExportPeriodeClick(Sender: TObject);
var
  Periode: TPeriodeTranche;
begin
  // Désactive les traitements
  DataModuleMain.TimTraitement.Enabled  := False;
  BtnParametrage.Enabled                := False;
  BtnQuitter.Enabled                    := False;
  LblProchain.Enabled                   := False;
  LblHeure.Enabled                      := False;

  // Récupération des dates pour le traitement
  Periode.dDateDebut  := StartOfTheDay(DtpDebut.DateTime);
  Periode.dDateFin    := RecodeMilliSecond(EndOfTheDay(DtpFin.DateTime), 0);

  // Démarre le thread du traitement
  DataModuleMain.LancerTraitement(Periode.dDateDebut, Periode.dDateFin, ParamsConnexion.MagId);
end;

procedure TFormMain.BtnExportTrancheClick(Sender: TObject);
var
  Periode : TPeriodeTranche;
  iResult : Integer;
begin
  // Désactive les traitements
  DataModuleMain.TimTraitement.Enabled  := False;
  BtnParametrage.Enabled                := False;
  BtnQuitter.Enabled                    := False;
  LblProchain.Enabled                   := False;
  LblHeure.Enabled                      := False;

  // Récupération des dates pour le traitement
  case GCONFIGAPP.Periodicite of
    // Si périodicité 1 fois par jour
    0: begin
      Periode.dDateDebut  := StartOfTheDay(DtpTrancheDate.Date);
      Periode.dDateFin    := RecodeMilliSecond(EndOfTheDay(DtpTrancheDate.Date), 0);
    end;
    // Si périodicité x fois par jour
    1: begin
      Periode.dDateDebut  := IncMinute(DateOf(DtpTrancheDate.Date) + TimeOf(DtpTrancheHeure.Time), -15);
      iResult             := CalculTranche(Periode.dDateDebut);
      Periode             := CalculPeriode(Periode.dDateDebut, iResult);
      Periode.dDateFin    := IncMinute(Periode.dDateDebut, GCONFIGAPP.Minutes - 15);
    end;
  end;

  // Démarre le thread du traitement
  DataModuleMain.LancerTraitement(Periode.dDateDebut, Periode.dDateFin, ParamsConnexion.MagId);
end;

procedure TFormMain.BtnParametrageClick(Sender: TObject);
begin
  // Lance le paramètrage
  Application.CreateForm(TFormParam, FormParam);
  try
    // Désactive les traitements
    DataModuleMain.TimTraitement.Enabled  := False;

    FormParam.TxtRepertoire.Text          := GCONFIGAPP.DestPath;
    FormParam.RdgPeridodicite.ItemIndex   := GCONFIGAPP.Periodicite;
    FormParam.RdgPeridodiciteClick(FormParam.RdgPeridodicite);
    FormParam.DtpHeure.Time               := GCONFIGAPP.Heure;
    FormParam.SpnMinutes.Value            := GCONFIGAPP.Minutes;
    FormParam.SpnJours.Value              := GCONFIGAPP.Jours;
    FormParam.ChkDemarrage.Checked        := GCONFIGAPP.bDemarrageAuto;
    FormParam.DtpDemarrage.Time           := GCONFIGAPP.tHeureDemarrage;
    FormParam.ChkDemarrageClick(FormParam.ChkDemarrage);
    FormParam.ChkArret.Checked            := GCONFIGAPP.bArretAuto;
    FormParam.DtpArret.Time               := GCONFIGAPP.tHeureArret;
    FormParam.ChkArretClick(FormParam.ChkArret);

    if FormParam.ShowModal() = mrOk then
    begin
      GCONFIGAPP.DestPath           := FormParam.TxtRepertoire.Text;
      GCONFIGAPP.Periodicite        := FormParam.RdgPeridodicite.ItemIndex;
      GCONFIGAPP.Heure              := FormParam.DtpHeure.Time;
      GCONFIGAPP.Minutes            := FormParam.SpnMinutes.Value;
      GCONFIGAPP.Jours              := FormParam.SpnJours.Value;
      GCONFIGAPP.bDemarrageAuto     := FormParam.ChkDemarrage.Checked;
      GCONFIGAPP.tHeureDemarrage    := FormParam.DtpDemarrage.Time;
      GCONFIGAPP.bArretAuto         := FormParam.ChkArret.Checked;
      GCONFIGAPP.tHeureArret        := FormParam.DtpArret.Time;

      EnregistreParametres();
      ChargerParametres();

      LblHeure.Caption          := FormatDateTime('DD/MM/YYYY hh:mm:ss', GCONFIGAPP.dNextAction);
      DataModuleMain.TimTraitement.Enabled  := True;

      // Affichage de l'heure de fin
      LblArret.Visible                    := GCONFIGAPP.bArretAuto;
      LblArret.Caption                    := Format(RS_LIB_ARRET, [FormatDateTime('hh:nn', GCONFIGAPP.tHeureArret)]);
      DataModuleMain.TimArretAuto.Enabled := GCONFIGAPP.bArretAuto;

      // Paramétrage de la tâche planifiée
      if GCONFIGAPP.bDemarrageAuto then
      begin
        SupprimeTachePlanifiee();
        CreerTachePlanifiee(GCONFIGAPP.tHeureDemarrage);
      end
      else
        SupprimeTachePlanifiee();
    end;
  finally
    FormParam.Free();
  end;
end;

procedure TFormMain.DemarrerThreadConnexion();
begin
  // Vérifie que le thread n'est pas démarré
  if Assigned(ThreadConnexion) then
  begin
    if not(ThreadConnexion.Finished) then
      ThreadConnexion.Terminate();
  end;

  Journaliser(RS_INF_TH_CONNECT_D);
  ThreadConnexion                 := TThreadConnexion.Create(True);
  ThreadConnexion.FDConnection    := DataModuleMain.FDConnection;
  ThreadConnexion.ParamsConnexion := ParamsConnexion;
  ThreadConnexion.OnTerminate     := FinThreadConnexion;
  ThreadConnexion.FreeOnTerminate := True;
  ThreadConnexion.Start();
end;

procedure TFormMain.FinThreadConnexion(Sender: TObject);
begin
  Journaliser(RS_INF_TH_CONNECT_F);

  // Si le thread à réussi à se connecter : on active les composants
  if TThreadConnexion(Sender).Connecte then
  begin
    try
      StbStatut.Panels[0].Text  := RS_INF_CONNEXION;

      // Récupère le MagId
      ParamsConnexion.MagId := DataModuleMain.RecupereMagId(ParamsConnexion.NomPoste, ParamsConnexion.NomMag);

      if ParamsConnexion.MagId <> 0 then
      begin
        // Vérifie si le magasin a le module
        if not(DataModuleMain.AModule(ParamsConnexion.MagId, 'EASYCOMPTAGE')) then
        begin
          Journaliser(RS_ERR_PARAM_MODULE, NivArret);
          MessageDlg(RS_ERR_PARAM_MODULE, mtError, [mbOk], 0);
          Application.Terminate();
        end;

        // Vérifie si le magasin a les paramètres
        if not( DataModuleMain.ParametreExiste(ParamsConnexion.MagId, 3, 10200)
          and   DataModuleMain.ParametreExiste(ParamsConnexion.MagId, 3, 10201)
          and   DataModuleMain.ParametreExiste(ParamsConnexion.MagId, 3, 10202)
          and   DataModuleMain.ParametreExiste(ParamsConnexion.MagId, 3, 10203)) then
        begin
          Journaliser(Format(RS_ERR_PARAM_BASE, [RS_ERR_PARAM_GENPARAM]), NivArret);
          MessageBox(Self.Handle, PChar(Format(RS_ERR_PARAM_BASE, [RS_ERR_PARAM_GENPARAM])), 'Erreur', MB_ICONERROR);
          Application.Terminate();
        end
        else begin
          Self.Caption              := Format(RS_LIB_TITRE, [ParamsConnexion.NomMag]);
          TrayTache.Hint            := Self.Caption;
          LblProchain.Enabled       := True;
          LblHeure.Enabled          := True;
          BtnParametrage.Enabled    := True;
          BtnExportPeriode.Visible  := GTESTMODE;
          DtpDebut.Visible          := GTESTMODE;
          DtpFin.Visible            := GTESTMODE;
          BtnExportTranche.Visible  := GTESTMODE;
          DtpTrancheDate.Visible    := GTESTMODE;
          DtpTrancheHeure.Visible   := GTESTMODE;
          ChargerParametres();
          DtpTrancheHeure.Enabled   := (GCONFIGAPP.Periodicite = 1);

          if GTESTMODE then
          begin
            DtpDebut.DateTime         := StartOfTheDay(Yesterday());
            DtpTrancheDate.DateTime   := StartOfTheDay(Yesterday());
            DtpTrancheHeure.DateTime  := StartOfTheDay(Yesterday());
            DtpFin.DateTime           := EndOfTheDay(Yesterday());
          end;

          LblHeure.Caption          := FormatDateTime('DD/MM/YYYY hh:mm:ss', GCONFIGAPP.dNextAction);
          DataModuleMain.TimTraitement.Enabled  := True;

          // Paramétrage de la tâche planifiée
          if GCONFIGAPP.bDemarrageAuto then
          begin
            SupprimeTachePlanifiee();
            CreerTachePlanifiee(GCONFIGAPP.tHeureDemarrage);
          end
          else
            SupprimeTachePlanifiee();

          // Affichage de l'heure de fin
          LblArret.Visible                    := GCONFIGAPP.bArretAuto;
          LblArret.Caption                    := Format(RS_LIB_ARRET, [FormatDateTime('hh:nn', GCONFIGAPP.tHeureArret)]);
          DataModuleMain.TimArretAuto.Enabled := GCONFIGAPP.bArretAuto;
        end;

        if FindCmdLineSwitch('PARAM') then
        begin
          // Ouvre la fenêtre de paramètrage au besoin
          Journaliser(RS_INF_PARAM);
          BtnParametrage.Click();
        end
        else if FindCmdLineSwitch('AUTO') then
        begin
          // Cache la fenêtre en mode auto
          ShowWindow(Self.Handle, SW_HIDE);
          TrayTache.BalloonTitle  := Self.Caption;
          TrayTache.BalloonHint   := RS_INFO_EN_COURS;
          TrayTache.ShowBalloonHint();
        end;
      end
      else begin
        Journaliser(Format(RS_ERR_PARAM_BASE, [Format(RS_ERR_PARAM_MAG, [ParamsConnexion.MagId])]), NivArret);
        MessageBox(Self.Handle, PChar(Format(RS_ERR_PARAM_BASE, [Format(RS_ERR_PARAM_MAG, [ParamsConnexion.MagId])])), 'Erreur', MB_ICONERROR);
        Application.Terminate();
      end;
    finally
      DataModuleMain.FDConnection.Close();
    end;
  end
  else begin
    Journaliser(RS_ERR_CONNEXION, NivArret);
    MessageBox(Self.Handle, PChar(RS_ERR_CONNEXION), 'Erreur', MB_ICONERROR);
    Application.Terminate();    
  end;
end;

procedure TFormMain.Journaliser(const AMessage: String; const ANiveau: TNiveau = NivDetail);
begin
  GKEasyComptageExport.Methodes.Journaliser(AMessage, ANiveau);
end;

end.
