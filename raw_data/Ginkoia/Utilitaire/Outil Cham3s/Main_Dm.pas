unit Main_Dm;

interface

uses
  SysUtils, Classes, IB_Components, DB, IBODataset, dxmdaset;

type
  TDm_Main = class(TDataModule)
    IbC_Database: TIB_Connection;
    IbT_Transaction: TIB_Transaction;
    Que_ChxMagasin: TIBOQuery;
    Que_ChxMagasinBAS_ID: TIntegerField;
    Que_ChxMagasinBAS_NOM: TStringField;
    Que_ChxMagasinBAS_IDENT: TStringField;
    Que_ChxMagasinBAS_JETON: TIntegerField;
    Que_ChxMagasinBAS_PLAGE: TStringField;
    Que_ChxMagasinBAS_SENDER: TStringField;
    Que_ChxMagasinBAS_GUID: TStringField;
    Que_ChxMagasinBAS_CENTRALE: TStringField;
    Que_ChxMagasinBAS_NOMPOURNOUS: TStringField;
    Que_ChxMagasinBAS_RGPID: TIntegerField;
    Que_ChxMagasinBAS_TYPE: TIntegerField;
    Que_ChxMagasinBAS_MAGID: TIntegerField;
    Que_ChxMagasinBAS_SECBASID: TIntegerField;
    Que_ChxMagasinBAS_SYNCHRO: TIntegerField;
    Que_ChxMagasinBAS_SECBASEID: TIntegerField;
    Que_ChxMagasinBAS_REPLOG: TIntegerField;
    Que_ChxMagasinBAS_CODETIERS: TMemoField;
    Que_ChxMagasinK_ID: TIntegerField;
    Que_ChxMagasinKRH_ID: TIntegerField;
    Que_ChxMagasinKTB_ID: TIntegerField;
    Que_ChxMagasinK_VERSION: TIntegerField;
    Que_ChxMagasinK_ENABLED: TIntegerField;
    Que_ChxMagasinKSE_OWNER_ID: TIntegerField;
    Que_ChxMagasinKSE_INSERT_ID: TIntegerField;
    Que_ChxMagasinK_INSERTED: TDateTimeField;
    Que_ChxMagasinKSE_DELETE_ID: TIntegerField;
    Que_ChxMagasinK_DELETED: TDateTimeField;
    Que_ChxMagasinKSE_UPDATE_ID: TIntegerField;
    Que_ChxMagasinK_UPDATED: TDateTimeField;
    Que_ChxMagasinKSE_LOCK_ID: TIntegerField;
    Que_ChxMagasinKMA_LOCK_ID: TIntegerField;
    Que_AnalyseArtWeb: TIBOQuery;
    MemD_AnalyseArtWeb: TdxMemData;
    Ds_AnalyseArtWeb: TDataSource;
    MemD_AnalyseArtWebARF_CHRONO: TStringField;
    MemD_AnalyseArtWebART_NOM: TStringField;
    MemD_AnalyseArtWebMRK_NOM: TStringField;
    MemD_AnalyseArtWebMRK_IDREF: TIntegerField;
    MemD_TailleCouleurAnalyseArtWeb: TdxMemData;
    Que_TailleCouleurArtWeb: TIBOQuery;
    Ds_TailleCouleurAnalyseArtWeb: TDataSource;
    MemD_TailleCouleurAnalyseArtWebTGF_NOM: TStringField;
    MemD_TailleCouleurAnalyseArtWebCOU_NOM: TStringField;
    MemD_TailleCouleurAnalyseArtWebGCS_NOM: TStringField;
    MemD_TailleCouleurAnalyseArtWebCBI_CB: TStringField;
    MemD_AnalyseArtWebART_ID: TIntegerField;
    Que_SynchroMarque: TIBOQuery;
    Que_NomenclatureRen: TIBOQuery;
    Que_NomenclatureSync: TIBOQuery;
    Que_CouleurStatSync: TIBOQuery;
    Que_TailleCouleurCB: TIBOQuery;
    MemD_TailleCouleurAnalyseArtWebCOU_ID: TIntegerField;
    MemD_TailleCouleurAnalyseArtWebTGF_ID: TIntegerField;
    Que_CbFournUnique: TIBOQuery;
    Que_CbFournOk: TIBOQuery;
    Que_SiteMiseLigneOk: TIBOQuery;
    Que_AnalyseArtCodeBarre: TIBOQuery;
    MemD_AnalyseArtCodeBarre: TdxMemData;
    Ds_AnalyseArtCb: TDataSource;
    MemD_AnalyseArtCodeBarreARF_CHRONO: TStringField;
    MemD_AnalyseArtCodeBarreART_NOM: TStringField;
    MemD_AnalyseArtCodeBarreMRK_IDREF: TIntegerField;
    MemD_AnalyseArtCodeBarreMRK_NOM: TStringField;
    MemD_AnalyseArtCodeBarreTGF_NOM: TStringField;
    MemD_AnalyseArtCodeBarreCOU_NOM: TStringField;
    Que_GetFournisseur: TIBOQuery;
    MemD_AnalyseArtCodeBarreART_ID: TIntegerField;
    Que_AnalyseArtDispoWeb: TIBOQuery;
    MemD_AnalyseArtDispoWeb: TdxMemData;
    Ds_AnalyseArtDispo: TDataSource;
    MemD_AnalyseArtDispoWebARF_CHRONO: TStringField;
    MemD_AnalyseArtDispoWebART_NOM: TStringField;
    MemD_AnalyseArtDispoWebMRK_IDREF: TIntegerField;
    MemD_AnalyseArtDispoWebMRK_NOM: TStringField;
    MemD_AnalyseArtDispoWebTGF_NOM: TStringField;
    MemD_AnalyseArtDispoWebCOU_NOM: TStringField;
    Que_AnalyseCodeBarreDouble: TIBOQuery;
    MemD_AnalyseCodeBarreDoubleArt: TdxMemData;
    Ds_AnalyseCodeBarreDoubleArt: TDataSource;
    MemD_CodeBarreDouble: TdxMemData;
    Ds_CodeBarreDouble: TDataSource;
    MemD_CodeBarreDoubleCBI_CB: TStringField;
    Que_AnalyseCodeBareArt: TIBOQuery;
    MemD_AnalyseCodeBarreDoubleArtARF_ID: TIntegerField;
    MemD_AnalyseCodeBarreDoubleArtARF_CHRONO: TStringField;
    MemD_AnalyseCodeBarreDoubleArtART_NOM: TStringField;
    MemD_AnalyseCodeBarreDoubleArtMRK_NOM: TStringField;
    MemD_AnalyseCodeBarreDoubleArtMRK_IDREF: TIntegerField;
    MemD_AnalyseCodeBarreDoubleArtTGF_NOM: TStringField;
    MemD_AnalyseCodeBarreDoubleArtCOU_NOM: TStringField;
    Que_GetNomenclature: TIBOQuery;
    MemD_GetNomenclature: TdxMemData;
    MemD_GetNomenclatureSSF_NOM: TStringField;
    MemD_GetNomenclatureFAM_NOM: TStringField;
    MemD_GetNomenclatureRAY_NOM: TStringField;
    Ds_GetNomenclature: TDataSource;
    MemD_AnalyseArtCodeBarreTGF_ID: TIntegerField;
    MemD_AnalyseArtCodeBarreCOU_ID: TIntegerField;
    Que_LigneArtCodeBarre: TIBOQuery;
    MemD_LigneArtCodeBarre: TdxMemData;
    Ds_LigneArtCodeBarre: TDataSource;
    MemD_LigneArtCodeBarreCBI_CB: TStringField;
    Que_FiltreArtWeb: TIBOQuery;
    MemD_AnalyseArtWebMRK_ID: TIntegerField;
    Ds_FiltreArtWeb: TDataSource;
    MemD_FiltreArtweb: TdxMemData;
    MemD_FiltreArtwebART_ID: TIntegerField;
    MemD_FiltreArtwebARF_CHRONO: TStringField;
    MemD_FiltreArtwebMRK_NOM: TStringField;
    MemD_FiltreArtwebMRK_IDREF: TIntegerField;
    MemD_FiltreArtwebART_NOM: TStringField;
    MemD_FiltreArtwebMRK_ID: TIntegerField;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Dm_Main: TDm_Main;

implementation

{$R *.dfm}

end.
