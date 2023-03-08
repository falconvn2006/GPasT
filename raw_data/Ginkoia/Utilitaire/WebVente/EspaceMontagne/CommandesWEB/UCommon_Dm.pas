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
  // fin uses perso
  Dialogs,
  Db,
  dxmdaset,
  IdBaseComponent,
  IdComponent,
  IdTCPConnection,
  IdTCPClient,
  IdFTP,
  IdMessage,
  IdMessageClient,
  IdSMTP,
  ActionRv,
  IdSMTPBase,
  IdAllFTPListParsers,
  rxStrHlder,
  IdExplicitTLSClientServerBase,
  IBODataset,
  IB_Components;

TYPE
  stGenParam = RECORD
    iPseudoLivr: integer;
    iVendeur: integer;
    iMagID: integer;
    iProjet: integer;
    iTypeCDV: integer;
    iTarif: integer;
  END;

TYPE
  stParam = RECORD
    // FTP
    sFTPHost: STRING;
    sFTPUser: STRING;
    sFTPPwd: STRING;
    iFTPNbTry: Integer;
    bDelFTPFiles: boolean;

    // Reception
    FTPGetFolder: STRING; // dossier sur le serveur FTP contenant les fichiers à GET

    // Envoi
    FTPValidEnvoi: Boolean; // Vérif ou non du fichier envoyé par un get
    FTPSendFolder: STRING; // dossier sur le serveur FTP où déposer les fichiers à PUT
    FTPSendExtention: STRING; // Type des fichiers à envoyer

    // EMail
    sSMTPHost: STRING;
    sSMTPUser: STRING;
    sSMTPPwd: STRING;
    sSMTPPort: STRING;
    sMailDest: STRING;
    sMailExp: STRING;

    // DB
    sDBPath: STRING;

    // DB Interne
    sDBInterne: STRING;

    // Chemins locaux pour get/send ftp
    sGetFolder: STRING;
    sToSendFolder: STRING;
    sSentFolder: STRING;

    iNbErreurFTPBeforePrompt: integer;

    // Params du poste
    iMagID: integer;
    sMagNom: STRING;
    iPosID: integer;
    sPosNom: STRING;

    iDelOldLogAge: integer;
    bDelOldLog: boolean;
    iNiveauLog: integer;

    bSend, bGet: Boolean;
  END;

TYPE
  stMontant = RECORD
    fTVA: double;
    fMontantTVA: double;
    fMontantHT: double;
  END;

TYPE
  stArticleInfos = RECORD
    iArfId, iArtId, iTgfId, iCouId: integer;
    fPxAchat, fTVA: double;
  END;

TYPE
  stUneAdresse = RECORD
    sAdr_Civ: STRING;
    sAdr_Nom: STRING;
    sAdr_Prenom: STRING;
    sAdr_Ste: STRING;
    sAdr_Adr1: STRING;
    sAdr_Adr2: STRING;
    sAdr_Adr3: STRING;
    sAdr_CP: STRING;
    sAdr_Ville: STRING;
    sAdr_Pays: STRING;
    sAdr_PaysISO: STRING;
    sAdr_Tel: STRING;
    sAdr_Gsm: STRING;
    sAdr_Fax: STRING;
  END;
TYPE
  stLignes = RECORD
    sCode: STRING;
    stArticle: stArticleInfos;
    sDesignation: STRING;
    sTypePx: STRING;
    fPUBRUT: double;
    fPUHT: double;
    fPUTTC: double;
    fPXCREDIT: double;
    fRemise: double;
    fQte: double;
    fHT: double;
  END;
TYPE
  stUneCommande = RECORD
    iCdeIntranetID: Integer;
    sCdeStatut: STRING;
    sCdeNum: STRING;
    sCdeDate: STRING;
    dtCdeDate: TDateTime;
    sModeReg: STRING;
    sDateReg: STRING;
    dtDateReg: TDateTime;
    iCliID: Integer;
    sCliCode: STRING;
    sCliMail: STRING;
    stAdrFact: stUneAdresse;
    stAdrLiv: stUneAdresse;
    fCdeSsTotal: double;
    fCdeFPHT: double;
    fCdeFPTTC: double;
    fCdeTotHT: double;
    fCdeRemise: double;
    fCdeTVA: double;
    fCdeTotTTC: double;
    fCdeNetAPayer: double;

    bCdeDetaxe: boolean;

    sColiTransp: STRING; // Colis

    sErreur: STRING; // Permet de remonter une erreur
    tabLignes: ARRAY OF stLignes;
  END;

TYPE
  TDm_Common = CLASS(TDataModule)
    MemD_DBParams: TdxMemData;
    MemD_DBParamsMAGNOM: TStringField;
    MemD_DBParamsPOSNOM: TStringField;
    MemD_DBParamsSECNOM: TStringField;
    MemD_DBParamsMAGID: TIntegerField;
    MemD_DBParamsPOSID: TIntegerField;
    MemD_DBParamsSECID: TIntegerField;
    Que_SelKTB: TIBOQuery;
    Que_GetClientByEMail: TIBOQuery;
    Que_SelGenImport: TIBOQuery;
    Ginkoia: TIB_Connection;
    DBInterne: TIB_Connection;
    IbT_InterneSelect: TIB_Transaction;
    IbT_InterneModif: TIB_Transaction;
    IbT_Select: TIB_Transaction;
    Que_GetGenImportID: TIBOQuery;
    Que_GetFileATraiter: TIBOQuery;
    Que_GetFileInfo: TIBOQuery;
    Que_InsertFile: TIBOQuery;
    Que_UpdateFile: TIBOQuery;
    Que_Magasins: TIBOQuery;
    Que_MagasinsMAG_NOM: TStringField;
    Que_MagasinsMAG_ENSEIGNE: TStringField;
    Que_MagasinsMAG_ID: TIntegerField;
    Que_Postes: TIBOQuery;
    Que_PostesPOS_NOM: TStringField;
    Que_PostesPOS_ID: TIntegerField;
    FTP: TIdFTP;
    Str_FTPList: TStrHolder;
    SMTP: TIdSMTP;
    idMsgSend: TIdMessage;
    Que_CreerClient: TIBOQuery;
    Grd_CloseAll: TGroupDataRv;
    Que_GetCliAdrLivr: TIBOQuery;
    Que_GetCliAdrFact: TIBOQuery;
    Que_GetPays: TIBOQuery;
    IbT_Modif: TIB_Transaction;
    Que_SelGenImportStr: TIBOQuery;
    Que_SelGenImportIMP_GINKOIA: TIntegerField;
    Que_SelGenImportIMP_ID: TIntegerField;
    Que_SelGenImportStrIMP_GINKOIA: TIntegerField;
    Que_SelGenImportStrIMP_ID: TIntegerField;
    Que_CreerDevis: TIBOQuery;
    Que_GetParam: TIBOQuery;
    IbC_K: TIB_Cursor;
    QryGet: TIB_Cursor;
    Que_GetCiv: TIBOQuery;
    Que_CreerDevisLigne: TIBOQuery;
    Que_GetArtInfos: TIBOQuery;
    Que_MajBL: TIBOQuery;
    Que_UpdateStatut: TIBOQuery;
    Que_CreerCltCompte: TIBOQuery;
    Que_GetModeEnc: TIBOQuery;
    Que_GetOuCreeSesID: TIBOQuery;
    Que_MajCptClient: TIBOQuery;
    Que_GetTranspLib: TIBOQuery;

    PROCEDURE FTPConnected(Sender: TObject);
    PROCEDURE FTPDisconnected(Sender: TObject);
    procedure FTPAfterClientLogin(Sender: TObject);

  PRIVATE

    iNbErreurFTP: integer;

    //    FUNCTION QueryVersFile(AQuery: TIB_Query; AFileName: STRING): boolean;

    FUNCTION GetAdresseXML(ACursor: IXMLCursor): stUneAdresse; // A partir d'un noeud XML adresse, renvoie une structure remplie (car fait 2 fois (Adr Livr, et Adr Factu))

    // Outils
    // Récupération d'id à partir du libellé
    FUNCTION GetOrCreatePayID(sPayNom: STRING): integer;
    FUNCTION GetOrCreateCivID(sCivNom: STRING): integer;

    // Formatage d'adresse
    FUNCTION Adr123VersAdr(Adr1, Adr2, Adr3: STRING): STRING;

    // récupère un ID avec un libellé, en paramètre : nom de la table, nom de la colone contenant l'id, et de celle contenant le libellé, et la valeur recherchée
    FUNCTION GetIdByLib(sNomTbl, sColId, sColLib, sNomRecherche: STRING; sAddSQL: STRING = ''): integer;

    // Récupération de la session
    FUNCTION GetSesID(): Integer;

    // GENPARAM
    FUNCTION GetParam(iCode: integer; VAR PrmInteger, PrmMag, PrmPos: integer; VAR PrmFloat: double; VAR PrmString: STRING): boolean; // récupère les infos dans genparam a partri d'un code pour le prm_type=9

    // Mode d'encaissement
    FUNCTION GetModeEncId(AModeReg: STRING): integer;

    // Transporteur
    FUNCTION GetTransporteurLib(ACode, ANum, AMag: STRING): STRING;

    // Gestion des K et KTB
    FUNCTION Ktb(ATable: STRING): integer; // Récupère le KTB à partir du nom
    FUNCTION NewK(ATblName: STRING): integer; // Créé un nouveau K et renvoie l'id
    FUNCTION NewGenImport(ATblName: STRING; IDRef: integer): integer; // Créé un nouveau K et un nouveau GenIMP et renvoie l'id du K
    PROCEDURE UpdateK(AKId: integer; Enabled: integer = 1); // Maj du K (dates et Enabled au besoin)

    // Conversion
    FUNCTION ISOStrToDate(S: STRING): TDateTime; // Transforme une date ISO en DateTime

    { Déclarations privées }
  PUBLIC

    MyParams: stParam; // Contient les paramètres lus dans l'ini
    MyGenParam: stGenParam; // Contient les paramètres lus dans GenParam

    // Outils
    FUNCTION GenImportGetId(AId: integer; AKtb: integer): integer; OVERLOAD; // récupère l'id ginkoia à partir d'un id
    FUNCTION GenImportGetId(AId: STRING; AKtb: integer): integer; OVERLOAD; // récupère l'id ginkoia à partir d'un id

    FUNCTION GetParamInteger(ACode: integer): integer; // récupération dabs genparam en fct du type
    FUNCTION GetParamMag(ACode: integer): integer; // récupération dabs genparam en fct du type
    FUNCTION GetParamPos(ACode: integer): integer; // récupération dabs genparam en fct du type
    FUNCTION GetParamString(ACode: integer): STRING;
    FUNCTION GetParamFloat(ACode: integer): double;

    FUNCTION DBReconnect(bVerifParams: Boolean = True): boolean; // Connection aux DB
    FUNCTION ParamValides(): boolean;

    // Traitement des fichiers
    PROCEDURE ProcessXMLFiles(); // s'occupe de boucler sur la liste de fichier à traiter et de lancer TraiterFichierXML
    FUNCTION TraiterFichierXML(AQuery: TIBOQuery): boolean; // Traitement d'un fichier XML
    FUNCTION ParseXMLFile(sPathFic: STRING): stUneCommande; // Parse le fichier XML et stock les infos dans une structure

    // Récup d'infos sur le document
    FUNCTION GetCliID(stCdeEnCours: stUneCommande): integer; // Récupère l'id du client, le crée si besoin
    FUNCTION IsDocValide(AidCde: integer; VAR AErrMess: STRING; VAR ADocType: integer; VAR AIdGinkoia: integer): boolean; // Vérifie si le document est ok, exple : si c'est une facture alors erreur !

    // Création/MAj des documents
    FUNCTION CreateDevis(ACde: stUneCommande): integer;
    FUNCTION CreateDevisLine(ADveID, iNumLig: integer; ALine: stLignes): boolean;
    FUNCTION GetArticleInfos(sCodeBar: STRING): stArticleInfos;
    FUNCTION MajBL(AIdGinkoia: integer; ACde: stUneCommande): Boolean;
    FUNCTION MajCptClient(ACde: stUneCommande; DevID: integer = 0): Boolean;

    // FTP
    FUNCTION FTPConnect(): Boolean;
    PROCEDURE FTPDisconnect();

    FUNCTION FTPFileExists(CONST ADirectory, AFile: STRING): Boolean;

    FUNCTION FTPGetList(): boolean;
    PROCEDURE FTPFilesGet();
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
  ClientAdrMaj_Frm;

{$R *.DFM}

PROCEDURE TDm_Common.FTPFilesGet();
VAR
  bTransOk: boolean;
  i, j: integer;
  iIDFic: integer;
  bFileToGet: Boolean;
  bNewFile: boolean;
  sPathFileToGet: STRING;
  dtMyFileAge: TDateTime;
BEGIN
  //  Envoi du fichier :
  // Etape 1 : Connection FTP : x Essais
  // Etape 2 : Positionnement dans le dossier source.
  // Etape 3 : Récupération des fichiers nécéssaires.
  // Etape 4 : En cas d'erreur, on incrémente le compteur d'échecs

  LogAction('', 2);
  LogAction('/***************************************************/', 2);
  LogAction('INFO - Réception des fichiers en provenance de ' + MyParams.sFTPHost, 2);

  j := 0;
  REPEAT
    LogAction('INFO - Connection FTP à ' + MyParams.sFTPHost + '. : Essai ' + IntToStr(j + 1) + '/' + IntToStr(MyParams.iFTPNbTry), 2);
    bTransOK := FTPConnect();
    // Si le transfert ne s'est pas bien passé, on recommence (x fois max a param dans l'ini)
    IF NOT (bTransOK) THEN
    BEGIN
      inc(j);
      // Déco avant nouvel essai
      FTPDisconnect();
    END;
  UNTIL ((bTransOK) OR (j = MyParams.iFTPNbTry));

  // Si la connection a bien réussie, on envoie le fichier
  IF bTransOK THEN
  BEGIN
    // Ok, réussi, on réinitialise le compteur
    iNbErreurFTP := 0;

    TRY
      // Positionnement dans le dossier du serveur FTP
      FTP.ChangeDir(MyParams.FTPGetFolder);
//      ShowMessage(FTP.RetrieveCurrentDir);
      bTransOK := FTPGetList();

      IF bTransOK THEN
      BEGIN
        FOR i := 0 TO (FTP.DirectoryListing.Count - 1) DO
        BEGIN
          // Si le nom de fichier n'est pas numérique, on ne pourra rien faire dans GENIMPORT, donc on zappe
          IF IsNumeric(ChangeFileExt(FTP.DirectoryListing[i].FileName, '')) THEN
          BEGIN
            iIdFic := StrToInt(ChangeFileExt(FTP.DirectoryListing[i].FileName, ''));
            Que_GetFileInfo.ParamByName('FICID').AsInteger := iIdFic;
            Que_GetFileInfo.Open;

            IF Que_GetFileInfo.RecordCount = 0 THEN
            BEGIN
              bFileToGet := True;
              bNewFile := True;
            END
            ELSE IF Que_GetFileInfo.FieldByName('FIC_FTPDATE').AsDateTime <> FTP.DirectoryListing[i].ModifiedDate THEN
            BEGIN
              bFileToGet := True;
              bNewFile := False;
            END
            ELSE BEGIN
              bFileToGet := False;
              bNewFile := False;
            END;
            Que_GetFileInfo.Close;

            IF bFileToGet THEN
            BEGIN
              sPathFileToGet := IncludeTrailingPathDelimiter(MyParams.sGetFolder) + FTP.DirectoryListing[i].FileName;

              IF FTPGetAFile(FTP.DirectoryListing[i].FileName, sPathFileToGet, FTP.Size(FTP.DirectoryListing[i].FileName)) THEN
              BEGIN
                IbT_InterneModif.StartTransaction;
                TRY
                  // Fichier reçu, on le note dans la base
                  IF bNewFile THEN
                  BEGIN
                    // insert
                    Que_InsertFile.Close;
                    // les infos de l'update
                    Que_InsertFile.ParamByName('FIC_ID').AsInteger := iIdFic;
                    Que_InsertFile.ParamByName('FIC_NOM').AsString := FTP.DirectoryListing[i].FileName;
                    Que_InsertFile.ParamByName('FIC_FTPDATE').AsDateTime := FTP.DirectoryListing[i].ModifiedDate;
                    Que_InsertFile.ParamByName('FIC_STATUT').AsInteger := 1;
                    FileAge(sPathFileToGet, dtMyFileAge);
                    Que_InsertFile.ParamByName('FIC_CURDATE').AsDateTime := dtMyFileAge;
                    Que_InsertFile.ParamByName('FIC_PATH').AsString := sPathFileToGet;
                    Que_InsertFile.ParamByName('FIC_SIZE').AsInteger := FTP.DirectoryListing[i].Size;

                    // effectue la query
                    Que_InsertFile.ExecSQL;
                    Que_InsertFile.Close;

                  END
                  ELSE BEGIN
                    // update
                    Que_UpdateFile.Close;
                    // le where
                    Que_UpdateFile.ParamByName('FIC_ID').AsInteger := iIdFic;
                    // les infos de l'update
                    Que_UpdateFile.ParamByName('FIC_FTPDATE').AsDateTime := FTP.DirectoryListing[i].ModifiedDate;
                    Que_UpdateFile.ParamByName('FIC_STATUT').AsInteger := 1;
                    FileAge(sPathFileToGet, dtMyFileAge); //
                    Que_UpdateFile.ParamByName('FIC_CURDATE').AsDateTime := dtMyFileAge;
                    Que_UpdateFile.ParamByName('FIC_PATH').AsString := sPathFileToGet;
                    Que_UpdateFile.ParamByName('FIC_SIZE').AsInteger := FTP.DirectoryListing[i].Size;

                    // effectue la query
                    Que_UpdateFile.ExecSQL;
                    Que_UpdateFile.Close;
                  END;
                  IbT_InterneModif.Commit;

                EXCEPT
                  ON E: Exception DO
                  BEGIN
                    LogAction('ERREUR INSERTION DANS BASE INTERNE : ' + E.Message, 0);
                    IbT_InterneModif.Rollback;
                  END;
                END;
              END;
            END;
          END;
        END;

      END;
    EXCEPT
      ON E: Exception DO
      BEGIN
        LogAction('ERREUR FTP : ' + E.Message, 1);
      END;
    END;
  END
  ELSE
  BEGIN
    // Erreur fatale, on compte le nombre de fois où l'on a raté
    iNbErreurFTP := iNbErreurFTP + 1;

    // On est sorti pour cause de 3 essais échoué
    LogAction('ERREUR - ' + IntToStr(MyParams.iFTPNbTry) + ' Echecs successifs de connection au FTP', 1);
  END;

  IF iNbErreurFTP >= MyParams.iFTPNbTry THEN
  BEGIN
    LogAction('ERREUR - ' + IntToStr(MyParams.iFTPNbTry) + ' Echecs successifs de connection au FTP', 0);
    iNbErreurFTP := 0;
  END;

  LogAction('/***************************************************/', 2);

END;

FUNCTION TDm_Common.ParamValides: boolean;
BEGIN
  TRY
    Result := (MyGenParam.iPseudoLivr <> 0);
    Result := Result AND (MyGenParam.iTarif <> 0);
    Result := Result AND (MyGenParam.iProjet <> 0);
    Result := Result AND (MyGenParam.iProjet <> 0);
    Result := Result AND (MyGenParam.iMagID <> 0);
    Result := Result AND (MyGenParam.iVendeur <> 0);
    Result := Result AND (MyGenParam.iTypeCDV <> 0);
  EXCEPT
    Result := False;
  END;
END;

FUNCTION TDm_Common.DBReconnect(bVerifParams: Boolean = True): boolean;
VAR
  sPrm: STRING;
BEGIN
  // Déconnection de la DB
  Ginkoia.Disconnect;

  Ginkoia.Database := MyParams.sDBPath;
  TRY
    TRY
      DBInterne.Close;
      DBInterne.Database := MyParams.sDBInterne;
      DBInterne.Connect;
    EXCEPT
      ON e: Exception DO
      BEGIN
        LogAction('Erreur de connection à la base de donnée' + MyParams.sDBInterne, 0);
      END;
    END;

    Ginkoia.Connect;

    IF Ginkoia.Connected THEN
    BEGIN
      Que_Magasins.Open;
      Que_Postes.Open;

      // Récupération des paramètres de la base
      MyGenParam.iPseudoLivr := GetParamInteger(200);
      MyGenParam.iTarif := GetParamInteger(201);
      MyGenParam.iProjet := GetParamInteger(202);
      MyGenParam.iMagID := GetParamMag(203);
      MyGenParam.iVendeur := GetParamInteger(204);
      MyGenParam.iTypeCDV := GetParamInteger(205);

      // Récup du chemin d'accès aux factures à envoyer
      sPrm := GetParamString(302);
      IF sPrm <> '' THEN
      BEGIN
        MyParams.sToSendFolder := IncludeTrailingPathDelimiter(sPrm);
        ForceDirectories(MyParams.sToSendFolder);
      END
      ELSE
      BEGIN
        MyParams.sToSendFolder := IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'Facture');
        ForceDirectories(MyParams.sToSendFolder);
      END;
      MyParams.sSentFolder := IncludeTrailingPathDelimiter(MyParams.sToSendFolder + 'OK');
      ForceDirectories(MyParams.sSentFolder);

      IF bVerifParams THEN
      BEGIN
        // Vérification des paramètres
        Result := ParamValides;
      END
      ELSE
      BEGIN
        // Vérification des paramètres
        Result := True;
      END;

      IF NOT Result THEN
        LogAction('Erreur de paramétrage, impossible de compléter le chargement', 0);

    END
    ELSE BEGIN
      // Erreur, a gerer
      Result := False;
      LogAction('Erreur de connection à la base de donnée' + MyParams.sDBPath, 0);
    END;
  EXCEPT
    Result := False;
    Ginkoia.Disconnect;
    DBInterne.Disconnect;
    LogAction('Erreur de connection à la base de donnée' + MyParams.sDBPath, 0);
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

FUNCTION TDm_Common.GetAdresseXML(ACursor: IXMLCursor): stUneAdresse;
BEGIN
  Result.sAdr_Civ := UpperCase(ACursor.GetValue('CIV'));
  Result.sAdr_Nom := UpperCase(ACursor.GetValue('Nom'));
  Result.sAdr_Prenom := UpperCase(ACursor.GetValue('Prénom'));
  Result.sAdr_Ste := UpperCase(ACursor.GetValue('Ste'));
  Result.sAdr_Adr1 := UpperCase(ACursor.GetValue('Adr1'));
  Result.sAdr_Adr2 := UpperCase(ACursor.GetValue('Adr2'));
  Result.sAdr_Adr3 := UpperCase(ACursor.GetValue('Adr3'));
  Result.sAdr_CP := ACursor.GetValue('cp');
  Result.sAdr_Ville := UpperCase(ACursor.GetValue('ville'));
  Result.sAdr_Pays := UpperCase(ACursor.GetValue('pays'));
  Result.sAdr_PaysISO := UpperCase(ACursor.GetValue('paysISO'));
  Result.sAdr_Tel := ACursor.GetValue('Tel');
  Result.sAdr_Gsm := ACursor.GetValue('Gsm');
  Result.sAdr_Fax := ACursor.GetValue('Fax');

  IF Result.sAdr_Ste <> '' THEN
  BEGIN
    Result.sAdr_Adr2 := Result.sAdr_Adr1 + ' ' + Result.sAdr_Adr2;
    Result.sAdr_Adr1 := Result.sAdr_Ste;
  END;
END;

PROCEDURE TDm_Common.ProcessXMLFiles;
BEGIN
  // le but ici est de boucler sur tous les fichiers reçus, puis de les parser
  Que_GetFileATraiter.Open;
  Que_GetFileATraiter.First;
  WHILE NOT Que_GetFileATraiter.Eof DO
  BEGIN
    IbT_Modif.StartTransaction;
    IF TraiterFichierXML(Que_GetFileATraiter) THEN
    BEGIN
      IbT_Modif.Commit;
      LogAction('TRAITEMENT FICHIER OK : ' + Que_GetFileATraiter.FieldByName('FIC_NOM').AsString, 4);
    END
    ELSE BEGIN
      IbT_Modif.Rollback; // Annulation
      LogAction('ERREUR TRAITEMENT FICHIER : ' + Que_GetFileATraiter.FieldByName('FIC_NOM').AsString, 0);
    END;
    Que_GetFileATraiter.Next;
  END;
  // fermeture de la query
  Que_GetFileATraiter.Close;

  // A-t-on eu une erreur dans le traitement
  IF iNbLog > 0 THEN
  BEGIN
    // Envoi du log
  END;
END;

FUNCTION TDm_Common.TraiterFichierXML(AQuery: TIBOQuery): boolean;
VAR
  //  IdClient: integer;
  IdCde, KtbCde: integer;
  sMess: STRING;
  MyCde: stUneCommande;
  DveID: Integer;
BEGIN
  Result := False;
  TRY
    TRY
      WITH AQuery DO
      BEGIN
        // 1 - on parse le fichier
        MyCde := ParseXMLFile(FieldByName('FIC_PATH').AsString);
        MyCde.iCdeIntranetID := FieldByName('FIC_ID').AsInteger;

        // Modif des adresses
        IF (MyCde.stAdrFact.sAdr_Nom <> MyCde.stAdrLiv.sAdr_Nom) THEN
        BEGIN
          // Dans le cas d'une adresse de livraison différente de l'adresse de facturation, on va transférer le nom dans l'adresse1, et faire glisser le tout

          IF MyCde.stAdrLiv.sAdr_Adr3 <> '' THEN
            MyCde.stAdrLiv.sAdr_Adr3 := MyCde.stAdrLiv.sAdr_Adr2 + ' ' + MyCde.stAdrLiv.sAdr_Adr3
          ELSE
            MyCde.stAdrLiv.sAdr_Adr3 := MyCde.stAdrLiv.sAdr_Adr2;

          MyCde.stAdrLiv.sAdr_Adr2 := MyCde.stAdrLiv.sAdr_Adr1;

          MyCde.stAdrLiv.sAdr_Adr1 := MyCde.stAdrLiv.sAdr_Nom + ' ' + MyCde.stAdrLiv.sAdr_Prenom;
        END;

        IF MyCde.sErreur = '' THEN
        BEGIN
          // 2 - On cherche le client dans ginkoia
          MyCde.iCliID := GetCliID(MyCde);

          // 3 - On cherche le document dans ginkoia
          IF IsDocValide(MyCde.iCdeIntranetID, sMess, KtbCde, IdCde) THEN
          BEGIN
            IF IdCde = 0 THEN
            BEGIN
              // Création du Devis
              DveID := CreateDevis(MyCde);
              // Créditer le compte client
              MajCptClient(MyCde, DveID);
            END
            ELSE BEGIN
              // Mise à jour du BL
              MajBL(IdCde, MyCde);
              // Créditer le compte client
              MajCptClient(MyCde);
            END;
            Result := True;
          END
          ELSE BEGIN
            // Problème avec un fichier
            LogAction(sMess, 0);
          END;
        END;

        // On vide le tableau de la structure...
        Finalize(MyCde.tabLignes);
      END;

    EXCEPT
      ON E: EXception DO
      BEGIN
        Result := False;
      END;
    END;
  FINALLY
    // Quoi qu'il arrive, on met à jour le fichier pour ne pas le traiter
    // Mise à jour du fichier pour indiquer qu'il a été traité
    Que_UpdateStatut.Close;
    // le where
    Que_UpdateStatut.ParamByName('FIC_ID').AsInteger := AQuery.FieldByName('FIC_ID').AsInteger;
    // les infos de l'update
    Que_UpdateStatut.ParamByName('FIC_STATUT').AsInteger := 2;
    // effectue la query
    Que_UpdateStatut.ExecSQL;
    Que_UpdateStatut.Close;

  END;
END;

FUNCTION TDm_Common.ParseXMLFile(sPathFic: STRING): stUneCommande;

VAR
  MyDoc, MyNode, MyNodeCli, MyNodeAdr, MyNodeLines, MyNodeColis: IXMLCursor;
  stCdeEnCours: stUneCommande;
  i: integer;
BEGIN
  // Création du document principal et chargement du fichier xml reçu
  MyDoc := TXMLCursor.Create;

  // Initialisation de l'erreur à vide
  stCdeEnCours.sErreur := '';

  TRY
    MyDoc.Load(sPathFic);

    MyNode := MyDoc.Select('/Commande');

    // Remplissage des infos de commande
    stCdeEnCours.sCdeStatut := UpperCase(MyNode.GetValue('Statut'));

    stCdeEnCours.bCdeDetaxe := (MyNode.GetValue('Export') = '1'); // Gestion de la commande en détaxe, voir comment identifier ce cas
    stCdeEnCours.sCdeNum := MyNode.GetValue('CommandeN');
    stCdeEnCours.sCdeDate := MyNode.GetValue('Date');
    stCdeEnCours.sModeReg := UpperCase(MyNode.GetValue('ModeRéglement'));
    stCdeEnCours.sDateReg := MyNode.GetValue('DatePaiement');
    stCdeEnCours.fCdeSsTotal := StringToFloat(MyNode.GetValue('SousTotalHT'));
    stCdeEnCours.fCdeTotHT := StringToFloat(MyNode.GetValue('TotalHT'));
    stCdeEnCours.fCdeFPHT := stCdeEnCours.fCdeTotHT - stCdeEnCours.fCdeSsTotal;
    stCdeEnCours.fCdeFPTTC := StringToFloat(MyNode.GetValue('FraisPortTTC'));

    stCdeEnCours.fCdeRemise := StringToFloat(MyNode.GetValue('Remise'));
    stCdeEnCours.fCdeTVA := StringToFloat(MyNode.GetValue('TVAN')) + StringToFloat(MyNode.GetValue('TVAR'));
    stCdeEnCours.fCdeTotTTC := StringToFloat(MyNode.GetValue('TotalTTC'));
    stCdeEnCours.fCdeNetAPayer := StringToFloat(MyNode.GetValue('Netpayer'));

    stCdeEnCours.dtDateReg := ISOStrToDate(stCdeEnCours.sDateReg);

    stCdeEnCours.dtCdeDate := ISOStrToDate(stCdeEnCours.sCdeDate);

    // Infos client
    MyNodeCli := MyDoc.Select('/Commande/Client');
    stCdeEnCours.sCliCode := MyNodeCli.GetValue('CodeClient');
    stCdeEnCours.sCliMail := MyNodeCli.GetValue('email');

    // Adresse de livraison
    MyNodeAdr := MyDoc.Select('/Commande/Client/addressLivr');
    stCdeEnCours.stAdrLiv := GetAdresseXML(MyNodeAdr);

    // Adresse de Facturation
    MyNodeAdr := MyDoc.Select('/Commande/Client/addressFact');
    stCdeEnCours.stAdrFact := GetAdresseXML(MyNodeAdr);

    // Colis
    MyNodeColis := MyDoc.Select('/Commande/colis');
    stCdeEnCours.sColiTransp := 'Transport : ' + GetTransporteurLib(UpperCase(MyNodeColis.GetValue('Transporteur')), UpperCase(MyNodeColis.GetValue('numero')), UpperCase(MyNodeColis.GetValue('MagasinRetrait')));

    // Les Lignes -> dans un tableau
    i := 1;
    SetLength(stCdeEnCours.tabLignes, 1); // donc taille = 1
    WITH stCdeEnCours.tabLignes[0] DO // donc indice 1 (1-1 = 0)
    BEGIN
      sCode := '';
      sDesignation := stCdeEnCours.sCdeNum;
      sTypePx := 'COMMENT';
      fPUBRUT := 0;
      fPUHT := 0;
      fPUTTC := 0;
      fPXCREDIT := 0;
      fRemise := 0;
      fQte := 0;
      fHT := 0;
    END;

    MyNodeLines := MyDoc.Select('/Commande/lignes/ligne');

    MyNodeLines.First;
    WHILE NOT MyNodeLines.EOF DO
    BEGIN
      inc(i); // premier passage : i=2

      SetLength(stCdeEnCours.tabLignes, i); // donc taille = 2

      WITH stCdeEnCours.tabLignes[i - 1] DO // donc indice 1 (2-1 = 1)
      BEGIN
        sCode := MyNodeLines.GetValue('Code');
        sDesignation := UpperCase(MyNodeLines.GetValue('Designation'));
        sTypePx := UpperCase(MyNodeLines.GetValue('TYPEPRIX'));
        fPUBRUT := StringToFloat(MyNodeLines.GetValue('PUBRUT'));
        fPUHT := StringToFloat(MyNodeLines.GetValue('PUHT'));
        fPUTTC := StringToFloat(MyNodeLines.GetValue('PUTTC'));
        fPXCREDIT := StringToFloat(MyNodeLines.GetValue('PXCREDIT'));
        fRemise := StringToFloat(MyNodeLines.GetValue('Remise'));
        fQte := StringToFloat(MyNodeLines.GetValue('Qte'));
        fHT := StringToFloat(MyNodeLines.GetValue('HT'));

        // Pour le prix brut, pour l'instant, il est mit = au prix TTC si vide
        IF fPUBRUT = 0 THEN
          fPUBRUT := fPUTTC;

        IF sCode = 'BAF' THEN
        BEGIN
          // TODO : Bon achat, a voir comment on gère quand plus d'infos sur la méthode.
          // Erreur, article non trouvé
          stCdeEnCours.sErreur := 'ERREUR - Bon achat non gérés pour l''instant = ' + sCode;
          BREAK;
        END;

        // Récupération des informations concernant l'article (prix achat, artid, couleur, taille, tva...)
        stArticle := GetArticleInfos(sCode);

        IF stArticle.iArtId = 0 THEN
        BEGIN
          // Erreur, article non trouvé
          stCdeEnCours.sErreur := 'ERREUR - Article non trouvé, code = ' + sCode;
          BREAK;
        END;

      END;

      MyNodeLines.Next;
    END;

    // Gestion des frais de port, ajout d'une ligne de commande manuellement
    inc(i);

    SetLength(stCdeEnCours.tabLignes, i);

    WITH stCdeEnCours.tabLignes[i - 1] DO
    BEGIN
      sCode := 'FP';
      sDesignation := 'FRAIS DE PORT';
      sTypePx := 'PV';
      fPXCREDIT := 0;
      fRemise := 0;
      fQte := 1;
      fHT := stCdeEnCours.fCdeFPHT;
      stArticle.iArtId := MyGenParam.iPseudoLivr;
      stArticle.iArfId := GetIdByLib('ARTREFERENCE', 'ARF_ID', 'ARF_ARTID', IntToStr(MyGenParam.iPseudoLivr));
      stArticle.iTgfId := 0;
      stArticle.iCouId := 0;

      stArticle.fTVA := 0;
      IF ((stCdeEnCours.fCdeFPHT <> 0) AND (stCdeEnCours.fCdeFPTTC <> 0)) THEN
        stArticle.fTVA := ArrondiMonetaire(((stCdeEnCours.fCdeFPTTC / stCdeEnCours.fCdeFPHT) - 1) * 100);

      fPUHT := stCdeEnCours.fCdeFPHT;
      fPUTTC := stCdeEnCours.fCdeFPTTC;
      fPUBRUT := fPUTTC;
    END;
  EXCEPT
    ON E: Exception DO
    BEGIN
      // erreur chargement du fichier XML
      // Initialisation de l'erreur à vide
      stCdeEnCours.sErreur := 'ERREUR - Exception lors de l''interprétation du fichier XML' + EOL + E.MEssage;
    END;
  END;

  // Si on a eu un problème -> LOG
  IF stCdeEnCours.sErreur <> '' THEN
    Logaction(stCdeEnCours.sErreur, 1);

  Result := stCdeEnCours;

  //
END;

//FUNCTION TDm_Common.QueryVersFile(AQuery: TIB_Query;
//  AFileName: STRING): boolean;
//  FUNCTION TDm_Common.QueryGetEntete(AQuery: TIB_Query): STRING;
//  VAR
//    i: integer;
//    sRet: STRING;
//  BEGIN
//    sRet := '';
//
//    FOR i := 0 TO AQuery.FieldCount - 1 DO
//    BEGIN
//      IF i = 0 THEN
//        sRet := AQuery.Fields[i].FieldName
//      ELSE
//        sRet := sRet + ';' + AQuery.Fields[i].FieldName;
//    END;
//
//    Result := sRet;
//  END;
//
//VAR
//  tsExport: TStrings;
//  i, j: integer;
//  sLig: STRING;
//  sTmp: STRING;
//  sChp: STRING;
//BEGIN
//  tsExport := TStringList.Create();
//  TRY
//    // Créer l'entete
//    tsExport.Add(QueryGetEntete(AQuery));
//    j := 0;
//    WHILE NOT AQuery.Eof DO
//    BEGIN
//      // Affichage
//      inc(j);
//      LogAction('Traitement du fichier ' + AFileName + ' ligne ' + IntToStr(j) + '/' + IntToStr(AQuery.RecordCount));
//
//      // Extraction
//      sLig := '';
//      FOR i := 0 TO AQuery.FieldCount - 1 DO
//      BEGIN
//        IF i = 0 THEN
//          sLig := sChp
//        ELSE
//          sLig := sLig + ';' + sChp;
//      END;
//      tsExport.Add(sLig);
//
//      AQuery.Next;
//    END;
//    tsExport.SaveToFile(MyParams.sToSendFolder + AFileName);
//
//    tsExport.Clear;
//
//    LogAction('OK - Export du fichier ' + AFileName + ' terminé');
//
//    result := true;
//  EXCEPT
//    ON E: Exception DO
//    BEGIN
//      LogAction('ERREUR - Export du fichier ' + AFileName + ' echoué : ' + E.Message);
//      result := false;
//    END;
//  END;
//  // Libération
//  tsExport.Free;
//
//END;

procedure TDm_Common.FTPAfterClientLogin(Sender: TObject);
begin
  LogAction('OK - Serveur : ' + MyParams.sFTPHost + ' -> Connection réussie', 2);
end;

FUNCTION TDm_Common.FTPConnect: Boolean;
BEGIN

  Result := False;

  IF (MyParams.sFTPHost <> '') THEN
  BEGIN
    // Au cas ou...
    IF FTP.Connected THEN
    BEGIN
      // Dans le doute
      FTP.Abort;
      FTP.Disconnect;
    END;

    FTP.Host := MyParams.sFTPHost;
    FTP.Username := MyParams.sFTPUser;
    FTP.Password := MyParams.sFTPPwd;
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
        LogAction('ERREUR - Serveur : ' + MyParams.sFTPHost + ' -> Connection échoué', 1);
      END;
    END;
  END
  ELSE BEGIN
    // Host mal lu
    LogAction('ERREUR - Serveur  non renseigné dans l''Ini, vérifiez votre configuration.', 1);
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
    IF not FTP.Connected THEN //Pas connecté ?
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
        FTP.List(FolderList,'*.*', False); //Lister les fichiers
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
  sListExtensions := UpperCase(';' + MyParams.FTPSendExtention + ';');
  iRes := FindFirst(MyParams.sToSendFolder + '*.*', faAnyFile, MyFile);
  WHILE iRes = 0 DO
  BEGIN
    sExtension := ExtractFileExt(MyFile.Name);
    Delete(sExtension, 1, 1);
    sExtension := UpperCase(';' + sExtension + ';');
    // On exclu de la liste le dossier . et .. et les fichiers dont l'extension n'est pas à traiter
    IF ((MyFile.Name <> '.') AND (MyFile.Name <> '..')) AND (Pos(sExtension, sListExtensions) > 0) THEN
    BEGIN
      // Traitement du fichier
      IF MyParams.FTPSendFolder <> '' THEN
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
      LogAction('INFO - Réception fichier ' + AFileName + ' : Essai ' + IntToStr(j + 1) + '/' + IntToStr(MyParams.iFTPNbTry), 2);
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
        IF MyParams.bDelFTPFiles THEN
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
  UNTIL ((bTransOK) OR (j = MyParams.iFTPNbTry));

  Result := bTransOK;
END;

FUNCTION TDm_Common.FTPGetList: boolean;
BEGIN
  Result := False;
  TRY
    FTP.List(Str_FTPList.Strings, '*.xml', False);

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
    sFolder := MyParams.FTPSendFolder;
    // On teste s'il existe déjà
//    IF FTPFileExists(sFolder, sFileSend) THEN
//    BEGIN
//     LogAction('INFO - ' + sFolder + sFile + ' : Fichier existant, sera ecrasé', 2);
//    END;

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
    LogAction('INFO - Essai ' + IntToStr(i + 1) + '/' + IntToStr(MyParams.iFTPNbTry), 2);
    bTransOK := FTPConnect();
    // Si la connection a bien réussie, on envoie le fichier
    IF bTransOK THEN
    BEGIN

      sFileSend := MyParams.sToSendFolder + sFile;
      sFileReceive := MyParams.sSentFolder + sFile;

      // Positionnement dans le bon dossier sur le site FTP.
      FTP.ChangeDir(MyParams.FTPSendFolder);
      LogAction('OK - Positionnement dans ' + MyParams.FTPSendFolder, 2);

      // Envoi du fichier
      bTransOK := FTPPutFile(sFileSend);

      // Si l'envoi s'est bien passé, on teste le transfert par un controle de crc.
      IF bTransOK THEN
      BEGIN
        IF MyParams.FTPValidEnvoi THEN
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

  UNTIL ((bTransOK) OR (i = MyParams.iFTPNbTry));

  IF NOT (bTransOK) THEN
  BEGIN
    // On est sorti pour cause de 3 essais échoué
    LogAction('ERREUR - ' + IntToStr(MyParams.iFTPNbTry) + ' Echecs successifs, Fichier non transmis', 1);
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
  LogAction('OK - Serveur : ' + MyParams.sFTPHost + ' -> Connection réussie', 2);
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

  IF MyParams.sSMTPHost = '' THEN
  BEGIN
    LogAction('Pas de SMTP renseigné, impossible d''envoyer un E-Mail', 2);
    Result := False;
    EXIT;
  END;

  IF MyParams.sMailDest = '' THEN
  BEGIN
    LogAction('Pas de destinataire renseigné, impossible d''envoyer un E-Mail', 2);
    Result := False;
    EXIT;
  END;

  IF MyParams.sMailExp = '' THEN
  BEGIN
    LogAction('Pas d''expéditeur renseigné, impossible d''envoyer un E-Mail', 2);
    Result := False;
    EXIT;
  END;

  SMTP.Host := MyParams.sSMTPHost;
  SMTP.Port := StrToInt(MyParams.sSMTPPort);

  IF MyParams.sSMTPUser <> '' THEN
  BEGIN
    SMTP.AuthType := satDefault;
    SMTP.Username := MyParams.sSMTPUser;
    SMTP.Password := MyParams.sSMTPPwd;
  END
  ELSE BEGIN
    SMTP.AuthType := satNone;
  END;

  idMsgSend.Clear;
  idMsgSend.Body.Clear;
  idMsgSend.From.Text := MyParams.sMailExp;

  idMsgSend.Recipients.EMailAddresses := MyParams.sMailDest;
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

FUNCTION TDm_Common.GetCliID(stCdeEnCours: stUneCommande): integer;

  FUNCTION StructAdrVersStrucCli(ACliID: integer;
    AStrucAdr: stUneAdresse; AEmail: STRING): TUnClient;
  VAR
    sAdr: STRING;
  BEGIN

    sAdr := Adr123VersAdr(AStrucAdr.sAdr_Adr1, AStrucAdr.sAdr_Adr2, AStrucAdr.sAdr_Adr3);

    Result := AdrCliVersStructure(ACliID, sAdr, AStrucAdr.sAdr_Ville, AStrucAdr.sAdr_CP, AStrucAdr.sAdr_Pays, AStrucAdr.sAdr_Tel, AStrucAdr.sAdr_Fax, AStrucAdr.sAdr_Gsm, AEmail);

  END;

  FUNCTION QueAdresseVersStrucCli(ACliId: integer;
    AQuery: TIBOQuery): TUnClient;
  BEGIN
    //
    WITH AQuery DO
    BEGIN
      Close;
      ParamByName('CLTID').AsInteger := ACliId;
      Open;
      Result := AdrCliVersStructure(ACliId, FieldByName('ADR_LIGNE').AsString, FieldByName('VIL_NOM').AsString, FieldByName('VIL_CP').AsString, FieldByName('PAY_NOM').AsString, FieldByName('ADR_TEL').AsString, FieldByName('ADR_FAX').AsString, FieldByName('ADR_GSM').AsString, FieldByName('ADR_EMAIL').AsString);
      Close;
    END;

  END;

VAR
  iCliId, iPayId: integer;

  CltAdrLivr, CltAdrFact: TUnClient;
  CltSvg: TUnClient;
BEGIN
  iCliID := 0;

  Que_SelGenImport.Close;
  TRY
    // Récupère l'id d'un client ou le crée s'il n'existe pas, et met à jour l'adresse au besoin
    Que_SelGenImport.ParamByName('KTBID').AsInteger := Ktb('CLTCLIENT');
    Que_SelGenImport.ParamByName('REFID').AsInteger := StrToInt(stCdeEnCours.sCliCode);
    Que_SelGenImport.Open;

    IF Que_SelGenImport.Eof THEN
    BEGIN
      // non trouvé, on cherche par Email
      Que_GetClientByEMail.Close;
      Que_GetClientByEMail.ParamByName('EMAIL').AsString := stCdeEncours.sCliMail;
      Que_GetClientByEMail.Open;

      Que_GetClientByEMail.First;
      IF NOT Que_GetClientByEMail.Eof THEN
      BEGIN
        // Trouvé, renvoi l'ID
        iCliID := Que_GetClientByEMail.FieldByName('CLT_ID').AsInteger;
      END;
      Que_GetClientByEMail.Close;
    END
    ELSE BEGIN
      iCliID := Que_SelGenImport.FieldByName('IMP_GINKOIA').AsInteger;
    END;
    Que_SelGenImport.Close;

    TRY
      iPayID := GetOrCreatePayID(stCdeEnCours.stAdrLiv.sAdr_Pays);
      // PR_CRER_CLIENT permet de mettre à jour le client ou de le créer si besoin, s'occupe également de faire
      // l'enreg dans GenIMPORT
      Que_CreerClient.Close;
      Que_CreerClient.ParamByName('IDREF').AsInteger := StrToInt(stCdeEncours.sCliCode);
      Que_CreerClient.ParamByName('IDGINKOIA').AsInteger := iCliID;
      Que_CreerClient.ParamByName('MAGID').AsInteger := MyParams.iMagID;
      Que_CreerClient.ParamByName('NOM').AsString := stCdeEnCours.stAdrFact.sAdr_Nom;
      Que_CreerClient.ParamByName('PRENOM').AsString := stCdeEnCours.stAdrFact.sAdr_Prenom;
      Que_CreerClient.ParamByName('ADR').AsString := Adr123VersAdr(stCdeEnCours.stAdrLiv.sAdr_Adr1, stCdeEnCours.stAdrLiv.sAdr_Adr2, stCdeEnCours.stAdrLiv.sAdr_Adr3);
      Que_CreerClient.ParamByName('CP').AsString := stCdeEnCours.stAdrLiv.sAdr_CP;
      Que_CreerClient.ParamByName('VILLE').AsString := stCdeEnCours.stAdrLiv.sAdr_Ville;
      Que_CreerClient.ParamByName('PAYS').AsInteger := iPayId;
      Que_CreerClient.ParamByName('EMAIL').AsString := stCdeEncours.sCliMail;
      Que_CreerClient.ParamByName('TEL').AsString := stCdeEnCours.stAdrLiv.sAdr_Tel;
      Que_CreerClient.Open;
      iCliId := Que_CreerClient.FieldByName('CLT_ID').AsInteger;
    EXCEPT
      ON e: exception DO
      BEGIN
        LogAction('Erreur à la sélection du client suivant : ' + stCdeEncours.sCliMail, 0);
        LogAction('Libellé de l''erreur : ' + E.Message, 0);
      END;

    END;
    Que_CreerClient.Close;

    // FC 06/04/2009 : Annulé suite demande stan
//    // Si adresse de livraison différente de l'adresse de facturation, on met dans l'adresse de livraison le

//    // Maj de l'adresse de livraison si besoin
//    // Envoi vers structure de son adresse
//    CltAdrLivr := StructAdrVersStrucCli(iCliId, stCdeEnCours.stAdrLiv, stCdeEncours.sCliMail);
//    CltSvg := QueAdresseVersStrucCli(iCliID, Que_GetCliAdrLivr);
//    MajClient(CltAdrLivr, CltSvg, 1);
//
//    // Maintenant, MAJ de l'adr de facturation (si différente de l'adr de livraison
//    CltAdrFact := StructAdrVersStrucCli(iCliId, stCdeEnCours.stAdrFact, stCdeEncours.sCliMail);
//    CltSvg := QueAdresseVersStrucCli(iCliID, Que_GetCliAdrFact);
//    IF NOT IsIdem(CltAdrLivr, CltAdrFact) THEN
//      MajClient(CltAdrFact, CltSvg, 2);

    // FC 06/04/2009 : Modif demandée par Stan : on stock dans l'adresse normale l'adresse de factureation, et on ignore l'adresse de livraison
    // car on s'en fout en fait.
    CltAdrLivr := StructAdrVersStrucCli(iCliId, stCdeEnCours.stAdrLiv, stCdeEncours.sCliMail);
    CltAdrFact := StructAdrVersStrucCli(iCliId, stCdeEnCours.stAdrFact, stCdeEncours.sCliMail);
    CltSvg := QueAdresseVersStrucCli(iCliID, Que_GetCliAdrLivr);
    MajClient(CltAdrFact, CltSvg, 1);

  EXCEPT
    ON E: Exception DO
    BEGIN
      iCliID := 0;
      LogAction('Erreur à la sélection du client suivant : ' + stCdeEncours.sCliMail, 0);
      LogAction('Libellé de l''erreur : ' + E.Message, 0);
    END;
  END;

  Result := iCliID;
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

FUNCTION TDm_Common.IsDocValide(AidCde: integer; VAR AErrMess: STRING;
  VAR ADocType, AIdGinkoia: integer): boolean;

//VAR
//  bFound: boolean;
BEGIN
  // Init du résultat, avec l'erreur par défaut
  Result := False;
  AErrMess := 'Erreur inconnue lors de la recherche du document';

  // On cherche dans genimport un BL
  AIdGinkoia := GenImportGetId(AidCde, Ktb('NEGBL'));
  IF AIdGinkoia > 0 THEN
  BEGIN
    ADocType := Ktb('NEGBL');
    AErrMess := '';
    Result := True
  END
  ELSE BEGIN
    // On cherche dans genimport un devis
    AIdGinkoia := GenImportGetId(AidCde, Ktb('NEGDEVIS'));
    IF AIdGinkoia > 0 THEN
    BEGIN
      // Devis trouvé : Erreur
      ADocType := Ktb('NEGDEVIS');
      AErrMess := 'Erreur : Devis existant pour cette commande, traitement annulé';
    END
    ELSE BEGIN
      // On cherche dans genimport une facture
      AIdGinkoia := GenImportGetId(AidCde, Ktb('NEGFACTURE'));
      IF AIdGinkoia > 0 THEN
      BEGIN
        // Facture trouvée : ERREUR
        ADocType := Ktb('NEGFACTURE');
        AErrMess := 'Erreur : Facture existante pour cette commande, traitement annulé';
      END
      ELSE BEGIN
        // Ni BL, ni facture : ok, on peut créer
        ADocType := Ktb('NEGDEVIS');
        AErrMess := '';
        Result := True;

      END;
    END;
  END;

  // On vérifie l
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

FUNCTION TDm_Common.CreateDevis(ACde: stUneCommande): Integer;
VAR
  iDveID: INTEGER;
  tabMontant: ARRAY OF stMontant;
  i, j: integer;
  fPxA: double;
BEGIN
  Result := 0;

  // Récup d'un ID
  iDveID := NewGenImport('NEGDEVIS', ACde.iCdeIntranetID); // Récupération d'un K pour ce devis, avec un genimport

  Que_CreerDevis.Close;

  // Infos devis
  Que_CreerDevis.ParamByName('DVE_ID').AsInteger := iDveID;
  Que_CreerDevis.ParamByName('DVE_NUMERO').AsString := ACde.sCdeNum;

  // Projet
  Que_CreerDevis.ParamByName('DVE_NPJID').AsInteger := MyGenParam.iProjet;

  Que_CreerDevis.ParamByName('DVE_MAGID').AsInteger := MyGenParam.iMagID;
  Que_CreerDevis.ParamByName('DVE_USRID').AsInteger := MyGenParam.iVendeur;

  // Client
  Que_CreerDevis.ParamByName('DVE_CLTID').AsInteger := ACde.iCliID;

  // Adresse
  WITH ACde.stAdrLiv DO
  BEGIN
    Que_CreerDevis.ParamByName('DVE_CLTNOM').AsString := ACde.stAdrfact.sAdr_Nom;
    Que_CreerDevis.ParamByName('DVE_CLTPRENOM').AsString := ACde.stAdrfact.sAdr_Prenom;
    Que_CreerDevis.ParamByName('DVE_ADRLIGNE').AsString := Adr123VersAdr(sAdr_Adr1, sAdr_Adr2, sAdr_Adr3);
    Que_CreerDevis.ParamByName('DVE_CIVID').AsInteger := GetOrCreateCivID(ACde.stAdrfact.sAdr_Civ);
    Que_CreerDevis.ParamByName('DVE_VILID').AsInteger := GetIDByLib('GENVILLE', 'VIL_ID', 'VIL_NOM', sAdr_Ville);
  END;

  // Date de commande et de règlements respectivement dans date création et livraison
  Que_CreerDevis.ParamByName('DVE_CREATION').AsDateTime := Trunc(ACde.dtCdeDate);
  Que_CreerDevis.ParamByName('DVE_LIVRPREVUE').AsDateTime := Trunc(ACde.dtDateReg);

  // Objet : Commande client provenant du site WEB
  Que_CreerDevis.ParamByName('DVE_OBJET').AsString := 'Commande client provenant du site WEB ';

  // Mode de règlement : VAD si CB, ou Chèque sinon
  IF ACde.sModeReg = 'CHQ' THEN
    Que_CreerDevis.ParamByName('DVE_MRGID').AsInteger := GetIDByLib('GENMODREG', 'MRG_ID', 'MRG_LIB', 'Chèque')
  ELSE
    Que_CreerDevis.ParamByName('DVE_MRGID').AsInteger := GetIDByLib('GENMODREG', 'MRG_ID', 'MRG_LIB', 'VAD');

  IF ACde.dtDateReg > 0 THEN
  BEGIN
    Que_CreerDevis.ParamByName('DVE_CPAID').AsInteger := GetIDByLib('GENCDTPAIEMENT', 'CPA_ID', 'CPA_CODE', '1');
    Que_CreerDevis.ParamByName('DVE_REGLEMENT').AsDateTime := Trunc(ACde.dtDateReg);
    // Compte client
    Que_CreerDevis.ParamByName('DVE_CPTCLT').AsInteger := 1; // 1 si cpte client crédité
    Que_CreerDevis.ParamByName('DVE_WEBACCPT').AsFloat := ACde.fCdeNetAPayer;
  END
  ELSE BEGIN
    Que_CreerDevis.ParamByName('DVE_CPAID').AsInteger := GetIDByLib('GENCDTPAIEMENT', 'CPA_ID', 'CPA_CODE', '2');
    Que_CreerDevis.ParamByName('DVE_REGLEMENT').AsDate := 0;
    // Compte client
    Que_CreerDevis.ParamByName('DVE_CPTCLT').AsInteger := 0; // 1 si cpte client crédité
    Que_CreerDevis.ParamByName('DVE_WEBACCPT').AsFloat := 0;
  END;

  // Gestion des détaxe
  IF ACde.bCdeDetaxe THEN
  BEGIN
    Que_CreerDevis.ParamByName('DVE_DETAXE').AsInteger := 1;
    Que_CreerDevis.ParamByName('DVE_HTWORK').AsInteger := 1;
  END
  ELSE BEGIN
    Que_CreerDevis.ParamByName('DVE_DETAXE').AsInteger := 0;
    Que_CreerDevis.ParamByName('DVE_HTWORK').AsInteger := 0;
  END;

  Que_CreerDevis.ParamByName('DVE_COMENT').AsString := 'Commande : ' + ACde.sCdeNum + ' - IdIntranet : ' + IntToStr(ACde.iCdeIntranetID) + RC + 'Client : ' + ACde.sCliCode + ' - Règlement : ' + ACde.sModeReg + RC + ACde.sColiTransp;
  Que_CreerDevis.ParamByName('DVE_MODELE').AsString := ''; // Vide, vu SM

  fPxA := 0; // init

  // Calcul des prix
  FOR i := 1 TO High(ACde.tabLignes) DO
  BEGIN
    // Cumul des prix d'achat
    fPxA := fPxA + (ACde.tabLignes[i].stArticle.fPxAchat * ACde.tabLignes[i].fQte);

    j := 0;
    WHILE j <= High(tabMontant) DO // High renvoie -1 si tableau vide
    BEGIN
      IF tabMontant[j].fTVA = ACde.tabLignes[i].stArticle.fTVA THEN
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
        tabMontant[j].fMontantTVA := tabMontant[j].fMontantTVA + ((ACde.tabLignes[i].fPUTTC - ACde.tabLignes[i].fPUHT) * ACde.tabLignes[i].fQte);
        tabMontant[j].fMontantHT := tabMontant[j].fMontantHT + (ACde.tabLignes[i].fPUHT * ACde.tabLignes[i].fQte);
      END
      ELSE
      BEGIN
        // On l'a pas trouvé, on ajoute la ligne de tva
        // Augmente le nombre de ligne dans le tableau
        SetLength(tabMontant, (Length(TabMontant) + 1));
        tabMontant[High(tabMontant)].fTVA := ACde.tabLignes[i].stArticle.fTVA;
        tabMontant[High(tabMontant)].fMontantTVA := (ACde.tabLignes[i].fPUTTC - ACde.tabLignes[i].fPUHT) * ACde.tabLignes[i].fQte;
        tabMontant[High(tabMontant)].fMontantHT := ACde.tabLignes[i].fPUHT * ACde.tabLignes[i].fQte;
      END;
    EXCEPT
      ON e: exception DO
      BEGIN
        logaction(E.Message, 4);
      END;
    END;
  END;

  // Marge (= Px Vente HT - Px Achat)
  Que_CreerDevis.ParamByName('DVE_MARGE').AsFloat := ArrondiMonetaire(ACde.fCdeTotHT - fPxA);

  TRY

    FOR i := 1 TO 5 DO // init à 0 des 5 champs TVA
    BEGIN
      Que_CreerDevis.ParamByName('DVE_TVAHT' + IntToStr(i)).AsFloat := 0;
      Que_CreerDevis.ParamByName('DEV_TVATAUX' + IntToStr(i)).AsFloat := 0;
      Que_CreerDevis.ParamByName('DVE_TVA' + IntToStr(i)).AsFloat := 0;
    END;

    // TVA et Montants
    FOR i := 0 TO High(TabMontant) DO
    BEGIN
      Que_CreerDevis.ParamByName('DVE_TVAHT' + IntToStr(i + 1)).AsFloat := ArrondiMonetaire(TabMontant[i].fMontantHT + TabMontant[i].fMontantTVA);
      Que_CreerDevis.ParamByName('DEV_TVATAUX' + IntToStr(i + 1)).AsFloat := TabMontant[i].fTVA;
      Que_CreerDevis.ParamByName('DVE_TVA' + IntToStr(i + 1)).AsFloat := ArrondiMonetaire(TabMontant[i].fMontantTVA);
    END;

  EXCEPT
    ON E: Exception DO
    BEGIN
      LogAction(E.Message, 4);
    END;
  END;

  // Id WEB
  Que_CreerDevis.ParamByName('DVE_IDWEB').AsInteger := ACde.iCdeIntranetID;

  TRY
    Que_CreerDevis.ExecSQL;

    // Lignes du devis
    FOR i := 0 TO High(ACde.tabLignes) DO
    BEGIN
      // Création de la ligne de devis
      CreateDevisLine(iDveID, i, ACde.tabLignes[i]);
    END;
    Result := iDveID
  EXCEPT

    ON E: Exception DO
    BEGIN
      LogAction(E.Message, 4);
      Result := 0;
    END;
  END;
  Que_CreerDevis.Close;

END;

FUNCTION TDm_Common.CreateDevisLine(ADveID, iNumLig: integer; ALine: stLignes): boolean;
VAR
  iTypId: integer;
  iDvlID: integer;

BEGIN
  // Création des lignes de DEVIS
  iDvlID := NewK('NEGDEVISL');
  Que_CreerDevisLigne.Close;

  Que_CreerDevisLigne.ParamByName('DVL_ID').AsInteger := iDvlID;
  Que_CreerDevisLigne.ParamByName('DVL_DVEID').AsInteger := aDveID;

  IF ALine.sTypePx = 'COMMENT' THEN
  BEGIN
    // Cas d'un commentaire, on traite différement
    Que_CreerDevisLigne.ParamByName('DVL_NOM').AsString := '000175000000000';

    Que_CreerDevisLigne.ParamByName('DVL_USRID').AsInteger := MyGenParam.iVendeur;

    // Commentaire = N° de commande, stockée dans sDesignation
    Que_CreerDevisLigne.ParamByName('DVL_COMENT').AsString := ALine.sDesignation;
    Que_CreerDevisLigne.ParamByName('DVL_LINETIP').AsInteger := 2; // 0 dans le cas d'une ligne normale, 2 pour un commentaire

    // Tout à 0
    Que_CreerDevisLigne.ParamByName('DVL_ARTID').AsInteger := 0;
    Que_CreerDevisLigne.ParamByName('DVL_TGFID').AsInteger := 0;
    Que_CreerDevisLigne.ParamByName('DVL_COUID').AsInteger := 0;
    Que_CreerDevisLigne.ParamByName('DVL_QTE').AsInteger := 0;
    Que_CreerDevisLigne.ParamByName('DVL_PXBRUT').AsInteger := 0;
    Que_CreerDevisLigne.ParamByName('DVL_PXNET').AsInteger := 0;
    Que_CreerDevisLigne.ParamByName('DVL_PXNN').AsInteger := 0;
    Que_CreerDevisLigne.ParamByName('DVL_TYPID').AsInteger := 0;
    Que_CreerDevisLigne.ParamByName('DVL_TVA').AsInteger := 0;
  END
  ELSE BEGIN
    // 000225000000000 avec numérotation croissante à chaque ligne
    Que_CreerDevisLigne.ParamByName('DVL_NOM').AsString := '000' + IntToStr(225000000000 + iNumLig);

    // Infos
    Que_CreerDevisLigne.ParamByName('DVL_USRID').AsInteger := MyGenParam.iVendeur;
    Que_CreerDevisLigne.ParamByName('DVL_COMENT').AsString := ALine.sDesignation;
    Que_CreerDevisLigne.ParamByName('DVL_LINETIP').AsInteger := 0; // 0 dans le cas d'une ligne normale, 2 pour un commentaire

    // GENTYPCDV
    IF ALine.sTypePx = 'PS' THEN
      iTypId := GetIdByLib('GENTYPCDV', 'TYP_ID', 'TYP_COD', '2', ' AND TYP_CATEG = 5') // Prix soldé
    ELSE IF ALine.sTypePx = 'PP' THEN
      iTypId := GetIdByLib('GENTYPCDV', 'TYP_ID', 'TYP_COD', '3', ' AND TYP_CATEG = 5') // Prix promo
    ELSE IF ALine.sTypePx = 'PD' THEN
      iTypId := GetIdByLib('GENTYPCDV', 'TYP_ID', 'TYP_COD', '1', ' AND TYP_CATEG = 5') // Prix déstocké = prix normal : cf Bruno
    ELSE
      iTypId := GetIdByLib('GENTYPCDV', 'TYP_ID', 'TYP_COD', '1', ' AND TYP_CATEG = 5'); // Autres = Prix normal

    Que_CreerDevisLigne.ParamByName('DVL_TYPID').AsInteger := iTypId;

    // Identifier l'article
    Que_CreerDevisLigne.ParamByName('DVL_ARTID').AsInteger := ALine.stArticle.iArtId;
    Que_CreerDevisLigne.ParamByName('DVL_TGFID').AsInteger := ALine.stArticle.iTgfId;
    Que_CreerDevisLigne.ParamByName('DVL_COUID').AsInteger := ALine.stArticle.iCouId;
    Que_CreerDevisLigne.ParamByName('DVL_TVA').AsFloat := ALine.stArticle.fTVA;

    // Qté, prix
    Que_CreerDevisLigne.ParamByName('DVL_QTE').AsFloat := ALine.fQte;
    Que_CreerDevisLigne.ParamByName('DVL_PXBRUT').AsFloat := ArrondiMonetaire(ALine.fPUBRUT); // PUBRUT
    Que_CreerDevisLigne.ParamByName('DVL_PXNET').AsFloat := ArrondiMonetaire(ALine.fQte * ALine.fPUTTC); // Px HT (PUHT*Qté)
    Que_CreerDevisLigne.ParamByName('DVL_PXNN').AsFloat := ArrondiMonetaire(ALine.fPUTTC); // PUHT
  END;

  Que_CreerDevisLigne.ExecSQL;

  Que_CreerDevisLigne.Close;

  Result := True;
END;

FUNCTION TDm_Common.GetArticleInfos(sCodeBar: STRING): stArticleInfos;
BEGIN
  Que_GetArtInfos.Close;
  Que_GetArtInfos.ParamByName('CBICB').AsString := sCodeBar;
  Que_GetArtInfos.ParamByName('MAGID').AsInteger := MyParams.iMagID;
  TRY
    Que_GetArtInfos.Open;
    Result.iArfId := Que_GetArtInfos.FieldByName('ARF_ID').AsInteger;
    Result.iArtId := Que_GetArtInfos.FieldByName('ARF_ARTID').AsInteger;
    Result.iTgfId := Que_GetArtInfos.FieldByName('CBI_TGFID').AsInteger;
    Result.iCouId := Que_GetArtInfos.FieldByName('CBI_COUID').AsInteger;
    Result.fTVA := Que_GetArtInfos.FieldByName('TVA_TAUX').AsFloat;
    Result.fPxAchat := Que_GetArtInfos.FieldByName('PXACHAT').AsFloat;
  EXCEPT
    ON E: Exception DO
    BEGIN
      Result.iArfId := 0;
      Result.iArtId := 0;
      Result.iTgfId := 0;
      Result.iCouId := 0;
      Result.fTVA := 0;
      Result.fPxAchat := 0;
    END;
  END;
  Que_GetArtInfos.Close;
END;

FUNCTION TDm_Common.MajBL(AIdGinkoia: integer;
  ACde: stUneCommande): Boolean;
BEGIN
  Result := True;
  TRY
    Que_MajBL.Close;
    Que_MajBL.ParamByName('BLEREGLEMENT').AsDateTime := ACde.dtDateReg;
    Que_MajBL.ParamByName('BLECPAID').AsInteger := GetIDByLib('GENCDTPAIEMENT', 'CPA_ID', 'CPA_CODE', '1');
    Que_MajBL.ParamByName('BLEID').AsInteger := AIdGinkoia;
    // TODO voir SM car les CPTCLT et WEBACCPT n'existe pas dans les BL, voir ce que l'on fait lors de la réception du chèque...
    // n'existe pas dans les BL   Que_CreerDevis.ParamByName('BLE_CPTCLT').AsInteger := 0; // 1 si cpte client crédité
    // n'existe pas dans les BL    Que_CreerDevis.ParamByName('BLE_WEBACCPT').AsFloat := 0;

    Que_MajBL.ExecSQL;
    Que_MajBL.Close;
  EXCEPT
    ON E: Exception DO
    BEGIN
      Result := False;
    END;
  END;
END;

FUNCTION TDm_Common.MajCptClient(ACde: stUneCommande; DevID: integer = 0): Boolean;
VAR
  //  iTkeId: integer;
  iSesId: integer;
BEGIN
  Result := False;
  IF ACde.sDateReg <> '' THEN
  BEGIN
    TRY
      iSesId := GetSesID;
      IF iSesID > 0 THEN
      BEGIN
        // Crédite le compte client
        // Procédure FC_CREDITE_CPT_CLIENT : Création d'un tiket (entete + ligne), Création de la ligne dans le compte client, Création de l'encaissement
        Que_MajCptClient.Close;
        Que_MajCptClient.ParamByName('CLTID').AsInteger := ACde.iCliID;
        Que_MajCptClient.ParamByName('SESID').AsInteger := iSesID;
        Que_MajCptClient.ParamByName('MENID').AsInteger := GetModeEncId(ACde.sModeReg);
        Que_MajCptClient.ParamByName('MONTANT').AsFloat := ACde.fCdeNetAPayer;
        Que_MajCptClient.ParamByName('LIBELLE').AsString := 'Web ' + ACde.sCdeNum;
        Que_MajCptClient.ParamByName('MAGID').AsInteger := MyParams.iMagID;
        Que_MajCptClient.ParamByName('DVEID').AsInteger := DevID;
        Que_MajCptClient.ParamByName('USRID').AsInteger := GetParamInteger(204);
        Que_MajCptClient.Open;

        Result := (Que_MajCptClient.FieldByName('OK').AsInteger = 1);

        IF NOT Result THEN
          LogAction('ERREUR - Problème sur le compte client', 4);

      END
      ELSE
      BEGIN
        LogAction('ERREUR - Problème sur la session', 0);
        Result := False;
      END;
    EXCEPT
      ON E: Exception DO
      BEGIN
        Result := False;
      END;
    END;

    Que_MajCptClient.Close;
  END;
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

FUNCTION TDm_Common.GetOrCreateCivID(sCivNom: STRING): integer;
BEGIN
  Result := 0;
  TRY
    WITH Que_GetCiv DO
    BEGIN
      Close;
      ParamByName('CIVNOM').asString := sCivNom;
      Open;
      Result := FieldByName('CIV_ID').AsInteger;
      Close;
    END;
  EXCEPT
  END;

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

FUNCTION TDm_Common.GetModeEncId(AModeReg: STRING): integer;
BEGIN
  Que_GetModeEnc.Close;
  TRY
    Que_GetModeEnc.ParamByName('MODEREG').AsString := AModeReg;
    Que_GetModeEnc.Open;
    Result := Que_GetModeEnc.FieldByName('CME_MENID').AsInteger;
  EXCEPT
    ON E: Exception DO
    BEGIN
      LogAction(E.Message, 4);
      Result := 0;
    END;
  END;
  Que_GetModeEnc.Close;
END;

FUNCTION TDm_Common.GetSesID: Integer;
BEGIN
  Que_GetOuCreeSesID.Close;
  TRY
    Que_GetOuCreeSesID.ParamByName('POSID').AsInteger := MyParams.iPosID;
    Que_GetOuCreeSesID.ParamByName('USRID').AsInteger := MyGenParam.iVendeur;
    Que_GetOuCreeSesID.Open;
    Result := Que_GetOuCreeSesID.FieldByName('SESID').AsInteger;
  EXCEPT
    ON E: Exception DO
    BEGIN
      LogAction(E.Message, 4);
      Result := 0;
    END;
  END;
  Que_GetOuCreeSesID.Close;
END;

FUNCTION TDm_Common.GetTransporteurLib(ACode, ANum, AMag: STRING): STRING;
BEGIN
  Que_GetTranspLib.Close;
  TRY
    Que_GetTranspLib.ParamByName('CODE').AsString := ACode;
    Que_GetTranspLib.Open;

    IF Que_GetTranspLib.EOF THEN
    BEGIN
      Result := 'Transporteur inconnu : ' + ACode + ' - ' + ANum + ' - ' + AMag;
    END
    ELSE BEGIN
      IF Que_GetTranspLib.FieldByName('CTR_AFFMAG').AsInteger = 0 THEN
      BEGIN
        // On affiche le mag, mais pas le num
        IF ANum <> '' THEN
          Result := Que_GetTranspLib.FieldByName('CTR_LIB').AsString + ' - n° : ' + ANum
        ELSE
          Result := Que_GetTranspLib.FieldByName('CTR_LIB').AsString;

      END
      ELSE BEGIN
        // On affiche le num, mais pas le mag (si on l'a)
        IF AMag <> '' THEN
          Result := Que_GetTranspLib.FieldByName('CTR_LIB').AsString + ' : ' + AMag
        ELSE
          Result := Que_GetTranspLib.FieldByName('CTR_LIB').AsString;

      END;
    END;
  EXCEPT
    ON E: Exception DO
    BEGIN
      Result := 'Non Communiqué';
      LogAction(E.Message, 4);
    END;
  END;
  Que_GetTranspLib.Close;
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

