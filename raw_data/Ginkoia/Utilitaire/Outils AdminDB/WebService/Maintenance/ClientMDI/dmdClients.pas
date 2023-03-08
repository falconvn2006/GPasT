unit dmdClients;

interface

uses
  SysUtils, Classes, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP, ImgList, Controls, DB, DBClient, Forms, Dialogs, cxGrid, cxPC, midaslib,
  ActnList, ComCtrls, u_Parser, ExtCtrls, Graphics, cxStyles, UVersion, cxGraphics;


type
  TGnkParams = Class(TComponent)
  private
    FListParam: TStringList;
    FDelayRefreshValues: integer;
    FUrl: String;
    FIsFileExist: Boolean;
    FAliasName: String;
    procedure SetUrl(const Value: String);
  published
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Load;
    procedure Save;
    property ListParam: TStringList read FListParam;
    property Url: String read FUrl write SetUrl;
    property AliasName: String read FAliasName write FAliasName;
    property DelayRefreshValues: integer read FDelayRefreshValues;
    property IsFileExist: Boolean read FIsFileExist;

    Class function UrlToHost(Const AUrl: String): String;
  End;

  TGenerique = Class(TComponent)
  private
    FID: Variant;
    FLibelle: Variant;
  public
    property ID: Variant read FID write FID;
    property Libelle: Variant read FLibelle write FLibelle;
  End;

  TdmClients = class(TDataModule)
    CDS_SRV: TClientDataSet;
    CDS_SRVSERV_ID: TIntegerField;
    CDS_SRVSERV_NOM: TStringField;
    CDS_SRVSERV_IP: TStringField;
    CDS_GRP: TClientDataSet;
    CDS_GRPGROU_ID: TIntegerField;
    CDS_GRPGROU_NOM: TStringField;
    CDS_DOS: TClientDataSet;
    CDS_DOSDOSS_ID: TIntegerField;
    CDS_DOSDOSS_DATABASE: TStringField;
    CDS_DOSDOSS_CHEMIN: TStringField;
    CDS_DOSDOSS_SERVID: TIntegerField;
    CDS_DOSDOSS_GROUID: TIntegerField;
    CDS_DOSDOSS_VIP: TIntegerField;
    CDS_DOSDOSS_PLATEFORME: TStringField;
    CDSModule: TClientDataSet;
    CDSModuleDOSS_ID: TIntegerField;
    CDSModuleMAGA_ID: TIntegerField;
    CDSModuleMAGA_MAGID_GINKOIA: TIntegerField;
    CDSModuleDOSS_DATABASE: TStringField;
    CDSModuleMAGA_NOM: TStringField;
    CDSModuleMODU_NOM: TStringField;
    CDSJeton: TClientDataSet;
    CDSJetonDOSS_ID: TIntegerField;
    CDSJetonEMET_ID: TIntegerField;
    CDSJetonDOSS_DATABASE: TStringField;
    CDSJetonEMET_NOM: TStringField;
    CDSJetonEMET_JETON: TIntegerField;
    CDS_DOSSERV_NOM: TStringField;
    CDS_DOSGROU_NOM: TStringField;
    CDS_DOSVERS_VERSION: TStringField;
    CDSHoraire: TClientDataSet;
    CDS_PARAMHORAIRES: TClientDataSet;
    CDS_PARAMHORAIRESPRHO_ID: TIntegerField;
    CDS_PARAMHORAIRESPRHO_NOMPLAGE: TStringField;
    CDS_PARAMHORAIRESPRHO_NBREPLIC: TIntegerField;
    CDS_PARAMHORAIRESPRHO_DEFAUT: TIntegerField;
    CDS_PARAMHORAIRESPRHO_SERVID: TIntegerField;
    CDS_PARAMHORAIRESPRHO_HDEB: TDateTimeField;
    CDS_PARAMHORAIRESPRHO_HFIN: TDateTimeField;
    CDS_DOSDOSS_INSTALL: TDateTimeField;
    CDSJetonEMET_TYPEREPLICATION: TStringField;
    CDSSuiviRepEtBaseHS: TClientDataSet;
    CDSSuiviRepEtBaseHSEMET_ID: TIntegerField;
    CDSSuiviRepEtBaseHSEMET_GUID: TStringField;
    CDSSuiviRepEtBaseHSEMET_NOM: TStringField;
    CDSSuiviRepEtBaseHSEMET_DONNEES: TStringField;
    CDSSuiviRepEtBaseHSEMET_DOSSID: TIntegerField;
    CDSSuiviRepEtBaseHSEMET_INSTALL: TDateTimeField;
    CDSSuiviRepEtBaseHSEMET_MAGID: TIntegerField;
    CDSSuiviRepEtBaseHSEMET_VERSID: TIntegerField;
    CDSSuiviRepEtBaseHSEMET_PATCH: TIntegerField;
    CDSSuiviRepEtBaseHSEMET_VERSION_MAX: TIntegerField;
    CDSSuiviRepEtBaseHSEMET_SPE_PATCH: TIntegerField;
    CDSSuiviRepEtBaseHSEMET_SPE_FAIT: TIntegerField;
    CDSSuiviRepEtBaseHSEMET_BCKOK: TDateTimeField;
    CDSSuiviRepEtBaseHSEMET_DERNBCK: TDateTimeField;
    CDSSuiviRepEtBaseHSEMET_RESBCK: TStringField;
    CDSSuiviRepEtBaseHSEMET_TIERSCEGID: TStringField;
    CDSSuiviRepEtBaseHSEMET_TYPEREPLICATION: TStringField;
    CDSSuiviRepEtBaseHSEMET_NONREPLICATION: TIntegerField;
    CDSSuiviRepEtBaseHSEMET_DEBUTNONREPLICATION: TDateField;
    CDSSuiviRepEtBaseHSEMET_FINNONREPLICATION: TDateField;
    CDSSuiviRepEtBaseHSEMET_SERVEURSECOURS: TIntegerField;
    CDSSuiviRepEtBaseHSEMET_IDENT: TStringField;
    CDSSuiviRepEtBaseHSEMET_JETON: TIntegerField;
    CDSSuiviRepEtBaseHSEMET_PLAGE: TStringField;
    CDSSuiviRepEtBaseHSEMET_H1: TIntegerField;
    CDSSuiviRepEtBaseHSEMET_HEURE1: TDateTimeField;
    CDSSuiviRepEtBaseHSEMET_H2: TIntegerField;
    CDSSuiviRepEtBaseHSEMET_HEURE2: TDateTimeField;
    CDSSuiviRepEtBaseHSBAS_SENDER: TStringField;
    CDSSuiviRepEtBaseHSBAS_CENTRALE: TStringField;
    CDSSuiviRepEtBaseHSBAS_NOMPOURNOUS: TStringField;
    CDSSuiviRepEtBaseHSLAU_AUTORUN: TIntegerField;
    CDSSuiviRepEtBaseHSLAU_BACK: TIntegerField;
    CDSSuiviRepEtBaseHSLAU_BACKTIME: TDateTimeField;
    CDSSuiviRepEtBaseHSPRM_POS: TIntegerField;
    CDSSuiviRepEtBaseHSSERV_ID: TIntegerField;
    CDSSuiviRepEtBaseHSSERV_NOM: TStringField;
    CDSSuiviRepEtBaseHSDOSS_DATABASE: TStringField;
    CDSSuiviRepEtBaseHSHDBM_ID: TIntegerField;
    CDSSuiviRepEtBaseHSHDBM_CYCLE: TDateTimeField;
    CDSSuiviRepEtBaseHSHDBM_OK: TIntegerField;
    CDSSuiviRepEtBaseHSHDBM_COMMENTAIRE: TStringField;
    CDSSuiviRepEtBaseHSHDBM_ARCHIVER: TIntegerField;
    CDSSuiviRepEtBaseHSHDBM_DATE: TDateTimeField;
    CDSSuiviRepEtBaseHSRAIS_ID: TIntegerField;
    CDSSuiviRepEtBaseHSRAIS_NOM: TStringField;
    CDSSuiviRepEtBaseHSDOSS_VIP: TBooleanField;
    CDSHoraireDispo: TClientDataSet;
    CDSHoraireDispoHoraireDispo: TDateTimeField;
    CDSHoraireDispoIndexCol: TIntegerField;
    CDSHoraireDispoPlageDispo: TStringField;
    CDSSuiviSrvReplication: TClientDataSet;
    CDSSuiviSrvReplicationSRV_ID: TIntegerField;
    CDSSuiviSrvReplicationSVR_DATE: TStringField;
    CDSSuiviSrvReplicationSVR_VERSION: TStringField;
    CDSSuiviSrvReplicationSVR_ERR: TStringField;
    CDSSuiviSrvReplicationSVR_PATH: TStringField;
    CDSSuiviSrvReplicationSVR_DATABASE: TStringField;
    CDSSuiviSrvReplicationSVR_SENDER: TStringField;
    CDSModeleMail: TClientDataSet;
    CDSModeleMailNOM: TStringField;
    CDSModeleMailOBJET: TStringField;
    CDSModeleMailMESSAGE: TStringField;
    CDSModeleMailFILENAME: TStringField;
    CDSSendMail: TClientDataSet;
    CDSSendMailEMET_ID: TIntegerField;
    CDSSendMailMAIL_FILENAME: TStringField;
    CDSRAISONS: TClientDataSet;
    CDSRAISONSRAIS_ID: TIntegerField;
    CDSRAISONSRAIS_NOM: TStringField;
    CDSRAISONSHDBM_ID: TIntegerField;
    CDSRAISONSDOSS_ID: TIntegerField;
    CDSRAISONSEMET_ID: TIntegerField;
    CDSSuiviServeur: TClientDataSet;
    CDSSuiviServeurEMET_ID: TIntegerField;
    CDSSuiviServeurSERV_NOM: TStringField;
    CDSSuiviServeurDOSS_DATABASE: TStringField;
    CDSSuiviServeurEMET_NOM: TStringField;
    CDSSuiviServeurEMET_GUID: TStringField;
    CDSSuiviServeurEMET_DONNEES: TStringField;
    CDSSuiviServeurEMET_DOSSID: TIntegerField;
    CDSSuiviServeurEMET_INSTALL: TDateTimeField;
    CDSSuiviServeurEMET_MAGID: TIntegerField;
    CDSSuiviServeurEMET_VERSID: TIntegerField;
    CDSSuiviServeurEMET_PATCH: TIntegerField;
    CDSSuiviServeurEMET_VERSION_MAX: TIntegerField;
    CDSSuiviServeurEMET_SPE_PATCH: TIntegerField;
    CDSSuiviServeurEMET_SPE_FAIT: TIntegerField;
    CDSSuiviServeurEMET_BCKOK: TDateTimeField;
    CDSSuiviServeurEMET_DERNBCK: TDateTimeField;
    CDSSuiviServeurEMET_RESBCK: TStringField;
    CDSSuiviServeurEMET_TIERSCEGID: TStringField;
    CDSSuiviServeurEMET_TYPEREPLICATION: TStringField;
    CDSSuiviServeurEMET_NONREPLICATION: TIntegerField;
    CDSSuiviServeurEMET_DEBUTNONREPLICATION: TDateField;
    CDSSuiviServeurEMET_FINNONREPLICATION: TDateField;
    CDSSuiviServeurEMET_SERVEURSECOURS: TIntegerField;
    CDSSuiviServeurEMET_IDENT: TStringField;
    CDSSuiviServeurEMET_JETON: TIntegerField;
    CDSSuiviServeurEMET_PLAGE: TStringField;
    CDSSuiviServeurEMET_H1: TIntegerField;
    CDSSuiviServeurEMET_HEURE1: TDateTimeField;
    CDSSuiviServeurEMET_H2: TIntegerField;
    CDSSuiviServeurEMET_HEURE2: TDateTimeField;
    CDSSuiviServeurBAS_SENDER: TStringField;
    CDSSuiviServeurBAS_CENTRALE: TStringField;
    CDSSuiviServeurBAS_NOMPOURNOUS: TStringField;
    CDSSuiviServeurLAU_AUTORUN: TIntegerField;
    CDSSuiviServeurLAU_BACK: TIntegerField;
    CDSSuiviServeurLAU_BACKTIME: TDateTimeField;
    CDSSuiviServeurPRM_POS: TIntegerField;
    CDSSuiviServeurSERV_ID: TIntegerField;
    CDSSuiviServeurHDBM_ID: TIntegerField;
    CDSSuiviServeurHDBM_CYCLE: TDateTimeField;
    CDSSuiviServeurHDBM_OK: TIntegerField;
    CDSSuiviServeurHDBM_COMMENTAIRE: TStringField;
    CDSSuiviServeurHDBM_ARCHIVER: TIntegerField;
    CDSSuiviServeurHDBM_DATE: TDateTimeField;
    CDSSuiviServeurRAIS_ID: TIntegerField;
    CDSSuiviServeurRAIS_NOM: TStringField;
    CDSSuiviServeurDOSS_VIP: TBooleanField;
    CDSSuiviPortable: TClientDataSet;
    CDSSuiviPortableEMET_ID: TIntegerField;
    CDSSuiviPortableSERV_NOM: TStringField;
    CDSSuiviPortableDOSS_DATABASE: TStringField;
    CDSSuiviPortableEMET_NOM: TStringField;
    CDSSuiviPortableEMET_GUID: TStringField;
    CDSSuiviPortableEMET_DONNEES: TStringField;
    CDSSuiviPortableEMET_DOSSID: TIntegerField;
    CDSSuiviPortableEMET_INSTALL: TDateTimeField;
    CDSSuiviPortableEMET_MAGID: TIntegerField;
    CDSSuiviPortableEMET_VERSID: TIntegerField;
    CDSSuiviPortableEMET_PATCH: TIntegerField;
    CDSSuiviPortableEMET_VERSION_MAX: TIntegerField;
    CDSSuiviPortableEMET_SPE_PATCH: TIntegerField;
    CDSSuiviPortableEMET_SPE_FAIT: TIntegerField;
    CDSSuiviPortableEMET_BCKOK: TDateTimeField;
    CDSSuiviPortableEMET_DERNBCK: TDateTimeField;
    CDSSuiviPortableEMET_RESBCK: TStringField;
    CDSSuiviPortableEMET_TIERSCEGID: TStringField;
    CDSSuiviPortableEMET_TYPEREPLICATION: TStringField;
    CDSSuiviPortableEMET_NONREPLICATION: TIntegerField;
    CDSSuiviPortableEMET_DEBUTNONREPLICATION: TDateField;
    CDSSuiviPortableEMET_FINNONREPLICATION: TDateField;
    CDSSuiviPortableEMET_SERVEURSECOURS: TIntegerField;
    CDSSuiviPortableEMET_IDENT: TStringField;
    CDSSuiviPortableEMET_JETON: TIntegerField;
    CDSSuiviPortableEMET_PLAGE: TStringField;
    CDSSuiviPortableEMET_H1: TIntegerField;
    CDSSuiviPortableEMET_HEURE1: TDateTimeField;
    CDSSuiviPortableEMET_H2: TIntegerField;
    CDSSuiviPortableEMET_HEURE2: TDateTimeField;
    CDSSuiviPortableBAS_SENDER: TStringField;
    CDSSuiviPortableBAS_CENTRALE: TStringField;
    CDSSuiviPortableBAS_NOMPOURNOUS: TStringField;
    CDSSuiviPortableLAU_AUTORUN: TIntegerField;
    CDSSuiviPortableLAU_BACK: TIntegerField;
    CDSSuiviPortableLAU_BACKTIME: TDateTimeField;
    CDSSuiviPortablePRM_POS: TIntegerField;
    CDSSuiviPortableSERV_ID: TIntegerField;
    CDSSuiviPortableHDBM_ID: TIntegerField;
    CDSSuiviPortableHDBM_CYCLE: TDateTimeField;
    CDSSuiviPortableHDBM_OK: TIntegerField;
    CDSSuiviPortableHDBM_COMMENTAIRE: TStringField;
    CDSSuiviPortableHDBM_ARCHIVER: TIntegerField;
    CDSSuiviPortableHDBM_DATE: TDateTimeField;
    CDSSuiviPortableRAIS_ID: TIntegerField;
    CDSSuiviPortableRAIS_NOM: TStringField;
    CDSSuiviPortableDOSS_VIP: TBooleanField;
    CDSSuiviServeurVIP: TClientDataSet;
    CDSSuiviServeurVIPEMET_ID: TIntegerField;
    CDSSuiviServeurVIPSERV_NOM: TStringField;
    CDSSuiviServeurVIPDOSS_DATABASE: TStringField;
    CDSSuiviServeurVIPEMET_NOM: TStringField;
    CDSSuiviServeurVIPEMET_GUID: TStringField;
    CDSSuiviServeurVIPEMET_DONNEES: TStringField;
    CDSSuiviServeurVIPEMET_DOSSID: TIntegerField;
    CDSSuiviServeurVIPEMET_INSTALL: TDateTimeField;
    CDSSuiviServeurVIPEMET_MAGID: TIntegerField;
    CDSSuiviServeurVIPEMET_VERSID: TIntegerField;
    CDSSuiviServeurVIPEMET_PATCH: TIntegerField;
    CDSSuiviServeurVIPEMET_VERSION_MAX: TIntegerField;
    CDSSuiviServeurVIPEMET_SPE_PATCH: TIntegerField;
    CDSSuiviServeurVIPEMET_SPE_FAIT: TIntegerField;
    CDSSuiviServeurVIPEMET_BCKOK: TDateTimeField;
    CDSSuiviServeurVIPEMET_DERNBCK: TDateTimeField;
    CDSSuiviServeurVIPEMET_RESBCK: TStringField;
    CDSSuiviServeurVIPEMET_TIERSCEGID: TStringField;
    CDSSuiviServeurVIPEMET_TYPEREPLICATION: TStringField;
    CDSSuiviServeurVIPEMET_NONREPLICATION: TIntegerField;
    CDSSuiviServeurVIPEMET_DEBUTNONREPLICATION: TDateField;
    CDSSuiviServeurVIPEMET_FINNONREPLICATION: TDateField;
    CDSSuiviServeurVIPEMET_SERVEURSECOURS: TIntegerField;
    CDSSuiviServeurVIPEMET_IDENT: TStringField;
    CDSSuiviServeurVIPEMET_JETON: TIntegerField;
    CDSSuiviServeurVIPEMET_PLAGE: TStringField;
    CDSSuiviServeurVIPEMET_H1: TIntegerField;
    CDSSuiviServeurVIPEMET_HEURE1: TDateTimeField;
    CDSSuiviServeurVIPEMET_H2: TIntegerField;
    CDSSuiviServeurVIPEMET_HEURE2: TDateTimeField;
    CDSSuiviServeurVIPBAS_SENDER: TStringField;
    CDSSuiviServeurVIPBAS_CENTRALE: TStringField;
    CDSSuiviServeurVIPBAS_NOMPOURNOUS: TStringField;
    CDSSuiviServeurVIPLAU_AUTORUN: TIntegerField;
    CDSSuiviServeurVIPLAU_BACK: TIntegerField;
    CDSSuiviServeurVIPLAU_BACKTIME: TDateTimeField;
    CDSSuiviServeurVIPPRM_POS: TIntegerField;
    CDSSuiviServeurVIPSERV_ID: TIntegerField;
    CDSSuiviServeurVIPHDBM_ID: TIntegerField;
    CDSSuiviServeurVIPHDBM_CYCLE: TDateTimeField;
    CDSSuiviServeurVIPHDBM_OK: TIntegerField;
    CDSSuiviServeurVIPHDBM_COMMENTAIRE: TStringField;
    CDSSuiviServeurVIPHDBM_ARCHIVER: TIntegerField;
    CDSSuiviServeurVIPHDBM_DATE: TDateTimeField;
    CDSSuiviServeurVIPRAIS_ID: TIntegerField;
    CDSSuiviServeurVIPRAIS_NOM: TStringField;
    CDSSuiviServeurVIPDOSS_VIP: TBooleanField;
    CDSSPLITTAGE_LOG: TClientDataSet;
    CDSSPLITTAGE_LOG_SPLI_NOSPLIT: TIntegerField;
    CDSSPLITTAGE_LOG_SPLI_EMETID: TIntegerField;
    CDSSPLITTAGE_LOG_SPLI_EMETNOM: TStringField;
    CDSSPLITTAGE_LOG_SPLI_DATEHEURESTART: TDateTimeField;
    CDSSPLITTAGE_LOG_SPLI_DATEHEUREEND: TDateTimeField;
    CDSSPLITTAGE_LOG_SPLI_ORDRE: TIntegerField;
    CDSSPLITTAGE_LOG_SPLI_EVENTLOG: TBlobField;
    CDSSPLITTAGE_LOG_SPLI_STARTED: TIntegerField;
    CDSSPLITTAGE_LOG_SPLI_TERMINATE: TIntegerField;
    CDSSPLITTAGE_LOG_SPLI_ERROR: TIntegerField;
    CDSSPLITTAGE_LOG_SPLI_USERNAME: TStringField;
    CDSSPLITTAGE_LOG_SPLI_TYPESPLIT: TStringField;
    CDSSPLITTAGE_LOG_SPLI_CLEARFILES: TIntegerField;
    CDS_DOSCHEMIN_BV: TStringField;
    CDSSuiviServeurBAS_GUID: TStringField;
    CDS_SRVSERV_DOSEAI: TStringField;
    CDS_DOSDOSS_ACTIF: TIntegerField;
    cxStyleRepository: TcxStyleRepository;
    cxStyleHeaderSearch: TcxStyle;
    cxStyleSearch: TcxStyle;
    CDS_SRVSERV_DOSBDD: TStringField;
    ImgLst1: TImageList;
    ImgLst: TcxImageList;
    CDS_DOSBJETON: TBooleanField;
    cxStyle1: TcxStyle;
    cxStyle2: TcxStyle;
    CDS_DOSDOSS_EASY: TIntegerField;
    procedure CDSHoraireNewRecord(DataSet: TDataSet);
    procedure CDS_PARAMHORAIRESNewRecord(DataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject);
    procedure CDS_DOSNewRecord(DataSet: TDataSet);
    procedure CDSSuiviRepEtBaseHSBeforePost(DataSet: TDataSet);
    procedure DataModuleDestroy(Sender: TObject);
    procedure CDS_PARAMHORAIRESPRHO_HDEBGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure CDSSPLITTAGE_LOG_SPLI_DATEHEURESTARTGetText(Sender: TField;
      var Text: string; DisplayText: Boolean);
    procedure CDSSPLITTAGE_LOG_SPLI_STARTEDGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
  private
    FInitialized: Boolean;
    FExportFluxToFile: Boolean;
    function GetFileNameDebug(Const ARessource: String): String;
    procedure ClearListGenerique(AList: TStrings);
    procedure InitialiseBooleanToDataSet(DataSet: TDataSet);
    procedure pOnRecordToXml(AName: String; ADateType: TFieldType; var Value: String);
  public
    function ResetConnexion: Boolean;
    function GetNewIdHTTP(Const AOwner: TComponent = nil): TIdHTTP;
    function GetTimeValues: String;
    function IndexOfByID(Const AID: integer; Const AList: TStrings): integer;
    function CountRecCxGrid(Const AGrid: TcxGrid): String;
    procedure ResetTimePanel(const APanel: TPanel);
    procedure InitializeIHM(Const AFrom: TWinControl);
    procedure LoadLists;
    procedure XmlToDataSet(Const ARessource: String; Const ACible: TClientDataSet;
                           Const FirstRecAutoDelete: Boolean = True; Const AutoPost: Boolean = True;
                           Const AEmpty: Boolean = True; Const AContentEncoding: String = cDefaultEncoding;
                           Const ASizeField: integer = cSizeField);
    procedure XmlToList(Const ARessource: String; Const AFieldName, AFieldNameID: String;
                        AListCible: TStrings; Const AOwner: TComponent;
                        Const FirstRecAutoDelete: Boolean = True);

    procedure PostRecordToXml(Const ARessource, AClassName: String; Const ASource: TClientDataSet;
                              Const AListField: TStringList = nil; Const AllDataSet: Boolean = False;
                              const ACDSReturn: TClientDataSet = nil; Const FirstRecAutoDelete: Boolean = True;
                              Const AutoPost: Boolean = True; Const AEmpty: Boolean = True;
                              Const AContentEncoding: String = cDefaultEncoding;
                              Const ASizeField: integer = cSizeField);
    procedure DeleteRecordByRessource(Const ARessource: String);

    procedure MoveOrdre(Const AUp: Boolean; Const AClientDataSet: TClientDataSet;
                        Const AFieldNameOrdre, ARessource, AClassName: String);

    procedure DataSetToList(Const ASource: TClientDataSet; Const AFieldNameID, AFieldName: String;
                        AListCible: TStrings; Const AOwner: TComponent);
    property Initialized: Boolean read FInitialized;
    property ExportFluxToFile: Boolean read FExportFluxToFile write FExportFluxToFile;
  end;

var
  dmClients: TdmClients;
  GIsBrowse: Boolean;
  GParams: TGnkParams;

implementation

uses uTool, uConst, FrmMain;

{$R *.dfm}

{ TdmClients }

procedure TdmClients.XmlToDataSet(const ARessource: String;
  const ACible: TClientDataSet; Const FirstRecAutoDelete: Boolean;
  Const AutoPost: Boolean; Const AEmpty: Boolean;
  Const AContentEncoding: String; Const ASizeField: integer);
var
  vParser: TParser;
  vIdHTTP: TIdHTTP;
begin
  Screen.Cursor:= crHourGlass;
  vParser:= TParser.Create(nil);
  try
    vParser.ContentEncoding:= AContentEncoding;
    vParser.SizeField:= ASizeField;
    try
      { Recuperation de la ressource }
      vIdHTTP:= GetNewIdHTTP(nil);
      vParser.ARequest:= vIdHTTP.Get(GParams.Url + ARessource);
      vParser.Execute;

      if FExportFluxToFile then
        DataSetToFile(vParser.ADataSet, GetFileNameDebug(ARessource), ';');

      if vParser.Erreur <> '' then
        Raise Exception.Create(vParser.Erreur);

      if vParser.ADataSet.FindField(cBlsExcept) <> nil then
        Raise Exception.Create(vParser.ADataSet.FieldByName(cBlsExcept).AsString);

      { Chargement des données dans le ClientDataSet }
      if AEmpty then
        ACible.EmptyDataSet;

      if vParser.ADataSet.FindField(cBlsResultEmpty) <> nil then
        Exit;

      if FirstRecAutoDelete then
        begin
          vParser.ADataSet.First;
          vParser.ADataSet.Delete;
        end;

      if vParser.ADataSet.RecordCount = 0 then
        Exit;

      BatchMove(vParser.ADataSet, ACible, AutoPost);
    except
      Raise;
    end;
  finally
    FreeAndNil(vParser);
    FreeAndNil(vIdHTTP);
    Screen.Cursor:= crDefault;
  end;
end;

procedure TdmClients.XmlToList(Const ARessource: String; Const AFieldName, AFieldNameID: String;
  AListCible: TStrings; Const AOwner: TComponent; Const FirstRecAutoDelete: Boolean = True);
var
  vParser: TParser;
  vGen: TGenerique;
  vIdHTTP: TIdHTTP;
begin
  vIdHTTP:= nil;
  Screen.Cursor:= crHourGlass;
  vParser:= TParser.Create(nil);
  try
    try
      { Recuperation de la ressource }
      vIdHTTP:= GetNewIdHTTP(nil);
      vParser.ARequest:= vIdHTTP.Get(GParams.Url + ARessource);
      vParser.Execute;

      if FExportFluxToFile then
        DataSetToFile(vParser.ADataSet, GetFileNameDebug(ARessource), ';');

      if vParser.Erreur <> '' then
        Raise Exception.Create(vParser.Erreur);

      if vParser.ADataSet.FindField(cBlsExcept) <> nil then
        Raise Exception.Create(vParser.ADataSet.FieldByName(cBlsExcept).AsString);

      if vParser.ADataSet.FindField(cBlsResultEmpty) <> nil then
        Exit;

      if vParser.ADataSet.RecordCount = 0 then
        Exit;

      if FirstRecAutoDelete then
        begin
          vParser.ADataSet.First;
          vParser.ADataSet.Delete;
        end;

      if vParser.ADataSet.RecordCount = 0 then
        Exit;

      { Chargement des données  }
      if vParser.ADataSet.FindField(AFieldName) = nil then
        Exit;

      ClearListGenerique(AListCible);
      vParser.ADataSet.First;
      while not vParser.ADataSet.Eof do
        begin
          vGen:= TGenerique.Create(AOwner);
          vGen.Libelle:= vParser.ADataSet.FieldByName(AFieldName).AsString;
          if (AFieldNameID <> '') and (vParser.ADataSet.FindField(AFieldNameID) <> nil) then
            vGen.ID:= vParser.ADataSet.FieldByName(AFieldNameID).AsString;
          AListCible.AddObject(vGen.Libelle, Pointer(vGen));
          vParser.ADataSet.Next;
        end;
    except
      Raise;
    end;
  finally
    FreeAndNil(vParser);
    FreeAndNil(vIdHTTP);
    Screen.Cursor:= crDefault;
  end;
end;

procedure TdmClients.CDSHoraireNewRecord(DataSet: TDataSet);
begin
  InitialiseBooleanToDataSet(DataSet);
end;

procedure TdmClients.CDSSPLITTAGE_LOG_SPLI_DATEHEURESTARTGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  Text:= FormatDateTime('dd/mm/yyyy hh:nn:ss', Sender.AsDateTime);
  if (Sender.IsNull) or (Sender.AsDateTime = 0) then
    Text:= '';
end;

procedure TdmClients.CDSSPLITTAGE_LOG_SPLI_STARTEDGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  if not Sender.IsNull then
    Text:= cNOYES[Sender.AsInteger];
end;

procedure TdmClients.CDSSuiviRepEtBaseHSBeforePost(DataSet: TDataSet);
begin
  if DataSet.FieldByName('DOSS_VIP').IsNull then
    DataSet.FieldByName('DOSS_VIP').AsBoolean:= False;
end;

procedure TdmClients.CDS_DOSNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('DOSS_ID').AsInteger:= -1;
  DataSet.FieldByName('DOSS_VIP').AsInteger:= 0;
  DataSet.FieldByName('DOSS_GROUID').AsInteger:= 0;
end;

procedure TdmClients.CDS_PARAMHORAIRESNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('PRHO_ID').AsInteger:= -1;
  if DataSet.FieldByName('PRHO_DEFAUT').IsNull then
    DataSet.FieldByName('PRHO_DEFAUT').AsInteger:= 0;
end;

procedure TdmClients.CDS_PARAMHORAIRESPRHO_HDEBGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  Text:= FormatDateTime('hh:nn', Sender.AsDateTime);
  if (CDS_PARAMHORAIRES.FieldByName('PRHO_DEFAUT').AsInteger = 1) then
    Text:= '';
end;

procedure TdmClients.ClearListGenerique(AList: TStrings);
var
  i: integer;
  vGen: TGenerique;
begin
  for i:= 0 to AList.Count - 1 do
    begin
      if (AList.Objects[i] <> nil) and (AList.Objects[i].ClassType = TGenerique) then
        begin
          vGen:= TGenerique(AList.Objects[i]);
          FreeAndNil(vGen);
        end;
    end;
  AList.Clear;
end;

function TdmClients.CountRecCxGrid(const AGrid: TcxGrid): String;
begin
  Result:= Format(cCountRec, ['0', '0']);
  if (AGrid <> nil) and (AGrid.Enabled) then
    Result:= Format(cCountRec, [IntToStr(AGrid.Controller.Control.FocusedView.DataController.FilteredRecordCount),
                                IntToStr(AGrid.Controller.Control.FocusedView.DataController.RecordCount)]);
end;

procedure TdmClients.DataModuleCreate(Sender: TObject);
begin
  FExportFluxToFile:= False;
  GIsBrowse:= True;
  SetLength(TrueBoolStrs, 2);
  SetLength(FalseBoolStrs, 2);
  TrueBoolStrs[0]:= DefaultTrueBoolStr;
  FalseBoolStrs[0]:= DefaultFalseBoolStr;
  TrueBoolStrs[1]:= 'Vrai';
  FalseBoolStrs[1]:= 'Faux';
end;

procedure TdmClients.DataModuleDestroy(Sender: TObject);
begin
  Finalize(TrueBoolStrs);
  Finalize(FalseBoolStrs);
end;

procedure TdmClients.DataSetToList(const ASource: TClientDataSet;
  const AFieldNameID, AFieldName: String; AListCible: TStrings;
  const AOwner: TComponent);
var
  vGen: TGenerique;
begin
  ClearListGenerique(AListCible);
  ASource.DisableControls;
  try
    ASource.First;
    while not ASource.Eof do
      begin
        vGen:= TGenerique.Create(AOwner);
        vGen.Libelle:= ASource.FieldByName(AFieldName).AsString;
        if (AFieldNameID <> '') and (ASource.FindField(AFieldNameID) <> nil) then
          vGen.ID:= ASource.FieldByName(AFieldNameID).Value;
        AListCible.AddObject(vGen.Libelle, Pointer(vGen));
        ASource.Next;
      end;
  finally
    ASource.First;
    ASource.EnableControls;
  end;
end;

procedure TdmClients.DeleteRecordByRessource(const ARessource: String);
var
  vIdHTTP: TIdHTTP;
  vParser: TParser;
  vRessource: String;
begin
  Screen.Cursor:= crHourGlass;
  vParser:= TParser.Create(nil);
  vIdHTTP:= GetNewIdHTTP(nil);
  try
    try
      vRessource:= ARessource;

      if Pos('?', vRessource) = 0 then
        Raise Exception.Create('Chaine de ressource incorrecte.');

      if Pos('DELETE', vRessource) = 0 then
        vRessource:= vRessource + '&DELETE=1';

      { Delete du record au serveur }
      vParser.ARequest:= vIdHTTP.Get(GParams.Url + vRessource);
      vParser.Execute;

      if vParser.ADataSet.FindField(cBlsExcept) <> nil then
        Raise Exception.Create(vParser.ADataSet.FieldByName(cBlsExcept).AsString);

      if (vParser.ADataSet.FindField(cBlsResult) <> nil) and
         (not vParser.ADataSet.FieldByName(cBlsResult).IsNull) then
        MessageDlg(vParser.ADataSet.FieldByName(cBlsResult).AsString, mtInformation, [mbOk], 0);
    except
      Raise;
    end;
  finally
    FreeAndNil(vParser);
    FreeAndNil(vIdHTTP);
    Screen.Cursor:= crDefault;
  end;
end;

function TdmClients.GetFileNameDebug(const ARessource: String): String;
begin
  Result:= ExtractFilePath(Application.ExeName) + Copy(ARessource, 1, Pos('?', ARessource)-1) + '_' +
           FormatDateTime('yyyymmdd_hh_nn_ss_zzz', Now) + '.csv';
end;

function TdmClients.GetNewIdHTTP(const AOwner: TComponent): TIdHTTP;
begin
  Result:= TIdHTTP.Create(AOwner);
  Result.Request.Accept:= 'text/xml, */*';
  Result.Request.ContentEncoding:= 'UTF-8';
  Result.Request.ContentType:= 'text/xml, */*';
  Result.Request.UserAgent:= 'Client Ginkoia 1.0';
  Result.Response.KeepAlive:= False;
end;

function TdmClients.GetTimeValues: String;
begin
  Result:= Format(cLibTimeValues, [FormatDateTime('dd/mm/yyy', Now), FormatDateTime('hh:nn', Now)]);
end;

procedure TdmClients.PostRecordToXml(const ARessource, AClassName: String;
  const ASource: TClientDataSet; Const AListField: TStringList;
  Const AllDataSet: Boolean; const ACDSReturn: TClientDataSet;
  Const FirstRecAutoDelete: Boolean; Const AutoPost: Boolean; Const AEmpty: Boolean;
  Const AContentEncoding: String; Const ASizeField: integer);
var
  vParser: TParser;
  vSL: TStrings;
  vIdHTTP: TIdHTTP;
begin
  Screen.Cursor:= crHourGlass;
  vSL:= TStringList.Create;
  vParser:= TParser.Create(nil);
  try
    vParser.OnRecordToXml:= pOnRecordToXml;
    try
      if not AllDataSet then
        vSL.Text:= vParser.RecordToXml(ASource, AClassName, AListField)
      else
        begin
          ASource.First;
          while not ASource.Eof do
            begin
              vSL.Text:= vSL.Text + vParser.RecordToXml(ASource, AClassName, AListField);
              ASource.Next;
            end;
        end;

      { Post du record au serveur }
      vIdHTTP:= GetNewIdHTTP(nil);
      vParser.ARequest:= vIdHTTP.Post(GParams.Url + ARessource, vSL);
      vParser.Execute;

      if FExportFluxToFile then
        DataSetToFile(vParser.ADataSet, GetFileNameDebug(ARessource), ';');

      if vParser.ADataSet.FindField(cBlsExcept) <> nil then
        Raise Exception.Create(vParser.ADataSet.FieldByName(cBlsExcept).AsString);

      if vParser.ADataSet.FindField(cBlsResultEmpty) <> nil then
        Exit;

      if ACDSReturn <> nil then
        begin
          if FirstRecAutoDelete then
            begin
              vParser.ADataSet.First;
              vParser.ADataSet.Delete;
            end;

          if vParser.ADataSet.RecordCount = 0 then
            Exit;

          { Chargement des données dans le ClientDataSet de retour }
          if AEmpty then
            ACDSReturn.EmptyDataSet;

          if not AllDataSet then
            BatchMove(vParser.ADataSet, ACDSReturn, AutoPost)
          else
            begin
              while not vParser.ADataSet.Eof do
                begin
                  BatchMove(vParser.ADataSet, ACDSReturn);
                  vParser.ADataSet.Next;
                end;
            end;
        end;

    except
      Raise;
    end;
  finally
    FreeAndNil(vSL);
    FreeAndNil(vParser);
    FreeAndNil(vIdHTTP);
    Screen.Cursor:= crDefault;
  end;
end;

function TdmClients.ResetConnexion: Boolean;
var
  vIdHTTP: TIdHTTP;
begin
  vIdHTTP:= GetNewIdHTTP(nil);
  try
    Result:= vIdHTTP.Get(GParams.Url + cStart) = cWSStarted;
  finally
    FreeAndNil(vIdHTTP);
  end;
end;

procedure TdmClients.ResetTimePanel(const APanel: TPanel);
begin
  APanel.Caption:= GetTimeValues;
  APanel.Font.Color:= clWindowText;
  if APanel.Tag <> 0 then
    begin
      TTimer(APanel.Tag).Interval:= GParams.DelayRefreshValues;
      TTimer(APanel.Tag).Enabled:= True;
    end;
end;

function TdmClients.IndexOfByID(const AID: integer;
  const AList: TStrings): integer;
var
  i: integer;
  vGen: TGenerique;
begin
  Result:= -1;
  for i:= 0 to AList.Count - 1 do
    begin
      vGen:= TGenerique(AList.Objects[i]);
      if (vGen <> nil) and (vGen.ID = AID) then
        begin
          Result:= i;
          Break;
        end;
    end;
end;

procedure TdmClients.InitialiseBooleanToDataSet(DataSet: TDataSet);
var
  i: integer;
begin
  for i:= 0 to DataSet.FieldCount - 1 do
    begin
      if DataSet.Fields.Fields[i].DataType = ftBoolean then
        DataSet.Fields.Fields[i].AsBoolean:= False;
    end;
end;

procedure TdmClients.InitializeIHM(const AFrom: TWinControl);
var
  i: integer;
begin
  for i:= 0 to AFrom.ComponentCount - 1 do
    begin
      if (AFrom.Components[i] is TcxGrid) and (TcxGrid(AFrom.Components[i]).Parent is TcxTabSheet) then
        TcxTabSheet(TcxGrid(AFrom.Components[i]).Parent).Tag:= Integer(AFrom.Components[i]);
    end;
end;

procedure TdmClients.LoadLists;
begin
  FInitialized:= False;
  Screen.Cursor:= crHourGlass;
  try
    try
      { Recuperation des Srv }

      XmlToDataSet('Srv', CDS_SRV);

      if (MainFrm.StBrMain.Panels.Items[1].Text <> '') and
         (Pos('LOCALHOST', UpperCase(MainFrm.StBrMain.Panels.Items[1].Text)) <> 0) then
        begin
          if not dmClients.CDS_SRV.Locate('SERV_NOM', 'LOCALHOST', []) then
            begin
              CDS_SRV.Append;
              CDS_SRV.FieldByName('SERV_ID').AsInteger:= 999;
              CDS_SRV.FieldByName('SERV_NOM').AsString:= 'LOCALHOST';
              CDS_SRV.FieldByName('SERV_DOSEAI').AsString:= 'D:\EAI';
              CDS_SRV.FieldByName('SERV_DOSBDD').AsString:= 'D:';
              CDS_SRV.Post;
            end;
        end;

      { Recuperation des Grp }
      XmlToDataSet('Grp', CDS_GRP);

      { Recuperation des dossiers }
      XmlToDataSet('Dossier', CDS_DOS);

      { Recuperation des modeles de mail }
      XmlToDataSet('ModeleMail', CDSModeleMail, True, True, True, cDefaultEncoding, 2000);

      FInitialized:= True;
    except
      Raise;
    end;
  finally
    Screen.Cursor:= crDefault;
  end;
end;

procedure TdmClients.MoveOrdre(const AUp: Boolean;
  const AClientDataSet: TClientDataSet; const AFieldNameOrdre, ARessource,
  AClassName: String);
var
  vOrdreCurr, vOrdre: integer;
  vBM: TBookmark;
begin
  if AClientDataSet.RecordCount = 0 then
    Exit;

  vBM:= AClientDataSet.GetBookmark;
  AClientDataSet.DisableControls;
  try
    vOrdreCurr:= AClientDataSet.FieldByName(AFieldNameOrdre).AsInteger;

    if AUp then
      begin
        AClientDataSet.Prior;
        if AClientDataSet.Bof then
          Exit;
      end
    else
      begin
        AClientDataSet.Next;
        if AClientDataSet.Eof then
          Exit;
      end;

    vOrdre:= AClientDataSet.FieldByName(AFieldNameOrdre).AsInteger;

    AClientDataSet.Edit;
    AClientDataSet.FieldByName(AFieldNameOrdre).AsInteger:= vOrdreCurr;
    AClientDataSet.Post;

    dmClients.PostRecordToXml(ARessource, AClassName, AClientDataSet);

    AClientDataSet.GotoBookmark(vBM);
    AClientDataSet.Edit;
    AClientDataSet.FieldByName(AFieldNameOrdre).AsInteger:= vOrdre;
    AClientDataSet.Post;

    dmClients.PostRecordToXml(ARessource, AClassName, AClientDataSet);

  finally
    AClientDataSet.EnableControls;
    AClientDataSet.FreeBookmark(vBM);
  end;
end;

procedure TdmClients.pOnRecordToXml(AName: String; ADateType: TFieldType;
  var Value: String);
begin
  if Value <> '' then
    begin
      case ADateType of
        ftDate, ftTime, ftDateTime, ftTimeStamp: Value:= FloatToStr(StrToDateTime(Value));
        ftBoolean: Value:= IntToStr(Integer(StrToBool(Value)));
      end;
    end;
end;

{ TParams }

constructor TGnkParams.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FListParam:= TStringList.Create;
end;

destructor TGnkParams.Destroy;
begin
  FreeAndNil(FListParam);
  inherited Destroy;
end;

procedure TGnkParams.Load;
var
  Buffer: String;
begin
  Buffer:= ChangeFileExt(Application.ExeName, '.ini');
  FIsFileExist:= FileExists(Buffer);
  if FIsFileExist then
    begin
      FListParam.LoadFromFile(Buffer);

      if FUrl = '' then
        Url:= FListParam.Values['URL'];

      Buffer:= FListParam.Values['DelayRefreshValues'];
      if Buffer <> '' then
        FDelayRefreshValues:= StrToInt(Buffer)
      else
        FDelayRefreshValues:= cDefaultDelayRefreshValues;
    end;
end;

procedure TGnkParams.Save;
begin
  FListParam.SaveToFile(ChangeFileExt(Application.ExeName, '.ini'));
  Load;
end;

procedure TGnkParams.SetUrl(const Value: String);
begin
  FUrl := Value;
  if (Trim(FUrl) <> '') and (FUrl[Length(FUrl)] <> '/') then
    FUrl:= FUrl + '/';
end;

Class function TGnkParams.UrlToHost(const AUrl: String): String;
var
  vIdx: integer;
begin
  Result:= AUrl;

  if Result <> '' then
    begin
      vIdx:= Pos('//', Result);
      if vIdx <> 0 then
        Delete(Result, 1, vIdx +1);

      if Result <> '' then
        begin
          vIdx:= Pos('/', Result);
          if vIdx <> 0 then
            Result:= Copy(Result, 1, vIdx -1);
        end;
    end;
end;

end.

