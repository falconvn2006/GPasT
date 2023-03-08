UNIT UGUID;

INTERFACE

USES
    Xml_Unit,
    IcXMLParser,
    //Debut Uses Perso
    UpostXe,
    GestionJetonLaunch,
    //Fin Uses Perso
    comobj,
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    StdCtrls, Db, IBCustomDataSet, IBQuery, IBDatabase, IBSQL, ComCtrls, Variants,
    CheckLst, wwriched, wwDBRichEditRv, ExtCtrls, RzPanel, Inifiles, StrUtils,
    IBStoredProc, DateUtils,
    IdHTTP, IdCompressorZLib, IdURI, IdComponent, uCommunicationAPI, DelosQPMAgentDatabases, XMLDoc, VDossier,
    ClassDossier, listbase, AddDossier_frm,
    uApi;

Const
  cRC              = #13#10;
  cFormatDT = 'mm/dd/yyyy hh:nn:ss';

  cSecGENERAL = 'GENERAL';
  cSecLAMES = 'LAMES';
  cSecDIRECTORY = 'DIRECTORY';

  cItmLECTEURLAME = 'FLecteurLame';
  cGinkoiaTools = 'GinkoiaTools';
  cAPIKEY = 'ApiKey';
  cAPIURL = 'ApiUrl';
  cItmDATABASEMAINTENANCE = 'DATABASEMAINTENANCE';
  cItmURLSOURCEPATCH = 'URLSOURCEPATCH';
  cItmLAMESOURCEPATCH = 'LAMESOURCEPATCH';
  cItmSEARCHIN = 'SEARCHIN';
  cItmMaintenanceLog = 'LOGMAINTENANCE';
  cItmBaseMaintenance = 'USEMAINTENANCE';
  cItmApiUrlMaintenance = 'APIURLMAINTENANCE';

  cEndLine = '****************************************************';

  cUrlSourcePatch = '%s/%s/script%d.SQL';
  cFileNameSql = '%s:\EAI\MAJ\Patch\%s\script%d.SQL';

  cSql_S_genversion = 'SELECT VER_VERSION FROM GENVERSION WHERE VER_DATE = (SELECT MAX(VER_DATE) FROM GENVERSION)';

  cSql_S_SyncBase_Magasins = 'SELECT MAGA_ID' + cRC +
                             'FROM MAGASINS' + cRC +
                             'WHERE MAGA_MAGID_GINKOIA = :PMAGAMAGIDGINKOIA' + cRC +
                             'AND MAGA_DOSSID = :PMAGADOSSID';

  cSql_S_SyncBase_MagasinsPoste = 'SELECT MAGA_ID, POSTES.*' + cRC +
                                  'FROM MAGASINS' + cRC +
                                  'LEFT OUTER JOIN POSTES ON (POST_MAGAID=MAGA_ID)' + cRC +
                                  'WHERE MAGA_DOSSID = :PMAGADOSSID' + cRC +
                                  'AND MAGA_MAGID_GINKOIA = :PMAGAMAGIDGINKOIA';

  cSql_I_SynchroGnkToPostes = 'INSERT INTO POSTES (' + cRC +
                               'POST_ID,' + cRC +
                               'POST_POSID,' + cRC +
                               'POST_MAGAID,' + cRC +
                               'POST_NOM,' + cRC +
                               'POST_INFO,' + cRC +
                               'POST_COMPTA,' + cRC +
                               'POST_PTYPID,' + cRC +
                               'POST_DATEC,' + cRC +
                               'POST_DATEM,' + cRC +
                               'POST_ENABLE,' + cRC +
                               'POST_CASH_DOITBASCULER,' + cRc +
                               'POST_CASH_CAISSEDEFAULT,' + cRc +
                               'POST_CASH_DATEBASCULE,' + cRc +
                               'POST_CASH_DATEEFFECTIVEBASCULE,' + cRc +
                               'POST_CASH_BASCULESTATUT' + cRc +
                               ') VALUES (' + cRC +
                               ':PPOSTID,' + cRC +
                               ':PPOSTPOSID,' + cRC +
                               ':PPOSTMAGAID,' + cRC +
                               ':PPOSTNOM,' + cRC +
                               ':PPOSTINFO,' + cRC +
                               ':PPOSTCOMPTA,' + cRC +
                               ':PPOSTPTYPID,' + cRC +
                               ':PPOSTDATEC,' + cRC +
                               ':PPOSTDATEM,' + cRC +
                               ':PPOSTENABLE,' + cRC +
                               ':PPOST_CASH_DOITBASCULER,' + cRc +
                               ':PPOST_CASH_CAISSEDEFAULT,' + cRc +
                               ':PPOST_CASH_DATEBASCULE,' + cRc +
                               ':PPOST_CASH_DATEEFFECTIVEBASCULE,' + cRc +
                               ':PPOST_CASH_BASCULESTATUT' + cRc +
                               ')';

  cSql_U_SynchroGnkToPostes = 'UPDATE POSTES SET' + cRC +
                              'POST_NOM=:PPOSTNOM,' + cRC +
                              'POST_INFO=:PPOSTINFO,' + cRC +
                              'POST_COMPTA=:PPOSTCOMPTA,' + cRC +
                              'POST_PTYPID=:PPOSTPTYPID,' + cRC +
                              'POST_DATEM=:PPOSTDATEM,' + cRC +
                              'POST_ENABLE=:PPOSTENABLE,' + cRC +
                              'POST_CASH_DOITBASCULER=:PPOST_CASH_DOITBASCULER,' + cRc +
                              'POST_CASH_CAISSEDEFAULT=:PPOST_CASH_CAISSEDEFAULT,' + cRc +
                              'POST_CASH_DATEBASCULE=:PPOST_CASH_DATEBASCULE,' + cRc +
                              'POST_CASH_DATEEFFECTIVEBASCULE=:PPOST_CASH_DATEEFFECTIVEBASCULE,' + cRc +
                              'POST_CASH_BASCULESTATUT=:PPOST_CASH_BASCULESTATUT' + cRc +
                              'WHERE POST_ID=:PPOSTID';

  cSql_I_magasins = 'INSERT INTO MAGASINS (' + cRC +
                    'MAGA_ID,' + cRC +
                    'MAGA_DOSSID,' + cRC +
                    'MAGA_MAGID_GINKOIA,' + cRC +
                    'MAGA_NOM,' + cRC +
                    'MAGA_ENSEIGNE,' + cRC +
                    'MAGA_CODEADH,' + cRC +
                    'MAGA_MAGCODE,' + cRC +
                    'MAGA_CODETIERS,' + cRC +
                    'MAGA_K_ENABLED,' + cRC +
                    'MAGA_CASH_PARAMACHIEVE,' + cRC +
                    'MAGA_CASH_DATEBASCULE' + cRC +
                    ') VALUES (' + cRC +
                    ':PMAGAID,' + cRC +
                    ':PMAGADOSSID,' + cRC +
                    ':PMAGAMAGIDGINKOIA,' + cRC +
                    ':PMAGANOM,' + cRC +
                    ':PMAGAENSEIGNE,' + cRC +
                    ':PMAGACODEADH,' + cRC +
                    ':PMAGAMAGCODE,' + cRC +
                    ':PMAGATIERS,' + cRC +
                    ':PMAGAKENABLED,' + cRC +
                    ':PMAGA_CASH_PARAMACHIEVE,' + cRC +
                    ':PMAGA_CASH_DATEBASCULE' + cRC +
                    ')';

  cSql_U_magasins = 'UPDATE MAGASINS SET' + cRC +
                    'MAGA_NOM=:PMAGANOM,' + cRC +
                    'MAGA_ENSEIGNE=:PMAGAENSEIGNE,' + cRC +
                    'MAGA_CODEADH=:PMAGACODEADH,' + cRC +
                    'MAGA_MAGCODE=:PMAGAMAGCODE,' + cRC +
                    'MAGA_CODETIERS=:PMAGATIERS,' + cRC +
                    'MAGA_MAGID_GINKOIA=:PMAGAMAGIDGINKOIA,' + cRC +
                    'MAGA_K_ENABLED=:PMAGAKENABLED,' + cRC +
                    'MAGA_CASH_PARAMACHIEVE=:PMAGA_CASH_PARAMACHIEVE,' + cRC +
                    'MAGA_CASH_DATEBASCULE=:PMAGA_CASH_DATEBASCULE' + cRC +
                    'WHERE MAGA_DOSSID=:PMAGADOSSID' + cRC +
                    'and MAGA_ID=:PMAGAID';

  cSql_S_SyncBase_GenBases =  'Select' + cRC +
                              '	BAS_ID,' + cRC +
                              '	BAS_NOM,' + cRC +
                              '	BAS_IDENT,' + cRC +
                              '	BAS_JETON,' + cRC +
                              '	BAS_PLAGE,' + cRC +
                              '	BAS_GUID,' + cRC +
                              '	BAS_MAGID,' + cRC +
                              '	BAS_CODETIERS,' + cRC +
                              '	LAU_HEURE1,' + cRC +
                              '	LAU_H1,' + cRC +
                              '	LAU_HEURE2,' + cRC +
                              '	LAU_H2' + cRC +
                              'From GENBASES' + cRC +
                              'Join K on (K_ID = BAS_ID and K_ENABLED = 1)' + cRC +
                              'Left Join GENLAUNCH on (BAS_ID = LAU_BASID)' + cRC +
                              'Where BAS_ID <> 0';

  cSql_S_SyncBase_Emetteur = 'Select EMET_ID' + cRC +
                             'From EMETTEUR' + cRC +
                             'Where EMET_GUID = :PEMETGUID' + cRC +
                             'And EMET_DOSSID = :PEMETDOSSID';

  cSql_U_SyncBase_Emetteur = 'Update emetteur set' + cRC +
                             'EMET_NOM = :PEMETNOM,' + cRC +
                             'EMET_MAGID = :PEMETMAGID,' + cRC +
                             'EMET_TIERSCEGID = :PEMETTIERSCEGID,' + cRC +
                             'EMET_IDENT = :PEMETIDENT,' + cRC +
                             'EMET_JETON = :PEMETJETON,' + cRC +
                             'EMET_PLAGE = :PEMETPLAGE,' + cRC +
                             'EMET_HEURE1 = :PEMETHEURE1,' + cRC +
                             'EMET_H1 = :PEMETH1,' + cRC +
                             'EMET_HEURE2 = :PEMETHEURE2,' + cRC +
                             'EMET_H2 = :PEMETH2,' + cRC +
                             'EMET_VERSID = :PEMETVERSID' + cRC +
                             'Where EMET_ID = :PEMETID';

  cSql_I_Modules_Magasins = 'INSERT INTO MODULES_MAGASINS (' + cRC +
                            'MMAG_MODUID,' + cRC +
                            'MMAG_MAGAID,' + cRC +
                            'MMAG_EXPDATE,' + cRC +
                            'MMAG_KENABLED,' + cRC +
                            'MMAG_UGMID' + cRC +
                            ') VALUES (' + cRC +
                            ':PMMAGMODUID,' + cRC +
                            ':PMMAGMAGAID,' + cRC +
                            ':PMMAGEXPDATE,' + cRC +
                            ':PMMAGKENABLED,' + cRC +
                            ':PMMAGUGMID' + cRC +
                            ')';
                            
  cSql_U_Modules_Magasins = 'UPDATE MODULES_MAGASINS SET' + cRC +
                            'MMAG_EXPDATE = :PMMAGEXPDATE,' + cRC +
                            'MMAG_KENABLED = :PMMAGKENABLED,' + cRC +
                            'MMAG_UGMID = :PMMAGUGMID' + cRC +
                            'WHERE' + cRC +
                            'MMAG_MODUID = :PMMAGMODUID' + cRC +
                            'AND' + cRC +
                            'MMAG_MAGAID = :PMMAGMAGAID';

  cSql_I_Emetteur = 'insert into emetteur (' + cRC +
                    'EMET_NOM,' + cRC +
                    'EMET_JETON,' + cRC +
                    'EMET_IDENT,' + cRC +
                    'EMET_PLAGE,' + cRC +
                    'EMET_GUID,' + cRC +
                    'EMET_DONNEES,' + cRC +
                    'EMET_VERSID,' + cRC +
                    'EMET_INSTALL,' + cRC +
                    'EMET_MAGID,' + cRC +
                    'EMET_PATCH,' + cRC +
                    'EMET_VERSION_MAX,' + cRC +
                    'EMET_SPE_PATCH,' + cRC +
                    'EMET_SPE_FAIT,' + cRC +
                    'EMET_BCKOK,' + cRC +
                    'EMET_DERNBCK,' + cRC +
                    'EMET_RESBCK,' + cRC +
                    'EMET_TIERSCEGID,' + cRC +
                    'EMET_TYPEREPLICATION,' + cRC +
                    'EMET_NONREPLICATION,' + cRC +
                    'EMET_DEBUTNONREPLICATION,' + cRC +
                    'EMET_FINNONREPLICATION,' + cRC +
                    'EMET_SERVEURSECOURS,' + cRC +
                    'EMET_HEURE1,' + cRC +
                    'EMET_H1,' + cRC +
                    'EMET_HEURE2,' + cRC +
                    'EMET_H2,' + cRC +
                    'EMET_INFOSUP,' + cRC +
                    'EMET_EMAIL,' + cRC +
                    'EMET_DOSSID,' + cRC +
                    'EMET_ID' + cRC +
                    ') Values (' + cRC +
                    ':PEMETNOM,' + cRC +
                    ':PEMETJETON,' + cRC +
                    ':PEMETIDENT,' + cRC +
                    ':PEMETPLAGE,' + cRC +
                    ':PEMETGUID,' + cRC +
                    ':PEMETDONNEES,' + cRC +
                    ':PEMETVERSID,' + cRC +
                    ':PEMETINSTALL,' + cRC +
                    ':PEMETMAGID,' + cRC +
                    ':PEMETPATCH,' + cRC +
                    ':PEMETVERSION_MAX,' + cRC +
                    ':PEMETSPEPATCH,' + cRC +
                    ':PEMETSPEFAIT,' + cRC +
                    ':PEMETBCKOK,' + cRC +
                    ':PEMETDERNBCK,' + cRC +
                    ':PEMETRESBCK,' + cRC +
                    ':PEMETTIERSCEGID,' + cRC +
                    ':PEMETTYPEREPLICATION,' + cRC +
                    ':PEMETNONREPLICATION,' + cRC +
                    ':PEMETDEBUTNONREPLICATION,' + cRC +
                    ':PEMETFINNONREPLICATION,' + cRC +
                    ':PEMETSERVEURSECOURS,' + cRC +
                    ':PEMETHEURE1,' + cRC +
                    ':PEMETH1,' + cRC +
                    ':PEMETHEURE2,' + cRC +
                    ':PEMETH2,' + cRC +
                    ':PEMETINFOSUP,' + cRC +
                    ':PEMETEMAIL,' + cRC +
                    ':PEMETDOSSID,' + cRC +
                    ':PEMETID' + cRC +
                    ')';

  cSql_S_SyncBase_Modules = 'SELECT' + cRC +
                              'MODU_ID' + cRC +
                            'FROM MODULES' + cRC +
                            'WHERE MODU_NOM = :PMODUNOM';

  cSql_I_SyncBase_Modules = 'INSERT INTO MODULES (' + cRC +
                            'MODU_ID,' + cRC +
                            'MODU_NOM,' + cRC +
                            'MODU_COMMENT,' + cRC +
                            'MODU_K_ENABLED' + cRC +
                            ') VALUES (' + cRC +
                            ':PMODUID,' + cRC +
                            ':PMODUNOM,' + cRC +
                            ':PMODUCOMMENT,' + cRC +
                            ':PMODUKENABLED' + cRC +
                            ')';

  cSql_U_SyncBase_Modules = 'UPDATE MODULES SET' + cRC +
                            'MODU_COMMENT=:PMODUCOMMENT,' + cRC +
                            'MODU_K_ENABLED=:PMODUKENABLED' + cRC +
                            'WHERE MODU_ID=:PMODUID';

  cSql_S_SyncBase_Modules_Magasins =  'SELECT' + cRC +
                                        'MMAG_MODUID,' + cRC +
                                        'MMAG_MAGAID,' + cRC +
                                        'MMAG_EXPDATE,' + cRC +
                                        'MMAG_KENABLED' + cRC +
                                      'FROM MODULES_MAGASINS' + cRC +
                                      ' JOIN MODULES ON (MODU_ID = MMAG_MODUID)' + cRC +
                                      ' JOIN MAGASINS ON (MAGA_ID = MMAG_MAGAID)' + cRC +
                                      'WHERE MODU_NOM = :PMODUNOM' + cRC +
                                      'AND MAGA_MAGID_GINKOIA = :PMAGAMAGID_GINKOIA' + cRC +
                                      'AND MAGA_DOSSID = :PMAGADOSSID';

  cSql_D_SyncBase_EMETTEUR = 'Delete From EMETTEUR Where EMET_ID = :PEMETID';

  cSql_D_SyncBase_SPLITTAGE_LOG = 'Delete From SPLITTAGE_LOG Where SPLI_EMETID = :PEMETID';

TYPE
  TFieldWhere = (fwPOS, fwMAGID, fwNone);
  TFieldResult = (frPRM_ID, frPRM_INTEGER, frPRM_FLOAT, frPRM_STRING);

  TGestion_K_Version = (tKNone, tKV32, tKV64);

  TForm1 = CLASS(TForm)
      Lab_Base: TLabel;
      data: TIBDatabase;
      tran: TIBTransaction;
      Que_Exists: TIBQuery;
      Que_GUID: TIBQuery;
      Que_ModifK: TIBQuery;
      Que_ModifGUID: TIBQuery;
      IBQue_Base: TIBQuery;
      IBQue_Soc: TIBQuery;
      Que_Version: TIBQuery;
      SQL: TIBSQL;
      Lab_Etape: TLabel;
      IBQue_LaBaseNew: TIBQuery;
      Que_BaseNew: TIBQuery;
      Label3: TLabel;
      Memo1: TMemo;
      IBQue_Param: TIBQuery;
      Que_newid1: TIBQuery;
      Que_newid2: TIBQuery;
      Que_newid3: TIBQuery;
      Que_GUIDBASE: TIBQuery;
      tran2: TIBTransaction;
      Que_existsNom: TIBQuery;
      Que_KTBID: TIBQuery;
      Od: TOpenDialog;
      OdDatabases: TOpenDialog;
      IBQue_Suite: TIBQuery;
      Que_logMag: TIBQuery;
      Que_LogPoste: TIBQuery;
      Chp_Rtf: TwwDBRichEditRv;
      IBQue_Adresse: TIBQuery;
      ds_adresse: TDataSource;
      Pan_Top: TRzPanel;
      PB: TProgressBar;
      Go: TButton;
      BtnVersion: TButton;
      BtnBase: TButton;
      QryGENMAGASIN: TIBQuery;
      QryGENLAUNCH: TIBQuery;
      DB_MAINTENANCE: TIBDatabase;
      IBTransMaintenance: TIBTransaction;
      QryGenMaintenance: TIBQuery;
      LstVwLame: TListView;
      pnlDebug: TPanel;
      pnlTech: TPanel;
      Btn_1: TButton;
      Edit1: TEdit;
      Splitter: TSplitter;
      QryGenData: TIBQuery;
      QryGENVERSION: TIBQuery;
      RdGrpSearchIn: TRadioGroup;
      StBrMain: TStatusBar;
      STP_NOUVELID: TIBStoredProc;
      GrpBxMaintenance: TGroupBox;
      ChkBxBaseMaintenance: TCheckBox;
      ChkBxMaintenanceLog: TCheckBox;
      IBQue_ListGroupe: TIBQuery;
      QrySelectMaintenance: TIBQuery;
      IBQue_GrpMag: TIBQuery;
      tmr1: TTimer;
    QrySelectGinkoia: TIBQuery;
    Btn_: TButton;
    Que_LogPostePOS_NOM: TIBStringField;
    IBQue_GrpMagUGM_ID: TIntegerField;
    IBQue_GrpMagUGG_NOM: TIBStringField;
    IBQue_GrpMagUGM_DATE: TDateTimeField;
    IBQue_GrpMagK_ENABLED: TIntegerField;
    IBQue_ListGroupeUGG_ID: TIntegerField;
    IBQue_ListGroupeUGG_NOM: TIBStringField;
    IBQue_ListGroupeUGG_COMMENT: TIBStringField;
    Que_ExistsNB: TIntegerField;
    Que_GUIDBAS_ID: TIntegerField;
    Que_GUIDBAS_NOM: TIBStringField;
    Que_GUIDBAS_IDENT: TIBStringField;
    Que_GUIDBAS_JETON: TIntegerField;
    Que_GUIDBAS_PLAGE: TIBStringField;
    Que_GUIDBAS_SENDER: TIBStringField;
    Que_GUIDBAS_GUID: TIBStringField;
    Que_GUIDBAS_CENTRALE: TIBStringField;
    Que_GUIDBAS_NOMPOURNOUS: TIBStringField;
    Que_GUIDBAS_RGPID: TIntegerField;
    Que_GUIDBAS_TYPE: TIntegerField;
    Que_GUIDBAS_MAGID: TIntegerField;
    Que_GUIDBAS_SECBASID: TIntegerField;
    Que_GUIDBAS_SYNCHRO: TIntegerField;
    Que_GUIDBAS_SECBASEID: TIntegerField;
    Que_GUIDBAS_REPLOG: TIntegerField;
    Que_GUIDBAS_CODETIERS: TIBStringField;
    Que_logMagMAG_ID: TIntegerField;
    Que_logMagMAG_IDENT: TIBStringField;
    Que_logMagMAG_NOM: TIBStringField;
    IBQue_SocSOC_NOM: TIBStringField;
    IBQue_AdresseADR_ID: TIntegerField;
    IBQue_AdresseADR_LIGNE: TIBStringField;
    IBQue_AdresseADR_VILID: TIntegerField;
    IBQue_AdresseADR_TEL: TIBStringField;
    IBQue_AdresseADR_FAX: TIBStringField;
    IBQue_AdresseADR_GSM: TIBStringField;
    IBQue_AdresseADR_EMAIL: TIBStringField;
    IBQue_AdresseADR_COMMENT: TIBStringField;
    IBQue_AdresseADR_TEL1_TYPE: TIntegerField;
    IBQue_AdresseADR_TEL2_TYPE: TIntegerField;
    IBQue_AdresseADR_TEL3_TYPE: TIntegerField;
    Que_VersionVER_VERSION: TIBStringField;
    IBQue_BaseBAS_ID: TIntegerField;
    IBQue_BaseBAS_NOM: TIBStringField;
    IBQue_BaseBAS_IDENT: TIBStringField;
    IBQue_BaseBAS_GUID: TIBStringField;
    IBQue_BaseBAS_JETON: TIntegerField;
    IBQue_BaseBAS_PLAGE: TIBStringField;
    IBQue_BaseBAS_MAGID: TIntegerField;
    IBQue_BaseBAS_CODETIERS: TIBStringField;
    Que_newid2ID: TLargeintField;
    IBQue_LaBaseNewBAS_ID: TIntegerField;
    IBQue_LaBaseNewBAS_NOM: TIBStringField;
    IBQue_LaBaseNewBAS_IDENT: TIBStringField;
    IBQue_LaBaseNewBAS_GUID: TIBStringField;
    IBQue_ParamPRM_ID: TIntegerField;
    IBQue_ParamPRM_CODE: TIntegerField;
    IBQue_ParamPRM_INTEGER: TIntegerField;
    IBQue_ParamPRM_FLOAT: TFloatField;
    IBQue_ParamPRM_STRING: TIBStringField;
    IBQue_ParamPRM_TYPE: TIntegerField;
    IBQue_ParamPRM_MAGID: TIntegerField;
    IBQue_ParamPRM_INFO: TIBStringField;
    IBQue_ParamPRM_POS: TIntegerField;
    Que_BaseNewBAS_ID: TIntegerField;
    Que_BaseNewBAS_NOM: TIBStringField;
    Que_BaseNewBAS_IDENT: TIBStringField;
    Que_BaseNewBAS_GUID: TIBStringField;
    Que_newid1KTB_ID: TIntegerField;
    Que_GUIDBASEBAS_GUID: TIBStringField;
    Que_KTBIDKTB_ID: TIntegerField;
    Btn_Liste: TButton;
    Btn_Auto: TButton;
    Btn_CreateListe: TButton;
    SD_XML: TSaveDialog;
    SQL2: TIBSQL;
    BtnEasyManu: TButton;
    Btn_SyncBase: TButton;
    Btn_SyncBaseByApiMaintenance: TButton;

      PROCEDURE GoClick(Sender: TObject);
      PROCEDURE FormCreate(Sender: TObject);
      PROCEDURE BtnBaseClick(Sender: TObject);
      PROCEDURE BtnVersionClick(Sender: TObject);
      procedure pnlDebugMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
      procedure Btn_1Click(Sender: TObject);
      procedure ChkBxBaseMaintenanceClick(Sender: TObject);
      // procedure Tim(Sender: TObject);
      procedure tmr1Timer(Sender: TObject);
      procedure Btn_Click(Sender: TObject);
      procedure Btn_ListeClick(Sender: TObject);
      procedure Btn_AutoClick(Sender: TObject);
      procedure Btn_CreateListeClick(Sender: TObject);
      procedure FormDestroy(Sender: TObject);
    procedure BtnEasyManuClick(Sender: TObject);
    procedure Btn_SyncBaseClick(Sender: TObject);
    procedure Btn_SyncBaseByApiMaintenanceClick(Sender: TObject);
    private
      slError : TStringList;
      FDatabaseNameMaintenance: String;
      FURLSOURCEPATCH: String;
      FIsSourceScriptHTTP: Boolean;
      //FLAMESOURCEPATCH: String;
      FFirst: Boolean;
      FVersion6plus: Boolean;
      FFaitLeLog: Boolean;
      FLog: TStringlist;
      FLecteurLame: String;
      FDebug : Boolean;
      FApiUrlMaintenance : string;
      FAPIURL : string;
      FAPIKEY : String;
      FAuto          : Boolean;     // Parametre de passage en ligne de commande lancement dans 1s
      FAutoGO        : Boolean;     // s'il y a le parametre GO
      FNewAuto       : Boolean;
      FEasyAuto      : Boolean;
      FEasyManuel    : Boolean;
      FAutoVersion   : TFileName;   // valeur du parametre version=
      FAutoDatabase  : TFileName;   // valeur du parametre databse=
      FLastDataBaseSync: String;
      FGestion_K_VERSION : TGestion_K_Version;

      function IsInteger(Const S: String): Boolean;
      function SyncBase(Const ADOSS_ID: integer):string;        //SR - 11/07/2014 - Ajout d'une procédure de syncro pour Maintenance
      function SyncBaseByDllMaintenance(Const ADOSS_ID: integer):string; // Greg - 15/03/2021 - Méthode de syncro par l'api de la dll Maintenance.
      function GetComputerNameLocal: string;
      function GetDriveByLameDirectory(Const ADirectory: String): String;
      function GetGenParam(Const APRM_TYPE, APRM_CODE: integer; Const AFieldWhere: TFieldWhere; Const AValueFieldWhere: integer;
                           Const AFieldResult: TFieldResult; Const AResultZeroIfPRM_FLOATIsDateNull: Boolean = True;
                           Const AWithK_ENABLED: Boolean = True): Variant;

      procedure SearchDataBaseXML(Const ARootFolder: String; Const AListFiles: TStringList; Const ASearchIn: integer);
      //PROCEDURE parcour(Const AMachine, ADirectory: String); //--> Deprecated
      function parcour2(Const AMachine, ADirectory: String): integer;


      PROCEDURE CreationGUID(NomClient, LaCentrale: STRING);
      PROCEDURE AffecteYellis(Tc: Tconnexion; NomPourNous: STRING; Lamachine, LaCentrale: STRING);
      PROCEDURE ExecJob(Machine, databases: STRING);
      PROCEDURE TraiteXML(_Nom, _tipe, _data: STRING);

      PROCEDURE CreationLog(NomClient, LaMachine, LaCentrale: STRING);
      PROCEDURE traitement_rtf;
      //Fonction de lecture d'une valeur dans le fichier Ini
      //FUNCTION LecteurValeurIni(AFileIni,ASection,AIdent,ADefault:String):String; //--> Deprecated
      //Procedure de création de log
      Procedure LogDebug(FileLogName,Texte:String);

      //function traitechaine(S: string): string; //--> Deprecated

      function GetNewID(Const ATableName: String): integer;
      function LoadEasyPostProcedures():TXMLDocument;
      procedure LoadParams;
      procedure SaveParams;
      procedure Traitement_GO;
      procedure Traitement_Auto;
      procedure Traitement_Version;

      procedure GUID_WS(aGUID:string);
      procedure majMagCode;
      procedure majFTPArchivage;
      procedure ExecJobListe(Dossier : TDossier);
      function LoadBaseMaintenance : TDossiers;
      procedure Process(const Xml_DocOrdre: TXMLDocument; sCentrale: string);
      procedure doPatchNewMaj(sUrl, sGuid, sVersion : String);
      function isNewMaj(var sUrl, sGuid, sVersion : String) : boolean;

      function IsReplicationEASY:boolean;
      function GetGestion_K_VERSION: TGestion_K_Version;
    procedure Check_Mode_K_VERSION;
    public
      function IsJetonVersion(Const AVER_VERSION: String; Const AVER_REF: String = '11.3.0.1'): Boolean;
      function Download(const URL, DestFilename: String): Boolean;
      procedure IdHTTPWorkBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Int64);
      procedure IdHTTPWorkEnd(ASender: TObject; AWorkMode: TWorkMode);
      procedure IdHTTPWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
      FUNCTION Patch(i: integer; S: STRING): boolean;

      // dossiers Easy de la base Maintenance.
      function LoadBaseMaintenance_Easy(aDossID:integer=0): TDossiers;
      PROCEDURE Traitement_Databases_EASY_PAR_MAINTENANCE(aDossID:integer = 0);

      property Gestion_K_VERSION: TGestion_K_Version read GetGestion_K_VERSION;
    published
      property DatabaseNameMaintenance: String read FDatabaseNameMaintenance write FDatabaseNameMaintenance;
  end;

VAR
    Form1: TForm1;
    FichierLog : String;


IMPLEMENTATION

uses types, UVersion, uSearchTG,UWSClient, ShellAPI, LaunchProcess, ExecuteScript_frm, ChoixBaseEasy,
  u_Parser;

{$R *.DFM}

procedure TForm1.GUID_WS(aGUID:string);
var axmlstr:TStrings;
    i:integer;
    AQuery:TIBQuery;
    vBAS_ID:integer;
    vMAG_ID:integer;
begin
     axmlstr:=TStringList.Create(); // Construction du XML
     axmlstr.Add('<?xml version="1.0" encoding="UTF-8"?>');
     axmlstr.Add(Format('<guid>%s</guid>',[aGUID]));
     // le GUID donne une base qui doit donner à son tour les modules
     vBAS_ID:=0;
     vMAG_ID:=0;
     AQuery:=TIBQuery.Create(nil);
     try
       AQuery.Database:=data;
       AQuery.Transaction:=tran;
       AQuery.Close;
       AQuery.SQL.clear;
       AQuery.SQL.Add('SELECT * FROM GENBASES JOIN GENMAGASIN ON MAG_ID=BAS_MAGID WHERE BAS_GUID=:GUID AND BAS_ID<>0 AND MAG_ID<>0');
       AQuery.ParamByName('GUID').asstring:=aGUID;
       AQuery.Open;
       if not(AQuery.IsEmpty) then
         begin
              vBAS_ID   := AQuery.FieldByName('BAS_ID').asinteger;
              vMAG_ID   := AQuery.FieldByName('BAS_MAGID').asinteger;
              axmlstr.Add(Format('<mag_id>%d</mag_id>',[vMAG_ID]));
              axmlstr.Add(Format('<mag_nom>%s</mag_nom>',[AQuery.FieldByName('MAG_NOM').asstring]));
              axmlstr.Add(Format('<mag_enseigne>%s</mag_enseigne>',[AQuery.FieldByName('MAG_ENSEIGNE').asstring]));
         end;
        if (vBAS_ID<>0) then
          begin
               AQuery.Close;
               AQuery.SQL.clear;
               AQuery.SQL.Add('SELECT LAU_H1, LAU_H2, LAU_HEURE1, LAU_HEURE2 ');
               AQuery.SQL.Add(' FROM GENLAUNCH join k on (k_id=lau_id and k_enabled=1) ');
               AQuery.SQL.Add(' where LAU_BASID=:BASID ');
               AQuery.ParamByName('BASID').asinteger:=vBAS_ID;
               AQuery.Open;
               if not(AQuery.IsEmpty) then
                   begin
                        axmlstr.Add(Format('<lau_h1>%s</lau_h1>',[AQuery.FieldByName('LAU_H1').asstring]));
                        axmlstr.Add(Format('<lau_h2>%s</lau_h2>',[AQuery.FieldByName('LAU_H2').asstring]));
                        axmlstr.Add(Format('<lau_heure1>%s</lau_heure1>',[AQuery.FieldByName('LAU_HEURE1').asstring]));
                        axmlstr.Add(Format('<lau_heure2>%s</lau_heure2>',[AQuery.FieldByName('LAU_HEURE2').asstring]));
                   end;
          end;
       if (vMAG_ID<>0) then
          begin
               AQuery.Close;
               AQuery.SQL.clear;
               AQuery.SQL.Add('SELECT UGG_NOM, UGM_DATE, K_ENABLED ');
               AQuery.SQL.Add('from UILGRPGINKOIAMAG Join k on (k_id=UGM_ID)      ');
               AQuery.SQL.Add('        Join UILGRPGINKOIA on (UGG_ID = UGM_UGGID) ');
               AQuery.SQL.Add(' WHERE UGM_MAGID = :PMAGID                         ');
               AQuery.ParamByName('PMAGID').asinteger:=vMAG_ID;
               AQuery.Open;
               if not(AQuery.IsEmpty) then
                 begin
                     axmlstr.Add('<modules_mag>');
                     AQuery.First;
                     while not(AQuery.eof) do
                          begin
                              axmlstr.Add('<module>');
                              for i:=0 to AQuery.FieldCount - 1 do
                                  begin
                                    axmlstr.Add(Format('<%s>%s</%s>',[AQuery.Fields[i].FieldName,AQuery.Fields[i].asstring,AQuery.Fields[i].FieldName]));
                                  end;
                              axmlstr.Add('</module>');
                              AQuery.Next;
                          end;
                       axmlstr.Add('</modules_mag>');
                 end;
          end;
          WPOST('http://192.168.10.184:8081/SrvMaintenance_WAD.c_Maintenance/Guid',axmlstr);
     finally
       AQuery.close;
       AQuery.Free;
     end;
end;


FUNCTION TForm1.Patch(i: integer; S: STRING): boolean;
VAR
    s1, s2, erreur: STRING;
BEGIN
    result := false;
    WHILE s <> '' DO
    BEGIN
        IF pos('<---->', S) > 0 THEN
        BEGIN
            S1 := trim(Copy(S, 1, pos('<---->', S) - 1));
            Delete(S, 1, pos('<---->', S) + 5);
        END
        ELSE
        BEGIN
            S1 := trim(S);
            S := '';
        END;
        IF s1 <> '' THEN
        BEGIN
            TRY
                if not Sql.Transaction.InTransaction then       //SR - 11/07/2014 - Passage au StartTransaction au lieu du Active := true;
                  Sql.Transaction.StartTransaction;
                Sql.SQL.Text := S1;
                Sql.ExecQuery;
                IF Sql.Transaction.InTransaction THEN
                    Sql.Transaction.Commit;
                //Sql.Transaction.Active := true;         //SR - 11/07/2014 -
            EXCEPT
                ON E: Exception DO
                BEGIN
                    IF Sql.Transaction.InTransaction THEN
                      SQL.Transaction.Rollback;             //SR - 11/07/2014 -
                    erreur := E.Message;

                    S1 := trim(S1) ;
                    S2 := Uppercase(S1);              // FL : Ce truc la passait S1 en majuscules et donc la proc entière !!!!  HOuuuuuuuuu !
                    
               // gestion des GENERATOR déja existants
                    IF copy(S2, 1, length('CREATE GENERATOR')) = 'CREATE GENERATOR' THEN
                    BEGIN
                    END
               // gestion des INDEX déja existants
                    ELSE IF Copy(S2, 1, length('CREATE INDEX')) = 'CREATE INDEX' THEN
                    BEGIN
                    END
           // gestion des TRIGGER déja existants
                    ELSE IF Copy(S2, 1, length('CREATE TRIGGER')) = 'CREATE TRIGGER' THEN
                    BEGIN
                    END
                    ELSE IF copy(S2, 1, length('CREATE PROCEDURE')) = 'CREATE PROCEDURE' THEN
                    BEGIN
                        delete(S1, 1, 6);
                        S1 := 'ALTER' + S1;
                        TRY
                            if not Sql.Transaction.InTransaction then       //SR - 11/07/2014 - Passage au StartTransaction au lieu du Active := true;
                              Sql.Transaction.StartTransaction;
                            Sql.SQL.Text := S1;
                            Sql.ExecQuery;
                            IF Sql.Transaction.InTransaction THEN
                                Sql.Transaction.Commit;
                            //Sql.Transaction.Active := true;               //SR - 11/07/2014 -
                        EXCEPT
                            ON E: Exception DO
                            BEGIN
                                IF Sql.Transaction.InTransaction THEN
                                  SQL.Transaction.Rollback;             //SR - 11/07/2014 -

                                slError.Add('Base:' + Lab_Base.caption + ' - Erreur sur le script' + Inttostr(i) + #10#13 + Erreur + Copy(S1, 1, 50));
//                                Application.messagebox(Pchar('Erreur sur le script' + Inttostr(i) + #10#13 + Erreur + Copy(S1, 1, 50)), ' impossible de continuer', mb_ok);
                                LogDebug(FichierLog,'Erreur sur le script' + Inttostr(i) + #10#13 + Erreur + Copy(S1, 1, 50));
                                result := true;
                                BREAK;
                            END;
                        END;
                    END
                    ELSE
                    BEGIN

                        slError.Add('Base:' + Lab_Base.caption + ' - Erreur sur le script' + Inttostr(i) + #10#13 + Erreur + Copy(S1, 1, 50));
//                        Application.messagebox(Pchar('Erreur sur le script' + Inttostr(i) + #10#13 + Erreur + Copy(S1, 1, 50)), ' impossible de continuer', mb_ok);
                        LogDebug(FichierLog,'Erreur sur le script' + Inttostr(i) + #10#13 + Erreur + Copy(S1, 1, 50));
                        result := true;
                        BREAK;
                    END;
                END;
            END
        END;
    END;
END;

procedure TForm1.pnlDebugMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   if Shift = [ssCtrl, ssAlt, ssLeft] then
     begin
       FDebug:= not FDebug;

       GrpBxMaintenance.Visible:= FDebug;

       if FDebug then
        begin
         pnlDebug.Caption:= 'Debug';
         GUID_WS('{98EFD11D-F308-4CA5-A31D-1415B3B20084}');
        end
       else
        pnlDebug.Caption:= '';
     end;
end;

procedure TForm1.SaveParams;
var
  vIniFile: TIniFile;
begin
  try
    vIniFile:= TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
    vIniFile.WriteString(cGinkoiaTools, cAPIURL, FAPIURL);
    vIniFile.WriteString(cGinkoiaTools, cAPIKEY, FAPIKEY);
  finally
    vIniFile.Free;
  end;
end;

procedure TForm1.SearchDataBaseXML(Const ARootFolder: String;
  Const AListFiles: TStringList; Const ASearchIn: integer);
var
  i, j: integer;
  vSearch: TSearching;
  vSL: TStringList;
  //vDir,
  //vSubStr,
  Buffer: String;
  //vT: TTime;
  //vAllow: Boolean;
begin
  AListFiles.Clear;
  vSearch:= TSearching.Create;
  vSL:= TStringList.Create;
  try
//    vT:= Now;
    vSearch.Searching(ARootFolder, '*.*', True, True);
    if vSearch.NbFoldersFound = 0 then
      Exit;
    for i:= Low(vSearch.TabInfoSearch) to High(vSearch.TabInfoSearch) do
      begin
        if vSearch.TabInfoSearch[i].PathFolder <> '' then
          begin
            Buffer:= StringReplace(vSearch.TabInfoSearch[i].PathFolder, ARootFolder, '', []);
            if (Trim(Buffer) <> '') and (Length(Buffer) >= 2) then
              begin
                case ASearchIn of
                  0:
                    begin
                      if (Buffer[1] = 'V') and (Buffer[2] <> '_') then
                        vSL.Append(vSearch.TabInfoSearch[i].PathFolder);
                    end;
                  1:
                    begin
                      if (Buffer[1] = 'V') and (Buffer[2] = '_') then
                        vSL.Append(vSearch.TabInfoSearch[i].PathFolder);
                    end;
                end;
              end;
          end;
      end;

    if vSL.Count = 0 then
      Exit;

    for i:= 0 to vSL.Count -1 do
      begin
        vSearch.Searching(vSL.Strings[i], '*.*', True, True);
        if vSearch.NbFoldersFound <> 0 then
          begin
            for j:= Low(vSearch.TabInfoSearch) to High(vSearch.TabInfoSearch) do
              begin
                if vSearch.TabInfoSearch[j].PathFolder <> '' then
                  vSL.Append(vSearch.TabInfoSearch[j].PathFolder);
              end;
          end;
      end;

    for i:= 0 to vSL.Count -1 do
      begin
        vSearch.Searching(vSL.Strings[i], 'DelosQPMAgent.Databases.xml', False, True);
        if vSearch.NbFilesFound <> 0 then
          begin
            for j:= Low(vSearch.TabInfoSearch) to High(vSearch.TabInfoSearch) do
              begin
                if (vSearch.TabInfoSearch[j].PathAndName <> '') and
                   (AListFiles.IndexOf(vSearch.TabInfoSearch[j].PathAndName) = -1) then
                 AListFiles.Append(vSearch.TabInfoSearch[j].PathAndName);
              end;
          end;
      end;

//    Memo1.Lines.Append(FormatDateTime('hh:nn:ss:zzz', Now - vT));
  finally
    FreeAndNil(vSearch);
    FreeAndNil(vSL);
  end;
end;

procedure TForm1.ChkBxBaseMaintenanceClick(Sender: TObject);
begin
  if ChkBxBaseMaintenance.Checked then
    begin
      DB_MAINTENANCE.DatabaseName:= FDatabaseNameMaintenance;

      try
        DB_MAINTENANCE.Open;
      except
        ChkBxBaseMaintenance.Checked:= False;
        Raise;
      end;
    end
  else
    DB_MAINTENANCE.Close;
end;

PROCEDURE TForm1.CreationGUID(NomClient, LaCentrale: STRING);
VAR
    ktbid, Id: Integer;
BEGIN
  // teste de l'existance du GUID dans la table GenBase
  LogDebug(FichierLog,'Création des GUID (NomClient: '+NomClient+' ; LaCentrale: '+LaCentrale);

  try
    if not tran.InTransaction then     //SR - 11/07/2014 Ajout condition
      tran.StartTransaction;
    if not tran2.InTransaction then     //SR - 11/07/2014 Ajout condition
      tran2.StartTransaction;

    Que_Exists.Open;
    Lab_Etape.caption := 'Création des GUID';
    Lab_Etape.Update;
    IF Que_ExistsNB.AsInteger > 0 THEN
    BEGIN
      caption := ' Que_GUID 1';
      Que_GUID.open;
      Que_GUID.first;
      WHILE NOT Que_GUID.eof DO
      BEGIN
        IF trim(Que_GUIDBAS_GUID.AsString) = '' THEN
        BEGIN
            caption := ' Que_GUID 1-1';
        // recherche si le guid n'est pas dans les parametres
            Que_ModifK.paramByName('ID').AsInteger := Que_GUIDBAS_ID.AsInteger;
            Que_ModifK.ExecSQL;
            caption := ' Que_GUID 1-2';
            Que_ModifGUID.paramByName('ID').AsInteger := Que_GUIDBAS_ID.AsInteger;
            IBQue_Param.parambyname('magid').AsInteger := Que_GUIDBAS_ID.AsInteger;
            IBQue_Param.Open;
            caption := ' Que_GUID 1-3';

//            IF IBQue_Param.isempty
//              then Que_ModifGUID.paramByName('GUID').AsSTRING := CreateClassID
//              else Que_ModifGUID.paramByName('GUID').AsSTRING := IBQue_ParamPRM_STRING.asstring;

            Que_ModifGUID.paramByName('GUID').AsSTRING := CreateClassID ;       // FL : 07-09-2015 : On ne va plus chercher dans GENPARAM

            IBQue_Param.close;
            Que_ModifGUID.ExecSQL;
            caption := ' Que_GUID 1-4';
        END;
        Que_GUID.next;
        caption := ' Que_GUID 2';
      END;
      Que_GUID.close;
    END
    ELSE
    BEGIN
      caption := ' IBQue_Base 1';
      IBQue_Base.open;
      IBQue_Base.first;
      caption := ' IBQue_Base 2';
      WHILE NOT IBQue_Base.eof DO
      BEGIN
        caption := ' IBQue_Base 4 - 1';
        IBQue_Param.parambyname('magid').AsInteger := IBQue_BaseBAS_ID.AsInteger;
        caption := ' IBQue_Base 4 - 2';
        IBQue_Param.Open;
        caption := ' IBQue_Base 4 - 3';
        IF IBQue_Param.isempty THEN
        BEGIN
          caption := ' IBQue_Base 4 - 4';
          Que_newid1.open;
          caption := ' IBQue_Base 4 - 5';
          ktbid := Que_newid1KTB_ID.AsInteger;
          Que_newid1.close;
          caption := ' IBQue_Base 4 - 6';
          Que_newid2.Open;
          caption := ' IBQue_Base 4 - 7';
          id := Que_newid2ID.AsInteger;
          Que_newid2.close;
          caption := ' IBQue_Base 4 - 8';
          Que_newid3.paramByName('ID').AsInteger := id;
          Que_newid3.paramByName('KTBID').AsInteger := ktbid;
          Que_newid3.ExecSQL;
          caption := ' IBQue_Base 4 - 9';
          SQL.SQL.Text := 'INSERT INTO GENPARAM ' +
              ' (PRM_ID,PRM_CODE,PRM_INTEGER,PRM_FLOAT,PRM_STRING,' +
              'PRM_TYPE,PRM_MAGID,PRM_INFO,PRM_POS) ' +
              ' VALUES ' +
              ' (' + Inttostr(id) + ', 9999, 0, 0,''' + CreateClassID + ''', 9999, ' +
              IBQue_BaseBAS_ID.AsString + ',''GUID en attente version 5.2'',0)';
          caption := ' IBQue_Base 4 - 10';
          Sql.ExecQuery;
          caption := ' IBQue_Base 4 - 11';
        END;
        IBQue_Param.close;
        caption := ' IBQue_Base 3';
        IBQue_Base.next;
        caption := ' IBQue_Base 4';
      END;
      caption := ' IBQue_Base 5';
      IBQue_Base.close;
      caption := ' IBQue_Base 6';
    END;
    Que_existsNom.close;
    Que_existsNom.sql.text := 'select count(*) NB from kfld where kfld_name=''BAS_CENTRALE''';

    Que_existsNom.Open;
    caption := ' IBQue_Base 7';
    IF Que_existsNom.fields[0].AsInteger > 0 THEN
    BEGIN
      caption := ' IBQue_Base 8-' + Que_existsNom.fields[0].AsString;
      FVersion6plus := true;
   // remplir les champs
      Que_existsNom.Close;
      Que_existsNom.sql.clear;
      Que_existsNom.sql.Add('Select BAS_ID from GENBASES join k on (k_id=bas_id and k_enabled=1) where BAS_ID<>0');
      Que_existsNom.Open;

      Que_existsNom.First;
      WHILE NOT Que_existsNom.eof DO
      BEGIN
          SQL.SQL.Text := 'EXECUTE PROCEDURE PR_UPDATEK (' + Que_existsNom.fields[0].AsString + ',0)';
          SQL.ExecQuery;
          SQL.SQL.Text := 'UPDATE GENBASES SET BAS_CENTRALE=' + QuotedStr(LaCentrale) +
              ' , BAS_NOMPOURNOUS=' + QuotedStr(NomClient) +
              ' where BAS_ID=' + Que_existsNom.fields[0].AsString;
          SQL.ExecQuery;
          Que_existsNom.next;
      END;
      Que_existsNom.Close;
    END;
    // enlever le loop que sur les versions qui n'ont pas le champs GET_CODE
    Que_existsNom.close;
    Que_existsNom.sql.text := 'select count(*) NB from kfld where kfld_name=''GET_CODE''';
    Que_existsNom.Open;
    IF Que_existsNom.fields[0].AsInteger = 0 THEN
    BEGIN
      Que_existsNom.Close;
      Que_existsNom.Sql.clear;
      Que_existsNom.Sql.Add('select sub_id');
      Que_existsNom.Sql.Add('from gensubscribers join k on (k_id=SUB_ID and k_enabled=1)');
      Que_existsNom.Sql.Add('where sub_loop=1');
      Que_existsNom.Sql.Add('and sub_id<>0');
      Que_existsNom.Open;
      WHILE NOT Que_existsNom.eof DO
      BEGIN
          if Gestion_K_VERSION = tKV64 then
            SQL.SQL.Text := 'UPDATE K SET K_VERSION=GEN_ID(VERSION_ID,1) WHERE K_ID=' + Que_existsNom.fields[0].AsString
          else
            SQL.SQL.Text := 'UPDATE K SET K_VERSION=GEN_ID(GENERAL_ID,1) WHERE K_ID=' + Que_existsNom.fields[0].AsString;
          SQL.ExecQuery;
          SQL.SQL.Text := 'Update gensubscribers set sub_loop=0 where sub_id=' + Que_existsNom.fields[0].AsString;
          SQL.ExecQuery;
          Que_existsNom.next;

      END;
      Que_existsNom.close;
    END;
    Que_existsNom.Close;

    Que_existsNom.Sql.clear;
    Que_existsNom.Sql.add('select BAS_ID');
    Que_existsNom.Sql.add('from genbases join k on (k_id=bas_id and k_enabled=1)');
    Que_existsNom.Sql.add('where bas_id<>0');
    Que_existsNom.Sql.add('and bas_nom like ''NB%''');
    Que_existsNom.Open;
    WHILE NOT Que_existsNom.eof DO
    BEGIN
      IBQue_Suite.Sql.Clear;
      IBQue_Suite.Sql.add('select PRM_ID, PRM_POS');
      IBQue_Suite.Sql.add('   From genparam');
      IBQue_Suite.Sql.add('        join k on (k_id=prm_id and k_enabled=1)');
      IBQue_Suite.Sql.add('Where PRM_INTEGER = ' + Que_existsNom.fieldByName('BAS_ID').AsString);
      IBQue_Suite.Sql.add('  And PRM_CODE=666 and PRM_TYPE =1999 ');
      IBQue_Suite.Open;
      IF IBQue_Suite.IsEmpty THEN
      BEGIN
          Que_KTBID.Close;
          Que_KTBID.params[0].AsString := 'GENPARAM';
          Que_KTBID.Open;
          Que_newid2.close;
          Que_newid2.Open;
          Que_newid3.paramByName('ID').AsInteger := Que_newid2ID.AsInteger;
          Que_newid3.paramByName('KTBID').AsInteger := Que_KTBIDKTB_ID.AsInteger; ;
          Que_newid3.ExecSQL;
          sql.sql.text := 'INSERT INTO GENPARAM ' +
              ' (PRM_ID,PRM_CODE,PRM_INTEGER,PRM_FLOAT,PRM_STRING,PRM_TYPE,PRM_MAGID,PRM_INFO,PRM_POS) ' +
              '  VALUES ' +
              '(' + Que_newid2ID.AsString + ',666,' + Que_existsNom.fields[0].AsString +
              ',0,'''',1999,0,''Forcer la MAJ'',1)';
          sql.ExecQuery;
          Que_newid2.close;
          Que_KTBID.Close;
      END
      ELSE
      BEGIN
          IF IBQue_Suite.FieldByName('PRM_POS').AsInteger <> 1 THEN
          BEGIN
              Que_ModifK.paramByName('ID').AsInteger := Que_existsNom.fields[0].AsInteger;
              Que_ModifK.ExecSQL;
              Sql.sql.text := 'Update genparam set PRM_POS=1 where prm_id=' + Que_existsNom.fields[0].AsString;
              Sql.execquery;
          END;
      END;
      IBQue_Suite.close;
      Que_existsNom.next;
    END;
    Que_existsNom.close;

    IF tran.InTransaction THEN
        tran.commit;
    IF tran2.InTransaction THEN
        tran2.commit;
    //tran.active := true;
    //tran2.active := true;
    Que_Exists.close;
  except
    on E: Exception do
    begin
      tran.Rollback;
      tran2.Rollback;
    end;
  end;
END;

procedure TForm1.tmr1Timer(Sender: TObject);
begin
     tmr1.Enabled:=false;
     if FAuto then
        begin
             if FAutoGo           then Traitement_GO;
             if FAutoVersion<>''  then Traitement_Version;
             // if FAutoDatabase<>'' then Traitement_Databases_EASY;
             if FNewAuto  then Traitement_Auto;
        end;
     if FEasyAuto then
        begin
          Traitement_Databases_EASY_PAR_MAINTENANCE;
        end;
end;

//function TForm1.traitechaine(S: string): string; //--> Deprecated
//var
//   kk: Integer;
//begin
//   while pos(' ', S) > 0 do
//   begin
//      kk := pos(' ', S);
//      delete(S, kk, 1);
//      Insert('%20', S, kk);
//   end;
//   result := S;
//end;

PROCEDURE TForm1.AffecteYellis(Tc: Tconnexion; NomPourNous: STRING; Lamachine, LaCentrale: STRING);
VAR
    GUID: STRING;
    tsl_C: tstringlist;
    tsl_V: TstringList;
    Site: STRING;
    S: STRING;
    VersionEnCours: STRING;
    idclient: STRING;
    PatchClt, PatchVers: Integer;
    Nomdelaversion: STRING;
    i: Integer;
//    vEMET_ID, vDOSS_ID, vMAGA_ID, vMODU_ID: Integer;
    Tsl: TstringList;
    Nok, vAllow: Boolean;
    LeJour: STRING;
    spe_patch, spe_fait: integer;
    Nomrecup: String;
//    axmlstr : TStrings;
  sUrl, sGuid, sVersion : String;
  sTmp : string;
BEGIN
    sUrl := '';
    sGuid := '';
    sVersion := '';
//    if isNewMaj(sUrl, sGuid, sVersion) then
//    begin
//      doPatchNewMaj(sUrl, sGuid, sVersion);
//      Exit;
//    end;
    // teste de l'existance du GUID dans la table GenBase
    LogDebug(FichierLog,'Affecte Yellis (NomPourNous: '+NomPourNous+' ; Lamachine: '+Lamachine+' ; LaCentrale: '+LaCentrale);
    Que_Exists.Open;
    caption := ' IBQue_Base 7';
    IBQue_Base.open;
    IBQue_Base.first;
    caption := ' IBQue_Base 8';
    Que_Version.Open;
    VersionEnCours := Que_VersionVER_VERSION.AsString;
    Que_Version.Close;
    tsl_V := tc.Select('Select * from version where version="' + VersionEnCours + '"');
    IF tsl_V.count = 0 THEN
    BEGIN
        slError.Add('Base:' + Lab_Base.caption + ' - la version ' + VersionEnCours + ' n''existe pas');
//        Application.messagebox(pchar('la version ' + VersionEnCours + ' n''existe pas'), 'Problème', mb_ok);
        LogDebug(FichierLog,'la version ' + VersionEnCours + ' n''existe pas');
        EXIT;
    END;
    caption := ' IBQue_Base 9';
    WHILE NOT IBQue_Base.eof DO
    BEGIN
        IF Que_ExistsNB.AsInteger > 0 THEN
        BEGIN
        // recupération du GUID dans GENBASE
            Que_GUIDBASE.ParamByName('BASID').AsInteger := IBQue_BaseBAS_ID.AsInteger;
            Que_GUIDBASE.Open;
            GUID := Que_GUIDBASEBAS_GUID.AsString;
            Que_GUIDBASE.Close;
        END
        ELSE
        BEGIN
        // recupération du GUID dans GENPARAM
            IBQue_Param.parambyname('magid').AsInteger := IBQue_BaseBAS_ID.AsInteger;
            IBQue_Param.Open;
            GUID := IBQue_ParamPRM_STRING.AsString;
            IBQue_Param.Close;
        END;
      // Recherche si le GUID est affecté à une base de Yellis
        tsl_C := tc.Select('Select * from clients where clt_GUID = "' + GUID + '"');
        IBQue_Soc.open;
        Site := IBQue_SocSOC_NOM.AsString;
        IBQue_Soc.Close;
        IF tsl_c.count = 0 THEN
        BEGIN
        // La base n'est pas affectée, recherche de la base
            tc.FreeResult(tsl_C);
         // on recherche au plus précis
            tsl_C := tc.Select('Select * from clients where site = "' + Site + '" And ' +
                ' nom="' + IBQue_BaseBAS_NOM.AsString + '" and nompournous="' + NomPourNous + '" and ' +
                ' clt_GUID is null');
            IF tsl_c.count = 0 THEN
            BEGIN
                tc.FreeResult(tsl_C);
                tsl_C := tc.Select('Select * from clients where site = "' + Site + '" And ' +
                    ' nom="' + IBQue_BaseBAS_NOM.AsString + '" and ' +
                    ' clt_GUID is null');
            END;
            IF tsl_c.count = 0 THEN
            BEGIN
           // le client n'existe pas encore le créer
                S := 'Insert into clients (site, nom, version, patch, nompournous, basepantin, clt_GUID) ' +
                    'values ("' + Site + '", "' + IBQue_BaseBAS_NOM.AsString + '", ' +
                    tc.UneValeur(tsl_V, 'id') + ', 0, "' + NomPourNous + '", ';
                IF IBQue_BaseBAS_IDENT.AsString = '0' THEN
                    s := s + ' 1, "' + GUID + '")'
                ELSE
                    s := s + ' 0, "' + GUID + '")';
                idclient := Inttostr(tc.insert(s, memo1));
            END
            ELSE
            BEGIN
                idclient := tc.UneValeur(tsl_C, 'id');
                tc.ordre('update clients set clt_GUID = "' + GUID + '" where id=' + idclient, memo1);
            END;
        END
        ELSE
            idclient := tc.UneValeur(tsl_C, 'id');
        tc.FreeResult(tsl_C);
        tsl_C := tc.Select('Select * from clients where id = ' + idclient);
      // vérification des données
        IF tc.UneValeur(tsl_C, 'clt_machine') <> LaMachine THEN
        BEGIN
            tc.ordre('update clients set clt_machine = "' + LaMachine + '" where id=' + idclient, memo1);
        END;
        IF tc.UneValeur(tsl_C, 'clt_centrale') <> LaCentrale THEN
        BEGIN
            tc.ordre('update clients set clt_centrale = "' + LaCentrale + '" where id=' + idclient, memo1);
        END;
        IF tc.UneValeur(tsl_C, 'nompournous') <> NomPourNous THEN
        BEGIN
            tc.ordre('update clients set nompournous = "' + NomPourNous + '" where id=' + idclient, memo1);
        END;
        IF tc.UneValeur(tsl_C, 'site') <> site THEN
        BEGIN
            tc.ordre('update clients set site = "' + site + '" where id=' + idclient, memo1);
        END;
        IF tc.UneValeur(tsl_C, 'nom') <> IBQue_BaseBAS_NOM.AsString THEN
        BEGIN
            tc.ordre('update clients set nom = "' + IBQue_BaseBAS_NOM.AsString + '" where id=' + idclient, memo1);
        END;
      // Vérification de la version actuellement dans yellis
        IF IBQue_BaseBAS_IDENT.AsString = '0' THEN
        BEGIN
            IF tc.UneValeur(tsl_V, 'id') <> tc.UneValeur(tsl_C, 'version') THEN
            BEGIN
            // MAJ de la version
                tc.ordre('update clients set version = ' + tc.UneValeur(tsl_V, 'id') + ', patch=0 where id=' + idclient, memo1);
                tc.FreeResult(tsl_C);
                tsl_C := tc.Select('Select * from clients where id=' + idclient, memo1);
            END;

         //SR - 11/07/2014 - Ajout test des
         if Strtoint(tc.UneValeur(tsl_C, 'blockmaj')) = 0 then  //Si le client n'est pas bloqué en mise à jour on passe les pacths
         begin

         // doit ont passer des patch ?
            PatchClt := Strtoint(tc.UneValeur(tsl_C, 'patch'));
            PatchVers := Strtoint(tc.UneValeur(tsl_V, 'Patch'));
            Nomdelaversion := tc.UneValeur(tsl_V, 'nomversion');
            IF PatchClt > PatchVers THEN
            BEGIN
            // Ya eu un gros problème
                PatchClt := 0;
                S := 'Update clients set patch = 0 where id=' + idclient;
                tc.ordre(S, memo1);
            END;

            FOR i := PatchClt + 1 TO PatchVers DO
            BEGIN
                Lab_Etape.caption := 'Patching script ' + inttostr(i);
                Lab_Etape.Update;
            // des patchs sont à passer
                Nomrecup := Format(cUrlSourcePatch, [FURLSOURCEPATCH, Nomdelaversion, i]);
                S:= Format(cFileNameSql, [FLecteurLame, Nomdelaversion, i]);
                vAllow:= False;

                { Si GUID est placé sur une machine differente de cLAMESOURCEPATCH
                  alors on recupere les scripts via HTTP si non c'est en local }
                if FIsSourceScriptHTTP then
                  vAllow := Download( Nomrecup, S )
                else
                  vAllow:= FileExists(S);

                if vAllow then
                begin
                  tsl := TstringList.Create;
                  tsl.loadfromfile(S);
                  S := trim(tsl.Text);
                  tsl.free;

                  Nok := Patch(i, S);

                  IF NOK THEN
                  BEGIN
                  // erreur
                      LeJour := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now);
                      S := 'Insert into histo (id_cli, ladate, action, actionstr, str1) ' +
                          'value (' + idclient + ', "' + LeJour + '",5 ,"script' + Inttostr(i) + '.SQL", "A pantin")';
                      tc.ordre(S, memo1);
                      BREAK;
                  END
                  ELSE
                  BEGIN
                      S := 'Update clients set patch = ' + Inttostr(i) + ' where id=' + idclient;
                      tc.ordre(S, memo1);
                      LeJour := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now);
                      S := 'Insert into histo (id_cli, ladate, action, actionstr, str1) ' +
                          'value (' + idclient + ', "' + LeJour + '",4 ,"script' + Inttostr(i) + '.SQL", "A pantin")';
                      tc.ordre(S, memo1);
                  END;
                end;
            END;

         // Patch Spécifique au client ?
            spe_patch := Strtoint(tc.UneValeur(tsl_C, 'spe_patch'));
            spe_fait := Strtoint(tc.UneValeur(tsl_C, 'spe_fait'));
            IF spe_fait > spe_patch THEN
            BEGIN
            // Ya eu un gros problème
                spe_fait := 0;
                S := 'Update clients set spe_fait = 0 where id=' + idclient;
                tc.ordre(S, memo1);
            END;

            FOR i := spe_fait + 1 TO spe_patch DO
            BEGIN
            // script specifique
                Lab_Etape.caption := 'Patching Spe script ' + inttostr(i);
                Lab_Etape.Update;
                Nomrecup := Format(cUrlSourcePatch, [FURLSOURCEPATCH, GUID, i]);
                S:= Format(cFileNameSql, [FLecteurLame, GUID, i]);
                vAllow:= False;

                { Si GUID.exe est placé sur une machine differente de FLAMESOURCEPATCH
                  alors on recupere les scripts via HTTP si non c'est en local }
                if FIsSourceScriptHTTP then
                  vAllow := Download( Nomrecup, S )
                else
                  vAllow:= FileExists(S);

                if vAllow then
                  BEGIN
                      tsl := TstringList.Create;
                      tsl.loadfromfile(S);
                      S := trim(tsl.Text);
                      tsl.free;

                      Nok := Patch(i, S);
                      IF NOK THEN
                      BEGIN
                    // erreur
                          LeJour := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now);
                          S := 'Insert into histo (id_cli, ladate, action, actionstr, str1) ' +
                              'value (' + idclient + ', "' + LeJour + '",8 ,"script' + Inttostr(i) + '.SQL", "A pantin")'; //--> l'ID 7 a été remplacé par 8 à cause d'une erreur de libelle
                          tc.ordre(S, memo1);
                          BREAK;
                      END
                      ELSE
                      BEGIN
                          S := 'Update clients set spe_fait = ' + Inttostr(i) + ' where id=' + idclient;
                          tc.ordre(S, memo1);
                          LeJour := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now);
                          S := 'Insert into histo (id_cli, ladate, action, actionstr, str1) ' +
                              'value (' + idclient + ', "' + LeJour + '",7 ,"script' + Inttostr(i) + '.SQL", "A pantin")'; //--> l'ID 8 a été remplacé par 7 à cause d'une erreur de libelle
                          tc.ordre(S, memo1);
                      END;
                  END;
              END;
         end
         else
          caption := ' Client bloqué en mise à jour';
   
        END;

        tc.FreeResult(tsl_C);
        caption := ' IBQue_Base 10';

        IBQue_Base.Next;
        caption := ' IBQue_Base 11';
    END;

    { -------------------- Synchronisation Maintenance -------------------- }
    if ChkBxBaseMaintenance.Checked then
    begin
      IBQue_Base.First;
      caption := ' Synchronisation Maintenance';
      try
        WHILE NOT IBQue_Base.eof DO
        begin
          if ChkBxMaintenanceLog.Checked then
          begin
            LogDebug(FichierLog, 'IBQue_BaseBAS_GUID.AsString = ' + IBQue_BaseBAS_GUID.AsString);
            LogDebug(FichierLog, 'IBQue_BaseBAS_ID.AsInteger = ' + IntToStr(IBQue_BaseBAS_ID.AsInteger));
            LogDebug(FichierLog, 'IBQue_BaseBAS_IDENT.AsString = ' + IBQue_BaseBAS_IDENT.AsString);
            LogDebug(FichierLog, 'IBQue_BaseBAS_ID.AsInteger = ' + IntToStr(IBQue_BaseBAS_JETON.AsInteger));
            LogDebug(FichierLog, 'IBQue_BaseBAS_PLAGE.AsInteger = ' + IBQue_BaseBAS_PLAGE.AsString);
            LogDebug(FichierLog, 'IBQue_BaseBAS_MAGID.AsInteger = ' + IntToStr(IBQue_BaseBAS_MAGID.AsInteger));
          end;

          QryGenMaintenance.SQL.Text:= 'SELECT EMET_ID, EMET_DOSSID, EMET_MAGID FROM EMETTEUR WHERE EMET_GUID=:PGUID';
          QryGenMaintenance.ParamByName('PGUID').AsString:= IBQue_BaseBAS_GUID.AsString;
          QryGenMaintenance.Open;

          if not QryGenMaintenance.Eof then
          begin
            LogDebug(FichierLog, 'QryGenMaintenance.FieldByName(EMET_DOSSID).AsInteger = ' + IntToStr(QryGenMaintenance.FieldByName('EMET_DOSSID').AsInteger));

            sTmp := SyncBase(QryGenMaintenance.FieldByName('EMET_DOSSID').AsInteger);

            // 15/03/2021 Greg : Méthode de Synchro par l'api de la dll Maintenance. En attente de recette...
            //sTmp := SyncBaseByDllMaintenance(QryGenMaintenance.FieldByName('EMET_DOSSID').AsInteger);

            LogDebug(FichierLog, sTmp);
            IBQue_Base.Last;
          end
          else
            LogDebug(FichierLog, 'EMET_GUID "' + IBQue_BaseBAS_GUID.AsString +'" introuvable');

          if ChkBxMaintenanceLog.Checked then
            LogDebug(FichierLog, '-----------------------------------------------');

          IBQue_Base.Next;
        end;
      except
        on E: Exception do
        begin
          LogDebug(FichierLog, 'Except : ' + E.Message);
          IBTransMaintenance.Rollback;
        end;
      end;
    end;

//            try
//              try
//                if ChkBxMaintenanceLog.Checked then
//                  begin
//                    LogDebug(FichierLog, 'IBQue_BaseBAS_GUID.AsString = ' + IBQue_BaseBAS_GUID.AsString);
//                    LogDebug(FichierLog, 'IBQue_BaseBAS_ID.AsInteger = ' + IntToStr(IBQue_BaseBAS_ID.AsInteger));
//                    LogDebug(FichierLog, 'IBQue_BaseBAS_IDENT.AsString = ' + IBQue_BaseBAS_IDENT.AsString);
//                    LogDebug(FichierLog, 'IBQue_BaseBAS_ID.AsInteger = ' + IntToStr(IBQue_BaseBAS_JETON.AsInteger));
//                    LogDebug(FichierLog, 'IBQue_BaseBAS_PLAGE.AsInteger = ' + IBQue_BaseBAS_PLAGE.AsString);
//                    LogDebug(FichierLog, 'IBQue_BaseBAS_MAGID.AsInteger = ' + IntToStr(IBQue_BaseBAS_MAGID.AsInteger));
//                  end;
//
//                QryGenMaintenance.SQL.Text:= 'SELECT EMET_ID, EMET_DOSSID, EMET_MAGID FROM EMETTEUR WHERE EMET_GUID=:PGUID';
//                QryGenMaintenance.Params[0].AsString:= IBQue_BaseBAS_GUID.AsString;
//                QryGenMaintenance.Open;
//
//                vMAGA_ID:= 0;
//                if not QryGenMaintenance.Eof then
//                  begin
//                    if not IBTransMaintenance.InTransaction then
//                      IBTransMaintenance.StartTransaction;
//
//                    vEMET_ID := QryGenMaintenance.FieldByName('EMET_ID').AsInteger;
//                    vDOSS_ID := QryGenMaintenance.FieldByName('EMET_DOSSID').AsInteger;
//
//                    QryGENMAGASIN.Open;
//
//                    // ------------ MAJ MAGASIN
//                    if (vDOSS_ID <> 0) and (not QryGENMAGASIN.Eof) and (QryGENMAGASIN.Locate('MAG_ID', IBQue_BaseBAS_MAGID.AsInteger, [])) then
//                      begin
//                        QryGenMaintenance.SQL.Text:= 'SELECT MAGA_ID FROM MAGASINS WHERE MAGA_DOSSID=:PDOSSID AND MAGA_MAGID_GINKOIA=:PMAGID_GINKOIA';
//                        QryGenMaintenance.ParamByName('PDOSSID').AsInteger:= vDOSS_ID;
//                        QryGenMaintenance.ParamByName('PMAGID_GINKOIA').AsInteger:= QryGENMAGASIN.FieldByName('MAG_ID').AsInteger;
//                        QryGenMaintenance.Open;
//
//                        if QryGenMaintenance.Eof then
//                          begin
//                            vMAGA_ID:= GetNewID('MAGASINS');
//                            QryGenMaintenance.SQL.Text:= 'INSERT INTO MAGASINS (MAGA_ID, MAGA_DOSSID, MAGA_MAGID_GINKOIA, MAGA_NOM, MAGA_ENSEIGNE)' + #13#10 +
//                                                         'VALUES (:PMAGA_ID, :PDOS_ID, :PMAG_ID_GINKOIA, :PMAG_NOM, :PMAG_ENSEIGNE)';
//
//                            QryGenMaintenance.ParamByName('PMAGA_ID').AsInteger:= vMAGA_ID;
//                            QryGenMaintenance.ParamByName('PDOS_ID').AsInteger:= vDOSS_ID;
//                            QryGenMaintenance.ParamByName('PMAG_ID_GINKOIA').AsInteger := QryGENMAGASIN.FieldByName('MAG_ID').AsInteger;
//                            QryGenMaintenance.ParamByName('PMAG_NOM').AsString         := QryGENMAGASIN.FieldByName('MAG_NOM').AsString;
//                            QryGenMaintenance.ParamByName('PMAG_ENSEIGNE').AsString    := QryGENMAGASIN.FieldByName('MAG_ENSEIGNE').AsString;
//                            QryGenMaintenance.ExecSQL;
//                          end
//                        else
//                          begin
//                            vMAGA_ID:= QryGenMaintenance.FieldByName('MAG_ID').AsInteger;
//
//                            QryGenMaintenance.SQL.Text:= 'UPDATE MAGASINS SET MAGA_NOM =:PMAGA_NOM, MAGA_ENSEIGNE =:PMAGA_ENSEIGNE WHERE MAGA_ID=:PMAGA_ID';
//                            QryGenMaintenance.ParamByName('PMAGA_NOM').AsString      := QryGENMAGASIN.FieldByName('MAG_NOM').AsString;
//                            QryGenMaintenance.ParamByName('PMAGA_ENSEIGNE').AsString := QryGENMAGASIN.FieldByName('MAG_ENSEIGNE').AsString;
//                            QryGenMaintenance.ParamByName('PMAGA_ID').AsInteger      := vMAGA_ID;
//                            QryGenMaintenance.ExecSQL;
//                          end;
//                      end;
//
//                    // ------------ MAJ MODULES
//                    QrySelectMaintenance.SQL.Text:= 'SELECT * FROM MODULES';
//                    QrySelectMaintenance.Open;
//
//                    QryGenMaintenance.SQL.Text:= 'INSERT INTO MODULES (MODU_ID, MODU_NOM, MODU_COMMENT)' + #13#10 +
//                                                 'VALUES (:PMODU_ID, :PMODU_NOM, :PMODU_COMMENT)';
//
//                    IBQue_ListGroupe.Open;
//                    IBQue_ListGroupe.First;
//                    while not IBQue_ListGroupe.Eof do
//                    begin
//                      if not QrySelectMaintenance.Locate('MODU_NOM',IBQue_ListGroupeUGG_NOM.Value,[]) then
//                      begin
//                        vMODU_ID:= GetNewID('MODULES');
//                        QryGenMaintenance.ParamByName('PMODU_ID').AsInteger      := vMODU_ID;
//                        QryGenMaintenance.ParamByName('PMODU_NOM').AsString      := IBQue_ListGroupeUGG_NOM.Text;
//                        QryGenMaintenance.ParamByName('PMODU_COMMENT').AsString  := IBQue_ListGroupeUGG_COMMENT.Text;
//                        QryGenMaintenance.ExecSQL;
//                      end;
//                      IBQue_ListGroupe.Next;
//                    end;
//                    IBQue_ListGroupe.Close;
//
//                    // ------------ MAJ MODULES MAGASINS
//                    if QryGENMAGASIN.FieldByName('MAG_ID').AsInteger <> 0 then
//                    begin
//                      QrySelectMaintenance.Close;
//                      QrySelectMaintenance.SQL.Text:= 'SELECT MODU_ID'                                     + #13#10 +
//                                                      ' FROM MODULES_MAGASINS '                            + #13#10 +
//                                                      ' JOIN MODULES ON (MODU_ID = MMAG_MODUID) '          + #13#10 +
//                                                      ' WHERE MMAG_MAGAID = :PMAGA_ID      '               + #13#10 +
//                                                      '  AND  MODU_NOM = :PMODU_NOM     ';
//
//                      IBQue_GrpMag.ParamByName('PMAGID').AsInteger  := QryGENMAGASIN.FieldByName('MAG_ID').AsInteger;
//                      IBQue_GrpMag.Open;
//                      IBQue_GrpMag.First;
//                      LogDebug(FichierLog, 'IBQue_GrpMag.RecordCount = ' + IntToStr(IBQue_GrpMag.RecordCount));
//                      while not IBQue_GrpMag.Eof do
//                      begin
//                        QrySelectMaintenance.ParamByName('PMAGA_ID').AsInteger := vMAGA_ID;
//                        QrySelectMaintenance.ParamByName('PMODU_NOM').AsString := IBQue_GrpMagUGG_NOM.AsString;
//                        QrySelectMaintenance.Open;
//
//                        LogDebug(FichierLog, 'IBQue_GrpMagUGG_NOM.AsString = ' + IBQue_GrpMagUGG_NOM.AsString);
//
//                        if QrySelectMaintenance.Eof then
//                        begin
//                          QryGenMaintenance.SQL.Text := 'SELECT MODU_ID FROM MODULES WHERE MODU_NOM = :PMODU_NOM';
//                          QryGenMaintenance.ParamByName('PMODU_NOM').AsString := IBQue_GrpMagUGG_NOM.AsString;
//                          QryGenMaintenance.Open;
//                          vMODU_ID := QryGenMaintenance.FieldByName('MODU_ID').AsInteger;
//                          LogDebug(FichierLog, 'Insert vMODU_ID = ' + IntToStr(vMODU_ID));
//
//                          QryGenMaintenance.Close;
//                          QryGenMaintenance.SQL.Text:= 'INSERT INTO MODULES_MAGASINS (MMAG_MODUID, MMAG_MAGAID, MMAG_EXPDATE, MMAG_KENABLED, MMAG_UGMID)' + #13#10 +
//                                                       'VALUES (:PMODUID, :PMAGAID, :PEXPDATE, :PKENABLED, :PUGMID)';
//                        end
//                        else
//                        begin
//                          vMODU_ID:= QrySelectMaintenance.FieldByName('MODU_ID').AsInteger;
//                          LogDebug(FichierLog, 'UPDATE vMODU_ID = ' + IntToStr(vMODU_ID));
//
//                          QryGenMaintenance.SQL.Text:= 'UPDATE MODULES_MAGASINS SET MMAG_EXPDATE =:PEXPDATE, MMAG_KENABLED =:PKENABLED, MMAG_UGMID =:PUGMID WHERE MMAG_MODUID=:PMODUID AND MMAG_MAGAID=:PMAGAID';
//                        end;
//                        QryGenMaintenance.ParamByName('PMODUID').AsInteger    := vMODU_ID;
//                        QryGenMaintenance.ParamByName('PMAGAID').AsInteger    := vMAGA_ID;
//                        QryGenMaintenance.ParamByName('PEXPDATE').AsDateTime  := IBQue_GrpMagUGM_DATE.AsDateTime;
//                        QryGenMaintenance.ParamByName('PKENABLED').AsInteger  := IBQue_GrpMagK_ENABLED.AsInteger;
//                        QryGenMaintenance.ParamByName('PUGMID').AsInteger     := IBQue_GrpMagUGM_ID.AsInteger;
//                        QryGenMaintenance.ExecSQL;
//
//                        IBQue_GrpMag.Next;
//                      end;
//                      IBQue_GrpMag.Close;
//                    end;
//
//                    // ------------ MAJ EMETTEUR
//                    QryGENLAUNCH.ParamByName('PBAS_ID').AsInteger:= IBQue_BaseBAS_ID.AsInteger;
//                    QryGENLAUNCH.Open;
//
//                    QryGenMaintenance.SQL.Clear;
//                    QryGenMaintenance.SQL.Append('UPDATE EMETTEUR SET');
//                    QryGenMaintenance.SQL.Append('EMET_TIERSCEGID =:PEMET_TIERSCEGID,');
//                    QryGenMaintenance.SQL.Append('EMET_IDENT =:PEMET_IDENT,');
//                    QryGenMaintenance.SQL.Append('EMET_JETON =:PEMET_JETON,');
//                    QryGenMaintenance.SQL.Append('EMET_MAGID =:PEMET_MAGID,');
//
//                    if not QryGENLAUNCH.Eof then
//                      begin
//                        QryGenMaintenance.SQL.Append('EMET_H1 =:PEMET_H1,');
//                        QryGenMaintenance.SQL.Append('EMET_H2 =:PEMET_H2,');
//                        QryGenMaintenance.SQL.Append('EMET_HEURE1 =:PEMET_HEURE1,');
//                        QryGenMaintenance.SQL.Append('EMET_HEURE2 =:PEMET_HEURE2,');
//                      end;
//
//                    QryGenMaintenance.SQL.Append('EMET_PLAGE =:PEMET_PLAGE');
//                    QryGenMaintenance.SQL.Append('WHERE EMET_ID=:PEMET_ID');
//
//                    QryGenMaintenance.ParamByName('PEMET_TIERSCEGID').AsString := IBQue_BaseBAS_CODETIERS.AsString;
//                    QryGenMaintenance.ParamByName('PEMET_IDENT').AsString      := IBQue_BaseBAS_IDENT.AsString;
//                    QryGenMaintenance.ParamByName('PEMET_JETON').AsInteger     := IBQue_BaseBAS_JETON.AsInteger;
//                    QryGenMaintenance.ParamByName('PEMET_PLAGE').AsString      := IBQue_BaseBAS_PLAGE.AsString;
//                    QryGenMaintenance.ParamByName('PEMET_MAGID').AsInteger     := vMAGA_ID; ////  <---< Etrange on met le MAGA_ID ou le MAG_ID ??
//                    QryGenMaintenance.ParamByName('PEMET_ID').AsInteger        := vEMET_ID;
//
//                    if not QryGENLAUNCH.Eof then
//                      begin
//                        if ChkBxMaintenanceLog.Checked then
//                          begin
//                            LogDebug(FichierLog, 'LAU_H1 = ' + IntToStr(QryGENLAUNCH.FieldByName('LAU_H1').AsInteger));
//                            LogDebug(FichierLog, 'LAU_H2 = ' + IntToStr(QryGENLAUNCH.FieldByName('LAU_H2').AsInteger));
//                            LogDebug(FichierLog, 'LAU_HEURE1 = ' + DateToStr(QryGENLAUNCH.FieldByName('LAU_HEURE1').AsDateTime));
//                            LogDebug(FichierLog, 'LAU_HEURE2 = ' + DateToStr(QryGENLAUNCH.FieldByName('LAU_HEURE2').AsDateTime));
//                          end;
//
//                        QryGenMaintenance.ParamByName('PEMET_H1').AsInteger:= QryGENLAUNCH.FieldByName('LAU_H1').AsInteger;
//                        QryGenMaintenance.ParamByName('PEMET_H2').AsInteger:= QryGENLAUNCH.FieldByName('LAU_H2').AsInteger;
//                        QryGenMaintenance.ParamByName('PEMET_HEURE1').Value:= QryGENLAUNCH.FieldByName('LAU_HEURE1').Value;
//                        QryGenMaintenance.ParamByName('PEMET_HEURE2').Value:= QryGENLAUNCH.FieldByName('LAU_HEURE2').Value;
//                      end;
//
//                    QryGenMaintenance.ExecSQL;
//
//                    IBTransMaintenance.Commit;
//                  end
//                else
//                  LogDebug(FichierLog, 'EMET_GUID "' + IBQue_BaseBAS_GUID.AsString +'" introuvable');
//                if ChkBxMaintenanceLog.Checked then
//                  LogDebug(FichierLog, '-----------------------------------------------');
//              except
//                on E: Exception do
//                  begin
//                    LogDebug(FichierLog, 'Except : ' + E.Message);
//                    IBTransMaintenance.Rollback;
//                  end;
//              end;
//
//            finally
//              QryGENMAGASIN.Close;
//              QryGENLAUNCH.Close;
//            end;
        { --------------------------------------------------------------------- }

    Que_Exists.Close;
    tc.FreeResult(tsl_V);
END;

PROCEDURE TForm1.CreationLog(NomClient, LaMachine, LaCentrale: STRING);
VAR
    S: STRING;
BEGIN
  //
    Que_logMag.Open;
    WHILE NOT Que_logMag.eof DO
    BEGIN
        S := NomClient + ';' + LaMachine + ';' + LaCentrale + ';' + Que_logMagMAG_IDENT.AsString + ';' + Que_logMagMAG_NOM.AsString;
        Que_LogPoste.ParamByName('ID').AsInteger := Que_logMagMAG_ID.AsInteger;
        Que_LogPoste.Open;
        WHILE NOT Que_LogPoste.Eof DO
        BEGIN
            S := S + ';' + Que_LogPostePOS_NOM.AsString;
            Que_LogPoste.next;
        END;
        FLog.add(s);
        Que_LogPoste.Close;
        Que_logMag.next;
    END;
    Que_logMag.Close;
  //
END;

procedure TForm1.doPatchNewMaj(sUrl, sGuid, sVersion : String);
var
  NewMaj : TNewMaj;
begin
  NewMaj := TNewMaj.Create;
  NewMaj.GUID := sGuid;
  NewMaj.URL := sUrl;
  NewMaj.Version := sVersion;
  try
    NewMaj.SendVersion;
    NewMaj.getPatch;
    NewMaj.doPatch;
    NewMaj.SendResult;
  finally
    NewMaj.Free;
  end;
end;

function TForm1.Download(const URL, DestFilename: String): Boolean;
  function FormatInClock(TickCount: Cardinal): string;
  var
    dd, hh, mm, ss, ms: Cardinal;
  begin
    Result := '00:00:00:00:0000';
    if (TickCount > 0) then
    try
      ms := TickCount mod 1000;
      TickCount := TickCount div 1000;

      ss := TickCount mod 60;
      TickCount := TickCount div 60;

      mm := TickCount mod 60;
      TickCount := TickCount div 60;

      hh := TickCount mod 60;
      TickCount := TickCount div 60;

      dd := TickCount;
    finally
      Result := Format( '%.2d:%.2d:%.2d:%.2d:%.4d', [ dd, hh, mm, ss, ms ] );
    end;
  end;
var
  IdHTTP: TIdHTTP;
  IdCompressorZLib: TIdCompressorZLib;
  FileStream: TFileStream;
  InitialTickCount: Cardinal;
  vTry      : Integer ;
begin
  Result := False ;
  vTry := 0 ;

  repeat
    Inc(vTry) ;
    try
      if not ForceDirectories( ExtractFilePath( DestFilename ) ) then
        raise EFCreateError.CreateFmt( 'Downloading "%s" -> "%s" (Try %d/5): Impossible de créer le repertoire de destination "%s"', [ TIdURI.URLEncode( URL ), DestFilename, vTry, ExtractFileDir( DestFilename ) ] );
      FileStream := TFileStream.Create( DestFilename, fmCreate or fmShareExclusive );
      try
        IdHTTP := TIdHTTP.Create( nil );
        IdHTTP.OnWork := IdHTTPWork;
        IdHTTP.OnWorkBegin := IdHTTPWorkBegin;
        IdHTTP.OnWorkEnd := IdHTTPWorkEnd;
        IdCompressorZLib := TIdCompressorZLib.Create( nil );
        IdHTTP.Compressor := IdCompressorZLib;
        IdHTTP.Request.AcceptEncoding := 'gzip';
        IdHTTP.HandleRedirects := True;
        IdHTTP.RedirectMaximum := 15;

        try
          LogDebug( FichierLog, Format( 'Downloading "%s" -> "%s" (Try %d/5)', [ TIdURI.URLEncode( URL ), DestFilename, vTry ] ) );
          InitialTickCount := GetTickCount;
          IdHTTP.Get( TIdURI.URLEncode( URL ), FileStream );
          Result := IdHTTP.ResponseCode = 200;

          if Result then
            LogDebug( FichierLog, Format( '  --> OK : %s (ms)', [ FormatInClock( GetTickCount - InitialTickCount ) ] ) )
          else
            LogDebug( FichierLog, Format( '  --> ERROR : %s (ms)'#13#10'%s', [ FormatInClock( GetTickCount - InitialTickCount ), idHTTP.ResponseText ] ) );

        finally
          IdHTTP.Free;
        end;

      finally
        FileStream.Free;
      end;

    except
      on E: Exception do begin            
        LogDebug( FichierLog, Format( '  --> NOK : %s - %s'#13#10'%s', [ TIdURI.URLEncode( URL ), DestFilename, E.Message ] ) );
        if FileExists( DestFilename ) then
          DeleteFile( DestFilename );
        Result := False;
      end;
    end;

    if Result = false
      then sleep(1000) ;              // Pause de 1 seconde entre 2 réessais

  until ((Result = true) or (vTry >= 5)) ;
end;

PROCEDURE TForm1.traitement_rtf;
VAR
    S: STRING;
BEGIN
  Caption := 'traitement rtf';
  try
    if not SQL.Transaction.InTransaction then   //SR - 11/07/2014 -
      SQL.Transaction.StartTransaction;

    IBQue_Adresse.Open;
    WHILE NOT IBQue_Adresse.eof DO
    BEGIN
      S := LowerCase(IBQue_AdresseADR_LIGNE.AsString);
      WHILE pos(#10, s) > 0 DO
          delete(s, pos(#10, s), 1);
      WHILE pos(#13, s) > 0 DO
          delete(s, pos(#13, s), 1);
      Chp_Rtf.Lines.text := s;
      SQL.SQL.text := 'Update Genadresse set ADR_LIGNE = ' + quotedstr(Chp_Rtf.Text) + ' where ADR_ID = ' + IBQue_AdresseADR_ID.AsString;
      SQL.ExecQuery;
      IBQue_Adresse.next;
    END;
    IBQue_Adresse.close;

    IF SQL.Transaction.InTransaction THEN
    BEGIN
      SQL.Transaction.commit;
    END;
  except
    on E: Exception do
    begin
      SQL.Transaction.Rollback;
    end;
  end;
END;

procedure TForm1.Process(const Xml_DocOrdre : TXMLDocument; sCentrale : string);
var
  XMLA: TIcXMLElement;
  _nom, _tipe, _data: String;
  Xml_Centrales : IXMLCENTRALESType;
  Xml_Centrale : IXMLCENTRALEType;
  Xml_Ordres : IXMLORDRESType;
  Xml_Ordre : IXMLORDREType;
  i,y : integer;
begin
  Xml_Centrales := GetCENTRALES(Xml_DocOrdre);
  for i := 0 to Xml_Centrales.Count -1 do
  begin
    Xml_Centrale := Xml_Centrales.CENTRALE[i];
    if LowerCase(Xml_Centrale.NOM) = LowerCase(sCentrale) then
    begin
      LogDebug(FichierLog,'Centrale['+inttostr(i)+'].Nom='+Xml_Centrale.NOM);
      Xml_Ordres := Xml_Centrale.ORDRES;
      for y := 0 to Xml_Ordres.Count -1 do
      begin
        Xml_Ordre := Xml_Ordres.ORDRE[y];
        LogDebug(FichierLog,'Ordre['+inttostr(y)+'].Data='+Xml_Ordre.DATA);
        TraiteXML(Xml_Ordre.NOM, Xml_Ordre.TYPE_, Xml_Ordre.DATA);
      end;
    end;
  end;
end;

PROCEDURE TForm1.ExecJob(Machine, databases: STRING);
VAR
    passXML: TIcXMLElement;
    passXML2: TIcXMLElement;
    LaBase: STRING;
    Tc: Tconnexion;
    NomClient: STRING;
    LaMachine: STRING;
    LaCentrale: STRING;
    s: STRING;
    tsl: tstringList;
    XMLA: TIcXMLElement;
    _nom, _tipe, _data: STRING;
    tpJeton : TTokenParams;
    bJeton  : Boolean;        //Vrai si on a le jeton sinon faux
    i, vNbEssais: Integer;    //Compteur pour les jetons / Nombre d'essais
    vAllowExecJob: Boolean;

    Xml_Doc : TXMLDocument;
    Xml_Datasources : IXMLDataSourcesType;
    Xml_Datasource : IXMLDataSourceType;
    Xml_Params : IXMLParamsType;
    Xml_Param : IXMLParamType;

    Xml_DocOrdre : TXMLDocument;
    Xml_Centrales : IXMLCENTRALESType;
    Xml_Centrale : IXMLCENTRALEType;
    Xml_Ordres : IXMLORDRESType;
    Xml_Ordre : IXMLORDREType;

    iDts, iPrm : integer;
BEGIN
    LogDebug(FichierLog,'Execute traitement (Machine: '+Machine+' ; DataBasesXml: '+ Databases);

    s := databases;
    WHILE pos('\', S) > 0 DO
        s[pos('\', S)] := '/';

    WHILE (s[1] <> 'V') DO
        delete(S, 1, pos('/', s));

    s := Copy(S, 1, pos('/', s) - 1);
    caption := S;
//    memo1.Lines.Add('TMP_DBG: S="' + S + '"');
    Xml_DocOrdre := TXMLDocument.Create(nil);
    IF NOT FileExists(IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) + S + '.xml') THEN
    BEGIN
      try
        tsl := TStringList.Create;
        tsl.add('<CENTRALES>');
        tsl.add('	<CENTRALE>');
        tsl.add('		<NOM>SPORT2000</NOM>');
        tsl.add('		<ORDRES>');
        tsl.add('			<ORDRE>');
        tsl.add('				<NOM>CCSVS</NOM>');
        tsl.add('				<TYPE>PROCEDURE</TYPE>');
        tsl.add('				<DATA>EXECUTE PROCEDURE CCSVS_PARAMDEFAUTSP2K</DATA>');
        tsl.add('			</ORDRE>');
        tsl.add('			<ORDRE>');
        tsl.add('				<NOM>TRAIT_BECOL</NOM>');
        tsl.add('				<TYPE>PROCEDURE</TYPE>');
        tsl.add('				<DATA>EXECUTE PROCEDURE ST_MAJ_TRAIT_BECOL</DATA>');
        tsl.add('			</ORDRE>');
        tsl.add('			<ORDRE>');
        tsl.add('				<NOM>GT_JA_SP2000</NOM>');
        tsl.add('				<TYPE>PROCEDURE</TYPE>');
        tsl.add('				<DATA>EXECUTE PROCEDURE SM_SP2000_GT_JA</DATA>');
        tsl.add('			</ORDRE>');
        tsl.add('		</ORDRES>');
        tsl.add('	</CENTRALE>');
        tsl.add('	<CENTRALE>');
        tsl.add('		<NOM>MONDOVELO</NOM>');
        tsl.add('		<ORDRES>');
        tsl.add('			<ORDRE>');
        tsl.add('				<NOM>TRAIT_BECOL</NOM>');
        tsl.add('				<TYPE>PROCEDURE</TYPE>');
        tsl.add('				<DATA>EXECUTE PROCEDURE ST_MAJ_TRAIT_BECOL</DATA>');
        tsl.add('			</ORDRE>');
        tsl.add('			<ORDRE>');
        tsl.add('				<NOM>CCSVS</NOM>');
        tsl.add('				<TYPE>PROCEDURE</TYPE>');
        tsl.add('				<DATA>EXECUTE PROCEDURE CCSVS_PARAMDEFAUTSP2K</DATA>');
        tsl.add('			</ORDRE>');
        tsl.add('		</ORDRES>');
        tsl.add('	</CENTRALE>');
        tsl.add('</CENTRALES>');
        tsl.SaveToFile(IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) + S + '.xml');
      except
        on e:exception do
          LogDebug(FichierLog,'Exception:' + e.Message);
      end;
    END;
//    memo1.Lines.Add('TMP_DBG: XML="' + IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) + S + '.xml' + '"');
    try
      Xml_DocOrdre.LoadFromFile(IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) + S + '.xml');
    except
      on e:exception do
      begin
        LogDebug(FichierLog,'Xml_DocOrdre.LoadFromFile - Exception:'+e.ClassName + '/' + e.Message);
        exit;
      end;
    end;
//    Xml := TmonXML.Create;
    Tc := Tconnexion.create;

    Label3.caption := databases;
    Label3.Update;
    try
//      xml.LoadFromFile(databases);

      Xml_Doc := TXMLDocument.Create(nil);
      Xml_Doc.LoadFromFile(databases);
      Xml_Datasources := GetDataSources(Xml_Doc);
      for iDts := 0 to Xml_Datasources.Count -1 do
      begin
        Xml_Datasource := Xml_Datasources.DataSource[iDts];
        NomClient := Xml_Datasource.Name;
        Xml_Params := Xml_Datasource.Params;
        for iPrm := 0 to Xml_Params.Count -1 do
        begin
          Xml_Param := Xml_Params.Param[iPrm];
          if Xml_Param.Name = 'SERVER NAME' then
          begin
            LaBase := Xml_Param.Value;
{$REGION 'la merde'}
////////////////////////////////////////////////////////////////////////////////
                IF pos(':', labase) < 3 THEN
                BEGIN
                    labase := machine + ':' + labase;
                END;
                LaMachine := copy(labase, 1, pos(':', labase) - 1);           //SR : Je tiens à préciser que ce n'est pas mon code. Je l'ai juste amélioré.
                LaCentrale := labase;                                         //SR : exemple avec   : SYMREPLIC2:F:\EAI\INTERSPORT\ALLONCLE\DATA\GINKOIA.IB
                Delete(LaCentrale, 1, pos('\', LaCentrale));                  //SR : Suppression de : SYMREPLIC2:F:\

                IF AnsiPos('EAI\', UpperCase(LaCentrale)) <> 0 THEN           //SR : Si on trouve 'EAI\' on le supprime.
                begin
                  Delete(LaCentrale, 1, pos('\', LaCentrale));                //SR : Suppression de : EAI\
                end;

                LaCentrale := Copy(LaCentrale, 1, pos('\', LaCentrale) - 1);  //SR : On récupère le nom de la centrale : INTERSPORT

                Lab_Etape.caption := '';
                Lab_Etape.Update;
                Lab_Base.caption := ('Traitement : ' + labase);
                Lab_Base.Update;
                data.DatabaseName := labase;
                LogDebug(FichierLog,'Traitement (La Machine: '+LaMachine+' ; La Centrale: '+LaCentrale+' ; la base: '+labase+' ; Nom Client: '+NomClient);

                if not FDebug then
                  begin
                    try
                      TRY
                        vAllowExecJob:= True;

                        LogDebug(FichierLog,'Ouverture de data');
                        data.open;
                        if ChkBxBaseMaintenance.Checked then
                          begin
                            DB_MAINTENANCE.Open;
                            IBTransMaintenance.Active:= True;
                          end;

                        QryGENVERSION.Open;

                        if (not QryGENVERSION.Eof) and (IsJetonVersion(QryGENVERSION.FieldByName('VER_VERSION').AsString)) then
                          begin
                            LogDebug(FichierLog,'Récupération des paramétres des jetons');
                            tpJeton := GetParamsToken(labase,'ginkoia','ginkoia');    //Prise en compte des Jetons
                            bJeton  := False;

                            if tpJeton.bLectureOK then
                            begin
                              LogDebug(FichierLog,'Prise de jeton');
                              i := 1;

                              vNbEssais:= 5;
                              while (not bJeton) and (i < vNbEssais) do
                              begin
                                bJeton  := StartTokenEnBoucle(tpJeton,30000);             //On rafraichi toute les 30s

                                if not bJeton then    //Si pas de jeton
                                begin
//                                  LogDebug(FichierLog,'Impossible de prendre un Jeton');
                                  LogDebug(FichierLog,'Impossible de prendre un Jeton. Tentative : '+ IntToStr(i) +' sur ' + IntToStr(vNbEssais) + '.');
                                  sleep(30000);       //Pause de 30s
                                  Inc(i);             //On incrémente le nombre d'essai
                                end
                                else
                                  Break;  // Jeton trouvé
                              end;
                            end;

                            LogDebug(FichierLog,'Contrôle jeton bJeton = '+BoolToStr(bJeton)+' ; tpJeton.bLectureOK: ' + BoolToStr(tpJeton.bLectureOK));
                            vAllowExecJob:= (bJeton and tpJeton.bLectureOK) or (not bJeton and not tpJeton.bLectureOK);
                          end;

                        if vAllowExecJob then
                        begin
                          // On vérifie que les GUID existe
//                          memo1.Lines.Add('TMP_DBG: CreationGUID:Try');
                          CreationGUID(NomClient, LaCentrale);
//                          memo1.Lines.Add('TMP_DBG: CreationGUID:OK');
                          // recherche sur yellis du GUID de chaque base
//                          memo1.Lines.Add('TMP_DBG: AffecteYellis:Try');
                          majMagCode;
                          AffecteYellis(TC, NomClient, LaMachine, LaCentrale);
//                          memo1.Lines.Add('TMP_DBG: AffecteYellis:Ok');
                          // création du log
                          IF FFaitLeLog THEN
                              CreationLog(NomClient, LaMachine, LaCentrale);
                          // traitement spécifique version
                          LogDebug(FichierLog,'traitement spécifique version');
//                          memo1.Lines.Add('TMP_DBG: Process:Try');
//                          Process( Xml_DocOrdre, Xml, passXML2 );
                          Process( Xml_DocOrdre, LaCentrale );
//                          memo1.Lines.Add('TMP_DBG: AffecteYellis:Ok');
//                          memo1.Lines.Add('TMP_DBG: traitement_rtf:Try');
                          traitement_rtf;
//                          memo1.Lines.Add('TMP_DBG: traitement_rtf:Ok');
//                          memo1.Lines.Add('TMP_DBG: majMagCode:Try');

                          majFTPArchivage;
//                          memo1.Lines.Add('TMP_DBG: majMagCode:Ok');
                        end
                        else
                        begin
                          LogDebug(FichierLog,'Impossible de prendre un Jeton.');
//                          memo1.lines.add('Impossible de prendre un Jeton.');
                        end;
                      EXCEPT  on E:exception do
                        begin
                          LogDebug(FichierLog,'prob sur la base : '+E.Message);
//                          memo1.lines.add('prob sur la base : '+E.Message);
                        end;
                      END;
                    finally
                      data.Close;
                      if ChkBxBaseMaintenance.Checked then
                        DB_MAINTENANCE.Close;
                      if bJeton then
                        StopTokenEnBoucle;      //Relache le jeton
                    end;
                  end;
////////////////////////////////////////////////////////////////////////////////
{$ENDREGION}
          end;
        end;
      end;
    except
      on e:exception do
      begin
        LogDebug(FichierLog,'xml_Doc.LoadFromFile - Exception:'+e.ClassName + '/' + e.Message);
        exit;
      end;
    end;
END;


procedure TForm1.ExecJobListe(Dossier: TDossier);
VAR
    LaBase: STRING;
    Tc: Tconnexion;
    NomClient: STRING;
    LaMachine: STRING;
    LaCentrale: STRING;

//    XMLExecute: TmonXML;
//    XMLExecute : TXMLDocument;
    s: STRING;
    tsl: tstringList;
    _nom, _tipe, _data: STRING;
    tpJeton : TTokenParams;
    bJeton  : Boolean;        //Vrai si on a le jeton sinon faux
    i, vNbEssais: Integer;    //Compteur pour les jetons / Nombre d'essais
    vAllowExecJob: Boolean;

    Xml_DocOrdre : TXMLDocument;
    Xml_Centrales : IXMLCENTRALESType;
    Xml_Centrale : IXMLCENTRALEType;
    Xml_Ordres : IXMLORDRESType;
    Xml_Ordre : IXMLORDREType;

    iDts, iPrm : integer;
BEGIN
    LogDebug(FichierLog,'Execute traitement (Base: ' + Dossier.Base);
    Xml_DocOrdre := TXMLDocument.Create(nil);
    IF NOT FileExists(IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) + Dossier.Version + '.xml') THEN
    BEGIN
      try
        tsl := TStringList.Create;
        tsl.add('<CENTRALES>');
        tsl.add('	<CENTRALE>');
        tsl.add('		<NOM>SPORT2000</NOM>');
        tsl.add('		<ORDRES>');
        tsl.add('			<ORDRE>');
        tsl.add('				<NOM>CCSVS</NOM>');
        tsl.add('				<TYPE>PROCEDURE</TYPE>');
        tsl.add('				<DATA>EXECUTE PROCEDURE CCSVS_PARAMDEFAUTSP2K</DATA>');
        tsl.add('			</ORDRE>');
        tsl.add('			<ORDRE>');
        tsl.add('				<NOM>TRAIT_BECOL</NOM>');
        tsl.add('				<TYPE>PROCEDURE</TYPE>');
        tsl.add('				<DATA>EXECUTE PROCEDURE ST_MAJ_TRAIT_BECOL</DATA>');
        tsl.add('			</ORDRE>');
        tsl.add('			<ORDRE>');
        tsl.add('				<NOM>GT_JA_SP2000</NOM>');
        tsl.add('				<TYPE>PROCEDURE</TYPE>');
        tsl.add('				<DATA>EXECUTE PROCEDURE SM_SP2000_GT_JA</DATA>');
        tsl.add('			</ORDRE>');
        tsl.add('		</ORDRES>');
        tsl.add('	</CENTRALE>');
        tsl.add('	<CENTRALE>');
        tsl.add('		<NOM>MONDOVELO</NOM>');
        tsl.add('		<ORDRES>');
        tsl.add('			<ORDRE>');
        tsl.add('				<NOM>TRAIT_BECOL</NOM>');
        tsl.add('				<TYPE>PROCEDURE</TYPE>');
        tsl.add('				<DATA>EXECUTE PROCEDURE ST_MAJ_TRAIT_BECOL</DATA>');
        tsl.add('			</ORDRE>');
        tsl.add('			<ORDRE>');
        tsl.add('				<NOM>CCSVS</NOM>');
        tsl.add('				<TYPE>PROCEDURE</TYPE>');
        tsl.add('				<DATA>EXECUTE PROCEDURE CCSVS_PARAMDEFAUTSP2K</DATA>');
        tsl.add('			</ORDRE>');
        tsl.add('		</ORDRES>');
        tsl.add('	</CENTRALE>');
        tsl.add('</CENTRALES>');
        tsl.SaveToFile(IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) + Dossier.Version + '.xml');
      except
        on e:exception do
          LogDebug(FichierLog,'Exception:' + e.Message);
      end;
    END;
//    memo1.Lines.Add('TMP_DBG: XML="' + IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) + S + '.xml' + '"');
    try
      Xml_DocOrdre.LoadFromFile(IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) + Dossier.Version + '.xml');
    except
      on e:exception do
      begin
        LogDebug(FichierLog,'Xml_DocOrdre.LoadFromFile - Exception:'+e.ClassName + '/' + e.Message);
        exit;
      end;
    end;
//    Xml := TmonXML.Create;
    Tc := Tconnexion.create;

    Label3.caption := Dossier.Base;
    Label3.Update;
    try
      LaBase := Dossier.Base;

{$REGION 'la merde'}
////////////////////////////////////////////////////////////////////////////////
      LaMachine := copy(labase, 1, pos(':', labase) - 1);           //SR : Je tiens à préciser que ce n'est pas mon code. Je l'ai juste amélioré.
      LaCentrale := Dossier.NomCentrale;                                         //SR : exemple avec   : SYMREPLIC2:F:\EAI\INTERSPORT\ALLONCLE\DATA\GINKOIA.IB
      NomClient := Dossier.Nom;
      Lab_Etape.caption := '';
      Lab_Etape.Update;
      Lab_Base.caption := ('Traitement : ' + labase);
//      memo1.lines.add(labase);
      Lab_Base.Update;
      data.DatabaseName := labase;
      LogDebug(FichierLog,'Traitement (La Machine: '+LaMachine+' ; La Centrale: '+LaCentrale+' ; la base: '+labase+' ; Nom Client: '+NomClient);

      if not FDebug then
        begin
          try
            TRY
              vAllowExecJob:= True;

              LogDebug(FichierLog,'Ouverture de data');
              data.open;
              if ChkBxBaseMaintenance.Checked then
                begin
                  DB_MAINTENANCE.Open;
                  IBTransMaintenance.Active:= True;
                end;

              QryGENVERSION.Open;

              if (not QryGENVERSION.Eof) and (IsJetonVersion(QryGENVERSION.FieldByName('VER_VERSION').AsString)) then
                begin
                  LogDebug(FichierLog,'Récupération des paramétres des jetons');
                  tpJeton := GetParamsToken(labase,'ginkoia','ginkoia');    //Prise en compte des Jetons
                  bJeton  := False;

                  if tpJeton.bLectureOK then
                  begin
                    LogDebug(FichierLog,'Prise de jeton');
                    i := 1;

                    vNbEssais:= 5;
                    while (not bJeton) and (i < vNbEssais) do
                    begin
                      bJeton  := StartTokenEnBoucle(tpJeton,30000);             //On rafraichi toute les 30s

                      if not bJeton then    //Si pas de jeton
                      begin
//                        LogDebug(FichierLog,'Impossible de prendre un Jeton');
                        LogDebug(FichierLog,'Impossible de prendre un Jeton. Tentative : '+ IntToStr(i) +' sur ' + IntToStr(vNbEssais) + '.');
                        sleep(30000);       //Pause de 30s
                        Inc(i);             //On incrémente le nombre d'essai
                      end
                      else
                        Break;  // Jeton trouvé
                    end;
                  end;

                  LogDebug(FichierLog,'Contrôle jeton bJeton = '+BoolToStr(bJeton)+' ; tpJeton.bLectureOK: ' + BoolToStr(tpJeton.bLectureOK));
                  vAllowExecJob:= (bJeton and tpJeton.bLectureOK) or (not bJeton and not tpJeton.bLectureOK);
                end;

              if vAllowExecJob then
              begin
                // On vérifie que les GUID existe
//                          memo1.Lines.Add('TMP_DBG: CreationGUID:Try');
                CreationGUID(NomClient, LaCentrale);
//                          memo1.Lines.Add('TMP_DBG: CreationGUID:OK');
                // recherche sur yellis du GUID de chaque base
//                          memo1.Lines.Add('TMP_DBG: AffecteYellis:Try');
                majMagCode;
                AffecteYellis(TC, NomClient, LaMachine, LaCentrale);
//                          memo1.Lines.Add('TMP_DBG: AffecteYellis:Ok');
                // création du log
                IF FFaitLeLog THEN
                    CreationLog(NomClient, LaMachine, LaCentrale);
                // traitement spécifique version
                LogDebug(FichierLog,'tsraitement spécifique version');
//                          memo1.Lines.Add('TMP_DBG: Process:Try');
//                          Process( Xml_DocOrdre, Xml, passXML2 );
                Process( Xml_DocOrdre, LaCentrale );
//                          memo1.Lines.Add('TMP_DBG: AffecteYellis:Ok');
//                          memo1.Lines.Add('TMP_DBG: traitement_rtf:Try');
                traitement_rtf;
//                          memo1.Lines.Add('TMP_DBG: traitement_rtf:Ok');
//                          memo1.Lines.Add('TMP_DBG: majMagCode:Try');

                majFTPArchivage;
//                          memo1.Lines.Add('TMP_DBG: majMagCode:Ok');
              end
              else
              begin
                LogDebug(FichierLog,'Impossible de prendre un Jeton.');
//                memo1.lines.add('Impossible de prendre un Jeton.');
              end;
            EXCEPT  on E:exception do
              begin
                LogDebug(FichierLog,'prob sur la base : '+E.Message);
//                memo1.lines.add('prob sur la base : '+E.Message);
              end;
            END;
          finally
            data.Close;
            if ChkBxBaseMaintenance.Checked then
              DB_MAINTENANCE.Close;
            if bJeton then
              StopTokenEnBoucle;      //Relache le jeton
          end;
        end;
////////////////////////////////////////////////////////////////////////////////
{$ENDREGION}

    except
      on e:exception do
      begin
        LogDebug(FichierLog,'xml_Doc.LoadFromFile.Exception='+e.ClassName + '/' + e.Message);
        exit;
      end;
    end;
end;

function TForm1.parcour2(const AMachine, ADirectory: String): integer;

  procedure Start(Const ASearchIn: integer);
  var
    i: integer;
    vSLFiles: TStringList;
    vRootDir, vDir: String;
  begin
    vSLFiles:= TStringList.Create;
    try
      LogDebug(FichierLog, AMachine + ' en cours');
//      memo1.lines.add(AMachine + ' en cours');

      vDir:= IncludeTrailingBackslash(ADirectory);
      vRootDir:= '\\' + AMachine + vDir;

      SearchDataBaseXML(vRootDir, vSLFiles, ASearchIn);

      Result:= vSLFiles.Count;

      LogDebug(FichierLog, AMachine + ' : ' + IntToStr(Result) + ' fichier(s) Xml trouvé(s)');
//      memo1.lines.add(AMachine + ' : ' + IntToStr(Result) + ' fichier(s) Xml trouvé(s)');

      for i:= 0 to vSLFiles.Count -1 do
        begin
          if FileExists(vSLFiles.Strings[i]) then
            ExecJob(AMachine, vSLFiles.Strings[i]);
        end;

    finally
      FreeAndNil(vSLFiles);
    end;
  end;

var
  i: integer;
begin
  if RdGrpSearchIn.ItemIndex = 2 then
    begin
      for i:= 0 to RdGrpSearchIn.Items.Count -2 do
        Start(i);
    end
  else
    Start(RdGrpSearchIn.ItemIndex);
end;

function TForm1.GetComputerNameLocal: string;
var
  vlpBuffer: array[0..MAX_COMPUTERNAME_LENGTH] of char;
  vSize: dword;
begin
  vSize:= Length(vlpBuffer);
  if GetComputerName(vlpBuffer, vSize) then
    Result:= vlpBuffer
  else
    Result:= '';
end;

function TForm1.GetDriveByLameDirectory(const ADirectory: String): String;
var
  i: integer;
begin
  Result:= '';
  for i:= 0 to LstVwLame.Items.Count -1 do
    begin
      if Pos(UpperCase(LstVwLame.Items[i].Caption), UpperCase(ADirectory)) <> 0 then
        begin
          Result:= Trim(LstVwLame.Items[i].SubItems.Strings[0]);
          Break;
        end;
    end;
end;

function TForm1.GetNewID(const ATableName: String): integer;
begin
  STP_NOUVELID.Close;
  STP_NOUVELID.ParamByName('NOM_GENERATEUR').AsString:= UpperCase(ATableName);
  STP_NOUVELID.ExecProc;
  Result:= STP_NOUVELID.ParamByName('ID').AsInteger;
end;

PROCEDURE TForm1.GoClick(Sender: TObject);
begin
  Traitement_GO;
end;

procedure TForm1.Traitement_GO;
VAR i, vCpt: integer;
BEGIN
  Screen.Cursor:= crHourGlass;
  Go.Enabled:=False;
  BtnVersion.Enabled:=False;
  BtnBase.Enabled:=False;
  try
    vCpt:= 0;
    FichierLog  := 'GUID_Go.log';
    LogDebug(FichierLog,'Début traitement');
    FFaitLeLog := true;
    FLog:= TStringlist.create;

//    FOR i := 0 TO Cb_serveur.items.count - 1 DO //--> Deprecated
//        IF Cb_serveur.Checked[i] THEN
//            parcour(Cb_serveur.items[i], '');

    for i:= 0 to LstVwLame.Items.Count - 1 do
      begin
        if LstVwLame.Items.Item[i].Checked then
//          parcour(LstVwLame.Items.Item[i].Caption, LstVwLame.Items.Item[i].SubItems.Strings[0]); //--> Deprecated
          vCpt:= vCpt + parcour2(LstVwLame.Items.Item[i].Caption, LstVwLame.Items.Item[i].SubItems.Strings[1]);
      end;

//   parcour('PASCAL_FIX');
    IF not(FAuto) then
      begin
        if vCpt <> 0 THEN
          application.MessageBox('c''est fini', 'fini', mb_ok)
        else
          application.MessageBox('Aucun traitement effectué', 'fini', mb_ok);
      end
      else
        begin
           if vCpt <> 0 then
              ExitCode:=0
            else
              ExitCode:=3;
        end;

    FLog.savetofile(IncludeTrailingBackslash(ExtractFilePath(application.exename)) + 'Postes.txt');
    FLog.free;
    FFaitLeLog := false;
    LogDebug(FichierLog,'Fin traitement');
  finally
    Memo1.Lines.Append(cEndLine);
    Screen.Cursor:= crDefault;
    Go.Enabled:=True;
    BtnVersion.Enabled:=True;
    BtnBase.Enabled:=True;
    if not(FAuto) then
      if application.MessageBox('Voulez-vous fermer le GUID.', 'Fermer GUID', MB_YESNO) = IDYES then
        Application.Terminate;
    if FAuto then Application.Terminate;
  end;
END;

procedure TForm1.IdHTTPWork(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Int64);
begin
  
end;

procedure TForm1.IdHTTPWorkBegin(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCountMax: Int64);
begin

end;

procedure TForm1.IdHTTPWorkEnd(ASender: TObject; AWorkMode: TWorkMode);
begin

end;

function TForm1.IsJetonVersion(const AVER_VERSION, AVER_REF: String): Boolean;
var
  i: integer;
  vVerData, vVerRef: TStringList;
begin
  Result:= False;
  vVerData:= TStringList.Create;
  vVerRef:= TStringList.Create;
  try
    if (Length(AVER_VERSION) < 7) or (AVER_VERSION = '0.0.0.0') then
      Exit;

    { Version de reference à partir de laquelle il y a une gestion des jetons }
    vVerRef.Text:= StringReplace(AVER_REF, '.', #13#10, [rfReplaceAll]);

    vVerData.Text:= StringReplace(AVER_VERSION, '.', #13#10, [rfReplaceAll]);

    for i:= 0 to vVerData.Count -1 do
      begin
        if StrToInt(vVerData.Strings[i]) > StrToInt(vVerRef.Strings[i]) then
          begin
            Result:= True;
            Break;
          end
        else
          if StrToInt(vVerData.Strings[i]) < StrToInt(vVerRef.Strings[i]) then
            Break;
      end;

  finally
    FreeAndNil(vVerData);
    FreeAndNil(vVerRef);
  end;
end;

//function TForm1.LecteurValeurIni(AFileIni, ASection, AIdent,
//  ADefault: String): String;
////Fonction de lecture d'une valeur dans le fichier Ini
//Var
//  FichierIni  : TIniFile;
//begin
//  Try
//    //Ouverture ou création du fichier ini
//    FichierIni  := TIniFile.Create(AFileIni);
//
//    //Lecteur de la valeur
//    Result := FichierIni.ReadString(ASection, AIdent, ADefault);
//  Finally
//    FichierIni.Free;
//    FichierIni  := nil;
//  End;
//end;


function TForm1.LoadBaseMaintenance_Easy(aDossID:integer=0): TDossiers;
var
  aDossier : TDossier;
begin
  result := nil;
  QrySelectMaintenance.Close;
  QrySelectMaintenance.SQL.clear;
  QrySelectMaintenance.SQL.add('SELECT * ');
  QrySelectMaintenance.SQL.add('FROM DOSSIER ');
  QrySelectMaintenance.SQL.add('WHERE doss_easy = 1 AND doss_actif = 1');
  if (aDossID > 0) then
  begin
    QrySelectMaintenance.SQL.Add(' AND DOSS_ID = :doss_id');
    QrySelectMaintenance.ParamByName('doss_id').AsInteger := aDossID;
  end;
  QrySelectMaintenance.SQL.Add(' ORDER BY DOSS_DATABASE ASC');
  LogDebug(FichierLog,'Try LoadBaseMaintenance : QrySelectMaintenance.Open');
  try
    QrySelectMaintenance.Open;
    LogDebug(FichierLog,'Ok LoadBaseMaintenance : QrySelectMaintenance.Open');
  except
    on e:exception do
    begin
      LogDebug(FichierLog,'Nok LoadBaseMaintenance : QrySelectMaintenance.Open');
      raise e;
    end;
  end;
  result := TDossiers.Create;
  QrySelectMaintenance.First;
  while not QrySelectMaintenance.eof do
  begin
    aDossier := TDossier.create;
    aDossier.Nom := QrySelectMaintenance.FieldByName('DOSS_DATABASE').AsString;
    aDossier.Base := QrySelectMaintenance.FieldByName('DOSS_CHEMIN').AsString;
    aDossier.DOSS_ID := QrySelectMaintenance.FieldByName('DOSS_ID').AsInteger;
    result.Add(aDossier);
    QrySelectMaintenance.Next;
  end;
end;


function TForm1.LoadBaseMaintenance: TDossiers;
var
  aDossier : TDossier;
begin
  result := nil;
  QrySelectMaintenance.Close;
  QrySelectMaintenance.SQL.clear;
  QrySelectMaintenance.SQL.add('select distinct doss_database, grou_id, grou_Nom, vers_version, serv_nom, doss_chemin ');
  QrySelectMaintenance.SQL.add('from DOSSIER ');
  QrySelectMaintenance.SQL.add('join Groupe on doss_grouid = grou_id ');
  QrySelectMaintenance.SQL.add('join serveur on doss_servid = serv_id ');
  QrySelectMaintenance.SQL.add('join magasins on maga_dossid = doss_id ');
  QrySelectMaintenance.SQL.add('join emetteur on emet_dossid = doss_id ');
  QrySelectMaintenance.SQL.add('join version on emet_versid = vers_id ');
  QrySelectMaintenance.SQL.add('join MODULES_MAGASINS on maga_id = mmag_magaid ');
  LogDebug(FichierLog,'Try LoadBaseMaintenance : QrySelectMaintenance.Open');
  try
    QrySelectMaintenance.Open;
    LogDebug(FichierLog,'Ok LoadBaseMaintenance : QrySelectMaintenance.Open');
  except
    on e:exception do
    begin
      LogDebug(FichierLog,'Nok LoadBaseMaintenance : QrySelectMaintenance.Open');
      raise e;
    end;
  end;
  result := TDossiers.Create;
  QrySelectMaintenance.First;
  while not QrySelectMaintenance.eof do
  begin
    aDossier := TDossier.create;
    aDossier.Nom := QrySelectMaintenance.FieldByName('DOSS_DATABASE').AsString;
    aDossier.NomCentrale := QrySelectMaintenance.FieldByName('GROU_NOM').asString;
    aDossier.Version := QrySelectMaintenance.FieldByName('VERS_VERSION').AsString;
    aDossier.Serveur := QrySelectMaintenance.FieldByName('SERV_NOM').AsString;
    aDossier.Base := QrySelectMaintenance.FieldByName('DOSS_CHEMIN').AsString;
    aDossier.Centrale := TCentrale(strtointdef(QrySelectMaintenance.FieldByName('GROU_ID').AsString,0));
    aDossier.DOSS_ID := QrySelectMaintenance.FieldByName('DOSS_ID').AsInteger;
    result.Add(aDossier);
    QrySelectMaintenance.Next;
  end;
end;

procedure TForm1.LoadParams;
var
  i: integer;
  vIniFile: TIniFile;
  vSLLame, vSLDir: TStringList;
  vListItm: TListItem;
  Buffer, vDrive, vDirectory: String;
  vLameSourceScript: String;
begin
  LstVwLame.Items.Clear;
  vSLLame:= TStringList.Create;
  vSLDir:= TStringList.Create;
  try
    vIniFile:= TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));

    FAPIURL := vIniFile.ReadString(cGinkoiaTools, cAPIURL, 'http://tools.ginkoia.net/');
    FAPIKEY := vIniFile.ReadString(cGinkoiaTools, cAPIKEY, '289e76e157d5af3dd00ae331313b6bf0');

    FLecteurLame:= vIniFile.ReadString(cSecGENERAL, cItmLECTEURLAME, 'D');
    RdGrpSearchIn.ItemIndex:= vIniFile.ReadInteger(cSecGENERAL, cItmSEARCHIN, 0);
    FDatabaseNameMaintenance:= vIniFile.ReadString(cSecGENERAL, cItmDATABASEMAINTENANCE, '');
    ChkBxBaseMaintenance.Checked:= vIniFile.ReadBool(cSecGENERAL, cItmBaseMaintenance, False);

    FApiUrlMaintenance  := vIniFile.ReadString(cSecGENERAL, cItmApiUrlMaintenance, '');

    ChkBxMaintenanceLog.Checked:= Boolean(vIniFile.ReadInteger(cSecGENERAL, cItmMaintenanceLog, 0));

    FURLSOURCEPATCH:= ExcludeTrailingBackslash(vIniFile.ReadString(cSecGENERAL, cItmURLSOURCEPATCH, 'http://lame2.no-ip.com/MAJ/Patch'));
    vLameSourceScript:= vIniFile.ReadString(cSecGENERAL, cItmLAMESOURCEPATCH, 'GSA-LAME2');

    FIsSourceScriptHTTP:= UpperCase(vLameSourceScript) <> GetComputerNameLocal;

    if FIsSourceScriptHTTP then
      Buffer:= FURLSOURCEPATCH
    else
      Buffer:= 'Local sur ' + vLameSourceScript;

    StBrMain.SimpleText:= 'Source script : ' + Buffer;

    vIniFile.ReadSectionValues(cSecLAMES, vSLLame);
    vIniFile.ReadSectionValues(cSecDIRECTORY, vSLDir);

    for i:= 0 to vSLLame.Count - 1 do
      begin
        vListItm:= LstVwLame.Items.Add;
        vListItm.Caption:= vSLLame.ValueFromIndex[i];
        vListItm.Checked:= True;

        if (vSLDir.Count <> 0) and (i in [0..vSLDir.Count-1]) then
          begin
            vDrive:= '';
            vDirectory:= vSLDir.ValueFromIndex[i];
            if Pos(':', vDirectory) <> 0 then
              begin
                vDrive:= ExtractFileDrive(vDirectory);
                vDirectory:= StringReplace(vDirectory,  vDrive, '', []);
              end;
            vListItm.SubItems.Append(vDrive);
            vListItm.SubItems.Append(vDirectory);
          end;
      end;

  finally
    FreeAndNil(vIniFile);
    FreeAndNil(vSLLame);
    FreeAndNil(vSLDir);
  end;
end;

procedure TForm1.LogDebug(FileLogName, Texte: String);
Var
  LogFile       : TextFile;   //Variable d'accès au fichier
  CheminLog     : String;     //Chemin du fichier de log
Begin
  CheminLog := IncludeTrailingPathDelimiter(ExtractFilePath(application.ExeName));
  ForceDirectories(CheminLog);
  AssignFile(LogFile,CheminLog+FileLogName);
  if Not FileExists(CheminLog+FileLogName) then
    ReWrite(LogFile)
  else
    Append(LogFile);
  try
    Writeln(LogFile,DatetimeToStr(now)+#9#9+ '=> ' + Texte);
  finally
    CloseFile(LogFile);
  end;
  try
    memo1.lines.add(Texte);
  except
  end;
end;

procedure TForm1.majFTPArchivage;
var
  api : TApiResult<TDossierStorage>;
  GUID, sFullURL,sParam  : string;
  i : integer;
  id : integer;
  stmp : string;
begin
  if not IBQue_Base.Active then
    IBQue_Base.Open;
  LogDebug(FichierLog,'majFTPArchivage:Debut');
  Que_GUIDBASE.Close;
  Que_GUIDBASE.ParamByName('BASID').AsInteger := IBQue_BaseBAS_ID.AsInteger;
  Que_GUIDBASE.Open;
  GUID := Que_GUIDBASEBAS_GUID.AsString;
  LogDebug(FichierLog,'majFTPArchivage:GUID='+GUID);
  Que_GUIDBASE.Close;
  stmp := '';
  api := TApiResult<TDossierStorage>.create;
  try
    try
      sFullURL := FAPIURL + 'api/ginkoia/tools/getDossierStorageByGuid.php';
      sParam := '?guid=' + GUID + '&apiKey=' + FAPIKEY;
      LogDebug(FichierLog,'majFTPArchivage:Get Api=' + sFullURL + sParam);
      api.get(sFullURL, sParam);
      if api.ErrNo = 0 then
        stmp := api.getResult.Dossier.Nom + ':' + api.getResult.Storage.PassWord + '@' + api.getResult.Storage.HostName + '/Archives';
    except
      on e:exception do
        LogDebug(FichierLog,'majFTPArchivage:Echec Get API='+e.Message);
    end;
    if api.ErrNo = 0 then
    begin
      if stmp <> '' then
      begin
        if not Sql.Transaction.InTransaction then       //SR - 11/07/2014 - Passage au StartTransaction au lieu du Active := true;
          Sql.Transaction.StartTransaction;
        try
          sql.close;
          sql.SQL.text := 'select prm_id, prm_string from genparam where prm_code=4 and prm_type=60';
          sql.ExecQuery;
          while not sql.eof do
          begin
            id := sql.FieldByName('prm_id').asinteger;
            if id > 0 then
            begin
              if (sql.FieldByName('prm_string').asString <> stmp) then
              begin
                sql2.close;
                sql2.sql.clear;
                sql2.SQL.text := 'update genparam set prm_string = '+quotedstr(stmp) + ' where prm_id='+inttostr(id);
                LogDebug(FichierLog,'majFTPArchivage:OK:'+sql2.SQL.text);
                sql2.ExecQuery;
                sql2.close;
                sql2.SQL.text := 'execute procedure pr_updatek('+inttostr(id)+',0)';
                sql2.ExecQuery;
              end;
            end;
            sql.Next;
          end;
        finally
          IF Sql.Transaction.InTransaction THEN
              Sql.Transaction.Commit;
        end;
      end
      else LogDebug(FichierLog,'majFTPArchivage:Echec pas d''URL');
    end
    else LogDebug(FichierLog,'majFTPArchivage:'+api.Error);
  finally
    api.free;
  end;
end;

procedure TForm1.majMagCode;
var
  api : TApiResult;
  GUID,sFullURL,sParam  : string;
  i : integer;
  id : integer;
  stmp : string;
begin
  if not IBQue_Base.Active then
    IBQue_Base.Open;
  LogDebug(FichierLog,'majMagCode:Debut');
  Que_GUIDBASE.Close;
  Que_GUIDBASE.ParamByName('BASID').AsInteger := IBQue_BaseBAS_ID.AsInteger;
  Que_GUIDBASE.Open;
  GUID := Que_GUIDBASEBAS_GUID.AsString;
  LogDebug(FichierLog,'majMagCode:GUID='+GUID);
  Que_GUIDBASE.Close;
  api := TApiResult.create;
  try
    try
      sFullURL := FAPIURL + 'api/ginkoia/tools/getMagasinsByGuid.php';
      sParam := '?guid=' + GUID;
      LogDebug(FichierLog,'majMagCode:Get Api=' + sFullURL + sParam);
      api.get(sFullURL, sParam);
    except
      on e:exception do
        LogDebug(FichierLog,'majMagCode:Echec Get API='+e.Message);
    end;

    if not Sql.Transaction.InTransaction then       //SR - 11/07/2014 - Passage au StartTransaction au lieu du Active := true;
      Sql.Transaction.StartTransaction;

    try
      LogDebug(FichierLog,'majMagCode:api.result "' + IntToStr(Length(api.Result)) );
      for I := 0 to length(api.Result)-1 do
      begin
        sql.close;
        sql.SQL.text := 'select mag_id, mag_code from genmagasin where mag_nom=' + QuotedStr(api.Result[i].Nom);
        LogDebug(FichierLog,'majMagCode:Maj de "' + api.Result[i].nom+'"');
        try
          sql.ExecQuery;
          if not sql.Eof then
            id := sql.FieldByName('mag_id').AsInteger;
          if ((sql.FieldByName('mag_code').AsString = '') and (api.Result[i].Code <> '')) then
          begin
            if id > 0 then
            begin
              sql.close;
              sql.SQL.text := 'update genmagasin set mag_code=' + quotedstr(api.Result[i].Code) + ' where mag_id=' + inttostr(id);
              LogDebug(FichierLog,'majMagCode:Maj de "' + api.Result[i].Nom + '" (mag_code=' + api.Result[i].Code + '['+inttostr(i)+'/'+inttostr(length(api.Result)-1)+'])');
              sql.ExecQuery;
              sql.close;
              sql.SQL.text := 'execute procedure pr_updatek('+inttostr(id)+',0)';
              sql.ExecQuery;
            end;
          end;
        except
          on e:exception do
            LogDebug(FichierLog,'sql:"'+sql.SQL.text+'" exception:'+e.Message);
        end;
      end;

    finally
      IF Sql.Transaction.InTransaction THEN
          Sql.Transaction.Commit;
    end;
  finally
    api.free;
  end;
end;

function TForm1.isNewMaj(var sUrl, sGuid, sVersion : String): boolean;
var
  AQuery : TIBQuery;
  bActif : boolean;
begin
  result := false;
  AQuery:=TIBQuery.Create(nil);
  try
    AQuery.Database:=data;
    AQuery.Transaction:=tran;
    AQuery.Close;
    AQuery.SQL.clear;
    AQuery.SQL.Add('select PRM_INTEGER, PRM_STRING from GENPARAM where prm_type=60 and prm_code=6');
    AQuery.Open;
    if not AQuery.Eof then
    begin
      sUrl := AQuery.FieldByName('PRM_STRING').AsString;
      bActif := (AQuery.FieldByName('PRM_INTEGER').AsInteger = 1);
    end;
    AQuery.SQL.clear;
    AQuery.SQL.Add('SELECT BAS_GUID FROM GENBASES ');
    AQuery.SQL.Add('JOIN K ON K_ID = BAS_ID AND K_ENABLED=1 ');
    AQuery.SQL.Add('JOIN GENPARAMBASE ON PAR_NOM=''IDGENERATEUR'' AND PAR_STRING = BAS_IDENT  ');
    AQuery.SQL.Add('ROWS 1');
    AQuery.Open ;
    if not AQuery.eof then
      sGuid := AQuery.FieldByName('BAS_GUID').AsString;

    AQuery.Close;
    AQuery.SQL.clear;
    AQuery.SQL.Add('select ver_version from genversion order by ver_date desc');
    AQuery.Open ;
    if not AQuery.eof then
      sVersion := AQuery.FieldByName('VER_VERSION').AsString;

    result := (bActif and (sUrl <> '') and (sGuid <> '') and (sVersion <> ''));
  finally
    AQuery.Free;
  end;
end;

PROCEDURE TForm1.FormCreate(Sender: TObject);
VAR i: integer;
    //sListFilePath : String;
    param,value:string;
BEGIN
  slError := TStringList.Create;
  FDebug:= False;
  FFaitLeLog := false;
  Lab_Base.caption := '';
  Lab_Etape.caption := '';
  Label3.caption := '';
  FFirst := true;
  FVersion6plus := false;
  Form1.caption := Form1.caption + '   -   V'+GetNumVersionSoft;
  FAutoVersion:='';
  FAutoDatabase:='';
  LoadParams;
  FAuto:=False;
  FAutoGo:=False;
  FNewAuto := false;
  FEasyAuto := False;
  FEasyManuel := False;
  FLastDataBaseSync:= '';

  for i := 1 to ParamCount do
     begin
          if (lowercase(ParamStr(i))='go') then FAutoGo := true;
          if (lowercase(ParamStr(i))='auto') then FNewAuto := true;
          if (lowercase(ParamStr(i))='easyauto') then FEasyAuto := true;
          //--------------------------------------------------------------------
          param:=Copy(ParamStr(i),1,Pos('=',ParamStr(i))-1);
          value:=Copy(ParamStr(i),Pos('=',ParamStr(i))+1,length(ParamStr(i)));
          If lowercase(param)='version'  then FAutoVersion  := value;
          If lowercase(param)='database' then FAutoDatabase := value;
     end;
    if (FAutoGo) and (FAutoVersion='') and (FAutoDatabase='')
      then FAuto:=true;
    if not(FAutoGo) and (FAutoVersion<>'') and (FAutoDatabase='')
      then FAuto:=true;
    if not(FAutoGo) and (FAutoVersion='') and (FAutoDatabase<>'')
      then FAuto:=true;
    if FNewAuto then
      FAuto := true;
  // Lancement dans 1 seconde si en auto...
  tmr1.Enabled:=FAuto or FEasyAuto;
//--> Deprecated
//    sListFilePath := ExtractFilePath(Application.ExeName) + 'GUID.lst';
//    if FileExists(ExtractFilePath(Application.ExeName) + 'GUID.lst') then
//      Cb_serveur.Items.LoadFromFile(sListFilePath);
//
//    FLecteurLame := LecteurValeurIni(IncludeTrailingPathDelimiter(ExtractFilePath(application.ExeName))+'GUID.ini','GENERAL','FLecteurLame','D');

//    FOR i := 0 TO Cb_serveur.items.count - 1 DO
//        Cb_serveur.Checked[i] := true;
//--> Deprecated

END;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  SaveParams;
  slError.Free;
end;

{
Nickel evidement on va mettre ca en FormPaint !!!!!!!! (Humour GR)
PROCEDURE TForm1.FormPaint(Sender: TObject);
BEGIN
    IF FFirst THEN
    BEGIN
        FFirst := false;
        IF paramcount > 0 THEN
        BEGIN
            GoClick(NIL);
            close;
        END;
    END;
END;
}

PROCEDURE TForm1.BtnBaseClick(Sender: TObject);
begin
   Traitement_Databases_EASY_PAR_MAINTENANCE;
end;

procedure TForm1.BtnEasyManuClick(Sender: TObject);
var
  FChoixBaseEasy : TFrm_choixBase;
begin
  // traitement manuel pour une seule base Easy, on propose d'abord la liste des bases disponibles dans la base maintenance connectée
  FEasyManuel := True;
  FChoixBaseEasy := TFrm_choixBase.Create(self);
  try
    FChoixBaseEasy.ShowModal;
    FEasyManuel := False;
  finally
    FChoixBaseEasy.Free;
  end;
end;

procedure TForm1.Traitement_Auto;
var
  Dossiers: TDossiers;
  i,y : integer;
  ListItem : TListItem;
  sFichier : String;
begin
  slError.Clear;
  FichierLog  := 'GUID_Auto.log';
  try
    Dossiers := LoadBaseMaintenance;
    pb.Min := 0;
    pb.Max := Dossiers.Count;
    pb.Step := 1;
    for I := 0 to Dossiers.Count - 1 do
    begin
      ExecJobListe((Dossiers.Items[i] as TDossier));
      pb.StepIt;
      Application.ProcessMessages;
    end;

  except
    on e:exception do
      LogDebug(FichierLog,'Traitement_Auto.Exception:' + e.Message);
  end;

  if (slError.Count > 0) then
  begin
    LogDebug(FichierLog, '********** Récap des Erreurs **********');
    for y := 0 to slError.Count -1 do
      LogDebug(FichierLog, slError[y]);
    LogDebug(FichierLog, '***************************************');
    application.MessageBox('Traitement auto effectué avec des erreurs', '', mb_ok);
  end
  else
    if not FNewAuto then
      application.MessageBox('Traitement auto effectué', '', mb_ok);
end;

function TForm1.IsReplicationEASY:boolean;
var vQuery : TIBQUery;
    vURL :string;
begin
   result:=false;
   If (data.Connected)
     then
      begin
         vQuery := TIBQUery.Create(nil);
         try
          vQuery.Close;
          vQuery.Database := data;
          vQuery.SQL.Clear;
          vQuery.SQL.Add('  SELECT PRM_STRING FROM GENPARAM JOIN K ON (K_ID = PRM_ID AND K_ENABLED = 1)');
          vQuery.SQL.Add('  WHERE PRM_TYPE=80 AND PRM_POS = 0 AND PRM_CODE=1');
          vQuery.Open;
          if not(vQuery.eof) then
            begin
                result:=vQuery.FieldByName('PRM_STRING').asstring<>'';
            end;
          vQuery.Close;
         finally
          vQuery.Free;
         end;
      end;
end;


function TForm1.LoadEasyPostProcedures():TXMLDocument;
var tsl: tstringList;
begin
    result := TXMLDocument.Create(nil);
    IF NOT FileExists(IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) + 'easy.xml') THEN
    BEGIN
      try
        tsl := TStringList.Create;
        try
          tsl.add('<CENTRALES>');
          tsl.add('	<CENTRALE>');
          tsl.add('		<NOM>SPORT2000</NOM>');
          tsl.add('		<ORDRES>');
          tsl.add('			<ORDRE>');
          tsl.add('				<NOM>CCSVS</NOM>');
          tsl.add('				<TYPE>PROCEDURE</TYPE>');
          tsl.add('				<DATA>EXECUTE PROCEDURE CCSVS_PARAMDEFAUTSP2K</DATA>');
          tsl.add('			</ORDRE>');
          tsl.add('			<ORDRE>');
          tsl.add('				<NOM>TRAIT_BECOL</NOM>');
          tsl.add('				<TYPE>PROCEDURE</TYPE>');
          tsl.add('				<DATA>EXECUTE PROCEDURE ST_MAJ_TRAIT_BECOL</DATA>');
          tsl.add('			</ORDRE>');
          tsl.add('			<ORDRE>');
          tsl.add('				<NOM>GT_JA_SP2000</NOM>');
          tsl.add('				<TYPE>PROCEDURE</TYPE>');
          tsl.add('				<DATA>EXECUTE PROCEDURE SM_SP2000_GT_JA</DATA>');
          tsl.add('			</ORDRE>');
          tsl.add('		</ORDRES>');
          tsl.add('	</CENTRALE>');
          tsl.add('	<CENTRALE>');
          tsl.add('		<NOM>MONDOVELO</NOM>');
          tsl.add('		<ORDRES>');
          tsl.add('			<ORDRE>');
          tsl.add('				<NOM>TRAIT_BECOL</NOM>');
          tsl.add('				<TYPE>PROCEDURE</TYPE>');
          tsl.add('				<DATA>EXECUTE PROCEDURE ST_MAJ_TRAIT_BECOL</DATA>');
          tsl.add('			</ORDRE>');
          tsl.add('			<ORDRE>');
          tsl.add('				<NOM>CCSVS</NOM>');
          tsl.add('				<TYPE>PROCEDURE</TYPE>');
          tsl.add('				<DATA>EXECUTE PROCEDURE CCSVS_PARAMDEFAUTSP2K</DATA>');
          tsl.add('			</ORDRE>');
          tsl.add('		</ORDRES>');
          tsl.add('	</CENTRALE>');
          tsl.add('</CENTRALES>');
          tsl.SaveToFile(IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) + 'easy.xml');
        except
          on e:exception do
            LogDebug(FichierLog,'Exception:' + e.Message);
        end;
      finally
         tsl.Free;
      end;
    END;
    try
      result.LoadFromFile(IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) + 'easy.xml');
    except
      on e:exception do
      begin
        LogDebug(FichierLog,'Xml_DocOrdre.LoadFromFile - Exception:'+e.ClassName + '/' + e.Message);
        exit;
      end;
    end;
end;

PROCEDURE TForm1.Traitement_Databases_EASY_PAR_MAINTENANCE(aDossID:integer = 0);
VAR s: STRING;
    vLecteurLame: String;
    LaCentrale: STRING;
    LaMachine: STRING;
    NomClient: STRING;
    Tc: Tconnexion;
    tpJeton : TTokenParams;
    bJeton  : Boolean;         //Vrai si on a le jeton sinon faux
    i, vNbEssais: Integer;     //Compteur pour les jetons / Nombre d'essais
    vAllowExecJob: Boolean;
    FichierIB:TFileName;
    vEASY : boolean;
    j:Integer;
    vName :string;
    iPosition : integer;
    Xml_DocOrdre :  TXMLDocument;
    vDossiers :  TDossiers;

BEGIN
    FichierLog  := 'GUID_Easy.log';
    FichierIB := '';

    //aDossID := 347;

    // Lecture complete de la base Maintenance avec le FLAG "EASY"
    vDossiers := LoadBaseMaintenance_Easy(aDossID);

    for j := 0 to vDossiers.Count-1 do
     begin
         FichierIB:= TDossier(vDossiers.Items[j]).Base;
         IF (FichierIB<>'') THEN
            BEGIN
              Screen.Cursor:= crHourGlass;
              Go.Enabled:=False;
              BtnVersion.Enabled:=False;
              BtnBase.Enabled:=False;
              try
                s := uppercase(FichierIB);
                caption := s;

                LogDebug(FichierLog,'Traitement de la base => '+ s);
        //        IF copy(s, 1, 2) = '\\' THEN //--> Deprecated
        //        BEGIN
                    Tc := Tconnexion.create;
                    try
                      TRY
                        vAllowExecJob:= True;

                        data.DatabaseName := s;
                        LogDebug(FichierLog,'Ouverture de data : ' + data.DatabaseName);

                        if FDebug then
                          Exit;

                        LogDebug('DataBaseName = '+FichierLog, s);
                        Lab_Base.caption := ('Traitement : ' + s);
                        data.open;

                        vEasy := IsReplicationEASY;
                        if Not(vEASY)
                          then
                              begin
                                  MessageDlg('Ce n''est pas une base EASY',  mtError,
                                    [mbOK], 0);
                                  exit;
                              end;

                        //--------------------------------------------------------------
                        // Avec EASY les chemins ne sont pas forcement comme cela maintenant !!
                        // EASY  => D:\BASES\CENTRALE\CLIENT\GINKOIA.IB

                        // LaMachine := GetComputerNameLocal();
                        iPosition := Pos(':',FichierIB);
                        if iPosition>2
                          then LaMachine := Copy(FichierIB,1,iPosition-1)
                          else LaMachine := GetComputerNameLocal();

                        LogDebug(FichierLog,'LaMachine = '+ LaMachine);
                        // -----------------------------------------------------

                        s := uppercase(FichierIB);
                        NomClient   := ExtractFileName(ExtractFileDir(s));                   // Récup du nom du client
                        LogDebug(FichierLog,'NomClient = '+ NomClient);
                        LaCentrale  := ExtractFileName(ExtractFileDir(ExtractFileDir(s)));   // Récup du nom du client
                        LogDebug(FichierLog,'NomCentrale = '+ LaCentrale);

                        QryGENVERSION.Open;

                        if vAllowExecJob then
                          begin
                            if ChkBxBaseMaintenance.Checked then
                              begin
                                DB_MAINTENANCE.Open;
                                IBTransMaintenance.Active:= True;
                              end;

                            // On vérifie que les GUID existe
                            CreationGUID(NomClient, LaCentrale);
                            // recherche sur yellis du GUID de chaque base
                            majMagCode;
                            AffecteYellis(TC, NomClient, LaMachine, LaCentrale);

                            Xml_DocOrdre := LoadEasyPostProcedures();

                            Process(Xml_DocOrdre, LaCentrale );

                            traitement_rtf;

                            majFTPArchivage;
                            ExitCode:=0;
                          end
                        else
                          begin
                            LogDebug(FichierLog,'Impossible de prendre un Jeton.');
                            memo1.lines.add('Impossible de prendre un Jeton.');
                            ExitCode:=1;
                          end;

                      EXCEPT on E:exception do
                        begin
                          LogDebug(FichierLog,'prob sur la base : '+E.Message);
                          memo1.lines.add('prob sur la base : '+E.Message);
                          ExitCode:=2;
                        end;
                      END;
                    finally
                      tc.free;
                      data.Close;
                      if ChkBxBaseMaintenance.Checked then
                        DB_MAINTENANCE.Close;
                      if bJeton then
                        StopTokenEnBoucle;      //Relache le jeton
                    end;
        //        END;
              finally
                Lab_Base.caption := '';
                Memo1.Lines.Append(cEndLine);
                Screen.Cursor:= crDefault;
                Go.Enabled:=True;
                BtnVersion.Enabled:=True;
                BtnBase.Enabled:=True;
              end;
            END;
            Application.ProcessMessages;
      end;
  if not FEasyManuel then
  begin
    if not(FEasyAuto) then
      if application.MessageBox('Voulez-vous fermer le GUID.', 'Fermer GUID', MB_YESNO) = IDYES then
         Application.Terminate;
    if FEasyAuto then Application.Terminate;
  end;
end;

{ // NE PLUS UTLISER ON PASSE PAR MAINTENANCE desormais
PROCEDURE TForm1.Traitement_Databases_EASY;
VAR    s: STRING;
    vLecteurLame: String;
    LaCentrale: STRING;
    LaMachine: STRING;
    NomClient: STRING;
    Tc: Tconnexion;
    tpJeton : TTokenParams;
    bJeton  : Boolean;        //Vrai si on a le jeton sinon faux
    i, vNbEssais: Integer;     //Compteur pour les jetons / Nombre d'essais
    vAllowExecJob: Boolean;
    FichierIB:TFileName;
    vEASY : boolean;
    vList: TStringList;
    vIniFile : TIniFile;
    j:Integer;
    vName :string;
    iPosition : integer;
    Xml_DocOrdre :  TXMLDocument;


BEGIN
    FichierLog  := 'GUID_UneBase.log';
    FichierIB := '';

    /// Il faudrait traiter toutes les bases "EASY"
    ///
    ///
  vIniFile := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  try
    vList:= TStringList.Create;
    try
      vIniFile.ReadSection('EASY',vList);
      for j := 0 to vList.Count-1 do
      begin
           vName := vList[j]; //The Name
           FichierIB:= vIniFile.ReadString('EASY', vName, ''); //The Value
           IF (FichierIB<>'') THEN
            BEGIN
              Screen.Cursor:= crHourGlass;
              Go.Enabled:=False;
              BtnVersion.Enabled:=False;
              BtnBase.Enabled:=False;
              try
                s := uppercase(FichierIB);
                caption := s;

        //--> Deprecated
        //        if (LeftStr(s,1) = FLecteurLame) then
        //        begin
        //          s := '\\SYMREPLIC1\' + rightStr(s,length(s)-3);
        //        end;
        //--> Deprecated

                LogDebug(FichierLog,'Traitement de la base => '+ s);
        //        IF copy(s, 1, 2) = '\\' THEN //--> Deprecated
        //        BEGIN
                    Tc := Tconnexion.create;
                    try
                      TRY
                        vAllowExecJob:= True;

                        data.DatabaseName := s;
                        LogDebug(FichierLog,'Ouverture de data : ' + data.DatabaseName);

                        if FDebug then
                          Exit;

                        LogDebug('DataBaseName = '+FichierLog, s);
                        Lab_Base.caption := ('Traitement : ' + s);
                        data.open;

                        vEasy := IsReplicationEASY;
                        if Not(vEASY)
                          then
                              begin
                                  MessageDlg('Ce n''est pas une base EASY',  mtError,
                                    [mbOK], 0);
                                  exit;
                              end;

                        //--------------------------------------------------------------
                        // Avec EASY les chemins ne sont pas forcement comme cela maintenant !!
                        // EASY  => D:\BASES\CENTRALE\CLIENT\GINKOIA.IB

                        // LaMachine := GetComputerNameLocal();
                        iPosition := Pos(':',FichierIB);
                        if iPosition>2
                          then LaMachine := Copy(FichierIB,1,iPosition-1)
                          else LaMachine := GetComputerNameLocal();

                        LogDebug(FichierLog,'LaMachine = '+ LaMachine);
                        // -----------------------------------------------------

                        s := uppercase(FichierIB);
                        NomClient   := ExtractFileName(ExtractFileDir(s));                   // Récup du nom du client
                        LogDebug(FichierLog,'NomClient = '+ NomClient);
                        LaCentrale  := ExtractFileName(ExtractFileDir(ExtractFileDir(s)));   // Récup du nom du client
                        LogDebug(FichierLog,'NomCentrale = '+ LaCentrale);

                        QryGENVERSION.Open;

                        if vAllowExecJob then
                          begin
                            if ChkBxBaseMaintenance.Checked then
                              begin
                                DB_MAINTENANCE.Open;
                                IBTransMaintenance.Active:= True;
                              end;

                            // On vérifie que les GUID existe
                            CreationGUID(NomClient, LaCentrale);
                            // recherche sur yellis du GUID de chaque base
                            AffecteYellis(TC, NomClient, LaMachine, LaCentrale);

                            Xml_DocOrdre := LoadEasyPostProcedures();

                            Process(Xml_DocOrdre, LaCentrale );

                            traitement_rtf;
                            majMagCode;
                            ExitCode:=0;
                          end
                        else
                          begin
                            LogDebug(FichierLog,'Impossible de prendre un Jeton.');
                            memo1.lines.add('Impossible de prendre un Jeton.');
                            ExitCode:=1;
                          end;

                      EXCEPT on E:exception do
                        begin
                          LogDebug(FichierLog,'prob sur la base : '+E.Message);
                          memo1.lines.add('prob sur la base : '+E.Message);
                          ExitCode:=2;
                        end;
                      END;
                    finally
                      tc.free;
                      data.Close;
                      if ChkBxBaseMaintenance.Checked then
                        DB_MAINTENANCE.Close;
                      if bJeton then
                        StopTokenEnBoucle;      //Relache le jeton
                    end;
        //        END;
              finally
                Lab_Base.caption := '';
                Memo1.Lines.Append(cEndLine);
                Screen.Cursor:= crDefault;
                Go.Enabled:=True;
                BtnVersion.Enabled:=True;
                BtnBase.Enabled:=True;
              end;
            END;
      end;
   finally
      vList.Free;
    end;
  finally
    vIniFile.Free;
  end;
  if not(FAuto) then
    if application.MessageBox('Voulez-vous fermer le GUID.', 'Fermer GUID', MB_YESNO) = IDYES then
       Application.Terminate;
  if FAuto then Application.Terminate;
END;
}


PROCEDURE TForm1.BtnVersionClick(Sender: TObject);
begin
  OdDatabases.DefaultExt := '';
  OdDatabases.InitialDir := '';
  OdDatabases.Filter := 'Databases|DelosQPMAgent.Databases.xml|tous|*.*';
  Traitement_Version;
end;


procedure TForm1.Traitement_Version;
VAR s: STRING;
    Machine: STRING;
    FichierXML:TFileName;

BEGIN
    FichierLog  := 'GUID_UneVersion.log';
    FichierXML := '';
    if (FAutoVersion='') then
      begin
          IF OdDatabases.execute THEN
          BEGIN
            FichierXML:=OdDatabases.FileName
          END;
      end
      else
      begin
         FichierXML:=FAutoVersion;
      end;
    //--------------------------------------------------------------------------
    if (FichierXML<>'') then
      begin
        Screen.Cursor:= crHourGlass;
        Go.Enabled:=False;
        BtnVersion.Enabled:=False;
        BtnBase.Enabled:=False;
        try
          S := FichierXML;
          IF pos('//', s) = 1 THEN
          BEGIN
              delete(S, 1, 2);
              Machine := Copy(S, 1, pos('/', s) - 1);
              ExecJob(Machine, FichierXML);
          END
          ELSE
              ExecJob(Machine, FichierXML);
        finally
          Memo1.Lines.Append(cEndLine);
          Screen.Cursor:= crDefault;
          Go.Enabled:=True;
          BtnVersion.Enabled:=True;
          BtnBase.Enabled:=True;
          if not(FAuto) then
            if application.MessageBox('Voulez-vous fermer le GUID.', 'Fermer GUID', MB_YESNO) = IDYES then
              Application.Terminate;
          if FAuto then Application.Terminate;
        end;
      END;
END;

procedure TForm1.Btn_1Click(Sender: TObject);
begin
  if IsJetonVersion(Edit1.Text) then
    ShowMessage('Jeton')
  else
    ShowMessage('Pas Jeton');
end;

procedure TForm1.Btn_SyncBaseByApiMaintenanceClick(Sender: TObject);
var
  Buffer: String;
begin
  Buffer:= InputBox('SyncBase Api Maintenance', 'DOSS_ID', '');

  if (Trim(Buffer) <> '') and (IsInteger(Buffer)) then
    begin
      Screen.Cursor:= crHourGlass;
      try
        MessageDlg(SyncBaseByDllMaintenance(StrToInt(Buffer)), mtInformation, [mbOk], 0);
      finally
        Screen.Cursor:= crDefault;
      end;      
    end
  else
    MessageDlg('DOSS_ID incorect !', mtError, [mbOk], 0);
end;

procedure TForm1.Btn_SyncBaseClick(Sender: TObject);
var
  Buffer: String;
begin
  Buffer:= InputBox('SyncBase', 'DATABASENAME', FLastDataBaseSync);

  if Trim(Buffer) <> '' then
    begin
      FLastDataBaseSync:= Buffer;
      data.DatabaseName:= Buffer;
      data.Connected:= True;
      MessageDlg(Buffer + ' : Connectée', mtInformation, [mbOk], 0);
    end
  else
    begin
      MessageDlg('DATABASENAME incorect !', mtError, [mbOk], 0);
      Exit;
    end;

  Buffer:= InputBox('SyncBase', 'DOSS_ID', '');

  if (Trim(Buffer) <> '') and (IsInteger(Buffer)) then
    begin
      Screen.Cursor:= crHourGlass;
      FichierLog  := 'GUID_SyncBase.log';
      try
        if not DB_MAINTENANCE.Connected then
          begin
            DB_MAINTENANCE.DatabaseName:= FDatabaseNameMaintenance;
            DB_MAINTENANCE.Connected:= True;
          end;

        MessageDlg(SyncBase(StrToInt(Buffer)), mtInformation, [mbOk], 0);
      finally
        Screen.Cursor:= crDefault;
        data.Connected:= False;
        data.DatabaseName:= '';
      end;
    end
  else
    MessageDlg('DOSS_ID incorect !', mtError, [mbOk], 0);
end;

procedure TForm1.Btn_AutoClick(Sender: TObject);
begin
  Traitement_Auto;
end;

procedure TForm1.Btn_Click(Sender: TObject);
var
  FExecuteScript : TFrm_ExecuteScript;
begin
  FExecuteScript := TFrm_ExecuteScript.Create(self);
  try
    FExecuteScript.ShowModal;
  finally
    FExecuteScript.Free;
  end;
end;

procedure TForm1.Btn_CreateListeClick(Sender: TObject);
var
  aDossiers : TDossiers;
  aDossier : TDossier;
  Dossiers: IXMLDossiersType;
  Dossier: IXMLDossierType;
  i : integer;
  ListItem : TListItem;
begin
  aDossiers := ExecuteChercheDossiers;
  try
    if assigned(aDossiers) then
    begin
      Dossiers := NewDossiers;
      for I := 0 to aDossiers.Count - 1 do
      begin
        Dossier := Dossiers.Add;
        Dossier.Name := TDossier(aDossiers[i]).Nom;
        Dossier.Centrale := TDossier(aDossiers[i]).NomCentrale;
        Dossier.Version := TDossier(aDossiers[i]).Version;
        Dossier.Serveur := TDossier(aDossiers[i]).Serveur;
        Dossier.Base := TDossier(aDossiers[i]).Base;
      end;
      if SD_XML.Execute then
        Dossiers.OwnerDocument.SaveToFile(SD_XML.FileName);
    end
    else
      Showmessage('Erreur : Dossiers vide !');
  finally
    aDossiers.Free;
  end;
end;

procedure TForm1.Btn_ListeClick(Sender: TObject);
var
  Dossiers: IXMLDossiersType;
  vDossier : TDossier;
  i,y : integer;
  ListItem : TListItem;
  sFichier : String;
begin
  slError.Clear;
  FichierLog  := 'GUID_UneListe.log';
  //ExecuteChercheDossiers
  OdDatabases.DefaultExt := 'xml';
  OdDatabases.Filter := '|*.xml|';
  OdDatabases.InitialDir := ExtractFilePath(application.ExeName);
  if OdDatabases.execute then
    sFichier := OdDatabases.FileName;

  if sFichier <> '' then
  begin
    try
      Dossiers := LoadDossiers(sFichier);
      pb.Min := 0;
      pb.Max := Dossiers.Count;
      pb.Step := 1;
      vDossier := TDossier.Create;
      try
        for I := 0 to Dossiers.Count - 1 do
        begin
          vDossier.Nom := Dossiers.Dossier[i].Name;
          vDossier.NomCentrale := Dossiers.Dossier[i].Centrale;
          vDossier.Version := Dossiers.Dossier[i].Version;
          vDossier.Serveur := Dossiers.Dossier[i].Serveur;
          vDossier.Base := Dossiers.Dossier[i].Base;
          ExecJobListe(vDossier);
          pb.StepIt;
          Application.ProcessMessages;
        end;
      finally
        vDossier.Free;
      end;
    except
      on e:exception do
        LogDebug(FichierLog,'Liste.Exception:' + e.Message);
    end;
    if (slError.Count > 0) then
    begin
      LogDebug(FichierLog, '********** Récap des Erreurs **********');
      for y := 0 to slError.Count -1 do
        LogDebug(FichierLog, slError[y]);
      LogDebug(FichierLog, '***************************************');
      application.MessageBox('Traitement effectué avec des erreurs', '', mb_ok);
    end
    else
       application.MessageBox('Traitement effectué', '', mb_ok);
  end;
end;

PROCEDURE TForm1.TraiteXML(_Nom, _tipe, _data: STRING);
VAR
  S: STRING;
  Error: String;
  ExitCode, ExitCode_ShellEx: Cardinal;
BEGIN
  try
    case AnsiIndexText( _tipe, [
      {0}'create_and_drop_procedure',
      {1}'procedure',
      {2}'query',
      {3}'commandline'
    ] ) of
      0: {$REGION 'create_and_drop_procedure'}begin
        try
          if not tran2.InTransaction then
            tran2.StartTransaction;
          SQL.SQL.Text := _data;
          SQL.ExecQuery;
          if tran2.InTransaction then
          begin
            tran2.Commit;
            tran2.StartTransaction;
          end;
          SQL.SQL.Text := 'EXECUTE PROCEDURE ' + _Nom;
          SQL.ExecQuery;
          if tran2.InTransaction then
          begin
            tran2.Commit;
            tran2.StartTransaction;
          end;
          SQL.SQL.Text := 'DROP PROCEDURE ' + _Nom;
          SQL.ExecQuery;
          if tran2.InTransaction then
            tran2.Commit;
        except
          on E: Exception do
            raise Exception.CreateFmt( 'prob sur CREATE_AND_DROP_PROCEDURE "%s" : %s', [ _Nom, E.Message ] );
        end;
      end;{$ENDREGION}
      1: {$REGION 'procedure'}begin
        try
          if not tran2.InTransaction then
            tran2.StartTransaction;
          SQL.SQL.Text := _data;
          SQL.ExecQuery;  
          if tran2.InTransaction then
            tran2.Commit;
        except
          //on E: Exception do MsgDialog(E.Message, E.HelpContext);
          on E: Exception do
            raise Exception.CreateFmt( 'prob sur PROCEDURE "%s" : %s', [ _data, E.Message ] );
        end;
      end;{$ENDREGION}
      2: {$REGION 'query'}begin
        while _data <> '' do
        begin
          if Pos( ';', _data ) > 0 then
          begin
            s := Copy( _data, 1, Pos( ';', _data ) - 1 );
            Delete( _data, 1, Pos( ';', _data ) );
          end
          else begin
            s := _data;
            _data := '';
          end;
          if Trim( s ) <> '' then
          begin
            try
              if not tran2.InTransaction then
                tran2.StartTransaction;
              SQL.SQL.Text := s;
              SQL.ExecQuery;
              if tran2.InTransaction then
                tran2.Commit;
            except
              on E: Exception do begin
                Break;
                raise Exception.CreateFmt( 'prob sur la QUERY "%s" : %s', [ _data, E.Message ] );
              end;
            end;
          end;
        end;
      end;{$ENDREGION}
      3: {$REGION 'commandline'}begin
        if LaunchProcess.ExecAndWaitProcess( Error, _nom, _data ) <> ERROR_SUCCESS then
          raise Exception.CreateFmt( 'prob sur COMMANDLINE "%s" "%s" : %s', [ _nom, _data, Error ] );
      end;{$ENDREGION}
      else {$REGION 'unkwnown'}begin
        { TODO -cXML : Gérer un nouveau noeud XML...(create_and_drop_procedure|procedure|query|commandline|...)}
      end;{$ENDREGION}
    end;
  except
    on E: Exception do begin
      LogDebug(FichierLog, 'TraiteXML - Exception' + E.ClassName +'/' + e.Message );
      if tran2.InTransaction then
        tran2.Rollback;
    end;
  end;
END;

function TForm1.SyncBase(const ADOSS_ID: integer):string;
Const
  cMessLogMAJValue = '%s : Mise à jour de "%s"';
  cMessLogNEWValue = '%s : Ajout de "%s"';
var
  iMAGID : Integer;
  iMODUID : Integer;
  vMAG_ID, vPOS_ID, vMAGAID: integer;
  sVerVersion : string;
  vField : TField;
  vDT: Variant;
begin
  Result := '';
  try
    try
      sVerVersion := '';
      QrySelectGinkoia.Close;
      QrySelectGinkoia.SQL.Text:= cSql_S_genversion;
      QrySelectGinkoia.Open;
      if not QrySelectGinkoia.Eof then
        sVerVersion := QrySelectGinkoia.FieldByName('VER_VERSION').AsString;
      QrySelectGinkoia.Close;

      //SR 13/03/2014 : Partie Synchro Magasin Ginkoia -> Maintenance
      caption := ' Synchronisation Maintenance : Synchro Magasin Ginkoia -> Maintenance';
      LogDebug(FichierLog, 'Synchronisation Maintenance : Synchro Magasin Ginkoia -> Maintenance');

      if not QryGenMaintenance.Transaction.InTransaction then
        QryGenMaintenance.Transaction.StartTransaction;

      QrySelectGinkoia.SQL.Text := 'Select * From GENMAGASIN Join K on (K_ID = MAG_ID) Where MAG_ID <> 0';
      QrySelectGinkoia.Open;
      QrySelectGinkoia.First;

      QrySelectMaintenance.SQL.Text:= cSql_S_SyncBase_Magasins;

      while not QrySelectGinkoia.Eof do
      begin
        vMAG_ID:= QrySelectGinkoia.FieldByName('MAG_ID').AsInteger;

        QrySelectMaintenance.Close;
        QrySelectMaintenance.ParamByName('PMAGAMAGIDGINKOIA').AsInteger:= vMAG_ID;
        QrySelectMaintenance.ParamByName('PMAGADOSSID').AsInteger:= ADOSS_ID;
        QrySelectMaintenance.Open;

        QryGenMaintenance.Close;

        if not QrySelectMaintenance.Eof then
        begin
          //Update
          QryGenMaintenance.SQL.Text:= cSql_U_magasins;
          QryGenMaintenance.ParamByName('PMAGAID').AsInteger:= QrySelectMaintenance.FieldByName('MAGA_ID').AsInteger;
        end
        else
        begin
          //Insert
          QryGenMaintenance.SQL.Text:= cSql_I_magasins;
          QryGenMaintenance.ParamByName('PMAGAID').AsInteger:= GetNewID('MAGASINS');
        end;

        QryGenMaintenance.ParamByName('PMAGANOM').AsString:= QrySelectGinkoia.FieldByName('MAG_NOM').AsString;
        QryGenMaintenance.ParamByName('PMAGAENSEIGNE').AsString:= QrySelectGinkoia.FieldByName('MAG_ENSEIGNE').AsString;
        QryGenMaintenance.ParamByName('PMAGACODEADH').AsString:= QrySelectGinkoia.FieldByName('MAG_CODEADH').AsString;

        vField := QrySelectGinkoia.FindField('MAG_CODE');
        if vField <> nil then
        begin
          LogDebug(FichierLog, format('Mag "%s" : Mise à jour de "%s" avec "%s"', [QrySelectGinkoia.FieldByName('MAG_NOM').AsString, 'MAG_CODE', vField.AsString]));
          QryGenMaintenance.ParamByName('PMAGAMAGCODE').AsString:= vField.AsString;
        end
        else
        begin
          LogDebug(FichierLog, format('Mag "%s" : Le champs MAG_CODE n''existe pas', [QrySelectGinkoia.FieldByName('MAG_NOM').AsString]));
          QryGenMaintenance.ParamByName('PMAGAMAGCODE').AsString:='';
        end;

        vField := QrySelectGinkoia.FindField('MAG_CODETIERS');
        if vField <> nil then
        begin
          LogDebug(FichierLog, format('Mag "%s" : Mise à jour de "%s" avec "%s"', [QrySelectGinkoia.FieldByName('MAG_NOM').AsString, 'MAG_CODETIERS', vField.AsString]));
          QryGenMaintenance.ParamByName('PMAGATIERS').AsString:= vField.AsString;
        end
        else
        begin
          LogDebug(FichierLog, format('Mag "%s" : Le champs MAG_CODETIERS n''existe pas', [QrySelectGinkoia.FieldByName('MAG_NOM').AsString]));
          QryGenMaintenance.ParamByName('PMAGATIERS').AsString:='';
        end;

        QryGenMaintenance.ParamByName('PMAGAMAGIDGINKOIA').AsInteger:= vMAG_ID;
        QryGenMaintenance.ParamByName('PMAGADOSSID').AsInteger:= ADOSS_ID;
        QryGenMaintenance.ParamByName('PMAGAKENABLED').AsInteger:= QrySelectGinkoia.FieldByName('K_ENABLED').AsInteger;

        // Récupération des valeurs CASH depuis la table GENPARAM
        QryGenMaintenance.ParamByName('PMAGA_CASH_PARAMACHIEVE').AsInteger := GetGenParam(666, 6, fwMAGID, vMAG_ID, frPRM_INTEGER);

        vDT:= GetGenParam(666, 1, fwMAGID, vMAG_ID, frPRM_FLOAT);
        if vDT = 0 then
          QryGenMaintenance.ParamByName('PMAGA_CASH_DATEBASCULE').AsDateTime := 0
        else
          QryGenMaintenance.ParamByName('PMAGA_CASH_DATEBASCULE').AsDateTime := UnixToDateTime(vDT);

        QryGenMaintenance.ExecSQL;

        QrySelectGinkoia.Next;
      end;

      QryGenMaintenance.Transaction.Commit;
      QrySelectGinkoia.Close;
      QryGenMaintenance.Close;
      QrySelectMaintenance.Close;

      //SR 13/03/2014 : Partie Synchro Magasin Maintenance -> Ginkoia (On supprime les magasins présent dans Maintenance et inéxistant dans Ginkoia)
      caption := ' Synchronisation Maintenance : Synchro Magasin Maintenance -> Ginkoia';
      LogDebug(FichierLog, 'Synchronisation Maintenance : Synchro Magasin Maintenance -> Ginkoia');

      if not QryGenMaintenance.Transaction.InTransaction then
        QryGenMaintenance.Transaction.StartTransaction;

      QrySelectMaintenance.SQL.Text := 'SELECT MAGA_ID, MAGA_MAGID_GINKOIA FROM MAGASINS WHERE MAGA_DOSSID = :PDOSSID';
      QrySelectMaintenance.ParamByName('PDOSSID').AsInteger:= ADOSS_ID;
      QrySelectMaintenance.Open;
      QrySelectMaintenance.First;

      QrySelectGinkoia.SQL.Text := 'Select MAG_ID From GENMAGASIN Join K on (K_ID = MAG_ID) Where MAG_ID = :PMAGID';
      QryGenMaintenance.SQL.Text:= 'Delete From Magasins Where MAGA_ID = :PMAGAID';

      while not QrySelectMaintenance.Eof do
      begin
        QrySelectGinkoia.Close;
        QrySelectGinkoia.ParamByName('PMAGID').AsInteger:= QrySelectMaintenance.FieldByName('MAGA_MAGID_GINKOIA').AsInteger;
        QrySelectGinkoia.Open;
        QrySelectGinkoia.First;

        if QrySelectGinkoia.Eof then  //Si non présent dans Ginkoia, on supprime la ligne
        begin
          QryGenMaintenance.Close;
          QryGenMaintenance.ParamByName('PMAGAID').AsInteger:= QrySelectMaintenance.FieldByName('MAGA_ID').AsInteger;
          QryGenMaintenance.ExecSQL;
        end;
        QrySelectMaintenance.Next;
      end;
      QryGenMaintenance.Transaction.Commit;
      QrySelectMaintenance.Close;
      QryGenMaintenance.Close;
      QrySelectGinkoia.Close;


      {$REGION '------------------- POSTE ----------------------'}

      // 16/03/2021 Greg - Faute de temps, il a été décidé de faire un Copier/Coller du code de Maintenance concernant la synchro des postes.

      caption := ' Synchronisation Maintenance : Synchro Poste Ginkoia -> Maintenance';
      LogDebug(FichierLog, 'Synchronisation Maintenance : Synchro Poste Ginkoia -> Maintenance');

      try
        QrySelectMaintenance.SQL.Text := cSql_S_SyncBase_MagasinsPoste;


        QrySelectGinkoia.SQL.Text:= 'SELECT GENPOSTE.* FROM GENPOSTE' + cRc +
                                    'JOIN K ON (K_ID = POS_ID AND K_ENABLED = 1)' + cRc +
                                    'WHERE POS_ID <> 0' + cRc +
                                    'ORDER BY POS_MAGID';

        QrySelectGinkoia.Open;
        QrySelectGinkoia.First;

        while not QrySelectGinkoia.Eof do
          begin
            vMAG_ID:= QrySelectGinkoia.FieldByName('POS_MAGID').AsInteger;
            vPOS_ID:= QrySelectGinkoia.FieldByName('POS_ID').AsInteger;

            // Liste des postes de ce magasin pour ce dossier
            QrySelectMaintenance.Close;
            QrySelectMaintenance.ParamByName('PMAGAMAGIDGINKOIA').AsInteger := vMAG_ID;
            QrySelectMaintenance.ParamByName('PMAGADOSSID').AsInteger := ADOSS_ID;
            QrySelectMaintenance.Open;

            if not QrySelectMaintenance.Eof then
              begin
                // Ce magasin existe dans Maintenance

                vMAGAID := QrySelectMaintenance.FieldByName('MAGA_ID').AsInteger;
              end
            else
              begin
                LogDebug(FichierLog, 'Synchro Poste - Ce magasin est introuvable dans Maintenance. MAG_ID = ' + IntToStr(vMAG_ID));

                QrySelectGinkoia.Next;
                Continue;
              end;

            if not QryGenMaintenance.Transaction.Active then
              QryGenMaintenance.Transaction.StartTransaction;

            QryGenMaintenance.Close;

            // On cherche si le poste existe déjà dans ce magasin
            if QrySelectMaintenance.Locate('POST_POSID', vPOS_ID, []) then
            begin
              LogDebug(FichierLog, format(cMessLogMAJValue, ['Poste', QrySelectGinkoia.FieldByName('POS_NOM').AsString]));

              // Update
              QryGenMaintenance.SQL.Text := cSql_U_SynchroGnkToPostes;

              QryGenMaintenance.ParamByName('PPOSTID').AsInteger := QrySelectMaintenance.FieldByName('POST_ID').AsInteger;
              QryGenMaintenance.ParamByName('PPOSTDATEM').AsDateTime:= Now;
            end
            else
            begin
              LogDebug(FichierLog, format(cMessLogNEWValue, ['Poste', QrySelectGinkoia.FieldByName('POS_NOM').AsString]));

              // Insert
              QryGenMaintenance.SQL.Text := cSql_I_SynchroGnkToPostes;

              QryGenMaintenance.ParamByName('PPOSTID').AsInteger := GetNewID('POSTES');
              QryGenMaintenance.ParamByName('PPOSTDATEC').AsDateTime:= Now;
              QryGenMaintenance.ParamByName('PPOSTDATEM').AsDateTime:= Now;
              QryGenMaintenance.ParamByName('PPOSTPOSID').AsInteger:= vPOS_ID;
              QryGenMaintenance.ParamByName('PPOSTMAGAID').AsInteger:= vMAGAID;
            end;

            QryGenMaintenance.ParamByName('PPOSTNOM').AsString:= QrySelectGinkoia.FieldByName('POS_NOM').AsString;
            QryGenMaintenance.ParamByName('PPOSTINFO').AsString:= QrySelectGinkoia.FieldByName('POS_INFO').AsString;
            QryGenMaintenance.ParamByName('PPOSTCOMPTA').AsString:= QrySelectGinkoia.FieldByName('POS_COMPTA').AsString;
            QryGenMaintenance.ParamByName('PPOSTPTYPID').AsInteger:= QrySelectGinkoia.FieldByName('POS_TYPE').AsInteger;
            QryGenMaintenance.ParamByName('PPOSTENABLE').AsInteger:= 1;

            // Récupération des valeurs CASH depuis la table GENPARAM
            QryGenMaintenance.ParamByName('PPOST_CASH_DOITBASCULER').AsInteger:= GetGenParam(666, 206, fwMAGID, vMAG_ID, frPRM_INTEGER);
            QryGenMaintenance.ParamByName('PPOST_CASH_CAISSEDEFAULT').AsString:= GetGenParam(666, 205, fwMAGID, vMAG_ID, frPRM_STRING);

            vDT:= GetGenParam(666, 110, fwMAGID, vMAG_ID, frPRM_FLOAT);
            if vDT = 0 then
              QryGenMaintenance.ParamByName('PPOST_CASH_DATEBASCULE').AsDateTime:= 0
            else
              QryGenMaintenance.ParamByName('PPOST_CASH_DATEBASCULE').AsDateTime:= UnixToDateTime(vDT);

            vDT:= GetGenParam(666, 104, fwMAGID, vMAG_ID, frPRM_FLOAT);
            if vDT = 0 then
              QryGenMaintenance.ParamByName('PPOST_CASH_DATEEFFECTIVEBASCULE').AsDateTime:= 0
            else
              QryGenMaintenance.ParamByName('PPOST_CASH_DATEEFFECTIVEBASCULE').AsDateTime:= UnixToDateTime(vDT);

            // 17/03/2021 Greg - A la demande de Sylvain.C, ce paramètre n'est pas à utiliser pour le moment...
            QryGenMaintenance.ParamByName('PPOST_CASH_BASCULESTATUT').AsString:= ''; //GetGenParam(666, 100, fwMAGID, vMAG_ID, frPRM_STRING);

            QryGenMaintenance.ExecSQL;

            if QryGenMaintenance.Transaction.Active then
              QryGenMaintenance.Transaction.Commit;

            QrySelectGinkoia.Next;
          end;

      except
        on E: Exception do
          begin
            if QryGenMaintenance.Transaction.Active then
              QryGenMaintenance.Transaction.Rollback;

            LogDebug(FichierLog, 'Except : Partie Synchro Poste Ginkoia -> Maintenance');
            LogDebug(FichierLog, '         ' + E.Message);
            LogDebug(FichierLog, '         ' + QryGenMaintenance.SQL.Text);
            LogDebug(FichierLog, '         MAG_ID = ' + IntToStr(vMAG_ID));
            LogDebug(FichierLog, '         POS_ID = ' + IntToStr(vPOS_ID));
          end;
      end;

      {$ENDREGION}


      //SR 13/03/2014 : Partie Synchro Emetteur Ginkoia -> Maintenance
      caption := ' Synchronisation Maintenance : Synchro Emetteur Ginkoia -> Maintenance';
      LogDebug(FichierLog, 'Synchronisation Maintenance : Synchro Emetteur Ginkoia -> Maintenance');

      if not QryGenMaintenance.Transaction.InTransaction then
        QryGenMaintenance.Transaction.StartTransaction;

      QrySelectGinkoia.SQL.Text := cSql_S_SyncBase_GenBases;
      QrySelectGinkoia.Open;
      QrySelectGinkoia.First;

      while not QrySelectGinkoia.Eof do
      begin
        QrySelectMaintenance.Close;
        QrySelectMaintenance.SQL.Text:= cSql_S_SyncBase_Magasins;
        QrySelectMaintenance.ParamByName('PMAGAMAGIDGINKOIA').AsInteger:= QrySelectGinkoia.FieldByName('BAS_MAGID').AsInteger;
        QrySelectMaintenance.ParamByName('PMAGADOSSID').AsInteger:= ADOSS_ID;
        QrySelectMaintenance.Open;

        if not QrySelectMaintenance.Eof then
          iMAGID := QrySelectMaintenance.FieldByName('MAGA_ID').AsInteger
        else
          iMAGID := 0;

        QrySelectMaintenance.Close;
        QrySelectMaintenance.SQL.Text:= cSql_S_SyncBase_Emetteur;
        QrySelectMaintenance.ParamByName('PEMETGUID').AsString:= QrySelectGinkoia.FieldByName('BAS_GUID').AsString;
        QrySelectMaintenance.ParamByName('PEMETDOSSID').AsInteger:= ADOSS_ID;
        QrySelectMaintenance.Open;

        QryGenMaintenance.Close;

        if not QrySelectMaintenance.Eof then
        begin
          //Update
          QryGenMaintenance.SQL.Text:= cSql_U_SyncBase_Emetteur;
          QryGenMaintenance.ParamByName('PEMETID').AsInteger := QrySelectMaintenance.FieldByName('EMET_ID').AsInteger;
        end
        else
        begin
          //Insert
          QryGenMaintenance.SQL.Text:= cSql_I_Emetteur;
          QryGenMaintenance.ParamByName('PEMETGUID').AsString              := QrySelectGinkoia.FieldByName('BAS_GUID').AsString;
          QryGenMaintenance.ParamByName('PEMETDONNEES').AsString           := '';
          QryGenMaintenance.ParamByName('PEMETINSTALL').AsDateTime         := StrToDateTime('01/01/1900');
          QryGenMaintenance.ParamByName('PEMETPATCH').AsInteger            := 0;
          QryGenMaintenance.ParamByName('PEMETVERSION_MAX').AsInteger      := 0;
          QryGenMaintenance.ParamByName('PEMETSPEPATCH').AsInteger         := 0;
          QryGenMaintenance.ParamByName('PEMETSPEFAIT').AsInteger          := 0;
          QryGenMaintenance.ParamByName('PEMETBCKOK').AsDateTime           := StrToDateTime('01/01/1900');
          QryGenMaintenance.ParamByName('PEMETDERNBCK').AsDateTime         := StrToDateTime('01/01/1900');
          QryGenMaintenance.ParamByName('PEMETRESBCK').AsString            := '';
          QryGenMaintenance.ParamByName('PEMETTYPEREPLICATION').Clear;
          QryGenMaintenance.ParamByName('PEMETNONREPLICATION').AsInteger   := 0;
          QryGenMaintenance.ParamByName('PEMETDEBUTNONREPLICATION').Clear;
          QryGenMaintenance.ParamByName('PEMETFINNONREPLICATION').Clear;
          QryGenMaintenance.ParamByName('PEMETSERVEURSECOURS').Clear;
          QryGenMaintenance.ParamByName('PEMETINFOSUP').Clear;
          QryGenMaintenance.ParamByName('PEMETEMAIL').Clear;
          QryGenMaintenance.ParamByName('PEMETDOSSID').AsInteger           := ADOSS_ID;
          QryGenMaintenance.ParamByName('PEMETID').AsInteger               := GetNewID('EMETTEUR');
        end;

        QrySelectMaintenance.Close;
        QrySelectMaintenance.SQL.Text:= 'SELECT VERS_ID FROM VERSION WHERE VERS_VERSION = :PVERSVERSION';
        QrySelectMaintenance.ParamByName('PVERSVERSION').AsString:= sVerVersion;
        QrySelectMaintenance.Open;
        if not (QrySelectMaintenance.Eof) then
          QryGenMaintenance.ParamByName('PEMETVERSID').AsInteger   := QrySelectMaintenance.FieldByName('VERS_ID').AsInteger
        else
          QryGenMaintenance.ParamByName('PEMETVERSID').AsInteger   := 0;
        QryGenMaintenance.ParamByName('PEMETNOM').AsString         := QrySelectGinkoia.FieldByName('BAS_NOM').AsString;
        QryGenMaintenance.ParamByName('PEMETMAGID').AsInteger      := iMAGID;
        QryGenMaintenance.ParamByName('PEMETTIERSCEGID').AsString  := QrySelectGinkoia.FieldByName('BAS_CODETIERS').AsString;
        QryGenMaintenance.ParamByName('PEMETIDENT').AsString       := QrySelectGinkoia.FieldByName('BAS_IDENT').AsString;
        QryGenMaintenance.ParamByName('PEMETJETON').AsInteger      := QrySelectGinkoia.FieldByName('BAS_JETON').AsInteger;
        QryGenMaintenance.ParamByName('PEMETPLAGE').AsString       := QrySelectGinkoia.FieldByName('BAS_PLAGE').AsString;
        QryGenMaintenance.ParamByName('PEMETHEURE1').AsDateTime    := QrySelectGinkoia.FieldByName('LAU_HEURE1').AsDateTime;
        QryGenMaintenance.ParamByName('PEMETH1').AsInteger         := QrySelectGinkoia.FieldByName('LAU_H1').AsInteger;
        QryGenMaintenance.ParamByName('PEMETHEURE2').AsDateTime    := QrySelectGinkoia.FieldByName('LAU_HEURE2').AsDateTime;
        QryGenMaintenance.ParamByName('PEMETH2').AsInteger         := QrySelectGinkoia.FieldByName('LAU_H2').AsInteger;

        QryGenMaintenance.ExecSQL;

        QrySelectGinkoia.Next;
      end;
      QryGenMaintenance.Transaction.Commit;
      QrySelectMaintenance.Close;
      QryGenMaintenance.Close;
      QrySelectGinkoia.Close;

      //SR 13/03/2014 : Partie Synchro Emetteur Maintenance -> Ginkoia (On supprime les emetteurs présent dans Maintenance et inéxistant dans Ginkoia)
      caption := ' Synchronisation Maintenance : Synchro Emetteur Maintenance -> Ginkoia';
      LogDebug(FichierLog, 'Synchronisation Maintenance : Synchro Emetteur Maintenance -> Ginkoia');
      try
        if not QryGenMaintenance.Transaction.InTransaction then
          QryGenMaintenance.Transaction.StartTransaction;

        QrySelectMaintenance.SQL.Text := 'SELECT EMET_ID, EMET_GUID FROM EMETTEUR WHERE EMET_DOSSID = :PEMETDOSSID';
        QrySelectMaintenance.ParamByName('PEMETDOSSID').AsInteger:= ADOSS_ID;
        QrySelectMaintenance.Open;
        QrySelectMaintenance.First;

        QrySelectGinkoia.SQL.Text := 'Select BAS_ID From GENBASES Join K on (K_ID = BAS_ID and K_ENABLED = 1) Where BAS_GUID = :PBASGUID';
        QryGenMaintenance.SQL.Text:= 'Delete From EMETTEUR Where EMET_ID = :PEMETID';

        while not QrySelectMaintenance.Eof do
        begin
          QrySelectGinkoia.Close;
          QrySelectGinkoia.ParamByName('PBASGUID').AsString:= QrySelectMaintenance.FieldByName('EMET_GUID').AsString;
          QrySelectGinkoia.Open;
          QrySelectGinkoia.First;

          if QrySelectGinkoia.Eof then  //Si non présent dans Ginkoia, on supprime la ligne
          begin
            QryGenMaintenance.Close;
            QryGenMaintenance.SQL.Text:= cSql_D_SyncBase_SPLITTAGE_LOG;
            QryGenMaintenance.ParamByName('PEMETID').AsInteger:= QrySelectMaintenance.FieldByName('EMET_ID').AsInteger;
            QryGenMaintenance.ExecSQL;
            QryGenMaintenance.Close;
            QryGenMaintenance.SQL.Text:= cSql_D_SyncBase_EMETTEUR;
            QryGenMaintenance.ParamByName('PEMETID').AsInteger:= QrySelectMaintenance.FieldByName('EMET_ID').AsInteger;
            QryGenMaintenance.ExecSQL;
          end;
          QrySelectMaintenance.Next;
        end;

        QryGenMaintenance.Transaction.Commit;
        QrySelectMaintenance.Close;
        QryGenMaintenance.Close;
        QrySelectGinkoia.Close;
      except
        on E: Exception do
        begin
          LogDebug(FichierLog, 'Except : Partie Synchro Emetteur Maintenance -> Ginkoia');
          LogDebug(FichierLog, '         ' + E.Message);
          LogDebug(FichierLog, '         ' + QryGenMaintenance.SQL.Text);
          LogDebug(FichierLog, '         PEMETID = ' + IntToStr(QryGenMaintenance.ParamByName('PEMETID').AsInteger));
          QryGenMaintenance.Transaction.Rollback;
        end;
      end;

      //SR 11/04/2014 : Partie Synchro UILGRPGINKOIA Ginkoia -> Maintenance MODULES
      caption := ' Synchronisation Maintenance : Synchro UILGRPGINKOIA Ginkoia -> Maintenance MODULES';
      LogDebug(FichierLog, 'Synchronisation Maintenance : Synchro UILGRPGINKOIA Ginkoia -> Maintenance MODULES');
      try
        if not QryGenMaintenance.Transaction.InTransaction then
          QryGenMaintenance.Transaction.StartTransaction;

        QrySelectGinkoia.SQL.Clear;
        QrySelectGinkoia.SQL.Append('Select');
        QrySelectGinkoia.SQL.Append(' UGG_ID,');
        QrySelectGinkoia.SQL.Append(' UGG_NOM,');
        QrySelectGinkoia.SQL.Append('	UGG_COMMENT,');
        QrySelectGinkoia.SQL.Append('	K_ENABLED');
        QrySelectGinkoia.SQL.Append('From UILGRPGINKOIA');
        QrySelectGinkoia.SQL.Append('Join K on (K_ID = UGG_ID)');
        QrySelectGinkoia.SQL.Append('Where UGG_ID <> 0');
        QrySelectGinkoia.Open;
        QrySelectGinkoia.First;

        QrySelectMaintenance.SQL.Text:= cSql_S_SyncBase_Modules;

        while not QrySelectGinkoia.Eof do
        begin
          QrySelectMaintenance.Close;
          QrySelectMaintenance.ParamByName('PMODUNOM').AsString:= QrySelectGinkoia.FieldByName('UGG_NOM').AsString;
          QrySelectMaintenance.Open;

          QryGenMaintenance.Close;

          if QrySelectMaintenance.Eof then
          begin
            //Insert car non présent
            QryGenMaintenance.SQL.Text:= cSql_I_SyncBase_Modules;
            QryGenMaintenance.ParamByName('PMODUID').AsInteger:= GetNewID('MODULES');
            QryGenMaintenance.ParamByName('PMODUNOM').AsString:= QrySelectGinkoia.FieldByName('UGG_NOM').AsString;
          end
          else
          begin
            //Update
            QryGenMaintenance.SQL.Text:= cSql_U_SyncBase_Modules;
            QryGenMaintenance.ParamByName('PMODUID').AsInteger:= QrySelectMaintenance.FieldByName('MODU_ID').AsInteger;
          end;

          QryGenMaintenance.ParamByName('PMODUCOMMENT').AsString:= QrySelectGinkoia.FieldByName('UGG_COMMENT').AsString;
          QryGenMaintenance.ParamByName('PMODUKENABLED').AsString:= QrySelectGinkoia.FieldByName('K_ENABLED').AsString;
          QryGenMaintenance.ExecSQL;

          QrySelectGinkoia.Next;
        end;
        QryGenMaintenance.Transaction.Commit;
        QrySelectMaintenance.Close;
        QryGenMaintenance.Close;
        QrySelectGinkoia.Close;
      except
        on E: Exception do
        begin
          LogDebug(FichierLog, 'Except : Partie Synchro UILGRPGINKOIA Ginkoia -> Maintenance MODULES');
          LogDebug(FichierLog, '         ' + E.Message);
          LogDebug(FichierLog, '         ' + QryGenMaintenance.SQL.Text);
          LogDebug(FichierLog, '         PMODUID = ' + IntToStr(QryGenMaintenance.ParamByName('PMODUID').AsInteger));
          LogDebug(FichierLog, '         PMODUNOM = ' + QryGenMaintenance.ParamByName('PMODUNOM').AsString);
          LogDebug(FichierLog, '         PMODUCOMMENT = ' + QryGenMaintenance.ParamByName('PMODUCOMMENT').AsString);
          QryGenMaintenance.Transaction.Rollback;
        end;
      end;

      //SR 17/04/2014 : Partie Synchro UILGRPGINKOIAMAG Ginkoia -> Maintenance MODULES_MAGASINS
      caption := ' Synchronisation Maintenance : Synchro UILGRPGINKOIAMAG Ginkoia -> Maintenance MODULES_MAGASINS';
      LogDebug(FichierLog, 'Synchronisation Maintenance : Synchro UILGRPGINKOIAMAG Ginkoia -> Maintenance MODULES_MAGASINS');
      try
        if not QryGenMaintenance.Transaction.InTransaction then
          QryGenMaintenance.Transaction.StartTransaction;

        QrySelectGinkoia.SQL.Clear;
        QrySelectGinkoia.SQL.Append('Select');
        QrySelectGinkoia.SQL.Append('	UGM_ID,');
        QrySelectGinkoia.SQL.Append('	UGM_MAGID,');
        QrySelectGinkoia.SQL.Append('	UGM_UGGID,');
        QrySelectGinkoia.SQL.Append('	UGM_DATE,');
        QrySelectGinkoia.SQL.Append('	K_ENABLED,');
        QrySelectGinkoia.SQL.Append('	UGG_NOM');
        QrySelectGinkoia.SQL.Append('From UILGRPGINKOIAMAG');
        QrySelectGinkoia.SQL.Append('Join K on (K_ID = UGM_ID)');
        QrySelectGinkoia.SQL.Append('Join UILGRPGINKOIA on (UGM_UGGID = UGG_ID)');
        QrySelectGinkoia.SQL.Append('Where UGM_ID <> 0');
        QrySelectGinkoia.Open;
        QrySelectGinkoia.First;

        while not QrySelectGinkoia.Eof do
        begin
          QrySelectMaintenance.Close;
          QrySelectMaintenance.SQL.Text:= cSql_S_SyncBase_Modules_Magasins;
          QrySelectMaintenance.ParamByName('PMODUNOM').AsString := QrySelectGinkoia.FieldByName('UGG_NOM').AsString;
          QrySelectMaintenance.ParamByName('PMAGAMAGID_GINKOIA').AsInteger:= QrySelectGinkoia.FieldByName('UGM_MAGID').AsInteger;
          QrySelectMaintenance.ParamByName('PMAGADOSSID').AsInteger:= ADOSS_ID;
          QrySelectMaintenance.Open;

          QryGenMaintenance.Close;

          if QrySelectMaintenance.Eof then
          begin
            //Insert car non présent
            QryGenMaintenance.SQL.Text:= cSql_I_Modules_Magasins;
          end
          else
          begin
            //Update
            QryGenMaintenance.SQL.Text:= cSql_U_Modules_Magasins;
          end;

          QrySelectMaintenance.Close;
          QrySelectMaintenance.SQL.Text:= cSql_S_SyncBase_Modules;
          QrySelectMaintenance.ParamByName('PMODUNOM').AsString:= QrySelectGinkoia.FieldByName('UGG_NOM').AsString;
          QrySelectMaintenance.Open;
          iMODUID := QrySelectMaintenance.FieldByName('MODU_ID').AsInteger;

          QrySelectMaintenance.Close;
          QrySelectMaintenance.SQL.Text:= cSql_S_SyncBase_Magasins;
          QrySelectMaintenance.ParamByName('PMAGAMAGIDGINKOIA').AsInteger:= QrySelectGinkoia.FieldByName('UGM_MAGID').AsInteger;
          QrySelectMaintenance.ParamByName('PMAGADOSSID').AsInteger:= ADOSS_ID;
          QrySelectMaintenance.Open;
          iMAGID := QrySelectMaintenance.FieldByName('MAGA_ID').AsInteger;

          QryGenMaintenance.ParamByName('PMMAGMODUID').AsInteger:= iMODUID;
          QryGenMaintenance.ParamByName('PMMAGMAGAID').AsInteger:= iMAGID;
          QryGenMaintenance.ParamByName('PMMAGEXPDATE').AsDateTime:= QrySelectGinkoia.FieldByName('UGM_DATE').AsDateTime;
          QryGenMaintenance.ParamByName('PMMAGKENABLED').AsInteger:= QrySelectGinkoia.FieldByName('K_ENABLED').AsInteger;
          QryGenMaintenance.ParamByName('PMMAGUGMID').AsInteger:= QrySelectGinkoia.FieldByName('UGM_ID').AsInteger;
          QryGenMaintenance.ExecSQL;

          QrySelectGinkoia.Next;
        end;

        QryGenMaintenance.Transaction.Commit;
        QrySelectMaintenance.Close;
        QryGenMaintenance.Close;
        QrySelectGinkoia.Close;
      except
        on E: Exception do
        begin
          LogDebug(FichierLog, 'Except : Partie Synchro UILGRPGINKOIAMAG Ginkoia -> Maintenance MODULES_MAGASINS');
          LogDebug(FichierLog, '         ' + E.Message);
          LogDebug(FichierLog, '         ' + QryGenMaintenance.SQL.Text);
          LogDebug(FichierLog, '         PMMAGMODUID = ' + IntToStr(QryGenMaintenance.ParamByName('PMMAGMODUID').AsInteger));
          LogDebug(FichierLog, '         PMMAGMAGAID = ' + IntToStr(QryGenMaintenance.ParamByName('PMMAGMAGAID').AsInteger));
          LogDebug(FichierLog, '         PMMAGEXPDATE = ' + DateTimeToStr(QryGenMaintenance.ParamByName('PMMAGEXPDATE').AsDateTime));
          LogDebug(FichierLog, '         PMMAGKENABLED = ' + IntToStr(QryGenMaintenance.ParamByName('PMMAGKENABLED').AsInteger));
          LogDebug(FichierLog, '         PMMAGUGMID = ' + IntToStr(QryGenMaintenance.ParamByName('PMMAGUGMID').AsInteger));
          QryGenMaintenance.Transaction.Rollback;
        end;
      end;
      if QryGenMaintenance.Transaction.InTransaction then
        QryGenMaintenance.Transaction.Commit;

    except
      on E: Exception do
      begin
        Raise Exception.Create(ClassName + '.SyncBase : ' + E.Message);
        Result := 'Erreur dans SyncBase : ' + E.Message;
      end;
    end;
  finally

  end;
  Result := 'Synchronisation de la base effectué.';
end;

function TForm1.SyncBaseByDllMaintenance(const ADOSS_ID: integer): string;
var
  vIdHTTP: TIdHTTP;
  vParser: TParser;
  Buffer: String;
begin
  Result:= '';

  vParser:= TParser.Create(nil);
  vIdHTTP:= GetNewIdHTTP(nil);
  try
    if Trim(FApiUrlMaintenance) = '' then
      Raise Exception.Create('Le paramètre "APIURLMAINTENANCE" de la section "GENERAL" du fichier GUID.ini est introuvable ou vide !');

    try
      vParser.ARequest:= vIdHTTP.Get(FApiUrlMaintenance + '/SyncBase?DOSS_ID=' + IntToStr(ADOSS_ID) + '&RETURNCODE=1');
      vParser.Execute;

      if (vParser.ADataSet.FindField(cBlsResult) <> nil) and
         (not vParser.ADataSet.FieldByName(cBlsResult).IsNull) then
        begin
          Buffer:= vParser.ADataSet.FieldByName(cBlsResult).AsString;

          if Trim(Buffer) <> '' then
            begin
              case Buffer[1] of
                '0': Result:= 'La synchronisation du dossier [ ' + IntToStr(ADOSS_ID) + ' ] est terminée.';
                '1': Result:= 'Une ou des erreurs se sont produites pendant la synchronisation du dossier [ ' + IntToStr(ADOSS_ID) + ' ]. Voir le fichier SyncBase_xxx.Traceur dans le répertoire log de la dll Maintenance.';
              end;

            end;

        end;

    except
      Raise;
    end;

  finally
    FreeAndNil(vParser);
    FreeAndNil(vIdHTTP);
  end;

end;

{ 16/03/2021 Greg - Méthode dupliquée de Maintenance }
function TForm1.GetGenParam(Const APRM_TYPE, APRM_CODE: integer; Const AFieldWhere: TFieldWhere; Const AValueFieldWhere: integer;
  Const AFieldResult: TFieldResult; Const AResultZeroIfPRM_FLOATIsDateNull: Boolean; Const AWithK_ENABLED: Boolean): Variant;

Const
  cSql_S_GENPARAM_Ext = 'SELECT' + cRC +
                          'PRM_ID,' + cRC +
                          'PRM_INTEGER,' + cRC +
                          'PRM_FLOAT,' + cRC +
                          'PRM_STRING' + cRC +
                        'FROM GENPARAM' + cRC +
                          'JOIN K ON (K_ID = PRM_ID %s)' + cRC +
                        'WHERE' + cRC +
                          'PRM_TYPE = :PPRMTYPE' + cRC +
                          'AND PRM_CODE = :PPRMCODE';
var
  vQry: TIBQuery;
begin
  Result := null;

  vQry:= TIBQuery.Create(nil);
  try
    vQry.Database:= data;
    vQry.Transaction:= tran;

    try
      if AWithK_ENABLED then
        vQry.SQL.Text:= Format(cSql_S_GENPARAM_Ext, ['AND K_ENABLED = 1'])
      else
        vQry.SQL.Text:= Format(cSql_S_GENPARAM_Ext, ['']);

      case AFieldWhere of
        fwPOS:
          begin
            vQry.SQL.Append('AND PRM_POS =:PPRMPOS');
            vQry.ParamByName('PPRMPOS').AsInteger:= AValueFieldWhere;
          end;

        fwMAGID:
          begin
            vQry.SQL.Append('AND PRM_MAGID =:PPRMMAGID');
            vQry.ParamByName('PPRMMAGID').AsInteger:= AValueFieldWhere;
          end;
      end;

      vQry.ParamByName('PPRMTYPE').AsInteger:= APRM_TYPE;
      vQry.ParamByName('PPRMCODE').AsInteger:= APRM_CODE;

      vQry.Open;

      if not vQry.Eof then
        begin
          case AFieldResult of
            frPRM_ID: Result:= vQry.FieldByName('PRM_ID').AsInteger;
            frPRM_INTEGER: Result:= vQry.FieldByName('PRM_INTEGER').AsInteger;
            frPRM_FLOAT: Result:= vQry.FieldByName('PRM_FLOAT').AsFloat;
            frPRM_STRING: Result:= vQry.FieldByName('PRM_STRING').AsString;
          end;
        end;

      // Dans le cas ou le genparam est introuvable
      if Result = null then
        Result:= -999;

      // Dans le cas ou le PRM_FLOAT contient une date
      if AResultZeroIfPRM_FLOATIsDateNull then
        begin
          if (AFieldResult = frPRM_FLOAT) and ((Result = null) or (Result = -999)) then
            Result:= 0;
        end;

    except
      on E: Exception do
        Raise Exception.Create(ClassName + '.GetGenParam : ' + E.Message);
    end;

  finally
    FreeAndNil(vQry);
  end;
end;

procedure TForm1.Check_Mode_K_VERSION;
var
  QueTmp: TIBQuery;
  vK_ENABLED: string;
  vVERSION_ID: boolean;
  vDependance_VERSION_ID: boolean;
begin
  if (FGestion_K_VERSION = TKNone) then
  begin
    vK_ENABLED := 'int32';
    vVERSION_ID := false;
    vDependance_VERSION_ID := false;
    QueTmp := TIBQuery.Create(Self);
    try
      QueTmp.Database := Data;
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
      QueTmp.close();

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
      if (vK_ENABLED = 'int64') and (vVERSION_ID) and (vDependance_VERSION_ID) then
        FGestion_K_VERSION := TKV64;

      QueTmp.Free;
    end;
  end;
end;

function TForm1.GetGestion_K_VERSION: TGestion_K_Version;
begin
  if (FGestion_K_VERSION = TKNone) then
    Check_Mode_K_VERSION();

  Result := FGestion_K_VERSION;
end;

function TForm1.IsInteger(Const S: String): Boolean;
var
  i: integer;
begin
  Result:= True;
  for i:= 1 to Length(S) do
    begin
      if not (S[i] in ['0'..'9']) then
        begin
          Result:= False;
          Break;
        end;
    end;
end;


END.

