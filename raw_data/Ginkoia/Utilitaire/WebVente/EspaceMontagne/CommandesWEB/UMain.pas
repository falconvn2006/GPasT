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
  Db,
  dxmdaset,
  IdMessage,
  IdMessageClient,
  IdSMTP,
  wwDialog,
  wwidlg,
  wwLookupDialogRv,
  ImgList,
  IBODataset,
  ActionRv,
  dxBar,
  IdBaseComponent,
  IdComponent,
  IdTCPConnection,
  IdTCPClient,
  IdFTP,
  StdCtrls,
  wwcheckbox,
  wwCheckBoxRV,
  DBCtrls,
  RzDBEdit,
  RzDBBnEd,
  RzDBButtonEditRv,
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
  ExtCtrls,
  RzPanel,
  RzPanelRv,
  ComCtrls,
  vgCtrls,
  vgPageControlRv,
  wwclearbuttongroup,
  wwradiogroup,
  dxCntner,
  dxEditor,
  dxExEdtr,
  dxEdLib,
  dxDBELib,
  LMDCustomComponent,
  LMDWndProcComponent,
  LMDTrayIcon,
  Menus,
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
  cxClasses,
  RzEdit;

TYPE
  stPrmTimer = RECORD
    dtReplicBegin: TDateTime; // Heure de début de réplication
    dtReplicEnd: TDateTime; // Heure de fin de réplic
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
    OptPrmMails: TdxBarButton;
    OptPrmDB: TdxBarButton;
    Gax_TestResult: TActionGroupRv;
    Pgc_Params: TvgPageControlRv;
    Tab_EMAIL_Params: TTabSheet;
    Pan_SMTP: TRzPanelRv;
    Lab_EMAIL_User: TRzLabel;
    Lab_EMAIL_SMTP: TRzLabel;
    Lab_EMAIL_PWD: TRzLabel;
    Lab_EMAIL_DEST: TRzLabel;
    Chp_EMAIL_User: TwwDBEditRv;
    Chp_EMAIL_SMTP: TwwDBEditRv;
    Chp_EMAIL_PWD: TwwDBEditRv;
    Chp_EMAIL_DEST: TwwDBEditRv;
    Tab_Traitement: TTabSheet;
    RzPanelRv2: TRzPanelRv;
    Pan_FTP: TRzPanelRv;
    Lab_FTP_User: TRzLabel;
    Lab_FTP_URL: TRzLabel;
    Lab_FTP_PWD: TRzLabel;
    Lab_TrtFTP: TRzLabel;
    Chp_FTP_User: TwwDBEditRv;
    Chp_FTP_URL: TwwDBEditRv;
    Chp_FTP_PWD: TwwDBEditRv;
    RzPanelRv1: TRzPanelRv;
    Tab_DB_Params: TTabSheet;
    Tab_File_Params: TTabSheet;
    Nbt_FileSave: TLMDButton;
    Nbt_FileCancel: TLMDButton;
    Nbt_FTPSave: TLMDButton;
    Nbt_FTPCancel: TLMDButton;
    Pan_PathDB: TRzPanelRv;
    Lab_PathDB: TRzLabel;
    RzLabel6: TRzLabel;
    Chp_DBPath: TwwDBEditRv;
    Nbt_PathDB: TLMDSpeedButton;
    OpDlg_DBPath: TOpenDialog;
    Pan_NomMagEtPoste: TRzPanelRv;
    Lab_NomMag: TRzLabel;
    Lab_NomPoste: TRzLabel;
    Nbt_ValidDBChange: TLMDButton;
    Img_Onglets: TImageList;
    OptPrmFiles: TdxBarButton;
    Nbt_DBCancel: TLMDButton;
    Nbt_DBSave: TLMDButton;
    RzLabel2: TRzLabel;
    RzLabel1: TRzLabel;
    RzLabel3: TRzLabel;
    RzLabel5: TRzLabel;
    RzPanelRv3: TRzPanelRv;
    Lab_Status: TRzLabel;
    Lab_CurStatus: TRzLabel;
    RzPanelRv4: TRzPanelRv;
    Memo_Log: TMemo;
    Pan_TestResult: TRzPanelRv;
    Lab_TestResult: TRzLabel;
    Lab_CurResult: TRzLabel;
    RzPanelRv5: TRzPanelRv;
    Nbt_DoTraitement: TLMDButton;
    Chp_MagID: TwwDBEditRv;
    Chp_PosID: TwwDBEditRv;
    LK_Magasins: TwwLookupDialogRV;
    Chp_NomMag: TRzDBButtonEditRv;
    Chp_NomPoste: TRzDBButtonEditRv;
    Ds_DBParams: TDataSource;
    LK_Postes: TwwLookupDialogRV;
    Lab_EMAIL_Titre: TRzLabel;
    RzLabel8: TRzLabel;
    Lab_FTPNbTry: TRzLabel;
    Chp_FTPNbTry: TwwDBSpinEditRv;
    RzLabel4: TRzLabel;
    Nbt_Quitter: TLMDSpeedButton;
    RzPanelRv8: TRzPanelRv;
    RzLabel11: TRzLabel;
    RzLabel12: TRzLabel;
    Chp_DelOldLogAge: TwwDBSpinEditRv;
    Chp_DelOldLog: TwwCheckBoxRV;
    Lab_EMAIL_EXP: TRzLabel;
    Chp_EMAIL_EXP: TwwDBEditRv;
    Nbt_SendLog: TLMDSpeedButton;
    Pan_Articles: TRzPanelRv;
    Lab_FTPSendFolder: TRzLabel;
    Lab_TrtSend: TRzLabel;
    Chp_FTPSendFolder: TwwDBEditRv;
    Lab_FicToSend: TRzLabel;
    Chp_FTPSendExtention: TwwDBEditRv;
    Lab_InfoFicToSend: TRzLabel;
    Chp_FTPValidEnvoi: TwwCheckBoxRV;
    RzPanelRv6: TRzPanelRv;
    RzLabel7: TRzLabel;
    RzLabel9: TRzLabel;
    Chp_FTPGetFolder: TwwDBEditRv;
    Chp_LogErreurs: TwwRadioGroup;
    Lab_NivLog: TRzLabel;
    Tim_DoTraitement: TTimer;
    Tab_Timer: TTabSheet;
    OptTimer: TdxBarButton;
    RzPanelRv7: TRzPanelRv;
    Lab_TimerInterval: TRzLabel;
    RzLabel13: TRzLabel;
    Chp_TimerInterval: TwwDBSpinEditRv;
    Lab_TimerDeb: TRzLabel;
    Lab_TimerFin: TRzLabel;
    Chp_TimerDeb: TdxDBTimeEdit;
    Chp_TimerFin: TdxDBTimeEdit;
    MemD_PrmTimer: TdxMemData;
    Ds_PrmTimer: TDataSource;
    MemD_PrmTimerDEBUT: TTimeField;
    MemD_PrmTimerFIN: TTimeField;
    MemD_PrmTimerInterval: TIntegerField;
    RzLabel10: TRzLabel;
    LMDButton3: TLMDButton;
    LMDButton4: TLMDButton;
    Tray_Icon: TLMDTrayIcon;
    PopupMenu1: TPopupMenu;
    PopRestaure: TMenuItem;
    PopQuitter: TMenuItem;
    N1: TMenuItem;
    OptClose: TdxBarButton;
    GrpModeManuel: TActionGroupRv;
    OptSvgClose: TdxBarButton;
    RzPanelRv9: TRzPanelRv;
    RzLabel14: TRzLabel;
    Nbt_TestConnexion: TLMDButton;
    Nbt_ForceFTPSend: TLMDButton;
    Nbt_ActiverModeAuto: TLMDSpeedButton;
    Lab_EMAIL_Port: TRzLabel;
    Chp_EMAIL_Port: TwwDBEditRv;
    Chp_DelFTPFiles: TwwCheckBoxRV;
    Chp_FTPSend: TwwCheckBoxRV;
    Chp_FTPGet: TwwCheckBoxRV;
    PROCEDURE Nbt_TestConnexionClick(Sender: TObject);
    PROCEDURE FormDestroy(Sender: TObject);
    PROCEDURE FormCreate(Sender: TObject);
    PROCEDURE Nbt_PathDBClick(Sender: TObject);
    PROCEDURE Nbt_ValidDBChangeClick(Sender: TObject);
    PROCEDURE OptQuitterClick(Sender: TObject);
    PROCEDURE BtnSaveClick(Sender: TObject);
    PROCEDURE BtnCancelClick(Sender: TObject);
    PROCEDURE OptPrmMailsClick(Sender: TObject);
    PROCEDURE OptPrmDBClick(Sender: TObject);
    PROCEDURE OptPrmFilesClick(Sender: TObject);
    PROCEDURE Chp_FileChange(Sender: TObject);
    PROCEDURE Nbt_QuitterClick(Sender: TObject);
    PROCEDURE Chp_NomPosteBtnBeforeAction(sender: TObject;
      VAR Allow: Boolean);
    PROCEDURE Nbt_SendLogClick(Sender: TObject);
    PROCEDURE Nbt_ForceFTPSendClick(Sender: TObject);
    PROCEDURE LMDSpeedButton1Click(Sender: TObject);

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
  UMapping;
{$R *.DFM}

PROCEDURE TFrm_Main.InitParams;

BEGIN
  InitPrmTimer();

  WITH Dm_common.MyParams DO
  BEGIN
    // Infos FTP
    sFTPHost := MyIniFile.ReadString('FTP', 'URL', '');
    IF sFTPHost = '' THEN
      Chp_FTP_URL.Text := 'Saisir l''adresse, le nom d''utilisateur et le mot de passe d''accès au serveur FTP'
    ELSE
      Chp_FTP_URL.Text := sFTPHost;

    sFTPUser := MyIniFile.ReadString('FTP', 'USER', '');
    Chp_FTP_User.Text := sFTPUser;

    sFTPPwd := MyIniFile.ReadString('FTP', 'PWD', '');
    Chp_FTP_PWD.Text := sFTPPwd;

    iFTPNbTry := MyIniFile.ReadInteger('FTP', 'NB_TRY', 3);
    Chp_FTPNbTry.Text := IntToStr(iFTPNbTry);

    bDelFTPFiles := MyIniFile.ReadBool('FTP', 'DELFILES', True);
    Chp_DelFTPFiles.Checked := bDelFTPFiles;

    // Infos pour envoi de mails
    sSMTPHost := MyIniFile.ReadString('EMAIL', 'SMTP', '');
    Chp_EMAIL_SMTP.Text := sSMTPHost;

    sSMTPPort := MyIniFile.ReadString('EMAIL', 'PORT', '25');
    Chp_EMAIL_Port.Text := sSMTPPort;

    sSMTPUser := MyIniFile.ReadString('EMAIL', 'USER', '');
    IF sSMTPHost = '' THEN
      Chp_EMAIL_User.Text := 'Saisir informations de connexion à la messagerie'
    ELSE
      Chp_EMAIL_User.Text := sSMTPUser;

    sSMTPPwd := MyIniFile.ReadString('EMAIL', 'PWD', '');
    Chp_EMAIL_PWD.Text := sSMTPPwd;

    sMailDest := MyIniFile.ReadString('EMAIL', 'DEST', '');
    Chp_EMAIL_DEST.Text := sMailDest;

    sMailExp := MyIniFile.ReadString('EMAIL', 'EXPE', '');
    Chp_EMAIL_EXP.Text := sMailExp;

    // DB Interne
    sDBInterne := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'Data\COMMANDESWEB.IB';

    Dm_Common.MemD_DBParams.Close;
    Dm_Common.MemD_DBParams.Open;
    Dm_Common.MemD_DBParams.Append;

    // Infos de connection à la BDD
    sDBPath := MyIniFile.ReadString('DATABASE', 'PATH', '');
    Chp_DBPath.Text := sDBPath;

    // Info magasin
    sMagNom := MyIniFile.ReadString('NOMMAGS', 'MAG', '');
    Dm_Common.MemD_DBParamsMAGNOM.AsString := sMagNom;
    iMagId := MyIniFile.ReadInteger('NOMMAGS', 'MAGID', 0);
    Dm_Common.MemD_DBParamsMAGID.AsInteger := iMagID;

    // Info Poste
    sPosNom := MyIniFile.ReadString('NOMPOSTE', 'POSTE', '');
    Dm_Common.MemD_DBParamsPOSNOM.AsString := sPosNom;
    iPosID := MyIniFile.ReadInteger('NOMPOSTE', 'POSID', 0);
    Dm_Common.MemD_DBParamsPOSID.AsInteger := iPosID;

    Dm_Common.MemD_DBParams.Post;

    // Infos Envoi FTP
    FTPValidEnvoi := MyIniFile.ReadBool('SENDFILE', 'VERIF_SENT_FILES', True);
    Chp_FTPValidEnvoi.Checked := FTPValidEnvoi;

    FTPSendFolder := MyIniFile.ReadString('SENDFILE', 'PATH', '/import_pdf/');
    Chp_FTPSendFolder.Text := FTPSendFolder;

    FTPSendExtention := MyIniFile.ReadString('SENDFILE', 'FICTOSEND', 'PDF');
    Chp_FTPSendExtention.Text := FTPSendExtention;

    // Infos Get FTP
    Chp_FTPGetFolder.Text := MyIniFile.ReadString('GETFILE', 'PATH', '/export_xml/');
    FTPGetFolder := Chp_FTPGetFolder.Text;

    // Options
    bDelOldLog := MyIniFile.ReadBool('OPTIONS', 'DELOLDLOG', True);
    Chp_DelOldLog.Checked := bDelOldLog;

    iDelOldLogAge := MyIniFile.ReadInteger('OPTIONS', 'DELOLDLOGAGE', 5);
    Chp_DelOldLogAge.Text := IntToStr(iDelOldLogAge);
    iNiveauLog := MyIniFile.ReadInteger('OPTIONS', 'NIVEAU', 0);
    Chp_LogErreurs.Value := IntToStr(iNiveauLog);

    InitLogFileName(Memo_Log, Lab_Status, iNiveauLog);

    // Création des dossiers d'envoi/reception FTP locaux
    sGetFolder := IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'Received');
    ForceDirectories(sGetFolder);

    bSend := MyIniFile.ReadBool('OPTIONS', 'DOSEND', True);
    Chp_FTPSend.Checked := bSend;

    bGet := MyIniFile.ReadBool('OPTIONS', 'DOGET', True);
    Chp_FTPGet.Checked := bGet;

  END;

END;

PROCEDURE TFrm_Main.Nbt_TestConnexionClick(Sender: TObject);
BEGIN
  WITH Dm_Common DO
  BEGIN
    Sablier(True, Self);
    TRY

      IF FTPConnect() THEN
      BEGIN
        // Connection réussie
        Lab_TestResult.Caption := 'Connection réussie';
      END
      ELSE BEGIN
        // Connection échouée
        Lab_TestResult.Caption := 'Connection échoué, consultez le log';
      END;
      Sleep(500);
      FTPDisconnect();
      Gax_TestResult.Visible := True;
      Update;
    FINALLY
      Sablier(False, Self);
    END;
  END;
END;

PROCEDURE TFrm_Main.FormDestroy(Sender: TObject);
BEGIN

  MyIniFile.Free;

END;

PROCEDURE TFrm_Main.FormCreate(Sender: TObject);
VAR
  sMess: STRING;
BEGIN

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
    // Vide les champs
    WITH Dm_Common DO
    BEGIN
      MemD_DBParams.Edit;
      MemD_DBParamsMAGNOM.AsString := '';
      MemD_DBParamsPOSNOM.AsString := '';
      MemD_DBParamsSECNOM.AsString := '';
      MemD_DBParamsMAGID.AsInteger := 0;
      MemD_DBParamsPOSID.AsInteger := 0;
      MemD_DBParamsSECID.AsInteger := 0;
      MemD_DBParams.Post;
    END;
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

  // Infos FTP
  MyIniFile.WriteString('FTP', 'URL', Chp_FTP_URL.Text);
  MyIniFile.WriteString('FTP', 'USER', Chp_FTP_User.Text);
  MyIniFile.WriteString('FTP', 'PWD', Chp_FTP_PWD.Text);
  MyIniFile.WriteString('FTP', 'NB_TRY', Chp_FTPNbTry.Text);
  MyIniFile.WriteBool('FTP', 'VERIF_SENT_FILES', Chp_FTPValidEnvoi.Checked);
  MyIniFile.WriteBool('FTP', 'DELFILES', Chp_DelFTPFiles.Checked);

  // Infos pour envoi de mails
  MyIniFile.WriteString('EMAIL', 'SMTP', Chp_EMAIL_SMTP.Text);
  MyIniFile.WriteString('EMAIL', 'USER', Chp_EMAIL_User.Text);
  MyIniFile.WriteString('EMAIL', 'PWD', Chp_EMAIL_PWD.Text);
  MyIniFile.WriteString('EMAIL', 'DEST', Chp_EMAIL_DEST.Text);
  MyIniFile.WriteString('EMAIL', 'EXPE', Chp_EMAIL_EXP.Text);

  // Infos de connection à la BDD
  MyIniFile.WriteString('DATABASE', 'PATH', Chp_DBPath.Text);

  WITH Dm_Common DO
  BEGIN
    MyIniFile.WriteString('NOMMAGS', 'MAG', MemD_DBParamsMAGNOM.AsString);
    MyIniFile.WriteInteger('NOMMAGS', 'MAGID', MemD_DBParamsMAGID.AsInteger);

    MyIniFile.WriteString('NOMPOSTE', 'POSTE', MemD_DBParamsPOSNOM.AsString);
    MyIniFile.WriteInteger('NOMPOSTE', 'POSID', MemD_DBParamsPOSID.AsInteger);
  END;

  // Logs
  MyIniFile.WriteBool('OPTIONS', 'DELOLDLOG', Chp_DelOldLog.Checked);
  MyIniFile.WriteString('OPTIONS', 'DELOLDLOGAGE', Chp_DelOldLogAge.Text);
  MyIniFile.WriteString('OPTIONS', 'NIVEAU', Chp_LogErreurs.Value);

  // Infos Envoi FTP
  MyIniFile.WriteBool('SENDFILE', 'VERIF_SENT_FILES', Chp_FTPValidEnvoi.Checked);
  MyIniFile.WriteString('SENDFILE', 'PATH', Chp_FTPSendFolder.Text);
  MyIniFile.WriteString('SENDFILE', 'FICTOSEND', Chp_FTPSendExtention.Text);

  // Infos Get FTP
  MyIniFile.WriteString('GETFILE', 'PATH', Chp_FTPGetFolder.Text);

  // Activer ou non l'envoi/le get
  MyIniFile.WriteBool('OPTIONS', 'DOSEND', Chp_FTPSend.Checked);
  MyIniFile.WriteBool('OPTIONS', 'DOGET', Chp_FTPGet.Checked);

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

PROCEDURE TFrm_Main.OptPrmMailsClick(Sender: TObject);
BEGIN
  ActiveOnglet(1);
END;

PROCEDURE TFrm_Main.OptPrmDBClick(Sender: TObject);
BEGIN
  ActiveOnglet(2);
END;

PROCEDURE TFrm_Main.OptPrmFilesClick(Sender: TObject);
BEGIN
  ActiveOnglet(3);
END;

PROCEDURE TFrm_Main.OptTimerClick(Sender: TObject);
BEGIN
  ActiveOnglet(4);
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

PROCEDURE TFrm_Main.Chp_NomPosteBtnBeforeAction(sender: TObject;
  VAR Allow: Boolean);
BEGIN
  WITH Dm_Common DO
  BEGIN
    Que_Postes.Close;
    Que_Postes.ParamByName('MAGNOM').AsString := Chp_NomMag.Text;
  END;
END;

PROCEDURE TFrm_Main.Nbt_SendLogClick(Sender: TObject);
BEGIN
  Dm_Common.SendLog(True);
END;

PROCEDURE TFrm_Main.Nbt_ForceFTPSendClick(Sender: TObject);
BEGIN
  Dm_Common.FTPFolderProcess();
  //
END;

PROCEDURE TFrm_Main.LMDSpeedButton1Click(Sender: TObject);
BEGIN
  WITH Dm_Common DO
  BEGIN
    FTPConnect;
    FTP.ChangeDir('/export_xml/');
    FTPGetList();
    FTPDisconnect;
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

  LogAction('Prochain time dans (ms) : ' + inttostr(Tim_DoTraitement.Interval), 3);
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

PROCEDURE TFrm_Main.ActiveTimer;
BEGIN
  bModeAuto := True;

  OptClose.Caption := OptSvgClose.Caption;
  OptClose.Glyph := OptSvgClose.Glyph;

  GrpModeManuel.Visible := False;
  Hide;
  Tray_Icon.NoClose := True;

  SetTimerInterval();
  Tim_DoTraitement.Enabled := True;
END;

FUNCTION TFrm_Main.DoTraitement: boolean;
BEGIN
  Result := True;
  WITH Dm_Common DO
  BEGIN
    IF MyParams.bGet THEN
    BEGIN
      // Phase 1 : Récupération des fichiers
      FTPFilesGet();

      // Phase 2 : Traitement des fichiers
      ProcessXMLFiles();
    END;

    IF MyParams.bSend THEN
    BEGIN
      // Phase 3 : Envoi de ce qu'il y'a à envoyer
      FTPFolderProcess();
    END;

    // Vérifie s'il y'a eu des erreurs, et les envoyer dans ce cas
    IF iNbLog > 0 THEN
    BEGIN
      SendLog(bModeAuto);
    END;
  END;
END;

PROCEDURE TFrm_Main.Nbt_ActiverModeAutoClick(Sender: TObject);
BEGIN
  IF Dm_Common.ParamValides THEN
    ActiveTimer
  ELSE
    LogAction('/************ Erreur de paramétrage, impossible de démarrer le mode automatique *****************/', 1);
END;

PROCEDURE TFrm_Main.Nbt_DoTraitementClick(Sender: TObject);
BEGIN
  IF Dm_Common.ParamValides THEN
    DoTraitement()
  ELSE
    LogAction('/************ Erreur de paramétrage, impossible de démarrer le traitement *****************/', 1);
END;

PROCEDURE TFrm_Main.Initialize;
VAR
  sMess: STRING;
BEGIN
  // Lecture de l'ini
  InitParams();

  // Delete des vieux logs
  PurgeOldLogs(Dm_Common.MyParams.bDelOldLog, Dm_Common.MyParams.iDelOldLogAge);

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
    Grd_CloseAll.Close;

    IF FTP.Connected THEN
    BEGIN
      ftp.ABORT;
      FTP.Disconnect;
    END;
    Ginkoia.Close;
    DBinterne.Close;
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

