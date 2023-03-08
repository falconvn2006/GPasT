UNIT UMain;

INTERFACE

USES
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  // Uses perso
  IniFiles,
  WinSvc,
  // Fin uses perso
  Dialogs,
  vgPageControlRv,
  wwDialog,
  wwidlg,
  wwLookupDialogRv,
  ActionRv,
  Menus,
  LMDCustomComponent,
  LMDWndProcComponent,
  LMDTrayIcon,
  DB,
  dxmdaset,
  ExtCtrls,
  ImgList,
  dxBar,
  cxClasses,
  StdCtrls,
  wwclearbuttongroup,
  wwradiogroup,
  wwcheckbox,
  wwCheckBoxRV,
  dxCntner,
  dxEditor,
  dxExEdtr,
  dxEdLib,
  dxDBELib,
  Wwdbspin,
  wwDBSpinEditRv,
  Mask,
  wwdbedit,
  wwDBEditRv,
  LMDCustomButton,
  LMDButton,
  RzLabel,
  LMDControl,
  LMDBaseControl,
  LMDBaseGraphicButton,
  LMDCustomSpeedButton,
  LMDSpeedButton,
  RzPanel,
  RzPanelRv,
  ComCtrls,
  vgCtrls,
  dxSkinsCore,
  dxSkinsdxBarPainter,
  dxSkinBlack,
  dxSkinBlue,
  dxSkinCaramel,
  dxSkinCoffee,
  dxSkinDarkSide,
  dxSkinGlassOceans,
  dxSkiniMaginary,
  dxSkinLilian,
  dxSkinLiquidSky,
  dxSkinLondonLiquidSky,
  dxSkinMcSkin,
  dxSkinMoneyTwins,
  dxSkinOffice2007Black,
  dxSkinOffice2007Blue,
  dxSkinOffice2007Green,
  dxSkinOffice2007Pink,
  dxSkinOffice2007Silver,
  dxSkinPumpkin,
  dxSkinSilver,
  dxSkinStardust,
  dxSkinSummer2008,
  dxSkinsDefaultPainters,
  dxSkinValentine,
  dxSkinXmas2008Blue,
  wwdbdatetimepicker,
  wwDBDateTimePickerRv;

TYPE
  stPrmTimer = RECORD
    dtReplicBegin: TDateTime; // Heure de début de réplication
    dtReplicEnd: TDateTime; // Heure de fin de réplic
    dtVerifHier: TDateTime; // Heure de vérif des commandes de la veille
    iIntervale: Integer; // Intervale entre deux réplic (en minutes)
  END;

TYPE
  TFrm_Main = CLASS(TForm)
    Bm_Menu: TdxBarManager;
    OptEnvoiFTP: TdxBarButton;
    dxBarGroup1: TdxBarGroup;
    MnuExecution: TdxBarSubItem;
    OptQuitter: TdxBarButton;
    OptStockFTP: TdxBarButton;
    MnuParams: TdxBarSubItem;
    OptPrmDB: TdxBarButton;
    OpDlg_DBPath: TOpenDialog;
    Img_Onglets: TImageList;
    Tim_DoTraitement: TTimer;
    OptTimer: TdxBarButton;
    MemD_PrmTimer: TdxMemData;
    Ds_PrmTimer: TDataSource;
    MemD_PrmTimerDEBUT: TTimeField;
    MemD_PrmTimerFIN: TTimeField;
    MemD_PrmTimerInterval: TIntegerField;
    MemD_PrmTimerVerifHier: TTimeField;
    Tray_Icon: TLMDTrayIcon;
    PopupMenu1: TPopupMenu;
    PopRestaure: TMenuItem;
    PopQuitter: TMenuItem;
    N1: TMenuItem;
    OptClose: TdxBarButton;
    OptSvgClose: TdxBarButton;
    Pgc_Params: TvgPageControlRv;
    Tab_Traitement: TTabSheet;
    RzPanelRv2: TRzPanelRv;
    Pan_Boutons: TRzPanelRv;
    Nbt_Quitter: TLMDSpeedButton;
    Nbt_SendLog: TLMDSpeedButton;
    Pan_TestResult: TRzPanelRv;
    Lab_TestResult: TRzLabel;
    Lab_CurResult: TRzLabel;
    Pan_NETEVEN: TRzPanelRv;
    Lab_NETEVEN: TRzLabel;
    Pan_Tests: TRzPanelRv;
    Lab_Tests: TRzLabel;
    Nbt_TestConnexion: TLMDButton;
    Nbt_ForceFTPSend: TLMDButton;
    RzPanelRv3: TRzPanelRv;
    Lab_Status: TRzLabel;
    Lab_CurStatus: TRzLabel;
    RzPanelRv4: TRzPanelRv;
    Memo_Log: TMemo;
    Tab_DB_Params: TTabSheet;
    RzLabel3: TRzLabel;
    Pan_PathDB: TRzPanelRv;
    Lab_PathDB: TRzLabel;
    RzLabel6: TRzLabel;
    Nbt_PathDB: TLMDSpeedButton;
    Chp_DBPath: TwwDBEditRv;
    Nbt_ValidDBChange: TLMDButton;
    Nbt_DBCancel: TLMDButton;
    Nbt_DBSave: TLMDButton;
    Tab_Timer: TTabSheet;
    RzLabel10: TRzLabel;
    Pan_Timer: TRzPanelRv;
    Lab_TimerInterval: TRzLabel;
    RzLabel13: TRzLabel;
    Lab_TimerDeb: TRzLabel;
    Lab_TimerFin: TRzLabel;
    Chp_TimerInterval: TwwDBSpinEditRv;
    Chp_TimerDeb: TdxDBTimeEdit;
    Chp_TimerFin: TdxDBTimeEdit;
    Nbt_TempoCancel: TLMDButton;
    Nbt_TempoSave: TLMDButton;
    Pan_Logs: TRzPanelRv;
    RzLabel11: TRzLabel;
    RzLabel12: TRzLabel;
    Lab_NivLog: TRzLabel;
    Chp_DelOldLogAge: TwwDBSpinEditRv;
    Chp_DelOldLog: TwwCheckBoxRV;
    Chp_LogErreurs: TwwRadioGroup;
    LK_SiteWeb: TwwLookupDialogRV;
    Pan_Traitement: TRzPanelRv;
    Lab_Traitements: TRzLabel;
    Nbt_ActiverModeAuto: TLMDSpeedButton;
    Nbt_DoTraitement: TLMDButton;
    Nbt_TrtJour: TLMDButton;
    GrpModeManuel: TActionGroupRv;
    Chp_RedoDateDeb: TwwDBDateTimePickerRv;
    Chp_DateRedoFin: TwwDBDateTimePickerRv;
    Lab_Du: TRzLabel;
    Lab_Au: TRzLabel;
    MemD_Redo: TdxMemData;
    Ds_Redo: TDataSource;
    MemD_RedoDebut: TDateField;
    MemD_RedoFin: TDateField;
    PROCEDURE Nbt_TestConnexionClick(Sender: TObject);
    PROCEDURE FormDestroy(Sender: TObject);
    PROCEDURE FormCreate(Sender: TObject);
    PROCEDURE Nbt_PathDBClick(Sender: TObject);
    PROCEDURE Nbt_ValidDBChangeClick(Sender: TObject);
    PROCEDURE OptQuitterClick(Sender: TObject);
    PROCEDURE OptPrmDBClick(Sender: TObject);
    PROCEDURE BtnSaveClick(Sender: TObject);
    PROCEDURE BtnCancelClick(Sender: TObject);
    PROCEDURE Chp_FileChange(Sender: TObject);
    PROCEDURE Nbt_QuitterClick(Sender: TObject);
    PROCEDURE Nbt_SendLogClick(Sender: TObject);
    PROCEDURE Nbt_ForceFTPSendClick(Sender: TObject);

    PROCEDURE InitPrmTimer();
    PROCEDURE SetTimerInterval();
    PROCEDURE MajDebFinTimer();
    FUNCTION TraitementToDo(): boolean;
    FUNCTION DoTraitement(): boolean;
    PROCEDURE Tim_DoTraitementTimer(Sender: TObject);
    PROCEDURE OptTimerClick(Sender: TObject);
    PROCEDURE PopQuitterClick(Sender: TObject);
    PROCEDURE PopRestaureClick(Sender: TObject);
    PROCEDURE FormClose(Sender: TObject; VAR Action: TCloseAction);
    PROCEDURE Tray_IconDblClick(Sender: TObject);
    PROCEDURE OptCloseClick(Sender: TObject);
    PROCEDURE Nbt_ActiverModeAutoClick(Sender: TObject);
    PROCEDURE Nbt_DoTraitementClick(Sender: TObject);

    PROCEDURE Initialize();
    PROCEDURE FinTraitement();
    PROCEDURE OptEnvoiFTPClick(Sender: TObject);
    PROCEDURE Nbt_TrtJourClick(Sender: TObject);

  PRIVATE

    MyPrmTimer: stPrmTimer; // Contient les paramètres

    hNextReplic: TDateTime;

    hDebReplic, hFinReplic: TDateTime; // Date et heure de début et fin de réplic pour ce jour

    // Fichier INI
    MyIniFile: TIniFile;

    bModeAuto: boolean;

    { Déclarations privées }
    PROCEDURE InitParams();
    PROCEDURE SaveParams();
    PROCEDURE ActiveOnglet(CONST NumPage: Integer = 0);
    PROCEDURE ActiveTimer();

    PROCEDURE Attente_IB();
  PUBLIC
    { Déclarations publiques }
  END;

VAR
  Frm_Main: TFrm_Main;

IMPLEMENTATION

USES UCommon,
  UCommon_DM,
  FileCTRL,
  UMapping,
  DateUtils;
{$R *.DFM}

PROCEDURE TFrm_Main.InitParams;

BEGIN
  InitPrmTimer();

  WITH Dm_common.MyIniParams DO
  BEGIN
    // Infos de connection à la BDD
    sDBPath := MyIniFile.ReadString('DATABASE', 'PATH', '');
    Chp_DBPath.Text := sDBPath;

    // Options
    bDelOldLog := MyIniFile.ReadBool('OPTIONS', 'DELOLDLOG', True);
    Chp_DelOldLog.Checked := bDelOldLog;

    iDelOldLogAge := MyIniFile.ReadInteger('OPTIONS', 'DELOLDLOGAGE', 5);
    Chp_DelOldLogAge.Text := IntToStr(iDelOldLogAge);
    iNiveauLog := MyIniFile.ReadInteger('OPTIONS', 'NIVEAU', 0);
    Chp_LogErreurs.Value := IntToStr(iNiveauLog);

    dtHier := MyIniFile.ReadDateTime('TIMER', 'VERIFHIER', Trunc(Now + 4) + EncodeTime(8, 0, 0, 0));

    iMarketId := MyIniFile.ReadInteger('GENERIQUE','MARKETID',999);
    InitLogFileName(Memo_Log, Lab_Status, iNiveauLog);
  END;
END;

PROCEDURE TFrm_Main.Nbt_TestConnexionClick(Sender: TObject);
BEGIN
  WITH Dm_Common DO
  BEGIN
    IF DBReconnect THEN
    BEGIN
      // pour chaque site
      Que_GetSites.Close;
      Que_GetSites.Open;
      WHILE NOT Que_GetSites.EOF DO
      BEGIN
        Dm_Common.LitParams(False);

        Sablier(True, Self);
        TRY
          TestConnexions;
        FINALLY
          Sablier(False, Self);
        END;
        Que_GetSites.Next;
      END;
      Que_GetSites.Close;
      DBDisconnect;
    END;
  END;
END;

PROCEDURE TFrm_Main.Nbt_TrtJourClick(Sender: TObject);
BEGIN
  IF (MemD_RedoDebut.AsDateTime <> 0) AND (MemD_RedoFin.AsDateTime <> 0) THEN
  BEGIN
    // On demande d'abord le site.
    IF LK_SiteWeb.Execute THEN
    BEGIN
      IF Dm_Common.LitParams(True) THEN
      BEGIN
        IF (Dm_Common.MySiteParams.bGet) AND (Dm_Common.MySiteParams.sTypeGet = 'NETEVEN') THEN
        BEGIN
          // Refaire une journée pour NetEVEN
          Dm_Common.NetEvenGet(MemD_RedoDebut.AsDateTime, MemD_RedoFin.AsDateTime);
        END;
      END;
    END;
  END;
END;

PROCEDURE TFrm_Main.FormDestroy(Sender: TObject);
BEGIN
  MemD_Redo.Close;

  MyIniFile.Free;

END;

PROCEDURE TFrm_Main.FormCreate(Sender: TObject);
VAR
  sMess: STRING;
BEGIN
  GAPPATH := ExtractFilePath(Application.ExeName);
  GGENTMPPATH := GAPPATH + 'TmpGenerique\';
  GGENPATHFACTURE := GGENTMPPATH + 'Factures\';
  GGENPATHCDE     := GGENTMPPATH + 'CDE\';
  GGENPATHCSV     := GGENTMPPATH + 'CSV\';
  GGENARCHCDE     := GGENPATHCDE + 'Archive\';

  if not DirectoryExists(GGENPATHFACTURE) then
    ForceDirectories(GGENPATHFACTURE);

  if not DirectoryExists(GGENPATHCSV) then
    ForceDirectories(GGENPATHCSV);

  if not DirectoryExists(GGENARCHCDE) then
    ForceDirectories(GGENARCHCDE);
  
  // Init du log
  InitLogFileName(Memo_Log, Lab_Status, 0);

  IF ParamCount > 0 THEN
  BEGIN
    TRY
      // Défini si on est en mode auto ou non
      bModeAuto := (UpperCase(ParamStr(1)) = 'AUTO');

    EXCEPT
      LogAction('ERREUR - Erreur de paramétrage du mode auto', 0);
      Dm_Common.SendLog(bModeAuto);
      Application.Terminate;
    END;
  END;

  sMess := '';

  IF NOT (FileExists(ChangeFileExt(Application.ExeName, '.ini'))) THEN
  BEGIN
    sMess := 'ERREUR - Fichier INI inexistant, impossible de démarrer l''application';
    LogAction(sMess, 0);
    // Si on est en mode auto, on log, et on dit rien, et on quitte l'appli
    IF bModeAuto THEN
    BEGIN
      Dm_Common.SendLog(bModeAuto);
      Application.Terminate();
    END;
  END;

  MemD_Redo.Open;
  MemD_Redo.Append;
  MemD_RedoDebut.AsDateTime := DateOf(DateUtils.IncDay(Now, -1));
  MemD_RedoFin.AsDateTime := DateOf(DateUtils.IncDay(Now, -1));

  // Création de l'objet inifile
  MyIniFile := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));

  IF sMess <> '' THEN // Ereur sur l'ini, on affiche le paramétrage automatiquement
  BEGIN
    ShowMessage(sMess);
    InitParams(); // Chargement des valeurs par défaut
    ActiveOnglet(2); // Params base de donnée
  END
  ELSE BEGIN // Ok, pas de pb
    Initialize();
    ActiveOnglet(0);
  END;

  Lab_TestResult.Caption := '';
  Lab_Status.Caption := '';
  IF bModeAuto THEN
  BEGIN
    TRY
      LogAction('/************ DEBUT TRAITEMENT AUTO ' + DateTimeToStr(Now()) + ' *****************/', 3);

      ActiveTimer();

      LogAction('/************ FIN TRAITEMENT AUTO ' + DateTimeToStr(Now()) + ' *****************/', 3);
    FINALLY

    END;
  END
  ELSE
  BEGIN
    GrpModeManuel.Visible := True;

    OptClose.Caption := OptQuitter.Caption;
    OptClose.Glyph := OptQuitter.Glyph;

    Show;

    Tray_Icon.NoClose := False;
  END;
END;

PROCEDURE TFrm_Main.Nbt_PathDBClick(Sender: TObject);
BEGIN
  IF OpDlg_DBPath.Execute THEN
  BEGIN
    Chp_DBPath.Text := OpDlg_DBPath.Filename;
    Nbt_ValidDBChange.Visible := true;
  END;
END;

PROCEDURE TFrm_Main.Nbt_ValidDBChangeClick(Sender: TObject);
VAR
  wAnswer: Word;
BEGIN
  wAnswer := MessageDlg('Attention, cette opération va supprimer le paramétrage du magasin et ' + #13 + #10 + 'du poste.' + #13 + #10 + 'Etes-vous sûrs ?', mtConfirmation, [mbYes, mbNo], 0);
  IF wAnswer = mrYes THEN
  BEGIN
    // Rend invisible le bouton
    Nbt_ValidDBChange.Visible := False;

    // Sauvegarde des données
    SaveParams();

    // Lecture des données
    InitParams();

    // Connection à la base
    IF NOT (Dm_Common.DBReconnect) THEN
    BEGIN
      // Erreur de connection, on vide le champ
      Chp_DBPath.Text := 'Impossible de se connecter à la base de données';
    END;
  END;

END;

PROCEDURE TFrm_Main.OptQuitterClick(Sender: TObject);
BEGIN
  Tray_Icon.NoClose := False;
  Close;
END;

PROCEDURE TFrm_Main.SaveParams;
BEGIN
  // Infos Timer
  MyIniFile.WriteString('TIMER', 'DEBUT', MemD_PrmTimerDEBUT.AsString);
  MyIniFile.WriteString('TIMER', 'FIN', MemD_PrmTimerFIN.AsString);
  MyIniFile.WriteString('TIMER', 'INTERVAL', MemD_PrmTimerInterval.AsString);

  // Infos de connection à la BDD
  MyIniFile.WriteString('DATABASE', 'PATH', Chp_DBPath.Text);

  // Logs
  MyIniFile.WriteBool('OPTIONS', 'DELOLDLOG', Chp_DelOldLog.Checked);
  MyIniFile.WriteString('OPTIONS', 'DELOLDLOGAGE', Chp_DelOldLogAge.Text);
  MyIniFile.WriteString('OPTIONS', 'NIVEAU', Chp_LogErreurs.Value);

  MyIniFile.WriteDateTime('TIMER', 'VERIFHIER', Dm_Common.MyIniParams.dtHier);

END;

PROCEDURE TFrm_Main.BtnSaveClick(Sender: TObject);
BEGIN
  // Sauvegarde des paramètres
  SaveParams();

  // Retour à l'onglet 0
  BtnCancelClick(Sender);
END;

PROCEDURE TFrm_Main.BtnCancelClick(Sender: TObject);
BEGIN

  // Réinit des paramètres
  Initialize();
  //  InitParams();

    // Retour à l'onglet 0
  ActiveOnglet(0);
END;

PROCEDURE TFrm_Main.ActiveOnglet(CONST NumPage: Integer = 0);
VAR
  i: integer;
  iNumPage: integer;
  b: boolean;
BEGIN

  iNumPage := NumPage;

  // On vérif que l'on est dans la plage, sinon, page 0
  IF NOT ((iNumPage >= 0) AND (iNumPage <= Pgc_Params.PageCount)) THEN
    iNumPage := 0;

  Pgc_Params.ActivePageIndex := iNumPage;

  FOR i := 0 TO Bm_Menu.ItemCount - 1 DO
  BEGIN
    Bm_Menu.Items[i].Enabled := (iNumPage = 0);
  END;
  {  IF iNumPage = 0 THEN
    BEGIN
      // Page traitements                                                                                

      Bm_Menu.Bars[0].Visible := True;
    END
    ELSE BEGIN
      // Pages params, on grise le menu
      Bm_Menu.Bars[0].Visible := False;
    END;}

    // On désactive toutes les pages
  FOR i := 0 TO Pgc_Params.PageCount - 1 DO
  BEGIN
    b := (i = iNumPage);
    Pgc_Params.Pages[i].Visible := b;
    Pgc_Params.Pages[i].Enabled := b;
    Pgc_Params.Pages[i].TabVisible := b;
  END;

END;

PROCEDURE TFrm_Main.OptPrmDBClick(Sender: TObject);
BEGIN
  ActiveOnglet(1);
END;

PROCEDURE TFrm_Main.OptTimerClick(Sender: TObject);
BEGIN
  ActiveOnglet(2);
END;

PROCEDURE TFrm_Main.Chp_FileChange(Sender: TObject);
BEGIN
  IF Sender.ClassType = TwwDBEditRv THEN
    TwwDBEditRv(Sender).Text := UpperCase(TwwDBEditRv(Sender).Text);
END;

PROCEDURE TFrm_Main.Nbt_QuitterClick(Sender: TObject);
BEGIN
  Close;
END;

PROCEDURE TFrm_Main.Nbt_SendLogClick(Sender: TObject);
BEGIN
  // On demande d'abord le site.
  IF LK_SiteWeb.Execute THEN
  BEGIN
    Dm_Common.LitParams(False);

    Dm_Common.SendLog(True);
  END;
END;

PROCEDURE TFrm_Main.Nbt_ForceFTPSendClick(Sender: TObject);
BEGIN
  // On demande d'abord le site.
  IF LK_SiteWeb.Execute THEN
  BEGIN
    Dm_Common.LitParams(False);

    Dm_Common.FTPFolderProcess();
  END;
END;

FUNCTION TFrm_Main.TraitementToDo: Boolean;
BEGIN
  //  Result := False;
  TRY
    // Est ce qu'on est en période de réplication ?
    IF (hDebReplic <= Now) AND (Now <= hFinReplic) THEN
    BEGIN
      IF (NOT MapGinkoia.Backup) AND (NOT MapGinkoia.Launcher) AND (NOT MapGinkoia.Verifencours) AND (NOT MapGinkoia.LiveUpdate) THEN
      BEGIN
        Result := True;
      END
      ELSE BEGIN
        Result := False;
      END;
    END
    ELSE BEGIN
      Result := False;
    END;
  EXCEPT
    ON E: Exception DO
    BEGIN
      Result := False;
    END;
  END;
END;

PROCEDURE TFrm_Main.Tim_DoTraitementTimer(Sender: TObject);
BEGIN
  Tim_DoTraitement.Enabled := False;

  // Initialisation
  Initialize();

  // Vérifie si on doit effectuer
  IF TraitementToDo THEN
  BEGIN
    // Fait le traitement
    DoTraitement();
  END;

  // autoamtiquement fait par ActiveTimer();
//  // Mise à jour de l'heure de début et fin de réplic
//  MajDebFinTimer();
//
//  // Calcul du prochain enclenchement du timer
//  SetTimerInterval();

  // Fermeture des connexions
  FinTraitement();

  // Réactivation du timer
  ActiveTimer();
END;

PROCEDURE TFrm_Main.SetTimerInterval;
VAR
  hNextPeriode: TDateTime;
  iNextPeriodeMS: integer;
BEGIN
  MajDebFinTimer;

  // Bloc de calcul de l'intervale du timer
  TRY
    // Init random
    Randomize();

    // Est ce qu'on est en période de réplication (à 1h près)
    IF ((hDebReplic - (1 / 24)) <= Now) AND (Now <= hFinReplic) THEN
    BEGIN
      // On set l'intervalle avec l'interval habituel + un temps aléatoire pour etaler sur la période les magasins
      // intervale + ou - 30 secondes
      Tim_DoTraitement.Interval := MyPrmTimer.iIntervale + Trunc(Random(30000));
      hNextReplic := Now + (Tim_DoTraitement.Interval / (24 * 60 * 60 * 1000))
    END ELSE
    BEGIN
      // On set l'intervalle hors réplic
      // on calcule le prochain lancement, pour mettre l'intervalle comme il faut
      IF hDebReplic <= Now THEN
        hNextPeriode := ((hDebReplic + 1) - Now)
      ELSE
        hNextPeriode := Now - hDebReplic;

      // On se met 10 minutes avant le prochain lancement prévu
      hNextPeriode := hNextPeriode - (10 / (24 * 60));

      // On transforme en millisecondes et on fait - 2h
      iNextPeriodeMS := trunc(hNextPeriode * 24 * 60 * 60 * 1000) - (2 * 60 * 60 * 1000);

      IF iNextPeriodeMS <= 0 THEN
        iNextPeriodeMS := 60 * 60 * 1000;

      // On set le prochain timer
      Tim_DoTraitement.Interval := iNextPeriodeMS;

      hNextReplic := Now + hNextPeriode;
    END;
  EXCEPT
    ON E: Exception DO
    BEGIN
      // En cas d'exception, on relance le timer pour un intervale fixe, afin de réessayer
      Tim_DoTraitement.Interval := MyPrmTimer.iIntervale;
      hNextReplic := Now + (MyPrmTimer.iIntervale / (24 * 60 * 60 * 1000));
    END;
  END;

  LogAction('Prochain time dans (ms) : ' + inttostr(Tim_DoTraitement.Interval) + ' (' + FormatDateTime('HH:MM:SS', Now() + (Tim_DoTraitement.Interval / (24 * 60 * 60 * 1000))) + ')', 3);

  Tray_Icon.Hint := 'Ginkoia - Commandes WEB' + #13#10 + 'Prochain time à ' + FormatDateTime('HH:MM:SS', Now() + (Tim_DoTraitement.Interval / (24 * 60 * 60 * 1000)));

END;

PROCEDURE TFrm_Main.MajDebFinTimer;
BEGIN
  InitPrmTimer;

  // Récup de l'heure de début de réplic pour aujourd'hui
  hDebReplic := Trunc(Now) + Frac(MyPrmTimer.dtReplicBegin);

  // Récup de la fin de réplic
  hFinReplic := Trunc(Now) + Frac(MyPrmTimer.dtReplicEnd);
  IF MyPrmTimer.dtReplicBegin > MyPrmTimer.dtReplicEnd THEN // La fin est avant le début, donc fin le lendemain
    hFinReplic := hFinReplic + 1;

END;

PROCEDURE TFrm_Main.InitPrmTimer;
VAR
  iIntervale: integer;
BEGIN

  // Init du memdata
  MemD_PrmTimer.Close;
  MemD_PrmTimer.Open;
  MemD_PrmTimer.Append;

  // Heure de début
  MyPrmTimer.dtReplicBegin := StrToTime(MyIniFile.ReadString('TIMER', 'DEBUT', '08:00'));
  MemD_PrmTimerDEBUT.AsDateTime := MyPrmTimer.dtReplicBegin;

  // Heure de fin
  MyPrmTimer.dtReplicEnd := StrToTime(MyIniFile.ReadString('TIMER', 'FIN', '17:00'));
  MemD_PrmTimerFIN.AsDateTime := MyPrmTimer.dtReplicEnd;

  // Intervale
  iIntervale := MyIniFile.ReadInteger('TIMER', 'INTERVAL', 300);
  MemD_PrmTimerInterval.AsInteger := iIntervale;

  MyPrmTimer.iIntervale := iIntervale * 1000;

  MemD_PrmTimer.Post;
END;

PROCEDURE TFrm_Main.PopQuitterClick(Sender: TObject);
BEGIN
  IF OptQuitter.Enabled THEN
  BEGIN
    OptQuitter.Click;
  END;
END;

PROCEDURE TFrm_Main.PopRestaureClick(Sender: TObject);
BEGIN
  Show;
  FormStyle := FsStayOnTop;
  Application.processmessages;
  FormStyle := FsNormal;
END;

PROCEDURE TFrm_Main.FormClose(Sender: TObject; VAR Action: TCloseAction);
BEGIN
  IF Tray_Icon.NoClose THEN
  BEGIN
    Hide;
    Action := caNone;
  END;
END;

PROCEDURE TFrm_Main.Tray_IconDblClick(Sender: TObject);
BEGIN
  PopRestaure.Click;
END;

PROCEDURE TFrm_Main.OptCloseClick(Sender: TObject);
BEGIN
  Close;
END;

PROCEDURE TFrm_Main.OptEnvoiFTPClick(Sender: TObject);
BEGIN
  // On demande d'abord le site.
  IF LK_SiteWeb.Execute THEN
  BEGIN
    Dm_Common.LitParams(False);

    Dm_Common.FTPFolderProcess();
  END;
END;

PROCEDURE TFrm_Main.ActiveTimer;
BEGIN
  bModeAuto := True;

  OptClose.Caption := OptSvgClose.Caption;
  OptClose.Glyph := OptSvgClose.Glyph;

  GrpModeManuel.Visible := False;
  Hide;
  Tray_Icon.NoClose := True;

  SetTimerInterval();

  IF Dm_Common.DBReconnect THEN
  BEGIN
    Dm_Common.DBDisconnect;
    Tim_DoTraitement.Enabled := True;
  END
  ELSE BEGIN
    LogAction('Impossible de démarrer le mode automatique, connexion à la base impossible', 0);
  END;

END;

FUNCTION TFrm_Main.DoTraitement: boolean;
BEGIN
  Result := True;
  WITH Dm_Common DO
  BEGIN
    IF NOT DBReconnect THEN
    BEGIN
      LogAction('Erreur de connexion à la base de données', 0);
      Exit;
    END;

    Que_GetSites.Close;
    Que_GetSites.Open;
    // Pour chaque site
    WHILE NOT Que_GetSites.EOF DO
    BEGIN
      LogAction('********** ' + Que_GetSitesASS_NOM.AsString + ' **********', 3);
      IF LitParams(True) THEN
      BEGIN
        IF MySiteParams.bGet THEN
        BEGIN
          LogAction('Début réception', 3);
          // Phase 1 : Récupération des infos et insertion
          TRY
            DoGet(Chp_TimerDeb.Time,Chp_TimerFin.Time);

            // Au cas ou elle aie changé
            MyIniFile.WriteDateTime('TIMER', 'VERIFHIER', Dm_Common.MyIniParams.dtHier);
          EXCEPT
            ON e: Exception DO
            BEGIN
              LogAction('Erreur lors de la réception, site : ' + Que_GetSitesASS_NOM.AsString, 0);
              LogAction(E.Message, 0);
            END;
          END;
          LogAction('Fin réception', 3);

        END;

        IF MySiteParams.bSend THEN
        BEGIN
          LogAction('Début envoi', 3);
          TRY
            DoSend(Chp_TimerDeb.Time,Chp_TimerFin.Time);
          EXCEPT
            ON e: Exception DO
            BEGIN
              LogAction('Erreur lors de l''envoi, site : ' + Que_GetSitesASS_NOM.AsString, 0);
              LogAction(E.Message, 0);
            END;
          END;
          LogAction('Fin Envoi', 3);
        END;
      END
      ELSE BEGIN
        LogAction('/************ Erreur de paramétrage, impossible de démarrer le traitement *****************/', 0);
        LogAction(Que_GetSitesASS_NOM.AsString, 0);
        LogAction('/******************************************************************************************/', 0);
      END;
      LogAction('***********************************', 3);

      Que_GetSites.Next;
    END;
    Que_GetSites.Close;

    // Vérifie s'il y'a eu des erreurs, et les envoyer dans ce cas
    IF iNbLog > 0 THEN
    BEGIN
      SendLog(bModeAuto);
    END;

    // Déconnection de la DB
    DBDisconnect;
  END;
END;

PROCEDURE TFrm_Main.Nbt_ActiverModeAutoClick(Sender: TObject);
BEGIN
  //  IF Dm_Common.LitParams(True) THEN
  ActiveTimer
    //  ELSE
//    LogAction('/************ Erreur de paramétrage, impossible de démarrer le mode automatique *****************/', 1);
END;

PROCEDURE TFrm_Main.Nbt_DoTraitementClick(Sender: TObject);
BEGIN
  //  IF Dm_Common.ParamValides THEN
  DoTraitement()
    //  ELSE
//    LogAction('/************ Erreur de paramétrage, impossible de démarrer le traitement *****************/', 1);
END;

PROCEDURE TFrm_Main.Initialize;
VAR
  sMess: STRING;
BEGIN
  // Lecture de l'ini
  InitParams();

  // Delete des vieux logs
  PurgeOldLogs(Dm_Common.MyIniParams.bDelOldLog, Dm_Common.MyIniParams.iDelOldLogAge);

  // Avant toute chose, on attend Interbase
  LogAction('/************ Attente Intebase Server ' + DateTimeToStr(Now()) + ' *****************/', 3);
  Attente_IB;

  // Connection à la BDD
  IF NOT Dm_Common.DBReconnect() THEN
  BEGIN
    // SI mode auto et echec, on déco
    IF bModeAuto THEN
    BEGIN
      sMess := 'ERREUR - Connection DB échouée, impossible de démarrer l''application';
      LogAction(sMess, 0);
      Dm_common.SendLog(bModeAuto);
      Application.Terminate();
    END
    ELSE
    BEGIN
      Nbt_DoTraitement.Enabled := False;
    END;
    // si pas mode auto, a voir... (positionnement auto dans les paramètres ?
  END;
END;

PROCEDURE TFrm_Main.FinTraitement;
BEGIN
  MemD_PrmTimer.Close;
  WITH Dm_Common DO
  BEGIN
    IF FTP.Connected THEN
    BEGIN
      ftp.ABORT;
      FTP.Disconnect;
    END;
    DBDisconnect;
  END;
END;

PROCEDURE TFrm_Main.Attente_IB;
VAR
  hSCManager: SC_HANDLE;
  hService: SC_HANDLE;
  Statut: TServiceStatus;
  tempMini: DWORD;
  CheckPoint: DWORD;
  NbBcl: Integer;
BEGIN
  hSCManager := OpenSCManager(NIL, NIL, SC_MANAGER_CONNECT);
  hService := OpenService(hSCManager, 'InterBaseGuardian', SERVICE_QUERY_STATUS);
  IF hService <> 0 THEN
  BEGIN // Service non installé
    QueryServiceStatus(hService, Statut);
    CheckPoint := 0;
    NbBcl := 0;
    WHILE (statut.dwCurrentState <> SERVICE_RUNNING) OR
      (CheckPoint <> Statut.dwCheckPoint) DO
    BEGIN
      CheckPoint := Statut.dwCheckPoint;
      tempMini := Statut.dwWaitHint + 1000;
      Sleep(tempMini);
      QueryServiceStatus(hService, Statut);
      Inc(nbBcl);
      IF NbBcl > 900 THEN BREAK;
    END;
    IF NbBcl < 900 THEN
    BEGIN
      CloseServiceHandle(hService);
      hService := OpenService(hSCManager, 'InterBaseServer', SERVICE_QUERY_STATUS);
      IF hService <> 0 THEN
      BEGIN // Service non installé
        QueryServiceStatus(hService, Statut);
        CheckPoint := 0;
        NbBcl := 0;
        WHILE (statut.dwCurrentState <> SERVICE_RUNNING) OR
          (CheckPoint <> Statut.dwCheckPoint) DO
        BEGIN
          CheckPoint := Statut.dwCheckPoint;
          tempMini := Statut.dwWaitHint + 1000;
          Sleep(tempMini);
          QueryServiceStatus(hService, Statut);
          Inc(nbBcl);
          IF NbBcl > 900 THEN BREAK;
        END;
      END;
    END;
  END;
  CloseServiceHandle(hService);
  CloseServiceHandle(hSCManager);
END;

END.

