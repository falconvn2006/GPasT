unit uMdlMaintenance;

interface

uses
  Windows, SysUtils, Classes, System.Types, Contnrs, SqlExpr, DB, dmdGINKOIA_XE7,
  ComObj, uConst, uMdlGinkoia, uSql, GestionJetonLaunch,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.Phys.IBDef, FireDAC.Phys.IBBase,
  FireDAC.Phys.IB, FireDAC.Comp.Client, FireDAC.Comp.DataSet;

Type
  { forward Declaration }
  TDossier = Class;
  TEmetteur = Class;
  TPoste = Class;
  TSociete = Class;
  THoraire = Class;
  TConnexion = Class;
  TGroupPump = Class;

  TGnkGenLiaiRepli = Class(TGnk)
  private
    FGLR_LASTVERSION: String;
    FGLR_REPID: integer;
    FGLR_ID: integer;
    FGLR_PROSUBID: integer;
  public
    constructor Create(AOwner: TComponent); override;
    procedure MAJ(Const AAction: TUpdateKind = ukModify); override;

    procedure SetValuesByDataSet(const ADS: TDataSet);
  published
    property GLR_ID: integer read FGLR_ID write FGLR_ID;
    property GLR_REPID: integer read FGLR_REPID write FGLR_REPID;
    property GLR_PROSUBID: integer read FGLR_PROSUBID write FGLR_PROSUBID;
    property GLR_LASTVERSION: String read FGLR_LASTVERSION write FGLR_LASTVERSION;
  End;

  TGnkGenSubscribers = Class(TGnk)
  private
    FSUB_ID: integer;
    FSUB_LOOP: integer;
    FSUB_ORDRE: integer;
    FSUB_NOM: String;
    FGenLiaiRepli: TGnkGenLiaiRepli;
  protected
    function GetLastOrdre: integer;
    procedure SetDOSS_ID(const Value: integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure MAJ(Const AAction: TUpdateKind = ukModify); override;

    procedure SetValuesByDataSet(const ADS: TDataSet);

  published
    property SUB_ID: integer read FSUB_ID write FSUB_ID;
    property SUB_NOM: String read FSUB_NOM write FSUB_NOM;
    property SUB_ORDRE: integer read FSUB_ORDRE write FSUB_ORDRE;
    property SUB_LOOP: integer read FSUB_LOOP write FSUB_LOOP;

    property AGenLiaiRepli: TGnkGenLiaiRepli read FGenLiaiRepli write FGenLiaiRepli;
  End;

  TGnkGenProviders = Class(TGnk)
  private
    FPRO_LOOP: integer;
    FPRO_ORDRE: integer;
    FPRO_NOM: String;
    FPRO_ID: integer;
    FGenLiaiRepli: TGnkGenLiaiRepli;
  protected
    function GetLastOrdre: integer;
    procedure SetDOSS_ID(const Value: integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure MAJ(Const AAction: TUpdateKind = ukModify); override;

    procedure SetValuesByDataSet(const ADS: TDataSet);
  published
    property PRO_ID: integer read FPRO_ID write FPRO_ID;
    property PRO_NOM: String read FPRO_NOM write FPRO_NOM;
    property PRO_ORDRE: integer read FPRO_ORDRE write FPRO_ORDRE;
    property PRO_LOOP: integer read FPRO_LOOP write FPRO_LOOP;

    property AGenLiaiRepli: TGnkGenLiaiRepli read FGenLiaiRepli write FGenLiaiRepli;
  End;

  TGnkGenLaunch = Class(TGnk)
  private
    FLAU_AUTORUN: integer;
    FLAU_HEURE2: TDateTime;
    FLAU_BACKTIME: TDateTime;
    FLAU_HEURE1: TDateTime;
    FLAU_ID: integer;
    FLAU_H2: integer;
    FLAU_BASID: integer;
    FLAU_BACK: integer;
    FLAU_H1: integer;
  published
  public
    // constructor Create(AOwner: TComponent); override;
    procedure MAJ(Const AAction: TUpdateKind = ukModify); override;

    procedure SetValuesByDataSet(const ADS: TDataSet);
  published
    property LAU_ID: integer read FLAU_ID write FLAU_ID;
    property LAU_BASID: integer read FLAU_BASID write FLAU_BASID;
    property LAU_HEURE1: TDateTime read FLAU_HEURE1 write FLAU_HEURE1;
    property LAU_H1: integer read FLAU_H1 write FLAU_H1;
    property LAU_HEURE2: TDateTime read FLAU_HEURE2 write FLAU_HEURE2;
    property LAU_H2: integer read FLAU_H2 write FLAU_H2;
    property LAU_AUTORUN: integer read FLAU_AUTORUN write FLAU_AUTORUN;
    property LAU_BACK: integer read FLAU_BACK write FLAU_BACK;
    property LAU_BACKTIME: TDateTime read FLAU_BACKTIME write FLAU_BACKTIME;
  End;

  TGnkGenReplication = Class(TGnk)
  private
    FREP_ID: integer;
    FREP_PUSH: String;
    FREP_PLACEBASE: String;
    FREP_PLACEEAI: String;
    FREP_URLLOCAL: String;
    FREP_USER: String;
    FREP_LAUID: integer;
    FREP_PULL: String;
    FREP_PWD: String;
    FREP_URLDISTANT: String;
    FREP_PING: String;
    FREP_ORDRE: integer;
    FREP_JOUR: integer;
    FREP_EXEFINREPLIC: String;
  protected
    function GetLastOrdre: integer;
  public
    // constructor Create(AOwner: TComponent); override;
    procedure MAJ(Const AAction: TUpdateKind = ukModify); override;

    procedure SetValuesByDataSet(const ADS: TDataSet);
  published
    property REP_ID: integer read FREP_ID write FREP_ID;
    property REP_LAUID: integer read FREP_LAUID write FREP_LAUID;
    property REP_PING: String read FREP_PING write FREP_PING;
    property REP_PUSH: String read FREP_PUSH write FREP_PUSH;
    property REP_PULL: String read FREP_PULL write FREP_PULL;
    property REP_USER: String read FREP_USER write FREP_USER;
    property REP_PWD: String read FREP_PWD write FREP_PWD;
    property REP_ORDRE: integer read FREP_ORDRE write FREP_ORDRE;
    property REP_URLLOCAL: String read FREP_URLLOCAL write FREP_URLLOCAL;
    property REP_URLDISTANT: String read FREP_URLDISTANT write FREP_URLDISTANT;
    property REP_PLACEEAI: String read FREP_PLACEEAI write FREP_PLACEEAI;
    property REP_PLACEBASE: String read FREP_PLACEBASE write FREP_PLACEBASE;
    property REP_JOUR: integer read FREP_JOUR write FREP_JOUR;
    property REP_EXEFINREPLIC: String read FREP_EXEFINREPLIC write FREP_EXEFINREPLIC;
  End;

  TGnkSplittageLog = Class(TCustomGnk)
  private
    FSPLI_ERROR: integer;
    FSPLI_USERNAME: string;
    FSPLI_NOSPLIT: integer;
    FSPLI_TERMINATE: integer;
    FSPLI_DATEHEURESTART: TDateTime;
    FSPLI_TYPESPLIT: string;
    FSPLI_EVENTLOG: string;
    FSPLI_EMETNOM: string;
    FSPLI_ORDRE: integer;
    FSPLI_STARTED: integer;
    FSPLI_EMETID: integer;
    FSPLI_DATEHEUREEND: TDateTime;
    FSPLI_CLEARFILES: integer;
    FSPLI_BASE: integer;
    FSPLI_MAIL: integer;
  protected
    function GetLastOrdre: integer;
    procedure AddEVENTLOG(Const ASLValue: TStrings);
  public
    constructor Create(AOwner: TComponent); override;
    procedure MAJ(Const AAction: TUpdateKind = ukModify); override;

    procedure SetStart;

    procedure SetValuesByDataSet(const ADS: TDataSet);
  published
    property SPLI_NOSPLIT: integer read FSPLI_NOSPLIT write FSPLI_NOSPLIT;
    property SPLI_EMETID: integer read FSPLI_EMETID write FSPLI_EMETID;
    property SPLI_EMETNOM: string read FSPLI_EMETNOM write FSPLI_EMETNOM;
    property SPLI_DATEHEURESTART: TDateTime read FSPLI_DATEHEURESTART write FSPLI_DATEHEURESTART;
    property SPLI_DATEHEUREEND: TDateTime read FSPLI_DATEHEUREEND write FSPLI_DATEHEUREEND;
    property SPLI_ORDRE: integer read FSPLI_ORDRE write FSPLI_ORDRE;
    property SPLI_EVENTLOG: string read FSPLI_EVENTLOG write FSPLI_EVENTLOG;
    property SPLI_STARTED: integer read FSPLI_STARTED write FSPLI_STARTED;
    property SPLI_TERMINATE: integer read FSPLI_TERMINATE write FSPLI_TERMINATE;
    property SPLI_ERROR: integer read FSPLI_ERROR write FSPLI_ERROR;
    property SPLI_USERNAME: string read FSPLI_USERNAME write FSPLI_USERNAME;
    property SPLI_TYPESPLIT: string read FSPLI_TYPESPLIT write FSPLI_TYPESPLIT;
    property SPLI_CLEARFILES: integer read FSPLI_CLEARFILES write FSPLI_CLEARFILES;
    property SPLI_BASE: integer read FSPLI_BASE write FSPLI_BASE;
    property SPLI_MAIL: integer read FSPLI_MAIL write FSPLI_MAIL;
  End;

  TRaison = Class(TCustomGnk)
  private
    FRAIS_NOM: String;
    FRAIS_ID: integer;
  public
  published
    property RAIS_ID: integer read FRAIS_ID write FRAIS_ID;
    property RAIS_NOM: String read FRAIS_NOM write FRAIS_NOM;
  End;

  TModeleMail = Class(TCustomGnk)
  private
    FMAIL_OBJET: String;
    FMAIL_NAME: String;
    FMAIL_FILENAME: String;
    FMAIL_MESSAGE: String;
    procedure SetMAIL_FILENAME(const Value: String);
  public
  published
    property MAIL_FILENAME: String read FMAIL_FILENAME write SetMAIL_FILENAME;
    property MAIL_NAME: String read FMAIL_NAME write FMAIL_NAME;
    property MAIL_OBJET: String read FMAIL_OBJET write FMAIL_OBJET;
    property MAIL_MESSAGE: String read FMAIL_MESSAGE write FMAIL_MESSAGE;
  End;

  TSrvReplication = Class(TCustomGnk)
  private
    FSVR_DATE: String;
    FSRV_ID: integer;
    FSVR_ERR: String;
    FSVR_PATH: String;
    FSVR_VERSION: String;
    FSVR_DATABASE: String;
    FSVR_SENDER: String;
  public
    procedure MAJ(Const AAction: TUpdateKind = ukModify); override;
  published
    property SRV_ID: integer read FSRV_ID write FSRV_ID;
    property SVR_DATE: String read FSVR_DATE write FSVR_DATE;
    property SVR_VERSION: String read FSVR_VERSION write FSVR_VERSION;
    property SVR_ERR: String read FSVR_ERR write FSVR_ERR;
    property SVR_PATH: String read FSVR_PATH write FSVR_PATH;
    property SVR_DATABASE: String read FSVR_DATABASE write FSVR_DATABASE;
    property SVR_SENDER: String read FSVR_SENDER write FSVR_SENDER;
  end;

  TGroupe = Class(TGnkGrp)
  public
    procedure MAJ(Const AAction: TUpdateKind = ukModify); override;
  end;

  TVersion = Class(TGnkVersion)
  public
    procedure MAJ(Const AAction: TUpdateKind = ukModify);
  end;

  TServeur = Class(TCustomGnk)
  private
    FListHoraire: TObjectList;
    FSERV_NOM: string;
    FSERV_ID: integer;
    FSERV_IP: string;
    FSERV_DOSEAI: string;
    FSERV_USER: string;
    FSERV_PASSWORD: string;
    FSERV_LOCALIP: string;
    FSERV_DOSBDD: string;
    FSERV_SEVENZIP: string;
    function GetCountHoraire: integer;
    function GetHoraire(index: integer): THoraire;
    function GetHoraireByID(APRH_ID: integer): THoraire;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure MAJ(Const AAction: TUpdateKind = ukModify);

    procedure SetValuesByDataSet(const ADS: TDataSet);

    property CountHoraire: integer read GetCountHoraire;
    property Horaire[index: integer]: THoraire read GetHoraire;
    property HoraireByID[APRH_ID: integer]: THoraire read GetHoraireByID;
    procedure AppendHoraire(Const AHoraire: THoraire);
    procedure DeleteHoraire(Const AHoraire: THoraire);
  published
    property SERV_ID: integer read FSERV_ID write FSERV_ID;
    property SERV_NOM: String read FSERV_NOM write FSERV_NOM;
    property SERV_IP: String read FSERV_IP write FSERV_IP;
    property SERV_DOSEAI: String read FSERV_DOSEAI write FSERV_DOSEAI;
    property SERV_USER: string read FSERV_USER write FSERV_USER;
    property SERV_PASSWORD: string read FSERV_PASSWORD write FSERV_PASSWORD;
    property SERV_LOCALIP: string read FSERV_LOCALIP write FSERV_LOCALIP;
    property SERV_DOSBDD: String read FSERV_DOSBDD write FSERV_DOSBDD;
    property SERV_SEVENZIP: String read FSERV_SEVENZIP write FSERV_SEVENZIP;
  End;

  TModule = Class(TGnkModule)
  private
    FMODU_ID: integer;
    FMODU_COMMENT: String;
    FMODU_NOM: String;
    FMMAG_EXPDATE: TDateTime;
  public
  published
    property MODU_ID: integer read FMODU_ID write FMODU_ID;
    property MODU_NOM: String read FMODU_NOM write FMODU_NOM;
    property MODU_COMMENT: String read FMODU_COMMENT write FMODU_COMMENT;
    property MMAG_EXPDATE: TDateTime read FMMAG_EXPDATE write FMMAG_EXPDATE;
  End;

  TModuleGinkoia = Class(TModule)
  private
    FMAGA_ID: integer;
    FDossier: TDossier;
    FDOSS_ID: integer;
    function GetDOSS_ID: integer;
  public
    procedure MAJ(Const AAction: TUpdateKind = ukModify); override;

    property ADossier: TDossier read FDossier write FDossier;
  published
    property DOSS_ID: integer read GetDOSS_ID write FDOSS_ID;
    property MAGA_ID: integer read FMAGA_ID write FMAGA_ID;
  End;

  TMagasin = Class(TGnkMagasin)
  private
    FMAGA_DOSSID: integer;
    FMAGA_BASID: integer;
    FMAGA_MAGCODE: string;
    FMAGA_MAGID_GINKOIA: integer;
    FDossier: TDossier;
    function GetMAGA_DOSSID: integer;
    function GetModuleByNOM(AMOD_NOM: String): TModule;
    function GetModuleByID(AMOD_ID: integer): TModule;
    function GetModule(index: integer): TModule;
    function GetPoste(index: integer): TPoste;
    function GetPosteByID(APOST_POSID: integer): TPoste;
  protected
  public
    procedure MAJ(Const AAction: TUpdateKind = ukModify); override;

    procedure SetValuesByDataSet(const ADS: TDataSet); override;

    property Module[index: integer]: TModule read GetModule;
    property ModuleByID[AMOD_ID: integer]: TModule read GetModuleByID;
    property ModuleByNOM[AMOD_NOM: String]: TModule read GetModuleByNOM;
    procedure AppendMdl(Const AMdl: TModule);
    procedure DeleteMdl(Const AMdl: TModule);

    property Poste[index: integer]: TPoste read GetPoste;
    property PosteByID[APOST_POSID: integer]: TPoste read GetPosteByID;
    procedure AppendPoste(Const APoste: TPoste);
    procedure DeletePoste(Const APoste: TPoste);

    property ADossier: TDossier read FDossier write FDossier;
  published
    property MAGA_DOSSID: integer read GetMAGA_DOSSID write FMAGA_DOSSID;
    property MAGA_MAGID_GINKOIA: integer read FMAGA_MAGID_GINKOIA write FMAGA_MAGID_GINKOIA;
    property MAGA_BASID: integer read FMAGA_BASID write FMAGA_BASID;
    property MAGA_MAGCODE: string read FMAGA_MAGCODE write FMAGA_MAGCODE;
  End;

  TDossier = Class(TCustomGnk)
  private
    FListMag: TObjectList;
    FListEmetteur: TObjectList;
    FListSociete: TObjectList;
    FListGroupPump: TObjectList;
    FDOSS_ID: integer;
    FDOSS_DATABASE: String;
    FDOSS_SERVID: integer;
    FDOSS_CHEMIN: String;
    FDOSS_GROUID: integer;
    FDOSS_INSTALL: TDateTime;
    FDOSS_VIP: integer;
    FDOSS_PLATEFORME: String;
    FDOSS_EMAIL: String;
    FDOSS_ACTIF: integer;
    FDOSS_RECALTEMPS: integer;
    FDOSS_RECALLASTDATE: TDateTime;
    FDOSS_EASY: integer;
    FVersion: TVersion;
    FServeur: TServeur;
    FGroupe: TGroupe;
    FVERS_ID: integer;
    FSERV_NOM: String;
    FSERV_USER: String;
    FSERV_PASSWORD: String;
    FSERV_LOCALIP: String;
    FSERV_IP: String;
    FVERS_VERSION: String;
    FGROU_NOM: String;
    FTokenManager: TTokenManager;
    FBJETON: Boolean;
    function GetCountMag: integer;
    function GetMagasin(index: integer): TMagasin;
    function GetMagasinByID(AMAGA_ID: integer): TMagasin;
    function GetDOSS_SERVID: integer;
    function GetSERV_IP: String;
    function GetDOSS_GROUID: integer;
    function GetCountEmetteur: integer;
    function GetEmetteurByID(AEMET_ID: integer): TEmetteur;
    function GetEmetteur(index: integer): TEmetteur;
    function GetCountSociete: integer;
    function GetSociete(index: integer): TSociete;
    function GetSocieteByID(ASOC_ID: integer): TSociete;
    function GetCountGroupPump: integer;
    function GetGroupPump(index: integer): TGroupPump;
    function GetGroupPumpByID(AGCP_ID: integer): TGroupPump;
    function GetVERS_ID: integer;
    function GetGROU_NOM: String;
    function GetSERV_NOM_ID: String;
    function GetSERV_USER: String;
    function GetSERV_PASSWORD: String;
    function GetSERV_LOCALIP: String;
    function GetVERS_VERSION: String;
    function GetMagasinByIDGINKOIA(AMAG_ID_GINKOIA: integer): TMagasin;
    function GetEmetteurByGUID(AEMET_GUID: String): TEmetteur;
    function GetEmetteurByIDENT(AEMET_IDENT: String): TEmetteur;
  protected
    procedure PlageToSL(Const S: String; Const ASL: TStringList);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure MAJ(Const AAction: TUpdateKind = ukModify); override;

    procedure SetValuesByDataSet(const ADS: TDataSet);

    function GetNewGUID: String;

    function IsPlageExist(Const AdmGINKOIA: TdmGINKOIA; Const APlage: String): Boolean;
    function GetNewPlage(Const AdmGINKOIA: TdmGINKOIA; AListPlage: TStringList): String;
    function GetNewIdent(Const AdmGINKOIA: TdmGINKOIA): String;

    property CountMag: integer read GetCountMag;
    property Magasin[index: integer]: TMagasin read GetMagasin;
    property MagasinByID[AMAG_ID: integer]: TMagasin read GetMagasinByID;
    property MagasinByIDGINKOIA[AMAG_ID_GINKOIA: integer]: TMagasin read GetMagasinByIDGINKOIA;
    procedure AppendMag(Const AMag: TMagasin);
    procedure DeleteMag(Const AMag: TMagasin);

    property CountEmetteur: integer read GetCountEmetteur;
    property Emetteur[index: integer]: TEmetteur read GetEmetteur;
    property EmetteurByID[ABAS_ID: integer]: TEmetteur read GetEmetteurByID;
    property EmetteurByGUID[AEMET_GUID: String]: TEmetteur read GetEmetteurByGUID;
    property EmetteurByIDENT[AEMET_IDENT: String]: TEmetteur read GetEmetteurByIDENT;
    procedure AppendEmetteur(Const AEmet: TEmetteur);
    procedure DeleteEmetteur(Const AEmet: TEmetteur);

    property CountSociete: integer read GetCountSociete;
    property Societe[index: integer]: TSociete read GetSociete;
    property SocieteByID[ASOC_ID: integer]: TSociete read GetSocieteByID;
    procedure AppendSociete(Const ASoc: TSociete);
    procedure DeleteSociete(Const ASoc: TSociete);

    property CountGroupPump: integer read GetCountGroupPump;
    property GroupPump[index: integer]: TGroupPump read GetGroupPump;
    property GroupPumpByID[AGCP_ID: integer]: TGroupPump read GetGroupPumpByID;
    procedure AppendGroupPump(Const AGrp: TGroupPump);
    procedure DeleteGroupPump(Const AGrp: TGroupPump);

    property AServeur: TServeur read FServeur write FServeur;
    property AGroupe: TGroupe read FGroupe write FGroupe;
    property AVersion: TVersion read FVersion write FVersion;
    property TokenManager: TTokenManager read FTokenManager write FTokenManager;

  published
    property DOSS_ID: integer read FDOSS_ID write FDOSS_ID;
    property DOSS_DATABASE: String read FDOSS_DATABASE write FDOSS_DATABASE;
    property DOSS_SERVID: integer read GetDOSS_SERVID write FDOSS_SERVID;
    property DOSS_CHEMIN: String read FDOSS_CHEMIN write FDOSS_CHEMIN;
    property DOSS_GROUID: integer read GetDOSS_GROUID write FDOSS_GROUID;
    property DOSS_INSTALL: TDateTime read FDOSS_INSTALL write FDOSS_INSTALL;
    property DOSS_VIP: integer read FDOSS_VIP write FDOSS_VIP;
    property DOSS_PLATEFORME: String read FDOSS_PLATEFORME write FDOSS_PLATEFORME;
    property DOSS_EMAIL: String read FDOSS_EMAIL write FDOSS_EMAIL;
    property DOSS_ACTIF: integer read FDOSS_ACTIF write FDOSS_ACTIF;
    property DOSS_EASY: integer read FDOSS_EASY write FDOSS_EASY;
    property DOSS_RECALTEMPS: integer read FDOSS_RECALTEMPS write FDOSS_RECALTEMPS;
    property DOSS_RECALLASTDATE: TDateTime read FDOSS_RECALLASTDATE write FDOSS_RECALLASTDATE;

    property VERS_ID: integer read GetVERS_ID write FVERS_ID;
    property SERV_NOM: String read GetSERV_NOM_ID write FSERV_NOM;
    property SERV_USER: String read GetSERV_USER write FSERV_USER;
    property SERV_PASSWORD: String read GetSERV_PASSWORD write FSERV_PASSWORD;
    property SERV_LOCALIP: String read GetSERV_LOCALIP write FSERV_LOCALIP;
    property SERV_IP: String read GetSERV_IP write FSERV_IP;
    property GROU_NOM: String read GetGROU_NOM write FGROU_NOM;
    property VERS_VERSION: String read GetVERS_VERSION write FVERS_VERSION;

    property BJETON: Boolean read FBJETON write FBJETON;
  End;

  TEmetteur = Class(TGnkBase)
  private
    FEMET_TIERSCEGID: String;
    FEMET_BASID_GINKOIA: integer;
    FEMET_NOM: String;
    FEMET_INSTALL: TDateTime;
    FEMET_ID: integer;
    FEMET_JETON: integer;
    FEMET_TYPEREPLICATION: String;
    FEMET_BCKOK: TDateTime;
    FEMET_SPE_FAIT: integer;
    FEMET_DERNBCK: TDateTime;
    FEMET_FINNONREPLICATION: TDate;
    FEMET_H2: integer;
    FEMET_GUID: String;
    FEMET_SERVEURSECOURS: integer;
    FEMET_H1: integer;
    FEMET_SPE_PATCH: integer;
    FEMET_IDENT: String;
    FEMET_PLAGE: String;
    FEMET_VERSION_MAX: integer;
    FEMET_INFOSUP: String;
    FEMET_EMAIL: String;
    FEMET_NONREPLICATION: integer;
    FEMET_HEURE2: TDateTime;
    FEMET_DEBUTNONREPLICATION: TDate;
    FEMET_PATCH: integer;
    FEMET_MAGID: integer;
    FEMET_DONNEES: String;
    FEMET_HEURE1: TDateTime;
    FEMET_RESBCK: String;
    FDossier: TDossier;
    FEMET_DOSSID: integer;
    FEMET_VERSID: integer;
    FHDBM_COMMENTAIRE: String;
    FRAIS_NOM: String;
    FRAIS_ID: integer;
    FHDBM_DATE: TDateTime;
    FHDBM_OK: integer;
    FHDBM_ARCHIVER: integer;
    FHDBM_ID: integer;
    FHDBM_CYCLE: TDateTime;
    FRTR_HEUREFIN: TDateTime;
    FRTR_DELAI: integer;
    FRTR_HEUREDEB: TDateTime;
    FRTR_NBESSAI: integer;
    FRTR_DATABASE: String;
    FRTR_URL: String;
    FRTR_SENDER: String;
    FRTR_PRMID_DELAI: integer;
    FRTR_PRMID_HEUREDEB: integer;
    FRTR_PRMID_DATABASE: integer;
    FRTR_PRMID_URL: integer;
    FRTR_PRMID_SENDER: integer;
    FRTR_PRMID_HEUREFIN: integer;
    FRTR_PRMID_NBESSAI: integer;
    FRW_PRMID_HEUREFIN: integer;
    FRW_HEUREFIN: TDateTime;
    FRW_INTERVALLE: real;
    FRW_ORDRE: integer;
    FRW_PRMID_INTERORDRE: integer;
    FRW_PRMID_HEUREDEB: integer;
    FRW_HEUREDEB: TDateTime;
    function GetFEMET_DOSSID: integer;
    function GetEMET_EMAIL: String;
    function GetConnexion(index: integer): TConnexion;
    function GetConnexionByID(ACON_ID: integer): TConnexion;
  protected
    // function GetBAS_NOM: String; override; //--> Deprecated 24/07/2013 Greg
    function GetListFieldGENBASES(Const AdmGINKOIA: TdmGINKOIA): TStringList; virtual;
  public
    procedure MAJ(Const AAction: TUpdateKind = ukModify); override;

    procedure SetValuesByDataSet(Const ADS: TDataSet); override;
    procedure MatchGenBasesToEmetteur;

    property Connexion[index: integer]: TConnexion read GetConnexion;
    property ConnexionByID[ACON_ID: integer]: TConnexion read GetConnexionByID;
    procedure AppendConnexion(Const ACon: TConnexion);
    procedure DeleteConnexion(Const ACon: TConnexion);

    property ADossier: TDossier read FDossier write FDossier;
  published
    property EMET_ID: integer read FEMET_ID write FEMET_ID;
    property EMET_NOM: String read FEMET_NOM write FEMET_NOM;
    property EMET_JETON: integer read FEMET_JETON write FEMET_JETON;
    property EMET_IDENT: String read FEMET_IDENT write FEMET_IDENT;
    property EMET_PLAGE: String read FEMET_PLAGE write FEMET_PLAGE;
    property EMET_GUID: String read FEMET_GUID write FEMET_GUID;
    property EMET_DONNEES: String read FEMET_DONNEES write FEMET_DONNEES;
    property EMET_DOSSID: integer read GetFEMET_DOSSID write FEMET_DOSSID;
    property EMET_VERSID: integer read FEMET_VERSID write FEMET_VERSID;
    property EMET_INSTALL: TDateTime read FEMET_INSTALL write FEMET_INSTALL;
    property EMET_MAGID: integer read FEMET_MAGID write FEMET_MAGID;
    property EMET_PATCH: integer read FEMET_PATCH write FEMET_PATCH;
    property EMET_VERSION_MAX: integer read FEMET_VERSION_MAX write FEMET_VERSION_MAX;
    property EMET_SPE_PATCH: integer read FEMET_SPE_PATCH write FEMET_SPE_PATCH;
    property EMET_SPE_FAIT: integer read FEMET_SPE_FAIT write FEMET_SPE_FAIT;
    property EMET_BCKOK: TDateTime read FEMET_BCKOK write FEMET_BCKOK;
    property EMET_DERNBCK: TDateTime read FEMET_DERNBCK write FEMET_DERNBCK;
    property EMET_RESBCK: String read FEMET_RESBCK write FEMET_RESBCK;
    property EMET_TIERSCEGID: String read FEMET_TIERSCEGID write FEMET_TIERSCEGID;
    property EMET_BASID_GINKOIA: integer read FEMET_BASID_GINKOIA write FEMET_BASID_GINKOIA;
    property EMET_TYPEREPLICATION: String read FEMET_TYPEREPLICATION write FEMET_TYPEREPLICATION;
    property EMET_NONREPLICATION: integer read FEMET_NONREPLICATION write FEMET_NONREPLICATION;
    property EMET_DEBUTNONREPLICATION: TDate read FEMET_DEBUTNONREPLICATION write FEMET_DEBUTNONREPLICATION;
    property EMET_FINNONREPLICATION: TDate read FEMET_FINNONREPLICATION write FEMET_FINNONREPLICATION;
    property EMET_SERVEURSECOURS: integer read FEMET_SERVEURSECOURS write FEMET_SERVEURSECOURS;
    property EMET_HEURE1: TDateTime read FEMET_HEURE1 write FEMET_HEURE1;
    property EMET_H1: integer read FEMET_H1 write FEMET_H1;
    property EMET_HEURE2: TDateTime read FEMET_HEURE2 write FEMET_HEURE2;
    property EMET_H2: integer read FEMET_H2 write FEMET_H2;
    property EMET_INFOSUP: String read FEMET_INFOSUP write FEMET_INFOSUP;
    property EMET_EMAIL: String read GetEMET_EMAIL write FEMET_EMAIL;

    property HDBM_ID: integer read FHDBM_ID write FHDBM_ID;
    property HDBM_CYCLE: TDateTime read FHDBM_CYCLE write FHDBM_CYCLE;
    property HDBM_OK: integer read FHDBM_OK write FHDBM_OK;
    property HDBM_COMMENTAIRE: String read FHDBM_COMMENTAIRE write FHDBM_COMMENTAIRE;
    property HDBM_ARCHIVER: integer read FHDBM_ARCHIVER write FHDBM_ARCHIVER;
    property HDBM_DATE: TDateTime read FHDBM_DATE write FHDBM_DATE;

    property RAIS_ID: integer read FRAIS_ID write FRAIS_ID;
    property RAIS_NOM: String read FRAIS_NOM write FRAIS_NOM;

    property RTR_PRMID_NBESSAI: integer read FRTR_PRMID_NBESSAI write FRTR_PRMID_NBESSAI;
    property RTR_NBESSAI: integer read FRTR_NBESSAI write FRTR_NBESSAI;
    property RTR_PRMID_DELAI: integer read FRTR_PRMID_DELAI write FRTR_PRMID_DELAI;
    property RTR_DELAI: integer read FRTR_DELAI write FRTR_DELAI;
    property RTR_PRMID_HEUREDEB: integer read FRTR_PRMID_HEUREDEB write FRTR_PRMID_HEUREDEB;
    property RTR_HEUREDEB: TDateTime read FRTR_HEUREDEB write FRTR_HEUREDEB;
    property RTR_PRMID_HEUREFIN: integer read FRTR_PRMID_HEUREFIN write FRTR_PRMID_HEUREFIN;
    property RTR_HEUREFIN: TDateTime read FRTR_HEUREFIN write FRTR_HEUREFIN;
    property RTR_PRMID_URL: integer read FRTR_PRMID_URL write FRTR_PRMID_URL;
    property RTR_URL: String read FRTR_URL write FRTR_URL;
    property RTR_PRMID_SENDER: integer read FRTR_PRMID_SENDER write FRTR_PRMID_SENDER;
    property RTR_SENDER: String read FRTR_SENDER write FRTR_SENDER;
    property RTR_PRMID_DATABASE: integer read FRTR_PRMID_DATABASE write FRTR_PRMID_DATABASE;
    property RTR_DATABASE: String read FRTR_DATABASE write FRTR_DATABASE;

    property RW_PRMID_HEUREDEB: integer read FRW_PRMID_HEUREDEB write FRW_PRMID_HEUREDEB;
    property RW_HEUREDEB: TDateTime read FRW_HEUREDEB write FRW_HEUREDEB;
    property RW_PRMID_HEUREFIN: integer read FRW_PRMID_HEUREFIN write FRW_PRMID_HEUREFIN;
    property RW_HEUREFIN: TDateTime read FRW_HEUREFIN write FRW_HEUREFIN;
    property RW_PRMID_INTERORDRE: integer read FRW_PRMID_INTERORDRE write FRW_PRMID_INTERORDRE;
    property RW_INTERVALLE: real read FRW_INTERVALLE write FRW_INTERVALLE;
    property RW_ORDRE: integer read FRW_ORDRE write FRW_ORDRE;
  End;

  TSociete = Class(TGnkSociete)
  private
    FDossier: TDossier;
    function GetMagasin(index: integer): TMagasin;
    function GetMagasinByID(AMAG_ID: integer): TMagasin;
  public
    procedure MAJ(Const AAction: TUpdateKind = ukModify); override;

    property Magasin[index: integer]: TMagasin read GetMagasin;
    property MagasinByID[AMAG_ID: integer]: TMagasin read GetMagasinByID;
    procedure AppendMag(Const AMag: TMagasin);
    procedure DeleteMag(Const AMag: TMagasin);

    property ADossier: TDossier read FDossier write FDossier;
  published
  End;

  TPoste = Class(TGnkPoste)
  private
    FPOST_PTYPID: integer;
    FPOST_DATEC: TDateTime;
    FPOST_DATEM: TDateTime;
    FPOST_ENABLE: integer;
    FPOST_MAGAID: integer;
    FMagasin: TMagasin;
  public
    procedure MAJ(Const AAction: TUpdateKind = ukModify); override;

    procedure SetValuesByDataSet(const ADS: TDataSet); override;

    property AMagasin: TMagasin read FMagasin write FMagasin;
  published

    property POST_PTYPID: integer read FPOST_PTYPID write FPOST_PTYPID;
    property POST_DATEC: TDateTime read FPOST_DATEC write FPOST_DATEC;
    property POST_DATEM: TDateTime read FPOST_DATEM write FPOST_DATEM;
    property POST_ENABLE: integer read FPOST_ENABLE write FPOST_ENABLE;
    property POST_MAGAID: integer read FPOST_MAGAID write FPOST_MAGAID;
  End;

  TGroupPump = Class(TGnkGroupPump)
  private
    FDossier: TDossier;
  public
    procedure MAJ(Const AAction: TUpdateKind = ukModify); override;

    property ADossier: TDossier read FDossier write FDossier;
  published
  End;

  THoraire = Class(TCustomGnk)
  private
    FPRH_HDEB: TDateTime;
    FPRH_DEFAUT: integer;
    FPRH_NOMPLAGE: String;
    FPRH_ID: integer;
    FPRH_HFIN: TDateTime;
    FPRH_NBREPLIC: integer;
    FPRH_SRVID: integer;
  public
    procedure MAJ(Const AAction: TUpdateKind = ukModify); override;

    procedure SetValuesByDataSet(const ADS: TDataSet);
  published
    property PRH_ID: integer read FPRH_ID write FPRH_ID;
    property PRH_NOMPLAGE: String read FPRH_NOMPLAGE write FPRH_NOMPLAGE;
    property PRH_HDEB: TDateTime read FPRH_HDEB write FPRH_HDEB;
    property PRH_HFIN: TDateTime read FPRH_HFIN write FPRH_HFIN;
    property PRH_NBREPLIC: integer read FPRH_NBREPLIC write FPRH_NBREPLIC;
    property PRH_DEFAUT: integer read FPRH_DEFAUT write FPRH_DEFAUT;
    property PRH_SRVID: integer read FPRH_SRVID write FPRH_SRVID;
  End;

  TConnexion = Class(TGnkConnexion)
  private
    FDOSS_ID: integer;
    FEMET_ID: integer;
    FEmetteur: TEmetteur;
    function GetDOSS_ID: integer;
    function GetEMET_ID: integer;
  protected
    function GetCON_LAUID: integer; override;
  public
    procedure MAJ(Const AAction: TUpdateKind = ukModify); override;

    procedure SetValuesByDataSet(const ADS: TDataSet; const ADOSSID: integer; const AEMET_ID: integer); overload;

    property AEmetteur: TEmetteur read FEmetteur write FEmetteur;
  published
    property DOSS_ID: integer read GetDOSS_ID write FDOSS_ID;
    property EMET_ID: integer read GetEMET_ID write FEMET_ID;
  End;

implementation

uses dmdMaintenance, uVar, uTool_XE7;

{ TMagasin }

procedure TMagasin.AppendMdl(const AMdl: TModule);
begin
  if ModuleByID[AMdl.MODU_ID] = nil then
    FListModule.Add(AMdl);
end;

procedure TMagasin.AppendPoste(const APoste: TPoste);
begin
  AppendPosteGnk(TGnkPoste(APoste));
end;

procedure TMagasin.DeleteMdl(const AMdl: TModule);
begin
  FListModule.Extract(AMdl);
end;

procedure TMagasin.DeletePoste(const APoste: TPoste);
begin
  DeletePosteGnk(TGnkPoste(APoste));
end;

function TMagasin.GetMAGA_DOSSID: integer;
begin
  Result := FMAGA_DOSSID;
  if FDossier <> nil then
    Result := FDossier.DOSS_ID;
end;

function TMagasin.GetModule(index: integer): TModule;
begin
  Result := TModule(FListModule.Items[index]);
end;

function TMagasin.GetModuleByID(AMOD_ID: integer): TModule;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to FListModule.Count - 1 do
  begin
    if Module[i].MODU_ID = AMOD_ID then
    begin
      Result := Module[i];
      Break;
    end;
  end;
end;

function TMagasin.GetModuleByNOM(AMOD_NOM: String): TModule;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to FListModule.Count - 1 do
  begin
    if Module[i].MODU_NOM = AMOD_NOM then
    begin
      Result := Module[i];
      Break;
    end;
  end;
end;

function TMagasin.GetPoste(index: integer): TPoste;
begin
  Result := TPoste(PosteGnk[index]);
end;

function TMagasin.GetPosteByID(APOST_POSID: integer): TPoste;
begin
  Result := TPoste(PosteGnkByID[APOST_POSID]);
end;

procedure TMagasin.MAJ(Const AAction: TUpdateKind);
var
  vQry, vQryGINKOIA: TFDQuery;
  VersionInt: integer;
  test: string;

  { Gestion du siege sociale }
  procedure SetMAG_SS;
  begin
    if MAG_SS = 1 then
    begin
      FAdmGINKOIA.UpdateK(MAGA_MAGID_GINKOIA, 0);
      vQryGINKOIA.SQL.Text := 'update genmagasin set MAG_SS=0 Where MAG_SOCID=:PMAG_SOCID and MAG_ID <> :PMAG_ID';
      vQryGINKOIA.ParamByName('PMAG_SOCID').AsInteger := MAG_SOCID;
      vQryGINKOIA.ParamByName('PMAG_ID').AsInteger := MAGA_MAGID_GINKOIA;
      vQryGINKOIA.ExecSQL;
      if ASociete <> nil then
      begin
        ASociete.SOC_SSID := MAGA_MAGID_GINKOIA;
        ASociete.MAJ(AAction);
      end;
    end;
  end;

{ Création d'un groupe de Pump }
  procedure GestionGroupPump;
  begin
    vQryGINKOIA.SQL.Clear;
    vQryGINKOIA.SQL.Text := 'select GCP_ID, K_ENABLED from gengestionpump join k on k_id = GCP_id where GCP_ID <> 0 AND GCP_NOM=:PGCPNOM';
    vQryGINKOIA.ParamByName('PGCPNOM').AsString := 'GROUPE ' + MAGA_ENSEIGNE;
    vQryGINKOIA.Open;
    if vQryGINKOIA.Eof then // Verrification qu'il n'éxiste pas
    begin
      MPU_GCPID := FAdmGINKOIA.GetNewID('gengestionpump'); // On le créer
      vQryGINKOIA.SQL.Clear;
      vQryGINKOIA.SQL.Text := cSql_I_gengestionpump;

      vQryGINKOIA.ParamByName('PGCPID').AsInteger := MPU_GCPID;
      vQryGINKOIA.ParamByName('PGCPNOM').AsString := 'GROUPE ' + MAGA_ENSEIGNE;
      vQryGINKOIA.ExecSQL;
    end
    else
    begin
      if vQryGINKOIA.FieldByName('K_ENABLED').AsInteger = 0 then // Verrification qu'il ne soit pas désactivé
      begin
        MPU_GCPID := vQryGINKOIA.FieldByName('GCP_ID').AsInteger;
        FAdmGINKOIA.UpdateK(MPU_GCPID, 2);
      end
      else
        MPU_GCPID := vQryGINKOIA.FieldByName('GCP_ID').AsInteger;
    end;
  end;

{ Gestion du lien Groupe de Pump / Magasin }
  procedure GestionLienPumpMag;
  begin
    vQryGINKOIA.SQL.Clear;
    vQryGINKOIA.SQL.Text := 'select MPU_ID, K_ENABLED from genmaggestionpump join k on k_id = MPU_ID where MPU_ID <> 0 AND MPU_MAGID=:PMPUMAGID';
    vQryGINKOIA.ParamByName('PMPUMAGID').AsInteger := MAGA_MAGID_GINKOIA;
    vQryGINKOIA.Open;
    if vQryGINKOIA.Eof then // Verrification que le lien n'éxiste pas
    begin
      MPU_ID := FAdmGINKOIA.GetNewID('genmaggestionpump'); // On le créer
      vQryGINKOIA.SQL.Clear;
      vQryGINKOIA.SQL.Text := cSql_I_genmaggestionpump;

      vQryGINKOIA.ParamByName('PMPUID').AsInteger := MPU_ID;
      vQryGINKOIA.ParamByName('PMPUMAGID').AsInteger := MAGA_MAGID_GINKOIA;
      vQryGINKOIA.ParamByName('PMPUGCPID').AsInteger := MPU_GCPID;
      vQryGINKOIA.ExecSQL;
    end
    else
    begin
      if vQryGINKOIA.FieldByName('K_ENABLED').AsInteger = 0 then // Verrification qu'il ne soit pas désactivé
      begin
        MPU_ID := vQryGINKOIA.FieldByName('MPU_ID').AsInteger;
        FAdmGINKOIA.UpdateK(MPU_ID, 2);
      end
      else
      begin
        MPU_ID := vQryGINKOIA.FieldByName('MPU_ID').AsInteger;
        FAdmGINKOIA.UpdateK(MPU_ID, 0);
      end;

      vQryGINKOIA.SQL.Clear;
      vQryGINKOIA.SQL.Text := cSql_U_genmaggestionpump;

      vQryGINKOIA.ParamByName('PGCPID').AsInteger := MPU_GCPID;
      vQryGINKOIA.ParamByName('PMPUID').AsInteger := MPU_ID;
      vQryGINKOIA.ParamByName('PMPUMAGID').AsInteger := MAGA_MAGID_GINKOIA;
      vQryGINKOIA.ExecSQL;
    end;
  end;

begin
  inherited;
  try
    if not IsExcludeGnkMAJ then
    begin
      if FAdmGINKOIA = nil then
        FAdmGINKOIA := ConnectToGINKOIA(ADossier.DOSS_CHEMIN);
      vQryGINKOIA := FAdmGINKOIA.GetNewQry;
    end;

    vQry := dmMaintenance.GetNewQry;
    try
      if not dmMaintenance.Transaction.Active then
        dmMaintenance.Transaction.StartTransaction;

      if not IsExcludeGnkMAJ then
      begin
        if not FAdmGINKOIA.Transaction.Active then
          FAdmGINKOIA.Transaction.StartTransaction;
      end;

      if MPU_GCPID = -2 then
        CreateGrpPump := True;

      // on vérifie si on est en version > à 16 pour savoir si on met à jour le champ mag_basid ou pas
      VersionInt := dmMaintenance.VersionStringToInt(ADossier.VERS_VERSION);

      case AAction of
        ukModify:
          begin
            if not IsExcludeGnkMAJ then
            begin
              SetMAG_SS;

              if MAGA_K_ENABLED = 0 then
                FAdmGINKOIA.UpdateK(MAGA_MAGID_GINKOIA, 1)
              else
                FAdmGINKOIA.UpdateK(MAGA_MAGID_GINKOIA, 0);

              if VersionInt >= 16 then
                vQryGINKOIA.SQL.Text := cSql_U_genmagasin_after_V16
              else
                vQryGINKOIA.SQL.Text := cSql_U_genmagasin;

              vQryGINKOIA.ParamByName('PMAG_NOM').AsString := MAGA_NOM;
              vQryGINKOIA.ParamByName('PMAG_ENSEIGNE').AsString := MAGA_ENSEIGNE;
              vQryGINKOIA.ParamByName('PMAG_IDENT').AsString := MAG_IDENT;
              vQryGINKOIA.ParamByName('PMAG_NATURE').AsInteger := MAG_NATURE;
              vQryGINKOIA.ParamByName('PMAG_SS').AsInteger := MAG_SS;
              vQryGINKOIA.ParamByName('PMAG_ID').AsInteger := MAGA_MAGID_GINKOIA;
              vQryGINKOIA.ParamByName('PMAG_CODEADH').AsString := MAGA_CODEADH;

              // on vérifie si on est en version > à 16 pour savoir si on met à jour le champ mag_basid ou pas
              if VersionInt >= 16 then
                vQryGINKOIA.ParamByName('PMAG_BASID').AsInteger := MAGA_BASID;

              vQryGINKOIA.ExecSQL;

              if CreateGrpPump then // Si on doit créer le Groupe de Pump
              begin
                GestionGroupPump;
              end;

              GestionLienPumpMag;
            end;

            vQry.SQL.Text := cSql_U_magasins;

            vQry.ParamByName('PMAGANOM').AsString := MAGA_NOM;
            vQry.ParamByName('PMAGAENSEIGNE').AsString := MAGA_ENSEIGNE;
            vQry.ParamByName('PMAGACODEADH').AsString := MAGA_CODEADH;
            vQry.ParamByName('PMAGAMAGIDGINKOIA').AsInteger := MAGA_MAGID_GINKOIA;
            vQry.ParamByName('PMAGADOSSID').AsInteger := MAGA_DOSSID;
            vQry.ParamByName('PMAGAID').AsInteger := MAGA_ID;
            vQry.ParamByName('PMAGAKENABLED').AsInteger := MAGA_K_ENABLED;
            vQry.ParamByName('PMAGABASID').AsInteger := MAGA_BASID;

            vQry.ExecSQL;

            if not IsExcludeGnkMAJ then
            begin
              { Initialisation du magasin }
              FAdmGINKOIA.STP_INITIALISEMAG.ParamByName('MAGID').AsInteger := MAGA_MAGID_GINKOIA;
              FAdmGINKOIA.STP_INITIALISEMAG.ExecProc;
            end;
          end;
        ukInsert:
          begin
            if not IsExcludeGnkMAJ then
            begin
              SetMAG_SS;

              MAGA_MAGID_GINKOIA := FAdmGINKOIA.GetNewID('genmagasin');

              if VersionInt >= 16 then
                vQryGINKOIA.SQL.Text := cSql_I_genmagasin_after_V16
              else
                vQryGINKOIA.SQL.Text := cSql_I_genmagasin;

              vQryGINKOIA.ParamByName('PMAG_NOM').AsString := MAGA_NOM;
              vQryGINKOIA.ParamByName('PMAG_ID_GINKOIA').AsInteger := MAGA_MAGID_GINKOIA;
              vQryGINKOIA.ParamByName('PMAG_SOCID').AsInteger := MAG_SOCID;
              vQryGINKOIA.ParamByName('PMAG_ENSEIGNE').AsString := MAGA_ENSEIGNE;
              vQryGINKOIA.ParamByName('PMAG_IDENT').AsString := MAG_IDENT;
              vQryGINKOIA.ParamByName('PMAG_NATURE').AsInteger := MAG_NATURE;
              vQryGINKOIA.ParamByName('PMAG_SS').AsInteger := MAG_SS;
              vQryGINKOIA.ParamByName('PMAG_CODEADH').AsString := MAGA_CODEADH;

              // on vérifie si on est en version > à 16 pour savoir si on met à jour le champ mag_basid ou pas
              if VersionInt >= 16 then
                vQryGINKOIA.ParamByName('PMAG_BASID').AsInteger := MAGA_BASID;

              vQryGINKOIA.ExecSQL;

              MAGA_K_ENABLED := 1; // SR - 10/05/2017 - On vient de créer le magasin il est donc actif

              if CreateGrpPump then // Si on doit créer le Groupe de Pump
              begin
                GestionGroupPump;
              end;

              GestionLienPumpMag;
            end;

            MAGA_ID := dmMaintenance.GetNewID('magasins');

            vQry.SQL.Text := cSql_I_magasins;

            vQry.ParamByName('PMAGANOM').AsString := MAGA_NOM;
            vQry.ParamByName('PMAGAENSEIGNE').AsString := MAGA_ENSEIGNE;
            vQry.ParamByName('PMAGACODEADH').AsString := MAGA_CODEADH;
            vQry.ParamByName('PMAGAMAGIDGINKOIA').AsInteger := MAGA_MAGID_GINKOIA;
            vQry.ParamByName('PMAGADOSSID').AsInteger := MAGA_DOSSID;
            vQry.ParamByName('PMAGAID').AsInteger := MAGA_ID;
            vQry.ParamByName('PMAGAKENABLED').AsInteger := MAGA_K_ENABLED;
            vQry.ParamByName('PMAGABASID').AsInteger := MAGA_BASID;
            vQry.ExecSQL;

            if not IsExcludeGnkMAJ then
            begin
              { Initialisation du magasin }
              FAdmGINKOIA.STP_INITIALISEMAG.ParamByName('MAGID').AsInteger := MAGA_MAGID_GINKOIA;
              FAdmGINKOIA.STP_INITIALISEMAG.ExecProc;
            end;
          end;
        ukDelete:
          begin
            // -->
          end;
      end;
      dmMaintenance.Transaction.Commit;
      if not IsExcludeGnkMAJ then
      begin
        FAdmGINKOIA.Transaction.Commit;
      end;
    except
      on E: Exception do
      begin
        if not IsExcludeGnkMAJ then
        begin
          FAdmGINKOIA.Transaction.Rollback;
        end;
        dmMaintenance.Transaction.Rollback;
        Raise Exception.Create(ClassName + '.MAJ ' + UpdateKindToStr(AAction) + cRC + E.Message);
      end;
    end;
  finally
    FreeAndNil(vQry);
    if not IsExcludeGnkMAJ then
    begin
      FreeAndNil(vQryGINKOIA);
    end;
    FreeAndNil(FAdmGINKOIA);
  end;
end;

procedure TMagasin.SetValuesByDataSet(const ADS: TDataSet);
var
  vField: TField;
begin
  inherited;
  vField := ADS.FindField('MAGA_DOSSID');
  if vField <> nil then
    MAGA_DOSSID := vField.AsInteger;

  vField := ADS.FindField('MAGA_MAGID_GINKOIA');
  if vField <> nil then
    MAGA_MAGID_GINKOIA := vField.AsInteger;
end;

{ TDossier }

procedure TDossier.AppendGroupPump(const AGrp: TGroupPump);
begin
  if GroupPumpByID[AGrp.GCP_ID] = nil then
    FListGroupPump.Add(AGrp);
end;

procedure TDossier.AppendMag(const AMag: TMagasin);
begin
  if MagasinByID[AMag.MAGA_ID] = nil then
    FListMag.Add(AMag);
end;

procedure TDossier.AppendSociete(const ASoc: TSociete);
begin
  if SocieteByID[ASoc.SOC_ID] = nil then
    FListSociete.Add(ASoc);
end;

procedure TDossier.AppendEmetteur(const AEmet: TEmetteur);
begin
  if EmetteurByID[AEmet.EMET_ID] = nil then
    FListEmetteur.Add(AEmet);
end;

constructor TDossier.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FListMag := TObjectList.Create(False);
  FListEmetteur := TObjectList.Create(True);
  FListSociete := TObjectList.Create(True);
  FListGroupPump := TObjectList.Create(True);

  // initialisation Jeton
  FBJETON := False;
  FTokenManager := nil;
end;

procedure TDossier.DeleteMag(const AMag: TMagasin);
begin
  FListMag.Extract(AMag);
end;

procedure TDossier.DeleteSociete(const ASoc: TSociete);
begin
  FListSociete.Remove(ASoc);
end;

procedure TDossier.DeleteEmetteur(const AEmet: TEmetteur);
begin
  FListMag.Remove(AEmet);
end;

procedure TDossier.DeleteGroupPump(const AGrp: TGroupPump);
begin
  FListGroupPump.Remove(AGrp);
end;

destructor TDossier.Destroy;
begin
  FreeAndNil(FListMag);
  FreeAndNil(FListEmetteur);
  FreeAndNil(FListSociete);
  FreeAndNil(FListGroupPump);
  inherited Destroy;
end;

function TDossier.GetCountMag: integer;
begin
  Result := FListMag.Count;
end;

function TDossier.GetCountSociete: integer;
begin
  Result := FListSociete.Count;
end;

function TDossier.GetCountEmetteur: integer;
begin
  Result := FListEmetteur.Count;
end;

function TDossier.GetCountGroupPump: integer;
begin
  Result := FListGroupPump.Count;
end;

function TDossier.GetGroupPump(index: integer): TGroupPump;
begin
  Result := TGroupPump(FListGroupPump.Items[index]);
end;

function TDossier.GetGroupPumpByID(AGCP_ID: integer): TGroupPump;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to FListGroupPump.Count - 1 do
  begin
    if GroupPump[i].GCP_ID = AGCP_ID then
    begin
      Result := GroupPump[i];
      Break;
    end;
  end;
end;

function TDossier.GetDOSS_GROUID: integer;
begin
  Result := FDOSS_GROUID;
  if FGroupe <> nil then
    Result := FGroupe.GROU_ID;
end;

function TDossier.GetGROU_NOM: String;
begin
  Result := FGROU_NOM;
  if FGroupe <> nil then
    Result := FGroupe.GROU_NOM;
end;

function TDossier.GetMagasin(index: integer): TMagasin;
begin
  Result := TMagasin(FListMag.Items[index]);
end;

function TDossier.GetMagasinByID(AMAGA_ID: integer): TMagasin;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to FListMag.Count - 1 do
  begin
    if Magasin[i].MAGA_ID = AMAGA_ID then
    begin
      Result := Magasin[i];
      Break;
    end;
  end;
end;

function TDossier.GetMagasinByIDGINKOIA(AMAG_ID_GINKOIA: integer): TMagasin;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to FListMag.Count - 1 do
  begin
    if Magasin[i].MAGA_MAGID_GINKOIA = AMAG_ID_GINKOIA then
    begin
      Result := Magasin[i];
      Break;
    end;
  end;
end;

function TDossier.GetNewGUID: String;
var
  vEmet: TEmetteur;
begin
  Result := CreateClassID;
  vEmet := EmetteurByGUID[Result];
  while vEmet <> nil do
  begin
    vEmet := EmetteurByGUID[Result];
    if vEmet <> nil then
      Result := CreateClassID;
  end;
end;

function TDossier.GetNewIdent(const AdmGINKOIA: TdmGINKOIA): String;
var
  vCpt: integer;
  vQryGINKOIA: TFDQuery;
begin
  Result := '';
  vCpt := 0;
  try
    try
      vQryGINKOIA := AdmGINKOIA.GetNewQry;
      vQryGINKOIA.SQL.Text := 'select * from genbases where BAS_IDENT <> ''''';
      vQryGINKOIA.Open;
      while not vQryGINKOIA.Eof do
      begin
        if vQryGINKOIA.FieldByName('BAS_IDENT').AsInteger > vCpt then
          vCpt := vQryGINKOIA.FieldByName('BAS_IDENT').AsInteger;
        vQryGINKOIA.Next;
      end;

      Result := IntToStr(vCpt + 1);
    except
      Raise;
    end;
  finally
    FreeAndNil(vQryGINKOIA);
  end;
end;

function TDossier.GetNewPlage(Const AdmGINKOIA: TdmGINKOIA; AListPlage: TStringList): String;
var
  i, vPlgDeb, vPlgFin: integer;
  vQryGINKOIA: TFDQuery;
  vSL: TStringList;
  vListPlage: array of array [0 .. 1] of integer;
  vPlageEmpty: Boolean;

  procedure SetOrdre;
  var
    i, j, vVal, vValNext, vSubVal, vSubValNext: integer;
  begin
    for i := High(vListPlage) downto Low(vListPlage) do
    begin
      for j := 0 to i - 1 do
      begin
        vVal := vListPlage[j][0];
        vValNext := vListPlage[j + 1][0];
        vSubVal := vListPlage[j][1];
        vSubValNext := vListPlage[j + 1][1];
        if vVal > vValNext then
        begin
          vListPlage[j][0] := vValNext;
          vListPlage[j][1] := vSubValNext;
          vListPlage[j + 1][0] := vVal;
          vListPlage[j + 1][1] := vSubVal;
        end;
      end;
    end;
  end;

begin
  Result := '';
  SetLength(vListPlage, 0);
  if AListPlage = nil then
    Exit;
  vSL := TStringList.Create;
  try
    try
      vQryGINKOIA := AdmGINKOIA.GetNewQry;
      vQryGINKOIA.SQL.Text := 'select BAS_PLAGE from genbases where BAS_ID <> 0';
      vQryGINKOIA.Open;

      { Chargement des plages dans un tableau }
      while not vQryGINKOIA.Eof do
      begin
        SetLength(vListPlage, Length(vListPlage) + 1);
        PlageToSL(vQryGINKOIA.FieldByName('BAS_PLAGE').AsString, vSL);
        vListPlage[High(vListPlage)][0] := StrToInt(vSL.Strings[0]);
        vListPlage[High(vListPlage)][1] := StrToInt(vSL.Strings[1]);
        vQryGINKOIA.Next;
      end;

      { Chargement des plages dans un tableau depuis la Stringlist }
      for i := 0 to AListPlage.Count - 1 do
      begin
        SetLength(vListPlage, Length(vListPlage) + 1);
        PlageToSL(AListPlage.Strings[i], vSL);
        vListPlage[High(vListPlage)][0] := StrToInt(vSL.Strings[0]);
        vListPlage[High(vListPlage)][1] := StrToInt(vSL.Strings[1]);
      end;

      { On trie le tableau en SPLI_ORDRE croissant }
      SetOrdre;

      { On cherche si il y a une plage libre }
      vPlgDeb := 1;
      vPlgFin := 1;
      vPlageEmpty := False;
      for i := 1 to High(vListPlage) do
      begin
        vPlgDeb := vListPlage[i][0];
        vPlgFin := vListPlage[i][1];
        if (vPlgDeb - vListPlage[i - 1][1]) >= cIntervalPlage then
        begin
          vPlgDeb := vListPlage[i - 1][1];
          vPlgFin := vPlgDeb + cIntervalPlage;
          vPlageEmpty := True;
          Break;
        end;
      end;

      { Si il n'y pas de plage libre, on ajoute une plage }
      if not vPlageEmpty then
      begin
        vPlgDeb := vPlgFin;
        if vPlgDeb = 1 then // Si c'est la première plage on fait [1-50]
          vPlgFin := 50
        else // Sinon on fait [vPlgDeb-(vPlgDeb+cIntervalPlage]
          vPlgFin := vPlgDeb + cIntervalPlage;
      end;

      Result := Format(cPlage, [IntToStr(vPlgDeb), IntToStr(vPlgFin)]);
      AListPlage.Append(Result);

      { Si la plage existe, on redemande une nouvelle plage (principe de récursivité) }
      if IsPlageExist(AdmGINKOIA, Result) then
        Result := GetNewPlage(AdmGINKOIA, AListPlage);
    except
      Raise;
    end;
  finally
    Finalize(vListPlage);
    FreeAndNil(vSL);
    FreeAndNil(vQryGINKOIA);
  end;
end;

function TDossier.GetEmetteur(index: integer): TEmetteur;
begin
  Result := TEmetteur(FListEmetteur.Items[index]);
end;

function TDossier.GetEmetteurByGUID(AEMET_GUID: String): TEmetteur;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to FListEmetteur.Count - 1 do
  begin
    if Emetteur[i].EMET_GUID = AEMET_GUID then
    begin
      Result := Emetteur[i];
      Break;
    end;
  end;
end;

function TDossier.GetEmetteurByIDENT(AEMET_IDENT: String): TEmetteur;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to FListEmetteur.Count - 1 do
  begin
    if Emetteur[i].EMET_IDENT = AEMET_IDENT then
    begin
      Result := Emetteur[i];
      Break;
    end;
  end;
end;

function TDossier.GetEmetteurByID(AEMET_ID: integer): TEmetteur;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to FListEmetteur.Count - 1 do
  begin
    if Emetteur[i].EMET_ID = AEMET_ID then
    begin
      Result := Emetteur[i];
      Break;
    end;
  end;
end;

function TDossier.GetSociete(index: integer): TSociete;
begin
  Result := TSociete(FListSociete.Items[index]);
end;

function TDossier.GetSocieteByID(ASOC_ID: integer): TSociete;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to FListSociete.Count - 1 do
  begin
    if Societe[i].SOC_ID = ASOC_ID then
    begin
      Result := Societe[i];
      Break;
    end;
  end;
end;

function TDossier.GetDOSS_SERVID: integer;
begin
  Result := FDOSS_SERVID;
  if FServeur <> nil then
    Result := FServeur.SERV_ID;
end;

function TDossier.GetSERV_IP: String;
begin
  Result := FSERV_IP;
  if FServeur <> nil then
    Result := FServeur.SERV_IP;
end;

function TDossier.GetSERV_NOM_ID: String;
begin
  Result := FSERV_NOM;
  if FServeur <> nil then
    Result := FServeur.SERV_NOM;
end;

function TDossier.GetSERV_PASSWORD: String;
begin
  Result := FSERV_PASSWORD;
  if FServeur <> nil then
    Result := FServeur.SERV_PASSWORD;
end;

function TDossier.GetSERV_LOCALIP: String;
begin
  Result := FSERV_LOCALIP;
  if FServeur <> nil then
    Result := FServeur.SERV_LOCALIP;
end;

function TDossier.GetSERV_USER: String;
begin
  Result := FSERV_USER;
  if FServeur <> nil then
    Result := FServeur.SERV_USER;
end;

function TDossier.GetVERS_ID: integer;
begin
  Result := FVERS_ID;
  if FVersion <> nil then
    Result := FVersion.VERS_ID;
end;

function TDossier.GetVERS_VERSION: String;
begin
  Result := FVERS_VERSION;
  if FVersion <> nil then
    Result := FVersion.VERS_VERSION;
end;

function TDossier.IsPlageExist(const AdmGINKOIA: TdmGINKOIA; const APlage: String): Boolean;
var
  vQryGINKOIA: TFDQuery;
  vSL: TStringList;
begin
  Result := False;
  vSL := TStringList.Create;
  try
    try
      PlageToSL(APlage, vSL);

      vQryGINKOIA := AdmGINKOIA.GetNewQry;
      vQryGINKOIA.SQL.Text := 'select k_id from k where k_id between ' + vSL.Strings[0] + '000000 and ' + vSL.Strings[1] + '000000';
      vQryGINKOIA.Open;

      Result := not vQryGINKOIA.Eof;
    except
      Raise;
    end;
  finally
    FreeAndNil(vSL);
    FreeAndNil(vQryGINKOIA);
  end;
end;

procedure TDossier.MAJ(Const AAction: TUpdateKind);
var
  vQry: TFDQuery;
begin
  inherited;
  try
    vQry := dmMaintenance.GetNewQry;
    try
      if not dmMaintenance.Transaction.Active then
        dmMaintenance.Transaction.StartTransaction;
      case AAction of
        ukModify:
          begin
            vQry.SQL.Text := cSql_U_Dossier;
          end;
        ukInsert:
          begin
            DOSS_ID := dmMaintenance.GetNewID('dossier');
            vQry.SQL.Text := cSql_I_Dossier;
          end;
        ukDelete:
          begin
            vQry.SQL.Text := 'DELETE FROM MOBILITE_ABONNEMENTS WHERE MABO_MACCID in (SELECT MACC_ID FROM MOBILITE_ACCES WHERE MACC_DOSSID=:PDOSSID)';
            vQry.ParamByName('PDOSSID').AsInteger := DOSS_ID;
            vQry.ExecSQL;

            vQry.SQL.Text := 'DELETE FROM MOBILITE_ACCES WHERE MACC_DOSSID=:PDOSSID';
            vQry.ParamByName('PDOSSID').AsInteger := DOSS_ID;
            vQry.ExecSQL;

            vQry.SQL.Text := 'DELETE FROM SPLITTAGE_LOG WHERE SPLI_EMETID in (SELECT EMET_ID FROM EMETTEUR WHERE EMET_DOSSID=:PDOSSID)';
            vQry.ParamByName('PDOSSID').AsInteger := DOSS_ID;
            vQry.ExecSQL;

            vQry.SQL.Text := 'DELETE FROM POSTES WHERE POST_MAGAID in (SELECT MAGA_ID FROM MAGASINS WHERE MAGA_DOSSID=:PDOSSID)';
            vQry.ParamByName('PDOSSID').AsInteger := DOSS_ID;
            vQry.ExecSQL;

            vQry.SQL.Text := 'DELETE FROM MODULES_MAGASINS WHERE MMAG_MAGAID in (SELECT MAGA_ID FROM MAGASINS WHERE MAGA_DOSSID=:PDOSSID)';
            vQry.ParamByName('PDOSSID').AsInteger := DOSS_ID;
            vQry.ExecSQL;

            vQry.SQL.Text := 'DELETE FROM MAGASINS WHERE MAGA_DOSSID=:PDOSSID';
            vQry.ParamByName('PDOSSID').AsInteger := DOSS_ID;
            vQry.ExecSQL;

            vQry.SQL.Text := 'DELETE FROM DEPENDANCE_DOSSIER WHERE DEPE_DOSSID=:PDOSSID';
            vQry.ParamByName('PDOSSID').AsInteger := DOSS_ID;
            vQry.ExecSQL;

            vQry.SQL.Text := 'DELETE FROM SPECIFIQUE WHERE SPEC_EMETID in (SELECT EMET_ID FROM EMETTEUR WHERE EMET_DOSSID=:PDOSSID)';
            vQry.ParamByName('PDOSSID').AsInteger := DOSS_ID;
            vQry.ExecSQL;

            vQry.SQL.Text := 'DELETE FROM HISTO WHERE HIST_EMETID in (SELECT EMET_ID FROM EMETTEUR WHERE EMET_DOSSID=:PDOSSID)';
            vQry.ParamByName('PDOSSID').AsInteger := DOSS_ID;
            vQry.ExecSQL;

            vQry.SQL.Text := 'DELETE FROM PLAGEMAJ WHERE PLAG_EMETID in (SELECT EMET_ID FROM EMETTEUR WHERE EMET_DOSSID=:PDOSSID)';
            vQry.ParamByName('PDOSSID').AsInteger := DOSS_ID;
            vQry.ExecSQL;

            vQry.SQL.Text := 'DELETE FROM HDB_MONITOR WHERE HDBM_EMETID in (SELECT EMET_ID FROM EMETTEUR WHERE EMET_DOSSID=:PDOSSID)';
            vQry.ParamByName('PDOSSID').AsInteger := DOSS_ID;
            vQry.ExecSQL;

            vQry.SQL.Text := 'DELETE FROM EMETTEUR WHERE EMET_DOSSID=:PDOSSID';
            vQry.ParamByName('PDOSSID').AsInteger := DOSS_ID;
            vQry.ExecSQL;

            vQry.SQL.Text := 'DELETE FROM DOSSIER WHERE DOSS_ID=:PDOSSID';
            vQry.ParamByName('PDOSSID').AsInteger := DOSS_ID;
            vQry.ExecSQL;
          end;
      end;

      if AAction in [ukModify, ukInsert] then
      begin
        vQry.ParamByName('PDOSSID').AsInteger := DOSS_ID;
        vQry.ParamByName('PDOSSDATABASE').AsString := DOSS_DATABASE;
        vQry.ParamByName('PDOSSSERVID').AsInteger := DOSS_SERVID;
        vQry.ParamByName('PDOSSCHEMIN').AsString := DOSS_CHEMIN;
        vQry.ParamByName('PDOSSGROUID').AsInteger := DOSS_GROUID;
        vQry.ParamByName('PDOSSINSTALL').AsDateTime := DOSS_INSTALL;
        vQry.ParamByName('PDOSSVIP').AsInteger := DOSS_VIP;
        vQry.ParamByName('PDOSSPLATEFORME').AsString := DOSS_PLATEFORME;
        vQry.ParamByName('PDOSSEMAIL').AsString := DOSS_EMAIL;
        vQry.ParamByName('PDOSSACTIF').AsInteger := DOSS_ACTIF;
        vQry.ParamByName('PDOSSRECALTEMPS').AsInteger := DOSS_RECALTEMPS;
        vQry.ParamByName('PDOSSRECALLASTDATE').AsDateTime := DOSS_RECALLASTDATE;
        vQry.ParamByName('PDOSSEASY').AsInteger := DOSS_EASY;
        vQry.ExecSQL;
      end;

      dmMaintenance.Transaction.Commit;
    except
      on E: Exception do
      begin
        dmMaintenance.Transaction.Rollback;
        Raise Exception.Create(ClassName + '.MAJ ' + UpdateKindToStr(AAction) + cRC + E.Message);
      end;
    end;
  finally
    FreeAndNil(vQry);
  end;
end;

procedure TDossier.PlageToSL(const S: String; const ASL: TStringList);
var
  i: integer;
begin
  ASL.Text := StringReplace(S, '_', #13#10, []);
  for i := 0 to ASL.Count - 1 do
  begin
    ASL.Strings[i] := StringReplace(ASL.Strings[i], '[', '', [rfReplaceAll]);
    ASL.Strings[i] := StringReplace(ASL.Strings[i], ']', '', [rfReplaceAll]);
    ASL.Strings[i] := StringReplace(ASL.Strings[i], 'M', '', [rfReplaceAll]);
  end;
end;

procedure TDossier.SetValuesByDataSet(const ADS: TDataSet);
var
  vField: TField;
begin
  inherited;
  vField := ADS.FindField('DOSS_ID');
  if vField <> nil then
    DOSS_ID := vField.AsInteger;

  vField := ADS.FindField('DOSS_DATABASE');
  if vField <> nil then
    DOSS_DATABASE := vField.AsString;

  vField := ADS.FindField('DOSS_CHEMIN');
  if vField <> nil then
    DOSS_CHEMIN := vField.AsString;

  vField := ADS.FindField('DOSS_INSTALL');
  if vField <> nil then
    DOSS_INSTALL := vField.AsDateTime;

  vField := ADS.FindField('DOSS_VIP');
  if vField <> nil then
    DOSS_VIP := vField.AsInteger;

  vField := ADS.FindField('DOSS_PLATEFORME');
  if vField <> nil then
    DOSS_PLATEFORME := vField.AsString;

  vField := ADS.FindField('DOSS_EMAIL');
  if vField <> nil then
    DOSS_EMAIL := vField.AsString;

  vField := ADS.FindField('DOSS_ACTIF');
  if vField <> nil then
    DOSS_ACTIF := vField.AsInteger;

  vField := ADS.FindField('DOSS_RECALTEMPS');
  if vField <> nil then
    DOSS_RECALTEMPS := vField.AsInteger;

  vField := ADS.FindField('DOSS_RECALLASTDATE');
  if vField <> nil then
    DOSS_RECALLASTDATE := vField.AsDateTime;

  vField := ADS.FindField('DOSS_EASY');
  if vField <> nil then
    DOSS_EASY := vField.AsInteger;

end;

{ TEmetteur }

procedure TEmetteur.AppendConnexion(const ACon: TConnexion);
begin
  AppendConnexionGnk(TGnkConnexion(ACon));
end;

procedure TEmetteur.DeleteConnexion(const ACon: TConnexion);
begin
  DeleteConnexionGnk(TConnexion(ACon));
end;

// function TEmetteur.GetBAS_NOM: String; //--> Deprecated 24/07/2013 Greg
// begin
// inherited GetBAS_NOM;
// Result:= FEMET_NOM;
// end;

function TEmetteur.GetConnexion(index: integer): TConnexion;
begin
  Result := TConnexion(ConnexionGnk[index]);
end;

function TEmetteur.GetConnexionByID(ACON_ID: integer): TConnexion;
begin
  Result := TConnexion(ConnexionGnkByID[ACON_ID]);
end;

function TEmetteur.GetEMET_EMAIL: String;
begin
  Result := FEMET_EMAIL;
  if (FDossier <> nil) and (Trim(Result) = '') then
    Result := FDossier.DOSS_EMAIL;
end;

function TEmetteur.GetFEMET_DOSSID: integer;
begin
  Result := FEMET_DOSSID;
  if FDossier <> nil then
    Result := FDossier.DOSS_ID;
end;

function TEmetteur.GetListFieldGENBASES(const AdmGINKOIA: TdmGINKOIA): TStringList;
var
  vQry: TFDQuery;
begin
  Result := TStringList.Create;
  vQry := AdmGINKOIA.GetNewQry;
  try
    vQry.SQL.Text := Format(cSqlListFieldByTableName, ['GENBASES']);
    vQry.Open;
    while not vQry.Eof do
    begin
      Result.Append(UpperCase(vQry.Fields[0].AsString));
      vQry.Next;
    end;
  finally
    FreeAndNil(vQry);
  end;
end;

procedure TEmetteur.MAJ(const AAction: TUpdateKind);
var
  vQry, vQryGINKOIA: TFDQuery;
  vListFieldGENBASES: TStringList;
  vPRMID: integer;
begin
  inherited;

  vListFieldGENBASES := nil;
  try
    if not IsExcludeGnkMAJ then
    begin
      if FAdmGINKOIA = nil then
        FAdmGINKOIA := ConnectToGINKOIA(ADossier.DOSS_CHEMIN);

      vQryGINKOIA := FAdmGINKOIA.GetNewQry;
    end;

    vQry := dmMaintenance.GetNewQry;
    try
      if not dmMaintenance.Transaction.Active then
        dmMaintenance.Transaction.StartTransaction;

      if not IsExcludeGnkMAJ then
      begin
        { Chargement des fields de GENBASES pour les differences de version }
        vListFieldGENBASES := GetListFieldGENBASES(FAdmGINKOIA);
        if not FAdmGINKOIA.Transaction.Active then
          FAdmGINKOIA.Transaction.StartTransaction;
      end;

      case AAction of
        ukModify:
          begin
            if not IsExcludeGnkMAJ then
            begin
              FAdmGINKOIA.UpdateK(BAS_ID, 0);

              vQryGINKOIA.SQL.Append('update genbases set');
              vQryGINKOIA.SQL.Append('BAS_NOM=' + QuotedStr(BAS_NOM) + ',');

              { Controle de l'existance des fields à cause des differences de version }
              if vListFieldGENBASES.IndexOf('BAS_RGPID') <> -1 then
                vQryGINKOIA.SQL.Append('BAS_RGPID=' + IntToStr(BAS_RGPID) + ',');
              if vListFieldGENBASES.IndexOf('BAS_TYPE') <> -1 then
                vQryGINKOIA.SQL.Append('BAS_TYPE=' + IntToStr(BAS_TYPE) + ',');
              if vListFieldGENBASES.IndexOf('BAS_SECBASID') <> -1 then
                vQryGINKOIA.SQL.Append('BAS_SECBASID=' + IntToStr(BAS_SECBASID) + ',');
              if vListFieldGENBASES.IndexOf('BAS_SYNCHRO') <> -1 then
                vQryGINKOIA.SQL.Append('BAS_SYNCHRO=' + IntToStr(BAS_SYNCHRO) + ',');
              if vListFieldGENBASES.IndexOf('BAS_CENTRALE') <> -1 then
                vQryGINKOIA.SQL.Append('BAS_CENTRALE=' + QuotedStr(BAS_CENTRALE) + ',');
              if vListFieldGENBASES.IndexOf('BAS_NOMPOURNOUS') <> -1 then
                vQryGINKOIA.SQL.Append('BAS_NOMPOURNOUS=' + QuotedStr(BAS_NOMPOURNOUS) + ',');
              if vListFieldGENBASES.IndexOf('BAS_CODETIERS') <> -1 then
                vQryGINKOIA.SQL.Append('BAS_CODETIERS=' + QuotedStr(EMET_TIERSCEGID) + ',');
              { ---------------------------------------------------------------- }
              if FEMET_MAGID <> -1 then
              begin
                vQryGINKOIA.SQL.Append('BAS_MAGID=' + IntToStr(ADossier.GetMagasinByID(FEMET_MAGID).FMAGA_MAGID_GINKOIA) + ',');
                // Ajout SR - 05/11/2013
              end;

              vQryGINKOIA.SQL.Append('BAS_SENDER=' + QuotedStr(BAS_SENDER) + ','); // SR - 18/02/2014 - Correction
              vQryGINKOIA.SQL.Append('BAS_IDENT=' + QuotedStr(EMET_IDENT) + ',');
              vQryGINKOIA.SQL.Append('BAS_JETON=' + IntToStr(EMET_JETON) + ',');
              vQryGINKOIA.SQL.Append('BAS_PLAGE=' + QuotedStr(EMET_PLAGE));
              vQryGINKOIA.SQL.Append('Where BAS_ID <> 0');
              vQryGINKOIA.SQL.Append('AND BAS_ID=' + IntToStr(BAS_ID));
              vQryGINKOIA.ExecSQL;

              vQryGINKOIA.SQL.Clear;
              vQryGINKOIA.SQL.Text := 'select PRM_ID from genparam where PRM_CODE=:PPRM_CODE AND PRM_TYPE=:PPRM_TYPE AND PRM_POS=:PPRM_POS ';
              vQryGINKOIA.ParamByName('PPRM_CODE').AsInteger := 35;
              vQryGINKOIA.ParamByName('PPRM_TYPE').AsInteger := 11;
              vQryGINKOIA.ParamByName('PPRM_POS').AsInteger := BAS_ID;
              vQryGINKOIA.Open;
              vPRMID := vQryGINKOIA.FieldByName('PRM_ID').AsInteger;
              vQryGINKOIA.Close;

              // GenLaunch
              FAdmGINKOIA.UpdateK(LAU_ID, 0);

              vQryGINKOIA.SQL.Clear;
              vQryGINKOIA.SQL.Text := cSQL_U_GenLaunch;
              vQryGINKOIA.ParamByName('PLAU_ID').AsInteger := LAU_ID;
              vQryGINKOIA.ParamByName('PLAU_BASID').AsInteger := BAS_ID;

              if EMET_HEURE1 > 0 then
                vQryGINKOIA.ParamByName('PLAU_HEURE1').AsDateTime := StrToDateTime(FormatDateTime(cFormatDT, EMET_HEURE1), FormatSettings)
              else
                vQryGINKOIA.ParamByName('PLAU_HEURE1').Clear;
              vQryGINKOIA.ParamByName('PLAU_H1').AsInteger := EMET_H1;
              if EMET_HEURE2 > 0 then
                vQryGINKOIA.ParamByName('PLAU_HEURE2').AsDateTime := StrToDateTime(FormatDateTime(cFormatDT, EMET_HEURE2), FormatSettings)
              else
                vQryGINKOIA.ParamByName('PLAU_HEURE2').Clear;
              vQryGINKOIA.ParamByName('PLAU_H2').AsInteger := EMET_H2;
              vQryGINKOIA.ParamByName('PLAU_AUTORUN').AsInteger := LAU_AUTORUN;
              vQryGINKOIA.ParamByName('PLAU_BACK').AsInteger := LAU_BACK;
              if LAU_BACKTIME > 0 then
                vQryGINKOIA.ParamByName('PLAU_BACKTIME').AsDateTime := StrToDateTime(FormatDateTime(cFormatDT, LAU_BACKTIME), FormatSettings)
              else
                vQryGINKOIA.ParamByName('PLAU_BACKTIME').Clear;
              vQryGINKOIA.ExecSQL;

              FAdmGINKOIA.UpdateK(PRM_ID, 0);

              vQryGINKOIA.SQL.Clear;
              vQryGINKOIA.SQL.Text := 'update genparam set PRM_POS=:PPRM_POS Where PRM_ID=:PPRM_ID';
              vQryGINKOIA.ParamByName('PPRM_POS').AsInteger := PRM_POS;
              vQryGINKOIA.ParamByName('PPRM_ID').AsInteger := PRM_ID;
              vQryGINKOIA.ExecSQL;

              // Genparam Prm_Integer
              vQryGINKOIA.SQL.Clear;
              vQryGINKOIA.SQL.Text := cSQL_U_Maj_Emetteur_GenParam_PrmInteger;

              FAdmGINKOIA.UpdateK(RTR_PRMID_NBESSAI, 0);
              vQryGINKOIA.ParamByName('PPRM_INTEGER').AsInteger := RTR_NBESSAI;
              vQryGINKOIA.ParamByName('PPRM_ID').AsInteger := RTR_PRMID_NBESSAI;
              vQryGINKOIA.ExecSQL;

              FAdmGINKOIA.UpdateK(RTR_PRMID_DELAI, 0);
              vQryGINKOIA.ParamByName('PPRM_INTEGER').AsInteger := RTR_DELAI;
              vQryGINKOIA.ParamByName('PPRM_ID').AsInteger := RTR_PRMID_DELAI;
              vQryGINKOIA.ExecSQL;
              // ********************

              // Genparam Prm_Float
              vQryGINKOIA.SQL.Clear;
              vQryGINKOIA.SQL.Text := cSQL_U_Maj_Emetteur_GenParam_PrmFloat;

              FAdmGINKOIA.UpdateK(RTR_PRMID_HEUREDEB, 0);
              vQryGINKOIA.ParamByName('PPRM_FLOAT').AsFloat := RTR_HEUREDEB;
              vQryGINKOIA.ParamByName('PPRM_ID').AsInteger := RTR_PRMID_HEUREDEB;
              vQryGINKOIA.ExecSQL;

              FAdmGINKOIA.UpdateK(RTR_PRMID_HEUREFIN, 0);
              vQryGINKOIA.ParamByName('PPRM_FLOAT').AsFloat := RTR_HEUREFIN;
              vQryGINKOIA.ParamByName('PPRM_ID').AsInteger := RTR_PRMID_HEUREFIN;
              vQryGINKOIA.ExecSQL;
              // ********************

              // Genparam Prm_String
              vQryGINKOIA.SQL.Clear;
              vQryGINKOIA.SQL.Text := cSQL_U_Maj_Emetteur_GenParam_PrmString;

              FAdmGINKOIA.UpdateK(vPRMID, 0);
              vQryGINKOIA.ParamByName('PPRM_STRING').AsString := BAS_SENDER;
              vQryGINKOIA.ParamByName('PPRM_ID').AsInteger := vPRMID;
              vQryGINKOIA.ExecSQL;

              FAdmGINKOIA.UpdateK(RTR_PRMID_URL, 0);
              vQryGINKOIA.ParamByName('PPRM_STRING').AsString := RTR_URL;
              vQryGINKOIA.ParamByName('PPRM_ID').AsInteger := RTR_PRMID_URL;
              vQryGINKOIA.ExecSQL;

              FAdmGINKOIA.UpdateK(RTR_PRMID_SENDER, 0);
              vQryGINKOIA.ParamByName('PPRM_STRING').AsString := RTR_SENDER;
              vQryGINKOIA.ParamByName('PPRM_ID').AsInteger := RTR_PRMID_SENDER;
              vQryGINKOIA.ExecSQL;

              FAdmGINKOIA.UpdateK(RTR_PRMID_DATABASE, 0);
              vQryGINKOIA.ParamByName('PPRM_STRING').AsString := RTR_DATABASE;
              vQryGINKOIA.ParamByName('PPRM_ID').AsInteger := RTR_PRMID_DATABASE;
              vQryGINKOIA.ExecSQL;

              { -------------------------- Replic Web ---------------------- }
              if RW_HEUREDEB <> 0 then
              begin
                FAdmGINKOIA.UpdateK(RW_PRMID_HEUREDEB, 0);

                vQryGINKOIA.SQL.Clear;
                vQryGINKOIA.SQL.Text := cSQL_U_Maj_Emetteur_GenParam_PrmFloat;
                vQryGINKOIA.ParamByName('PPRM_FLOAT').AsFloat := RW_HEUREDEB;
                vQryGINKOIA.ParamByName('PPRM_ID').AsInteger := RW_PRMID_HEUREDEB;
                vQryGINKOIA.ExecSQL;
              end
              else
                FAdmGINKOIA.UpdateK(RW_PRMID_HEUREDEB, 1);

              if RW_HEUREFIN <> 0 then
              begin
                FAdmGINKOIA.UpdateK(RW_PRMID_HEUREFIN, 0);

                vQryGINKOIA.SQL.Clear;
                vQryGINKOIA.SQL.Text := cSQL_U_Maj_Emetteur_GenParam_PrmFloat;
                vQryGINKOIA.ParamByName('PPRM_FLOAT').AsFloat := RW_HEUREFIN;
                vQryGINKOIA.ParamByName('PPRM_ID').AsInteger := RW_PRMID_HEUREFIN;
                vQryGINKOIA.ExecSQL;
              end
              else
                FAdmGINKOIA.UpdateK(RW_PRMID_HEUREFIN, 1);

              if RW_INTERVALLE <> 0 then
              begin
                FAdmGINKOIA.UpdateK(RW_PRMID_INTERORDRE, 0);

                vQryGINKOIA.SQL.Clear;
                vQryGINKOIA.SQL.Text := 'update genparam set PRM_FLOAT=:PPRM_FLOAT, PRM_POS=:PPRM_POS Where PRM_ID=:PPRM_ID';
                vQryGINKOIA.ParamByName('PPRM_FLOAT').AsFloat := RW_INTERVALLE;
                vQryGINKOIA.ParamByName('PPRM_POS').AsInteger := RW_ORDRE;
                vQryGINKOIA.ParamByName('PPRM_ID').AsInteger := RW_PRMID_INTERORDRE;
                vQryGINKOIA.ExecSQL;
              end
              else
                FAdmGINKOIA.UpdateK(RW_PRMID_INTERORDRE, 1);
              { ------------------------------------------------------------- }

            end;

            vQry.SQL.Append('update emetteur set');
            vQry.SQL.Append('EMET_NOM=' + QuotedStr(EMET_NOM) + ',');
            vQry.SQL.Append('EMET_JETON=' + IntToStr(EMET_JETON) + ',');
            vQry.SQL.Append('EMET_IDENT=' + QuotedStr(EMET_IDENT) + ',');
            vQry.SQL.Append('EMET_PLAGE=' + QuotedStr(EMET_PLAGE) + ',');
            vQry.SQL.Append('EMET_GUID=' + QuotedStr(EMET_GUID) + ',');
            vQry.SQL.Append('EMET_DONNEES=' + QuotedStr(EMET_DONNEES) + ',');
            vQry.SQL.Append('EMET_VERSID=' + IntToStr(EMET_VERSID) + ',');

            if EMET_INSTALL > 0 then
              vQry.SQL.Append('EMET_INSTALL=' + QuotedStr(FormatDateTime(cFormatD, EMET_INSTALL)) + ',')
            else
              vQry.SQL.Append('EMET_INSTALL=null,');

            vQry.SQL.Append('EMET_MAGID=' + IntToStr(EMET_MAGID) + ',');
            vQry.SQL.Append('EMET_PATCH=' + IntToStr(EMET_PATCH) + ',');
            vQry.SQL.Append('EMET_VERSION_MAX=' + IntToStr(EMET_VERSION_MAX) + ',');
            vQry.SQL.Append('EMET_SPE_PATCH=' + IntToStr(EMET_SPE_PATCH) + ',');
            vQry.SQL.Append('EMET_SPE_FAIT=' + IntToStr(EMET_SPE_FAIT) + ',');
            if EMET_BCKOK > 0 then
              vQry.SQL.Append('EMET_BCKOK=' + QuotedStr(FormatDateTime(cFormatD, EMET_BCKOK)) + ',')
            else
              vQry.SQL.Append('EMET_BCKOK=null,');

            if EMET_DERNBCK > 0 then
              vQry.SQL.Append('EMET_DERNBCK=' + QuotedStr(FormatDateTime(cFormatD, EMET_DERNBCK)) + ',')
            else
              vQry.SQL.Append('EMET_DERNBCK=null,');

            vQry.SQL.Append('EMET_RESBCK=' + QuotedStr(EMET_RESBCK) + ',');
            vQry.SQL.Append('EMET_TIERSCEGID=' + QuotedStr(EMET_TIERSCEGID) + ',');
            vQry.SQL.Append('EMET_TYPEREPLICATION=' + QuotedStr(EMET_TYPEREPLICATION) + ',');
            vQry.SQL.Append('EMET_NONREPLICATION=' + IntToStr(EMET_NONREPLICATION) + ',');

            if EMET_DEBUTNONREPLICATION > 0 then
              vQry.SQL.Append('EMET_DEBUTNONREPLICATION=' + QuotedStr(FormatDateTime(cFormatD, EMET_DEBUTNONREPLICATION)) + ',')
            else
              vQry.SQL.Append('EMET_DEBUTNONREPLICATION=null,');

            if EMET_FINNONREPLICATION > 0 then
              vQry.SQL.Append('EMET_FINNONREPLICATION=' + QuotedStr(FormatDateTime(cFormatD, EMET_FINNONREPLICATION)) + ',')
            else
              vQry.SQL.Append('EMET_FINNONREPLICATION=null,');

            vQry.SQL.Append('EMET_SERVEURSECOURS=' + IntToStr(EMET_SERVEURSECOURS) + ',');

            if EMET_HEURE1 > 0 then
              vQry.SQL.Append('EMET_HEURE1=' + QuotedStr(FormatDateTime(cFormatDT, EMET_HEURE1)) + ',')
            else
              vQry.SQL.Append('EMET_HEURE1=null,');

            vQry.SQL.Append('EMET_H1=' + IntToStr(EMET_H1) + ',');

            if EMET_HEURE2 > 0 then
              vQry.SQL.Append('EMET_HEURE2=' + QuotedStr(FormatDateTime(cFormatDT, EMET_HEURE2)) + ',')
            else
              vQry.SQL.Append('EMET_HEURE2=null,');

            vQry.SQL.Append('EMET_H2=' + IntToStr(EMET_H2) + ',');
            vQry.SQL.Append('EMET_EMAIL=' + QuotedStr(EMET_EMAIL) + ',');
            vQry.SQL.Append('EMET_INFOSUP=' + QuotedStr(EMET_INFOSUP));

            vQry.SQL.Append('Where EMET_DOSSID=' + IntToStr(EMET_DOSSID));
            vQry.SQL.Append('and EMET_ID=' + IntToStr(EMET_ID));
            vQry.ExecSQL;

            if (HDBM_ID > 0) and (RAIS_ID > 0) then
            begin
              vQry.SQL.Clear;
              vQry.SQL.Append('update HDB set');
              vQry.SQL.Append('RAIS_ID=' + IntToStr(RAIS_ID));
              vQry.SQL.Append('Where HDBM_ID=' + IntToStr(HDBM_ID));
              vQry.ExecSQL;
            end;
          end;
        ukInsert:
          begin
            if BAS_GUID = '' then
            begin
              BAS_GUID := ADossier.GetNewGUID;
              FEMET_GUID := BAS_GUID;
            end;

            if not IsExcludeGnkMAJ then
            begin
              if ADossier.IsPlageExist(FAdmGINKOIA, EMET_PLAGE) then
                Raise Exception.Create('La plage ' + EMET_PLAGE + ' est occupée.');

              BAS_CENTRALE := ADossier.GROU_NOM;
              BAS_NOMPOURNOUS := ADossier.DOSS_DATABASE;

              BAS_ID := FAdmGINKOIA.GetNewID('genbases');

              vQryGINKOIA.SQL.Append('insert into genbases (');
              vQryGINKOIA.SQL.Append('BAS_NOM,');
              vQryGINKOIA.SQL.Append('BAS_GUID,');

              { Controle de l'existance des fields à cause des differences de version }
              if vListFieldGENBASES.IndexOf('BAS_RGPID') <> -1 then
                vQryGINKOIA.SQL.Append('BAS_RGPID,');
              if vListFieldGENBASES.IndexOf('BAS_TYPE') <> -1 then
                vQryGINKOIA.SQL.Append('BAS_TYPE,');
              if vListFieldGENBASES.IndexOf('BAS_SECBASID') <> -1 then
                vQryGINKOIA.SQL.Append('BAS_SECBASID,');
              if vListFieldGENBASES.IndexOf('BAS_SYNCHRO') <> -1 then
                vQryGINKOIA.SQL.Append('BAS_SYNCHRO,');
              if vListFieldGENBASES.IndexOf('BAS_CENTRALE') <> -1 then
                vQryGINKOIA.SQL.Append('BAS_CENTRALE,');
              if vListFieldGENBASES.IndexOf('BAS_NOMPOURNOUS') <> -1 then
                vQryGINKOIA.SQL.Append('BAS_NOMPOURNOUS,');
              if vListFieldGENBASES.IndexOf('BAS_CODETIERS') <> -1 then
                vQryGINKOIA.SQL.Append('BAS_CODETIERS,');
              { ---------------------------------------------------------------- }

              vQryGINKOIA.SQL.Append('BAS_MAGID,');
              vQryGINKOIA.SQL.Append('BAS_SENDER,');
              vQryGINKOIA.SQL.Append('BAS_ID,');
              vQryGINKOIA.SQL.Append('BAS_IDENT,');
              vQryGINKOIA.SQL.Append('BAS_JETON,');
              vQryGINKOIA.SQL.Append('BAS_PLAGE');
              vQryGINKOIA.SQL.Append(') Values (');

              // Données
              if BAS_NOM <> '' then // Si le BAS_NOM est vide en le renseigne avec le BAS_SENDER
                vQryGINKOIA.SQL.Append(QuotedStr(BAS_NOM) + ',')
              else
                vQryGINKOIA.SQL.Append(QuotedStr(BAS_SENDER) + ',');

              vQryGINKOIA.SQL.Append(QuotedStr(BAS_GUID) + ',');

              { Controle de l'existance des fields à cause des differences de version }
              if vListFieldGENBASES.IndexOf('BAS_RGPID') <> -1 then
                vQryGINKOIA.SQL.Append(IntToStr(BAS_RGPID) + ',');
              if vListFieldGENBASES.IndexOf('BAS_TYPE') <> -1 then
                vQryGINKOIA.SQL.Append(IntToStr(BAS_TYPE) + ',');
              if vListFieldGENBASES.IndexOf('BAS_SECBASID') <> -1 then
                vQryGINKOIA.SQL.Append(IntToStr(BAS_SECBASID) + ',');
              if vListFieldGENBASES.IndexOf('BAS_SYNCHRO') <> -1 then
                vQryGINKOIA.SQL.Append(IntToStr(BAS_SYNCHRO) + ',');
              if vListFieldGENBASES.IndexOf('BAS_CENTRALE') <> -1 then
                vQryGINKOIA.SQL.Append(QuotedStr(BAS_CENTRALE) + ',');
              if vListFieldGENBASES.IndexOf('BAS_NOMPOURNOUS') <> -1 then
                vQryGINKOIA.SQL.Append(QuotedStr(BAS_NOMPOURNOUS) + ',');
              if vListFieldGENBASES.IndexOf('BAS_CODETIERS') <> -1 then
                vQryGINKOIA.SQL.Append(QuotedStr(EMET_TIERSCEGID) + ',');
              { ---------------------------------------------------------------- }

              if FEMET_MAGID <> -1 then
                vQryGINKOIA.SQL.Append(IntToStr(ADossier.GetMagasinByID(FEMET_MAGID).MAGA_MAGID_GINKOIA) + ',')
              else
                vQryGINKOIA.SQL.Append('0,');
              vQryGINKOIA.SQL.Append(QuotedStr(BAS_SENDER) + ',');
              vQryGINKOIA.SQL.Append(IntToStr(BAS_ID) + ',');
              vQryGINKOIA.SQL.Append(QuotedStr(EMET_IDENT) + ',');
              vQryGINKOIA.SQL.Append(IntToStr(EMET_JETON) + ',');
              vQryGINKOIA.SQL.Append(QuotedStr(EMET_PLAGE));
              vQryGINKOIA.SQL.Append(')');
              vQryGINKOIA.ExecSQL;

              LAU_ID := FAdmGINKOIA.GetNewID('genlaunch');

              vQryGINKOIA.SQL.Text := cSQL_I_GenLaunch;
              vQryGINKOIA.ParamByName('PLAUID').AsInteger := LAU_ID;
              vQryGINKOIA.ParamByName('PLAUBASID').AsInteger := BAS_ID;
              if EMET_HEURE1 > 0 then
                vQryGINKOIA.ParamByName('PLAUHEURE1').AsDateTime := StrToDateTime(FormatDateTime(cFormatDT, EMET_HEURE1), FormatSettings)
              else
                vQryGINKOIA.ParamByName('PLAUHEURE1').Clear;
              vQryGINKOIA.ParamByName('PLAUH1').AsInteger := EMET_H1;
              if EMET_HEURE2 > 0 then
                vQryGINKOIA.ParamByName('PLAUHEURE2').AsDateTime := StrToDateTime(FormatDateTime(cFormatDT, EMET_HEURE2), FormatSettings)
              else
                vQryGINKOIA.ParamByName('PLAUHEURE2').Clear;
              vQryGINKOIA.ParamByName('PLAUH2').AsInteger := EMET_H2;
              vQryGINKOIA.ParamByName('PLAUAUTORUN').AsInteger := LAU_AUTORUN;
              if LAU_BACKTIME > 0 then
                vQryGINKOIA.ParamByName('PLAUBACKTIME').AsDateTime := StrToDateTime(FormatDateTime(cFormatDT, LAU_BACKTIME), FormatSettings)
              else
                vQryGINKOIA.ParamByName('PLAUBACKTIME').Clear;
              vQryGINKOIA.ParamByName('PLAUBACK').AsInteger := LAU_BACK;
              vQryGINKOIA.ExecSQL;

              vQryGINKOIA.SQL.Text := 'EXECUTE PROCEDURE PR_INITBASE(:PBASID, :PPANTIN, :PLAVERSION)';
              vQryGINKOIA.ParamByName('PBASID').AsInteger := BAS_ID;

              // SR - 15/10/2015 - Correction Mantis 1212
              if dmMaintenance.GetMaintenanceParamInteger(1, 8) = 1 then
                vQryGINKOIA.ParamByName('PPANTIN').AsString := ADossier.DOSS_DATABASE + '.' + dmMaintenance.GetMaintenanceParamString(1, 8)
              else
                vQryGINKOIA.ParamByName('PPANTIN').AsString := ADossier.SERV_IP;
              // ------

              vQryGINKOIA.ParamByName('PLAVERSION').AsString := BAS_NOMPOURNOUS + 'Bin';
              vQryGINKOIA.ExecSQL;
            end;

            FEMET_ID := dmMaintenance.GetNewID('emetteur');

            vQry.SQL.Text := cSql_I_Emetteur;

            vQry.ParamByName('PEMETNOM').AsString := EMET_NOM;
            vQry.ParamByName('PEMETJETON').AsInteger := EMET_JETON;
            vQry.ParamByName('PEMETIDENT').AsString := EMET_IDENT;
            vQry.ParamByName('PEMETPLAGE').AsString := EMET_PLAGE;
            vQry.ParamByName('PEMETGUID').AsString := EMET_GUID;
            vQry.ParamByName('PEMETDONNEES').AsString := EMET_DONNEES;
            vQry.ParamByName('PEMETVERSID').AsInteger := AVersion.VERS_ID;
            if EMET_INSTALL > 0 then
              vQry.ParamByName('PEMETINSTALL').AsDateTime := StrToDateTime(FormatDateTime(cFormatD, EMET_INSTALL), FormatSettings)
            else
              vQry.ParamByName('PEMETINSTALL').AsDateTime := StrToDateTime('01/01/1900');
            vQry.ParamByName('PEMETMAGID').AsInteger := EMET_MAGID;
            vQry.ParamByName('PEMETPATCH').AsInteger := EMET_PATCH;
            vQry.ParamByName('PEMETVERSION_MAX').AsInteger := EMET_VERSION_MAX;
            vQry.ParamByName('PEMETSPEPATCH').AsInteger := EMET_SPE_PATCH;
            vQry.ParamByName('PEMETSPEFAIT').AsInteger := EMET_SPE_FAIT;
            if EMET_BCKOK > 0 then
              vQry.ParamByName('PEMETBCKOK').AsDateTime := StrToDateTime(FormatDateTime(cFormatD, EMET_BCKOK), FormatSettings)
            else
              vQry.ParamByName('PEMETBCKOK').AsDateTime := StrToDateTime('01/01/1900');
            if EMET_DERNBCK > 0 then
              vQry.ParamByName('PEMETDERNBCK').AsDateTime := StrToDateTime(FormatDateTime(cFormatD, EMET_DERNBCK), FormatSettings)
            else
              vQry.ParamByName('PEMETDERNBCK').AsDateTime := StrToDateTime('01/01/1900');
            vQry.ParamByName('PEMETRESBCK').AsString := EMET_RESBCK;
            vQry.ParamByName('PEMETTIERSCEGID').AsString := EMET_TIERSCEGID;
            vQry.ParamByName('PEMETTYPEREPLICATION').AsString := EMET_TYPEREPLICATION;
            vQry.ParamByName('PEMETNONREPLICATION').AsInteger := EMET_NONREPLICATION;
            if EMET_DEBUTNONREPLICATION > 0 then
              vQry.ParamByName('PEMETDEBUTNONREPLICATION').AsDate := EMET_DEBUTNONREPLICATION
            else
              vQry.ParamByName('PEMETDEBUTNONREPLICATION').AsDate := StrToDate('01/01/1900');
            if EMET_FINNONREPLICATION > 0 then
              vQry.ParamByName('PEMETFINNONREPLICATION').AsDate := EMET_FINNONREPLICATION
            else
              vQry.ParamByName('PEMETFINNONREPLICATION').AsDate := StrToDate('01/01/1900');
            vQry.ParamByName('PEMETSERVEURSECOURS').AsInteger := EMET_SERVEURSECOURS;
            if EMET_HEURE1 > 0 then
              vQry.ParamByName('PEMETHEURE1').AsDateTime := StrToDateTime(FormatDateTime(cFormatDT, EMET_HEURE1), FormatSettings)
            else
              vQry.ParamByName('PEMETHEURE1').AsDateTime := StrToDate('01/01/1900');
            vQry.ParamByName('PEMETH1').AsInteger := EMET_H1;
            if EMET_HEURE2 > 0 then
              vQry.ParamByName('PEMETHEURE2').AsDateTime := StrToDateTime(FormatDateTime(cFormatDT, EMET_HEURE2), FormatSettings)
            else
              vQry.ParamByName('PEMETHEURE2').AsDateTime := StrToDate('01/01/1900');
            vQry.ParamByName('PEMETH2').AsInteger := EMET_H2;
            vQry.ParamByName('PEMETINFOSUP').AsString := EMET_INFOSUP;
            vQry.ParamByName('PEMETEMAIL').AsString := EMET_EMAIL;
            vQry.ParamByName('PEMETDOSSID').AsInteger := EMET_DOSSID;
            vQry.ParamByName('PEMETID').AsInteger := EMET_ID;
            vQry.ExecSQL;
          end;
        ukDelete:
          begin
            vQry.SQL.Text := 'DELETE FROM SPECIFIQUE WHERE SPEC_EMETID=:PEMET_ID';
            vQry.ParamByName('PEMET_ID').AsInteger := EMET_ID;
            vQry.ExecSQL;

            vQry.SQL.Text := 'DELETE FROM HISTO WHERE HIST_EMETID=:PEMET_ID';
            vQry.ParamByName('PEMET_ID').AsInteger := EMET_ID;
            vQry.ExecSQL;

            vQry.SQL.Text := 'DELETE FROM PLAGEMAJ WHERE PLAG_EMETID=:PEMET_ID';
            vQry.ParamByName('PEMET_ID').AsInteger := EMET_ID;
            vQry.ExecSQL;

            vQry.SQL.Text := 'DELETE FROM HDB WHERE EMET_ID=:PEMET_ID';
            vQry.ParamByName('PEMET_ID').AsInteger := EMET_ID;
            vQry.ExecSQL;

            vQry.SQL.Text := 'DELETE FROM EMETTEUR WHERE EMET_ID=:PEMET_ID';
            vQry.ParamByName('PEMET_ID').AsInteger := EMET_ID;
            vQry.ExecSQL;
          end;
      end;

      if not IsExcludeGnkMAJ then
        FAdmGINKOIA.Transaction.Commit;

      dmMaintenance.Transaction.Commit;

      // AJ 20/12/2017
      // Si on renseigne le BAS_MAGID et que le magasin associé n'a pas encore de MAG_BASID, alors on met à jour le MAG_BASID du magasin avec la BAS_ID de l'émetteur
      if not(IsExcludeGnkMAJ) then
      begin
        // si le magasin est renseigné sur le site, on fait le test, sinon non car génère une exception
        if FEMET_MAGID <> -1 then
        begin
          if (ADossier.GetMagasinByID(FEMET_MAGID).FMAGA_BASID = 0) then
          begin
            ADossier.GetMagasinByID(FEMET_MAGID).MAGA_BASID := BAS_ID;
            ADossier.GetMagasinByID(FEMET_MAGID).MAJ(ukModify);
          end;
        end;
      end;
    except
      on E: Exception do
      begin
        if not IsExcludeGnkMAJ then
          FAdmGINKOIA.Transaction.Rollback;

        dmMaintenance.Transaction.Rollback;

        Raise Exception.Create(ClassName + '.MAJ ' + UpdateKindToStr(AAction) + cRC + E.Message);
      end;
    end;
  finally
    FreeAndNil(vQry);
    if not IsExcludeGnkMAJ then
    begin
      FreeAndNil(vQryGINKOIA);
      FreeAndNil(FAdmGINKOIA);
    end;
    if vListFieldGENBASES <> nil then
      FreeAndNil(vListFieldGENBASES);
  end;
end;

procedure TEmetteur.MatchGenBasesToEmetteur;
begin
  if BAS_SENDER = '' then
    BAS_SENDER := BAS_NOM;
  EMET_NOM := BAS_SENDER;
  EMET_MAGID := BAS_MAGID;
  EMET_TIERSCEGID := BAS_CODETIERS;
  EMET_IDENT := BAS_IDENT;
  EMET_JETON := BAS_JETON;
  EMET_PLAGE := BAS_PLAGE;
  if LAU_HEURE1 < StrToDateTime('01/01/1900 00:00:00') then
    EMET_HEURE1 := StrToDateTime('01/01/1900 00:00:00')
  else
    EMET_HEURE1 := LAU_HEURE1;
  EMET_H1 := LAU_H1;
  if LAU_HEURE2 < StrToDateTime('01/01/1900 00:00:00') then
    EMET_HEURE2 := StrToDateTime('01/01/1900 00:00:00')
  else
    EMET_HEURE2 := LAU_HEURE2;
  EMET_H2 := LAU_H2;

  if BAS_GUID <> '' then
    EMET_GUID := BAS_GUID;
end;

procedure TEmetteur.SetValuesByDataSet(const ADS: TDataSet);
var
  vField: TField;
begin
  inherited;
  vField := ADS.FindField('EMET_TIERSCEGID');
  if vField <> nil then
    EMET_TIERSCEGID := vField.AsString;

  vField := ADS.FindField('EMET_BASID_GINKOIA');
  if vField <> nil then
    EMET_BASID_GINKOIA := vField.AsInteger;

  vField := ADS.FindField('EMET_NOM');
  if vField <> nil then
    EMET_NOM := vField.AsString;

  vField := ADS.FindField('EMET_INSTALL');
  if vField <> nil then
    EMET_INSTALL := vField.AsDateTime;

  vField := ADS.FindField('EMET_ID');
  if vField <> nil then
    EMET_ID := vField.AsInteger;

  vField := ADS.FindField('EMET_JETON');
  if vField <> nil then
    EMET_JETON := vField.AsInteger;

  vField := ADS.FindField('EMET_TYPEREPLICATION');
  if vField <> nil then
    EMET_TYPEREPLICATION := vField.AsString;

  vField := ADS.FindField('EMET_BCKOK');
  if vField <> nil then
    EMET_BCKOK := vField.AsDateTime;

  vField := ADS.FindField('EMET_SPE_FAIT');
  if vField <> nil then
    EMET_SPE_FAIT := vField.AsInteger;

  vField := ADS.FindField('EMET_DERNBCK');
  if vField <> nil then
    EMET_DERNBCK := vField.AsDateTime;

  vField := ADS.FindField('EMET_FINNONREPLICATION');
  if vField <> nil then
    EMET_FINNONREPLICATION := vField.AsDateTime;

  vField := ADS.FindField('EMET_H2');
  if vField <> nil then
    EMET_H2 := vField.AsInteger;

  vField := ADS.FindField('EMET_GUID');
  if vField <> nil then
    EMET_GUID := vField.AsString;

  vField := ADS.FindField('EMET_SERVEURSECOURS');
  if vField <> nil then
    EMET_SERVEURSECOURS := vField.AsInteger;

  vField := ADS.FindField('EMET_H1');
  if vField <> nil then
    EMET_H1 := vField.AsInteger;

  vField := ADS.FindField('EMET_SPE_PATCH');
  if vField <> nil then
    EMET_SPE_PATCH := vField.AsInteger;

  vField := ADS.FindField('EMET_IDENT');
  if vField <> nil then
    EMET_IDENT := vField.AsString;

  vField := ADS.FindField('EMET_PLAGE');
  if vField <> nil then
    EMET_PLAGE := vField.AsString;

  vField := ADS.FindField('EMET_VERSION_MAX');
  if vField <> nil then
    EMET_VERSION_MAX := vField.AsInteger;

  vField := ADS.FindField('EMET_INFOSUP');
  if vField <> nil then
    EMET_INFOSUP := vField.AsString;

  vField := ADS.FindField('EMET_EMAIL');
  if vField <> nil then
    EMET_EMAIL := vField.AsString;

  vField := ADS.FindField('EMET_NONREPLICATION');
  if vField <> nil then
    EMET_NONREPLICATION := vField.AsInteger;

  vField := ADS.FindField('EMET_HEURE2');
  if vField <> nil then
    EMET_HEURE2 := vField.AsDateTime;

  vField := ADS.FindField('EMET_DEBUTNONREPLICATION');
  if vField <> nil then
    EMET_DEBUTNONREPLICATION := vField.AsDateTime;

  vField := ADS.FindField('EMET_PATCH');
  if vField <> nil then
    EMET_PATCH := vField.AsInteger;

  vField := ADS.FindField('EMET_MAGID');
  if vField <> nil then
    EMET_MAGID := vField.AsInteger;

  vField := ADS.FindField('EMET_DONNEES');
  if vField <> nil then
    EMET_DONNEES := vField.AsString;

  vField := ADS.FindField('EMET_HEURE1');
  if vField <> nil then
    EMET_HEURE1 := vField.AsDateTime;

  vField := ADS.FindField('EMET_RESBCK');
  if vField <> nil then
    EMET_RESBCK := vField.AsString;

  vField := ADS.FindField('EMET_DOSSID');
  if vField <> nil then
    EMET_DOSSID := vField.AsInteger;

  vField := ADS.FindField('EMET_VERSID');
  if vField <> nil then
    EMET_VERSID := vField.AsInteger;

  vField := ADS.FindField('HDBM_COMMENTAIRE');
  if vField <> nil then
    HDBM_COMMENTAIRE := vField.AsString;

  vField := ADS.FindField('RAIS_NOM');
  if vField <> nil then
    RAIS_NOM := vField.AsString;

  vField := ADS.FindField('RAIS_ID');
  if vField <> nil then
    RAIS_ID := vField.AsInteger;

  vField := ADS.FindField('HDBM_DATE');
  if vField <> nil then
    HDBM_DATE := vField.AsDateTime;

  vField := ADS.FindField('HDBM_OK');
  if vField <> nil then
    HDBM_OK := vField.AsInteger;

  vField := ADS.FindField('HDBM_ARCHIVER');
  if vField <> nil then
    HDBM_ARCHIVER := vField.AsInteger;

  vField := ADS.FindField('HDBM_ID');
  if vField <> nil then
    HDBM_ID := vField.AsInteger;

  vField := ADS.FindField('HDBM_CYCLE');
  if vField <> nil then
    HDBM_CYCLE := vField.AsDateTime;

  vField := ADS.FindField('RTR_HEUREFIN');
  if vField <> nil then
    RTR_HEUREFIN := vField.AsDateTime;

  vField := ADS.FindField('RTR_DELAI');
  if vField <> nil then
    RTR_DELAI := vField.AsInteger;

  vField := ADS.FindField('RTR_HEUREDEB');
  if vField <> nil then
    RTR_HEUREDEB := vField.AsDateTime;

  vField := ADS.FindField('RTR_NBESSAI');
  if vField <> nil then
    RTR_NBESSAI := vField.AsInteger;

  vField := ADS.FindField('RTR_DATABASE');
  if vField <> nil then
    RTR_DATABASE := vField.AsString;

  vField := ADS.FindField('RTR_URL');
  if vField <> nil then
    RTR_URL := vField.AsString;

  vField := ADS.FindField('RTR_SENDER');
  if vField <> nil then
    RTR_SENDER := vField.AsString;

  vField := ADS.FindField('RTR_PRMID_DELAI');
  if vField <> nil then
    RTR_PRMID_DELAI := vField.AsInteger;

  vField := ADS.FindField('RTR_PRMID_HEUREDEB');
  if vField <> nil then
    RTR_PRMID_HEUREDEB := vField.AsInteger;

  vField := ADS.FindField('RTR_PRMID_DATABASE');
  if vField <> nil then
    RTR_PRMID_DATABASE := vField.AsInteger;

  vField := ADS.FindField('RTR_PRMID_URL');
  if vField <> nil then
    RTR_PRMID_URL := vField.AsInteger;

  vField := ADS.FindField('RTR_PRMID_SENDER');
  if vField <> nil then
    RTR_PRMID_SENDER := vField.AsInteger;

  vField := ADS.FindField('RTR_PRMID_HEUREFIN');
  if vField <> nil then
    RTR_PRMID_HEUREFIN := vField.AsInteger;

  vField := ADS.FindField('RTR_PRMID_NBESSAI');
  if vField <> nil then
    RTR_PRMID_NBESSAI := vField.AsInteger;

  vField := ADS.FindField('RW_PRMID_HEUREFIN');
  if vField <> nil then
    RW_PRMID_HEUREFIN := vField.AsInteger;

  vField := ADS.FindField('RW_HEUREFIN');
  if vField <> nil then
    RW_HEUREFIN := vField.AsDateTime;

  vField := ADS.FindField('RW_INTERVALLE');
  if vField <> nil then
    RW_INTERVALLE := vField.AsFloat;

  vField := ADS.FindField('RW_ORDRE');
  if vField <> nil then
    RW_ORDRE := vField.AsInteger;

  vField := ADS.FindField('RW_PRMID_INTERORDRE');
  if vField <> nil then
    RW_PRMID_INTERORDRE := vField.AsInteger;

  vField := ADS.FindField('RW_PRMID_HEUREDEB');
  if vField <> nil then
    RW_PRMID_HEUREDEB := vField.AsInteger;

  vField := ADS.FindField('RW_HEUREDEB');
  if vField <> nil then
    RW_HEUREDEB := vField.AsDateTime;
end;

{ TSociete }

procedure TSociete.AppendMag(const AMag: TMagasin);
begin
  AppendMagGnk(TGnkMagasin(AMag));
end;

procedure TSociete.DeleteMag(const AMag: TMagasin);
begin
  DeleteMagGnk(TGnkMagasin(AMag));
end;

function TSociete.GetMagasin(index: integer): TMagasin;
begin
  Result := TMagasin(MagasinGnk[index]);
end;

function TSociete.GetMagasinByID(AMAG_ID: integer): TMagasin;
begin
  Result := TMagasin(MagasinGnkByID[AMAG_ID]);
end;

procedure TSociete.MAJ(const AAction: TUpdateKind);
var
  vQry: TFDQuery;
begin
  inherited;
  try
    if FAdmGINKOIA = nil then
      FAdmGINKOIA := ConnectToGINKOIA(ADossier.DOSS_CHEMIN);
    vQry := FAdmGINKOIA.GetNewQry;
    try
      if not FAdmGINKOIA.Transaction.Active then
        FAdmGINKOIA.Transaction.StartTransaction;
      case AAction of
        ukModify:
          begin
            FAdmGINKOIA.UpdateK(SOC_ID, 0);

            vQry.SQL.Append('update gensociete set');
            vQry.SQL.Append('SOC_NOM=' + QuotedStr(SOC_NOM) + ',');
            vQry.SQL.Append('SOC_CLOTURE=' + QuotedStr(FormatDateTime(cFormatD, SOC_CLOTURE)) + ',');
            vQry.SQL.Append('SOC_SSID=' + IntToStr(SOC_SSID));
            vQry.SQL.Append('Where SOC_ID=' + IntToStr(SOC_ID));
            vQry.ExecSQL;
          end;
        ukInsert:
          begin
            SOC_ID := FAdmGINKOIA.GetNewID('gensociete');

            vQry.SQL.Append('insert into gensociete (');
            vQry.SQL.Append('SOC_ID,');
            vQry.SQL.Append('SOC_NOM,');
            vQry.SQL.Append('SOC_CLOTURE,');
            vQry.SQL.Append('SOC_SSID');
            vQry.SQL.Append(') Values (');
            vQry.SQL.Append(IntToStr(SOC_ID) + ',');
            vQry.SQL.Append(QuotedStr(SOC_NOM) + ',');
            vQry.SQL.Append(QuotedStr(FormatDateTime(cFormatD, SOC_CLOTURE)) + ',');
            vQry.SQL.Append(IntToStr(SOC_SSID));
            vQry.SQL.Append(')');
            vQry.ExecSQL;
          end;
        ukDelete:
          begin

          end;
      end;

      FAdmGINKOIA.Transaction.Commit;
    except
      on E: Exception do
      begin
        FAdmGINKOIA.Transaction.Rollback;
        Raise Exception.Create(ClassName + '.MAJ ' + UpdateKindToStr(AAction) + cRC + E.Message);
      end;
    end;
  finally
    FreeAndNil(vQry);
    FreeAndNil(FAdmGINKOIA);
  end;
end;

{ TPoste }

procedure TPoste.MAJ(const AAction: TUpdateKind);
var
  vQryMaintenance, vQryGINKOIA: TFDQuery;
begin
  inherited;
  try
    if not IsExcludeGnkMAJ then
    begin
      if FAdmGINKOIA = nil then
        FAdmGINKOIA := ConnectToGINKOIA(FMagasin.FDossier.DOSS_CHEMIN);
      vQryGINKOIA := FAdmGINKOIA.GetNewQry;
    end;

    vQryMaintenance := dmMaintenance.GetNewQry;
    try
      if not dmMaintenance.Transaction.Active then
        dmMaintenance.Transaction.StartTransaction;

      if not IsExcludeGnkMAJ then
      begin
        if not FAdmGINKOIA.Transaction.Active then
          FAdmGINKOIA.Transaction.StartTransaction;
      end;

      case AAction of
        ukModify:
          begin
            if not IsExcludeGnkMAJ then
            begin
              FAdmGINKOIA.UpdateK(POST_POSID, 0);

              vQryGINKOIA.SQL.Text := cSql_U_genposte;

              vQryGINKOIA.ParamByName('PPOS_NOM').AsString := POST_NOM;
              vQryGINKOIA.ParamByName('PPOS_INFO').AsString := POST_INFO;
              vQryGINKOIA.ParamByName('PPOS_COMPTA').AsString := POST_COMPTA;
              vQryGINKOIA.ParamByName('PPOS_ID').AsInteger := POST_POSID;
              vQryGINKOIA.ExecSQL;
            end;

            vQryMaintenance.SQL.Text := cSql_U_postes;

            vQryMaintenance.ParamByName('PPOSTNOM').AsString := POST_NOM;
            vQryMaintenance.ParamByName('PPOSTINFO').AsString := POST_INFO;
            vQryMaintenance.ParamByName('PPOSTCOMPTA').AsString := POST_COMPTA;
            vQryMaintenance.ParamByName('PPOSTPTYPID').AsInteger := POST_PTYPID;
            vQryMaintenance.ParamByName('PPOSTDATEC').AsDateTime := POST_DATEC;
            vQryMaintenance.ParamByName('PPOSTDATEM').AsDateTime := Now;
            vQryMaintenance.ParamByName('PPOSTENABLE').AsInteger := POST_ENABLE;
            vQryMaintenance.ParamByName('PPOSTID').AsInteger := POST_ID;
            vQryMaintenance.ExecSQL;
          end;
        ukInsert:
          begin
            if not IsExcludeGnkMAJ then
            begin
              POST_POSID := FAdmGINKOIA.GetNewID('genposte');

              vQryGINKOIA.SQL.Text := cSql_I_genposte;

              vQryGINKOIA.ParamByName('PPOS_NOM').AsString := POST_NOM;
              vQryGINKOIA.ParamByName('PPOS_INFO').AsString := POST_INFO;
              vQryGINKOIA.ParamByName('PPOS_MAGID').AsInteger := POST_MAGID;
              vQryGINKOIA.ParamByName('PPOS_COMPTA').AsString := POST_COMPTA;
              vQryGINKOIA.ParamByName('PPOS_ID').AsInteger := POST_POSID;
              vQryGINKOIA.ExecSQL;
            end;

            POST_ID := dmMaintenance.GetNewID('postes');

            vQryMaintenance.SQL.Text := cSql_I_postes;

            vQryMaintenance.ParamByName('PPOSTID').AsInteger := POST_ID;
            vQryMaintenance.ParamByName('PPOSTPOSID').AsInteger := POST_POSID;
            vQryMaintenance.ParamByName('PPOSTMAGAID').AsInteger := FMagasin.MAGA_ID;;
            vQryMaintenance.ParamByName('PPOSTNOM').AsString := POST_NOM;
            vQryMaintenance.ParamByName('PPOSTINFO').AsString := POST_INFO;
            vQryMaintenance.ParamByName('PPOSTCOMPTA').AsString := POST_COMPTA;
            vQryMaintenance.ParamByName('PPOSTPTYPID').AsInteger := POST_PTYPID;
            vQryMaintenance.ParamByName('PPOSTDATEC').AsDateTime := POST_DATEC;
            vQryMaintenance.ParamByName('PPOSTDATEM').AsDateTime := POST_DATEM;
            vQryMaintenance.ParamByName('PPOSTENABLE').AsInteger := POST_ENABLE;
            vQryMaintenance.ExecSQL;

          end;
        ukDelete:
          begin

          end;
      end;

      if not IsExcludeGnkMAJ then
      begin
        // SR - 23/06/2015 - Active la caisse de secours si le module est présent.
        if (AAction = ukInsert) then
        begin
          vQryGINKOIA.Close;
          vQryGINKOIA.SQL.Text := 'SELECT UGG_ID ' + 'FROM UILGRPGINKOIAMAG ' + '  JOIN K KUGM ON (KUGM.K_ID = UGM_ID AND KUGM.K_ENABLED = 1) ' +
            '  JOIN UILGRPGINKOIA ON (UGG_ID = UGM_UGGID) ' + '  JOIN K KUGG ON (KUGG.K_ID = UGG_ID AND KUGG.K_ENABLED = 1) ' + 'WHERE UGG_ID <> 0 ' +
            'AND UGG_NOM = ' + QuotedStr('CAISSE_SECOURS') + ' ' + 'AND UGM_MAGID = ' + IntToStr(POST_MAGID);
          vQryGINKOIA.Open;

          if ((Not vQryGINKOIA.FieldByName('UGG_ID').IsNull) AND (Pos('CAISSE', POST_NOM, 1) <> 0) AND (Pos('%_SEC', POST_NOM, 1) = 0)) then
          begin
            if not FAdmGINKOIA.Transaction.Active then
              FAdmGINKOIA.Transaction.StartTransaction;

            // Vérifie si il n'y a pas déjà trop de postes de secours dans le magasin
            vQryGINKOIA.Close;
            vQryGINKOIA.SQL.Text := 'SELECT COUNT(*) AS NB ' + 'FROM GENPOSTE' +
              '  JOIN K KPOS ON (KPOS.K_ID = POS_ID AND KPOS.K_ENABLED = 1 AND KPOS.K_ID != 0)' + 'WHERE POS_MAGID = ' + IntToStr(POST_MAGID) + ' ' +
              'AND POS_NOM LIKE ' + QuotedStr('%_SEC');
            vQryGINKOIA.Open;

            if (vQryGINKOIA.FieldByName('NB').AsInteger < 5) then
            begin
              if not FAdmGINKOIA.Transaction.Active then
                FAdmGINKOIA.Transaction.StartTransaction;

              vQryGINKOIA.Close;
              vQryGINKOIA.SQL.Text := 'SELECT RETOUR FROM INIT_CAISSES_SEC_POS(' + IntToStr(POST_POSID) + ')';
              vQryGINKOIA.Open;
            end;
          end;
        end;
      end;

      dmMaintenance.Transaction.Commit;
      if not IsExcludeGnkMAJ then
      begin
        FAdmGINKOIA.Transaction.Commit;
      end;

    except
      on E: Exception do
      begin
        if not IsExcludeGnkMAJ then
        begin
          FAdmGINKOIA.Transaction.Rollback;
        end;
        FAdmGINKOIA.Transaction.Rollback;
        Raise Exception.Create(ClassName + '.MAJ ' + UpdateKindToStr(AAction) + cRC + E.Message);
      end;
    end;
  finally
    FreeAndNil(vQryMaintenance);
    FreeAndNil(vQryGINKOIA);
    FreeAndNil(FAdmGINKOIA);
  end;
end;

procedure TPoste.SetValuesByDataSet(const ADS: TDataSet);
var
  vField: TField;
begin
  inherited;
  vField := ADS.FindField('POST_POSID');
  if vField <> nil then
    POST_POSID := vField.AsInteger;

  vField := ADS.FindField('POST_PTYPID');
  if vField <> nil then
    POST_PTYPID := vField.AsInteger;
end;

{ THoraire }

procedure THoraire.MAJ(const AAction: TUpdateKind);
var
  vQry: TFDQuery;
begin
  inherited;
  try
    vQry := dmMaintenance.GetNewQry;
    try
      if not dmMaintenance.Transaction.Active then
        dmMaintenance.Transaction.StartTransaction;
      case AAction of
        ukModify:
          begin
            vQry.SQL.Append('update param_horaires set');
            vQry.SQL.Append('PRH_SRVID=' + IntToStr(PRH_SRVID) + ',');
            vQry.SQL.Append('PRH_NOMPLAGE=' + QuotedStr(PRH_NOMPLAGE) + ',');
            vQry.SQL.Append('PRH_HDEB=' + QuotedStr(FormatDateTime(cFormatDT, PRH_HDEB)) + ',');
            vQry.SQL.Append('PRH_HFIN=' + QuotedStr(FormatDateTime(cFormatDT, PRH_HFIN)) + ',');
            vQry.SQL.Append('PRH_NBREPLIC=' + IntToStr(PRH_NBREPLIC) + ',');
            vQry.SQL.Append('PRH_DEFAUT=' + IntToStr(PRH_DEFAUT));
            vQry.SQL.Append('Where PRH_ID=' + IntToStr(PRH_ID));
            vQry.ExecSQL;
          end;
        ukInsert:
          begin
            FPRH_ID := dmMaintenance.GetNewID('param_horaires');

            vQry.SQL.Append('insert into param_horaires (');
            vQry.SQL.Append('PRH_SRVID,');
            vQry.SQL.Append('PRH_NOMPLAGE,');
            vQry.SQL.Append('PRH_HDEB,');
            vQry.SQL.Append('PRH_HFIN,');
            vQry.SQL.Append('PRH_NBREPLIC,');
            vQry.SQL.Append('PRH_DEFAUT,');
            vQry.SQL.Append('PRH_ID');
            vQry.SQL.Append(') Values (');
            vQry.SQL.Append(IntToStr(PRH_SRVID) + ',');
            vQry.SQL.Append(QuotedStr(PRH_NOMPLAGE) + ',');
            vQry.SQL.Append(QuotedStr(FormatDateTime(cFormatDT, PRH_HDEB)) + ',');
            vQry.SQL.Append(QuotedStr(FormatDateTime(cFormatDT, PRH_HFIN)) + ',');
            vQry.SQL.Append(IntToStr(PRH_NBREPLIC) + ',');
            vQry.SQL.Append(IntToStr(PRH_DEFAUT) + ',');
            vQry.SQL.Append(IntToStr(PRH_ID));
            vQry.SQL.Append(')');
            vQry.ExecSQL;
          end;
        ukDelete:
          begin
            vQry.SQL.Append('Delete from param_horaires');
            vQry.SQL.Append('Where PRH_ID=' + IntToStr(PRH_ID));
            vQry.ExecSQL;
          end;
      end;

      dmMaintenance.Transaction.Commit;
    except
      on E: Exception do
      begin
        dmMaintenance.Transaction.Rollback;
        Raise Exception.Create(ClassName + '.MAJ ' + UpdateKindToStr(AAction) + cRC + E.Message);
      end;
    end;
  finally
    FreeAndNil(vQry);
  end;
end;

procedure THoraire.SetValuesByDataSet(const ADS: TDataSet);
var
  vField: TField;
begin
  vField := ADS.FindField('PRH_HDEB');
  if vField <> nil then
    PRH_HDEB := vField.AsDateTime;

  vField := ADS.FindField('PRH_DEFAUT');
  if vField <> nil then
    PRH_DEFAUT := vField.AsInteger;

  vField := ADS.FindField('PRH_NOMPLAGE');
  if vField <> nil then
    PRH_NOMPLAGE := vField.AsString;

  vField := ADS.FindField('PRH_ID');
  if vField <> nil then
    PRH_ID := vField.AsInteger;

  vField := ADS.FindField('PRH_HFIN');
  if vField <> nil then
    PRH_HFIN := vField.AsDateTime;

  vField := ADS.FindField('PRH_NBREPLIC');
  if vField <> nil then
    PRH_NBREPLIC := vField.AsInteger;

  vField := ADS.FindField('PRH_SRVID');
  if vField <> nil then
    PRH_SRVID := vField.AsInteger;
end;

{ TServeur }

procedure TServeur.AppendHoraire(const AHoraire: THoraire);
begin
  if HoraireByID[AHoraire.PRH_ID] = nil then
    FListHoraire.Add(AHoraire);
end;

constructor TServeur.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FListHoraire := TObjectList.Create(True);
end;

procedure TServeur.DeleteHoraire(const AHoraire: THoraire);
begin
  FListHoraire.Remove(AHoraire);
end;

destructor TServeur.Destroy;
begin
  FreeAndNil(FListHoraire);
  inherited Destroy;
end;

function TServeur.GetCountHoraire: integer;
begin
  Result := FListHoraire.Count;
end;

function TServeur.GetHoraire(index: integer): THoraire;
begin
  Result := THoraire(FListHoraire.Items[index]);
end;

function TServeur.GetHoraireByID(APRH_ID: integer): THoraire;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to FListHoraire.Count - 1 do
  begin
    if Horaire[i].PRH_ID = APRH_ID then
    begin
      Result := Horaire[i];
      Break;
    end;
  end;
end;

procedure TServeur.MAJ(const AAction: TUpdateKind);
var
  vQry: TFDQuery;
begin
  inherited;
  try
    vQry := dmMaintenance.GetNewQry;
    try
      if not dmMaintenance.Transaction.Active then
        dmMaintenance.Transaction.StartTransaction;
      case AAction of
        ukInsert:
          begin
            SERV_ID := dmMaintenance.GetNewID('SERVEUR');
            vQry.SQL.Text := cSql_I_Serveur;
          end;
        ukModify:
          vQry.SQL.Text := cSql_U_Serveur;
        ukDelete:
          vQry.SQL.Text := 'DELETE FROM SERVEUR WHERE SERV_ID = ' + IntToStr(SERV_ID);
      end;

      if AAction in [ukInsert, ukModify] then
      begin
        vQry.ParamByName('PSERVID').AsInteger := SERV_ID;
        vQry.ParamByName('PSERVNOM').AsString := SERV_NOM;
        vQry.ParamByName('PSERVIP').AsString := SERV_IP;
        vQry.ParamByName('PSERVDOSEAI').AsString := SERV_DOSEAI;
        vQry.ParamByName('PSERVUSER').AsString := SERV_USER;
        vQry.ParamByName('PSERVPASSWORD').AsString := SERV_PASSWORD;
        vQry.ParamByName('PSERVDOSBDD').AsString := SERV_DOSBDD;
        vQry.ParamByName('PSERVSEVENZIP').AsString := SERV_SEVENZIP;
        vQry.ParamByName('PSERVLOCALIP').AsString := SERV_LOCALIP;
      end;

      vQry.ExecSQL;

      dmMaintenance.Transaction.Commit;
    except
      on E: Exception do
      begin
        dmMaintenance.Transaction.Rollback;
        Raise Exception.Create(ClassName + '.MAJ ' + UpdateKindToStr(AAction) + cRC + E.Message);
      end;
    end;
  finally
    FreeAndNil(vQry);
  end;
end;

procedure TServeur.SetValuesByDataSet(const ADS: TDataSet);
var
  vField: TField;
begin
  vField := ADS.FindField('SERV_NOM');
  if vField <> nil then
    SERV_NOM := vField.AsString;

  vField := ADS.FindField('SERV_ID');
  if vField <> nil then
    SERV_ID := vField.AsInteger;

  vField := ADS.FindField('SERV_IP');
  if vField <> nil then
    SERV_IP := vField.AsString;

  vField := ADS.FindField('SERV_DOSEAI');
  if vField <> nil then
    SERV_DOSEAI := vField.AsString;

  vField := ADS.FindField('SERV_USER');
  if vField <> nil then
    SERV_USER := vField.AsString;

  vField := ADS.FindField('SERV_PASSWORD');
  if vField <> nil then
    SERV_PASSWORD := vField.AsString;

  vField := ADS.FindField('SERV_DOSBDD');
  if vField <> nil then
    SERV_DOSBDD := vField.AsString;

  vField := ADS.FindField('SERV_SEVENZIP');
  if vField <> nil then
    SERV_SEVENZIP := vField.AsString;

  vField := ADS.FindField('SERV_LOCALIP');
  if vField <> nil then
    SERV_LOCALIP := vField.AsString;
end;

{ TModuleGinkoia }

function TModuleGinkoia.GetDOSS_ID: integer;
begin
  Result := FDOSS_ID;
  if FDossier <> nil then
    Result := FDossier.DOSS_ID;
end;

procedure TModuleGinkoia.MAJ(const AAction: TUpdateKind);
var
  vQry, vQryMOD_MAG, vQryGINKOIA, vQryGINKOIASelect: TFDQuery;
  vSLExcept: TStringList;
  vPRMID_Loc, vPRMKEnabled_Loc: integer;
begin
  inherited;
  vSLExcept := TStringList.Create;
  try
    if FAdmGINKOIA = nil then
      FAdmGINKOIA := ConnectToGINKOIA(ADossier.DOSS_CHEMIN);

    vQry := dmMaintenance.GetNewQry;
    vQryMOD_MAG := dmMaintenance.GetNewQry;
    vQryGINKOIA := FAdmGINKOIA.GetNewQry;
    vQryGINKOIASelect := FAdmGINKOIA.GetNewQry;
    try
      if not dmMaintenance.Transaction.Active then
        dmMaintenance.Transaction.StartTransaction;
      if not FAdmGINKOIA.Transaction.Active then
        FAdmGINKOIA.Transaction.StartTransaction;

      if UGM_ID < 1 then
      begin
        { Ce traitement est en attendant la modif de PR_GRPASSOCIEMAG pour obtenir le new ID }
        vQryGINKOIA.SQL.Append('select * from uilgrpginkoiamag');
        vQryGINKOIA.SQL.Append('Where UGM_MAGID=:PUGM_MAGID');
        vQryGINKOIA.SQL.Append('and UGM_UGGID=:PUGM_UGGID');
        vQryGINKOIA.ParamByName('PUGM_MAGID').AsInteger := UGM_MAGID;
        vQryGINKOIA.ParamByName('PUGM_UGGID').AsInteger := UGG_ID;
        vQryGINKOIA.Open;
        if not vQryGINKOIA.Eof then
          UGM_ID := vQryGINKOIA.FieldByName('UGM_ID').AsInteger;
      end;

      case AAction of
        ukInsert, ukModify:
          begin
            vQryMOD_MAG.SQL.Append('Select * from modules_magasins where');
            vQryMOD_MAG.SQL.Append('MMAG_MODUID =' + IntToStr(MODU_ID));
            vQryMOD_MAG.SQL.Append('and MMAG_MAGAID =' + IntToStr(MAGA_ID));
            vQryMOD_MAG.Open;
            if not vQryMOD_MAG.Eof then
            begin
              vSLExcept.Append('Update K');
              if vQryMOD_MAG.FieldByName('MMAG_KENABLED').AsInteger = 0 then
                FAdmGINKOIA.UpdateK(UGM_ID, cPrUpdateK_Act)
              else
                FAdmGINKOIA.UpdateK(UGM_ID, cPrUpdateK_Mvt);

              // Base Ginkoia
              vSLExcept.Append('Update uilgrpginkoiamag');
              vQryGINKOIA.SQL.Clear;
              vQryGINKOIA.SQL.Append('update uilgrpginkoiamag set');
              vQryGINKOIA.SQL.Append('UGM_DATE=' + QuotedStr(FormatDateTime(cFormatD, MMAG_EXPDATE)));
              vQryGINKOIA.SQL.Append('Where UGM_MAGID=' + IntToStr(UGM_MAGID));
              vQryGINKOIA.SQL.Append('and UGM_UGGID=' + IntToStr(UGG_ID));
              vQryGINKOIA.ExecSQL;
              // ------------

              // Base Maintenance
              vSLExcept.Append('Update modules_magasins');
              vQry.SQL.Append('UPDATE modules_magasins set');
              vQry.SQL.Append('MMAG_EXPDATE=' + QuotedStr(FormatDateTime(cFormatD, MMAG_EXPDATE)) + ',');
              vQry.SQL.Append('MMAG_KENABLED=1');
              vQry.SQL.Append('Where MMAG_MAGAID=' + IntToStr(MAGA_ID));
              vQry.SQL.Append('and MMAG_MODUID=' + IntToStr(MODU_ID));
              vQry.ExecSQL;
              // ----------------
            end
            else
            begin
              vSLExcept.Append('Insert uilgrpginkoiamag');
              // FUGM_ID:= vdmGINKOIA.PR_GRPASSOCIEMAG(UGM_MAGID, MOD_NOM, MMAG_EXPDATE); //--> en attente de changement de la storproc pour obtenir le new ID...

              UGM_ID := FAdmGINKOIA.GetNewID('uilgrpginkoiamag');

              vQryGINKOIA.SQL.Clear;
              vQryGINKOIA.SQL.Append('insert into uilgrpginkoiamag (');
              vQryGINKOIA.SQL.Append('UGM_ID,');
              vQryGINKOIA.SQL.Append('UGM_MAGID,');
              vQryGINKOIA.SQL.Append('UGM_UGGID,');
              vQryGINKOIA.SQL.Append('UGM_DATE');
              vQryGINKOIA.SQL.Append(') Values (');
              vQryGINKOIA.SQL.Append(IntToStr(UGM_ID) + ',');
              vQryGINKOIA.SQL.Append(IntToStr(UGM_MAGID) + ',');
              vQryGINKOIA.SQL.Append(IntToStr(UGG_ID) + ',');
              vQryGINKOIA.SQL.Append(QuotedStr(FormatDateTime(cFormatD, MMAG_EXPDATE)));
              vQryGINKOIA.SQL.Append(')');
              vQryGINKOIA.ExecSQL;

              vQry.SQL.Append('SELECT * FROM MODULES WHERE');
              vQry.SQL.Append('MODU_ID =' + IntToStr(MODU_ID));
              vQry.Open;
              if vQry.Eof then
              begin
                vSLExcept.Append('Insert modules');
                MODU_ID := dmMaintenance.GetNewID('MODULES');

                vQry.SQL.Clear;
                vQry.SQL.Append('INSERT INTO MODULES (');
                vQry.SQL.Append('MODU_ID,');
                vQry.SQL.Append('MODU_NOM,');
                vQry.SQL.Append('MODU_COMMENT');
                vQry.SQL.Append(') Values (');
                vQry.SQL.Append(IntToStr(MODU_ID) + ',');
                vQry.SQL.Append(QuotedStr(MODU_NOM) + ',');
                vQry.SQL.Append(QuotedStr(MODU_COMMENT));
                vQry.SQL.Append(')');
                vQry.ExecSQL;
              end;

              vSLExcept.Append('Insert modules_magasins');
              vQry.SQL.Clear;
              vQry.SQL.Append('insert into modules_magasins (');
              vQry.SQL.Append('MMAG_MODUID,');
              vQry.SQL.Append('MMAG_MAGAID,');
              vQry.SQL.Append('MMAG_EXPDATE,');
              vQry.SQL.Append('MMAG_KENABLED,');
              vQry.SQL.Append('MMAG_UGMID');
              vQry.SQL.Append(') Values (');
              vQry.SQL.Append(IntToStr(MODU_ID) + ',');
              vQry.SQL.Append(IntToStr(MAGA_ID) + ',');
              vQry.SQL.Append(QuotedStr(FormatDateTime(cFormatD, MMAG_EXPDATE)) + ',');
              vQry.SQL.Append('1,');
              vQry.SQL.Append(IntToStr(UGM_ID));
              vQry.SQL.Append(')');
              vQry.ExecSQL;
            end;

            vSLExcept.Append('Update uilpermissions'); // SR : Correction Module
            vQryGINKOIASelect.SQL.Clear;
            vQryGINKOIASelect.SQL.Append('Select PER_ID ' + 'From UILGRPGINKOIAL ' + '  join K on (K_ID = UGL_ID and K_ENABLED = 1) ' +
              '  join UILPERMISSIONS ' + '  join K on (K_ID = PER_ID and K_ENABLED = 1) on (PER_ID = UGL_PERID) ' + 'where UGL_UGGID = :UGGID ' +
              'and PER_VISIBLE = 1 ' + 'and PER_PERMISSION <> ''SUPER''');
            vQryGINKOIASelect.ParamByName('UGGID').AsInteger := UGG_ID;
            vQryGINKOIASelect.Open;
            vQryGINKOIASelect.First;
            while not vQryGINKOIASelect.Eof do
            begin
              FAdmGINKOIA.UpdateK(vQryGINKOIASelect.FieldByName('PER_ID').AsInteger, 0);
              vQryGINKOIA.SQL.Clear;
              vQryGINKOIA.SQL.Append('update UILPERMISSIONS set PER_VISIBLE = 0 where PER_ID = ' +
                IntToStr(vQryGINKOIASelect.FieldByName('PER_ID').AsInteger));
              vQryGINKOIA.ExecSQL;
              vQryGINKOIASelect.Next;
            end;

            // SR - 17/09/2014 - Cas particulier pour la location
            if MODU_NOM = 'LOCATION' then
            begin
              vSLExcept.Append('Mise à jour du GenParam');
              vPRMID_Loc := FAdmGINKOIA.GetParamIDByMag_SS_KENABLED(9, 90, UGM_MAGID);
              if vPRMID_Loc > 0 then // Si le GenParam existe
              begin
                FAdmGINKOIA.UpdateK(vPRMID_Loc, cPrUpdateK_Act);
                FAdmGINKOIA.SetParamInteger(vPRMID_Loc, 1);
              end
              else // Si non on l'ajoute
              begin
                FAdmGINKOIA.CreateParam(9, 90, UGM_MAGID, 0, 1, 0, 'LOCATION', 'LOCATION');
              end;
            end;

          end;
        ukDelete:
          begin
            vSLExcept.Append('Delete K');
            FAdmGINKOIA.UpdateK(UGM_ID, cPrUpdateK_Sup);

            // SR - 17/09/2014 - Cas particulier pour la location
            if MODU_NOM = 'LOCATION' then
            begin
              vSLExcept.Append('Mise à jour du GenParam');
              vPRMID_Loc := FAdmGINKOIA.GetParamIDByMag_SS_KENABLED(9, 90, UGM_MAGID);
              if vPRMID_Loc > 0 then // Si le GenParam existe
              begin
                FAdmGINKOIA.SetParamInteger(vPRMID_Loc, 0);
              end
              else // Si non on l'ajoute
              begin
                FAdmGINKOIA.CreateParam(9, 90, UGM_MAGID, 0, 0, 0, 'LOCATION', 'LOCATION');
              end;
            end;

            vSLExcept.Append('Delete modules_magasins');
            vQry.SQL.Append('update modules_magasins set');
            vQry.SQL.Append('MMAG_KENABLED=0');
            vQry.SQL.Append('Where MMAG_MAGAID=' + IntToStr(MAGA_ID));
            vQry.SQL.Append('and MMAG_MODUID=' + IntToStr(MODU_ID));
            vQry.ExecSQL;
          end;
      end;

      FAdmGINKOIA.Transaction.Commit;
      dmMaintenance.Transaction.Commit;
    except
      on E: Exception do
      begin
        FAdmGINKOIA.Transaction.Rollback;
        dmMaintenance.Transaction.Rollback;
        vSLExcept.Append('TModuleGinkoia.MAJ');
        vSLExcept.Append(E.Message);
        GWSConfig.SaveFile(GWSConfig.ServiceFileName + GWSConfig.GetTime + '_TModuleGinkoia_TModuleGinkoia_MAJ.Except', vSLExcept,
          GWSConfig.LogException);
        Raise Exception.Create(ClassName + '.MAJ ' + UpdateKindToStr(AAction) + cRC + E.Message);
      end;
    end;
  finally
    FreeAndNil(vQry);
    FreeAndNil(vQryMOD_MAG);
    FreeAndNil(vQryGINKOIA);
    FreeAndNil(FAdmGINKOIA);
    FreeAndNil(vSLExcept);
  end;
end;

{ TConnexion }

function TConnexion.GetCON_LAUID: integer;
begin
  Result := inherited GetCON_LAUID;
  if (FEmetteur <> nil) and (Result < 1) then
    Result := FEmetteur.LAU_ID;
end;

function TConnexion.GetDOSS_ID: integer;
begin
  Result := FDOSS_ID;
  if FEmetteur <> nil then
    Result := FEmetteur.EMET_DOSSID;
end;

function TConnexion.GetEMET_ID: integer;
begin
  Result := FEMET_ID;
  if FEmetteur <> nil then
    Result := FEmetteur.EMET_ID;
end;

procedure TConnexion.MAJ(const AAction: TUpdateKind);
var
  vQry: TFDQuery;
begin
  inherited;
  try
    if FAdmGINKOIA = nil then
      FAdmGINKOIA := ConnectToGINKOIA(AEmetteur.ADossier.DOSS_CHEMIN);
    vQry := FAdmGINKOIA.GetNewQry;
    try
      if not FAdmGINKOIA.Transaction.Active then
        FAdmGINKOIA.Transaction.StartTransaction;
      case AAction of
        ukModify:
          begin
            FAdmGINKOIA.UpdateK(CON_ID, 0);

            vQry.SQL.Text := cSql_U_GENCONNEXION;

            vQry.ParamByName('PCON_LAUID').AsInteger := CON_LAUID;
            vQry.ParamByName('PCON_NOM').AsString := CON_NOM;
            vQry.ParamByName('PCON_TEL').AsString := CON_TEL;
            vQry.ParamByName('PCON_TYPE').AsInteger := CON_TYPE;
            vQry.ParamByName('PCON_ORDRE').AsInteger := CON_ORDRE;
            vQry.ParamByName('PCON_ID').AsInteger := CON_ID;
            vQry.ExecSQL;
          end;
        ukInsert:
          begin
            CON_ID := FAdmGINKOIA.GetNewID('GENCONNEXION');

            vQry.SQL.Text := cSql_I_GENCONNEXION;

            vQry.ParamByName('PCON_LAUID').AsInteger := CON_LAUID;
            vQry.ParamByName('PCON_NOM').AsString := CON_NOM;
            vQry.ParamByName('PCON_TEL').AsString := CON_TEL;
            vQry.ParamByName('PCON_TYPE').AsInteger := CON_TYPE;
            vQry.ParamByName('PCON_ORDRE').AsInteger := CON_ORDRE;
            vQry.ParamByName('PCON_ID').AsInteger := CON_ID;
            vQry.ExecSQL;
          end;
        ukDelete:
          begin
            FAdmGINKOIA.UpdateK(CON_ID, 1);
          end;
      end;
      FAdmGINKOIA.Transaction.Commit;
    except
      on E: Exception do
      begin
        FAdmGINKOIA.Transaction.Rollback;
        Raise Exception.Create(ClassName + '.MAJ ' + UpdateKindToStr(AAction) + cRC + E.Message);
      end;
    end;
  finally
    FreeAndNil(vQry);
    FreeAndNil(FAdmGINKOIA);
  end;
end;

procedure TConnexion.SetValuesByDataSet(const ADS: TDataSet; const ADOSSID: integer; const AEMET_ID: integer);
var
  vField: TField;
begin
  inherited SetValuesByDataSet(ADS);

  // vField:= ADS.FindField('DOSS_ID');
  // if vField <> nil then
  DOSS_ID := ADOSSID; // vField.AsInteger;

  // vField:= ADS.FindField('EMET_ID');
  // if vField <> nil then
  EMET_ID := AEMET_ID; // vField.AsInteger;

end;

{ TSrvReplication }

procedure TSrvReplication.MAJ(const AAction: TUpdateKind);
var
  vQry: TFDQuery;
begin
  inherited;
  try
    vQry := dmMaintenance.GetNewQry;
    try
      if not dmMaintenance.Transaction.Active then
        dmMaintenance.Transaction.StartTransaction;
      case AAction of
        ukInsert:
          begin
            if SVR_PATH = '' then
              Exit;

            vQry.SQL.Append('Select * from SUIVISVR where');
            vQry.SQL.Append('SSVR_SERVID =' + IntToStr(SRV_ID));
            vQry.SQL.Append('and SVR_PATH =' + QuotedStr(SVR_PATH));
            vQry.Open;

            if vQry.Eof then
            begin
              vQry.SQL.Text := cSql_I_SUIVISVR;

              vQry.ParamByName('PSSRVSERVID').AsInteger := SRV_ID;
              vQry.ParamByName('PSSVRPATH').AsString := SVR_PATH;

              vQry.ExecSQL;
            end;
          end;
        ukDelete:
          begin
            vQry.SQL.Append('Delete from SUIVISVR where ');
            vQry.SQL.Append('SSVR_SERVID =' + IntToStr(SRV_ID));
            vQry.SQL.Append('and SSVR_PATH =' + QuotedStr(SVR_PATH));
            vQry.ExecSQL;

            if (Trim(SVR_PATH) <> '') and (FileExists(SVR_PATH)) then
              DeleteFile(SVR_PATH);
          end;
      end;

      dmMaintenance.Transaction.Commit;
    except
      on E: Exception do
      begin
        dmMaintenance.Transaction.Rollback;
        Raise Exception.Create(ClassName + '.MAJ ' + UpdateKindToStr(AAction) + cRC + E.Message);
      end;
    end;
  finally
    FreeAndNil(vQry);
  end;
end;

{ TModeleMail }

procedure TModeleMail.SetMAIL_FILENAME(const Value: String);
begin
  FMAIL_FILENAME := Value;
  if FMAIL_FILENAME <> '' then
    FMAIL_NAME := ChangeFileExt(ExtractFileName(FMAIL_FILENAME), '');
end;

{ TGnkSplittageLog }

procedure TGnkSplittageLog.AddEVENTLOG(const ASLValue: TStrings);
var
  vQry: TFDQuery;
  vStream: TMemoryStream;
begin
  inherited;
  ASLValue.Clear;
  try
    vQry := dmMaintenance.GetNewQry;
    vStream := TMemoryStream.Create;

    vQry.SQL.Append('Select SPLI_EVENTLOG from SPLITTAGE_LOG where SPLI_NOSPLIT = :PNOSPLIT');
    vQry.ParamByName('PNOSPLIT').AsInteger := SPLI_NOSPLIT;
    vQry.Open;

    if not vQry.Eof then
    begin
      TBlobField(vQry.FieldByName('SPLI_EVENTLOG')).SaveToStream(vStream);
      vStream.Position := 0;
      ASLValue.LoadFromStream(vStream);
    end;

    if ASLValue.Count <> 0 then
    begin
      ASLValue.Append('');
      ASLValue.Text := ASLValue.Text + Trim(SPLI_EVENTLOG);
    end
    else
      ASLValue.Text := Trim(SPLI_EVENTLOG);
  finally
    FreeAndNil(vQry);
    FreeAndNil(vStream);
  end;
end;

constructor TGnkSplittageLog.Create(AOwner: TComponent);
begin
  inherited;
  SPLI_NOSPLIT := 0;
  SPLI_DATEHEURESTART := 0;
  SPLI_DATEHEUREEND := 0;
end;

function TGnkSplittageLog.GetLastOrdre: integer;
var
  vQry: TFDQuery;
begin
  Result := 0;
  try
    vQry := dmMaintenance.GetNewQry;
    vQry.SQL.Text := 'SELECT MAX(SPLI_ORDRE) AS ARESULT FROM SPLITTAGE_LOG WHERE SPLI_STARTED = 0';
    vQry.Open;

    if not vQry.Eof then
      Result := vQry.FieldByName('ARESULT').AsInteger;

  finally
    FreeAndNil(vQry);
  end;
end;

procedure TGnkSplittageLog.MAJ(const AAction: TUpdateKind);
var
  vQry: TFDQuery;
  vSL: TStrings;
  myStream: TMemoryStream;
begin
  inherited;
  try
    vQry := dmMaintenance.GetNewQry;
    try
      if not dmMaintenance.Transaction.Active then
        dmMaintenance.Transaction.StartTransaction;
      case AAction of
        ukInsert:
          begin
            SPLI_NOSPLIT := dmMaintenance.GetNewID('SPLITTAGE_LOG');
            SPLI_ORDRE := GetLastOrdre + 1;

            vQry.SQL.Text := cSql_I_SPLITTAGE_LOG;

            vQry.ParamByName('PNOSPLIT').AsInteger := SPLI_NOSPLIT;
            vQry.ParamByName('PEMET_ID').AsInteger := SPLI_EMETID;
            vQry.ParamByName('PEMET_NOM').AsString := SPLI_EMETNOM;
            vQry.ParamByName('PTYPESPLIT').AsString := SPLI_TYPESPLIT;
            vQry.ParamByName('PUSERNAME').AsString := SPLI_USERNAME;
            vQry.ParamByName('PCLEARFILES').AsInteger := SPLI_CLEARFILES;
            vQry.ParamByName('PORDRE').AsInteger := SPLI_ORDRE;
            vQry.ParamByName('PBASE').AsInteger := SPLI_BASE;
            vQry.ParamByName('PMAIL').AsInteger := SPLI_MAIL;
          end;
        ukModify:
          begin
            vSL := TStringList.Create;
            try
              AddEVENTLOG(vSL);

              vQry.SQL.Append('update SPLITTAGE_LOG set');
              if vSL.Count <> 0 then
                vQry.SQL.Append('SPLI_EVENTLOG=:PEVENTLOG,');
              vQry.SQL.Append('SPLI_TERMINATE=:PTERMINATE,');
              vQry.SQL.Append('SPLI_ERROR=:PERROR,');
              vQry.SQL.Append('SPLI_TYPESPLIT=:PTYPESPLIT,');

              if (SPLI_TERMINATE = 1) and (SPLI_DATEHEUREEND = 0) then
                vQry.SQL.Append('SPLI_DATEHEUREEND=:PDATEHEUREEND,');

              vQry.SQL.Append('SPLI_ORDRE=:PORDRE');
              vQry.SQL.Append('WHERE');
              vQry.SQL.Append('SPLI_NOSPLIT=:PNOSPLIT');

              vQry.ParamByName('PNOSPLIT').AsInteger := SPLI_NOSPLIT;
              if vSL.Count <> 0 then
              begin
                // SR : Correction pour l'enregistrement du Blob
                myStream := TMemoryStream.Create;
                try
                  vSL.SaveToStream(myStream);
                  vQry.ParamByName('PEVENTLOG').LoadFromStream(myStream, ftBlob);
                finally
                  FreeAndNil(myStream);
                end;
              end;
              vQry.ParamByName('PTERMINATE').AsInteger := SPLI_TERMINATE;
              vQry.ParamByName('PERROR').AsInteger := SPLI_ERROR;
              vQry.ParamByName('PORDRE').AsInteger := SPLI_ORDRE;
              vQry.ParamByName('PTYPESPLIT').AsString := SPLI_TYPESPLIT;

              if (SPLI_TERMINATE = 1) and (SPLI_DATEHEUREEND = 0) then
                vQry.ParamByName('PDATEHEUREEND').AsDateTime := Now;
            finally
              FreeAndNil(vSL);
            end;
          end;
        ukDelete:
          begin
            vQry.SQL.Append('Delete from SPLITTAGE_LOG where SPLI_NOSPLIT = :PNOSPLIT');
            vQry.ParamByName('PNOSPLIT').AsInteger := SPLI_NOSPLIT;
          end;
      end;

      vQry.ExecSQL;

      dmMaintenance.Transaction.Commit;
    except
      on E: Exception do
      begin
        dmMaintenance.Transaction.Rollback;
        Raise Exception.Create(ClassName + '.MAJ ' + UpdateKindToStr(AAction) + cRC + E.Message);
      end;
    end;
  finally
    FreeAndNil(vQry);
  end;
end;

procedure TGnkSplittageLog.SetStart;
var
  vQry: TFDQuery;
  vSL: TStrings;
begin
  inherited;
  if SPLI_STARTED <> 1 then
    Exit;

  try
    vSL := TStringList.Create;
    vQry := dmMaintenance.GetNewQry;
    try
      if not dmMaintenance.Transaction.Active then
        dmMaintenance.Transaction.StartTransaction;

      AddEVENTLOG(vSL);

      vQry.SQL.Append('update SPLITTAGE_LOG set');
      vQry.SQL.Append('SPLI_DATEHEURESTART=:PDATEHEURESTART,');
      vQry.SQL.Append('SPLI_STARTED=:PSTARTED,');
      if vSL.Count <> 0 then
        vQry.SQL.Append('SPLI_EVENTLOG=:PEVENTLOG');

      vQry.SQL.Append('WHERE');
      vQry.SQL.Append('SPLI_NOSPLIT=:PNOSPLIT');

      vQry.ParamByName('PNOSPLIT').AsInteger := SPLI_NOSPLIT;
      vQry.ParamByName('PSTARTED').AsInteger := SPLI_STARTED;
      vQry.ParamByName('PDATEHEURESTART').AsDateTime := SPLI_DATEHEURESTART;
      if vSL.Count <> 0 then
        vQry.ParamByName('PEVENTLOG').Assign(vSL);
      vQry.ExecSQL;

      dmMaintenance.Transaction.Commit;
    except
      on E: Exception do
      begin
        dmMaintenance.Transaction.Rollback;
        Raise Exception.Create(ClassName + '.SetStart ' + cRC + E.Message);
      end;
    end;
  finally
    FreeAndNil(vQry);
    FreeAndNil(vSL);
  end;
end;

procedure TGnkSplittageLog.SetValuesByDataSet(const ADS: TDataSet);
var
  vField: TField;
begin
  vField := ADS.FindField('SPLI_NOSPLIT');
  if vField <> nil then
    SPLI_NOSPLIT := vField.AsInteger;

  vField := ADS.FindField('SPLI_EMETID');
  if vField <> nil then
    SPLI_EMETID := vField.AsInteger;

  vField := ADS.FindField('SPLI_EMETNOM');
  if vField <> nil then
    SPLI_EMETNOM := vField.AsString;

  vField := ADS.FindField('SPLI_DATEHEURESTART');
  if vField <> nil then
    SPLI_DATEHEURESTART := vField.AsDateTime;

  vField := ADS.FindField('SPLI_DATEHEUREEND');
  if vField <> nil then
    SPLI_DATEHEUREEND := vField.AsDateTime;

  vField := ADS.FindField('SPLI_EVENTLOG');
  if vField <> nil then
    SPLI_EVENTLOG := vField.AsString;

  vField := ADS.FindField('SPLI_ORDRE');
  if vField <> nil then
    SPLI_ORDRE := vField.AsInteger;

  vField := ADS.FindField('SPLI_STARTED');
  if vField <> nil then
    SPLI_STARTED := vField.AsInteger;

  vField := ADS.FindField('SPLI_TERMINATE');
  if vField <> nil then
    SPLI_TERMINATE := vField.AsInteger;

  vField := ADS.FindField('SPLI_ERROR');
  if vField <> nil then
    SPLI_ERROR := vField.AsInteger;

  vField := ADS.FindField('SPLI_USERNAME');
  if vField <> nil then
    SPLI_USERNAME := vField.AsString;

  vField := ADS.FindField('SPLI_TYPESPLIT');
  if vField <> nil then
    SPLI_TYPESPLIT := vField.AsString;

  vField := ADS.FindField('SPLI_CLEARFILES');
  if vField <> nil then
    SPLI_CLEARFILES := vField.AsInteger;

  vField := ADS.FindField('SPLI_BASE');
  if vField <> nil then
    SPLI_BASE := vField.AsInteger;

  vField := ADS.FindField('SPLI_MAIL');
  if vField <> nil then
    SPLI_MAIL := vField.AsInteger;
end;

{ TGnkGenReplication }

function TGnkGenReplication.GetLastOrdre: integer;
var
  vQry: TFDQuery;
begin
  Result := 0;
  try
    vQry := AdmGINKOIA.GetNewQry;
    if REP_ORDRE >= 0 then
      vQry.SQL.Text := 'SELECT MAX(REP_ORDRE) AS ARESULT FROM GENREPLICATION Join K on (K_ID = REP_ID and K_ENABLED = 1)'
    else
      vQry.SQL.Text := 'SELECT MIN(REP_ORDRE) AS ARESULT FROM GENREPLICATION Join K on (K_ID = REP_ID and K_ENABLED = 1)';

    vQry.Open;

    if not vQry.Eof then
      Result := vQry.FieldByName('ARESULT').AsInteger;

  finally
    FreeAndNil(vQry);
  end;
end;

procedure TGnkGenReplication.MAJ(const AAction: TUpdateKind);
var
  vOrdre: integer;
  vQry, vQryS: TFDQuery;
  bREPJOUR, bREPEXEFINREPLIC: Boolean;
begin
  inherited;
  try
    if AdmGINKOIA = nil then
      Raise Exception.Create('DataModule Ginkoia introuvable.');

    vQry := AdmGINKOIA.GetNewQry;
    vQryS := AdmGINKOIA.GetNewQry;
    try
      vQryS.SQL.Text := Format(cSqlListFieldByTableName, ['GENREPLICATION']);
      vQryS.Open;
      vQryS.First;

      bREPJOUR := False;
      bREPEXEFINREPLIC := False;

      while not vQryS.Eof do
      begin
        if vQryS.FieldByName('FIELD_NAME').AsString = 'REP_JOUR' then
          bREPJOUR := True
        else if vQryS.FieldByName('FIELD_NAME').AsString = 'REP_EXEFINREPLIC' then
          bREPEXEFINREPLIC := True;
        vQryS.Next;
      end;
      if not AdmGINKOIA.Transaction.Active then
        AdmGINKOIA.Transaction.StartTransaction;

      case AAction of
        ukInsert:
          begin
            REP_ID := AdmGINKOIA.GetNewID('GENREPLICATION');

            vOrdre := GetLastOrdre;
            if REP_ORDRE >= 0 then
              Inc(vOrdre)
            else
            begin
              if vOrdre = 1 then
                Dec(vOrdre);

              Dec(vOrdre); // --> Gestion Web
            end;

            REP_ORDRE := vOrdre;

            vQry.SQL.Append('insert into GENREPLICATION (');
            vQry.SQL.Append('REP_ID,');
            vQry.SQL.Append('REP_LAUID,');
            vQry.SQL.Append('REP_PING,');
            vQry.SQL.Append('REP_PUSH,');
            vQry.SQL.Append('REP_PULL,');
            vQry.SQL.Append('REP_USER,');
            vQry.SQL.Append('REP_PWD,');
            vQry.SQL.Append('REP_ORDRE,');

            if bREPJOUR then
              vQry.SQL.Append('REP_JOUR,');

            if bREPEXEFINREPLIC then
              vQry.SQL.Append('REP_EXEFINREPLIC,');

            vQry.SQL.Append('REP_URLLOCAL,');
            vQry.SQL.Append('REP_URLDISTANT,');
            vQry.SQL.Append('REP_PLACEEAI,');
            vQry.SQL.Append('REP_PLACEBASE');

            vQry.SQL.Append(') Values (');
            vQry.SQL.Append(':PREP_ID,');
            vQry.SQL.Append(':PREP_LAUID,');
            vQry.SQL.Append(':PREP_PING,');
            vQry.SQL.Append(':PREP_PUSH,');
            vQry.SQL.Append(':PREP_PULL,');
            vQry.SQL.Append(':PREP_USER,');
            vQry.SQL.Append(':PREP_PWD,');
            vQry.SQL.Append(':PREP_ORDRE,');

            if bREPJOUR then
              vQry.SQL.Append(':PREP_JOUR,');

            if bREPEXEFINREPLIC then
              vQry.SQL.Append(':PREP_EXEFINREPLIC,');

            vQry.SQL.Append(':PREP_URLLOCAL,');
            vQry.SQL.Append(':PREP_URLDISTANT,');
            vQry.SQL.Append(':PREP_PLACEEAI,');
            vQry.SQL.Append(':PREP_PLACEBASE');
            vQry.SQL.Append(')');
          end;
        ukModify:
          begin
            AdmGINKOIA.UpdateK(REP_ID, 0);

            vQry.SQL.Append('update GENREPLICATION Set');
            vQry.SQL.Append('REP_LAUID = :PREP_LAUID,');
            vQry.SQL.Append('REP_ORDRE = :PREP_ORDRE,');
            vQry.SQL.Append('REP_PING = :PREP_PING,');
            vQry.SQL.Append('REP_PLACEBASE = :PREP_PLACEBASE,');
            vQry.SQL.Append('REP_PLACEEAI = :PREP_PLACEEAI,');
            vQry.SQL.Append('REP_PULL = :PREP_PULL,');
            vQry.SQL.Append('REP_PUSH = :PREP_PUSH,');
            vQry.SQL.Append('REP_PWD = :PREP_PWD,');

            if bREPJOUR then
              vQry.SQL.Append('REP_JOUR = :PREP_JOUR,');

            if bREPEXEFINREPLIC then
              vQry.SQL.Append('REP_EXEFINREPLIC = :PREP_EXEFINREPLIC,');

            vQry.SQL.Append('REP_URLDISTANT = :PREP_URLDISTANT,');
            vQry.SQL.Append('REP_URLLOCAL = :PREP_URLLOCAL,');
            vQry.SQL.Append('REP_USER = :PREP_USER');

            vQry.SQL.Append('where');
            vQry.SQL.Append('REP_ID = :PREP_ID');
          end;
        ukDelete:
          begin
            vQry.SQL.Text := 'Select GLR_ID from GENLIAIREPLI where GLR_REPID=:PREPID';
            vQry.ParamByName('PREPID').AsInteger := REP_ID;

            if not vQry.Eof then
            begin
              while not vQry.Eof do
              begin
                AdmGINKOIA.UpdateK(vQry.FieldByName('GLR_ID').AsInteger, 1);
                vQry.Next;
              end;
            end;

            AdmGINKOIA.UpdateK(REP_ID, 1);
          end;
      end;

      if AAction in [ukInsert, ukModify] then
      begin
        vQry.ParamByName('PREP_ID').AsInteger := REP_ID;
        vQry.ParamByName('PREP_LAUID').AsInteger := REP_LAUID;
        vQry.ParamByName('PREP_PING').AsString := REP_PING;
        vQry.ParamByName('PREP_PUSH').AsString := REP_PUSH;
        vQry.ParamByName('PREP_PULL').AsString := REP_PULL;
        vQry.ParamByName('PREP_USER').AsString := REP_USER;
        vQry.ParamByName('PREP_PWD').AsString := REP_PWD;
        vQry.ParamByName('PREP_ORDRE').AsInteger := REP_ORDRE;
        vQry.ParamByName('PREP_URLLOCAL').AsString := REP_URLLOCAL;
        vQry.ParamByName('PREP_URLDISTANT').AsString := REP_URLDISTANT;
        vQry.ParamByName('PREP_PLACEEAI').AsString := REP_PLACEEAI;
        vQry.ParamByName('PREP_PLACEBASE').AsString := REP_PLACEBASE;

        if bREPJOUR then
          vQry.ParamByName('PREP_JOUR').AsInteger := REP_JOUR;

        if bREPEXEFINREPLIC then
          vQry.ParamByName('PREP_EXEFINREPLIC').AsString := REP_EXEFINREPLIC;

        vQry.ExecSQL;
      end;

      AdmGINKOIA.Transaction.Commit;
    except
      on E: Exception do
      begin
        AdmGINKOIA.Transaction.Rollback;
        Raise;
      end;
    end;
  finally
    FreeAndNil(vQry);
    FreeAndNil(vQryS);
  end;
end;

procedure TGnkGenReplication.SetValuesByDataSet(const ADS: TDataSet);
var
  vField: TField;
begin
  vField := ADS.FindField('REP_ID');
  if vField <> nil then
    REP_ID := vField.AsInteger;

  vField := ADS.FindField('REP_LAUID');
  if vField <> nil then
    REP_LAUID := vField.AsInteger;

  vField := ADS.FindField('REP_PING');
  if vField <> nil then
    REP_PING := vField.AsString;

  vField := ADS.FindField('REP_PUSH');
  if vField <> nil then
    REP_PUSH := vField.AsString;

  vField := ADS.FindField('REP_PULL');
  if vField <> nil then
    REP_PULL := vField.AsString;

  vField := ADS.FindField('REP_USER');
  if vField <> nil then
    REP_USER := vField.AsString;

  vField := ADS.FindField('REP_PWD');
  if vField <> nil then
    REP_PWD := vField.AsString;

  vField := ADS.FindField('REP_ORDRE');
  if vField <> nil then
    REP_ORDRE := vField.AsInteger;

  vField := ADS.FindField('REP_URLLOCAL');
  if vField <> nil then
    REP_URLLOCAL := vField.AsString;

  vField := ADS.FindField('REP_URLDISTANT');
  if vField <> nil then
    REP_URLDISTANT := vField.AsString;

  vField := ADS.FindField('REP_PLACEEAI');
  if vField <> nil then
    REP_PLACEEAI := vField.AsString;

  vField := ADS.FindField('REP_PLACEBASE');
  if vField <> nil then
    REP_PLACEBASE := vField.AsString;

  vField := ADS.FindField('REP_JOUR');
  if vField <> nil then
    REP_JOUR := vField.AsInteger;

  vField := ADS.FindField('REP_EXEFINREPLIC');
  if vField <> nil then
    REP_EXEFINREPLIC := vField.AsString;
end;

{ TGnkGenLaunch }

procedure TGnkGenLaunch.MAJ(const AAction: TUpdateKind);
var
  vQry: TFDQuery;
begin
  inherited;

  try
    if AdmGINKOIA = nil then
      Raise Exception.Create('DataModule Ginkoia introuvable.');

    vQry := AdmGINKOIA.GetNewQry;
    try
      if not AdmGINKOIA.Transaction.Active then
        AdmGINKOIA.Transaction.StartTransaction;
      case AAction of
        ukInsert:
          begin
            LAU_ID := AdmGINKOIA.GetNewID('GENLAUNCH');
            vQry.SQL.Text := cSQL_I_GenLaunch;
          end;
        ukModify:
          begin
            AdmGINKOIA.UpdateK(LAU_ID, 0);
            vQry.SQL.Text := cSQL_U_GenLaunch;
          end;
      end;

      vQry.ParamByName('PLAUID').AsInteger := LAU_ID;
      vQry.ParamByName('PLAUBASID').AsInteger := LAU_BASID;
      if LAU_HEURE1 > 0 then
        vQry.ParamByName('PLAUHEURE1').AsDateTime := StrToDateTime(FormatDateTime(cFormatDT, LAU_HEURE1), FormatSettings)
      else
        vQry.ParamByName('PLAUHEURE1').Clear;
      vQry.ParamByName('PLAUH1').AsInteger := LAU_H1;
      if LAU_HEURE2 > 0 then
        vQry.ParamByName('PLAUHEURE2').AsDateTime := StrToDateTime(FormatDateTime(cFormatDT, LAU_HEURE2), FormatSettings)
      else
        vQry.ParamByName('PLAUHEURE2').Clear;
      vQry.ParamByName('PLAUH2').AsInteger := LAU_H2;
      vQry.ParamByName('PLAUAUTORUN').AsInteger := LAU_AUTORUN;
      vQry.ParamByName('PLAUBACK').AsInteger := LAU_BACK;
      if LAU_BACKTIME > 0 then
        vQry.ParamByName('PLAUBACKTIME').AsDateTime := StrToDateTime(FormatDateTime(cFormatDT, LAU_BACKTIME), FormatSettings)
      else
        vQry.ParamByName('PLAUBACKTIME').Clear;

      vQry.ExecSQL;

      AdmGINKOIA.Transaction.Commit;
    except
      on E: Exception do
      begin
        AdmGINKOIA.Transaction.Rollback;
        Raise;
      end;
    end;
  finally
    FreeAndNil(vQry);
  end;
end;

procedure TGnkGenLaunch.SetValuesByDataSet(const ADS: TDataSet);
var
  vField: TField;
begin
  vField := ADS.FindField('LAU_ID');
  if vField <> nil then
    LAU_ID := vField.AsInteger;

  vField := ADS.FindField('LAU_BASID');
  if vField <> nil then
    LAU_BASID := vField.AsInteger;

  vField := ADS.FindField('LAU_HEURE1');
  if vField <> nil then
    LAU_HEURE1 := vField.AsDateTime;

  vField := ADS.FindField('LAU_H1');
  if vField <> nil then
    LAU_H1 := vField.AsInteger;

  vField := ADS.FindField('LAU_HEURE2');
  if vField <> nil then
    LAU_HEURE2 := vField.AsDateTime;

  vField := ADS.FindField('LAU_H2');
  if vField <> nil then
    LAU_H2 := vField.AsInteger;

  vField := ADS.FindField('LAU_AUTORUN');
  if vField <> nil then
    LAU_AUTORUN := vField.AsInteger;

  vField := ADS.FindField('LAU_BACK');
  if vField <> nil then
    LAU_BACK := vField.AsInteger;

  vField := ADS.FindField('LAU_BACKTIME');
  if vField <> nil then
    LAU_BACKTIME := vField.AsDateTime;
end;

{ TGnkGenLiaiRepli }

constructor TGnkGenLiaiRepli.Create(AOwner: TComponent);
begin
  inherited;
  UsedTransaction := True;
end;

procedure TGnkGenLiaiRepli.MAJ(const AAction: TUpdateKind);
var
  vQry, vQryS: TFDQuery;
  bGLRLASTVERSION: Boolean;
begin
  inherited;
  try
    if AdmGINKOIA = nil then
      Raise Exception.Create('DataModule Ginkoia introuvable.');

    vQry := AdmGINKOIA.GetNewQry;
    vQryS := AdmGINKOIA.GetNewQry;
    try
      vQryS.SQL.Text := Format(cSqlListFieldByTableName, ['GENLIAIREPLI']);
      vQryS.Open;
      vQryS.First;

      bGLRLASTVERSION := False;

      while not vQryS.Eof do
      begin
        if vQryS.FieldByName('FIELD_NAME').AsString = 'GLR_LASTVERSION' then
          bGLRLASTVERSION := True;
        vQryS.Next;
      end;

      if UsedTransaction then
      begin
        if not AdmGINKOIA.Transaction.Active then
          AdmGINKOIA.Transaction.StartTransaction;
      end;
      case AAction of
        ukInsert:
          begin
            GLR_ID := AdmGINKOIA.GetNewID('GENLIAIREPLI');

            vQry.SQL.Append('insert into GENLIAIREPLI (');
            vQry.SQL.Append('GLR_ID,');
            vQry.SQL.Append('GLR_REPID,');

            if bGLRLASTVERSION then
              vQry.SQL.Append('GLR_LASTVERSION,');

            vQry.SQL.Append('GLR_PROSUBID');

            vQry.SQL.Append(') Values (');
            vQry.SQL.Append(':PGLR_ID,');
            vQry.SQL.Append(':PGLR_REPID,');

            if bGLRLASTVERSION then
              vQry.SQL.Append('null,');

            vQry.SQL.Append(':PGLR_PROSUBID');

            vQry.SQL.Append(')');
          end;
        ukModify:
          begin
            AdmGINKOIA.UpdateK(GLR_ID, 0);

            vQry.SQL.Append('update GENLIAIREPLI Set');
            vQry.SQL.Append('GLR_REPID=:PGLR_REPID,');

            if bGLRLASTVERSION then
              vQry.SQL.Append('GLR_LASTVERSION=:PGLR_LASTVERSION,');

            vQry.SQL.Append('GLR_PROSUBID=:PGLR_PROSUBID');
            vQry.SQL.Append('where');
            vQry.SQL.Append('GLR_ID = :PGLR_ID');

            if bGLRLASTVERSION then
              vQry.ParamByName('PGLR_LASTVERSION').AsString := GLR_LASTVERSION;
          end;

        ukDelete:
          AdmGINKOIA.UpdateK(GLR_ID, 1);
      end;

      if AAction in [ukInsert, ukModify] then
      begin
        vQry.ParamByName('PGLR_ID').AsInteger := GLR_ID;
        vQry.ParamByName('PGLR_REPID').AsInteger := GLR_REPID;
        vQry.ParamByName('PGLR_PROSUBID').AsInteger := GLR_PROSUBID;

        vQry.ExecSQL;
      end;

      if UsedTransaction then
        AdmGINKOIA.Transaction.Commit;
    except
      on E: Exception do
      begin
        if UsedTransaction then
          AdmGINKOIA.Transaction.Rollback;
        Raise;
      end;
    end;
  finally
    FreeAndNil(vQry);
    FreeAndNil(vQryS);
  end;
end;

procedure TGnkGenLiaiRepli.SetValuesByDataSet(const ADS: TDataSet);
var
  vField: TField;
begin
  vField := ADS.FindField('GLR_ID');
  if vField <> nil then
    GLR_ID := vField.AsInteger;

  vField := ADS.FindField('GLR_REPID');
  if vField <> nil then
    GLR_REPID := vField.AsInteger;

  vField := ADS.FindField('GLR_PROSUBID');
  if vField <> nil then
    GLR_PROSUBID := vField.AsInteger;

  vField := ADS.FindField('GLR_LASTVERSION');
  if vField <> nil then
    GLR_LASTVERSION := vField.AsString;
end;

{ TGnkGenProviders }

constructor TGnkGenProviders.Create(AOwner: TComponent);
begin
  inherited;
  FGenLiaiRepli := TGnkGenLiaiRepli.Create(Self);
  FGenLiaiRepli.UsedTransaction := False;
end;

function TGnkGenProviders.GetLastOrdre: integer;
var
  vQry: TFDQuery;
begin
  Result := 0;
  try
    vQry := AdmGINKOIA.GetNewQry;
    vQry.SQL.Text := 'SELECT MAX(PRO_ORDRE) AS ARESULT FROM GENPROVIDERS Join K on (K_ID = PRO_ID and K_ENABLED = 1)';
    vQry.Open;

    if not vQry.Eof then
      Result := vQry.FieldByName('ARESULT').AsInteger;

  finally
    FreeAndNil(vQry);
  end;
end;

procedure TGnkGenProviders.MAJ(const AAction: TUpdateKind);
var
  vQry: TFDQuery;
begin
  inherited;
  try
    if AdmGINKOIA = nil then
      Raise Exception.Create('DataModule Ginkoia introuvable.');

    vQry := AdmGINKOIA.GetNewQry;
    try
      if not AdmGINKOIA.Transaction.Active then
        AdmGINKOIA.Transaction.StartTransaction;
      case AAction of
        ukInsert:
          begin
            PRO_ID := AdmGINKOIA.GetNewID('GENPROVIDERS');

            PRO_ORDRE := GetLastOrdre + 1;

            vQry.SQL.Text := cSql_I_GENPROVIDERS;
          end;
        ukModify:
          begin
            AdmGINKOIA.UpdateK(PRO_ID, 0);

            vQry.SQL.Text := cSql_U_GENPROVIDERS;
          end;
        ukDelete:
          AdmGINKOIA.UpdateK(PRO_ID, 1);
      end;

      if AAction in [ukInsert, ukModify] then
      begin
        vQry.ParamByName('PPRO_ID').AsInteger := PRO_ID;
        vQry.ParamByName('PPRO_NOM').AsString := PRO_NOM;
        vQry.ParamByName('PPRO_ORDRE').AsInteger := PRO_ORDRE;
        vQry.ParamByName('PPRO_LOOP').AsInteger := PRO_LOOP;

        vQry.ExecSQL;
      end;

      AdmGINKOIA.Transaction.Commit;
    except
      on E: Exception do
      begin
        AdmGINKOIA.Transaction.Rollback;
        Raise;
      end;
    end;
  finally
    FreeAndNil(vQry);
  end;
end;

procedure TGnkGenProviders.SetDOSS_ID(const Value: integer);
begin
  inherited;
  AGenLiaiRepli.DOSS_ID := Value;
end;

procedure TGnkGenProviders.SetValuesByDataSet(const ADS: TDataSet);
var
  vField: TField;
begin
  vField := ADS.FindField('PRO_ID');
  if vField <> nil then
    PRO_ID := vField.AsInteger;

  vField := ADS.FindField('PRO_NOM');
  if vField <> nil then
    PRO_NOM := vField.AsString;

  vField := ADS.FindField('PRO_ORDRE');
  if vField <> nil then
    PRO_ORDRE := vField.AsInteger;

  vField := ADS.FindField('PRO_LOOP');
  if vField <> nil then
    PRO_LOOP := vField.AsInteger;

  AGenLiaiRepli.SetValuesByDataSet(ADS);
end;

{ TGnkGenSubscribers }

constructor TGnkGenSubscribers.Create(AOwner: TComponent);
begin
  inherited;
  FGenLiaiRepli := TGnkGenLiaiRepli.Create(Self);
  FGenLiaiRepli.UsedTransaction := False;
end;

function TGnkGenSubscribers.GetLastOrdre: integer;
var
  vQry: TFDQuery;
begin
  Result := 0;
  try
    vQry := AdmGINKOIA.GetNewQry;
    vQry.SQL.Text := 'SELECT MAX(SUB_ORDRE) AS ARESULT FROM GENSUBSCRIBERS Join K on (K_ID = SUB_ID and K_ENABLED = 1)';
    vQry.Open;

    if not vQry.Eof then
      Result := vQry.FieldByName('ARESULT').AsInteger;

  finally
    FreeAndNil(vQry);
  end;
end;

procedure TGnkGenSubscribers.MAJ(const AAction: TUpdateKind);
var
  vQry: TFDQuery;
begin
  inherited;
  try
    if AdmGINKOIA = nil then
      Raise Exception.Create('DataModule Ginkoia introuvable.');

    vQry := AdmGINKOIA.GetNewQry;
    try
      if not AdmGINKOIA.Transaction.Active then
        AdmGINKOIA.Transaction.StartTransaction;
      case AAction of
        ukInsert:
          begin
            SUB_ID := AdmGINKOIA.GetNewID('GENSUBSCRIBERS');

            SUB_ORDRE := GetLastOrdre + 1;

            vQry.SQL.Text := cSql_I_GENSUBSCRIBERS;
          end;
        ukModify:
          begin
            AdmGINKOIA.UpdateK(SUB_ID, 0);

            vQry.SQL.Text := cSql_U_GENSUBSCRIBERS;
          end;
        ukDelete:
          AdmGINKOIA.UpdateK(SUB_ID, 1);
      end;

      if AAction in [ukInsert, ukModify] then
      begin
        vQry.ParamByName('PSUB_ID').AsInteger := SUB_ID;
        vQry.ParamByName('PSUB_NOM').AsString := SUB_NOM;
        vQry.ParamByName('PSUB_ORDRE').AsInteger := SUB_ORDRE;
        vQry.ParamByName('PSUB_LOOP').AsInteger := SUB_LOOP;

        vQry.ExecSQL;
      end;

      AdmGINKOIA.Transaction.Commit;
    except
      on E: Exception do
      begin
        AdmGINKOIA.Transaction.Rollback;
        Raise;
      end;
    end;
  finally
    FreeAndNil(vQry);
  end;
end;

procedure TGnkGenSubscribers.SetDOSS_ID(const Value: integer);
begin
  inherited;
  AGenLiaiRepli.DOSS_ID := Value;
end;

procedure TGnkGenSubscribers.SetValuesByDataSet(const ADS: TDataSet);
var
  vField: TField;
begin
  vField := ADS.FindField('SUB_ID');
  if vField <> nil then
    SUB_ID := vField.AsInteger;

  vField := ADS.FindField('SUB_NOM');
  if vField <> nil then
    SUB_NOM := vField.AsString;

  vField := ADS.FindField('SUB_ORDRE');
  if vField <> nil then
    SUB_ORDRE := vField.AsInteger;

  vField := ADS.FindField('SUB_LOOP');
  if vField <> nil then
    SUB_LOOP := vField.AsInteger;

  AGenLiaiRepli.SetValuesByDataSet(ADS);
end;

{ TGroupe }

procedure TGroupe.MAJ(const AAction: TUpdateKind);
var
  vQry: TFDQuery;
begin
  inherited;
  try
    vQry := dmMaintenance.GetNewQry;
    try
      if not dmMaintenance.Transaction.Active then
        dmMaintenance.Transaction.StartTransaction;
      case AAction of
        ukInsert:
          begin
            GROU_ID := dmMaintenance.GetNewID('GROUPE');
            vQry.SQL.Text := cSql_I_Groupe;
          end;

        ukModify:
          vQry.SQL.Text := cSql_U_Groupe;
        ukDelete:
          vQry.SQL.Text := 'DELETE FROM GROUPE WHERE GROU_ID = ' + IntToStr(GROU_ID);
      end;

      if AAction in [ukInsert, ukModify] then
      begin
        vQry.ParamByName('PGROUID').AsInteger := GROU_ID;
        vQry.ParamByName('PGROUNOM').AsString := GROU_NOM;
      end;

      vQry.ExecSQL;

      dmMaintenance.Transaction.Commit;
    except
      on E: Exception do
      begin
        dmMaintenance.Transaction.Rollback;
        Raise Exception.Create(ClassName + '.MAJ ' + UpdateKindToStr(AAction) + cRC + E.Message);
      end;
    end;
  finally
    FreeAndNil(vQry);
  end;
end;

{ TVersion }

procedure TVersion.MAJ(const AAction: TUpdateKind);
var
  vQry: TFDQuery;
begin
  inherited;
  try
    vQry := dmMaintenance.GetNewQry;
    try
      if not dmMaintenance.Transaction.Active then
        dmMaintenance.Transaction.StartTransaction;
      case AAction of
        ukInsert:
          begin
            VERS_ID := dmMaintenance.GetNewID('VERSION');

            vQry.SQL.Text := cSql_I_version;
          end;

        ukModify:
          vQry.SQL.Text := cSql_U_version;
        ukDelete:
          vQry.SQL.Text := 'Delete from version where VERS_ID = ' + IntToStr(VERS_ID);
      end;

      if AAction in [ukInsert, ukModify] then
      begin
        vQry.ParamByName('PVERSVERSION').AsString := VERS_VERSION;
        vQry.ParamByName('PVERSNOMVERSION').AsString := VERS_NOMVERSION;
        vQry.ParamByName('PVERSPATCH').AsInteger := VERS_PATCH;
        vQry.ParamByName('PVERSEAI').AsString := VERS_EAI;
        vQry.ParamByName('PVERSID').AsInteger := VERS_ID;
      end;

      vQry.ExecSQL;

      dmMaintenance.Transaction.Commit;
    except
      on E: Exception do
      begin
        dmMaintenance.Transaction.Rollback;
        Raise Exception.Create(ClassName + '.MAJ ' + UpdateKindToStr(AAction) + cRC + E.Message);
      end;
    end;
  finally
    FreeAndNil(vQry);
  end;
end;

{ TGroupPump }

procedure TGroupPump.MAJ(const AAction: TUpdateKind);
var
  vQry: TFDQuery;
begin
  inherited;
  try
    if FAdmGINKOIA = nil then
      FAdmGINKOIA := ConnectToGINKOIA(ADossier.DOSS_CHEMIN);
    vQry := FAdmGINKOIA.GetNewQry;
    try
      if not FAdmGINKOIA.Transaction.Active then
        FAdmGINKOIA.Transaction.StartTransaction;
      case AAction of
        ukModify:
          begin
            FAdmGINKOIA.UpdateK(GCP_ID, 0);

            vQry.SQL.Text := cSql_U_gengestionpump;
          end;
        ukInsert:
          begin
            GCP_ID := FAdmGINKOIA.GetNewID('gengestionpump');

            vQry.SQL.Text := cSql_I_gengestionpump;
          end;
        ukDelete:
          begin

          end;
      end;

      if AAction in [ukModify, ukInsert] then
      begin
        vQry.ParamByName('PGCPID').AsInteger := GCP_ID;
        vQry.ParamByName('PGCPNOM').AsString := GCP_NOM;
        vQry.ExecSQL;
      end;

      FAdmGINKOIA.Transaction.Commit;
    except
      on E: Exception do
      begin
        FAdmGINKOIA.Transaction.Rollback;
        Raise Exception.Create(ClassName + '.MAJ ' + UpdateKindToStr(AAction) + cRC + E.Message);
      end;
    end;
  finally
    FreeAndNil(vQry);
    FreeAndNil(FAdmGINKOIA);
  end;
end;

end.
