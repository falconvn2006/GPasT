//$Log:
// 2    Utilitaires1.1         16/07/2014 17:46:31    Ortega Julien   CDC -
//      Suppression des liaisons avec ART_SSFID (2.10)
// 1    Utilitaires1.0         09/08/2013 09:53:56    Thierry Fleisch 
//$
//$NoKeywords$
//
//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------
// @@18 03/05/2002 modification de la query QUE_LISTE

UNIT NegFac_DM;

INTERFACE

USES
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
  Registry,
  IB_Components,
  IB_StoredProc,
  ExtCtrls,
  dxmdaset,
  DBSumLst,
  ppPrnabl,
  ppClass,
  ppStrtch,
  ppRichTx,
  ppCache,
  ppBands,
  ppComm,
  ppRelatv,
  ppProd,
  ppReport,
  ppModule,
  daDataModule,
  ppParameter,
  IBODataset,
  Variants;

TYPE

  TRECTAR = RECORD
    prix: Double;
    typid: Integer;
    pxbrut: Double;
    typcod: Integer;
  END;

  TDm_NegFac = CLASS(TDataModule)
    Grd_Close: TGroupDataRv;
    Que_TetFAC: TIBOQuery;
    Que_TetFACCPA_NOM: TStringField;
    Que_TetFACMRG_LIB: TStringField;
    Que_TetFACUSR_USERNAME: TStringField;
    Que_TetFACCIV_NOM: TStringField;
    Que_TetFACVIL_NOM: TStringField;
    Que_TetFACVIL_CP: TStringField;
    Que_TetFACPAY_NOM: TStringField;
    Que_Client: TIBOQuery;
    Que_Civilite: TIBOQuery;
    Que_ClientCLT_ID: TIntegerField;
    Que_ClientCLT_GCLID: TIntegerField;
    Que_ClientCLT_NUMERO: TStringField;
    Que_ClientCLT_NOM: TStringField;
    Que_ClientCLT_PRENOM: TStringField;
    Que_ClientCLT_CIVID: TIntegerField;
    Que_ClientCLT_ADRID: TIntegerField;
    Que_ClientCLT_NAISSANCE: TDateTimeField;
    Que_ClientCLT_TYPE: TIntegerField;
    Que_ClientCLT_CLTID: TIntegerField;
    Que_ClientCLT_COMPTA: TStringField;
    Que_ClientCLT_BL: TIntegerField;
    Que_ClientCLT_FIDELITE: TIntegerField;
    Que_ClientCLT_COMMENT: TMemoField;
    Que_ClientCLT_TELEPHONE: TStringField;
    Que_ClientCLT_TELTRAVAIL_FAX: TStringField;
    Que_ClientCLT_TELPORTABLE: TStringField;
    Que_ClientCLT_EMAIL: TStringField;
    Que_ClientCLT_PREMIERPASS: TDateTimeField;
    Que_ClientCLT_DERNIERPASS: TDateTimeField;
    Que_ClientCLT_ECAUTORISE: TIBOFloatField;
    Que_ClientCLT_CPTBLOQUE: TIntegerField;
    Que_ClientCLT_AFADRID: TIntegerField;
    Que_ClientCLT_AFTELEPHONE: TStringField;
    Que_ClientCLT_AFFAX: TStringField;
    Que_ClientCLT_AFEMAIL: TStringField;
    Que_ClientCLT_AFAUTRE: TMemoField;
    Que_ClientCLT_RETRAIT: TStringField;
    Que_ClientCLT_MRGID: TIntegerField;
    Que_ClientCLT_CPAID: TIntegerField;
    Que_ClientCLT_RIBBANQUE: TIntegerField;
    Que_ClientCLT_RIBGUICHET: TIntegerField;
    Que_ClientCLT_RIBCOMPTE: TStringField;
    Que_ClientCLT_RIBCLE: TIntegerField;
    Que_ClientCLT_RIBDOMICILIATION: TStringField;
    Que_ClientCLT_CODETVA: TStringField;
    Que_ClientCLT_ICLID1: TIntegerField;
    Que_ClientCLT_ICLID2: TIntegerField;
    Que_ClientCLT_ICLID3: TIntegerField;
    Que_ClientCLT_ICLID4: TIntegerField;
    Que_ClientCLT_ICLID5: TIntegerField;
    Que_ClientCLT_NUMFACTOR: TStringField;
    Que_ClientCIV_NOM: TStringField;
    Que_ClientADR_LIGNE: TMemoField;
    Que_ClientVIL_NOM: TStringField;
    Que_ClientPAY_NOM: TStringField;
    Que_ClientCPA_NOM: TStringField;
    Que_ClientMRG_LIB: TStringField;
    Que_CiviliteCIV_ID: TIntegerField;
    Que_CiviliteCIV_NOM: TStringField;
    Que_CiviliteCIV_SEXE: TIntegerField;
    Que_Magasin: TIBOQuery;
    Que_MagasinMAG_ID: TIntegerField;
    Que_MagasinMAG_IDENT: TStringField;
    Que_MagasinMAG_SOCID: TIntegerField;
    Que_MagasinMAG_TVTID: TIntegerField;
    Que_MagasinMAG_NATURE: TIntegerField;
    Que_MagasinMAG_IDENTCOURT: TStringField;
    Que_MagasinMAG_COMENT: TMemoField;
    Que_MagasinMAG_ARRONDI: TIntegerField;
    Que_MagasinMAG_GCLID: TIntegerField;
    Que_MagasinMAG_ADRID: TIntegerField;
    Que_MagasinMAG_TEL: TStringField;
    Que_MagasinMAG_FAX: TStringField;
    Que_MagasinMAG_EMAIL: TStringField;
    Que_MagasinMAG_SIRET: TStringField;
    Que_MagasinMAG_CODEADH: TStringField;
    Que_MagasinMAG_TRANSFERT: TIntegerField;
    Que_MagasinMAG_SS: TIntegerField;
    Que_MagasinMAG_HUSKY: TIntegerField;
    Que_ClientVIL_ID: TIntegerField;
    Que_ClientVIL_CP: TStringField;
    Que_Vendeur: TIBOQuery;
    Que_Moder: TIBOQuery;
    Que_CdtP: TIBOQuery;
    IbStProc_Chrono: TIB_StoredProc;
    IbC_CtrlMag: TIB_Cursor;
    Que_LineFAC: TIBOQuery;
    Que_LineFACART_REFMRK: TStringField;
    Que_LineFACART_ORIGINE: TIntegerField;
    Que_LineFACARF_CHRONO: TStringField;
    Que_LineFACARF_DIMENSION: TIntegerField;
    Que_LineFACARF_VIRTUEL: TIntegerField;
    Que_LineFACARF_VTFRAC: TIntegerField;
    Que_LineFACTGF_NOM: TStringField;
    Que_LineFACCOU_NOM: TStringField;
    IbC_Art: TIB_Cursor;
    Que_LineFACUSR_USERNAME: TStringField;
    Que_LineFACPUMP: TIBOFloatField;
    IbStProc_PumpNeo: TIB_StoredProc;
    Que_LineFACARF_SERVICE: TIntegerField;
    Que_LineFACARF_COEFT: TIBOFloatField;
    Que_Liste: TIBOQuery;
    Que_ListeTVA: TIBOFloatField;
    Que_ListeTOTHT: TFloatField;
    Que_ListeVIL_NOM: TStringField;
    Que_ListeVIL_CP: TStringField;
    Que_ListeCPA_NOM: TStringField;
    Que_ListeMAG_NOM: TStringField;
    Que_ListeTTC: TIBOFloatField;
    Que_Mags: TIBOQuery;
    Que_Archive: TIBOQuery;
    Que_RelDest: TIBOQuery;
    Que_TetFACFCE_ID: TIntegerField;
    Que_TetFACFCE_MAGID: TIntegerField;
    Que_TetFACFCE_CLTID: TIntegerField;
    Que_TetFACFCE_NUMERO: TStringField;
    Que_TetFACFCE_DATE: TDateTimeField;
    Que_TetFACFCE_PRENEUR: TStringField;
    Que_TetFACFCE_REMISE: TIBOFloatField;
    Que_TetFACFCE_DETAXE: TIntegerField;
    Que_TetFACFCE_TVAHT1: TIBOFloatField;
    Que_TetFACFCE_TVATAUX1: TIBOFloatField;
    Que_TetFACFCE_TVA1: TIBOFloatField;
    Que_TetFACFCE_TVAHT2: TIBOFloatField;
    Que_TetFACFCE_TVATAUX2: TIBOFloatField;
    Que_TetFACFCE_TVA2: TIBOFloatField;
    Que_TetFACFCE_TVAHT3: TIBOFloatField;
    Que_TetFACFCE_TVATAUX3: TIBOFloatField;
    Que_TetFACFCE_TVA3: TIBOFloatField;
    Que_TetFACFCE_TVAHT4: TIBOFloatField;
    Que_TetFACFCE_TVATAUX4: TIBOFloatField;
    Que_TetFACFCE_TVA4: TIBOFloatField;
    Que_TetFACFCE_TVAHT5: TIBOFloatField;
    Que_TetFACFCE_TVATAUX5: TIBOFloatField;
    Que_TetFACFCE_TVA5: TIBOFloatField;
    Que_TetFACFCE_CLOTURE: TIntegerField;
    Que_TetFACFCE_ARCHIVE: TIntegerField;
    Que_TetFACFCE_USRID: TIntegerField;
    Que_TetFACFCE_TYPID: TIntegerField;
    Que_TetFACFCE_CLTNOM: TStringField;
    Que_TetFACFCE_CLTPRENOM: TStringField;
    Que_TetFACFCE_CIVID: TIntegerField;
    Que_TetFACFCE_VILID: TIntegerField;
    Que_TetFACFCE_ADRLIGNE: TMemoField;
    Que_TetFACFCE_MRGID: TIntegerField;
    Que_TetFACFCE_CPAID: TIntegerField;
    Que_TetFACFCE_NMODIF: TIntegerField;
    Que_TetFACFCE_COMENT: TMemoField;
    Que_TetFACFCE_MARGE: TIBOFloatField;
    Que_TetFACFCE_PRO: TIntegerField;
    Que_LineFACFCL_ID: TIntegerField;
    Que_LineFACFCL_FCEID: TIntegerField;
    Que_LineFACFCL_ARTID: TIntegerField;
    Que_LineFACFCL_TGFID: TIntegerField;
    Que_LineFACFCL_COUID: TIntegerField;
    Que_LineFACFCL_NOM: TStringField;
    Que_LineFACFCL_USRID: TIntegerField;
    Que_LineFACFCL_QTE: TIBOFloatField;
    Que_LineFACFCL_PXBRUT: TIBOFloatField;
    Que_LineFACFCL_PXNET: TIBOFloatField;
    Que_LineFACFCL_PXNN: TIBOFloatField;
    Que_LineFACFCL_SSTOTAL: TIntegerField;
    Que_LineFACFCL_INSSTOTAL: TIntegerField;
    Que_LineFACFCL_GPSSTOTAL: TIntegerField;
    Que_LineFACFCL_TVA: TIBOFloatField;
    Que_LineFACFCL_COMENT: TStringField;
    Que_LineFACFCL_BLLID: TIntegerField;
    Que_LineFACFCL_TYPID: TIntegerField;
    Que_LineFACFCL_LINETIP: TIntegerField;
    Que_LineFACFCL_FROMBLL: TIntegerField;
    Que_ListeFCE_ID: TIntegerField;
    Que_ListeFCE_NUMERO: TStringField;
    Que_ListeFCE_DATE: TDateTimeField;
    Que_ListeFCE_CLTNOM: TStringField;
    Que_ListeFCE_CLTPRENOM: TStringField;
    Que_ListeFCE_REMISE: TIBOFloatField;
    Que_ListeFCE_ARCHIVE: TIntegerField;
    Que_ListeFCE_CLOTURE: TIntegerField;
    Que_ListeFCE_NMODIF: TIntegerField;
    Que_ListeFCE_MARGE: TIBOFloatField;
    Que_ListeFCE_PRO: TIntegerField;
    Que_TetFACCLT_NUMERO: TStringField;
    Que_LineFACFCL_DATEBLL: TDateTimeField;
    Que_ListeCLT_NUMERO: TStringField;
    IbC_TipLine: TIB_Cursor;
    Que_CptClt: TIBOQuery;
    Que_LineFACNEOLINE: TIntegerField;
    IbC_TipFac: TIB_Cursor;
    Tim_Focus: TTimer;
    Que_TetImp: TIBOQuery;
    Que_LineImp: TIBOQuery;
    Que_LineImpART_REFMRK: TStringField;
    Que_LineImpART_ORIGINE: TIntegerField;
    Que_LineImpARF_CHRONO: TStringField;
    Que_LineImpARF_DIMENSION: TIntegerField;
    Que_LineImpTGF_NOM: TStringField;
    Que_LineImpCOU_NOM: TStringField;
    Que_LineImpPUMP: TIBOFloatField;
    Que_LineImpFCL_ID: TIntegerField;
    Que_LineImpFCL_FCEID: TIntegerField;
    Que_LineImpFCL_ARTID: TIntegerField;
    Que_LineImpFCL_TGFID: TIntegerField;
    Que_LineImpFCL_COUID: TIntegerField;
    Que_LineImpFCL_NOM: TStringField;
    Que_LineImpFCL_USRID: TIntegerField;
    Que_LineImpFCL_QTE: TIBOFloatField;
    Que_LineImpFCL_PXBRUT: TIBOFloatField;
    Que_LineImpFCL_PXNET: TIBOFloatField;
    Que_LineImpFCL_PXNN: TIBOFloatField;
    Que_LineImpFCL_SSTOTAL: TIntegerField;
    Que_LineImpFCL_INSSTOTAL: TIntegerField;
    Que_LineImpFCL_GPSSTOTAL: TIntegerField;
    Que_LineImpFCL_TVA: TIBOFloatField;
    Que_LineImpFCL_COMENT: TStringField;
    Que_LineImpFCL_BLLID: TIntegerField;
    Que_LineImpFCL_TYPID: TIntegerField;
    Que_LineImpFCL_LINETIP: TIntegerField;
    Que_LineImpFCL_FROMBLL: TIntegerField;
    Que_LineImpFCL_DATEBLL: TDateTimeField;
    Que_TetFACTYP_LIB: TStringField;
    Que_Typefac: TIBOQuery;
    Que_TetFACFCE_REGLEMENT: TDateTimeField;
    Que_TetFACCPA_CODE: TIntegerField;
    Que_ListeCPA_CODE: TIntegerField;
    Que_ListeDateRglt: TDateTimeField;
    Que_ListeType: TStringField;
    Que_TetImpTTCEURO: TFloatField;
    Que_TetImpDateRglt: TDateTimeField;
    Que_ListeFCE_TYPID: TIntegerField;
    IbC_DefFac: TIB_Cursor;
    IBC_RechDoc: TIB_Cursor;
    Que_Recherche: TIBOQuery;
    Que_ListeUSR_USERNAME: TStringField;
    Que_TetFACFCE_FACTOR: TIntegerField;
    Que_ListeFCE_FACTOR: TIntegerField;
    IbC_Next: TIB_Cursor;
    Que_TetFACFCE_MODELE: TIntegerField;
    Que_Glossaire: TIBOQuery;
    Que_GlossaireDVL_ID: TIntegerField;
    Que_GlossaireDVL_NOM: TStringField;
    Que_GlossaireDVL_QTE: TIBOBCDField;
    Que_GlossaireDVL_PXBRUT: TIBOBCDField;
    Que_GlossaireDVL_PXNN: TIBOBCDField;
    Que_GlossaireDVL_TYPID: TIntegerField;
    Que_GlossaireDVL_LINETIP: TIntegerField;
    Que_GlossaireDVL_TVA: TIBOBCDField;
    Que_GlossaireDVL_COMENT: TStringField;
    Que_GlossaireDVE_NUMERO: TStringField;
    Que_GlossaireRAY_NOM: TStringField;
    Que_GlossaireFAM_NOM: TStringField;
    Que_GlossaireSSF_NOM: TStringField;
    Que_GlossaireSEC_NOM: TStringField;
    Que_GlossaireCTF_NOM: TStringField;
    Que_GlossaireCAT_NOM: TStringField;
    Que_GlossaireMRK_NOM: TStringField;
    Que_GlossaireGRE_NOM: TStringField;
    Que_GlossaireART_REFMRK: TStringField;
    Que_GlossaireARF_CHRONO: TStringField;
    Que_GlossaireTGF_NOM: TStringField;
    Que_GlossaireDVL_PXNET: TIBOBCDField;
    Que_ListeFCE_MAGID: TIntegerField;
    Que_GlossaireDVL_ARTID: TIntegerField;
    Que_GlossaireDVL_TGFID: TIntegerField;
    Que_GlossaireDVL_COUID: TIntegerField;
    Que_LineImpARF_VIRTUEL: TIntegerField;
    Que_LineImpARF_VTFRAC: TIntegerField;
    Que_LineImpARF_SERVICE: TIntegerField;
    Que_LineImpARF_COEFT: TIBOFloatField;
    Que_LineImpUSR_USERNAME: TStringField;
    Que_LineImpNEOLINE: TIntegerField;
    IbStProc_ChronoMod: TIB_StoredProc;
    Que_ListeFacMod: TIBOQuery;
    Que_ListeFacModFCE_ID: TIntegerField;
    Que_ListeFacModFCE_MAGID: TIntegerField;
    Que_ListeFacModFCE_NUMERO: TStringField;
    Que_ListeFacModFCE_CLTNOM: TStringField;
    Que_ListeFacModFCE_CLTPRENOM: TStringField;
    Que_ListeFacModFCE_REMISE: TIBOBCDField;
    Que_ListeFacModFCE_MARGE: TIBOFloatField;
    Que_ListeFacModFCE_PRO: TIntegerField;
    Que_ListeFacModVIL_NOM: TStringField;
    Que_ListeFacModVIL_CP: TStringField;
    Que_ListeFacModCPA_NOM: TStringField;
    Que_ListeFacModCPA_CODE: TIntegerField;
    Que_ListeFacModMAG_NOM: TStringField;
    Que_ListeFacModCLT_NUMERO: TStringField;
    Que_ListeFacModUSR_USERNAME: TStringField;
    Que_ListeFacModFCE_FACTOR: TIntegerField;
    Que_ListeFacModTTC: TIBOFloatField;
    Que_ListeFacModTVA: TIBOFloatField;
    Que_ListeFacModTOTHT: TFloatField;
    Que_NeoDocT: TIBOQuery;
    Que_NeoDocTFCE_ID: TIntegerField;
    Que_NeoDocTFCE_MAGID: TIntegerField;
    Que_NeoDocTFCE_CLTID: TIntegerField;
    Que_NeoDocTFCE_NUMERO: TStringField;
    Que_NeoDocTFCE_DATE: TDateTimeField;
    Que_NeoDocTFCE_PRENEUR: TStringField;
    Que_NeoDocTFCE_REMISE: TIBOFloatField;
    Que_NeoDocTFCE_DETAXE: TIntegerField;
    Que_NeoDocTFCE_TVAHT1: TIBOFloatField;
    Que_NeoDocTFCE_TVATAUX1: TIBOFloatField;
    Que_NeoDocTFCE_TVA1: TIBOFloatField;
    Que_NeoDocTFCE_TVAHT2: TIBOFloatField;
    Que_NeoDocTFCE_TVATAUX2: TIBOFloatField;
    Que_NeoDocTFCE_TVA2: TIBOFloatField;
    Que_NeoDocTFCE_TVAHT3: TIBOFloatField;
    Que_NeoDocTFCE_TVATAUX3: TIBOFloatField;
    Que_NeoDocTFCE_TVA3: TIBOFloatField;
    Que_NeoDocTFCE_TVAHT4: TIBOFloatField;
    Que_NeoDocTFCE_TVATAUX4: TIBOFloatField;
    Que_NeoDocTFCE_TVA4: TIBOFloatField;
    Que_NeoDocTFCE_TVAHT5: TIBOFloatField;
    Que_NeoDocTFCE_TVATAUX5: TIBOFloatField;
    Que_NeoDocTFCE_TVA5: TIBOFloatField;
    Que_NeoDocTFCE_CLOTURE: TIntegerField;
    Que_NeoDocTFCE_ARCHIVE: TIntegerField;
    Que_NeoDocTFCE_USRID: TIntegerField;
    Que_NeoDocTFCE_TYPID: TIntegerField;
    Que_NeoDocTFCE_CLTNOM: TStringField;
    Que_NeoDocTFCE_CLTPRENOM: TStringField;
    Que_NeoDocTFCE_CIVID: TIntegerField;
    Que_NeoDocTFCE_VILID: TIntegerField;
    Que_NeoDocTFCE_ADRLIGNE: TMemoField;
    Que_NeoDocTFCE_MRGID: TIntegerField;
    Que_NeoDocTFCE_CPAID: TIntegerField;
    Que_NeoDocTFCE_NMODIF: TIntegerField;
    Que_NeoDocTFCE_COMENT: TMemoField;
    Que_NeoDocTFCE_MARGE: TIBOFloatField;
    Que_NeoDocTFCE_PRO: TIntegerField;
    Que_NeoDocTFCE_REGLEMENT: TDateTimeField;
    Que_NeoDocTFCE_FACTOR: TIntegerField;
    Que_NeoDocTFCE_MODELE: TIntegerField;
    Que_NeoDocL: TIBOQuery;
    Que_CopyDocT: TIBOQuery;
    Que_CopyDocL: TIBOQuery;
    Que_CopyDocLFCL_ID: TIntegerField;
    Que_CopyDocLFCL_FCEID: TIntegerField;
    Que_CopyDocLFCL_ARTID: TIntegerField;
    Que_CopyDocLFCL_TGFID: TIntegerField;
    Que_CopyDocLFCL_COUID: TIntegerField;
    Que_CopyDocLFCL_NOM: TStringField;
    Que_CopyDocLFCL_USRID: TIntegerField;
    Que_CopyDocLFCL_QTE: TIBOFloatField;
    Que_CopyDocLFCL_PXBRUT: TIBOFloatField;
    Que_CopyDocLFCL_PXNET: TIBOFloatField;
    Que_CopyDocLFCL_PXNN: TIBOFloatField;
    Que_CopyDocLFCL_SSTOTAL: TIntegerField;
    Que_CopyDocLFCL_INSSTOTAL: TIntegerField;
    Que_CopyDocLFCL_GPSSTOTAL: TIntegerField;
    Que_CopyDocLFCL_TVA: TIBOFloatField;
    Que_CopyDocLFCL_COMENT: TStringField;
    Que_CopyDocLFCL_BLLID: TIntegerField;
    Que_CopyDocLFCL_TYPID: TIntegerField;
    Que_CopyDocLFCL_LINETIP: TIntegerField;
    Que_CopyDocLFCL_FROMBLL: TIntegerField;
    Que_CopyDocLFCL_DATEBLL: TDateTimeField;
    Que_NeoDocLFCL_ID: TIntegerField;
    Que_NeoDocLFCL_FCEID: TIntegerField;
    Que_NeoDocLFCL_ARTID: TIntegerField;
    Que_NeoDocLFCL_TGFID: TIntegerField;
    Que_NeoDocLFCL_COUID: TIntegerField;
    Que_NeoDocLFCL_NOM: TStringField;
    Que_NeoDocLFCL_USRID: TIntegerField;
    Que_NeoDocLFCL_QTE: TIBOFloatField;
    Que_NeoDocLFCL_PXBRUT: TIBOFloatField;
    Que_NeoDocLFCL_PXNET: TIBOFloatField;
    Que_NeoDocLFCL_PXNN: TIBOFloatField;
    Que_NeoDocLFCL_SSTOTAL: TIntegerField;
    Que_NeoDocLFCL_INSSTOTAL: TIntegerField;
    Que_NeoDocLFCL_GPSSTOTAL: TIntegerField;
    Que_NeoDocLFCL_TVA: TIBOFloatField;
    Que_NeoDocLFCL_COMENT: TStringField;
    Que_NeoDocLFCL_BLLID: TIntegerField;
    Que_NeoDocLFCL_TYPID: TIntegerField;
    Que_NeoDocLFCL_LINETIP: TIntegerField;
    Que_NeoDocLFCL_FROMBLL: TIntegerField;
    Que_NeoDocLFCL_DATEBLL: TDateTimeField;
    Que_CopyDocTFCE_ID: TIntegerField;
    Que_CopyDocTFCE_MAGID: TIntegerField;
    Que_CopyDocTFCE_CLTID: TIntegerField;
    Que_CopyDocTFCE_NUMERO: TStringField;
    Que_CopyDocTFCE_DATE: TDateTimeField;
    Que_CopyDocTFCE_PRENEUR: TStringField;
    Que_CopyDocTFCE_REMISE: TIBOFloatField;
    Que_CopyDocTFCE_DETAXE: TIntegerField;
    Que_CopyDocTFCE_TVAHT1: TIBOFloatField;
    Que_CopyDocTFCE_TVATAUX1: TIBOFloatField;
    Que_CopyDocTFCE_TVA1: TIBOFloatField;
    Que_CopyDocTFCE_TVAHT2: TIBOFloatField;
    Que_CopyDocTFCE_TVATAUX2: TIBOFloatField;
    Que_CopyDocTFCE_TVA2: TIBOFloatField;
    Que_CopyDocTFCE_TVAHT3: TIBOFloatField;
    Que_CopyDocTFCE_TVATAUX3: TIBOFloatField;
    Que_CopyDocTFCE_TVA3: TIBOFloatField;
    Que_CopyDocTFCE_TVAHT4: TIBOFloatField;
    Que_CopyDocTFCE_TVATAUX4: TIBOFloatField;
    Que_CopyDocTFCE_TVA4: TIBOFloatField;
    Que_CopyDocTFCE_TVAHT5: TIBOFloatField;
    Que_CopyDocTFCE_TVATAUX5: TIBOFloatField;
    Que_CopyDocTFCE_TVA5: TIBOFloatField;
    Que_CopyDocTFCE_CLOTURE: TIntegerField;
    Que_CopyDocTFCE_ARCHIVE: TIntegerField;
    Que_CopyDocTFCE_USRID: TIntegerField;
    Que_CopyDocTFCE_TYPID: TIntegerField;
    Que_CopyDocTFCE_CLTNOM: TStringField;
    Que_CopyDocTFCE_CLTPRENOM: TStringField;
    Que_CopyDocTFCE_CIVID: TIntegerField;
    Que_CopyDocTFCE_VILID: TIntegerField;
    Que_CopyDocTFCE_ADRLIGNE: TMemoField;
    Que_CopyDocTFCE_MRGID: TIntegerField;
    Que_CopyDocTFCE_CPAID: TIntegerField;
    Que_CopyDocTFCE_NMODIF: TIntegerField;
    Que_CopyDocTFCE_COMENT: TMemoField;
    Que_CopyDocTFCE_MARGE: TIBOFloatField;
    Que_CopyDocTFCE_PRO: TIntegerField;
    Que_CopyDocTFCE_REGLEMENT: TDateTimeField;
    Que_CopyDocTFCE_FACTOR: TIntegerField;
    Que_CopyDocTFCE_MODELE: TIntegerField;
    IbC_CpaCode: TIB_Cursor;
    MemD_Copy: TdxMemData;
    MemD_CopyDocO: TStringField;
    MemD_CopyDocD: TStringField;
    MemD_CopyAction: TStringField;
    MemD_CopyOk: TIntegerField;
    Que_CptCLTAbon: TIBOQuery;
    Que_CptCLTAbonCTE_ID: TIntegerField;
    Que_CptCLTAbonCTE_CLTID: TIntegerField;
    Que_CptCLTAbonCTE_MAGID: TIntegerField;
    Que_CptCLTAbonCTE_LIBELLE: TStringField;
    Que_CptCLTAbonCTE_DATE: TDateTimeField;
    Que_CptCLTAbonCTE_DEBIT: TIBOFloatField;
    Que_CptCLTAbonCTE_CREDIT: TIBOFloatField;
    Que_CptCLTAbonCTE_REGLER: TDateTimeField;
    Que_CptCLTAbonCTE_TKEID: TIntegerField;
    Que_CptCLTAbonCTE_TYP: TIntegerField;
    Que_CptCLTAbonCTE_ORIGINE: TIntegerField;
    Que_CptCLTAbonCTE_FCEID: TIntegerField;
    MemD_CopyNom: TStringField;
    Que_Datimp: TIBOQuery;
    Que_DatimpHTI_ID: TIntegerField;
    Que_DatimpHTI_MAGID: TIntegerField;
    Que_DatimpHTI_DOCID: TIntegerField;
    Que_DatimpHTI_TIPDOC: TIntegerField;
    Que_DatimpHTI_DATEIMP: TDateTimeField;
    Que_DatimpHTI_USRID: TIntegerField;
    Que_ParamImp: TIBOQuery;
    Que_ParamImpPRM_ID: TIntegerField;
    Que_ParamImpPRM_CODE: TIntegerField;
    Que_ParamImpPRM_INTEGER: TIntegerField;
    Que_ParamImpPRM_FLOAT: TIBOFloatField;
    Que_ParamImpPRM_STRING: TStringField;
    Que_ParamImpPRM_TYPE: TIntegerField;
    Que_ParamImpPRM_MAGID: TIntegerField;
    Que_ParamImpPRM_INFO: TStringField;
    Que_ListeDATIMP: TDateTimeField;
    Que_TetFACFCE_HTWORK: TIntegerField;
    Sum_LineFac: TDBSumList;
    Que_LineFACFCL_VALREMGLO: TIBOFloatField;
    Que_LineFACPXSBR: TIBOFloatField;
    Que_LineFACPXSAR: TIBOFloatField;
    Que_LineFACMTLINE: TIBOFloatField;
    Que_LineFACREMISE: TIBOFloatField;
    Que_LineFACMARGE: TIBOFloatField;
    Que_LineFACCUM1: TFloatField;
    Que_LineFACCUM2: TFloatField;
    Que_LineFACCUM3: TFloatField;
    Que_LineFACCUM4: TFloatField;
    Que_LineFACCUM5: TFloatField;
    MemD_Cums: TdxMemData;
    MemD_CumsCUMBR: TFloatField;
    MemD_CumsCUMTTC: TFloatField;
    MemD_CumsCUMHT: TFloatField;
    MemD_CumsDECLENCHEUR: TIntegerField;
    MemD_CumsCUMMARGE: TFloatField;
    MemD_CumsTEMMODIF: TIntegerField;
    Que_GlossaireCOU_NOM: TStringField;
    Que_GlossairePXSBR: TIBOBCDField;
    Que_GlossairePXSAR: TIBOBCDField;
    Que_GlossaireMTLINE: TIBOBCDField;
    Que_GlossaireREMISE: TIBOBCDField;
    Que_LineImpFCL_VALREMGLO: TIBOFloatField;
    Que_LineImpPXSBR: TIBOBCDField;
    Que_LineImpPXSAR: TIBOBCDField;
    Que_LineImpMTLINE: TIBOBCDField;
    Que_LineImpMARGE: TIBOBCDField;
    Que_LineImpREMISE: TIBOBCDField;
    Que_NeoDocTFCE_HTWORK: TIntegerField;
    Que_NeoDocLFCL_VALREMGLO: TIBOFloatField;
    Que_CopyDocTFCE_HTWORK: TIntegerField;
    Que_CopyDocLFCL_VALREMGLO: TIBOFloatField;
    Que_TetImpFCE_ID: TIntegerField;
    Que_TetImpFCE_MAGID: TIntegerField;
    Que_TetImpFCE_CLTID: TIntegerField;
    Que_TetImpFCE_NUMERO: TStringField;
    Que_TetImpFCE_DATE: TDateTimeField;
    Que_TetImpFCE_PRENEUR: TStringField;
    Que_TetImpFCE_REMISE: TIBOFloatField;
    Que_TetImpFCE_DETAXE: TIntegerField;
    Que_TetImpFCE_TVAHT1: TIBOFloatField;
    Que_TetImpFCE_TVATAUX1: TIBOFloatField;
    Que_TetImpFCE_TVA1: TIBOFloatField;
    Que_TetImpFCE_TVAHT2: TIBOFloatField;
    Que_TetImpFCE_TVATAUX2: TIBOFloatField;
    Que_TetImpFCE_TVA2: TIBOFloatField;
    Que_TetImpFCE_TVAHT3: TIBOFloatField;
    Que_TetImpFCE_TVATAUX3: TIBOFloatField;
    Que_TetImpFCE_TVA3: TIBOFloatField;
    Que_TetImpFCE_TVAHT4: TIBOFloatField;
    Que_TetImpFCE_TVATAUX4: TIBOFloatField;
    Que_TetImpFCE_TVA4: TIBOFloatField;
    Que_TetImpFCE_TVAHT5: TIBOFloatField;
    Que_TetImpFCE_TVATAUX5: TIBOFloatField;
    Que_TetImpFCE_TVA5: TIBOFloatField;
    Que_TetImpFCE_CLOTURE: TIntegerField;
    Que_TetImpFCE_ARCHIVE: TIntegerField;
    Que_TetImpFCE_USRID: TIntegerField;
    Que_TetImpFCE_TYPID: TIntegerField;
    Que_TetImpFCE_CLTNOM: TStringField;
    Que_TetImpFCE_CLTPRENOM: TStringField;
    Que_TetImpFCE_CIVID: TIntegerField;
    Que_TetImpFCE_VILID: TIntegerField;
    Que_TetImpFCE_ADRLIGNE: TMemoField;
    Que_TetImpFCE_MRGID: TIntegerField;
    Que_TetImpFCE_CPAID: TIntegerField;
    Que_TetImpFCE_NMODIF: TIntegerField;
    Que_TetImpFCE_COMENT: TMemoField;
    Que_TetImpFCE_MARGE: TIBOFloatField;
    Que_TetImpFCE_PRO: TIntegerField;
    Que_TetImpFCE_REGLEMENT: TDateTimeField;
    Que_TetImpFCE_FACTOR: TIntegerField;
    Que_TetImpFCE_MODELE: TIntegerField;
    Que_TetImpFCE_HTWORK: TIntegerField;
    Que_TetImpCPA_NOM: TStringField;
    Que_TetImpCPA_CODE: TIntegerField;
    Que_TetImpMRG_LIB: TStringField;
    Que_TetImpCIV_NOM: TStringField;
    Que_TetImpCLTVILLE: TStringField;
    Que_TetImpCLTCP: TStringField;
    Que_TetImpCLTPAYS: TStringField;
    Que_TetImpMAGVILLE: TStringField;
    Que_TetImpMAGCP: TStringField;
    Que_TetImpMAGPAYS: TStringField;
    Que_TetImpCLT_NUMERO: TStringField;
    Que_TetImpSOC_NOM: TStringField;
    Que_TetImpCLT_NUMFACTOR: TStringField;
    Que_TetImpCLTADR: TMemoField;
    Que_TetImpMAGADR: TMemoField;
    Que_TetImpUSR_USERNAME: TStringField;
    Que_TetImpUSR_FULLNAME: TStringField;
    Que_TetImpCLIENT: TStringField;
    Que_TetImpTOTTTC: TIBOFloatField;
    Que_TetImpTOTTVA: TIBOFloatField;
    Que_TetImpHT1: TIBOFloatField;
    Que_TetImpHT2: TIBOFloatField;
    Que_TetImpHT3: TIBOFloatField;
    Que_TetImpHT4: TIBOFloatField;
    Que_TetImpHT5: TIBOFloatField;
    Que_TetImpTOTHT: TIBOFloatField;
    Que_GlossaireDVL_GPSSTOTAL: TIntegerField;
    MemD_Stk: TdxMemData;
    MemD_StkARTID: TIntegerField;
    MemD_StkTGFID: TIntegerField;
    MemD_StkCOUID: TIntegerField;
    MemD_StkSTK: TFloatField;
    MemD_StkSTKI: TFloatField;
    IbC_Stk: TIB_Cursor;
    Que_GlossaireDVL_SSTOTAL: TIntegerField;
    Que_LineFACMRK_NOM: TStringField;
    Que_TetImpCLT_CODETVA: TStringField;
    Que_TVT: TIBOQuery;
    Que_TVTTVT_NOM: TStringField;
    Que_TVTTVT_ID: TIntegerField;
    Que_GlossaireMODELE: TStringField;
    IbC_CtrlPseudo: TIB_Cursor;
    Que_TetImpSUMTTC: TFloatField;
    Que_DatimpHTI_MODIFIE: TIntegerField;
    Que_ListeCLT_NUMFACTOR: TStringField;
    Que_ListeFacModCLT_NUMFACTOR: TStringField;
    Que_TetFACCLT_NUMFACTOR: TStringField;
    Que_TetImpMAG_ENSEIGNE: TStringField;
    Que_ListeFCE_HTWORK: TIntegerField;
    Que_ListeFacModFCE_HTWORK: TIntegerField;
    Que_TetFACMAG_ENSEIGNE: TStringField;
    Que_MagasinMAG_ENSEIGNE: TStringField;
    Que_MagasinMAG_FACID: TIntegerField;
    Que_MagasinMAG_LIVID: TIntegerField;
    Que_TetFACFCE_CATEG: TIntegerField;
    Que_TetFACCATEGORIE: TStringField;
    Que_GlossaireCATEGORIE: TStringField;
    Que_Categ: TIBOQuery;
    Que_CategNPR_LIBELLE: TStringField;
    Que_CategNPR_ID: TIntegerField;
    Que_CategNPR_TYPE: TIntegerField;
    Que_CategNPR_CODE: TIntegerField;
    Que_ListeCATEGORIE: TStringField;
    Que_ListeFacModCATEGORIE: TStringField;
    Que_NeoDocTFCE_CATEG: TIntegerField;
    Que_CopyDocTFCE_CATEG: TIntegerField;
    Que_TetImpFCE_CATEG: TIntegerField;
    IbC_GPC: TIB_Cursor;
    Que_ListeCLT_COMPTA: TStringField;
    Ppr_Cdv: TppReport;
    ppDetailBand1: TppDetailBand;
    ppRich_Cdv: TppRichText;
    Que_ListeMRG_LIB: TStringField;
    daDataModule1: TdaDataModule;
    Que_ListeCLTCLA1: TStringField;
    Que_ListeCLTCLA2: TStringField;
    Que_ListeCLTCLA3: TStringField;
    Que_ListeCLTCLA4: TStringField;
    Que_ListeCLTCLA5: TStringField;
    Que_CltMembrePro: TIBOQuery;
    Que_CltMembreProPRM_ID: TIntegerField;
    Que_CltMembreProPRM_CLTIDPRO: TIntegerField;
    Que_CltMembreProPRM_CLTIDPART: TIntegerField;
    Que_CltMembreProPRM_DEBUT: TDateTimeField;
    Que_CltMembreProNOM_PRO: TStringField;
    Que_CltMembreProCLT_TOFACTURATION: TIntegerField;
    Que_CltMembreProCLT_VTEREMISE: TIBOFloatField;
    IbStProc_Prix: TIB_StoredProc;
    Que_ClientCLT_DATECF: TDateTimeField;
    Que_ClientCLT_ADRLIV: TIntegerField;
    Que_ClientCLT_MAGID: TIntegerField;
    Que_ClientCLT_ARCHIVE: TIntegerField;
    Que_ClientCLT_RESID: TIntegerField;
    Que_ClientCLT_STAADRID: TIntegerField;
    Que_ClientCLT_ORGID: TIntegerField;
    Que_ClientCLT_NUMCB: TStringField;
    Que_ClientCLT_NBJLOC: TIntegerField;
    Que_ClientCLT_CLIPROLOCATION: TIntegerField;
    Que_ClientCLT_TOFACTURATION: TIntegerField;
    Que_ClientCLT_LOCREMISE: TIBOFloatField;
    Que_ClientCLT_VTEREMISE: TIBOFloatField;
    Que_ClientCLT_TOCLTID: TIntegerField;
    Que_ClientCLT_IDTHEO: TIntegerField;
    Que_ClientCLT_TOSUPPLEMENT: TIBOFloatField;
    Que_ClientCLT_NMODIF: TIntegerField;
    Que_ClientCLT_DUREEVO: TIntegerField;
    Que_ClientCLT_DUREEVODATE: TDateTimeField;
    Que_ClientCLT_VTEREMISEPRO: TIBOFloatField;
    Que_TetFACFCE_WEB: TIntegerField;
    Que_TetFACPAY_ID: TIntegerField;
    Que_TetFACADR1: TStringField;
    Que_TetFACADR2: TStringField;
    Que_TetFACADR3: TStringField;
    Que_ClientPAY_ID: TIntegerField;
    Que_ClientADR1: TMemoField;
    Que_ClientADR2: TMemoField;
    Que_ClientADR3: TMemoField;
    Que_PXVOCWEB: TIBOQuery;
    Que_PXVOCWEBISOK: TIntegerField;
    Que_PXVOCWEBPXVTEOCWEB: TIBOBCDField;
    IbC_PseudoPort: TIB_Cursor;
    Que_ListeFCE_WEB: TIntegerField;
    Que_LineImpMRK_NOM: TStringField;
    Que_LineImpCBTO: TStringField;
    Que_TetImpFCE_WEB: TIntegerField;
    Que_TetImpTYP_COD: TIntegerField;
    Que_TetImpMAG_CODEADH: TStringField;
    Que_ListeCLT_RIBBANQUE: TIntegerField;
    Que_ListeCLT_RIBGUICHET: TIntegerField;
    Que_ListeCLT_RIBCOMPTE: TStringField;
    Que_ListeCLT_RIBCLE: TIntegerField;
    Que_ListeCLT_RIBDOMICILIATION: TStringField;
    Que_LineImpPXSBRHT: TIBOFloatField;
    Que_LineImpPXSARHT: TIBOFloatField;
    Que_ListeFacModMRG_LIB: TStringField;
    Que_ListeFacModCLTCLA1: TStringField;
    Que_ListeFacModCLT_RIBBANQUE: TIntegerField;
    Que_ListeFacModCLT_RIBGUICHET: TIntegerField;
    Que_ListeFacModCLT_RIBCOMPTE: TStringField;
    Que_ListeFacModCLT_RIBCLE: TIntegerField;
    Que_ListeFacModCLT_RIBDOMICILIATION: TStringField;
    Que_ListeFacModFCE_DETAXE: TIntegerField;
    Que_ListeFCE_DETAXE: TIntegerField;
    IbC_Email: TIB_Cursor;
    Que_LineFACMARGEPOURCENT: TIBOFloatField;
    Que_LineFACCOEF: TIBOBCDField;
    Que_TetImpUSR_TEL: TStringField;
    Que_TetImpUSR_FAX: TStringField;
    Que_TetImpUSR_GSM: TStringField;
    Que_TetImpUSR_EMAIL: TStringField;
    Que_PseudoClient: TIBOQuery;
    Que_PseudoClientCLT_ID: TIntegerField;
    Que_PseudoClientCLT_MAGIDPF: TIntegerField;
    Que_LineFACCBTO: TStringField;
    Que_LineFACPXSBRHT: TIBOFloatField;
    Que_LineFACPXSARHT: TIBOFloatField;
    Que_LineFACFCL_LOTID: TIntegerField;
    Que_LineFACFCL_TYPELOT: TIntegerField;
    Que_LineFACFCL_NUMLOT: TIntegerField;
    Que_TetFACFCE_SUIVI: TStringField;
    Que_TetFACFCE_URLSUIVI: TStringField;
    Que_TetFACFCE_CLTIDPRO: TIntegerField;
    Que_TetFACFCE_IMAID: TIntegerField;
    Que_TetFACFCE_IDWEB: TIntegerField;
    Que_TetFACFCE_DVEID: TIntegerField;
    Que_TetFACFCE_BLLID: TIntegerField;
    Que_TetFACFCE_CODESITEWEB: TIntegerField;
    Que_TetFACFCE_NUMCDE: TStringField;
    Que_ListeFCE_REGLER: TIntegerField;
    Que_TetFACFCE_REGLER: TIntegerField;
    Que_TetFACFCE_DTREGLER: TDateTimeField;
    Que_TetFACAffFCEREGLER: TIntegerField;
    Que_ListeFCE_DTREGLER: TDateTimeField;
    Que_LineFACART_FUSARTID: TIntegerField;
    Que_ListePAY_NOM: TStringField;
    Que_TetImpFCE_SUIVI: TStringField;
    Que_TetImpFCE_URLSUIVI: TStringField;
    Que_TetImpFCE_CLTIDPRO: TIntegerField;
    Que_TetImpFCE_IMAID: TIntegerField;
    Que_TetImpFCE_IDWEB: TIntegerField;
    Que_TetImpFCE_DVEID: TIntegerField;
    Que_TetImpFCE_BLLID: TIntegerField;
    Que_TetImpFCE_CODESITEWEB: TIntegerField;
    Que_TetImpFCE_NUMCDE: TStringField;
    Que_TetImpFCE_REGLER: TIntegerField;
    Que_TetImpFCE_DTREGLER: TDateTimeField;
    Que_TetImpFCE_FILID: TIntegerField;
    Que_TetImpFIL_COMMENT1: TMemoField;
    Que_TetImpFIL_COMMENT2: TMemoField;
    Que_TetImpFIL_ID: TIntegerField;
    PROCEDURE DataModuleCreate(Sender: TObject);
    PROCEDURE DataModuleDestroy(Sender: TObject);

    PROCEDURE Que_TetFACAfterPost(DataSet: TDataSet);
    PROCEDURE Que_TetFACNewRecord(DataSet: TDataSet);
    PROCEDURE Que_TetFACAfterCancel(DataSet: TDataSet);
    PROCEDURE Que_TetFACAfterScroll(DataSet: TDataSet);
    PROCEDURE Que_TetFACAfterEdit(DataSet: TDataSet);
    PROCEDURE Que_TetFACTYP_LIBGetText(Sender: TField; VAR Text: STRING;
      DisplayText: Boolean);
    PROCEDURE Que_TetFACCPA_NOMGetText(Sender: TField; VAR Text: STRING;
      DisplayText: Boolean);
    PROCEDURE Que_TetFACBeforeDelete(DataSet: TDataSet);
    PROCEDURE Que_TetFACFCE_REMISEGetText(Sender: TField; VAR Text: STRING;
      DisplayText: Boolean);

    PROCEDURE Que_LineFACAfterPost(DataSet: TDataSet);
    PROCEDURE Que_LineFACNewRecord(DataSet: TDataSet);
    PROCEDURE Que_LineFACAfterCancel(DataSet: TDataSet);
    PROCEDURE Que_LineFACCalcFields(DataSet: TDataSet);
    PROCEDURE Que_LineFACBeforeEdit(DataSet: TDataSet);
    PROCEDURE Que_LineFACBeforePost(DataSet: TDataSet);
    PROCEDURE Que_LineFACREMISEGetText(Sender: TField; VAR Text: STRING;
      DisplayText: Boolean);

    PROCEDURE Que_ListeCalcFields(DataSet: TDataSet);

    PROCEDURE Que_CptCltNewRecord(DataSet: TDataSet);
    PROCEDURE Tim_FocusTimer(Sender: TObject);
    PROCEDURE Que_TetImpCalcFields(DataSet: TDataSet);
    PROCEDURE Que_ListeFacModCalcFields(DataSet: TDataSet);
    PROCEDURE Que_TetFACBeforePost(DataSet: TDataSet);
    PROCEDURE Que_LineFACPXSBRValidate(Sender: TField);
    PROCEDURE Que_LineFACREMISEValidate(Sender: TField);
    PROCEDURE Que_LineFACMTLINEValidate(Sender: TField);
    PROCEDURE Que_TetFACFCE_REMISEChange(Sender: TField);
    PROCEDURE MemD_CumsCalcFields(DataSet: TDataSet);
    PROCEDURE Que_LineFACFCL_QTEValidate(Sender: TField);
    PROCEDURE Que_GlossaireREMISEGetText(Sender: TField; VAR Text: STRING;
      DisplayText: Boolean);
    PROCEDURE Que_LineImpREMISEGetText(Sender: TField; VAR Text: STRING;
      DisplayText: Boolean);
    PROCEDURE Que_LineFACFCL_PXNNValidate(Sender: TField);
    PROCEDURE Que_TVTTVT_NOMGetText(Sender: TField; VAR Text: STRING;
      DisplayText: Boolean);
    PROCEDURE Que_LineFACBeforeInsert(DataSet: TDataSet);
    PROCEDURE Que_CategBeforeDelete(DataSet: TDataSet);
    PROCEDURE Que_CategNewRecord(DataSet: TDataSet);
    PROCEDURE Que_TVTBeforeOpen(DataSet: TDataSet);
    PROCEDURE Que_TetFACFCE_DETAXEChange(Sender: TField);
    procedure Que_TetFACCalcFields(DataSet: TDataSet);
    procedure Que_TetFACBeforeEdit(DataSet: TDataSet);

  PRIVATE
    OnCalcST, IsRefresh, OnMajTete: Boolean;
    TemCalcLine: Integer; // pour distiguer cas dans calcline

    // Maj différée CalcST
    STDifMT: Double;
    STDifID: Integer;
    //********************

    MemQte, MemRemST, MemCumBrut: Double; // pour gérer le tableur d'entête
    MemMtBR, MemTvaLin: Double; // pour gérer le tableur d'entête
    MemRefST: Integer; // optimisation pour la validation finale
    MemPro: Integer; // optimisation pour la validation finale

    RecTar: TRecTar;

    TabTaux: ARRAY[1..5] OF Double;
    TheDateABON: TDateTime;
    fMontantBeforeEdit: double; // Montant TTC au moment du passage en mode édition

    FUNCTION UpdateNeoDoc: Boolean;
    PROCEDURE InitTabTaux;
    FUNCTION GetIndiceTaux(TxTva: Double): Integer;
    PROCEDURE MajEntete;
    PROCEDURE AligneMemdSTK;

    PROCEDURE CalcST(IdPack: Integer);
    PROCEDURE UpdateMask;

    { Déclarations privées }
  PUBLIC
    { Déclarations publiques }
    DoCtrlStk: boolean;
    DisableSetContext: Boolean;
    LabFactor: STRING;
    DoCalcLine: Boolean;
    DoPostLine, DoBeforePostLine: Boolean;
    DoInitEntet: Boolean;

    IsHt: Boolean;

    ExDatas: ARRAY OF variant;
    TxtFinFact, TxtFactor, TxtRgltDef: STRING;

    Codasais, Codarecep: Integer;
    FromGlos: Boolean; // Pour dragdrop glossaire  

    bCreationWebManu: boolean;   // Creation Fact Web Manuel  
    iSavTarif: integer;     // Sav du choix du tarif avant création BL Web Manuel

    HTPied: extended;
    GpcID: Integer;
    ImpCdv, ImpTailCoul, ImpPg, ImpLine, ImpTVA, ImpVend, ImpPayClt, ImpCivClt, ImpPayMag, ImpDateDef, ImpRem, ImpEuro, ImpTTC, ImpTextePied, ImpTete, ImpPied: Boolean; // gestion impression

    TipPrix: Integer; // Pour rétros  0 : Pump,  1 PXANNego  2 PxCat
    PseudoPortWeb: Integer;
    TipFacRetro, TipFacNormal, TipFacRegul : Integer;
    LibFacNormal, LibFacRetro: STRING;

    TipNormal, TipPro, TipFacLoc: Integer;
    NeoComent: Integer; // en création d'un commentaire

    OkW2Pdf, CbRech: Boolean;
    CBQtte: Double;

    // FC Gestion des lots
    bDelLot: Boolean;

    OnNewLine, OnNewRec, LineModified, UserVM, UserVisuTarifs: Boolean;
    Preview, ChxImp: Boolean;

    PROCEDURE AssigneFiche(MaFiche: TObject);
    PROCEDURE OpenFac(IdFac: Integer);
    PROCEDURE MajClient(idClt: Integer);
    FUNCTION OkClient: Boolean;
    PROCEDURE DMUserVM(Uvm, Uvt: Boolean);
    FUNCTION ConfPost: Boolean;
    FUNCTION ConFCancel: Boolean;

    FUNCTION StateEdit: Integer;
    FUNCTION ControleDoc(IdMag, IdDoc: Integer): Boolean;

    FUNCTION OnComent: Boolean;
    PROCEDURE AligneArticle(Artid: Integer);
    PROCEDURE Refresh;

    FUNCTION GetMagKour: Integer;
    PROCEDURE ArchiveFac(IdFac: Integer);
    PROCEDURE ClotureFac(IdFac: Integer);

    PROCEDURE DeleteLine;

    FUNCTION FromBL: Boolean;
    PROCEDURE PROChange;
    PROCEDURE RechDoc(Ledoc: STRING; AlsResu: TStrings);

    FUNCTION ImprimeFactureKour(IdFac: Integer; First: Boolean): Boolean;
    FUNCTION SetParamImp: Boolean;
    PROCEDURE Clotarch(Archiver: Boolean);
    FUNCTION CltHasFactor: Boolean;
    PROCEDURE NextRec;
    PROCEDURE PRIORRec;
    FUNCTION IsModele: Boolean;
    PROCEDURE CopyDoc(FCEID: Integer; Modele: Boolean);
    FUNCTION NeoDoc(Modele: Boolean; VAR ChronoDoc: STRING): Boolean;
    FUNCTION CreModele: Boolean;
    PROCEDURE GenereFac(Ts: Tstrings);
    PROCEDURE SupprimeAbon(Ts: Tstrings);
    PROCEDURE SetflagVisLine;
    PROCEDURE AffStkLigne;

    PROCEDURE Neoline;
    PROCEDURE NewComent(Tip: Integer);
    PROCEDURE SimpleDragNode(TS: TStrings);
    PROCEDURE DragGlos(Prec, Suiv: STRING; Nbre: Integer);
    PROCEDURE DragModeleGlos(TS: TStrings);
    PROCEDURE DragPackNode(TS: TStrings; ExPack, NeoPack: Integer; IdLock: Integer = 0);
    FUNCTION CTRLDateValid: Boolean;
    PROCEDURE RefreshDoc;
    PROCEDURE RegenIDLin(IdRet: Integer; VAR IdPrec, IdSuiv: STRING);
    PROCEDURE Decale(idRet, Nbre: Integer; IdNomStart: STRING);

    FUNCTION GetPVURemClt: Boolean;
    PROCEDURE SetPVURemClt;

    procedure OuvreFacture(IdFac: Integer); //JO 2013-07-01 : Ouverture d'une Facture
  PUBLISHED

    PROCEDURE GetTextEuro(Sender: TField; VAR Text: STRING; DisplayText: Boolean);
    PROCEDURE GenerikAfterPost(DataSet: TDataSet);
    PROCEDURE GenerikUpdateRecord(DataSet: TDataSet;
      UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
    PROCEDURE GenerikAfterCancel(DataSet: TDataSet);

  END;

PROCEDURE ImprimeFacturePDF(IdFac: integer; sCheminPDF: STRING);
PROCEDURE ImprimeFacture(IdFac : integer);

VAR
  Dm_NegFac: TDm_NegFac;
IMPLEMENTATION

USES
  Main_Dm,
  Common_Frm,
  NegFac_Frm,
  GinkoiaResStr,
  GinKoiaStd,
  stdCalcs,
  StdUtils,
  StdBdeUtils,
  ListeFac_Frm,
  ChxTailCoul_Frm,
  ChxModeImp_Frm,
  ListeFacMod_Frm,
  ChxStdDate_Frm,
  AbonRap_Frm,
  CalcEntet_Frm,
  DlgChoix_Frm,
  DlgStd_Frm,
  FileCTRL,
  ShellApi,
  Math,
  Types;
{$R *.DFM}

VAR
  Frm_NegFac: TFrm_NegFac;
  Frm_CalcEntet: TFrm_CalcEntet;

PROCEDURE TDm_NegFac.DataModuleCreate(Sender: TObject);
BEGIN
  bDelLot := False; // FC : Gestion des lots

  bCreationWebManu := false;   // Creation Fact Web Manuel
  iSavTarif := 0;     // Sav du choix du tarif avant création BL Web Manuel

  OnCalcSt := False;
  DisableSetContext := False;
  gpcID := 0;

  PseudoPortWeb := 0;
  RecTar.prix := 0;
  RecTar.typid := 0;
  RecTar.pxbrut := 0;
  RecTar.typcod := 0;

  IsRefresh := False;
  DoCtrlSTK := True;
  DoPostLine := True;
  DoBeforePostLine := True;
  DoCalcLine := True;
  DoInitEntet := False;
  OnMajTete := False;
  IsHT := False;
  FromGlos := False;

  OnNewRec := False;
  OnNewLine := False;
  CbRech := False;
  CBQtte := 1;
  LineModified := False;
  UserVM := False;
  UserVisuTarifs := True;

  NeoComent := 0;
  MemRemST := 0;
  MemRefST := 0;
  TemCalcLine := 0;
  MemMtBR := 0;
  MemCumBrut := 0;
  MemQte := 0;
  MemTvaLin := 0;

  Frm_CalcEntet := TFrm_CalcEntet.Create(Application);

  Codasais := 0;
  Codarecep := 0;
  TipPrix := 0;
  Preview := False;
  HTPied := 0;
  ChxImp := True;
  ImpTete := False;
  ImpPied := False;
  ImpTextePied := False;
  ImpTTC := False;
  ImpEuro := False;
  ImpRem := False;
  ImpCivClt := False;
  ImpPayClt := False;
  ImpVend := False;
  ImpPg := False;
  ImpLine := False;
  ImpTva := False;
  ImpTailCoul := False;
  ImpCdv := False;
  ImpPayMag := False;

  TipFacRetro := 0;
  TipFacNormal := 0;
  TipFacRegul := 0;
  TipFacLoc := 0;
  LibFacNormal := '';
  LibFacRetro := '';

  TRY
    ibc_PseudoPort.Close;
    ibc_PseudoPort.Open;
    PseudoPortWeb := ibc_PseudoPort.Fields[0].asInteger;
  FINALLY
    Ibc_PseudoPort.Close;
  END;

  // Type de Ligne normale
  Ibc_TipLine.Close;
  Ibc_TipLine.ParamByName('LETIP').asInteger := 1;
  Ibc_TipLine.Open;
  IF NOT Ibc_TipLine.eof THEN
    TipNormal := Ibc_TipLine.FieldByName('TYP_ID').asInteger;
  Ibc_TipLine.Close;

  // Type de ligne professionnelle
  Ibc_TipLine.Close;
  Ibc_TipLine.ParamByName('LETIP').asInteger := 5;
  Ibc_TipLine.Open;
  IF NOT Ibc_TipLine.eof THEN
    TipPro := Ibc_TipLine.FieldByName('TYP_ID').asInteger;
  Ibc_TipLine.Close;

  // Note le Type retro d'une Facture
  Ibc_TipFac.Close;
  Ibc_TipFac.ParamByName('LETIP').asInteger := 1001;
  Ibc_TipFac.Open;
  IF NOT Ibc_TipFac.eof THEN
  BEGIN
    TipFacRetro := Ibc_TipFac.FieldByName('TYP_ID').asInteger;
    LibFacRetro := Ibc_TipFac.FieldByName('TYP_LIB').asString;
  END;

  // Note le Type retro d'une Facture
  Ibc_TipFac.Close;
  Ibc_TipFac.ParamByName('LETIP').asInteger := 903;
  Ibc_TipFac.Open;
  IF NOT Ibc_TipFac.eof THEN
  BEGIN
    TipFacLoc := Ibc_TipFac.FieldByName('TYP_ID').asInteger;
  END;

  // Type de facture normale
  Ibc_TipFac.Close;
  Ibc_TipFac.ParamByName('LETIP').asInteger := 901;
  Ibc_TipFac.Open;
  IF NOT Ibc_TipFac.eof THEN
  BEGIN
    TipFacNormal := Ibc_TipFac.FieldByName('TYP_ID').asInteger;
    LibFacNormal := Ibc_TipFac.FieldByName('TYP_LIB').asString;
  END;
  Ibc_TipFac.Close;

  // Type de facture de regul interclub
  Ibc_TipFac.ParamByName('LETIP').asInteger := 906;
  Ibc_TipFac.Open;
  IF NOT Ibc_TipFac.eof THEN
  BEGIN
    TipFacRegul := Ibc_TipFac.FieldByName('TYP_ID').asInteger;
  END;
  Ibc_TipFac.Close;

  TRY
    ibc_Gpc.Close;
    ibc_Gpc.ParamByName('MAGID').asInteger := stdginkoia.magasinID;
    ibc_Gpc.Open;
    GpcId := ibc_Gpc.FieldByName('mgc_gclid').asInteger;
  FINALLY
    Ibc_Gpc.Close;
  END;

END;

PROCEDURE TDm_NegFac.DataModuleDestroy(Sender: TObject);
BEGIN
  Frm_CalcEntet.Free;

  IF UserVisuTarifs THEN
    StdGinkoia.iniCtrl.WriteInteger('NEGOCE', 'TARIF', que_TvtTVT_ID.asInteger);

  StdGinkoia.iniCtrl.WriteInteger('NEGFAC', 'VALUE', que_TetFacFCE_ID.asInteger);
  Grd_Close.Close;
END;

// -----------  Tables annexes -----------------

FUNCTION TDm_NegFac.OkClient: Boolean;
BEGIN
  Result := False;
  IF Que_TetFac.State IN [dsInsert, dsEdit] THEN
    Result := Que_TetFacFCE_CLTID.asInteger > 0;
END;

PROCEDURE TDm_NegFac.MajClient(idClt: Integer);
BEGIN
  que_Client.Close;
  que_Client.ParamByName('CLTID').asInteger := IdClt;
  que_Client.Open;

  IF que_Client.isEmpty THEN
  BEGIN
    StdGinKoia.DelayMess(Noclient, 3);
    Exit;
  END;

  //lab 18/11/08 Filtre PseudoClient
  //interroger la base : si c'est un pseudo client quitter
  Que_PseudoClient.Close;
  Que_PseudoClient.ParamByName('CLTID').asInteger := IdClt;
  Que_PseudoClient.Open;
  IF Que_PseudoClientCLT_MAGIDPF.asInteger <> 0 THEN
  BEGIN
    StdGinkoia.DelayMess(clientPseudo, 3);
    EXIT;
  END;

  que_CltMembrePro.Close;
  que_CltMembrePro.ParamByName('CLTID').asInteger := idclt;
  que_CltMembrePro.Open;

  IF NOT (que_TetFac.State IN [DsInsert, dsEdit]) THEN
    que_TetFac.Edit;

  IF (Que_TetFacFCE_CIVID.asInteger = 0) OR
    (Que_TetFacFCE_CLTID.asInteger <> Que_ClientCLT_ID.asInteger) THEN
  BEGIN
    // ne change le factor que SSI init du client
    IF Trim(Que_ClientCLT_NUMFACTOR.asstring) <> '' THEN
      Que_TetFacFCE_FACTOR.asInteger := 1
    ELSE
      Que_TetFacFCE_FACTOR.asInteger := 0;
  END;

  Que_TetFacFCE_CIVID.asInteger := Que_ClientCLT_CIVID.asInteger;
  Que_TetFacCIV_NOM.asString := Que_ClientCIV_NOM.asString;
  Que_TetFacFCE_CLTID.asInteger := Que_ClientCLT_ID.asInteger;
  Que_TetFacFCE_CLTNOM.asString := Que_ClientCLT_NOM.asString;
  Que_TetFacFCE_CLTPRENOM.asString := Que_ClientCLT_PRENOM.asString;
  Que_TetFacFCE_VILID.asInteger := Que_ClientVIL_ID.asInteger;
  Que_TetFacVIL_NOM.asString := Que_ClientVIL_NOM.asString;
  Que_TetFacPAY_NOM.asString := Que_ClientPAY_NOM.asString;
  Que_TetFacVIL_CP.asString := Que_ClientVIL_CP.asString;
  Que_TetFacFCE_ADRLIGNE.asString := Que_ClientADR_LIGNE.asString;
                                  
  // pas d'affection règlement si Web manu ou cli particulier
  if (Que_TetFac.FieldByName('FCE_WEB').AsInteger=0)
      and (Que_ClientCLT_TYPE.asInteger=1) then
  begin
    Que_TetFacFCE_MRGID.asInteger := Que_ClientCLT_MRGID.asInteger;
    Que_TetFacMRG_LIB.asString := Que_ClientMRG_LIB.asString;
    Que_TetFacFCE_CPAID.asInteger := Que_ClientCLT_CPAID.asInteger;
    Que_TetFacCPA_NOM.asString := Que_ClientCPA_NOM.asString;
  end;

  Que_TetFacCLT_NUMERO.asString := Que_ClientCLT_NUMERO.asString;
  Que_TetFacCLT_NUMFACTOR.asString := Que_ClientCLT_NUMFACTOR.asString;

  Que_TetFacADR1.asString := Que_ClientADR1.asString;
  Que_TetFacADR2.asString := Que_ClientADR2.asString;
  Que_TetFacADR3.asString := Que_ClientADR3.asString;
  Que_TetFacPAY_ID.asInteger := Que_ClientPAY_ID.asInteger;

  Que_TetFacFCE_PRO.asInteger := Que_ClientCLT_TYPE.asInteger;
  WITH FRM_NegFac DO
  BEGIN
    chp_Factor.Visible := CltHasFactor;
    IF chp_Factor.Visible THEN
    BEGIN
      Chp_NumFactor.Visible := True;
      Chp_Coment.Height := 54;
    END
    ELSE BEGIN
      Chp_NumFactor.Visible := False;
      Chp_Coment.Height := 79;
    END;
  END;
END;

// -------------- Fin des tables annexes

// -------------------------------------------

PROCEDURE TDm_NegFac.Refresh;
BEGIN
  IF Que_TetFac.Active THEN
    IF Que_TetFacFCE_ID.asInteger > 0 THEN
    BEGIN
      OPENFac(Que_TetFacFCE_ID.asInteger);
      IF IsModele THEN
        Frm_ListeFacMod.NeedRefresh := True
      ELSE
        Frm_ListeFac.NeedRefresh := True
    END;
END;

FUNCTION TDm_NegFac.StateEdit: Integer;
BEGIN
  { 0 : Inactive
    1 : Empty
    2 : En Edition
    3 : En Création
    4 : Archivé
    5 : Cloturé
    6 : Non Modifiable
    10 : Modifiable

    REM : Un document dont des lignes ont été transférées est non modifiable
  }
  Result := 0;
  IF NOT que_TetFac.Active THEN Exit;
  Result := 1;
  IF que_TetFac.IsEmpty THEN Exit;
  Result := 2;
  IF que_TetFac.state IN [dsEdit] THEN Exit;
  Result := 3;
  IF que_TetFac.state IN [dsInsert] THEN Exit;
  Result := 4;
  IF que_TetFacFCE_ARCHIVE.asInteger = 1 THEN Exit;
  Result := 5;
  IF que_TetFacFCE_CLOTURE.asInteger = 1 THEN Exit;
  Result := 6;
  IF que_TetFacFCE_NMODIF.asInteger = 1 THEN Exit;
  Result := 10;
END;

PROCEDURE TDm_NegFac.OpenFac(IdFac: Integer);

  FUNCTION DefFac: Integer;
  BEGIN
    Result := 0;
    TRY
      Ibc_DefFac.Close;
      Ibc_DefFac.ParamByName('MAGID').asInteger := stdGinkoia.MagasinID;
      Ibc_DefFac.Open;
      IF NOT Ibc_DefFac.Eof THEN
        Result := Ibc_DefFac.FieldByName('FCE_ID').asInteger;
    FINALLY
      Ibc_DefFac.Close;
    END;
  END;

BEGIN

  IF IdFac < 0 THEN
    IdFac := StdGinkoia.iniCtrl.ReadInteger('NEGFAC', 'VALUE', 0);
  // cas du démarrage

  Que_TetFac.DisableControls;
  WITH Frm_NegFac DO
  BEGIN
    Dbg_LineFac.BeginUpdate;

    TRY
      IF IdFac <> 0 THEN
      BEGIN
        que_TetFac.Close;
        que_TetFac.ParamByName('FCEID').asInteger := IdFac;
        que_TetFac.Open;
        IdFac := que_TetFac.FieldByName('FCE_ID').asInteger;
      END;

      IF ((NOT Frm_Negfac.UserVisuMags) AND
        (que_TetFacFCE_MAGID.asInteger <> stdGinkoia.MagasinID)) OR (IdFac = 0) THEN
      BEGIN
        que_TetFac.Close;
        que_TetFac.ParamByName('FCEID').asInteger := DefFac;
        que_TetFac.Open;
      END;

      Dbg_LineFac.Filter.Clear;
      Dbg_LineFac.ClearSelection;
    FINALLY
      Dbg_LineFac.FullExpand;
      Dbg_LineFac.GotoFirst;
      Dbg_LineFac.EndUpdate;
      Que_TetFac.EnableControls;

      SetContextSaisie;
    END;
  END;

END;

procedure TDm_NegFac.OuvreFacture(IdFac: Integer);
 FUNCTION DefFacture: Integer;
  BEGIN
    Result := 0;
    TRY
      IbC_DefFac.Close;
      IbC_DefFac.ParamByName('MAGID').asInteger := stdGinkoia.MagasinID;
      IbC_DefFac.Open;
      IF NOT IbC_DefFac.Eof THEN
        Result := IbC_DefFac.FieldByName('FCE_ID').asInteger;
    FINALLY
      IbC_DefFac.Close;
    END;
  END;
begin
  with Frm_NegFac do
  begin
    screen.cursor := crSQLWait;
    Dbg_LineFac.BeginUpdate;
    try
      if IdFac <> 0 then
      begin
        Que_TetFAC.Close;
        Que_TetFAC.ParamByName('FCEID').asInteger := IdFac;
        Que_TetFAC.Open;
        IdFac := Que_TetFAC.FieldByName('FCE_ID').asInteger;
      end;

      if (not Frm_NegFac.UserVisuMags) or (IdFac = 0) then
      begin
        Que_TetFAC.Close;
        Que_TetFAC.ParamByName('FCEID').asInteger := DefFacture;
        Que_TetFAC.Open;
      end;

      Dbg_LineFac.Filter.Clear;
    finally
      Dbg_LineFac.FullExpand;
      Dbg_LineFac.EndUpdate;
      Dbg_LineFac.GotoFirstDetail;
      Screen.Cursor := crDefault;
    end;
  end;
end;

FUNCTION TDm_NegFac.ControleDoc(IdMag, IdDoc: Integer): Boolean;
BEGIN
  Ibc_CtrlMAG.Close;
  Ibc_CtrlMAG.ParamByName('FCEID').asInteger := IdDoc;
  Ibc_CtrlMAG.ParamByName('MAGID').asInteger := IdMag;
  Ibc_CtrlMag.Open;

  Result := (StdGinkoia.UserVisuMags) or (NOT Ibc_CtrlMag.eof);
  Ibc_CtrlMag.Close;
END;

FUNCTION TDm_NegFac.OnComent: Boolean;
BEGIN
  Result := False;
  IF que_LineFac.Active THEN
    Result := que_LineFacFCL_LINETIP.asInteger > 0;
  IF Result THEN
  BEGIN
    IF que_LineFACFCL_LINETIP.asInteger = 1 THEN
      Frm_NegFAC.Lab_LineComent.Caption := NegLabComent;
    IF que_LineFACFCL_LINETIP.asInteger = 2 THEN
      Frm_NegFAC.Lab_LineComent.Caption := NegLabTitle;
    IF que_LineFACFCL_LINETIP.asInteger = 3 THEN
      Frm_NegFAC.Lab_LineComent.Caption := NegLabPack;
    IF que_LineFACFCL_LINETIP.asInteger = 4 THEN
      Frm_NegFAC.Lab_LineComent.Caption := NegLabPack;

    Frm_NegFac.Lab_LineComent.Top := 10;
  END
  ELSE
  BEGIN
    Frm_NegFac.Lab_LineComent.Caption := NegLabArticle;
    Frm_NegFac.Lab_LineComent.Top := 53;
  END;

END;

PROCEDURE TDm_NegFac.NewComent(Tip: Integer);
VAR
  MemID4, MemID3: Integer;
BEGIN
  IF TIP = 3 THEN
  BEGIN
    TRY
      frm_NegFac.Dbg_LineFac.BeginUpdate;
      DoPostLine := True;
      NeoComent := 4;
      Neoline;
      Que_LineFac.Post;
      MemID3 := que_LineFacFCL_ID.asInteger;

      Neocoment := 3;
      NeoLine;
      Que_LineFac.Post;
      MemID4 := que_LineFacFCL_ID.asInteger;

      Que_LineFac.Locate('FCL_ID', MemID3, []);
      que_LineFac.Edit;
      que_LineFacFCL_SSTOTAL.AsInteger := MemID4;
      Que_LineFac.Post;

    FINALLY
      frm_NegFac.Dbg_LineFac.EndUpdate;
      DoPostLine := False;
      LineModified := True;
      Frm_negFac.dbg_lineFac.GotoNext(False);
      IF frm_NegFac.Chp_RemST.Visible THEN
        frm_NegFac.Chp_RemST.SetFocus;
      NeoComent := 0;
    END;
  END
  ELSE BEGIN
    NeoComent := Tip;
    Neoline;
  END;
END;

PROCEDURE TDm_NegFac.Neoline;
VAR
  DoAppend: Boolean;
BEGIN
  { On passe ici SSI une seule nouvelle ligne est en cours d'insertion
    La gestion des blocs importés est autonome et n'appelle pas Neoline }
  MemRemSt := 0;
  MemRefSt := 0;
  MemCumBrut := 0;
  MemMtBR := 0;
  MemTvaLin := 0;
  MemQte := 0;
  DoAppend := False;

  Frm_NegFac.IdxNeoline(DoAppend);
  IF Frm_NegFac.GetRemST(MemRemST) THEN
    MemRefST := que_LineFacFCL_SSTOTAL.AsInteger;

  que_LineFac.Next;
  IF DoAppend THEN
    Que_LineFac.Append
  ELSE
    que_LineFac.Insert;
END;

PROCEDURE TDm_NegFac.AligneArticle(Artid: Integer);
BEGIN
  IBC_Art.Close;
  IBC_Art.ParamByname('ARTID').asInteger := artid;
  IBC_Art.Open;
END;

PROCEDURE TDm_NegFac.Que_ListeCalcFields(DataSet: TDataSet);
BEGIN
  que_ListeTOTHT.asfloat :=
    que_ListeTTC.asfloat - que_ListeTVA.asFloat;
  stdGinKoia.ChpDateRgltCODE(que_ListeFCE_DATE.asDateTime, que_ListeCPA_CODE.asInteger, que_ListeDateRglt);

  IF que_ListeTTC.asFloat < 0 THEN
    que_ListeType.asString := AvoirLib
  ELSE
  BEGIN
    IF que_ListeFCE_TYPID.asFloat = TipFacRetro THEN
      que_ListeType.asString := RetroLib
    ELSE
      que_ListeType.asString := FacLib;
  END;
END;

FUNCTION TDm_NegFac.GetMagKour: Integer;
BEGIN
  Result := 0;
  IF Que_TetFac.Active THEN
    Result := Que_TetFac.fieldByName('FCE_MAGID').asInteger;
END;

PROCEDURE TDm_NegFac.ArchiveFac(IdFac: Integer);
BEGIN
  que_Archive.close;
  que_archive.paramByName('FCEID').asInteger := IdFac;
  que_Archive.open;
  IF NOT que_Archive.IsEmpty THEN
  BEGIN
    que_Archive.Edit;
    que_Archive.fieldByName('FCE_ARCHIVE').asInteger := 1;
    que_Archive.fieldByName('FCE_CLOTURE').asInteger := 1;
    que_Archive.fieldByName('FCE_NMODIF').asInteger := 1;
    que_Archive.Post;
    que_Archive.Close;
  END;
END;

FUNCTION TDm_NegFac.FromBL: Boolean;
BEGIN
  Result := false;
  IF que_LineFac.active THEN
    Result := que_LineFacFCL_FROMBLL.asInteger = 1;
END;

PROCEDURE TDm_NegFAC.PROChange;
VAR
  bkm: TBooKmark;
BEGIN

  IF NOT Que_TetFAC.Active THEN EXIT;
  IF NOT (Que_TetFAC.State IN [dsInsert, dsEdit]) THEN Exit;

  IF que_TetFACFCE_PRO.asInteger = MemPro THEN Exit;
  IF que_LineFAC.IsEmpty THEN Exit;
  // Rien à faire ....

  DoPostLine := False;
  // évite sautillement d'affichage et déclenchement du timer ligne
  DoCalcLine := False;
  // évite dans ce contexte les recalculs inutiles ...
  DoBeforePostLine := False;

  Bkm := que_LineFAC.getBookMark;
  TRY
    Frm_NegFac.Dbg_LineFac.BeginUpdate;
    que_LineFAC.DisableControls;

    screen.cursor := crSqlWait;
    que_LineFAC.First;
    WHILE NOT que_LineFAC.Eof DO
    BEGIN
      IF (que_LineFACFCL_LINETIP.asInteger = 0) THEN
      BEGIN
        que_LineFAC.Edit;
        IF que_TetFACFCE_PRO.asInteger = 1 THEN
          que_LineFACFCL_TYPID.asInteger := TipPro
        ELSE
          que_LineFACFCL_TYPID.asInteger := TipNormal;
        // si l'user change le type de doc il perd
        // toute notion de solde, promo etc dans les lignes !
        que_LineFAC.Post;
      END;

      que_LineFAC.Next;
    END;

  FINALLY
    que_LineFAC.GotoBookmark(bkm);
    que_LineFAC.FreeBookMark(Bkm);
    que_LineFAC.EnableControls;
    screen.cursor := crDefault;
    DoPostLine := True;
    DoCalcLine := True;
    DoBeforePostLine := True;
    Frm_NegFac.Dbg_LineFac.EndUpdate;
  END;
END;

PROCEDURE TDm_NegFAC.RechDoc(Ledoc: STRING; AlsResu: TStrings);
var
  iFCEID: integer;  // id facture trouvé
BEGIN
  iFCEID := 0; 
  Ibc_RechDoc.Close;
  TRY
    // 1) recherche sur le chrono
    with Ibc_RechDoc do
    begin
      SQL.Clear;
      SQL.Add('SELECT FCE_ID FROM NEGFACTURE');
      SQL.Add('JOIN K ON (FCE_ID=K_ID AND K_ENABLED=1)');
      SQL.Add('WHERE');
      SQL.Add('FCE_NUMERO='+QuotedStr(LeDoc));
      Open;
      if not(Eof) then
      begin
        iFCEID := fieldbyname('FCE_ID').AsInteger;
        AlsResu.Add(inttostr(iFCEID));
      end;
      Close;
    end;

    // si pas trouvé, 2) recherche sur le chrono d'origine (BL ou Devis)
    if iFCEID=0 then
    begin
      with Ibc_RechDoc do
      begin
        SQL.Clear;
        SQL.Add('SELECT FCE_ID FROM NEGFACTURE');
        SQL.Add('JOIN K ON (FCE_ID=K_ID AND K_ENABLED=1)');
        SQL.Add('WHERE');
        SQL.Add('Upper(FCE_NUMCDE)='+QuotedStr(UpperCase(LeDoc)));
        Open;
        if not(Eof) then
        begin
          iFCEID := fieldbyname('FCE_ID').AsInteger;
          while not(Eof) do
          begin
            AlsResu.Add(inttostr(fieldbyname('FCE_ID').AsInteger));
            Next;
          end;
        end;
        Close;
      end;
    end;
    
    // si pas trouvé, 3) recherche sur l'IDWeb si LeDoc est numérique
    if (iFCEID=0) and (StrToIntDef(LeDoc,-1)<>-1) then
    begin 
      with Ibc_RechDoc do
      begin
        SQL.Clear;
        SQL.Add('SELECT FCE_ID FROM NEGFACTURE');
        SQL.Add('JOIN K ON (FCE_ID=K_ID AND K_ENABLED=1)');
        SQL.Add('WHERE');
        SQL.Add('FCE_IDWEB='+LeDoc);
        Open;
        if not(Eof) then
        begin
          iFCEID := fieldbyname('FCE_ID').AsInteger; 
          while not(Eof) do
          begin
            AlsResu.Add(inttostr(fieldbyname('FCE_ID').AsInteger));
            Next;
          end;
        end;
        Close;
      end;
    end;

    // si rien trouvé--> message
    IF AlsResu.Count=0 THEN
      StdGinkoia.DelayMess(ParamsStr(NoDocFound, Ledoc), 0);

  FINALLY
    Ibc_RechDoc.Close;
  END;

END;

PROCEDURE TDm_NegFac.Que_CptCltNewRecord(DataSet: TDataSet);
BEGIN
  IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
    (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;
  WITH que_CptClt DO
  BEGIN
    fieldByName('CTE_CLTID').asInteger := que_TetFacFCE_CLTID.asInteger;
    fieldByName('CTE_MAGID').asInteger := que_TetFacFCE_MAGID.asInteger;
    fieldByName('CTE_Libelle').asString := '';
    fieldByName('CTE_DATE').asDateTime := que_TetFacFCE_DATE.asDateTime;
    fieldByName('CTE_CREDIT').asFloat := 0;
    fieldByName('CTE_DEBIT').asInteger := 0;
    fieldByName('CTE_TKEID').asInteger := 0;
    fieldByName('CTE_TYP').asInteger := 0;
    fieldByName('CTE_ORIGINE').asInteger := 1;
    fieldByName('CTE_FCEID').asInteger := que_TetFacFCE_ID.asInteger;
  END;

END;

PROCEDURE TDm_NegFac.ClotureFac(IdFac: Integer);
BEGIN
  que_Archive.close;
  que_archive.paramByName('FCEID').asInteger := IdFac;
  que_Archive.open;
  IF NOT que_Archive.IsEmpty THEN
  BEGIN
    que_Archive.Edit;
    que_Archive.fieldByName('FCE_CLOTURE').asInteger := 1;
    que_Archive.fieldByName('FCE_NMODIF').asInteger := 1;
    que_Archive.Post;
    que_Archive.Close;
  END;

END;

FUNCTION TDm_NegFac.ImprimeFactureKour(IdFac: Integer; First: Boolean): Boolean;
VAR
  i: Integer;
  isPro: Boolean;
  Reg: TRegistry;
  Nom, NomPdf, FactRtm: STRING;
  sNomExportPdf: string;
  sFactureOuAvoir: string;  // libellé suivant que c'est un avoir ou une facture
BEGIN
  Result := False;
  IF IDFac <= 0 THEN Exit;

  IF StdGinkoia.GetIso(stdGinkoia.Convertor.MnyRef) <>
    StdGinkoia.GetIso(stdGinkoia.Convertor.DefaultMnyRef) THEN

    StdGinKoia.DelayMess(NoNegEuro, 3)
  ELSE BEGIN

    TRY
      que_TetImp.Close;
      que_TetImp.paramByName('FCEID').asInteger := IdFac;
      que_tetImp.Open;
      IsPro := que_TetImpFCE_PRO.asInteger = 1;

      // Facture ou avoir
      if Que_TetImp.Fieldbyname('TOTTTC').AsFloat<0 then
      begin
        sFactureOuAvoir := 'Avoir';
        sNomExportPdf := FormatDateTime('yyyy-mm-dd', Date)+
                         '_'+sFactureOuAvoir+'_'+
                         que_TetImp.fieldByName('FCE_NUMERO').asString+'-A.pdf';
      end
      else
      begin
        sFactureOuAvoir := 'Facture';  
        sNomExportPdf := FormatDateTime('yyyy-mm-dd', Date)+
                         '_'+sFactureOuAvoir+'_'+
                         que_TetImp.fieldByName('FCE_NUMERO').asString+'.pdf';
      end;

      Nom := ReplaceChars(que_TetImpFCE_CLTNOM.asstring, ';.?./\''#@5{[]}°"~!§?%àèéïô+*%$| ', '_');
      // modification car la date n'a pas d'interet
      NomPdf := que_TetImpFCE_NUMERO.asstring + '_' + Copy(Nom, 1, 32) + '.pdf';

      CASE Que_TetImpTYP_COD.asinteger OF
        903: FactRtm := 'FACTURE2.RTM';
      ELSE
        if Que_TetImp.FieldByName('FIL_ID').AsInteger <> 0 then
          FactRtm := 'FactureFiliale.rtm'
        else
          FactRtm := 'Facture1.RTM';
      END;

      que_TetImp.Close;
      i := que_TetImp.SQL.IndexOf('/*BALISE1*/');
      IF i <> -1 THEN
      BEGIN
        IF NOT isPro THEN
        BEGIN
          IF ImpCivClt THEN
            que_TetImp.SQL[i + 1] :=
              '( LTRIM(CIV_NOM||'' '')||FCE_CLTNOM||'' ''||FCE_CLTPRENOM ) CLIENT,'
          ELSE
            que_TetImp.SQL[i + 1] :=
              '( FCE_CLTNOM||'' ''||FCE_CLTPRENOM ) CLIENT,'
        END
        ELSE que_TetImp.SQL[i + 1] := '( FCE_CLTNOM ) CLIENT,'
      END;
      que_tetImp.Open;

      //lab 08/07/08 pour un possible envoie de pdf initialiser sa description
      stdGinkoia.aPdfEmail.FichierNom := sNomExportPdf;
      stdGinkoia.aPdfEmail.EmailObjet := sFactureOuAvoir+' ' + que_TetImp.fieldByName('FCE_NUMERO').asString;

      //lab 08/07/08 pour un possible envoie récupèrer l'e-mail du destinataire
      TRY
        ibc_Email.close;
        ibc_Email.ParamByName('CLTNUM').asString := que_TetImp.fieldByName('CLT_NUMERO').asString;
        ibc_Email.open;
        IF NOT ibc_Email.eof THEN
        BEGIN
          stdGinkoia.aPdfEmail.EmailDestinataire := ibc_Email.Fields[0].asString;
        END
      FINALLY
        ibc_Email.Close;
      END;
      que_TetImp.paramByName('FCEID').asInteger := IdFac;
      que_tetImp.Open;

      Que_LineImp.Close;
      que_LineImp.paramByName('FCEID').asInteger := IdFac;
      que_LineImp.Open;

      que_Mags.Close;
      que_Mags.Open;
      que_Mags.Locate('MAG_ID', que_TetImp.fieldByName('FCE_MAGID').asInteger, []);

      //lab 08/07/08 pour un possible envoie de pdf renseigner sa description
      stdGinkoia.aPdfEmail.EmailEmetteur := que_Mags.fieldByName('ADR_EMAIL').asString;

      IF First THEN
      BEGIN
        // OkW2Pdf est mis a false en entrée de choixImp...
        IF ChoixModeImpAutoW2Pdf(Preview, ChxImp, OkW2Pdf) THEN
        BEGIN
          //lab 08/07/08 Tester l'option pdf par email
          IF StdGinkoia.apdfEmail.pdfByEmail THEN
          BEGIN
            //prévenir de la création du pdf
            StdGinkoia.InfoMess('', 'La version "pdf" est enregistrée dans le répertoire' + #13#10 +
              ExtractFilePath(Application.ExeName) + 'Pdf' + #13#10#13#10 +
              sNomExportPdf);
          END;

          IF OkW2Pdf THEN
          BEGIN
            Reg := TRegistry.Create;
            TRY
              TRY
                Reg.RootKey := HKey_CURRENT_USER; // Section à rechercher dans le registre
                IF Reg.OpenKey('Software\Dane Prairie Systems\Win2Pdf', FALSE) THEN
                  Reg.WriteString('PDFFileName', ExtractFilePath(Application.ExeName) + 'Pdf' + '\' + Nompdf);
              EXCEPT
              END;
            FINALLY
              Reg.CloseKey;
              Reg.Free;
            END;
          END;

          IF Frm_Common.ChargeRap(que_TetImp, Que_LineImp, que_Mags, True, FactRtm, HTPied) THEN
            Frm_Common.Imprime(Preview, ChxImp);

          IF (NOT Preview) AND ImpCdv THEN
          BEGIN
            TRY
              IF fileexists(ChemWinIni(ExtractFilePath(StdGinkoia.PathBase), 'FactureTxt.rtf')) THEN
              BEGIN
                pprich_cdv.LoadFromFile(ChemWinIni(ExtractFilePath(StdGinkoia.PathBase), 'FactureTxt.rtf'));
                IF Trim(pprich_cdv.RichText) <> '' THEN ppr_cdv.Print;
              END;
            EXCEPT
            END;
          END;

          Result := True;
        END
      END
      ELSE
      BEGIN
        IF OkW2Pdf THEN
        BEGIN
          Reg := TRegistry.Create;
          TRY
            TRY
              Reg.RootKey := HKey_CURRENT_USER; // Section à rechercher dans le registre
              IF Reg.OpenKey('Software\Dane Prairie Systems\Win2Pdf', FALSE) THEN
                Reg.WriteString('PDFFileName', ExtractFilePath(Application.ExeName) + 'Pdf' + '\' + Nompdf);
            EXCEPT
            END;
          FINALLY
            Reg.CloseKey;
            Reg.Free;
          END;
        END;

        IF Frm_Common.ChargeRap(que_TetImp, Que_LineImp, que_Mags, True, FactRtm, HtPied) THEN
          Frm_Common.Imprime(Preview, False);

        IF (NOT Preview) AND ImpCdv THEN
        BEGIN
          TRY
            IF fileexists(ChemWinIni(ExtractFilePath(StdGinkoia.PathBase), 'FactureTxt.rtf')) THEN
            BEGIN
              pprich_cdv.LoadFromFile(ChemWinIni(ExtractFilePath(StdGinkoia.PathBase), 'FactureTxt.rtf'));
              IF Trim(pprich_cdv.RichText) <> '' THEN ppr_cdv.Print;
            END;
          EXCEPT
          END;
        END;

        Result := True;
      END;

      IF que_TetImpFCE_MODELE.asInteger = 0 THEN
      BEGIN
        // car refresh datimp
        TRY
          if Frm_ListeFac<>nil then
            Frm_ListeFac.NeedRefresh := True;
          IF IdFac = que_TetFacFCE_ID.asInteger THEN
          BEGIN
            que_Datimp.Close;
            que_Datimp.Open;
            if Frm_NegFac<>nil then
              Frm_NegFac.Chp_Datimp.visible := NOT que_DatimpHTI_DATEIMP.isnull;
          END;
        EXCEPT
        END;
      END;
    FINALLY
      que_PgCum.Close;
      que_TetImp.close;
      que_LineImp.Close;
      que_Mags.Close;
    END;
  END;

END;

FUNCTION TDm_NegFac.SetParamImp: Boolean;
VAR
  ch: STRING;
  j: Integer;
BEGIN
  TxtFinFact := '';
  TxtFactor := TxtPmtFactor;
  TxtRgltDef := FacImpDateDef;
  LabFactor := '';
  Result := False;

  TRY
    Que_ParamIMP.Close;
    que_ParamIMP.ParamByName('MAGID').asInteger := StdGinkoia.MagasinID;
    Que_ParamIMP.Open;

    IF que_ParamImp.IsEmpty THEN
      StdGinKoia.InfoMess('', NeedParamimp)
    ELSE BEGIN
      Result := True;

      IF Que_ParamImp.Locate('PRM_CODE', 1, []) THEN
      BEGIN
        ch := que_ParamImpPRM_STRING.asstring;
        HtPied := que_ParamImpPRM_FLOAT.asFloat;
      END
      ELSE
      BEGIN
        FOR j := 1 TO 100 DO
          ch := ch + '1';
        HtPied := 11.642;
      END;

      IF ch[1] = '1' THEN
        ImpTete := True
      ELSE
        ImpTete := False;

      IF ch[2] = '1' THEN
        ImpPied := True
      ELSE
        ImpPied := False;

      IF ch[4] = '1' THEN
        ImpPg := True
      ELSE
        ImpPg := False;

      IF ch[41] = '1' THEN
        ImpTextePied := True
      ELSE
        ImpTextePied := False;

      IF ch[42] = '1' THEN
        ImpEuro := True
      ELSE
        ImpEuro := False;

      IF ch[3] = '1' THEN
        ImpPayMag := True
      ELSE
        ImpPayMag := False;

      IF ch[43] = '1' THEN
        ImpPayClt := True
      ELSE
        ImpPayClt := False;

      IF ch[44] = '1' THEN
        ImpCivClt := True
      ELSE
        ImpCivClt := False;

      IF ch[45] = '1' THEN
        ImpRem := True
      ELSE
        ImpRem := False;

      IF ch[46] = '1' THEN
        ImpVend := True
      ELSE
        ImpVend := False;

      IF ch[47] = '1' THEN
        ImpLine := True
      ELSE
        ImpLine := False;

      IF ch[49] = '1' THEN
        ImpTVA := True
      ELSE
        ImpTVA := False;

      IF ch[52] = '1' THEN
        ImpTailCoul := True
      ELSE
        ImpTailCoul := False;

      IF ch[53] = '1' THEN
        ImpCDV := True
      ELSE
        ImpCDV := False;

      IF Que_ParamImp.Locate('PRM_CODE', 4, []) THEN
        TxtFinFact := que_ParamImpPRM_STRING.asString;
      IF Que_ParamImp.Locate('PRM_CODE', 5, []) THEN
        TxtRgltDef := que_paramImpPRM_STRING.asString;
      IF Que_ParamImp.Locate('PRM_CODE', 7, []) THEN
        LabFactor := que_paramImpPRM_STRING.asString;
      IF Que_ParamImp.Locate('PRM_CODE', 8, []) THEN
        TxtFactor := que_paramImpPRM_STRING.asString;

    END;
  FINALLY
    Que_ParamImp.Close;
  END;

END;

PROCEDURE TDm_NegFac.Que_TetImpCalcFields(DataSet: TDataSet);
BEGIN
  IF que_TetImpCPA_CODE.asInteger = 1 THEN
    que_TetImpDateRglt.asdatetime := que_TetFac.FieldByName('FCE_REGLEMENT').asDateTime
  ELSE
    stdGinKoia.ChpDateRgltCODE(que_TetImpFCE_DATE.asDateTime, que_TetImpCPA_CODE.asInteger, que_TetImpDateRglt);

  IF que_TetImpFCE_DETAXE.asInteger = 1 THEN
  BEGIN
    que_TetImpTTCEURO.asFloat := RoundRv(que_TetImpTOTHT.asFloat, 2);
    que_TetImpSUMTTC.asFloat := RoundRv(que_TetImpTOTHT.asFloat, 2);
  END
  ELSE BEGIN
    que_TetImpTTCEURO.asFloat := RoundRv(que_TetImpTOTTTC.asFloat, 2);
    que_TetImpSUMTTC.asFloat := RoundRv(que_TetImpTOTTTC.asFloat, 2);
  END
END;

PROCEDURE TDm_NegFac.Clotarch(Archiver: Boolean);
BEGIN
  Que_TetFac.Edit;
  que_TetFacFCE_CLOTURE.asInteger := 1;
  que_TetFacFCE_NMODIF.asInteger := 1;
  IF Archiver THEN
    que_TetFacFCE_ARCHIVE.asInteger := 1;
  que_TetFac.Post;
END;

FUNCTION TDm_NegFac.CltHasFactor: Boolean;
BEGIN
  Result := False;
  IF que_Client.Active THEN
    Result := Trim(que_ClientCLT_NUMFACTOR.asstring) <> '';
END;

PROCEDURE TDm_NegFac.NextRec;
VAR
  id: Integer;
BEGIN
  Id := stdGinkoia.NextId(Que_TETFACFCE_ID.asInteger, 'NEGFACTURE');
  IF id <> 0 THEN OpenFac(Id);
END;

PROCEDURE TDm_NegFac.PriorRec;
VAR
  id: Integer;
BEGIN
  Id := stdGinkoia.PriorId(Que_TETFACFCE_ID.asInteger, 'NEGFACTURE');
  IF id <> 0 THEN OpenFac(Id);
END;

FUNCTION TDm_NegFac.IsModele: Boolean;
BEGIN
  Result := False;
  IF que_TetFac.active THEN
    Result := que_TetFACFCE_MODELE.asInteger = 1;
END;

FUNCTION TDm_NegFac.CreModele: Boolean;
BEGIN
  Result := False;
  MemD_Copy.Close;
  MemD_Copy.Open;
  Memd_Copy.SortedField := 'DocD';

  TRY
    screen.Cursor := crSqlWait;
    StdGinKoia.WaitMess(GenerModFacture);

    WITH Dm_Main DO
    BEGIN
      IBOCancelCache(Que_NeoDocT);
      IBOCancelCache(Que_NeoDocL);
      IBOCancelCache(Que_CptCltAbon);
    END;

    que_NeodocT.Close;
    que_NeoDocT.Open;
    que_NeodocL.Close;
    que_NeoDocL.Open;

    CopyDoc(Que_TetFacFCE_ID.asInteger, True);

  FINALLY

    StdGinKoia.WaitClose;
    screen.Cursor := crDefault;

    IF Memd_CopyOK.asInteger = 1 THEN
    BEGIN
      IF UpdateNeoDoc THEN
      BEGIN
        Result := True;
        StdGinKoia.InfoMess('', paramsStr(ModFactOk, vararrayOf([memd_CopyDocD.asstring, memd_CopyDocO.asstring])));
      END;
    END
    ELSE
      StdGinKoia.InfoMess('', paramsStr(ModFactPB, memd_CopyDocO.asstring));

    que_NeodocT.Close;
    que_NeodocL.Close;
    MemD_Copy.Close;

  END;
END;

PROCEDURE TDm_NegFac.GenereFac(Ts: Tstrings);
VAR
  i, nb: Integer;
BEGIN
  IF TS.Count = 0 THEN EXIT;
  TheDateAbon := Date;
  IF NOT ChxStdDate(Date - 30, 0, False, LibDatFacAbon, TheDateABON) THEN EXIT;

  nb := TS.Count - 1;

  MemD_Copy.Close;
  MemD_Copy.Open;
  Memd_Copy.SortedField := 'DocD';

  TRY

    screen.Cursor := crSqlWait;
    IF nb = 0 THEN // 1 seul doc
      StdGinKoia.WaitMess(GenerModFacture)
    ELSE
      StdGinKoia.InitGaugeBtn(GenerAbonFactures, nb + 1);
    // nb + 1 car l'incrémentation se fait avant copyDoc pour
    // intercepter avant tout si nécessaire ...

    WITH Dm_Main DO
    BEGIN
      IBOCancelCache(Que_NeoDocT);
      IBOCancelCache(Que_NeoDocL);
      IBOCancelCache(Que_CptCltAbon);
    END;

    que_NeodocT.Close;
    que_NeoDocT.Open;
    que_NeodocL.Close;
    que_NeoDocL.Open;
    que_CptCltAbon.Close;
    que_CptCltAbon.Open;

    FOR i := 0 TO Nb DO
    BEGIN
      IF nb > 0 THEN
        IF StdGinkoia.IncGaugeMess THEN BREAK;
      CopyDoc(StrToInt(TS[i]), False);
    END;

  FINALLY

    screen.Cursor := crDefault;
    IF nb = 0 THEN
      StdGinKoia.WaitClose
    ELSE
      StdGinKoia.CloseGaugeMess;

    IF UpdateNeoDoc THEN
    BEGIN
      Frm_ListeFac.NeedRefresh := True;
      IF NOT MemD_Copy.isEmpty THEN
      BEGIN
        Memd_Copy.First;
        ExecuteAbonRap(formatDateTime('dd/mm/yyyy', TheDateAbon));
      END;
    END;
    que_NeodocT.Close;
    que_NeodocL.Close;
    que_CptCltAbon.Close;
    MemD_Copy.Close;

  END;
END;

PROCEDURE TDm_NegFac.SupprimeAbon(Ts: Tstrings);
VAR
  i, nb: Integer;
BEGIN
  IF TS.Count = 0 THEN EXIT;

  nb := TS.Count - 1;

  TRY

    screen.Cursor := crSqlWait;
    StdGinKoia.WaitMess(SupprModFacture);

    FOR i := 0 TO Nb DO
    BEGIN
      TRY
        que_CopyDocT.Close;
        que_CopyDocT.ParamByName('FCEID').asInteger := StrToInt(TS[i]);
        que_CopyDocT.Open;

        que_CopyDocL.Close;
        que_CopyDocL.ParamByName('FCEID').asInteger := StrToInt(TS[i]);
        que_CopyDocL.Open;

        que_CopyDocL.First;
        WHILE NOT que_CopyDocL.Eof DO
          que_CopyDocL.Delete;
        que_CopyDocT.Delete;

        WITH Dm_Main DO
        BEGIN
          TRY
            StartTransaction;

            IBOUpDateCache(Que_CopyDocT);
            IBOUpDateCache(que_CopyDocL);

            Commit;
          EXCEPT
            Rollback;

            IBOCancelCache(Que_CopyDocT);
            IBOCancelCache(que_CopyDocL);
          END;

          IBOCOmmitCache(Que_CopyDocT);
          IBOCommitCache(que_CopyDocL);
        END;
      EXCEPT

      END;
    END;

  FINALLY

    screen.Cursor := crDefault;
    StdGinKoia.WaitClose;

    que_CopydocT.Close;
    que_CopydocL.Close;

  END;
END;

FUNCTION TDm_NegFac.UpdateNeoDoc: Boolean;
BEGIN
  WITH Dm_Main DO
  BEGIN
    TRY
      StartTransaction;

      IBOUpDateCache(Que_NeodocT);
      IBOUpDateCache(que_NeoDocL);

      IBOUpDateCache(que_CptCltAbon);

      Commit;
      Result := True;
    EXCEPT
      Result := False;
      Rollback;

      IBOCancelCache(Que_NeodocT);
      IBOCancelCache(que_NeoDocL);
      IBOCancelCache(que_CptCltAbon);

    END;

    IBOCOmmitCache(Que_NeoDocT);
    IBOCommitCache(que_NeoDocL);
    IBOCommitCache(que_CptCltAbon);

  END;
END;

PROCEDURE TDm_NegFac.CopyDoc(FCEID: Integer; Modele: Boolean);
VAR
  Lechro: STRING;
BEGIN
  IF FCEID <= 0 THEN EXIT;

  TRY
    IF Codasais = 0 THEN
    BEGIN
      //  Repérer les id de date à saisir cas impossible en abonnement
      TRY
        Ibc_CpaCode.Close;
        Ibc_CpaCode.ParamByName('CPACODE').asInteger := 1;
        Ibc_CpaCode.Open;
        IF NOT Ibc_CpaCode.Eof THEN
          Codasais := Ibc_CpaCode.FieldByName('CPA_ID').asInteger;
      FINALLY
        Ibc_CpaCode.Close;
      END;

      //  Repérer les id de date à saisir cas impossible en abonnement
      TRY
        Ibc_CpaCode.Close;
        Ibc_CpaCode.ParamByName('CPACODE').asInteger := 2;
        Ibc_CpaCode.Open;
        IF NOT Ibc_CpaCode.Eof THEN
          Codarecep := Ibc_CpaCode.FieldByName('CPA_ID').asInteger;
      FINALLY
        Ibc_CpaCode.Close;
      END;
    END;

    // je pointe sur les docs à copier
    que_CopyDocT.Close;
    que_CopyDocT.ParamByName('FCEID').asInteger := FCEID;
    que_CopyDocT.Open;

    que_CopyDocL.Close;
    que_CopyDocL.ParamByName('FCEID').asInteger := FCEID;
    que_CopyDocL.Open;

    IF NeoDoc(Modele, LeChro) THEN
    BEGIN
      Memd_Copy.Insert;
      MemD_CopyDOCO.asstring := que_CopyDocTFCE_NUMERO.asstring;
      MemD_CopyDocD.asstring := LeChro;
      MemD_CopyAction.asstring := GenerFacAbonOk;
      Memd_CopyOk.asInteger := 1;
      Memd_CopyNom.asstring := que_CopyDocTFCE_CLTNOM.asstring + ' ' + que_CopyDocTFCE_CLTPRENOM.asstring;
      MemD_Copy.Post;
    END
    ELSE
    BEGIN
      Memd_Copy.Insert;
      MemD_CopyDOCO.asstring := que_CopyDocTFCE_NUMERO.asstring;
      MemD_CopyDocD.asstring := '';
      MemD_CopyAction.asstring := GenerFacAbonPB;
      Memd_CopyOk.asInteger := 0;
      Memd_CopyNom.asstring := que_CopyDocTFCE_CLTNOM.asstring + ' ' + que_CopyDocTFCE_CLTPRENOM.asstring;
      MemD_Copy.Post;
    END;
  FINALLY
    Que_CopyDocT.Close;
    Que_CopyDocL.Close;
  END;
END;

FUNCTION TDm_NegFac.NeoDoc(Modele: Boolean; VAR ChronoDoc: STRING): Boolean;
VAR
  ExIdST, NeoIdST: Integer;
  err, i: Integer;
  TheTotal: extended;
  t: TdateTime;
BEGIN

  err := 0;
  TheTotal := 0;
  ChronoDoc := '';
  Result := False;

  IF NOT que_CopyDocT.Active THEN EXIT;
  TRY

    que_NeoDocT.Insert;

    IF NOT Dm_Main.IBOMajPkKey(que_NeoDocT, que_NeoDocT.KeyLinks.IndexNames[0]) THEN
      Err := 1;

    IF err = 0 THEN
    BEGIN

      TRY

        WITH que_NeoDocT DO
        BEGIN

          IF Modele THEN
          BEGIN
            fieldBYName('FCE_MODELE').asInteger := 1;
            fieldBYName('FCE_DATE').asDateTime := Date;
            // les modèles ont la date du jour de leur génération

            IbStProc_ChronoMod.Close;
            IbStProc_ChronoMod.Prepared := True;
            TRY
              IbStProc_ChronoMod.ExecProc;
              fieldBYName('FCE_NUMERO').asString := IbStProc_ChronoMod.Fields[0].asString;
            FINALLY
              IbStProc_ChronoMod.Close;
              IbStProc_ChronoMod.Unprepare;
            END;
          END
          ELSE
          BEGIN
            fieldBYName('FCE_MODELE').asInteger := 0;
            fieldBYName('FCE_DATE').asDateTime := TheDateABON;

            IbStProc_Chrono.Close;
            IbStProc_Chrono.Prepared := True;
            TRY
              IbStProc_Chrono.ExecProc;
              fieldBYName('FCE_NUMERO').asString := IbStProc_Chrono.Fields[0].asString;
            FINALLY
              IbStProc_Chrono.Close;
              IbStProc_Chrono.Unprepare;
            END;
          END;
          fieldBYName('FCE_CATEG').asInteger := Que_CopyDocTFCE_CATEG.Asinteger;
          fieldBYName('FCE_MAGID').asInteger := Que_CopyDocTFCE_MAGID.Asinteger;
          fieldBYName('FCE_CLTID').asInteger := Que_CopyDocTFCE_CLTID.Asinteger;
          fieldBYName('FCE_FACTOR').asInteger := Que_CopyDocTFCE_FACTOR.Asinteger;
          fieldBYName('FCE_TYPID').asInteger := Que_CopyDocTFCE_TYPID.Asinteger;

          fieldBYName('FCE_USRID').asInteger := Que_CopyDocTFCE_USRID.Asinteger;
          fieldBYName('FCE_CLTNOM').asString := Que_CopyDocTFCE_CLTNOM.asstring;
          fieldBYName('FCE_CLTPRENOM').asString := Que_CopyDocTFCE_CLTPRENOM.AsString;
          fieldBYName('FCE_CIVID').asInteger := Que_CopyDocTFCE_CIVID.Asinteger;
          fieldBYName('FCE_VILID').asInteger := Que_CopyDocTFCE_VILID.Asinteger;
          fieldBYName('FCE_ADRLIGNE').asString := Que_CopyDocTFCE_ADRLIGNE.asstring;
          fieldBYName('FCE_MRGID').asInteger := Que_CopyDocTFCE_MRGID.Asinteger;
          fieldBYName('FCE_COMENT').asString := Que_CopyDocTFCE_COMENT.AsString;
          fieldBYName('FCE_PRO').asInteger := Que_CopyDocTFCE_PRO.AsInteger;

          fieldBYName('FCE_DETAXE').asInteger := Que_CopyDocTFCE_DETAXE.Asinteger;
          fieldBYName('FCE_PRENEUR').asString := Que_CopyDocTFCE_PRENEUR.asstring;
          fieldBYName('FCE_REMISE').asFloat := Que_CopyDocTFCE_Remise.asFloat;

          IF Que_CopyDocTFCE_CPAID.Asinteger = CodaSais THEN
            fieldBYName('FCE_CPAID').asInteger := Codarecep
          ELSE
            fieldBYName('FCE_CPAID').asInteger := Que_CopyDocTFCE_CPAID.Asinteger;

          fieldBYName('FCE_TVAHT1').asFloat := Que_CopyDocTFCE_TVAHT1.AsFloat;
          fieldBYName('FCE_TVATAUX1').asFloat := Que_CopyDocTFCE_TVATAUX1.AsFloat;
          fieldBYName('FCE_TVA1').asFloat := Que_CopyDocTFCE_TVA1.AsFloat;
          fieldBYName('FCE_TVAHT2').asFloat := Que_CopyDocTFCE_TVAHT2.AsFloat;
          fieldBYName('FCE_TVATAUX2').asFloat := Que_CopyDocTFCE_TVATAUX2.AsFloat;
          fieldBYName('FCE_TVA2').asFloat := Que_CopyDocTFCE_TVA2.AsFloat;
          fieldBYName('FCE_TVAHT3').asFloat := Que_CopyDocTFCE_TVAHT3.AsFloat;
          fieldBYName('FCE_TVATAUX3').asFloat := Que_CopyDocTFCE_TVATAUX3.AsFloat;
          fieldBYName('FCE_TVA3').asFloat := Que_CopyDocTFCE_TVA3.AsFloat;
          fieldBYName('FCE_TVAHT4').asFloat := Que_CopyDocTFCE_TVAHT4.AsFloat;
          fieldBYName('FCE_TVATAUX4').asFloat := Que_CopyDocTFCE_TVATAUX4.AsFloat;
          fieldBYName('FCE_TVA4').asFloat := Que_CopyDocTFCE_TVA4.AsFloat;
          fieldBYName('FCE_TVAHT5').asFloat := Que_CopyDocTFCE_TVAHT5.AsFloat;
          fieldBYName('FCE_TVATAUX5').asFloat := Que_CopyDocTFCE_TVATAUX5.AsFloat;
          fieldBYName('FCE_TVA5').asFloat := Que_CopyDocTFCE_TVA5.AsFloat;
          fieldBYName('FCE_MARGE').asFloat := Que_CopyDocTFCE_Marge.AsFloat;
          fieldBYName('FCE_HTWORK').asInteger := Que_CopyDocTFCE_HTWORK.AsInteger;

          // FCE_REGLEMENT Reste à nul car date à saisir est non valide dans ce cas
          fieldBYName('FCE_NMODIF').asInteger := 0;
          fieldBYName('FCE_CLOTURE').asInteger := 0;
          fieldBYName('FCE_ARCHIVE').asInteger := 0;

          Post;
        END;

        ExIdST := 0;
        NeoIdST := 0;

        Que_CopyDocL.First;
        WHILE NOT Que_CopyDocL.eof DO
        BEGIN

          WITH que_NeoDocL DO
          BEGIN

            Insert;

            // id de la ligne

            IF NOT Dm_Main.IBOMajPkKey(que_NeoDocL, que_NeoDocL.KeyLinks.IndexNames[0]) THEN
            BEGIN
              err := 2;
              BREAK;
            END;

            fieldBYName('FCL_FCEID').asInteger := que_NeoDocT.fieldByName('FCE_ID').asInteger;
            fieldBYName('FCL_ARTID').asInteger := Que_CopyDocLFCL_ARTID.AsInteger;
            fieldBYName('FCL_TGFID').asInteger := Que_CopyDocLFCL_TGFID.AsInteger;
            fieldBYName('FCL_COUID').asInteger := Que_CopyDocLFCL_COUID.AsInteger;
            fieldBYName('FCL_NOM').asString := Que_CopyDocLFCL_NOM.asString;
            fieldBYName('FCL_USRID').asInteger := Que_CopyDocLFCL_USRID.AsInteger;
            fieldBYName('FCL_QTE').asFloat := Que_CopyDocLFCL_QTE.AsFloat;
            fieldBYName('FCL_PXBRUT').asFloat := Que_CopyDocLFCL_PXBRUT.AsFloat;
            fieldBYName('FCL_PXNET').asFloat := Que_CopyDocLFCL_PXNET.AsFloat;
            fieldBYName('FCL_PXNN').asFloat := Que_CopyDocLFCL_PXNN.AsFloat;

            IF Que_CopyDocLFCL_LINETIP.AsInteger = 3 THEN
            BEGIN // ST
              ExIdST := Que_CopyDocLFCL_ID.asInteger;
              NeoIdST := fieldBYName('FCL_ID').asInteger;
            END;

            IF (Que_CopyDocLFCL_SSTOTAL.asInteger <> 0) AND (Que_CopyDocLFCL_SSTOTAL.asInteger = ExIdSt) THEN
              fieldBYName('FCL_SSTOTAL').asInteger := NeoIdST
            ELSE
              fieldBYName('FCL_SSTOTAL').asInteger := 0;

            IF Que_CopyDocLFCL_LINETIP.asInteger = 4 THEN // fin de ST
            BEGIN
              ExIdST := 0;
              NeoIdST := 0;
            END;

            fieldBYName('FCL_INSSTOTAL').asInteger := Que_CopyDocLFCL_INSSTOTAL.AsInteger;
            fieldBYName('FCL_GPSSTOTAL').asInteger := Que_CopyDocLFCL_GPSSTOTAL.AsInteger;
            fieldBYName('FCL_TVA').asFloat := Que_CopyDocLFCL_TVA.AsFloat;
            fieldBYName('FCL_COMENT').asString := Que_CopyDocLFCL_COMENT.AsString;
            fieldBYName('FCL_BLLID').asInteger := 0;
            fieldBYName('FCL_TYPID').asInteger := Que_CopyDocLFCL_TYPID.asInteger;
            fieldBYName('FCL_LINETIP').asInteger := Que_CopyDocLFCL_LINETIP.AsInteger;
            fieldBYName('FCL_FROMBLL').asInteger := 0;
            fieldBYName('FCL_VALREMGLO').asInteger := Que_CopyDocLFCL_VALREMGLO.AsInteger;

            // FCL_DATEBLL' reste à null car pas généré depuis BL

            Post;
          END;

          Que_CopyDocL.Next;

        END;

        IF (NOT Modele) THEN
        BEGIN
          // Les comptes clients
          FOR i := 1 TO 5 DO
            TheToTal := TheTotal + que_NeoDocT.FieldByName('FCE_TVAHT' + IntToStr(i)).asFloat;

          WITH que_CptCltAbon DO
          BEGIN
            Insert;

            IF NOT Dm_Main.IBOMajPkKey(que_CptCltAbon, 'CTE_ID') THEN
              err := 3
            ELSE
            BEGIN

              fieldByName('CTE_CLTID').asInteger := que_NeoDocT.FieldByName('FCE_CLTID').asInteger;
              fieldByName('CTE_MAGID').asInteger := que_NeoDocT.FieldByName('FCE_MAGID').asInteger;
              fieldByName('CTE_DATE').asDateTime := que_NeoDocT.FieldByName('FCE_DATE').asDateTime;

              fieldByName('CTE_DEBIT').asFloat := TheTotal;
              fieldByName('CTE_TKEID').asInteger := 0;
              fieldByName('CTE_TYP').asInteger := 0;
              fieldByName('CTE_ORIGINE').asInteger := 1;
              fieldByName('CTE_FCEID').asInteger := que_NeoDocT.FieldByName('FCE_ID').asInteger;

              fieldByName('CTE_Libelle').asString := FacLib + ' :' + que_NeoDocT.fieldByName('FCE_NUMERO').asString;

              t := stdGinkoia.DateRgltID(que_NeoDocT.FieldByName('FCE_DATE').asDateTime, que_NeoDocT.FieldByName('FCE_CPAID')
                .asInteger);
              IF t = 0 THEN T := Date;
              FieldByName('CTE_REGLER').asDateTime := T;

              Post;
            END;
          END;
        END;

      EXCEPT
        err := 7;
      END;

    END;

  FINALLY

    IF err = 0 THEN
    BEGIN
      ChronoDoc := que_NeoDocTFCE_NUMERO.asString;
      Result := True;
    END;

  END;

END;

PROCEDURE TDm_NegFac.Que_ListeFacModCalcFields(DataSet: TDataSet);
BEGIN
  que_ListeFacModTOTHT.asfloat :=
    que_ListeFacModTTC.asfloat - que_ListeFacModTVA.asFloat;
END;

// ---------------------> Procedures Revues
// -------------------- Routines internes ------------------------------

PROCEDURE TDm_NegFac.GetTextEuro(Sender: TField;
  VAR Text: STRING; DisplayText: Boolean);
BEGIN
  Text := StdGinkoia.Convert((Sender AS TField).AsFloat)
END;

PROCEDURE TDm_NegFac.DMUserVM(Uvm, UVT: Boolean);
VAR
  leTvtId: Integer;
BEGIN
  UserVM := UVM;
  UserVisuTarifs := UVT;

  IF que_TVT.Active THEN
    LeTvtId := que_TVTTVT_ID.asInteger
  ELSE
    LeTvtId := StdGinkoia.iniCtrl.ReadInteger('NEGOCE', 'TARIF', StdGinkoia.TVTID);

  que_TVT.Close;
  que_TVT.Open;
  IF UserVisuTarifs THEN
    // à corriger quand droit viu tarifs existant,
    que_TVT.Locate('TVT_ID', LeTvtId, [])
  ELSE
    que_TVT.Locate('TVT_ID', StdGinkoia.TVTID, []);
  // dans ce contexte l'user ne peut pas changer l'enreg courant puisque pas
  // de bouton correspondant dans la forme et donc pointe tjrs sur tarif en cours du mag
END;

PROCEDURE TDm_NegFac.AssigneFiche(MaFiche: TObject);
BEGIN
  Frm_NegFac := (MaFiche AS TFrm_NegFac);
END;

PROCEDURE TDm_NegFac.InitTabTaux;
VAR
  i: Integer;
BEGIN
  // J'initialise le tableau de référence des taux de TVA de l'entête
  FOR i := 1 TO 5 DO TabTaux[i] := -1;
  IF NOT que_TetFac.IsEmpty THEN
  BEGIN
    FOR i := 1 TO 5 DO
    BEGIN
      IF que_TetFac.fieldByName('FCE_TVAHT' + IntToStr(i)).asFloat <> 0 THEN
        TabTaux[i] := que_TetFac.fieldByName('FCE_TVATAUX' + IntToStr(i)).asfloat;
    END;
  END;
END;

FUNCTION TDm_NegFac.GetIndiceTaux(TxTva: Double): Integer;
VAR
  i: Integer;
BEGIN
  // retourne l'indice correspondant au taux de TVA
  // crée l'indice si n'existe pas
  Result := -1;
  FOR i := 1 TO 5 DO
  BEGIN
    IF TabTaux[i] = TxTva THEN
    BEGIN
      Result := i;
      BREAK;
    END;
  END;
  IF Result = -1 THEN
  BEGIN
    FOR i := 1 TO 5 DO
    BEGIN
      IF TabTaux[i] = -1 THEN
      BEGIN
        Result := i;
        TabTaux[i] := TxTVA;
        BREAK;
      END;
    END;
  END;
END;

PROCEDURE TDm_NegFac.MajEntete;
VAR
  Flag: Boolean;
BEGIN
  OnMajTete := True;
  Flag := False;
  IF NOT MemD_Cums.Active THEN
    MemD_Cums.Open;
  IF NOT (MemD_Cums.State IN [dsInsert, dsEdit]) THEN
  BEGIN
    MemD_Cums.Edit;
    Flag := True;
  END;

  WITH Frm_CalcEntet DO
  BEGIN
    MemD_CumsCUMBR.asfloat := GetCUMBeforeRem;
    MemD_CumsCUMHT.asfloat := GetCUMHT;
    MemD_CumsCUMTTC.asfloat := GetCUMTTC;
  END;
  MemD_CumsCUMMARGE.asFloat := RoundRv(Sum_LineFac.SumCollection[0].SumValue, 2);
  IF DoInitEntet THEN
    MemD_CumsTEMMODIF.asInteger := 0
  ELSE BEGIN
    IF ISHT THEN
    BEGIN
      IF MemD_CumsCUMBR.asfloat <> MemD_CumsCUMHT.asfloat THEN
        que_TetFACFCE_REMISE.asFloat := GetRemise(MemD_CumsCUMBR.asfloat, MemD_CumsCUMHT.asfloat, 5);
    END
    ELSE BEGIN
      IF MemD_CumsCUMBR.asfloat <> MemD_CumsCUMTTC.asfloat THEN
        que_TetFACFCE_REMISE.asFloat := GetRemise(MemD_CumsCUMBR.asfloat, MemD_CumsCUMTTC.asfloat, 5);
    END;

    MemD_CumsTEMMODIF.asInteger := 1;
  END;

  IF Flag THEN MemD_Cums.Post;
  OnMajtete := False;
END;

// --------------------- Tête de facture ----------------------------

PROCEDURE TDm_NegFac.Que_TetFACAfterScroll(DataSet: TDataSet);
VAR
  i              : Integer;
  bModFusion     : boolean;   //Passe à true si la facture contient un modèle fusionné
BEGIN

  DoInitEntet := True;
  TRY
    bDelLot := False;

    Memd_Stk.Close;
    Memd_Cums.Close;
    IsHT := (que_TetFacFCE_HTWORK.asInteger = 1);
    InitTabTaux;
    // Initialisation du tableau de TVA en fonction du document

    Frm_NegFac.SetStateHTTTC;
    Frm_NegFac.Chp_TOTTTC.ReadOnly := IsHT;
    Frm_NegFac.Chp_TOTHT.ReadOnly := NOT IsHT;

    que_LineFac.Close;
    que_LineFac.ParamByName('FCEID').asInteger := Que_TetFacFCE_ID.AsInteger;
    que_LineFac.Open;

    que_Client.Close;
    que_Client.ParamByName('CLTID').asInteger := que_TetFacFCE_CLTID.AsInteger;
    que_Client.Open;

    que_CltMembrePro.Close;
    que_CltMembrePro.ParamByName('CLTID').asInteger := que_TetFacFCE_CLTID.AsInteger;
    que_CltMembrePro.Open;

    frm_NegFac.DBG_LineFac.FullExpand;
    Frm_NegFac.SetLabEtat;
    Frm_NegFAC.Chp_chrono.Text := que_TetFACFCE_NUMERO.asString;
    Frm_NegFAC.Chp_chrono.SelectAll;

    // optimsation de validation n'effectue le ctrle de type client que si <> de mempro
    MemPro := que_TetFACFCE_PRO.asInteger;

    // affichage de la date de dernière impression courrier
    que_Datimp.Close;
    que_Datimp.ParamByName('FCEID').asInteger := que_TetFACFCE_ID.asInteger;
    que_Datimp.Open;

    WITH Frm_NegFac DO
    BEGIN
      Nbt_PortWeb.Visible := que_TetFacFce_WEB.asInteger = 1;
      //            Nbt_DoCredit.Visible := que_TetFacFCE_WEB.asInteger = 1;

      Chp_Datimp.visible := NOT que_DatimpHTI_DATEIMP.isnull;
      Chp_Detaxe.Visible := IsHT;
      Chp_Web.Visible := que_TetFacFCE_WEB.asInteger = 1;

      IF (IsHT = StdGinkoia.GlossaireHT) AND (Frm_NegFac.Gax_UserCModif.Visible) THEN
      BEGIN
        Nbt_BtnGlo.Visible := True;
        Nbt_Glossaire.Visible := True;
      END
      ELSE BEGIN
        Nbt_BtnGlo.Visible := False;
        Nbt_Glossaire.Visible := False;
      END;
    END;

    // Chargement du tableur d'entête
    WITH Frm_CalcEntet DO
    BEGIN // unité de gestion d'entête...
      SetNeoCalc(Que_TetFacFCE_HTWork.AsInteger);
      SetRemGlo(Que_tetFacFCE_REMISE.asFloat);
      FOR i := 1 TO 5 DO
      BEGIN
        // le tableau a été initialisé avec les bons indices correspondants
        // double algo pour récup d'éventuels PB antérieurs...
        IF (que_TetFac.FieldByName('FCE_TVAHT' + IntToStr(i)).asFloat <> 0) OR
          ((que_TetFac.FieldByName('FCE_TVAHT' + IntToStr(i)).asFloat = 0) AND
          (que_TetFac.FieldByName('FCE_TVATAUX' + IntToStr(i)).asFloat <> 0)) THEN
          SetPlusMontant(Sum_LineFac.SumCollection[i].sumValue, que_TetFac.FieldByName('FCE_TVATAUX' + IntToStr(i))
            .asFloat);
      END;
      // Initialisation des champs calculés
      MajEntete;
    END;

    Frm_NegFAC.SetContextModele;

    //Verrouillage de la création d'avoir si modèle fusionné
    bModFusion  := False;
    que_LineFac.DisableControls;
    Que_LineFac.First;
    while Not Que_LineFac.eof and Not bModFusion do
    begin
      bModFusion  := Que_LineFac.FieldByName('ART_FUSARTID').asInteger>0;
      Que_LineFac.Next;
    end;
    Que_LineFac.First;
    Frm_NegFac.Nbt_Avoir.Enabled  := Not bModFusion;
  FINALLY
    que_LineFac.EnableControls;
    IF IsHT THEN
    BEGIN
      Que_LineFACMTLINE.MinValue := -770000;
      Que_LineFACMTLINE.MaxValue := 770000;
    END
    ELSE BEGIN
      Que_LineFACMTLINE.MinValue := -920000;
      Que_LineFACMTLINE.MaxValue := 920000;
    END;

    DoInitEntet := False;
    Frm_NegFac.SetContextSaisie;
  END;

END;

PROCEDURE TDm_NegFac.Que_TetFACAfterPost(DataSet: TDataSet);
BEGIN
  IF DoInitEntet THEN EXIT;
  DoPostLine := False;
  DoCalcline := False;
  DoBeforePostLine := False;

  TRY
    Screen.Cursor := crSQLWait;
    WITH Dm_Main DO
    BEGIN
      TRY
        StartTransaction;

        IBOUpDateCache(Que_TetFac);
        IBOUpDateCache(que_LineFac);
        IBOUpDateCache(que_Datimp);
        IF que_RelDest.Active AND que_RelDest.UpdatesPending THEN
          IBOUpDateCache(que_RelDest);
        IBOUpDateCache(que_CptClt);

        Commit;
      EXCEPT
        Rollback;

        IBOCancelCache(Que_TetFac);
        IBOCancelCache(que_LineFac);
        IBOCancelCache(que_Datimp);
        IF que_RelDest.Active THEN
          IBOCancelCache(que_RelDest);
        IBOCancelCache(que_CptClt);
      END;

      IBOCOmmitCache(Que_TetFac);
      IBOCommitCache(que_LineFac);
      IBOCommitCache(que_Datimp);
      IF que_RelDest.Active THEN
        IBOCommitCache(que_RelDest);
      IBOCommitCache(que_CptClt);

    END;
  FINALLY
    que_RelDest.Close; // Inutile de le garder ouvert !

    IsRefresh := False;
    DoPostLine := True;
    DoBeforePostLine := True;
    DoCalcline := True;       

    // Remet le tarif où l'on était avant la création Web Manuel
    if bCreationWebManu then
      Que_TVT.Locate('TVT_ID', iSavTarif, []);

    iSavTarif := 0;
    bCreationWebManu := false;   // Creation Fact Web Manuel

    OnNewRec := False;

    OpenFac(que_TetFacFCE_Id.asInteger);
    IF IsModele THEN
      Frm_ListeFacMod.NeedRefresh := True
    ELSE
      Frm_ListeFac.NeedRefresh := True;

    Screen.Cursor := crDefault;

    WITH Frm_NegFac DO
    BEGIN
      IF Nbt_ShowTete.Pressed THEN
      BEGIN
        Nbt_ShowTeteClick(NIL);
        Nbt_ShowTete.Pressed := False;
      END;
      Pan_FdTete.Height := Pan_FdTete.Constraints.MaxHeight;

      IF chp_Chrono.enabled THEN Chp_Chrono.SetFocus;
    END;

    OnNewLine := False;
    NeoComent := 0;
    LineModified := False;

    frm_negFac.SetContextSaisie;

  END;

END;

PROCEDURE TDm_NegFac.Que_TetFACAfterCancel(DataSet: TDataSet);
BEGIN
  DoPostLine := False;
  DoCalcline := False;
  DoBeforePostLine := False;

  TRY
    Screen.Cursor := crSQLWait;
    WITH Dm_Main DO
    BEGIN
      IBOCancelCache(Que_TetFac);
      IBOCancelCache(que_LineFac);
      IF que_RelDest.Active THEN
        IBOCancelCache(que_RelDest);

      IBOCancelCache(que_CptClt);

      IBOCommitCache(Que_TetFac);
      IBOCommitCache(que_LineFac);
      IBOCommitCache(que_CptClt);
    END;

  FINALLY
    que_RelDest.Close; // Inutile de le garder ouvert ...

    IsRefresh := False;
    OnNewLine := False;
    OnNewRec := False;
    DoPostLine := True;
    DoCalcline := True;
    DoBeforePostLine := True;

    // Remet le tarif où l'on était avant la création Web Manuel
    if bCreationWebManu then
      Que_TVT.Locate('TVT_ID', iSavTarif, []);

    iSavTarif := 0;
    bCreationWebManu := false;   // Creation Fact Web Manuel

    OpenFac(que_TetFacFCE_Id.asInteger);
    Screen.Cursor := crDefault;

    WITH Frm_NegFac DO
    BEGIN
      IF Nbt_ShowTete.Pressed THEN
      BEGIN
        Nbt_ShowTeteClick(NIL);
        Nbt_ShowTete.Pressed := False;
      END;
      Pan_FdTete.Height := Pan_FdTete.Constraints.MaxHeight;
      IF chp_chrono.Enabled THEN Chp_Chrono.SetFocus;
    END;

    NeoComent := 0;
    LineModified := False;

    frm_negFac.SetContextSaisie;

  END;
END;

PROCEDURE TDm_NegFac.Que_TetFACAfterEdit(DataSet: TDataSet);
BEGIN
  IF (NOT DoInitEntet) AND (NOT IsRefresh) THEN
    IF Frm_NegFac.Chp_Rech.Enabled AND Frm_NegFac.Chp_Rech.Visible THEN Frm_NegFac.Chp_Rech.SetFocus;
END;

PROCEDURE TDm_NegFac.Que_TetFACBeforeDelete(DataSet: TDataSet);
BEGIN
  ABORT;
END;

procedure TDm_NegFac.Que_TetFACBeforeEdit(DataSet: TDataSet);
begin
  //Date dans un exercice comptable clôturé
  if not(StdGinKoia.CtrlExerciceComptable(que_TetFac.fieldbyname('FCE_MAGID').AsInteger,
                                          que_TetFac.fieldbyname('FCE_DATE').AsDateTime)) then
  begin
    StdGinKoia.DelayMess(RS_ERR_DateDansUnExeComptableClot, 3);
    Frm_NegFac.Pan_fdTete.Height := Frm_NegFac.Pan_fdTete.Constraints.MaxHeight;
    IF Frm_NegFac.Chp_Chrono.Visible AND Frm_NegFac.Chp_Chrono.Enabled THEN
      Frm_NegFac.Chp_Chrono.SetFocus;
    Abort;
    Exit;
  end;

  // On edite la facture, on mémorise son montant pour le calcul d'encours
  fMontantBeforeEdit := MemD_CumsCUMTTC.asfloat;
end;

PROCEDURE TDm_NegFac.Que_TetFACNewRecord(DataSet: TDataSet);
BEGIN
  IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
    (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;

  TRY
    Memd_Cums.Close;
    Memd_Cums.Open;

    OnMajTete := True;
    // sinon effet de bord de recalculs entête
    OnNewRec := True;

    // Init montant de la facture BL à 0;
    fMontantBeforeEdit := 0;

    Que_TetFacFCE_NUMERO.asString := NegFacCroPro;

    // champs plus gées laissés par compatibilité
    Que_TetFacFCE_PRENEUR.asString := '';

    // Magasin courant par défaut...
    Que_TetFacFCE_MAGID.asInteger := StdGinKoia.MagasinId;
    Que_TetFacMAG_ENSEIGNE.asString := StdGinKoia.MagasinEnseigne;

    IF Que_TetFac.Tag = 0 THEN
    BEGIN
      Que_TetFacFCE_TYPID.asInteger := TipFacNormal;
      Que_TetFacTYP_LIB.asString := LibFacNormal;
    END
    ELSE
    BEGIN
      Que_TetFacFCE_TYPID.asInteger := TipFacRetro;
      Que_TetFacTYP_LIB.asString := LibFacRetro;
      Que_TetFac.Tag := 0;
    END;

    IF IsHt THEN
      Que_TetFacFCE_HTWORK.asInteger := 1
    ELSE
      Que_TetFacFCE_HTWORK.asInteger := 0;

    // Type normal par defaut
    Que_TetFacFCE_WEB.asInteger := 0; // crées que en automatique

    Que_TetFacFCE_FACTOR.asInteger := 0;
    Que_TetFacFCE_MODELE.asInteger := 0;
    Que_TetFacFCE_PRO.asInteger := 0;
    Que_TetFacFCE_CLTID.asInteger := 0;
    Que_TetFacFCE_DATE.asDateTime := Date;
    Que_TetFacFCE_REMISE.asFloat := 0;
    Que_TetFacFCE_DETAXE.asInteger := 0;

    Que_TetFacFCE_TVAHT1.asFloat := 0;
    Que_TetFacFCE_TVATAUX1.asFloat := 0;
    Que_TetFacFCE_TVA1.asFloat := 0;

    Que_TetFacFCE_TVAHT2.asFloat := 0;
    Que_TetFacFCE_TVATAUX2.asFloat := 0;
    Que_TetFacFCE_TVA2.asFloat := 0;

    Que_TetFacFCE_TVAHT3.asFloat := 0;
    Que_TetFacFCE_TVATAUX3.asFloat := 0;
    Que_TetFacFCE_TVA3.asFloat := 0;

    Que_TetFacFCE_TVAHT4.asFloat := 0;
    Que_TetFacFCE_TVATAUX4.asFloat := 0;
    Que_TetFacFCE_TVA4.asFloat := 0;

    Que_TetFacFCE_TVAHT5.asFloat := 0;
    Que_TetFacFCE_TVATAUX5.asFloat := 0;
    Que_TetFacFCE_TVA5.asFloat := 0;

    Que_TetFacFCE_CLOTURE.asInteger := 0;
    Que_TetFacFCE_ARCHIVE.asInteger := 0;
    Que_TetFacFCE_USRID.asInteger := 0;

    Que_TetFacFCE_CLTNOM.asString := '';
    Que_TetFacFCE_CLTPRENOM.asString := '';
    Que_TetFacFCE_CIVID.asInteger := 0;
    Que_TetFacFCE_VILID.asInteger := 0;
    Que_TetFacFCE_ADRLIGNE.asString := '';
    Que_TetFacFCE_MRGID.asInteger := 0;
    Que_TetFacFCE_CPAID.asInteger := 0;
    Que_TetFacFCE_NMODIF.asInteger := 0;
    Que_TetFacFCE_COMENT.asString := '';
    Que_TetFacFCE_MARGE.asFloat := 0;
    Que_TetFacFCE_CATEG.asInteger := 0;
    Que_TetFacCATEGORIE.asString := '';

    // Champs associés
    Que_TetFacCPA_CODE.asInteger := 0;
    Que_TetFacCPA_NOM.asString := '';
    Que_TetFacMRG_LIB.asString := '';
    Que_TetFacUSR_USERNAME.asString := '';
    Que_TetFacCIV_NOM.asString := '';
    Que_TetFacVIL_NOM.asString := '';
    Que_TetFacVIL_CP.asString := '';
    Que_TetFacPAY_NOM.asString := '';
    Que_TetFacCLT_NUMERO.asString := '';

    WITH Frm_NegFac DO
    BEGIN
      IF Nbt_ShowTete.Pressed THEN
      BEGIN
        Nbt_ShowTeteClick(NIL);
        Nbt_ShowTete.Pressed := False;
      END;
      Pan_FdTete.Height := Pan_FdTete.Constraints.MaxHeight;
      IF Chp_Date.Visible AND Chp_Date.Enabled THEN
        Chp_Date.SetFocus
      ELSE
        IF Chp_Nom.Visible AND Chp_Nom.Enabled THEN
          Chp_Nom.SetFocus;

    END;
  FINALLY
    OnMajTete := False;
  END;
END;

FUNCTION TDm_NegFac.ConfPost: Boolean;
VAR
  t: TDateTime;
  nothing, done: Boolean;
  DateMigre: TDateTime;
  lMaxEncours: currency;
BEGIN
  Result := True; // par défaut ne fera pas le post
  Done := False;
  Nothing := False;

  IF Frm_NegFac.Chp_Chrono.Enabled THEN Frm_NegFac.Chp_Chrono.SetFocus;
  // Force la validation du champ en cours

  IF (Tim_Focus.Tag <> 0) OR OnCalcSt THEN EXIT;
  // si des fois y'aurait un recalcul en cours par le timer ...

  // si facture de type regul alors non !
  if (Que_TetFACFCE_TYPID.AsInteger = TipFacRegul) then
    exit;

  IF NOT (Que_TetFac.State IN [dsInsert]) THEN
  BEGIN
    IF Que_TetFac.updatesPending OR Que_TetFac.Modified THEN Done := True;
  END
  ELSE Done := TRue;
  IF LineModified THEN Done := True;

  IF Done THEN
  BEGIN

    IF Que_TetFacFCE_MAGID.asInteger = 0 THEN
    BEGIN
      StdGinKoia.DelayMess(FactNoMag, 3);
      WITH Frm_NegFac DO
      BEGIN
        IF Nbt_ShowTete.Pressed THEN
        BEGIN
          Nbt_ShowTeteClick(NIL);
          Nbt_ShowTete.Pressed := False;
        END;
        Pan_FdTete.Height := Pan_FdTete.Constraints.MaxHeight;
        IF chp_Magasin.Enabled THEN Chp_Magasin.SetFocus;
      END;
      Exit;
    END;
    IF Que_TetFacFCE_CLTID.asInteger = 0 THEN
    BEGIN
      StdGinKoia.DelayMess(FactNoClt, 3);
      WITH Frm_NegFac DO
      BEGIN
        IF Nbt_ShowTete.Pressed THEN
        BEGIN
          Nbt_ShowTeteClick(NIL);
          Nbt_ShowTete.Pressed := False;
        END;
        Pan_FdTete.Height := Pan_FdTete.Constraints.MaxHeight;
        IF chp_Nom.Enabled THEN Chp_Nom.SetFocus;
      END;
      Exit;
    END;
    IF Que_TetFacFCE_TYPID.asInteger = 0 THEN
    BEGIN
      StdGinKoia.DelayMess(FactNoTip, 3);
      WITH Frm_NegFac DO
      BEGIN
        IF Nbt_ShowTete.Pressed THEN
        BEGIN
          Nbt_ShowTeteClick(NIL);
          Nbt_ShowTete.Pressed := False;
        END;
        Pan_FdTete.Height := Pan_FdTete.Constraints.MaxHeight;
        IF Chp_TypeFac.Enabled THEN Chp_TypeFac.SetFocus;
      END;
      Exit;
    END;

    IF que_TetFACFCE_DATE.asDateTime > Date THEN
    BEGIN
      IF NOT StdGinKoia.OuiNon('', DateDocMess, False) THEN
      BEGIN
        WITH Frm_NegFac DO
        BEGIN
          IF Nbt_ShowTete.Pressed THEN
          BEGIN
            Nbt_ShowTeteClick(NIL);
            Nbt_ShowTete.Pressed := False;
          END;
          Pan_FdTete.Height := Pan_FdTete.Constraints.MaxHeight;
          IF chp_Date.Visible AND Chp_Date.Enabled THEN
            Chp_Date.SetFocus
          ELSE
            IF Chp_Nom.Visible AND Chp_Nom.Enabled THEN
              Chp_Nom.SetFocus;
        END;
        Exit;
      END;
    END;

    // date inférerieur à la date de migration intersys
    if not(StdGinKoia.CtrlMigrationIntersys(que_TetFac.fieldbyname('FCE_MAGID').AsInteger,
                                            que_TetFac.fieldbyname('FCE_DATE').AsDateTime,
                                            DateMigre)) then
    begin
      StdGinKoia.DelayMess(Format(RS_ERR_ImpossibleAvantDateMigration,
                                       [FormatDateTime('dd/mm/yyyy', DateMigre)]), 4);
      Frm_NegFac.Pan_fdTete.Height := Frm_NegFac.Pan_fdTete.Constraints.MaxHeight;
      Frm_NegFac.Chp_Date.SetFocus;
      Exit;
    end;

    //Date dans un exercice comptable clôturé
    if not(StdGinKoia.CtrlExerciceComptable(que_TetFac.fieldbyname('FCE_MAGID').AsInteger,
                                            que_TetFac.fieldbyname('FCE_DATE').AsDateTime)) then
    begin
      StdGinKoia.DelayMess(RS_ERR_DateDansUnExeComptableClot, 3);
      Frm_NegFac.Pan_fdTete.Height := Frm_NegFac.Pan_fdTete.Constraints.MaxHeight;
      IF Frm_NegFac.chp_Date.Visible AND Frm_NegFac.Chp_Date.Enabled THEN
        Frm_NegFac.Chp_Date.SetFocus
      ELSE
        IF Frm_NegFac.Chp_Nom.Visible AND Frm_NegFac.Chp_Nom.Enabled THEN
          Frm_NegFac.Chp_Nom.SetFocus;
      Exit;
    end;

    // réinit du champ règlement si pas à saisir
    IF que_TetFac.FieldByName('CPA_CODE').asInteger <> 1 THEN
      que_TetFac.FieldByName('FCE_REGLEMENT').Clear;

    // Vérification de l'encours
    lMaxEncours := MaxEncoursAtteint (MemD_CumsCUMTTC.asfloat -  fMontantBeforeEdit, Que_Client.fieldbyname('CLT_ID').AsInteger, StdGinKoia.MagasinId);
    if lMaxEncours <> 0 then
    begin;
      // Encours dépassé
      ErrMess (Format (ErrEncoursDepasse, [lMaxEncours]), '');
      Exit;
    end;

    IF StdGinKoia.OuiNon('', WarPost, True) THEN
    BEGIN
      WITH Frm_NegFac DO
      BEGIN
        IF Pan_FdTete.Height <> Pan_FdTete.Constraints.MaxHeight THEN
        BEGIN
          Pan_FdTete.Height := Pan_FdTete.Constraints.MaxHeight;
          Nbt_ShowTete.Color := $00DEE3E4;
          Nbt_ShowTete.Pressed := False;

          Nbt_Glossaire.Enabled := False;
          Nbt_BtnGlo.Enabled := False;
          dbg_Glossaire.Enabled := False;
          Pan_Glossaire.Enabled := False;
          Spl_Gloss.LowerRight.Visible := False;
        END;
        Dbg_LineFac.Refresh;
      END;
      Delai(150);

      ProChange; // maj du flag pro si nécessaire

      TRY
        IF OnNewRec THEN
        BEGIN
          // Le chrono de facture
          IbStProc_Chrono.Close;
          IbStProc_Chrono.Prepared := True;
          IbStProc_Chrono.ExecProc;
          Que_TetFacFCE_NUMERO.asString := IbStProc_Chrono.Fields[0].asString;

          IbStProc_Chrono.Close;
          IbStProc_Chrono.Unprepare;
          Frm_NegFAC.Chp_chrono.Text := que_TetFACFCE_NUMERO.asString;
        END;

        IF (NOT Memd_Cums.IsEmpty) AND (Memd_CumsTEMMODIF.asInteger = 1) THEN
        BEGIN

          // Mise à jour du compte client
          // Rappel : on ne peut pas supprimer une facture
          que_CptClt.Close;
          que_CptClt.ParamByName('CLTID').asInteger := que_TetFacFCE_CLTID.asInteger;
          que_CptClt.ParamByName('FCEID').asInteger := que_TetFacFCE_ID.asInteger;
          que_CptClt.Open;

          IF que_CptClt.IsEmpty AND (ABS(Memd_CumsCUMTTC.asFloat) < 0.01) THEN Nothing := TRUE;

          IF NOT Nothing THEN
          BEGIN
            IF que_CptClt.IsEmpty THEN
              que_CptClt.Insert
            ELSE
              que_CptClt.Edit;

            que_CptClt.fieldByName('CTE_Libelle').asString := FacLib + ' :' + que_TetFacFCE_NUMERO.asString;

            IF MemD_CumsCUMTTC.asFloat >= 0 THEN
            BEGIN
              IF que_TetFacFCE_DETAXE.asInteger <> 1 THEN
              BEGIN
                que_CptClt.fieldByName('CTE_DEBIT').asFloat := MemD_CumsCUMTTC.asFloat;
                que_CptClt.fieldByName('CTE_CREDIT').asFloat := 0;
              END
              ELSE BEGIN
                que_CptClt.fieldByName('CTE_DEBIT').asFloat := MemD_CumsCUMHT.asFloat;
                que_CptClt.fieldByName('CTE_CREDIT').asFloat := 0;
              END;
            END
            ELSE
            BEGIN
              IF que_TetFacFCE_DETAXE.asInteger <> 1 THEN
              BEGIN
                que_CptClt.fieldByName('CTE_CREDIT').asFloat := ABS(MemD_CumsCUMTTC.asFloat);
                que_CptClt.fieldByName('CTE_DEBIT').asFloat := 0;
              END
              ELSE BEGIN
                que_CptClt.fieldByName('CTE_CREDIT').asFloat := ABS(MemD_CumsCUMHT.asFloat);
                que_CptClt.fieldByName('CTE_DEBIT').asFloat := 0;
              END;
            END;

            t := stdGinkoia.DateRgltCODE(que_TetFacFCE_DATE.asDateTime, que_TetFacCPA_CODE.asInteger);
            IF t = 0 THEN T := Date;
            que_CptClt.FieldByName('CTE_REGLER').asDateTime := T;
            // je ne mets pas "0". Si aucune date de reglt met la date du jour

            que_CptClt.Post;
          END;
        END;

        Result := False;

      EXCEPT
        IF OnNewRec AND IbStProc_Chrono.Prepared THEN
        BEGIN
          IbStProc_Chrono.Close;
          IbStProc_Chrono.Unprepare;
        END;
        StdGinKoia.DelayMess(FacPbCptClt, 3);
      END;

    END;
  END
  ELSE Que_TetFac.Cancel;
  // y'avait rien à sauver donc cancel et actionisdone ne fait rien

END;

FUNCTION TDm_NegFac.ConfCancel: Boolean;
VAR
  done: Boolean;
BEGIN
  // ici inversé car si en edit ou insert et que rien fait, doit exécuter
  // le cancel au bout du compte...

  Result := False; // par defaut fait le cancel
  done := False;

  IF Que_TetFac.updatesPending OR Que_TetFac.Modified THEN Done := True;
  IF LineModified THEN done := True;

  IF done THEN
  BEGIN
    IF NOT StdGinKoia.OuiNon('', WarCancel, False) THEN
      Result := True; // actionisdone = True donc pas de Cancel
  END;

END;

PROCEDURE TDm_NegFac.Que_TetFACBeforePost(DataSet: TDataSet);
VAR
  F2, D3, G2: Double;
  i: Integer;
BEGIN
  IF DoInitEntet THEN EXIT;

  TRY
    StdGinKoia.WaitMess(enregencours);

    TRY

      Que_TetFacFCE_ADRLIGNE.AsString := Que_TetFacADR1.AsString;
      IF (trim(Que_TetFacADR2.AsString) <> '') OR
        (trim(Que_TetFacADR3.AsString) <> '') THEN
        Que_TetFacFCE_ADRLIGNE.AsString := Que_TetFacFCE_ADRLIGNE.AsString + #10 + Que_TetFacADR2.AsString;
      IF (trim(Que_TetFacADR3.AsString) <> '') THEN
        Que_TetFacFCE_ADRLIGNE.AsString := Que_TetFacFCE_ADRLIGNE.AsString + #10 + Que_TetFacADR3.AsString;

      DoPostLine := False;
      DoCalcLine := False;
      DoBeforePostLine := False;

      que_LineFac.DisableControls;
      Frm_NegFac.Dbg_LineFac.BeginUpdate;
      que_LineFac.First;

      F2 := Frm_CalcEntet.GetCUMBeforeRem;
      G2 := Frm_CalcEntet.GetCUMValRem;

      WHILE NOT que_LineFac.Eof DO
      BEGIN
        IF Que_LineFacFCL_LINETIP.asInteger = 0 THEN
        BEGIN
          IF (F2 * G2 = 0) THEN
          BEGIN
            IF Que_LineFacFCL_VALREMGLO.asFloat <> 0 THEN
            BEGIN
              Que_LineFac.Edit;
              Que_LineFacFCL_VALREMGLO.asFloat := 0;
              Que_LineFac.Post;
            END;
          END
          ELSE
          BEGIN
            D3 := RoundRv(Que_LineFacMTLINE.asFloat / F2 * G2, 2);
            F2 := RoundRv(F2 - Que_LineFacMTLINE.asFloat, 2);
            G2 := RoundRV(G2 - D3, 2);

            Que_LineFac.Edit;
            IF IsHT THEN
              Que_LineFacFCL_VALREMGLO.asFloat := GetPxTTC(D3, Que_LineFacFCL_TVA.asFloat, 7)
            ELSE
              Que_LineFacFCL_VALREMGLO.asFloat := D3;
            Que_LineFac.Post;
          END;
        END;
        que_LineFac.Next;
      END;
    FINALLY
      DoPostLine := True;
      DoCalcLine := True;
      DoBeforePostLine := True;
      que_LineFac.First;
      que_LineFac.EnableControls;
      Frm_NegFac.Dbg_LineFac.EndUpdate;
    END;

    FOR i := 1 TO 5 DO
    BEGIN
      IF TabTaux[i] <> -1 THEN
      BEGIN
        Que_TetFac.FieldByName('FCE_TVATAUX' + IntToStr(i)).asFloat := TabTaux[i];
        Que_TetFac.FieldByName('FCE_TVAHT' + IntToStr(i)).asFloat := Frm_CalcEntet.GetMtTTC(TabTaux[i]);
        Que_TetFac.FieldByName('FCE_TVA' + IntToStr(i)).asFloat := Frm_CalcEntet.GetMtTVA(TabTaux[i]);
      END
      ELSE
      BEGIN
        Que_TetFac.FieldByName('FCE_TVATAUX' + IntToStr(i)).asFloat := 0;
        Que_TetFac.FieldByName('FCE_TVAHT' + IntToStr(i)).asFloat := 0;
        Que_TetFac.FieldByName('FCE_TVA' + IntToStr(i)).asFloat := 0;
      END;
    END;
    Que_TetFacFCE_MARGE.asFloat := RoundRv(Sum_LineFac.SumCollection[0].SumValue, 2);

    IF NOT IsRefresh THEN
    BEGIN
      que_Datimp.First;
      WHILE NOT que_Datimp.Eof DO
      BEGIN
        que_Datimp.Edit;
        que_DatimpHTI_MODIFIE.asInteger := 1;
        que_Datimp.Post;
        que_Datimp.Next;
        Frm_NegFac.Chp_Datimp.visible := False;
      END;
    END;
  FINALLY
    StdGinKoia.WaitClose;
  END;

END;

// calculs & affichage des champs

PROCEDURE TDm_NegFac.Que_TetFACTYP_LIBGetText(Sender: TField;
  VAR Text: STRING; DisplayText: Boolean);
BEGIN
  IF Memd_CumsCUMTTC.asFloat < 0 THEN
    Text := AvoirLib
  ELSE
    Text := que_TetFacTyp_Lib.asstring;

  IF que_TetFacFCE_HTWORK.asInteger = 1 THEN
    Text := Text + ' ' + cstJSESHT
  ELSE
    Text := Text + ' ' + cstJSESTTC;

END;

PROCEDURE TDm_NegFac.Que_TetFACFCE_REMISEChange(Sender: TField);
BEGIN
  IF OnMajTete THEN EXIT;
  Frm_CalcEntet.SetRemGlo(que_TetFacFCE_REMISE.asFloat);
  MajEntete;
END;

PROCEDURE TDm_NegFac.Que_TetFACFCE_REMISEGetText(Sender: TField;
  VAR Text: STRING; DisplayText: Boolean);
BEGIN
  IF ABS(Que_TetFacFCE_REMISE.Asfloat) < 0.01 THEN
    Text := '0.00'
  ELSE
    Text := FormatFloat('#0.00', Que_TetFACFCE_REMISE.Asfloat);
END;

procedure TDm_NegFac.Que_TetFACCalcFields(DataSet: TDataSet);
begin      
  // ce champ ne sert qu'à afficher sans coche griser si FCE_REGLER est null
  Que_TetFAC.fieldbyname('AffFCEREGLER').AsInteger := Que_TetFAC.fieldbyname('FCE_REGLER').AsInteger
end;

PROCEDURE TDm_NegFac.Que_TetFACCPA_NOMGetText(Sender: TField;
  VAR Text: STRING; DisplayText: Boolean);
BEGIN
  IF que_TetFac.FieldByName('CPA_CODE').asInteger = 1 THEN
    Text := FormatDateTime('dd/mm/yyyy', que_TetFac.FieldByName('FCE_REGLEMENT').asDateTime)
  ELSE
    Text := que_TetFac.FieldByName('CPA_NOM').asString;

END;

//--------------------------- Lignes de facture --------------------

PROCEDURE TDm_NegFac.Que_LineFACREMISEGetText(Sender: TField;
  VAR Text: STRING; DisplayText: Boolean);
VAR
  v: double;
BEGIN
  IF ABS(Que_LineFACREMISE.Asfloat) < 0.01 THEN
    Text := '0.00'
  ELSE BEGIN
    v := roundrv(Que_LineFACREMISE.Asfloat, 1);
    Text := FormatFloat('#0.00', v);
  END;
END;

FUNCTION TDm_NEGFac.CTRLDateValid: Boolean;
BEGIN
  Result := True;
  IF que_TetFac.State IN [dsInsert, dsEdit] THEN
  BEGIN
    IF ((Que_TetFACFCE_MODELE.asInteger <> 1)
      AND (que_TetFacFCE_DATE.asDateTIME < Date - 90)) THEN
    BEGIN
      IF que_LineFacFCL_LINETIP.asInteger = 0 THEN
      BEGIN
        TRY
          Ibc_CtrlPseudo.Close;
          Ibc_CtrlPseudo.ParamByName('ARTID').asInteger := Que_LineFacFCL_ARTID.asInteger;
          Ibc_CtrlPseudo.Open;
          IF IBC_CtrlPseudo.RecordCount > 0 THEN
            Result := Ibc_CtrlPseudo.FieldByName('ARF_VIRTUEL').asInteger = 1;
        FINALLY
          Ibc_CtrlPseudo.Close;
        END;
      END
      ELSE Result := (que_LineFacFCL_LINETIP.asInteger IN [1, 2]);
    END;
  END;
END;

PROCEDURE TDm_NegFac.Que_LineFACBeforeEdit(DataSet: TDataSet);
BEGIN
  MemMtBR := que_LineFacMTLINE.asFloat;
  MemTvaLin := que_LineFacFCL_TVA.asFloat;
  MemQte := que_LineFacFCL_Qte.Asfloat;

  MemCumBrut := RoundRV(que_LineFacPXSBR.asFloat * que_LineFacFCL_QTE.asFloat, 2);
  // nécessaire pour la MAJ éventuelle des SR en modif qté ou pxAchat

  IF DoPostLine AND (Tim_Focus.Tag = 0) AND (NOT OnCalcSt) THEN
    StdGinKoia.SauveOnCache(Dataset, ExDatas);
END;

PROCEDURE TDm_NegFac.Que_LineFACAfterCancel(DataSet: TDataSet);
BEGIN
  DoPostLine := True;
  DoBeforePostLine := True;
  DoCalcLine := True;

  IF (Frm_NegFac.Dbg_LineFac.focusedNode <> NIL) AND OnNewLine AND (NOT frm_negFac.Dbg_LineFac.FocusedNode.IsLast) THEN
    Frm_NegFac.PrevNode;

  OnNewLine := False;
  NeoComent := 0;

  IF Frm_NegFac.Chp_Rech.Enabled AND Frm_NegFac.Chp_Rech.Visible THEN
    Frm_NegFac.Chp_Rech.SetFocus;

END;

PROCEDURE TDm_NegFac.AligneMemdSTK;
VAR
  trouve: Boolean;
BEGIN
  IF que_LineFACARF_VIRTUEL.asInteger = 1 THEN EXIT;
  Trouve := False;

  IF NOT Memd_Stk.active THEN
    Memd_STK.Open
  ELSE
    // le mag considéré est forcément celui du bon
    Trouve := Memd_Stk.locate('ARTID;TGFID;COUID', varArrayOf([
      que_LineFacFCL_ARTID.asInteger,
        que_LineFacFCL_TGFID.asInteger,
        que_LineFacFCL_COUID.asInteger]), []);

  IF NOT Trouve THEN
  BEGIN

    Memd_Stk.Insert;
    MemD_STKARTID.asInteger := que_LineFacFCL_ARTID.asInteger;
    MemD_STKTGFID.asInteger := que_LineFacFCL_TGFID.asInteger;
    MemD_STKCOUID.asInteger := que_LineFacFCL_COUID.asInteger;

    TRY
      ibc_STK.close;
      ibc_STK.ParamByName('MAGID').asInteger := que_TetFacFCE_MAGID.asInteger;
      ibc_STK.ParamByName('ARTID').asInteger := que_LineFacFCL_ARTID.asInteger;
      ibc_STK.ParamByName('TGFID').asInteger := que_LineFacFCL_TGFID.asInteger;
      ibc_STK.ParamByName('COUID').asInteger := que_LineFacFCL_COUID.asInteger;
      ibc_STK.open;
      IF NOT ibc_stk.eof THEN
      BEGIN
        MemD_STKSTK.asFloat := ibc_Stk.Fields[0].asFloat;
        MemD_STKSTKI.asFloat := ibc_Stk.Fields[1].asFloat;
      END
      ELSE BEGIN
        MemD_STKSTK.asFloat := 0;
        MemD_STKSTKI.asFloat := 0;
      END;
      Memd_STK.Post;
    FINALLY
      Ibc_Stk.Close;
    END;
  END;
END;

PROCEDURE TDm_NegFac.AffStkLigne;
BEGIN
  IF (que_LineFacFCL_LineTip.asInteger = 0) THEN
  BEGIN
    IF que_LineFacARF_VIRTUEL.asInteger <> 0 THEN
      StdGinKoia.DelayMess(VirtuelNoStock, 3)
    ELSE BEGIN
      AligneMemdSTK;
      StdGinKoia.InfoMess(Infostkcour, ParamsStr(NegAffStk, VarArrayOf([
        que_LineFacARF_Chrono.asstring,
          que_LineFacART_RefMrk.asstring,
          que_LineFacFCL_COMENT.asstring,
          FormatFloat('#0', Memd_STKSTK.asfloat)])));
    END;
  END
  ELSE StdGinKoia.DelayMess(NegNoArticleStk, 3);

END;

// Calculs & affichage des champs

PROCEDURE TDm_NegFac.Que_LineFACCalcFields(DataSet: TDataSet);
VAR
  idx: Integer;
  marge, txTva, prixAchat: extended;
BEGIN
  IF NOT DoCalcLine THEN
  BEGIN
    TemCalcLine := 0;
    EXIT;
  END;

  IF (Que_LineFacFCL_LineTip.asInteger = 0) THEN
  BEGIN
    IF DoInitEntet THEN
    BEGIN
      Idx := GetIndiceTaux(que_LineFacFCL_TVA.asFloat);
      IF Idx <> -1 THEN
        que_LineFac.fieldByName('CUM' + IntToStr(idx)).asFloat := que_LineFacMTLINE.asFloat;

      //lab 14/10/08 indispensable pour export excel
      IF (isHT OR (que_TetFacFCE_TYPID.asFloat = TipFacRetro)) THEN //si rétrocession ou hors taxe
      BEGIN
        txTva := 0;
      END
      ELSE
      BEGIN
        txTva := que_LineFACFCL_TVA.asfloat;
      END;
      //si pseudo et coef non 0 calculer le prix d'achat théorique
      IF (Que_LineFACARF_VIRTUEL.asFloat = 1) AND (Que_LineFACARF_COEFT.asFloat <> 0) THEN
      BEGIN
        prixAchat := que_LineFacPXSAR.asFloat / Que_LineFACARF_COEFT.asFloat;
        //si ht traiter le cas spécial du pseudo non Service
        IF Dm_NegFac.isHT THEN
        BEGIN
          prixAchat := que_LineFacPXSBR.asFloat * ((100 + que_LineFACFCL_TVA.asfloat) / 100) / Que_LineFACARF_COEFT.asFloat;
        END
        ELSE
        BEGIN
          prixAchat := que_LineFacPXSBR.asFloat / Que_LineFACARF_COEFT.asFloat;
        END
      END
      ELSE
      BEGIN
        prixAchat := Que_LineFACPUMP.asFloat;
      END;
      //coef : prixVenteTTC=pa*coef
      //si ht
      IF (txTva = 0) THEN
      BEGIN
        //vérifier s'il s'agit d'une rétrocession
//        if (que_TetFacFCE_TYPID.asFloat = TipFacRetro) then
//        begin
//          Que_LineFACCOEF.asFLoat := GetCoef(prixAchat, (Que_LineFACPXSAR.asFloat), 4);
//        end
//        else
//        begin
        Que_LineFACCOEF.asFLoat := GetCoef(prixAchat, (Que_LineFACPXSAR.asFloat * ((100 + que_LineFACFCL_TVA.asfloat) / 100)), 4);
        //        end;
      END
      ELSE
      BEGIN
        Que_LineFACCOEF.asFLoat := GetCoef(prixAchat, (Que_LineFACPXSAR.asFloat), 4);
      END;
      //marge en pourcentage
      IF (Que_LineFACPXSAR.asFloat <> 0) AND (que_LineFACFCL_QTE.asFloat <> 0) THEN
      BEGIN
        //si pseudo service et pas de coef
        IF (Que_LineFACARF_VIRTUEL.asinteger = 1) AND (Que_LineFACARF_COEFT.AsFloat = 0) THEN
        BEGIN
          Que_LineFACMARGEPOURCENT.asFLoat := 100;
        END
        ELSE //pour tout autre produit calculer la marge en %
        BEGIN
          marge := GetValMargeTT(Que_LineFACPXSAR.asFloat, prixAchat, txTva, 7) * que_LineFACFCL_QTE.asFloat;
          Que_LineFACMARGEPOURCENT.asFLoat := GetPcentMargeVMTT(Que_LineFACPXSAR.asFloat, marge, txTva, 7) / que_LineFACFCL_QTE.asFloat;
        END;
        //si marge positive et prix d'achat
//        if (marge >= 0) then
//        begin
//          Que_LineFACMARGEPOURCENT.asFLoat := GetPcentMargeVMTT(Que_LineFACPXSAR.asFloat, marge, txTva, 7) / que_LineFACFCL_QTE.asFloat;
//        END;
//        else //sinon le pourcentage de marge ne présente aucun intérêt
//        begin
//          Que_LineFACMARGEPOURCENT.asFLoat := 0;
//        end;
      END;
    END
    ELSE
    BEGIN
      IF TemCalcLine <> 0 THEN
      BEGIN
        IF que_LineFac.State IN [DsInsert, dsEdit] THEN
        BEGIN
          DoCalcLine := False;
          TRY
            CASE TemCalcLine OF
              1: // Modif PXSBR
                BEGIN
                  Que_LineFACPXSAR.asFloat := GetPxNego(Que_LineFacPXSBR.asFloat, que_LineFacREMISE.asFloat, 2);
                  Que_LineFACREMISE.asFloat := GetRemise(Que_LineFacPXSBR.asFloat, que_LineFacPXSAR.asFloat, 13);
                  Que_LineFACMTLINE.asFloat := RoundRV(Que_LineFACPXSAR.asFloat * que_LineFacFCL_QTE.asFloat, 2);
                END;
              2: // MODIF REMISE
                BEGIN
                  Que_LineFACPXSAR.asFloat := GetPxNego(Que_LineFacPXSBR.asFloat, que_LineFacREMISE.asFloat, 2);
                  Que_LineFACMTLINE.asFloat := RoundRV(Que_LineFACPXSAR.asFloat * que_LineFacFCL_QTE.asFloat, 2);
                END;
              3: // MODIF MTLINE
                BEGIN
                  IF Que_LineFacFCL_QTE.asFloat <> 0 THEN
                  BEGIN
                    Que_LineFACPXSAR.asFloat := RoundRV(Que_LineFacMTLINE.asFloat / Que_LineFacFCL_QTE.asFloat, 2);
                    //si pseudo enregistrer le montant net dans le brut sinon on aura une remise négative dans l'analyse des ventes
                    IF (Que_LineFACARF_VIRTUEL.asFloat = 1) THEN
                    BEGIN
                      Que_LineFacPXSBR.asFloat := Que_LineFACPXSAR.asFloat;
                    END;
                  END
                  ELSE
                    Que_LineFACPXSAR.asFloat := 0;
                  Que_LineFACREMISE.asFloat := GetRemise(Que_LineFacPXSBR.asFloat, que_LineFacPXSAR.asFloat, 13);
                END;
              4: // MODIF Qté
                BEGIN
                  Que_LineFACMTLINE.asFloat := RoundRV(Que_LineFACPXSAR.asFloat * que_LineFacFCL_QTE.asFloat, 2);
                END;
            END; // du case

            ////lab 14/10/08
//            if (isHT or (que_TetFacFCE_TYPID.asFloat = TipFacRetro)) then //si rétrocession ou hors taxe
//            begin
//              txTva := 0;
//            end
//            else
//            begin
//              txTva := que_LineFACFCL_TVA.asfloat;
//            end;
//                  //si pseudo et coef non 0 calculer le prix d'achat théorique
//            if (Que_LineFACARF_VIRTUEL.asFloat = 1) and (Que_LineFACARF_COEFT.asFloat <> 0) then
//            begin
//              prixAchat := que_LineFacPXSAR.asFloat / Que_LineFACARF_COEFT.asFloat;
//            end
//            else
//            begin
//              prixAchat := Que_LineFACPUMP.asFloat;
//            end;
//                  //coef : prixVenteTTC=pa*coef
//             //si ht
//            if (txTva = 0) then
//            begin
//            //vérifier s'il s'agit d'une rétrocession
//              if (que_TetFacFCE_TYPID.asFloat = TipFacRetro) then
//              begin
//                Que_LineFACCOEF.asFLoat := GetCoef(prixAchat, (Que_LineFACPXSAR.asFloat), 4);
//              end
//              else
//              begin
//                Que_LineFACCOEF.asFLoat := GetCoef(prixAchat, (Que_LineFACPXSAR.asFloat * (1 + (que_LineFACFCL_TVA.asfloat / 100))), 4);
//              end;
//            end
//            else
//            begin
//              Que_LineFACCOEF.asFLoat := GetCoef(prixAchat, (Que_LineFACPXSAR.asFloat), 4);
//            end;
//            marge := GetValMargeTT(Que_LineFACPXSAR.asFloat, prixAchat, txTva, 7) * que_LineFACFCL_QTE.asFloat;
//            Que_LineFACMARGE.asfloat := marge;
//            if (Que_LineFACPXSAR.asFloat <> 0) and (que_LineFACFCL_QTE.asFloat <> 0) then
//            begin
//                  //si marge positive et prix d'achat
//              if (marge >= 0) then
//              begin
//                Que_LineFACMARGEPOURCENT.asFLoat := GetPcentMargeVMTT(Que_LineFACPXSAR.asFloat, marge, txTva, 7) / que_LineFACFCL_QTE.asFloat;
//              end
//              else //sinon le pourcentage de marge ne présente aucun intérêt
//              begin
//                Que_LineFACMARGEPOURCENT.asFLoat := 0;
//              end;
//            end;

          FINALLY
            TemCalcLine := 0;
            DoCalcLine := True;
          END;
        END;
      END;
    END;
  END
  ELSE BEGIN
    IF (NOT DoInitEntet) AND
      (TemCalcLine <> 0) AND
      (que_LineFac.State IN [DsInsert, dsEdit]) THEN
    BEGIN
      DoCalcLine := False;
      TRY
        CASE TemCalcLine OF
          2: // MODIF REMISE
            BEGIN
              Que_LineFACFCL_PXNN.asFloat := GetPxNego(Que_LineFacFCL_PXBRUT.asFloat, que_LineFacREMISE.asFloat, 2);
            END;
          5: // MODIF PXV SousTotal
            BEGIN
              Que_LineFACREMISE.asFloat := GetRemise(Que_LineFacFCL_PXBRUT.asFloat, que_LineFacFCL_PXNN.asFloat, 13);
            END
        END;
      FINALLY
        TemCalcLine := 0;
        DoCalcLine := True;
      END;
    END;
  END;

END;

PROCEDURE TDm_NegFac.Que_LineFACPXSBRValidate(Sender: TField);
BEGIN
  TemCalcLine := 1;
END;

PROCEDURE TDm_NegFac.Que_LineFACREMISEValidate(Sender: TField);
BEGIN
  TemCalcLine := 2;
END;

PROCEDURE TDm_NegFac.Que_LineFACMTLINEValidate(Sender: TField);
BEGIN
  TemCalcLine := 3;
END;

PROCEDURE TDm_NegFac.Que_LineFACFCL_QTEValidate(Sender: TField);
BEGIN
  TemCalcLine := 4;
END;

PROCEDURE TDm_NegFac.MemD_CumsCalcFields(DataSet: TDataSet);
BEGIN
  IF OnMajtete THEN EXIT;
  IF NOT (Memd_Cums.State IN [DsInsert, DsEDit]) THEN EXIT;
  IF IsHT THEN
    Frm_CalcEntet.SetCumMontant(Memd_CumsCUMHT.asFloat)
  ELSE
    Frm_CalcEntet.SetCumMontant(Memd_CumsCUMTTC.asFloat);
  MajEntete;
END;

PROCEDURE TDm_NegFac.SetflagVisLine;
VAR
  i: Integer;
BEGIN
  TRY
    DoPostLine := False;
    DoCalcLine := False;
    DoBeforePostLine := False;

    que_LineFac.Edit;
    i := que_LineFacFCL_GPSSTOTAL.asInteger;
    IF i = 1 THEN
      i := 0
    ELSE i := 1;
    que_LineFacFCL_GPSSTOTAL.asInteger := i;
    que_LineFac.Post;
    IF NOT (que_TetFac.State IN [dsInsert, dsEdit]) THEN
      UpdateMask;

  FINALLY
    LineModified := True;
    DoCalcline := True;
    DoPostLine := True;
    DoBeforePostLine := True;
  END;
END;

PROCEDURE TDm_NegFac.Que_GlossaireREMISEGetText(Sender: TField;
  VAR Text: STRING; DisplayText: Boolean);
VAR
  v: double;
BEGIN
  IF ABS(Que_GLOSSAIREREMISE.Asfloat) < 0.01 THEN
    Text := '0.00'
  ELSE BEGIN
    v := roundrv(Que_GLOSSAIREREMISE.Asfloat, 1);
    Text := FormatFloat('#0.00', v);
  END;
END;

PROCEDURE TDm_NegFac.Que_LineImpREMISEGetText(Sender: TField;
  VAR Text: STRING; DisplayText: Boolean);
VAR
  v: double;
BEGIN
  IF ABS(Que_LineIMPREMISE.Asfloat) < 0.01 THEN
    Text := '0.00'
  ELSE BEGIN
    v := roundrv(Que_LineIMPREMISE.Asfloat, 1);
    Text := FormatFloat('#0.00', v);
  END;
END;

PROCEDURE TDm_NegFac.CalcST(IdPack: Integer);
VAR
  i, id: Integer;
  mt, pb, F2, G2, D3, mtlBR, rem: Double;
  TS: TStrings;
BEGIN
  // Tip = 0 simple calcul Tip = 1 : retire une ligne 2 = Ajoute une ligne
  // Cette procédure recalcule le ST en répartissant correctement la remise
  Id := que_LineFacFCL_Id.asInteger;
  TRY

    OnCalcSt := True;
    DoCtrlStK := False; // empêche le contrôle du stock
    DoPostLine := False;
    DoCalcLine := False;
    // DobeforePostLine doit rester actif pour mise à jour des réels champs de prix
    screen.cursor := crSQLWait;

    Frm_NegFac.dbg_LineFac.Enabled := False;
    Frm_NegFac.dbg_Glossaire.Enabled := False;
    Frm_NegFac.Dbg_LineFac.BeginUpdate;
    Que_LineFac.DisableControls;

    TS := TStringList.Create;

    Frm_NegFac.IdOfST(TS, IdPack);
    Que_LineFac.Locate('FCL_ID', idPack, []);

    Rem := RoundRv(Que_LineFacREMISE.asFloat, 13);
    pb := 0;
    // mt := 0;
    FOR i := 0 TO Ts.count - 1 DO
    BEGIN
      IF que_LineFac.Locate('FCL_ID', strToInt(Ts[i]), []) THEN
      BEGIN
        IF Que_LineFacFCL_LINETIP.asInteger = 0 THEN
          Pb := Pb + RoundRV(que_LineFacPXSBR.asFloat * Que_LineFacFCL_QTE.asFloat, 2);
      END;
    END;

    F2 := Pb;
    G2 := RoundRV((F2 * Rem) / 100, 2); // valeur remise
    Mt := RoundRv(Pb - G2, 2);

    FOR i := 0 TO Ts.count - 1 DO
    BEGIN
      IF que_LineFac.Locate('FCL_ID', strToInt(Ts[i]), []) THEN
      BEGIN
        IF Que_LineFacFCL_LINETIP.asInteger = 0 THEN
        BEGIN
          IF (F2 * G2 = 0) THEN
          BEGIN
            Que_LineFac.Edit;
            Que_LineFacREMISE.AsFloat := 0;
            Que_LineFacPXSAR.asFloat := GetPxNego(Que_LineFacPXSBR.asFloat, que_LineFacREMISE.asFloat, 2);
            Que_LineFacMTLINE.asFloat := RoundRV(Que_LineFacPXSAR.asFloat * que_LineFacFCL_QTE.asFloat, 2);
            Que_LineFac.Post;
          END
          ELSE
          BEGIN
            MtlBR := RoundRV(que_LineFacPXSBR.asFloat * Que_LineFacFCL_QTE.asFloat, 2);
            D3 := RoundRv(MtlBR / F2 * G2, 2);
            F2 := RoundRv(F2 - mtlBR, 2);
            G2 := RoundRV(G2 - D3, 2);

            Que_LineFac.Edit;
            Que_LineFacMTLINE.asFloat := RoundRv(mtlBR - D3, 2);
            IF Que_LineFacFCL_QTE.asFloat <> 0 THEN
              Que_LineFacPXSAR.asFloat := RoundRV(Que_LineFacMTLINE.asFloat / Que_LineFacFCL_QTE.asFloat, 2)
            ELSE
              Que_LineFacPXSAR.asFloat := 0;
            Que_LineFacREMISE.asFloat := GetRemise(Que_LineFacPXSBR.asFloat, que_LineFacPXSAR.asFloat, 13);
            Que_LineFac.Post;
          END;
          GetIndiceTaux(que_LineFacFCL_TVA.asFloat);
          Frm_CalcEntet.SetMoinsMontant(MemMtBR, MemTvaLin); // si mt = 0 Ne fait rien
          Frm_CalcEntet.SetPlusMontant(que_LineFacMTLINE.asfloat, que_LineFacFCL_TVA.asFloat);
        END;
      END;
    END;
    Que_LineFac.Locate('FCL_ID', idPack, []);
    que_LineFac.Edit;
    que_LineFacFCL_PXBRUT.asFloat := RoundRv(Pb, 2);
    que_LineFacFCL_PXNN.asFloat := RoundRV(mt, 2);
    que_LineFac.Post;

  FINALLY

    MajEntete;

    TS.Free;

    que_LineFac.Locate('FCL_ID', id, []);
    que_LineFac.EnableControls;

    Frm_NegFac.Dbg_LineFac.EndUpdate;
    Frm_NegFac.Pan_fdSaisie.Visible := True;
    Frm_NegFac.dbg_LineFac.Enabled := True;
    Frm_NegFac.dbg_Glossaire.Enabled := True;

    OnCalcSt := False;
    DoCtrlStk := True;
    DoCalcLine := True;
    DoPostLine := True;
    OnNewLine := False;
    NeoComent := 0;
    LineModified := True;

    Frm_NegFac.SetContextSaisie;
    screen.Cursor := crDefault;
  END;
END;

PROCEDURE TDm_NegFac.Que_LineFACFCL_PXNNValidate(Sender: TField);
BEGIN
  IF que_LineFacFCL_LineTip.asInteger = 3 THEN TemCalcline := 5;
END;

PROCEDURE TDm_NegFac.DragGlos(Prec, Suiv: STRING; Nbre: Integer);
VAR
  DoAppend, cb: boolean;
BEGIN
  FromGlos := True;

  // Initialisation nécessaire pour correspondre au contexte d'insertion classique
  NeoComent := que_GlossaireDVL_LINETIP.asInteger;
  IF que_GlossaireDVL_LINETIP.asInteger = 0 THEN
    StdGinkoia.RechArt(que_GlossaireDVL_ARTID.asstring, True, 0, 0, False, False, True, False, Cb, Que_Recherche);

  Frm_NegFAC.PrepareIdLin(Prec, Suiv, Nbre);
  //    StdGinkoia.GetFirstIdLigne(Prec, Suiv, Nbre);

  MemRemSt := 0;
  MemRefSt := 0;
  MemCumBrut := 0;
  MemMtBR := 0;
  MemTvaLin := 0;
  MemQte := 0;
  DoAppend := False;

  IF (Prec <> '') AND (Suiv <> '') THEN
  BEGIN
    IF Frm_NegFac.GetRemST(MemRemST) THEN
      MemRefST := que_LineFacFCL_SSTOTAL.AsInteger;
  END
  ELSE IF Suiv = '' THEN DoAppend := True;

  que_LineFAC.Next;
  IF DoAppend THEN
    Que_LineFAC.Append
  ELSE
    que_LineFAC.Insert;

  que_LineFAC.Post;

END;

PROCEDURE TDm_NegFac.DragModeleGlos(TS: TStrings);
VAR
  i: Integer;
  cb: boolean;
  LaremSt: double;
  LaRefSt: Integer;

BEGIN
  TRY
    IF Ts.Count > 8 THEN stdGinkoia.WaitMess(PastFromGlos);
    Screen.Cursor := CrSQLWait;
    DoPostLine := False;
    DisableSetContext := True;
    DoCtrlSTK := False;
    // DoCalcline et DoBeforePostLine restentnt actifs

    MemCumBrut := 0;
    MemMtBR := 0;
    MemTvaLin := 0;
    MemQte := 0;

    MemRemST := 0;
    MemRefSt := 0;
    Larefst := 0;
    LaRemSt := 0;

    FOR i := 0 TO TS.count - 1 DO
    BEGIN

      IF Que_Glossaire.Locate('DVL_ID', TS[i], []) THEN
      BEGIN

        FromGlos := True;
        // Indispensable à chaque itération car remis à  false dans newrecord

        NeoComent := que_GlossaireDVL_LINETIP.asInteger;
        IF que_GlossaireDVL_LINETIP.asInteger = 0 THEN
          StdGinkoia.RechArt(que_GlossaireDVL_ARTID.asstring, True, 0, 0, False, False, True, False, Cb, Que_Recherche);

        IF que_GlossaireDVL_LINETIP.asInteger = 3 THEN
        BEGIN
          MemRemSt := Que_GlossaireREMISE.asFloat;
          MemRefST := 0;
        END
        ELSE BEGIN
          MemRemST := LaRemST;
          MemRefST := LaRefST;
          // ces deux variables étant réinitialisées à le fin de
          // NewRecord je les réalimente si nécessaire
        END;

        // Le générateur d'id ordre est initialisé dans OnDragandDrop ...
        Que_LineFac.Insert;
        que_LineFac.Post;

        IF que_GlossaireDVL_LINETIP.asInteger = 3 THEN
        BEGIN
          LaRemSt := Que_GlossaireREMISE.asFloat;
          LarefST := Que_LineFacFCL_ID.asInteger;
        END;

        IF (que_GlossaireDVL_LINETIP.asInteger = 0) THEN
        BEGIN
          GetIndiceTaux(que_LineFacFCL_TVA.asFloat);
          Frm_CalcEntet.SetPlusMontant(que_LineFacMTLINE.asfloat, que_LineFacFCL_TVA.asFloat);
        END;

        IF que_GlossaireDVL_LINETIP.asInteger = 4 THEN
        BEGIN
          LaRemSt := 0;
          LarefST := 0;
        END;
      END;
    END;
  FINALLY
    MemRefST := 0;
    MemRemSt := 0;

    MajEntete;

    DoPostLine := True;
    DoCtrlSTK := True;
    LineModified := True;

    OnNewLine := False;
    NeoComent := 0;

    IF Ts.Count > 8 THEN stdGinkoia.WaitClose;
    Frm_NegFac.Pan_fdSaisie.Visible := True;
    IF Frm_NegFac.Dbg_Glossaire.Enabled THEN Frm_NegFac.Dbg_Glossaire.SetFocus;
    Screen.Cursor := crDefault;

    DisableSetContext := False;
    Frm_NegFac.SetContextSaisie;
  END;
END;

PROCEDURE TDm_NegFac.DragPackNode(TS: TStrings; ExPack, NeoPack,
  IdLock: Integer);
VAR
  NeoRem, retire, ajoute: Double;
  ch: STRING;
  i: Integer;
BEGIN
  NeoRem := 0;
  Retire := 0;
  Ajoute := 0;
  TRY
    frm_NegFac.Dbg_LineFac.BEGINUpdate;
    frm_NegFac.Dbg_LineFac.Enabled := False;
    screen.Cursor := CrSQLWAIT;

    DoPostLine := False;
    DoCtrlSTK := False;

    IF NeoPack <> 0 THEN
    BEGIN
      IF que_LineFac.Locate('FCL_ID', NeoPack, []) THEN
        NeoRem := que_LineFacREMISE.asFloat;
    END;

    FOR i := 0 TO TS.Count - 1 DO
    BEGIN
      IF que_LineFac.Locate('FCL_ID', Ts[i], []) THEN
      BEGIN
        IF Frm_NegFAC.GetNeoIdLIne(ch) THEN
          //IF StdGinkoia.GetIdLigne(ch) THEN
        BEGIN
          que_LineFac.Edit;
          que_LineFacFCL_NOM.asstring := ch;
          que_LineFacFCL_SSTOTAL.asInteger := NeoPack;
          que_LineFacREMISE.asFloat := NeoRem;
          que_LineFac.Post;

          GetIndiceTaux(que_LineFacFCL_TVA.asFloat);
          Frm_CalcEntet.SetMoinsMontant(MemMtBR, MemTvaLin); // si mt = 0 Ne fait rien
          Frm_CalcEntet.SetPlusMontant(que_LineFacMTLINE.asfloat, que_LineFacFCL_TVA.asFloat);

          IF ExPack <> 0 THEN Retire := Retire + RoundRV(MemCumBrut, 2);
          IF NeoPack <> 0 THEN Ajoute := Ajoute + RoundRV(que_LineFacPXSBR.asFloat * que_LineFacFCL_QTE.asFloat, 2);
        END;
      END;
    END;
  FINALLY
    IF (ExPack <> 0) AND (Retire <> 0) THEN
      CalcST(ExPack);
    IF (NeoPack <> 0) AND (Ajoute <> 0) THEN
      CalcST(NeoPack);
    MajEntete;
    IF IdLock <> 0 THEN que_LineFac.Locate('FCL_ID', IdLock, []);
    frm_NegFac.Dbg_LineFac.EndUpdate;
    frm_NegFac.Dbg_LineFac.Enabled := True;
    Frm_NegFac.Dbg_LineFac.SetFocus;
    screen.Cursor := CrDefault;
    Frm_NegFac.Pan_FdSaisie.Visible := True;

    DoPostLine := True;
    DoCtrlStk := True;
  END;
END;

PROCEDURE TDm_NegFac.SimpleDragNode(TS: TStrings);
VAR
  ch: STRING;
  i: Integer;
BEGIN
  { Simple déplacement de node(s) sans aucun autre changement donc
    nul besoin de recalculer le ST et l'entête du doc...
    Si bloc ST alors TS part du node le plus bas vers le premier
  }
  TRY
    frm_NegFac.Dbg_LineFac.BEGINUpdate;
    DoPostLine := False;
    DoBeforePostLine := False;
    DoCalcLine := False;

    FOR i := 0 TO Ts.Count - 1 DO
    BEGIN
      IF que_LineFac.Locate('FCL_ID', Ts[i], []) THEN
      BEGIN
        IF Frm_NegFac.GetNeoIdLIne(ch) THEN
        BEGIN
          que_LineFac.Edit;
          que_LineFacFCL_NOM.asstring := ch;
          que_LineFac.Post;
        END;
      END;
    END;
  FINALLY
    frm_NegFac.Dbg_LineFac.EndUpdate;
    DoPostLine := True;
    DoCalcLine := True;
    DoBeforePostLine := True;
  END;

END;

PROCEDURE TDm_NegFac.GenerikAfterCancel(DataSet: TDataSet);
BEGIN
  Dm_Main.IBOCancelCache(DataSet AS TIBOQuery);
END;

PROCEDURE TDm_NegFac.GenerikAfterPost(DataSet: TDataSet);
BEGIN
  Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TDm_NegFac.GenerikUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
  Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
    (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TDm_NegFac.DeleteLine;
VAR
  i, IdSt: Integer;
  TS, tsd: TStrings;
  FlagOk: Integer;

BEGIN

  IdSt := 0;
  // MTBRUT := 0;
  // MTVA := 0;

  TRY
    Frm_NegFac.DBG_LineFac.BeginUpdate;
    DoPostLine := False;
    TS := TStringList.Create;

    // Une ligne importée directement d'un devis peut être supprimée... la relation saute si existe
    IF Que_LineFacFCL_FROMBLL.asInteger = 1 THEN
    BEGIN
      // On ne peut pas supprimer Une ligne importée d'un BL
      StdGinKoia.DelayMess(NoSupprImportedLine, 3);
    END
    ELSE
    BEGIN

      FlagOk := -1;
      IF Que_LineFacFCL_LINETIP.asInteger <> 3 THEN
      BEGIN
        IF OuiNonHP(CdeConfDelLine, False, true, 0, 0, '') THEN
          FlagOk := 3;
      END
      ELSE BEGIN
        IF bDelLot THEN
          // FC : Gestion lots
          FLagOk := 1
        ELSE BEGIN
          // FC : Gestion lots
          TRY
            tsd := tstringlist.create;
            tsd.Add('Supprimer LE SOUS-TOTAL AVEC TOUTES LES LIGNES QU''IL CONTIENT');
            tsd.Add('Ne supprimer QUE LE SOUS-TOTAL  (les lignes restent dans le document)');
            FlagOk := DlgChoixDyna('', Tsd, 0, 550, True, 'Cochez l''option de votre choix...');
          FINALLY
            Tsd.Free;
          END;
        END;
      END;

      CASE FLagOk OF
        0, 3: // tout
          BEGIN
            TRY
              screen.Cursor := crSQLWait;

              IF que_LineFac.state IN [DsInsert] THEN
                que_LineFac.Cancel
              ELSE
              BEGIN
                // seules les relations dont le destinataire est la FACTURE doivent
               // êtres supprimées.

                IF Que_LineFacFCL_LINETIP.asInteger = 3 THEN
                  Frm_NegFac.IdOfST(TS, que_LineFacFCL_ID.asInteger)
                ELSE
                  TS.add(que_LineFacFCL_ID.asString);

                FOR i := 0 TO TS.count - 1 DO
                BEGIN
                  IF que_LineFac.Locate('FCL_ID', strToInt(TS[i]), []) THEN
                  BEGIN
                    IF que_LineFacFCL_FROMBLL.asInteger = 0 THEN
                    BEGIN
                      IF NOT que_RelDest.Active THEN
                      BEGIN
                        que_RelDest.paramByName('FCEID').asInteger := que_TetFacFCE_ID.asInteger;
                        Que_RelDest.Open;
                      END;

                      que_RelDest.First;
                      WHILE NOT que_RelDest.eof DO
                      BEGIN
                        IF que_RelDest.FieldByName('NGR_LINEIDD').asInteger = que_LineFacFCL_ID.asInteger THEN
                          que_RelDest.Delete
                        ELSE
                          que_RelDest.Next;
                      END;

                      AligneMemDStk;

                      IF Que_LineFacFCL_LINETIP.asInteger = 0 THEN
                      BEGIN
                        GetIndiceTaux(que_LineFACFCL_TVA.asFloat);
                        Frm_CalcEntet.SetMoinsMontant(RoundRV(que_LineFACMTLINE.asFloat, 2), que_LineFACFCL_TVA.asFloat);

                        IF (que_LineFACARF_VIRTUEL.asInteger = 0) AND (memD_Stk.Active) THEN
                        BEGIN
                          // memd_Stk est positionné
                          MemD_Stk.Edit;
                          MemD_STKSTK.asFloat := MemD_STKSTK.asFloat + que_LineFacFCL_QTE.asfloat;
                          Memd_Stk.Post;
                        END;
                      END;

                      IF (FlagOk = 3) AND (que_LineFacFCL_SSTOTAL.asInteger <> 0) AND
                        (Que_LineFacFCL_LINETIP.asInteger = 0) THEN
                      BEGIN
                        IdST := que_LineFACFCL_SSTOTAL.asInteger;
                        // MTBRUT := RoundRV(que_LineFacPXSBR.asFloat * que_LineFacFCL_QTE.asFloat, 2);
                        // c'est ici la suppression d'une ligne article à l'intérieur du ST
                      END;

                      Que_LineFac.Delete;

                    END
                    ELSE BEGIN
                      // lignes from BLL
                      Que_LineFac.EDIT;
                      Que_LineFacFCL_SSTOTAL.asInteger := 0;
                      Que_LineFacREMISE.asFloat := 0;
                      Que_LineFAC.Post;
                      IF que_LineFacFCL_LINETIP.asInteger = 0 THEN
                      BEGIN
                        GetIndiceTaux(que_LineFACFCL_TVA.asFloat);
                        Frm_CalcEntet.SetMoinsMontant(MemMtBR, MemTvaLin); // si mt = 0 Ne fait rien
                        Frm_CalcEntet.SetPlusMontant(que_LineFacMTLINE.asfloat, que_LineFACFCL_TVA.asFloat);
                      END;

                    END;
                  END;
                END;
              END
            FINALLY
              LineModified := True;
              IF IdST <> 0 THEN
                CalcST(IdST);
            END;
          END;
        1:
          BEGIN
            TRY
              screen.Cursor := crSQLWait;
              Frm_NegFac.IdOfST(TS, que_LineFacFCL_ID.asInteger);

              FOR i := 0 TO TS.count - 1 DO
              BEGIN
                IF que_LineFac.Locate('FCL_ID', strToInt(TS[i]), []) THEN
                BEGIN

                  IF que_LineFacFCL_LINETIP.asInteger > 2 THEN
                  BEGIN
                    IF NOT que_RelDest.Active THEN
                    BEGIN
                      que_RelDest.paramByName('FCEID').asInteger := que_TetFacFCE_ID.asInteger;
                      Que_RelDest.Open;
                    END;

                    que_RelDest.First;
                    WHILE NOT que_RelDest.eof DO
                    BEGIN
                      IF que_RelDest.FieldByName('NGR_LINEIDD').asInteger = que_LineFacFCL_ID.asInteger THEN
                        que_RelDest.Delete
                      ELSE
                        que_RelDest.Next;
                    END;

                    Que_LineFac.Delete;
                  END
                  ELSE BEGIN
                    Que_LineFac.EDIT;
                    Que_LineFacFCL_SSTOTAL.asInteger := 0;
                    Que_LineFacREMISE.asFloat := 0;
                    Que_LineFAC.Post;
                    IF que_LineFacFCL_LINETIP.asInteger = 0 THEN
                    BEGIN
                      GetIndiceTaux(que_LineFACFCL_TVA.asFloat);
                      Frm_CalcEntet.SetMoinsMontant(MemMtBR, MemTvaLin); // si mt = 0 Ne fait rien
                      Frm_CalcEntet.SetPlusMontant(que_LineFacMTLINE.asfloat, que_LineFACFCL_TVA.asFloat);
                    END;
                  END;
                END;
              END
            FINALLY
              LineModified := True;
            END;
          END;
      END; // Du case
    END;
  FINALLY

    TS.Free;

    MajEntete;

    Frm_NegFac.Dbg_LineFac.ClearSelection;
    OnNewLine := False;
    NeoComent := 0;
    DoPostLine := True;

    Frm_NegFac.DBG_LineFac.EndUpdate;
    IF frm_NegFac.dbg_LineFac.focusedNode <> NIL THEN
      frm_NegFac.Dbg_LineFac.setFocus;

    screen.Cursor := crDefault;

  END;
END;

PROCEDURE TDm_NegFac.Tim_FocusTimer(Sender: TObject);
BEGIN
  Tim_Focus.Enabled := False;
  CASE Tim_Focus.Tag OF
    0:
      BEGIN
        CASE que_LineFacFCL_LineTip.AsInteger OF
          0:
            BEGIN
              IF Frm_NegFac.chp_QTE.enabled THEN
                Frm_NegFac.Chp_Qte.SetFocus
              ELSE Frm_NegFac.Chp_PXSBR.SetFocus;
            END;
          1, 2: Frm_NegFac.Chp_LineCom.SetFocus;
          3: Frm_NegFac.Chp_RemST.SetFocus;
        END;
      END;
    // les deux cas à suivre ne sont déclenchés que depuis le afterpostLine
    1: CalcST(STDifId);
    // mise à jour d'une modif de ligne ST
    2: CalcST(STDifId);
    // mise à jour d'une modif de ligne contenue dans un ST
  END;
  Tim_Focus.Tag := 0;

END;

PROCEDURE TDm_NegFac.Que_LineFACBeforePost(DataSet: TDataSet);
VAR
  Lestock, Tva, Pa, HT: Double;
  depass: Boolean;
BEGIN
  IF NOT DoBeforePostLine THEN EXIT;

  IF OnNewLine THEN Que_LineFACNEOLINE.AsInteger := 1;

  IF NOT ISREFRESH THEN
  BEGIN
    // Depass := False;
    IF isHT THEN
      Depass := Que_LineFacMTLINE.asFloat >= 770000
    ELSE
      Depass := Que_LineFacMTLINE.asFloat >= 920000;

    IF Depass THEN
    BEGIN
      StdGinKoia.DelayMess(NegMaxiLine, 3);
      ABORT;
    END;
  END;

  //    TRY
  DoCalcLine := False;
  // calcfields est inutile

  IF Que_LineFacFCL_LINETIP.asInteger = 0 THEN
  BEGIN
    IF DoCtrlStk AND (Memqte <> que_LineFacFCL_Qte.asFloat) AND
      (que_LineFACARF_VIRTUEL.asInteger = 0) THEN
    BEGIN
      // Lestock := 0;
      AligneMemdSTK;

      // pas de contrôle quand importe plusieurs lignes du glossaire
      Lestock := MemD_STKSTK.asFloat + MemQte - que_LineFacFCL_QTE.asFloat;
      IF LeStock < 0 THEN
        StdGinKoia.DelayMess(ParamsStr(AlerteStk, FormatFloat('#0', LeStock)), 3)
      ELSE BEGIN
        IF (stdGinkoia.Origine = 2) AND (MemD_STKSTKI.asFloat > 0) THEN
        BEGIN
          // ctrl stkI seulement en unidim
          IF MemD_STKSTKI.asFloat > LeStock THEN
            StdGinKoia.delayMess(ParamsStr(AlerteStkIdeal, VarArrayOf([
              FormatFloat('#0', LeStock), FormatFloat('#0', MemD_STKSTKI.asFloat)])), 3);
        END;
      END;
    END;

    // C'est seulement ici que selon isHT je mets à jour les champs adéquat
    IF isHT THEN
    BEGIN
      Que_LineFacFCL_PXBRUT.asFloat := GetPXTTC(Que_LineFacPXSBR.asFloat, Que_LineFacFCL_TVA.asfloat, 13);
      Que_LineFacFCL_PXNN.asFloat := GetPXTTC(Que_LineFacPXSAR.asFloat, Que_LineFacFCL_TVA.asfloat, 13);
      Que_LineFACFCL_PXNET.asFloat := GetPXTTC(Que_LineFacMTLINE.asFloat, Que_LineFacFCL_TVA.asfloat, 13);
    END
    ELSE
    BEGIN
      Que_LineFacFCL_PXBRUT.asFloat := Que_LineFacPXSBR.asFloat;
      Que_LineFacFCL_PXNN.asFloat := Que_LineFacPXSAR.asFloat;
      Que_LineFACFCL_PXNET.asFloat := Que_LineFacMTLINE.asFloat;
    END;

    Pa := 0;
    HT := 0;

    IF que_LineFACFCL_QTE.asFloat = 0 THEN
      Que_LineFacMARGE.asFloat := 0
    ELSE
    BEGIN
      IF que_LineFACARF_VIRTUEL.asInteger = 0 THEN
      BEGIN
        Pa := que_LineFACPUMP.asFloat * que_LineFACFCL_QTE.asFloat
      END
      ELSE BEGIN

        IF (que_LineFACARF_SERVICE.asInteger <> 1) AND
          (que_LineFACARF_COEFT.asFloat <> 0) THEN
          Pa := (que_LineFACFCL_PXBRUT.asFloat * (que_LineFacFCL_QTE.asfloat) / que_LineFACARF_COEFT.asFloat);
      END;

      IF que_TetFacFCE_TYPID.asFloat <> TipFacRetro THEN
      BEGIN
        IF NOT IsHT THEN
          HT := GetPxHT(que_LineFacMTLINE.asFloat, que_LineFacFCL_TVA.asFloat, 7)
        ELSE
          HT := que_LineFacMTLINE.asFloat;
        Que_LineFacMARGE.asFloat := HT - PA;
      END
      ELSE Que_LineFacMARGE.asFloat := 0;

    END;
  END;
  //    FINALLY
  DoCalcLine := True;
  //    END;
END;

PROCEDURE TDm_NegFac.Que_LineFACAfterPost(DataSet: TDataSet);
BEGIN

  IF NOT DoPostLine THEN EXIT;

  LineModified := True;
  // signale qu'une ligne vient d'être validée

  IF Que_LineFacFCL_LINETIP.asInteger = 0 THEN
  BEGIN
    GetIndiceTaux(que_LineFACFCL_TVA.asFloat);
    // Contrôle si indice TVA existe dans tablo et si non le crée
    Frm_CalcEntet.SetMoinsMontant(MemMtBR, MemTvaLin); // si mt = 0 Ne fait rien
    Frm_CalcEntet.SetPlusMontant(que_LineFacMTLINE.asfloat, que_LineFACFCL_TVA.asFloat);
    MajEntete; // l'entête est ici forcément en édition

    IF (que_LineFACARF_VIRTUEL.asInteger = 0) AND (memD_Stk.Active) THEN
      IF MemQte <> que_LineFacFCL_QTE.asFloat THEN
      BEGIN
        // memd_Stk est positionné
        MemD_Stk.Edit;
        MemD_STKSTK.asFloat := MemD_STKSTK.asFloat + MemQte - que_LineFacFCL_QTE.asFloat;
        Memd_Stk.Post;
      END;

    IF (Que_LineFacFCL_SSTOTAL.asInteger <> 0) AND (que_LineFacFCL_LINETIP.asInteger = 0) THEN
    BEGIN
      STDifID := que_LineFacFCL_SSTOTAL.asInteger;
      STDifMT := RoundRV(que_LineFacPXSBR.asfloat * que_LineFacFCL_QTE.asFloat, 2);
      Tim_Focus.Tag := 2;
      Tim_Focus.Enabled := True;
    END;
  END
  ELSE BEGIN
    IF (Que_LineFacFCL_LINETIP.asInteger = 3) THEN
    BEGIN
      STDifID := que_LineFacFCL_ID.asInteger;
      Tim_Focus.Tag := 1;
      Tim_Focus.Enabled := True;
    END;
  END;

  OnNewLine := False;
  NeoComent := 0;

  Frm_NegFac.Pan_fdSaisie.Visible := True;
  IF Frm_NegFac.Chp_Rech.Enabled AND Frm_NegFac.Chp_Rech.Visible THEN
    Frm_NegFac.Chp_Rech.SetFocus;

END;

PROCEDURE TDm_NegFac.Que_LineFACNewRecord(DataSet: TDataSet);
VAR
  NeoIdCh, NT, NC: STRING;
  Lid, i, Tail, Coul: Integer;
  LidOk, isFromGlos, isCbarre: boolean;
  LePrix: Double;
  Qtte: Double;
BEGIN
  LePrix := 0;
  IF ((Que_TetFACFCE_MODELE.asInteger <> 1)
    AND (que_TetFacFCE_DATE.asDateTIME < Date - 90)) THEN
  BEGIN
    // Lid := 0;
    LidOk := False;
    IF NeoComent = 0 THEN
    BEGIN
      isFromGlos := FromGlos;
      IF IsFromGlos THEN
        Lid := que_Glossaire.FieldByName('DVL_ARTID').asInteger
      ELSE
        Lid := que_Recherche.FieldByName('ART_ID').asInteger;
      TRY
        Ibc_CtrlPseudo.Close;
        Ibc_CtrlPseudo.ParamByName('ARTID').asInteger := Lid;
        Ibc_CtrlPseudo.Open;
        IF IBC_CtrlPseudo.RecordCount > 0 THEN
          LidOk := Ibc_CtrlPseudo.FieldByName('ARF_VIRTUEL').asInteger = 1;
      FINALLY
        Ibc_CtrlPseudo.Close;
      END;
    END
    ELSE LidOk := (NeoComent IN [1, 2]);

    IF NOT LidoK THEN
    BEGIN
      StdGinKoia.DelayMess(NegDateLim, 3);
      ABORT;
    END;
  END;

  IF Frm_NegFac.GetNeoIdLIne(NeoIdch) THEN
    //IF StdGinkoia.GetIdLigne(NeoIdch) THEN
  BEGIN
    isFromGlos := FromGlos;
    TRY

      DoCalcLine := False;
      // ne doit pas passer dans le onCalc lors de l'i,it d'une nouvelle ligne !

      isCBarre := CBRech;

      // ainsi sûr que reinitialisé ces variables car je travaille sur des
      // copies locales...
      CBRech := False;
      FromGlos := False;

      Qtte := CBQtte; // Sauve la quantité en tant que code barre
      CBQtte := 1; // Remet à 1

      OnNewLine := True;

      ibc_Art.Close;

      // Init des champs non utilisés
      que_LineFacFCL_BLLID.asInteger := 0;

      // Init des champs
      Que_LineFacFCL_NOM.asString := NeoIdCh;
      // détourné pour gérer un ordre d'affichage des lignes

      Que_LineFacFCL_ARTID.AsInteger := 0;
      Que_LineFacFCL_TYPID.asInteger := 0;
      que_LineFacFCL_FROMBLL.asInteger := 0;
      que_LineFacFCL_TGFID.asInteger := 0;
      que_LineFacFCL_COUID.asInteger := 0;
      que_LineFacTGF_NOM.asString := '';
      que_LineFacCOU_NOM.asString := '';

      Que_LineFacFCL_USRID.asInteger := 0;
      Que_LineFacUSR_USERNAME.asString := '';

      Que_LineFacFCL_COMENT.asstring := '';
      Que_LineFacFCL_Qte.asFloat := 0;
      Que_LineFacFCL_PXBRUT.asFloat := 0;
      que_LineFacFCL_PXNET.asFloat := 0;
      que_LineFacFCL_PXNET.asFloat := 0;
      que_LineFacFCL_PXNN.asFloat := 0;
      que_LineFacFCL_VALREMGLO.asFloat := 0;

      que_LineFacPXSBR.asFloat := 0;
      que_LineFacPXSAR.asFloat := 0;
      que_LineFacMTLINE.asFloat := 0;
      que_LineFacMARGE.asFloat := 0;

      que_LineFacPUMP.asFloat := 0;
      Que_LineFacFCL_TVA.asFloat := 0;
      que_LineFacART_REFMRK.asString := '';
      que_LineFacART_ORIGINE.asInteger := 0;
      que_LineFacARF_CHRONO.asstring := '';
      que_LineFacARF_VIRTUEL.asInteger := 0;
      que_LineFacARF_VTFRAC.asInteger := 0;
      que_LineFacARF_DIMENSION.asInteger := 0;
      que_LineFacARF_SERVICE.asInteger := 0;
      que_LineFacARF_COEFT.asFloat := 0;

      que_LineFacREMISE.asFloat := 0;

      Que_LineFacFCL_SSTOTAL.asInteger := MemRefST;
      // *****************************************

      Que_LineFacFCL_INSSTOTAL.asInteger := 0;
      Que_LineFacFCL_GPSSTOTAL.asInteger := 0;
      // Ligne masquée
      Que_LineFacFCL_LINETIP.asInteger := 0;
      // 0 ligne normale 1 commentaire

      IF NeoComent = 0 THEN
      BEGIN
        // si ce n'est pas un commentaire
        IF IsCBarre THEN
        BEGIN
          que_LineFacFCL_TGFID.asInteger := que_Recherche.FieldByName('CBI_TGFID').asInteger;
          que_LineFacFCL_COUID.asInteger := que_Recherche.FieldByName('CBI_COUID').asInteger;
          que_LineFacTGF_NOM.asString := que_Recherche.FieldByName('TGF_NOM').asString;
          que_LineFacCOU_NOM.asString := que_Recherche.FieldByName('COU_NOM').asString;
          que_LineFacFCL_QTE.asFloat := Qtte;
        END
        ELSE
        BEGIN

          IF IsFromGlos THEN
          BEGIN
            que_LineFacFCL_TGFID.asInteger := que_Glossaire.FieldByName('DVL_TGFID').asInteger;
            que_LineFacFCL_COUID.asInteger := que_Glossaire.FieldByName('DVL_COUID').asInteger;
            que_LineFacTGF_NOM.asString := que_Glossaire.FieldByName('TGF_NOM').asString;
            que_LineFacCOU_NOM.asString := que_Glossaire.FieldByName('COU_NOM').asString;
          END
          ELSE
          BEGIN
            IF que_Recherche.FieldByname('ARF_DIMENSION').asInteger = 1 THEN
            BEGIN
              Tail := que_LineFacFCL_TGFID.asInteger;
              Coul := que_LineFacFCL_COUID.asInteger;
              NT := que_LineFacTGF_NOM.asString;
              NC := que_LineFacCOU_NOM.asString;

              IF stdGinkoia.IsUniqueTailCoul(Que_Recherche.FieldByName('ART_ID').asInteger, Tail, NT, Coul, NC) THEN
              BEGIN
                que_LineFacFCL_TGFID.asInteger := Tail;
                que_LineFacFCL_COUID.asInteger := Coul;
                que_LineFacTGF_NOM.asString := NT;
                que_LineFacCOU_NOM.asString := NC;
              END
              ELSE BEGIN
                IF SelectTailCoul(Que_Recherche.FieldByName('ART_ID').asInteger,
                  Tail, coul, NT, NC) THEN
                BEGIN
                  que_LineFacFCL_TGFID.asInteger := Tail;
                  que_LineFacFCL_COUID.asInteger := Coul;
                  que_LineFacTGF_NOM.asString := NT;
                  que_LineFacCOU_NOM.asString := NC;
                END
                ELSE OnNewLine := False;
              END;
            END;
          END;
        END;

        IF OnNewLine THEN
        BEGIN
          LePrix := 0;
          i := Ibc_ART.SQL.IndexOf('/*BALISE1*/');

          IF (que_TetFacFCE_TYPID.asInteger = TipFacRetro) AND (i <> -1) THEN
          BEGIN
            CASE TIPPRIX OF
              0: // Pump
                BEGIN
                  Ibc_ART.SQL[i + 1] := '(SELECT S_PUMPDATE FROM RV_PUMPARTDATETAILLE (:MAGID,:ARTID,:LADATE,:TGFID,:COUID)) PVU';
                  ibc_art.paramByName('MAGID').asInteger := Que_TetFacFCE_MAGID.asInteger;
                  ibc_art.paramByName('LADATE').asDateTime := que_TetFacFCE_DATE.asDateTime;
                END;
              1: // PxNego
                BEGIN
                  Ibc_ART.SQL[i + 1] := '(SELECT S_PXNNACHAT FROM  RV_GETPXARETRO (:ARTID,:TGFID,:COUID,:NEGO)) PVU';
                  ibc_art.paramByName('NEGO').asInteger := 1;
                END;
              2: // PxCat
                BEGIN
                  Ibc_ART.SQL[i + 1] := '(SELECT S_PXNNACHAT FROM  RV_GETPXARETRO (:ARTID,:TGFID,:COUID,:NEGO)) PVU';
                  ibc_art.paramByName('NEGO').asInteger := 0;
                END;
            END; // du case
          END
          ELSE
          BEGIN

            IF que_TetFACFCE_WEB.asInteger = 1 THEN
            BEGIN
              TRY
                Que_PXVOCWEB.Close;
                Que_PXVOCWEB.ParamByName('ARTID').asInteger := que_Recherche.fieldByName('ART_ID').asInteger;
                Que_PXVOCWEB.ParamByName('CLTID').asInteger := que_TetFACFCE_CLTID.asInteger;
                Que_PXVOCWEB.OPEN;
                IF Que_PXVOCWEBIsOK.asInteger = 1 THEN LePrix := Que_PXVOCWebPXVTEOCWEB.asFloat;
              FINALLY
                Que_PXVOCWEB.Close;
              END
            END;

            Ibc_ART.SQL[i + 1] := '(SELECT R_PRIX FROM GETTVTPXVTE (:TVTID,:ARTID,:TGFID,:COUID)) PVU';

            IF (StdGinkoia.idTvtWeb > 0) AND (que_TetFacFCE_WEB.asInteger = 1) THEN
              ibc_art.paramByName('TVTID').asInteger := StdGinkoia.idTVTWeb
            ELSE
              ibc_art.paramByName('TVTID').asInteger := Que_TVTTVT_ID.asInteger;
          END;

          // même si glossaire rechart est initialisé
          ibc_art.paramByName('ARTID').asInteger := que_Recherche.fieldByName('ART_ID').asInteger;
          ibc_art.paramByName('TGFID').asInteger := que_LineFacFCL_TGFID.asInteger;
          ibc_art.paramByName('COUID').asInteger := que_LineFacFCL_COUID.asInteger;

          ibc_Art.Open;
          IF ibc_art.eof THEN OnNewLine := False;

          IF OnNewLine THEN
          BEGIN
            IF LePrix = 0 THEN LePrix := Ibc_Art.fieldByName('PVU').asFloat;

            Que_LineFacFCL_ARTID.AsInteger := Ibc_Art.fieldByName('ART_ID').asInteger;

            que_LineFacARF_VIRTUEL.asInteger := Ibc_Art.fieldByName('ARF_VIRTUEL').asInteger;
            que_LineFacARF_SERVICE.asInteger := Ibc_Art.fieldByName('ARF_SERVICE').asInteger;
            que_LineFacARF_COEFT.asFloat := Ibc_Art.fieldByName('ARF_COEFT').asFloat;

            Que_LineFacFCL_TVA.asFloat := Ibc_Art.fieldByName('TVA_TAUX').asFloat;
            que_LineFacART_REFMRK.asString := Ibc_Art.fieldByName('ART_REFMRK').asstring;
            que_LineFacART_ORIGINE.asInteger := Ibc_Art.fieldByName('ART_ORIGINE').asInteger;
            que_LineFacARF_CHRONO.asstring := Ibc_Art.fieldByName('ARF_CHRONO').asstring;
            que_LineFacARF_VTFRAC.asInteger := Ibc_Art.fieldByName('ARF_VTFRAC').asInteger;
            que_LineFacARF_DIMENSION.asInteger := Ibc_Art.fieldByName('ARF_DIMENSION').asInteger;

            IF Que_TetFACFCE_PRO.asInteger = 1 THEN // Professionnel
              Que_LineFACFCL_TYPID.asInteger := TipPro
            ELSE
              Que_LineFACFCL_TYPID.asInteger := TipNormal;
            // quand ventes promos et soldes ... seront gérées il faudra
            // ici mettre le type correspondant

            IF Que_LineFacARF_VIRTUEL.asInteger = 0 THEN
            BEGIN
              TRY
                IbStProc_PumpNeo.Close;
                IbstProc_PumpNeo.ParamByName('MAGID').asInteger := Que_TetFacFCE_MAGID.AsInteger;
                IbstProc_PumpNeo.ParamByName('ARTID').asInteger := Que_LineFacFCL_ARTID.AsInteger;
                IbstProc_PumpNeo.ParamByName('TGFID').asInteger := que_LineFacFCL_TGFID.asInteger;
                IbstProc_PumpNeo.ParamByName('COUID').asInteger := Que_LineFACFCL_COUID.asInteger;
                IbstProc_PumpNeo.ParamByName('LADATE').asDateTime := Que_TetFacFCE_Date.asDateTime;
                IbStProc_PumpNeo.Prepared := True;
                IbStProc_PumpNeo.ExecProc;
                que_LineFacPUMP.asFloat := IbStProc_PumpNeo.Fields[0].asFloat;

                IbStProc_PumpNeo.Close;
                IbStProc_PumpNeo.Unprepare;
              EXCEPT
                IbStProc_PumpNeo.Close;
                IbStProc_PumpNeo.Unprepare;
                OnNewLine := False;
              END;
            END;

            IF OnNewLine THEN
            BEGIN
              IF NOT IsFromGlos THEN
              BEGIN
                // Nota : Le glossaire n'est pas accessible sur les rétros
                IF Que_LineFacFCL_Qte.asFloat <= 1 THEN
                  Que_LineFacFCL_Qte.asFloat := 1;

                Que_LineFacFCL_COMENT.asstring := Ibc_Art.fieldByName('ART_NOM').asstring;

                IF (que_TetFacFCE_TYPID.asInteger = TipFacRetro) THEN
                BEGIN
                  // En rétro on est par défaut sur du HT car prix d'achat
                  // le tarif est aligné au dessus selon contexte Type

                  IF IsHT THEN
                    que_LineFacPXSBR.asFloat := LePrix
                  ELSE
                    que_LineFacPXSBR.asFloat := GetPxTTC(LePrix,
                      Ibc_Art.fieldByName('TVA_TAUX').asFloat, 2);
                END
                ELSE
                BEGIN
                  // ici tarif de vente donc sur du TTC par défaut
                  IF IsHT THEN
                    que_LineFacPXSBR.asFloat := GetPxHT(LePrix,
                      Ibc_Art.fieldByName('TVA_TAUX').asFloat, 2)
                  ELSE
                    que_LineFacPXSBR.asFloat := LePrix;
                END;

                que_LineFacPXSAR.asFloat := Que_LineFacPXSBR.asFloat;
                que_LineFacMTLINE.asFloat := (Que_LineFacPXSBR.asFloat * Que_LineFacFCL_Qte.asFloat);
              END
              ELSE
              BEGIN
                Que_LineFacFCL_Qte.asFloat := que_GlossaireDVL_QTE.asfloat;
                Que_LineFacFCL_COMENT.asstring := que_GlossaireDVL_COMENT.asstring;

                Que_LineFacPXSBR.asFloat := Que_GlossairePXSBR.asFloat;
                que_LineFacPXSAR.asFloat := Que_GlossairePXSAR.asFloat;
                que_LineFacMTLINE.asFloat := Que_GlossaireMTLINE.asFloat;
                que_LineFacREMISE.asFloat := Que_GlossaireREMISE.asFloat;
                Que_LineFacFCL_GPSSTOTAL.asInteger := que_GlossaireDVL_GPSSTOTAL.asInteger;
              END;

              IF MemREMST <> 0 THEN
              BEGIN
                que_LineFacREMISE.asFloat := MemREMST;
                que_LineFacPXSAR.AsFloat := GetPxNego(Que_LineFacPXSBR.asFloat, MemRemST, 2);
                que_LineFacMTLINE.AsFloat := GetPxNego(Que_LineFacFCL_QTE.asFloat * Que_LineFacPXSBR.asFloat, MemRemST, 2);
              END;

              Que_LineFacFCL_USRID.asInteger := Que_TetFacFCE_USRID.asInteger;
              Que_LineFacUSR_USERNAME.asString := Que_TetFacUSR_USERNAME.asstring;
            END;
          END;
        END;
      END;

      IF OnNewLine THEN
      BEGIN
        IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
          (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN

          OnNewLine := False

        ELSE
        BEGIN

          Que_LineFacFCL_FCEID.asInteger := Que_TetFacFCE_ID.asInteger;

          frm_negFac.SetcontextSaisie;

          IF NeoComent <> 0 THEN
          BEGIN
            IF isFromGlos THEN
            BEGIN
              Que_LineFACFCL_COMENT.asstring := que_GlossaireDVL_COMENT.asstring;
              Que_LineFACFCL_GPSSTOTAL.asInteger := que_GlossaireDVL_GPSSTOTAL.asInteger;
              Que_LineFACFCL_PXBRUT.asFloat := que_GlossaireDVL_PXBRUT.asFloat;
              Que_LineFACFCL_PXNN.asFloat := que_GlossaireDVL_PXNN.asFloat;
              Que_LineFACREMISE.asFloat := que_GlossaireREMISE.asFloat;

              Que_LineFacFCL_LINETIP.asInteger := NeoComent;
            END
            ELSE BEGIN
              IF NeoComent = 3 THEN
                Que_LineFACFCL_COMENT.asstring := NegLabPack;
              IF NeoComent = 4 THEN
                Que_LineFACFCL_COMENT.asstring := ''; // LibEntetST;

              Que_LineFacFCL_LINETIP.asInteger := NeoComent;
            END;
          END;
        END;
      END;

    FINALLY
      MemRemST := 0;
      MemRefST := 0;
      Tim_Focus.Tag := 0;
      DoCalcLine := True;
      IF OnNewLine THEN
      BEGIN
        IF NOT IsFromGlos THEN
          IF Que_LineFacFCL_LINETIP.asInteger <> 4 THEN
            Tim_Focus.Enabled := True;
      END
      ELSE ABORT;
    END;
  END
  ELSE ABORT;

END;

PROCEDURE TDm_NegFac.UpdateMask;
BEGIN
  // postage aprés changement du masquage non en edition
  WITH Dm_Main DO
  BEGIN
    TRY
      StartTransaction;
      IBOUpDateCache(que_LineFac);
      Commit;
    EXCEPT
      Rollback;
      IBOCancelCache(que_LineFac);
    END;
    IBOCommitCache(que_LineFac);
  END;

END;

PROCEDURE TDm_NegFac.Que_TVTTVT_NOMGetText(Sender: TField;
  VAR Text: STRING; DisplayText: Boolean);
BEGIN
  Text := ' ' + que_TVTTVT_NOM.asString;
END;

PROCEDURE TDm_NegFac.Decale(idRet: Integer; Nbre: Integer; IdNomStart: STRING);
VAR
  z, q: Extended;
  ch, chFrac: STRING;
  dernier: Boolean;
BEGIN
  dernier := False;
  q := 100000000000 * nbre;
  TRY
    screen.Cursor := crSQLWait;
    Frm_NegFac.Dbg_LineFac.BeginUpdate;

    IsRefresh := True;
    DoPostLine := False;
    DoBeforePostLine := False;
    DoCalcLine := False;

    Frm_NegFac.dbg_LineFac.GotoLast(True);
    Frm_NegFac.TNode := Frm_NegFac.dbg_LineFac.FocusedNode;

    WHILE Frm_NegFac.TNode <> NIL DO
    BEGIN
      ChFrac := '';

      Frm_NegFac.TNode.Focused := True;
      IF Que_LineFacFCL_NOM.asstring = idNomStart THEN Dernier := True;

      z := StrToFloat(copy(que_LineFacFCL_NOM.asstring, 1, 15));
      ChFrac := copy(que_LineFacFCL_NOM.asstring, 16, 15);

      z := z + q;
      ch := conv(z, 15);

      Que_LineFac.Edit;
      Que_LineFacFCL_NOM.asstring := ch + chFrac;
      Que_LineFac.Post;

      IF Dernier THEN
        BREAK
      ELSE
        Frm_NegFac.TNode := Frm_NegFac.Dbg_LineFac.FocusedNode.GetPrev;
    END;

  FINALLY
    Que_LineFac.Locate('FCL_ID', IdRet, []);
    IsRefresh := False;
    DoPostLine := True;
    DoCalcLine := True;
    DoBeforePostLine := True;

    Frm_NegFac.Dbg_LineFac.EndUpdate;

  END;
END;

PROCEDURE TDm_NegFac.RefreshDoc;
VAR
  TS: TStrings;
  Idpk: Integer;
  DoCalcST, FlagST: Boolean;
  MtlST: double;

  i: Integer;
  Remise, F2, G2, D3, mtlBR: Double;

  OldCumTTC : Extended;
BEGIN

  // Récupération du Total TTC afin de pouvoir le comparer à la fin du calcul
  OldCumTTC := Que_TetFAC.FieldByName('FCE_TVAHT1').AsFloat;

  TS := TStringList.Create;
  TRY
    screen.Cursor := crSQLWait;
    Frm_NegFac.Dbg_LineFac.BeginUpdate;

    IsRefresh := True;
    DoPostLine := False;
    DoCalcLine := False;

    Idpk := 0;
    FlagST := False;
    DoCalcST := False;
    MtlST := 0;

    Frm_NegFAC.dbg_LineFac.GotoFirst;
    Frm_NegFac.TNode := Frm_NegFac.dbg_LineFac.FocusedNode;
    que_LineFac.DisableControls;

    WHILE Frm_NegFac.TNode <> NIL DO
    BEGIN
      que_LineFac.Locate('FCL_ID', Frm_NegFac.dbg_LineFac.GetValueByFieldName(Frm_NegFac.TNode, 'FCL_ID'), []);

      IF que_LineFacFCL_LINETIP.asInteger = 0 THEN
      BEGIN
        Remise := GetRemise(Que_LineFacPXSBR.asFloat, que_LineFacPXSAR.asFloat, 13);

        IF (NOT (RoundRV(Que_LineFacMTLINE.asFloat, 2) = RoundRV(Que_LineFacPXSAR.asFloat * Que_LineFacFCL_QTE.asFloat, 2))) OR
          ((Que_LineFacFCL_QTE.asFloat = 0) AND (NOT (Que_LineFacPXSBR.asfloat = Que_LineFacPXSAR.asfloat))) THEN
        BEGIN
          que_LineFac.Edit;
          IF (que_LineFacFCL_SSTOTAL.asInteger = 0) AND (Remise <> 0) THEN
            // lignes non comprises dans un sous Total;
            Que_LineFacPXSAR.asFloat := GetPxNego(Que_LineFacPXSBR.asFloat, Remise, 2)
          ELSE
            Que_LineFacPXSAR.asFloat := Que_LineFacPXSBR.asFloat;

          Que_LineFacREMISE.asFloat := Remise;

          IF RoundRv(que_LineFacFCL_QTE.asFloat, 2) = 0 THEN
            Que_LineFacMTLINE.asFloat := 0
          ELSE
            Que_LineFacMTLINE.asFloat := RoundRV(Que_LineFacPXSAR.asFloat * que_LineFacFCL_QTE.asFloat, 2);

          que_LineFac.Post;

          Frm_CalcEntet.SetMoinsMontant(MemMtBR, MemTvaLin); // si mt = 0 Ne fait rien
          Frm_CalcEntet.SetPlusMontant(que_LineFacMTLINE.asfloat, que_LineFacFCL_TVA.asFloat);
          MajEntete; // l'entête est ici forcément en édition

          IF FlagST THEN DoCalcST := True;
        END;

        IF FlagST AND (que_LineFacFCL_LINETIP.asInteger <> 3) THEN
        BEGIN
          // c'est donc une ligne d'un sous total
          TS.add(Que_LineFacFCL_ID.asString);
          MtlST := MtlST + RoundRV(Que_LineFacPXSBR.asFloat * Que_LineFacFCL_QTE.asFloat, 2);
        END;
      END
      ELSE BEGIN

        IF que_LineFacFCL_LINETIP.asInteger = 4 THEN
        BEGIN
          TS.Clear;
          DoCalcST := False;
          IdPk := Que_LineFacFCL_SSTOTAL.asInteger;
          MtlST := 0;
          FlagST := True;
        END;
        IF que_LineFacFCL_LINETIP.asInteger = 3 THEN
        BEGIN

          IF DoCalcST OR (RoundRv(Que_LineFacFCL_PXBRUT.asFloat, 2) <> MtLst) THEN
          BEGIN
            // je calcule la remise existante...
            Remise := GetRemise(Que_LineFacFCL_PXBRUT.asFloat, que_LineFacFCL_PXNN.asFloat, 13);
            IF Remise = 0 THEN
            BEGIN
              // ici il ne se passe rien dans les postline puisque linetip = 3
              Que_LineFac.Edit;
              Que_LineFacFCL_PXBRUT.asFloat := RoundRV(MtLst, 2);
              Que_LineFacFCL_PXNN.asFloat := RoundRV(MtLst, 2);
              Que_LineFac.Post;
              TRY
                FOR i := 0 TO Ts.count - 1 DO
                BEGIN
                  IF Que_LineFac.Locate('FCL_ID', strToInt(Ts[i]), []) THEN
                  BEGIN
                    IF Que_LineFacFCL_SSTOTAL.asInteger <> IdPk THEN
                    BEGIN
                      Que_LineFac.Edit;
                      Que_LineFacFCL_SSTOTAL.asInteger := IdPk;
                      Que_LineFac.Post;
                    END;
                  END;
                END;
              FINALLY
                Que_LineFac.Locate('FCL_ID', idPk, []);
              END;

            END
            ELSE BEGIN
              TRY
                F2 := RounDRV(MTLST, 2);
                G2 := RoundRV((F2 * Remise) / 100, 2); // valeur remise
                Que_LineFac.Edit;
                Que_LineFacFCL_PXBRUT.asFloat := RoundRV(F2, 2);
                Que_LineFacFCL_PXNN.asFloat := RoundRV(F2 - G2, 2);
                Que_LineFac.Post;

                FOR i := 0 TO Ts.count - 1 DO
                BEGIN
                  IF Que_LineFac.Locate('FCL_ID', strToInt(Ts[i]), []) THEN
                  BEGIN
                    IF (F2 * G2 <> 0) THEN
                    BEGIN
                      MtlBR := RoundRV(Que_LineFacPXSBR.asFloat * Que_LineFacFCL_QTE.asFloat, 2);
                      D3 := RoundRv(MtlBR / F2 * G2, 2);
                      F2 := RoundRv(F2 - mtlBR, 2);
                      G2 := RoundRV(G2 - D3, 2);

                      Que_LineFac.Edit;
                      Que_LineFacFCL_SSTOTAL.asInteger := IdPk;
                      Que_LineFacMTLINE.asFloat := RoundRv(mtlBR - D3, 2);
                      IF Que_LineFacFCL_QTE.asFloat <> 0 THEN
                        Que_LineFacPXSAR.asFloat := RoundRV(Que_LineFacMTLINE.asFloat / Que_LineFacFCL_QTE.asFloat, 2)
                      ELSE
                        Que_LineFacPXSAR.asFloat := 0;
                      Que_LineFac.Post;
                    END
                    ELSE BEGIN
                      IF Que_LineFacFCL_SSTOTAL.asInteger <> IdPk THEN
                      BEGIN
                        Que_LineFac.Edit;
                        Que_LineFacFCL_SSTOTAL.asInteger := IdPk;
                        Que_LineFac.Post;
                      END;
                    END;
                  END;
                END;

              FINALLY
                Que_LineFac.Locate('FCL_ID', idPk, []);
              END;
            END;
          END
          ELSE BEGIN
            TRY
              FOR i := 0 TO Ts.count - 1 DO
              BEGIN
                IF Que_LineFac.Locate('FCL_ID', strToInt(Ts[i]), []) THEN
                BEGIN
                  IF Que_LineFacFCL_SSTOTAL.asInteger <> IdPk THEN
                  BEGIN
                    Que_LineFac.Edit;
                    Que_LineFacFCL_SSTOTAL.asInteger := IdPk;
                    Que_LineFac.Post;
                  END;
                END;
              END;
            FINALLY
              Que_LineFac.Locate('FCL_ID', idPk, []);
            END;
          END;

          DoCalcST := False;
          TS.Clear;
          IdPk := 0;
          MtlST := 0;
          FlagST := False;
        END;
        IF que_LineFacFCL_LINETIP.asInteger IN [1, 2] THEN
        BEGIN
          IF Flagst AND (que_LineFacFCL_SSTOTAL.asInteger <> IdPK) THEN
          BEGIN
            Que_LineFac.Edit;
            Que_LineFacFCL_SSTOTAL.asInteger := IdPk;
            Que_LineFac.Post;
          END;
        END;
      END;
      Frm_NegFac.TNode := Frm_NegFac.TNode.GetNext;
    END;

    que_TetFac.Edit;
    que_TetFac.Post;

    {
      Le calcul de l'entete + la mise à jour du compte client sont fait après ce premier post de l'entete
      car le calcul final n'est mis à jour qu'après validation.
      Le deuxieme post de que_tetfac plus bas est fait pour mettre à jour l'entete elle même avec les bons calculs
    }

    // Chargement du tableur d'entête
    WITH Frm_CalcEntet DO
    BEGIN // unité de gestion d'entête...
      SetNeoCalc(Que_TetFacFCE_HTWork.AsInteger);
      SetRemGlo(Que_tetFacFCE_REMISE.asFloat);
      FOR i := 1 TO 5 DO
      BEGIN
        // le tableau a été initialisé avec les bons indices correspondants
        // double algo pour récup d'éventuels PB antérieurs...
        IF (que_TetFac.FieldByName('FCE_TVAHT' + IntToStr(i)).asFloat <> 0) OR
          ((que_TetFac.FieldByName('FCE_TVAHT' + IntToStr(i)).asFloat = 0) AND
          (que_TetFac.FieldByName('FCE_TVATAUX' + IntToStr(i)).asFloat <> 0)) THEN
          SetPlusMontant(MemD_Cums.FieldByName('CumTTC').AsFloat, que_TetFac.FieldByName('FCE_TVATAUX' + IntToStr(i))
            .asFloat);
      END;
      // Initialisation des champs calculés
      MajEntete;
    END;

    // Modification du compte du client
    if CompareValue(OldCumTTC,MemD_Cums.FieldByName('CumTTC').AsFloat,0.01) <> EqualsValue then
    begin
      // Mise à jour du compte client
      // Rappel : on ne peut pas supprimer une facture
      que_CptClt.Close;
      que_CptClt.ParamByName('CLTID').asInteger := que_TetFacFCE_CLTID.asInteger;
      que_CptClt.ParamByName('FCEID').asInteger := que_TetFacFCE_ID.asInteger;
      que_CptClt.Open;

      que_CptClt.Edit;

      IF Que_TetFAC.FieldByName('FCE_TVAHT1').asFloat >= 0 THEN
      BEGIN
        IF que_TetFacFCE_DETAXE.asInteger <> 1 THEN
        BEGIN
          que_CptClt.fieldByName('CTE_DEBIT').asFloat := MemD_Cums.FieldByName('CumTTC').AsFloat;
          que_CptClt.fieldByName('CTE_CREDIT').asFloat := 0;
        END
        ELSE BEGIN
          que_CptClt.fieldByName('CTE_DEBIT').asFloat := MemD_Cums.FieldByName('CumHT').AsFloat;
          que_CptClt.fieldByName('CTE_CREDIT').asFloat := 0;
        END;
      END
      ELSE
      BEGIN
        IF que_TetFacFCE_DETAXE.asInteger <> 1 THEN
        BEGIN
          que_CptClt.fieldByName('CTE_CREDIT').asFloat := ABS(MemD_Cums.FieldByName('CumTTC').AsFloat);
          que_CptClt.fieldByName('CTE_DEBIT').asFloat := 0;
        END
        ELSE BEGIN
          que_CptClt.fieldByName('CTE_CREDIT').asFloat := ABS(MemD_Cums.FieldByName('CumHT').AsFloat);
          que_CptClt.fieldByName('CTE_DEBIT').asFloat := 0;
        END;
      END;
      que_CptClt.Post;
    end;

    que_TetFac.Edit;
    que_TetFac.Post;

  FINALLY
    TS.Free;

    IsRefresh := False;
    DoPostLine := True;
    DoCalcLine := True;
    que_LineFac.EnableControls;
    Frm_NegFac.Dbg_LineFac.EndUpdate;

    IF IsModele THEN
      Frm_ListeFacMod.NeedRefresh := True
    ELSE
      Frm_ListeFac.NeedRefresh := True

  END;
END;

PROCEDURE TDm_NegFac.RegenIDLin(IdRet: Integer; VAR IdPrec: STRING; VAR IdSuiv: STRING);
VAR
  i: Integer;
  z, q: Extended;
  ch: STRING;
BEGIN
  q := 100000000000;

  TRY
    screen.Cursor := crSQLWait;
    Frm_NegFAC.Dbg_LineFAC.BeginUpdate;

    IsRefresh := True;
    DoPostLine := False;
    DoBeforePostLine := False;
    DoCalcLine := False;

    i := Frm_NegFAC.dbg_LineFAC.Count + 1;
    Frm_NegFAC.dbg_LineFAC.GotoLast(True);
    Frm_NegFAC.TNode := Frm_NegFAC.dbg_LineFAC.FocusedNode;
    WHILE Frm_NegFAC.TNode <> NIL DO
    BEGIN
      Frm_NegFAC.TNode.Focused := True;
      Dec(i);
      z := q * i;
      ch := conv(z, 15);
      IF Que_LineFACFCL_NOM.asstring = idPrec THEN idPrec := ch;
      IF Que_LineFACFCL_NOM.asstring = idSuiv THEN idSuiv := ch;

      Que_LineFAC.Edit;
      Que_LineFACFCL_NOM.asstring := ch;
      Que_LineFAC.Post;
      Frm_NegFAC.TNode := Frm_NegFAC.Dbg_LineFAC.FocusedNode.GetPrev;
    END;

  FINALLY
    Que_LineFAC.Locate('FCL_ID', IdRet, []);
    IsRefresh := False;
    DoPostLine := True;
    DoCalcLine := True;
    DoBeforePostLine := True;

    Frm_NegFAC.Dbg_LineFAC.EndUpdate;

  END;
END;

PROCEDURE TDm_NegFac.Que_LineFACBeforeInsert(DataSet: TDataSet);
BEGIN
  IF (Tim_Focus.Tag <> 0) OR OnCalcSt THEN EXIT;
  // si des fois y'aurait un recalcul en cours par le timer ...
END;

PROCEDURE TDm_NegFac.Que_CategBeforeDelete(DataSet: TDataSet);
BEGIN
  IF (StdGinkoia.ID_EXISTE('NPRID', que_TetFACFCE_CATEG.asInteger, [])) OR
    (StdGinkoia.ID_EXISTE('SCAT', que_TetFACFCE_CATEG.asInteger, [])) OR
    (StdGinkoia.ID_EXISTE('CATEG', que_TetFACFCE_CATEG.asInteger, [])) THEN
  BEGIN
    StdGinKoia.DelayMess(NoDelDevCateg, 3);
    ABORT;
  END;

END;

PROCEDURE TDm_NegFac.Que_CategNewRecord(DataSet: TDataSet);
BEGIN
  IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
    (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;
  Que_CategNPR_LIBELLE.asstring := '';
  Que_CategNPR_TYPE.asInteger := 3;
  Que_CategNPR_CODE.asInteger := 0;
END;

PROCEDURE TDm_NegFac.SetPVURemClt;
BEGIN
  IF NOT (que_LineFac.State IN [dsInsert, dsEdit]) THEN
    Que_LineFac.Edit;

  Que_LineFacPXSBR.asFloat := RecTar.pxBrut;
  Que_LineFacREMISE.asFloat := GetRemise(RecTar.pxBrut, RecTar.prix, 13);
  Que_LineFacFCL_TYPID.asInteger := RecTar.Typid;
END;

FUNCTION TDm_NegFac.GetPVURemClt: Boolean;
BEGIN
  // Ici retourne toujours par defaut result à False !
  // si le contexte ( edition, ligne article, pas ST...) le permet calcule le PVU avec remise CLt, Toc ...etc
  // Result n'est mis à True qui si LePVu <> PxsAR et LePVU <> 0

  Result := False;
  RecTar.prix := 0;
  RecTar.typid := 0;
  RecTar.pxbrut := 0;
  RecTar.typcod := 0;

  IF ((Que_TetFacFCE_TYPID.asInteger = TipFacRetro) AND (TipFacRetro <> 0)) OR ((Que_TetFacFCE_TYPID.asInteger = TipFacLoc) AND (TipFacLoc <> 0)) THEN EXIT;

  IF Que_TetFac.State IN [dsInsert, dsEdit] THEN // SSI doc en édition
    IF (Que_LineFacFCL_LINETIP.asInteger = 0) AND (Que_LineFacFCL_SSTOTAL.asInteger = 0) THEN // SSI ligne article normale
    BEGIN
      TRY
        IF Que_Client.Active THEN Que_Client.RefreshRows;
        IF Que_CltMembrePro.Active THEN Que_CltMembrePro.RefreshRows;
        IbStProc_prix.Close;
        IbStProc_prix.Prepared := True;
        IbStProc_prix.ParamByName('TVTID').asInteger := Que_TVTTVT_ID.asInteger;
        IbStProc_prix.ParamByName('MAGID').asInteger := Que_TETFacFCE_MAGID.asInteger;

        IbStProc_prix.ParamByName('ARTID').asInteger := que_LineFacFCL_ARTID.asInteger;
        IbStProc_prix.ParamByName('TGFID').asInteger := que_LineFacFCL_TGFID.asInteger;
        IbStProc_prix.ParamByName('COUID').asInteger := que_LineFacFCL_COUID.asInteger;
        IbStProc_prix.ParamByName('CLTIDPART').asinteger := Que_ClientCLT_ID.asinteger;

        IF Que_ClientCLT_TYPE.asinteger = 0 THEN
        BEGIN // Client Normal
          IbStProc_prix.ParamByName('REMPART').asfloat := Que_ClientCLT_VTEREMISE.asfloat;
          IbStProc_prix.ParamByName('CLTIDPRO').asinteger := Que_CltMembreProPRM_CLTIDPRO.asinteger;
          IbStProc_prix.ParamByName('REMPRO').asfloat := Que_CltMembreProCLT_VTEREMISE.asfloat;
          IbStProc_prix.ParamByName('CLIPRO').asfloat := 0;
        END
        ELSE
        BEGIN
          // Client PRO
          IbStProc_prix.ParamByName('REMPART').asfloat := Que_ClientCLT_VTEREMISEPRO.asfloat;
          IbStProc_prix.ParamByName('CLTIDPRO').asinteger := 0;
          IbStProc_prix.ParamByName('REMPRO').asfloat := 0;
          IbStProc_prix.ParamByName('CLIPRO').asfloat := 1;
        END;

        IbStProc_prix.ExecProc;

        RecTar.typid := IbStProc_prix.Fieldbyname('r_typid').asinteger;
        RecTar.typcod := IbStProc_prix.Fieldbyname('r_typcod').asinteger;

        IF que_TetFacFCE_HTWORK.asInteger <> 1 THEN // notHt
        BEGIN
          RecTar.prix := roundRV(IbStProc_prix.Fieldbyname('R_prix').asfloat, 2);
          RecTar.pxbrut := roundRV(IbStProc_prix.Fieldbyname('R_prixbrut').asfloat, 2);
        END
        ELSE BEGIN
          Rectar.PxBrut := GetPxHT(IbStProc_prix.Fieldbyname('R_prixbrut').asfloat,
            que_LineFacFCL_TVA.asFloat, 2);
          Rectar.Prix := GetPxHT(IbStProc_prix.Fieldbyname('R_prix').asfloat,
            que_LineFacFCL_TVA.asFloat, 2);
        END;
      FINALLY
        IbStProc_prix.Close;
        IbStProc_prix.Unprepare;
        Result := (RecTar.Prix <> RecTar.pxBrut) AND
          (RecTar.prix < roundRV(Que_LineFacPXSAR.asfloat, 2));
      END;
    END;

END;

PROCEDURE TDm_NegFac.Que_TVTBeforeOpen(DataSet: TDataSet);
BEGIN
  //que_TVT.ParamByName('IDWEB').asInteger := stdGinkoia.IdTVTWEB;
END;

PROCEDURE ImprimeFacturePDF(IdFac: integer; sCheminPDF: STRING);
BEGIN
  // FC 02/03/09 : Création d'une fonction de création de facture direct en PDF, on passe l'id de la facture et le chemin du fichier de sortie
  IF stdginkoia.negfac_dm = 0 THEN
  BEGIN
    Dm_NegFac := TDm_NegFac.create(Application);
    Dm_NegFac.setParamImp;
  END;
  TRY
    Dm_NegFac.Preview := False;
    Dm_NegFac.ChxImp := False;

    IF (idFac > 0) AND (sCheminPDF <> '') THEN
    BEGIN
      ForceDirectories(ExtractFilePath(sCheminPDF));

      // Activation du mode PDF
      StdGinKoia.PrintToPdf.bActive := True;

      // TODO : nom de fichier
      StdGinKoia.PrintToPdf.sNomFichier := sCheminPDF;

      Dm_NegFac.ImprimeFactureKour(IdFac, False);
    END;
  FINALLY
    IF stdginkoia.negfac_dm = 0 THEN Dm_NegFac.Free;
  END;

END;

PROCEDURE ImprimeFacture(IdFac : integer);
BEGIN
  // FC 02/03/09 : Création d'une fonction de création de facture direct en PDF, on passe l'id de la facture et le chemin du fichier de sortie
  IF stdginkoia.negfac_dm = 0 THEN
  BEGIN
    Dm_NegFac := TDm_NegFac.create(Application);
    Dm_NegFac.setParamImp;
  END;
  TRY
    Dm_NegFac.Preview := False;
    Dm_NegFac.ChxImp := False;

    Dm_NegFac.ImprimeFactureKour(IdFac, False);
  FINALLY
    IF stdginkoia.negfac_dm = 0 THEN Dm_NegFac.Free;
  END;
END;


PROCEDURE TDm_NegFac.Que_TetFACFCE_DETAXEChange(Sender: TField);
BEGIN
  IF OnMajTete THEN EXIT;

  // On force la mise à jour de l'entete, pour que le post remette à jour le compte client, car le montant change (TTC/HT).
  MajEntete;
END;

END.

