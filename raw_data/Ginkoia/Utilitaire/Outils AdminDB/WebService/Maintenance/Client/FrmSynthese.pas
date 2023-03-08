unit FrmSynthese;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FrmCustomGinkoiaForm, ComCtrls, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinBlack,
  dxSkinBlue, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinFoggy, dxSkinGlassOceans, dxSkiniMaginary, dxSkinLilian, IdHTTP,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSharp, dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinXmas2008Blue,
  dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, DB,
  cxDBData, cxGridLevel, cxClasses, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, DBClient, StdCtrls, Buttons,
  ExtCtrls, Menus, cxPC, ActnList, cxPropertiesStore, cxGridBandedTableView,
  cxGridDBBandedTableView, ToolWin, FrameToolBar, ThrdSuiviSrvReplication;

type
  TPlageHoraire = Class;

  TPlageHoraire = Class(TComponent)
  private
    FColumn: TcxGridDBBandedColumn;
    FDisponible: Boolean;
    FNbReplic: integer;
    FTime: TTime;
    FNbReplicDefault: integer;
    FNextPlageHoraire: TPlageHoraire;
  published
  public
    property ATime: TTime read FTime write FTime;
    property Disponible: Boolean read FDisponible write FDisponible;
    property NbReplic: integer read FNbReplic write FNbReplic;
    property NbReplicDefault: integer read FNbReplicDefault write FNbReplicDefault;
    property AColumn: TcxGridDBBandedColumn read FColumn write FColumn;
    property NextPlageHoraire: TPlageHoraire read FNextPlageHoraire write FNextPlageHoraire;
  end;

  TSyntheseFrm = class(TCustomGinkoiaFormFrm)
    DsModule: TDataSource;
    DSJeton: TDataSource;
    PgCtrlSynthese: TcxPageControl;
    TbShtModule: TcxTabSheet;
    TbshtJeton: TcxTabSheet;
    TbshtHoraireRep: TcxTabSheet;
    cxGridModule: TcxGrid;
    cxGridTWModule: TcxGridDBTableView;
    cxGridTWModuleDOS_DATABASE: TcxGridDBColumn;
    cxGridTWModuleMAG_NOM: TcxGridDBColumn;
    cxGridTWModuleMOD_NOM: TcxGridDBColumn;
    cxGridModuleLevel1: TcxGridLevel;
    cxGridJeton: TcxGrid;
    cxGridTWJeton: TcxGridDBTableView;
    cxGridTWJetonDOS_DATABASE: TcxGridDBColumn;
    cxGridTWJetonEMET_NOM: TcxGridDBColumn;
    cxGridTWJetonEMET_JETON: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    cxGridHoraire: TcxGrid;
    cxGridDBTWHoraire: TcxGridDBTableView;
    cxGridLevel2: TcxGridLevel;
    DsHoraire: TDataSource;
    pnlSrv: TPanel;
    Lab_1: TLabel;
    CmBxSrv: TComboBox;
    cxGridDBBandedTWHoraire: TcxGridDBBandedTableView;
    cxStyleRepository: TcxStyleRepository;
    cxStyleHoraireNonDisponible: TcxStyle;
    cxStyleDebordementNbRep: TcxStyle;
    cxStyleNbRepOk: TcxStyle;
    pnlTmrTimeModule: TPanel;
    pnlTmrTimeJeton: TPanel;
    pnlTmrTimeHoraire: TPanel;
    ToolBarSynthese: TToolBarFrame;
    SpdBtnHoraireDisp: TSpeedButton;
    SpdBtnReplic1: TSpeedButton;
    SpdBtnDesactiver: TSpeedButton;
    SpdBtnReplic2: TSpeedButton;
    cxGridTWJetonEMET_TYPEREPLICATION: TcxGridDBColumn;
    TbshtSuiviRepEtBaseHS: TcxTabSheet;
    TbshtSuiviServeurRep: TcxTabSheet;
    cxGridSuiviRepEtBaseHS: TcxGrid;
    cxGridDBTWSuiviRepEtBaseHS: TcxGridDBTableView;
    cxGridLevel3: TcxGridLevel;
    pnlTmrSuiviRepEtBaseHS: TPanel;
    DsSuiviRepEtBaseHS: TDataSource;
    cxGridDBTWSuiviRepEtBaseHSEMET_ID: TcxGridDBColumn;
    cxGridDBTWSuiviRepEtBaseHSSRV_NOM: TcxGridDBColumn;
    cxGridDBTWSuiviRepEtBaseHSDOS_DATABASE: TcxGridDBColumn;
    cxGridDBTWSuiviRepEtBaseHSEMET_NOM: TcxGridDBColumn;
    cxGridDBTWSuiviRepEtBaseHSEMET_GUID: TcxGridDBColumn;
    cxGridDBTWSuiviRepEtBaseHSEMET_DONNEES: TcxGridDBColumn;
    cxGridDBTWSuiviRepEtBaseHSDOS_ID: TcxGridDBColumn;
    cxGridDBTWSuiviRepEtBaseHSEMET_INSTALL: TcxGridDBColumn;
    cxGridDBTWSuiviRepEtBaseHSEMET_MAGID: TcxGridDBColumn;
    cxGridDBTWSuiviRepEtBaseHSVER_ID: TcxGridDBColumn;
    cxGridDBTWSuiviRepEtBaseHSEMET_PATCH: TcxGridDBColumn;
    cxGridDBTWSuiviRepEtBaseHSEMET_VERSION_MAX: TcxGridDBColumn;
    cxGridDBTWSuiviRepEtBaseHSEMET_SPE_PATCH: TcxGridDBColumn;
    cxGridDBTWSuiviRepEtBaseHSEMET_SPE_FAIT: TcxGridDBColumn;
    cxGridDBTWSuiviRepEtBaseHSEMET_BCKOK: TcxGridDBColumn;
    cxGridDBTWSuiviRepEtBaseHSEMET_DERNBCK: TcxGridDBColumn;
    cxGridDBTWSuiviRepEtBaseHSEMET_RESBCK: TcxGridDBColumn;
    cxGridDBTWSuiviRepEtBaseHSEMET_TIERSCEGID: TcxGridDBColumn;
    cxGridDBTWSuiviRepEtBaseHSEMET_TYPEREPLICATION: TcxGridDBColumn;
    cxGridDBTWSuiviRepEtBaseHSEMET_NONREPLICATION: TcxGridDBColumn;
    cxGridDBTWSuiviRepEtBaseHSEMET_DEBUTNONREPLICATION: TcxGridDBColumn;
    cxGridDBTWSuiviRepEtBaseHSEMET_FINNONREPLICATION: TcxGridDBColumn;
    cxGridDBTWSuiviRepEtBaseHSEMET_SERVEURSECOURS: TcxGridDBColumn;
    cxGridDBTWSuiviRepEtBaseHSEMET_IDENT: TcxGridDBColumn;
    cxGridDBTWSuiviRepEtBaseHSEMET_JETON: TcxGridDBColumn;
    cxGridDBTWSuiviRepEtBaseHSEMET_PLAGE: TcxGridDBColumn;
    cxGridDBTWSuiviRepEtBaseHSEMET_H1: TcxGridDBColumn;
    cxGridDBTWSuiviRepEtBaseHSEMET_HEURE1: TcxGridDBColumn;
    cxGridDBTWSuiviRepEtBaseHSEMET_H2: TcxGridDBColumn;
    cxGridDBTWSuiviRepEtBaseHSEMET_HEURE2: TcxGridDBColumn;
    cxGridDBTWSuiviRepEtBaseHSBAS_SENDER: TcxGridDBColumn;
    cxGridDBTWSuiviRepEtBaseHSBAS_CENTRALE: TcxGridDBColumn;
    cxGridDBTWSuiviRepEtBaseHSBAS_NOMPOURNOUS: TcxGridDBColumn;
    cxGridDBTWSuiviRepEtBaseHSLAU_AUTORUN: TcxGridDBColumn;
    cxGridDBTWSuiviRepEtBaseHSLAU_BACK: TcxGridDBColumn;
    cxGridDBTWSuiviRepEtBaseHSLAU_BACKTIME: TcxGridDBColumn;
    cxGridDBTWSuiviRepEtBaseHSPRM_POS: TcxGridDBColumn;
    cxGridDBTWSuiviRepEtBaseHSSRV_ID: TcxGridDBColumn;
    cxGridDBTWSuiviRepEtBaseHSHDB_ID: TcxGridDBColumn;
    cxGridDBTWSuiviRepEtBaseHSHDB_CYCLE: TcxGridDBColumn;
    cxGridDBTWSuiviRepEtBaseHSHDB_OK: TcxGridDBColumn;
    cxGridDBTWSuiviRepEtBaseHSHDB_COMMENTAIRE: TcxGridDBColumn;
    cxGridDBTWSuiviRepEtBaseHSHDB_ARCHIVER: TcxGridDBColumn;
    cxGridDBTWSuiviRepEtBaseHSHDB_DATE: TcxGridDBColumn;
    cxGridDBTWSuiviRepEtBaseHSRAISON_ID: TcxGridDBColumn;
    cxGridDBTWSuiviRepEtBaseHSRAISON_NOM: TcxGridDBColumn;
    cxGridDBTWSuiviRepEtBaseHSDOS_VIP: TcxGridDBColumn;
    StBrSynthese: TStatusBar;
    cxGridSuiviSrvReplication: TcxGrid;
    cxGridDBTWSuiviSrvReplication: TcxGridDBTableView;
    cxGridLevel4: TcxGridLevel;
    DsSuiviSrvReplication: TDataSource;
    pnlTopSuiviSrvReplic: TPanel;
    Lab_2: TLabel;
    CmbBxListLame: TComboBox;
    cxGridDBTWSuiviSrvReplicationSRV_ID: TcxGridDBColumn;
    cxGridDBTWSuiviSrvReplicationSVR_DATABASE: TcxGridDBColumn;
    cxGridDBTWSuiviSrvReplicationSVR_SENDER: TcxGridDBColumn;
    cxGridDBTWSuiviSrvReplicationSVR_DATE: TcxGridDBColumn;
    cxGridDBTWSuiviSrvReplicationSVR_VERSION: TcxGridDBColumn;
    cxGridDBTWSuiviSrvReplicationSVR_PATH: TcxGridDBColumn;
    cxGridDBTWSuiviSrvReplicationSVR_ERR: TcxGridDBColumn;
    pnlTmrSuiviSrvReplication: TPanel;
    TbshtSuiviServeur: TcxTabSheet;
    TbshtSuiviPortable: TcxTabSheet;
    TbshtSuiviVIP: TcxTabSheet;
    pnlTmrSuiviServeur: TPanel;
    cxGridSuiviServeur: TcxGrid;
    cxGridDBTWSuiviServeur: TcxGridDBTableView;
    cxGridLevel5: TcxGridLevel;
    pnlTmrSuiviPortable: TPanel;
    cxGridSuiviPortable: TcxGrid;
    cxGridDBTWSuiviPortable: TcxGridDBTableView;
    cxGridLevel6: TcxGridLevel;
    pnlTmrSuiviVIP: TPanel;
    cxGridSuiviVIP: TcxGrid;
    cxGridDBTWSuiviVIP: TcxGridDBTableView;
    cxGridLevel7: TcxGridLevel;
    DsSuiviServeur: TDataSource;
    DsSuiviPortable: TDataSource;
    DsSuiviServeurVIP: TDataSource;
    cxGridDBTWSuiviServeurEMET_ID: TcxGridDBColumn;
    cxGridDBTWSuiviServeurSRV_NOM: TcxGridDBColumn;
    cxGridDBTWSuiviServeurDOS_DATABASE: TcxGridDBColumn;
    cxGridDBTWSuiviServeurEMET_NOM: TcxGridDBColumn;
    cxGridDBTWSuiviServeurEMET_GUID: TcxGridDBColumn;
    cxGridDBTWSuiviServeurEMET_DONNEES: TcxGridDBColumn;
    cxGridDBTWSuiviServeurDOS_ID: TcxGridDBColumn;
    cxGridDBTWSuiviServeurEMET_INSTALL: TcxGridDBColumn;
    cxGridDBTWSuiviServeurEMET_MAGID: TcxGridDBColumn;
    cxGridDBTWSuiviServeurVER_ID: TcxGridDBColumn;
    cxGridDBTWSuiviServeurEMET_PATCH: TcxGridDBColumn;
    cxGridDBTWSuiviServeurEMET_VERSION_MAX: TcxGridDBColumn;
    cxGridDBTWSuiviServeurEMET_SPE_PATCH: TcxGridDBColumn;
    cxGridDBTWSuiviServeurEMET_SPE_FAIT: TcxGridDBColumn;
    cxGridDBTWSuiviServeurEMET_BCKOK: TcxGridDBColumn;
    cxGridDBTWSuiviServeurEMET_DERNBCK: TcxGridDBColumn;
    cxGridDBTWSuiviServeurEMET_RESBCK: TcxGridDBColumn;
    cxGridDBTWSuiviServeurEMET_TIERSCEGID: TcxGridDBColumn;
    cxGridDBTWSuiviServeurEMET_TYPEREPLICATION: TcxGridDBColumn;
    cxGridDBTWSuiviServeurEMET_NONREPLICATION: TcxGridDBColumn;
    cxGridDBTWSuiviServeurEMET_DEBUTNONREPLICATION: TcxGridDBColumn;
    cxGridDBTWSuiviServeurEMET_FINNONREPLICATION: TcxGridDBColumn;
    cxGridDBTWSuiviServeurEMET_SERVEURSECOURS: TcxGridDBColumn;
    cxGridDBTWSuiviServeurEMET_IDENT: TcxGridDBColumn;
    cxGridDBTWSuiviServeurEMET_JETON: TcxGridDBColumn;
    cxGridDBTWSuiviServeurEMET_PLAGE: TcxGridDBColumn;
    cxGridDBTWSuiviServeurEMET_H1: TcxGridDBColumn;
    cxGridDBTWSuiviServeurEMET_HEURE1: TcxGridDBColumn;
    cxGridDBTWSuiviServeurEMET_H2: TcxGridDBColumn;
    cxGridDBTWSuiviServeurEMET_HEURE2: TcxGridDBColumn;
    cxGridDBTWSuiviServeurBAS_SENDER: TcxGridDBColumn;
    cxGridDBTWSuiviServeurBAS_CENTRALE: TcxGridDBColumn;
    cxGridDBTWSuiviServeurBAS_NOMPOURNOUS: TcxGridDBColumn;
    cxGridDBTWSuiviServeurLAU_AUTORUN: TcxGridDBColumn;
    cxGridDBTWSuiviServeurLAU_BACK: TcxGridDBColumn;
    cxGridDBTWSuiviServeurLAU_BACKTIME: TcxGridDBColumn;
    cxGridDBTWSuiviServeurPRM_POS: TcxGridDBColumn;
    cxGridDBTWSuiviServeurSRV_ID: TcxGridDBColumn;
    cxGridDBTWSuiviServeurHDB_ID: TcxGridDBColumn;
    cxGridDBTWSuiviServeurHDB_CYCLE: TcxGridDBColumn;
    cxGridDBTWSuiviServeurHDB_OK: TcxGridDBColumn;
    cxGridDBTWSuiviServeurHDB_COMMENTAIRE: TcxGridDBColumn;
    cxGridDBTWSuiviServeurHDB_ARCHIVER: TcxGridDBColumn;
    cxGridDBTWSuiviServeurHDB_DATE: TcxGridDBColumn;
    cxGridDBTWSuiviServeurRAISON_ID: TcxGridDBColumn;
    cxGridDBTWSuiviServeurRAISON_NOM: TcxGridDBColumn;
    cxGridDBTWSuiviServeurDOS_VIP: TcxGridDBColumn;
    cxGridDBTWSuiviPortableEMET_ID: TcxGridDBColumn;
    cxGridDBTWSuiviPortableSRV_NOM: TcxGridDBColumn;
    cxGridDBTWSuiviPortableDOS_DATABASE: TcxGridDBColumn;
    cxGridDBTWSuiviPortableEMET_NOM: TcxGridDBColumn;
    cxGridDBTWSuiviPortableEMET_GUID: TcxGridDBColumn;
    cxGridDBTWSuiviPortableEMET_DONNEES: TcxGridDBColumn;
    cxGridDBTWSuiviPortableDOS_ID: TcxGridDBColumn;
    cxGridDBTWSuiviPortableEMET_INSTALL: TcxGridDBColumn;
    cxGridDBTWSuiviPortableEMET_MAGID: TcxGridDBColumn;
    cxGridDBTWSuiviPortableVER_ID: TcxGridDBColumn;
    cxGridDBTWSuiviPortableEMET_PATCH: TcxGridDBColumn;
    cxGridDBTWSuiviPortableEMET_VERSION_MAX: TcxGridDBColumn;
    cxGridDBTWSuiviPortableEMET_SPE_PATCH: TcxGridDBColumn;
    cxGridDBTWSuiviPortableEMET_SPE_FAIT: TcxGridDBColumn;
    cxGridDBTWSuiviPortableEMET_BCKOK: TcxGridDBColumn;
    cxGridDBTWSuiviPortableEMET_DERNBCK: TcxGridDBColumn;
    cxGridDBTWSuiviPortableEMET_RESBCK: TcxGridDBColumn;
    cxGridDBTWSuiviPortableEMET_TIERSCEGID: TcxGridDBColumn;
    cxGridDBTWSuiviPortableEMET_TYPEREPLICATION: TcxGridDBColumn;
    cxGridDBTWSuiviPortableEMET_NONREPLICATION: TcxGridDBColumn;
    cxGridDBTWSuiviPortableEMET_DEBUTNONREPLICATION: TcxGridDBColumn;
    cxGridDBTWSuiviPortableEMET_FINNONREPLICATION: TcxGridDBColumn;
    cxGridDBTWSuiviPortableEMET_SERVEURSECOURS: TcxGridDBColumn;
    cxGridDBTWSuiviPortableEMET_IDENT: TcxGridDBColumn;
    cxGridDBTWSuiviPortableEMET_JETON: TcxGridDBColumn;
    cxGridDBTWSuiviPortableEMET_PLAGE: TcxGridDBColumn;
    cxGridDBTWSuiviPortableEMET_H1: TcxGridDBColumn;
    cxGridDBTWSuiviPortableEMET_HEURE1: TcxGridDBColumn;
    cxGridDBTWSuiviPortableEMET_H2: TcxGridDBColumn;
    cxGridDBTWSuiviPortableEMET_HEURE2: TcxGridDBColumn;
    cxGridDBTWSuiviPortableBAS_SENDER: TcxGridDBColumn;
    cxGridDBTWSuiviPortableBAS_CENTRALE: TcxGridDBColumn;
    cxGridDBTWSuiviPortableBAS_NOMPOURNOUS: TcxGridDBColumn;
    cxGridDBTWSuiviPortableLAU_AUTORUN: TcxGridDBColumn;
    cxGridDBTWSuiviPortableLAU_BACK: TcxGridDBColumn;
    cxGridDBTWSuiviPortableLAU_BACKTIME: TcxGridDBColumn;
    cxGridDBTWSuiviPortablePRM_POS: TcxGridDBColumn;
    cxGridDBTWSuiviPortableSRV_ID: TcxGridDBColumn;
    cxGridDBTWSuiviPortableHDB_ID: TcxGridDBColumn;
    cxGridDBTWSuiviPortableHDB_CYCLE: TcxGridDBColumn;
    cxGridDBTWSuiviPortableHDB_OK: TcxGridDBColumn;
    cxGridDBTWSuiviPortableHDB_COMMENTAIRE: TcxGridDBColumn;
    cxGridDBTWSuiviPortableHDB_ARCHIVER: TcxGridDBColumn;
    cxGridDBTWSuiviPortableHDB_DATE: TcxGridDBColumn;
    cxGridDBTWSuiviPortableRAISON_ID: TcxGridDBColumn;
    cxGridDBTWSuiviPortableRAISON_NOM: TcxGridDBColumn;
    cxGridDBTWSuiviPortableDOS_VIP: TcxGridDBColumn;
    cxGridDBTWSuiviVIPEMET_ID: TcxGridDBColumn;
    cxGridDBTWSuiviVIPSRV_NOM: TcxGridDBColumn;
    cxGridDBTWSuiviVIPDOS_DATABASE: TcxGridDBColumn;
    cxGridDBTWSuiviVIPEMET_NOM: TcxGridDBColumn;
    cxGridDBTWSuiviVIPEMET_GUID: TcxGridDBColumn;
    cxGridDBTWSuiviVIPEMET_DONNEES: TcxGridDBColumn;
    cxGridDBTWSuiviVIPDOS_ID: TcxGridDBColumn;
    cxGridDBTWSuiviVIPEMET_INSTALL: TcxGridDBColumn;
    cxGridDBTWSuiviVIPEMET_MAGID: TcxGridDBColumn;
    cxGridDBTWSuiviVIPVER_ID: TcxGridDBColumn;
    cxGridDBTWSuiviVIPEMET_PATCH: TcxGridDBColumn;
    cxGridDBTWSuiviVIPEMET_VERSION_MAX: TcxGridDBColumn;
    cxGridDBTWSuiviVIPEMET_SPE_PATCH: TcxGridDBColumn;
    cxGridDBTWSuiviVIPEMET_SPE_FAIT: TcxGridDBColumn;
    cxGridDBTWSuiviVIPEMET_BCKOK: TcxGridDBColumn;
    cxGridDBTWSuiviVIPEMET_DERNBCK: TcxGridDBColumn;
    cxGridDBTWSuiviVIPEMET_RESBCK: TcxGridDBColumn;
    cxGridDBTWSuiviVIPEMET_TIERSCEGID: TcxGridDBColumn;
    cxGridDBTWSuiviVIPEMET_TYPEREPLICATION: TcxGridDBColumn;
    cxGridDBTWSuiviVIPEMET_NONREPLICATION: TcxGridDBColumn;
    cxGridDBTWSuiviVIPEMET_DEBUTNONREPLICATION: TcxGridDBColumn;
    cxGridDBTWSuiviVIPEMET_FINNONREPLICATION: TcxGridDBColumn;
    cxGridDBTWSuiviVIPEMET_SERVEURSECOURS: TcxGridDBColumn;
    cxGridDBTWSuiviVIPEMET_IDENT: TcxGridDBColumn;
    cxGridDBTWSuiviVIPEMET_JETON: TcxGridDBColumn;
    cxGridDBTWSuiviVIPEMET_PLAGE: TcxGridDBColumn;
    cxGridDBTWSuiviVIPEMET_H1: TcxGridDBColumn;
    cxGridDBTWSuiviVIPEMET_HEURE1: TcxGridDBColumn;
    cxGridDBTWSuiviVIPEMET_H2: TcxGridDBColumn;
    cxGridDBTWSuiviVIPEMET_HEURE2: TcxGridDBColumn;
    cxGridDBTWSuiviVIPBAS_SENDER: TcxGridDBColumn;
    cxGridDBTWSuiviVIPBAS_CENTRALE: TcxGridDBColumn;
    cxGridDBTWSuiviVIPBAS_NOMPOURNOUS: TcxGridDBColumn;
    cxGridDBTWSuiviVIPLAU_AUTORUN: TcxGridDBColumn;
    cxGridDBTWSuiviVIPLAU_BACK: TcxGridDBColumn;
    cxGridDBTWSuiviVIPLAU_BACKTIME: TcxGridDBColumn;
    cxGridDBTWSuiviVIPPRM_POS: TcxGridDBColumn;
    cxGridDBTWSuiviVIPSRV_ID: TcxGridDBColumn;
    cxGridDBTWSuiviVIPHDB_ID: TcxGridDBColumn;
    cxGridDBTWSuiviVIPHDB_CYCLE: TcxGridDBColumn;
    cxGridDBTWSuiviVIPHDB_OK: TcxGridDBColumn;
    cxGridDBTWSuiviVIPHDB_COMMENTAIRE: TcxGridDBColumn;
    cxGridDBTWSuiviVIPHDB_ARCHIVER: TcxGridDBColumn;
    cxGridDBTWSuiviVIPHDB_DATE: TcxGridDBColumn;
    cxGridDBTWSuiviVIPRAISON_ID: TcxGridDBColumn;
    cxGridDBTWSuiviVIPRAISON_NOM: TcxGridDBColumn;
    cxGridDBTWSuiviVIPDOS_VIP: TcxGridDBColumn;
    procedure BtBtnCloseClick(Sender: TObject);
    procedure PgCtrlSyntheseChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cxGridTWModuleDblClick(Sender: TObject);
    procedure CmBxSrvChange(Sender: TObject);
    procedure cxGridDBBandedTWHoraireEditing(Sender: TcxCustomGridTableView;
      AItem: TcxCustomGridTableItem; var AAllow: Boolean);
    procedure cxGrid1DBBandedTWHoraireDataControllerSummaryAfterSummary(
      ASender: TcxDataSummary);
    procedure ToolBarSyntheseActRefreshExecute(Sender: TObject);
    procedure ToolBarSyntheseActExcelExecute(Sender: TObject);
    procedure ToolBarSyntheseActToolExecute(Sender: TObject);
    procedure cxGridTWJetonDblClick(Sender: TObject);
    procedure cxGridDBBandedTWHoraireDblClick(Sender: TObject);
    procedure cxGridDBBandedTWHoraireCellClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure SpdBtnReplic1Click(Sender: TObject);
    procedure SpdBtnReplic2Click(Sender: TObject);
    procedure SpdBtnDesactiverClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cxGridDBTWSuiviRepEtBaseHSDataControllerGroupingChanged(
      Sender: TObject);
    procedure cxGridDBTWSuiviRepEtBaseHSDataControllerDataChanged(
      Sender: TObject);
    procedure SpdBtnHoraireDispClick(Sender: TObject);
    procedure CmbBxListLameChange(Sender: TObject);
    procedure cxGridDBTWSuiviSrvReplicationDblClick(Sender: TObject);
    procedure ToolBarSyntheseActDeleteExecute(Sender: TObject);
    procedure ToolBarSyntheseActEmailExecute(Sender: TObject);
    procedure cxGridDBTWSuiviRepEtBaseHSDblClick(Sender: TObject);
  private
    FCurrentGrid: TcxGrid;
    FColumnSelected: TcxGridDBBandedColumn;
    FProgessBar: TProgressBar;
    FThrdSuiviSrvReplication: TThrdSuiviSrvReplication;
    function FieldNameToTimeByCol(Const AColumn: TcxGridDBBandedColumn): TTime;
    function DateTimeToTime(Const ADateTime: TDateTime): TTime;
    procedure InitializeTimer;
    procedure SearchBorneReplic(Const AColumn: TcxGridDBBandedColumn; var APlageHorDeb, APlageHorFin: TPlageHoraire);
    procedure RefreshHoraire;
    procedure PlageEmetteurToDataSet;
    procedure SetColorHoraire(Const AColumn: TcxGridDBBandedColumn; Const ASender: TcxDataSummary);

    procedure p_FooterSummaryItemsGetText(Sender: TcxDataSummaryItem; Const AValue: Variant; AIsFooter: Boolean; var AText: String);
    procedure p_OnGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure p_OnTimer(Sender: TObject);
    procedure p_OnTerminate(Sender: TObject);

    procedure LoadSuiviRepEtBaseHS;
    procedure LoadSuiviServeur;
    procedure LoadSuiviPortableEtPortableSynchro;
    procedure LoadSuiviServeurVIP;
    procedure LoadModule;
    procedure LoadJeton;
    procedure LoadHoraire;
    procedure LoadHorairesDispo;
    procedure LoadSuiviSrvReplication;

    procedure ShowSendMail;
    procedure ShowDetailErreur;
    procedure ShowDetailRaison;

    procedure CallDetailModule(Const ADOS_ID, AMAG_ID: integer);
    procedure CallDetailEmetteur(Const ADOS_ID, AEMET_ID: integer);

    procedure CheckedReplication(Const AFieldNameHeure, AFieldNameActive: String; Const AChecked: Boolean = True);
  public
    procedure Initialize;
    property AProgessBar: TProgressBar read FProgessBar write FProgessBar;
  end;

var
  SyntheseFrm: TSyntheseFrm;

implementation

uses dmdClients, u_Parser, uTool, FrmClients, FrmMain, FrmParamHoraire,
  FrmClient, uConst, FrmPlagesDisponibles, FrmMemo, FrmDlgModeleMail,
  FrmDlgRaison;

{$R *.dfm}

{ TSyntheseFrm }

procedure TSyntheseFrm.BtBtnCloseClick(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TSyntheseFrm.CallDetailEmetteur(const ADOS_ID, AEMET_ID: integer);
var
  vClientFrm: TClientFrm;
begin
  MainFrm.ActClients.Execute;
  vClientFrm:= ClientsFrm.ClientByDOS_ID[ADOS_ID];
  if vClientFrm <> nil then
    vClientFrm.ShowDetailEmetteur(AEMET_ID);
end;

procedure TSyntheseFrm.CallDetailModule(const ADOS_ID, AMAG_ID: integer);
var
  vClientFrm: TClientFrm;
begin
  MainFrm.ActClients.Execute;
  vClientFrm:= ClientsFrm.ClientByDOS_ID[ADOS_ID];
  if vClientFrm <> nil then
    vClientFrm.ShowDetailModule(AMAG_ID);
end;

procedure TSyntheseFrm.CheckedReplication(const AFieldNameHeure, AFieldNameActive: String;
  Const AChecked: Boolean);
var
  i: integer;
  vSL: TStringList;
  vFieldSelected, vFieldChecked, vFieldHeure, vFieldActive: TField;
  vTime: TTime;
  vPlageHorDeb, vPlageHorFin: TPlageHoraire;
  vColumn: TcxGridDBBandedColumn;
begin
  if FColumnSelected <> nil then
    begin
      vFieldChecked:= nil;
      vSL:= TStringList.Create;
      try
        try
          vFieldSelected:= FColumnSelected.DataBinding.Field;
          if AChecked then
            begin
              if vFieldSelected.AsBoolean then
                Exit;

              vFieldHeure:= dmClients.CDSHoraire.FindField(AFieldNameHeure);
              vFieldActive:= dmClients.CDSHoraire.FindField(AFieldNameActive);

              if (vFieldHeure = nil) or (vFieldActive = nil) then
                Exit;

              if vFieldActive.AsInteger = 1 then
                begin
                  vTime:= DateTimeToTime(vFieldHeure.AsDateTime);
                  for i:= 0 to cxGridDBBandedTWHoraire.ColumnCount - 1 do
                    begin
                      SearchBorneReplic(cxGridDBBandedTWHoraire.Columns[i], vPlageHorDeb, vPlageHorFin);
                      if (vPlageHorDeb <> nil) and (vPlageHorFin <> nil) and
                         (vPlageHorDeb.ATime <= vTime) and (vTime < vPlageHorFin.ATime) then
                        begin
                          vFieldChecked:= dmClients.CDSHoraire.FindField(cxGridDBBandedTWHoraire.Columns[i].DataBinding.FieldName);
                          Break;
                        end;
                    end;
                end;
              vTime:= FieldNameToTimeByCol(FColumnSelected);
            end
          else
            begin
              SearchBorneReplic(FColumnSelected, vPlageHorDeb, vPlageHorFin);
              vTime:= DateTimeToTime(dmClients.CDSHoraire.FieldByName('EMET_HEURE1').AsDateTime);

              if (vPlageHorDeb.ATime <= vTime) and (vTime < vPlageHorFin.ATime) then
                begin
                  vFieldHeure:= dmClients.CDSHoraire.FindField('EMET_HEURE1');
                  vFieldActive:= dmClients.CDSHoraire.FindField('EMET_H1');
                end
              else
                begin
                  vFieldHeure:= dmClients.CDSHoraire.FindField('EMET_HEURE2');
                  vFieldActive:= dmClients.CDSHoraire.FindField('EMET_H2');
                end;
              vTime:= 0;
              if (vFieldHeure = nil) or (vFieldActive = nil) then
                Exit;
            end;

          dmClients.CDSHoraire.Edit;

          if vFieldChecked <> nil then
            begin
              vFieldChecked.AsBoolean:= not AChecked;
            end;

          vFieldSelected.AsBoolean:= AChecked;
          vFieldHeure.AsDateTime:= vTime;
          vFieldActive.AsInteger:= Integer(AChecked);

          vSL.Append('DOS_ID');
          vSL.Append('EMET_ID');
          vSL.Append('EMET_HEURE1');
          vSL.Append('EMET_HEURE2');
          vSL.Append('EMET_H1');
          vSL.Append('EMET_H2');

          dmClients.PostRecordToXml('Emetteur', 'TEmetteur', dmClients.CDSHoraire, vSL);
          dmClients.CDSHoraire.Post;

          if vFieldChecked <> nil then
            begin
              vColumn:= TcxGridDBBandedColumn(vFieldChecked.Tag);
              SetColorHoraire(vColumn, cxGridDBBandedTWHoraire.DataController.Summary);
            end;
        except
          if dmClients.CDSHoraire.State <> dsBrowse then
            dmClients.CDSHoraire.Cancel;
          Raise;
        end;
      finally
        FreeAndNil(vSL);
      end;
    end;
end;

procedure TSyntheseFrm.CmbBxListLameChange(Sender: TObject);
begin
  inherited;
  LoadSuiviSrvReplication;
end;

procedure TSyntheseFrm.CmBxSrvChange(Sender: TObject);
begin
  inherited;
  ToolBarSynthese.ActTool.Enabled:= CmBxSrv.ItemIndex <> -1;
  RefreshHoraire;
end;

procedure TSyntheseFrm.cxGrid1DBBandedTWHoraireDataControllerSummaryAfterSummary(
  ASender: TcxDataSummary);
begin
  inherited;
  if (dmClients.CDSHoraire.Active) and (dmClients.CDSHoraire.RecordCount <> 0) then
    SetColorHoraire(FColumnSelected, ASender);
end;

procedure TSyntheseFrm.cxGridDBBandedTWHoraireCellClick(
  Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
  AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  inherited;
  FColumnSelected:= nil;
  if ACellViewInfo.Item.Index > 7 then
    FColumnSelected:= TcxGridDBBandedColumn(ACellViewInfo.Item);
end;

procedure TSyntheseFrm.cxGridDBBandedTWHoraireDblClick(Sender: TObject);
begin
  inherited;
  if (DsHoraire.DataSet <> nil) and (DsHoraire.DataSet.RecordCount <> 0) and (FColumnSelected = nil) then
    CallDetailEmetteur(DsHoraire.DataSet.FieldByName('DOS_ID').AsInteger,
                       DsHoraire.DataSet.FieldByName('EMET_ID').AsInteger);
end;

procedure TSyntheseFrm.cxGridDBBandedTWHoraireEditing(
  Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
  var AAllow: Boolean);
begin
  inherited;
  AAllow:= False;
end;

procedure TSyntheseFrm.cxGridDBTWSuiviRepEtBaseHSDataControllerDataChanged(
  Sender: TObject);
begin
  inherited;
  StBrSynthese.SimpleText:= dmClients.CountRecCxGrid(FCurrentGrid);
end;

procedure TSyntheseFrm.cxGridDBTWSuiviRepEtBaseHSDataControllerGroupingChanged(
  Sender: TObject);
begin
  inherited;
  if FCurrentGrid <> nil then
    begin
      FCurrentGrid.Controller.Control.FocusedView.DataController.Groups.FullExpand;
      FCurrentGrid.Controller.Control.FocusedView.DataController.FocusedRowIndex:= 0;
    end;
  StBrSynthese.SimpleText:= dmClients.CountRecCxGrid(FCurrentGrid);
end;

procedure TSyntheseFrm.cxGridDBTWSuiviRepEtBaseHSDblClick(Sender: TObject);
begin
  inherited;
  ShowDetailRaison;
end;

procedure TSyntheseFrm.cxGridDBTWSuiviSrvReplicationDblClick(Sender: TObject);
begin
  inherited;
  ShowDetailErreur;
end;

procedure TSyntheseFrm.cxGridTWJetonDblClick(Sender: TObject);
begin
  inherited;
  if (DSJeton.DataSet <> nil) and (DSJeton.DataSet.RecordCount <> 0) then
    CallDetailEmetteur(DSJeton.DataSet.FieldByName('DOS_ID').AsInteger,
                       DSJeton.DataSet.FieldByName('EMET_ID').AsInteger);
end;

procedure TSyntheseFrm.cxGridTWModuleDblClick(Sender: TObject);
begin
  inherited;
  if (DsModule.DataSet <> nil) and (DsModule.DataSet.RecordCount <> 0) then
    CallDetailModule(DsModule.DataSet.FieldByName('DOS_ID').AsInteger,
                     DsModule.DataSet.FieldByName('MAG_ID').AsInteger);
end;

function TSyntheseFrm.DateTimeToTime(const ADateTime: TDateTime): TTime;
var
  vH, vN, vS, vMls: Word;
begin
  DecodeTime(ADateTime, vH, vN, vS, vMls);
  Result:= EncodeTime(vH, vN, 0, 0);
end;

function TSyntheseFrm.FieldNameToTimeByCol(
  const AColumn: TcxGridDBBandedColumn): TTime;
var
  vH, vN: Word;
begin
  vH:= StrToInt(Copy(AColumn.DataBinding.FieldName, 1, 2));
  vN:= StrToInt(Copy(AColumn.DataBinding.FieldName, 4, 2));
  Result:= EncodeTime(vH, vN, 0, 0);
end;

procedure TSyntheseFrm.FormCreate(Sender: TObject);
begin
  cxPropertiesStore.Active:= True;
  inherited;
  ToolBarSynthese.ConfirmDelete:= True;
  cxGridDBTWSuiviRepEtBaseHS.RestoreFromRegistry(cxPropertiesStore.StorageName, False, False, [gsoUseFilter], cxGridDBTWSuiviRepEtBaseHS.Name);
  cxGridDBTWSuiviSrvReplication.RestoreFromRegistry(cxPropertiesStore.StorageName, False, False, [gsoUseFilter], cxGridDBTWSuiviSrvReplication.Name);
  cxGridTWModule.RestoreFromRegistry(cxPropertiesStore.StorageName, False, False, [gsoUseFilter], cxGridTWModule.Name);
  cxGridTWJeton.RestoreFromRegistry(cxPropertiesStore.StorageName, False, False, [gsoUseFilter], cxGridTWJeton.Name);
  cxGridDBTWHoraire.RestoreFromRegistry(cxPropertiesStore.StorageName, False, False, [gsoUseFilter], cxGridDBTWHoraire.Name);
  if not dmClients.Initialized then
    dmClients.LoadLists;
end;

procedure TSyntheseFrm.FormDestroy(Sender: TObject);
begin
  inherited;
  cxGridDBTWSuiviRepEtBaseHS.StoreToRegistry(cxPropertiesStore.StorageName, False, [gsoUseFilter], cxGridDBTWSuiviRepEtBaseHS.Name);
  cxGridDBTWSuiviSrvReplication.StoreToRegistry(cxPropertiesStore.StorageName, False, [gsoUseFilter], cxGridDBTWSuiviSrvReplication.Name);
  cxGridTWModule.StoreToRegistry(cxPropertiesStore.StorageName, False, [gsoUseFilter], cxGridTWModule.Name);
  cxGridTWJeton.StoreToRegistry(cxPropertiesStore.StorageName, False, [gsoUseFilter], cxGridTWJeton.Name);
  cxGridDBTWHoraire.StoreToRegistry(cxPropertiesStore.StorageName, False, [gsoUseFilter], cxGridDBTWHoraire.Name);
end;

procedure TSyntheseFrm.Initialize;
var
  i, vCptTranche: integer;
  vDT: TDateTime;
  vH, vN, vS, vZ: Word;
  Buffer: String;
  vColumn: TcxGridDBBandedColumn;
  vSummaryItem: TcxDataSummaryItem;
  vPlageHoraire, vPlgHorFirst, vPlgHorPrior: TPlageHoraire;
begin
  vPlgHorPrior:= nil;
  vPlgHorFirst:= nil;
  Screen.Cursor:= crHourGlass;
  try
    dmClients.InitializeIHM(Self);
    PgCtrlSynthese.ActivePageIndex:= 0;
    PgCtrlSyntheseChange(nil);

    { Creation des fields }
    dmClients.CDSHoraire.FieldDefs.Add('DOS_ID', ftInteger);
    dmClients.CDSHoraire.FieldDefs.Add('DOS_DATABASE', ftString, 255);
    dmClients.CDSHoraire.FieldDefs.Add('EMET_ID', ftInteger);
    dmClients.CDSHoraire.FieldDefs.Add('EMET_NOM', ftString, 128);
    dmClients.CDSHoraire.FieldDefs.Add('EMET_HEURE1', ftDateTime);
    dmClients.CDSHoraire.FieldDefs.Add('EMET_HEURE2', ftDateTime);
    dmClients.CDSHoraire.FieldDefs.Add('EMET_INFOSUP', ftString, 255);
    dmClients.CDSHoraire.FieldDefs.Add('EMET_GUID', ftString, 64);
    dmClients.CDSHoraire.FieldDefs.Add('EMET_H1', ftInteger);
    dmClients.CDSHoraire.FieldDefs.Add('EMET_H2', ftInteger);

    Double(vDT):= 0.0 + ((1 / HoursPerDay) * 18) + ((1 / (MinsPerHour*HoursPerDay)) * 40);
    vCptTranche:= MinsPerDay div 10;
    for i:= 0 to vCptTranche -1 do
      begin
        DecodeTime(vDT, vH, vN, vS, vZ);
        Buffer:= Format('%.2dh%.2d', [vH, vN]);
        dmClients.CDSHoraire.FieldDefs.Add(Buffer, ftBoolean);
        Double(vDT):= Double(vDT) + ((1 / (MinsPerHour*HoursPerDay)) * 10);
      end;

    dmClients.CDSHoraire.CreateDataset;

    { Initialisation de l'affichage des fields }
    dmClients.CDSHoraire.Fields.Fields[0].Visible:= False;
    dmClients.CDSHoraire.Fields.Fields[1].DisplayLabel:= 'Dossier';
    dmClients.CDSHoraire.Fields.Fields[1].Tag:= 120;
    dmClients.CDSHoraire.Fields.Fields[2].Visible:= False;
    dmClients.CDSHoraire.Fields.Fields[3].DisplayLabel:= 'Site émetteur';
    dmClients.CDSHoraire.Fields.Fields[3].Tag:= 200;
    dmClients.CDSHoraire.Fields.Fields[4].DisplayLabel:= 'Réplic 1';
    dmClients.CDSHoraire.Fields.Fields[4].Alignment:= taCenter;
    dmClients.CDSHoraire.Fields.Fields[4].Tag:= 70;
    dmClients.CDSHoraire.Fields.Fields[4].OnGetText:= p_OnGetText;
    TDateTimeField(dmClients.CDSHoraire.Fields.Fields[4]).DisplayFormat:= 'hh:nn';
    dmClients.CDSHoraire.Fields.Fields[5].DisplayLabel:= 'Réplic 2';
    dmClients.CDSHoraire.Fields.Fields[5].Alignment:= taCenter;
    dmClients.CDSHoraire.Fields.Fields[5].Tag:= 70;
    dmClients.CDSHoraire.Fields.Fields[5].OnGetText:= p_OnGetText;
    TDateTimeField(dmClients.CDSHoraire.Fields.Fields[5]).DisplayFormat:= 'hh:nn';
    dmClients.CDSHoraire.Fields.Fields[6].DisplayLabel:= 'Remarques';
    dmClients.CDSHoraire.Fields.Fields[6].Tag:= 120;
    dmClients.CDSHoraire.Fields.Fields[7].Visible:= False;
    dmClients.CDSHoraire.Fields.Fields[8].Visible:= False;
    dmClients.CDSHoraire.Fields.Fields[9].Visible:= False;

    if FProgessBar <> nil then
      begin
        FProgessBar.Min:= 0;
        FProgessBar.Max:= dmClients.CDSHoraire.FieldCount -1;
        FProgessBar.Position:= 0;
      end;

    { Creation des colonnes }
    for i:= 0 to dmClients.CDSHoraire.FieldCount - 1 do
      begin
        vColumn                       := cxGridDBBandedTWHoraire.CreateColumn;
        vColumn.DataBinding.FieldName := dmClients.CDSHoraire.Fields.Fields[i].FieldName;
        vColumn.Caption               := dmClients.CDSHoraire.Fields.Fields[i].DisplayLabel;
        vColumn.Options.VertSizing    := False;
        vColumn.Options.Moving        := False;
        vColumn.HeaderAlignmentHorz   := taCenter;
        vColumn.visible               := dmClients.CDSHoraire.Fields.Fields[i].Visible;
        vColumn.Filtered              := True;
        if i in [0..9] then
          begin
            vColumn.Position.BandIndex    := 0;
            vColumn.Editing               := False;
            if dmClients.CDSHoraire.Fields.Fields[i].Tag <> 0 then
              vColumn.Width               := dmClients.CDSHoraire.Fields.Fields[i].Tag;
          end
        else
          begin
            dmClients.CDSHoraire.Fields.Fields[i].Tag:= Integer(vColumn);
            if dmClients.CDSHoraire.Fields.Fields[i].Visible then
              vColumn.Width               := 40;
            vColumn.Options.HorzSizing    := False;
            vColumn.Options.Filtering     := False;
            vColumn.Options.Sorting       := False;
            vColumn.Position.BandIndex:= 1;
            vSummaryItem:= cxGridDBBandedTWHoraire.DataController.Summary.FooterSummaryItems.Add;
            vSummaryItem.ItemLink:= vColumn;
            vColumn.Tag:= Integer(vSummaryItem);
            vSummaryItem.Kind:= skSum;
            vSummaryItem.OnGetText:= p_FooterSummaryItemsGetText;

            vPlageHoraire:= TPlageHoraire.Create(Self);
            vPlageHoraire.AColumn:= vColumn;
            vPlageHoraire.ATime:= FieldNameToTimeByCol(vColumn);
            vSummaryItem.Tag:= Integer(vPlageHoraire);

            if vPlgHorFirst = nil then
              vPlgHorFirst:= vPlageHoraire;

            if vPlgHorPrior <> nil then
              vPlgHorPrior.NextPlageHoraire:= vPlageHoraire;

            vPlgHorPrior:= vPlageHoraire;

            if i = dmClients.CDSHoraire.FieldCount - 1 then
              vPlageHoraire.NextPlageHoraire:= vPlgHorFirst;
          end;

        if FProgessBar <> nil then
          FProgessBar.Position:= FProgessBar.Position +1;
      end;

    DsHoraire.DataSet:= dmClients.CDSHoraire;

    SpdBtnReplic1.Caption:= dmClients.CDSHoraire.FieldByName('EMET_HEURE1').DisplayLabel;
    SpdBtnReplic2.Caption:= dmClients.CDSHoraire.FieldByName('EMET_HEURE2').DisplayLabel;

    { Chargement des paramètres horaires + Chargement de la liste des Lames pour les horaires}
    LoadHoraire;
  finally
    InitializeTimer;
    FProgessBar:= nil;
    Screen.Cursor:= crDefault;
  end;
end;

procedure TSyntheseFrm.InitializeTimer;
var
  i: integer;
  vTimer: TTimer;
begin
  for i:= 0 to ComponentCount - 1 do
    begin
      if (Components[i] is TPanel) and (UpperCase(Copy(TPanel(Components[i]).Name, 1, 6)) = 'PNLTMR') then
        begin
          vTimer:= TTimer.Create(Self);
          vTimer.Interval:= GParams.DelayRefreshValues;
          vTimer.OnTimer:= p_OnTimer;
          vTimer.Tag:= Integer(Components[i]);
          Components[i].Tag:= Integer(vTimer);
        end;
    end;
end;

procedure TSyntheseFrm.LoadHoraire;
var
  vIdx: integer;
begin
  vIdx:= CmBxSrv.ItemIndex;

  { Chargement des paramètres horaires }
  dmClients.XmlToDataSet('Horaire', dmClients.CDS_PARAMHORAIRES);

  { Chargement de la liste des Lames pour les horaires et les serveurs de replication }
  dmClients.DataSetToList(dmClients.CDS_SRV, 'SRV_ID', 'SRV_NOM', CmBxSrv.Items, Self);
  CmbBxListLame.Items.Assign(CmBxSrv.Items);

  if vIdx <> -1 then
    begin
      CmBxSrv.ItemIndex:= vIdx;
      RefreshHoraire;
    end;
end;

procedure TSyntheseFrm.LoadHorairesDispo;
var
  i, vSumReplic: integer;
  vPlagesDispoFrm: TPlagesDisponiblesFrm;
  vPlageHoraire: TPlageHoraire;
begin
  dmClients.CDSHoraireDispo.DisableControls;
  vPlagesDispoFrm:= TPlagesDisponiblesFrm.Create(nil);
  try
    dmClients.CDSHoraireDispo.EmptyDataSet;
    vPlagesDispoFrm.lblSrvName.Caption:= CmBxSrv.Items.Strings[CmBxSrv.ItemIndex];

    for i:= 0 to cxGridDBBandedTWHoraire.DataController.Summary.FooterSummaryItems.Count - 1 do
      begin
        vSumReplic:= 0;
        vPlageHoraire:= TPlageHoraire(cxGridDBBandedTWHoraire.DataController.Summary.FooterSummaryItems.Items[i].Tag);
        if (not VarIsNull(cxGridDBBandedTWHoraire.DataController.Summary.FooterSummaryValues[i])) and
           (cxGridDBBandedTWHoraire.DataController.Summary.FooterSummaryValues[i] <> 0) then
          vSumReplic:= Abs(Integer(cxGridDBBandedTWHoraire.DataController.Summary.FooterSummaryValues[i]));

        if (vPlageHoraire.Disponible) and (vSumReplic < vPlageHoraire.NbReplic) then
          begin
            dmClients.CDSHoraireDispo.Append;
            dmClients.CDSHoraireDispo.FieldByName('HoraireDispo').AsDateTime:= vPlageHoraire.ATime;
            dmClients.CDSHoraireDispo.FieldByName('PlageDispo').AsString:= IntToStr(vPlageHoraire.NbReplic - vSumReplic);
            dmClients.CDSHoraireDispo.FieldByName('IndexCol').AsInteger:= vPlageHoraire.AColumn.Index;
            dmClients.CDSHoraireDispo.Post;
          end;
      end;
    dmClients.CDSHoraireDispo.First;
    dmClients.CDSHoraireDispo.EnableControls;
    if vPlagesDispoFrm.ShowModal = mrOk then
      cxGridDBBandedTWHoraire.Columns[dmClients.CDSHoraireDispo.FieldByName('IndexCol').AsInteger].FocusWithSelection;
  finally
    FreeAndNil(vPlagesDispoFrm);
  end;
end;

procedure TSyntheseFrm.LoadJeton;
begin
  dmClients.XmlToDataSet('Jeton', dmClients.CDSJeton);
  cxGridTWJeton.DataController.Groups.FullExpand;
  cxGridTWJeton.DataController.FocusedRowIndex:= 0;
  dmClients.ResetTimePanel(pnlTmrTimeJeton);
end;

procedure TSyntheseFrm.LoadModule;
begin
  dmClients.XmlToDataSet('Module', dmClients.CDSModule);
  cxGridTWModule.DataController.Groups.FullExpand;
  cxGridTWModule.DataController.FocusedRowIndex:= 0;
  if FProgessBar <> nil then
    begin
      FProgessBar.Position:= FProgessBar.Position +1;
      Application.ProcessMessages;
    end;
  dmClients.ResetTimePanel(pnlTmrTimeModule);
end;

procedure TSyntheseFrm.LoadSuiviRepEtBaseHS;
begin
  dmClients.XmlToDataSet('Emetteur?Synthese=SuiviRepEtBaseHS', dmClients.CDSSuiviRepEtBaseHS);
  cxGridDBTWSuiviRepEtBaseHS.DataController.Groups.FullExpand;
  cxGridDBTWSuiviRepEtBaseHS.DataController.FocusedRowIndex:= 0;
  dmClients.ResetTimePanel(pnlTmrSuiviRepEtBaseHS);
end;

procedure TSyntheseFrm.LoadSuiviPortableEtPortableSynchro;
begin
  dmClients.XmlToDataSet('Emetteur?Synthese=SuiviPortableEtPortableSynchro', dmClients.CDSSuiviPortable);
  cxGridDBTWSuiviPortable.DataController.Groups.FullExpand;
  cxGridDBTWSuiviPortable.DataController.FocusedRowIndex:= 0;
  dmClients.ResetTimePanel(pnlTmrSuiviPortable);
end;

procedure TSyntheseFrm.LoadSuiviServeur;
begin
  dmClients.XmlToDataSet('Emetteur?Synthese=SuiviServeur', dmClients.CDSSuiviServeur);
  cxGridDBTWSuiviServeur.DataController.Groups.FullExpand;
  cxGridDBTWSuiviServeur.DataController.FocusedRowIndex:= 0;
  dmClients.ResetTimePanel(pnlTmrSuiviServeur);
end;

procedure TSyntheseFrm.LoadSuiviServeurVIP;
begin
  dmClients.XmlToDataSet('Emetteur?Synthese=SuiviVIP', dmClients.CDSSuiviServeurVIP);
  cxGridDBTWSuiviVIP.DataController.Groups.FullExpand;
  cxGridDBTWSuiviVIP.DataController.FocusedRowIndex:= 0;
  dmClients.ResetTimePanel(pnlTmrSuiviVIP);
end;

procedure TSyntheseFrm.LoadSuiviSrvReplication;
var
  Buffer: String;
  vIdHTTP: TIdHTTP;
begin
  if CmbBxListLame.ItemIndex = -1 then
    Exit;

  vIdHTTP:= dmClients.GetNewIdHTTP(nil);
  try
    Buffer:= vIdHTTP.Get(GParams.Url + 'SynchronizeSVRStarted');
    if Buffer <> '' then
      begin
        pnlTopSuiviSrvReplic.Caption:= Buffer;
        Exit;
      end;

    dmClients.CDSSuiviSrvReplication.EmptyDataSet;
    CmbBxListLame.Enabled:= False;
    cxGridSuiviSrvReplication.Enabled:= False;
    pnlTmrSuiviSrvReplication.Caption:= '';
    pnlTopSuiviSrvReplic.Caption:= 'Recherche en cours...';
    FThrdSuiviSrvReplication:= TThrdSuiviSrvReplication.create(True);
    FThrdSuiviSrvReplication.APRH_SRVID:= VarToStr(TGenerique(SyntheseFrm.CmbBxListLame.Items.Objects[SyntheseFrm.CmbBxListLame.ItemIndex]).ID);
    FThrdSuiviSrvReplication.OnTerminate:= p_OnTerminate;
    FThrdSuiviSrvReplication.FreeOnTerminate:= True;
    FThrdSuiviSrvReplication.priority:= tpNormal;
    FThrdSuiviSrvReplication.Resume;
  finally
    FreeAndNil(vIdHTTP);
  end;
end;

procedure TSyntheseFrm.PgCtrlSyntheseChange(Sender: TObject);
begin
  inherited;
  FCurrentGrid:= TcxGrid(PgCtrlSynthese.ActivePage.Tag);
  StBrSynthese.SimpleText:= dmClients.CountRecCxGrid(FCurrentGrid);
  ToolBarSynthese.ActTool.Visible:= (PgCtrlSynthese.ActivePage.Name = 'TbshtHoraireRep') and (CmBxSrv.ItemIndex <> -1);
  ToolBarSynthese.ActDelete.Visible:= (PgCtrlSynthese.ActivePage.Name = 'TbshtSuiviServeurRep') and (CmbBxListLame.ItemIndex <> -1);
  ToolBarSynthese.ActEmail.Visible:= (PgCtrlSynthese.ActivePage.Name = 'TbshtSuiviRepEtBaseHS') or
                                     (PgCtrlSynthese.ActivePage.Name = 'TbshtSuiviServeur') or
                                     (PgCtrlSynthese.ActivePage.Name = 'TbshtSuiviPortable') or
                                     (PgCtrlSynthese.ActivePage.Name = 'TbshtSuiviVIP');
end;

procedure TSyntheseFrm.PlageEmetteurToDataSet;

  procedure SetValueToPlageHoraire(Const AFieldHeure, AFieldHeureAllow: String);
  var
    i: integer;
    vTime: TTime;
    vColumn: TcxGridDBBandedColumn;
    vPlageHorDeb, vPlageHorFin: TPlageHoraire;
  begin
    if not DsHoraire.DataSet.FieldByName(AFieldHeure).IsNull then
      begin
        if DsHoraire.DataSet.FieldByName(AFieldHeureAllow).AsInteger = 1 then
          begin
            vTime:= DateTimeToTime(DsHoraire.DataSet.FieldByName(AFieldHeure).AsDateTime);
            for i:= 10 to DsHoraire.DataSet.FieldCount - 1 do
              begin
                if DsHoraire.DataSet.Fields.Fields[i].Tag <> 0 then
                  begin
                    vColumn:= TcxGridDBBandedColumn(DsHoraire.DataSet.Fields.Fields[i].Tag);
                    SearchBorneReplic(vColumn, vPlageHorDeb, vPlageHorFin);
                    if (vPlageHorDeb <> nil) and (vPlageHorFin <> nil) and
                       (vPlageHorDeb.ATime <= vTime) and (vTime < vPlageHorFin.ATime) then
                      begin
                        DsHoraire.DataSet.Edit;
                        DsHoraire.DataSet.Fields.Fields[i].AsBoolean:= True;
                        DsHoraire.DataSet.Post;
                        Break;
                      end;
                  end;
              end;
          end;
      end;
  end;

begin
  DsHoraire.DataSet.DisableControls;
  try
    DsHoraire.DataSet.First;
    while not DsHoraire.DataSet.Eof do
      begin
        SetValueToPlageHoraire('EMET_HEURE1', 'EMET_H1');
        SetValueToPlageHoraire('EMET_HEURE2', 'EMET_H2');
        DsHoraire.DataSet.Next;
      end;
    DsHoraire.DataSet.First;
  finally
    DsHoraire.DataSet.EnableControls;
  end;
end;

procedure TSyntheseFrm.p_OnGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  Text:= FormatDateTime('hh:nn', Sender.AsDateTime);
  if (Sender.FieldName = 'EMET_HEURE1') and (dmClients.CDSHoraire.FieldByName('EMET_H1').AsInteger = 0) then
    Text:= '-';
  if (Sender.FieldName = 'EMET_HEURE2') and (dmClients.CDSHoraire.FieldByName('EMET_H2').AsInteger = 0) then
    Text:= '-';
end;

procedure TSyntheseFrm.p_OnTerminate(Sender: TObject);
var
  vParser: TParser;
begin
  try
    CmbBxListLame.Enabled:= True;
    cxGridSuiviSrvReplication.Enabled:= True;
    pnlTopSuiviSrvReplic.Caption:= '';
    if FThrdSuiviSrvReplication.AParser.ADataSet.RecordCount <> 0 then
      begin
        BatchMove(FThrdSuiviSrvReplication.AParser.ADataSet, dmClients.CDSSuiviSrvReplication);
        StBrSynthese.SimpleText:= dmClients.CountRecCxGrid(cxGridSuiviSrvReplication);
        dmClients.ResetTimePanel(pnlTmrSuiviSrvReplication);
        ToolBarSynthese.ActDelete.Visible:= PgCtrlSynthese.ActivePage.Name = 'TbshtSuiviServeurRep';
      end;
  finally
    vParser:= FThrdSuiviSrvReplication.AParser;
    FreeAndNil(vParser);
    MainFrm.TrayIconMain.BalloonTitle:= 'Suivi des serveurs de réplication';
    MainFrm.TrayIconMain.BalloonHint:= '' + cRC + 'Recherche terminée.';
    MainFrm.TrayIconMain.BalloonTimeout:= 30000;
    MainFrm.TrayIconMain.BalloonFlags:= bfInfo;
    MainFrm.TrayIconMain.ShowBalloonHint;
  end;
end;

procedure TSyntheseFrm.p_OnTimer(Sender: TObject);
begin
  TTimer(Sender).Enabled:= False;
  TPanel(TTimer(Sender).Tag).Font.Color:= clRed; { Alerte visuelle }
end;

procedure TSyntheseFrm.p_FooterSummaryItemsGetText(Sender: TcxDataSummaryItem;
  const AValue: Variant; AIsFooter: Boolean; var AText: String);
begin
 if not VarIsNull(AValue) then
    AText:= IntToStr(Round(Abs(AValue)));
end;

procedure TSyntheseFrm.RefreshHoraire;
var
  i, vCptNbDefault: integer;
  vPlageHoraire: TPlageHoraire;
  vTDeb, vTFin: TTime;
  vPRH_SRVID: String;
begin
  Screen.Cursor:= crHourGlass;
  try
    { Recuperation de l'ID de la Lame }
    vPRH_SRVID:= VarToStr(TGenerique(CmBxSrv.Items.Objects[CmBxSrv.ItemIndex]).ID);

    { Chargement Horaire pour un Lame }
    dmClients.XmlToDataSet('Emetteur?SRV_ID=' + vPRH_SRVID, dmClients.CDSHoraire);
    Screen.Cursor:= crHourGlass;
    PlageEmetteurToDataSet;

    { Filtrage du ClientdataSet des paramètres horaire }
    dmClients.CDS_PARAMHORAIRES.Filtered:= False;
    dmClients.CDS_PARAMHORAIRES.Filter:= 'PRH_SRVID=' + vPRH_SRVID;
    dmClients.CDS_PARAMHORAIRES.Filtered:= True;

    { Chargement des parametres horaire pour une Lame }
    vCptNbDefault:= 0;
    if dmClients.CDS_PARAMHORAIRES.Locate('PRH_DEFAUT', 1, []) then
      vCptNbDefault:= dmClients.CDS_PARAMHORAIRES.FieldByName('PRH_NBREPLIC').AsInteger;

    for i:= 0 to cxGridDBBandedTWHoraire.DataController.Summary.FooterSummaryItems.Count - 1 do
      begin
        vPlageHoraire:= TPlageHoraire(cxGridDBBandedTWHoraire.DataController.Summary.FooterSummaryItems.Items[i].Tag);
        vPlageHoraire.NbReplicDefault:= vCptNbDefault;
        vPlageHoraire.NbReplic:= 0;
        if dmClients.CDS_PARAMHORAIRES.RecordCount <> 0 then
          begin
            dmClients.CDS_PARAMHORAIRES.First;
            while not dmClients.CDS_PARAMHORAIRES.Eof do
              begin
                if dmClients.CDS_PARAMHORAIRES.FieldByName('PRH_DEFAUT').AsInteger <> 1 then
                  begin
                    vPlageHoraire.NbReplic:= vCptNbDefault;
                    vTDeb:= DateTimeToTime(dmClients.CDS_PARAMHORAIRES.FieldByName('PRH_HDEB').AsDateTime);
                    vTFin:= DateTimeToTime(dmClients.CDS_PARAMHORAIRES.FieldByName('PRH_HFIN').AsDateTime);
                    vPlageHoraire.Disponible:= True;
                    if (vPlageHoraire.ATime >= vTDeb) and (vPlageHoraire.ATime <= vTFin) then
                      begin
                        if dmClients.CDS_PARAMHORAIRES.FieldByName('PRH_NBREPLIC').AsInteger = 0 then
                          vPlageHoraire.Disponible:= False;
                        vPlageHoraire.NbReplic:= dmClients.CDS_PARAMHORAIRES.FieldByName('PRH_NBREPLIC').AsInteger;
                        Break;
                      end;
                  end
                else
                  begin
                    vPlageHoraire.NbReplic:= dmClients.CDS_PARAMHORAIRES.FieldByName('PRH_NBREPLIC').AsInteger;
                    vPlageHoraire.Disponible:= True;
                  end;
                dmClients.CDS_PARAMHORAIRES.Next;
              end;
          end
        else
          vPlageHoraire.Disponible:= False;

        SetColorHoraire(vPlageHoraire.AColumn, cxGridDBBandedTWHoraire.DataController.Summary);
      end;
  finally
    StBrSynthese.SimpleText:= dmClients.CountRecCxGrid(FCurrentGrid);
    dmClients.ResetTimePanel(pnlTmrTimeHoraire);
    ToolBarSynthese.ActTool.Visible:= (PgCtrlSynthese.ActivePage.Name = 'TbshtHoraireRep') and (CmBxSrv.ItemIndex <> -1);
    Screen.Cursor:= crDefault;
  end;
end;

procedure TSyntheseFrm.SearchBorneReplic(const AColumn: TcxGridDBBandedColumn;
  var APlageHorDeb, APlageHorFin: TPlageHoraire);
var
  vSummaryItem: TcxDataSummaryItem;
begin
  APlageHorDeb:= nil;
  APlageHorFin:= nil;
  if (AColumn <> nil) and (AColumn.Tag <> 0) then
    begin
      vSummaryItem:= TcxDataSummaryItem(AColumn.Tag);
      if vSummaryItem.Tag <> 0 then
        begin
          APlageHorDeb:= TPlageHoraire(vSummaryItem.Tag);
          APlageHorFin:= APlageHorDeb.NextPlageHoraire;
        end;
    end;
end;

procedure TSyntheseFrm.ShowDetailErreur;
var
  vFrmMemo: TMemoFrm;
begin
  if cxGridDBTWSuiviSrvReplication.DataController.DataSource.DataSet.RecordCount <> 0 then
    begin
      vFrmMemo:= TMemoFrm.Create(nil);
      try
        vFrmMemo.Caption:= 'Erreur détail (' + dmClients.CDSSuiviSrvReplication.FieldByName('SVR_DATABASE').AsString + '/' +
                                               dmClients.CDSSuiviSrvReplication.FieldByName('SVR_SENDER').AsString + ')';
        vFrmMemo.Memo.Lines.Text:= dmClients.CDSSuiviSrvReplication.FieldByName('SVR_ERR').AsString;
        vFrmMemo.ShowModal;
      finally
        FreeAndNil(vFrmMemo);
      end;
    end;
end;

procedure TSyntheseFrm.ShowDetailRaison;
var
  vDlgRaisonFrm: TDlgRaisonFrm;
  vDS: TDataSet;
begin
  vDS:= TcxGridDBTableView(FCurrentGrid.ActiveView).DataController.DataSource.DataSet;
  if (vDS = nil) or (vDS.RecordCount = 0) then
    Exit;
  vDlgRaisonFrm:= TDlgRaisonFrm.Create(nil);
  try
    vDlgRaisonFrm.ADataSet:= vDS;
    if vDlgRaisonFrm.ShowModal = mrOk then
      begin
        vDS.Edit;
        vDS.FieldByName('RAISON_ID').AsInteger:= dmClients.CDSRAISONS.FieldByName('RAISON_ID').AsInteger;
        vDS.FieldByName('RAISON_NOM').AsString:= dmClients.CDSRAISONS.FieldByName('RAISON_NOM').AsString;
        vDS.Post;
      end;
  finally
    FreeAndNil(vDlgRaisonFrm);
  end;
end;

procedure TSyntheseFrm.ShowSendMail;
var
  i, vEMET_ID: integer;
  vModeleMailFrm: TDlgModeleMailFrm;
  vcxGridDBColumn: TcxGridDBColumn;
begin
  vModeleMailFrm:= TDlgModeleMailFrm.Create(nil);
  try
    if vModeleMailFrm.ShowModal = mrOk then
      begin
        Screen.Cursor:= crHourGlass;
        dmClients.CDSSendMail.EmptyDataSet;
        for i:= 0 to FCurrentGrid.Controller.Control.FocusedView.DataController.RowCount - 1 do
          begin
            if TcxGridDBTableView(FCurrentGrid.ActiveView).ViewData.Rows[i].Selected then
              begin
                vcxGridDBColumn:= TcxGridDBTableView(FCurrentGrid.ActiveView).GetColumnByFieldName('EMET_ID');
                if vcxGridDBColumn <> nil then
                  begin
                    vEMET_ID:= TcxGridDBTableView(FCurrentGrid.ActiveView).ViewData.Rows[i].Values[vcxGridDBColumn.Index];
                    dmClients.CDSSendMail.Append;
                    dmClients.CDSSendMail.FieldByName('EMET_ID').AsInteger:= vEMET_ID;
                    dmClients.CDSSendMail.FieldByName('MAIL_FILENAME').AsString:= dmClients.CDSModeleMail.FieldByName('MAIL_FILENAME').AsString;
                    dmClients.CDSSendMail.Post;
                  end;
              end;
          end;
        if dmClients.CDSSendMail.RecordCount <> 0 then
          dmClients.PostRecordToXml('SendMailEmetteur', 'TEmetteur', dmClients.CDSSendMail, nil, True);
      end;
  finally
    FreeAndNil(vModeleMailFrm);
    Screen.Cursor:= crDefault;
  end;
end;

procedure TSyntheseFrm.SetColorHoraire(Const AColumn: TcxGridDBBandedColumn;
  Const ASender: TcxDataSummary);
var
  vPlageHoraire: TPlageHoraire;
  vSummaryItem: TcxDataSummaryItem;
  vSumReplic: integer;
  vAfterSummaryEvent: TcxAfterSummaryEvent;
begin
  vAfterSummaryEvent:= nil;
  if AColumn <> nil then
    begin
      try
        vAfterSummaryEvent:= cxGridDBBandedTWHoraire.DataController.Summary.OnAfterSummary;
        cxGridDBBandedTWHoraire.DataController.Summary.OnAfterSummary:= nil;

        vSummaryItem:= TcxDataSummaryItem(AColumn.Tag);
        vPlageHoraire:= TPlageHoraire(vSummaryItem.Tag);
        vSumReplic:= 0;
        AColumn.Styles.Content:= nil;
        if (not VarIsNull(ASender.FooterSummaryValues[vSummaryItem.Index])) and
           (ASender.FooterSummaryValues[vSummaryItem.Index] <> 0) then
          vSumReplic:= Abs(Integer(ASender.FooterSummaryValues[vSummaryItem.Index]));
        if not vPlageHoraire.Disponible then
            AColumn.Styles.Content:= cxStyleHoraireNonDisponible;
        if vSumReplic <> 0 then
          begin
            if vPlageHoraire.NbReplic < vSumReplic then
              AColumn.Styles.Content:= cxStyleDebordementNbRep
            else
              if vPlageHoraire.NbReplic = vSumReplic then
                AColumn.Styles.Content:= cxStyleNbRepOk;
          end;
      finally
        cxGridDBBandedTWHoraire.DataController.Summary.OnAfterSummary:= vAfterSummaryEvent;
      end;
    end;
end;

procedure TSyntheseFrm.SpdBtnDesactiverClick(Sender: TObject);
begin
  inherited;
  CheckedReplication('', '', False);
end;

procedure TSyntheseFrm.SpdBtnHoraireDispClick(Sender: TObject);
begin
  inherited;
  if CmBxSrv.ItemIndex = -1 then
    Exit;
  LoadHorairesDispo;
end;

procedure TSyntheseFrm.SpdBtnReplic1Click(Sender: TObject);
begin
  inherited;
  CheckedReplication('EMET_HEURE1', 'EMET_H1');
end;

procedure TSyntheseFrm.SpdBtnReplic2Click(Sender: TObject);
begin
  inherited;
  CheckedReplication('EMET_HEURE2', 'EMET_H2');
end;

procedure TSyntheseFrm.ToolBarSyntheseActDeleteExecute(Sender: TObject);
begin
  inherited;
  ToolBarSynthese.ActDeleteExecute(Sender);
  if (PgCtrlSynthese.ActivePage.Name = 'TbshtSuiviServeurRep') and
     (dmClients.CDSSuiviSrvReplication.RecordCount <> 0) then
    begin
      Screen.Cursor:= crHourGlass;
      try
        dmClients.DeleteRecordByRessource('SuiviSrvReplication?SVR_PATH=' + dmClients.CDSSuiviSrvReplication.FieldByName('SVR_PATH').AsString);
        dmClients.CDSSuiviSrvReplication.Delete;
      finally
        Screen.Cursor:= crDefault;
      end;
    end;
end;

procedure TSyntheseFrm.ToolBarSyntheseActEmailExecute(Sender: TObject);
begin
  inherited;
  ShowSendMail;
end;

procedure TSyntheseFrm.ToolBarSyntheseActExcelExecute(Sender: TObject);
begin
  inherited;
  if FCurrentGrid <> nil then
    SaveGridToXLS(FCurrentGrid, True);
end;

procedure TSyntheseFrm.ToolBarSyntheseActRefreshExecute(Sender: TObject);
begin
  inherited;
  case PgCtrlSynthese.ActivePageIndex of
    0: LoadSuiviRepEtBaseHS;               { Chargement Suivi de la réplication et des Bases HS }
    1: LoadSuiviServeur;                   { Chargement Suivi des serveurs }
    2: LoadSuiviPortableEtPortableSynchro; { Chargement Suivi des portables et portable synchro }
    3: LoadSuiviServeurVIP;                { Chargement Suivi VIP }
    4: LoadSuiviSrvReplication;            { Chargement des serveurs de replication pour une Lame }
    5: LoadModule;                         { Chargement des Modules }
    6: LoadJeton;                          { Chargement des Jetons }
    7: LoadHoraire;                        { Chargement des paramètres horaires + Chargement de la liste des Lames pour les horaires}
  end;
end;

procedure TSyntheseFrm.ToolBarSyntheseActToolExecute(Sender: TObject);
var
  vParamHoraireFrm: TParamHoraireFrm;
begin
  inherited;
  vParamHoraireFrm:= TParamHoraireFrm.Create(nil);
  try
    vParamHoraireFrm.pnlTimeValues.Caption:= pnlTmrTimeHoraire.Caption;
    vParamHoraireFrm.AServeur:= TGenerique(CmBxSrv.Items.Objects[CmBxSrv.ItemIndex]);
    vParamHoraireFrm.ShowModal;
    if vParamHoraireFrm.Modified then
      LoadHoraire;
  finally
    FreeAndNil(vParamHoraireFrm);
  end;
end;

end.
