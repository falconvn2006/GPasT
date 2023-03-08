//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------

UNIT NegBL_DM;

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
    RzLabel,
    IBDataset,
    IB_Components,
    IB_StoredProc,
    splashms,
    BmDelay,
    ExtCtrls,
    StrHlder,
    wwDialog,
    wwidlg,
    wwLookupDialogRv,
    dxmdaset;

TYPE

    TMultiTem = RECORD
        Neo: Boolean;
        MagId: Integer;
        TypId: Integer;
        Pro: Integer;
        Detaxe: Integer;
        Livreur: STRING[64];
        RemGlo: Extended;
        CpaId: Integer;
        MrgId: Integer;
        Reglement: TDateTime;
        CltId: Integer;
        CltNom: STRING[64];
        CltPrenom: STRING[64];
    END;

    TDm_NegBL = CLASS ( TDataModule )
        Grd_Close: TGroupDataRv;
        Que_TetBL: TIBOQuery;
        Que_TetBLBLE_ID: TIntegerField;
        Que_TetBLBLE_MAGID: TIntegerField;
        Que_TetBLBLE_CLTID: TIntegerField;
        Que_TetBLBLE_TYPE: TIntegerField;
        Que_TetBLBLE_NUMERO: TStringField;
        Que_TetBLBLE_DATE: TDateTimeField;
        Que_TetBLBLE_LIVREUR: TStringField;
        Que_TetBLBLE_REMISE: TIBOFloatField;
        Que_TetBLBLE_DETAXE: TIntegerField;
        Que_TetBLBLE_TVAHT1: TIBOFloatField;
        Que_TetBLBLE_TVATAUX1: TIBOFloatField;
        Que_TetBLBLE_TVA1: TIBOFloatField;
        Que_TetBLBLE_TVAHT2: TIBOFloatField;
        Que_TetBLBLE_TVATAUX2: TIBOFloatField;
        Que_TetBLBLE_TVA2: TIBOFloatField;
        Que_TetBLBLE_TVAHT3: TIBOFloatField;
        Que_TetBLBLE_TVATAUX3: TIBOFloatField;
        Que_TetBLBLE_TVA3: TIBOFloatField;
        Que_TetBLBLE_TVAHT4: TIBOFloatField;
        Que_TetBLBLE_TVATAUX4: TIBOFloatField;
        Que_TetBLBLE_TVA4: TIBOFloatField;
        Que_TetBLBLE_TVAHT5: TIBOFloatField;
        Que_TetBLBLE_TVATAUX5: TIBOFloatField;
        Que_TetBLBLE_TVA5: TIBOFloatField;
        Que_TetBLBLE_CLOTURE: TIntegerField;
        Que_TetBLBLE_ARCHIVE: TIntegerField;
        Que_TetBLBLE_USRID: TIntegerField;
        Que_TetBLBLE_TYPID: TIntegerField;
        Que_TetBLBLE_CLTNOM: TStringField;
        Que_TetBLBLE_CLTPRENOM: TStringField;
        Que_TetBLBLE_CIVID: TIntegerField;
        Que_TetBLBLE_VILID: TIntegerField;
        Que_TetBLBLE_ADRLIGNE: TMemoField;
        Que_TetBLBLE_MRGID: TIntegerField;
        Que_TetBLBLE_CPAID: TIntegerField;
        Que_TetBLBLE_NMODIF: TIntegerField;
        Que_TetBLBLE_COMENT: TMemoField;
        Que_TetBLBLE_MARGE: TIBOFloatField;
        Que_TetBLCPA_NOM: TStringField;
        Que_TetBLMAG_NOM: TStringField;
        Que_TetBLMRG_LIB: TStringField;
        Que_TetBLCIV_NOM: TStringField;
        Que_TetBLVIL_NOM: TStringField;
        Que_TetBLVIL_CP: TStringField;
        Que_TetBLPAY_NOM: TStringField;
        Que_TetBLTYP_LIB: TStringField;
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
        Que_MagasinMAG_NOM: TStringField;
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
        Que_Ville: TIBOQuery;
        Que_VilleVIL_ID: TIntegerField;
        Que_VilleVIL_NOM: TStringField;
        Que_VilleVIL_CP: TStringField;
        Que_VilleVIL_PAYID: TIntegerField;
        Que_VillePAY_NOM: TStringField;
        Que_Pays: TIBOQuery;
        Que_PaysPAY_ID: TIntegerField;
        Que_PaysPAY_NOM: TStringField;
        Que_TypeBL: TIBOQuery;
        Que_Vendeur: TIBOQuery;
        Que_Moder: TIBOQuery;
        Que_CdtP: TIBOQuery;
        IbStProc_Chrono: TIB_StoredProc;
        IbC_UvmOpen: TIB_Cursor;
        IbC_NotUvmOpen: TIB_Cursor;
        IbC_CtrlMag: TIB_Cursor;
        Que_LineBL: TIBOQuery;
        Que_LineBLBLL_ID: TIntegerField;
        Que_LineBLBLL_BLEID: TIntegerField;
        Que_LineBLBLL_ARTID: TIntegerField;
        Que_LineBLBLL_TGFID: TIntegerField;
        Que_LineBLBLL_COUID: TIntegerField;
        Que_LineBLBLL_NOM: TStringField;
        Que_LineBLBLL_USRID: TIntegerField;
        Que_LineBLBLL_QTE: TIBOFloatField;
        Que_LineBLBLL_PXBRUT: TIBOFloatField;
        Que_LineBLBLL_PXNET: TIBOFloatField;
        Que_LineBLBLL_PXNN: TIBOFloatField;
        Que_LineBLBLL_TYPE: TIntegerField;
        Que_LineBLBLL_SSTOTAL: TIntegerField;
        Que_LineBLBLL_INSSTOTAL: TIntegerField;
        Que_LineBLBLL_GPSSTOTAL: TIntegerField;
        Que_LineBLBLL_TVA: TIBOFloatField;
        Que_LineBLBLL_COMENT: TStringField;
        Que_LineBLBLL_TYPID: TIntegerField;
        Que_LineBLBLL_LINETIP: TIntegerField;
        Que_LineBLART_REFMRK: TStringField;
        Que_LineBLART_ORIGINE: TIntegerField;
        Que_LineBLARF_CHRONO: TStringField;
        Que_LineBLARF_DIMENSION: TIntegerField;
        Que_LineBLARF_VIRTUEL: TIntegerField;
        Que_LineBLARF_VTFRAC: TIntegerField;
        Que_LineBLTGF_NOM: TStringField;
        Que_LineBLCOU_NOM: TStringField;
        IbC_InitIdGrp: TIB_Cursor;
        IbC_Art: TIB_Cursor;
        Que_LineBLUSR_USERNAME: TStringField;
        Splash_Recherche: TSplashMessage;
        Que_Recherche: TIBOQuery;
        IbC_CtrlChrono: TIB_Cursor;
        Que_LineBLPUMP: TIBOFloatField;
        Que_LineBLREMISE: TFloatField;
        IbStProc_PumpNeo: TIB_StoredProc;
        Que_LineBLARF_SERVICE: TIntegerField;
        Que_LineBLARF_COEFT: TIBOFloatField;
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
        Que_ListeBLE_ID: TIntegerField;
        Que_ListeBLE_NUMERO: TStringField;
        Que_ListeBLE_DATE: TDateTimeField;
        Que_ListeBLE_CLTNOM: TStringField;
        Que_ListeBLE_CLTPRENOM: TStringField;
        Que_ListeBLE_REMISE: TIBOFloatField;
        Que_ListeBLE_ARCHIVE: TIntegerField;
        Que_ListeBLE_CLOTURE: TIntegerField;
        Que_ListeBLE_NMODIF: TIntegerField;
        Que_RelDest: TIBOQuery;
        Que_TFTet: TIBOQuery;
        Que_TFLine: TIBOQuery;
        Que_TFRel: TIBOQuery;
        Que_BTO: TIBOQuery;
        Que_BLO: TIBOQuery;
        IbStProc_NumFac: TIB_StoredProc;
        IbC_CodTrans: TIB_Cursor;
        Que_ListeBLE_MARGE: TIBOFloatField;
        Que_TetBLCLT_NUMERO: TStringField;
        Que_LineBLTTC1: TFloatField;
        Que_LineBLTTC2: TFloatField;
        Que_LineBLTTC3: TFloatField;
        Que_LineBLTTC4: TFloatField;
        Que_LineBLTTC5: TFloatField;
        Que_LineBLTVA1: TFloatField;
        Que_LineBLTVA2: TFloatField;
        Que_LineBLTVA3: TFloatField;
        Que_LineBLTVA4: TFloatField;
        Que_LineBLTVA5: TFloatField;
        Tim_TOTO: TTimer;
        Que_TetBLTOTTTC: TIBOFloatField;
        Que_TetBLTOTTVA: TIBOFloatField;
        Que_LineBLLMtTVA: TFloatField;
        Que_LineBLLMtHR: TFloatField;
        Que_LineBLLMtMrg: TFloatField;
        Que_TetBLTOTHT: TFloatField;
        IbC_TipLine: TIB_Cursor;
        Str_BLToClot: TStrHolder;
        Que_BTOBLE_ID: TIntegerField;
        Que_BTOBLE_MAGID: TIntegerField;
        Que_BTOBLE_CLTID: TIntegerField;
        Que_BTOBLE_TYPE: TIntegerField;
        Que_BTOBLE_NUMERO: TStringField;
        Que_BTOBLE_DATE: TDateTimeField;
        Que_BTOBLE_LIVREUR: TStringField;
        Que_BTOBLE_REMISE: TIBOFloatField;
        Que_BTOBLE_DETAXE: TIntegerField;
        Que_BTOBLE_TVAHT1: TIBOFloatField;
        Que_BTOBLE_TVATAUX1: TIBOFloatField;
        Que_BTOBLE_TVA1: TIBOFloatField;
        Que_BTOBLE_TVAHT2: TIBOFloatField;
        Que_BTOBLE_TVATAUX2: TIBOFloatField;
        Que_BTOBLE_TVA2: TIBOFloatField;
        Que_BTOBLE_TVAHT3: TIBOFloatField;
        Que_BTOBLE_TVATAUX3: TIBOFloatField;
        Que_BTOBLE_TVA3: TIBOFloatField;
        Que_BTOBLE_TVAHT4: TIBOFloatField;
        Que_BTOBLE_TVATAUX4: TIBOFloatField;
        Que_BTOBLE_TVA4: TIBOFloatField;
        Que_BTOBLE_TVAHT5: TIBOFloatField;
        Que_BTOBLE_TVATAUX5: TIBOFloatField;
        Que_BTOBLE_TVA5: TIBOFloatField;
        Que_BTOBLE_CLOTURE: TIntegerField;
        Que_BTOBLE_ARCHIVE: TIntegerField;
        Que_BTOBLE_USRID: TIntegerField;
        Que_BTOBLE_TYPID: TIntegerField;
        Que_BTOBLE_CLTNOM: TStringField;
        Que_BTOBLE_CLTPRENOM: TStringField;
        Que_BTOBLE_CIVID: TIntegerField;
        Que_BTOBLE_VILID: TIntegerField;
        Que_BTOBLE_ADRLIGNE: TMemoField;
        Que_BTOBLE_MRGID: TIntegerField;
        Que_BTOBLE_CPAID: TIntegerField;
        Que_BTOBLE_NMODIF: TIntegerField;
        Que_BTOBLE_COMENT: TMemoField;
        Que_BTOBLE_MARGE: TIBOFloatField;
        Que_BTOBLE_PRO: TIntegerField;
        Que_BLOBLL_ID: TIntegerField;
        Que_BLOBLL_BLEID: TIntegerField;
        Que_BLOBLL_ARTID: TIntegerField;
        Que_BLOBLL_TGFID: TIntegerField;
        Que_BLOBLL_COUID: TIntegerField;
        Que_BLOBLL_NOM: TStringField;
        Que_BLOBLL_USRID: TIntegerField;
        Que_BLOBLL_QTE: TIBOFloatField;
        Que_BLOBLL_PXBRUT: TIBOFloatField;
        Que_BLOBLL_PXNET: TIBOFloatField;
        Que_BLOBLL_PXNN: TIBOFloatField;
        Que_BLOBLL_TYPE: TIntegerField;
        Que_BLOBLL_SSTOTAL: TIntegerField;
        Que_BLOBLL_INSSTOTAL: TIntegerField;
        Que_BLOBLL_GPSSTOTAL: TIntegerField;
        Que_BLOBLL_TVA: TIBOFloatField;
        Que_BLOBLL_COMENT: TStringField;
        Que_BLOBLL_TYPID: TIntegerField;
        Que_BLOBLL_LINETIP: TIntegerField;
        Que_TetBLBLE_PRO: TIntegerField;
        Que_ListeBLE_PRO: TIntegerField;
        Que_ListeCLT_NUMERO: TStringField;
        Que_ListeBLE_CLTID: TIntegerField;
        Que_LineBLNEOLINE: TIntegerField;
        IbC_TipBL: TIB_Cursor;
        IbC_TipFac: TIB_Cursor;
        Tim_Focus: TTimer;
        IbC_CtrlId: TIB_Cursor;
        Que_TetBLBLE_REGLEMENT: TDateTimeField;
        Que_TetBLCPA_CODE: TIntegerField;
        Que_BTOBLE_REGLEMENT: TDateTimeField;
        Que_ListeCPA_CODE: TIntegerField;
        Que_ListeDateRglt: TDateTimeField;
        Que_TetImp: TIBOQuery;
        Que_TetImpCPA_NOM: TStringField;
        Que_TetImpMAG_NOM: TStringField;
        Que_TetImpMRG_LIB: TStringField;
        Que_TetImpCIV_NOM: TStringField;
        Que_TetImpCLT_NUMERO: TStringField;
        Que_TetImpTOTTTC: TIBOFloatField;
        Que_TetImpTOTTVA: TIBOFloatField;
        Que_TetImpCLTVILLE: TStringField;
        Que_TetImpCLTCP: TStringField;
        Que_TetImpCLTPAYS: TStringField;
        Que_TetImpMAGVILLE: TStringField;
        Que_TetImpMAGCP: TStringField;
        Que_TetImpMAGPAYS: TStringField;
        Que_TetImpSOC_NOM: TStringField;
        Que_TetImpCLTADR: TMemoField;
        Que_TetImpMAGADR: TMemoField;
        Que_TetImpCLIENT: TStringField;
        Que_TetImpHT1: TIBOFloatField;
        Que_TetImpHT2: TIBOFloatField;
        Que_TetImpHT3: TIBOFloatField;
        Que_TetImpHT4: TIBOFloatField;
        Que_TetImpHT5: TIBOFloatField;
        Que_TetImpTOTHT: TIBOFloatField;
        Que_TetImpTTCEURO: TFloatField;
        Que_TetImpDateRglt: TDateTimeField;
        Que_TetImpCPA_CODE: TIntegerField;
        Que_LineImp: TIBOQuery;
        Que_LineImpART_REFMRK: TStringField;
        Que_LineImpART_ORIGINE: TIntegerField;
        Que_LineImpARF_CHRONO: TStringField;
        Que_LineImpARF_DIMENSION: TIntegerField;
        Que_LineImpTGF_NOM: TStringField;
        Que_LineImpCOU_NOM: TStringField;
        Que_LineImpPUMP: TIBOFloatField;
        Que_LineImpREMISE: TFloatField;
        Que_LineImpLMtHR: TFloatField;
        Que_TetImpBLE_ID: TIntegerField;
        Que_TetImpBLE_MAGID: TIntegerField;
        Que_TetImpBLE_CLTID: TIntegerField;
        Que_TetImpBLE_TYPE: TIntegerField;
        Que_TetImpBLE_NUMERO: TStringField;
        Que_TetImpBLE_DATE: TDateTimeField;
        Que_TetImpBLE_LIVREUR: TStringField;
        Que_TetImpBLE_REMISE: TIBOFloatField;
        Que_TetImpBLE_DETAXE: TIntegerField;
        Que_TetImpBLE_TVAHT1: TIBOFloatField;
        Que_TetImpBLE_TVATAUX1: TIBOFloatField;
        Que_TetImpBLE_TVA1: TIBOFloatField;
        Que_TetImpBLE_TVAHT2: TIBOFloatField;
        Que_TetImpBLE_TVATAUX2: TIBOFloatField;
        Que_TetImpBLE_TVA2: TIBOFloatField;
        Que_TetImpBLE_TVAHT3: TIBOFloatField;
        Que_TetImpBLE_TVATAUX3: TIBOFloatField;
        Que_TetImpBLE_TVA3: TIBOFloatField;
        Que_TetImpBLE_TVAHT4: TIBOFloatField;
        Que_TetImpBLE_TVATAUX4: TIBOFloatField;
        Que_TetImpBLE_TVA4: TIBOFloatField;
        Que_TetImpBLE_TVAHT5: TIBOFloatField;
        Que_TetImpBLE_TVATAUX5: TIBOFloatField;
        Que_TetImpBLE_TVA5: TIBOFloatField;
        Que_TetImpBLE_CLOTURE: TIntegerField;
        Que_TetImpBLE_ARCHIVE: TIntegerField;
        Que_TetImpBLE_USRID: TIntegerField;
        Que_TetImpBLE_TYPID: TIntegerField;
        Que_TetImpBLE_CLTNOM: TStringField;
        Que_TetImpBLE_CLTPRENOM: TStringField;
        Que_TetImpBLE_CIVID: TIntegerField;
        Que_TetImpBLE_VILID: TIntegerField;
        Que_TetImpBLE_ADRLIGNE: TMemoField;
        Que_TetImpBLE_MRGID: TIntegerField;
        Que_TetImpBLE_CPAID: TIntegerField;
        Que_TetImpBLE_NMODIF: TIntegerField;
        Que_TetImpBLE_COMENT: TMemoField;
        Que_TetImpBLE_MARGE: TIBOFloatField;
        Que_TetImpBLE_PRO: TIntegerField;
        Que_TetImpBLE_REGLEMENT: TDateTimeField;
        Que_LineImpBLL_ID: TIntegerField;
        Que_LineImpBLL_BLEID: TIntegerField;
        Que_LineImpBLL_ARTID: TIntegerField;
        Que_LineImpBLL_TGFID: TIntegerField;
        Que_LineImpBLL_COUID: TIntegerField;
        Que_LineImpBLL_NOM: TStringField;
        Que_LineImpBLL_USRID: TIntegerField;
        Que_LineImpBLL_QTE: TIBOFloatField;
        Que_LineImpBLL_PXBRUT: TIBOFloatField;
        Que_LineImpBLL_PXNET: TIBOFloatField;
        Que_LineImpBLL_PXNN: TIBOFloatField;
        Que_LineImpBLL_TYPE: TIntegerField;
        Que_LineImpBLL_SSTOTAL: TIntegerField;
        Que_LineImpBLL_INSSTOTAL: TIntegerField;
        Que_LineImpBLL_GPSSTOTAL: TIntegerField;
        Que_LineImpBLL_TVA: TIBOFloatField;
        Que_LineImpBLL_COMENT: TStringField;
        Que_LineImpBLL_TYPID: TIntegerField;
        Que_LineImpBLL_LINETIP: TIntegerField;
        Que_TetImpTYP_LIB: TStringField;
        Que_CptClt: TIBOQuery;
        MemD_Trans: TdxMemData;
        MemD_TransIdBL: TStringField;
        MemD_TransMess: TStringField;
        MemD_TransIdFact: TStringField;
        MemD_TransKeyBL: TIntegerField;
        Str_Trans: TStrHolder;
        Splash_Trans: TSplashMessage;
        IbC_CdtP: TIB_Cursor;
    Que_TFLineFCL_ID: TIntegerField;
    Que_TFLineFCL_FCEID: TIntegerField;
    Que_TFLineFCL_ARTID: TIntegerField;
    Que_TFLineFCL_TGFID: TIntegerField;
    Que_TFLineFCL_COUID: TIntegerField;
    Que_TFLineFCL_NOM: TStringField;
    Que_TFLineFCL_USRID: TIntegerField;
    Que_TFLineFCL_QTE: TIBOFloatField;
    Que_TFLineFCL_PXBRUT: TIBOFloatField;
    Que_TFLineFCL_PXNET: TIBOFloatField;
    Que_TFLineFCL_PXNN: TIBOFloatField;
    Que_TFLineFCL_SSTOTAL: TIntegerField;
    Que_TFLineFCL_INSSTOTAL: TIntegerField;
    Que_TFLineFCL_GPSSTOTAL: TIntegerField;
    Que_TFLineFCL_TVA: TIBOFloatField;
    Que_TFLineFCL_COMENT: TStringField;
    Que_TFLineFCL_BLLID: TIntegerField;
    Que_TFLineFCL_TYPID: TIntegerField;
    Que_TFLineFCL_LINETIP: TIntegerField;
    Que_TFLineFCL_FROMBLL: TIntegerField;
    Que_TFLineFCL_DATEBLL: TDateTimeField;
    Que_TFRelNGR_ID: TIntegerField;
    Que_TFRelNGR_NPRID: TIntegerField;
    Que_TFRelNGR_LINEIDO: TIntegerField;
    Que_TFRelNGR_LINEIDD: TIntegerField;
        PROCEDURE DataModuleCreate ( Sender: TObject ) ;
        PROCEDURE DataModuleDestroy ( Sender: TObject ) ;
        PROCEDURE Que_TetBLAfterPost ( DataSet: TDataSet ) ;
        PROCEDURE Que_TetBLNewRecord ( DataSet: TDataSet ) ;
        PROCEDURE Que_TetBLUpdateRecord ( DataSet: TDataSet;
            UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction ) ;
        PROCEDURE Que_VilleAfterPost ( DataSet: TDataSet ) ;
        PROCEDURE Que_VilleBeforeDelete ( DataSet: TDataSet ) ;
        PROCEDURE Que_VilleNewRecord ( DataSet: TDataSet ) ;
        PROCEDURE Que_VilleUpdateRecord ( DataSet: TDataSet;
            UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction ) ;
        PROCEDURE Que_PaysAfterPost ( DataSet: TDataSet ) ;
        PROCEDURE Que_PaysBeforeDelete ( DataSet: TDataSet ) ;
        PROCEDURE Que_PaysNewRecord ( DataSet: TDataSet ) ;
        PROCEDURE Que_PaysUpdateRecord ( DataSet: TDataSet;
            UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction ) ;
        PROCEDURE Que_VilleBeforePost ( DataSet: TDataSet ) ;
        PROCEDURE Que_PaysBeforePost ( DataSet: TDataSet ) ;
        PROCEDURE Que_TetBLAfterScroll ( DataSet: TDataSet ) ;
        PROCEDURE Que_LineBLAfterPost ( DataSet: TDataSet ) ;
        PROCEDURE Que_LineBLNewRecord ( DataSet: TDataSet ) ;
        PROCEDURE Que_LineBLUpdateRecord ( DataSet: TDataSet;
            UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction ) ;
        PROCEDURE Que_LineBLAfterCancel ( DataSet: TDataSet ) ;
        PROCEDURE Que_TetBLAfterCancel ( DataSet: TDataSet ) ;
        PROCEDURE Que_LineBLCalcFields ( DataSet: TDataSet ) ;
        PROCEDURE Que_LineBLBLL_QTEValidate ( Sender: TField ) ;
        PROCEDURE Que_LineBLBLL_PXNETValidate ( Sender: TField ) ;
        PROCEDURE Que_LineBLAfterDelete ( DataSet: TDataSet ) ;
        PROCEDURE Que_ListeCalcFields ( DataSet: TDataSet ) ;
        PROCEDURE Que_ArchiveAfterPost ( DataSet: TDataSet ) ;
        PROCEDURE Que_ArchiveUpdateRecord ( DataSet: TDataSet;
            UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction ) ;
        PROCEDURE Que_RelDestUpdateRecord ( DataSet: TDataSet;
            UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction ) ;
        PROCEDURE Tim_TOTOTimer ( Sender: TObject ) ;
        PROCEDURE Que_TetBLBLE_REMISEChange ( Sender: TField ) ;
        PROCEDURE Que_TetBLCalcFields ( DataSet: TDataSet ) ;
        PROCEDURE Que_TetBLBLE_PROChange ( Sender: TField ) ;

        PROCEDURE Que_CptCltUpdateRecord ( DataSet: TDataSet;
            UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction ) ;
        PROCEDURE Que_LineBLBeforeEdit ( DataSet: TDataSet ) ;
        PROCEDURE Que_LineBLBeforePost ( DataSet: TDataSet ) ;
        PROCEDURE Tim_FocusTimer ( Sender: TObject ) ;
        PROCEDURE Que_TetBLCPA_CODEGetText ( Sender: TField; VAR Text: STRING;
            DisplayText: Boolean ) ;
        PROCEDURE Que_TetImpCalcFields ( DataSet: TDataSet ) ;
        PROCEDURE Que_LineImpCalcFields ( DataSet: TDataSet ) ;
        PROCEDURE Que_TetBLCPA_NOMGetText ( Sender: TField; VAR Text: STRING;
            DisplayText: Boolean ) ;

    Private

    { Déclarations privées }
    Public
    { Déclarations publiques }

        TheTTC: ARRAY[1..5] OF Extended;
        TxTva: ARRAY[1..5] OF Extended;
        TheTva: ARRAY[1..5] OF extended;
        TheMarge, TheTotal: extended;

        MultiTem: TMultiTem;

        DocTTC, ImpEuro, ImpTTC, ImpTextePied, ImpTete, ImpPied: Boolean; // gestion impression
        Preview, ChxImp: Boolean;

        ExDatas: ARRAY OF variant;

        InternalUpdate: Boolean;
        // utilisé pour les boucles internes sur les lignes pour éviter
        // le sutillement du panel de saisie ...

        NoControlDeline: Boolean;
        TransCode: Integer;
        TransPino: Boolean;
        MemPro, TipPro, TipNormal, TipBLRetro, TipFacRetro, TipFacNormal: Integer;
        IdxLTrans: Integer;

        Neost: Boolean; // en création d'un nouveau groupe
        NeoComent: Integer; // en création d'un commentaire

        IdGrp: Integer; // gestionnaire des id de groupes;
        TemRecherche: Integer;
        CbRech: Boolean;

        InsSTotal, GpsSTotal: Integer;
        IndexLine: Extended; // pour retrouver l'ordre des lignes

        NoCalcLine, OnNewRec, OnNewLine, OnUpdateBL, LineModified, UserVM: Boolean;

        Version: integer;
        RZL: TRzLabel;

        PROCEDURE AssigneFiche ( MaFiche: TObject ) ;
        PROCEDURE OpenBL ( IdBL: Integer ) ;
        PROCEDURE MajClient ( IdClt: Integer ) ;
        FUNCTION OkClient: Boolean;
        PROCEDURE ClearVille;
        PROCEDURE MajVille;
        PROCEDURE DMUserVM ( Uvm: Boolean ) ;
        FUNCTION ConfPost: Boolean;
        FUNCTION ConFCancel: Boolean;

        FUNCTION StateEdit: Integer;
        FUNCTION ControleDoc ( IdMag, IdDoc: Integer ) : Boolean;
        FUNCTION RechercheArt ( Rech: STRING ) : Integer;
        FUNCTION PrepareArt ( Rech: STRING; Cas: Integer ) : Integer;
        FUNCTION CtrlChrono ( Chrono: STRING ) : Integer;
        PROCEDURE Neoline;
        PROCEDURE NewComent ( tip: Integer ) ;
        FUNCTION OnComent: Boolean;
        PROCEDURE AligneArticle ( Artid: Integer ) ;
        PROCEDURE Refresh;
        PROCEDURE MajTotaux ( Cas: Integer ) ;

        PROCEDURE OuvreListe;
        FUNCTION GetMagKour: Integer;
        PROCEDURE ArchiveBL ( IdBL: Integer ) ;
        FUNCTION CTRLOuvreBL ( IdBL: Integer ) : Integer;
        PROCEDURE DeleteLine;
        PROCEDURE DeleteBL;
        FUNCTION TransBLVersFact ( Multi, NeoDoc, Pino: Boolean; VAR NoFact: STRING ) : boolean;
        FUNCTION CodeDeTransfert ( TIP: Integer ) : Integer;
        FUNCTION TransBLKour: STRING;
        PROCEDURE TransBLMulti;

        FUNCTION TVAColumn ( Taux: Extended ) : Integer;
        PROCEDURE RechDoc ( Ledoc: STRING ) ;
        FUNCTION MajTransCache: Boolean;
        PROCEDURE DragNode ( P, N: Extended ) ;
        FUNCTION CtrlId ( IdSTR: STRING ) : Integer;

        FUNCTION ImprimeBLKour ( IdBL: Integer; First: Boolean ) : Boolean;
        PROCEDURE ParamImp;
        PROCEDURE SetParamImp ( ch: STRING ) ;

        FUNCTION BTOTVA ( Taux: Extended ) : Integer;
        PROCEDURE CancelTransCache;
        FUNCTION FinEntetMulti: Boolean;
    Published

        PROCEDURE GetTextEuro ( Sender: TField; VAR Text: STRING; DisplayText: Boolean ) ;

    END;

VAR
    Dm_NegBL: TDm_NegBL;

IMPLEMENTATION

USES ConstStd,
    Main_Dm,
    //NegBL_Frm,
    GinkoiaResStr,
    GinKoiaStd,
    stdCalcs,
    StdUtils,
    StdBdeUtils;
    //ListeBL_Frm,
    //ChxTailCoul_Frm,
    //ConfTransM_Frm,
    //RapRv_Frm,
    //NegParamImp_Frm,
    //ChxModeImp_Frm, TransRap_Frm;
{$R *.DFM}

{
VAR
    Frm_NegBL: TFrm_NegBL;
}

PROCEDURE Tdm_NegBL.Refresh;
BEGIN
    IF Que_TetBL.Active THEN
        IF que_TetBLBLE_ID.asInteger > 0 THEN
            OPENBL ( que_TetBLBLE_ID.asInteger ) ;
END;

FUNCTION Tdm_NegBL.StateEdit: Integer;
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
    IF NOT que_TetBl.Active THEN Exit;
    Result := 1;
    IF que_TetBl.IsEmpty THEN Exit;
    Result := 2;
    IF que_TetBl.state IN [dsEdit] THEN Exit;
    Result := 3;
    IF que_TetBl.state IN [dsInsert] THEN Exit;
    Result := 4;
    IF que_TetBlBLE_ARCHIVE.asInteger = 1 THEN Exit;
    Result := 5;
    IF que_TetBlBLE_CLOTURE.asInteger = 1 THEN Exit;
    Result := 6;
    IF que_TetBlBLE_NMODIF.asInteger = 1 THEN Exit;
    Result := 10;
END;

FUNCTION TDm_NegBl.CtrlId ( IdSTR: STRING ) : Integer;
BEGIN
    Result := 0;
    IF IsInteger ( IdStr, length ( IdStr ) ) THEN
    BEGIN
        TRY
            Ibc_CtrlId.close;
            Ibc_CtrlId.paramByName ( 'ARTID' ) .asInteger := StrToInt ( IdStr ) ;
            Ibc_CtrlId.Open;
            IF NOT Ibc_CtrlId.eof THEN
                Result := Ibc_CtrlId.FieldByName ( 'ARF_ARTID' ) .asInteger;
            Ibc_CtrlId.close;
        EXCEPT
            Ibc_CtrlId.close;
            // Pour les cas où arrive une valeur entièrement numérique
            // supérieure à l'entier maxi posssible ...
        END;
    END;
END;

PROCEDURE TDm_NegBL.GetTextEuro ( Sender: TField; VAR Text: STRING; DisplayText: Boolean ) ;
BEGIN
    Text := StdGinkoia.Convert ( ( Sender AS TField ) .AsFloat ) ;
END;

PROCEDURE TDm_NegBL.DMUserVM ( Uvm: Boolean ) ;
BEGIN
    UserVM := UVM;
END;

PROCEDURE TDm_NEGBL.OpenBL ( IdBL: Integer ) ;
BEGIN
END;

FUNCTION Tdm_NegBL.ControleDoc ( IdMag, IdDoc: Integer ) : Boolean;
BEGIN

    Ibc_CtrlMAG.Close;
    Ibc_CtrlMAG.ParamByName ( 'BLEID' ) .asInteger := IdDoc;
    Ibc_CtrlMAG.ParamByName ( 'MAGID' ) .asInteger := IdMag;
    Ibc_CtrlMag.Open;

    Result := NOT Ibc_CtrlMag.eof;
    Ibc_CtrlMag.Close;
END;

PROCEDURE TDM_NEGBL.MajVille;
BEGIN
    Que_TetBLPAY_NOM.asstring := Que_VillePAY_NOM.AsString;
    Que_TetBLVIL_CP.asstring := Que_VilleVIL_CP.AsString;
END;

PROCEDURE TDM_NEGBL.ClearVille;
BEGIN
    Que_TetBLPAY_NOM.asstring := '';
    Que_TetBLVIL_CP.asstring := '';
END;

FUNCTION TDM_NEGBL.OkClient: Boolean;
BEGIN
    Result := False;
    IF Que_TetBL.State IN [dsInsert, dsEdit] THEN
        Result := Que_TetBLBLE_CLTID.asInteger > 0;
END;

PROCEDURE TDM_NEGBL.MajClient ( idClt: Integer ) ;
BEGIN
    que_Client.close ;
    que_Client.paramByName('CLTID').AsInteger := IdCLT ;
    que_Client.Open;

    IF NOT ( que_TetBL.State IN [DsInsert, dsEdit] ) THEN
        que_TetBL.Edit;

    Que_TetBLBLE_CIVID.asInteger := Que_ClientCLT_CIVID.asInteger;
    Que_TetBLCIV_NOM.asString := Que_ClientCIV_NOM.asString;
    Que_TetBLBLE_CLTID.asInteger := Que_ClientCLT_ID.asInteger;
    Que_TetBLBLE_CLTNOM.asString := Que_ClientCLT_NOM.asString;
    Que_TetBLBLE_CLTPRENOM.asString := Que_ClientCLT_PRENOM.asString;
    Que_TetBLBLE_VILID.asInteger := Que_ClientVIL_ID.asInteger;
    Que_TetBLVIL_NOM.asString := Que_ClientVIL_NOM.asString;
    Que_TetBLPAY_NOM.asString := Que_ClientPAY_NOM.asString;
    Que_TetBLVIL_CP.asString := Que_ClientVIL_CP.asString;
    Que_TetBLBLE_ADRLIGNE.asString := Que_ClientADR_LIGNE.asString;
    Que_TetBLBLE_MRGID.asInteger := Que_ClientCLT_MRGID.asInteger;
    Que_TetBLMRG_LIB.asString := Que_ClientMRG_LIB.asString;
    Que_TetBLBLE_CPAID.asInteger := Que_ClientCLT_CPAID.asInteger;
    Que_TetBLCPA_NOM.asString := Que_ClientCPA_NOM.asString;
    Que_TetBLCLT_NUMERO.asString := Que_ClientCLT_NUMERO.asString;

//    Frm_NegBL.Lab_Pro.Visible := Que_ClientCLT_TYPE.asInteger = 1;

END;

PROCEDURE TDm_NegBL.AssigneFiche ( MaFiche: TObject ) ;
BEGIN
END;

PROCEDURE TDm_NegBL.DataModuleCreate ( Sender: TObject ) ;
VAR
    ch: STRING;
BEGIN
    Version := 3;
    Preview := False;
    ChxImp := True;
    ImpTete := True;
    ImpPied := True;
    ImpTextePied := True;
    ImpTTC := True;
    ImpEuro := True;
    DocTTc := True;

    TransPino := False;

    OnNewRec := False;
    OnNewLine := False;

    NeoSt := False;
    NeoComent := 0;
    IdGrp := 0;
    NoCalcLine := False;
    CbRech := False;
    TemRecherche := -1;
    LineModified := False;
    OnUpdateBL := False;
    UserVM := False;
    NoControlDeline := False;
    InternalUpdate := False;

    TipNormal := 0;
    TipPro := 0;
    TipBlRetro := 0;
    TipFacRetro := 0;
    TipFacNormal := 0;

    // Type de Ligne normale
    Ibc_TipLine.Close;
    Ibc_TipLine.ParamByName ( 'LETIP' ) .asInteger := 1;
    Ibc_TipLine.Open;
    IF NOT Ibc_TipLine.eof THEN
        TipNormal := Ibc_TipLine.FieldByName ( 'TYP_ID' ) .asInteger;
    Ibc_TipLine.Close;

    // Type de ligne professionnelle
    Ibc_TipLine.Close;
    Ibc_TipLine.ParamByName ( 'LETIP' ) .asInteger := 5;
    Ibc_TipLine.Open;
    IF NOT Ibc_TipLine.eof THEN
        TipPro := Ibc_TipLine.FieldByName ( 'TYP_ID' ) .asInteger;
    Ibc_TipLine.Close;

    // Note le Type retro d'un BL
    Ibc_TipBL.Close;
    Ibc_TipBL.ParamByName ( 'LETIP' ) .asInteger := 117;
    Ibc_TipBL.Open;
    IF NOT Ibc_TipBL.eof THEN
        TipBLRetro := Ibc_TipBL.FieldByName ( 'TYP_ID' ) .asInteger;
    Ibc_TipBL.Close;

    // Note le Type retro d'une Facture
    Ibc_TipFac.Close;
    Ibc_TipFac.ParamByName ( 'LETIP' ) .asInteger := 1001;
    Ibc_TipFac.Open;
    IF NOT Ibc_TipFac.eof THEN
        TipFacRetro := Ibc_TipFac.FieldByName ( 'TYP_ID' ) .asInteger;

    // Type de facture normale
    Ibc_TipFac.Close;
    Ibc_TipFac.ParamByName ( 'LETIP' ) .asInteger := 901;
    Ibc_TipFac.Open;
    IF NOT Ibc_TipFac.eof THEN
        TipFacNormal := Ibc_TipFac.FieldByName ( 'TYP_ID' ) .asInteger;
    Ibc_TipFac.Close;

    // init des param d'impression
END;

PROCEDURE TDm_NegBL.DataModuleDestroy ( Sender: TObject ) ;
BEGIN
    Grd_Close.Close;
END;

PROCEDURE TDm_NegBL.Que_TetBLAfterPost ( DataSet: TDataSet ) ;
VAR
    id: Integer;
BEGIN
    InternalUpdate := True;
    OnUpdateBL := True;
   // Sinon pb dans le OncalcFields ... n'est pas en édition !

    TRY
        Screen.Cursor := crSQLWait;
        WITH Dm_Main DO
        BEGIN
            TRY
                StartTransaction;

                IBOUpDateCache ( que_TetBL ) ;
                IBOUpDateCache ( que_LineBL ) ;
                IBOUpDateCache ( que_RelDest ) ;

                Commit;
            EXCEPT

                Rollback;

                IBOCancelCache ( que_TetBL ) ;
                IBOCancelCache ( que_LineBL ) ;
                IBOCancelCache ( que_RelDest ) ;
            END;

            IBOCOmmitCache ( que_TetBL ) ;
            IBOCommitCache ( que_LineBL ) ;
            IBOCommitCache ( que_RelDest ) ;

        END;
    FINALLY
        Screen.Cursor := crDefault;

        OnNewRec := False;
        OnNewLine := False;
        NeoComent := 0;
        NeoSt := False;
        NoCalcLine := False;
        OnUpdateBL := False;
        LineModified := False;
        NoControlDeline := False;

        IF que_TetBLBLE_ID.asInteger <> 0 THEN
        BEGIN
        END
        ELSE
        BEGIN
            // Cas particulier aprés suppression
            que_Liste.Close;
            Id := CTRLOuvreBL ( que_TetBL.FieldByname ( 'BLE_ID' ) .asInteger ) ;
            OpenBL ( Id ) ;
        END;
        InternalUpdate := False;

    END;

END;

PROCEDURE TDm_NegBL.Que_TetBLNewRecord ( DataSet: TDataSet ) ;
BEGIN
    IF NOT Dm_Main.IBOMajPkKey ( ( DataSet AS TIBODataSet ) ,
        ( DataSet AS TIBODataSet ) .KeyLinks.IndexNames[0] ) THEN Abort;

    OnNewRec := True;
    Que_TetBLBLE_NUMERO.asString := NegFacCroPro;

  // champs plus gées laissés par compatibilité
    Que_TetBLBLE_TYPE.asInteger := 0;
    Que_TetBLBLE_LIVREUR.asString := '';

  // Champs Gérés

  // Magasin courant par défaut...
    Que_TetBLBLE_MAGID.asInteger := StdGinKoia.MagasinId;
    Que_TetBLMAG_NOM.asString := StdGinKoia.MagasinName;

    IF NOT que_TypeBl.Active THEN que_TypeBL.Open;
    IF que_TypeBl.Locate ( 'TYP_COD', 113, [] ) THEN
    BEGIN
      // Bon de livraison par défaut
        Que_TetBLTYP_LIB.asString := que_TypeBl.FieldByName ( 'TYP_LIB' ) .asstring;
        Que_TetBLBLE_TYPID.asInteger := que_TypeBl.FieldByName ( 'TYP_ID' ) .asInteger;
    END
    ELSE
    BEGIN
        Que_TetBLTYP_LIB.asString := '';
        Que_TetBLBLE_TYPID.asInteger := 0;
    END;

    Que_TetBLBLE_PRO.asInteger := 0;
    Que_TetBLBLE_CLTID.asInteger := 0;
    Que_TetBLBLE_DATE.asDateTime := Date;
    Que_TetBLBLE_REMISE.asFloat := 0;
    Que_TetBLBLE_DETAXE.asInteger := 0;

    Que_TetBLBLE_TVAHT1.asFloat := 0;
    Que_TetBLBLE_TVATAUX1.asFloat := 0;
    Que_TetBLBLE_TVA1.asFloat := 0;

    Que_TetBLBLE_TVAHT2.asFloat := 0;
    Que_TetBLBLE_TVATAUX2.asFloat := 0;
    Que_TetBLBLE_TVA2.asFloat := 0;

    Que_TetBLBLE_TVAHT3.asFloat := 0;
    Que_TetBLBLE_TVATAUX3.asFloat := 0;
    Que_TetBLBLE_TVA3.asFloat := 0;

    Que_TetBLBLE_TVAHT4.asFloat := 0;
    Que_TetBLBLE_TVATAUX4.asFloat := 0;
    Que_TetBLBLE_TVA4.asFloat := 0;

    Que_TetBLBLE_TVAHT5.asFloat := 0;
    Que_TetBLBLE_TVATAUX5.asFloat := 0;
    Que_TetBLBLE_TVA5.asFloat := 0;

    Que_TetBLBLE_CLOTURE.asInteger := 0;
    Que_TetBLBLE_ARCHIVE.asInteger := 0;
    Que_TetBLBLE_USRID.asInteger := 0;

    Que_TetBLBLE_CLTNOM.asString := '';
    Que_TetBLBLE_CLTPRENOM.asString := '';
    Que_TetBLBLE_CIVID.asInteger := 0;
    Que_TetBLBLE_VILID.asInteger := 0;
    Que_TetBLBLE_ADRLIGNE.asString := '';
    Que_TetBLBLE_MRGID.asInteger := 0;
    Que_TetBLBLE_CPAID.asInteger := 0;
    Que_TetBLBLE_NMODIF.asInteger := 0;
    Que_TetBLBLE_COMENT.asString := '';
    Que_TetBLBLE_MARGE.asFloat := 0;

  // Champs associés
    Que_TetBLCPA_CODE.asInteger := 0;
    Que_TetBLCPA_NOM.asString := '';
    Que_TetBLMRG_LIB.asString := '';
//    Que_TetBLUSR_USERNAME.asString := '';
    Que_TetBLCIV_NOM.asString := '';
    Que_TetBLVIL_NOM.asString := '';
    Que_TetBLVIL_CP.asString := '';
    Que_TetBLPAY_NOM.asString := '';
    Que_TetBLCLT_NUMERO.asString := '';

    Que_TetBLTOTTVA.asFloat := 0;
    Que_TetBLTOTTTC.asFloat := 0;
    Que_TetBLTOTHT.asFloat := 0;

END;

PROCEDURE TDm_NegBL.Que_TetBLUpdateRecord ( DataSet: TDataSet;
    UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction ) ;
BEGIN
    Dm_Main.IBOUpdateRecord ( ( DataSet AS TIBODataSet ) .KeyRelation,
        ( DataSet AS TIBODataSet ) , UpdateKind, UpdateAction ) ;
END;

PROCEDURE TDm_NegBL.Que_VilleAfterPost ( DataSet: TDataSet ) ;
BEGIN
    Dm_Main.IBOUpDateCache ( DataSet AS TIBOQuery ) ;
END;

PROCEDURE TDm_NegBL.Que_VilleBeforeDelete ( DataSet: TDataSet ) ;
BEGIN
    IF NOT Dm_Main.CheckAllowDelete ( ( DataSet AS TIBODataSet ) .KeyRelation,
        DataSet.FieldByName ( ( DataSet AS TIBODataSet ) .KeyLinks.IndexNames[0] ) .AsString,
        True ) THEN Abort;
END;

PROCEDURE TDm_NegBL.Que_VilleNewRecord ( DataSet: TDataSet ) ;
BEGIN
    IF NOT Dm_Main.IBOMajPkKey ( ( DataSet AS TIBODataSet ) ,
        ( DataSet AS TIBODataSet ) .KeyLinks.IndexNames[0] ) THEN Abort;
    Que_VilleVil_CP.asString := '';
    Que_VilleVil_PAYID.asInteger := 0;
    que_VillePAY_NOM.AsString := '';
END;

PROCEDURE TDm_NegBL.Que_VilleUpdateRecord ( DataSet: TDataSet;
    UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction ) ;
BEGIN
    Dm_Main.IBOUpdateRecord ( ( DataSet AS TIBODataSet ) .KeyRelation,
        ( DataSet AS TIBODataSet ) , UpdateKind, UpdateAction ) ;
END;

PROCEDURE TDm_NegBL.Que_PaysAfterPost ( DataSet: TDataSet ) ;
BEGIN
    Dm_Main.IBOUpDateCache ( DataSet AS TIBOQuery ) ;
END;

PROCEDURE TDm_NegBL.Que_PaysBeforeDelete ( DataSet: TDataSet ) ;
BEGIN
    IF NOT Dm_Main.CheckAllowDelete ( ( DataSet AS TIBODataSet ) .KeyRelation,
        DataSet.FieldByName ( ( DataSet AS TIBODataSet ) .KeyLinks.IndexNames[0] ) .AsString,
        True ) THEN Abort;
END;

PROCEDURE TDm_NegBL.Que_PaysNewRecord ( DataSet: TDataSet ) ;
BEGIN
    IF NOT Dm_Main.IBOMajPkKey ( ( DataSet AS TIBODataSet ) ,
        ( DataSet AS TIBODataSet ) .KeyLinks.IndexNames[0] ) THEN Abort;
    Que_PaysPay_Nom.AsString := '';
END;

PROCEDURE TDm_NegBL.Que_PaysUpdateRecord ( DataSet: TDataSet;
    UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction ) ;
BEGIN
    Dm_Main.IBOUpdateRecord ( ( DataSet AS TIBODataSet ) .KeyRelation,
        ( DataSet AS TIBODataSet ) , UpdateKind, UpdateAction ) ;
END;

PROCEDURE TDm_NegBL.Que_VilleBeforePost ( DataSet: TDataSet ) ;
BEGIN
    IF Que_VilleVil_PAYID.asInteger = 0 THEN
    BEGIN
        ABORT;
    END;
END;

PROCEDURE TDm_NegBL.Que_PaysBeforePost ( DataSet: TDataSet ) ;
BEGIN
    IF TRIM ( que_PaysPAY_NOM.asString ) = '' THEN
    BEGIN
        ABORT;
    END;
END;

FUNCTION TDm_NegBl.ConfPost: Boolean;
VAR
    done: Boolean;
BEGIN
    Result := True; // par défaut ne fera pas le post
    Done := False;

    IF que_TetBL.updatesPending OR que_TetBL.Modified THEN Done := True;
    IF LineModified THEN Done := True;

    IF Done THEN
    BEGIN

        IF que_TetBLBLE_MAGID.asInteger = 0 THEN
        BEGIN
            Exit;
        END;
        IF que_TetBLBLE_CLTID.asInteger = 0 THEN
        BEGIN
            Exit;
        END;
        IF Que_TetBLBLE_TYPID.asInteger = 0 THEN
        BEGIN
            Exit;
        END;

        // réinit du champ règlement si pas à saisir
        IF que_TetBL.FieldByName ( 'CPA_CODE' ) .asInteger <> 1 THEN
            que_TetBL.FieldByName ( 'BLE_REGLEMENT' ) .Clear;

        IF CNFMess ( WarPost, '', 0 ) = MrYes THEN
        BEGIN

            TRY
                IF OnNewRec THEN
                BEGIN
                    IbStProc_Chrono.Close;
                    IbStProc_Chrono.Prepared := True;
                    IbStProc_Chrono.ExecProc;
                    Que_TetBLBLE_NUMERO.asString := IbStProc_Chrono.Fields[0].asString;

                    IbStProc_Chrono.Close;
                    IbStProc_Chrono.Unprepare;
                END;
                Result := False;
            EXCEPT
                IF OnNewRec AND IbStProc_Chrono.Prepared THEN
                BEGIN
                    IbStProc_Chrono.Close;
                    IbStProc_Chrono.Unprepare;
                END;
            END;

        END;
    END
    ELSE que_TetBL.Cancel;
     // y'avait rien à sauver donc cancel et actionisdone ne fait rien

END;

FUNCTION TDm_NegBL.ConfCancel: Boolean;
VAR
    done: Boolean;
BEGIN
    // ici inversé car si en edit ou insert et que rien fait, doit exécuter
    // le cancel au bout du compte...

    Result := False; // par defaut fait le cancel
    done := False;

    IF que_TetBL.updatesPending OR que_TetBL.Modified THEN Done := True;
    IF LineModified THEN done := True;

    IF done THEN
    BEGIN
        IF NCNFMess ( WarCancel, '' ) <> MrYes THEN
            Result := True; // actionisdone = True donc pas de Cancel
    END;

END;

PROCEDURE TDm_NegBL.Que_TetBLAfterScroll ( DataSet: TDataSet ) ;
BEGIN

    IdGrp := 0;
     // réinit de l'id de groupage
    que_LineBL.Close;
    que_LineBL.ParamByName ( 'BLEID' ) .asInteger := que_TetBLBLE_ID.AsInteger;
//    que_LineBL.ParamByName ( 'MAGID' ) .asInteger := que_TetBLBLE_MAGID.AsInteger;
//    que_LineBL.ParamByName ( 'LADATE' ) .asDateTime := que_TetBLBLE_DATE.AsDateTime;

    que_LineBL.Open;


    que_Client.close ;
    que_Client.paramByName('CLTID').AsInteger := que_TetBLBLE_CLTID.AsInteger ;
    que_Client.Open;

    que_RelDest.Close;
    que_RelDest.paramByName ( 'BLEID' ) .asInteger := que_TetBLBLE_ID.AsInteger;
    Que_RelDest.Open;

    MemPro := que_TetBLBLE_PRO.asInteger;

END;

PROCEDURE TDm_NegBL.MajTotaux ( Cas: Integer ) ;
BEGIN
END;

PROCEDURE TDm_NegBL.Que_LineBLAfterPost ( DataSet: TDataSet ) ;
VAR
    i: Integer;
BEGIN

    LineModified := True;
    // signale qu'une ligne vient d'être validée
    IF InternalUpdate THEN Exit;

    Tim_Toto.Enabled := True;

    OnNewLine := False;
    NeoComent := 0;
    NeoSt := False;
    NoCalcLine := False;
    OnUpdateBL := False;

END;

PROCEDURE TDm_NegBL.Que_LineBLNewRecord ( DataSet: TDataSet ) ;
VAR
    ch, NT, NC: STRING;
    Tail, Coul: Integer;
    pmp: extended;
BEGIN
    OnNewLine := True;
    NoCalcLine := True;

    ibc_Art.Close;
  // Init des champs non utilisés
    Que_LineBLBLL_TYPE.asInteger := 0;

  // Init des champs
    Que_LineBLBLL_NOM.asString := Conv ( IndexLine, 15 ) ;
  // détourné pour gérer un ordre d'affichage des lignes

    Que_LineBLBLL_ARTID.AsInteger := 0;
    Que_LineBLBLL_TYPID.asInteger := 0;
    que_LineBLBLL_TGFID.asInteger := 0;
    que_LineBLBLL_COUID.asInteger := 0;
    que_LineBLTGF_NOM.asString := '';
    que_LineBLCOU_NOM.asString := '';

    Que_LineBLBLL_USRID.asInteger := 0;
    Que_LineBLUSR_USERNAME.asString := '';

    Que_LineBLBLL_COMENT.asstring := '';
    Que_LineBLBLL_Qte.asFloat := 0;
    Que_LineBLBLL_PXBRUT.asFloat := 0;
    que_LineBLBLL_PXNET.asFloat := 0;
    que_LineBLBLL_PXNET.asFloat := 0;
    que_LineBLBLL_PXNN.asFloat := 0;

    que_LineBLREMISE.asFloat := 0;
    que_LineBLLMtHR.asFloat := 0;
    que_LineBLLMtTVA.asFloat := 0;
    que_LineBLLMtMRG.asFloat := 0;
    que_LineBLPUMP.asFloat := 0;

    Que_LineBLBLL_TVA.asFloat := 0;
    que_LineBLART_REFMRK.asString := '';
    que_LineBLART_ORIGINE.asInteger := 0;
    que_LineBLARF_CHRONO.asstring := '';
    que_LineBLARF_VIRTUEL.asInteger := 0;
    que_LineBLARF_VTFRAC.asInteger := 0;
    que_LineBLARF_DIMENSION.asInteger := 0;
    que_LineBLARF_SERVICE.asInteger := 0;
    que_LineBLARF_COEFT.asFloat := 0;

    Que_LineBLBLL_SSTOTAL.asInteger := 0;
  // 0 ligne normale 1 ligne de pseudo SS
    Que_LineBLBLL_INSSTOTAL.asInteger := 0;
  // 0 ligne normale hors groupe  1 ligne faisant partie d'un groupe SStotal
    Que_LineBLBLL_GPSSTOTAL.asInteger := 0;
  // Contient un id de groupage
    Que_LineBLBLL_LINETIP.asInteger := 0;
  // 0 ligne normale 1 commentaire

    IF NeoComent = 0 THEN
    BEGIN
      // si ce n'est pas un commentaire
        IF CBRech THEN
        BEGIN
            que_LineBLBLL_TGFID.asInteger := que_Recherche.FieldByName ( 'CBI_TGFID' ) .asInteger;
            que_LineBLBLL_COUID.asInteger := que_Recherche.FieldByName ( 'CBI_COUID' ) .asInteger;
            que_LineBLTGF_NOM.asString := que_Recherche.FieldByName ( 'TGF_NOM' ) .asString;
            que_LineBLCOU_NOM.asString := que_Recherche.FieldByName ( 'COU_NOM' ) .asString;
        END
        ELSE
        BEGIN
            Cbrech := False;

            IF que_Recherche.FieldByname ( 'ARF_DIMENSION' ) .asInteger = 1 THEN
            BEGIN
                Tail := que_LineBLBLL_TGFID.asInteger;
                Coul := que_LineBLBLL_COUID.asInteger;
                NT := que_LineBLTGF_NOM.asString;
                NC := que_LineBLCOU_NOM.asString;

                OnNewLine := False;
                NoCalcLine := False;
                Abort;
            END;
        END;

        ibc_art.paramByName ( 'ARTID' ) .asInteger := que_Recherche.fieldByName ( 'ART_ID' ) .asInteger;
        ibc_art.paramByName ( 'MAGID' ) .asInteger := que_TetBLBLE_MAGID.asInteger;
        ibc_art.paramByName ( 'TGFID' ) .asInteger := que_LineBLBLL_TGFID.asInteger;

        ibc_Art.Open;
        IF ibc_art.eof THEN
        BEGIN
            OnNewLine := False;
            NoCalcLine := False;
            Abort;
        END;

        Que_LineBLBLL_ARTID.AsInteger := Ibc_Art.fieldByName ( 'ART_ID' ) .asInteger;
        Que_LineBLBLL_COMENT.asstring := Ibc_Art.fieldByName ( 'ART_NOM' ) .asstring;

        que_LineBLARF_VIRTUEL.asInteger := Ibc_Art.fieldByName ( 'ARF_VIRTUEL' ) .asInteger;
        que_LineBLARF_SERVICE.asInteger := Ibc_Art.fieldByName ( 'ARF_SERVICE' ) .asInteger;
        que_LineBLARF_COEFT.asFloat := Ibc_Art.fieldByName ( 'ARF_COEFT' ) .asFloat;

        Que_LineBLBLL_Qte.asFloat := 1;
        Que_LineBLBLL_PXBRUT.asFloat := Ibc_Art.fieldByName ( 'PVU' ) .asFloat;
        que_LineBLBLL_PXNET.asFloat := Que_LineBLBLL_PXBRUT.asFloat;
        que_LineBLBLL_PXNET.asFloat := Que_LineBLBLL_PXBRUT.asFloat;
        que_LineBLBLL_PXNN.asFloat := Que_LineBLBLL_PXBRUT.asFloat;

        IF Que_TetBLBLE_PRO.asInteger = 1 THEN // Professionnel
            Que_LineBLBLL_TYPID.asInteger := TipPro
        ELSE
            Que_LineBLBLL_TYPID.asInteger := TipNormal;
            // quand ventes promos et soldes ... seront gérées il faudra
            // ici mettre le type correspondant

        IF Que_LineBLARF_VIRTUEL.asInteger = 0 THEN
        BEGIN
            TRY
                IbStProc_PumpNeo.Close;
                IbstProc_PumpNeo.ParamByName ( 'MAGID' ) .asInteger := que_TetBLBLE_MAGID.AsInteger;
                IbstProc_PumpNeo.ParamByName ( 'ARTID' ) .asInteger := Que_LineBLBLL_ARTID.AsInteger;
                IbstProc_PumpNeo.ParamByName ( 'TGFID' ) .asInteger := que_LineBLBLL_TGFID.asInteger;
                IbstProc_PumpNeo.ParamByName ( 'LADATE' ) .asDateTime := que_TETBLBLE_Date.asDateTime;
                IbStProc_PumpNeo.Prepared := True;
                IbStProc_PumpNeo.ExecProc;
                que_LineBLPUMP.asFloat := IbStProc_PumpNeo.Fields[0].asFloat;

                IbStProc_PumpNeo.Close;
                IbStProc_PumpNeo.Unprepare;
            EXCEPT
                IbStProc_PumpNeo.Close;
                IbStProc_PumpNeo.Unprepare;
                OnNewLine := False;
                NoCalcLine := False;
                Abort;
            END;
        END;

        Que_LineBLBLL_USRID.asInteger := que_TetBLBLE_USRID.asInteger;
//        Que_LineBLUSR_USERNAME.asString := que_TetBLUSR_USERNAME.asstring;

        Que_LineBLBLL_TVA.asFloat := Ibc_Art.fieldByName ( 'TVA_TAUX' ) .asFloat;
        que_LineBLART_REFMRK.asString := Ibc_Art.fieldByName ( 'ART_REFMRK' ) .asstring;
        que_LineBLART_ORIGINE.asInteger := Ibc_Art.fieldByName ( 'ART_ORIGINE' ) .asInteger;
        que_LineBLARF_CHRONO.asstring := Ibc_Art.fieldByName ( 'ARF_CHRONO' ) .asstring;
        que_LineBLARF_VTFRAC.asInteger := Ibc_Art.fieldByName ( 'ARF_VTFRAC' ) .asInteger;
        que_LineBLARF_DIMENSION.asInteger := Ibc_Art.fieldByName ( 'ARF_DIMENSION' ) .asInteger;

    END;

    IF NOT Dm_Main.IBOMajPkKey ( ( DataSet AS TIBODataSet ) ,
        ( DataSet AS TIBODataSet ) .KeyLinks.IndexNames[0] ) THEN
    BEGIN
        OnNewLine := False;
        NoCalcLine := False;
        Abort;
    END;

    Que_LineBLBLL_BLEID.asInteger := que_TetBLBLE_ID.asInteger;
    NoCalcLIne := False;

    IF NeoComent <> 0 THEN
        Que_LineBLBLL_LINETIP.asInteger := NeoComent
    ELSE
        Que_LineBLCalcFields ( NIL ) ;
    Tim_Focus.Enabled := True;
END;

PROCEDURE TDm_NegBL.Que_LineBLUpdateRecord ( DataSet: TDataSet;
    UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction ) ;
BEGIN
    Dm_Main.IBOUpdateRecord ( ( DataSet AS TIBODataSet ) .KeyRelation,
        ( DataSet AS TIBODataSet ) , UpdateKind, UpdateAction ) ;
END;

FUNCTION TDm_NegBL.RechercheArt ( Rech: STRING ) : Integer;
VAR
    i, cas: Integer;
BEGIN
    Result := 0;
    CbRech := False;

    IF Trim ( rech ) = '' THEN EXIT;
    TRY
        screen.Cursor := crSQLWait;
        IF IsInteger ( Rech, 13 ) THEN
            Cas := 0
        ELSE
        BEGIN
            IF Trim ( Rech ) = '*' THEN
                cas := 3
            ELSE
            BEGIN
                i := CtrlId ( Rech ) ;
                IF i <> 0 THEN
                BEGIN
                    Cas := 4;
                END
                ELSE
                BEGIN
                    i := CtrlChrono ( Rech ) ;
                    IF i <> 0 THEN
                        cas := 1
                    ELSE cas := 2;
                END;
            END;
        END;

        Result := PrepareArt ( Rech, Cas ) ;

    FINALLY
        screen.cursor := crDefault;
        IF Result = 0 THEN
        BEGIN
            Splash_Recherche.FixedWidth := 350;
            Splash_Recherche.MessageText := CdeRechVide;
            Splash_Recherche.SplashDelay ( 1000 ) ;
        END
        ELSE
        BEGIN
            TemRecherche := cas;
            IF Result = 1 THEN
                IF ( Cas = 0 ) THEN // Cbarre
                    CBRech := True;

        END;

    END;
END;

FUNCTION TDm_NegBL.PrepareArt ( Rech: STRING; Cas: Integer ) : Integer;
VAR
    RechID: Integer;
BEGIN
    Result := 0;
    Que_Recherche.Close;

    CASE cas OF
        0:          // Cbarre

            BEGIN
                Que_Recherche.SQL.Clear;
                Que_Recherche.KeyLinks.Clear;
                Que_Recherche.JoinLinks.Clear;
                Que_Recherche.SQL.Add (
                    'select CBI_ID, CBI_TGFID, CBI_COUID, ARF_ID, ART_ID, ART_NOM, ART_REFMRK, ARF_CHRONO, TGF_NOM, COU_NOM, ARF_DIMENSION' ) ;
                Que_Recherche.SQL.Add ( 'from artcodebarre, k, artreference, artarticle, plxcouleur, plxtaillesGF' ) ;
                Que_Recherche.SQL.Add ( 'where k_enabled=1' ) ;
                Que_Recherche.SQL.Add ( 'and CBI_CB=:RECH and ARF_CATALOG=0' ) ;
                Que_Recherche.KeyRelation := 'ARTCODEBARRE';
                Que_Recherche.KeyLinks.Add ( 'CBI_ID' ) ;
                Que_Recherche.JoinLinks.Add ( 'cbi_id=k_id' ) ;
                Que_Recherche.JoinLinks.Add ( 'cbi_arfid=arf_id' ) ;
                Que_Recherche.JoinLinks.Add ( 'arf_artid=art_id' ) ;
                Que_Recherche.JoinLinks.Add ( 'cbi_tgfid=tgf_id' ) ;
                Que_Recherche.JoinLinks.Add ( 'cbi_couid=cou_id' ) ;
            END;

        1:          // Chrono

            BEGIN
                Que_Recherche.SQL.Clear;
                Que_Recherche.KeyLinks.Clear;
                Que_Recherche.JoinLinks.Clear;
                Que_Recherche.SQL.Add ( 'select ARF_ID, ART_ID, ART_NOM, ART_REFMRK, ARF_CHRONO, ARF_DIMENSION' ) ;
                Que_Recherche.SQL.Add ( 'from artarticle, artreference, k' ) ;
                Que_Recherche.SQL.Add ( 'where k_enabled=1' ) ;
                Que_Recherche.SQL.Add ( 'and (( ARF_CHRONO = :RECH ) OR (art_refmrk =:RECH)) and ARF_CATALOG=0' ) ;
                Que_Recherche.SQL.Add ( 'ORDER BY ARF_CHRONO' ) ;
                Que_Recherche.KeyRelation := 'ARTREFERENCE';
                Que_Recherche.KeyLinks.Add ( 'ARF_ID' ) ;
                Que_Recherche.JoinLinks.Add ( 'arf_id=k_id' ) ;
                Que_Recherche.JoinLinks.Add ( 'arf_artid=art_id' ) ;
            END;

        2:          // Nom & Ref

            BEGIN
                Que_Recherche.SQL.Clear;
                Que_Recherche.KeyLinks.Clear;
                Que_Recherche.JoinLinks.Clear;
                Que_Recherche.SQL.Add ( 'select ARF_ID, ART_ID, ART_NOM, ART_REFMRK, ARF_CHRONO, ARF_DIMENSION' ) ;
                Que_Recherche.SQL.Add ( 'from artarticle, artreference, k' ) ;
                Que_Recherche.SQL.Add ( 'where k_enabled=1 and ARF_CATALOG=0' ) ;
                Que_Recherche.SQL.Add ( 'and ((art_nom containing :RECH) or (art_refmrk containing :RECH))' ) ;
                Que_Recherche.SQL.Add ( 'ORDER BY ARF_CHRONO' ) ;
                Que_Recherche.KeyRelation := 'ARTARTICLE';
                Que_Recherche.KeyLinks.Add ( 'ART_ID' ) ;
                Que_Recherche.JoinLinks.Add ( 'art_id=k_id' ) ;
                Que_Recherche.JoinLinks.Add ( 'arf_artid=art_id' ) ;
            END;

        3:          //  *

            BEGIN
                Que_Recherche.SQL.Clear;
                Que_Recherche.KeyLinks.Clear;
                Que_Recherche.JoinLinks.Clear;
                Que_Recherche.SQL.Add ( 'select ARF_ID, ART_ID, ART_NOM, ART_REFMRK, ARF_CHRONO, ARF_DIMENSION' ) ;
                Que_Recherche.SQL.Add ( 'from artarticle, artreference, k' ) ;
                Que_Recherche.SQL.Add ( 'where k_enabled=1 and ARF_CATALOG=0 and ART_ID<>0' ) ;
                Que_Recherche.SQL.Add ( 'ORDER BY ARF_CHRONO' ) ;
                Que_Recherche.KeyRelation := 'ARTARTICLE';
                Que_Recherche.KeyLinks.Add ( 'ART_ID' ) ;
                Que_Recherche.JoinLinks.Add ( 'art_id=k_id' ) ;
                Que_Recherche.JoinLinks.Add ( 'arf_artid=art_id' ) ;
            END;

        4:          // IdART

            BEGIN
                Que_Recherche.SQL.Clear;
                Que_Recherche.KeyLinks.Clear;
                Que_Recherche.JoinLinks.Clear;
                Que_Recherche.SQL.Add ( 'select ARF_ID, ART_ID, ART_NOM, ART_REFMRK, ARF_CHRONO, ARF_DIMENSION' ) ;
                Que_Recherche.SQL.Add ( 'from artarticle, artreference, k' ) ;
                Que_Recherche.SQL.Add ( 'where k_enabled=1 and ARF_CATALOG=0' ) ;
                Que_Recherche.SQL.Add ( 'and (ARF_ARTID = :RECH )' ) ;
                Que_Recherche.SQL.Add ( 'ORDER BY ARF_CHRONO' ) ;
                Que_Recherche.KeyRelation := 'ARTREFERENCE';
                Que_Recherche.KeyLinks.Add ( 'ARF_ID' ) ;
                Que_Recherche.JoinLinks.Add ( 'arf_id=k_id' ) ;
                Que_Recherche.JoinLinks.Add ( 'arf_artid=art_id' ) ;
            END;
    END;            // du case

    IF cas <> 3 THEN
        Que_Recherche.ParamByName ( 'RECH' ) .asString := Rech;

    Que_Recherche.Open;
    Result := RecUnique ( Que_Recherche AS TDataset ) ;

END;

FUNCTION TDm_NegBL.CtrlChrono ( Chrono: STRING ) : Integer;
BEGIN
    Result := 0;
    Ibc_CtrlChrono.close;
    Ibc_CtrlChrono.paramByName ( 'Lechrono' ) .asstring := Chrono;
    Ibc_CtrlChrono.Open;
    IF NOT Ibc_CtrlChrono.eof THEN
        Result := Ibc_CtrlChrono.FieldByName ( 'ARF_ARTID' ) .asInteger;
    Ibc_CtrlChrono.close;
END;

FUNCTION TDm_NEGBL.OnComent: Boolean;
BEGIN
    Result := False;
    IF que_LineBL.Active THEN
        Result := que_LineBLBLL_LINETIP.asInteger > 0;
    IF Result THEN
    BEGIN
    END
    ELSE
    BEGIN
    END;

END;

PROCEDURE TDm_NEGBL.NewComent ( Tip: Integer ) ;
BEGIN
    NeoComent := Tip;
    Neoline;
END;

PROCEDURE TDm_NEGBL.Neoline;
VAR
    LN: Boolean;
BEGIN

    IF NeoComent = 0 THEN
        AligneArticle ( que_Recherche.fieldByName ( 'ART_ID' ) .asInteger ) ;

    InsSTotal := 0;
    GpsSTotal := 0;

     // va chercher le N° d'ordre dans de groupe de la ligne à saisir

    IF NOT que_LineBL.IsEmpty THEN
    BEGIN
          // pour l'instant toujours 0 ...
        InsSTotal := que_LineBLBLL_INSSTOTAL.asInteger;
        GpsSTotal := que_LineBLBLL_GPSSTOTAL.asInteger;
    END;

    IF LN THEN
        que_LineBL.Append
    ELSE
        que_LineBL.Insert;

END;

PROCEDURE TDm_NegBL.AligneArticle ( Artid: Integer ) ;
BEGIN
    IBC_Art.Close;
    IBC_Art.ParamByname ( 'ARTID' ) .asInteger := artid;
    IBC_Art.Open;
END;

PROCEDURE TDm_NegBL.Que_LineBLAfterCancel ( DataSet: TDataSet ) ;
BEGIN

    OnNewLine := False;
    NeoComent := 0;
    NeoSt := False;
    NoCalcLine := False;
    OnUpdateBL := False;
    NoControlDeline := False;

END;

PROCEDURE TDm_NegBL.Que_TetBLAfterCancel ( DataSet: TDataSet ) ;
BEGIN
    InternalUpdate := True;
    OnUpdateBL := True;

    TRY
        Screen.Cursor := crSQLWait;
        WITH Dm_Main DO
        BEGIN
            IBOCancelCache ( que_TetBL ) ;
            IBOCancelCache ( que_LineBL ) ;
            IBOCancelCache ( que_RelDest ) ;
        END;
    FINALLY

        Screen.Cursor := crDefault;

        OnNewRec := False;
        OnNewLine := False;
        NeoComent := 0;
        NeoSt := False;
        NoCalcLine := False;
        OnUpdateBL := False;
        LineModified := False;
        NoControlDeline := False;

        IF que_TetBLBLE_ID.asInteger <> 0 THEN
        BEGIN
        END;
        InternalUpdate := False;
    END;
END;

PROCEDURE TDm_NegBL.Que_LineBLCalcFields ( DataSet: TDataSet ) ;
VAR
    pteo: extended;
    idxTva: Integer;
BEGIN

    IF OnUpdateBL OR NoCalcLine THEN Exit;
    IF que_LineBLBLL_SSTOTAL.asInteger = 1 THEN Exit; // ST
    IF que_LineBLBLL_LINETIP.asInteger <> 0 THEN Exit; // Coment

    NoCalcLine := True;
    // sinon tourne en rond...

    IdxTva := TVAColumn ( que_LineBLBLL_TVA.asFloat ) ;

    IF que_LineBLBLL_QTE.asFloat = 0 THEN
    BEGIN
        que_LineBLREMISE.asFloat := 0;
        que_LineBLLMtHR.asFloat := 0;
        que_LineBLLMtTVA.asFloat := 0;
        que_LineBLLMtMRG.asFloat := 0;

        IF IdxTva > 0 THEN
        BEGIN
            que_LineBL.fieldByname ( 'TVA' + IntToStr ( idxTva ) ) .asFloat := 0;
            que_LineBL.fieldByname ( 'TTC' + IntToStr ( idxTva ) ) .asFloat := 0;
        END;

    END
    ELSE
    BEGIN

        que_LineBLLMtHR.asFloat :=
            que_LineBLBLL_PXBRUT.asFloat * que_LineBLBLL_QTE.asFloat;

        que_LineBLREMISE.asFloat := GetRemise (
            que_LineBLLMtHR.asFloat,
            que_LineBLBLL_PXNET.asFloat, 7 ) ;

        que_LineBLLMtTVA.asFloat := GetValTva (
            que_LineBLBLL_PXNET.asFloat,
            que_LineBLBLL_TVA.asFloat, 7 ) ;

        IF IdxTva > 0 THEN
        BEGIN
            que_LineBL.fieldByname ( 'TVA' + IntToStr ( idxTva ) ) .asFloat := que_LineBLLMtTVA.asFloat;
            que_LineBL.fieldByname ( 'TTC' + IntToStr ( idxTva ) ) .asFloat := que_LineBLBLL_PXNET.asFloat;
        END;

        IF que_LineBLARF_VIRTUEL.asInteger = 0 THEN
        BEGIN
            que_LineBLLMtMRG.asFloat := GetValMargeVT (
                que_LineBLBLL_PXNET.asFloat,
                ( que_LineBLPUMP.asFloat * que_LineBLBLL_QTE.asFloat ) ,
                que_LineBLLMtTVA.asFloat, 7 ) ;
        END
        ELSE
        BEGIN
            IF que_LineBLARF_SERVICE.asInteger = 1 THEN
            BEGIN
               // Service PxAchat = 0 donc j'enlève la tva
                que_LineBLLMtMRG.asFloat := que_LineBLBLL_PXNET.asFloat -
                    que_LineBLLMtTVA.asFloat
            END
            ELSE
            BEGIN
                IF que_LineBLARF_COEFT.asFloat <> 0 THEN
                BEGIN
                   // Calcul du cout d'achat thérique à l'aide du Coeft
                    Pteo := que_LineBLLMtHR.asFloat / que_LineBLARF_COEFT.asFloat;
                    que_LineBLLMtMRG.asFloat := GetValMargeVT (
                        que_LineBLBLL_PXNET.asFloat,
                        pteo,
                        que_LineBLLMtTVA.asFloat, 7 ) ;
                END
                ELSE
                BEGIN
                   // pas de coefT donc incapable de définir un pxAchat théorique comme service !
                    que_LineBLLMtMRG.asFloat := que_LineBLBLL_PXNET.asFloat -
                        que_LineBLLMtTVA.asFloat
                END
            END;
        END;

    END;
    NoCalcLine := False;

END;

PROCEDURE TDm_NegBL.Que_LineBLBLL_QTEValidate ( Sender: TField ) ;
VAR
    mtHR, rem, pnn: Extended;
BEGIN
    IF OnUpdateBL OR NoCalcLine THEN Exit;
    IF que_LineBLBLL_SSTOTAL.asInteger = 1 THEN Exit; // ST
    IF que_LineBLBLL_LINETIP.asInteger <> 0 THEN Exit; // Coment

    NoCalcLine := True;
    // sinon tourne en rond...

    IF que_LineBLBLL_QTE.asFloat <> 0 THEN
    BEGIN
        mthr := que_LineBLBLL_PXBRUT.asFloat * que_LineBLBLL_QTE.asFloat;
        rem := que_LineBLREMISE.asFloat;

        que_LineBLBLL_PXNET.asFloat := GetPxNego ( mthr, Rem, 7 ) ;
        pnn := que_LineBLBLL_PXNET.asFloat / que_LineBLBLL_QTE.asFloat;
        que_LineBLBLL_PXNN.asFloat := RoundRv ( pnn, 7 ) ;

    END
    ELSE
    BEGIN
        que_LineBLBLL_PXNN.asFloat := que_LineBLBLL_PXBRUT.asFloat;
        que_LineBLBLL_PXNET.asFloat := 0;
    END;

    NoCalcLine := False;
    Que_LineBLCalcFields ( que_LineBL ) ;

END;

PROCEDURE TDm_NegBL.Que_LineBLBLL_PXNETValidate ( Sender: TField ) ;
VAR
    pnn: Extended;
BEGIN
    IF OnUpdateBL OR NoCalcLine THEN Exit;
    IF que_LineBLBLL_SSTOTAL.asInteger = 1 THEN Exit; // ST
    IF que_LineBLBLL_LINETIP.asInteger <> 0 THEN Exit; // Coment

    NoCalcLine := True;
    // sinon tourne en rond...

    IF que_LineBLBLL_QTE.asFloat <> 0 THEN
    BEGIN
        pnn := que_LineBLBLL_PXNET.asFloat / que_LineBLBLL_QTE.asFloat;
        que_LineBLBLL_PXNN.asFloat := RoundRv ( pnn, 7 ) ;
    END;
    NoCalcLine := False;
    Que_LineBLCalcFields ( que_LineBL ) ;

END;

PROCEDURE TDm_NegBL.Que_LineBLAfterDelete ( DataSet: TDataSet ) ;
BEGIN
    IF NoControlDeline THEN Exit;

    Tim_Toto.Tag := 1;
    Tim_Toto.Enabled := True;

    OnNewLine := False;
    NeoComent := 0;
    NeoSt := False;
    NoCalcLine := False;
    OnUpdateBL := False;
END;

PROCEDURE TDm_NegBL.Que_ListeCalcFields ( DataSet: TDataSet ) ;
BEGIN
    que_ListeTOTHT.asfloat :=
        que_ListeTTC.asfloat - que_ListeTVA.asFloat;

    stdGinKoia.ChpDateRgltCODE ( que_ListeBLE_DATE.asDateTime, que_ListeCPA_CODE.asInteger, que_ListeDateRglt ) ;

END;

PROCEDURE TDm_NegBL.OuvreListe;
VAR
    i: Integer;
    ch: STRING;
BEGIN
END;

FUNCTION TDm_NegBL.GetMagKour: Integer;
BEGIN
    Result := 0;
    IF que_TetBL.Active THEN
        Result := que_TetBL.fieldByName ( 'BLE_MAGID' ) .asInteger;
END;

PROCEDURE TDm_NegBL.ArchiveBL ( IdBL: Integer ) ;
BEGIN
    que_Archive.close;
    que_archive.paramByName ( 'BLEID' ) .asInteger := IdBL;
    que_Archive.open;
    IF NOT que_Archive.IsEmpty THEN
    BEGIN
        que_Archive.Edit;
        que_Archive.fieldByName ( 'BLE_ARCHIVE' ) .asInteger := 1;
        que_Archive.Post;
        que_Archive.Close;
    END;
END;

PROCEDURE TDm_NegBL.Que_ArchiveAfterPost ( DataSet: TDataSet ) ;
BEGIN
    Dm_Main.IBOUpDateCache ( DataSet AS TIBOQuery ) ;
END;

PROCEDURE TDm_NegBL.Que_ArchiveUpdateRecord ( DataSet: TDataSet;
    UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction ) ;
BEGIN
    Dm_Main.IBOUpdateRecord ( ( DataSet AS TIBODataSet ) .KeyRelation,
        ( DataSet AS TIBODataSet ) , UpdateKind, UpdateAction ) ;
END;

FUNCTION TDm_NegBL.CTRLOuvreBL ( IdBL: Integer ) : Integer;
BEGIN
    Result := 0;
    IF NOT Que_Liste.Active THEN OuvreListe;
    IF NOT Que_Liste.IsEmpty THEN
    BEGIN
        IF Que_Liste.Locate ( 'BLE_ID', IdBL, [] ) THEN
            Result := IdBL
        ELSE
        BEGIN
            Que_Liste.First;
            Result := Que_Liste.FieldByName ( 'BLE_ID' ) .asInteger;
        END;
    END;
END;

PROCEDURE TDm_NegBL.DeleteLine;
BEGIN
    IF NCNFMess ( CdeConfDelLine, '' ) = MrYes THEN
    BEGIN
        IF que_LineBL.state IN [DsInsert] THEN
            que_LineBL.Cancel
        ELSE
        BEGIN
            // seules les relations dont le destinataire est le BL doivent
            // êtres supprimées. Si relation existe où l'origine est le BL
            // on ne peut être ici car dans ce cas on est en Non Modif !
            que_RelDest.First;
            WHILE NOT que_RelDest.eof DO
            BEGIN
                IF que_Reldest.FieldByName ( 'NGR_LINEIDD' ) .asInteger = que_LineBLBLL_ID.asInteger THEN
                    que_RelDest.Delete
                ELSE
                    que_RelDest.Next;
            END;

            Que_LineBL.Delete;
        END;
    END;
END;

PROCEDURE TDm_NegBL.DeleteBL;
VAR
    fok: Boolean;
BEGIN
    Fok := False;

    IF NCNFMess ( CdeConfDelBcde, '' ) = MrYes THEN
    BEGIN
        fok := True;
        IF NOT que_LineBL.IsEmpty AND ( que_LineBL.RecordCount > 2 ) THEN
            IF NCNFMess ( CdeConfConfDelBcde, '' ) <> MrYes THEN Fok := False;
    END;

    IF Fok THEN
    BEGIN
        // seules les relations dont le destinataire est le BL doivent
        // êtres supprimées. Si relation existe où l'origine est le BL
        // on ne peut être ici car dans ce cas on est en Non Modif !
        que_Linebl.DisableControls;
        TRY
            NoControlDeline := True;
            que_RelDest.First;
            WHILE NOT que_RelDest.eof DO
                que_RelDest.Delete;
            que_LineBl.First;
            WHILE NOT que_LineBL.Eof DO
                Que_LineBL.Delete;
        FINALLY
            NoControlDeline := False;
            que_LineBL.EnableControls;
        END;
        que_TetBl.Delete;
    END;
END;

PROCEDURE TDm_NegBL.Que_RelDestUpdateRecord ( DataSet: TDataSet;
    UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction ) ;
BEGIN
    Dm_Main.IBOUpdateRecord ( ( DataSet AS TIBODataSet ) .KeyRelation,
        ( DataSet AS TIBODataSet ) , UpdateKind, UpdateAction ) ;
END;

FUNCTION Tdm_NegBL.TransBLKour: STRING;
VAR
    i: Integer;
    LaFact: STRING;
    FlagPb: Boolean;
    t: TdateTime;
BEGIN
    TRY
        FlagPb := False;

        FOR i := 1 TO 5 DO
        BEGIN
            TheTTC[i] := 0;
            TxTva[i] := 0;
            TheTva[i] := 0;
        END;
        TheMarge := 0;
        TheTotal := 0;

        WITH MultiTem DO
        BEGIN
            Neo := False;
            MagId := 0;
            TypId := 0;
            Pro := 0;
            Detaxe := 0;
            Livreur := '';
            RemGlo := 0;
            CpaId := 0;
            MrgId := 0;
            Reglement := 0;
            CltId := 0;
            CltNom := '';
            CltPrenom := '';
        END;

        LaFact := '';
        IdxLTrans := 0;

        Str_BLToClot.Strings.Clear;

        TransCode := CodeDeTransfert ( 205 ) ;
        TransPino := False;

    {
    IF que_TetBLBLE_NMODIF.asInteger = 1 THEN Exit;
    IF que_TetBLBLE_CLOTURE.asInteger = 1 THEN Exit;
    IF que_TetBLBLE_ARCHIVE.asInteger = 1 THEN Exit;
     // ne devrait jamais se présenter car bouton non actif dans ces cas !
     }

    // IF NCNFMess ( DoBLTransFact, '' ) <> MrYes THEN Exit;

        TRY
            screen.Cursor := crSQLWait;

            que_BTO.close;
            que_BTO.paramByName ( 'BLEID' ) .asInteger := que_TetBLBLE_ID.asInteger;
            que_BTO.Open;

            que_BLO.close;
            que_BLO.paramByName ( 'BLEID' ) .asInteger := que_TetBLBLE_ID.asInteger;
            que_BLO.Open;

            que_CptClt.Open;
            que_TFTet.Open;
            que_TFLine.Open;
            que_TFRel.Open;

            IF NOT TransBLVersFact ( False, True, False, laFact ) THEN
            BEGIN
                CancelTransCache;
                screen.Cursor := crDefault;
            END
            ELSE
            BEGIN

                IF que_TetBLTOTTTC.asFloat <> 0 THEN
                BEGIN
                    WITH que_CptClt DO
                    BEGIN
                        Insert;

                        IF NOT Dm_Main.IBOMajPkKey ( que_CptClt, 'CTE_ID' ) THEN
                        BEGIN
                            IF que_CptClt.State IN [dsInsert] THEN que_CptClt.Cancel;
                            FlagPb := True;
                        END
                        ELSE
                        BEGIN

                            fieldByName ( 'CTE_CLTID' ) .asInteger := que_TFTet.FieldByName ( 'FCE_CLTID' ) .asInteger;
                            fieldByName ( 'CTE_MAGID' ) .asInteger := que_TFTet.fieldByName ( 'FCE_MAGID' ) .asInteger;
                            fieldByName ( 'CTE_DATE' ) .asDateTime := que_TFTet.fieldByName ( 'FCE_DATE' ) .asDateTime;

                            IF TheTotal > 0 THEN
                                fieldByName ( 'CTE_DEBIT' ) .asFloat := que_TetBLTOTTTC.asFloat
                            ELSE
                                fieldByName ( 'CTE_CREDIT' ) .asFloat := ABS ( que_TetBLTOTTTC.asFloat ) ;

                            fieldByName ( 'CTE_TKEID' ) .asInteger := 0;
                            fieldByName ( 'CTE_TYP' ) .asInteger := 0;
                            fieldByName ( 'CTE_ORIGINE' ) .asInteger := 1;
                            fieldByName ( 'CTE_FCEID' ) .asInteger := que_TFTet.FieldByName ( 'FCE_ID' ) .asInteger;

                            que_CptClt.fieldByName ( 'CTE_Libelle' ) .asString := FacLib + ' :' + que_TFTet.fieldByName ( 'FCE_NUMERO' ) .asString;

                            t := stdGinkoia.DateRgltID ( que_TFTet.FieldByName ( 'FCE_DATE' ) .asDateTime, que_TFTet.FieldByName ( 'FCE_CPAID' )
                                .asInteger ) ;
                            IF t = 0 THEN T := Date;
                            que_CptClt.FieldByName ( 'CTE_REGLER' ) .asDateTime := T;

                            que_CptClt.Post;
                        END;
                    END;
                END;

                IF NOT FlagPb THEN
                BEGIN
                    IF NOT que_BTO.IsEmpty THEN
                    BEGIN
                        que_BTO.Edit;

                        que_BTOBLE_NMODIF.asInteger := 1;
                        que_BTOBLE_CLOTURE.asInteger := 1;
                        IF Que_BTOBLE_PRO.IsNull THEN
                            Que_BTOBLE_PRO.asInteger := 0;

                        que_BTO.Post;
                    END;

                    IF MajTransCache THEN
                    BEGIN
                        OPENBL ( que_TetBLBLE_ID.asInteger ) ;
                        screen.Cursor := crDefault;
                    END;
                END
                ELSE
                BEGIN
                    CancelTransCache;
                END;

            END;

        FINALLY
            que_TFTet.Close;
            que_TFLine.Close;
            que_TFRel.Close;

            que_BTO.Close;
            Que_BLO.Close;
            Que_CptClt.Close;
            screen.Cursor := crDefault;
        END;
    FINALLY
        result := LaFact;
    END;
END;

FUNCTION TDm_NegBL.FinEnTetMulti: Boolean;
VAR
    i: Integer;
    t: TDateTime;
BEGIN

    Result := True;
    que_TfTet.Edit;
    FOR i := 1 TO 5 DO
    BEGIN
        que_TFTet.FieldByName ( 'FCE_TVAHT' + IntToStr ( i ) ) .asFloat := TheTTC[i];
        que_TFTet.FieldByName ( 'FCE_TVA' + IntToStr ( i ) ) .asFloat := TheTVA[i];
        que_TFTet.FieldByName ( 'FCE_TVATAUX' + IntToStr ( i ) ) .asFloat := TxTVa[i];
    END;
    que_TFTet.FieldByName ( 'FCE_MARGE' ) .asFloat := TheMarge;

    que_TfTet.Post;

    IF TheTotal <> 0 THEN
    BEGIN
        // Les comptes clients
        WITH que_CptClt DO
        BEGIN
            Insert;

            IF NOT Dm_Main.IBOMajPkKey ( que_CptClt, 'CTE_ID' ) THEN
            BEGIN
                Result := False;
                Exit;
            END;

            fieldByName ( 'CTE_CLTID' ) .asInteger := que_TFTet.FieldByName ( 'FCE_CLTID' ) .asInteger;
            fieldByName ( 'CTE_MAGID' ) .asInteger := que_TFTet.FieldByName ( 'FCE_MAGID' ) .asInteger;
            fieldByName ( 'CTE_DATE' ) .asDateTime := que_TFTet.FieldByName ( 'FCE_DATE' ) .asDateTime;

            IF TheTotal > 0 THEN
                fieldByName ( 'CTE_DEBIT' ) .asFloat := TheTotal
            ELSE
                fieldByName ( 'CTE_CREDIT' ) .asFloat := ABS ( TheTotal ) ;

            fieldByName ( 'CTE_TKEID' ) .asInteger := 0;
            fieldByName ( 'CTE_TYP' ) .asInteger := 0;
            fieldByName ( 'CTE_ORIGINE' ) .asInteger := 1;
            fieldByName ( 'CTE_FCEID' ) .asInteger := que_TFTet.FieldByName ( 'FCE_ID' ) .asInteger;

            que_CptClt.fieldByName ( 'CTE_Libelle' ) .asString := FacLib + ' :' + que_TFTet.fieldByName ( 'FCE_NUMERO' ) .asString;

            t := stdGinkoia.DateRgltID ( que_TFTet.FieldByName ( 'FCE_DATE' ) .asDateTime, que_TFTet.FieldByName ( 'FCE_CPAID' ) .asInteger ) ;
            IF t = 0 THEN T := Date;
            que_CptClt.FieldByName ( 'CTE_REGLER' ) .asDateTime := T;

            que_CptClt.Post;
        END;
    END;

END;

PROCEDURE Tdm_NegBL.TransBLMulti;
VAR
    CptTrans: Integer;
    TTcVide, FlagKour, First, FlagPb, OkTrans: Boolean;
    NoFact: STRING;
    i: Integer;
//    t: TDateTime;
BEGIN

    First := True;
    FlagKour := False;

    FOR i := 1 TO 5 DO
    BEGIN
        TheTTC[i] := 0;
        TxTva[i] := 0;
        TheTva[i] := 0;
    END;
    TheMarge := 0;
    TheTotal := 0;

    WITH MultiTem DO
    BEGIN
        Neo := False;
        MagId := 0;
        TypId := 0;
        Pro := 0;
        Detaxe := 0;
        Livreur := '';
        RemGlo := 0;
        CpaId := 0;
        MrgId := 0;
        Reglement := 0;
        CltId := 0;
        CltNom := '';
        CltPrenom := '';
    END;

    IdxLTrans := 0;
    Str_BLToClot.Strings.Clear;
    Str_Trans.Strings.Clear;
    TransCode := CodeDeTransfert ( 205 ) ;
    TransPino := False;

    TRY

        Screen.cursor := crSQLWait;
        FlagPb := False;
        que_CptClt.Open;
        que_TFTet.Open;
        que_TFLine.Open;
        que_TFRel.Open;

        // je prépare la liste de contrôle...
        MemD_Trans.First;
        WHILE NOT MemD_Trans.Eof DO
        BEGIN
            IF MemD_Trans.FieldByName ( 'KEYBL' ) .AsInteger <> 0 THEN
                Str_Trans.Strings.add ( MemD_Trans.FieldByName ( 'KEYBL' ) .AsString ) ;
            MemD_Trans.Next;
        END;

        IF Str_Trans.Strings.Count > 0 THEN
        BEGIN
            Splash_Trans.Gauge.MaxValue := Str_Trans.Strings.Count;
            Splash_Trans.Gauge.Progress := 0;
            Splash_Trans.Splash;
        END;

        WHILE Str_Trans.Strings.Count > 0 DO
        BEGIN
            MultiTem.Neo := True;

            FOR CptTrans := ( Str_Trans.Strings.Count - 1 ) DOWNTO 0 DO
            BEGIN
                IF MemD_Trans.Locate ( 'KeyBL', StrToInt ( str_Trans.Strings[cptTrans] ) , [] ) THEN
                BEGIN

                    NoFact := '';

                    que_BTO.close;
                    que_BTO.paramByName ( 'BLEID' ) .asInteger := Memd_Trans.FieldByName ( 'KeyBL' ) .asInteger;
                    que_BTO.Open;

                    IF ( que_BTO.fieldByName ( 'BLE_NMODIF' ) .asInteger = 1 ) OR
                        ( que_BTO.fieldByName ( 'BLE_CLOTURE' ) .asInteger = 1 ) OR
                        ( que_BTO.fieldByName ( 'BLE_ARCHIVE' ) .asInteger = 1 ) THEN
                    BEGIN
                        MemD_Trans.Edit;
                        MemD_Trans.FieldBYName ( 'MESS' ) .asString := BLTransNoPoss;
                        MemD_Trans.Post;

                        Splash_Trans.Gauge.Progress := Splash_Trans.Gauge.Progress + 1;
                        str_Trans.Strings.Delete ( cptTrans ) ;
                        Continue;

                    END;

                    TTCVide := True;
                    FOR i := 1 TO 5 DO
                        IF que_BTO.fieldByName ( 'BLE_TVAHT' + IntToStr ( i ) ) .asFloat <> 0 THEN TTCVide := False;
                    IF TTCVide THEN
                    BEGIN
                        MemD_Trans.Edit;
                        MemD_Trans.FieldBYName ( 'MESS' ) .asString := BLTransNoProd;
                        MemD_Trans.Post;

                        Splash_Trans.Gauge.Progress := Splash_Trans.Gauge.Progress + 1;
                        str_Trans.Strings.Delete ( cptTrans ) ;
                        Continue;
                    END;

                    IF MultiTem.Neo THEN
                    BEGIN
                        WITH MultiTem DO
                        BEGIN
                            IF NOT First THEN
                            BEGIN
                                FlagPb := NOT FinEntetMulti;
                                IF FlagPb THEN Break;
                            END;

                            First := False;

                            MagId := que_BTOBLE_MAGID.asInteger;
                            TypId := que_BTOBLE_TYPID.asInteger;
                            Pro := que_BTOBLE_PRO.asInteger;
                            Detaxe := que_BTOBLE_DETAXE.asInteger;
                            Livreur := que_BTOBLE_LIVREUR.asString;
                            RemGlo := que_BTOBLE_REMISE.asFloat;
                            CpaId := que_BTOBLE_CPAID.asInteger;
                            MrgId := que_BTOBLE_MRGID.asInteger;
                            Reglement := que_BTOBLE_REGLEMENT.asDateTime;
                            CltId := que_BTOBLE_CLTID.asInteger;
                            CltNom := que_BTOBLE_CLTNOM.asString;
                            CltPrenom := que_BTOBLE_CLTPRENOM.asString;
                        END;
                    END
                    ELSE
                    BEGIN
                        WITH MultiTem DO
                        BEGIN
                            OkTrans := true;
                            IF MagId <> que_BTOBLE_MAGID.asInteger THEN OkTrans := False;
                            IF TypId <> que_BTOBLE_TYPID.asInteger THEN OkTrans := False;
                            IF Pro <> que_BTOBLE_PRO.asInteger THEN OkTrans := False;
                            IF Detaxe <> que_BTOBLE_DETAXE.asInteger THEN OkTrans := False;
                            IF Livreur <> que_BTOBLE_LIVREUR.asString THEN OkTrans := False;
                            IF RemGlo <> que_BTOBLE_REMISE.asFloat THEN OkTrans := False;
                            IF CpaId <> que_BTOBLE_CPAID.asInteger THEN OkTrans := False;
                            IF MrgId <> que_BTOBLE_MRGID.asInteger THEN OkTrans := False;
                            IF Reglement <> que_BTOBLE_REGLEMENT.asDateTime THEN OkTrans := False;
                            IF CltId <> que_BTOBLE_CLTID.asInteger THEN OkTrans := False;
                            IF CltNom <> que_BTOBLE_CLTNOM.asString THEN OkTrans := False;
                            IF CltPrenom <> que_BTOBLE_CLTPRENOM.asString THEN OkTrans := False;
                            IF NOT OkTrans THEN Continue;
                        END
                    END;

                    str_Trans.strings.Delete ( cptTrans ) ;
                    Splash_Trans.Gauge.Progress := Splash_Trans.Gauge.Progress + 1;

                    que_BLO.close;
                    que_BLO.paramByName ( 'BLEID' ) .asInteger := Memd_Trans.FieldByName ( 'KeyBL' ) .asInteger;
                    que_BLO.Open;

                    IF que_BLO.IsEmpty THEN
                    BEGIN
                        MemD_Trans.Edit;
                        MemD_Trans.FieldBYName ( 'MESS' ) .asString := BLTransNoLine;
                        MemD_Trans.Post;
                        Continue;
                    END
                    ELSE
                    BEGIN
                        IF TransBLVersFact ( True, MultiTem.Neo, TransPino, NoFact ) THEN
                        BEGIN
                            MemD_Trans.Edit;
                            Dm_NegBL.MemD_Trans.FieldBYName ( 'MESS' ) .asString := BLTransEnFact;
                            Dm_NegBL.MemD_Trans.FieldBYName ( 'IDFACT' ) .asString := NoFact;
                            MemD_Trans.Post;

                            // la met dans la liste des BL à clôturer
                            Str_BlToClot.Strings.Add ( Que_BTOBLE_ID.AsString ) ;

                            IF Que_BTOBLE_ID.asInteger = Que_TETBLBLE_ID.asInteger THEN
                                FlagKour := True;
                        END
                        ELSE
                        BEGIN
                            FlagPB := True;
                            Break;
                        END;
                    END;
                    MultiTem.Neo := False;
                END;
            END;
            IF FlagPb THEN Break;
        END;

    FINALLY

        IF NOT FlagPB THEN
        BEGIN
            TRY

                IF Str_BlToClot.Strings.count > 0 THEN
                    IF NOT FinEntetMulti THEN
                        RAISE Exception.Create ( '' ) ;

                IF Str_BlToClot.strings.Count > 0 THEN
                BEGIN
                    // clôture des BL
                    FOR i := 0 TO Str_BlToClot.strings.Count - 1 DO
                    BEGIN
                        que_BTO.close;
                        que_BTO.paramByName ( 'BLEID' ) .asInteger := StrToInt ( Str_BlToClot.strings[i] ) ;
                        que_BTO.Open;
                        IF NOT que_BTO.IsEmpty THEN
                        BEGIN
                            IF que_BTOBLE_NMODIF.asInteger <> 1 THEN
                            BEGIN
                                que_BTO.Edit;
                                que_BTOBLE_NMODIF.asInteger := 1;
                                que_BTOBLE_CLOTURE.asInteger := 1;

                                IF Que_BTOBLE_PRO.IsNull THEN
                                    Que_BTOBLE_PRO.asInteger := 0;

                                que_BTO.Post;
                            END;
                        END;
                    END;

                    Splash_Trans.Stop;
                    Splash_Trans.Gauge.Progress := 0;

                    IF MajTransCache THEN
                    BEGIN
                        screen.Cursor := CrDefault;
                    END;

                END
                ELSE
                BEGIN
                    Splash_Trans.Stop;
                    Splash_Trans.Gauge.Progress := 0;
                    screen.Cursor := CrDefault;
                END;

                IF FlagKour THEN OpenBL ( Que_TetBLBLE_ID.AsInteger ) ;

            EXCEPT
                CancelTransCache;
                Splash_Trans.Stop;
                Splash_Trans.Gauge.Progress := 0;
                screen.Cursor := CrDefault;
            END;

        END
        ELSE
        BEGIN

            CancelTransCache;

            Splash_Trans.Stop;
            Splash_Trans.Gauge.Progress := 0;
            screen.Cursor := CrDefault;

        END;

        que_TFTet.Close;
        que_TFLine.Close;
        que_TFRel.Close;

        que_BTO.Close;
        Que_BLO.Close;
        Que_CptClt.Close;
        MemD_Trans.Close;

    END;

END;

FUNCTION Tdm_NegBL.CodeDeTransfert ( TIP: Integer ) : Integer;
BEGIN
    Result := 0;
    Ibc_CodTrans.close;
    Ibc_CodTrans.ParamByName ( 'KOD' ) .asInteger := TIP;
    Ibc_CodTrans.Open;
    IF NOT Ibc_CodTrans.Eof THEN
        Result := Ibc_CodTrans.FieldByName ( 'NPR_ID' ) .asInteger;
    Ibc_CodTrans.close;
END;

FUNCTION TDm_NegBL.TransBLVersFact ( Multi, NeoDoc, Pino: Boolean; VAR NOFact: STRING ) : Boolean;
VAR
    chLine: STRING;
    coment: boolean;
    k: Extended;
    i, itva: Integer;
    lenum,
        numLig: Integer;
BEGIN
      // ici seulement la boucle de travail !
      // les contrôles sont fait avant et les tables ouvertes et positionnées

    k := 100000000000;

    NoFact := '';
    Result := False;

    IF NeoDoc THEN
    BEGIN

        FOR i := 1 TO 5 DO
        BEGIN
            TheTTC[i] := 0;
            TxTva[i] := 0;
            TheTva[i] := 0;
        END;
        TheMarge := 0;
        TheTotal := 0;

        que_TFTet.Insert;

        IF NOT Dm_Main.IBOMajPkKey ( que_TFTet, que_TFTet.KeyLinks.IndexNames[0] ) THEN
            RAISE Exception.Create ( '' ) ;

        WITH que_TFTet DO
        BEGIN

            IbStProc_NumFac.Close;
            IbStProc_NumFac.Prepared := True;
            TRY
                IbStProc_NumFac.ExecProc;
                fieldBYName ( 'FCE_NUMERO' ) .asString := IbStProc_NumFac.Fields[0].asString;
            FINALLY
                IbStProc_Numfac.Close;
                IbStProc_Numfac.Unprepare;
            END;

            fieldBYName ( 'FCE_MAGID' ) .asInteger := Que_BTOBLE_MAGID.Asinteger;
            fieldBYName ( 'FCE_CLTID' ) .asInteger := Que_BTOBLE_CLTID.Asinteger;
            fieldBYName ( 'FCE_DATE' ) .asDateTime := Date;

            IF que_BTOBLE_TYPID.asInteger = TipBLRetro THEN
                fieldBYName ( 'FCE_TYPID' ) .asInteger := TipFacRetro
            ELSE
                fieldBYName ( 'FCE_TYPID' ) .asInteger := TipFacNormal;

            fieldBYName ( 'FCE_CLOTURE' ) .asInteger := 0;
            fieldBYName ( 'FCE_ARCHIVE' ) .asInteger := 0;
            fieldBYName ( 'FCE_USRID' ) .asInteger := Que_BTOBLE_USRID.Asinteger;
            fieldBYName ( 'FCE_CLTNOM' ) .asString := Que_BTOBLE_CLTNOM.asstring;
            fieldBYName ( 'FCE_CLTPRENOM' ) .asString := Que_BTOBLE_CLTPRENOM.AsString;
            fieldBYName ( 'FCE_CIVID' ) .asInteger := Que_BTOBLE_CIVID.Asinteger;
            fieldBYName ( 'FCE_VILID' ) .asInteger := Que_BTOBLE_VILID.Asinteger;
            fieldBYName ( 'FCE_ADRLIGNE' ) .asString := Que_BTOBLE_ADRLIGNE.asstring;
            fieldBYName ( 'FCE_MRGID' ) .asInteger := Que_BTOBLE_MRGID.Asinteger;
            fieldBYName ( 'FCE_NMODIF' ) .asInteger := 0;
            fieldBYName ( 'FCE_COMENT' ) .asString := Que_BTOBLE_COMENT.AsString;

            fieldBYName ( 'FCE_PRO' ) .asInteger := Que_BTOBLE_PRO.AsInteger;
            IF fieldBYName ( 'FCE_PRO' ) .IsNull THEN
                fieldBYName ( 'FCE_PRO' ) .asInteger := 0;
            fieldBYName ( 'FCE_DETAXE' ) .asInteger := Que_BTOBLE_DETAXE.Asinteger;
            fieldBYName ( 'FCE_PRENEUR' ) .asString := Que_BTOBLE_LIVREUR.asstring;
            fieldBYName ( 'FCE_REMISE' ) .asFloat := Que_BTOBLE_Remise.asFloat;

            IF Que_BTOBLE_CPAID.asInteger <> 0 THEN
                fieldBYName ( 'FCE_CPAID' ) .asInteger := Que_BTOBLE_CPAID.Asinteger
            ELSE
            BEGIN
                fieldBYName ( 'FCE_CPAID' ) .asInteger := 0;
                Ibc_CdtP.Close;
                Ibc_CdtP.ParamByName ( 'LECODE' ) .asInteger := 2; // a réception
                Ibc_CdtP.Open;
                IF Ibc_CdtP.Eof THEN
                    fieldBYName ( 'FCE_CPAID' ) .asInteger := Ibc_CdtP.fieldByName ( 'CPA_ID' ) .asInteger;

                Ibc_CdtP.Close;
            END;

            IF NOT Que_BTOBLE_Reglement.IsNull THEN
                fieldBYName ( 'FCE_REGLEMENT' ) .asDateTime := Que_BTOBLE_Reglement.AsDateTime;

            IF NOT Multi THEN
            BEGIN

                fieldBYName ( 'FCE_TVAHT1' ) .asFloat := Que_BTOBLE_TVAHT1.AsFloat;
                fieldBYName ( 'FCE_TVATAUX1' ) .asFloat := Que_BTOBLE_TVATAUX1.AsFloat;
                fieldBYName ( 'FCE_TVA1' ) .asFloat := Que_BTOBLE_TVA1.AsFloat;
                fieldBYName ( 'FCE_TVAHT2' ) .asFloat := Que_BTOBLE_TVAHT2.AsFloat;
                fieldBYName ( 'FCE_TVATAUX2' ) .asFloat := Que_BTOBLE_TVATAUX2.AsFloat;
                fieldBYName ( 'FCE_TVA2' ) .asFloat := Que_BTOBLE_TVA2.AsFloat;
                fieldBYName ( 'FCE_TVAHT3' ) .asFloat := Que_BTOBLE_TVAHT3.AsFloat;
                fieldBYName ( 'FCE_TVATAUX3' ) .asFloat := Que_BTOBLE_TVATAUX3.AsFloat;
                fieldBYName ( 'FCE_TVA3' ) .asFloat := Que_BTOBLE_TVA3.AsFloat;
                fieldBYName ( 'FCE_TVAHT4' ) .asFloat := Que_BTOBLE_TVAHT4.AsFloat;
                fieldBYName ( 'FCE_TVATAUX4' ) .asFloat := Que_BTOBLE_TVATAUX4.AsFloat;
                fieldBYName ( 'FCE_TVA4' ) .asFloat := Que_BTOBLE_TVA4.AsFloat;
                fieldBYName ( 'FCE_TVAHT5' ) .asFloat := Que_BTOBLE_TVAHT5.AsFloat;
                fieldBYName ( 'FCE_TVATAUX5' ) .asFloat := Que_BTOBLE_TVATAUX5.AsFloat;
                fieldBYName ( 'FCE_TVA5' ) .asFloat := Que_BTOBLE_TVA5.AsFloat;
                fieldBYName ( 'FCE_MARGE' ) .asFloat := Que_BTOBLE_Marge.AsFloat;

            END
            ELSE
            BEGIN

                fieldBYName ( 'FCE_TVAHT1' ) .asFloat := 0;
                fieldBYName ( 'FCE_TVATAUX1' ) .asFloat := 0;
                fieldBYName ( 'FCE_TVA1' ) .asFloat := 0;
                fieldBYName ( 'FCE_TVAHT2' ) .asFloat := 0;
                fieldBYName ( 'FCE_TVATAUX2' ) .asFloat := 0;
                fieldBYName ( 'FCE_TVA2' ) .asFloat := 0;
                fieldBYName ( 'FCE_TVAHT3' ) .asFloat := 0;
                fieldBYName ( 'FCE_TVATAUX3' ) .asFloat := 0;
                fieldBYName ( 'FCE_TVA3' ) .asFloat := 0;
                fieldBYName ( 'FCE_TVAHT4' ) .asFloat := 0;
                fieldBYName ( 'FCE_TVATAUX4' ) .asFloat := 0;
                fieldBYName ( 'FCE_TVA4' ) .asFloat := 0;
                fieldBYName ( 'FCE_TVAHT5' ) .asFloat := 0;
                fieldBYName ( 'FCE_TVATAUX5' ) .asFloat := 0;
                fieldBYName ( 'FCE_TVA5' ) .asFloat := 0;
                fieldBYName ( 'FCE_MARGE' ) .asFloat := 0;
            END;

            Post;
        END;
    END;

    IF Multi THEN
    BEGIN

        FOR i := 1 TO 5 DO
        BEGIN
            IF ( que_BTO.FieldByName ( 'BLE_TVAHT' + IntToStr ( i ) ) .asFloat <> 0 ) THEN
            BEGIN
                TheToTal := TheTotal + que_BTO.FieldByName ( 'BLE_TVAHT' + IntToStr ( i ) ) .asFloat;
                // la remise globale est déjà dans les totaux par indice

                // définit l'id tablo de la tva
                iTva := BTOTVA ( que_BTO.FieldByName ( 'BLE_TVATAUX' + IntToStr ( i ) ) .asFloat ) ;
                IF itva <> 0 THEN
                BEGIN
                    TheTTC[iTva] := TheTTC[iTva] + que_BTO.FieldByName ( 'BLE_TVAHT' + IntToStr ( i ) ) .asFloat;
                    TheTVA[iTva] := TheTVA[iTva] + que_BTO.FieldByName ( 'BLE_TVA' + IntToStr ( i ) ) .asFloat;
                END;
            END;
        END;

        TheMarge := TheMarge + Que_BTOBLE_Marge.AsFloat;

    END;

    IF NOT Pino THEN
    BEGIN
         // Ligne de commentaire en entête ...
        que_TFLine.Insert;

        WITH que_TFLine DO
        BEGIN

               // id de la ligne
            IF NOT Dm_Main.IBOMajPkKey ( que_TFLine, que_TFLine.KeyLinks.IndexNames[0] ) THEN
                RAISE Exception.Create ( '' ) ;

            IF Multi THEN
            BEGIN
                Inc ( IdxLTrans ) ;
                ChLine := Conv ( IdxLTrans * k, 15 ) ;
            END
            ELSE
                ChLine := '000   ';

            fieldBYName ( 'FCL_FCEID' ) .asInteger := que_TFTET.fieldByName ( 'FCE_ID' ) .asInteger;
            fieldBYName ( 'FCL_ARTID' ) .asInteger := 0;
            fieldBYName ( 'FCL_TGFID' ) .asInteger := 0;
            fieldBYName ( 'FCL_COUID' ) .asInteger := 0;
            fieldBYName ( 'FCL_NOM' ) .asString := chLine;
            fieldBYName ( 'FCL_USRID' ) .asInteger := 0;
            fieldBYName ( 'FCL_QTE' ) .asFloat := 0;
            fieldBYName ( 'FCL_PXBRUT' ) .asFloat := 0;
            fieldBYName ( 'FCL_PXNET' ) .asFloat := 0;
            fieldBYName ( 'FCL_PXNN' ) .asFloat := 0;
            fieldBYName ( 'FCL_SSTOTAL' ) .asInteger := 0;
            fieldBYName ( 'FCL_INSSTOTAL' ) .asInteger := 0;
            fieldBYName ( 'FCL_GPSSTOTAL' ) .asInteger := 0;
            fieldBYName ( 'FCL_TVA' ) .asFloat := 0;
            fieldBYName ( 'FCL_COMENT' ) .asString := NegComTransBL + que_BTO.FieldByName ( 'BLE_NUMERO' ) .asstring;
            fieldBYName ( 'FCL_BLLID' ) .asInteger := 0;
            fieldBYName ( 'FCL_TYPID' ) .asInteger := 0;
            fieldBYName ( 'FCL_LINETIP' ) .asInteger := 2; // Titre
            fieldBYName ( 'FCL_FROMBLL' ) .asInteger := 0;

            Post;
        END;
    END;

    NumLig := 0;

    lenum := 0;

    Que_BLO.First;
    MajTransCache;
    IF NOT Dm_Main.IbT_Maj.intransaction THEN
        Dm_Main.StartTransaction;
    WHILE NOT Que_BLO.eof DO
    BEGIN
        Coment := Que_BLOBLL_LINETIP.AsInteger <> 0;
        inc ( numLig ) ;
        if (lenum mod 100) = 0 then
          RZL.Caption := Inttostr ( lenum+1 ) + '/' + Inttostr ( Que_BLO.recordCount ) ;
        inc ( lenum ) ;

        IF NOT Coment THEN
        BEGIN

            IF numlig > 1000 THEN
            BEGIN
                MajTransCache;
                IF NOT Dm_Main.IbT_Maj.intransaction THEN
                    Dm_Main.StartTransaction;
                NumLig := 1;
            END;

            ChLine := Que_BLOBLL_Nom.AsString;

            que_TFLine.Insert;
            que_TFRel.Insert;
              // Relation SSI ligne d'articles....

            WITH que_TFLine DO
            BEGIN
                   // id de la ligne
                IF NOT Dm_Main.IBOMajPkKey ( que_TFLine, que_TFLine.KeyLinks.IndexNames[0] ) THEN
                    RAISE Exception.Create ( '' ) ;

                   // Id de la relation SSI pas comment
                IF NOT Dm_Main.IBOMajPkKey ( que_TFRel, que_TFRel.KeyLinks.IndexNames[0] ) THEN
                    RAISE Exception.Create ( '' ) ;

                que_TFLineFCL_FCEID.asInteger := que_TFTET.fieldByName ( 'FCE_ID' ) .asInteger;
                que_TFLineFCL_ARTID.asInteger := Que_BLOBLL_ARTID.AsInteger;
                que_TFLineFCL_TGFID.asInteger := Que_BLOBLL_TGFID.AsInteger;
                que_TFLineFCL_COUID.asInteger := Que_BLOBLL_COUID.AsInteger;
                que_TFLineFCL_NOM.asString := chLine;
                que_TFLineFCL_USRID.asInteger := Que_BLOBLL_USRID.AsInteger;
                que_TFLineFCL_QTE.asFloat := Que_BLOBLL_QTE.AsFloat;
                IF version = 1 THEN
                BEGIN
                    que_TFLineFCL_PXBRUT.asFloat := Que_BLOBLL_PXBRUT.AsFloat / 6.55957;
                    que_TFLineFCL_PXNET.asFloat := Que_BLOBLL_PXNET.AsFloat / 6.55957;
                    que_TFLineFCL_PXNN.asFloat := que_TFLineFCL_PXNET .asFloat / Que_BLOBLL_QTE.AsFloat;
                END
                ELSE IF version = 2 THEN
                BEGIN
                    que_TFLineFCL_PXBRUT.asFloat := Que_BLOBLL_PXBRUT.AsFloat;
                    que_TFLineFCL_PXNET.asFloat := Que_BLOBLL_PXNET.AsFloat * Que_BLOBLL_QTE.AsFloat;
                    que_TFLineFCL_PXNN.asFloat := Que_BLOBLL_PXNET.AsFloat;
                END
                ELSE
                BEGIN
                    que_TFLineFCL_PXBRUT.asFloat := Que_BLOBLL_PXBRUT.AsFloat;
                    que_TFLineFCL_PXNET.asFloat := Que_BLOBLL_PXNET.AsFloat;
                    que_TFLineFCL_PXNN.asFloat := Que_BLOBLL_PXNN.AsFloat;
                END;
                que_TFLineFCL_SSTOTAL.asInteger := Que_BLOBLL_SSTOTAL.AsInteger;
                que_TFLineFCL_INSSTOTAL.asInteger := Que_BLOBLL_INSSTOTAL.AsInteger;
                que_TFLineFCL_GPSSTOTAL.asInteger := Que_BLOBLL_GPSSTOTAL.AsInteger;
                que_TFLineFCL_TVA.asFloat := Que_BLOBLL_TVA.AsFloat;
                que_TFLineFCL_COMENT.asString := Que_BLOBLL_COMENT.AsString;
                que_TFLineFCL_BLLID.asInteger := 0;
                que_TFLineFCL_TYPID.asInteger := Que_BLOBLL_TYPID.asInteger;
                que_TFLineFCL_LINETIP.asInteger := Que_BLOBLL_LINETIP.AsInteger;
                IF que_TFLineFCL_LINETIP.asInteger <> 0 THEN
                    que_TFLineFCL_FROMBLL.asInteger := 0
                ELSE
                    que_TFLineFCL_FROMBLL.asInteger := 1;
                que_TFLineFCL_DATEBLL.asDateTime := Que_BTOBLE_DATE.AsDateTime;

                Post;
            END;
            // SSI pas comment
            WITH que_TFRel DO
            BEGIN
                que_TFRelNGR_NPRID.asInteger := TransCode;
                que_TFRelNGR_LINEIDO.asInteger := que_BLOBLL_ID.asInteger;
                que_TFRelNGR_LINEIDD.asInteger := que_TFLINEFCL_ID.asInteger;
                Post;
            END;
        END;
        Que_BLO.Next;
    END;
    RZL.Caption := Inttostr ( lenum ) + '/' + Inttostr ( Que_BLO.recordCount ) ;
    Result := True;
    NoFact := que_TFTet.fieldBYName ( 'FCE_NUMERO' ) .asString;
END;

PROCEDURE TDM_NegBL.CancelTransCache;
BEGIN
    WITH Dm_Main DO
    BEGIN
        IBOCancelCache ( que_TFTET ) ;
        IBOCancelCache ( que_TFLINE ) ;
        IBOCancelCache ( que_TFREL ) ;
        IBOCancelCache ( que_BTO ) ;
        IBOCancelCache ( que_CptClt ) ;
    END;
END;

FUNCTION TDM_NegBL.MajTransCache: Boolean;
BEGIN

    Result := False;

    WITH Dm_Main DO
    BEGIN
        TRY
            (*
            IF NOT ( IbT_Maj.inTransaction ) THEN
                StartTransaction;

            IF que_TFTET.UpdatesPending THEN
                IBOUpDateCache ( que_TFTET ) ;
            IF que_TFLINE.UpdatesPending THEN
                IBOUpDateCache ( que_TFLINE ) ;
            IF que_TFREL.UpdatesPending THEN
                IBOUpDateCache ( que_TFREL ) ;
            IF que_BTO.UpdatesPending THEN
                IBOUpDateCache ( que_BTO ) ;
            IF que_CptClt.UpdatesPending THEN
                IBOUpDateCache ( que_CptClt ) ;
            /*)

            Commit;
            que_TFTET.close ;
            que_TFLINE.close ;
            que_TFREL.close ;
            que_BTO.close ;
            que_TFTET.open ;
            que_TFLINE.open ;
            que_TFREL.open ;
            que_BTO.open;
            
            Result := True;

        EXCEPT
            Rollback;
            (*
            IBOCancelCache ( que_TFTET ) ;
            IBOCancelCache ( que_TFLINE ) ;
            IBOCancelCache ( que_TFREL ) ;
            IBOCancelCache ( que_BTO ) ;
            IBOCancelCache ( que_CptClt ) ;
            *)
        END;

        (*
        IBOCOmmitCache ( que_TFTET ) ;
        IBOCommitCache ( que_TFLINE ) ;
        IBOCommitCache ( que_TFREL ) ;
        IBOCommitCache ( que_BTO ) ;
        IBOCommitCache ( que_CptClt ) ;
        *)
    END;
    // que_CptClt.Close;

END;

FUNCTION Tdm_NegBL.TVAColumn ( Taux: Extended ) : Integer;
VAR
    i, itva: Integer;
BEGIN

    Result := 0;

    IF que_TetBL.State IN [dsInsert, dsEdit] THEN
    BEGIN
        FOR i := 1 TO 5 DO
            IF que_TetBL.fieldByname ( 'BLE_TVAHT' + IntToStr ( i ) ) .asfloat = 0 THEN
                que_TetBL.fieldByname ( 'BLE_TVATAUX' + IntToStr ( i ) ) .asfloat := 0
    END;

    FOR i := 1 TO 5 DO
        IF ( que_TetBL.fieldByname ( 'BLE_TVAHT' + IntToStr ( i ) ) .asfloat <> 0 ) AND
            ( que_TetBL.fieldByname ( 'BLE_TVATAUX' + IntToStr ( i ) ) .asfloat = Taux ) THEN
        BEGIN
            Result := i;
            Break;
        END;

    IF que_TetBL.State IN [dsInsert, dsEdit] THEN
    BEGIN
        IF Result = 0 THEN
        BEGIN
            FOR i := 1 TO 5 DO
                IF ( que_TetBL.fieldByname ( 'BLE_TVAHT' + IntToStr ( i ) ) .asfloat = 0 ) AND
                    ( que_TetBL.fieldByname ( 'BLE_TVATAUX' + IntToStr ( i ) ) .asfloat = 0 ) THEN
                BEGIN
                    que_TetBL.fieldByname ( 'BLE_TVATAUX' + IntToStr ( i ) ) .asfloat := Taux;
                    Result := i;
                    Break;
                END;
        END;
    END;

END;

PROCEDURE TDm_NegBL.Tim_TOTOTimer ( Sender: TObject ) ;
BEGIN
    Tim_Toto.Enabled := False;
    MajTotaux ( Tim_ToTo.Tag ) ;
    Tim_Toto.Tag := 0;
     // Timer car doit attendre que Devexpress ait mis à jour ses totaux ...
END;

PROCEDURE TDm_NegBL.Que_TetBLBLE_REMISEChange ( Sender: TField ) ;
BEGIN
    MajTotaux ( 1 ) ;
END;

PROCEDURE TDm_NegBL.Que_TetBLCalcFields ( DataSet: TDataSet ) ;
BEGIN
    IF OnUpdateBL OR NoCalcLine THEN Exit;
    que_TetBLTOTHT.asFloat := que_TetBLTOTTTC.asFloat - que_TetBLTOTTVA.asFloat;
END;

PROCEDURE TDm_NegBL.Que_TetBLBLE_PROChange ( Sender: TField ) ;
BEGIN
    IF que_LineBL.IsEmpty THEN
        MemPro := Que_TetBLBLE_PRO.asInteger;
     // ainsi ne déclenche pas la mise à jour finale si pas de lignes
END;

PROCEDURE TDm_NegBL.RechDoc ( Ledoc: STRING ) ;
BEGIN
    IF NOT Que_Liste.Locate ( 'BLE_NUMERO', LeDoc, [] ) THEN
    ELSE
        OpenBL ( Que_ListeBLE_ID.asInteger ) ;
END;

PROCEDURE TDm_NegBL.DragNode ( P, N: Extended ) ;
VAR
    i: Extended;
BEGIN
    que_LineBL.Edit;
    IF N = 0 THEN N := P + 100000000000;
    i := Trunc ( ( n + p ) / 2 ) ;
    Que_LineBLBLL_NOM.asString := Conv ( I, 15 ) ;
    que_LineBL.Post;
END;

PROCEDURE TDm_NegBL.Que_LineBLBeforeEdit ( DataSet: TDataSet ) ;
BEGIN
    StdGinKoia.SauveOnCache ( Dataset, ExDatas ) ;
END;

PROCEDURE TDm_NegBL.Que_LineBLBeforePost ( DataSet: TDataSet ) ;
BEGIN
    IF OnNewLine THEN Que_LineBLNEOLINE.AsInteger := 1;
END;

PROCEDURE TDm_NegBL.Tim_FocusTimer ( Sender: TObject ) ;
BEGIN
    Tim_Focus.Enabled := False;
END;

PROCEDURE TDm_NegBL.Que_TetBLCPA_CODEGetText ( Sender: TField;
    VAR Text: STRING; DisplayText: Boolean ) ;
BEGIN
    IF que_TetBL.FieldByName ( 'CPA_CODE' ) .asInteger = 1 THEN
        Text := FormatDateTime ( 'dd/mm/yyyy', que_TetBL.FieldByName ( 'BLE_REGLEMENT' ) .asDateTime )
    ELSE
        Text := que_TetBL.FieldByName ( 'CPA_NOM' ) .asString;

END;

PROCEDURE TDm_NegBL.Que_TetImpCalcFields ( DataSet: TDataSet ) ;
BEGIN
    que_TetImpTTCEURO.asFloat := RoundRv ( que_TetImpTOTTTC.asFloat, 2 ) ;
END;

PROCEDURE TDm_NegBL.Que_LineImpCalcFields ( DataSet: TDataSet ) ;
BEGIN
    que_LineImpLMtHR.asFloat :=
        que_LineImpBLL_PXBRUT.asFloat * que_LineImpBLL_QTE.asFloat;

    que_LineImpREMISE.asFloat := GetRemise (
        que_LineImpLMtHR.asFloat,
        que_LineImpBLL_PXNET.asFloat, 7 ) ;

END;

PROCEDURE TDm_NegBL.ParamImp;
BEGIN
END;

PROCEDURE TDm_NegBL.SetParamImp ( ch: STRING ) ;
BEGIN
END;

FUNCTION TDm_NegBL.ImprimeBLKour ( IdBL: Integer; First: Boolean ) : Boolean;
BEGIN
END;

PROCEDURE TDm_NegBL.Que_CptCltUpdateRecord ( DataSet: TDataSet;
    UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction ) ;
BEGIN
    Dm_Main.IBOUpdateRecord ( ( DataSet AS TIBODataSet ) .KeyRelation,
        ( DataSet AS TIBODataSet ) , UpdateKind, UpdateAction ) ;
END;

FUNCTION Tdm_NegBL.BTOTVA ( Taux: Extended ) : Integer;
VAR
    i: Integer;
BEGIN
    // retrouve l'indice de tva du transfert ou l'affecte
    Result := 0;

    FOR i := 1 TO 5 DO
        IF ( TheTTc[i] <> 0 ) AND ( TxTva[i] = Taux ) THEN
        BEGIN
            Result := i;
            Break;
        END;

    IF Result = 0 THEN
    BEGIN
        FOR i := 1 TO 5 DO
            IF ( TheTTc[i] = 0 ) AND ( TxTva[i] = 0 ) THEN
            BEGIN
                TxTva[i] := Taux;
                Result := i;
                Break;
            END;
    END;

END;

PROCEDURE TDm_NegBL.Que_TetBLCPA_NOMGetText ( Sender: TField;
    VAR Text: STRING; DisplayText: Boolean ) ;
BEGIN
    IF que_TetBL.FieldByName ( 'CPA_CODE' ) .asInteger = 1 THEN
        Text := FormatDateTime ( 'dd/mm/yyyy', que_TetBL.FieldByName ( 'BLE_REGLEMENT' ) .asDateTime )
    ELSE
        Text := que_TetBL.FieldByName ( 'CPA_NOM' ) .asString;
END;

END.

