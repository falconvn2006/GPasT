UNIT UCommon_Dm;

INTERFACE

USES
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  // deb uses perso
  idFtpCommon,
  XMLCursor,
  StdXML_TLB,
  IdGlobalProtocols,
  IdAttachmentFile,
  NetEvenWS,
  // fin uses perso
  Dialogs,
  DB,
  IB_Components,
  ActionRv,
  IdMessage,
  IdMessageClient,
  IdSMTPBase,
  IdSMTP,
  rxStrHlder,
  IdBaseComponent,
  IdComponent,
  IdTCPConnection,
  IdTCPClient,
  IdExplicitTLSClientServerBase,
  IdFTP,
  IBODataset,
  uGeneriqueType, xmldom, XMLIntf, msxmldom, XMLDoc,
  uCommon_Type;



TYPE
  TDm_Common = CLASS(TDataModule)
    Que_SelKTB: TIBOQuery;
    Ginkoia: TIB_Connection;
    IbT_Select: TIB_Transaction;
    FTP: TIdFTP;
    Str_FTPList: TStrHolder;
    SMTP: TIdSMTP;
    idMsgSend: TIdMessage;
    Grd_CloseAll: TGroupDataRv;
    IbT_Modif: TIB_Transaction;
    Que_GetParam: TIBOQuery;
    IbC_K: TIB_Cursor;
    Que_Client: TIBOQuery;
    Que_Commande: TIBOQuery;
    Que_CommandeL: TIBOQuery;
    Que_SelGenImportStr: TIBOQuery;
    Que_SelGenImportStrIMP_GINKOIA: TIntegerField;
    Que_SelGenImportStrIMP_ID: TIntegerField;
    Que_SelGenImport: TIBOQuery;
    Que_SelGenImportIMP_GINKOIA: TIntegerField;
    Que_SelGenImportIMP_ID: TIntegerField;
    Que_GetGenImportID: TIBOQuery;
    Que_GetSitesParam: TIBOQuery;
    Que_GetSites: TIBOQuery;
    Que_GetSitesASS_ID: TIntegerField;
    Que_GetSitesASS_NOM: TStringField;
    Que_GetSitesASS_CODE: TIntegerField;
    Que_GetSitesASS_INFO: TMemoField;
    Que_GetSitesASS_AMAJ: TIntegerField;
    Que_GetSitesASS_USRID: TIntegerField;
    Que_GetSitesASS_NPJID: TIntegerField;
    Que_GetSitesASS_POSID: TIntegerField;
    Que_GetSitesParamASF_ID: TIntegerField;
    Que_GetSitesParamASF_ASSID: TIntegerField;
    Que_GetSitesParamASF_DOSSIERLOCAL: TStringField;
    Que_GetSitesParamASF_DOSSIERFTP: TStringField;
    Que_GetSitesParamASF_EXTENSION: TStringField;
    Que_GetSitesParamASF_FTPHOST: TMemoField;
    Que_GetSitesParamASF_FTPUSER: TStringField;
    Que_GetSitesParamASF_FTPPWD: TStringField;
    Que_GetSitesParamASF_FTPPORT: TIntegerField;
    Que_GetSitesParamASF_CTRLENVOI: TIntegerField;
    Que_GetSitesParamASF_NBESSAI: TIntegerField;
    Que_GetSitesParamASF_SMTPHOST: TMemoField;
    Que_GetSitesParamASF_SMTPUSER: TStringField;
    Que_GetSitesParamASF_SMTPPWD: TStringField;
    Que_GetSitesParamASF_SMTPPORT: TIntegerField;
    Que_GetSitesParamASF_SMTPEXP: TMemoField;
    Que_GetSitesParamASF_SMTPDEST: TMemoField;
    Que_GetSitesParamASF_URLMAJ: TMemoField;
    Que_GetPays: TIBOQuery;
    QryGet: TIB_Cursor;
    Que_GetSitesParamASF_DOGET: TIntegerField;
    Que_GetSitesParamASF_TYPEGET: TStringField;
    Que_GetSitesParamASF_URLGET: TStringField;
    Que_GetSitesParamASF_LOGINGET: TStringField;
    Que_GetSitesParamASF_PASSWRDGET: TStringField;
    Que_GetSitesParamASF_FTPDELFILEGET: TIntegerField;
    Que_GetSitesParamASF_FTPFOLDERGET: TStringField;
    Que_GetSitesParamASF_LOCALFOLDERGET: TStringField;
    Que_GetSitesParamASF_DOSEND: TIntegerField;
    Que_GetSitesParamASF_TYPESEND: TStringField;
    Que_GetSitesParamASF_URLSEND: TStringField;
    Que_GetSitesParamASF_LOGINSEND: TStringField;
    Que_GetSitesParamASF_PASSWRDSEND: TStringField;
    Que_GetSitesParamASF_FTPFOLDERSEND: TStringField;
    Que_GetSitesParamASF_LASTTIME: TDateTimeField;
    Que_GetSitesParamASF_LOCALFOLDERSEND: TStringField;
    Que_UpdateLastTime: TIBOQuery;
    IntegerField1: TIntegerField;
    IntegerField2: TIntegerField;
    StringField1: TStringField;
    StringField2: TStringField;
    StringField3: TStringField;
    MemoField1: TMemoField;
    StringField4: TStringField;
    StringField5: TStringField;
    IntegerField3: TIntegerField;
    IntegerField4: TIntegerField;
    IntegerField5: TIntegerField;
    MemoField2: TMemoField;
    StringField6: TStringField;
    StringField7: TStringField;
    IntegerField6: TIntegerField;
    MemoField3: TMemoField;
    MemoField4: TMemoField;
    MemoField5: TMemoField;
    IntegerField7: TIntegerField;
    StringField8: TStringField;
    StringField9: TStringField;
    StringField10: TStringField;
    StringField11: TStringField;
    IntegerField8: TIntegerField;
    StringField12: TStringField;
    StringField13: TStringField;
    IntegerField9: TIntegerField;
    StringField14: TStringField;
    StringField15: TStringField;
    StringField16: TStringField;
    StringField17: TStringField;
    StringField18: TStringField;
    DateTimeField1: TDateTimeField;
    StringField19: TStringField;
    Que_GetArtInfos: TIBOQuery;
    IbC_GetTvaFP: TIB_Cursor;
    Que_CdeExists: TIBOQuery;
    Que_Tmp: TIBOQuery;
    MyDoc: TXMLDocument;

    PROCEDURE FTPConnected(Sender: TObject);
    PROCEDURE FTPDisconnected(Sender: TObject);
    PROCEDURE FTPAfterClientLogin(Sender: TObject);
    PROCEDURE DataModuleCreate(Sender: TObject);

  PRIVATE

    iNbErreurFTP: integer;
    iNbErreurNetEven: Integer; // TODO : voir solution + tard pour en faire 1 par Site

    // Outils

    // Formatage d'adresse
    FUNCTION Adr123VersAdr(Adr1, Adr2, Adr3: STRING): STRING;

    // récupère un ID avec un libellé, en paramètre : nom de la table, nom de la colone contenant l'id, et de celle contenant le libellé, et la valeur recherchée
    FUNCTION GetIdByLib(sNomTbl, sColId, sColLib, sNomRecherche: STRING; sAddSQL: STRING = ''): integer;

    // GENPARAM
    FUNCTION GetParam(iCode: integer; VAR PrmInteger, PrmMag, PrmPos: integer; VAR PrmFloat: double; VAR PrmString: STRING): boolean; // récupère les infos dans genparam a partri d'un code pour le prm_type=9

    // Gestion des K et KTB
    FUNCTION Ktb(ATable: STRING): integer; // Récupère le KTB à partir du nom
    FUNCTION NewK(ATblName: STRING): integer; // Créé un nouveau K et renvoie l'id
    FUNCTION NewGenImport(ATblName: STRING; IDRef: integer): integer; // Créé un nouveau K et un nouveau GenIMP et renvoie l'id du K
    PROCEDURE UpdateK(AKId: integer; Enabled: integer = 1); // Maj du K (dates et Enabled au besoin)

    // Conversion
    FUNCTION ISOStrToDate(S: STRING): TDateTime; // Transforme une date ISO en DateTime

    { Déclarations privées }
  PUBLIC

    MySiteParams: stParam; // Contient les infos pour chaque site
    MyIniParams: stIniParam; // Contient les paramètres lus dans l'ini

    // Outils
    // Récupération d'id à partir du libellé
    FUNCTION GetOrCreatePayID(sPayNom: STRING): integer;

    FUNCTION GenImportGetId(AId: integer; AKtb: integer): integer; OVERLOAD; // récupère l'id ginkoia à partir d'un id
    FUNCTION GenImportGetId(AId: STRING; AKtb: integer): integer; OVERLOAD; // récupère l'id ginkoia à partir d'un id

    FUNCTION GetParamInteger(ACode: integer): integer; // récupération dabs genparam en fct du type
    FUNCTION GetParamMag(ACode: integer): integer; // récupération dabs genparam en fct du type
    FUNCTION GetParamPos(ACode: integer): integer; // récupération dabs genparam en fct du type
    FUNCTION GetParamString(ACode: integer): STRING;
    FUNCTION GetParamFloat(ACode: integer): double;

    FUNCTION DBReconnect: boolean; // Connection aux DB
    PROCEDURE DBDisconnect; // Connection aux DB
    FUNCTION LitParams(bVerifParams: boolean): Boolean;
    FUNCTION ParamValides(): boolean;

    // Traitement des fichiers
    PROCEDURE DoGet(dDebut,dFin : TTime);
    PROCEDURE DoSend(dDebut,dFin : TTime);

    PROCEDURE NetEvenGet(dtForceJourDeb : TDateTime = 0; dtForceJourFin: TDateTime = 0);
    PROCEDURE NetEven_CreeEntete(ACdeLine: MarketPlaceOrder; AtabMontant: tbMontant; AFraisPort: Double);
    PROCEDURE NetEven_CreeLigne(ACdeLine: MarketPlaceOrder; AArtInfos: stArticleInfos; ALotInfos: stLotInfos);

    FUNCTION GetArticleInfos(sCodeBar: STRING): stArticleInfos;
    PROCEDURE CumulMontant(VAR tabMontant: tbMontant; fTva, fMtTva, fMtTTC: Double);
    PROCEDURE SKUVersLot(VAR ALot: stLotInfos; ASKU: STRING; APrice: double);
    FUNCTION CdeExists(AIdCde: integer): Boolean;

    PROCEDURE TestConnexions;
    // FTP
    FUNCTION FTPConnect(bGet: boolean): Boolean;
    PROCEDURE FTPDisconnect();

    FUNCTION FTPFileExists(CONST ADirectory, AFile: STRING): Boolean;

    FUNCTION FTPGetList(): boolean;
    FUNCTION FTPGetAFile(AFileName, APathFileToGet: STRING; AExpectedSize: integer): boolean;

    PROCEDURE FTPFolderProcess();
    PROCEDURE FTPFileSend(sFile: STRING);
    FUNCTION FTPPutFile(sFileSend: STRING): boolean;
    FUNCTION FTPTestTransfert(sFileSend, sFileReceive: STRING): boolean;

    // Mails
    FUNCTION SendMail: boolean;
    PROCEDURE SendLog(bModeAuto: boolean);

    { Déclarations publiques }
  END;

VAR
  Dm_Common: TDm_Common;

CONST
  RC = #13#10;

IMPLEMENTATION

USES UCommon,
  MD5Api,
  idGlobal,
  DateUtils,
  uGenerique;

{$R *.DFM}

FUNCTION TDm_Common.ParamValides: boolean;
BEGIN
  // TODO : Voir les params vitaux
  TRY
    WITH MySiteParams DO
    BEGIN
      Result := (iPseudoLivr <> 0);
      Result := Result AND (iTarif <> 0);
      Result := Result AND (iProjet <> 0);
      Result := Result AND (iProjet <> 0);
      Result := Result AND (iMagID <> 0);
      Result := Result AND (iVendeur <> 0);
      Result := Result AND (iTypeCDV <> 0);
      Result := Result AND (iAssID <> 0);
      Result := Result AND (iAsfID <> 0);
    END;
  EXCEPT
    Result := False;
  END;
END;

PROCEDURE TDm_Common.DataModuleCreate(Sender: TObject);
BEGIN
  iNbErreurFTP := 0;
  iNbErreurNetEven := 0;
END;

PROCEDURE TDm_Common.DBDisconnect;
BEGIN
  // Déconnection de la DB
  Grd_CloseAll.Close;
  Ginkoia.Disconnect;
  Ginkoia.Close;
END;

FUNCTION TDm_Common.DBReconnect: boolean;
BEGIN
  // Déconnection de la DB
  Ginkoia.Disconnect;

  Ginkoia.Database := MyIniParams.sDBPath;
  TRY
    Ginkoia.Connect;

    IF Ginkoia.Connected THEN
    BEGIN
      Result := True;
    END
    ELSE BEGIN
      // Erreur, a gerer
      Result := False;
      LogAction('Erreur de connection à la base de donnée' + MyIniParams.sDBPath, 0);
    END;
  EXCEPT
    Result := False;
    Ginkoia.Disconnect;
    LogAction('Erreur de connection à la base de donnée' + MyIniParams.sDBPath, 0);
  END;
END;

PROCEDURE TDm_Common.DoGet(dDebut,dFin : TTime);
BEGIN
  // 1 : Vérifier la méthode à utiliser
  IF MySiteParams.sTypeGet = 'NETEVEN' THEN
  BEGIN
    NetEvenGet();
  END
  ELSE IF MySiteParams.sTypeGet = 'ATIPIC' THEN
  BEGIN
    // Rien pour l'instant
  END
  ELSE IF MySiteParams.sTypeGet = 'CLEONET' THEN
  BEGIN
    // Rien pour l'instant
  END
  ELSE if MySiteParams.sTypeGet = 'GENERIQUE' then
  begin
    DoGenGet(dDebut,dFin);
  END;

  // 2 : Effectuer le transfert vers la structure

  // NetEven

  // 3 : Effectuer la création
END;

PROCEDURE TDm_Common.DoSend(dDebut,dFin : TTime);
BEGIN
  IF MySiteParams.sTypeSend = 'NETEVEN' THEN
  BEGIN

  END
  ELSE IF MySiteParams.sTypeSend = 'ATIPIC' THEN
  BEGIN
    // Phase 2 : Envoi de ce qu'il y'a à envoyer
    FTPFolderProcess();
  END
  ELSE IF MySiteParams.sTypeSend = 'CLEONET' THEN
  BEGIN

  END
  ELSE IF MySiteParams.sTypeSend = 'GENERIQUE' THEN
  BEGIN
    DoGenSend(dDebut,dFin);
  END 
  ELSE BEGIN

  END;

END;

FUNCTION TDm_Common.ISOStrToDate(S: STRING): TDateTime;
VAR
  cSaveDateSep: Char;
  sSaveFormat: STRING;
BEGIN
  cSaveDateSep := DateSeparator;
  sSaveFormat := ShortDateFormat;
  TRY
    TRY
      DateSeparator := '-';
      ShortDateFormat := 'YYYY-MM-DD';
      IF S = '' THEN
        Result := 0
      ELSE
        Result := StrToDateTime(S);
    EXCEPT
      ON E: Exception DO
      BEGIN
        Result := 0;
      END;
    END;
  FINALLY
    ShortDateFormat := sSaveFormat;
    DateSeparator := cSaveDateSep;
  END;
END;

FUNCTION TDm_Common.Ktb(ATable: STRING): integer;
VAR
  i: integer;
BEGIN
  // Récupère le KTBid a partir d'un nom de table
  Que_SelKTB.Close;
  TRY
    Que_SelKTB.ParamByName('NOMTBL').AsString := ATable;
    Que_SelKTB.Open;
    i := Que_SelKTB.FieldByName('KTB_ID').AsInteger;
  EXCEPT
    ON E: Exception DO
    BEGIN
      i := 0;
    END;
  END;
  Que_SelKTB.Close;
  Result := i;
END;

FUNCTION TDm_Common.LitParams(bVerifParams: boolean): boolean;
VAR
  sPrm: STRING;
BEGIN
  WITH MySiteParams DO
  BEGIN

    iPseudoLivr := 0;
    iTarif := 0;
    iMagID := 0;
    iProjet := 0;
    iVendeur := 0;
    iTypeCDV := 0;

    Result := False;

    IF NOT Que_GetSites.Active THEN
      Exit;

    // Récupération des paramètres de la base
    iPseudoLivr := GetParamInteger(200);
    iTarif := GetParamInteger(201);
    iMagID := GetParamMag(203);

    iProjet := Que_GetSitesASS_NPJID.AsInteger;
    IF iProjet = 0 THEN
      iProjet := GetParamInteger(202);

    iVendeur := Que_GetSitesASS_USRID.AsInteger;
    IF iVendeur = 0 THEN
      iVendeur := GetParamInteger(204);

    iTypeCDV := GetParamInteger(205);

    iAssId := Que_GetSitesASS_ID.AsInteger;
    iCodeSite := Que_GetSitesASS_CODE.AsInteger;
    sNomSite := Que_GetSitesASS_NOM.AsString;

    // Lecture des paramètres du site
    Que_GetSitesParam.Close;
    Que_GetSitesParam.ParamByName('ASSID').AsInteger := Que_GetSitesASS_ID.AsInteger;
    Que_GetSitesParam.Open;

    iAsfId := Que_GetSitesParamASF_ID.AsInteger;
    IF Que_GetSitesParamASF_ID.AsInteger <> 0 THEN
    BEGIN

      // ************** 1 - Envoi ************
      bSend := (Que_GetSitesParamASF_DOSEND.AsInteger = 1);

      // Type d'envoi
      sTypeSend := Que_GetSitesParamASF_TYPESEND.AsString;

      // Récup du chemin d'accès aux factures à envoyer
      sPrm := Que_GetSitesParamASF_LOCALFOLDERSEND.AsString; // Remplace GetParamString(302);
      IF sPrm = '' THEN
        sPrm := Que_GetSitesParamASF_DOSSIERLOCAL.AsString; // Ancien param

      IF sPrm <> '' THEN
      BEGIN
        sToSendFolder := IncludeTrailingPathDelimiter(sPrm);
        sLocalFolderSend := IncludeTrailingPathDelimiter(sPrm);
        ForceDirectories(sToSendFolder);

        sSentFolder := IncludeTrailingPathDelimiter(sToSendFolder + 'OK');
        ForceDirectories(sSentFolder);
      END;

      // Infos FTP
      sURLSend := Que_GetSitesParamASF_URLSEND.AsString;
      sFTPHost := Que_GetSitesParamASF_URLSEND.AsString;
      IF sFTPHost = '' THEN
        sFTPHost := Que_GetSitesParamASF_FTPHOST.AsString;

      sLoginSend := Que_GetSitesParamASF_LOGINSEND.AsString;
      sFTPUser := Que_GetSitesParamASF_LOGINSEND.AsString;
      IF sFTPUser = '' THEN
        sFTPUser := Que_GetSitesParamASF_FTPUSER.AsString;

      sPassSend := Que_GetSitesParamASF_PASSWRDSEND.AsString;
      sFTPPwd := Que_GetSitesParamASF_PASSWRDSEND.AsString;
      IF sFTPPwd = '' THEN
        sFTPPwd := Que_GetSitesParamASF_FTPPWD.AsString;

      sFTPPort := IntToStr(Que_GetSitesParamASF_FTPPORT.AsInteger);

      iFTPNbTry := Que_GetSitesParamASF_NBESSAI.AsInteger;

      // Infos Envoi FTP
      bFTPValidEnvoi := (Que_GetSitesParamASF_CTRLENVOI.AsInteger = 1);

      sFTPSendFolder := Que_GetSitesParamASF_FTPFOLDERSEND.AsString;
      IF sFTPSendFolder = '' THEN
        sFTPSendFolder := Que_GetSitesParamASF_DOSSIERFTP.AsString;

      sFTPSendExtention := Que_GetSitesParamASF_EXTENSION.AsString;

      bDelFTPFiles := (Que_GetSitesParamASF_FTPDELFILEGET.AsInteger = 1);

      // **************** Réception ****************
      bGet := (Que_GetSitesParamASF_DOGET.AsInteger = 1);

      // Type de récupération
      sTypeGet := Que_GetSitesParamASF_TYPEGET.AsString;

      // Infos Get FTP
      sURLGet := Que_GetSitesParamASF_URLMAJ.AsString;
      sLoginGet := Que_GetSitesParamASF_LOGINGET.AsString;
      sPassGet := Que_GetSitesParamASF_PASSWRDGET.AsString;

      // Création des dossiers d'envoi/reception FTP locaux
      sGetFolder := IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'Received');
      ForceDirectories(sGetFolder);

      // ********* Communs ************
      // Infos pour envoi de mails
      sSMTPHost := Que_GetSitesParamASF_SMTPHOST.AsString;

      sSMTPPort := IntToStr(Que_GetSitesParamASF_SMTPPORT.AsInteger);

      sSMTPUser := Que_GetSitesParamASF_SMTPUSER.AsString;

      sSMTPPwd := Que_GetSitesParamASF_SMTPPWD.AsString;

      sMailDest := Que_GetSitesParamASF_SMTPDEST.AsString;

      sMailExp := Que_GetSitesParamASF_SMTPEXP.AsString;

      // Dernier traitement
      dtLastTime := Que_GetSitesParamASF_LASTTIME.AsDateTime - (2 / 24);
      dtCurrentTime := Now;

      //  TODO     FTPGetFolder := Que_GetSitesParamASF_DOSSIERFTP.AsString;


      sLocalFolderGet := IncludeTrailingPathDelimiter(Que_GetSitesParamASF_LOCALFOLDERGET.AsString);
      IF sLocalFolderGet <> '' THEN
        ForceDirectories(sLocalFolderGet);

      // Pas encore gérés
      //  ASF_URLMAJ,
      //  ASF_FTPFOLDERGET,
      //  ,
      With FTPGenGet do
      begin
        Host         := Que_GetSitesParam.FieldByName('ASF_URLGET').AsString;
        User         := Que_GetSitesParam.FieldByName('ASF_LOGINGET').AsString;
        Psw          := Que_GetSitesParam.FieldByName('ASF_PASSWRDGET').AsString;
        Port         := 21;
        FTPDirectory := Que_GetSitesParam.FieldByName('ASF_FTPFOLDERGET').AsString;
        bDeleteFile  := (Que_GetSitesParam.FieldByName('ASF_FTPDELFILEGET').AsInteger = 1);
      end;

      With FTPGenFacture do
      begin
        Host         := Que_GetSitesParam.FieldByName('ASF_URLSEND').AsString;
        User         := Que_GetSitesParam.FieldByName('ASF_LOGINSEND').AsString;
        Psw          := Que_GetSitesParam.FieldByName('ASF_PASSWRDSEND').AsString;
        Port         := 21;
        FTPDirectory := Que_GetSitesParam.FieldByName('ASF_FTPFOLDERSEND').AsString;
      end;

      With FTPGenCSV do
      begin
        Host         := Que_GetSitesParam.FieldByName('ASF_FTPHOST').AsString;
        User         := Que_GetSitesParam.FieldByName('ASF_FTPUSER').AsString;
        Psw          := Que_GetSitesParam.FieldByName('ASF_FTPPWD').AsString;
        Port         := Que_GetSitesParam.FieldByName('ASF_FTPPORT').AsInteger;
        FTPDirectory := Que_GetSitesParam.FieldByName('ASF_DOSSIERFTP').AsString;
      end;

      Que_GetSitesParam.Close;

    END;
  END;

  IF bVerifParams THEN
  BEGIN
    Result := ParamValides;
  END
  ELSE BEGIN
    Result := True;
  END;

  IF NOT Result THEN
    LogAction('Erreur de paramétrage, impossible de compléter le chargement', 0);
END;

PROCEDURE TDm_Common.SKUVersLot(VAR ALot: stLotInfos; ASKU: STRING; APrice: double);
VAR
  iPos: Integer;
  sCBArt: STRING;
  sTmpSKU: STRING;
BEGIN
  // 1 : On vide le tableau, et init les variables
  SetLength(ALot.tabArticles, 0);
  sTmpSKU := ASKU;
  ALot.fPxBrut := 0;
  ALot.fPxNet := 0;

  // 2 on cherche le premier *
  REPEAT
    iPos := Pos('*', sTmpSKU);

    IF iPos > 0 THEN
    BEGIN
      sCBArt := Copy(sTmpSKU, 1, iPos - 1);
      sTmpSKU := Copy(sTmpSKU, iPos + 1, Length(sTmpSKU) - iPos);

      // Ajoute une ligne dans le tableau
      SetLength(ALot.tabArticles, Length(ALot.tabArticles) + 1);
      ALot.tabArticles[High(ALot.tabArticles)] := GetArticleInfos(sCBArt);
      ALot.fPxBrut := ALot.fPxBrut + ALot.tabArticles[High(ALot.tabArticles)].fPxBrut;
    END;
  UNTIL iPos = 0;

  // le TmpSKU contient le lot id en sortie de boucle.
  ALot.iLotId := StrToInt(sTmpSKU);
  ALot.fPxNet := APrice;
  IF ALot.fPxBrut = 0 THEN
    ALot.fPxBrut := APrice;

  ALot.fRemise := (ALot.fPxBrut - ALot.fPxNet) / ALot.fPxBrut
END;

PROCEDURE TDm_Common.TestConnexions;
VAR
  wsNetEven: TGestionNetEven;
  sTestConnect: STRING;
BEGIN
  IF MySiteParams.bGet THEN
  BEGIN
    IF MySiteParams.sTypeGet = 'NETEVEN' THEN
    BEGIN
      wsNetEven := CreerNWSServer(MySiteParams.sURLGet, MySiteParams.sLoginGet, MySiteParams.sPassGet, MySiteParams.sLocalFolderGet); //'laurent@ekosport.fr', '2fsarl73');
      TRY
        sTestConnect := wsNetEven.TestConnection;
      EXCEPT
        sTestConnect := 'Echec';
      END;
      CloseNWSServer(wsNetEven);
      LogAction(MySiteParams.sNomSite + ' (Réception) : ' + sTestConnect, 2);
    END
    ELSE IF MySiteParams.sTypeGet = 'ATIPIC' THEN
    BEGIN
      IF FTPConnect(True) THEN
      BEGIN
        // Connection réussie
        LogAction(MySiteParams.sNomSite + ' (Réception) : Connection réussie', 2);
      END
      ELSE BEGIN
        // Connection échouée
        LogAction(MySiteParams.sNomSite + ' (Réception) : Connection échouée', 2)
      END;
      Sleep(100);
      FTPDisconnect();
    END
    ELSE IF MySiteParams.sTypeGet = 'CLEONET' THEN
    BEGIN
      IF FTPConnect(True) THEN
      BEGIN
        // Connection réussie
        LogAction(MySiteParams.sNomSite + ' (Réception) : Connection réussie', 2);
      END
      ELSE BEGIN
        // Connection échouée
        LogAction(MySiteParams.sNomSite + ' (Réception) : Connection échouée', 2)
      END;
      Sleep(100);
      FTPDisconnect();
    END;
  END;

  IF MySiteParams.bSend THEN
  BEGIN
    IF MySiteParams.sTypeSend = 'NETEVEN' THEN
    BEGIN
      wsNetEven := CreerNWSServer(MySiteParams.sURLSend, MySiteParams.sLoginSend, MySiteParams.sPassSend, MySiteParams.sLocalFolderSend); //'laurent@ekosport.fr', '2fsarl73');
      TRY
        sTestConnect := wsNetEven.TestConnection;
      EXCEPT
        sTestConnect := 'Echec';
      END;
      CloseNWSServer(wsNetEven);
      LogAction(MySiteParams.sNomSite + ' (Envoi) : ' + sTestConnect, 2);
    END
    ELSE IF MySiteParams.sTypeSend = 'ATIPIC' THEN
    BEGIN
      IF FTPConnect(False) THEN
      BEGIN
        // Connection réussie
        LogAction(MySiteParams.sNomSite + ' (Envoi) : Connection réussie', 2);
      END
      ELSE BEGIN
        // Connection échouée
        LogAction(MySiteParams.sNomSite + ' (Envoi) : Connection échouée', 2)
      END;
      Sleep(100);
      FTPDisconnect();
    END
    ELSE IF MySiteParams.sTypeSend = 'CLEONET' THEN
    BEGIN
      IF FTPConnect(False) THEN
      BEGIN
        // Connection réussie
        LogAction(MySiteParams.sNomSite + ' (Envoi) : Connection réussie', 2);
      END
      ELSE BEGIN
        // Connection échouée
        LogAction(MySiteParams.sNomSite + ' (Envoi) : Connection échouée', 2)
      END;
      Sleep(100);
      FTPDisconnect();
    END;
  END;

END;

PROCEDURE TDm_Common.FTPAfterClientLogin(Sender: TObject);
BEGIN
  LogAction('OK - Serveur : ' + MySiteParams.sFTPHost + ' -> Connection réussie', 2);
END;

FUNCTION TDm_Common.FTPConnect(bGet: Boolean): Boolean;
BEGIN

  Result := False;

  IF (MySiteParams.sFTPHost <> '') THEN
  BEGIN
    // Au cas ou...
    IF FTP.Connected THEN
    BEGIN
      // Dans le doute
      FTP.Abort;
      FTP.Disconnect;
    END;
    IF bGet THEN
    BEGIN
      FTP.Host := MySiteParams.sURLGet;
      FTP.Username := MySiteParams.sLoginGet;
      FTP.Password := MySiteParams.sPassGet;
    END
    ELSE BEGIN
      FTP.Host := MySiteParams.sURLSend;
      FTP.Username := MySiteParams.sLoginSend;
      FTP.Password := MySiteParams.sPassSend;
    END;

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
        LogAction('ERREUR - Serveur : ' + MySiteParams.sFTPHost + ' -> Connection échoué', 1);
      END;
    END;
  END
  ELSE BEGIN
    // Host mal lu
    LogAction('ERREUR - Serveur non renseigné, vérifiez votre configuration.', 1);
  END;
END;

PROCEDURE TDm_Common.FTPDisconnect;
BEGIN
  TRY
    FTP.Disconnect;
  EXCEPT

  END;
END;

FUNCTION TDm_Common.FTPFileExists(CONST ADirectory,
  AFile: STRING): Boolean;
VAR

  AOldDir: STRING;
  FolderList: TStringList;
BEGIN
  Result := False;
  TRY
    IF NOT FTP.Connected THEN //Pas connecté ?
      FTP.Connect(); //On connecte
  EXCEPT
    FTP.Disconnect;
    Exit; //Impossible de connecter !
  END;

  FolderList := TStringList.Create;
  TRY
    AOldDir := FTP.RetrieveCurrentDir; //sauvegarder le répertoire actuel
    TRY
      FTP.ChangeDir(ADirectory); //Si le dossier n'existe pas -> exception levée
      TRY
        FTP.List(FolderList, '*.*', False); //Lister les fichiers
      FINALLY
        Result := FolderList.IndexOf(ExtractFileName(AFile)) >= 0;
      END;
    EXCEPT
    END;
  FINALLY
    FTP.ChangeDir(AOldDir); //reviens à l'ancien dossier
    FolderList.Free; //Libère la StringList
  END;
END;

PROCEDURE TDm_Common.FTPFolderProcess;
VAR
  MyFile: TSearchRec;
  sExtension, sListExtensions: STRING;
  iRes: integer;
BEGIN
  sListExtensions := UpperCase(';' + MySiteParams.sFTPSendExtention + ';');
  iRes := FindFirst(MySiteParams.sToSendFolder + '*.*', faAnyFile, MyFile);
  WHILE iRes = 0 DO
  BEGIN
    sExtension := ExtractFileExt(MyFile.Name);
    Delete(sExtension, 1, 1);
    sExtension := UpperCase(';' + sExtension + ';');
    // On exclu de la liste le dossier . et .. et les fichiers dont l'extension n'est pas à traiter
    IF ((MyFile.Name <> '.') AND (MyFile.Name <> '..')) AND (Pos(sExtension, sListExtensions) > 0) THEN
    BEGIN
      // Traitement du fichier
      IF MySiteParams.sFTPSendFolder <> '' THEN
      BEGIN
        FTPFileSend(ExtractFileName(MyFile.Name));
      END
      ELSE BEGIN
        LogAction('', 2);
        LogAction('/***************************************************/', 2);
        LogAction('INFO - Fichier non traité : ' + ExtractFileName(MyFile.Name), 2);
        LogAction('/***************************************************/', 2);
      END;
    END;
    iRes := FindNext(MyFile);
  END;
  FindClose(MyFile);
END;

FUNCTION TDm_Common.FTPGetAFile(AFileName, APathFileToGet: STRING;
  AExpectedSize: integer): boolean;
VAR
  j: integer;
  bTransOK: boolean;
  iFileSize: integer;
  //  F: TextFile;

BEGIN
  j := 0;
  REPEAT
    TRY
      LogAction('INFO - Réception fichier ' + AFileName + ' : Essai ' + IntToStr(j + 1) + '/' + IntToStr(MySiteParams.iFTPNbTry), 2);
      // Téléchargement du fichier
//      sPathFileToGet := IncludeTrailingBackslash(AFolderToSave) + AFileName;
      IF FileExists(APathFileToGet) THEN
      BEGIN
        // on l'a déjà, on la retélécharge, le fichier du FTP est le plus fiable
        DeleteFile(APathFileToGet);
      END;

      FTP.Get(AFileName, APathFileToGet, True, False);

      iFileSize := FileSizeByName(APathFileToGet);

      // une fois le Get Effectué, on vérifie la taille du fichier pour vérif que le transfert est ok
      IF AExpectedSize = iFileSize THEN
      BEGIN
        bTransOK := True;

        // Suppression sur le ftp
        IF MySiteParams.bDelFTPFiles THEN
          FTP.Delete(AFileName);
      END
      ELSE
        bTransOK := False;

      // Fermeture du fichier
    EXCEPT
      bTransOK := False;
    END;

    // Si le transfert ne s'est pas bien passé, on recommence (x fois max a param dans l'ini)
    IF NOT (bTransOK) THEN inc(j);
  UNTIL ((bTransOK) OR (j = MySiteParams.iFTPNbTry));

  Result := bTransOK;
END;

FUNCTION TDm_Common.FTPGetList: boolean;
BEGIN
  Result := False;
  TRY
    FTP.List(Str_FTPList.Strings, '*.xml', True);

    Result := True;
  EXCEPT
    ON E: Exception DO
    BEGIN
      // Erreur
      Result := False;
    END;
  END;
END;

FUNCTION TDm_Common.FTPPutFile(sFileSend: STRING): boolean;
VAR
  sFolder: STRING;
  sFile: STRING;
BEGIN
  TRY
    sFile := ExtractFileName(sFileSend);
    sFolder := MySiteParams.sFTPSendFolder;

    Application.ProcessMessages;

    // On envoie le fichier
    FTP.TransferType := ftBinary;
    FTP.Put(sFileSend, sFile, False);

    Application.ProcessMessages;

    result := true;
  EXCEPT
    ON E: EXCEPTION DO
    BEGIN
      LogAction('ERREUR - Erreur d''envoi du fichier : ' + E.Message, 1);
      result := false;
    END;
  END;

END;

PROCEDURE TDm_Common.FTPFileSend(sFile: STRING);
VAR
  sFileSend, sFileReceive: STRING;
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
  LogAction('', 2);
  LogAction('/***************************************************/', 2);
  LogAction('INFO - Envoi fichier ' + sFile, 2);

  i := 0;
  REPEAT
    LogAction('INFO - Essai ' + IntToStr(i + 1) + '/' + IntToStr(MySiteParams.iFTPNbTry), 2);
    bTransOK := FTPConnect(False);
    // Si la connection a bien réussie, on envoie le fichier
    IF bTransOK THEN
    BEGIN

      sFileSend := MySiteParams.sToSendFolder + sFile;
      sFileReceive := MySiteParams.sSentFolder + sFile;

      // Positionnement dans le bon dossier sur le site FTP.
      FTP.ChangeDir(MySiteParams.sFTPSendFolder);
      LogAction('OK - Positionnement dans ' + MySiteParams.sFTPSendFolder, 2);

      // Envoi du fichier
      bTransOK := FTPPutFile(sFileSend);

      // Si l'envoi s'est bien passé, on teste le transfert par un controle de crc.
      IF bTransOK THEN
      BEGIN
        IF MySiteParams.bFTPValidEnvoi THEN
        BEGIN
          bTransOK := FTPTestTransfert(sFileSend, sFileReceive);
        END
        ELSE BEGIN
          bTransOK := MoveFileEx(PChar(sFileSend), PChar(sFileReceive), MOVEFILE_REPLACE_EXISTING);
          IF bTransOK THEN
          BEGIN
            LogAction('OK - Déplacement vers dossier SENT réussi', 2);
          END
          ELSE BEGIN
            LogAction('ERREUR - Déplacement vers dossier SENT échoué', 1);
          END;
        END;
      END;
    END;
    // Si le transfert ne s'est pas bien passé, on recommence (x fois max a param dans l'ini)
    IF NOT (bTransOK) THEN inc(i);

    // Déco avant nouvel essai
    FTPDisconnect();

  UNTIL ((bTransOK) OR (i = MySiteParams.iFTPNbTry));

  IF NOT (bTransOK) THEN
  BEGIN
    // On est sorti pour cause de 3 essais échoué
    LogAction('ERREUR - ' + IntToStr(MySiteParams.iFTPNbTry) + ' Echecs successifs, Fichier non transmis', 1);
  END;
  LogAction('/***************************************************/', 2);

END;

FUNCTION TDm_Common.FTPTestTransfert(sFileSend,
  sFileReceive: STRING): boolean;
VAR
  CRC1, CRC2: STRING;
BEGIN
  TRY
    // On recup le fichier (pour test + tard)
    FTP.Get(ExtractFileName(sFileSend), sFileReceive, True, false);

    CRC1 := MD5FromFile(sFileSend);
    CRC2 := MD5FromFile(sFileReceive);
    IF crc1 = crc2 THEN
    BEGIN
      // On supprime le fichier envoyé
      DeleteFile(sFileSend);
      LogAction('OK - Fichiers identique, transfert validé', 2);
      Result := true
    END
    ELSE BEGIN
      // On supprime le fichier recu
      FTP.Delete(ExtractFileName(sFileSend));
      DeleteFile(sFileReceive);
      result := false;
      // les deux fichiers sont différents
      LogAction('ERREUR - Fichier erronné, transfert échoué', 1);
      // Suppression du fichier envoyé, au cas ou
    END;
  EXCEPT
    ON E: EXCEPTION DO
    BEGIN
      LogAction('ERREUR - Erreur de récupération du fichier : ' + E.Message, 1);
      result := false;
    END;
  END;
END;

PROCEDURE TDm_Common.FTPConnected(Sender: TObject);
BEGIN
  LogAction('OK - Serveur : ' + MySiteParams.sFTPHost + ' -> Connection réussie', 2);
END;

PROCEDURE TDm_Common.FTPDisconnected(Sender: TObject);
BEGIN
  LogAction('OK - Déconnection', 2);
END;

FUNCTION TDm_Common.SendMail: Boolean;
VAR
  iafAttachement: TIdAttachmentFile;
BEGIN
  Result := False;

  IF MySiteParams.sSMTPHost = '' THEN
  BEGIN
    LogAction('Pas de SMTP renseigné, impossible d''envoyer un E-Mail', 2);
    Result := False;
    EXIT;
  END;

  IF MySiteParams.sMailDest = '' THEN
  BEGIN
    LogAction('Pas de destinataire renseigné, impossible d''envoyer un E-Mail', 2);
    Result := False;
    EXIT;
  END;

  IF MySiteParams.sMailExp = '' THEN
  BEGIN
    LogAction('Pas d''expéditeur renseigné, impossible d''envoyer un E-Mail', 2);
    Result := False;
    EXIT;
  END;

  SMTP.Host := MySiteParams.sSMTPHost;
  SMTP.Port := StrToInt(MySiteParams.sSMTPPort);

  IF MySiteParams.sSMTPUser <> '' THEN
  BEGIN
    SMTP.AuthType := atDefault;
    SMTP.Username := MySiteParams.sSMTPUser;
    SMTP.Password := MySiteParams.sSMTPPwd;
  END
  ELSE BEGIN
    SMTP.AuthType := atNone;
  END;

  idMsgSend.Clear;
  idMsgSend.Body.Clear;
  idMsgSend.From.Text := MySiteParams.sMailExp;

  idMsgSend.Recipients.EMailAddresses := MySiteParams.sMailDest;
  idMsgSend.Subject := 'Erreur de l''outil : ' + Application.ExeName;
  idMsgSend.Body.Text := 'Une erreur est survenue lors de l''exécution du service, voir le log joint.';
  IF FileExists(GetLogFile) THEN
    iafAttachement := TIdAttachmentFile.create(idMsgSend.MessageParts, GetLogFile);

  TRY
    SMTP.Connect();
  EXCEPT
    LogAction('Erreur de connection au serveur de messagerie', 4);
    result := false;
    EXIT;
  END;

  TRY
    // === Tout est OK ===
    SMTP.Send(idMsgSend);
    LogAction('Message envoyé à : ' + idMsgSend.Recipients.EMailAddresses, 4);
  EXCEPT
    ON E: Exception DO
    BEGIN
      // === Ne devrait normalement pas se produire ===
      LogAction(E.Message, 0);
      LogAction('Erreur SendMail', 4);
      result := false;
      SMTP.Disconnect();
      EXIT;
    END;
  END;

  SMTP.Disconnect();
  IF iafAttachement <> NIL THEN
    iafAttachement.Free;
  Result := True;

END;

PROCEDURE TDm_Common.SendLog(bModeAuto: boolean);
BEGIN
  IF bModeAuto THEN
  BEGIN
    IF SendMail() THEN
    BEGIN
      // Suppression du log
      DelCurrentLog;
    END;
  END;
END;

FUNCTION TDm_Common.GenImportGetId(AId: integer; AKtb: integer): integer;
BEGIN
  Result := 0;
  TRY
    Que_SelGenImport.Close;
    Que_SelGenImport.ParamByName('REFID').AsInteger := AId;
    Que_SelGenImport.ParamByName('KTBID').AsInteger := AKtb;
    Que_SelGenImport.Open;

    Result := Que_SelGenImportIMP_GINKOIA.AsInteger;
  FINALLY
    Que_SelGenImport.Close;
  END;
END;

FUNCTION TDm_Common.GenImportGetId(AId: STRING; AKtb: integer): integer;
BEGIN
  Result := 0;
  TRY
    Que_SelGenImportStr.Close;
    Que_SelGenImportStr.ParamByName('REFID').AsString := AId;
    Que_SelGenImportStr.ParamByName('KTBID').AsInteger := AKtb;
    Que_SelGenImportStr.Open;

    Result := Que_SelGenImportStrIMP_GINKOIA.AsInteger;
  FINALLY
    Que_SelGenImportStr.Close;
  END;
END;

FUNCTION TDm_Common.CdeExists(AIdCde: integer): Boolean;
BEGIN
  Result := True;
  Que_CdeExists.Close;
  TRY
    Que_CdeExists.ParamByName('ID_COMMANDE').AsInteger := AIdCde;
    Que_CdeExists.Open;

    IF Que_CdeExists.Fields[0].AsInteger > 0 THEN
    BEGIN
      Result := True;
    END
    ELSE BEGIN
      Result := False;
    END;
  EXCEPT
    Result := True; // En cas d'erreur, on considère qu'elle existe pour par risquer un pb
  END;
  Que_CdeExists.Close;

END;

PROCEDURE TDm_Common.CumulMontant(VAR tabMontant: tbMontant; fTva, fMtTva, fMtTTC: Double);
VAR
  j: Integer;
BEGIN
  j := 0;
  WHILE j <= High(tabMontant) DO // High renvoie -1 si tableau vide
  BEGIN
    IF tabMontant[j].fTVA = fTVA THEN
    BEGIN
      // Ok, on a trouvé la bonne TVA, on sort
      BREAK;
    END;
    // Suivant
    inc(j);
  END;

  TRY
    // si on l'a trouvé
    IF j <= High(tabMontant) THEN
    BEGIN
      // Cumul des quantités
      tabMontant[j].fMontantTVA := tabMontant[j].fMontantTVA + fMtTva;
      tabMontant[j].fMontantTTC := tabMontant[j].fMontantTTC + fMtTTC;
    END
    ELSE
    BEGIN
      // On l'a pas trouvé, on ajoute la ligne de tva
      // Augmente le nombre de ligne dans le tableau
      SetLength(tabMontant, (Length(TabMontant) + 1));
      tabMontant[High(tabMontant)].fTVA := fTVA;
      tabMontant[High(tabMontant)].fMontantTVA := fMtTVA;
      tabMontant[High(tabMontant)].fMontantTTC := fMtTTC;
    END;
  EXCEPT
    ON e: exception DO
    BEGIN
      logaction(E.Message, 4);
    END;
  END;
END;

FUNCTION TDm_Common.GetArticleInfos(sCodeBar: STRING): stArticleInfos;
BEGIN
  Que_GetArtInfos.Close;
  Que_GetArtInfos.ParamByName('CBICB').AsString := sCodeBar;
  Que_GetArtInfos.ParamByName('MAGID').AsInteger := MySiteParams.iMagID;
  TRY
    Que_GetArtInfos.Open;
    With Result do
    begin
      iArfId := Que_GetArtInfos.FieldByName('ARF_ID').AsInteger;
      iArtId := Que_GetArtInfos.FieldByName('ARF_ARTID').AsInteger;
      iTgfId := Que_GetArtInfos.FieldByName('CBI_TGFID').AsInteger;
      iCouId := Que_GetArtInfos.FieldByName('CBI_COUID').AsInteger;
      fTVA := Que_GetArtInfos.FieldByName('TVA_TAUX').AsFloat;
      fPxAchat := Que_GetArtInfos.FieldByName('PXACHAT').AsFloat;
      fPxBrut := Que_GetArtInfos.FieldByName('PXVTEBRUT').AsFloat;
      IsValide := (iArtId <> 0) and (iTgfId <> 0) and (iCouId <> 0);
    end;
  EXCEPT
    ON E: Exception DO
    BEGIN
      Result.iArfId := 0;
      Result.iArtId := 0;
      Result.iTgfId := 0;
      Result.iCouId := 0;
      Result.fTVA := 0;
      Result.fPxAchat := 0;
      Result.fPxBrut := 0;
      Result.IsValide := False;
    END;
  END;
  Que_GetArtInfos.Close;
END;

FUNCTION TDm_Common.GetParamFloat(ACode: integer): double;
VAR
  iInt, iMag, iPos: integer;
  fFlt: double;
  sStr: STRING;
BEGIN
  Result := 0;
  TRY
    IF GetParam(ACode, iInt, iMag, iPos, fFlt, sStr) THEN
      Result := fFlt;
  EXCEPT
  END;
END;

FUNCTION TDm_Common.GetParamMag(ACode: integer): integer;
VAR
  iInt, iMag, iPos: integer;
  fFlt: double;
  sStr: STRING;
BEGIN
  Result := 0;
  TRY
    IF GetParam(ACode, iInt, iMag, iPos, fFlt, sStr) THEN
      Result := iMag;
  EXCEPT
  END;
END;

FUNCTION TDm_Common.GetParamPos(ACode: integer): integer;
VAR
  iInt, iMag, iPos: integer;
  fFlt: double;
  sStr: STRING;
BEGIN
  Result := 0;
  TRY
    IF GetParam(ACode, iInt, iMag, iPos, fFlt, sStr) THEN
      Result := iPos;
  EXCEPT
  END;
END;

FUNCTION TDm_Common.GetParamInteger(ACode: integer): integer;
VAR
  iInt, iMag, iPos: integer;
  fFlt: double;
  sStr: STRING;
BEGIN
  Result := 0;
  TRY
    IF GetParam(ACode, iInt, iMag, iPos, fFlt, sStr) THEN
      Result := iInt;
  EXCEPT
  END;
END;

FUNCTION TDm_Common.GetParamString(ACode: integer): STRING;
VAR
  iInt, iMag, iPos: integer;
  fFlt: double;
  sStr: STRING;
BEGIN
  Result := '';
  TRY
    IF GetParam(ACode, iInt, iMag, iPos, fFlt, sStr) THEN
      Result := sStr;
  EXCEPT
  END;
END;

FUNCTION TDm_Common.GetParam(iCode: integer; VAR PrmInteger, PrmMag, PrmPos: integer;
  VAR PrmFloat: double; VAR PrmString: STRING): boolean;
BEGIN
  Result := True;
  Que_GetParam.Close;
  TRY
    Que_GetParam.ParamByName('PRMCODE').AsInteger := iCode;
    Que_GetParam.Open;
    PrmInteger := Que_GetParam.FieldByName('PRM_INTEGER').AsInteger;
    PrmMag := Que_GetParam.FieldByName('PRM_MAGID').AsInteger;
    PrmPos := Que_GetParam.FieldByName('PRM_POS').AsInteger;
    PrmFloat := Que_GetParam.FieldByName('PRM_FLOAT').AsFloat;
    PrmString := Que_GetParam.FieldByName('PRM_STRING').AsString;
    Que_GetParam.Close;
  EXCEPT
    ON E: Exception DO
    BEGIN
      Result := False;
    END;
  END;
  Que_GetParam.Close;
END;

FUNCTION TDm_Common.NewK(ATblName: STRING): integer;
VAR
  MyId: integer;
BEGIN
  TRY
    IbC_K.Close;
    IbC_K.SQL.Text := 'SELECT ID FROM PR_NEWK(:TBL)';
    IbC_K.ParamByName('TBL').AsString := ATblName;
    IbC_K.Open;
    MyId := IbC_K.FieldByName('ID').AsInteger;
  EXCEPT
    ON E: Exception DO
    BEGIN
      MyId := 0;
    END;
  END;
  IbC_K.Close;

  Result := MyId;
END;

PROCEDURE TDm_Common.UpdateK(AKId: integer; Enabled: integer = 1);
BEGIN
  TRY
    IbC_K.Close;
    IbC_K.SQL.Text := 'EXECUTE PROCEDURE PR_UPDATEK(:KID, :ENABLED)';
    IbC_K.ParamByName('KID').AsInteger := AKId;
    IbC_K.ParamByName('ENABLED').AsInteger := Enabled;
    IbC_K.Open;
  EXCEPT
    ON E: Exception DO
    BEGIN
      // erreur le k ne sera pas mouvementé
    END;
  END;
  IbC_K.Close;

END;

PROCEDURE TDm_Common.NetEvenGet(dtForceJourDeb : TDateTime = 0; dtForceJourFin: TDateTime = 0);
VAR
  wsNetEven: TGestionNetEven;
  aCdes: GetOrdersResponse;

  i, j, iSvg: Integer;

  sCdeId, sCdeIdCumul: STRING;

  fMontantFP, fTvaFP, fMtTvaFP: double;

  tabMontant: tbMontant;

  stArticle: stArticleInfos;
  stLot: stLotInfos;

  tabLotArticles: ARRAY OF stArticleInfos;

  iArt: Integer;

  fPxRemise, fPxRemiseHT, fPxRemiseMtTVA: Double;

  nbCdes, iNbTraite, iNbExiste, iNbNotToDo: Integer;

  sTestConnect: STRING;

  bCdeExisteDeja: Boolean;
  bForceJournee: Boolean;
BEGIN
  iNbTraite := 0;
  iNbExiste := 0;
  iNbNotToDo := 0;

  bForceJournee := (dtForceJourDeb <> 0) and (dtForceJourFin <> 0);

  wsNetEven := CreerNWSServer(MySiteParams.sURLGet, MySiteParams.sLoginGet, MySiteParams.sPassGet, MySiteParams.sLocalFolderGet); //'laurent@ekosport.fr', '2fsarl73');
  TRY
    TRY
      sTestConnect := wsNetEven.TestConnection;
    FINALLY
      CloseNWSServer(wsNetEven);
    END;

    IF sTestConnect = 'OK' THEN
    BEGIN
      iNbErreurNetEven := 0;

      // Lorsque l'on est en mode 'Forcer la journée', on force les date de deb et fin, et on n'enregistrera rien
      if bForceJournee then
      begin
        MySiteParams.dtLastTime := dtForceJourDeb;
        MySiteParams.dtCurrentTime := dtForceJourFin;
      end
      else begin
        IF MyIniParams.dtHier < Now() THEN
        BEGIN
          MySiteParams.dtLastTime := Trunc(MySiteParams.dtCurrentTime - 4); // On vérif 4 jours complets dans ce cas
        END;
      end;

      LogAction('Date deb : ' + DateTimeToStr(MySiteParams.dtLastTime), 3);
      LogAction('Date fin : ' + DateTimeToStr(MySiteParams.dtCurrentTime), 3);
      LogAction('Code site : ' + IntToStr(MySiteParams.iCodeSite), 3);

      Sleep(50); // Petite tempo pour éviter erreur sur WebService
      Application.ProcessMessages; // Refresh de l'affichage

      // Création de l'instance du WebService
      wsNetEven := CreerNWSServer(MySiteParams.sURLGet, MySiteParams.sLoginGet, MySiteParams.sPassGet, MySiteParams.sLocalFolderGet); //'laurent@ekosport.fr', '2fsarl73');

      aCdes := wsNetEven.GetCommandes(MySiteParams.dtLastTime, MySiteParams.dtCurrentTime);
      TRY
        nbCdes := Length(aCdes.GetOrdersResult);

        LogAction(IntToStr(nbCdes) + ' lignes de commandes à traiter', 3);
        // Todo : faire évoluer pour stocker le résultat du flux

        IbT_Modif.StartTransaction;

        sCdeId := '0';
        IF nbCdes > 0 THEN
        BEGIN
          WHILE i <= (nbCdes - 1) DO
          BEGIN
            IF StrToInt(aCdes.GetOrdersResult[i].MarketPlaceId) = MySiteParams.iCodeSite THEN
            BEGIN

              // Création De l'entete, dès qu'on est sur une nouvelle commande
              IF sCdeId <> aCdes.GetOrdersResult[i].OrderID THEN
              BEGIN
                // Etape 1 : On vérifie si elle existe pas déjà cette commande
                bCdeExisteDeja := CdeExists(StrToInt(aCdes.GetOrdersResult[i].OrderID));

                iSvg := i;
                // On parcours les commandes jusqu'a ce que l'on soit sur un iCdeId Différent
                sCdeIdCumul := aCdes.GetOrdersResult[i].OrderID; // Svg de l'id
                REPEAT
                  IF Pos('*', aCdes.GetOrdersResult[i].SKU) > 0 THEN
                  BEGIN
                    // Atention, cas des packs
                    SKUVersLot(stLot, aCdes.GetOrdersResult[i].SKU, aCdes.GetOrdersResult[i].Price);

                    FOR j := 0 TO (Length(stLot.tabArticles) - 1) DO
                    BEGIN
                      fPxRemise := ArrondiMonetaire(stLot.tabArticles[j].fPxBrut * (1 - stLot.fRemise));
                      fPxRemiseHT := ArrondiMonetaire(100 * fPxRemise / (100 + stLot.tabArticles[j].fTva));
                      fPxRemiseMtTVA := ArrondiMonetaire(fPxRemise - fPxRemiseHT);

                      // Cumul des prix
                      CumulMontant(tabMontant, stLot.tabArticles[j].fTva, fPxRemiseMtTVA, fPxRemise);
                    END;
                  END
                  ELSE BEGIN
                    // Récup des infos de l'article
                    stArticle := GetArticleInfos(aCdes.GetOrdersResult[i].SKU);

                    // Cumul des prix
                    CumulMontant(tabMontant, stArticle.fTva, aCdes.GetOrdersResult[i].VAT, aCdes.GetOrdersResult[i].Price);

                  END;

                  // Cumul des frais de port
                  fMontantFP := fMontantFP + aCdes.GetOrdersResult[i].FinalShippingCost;

                  Inc(i); // Suivant

                  IF i > (nbCdes - 1) THEN // Derniere commande
                    BREAK;

                UNTIL sCdeIdCumul <> aCdes.GetOrdersResult[i].OrderID;
                i := iSvg;

                stLot.iNumLot := 0;
                stLot.iLotId := 0;
                // Récup du taux de TVa des FP
                IbC_GetTvaFP.Close;
                IbC_GetTvaFP.ParamByName('ARTID').AsInteger := MySiteParams.iPseudoLivr;
                IbC_GetTvaFP.Open;
                fTvaFP := IbC_GetTvaFP.FieldByName('TVA_TAUX').AsFloat;
                IbC_GetTvaFP.Close;

                fMtTvaFP := ArrondiMonetaire(fMontantFP - ArrondiMonetaire(100 * fMontantFP / (100 + fTvaFP)));

                // Cumul des prix des frais de port
                CumulMontant(tabMontant, fTvaFP, fMtTvaFP, fMontantFP);

                IF NOT bCdeExisteDeja THEN
                BEGIN
                  // Creer l'entete
                  NetEven_CreeEntete(aCdes.GetOrdersResult[i], tabMontant, fMontantFP);
                  Inc(iNbTraite);
                  LogAction('Traitement de la commande : ' + Copy(aCdes.GetOrdersResult[i].MarketPlaceName, 1, 4) + '-' + aCdes.GetOrdersResult[i].OrderID, 2);
                END
                ELSE BEGIN
                  // Appel de la procédure qui se charge de mettre à jour le règlement.
                  NetEven_CreeEntete(aCdes.GetOrdersResult[i], tabMontant, fMontantFP);
                  Inc(iNbExiste);
                  LogAction('Vérification et Maj de la commande : ' + Copy(aCdes.GetOrdersResult[i].MarketPlaceName, 1, 4) + '-' + aCdes.GetOrdersResult[i].OrderID, 2);
                END;

                // Vidage du tableau
                SetLength(tabMontant, 0);
                fMontantFP := 0;

                // Svg de l'id
                sCdeId := aCdes.GetOrdersResult[i].OrderID;

              END;

              IF NOT bCdeExisteDeja THEN // On ne traite pas si elle existe déjà
              BEGIN
                IF Pos('*', aCdes.GetOrdersResult[i].SKU) > 0 THEN
                BEGIN
                  stLot.iLotId := 0;
                  Inc(stLot.iNumLot);

                  // Atention, cas des packs
                  SKUVersLot(stLot, aCdes.GetOrdersResult[i].SKU, aCdes.GetOrdersResult[i].Price);

                  FOR j := 0 TO (Length(stLot.tabArticles) - 1) DO
                  BEGIN
                    NetEven_CreeLigne(aCdes.GetOrdersResult[i], stLot.tabArticles[j], stLot);
                  END;

                END
                ELSE BEGIN
                  stLot.iLotId := 0;
                  // Traiter la ligne
                  NetEven_CreeLigne(aCdes.GetOrdersResult[i], stArticle, stLot);
                END;
              END;
            END
            ELSE BEGIN
              Inc(iNbNotToDo)
            END;
            // Suivante
            Inc(i);
          END;
        END;

        LogAction(IntToStr(iNbTraite) + ' commandes traitées', 3);
        LogAction(IntToStr(iNbExiste) + ' commandes ignorées (déjà existantes)', 3);
        LogAction(IntToStr(iNbNotToDo) + ' commandes ignorées (code site différent)', 3);

        // Uniquement si on est pas en mode 'Forcer une journée'
        if not bForceJournee then
        begin
          // Sauve l'heure de dernier traitement
          Que_UpdateLastTime.Close;
          Que_UpdateLastTime.ParamByName('ASFID').AsInteger := MySiteParams.iAsfID;
          Que_UpdateLastTime.ParamByName('LASTTIME').AsDateTime := MySiteParams.dtCurrentTime;
          Que_UpdateLastTime.ExecSQL;
          Que_UpdateLastTime.Close;

          // Si tout c'est bien passé, et qu'on a fait les 4 jour, on sauve la date du moment
          IF MyIniParams.dtHier < Now() THEN
          BEGIN
            MyIniParams.dtHier := (DateOf(Now()) + TimeOf(MyIniParams.dtHier)) + 1; // On passe la date à demain, pour prochain traitement
          END;
        end;

        IbT_Modif.Commit;

      EXCEPT
        ON E: Exception DO BEGIN
          IbT_Modif.Rollback;
          LogAction('Erreur lors de la création des commandes NetEven', 0);
          LogAction(E.Message, 0);
        END;
      END;

      IF Assigned(aCdes) THEN
        aCdes.Free;

      CloseNWSServer(wsNetEven);
    END
    ELSE
    BEGIN
      Inc(iNbErreurNetEven);
      IF iNbErreurNetEven = 3 THEN
      BEGIN
        LogAction('WebService NetEven non disponible (3 tentatives)', 0);
      END;
    END;
  EXCEPT
    ON e: Exception DO
    BEGIN
      LogAction(E.Message, 1);
    END;
  END;

  // Vidage
  SetLength(stLot.tabArticles, 0);

END;

PROCEDURE TDm_Common.NetEven_CreeEntete(ACdeLine: MarketPlaceOrder; AtabMontant: tbMontant; AFraisPort: Double);
VAR
  CliID: STRING;
  i, iPaiement: Integer;
  //  iPos: Integer;
  sPays: STRING;
BEGIN
  IF ACdeLine.BillingAddress.Email = '' THEN
    Exit;

  Que_Client.Close;
  CliID := ComputeSignature(ACdeLine.BillingAddress.Email, '', '', '');

  // Création du client
  Que_Client.ParamByName('ID_CLIENT').AsString := CliID;

  WITH ACdeLine.BillingAddress DO
  BEGIN
    //    if FirstName = '' THEN
    //    begin
    //      iPos := Pos(' ', LastName);
    //      if iPos > 0 Then
    //      begin
    //        FirstName := Copy(LastName, iPos + 1, Length(LastName) - iPos);
    //        LastName := Copy(LastName, 1, iPos - 1);
    //      end;
    //    end;
    sPays := UpperCase(StrEnleveAccents(Country));
    IF Pos('FRANCE', sPays) > 0 THEN
    BEGIN
      sPays := 'FRANCE';
    END;

    Que_Client.ParamByName('NOM_CLIENT').AsString := Copy(LastName, 1, 64);
    Que_Client.ParamByName('PRENOM_CLIENT').AsString := Copy(FirstName, 1, 64);
    Que_Client.ParamByName('EMAIL_CLIENT').AsString := Copy(Email, 1, 128);
    Que_Client.ParamByName('ADRESSE_FACTURATION').AsString := Copy(Address1 + RC + Address2, 1, 512);
    Que_Client.ParamByName('CP_CLIENT').AsString := Copy(PostalCode, 1, 32);
    Que_Client.ParamByName('VILLE_CLIENT').AsString := Copy(CityName, 1, 64);
    Que_Client.ParamByName('ID_PAYS').AsInteger := GetOrCreatePayID(sPays);
    Que_Client.ParamByName('TEL_CLIENT').AsString := Copy(Phone, 1, 32);
    Que_Client.ParamByName('GSM_CLIENT').AsString := Copy(Mobile, 1, 32);
    Que_Client.ParamByName('FAX_CLIENT').AsString := Copy(Fax, 1, 32);
  END;

  WITH ACdeLine.ShippingAddress DO
  BEGIN
    //    if FirstName = '' THEN
    //    begin
    //      iPos := Pos(' ', LastName);
    //      if iPos > 0 Then
    //      begin
    //        FirstName := Copy(LastName, iPos + 1, Length(LastName) - iPos);
    //        LastName := Copy(LastName, 1, iPos + 1);
    //      end;
    //    end;
    sPays := UpperCase(StrEnleveAccents(Country));
    IF Pos('FRANCE', sPays) > 0 THEN
    BEGIN
      sPays := 'FRANCE';
    END;

    Que_Client.ParamByName('NOM_CLIENT_LIVRAISON').AsString := Copy(LastName, 1, 64);
    Que_Client.ParamByName('PRENOM_CLIENT_LIVRAISON').AsString := Copy(FirstName, 1, 64);
    Que_Client.ParamByName('EMAIL_CLIENT_LIVRAISON').AsString := Copy(Email, 1, 128);
    Que_Client.ParamByName('ADRESSE_LIVRAISON').AsString := Copy(Address1 + RC + Address2, 1, 512);
    Que_Client.ParamByName('CP_CLIENT_LIVRAISON').AsString := Copy(PostalCode, 1, 32);
    Que_Client.ParamByName('VILLE_CLIENT_LIVRAISON').AsString := Copy(CityName, 1, 64);
    Que_Client.ParamByName('ID_PAYS_LIVRAISON').AsInteger := GetOrCreatePayID(sPays);
    Que_Client.ParamByName('TEL_CLIENT_LIVRAISON').AsString := Copy(Phone, 1, 32);
  END;

  Que_Client.ParamByName('SOCIETE').AsString := '';
  Que_Client.ParamByName('NUM_SIRET').AsString := '';
  Que_Client.ParamByName('NUM_TVA').AsString := '';

  ///  Que_Client.IB_Transaction.StartTransaction;
  Que_Client.ExecSQL;

  Que_Client.Close;

  // Création de l'entete de commande
  Que_Commande.Close;
  Que_Commande.ParamByName('ID_CLIENT').AsString := CliID;
  Que_Commande.ParamByName('ID_COMMANDE').AsInteger := StrToInt(ACdeLine.OrderID);
  Que_Commande.ParamByName('NUM_COMMANDE').AsString := Copy(ACdeLine.MarketPlaceName, 1, 4) + '-' + ACdeLine.OrderID;

  FOR i := 1 TO 5 DO // init à 0 des 5 champs TVA
  BEGIN
    Que_Commande.ParamByName('MT_TTC' + IntToStr(i)).AsFloat := 0;
    Que_Commande.ParamByName('MT_HT' + IntToStr(i)).AsFloat := 0;
    Que_Commande.ParamByName('MT_TAUX_HT' + IntToStr(i)).AsFloat := 0;
  END;

  FOR i := 0 TO High(ATabMontant) DO
  BEGIN
    Que_Commande.ParamByName('MT_TTC' + IntToStr(i + 1)).AsFloat := ArrondiMonetaire(ATabMontant[i].fMontantTTC);
    Que_Commande.ParamByName('MT_HT' + IntToStr(i + 1)).AsFloat := ArrondiMonetaire(ATabMontant[i].fMontantTTC - ATabMontant[i].fMontantTVA);
    Que_Commande.ParamByName('MT_TAUX_HT' + IntToStr(i + 1)).AsFloat := ATabMontant[i].fTVA;
  END;

  Que_Commande.ParamByName('REMISE').AsFloat := 0;

  Que_Commande.ParamByName('COMENT').AsString := Copy(ACdeLine.MarketPlaceName, 1, 512) + '-' + ACdeLine.OrderID;

  IF ACdeLine.VAT = 0 THEN
  BEGIN
    Que_Commande.ParamByName('HTWORK').AsInteger := 1;
    Que_Commande.ParamByName('DETAXE').AsInteger := 1;
  END
  ELSE BEGIN
    Que_Commande.ParamByName('HTWORK').AsInteger := 0;
    Que_Commande.ParamByName('DETAXE').AsInteger := 0;
  END;

  CASE ACdeLine.PaymentMethod OF
    CreditCard: iPaiement := 0;
    Check: iPaiement := 1;
    PayPal: iPaiement := 2;
    Other: iPaiement := 3;
    Unknown: iPaiement := 4;
  END;

  Que_Commande.ParamByName('CODE_SITE_WEB').AsInteger := StrToInt(ACdeLine.MarketPlaceId); // Voir si l'on met le Code_Marchand (ebay = 4)
  Que_Commande.ParamByName('DATE_CREATION').AsDateTime := ACdeLine.DateSale.AsDateTime;

  IF Assigned(ACdeLine.DatePayment) THEN
    Que_Commande.ParamByName('DATE_PAIEMENT').AsDateTime := ACdeLine.DatePayment.AsDateTime
  ELSE
    Que_Commande.ParamByName('DATE_PAIEMENT').AsDateTime := 0;

  Que_Commande.ParamByName('MONTANT_FRAIS_PORT').AsFloat := AFraisPort;
  Que_Commande.ParamByName('ID_PAIEMENT_TYPE').AsInteger := iPaiement;
  Que_Commande.ParamByName('NOM_CLIENT_LIVR').AsString := Copy(ACdeLine.ShippingAddress.LastName, 1, 64);
  Que_Commande.ParamByName('PRENOM_CLIENT_LIVR').AsString := Copy(ACdeLine.ShippingAddress.FirstName, 1, 64);

  Que_Commande.ExecSQL;

  Que_Commande.Close;
END;

PROCEDURE TDm_Common.NetEven_CreeLigne(ACdeLine: MarketPlaceOrder; AArtInfos: stArticleInfos; ALotInfos: stLotInfos);
BEGIN
  IF ACdeLine.BillingAddress.Email = '' THEN
    Exit;

  Que_CommandeL.Close;
  Que_CommandeL.ParamByName('ID_COMMANDE').AsInteger := StrToInt(ACdeLine.OrderID);
  Que_CommandeL.ParamByName('ID_PRODUIT').AsInteger := AArtInfos.iArtId;
  Que_CommandeL.ParamByName('ID_TAILLE').AsInteger := AArtInfos.iTgfId;
  Que_CommandeL.ParamByName('ID_COULEUR').AsInteger := AArtInfos.iCouId;
  Que_CommandeL.ParamByName('ID_PACK').AsInteger := ALotInfos.iLotId;
  Que_CommandeL.ParamByName('NUM_LOT').AsInteger := ALotInfos.iNumLot;
  Que_CommandeL.ParamByName('ID_CODE_PROMO').AsInteger := 0; // TODO
  Que_CommandeL.ParamByName('QTE').AsInteger := Trunc(ACdeLine.Quantity);
  Que_CommandeL.ParamByName('PX_BRUT').AsFloat := AArtInfos.fPxBrut;
  IF Trunc(ACdeLine.Quantity) <> 0 THEN
    Que_CommandeL.ParamByName('PX_NET').AsFloat := ACdeLine.Price / Trunc(ACdeLine.Quantity)
  ELSE
    Que_CommandeL.ParamByName('PX_NET').AsFloat := ACdeLine.Price;

  Que_CommandeL.ParamByName('PX_NET_NET').AsFloat := ACdeLine.Price;

  Que_CommandeL.ParamByName('POINTURE').AsString := '';
  Que_CommandeL.ParamByName('LONGUEUR').AsString := '';
  Que_CommandeL.ParamByName('MONTAGE_FIXATIONS').AsInteger := -1;
//  Que_CommandeL.ParamByName('POINTURE').AsString := '';
  Que_CommandeL.ParamByName('INFO_SUP').AsString := '';
  Que_CommandeL.ParamByName('TYPE_VTE').AsInteger := 1;

  Que_CommandeL.ExecSQL;

  Que_CommandeL.Close;
END;

FUNCTION TDm_Common.NewGenImport(ATblName: STRING; IDRef: integer): integer;
VAR
  MyId: integer;
BEGIN
  TRY
    Que_GetGenImportID.Close;
    Que_GetGenImportID.ParamByName('IDREF').AsInteger := IDRef;
    Que_GetGenImportID.ParamByName('KTBID').AsInteger := Ktb(ATblName);
    Que_GetGenImportID.Open;
    MyId := Que_GetGenImportID.FieldByName('ID').AsInteger;
  EXCEPT
    ON E: Exception DO
    BEGIN
      MyId := 0;
    END;
  END;
  Que_GetGenImportID.Close;

  Result := MyId;
END;

FUNCTION TDm_Common.GetOrCreatePayID(sPayNom: STRING): integer;
BEGIN
  Result := 0;
  TRY
    WITH Que_GetPays DO
    BEGIN
      Close;
      ParamByName('PAYNOM').asString := sPayNom;
      Open;
      Result := FieldByName('PAY_ID').AsInteger;
      Close;
    END;
  EXCEPT
  END;
END;

FUNCTION TDm_Common.GetIdByLib(sNomTbl, sColId, sColLib, sNomRecherche: STRING; sAddSQL: STRING = ''): integer;
BEGIN
  Result := 0;
  TRY
    QryGet.Close;
    QryGet.SQL.Text := 'SELECT ' + sColId + ' FROM ' + sNomTbl + ' JOIN K ON (K_ID = ' + sColId + ' AND K_ENABLED = 1) WHERE ' + sColLib + ' = :' + sColLib + ' ' + sAddSQL;
    QryGet.ParamByName(sColLib).asString := sNomRecherche;
    QryGet.Open;
    Result := QryGet.FieldByName(sColId).AsInteger;
    QryGet.Close;
  EXCEPT
    ON Stan: Exception DO
    BEGIN
      LogAction('Erreur lecture table ' + sNomTbl + ' : ' + Stan.Message, 1);
    END;
  END;

END;

FUNCTION TDm_Common.Adr123VersAdr(Adr1, Adr2, Adr3: STRING): STRING;
BEGIN
  Result := Adr1;

  IF Adr2 <> '' THEN
  BEGIN
    Result := Result + RC + Adr2;
  END;

  IF Adr3 <> '' THEN
  BEGIN
    Result := Result + RC + Adr3;
  END;
END;

END.

