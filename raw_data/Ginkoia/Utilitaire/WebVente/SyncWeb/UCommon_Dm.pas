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
  uGeneriqueType,
  uCommon_Type,
  idFtpCommon,
  XMLCursor,
  StdXML_TLB,
  IdGlobalProtocols,
  IdAttachmentFile,
  NetEvenWS,
  NetEvenGestion,
  IniFiles,
  RegularExpressions,
  // fin uses perso
  xmldom, XMLIntf, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack,
  IdSSL, IdSSLOpenSSL, IdAntiFreezeBase, IdAntiFreeze, dxmdaset, msxmldom,
  XMLDoc, StrHlder, DB, IB_Components, ActionRv, IdMessage, IdMessageClient,
  IdSMTPBase, IdSMTP, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdExplicitTLSClientServerBase, IdFTP, IBODataset, SBSimpleSftp, SBUtils, SBSSHKeyStorage,
  DBClient, SBTypes,
  uWebVenteFid, IB_Process, IB_Script, SBSSLCommon, SBSimpleFTPS, SBSocket,
  SBSSLClient;

TYPE
  TGestion_K_Version = (tKNone, tKV32, tKV64);

  TDm_Common = CLASS(TDataModule)
    Que_SelKTB: TIBOQuery;
    Ginkoia: TIB_Connection;
    IbT_Select: TIB_Transaction;
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
    Que_GetPays: TIBOQuery;
    QryGet: TIB_Cursor;
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
    Que_SitePriv: TIBOQuery;
    Que_SitePrivASS_ID: TIntegerField;
    Que_SitePrivASS_NOM: TStringField;
    Que_SitePrivASS_CODE: TIntegerField;
    Que_SitePrivASS_INFO: TMemoField;
    Que_SitePrivASS_AMAJ: TIntegerField;
    Que_SitePrivASS_USRID: TIntegerField;
    Que_SitePrivASS_NPJID: TIntegerField;
    Que_SitePrivASS_POSID: TIntegerField;
    Que_SitePrivASF_ID: TIntegerField;
    Que_SitePrivASF_ASSID: TIntegerField;
    Que_SitePrivASF_DOSSIERLOCAL: TStringField;
    Que_SitePrivASF_DOSSIERFTP: TStringField;
    Que_SitePrivASF_EXTENSION: TStringField;
    Que_SitePrivASF_FTPUSER: TStringField;
    Que_SitePrivASF_FTPPWD: TStringField;
    Que_SitePrivASF_FTPPORT: TIntegerField;
    Que_SitePrivASF_CTRLENVOI: TIntegerField;
    Que_SitePrivASF_NBESSAI: TIntegerField;
    Que_SitePrivASF_SMTPUSER: TStringField;
    Que_SitePrivASF_SMTPPWD: TStringField;
    Que_SitePrivASF_SMTPPORT: TIntegerField;
    Que_SitePrivASF_DOGET: TIntegerField;
    Que_SitePrivASF_TYPEGET: TStringField;
    Que_SitePrivASF_URLGET: TStringField;
    Que_SitePrivASF_LOGINGET: TStringField;
    Que_SitePrivASF_PASSWRDGET: TStringField;
    Que_SitePrivASF_FTPDELFILEGET: TIntegerField;
    Que_SitePrivASF_FTPFOLDERGET: TStringField;
    Que_SitePrivASF_LOCALFOLDERGET: TStringField;
    Que_SitePrivASF_DOSEND: TIntegerField;
    Que_SitePrivASF_TYPESEND: TStringField;
    Que_SitePrivASF_URLSEND: TStringField;
    Que_SitePrivASF_LOGINSEND: TStringField;
    Que_SitePrivASF_PASSWRDSEND: TStringField;
    Que_SitePrivASF_FTPFOLDERSEND: TStringField;
    Que_SitePrivASF_LASTTIME: TDateTimeField;
    Que_SitePrivASF_LOCALFOLDERSEND: TStringField;
    Que_Trv: TIBOQuery;
    IbT_GenSku: TIB_Transaction;
    Que_GetPayPriv: TIBOQuery;
    Que_CreClientPriv: TIBOQuery;
    Que_CreCommEnt: TIBOQuery;
    Que_CreCommLig: TIBOQuery;
    MemD_Rapport: TdxMemData;
    MemD_RapportNOLIGNE: TIntegerField;
    MemD_RapportFICHIER: TStringField;
    MemD_RapportJDATE: TDateField;
    MemD_RapportJTIME: TTimeField;
    MemD_RapportLIGERR: TIntegerField;
    MemD_RapportLIBERR: TStringField;
    MemD_RapportNUMCOM: TStringField;
    MemD_RapportNUMART: TStringField;
    MemD_ATraiterVtePriv: TdxMemData;
    MemD_ATraiterVtePrivfichier: TStringField;
    MemD_ATraiterVtePrivATraiter: TIntegerField;
    MemD_ImportVtePriv: TdxMemData;
    MemD_ImportVtePrivCodeIntComm: TStringField;
    MemD_ImportVtePrivMntTotComm: TStringField;
    MemD_ImportVtePrivFraisPort: TStringField;
    MemD_ImportVtePrivCodeIntProd: TStringField;
    MemD_ImportVtePrivQte: TStringField;
    MemD_ImportVtePrivStatuCom: TStringField;
    MemD_ImportVtePrivDateCom: TStringField;
    MemD_ImportVtePrivLibProd: TStringField;
    MemD_ImportVtePrivPxUnit: TStringField;
    MemD_ImportVtePrivSKUProd: TStringField;
    MemD_ImportVtePrivPA: TStringField;
    MemD_ImportVtePrivVente: TStringField;
    MemD_ImportVtePrivEMail: TStringField;
    MemD_ImportVtePrivPrenomFact: TStringField;
    MemD_ImportVtePrivNomFact: TStringField;
    MemD_ImportVtePrivNumCom: TStringField;
    MemD_ImportVtePrivAdrLiv1: TStringField;
    MemD_ImportVtePrivAdrLiv2: TStringField;
    MemD_ImportVtePrivVil: TStringField;
    MemD_ImportVtePrivPays: TStringField;
    MemD_ImportVtePrivTel: TStringField;
    MemD_ImportVtePrivCodePostal: TStringField;
    MemD_ImportVtePrivPrenomLiv: TStringField;
    MemD_ImportVtePrivNomLiv: TStringField;
    MemD_ImportVtePrivTaille: TStringField;
    MemD_ImportVtePrivNoLigne: TIntegerField;
    Que_GetNumCommPriv: TIBOQuery;
    MemD_RapportDATECOM: TStringField;
    MemD_RapportLIBCOM: TStringField;
    Que_IsLotValid: TIBOQuery;
    Que_IsCodePromo: TIBOQuery;
    Que_SiteNetEven: TIBOQuery;
    IdAntiFreeze1: TIdAntiFreeze;
    Que_Div: TIBOQuery;
    Que_ArtInfosCBComplete: TIBOQuery;
    idOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    que_GetSitesParamSecuMail: TIBOQuery;
    SFTP: TElSimpleSFTPClient;
    Que_GetSitesParamASF_ID: TIntegerField;
    Que_GetSitesParamASF_ASSID: TIntegerField;
    Que_GetSitesParamASF_DOSSIERLOCAL: TStringField;
    Que_GetSitesParamASF_DOSSIERFTP: TStringField;
    Que_GetSitesParamASF_EXTENSION: TStringField;
    Que_GetSitesParamASF_FTPUSER: TStringField;
    Que_GetSitesParamASF_FTPPWD: TStringField;
    Que_GetSitesParamASF_FTPPORT: TIntegerField;
    Que_GetSitesParamASF_CTRLENVOI: TIntegerField;
    Que_GetSitesParamASF_NBESSAI: TIntegerField;
    Que_GetSitesParamASF_SMTPUSER: TStringField;
    Que_GetSitesParamASF_SMTPPWD: TStringField;
    Que_GetSitesParamASF_SMTPPORT: TIntegerField;
    Que_GetSitesParamASF_SMTPDEST: TMemoField;
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
    Que_GetSitesParamASF_FTPSFTP: TIntegerField;
    Que_GetSitesParamASF_PORTGET: TIntegerField;
    Que_GetSitesParamASF_SFTPGET: TIntegerField;
    Que_GetSitesParamASF_PORTSEND: TIntegerField;
    Que_GetSitesParamASF_SFTPSEND: TIntegerField;
    Que_GetArtExportWeb: TIBOQuery;
    Que_GetArtExportWebAWE_ID: TIntegerField;
    Que_GetArtExportWebAWE_ASSID: TIntegerField;
    Que_GetArtExportWebAWE_FICHIER: TStringField;
    Que_GetArtExportWebAWE_ACTIF: TIntegerField;
    Que_GetArtExportWebAWE_DATEEXPORT: TDateTimeField;
    Que_GetArtExportWebAWE_LASTVERSION: TLargeintField;
    Que_GeneralId: TIBOQuery;
    Que_GeneralIdCURRENT_VERSION: TIBOLargeIntField;
    Que_Plage: TIBOQuery;
    Que_PlageBAS_PLAGE: TStringField;
    MemD_Export: TClientDataSet;
    Que_IsBonAchatValid: TIBOQuery;
    Que_IsBonAchatValidBAC_ID: TIntegerField;
    Que_IsBonAchatValidBAC_CLTID: TIntegerField;
    Que_IsBonAchatValidBAC_MONTANT: TIBOFloatField;
    Que_IsBonAchatValidBAC_TKEID: TIntegerField;
    Que_IsBonAchatValidBAC_CBTID: TIntegerField;
    Que_IsBonAchatValidBAC_USED: TIntegerField;
    Que_ClientGenerique: TIBOQuery;
    Que_Fidelite: TIBOQuery;
    Que_FideliteCTL_POINT: TIntegerField;
    IbT_Doublon: TIB_Transaction;
    ibs_DoublonADW: TIB_Script;
    Que_CurrentVersionPlage: TIBOQuery;
    Que_CurrentVersionPlageCURRENT_VERSION: TLargeintField;
    Que_GetArtExportWebLame: TIBOQuery;
    IntegerField10: TIntegerField;
    IntegerField11: TIntegerField;
    StringField20: TStringField;
    IntegerField12: TIntegerField;
    DateTimeField2: TDateTimeField;
    IntegerField13: TIntegerField;
    Que_GetArtExportWebLameAWE_MAGID: TIntegerField;
    Que_NumVersion: TIBOQuery;
    IBOLargeIntField2: TIBOLargeIntField;
    Que_GetArtExportWebAWE_MAGID: TIntegerField;
    FTP: TElSimpleFTPSClient;
    FTPold: TIdFTP;
    Que_SitePrivASF_FTPHOST: TStringField;
    Que_SitePrivASF_URLMAJ: TStringField;
    Que_SitePrivASF_SMTPHOST: TStringField;
    Que_SitePrivASF_SMTPEXP: TStringField;
    Que_SitePrivASF_SMTPDEST: TStringField;
    Que_GetSitesParamASF_SMTPHOST: TStringField;
    Que_GetSitesParamASF_FTPHOST: TStringField;
    Que_GetSitesParamASF_SMTPEXP: TStringField;
    Que_GetSitesParamASF_URLMAJ: TStringField;
    QueryPlage: TIBOQuery;
    Que_VersionID: TIBOQuery;
    IBOLargeIntField1: TIBOLargeIntField;
    Que_Plage64: TIBOQuery;

    PROCEDURE FTPConnected(Sender: TObject);
    PROCEDURE FTPoldDisconnected(Sender: TObject);
    PROCEDURE FTPoldAfterClientLogin(Sender: TObject);
    PROCEDURE DataModuleCreate(Sender: TObject);
    procedure SFTPKeyValidate(Sender: TObject; ServerKey: TElSSHKey; var Validate: Boolean);

  PRIVATE

    iNbErreurFTP: integer;
    iNbErreurNetEven: Integer; // TODO : voir solution + tard pour en faire 1 par Site
    FGestion_K_VERSION : TGestion_K_Version;

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
    PROCEDURE UpdateK(AKId: integer; ASuppression: integer = 0); // Maj du K (dates et Enabled au besoin)

    // Conversion
    FUNCTION ISOStrToDate(S: STRING): TDateTime; // Transforme une date ISO en DateTime

    // Spécial Chullanka
    function GetOrderClause(out bUnSeulResultat: Boolean): String;

    { Déclarations privées }
  PUBLIC

    MySiteParams: stParam; // Contient les infos pour chaque site
    MyIniParams: stIniParam; // Contient les paramètres lus dans l'ini
    OkSiteWebVentePriv:boolean;  //à TRUE si il y a au moins un site Web Vente privée (GENERIC_SKU)
    OkSiteWebNetEven: Boolean;
    bCopyMemoNetEven: Boolean; // a True si on est en train de retraiter une journée NetEven

    WebVenteFid : TWebVenteFid;
    WebVenteIntFid: TWebVenteFid_Params;

    // Informations sur les plages de la base
    PlageLame: TPlage;
    PlageBase: TPlage;

    // fonctions generiques
    function GetNewQuery: TIBOQuery;

    // Outils
    // Récupération d'id à partir du libellé
    FUNCTION GetOrCreatePayID(sPayNom, sPayCode: STRING): integer;

    FUNCTION GenImportGetId(AId: integer; AKtb: integer): integer; OVERLOAD; // récupère l'id ginkoia à partir d'un id
    FUNCTION GenImportGetId(AId: STRING; AKtb: integer): integer; OVERLOAD; // récupère l'id ginkoia à partir d'un id

    FUNCTION GetParamInteger(ACode: integer): integer; // récupération dabs genparam en fct du type
    FUNCTION GetParamMag(ACode: integer): integer; // récupération dabs genparam en fct du type
    FUNCTION GetParamPos(ACode: integer): integer; // récupération dabs genparam en fct du type
    FUNCTION GetParamString(ACode: integer): STRING;
    FUNCTION GetParamFloat(ACode: integer): double;

    FUNCTION DBReconnect(const OkTestVtePrive:boolean = false): boolean; // Connection aux DB
    PROCEDURE DBDisconnect; // Connection aux DB
    FUNCTION LitParams(bVerifParams: boolean): Boolean;
    FUNCTION ParamValides(): boolean;

    // Récupération des plages de la base
    function PlagesBase(): Boolean;

    // Traitement des fichiers
    PROCEDURE DoGet(dDebut,dFin : TTime);
    procedure DoSend(dDebut, dFin: TTime; bEnd: Boolean; dLastDateArt: TDateTime; dLastDateStk: TDateTime; bInitialisation: Boolean = False; bInitStockUniquement: Boolean = False);

    PROCEDURE NetEvenGet(dtForceJourDeb : TDateTime = 0; dtForceJourFin: TDateTime = 0);
    FUNCTION NetEven_CreeEntete(ACdeLine: MarketPlaceOrder; AtabMontant: tbMontant; AFraisPort: Double): string;
    PROCEDURE NetEven_CreeLigne(ACdeLine: MarketPlaceOrder; AArtInfos: stArticleInfos; ALotInfos: stLotInfos);

    FUNCTION GetArticleInfos(sCodeBar: STRING; aCodeBarType: integer = 1; aRetry: boolean = false): stArticleInfos;
    function IsLotValid(AIdLot:integer):integer;
    function IsCodePromoValid(AIdCodPromo:integer; ANomCodePromo: string):boolean;
    function IsBonAchatValid(AIdBonAchat, AIdClient, AIdMag: Integer): Boolean;
    PROCEDURE CumulMontant(VAR tabMontant: tbMontant; fTva, fMtTva, fMtTTC: Double);
    PROCEDURE SKUVersLot(VAR ALot: stLotInfos; ASKU: STRING; APrice: double);
    FUNCTION CdeExists(AIdCde: integer): Boolean;
    function GetFidelite(AMagId: Integer; AMontant: Currency): Integer;

    function TestConnexions: boolean;

    function RecupererTTC(const AArtId: Integer; const APUBrutHT, APUHT, APXHT: Currency;
      var APUBrutTTC, APUTTC, APXTTC, ATxTVA: Currency): Boolean;

    // FTP
    FUNCTION FTPConnect(bGet: boolean): Boolean;
    PROCEDURE FTPDisconnect();

    FUNCTION FTPFileExists(CONST ADirectory, AFile: STRING): Boolean;

//    FUNCTION FTPGetList(): boolean;
    FUNCTION FTPGetAFile(AFileName, APathFileToGet: STRING; AExpectedSize: integer): boolean;

    PROCEDURE FTPFolderProcess();
    PROCEDURE FTPFileSend(sFile: STRING);
    FUNCTION FTPPutFile(sFileSend: STRING): boolean;
    FUNCTION FTPTestTransfert(sFileSend, sFileReceive: STRING): boolean;

    // Mails
    FUNCTION SendMail: boolean; overload;
    function SendMail(ASMTPData: TSMTPData; ALogFilePath: string): boolean; overload;
    PROCEDURE SendLog(bModeAuto: boolean);

    procedure ModulesToList(Const AList: TStringList);

    function GetClientByIDREF(AIDWeb : integer): integer;
    function GetClientByEmailLivraison(AEmail : string): integer;
    function GetClientByEmailFacturation(AEmail : string): integer;

    // passage au int64 pour le K_VERSION
     procedure Check_Mode_K_VERSION;

     property Gestion_K_VERSION: TGestion_K_Version read FGestion_K_VERSION;
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
  StrUtils,
  uMezcalito,
  uGenerique,
  SyncWebResStr, UMapping, uMonitoring, uLog;

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

function TDm_Common.PlagesBase(): Boolean;

  function RecupererPlage(const APlage: string): TPlage;
  var
    RegExp: TRegEx;
    Match : TMatch;
  begin
    // Créer l'expression régulière
    RegExp.Create('\[(\d+)M_(\d+)M\]',[roIgnoreCase]);
    Match := RegExp.Match(APlage);

    if Match.Success then
    begin
      Result.Debut  := StrToInt(Match.Groups.Item[1].Value) * 1000000;
      Result.Fin    := StrToInt(Match.Groups.Item[2].Value) * 1000000;
    end
    else begin
      raise EConvertError.CreateFmt('Plage non récupérable "%s".', [APlage]);
    end;
  end;

begin
  // Récupère les plages
  try
    if QueryPlage.Active then
      QueryPlage.Close;

    QueryPlage.SQL.Clear;
    QueryPlage.SQL.Add('SELECT BAS_IDENT,');
    QueryPlage.SQL.Add('       BAS_PLAGE');

    if FGestion_K_VERSION = tKV64 then
    begin
      QueryPlage.SQL.Add(', BAS_VERSDEB');
      QueryPlage.SQL.Add(', BAS_VERSFIN');
    end;

    QueryPlage.SQL.Add('FROM   GENBASES');
    QueryPlage.SQL.Add('WHERE  BAS_IDENT = ''0''');
    QueryPlage.SQL.Add('   OR  BAS_IDENT = (SELECT PAR_STRING');
    QueryPlage.SQL.Add('                    FROM   GENPARAMBASE');
    QueryPlage.SQL.Add('                    WHERE  PAR_NOM = ''IDGENERATEUR'');');
    QueryPlage.Open;

    try
      Result := True;
      QueryPlage.First;
      while not QueryPlage.Eof do
      begin

        if QueryPlage.FieldByName('BAS_IDENT').AsString = '0' then
        begin
          if FGestion_K_VERSION = tKV64 then
          begin
            PlageLame.Debut := QueryPlage.FieldByName('BAS_VERSDEB').AsLargeInt;
            PlageLame.Fin := QueryPlage.FieldByName('BAS_VERSFIN').AsLargeInt;
          end
          else
            PlageLame := RecupererPlage(QueryPlage.FieldByName('BAS_PLAGE').AsString)
        end
        else
        begin
          if FGestion_K_VERSION = tKV64 then
          begin
            PlageBase.Debut := QueryPlage.FieldByName('BAS_VERSDEB').AsLargeInt;
            PlageBase.Fin := QueryPlage.FieldByName('BAS_VERSFIN').AsLargeInt;
          end
          else
            PlageBase := RecupererPlage(QueryPlage.FieldByName('BAS_PLAGE').AsString);
        end;

        QueryPlage.Next;
      end;
    except
      Result := False;
      raise;
    end;
  finally
    QueryPlage.Close;
  end;
end;

PROCEDURE TDm_Common.DataModuleCreate(Sender: TObject);
BEGIN
  iNbErreurFTP       := 0;
  iNbErreurNetEven   := 0;
  OkSiteWebVentePriv := False;
  OkSiteWebNetEven   := False;
END;

PROCEDURE TDm_Common.DBDisconnect;
BEGIN
  // Déconnection de la DB
  Grd_CloseAll.Close;
  Ginkoia.Disconnect;
  Ginkoia.Close;
END;

FUNCTION TDm_Common.DBReconnect(const OkTestVtePrive:boolean = false): boolean;
const
  MAX_ESSAIS = 10;
  NB_SECS = 30;
var
  iNbEssais : Integer;
  iNbSecs   : Integer;
  bAttente  : Boolean;
BEGIN
  // Déconnection de la DB
  Ginkoia.Disconnect;
  Result := False;

  Ginkoia.Database := MyIniParams.sDBPath;

  iNbEssais := 0;
  bAttente  := False;

  repeat
    try
      if bAttente then
      begin
        for iNbSecs := 0 to (NB_SECS * 5) do
        begin
          Sleep(200);
          Application.ProcessMessages();
        end;
      end;

      Ginkoia.Connect();
    except
      on E: Exception do
      begin
        Inc(iNbEssais);
        bAttente := True;
        LogAction(Format('%s. %s' + sLineBreak + '%s'#160': %s.', [ErrDBConnect, MyIniParams.sDBPath, E.ClassName, E.Message]), 0);
        LogAction(Format(ErrDBConnectEssais, [iNbEssais, MAX_ESSAIS, NB_SECS * 1.0]));
      end;
    end;
  until Ginkoia.Connected or (iNbEssais >= MAX_ESSAIS);

  IF Ginkoia.Connected THEN
  BEGIN
    Result := True;

    if OkTestVtePrive then begin
      //y a t'il un site Web actif de type vente privée ?
      try
        Que_SitePriv.Active := True;
        OkSiteWebVentePriv  := (Que_SitePriv.RecordCount > 0);
      finally
        Que_SitePriv.Active   := False;
      end;
    end;

    // Vérifie s'il y'a un site NetEven actif
    Que_SiteNetEven.Open;
    OkSiteWebNetEven := (Que_SiteNetEven.RecordCount > 0);
    Que_SiteNetEven.Close;

    LitParams(false);

    // Récupère les plages
    PlagesBase();

    // récurépation des infos de l'info du k_version en int32 ou int64
    Check_Mode_K_VERSION();
  END
  ELSE BEGIN
    // Erreur, a gerer
    Result := False;
    LogAction(ErrDBConnect + MyIniParams.sDBPath, 0);
  END;
END;

PROCEDURE TDm_Common.DoGet(dDebut,dFin : TTime);
BEGIN
  AddMonitoring('Début import', logNotice, mdltImport, apptSyncWeb, MySiteParams.iMagID);
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
  END
  ELSE if MySiteParams.sTypeGet = 'GENERIC_SKU' then
  begin
    //rien faire
  end
  else if MySiteParams.sTypeGet = 'MEZCALITO' then
  begin
    //rien faire
  end;

  AddMonitoring('Fin import', logInfo, mdltImport, apptSyncWeb, MySiteParams.iMagID);

  // 2 : Effectuer le transfert vers la structure

  // NetEven

  // 3 : Effectuer la création
END;

procedure TDm_Common.DoSend(dDebut, dFin: TTime; bEnd: Boolean; dLastDateArt: TDateTime; dLastDateStk: TDateTime; bInitialisation, bInitStockUniquement: Boolean);
begin
  AddMonitoring('Début export', logNotice, mdltExport, apptSyncWeb, MySiteParams.iMagID);
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
    DoGenSend(dDebut, dFin, bEnd, MySiteParams.bZipper, dLastDateArt, dLastDateStk, bInitialisation, bInitStockUniquement, MySiteParams.bDateFicInit, MySiteParams.bDateFic);
  END
  ELSE IF MySiteParams.sTypeSend = 'GENERIC_SKU' THEN
  BEGIN
    //rien faire
  end
  else if MySiteParams.sTypeSend = 'MEZCALITO' then
  begin
    DoMezSend(dDebut,dFin,bEnd);
  end;
  AddMonitoring('Fin export', logInfo, mdltExport, apptSyncWeb, MySiteParams.iMagID);
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
{$REGION 'LitParams'}
  function GetFTPRepertoireStocksRAL(const nASSID: Integer): String;
  var
    FichierINI: TIniFile;
    QueryTmp: TIBOQuery;
  begin
    Result := '';
    // MD - 2015-10-23 - modification de priorité. d'abord la BD et si pas trouvé ou vide on regarde l'ini
    QueryTmp := TIBOQuery.Create(Self);
    try
      QueryTmp.IB_Connection := Ginkoia;

      QueryTmp.Close;
      QueryTmp.SQL.Create;
      QueryTmp.SQL.Add('select ASF_DOSSIERFTPSTOCKSRAL');
      QueryTmp.SQL.Add('from ARTSITEFTP');
      QueryTmp.SQL.Add('join K on (K_ID = ASF_ID and K_ENABLED = 1)');
      QueryTmp.SQL.Add('where ASF_ASSID = :ASSID');
      QueryTmp.SQL.Add('and ASF_ID <> 0');
      try
        QueryTmp.ParamByName('ASSID').AsInteger := nASSID;
        QueryTmp.Open;
      except
        on E: Exception do
        begin
          LogAction('Erreur :  la recherche du répertoire FTP Stocks RAL en base a échoué !' + #13#10 + E.Message, 0);
          //Exit;
        end;
      end;
      if not QueryTmp.IsEmpty then
        Result := ExcludeTrailingPathDelimiter(QueryTmp.FieldByName('ASF_DOSSIERFTPSTOCKSRAL').AsString);
    finally
      QueryTmp.Free;
    end;

    if Result = '' then
    begin
      FichierINI := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'SyncWeb.ini');
      try
        if FichierINI.ValueExists('GENERIQUE', 'RepertoireFTPStocksRAL') then
          Result := ExcludeTrailingPathDelimiter(FichierINI.ReadString('GENERIQUE', 'RepertoireFTPStocksRAL', 'Stocks RAL'))
        else
          LogAction('Erreur :  la recherche du répertoire FTP Stocks RAL en INI a échoué !', 0);
      finally
        FichierINI.Free;
      end;
    end;

  end;
{$ENDREGION}
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


    FMonitoringError := False;

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

      if not(Que_GetSitesParamASF_FTPPORT.IsNull or (Que_GetSitesParamASF_FTPPORT.AsInteger = 0)) then
        sFTPPort := IntToStr(Que_GetSitesParamASF_FTPPORT.AsInteger)
      else
        sFTPPort := '21';

      iFTPNbTry := Que_GetSitesParamASF_NBESSAI.AsInteger;

      // Infos Envoi FTP
      bFTPValidEnvoi := (Que_GetSitesParamASF_CTRLENVOI.AsInteger = 1);

      sFTPSendFolder := Que_GetSitesParamASF_FTPFOLDERSEND.AsString;
      IF sFTPSendFolder = '' THEN
        sFTPSendFolder := Que_GetSitesParamASF_DOSSIERFTP.AsString;
      // MD - 2015-10-23 - ajout d'un contrôle du '/' en début de dossier
      if LeftStr(sFTPSendFolder,1) <> '/' then
          sFTPSendFolder := '/'+sFTPSendFolder;

      sFTPSendExtention := Que_GetSitesParamASF_EXTENSION.AsString;

      bDelFTPFiles := (Que_GetSitesParamASF_FTPDELFILEGET.AsInteger = 1);

      // **************** Réception ****************
      bGet := (Que_GetSitesParamASF_DOGET.AsInteger = 1);

      // Type de récupération
      sTypeGet := Que_GetSitesParamASF_TYPEGET.AsString;

      // Infos Get FTP
      sURLGet := Que_GetSitesParamASF_URLGET.AsString;
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

      // recherche du paramètre de securisation
      // pour le site en cours, sinon le général
      que_GetSitesParamSecuMail.Close();
      que_GetSitesParamSecuMail.ParamByName('siteid').AsInteger := Que_GetSitesASS_ID.AsInteger;
      que_GetSitesParamSecuMail.Open();
      if que_GetSitesParamSecuMail.Eof then
      begin
        que_GetSitesParamSecuMail.Close();
        que_GetSitesParamSecuMail.ParamByName('siteid').AsInteger := 0;
        que_GetSitesParamSecuMail.Open();
        if que_GetSitesParamSecuMail.Eof then
          sMailSecu := 2
        else
          sMailSecu := que_GetSitesParamSecuMail.FieldByName('prm_integer').AsInteger;
      end
      else
        sMailSecu := que_GetSitesParamSecuMail.FieldByName('prm_integer').AsInteger;
      que_GetSitesParamSecuMail.Close();

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
        Port         := Que_GetSitesParam.FieldByName('ASF_PORTGET').AsInteger;
        SFTP         := (Que_GetSitesParam.FieldByName('ASF_SFTPGET').AsInteger <> 0);
        FTPDirectory := Que_GetSitesParam.FieldByName('ASF_FTPFOLDERGET').AsString;
        // MD - 2015-10-23 - ajout d'un contrôle du '/' en début de dossier
        if LeftStr(FTPDirectory,1) <> '/' then
          FTPDirectory := '/'+FTPDirectory;
        bDeleteFile  := (Que_GetSitesParam.FieldByName('ASF_FTPDELFILEGET').AsInteger = 1);
      end;

      With FTPGenFacture do
      begin
        Host         := Que_GetSitesParam.FieldByName('ASF_URLSEND').AsString;
        User         := Que_GetSitesParam.FieldByName('ASF_LOGINSEND').AsString;
        Psw          := Que_GetSitesParam.FieldByName('ASF_PASSWRDSEND').AsString;
        Port         := Que_GetSitesParam.FieldByName('ASF_PORTSEND').AsInteger;
        SFTP         := (Que_GetSitesParam.FieldByName('ASF_SFTPSEND').AsInteger <> 0);
        FTPDirectory := Que_GetSitesParam.FieldByName('ASF_FTPFOLDERSEND').AsString;
        // MD - 2015-10-23 - ajout d'un contrôle du '/' en début de dossier
        if LeftStr(FTPDirectory,1) <> '/' then
          FTPDirectory := '/'+FTPDirectory;
      end;

      With FTPGenCSV do
      begin
        Host         := Que_GetSitesParam.FieldByName('ASF_FTPHOST').AsString;
        User         := Que_GetSitesParam.FieldByName('ASF_FTPUSER').AsString;
        Psw          := Que_GetSitesParam.FieldByName('ASF_FTPPWD').AsString;
        Port         := Que_GetSitesParam.FieldByName('ASF_FTPPORT').AsInteger;
        SFTP         := (Que_GetSitesParam.FieldByName('ASF_FTPSFTP').AsInteger <> 0);
        FTPDirectory := Que_GetSitesParam.FieldByName('ASF_DOSSIERFTP').AsString;
        // MD - 2015-10-23 - ajout d'un contrôle du '/' en début de dossier
        if LeftStr(FTPDirectory,1) <> '/' then
          FTPDirectory := '/'+FTPDirectory;
        FTPRepertoireStocksRAL := GetFTPRepertoireStocksRAL(Que_GetSitesASS_ID.AsInteger);
        // MD - 2015-10-23 - ajout d'un contrôle du '/' en début de dossier
        if LeftStr(FTPRepertoireStocksRAL,1) <> '/' then
          FTPRepertoireStocksRAL := '/'+FTPRepertoireStocksRAL;
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

procedure TDm_Common.ModulesToList(const AList: TStringList);
var
  vQry: TIBOQuery;
begin
  AList.Clear;
  vQry:= GetNewQuery;
  try
    vQry.SQL.Text:= 'SELECT UGG_NOM FROM' +
                    '  uilgrpginkoiamag JOIN k ON (k_id=UGM_ID and K_enabled=1)' +
                    '  join uilgrpginkoia Join k on (k_id=UGG_ID and K_enabled=1) on (UGG_ID = UGM_UGGID) ' +
                    'WHERE UGG_ID<>0';
    vQry.Open;

    // Chargement de tous les modules actifs dans la liste

    while not vQry.Eof do
      begin
        AList.Append(vQry.Fields[0].AsString);
        vQry.Next;
      end;

  finally
    FreeAndNil(vQry);
  end;
end;

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

function TDm_Common.TestConnexions: boolean;
VAR
  wsNetEven: TGestionNetEven;
  sTestConnect: STRING;
  s:string;
BEGIN
  Result := True;
  IF MySiteParams.bGet THEN
  BEGIN
    IF MySiteParams.sTypeGet = 'NETEVEN' THEN
    BEGIN
      wsNetEven := CreerNWSServer(MySiteParams.sURLGet, MySiteParams.sLoginGet, MySiteParams.sPassGet, MySiteParams.sLocalFolderGet); //'laurent@ekosport.fr', '2fsarl73');
      TRY
        sTestConnect := wsNetEven.TestConnection;
      EXCEPT
        sTestConnect := 'Echec';
        Result := False;
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
        LogAction(MySiteParams.sNomSite + ' (Réception) : Connection échouée', 2);
        Result := False;
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
        LogAction(MySiteParams.sNomSite + ' (Réception) : Connection échouée', 2);
        Result := False;
      END;
      Sleep(100);
      FTPDisconnect();
    END
    else if MySiteParams.sTypeGet = 'GENERIQUE' then //test connexion ftp GENERIQUE
    begin
      if not(MySiteParams.FTPGenGet.SFTP) then
      begin
        try
          if GenFTPConnection(MySiteParams.FTPGenGet) then
            LogAction(MySiteParams.sNomSite + ' (Réception) : Connection réussie', 2)
          else
          begin
            LogAction(MySiteParams.sNomSite + ' (Réception) : Connection échouée', 2);
            Result := False;
          end;
        finally
          GenFTPClose;
        end;
      end
      else
      begin
        try
          if GenSFTPConnection(MySiteParams.FTPGenGet) then
            LogAction(MySiteParams.sNomSite + ' (Réception) : Connection réussie', 2)
          else
          begin
            LogAction(MySiteParams.sNomSite + ' (Réception) : Connection échouée', 2);
            Result := False;
          end;
        finally
          GenSFTPClose();
        end;
      end;
    end
    else if MySiteParams.sTypeGet = 'GENERIC_SKU' then
    begin
      s:=MySiteParams.sLocalFolderGet;
      if (s<>'') and DirectoryExists(s) then
        LogAction(MySiteParams.sNomSite + ' Emplacement des fichiers Ok', 2)
      else
        LogAction(MySiteParams.sNomSite + ' Emplacement des fichiers invalide', 2);
    end
    else if MySiteParams.sTypeGet = 'MEZCALITO' then
    begin
      try
        if MezFTPConnection(MySiteParams.FTPGenFacture) then
          LogAction(MySiteParams.sNomSite + ' (Réception) : Connection réussie', 2)
        else
        begin
          LogAction(MySiteParams.sNomSite + ' (Réception) : Connection échouée', 2);
          Result := False;
        end;
      finally
        MezFTPClose;
      end;
    end;
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
        Result := False;
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
      ELSE
      BEGIN
        // Connection échouée
        LogAction(MySiteParams.sNomSite + ' (Envoi) : Connection échouée', 2);
        Result := False;
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
      ELSE
      BEGIN
        // Connection échouée
        LogAction(MySiteParams.sNomSite + ' (Envoi) : Connection échouée', 2);
        Result := False;
      END;
      Sleep(100);
      FTPDisconnect();
    END
    ELSE if MySiteParams.sTypeSend = 'GENERIQUE' then
    begin
      if not(MySiteParams.FTPGenCSV.SFTP) then
      begin
        try
          if MySiteParams.FTPGenCSV.Host <> '' then
          begin
            if GenFTPConnection(MySiteParams.FTPGenCSV) then
              LogAction(MySiteParams.sNomSite + ' (Envoi Stocks et articles) : Connection réussie', 2)
            else
            begin
              LogAction(MySiteParams.sNomSite + ' (Envoi Stocks et articles) : Connection échouée', 2);
              Result := False;
            end;
          end
          else
          begin
            LogAction(MySiteParams.sNomSite + ' (Envoi Stocks et articles) : Non renseigné', 2)
          end;
        finally
          GenFTPClose;
        end;
        try
          if MySiteParams.FTPGenFacture.Host <> '' then
          begin
            if GenFTPConnection(MySiteParams.FTPGenFacture) then
              LogAction(MySiteParams.sNomSite + ' (Envoi factures) : Connection réussie', 2)
            else
            begin
              LogAction(MySiteParams.sNomSite + ' (Envoi factures) : Connection échouée', 2);
              Result := False;
            end;
          end
          else
          begin
            LogAction(MySiteParams.sNomSite + ' (Envoi factures) : Non renseigné', 2)
          end;
        finally
          GenFTPClose;
        end;
      end
      else
      begin
        try
          if MySiteParams.FTPGenCSV.Host <> '' then
          begin
            if GenSFTPConnection(MySiteParams.FTPGenCSV) then
              LogAction(MySiteParams.sNomSite + ' (Envoi Stocks et articles) : Connection réussie', 2)
            else
            begin
              LogAction(MySiteParams.sNomSite + ' (Envoi Stocks et articles) : Connection échouée', 2);
              Result := False;
            end;
          end
          else
          begin
            LogAction(MySiteParams.sNomSite + ' (Envoi Stocks et articles) : Non renseigné', 2)
          end;
        finally
          GenSFTPClose();
        end;
        try
          if MySiteParams.FTPGenFacture.Host <> '' then
          begin
            if GenSFTPConnection(MySiteParams.FTPGenFacture) then
              LogAction(MySiteParams.sNomSite + ' (Envoi factures) : Connection réussie', 2)
            else
            begin
              LogAction(MySiteParams.sNomSite + ' (Envoi factures) : Connection échouée', 2);
              Result := False;
            end;
          end
          else
          begin
            LogAction(MySiteParams.sNomSite + ' (Envoi factures) : Non renseigné', 2)
          end;
        finally
          GenSFTPClose();
        end;
      end;
    end
    else if MySiteParams.sTypeGet = 'GENERIC_SKU' then
    begin
      //rien faire
    end
    else if MySiteParams.sTypeGet = 'MEZCALITO' then
    begin
      try
        if MySiteParams.FTPGenCSV.Host <> '' then
        begin
          if MezFTPConnection(MySiteParams.FTPGenFacture) then
            LogAction(MySiteParams.sNomSite + ' (Envoi Stocks et articles) : Connection réussie', 2)
          else
          begin
            LogAction(MySiteParams.sNomSite + ' (Envoi Stocks et articles) : Connection échouée', 2);
            Result := False;
          end;
        end
        else
        begin
          LogAction(MySiteParams.sNomSite + ' (Envoi Stocks et articles) : Non renseigné', 2)
        end;
      finally
        MezFTPClose;
      end;
    end;
  END;

END;

function TDm_Common.RecupererTTC(const AArtId: Integer; const APUBrutHT, APUHT, APXHT: Currency;
  var APUBrutTTC, APUTTC, APXTTC, ATxTVA: Currency): Boolean;
var
  QueTVAArticle : TIBOQuery;
begin
  Result := False;

  QueTVAArticle := TIBOQuery.Create(Self);
  try
    // Paramètre la connexion
    QueTVAArticle.IB_Connection   := Ginkoia;
    QueTVAArticle.IB_Transaction  := IbT_Select;

    if QueTVAArticle.IB_Transaction.TransactionOpen then
      QueTVAArticle.IB_Transaction.Refresh(False);

    // Paramètre la requête
    QueTVAArticle.SQL.Clear();
    QueTVAArticle.SQL.Add('SELECT TVA_TAUX');
    QueTVAArticle.SQL.Add('FROM ARTREFERENCE');
    QueTVAArticle.SQL.Add('  JOIN ARTTVA ON (TVA_ID = ARF_TVAID)');
    QueTVAArticle.SQL.Add('WHERE ARF_ARTID = :ARTID;');

    // Récupére le taux de TVA de l'article
    QueTVAArticle.ParamByName('ARTID').AsInteger := AArtId;
    QueTVAArticle.Open();

    if not(QueTVAArticle.IsEmpty()) then
    begin
      // Si le taux de TVA de l'article a été trouvé
      ATxTVA      := QueTVAArticle.FieldByName('TVA_TAUX').AsFloat;

      // Calcul les prix TTC en fonction des prix HT avec la TVA
      APUBrutTTC  := APUBrutHT * (1 + ATxTVA / 100);
      APUTTC      := APUHT     * (1 + ATxTVA / 100);
      APXTTC      := APXHT     * (1 + ATxTVA / 100);

      Result      := True;
    end
    else begin
      // Le taux de TVA n'a pas été trouvé
      Result      := False;
    end;
  finally
    QueTVAArticle.Close();
    QueTVAArticle.Free();
  end;
end;

PROCEDURE TDm_Common.FTPoldAfterClientLogin(Sender: TObject);
BEGIN
  LogAction('OK - Serveur : ' + MySiteParams.sFTPHost + ' -> Connection réussie', 2);
END;

FUNCTION TDm_Common.FTPConnect(bGet: Boolean): Boolean;
BEGIN

  Result := False;

  IF (MySiteParams.sFTPHost <> '') THEN
  BEGIN
    // Au cas ou...
    IF FTP.Active THEN
    BEGIN
      // Dans le doute
      FTP.Abort;
      FTP.Close;
    END;
    IF bGet THEN
    BEGIN
      FTP.Address := MySiteParams.sURLGet;
      FTP.Username := MySiteParams.sLoginGet;
      FTP.Password := MySiteParams.sPassGet;
      FTP.Port := StrToInt(MySiteParams.sFTPPort);
    END
    ELSE BEGIN
      FTP.Address := MySiteParams.sURLSend;
      FTP.Username := MySiteParams.sLoginSend;
      FTP.Password := MySiteParams.sPassSend;
      FTP.Port := StrToInt(MySiteParams.sFTPPort);
    END;

    TRY

      FTP.Open;
      IF FTP.Active THEN
      BEGIN
        FTP.Login;
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
    FTP.Close;
  EXCEPT

  END;
END;

FUNCTION TDm_Common.FTPFileExists(CONST ADirectory,
  AFile: STRING): Boolean;
VAR

  AOldDir: STRING;
  FolderList: TStringList;
  vListeFichiers: TList;
  i: Integer;
BEGIN
  Result := False;
  TRY
    IF NOT FTP.Active THEN //Pas connecté ?
      FTP.Open; //On connecte
  EXCEPT
    FTP.Close;
    Exit; //Impossible de connecter !
  END;

  FolderList := TStringList.Create;
  TRY
    AOldDir := FTP.GetCurrentDir; //sauvegarder le répertoire actuel
    TRY
      FTP.Cwd(ADirectory); //Si le dossier n'existe pas -> exception levée
      vListeFichiers := TList.Create();
      TRY
        FTP.ListDirectory(ADirectory, vListeFichiers, '*.*', False, True, False);

        FolderList.Clear();
        for i := 0 to vListeFichiers.Count - 1 do
        begin
          FolderList.Add(TElFTPFileInfo(vListeFichiers[i]).Name);
        end;
      FINALLY
        vListeFichiers.Free();
        Result := FolderList.IndexOf(ExtractFileName(AFile)) >= 0;
      END;
    EXCEPT
    END;
  FINALLY
    FTP.Cwd(AOldDir); //reviens à l'ancien dossier
    FolderList.Free; //Libère la StringList
  END;
END;

PROCEDURE TDm_Common.FTPFolderProcess;
VAR
  MyFile: TSearchRec;
  sExtension, sListExtensions: STRING;
  iRes: integer;
BEGIN
  if MySiteParams.sToSendFolder <> '' then
  begin
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
  end
  else
  begin
    LogAction('', 2);
    LogAction('/***** Forcer envoie FTP : Pas de fichier à traité. *****/', 2);
  end;
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

      FTP.DownloadFile(AFileName, APathFileToGet, ftmOverwrite);

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

//FUNCTION TDm_Common.FTPGetList: boolean;
//BEGIN
//  Result := False;
//  TRY
//    FTP.GetFileList('*.xml',Str_FTPList.Strings);
//
//    Result := True;
//  EXCEPT
//    ON E: Exception DO
//    BEGIN
//      // Erreur
//      Result := False;
//    END;
//  END;
//END;

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
    FTP.TransferType := ttBinary;
    FTP.UploadFile(sFileSend, sFile, ftmOverwrite);

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
      FTP.Cwd(MySiteParams.sFTPSendFolder);
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
    FTP.DownloadFile(ExtractFileName(sFileSend), sFileReceive, ftmOverwrite);

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

PROCEDURE TDm_Common.FTPoldDisconnected(Sender: TObject);
BEGIN
  LogAction('OK - Déconnection', 2);
END;

FUNCTION TDm_Common.SendMail: Boolean;
VAR
  smtpData: TSMTPData;
BEGIN
  smtpData.Host := MySiteParams.sSMTPHost;
  smtpData.Port := StrToInt(MySiteParams.sSMTPPort);
  smtpData.User := MySiteParams.sSMTPUser;
  smtpData.Password := MySiteParams.sSMTPPwd;
  smtpData.Expediteur := MySiteParams.sMailExp;
  smtpData.Destinataires := MySiteParams.sMailDest;
  smtpData.SecurityType := TSMTPSecurityType(MySiteParams.sMailSecu);

  Result := SendMail(smtpData, GetLogFile);
END;

procedure TDm_Common.SFTPKeyValidate(Sender: TObject; ServerKey: TElSSHKey; var Validate: Boolean);
begin
  Validate := True;
end;

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

function TDm_Common.SendMail(ASMTPData: TSMTPData; ALogFilePath: string): boolean;
VAR
  iafAttachement: TIdAttachmentFile;
  IOHandler : TIdSSLIOHandlerSocketOpenSSL;
  index: integer;
BEGIN
  Result := False;

  IF not FileExists(ALogFilePath) THEN
  begin
    // si pas de log, pas d'envoi de mail !
    LogAction('Pas d''envoi d''Email car pas de log enregistré',2);
    Result := true;
    exit;
  end;

  IF ASMTPData.Host = '' THEN
  BEGIN
    LogAction('Pas de SMTP renseigné, impossible d''envoyer un E-Mail', 2);
    Result := False;
    EXIT;
  END;

  IF ASMTPData.Destinataires = '' THEN
  BEGIN
    LogAction('Pas de destinataire renseigné, impossible d''envoyer un E-Mail', 2);
    Result := False;
    EXIT;
  END;

  IF ASMTPData.Expediteur = '' THEN
  BEGIN
    LogAction('Pas d''expéditeur renseigné, impossible d''envoyer un E-Mail', 2);
    Result := False;
    EXIT;
  END;

  SMTP.Host := ASMTPData.Host;
  SMTP.Port := ASMTPData.Port;

  IF ASMTPData.User <> '' THEN
  BEGIN
    SMTP.AuthType := satDefault;
    SMTP.Username := ASMTPData.User;
    SMTP.Password := ASMTPData.Password;
  END
  ELSE BEGIN
    SMTP.AuthType := satNone;
  END;

   case ASMTPData.SecurityType of
     smtpTLS : // tls
     begin
       LogAction('Sécurité mail : TLS', 3);
       IOHandler := TIdSSLIOHandlerSocketOpenSSL.Create();
       IOHandler.Destination := ASMTPData.Host + ':' + IntToStr(ASMTPData.Port);
       IOHandler.Host := ASMTPData.Host;
       IOHandler.Port := ASMTPData.Port;
       IOHandler.SSLOptions.Method := sslvTLSv1;
       SMTP.IOHandler := IOHandler;
       SMTP.UseTLS := utUseExplicitTLS;
     end;
     smtpSSL : // ssl
     begin
       LogAction('Sécurité mail : SSL', 3);
       IOHandler := TIdSSLIOHandlerSocketOpenSSL.Create();
       IOHandler.Destination := ASMTPData.Host+ ':' + IntToStr(ASMTPData.Port);
       IOHandler.Host := ASMTPData.Host;
       IOHandler.Port := ASMTPData.Port;
       IOHandler.SSLOptions.Method := sslvSSLv23;
       SMTP.IOHandler := IOHandler;
       SMTP.UseTLS := utUseImplicitTLS;
     end;
     smtpNone :
     begin
       LogAction('Sécurité mail : Aucune', 3);
       SMTP.IOHandler := nil;
       SMTP.UseTLS := utNoTLSSupport;
     end;
   end;

  idMsgSend.Clear;
  idMsgSend.Body.Clear;
  idMsgSend.From.Text := ASMTPData.Expediteur;

  idMsgSend.Recipients.EMailAddresses := ASMTPData.Destinataires;
  idMsgSend.Subject := 'Erreur de l''outil : ' + Application.ExeName;

  // Enrichissement du body - Ajouté le 2013-06-11 par JO
  with Que_Tmp do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select bas_nom, bas_ident, bas_sender, bas_centrale, bas_nompournous, bas_codetiers, mag_nom, mag_enseigne');
    SQL.Add('from genparambase');
    SQL.Add('join genbases on par_string=bas_ident');
    SQL.Add('join genmagasin on mag_id=bas_magid');
    SQL.Add('where par_nom=''IDGENERATEUR''');
    Open;

    idMsgSend.Body.Add('Une erreur est survenue lors de l''exécution du service, voir le log joint.'+#13#10);
    for index := 0 to Que_Tmp.FieldCount-1 do
      idMsgSend.Body.Add( Fields.Fields[index].FieldName +'='+Fields.Fields[index].AsString );

    SQL.Clear;
    Close;
  end; // with Que_Tmp

  IF FileExists(ALogFilePath) THEN
    iafAttachement := TIdAttachmentFile.create(idMsgSend.MessageParts, ALogFilePath);

  try
    SMTP.Connect();
  except
    on e: Exception do
    begin
      LogAction(E.Message, 3);
      LogAction('Erreur de connection au serveur de messagerie, nouvelle tentative sur le port 25', 0);

      SMTP.Port := 25;
      if Assigned(IOHandler) then
      begin
        IOHandler.Destination := ASMTPData.Host + ':25';
        IOHandler.Port := 25;
      end;

      TRY
        SMTP.Connect();
      EXCEPT
        on e : Exception do
        begin
          LogAction(E.Message, 3);
          LogAction('Erreur de connection au serveur de messagerie', 0);
          result := false;
          EXIT;
        end;
      END;
    end;
  end;

  TRY
    // === Tout est OK ===
    SMTP.Send(idMsgSend);
    LogAction('Message envoyé à : ' + idMsgSend.Recipients.EMailAddresses, 2);
  EXCEPT
    ON E: Exception DO
    BEGIN
      // === Ne devrait normalement pas se produire ===
      LogAction(E.Message, 3);
      LogAction('Erreur SendMail', 0);
      result := false;
      SMTP.Disconnect();
      EXIT;
    END;
  END;

  SMTP.Disconnect();
  IF iafAttachement <> NIL THEN
    iafAttachement.Free;
  Result := True;

  if Assigned(IOHandler) then
  begin
    SMTP.IOHandler := nil;
    SMTP.UseTLS := utNoTLSSupport;
    FreeAndNil(IOHandler);
  end;
end;

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

function TDm_Common.GetFidelite(AMagId: Integer; AMontant: Currency): Integer;
begin
  try
    Que_Fidelite.ParamByName('MAGID').AsInteger   := AMagId;
    Que_Fidelite.ParamByName('PXTTC').AsCurrency  := AMontant;
    Que_Fidelite.Open();

    if not(Que_Fidelite.IsEmpty) then
      Result := Que_Fidelite.FieldByName('CLT_POINT').AsInteger
    else
      Result := 0;
  finally
    Que_Fidelite.Close();
  end;
end;

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
      logaction(E.Message, 3);
    END;
  END;
END;

FUNCTION TDm_Common.GetArticleInfos(sCodeBar: STRING; aCodeBarType: integer = 1; aRetry: boolean = false): stArticleInfos;
var
  sTmpCodeBar : string;

  procedure FillResult;
  begin
    Result.iArfId := Que_GetArtInfos.FieldByName('ARF_ID').AsInteger;
    Result.iArtId := Que_GetArtInfos.FieldByName('ARF_ARTID').AsInteger;
    Result.iTgfId := Que_GetArtInfos.FieldByName('CBI_TGFID').AsInteger;
    Result.iCouId := Que_GetArtInfos.FieldByName('CBI_COUID').AsInteger;
    Result.fTVA := Que_GetArtInfos.FieldByName('TVA_TAUX').AsFloat;
    Result.fPxAchat := Que_GetArtInfos.FieldByName('PXACHAT').AsFloat;
    Result.fPxBrut := Que_GetArtInfos.FieldByName('PXVTEBRUT').AsFloat;
    Result.IsValide := (Result.iArtId <> 0) and (Result.iTgfId <> 0) and (Result.iCouId <> 0);
  end;
BEGIN
  // MD - 2016-06-03 - On refait tout car FC a fait de la bouze :)
  Result.iArfId := 0;
  Result.iArtId := 0;
  Result.iTgfId := 0;
  Result.iCouId := 0;
  Result.fTVA := 0;
  Result.fPxAchat := 0;
  Result.fPxBrut := 0;
  Result.IsValide := False;
  try
    if sCodeBar = '' then
      raise Exception.Create('Code Barre vide');

    Que_GetArtInfos.Close;
    Que_GetArtInfos.ParamByName('CBICB').AsString := sCodeBar;
    Que_GetArtInfos.ParamByName('MAGID').AsInteger := MySiteParams.iMagID;
    Que_GetArtInfos.ParamByName('CBITYPE').AsInteger := aCodeBarType;
    try
      Que_GetArtInfos.Open;
      if not(Que_GetArtInfos.IsEmpty) then
      begin
        FillResult;
      end
      else
      begin
        // si pas trouvé avec le type actuel on test avec l'autre, si pas déjà un retry
        if aRetry then
          Exit;

        if aCodeBarType = 1 then
          aCodeBarType := 3
        else
          aCodeBarType := 1;
        Result := GetArticleInfos(sCodeBar, aCodeBarType, true);

        // toujours pas trouvé, on test en supprimant les 0 devant (NETEVEN)
        if not Result.IsValide then
        begin
          // si pas trouvé on supprime les 0 devant (NETEVEN)
          sTmpCodeBar := sCodeBar;
          if Length(sTmpCodeBar) = 13 then
          begin
            while (sTmpCodeBar <> '') and (sTmpCodeBar[1] = '0') and (not Result.IsValide) do
            begin
              Delete(sTmpCodeBar, 1, 1);
              if aCodeBarType = 1 then
                aCodeBarType := 3
              else
                aCodeBarType := 1;

              Result := GetArticleInfos(sTmpCodeBar, aCodeBarType, true);

              if not Result.IsValide then
              begin
                if aCodeBarType = 1 then
                  aCodeBarType := 3
                else
                  aCodeBarType := 1;
                Result := GetArticleInfos(sTmpCodeBar, aCodeBarType, true);
              end;
            end;
          end;
        end;
      end;
    finally
      Que_GetArtInfos.Close;
    end;
  except
  end;
end;

function TDm_Common.GetClientByIDREF(AIDWeb: Integer): Integer;
var
  vQuery: TIBOQuery;
  bUnSeulResultat: Boolean;
begin
  Result := 0;

  vQuery := TIBOQuery.Create(nil);
  try
    vQuery.IB_Connection := Dm_Common.Ginkoia;
    vQuery.IB_Transaction := Dm_Common.IbT_Modif;

    try
      vQuery.SQL.Text := 'SELECT CLT_ID, CLT_IDREF, CLT_EMAIL, CLT_OPTINEMAIL, CLT_OPINSMS ' +
                          'FROM CLTCLIENT ' +
                          '   JOIN K ON K_ID = CLT_ID AND K_ENABLED = 1 ' +
                          'WHERE CLT_ARCHIVE = 0 AND CLT_IDREF = :PIDREF';
      vQuery.SQL.Add(GetOrderClause(bUnSeulResultat));

      vQuery.ParamByName('PIDREF').AsInteger := AIDWeb;
      vQuery.Open;

      if not vQuery.IsEmpty then
      begin
        if bUnSeulResultat and (vQuery.RecordCount > 1) then
          raise Exception.Create('Plusieurs clients trouvés')
        else
          Result := vQuery.FieldByName('CLT_ID').AsInteger;
      end;
    except
      on E: Exception do
        raise Exception.Create('GetClientByIDREF -> ' + E.Message);
    end;
  finally
    FreeAndNil(vQuery);
  end;
end;

function TDm_Common.GetClientByEmailFacturation(AEmail: String): Integer;
var
  vQuery:  TIBOQuery;
  bUnSeulResultat: Boolean;
begin
  Result := 0;

  vQuery := TIBOQuery.Create(nil);
  try
    vQuery.IB_Connection := Dm_Common.Ginkoia;
    vQuery.IB_Transaction := Dm_Common.IbT_Modif;

    try
      vQuery.SQL.Text := 'SELECT CLT_ID, CLT_IDREF, CLT_EMAIL, CLT_OPTINEMAIL, CLT_OPINSMS ' +
                          'FROM CLTCLIENT ' +
                          '   JOIN K ON K_ID = CLT_ID AND K_ENABLED = 1 ' +
                          '   JOIN GENADRESSE ON CLT_ADRID = ADR_ID ' +
                          'WHERE CLT_ARCHIVE = 0 AND lower(ADR_EMAIL) = :PEMAIL';
      vQuery.SQL.Add('plan join (GENADRESSE natural,CLTCLIENT index (INX_CLTCLTADRID),K index (K_1))');
      vQuery.SQL.Add(GetOrderClause(bUnSeulResultat));


      vQuery.ParamByName('PEMAIL').AsString := LowerCase(AEmail);
      vQuery.Open;

      if not vQuery.IsEmpty then
      begin
        if bUnSeulResultat and (vQuery.RecordCount > 1) then
          raise Exception.Create('Plusieurs clients trouvés')
        else
          Result := vQuery.FieldByName('CLT_ID').AsInteger;
      end;
    except
      on E: Exception do
        raise Exception.Create('GetClientByEmailFacturation -> ' + E.Message);
    end;
  finally
    FreeAndNil(vQuery);
  end;
end;

function TDm_Common.GetClientByEmailLivraison(AEmail: String): Integer;
var
  vQuery: TIBOQuery;
  bUnSeulResultat: Boolean;
begin
  Result := 0;

  vQuery := TIBOQuery.Create(nil);
  try
    vQuery.IB_Connection := Dm_Common.Ginkoia;
    vQuery.IB_Transaction := Dm_Common.IbT_Modif;

    try
      vQuery.SQL.Text := 'SELECT CLT_ID, CLT_IDREF, CLT_EMAIL, CLT_OPTINEMAIL, CLT_OPINSMS ' +
                          'FROM CLTCLIENT ' +
                          '   JOIN K ON K_ID = CLT_ID AND K_ENABLED = 1 ' +
                          '   JOIN GENADRESSE ON CLT_AFADRID = ADR_ID ' +
                          'WHERE CLT_ARCHIVE = 0 AND lower(ADR_EMAIL) = :PEMAIL';
      vQuery.SQL.Add('plan join (GENADRESSE natural,CLTCLIENT index (INX_CLTCLTAFADRID),K index (K_1))');
      vQuery.SQL.Add(GetOrderClause(bUnSeulResultat));


      vQuery.ParamByName('PEMAIL').AsString := LowerCase(AEmail);
      vQuery.Open;

      if not vQuery.IsEmpty then
      begin
        if bUnSeulResultat and (vQuery.RecordCount > 1) then
          raise Exception.Create('Plusieurs clients trouvés')
        else
          Result := vQuery.FieldByName('CLT_ID').AsInteger;
      end;
    except
      on E: Exception do
        raise Exception.Create('GetClientByEmailLivraison -> ' + E.Message);
    end;
  finally
    FreeAndNil(vQuery);
  end;
end;

function TDm_Common.IsLotValid(AIdLot:integer):integer;
begin
  if AIdLot<=0 then
  begin
    result:=1;   //N° lot invalide
    exit;
  end;
  with Que_IsLotValid do begin
    Active:=false;
    ParamByName('LOTID').AsInteger:=AIdLot;
    Active:=true;
    First;
    if not(Eof) then
    begin
      if fieldbyname('K_ENABLED').AsInteger=1 then
        result:=0  //Ok
      else
        result:=3;  //N° lot supprimé
    end
    else
    begin
      result:=2;   //N° lot inconnu
    end;
    Active:=false;
  end;
end;

function TDm_Common.IsCodePromoValid(AIdCodPromo:integer; ANomCodePromo: string):boolean;
begin
  result := false;   //N° code promo invalide
  if AIdCodPromo<=0 then
    exit
  else
  begin
    with Que_IsCodePromo do
    begin
      Active := false;
      try
        ParamByName('ARTID').AsInteger := AIdCodPromo;
        ParamByName('ARTNOM').AsString := ANomCodePromo;
        Active := true;
        First;
        if not(Eof) then
          result := true;
      finally
        Active := false;
      end;
    end;
  end;
end;

function TDm_Common.IsBonAchatValid(AIdBonAchat, AIdClient, AIdMag: Integer): Boolean;
var
  JsonWebFid: TJSONReturnFidClient;
  vBonAchat: TBonAchat;
begin
  Result := True;

  if Assigned(WebVenteFid) then
  begin
    JsonWebFid  := WebVenteFid.getFidClientByIdAndMagId(AIdClient, AIdMag);
    if JsonWebFid.returnCode.code = 200 then
    begin
      vBonAchat   := JsonWebFid.getBonAchatById(AIdBonAchat);
      if Assigned(vBonAchat) then
      begin
        Result := ((vBonAchat.cbtId <> 0) and not(vBonAchat.used) and (vBonAchat.tkeId = 0));
      end;
    end;
  end;

  if Result then
  begin
    if Que_IsBonAchatValid.Active then
      Que_IsBonAchatValid.Close();
    try
      Que_IsBonAchatValid.ParamByName('BACID').AsInteger := AidBonAchat;
      Que_IsBonAchatValid.Open();

      // Vérifie que le bon d'achat existe
      if not(Que_IsBonAchatValid.IsEmpty) then
      begin
        // Vérifie qu'il n'a pas été utilisé
        Result := (Que_IsBonAchatValid.FieldByName('BAC_TKEID').AsInteger = 0)
              and (Que_IsBonAchatValid.FieldByName('BAC_USED').AsInteger = 0);
      end;
    finally
      Que_IsBonAchatValid.Close();
    end;
  end;
end;

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

function TDm_Common.GetNewQuery: TIBOQuery;
begin
  Result:= TIBOQuery.Create(nil);
  Result.IB_Connection:= Ginkoia;
end;

PROCEDURE TDm_Common.UpdateK(AKId: integer; ASuppression: integer = 0);
BEGIN
  TRY
    IbC_K.Close;
    IbC_K.SQL.Text := 'EXECUTE PROCEDURE PR_UPDATEK(:KID, :SUPPRESSION)';
    IbC_K.ParamByName('KID').AsInteger := AKId;
    IbC_K.ParamByName('SUPPRESSION').AsInteger := ASuppression;
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

  k, iNbLots: Integer;

  sCdeId, sCdeIdCumul: STRING;

  sCdeNum : string;

  fMontantFP, fTvaFP, fMtTvaFP: double;

  tabMontant: tbMontant;

  stArticle: stArticleInfos;
  stLot: stLotInfos;

  tabLotArticles: ARRAY OF stArticleInfos;

  iArt: Integer;

  iNbPagesTot : integer; // Nombre de pages total
  iPageCour   : integer; // Page en cours

  fPxRemise, fPxRemiseHT, fPxRemiseMtTVA: Double;

  nbCdes, iNbTraite, iNbExiste, iNbNotToDo: Integer;

  sTestConnect: STRING;

  bCdeExisteDeja: Boolean;
  bForceJournee: Boolean;
BEGIN
  // Init des variables de tracking
  iNbTraite := 0;
  iNbExiste := 0;
  iNbNotToDo := 0;

  bForceJournee := (dtForceJourDeb <> 0) and (dtForceJourFin <> 0);
  if bForceJournee then
  begin
    // On déplace également l'affichage dans le mémo
    bCopyMemoNetEven := True;
  end;

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
          MySiteParams.dtLastTime := Trunc(MySiteParams.dtCurrentTime - MyIniParams.iNbJourHier); // On vérif 1 jours complet dans ce cas
        END;
      end;

      LogAction('Date deb : ' + DateTimeToStr(MySiteParams.dtLastTime), 3);
      LogAction('Date fin : ' + DateTimeToStr(MySiteParams.dtCurrentTime), 3);
      LogAction('Code site : ' + IntToStr(MySiteParams.iCodeSite), 3);

      Sleep(50); // Petite tempo pour éviter erreur sur WebService
      Application.ProcessMessages; // Refresh de l'affichage

      // Création de l'instance du WebService
      LogAction('Creer', 3);
      wsNetEven := CreerNWSServer(MySiteParams.sURLGet, MySiteParams.sLoginGet, MySiteParams.sPassGet, MySiteParams.sLocalFolderGet); //'laurent@ekosport.fr', '2fsarl73');

      LogAction('Get', 3);
      aCdes := wsNetEven.GetCommandes(MySiteParams.dtLastTime, MySiteParams.dtCurrentTime, MySiteParams.iCodeSite, 1);
      TRY
        LogAction('After Get', 3);

        iPageCour := 1;
        try
          iNbPagesTot := StrToInt(aCdes.PagesTotal);
        Except
          iNbPagesTot := 1;
        end;

        LogAction(IntToStr(iNbPagesTot) + ' pages à traiter', 3);

        while iPageCour <= iNbPagesTot do
        begin
          i := 0;

          LogAction('Page en cours de traitement : ' + IntToStr(iPageCour) + '/' + IntToStr(iNbPagesTot), 3);
          nbCdes := Length(aCdes.GetOrdersResult);

          LogAction(IntToStr(nbCdes) + ' lignes de commandes à traiter', 3);

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
                    sCdeNum := NetEven_CreeEntete(aCdes.GetOrdersResult[i], tabMontant, fMontantFP);
                    Inc(iNbTraite);
                    LogAction('Traitement de la commande : ' + sCdeNum, 2);
                  END
                  ELSE BEGIN
                    // Appel de la procédure qui se charge de mettre à jour le règlement.
                    sCdeNum := NetEven_CreeEntete(aCdes.GetOrdersResult[i], tabMontant, fMontantFP);
                    Inc(iNbExiste);
                    LogAction('Vérification et Maj de la commande : ' + sCdeNum, 2);
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
                    iNbLots := Trunc(aCdes.GetOrdersResult[i].Quantity);

                    // ATTENTION AUX PACKS AVEC Qté <> 1
                    if iNbLots <> 0 then
                    begin
                      aCdes.GetOrdersResult[i].Price := aCdes.GetOrdersResult[i].Price / iNbLots;
                    end;

                    // Boucler sur la Qté et mettre 1 à chaque fois + incrémenter le numlot
                    for k := 1 To iNbLots  do
                    begin
                      aCdes.GetOrdersResult[i].Quantity := 1;
                      Inc(stLot.iNumLot);

                      // Atention, cas des packs
                      SKUVersLot(stLot, aCdes.GetOrdersResult[i].SKU, aCdes.GetOrdersResult[i].Price);

                      FOR j := 0 TO (Length(stLot.tabArticles) - 1) DO
                      BEGIN
                        NetEven_CreeLigne(aCdes.GetOrdersResult[i], stLot.tabArticles[j], stLot);
                      END;
                    end;


                  END
                  ELSE BEGIN
                    stLot.iLotId := 0;
                    // Récup des infos de l'article
                    stArticle := GetArticleInfos(aCdes.GetOrdersResult[i].SKU);
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

          Inc(iPageCour);
          IF (iPageCour <= iNbPagesTot) THEN
          BEGIN
            IF Assigned(aCdes) THEN
              FreeAndNil(aCdes);

            aCdes := wsNetEven.GetCommandes(MySiteParams.dtLastTime, MySiteParams.dtCurrentTime, MySiteParams.iCodeSite, iPageCour);
          END;
        end;
        LogAction(IntToStr(iNbTraite) + ' commandes traitées', 3);
        LogAction(IntToStr(iNbExiste) + ' commandes ignorées (déjà existantes)', 3);
        LogAction(IntToStr(iNbNotToDo) + ' commandes ignorées (code site différent)', 3);


      EXCEPT
        ON E: Exception DO BEGIN
          IbT_Modif.Rollback;
          LogAction('Erreur lors de la création des commandes NetEven', 0);
          LogAction(E.Message, 0);
        END;
      END;

      IF Assigned(aCdes) THEN
        FreeAndNil(aCdes);

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
      LogAction('Execption : ' + E.Message, 1);
    END;
  END;

  // Vidage
  SetLength(stLot.tabArticles, 0);

  bCopyMemoNetEven := False;
END;

// S'occupe de créé l'entete recue via un flux NetEven
FUNCTION TDm_Common.NetEven_CreeEntete(ACdeLine: MarketPlaceOrder; AtabMontant: tbMontant; AFraisPort: Double): string;
VAR
  CliID        : STRING;  // Contient l'id du client, si dispo, sinon hashage de son email
  i            : Integer; // variable de boucle
  iPaiement    : Integer; // Décomposition d'un type énuméré en entier
  sPays        : STRING;  // Pays, car traitement particulier
  sNumCommande : string;  // Contient le numéro de commande
BEGIN
  IF ((ACdeLine.BillingAddress.Email = '') AND (ACdeLine.CustomerId = '')) THEN
  begin
    LogAction(ACdeLine.OrderId + ' : commande ignorée, adresse mail de facturation et id client non renseignée.', 2);
    Exit;
  end;

  Que_Client.Close;

  if (IndexText(ACdeLine.MarketPlaceName, ['laredoute']) > -1) then
  begin
    if ContainsText(Que_Client.SQL.Text, 'FC_CREE_CLIENT_WEB') then
    begin
      Que_Client.SQL.Text := ReplaceText(Que_Client.SQL.Text, 'FC_CREE_CLIENT_WEB', 'CREE_CLIENT_WEB_MAJ');
      Que_Client.Prepare();
    end;
  end
  else if ContainsText(Que_Client.SQL.Text, 'CREE_CLIENT_WEB_MAJ') then
  begin
    Que_Client.SQL.Text := ReplaceText(Que_Client.SQL.Text, 'CREE_CLIENT_WEB_MAJ', 'FC_CREE_CLIENT_WEB');
    Que_Client.Prepare();
  end;

  // Récup de l'id client, si existant, sinon hashage de son email pour obtenir quelquechose d'unique
  // sur moins de 32 car
  CliID := ACdeLine.CustomerId;
  if CliID = '' then
    CliID := ComputeSignature(ACdeLine.BillingAddress.Email, '', '', '');
  Que_Client.ParamByName('ID_CLIENT').AsString := CliID;

  // Création du client
  WITH ACdeLine.BillingAddress DO
  BEGIN
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
    Que_Client.ParamByName('ID_PAYS').AsInteger := GetOrCreatePayID(sPays, '');
    Que_Client.ParamByName('TEL_CLIENT').AsString := Copy(Phone, 1, 32);
    Que_Client.ParamByName('GSM_CLIENT').AsString := Copy(Mobile, 1, 32);
    Que_Client.ParamByName('FAX_CLIENT').AsString := Copy(Fax, 1, 32);
  END;

  WITH ACdeLine.ShippingAddress DO
  BEGIN
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
    Que_Client.ParamByName('ID_PAYS_LIVRAISON').AsInteger := GetOrCreatePayID(sPays, '');
    Que_Client.ParamByName('TEL_CLIENT_LIVRAISON').AsString := Copy(Phone, 1, 32);
  END;

  Que_Client.ParamByName('SOCIETE').AsString := '';
  Que_Client.ParamByName('NUM_SIRET').AsString := '';
  Que_Client.ParamByName('NUM_TVA').AsString := '';
  Que_Client.ParamByName('CLT_MDP').AsString := '';
  ///  Que_Client.IB_Transaction.StartTransaction;
  Que_Client.ExecSQL;

  Que_Client.Close;

  // Création de l'entete de commande
  Que_Commande.Close;
  Que_Commande.ParamByName('ID_CLIENT').AsString := CliID;
  Que_Commande.ParamByName('ID_COMMANDE').AsInteger := StrToInt(ACdeLine.OrderID);

  // Sur demande client ne plus mettre le OrderID mais MarketPlaceInvoiceId
  // Cependant, il peut être vide... Donc, on mettra dans ce cas le SaleID
  // Si non présent, on mettra le OrderId, nous n'avons plus d'autre choix lisible
  if ACdeLine.MarketPlaceInvoiceId = '' THEN
  begin
    ACdeLine.MarketPlaceInvoiceId := ACdeLine.MarketPlaceSaleId;
    if ACdeLine.MarketPlaceInvoiceId = '' THEN
    begin
      ACdeLine.MarketPlaceInvoiceId := ACdeLine.OrderId;
    end;
  end;
  sNumCommande := Copy(ACdeLine.MarketPlaceName, 1, 4) + '-' + ACdeLine.MarketPlaceInvoiceId;
  Que_Commande.ParamByName('NUM_COMMANDE').AsString := StrUtils.LeftStr(sNumCommande, 32) ;

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

  Result := sNumCommande;
END;

PROCEDURE TDm_Common.NetEven_CreeLigne(ACdeLine: MarketPlaceOrder; AArtInfos: stArticleInfos; ALotInfos: stLotInfos);
BEGIN
  IF (ACdeLine.BillingAddress.Email = '') AND (ACdeLine.CustomerId = '') THEN
    Exit;

  Que_CommandeL.Close;
  Que_CommandeL.ParamByName('ID_COMMANDE').AsInteger := StrToInt(ACdeLine.OrderID);
  Que_CommandeL.ParamByName('CODE_SITE').AsInteger := StrToInt(ACdeLine.MarketPlaceId);
  Que_CommandeL.ParamByName('ID_PRODUIT').AsInteger := AArtInfos.iArtId;
  Que_CommandeL.ParamByName('ID_TAILLE').AsInteger := AArtInfos.iTgfId;
  Que_CommandeL.ParamByName('ID_COULEUR').AsInteger := AArtInfos.iCouId;
  Que_CommandeL.ParamByName('ID_PACK').AsInteger := ALotInfos.iLotId;
  Que_CommandeL.ParamByName('NUM_LOT').AsInteger := ALotInfos.iNumLot;
  Que_CommandeL.ParamByName('ID_CODE_PROMO').AsInteger := 0; // TODO
  Que_CommandeL.ParamByName('QTE').AsInteger := Trunc(ACdeLine.Quantity);
  Que_CommandeL.ParamByName('PX_BRUT').AsFloat := AArtInfos.fPxBrut;

  IF Trunc(ACdeLine.Quantity) <> 0 THEN
    Que_CommandeL.ParamByName('PX_NET_NET').AsFloat := ACdeLine.Price / Trunc(ACdeLine.Quantity)
  ELSE
    Que_CommandeL.ParamByName('PX_NET_NET').AsFloat := ACdeLine.Price;

  Que_CommandeL.ParamByName('PX_NET').AsFloat := ACdeLine.Price;

  Que_CommandeL.ParamByName('POINTURE').AsString := '';
  Que_CommandeL.ParamByName('LONGUEUR').AsString := '';
  Que_CommandeL.ParamByName('MONTAGE_FIXATIONS').AsInteger := 1;
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

FUNCTION TDm_Common.GetOrCreatePayID(sPayNom, sPayCode: STRING): integer;
var
  vQuery:  TIBOQuery;
BEGIN
  Result := 0;
  TRY
    if Que_Tmp.Active then
      Que_Tmp.Close();

    // on cherche d'abord par code pays, si on ne trouve pas on cherche par nom du pays
    if sPayCode <> '' then
    begin
      Que_Tmp.SQL.Clear();
      Que_Tmp.SQL.Add('SELECT MIN(PAY_ID)');
      Que_Tmp.SQL.Add('FROM GENPAYS');
      Que_Tmp.SQL.Add('JOIN K ON K_ID = PAY_ID AND K_ENABLED = 1');
      Que_Tmp.SQL.Add('WHERE PAY_CODE = :ACODE;');
      Que_Tmp.ParamByName('ACODE').AsString := UpperCase(sPayCode);
      Que_Tmp.Open();

      if not Que_Tmp.Eof then
      begin
        Result := Que_Tmp.Fields[0].AsInteger;
      end;
      Que_Tmp.Close();
    end;

    // si pas trouvé on cherche par le nom du pays
    if Result = 0 then
    begin
      Que_Tmp.SQL.Clear();
      Que_Tmp.SQL.Add('SELECT MIN(PAY_ID)');
      Que_Tmp.SQL.Add('FROM GENPAYS');
      Que_Tmp.SQL.Add('JOIN K ON K_ID = PAY_ID AND K_ENABLED = 1');
      Que_Tmp.SQL.Add('WHERE PAY_NOM = :ANAME;');
      Que_Tmp.ParamByName('ANAME').AsString := UpperCase(sPayNom);
      Que_Tmp.Open();

      if not Que_Tmp.Eof then
      begin
        Result := Que_Tmp.Fields[0].AsInteger;
      end;
      Que_Tmp.Close();
    end;

    // si toujours pas trouvé on insère le pays
    if Result = 0 then
    begin
      vQuery := TIBOQuery.Create(nil);
      try
        vQuery.IB_Connection := Ginkoia;
        vQuery.IB_Transaction := IbT_Modif;
        try
          vQuery.SQL.Text := 'INSERT INTO GENPAYS (PAY_ID, PAY_NOM, PAY_CODE) VALUES (:PAYID, :PAYNOM, :PAYCODE);';

          vQuery.ParamByName('PAYID').AsInteger    := NewK('GENPAYS');
          vQuery.ParamByName('PAYNOM').AsString   := sPayNom;
          vQuery.ParamByName('PAYCODE').AsString  := sPayCode;

          vQuery.ExecSQL;
        except
          on E : Exception do
            Exception.Create('GetOrCreatePayID -> ' + E.Message);
        end;
      finally
        FreeAndNil(vQuery);
      end;
    end;
  EXCEPT
  END;
END;

function TDm_Common.GetOrderClause(out bUnSeulResultat: Boolean): String;
var
  vPriorityPolicy: Integer;
begin
  bUnSeulResultat := False;
  vPriorityPolicy := Dm_Common.GetParamInteger(234);
  case vPriorityPolicy of
    0:
      bUnSeulResultat := True;
    1:
      Result := ' ORDER BY CLT_PREMIERPASS ';
    2:
      Result := ' ORDER BY CLT_PREMIERPASS DESC ';
    3:
      Result := ' ORDER BY CLT_ID DESC ';
  else
    raise Exception.Create('Politique d''ordonnancement pour les clients inconnue');
  end;
end;

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

procedure TDm_Common.Check_Mode_K_VERSION;
var
  vK_ENABLED: string;
  vVERSION_ID: boolean;
  vDependance_VERSION_ID: boolean;
  QueTmp: TIBOQuery;
begin

  if (FGestion_K_VERSION = TKNone) then
  begin
    vK_ENABLED := 'int32';
    vVERSION_ID := false;
    vDependance_VERSION_ID := false;

    QueTmp := TIBOQuery.Create(Self);
    try
      QueTmp.IB_Connection := Ginkoia;

        //----------------------------------------------
      QueTmp.close;
      QueTmp.SQL.Clear;
      QueTmp.SQL.Add('SELECT r.RDB$RELATION_NAME,  ');
      QueTmp.SQL.Add('     r.RDB$FIELD_NAME,       ');
      QueTmp.SQL.Add('     f.RDB$FIELD_TYPE,       ');
      QueTmp.SQL.Add('     f.RDB$FIELD_SUB_TYPE,   ');
      QueTmp.SQL.Add('     f.RDB$FIELD_LENGTH      ');
      QueTmp.SQL.Add(' FROM RDB$RELATION_FIELDS r  ');
      QueTmp.SQL.Add(' JOIN RDB$FIELDS f ON r.RDB$FIELD_SOURCE = f.RDB$FIELD_NAME         ');
      QueTmp.SQL.Add(' WHERE r.RDB$RELATION_NAME=''K'' AND r.RDB$FIELD_NAME=''K_VERSION'' ');
      QueTmp.open();
      if not (QueTmp.eof) then
      begin
        if QueTmp.FieldByName('RDB$FIELD_TYPE').asinteger = 16 then
          vK_ENABLED := 'int64'
        else
        begin
          FGestion_K_VERSION := TKV32;
          exit;
        end;
      end;

      QueTmp.close;
      QueTmp.SQL.Clear;
      QueTmp.SQL.Add('SELECT * FROM RDB$GENERATORS WHERE RDB$GENERATOR_NAME=''VERSION_ID'' ');
      QueTmp.open();
      if not (QueTmp.eof) then
        vVERSION_ID := true
      else
        exit;

      QueTmp.close;
      QueTmp.SQL.Clear;
      if (vVERSION_ID) then
      begin
        QueTmp.close;
        QueTmp.SQL.Clear;
        QueTmp.SQL.Add('SELECT * FROM RDB$DEPENDENCIES WHERE RDB$DEPENDED_ON_NAME=''VERSION_ID'' AND RDB$DEPENDENT_NAME=''PR_UPDATEK'' ');
        QueTmp.open();
        if not (QueTmp.eof) then
          vDependance_VERSION_ID := true
        else
          exit;
      end;

        // On peut également controler qu'il est dans sa tranche etc...
      QueTmp.close;
    finally
      QueTmp.Free;

      if (vK_ENABLED = 'int64') and (vVERSION_ID) and (vDependance_VERSION_ID) then
        FGestion_K_VERSION := TKV64;
    end;
  end;
end;

// Déclaration de la License Key SecureBlackBox
initialization
  SetLicenseKey('4FDA4556348ED2F45F1A6BE199EFA3FC3E0762DC70E138047C3B51E1E80AF73E'
    + '93572E6216C39B769CEC821C38E3F660EF222820EB6DC3EC912C5A390AED971F'
    + 'A50EEC92E376F7E22023CC1D530D5D371DCDDE03227F87D3F3D4826E2D6AA06D'
    + 'B50E61E257CDFE8E765407EAE1E0F1FDBB1B4FF9990A0F04F9FA64A8FAC82136'
    + '403D6B107DD4D7F48D72AB0F923FB45983BAA94A86FDE7E694D1BA649DD3564F'
    + '77AB88F07594D1B395FF0AC6A83699F048F23D6473D086BB5BE09F753CDE3694'
    + 'CCED24109146D7750699FDDEB53BE57951D0326B185A592E9BB3BAE89260237D'
    + '7C3198B98FDC6C7997AF9E673F307FAADE5D04FF8646E4E7B9059B6285390C8C');

  SetLicenseKey('4003D46B2B8444C662FA106C95792805D3E87D27FC53D6E57C3050AEA3E7375A' +
    'E9D03CD909F3120E8E740B4510CEA0E5D3303E83DD28EFEB5862603B18E7EF46' +
    '2FA3CE11BDECA8DC271B63F7F53D6EEEA8709B45130709DC97A73B9EFD3A8D92' +
    'DF286D7B55C02D26322D76D4E0312936C177419931345AED6B3A298774A71B05' +
    'F4DE9D00FCF9DC55F907219D5AB67032F7D184F4CD069CE39F28E60AE4DA6034' +
    'B434939F74F61535C602116CFAEBF228F6477B7D20D7FC43D8502ADA45359169' +
    '3D708AFDAB7A08DD8A2D3092082466DA583EF082625E8C3820BE5EF5B48D45B2' +
    'F76D49B11FE99F2295F677A8F3BD84A4560E73C231803D74EAFE53105B38017F');
END.

