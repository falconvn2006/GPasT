UNIT UMain;

INTERFACE

USES
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  // Uses perso
  idFtpCommon, IniFiles,  XMLCursor, StdXML_TLB,
  // Fin uses perso
  Dialogs, Db, wwdblook, Wwdbdlg, wwDBLookupComboDlgRv, ApOpenDlg,
  LMDControl, LMDBaseControl, LMDBaseGraphicButton, LMDCustomSpeedButton,
  LMDSpeedButton, IBDataset, StdCtrls, LMDCustomButton, LMDButton,
  ActionRv, dxBar, IB_Components, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, dxmdaset, wwDialog, wwidlg,
  wwLookupDialogRv, ImgList, IdFTP, DBCtrls, RzDBEdit, RzDBBnEd,
  RzDBButtonEditRv, Wwdbspin, wwDBSpinEditRv, wwcheckbox, wwCheckBoxRV,
  Mask, wwdbedit, wwDBEditRv, RzLabel, ExtCtrls, RzPanel, RzPanelRv,
  ComCtrls, vgCtrls, vgPageControlRv, IdMessageClient, IdSMTP, IdMessage;

TYPE stParam = RECORD
    // FTP
    sFTPHost: STRING;
    sFTPUser: STRING;
    sFTPPwd: STRING;
    iFTPNbTry: Integer;

    // EMail
    sSMTPHost: STRING;
    sSMTPUser: STRING;
    sSMTPPwd: STRING;
    sMailDest: STRING;
    sMailExp: STRING;
    // DB
    sDBPath: STRING;

    // Params du poste
    iMagID: integer;
    sMagNom: STRING;
    iPosID: integer;
    sPosNom: STRING;
    iSecID: Integer;
    sSecNom: STRING;

    iDelOldLogAge: integer;
    bDelOldLog: boolean;
  END;

TYPE
  TFrm_Main = CLASS(TForm)
    FTP: TIdFTP;
    Ginkoia: TIB_Connection;
    IbQ_GetNomenclature: TIB_Query;
    IbT_Select: TIB_Transaction;
    IbQ_GetGenre: TIB_Query;
    IbQ_GetArticle: TIB_Query;
    Bm_Menu: TdxBarManager;
    OptArticlesFTP: TdxBarButton;
    OptEnvoiFTP: TdxBarButton;
    dxBarGroup1: TdxBarGroup;
    MnuExecution: TdxBarSubItem;
    OptQuitter: TdxBarButton;
    SubMnuAvecFTP: TdxBarSubItem;
    SubMnuExportSeul: TdxBarSubItem;
    OptArticles: TdxBarButton;
    OptStockFTP: TdxBarButton;
    OptStock: TdxBarButton;
    MnuParams: TdxBarSubItem;
    OptPrmMails: TdxBarButton;
    OptPrmDB: TdxBarButton;
    Grd_CloseAll: TGroupDataRv;
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
    Pan_Articles: TRzPanelRv;
    Lab_ArtFile: TRzLabel;
    Lab_DCSFile: TRzLabel;
    Lab_GenreFile: TRzLabel;
    Lab_ArtFTPFolder: TRzLabel;
    Lab_TrtArticles: TRzLabel;
    Chp_FileArt: TwwDBEditRv;
    Chp_FileGenre: TwwDBEditRv;
    Chp_ArtFTPFolder: TwwDBEditRv;
    Pan_Stock: TRzPanelRv;
    Lab_StkFile: TRzLabel;
    Lab_StockFTPFolder: TRzLabel;
    Lab_TrtStock: TRzLabel;
    Chp_FileStk: TwwDBEditRv;
    Chp_StockFTPFolder: TwwDBEditRv;
    Nbt_FileSave: TLMDButton;
    Nbt_FileCancel: TLMDButton;
    Nbt_FTPSave: TLMDButton;
    Nbt_FTPCancel: TLMDButton;
    Pan_PathDB: TRzPanelRv;
    Lab_PathDB: TRzLabel;
    RzLabel6: TRzLabel;
    Chp_DBPath: TwwDBEditRv;
    Que_Postes: TIBOQuery;
    Que_Magasins: TIBOQuery;
    LMDSpeedButton1: TLMDSpeedButton;
    OpDlg_DBPath: TApOpenDialog;
    Pan_NomMagEtPoste: TRzPanelRv;
    Lab_NomMag: TRzLabel;
    Lab_NomPoste: TRzLabel;
    Nbt_ValidDBChange: TLMDButton;
    Que_PostesPOS_NOM: TStringField;
    Que_MagasinsMAG_NOM: TStringField;
    Que_MagasinsMAG_ENSEIGNE: TStringField;
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
    Nbt_TestConnection: TLMDButton;
    Nbt_ForceFTPSend: TLMDButton;
    RzPanelRv6: TRzPanelRv;
    RzPanelRv7: TRzPanelRv;
    Nbt_ExportArticle: TLMDButton;
    Nbt_ExportStock: TLMDButton;
    Nbt_ExportArticleFTP: TLMDButton;
    Nbt_ExportStockFTP: TLMDButton;
    Chp_MagID: TwwDBEditRv;
    Chp_PosID: TwwDBEditRv;
    Chp_SecID: TwwDBEditRv;
    Lab_Secteur: TRzLabel;
    Que_Secteurs: TIBOQuery;
    LK_Magasins: TwwLookupDialogRV;
    Chp_NomMag: TRzDBButtonEditRv;
    Chp_NomPoste: TRzDBButtonEditRv;
    Chp_NomSecteur: TRzDBButtonEditRv;
    Que_MagasinsMAG_ID: TIntegerField;
    Que_PostesPOS_ID: TIntegerField;
    Que_SecteursSEC_ID: TIntegerField;
    Que_SecteursSEC_NOM: TStringField;
    MemD_DBParams: TdxMemData;
    MemD_DBParamsMAGNOM: TStringField;
    MemD_DBParamsPOSNOM: TStringField;
    MemD_DBParamsSECNOM: TStringField;
    MemD_DBParamsMAGID: TIntegerField;
    MemD_DBParamsPOSID: TIntegerField;
    MemD_DBParamsSECID: TIntegerField;
    Ds_DBParams: TDataSource;
    LK_Postes: TwwLookupDialogRV;
    LK_Secteurs: TwwLookupDialogRV;
    Lab_EMAIL_Titre: TRzLabel;
    RzLabel7: TRzLabel;
    RzLabel8: TRzLabel;
    RzLabel9: TRzLabel;
    IbQ_GetStock: TIB_Query;
    Chp_FTPValidEnvoi: TwwCheckBoxRV;
    Lab_FTPNbTry: TRzLabel;
    Chp_FTPNbTry: TwwDBSpinEditRv;
    RzLabel4: TRzLabel;
    LMDSpeedButton2: TLMDSpeedButton;
    Chp_FileDCS: TwwDBEditRv;
    RzPanelRv8: TRzPanelRv;
    RzLabel11: TRzLabel;
    RzLabel12: TRzLabel;
    Chp_DelOldLogAge: TwwDBSpinEditRv;
    Chp_DelOldLog: TwwCheckBoxRV;
    SMTP: TIdSMTP;
    idMsgSend: TIdMessage;
    Lab_EMAIL_EXP: TRzLabel;
    Chp_EMAIL_EXP: TwwDBEditRv;
    Nbt_SendLog: TLMDSpeedButton;
    PROCEDURE FTPConnected(Sender: TObject);
    PROCEDURE FTPDisconnected(Sender: TObject);
    PROCEDURE Nbt_TestConnectionClick(Sender: TObject);
    PROCEDURE Nbt_SendFileClick(Sender: TObject);
    PROCEDURE FTPWorkBegin(Sender: TObject; AWorkMode: TWorkMode;
      CONST AWorkCountMax: Integer);
    PROCEDURE FTPWorkEnd(Sender: TObject; AWorkMode: TWorkMode);
    PROCEDURE Nbt_AbortClick(Sender: TObject);
    PROCEDURE FormDestroy(Sender: TObject);
    PROCEDURE FormCreate(Sender: TObject);
    PROCEDURE FormCloseQuery(Sender: TObject; VAR CanClose: Boolean);
    PROCEDURE LMDSpeedButton1Click(Sender: TObject);
    PROCEDURE Nbt_ValidDBChangeClick(Sender: TObject);
    PROCEDURE OptQuitterClick(Sender: TObject);
    PROCEDURE BtnSaveClick(Sender: TObject);
    PROCEDURE BtnCancelClick(Sender: TObject);
    PROCEDURE OptPrmMailsClick(Sender: TObject);
    PROCEDURE OptPrmDBClick(Sender: TObject);
    PROCEDURE OptPrmFilesClick(Sender: TObject);
    PROCEDURE Nbt_ExportArticleClick(Sender: TObject);
    PROCEDURE Chp_FileChange(Sender: TObject);
    PROCEDURE Nbt_ForceFTPSendClick(Sender: TObject);
    PROCEDURE Nbt_ExportArticleFTPClick(Sender: TObject);
    PROCEDURE Nbt_ExportStockClick(Sender: TObject);
    PROCEDURE Nbt_ExportStockFTPClick(Sender: TObject);
    PROCEDURE LMDSpeedButton2Click(Sender: TObject);
    PROCEDURE Chp_NomPosteBtnBeforeAction(sender: TObject;
      VAR Allow: Boolean);
    procedure Nbt_SendLogClick(Sender: TObject);
  PRIVATE
    MyParams: stParam;
    MyIniFile: TIniFile;

    bModeAuto: boolean;
    sTrtToDo: STRING;

    sFileEnCours: STRING;

    sToSendFolder: STRING;
    sSentFolder: STRING;

    { Déclarations privées }
    FUNCTION FTPConnect(): Boolean;
    PROCEDURE FTPDisconnect();
    FUNCTION SendFile(sFileSend: STRING): boolean;
    FUNCTION TestTransfert(sFileSend, sFileReceive: STRING): boolean;
    FUNCTION FTPFileExists(AFTPClient: TIdFTP; CONST ADirectory, AFile: STRING): Boolean;
    FUNCTION GetFTPFolder(sAFile: STRING): STRING;
    PROCEDURE InitParams();
    PROCEDURE SaveParams();
    FUNCTION DBReconnect(): boolean;
    PROCEDURE TraiteArticles();
    PROCEDURE TraiteStock();
    PROCEDURE ActiveOnglet(CONST NumPage: Integer = 0);
    PROCEDURE FileProcess(sFile: STRING);
    PROCEDURE FTPFolderProcess();
    FUNCTION QueryGetEntete(AQuery: TIB_Query): STRING;
    FUNCTION QueryVersFile(AQuery: TIB_Query; AFileName: STRING): boolean;
    FUNCTION SendMail(): Boolean;
    PROCEDURE SendLog();
  PUBLIC
    { Déclarations publiques }
  END;

VAR
  Frm_Main: TFrm_Main;

IMPLEMENTATION

USES UCommon
  , MD5Api
  , FileCTRL;
{$R *.DFM}

VAR
  bTransferringData: boolean;
  bAbortTransfer: boolean;
  iFileSize: integer;
  dtSTime: TDateTime;

PROCEDURE TFrm_Main.FTPConnected(Sender: TObject);
BEGIN
  LogAction('OK - Serveur : ' + MyParams.sFTPHost + ' -> Connection réussie');
  Lab_Status.Caption := 'Connecté...';
  Update;
END;

PROCEDURE TFrm_Main.FTPDisconnected(Sender: TObject);
BEGIN
  LogAction('OK - Déconnection');
  Lab_Status.Caption := 'Déconnecté';
  Update;
END;

PROCEDURE TFrm_Main.InitParams;

BEGIN

  // Infos FTP
  MyParams.sFTPHost := MyIniFile.ReadString('FTP', 'URL', '');
  Chp_FTP_URL.Text := MyParams.sFTPHost;

  MyParams.sFTPUser := MyIniFile.ReadString('FTP', 'USER', '');
  Chp_FTP_User.Text := MyParams.sFTPUser;

  MyParams.sFTPPwd := MyIniFile.ReadString('FTP', 'PWD', '');
  Chp_FTP_PWD.Text := MyParams.sFTPPwd;

  MyParams.iFTPNbTry := MyIniFile.ReadInteger('FTP', 'NB_TRY', 3);
  Chp_FTPNbTry.Text := IntToStr(MyParams.iFTPNbTry);

  Chp_FTPValidEnvoi.Checked := MyIniFile.ReadBool('FTP', 'VERIF_SENT_FILES', true);


  // Infos pour envoi de mails
  MyParams.sSMTPHost := MyIniFile.ReadString('EMAIL', 'SMTP', '');
  Chp_EMAIL_SMTP.Text := MyParams.sSMTPHost;


  MyParams.sSMTPUser := MyIniFile.ReadString('EMAIL', 'USER', '');
  Chp_EMAIL_User.Text := MyParams.sSMTPUser;

  MyParams.sSMTPPwd := MyIniFile.ReadString('EMAIL', 'PWD', '');
  Chp_EMAIL_PWD.Text := MyParams.sSMTPPwd;

  MyParams.sMailDest := MyIniFile.ReadString('EMAIL', 'DEST', '');
  Chp_EMAIL_DEST.Text := MyParams.sMailDest;

  MyParams.sMailExp := MyIniFile.ReadString('EMAIL', 'EXPE', '');
  Chp_EMAIL_EXP.Text := MyParams.sMailExp;

  MemD_DBParams.Close;
  MemD_DBParams.Open;
  MemD_DBParams.Append;

  // Infos de connection à la BDD
  MyParams.sDBPath := MyIniFile.ReadString('DATABASE', 'PATH', '');
  Chp_DBPath.Text := MyParams.sDBPath;

  // Info magasin
  MyParams.sMagNom := MyIniFile.ReadString('NOMMAGS', 'MAG', '');
  MemD_DBParamsMAGNOM.AsString := MyParams.sMagNom;
  MyParams.iMagId := MyIniFile.ReadInteger('NOMMAGS', 'MAGID', 0);
  MemD_DBParamsMAGID.AsInteger := MyParams.iMagID;


  // Info Poste

  MyParams.sPosNom := MyIniFile.ReadString('NOMPOSTE', 'POSTE', '');
  MemD_DBParamsPOSNOM.AsString := MyParams.sPosNom;
  MyParams.iPosID := MyIniFile.ReadInteger('NOMPOSTE', 'POSID', 0);
  MemD_DBParamsPOSID.AsInteger := MyParams.iPosID;

  // Secteur
  MyParams.sSecNom := MyIniFile.ReadString('NOMSECTEUR', 'SECTEUR', '');
  MemD_DBParamsSECNOM.AsString := MyParams.sSecNom;
  MyParams.iSecID := MyIniFile.ReadInteger('NOMSECTEUR', 'SECID', 0);
  MemD_DBParamsSECID.AsInteger := MyParams.iSecID;

  MemD_DBParams.Post;

  // Noms de fichier
  Chp_FileDCS.Text := MyIniFile.ReadString('ARTICLES', 'FILE_DCS', 'NOMENCLATURE.TXT');
  Chp_FileGenre.Text := MyIniFile.ReadString('ARTICLES', 'FILE_GENRE', 'GENRE.TXT');
  Chp_FileArt.Text := MyIniFile.ReadString('ARTICLES', 'FILE_ARTICLE', 'ARTWEB.TXT');
  Chp_ArtFTPFolder.Text := MyIniFile.ReadString('ARTICLES', 'SENDPATH', '/');

  Chp_FileStk.Text := MyIniFile.ReadString('STOCK', 'FILE_STOCK', 'STOCK.TXT');
  Chp_StockFTPFolder.Text := MyIniFile.ReadString('STOCK', 'SENDPATH', '/');

  MyParams.bDelOldLog := MyIniFile.ReadBool('OPTIONS', 'DELOLDLOG', True);
  Chp_DelOldLog.Checked := MyParams.bDelOldLog;
  MyParams.iDelOldLogAge := MyIniFile.ReadInteger('OPTIONS', 'DELOLDLOGAGE', 60);
  Chp_DelOldLogAge.Text := IntToStr(MyParams.iDelOldLogAge);


END;

FUNCTION TFrm_Main.FTPConnect: boolean;
BEGIN

  Result := False;

  IF bTransferringData THEN FTP.ABORT;

  InitParams();

  IF MyParams.sFTPHost <> '' THEN
  BEGIN
    // Au cas ou...
    IF FTP.Connected THEN FTP.Disconnect;

    FTP.Host := MyParams.sFTPHost;
    FTP.Username := MyParams.sFTPUser;
    FTP.Password := MyParams.sFTPPwd;

    Sablier(true, self);
    TRY

      FTP.Connect;
      IF FTP.Connected THEN
      BEGIN
        { conection réussie }
        Result := true;
      END;

    EXCEPT
      ON E: Exception DO
      BEGIN
        // Erreur à la connection, on log
        LogAction('ERREUR - Serveur : ' + MyParams.sFTPHost + ' -> Connection échoué');
      END;
    END;
    Sablier(false, self);
  END
  ELSE BEGIN
    // Host mal lu
    LogAction('ERREUR - Serveur  non renseigné dans l''Ini, vérifiez votre configuration.');
  END;
END;

PROCEDURE TFrm_Main.Nbt_TestConnectionClick(Sender: TObject);
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

PROCEDURE TFrm_Main.FTPDisconnect();
BEGIN
  TRY
    FTP.Disconnect;
  EXCEPT

  END;
END;

FUNCTION TFrm_Main.SendFile(sFileSend: STRING): boolean;
VAR
  sFolder: STRING;
  sFile: STRING;
BEGIN
  Sablier(True, Self);
  TRY
    sFile := ExtractFileName(sFileSend);
    sFolder := GetFTPFolder(sFile);
    // On teste s'il existe déjà
    IF FTPFileExists(FTP, sFolder, sFileSend) THEN
    BEGIN
      LogAction('INFO - ' + sFolder + sFile + ' : Fichier existant, sera ecrasé');
    END;


    Application.ProcessMessages;
    Update;

    // On envoie le fichier
    FTP.TransferType := ftBinary;
    sFileEnCours := sFile;
    FTP.Put(sFileSend, sFile, False);
    sFileEnCours := '';

    Application.ProcessMessages;
    Update;

    result := true;
  EXCEPT
    ON E: EXCEPTION DO
    BEGIN
      LogAction('ERREUR - Erreur d''envoi du fichier : ' + E.Message);
      result := false;
    END;
  END;
  Sablier(False, Self);

END;

FUNCTION TFrm_Main.FTPFileExists(AFTPClient: TIdFTP; CONST ADirectory, AFile: STRING): Boolean;
VAR
  AOldDir: STRING;
  FolderList: TStringList;
BEGIN
  Result := False;
  TRY
    IF NOT AFTPClient.Connected THEN //Pas connecté ?
      AFTPClient.Connect(); //On connecte
  EXCEPT
    FTP.Disconnect;
    Exit; //Impossible de connecter !
  END;

  FolderList := TStringList.Create;
  TRY
    AOldDir := AFTPClient.RetrieveCurrentDir; //sauvegarder le répertoire actuel
    TRY
      AFTPClient.ChangeDir(ADirectory); //Si le dossier n'existe pas -> exception levée
      TRY
        AFTPClient.List(FolderList, '', False); //Lister les fichiers
      FINALLY
        Result := FolderList.IndexOf(AFile) > 0;
      END;
    EXCEPT
    END;
  FINALLY
    AFTPClient.ChangeDir(AOldDir); //reviens à l'ancien dossier
    FolderList.Free; //Libère la StringList
  END;
END;



PROCEDURE TFrm_Main.Nbt_SendFileClick(Sender: TObject);
BEGIN
  FileProcess('pipo.txt');
END;

PROCEDURE TFrm_Main.FTPWorkBegin(Sender: TObject; AWorkMode: TWorkMode;
  CONST AWorkCountMax: Integer);
BEGIN

  bTransFerringData := true;
  IF sFileEnCours <> '' THEN
  BEGIN
    IF AWorkMode = wmRead THEN
    BEGIN
      Lab_Status.Caption := 'Download ' + sFileEnCours + ' en cours...'
    END
    ELSE
    BEGIN
      Lab_Status.Caption := 'Upload ' + sFileEnCours + ' en cours...'
    END;
  END;

  dtSTime := Now;

  Update;

  iFileSize := AWorkCountMax;

END;

PROCEDURE TFrm_Main.FTPWorkEnd(Sender: TObject; AWorkMode: TWorkMode);
BEGIN
  IF (sFileEnCours <> '') THEN
  BEGIN
    IF AWorkMode = wmRead THEN
    BEGIN
      LogAction('INFO - Download terminé : ' + sFileEnCours);
      Lab_Status.Caption := 'Download ' + sFileEnCours + ' terminé.'
    END
    ELSE
    BEGIN
      LogAction('INFO - Upload terminé : ' + sFileEnCours);
      Lab_Status.Caption := 'Upload ' + sFileEnCours + ' terminé.'
    END;
  END;

  iFileSize := 0;

  Update;

  bTransferringData := False;
END;

PROCEDURE TFrm_Main.Nbt_AbortClick(Sender: TObject);
BEGIN
  bAbortTransfer := true;
END;

PROCEDURE TFrm_Main.FormDestroy(Sender: TObject);
BEGIN
  IF bTransferringData THEN FTP.Abort;
  IF FTP.Connected THEN FTP.Disconnect;
END;

FUNCTION TFrm_Main.TestTransfert(sFileSend, sFileReceive: STRING): boolean;
VAR
  CRC1, CRC2: STRING;
BEGIN
  TRY
    // On recup le fichier (pour test + tard)
    sFileEnCours := ExtractFileName(sFileSend);
    FTP.Get(ExtractFileName(sFileSend), sFileReceive, True, false);
    sFileEnCours := '';

    CRC1 := MD5FromFile(sFileSend);
    CRC2 := MD5FromFile(sFileReceive);
    IF crc1 = crc2 THEN
    BEGIN
      // On supprime le fichier envoyé
      DeleteFile(sFileSend);
      LogAction('OK - Fichiers identique, transfert validé');
      Result := true
    END
    ELSE BEGIN
      // On supprime le fichier recu
      FTP.Delete(ExtractFileName(sFileSend));
      DeleteFile(sFileReceive);
      result := false;
      // les deux fichiers sont différents
      LogAction('ERREUR - Fichier erronné, transfert échoué');
      // Suppression du fichier envoyé, au cas ou
    END;
  EXCEPT
    ON E: EXCEPTION DO
    BEGIN
      LogAction('ERREUR - Erreur de récupération du fichier : ' + E.Message);
      result := false;
    END;
  END;
END;

PROCEDURE TFrm_Main.FormCreate(Sender: TObject);
VAR
  sMess: STRING;
BEGIN
  // Init du log
  InitLogFileName(Memo_Log, Lab_Status);


  IF ParamCount > 0 THEN
  BEGIN
    TRY
      // Défini si on est en mode auto ou non
      bModeAuto := (UpperCase(ParamStr(1)) = 'AUTO');

      // Défini le type de traitement à faire en auto
      IF bModeAuto THEN
        sTrtToDo := UpperCase(ParamStr(2));
    EXCEPT
      LogAction('ERREUR - Erreur de paramétrage du mode auto');
      SendLog();
      Application.Terminate;
    END;
  END;

  IF NOT (FileExists(ChangeFileExt(Application.ExeName, '.ini'))) THEN
  BEGIN
    sMess := 'ERREUR - Fichier INI inexistant, impossible de démarrer l''application';
    LogAction(sMess);
    // Si on est en mode auto, on log, et on dit rien
    IF NOT (bModeAuto) THEN
    BEGIN
      ShowMessage(sMess);
    END;
    SendLog();
    Application.Terminate();
  END;

  // Création de l'objet inifile
  MyIniFile := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));

  // Lecture de l'ini
  InitParams();

  // Delete des vieux logs
  PurgeOldLogs(MyParams.bDelOldLog, MyParams.iDelOldLogAge);

  // Connection à la BDD
  IF NOT DBReconnect() THEN
  BEGIN
    // SI mode auto et echec, on déco
    IF bModeAuto THEN
    BEGIN
      sMess := 'ERREUR - Connection DB échouée, impossible de démarrer l''application';
      LogAction(sMess);
      Application.Terminate();
    END;
    // si pas mode auto, a voir... (positionnement auto dans les paramètres ?
  END;

  sToSendFolder := IncludeTrailingBackslash(IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) + 'ToSend');
  ForceDirectories(sToSendFolder);

  sSentFolder := IncludeTrailingBackslash(IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) + 'Sent');
  ForceDirectories(sSentFolder);

  ActiveOnglet(0);

  Lab_TestResult.Caption := '';
  Lab_Status.Caption := '';

  IF bModeAuto THEN
  BEGIN
    TRY
      LogAction('/************ DEBUT TRAITEMENT AUTO ' + DateTimeToStr(Now()) + ' *************************/');
      // Traitement Article ou stock selon le cas
      IF sTrtToDo = 'STOCK' THEN
      BEGIN
        TraiteStock();
      END
      ELSE BEGIN
        TraiteArticles();
      END;

      // Envoi FTP des fichiers exportés
      FTPFolderProcess();
      LogAction('/************ FIN TRAITEMENT AUTO ' + DateTimeToStr(Now()) + ' *************************/');
    FINALLY

      // Fin d'appli
      Application.Terminate;
    END;
  END;

END;

PROCEDURE TFrm_Main.FileProcess(sFile: STRING);
VAR
  sFolder, sFileSend, sFileReceive: STRING;
  bTransOk: boolean;
  i: integer;
BEGIN
  //  Envoi du fichier :
  // Etape 1 : Connection FTP.
  // Etape 2 : Positionnement dans le dossier destination.
  // Etape 3 : Envoi du fichier.
  // Etape 4 : Récupération du fichier.
  // Etape 5 : Comparaison entre les 2, pour vérifier qu'ils sont identiques, si oui, on conserve le fichier reçu dans FileSent
  // Etape 6 : En cas d'erreur, retour à l'étape 1
  // Etape 7 : Si tout est ok, on supprime le fichier envoyé
  LogAction('');
  LogAction('/***************************************************/');
  LogAction('INFO - Envoi fichier ' + sFile);


  i := 0;
  REPEAT
    LogAction('INFO - Essai ' + IntToStr(i + 1) + '/' + IntToStr(MyParams.iFTPNbTry));
    bTransOK := FTPConnect();
    // Si la connection a bien réussie, on envoie le fichier
    IF bTransOK THEN
    BEGIN

      sFileSend := sToSendFolder + sFile;
      sFileReceive := sSentFolder + sFile;


      // Positionnement dans le bon dossier sur le site FTP.
      FTP.ChangeDir(GetFTPFolder(sFile));
      LogAction('OK - Positionnement dans ' + GetFTPFolder(sFile));
      Update;

      // Envoi du fichier
      bTransOK := SendFile(sFileSend);

      // Si l'envoi s'est bien passé, on teste le transfert par un controle de crc.
      IF bTransOK THEN
      BEGIN
        IF Chp_FTPValidEnvoi.Checked THEN
        BEGIN
          bTransOK := TestTransfert(sFileSend, sFileReceive);
        END
        ELSE BEGIN
          bTransOK := MoveFileEx(PChar(sFileSend), PChar(sFileReceive), MOVEFILE_REPLACE_EXISTING);
          IF bTransOK THEN
          BEGIN
            LogAction('OK - Déplacement vers dossier SENT réussi');
          END
          ELSE BEGIN
            LogAction('ERREUR - Déplacement vers dossier SENT échoué');
          END;
        END;
      END;
    END;
    // Si le transfert ne s'est pas bien passé, on recommence (x fois max a param dans l'ini)
    IF NOT (bTransOK) THEN inc(i);

    // Déco avant nouvel essai
    FTPDisconnect();

  UNTIL ((bTransOK) OR (i = MyParams.iFTPNbTry));


  IF NOT (bTransOK) THEN
  BEGIN
    // On est sorti pour cause de 3 essais échoué
    LogAction('ERREUR - ' + IntToStr(MyParams.iFTPNbTry) + ' Echecs successifs, Fichier non transmis');
  END;
  LogAction('/***************************************************/');

END;

PROCEDURE TFrm_Main.FormCloseQuery(Sender: TObject; VAR CanClose: Boolean);
BEGIN
  Grd_CloseAll.Close;
  MyIniFile.Free
END;

PROCEDURE TFrm_Main.TraiteArticles;
VAR
  sFileDCS, sFileArticles, sFileGenre: STRING;
  i, j: integer;
BEGIN
  LogAction('');
  LogAction('/***************************************************/');
  LogAction('INFO - Début traitement des fichiers articles');

  // Relecture des params
  InitParams;

  LogAction('INFO - Export dans : ' + sToSendFolder);

  // Connection à la BDD
  IF DBReconnect() THEN
  BEGIN
    TRY
      // Export de la nomenclature
      sFileDCS := Chp_FileDCS.Text;
      LogAction('OK - Début Fichier 1 : ' + sFileDCS);

      IbQ_GetNomenclature.Close;
      IbQ_GetNomenclature.ParamByName('SECID').AsInteger := StrToInt(Chp_SecId.Text);
      IbQ_GetNomenclature.Open;
      IbQ_GetNomenclature.FetchAll;

      IF NOT QueryVersFile(IbQ_GetNomenclature, sFileDCS) THEN
      BEGIN
        // abandon ?
      END;
      IbQ_GetNomenclature.Close;

      // Export du genre
      sFileGenre := Chp_FileGenre.Text;
      LogAction('OK - Début Fichier 2 : ' + sFileGenre);
      IbQ_GetGenre.Close;
      IbQ_GetGenre.Open;
      IF NOT QueryVersFile(IbQ_GetGenre, sFileGenre) THEN
      BEGIN
        // abandon ?
      END;
      IbQ_GetGenre.Close;

      // Export des articles
      sFileArticles := Chp_FileArt.Text;
      LogAction('OK - Début Fichier 3 : ' + sFileArticles);
      IbQ_GetArticle.Close;
      IbQ_GetArticle.ParamByName('MAGID').AsInteger := MyParams.iMagID;
      IbQ_GetArticle.ParamByName('SECID').AsInteger := StrToInt(Chp_SecId.Text);
      IbQ_GetArticle.Open;
      IF NOT QueryVersFile(IbQ_GetArticle, sFileArticles) THEN
      BEGIN
        // abandon ?
      END;
      IbQ_GetArticle.Close;
      LogAction('OK - Fichiers articles exportés correctement');

    EXCEPT
      ON e: exception DO
      BEGIN
        LogAction('ERREUR - ' + E.Message);
      END;
    END;
    LogAction('INFO - Fin traitement des fichiers articles');
    LogAction('/***************************************************/');

  END;
END;

PROCEDURE TFrm_Main.TraiteStock;
VAR
  sFileStock: STRING;
BEGIN
  LogAction('');
  LogAction('/***************************************************/');
  LogAction('INFO - Début traitement du fichier stock');

  // Relecture des params
  InitParams;

  LogAction('INFO - Export dans : ' + sToSendFolder);

  // Connection à la BDD
  IF DBReconnect() THEN
  BEGIN
    TRY

      // Export des stocks
      sFileStock := Chp_FileStk.Text;
      LogAction('OK - Début Fichier : ' + sFileStock);
      IbQ_GetStock.Close;
      IbQ_GetStock.ParamByName('MAGID').AsInteger := MyParams.iMagID;
      IbQ_GetStock.Open;
      IF NOT QueryVersFile(IbQ_GetStock, sFileStock) THEN
      BEGIN
        // abandon ?
      END;
      IbQ_GetStock.Close;
      LogAction('OK - Fichier stock exporté correctement');
    EXCEPT
      ON e: exception DO
      BEGIN
        LogAction('ERREUR - ' + E.Message);
      END;
    END;
    LogAction('INFO - Fin traitement du fichier stock');
    LogAction('/***************************************************/');

  END;

END;

PROCEDURE TFrm_Main.LMDSpeedButton1Click(Sender: TObject);
BEGIN
  IF OpDlg_DBPath.Execute THEN
  BEGIN
    Chp_DBPath.Text := OpDlg_DBPath.Filename;
    Nbt_ValidDBChange.Visible := true;
  END;
END;

FUNCTION TFrm_Main.DBReconnect: boolean;
BEGIN
  // Déconnection de la DB
  Ginkoia.Disconnect;

  Ginkoia.Database := MyParams.sDBPath;
  TRY
    Ginkoia.Connect;

    IF Ginkoia.Connected THEN
    BEGIN
      Que_Magasins.Open;
      Que_Postes.Open;
      Result := True;
    END
    ELSE BEGIN
      // Erreur, a gerer
      Result := False;
    END;
  EXCEPT
    Result := False;
    Ginkoia.Disconnect;
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
    MemD_DBParams.Edit;
    MemD_DBParamsMAGNOM.AsString := '';
    MemD_DBParamsPOSNOM.AsString := '';
    MemD_DBParamsSECNOM.AsString := '';
    MemD_DBParamsMAGID.AsInteger := 0;
    MemD_DBParamsPOSID.AsInteger := 0;
    MemD_DBParamsSECID.AsInteger := 0;
    MemD_DBParams.Post;

    // Rend invisible le bouton
    Nbt_ValidDBChange.Visible := False;

    // Sauvegarde des données
    SaveParams();

    // Lecture des données
    InitParams();

    // Connection à la base
    IF NOT (DBReconnect) THEN
    BEGIN
      // Erreur de connection, on vide le champ
      Chp_DBPath.Text := 'Impossible de se connecter à la base de données';
    END;
  END;

END;

PROCEDURE TFrm_Main.OptQuitterClick(Sender: TObject);
BEGIN
  Close;
END;

PROCEDURE TFrm_Main.SaveParams;
BEGIN
  // Infos FTP
  MyIniFile.WriteString('FTP', 'URL', Chp_FTP_URL.Text);
  MyIniFile.WriteString('FTP', 'USER', Chp_FTP_User.Text);
  MyIniFile.WriteString('FTP', 'PWD', Chp_FTP_PWD.Text);
  MyIniFile.WriteBool('FTP', 'VERIF_SENT_FILES', Chp_FTPValidEnvoi.Checked);
  MyIniFile.WriteString('FTP', 'NB_TRY', Chp_FTPNbTry.Text);



  // Infos pour envoi de mails
  MyIniFile.WriteString('EMAIL', 'SMTP', Chp_EMAIL_SMTP.Text);
  MyIniFile.WriteString('EMAIL', 'USER', Chp_EMAIL_User.Text);
  MyIniFile.WriteString('EMAIL', 'PWD', Chp_EMAIL_PWD.Text);
  MyIniFile.WriteString('EMAIL', 'DEST', Chp_EMAIL_DEST.Text);
  MyIniFile.WriteString('EMAIL', 'EXPE', Chp_EMAIL_EXP.Text);


  // Infos de connection à la BDD
  MyIniFile.WriteString('DATABASE', 'PATH', Chp_DBPath.Text);

  MyIniFile.WriteString('NOMMAGS', 'MAG', MemD_DBParamsMAGNOM.AsString);
  MyIniFile.WriteInteger('NOMMAGS', 'MAGID', MemD_DBParamsMAGID.AsInteger);

  MyIniFile.WriteString('NOMPOSTE', 'POSTE', MemD_DBParamsPOSNOM.AsString);
  MyIniFile.WriteInteger('NOMPOSTE', 'POSID', MemD_DBParamsPOSID.AsInteger);

  MyIniFile.WriteString('NOMSECTEUR', 'SECTEUR', MemD_DBParamsSECNOM.AsString);
  MyIniFile.WriteInteger('NOMSECTEUR', 'SECID', MemD_DBParamsSECID.AsInteger);



  MyIniFile.WriteString('ARTICLES', 'FILE_DCS', Chp_FileDCS.Text);
  MyIniFile.WriteString('ARTICLES', 'FILE_GENRE', Chp_FileGenre.Text);
  MyIniFile.WriteString('ARTICLES', 'FILE_ARTICLE', Chp_FileArt.Text);
  MyIniFile.WriteString('ARTICLES', 'SENDPATH', Chp_ArtFTPFolder.Text);

  MyIniFile.WriteString('STOCK', 'FILE_STOCK', Chp_FileStk.Text);
  MyIniFile.WriteString('STOCK', 'SENDPATH', Chp_StockFTPFolder.Text);

  MyIniFile.WriteBool('OPTIONS', 'DELOLDLOG', Chp_DelOldLog.Checked);
  MyIniFile.WriteString('OPTIONS', 'DELOLDLOGAGE', Chp_DelOldLogAge.Text);


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
  InitParams();

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

FUNCTION TFrm_Main.GetFTPFolder(sAFile: STRING): STRING;
BEGIN
  IF (UpperCase(sAFile) = UpperCase(Chp_FileStk.Text)) THEN
  BEGIN
    // Stock
    Result := Chp_StockFTPFolder.Text;
  END
  ELSE IF (UpperCase(sAFile) = UpperCase(Chp_FileDCS.Text))
    OR (UpperCase(sAFile) = UpperCase(Chp_FileArt.Text))
    OR (UpperCase(sAFile) = UpperCase(Chp_FileGenre.Text)) THEN
  BEGIN
    // Articles
    Result := Chp_ArtFTPFolder.Text;
  END
  ELSE BEGIN
    // Erreur
    Result := '';
  END;
END;

PROCEDURE TFrm_Main.Nbt_ExportArticleClick(Sender: TObject);
BEGIN
  TraiteArticles();
  //  GetFTPFolder('STOCK.TXT');
END;

PROCEDURE TFrm_Main.Chp_FileChange(Sender: TObject);
BEGIN
  IF Sender.ClassType = TwwDBEditRv THEN
    TwwDBEditRv(Sender).Text := UpperCase(TwwDBEditRv(Sender).Text);
END;

PROCEDURE TFrm_Main.FTPFolderProcess;
VAR
  MyFile: TSearchRec;
  iRes: integer;
BEGIN
  iRes := FindFirst(sToSendFolder + '*.*', faAnyFile, MyFile);
  WHILE iRes = 0 DO
  BEGIN
    IF ((MyFile.Name <> '.') AND (MyFile.Name <> '..')) THEN
    BEGIN
      // Traitement du fichier
      IF GetFTPFolder(ExtractFileName(MyFile.Name)) <> '' THEN
      BEGIN
        FileProcess(ExtractFileName(MyFile.Name));
      END
      ELSE BEGIN
        LogAction('');
        LogAction('/***************************************************/');
        LogAction('INFO - Fichier non traité : ' + ExtractFileName(MyFile.Name));
        LogAction('/***************************************************/');
      END;
    END;
    iRes := FindNext(MyFile);
  END;
  FindClose(MyFile);
END;

PROCEDURE TFrm_Main.Nbt_ForceFTPSendClick(Sender: TObject);
BEGIN
  FTPFolderProcess();
END;

FUNCTION TFrm_Main.QueryGetEntete(AQuery: TIB_Query): STRING;
VAR
  i: integer;
  sRet: STRING;
BEGIN
  sRet := '';

  FOR i := 0 TO AQuery.FieldCount - 1 DO
  BEGIN
    IF i = 0 THEN
      sRet := AQuery.Fields[i].FieldName
    ELSE
      sRet := sRet + ';' + AQuery.Fields[i].FieldName;
  END;

  Result := sRet;
END;

FUNCTION TFrm_Main.QueryVersFile(AQuery: TIB_Query;
  AFileName: STRING): boolean;
VAR
  tsExport: TStrings;
  i, j: integer;
  sLig: STRING;
  sTmp: STRING;
  sChp: STRING;
BEGIN
  tsExport := TStringList.Create();
  TRY
    // Créer l'entete
    tsExport.Add(QueryGetEntete(AQuery));
    j := 0;
    WHILE NOT AQuery.Eof DO
    BEGIN
      // Affichage
      inc(j);
      Lab_Status.Caption := 'Traitement du fichier ' + AFileName + ' ligne ' + IntToStr(j) + '/' + IntToStr(AQuery.RecordCount);
      Lab_Status.Update;
      // Extraction
      sLig := '';
      FOR i := 0 TO AQuery.FieldCount - 1 DO
      BEGIN
        IF AQuery.Fields[i].FieldName = 'STC_QTE' THEN
        BEGIN
          sChp := StringReplace(FloatToStrF(AQuery.Fields[i].AsFloat, ffFixed, 9, 2), ',', '.', [rfReplaceAll]);
        END
        ELSE BEGIN
          sChp := AQuery.Fields[i].AsString;
        END;


        IF i = 0 THEN
          sLig := sChp
        ELSE
          sLig := sLig + ';' + sChp;
      END;
      tsExport.Add(sLig);

      AQuery.Next;
    END;
    tsExport.SaveToFile(sToSendFolder + AFileName);

    tsExport.Clear;

    LogAction('OK - Export du fichier ' + AFileName + ' terminé');

    result := true;
  EXCEPT
    ON E: Exception DO
    BEGIN
      LogAction('ERREUR - Export du fichier ' + AFileName + ' echoué : ' + E.Message);
      result := false;
    END;
  END;
  // Libération
  tsExport.Free;

END;

PROCEDURE TFrm_Main.Nbt_ExportArticleFTPClick(Sender: TObject);
BEGIN
  TraiteArticles();

  FTPFolderProcess();
END;

PROCEDURE TFrm_Main.Nbt_ExportStockClick(Sender: TObject);
BEGIN
  TraiteStock();
END;

PROCEDURE TFrm_Main.Nbt_ExportStockFTPClick(Sender: TObject);
BEGIN
  TraiteStock();

  FTPFolderProcess();
END;

PROCEDURE TFrm_Main.LMDSpeedButton2Click(Sender: TObject);
BEGIN
  Close;
END;

PROCEDURE TFrm_Main.Chp_NomPosteBtnBeforeAction(sender: TObject;
  VAR Allow: Boolean);
BEGIN
  Que_Postes.Close;
  Que_Postes.ParamByName('MAGNOM').AsString := Chp_NomMag.Text;
END;

FUNCTION TFrm_Main.SendMail: Boolean;

BEGIN

  IF MyParams.sSMTPHost = '' THEN
  begin
    LogAction('Pas de SMTP renseigné, impossible d''envoyer un E-Mail');
    EXIT;
  END;

  IF MyParams.sMailDest = '' THEN
  begin
    LogAction('Pas de destinataire renseigné, impossible d''envoyer un E-Mail');
    EXIT;
  END;

  IF MyParams.sMailExp = '' THEN
  begin
    LogAction('Pas d''expéditeur renseigné, impossible d''envoyer un E-Mail');
    EXIT;
  END;

  SMTP.Host := MyParams.sSMTPHost;
  SMTP.Port := 25; // <- à prendre dans les paramètres

  IF MyParams.sSMTPUser <> '' THEN
  BEGIN
    SMTP.AuthenticationType := atLogin; // <- à rendre paramétrable
    SMTP.Username := MyParams.sSMTPUser;
    SMTP.Password := MyParams.sSMTPPwd; // <- à rendre paramétrable
  END
  ELSE BEGIN
    SMTP.AuthenticationType := atNone;
  END;

  idMsgSend.Clear;
  idMsgSend.Body.Clear;
  idMsgSend.From.Text := MyParams.sMailExp;
  //  idMsgSend.CCList.EMailAddresses := ; // Systématiquement une copie à l'adresse mail originale

  idMsgSend.Recipients.EMailAddresses := MyParams.sMailDest;
  idMsgSend.Subject := 'Erreur de l''outil d''extraction vers le WEB';
  idMsgSend.Body.Text := 'Une erreur est survenue lors de l''exécution du service, voir le log joint.';

  TIDAttachment.create(idMsgSend.MessageParts, GetLogFile);

  TRY
    SMTP.Connect();
  EXCEPT
    LogAction('Erreur de connection au serveur de messagerie');
    result := false;
    EXIT;
  END;

  // === Tout est OK ===
  TRY
    SMTP.Send(idMsgSend);
    LogAction('Message envoyé à : ' + idMsgSend.Recipients.EMailAddresses);
  EXCEPT
    // === Ne devrait normalement pas se produire ===
    LogAction('Erreur SendMail');
    result := false;
    EXIT;
  END;

  SMTP.Disconnect();
  Result := True;

END;

procedure TFrm_Main.SendLog;
begin
  IF bModeAuto THEN
  BEGIN
    SendMail();
  END;
end;

procedure TFrm_Main.Nbt_SendLogClick(Sender: TObject);
begin
  SendMail();
end;

END.

