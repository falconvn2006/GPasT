
//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------

unit Import_dm;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ActionRv,
  Db,
  dxmdaset,
  DBTables,
  Wwtable,
  IBDataset,
  IB_Components,

  Main_frm;

type
  Tdm_import = class(TDataModule)
    Grd_Que: TGroupDataRv;
    MemD_GT: TdxMemData;
    MemD_GTNum: TStringField;
    MemD_GTLibGt: TStringField;
    MemD_GTTail: TStringField;
    MemD_GTLibcourt: TStringField;
    MemD_GTLibLong: TStringField;
    Que_GT: TIBOQuery;
    Que_GTGTF_ID: TIntegerField;
    Que_GTGTF_IDREF: TIntegerField;
    Que_GTGTF_NOM: TStringField;
    Que_GTGTF_TGTID: TIntegerField;
    Oskar: TDatabase;
    Gt_OSK: TwwTable;
    MemD_GTRef: TStringField;
    IbQ_TAIL: TIB_Query;
    Import: TIB_Database;
    Corres_GT: TIBOTable;
    Que_GTGTF_IMPORT: TIntegerField;
    Que_GTGTF_ORDREAFF: TIBOFloatField;
    IbQ_Fourn: TIB_Query;
    MemD_Fourn: TdxMemData;
    MemD_Fournnum: TStringField;
    MemD_FournRS: TStringField;
    MemD_Fournadr: TStringField;
    MemD_Fourncp: TStringField;
    MemD_FournVille: TStringField;
    MemD_FournTel: TStringField;
    MemD_FournFax: TStringField;
    MemD_FournNocli: TStringField;
    MemD_FournCorres: TStringField;
    MemD_FournRemise: TStringField;
    IbC_CP: TIB_Cursor;
    Corres_Four: TIBOTable;
    MemD_FournIDGinkoia: TStringField;
    MemD_NK: TdxMemData;
    Corres_NK: TIBOTable;
    MemD_NKSSFHusky: TStringField;
    MemD_NKSSFGinkoia: TStringField;
    IbQ_Ray: TIB_Query;
    IbQ_Fam: TIB_Query;
    IbQ_SF: TIB_Query;
    Corres_NKSF_HUSKY: TStringField;
    Corres_NKSF_GINKOIA: TIntegerField;
    MemD_Nom: TdxMemData;
    MemD_NomNum: TStringField;
    MemD_NomRayon: TStringField;
    MemD_NomFam: TStringField;
    MemD_NomSF: TStringField;
    MemD_Art: TdxMemData;
    MemD_ArtCode: TStringField;
    MemD_ArtChrono: TStringField;
    MemD_ArtDesi: TStringField;
    MemD_ArtGT: TStringField;
    MemD_ArtDtcrea: TStringField;
    MemD_ArtTxDep: TStringField;
    MemD_ArtLibDep: TStringField;
    MemD_ArtFourn: TStringField;
    MemD_ArtArchi: TStringField;
    MemD_ArtDtDep: TStringField;
    MemD_ArtCC1: TStringField;

    MemD_ArtCL1: TStringField;
    MemD_ArtCC2: TStringField;
    MemD_ArtCC3: TStringField;
    MemD_ArtCC4: TStringField;
    MemD_ArtCC5: TStringField;
    MemD_ArtCC6: TStringField;
    MemD_ArtCC7: TStringField;
    MemD_ArtCC8: TStringField;
    MemD_ArtCC9: TStringField;
    MemD_ArtCC10: TStringField;
    MemD_ArtCC11: TStringField;
    MemD_ArtCC12: TStringField;
    MemD_ArtCC13: TStringField;
    MemD_ArtCC14: TStringField;
    MemD_ArtCC15: TStringField;
    MemD_ArtCC16: TStringField;
    MemD_ArtCC17: TStringField;
    MemD_ArtCC18: TStringField;
    MemD_ArtCC19: TStringField;
    MemD_ArtCC20: TStringField;
    MemD_ArtCL2: TStringField;
    MemD_ArtCL3: TStringField;
    MemD_ArtCL4: TStringField;
    MemD_ArtCL5: TStringField;
    MemD_ArtCL6: TStringField;
    MemD_ArtCL7: TStringField;
    MemD_ArtCL8: TStringField;
    MemD_ArtCL9: TStringField;
    MemD_ArtCL10: TStringField;
    MemD_ArtCL11: TStringField;
    MemD_ArtCL12: TStringField;
    MemD_ArtCL13: TStringField;
    MemD_ArtCL14: TStringField;
    MemD_ArtCL15: TStringField;
    MemD_ArtCL16: TStringField;
    MemD_ArtCL17: TStringField;
    MemD_ArtCL18: TStringField;
    MemD_ArtCL19: TStringField;
    MemD_ArtCL20: TStringField;
    IbC_Ktb: TIB_Cursor;
    IbC_Art: TIB_Cursor;
    IbC_Ref: TIB_Cursor;
    Que_Class1: TIBOQuery;
    Que_Class2: TIBOQuery;
    MemD_FournMrkGinkoia: TStringField;
    IbC_Fourn: TIB_Cursor;
    MemD_ArtRefourn: TStringField;
    MemD_Artcritere: TStringField;
    MemD_ArtTva: TStringField;
    MemD_ArtSecteur: TStringField;
    IbC_SF: TIB_Cursor;
    IbC_GT: TIB_Cursor;
    MemD_ArtGenre: TStringField;
    IbC_Genre: TIB_Cursor;
    MemD_ArtFidel: TStringField;
    IbC_Coul: TIB_Cursor;
    IbC_Tail: TIB_Cursor;
    IbC_TT: TIB_Cursor;
    Tbl_Art: TIBOTable;
    Tbl_ArtART_HUSKY: TStringField;
    Tbl_ArtTAIL_HUSKY: TIntegerField;
    Tbl_ArtCOUL_HUSKY: TIntegerField;
    Tbl_ArtART_GINKOIA: TIntegerField;
    Tbl_ArtTAIL_GINKOIA: TIntegerField;
    Tbl_ArtCOUL_GINKOIA: TIntegerField;
    MemD_Tarifs: TdxMemData;
    IbC_Achat: TIB_Cursor;
    IbC_Vente: TIB_Cursor;
    MemD_Tarifscode: TStringField;
    MemD_TarifsTail: TStringField;
    MemD_TarifsAchat: TStringField;
    MemD_TarifsVente: TStringField;
    MemD_TarifsFourn: TStringField;
    IbC_Fou: TIB_Cursor;
    IbC_AT: TIB_Cursor;
    IbC_Arti: TIB_Cursor;
    MemD_TarifsCatal: TStringField;
    MemD_Stk: TdxMemData;
    MemD_StkCode: TStringField;
    MemD_StkMag: TStringField;
    MemD_StkTail: TStringField;
    MemD_StkCoul: TStringField;
    MemD_StkQte: TStringField;
    MemD_StkPx: TStringField;
    IbC_brl: TIB_Cursor;
    IbC_ATC: TIB_Cursor;
    IbC_BR: TIB_Cursor;
    MemD_ArtDescript: TStringField;
    MemD_CB: TdxMemData;
    IbC_CB: TIB_Cursor;
    MemD_CBArticle: TStringField;
    MemD_CBTail: TStringField;
    MemD_CBCoul: TStringField;
    MemD_CBCB: TStringField;
    IbC_ArtRef: TIB_Cursor;
    MemD_MVT: TdxMemData;
    IbC_BL: TIB_Cursor;
    IbC_BLL: TIB_Cursor;
    MemD_MVTCode: TStringField;
    MemD_MVTMag: TStringField;
    MemD_MVTTail: TStringField;
    MemD_MVTCoul: TStringField;
    MemD_MVTTes: TStringField;
    MemD_MVTQte: TStringField;
    MemD_MVTPxb: TStringField;
    MemD_MVTPxn: TStringField;
    MemD_MVTTva: TStringField;
    MemD_MVTSAAMM: TStringField;
    IbC_ENTBR: TIB_Cursor;
    IbC_ENTBL: TIB_Cursor;
    IbQ_Conso: TIB_Query;
    IbC_CDV: TIB_Cursor;
    IbC_Typ: TIB_Cursor;
    IbQ_Tva: TIB_Query;
    IbQ_Class: TIB_Query;
    IbC_Tct: TIB_Cursor;
    IbC_Pays: TIB_Cursor;
    IbC_Adr: TIB_Cursor;
    IbC_Clt: TIB_Cursor;
    //Client: TdxAlgolProto;
    Client: TdxMemData;
    Clientnom: TStringField;
    Clientprenom: TStringField;
    Clientadresse: TStringField;
    Clientcp: TStringField;
    Clientville: TStringField;
    Clientpolitesse: TStringField;
    Clientdpp: TStringField;
    Clientddp: TStringField;
    Clientobs: TStringField;
    Clienttelp: TStringField;
    Clienttelt: TStringField;
    Clientcf: TStringField;
    Clientsexe: TStringField;
    Clientjanni: TStringField;
    ClientEncours: TStringField;
    Clientcateg: TStringField;
    ClientCrit1: TStringField;
    Clientcrit2: TStringField;
    Clientcrit3: TStringField;
    Clientcrit4: TStringField;
    Clientcrit5: TStringField;
    Clientpays: TStringField;
    Clientta: TStringField;
    Clientnumero: TStringField;
    ClientID_Ville: TStringField;
    MemD_Mag: TdxMemData;
    MemD_MagNum: TStringField;
    MemD_MagLiblong: TStringField;
    MemD_MagLibcourt: TStringField;
    MemD_MagRS: TStringField;
    MemD_MagADR: TStringField;
    MemD_Magcp: TStringField;
    MemD_MagVille: TStringField;
    MemD_MagTel: TStringField;
    MemD_MagFax: TStringField;
    MemD_MagRC: TStringField;
    MemD_MagComent: TStringField;
    MemD_Magcdadh: TStringField;
    IbQ_Mag: TIB_Query;
    MemD_Cde: TdxMemData;
    MemD_CdeCode: TStringField;
    MemD_CdeTail: TStringField;
    MemD_CdeCoul: TStringField;
    MemD_CdeMag: TStringField;
    MemD_CdeNumCde: TStringField;
    MemD_CdeQte: TStringField;
    MemD_CdePxCatal: TStringField;
    MemD_CdeR1: TStringField;
    MemD_CdeR2: TStringField;
    MemD_CdeR3: TStringField;
    MemD_CdePxnn: TStringField;
    MemD_CdeTva: TStringField;
    MemD_CdeDtLiv: TStringField;
    MemD_CdeDtLim: TStringField;
    MemD_CdePxVente: TStringField;
    MemD_CdeC_Fourn: TStringField;
    MemD_CdeC_Rbp: TStringField;
    MemD_CdeC_date: TStringField;
    MemD_CdeC_Dliv: TStringField;
    MemD_CdeC_offset: TStringField;
    MemD_CdeC_coment: TStringField;
    IbC_Cde: TIB_Cursor;
    IbC_Cdl: TIB_Cursor;
    IbC_TestCde: TIB_Cursor;
    IbQ_Cde: TIB_Query;
    IbC_Cumul: TIB_Cursor;
    MemD_Cpt: TdxMemData;
    MemD_CptCode: TStringField;
    MemD_CptMag: TStringField;
    MemD_CptLib: TStringField;
    MemD_CptDate: TStringField;
    MemD_CptDebit: TStringField;
    MemD_CptCredit: TStringField;
    MemD_CptDtreg: TStringField;
    IbC_Cli: TIB_Cursor;
    IbC_Cpt: TIB_Cursor;
    IbQ_GrpClt: TIB_Query;
    IbQ_MagClt: TIB_Query;
    MemD_MVTFourn: TStringField;
    IbQ_Civ: TIB_Query;
    MemD_ArtPseudo: TStringField;
    Que_Categ: TIBOQuery;
    IbQ_Univers: TIB_Query;
    IbQ_NkGts: TIB_Query;
    IbC_TV: TIB_Cursor;
    MemD_NomRV: TStringField;
    MemD_NomFV: TStringField;
    MemD_NomSV: TStringField;
    MemD_Fid: TdxMemData;
    StringField1: TStringField;
    StringField3: TStringField;
    StringField4: TStringField;
    StringField6: TStringField;
    Que_Poste: TIBOQuery;
    IbC_MP: TIB_Cursor;
    IbQ_Session: TIB_Query;
    ClientGarant: TStringField;
    Que_TarVente: TIBOQuery;
    MemD_TarifsVente2: TStringField;
    MemD_TarifsVente3: TStringField;
    Que_TarPrix: TIBOQuery;
    Que_Statut: TIBOQuery;
    MemD_Statut: TdxMemData;
    MemD_StatutNum: TStringField;
    MemD_StatutLib: TStringField;
    MemD_Resi: TdxMemData;
    Que_Resi: TIBOQuery;
    MemD_ResiNum: TStringField;
    MemD_ResiLib: TStringField;
    MemD_Categ: TdxMemData;
    MemD_CategNum: TStringField;
    MemD_CategLib: TStringField;
    MemD_CategGT: TStringField;
    MemD_Categbaton: TStringField;
    MemD_Categlibcourt: TStringField;
    MemD_CategTVA: TStringField;
    MemD_CategCOMPTA: TStringField;
    MemD_CategFIXA: TStringField;
    MemD_CategCAUTION: TStringField;
    MemD_CategAMORT: TStringField;
    Que_CategLoc: TIBOQuery;
    Que_Class: TIBOQuery;
    MemD_Artloc: TdxMemData;
    MemD_Artlocnum: TStringField;
    MemD_Artlocmanuel: TStringField;
    MemD_Artloccateg: TStringField;
    MemD_Artlocfourn: TStringField;
    MemD_Artloclib1: TStringField;
    MemD_Artloclib2: TStringField;
    MemD_Artlocstatut: TStringField;
    MemD_Artloccouleur: TStringField;
    MemD_Artlocserie: TStringField;
    MemD_Artlocdivers: TStringField;
    MemD_Artloccrit1: TStringField;
    MemD_Artloccrit2: TStringField;
    MemD_Artlocpxa: TStringField;
    MemD_Artlocpxasup: TStringField;
    MemD_Artlocdateachat: TStringField;
    MemD_Artlocdatecession: TStringField;
    MemD_Artlocpxcession: TStringField;
    MemD_Artloclibtaille: TStringField;
    MemD_Artlocdureeamt: TStringField;
    MemD_ArtlocsommeAmt: TStringField;
    MemD_Artlocderamt: TStringField;
    MemD_ArtlocGT: TStringField;
    MemD_Artlocpseudo: TStringField;
    MemD_ArtlocSES: TStringField;
    IbC_IndGT: TIB_Cursor;
    MemD_Artlocarchiver: TStringField;
    IbC_Chrono: TIB_Cursor;
    MemD_ArtlocCB: TStringField;
    MemD_Artlocsalo1: TStringField;
    MemD_Artlocsalo2: TStringField;
    Que_Typc: TIBOQuery;
    THEO: TIB_Connection;
    THEO_RAY: TIB_Cursor;
    THEO_FAM: TIB_Cursor;
    THEO_COMPO: TIB_Cursor;
    Que_Ray: TIBOQuery;
    Que_Fam: TIBOQuery;
    Que_Compo: TIBOQuery;
    MemD_Orga: TdxMemData;
    MemD_OrgaNum: TStringField;
    MemD_OrgaLib: TStringField;
    MemD_OrgaAD1: TStringField;
    MemD_OrgaAD2: TStringField;
    MemD_OrgaCP: TStringField;
    MemD_OrgaVILLE: TStringField;
    MemD_OrgaPAYS: TStringField;
    MemD_OrgaTEL: TStringField;
    MemD_OrgaFAX: TStringField;
    MemD_OrgaRESI: TStringField;
    Que_Orga: TIBOQuery;
    Que_Client: TIBOQuery;
    MemD_Info: TdxMemData;
    MemD_Infonum: TStringField;
    MemD_InfoRESI: TStringField;
    MemD_InfoAD1: TStringField;
    MemD_InfoAD2: TStringField;
    MemD_Infoorga: TStringField;
    IB_Cursor2: TIB_Cursor;
    IbC_Tva: TIB_Cursor;
    IbC_Tctl: TIB_Cursor;
    Que_Itemc: TIBOQuery;
    MemD_CP: TdxMemData;
    MemD_CPcodepostal: TStringField;
    MemD_CPville: TStringField;
    Que_Produit: TIBOQuery;
    IbC_Produit: TIB_Cursor;
    Que_PrdTC: TIBOQuery;
    Que_TypcTCA_ID: TIntegerField;
    Que_TypcTCA_NOM: TStringField;
    Que_PrdTCTYC_ID: TIntegerField;
    Que_PrdTCTYC_COMID: TIntegerField;
    Que_PrdTCTYC_TCAID: TIntegerField;
    Que_PrdTCTYC_RAT: TIBOFloatField;
    Que_Prdlg: TIBOQuery;
    Que_PrdlgPRL_ID: TIntegerField;
    Que_PrdlgPRL_CALID: TIntegerField;
    Que_PrdlgPRL_TYCID: TIntegerField;
    IbC_Loa: TIB_Cursor;
    IbC_Loc: TIB_Cursor;
    HL: TdxMemData;
    HLclient: TStringField;
    HLdate: TStringField;
    HLarticle: TStringField;
    HLcateg: TStringField;
    HLbrut: TStringField;
    HLnet: TStringField;
    HLassur: TStringField;
    HLnbj: TStringField;
    HLident: TStringField;
    IbC_LOCART: TIB_Cursor;
    IbC_Prd: TIB_Cursor;
    IB_Cursor1: TIB_Cursor;
    IbC_France: TIB_Cursor;
    Que_Param: TIBOQuery;
    Que_ParamPRM_ID: TIntegerField;
    Que_ParamPRM_CODE: TIntegerField;
    Que_ParamPRM_INTEGER: TIntegerField;
    Que_ParamPRM_FLOAT: TIBOFloatField;
    Que_ParamPRM_STRING: TStringField;
    Que_ParamPRM_TYPE: TIntegerField;
    Que_ParamPRM_MAGID: TIntegerField;
    Que_ParamPRM_INFO: TStringField;
    Que_ParamPRM_POS: TIntegerField;
    IbC_Gt2: TIB_Cursor;
    MemD_Artloclibgt: TStringField;
    Vide: TIB_Cursor;
    MemD_ArtCrit3: TStringField;
    MemD_ArtCrit4: TStringField;
    MemD_ArtCrit5: TStringField;
    IbQ_Magcte: TIB_Query;
    IbQ_Magfid: TIB_Query;
    IbQ_Locmag: TIB_Query;
    IbQ_Dossier: TIB_Query;

    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure Que_GTAfterPost(DataSet: TDataSet);
    procedure Que_GTBeforeDelete(DataSet: TDataSet);
    procedure Que_GTBeforeEdit(DataSet: TDataSet);
    procedure Que_GTNewRecord(DataSet: TDataSet);
    procedure Que_GTUpdateRecord(DataSet: TDataSet;
      UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
    procedure IbQ_TAILAfterPost(IB_Dataset: TIB_Dataset);
    procedure IbQ_TAILBeforeDelete(IB_Dataset: TIB_Dataset);
    procedure IbQ_TAILBeforeEdit(IB_Dataset: TIB_Dataset);
    procedure IbQ_TAILNewRecord(IB_Dataset: TIB_Dataset);
    procedure IbQ_TAILUpdateRecord(DataSet: TComponent;
      UpdateKind: TIB_UpdateKind; var UpdateAction: TIB_UpdateAction);
    procedure IbQ_FournAfterPost(IB_Dataset: TIB_Dataset);
    procedure IbQ_FournBeforeDelete(IB_Dataset: TIB_Dataset);
    procedure IbQ_FournBeforeEdit(IB_Dataset: TIB_Dataset);
    procedure IbQ_FournNewRecord(IB_Dataset: TIB_Dataset);
    procedure IbQ_FournUpdateRecord(DataSet: TComponent;
      UpdateKind: TIB_UpdateKind; var UpdateAction: TIB_UpdateAction);
    procedure Que_Class1AfterPost(DataSet: TDataSet);
    procedure Que_Class1BeforeDelete(DataSet: TDataSet);
    procedure Que_Class1BeforeEdit(DataSet: TDataSet);
    procedure Que_Class1NewRecord(DataSet: TDataSet);
    procedure Que_Class1UpdateRecord(DataSet: TDataSet;
      UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
    procedure IbQ_AdrAfterPost(IB_Dataset: TIB_Dataset);
    procedure IbQ_AdrBeforeDelete(IB_Dataset: TIB_Dataset);
    procedure IbQ_AdrBeforeEdit(IB_Dataset: TIB_Dataset);
    procedure IbQ_AdrNewRecord(IB_Dataset: TIB_Dataset);
    procedure IbQ_AdrUpdateRecord(DataSet: TComponent;
      UpdateKind: TIB_UpdateKind; var UpdateAction: TIB_UpdateAction);
    procedure IbQ_RayAfterPost(IB_Dataset: TIB_Dataset);
    procedure IbQ_RayBeforeDelete(IB_Dataset: TIB_Dataset);
    procedure IbQ_RayBeforeEdit(IB_Dataset: TIB_Dataset);
    procedure IbQ_RayNewRecord(IB_Dataset: TIB_Dataset);
    procedure IbQ_RayUpdateRecord(DataSet: TComponent;
      UpdateKind: TIB_UpdateKind; var UpdateAction: TIB_UpdateAction);
    procedure IbQ_FamAfterPost(IB_Dataset: TIB_Dataset);
    procedure IbQ_FamBeforeDelete(IB_Dataset: TIB_Dataset);
    procedure IbQ_FamBeforeEdit(IB_Dataset: TIB_Dataset);
    procedure IbQ_FamNewRecord(IB_Dataset: TIB_Dataset);
    procedure IbQ_FamUpdateRecord(DataSet: TComponent;
      UpdateKind: TIB_UpdateKind; var UpdateAction: TIB_UpdateAction);
    procedure IbQ_SFAfterPost(IB_Dataset: TIB_Dataset);
    procedure IbQ_SFBeforeDelete(IB_Dataset: TIB_Dataset);
    procedure IbQ_SFBeforeEdit(IB_Dataset: TIB_Dataset);
    procedure IbQ_SFNewRecord(IB_Dataset: TIB_Dataset);
    procedure IbQ_SFUpdateRecord(DataSet: TComponent;
      UpdateKind: TIB_UpdateKind; var UpdateAction: TIB_UpdateAction);
    procedure Que_Class2AfterPost(DataSet: TDataSet);
    procedure Que_Class2BeforeDelete(DataSet: TDataSet);
    procedure Que_Class2BeforeEdit(DataSet: TDataSet);
    procedure Que_Class2NewRecord(DataSet: TDataSet);
    procedure Que_Class2UpdateRecord(DataSet: TDataSet;
      UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
    procedure Que_BrlAfterPost(DataSet: TDataSet);
    procedure Que_BrlBeforeDelete(DataSet: TDataSet);
    procedure Que_BrlBeforeEdit(DataSet: TDataSet);
    procedure Que_BrlNewRecord(DataSet: TDataSet);
    procedure Que_BrlUpdateRecord(DataSet: TDataSet;
      UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
    procedure Que_GroupeCltAfterPost(DataSet: TDataSet);
    procedure Que_GroupeCltBeforeDelete(DataSet: TDataSet);
    procedure Que_GroupeCltBeforeEdit(DataSet: TDataSet);
    procedure Que_GroupeCltNewRecord(DataSet: TDataSet);
    procedure Que_GroupeCltUpdateRecord(DataSet: TDataSet;
      UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
    procedure IbQ_ConsoAfterPost(IB_Dataset: TIB_Dataset);
    procedure IbQ_ConsoBeforeDelete(IB_Dataset: TIB_Dataset);
    procedure IbQ_ConsoBeforeEdit(IB_Dataset: TIB_Dataset);
    procedure IbQ_ConsoNewRecord(IB_Dataset: TIB_Dataset);
    procedure IbQ_ConsoUpdateRecord(DataSet: TComponent;
      UpdateKind: TIB_UpdateKind; var UpdateAction: TIB_UpdateAction);
    procedure IbQ_TvaAfterPost(IB_Dataset: TIB_Dataset);
    procedure IbQ_TvaBeforeDelete(IB_Dataset: TIB_Dataset);
    procedure IbQ_TvaBeforeEdit(IB_Dataset: TIB_Dataset);
    procedure IbQ_TvaNewRecord(IB_Dataset: TIB_Dataset);
    procedure IbQ_TvaUpdateRecord(DataSet: TComponent;
      UpdateKind: TIB_UpdateKind; var UpdateAction: TIB_UpdateAction);
    procedure IbQ_ClassAfterPost(IB_Dataset: TIB_Dataset);
    procedure IbQ_ClassBeforeDelete(IB_Dataset: TIB_Dataset);
    procedure IbQ_ClassBeforeEdit(IB_Dataset: TIB_Dataset);
    procedure IbQ_ClassNewRecord(IB_Dataset: TIB_Dataset);
    procedure IbQ_ClassUpdateRecord(DataSet: TComponent;
      UpdateKind: TIB_UpdateKind; var UpdateAction: TIB_UpdateAction);
    procedure IbQ_MagBeforeDelete(IB_Dataset: TIB_Dataset);
    procedure IbQ_MagBeforeEdit(IB_Dataset: TIB_Dataset);
    procedure IbQ_MagNewRecord(IB_Dataset: TIB_Dataset);
    procedure IbQ_MagUpdateRecord(DataSet: TComponent;
      UpdateKind: TIB_UpdateKind; var UpdateAction: TIB_UpdateAction);
    procedure IbQ_CdeBeforeDelete(IB_Dataset: TIB_Dataset);
    procedure IbQ_CdeBeforeEdit(IB_Dataset: TIB_Dataset);
    procedure IbQ_CdeNewRecord(IB_Dataset: TIB_Dataset);
    procedure IbQ_CdeUpdateRecord(DataSet: TComponent;
      UpdateKind: TIB_UpdateKind; var UpdateAction: TIB_UpdateAction);
    procedure Que_CategAfterPost(DataSet: TDataSet);
    procedure Que_CategBeforeDelete(DataSet: TDataSet);
    procedure Que_CategBeforeEdit(DataSet: TDataSet);
    procedure Que_CategNewRecord(DataSet: TDataSet);
    procedure Que_CategUpdateRecord(DataSet: TDataSet;
      UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
    procedure IbQ_GrpCltAfterPost(IB_Dataset: TIB_Dataset);
    procedure IbQ_GrpCltBeforeDelete(IB_Dataset: TIB_Dataset);
    procedure IbQ_GrpCltBeforeEdit(IB_Dataset: TIB_Dataset);
    procedure IbQ_GrpCltNewRecord(IB_Dataset: TIB_Dataset);
    procedure IbQ_GrpCltUpdateRecord(DataSet: TComponent;
      UpdateKind: TIB_UpdateKind; var UpdateAction: TIB_UpdateAction);
    procedure IbQ_MagCltAfterPost(IB_Dataset: TIB_Dataset);
    procedure IbQ_MagCltBeforeDelete(IB_Dataset: TIB_Dataset);
    procedure IbQ_MagCltBeforeEdit(IB_Dataset: TIB_Dataset);
    procedure IbQ_MagCltNewRecord(IB_Dataset: TIB_Dataset);
    procedure IbQ_MagCltUpdateRecord(DataSet: TComponent;
      UpdateKind: TIB_UpdateKind; var UpdateAction: TIB_UpdateAction);
    procedure IbQ_CivAfterPost(IB_Dataset: TIB_Dataset);
    procedure IbQ_CivBeforeDelete(IB_Dataset: TIB_Dataset);
    procedure IbQ_CivBeforeEdit(IB_Dataset: TIB_Dataset);
    procedure IbQ_CivNewRecord(IB_Dataset: TIB_Dataset);
    procedure IbQ_CivUpdateRecord(DataSet: TComponent;
      UpdateKind: TIB_UpdateKind; var UpdateAction: TIB_UpdateAction);
    procedure Que_NkGtsAfterPost(DataSet: TDataSet);
    procedure Que_NkGtsBeforeDelete(DataSet: TDataSet);
    procedure Que_NkGtsBeforeEdit(DataSet: TDataSet);
    procedure Que_NkGtsNewRecord(DataSet: TDataSet);
    procedure Que_NkGtsUpdateRecord(DataSet: TDataSet;
      UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
    procedure IbQ_UniversAfterPost(IB_Dataset: TIB_Dataset);
    procedure IbQ_UniversBeforeDelete(IB_Dataset: TIB_Dataset);
    procedure IbQ_UniversBeforeEdit(IB_Dataset: TIB_Dataset);
    procedure IbQ_UniversNewRecord(IB_Dataset: TIB_Dataset);
    procedure IbQ_UniversUpdateRecord(DataSet: TComponent;
      UpdateKind: TIB_UpdateKind; var UpdateAction: TIB_UpdateAction);
    procedure Que_PosteAfterPost(DataSet: TDataSet);
    procedure Que_PosteBeforeDelete(DataSet: TDataSet);
    procedure Que_PosteBeforeEdit(DataSet: TDataSet);
    procedure Que_PosteNewRecord(DataSet: TDataSet);
    procedure Que_PosteUpdateRecord(DataSet: TDataSet;
      UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
    procedure IbQ_NkGtsAfterPost(IB_Dataset: TIB_Dataset);
    procedure IbQ_NkGtsBeforeDelete(IB_Dataset: TIB_Dataset);
    procedure IbQ_NkGtsBeforeEdit(IB_Dataset: TIB_Dataset);
    procedure IbQ_NkGtsNewRecord(IB_Dataset: TIB_Dataset);
    procedure IbQ_NkGtsUpdateRecord(DataSet: TComponent;
      UpdateKind: TIB_UpdateKind; var UpdateAction: TIB_UpdateAction);
    procedure Que_TarVenteAfterPost(DataSet: TDataSet);
    procedure Que_TarVenteBeforeDelete(DataSet: TDataSet);
    procedure Que_TarVenteBeforeEdit(DataSet: TDataSet);
    procedure Que_TarVenteNewRecord(DataSet: TDataSet);
    procedure Que_TarVenteUpdateRecord(DataSet: TDataSet;
      UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
    procedure IbQ_SessionAfterPost(IB_Dataset: TIB_Dataset);
    procedure IbQ_SessionBeforeDelete(IB_Dataset: TIB_Dataset);
    procedure IbQ_SessionBeforeEdit(IB_Dataset: TIB_Dataset);
    procedure IbQ_SessionNewRecord(IB_Dataset: TIB_Dataset);
    procedure IbQ_SessionUpdateRecord(DataSet: TComponent;
      UpdateKind: TIB_UpdateKind; var UpdateAction: TIB_UpdateAction);
    procedure Que_TarPrixAfterPost(DataSet: TDataSet);
    procedure Que_TarPrixBeforeDelete(DataSet: TDataSet);
    procedure Que_TarPrixBeforeEdit(DataSet: TDataSet);
    procedure Que_TarPrixNewRecord(DataSet: TDataSet);
    procedure Que_TarPrixUpdateRecord(DataSet: TDataSet;
      UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
    procedure Que_StatutBeforeDelete(DataSet: TDataSet);
    procedure Que_StatutBeforeEdit(DataSet: TDataSet);
    procedure Que_StatutNewRecord(DataSet: TDataSet);
    procedure Que_StatutUpdateRecord(DataSet: TDataSet;
      UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
    procedure Que_ResiBeforeDelete(DataSet: TDataSet);
    procedure Que_ResiBeforeEdit(DataSet: TDataSet);
    procedure Que_ResiNewRecord(DataSet: TDataSet);
    procedure Que_ResiUpdateRecord(DataSet: TDataSet;
      UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
    procedure Que_CategLocAfterPost(DataSet: TDataSet);
    procedure Que_CategLocBeforeDelete(DataSet: TDataSet);
    procedure Que_CategLocBeforeEdit(DataSet: TDataSet);
    procedure Que_CategLocNewRecord(DataSet: TDataSet);
    procedure Que_CategLocUpdateRecord(DataSet: TDataSet;
      UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
    procedure Que_ClassAfterPost(DataSet: TDataSet);
    procedure Que_ClassBeforeDelete(DataSet: TDataSet);
    procedure Que_ClassBeforeEdit(DataSet: TDataSet);
    procedure Que_ClassNewRecord(DataSet: TDataSet);
    procedure Que_ClassUpdateRecord(DataSet: TDataSet;
      UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
    procedure Que_TypcAfterPost(DataSet: TDataSet);
    procedure Que_TypcBeforeDelete(DataSet: TDataSet);
    procedure Que_TypcBeforeEdit(DataSet: TDataSet);
    procedure Que_TypcNewRecord(DataSet: TDataSet);
    procedure Que_TypcUpdateRecord(DataSet: TDataSet;
      UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
    procedure Que_RayAfterPost(DataSet: TDataSet);
    procedure Que_RayBeforeDelete(DataSet: TDataSet);
    procedure Que_RayBeforeEdit(DataSet: TDataSet);
    procedure Que_RayNewRecord(DataSet: TDataSet);
    procedure Que_RayUpdateRecord(DataSet: TDataSet;
      UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
    procedure Que_OrgaAfterPost(DataSet: TDataSet);
    procedure Que_OrgaBeforeDelete(DataSet: TDataSet);
    procedure Que_OrgaBeforeEdit(DataSet: TDataSet);
    procedure Que_OrgaNewRecord(DataSet: TDataSet);
    procedure Que_OrgaUpdateRecord(DataSet: TDataSet;
      UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
    procedure Que_FamAfterPost(DataSet: TDataSet);
    procedure Que_FamBeforeDelete(DataSet: TDataSet);
    procedure Que_FamBeforeEdit(DataSet: TDataSet);
    procedure Que_FamNewRecord(DataSet: TDataSet);
    procedure Que_FamUpdateRecord(DataSet: TDataSet;
      UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
    procedure Que_CompoAfterPost(DataSet: TDataSet);
    procedure Que_CompoBeforeDelete(DataSet: TDataSet);
    procedure Que_CompoBeforeEdit(DataSet: TDataSet);
    procedure Que_CompoNewRecord(DataSet: TDataSet);
    procedure Que_CompoUpdateRecord(DataSet: TDataSet;
      UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
    procedure Que_ClientAfterPost(DataSet: TDataSet);
    procedure Que_ClientBeforeDelete(DataSet: TDataSet);
    procedure Que_ClientBeforeEdit(DataSet: TDataSet);
    procedure Que_ClientNewRecord(DataSet: TDataSet);
    procedure Que_ClientUpdateRecord(DataSet: TDataSet;
      UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
    procedure IBOQryCuAfterPost(DataSet: TDataSet);
    procedure IBOQryCuBeforeDelete(DataSet: TDataSet);
    procedure IBOQryCuBeforeEdit(DataSet: TDataSet);
    procedure IBOQryCuNewRecord(DataSet: TDataSet);
    procedure IBOQryCuUpdateRecord(DataSet: TDataSet;
      UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
    procedure GenerikAfterPost(DataSet: TDataSet);
    procedure GenerikNewRecord(DataSet: TDataSet);
    procedure GenerikUpdateRecord(DataSet: TDataSet;
      UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
    procedure GenerikAfterCancel(DataSet: TDataSet);
    procedure GenerikBeforeDelete(DataSet: TDataSet);
    procedure IbQ_DossierAfterPost(IB_Dataset: TIB_Dataset);
  private
    { Déclarations privées }
    Init_Mag, Init_poste: boolean;
    Compteur: integer;


    Maga, poste: array[1..20] of integer;
    function Magas(MagHusky: integer): integer;
    function Postes(MagHusky: integer): integer;
    procedure Refresh_form;
    function IncMois(const Date: TDateTime; NumberOfMonths: Integer): TDateTime;

  public
    { Déclarations publiques }
    Euro: double;
    pathIp: string;
    procedure memoduree(duree: ttime);
    function TESTINITIAL: boolean;
    function ImportVide: boolean;
    procedure Refresh;
    procedure MAGASIN;
    procedure GT;
    procedure Fourn;
    procedure NK(Nkoption: integer);
    procedure Article;
    procedure Tarifs;
    procedure STOCKMVT;
    procedure CB;
    procedure COMMANDES;
    procedure CLIENTS(fid: integer);
    procedure CPTCLI;
    procedure FIDELITE;
    procedure TARIF23;
    function ReplaceStr(Chaine, Ex, Nlle: string; CaseSensitive: boolean): string;
    procedure Conso;

        //Location
    function STATUT: boolean;
    procedure RESIDENCE;
    procedure CATEGORIE;
    procedure ARTICLELOC;
    procedure Organisme;
    procedure INFOLOC;

    procedure classLoc;
    procedure TypeCateg;
    procedure NK_Theo;
    procedure CodePostaux(pays: integer);
    procedure HistoLoc;
    procedure genparam;
    function CD_EAN(Cb: string; var CbCd: string): boolean;


  end;

var
  dm_import: Tdm_import;

//------------------------------------------------------------------------------
// Ressources strings
//------------------------------------------------------------------------------
//ResourceString

implementation

uses Main_Dm,
  stdutils, GinKoiaStd;

{$R *.DFM}

//------------------------------------------------------------------------------
// Procédures et fonctions internes
//------------------------------------------------------------------------------

procedure Tdm_import.Refresh;
begin
  Grd_Que.Refresh;
end;

procedure Tdm_import.Refresh_form;
begin
   //---Utile pour ne pas perdre de vue la form après l'avoir reduite
   //   Tout les 20 passages dans une boucle je reactive le bazar...
  if compteur > 20 then
  begin
    Application.ProcessMessages;
    compteur := 0;
  end
  else
    inc(compteur);
end;

function Tdm_import.Magas(MagHusky: integer): integer;
begin
  if not frm_main.Chk_IC.checked then
  begin
    if not Init_Mag then
    begin
      ibq_mag.open;
      while not ibq_mag.eof do
      begin
        if (ibq_mag.fieldbyname('MAG_husky').asinteger > 0) and (ibq_mag.fieldbyname('MAG_husky'
          ).asinteger < 21) then
          Maga[ibq_mag.fieldbyname('MAG_husky').asinteger] := ibq_mag.fieldbyname('MAG_id'
            ).asinteger;

        ibq_mag.next;
      end;
    end;
    ibq_mag.close;
    Init_mag := true;
    result := maga[MagHusky];
  end
  else
  begin
    ibq_mag.open;
    result := ibq_mag.fieldbyname('MAG_id').asinteger;
  end;

end;

function Tdm_import.Postes(MagHusky: integer): integer;
begin

  if not Init_poste then
  begin
    ibq_mag.open;
    while not ibq_mag.eof do
    begin
      if (ibq_mag.fieldbyname('MAG_husky').asinteger > 0) and (ibq_mag.fieldbyname('MAG_husky'
        ).asinteger < 21) then
        Poste[ibq_mag.fieldbyname('MAG_husky').asinteger] := ibq_mag.fieldbyname('POS_id'
          ).asinteger;

      ibq_mag.next;
    end;
    ibq_mag.close;
    Init_poste := true;
  end;

  result := poste[MagHusky];
end;

procedure Tdm_import.MAGASIN;
var
  id_vil: string;
  id_Soc: string;
  PayID: string;
  societe: boolean;
  GroupeClient, GroupeCompte, GroupeFidelite: integer;

begin

  screen.Cursor := crSQLWait;
  que_param.open;

    //Recherche des groupes dans la base vide
  ibq_grpclt.sql.text := 'SELECT GCL_ID FROM GENGESTIONCLT where gcl_id<>0';
  ibq_grpclt.keylinks.text := 'GCL_ID';
  ibq_grpclt.open;
  groupeclient := ibq_grpclt.fieldbyname('GCL_id').asinteger;
  ibq_grpclt.close;

  ibq_grpclt.sql.text := 'SELECT GCF_ID FROM GENGESTIONCARTEFID where gcf_id<>0';
  ibq_grpclt.keylinks.text := 'GCF_ID';
  ibq_grpclt.open;
  groupeFidelite := ibq_grpclt.fieldbyname('GCf_id').asinteger;
  ibq_grpclt.close;

  ibq_grpclt.sql.text := 'SELECT GCC_ID FROM GENGESTIONCLTCPT where gcc_id<>0';
  ibq_grpclt.keylinks.text := 'GCC_ID';
  ibq_grpclt.open;
  groupecompte := ibq_grpclt.fieldbyname('GCC_id').asinteger;
  ibq_grpclt.close;

    //Recherche du PayID
  ibq_grpclt.sql.text := 'SELECT pay_id FROM GENPAYS where PAY_NOM=' + #39 + 'FRANCE' + #39;
  ibq_grpclt.keylinks.text := 'PAY_ID';
  ibq_grpclt.open;
  PayID := ibq_grpclt.fieldbyname('PAY_ID').asstring;
  ibq_grpclt.close;

  ibq_MagClt.open;
  ibq_MagCTE.open;
  ibq_MagFid.open;
  ibq_locmag.open;
  ibq_mag.open;
  que_poste.open;

  MemD_Mag.DelimiterChar := ';';
  MemD_Mag.LoadFromTextFile(pathIp + 'MAGASIN.TXT');
  societe := false;

  try
    dm_main.starttransaction;

    memd_mag.first;
    while not memd_mag.eof do
    begin
      if memd_mag.fieldbyname('LibLong').asstring = '%FINI%' then break;

      if not Societe then
      begin
             // ---Création de la societe---
        dm_main.PrepareScript(
          'INSERT into Gensociete(soc_id,soc_nom,soc_ssid) values (:soc_id,:soc_nom,0)');
        id_soc := dm_main.GenId;
        dm_main.SetScriptParameterValue('soc_id', id_soc);
        dm_main.SetScriptParameterValue('soc_nom', memd_mag.fieldbyname('RS').asstring);
        dm_main.ExecuteInsertK('GENSOCIETE', id_soc);
        societe := true;
      end;

      ibq_mag.insert;

      ibq_mag.fieldbyname('mag_ident').asstring := memd_mag.fieldbyname('Liblong').asstring;
      ibq_mag.fieldbyname('mag_nom').asstring := memd_mag.fieldbyname('RS').asstring;
      ibq_mag.fieldbyname('mag_socid').asstring := id_soc;
      ibq_mag.fieldbyname('mag_tvtid').asinteger := 0;
      ibq_mag.fieldbyname('mag_tel').asstring := memd_mag.fieldbyname('tel').asstring;
      ibq_mag.fieldbyname('mag_fax').asstring := memd_mag.fieldbyname('fax').asstring;
      ibq_mag.fieldbyname('mag_siret').asstring := memd_mag.fieldbyname('RC').asstring;
      ibq_mag.fieldbyname('mag_codeadh').asstring := memd_mag.fieldbyname('cdadh').asstring;
      ibq_mag.fieldbyname('mag_husky').asstring := memd_mag.fieldbyname('num').asstring;
      ibq_mag.fieldbyname('mag_identcourt').asstring := memd_mag.fieldbyname('Libcourt').asstring;
      ibq_mag.fieldbyname('mag_coment').asstring := ReplaceStr(memd_mag.fieldbyname('coment'
        ).asstring, '%', #10, false);
      ibq_mag.fieldbyname('mag_nature').asinteger := 0;
      ibq_mag.fieldbyname('mag_transfert').asinteger := 0;
      ibq_mag.fieldbyname('mag_ss').asinteger := 0;
      ibq_mag.fieldbyname('mag_gclid').asinteger := 0;
      ibq_mag.fieldbyname('mag_adrid').asinteger := ibq_mag.fieldbyname('adr_id').asinteger;
      ibq_mag.fieldbyname('mag_enseigne').asstring := memd_mag.fieldbyname('RS').asstring;
      ibq_mag.fieldbyname('mag_facid').asinteger := 0;
      ibq_mag.fieldbyname('mag_livid').asinteger := 0;

       //--------Ville
      ibc_cp.close;
      ibc_cp.parambyname('CP').asstring := memd_mag.fieldbyname('cp').asstring;
      ibc_cp.open;

      ibc_cp.first;
      while not ibc_cp.eof do
      begin
        if (memd_mag.fieldbyname('Ville').asstring = ibc_cp.fieldbyname('Vil_nom').asstring)
          then
                //Il existe une commune  qui correspond
          break
        else
          ibc_cp.next;
      end;

      if ibc_cp.eof then
      begin
           //Aucune commune ne correspond, il faut créer cette ville dans GenVille
        id_vil := dm_main.GenId;
        dm_main.preparescript('INSERT into GENVILLE (vil_id,vil_nom,vil_cp,vil_payid)' +
          ' values (:vil_id,:vil_nom,:vil_cp,:vil_payid)');
        dm_main.SetScriptParameterValue('vil_id', id_vil);
        dm_main.SetScriptParameterValue('vil_nom', memd_mag.fieldbyname('Ville').asstring);
        dm_main.SetScriptParameterValue('vil_cp', memd_mag.fieldbyname('CP').asstring);
        dm_main.SetScriptParameterValue('vil_payid', payID);
        dm_main.ExecuteInsertK('GENVILLE', id_vil);
      end
      else
        id_vil := ibc_cp.fieldbyname('Vil_id').asstring;

       //--------Adresse
      ibq_mag.fieldbyname('adr_ligne').asstring := ReplaceStr(memd_mag.fieldbyname('ADR'
        ).asstring, '%', #10, false);
      ibq_mag.fieldbyname('adr_vilid').asstring := id_vil;

       //--------C'est fini...
      ibq_mag.post;

            //Table de relation entre le magasin et les groupes
      ibq_Magclt.insert;
      ibq_Magclt.fieldbyname('mgc_magid').asinteger := ibq_mag.fieldbyname('mag_id').asinteger;
      ibq_Magclt.fieldbyname('mgc_gclid').asinteger := groupeclient;
      ibq_Magclt.post;

      ibq_Magfid.insert;
      ibq_Magfid.fieldbyname('mcf_magid').asinteger := ibq_mag.fieldbyname('mag_id').asinteger;
      ibq_Magfid.fieldbyname('mcf_gcfid').asinteger := groupeFidelite;
      ibq_Magfid.post;

      ibq_Magcte.insert;
      ibq_Magcte.fieldbyname('mcc_magid').asinteger := ibq_mag.fieldbyname('mag_id').asinteger;
      ibq_Magcte.fieldbyname('mcc_gccid').asinteger := groupecompte;
      ibq_Magcte.post;
            //------------------------------------------------

            //Création du poste caisse associé au magasin
      que_poste.insert;
      que_poste.fieldbyname('pos_nom').asstring := 'SERVEUR';
      que_poste.fieldbyname('pos_info').asstring := '';
      que_poste.fieldbyname('pos_magid').asinteger := ibq_mag.fieldbyname('mag_id').asinteger;
      que_poste.fieldbyname('pos_compta').asstring := '';
      que_poste.post;

            //Creation des infos dans genparam
      que_param.insert;
      Que_ParamPRM_CODE.asinteger := 90;
      Que_ParamPRM_INTEGER.asinteger := 0;
      Que_ParamPRM_FLOAT.asfloat := 0;
      Que_ParamPRM_STRING.asstring := 'LOCATION';
      Que_ParamPRM_TYPE.asinteger := 9;
      Que_ParamPRM_MAGID.asinteger := ibq_mag.fieldbyname('mag_id').asinteger;
      Que_ParamPRM_INFO.asstring := 'LOCATION';
      Que_ParamPRM_POS.asinteger := 0;
      que_param.post;

      que_param.insert;
      Que_ParamPRM_CODE.asinteger := 31;
      Que_ParamPRM_INTEGER.asinteger := 3;
      Que_ParamPRM_FLOAT.asfloat := 0;
      Que_ParamPRM_STRING.asstring := '';
      Que_ParamPRM_TYPE.asinteger := 3;
      Que_ParamPRM_MAGID.asinteger := ibq_mag.fieldbyname('mag_id').asinteger;
      Que_ParamPRM_INFO.asstring := 'NIVEAU VERSION UTILISATEUR';
      Que_ParamPRM_POS.asinteger := 0;
      que_param.post;

            //Param loc à creer vide
      ibq_locmag.insert;
      ibq_locmag.fieldbyname('lmp_magid').asinteger := ibq_mag.fieldbyname('mag_id').asinteger;
      ibq_locmag.fieldbyname('lmp_djsup').asinteger := 0;
      ibq_locmag.fieldbyname('lmp_djsuppc').asfloat := 0;
      ibq_locmag.fieldbyname('lmp_saison').asinteger := 0;
      ibq_locmag.fieldbyname('lmp_etqcli').asinteger := 0;
      ibq_locmag.fieldbyname('lmp_etqoc').asinteger := 0;
      ibq_locmag.fieldbyname('lmp_piccoech').asinteger := 0;
      ibq_locmag.fieldbyname('lmp_piccoret').asinteger := 0;
      ibq_locmag.fieldbyname('lmp_etqvo').asinteger := 0;
      ibq_locmag.fieldbyname('lmp_menid').asinteger := 0;
      ibq_locmag.post;

      memd_mag.next;
    end;

    Dm_Main.IB_UpDateCache(ibq_mag);
    Dm_Main.IB_UpDateCache(ibq_Magclt);
    Dm_Main.IB_UpDateCache(ibq_Magfid);
    Dm_Main.IB_UpDateCache(ibq_Magcte);
    Dm_Main.IB_UpDateCache(ibq_locmag);
    Dm_Main.IBOUpDateCache(que_poste);
    Dm_Main.IBOUpDateCache(que_param);

    dm_main.commit;

  except
    raise;
    dm_main.rollback;

  end;

  ibq_mag.close;
  ibq_Magclt.close;
  ibq_Magfid.close;
  ibq_Magcte.close;
  ibq_locmag.close;
  que_param.close;
  screen.Cursor := crdefault;
  Application.ProcessMessages;
end;

procedure Tdm_import.GT;
var
  NumHusky: string;
  aff: double;

  nbart, Un_pc: integer;
  vario: variant;

begin

  screen.Cursor := crSQLWait;

  MemD_GT.DelimiterChar := ';';
  MemD_GT.LoadFromTextFile(pathIp + 'GT.TXT');

  Import.open;

  Corres_gt.open;
  Ibq_Tail.open;
  que_gt.open;
  numHusky := '';

    //Recherche de la categorie
  que_categ.open;
  if que_categ.eof then
  begin
    que_categ.insert;
    que_categ.fieldbyname('tgt_nom').asstring := 'TRANSFERT HUSHY';
    que_categ.fieldbyname('tgt_ordreaff').asfloat := 1000;
    que_categ.post;
  end;

    //Recherche de l'odre d'aff le plus elevé
  aff := 0;
  que_gt.first;
  while not que_gt.eof do
  begin
    if que_gt.fieldbyname('gtf_ordreaff').asfloat > Aff then
      aff := que_gt.fieldbyname('gtf_ordreaff').asfloat;
    que_gt.next;
  end;

    //---C'est parti mon quiqui...
  Nbart := 0;
  Memd_gt.first;
  while not memd_gt.eof do
  begin
    if memd_gt.fieldbyname('LibGt').asstring = '%FINI%' then break;
    Inc(Nbart);
    memd_gt.next;
  end;
  Vario := int(NbArt / 100);
  Un_Pc := Vario;
  nbart := 0;

  memd_gt.first;
  while not memd_gt.eof do
  begin
    if memd_gt.fieldbyname('LibGt').asstring = '%FINI%' then break;

        //Progress Bar
    inc(NbArt);
    if NbArt = Un_Pc then
    begin
      frm_main.PGB_IEC;
      NbArt := 0;
    end;
    Refresh_form;

    if trim(memd_gt.fieldbyname('num').asstring) <> '' then
    begin

      if numHusky <> memd_gt.fieldbyname('num').asstring then
      begin
        numHusky := memd_gt.fieldbyname('num').asstring;
                //Création de l'entete GT
        que_gt.insert;
        que_gt.fieldbyname('gtf_Import').asinteger := 1;
        que_gt.fieldbyname('gtf_idref').asinteger := 0;
        que_gt.fieldbyname('gtf_nom').asstring := '[H] ' + memd_gt.fieldbyname('LibGt').asstring;
        Aff := Aff + 1000;
        que_gt.fieldbyname('gtf_ordreaff').asfloat := Aff;
        que_gt.fieldbyname('gtf_tgtid').asinteger := que_categ.fieldbyname('tgt_id').asinteger;
        que_gt.post;

                //----Mémo de la realtion Num Husky/Num Ginkoia----
        corres_gt.insert;
        corres_gt.fieldbyname('Gt_Husky').asinteger := memd_gt.fieldbyname('num').asinteger;
        corres_gt.fieldbyname('Gt_Ginkoia').asinteger := que_gt.fieldbyname('gtf_id').asinteger;
        corres_gt.post;

      end;

           //----Import des lignes de grilles des tailles----
      Ibq_tail.insert;
      Ibq_tail.fieldbyname('tgf_gtfid').asinteger := que_gt.fieldbyname('gtf_id').asinteger;
      Ibq_tail.fieldbyname('tgf_idref').asinteger := memd_gt.fieldbyname('tail').asinteger;
      Ibq_tail.fieldbyname('tgf_tgfid').asinteger := Ibq_tail.fieldbyname('tgf_id').asinteger;
      Ibq_tail.fieldbyname('tgf_nom').asstring := memd_gt.fieldbyname('Libcourt').asstring;
      Ibq_tail.fieldbyname('tgf_corres').asstring := memd_gt.fieldbyname('Liblong').asstring;
      Ibq_tail.fieldbyname('tgf_ordreaff').asfloat := strtofloat(memd_gt.fieldbyname('tail'
        ).asstring) * 1000;
      Ibq_tail.fieldbyname('tgf_stat').asinteger := memd_gt.fieldbyname('tail').asinteger;
      Ibq_tail.post;
           //----
    end;

    MemD_Gt.next;
  end;

  MemD_GT.close;
  Import.close;

  Corres_gt.close;
  Ibq_Tail.close;
  que_gt.close;
  screen.Cursor := crdefault;
  que_categ.close;
end;

procedure Tdm_import.Fourn;
var
  id_vil: string;
  nbart, Un_pc: integer;
  vario: variant;
begin

  screen.Cursor := crSQLWait;

  ibq_fourn.open;
  Import.open;
  Corres_four.open;

  MemD_fourn.DelimiterChar := ';';
  MemD_fourn.LoadFromTextFile(pathIp + 'Fourn.TXT');

  try
    dm_main.starttransaction;

    //---C'est parti mon quiqui...
    Nbart := 0;
    Memd_fourn.first;
    while not memd_fourn.eof do
    begin
      if memd_fourn.fieldbyname('num').asstring = '%FINI%' then break;
      Inc(Nbart);
      memd_fourn.next;
    end;
    Vario := int(NbArt / 100);
    Un_Pc := Vario;
    Nbart := 0;

    memd_fourn.first;
    while not memd_fourn.eof do
    begin
      if memd_fourn.fieldbyname('num').asstring = '%FINI%' then break;

            //Progress Bar
      inc(NbArt);
      if NbArt = Un_Pc then
      begin
        frm_main.PGB_IEC;
        NbArt := 0;
      end;
      Refresh_form;

      ibq_fourn.insert;

       //--------Donnée du fournisseur
      ibq_fourn.fieldbyname('fou_idref').asinteger := 0;
      ibq_fourn.fieldbyname('fou_nom').asstring := memd_fourn.fieldbyname('RS').asstring;
      ibq_fourn.fieldbyname('fou_nom').asstring := uppercase(ibq_fourn.fieldbyname('fou_nom').asstring);
      ibq_fourn.fieldbyname('fou_tel').asstring := memd_fourn.fieldbyname('tel').asstring;
      ibq_fourn.fieldbyname('fou_fax').asstring := memd_fourn.fieldbyname('fax').asstring;
            //ibq_fourn.fieldbyname( 'fou_comentcom' ).asstring := memd_fourn.fieldbyname( 'corres' ).asstring;
      ibq_fourn.fieldbyname('fou_remise').asstring := memd_fourn.fieldbyname('Remise').asstring;
      ibq_fourn.fieldbyname('fou_adrid').asinteger := ibq_fourn.fieldbyname('adr_id').asinteger;
      ibq_fourn.fieldbyname('fou_email').asstring := '';
            //ibq_fourn.fieldbyname( 'fou_comentcom' ).asstring := '';
            //ibq_fourn.fieldbyname( 'fou_minicde' ).asfloat := 0;
            //ibq_fourn.fieldbyname( 'fou_franco' ).asinteger := 0;
            //ibq_fourn.fieldbyname( 'fou_mtfranco' ).asfloat := 0;
      ibq_fourn.fieldbyname('fou_remise').asfloat := 0;
      ibq_fourn.fieldbyname('fou_gros').asinteger := 0;
      ibq_fourn.fieldbyname('fou_cdtcde').asstring := '';

      ibq_fourn.fieldbyname('fou_code').asstring := '';
      ibq_fourn.fieldbyname('fou_textcde').asstring := '';

       //--------Ville
      ibc_cp.close;
      ibc_cp.parambyname('CP').asstring := memd_fourn.fieldbyname('cp').asstring;
      ibc_cp.open;

      ibc_cp.first;
      while not ibc_cp.eof do
      begin
        if (memd_fourn.fieldbyname('Ville').asstring = ibc_cp.fieldbyname('Vil_nom').asstring)
          then
                //Il existe une commune  qui correspond
          break
        else
          ibc_cp.next;
      end;

      if ibc_cp.eof then
      begin
           //Aucune commune ne correspond, il faut créer cette ville dans GenVille
        id_vil := dm_main.GenId;
        dm_main.preparescript('INSERT into GENVILLE (vil_id,vil_nom,vil_cp,vil_payid)' +
          ' values (:vil_id,:vil_nom,:vil_cp,:vil_payid)');
        dm_main.SetScriptParameterValue('vil_id', id_vil);
        dm_main.SetScriptParameterValue('vil_nom', memd_fourn.fieldbyname('Ville').asstring);
        dm_main.SetScriptParameterValue('vil_cp', memd_fourn.fieldbyname('CP').asstring);
        dm_main.SetScriptParameterValue('vil_payid', '0');
        dm_main.ExecuteInsertK('GENVILLE', id_vil);
      end
      else
        id_vil := ibc_cp.fieldbyname('Vil_id').asstring;

       //--------Adresse
      ibq_fourn.fieldbyname('adr_ligne').asstring := ReplaceStr(memd_fourn.fieldbyname('ADR'
        ).asstring, '%', #10, false);
      ibq_fourn.fieldbyname('adr_vilid').asstring := id_vil;

       //--------Fournisseur détail

      ibq_fourn.fieldbyname('fod_fouid').asinteger := ibq_fourn.fieldbyname('fou_id').asinteger;
      ibq_fourn.fieldbyname('fod_magid').asinteger := 0;
      ibq_fourn.fieldbyname('fod_numclient').asstring := memd_fourn.fieldbyname('nocli').asstring;
      ibq_fourn.fieldbyname('fod_ftoid').asinteger := 0;
      ibq_fourn.fieldbyname('fod_mrgid').asinteger := 0;
      ibq_fourn.fieldbyname('fod_cpaid').asinteger := 0;
      ibq_fourn.fieldbyname('fod_coment').asstring := 'Numéro HUSKY : ' + memd_fourn.fieldbyname(
        'num').asstring;
      ibq_fourn.fieldbyname('fod_encoursa').asfloat := 0;

       //--------Marque
      ibq_fourn.fieldbyname('mrk_idref').asinteger := 0;
      ibq_fourn.fieldbyname('mrk_nom').asstring := memd_fourn.fieldbyname('RS').asstring;
      ibq_fourn.fieldbyname('mrk_condition').asstring := '';

       //--------Relation marque fournisseur
      ibq_fourn.fieldbyname('fmk_fouid').asinteger := ibq_fourn.fieldbyname('fou_id').asinteger;
      ibq_fourn.fieldbyname('fmk_mrkid').asinteger := ibq_fourn.fieldbyname('mrk_id').asinteger;
      ibq_fourn.fieldbyname('fmk_prin').asinteger := 1;

       //--------C'est fini...
      ibq_fourn.post;

       //--------Memo de l'id Ginkoia dans le Memdataset
      memd_fourn.edit;
      memd_fourn.fieldbyname('IdGinkoia').asstring := ibq_fourn.fieldbyname('fou_id').asstring;
      memd_fourn.fieldbyname('MRKGinkoia').asstring := ibq_fourn.fieldbyname('mrk_id').asstring;
      memd_fourn.post;

      memd_fourn.next;
    end;

    Dm_Main.IB_UpDateCache(Ibq_fourn);
    dm_main.commit;

       //--A priori c'est tout bon je mets à jour la table de correspondance
    memd_fourn.first;
    while not memd_fourn.eof do
    begin
      if memd_fourn.fieldbyname('num').asstring = '%FINI%' then break;
      Corres_four.insert;
      Corres_four.fieldbyname('four_husky').asstring := memd_fourn.fieldbyname('num').asstring;
      Corres_four.fieldbyname('four_Ginkoia').asstring := memd_fourn.fieldbyname('IdGinkoia'
        ).asstring;
      Corres_four.fieldbyname('Mrk_Ginkoia').asstring := memd_fourn.fieldbyname('MrkGinkoia'
        ).asstring;
      Corres_four.post;
      Memd_fourn.next;
    end;

  except
    raise;
    dm_main.rollback;
  end;

  ibq_fourn.close;
  Corres_four.close;
  MemD_fourn.close;
  screen.Cursor := crdefault;
  Application.ProcessMessages;
end;

procedure Tdm_import.NK(Nkoption: integer);
var

  aff, aff_sf: double;
  univers: integer;

  Lib_ray, Lib_fam: string;

  nbart, Un_pc: integer;
  vario: variant;

  Rayon, famille: string;
  univ: string;

begin
    //Option 1 :Vérif de la nomenclature et création d' un rayon et famille 'Transfert husky'
    //          et des SF inexistantes.

    //Option 2 :Client Hors normes, la nomenclature Husky est recrée à l'identique.

     //---Recherche de l'ID PRODUIT dans la table ARTTYPECOMPTABLE
  Ibc_tct.open;
  ibc_tct.first;
  if ibc_tct.eof then
  begin
    MessageDlg('La ligne PRODUIT n' + #39 + 'existe pas dans la table ARTTYPECOMPTABLE', mtWarning, [],
      0);
    exit;
  end;

  ibc_tv.open;
  if ibc_tv.eof then
  begin

    MessageDlg('Le taux de TVA 19.6 n''existe pas...', mtWarning, [], 0);
    exit;
  end;

  screen.Cursor := crSQLWait;

  aff_sf := 0;

  MemD_Nom.DelimiterChar := ';';
  MemD_Nom.LoadFromTextFile(pathIp + 'NK.TXT');

  import.open;
  corres_nk.open;
  Ibq_sf.open;
  Ibq_ray.open;
  Ibq_Fam.open;
  ibq_nkgts.open;

  ibq_univers.open;
  if frm_main.chk_husky.Checked then
  begin //C'est un import Husky
    univ := 'TEXTILE';
    if not Ibq_Univers.locate('UNI_NOM', 'TEXTILE', [lopCaseInsensitive]) then
    begin
            //Création de l'univers' (C'est moi dieu le père...)
      ibq_univers.insert;
      ibq_univers.fieldbyname('UNI_IDREF').asinteger := 1;
      ibq_univers.fieldbyname('uni_nom').asstring := 'TEXTILE';
      ibq_univers.fieldbyname('uni_niveau').asinteger := 3;
      ibq_univers.fieldbyname('uni_origine').asinteger := 1;
      ibq_univers.post;
    end;
  end
  else
  begin //Import autre
    univ := 'UNIVERS';
    if ibq_univers.isempty then
    begin //Création d'un univers
      ibq_univers.insert;
      ibq_univers.fieldbyname('UNI_IDREF').asinteger := 1;
      ibq_univers.fieldbyname('uni_nom').asstring := 'UNIVERS';
      ibq_univers.fieldbyname('uni_niveau').asinteger := 3;
      ibq_univers.fieldbyname('uni_origine').asinteger := 1;
      ibq_univers.post;
    end;
  end;

    //Test si reference dans gendossier
  ibq_dossier.close;
  ibq_dossier.parambyname('univ').asstring := univ;
  ibq_dossier.open;
  if ibq_dossier.eof then
  begin
    ibq_dossier.insert;
    ibq_dossier.fieldbyname('dos_nom').asstring := 'UNIVERS_REF';
    ibq_dossier.fieldbyname('dos_string').asstring := univ;
    ibq_dossier.fieldbyname('dos_float').asfloat := 0;
    ibq_dossier.post;
  end;
  ibq_dossier.close;

    //---C'est parti mon quiqui...
  Nbart := 0;
  Memd_nom.first;
  while not memd_nom.eof do
  begin
    if memd_nom.fieldbyname('num').asstring = '%FINI%' then break;

    Inc(Nbart);
    memd_nom.next;
  end;
  Vario := int(NbArt / 100);
  Un_Pc := Vario;
  Nbart := 0;

  Rayon := '';
  Famille := '';

  memd_nom.first;
  while not memd_nom.eof do
  begin
    if memd_nom.fieldbyname('num').asstring = '%FINI%' then break;

         //Progress Bar
    inc(NbArt);
    if NbArt = Un_Pc then
    begin
      frm_main.PGB_IEC;
      NbArt := 0;
    end;
    Refresh_form;

    if rayon <> copy(memd_nom.fieldbyname('num').asstring, 1, 2) then
    begin
            //  - -LE RAYON N'EXISTE PAS---
            //--Recherche de l'ordre d'aff le plus élevé

      aff := 0;
      Ibq_ray.first;
      while not Ibq_ray.eof do
      begin
        if ibq_ray.fieldbyname('ray_ordreaff').asfloat > aff then
          aff := ibq_ray.fieldbyname('ray_ordreaff').asfloat;
        ibq_ray.next;
      end;

            //--Création du nouveau rayon
      ibq_ray.insert;
      ibq_ray.fieldbyname('ray_uniid').asinteger := Ibq_Univers.fieldbyname('UNI_ID').asinteger;
      ibq_ray.fieldbyname('ray_idref').asinteger := 0;
      ibq_ray.fieldbyname('ray_nom').asstring := memd_nom.fieldbyname('rayon').asstring;
      ibq_ray.fieldbyname('ray_ordreaff').asfloat := aff + 10;
      ibq_ray.fieldbyname('ray_visible').asinteger := memd_Nom.fieldbyname('RV').asinteger;
      ibq_ray.fieldbyname('ray_secid').asinteger := 0;
      ibq_ray.post;

      rayon := copy(memd_nom.fieldbyname('num').asstring, 1, 2);
    end;

    if famille <> copy(memd_nom.fieldbyname('num').asstring, 1, 4) then
    begin
               //--LA FAMILLE N'EXISTE PAS---
               //--FAMILLE : Recherche de l'ordre d'aff le plus élevé

      aff := 0;
      Ibq_fam.first;
      while not Ibq_fam.eof do
      begin
        if ibq_fam.fieldbyname('fam_ordreaff').asfloat > aff then
          aff := ibq_fam.fieldbyname('fam_ordreaff').asfloat;
        ibq_fam.next;
      end;

      Ibq_fam.insert;
      Ibq_fam.fieldbyname('fam_rayid').asinteger := ibq_ray.fieldbyname('ray_id').asinteger;
      Ibq_fam.fieldbyname('fam_idref').asinteger := 0;
      Ibq_fam.fieldbyname('fam_nom').asstring := memd_nom.fieldbyname('fam').asstring;
      Ibq_fam.fieldbyname('fam_ordreaff').asfloat := aff + 10;
      Ibq_fam.fieldbyname('fam_visible').asinteger := memd_Nom.fieldbyname('FV').asinteger;
      Ibq_fam.fieldbyname('fam_ctfid').asinteger := 0;
      Ibq_fam.post;

      famille := copy(memd_nom.fieldbyname('num').asstring, 1, 4);
    end;

            //---Création de la Sous Famille
    Aff_sf := Aff_sf + 10;
    ibq_sf.insert;
    Ibq_sf.fieldbyname('ssf_Famid').asinteger := Ibq_fam.fieldbyname('fam_id').asinteger;
    Ibq_sf.fieldbyname('ssf_idref').asinteger := 0;
    Ibq_sf.fieldbyname('ssf_Nom').asstring := memd_Nom.fieldbyname('SF').asstring;
    Ibq_sf.fieldbyname('ssf_Ordreaff').asfloat := Aff_sf;
    Ibq_sf.fieldbyname('ssf_visible').asinteger := memd_Nom.fieldbyname('SV').asinteger;
    Ibq_sf.fieldbyname('ssf_catid').asinteger := 0;
    Ibq_sf.fieldbyname('ssf_Tctid').asinteger := ibc_tct.fieldbyname('tct_id').asinteger;
    Ibq_sf.fieldbyname('ssf_TVAID').asinteger := ibc_tv.fieldbyname('tva_id').asinteger;
    Ibq_sf.post;

        //---Création de la table corres avec les GTS
    ibq_nkgts.insert;
    ibq_nkgts.fieldbyname('rel_ssfid').asinteger := Ibq_sf.fieldbyname('ssf_id').asinteger;

    ibq_nkgts.fieldbyname('rel_gtsid').asinteger := 0;
    ibq_nkgts.post;

           //---Insertion dans la table de correspondance
    corres_nk.insert;
    corres_nk.fieldbyname('Sf_husky').asstring := memd_nom.fieldbyname('num').asstring;
    corres_nk.fieldbyname('Sf_Ginkoia').asinteger := Ibq_sf.fieldbyname('ssf_id').asinteger;
    corres_nk.post;

    memd_nom.next;
  end;

// IF NOT ( corres_nk.Locate ( 'sf_husky', memd_nom.fieldbyname ( 'num' ) .asstring, [loCaseInsensitive] )
//            ) OR ( NkOption = 2 ) THEN
//        BEGIN
//           //---Cette SF n'existe pas dans OSKAR, il faut la créer
//           //   Ou c'est option 2 Hors normes
//           //   Il faut vérifier si le Rayon et la Famille cette SF exite
//
//            IF ( ( Nkoption = 1 ) AND ( copy ( memd_nom.fieldbyname ( 'num' ) .asstring, 1, 2 ) > '45' ) ) OR (
//                Nkoption = 2 ) THEN
//                Lib_ray := memd_nom.fieldbyname ( 'rayon' ) .asstring
//            ELSE
//                Lib_ray := 'TRANSFERT HUSKY';
//
//            IF NOT ibq_ray.Locate ( 'ray_nom', Lib_ray, [lopCaseInsensitive] ) THEN
//            BEGIN
//                //--LE RAYON N'EXISTE PAS---
//                //--Recherche de l'ordre d'aff le plus élevé
//
//                aff := 0;
//                Ibq_ray.first;
//                WHILE NOT Ibq_ray.eof DO
//                BEGIN
//                    IF ibq_ray.fieldbyname ( 'ray_ordreaff' ) .asfloat > aff THEN
//                        aff := ibq_ray.fieldbyname ( 'ray_ordreaff' ) .asfloat;
//                    ibq_ray.next;
//                END;
//
//
//
//               //--Création du nouveau rayon
//                ibq_ray.insert;
//                ibq_ray.fieldbyname ( 'ray_uniid' ) .asinteger := Ibq_Univers.fieldbyname ( 'UNI_ID' ) .asinteger;
//                ibq_ray.fieldbyname ( 'ray_idref' ) .asinteger := 0;
//                ibq_ray.fieldbyname ( 'ray_nom' ) .asstring := lib_ray;
//                ibq_ray.fieldbyname ( 'ray_ordreaff' ) .asfloat := aff + 10;
//                ibq_ray.fieldbyname ( 'ray_visible' ) .asinteger := 1;
//                ibq_ray.fieldbyname ( 'ray_secid' ) .asinteger := 0;
//                ibq_ray.post;
//            END;
//
//            IF ( ( Nkoption = 1 ) AND ( copy ( memd_nom.fieldbyname ( 'num' ) .asstring, 1, 2 ) > '45' ) ) OR (
//                Nkoption = 2 ) THEN
//                Lib_fam := memd_nom.fieldbyname ( 'fam' ) .asstring
//            ELSE
//                Lib_fam := 'TRANSFERT HUSKY';
//
//            IF NOT ibq_fam.Locate ( 'fam_nom', Lib_fam, [lopCaseInsensitive]
//                ) THEN
//            BEGIN
//               //--LA FAMILLE N'EXISTE PAS---
//               //--FAMILLE : Recherche de l'ordre d'aff le plus élevé
//
//                aff := 0;
//                Ibq_fam.first;
//                WHILE NOT Ibq_fam.eof DO
//                BEGIN
//                    IF ibq_fam.fieldbyname ( 'fam_ordreaff' ) .asfloat > aff THEN
//                        aff := ibq_fam.fieldbyname ( 'fam_ordreaff' ) .asfloat;
//                    ibq_fam.next;
//                END;
//
//                Ibq_fam.insert;
//                Ibq_fam.fieldbyname ( 'fam_rayid' ) .asinteger := ibq_ray.fieldbyname ( 'ray_id' ) .asinteger;
//                Ibq_fam.fieldbyname ( 'fam_idref' ) .asinteger := 0;
//                Ibq_fam.fieldbyname ( 'fam_nom' ) .asstring := Lib_fam;
//                Ibq_fam.fieldbyname ( 'fam_ordreaff' ) .asfloat := aff + 10;
//                Ibq_fam.fieldbyname ( 'fam_visible' ) .asinteger := 1;
//                Ibq_fam.fieldbyname ( 'fam_ctfid' ) .asinteger := 0;
//                Ibq_fam.post;
//            END;
//
//           //---Création de la Sous Famille
//            Aff_sf := Aff_sf + 10;
//            ibq_sf.insert;
//            Ibq_sf.fieldbyname ( 'ssf_Famid' ) .asinteger := Ibq_fam.fieldbyname ( 'fam_id' ) .asinteger;
//            Ibq_sf.fieldbyname ( 'ssf_idref' ) .asinteger := 0;
//
//            IF ( ( Nkoption = 1 ) AND ( copy ( memd_nom.fieldbyname ( 'num' ) .asstring, 1, 2 ) > '45' ) ) OR (
//                Nkoption = 2 ) THEN
//                Ibq_sf.fieldbyname ( 'ssf_Nom' ) .asstring := memd_Nom.fieldbyname ( 'SF' ) .asstring
//            ELSE
//                Ibq_sf.fieldbyname ( 'ssf_Nom' ) .asstring := memd_nom.fieldbyname ( 'Rayon' ) .asstring + '/' +
//                    memd_nom.fieldbyname ( 'Fam' ) .asstring + '/' + memd_nom.fieldbyname ( 'SF' ) .asstring;
//
//            Ibq_sf.fieldbyname ( 'ssf_Ordreaff' ) .asfloat := Aff_sf;
//            Ibq_sf.fieldbyname ( 'ssf_visible' ) .asinteger := 1;
//            Ibq_sf.fieldbyname ( 'ssf_catid' ) .asinteger := 0;
//            Ibq_sf.fieldbyname ( 'ssf_Tctid' ) .asinteger := 0;
//            Ibq_sf.fieldbyname ( 'ssf_TVAID' ) .asinteger := 0;
//            Ibq_sf.post;
//
//           //---Insertion dans la table de correspondance
//            corres_nk.insert;
//            corres_nk.fieldbyname ( 'Sf_husky' ) .asstring := memd_nom.fieldbyname ( 'num' ) .asstring;
//            corres_nk.fieldbyname ( 'Sf_Ginkoia' ) .asinteger := Ibq_sf.fieldbyname ( 'ssf_id' ) .asinteger;
//            corres_nk.post;
//        END;
//        memd_nom.next;
//
//    END;

  corres_nk.close;
  import.close;
  Ibq_sf.close;
  Ibq_ray.close;
  Ibq_Fam.close;

  ibc_tct.close;
  ibc_tv.close;
  ibq_nkgts.close;

  IbQ_univers.close;
  Memd_Nom.close;

  screen.Cursor := crDefault;

end;

procedure Tdm_import.Article;
var
  id_art, id_ref, Id_Coul, Id_TT: string;
  ktb_art, ktb_ref, ktb_coul, Ktb_TT: string;
  nbart, Un_pc: integer;
  vario: variant;
  TCoul: array[1..20] of string;
  i: integer;
  vid: string;
  id_secteur, id_critere, id_cla3, id_cla4, id_cla5: integer;
  id_tct: integer;
  pseudo: boolean;
  chro, cod: string;
begin

  vid := '';

   //-----Import des articles--------------------------
  screen.Cursor := crSQLWait;

  MemD_Art.DelimiterChar := ';';
  try
    MemD_Art.LoadFromTextFile(pathIp + 'ARTICLE.TXT');
  except
    MessageDlg(memd_art.fieldbyname('code').asstring, mtWarning, [], 0);
    Exit;
  end;

    //-----Recherche des ID des tables Article et Ref
  ibc_ktb.close;
  ibc_ktb.parambyname('ktb_name').asstring := 'ARTARTICLE';
  ibc_ktb.open;
  ktb_art := ibc_ktb.fieldbyname('ktb_id').asstring;

  ibc_ktb.close;
  ibc_ktb.prepare;
  ibc_ktb.parambyname('ktb_name').asstring := 'ARTREFERENCE';
  ibc_ktb.open;
  ktb_ref := ibc_ktb.fieldbyname('ktb_id').asstring;

  ibc_ktb.close;
  ibc_ktb.prepare;
  ibc_ktb.parambyname('ktb_name').asstring := 'PLXCOULEUR';
  ibc_ktb.open;
  ktb_coul := ibc_ktb.fieldbyname('ktb_id').asstring;

  ibc_ktb.close;
  ibc_ktb.prepare;
  ibc_ktb.parambyname('ktb_name').asstring := 'PLXTAILLESTRAV';
  ibc_ktb.open;
  ktb_tt := ibc_ktb.fieldbyname('ktb_id').asstring;

    //------Préparation des scripts--
  IbC_Art.Close;
  IbC_Art.SQL.Clear;
  IbC_Art.SQL.Add('INSERT into ARTARTICLE ( ART_ID,ART_IDREF,ART_NOM,ART_ORIGINE,' +
    'ART_DESCRIPTION,' +
    'ART_MRKID,ART_REFMRK,ART_SSFID,ART_PUB,ART_GTFID,ART_GREID,' +
    'ART_SUPPRIME,ART_REFREMPLACE,ART_GARID,ART_CODEGS,' +
    'ART_SESSION,ART_THEME,ART_GAMME,ART_CODECENTRALE,ART_TAILLES,ART_POS,' +
    'ART_GAMPF,ART_POINT,ART_GAMPRODUIT,ART_COMENT1,ART_COMENT2,ART_COMENT3,' +
    'ART_COMENT4,ART_COMENT5)' +
    'Values (:ART_ID,0,:ART_NOM,1,:ART_DESCRIPTION,' +
    ':ART_MRKID,:ART_REFMRK,:ART_SSFID,0,:ART_GTFID,' +
    ':ART_GREID,:ART_SUPPRIME,0,0,0,' +
    ':ART_SESSION,:ART_THEME,:ART_GAMME,:ART_CODECENTRALE,:ART_TAILLES,:ART_POS,' +
    ':ART_GAMPF,:ART_POINT,:ART_GAMPRODUIT,:ART_COMENT1,:ART_COMENT2,:ART_COMENT3,' +
    ':ART_COMENT4,:ART_COMENT5 )');

  IbC_Art.Prepare;

  IbC_ref.Close;
  IbC_ref.SQL.Clear;
  IbC_ref.SQL.Add(
    'INSERT into ARTREFERENCE (ARF_ID,ARF_ARTID,ARF_CATID,ARF_TVAID,ARF_TCTID,' +
    'ARF_ICLID1,ARF_ICLID2,ARF_ICLID3,ARF_ICLID4,ARF_ICLID5,' +
    'ARF_CREE,ARF_CHRONO,ARF_DIMENSION,ARF_DEPRECIATION,' +
    'ARF_STOCKI,ARF_VTFRAC,ARF_CDNMT,' +
    'ARF_CDNMTQTE,ARF_GUELT,ARF_CPFA,ARF_FIDELITE,' +
    'ARF_ARCHIVER,ARF_FIDPOINT,ARF_DEPTAUX,ARF_DEPDATE,ARF_DEPMOTIF,' +
    'ARF_CGTID,ARF_GLTMONTANT,ARF_GLTPXV,ARF_GLTMARGE,' +
    'ARF_VIRTUEL,ARF_SERVICE,ARF_COEFT,ARF_UNITE,ARF_MAGORG,ARF_CATALOG)' +

    'VALUES (:ARF_ID,:ARF_ARTID,0,:ARF_TVAID,:ARF_TCTID,:ARF_ICLID1,:ARF_ICLID2,:ARF_ICLID3,:ARF_ICLID4,:ARF_ICLID5,' +
    ':ARF_CREE,:ARF_CHRONO,:ARF_DIMENSION,:ARF_DEPRECIATION,' +
    '0,0,0,' +
    '0,0,1,:ARF_FIDELITE,' +
    ':ARF_ARCHIVER,0,:ARF_DEPTAUX,:ARF_DEPDATE,:ARF_DEPMOTIF,' +
    '0,0,0,0,:ARF_VIRTUEL,0,0,:ARF_UNITE,:ARF_MAGORG,0)');
  IbC_ref.Prepare;

  IbC_Coul.Close;
  IbC_Coul.SQL.Clear;
  IbC_Coul.SQL.Add('INSERT into plxcouleur (cou_id,cou_artid,cou_idref,cou_gcsid,cou_code,cou_nom) ' +
    'Values (:cou_id,:cou_artid,0,0,:cou_code,:cou_nom)');
  Ibc_coul.Prepare;

  IbC_tt.Close;
  IbC_tt.sqL.Clear;
  IbC_tt.sql.Add('INSERT into plxtaillestrav (ttv_id,ttv_artid,ttv_tgfid) ' +
    'Values (:ttv_id,:ttv_artid,:ttv_tgfid)');
  Ibc_tt.Prepare;

    //---Recherche et initialisation des champs de la table des classement
  ibq_class.close;
  ibq_class.parambyname('TYP').asstring := 'ART';
  ibq_class.open;

  while not ibq_class.eof do
  begin
    if ibq_class.fieldbyname('cla_num').asinteger = 1 then
    begin
      if frm_main.chk_husky.Checked then
      begin
        ibq_class.edit;
        ibq_class.fieldbyname('cla_nom').asstring := 'Critères Husky';
        ibq_class.post;
      end;
      id_critere := ibq_class.fieldbyname('cla_id').asinteger;
    end;

    if ibq_class.fieldbyname('cla_num').asinteger = 2 then
    begin
      if frm_main.chk_husky.Checked then
      begin
        ibq_class.edit;
        ibq_class.fieldbyname('cla_nom').asstring := 'Secteurs Husky';
        ibq_class.post;
      end;
      id_secteur := ibq_class.fieldbyname('cla_id').asinteger;
    end;

    if ibq_class.fieldbyname('cla_num').asinteger = 3 then
      id_cla3 := ibq_class.fieldbyname('cla_id').asinteger;

    if ibq_class.fieldbyname('cla_num').asinteger = 4 then
      id_cla4 := ibq_class.fieldbyname('cla_id').asinteger;

    if ibq_class.fieldbyname('cla_num').asinteger = 5 then
      id_cla5 := ibq_class.fieldbyname('cla_id').asinteger;

    ibq_class.next;
  end;

   //---Recherche de l'ID PRODUIT dans la table ARTTYPECOMPTABLE
  Ibc_tct.open;
  ibc_tct.first;
  if ibc_tct.eof then
  begin
    MessageDlg('La ligne PRODUIT n' + #39 + 'existe pas dans la table ARTTYPECOMPTABLE', mtWarning, [],
      0);
    exit;
  end;
  id_tct := ibc_tct.fieldbyname('tct_id').asinteger;

    //---Ouverture...
  import.open;
  tbl_art.open;
  Ibq_TVA.open;

    //---C'est parti mon quiqui...
  Nbart := 0;
  Memd_art.first;
  while not memd_art.eof do
  begin
    if memd_art.fieldbyname('CODE').asstring = '%FINI%' then break;
    Inc(Nbart);
    memd_art.next;
  end;
  Vario := int(NbArt / 100);
  Un_Pc := Vario;

  try
    dm_main.starttransaction;

    Nbart := 0;
    Memd_art.first;
    while not memd_art.eof do
    begin

      if memd_art.fieldbyname('CODE').asstring = '%FINI%' then break;

      chro := memd_art.fieldbyname('chrono').asstring;
      cod := memd_art.fieldbyname('code').asstring;

      for i := 1 to 20 do
        Tcoul[i] := '';

           //Progress Bar
      inc(NbArt);
      if NbArt = Un_Pc then
      begin
        frm_main.PGB_IEC;
        NbArt := 0;
        dm_main.commit;
        dm_main.starttransaction;
      end;
      Refresh_form;

      pseudo := false;
      if memd_art.fieldbyname('Peudo').asstring = 'P' then pseudo := true;

      id_art := dm_main.GenId;
      dm_main.InsertK(id_art, ktb_art, '-101', '-1', '-1');

      Ibc_art.parambyname('ART_ID').asstring := id_art;
      Ibc_art.parambyname('ART_NOM').asstring := memd_art.fieldbyname('Desi').asstring;
      Ibc_art.parambyname('ART_DESCRIPTION').asstring := memd_art.fieldbyname('Descript').asstring;

           //recherche de la marque et du fournisseur
      if pseudo = false then
      begin
        Ibc_fourn.close;
        Ibc_Fourn.parambyname('FOURN').asinteger := memd_art.fieldbyname('Fourn').asinteger;
        Ibc_Fourn.open;
        Ibc_art.parambyname('ART_MRKID').asinteger := Ibc_fourn.fieldbyname('mrk_GINKOIA').asinteger;
      end
      else
        Ibc_art.parambyname('ART_MRKID').asinteger := 0;

      Ibc_art.parambyname('ART_REFMRK').asstring := memd_art.fieldbyname('ReFourn').asstring;

           //recherche de la SF
      Ibc_Sf.close;
      Ibc_SF.parambyname('SF').asstring := copy(memd_art.fieldbyname('Code').asstring, 1, 6);
      Ibc_SF.open;
      Ibc_art.parambyname('ART_SSFID').asinteger := Ibc_SF.fieldbyname('SF_GINKOIA').asinteger;

           //recherche de la GT
      if pseudo = false then
      begin
        Ibc_gt.close;
        Ibc_gt.parambyname('gt').asinteger := memd_art.fieldbyname('GT').asinteger;
        Ibc_gt.open;
        Ibc_art.parambyname('ART_GTFID').asinteger := Ibc_gt.fieldbyname('GT_GINKOIA').asinteger;
      end
      else
        Ibc_art.parambyname('ART_GTFID').asinteger := 0;

           //Recherech du Genre
      if pseudo = false then
      begin
        Ibc_Genre.close;
        Ibc_Genre.parambyname('Sexe').asinteger := memd_art.fieldbyname('Genre').asinteger;
        Ibc_Genre.open;
        Ibc_art.parambyname('ART_GREID').asinteger := Ibc_Genre.fieldbyname('GRE_ID').asinteger;
      end
      else
        Ibc_art.parambyname('ART_GREID').asinteger := 0;

      Ibc_art.parambyname('ART_SUPPRIME').asinteger := memd_art.fieldbyname('archi').asinteger;

            //Tous les champs vides
      Ibc_art.parambyname('ART_SESSION').asstring := '';
      Ibc_art.parambyname('ART_THEME').asstring := '';
      Ibc_art.parambyname('ART_GAMME').asstring := '';
      Ibc_art.parambyname('ART_CODECENTRALE').asstring := '';
      Ibc_art.parambyname('ART_TAILLES').asstring := '';
      Ibc_art.parambyname('ART_POS').asstring := '';
      Ibc_art.parambyname('ART_GAMPF').asstring := '';
      Ibc_art.parambyname('ART_POINT').asstring := '';
      Ibc_art.parambyname('ART_GAMPRODUIT').asstring := '';
      Ibc_art.parambyname('ART_COMENT1').asstring := '';
      Ibc_art.parambyname('ART_COMENT2').asstring := '';
      Ibc_art.parambyname('ART_COMENT3').asstring := '';
      Ibc_art.parambyname('ART_COMENT4').asstring := '';
      Ibc_art.parambyname('ART_COMENT5').asstring := '';
      Ibc_art.parambyname('ART_SESSION').asstring := '';
      Ibc_art.parambyname('ART_SESSION').asstring := '';

      Ibc_art.Execute;

           //----La suite maintenant  ...

      id_ref := dm_main.GenId;
      dm_main.InsertK(id_ref, ktb_ref, '-101', '-1', '-1');

      Ibc_ref.parambyname('ARF_ID').asstring := id_ref;
      Ibc_ref.parambyname('ARF_artid').asstring := id_art;

      if pseudo then
      begin
        Ibc_ref.parambyname('ARF_VIRTUEL').asinteger := 1;
        Ibc_ref.parambyname('ARF_DIMENSION').asinteger := 0;
      end
      else
      begin
        Ibc_ref.parambyname('ARF_VIRTUEL').asinteger := 0;
        Ibc_ref.parambyname('ARF_DIMENSION').asinteger := 1;
      end;

           //Recherche de la TVA
      ibq_tva.first;
      while not Ibq_tva.eof do
      begin
        if Ibq_TVA.fieldbyname('TVA_taux').asfloat <> memd_art.fieldbyname('TVA').asfloat then
          ibq_tva.next
        else
          break;
      end;

      if ibq_tva.eof then
      begin
               //---Le Taux de tva n'existe pas...---
        ibq_tva.insert;
        ibq_tva.fieldbyname('tva_taux').asfloat := memd_art.fieldbyname('TVA').asfloat;
        ibq_tva.post;
      end;

      Ibc_ref.parambyname('ARF_TVAID').asinteger := Ibq_TVA.fieldbyname('TVA_ID').asinteger;
      Ibc_ref.parambyname('ARF_TCTID').asinteger := id_tct;

            //------Les Critères et les secteurs sont transférés dans les classement 1 & 2
      if trim(memd_art.fieldbyname('secteur').asstring) <> '' then
      begin
//                    ibq_class.first;
//                    WHILE NOT ibq_class.eof DO
//                    BEGIN
//                        IF ibq_class.fieldbyname('icl_nom').asstring <> memd_art.fieldbyname('secteur'
//                            ).asstring THEN
//                            ibq_class.next
//                        ELSE
//                            break;
//                    END;
//                    IF ibq_class.eof THEN

        if not ibq_class.locate('icl_nom;cla_num', VarArrayOf([trim(memd_art.fieldbyname('secteur').asstring), 2]), []) then
        begin // --Le Secteur n'existe pas
          ibq_class.insert;
          ibq_class.fieldbyname('icl_nom').asstring := trim(memd_art.fieldbyname('secteur').asstring);
          ibq_class.fieldbyname('cit_iclid').asinteger := ibq_class.fieldbyname('icl_id'
            ).asinteger;
          ibq_class.fieldbyname('cit_claid').asinteger := id_secteur;
          ibq_class.fieldbyname('cla_num').asinteger := 2;
          ibq_class.post;
        end;
        Ibc_ref.parambyname('ARF_ICLID2').asinteger := ibq_class.fieldbyname('icl_id').asinteger;
      end
      else
        Ibc_ref.parambyname('ARF_ICLID2').asinteger := 0;

            //------Critère-------
      if trim(memd_art.fieldbyname('critere').asstring) <> '' then
      begin
//                ibq_class.first;
//                WHILE NOT ibq_class.eof DO
//                BEGIN
//                    IF ibq_class.fieldbyname('icl_nom').asstring <> memd_art.fieldbyname('critere'
//                        ).asstring THEN
//                        ibq_class.next
//                    ELSE
//                        break;
//                END;
//
//                IF ibq_class.eof THEN

        if not ibq_class.locate('icl_nom;cla_num', VarArrayOf([trim(memd_art.fieldbyname('critere').asstring), 1]), []) then
        begin // --Le Critère n'existe pas
          ibq_class.insert;
          ibq_class.fieldbyname('icl_nom').asstring := trim(memd_art.fieldbyname('critere').asstring);
          ibq_class.fieldbyname('cit_iclid').asinteger := ibq_class.fieldbyname('icl_id'
            ).asinteger;
          ibq_class.fieldbyname('cit_claid').asinteger := id_critere;
          ibq_class.fieldbyname('cla_num').asinteger := 1;
          ibq_class.post;
        end;
        Ibc_ref.parambyname('ARF_ICLID1').asinteger := ibq_class.fieldbyname('icl_id').asinteger;
      end
      else
        Ibc_ref.parambyname('ARF_ICLID1').asinteger := 0;

            //---------Classement3----------------------
      if trim(memd_art.fieldbyname('crit3').asstring) <> '' then
      begin
//                ibq_class.first;
//                WHILE NOT ibq_class.eof DO
//                BEGIN
//                    IF ibq_class.fieldbyname('icl_nom').asstring <> memd_art.fieldbyname('crit3'
//                        ).asstring THEN
//                        ibq_class.next
//                    ELSE
//                        break;
//                END;
//
//                IF ibq_class.eof THEN
        if not ibq_class.locate('icl_nom;cla_num', VarArrayOf([trim(memd_art.fieldbyname('crit3').asstring), 3]), []) then
        begin // --Le Critère3
          ibq_class.insert;
          ibq_class.fieldbyname('icl_nom').asstring := trim(memd_art.fieldbyname('crit3').asstring);
          ibq_class.fieldbyname('cit_iclid').asinteger := ibq_class.fieldbyname('icl_id'
            ).asinteger;
          ibq_class.fieldbyname('cit_claid').asinteger := id_cla3;
          ibq_class.fieldbyname('cla_num').asinteger := 3;
          ibq_class.post;
        end;
        Ibc_ref.parambyname('ARF_ICLID3').asinteger := ibq_class.fieldbyname('icl_id').asinteger;
      end
      else
        Ibc_ref.parambyname('ARF_ICLID3').asinteger := 0;

            //---------Classement4----------------------
      if trim(memd_art.fieldbyname('crit4').asstring) <> '' then
      begin
//                ibq_class.first;
//                WHILE NOT ibq_class.eof DO
//                BEGIN
//                    IF ibq_class.fieldbyname('icl_nom').asstring <> memd_art.fieldbyname('crit4'
//                        ).asstring THEN
//                        ibq_class.next
//                    ELSE
//                        break;
//                END;
//
//                IF ibq_class.eof THEN
        if not ibq_class.locate('icl_nom;cla_num', VarArrayOf([trim(memd_art.fieldbyname('crit4').asstring), 4]), []) then
        begin // --Le Critère4
          ibq_class.insert;
          ibq_class.fieldbyname('icl_nom').asstring := trim(memd_art.fieldbyname('crit4').asstring);
          ibq_class.fieldbyname('cit_iclid').asinteger := ibq_class.fieldbyname('icl_id'
            ).asinteger;
          ibq_class.fieldbyname('cit_claid').asinteger := id_cla4;
          ibq_class.fieldbyname('cla_num').asinteger := 4;
          ibq_class.post;
        end;
        Ibc_ref.parambyname('ARF_ICLID4').asinteger := ibq_class.fieldbyname('icl_id').asinteger;
      end
      else
        Ibc_ref.parambyname('ARF_ICLID4').asinteger := 0;

            //---------Classement5----------------------
      if trim(memd_art.fieldbyname('crit5').asstring) <> '' then
      begin
//                ibq_class.first;
//                WHILE NOT ibq_class.eof DO
//                BEGIN
//                    IF ibq_class.fieldbyname('icl_nom').asstring <> memd_art.fieldbyname('crit5'
//                        ).asstring THEN
//                        ibq_class.next
//                    ELSE
//                        break;
//                END;
//
//                IF ibq_class.eof THEN
        if not ibq_class.locate('icl_nom;cla_num', VarArrayOf([trim(memd_art.fieldbyname('crit5').asstring), 5]), []) then
        begin // --Le Critère5
          ibq_class.insert;
          ibq_class.fieldbyname('icl_nom').asstring := trim(memd_art.fieldbyname('crit5').asstring);
          ibq_class.fieldbyname('cit_iclid').asinteger := ibq_class.fieldbyname('icl_id'
            ).asinteger;
          ibq_class.fieldbyname('cit_claid').asinteger := id_cla5;
          ibq_class.fieldbyname('cla_num').asinteger := 5;
          ibq_class.post;
        end;
        Ibc_ref.parambyname('ARF_ICLID5').asinteger := ibq_class.fieldbyname('icl_id').asinteger;
      end
      else
        Ibc_ref.parambyname('ARF_ICLID5').asinteger := 0;

      Ibc_ref.parambyname('ARF_CREE').asstring := memd_art.fieldbyname('DTCREA').asstring;
      Ibc_ref.parambyname('ARF_CHRONO').asstring := memd_art.fieldbyname('chrono').asstring;

      if memd_art.fieldbyname('txdep').asstring = '' then
        Ibc_ref.parambyname('ARF_DEPRECIATION').asinteger := 0
      else
        Ibc_ref.parambyname('ARF_DEPRECIATION').asinteger := 1;

      Ibc_ref.parambyname('ARF_FIDELITE').asinteger := memd_art.fieldbyname('Fidel').asinteger;
      Ibc_ref.parambyname('ARF_ARCHIVER').asinteger := memd_art.fieldbyname('Archi').asinteger;
      Ibc_ref.parambyname('ARF_DEPTAUX').asstring := memd_art.fieldbyname('TxDep').asstring;
      Ibc_ref.parambyname('ARF_DEPDATE').asstring := memd_art.fieldbyname('DtDep').asstring;
      Ibc_ref.parambyname('ARF_DEPMOTIF').asstring := memd_art.fieldbyname('LibDep').asstring;
      Ibc_ref.parambyname('ARF_UNITE').asstring := '';
      Ibc_ref.parambyname('ARF_MAGORG').asinteger := magas(1);
      Ibc_Ref.Execute;

            //-------Les couleurs maintenant------
      if trim(memd_art.fieldbyname('cc1').asstring) <> '' then
      begin
               //Il y a au moins une couleurs
        id_coul := dm_main.GenId;
        Ibc_coul.parambyname('cou_ID').asstring := id_coul;
        Ibc_coul.parambyname('cou_artid').asstring := id_art;
        Ibc_coul.parambyname('cou_code').asstring := memd_art.fieldbyname('cc1').asstring;
        Ibc_coul.parambyname('cou_nom').asstring := memd_art.fieldbyname('cl1').asstring;
        Ibc_coul.execute;
        dm_main.InsertK(id_coul, ktb_coul, '-101', '-1', '-1');
        Tcoul[1] := id_coul;

        if trim(memd_art.fieldbyname('cc2').asstring) <> '' then
        begin
          id_coul := dm_main.GenId;
          Ibc_coul.parambyname('cou_ID').asstring := id_coul;
          Ibc_coul.parambyname('cou_artid').asstring := id_art;
          Ibc_coul.parambyname('cou_code').asstring := memd_art.fieldbyname('cc2').asstring;
          Ibc_coul.parambyname('cou_nom').asstring := memd_art.fieldbyname('cl2').asstring;
          Ibc_coul.execute;
          dm_main.InsertK(id_coul, ktb_coul, '-101', '-1', '-1');
          Tcoul[2] := id_coul;
        end;

        if trim(memd_art.fieldbyname('cc3').asstring) <> '' then
        begin
          id_coul := dm_main.GenId;
          Ibc_coul.parambyname('cou_ID').asstring := id_coul;
          Ibc_coul.parambyname('cou_artid').asstring := id_art;
          Ibc_coul.parambyname('cou_code').asstring := memd_art.fieldbyname('cc3').asstring;
          Ibc_coul.parambyname('cou_nom').asstring := memd_art.fieldbyname('cl3').asstring;
          Ibc_coul.execute;
          dm_main.InsertK(id_coul, ktb_coul, '-101', '-1', '-1');
          Tcoul[3] := id_coul;
        end;

        if trim(memd_art.fieldbyname('cc4').asstring) <> '' then
        begin
          id_coul := dm_main.GenId;
          Ibc_coul.parambyname('cou_ID').asstring := id_coul;
          Ibc_coul.parambyname('cou_artid').asstring := id_art;
          Ibc_coul.parambyname('cou_code').asstring := memd_art.fieldbyname('cc4').asstring;
          Ibc_coul.parambyname('cou_nom').asstring := memd_art.fieldbyname('cl4').asstring;
          Ibc_coul.execute;
          dm_main.InsertK(id_coul, ktb_coul, '-101', '-1', '-1');
          Tcoul[4] := id_coul;
        end;

        if trim(memd_art.fieldbyname('cc5').asstring) <> '' then
        begin
          id_coul := dm_main.GenId;
          Ibc_coul.parambyname('cou_ID').asstring := id_coul;
          Ibc_coul.parambyname('cou_artid').asstring := id_art;
          Ibc_coul.parambyname('cou_code').asstring := memd_art.fieldbyname('cc5').asstring;
          Ibc_coul.parambyname('cou_nom').asstring := memd_art.fieldbyname('cl5').asstring;
          Ibc_coul.execute;
          dm_main.InsertK(id_coul, ktb_coul, '-101', '-1', '-1');
          Tcoul[5] := id_coul;
        end;

        if trim(memd_art.fieldbyname('cc6').asstring) <> '' then
        begin
          id_coul := dm_main.GenId;
          Ibc_coul.parambyname('cou_ID').asstring := id_coul;
          Ibc_coul.parambyname('cou_artid').asstring := id_art;
          Ibc_coul.parambyname('cou_code').asstring := memd_art.fieldbyname('cc6').asstring;
          Ibc_coul.parambyname('cou_nom').asstring := memd_art.fieldbyname('cl6').asstring;
          Ibc_coul.execute;
          dm_main.InsertK(id_coul, ktb_coul, '-101', '-1', '-1');
          Tcoul[6] := id_coul;
        end;

        if trim(memd_art.fieldbyname('cc7').asstring) <> '' then
        begin
          id_coul := dm_main.GenId;
          Ibc_coul.parambyname('cou_ID').asstring := id_coul;
          Ibc_coul.parambyname('cou_artid').asstring := id_art;
          Ibc_coul.parambyname('cou_code').asstring := memd_art.fieldbyname('cc7').asstring;
          Ibc_coul.parambyname('cou_nom').asstring := memd_art.fieldbyname('cl7').asstring;
          Ibc_coul.execute;
          dm_main.InsertK(id_coul, ktb_coul, '-101', '-1', '-1');
          Tcoul[7] := id_coul;
        end;

        if trim(memd_art.fieldbyname('cc8').asstring) <> '' then
        begin
          id_coul := dm_main.GenId;
          Ibc_coul.parambyname('cou_ID').asstring := id_coul;
          Ibc_coul.parambyname('cou_artid').asstring := id_art;
          Ibc_coul.parambyname('cou_code').asstring := memd_art.fieldbyname('cc8').asstring;
          Ibc_coul.parambyname('cou_nom').asstring := memd_art.fieldbyname('cl8').asstring;
          Ibc_coul.execute;
          dm_main.InsertK(id_coul, ktb_coul, '-101', '-1', '-1');
          Tcoul[8] := id_coul;
        end;

        if trim(memd_art.fieldbyname('cc9').asstring) <> '' then
        begin
          id_coul := dm_main.GenId;
          Ibc_coul.parambyname('cou_ID').asstring := id_coul;
          Ibc_coul.parambyname('cou_artid').asstring := id_art;
          Ibc_coul.parambyname('cou_code').asstring := memd_art.fieldbyname('cc9').asstring;
          Ibc_coul.parambyname('cou_nom').asstring := memd_art.fieldbyname('cl9').asstring;
          Ibc_coul.execute;
          dm_main.InsertK(id_coul, ktb_coul, '-101', '-1', '-1');
          Tcoul[9] := id_coul;
        end;

        if trim(memd_art.fieldbyname('cc10').asstring) <> '' then
        begin
          id_coul := dm_main.GenId;
          Ibc_coul.parambyname('cou_ID').asstring := id_coul;
          Ibc_coul.parambyname('cou_artid').asstring := id_art;
          Ibc_coul.parambyname('cou_code').asstring := memd_art.fieldbyname('cc10').asstring;
          Ibc_coul.parambyname('cou_nom').asstring := memd_art.fieldbyname('cl10').asstring;
          Ibc_coul.execute;
          dm_main.InsertK(id_coul, ktb_coul, '-101', '-1', '-1');
          Tcoul[10] := id_coul;
        end;

        if trim(memd_art.fieldbyname('cc11').asstring) <> '' then
        begin
          id_coul := dm_main.GenId;
          Ibc_coul.parambyname('cou_ID').asstring := id_coul;
          Ibc_coul.parambyname('cou_artid').asstring := id_art;
          Ibc_coul.parambyname('cou_code').asstring := memd_art.fieldbyname('cc11').asstring;
          Ibc_coul.parambyname('cou_nom').asstring := memd_art.fieldbyname('cl11').asstring;
          Ibc_coul.execute;
          dm_main.InsertK(id_coul, ktb_coul, '-101', '-1', '-1');
          Tcoul[11] := id_coul;
        end;

        if trim(memd_art.fieldbyname('cc12').asstring) <> '' then
        begin
          id_coul := dm_main.GenId;
          Ibc_coul.parambyname('cou_ID').asstring := id_coul;
          Ibc_coul.parambyname('cou_artid').asstring := id_art;
          Ibc_coul.parambyname('cou_code').asstring := memd_art.fieldbyname('cc12').asstring;
          Ibc_coul.parambyname('cou_nom').asstring := memd_art.fieldbyname('cl12').asstring;
          Ibc_coul.execute;
          dm_main.InsertK(id_coul, ktb_coul, '-101', '-1', '-1');
          Tcoul[12] := id_coul;
        end;

        if trim(memd_art.fieldbyname('cc13').asstring) <> '' then
        begin
          id_coul := dm_main.GenId;
          Ibc_coul.parambyname('cou_ID').asstring := id_coul;
          Ibc_coul.parambyname('cou_artid').asstring := id_art;
          Ibc_coul.parambyname('cou_code').asstring := memd_art.fieldbyname('cc13').asstring;
          Ibc_coul.parambyname('cou_nom').asstring := memd_art.fieldbyname('cl13').asstring;
          Ibc_coul.execute;
          dm_main.InsertK(id_coul, ktb_coul, '-101', '-1', '-1');
          Tcoul[13] := id_coul;
        end;

        if trim(memd_art.fieldbyname('cc14').asstring) <> '' then
        begin
          id_coul := dm_main.GenId;
          Ibc_coul.parambyname('cou_ID').asstring := id_coul;
          Ibc_coul.parambyname('cou_artid').asstring := id_art;
          Ibc_coul.parambyname('cou_code').asstring := memd_art.fieldbyname('cc14').asstring;
          Ibc_coul.parambyname('cou_nom').asstring := memd_art.fieldbyname('cl14').asstring;
          Ibc_coul.execute;
          dm_main.InsertK(id_coul, ktb_coul, '-101', '-1', '-1');
          Tcoul[14] := id_coul;
        end;

        if trim(memd_art.fieldbyname('cc15').asstring) <> '' then
        begin
          id_coul := dm_main.GenId;
          Ibc_coul.parambyname('cou_ID').asstring := id_coul;
          Ibc_coul.parambyname('cou_artid').asstring := id_art;
          Ibc_coul.parambyname('cou_code').asstring := memd_art.fieldbyname('cc15').asstring;
          Ibc_coul.parambyname('cou_nom').asstring := memd_art.fieldbyname('cl15').asstring;
          Ibc_coul.execute;
          dm_main.InsertK(id_coul, ktb_coul, '-101', '-1', '-1');
          Tcoul[15] := id_coul;
        end;

        if trim(memd_art.fieldbyname('cc16').asstring) <> '' then
        begin
          id_coul := dm_main.GenId;
          Ibc_coul.parambyname('cou_ID').asstring := id_coul;
          Ibc_coul.parambyname('cou_artid').asstring := id_art;
          Ibc_coul.parambyname('cou_code').asstring := memd_art.fieldbyname('cc16').asstring;
          Ibc_coul.parambyname('cou_nom').asstring := memd_art.fieldbyname('cl16').asstring;
          Ibc_coul.execute;
          dm_main.InsertK(id_coul, ktb_coul, '-101', '-1', '-1');
          Tcoul[16] := id_coul;
        end;

        if trim(memd_art.fieldbyname('cc17').asstring) <> '' then
        begin
          id_coul := dm_main.GenId;
          Ibc_coul.parambyname('cou_ID').asstring := id_coul;
          Ibc_coul.parambyname('cou_artid').asstring := id_art;
          Ibc_coul.parambyname('cou_code').asstring := memd_art.fieldbyname('cc17').asstring;
          Ibc_coul.parambyname('cou_nom').asstring := memd_art.fieldbyname('cl17').asstring;
          Ibc_coul.execute;
          dm_main.InsertK(id_coul, ktb_coul, '-101', '-1', '-1');
          Tcoul[17] := id_coul;
        end;

        if trim(memd_art.fieldbyname('cc18').asstring) <> '' then
        begin
          id_coul := dm_main.GenId;
          Ibc_coul.parambyname('cou_ID').asstring := id_coul;
          Ibc_coul.parambyname('cou_artid').asstring := id_art;
          Ibc_coul.parambyname('cou_code').asstring := memd_art.fieldbyname('cc18').asstring;
          Ibc_coul.parambyname('cou_nom').asstring := memd_art.fieldbyname('cl18').asstring;
          Ibc_coul.execute;
          dm_main.InsertK(id_coul, ktb_coul, '-101', '-1', '-1');
          Tcoul[18] := id_coul;
        end;

        if trim(memd_art.fieldbyname('cc19').asstring) <> '' then
        begin
          id_coul := dm_main.GenId;
          Ibc_coul.parambyname('cou_ID').asstring := id_coul;
          Ibc_coul.parambyname('cou_artid').asstring := id_art;
          Ibc_coul.parambyname('cou_code').asstring := memd_art.fieldbyname('cc19').asstring;
          Ibc_coul.parambyname('cou_nom').asstring := memd_art.fieldbyname('cl19').asstring;
          Ibc_coul.execute;
          dm_main.InsertK(id_coul, ktb_coul, '-101', '-1', '-1');
          Tcoul[19] := id_coul;
        end;

        if trim(memd_art.fieldbyname('cc20').asstring) <> '' then
        begin
          id_coul := dm_main.GenId;
          Ibc_coul.parambyname('cou_ID').asstring := id_coul;
          Ibc_coul.parambyname('cou_artid').asstring := id_art;
          Ibc_coul.parambyname('cou_code').asstring := memd_art.fieldbyname('cc20').asstring;
          Ibc_coul.parambyname('cou_nom').asstring := memd_art.fieldbyname('cl20').asstring;
          Ibc_coul.execute;
          dm_main.InsertK(id_coul, ktb_coul, '-101', '-1', '-1');
          Tcoul[20] := id_coul;
        end;
      end
      else
      begin
               //Il y a pas de couleur il faut lié au moins une couleur générique
        id_coul := dm_main.GenId;
        Ibc_coul.parambyname('cou_ID').asstring := id_coul;
        Ibc_coul.parambyname('cou_artid').asstring := id_art;
        Ibc_coul.parambyname('cou_code').asstring := '';
        Ibc_coul.parambyname('cou_nom').asstring := '';
        Ibc_coul.execute;
        dm_main.InsertK(id_coul, ktb_coul, '-101', '-1', '-1');
        Tcoul[1] := id_coul;
      end;

            //---Les tailles pour finir---------------
      Ibc_tail.close;
      Ibc_tail.parambyname('GT').asinteger := Ibc_gt.fieldbyname('GT_GINKOIA').asinteger;
      Ibc_tail.open;

      while not ibc_tail.eof do
      begin
        id_tt := dm_main.GenId;
        Ibc_tt.parambyname('ttv_id').asstring := id_tt;
        Ibc_tt.parambyname('ttv_artid').asstring := id_art;
        Ibc_tt.parambyname('ttv_tgfid').asinteger := Ibc_tail.fieldbyname('tgf_id').asinteger;
        Ibc_tt.execute;
        dm_main.InsertK(id_tt, ktb_tt, '-101', '-1', '-1');

        ibc_tail.next;
      end;

           //---Mise à jour de la table de correspondance ARTICLE/Taille/Couleur

      ibc_tail.first;
      while not ibc_tail.eof do
      begin
        for i := 1 to 20 do
        begin
          if Tcoul[i] <> '' then
          begin
            tbl_art.insert;
            tbl_art.fieldbyname('ART_HUSKY').asstring := memd_art.fieldbyname('code'
              ).asstring;
            tbl_art.fieldbyname('TAIL_HUSKY').asinteger := ibc_tail.fieldbyname('tgf_idref'
              ).asinteger;
            tbl_art.fieldbyname('Coul_HUSKY').asinteger := i;

            tbl_art.fieldbyname('ART_GINKOIA').asstring := id_art;

            if not pseudo then
            begin
              tbl_art.fieldbyname('TAIL_GINKOIA').asinteger := ibc_tail.fieldbyname('tgf_id'
                ).asinteger;
              tbl_art.fieldbyname('COUL_GINKOIA').asstring := Tcoul[i];
            end
            else
            begin
              tbl_art.fieldbyname('TAIL_GINKOIA').asinteger := 0;
              tbl_art.fieldbyname('COUL_GINKOIA').asinteger := 0;
            end;

            tbl_art.post;
          end;
        end;
        Ibc_tail.next;
      end;

      memd_art.next;

    end;

    Dm_Main.IB_UpDateCache(ibq_class); //Mise à jour des classements
    dm_main.commit;
  except
    MessageDlg('Chrono et code en cours :' + chro + '/' + cod, mtWarning, [], 0);
    raise;
    dm_main.rollback;
  end;

  memd_art.close;
  Ibq_TVA.close;

  Dm_Main.IB_CancelCache(ibq_class);
  Ibq_Class.close;

  screen.Cursor := crDefault;
  Application.ProcessMessages;
end;

procedure Tdm_import.Tarifs;
var
  id_achat, id_vente: string;
  ktb_achat, ktb_vente: string;
  nbart, Un_pc: integer;
  vario: variant;
  achat, vente, catal: double;
  id_fourn, id_art, id_tail: integer;
  fachat, fvente: boolean;
  cpt: integer;
begin

   //-----Import des tarifs--------------------------
  screen.Cursor := crSQLWait;

  MemD_tarifs.DelimiterChar := ';';
  try
    MemD_tarifs.LoadFromTextFile(pathIp + 'TARIFS.TXT');
  except
    MessageDlg(memd_tarifs.fieldbyname('CODE').asstring, mtWarning, [], 0);
    Exit;
  end;

    //-----Recherche des ID des tables Article et Ref
  ibc_ktb.close;
  ibc_ktb.parambyname('ktb_name').asstring := 'TARPRIXVENTE';
  ibc_ktb.open;
  ktb_vente := ibc_ktb.fieldbyname('ktb_id').asstring;

  ibc_ktb.close;
  ibc_ktb.prepare;
  ibc_ktb.parambyname('ktb_name').asstring := 'TARCLGFOURN';
  ibc_ktb.open;
  ktb_achat := ibc_ktb.fieldbyname('ktb_id').asstring;

    //------Préparation des scripts--
  IbC_Achat.Close;
  IbC_Achat.SQL.Clear;
  IbC_Achat.SQL.Add('INSERT into TARCLGFOURN (CLG_ID,CLG_ARTID,CLG_FOUID,CLG_TGFID,CLG_PX,' +
    'CLG_PXNEGO,CLG_PXVI,CLG_RA1,CLG_RA2,CLG_RA3,CLG_TAXE,CLG_PRINCIPAL) ' +
    'Values (:CLG_ID,:CLG_ARTID,:CLG_FOUID,:CLG_TGFID,:CLG_PX,' +
    ':CLG_PXNEGO,:CLG_PXVI,0,0,0,0,1)');
  IbC_Achat.Prepare;

  IbC_Vente.Close;
  IbC_Vente.SQL.Clear;
  IbC_Vente.SQL.Add('INSERT into TARPRIXVENTE(PVT_ID,PVT_TVTID,PVT_ARTID,PVT_TGFID,PVT_PX) ' +
    'Values (:PVT_ID,0,:PVT_ARTID,:PVT_TGFID,:PVT_PX)');
  Ibc_Vente.prepare;

    //---Ouverture...
  import.open;
  tbl_art.open;
    //---C'est parti mon quiqui...
  Nbart := 0;
  Memd_tarifs.first;
  while not memd_tarifs.eof do
  begin
    if memd_tarifs.fieldbyname('CODE').asstring = '%FINI%' then break;
    Inc(Nbart);
    memd_tarifs.next;
  end;
  Vario := int(NbArt / 100);
  Un_Pc := Vario;

  try
    dm_main.starttransaction;
    cpt := 0;
    Nbart := 0;
    Memd_tarifs.first;
    while not memd_tarifs.eof do
    begin
      if memd_tarifs.fieldbyname('CODE').asstring = '%FINI%' then break;
            //Progress Bar
      inc(NbArt);
      if NbArt = Un_Pc then
      begin
        frm_main.PGB_IEC;
        NbArt := 0;
      end;
      Refresh_form;

      inc(cpt);
      if cpt = 1000 then
      begin
        cpt := 0;
        dm_main.commit;
        dm_main.starttransaction;
      end;

      if memd_tarifs.fieldbyname('tail').asstring = '00' then
      begin
               // --C'est le prix de base--
        catal := memd_tarifs.fieldbyname('catal').asfloat;
        achat := memd_tarifs.fieldbyname('achat').asfloat;
        vente := memd_tarifs.fieldbyname('vente').asfloat;

               //Recherche du fournisseur
        ibc_fou.close;
        ibc_fou.parambyname('fou').asstring := memd_tarifs.fieldbyname('fourn').asstring;
        ibc_fou.open;
        Id_fourn := ibc_fou.fieldbyname('four_ginkoia').asinteger;

               //Recherche de l'article
        ibc_Arti.close;
        ibc_Arti.parambyname('ART').asstring := memd_tarifs.fieldbyname('code').asstring;
        ibc_Arti.open;
        Id_art := ibc_arti.fieldbyname('art_ginkoia').asinteger;

        Id_tail := 0;
        fachat := true;
        fvente := true;
      end
      else
      begin
        if (achat = memd_tarifs.fieldbyname('achat').asfloat) and
          (catal = memd_tarifs.fieldbyname('catal').asfloat) then
          fachat := false
        else
        begin
          ibc_AT.close;
          Ibc_At.parambyname('ART').asstring := memd_tarifs.fieldbyname('code').asstring;
          Ibc_At.parambyname('tail').asstring := memd_tarifs.fieldbyname('tail').asstring;
          ibc_at.open;
          Id_tail := ibc_at.fieldbyname('tail_ginkoia').asinteger;
          fachat := true;
        end;

        if vente = memd_tarifs.fieldbyname('vente').asfloat then
          fvente := false
        else
        begin
          ibc_AT.close;
          Ibc_At.parambyname('ART').asstring := memd_tarifs.fieldbyname('code').asstring;
          Ibc_At.parambyname('tail').asstring := memd_tarifs.fieldbyname('tail').asstring;
          ibc_at.open;
          Id_tail := ibc_at.fieldbyname('tail_ginkoia').asinteger;
          fvente := true;
        end;
      end;
      if fvente = true then
      begin
        id_vente := dm_main.GenId;
        Ibc_vente.parambyname('pvt_id').asstring := id_vente;
        Ibc_vente.parambyname('pvt_artid').asinteger := id_art;
        Ibc_vente.parambyname('pvt_tgfid').asinteger := Id_tail;
        Ibc_vente.parambyname('pvt_px').asfloat := memd_tarifs.fieldbyname('vente').asfloat /
          euro;
        Ibc_vente.Execute;
        dm_main.InsertK(id_vente, ktb_vente, '-101', '-1', '-1');
      end;

      if fachat = true then
      begin
        Id_achat := dm_main.GenId;
        Ibc_achat.parambyname('CLG_Id').asstring := id_achat;
        Ibc_achat.parambyname('CLG_artId').asinteger := id_art;
        Ibc_achat.parambyname('CLG_fouid').asinteger := id_fourn;
        Ibc_achat.parambyname('CLG_tgfId').asinteger := id_tail;
        Ibc_achat.parambyname('CLG_px').asfloat := memd_tarifs.fieldbyname('catal').asfloat /
          euro;
        Ibc_achat.parambyname('CLG_pxnego').asfloat := memd_tarifs.fieldbyname('achat'
          ).asfloat / euro;
        Ibc_achat.parambyname('CLG_pxvi').asfloat := 0;
        Ibc_achat.execute;
        dm_main.InsertK(id_achat, ktb_achat, '-101', '-1', '-1');
      end;

      memd_tarifs.next;
    end;

    dm_main.commit;
  except
    MessageDlg(memd_tarifs.fieldbyname('CODE').asstring, mtWarning, [], 0);
    raise;
    dm_main.rollback;
  end;

  memd_tarifs.close;
  screen.Cursor := crDefault;
  Application.ProcessMessages;
end;

procedure Tdm_import.STOCKMVT;
var
  id_brl, id_br, id_TK, id_TKL, id_cdv: string;
  ktb_brl, ktb_br, ktb_TK, ktb_TKL, ktb_cdv: string;
    //ktb_bl, ktb_bll
  nbart, Un_pc: integer;
  vario: variant;

  Mvtdate: string;
  cpt: integer;
  cod: string;
  i, mag: integer;
  Session: array[1..20] of integer;
  TES: array[1..99] of integer;
begin

   //Création des sessions (Une par magasin)
  ibq_session.open;
  for i := 1 to 20 do
  begin
    session[i] := 0;
    mag := magas(i);
    if mag <> 0 then
    begin //Un magasin Ginkoia Existe
      ibq_session.insert;
      ibq_session.fieldbyname('SES_POSID').asinteger := postes(i);
      ibq_session.fieldbyname('SES_NUMERO').asstring := inttostr(i);
      ibq_session.fieldbyname('SES_DEBUT').asdatetime := IncMois(now, -1);
      ibq_session.fieldbyname('SES_FIN').asdatetime := IncMois(now, -1);
      ibq_session.fieldbyname('SES_CAISOUV').asstring := 'Transfert Husky';
      ibq_session.fieldbyname('SES_CAISFIN').asstring := 'Transfert Husky';
      ibq_session.fieldbyname('SES_NBTKT').asinteger := 0;
      ibq_session.fieldbyname('SES_ETAT').asinteger := 2;
      ibq_session.post;
      session[i] := ibq_session.fieldbyname('SES_ID').asinteger;
    end;
  end;

    //Génération d'un tableau contenant tous les ID des TES HUSKY
  for i := 1 to 99 do
  begin
    tes[i] := 0;
    Ibc_typ.close;
    Ibc_typ.parambyname('Typ').asinteger := i;
    Ibc_typ.open;
    if not ibc_typ.eof then tes[i] := ibc_typ.fieldbyname('typ_id').asinteger;
  end;

   //-----Import des STOCkS via les mouvements entrées et sorties de stock------
  screen.Cursor := crSQLWait;

  MemD_mvt.DelimiterChar := ';';
  try
    MemD_mvt.LoadFromTextFile(pathIp + 'STOCKTOT.TXT');
  except
    MessageDlg(memd_mvt.fieldbyname('code').asstring, mtWarning, [], 0);
    Exit;
  end;

     //-----Recherche des ID des tables BR et BRL
  ibc_ktb.close;
  ibc_ktb.parambyname('ktb_name').asstring := 'RECBR';
  ibc_ktb.open;
  ktb_br := ibc_ktb.fieldbyname('ktb_id').asstring;

  ibc_ktb.close;
  ibc_ktb.parambyname('ktb_name').asstring := 'RECBRL';
  ibc_ktb.open;
  ktb_brl := ibc_ktb.fieldbyname('ktb_id').asstring;

    //-----Recherche des ID des tables BL et BLL

//    ibc_ktb.close;
//    ibc_ktb.parambyname ( 'ktb_name' ) .asstring := 'NEGBL';
//    ibc_ktb.open;
//    ktb_BL := ibc_ktb.fieldbyname ( 'ktb_id' ) .asstring;
//
//    ibc_ktb.close;
//    ibc_ktb.parambyname ( 'ktb_name' ) .asstring := 'NEGBLL';
//    ibc_ktb.open;
//    ktb_bll := ibc_ktb.fieldbyname ( 'ktb_id' ) .asstring;

  ibc_ktb.close;
  ibc_ktb.parambyname('ktb_name').asstring := 'CSHTICKET';
  ibc_ktb.open;
  ktb_TK := ibc_ktb.fieldbyname('ktb_id').asstring;

  ibc_ktb.close;
  ibc_ktb.parambyname('ktb_name').asstring := 'CSHTICKETL';
  ibc_ktb.open;
  ktb_TKL := ibc_ktb.fieldbyname('ktb_id').asstring;

    //-----Recherche des ID des tables CONSODIV
  ibc_ktb.close;
  ibc_ktb.parambyname('ktb_name').asstring := 'CONSODIV';
  ibc_ktb.open;
  ktb_Cdv := ibc_ktb.fieldbyname('ktb_id').asstring;

    //------Préparation des scripts-- BR et BRL
  IbC_br.Close;
  IbC_br.SQL.Clear;
  IbC_br.SQL.Add('insert into recbr (BRE_ID,BRE_EXEID,BRE_CPAID,BRE_MAGID,BRE_FOUID,BRE_DATE,bre_mrgid,' +
    'BRE_NUMERO,BRE_NUMFOURN,' +

    'BRE_SAISON,BRE_REMISE,BRE_TVAHT1,BRE_TVATAUX1,BRE_TVA1,BRE_TVAHT2,' +
    'BRE_TVATAUX2,BRE_TVA2,BRE_TVAHT3,BRE_TVATAUX3,BRE_TVA3,BRE_TVAHT4,' +
    'BRE_TVATAUX4,BRE_TVA4,BRE_TVAHT5,BRE_TVATAUX5,BRE_TVA5,BRE_FRAISPORT,' +
    'BRE_FRAISDOUANE,BRE_CLOTURE,BRE_FOURNTTC,BRE_FRAISPORTTVA,' +
    'BRE_FRAISPORTOK,BRE_ARCHIVE,BRE_FDNP,BRE_REMGLO,bre_notva,bre_reglement) ' +
    'values (:BRE_ID,0,0,:BRE_MAGID,:BRE_FOUID,:bre_date,0,' +
    ':BRE_NUMERO,:BRE_NUMFOURN,' +
    '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,1,0,0,0,:bre_reglement)');
  Ibc_br.Prepare;

  IbC_brl.Close;
  IbC_brl.SQL.Clear;
  IbC_brl.SQL.Add('insert into recbrl (BRL_ID,BRL_BREID,BRL_ARTID,BRL_TGFID,BRL_COUID,BRL_QTE,' +
    'BRL_PXCTLG,BRL_PXACHAT,BRL_PXNN,BRL_TVA,BRL_CDLID,' +
    'BRL_REMISE1,BRL_REMISE2,BRL_REMISE3,BRL_CPFA,BRL_PXVENTE,BRL_CDLLIVRAISON,' +
    'BRL_CDENUMERO,brl_tartaille,BRL_VALREMGLO,BRL_FRAIS)' +

    'Values (:BRL_ID,:BRL_BREID,:BRL_ARTID,:BRL_TGFID,:BRL_COUID,:BRL_QTE,' +
    ':BRL_PXCTLG,:BRL_PXACHAT,:BRL_PXNN,19.6,0,' +
    '0,0,0,0,0,:BRL_CDLLIVRAISON,:BRL_CDENUMERO,0,0,0)');
  IbC_brl.Prepare;

//    //------Préparation des scripts-- BL et BLL
//    IbC_bl.Close;
//    IbC_bl.SQL.Clear;
//    IbC_bl.SQL.Add ( 'insert into negbl (BLE_ID,BLE_MAGID,BLE_CLTID,BLE_TYPE,BLE_NUMERO,' +
//        'BLE_DATE,BLE_LIVREUR,BLE_REMISE,BLE_DETAXE,' +
//        'BLE_TVAHT1,BLE_TVATAUX1,BLE_TVA1,' +
//        'BLE_TVAHT2,BLE_TVATAUX2,BLE_TVA2,' +
//        'BLE_TVAHT3,BLE_TVATAUX3,BLE_TVA3,' +
//        'BLE_TVAHT4,BLE_TVATAUX4,BLE_TVA4,' +
//        'BLE_TVAHT5,BLE_TVATAUX5,BLE_TVA5,' +
//        'BLE_CLOTURE,BLE_ARCHIVE,BLE_NMODIF,' +
//        'BLE_USRID,BLE_TYPID,BLE_CIVID,BLE_VILID,BLE_CPAID,BLE_MRGID,' +
//        'BLE_CLTNOM,BLE_CLTPRENOM,BLE_ADRLIGNE,BLE_COMENT,BLE_MARGE,BLE_PRO) ' +
//        'values (:BLE_ID,:BLE_MAGID,0,0,:BLE_NUMERO,' +
//        ':BLE_DATE,:BLE_LIVREUR,0,0,' +
//        '0,0,0,' +
//        '0,0,0,' +
//        '0,0,0,' +
//        '0,0,0,' +
//        '0,0,0,' +
//        '1,1,1,' +
//        '0,0,0,0,0,0,' +
//        ':BLE_CLTNOM,:BLE_CLTPRENOM,:BLE_ADRLIGNE,:BLE_COMENT,0,0)' ) ;
//    Ibc_bl.Prepare;
//
//    IbC_bll.Close;
//    IbC_bll.SQL.Clear;
//    IbC_bll.SQL.Add ( 'insert into negbll (BLL_ID,BLL_BLEID,BLL_ARTID,BLL_TGFID,BLL_COUID,' +
//        'BLL_NOM,BLL_QTE,BLL_PXBRUT,BLL_PXNET,BLL_TYPE,BLL_SSTOTAL,' +
//        'BLL_TVA,bll_usrid,bll_typid,bll_linetip,bll_pxnn,bll_insstotal,bll_gpsstotal)' +
//        'Values (:BLL_ID,:BLL_BLEID,:BLL_ARTID,:BLL_TGFID,:BLL_COUID,' +
//        ':BLL_NOM,:BLL_QTE,:BLL_PXBRUT,:BLL_PXNET,0,0,' +
//        ':BLL_TVA,0,0,0,:BLL_PXNN,0,0)' ) ;
//    IbC_BLL.Prepare;

    //------Préparation des scripts-- TICKET & TICKET LIGNE
  IbC_bl.Close;
  IbC_bl.SQL.Clear;
  IbC_bl.SQL.Add('insert into CSHTICKET (TKE_ID,TKE_SESID,TKE_CLTID,TKE_USRID,TKE_NUMERO,' +
    'TKE_DATE,TKE_DETAXE,TKE_CAISSIER,TKE_NUM,TKE_ARCHIVE,' +
    'TKE_TOTBRUTA1,TKE_REMA1,TKE_TOTNETA1,TKE_QTEA1,' +
    'TKE_TOTBRUTA2,TKE_REMA2,TKE_TOTNETA2,TKE_QTEA2,' +
    'TKE_TOTBRUTA3,TKE_REMA3,TKE_TOTNETA3,TKE_QTEA3,' +
    'TKE_TOTBRUTA4,TKE_REMA4,TKE_TOTNETA4,TKE_QTEA4,' +
    'TKE_DIVINT,TKE_DIVFLOAT,TKE_DIVCHAR,' +
    'TKE_CHEFCLTID,TKE_CTEID) ' +
    'values (:TKE_ID,:TKE_SESID,0,0,:TKE_NUMERO,' +
    ':TKE_DATE,0,:TKE_CAISSIER,:TKE_NUM,1,' +
    '0,0,0,0,' +
    '0,0,0,0,' +
    '0,0,0,0,' +
    '0,0,0,0,' +
    '0,0,:TKE_DIVCHAR,' +
    '0,0)');
  Ibc_bl.Prepare;

  IbC_bll.Close;
  IbC_bll.SQL.Clear;
  IbC_bll.SQL.Add('insert into CSHTICKETL (tkl_id,tkl_tkeid,tkl_artid,tkl_tgfid,tkl_couid,' +
    'tkl_nom,tkl_usrid,tkl_pxbrut,tkl_remise,tkl_qte,tkl_pxnet,tkl_pxnn,' +
    'tkl_tva,tkl_typid,tkl_gpsstotal,tkl_sstotal,tkl_insstotal,tkl_ssmontant,' +
    'tkl_bllid,tkl_typevte,tkl_coment)' +
    'Values (:tkl_id,:tkl_tkeid,:tkl_artid,:tkl_tgfid,:tkl_couid,' +
    ':tkl_nom,0,:tkl_pxbrut,0,:tkl_qte,:tkl_pxnet,:tkl_pxnn,' +
    ':tkl_tva,:tkl_typid,0,0,0,0,' +
    '0,0,:tkl_coment)');
  IbC_BLL.Prepare;

    //------Préparation des scripts-- conso div
  IbC_cdv.Close;
  IbC_cdv.SQL.Clear;
  IbC_cdv.SQL.Add('insert into Consodiv (CDV_ID,CDV_ARTID,CDV_TGFID,CDV_COUID,' +
    'CDV_MAGID,CDV_TYPID,CDV_DATE,CDV_COMENT,CDV_QTE) ' +
    'values (:cdv_id,:cdv_artid,:cdv_tgfid,:cdv_couid,:cdv_magid,' +
    ':cdv_typid,:cdv_date,:cdv_coment,:cdv_qte)');
  Ibc_cdv.Prepare;

    //---Ouverture...
  import.open;
  tbl_art.open;
    //---C'est parti mon quiqui...
  Nbart := 0;
  Memd_mvt.first;
  while not memd_MVT.eof do
  begin
    if memd_mvt.fieldbyname('CODE').asstring = '%FINI%' then break;
    Inc(Nbart);
    memd_mvt.next;
  end;
  Vario := int(NbArt / 100);
  Un_Pc := Vario;

  try
    dm_main.starttransaction;
    Cpt := 0;
    Nbart := 0;
    Memd_mvt.first;
    while not memd_mvt.eof do
    begin
      if memd_mvt.fieldbyname('CODE').asstring = '%FINI%' then break;
      cod := memd_art.fieldbyname('code').asstring;

            //Progress Bar
      inc(NbArt);
      if NbArt = Un_Pc then
      begin
        frm_main.PGB_IEC;
        NbArt := 0;
                //dm_main.commit;
                //dm_main.starttransaction;
      end;

      inc(cpt);
      if cpt = 1000 then
      begin
        cpt := 0;
        dm_main.commit;
        dm_main.starttransaction;
      end;

      Refresh_form;

      case memd_mvt.fieldbyname('tes').asinteger of

        1, 2, 3, 5, 6, 7, 8, 9, 30:
          begin
                       //Cas de SORTIE donc génération d'un enreg dans Ticket

            if copy(memd_Mvt.fieldbyname('SAAMM').asstring, 1, 1) = '1' then
              Mvtdate := '01/' + copy(memd_Mvt.fieldbyname('SAAMM').asstring, 4, 2) + '/19'
                + copy(memd_Mvt.fieldbyname('SAAMM').asstring, 2, 2)
            else
              Mvtdate := '01/' + copy(memd_Mvt.fieldbyname('SAAMM').asstring, 4, 2) + '/20'
                + copy(memd_Mvt.fieldbyname('SAAMM').asstring, 2, 2);

                        //Il faut regarder si l'entete pour ce mois et ce magasin existe déjà
            ibc_entbl.close;
            ibc_entbl.parambyname('MvtDate').asstring := MvtDate;
            ibc_entbl.parambyname('Mag').asinteger := magas(Memd_Mvt.fieldbyname('mag').asinteger);
            ibc_entbl.open;
            if ibc_entbl.eof then
            begin
                           //Il faut créer l'entête du Ticket
              id_TK := dm_main.GenId;

              dm_main.InsertK(id_TK, ktb_TK, '-101', '-1', '-1');

              Ibc_bl.parambyname('tke_id').asstring := id_TK;
              Ibc_bl.parambyname('tke_sesid').asinteger := session[Memd_Mvt.fieldbyname('mag').asinteger];
              Ibc_bl.parambyname('tke_date').AsString := MvtDate;
              Ibc_bl.parambyname('tke_caissier').asstring := '';
              Ibc_bl.parambyname('tke_num').asstring := '';
              Ibc_bl.parambyname('tke_numero').asstring := memd_Mvt.fieldbyname('SAAMM').asstring;

              Ibc_bl.execute;

            end
            else
              id_TK := ibc_entbl.fieldbyname('TKE_ID').asstring;

                        //--Recherche des correspondances
            ibc_ATc.close;
            Ibc_Atc.parambyname('ART').asstring := memd_mvt.fieldbyname('code').asstring;
            Ibc_Atc.parambyname('tail').asinteger := memd_mvt.fieldbyname('tail').asinteger;
            Ibc_Atc.parambyname('coul').asinteger := memd_mvt.fieldbyname('coul').asinteger;
            ibc_atc.open;

            if not ibc_atc.eof then
            begin
                           //Si les tailles /couleurs ne sont pas référencé les mouvements sont rejetés

                           //Recherche du Typ
              case memd_mvt.fieldbyname('tes').asinteger of
                7, 8, 9: //Anciennement la facturation HUSKY
                  begin
                    memd_mvt.edit;
                    memd_mvt.fieldbyname('tes').asinteger := memd_mvt.fieldbyname('tes'
                      ).asinteger - 6;
                    memd_mvt.post;
                  end;
                30: //Cas des retours fournisseurs transformés en vente retro.
                  begin
                    memd_mvt.edit;
                    memd_mvt.fieldbyname('tes').asinteger := 6;
                    memd_mvt.post;
                  end;
              end;

                            //ibc_typ.close;
                            //Ibc_typ.parambyname ( 'Typ' ) .asinteger := memd_mvt.fieldbyname ( 'tes'
                            //    ) .asinteger;
                            //Ibc_typ.open;

                        //--Création de la ligne------------
              id_TKL := dm_main.GenId;

              dm_main.InsertK(id_TKL, ktb_TKL, '-101', '-1', '-1');

              ibc_bll.parambyname('TKL_ID').asstring := id_tkl;
              ibc_bll.parambyname('TKL_TKEID').asstring := id_tk;
              ibc_bll.parambyname('tkl_artid').asinteger := ibc_atc.fieldbyname('art_ginkoia').asinteger;
              ibc_bll.parambyname('tkl_tgfid').asinteger := ibc_atc.fieldbyname('tail_ginkoia').asinteger;
              ibc_bll.parambyname('tkl_couid').asinteger := ibc_atc.fieldbyname('coul_ginkoia').asinteger;
              ibc_bll.parambyname('tkl_nom').asstring := '';
              ibc_bll.parambyname('tkl_qte').asfloat := Memd_Mvt.fieldbyname('qte').asfloat;
              if Memd_Mvt.fieldbyname('qte').asfloat <> 0 then
              begin
                ibc_bll.parambyname('tkl_Pxbrut').asfloat := (Memd_Mvt.fieldbyname('pxb').asfloat / Memd_Mvt.fieldbyname(
                  'qte').asfloat) / euro;
                ibc_bll.parambyname('tkl_PxNet').asfloat := Memd_Mvt.fieldbyname('pxn').asfloat / euro;
                ibc_bll.parambyname('tkl_PxNN').asfloat := (Memd_Mvt.fieldbyname('pxn').asfloat / Memd_Mvt.fieldbyname(
                  'qte').asfloat) / euro;
              end
              else
              begin
                ibc_bll.parambyname('tkl_Pxbrut').asfloat := 0;
                ibc_bll.parambyname('tkl_PxNet').asfloat := 0;
              end;

              ibc_bll.parambyname('tkl_tva').asfloat := Memd_Mvt.fieldbyname('tva'
                ).asfloat;
              ibc_bll.parambyname('tkl_typid').asinteger := tes[memd_mvt.fieldbyname('tes').asinteger];
              ibc_bll.parambyname('tkl_coment').asstring := '';
              ibc_bll.execute;

            end;

          end;

        50, 51, 52, 60, 62, 63, 64, 65:
          begin
                       //Cas ENTREE donc génération d'un enreg dans BRL

            if copy(memd_Mvt.fieldbyname('SAAMM').asstring, 1, 1) = '1' then
              Mvtdate := '01/' + copy(memd_Mvt.fieldbyname('SAAMM').asstring, 4, 2) + '/19'
                + copy(memd_Mvt.fieldbyname('SAAMM').asstring, 2, 2)
            else
              Mvtdate := '01/' + copy(memd_Mvt.fieldbyname('SAAMM').asstring, 4, 2) + '/20'
                + copy(memd_Mvt.fieldbyname('SAAMM').asstring, 2, 2);
                        //Il faut retrouver le fournisseur
            Ibc_fou.close;
            Ibc_Fou.parambyname('FOU').asinteger := memd_Mvt.fieldbyname('Fourn').asinteger;
            Ibc_Fou.open;

                       //Il faut regarder si l'entete pour ce mois et pour le fournisseur et la magasin existe déjà
            ibc_entbr.close;
            ibc_entbr.parambyname('MvtDate').asstring := MvtDate;
            ibc_entbr.parambyname('Fourn').asinteger := ibc_fou.fieldbyname('four_ginkoia').asinteger;
            ibc_entbr.parambyname('Mag').asinteger := magas(Memd_Mvt.fieldbyname('mag').asinteger);
            ibc_entbr.open;
            if ibc_entbr.eof then
            begin
                           //Il faut créer l'entête du BR
              id_br := dm_main.GenId;

              dm_main.InsertK(id_br, ktb_br, '-101', '-1', '-1');

              Ibc_br.parambyname('bre_id').asstring := id_br;
              Ibc_br.parambyname('bre_date').AsString := MvtDate;
              Ibc_br.parambyname('bre_numero').asstring := '';
              Ibc_br.parambyname('bre_numfourn').asstring := '';
              Ibc_br.parambyname('bre_magid').asinteger := magas(Memd_Mvt.fieldbyname('mag'
                ).asinteger);
              Ibc_br.parambyname('bre_fouid').asinteger := ibc_fou.fieldbyname('four_ginkoia').asinteger;
              Ibc_br.parambyname('bre_reglement').asdatetime := now;
              Ibc_br.execute;

            end
            else
              id_br := ibc_entbr.fieldbyname('bre_Id').asstring;

                        //--Recherche des correspondances
            ibc_ATc.close;
            Ibc_Atc.parambyname('ART').asstring := memd_mvt.fieldbyname('code').asstring;
            Ibc_Atc.parambyname('tail').asinteger := memd_mvt.fieldbyname('tail').asinteger;
            Ibc_Atc.parambyname('coul').asinteger := memd_mvt.fieldbyname('coul').asinteger;
            ibc_atc.open;

            if not ibc_atc.eof then
            begin
                           //Si les tailles /couleurs ne sont pas référencé les mouvements sont rejetés

                        //--Création de la ligne------------
              id_brl := dm_main.GenId;

              dm_main.InsertK(id_brl, ktb_brl, '-101', '-1', '-1');

              ibc_brl.parambyname('brl_id').asstring := id_brl;
              ibc_brl.parambyname('brl_breid').asstring := id_br;
              ibc_brl.parambyname('brl_artid').asinteger := ibc_atc.fieldbyname('art_ginkoia'
                ).asinteger;
              ibc_brl.parambyname('brl_tgfid').asinteger := ibc_atc.fieldbyname(
                'tail_ginkoia'
                ).asinteger;
              ibc_brl.parambyname('brl_couid').asinteger := ibc_atc.fieldbyname(
                'coul_ginkoia'
                ).asinteger;
              ibc_brl.parambyname('brl_qte').asfloat := Memd_Mvt.fieldbyname('qte'
                ).asfloat;
              ibc_brl.parambyname('brl_pxctlg').asfloat := Memd_Mvt.fieldbyname('pxn'
                ).asfloat /
                euro;
              ibc_brl.parambyname('brl_pxACHAT').asfloat := Memd_Mvt.fieldbyname('pxn'
                ).asfloat
                / euro;
              ibc_brl.parambyname('brl_pxnn').asfloat := Memd_Mvt.fieldbyname('pxn').asfloat
                /
                euro;
              ibc_brl.parambyname('brl_cdenumero').asstring := '';
              ibc_brl.parambyname('BRL_CDLLIVRAISON').asstring := '';
              ibc_brl.execute;
            end;

          end;

        20, 21, 22, 23, 24, 25, 26, 27, 28:
          begin
                    //---Cas de Conso Diverses

            if copy(memd_Mvt.fieldbyname('SAAMM').asstring, 1, 1) = '1' then
              Mvtdate := '01/' + copy(memd_Mvt.fieldbyname('SAAMM').asstring, 4, 2) + '/19'
                + copy(memd_Mvt.fieldbyname('SAAMM').asstring, 2, 2)
            else
              Mvtdate := '01/' + copy(memd_Mvt.fieldbyname('SAAMM').asstring, 4, 2) + '/20'
                + copy(memd_Mvt.fieldbyname('SAAMM').asstring, 2, 2);

                        //--Recherche du Typ

                        //ibc_typ.close;
            if (memd_mvt.fieldbyname('tes').asinteger = 27) or //Les transfert IM passe en Sortie diverse
              (memd_mvt.fieldbyname('tes').asinteger = 28) then
            begin
              memd_mvt.edit;
              memd_mvt.fieldbyname('tes').asinteger := 26;
              memd_mvt.post;
            end;

                        //    Ibc_typ.parambyname ( 'Typ' ) .asinteger := 26
                        //ELSE
//                      //      Ibc_typ.parambyname ( 'Typ' ) .asinteger := memd_mvt.fieldbyname ( 'tes' ) .asinteger;
                        //Ibc_typ.open;

                        //--Recherche des correspondances
            ibc_ATc.close;
            Ibc_Atc.parambyname('ART').asstring := memd_mvt.fieldbyname('code').asstring;
            Ibc_Atc.parambyname('tail').asinteger := memd_mvt.fieldbyname('tail').asinteger;
            Ibc_Atc.parambyname('coul').asinteger := memd_mvt.fieldbyname('coul').asinteger;
            ibc_atc.open;

            if not ibc_atc.eof then
            begin

                             //--Création de l'enregistrement------------
              id_cdv := dm_main.GenId;

              dm_main.InsertK(id_cdv, ktb_cdv, '-101', '-1', '-1');

              ibc_cdv.parambyname('cdv_id').asstring := id_cdv;
              ibc_cdv.parambyname('cdv_artid').asinteger := ibc_atc.fieldbyname('art_ginkoia'
                ).asinteger;
              ibc_cdv.parambyname('cdv_tgfid').asinteger := ibc_atc.fieldbyname(
                'tail_ginkoia'
                ).asinteger;
              ibc_cdv.parambyname('cdv_couid').asinteger := ibc_atc.fieldbyname(
                'coul_ginkoia'
                ).asinteger;
              ibc_cdv.parambyname('cdv_magid').asinteger := magas(Memd_Mvt.fieldbyname('mag'
                ).asinteger);
              ibc_cdv.parambyname('cdv_date').asstring := MvtDate;
                            //ibc_cdv.parambyname ( 'cdv_typid' ) .asinteger := Ibc_typ.fieldbyname ( 'Typ_Id'
                            //    ) .asinteger;
              ibc_cdv.parambyname('cdv_typid').asinteger := tes[memd_mvt.fieldbyname('tes').asinteger];

              ibc_cdv.parambyname('cdv_coment').asstring := 'Transfert Husky->Ginkoia';
              ibc_cdv.parambyname('cdv_qte').asfloat := Memd_Mvt.fieldbyname('qte'
                ).asfloat;
              ibc_cdv.execute;

            end;

          end;
      end;
      memd_mvt.next;
    end;

    dm_main.commit;
  except
    MessageDlg('Problème' + memd_mvt.fieldbyname('code').asstring + '/' +
      memd_mvt.fieldbyname('mag').asstring + '/' +
      memd_mvt.fieldbyname('tail').asstring + '/' +
      memd_mvt.fieldbyname('coul').asstring + '/' +
      memd_mvt.fieldbyname('SAAMM').asstring, mtWarning, [], 0);
    raise;
    dm_main.rollback;
  end;
  ibq_session.close;
  screen.Cursor := crDefault;
  Application.ProcessMessages;
end;

procedure Tdm_import.CB;
var
  id_cb: string;
  ktb_cb: string;
  nbart, Un_pc: integer;
  vario: variant;
  cpt: integer;

begin

   //-----Import des CB--------------------------
  screen.Cursor := crSQLWait;

  MemD_CB.DelimiterChar := ';';
  try
    MemD_CB.LoadFromTextFile(pathIp + 'CB.TXT');
  except
    MessageDlg(memd_CB.fieldbyname('ARTICLE').asstring, mtWarning, [], 0);
    Exit;
  end;
    //-----Recherche des ID des tables Article et Ref
  ibc_ktb.close;
  ibc_ktb.parambyname('ktb_name').asstring := 'ARTCODEBARRE';
  ibc_ktb.open;
  ktb_cb := ibc_ktb.fieldbyname('ktb_id').asstring;

    //------Préparation des scripts--
  IbC_CB.Close;
  IbC_CB.SQL.Clear;
  IbC_CB.SQL.Add('INSERT into ARTCODEBARRE (CBI_ID,CBI_ARFID,CBI_TGFID,CBI_COUID,CBI_CB,' +
    'CBI_TYPE,CBI_CLTID,CBI_ARLID,CBI_LOC) ' +
    'Values (:CBI_ID,:CBI_ARFID,:CBI_TGFID,:CBI_COUID,:CBI_CB,:cbi_type,0,0,0)');
  IbC_CB.Prepare;

    //---Ouverture...
  import.open;
  tbl_art.open;
    //---C'est parti mon quiqui...
  Nbart := 0;
  Memd_CB.first;
  while not memd_CB.eof do
  begin
    if memd_CB.fieldbyname('ARTICLE').asstring = '%FINI%' then break;
    Inc(Nbart);
    memd_CB.next;
  end;
  Vario := int(NbArt / 100);
  Un_Pc := Vario;

  try
    dm_main.starttransaction;
    cpt := 0;
    Nbart := 0;
    Memd_CB.first;
    while not memd_CB.eof do
    begin
      if memd_CB.fieldbyname('ARTICLE').asstring = '%FINI%' then break;
            //Progress Bar
      inc(NbArt);
      if NbArt = Un_Pc then
      begin
        frm_main.PGB_IEC;
        NbArt := 0;
      end;

      Refresh_form;

      inc(cpt);
      if cpt = 1000 then
      begin
        cpt := 0;
        dm_main.commit;
        dm_main.starttransaction;
      end;

            //--Recherche des correspondances
      ibc_ATc.close;
      Ibc_Atc.parambyname('ART').asstring := memd_cb.fieldbyname('article').asstring;
      Ibc_Atc.parambyname('tail').asinteger := memd_cb.fieldbyname('tail').asinteger;
      Ibc_Atc.parambyname('coul').asinteger := memd_cb.fieldbyname('coul').asinteger;
      ibc_atc.open;
      if not ibc_atc.eof then
      begin

                 //Recherche de la relation avec ARTREFERENCE
        ibc_artref.close;
        ibc_artref.parambyname('ART').asinteger := ibc_atc.fieldbyname('art_ginkoia').asinteger;
        ibc_artref.open;
        if not ibc_artref.eof then
        begin

                       //C'est OK on a toutes les relations
          id_CB := dm_main.GenId;
          dm_main.InsertK(id_CB, ktb_CB, '-101', '-1', '-1');

          Ibc_cb.parambyname('CBI_Id').asstring := id_cb;
          Ibc_cb.parambyname('CBI_arfid').asinteger := ibc_artref.fieldbyname('ARF_ID'
            ).asinteger;
          Ibc_cb.parambyname('CBI_tgfid').asinteger := ibc_atc.fieldbyname('tail_ginkoia'
            ).asinteger;
          Ibc_cb.parambyname('CBI_couid').asinteger := ibc_atc.fieldbyname('coul_ginkoia'
            ).asinteger;
          Ibc_cb.parambyname('CBI_CB').asstring := memd_cb.fieldbyname('CB').asstring;

          if frm_main.chk_husky.Checked then
          begin
            if copy(memd_cb.fieldbyname('CB').asstring, 1, 1) = '2' then
              ibc_cb.parambyname('CBI_TYPE').asinteger := 1
            else
              ibc_cb.parambyname('CBI_TYPE').asinteger := 3
          end
          else
            ibc_cb.parambyname('CBI_TYPE').asinteger := 3;

          Ibc_cb.execute;

        end;
      end;

      memd_cb.next;
    end;

    dm_main.commit;
  except
    dm_main.rollback;
    MessageDlg(memd_CB.fieldbyname('ARTICLE').asstring, mtWarning, [], 0);
    raise;

  end;

  ibc_cb.close;
  ibc_artref.close;
  memd_cb.close;

  screen.Cursor := crDefault;
  Application.ProcessMessages;
end;

procedure Tdm_import.Commandes;
var
  id_cdl, id_cde: string;
  ktb_cde, ktb_cdl: string;
  nbart, Un_pc: integer;
  vario: variant;
  dadate: tdatetime;
  valeur: string;
begin

   //-----Import des Commandes--------------------------
  screen.Cursor := crSQLWait;

  MemD_cde.DelimiterChar := ';';
  MemD_cde.LoadFromTextFile(pathIp + 'COMMANDE.TXT');

     //-----Recherche des ID des tables Cmde et lignes
  ibc_ktb.close;
  ibc_ktb.parambyname('ktb_name').asstring := 'COMBCDE';
  ibc_ktb.open;
  ktb_cde := ibc_ktb.fieldbyname('ktb_id').asstring;

    //-----Recherche des
  ibc_ktb.close;
  ibc_ktb.parambyname('ktb_name').asstring := 'COMBCDEL';
  ibc_ktb.open;
  ktb_cdl := ibc_ktb.fieldbyname('ktb_id').asstring;

    //------Préparation des scripts--
  IbC_cde.Close;
  IbC_cde.SQL.Clear;
  IbC_cde.SQL.Add('insert into combcde (CDE_ID,CDE_NUMERO,CDE_SAISON,CDE_EXEID,CDE_CPAID,' +
    'CDE_MAGID,CDE_FOUID,cde_numfourn,CDE_DATE,CDE_REMISE,' +
    'CDE_TVAHT1,CDE_TVATAUX1,CDE_TVA1,' +
    'CDE_TVAHT2,CDE_TVATAUX2,CDE_TVA2,' +
    'CDE_TVAHT3,CDE_TVATAUX3,CDE_TVA3,' +
    'CDE_TVAHT4,CDE_TVATAUX4,CDE_TVA4,' +
    'CDE_TVAHT5,CDE_TVATAUX5,CDE_TVA5,' +
    'CDE_FRANCO,CDE_MODIF,CDE_LIVRAISON,CDE_OFFSET,CDE_REMGLO,CDE_ARCHIVE,CDE_TYPID,CDE_NOTVA)' +

    'Values (:CDE_ID,:CDE_NUMERO,:CDE_SAISON,:CDE_EXEID,:CDE_CPAID,' +
    ':CDE_MAGID,:CDE_FOUID,:cde_numfourn,:CDE_DATE,:CDE_REMISE,' +
    '0,0,0,' +
    '0,0,0,' +
    '0,0,0,' +
    '0,0,0,' +
    '0,0,0,' +
    '0,0,:CDE_LIVRAISON,:CDE_OFFSET,0,0,0,0)');

  Ibc_cde.Prepare;

  IbC_cdl.Close;
  IbC_cdl.SQL.Clear;
  IbC_cdl.SQL.Add('INSERT into combcdel (CDL_ID,CDL_CDEID,CDL_ARTID,CDL_TGFID,CDL_COUID,' +
    'CDL_QTE,CDL_PXCTLG,CDL_PXACHAT,CDL_TVA,' +
    'CDL_REMISE1,CDL_REMISE2,CDL_REMISE3,cdl_livraison,cdl_PxVente,cdl_offset,' +
    'cdl_tartaille,CDL_VALREMGLO)' +

    'Values (:CDL_ID,:CDL_CDEID,:CDL_ARTID,:CDL_TGFID,:CDL_COUID,' +
    ':CDL_QTE,:CDL_PXCTLG,:CDL_PXACHAT,:cdl_tva,' +
    ':CDL_REMISE1,:CDL_REMISE2,:CDL_REMISE3,:cdl_livraison,:cdl_PxVente,:cdl_offset,' +
    '0,0)');

  IbC_cdl.Prepare;

    //---Ouverture...
  import.open;
  tbl_art.open;
    //---C'est parti mon quiqui...
  Nbart := 0;
  Memd_Cde.first;
  while not memd_Cde.eof do
  begin
    if memd_Cde.fieldbyname('CODE').asstring = '%FINI%' then break;
    Inc(Nbart);
    memd_cde.next;
  end;
  Vario := int(NbArt / 100);
  Un_Pc := Vario;

  try
    dm_main.starttransaction;

    Nbart := 0;
    Memd_cde.first;
    while not memd_cde.eof do
    begin
      if memd_cde.fieldbyname('CODE').asstring = '%FINI%' then break;
            //Progress Bar
      inc(NbArt);
      if NbArt = Un_Pc then
      begin
        frm_main.PGB_IEC;
        NbArt := 0;
      end;
      Refresh_form;

            //---Regarder si l'entete existe déja le numéro Ginkoia pour le transfert
            //   est NumCde + Num Magasin Ex Cmde 680 et Mag 01 Numéro 68001
      Ibc_testcde.close;
      Ibc_testcde.parambyname('Numero').asstring := memd_cde.fieldbyname('Numcde').asstring +
        memd_cde.fieldbyname('Mag').asstring;
      Ibc_testcde.open;
      if ibc_testcde.eof then
      begin

               //----Recherche du fournisseur---

        Ibc_fourn.close;
        Ibc_Fourn.parambyname('FOURN').asinteger := memd_cde.fieldbyname('C_Fourn'
          ).asinteger;
        Ibc_Fourn.open;

               //----Création de l'entête---

        id_cde := dm_main.GenId;
        dm_main.InsertK(id_cde, ktb_cde, '-101', '-1', '-1');

        Ibc_cde.parambyname('cde_id').asstring := id_cde;
        Ibc_cde.parambyname('cde_numero').asstring := memd_cde.fieldbyname('Numcde').asstring +
          memd_cde.fieldbyname('Mag').asstring;
        Ibc_cde.parambyname('cde_saison').asinteger := 0;
        Ibc_cde.parambyname('cde_exeid').asinteger := 0;
        Ibc_cde.parambyname('cde_cpaid').asinteger := 0;
        Ibc_cde.parambyname('cde_magid').asinteger := magas(memd_cde.fieldbyname('Mag'
          ).asinteger);
        Ibc_cde.parambyname('cde_fouid').asinteger := ibc_fourn.fieldbyname('four_ginkoia'
          ).asinteger;
        Ibc_cde.parambyname('cde_numfourn').asstring := '';
        Ibc_cde.parambyname('cde_date').asstring := memd_cde.fieldbyname('C_date').asstring;
        Ibc_cde.parambyname('cde_Livraison').asstring := memd_cde.fieldbyname('C_Dliv').asstring;
        Ibc_cde.parambyname('cde_remise').asfloat := memd_cde.fieldbyname('C_Rbp').asfloat;
        Ibc_cde.parambyname('cde_offset').asinteger := memd_cde.fieldbyname('C_offset'
          ).asinteger;
        Ibc_cde.execute;
      end
      else
        id_cde := ibc_testcde.fieldbyname('Cde_id').asstring;

            //--Recherche des correspondances
      ibc_ATc.close;
      Ibc_Atc.parambyname('ART').asstring := memd_cde.fieldbyname('code').asstring;
      Ibc_Atc.parambyname('tail').asinteger := memd_cde.fieldbyname('tail').asinteger;
      Ibc_Atc.parambyname('coul').asinteger := memd_cde.fieldbyname('coul').asinteger;
      ibc_atc.open;

      if not ibc_atc.eof then
      begin

                //---Création des lignes de commandes---
        id_cdl := dm_main.GenId;
        dm_main.InsertK(id_cdl, ktb_cdl, '-101', '-1', '-1');

        ibc_cdl.parambyname('cdl_id').asstring := id_cdl;
        ibc_cdl.parambyname('cdl_cdeid').asstring := id_cde;
        ibc_cdl.parambyname('cdl_artid').asinteger := ibc_atc.fieldbyname('art_ginkoia'
          ).asinteger;
        ibc_cdl.parambyname('cdl_tgfid').asinteger := ibc_atc.fieldbyname('tail_ginkoia'
          ).asinteger;
        ibc_cdl.parambyname('cdl_couid').asinteger := ibc_atc.fieldbyname('coul_ginkoia'
          ).asinteger;
        ibc_cdl.parambyname('cdl_qte').asfloat := Memd_cde.fieldbyname('qte').asfloat;
        ibc_cdl.parambyname('cdl_pxctlg').asfloat := Memd_cde.fieldbyname('PxCatal').asfloat
          / euro;
        ibc_cdl.parambyname('cdl_pxACHAT').asfloat := Memd_cde.fieldbyname('pxnn').asfloat /
          euro;
        ibc_cdl.parambyname('cdl_tva').asfloat := Memd_cde.fieldbyname('tva').asfloat;
        ibc_cdl.parambyname('cdl_remise1').asfloat := Memd_cde.fieldbyname('r1').asfloat;
        ibc_cdl.parambyname('cdl_remise2').asfloat := Memd_cde.fieldbyname('r2').asfloat;
        ibc_cdl.parambyname('cdl_REMISE3').asfloat := Memd_cde.fieldbyname('r3').asfloat;
        ibc_cdl.parambyname('cdl_PxVente').asfloat := Memd_cde.fieldbyname('Pxvente'
          ).asfloat / euro;

        ibc_cdl.parambyname('cdl_livraison').asstring := Memd_cde.fieldbyname('Dtliv'
          ).asstring;
        ibc_cdl.parambyname('cdl_offset').asinteger := Memd_cde.fieldbyname('Dtlim'
          ).asinteger;

        ibc_cdl.execute;

      end;

      memd_cde.next;
    end;

    dm_main.commit;
  except
    raise;
    dm_main.rollback;
  end;

        //----Mise à jour des Montants HT & TVA dans les entetes

  try
    dm_main.starttransaction;

    ibq_cde.open;
    while not ibq_cde.eof do
    begin
      ibc_cumul.close;
      ibc_cumul.parambyname('CDE').asinteger := ibq_cde.fieldbyname('cde_id').asinteger;
      ibc_cumul.open;

      ibc_cumul.first;
      if not ibc_cumul.eof then
      begin
               // Mise à jour du Tx Tva 1
        ibq_cde.edit;
        ibq_cde.fieldbyname('cde_tvaht1').asfloat := ibc_cumul.fieldbyname('VALEURHT').asfloat;
        ibq_cde.fieldbyname('cde_tvataux1').asfloat := ibc_cumul.fieldbyname('cdl_tva').asfloat;
        ibq_cde.fieldbyname('cde_tva1').asfloat := (ibc_cumul.fieldbyname('VALEURHT').asfloat *
          (1 + (ibc_cumul.fieldbyname('cdl_tva').asfloat / 100))) -
          ibc_cumul.fieldbyname('VALEURHT').asfloat;
        ibq_cde.post;

        ibc_cumul.next;
        if not ibc_cumul.eof then
        begin
                   // Mise à jour du Tx Tva 2
          ibq_cde.edit;
          ibq_cde.fieldbyname('cde_tvaht2').asfloat := ibc_cumul.fieldbyname('VALEURHT'
            ).asfloat;
          ibq_cde.fieldbyname('cde_tvataux2').asfloat := ibc_cumul.fieldbyname('cdl_tva'
            ).asfloat;
          ibq_cde.fieldbyname('cde_tva2').asfloat := (ibc_cumul.fieldbyname('VALEURHT').asfloat
            *
            (1 + (ibc_cumul.fieldbyname('cdl_tva').asfloat / 100))) -
            ibc_cumul.fieldbyname('VALEURHT').asfloat;
          ibq_cde.post;

          ibc_cumul.next;
          if not ibc_cumul.eof then
          begin
                        // Mise à jour du Tx Tva 3
            ibq_cde.edit;
            ibq_cde.fieldbyname('cde_tvaht3').asfloat := ibc_cumul.fieldbyname('VALEURHT'
              ).asfloat;
            ibq_cde.fieldbyname('cde_tvataux3').asfloat := ibc_cumul.fieldbyname('cdl_tva'
              ).asfloat;
            ibq_cde.fieldbyname('cde_tva3').asfloat := (ibc_cumul.fieldbyname('VALEURHT'
              ).asfloat *
              (1 + (ibc_cumul.fieldbyname('cdl_tva').asfloat / 100))) -
              ibc_cumul.fieldbyname('VALEURHT').asfloat;

            ibq_cde.post;

            ibc_cumul.next;
            if not ibc_cumul.eof then
            begin
                        // Mise à jour du Tx Tva 4
              ibq_cde.edit;
              ibq_cde.fieldbyname('cde_tvaht4').asfloat := ibc_cumul.fieldbyname('VALEURHT'
                ).asfloat;
              ibq_cde.fieldbyname('cde_tvataux4').asfloat := ibc_cumul.fieldbyname('cdl_tva'
                ).asfloat;
              ibq_cde.fieldbyname('cde_tva4').asfloat := (ibc_cumul.fieldbyname('VALEURHT'
                ).asfloat *
                (1 + (ibc_cumul.fieldbyname('cdl_tva').asfloat / 100))) -
                ibc_cumul.fieldbyname('VALEURHT').asfloat;

              ibq_cde.post;

              ibc_cumul.next;
              if not ibc_cumul.eof then
              begin
                               // Mise à jour du Tx Tva 5
                ibq_cde.edit;
                ibq_cde.fieldbyname('cde_tvaht5').asfloat := ibc_cumul.fieldbyname(
                  'VALEURHT'
                  ).asfloat;
                ibq_cde.fieldbyname('cde_tvataux5').asfloat := ibc_cumul.fieldbyname(
                  'cdl_tva'
                  ).asfloat;
                ibq_cde.fieldbyname('cde_tva5').asfloat := (ibc_cumul.fieldbyname(
                  'VALEURHT'
                  ).asfloat *
                  (1 + (ibc_cumul.fieldbyname('cdl_tva').asfloat / 100))) -
                  ibc_cumul.fieldbyname('VALEURHT').asfloat;
                ibq_cde.post;
              end;

            end;

          end;

        end;

      end;

      ibq_cde.next
    end;

    Dm_Main.IB_UpDateCache(ibq_cde);
    dm_main.commit;
  except
    raise;
    dm_main.rollback;
  end;

  ibq_cde.close;
  ibc_cumul.close;
  ibc_brl.close;
  ibc_br.close;
  ibc_testcde.close;

  screen.Cursor := crDefault;
  Application.ProcessMessages;
end;

procedure Tdm_import.Conso;
begin

  ibq_conso.open;

  ibq_conso.insert;
  ibq_conso.fieldbyname('typ_lib').asstring := 'Régularisation de stock';
  ibq_conso.fieldbyname('typ_cod').asinteger := 20;
  ibq_conso.fieldbyname('typ_Categ').asinteger := 7;
  Ibq_conso.post;

  ibq_conso.insert;
  ibq_conso.fieldbyname('typ_lib').asstring := 'Vol ou perte connu';
  ibq_conso.fieldbyname('typ_cod').asinteger := 21;
  ibq_conso.fieldbyname('typ_Categ').asinteger := 7;
  Ibq_conso.post;

  ibq_conso.insert;
  ibq_conso.fieldbyname('typ_lib').asstring := 'Prélèvement personnel';
  ibq_conso.fieldbyname('typ_cod').asinteger := 22;
  ibq_conso.fieldbyname('typ_Categ').asinteger := 4;
  Ibq_conso.post;

  ibq_conso.insert;
  ibq_conso.fieldbyname('typ_lib').asstring := 'Mis en location';
  ibq_conso.fieldbyname('typ_cod').asinteger := 23;
  ibq_conso.fieldbyname('typ_Categ').asinteger := 4;
  Ibq_conso.post;

  ibq_conso.insert;
  ibq_conso.fieldbyname('typ_lib').asstring := 'Atelier';
  ibq_conso.fieldbyname('typ_cod').asinteger := 24;
  ibq_conso.fieldbyname('typ_Categ').asinteger := 4;
  Ibq_conso.post;

  ibq_conso.insert;
  ibq_conso.fieldbyname('typ_lib').asstring := 'Cadeaux';
  ibq_conso.fieldbyname('typ_cod').asinteger := 25;
  ibq_conso.fieldbyname('typ_Categ').asinteger := 7;
  Ibq_conso.post;

  ibq_conso.insert;
  ibq_conso.fieldbyname('typ_lib').asstring := 'Autres sorties';
  ibq_conso.fieldbyname('typ_cod').asinteger := 26;
  ibq_conso.fieldbyname('typ_Categ').asinteger := 4;
  Ibq_conso.post;

  ibq_conso.insert;
  ibq_conso.fieldbyname('typ_lib').asstring := 'Ventes Normales';
  ibq_conso.fieldbyname('typ_cod').asinteger := 1;
  ibq_conso.fieldbyname('typ_Categ').asinteger := 5;
  Ibq_conso.post;

  ibq_conso.insert;
  ibq_conso.fieldbyname('typ_lib').asstring := 'Ventes Promo';
  ibq_conso.fieldbyname('typ_cod').asinteger := 3;
  ibq_conso.fieldbyname('typ_Categ').asinteger := 5;
  Ibq_conso.post;

  ibq_conso.insert;
  ibq_conso.fieldbyname('typ_lib').asstring := 'Ventes Soldées';
  ibq_conso.fieldbyname('typ_cod').asinteger := 2;
  ibq_conso.fieldbyname('typ_Categ').asinteger := 5;
  Ibq_conso.post;

  ibq_conso.insert;
  ibq_conso.fieldbyname('typ_lib').asstring := 'Ventes aux Professionnels';
  ibq_conso.fieldbyname('typ_cod').asinteger := 5;
  ibq_conso.fieldbyname('typ_Categ').asinteger := 5;
  Ibq_conso.post;

  ibq_conso.insert;
  ibq_conso.fieldbyname('typ_lib').asstring := 'Rétrocessions externes';
  ibq_conso.fieldbyname('typ_cod').asinteger := 6;
  ibq_conso.fieldbyname('typ_Categ').asinteger := 4;
  Ibq_conso.post;

  Ibq_conso.close;

end;

//********************************************************************************
//*********CLIENTS************
//********************************************************************************

procedure Tdm_import.Clients(fid: integer);
var
  id_clt, id_pay, id_vil, id_adr, iclid1, iclid2, id_cb: string;
  NbCli, Un_Pc: Integer;
  Vario: variant;
  ktb_adr, ktb_clt, ktb_cb: string;
  id_ta, id_categ: integer;
  CD: string;
begin

  screen.Cursor := crSQLWait;

  ibq_grpclt.close;
  ibq_grpclt.sql.text := 'SELECT GCL_ID FROM GENGESTIONCLT where gcl_id<>0';
  ibq_grpclt.keylinks.text := 'GCL_ID';
  ibq_grpclt.open;


  ibc_france.open;
    //---Recherche et initialisation des champs de la table des classement
  ibq_class.close;
  ibq_class.parambyname('TYP').asstring := 'CLT';
  ibq_class.open;

  while not ibq_class.eof do
  begin
    if ibq_class.fieldbyname('cla_num').asinteger = 1 then
    begin
      if frm_main.chk_husky.Checked then
      begin
        ibq_class.edit;
        ibq_class.fieldbyname('cla_nom').asstring := 'Catégorie';
        ibq_class.post;
      end;
      id_categ := ibq_class.fieldbyname('cla_id').asinteger;
    end;
    if ibq_class.fieldbyname('cla_num').asinteger = 2 then
    begin
      if frm_main.chk_husky.Checked then
      begin
        ibq_class.edit;
        ibq_class.fieldbyname('cla_nom').asstring := 'Tranches d''âges';
        ibq_class.post;
      end;
      id_TA := ibq_class.fieldbyname('cla_id').asinteger;
    end;
    ibq_class.next;
  end;

   //*********************************************************
   // 1 ère partie Traitement des créations des villes et pays
   //*********************************************************
  client.DelimiterChar := ';';
  client.LoadFromTextFile(pathIp + 'clients.TXT');

  NbCli := 0;
  client.first;
  while not client.eof do
  begin
    if client.fieldbyname('nom').asstring = '%FINI%' then break;
    inc(NbCli);
    client.next;
  end;

  Vario := int((NbCli * 2) / 100); // 2 passages c'est comme si il y avait 2 fois plus de clients...
  Un_Pc := Vario;

  NbCli := 0;

  client.first;
  while not client.eof do
  begin
    if client.fieldbyname('nom').asstring = '%FINI%' then break;

        //Progress Bar
    inc(NbCli);
    if NbCli = Un_Pc then
    begin
      frm_main.PGB_IEC;
      NbCli := 0;
    end;
    Refresh_form;

        //----------------------
        // 1. Traitement du pays
        //----------------------
    if client.fieldbyname('pays').asstring <> '' then
    begin
      ibc_pays.close;
      ibc_pays.parambyname('pay_nom').asstring := uppercase(client.fieldbyname('pays').asstring);
      ibc_pays.open;
      if ibc_pays.eof = true then
      begin
               //Il faut créer le pays
        id_pay := dm_main.GenId;
        dm_main.preparescript('INSERT into GENPAYS (pay_id,pay_nom) values (:pay_id,:pay_nom)'
          );
        dm_main.SetScriptParameterValue('pay_id', id_pay);
        dm_main.SetScriptParameterValue('pay_nom', uppercase(client.fieldbyname('pays').asstring));
        dm_main.ExecuteInsertK('GENPAYS', id_pay);
      end
      else
               //Le pays existe on recupère l'ID
        id_pay := ibc_pays.fieldbyname('Pay_id').asstring;
    end
    else
           //Le Nom du pays est Nul dans Husky on affecte l'ID 0
           // id_pay := '0';
           // NON maintenat affectation à FRANCE
      id_pay := ibc_france.fieldbyname('pay_id').asstring;

        //--------------------------
        // 2. Traitement de la Ville
        //--------------------------

    ibc_cp.close;
    ibc_cp.parambyname('CP').asstring := uppercase(client.fieldbyname('cp').asstring);
    ibc_cp.open;

    ibc_cp.first;
    while not ibc_cp.eof do
    begin
      if (uppercase(client.fieldbyname('Ville').asstring) = ibc_cp.fieldbyname('Vil_nom').asstring)
        and (id_pay = ibc_cp.fieldbyname('Vil_payid').asstring) then
                   //Il existe une commune  qui correspond (Même Nom et même Id Pays)
        break
      else
        ibc_cp.next;
    end;

    if ibc_cp.eof then
    begin
           //Aucune commune ne correspond, il faut créer cette ville dans GenVille
      id_vil := dm_main.GenId;
      dm_main.preparescript('INSERT into GENVILLE (vil_id,vil_nom,vil_cp,vil_payid)' +
        ' values (:vil_id,:vil_nom,:vil_cp,:vil_payid)');
      dm_main.SetScriptParameterValue('vil_id', id_vil);
      dm_main.SetScriptParameterValue('vil_nom', uppercase(client.fieldbyname('ville').asstring));
      dm_main.SetScriptParameterValue('vil_cp', uppercase(client.fieldbyname('cp').asstring));
      dm_main.SetScriptParameterValue('vil_payid', id_pay);
      dm_main.ExecuteInsertK('GENVILLE', id_vil);
    end
    else
      id_vil := ibc_cp.fieldbyname('Vil_id').asstring;

    client.edit;
    client.fieldbyname('id_ville').asstring := id_vil;
    client.post;

    client.next;

  end;
  ibc_france.close;
   //*********************************************************
   // 2 ème partie Traitement des clients
   //*********************************************************

  Ibq_civ.open;

    //------Préparation des scripts--
  IbC_CB.Close;
  IbC_CB.SQL.Clear;
  IbC_CB.SQL.Add('INSERT into ARTCODEBARRE (CBI_ID,CBI_ARFID,CBI_TGFID,CBI_COUID,CBI_CB,' +
    'CBI_TYPE,CBI_CLTID,cbi_arlid,cbi_loc) ' +
    'Values (:CBI_ID,0,0,0,:CBI_CB,2,:cbi_cltid,0,0)');
  IbC_CB.Prepare;

  IbC_Adr.Close;
  IbC_Adr.SQL.Clear;
  IbC_Adr.SQL.Add('INSERT into GENADRESSE (ADR_ID,ADR_LIGNE,ADR_VILID,ADR_TEL,ADR_FAX,ADR_GSM,ADR_EMAIL,ADR_COMMENT)' +
    ' values (:adr_id,:adr_ligne,:adr_vilid,:ADR_TEL,:ADR_FAX,:ADR_GSM,:ADR_EMAIL,:ADR_COMMENT)');
  IbC_Adr.Prepare;

  IbC_Clt.Close;
  IbC_Clt.SQL.Clear;
  IbC_Clt.SQL.Add('INSERT into cltclient (clt_id,clt_gclid,clt_numero,clt_nom,' +
    'clt_prenom,CLT_ADRID,CLT_NAISSANCE,CLT_TYPE,CLT_CLTID,CLT_BL,' +
    'CLT_FIDELITE,CLT_COMMENT,CLT_TELEPHONE,CLT_TELTRAVAIL_FAX,CLT_PREMIERPASS,' +
    'CLT_DERNIERPASS,CLT_ECAUTORISE,CLT_ICLID1,CLT_ICLID2,CLT_ICLID3,CLT_ICLID4,CLT_ICLID5,' +
    'clt_afadrid,clt_mrgid,clt_cpaid,clt_civid,clt_cptbloque,CLT_NUMFACTOR,' +
    'CLT_ADRLIV,CLT_MAGID,CLT_ARCHIVE,' +
    'CLT_RESID,CLT_STAADRID,CLT_ORGID,CLT_NUMCB,CLT_NBJLOC,' +
    'CLT_CLIPROLOCATION,CLT_TOFACTURATION,CLT_LOCREMISE,CLT_VTEREMISE,' +
    'CLT_TOCLTID,CLT_IDTHEO,CLT_TOSUPPLEMENT,CLT_NMODIF)' +

    'Values (:clt_id,:clt_gclid,:clt_numero,:clt_nom,:clt_prenom,:CLT_ADRID,:CLT_NAISSANCE,:CLT_TYPE,' +
    ':CLT_CLTID,:CLT_BL,:CLT_FIDELITE,:CLT_COMMENT,:CLT_TELEPHONE,:CLT_TELTRAVAIL_FAX,' +
    ':CLT_PREMIERPASS,:CLT_DERNIERPASS,:CLT_ECAUTORISE,:CLT_ICLID1,:CLT_ICLID2,0,0,0,0,0,0,:clt_civid,0,' +
    ':CLT_NUMFACTOR,0,0,0,0,0,0,:clt_numcb,0,0,0,0,0,0,0,0,0)');
  IbC_Clt.Prepare;

    //Recherche des ID des tables Adresse & Clients

  ibc_ktb.close;
  ibc_ktb.parambyname('ktb_name').asstring := 'CLTCLIENT';
  ibc_ktb.open;
  ktb_clt := ibc_ktb.fieldbyname('ktb_id').asstring;

  ibc_ktb.close;
  ibc_ktb.prepare;
  ibc_ktb.parambyname('ktb_name').asstring := 'GENADRESSE';
  ibc_ktb.open;
  ktb_adr := ibc_ktb.fieldbyname('ktb_id').asstring;

  ibc_ktb.close;
  ibc_ktb.parambyname('ktb_name').asstring := 'ARTCODEBARRE';
  ibc_ktb.open;
  ktb_cb := ibc_ktb.fieldbyname('ktb_id').asstring;

  try
    dm_main.StartTransaction;

    client.first;
    while not client.eof do
    begin

      if client.fieldbyname('nom').asstring = '%FINI%' then break;
            //Progress Bar
      inc(NbCli);
      if NbCli = Un_Pc then
      begin
        frm_main.PGB_IEC;
        NbCli := 0;
      end;
      Refresh_form;

           //--------------------------
           //3. Traitement de l'adresse
           //--------------------------
      id_adr := dm_main.GenId;
      dm_main.InsertK(id_adr, ktb_adr, '-101', '-1', '-1');

      ibc_adr.parambyname('adr_id').asstring := id_adr;
      ibc_adr.parambyname('adr_ligne').asstring := ReplaceStr(client.fieldbyname('adresse'
        ).asstring, '%', #10, false);
      ibc_adr.parambyname('adr_vilid').asstring := client.fieldbyname('id_ville').asstring;
      ibc_adr.parambyname('adr_tel').asstring := client.fieldbyname('telp').asstring;
      ibc_adr.parambyname('adr_fax').asstring := client.fieldbyname('telt').asstring;
      ibc_adr.parambyname('adr_gsm').asstring := '';
      ibc_adr.parambyname('adr_email').asstring := '';
      ibc_adr.parambyname('adr_comment').asstring := ReplaceStr(client.fieldbyname('obs'
        ).asstring, '%', #10, false);
      ibc_adr.Execute;

      id_clt := dm_main.genId;
      dm_main.InsertK(id_clt, ktb_clt, '-101', '-1', '-1');

      Ibc_Clt.parambyname('clt_id').asstring := id_clt;
      Ibc_Clt.parambyname('clt_gclid').asinteger := ibq_GrpClt.fieldbyname('GCL_Id').asinteger;
      Ibc_Clt.parambyname('clt_numero').asstring := client.fieldbyname('numero').asstring;
      Ibc_Clt.parambyname('clt_nom').asstring := client.fieldbyname('nom').asstring;
      Ibc_Clt.parambyname('clt_prenom').asstring := client.fieldbyname('prenom').asstring;

      Ibc_Clt.parambyname('clt_adrid').asstring := id_adr;
      if length(client.fieldbyname('Janni').asstring) = 4 then
        Ibc_Clt.parambyname('clt_naissance').asstring := copy(client.fieldbyname('Janni').asstring, 1, 2) + '/' +
          copy(client.fieldbyname('Janni').asstring, 3, 2) + '/03'
      else
        Ibc_Clt.parambyname('clt_naissance').asstring := '';

      Ibc_Clt.parambyname('clt_type').asstring := '0';
      Ibc_Clt.parambyname('clt_cltid').asstring := '0';
      Ibc_Clt.parambyname('clt_bl').asstring := '0';

      if client.fieldbyname('cf').asstring = '0' then
        Ibc_Clt.parambyname('clt_fidelite').asstring := client.fieldbyname('cf').asstring
      else
        Ibc_Clt.parambyname('clt_fidelite').asstring := inttostr(fid);

      Ibc_Clt.parambyname('clt_comment').asstring := '';
      Ibc_Clt.parambyname('clt_telephone').asstring := '';
      Ibc_Clt.parambyname('clt_teltravail_fax').asstring := '';
      Ibc_Clt.parambyname('clt_premierpass').asstring := client.fieldbyname('dpp').asstring;
      Ibc_Clt.parambyname('clt_dernierpass').asstring := client.fieldbyname('ddp').asstring;
      Ibc_Clt.parambyname('clt_ECAUTORISE').asstring := client.fieldbyname('Encours').asstring;

            //Uniquement pour algol (ne plus utiliser)
            //Ibc_clt.parambyname('CLT_NUMFACTOR').asstring := client.fieldbyname('Garant').asstring;
      Ibc_clt.parambyname('CLT_NUMFACTOR').asstring := '';
      Ibc_Clt.parambyname('clt_numcb').asstring := '';

            //-----Civilité et Sexe
      if trim(client.fieldbyname('politesse').asstring) <> '' then
      begin
        ibq_civ.first;
        while not ibq_civ.eof do
        begin
          if ibq_Civ.fieldbyname('Civ_nom').asstring = client.fieldbyname('politesse').asstring then
            break
          else
            ibq_civ.next;
        end;

        if Ibq_civ.eof then
        begin
          ibq_civ.insert;
          ibq_civ.fieldbyname('civ_nom').asstring := client.fieldbyname('politesse').asstring;
          ibq_civ.fieldbyname('civ_sexe').asinteger := 0;
          Ibq_civ.post;
        end;
        Ibc_Clt.parambyname('clt_civid').asinteger := ibq_civ.fieldbyname('civ_id').asinteger;
      end
      else
        Ibc_Clt.parambyname('clt_civid').asstring := '0';

            //------Les Catégories et les tranches d'ages sont transférés dans les classement 1 & 2
      if client.fieldbyname('categ').asstring <> '' then
      begin
        ibq_class.first;
        while not ibq_class.eof do
        begin
          if ibq_class.fieldbyname('icl_nom').asstring <> client.fieldbyname('categ').asstring
            then
            ibq_class.next
          else
            break;
        end;

        if ibq_class.eof then
        begin // --Le Secteur n'existe pas
          ibq_class.insert;
          ibq_class.fieldbyname('icl_nom').asstring := client.fieldbyname('categ').asstring;
          ibq_class.fieldbyname('cit_iclid').asinteger := ibq_class.fieldbyname('icl_id'
            ).asinteger;
          ibq_class.fieldbyname('cit_claid').asinteger := id_categ;
          ibq_class.post;
        end;
        Ibc_Clt.parambyname('clt_iclid1').asinteger := ibq_class.fieldbyname('icl_id').asinteger;
      end
      else
        Ibc_Clt.parambyname('clt_iclid1').asinteger := 0;

      if client.fieldbyname('TA').asstring <> '' then
      begin
        ibq_class.first;
        while not ibq_class.eof do
        begin
          if ibq_class.fieldbyname('icl_nom').asstring <> client.fieldbyname('TA').asstring
            then
            ibq_class.next
          else
            break;
        end;

        if ibq_class.eof then
        begin // --Le Critère n'existe pas
          ibq_class.insert;
          ibq_class.fieldbyname('icl_nom').asstring := client.fieldbyname('TA').asstring;
          ibq_class.fieldbyname('cit_iclid').asinteger := ibq_class.fieldbyname('icl_id'
            ).asinteger;
          ibq_class.fieldbyname('cit_claid').asinteger := id_TA;
          ibq_class.post;
        end;
        Ibc_Clt.parambyname('clt_iclid2').asinteger := ibq_class.fieldbyname('icl_id').asinteger;
      end
      else
        Ibc_Clt.parambyname('clt_iclid2').asinteger := 0;

            //-----Code barre EAN8-----------------------------
      if CD_EAN('1' + copy(client.fieldbyname('obs').asstring, 1, 6), CD) then

      begin
        id_cb := dm_main.GenId;
        dm_main.InsertK(id_cb, ktb_cb, '-101', '-1', '-1');

        ibc_cb.parambyname('cbi_id').asstring := id_cb;
        ibc_cb.parambyname('cbi_cb').asstring := CD;
        ibc_cb.parambyname('cbi_cltid').asstring := id_clt;
        ibc_cb.execute;
      end;

      Ibc_Clt.Execute;

      client.next;
    end;
    Dm_Main.IB_UpDateCache(ibq_class); //Mise à jour des classements
    Dm_Main.IB_UpDateCache(ibq_civ); //Mise à jour des civilite

    dm_main.commit;
  except
    MessageDlg('Client N° ' + Clientnumero.asstring, mtWarning, [], 0);
    raise;
    dm_main.rollback;
  end;

  Dm_Main.IB_CancelCache(ibq_class);
  Ibq_class.close;
  ibq_GrpClt.close;
  screen.Cursor := crdefault;
  Application.ProcessMessages;
end;

procedure Tdm_import.CPTCLI;
var
  id_cpt: string;
  ktb_cpt: string;
  nbart, Un_pc: integer;
  vario: variant;

begin

   //-----Import des Comptes clients-------------------------
  screen.Cursor := crSQLWait;

  MemD_Cpt.DelimiterChar := ';';
  MemD_Cpt.LoadFromTextFile(pathIp + 'cptcli.TXT');

    //-----Recherche des ID des tables Article et Ref
  ibc_ktb.close;
  ibc_ktb.parambyname('ktb_name').asstring := 'CLTCOMPTE';
  ibc_ktb.open;
  ktb_cpt := ibc_ktb.fieldbyname('ktb_id').asstring;

    //------Préparation des scripts--
  IbC_Cpt.Close;
  IbC_Cpt.SQL.Clear;
  IbC_Cpt.SQL.Add('INSERT into CLTCOMPTE (CTE_ID,CTE_CLTID,CTE_LIBELLE,CTE_DATE,' +
    'CTE_DEBIT,CTE_CREDIT,CTE_MAGID,CTE_REGLER,CTE_TKEID,CTE_ORIGINE,CTE_FCEID,cte_typ,' +
    'CTE_RVSID,CTE_LETTRAGE,CTE_LETTRAGENUM,CTE_CTEID)' +
    'Values (:CTE_ID,:CTE_CLTID,:CTE_LIBELLE,:CTE_DATE,' +
    ':CTE_DEBIT,:CTE_CREDIT,:CTE_MAGID,:CTE_REGLER,0,0,0,0,0,0,:cte_lettragenum,0)');
  IbC_cpt.Prepare;

    //---C'est parti mon quiqui...
  Nbart := 0;
  Memd_Cpt.first;
  while not memd_Cpt.eof do
  begin
    if memd_Cpt.fieldbyname('CODE').asstring = '%FINI%' then break;
    Inc(Nbart);
    memd_Cpt.next;
  end;
  Vario := int(NbArt / 100);
  Un_Pc := Vario;

  try
    dm_main.starttransaction;

    Nbart := 0;
    Memd_Cpt.first;
    while not memd_Cpt.eof do
    begin
      if memd_Cpt.fieldbyname('CODE').asstring = '%FINI%' then break;
            //Progress Bar
      inc(NbArt);
      if NbArt = Un_Pc then
      begin
        frm_main.PGB_IEC;
        NbArt := 0;
      end;
      Refresh_form;

      if IsNumStr(memd_cpt.fieldbyname('mag').asstring) then
      begin
            //--Recherche du client
        ibc_cli.close;
        Ibc_cli.parambyname('NUMERO').asinteger := memd_cpt.fieldbyname('code').asinteger;
        ibc_cli.open;
        if not ibc_cli.eof then
        begin

                    // OK on a toutes les relations
          id_Cpt := dm_main.GenId;
          dm_main.InsertK(id_Cpt, ktb_Cpt, '-101', '-1', '-1');

          Ibc_cpt.parambyname('CTE_Id').asstring := id_cpt;
          Ibc_cpt.parambyname('CTE_cltId').asinteger := ibc_cli.fieldbyname('clt_id').asinteger;
          Ibc_cpt.parambyname('CTE_libelle').asstring := memd_cpt.fieldbyname('lib').asstring;
          Ibc_cpt.parambyname('CTE_date').asstring := memd_cpt.fieldbyname('date').asstring;
          Ibc_cpt.parambyname('CTE_debit').asfloat := memd_cpt.fieldbyname('debit').asfloat / euro;
          Ibc_cpt.parambyname('CTE_credit').asfloat := memd_cpt.fieldbyname('credit').asfloat / euro;
          Ibc_cpt.parambyname('CTE_magid').asfloat := magas(memd_cpt.fieldbyname('mag').asinteger);
          if memd_cpt.fieldbyname('Dtreg').asstring <> '' then
            Ibc_cpt.parambyname('CTE_regler').asstring := memd_cpt.fieldbyname('Dtreg').asstring
          else
            Ibc_cpt.parambyname('CTE_regler').asstring := '';

          Ibc_cpt.parambyname('cte_lettragenum').asstring := '';
          Ibc_cpt.execute;

        end;
      end;

      memd_cpt.next;
    end;

    dm_main.commit;
  except
    raise;
    dm_main.rollback;
  end;

  memd_cpt.close;
  ibc_cli.close;
  ibc_cpt.close;

  screen.Cursor := crDefault;
  Application.ProcessMessages;
end;

procedure Tdm_import.FIDELITE;
var
  id_cpt: string;
  ktb_cpt: string;
  nbart, Un_pc: integer;
  vario: variant;

  nbtranche: variant;
  PointFidelite: integer;
begin

   //-----Import des Fidelites-------------------------
  screen.Cursor := crSQLWait;

  MemD_Fid.DelimiterChar := ';';
  MemD_Fid.LoadFromTextFile(pathIp + 'Fidelite.TXT');

    //-----Recherche des ID des tables Article et Ref
  ibc_ktb.close;
  ibc_ktb.parambyname('ktb_name').asstring := 'CLTFIDELITE';
  ibc_ktb.open;
  ktb_cpt := ibc_ktb.fieldbyname('ktb_id').asstring;

    //------Préparation des scripts--
  IbC_Cpt.Close;
  IbC_Cpt.SQL.Clear;
  IbC_Cpt.SQL.Add('INSERT into CLTFIDELITE (FID_ID,FID_TKEID,FID_POINT,FID_DATE,' +
    'FID_MAGID,FID_BACID,FID_CLTID,FID_MANUEL)' +
    'Values (:FID_ID,0,:FID_POINT,:FID_DATE,' +
    ':FID_MAGID,0,:FID_CLTID,0)');
  IbC_cpt.Prepare;

    //---C'est parti mon quiqui...
  Nbart := 0;
  Memd_Fid.first;
  while not memd_fid.eof do
  begin
    if memd_fid.fieldbyname('CODE').asstring = '%FINI%' then break;
    Inc(Nbart);
    memd_Fid.next;
  end;
  Vario := int(NbArt / 100);
  Un_Pc := Vario;

  try
    dm_main.starttransaction;

    Nbart := 0;
    Memd_fid.first;
    while not memd_fid.eof do
    begin
      if memd_fid.fieldbyname('CODE').asstring = '%FINI%' then break;
            //Progress Bar
      inc(NbArt);
      if NbArt = Un_Pc then
      begin
        frm_main.PGB_IEC;
        NbArt := 0;
      end;
      Refresh_form;

            //--Recherche du client
      ibc_cli.close;
      Ibc_cli.parambyname('NUMERO').asinteger := memd_fid.fieldbyname('code').asinteger;
      ibc_cli.open;
      if not ibc_cli.eof then
      begin

                // OK on a toutes les relations
        id_Cpt := dm_main.GenId;
        dm_main.InsertK(id_Cpt, ktb_Cpt, '-101', '-1', '-1');

        nbtranche := int(memd_fid.fieldbyname('credit').asfloat / strtofloat(frm_main.TrPrix.text));
        PointFidelite := nbtranche * strtoint(frm_main.TrPoint.text);
        if PointFidelite = 0 then PointFidelite := 1;
        Ibc_cpt.parambyname('FID_Id').asstring := id_cpt;
        Ibc_cpt.parambyname('FID_cltId').asinteger := ibc_cli.fieldbyname('clt_id').asinteger;
        Ibc_cpt.parambyname('FID_date').asstring := memd_fid.fieldbyname('date').asstring;
        Ibc_cpt.parambyname('FID_point').asinteger := PointFidelite;
        Ibc_cpt.parambyname('FID_magid').asfloat := magas(1);

        Ibc_cpt.execute;

      end;

      memd_fid.next;
    end;

    dm_main.commit;
  except
    raise;
    dm_main.rollback;
  end;

  memd_fid.close;
  ibc_cli.close;
  ibc_cpt.close;

  screen.Cursor := crDefault;
  Application.ProcessMessages;
end;

function tdm_import.ReplaceStr(Chaine, Ex, Nlle: string; CaseSensitive: boolean): string;
var
  i: integer;
  s, t: string;
begin
  s := '';
  t := Chaine;
  repeat
    if CaseSensitive then
      i := pos(Ex, t)
    else
      i := pos(lowercase(Ex), lowercase(t));
    if i > 0 then
    begin
      s := s + Copy(t, 1, i - 1) + Nlle;
      t := Copy(t, i + Length(Ex), MaxInt);
    end
    else
      s := s + t;
  until i <= 0;
  Result := s;
end;

procedure Tdm_import.TARIF23;
var h1, h2: integer;
  id_art: integer;
  lecode: string;
  nbart, un_pc: integer;
  vario: variant;
  cpt: integer;
begin

   //-----Import des tarifs 2 et 3--------------------------
  screen.Cursor := crSQLWait;

  MemD_tarifs.DelimiterChar := ';';
  try
    MemD_tarifs.LoadFromTextFile(pathIp + 'TARIFS.TXT');
  except
    MessageDlg(memd_tarifs.fieldbyname('CODE').asstring, mtWarning, [], 0);
    Exit;
  end;

  cpt := 0;
  Nbart := 0;
  memd_tarifs.open;
  Memd_tarifs.first;
  while not memd_tarifs.eof do
  begin
    if memd_tarifs.fieldbyname('CODE').asstring = '%FINI%' then break;
    Inc(Nbart);
    memd_tarifs.next;
  end;
  Vario := int(NbArt / 100);
  Un_Pc := Vario;

    //Création des entetes de tarifs
  Que_Tarvente.Open;
  if Que_Tarvente.Locate('TVT_NOM', 'Husky 2', []) then
    H1 := que_Tarvente.fieldByName('TVT_ID').asInteger

  else
  begin
    que_Tarvente.Insert;
    que_Tarvente.fieldByName('TVT_NOM').asString := 'Husky 2';
    H1 := que_Tarvente.fieldByName('TVT_ID').asInteger;
    que_Tarvente.Post;
  end;
  if Que_Tarvente.Locate('TVT_NOM', 'Husky 3', []) then
    H2 := que_Tarvente.fieldByName('TVT_ID').asInteger
  else
  begin
    que_Tarvente.Insert;
    que_Tarvente.fieldByName('TVT_NOM').asString := 'Husky 3';
    H2 := que_Tarvente.fieldByName('TVT_ID').asInteger;
    que_Tarvente.Post;
  end;
  que_Tarvente.Close;

  Que_TarPrix.open;
  lecode := '';
  nbart := 0;
  Memd_tarifs.First;
  while not Memd_tarifs.Eof do
  begin
    if memd_tarifs.fieldbyname('CODE').asstring = '%FINI%' then BREAK;

        //Progress Bar
    inc(NbArt);
    if NbArt = Un_Pc then
    begin
      frm_main.PGB_IEC;
      NbArt := 0;
    end;
    Refresh_form;

    inc(cpt);
    if cpt = 1000 then
    begin
      cpt := 0;
      dm_main.commit;
      dm_main.starttransaction;
    end;

    if lecode <> memd_tarifs.fieldByName('CODE').asstring then
    begin
      lecode := memd_tarifs.fieldByName('CODE').asstring;

      if Trim(Memd_tarifs.fieldByname('Vente2').asstring) <> '' then
      begin

        if Memd_tarifs.fieldByname('Vente2').asfloat <> 0 then
        begin
                 //Recherche de l'article
          ibc_Arti.close;
          ibc_Arti.parambyname('ART').asstring := memd_tarifs.fieldbyname('code').asstring;
          ibc_Arti.open;
          Id_art := ibc_arti.fieldbyname('art_ginkoia').asinteger;

          Que_TarPrix.Insert;
          que_TarPrix.fieldByName('PVT_TVTID').asInteger := H1;
          que_TarPrix.FieldByName('PVT_ARTID').asInteger := Id_art;
          que_TarPrix.FieldByName('PVT_TGFID').asInteger := 0;
          que_TarPrix.FieldByName('PVT_PX').asFloat := Memd_tarifs.fieldByname('Vente2').asFloat;
          que_TarPrix.Post;
        end;
      end;

      if Trim(Memd_tarifs.fieldByname('Vente3').asstring) <> '' then
      begin
        if Memd_tarifs.fieldByname('Vente3').asfloat <> 0 then
        begin
                 //Recherche de l'article
          ibc_Arti.close;
          ibc_Arti.parambyname('ART').asstring := memd_tarifs.fieldbyname('code').asstring;
          ibc_Arti.open;
          Id_art := ibc_arti.fieldbyname('art_ginkoia').asinteger;

          Que_TarPrix.Insert;
          que_TarPrix.fieldByName('PVT_TVTID').asInteger := H2;
          que_TarPrix.FieldByName('PVT_ARTID').asInteger := Id_art;
          que_TarPrix.FieldByName('PVT_TGFID').asInteger := 0;
          que_TarPrix.FieldByName('PVT_PX').asFloat := Memd_tarifs.fieldByname('Vente3').asFloat;
          que_TarPrix.Post;
        end;
      end;

    end;
    Memd_tarifs.Next;

  end;

  dm_main.IBOUpDateCache(que_TarPrix);
  dm_main.IBOCommitCache(que_TarPrix);

  memd_tarifs.close;
  que_TarVente.close;
  que_TarPrix.close;

  screen.Cursor := crdefault;

end;

//------------------------------------------------------------------------------
//   LOCATION
//------------------------------------------------------------------------------

function Tdm_import.Statut: boolean;
var F: TSearchRec;
begin

    // Test si location
  if FindFirst(pathIp + 'Statut.TXT', faAnyFile, F) <> 0 then
  begin
    findclose(F);
    result := false;
    EXIT;
  end;
  result := true;

  screen.Cursor := crSQLWait;
  que_statut.open;
  MemD_Statut.DelimiterChar := ';';
  MemD_Statut.LoadFromTextFile(pathIp + 'Statut.TXT');

  try

    memd_statut.first;
    while not memd_statut.eof do
    begin
      if memd_statut.fieldbyname('num').asstring = '%FINI%' then break;

      que_statut.insert;
      que_statut.fieldbyname('STA_NOM').asstring := memd_statut.fieldbyname('Lib').asstring;
      que_statut.fieldbyname('STA_DISPOLOC').asinteger := 0;
      que_statut.post;

      memd_statut.next;
    end;

    dm_main.starttransaction;
    Dm_Main.IBOUpDateCache(que_statut);
    dm_main.commit;

  except
    dm_main.IBOCancelCache(que_statut);
    raise;
    dm_main.rollback;
  end;
  dm_main.IBOCommitCache(Que_statut);

  que_statut.close;
  MemD_statut.close;
  screen.Cursor := crdefault;
  Application.ProcessMessages;
end;

procedure Tdm_import.Residence;

begin

  screen.Cursor := crSQLWait;
  que_resi.open;
  MemD_Resi.DelimiterChar := ';';
  MemD_Resi.LoadFromTextFile(pathIp + 'Residence.TXT');

  try

    memd_Resi.first;
    while not memd_Resi.eof do
    begin
      if memd_Resi.fieldbyname('num').asstring = '%FINI%' then break;

      que_resi.insert;
      que_Resi.fieldbyname('RES_NOM').asstring := memd_Resi.fieldbyname('Lib').asstring;
      que_Resi.post;

      memd_Resi.next;
    end;

    dm_main.starttransaction;
    Dm_Main.IBOUpDateCache(que_Resi);
    dm_main.commit;

  except
    dm_main.IBOCancelCache(que_Resi);
    raise;
    dm_main.rollback;
  end;
  dm_main.IBOCommitCache(Que_Resi);

  que_Resi.close;
  MemD_Resi.close;
  screen.Cursor := crdefault;
  Application.ProcessMessages;
end;

procedure Tdm_import.Categorie;

begin
  ibc_tva.open;
  ibc_tctl.open;

   //Tout d'abord il faut creer rayon/fam/SF Import

  que_ray.open;
  que_ray.insert;
  que_ray.fieldbyname('RAP_NOM').asstring := 'Transpo Pulka';
  que_ray.fieldbyname('RAP_ordreaff').asfloat := 99999999;
  que_ray.fieldbyname('RAP_theo').asinteger := 0;
  que_ray.post;

  que_fam.open;
  que_fam.insert;
  que_fam.fieldbyname('FAP_NOM').asstring := 'Transpo Pulka';
  que_fam.fieldbyname('FAP_ordreaff').asfloat := 99999999;
  que_fam.fieldbyname('FAP_theo').asinteger := 0;
  que_fam.fieldbyname('FAP_RAPID').asinteger := que_ray.fieldbyname('RAP_ID').asinteger;
  que_fam.post;

  que_compo.open;
  que_produit.open;
  que_typc.open;
  que_prdtc.open;
  que_prdlg.open;

  Import.open;
  Corres_gt.open;

  screen.Cursor := crSQLWait;
  que_categLoc.open;
  MemD_categ.DelimiterChar := ';';
  MemD_categ.LoadFromTextFile(pathIp + 'Categorie.TXT');

  try

    memd_categ.first;
    while not memd_categ.eof do
    begin
      if memd_categ.fieldbyname('num').asstring = '%FINI%' then break;

      que_categLoc.insert;
      que_categLoc.fieldbyname('CAL_NOM').asstring := memd_categ.fieldbyname('Lib').asstring;
      que_categLoc.fieldbyname('CAL_DESCRIPTION').asstring := '';

      if uppercase(memd_categ.fieldbyname('baton').asstring) = 'O' then
        que_categLoc.fieldbyname('cal_baton').asinteger := 1
      else
        que_categLoc.fieldbyname('cal_baton').asinteger := 0;

      if uppercase(memd_categ.fieldbyname('Fixa').asstring) = 'O' then
        que_categLoc.fieldbyname('cal_reglage').asinteger := 1
      else
        que_categLoc.fieldbyname('cal_reglage').asinteger := 0;

      que_categLoc.fieldbyname('CAL_DUREEAMT').asinteger := memd_categ.fieldbyname('amort').asinteger;

      que_typc.first;
      while not que_typc.eof do
      begin
        if copy(Que_TypcTCA_NOM.asstring, 1, 1) = MemD_CategCOMPTA.asstring then BREAK;
        que_typc.next;
      end;
      if not que_typc.eof then
        que_categLoc.fieldbyname('CAL_tcaid').asinteger := Que_TypcTCA_ID.asinteger
      else
        que_categLoc.fieldbyname('CAL_tcaid').asinteger := 0;

      if corres_gt.Locate('GT_HUSKY', memd_categ.fieldbyname('GT').asinteger, []) then
        que_categLoc.fieldbyname('CAL_GTFID').asinteger := corres_gt.fieldbyname('GT_GINKOIA').asinteger
      else
        que_categLoc.fieldbyname('CAL_GTFID').asinteger := 0;

      que_categLoc.post;

            //Pour chaque categorie une Sous famille

      que_compo.insert;
      que_compo.fieldbyname('com_NOM').asstring := 'Pulka / ' + que_categLoc.fieldbyname('CAL_NOM').asstring;
      que_compo.fieldbyname('com_ordreaff').asfloat := 99999999;
      que_compo.fieldbyname('com_theo').asinteger := 0;
      que_compo.fieldbyname('com_fapID').asinteger := que_fam.fieldbyname('FAP_ID').asinteger;
      que_compo.fieldbyname('com_tvaid').asinteger := ibc_tva.fieldbyname('tva_id').asinteger;
      que_compo.fieldbyname('com_tctid').asinteger := ibc_tctl.fieldbyname('tct_id').asinteger;
      que_compo.post;

            //Ainsi qu'un produit
      que_produit.insert;
      que_produit.fieldbyname('prd_nom').asstring := 'Pulka / ' + que_categLoc.fieldbyname('CAL_NOM').asstring;
      que_produit.fieldbyname('prd_description').asstring := MemD_CategNum.asstring;
      que_produit.fieldbyname('prd_caution').asfloat := 0;
      que_produit.fieldbyname('prd_comid').asinteger := que_compo.fieldbyname('com_id').asinteger;
      que_produit.fieldbyname('prd_magasin').asinteger := 0;
      que_produit.post;

      que_prdtc.insert;
      Que_PrdTCTYC_COMID.asinteger := que_compo.fieldbyname('com_id').asinteger;
      Que_PrdTCTYC_TCAID.asinteger := que_categLoc.fieldbyname('CAL_tcaid').asinteger;
      Que_PrdTCTYC_RAT.asfloat := 100;
      que_prdtc.post;

      que_prdlg.insert;
      Que_PrdlgPRL_CALID.asinteger := que_categLoc.fieldbyname('CAL_id').asinteger;
      Que_PrdlgPRL_TYCID.asinteger := Que_PrdTCTYC_ID.asinteger;
      Que_Prdlg.post;

      memd_categ.next;
    end;

    dm_main.starttransaction;
    Dm_Main.IBOUpDateCache(que_categLoc);
    dm_main.commit;

  except
    dm_main.IBOCancelCache(que_categLoc);
    raise;
    dm_main.rollback;
  end;
  dm_main.IBOCommitCache(Que_categLoc);

  que_categLoc.close;
  MemD_categ.close;
  screen.Cursor := crdefault;
  Application.ProcessMessages;

  Corres_gt.close;
  Import.close;
  que_typc.close;
  que_prdtc.close;
  que_prdlg.close;

end;

procedure Tdm_import.ArticleLoc;
var
  id_art, id_artprinc, id_cb: string;
  ktb_art, ktb_cb: string;
  nbart, Un_pc: integer;
  vario: variant;
  id_crit1, id_crit2: integer;
  i: integer;
  text: string;
  pxcession_princ, pxcession_sup, amt_princ, amt_sup: Extended;

begin

   //-----Import des articles--------------------------
  screen.Cursor := crSQLWait;

  MemD_ArtLoc.DelimiterChar := ';';
  try
    MemD_ArtLoc.LoadFromTextFile(pathIp + 'LOCARTICLE.TXT');
  except
    MessageDlg(memd_artloc.fieldbyname('num').asstring, mtWarning, [], 0);
    Exit;
  end;

    //-----Recherche des ID des tables Article et Ref
  ibc_ktb.close;
  ibc_ktb.parambyname('ktb_name').asstring := 'LOCARTICLE';
  ibc_ktb.open;
  ktb_art := ibc_ktb.fieldbyname('ktb_id').asstring;

    //------Préparation des scripts--
  IbC_Art.Close;
  IbC_Art.SQL.Clear;
  IbC_Art.SQL.Add('INSERT INTO LOCARTICLE  (ARL_ID,ARL_ARLID,ARL_STAID,ARL_MRKID,' +
    'ARL_TGFID,ARL_CALID,ARL_CDVID,ARL_TKEID,ARL_ICLID1,ARL_ICLID2,ARL_ICLID3,ARL_ICLID4,' +
    'ARL_ICLID5,ARL_CHRONO,ARL_NOM,ARL_DESCRIPTION,ARL_NUMSERIE,ARL_COMENT,' +
    'ARL_SESSALOMON,ARL_DATEACHAT,ARL_PRIXACHAT,ARL_PRIXVENTE,ARL_DATECESSION,' +
    'ARL_PRIXCESSION,ARL_DUREEAMT,ARL_SOMMEAMT,ARL_ARCHIVER,ARL_VIRTUEL,ARL_REFMRK)' +
    'VALUES' +
    '(:ARL_ID,:ARL_ARLID,:ARL_STAID,:ARL_MRKID,' +
    ':ARL_TGFID,:ARL_CALID,:ARL_CDVID,:ARL_TKEID,:ARL_ICLID1,:ARL_ICLID2,:ARL_ICLID3,:ARL_ICLID4,' +
    ':ARL_ICLID5,:ARL_CHRONO,:ARL_NOM,:ARL_DESCRIPTION,:ARL_NUMSERIE,:ARL_COMENT,' +
    ':ARL_SESSALOMON,:ARL_DATEACHAT,:ARL_PRIXACHAT,:ARL_PRIXVENTE,:ARL_DATECESSION,' +
    ':ARL_PRIXCESSION,:ARL_DUREEAMT,:ARL_SOMMEAMT,:ARL_ARCHIVER,:ARL_VIRTUEL,:ARL_REFMRK)');

  IbC_Art.Prepare;

        //-----Recherche des ID des tables Article et Ref
  ibc_ktb.close;
  ibc_ktb.parambyname('ktb_name').asstring := 'ARTCODEBARRE';
  ibc_ktb.open;
  ktb_cb := ibc_ktb.fieldbyname('ktb_id').asstring;

    //------Préparation des scripts--
  IbC_CB.Close;
  IbC_CB.SQL.Clear;
  IbC_CB.SQL.Add('INSERT into ARTCODEBARRE (CBI_ID,CBI_ARFID,CBI_TGFID,CBI_COUID,CBI_CB,' +
    'CBI_TYPE,CBI_CLTID,CBI_ARLID,cbi_loc) ' +
    'Values (:CBI_ID,:CBI_ARFID,:CBI_TGFID,:CBI_COUID,:CBI_CB,:CBI_TYPE,:CBI_CLTID,:CBI_ARLID,0)');
  IbC_CB.Prepare;

    //---Recherche et initialisation des champs de la table des classement
  ibq_class.close;
  ibq_class.parambyname('TYP').asstring := 'LOC';
  ibq_class.open;

  while not ibq_class.eof do
  begin
    if ibq_class.fieldbyname('cla_num').asinteger = 1 then
    begin
      ibq_class.edit;
      ibq_class.fieldbyname('cla_nom').asstring := 'Crit. Pulka (1)';
      ibq_class.post;
      id_crit1 := ibq_class.fieldbyname('cla_id').asinteger;
    end;
    if ibq_class.fieldbyname('cla_num').asinteger = 2 then
    begin
      ibq_class.edit;
      ibq_class.fieldbyname('cla_nom').asstring := 'Crit. Pulka (2)';
      ibq_class.post;
      id_crit2 := ibq_class.fieldbyname('cla_id').asinteger;
    end;
    ibq_class.next;
  end;

    //---Ouverture...
  import.open;
  corres_four.open;
  que_statut.open;
  que_categloc.open;

    //---C'est parti mon quiqui...
  Nbart := 0;
  Memd_artloc.first;
  while not memd_artloc.eof do
  begin
    if memd_artloc.fieldbyname('num').asstring = '%FINI%' then break;
    Inc(Nbart);
    memd_artloc.next;
  end;
  Vario := int(NbArt / 100);
  Un_Pc := Vario;

  try
    dm_main.starttransaction;

    Nbart := 0;
    Memd_artloc.first;
    while not memd_artloc.eof do
    begin

      if memd_artloc.fieldbyname('num').asstring = '%FINI%' then break;

           //Progress Bar
      inc(NbArt);
      if NbArt = Un_Pc then
      begin
        frm_main.PGB_IEC;
        NbArt := 0;

      end;
      Refresh_form;

      id_artPrinc := dm_main.GenId;
      dm_main.InsertK(id_artPrinc, ktb_art, '-101', '-1', '-1');

      pxcession_princ := memd_artloc.fieldbyname('pxcession').asfloat;
      pxcession_sup := 0;
      amt_princ := memd_artloc.fieldbyname('sommeAmt').asfloat;
      amt_sup := 0;

            //Traitement préalable
      if memd_artloc.fieldbyname('pxasup').asfloat <> 0 then
      begin

                //Il faut calculer le montant de l'amortissement ou le prix de  cession
                //Au proratat du prix achat et du prix achat supplémentaire

                //Prix de cession

        if memd_artloc.fieldbyname('pxcession').asfloat <> 0 then
        begin
          if (memd_artloc.fieldbyname('pxa').asfloat + memd_artloc.fieldbyname('pxasup').asfloat) <> 0 then
          begin
            pxcession_princ := memd_artloc.fieldbyname('pxcession').asfloat *
              (memd_artloc.fieldbyname('pxa').asfloat / (memd_artloc.fieldbyname('pxa').asfloat + memd_artloc.fieldbyname('pxasup').asfloat));
            pxcession_princ := roundrv(pxcession_princ, 2);
            pxcession_sup := memd_artloc.fieldbyname('pxcession').asfloat - pxcession_princ;
          end;
        end;

                //Somme des AMT

        if memd_artloc.fieldbyname('sommeAmt').asfloat <> 0 then
        begin
          if (memd_artloc.fieldbyname('pxa').asfloat + memd_artloc.fieldbyname('pxasup').asfloat) <> 0 then
          begin
            amt_princ := memd_artloc.fieldbyname('sommeAMT').asfloat *
              (memd_artloc.fieldbyname('pxa').asfloat / (memd_artloc.fieldbyname('pxa').asfloat + memd_artloc.fieldbyname('pxasup').asfloat));
            amt_princ := roundrv(amt_princ, 2);
            amt_sup := memd_artloc.fieldbyname('sommeAMT').asfloat - amt_princ;
          end;
        end;

      end;

      ibc_art.parambyname('arl_id').asstring := id_artPrinc;
      ibc_art.parambyname('arl_arlid').asstring := id_artPrinc;

            //RECHERCHE DU STATUT
      if que_statut.locate('STA_NOM', memd_artLoc.fieldbyname('statut').asstring, []) then
        ibc_art.parambyname('arl_staid').asinteger := que_statut.fieldbyname('STA_ID').asinteger
      else
        ibc_art.parambyname('arl_staid').asinteger := 0;

            //recherche de la marque et du fournisseur
      if memd_artloc.fieldbyname('pseudo').asstring <> 'O' then
      begin
        Ibc_fourn.close;
        Ibc_Fourn.parambyname('FOURN').asinteger := memd_artloc.fieldbyname('Fourn').asinteger;
        Ibc_Fourn.open;
        Ibc_art.parambyname('ARL_MRKID').asinteger := Ibc_fourn.fieldbyname('mrk_GINKOIA').asinteger;
      end
      else
        Ibc_art.parambyname('ARL_MRKID').asinteger := 0;

            //Recherche de la GT  et de la taille
      if memd_artloc.fieldbyname('pseudo').asstring <> 'O' then
      begin
        Ibc_gt.close;
        Ibc_gt.parambyname('gt').asinteger := memd_artloc.fieldbyname('GT').asinteger;
        Ibc_gt.open;

//              Ibc_gt2.close;
//              Ibc_gt2.parambyname('gt').asstring := memd_artloc.fieldbyname('libgt').asstring;
//              Ibc_gt2.open;

        ibc_indgt.close;
        ibc_indgt.parambyname('taille').asstring := memd_artloc.fieldbyname('libtaille').asstring;
        ibc_indgt.parambyname('gtfid').asinteger := Ibc_gt.fieldbyname('GT_GINKOIA').asinteger;
//                ibc_indgt.parambyname('gtfid').asinteger := Ibc_gt2.fieldbyname('gtf_id').asinteger;

        ibc_indgt.open;
        Ibc_art.parambyname('ARL_tgfiD').asinteger := ibc_indgt.fieldbyname('tgf_id').asinteger;

      end
      else
      begin
        Ibc_art.parambyname('ARL_TGFID').asinteger := 0;
      end;

            //Categorie
      if que_categloc.locate('CAL_NOM', memd_artloc.fieldbyname('categ').asstring, []) then
        ibc_art.parambyname('ARL_CALID').asinteger := que_categloc.fieldbyname('CAL_ID').asinteger
      else
        ibc_art.parambyname('ARL_CALID').asinteger := 0;

            //Conso Div
      ibc_art.parambyname('ARL_CDVID').asinteger := 0;

            //Ticket de vente
      ibc_art.parambyname('ARL_TKEID').asinteger := 0;

            //Autres Champ

      ibc_art.parambyname('ARL_CHRONO').asstring := memd_artloc.fieldbyname('num').asstring;
      ibc_art.parambyname('ARL_NOM').asstring := memd_artloc.fieldbyname('LIB1').asstring;
      ibc_art.parambyname('ARL_DESCRIPTION').asstring := '';

      ibc_art.parambyname('ARL_NUMSERIE').asstring := memd_artloc.fieldbyname('serie').asstring;

      text := '';

      if trim(memd_artloc.fieldbyname('LIB2').asstring) <> '' then
      begin
        text := memd_artloc.fieldbyname('LIB2').asstring;
        if trim(memd_artloc.fieldbyname('DIVERS').asstring) <> '' then
        begin
          text := text + #13 + memd_artloc.fieldbyname('DIVERS').asstring;
          if trim(memd_artloc.fieldbyname('COULEUR').asstring) <> '' then
            text := text + #13 + memd_artloc.fieldbyname('COULEUR').asstring;
        end
        else
        begin
          if trim(memd_artloc.fieldbyname('COULEUR').asstring) <> '' then
            text := text + #13 + memd_artloc.fieldbyname('COULEUR').asstring;
        end;
      end
      else
      begin
        if trim(memd_artloc.fieldbyname('DIVERS').asstring) <> '' then
        begin
          text := memd_artloc.fieldbyname('DIVERS').asstring;
          if trim(memd_artloc.fieldbyname('COULEUR').asstring) <> '' then
            text := text + #13 + memd_artloc.fieldbyname('COULEUR').asstring;
        end
        else
        begin
          if trim(memd_artloc.fieldbyname('COULEUR').asstring) <> '' then
            text := memd_artloc.fieldbyname('COULEUR').asstring;
        end;
      end;

      ibc_art.parambyname('ARL_COMENT').asstring := text;

      if memd_artloc.fieldbyname('SES').asstring = 'O' then
        ibc_art.parambyname('ARL_SESSALOMON').asinteger := 1
      else
        ibc_art.parambyname('ARL_SESSALOMON').asinteger := 0;

      ibc_art.parambyname('ARL_DATEACHAT').asSTRING := memd_artloc.fieldbyname('dateachat').asstring;
      ibc_art.parambyname('ARL_PRIXACHAT').asSTRING := memd_artloc.fieldbyname('pxa').asstring;
      ibc_art.parambyname('ARL_PRIXvente').asfloat := 0;
            //IF trim(memd_artloc.fieldbyname('datecession').asstring) <> '' THEN
      ibc_art.parambyname('ARL_DATECESSION').asSTRING := memd_artloc.fieldbyname('datecession').asstring;
            //ELSE
            //    ibc_art.parambyname('ARL_DATECESSION').asSTRING := '';

      ibc_art.parambyname('ARL_PRIXCESSION').asfloat := pxcession_princ;
      ibc_art.parambyname('ARL_SOMMEAMT').asfloat := amt_princ;

      ibc_art.parambyname('ARL_DUREEAMT').asinteger := memd_artloc.fieldbyname('dureeamt').asinteger;
      ibc_art.parambyname('ARL_ARCHIVER').asinteger := 0;
      ibc_art.parambyname('ARL_VIRTUEL').asinteger := memd_artloc.fieldbyname('pseudo').asinteger;
      ibc_art.parambyname('ARL_REFMRK').asSTRING := '';

            //------Les Critères libres 1 & 2 sont transférés dans les classements
      if memd_artloc.fieldbyname('crit1').asstring <> '' then
      begin
        ibq_class.first;
        while not ibq_class.eof do
        begin
          if ibq_class.fieldbyname('icl_nom').asstring <> memd_artloc.fieldbyname('crit1').asstring
            then
            ibq_class.next
          else
            break;
        end;

        if ibq_class.eof then
        begin // --Le critère'existe pas
          ibq_class.insert;
          ibq_class.fieldbyname('icl_nom').asstring := memd_artloc.fieldbyname('crit1').asstring;
          ibq_class.fieldbyname('cit_iclid').asinteger := ibq_class.fieldbyname('icl_id'
            ).asinteger;
          ibq_class.fieldbyname('cit_claid').asinteger := id_crit1;
          ibq_class.post;
        end;
        ibc_art.parambyname('ARL_iclid1').asinteger := ibq_class.fieldbyname('icl_id').asinteger;
      end
      else
        ibc_art.parambyname('ARL_iclid1').asinteger := 0;

            //Idem critère 2
      if memd_artloc.fieldbyname('crit2').asstring <> '' then
      begin
        ibq_class.first;
        while not ibq_class.eof do
        begin
          if ibq_class.fieldbyname('icl_nom').asstring <> memd_artloc.fieldbyname('crit2').asstring
            then
            ibq_class.next
          else
            break;
        end;

        if ibq_class.eof then
        begin // --Le critère'existe pas
          ibq_class.insert;
          ibq_class.fieldbyname('icl_nom').asstring := memd_artloc.fieldbyname('crit2').asstring;
          ibq_class.fieldbyname('cit_iclid').asinteger := ibq_class.fieldbyname('icl_id'
            ).asinteger;
          ibq_class.fieldbyname('cit_claid').asinteger := id_crit2;
          ibq_class.post;
        end;
        ibc_art.parambyname('ARL_iclid2').asinteger := ibq_class.fieldbyname('icl_id').asinteger;
      end
      else
        ibc_art.parambyname('ARL_iclid2').asinteger := 0;

      ibc_art.parambyname('ARL_iclid3').asinteger;
      ibc_art.parambyname('ARL_iclid4').asinteger;
      ibc_art.parambyname('ARL_iclid5').asinteger;

      ibc_art.execute;

            //Si le prix d'achat supplémentaire est > 0
            //il faut créer une sous fiche.
      if memd_artloc.fieldbyname('pxasup').asfloat <> 0 then
      begin
        id_art := dm_main.GenId;
        dm_main.InsertK(id_art, ktb_art, '-101', '-1', '-1');

        ibc_art.parambyname('arl_id').asstring := id_art;
        ibc_art.parambyname('arl_arlid').asstring := id_artprinc;

                //RECHERCHE DU STATUT
        if que_statut.locate('STA_NOM', memd_artLoc.fieldbyname('statut').asstring, []) then
          ibc_art.parambyname('arl_staid').asinteger := que_statut.fieldbyname('STA_ID').asinteger
        else
          ibc_art.parambyname('arl_staid').asinteger := 0;

        Ibc_art.parambyname('ARL_MRKID').asinteger := 0;

        Ibc_art.parambyname('ARL_TGFID').asinteger := 0;
        ibc_art.parambyname('ARL_CALID').asinteger := 0;
        ibc_art.parambyname('ARL_CDVID').asinteger := 0;
        ibc_art.parambyname('ARL_TKEID').asinteger := 0;

        ibc_chrono.close;
        ibc_chrono.open;
        ibc_art.parambyname('ARL_CHRONO').asstring := ibc_chrono.fieldbyname('newnum').asstring;
        ibc_art.parambyname('ARL_NOM').asstring := memd_artloc.fieldbyname('DIVERS').asstring;
        ibc_art.parambyname('ARL_DESCRIPTION').asstring := '';
        ibc_art.parambyname('ARL_NUMSERIE').asstring := '';
        ibc_art.parambyname('ARL_COMENT').asstring := '';
        ibc_art.parambyname('ARL_SESSALOMON').asinteger := 0;
        ibc_art.parambyname('ARL_SESSALOMON').asinteger := 0;

        ibc_art.parambyname('ARL_DATEACHAT').asSTRING := memd_artloc.fieldbyname('dateachat').asstring;
        ibc_art.parambyname('ARL_PRIXACHAT').asSTRING := memd_artloc.fieldbyname('pxasup').asstring;
        ibc_art.parambyname('ARL_PRIXvente').asfloat := 0;
        if trim(memd_artloc.fieldbyname('datecession').asstring) <> '' then
          ibc_art.parambyname('ARL_DATECESSION').asSTRING := memd_artloc.fieldbyname('datecession').asstring;
        ibc_art.parambyname('ARL_DUREEAMT').asinteger := memd_artloc.fieldbyname('dureeamt').asinteger;

        ibc_art.parambyname('ARL_PRIXCESSION').asfloat := pxcession_sup;
        ibc_art.parambyname('ARL_SOMMEAMT').asfloat := amt_sup;

        ibc_art.parambyname('ARL_ARCHIVER').asinteger := 0;
        ibc_art.parambyname('ARL_VIRTUEL').asinteger := 0;
        ibc_art.parambyname('ARL_REFMRK').asSTRING := '';

        ibc_art.parambyname('ARL_iclid1').asinteger := 0;
        ibc_art.parambyname('ARL_iclid2').asinteger := 0;

        ibc_art.parambyname('ARL_iclid3').asinteger;
        ibc_art.parambyname('ARL_iclid4').asinteger;
        ibc_art.parambyname('ARL_iclid5').asinteger;

        ibc_art.execute;

      end;

            //---Mise à jour des codes barre

            //---Code barre PULKA EAN8

      id_cb := dm_main.GenId;
      dm_main.InsertK(id_cb, ktb_cb, '-101', '-1', '-1');

      ibc_cb.parambyname('cbi_id').asstring := id_cb;
      ibc_cb.parambyname('cbi_arfid').asinteger := 0;
      ibc_cb.parambyname('cbi_tgfid').asinteger := 0;
      ibc_cb.parambyname('cbi_couid').asinteger := 0;
      ibc_cb.parambyname('cbi_cb').asstring := MemD_ArtlocCB.asstring;
      ibc_cb.parambyname('cbi_type').asstring := '4';
      ibc_cb.parambyname('cbi_cltid').asinteger := 0;
      ibc_cb.parambyname('cbi_arlid').asstring := id_artprinc;
      ibc_cb.execute;

            //---Code barre bis (code manuel Pulka)
      if trim(memd_artloc.fieldbyname('manuel').asstring) <> '' then
      begin
        id_cb := dm_main.GenId;
        dm_main.InsertK(id_cb, ktb_cb, '-101', '-1', '-1');

        ibc_cb.parambyname('cbi_id').asstring := id_cb;
        ibc_cb.parambyname('cbi_arfid').asinteger := 0;
        ibc_cb.parambyname('cbi_tgfid').asinteger := 0;
        ibc_cb.parambyname('cbi_couid').asinteger := 0;
        ibc_cb.parambyname('cbi_cb').asstring := memd_artloc.fieldbyname('manuel').asstring;
        ibc_cb.parambyname('cbi_type').asstring := '4';
        ibc_cb.parambyname('cbi_cltid').asinteger := 0;
        ibc_cb.parambyname('cbi_arlid').asstring := id_artprinc;
        ibc_cb.execute;

      end;

            //---Code Salomon (1)
      if trim(memd_artloc.fieldbyname('SALO1').asstring) <> '' then
      begin
        id_cb := dm_main.GenId;
        dm_main.InsertK(id_cb, ktb_cb, '-101', '-1', '-1');

        ibc_cb.parambyname('cbi_id').asstring := id_cb;
        ibc_cb.parambyname('cbi_arfid').asinteger := 0;
        ibc_cb.parambyname('cbi_tgfid').asinteger := 0;
        ibc_cb.parambyname('cbi_couid').asinteger := 0;
        ibc_cb.parambyname('cbi_cb').asstring := memd_artloc.fieldbyname('salo1').asstring;
        ibc_cb.parambyname('cbi_type').asstring := '4';
        ibc_cb.parambyname('cbi_cltid').asinteger := 0;
        ibc_cb.parambyname('cbi_arlid').asstring := id_artprinc;
        ibc_cb.execute;
      end;

            //---Code Salomon (2)
      if trim(memd_artloc.fieldbyname('SALO2').asstring) <> '' then
      begin
        id_cb := dm_main.GenId;
        dm_main.InsertK(id_cb, ktb_cb, '-101', '-1', '-1');

        ibc_cb.parambyname('cbi_id').asstring := id_cb;
        ibc_cb.parambyname('cbi_arfid').asinteger := 0;
        ibc_cb.parambyname('cbi_tgfid').asinteger := 0;
        ibc_cb.parambyname('cbi_couid').asinteger := 0;
        ibc_cb.parambyname('cbi_cb').asstring := memd_artloc.fieldbyname('salo2').asstring;
        ibc_cb.parambyname('cbi_type').asstring := '4';
        ibc_cb.parambyname('cbi_cltid').asinteger := 0;
        ibc_cb.parambyname('cbi_arlid').asstring := id_artprinc;
        ibc_cb.execute;
      end;

      memd_artloc.next;

    end;
    Dm_Main.IB_UpDateCache(ibq_class);
    dm_main.commit;

  except
    MessageDlg(memd_artloc.fieldbyname('num').asstring, mtWarning, [], 0);
    raise;
    dm_main.rollback;
  end;

    //---Ouverture...

  corres_four.close;
  import.close;
  que_statut.close;
  que_categloc.close;

  Dm_Main.IB_CancelCache(ibq_class);
  Ibq_class.close;

  screen.Cursor := crdefault;
  Application.ProcessMessages;

end;

procedure tdm_import.ClassLoc;
begin
  screen.cursor := crsqlwait;
  que_class.open;
  que_itemc.open;

  que_class.insert;
  que_class.fieldbyname('cla_nom').asstring := 'Classement 1';
  que_class.fieldbyname('cla_type').asstring := 'LOC';
  que_class.fieldbyname('cla_num').asstring := '1';
  que_class.post;

  que_itemc.insert;
  que_itemc.fieldbyname('cit_iclid').asinteger := 0;
  que_itemc.fieldbyname('cit_claid').asinteger := que_class.fieldbyname('cla_id').asinteger;
  que_itemc.post;

  que_class.insert;
  que_class.fieldbyname('cla_nom').asstring := 'Classement 2';
  que_class.fieldbyname('cla_type').asstring := 'LOC';
  que_class.fieldbyname('cla_num').asstring := '2';
  que_class.post;

  que_itemc.insert;
  que_itemc.fieldbyname('cit_iclid').asinteger := 0;
  que_itemc.fieldbyname('cit_claid').asinteger := que_class.fieldbyname('cla_id').asinteger;
  que_itemc.post;

  que_class.insert;
  que_class.fieldbyname('cla_nom').asstring := 'Classement 3';
  que_class.fieldbyname('cla_type').asstring := 'LOC';
  que_class.fieldbyname('cla_num').asstring := '3';
  que_class.post;

  que_itemc.insert;
  que_itemc.fieldbyname('cit_iclid').asinteger := 0;
  que_itemc.fieldbyname('cit_claid').asinteger := que_class.fieldbyname('cla_id').asinteger;
  que_itemc.post;

  que_class.insert;
  que_class.fieldbyname('cla_nom').asstring := 'Classement 4';
  que_class.fieldbyname('cla_type').asstring := 'LOC';
  que_class.fieldbyname('cla_num').asstring := '4';
  que_class.post;

  que_itemc.insert;
  que_itemc.fieldbyname('cit_iclid').asinteger := 0;
  que_itemc.fieldbyname('cit_claid').asinteger := que_class.fieldbyname('cla_id').asinteger;
  que_itemc.post;

  que_class.insert;
  que_class.fieldbyname('cla_nom').asstring := 'Classement 5';
  que_class.fieldbyname('cla_type').asstring := 'LOC';
  que_class.fieldbyname('cla_num').asstring := '5';
  que_class.post;

  que_itemc.insert;
  que_itemc.fieldbyname('cit_iclid').asinteger := 0;
  que_itemc.fieldbyname('cit_claid').asinteger := que_class.fieldbyname('cla_id').asinteger;
  que_itemc.post;

  que_class.close;
  que_itemc.close;
  screen.cursor := crdefault;
end;

procedure tdm_import.Typecateg;
begin
  screen.cursor := crsqlwait;
  que_typc.open;

  que_typc.insert;
  que_typc.fieldbyname('TCA_nom').asstring := 'Skis';
  que_typc.post;

  que_typc.insert;
  que_typc.fieldbyname('TCA_nom').asstring := 'Chaussures';
  que_typc.post;

  que_typc.insert;
  que_typc.fieldbyname('TCA_nom').asstring := 'Accessoires';
  que_typc.post;

  que_typc.close;
  screen.cursor := crdefault;
end;

procedure tdm_import.NK_THEO;
var ray_theo, ray_gink: array[1..100] of integer;
  fam_theo, fam_Gink: array[1..500] of integer;

  i: integer;
  pathbase: string;
begin
  screen.cursor := crsqlwait;
  for i := 1 to 100 do
  begin
    ray_theo[i] := 0;
    ray_Gink[i] := 0;
  end;

  for i := 1 to 500 do
  begin
    fam_theo[i] := 0;
    fam_Gink[i] := 0;
  end;

  pathbase := uppercase(stdginkoia.iniCtrl.readString('DATABASE', 'PATH', ''));
  i := Pos('GINKOIA.GDB', pathbase);
  pathbase := copy(pathbase, 1, i - 1) + 'NESTOR.GDB';
  theo.databasename := pathbase;
  theo.open;

    //Table des rayons
  theo_ray.open;
  que_ray.open;

  while not theo_ray.eof do
  begin
    que_ray.insert;
    que_ray.fieldbyname('RAP_NOM').asstring := theo_ray.fieldbyname('FAM_NOM').asstring;
    que_ray.fieldbyname('RAP_ordreaff').asinteger := theo_ray.fieldbyname('FAM_ordre').asinteger;
    que_ray.fieldbyname('RAP_theo').asinteger := theo_ray.fieldbyname('FAM_KEY').asinteger;
    que_ray.post;

    for i := 1 to 100 do
    begin
      if ray_theo[i] = 0 then
      begin
        ray_theo[i] := theo_ray.fieldbyname('FAM_KEY').asinteger;
        ray_Gink[i] := que_ray.fieldbyname('RAP_ID').asinteger;
        BREAK;
      end;
    end;
    theo_ray.next;
  end;

    //Table des familles
  theo_fam.open;
  que_fam.open;

  while not theo_fam.eof do
  begin
    que_fam.insert;
    que_fam.fieldbyname('FAP_NOM').asstring := theo_fam.fieldbyname('DES_NOM').asstring;
    que_fam.fieldbyname('FAP_ordreaff').asinteger := theo_fam.fieldbyname('DES_ordre').asinteger;
    que_fam.fieldbyname('fap_theo').asinteger := theo_fam.fieldbyname('DES_KEY').asinteger;

    for i := 1 to 100 do
      if ray_theo[i] = theo_fam.fieldbyname('DES_FAM').asinteger then BREAK;

    que_fam.fieldbyname('FAP_RAPID').asinteger := ray_Gink[i];
    que_fam.post;

    for i := 1 to 500 do
    begin
      if fam_theo[i] = 0 then
      begin
        fam_theo[i] := theo_fam.fieldbyname('DES_KEY').asinteger;
        fam_Gink[i] := que_fam.fieldbyname('FAP_ID').asinteger;
        BREAK;
      end;
    end;
    theo_fam.next;
  end;

    //Table des compositions  ou sous familles
  ibc_tva.open;
  ibc_tctl.open;
  theo_compo.open;
  que_compo.open;
  while not theo_compo.eof do
  begin
    que_compo.insert;
    que_compo.fieldbyname('COM_NOM').asstring := theo_compo.fieldbyname('COM_LIB').asstring;
    que_compo.fieldbyname('COM_ordreaff').asinteger := theo_compo.fieldbyname('COM_ordre').asinteger;
    que_compo.fieldbyname('com_theo').asinteger := theo_compo.fieldbyname('COM_key').asinteger; ;
    que_compo.fieldbyname('com_tvaid').asinteger := ibc_tva.fieldbyname('tva_id').asinteger;
    que_compo.fieldbyname('com_tctid').asinteger := ibc_tctl.fieldbyname('tct_id').asinteger;

    for i := 1 to 500 do
      if fam_theo[i] = theo_compo.fieldbyname('COM_DES').asinteger then BREAK;

    que_compo.fieldbyname('COM_FAPID').asinteger := fam_Gink[i];
    que_compo.post;

    theo_compo.next;
  end;

  que_produit.open;
  ibc_produit.open;
  while not ibc_produit.eof do
  begin
    que_produit.insert;
    que_produit.fieldbyname('prd_nom').asstring := ibc_produit.fieldbyname('produit').asstring;
    que_produit.fieldbyname('prd_description').asstring := ibc_produit.fieldbyname('produit').asstring;
    que_produit.fieldbyname('prd_caution').asfloat := 0;
    que_produit.fieldbyname('prd_comid').asinteger := ibc_produit.fieldbyname('com_id').asinteger;
    que_produit.fieldbyname('prd_magasin').asinteger := 1;
    que_produit.post;
    ibc_produit.next;
  end;

  theo.close;
  ibc_tva.close;
  ibc_tctl.close;
  ibc_produit.close;
  que_produit.close;
  screen.cursor := crdefault;
end;

procedure Tdm_import.Organisme;
var
  id_vil: string;
  nbart, Un_pc: integer;
  vario: variant;
begin

  screen.Cursor := crSQLWait;

  que_orga.open;
  MemD_orga.DelimiterChar := ';';
  MemD_orga.LoadFromTextFile(pathIp + 'Organisme.TXT');

  try
    dm_main.starttransaction;

    //---C'est parti mon quiqui...
    Nbart := 0;
    Memd_orga.first;
    while not memd_orga.eof do
    begin
      if memd_orga.fieldbyname('num').asstring = '%FINI%' then break;
      Inc(Nbart);
      memd_orga.next;
    end;
    Vario := int(NbArt / 100);
    Un_Pc := Vario;
    Nbart := 0;

    memd_orga.first;
    while not memd_orga.eof do
    begin
      if memd_orga.fieldbyname('num').asstring = '%FINI%' then break;

            //Progress Bar
      inc(NbArt);
      if NbArt = Un_Pc then
      begin
        frm_main.PGB_IEC;
        NbArt := 0;
      end;
      Refresh_form;

      que_orga.insert;

      que_orga.fieldbyname('org_nom').asstring := memd_orga.fieldbyname('Lib').asstring;
      que_orga.fieldbyname('org_facturation').asinteger := 0;
      que_orga.fieldbyname('org_type').asinteger := 0;
      que_orga.fieldbyname('org_adrid').asinteger := que_orga.fieldbyname('adr_id').asinteger;

            //--------Residence
      que_resi.open;
      if que_resi.locate('res_nom', memd_orga.fieldbyname('RESI').asstring, []) then
        que_orga.fieldbyname('org_resid').asinteger := que_resi.fieldbyname('res_id').asinteger
      else
        que_orga.fieldbyname('org_resid').asinteger := 0;

            //--------Ville
      ibc_cp.close;
      ibc_cp.parambyname('CP').asstring := memd_orga.fieldbyname('cp').asstring;
      ibc_cp.open;

      ibc_cp.first;
      while not ibc_cp.eof do
      begin
        if (memd_orga.fieldbyname('Ville').asstring = ibc_cp.fieldbyname('Vil_nom').asstring) then
                  //Il existe une commune  qui correspond
          break
        else
          ibc_cp.next;
      end;

      if ibc_cp.eof then
      begin
               //Aucune commune ne correspond, il faut créer cette ville dans GenVille
        id_vil := dm_main.GenId;
        dm_main.preparescript('INSERT into GENVILLE (vil_id,vil_nom,vil_cp,vil_payid)' +
          ' values (:vil_id,:vil_nom,:vil_cp,:vil_payid)');
        dm_main.SetScriptParameterValue('vil_id', id_vil);
        dm_main.SetScriptParameterValue('vil_nom', memd_orga.fieldbyname('Ville').asstring);
        dm_main.SetScriptParameterValue('vil_cp', memd_orga.fieldbyname('CP').asstring);
        dm_main.SetScriptParameterValue('vil_payid', '0');
        dm_main.ExecuteInsertK('GENVILLE', id_vil);
      end
      else
        id_vil := ibc_cp.fieldbyname('Vil_id').asstring;

           //--------Adresse
      que_orga.fieldbyname('adr_ligne').asstring := memd_orga.fieldbyname('AD1').asstring + #10 +
        memd_orga.fieldbyname('AD2').asstring;
      que_orga.fieldbyname('adr_vilid').asstring := id_vil;
      que_orga.fieldbyname('adr_tel').asstring := memd_orga.fieldbyname('TEL').asstring;
      que_orga.fieldbyname('adr_fax').asstring := memd_orga.fieldbyname('FAX').asstring;
      que_orga.post;

      memd_orga.next;
    end;
    Dm_Main.IBOUpDateCache(que_orga);
    dm_main.commit;

  except
    raise;
    dm_main.rollback;
  end;

  que_orga.close;
  MemD_orga.close;
  que_resi.close;
  screen.Cursor := crdefault;
  Application.ProcessMessages;
end;

procedure Tdm_import.INFOLOC;
var
  id_adr, ktb_adr: string;
  nbart, Un_pc: integer;
  vario: variant;
begin
  ibc_ktb.close;
  ibc_ktb.prepare;
  ibc_ktb.parambyname('ktb_name').asstring := 'GENADRESSE';
  ibc_ktb.open;
  ktb_adr := ibc_ktb.fieldbyname('ktb_id').asstring;

  IbC_Adr.Close;
  IbC_Adr.SQL.Clear;
  IbC_Adr.SQL.Add('INSERT into GENADRESSE (ADR_ID,ADR_LIGNE,ADR_VILID,ADR_TEL,ADR_FAX,ADR_GSM,ADR_EMAIL,ADR_COMMENT)' +
    ' values (:adr_id,:adr_ligne,:adr_vilid,:ADR_TEL,:ADR_FAX,:ADR_GSM,:ADR_EMAIL,:ADR_COMMENT)');
  IbC_Adr.Prepare;

  IbC_clt.Close;
  IbC_clt.SQL.Clear;
  IbC_clt.SQL.Add('UPDATE CLTCLIENT SET clt_resid=:clt_resid,clt_staadrid=:clt_staadrid,' +
    'clt_orgid=:clt_orgid' +
    ' where clt_id=:clt_id');
  IbC_clt.Prepare;

  screen.Cursor := crSQLWait;

  MemD_info.DelimiterChar := ';';
  MemD_info.LoadFromTextFile(pathIp + 'flinfo.TXT');

  try
    dm_main.starttransaction;

    //---C'est parti mon quiqui...

    Nbart := 0;
    Memd_info.first;
    while not memd_info.eof do
    begin
      if memd_info.fieldbyname('num').asstring = '%FINI%' then break;
      Inc(Nbart);
      memd_info.next;
    end;
    Vario := int(NbArt / 100);
    Un_Pc := Vario;
    Nbart := 0;

    memd_info.first;
    while not memd_info.eof do
    begin
      if memd_info.fieldbyname('num').asstring = '%FINI%' then break;

            //Progress Bar
      inc(NbArt);
      if NbArt = Un_Pc then
      begin
        frm_main.PGB_IEC;
        NbArt := 0;
      end;
      Refresh_form;

      ibc_cli.close;
      ibc_cli.parambyname('numero').asstring := memd_info.fieldbyname('num').asstring;
      ibc_cli.open;

      if not ibc_cli.eof then
      begin

        ibc_clt.parambyname('clt_id').asinteger := ibc_cli.fieldbyname('clt_id').asinteger;

                //--------Residence
        que_resi.open;
        if que_resi.locate('res_nom', memd_info.fieldbyname('RESI').asstring, []) then
          ibc_clt.parambyname('clt_resid').asinteger := que_resi.fieldbyname('res_id').asinteger
        else
          ibc_clt.parambyname('clt_resid').asinteger := 0;

                //--------Organisme
        que_orga.open;
        if que_orga.locate('org_nom', memd_info.fieldbyname('ORGA').asstring, []) then
          ibc_clt.parambyname('clt_orgid').asinteger := que_orga.fieldbyname('org_id').asinteger
        else
          ibc_clt.parambyname('clt_orgid').asinteger := 0;

                //Adresse station
        id_adr := dm_main.GenId;
        dm_main.InsertK(id_adr, ktb_adr, '-101', '-1', '-1');

        ibc_adr.parambyname('adr_id').asstring := id_adr;
        if (trim(memd_info.fieldbyname('AD1').asstring) = '') and
          (trim(memd_info.fieldbyname('AD2').asstring) = '') then
          ibc_adr.parambyname('adr_ligne').asstring := ''
        else
          ibc_adr.parambyname('adr_ligne').asstring := memd_info.fieldbyname('AD1').asstring + #10 +
            memd_info.fieldbyname('AD2').asstring;

        ibc_adr.parambyname('adr_vilid').asinteger := 0;
        ibc_adr.parambyname('adr_tel').asstring := '';
        ibc_adr.parambyname('adr_fax').asstring := '';
        ibc_adr.parambyname('adr_gsm').asstring := '';
        ibc_adr.parambyname('adr_email').asstring := '';
        ibc_adr.parambyname('adr_comment').asstring := '';
        ibc_adr.Execute;

        ibc_clt.parambyname('clt_staadrid').asstring := id_adr;
        ibc_clt.Execute;

      end;
      memd_info.next;
    end;
        //Dm_Main.IBOUpDateCache(que_client);
    dm_main.commit;

  except
    raise;
    dm_main.rollback;
  end;

  ibc_clt.close;
  ibc_cli.close;
  MemD_info.close;
  que_resi.close;
  que_orga.close;
  screen.Cursor := crdefault;
  Application.ProcessMessages;
end;

procedure Tdm_import.CodePostaux(pays: integer);
var
  id_adr, ktb_adr: string;
  nbart, Un_pc: integer;
  vario: variant;
  idfrance, idsuisse, idpays: string;
begin
  ibc_ktb.close;
  ibc_ktb.prepare;
  ibc_ktb.parambyname('ktb_name').asstring := 'GENVILLE';
  ibc_ktb.open;
  ktb_adr := ibc_ktb.fieldbyname('ktb_id').asstring;

  IbC_Adr.Close;
  IbC_Adr.SQL.Clear;
  IbC_Adr.SQL.Add('INSERT into GENVILLE (VIL_ID,VIL_NOM,VIL_CP,VIL_PAYID)' +
    ' values (:VIL_ID,:VIL_NOM,:VIL_CP,:VIL_PAYID)');
  IbC_Adr.Prepare;

  MemD_CP.DelimiterChar := ';';

  case pays of
    1: begin

        idfrance := dm_main.GenId;
        dm_main.preparescript('INSERT into GENPAYS (pay_id,pay_nom) values (:pay_id,:pay_nom)'
          );
        dm_main.SetScriptParameterValue('pay_id', idfrance);
        dm_main.SetScriptParameterValue('pay_nom', 'FRANCE');
        dm_main.ExecuteInsertK('GENPAYS', idfrance);
        idpays := idfrance;

        MemD_CP.LoadFromTextFile('c:\codepostal.csv');

      end;
    2: begin
        idsuisse := dm_main.GenId;
        dm_main.preparescript('INSERT into GENPAYS (pay_id,pay_nom) values (:pay_id,:pay_nom)'
          );
        dm_main.SetScriptParameterValue('pay_id', idsuisse);
        dm_main.SetScriptParameterValue('pay_nom', 'SUISSE');
        dm_main.ExecuteInsertK('GENPAYS', idsuisse);
        idpays := idsuisse;
        MemD_CP.LoadFromTextFile('c:\codepostal-suisse.csv');

      end;
  end;
  screen.Cursor := crSQLWait;

  try
    dm_main.starttransaction;

    //---C'est parti mon quiqui...

    Nbart := 0;
    Memd_CP.first;
    while not memd_CP.eof do
    begin
      if MemD_CPcodepostal.asstring = '%FINI%' then break;
      Inc(Nbart);
      memd_CP.next;
    end;
    Vario := int(NbArt / 100);
    Un_Pc := Vario;
    Nbart := 0;

    memd_CP.first;
    while not memd_cp.eof do
    begin
      if MemD_CPcodepostal.asstring = '%FINI%' then break;

            //Progress Bar
      inc(NbArt);
      if NbArt = Un_Pc then
      begin
        frm_main.PGB_IEC;
        NbArt := 0;
      end;
      Refresh_form;

                //Adresse station
      id_adr := dm_main.GenId;
      dm_main.InsertK(id_adr, ktb_adr, '-101', '-1', '-1');
      ibc_adr.parambyname('vil_id').asstring := id_adr;
      ibc_adr.parambyname('vil_nom').asstring := uppercase(MemD_CPville.asstring);
      ibc_adr.parambyname('vil_cp').asstring := uppercase(MemD_CPcodepostal.asstring);
      ibc_adr.parambyname('vil_payid').asstring := idpays;
      ibc_adr.Execute;

      memd_cp.next;
    end;
        //Dm_Main.IBOUpDateCache(que_client);
    dm_main.commit;

  except
    raise;
    dm_main.rollback;
  end;

  ibc_adr.close;
  MemD_cp.close;
  screen.Cursor := crdefault;
  Application.ProcessMessages;
end;

procedure Tdm_import.HistoLoc;
var
  ktb_TK, id_tk: string;
  ktb_loc, id_loc: string;
  ktb_loa, id_loa: string;
  nbart, Un_pc, cpt: integer;
  vario: variant;
  clt, dat: string;
begin
  clt := '';
  dat := '';

  ibc_ktb.close;
  ibc_ktb.parambyname('ktb_name').asstring := 'CSHTICKET';
  ibc_ktb.open;
  ktb_TK := ibc_ktb.fieldbyname('ktb_id').asstring;

  ibc_ktb.close;
  ibc_ktb.parambyname('ktb_name').asstring := 'LOCBONLOCATION';
  ibc_ktb.open;
  ktb_loc := ibc_ktb.fieldbyname('ktb_id').asstring;

  ibc_ktb.close;
  ibc_ktb.parambyname('ktb_name').asstring := 'LOCBONLOCATIONLIGNE';
  ibc_ktb.open;
  ktb_loa := ibc_ktb.fieldbyname('ktb_id').asstring;

  IbC_bl.Close;
  IbC_bl.SQL.Clear;
  IbC_bl.SQL.Add('insert into CSHTICKET (TKE_ID,TKE_SESID,TKE_CLTID,TKE_USRID,TKE_NUMERO,' +
    'TKE_DATE,TKE_DETAXE,TKE_CAISSIER,TKE_NUM,TKE_ARCHIVE,' +
    'TKE_TOTBRUTA1,TKE_REMA1,TKE_TOTNETA1,TKE_QTEA1,' +
    'TKE_TOTBRUTA2,TKE_REMA2,TKE_TOTNETA2,TKE_QTEA2,' +
    'TKE_TOTBRUTA3,TKE_REMA3,TKE_TOTNETA3,TKE_QTEA3,' +
    'TKE_TOTBRUTA4,TKE_REMA4,TKE_TOTNETA4,TKE_QTEA4,' +
    'TKE_DIVINT,TKE_DIVFLOAT,TKE_DIVCHAR,' +
    'TKE_CHEFCLTID,TKE_CTEID) ' +
    'values (:TKE_ID,:TKE_SESID,:tke_cltid,0,:TKE_NUMERO,' +
    ':TKE_DATE,0,:TKE_CAISSIER,:TKE_NUM,1,' +
    '0,0,0,0,' +
    '0,0,0,0,' +
    '0,0,0,0,' +
    '0,0,0,0,' +
    '0,0,:TKE_DIVCHAR,' +
    '0,0)');
  Ibc_bl.Prepare;

  IbC_loc.Close;
  IbC_loc.SQL.Clear;
  IbC_loc.SQL.Add('insert into LOCBONLOCATION (LOC_ID,LOC_NUMERO,LOC_DATE,LOC_TYPEDOC,' +
    'LOC_CLTID,LOC_TKEID,LOC_REMISE,LOC_NUM,loc_sortie,loc_retour,loc_sesid,loc_orgcltid)' +
    'values (:LOC_ID,:LOC_NUMERO,:LOC_DATE,:LOC_TYPEDOC,' +
    ':LOC_CLTID,:LOC_TKEID,:LOC_REMISE,:LOC_NUM,0,0,0,0)');
  Ibc_loc.Prepare;

  IbC_loa.Close;
  IbC_loa.SQL.Clear;
  IbC_loa.SQL.Add('insert into LOCBONLOCATIONligne (  LOA_ID ,LOA_LOCID ,LOA_ARLID ,LOA_PRDID ,' +
    'LOA_LOAID ,LOA_CLIENT ,LOA_DEBUT ,LOA_FIN ,LOA_ETAT ,' +
    'LOA_ARTICLESEUL ,LOA_TYPELIGNE ,LOA_ORDREAFF ,LOA_PXBRUT ,LOA_REMISE ,' +
    'LOA_PXNET ,LOA_ASSUR ,LOA_PXNN ,LOA_DJPPRIX , LOA_DJPASSUR ,' +
    'LOA_SORTIEREEL , LOA_REGFIX , LOA_USRID , LOA_FLAGASS , LOA_TVAID  ,' +
    ' LOA_TXTVA,loa_cltid ,loa_topxnn)' +
    'values (  :LOA_ID ,:LOA_LOCID ,:LOA_ARLID ,:LOA_PRDID ,' +
    ':LOA_LOAID ,:LOA_CLIENT ,:LOA_DEBUT ,:LOA_FIN ,:LOA_ETAT ,' +
    ':LOA_ARTICLESEUL ,:LOA_TYPELIGNE ,:LOA_ORDREAFF ,:LOA_PXBRUT ,:LOA_REMISE ,' +
    ':LOA_PXNET ,:LOA_ASSUR ,:LOA_PXNN ,:LOA_DJPPRIX , :LOA_DJPASSUR ,' +
    ':LOA_SORTIEREEL ,:LOA_REGFIX , :LOA_USRID , :LOA_FLAGASS , :LOA_TVAID  ,' +
    ' :LOA_TXTVA,0,0)');
  Ibc_loa.Prepare;

  ibq_session.open;
  ibq_session.insert;
  ibq_session.fieldbyname('SES_POSID').asinteger := postes(1);
  ibq_session.fieldbyname('SES_NUMERO').asstring := '21';
  ibq_session.fieldbyname('SES_DEBUT').asdatetime := IncMois(now, -1);
  ibq_session.fieldbyname('SES_FIN').asdatetime := IncMois(now, -1);
  ibq_session.fieldbyname('SES_CAISOUV').asstring := 'Transfert PULKA';
  ibq_session.fieldbyname('SES_CAISFIN').asstring := 'Transfert PULKA';
  ibq_session.fieldbyname('SES_NBTKT').asinteger := 0;
  ibq_session.fieldbyname('SES_ETAT').asinteger := 2;
  ibq_session.post;

  screen.Cursor := crSQLWait;

  HL.DelimiterChar := ';';
  HL.LoadFromTextFile(pathIp + 'Statloc.TXT');

  ibc_tva.open;

  try
    dm_main.starttransaction;

    //---C'est parti mon quiqui...

    Nbart := 0;
    HL.first;
    while not HL.eof do
    begin
      if HL.fieldbyname('client').asstring = '%FINI%' then break;
      Inc(Nbart);
      HL.next;
    end;
    Vario := int(NbArt / 100);
    Un_Pc := Vario;
    Nbart := 0;

    HL.first;
    while not HL.eof do
    begin
      if HL.fieldbyname('client').asstring = '%FINI%' then break;

            //Progress Bar
      inc(NbArt);
      if NbArt = Un_Pc then
      begin
        frm_main.PGB_IEC;
        NbArt := 0;
      end;
      Refresh_form;

      inc(cpt);
      if cpt = 500 then
      begin
        cpt := 0;
        dm_main.commit;
        dm_main.starttransaction;
      end;

      if clt <> HLclient.asstring then
      begin
        ibc_cli.close;
        Ibc_cli.parambyname('NUMERO').asinteger := HLclient.asinteger;
        ibc_cli.open;
        clt := HLclient.asstring;
        dat := '';
      end;

      if dat <> HLdate.asstring then
      begin //Nouveau ticket & nouvelle entete

        dat := HLdate.asstring;
        id_TK := dm_main.GenId;
        dm_main.InsertK(id_TK, ktb_TK, '-101', '-1', '-1');
        Ibc_bl.parambyname('tke_id').asstring := id_TK;
        Ibc_bl.parambyname('tke_cltid').asinteger := ibc_cli.fieldbyname('clt_id').asinteger;
        Ibc_bl.parambyname('tke_sesid').asinteger := ibq_session.fieldbyname('SES_ID').asinteger;
        Ibc_bl.parambyname('tke_date').AsString := HLdate.asstring;
        Ibc_bl.parambyname('tke_caissier').asstring := '';
        Ibc_bl.parambyname('tke_num').asstring := '';
        Ibc_bl.parambyname('tke_numero').asstring := '';
        ibc_bl.execute;

        id_loc := dm_main.GenId;
        dm_main.InsertK(id_loc, ktb_loc, '-101', '-1', '-1');
        Ibc_loc.parambyname('loc_id').asstring := id_loc;
        Ibc_loc.parambyname('loc_numero').asinteger := 0;
        Ibc_loc.parambyname('loc_date').asstring := HLdate.asstring;
        Ibc_loc.parambyname('loc_typedoc').asinteger := 2;
        Ibc_loc.parambyname('loc_cltid').asinteger := ibc_cli.fieldbyname('clt_id').asinteger;
        Ibc_loc.parambyname('loc_tkeid').asstring := id_tk;
        Ibc_loc.parambyname('loc_remise').asfloat := 0;
        Ibc_loc.parambyname('loc_num').asstring := '';
        Ibc_loc.execute;

      end;

            //Lignes de facture
      id_loa := dm_main.GenId;
      dm_main.InsertK(id_loa, ktb_loa, '-101', '-1', '-1');
      Ibc_loa.parambyname('loa_id').asstring := id_loa;
      Ibc_loa.parambyname('loa_LOCID').asstring := id_LOC;

      ibc_locart.close;
      ibc_locart.parambyname('chrono').asstring := HLarticle.asstring;
      ibc_locart.open;
      Ibc_loa.parambyname('loa_ARLID').asinteger := ibc_locart.fieldbyname('arl_id').asinteger;

      ibc_prd.close;
      ibc_prd.parambyname('categ').asstring := HLcateg.asstring;
      ibc_prd.open;
      Ibc_loa.parambyname('loa_prdID').asinteger := ibc_prd.fieldbyname('prd_id').asinteger;

            //Ibc_loa.parambyname('loa_orgid').asinteger := 0;
      Ibc_loa.parambyname('loa_loaid').asinteger := 0;
      Ibc_loa.parambyname('loa_client').asstring := HLident.asstring;

      Ibc_loa.parambyname('loa_debut').asstring := HLdate.asstring;
      Ibc_loa.parambyname('loa_debut').asdatetime := Ibc_loa.parambyname('loa_debut').asdatetime -
        int(HLnbj.asfloat) + 1.3333; //Loc à 8 H

      if int(HLnbj.asfloat) <> HLnbj.asfloat then
      begin //Il y a une demi journee
        Ibc_loa.parambyname('loa_debut').asdatetime := Ibc_loa.parambyname('loa_debut').asdatetime - 0.75; //La veille à 14 H
      end;

      Ibc_loa.parambyname('loa_fin').asstring := HLdate.asstring;
      Ibc_loa.parambyname('loa_fin').asdatetime := Ibc_loa.parambyname('loa_fin').asdatetime + 0.75; //Retour à18H
      Ibc_loa.parambyname('loa_etat').asinteger := 2;
      Ibc_loa.parambyname('loa_articleseul').asinteger := 0;
      Ibc_loa.parambyname('loa_typeligne').asinteger := 1;
      Ibc_loa.parambyname('loa_ordreaff').asfloat := 0;

      Ibc_loa.parambyname('loa_pxbrut').asstring := HLbrut.asstring;
      Ibc_loa.parambyname('loa_remise').asfloat := 0;
      Ibc_loa.parambyname('loa_pxnet').asstring := HLnet.asstring;
      Ibc_loa.parambyname('loa_assur').asstring := HLassur.asstring;
      Ibc_loa.parambyname('loa_pxnn').asstring := HLnet.asstring;
      Ibc_loa.parambyname('loa_djpprix').asstring := HLnet.asstring;
      Ibc_loa.parambyname('loa_djpassur').asstring := '';
      Ibc_loa.parambyname('loa_SORTIEREEL').asstring := HLdate.asstring;
      Ibc_loa.parambyname('loa_regfix').asinteger := 0;
      Ibc_loa.parambyname('loa_usrid').asinteger := 0;
      if HLassur.asfloat <> 0 then
        Ibc_loa.parambyname('loa_flagass').asinteger := 1
      else
        Ibc_loa.parambyname('loa_flagass').asinteger := 0;

      Ibc_loa.parambyname('loa_tvaid').asinteger := ibc_tva.fieldbyname('tva_id').asinteger;
      Ibc_loa.parambyname('loa_txtva').asfloat := 19.6;

      Ibc_loa.execute;

      HL.next;
    end;
    dm_main.commit;

  except
    raise;
    dm_main.rollback;
  end;
  ibc_tva.close;
  ibq_session.close;
  screen.Cursor := crdefault;
end;

//------------------------------------------------------------------------------
// Gestionnaires d'événements
//------------------------------------------------------------------------------

procedure Tdm_import.DataModuleCreate(Sender: TObject);
var i: integer;
  tmp: string;
begin
  Grd_Que.Open;
  Init_mag := false;
  Init_Poste := false;

//    pathIP := uppercase(stdginkoia.iniCtrl.readString('DATABASE', 'PATH', ''));
//    i := Pos('GINKOIA.', pathip);
//    pathIP := copy(pathip, 1, i - 1) + 'ip_husky\';
  if paramstr(4) = '' then
  begin
    pathIP := uppercase(stdginkoia.iniCtrl.readString('IP', 'CHEMIN', ''));
    tmp := uppercase(stdginkoia.iniCtrl.readString('DATABASE', 'PATH', ''));
  end
  else
  begin
    pathIP := paramstr(4)+ 'ip_husky\';
    tmp := paramstr(4)+'GINKOIA.gdb';
  end;
  i := Pos('GINKOIA.', tmp);
  import.path := copy(tmp, 1, i - 1) + 'import.gdb';

   // MessageDlg(pathIp+'  '+import.path, mtWarning, [], 0);
end;

procedure Tdm_import.DataModuleDestroy(Sender: TObject);
begin
  Grd_Que.Close;
end;

procedure Tdm_import.Que_GTAfterPost(DataSet: TDataSet);
begin
  Dm_Main.IBOUpDateCache(DataSet as TIBOQuery);
end;

procedure Tdm_import.Que_GTBeforeDelete(DataSet: TDataSet);
begin
  if not Dm_Main.CheckAllowDelete((DataSet as TIBODataSet).KeyRelation,
    DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.Que_GTBeforeEdit(DataSet: TDataSet);
begin
  if not Dm_Main.CheckAllowEdit((DataSet as TIBODataSet).KeyRelation,
    DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.Que_GTNewRecord(DataSet: TDataSet);
begin
  if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
    (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
end;

procedure Tdm_import.Que_GTUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
  Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
    (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;

procedure Tdm_import.IbQ_TAILAfterPost(IB_Dataset: TIB_Dataset);
begin
  Dm_Main.IB_UpDateCache(IB_Dataset as TIB_BDataSet);
end;

procedure Tdm_import.IbQ_TAILBeforeDelete(IB_Dataset: TIB_Dataset);
begin
  if not Dm_Main.CheckAllowDelete(IB_Dataset.KeyRelation,
    IB_Dataset.FieldByName(IB_Dataset.KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.IbQ_TAILBeforeEdit(IB_Dataset: TIB_Dataset);
begin
  if not Dm_Main.CheckAllowEdit(IB_Dataset.KeyRelation,
    IB_Dataset.FieldByName(IB_Dataset.KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.IbQ_TAILNewRecord(IB_Dataset: TIB_Dataset);
begin
  if not Dm_Main.IB_MajPkKey((IB_Dataset as TIB_BDataSet),
    IB_Dataset.KeyLinks.IndexNames[0]) then Abort;
end;

procedure Tdm_import.IbQ_TAILUpdateRecord(DataSet: TComponent;
  UpdateKind: TIB_UpdateKind; var UpdateAction: TIB_UpdateAction);
begin
  Dm_Main.IB_UpdateRecord((DataSet as TIB_BDataSet).KeyRelation,
    (DataSet as TIB_BDataSet), UpdateKind, UpdateAction);
end;

procedure Tdm_import.IbQ_FournAfterPost(IB_Dataset: TIB_Dataset);
begin
   // Dm_Main.IB_UpDateCache( IB_Dataset AS TIB_BDataSet );
end;

procedure Tdm_import.IbQ_FournBeforeDelete(IB_Dataset: TIB_Dataset);
begin
  if not Dm_Main.CheckAllowDelete(IB_Dataset.KeyRelation,
    IB_Dataset.FieldByName(IB_Dataset.KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.IbQ_FournBeforeEdit(IB_Dataset: TIB_Dataset);
begin
  if not Dm_Main.CheckAllowEdit(IB_Dataset.KeyRelation,
    IB_Dataset.FieldByName(IB_Dataset.KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.IbQ_FournNewRecord(IB_Dataset: TIB_Dataset);
begin
  if not Dm_Main.IB_MajPkKey(ibq_fourn, 'fou_id') then Abort;
  if not Dm_Main.IB_MajPkKey(ibq_fourn, 'adr_id') then Abort;
  if not Dm_Main.IB_MajPkKey(ibq_fourn, 'fod_id') then Abort;
  if not Dm_Main.IB_MajPkKey(ibq_fourn, 'mrk_id') then Abort;
  if not Dm_Main.IB_MajPkKey(ibq_fourn, 'fmk_id') then Abort;
end;

procedure Tdm_import.IbQ_FournUpdateRecord(DataSet: TComponent;
  UpdateKind: TIB_UpdateKind; var UpdateAction: TIB_UpdateAction);
begin
  Dm_Main.IB_UpdateRecord('ARTFOURN', ibq_fourn, UpdateKind, UpdateAction);
  Dm_Main.IB_UpdateRecord('GENADRESSE', ibq_fourn, UpdateKind, UpdateAction);
  Dm_Main.IB_UpdateRecord('ARTMARQUE', ibq_fourn, UpdateKind, UpdateAction);
  Dm_Main.IB_UpdateRecord('ARTMRKFOURN', ibq_fourn, UpdateKind, UpdateAction);
  Dm_Main.IB_UpdateRecord('ARTFOURNDETAIL', ibq_fourn, UpdateKind, UpdateAction);
end;

procedure Tdm_import.IBOQryCuAfterPost(DataSet: TDataSet);
begin
  Dm_Main.IBOUpDateCache(DataSet as TIBOQuery);
end;

procedure Tdm_import.IBOQryCuBeforeDelete(DataSet: TDataSet);
begin
  if not Dm_Main.CheckAllowDelete((DataSet as TIBODataSet).KeyRelation,
    DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.IBOQryCuBeforeEdit(DataSet: TDataSet);
begin
  if not Dm_Main.CheckAllowEdit((DataSet as TIBODataSet).KeyRelation,
    DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.IBOQryCuNewRecord(DataSet: TDataSet);
begin
  if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
    (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
end;

procedure Tdm_import.IBOQryCuUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
  Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
    (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;

procedure Tdm_import.IbQ_AdrAfterPost(IB_Dataset: TIB_Dataset);
begin
  Dm_Main.IB_UpDateCache(IB_Dataset as TIB_BDataSet);
end;

procedure Tdm_import.IbQ_AdrBeforeDelete(IB_Dataset: TIB_Dataset);
begin
  if not Dm_Main.CheckAllowDelete(IB_Dataset.KeyRelation,
    IB_Dataset.FieldByName(IB_Dataset.KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.IbQ_AdrBeforeEdit(IB_Dataset: TIB_Dataset);
begin
  if not Dm_Main.CheckAllowEdit(IB_Dataset.KeyRelation,
    IB_Dataset.FieldByName(IB_Dataset.KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.IbQ_AdrNewRecord(IB_Dataset: TIB_Dataset);
begin
  if not Dm_Main.IB_MajPkKey((IB_Dataset as TIB_BDataSet),
    IB_Dataset.KeyLinks.IndexNames[0]) then Abort;
end;

procedure Tdm_import.IbQ_AdrUpdateRecord(DataSet: TComponent;
  UpdateKind: TIB_UpdateKind; var UpdateAction: TIB_UpdateAction);
begin
  Dm_Main.IB_UpdateRecord((DataSet as TIB_BDataSet).KeyRelation,
    (DataSet as TIB_BDataSet), UpdateKind, UpdateAction);
end;

procedure Tdm_import.IbQ_RayAfterPost(IB_Dataset: TIB_Dataset);
begin
  Dm_Main.IB_UpDateCache(IB_Dataset as TIB_BDataSet);
end;

procedure Tdm_import.IbQ_RayBeforeDelete(IB_Dataset: TIB_Dataset);
begin
  if not Dm_Main.CheckAllowDelete(IB_Dataset.KeyRelation,
    IB_Dataset.FieldByName(IB_Dataset.KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.IbQ_RayBeforeEdit(IB_Dataset: TIB_Dataset);
begin
  if not Dm_Main.CheckAllowEdit(IB_Dataset.KeyRelation,
    IB_Dataset.FieldByName(IB_Dataset.KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.IbQ_RayNewRecord(IB_Dataset: TIB_Dataset);
begin
  if not Dm_Main.IB_MajPkKey((IB_Dataset as TIB_BDataSet),
    IB_Dataset.KeyLinks.IndexNames[0]) then Abort;
end;

procedure Tdm_import.IbQ_RayUpdateRecord(DataSet: TComponent;
  UpdateKind: TIB_UpdateKind; var UpdateAction: TIB_UpdateAction);
begin
  Dm_Main.IB_UpdateRecord((DataSet as TIB_BDataSet).KeyRelation,
    (DataSet as TIB_BDataSet), UpdateKind, UpdateAction);
end;

procedure Tdm_import.IbQ_FamAfterPost(IB_Dataset: TIB_Dataset);
begin
  Dm_Main.IB_UpDateCache(IB_Dataset as TIB_BDataSet);
end;

procedure Tdm_import.IbQ_FamBeforeDelete(IB_Dataset: TIB_Dataset);
begin
  if not Dm_Main.CheckAllowDelete(IB_Dataset.KeyRelation,
    IB_Dataset.FieldByName(IB_Dataset.KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.IbQ_FamBeforeEdit(IB_Dataset: TIB_Dataset);
begin
  if not Dm_Main.CheckAllowEdit(IB_Dataset.KeyRelation,
    IB_Dataset.FieldByName(IB_Dataset.KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.IbQ_FamNewRecord(IB_Dataset: TIB_Dataset);
begin
  if not Dm_Main.IB_MajPkKey((IB_Dataset as TIB_BDataSet),
    IB_Dataset.KeyLinks.IndexNames[0]) then Abort;
end;

procedure Tdm_import.IbQ_FamUpdateRecord(DataSet: TComponent;
  UpdateKind: TIB_UpdateKind; var UpdateAction: TIB_UpdateAction);
begin
  Dm_Main.IB_UpdateRecord((DataSet as TIB_BDataSet).KeyRelation,
    (DataSet as TIB_BDataSet), UpdateKind, UpdateAction);
end;

procedure Tdm_import.IbQ_SFAfterPost(IB_Dataset: TIB_Dataset);
begin
  Dm_Main.IB_UpDateCache(IB_Dataset as TIB_BDataSet);
end;

procedure Tdm_import.IbQ_SFBeforeDelete(IB_Dataset: TIB_Dataset);
begin
  if not Dm_Main.CheckAllowDelete(IB_Dataset.KeyRelation,
    IB_Dataset.FieldByName(IB_Dataset.KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.IbQ_SFBeforeEdit(IB_Dataset: TIB_Dataset);
begin
  if not Dm_Main.CheckAllowEdit(IB_Dataset.KeyRelation,
    IB_Dataset.FieldByName(IB_Dataset.KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.IbQ_SFNewRecord(IB_Dataset: TIB_Dataset);
begin
  if not Dm_Main.IB_MajPkKey((IB_Dataset as TIB_BDataSet),
    IB_Dataset.KeyLinks.IndexNames[0]) then Abort;
end;

procedure Tdm_import.IbQ_SFUpdateRecord(DataSet: TComponent;
  UpdateKind: TIB_UpdateKind; var UpdateAction: TIB_UpdateAction);
begin
  Dm_Main.IB_UpdateRecord((DataSet as TIB_BDataSet).KeyRelation,
    (DataSet as TIB_BDataSet), UpdateKind, UpdateAction);
end;

procedure Tdm_import.Que_Class1AfterPost(DataSet: TDataSet);
begin
  Dm_Main.IBOUpDateCache(DataSet as TIBOQuery);
end;

procedure Tdm_import.Que_Class1BeforeDelete(DataSet: TDataSet);
begin
  if not Dm_Main.CheckAllowDelete((DataSet as TIBODataSet).KeyRelation,
    DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.Que_Class1BeforeEdit(DataSet: TDataSet);
begin
  if not Dm_Main.CheckAllowEdit((DataSet as TIBODataSet).KeyRelation,
    DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.Que_Class1NewRecord(DataSet: TDataSet);
begin
  if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
    (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
end;

procedure Tdm_import.Que_Class1UpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
  Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
    (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;

procedure Tdm_import.Que_Class2AfterPost(DataSet: TDataSet);
begin
  Dm_Main.IBOUpDateCache(DataSet as TIBOQuery);
end;

procedure Tdm_import.Que_Class2BeforeDelete(DataSet: TDataSet);
begin
  if not Dm_Main.CheckAllowDelete((DataSet as TIBODataSet).KeyRelation,
    DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.Que_Class2BeforeEdit(DataSet: TDataSet);
begin
  if not Dm_Main.CheckAllowEdit((DataSet as TIBODataSet).KeyRelation,
    DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.Que_Class2NewRecord(DataSet: TDataSet);
begin
  if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
    (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
end;

procedure Tdm_import.Que_Class2UpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
  Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
    (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;

procedure Tdm_import.Que_BrlAfterPost(DataSet: TDataSet);
begin
  //Dm_Main.IBOUpDateCache ( DataSet As TIBOQuery) ;
end;

procedure Tdm_import.Que_BrlBeforeDelete(DataSet: TDataSet);
begin
  if not Dm_Main.CheckAllowDelete((DataSet as TIBODataSet).KeyRelation,
    DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.Que_BrlBeforeEdit(DataSet: TDataSet);
begin
  if not Dm_Main.CheckAllowEdit((DataSet as TIBODataSet).KeyRelation,
    DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.Que_BrlNewRecord(DataSet: TDataSet);
begin
  if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
    (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
end;

procedure Tdm_import.Que_BrlUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
  Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
    (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;

procedure Tdm_import.IbQ_ConsoAfterPost(IB_Dataset: TIB_Dataset);
begin
  Dm_Main.IB_UpDateCache(IB_Dataset as TIB_BDataSet);
end;

procedure Tdm_import.IbQ_ConsoBeforeDelete(IB_Dataset: TIB_Dataset);
begin
  if not Dm_Main.CheckAllowDelete(IB_Dataset.KeyRelation,
    IB_Dataset.FieldByName(IB_Dataset.KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.IbQ_ConsoBeforeEdit(IB_Dataset: TIB_Dataset);
begin
  if not Dm_Main.CheckAllowEdit(IB_Dataset.KeyRelation,
    IB_Dataset.FieldByName(IB_Dataset.KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.IbQ_ConsoNewRecord(IB_Dataset: TIB_Dataset);
begin
  if not Dm_Main.IB_MajPkKey((IB_Dataset as TIB_BDataSet),
    IB_Dataset.KeyLinks.IndexNames[0]) then Abort;
end;

procedure Tdm_import.IbQ_ConsoUpdateRecord(DataSet: TComponent;
  UpdateKind: TIB_UpdateKind; var UpdateAction: TIB_UpdateAction);
begin
  Dm_Main.IB_UpdateRecord((DataSet as TIB_BDataSet).KeyRelation,
    (DataSet as TIB_BDataSet), UpdateKind, UpdateAction);
end;

procedure Tdm_import.IbQ_TvaAfterPost(IB_Dataset: TIB_Dataset);
begin
  Dm_Main.IB_UpDateCache(IB_Dataset as TIB_BDataSet);
end;

procedure Tdm_import.IbQ_TvaBeforeDelete(IB_Dataset: TIB_Dataset);
begin
  if not Dm_Main.CheckAllowDelete(IB_Dataset.KeyRelation,
    IB_Dataset.FieldByName(IB_Dataset.KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.IbQ_TvaBeforeEdit(IB_Dataset: TIB_Dataset);
begin
  if not Dm_Main.CheckAllowEdit(IB_Dataset.KeyRelation,
    IB_Dataset.FieldByName(IB_Dataset.KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.IbQ_TvaNewRecord(IB_Dataset: TIB_Dataset);
begin
  if not Dm_Main.IB_MajPkKey((IB_Dataset as TIB_BDataSet),
    IB_Dataset.KeyLinks.IndexNames[0]) then Abort;
end;

procedure Tdm_import.IbQ_TvaUpdateRecord(DataSet: TComponent;
  UpdateKind: TIB_UpdateKind; var UpdateAction: TIB_UpdateAction);
begin
  Dm_Main.IB_UpdateRecord((DataSet as TIB_BDataSet).KeyRelation,
    (DataSet as TIB_BDataSet), UpdateKind, UpdateAction);
end;

procedure Tdm_import.IbQ_ClassAfterPost(IB_Dataset: TIB_Dataset);
begin
 // Dm_Main.IB_UpDateCache ( IB_Dataset As TIB_BDataSet ) ;
end;

procedure Tdm_import.IbQ_ClassBeforeDelete(IB_Dataset: TIB_Dataset);
begin
  if not Dm_Main.CheckAllowDelete(IB_Dataset.KeyRelation,
    IB_Dataset.FieldByName(IB_Dataset.KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.IbQ_ClassBeforeEdit(IB_Dataset: TIB_Dataset);
begin
  if not Dm_Main.CheckAllowEdit(IB_Dataset.KeyRelation,
    IB_Dataset.FieldByName(IB_Dataset.KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.IbQ_ClassNewRecord(IB_Dataset: TIB_Dataset);
begin
  if not Dm_Main.IB_MajPkKey(ibq_class, 'cit_id') then Abort;
  if not Dm_Main.IB_MajPkKey(ibq_class, 'icl_id') then Abort;
  ibq_class.fieldbyname('CLA_ID').asinteger := 0;
end;

procedure Tdm_import.IbQ_ClassUpdateRecord(DataSet: TComponent;
  UpdateKind: TIB_UpdateKind; var UpdateAction: TIB_UpdateAction);
begin
  Dm_Main.IB_UpdateRecord('ARTITEMC', ibq_class, UpdateKind, UpdateAction);
  Dm_Main.IB_UpdateRecord('ARTCLAITEM', ibq_class, UpdateKind, UpdateAction);
  if ibq_class.fieldbyname('CLA_ID').asinteger <> 0 then
    Dm_Main.IB_UpdateRecord('ARTCLASSEMENT', ibq_class, UpdateKind, UpdateAction);
end;

procedure Tdm_import.IbQ_MagBeforeDelete(IB_Dataset: TIB_Dataset);
begin
  if not Dm_Main.CheckAllowDelete(IB_Dataset.KeyRelation,
    IB_Dataset.FieldByName(IB_Dataset.KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.IbQ_MagBeforeEdit(IB_Dataset: TIB_Dataset);
begin
  if not Dm_Main.CheckAllowEdit(IB_Dataset.KeyRelation,
    IB_Dataset.FieldByName(IB_Dataset.KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.IbQ_MagNewRecord(IB_Dataset: TIB_Dataset);
begin
  if not Dm_Main.IB_MajPkKey(ibq_mag, 'mag_id') then Abort;
  if not Dm_Main.IB_MajPkKey(ibq_mag, 'adr_id') then Abort;
end;

procedure Tdm_import.IbQ_MagUpdateRecord(DataSet: TComponent;
  UpdateKind: TIB_UpdateKind; var UpdateAction: TIB_UpdateAction);
begin
  Dm_Main.IB_UpdateRecord('GENMAGASIN', ibq_mag, UpdateKind, UpdateAction);
  Dm_Main.IB_UpdateRecord('GENADRESSE', ibq_mag, UpdateKind, UpdateAction);
end;

procedure Tdm_import.IbQ_CdeBeforeDelete(IB_Dataset: TIB_Dataset);
begin
  if not Dm_Main.CheckAllowDelete(IB_Dataset.KeyRelation,
    IB_Dataset.FieldByName(IB_Dataset.KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.IbQ_CdeBeforeEdit(IB_Dataset: TIB_Dataset);
begin
  if not Dm_Main.CheckAllowEdit(IB_Dataset.KeyRelation,
    IB_Dataset.FieldByName(IB_Dataset.KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.IbQ_CdeNewRecord(IB_Dataset: TIB_Dataset);
begin
  if not Dm_Main.IB_MajPkKey((IB_Dataset as TIB_BDataSet),
    IB_Dataset.KeyLinks.IndexNames[0]) then Abort;
end;

procedure Tdm_import.IbQ_CdeUpdateRecord(DataSet: TComponent;
  UpdateKind: TIB_UpdateKind; var UpdateAction: TIB_UpdateAction);
begin
  Dm_Main.IB_UpdateRecord('COMBCDE', ibq_cde, UpdateKind, UpdateAction);
end;

procedure Tdm_import.Que_GroupeCltAfterPost(DataSet: TDataSet);
begin
  Dm_Main.IBOUpDateCache(DataSet as TIBOQuery);
end;

procedure Tdm_import.Que_GroupeCltBeforeDelete(DataSet: TDataSet);
begin
  if not Dm_Main.CheckAllowDelete((DataSet as TIBODataSet).KeyRelation,
    DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.Que_GroupeCltBeforeEdit(DataSet: TDataSet);
begin
  if not Dm_Main.CheckAllowEdit((DataSet as TIBODataSet).KeyRelation,
    DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.Que_GroupeCltNewRecord(DataSet: TDataSet);
begin
  if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
    (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
end;

procedure Tdm_import.Que_GroupeCltUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
  Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
    (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;

procedure Tdm_import.IbQ_GrpCltAfterPost(IB_Dataset: TIB_Dataset);
begin
  Dm_Main.IB_UpDateCache(IB_Dataset as TIB_BDataSet);
end;

procedure Tdm_import.IbQ_GrpCltBeforeDelete(IB_Dataset: TIB_Dataset);
begin
  if not Dm_Main.CheckAllowDelete(IB_Dataset.KeyRelation,
    IB_Dataset.FieldByName(IB_Dataset.KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.IbQ_GrpCltBeforeEdit(IB_Dataset: TIB_Dataset);
begin
  if not Dm_Main.CheckAllowEdit(IB_Dataset.KeyRelation,
    IB_Dataset.FieldByName(IB_Dataset.KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.IbQ_GrpCltNewRecord(IB_Dataset: TIB_Dataset);
begin
  if not Dm_Main.IB_MajPkKey((IB_Dataset as TIB_BDataSet),
    IB_Dataset.KeyLinks.IndexNames[0]) then Abort;
end;

procedure Tdm_import.IbQ_GrpCltUpdateRecord(DataSet: TComponent;
  UpdateKind: TIB_UpdateKind; var UpdateAction: TIB_UpdateAction);
begin
  Dm_Main.IB_UpdateRecord((DataSet as TIB_BDataSet).KeyRelation,
    (DataSet as TIB_BDataSet), UpdateKind, UpdateAction);
end;

procedure Tdm_import.IbQ_MagCltAfterPost(IB_Dataset: TIB_Dataset);
begin
//  Dm_Main.IB_UpDateCache ( IB_Dataset As TIB_BDataSet ) ;
end;

procedure Tdm_import.IbQ_MagCltBeforeDelete(IB_Dataset: TIB_Dataset);
begin
  if not Dm_Main.CheckAllowDelete(IB_Dataset.KeyRelation,
    IB_Dataset.FieldByName(IB_Dataset.KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.IbQ_MagCltBeforeEdit(IB_Dataset: TIB_Dataset);
begin
  if not Dm_Main.CheckAllowEdit(IB_Dataset.KeyRelation,
    IB_Dataset.FieldByName(IB_Dataset.KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.IbQ_MagCltNewRecord(IB_Dataset: TIB_Dataset);
begin
  if not Dm_Main.IB_MajPkKey((IB_Dataset as TIB_BDataSet),
    IB_Dataset.KeyLinks.IndexNames[0]) then Abort;
end;

procedure Tdm_import.IbQ_MagCltUpdateRecord(DataSet: TComponent;
  UpdateKind: TIB_UpdateKind; var UpdateAction: TIB_UpdateAction);
begin
  Dm_Main.IB_UpdateRecord((DataSet as TIB_BDataSet).KeyRelation,
    (DataSet as TIB_BDataSet), UpdateKind, UpdateAction);
end;

procedure Tdm_import.IbQ_CivAfterPost(IB_Dataset: TIB_Dataset);
begin
 // Dm_Main.IB_UpDateCache ( IB_Dataset As TIB_BDataSet ) ;
end;

procedure Tdm_import.IbQ_CivBeforeDelete(IB_Dataset: TIB_Dataset);
begin
  if not Dm_Main.CheckAllowDelete(IB_Dataset.KeyRelation,
    IB_Dataset.FieldByName(IB_Dataset.KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.IbQ_CivBeforeEdit(IB_Dataset: TIB_Dataset);
begin
  if not Dm_Main.CheckAllowEdit(IB_Dataset.KeyRelation,
    IB_Dataset.FieldByName(IB_Dataset.KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.IbQ_CivNewRecord(IB_Dataset: TIB_Dataset);
begin
  if not Dm_Main.IB_MajPkKey((IB_Dataset as TIB_BDataSet),
    IB_Dataset.KeyLinks.IndexNames[0]) then Abort;
end;

procedure Tdm_import.IbQ_CivUpdateRecord(DataSet: TComponent;
  UpdateKind: TIB_UpdateKind; var UpdateAction: TIB_UpdateAction);
begin
  Dm_Main.IB_UpdateRecord((DataSet as TIB_BDataSet).KeyRelation,
    (DataSet as TIB_BDataSet), UpdateKind, UpdateAction);
end;

procedure Tdm_import.Que_CategAfterPost(DataSet: TDataSet);
begin
  Dm_Main.IBOUpDateCache(DataSet as TIBOQuery);
end;

procedure Tdm_import.Que_CategBeforeDelete(DataSet: TDataSet);
begin
  if not Dm_Main.CheckAllowDelete((DataSet as TIBODataSet).KeyRelation,
    DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.Que_CategBeforeEdit(DataSet: TDataSet);
begin
  if not Dm_Main.CheckAllowEdit((DataSet as TIBODataSet).KeyRelation,
    DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.Que_CategNewRecord(DataSet: TDataSet);
begin
  if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
    (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
end;

procedure Tdm_import.Que_CategUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
  Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
    (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;

procedure Tdm_import.IbQ_UniversAfterPost(IB_Dataset: TIB_Dataset);
begin
  Dm_Main.IB_UpDateCache(IB_Dataset as TIB_BDataSet);
end;

procedure Tdm_import.IbQ_UniversBeforeDelete(IB_Dataset: TIB_Dataset);
begin
  if not Dm_Main.CheckAllowDelete(IB_Dataset.KeyRelation,
    IB_Dataset.FieldByName(IB_Dataset.KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.IbQ_UniversBeforeEdit(IB_Dataset: TIB_Dataset);
begin
  if not Dm_Main.CheckAllowEdit(IB_Dataset.KeyRelation,
    IB_Dataset.FieldByName(IB_Dataset.KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.IbQ_UniversNewRecord(IB_Dataset: TIB_Dataset);
begin
  if not Dm_Main.IB_MajPkKey((IB_Dataset as TIB_BDataSet),
    IB_Dataset.KeyLinks.IndexNames[0]) then Abort;
end;

procedure Tdm_import.IbQ_UniversUpdateRecord(DataSet: TComponent;
  UpdateKind: TIB_UpdateKind; var UpdateAction: TIB_UpdateAction);
begin
  Dm_Main.IB_UpdateRecord((DataSet as TIB_BDataSet).KeyRelation,
    (DataSet as TIB_BDataSet), UpdateKind, UpdateAction);
end;

procedure Tdm_import.Que_NkGtsAfterPost(DataSet: TDataSet);
begin
  Dm_Main.IBOUpDateCache(DataSet as TIBOQuery);
end;

procedure Tdm_import.Que_NkGtsBeforeDelete(DataSet: TDataSet);
begin
  if not Dm_Main.CheckAllowDelete((DataSet as TIBODataSet).KeyRelation,
    DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.Que_NkGtsBeforeEdit(DataSet: TDataSet);
begin
  if not Dm_Main.CheckAllowEdit((DataSet as TIBODataSet).KeyRelation,
    DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.Que_NkGtsNewRecord(DataSet: TDataSet);
begin
  if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
    (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
end;

procedure Tdm_import.Que_NkGtsUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
  Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
    (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;

procedure Tdm_import.IbQ_NkGtsAfterPost(IB_Dataset: TIB_Dataset);
begin
  Dm_Main.IB_UpDateCache(IB_Dataset as TIB_BDataSet);
end;

procedure Tdm_import.IbQ_NkGtsBeforeDelete(IB_Dataset: TIB_Dataset);
begin
  if not Dm_Main.CheckAllowDelete(IB_Dataset.KeyRelation,
    IB_Dataset.FieldByName(IB_Dataset.KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.IbQ_NkGtsBeforeEdit(IB_Dataset: TIB_Dataset);
begin
  if not Dm_Main.CheckAllowEdit(IB_Dataset.KeyRelation,
    IB_Dataset.FieldByName(IB_Dataset.KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.IbQ_NkGtsNewRecord(IB_Dataset: TIB_Dataset);
begin
  if not Dm_Main.IB_MajPkKey((IB_Dataset as TIB_BDataSet),
    IB_Dataset.KeyLinks.IndexNames[0]) then Abort;
end;

procedure Tdm_import.IbQ_NkGtsUpdateRecord(DataSet: TComponent;
  UpdateKind: TIB_UpdateKind; var UpdateAction: TIB_UpdateAction);
begin
  Dm_Main.IB_UpdateRecord((DataSet as TIB_BDataSet).KeyRelation,
    (DataSet as TIB_BDataSet), UpdateKind, UpdateAction);
end;

procedure Tdm_import.Que_PosteAfterPost(DataSet: TDataSet);
begin
//    Dm_Main.IBOUpDateCache ( DataSet AS TIBOQuery ) ;
end;

procedure Tdm_import.Que_PosteBeforeDelete(DataSet: TDataSet);
begin
  if not Dm_Main.CheckAllowDelete((DataSet as TIBODataSet).KeyRelation,
    DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.Que_PosteBeforeEdit(DataSet: TDataSet);
begin
  if not Dm_Main.CheckAllowEdit((DataSet as TIBODataSet).KeyRelation,
    DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.Que_PosteNewRecord(DataSet: TDataSet);
begin
  if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
    (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
end;

procedure Tdm_import.Que_PosteUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
  Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
    (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;

procedure Tdm_import.IbQ_SessionAfterPost(IB_Dataset: TIB_Dataset);
begin
  Dm_Main.IB_UpDateCache(IB_Dataset as TIB_BDataSet);
end;

procedure Tdm_import.IbQ_SessionBeforeDelete(IB_Dataset: TIB_Dataset);
begin
  if not Dm_Main.CheckAllowDelete(IB_Dataset.KeyRelation,
    IB_Dataset.FieldByName(IB_Dataset.KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.IbQ_SessionBeforeEdit(IB_Dataset: TIB_Dataset);
begin
  if not Dm_Main.CheckAllowEdit(IB_Dataset.KeyRelation,
    IB_Dataset.FieldByName(IB_Dataset.KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.IbQ_SessionNewRecord(IB_Dataset: TIB_Dataset);
begin
  if not Dm_Main.IB_MajPkKey((IB_Dataset as TIB_BDataSet),
    IB_Dataset.KeyLinks.IndexNames[0]) then Abort;
end;

procedure Tdm_import.IbQ_SessionUpdateRecord(DataSet: TComponent;
  UpdateKind: TIB_UpdateKind; var UpdateAction: TIB_UpdateAction);
begin
  Dm_Main.IB_UpdateRecord((DataSet as TIB_BDataSet).KeyRelation,
    (DataSet as TIB_BDataSet), UpdateKind, UpdateAction);
end;

procedure Tdm_import.Que_TarVenteAfterPost(DataSet: TDataSet);
begin
  Dm_Main.IBOUpDateCache(DataSet as TIBOQuery);
end;

procedure Tdm_import.Que_TarVenteBeforeDelete(DataSet: TDataSet);
begin
  if not Dm_Main.CheckAllowDelete((DataSet as TIBODataSet).KeyRelation,
    DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.Que_TarVenteBeforeEdit(DataSet: TDataSet);
begin
  if not Dm_Main.CheckAllowEdit((DataSet as TIBODataSet).KeyRelation,
    DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.Que_TarVenteNewRecord(DataSet: TDataSet);
begin
  if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
    (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
end;

procedure Tdm_import.Que_TarVenteUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
  Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
    (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;

procedure Tdm_import.Que_TarPrixAfterPost(DataSet: TDataSet);
begin
  Dm_Main.IBOUpDateCache(DataSet as TIBOQuery);
end;

procedure Tdm_import.Que_TarPrixBeforeDelete(DataSet: TDataSet);
begin
  if not Dm_Main.CheckAllowDelete((DataSet as TIBODataSet).KeyRelation,
    DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.Que_TarPrixBeforeEdit(DataSet: TDataSet);
begin
  if not Dm_Main.CheckAllowEdit((DataSet as TIBODataSet).KeyRelation,
    DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.Que_TarPrixNewRecord(DataSet: TDataSet);
begin
  if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
    (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
end;

procedure Tdm_import.Que_TarPrixUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
  Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
    (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;

procedure Tdm_import.Que_StatutBeforeDelete(DataSet: TDataSet);
begin
  if not Dm_Main.CheckAllowDelete((DataSet as TIBODataSet).KeyRelation,
    DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.Que_StatutBeforeEdit(DataSet: TDataSet);
begin
  if not Dm_Main.CheckAllowEdit((DataSet as TIBODataSet).KeyRelation,
    DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.Que_StatutNewRecord(DataSet: TDataSet);
begin
  if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
    (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
end;

procedure Tdm_import.Que_StatutUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
  Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
    (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;

procedure Tdm_import.Que_ResiBeforeDelete(DataSet: TDataSet);
begin
  if not Dm_Main.CheckAllowDelete((DataSet as TIBODataSet).KeyRelation,
    DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.Que_ResiBeforeEdit(DataSet: TDataSet);
begin
  if not Dm_Main.CheckAllowEdit((DataSet as TIBODataSet).KeyRelation,
    DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.Que_ResiNewRecord(DataSet: TDataSet);
begin
  if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
    (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
end;

procedure Tdm_import.Que_ResiUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
  Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
    (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;

procedure Tdm_import.Que_CategLocAfterPost(DataSet: TDataSet);
begin
  Dm_Main.IBOUpDateCache(DataSet as TIBOQuery);
end;

procedure Tdm_import.Que_CategLocBeforeDelete(DataSet: TDataSet);
begin
  if not Dm_Main.CheckAllowDelete((DataSet as TIBODataSet).KeyRelation,
    DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.Que_CategLocBeforeEdit(DataSet: TDataSet);
begin
  if not Dm_Main.CheckAllowEdit((DataSet as TIBODataSet).KeyRelation,
    DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.Que_CategLocNewRecord(DataSet: TDataSet);
begin
  if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
    (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
end;

procedure Tdm_import.Que_CategLocUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
  Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
    (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;

procedure Tdm_import.Que_ClassAfterPost(DataSet: TDataSet);
begin
  Dm_Main.IBOUpDateCache(DataSet as TIBOQuery);
end;

procedure Tdm_import.Que_ClassBeforeDelete(DataSet: TDataSet);
begin
  if not Dm_Main.CheckAllowDelete((DataSet as TIBODataSet).KeyRelation,
    DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.Que_ClassBeforeEdit(DataSet: TDataSet);
begin
  if not Dm_Main.CheckAllowEdit((DataSet as TIBODataSet).KeyRelation,
    DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.Que_ClassNewRecord(DataSet: TDataSet);
begin
  if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
    (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
end;

procedure Tdm_import.Que_ClassUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
  Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
    (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;

procedure Tdm_import.Que_TypcAfterPost(DataSet: TDataSet);
begin
  Dm_Main.IBOUpDateCache(DataSet as TIBOQuery);
end;

procedure Tdm_import.Que_TypcBeforeDelete(DataSet: TDataSet);
begin
  if not Dm_Main.CheckAllowDelete((DataSet as TIBODataSet).KeyRelation,
    DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.Que_TypcBeforeEdit(DataSet: TDataSet);
begin
  if not Dm_Main.CheckAllowEdit((DataSet as TIBODataSet).KeyRelation,
    DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.Que_TypcNewRecord(DataSet: TDataSet);
begin
  if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
    (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
end;

procedure Tdm_import.Que_TypcUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
  Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
    (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;

procedure Tdm_import.Que_RayAfterPost(DataSet: TDataSet);
begin
  Dm_Main.IBOUpDateCache(DataSet as TIBOQuery);
end;

procedure Tdm_import.Que_RayBeforeDelete(DataSet: TDataSet);
begin
  if not Dm_Main.CheckAllowDelete((DataSet as TIBODataSet).KeyRelation,
    DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.Que_RayBeforeEdit(DataSet: TDataSet);
begin
  if not Dm_Main.CheckAllowEdit((DataSet as TIBODataSet).KeyRelation,
    DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.Que_RayNewRecord(DataSet: TDataSet);
begin
  if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
    (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
end;

procedure Tdm_import.Que_RayUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
  Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
    (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;

procedure Tdm_import.Que_FamAfterPost(DataSet: TDataSet);
begin
  Dm_Main.IBOUpDateCache(DataSet as TIBOQuery);
end;

procedure Tdm_import.Que_FamBeforeDelete(DataSet: TDataSet);
begin
  if not Dm_Main.CheckAllowDelete((DataSet as TIBODataSet).KeyRelation,
    DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.Que_FamBeforeEdit(DataSet: TDataSet);
begin
  if not Dm_Main.CheckAllowEdit((DataSet as TIBODataSet).KeyRelation,
    DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.Que_FamNewRecord(DataSet: TDataSet);
begin
  if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
    (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
end;

procedure Tdm_import.Que_FamUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
  Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
    (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;

procedure Tdm_import.Que_CompoAfterPost(DataSet: TDataSet);
begin
  Dm_Main.IBOUpDateCache(DataSet as TIBOQuery);
end;

procedure Tdm_import.Que_CompoBeforeDelete(DataSet: TDataSet);
begin
  if not Dm_Main.CheckAllowDelete((DataSet as TIBODataSet).KeyRelation,
    DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.Que_CompoBeforeEdit(DataSet: TDataSet);
begin
  if not Dm_Main.CheckAllowEdit((DataSet as TIBODataSet).KeyRelation,
    DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.Que_CompoNewRecord(DataSet: TDataSet);
begin
  if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
    (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
end;

procedure Tdm_import.Que_CompoUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
  Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
    (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;

procedure Tdm_import.Que_OrgaAfterPost(DataSet: TDataSet);
begin
//  Dm_Main.IBOUpDateCache ( DataSet As TIBOQuery) ;
end;

procedure Tdm_import.Que_OrgaBeforeDelete(DataSet: TDataSet);
begin
  if not Dm_Main.CheckAllowDelete((DataSet as TIBODataSet).KeyRelation,
    DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.Que_OrgaBeforeEdit(DataSet: TDataSet);
begin
  if not Dm_Main.CheckAllowEdit((DataSet as TIBODataSet).KeyRelation,
    DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.Que_OrgaNewRecord(DataSet: TDataSet);
begin
  if not Dm_Main.IBOMajPkKey(que_orga, 'ORG_ID') then ABORT;
  if not Dm_Main.IBOMajPkKey(que_orga, 'adr_id') then ABORT;
end;

procedure Tdm_import.Que_OrgaUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
  Dm_Main.IBOUpdateRecord('LOCORGANISME', que_orga, UpdateKind, UpdateAction);
  Dm_Main.IBOUpdateRecord('GENADRESSE', que_orga, UpdateKind, UpdateAction);
end;

procedure Tdm_import.Que_ClientAfterPost(DataSet: TDataSet);
begin
//  Dm_Main.IBOUpDateCache ( DataSet As TIBOQuery) ;
end;

procedure Tdm_import.Que_ClientBeforeDelete(DataSet: TDataSet);
begin
  if not Dm_Main.CheckAllowDelete((DataSet as TIBODataSet).KeyRelation,
    DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.Que_ClientBeforeEdit(DataSet: TDataSet);
begin
  if not Dm_Main.CheckAllowEdit((DataSet as TIBODataSet).KeyRelation,
    DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
    True) then Abort;
end;

procedure Tdm_import.Que_ClientNewRecord(DataSet: TDataSet);
begin
  if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
    (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
end;

procedure Tdm_import.Que_ClientUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
  Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
    (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;

procedure Tdm_import.GenerikAfterCancel(DataSet: TDataSet);
begin
  Dm_Main.IBOCancelCache(DataSet as TIBOQuery);
end;

procedure Tdm_import.GenerikAfterPost(DataSet: TDataSet);
begin
  Dm_Main.IBOUpDateCache(DataSet as TIBOQuery);
end;

procedure Tdm_import.GenerikBeforeDelete(DataSet: TDataSet);
begin
{ A achever ...
    IF StdGinkoia.ID_EXISTE('KEYID', que_QueryKEY_ID.asInteger, []) THEN
    BEGIN
        StdGinKoia.DelayMess(ErrNoDeleteIntChk, 3);
        ABORT;
    END;
}
end;

procedure Tdm_import.GenerikNewRecord(DataSet: TDataSet);
begin
  if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
    (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
end;

procedure Tdm_import.GenerikUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
  Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
    (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;

procedure Tdm_import.GenParam;
begin
  que_param.open;

    //Creation des infos dans genparam
  que_param.insert;
  Que_ParamPRM_CODE.asinteger := 90;
  Que_ParamPRM_INTEGER.asinteger := 0;
  Que_ParamPRM_FLOAT.asfloat := 0;
  Que_ParamPRM_STRING.asstring := 'LOCATION';
  Que_ParamPRM_TYPE.asinteger := 9;
  Que_ParamPRM_MAGID.asinteger := 9187;
  Que_ParamPRM_INFO.asstring := 'LOCATION';
  Que_ParamPRM_POS.asinteger := 0;
  que_param.post;

  que_param.insert;
  Que_ParamPRM_CODE.asinteger := 31;
  Que_ParamPRM_INTEGER.asinteger := 3;
  Que_ParamPRM_FLOAT.asfloat := 0;
  Que_ParamPRM_STRING.asstring := '';
  Que_ParamPRM_TYPE.asinteger := 3;
  Que_ParamPRM_MAGID.asinteger := 9187;
  Que_ParamPRM_INFO.asstring := 'NIVEAU VERSION UTILISATEUR';
  Que_ParamPRM_POS.asinteger := 0;
  que_param.post;

  Dm_Main.IBOUpDateCache(que_param);
  que_param.close;
end;

function tdm_import.TestInitial: boolean;
var F: TSearchRec;

begin
  result := false;
  try
    frm_main.Ed_IEC.text := 'MAGASIN.TXT';
    MemD_Mag.DelimiterChar := ';';
    MemD_Mag.LoadFromTextFile(pathIp + 'MAGASIN.TXT');
  except
    MessageDlg('MAGASIN.TXT' + #10 + #13 + memd_mag.fieldbyname('num').asstring, mtWarning, [], 0);
    Exit;
  end;

  try
    frm_main.Ed_IEC.text := 'GT.TXT';
    MemD_GT.DelimiterChar := ';';
    MemD_GT.LoadFromTextFile(pathIp + 'GT.TXT');
  except
    MessageDlg('GT.TXT' + #10 + #13 + memd_gt.fieldbyname('num').asstring, mtWarning, [], 0);
    Exit;
  end;

  try
    frm_main.Ed_IEC.text := 'FOURN.TXT';
    MemD_fourn.DelimiterChar := ';';
    MemD_fourn.LoadFromTextFile(pathIp + 'Fourn.TXT');
  except
    MessageDlg('Fourn.txt' + #10 + #13 + memd_fourn.fieldbyname('num').asstring, mtWarning, [], 0);
    Exit;
  end;

  try
    frm_main.Ed_IEC.text := 'NK.TXT';
    MemD_Nom.DelimiterChar := ';';
    MemD_Nom.LoadFromTextFile(pathIp + 'NK.TXT');
  except
    MessageDlg('NK.txt' + #10 + #13 + memd_nom.fieldbyname('num').asstring, mtWarning, [], 0);
    Exit;
  end;

  try
    frm_main.Ed_IEC.text := 'ARTICLE.TXT';
    MemD_Art.DelimiterChar := ';';
    MemD_Art.LoadFromTextFile(pathIp + 'ARTICLE.TXT');
  except
    MessageDlg('ARTICLE.TXT' + #10 + #13 + memd_art.fieldbyname('code').asstring, mtWarning, [], 0);
    Exit;
  end;

  try
    frm_main.Ed_IEC.text := 'TARIFS.TXT';
    MemD_tarifs.DelimiterChar := ';';
    MemD_tarifs.LoadFromTextFile(pathIp + 'TARIFS.TXT');
  except
    MessageDlg('TARIFS.TXT' + #10 + #13 + memd_tarifs.fieldbyname('CODE').asstring, mtWarning, [], 0);
    Exit;
  end;

  try
    frm_main.Ed_IEC.text := 'STOCKTOT.TXT';
    MemD_mvt.DelimiterChar := ';';
    MemD_mvt.LoadFromTextFile(pathIp + 'STOCKTOT.TXT');
  except
    MessageDlg('STOCKTOT.TXT' + #10 + #13 + memd_mvt.fieldbyname('code').asstring, mtWarning, [], 0);
    Exit;
  end;

  try
    frm_main.Ed_IEC.text := 'CB.TXT';
    MemD_CB.DelimiterChar := ';';
    MemD_CB.LoadFromTextFile(pathIp + 'CB.TXT');
  except
    MessageDlg('CB.TXT' + #10 + #13 + memd_CB.fieldbyname('ARTICLE').asstring, mtWarning, [], 0);
    Exit;
  end;

  try
    frm_main.Ed_IEC.text := 'COMMANDE.TXT';
    MemD_cde.DelimiterChar := ';';
    MemD_cde.LoadFromTextFile(pathIp + 'COMMANDE.TXT');
  except
    MessageDlg('COMMANDE.TXT' + #10 + #13 + memd_cde.fieldbyname('code').asstring, mtWarning, [], 0);
    Exit;
  end;

  try
    frm_main.Ed_IEC.text := 'CLIENTS.TXT';
    client.DelimiterChar := ';';
    client.LoadFromTextFile(pathIp + 'clients.TXT');
  except
    MessageDlg('CLIENTS.TXT' + #10 + #13 + client.fieldbyname('nom').asstring + #10 + #13 + client.fieldbyname('prenom').asstring, mtWarning, [], 0);
    Exit;
  end;

  try
    frm_main.Ed_IEC.text := 'CPTCLI.TXT';
    MemD_Cpt.DelimiterChar := ';';
    MemD_Cpt.LoadFromTextFile(pathIp + 'cptcli.TXT');
  except
    MessageDlg('CPTCLI.TXT' + #10 + #13 + memd_Cpt.fieldbyname('code').asstring, mtWarning, [], 0);
    Exit;
  end;

  try
    frm_main.Ed_IEC.text := 'FIDELITE.TXT';
    MemD_Fid.DelimiterChar := ';';
    MemD_Fid.LoadFromTextFile(pathIp + 'Fidelite.TXT');
  except
    MessageDlg('FIDELITE.TXT' + #10 + #13 + memd_fid.fieldbyname('code').asstring, mtWarning, [], 0);
    Exit;
  end;

    // Test si location
  if FindFirst(pathIp + 'Statut.TXT', faAnyFile, F) <> 0 then
  begin
    findclose(F);
    result := true;
    EXIT; //Pas de location
  end;

  try
    frm_main.Ed_IEC.text := 'STATUT.TXT';
    MemD_Statut.DelimiterChar := ';';
    MemD_Statut.LoadFromTextFile(pathIp + 'Statut.TXT');
  except
    MessageDlg('STATUT.TXT' + #10 + #13 + memd_statut.fieldbyname('num').asstring, mtWarning, [], 0);
    Exit;
  end;

  try
    frm_main.Ed_IEC.text := 'RESIDENCE.TXT';
    MemD_Resi.DelimiterChar := ';';
    MemD_Resi.LoadFromTextFile(pathIp + 'Residence.TXT');
  except
    MessageDlg('RESIDENCE.TXT' + #10 + #13 + memd_resi.fieldbyname('Num').asstring, mtWarning, [], 0);
    Exit;
  end;

  try
    frm_main.Ed_IEC.text := 'CATEGORIE.TXT';
    MemD_categ.DelimiterChar := ';';
    MemD_categ.LoadFromTextFile(pathIp + 'Categorie.TXT');
  except
    MessageDlg('RESIDENCE.TXT' + #10 + #13 + memd_categ.fieldbyname('Num').asstring, mtWarning, [], 0);
    Exit;
  end;

  try
    frm_main.Ed_IEC.text := 'LOCARTICLE.TXT';
    MemD_ArtLoc.DelimiterChar := ';';
    MemD_ArtLoc.LoadFromTextFile(pathIp + 'LOCARTICLE.TXT');
  except
    MessageDlg('LOCARTICLE' + #10 + #13 + memd_artloc.fieldbyname('num').asstring, mtWarning, [], 0);
    Exit;
  end;

  try
    frm_main.Ed_IEC.text := 'ORGANISME.TXT';
    MemD_orga.DelimiterChar := ';';
    MemD_orga.LoadFromTextFile(pathIp + 'Organisme.TXT');
  except
    MessageDlg('ORGANISME' + #10 + #13 + memd_orga.fieldbyname('num').asstring, mtWarning, [], 0);
    Exit;
  end;

  try
    frm_main.Ed_IEC.text := 'FLINFO.TXT';
    MemD_info.DelimiterChar := ';';
    MemD_info.LoadFromTextFile(pathIp + 'flinfo.TXT');
  except
    MessageDlg('FLINFO.TXT' + #10 + #13 + memd_info.fieldbyname('num').asstring, mtWarning, [], 0);
    Exit;
  end;

  try
    frm_main.Ed_IEC.text := 'STATLOC.TXT';
    HL.DelimiterChar := ';';
    HL.LoadFromTextFile(pathIp + 'Statloc.TXT');
  except
    MessageDlg('Statloc.txt' + #10 + #13 + HL.fieldbyname('client').asstring + #10 + #13 +
      HL.fieldbyname('date').asstring + #10 + #13 +
      HL.fieldbyname('article').asstring, mtWarning, [], 0);
    Exit;
  end;
  result := true;
end;

function tdm_import.ImportVide: boolean;
begin
  result := false;
  import.open;

  vide.close;
  vide.sql.clear;
  vide.sql.add('select * from corres_article');
  vide.open;
  vide.first;
  if not vide.eof then
  begin
    import.close;
    EXIT;
  end;

  vide.close;
  vide.sql.clear;
  vide.sql.add('select * from corres_fourn');
  vide.open;
  vide.first;
  if not vide.eof then
  begin
    import.close;
    EXIT;
  end;

  vide.close;
  vide.sql.clear;
  vide.sql.add('select * from corres_gt');
  vide.open;
  vide.first;
  if not vide.eof then
  begin
    import.close;
    EXIT;
  end;

  vide.close;
  vide.sql.clear;
  vide.sql.add('select * from corres_nk');
  vide.open;
  vide.first;
  if not vide.eof then
  begin
    import.close;
    EXIT;
  end;

  result := true;

end;

procedure Tdm_import.IbQ_DossierAfterPost(IB_Dataset: TIB_Dataset);
begin
  Dm_Main.IB_UpDateCache(IB_Dataset as TIB_BDataSet);
end;

procedure Tdm_import.memoduree(duree: ttime);
var i, vol: integer;
  F: TSearchRec;
begin
  ibq_dossier.open;
  ibq_dossier.insert;
  ibq_dossier.fieldbyname('dos_nom').asstring := 'DUREE_IMPORT_HUSKY';
  ibq_dossier.fieldbyname('dos_string').asstring := timetostr(duree);
  ibq_dossier.fieldbyname('dos_float').asfloat := 0;
  ibq_dossier.post;

  ibq_dossier.insert;
  ibq_dossier.fieldbyname('dos_nom').asstring := 'DATE_IMPORT_HUSKY';
  ibq_dossier.fieldbyname('dos_string').asstring := datetimetostr(now);
  ibq_dossier.fieldbyname('dos_float').asfloat := 0;
  ibq_dossier.post;


  vol := 0;
  i := findFirst(pathIp + '\*.txt', faAnyFile, F);
  while i = 0 do
  begin
    vol := vol + f.size;
    i := findnext(f);
  end;
  ibq_dossier.insert;
  ibq_dossier.fieldbyname('dos_nom').asstring := 'TAILLE_IP_HUSKY';
  ibq_dossier.fieldbyname('dos_string').asstring := inttostr(vol);
  ibq_dossier.fieldbyname('dos_float').asfloat := 0;
  ibq_dossier.post;
  ibq_dossier.close;


end;


function Tdm_import.IncMois(const Date: TDateTime; NumberOfMonths: Integer): TDateTime;
var
  Year, Month, Day: word;
begin
  DecodeDate(Date, Year, Month, Day);
  month := month - 1;
  if month = 0 then
  begin
    month := 12;
    year := year - 1;
  end;
  Result := EncodeDate(Year, Month, Day);
  ReplaceTime(Result, Date);
end;



function Tdm_import.CD_EAN(Cb: string; var CbCd: string): boolean;
var
  vcal, reste: integer;
  CD, cal: string;
  i: integer;
begin
  // Modification suppression du calcul du digit car tout peut être un CB
  Result := true;
  CbCd := CB;


       //Result est 'FALSE' si les caractères ne représentent pas un code barre
       //ou si en entrée il a 8 ou 13 caractères avec un mauvais 'check digit'.
       //
       //Calcul du Check Digit pour un EAN13
       //En entrée dans CB il y 12 ou 13 Chiffres, en sortie dans CbCd il y a
       //13 Chiffres. Je n'utilise pas CB en retour car celà permet
       //au programme appelant de pouvoir controler si les 13 chiffes origines correspondent
       //à ceux calculés. Si ils sont différents, cela indique que le code barre n'a pas été
       //lu correctement...
       //Idem pour les EAN8...

  result := true;
  CbCd := '';

    //---Test de controle des caractères
  for I := 1 to Length(cb) do
  begin
    if (cb[I] < '0') or (cb[I] > '9') then
    begin
      result := false;
      break;
    end;
  end;
  if result = false then
    Exit;

  case Length(cb) of
    12, 13:
      begin
        vcal := strtoint(CB[12]) + strtoint(CB[10]) + strtoint(CB[8]);
        vcal := vcal + strtoint(CB[6]) + strtoint(CB[4]) + strtoint(CB[2]);

        vcal := vcal * 3;

        vcal := vcal + strtoint(CB[11]) + strtoint(CB[9]) + strtoint(CB[7]);
        vcal := vcal + strtoint(CB[5]) + strtoint(CB[3]) + strtoint(CB[1]);

        vcal := 10000 - vcal;
        cal := inttostr(vcal);
        CD := copy(cal, Length(cal), 1);

        CbCd := copy(CB, 1, 12) + CD;

        if length(CB) = 13 then
          if cb[13] <> CD then result := false;

      end;

    7, 8:
      begin
        vcal := strtoint(CB[7]) + strtoint(CB[5]) + strtoint(CB[3]);
        vcal := vcal + strtoint(CB[1]);

        vcal := vcal * 3;

        vcal := vcal + strtoint(CB[6]) + strtoint(CB[4]) + strtoint(CB[2]);

        reste := vcal mod 10;
        if reste <> 0 then
          vcal := 10 - reste
        else
          vcal := reste;

        cd := inttostr(vcal);

        CbCd := copy(CB, 1, 7) + CD;

        if length(CB) = 8 then
          if cb[8] <> CD then result := false;

      end;
  else
    result := false;
  end;

end;


end.

