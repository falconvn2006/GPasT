//$Log:
// 1    Utilitaires1.0         29/11/2018 10:19:33    Carole Anne VIFFRAY 
//$
//$NoKeywords$
//

{***************************************************************
 * *
 * Unit Name: GinKoiaStd
 * Purpose  :
 * Author   : Hervé Pulluard
 * History  :
 *
 Unité spécifique à Ginkoia permettant de récupérer le nom du "poste' via soit :
 a/ un param d'entrée dans le raccourçi
 b/ le fichier ini Section [NOMPOSTE] rubrique POSTE=
 c/ par défaut le nom de la machine windows

 Cette unité contient aussi les fonctions propres au "Convertor" puisque celui-ci
 passe par la base de données ...

 IMPORTANT : si le nom de poste n'est pas reconnu, l'application doit se terminer !!
 Pour que cette fonctionnalité soit active il faut bien entendu que la FRM_MAIN de
 l'application voit la préente unité et en appelle la PROCEDURE LoadIniFileFromDatabase
 dans son event "OnShow" dans la séquence "If not Init" juste avant le "tip of the day.

 Exemple :
    IF NOT Init THEN
    BEGIN
        windowState := wsMaximized;
        canMaximize := False;
        StdGinKoia.LoadIniFileFromDatabase;

        IF Tip_Main.ShowAtStartup THEN ExecTip;

    END;
 ****************************************************************}

UNIT GinKoiaStd;

INTERFACE

USES
  wwDialog,
  wwidlg,
  wwLookupDialogRv,
  Wwdbigrd,
  wwDBDateTimePickerRv,
  wwDBLookupComboRv,
  wwDBLookupComboDlgRv,
  wwDBComboBoxRv,
  wwDBComboDlgRv,
  LMDSpeedButton,
  LmdSBtn,
  RzDbBnEd,
  dxBar,
  Windows,
  Printers,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  IBODataset,
  TypInfo,
  lmdxpstyles,
  lmdGraph,
  Inifiles, // unité utilisée dans le code
  FileCtrl, // unité utilisée dans le code
  RzPanel, // unité utilisée dans le code
  EUGen, // unité utilisée dans le code
  dxPSdxDBGrLnk, // unité utilisée dans le code
  dxPSGlBl, // unité utilisée dans le code
  dxPSdxMVLnk, // unité utilisée dans le code
  dxPSdxTlLnk, // unité utilisée dans le code
  dxPSCore, // unité utilisée dans le code
  dxPrnDev, // unité utilisée dans le code
  dxDBGrid, // unité utilisée dans le code
  ConvertorRv, // unité utilisée dans le code
  LMDCustomSpeedButton, // unité utilisée dans le code
  Buttons, // unité utilisée dans le code
  LMDTimer,
  IB_Components,
  LMDCustomComponent,
  LMDIniCtrl,
  Db,
  dxmdaset,
  stdCtrls,
  LMDTxtPrinter,
  Wwdbgrid,
  ActionRv,
  vgStndrt,
  ALSTDlg,
  BmDelay,
  LMDSysInfo,
  LMDContainerComponent,
  lmdmsg,
  RxCalc,
  LMDOneInstance,
  lmdcont,
  IB_Session,
  IB_StoredProc,
  BtConvRv,
  dxDBMemoRv,
  wwDBEditRv,
  ExtCtrls,
  ListBitMap,
  RzDBButtonEditRv,
  rxStrHlder,
  Variants,
  cxDrawTextUtils,
  dxDBGridHP,
  IdBaseComponent,
  IdComponent,
  IdTCPConnection,
  IdTCPClient,
  IdExplicitTLSClientServerBase,
  IdMessageClient,
  IdSMTPBase,
  IdSMTP,
  uLog, UVersion;

// FC 02/03/09 : Type de doosier web (CleoNET, ATIPIC, etc...)
TYPE
  TWebDossier = (webInactif, webCleoNetMag, webCleoNetCentrale, webATIPIC, webGENERIQUE);

TYPE
  TTypeCarteCadeau = (tcc_Generique, tcc_SVS, tcc_Prosodie, tcc_Courrir, tcc_ISF, tcc_Debug);
  TFrequenceFacturation = (ff_None, ff_Mois, ff_Semaine, ff_Journee, ff_Carte, ff_CompteClient);

  TCarteCadeau = record
    TypeCC         : TTypeCarteCadeau;
    PseudoID       ,
    SSFamilleID    ,
    NbArtSSFam     ,
    ModEncID       ,
    ClientID       : Integer;
    Devise         ,
    MerchantName   ,
    MerchantNumber ,
    StoreNumber    ,
    TelSVI         : String;
    PxMin          ,
    PxMax          : Integer;
    Login          ,
    PassWord       ,
    RoutingID      : String;
    Frequence      : TFrequenceFacturation;
    TestMode       : Boolean;
    OrganismeCollecteur : integer;
    UrlWebService  : String;
    Certificat     : Boolean;
    AcompteWebClientID : Integer;
    TimeOutSolde, TimeOutOther : integer;
  private
    function GetNbArticleSSFamille(ssfid : integer) : Integer;
  public
    procedure LoadPAram;
  end;

  TParamSMTP = record
    From: string;
    Host: string;
    user: string;
    Pwd:  string;
    Port: integer;
  end;

  TArVariant = ARRAY OF Variant;

  //lab 08/07/08 information concernant un pdf par email
  TPDFEmail = RECORD
    pdfByEmail: Boolean; //option cochée ou non
    FichierNom: STRING; //nom du fichier
    EmailEmetteur: STRING; //
    EmailDestinataire: STRING;
    EmailObjet: STRING;
  END;

  // FC 02/03/09 : Ajouts pour pouvoir uniquement créer des PDF
  TPrintPDF = RECORD
    bActive: boolean;
    sNomFichier: STRING;
  END;

  //lab 21/12/09 BeCollector_ws Record pour recevoir les infos clients retournées par le web service getDatacard
  TDataCard = RECORD
    iReturnCode: Integer;
    sCardNumber: WideString;
    sStatus: WideString;
    iClientNumber: Integer;
    sStoreCode: WideString;
    sStoreName: WideString;
    sSolde: WideString;
    sLastName: WideString;
    sFirstName: WideString;
    sTitle: WideString;
    adresse: RECORD
      sAdresse1: WideString;
      sAdresse2: WideString;
      sAdresse3: WideString;
      sCode: WideString;
      sCity: WideString;
      sCountry: WideString;
      sIsValid: boolean;
    END;
    sPhone: WideString;
    sMobilePhone: WideString;
    bIsMobilePhoneValid: Boolean;
    sMail: WideString;
    bIsMailValid: Boolean;
    dtBirthDate: TDateTime;
  END;

  TStdGinKoia = CLASS(TDataModule)
    Que_Ini: TIBOQuery;
    Convertor: TConvertorRv;
    IbC_GetParamDossier: TIB_Cursor;
    Que_NbreMags: TIBOQuery;
    Que_PutParamDos: TIBOQuery;
    MemD_EtikPro: TdxMemData;
    MemD_EtikProArtid: TIntegerField;
    MemD_EtikProMagid: TIntegerField;
    MemD_EtikProTgfId: TIntegerField;
    MemD_EtikProCouId: TIntegerField;
    MemD_EtikProQte: TIntegerField;
    MemD_EtikProMrkId: TIntegerField;
    Str_CanConvert: TStrHolder;
    Que_Prefix: TIBOQuery;
    IniCtrl_Jeton: TLMDIniCtrl;
    Str_Jeton: TStrHolder;
    Que_Jetons: TIBOQuery;
    IbC_ParamBase: TIB_Cursor;
    Str_ModifTTrav: TStrHolder;
    Que_EtikPro: TIBOQuery;
    MemD_EtikProLinId: TIntegerField;
    MemD_EtikProRetik: TIntegerField;
    ConvertorEtik: TConvertorRv;
    IbC_CdtPmt: TIB_Cursor;
    Que_RechTable: TIBOQuery;
    Que_ExeCom: TIBOQuery;
    Que_ExeComEXE_NOM: TStringField;
    Que_ExeComEXE_DEBUT: TDateTimeField;
    Que_ExeComEXE_FIN: TDateTimeField;
    Que_ExeComEXE_ANNEE: TIntegerField;
    Que_ExeComEXE_ID: TIntegerField;
    LK_ExeCom: TwwLookupDialogRV;
    PrtT_Memo: TLMDTxtPrinter;
    Grd_Close: TGroupDataRv;
    IbC_CtrlId: TIB_Cursor;
    IbQ_Univers: TIBOQuery;
    IbQ_UniversUNI_NOM: TStringField;
    IbQ_UniversUNI_NIVEAU: TIntegerField;
    IbQ_UniversUNI_ORIGINE: TIntegerField;
    IbQ_UniversUNI_ID: TIntegerField;
    IbQ_UniversUNI_IDREF: TIntegerField;
    Que_TVA: TIBOQuery;
    Que_TVATVA_CODE: TStringField;
    Que_TVATVA_TAUX: TIBOFloatField;
    Que_TVATVA_ID: TIntegerField;
    Calc_Main: TRxCalculator;
    SysInf_Main: TLMDSysInfo;
    Delay_Main: TBmDelay;
    Tip_Main: TALSTipDlg;
    PropSto_Const: TPropStorage;
    AppIni_Main: TAppIniFile;
    IniCtrl: TLMDIniCtrl;
    CurSto_Main: TCurrencyStorage;
    TimeSto_Main: TDateTimeStorage;
    MemD_EtikClt: TdxMemData;
    MemD_EtikCltclt_id: TIntegerField;
    Que_Adresse: TIBOQuery;
    Que_AdresseADR_ID: TIntegerField;
    Que_AdresseADR_LIGNE: TMemoField;
    IbC_CtrlAdr: TIB_Cursor;
    Que_FouDetail: TIBOQuery;
    Que_FouDetailFOD_ID: TIntegerField;
    Que_FouDetailFOD_COMENT: TMemoField;
    IbC_CtrlFOD: TIB_Cursor;
    Que_Fourn: TIBOQuery;
    Que_FournFOU_ID: TIntegerField;
    Que_FournFOU_CDTCDE: TStringField;
    IbC_CtrlFOU: TIB_Cursor;
    Que_Contact: TIBOQuery;
    IbC_CtrlCon: TIB_Cursor;
    Que_ContactCON_ID: TIntegerField;
    Que_ContactCON_COMENT: TMemoField;
    Que_Ville: TIBOQuery;
    Que_VilleVIL_CP: TStringField;
    Que_VilleVIL_NOM: TStringField;
    Que_VillePAY_NOM: TStringField;
    Que_VilleVIL_ID: TIntegerField;
    Que_VilleVIL_PAYID: TIntegerField;
    Que_Pays: TIBOQuery;
    Que_PaysPAY_NOM: TStringField;
    Que_PaysPAY_ID: TIntegerField;
    LK_Ville: TwwLookupDialogRV;
    LK_Pays: TwwLookupDialogRV;
    Ds_Ville: TDataSource;
    Que_Modereg: TIBOQuery;
    Que_ModeregMRG_LIB: TStringField;
    Que_ModeregMRG_ID: TIntegerField;
    LK_MODEREG: TwwLookupDialogRV;
    IbStProc_Marques: TIB_StoredProc;
    IbC_CoulUnik: TIB_Cursor;
    IbC_TailleUnik: TIB_Cursor;
    Que_AffSec: TIBOQuery;
    Que_AffSecPRM_ID: TIntegerField;
    Que_AffSecPRM_CODE: TIntegerField;
    Que_AffSecPRM_INTEGER: TIntegerField;
    Que_AffSecPRM_FLOAT: TIBOFloatField;
    Que_AffSecPRM_STRING: TStringField;
    Que_AffSecPRM_TYPE: TIntegerField;
    Que_AffSecPRM_MAGID: TIntegerField;
    Que_AffSecPRM_INFO: TStringField;
    Que_AffSecPRM_POS: TIntegerField;
    Que_CtrlTypDev: TIBOQuery;
    Que_CtrlTypDevNPR_ID: TIntegerField;
    Que_CtrlTypDevNPR_TYPE: TIntegerField;
    Que_CtrlTypDevNPR_LIBELLE: TStringField;
    Que_CtrlTypDevNPR_CODE: TIntegerField;
    Tim_Jeton: TTimer;
    Str_Exclude: TStrHolder;
    IbC_Next: TIB_Cursor;
    IbC_Prior: TIB_Cursor;
    Ibc_CtrlChrono: TIBOQuery;
    Ibc_CtrlChronoART_ID: TIntegerField;
    RVIML_Small: TlistImageRV;
    Que_Modules: TIBOQuery;
    Que_ModulesMODULEEXCLU: TStringField;
    Que_CtrlK0: TIBOQuery;
    Str_CodesBtn: TStrHolder;
    Que_TOLOC: TIBOQuery;
    Que_TOLOCPRM_ID: TIntegerField;
    Que_TOLOCPRM_CODE: TIntegerField;
    Que_TOLOCPRM_INTEGER: TIntegerField;
    Que_TOLOCPRM_FLOAT: TIBOFloatField;
    Que_TOLOCPRM_STRING: TStringField;
    Que_TOLOCPRM_TYPE: TIntegerField;
    Que_TOLOCPRM_MAGID: TIntegerField;
    Que_TOLOCPRM_INFO: TStringField;
    Que_TOLOCPRM_POS: TIntegerField;
    IbC_PxNonTraite: TIB_Cursor;
    Que_RefGestionNk: TIBOQuery;
    Que_RefGestionNkJOU_ID: TIntegerField;
    Que_Gebuco: TIBOQuery;
    Que_GebucoPRM_INTEGER: TIntegerField;
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
    IbStProc_OC: TIB_StoredProc;
    MemD_EtikProdate: TDateTimeField;
    MemD_EtikProtocid: TIntegerField;
    MemD_EtikProordre: TIntegerField;
    MemD_EtikDiv: TdxMemData;
    MemD_EtikDivid: TIntegerField;
    MemD_EtikDivchamp: TStringField;
    MemD_EtikDivid1: TIntegerField;
    Tim_Focus: TTimer;
    IbC_CtrlSage: TIB_Cursor;
    IbC_CtrlCB: TIB_Cursor;
    Que_CtrlRtf: TIBOQuery;
    Que_CtrlRtfPRM_ID: TIntegerField;
    Que_CtrlRtfPRM_CODE: TIntegerField;
    Que_CtrlRtfPRM_INTEGER: TIntegerField;
    Que_CtrlRtfPRM_FLOAT: TIBOFloatField;
    Que_CtrlRtfPRM_STRING: TStringField;
    Que_CtrlRtfPRM_TYPE: TIntegerField;
    Que_CtrlRtfPRM_MAGID: TIntegerField;
    Que_CtrlRtfPRM_INFO: TStringField;
    Que_CtrlRtfPRM_POS: TIntegerField;
    IbC_IdTvtWeb: TIB_Cursor;
    Que_IsParaWeb: TIBOQuery;
    Que_IsParaWebPRM_ID: TIntegerField;
    Que_IsParaWebPRM_MAGID: TIntegerField;
    Que_IsParaWebPRM_INTEGER: TIntegerField;
    IbC_CurUserID: TIB_Cursor;
    IbC_Ref_dynaSp2000: TIB_Cursor;
    IbC_CATMAN: TIB_Cursor;
    IbC_ARTSP2000: TIB_Cursor;
    IbC_FidNatTwin: TIB_Cursor;
    Que_MajGenImport: TIBOQuery;
    Que_MajGenImportIMP_ID: TIntegerField;
    Que_MajGenImportIMP_KTBID: TIntegerField;
    Que_MajGenImportIMP_GINKOIA: TIntegerField;
    Que_MajGenImportIMP_REF: TIntegerField;
    Que_MajGenImportIMP_NUM: TIntegerField;
    Que_MajGenImportIMP_REFSTR: TStringField;
    Que_GetParam: TIBOQuery;
    RVIML_Large: TlistImageRV;
    Que_GetActiveJeton: TIBOQuery;
    IbStProc_LA_BECOL_MAJCLIENT: TIB_StoredProc;
    Que_GenParamUpd: TIBOQuery;
    Que_GenParamUpdPRM_ID: TIntegerField;
    Que_GenParamUpdPRM_CODE: TIntegerField;
    Que_GenParamUpdPRM_INTEGER: TIntegerField;
    Que_GenParamUpdPRM_FLOAT: TIBOFloatField;
    Que_GenParamUpdPRM_STRING: TStringField;
    Que_GenParamUpdPRM_TYPE: TIntegerField;
    Que_GenParamUpdPRM_MAGID: TIntegerField;
    Que_GenParamUpdPRM_INFO: TStringField;
    Que_GenParamUpdPRM_POS: TIntegerField;
    Que_RefDyn_Param: TIBOQuery;
    Que_RefDyn_ParamRED_ID: TIntegerField;
    Que_RefDyn_ParamRED_NOM: TStringField;
    Que_RefDyn_ParamRED_URL: TMemoField;
    Que_RefDyn_ParamRED_NUM: TIntegerField;
    Que_RefDyn_ParamRED_TYPE: TIntegerField;
    Que_RefDyn_ParamRED_URL2: TMemoField;
    MemD_RefDyn_LstBases: TdxMemData;
    MemD_RefDyn_LstBasesRED_NOM: TStringField;
    MemD_RefDyn_LstBasesRED_ID: TIntegerField;
    MemD_RefDyn_LstBasesRED_URL: TStringField;
    MemD_RefDyn_LstBasesRED_NUM: TIntegerField;
    MemD_RefDyn_LstBasesRED_TYPE: TIntegerField;
    MemD_RefDyn_LstBasesRED_URL2: TStringField;
    LK_RefDyn_LstBases: TwwLookupDialogRV;
    MemD_RefDyn_LstArticles: TdxMemData;
    MemD_RefDyn_LstArticlesART_NOM: TStringField;
    MemD_RefDyn_LstArticlesART_REFMRK: TStringField;
    MemD_RefDyn_LstArticlesGRE_NOM: TStringField;
    MemD_RefDyn_LstArticlesNOMENCLATURE: TStringField;
    MemD_RefDyn_LstArticlesCOL_NOM: TStringField;
    MemD_RefDyn_LstArticlesARF_ARCHIVER: TIntegerField;
    MemD_RefDyn_LstArticlesART_ID: TIntegerField;
    LK_RefDyn_LstArticles: TwwLookupDialogRV;
    Que_CtrlRefMrk: TIBOQuery;
    Que_TmpNoEvent: TIBOQuery;
    Que_ArchiveStagiaireUCPA: TIBOQuery;
    Que_CtrlBonLocEncours: TIBOQuery;
    Que_CtrlBonLocEncoursNBBONLOC: TIntegerField;
    Ibc_CtrlChronoARF_ID: TIntegerField;
    Ibc_CtrlChronoART_NOM: TStringField;
    Ibc_CtrlChronoART_REFMRK: TStringField;
    Ibc_CtrlChronoARF_CHRONO: TStringField;
    Ibc_CtrlChronoARF_DIMENSION: TIntegerField;
    Ibc_CtrlChronoART_MRKID: TIntegerField;
    Ibc_CtrlChronoARF_CATALOG: TIntegerField;
    Ibc_CtrlChronoARF_VIRTUEL: TIntegerField;
    Ibc_CtrlChronoARF_ARCHIVER: TIntegerField;
    Ibc_CtrlChronoART_GREID: TIntegerField;
    Ibc_CtrlChronoART_SSFID: TIntegerField;
    Ibc_CtrlChronoRECH_PARTIELLE: TIntegerField;
    MemD_EtikProid3: TIntegerField;
    Que_AdresseSOCIETE: TIBOQuery;
    Que_AdresseSOCIETEADR_VILID: TIntegerField;
    Que_AdresseSOCIETEADR_LIGNE: TMemoField;
    Que_AdresseSOCIETESOC_CAPITAL: TStringField;
    Que_AdresseSOCIETESOC_ADRID: TIntegerField;
    Que_AdresseSOCIETESOC_NOM: TStringField;
    Que_AdresseSOCIETESOC_ID: TIntegerField;

    PROCEDURE Que_IniAfterPost(DataSet: TDataSet);
    PROCEDURE Que_IniBeforeDelete(DataSet: TDataSet);
    PROCEDURE Que_IniBeforeEdit(DataSet: TDataSet);
    PROCEDURE Que_IniNewRecord(DataSet: TDataSet);
    PROCEDURE Que_IniUpdateRecord(DataSet: TDataSet; UpdateKind: TUpdateKind; VAR UpdateAction:
      TUpdateAction);
    PROCEDURE Que_PutParamDosAfterPost(DataSet: TDataSet);
    PROCEDURE Que_PutParamDosBeforeDelete(DataSet: TDataSet);
    PROCEDURE Que_PutParamDosBeforeEdit(DataSet: TDataSet);
    PROCEDURE Que_PutParamDosNewRecord(DataSet: TDataSet);
    PROCEDURE Que_PutParamDosUpdateRecord(DataSet: TDataSet;
      UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
    PROCEDURE Tim_JetonTimer(Sender: TObject);
    PROCEDURE Que_JetonsAfterPost(DataSet: TDataSet);
    PROCEDURE Que_JetonsNewRecord(DataSet: TDataSet);
    PROCEDURE Que_JetonsUpdateRecord(DataSet: TDataSet;
      UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
    PROCEDURE DataModuleCreate(Sender: TObject);
    PROCEDURE DataModuleDestroy(Sender: TObject);
    PROCEDURE Que_ExeComAfterPost(DataSet: TDataSet);
    PROCEDURE Que_ExeComBeforeDelete(DataSet: TDataSet);
    PROCEDURE Que_ExeComBeforeEdit(DataSet: TDataSet);
    PROCEDURE Que_ExeComNewRecord(DataSet: TDataSet);
    PROCEDURE Que_ExeComUpdateRecord(DataSet: TDataSet;
      UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
    PROCEDURE Que_ExeComEXE_DEBUTValidate(Sender: TField);
    PROCEDURE GeneBeforeDelete(DataSet: TDataSet);
    PROCEDURE GeneBeforeEdit(DataSet: TDataSet);
    PROCEDURE GeneNewRecord(DataSet: TDataSet);
    PROCEDURE GeneUpdateRecord(DataSet: TDataSet; UpdateKind: TUpdateKind;
      VAR UpdateAction: TUpdateAction);
    PROCEDURE LK_VilleInitDialog(Dialog: TwwLookupDlg);
    PROCEDURE Que_ModeregBeforePost(DataSet: TDataSet);
    PROCEDURE Tim_FocusTimer(Sender: TObject);
  
    procedure Que_ArchiveStagiaireUCPAAfterPost(DataSet: TDataSet);
    procedure Que_ArchiveStagiaireUCPABeforeDelete(DataSet: TDataSet);
    procedure Que_ArchiveStagiaireUCPABeforeEdit(DataSet: TDataSet);
    procedure Que_ArchiveStagiaireUCPANewRecord(DataSet: TDataSet);
    procedure Que_ArchiveStagiaireUCPAUpdateRecord(DataSet: TDataSet; UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
  PRIVATE
    // LeBidon: Integer;
    LeCp, LaVille: STRING; // Pour la selection Pays + Villes
    VillePrem: Boolean; // problème d'affichage du dialogue ville

    FVisuMagSoc: Boolean;
    FFlagSavePrinterSetup_RapRV: Boolean; // CBR - Modif 10/04/2013 - CR 2000

    IsAutoWidth, NeedRestit: Boolean;
    FDefTvaTaux: STRING;
    FaffSec, FNkLevel, FdefTva: Integer;
    FisAlgol: Boolean;

    FDefCollec, FDefCollecRecept, FDefMajTarRecep: Boolean; //lab 862 gestions collections
    FIdDefCollec, FIdDefCollecRecept: Integer; //lab 862 gestions collections
    FSocieteName, FMagasinName, FPosteName,
      // FPrefServeur,
    FRepImg, FNonRefRepImg: STRING;
    Funi, Forig, FMM, FSocieteID, FMagasinID, FPosteID, FTvtID, FMtaid: Integer;
    FDevModImp, FEtik, FLaserPreview, FPrintReverse, FEtik_Format, FDerImp: Integer;
    FModeZPL, FDensite, FVitesse, FWideBar, Finterpretation_line : integer;
    FMagEnseigne, FPrefix, FnomTvt, FImp_Laser, FImp_Eltron: STRING;
    //lab pour Fidelite Twinner
    FMagCodeAdherent: STRING;

    FEtik_Format_clt: integer;
    FEtik_Format_Loc: integer;

    // Push - Pull Cogisoft
    FPushURL, FPushUSER, FPushPASS: STRING;
    FPullURL, FPullUSER, FPullPASS: STRING;
    FPushPROV, FPullPROV: TStrings;
    FgestionHT, FglossaireHT, FDigital: Boolean;
    FHistoDur: Integer;

    Fnl, Fcl: Boolean;
    FCalc: Double;

    FNM, FNP, FPatBase, FIniApp, FPatLect, FPatApp, FPatHelp, FPatEAI, FPatEAIexe, FPatRapport: STRING;
    FPatErreurXML: string;    // repertoire de sauvegarde des fichiers XML reçu en erreur
    FPseudoTO, FTOTWINNER, FTOWEB: Integer;
    FTOWEBACTIVE: BOOLEAN;
    FDEBSAISLOC: STRING;

    LesBitMap: TStringList;
    fBlokDate: Integer;
    fLaFormActive: TCustomForm;

    FMaxiDBGDev: Integer;
    FIsXP: Boolean;
    FISWEBParamOK: Boolean;
    FIdCurUser: Integer;

    // Variable local pour dossier SPORT 2000
    Fref_dyna_sp2000, Fcatman: Boolean;

    //lab 15/07/08 variable locale pour Twinner Fidèlité nationale
    FFidNatTwinner: Boolean;
    FFidNatUrl: STRING;
    FwebTypeDossier: TWebDossier;
    FBaseID: Integer;
    FBasCodeTiers: string;
    FBasGuid: String;
    FMonnaieActuelle: string;

    bModuleIntersport : Boolean ;
    bModuleCourir     : Boolean ;
    bModuleGoSport    : Boolean ;
    bModuleSport2000  : Boolean ;
    bModuleCrossCanal : Boolean ;
    FSocieteADR: boolean;
    FMagasinAdr: STRING;
    FSocieteCapital: String;
    FMagasinAdrVILLE: STRING;
    FMagasinAdrCP: STRING;
    FMagasinAdrPAYS: STRING;
    FMdp: String;
    FLogin: String;
    PROCEDURE SetFnl(Value: Boolean);
    PROCEDURE SetFcl(Value: Boolean);
    PROCEDURE ConstDoInit;

    PROCEDURE SetDevModimp(Value: Integer);
    PROCEDURE VilleBeforePaint(sender: Tobject);

    FUNCTION MyComputerName: STRING;

    PROCEDURE WriteJeton;
    FUNCTION GetActiveJetons: integer;
    procedure SetMonnaieActuelle(const Value: string);
    function GetMonnaieActuelle: string;


  PUBLIC
    StopErrorMess: Boolean;
    PanFocus: TWinControl;
    Sage: STRING;
    SageNbre: Integer;

    // FC 04/2010 : Gestion de l'ecart toléré pour les bons de rapprochment
    fRapprochementEcartTolere: Extended;

    sInfoClientMultiCopie : string; // Variable permettant de passer l'information client dans le cas de réédition de facture et facturette en nbre copie
    iNbCopies             : Integer;

    //lab 08/07/08 création d'un enregistrement TPDFEmail
    aPdfEmail: TPDFEmail;

    // FC 02/03/09 : Ajouts pour pouvoir uniquement créer des PDF
    PrintToPdf: TPrintPDF;

    // Gestion de id ligne type doc
    IdOffset, IdOrdre, TemoinIdP: Extended;
    //**************************************
    ExChange: STRING;
    ExChangeCode: integer;

    RefreshListArt, RefreshListCatalog: Boolean;
    FichartArtENKour: Integer;
    // refresh de la liste catalog si référencement

    MailingIDenCours: Integer; //Bruno 10/10/2002

    DateSurJourneaux: Boolean;
    ClotureEnCaisse: Integer;
    FidTvtWeb: Integer;

    EtikGEM_ID: ARRAY[0..16] OF Integer; //Dernier modèle d'étiquette utilisé par code application
    EtikTCA_ID: integer;
    EtikAppli: integer;

    Negfac_dm: integer;

    sClientCBI_CB: String;

    PROPERTY sMonnaieActuelle : string read GetMonnaieActuelle write SetMonnaieActuelle;

    PROCEDURE SetCurrentUserId;

    procedure Sablier(bActif: Boolean); // Ajout FC : Gestion du sablier plus facile

    PROCEDURE CtrlIsParamWebOK;
    FUNCTION GetISXP: Boolean;
    FUNCTION UserVisuMags: Boolean;
    FUNCTION UserVisuStkMM: Boolean;
    FUNCTION UserCanModify(Droit: STRING): Boolean;
    FUNCTION UserWebVente: Boolean;
    PROCEDURE CtrlIfIsSuper;

    FUNCTION TexteFiltre(TS: TStrings; Chaine: STRING = ''): STRING;
    PROCEDURE LoadIniFileFromDatabase;

    FUNCTION GetStringParamValue(ParamName: STRING): STRING;
    FUNCTION GetFloatParamValue(ParamName: STRING): double;
    PROCEDURE PutStringParamValue(ParamName, Val: STRING);
    PROCEDURE PutFloatParamValue(ParamName: STRING; Val: Extended);

    PROCEDURE MajGenImport(AGinkId, ACode, AKtb: integer; NewGinkId, NewKtb: integer);

    PROCEDURE InitConvertor;
    PROCEDURE ReInitConvertor;
    FUNCTION Convert(Value: Extended): STRING;
    FUNCTION ConvertBlank(Value: Extended): STRING;
    FUNCTION ConvertEtik(Value: Extended): STRING;
    FUNCTION GetDefaultMnyRef: TMYTYP;
    FUNCTION GetDefaultMnyTgt: TMYTYP;

    FUNCTION GetISO(Mny: TMYTYP): STRING;
    FUNCTION GetTMYTYP(ISO: STRING): TMYTYP;
    FUNCTION GetTva(aTvaId: Integer): double;

    PROCEDURE FilterColor(Panel: TrzPanel; Filtered: Boolean);
    PROCEDURE MajAutoData(Conteneur: TComponent; UserCanModif: Boolean);

    PROCEDURE SetCanConvert(Origine: STRING; Bloque: Boolean);
    FUNCTION CanConvert(OkMess: Boolean): Boolean;

    PROCEDURE SetModifTTrav(Origine: STRING; Bloque: Boolean);
    FUNCTION ModifTTrav(OkMess: Boolean): Boolean;
    FUNCTION CanDeleteArt(OkMess: Boolean): Boolean;

    FUNCTION GetParam(ACode, AType, AMagID, APosID: integer; VAR PrmInteger: integer; VAR PrmFloat: double; VAR PrmString: STRING; VAR PrmInfo: STRING): boolean; // récupère les infos dans genparam a partri d'un code/type/mag/Poste
    FUNCTION GetParamInteger(ACode: integer; AType: integer; AMagID: integer = 0; APosID: integer = 0): integer; // récupération dabs genparam en fct du type
    FUNCTION GetParamString(ACode: integer; AType: integer; AMagID: integer = 0; APosID: integer = 0): STRING;
    FUNCTION GetParamInfo(ACode: integer; AType: integer; AMagID: integer = 0; APosID: integer = 0): STRING;
    FUNCTION GetParamFloat(ACode: integer; AType: integer; AMagID: integer = 0; APosID: integer = 0): double;

    FUNCTION SetParam(ACode, AType, AMagID, APosID : integer; PrmInteger : integer;PrmFloat : double;PrmString, PrmInfo : String;bNoZeroInt:Boolean=True;bNoZeroFloat:Boolean=True) : Boolean;

    PROCEDURE InitJetons;

    FUNCTION ResteEtiquette: Integer;

    FUNCTION ModeImpressionDevFull(DxImp: TObject; Sens: Integer; VAR Direct, ChxImp: Boolean): Boolean;

    FUNCTION ImpDevDBG(dxImp, dxPrt: TObject; OffsetPolice: Integer = 1; BestFit: Boolean = False): Boolean;
    // procédure générique des impressions de grilles décisionnelles
    // s'occupe à la fois de la boite de dialogue de paramétrage
    // mais aussi si restitue est à true de sauver et restituer la grille
    // dans sa config actuelle...
    // offsetPolice : param non obligatoire indique la diminution voulue du size de la
    // police si besoin de resiser les colonnes..

    PROCEDURE DevImpPgH(DxImp: TObject; FirstLine: STRING);
    // Page Header est de type TStrings
    // Charge first line dans la première ligne du page header
    // si cette ligne n'existe pas elle est crée
    // ne touche à aucune ligne existant éventuellement sauf laère (item )

    PROCEDURE DevImpFilter(DxImp: TObject; GrdFilter: ARRAY OF CONST);
    // Travaille sur "ReportTitle" propriété de type string et qui s'imprime
    // en dessous du pageHeader.
    // Réinitialise et reconfigure entièrement ReportTitle
    // met les chaînes de fitre dans le titre et configure
    // arial 8 normal
    // à gauche
    // uniquement sur 1ère page
    // si modif standard nécessaire, la coder après appel

    PROCEDURE CancelOnCache(Dset: TDataset; VAR VariantMem);
    PROCEDURE SauveOnCache(Dset: TDataset; VAR VariantMem);

    FUNCTION DateRgltCODE(DateDoc: TDateTime; CPACode: Integer): TDateTime;
    FUNCTION DateRgltID(DateDoc: TDateTime; CPAID: Integer): TDateTime;
    PROCEDURE ChpDateRgltCODE(DateDoc: TDateTime; CPACode: Integer; VAR Chp: TDateTimeField);

    // renvoi la liste de Table;Champs correspondant au champs ID ex ARTID, CLTID FOUID etc...
    FUNCTION Liste_Table_Par_Id(Id: STRING): TstringList;

    // renvoie la valeur du champ indiqué dans la requête passée en argument
    function GetDBFieldValue_With_Transaction(const ASQLText: string; const AFieldName: string = ''; const ADefaultValue: string = ''): string;
    function GetDBFieldValue( const ASQLText: string; const AFieldName: string = ''; const ADefaultValue: string = ''): string;

    // Cherche si Id existe dans les tables correspondant au champs ex ARTID, CLTID FOUID etc...
    FUNCTION ID_EXISTE(Champs: STRING; Id: Integer; Excepter: ARRAY OF CONST): Boolean;
    PROCEDURE ChgExerciceCommercial;
    FUNCTION OkDeVise(DoMess: Boolean = True): Boolean;

    PROCEDURE WaitMess(Msg: STRING);
    PROCEDURE WaitClose(const Sender: TForm = nil);
    PROCEDURE InitGaugeMess(Msg: STRING; MaxCount: Integer);
    PROCEDURE CloseGaugeMess;
    FUNCTION IncGaugeMess: Boolean;
    PROCEDURE InitGaugeBtn(Msg: STRING; MaxCount: Integer);
    FUNCTION ValGauge: Integer;
    PROCEDURE MaxGaugeMess(MaxCount: Integer);
    PROCEDURE PositionGaugeMess(Count: Integer);

    PROCEDURE DelayMess(Msg: STRING; DelaiSec: Integer);
    PROCEDURE DlgChpMemo(DS: TDatasource; Champ, Titre: STRING; Value: STRING = '');
    PROCEDURE DlgMemoRv(VAR Chp: TdxDbMemoRv; Titre: STRING; GotoNextOnOk: Boolean = True); overload;
    PROCEDURE DlgMemoRv(VAR Chp: TwwDBEditRv; Titre: STRING; GotoNextOnOk: Boolean = True; ForceReadOnly : boolean = false); overload;

    FUNCTION OuiNon(Caption, Text: STRING; BtnDef: Boolean): Boolean;
    // result := True SSI OUI ...
    PROCEDURE InfoMess(Caption, Text: STRING);
    PROCEDURE PrintTS(Caption: STRING; TS: TStrings);
    FUNCTION RechArt(Rech: STRING; DoMess: Boolean; Collection, FouId: Integer;
      Gros, Catalog, Virtuel, Archive: Boolean; VAR IsCB: Boolean;
      Qry: TIBOQuery; IsID: Integer = 0; RechPlus: Boolean = True): Integer;
    // 0 tous, 1 que ID, 2 Pas ID

    FUNCTION RechArtLOC(Rech: STRING; Client, LibRef, DoMess: Boolean; Virtuel, Archive: Boolean;
      VAR Qry: TIBOQuery; VAR IdClient: integer; OkFicheSecond: Boolean = True; ChronoExclusive: Boolean = False): integer;

    PROCEDURE CTRLTypDev;
    PROCEDURE CtrlMrkFouPrin;

    PROCEDURE AffecteHintEtBmp(Panel: TWinControl);
    PROCEDURE GetFirstIdLigne(Prec, Suiv: STRING; Nbre: Integer);
    FUNCTION GetIdLigne(VAR IdL: STRING): Boolean;

    FUNCTION rechercheCP(VAR Cp, Ville, pays: STRING; VAR Id, idpays: Integer; AvecPays: Boolean = False; AvecInsertion: Boolean = True): Boolean;
    PROCEDURE GesModereg;

    FUNCTION IsUniqueTailCoul(Artid: Integer; VAR TGFID: Integer; VAR TgfNom: STRING; VAR Couid: Integer; VAR CouNom: STRING): Boolean;

    FUNCTION IS98: Boolean;

    PROCEDURE DechargeBMP(Panel: TWinControl);
    FUNCTION chargeBMP(Panel: TWinControl): Boolean;
    PROCEDURE LibereBMP(Panel: TWinControl);

    PROCEDURE LoadSmallBmp(Name: STRING; Bit: TspeedButton); OVERLOAD;
    PROCEDURE LoadLargeBmp(Name: STRING; Bit: TspeedButton); OVERLOAD;
    PROCEDURE LoadSmallBmp(Name: STRING; Bit: TLMDCUSTOMSpeedButton); OVERLOAD;
    PROCEDURE LoadLargeBmp(Name: STRING; Bit: TLMDCUSTOMSpeedButton); OVERLOAD;
    PROCEDURE LoadSmallBmp(Name: STRING; Bit: TPicture); OVERLOAD;
    PROCEDURE LoadLargeBmp(Name: STRING; Bit: TPicture); OVERLOAD;
    PROCEDURE LoadSmallBmp(Name: STRING; Bit: TLMDSpecialButton); OVERLOAD;
    PROCEDURE LoadLargeBmp(Name: STRING; Bit: TLMDSpecialButton); OVERLOAD;
    PROCEDURE LoadSmallBmp(Name: STRING; Bit: TRzDBButtonEdit); OVERLOAD;
    PROCEDURE LoadLargeBmp(Name: STRING; Bit: TRzDBButtonEdit); OVERLOAD;
    PROCEDURE LoadSmallBmp(Name: STRING; Bit: TdxBarButton); OVERLOAD;
    PROCEDURE LoadLargeBmp(Name: STRING; Bit: TdxBarButton); OVERLOAD;

    FUNCTION TestOkModule(Name: STRING): Boolean;
    PROCEDURE InitTestModule;
    FUNCTION NEXTID(ID: INTEGER; NOMTABLE: STRING; okMess: Boolean = True): INTEGER;
    FUNCTION PRIORID(ID: INTEGER; NOMTABLE: STRING; okMess: Boolean = True): INTEGER;

    FUNCTION CONTROLESAGE(Text: STRING): STRING;
    FUNCTION LOCATION: boolean;
    FUNCTION ChronoModifiable(Chrono: STRING): Boolean;
    FUNCTION DimPerScreen(Value: Integer): Integer;
    FUNCTION DureePeriodeMoisJour(Debut, fin: TdateTime): Integer;
    FUNCTION PictureMaskChrono(OnOff: Boolean): STRING;

    // lancement directe d'une impression
    PROCEDURE Imprime_Directement(dxPrt, dxImp: TObject);
    FUNCTION BlokDate: Boolean;
    FUNCTION NbrRefPxNonTraite: Integer;
    FUNCTION NbrRefNKNonTraite: Integer;

    PROCEDURE Do_OC(Artid: Integer = 0; Chrono: STRING = '');
    PROCEDURE GesHintetButton(Panel: TWinControl);

    FUNCTION Getreferencementdyna: boolean;
    FUNCTION GetReferencement: boolean;
    FUNCTION GetTraiteJournaux: boolean;
    FUNCTION GetCollection: boolean;
    FUNCTION GetWebVente: boolean;
    FUNCTION GetImp_SP2000: boolean;
    FUNCTION GetBonPrepra: boolean;

    FUNCTION LibCouleur(CODE: STRING; NOM: STRING): STRING;

    // enregistre le flux XML reçu en erreur dans le répertoire PathErreurXML (donc AFileName ne doit pas contenir de chemin)
    procedure EnregistreXMLErreur(AFluxXML, AFileName: string);

    // Fonction de contrôle pour dossier SPORT 2000
    PROCEDURE TypeArticle_SP2000(ARTID: INTEGER; VAR CATMAN, REFERENCE: Boolean; VAR TYPE_REF: INTEGER);
    FUNCTION ControlePrix_SP2000(ARTID, MRKID, FOUID: INTEGER; VAR PxAchat, PxNet, PxVte: Extended): Boolean;
    FUNCTION Md5(chaine: STRING): STRING;

    FUNCTION lengthMsgGsm(texte: STRING): integer; // FC : 09/03/2009 : Ajout pour Lab

    //lab 21/12/09 BeCollect'or
    FUNCTION majClientFidBecol(VAR clt_id: Integer; mode: Integer; numCb: STRING; cltData: TDataCard; VAR cbGinkoia: STRING): boolean;
    FUNCTION creerAdresseLigne(champs1, champs2, champs3: STRING): STRING;

    //Procedure de création de log
    Procedure Log(FileLogName,Texte:String);

    //Fonction permettant de choisir la base de recherche du référencement dynamique
    Function ChoixRefDyn:Integer;

    // renvoie true si la date de migration est inférieur à la date à controler
    function CtrlMigrationIntersys(AMagID: integer; ADateACtrl: TDatetime; var ADateMigre: TDatetime): boolean;

    // renvoie true si la date du document n'est pas dans un exe comptable cloturé
    function CtrlExerciceComptable(AMagID: integer; ADateACtrl: TDatetime): boolean;

    // envoi un message mail à ginkoia
    procedure MailToGinkoia(AObjet, AMessage, AFileJoint: string); overload;
    procedure MailToGinkoia(AObjet, AMessage: string; AFileJoints: TStrings); overload;

    // Supprime toutes les selection d'articles de TMPSTAT contenu dans AListeID
    procedure SupprimeLesIDDeTmpStat(AListeID: TStrings);

    // est-ce la centrale est présent au moins dans un domaine commercial
    function IsIntersportInDomaineCommercial: boolean;

    procedure checkCentralModules ;
    procedure checkCrossCanal;
    function getTypeModeleStr(aCentrale: integer ; isSp2000:boolean = false ;  isCatman : Boolean = false): string;
    procedure ChargeDonneeSociete(magid : integer);

//JB
   function SaveOrLoadDBGGrilleConfiguration(SaveOrLoad : Boolean;aDBGGrille : TdxDBGridHP; var OldConfig : Boolean) : Boolean;
//

  PUBLISHED

    PROPERTY SocieteName: STRING READ FSocieteName WRITE FSocieteName;
    PROPERTY MagasinName: STRING READ FMagasinName WRITE FMagasinName;
    PROPERTY MagasinAdr: STRING READ FMagasinAdr WRITE FMagasinAdr;
    property MagasinAdrVILLE: STRING READ FMagasinAdrVILLE WRITE FMagasinAdrVILLE;
    property MagasinAdrCP: STRING READ FMagasinAdrCP WRITE FMagasinAdrCP;
    property MagasinAdrPAYS: STRING READ FMagasinAdrPAYS WRITE FMagasinAdrPAYS;
    PROPERTY MagasinEnseigne: STRING READ FMagEnseigne WRITE FMagEnseigne;
    PROPERTY PosteName: STRING READ FPosteName WRITE FPosteName;
    PROPERTY SocieteID: Integer READ FSocieteID WRITE FSocieteID;
    PROPERTY SocieteADR: boolean READ FSocieteADR WRITE FSocieteADR;
    PROPERTY SocieteCapital: String READ FSocieteCapital WRITE FSocieteCapital;
    PROPERTY MagasinID: Integer READ FMagasinID WRITE FMagasinID;
    PROPERTY PosteID: Integer READ FPosteID WRITE FPosteID;
    PROPERTY BaseID: Integer READ FBaseID WRITE FBaseID;
    property BasCodeTiers: string read FBasCodeTiers write FBasCodeTiers;
    property BasGuid: String read FBasGuid write FBasGuid;
    PROPERTY PrefixBase: STRING READ FPrefix WRITE FPrefix;
    PROPERTY MagasinCodeAdh: STRING READ FMagCodeAdherent WRITE FMagCodeAdherent; //lab mis en place pour fid nat twin

    PROPERTY TvtID: Integer READ FTvtID WRITE FTvtID;
    PROPERTY MtaId: Integer READ FMtaId WRITE FMtaId;
    PROPERTY TvtNom: STRING READ FNomTvt WRITE FNomTvt;
    PROPERTY NbreMags: Integer READ FMM WRITE FMM;

    PROPERTY RepImg: STRING READ FrepImg WRITE FRepImg;
    PROPERTY RepNonRefImg: STRING READ FNonRefRepImg WRITE FNonRefRepImg;
    PROPERTY UniVers: Integer READ Funi WRITE Funi;
    PROPERTY Origine: Integer READ Forig WRITE Forig;

    PROPERTY ResteEtiK: Integer READ FEtik WRITE FEtik;
    PROPERTY Imp_Laser: STRING READ FImp_Laser WRITE FImp_Laser;
    PROPERTY Imp_Eltron: STRING READ FImp_Eltron WRITE FImp_Eltron;
    PROPERTY LaserPreview: Integer READ FLaserPreview WRITE FLaserPreview;
    PROPERTY PrintReverse: Integer READ FPrintReverse WRITE FPrintReverse;

    PROPERTY ModeZPL: Integer READ FModeZPL WRITE FModeZPL;
    PROPERTY Densite: Integer READ FDensite WRITE FDensite;
    property Vitesse: integer READ FVitesse WRITE FVitesse;
    property WideBar: integer READ FWideBar WRITE FWideBar;
    property interpretation_line: Integer read Finterpretation_line write Finterpretation_line; 

    PROPERTY Etik_Format: Integer READ FEtik_Format WRITE FEtik_Format;
    PROPERTY DernierImpression: Integer READ FDerImp WRITE FDerImp;

    PROPERTY Etik_Format_clt: Integer READ FEtik_Format_clt WRITE FEtik_Format_clt;
    PROPERTY Etik_Format_Loc: Integer READ FEtik_Format_loc WRITE FEtik_Format_loc;

    // Push - Pull Cogisoft
    PROPERTY PushURL: STRING READ FPushURL WRITE FPushURL;
    PROPERTY PushUSER: STRING READ FPushUSER WRITE FPushUSER;
    PROPERTY PushPASS: STRING READ FPushPASS WRITE FPushPASS;
    PROPERTY PushPROV: TStrings READ FPushPROV WRITE FPushPROV;
    PROPERTY PullURL: STRING READ FPullURL WRITE FPullURL;
    PROPERTY PullUSER: STRING READ FPullUSER WRITE FPullUSER;
    PROPERTY PullPASS: STRING READ FPullPASS WRITE FPullPASS;
    PROPERTY PullPROV: TStrings READ FPullPROV WRITE FPullPROV;

    PROPERTY DevModImp: Integer READ FDevModImp WRITE SetDevModimp;
    PROPERTY GestionHT: Boolean READ FgestionHT WRITE FGestionHT;
    PROPERTY GlossaireHT: Boolean READ FglossaireHT WRITE FGlossaireHT;
    PROPERTY ISDigital: Boolean READ FDigital WRITE FDigital;
    PROPERTY DefTvaTaux: STRING READ FDefTVATaux WRITE FDefTVATaux;
    PROPERTY DefTvaId: Integer READ FDefTVA WRITE FDefTVA;
    PROPERTY NKLevel: Integer READ FNkLevel WRITE FNkLevel;

    // ---------------------->

    PROPERTY NumLock: Boolean READ Fnl WRITE SetFnl;
    PROPERTY Capslock: Boolean READ Fcl WRITE SetFcl;
    PROPERTY CalcResult: Double READ FCalc;

    PROPERTY IniFileName: STRING READ FIniApp;
    PROPERTY PathApp: STRING READ FPatApp;
    PROPERTY PathLecteur: STRING READ FPatLect;
    PROPERTY PathHelp: STRING READ FPatHelp;
    PROPERTY PathBase: STRING READ FPatBase WRITE FPatBase;
    PROPERTY PathRapport: STRING READ FPatRapport WRITE FPatRapport;
    PROPERTY PathErreurXML: STRING READ FPatErreurXML WRITE FPatErreurXML;
    PROPERTY PathEAI: STRING READ FPatEAI WRITE FPatEAI;
    PROPERTY ExeEAI: STRING READ FPatEAIexe WRITE FPatEAIexe;
    PROPERTY NomPoste: STRING READ FNP WRITE FNP;
    PROPERTY NomDuMag: STRING READ FNM WRITE FNM;

    PROPERTY HistoDuree: Integer READ FHistoDur WRITE FHistoDur DEFAULT 6;

    PROCEDURE GenerikAfterPost(DataSet: TDataSet);
    PROCEDURE GenerikBeforeOpen(DataSet: TDataSet);
    PROCEDURE GenerikUpdateRecord(DataSet: TDataSet; UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
    PROCEDURE ParamsBeforeDelete(DataSet: TDataSet);
    PROPERTY NkAffSecteurs: Integer READ FAffSec WRITE FAffSec DEFAULT 0;
    PROPERTY VisuMagSoc: Boolean READ FVisuMagSoc WRITE FVisuMagSoc DEFAULT True;
    PROPERTY DefMajTarRecep: Boolean READ FDefMajTarRecep WRITE FDefMajTarRecep DEFAULT True;
    PROPERTY DefCollec: Boolean READ FDefCollec WRITE FDefCollec DEFAULT True;
    PROPERTY IdDefCollec: Integer READ FIdDefCollec WRITE FIdDefCollec DEFAULT 0;
    PROPERTY DefCollecRecept: Boolean READ FDefCollecRecept WRITE FDefCollecRecept DEFAULT True; //lab 866 gérer les collections en réception et en commande
    PROPERTY IdDefCollecRecept: Integer READ FIdDefCollecRecept WRITE FIdDefCollecRecept DEFAULT 0; //lab 866 gérer les collections en réception et en commande
    PROPERTY IsAlgol: Boolean READ FisAlgol WRITE FisAlgol DEFAULT False;

    PROPERTY IDPSEUDOTO: Integer READ FPseudoTO WRITE FPseudoTO;
    PROPERTY IDTOTWINNER: Integer READ FTOTWINNER WRITE FTOTWINNER;
    PROPERTY IDTOWEB: Integer READ FTOWEB WRITE FTOWEB;
    PROPERTY TOWEBACTIVE: Boolean READ FTOWEBACTIVE WRITE FTOWEBACTIVE;
    PROPERTY DEBUTSAISLOC: STRING READ FDEBSAISLOC WRITE FDEBSAISLOC;

    PROPERTY LaFormActive: TCustomForm READ fLaFormActive WRITE fLaFormActive;
    PROPERTY FMaxiDbg: Integer READ FMaxiDbgDev WRITE FMaxiDbgDev;
    PROPERTY IsXP: Boolean READ FIsXP;
    PROPERTY IdTVTWeb: Integer READ FidTvtWeb;
    PROPERTY ISWEBParamOK: Boolean READ FISWEBParamOK;
    PROPERTY IDCurrentUser: Integer READ FIdCurUser;

    PROPERTY Referencement: Boolean READ GetReferencement;
    PROPERTY TraiteJournaux: Boolean READ GetTraiteJournaux;
    PROPERTY Collection: Boolean READ GetCollection;
    PROPERTY WebVente: Boolean READ GetWebVente;
    PROPERTY ReferencementDyna: Boolean READ Getreferencementdyna;

    // Variable globale pour dossier SPORT 2000
    PROPERTY Imp_SP2000: Boolean READ GetImp_SP2000; // Import par CDRom des JA
    PROPERTY REF_DYNA_SP2000: boolean READ Fref_dyna_sp2000;
    PROPERTY CATMAN: boolean READ Fcatman ;

    //lab 15/07/08 Fid nat Twinner
    PROPERTY FidNatTwinner: Boolean READ FFidNatTwinner;
    PROPERTY FidNatUrl: STRING READ FFidNatUrl;

    // FC 02/03/09 : WebVente type CLEONET
    PROPERTY webType: TWebDossier READ FwebTypeDossier WRITE FwebTypeDossier;

    //lab Bon de préparation 1056
    PROPERTY BonPreparation: Boolean READ GetBonPrepra;

    // CBR - Modif - 10/04/2013 - CR:2000
    PROPERTY FlagSavePrinterSetup_RapRV: Boolean READ FFlagSavePrinterSetup_RapRV WRITE FFlagSavePrinterSetup_RapRV;  // CBR - Modif 10/04/2013 - CR 2000

    property isModuleIntersport : Boolean read bModuleIntersport ;
    property isModuleCourir     : Boolean read bModuleCourir ;
    property isModuleGoSport    : Boolean read bModuleGoSport ;
    property isModuleSport2000  : Boolean read bModuleSport2000 ;

    // cross canal
    property isModuleCrossCanal : Boolean read bModuleCrossCanal;

    // auto login
    property AutoLogUser : String read FLogin write FLogin;
    property AutoLogPass : String read FMdp write FMdp;

  END;

VAR
  StdGinKoia: TStdGinKoia;

  TVA: Integer; //clé de la TVA par défault de l'application
  TVA_TAUX: STRING; // Libelle de la TVA par défault de l'application
  CartCadeauConfig : TCarteCadeau; // Record de configuration des cartes cadeau

CONST

  // ---------------------- > Ex ConstCaisse ---------------->
  //--------------------------------------------------------->

  IBDATEFORMAT = 'yyyy-mm-dd';

  //// MODE D'ENCAISSEMENT

 // Type de mode d'encaissement
  ENC_COMPTECLI = 1;
  ENC_DEVISE = 2;
  ENC_REMISE = 3;
  ENC_ESPECE = 4;
  ENC_AUTRE = 5;

  // Détail géré
  ENC_AVECDETAIL = 1;
  ENC_SANSDETAIL = 0;

  // Type de fond
  ENC_FDVARIABLE = 0;
  ENC_FDFIXE = 1;

  // Type de transfert auto
  ENC_TRFCOFFRE = 1;
  ENC_TRFBANQUE = 2;

  // Date d'échéance
  ENC_AVECDATEECH = 1;
  ENC_SANSDATEECH = 0;

  //// SESSION DE CAISSE

  // Etat de session
  SES_OUVERTE = 0;
  SES_CLOTNOCTRL = 1;
  SES_CLOTCTRL = 2;

  //********************************************* >

FUNCTION ERRMess(Chaine: STRING; V: variant): Word;
FUNCTION INFMess(Chaine: STRING; V: variant): Word;
FUNCTION WARMess(Chaine: STRING; V: variant): Word;
FUNCTION CNFMess(Chaine: STRING; V: Variant; BtnDef: Integer): Word;
FUNCTION NCNFMess(Chaine: STRING; V: variant): Word;
{ *****************************************************************************
  Message de confirmation avec NON PAR DEFAUT
 ***************************************************************************** }

FUNCTION CtrlDelIdRef(IdRef: Integer; ShowErrorMessage: Boolean): boolean;
FUNCTION CtrlEditIdRef(IdRef: Integer; ShowErrorMessage: Boolean): boolean;
{ *****************************************************************************
  Fonctions génériques qui retournent False et éventuellement un message d'erreur
  si le paramètre d'entrée IdRef <> 0.
  Dans Pollux nous n'aurons pas besoin de plus pour contrôler lorsque ce sera
  nécessaire les enregs de référence ...
 ***************************************************************************** }

//--------------------------------------------------------------------------------
// Routines Globales "outils"
//--------------------------------------------------------------------------------
                                              
procedure PostFocus(AFocusControl: TWinControl);

PROCEDURE Pause(Value: Integer); // secondes
PROCEDURE Delai(Value: Integer); // milisecondes
PROCEDURE ExecTip;
FUNCTION ExecCalc: Boolean;
// le résultat est dans la propriété CalcResult de la forme

FUNCTION CreateForm(AFormClass: TFormClass): TCustomForm;
FUNCTION ExecModal(AForm: TForm; AClass: TFormClass): TModalResult;
FUNCTION SetFocusHP(Panel: TWinControl; delai: Integer = 0): Boolean;

// FTH
// 07/10/2009  - 08/10/2009
FUNCTION SendMailFromGrid(DbgDxHp: TdxDbGridHP; sFieldEmail: STRING = 'ADR_EMAIL'): Boolean;
FUNCTION SendSmsFromGrid(DbgDxHp: TdxDbGridHP; sFieldGsm: STRING = 'ADR_GSM'): Boolean;
FUNCTION isCellulaire(VAR numCell: STRING): boolean;

// 17/12/2012 DLA Calcul clé de luhn
function luhn(arg: string): boolean;
function CodeBarreTypeClient (aCode: string): boolean;

function MaxEncoursAtteint (aMontant: currency; aClientId, aMagId: integer): currency;
//JB
function SecToTime(Sec: Integer): string;
function EnteteFichierLogStats(DateTimeDebut, DateTimeFin : TDateTime; TransactionName, Duree : String) : String;
//

IMPLEMENTATION
USES
  GinkoiaResStr,
  StdUtils,
  StdBdeUtils,
  StdDateUtils,
  Uil_Dm,
  Main_dm,
  ChxcolImp_Frm,
  DlgMemo_Frm,
  Common_frm,
  VPCP_Frm,
  DlgStd_Frm,
  GaugeMess_Frm,
  RefRechArt_frm,
  md5api,
  RapMail_frm,
  SavMessageSms_Frm,
  // IDxxxx Nécesaire pour la création dynamique du composant SMTP pour l'envoi de mail
  IdEmailAddress,
  IdAttachment,
  IdMessage,
  IdAttachmentFile,
  // Nécessaire pour la prise en charge du module d'envoi de sms
  eSendexLib_TLB,
  ActiveX,
  GinkoiaEAICommon,
  ReferencementResStr,
  PostFocusUnit,
  SaveLoadDbgConfig_Frm;

{$R *.DFM}

procedure PostFocus(AFocusControl: TWinControl);
begin
  PostFocusUnit.PostFocus(AFocusControl);
end;

function TStdGinKoia.GetDBFieldValue_With_Transaction(const ASQLText: string; const AFieldName: string = ''; const ADefaultValue: string = ''): string;
var Query:TIB_Query;
begin
    Query:=TIB_Query.Create(Self);
    try
      try
          Query.IB_Connection := Dm_Main.Database;
          Query.IB_Transaction := Dm_Main.IbT_Maj;
          Query.IB_Transaction.StartTransaction;
          Query.SQL.Text := ASQLText;
          Query.Open;
          if Query.RecordCount > 0 then
          begin
            if AFieldName = '' then
            begin
              Result := Query.Fields[0].AsString;
            end else
            begin
              Result := Query.FieldByName( AFieldName ).AsString;
            end;
          end else
          begin
            Result := ADefaultValue;
          end;
          Query.IB_Transaction.Commit;
    Except
       result:='';
       Query.IB_Transaction.Commit;
    end;
    Finally
    Query.Close;
    Query.Free;
  end;
end;


function TStdGinKoia.GetDBFieldValue(const ASQLText: string; const AFieldName: string = ''; const ADefaultValue: string = ''): string;
begin
  with TIB_Query.Create( Self ) do
  begin
    IB_Connection := Dm_Main.Database;
    IB_Transaction := Dm_Main.IbT_Select;
    SQL.Text := ASQLText;
    Open;
    if RecordCount > 0 then
    begin
      if AFieldName = '' then
      begin
        Result := Fields[0].AsString;
      end else
      begin
        Result := FieldByName( AFieldName ).AsString;
      end;
    end else
    begin
      Result := ADefaultValue;
    end;
    Free;
  end;
end;

procedure TStdGinKoia.MailToGinkoia(AObjet, AMessage, AFileJoint: string);
var
  LstTmp: TStringList;
begin
  LstTmp := TStringList.Create;
  try
    if (AFileJoint<>'') and FileExists(AFileJoint) then
      LstTmp.Add(AFileJoint);
    MailToGinkoia(AObjet, AMessage, LstTmp);
  finally
    FreeAndNil(LstTmp);
  end;
end;

procedure TStdGinKoia.MailToGinkoia(AObjet, AMessage: string; AFileJoints: TStrings);
var
  ParamSMTP: TParamSMTP;
  ToMail: string;
  bOkEnvoye: boolean;
  IdMessage: TIdMessage;
  IdSMTP: TIdSMTP;
  QueTmp: TIBOQuery;
  infoMagEnseigne: string;
  InfoMagVille: string;
  InfoCodeAdh: string;
  InfoBasSender: string;
  i: integer;
begin
  try    
    // CR1744 :
    // chercher ces valeurs dans des paramètres, les garder comme valeurs par défaut
    // paramètres de connexion stmp
    ParamSMTP.From := 'ginkoia@ginkoia.fr';
    ParamSMTP.Host := 'smtp.fr.oleane.com';
    ParamSMTP.user := 'mp1304-28@algodefi.fr.fto';    //  mp1304-28@algodefi.fr.fto
    ParamSMTP.Pwd := 'VcHSB0cw';
    ParamSMTP.Port := 25;
    ToMail := 'christophe.henrat@ginkoia.fr';
    bOkEnvoye := false;

    infoMagEnseigne := '';
    InfoMagVille := '';
    InfoCodeAdh := '';
    InfoBasSender := '';
    QueTmp := TIBOQuery.Create(Self);
    try
      QueTmp.IB_Connection := Dm_Main.Database;
      QueTmp.IB_Transaction := Dm_Main.IbT_HorsK;
      With QueTmp do
      begin
        // récupération paramétrage SMTP
        SQL.Clear;
        SQL.Add('select * from GENPARAM');
        SQL.Add('where PRM_TYPE=3 and PRM_CODE=:PRMCODE');

        // Expidateur SMTP
        ParamByName('PRMCODE').AsInteger := 60;
        Open;
        if not(Eof) then
          ParamSMTP.From := fieldbyname('PRM_STRING').AsString;
        Close;

        // Host SMTP + Port SMTP
        ParamByName('PRMCODE').AsInteger := 61;
        Open;
        if not(Eof) then
        begin
          ParamSMTP.Host := fieldbyname('PRM_STRING').AsString;
          ParamSMTP.Port := fieldbyname('PRM_INTEGER').AsInteger;
        end;
        Close;

        // User SMTP
        ParamByName('PRMCODE').AsInteger := 62;
        Open;
        if not(Eof) then
          ParamSMTP.user := fieldbyname('PRM_STRING').AsString;
        Close;

        // Pass SMTP
        ParamByName('PRMCODE').AsInteger := 63;
        Open;
        if not(Eof) then
          ParamSMTP.Pwd := fieldbyname('PRM_STRING').AsString;
        Close;    

        // Destinataire + Envoyé (oui/non) pour pas être inondé de mail
        ParamByName('PRMCODE').AsInteger := 64;
        Open;
        if not(Eof) then
        begin
          ToMail := fieldbyname('PRM_STRING').AsString;   
          bOkEnvoye := (fieldbyname('PRM_INTEGER').AsInteger=1);
        end;
        Close;

        // recupération info
        SQL.Clear;
        SQL.Add('select MAG_ENSEIGNE, MAG_CODEADH, VIL_NOM from genmagasin');
        SQL.Add('join GENADRESSE on adr_id=mag_adrid');
        SQL.Add('join GENVILLE b on vil_id=adr_vilid');
        SQL.Add('where mag_id='+inttostr(MagasinID));
        Open;
        infoMagEnseigne := fieldbyname('MAG_ENSEIGNE').AsString;
        InfoCodeAdh := fieldbyname('MAG_CODEADH').AsString;
        InfoMagVille := fieldbyname('VIL_NOM').AsString;
        Close;
              
        SQL.Clear;
        SQL.Add('select * from GENBASES');
        SQL.Add('where BAS_ID='+inttostr(BaseID));
        Open;
        InfoBasSender := fieldbyname('BAS_SENDER').AsString;   
        Close;
      end;
    finally
      QueTmp.Close;
      FreeAndNil(QueTmp);
    end;

    if not(bOkEnvoye) then
      exit;

    // envoi du msg
    IdSMTP := TIdSMTP.Create(Self);
    IdMessage := TIdMessage.Create(Self);
    try
      // expéditeur
      IdMessage.From.Address := ParamSMTP.From;
      // destinataire
      IdMessage.Recipients.EMailAddresses := ToMail;
      // objet
      IdMessage.Subject := AObjet;
      // corps du Message
      with IdMessage.Body do
      begin
        Clear;
        Add('Le '+FormatDateTime('dd/mm/yyyy" à "hh:nn', now));
        Add('');
        Add('Message provenant de:');
        Add(#9+'Nom société: '+#9+SocieteName);
        Add(#9+'Enseigne Mag.: '+#9+infoMagEnseigne);
        Add(#9+'Ville Magasin: '+#9+InfoMagVille);
        Add(#9+'Code adhérent: '+#9+InfoCodeAdh);
        Add(#9+'Base Sender: '+#9+InfoBasSender);
        Add('');
        Add(AMessage);
      end;
      //pièces jointes
      for i:=1 to AFileJoints.Count do
      begin
        if (AFileJoints[i-1]<>'') and FileExists(AFileJoints[i-1]) then
          TIdAttachmentFile.Create(IdMessage.MessageParts, AFileJoints[i-1]);
      end;

      // envoi du Message
      IdSMTP.Host := ParamSMTP.Host;
      IdSMTP.Username := ParamSMTP.user;
      IdSMTP.Password := ParamSMTP.Pwd;
      IdSMTP.Port := ParamSMTP.Port;
      IdSMTP.Connect;
      IdSMTP.Send(IdMessage);

    finally
      IdSMTP.Disconnect;
      FreeAndNil(IdMessage);
      FreeAndNil(IdSMTP);
    end;
  except
    // pas d'affichage d'erreur pour l'envoi de mail d'erreur !
    // par contre, c'est enregistrer dans les log
    on E:Exception do
      EnregistrerLog('MailToGinkoia: '+E.Message);
  end;

end;

PROCEDURE TStdGinKoia.Imprime_Directement(dxPrt: TObject; dxImp: TObject);
VAR
  MaxPortrait, Maxi,
    //u, z,
  i, j, k: Integer;
  //rat: Extended;
  Lk: ARRAY[0..5] OF Integer;
  Sens: Integer;
BEGIN
  MaxPortrait := IniCtrl.ReadInteger('DEVMOD', 'PORTRAIT', 1035);
  FOR i := 0 TO 5 DO
    Lk[i] := 0;
  k := 0;
  FOR j := 0 TO (DxImp AS TdxDbGridReportLink).DBGrid.VisibleColumnCount - 1 DO
  BEGIN
    LK[(DxImp AS TdxDbGridReportLink).DBGrid.VisibleColumns[j].RowIndex] :=
      LK[(DxImp AS TdxDbGridReportLink).DBGrid.VisibleColumns[j].RowIndex] +
      (DxImp AS TdxDbGridReportLink).DBGrid.VisibleColumns[j].Width;
  END;
  FOR i := 0 TO 5 DO
    IF Lk[i] > k THEN k := LK[i];

  IF k >= StdGinkoia.DimPerScreen(700) THEN
    sens := 1
  ELSE
    sens := 0;
  IF sens = 0 THEN
    (DxImp AS TdxDBGridReportLink).PrinterPage.Orientation := PoPortrait
  ELSE
    (DxImp AS TdxDBGridReportLink).PrinterPage.Orientation := PoLandScape;
  (DxImp AS TdxDBGridReportLink).PrinterPage.Margins.Top := 12700;
  (DxImp AS TdxDBGridReportLink).PrinterPage.Margins.Bottom := 12700;
  (DxImp AS TdxDBGridReportLink).PrinterPage.Margins.Left := 6350;
  (DxImp AS TdxDBGridReportLink).PrinterPage.Margins.Right := 6350;
  IF Sens = 0 THEN
    maxi := DimPerScreen(700)
  ELSE
    maxi := DimPerScreen(MaxPortrait);
  (DxImp AS TdxDbGridReportLink).ShrinkToPageWidth := k >= Maxi;
  CASE iniCtrl.ReadInteger('EDITION_ENCHAINE', 'Mode', 0) OF
    0: (DxImp AS TdxDBGridReportLink).DrawMode := tldmStrict;
    1: (DxImp AS TdxDBGridReportLink).DrawMode := tldmBorrowSource;
    2:
      BEGIN
        (DxImp AS TdxDBGridReportLink).DrawMode := tldmStrict;
        (DxImp AS TdxDBGridReportLink).FixedTransParent := True;
      END;
  END; // du case

  (DxPrt AS TDXComponentPrinter).Print(False, NIL, (DxImp AS TdxDBGridReportLink));
END;

FUNCTION TStdGinKoia.OuiNon(Caption, Text: STRING; BtnDef: Boolean): Boolean;
BEGIN
  IF Trim(Text) = '' THEN text := DefOuiNon;
  IF Trim(Caption) = '' THEN Caption := ' ' + LibConf + '...';

  Result := OuiNonHP(Text, BtnDef, True, 0, 0, Caption);
END;

PROCEDURE TStdGinKoia.InfoMess(Caption, Text: STRING);
BEGIN
  IF Trim(Caption) = '' THEN Caption := ' ' + LibInfo + '...';
  InfoMessHP(Text, True, 0, 0, Caption);
END;

PROCEDURE TStdGinKoia.WaitMess(Msg: STRING);
BEGIN
  ShowmessHP(Msg, True, 0, 0, '');
END;

PROCEDURE TStdGinKoia.WriteJeton;
BEGIN
  Dm_Main.IbC_Script.SQL.Text := 'DELETE ' +
    '  FROM GENJETONS' +
    ' WHERE JET_BASID = ' + IntToStr(BaseId) +
    '   AND JET_NOMPOSTE = ' + QuotedStr(MyComputerName);
  Dm_Main.ExecuteScript;

  Dm_Main.IbC_Script.SQL.Text := 'INSERT INTO GENJETONS' +
    '  (JET_BASID, JET_NOMPOSTE, JET_STAMP) ' +
    'VALUES ' +
    '  (' + IntToStr(BaseId) + ',' + QuotedStr(MyComputerName) + ',current_timestamp)';
  Dm_Main.ExecuteScript;

END;

PROCEDURE TStdGinKoia.WaitClose(const Sender: TForm = nil);
BEGIN
  ShowCloseHP( Sender );
END;

PROCEDURE TStdGinKoia.MaxGaugeMess(MaxCount: Integer);
BEGIN
  MaxGaugeMessHP(MaxCount);
END;

PROCEDURE TStdGinKoia.PositionGaugeMess(Count: Integer);
BEGIN
  PositionGaugeMessHP(Count);
END;

PROCEDURE TStdGinKoia.InitGaugeMess(Msg: STRING; MaxCount: Integer);
BEGIN
  InitGaugeMessHP(Msg, MaxCount, true, 0, 0, '', False);
END;

FUNCTION TStdGinKoia.VAlGauge: Integer;
BEGIN
  Result := ValGaugeHP;
END;

PROCEDURE TStdGinKoia.InitGaugeBtn(Msg: STRING; MaxCount: Integer);
BEGIN
  InitGaugeMessHP(Msg, MaxCount, true, 0, 0, '', True);
END;

PROCEDURE TStdGinKoia.CloseGaugeMess;
BEGIN
  CloseGaugeMessHP;
END;

FUNCTION TStdGinKoia.IncGaugeMess: Boolean;
BEGIN
  Result := IncGaugeMessHP;
END;

PROCEDURE TStdGinKoia.DelayMess(Msg: STRING; DelaiSec: Integer);
BEGIN
  IF DelaiSec = 0 THEN DelaiSec := 5;
  WaitMessHP(Msg, Delaisec, True, 0, 0, ' ' + LibInfo + '...');
END;

PROCEDURE TStdGinKoia.ChpDateRgltCODE(DateDoc: TDateTime; CPACode: Integer; VAR Chp: TDateTimeField);
VAR
  T: TDateTime;
BEGIN
  T := DateRgltCODE(DateDoc, CPACode);
  IF T = 0 THEN
    chp.Clear
  ELSE
    chp.asDateTime := T;
END;

FUNCTION TStdGinKoia.OkDeVise(Domess: Boolean = True): Boolean;
BEGIN
  Result := True;
  IF GetIso(stdGinkoia.Convertor.MnyRef) <>
    GetIso(stdGinkoia.Convertor.DefaultMnyRef) THEN
  BEGIN
    IF DoMess THEN WaitMessHP(NoGoodDevise, 2, true, 0, 0, '');
    Result := False;
  END;
END;

FUNCTION TStdGinKoia.DateRgltCODE(DateDoc: TDateTime; CPACode: Integer): TDateTime;
BEGIN
  Result := 0;
  IF DateDoc = 0 THEN DateDoc := Date;
  CASE CPACode OF
    2: Result := DateDoc + 3;
    3: Result := AddDays(DateDoc, 30);
    15: Result := AddDays(DateDoc, 45);
    4: Result := AddDays(DateDoc, 60);
    5: Result := AddDays(DateDoc, 90);
    6: Result := AddDays(DateDoc, 120);

    7: Result := LastDayOfMonth(AddDays(DateDoc, 30));
    16: Result := LastDayOfMonth(AddDays(DateDoc, 45));
    8: Result := LastDayOfMonth(AddDays(DateDoc, 60));
    9: Result := LastDayOfMonth(AddDays(DateDoc, 90));
    10: Result := LastDayOfMonth(AddDays(DateDoc, 120));

    11: Result := AddDays(LastDayOfMonth(AddDays(DateDoc, 30)), 10);
    17: Result := AddDays(LastDayOfMonth(AddDays(DateDoc, 45)), 10);
    12: Result := AddDays(LastDayOfMonth(AddDays(DateDoc, 60)), 10);
    13: Result := AddDays(LastDayOfMonth(AddDays(DateDoc, 90)), 10);
    14: Result := AddDays(LastDayOfMonth(AddDays(DateDoc, 120)), 10);

  END;
END;

FUNCTION TStdGinKoia.DateRgltID(DateDoc: TDateTime; CPAID: Integer): TDateTime;
BEGIN
  TRY
    Ibc_CdtPmt.Close;
    Ibc_CdtPmt.ParamByName('CPAID').asInteger := CPAID;
    Ibc_CdtPmt.Open;

    Result := DateRgltCODE(DateDoc, Ibc_CdtPmt.fieldByName('CPA_CODE').asInteger);
  FINALLY
    Ibc_CdtPmt.Close;
  END;
END;

FUNCTION TStdGinKoia.TexteFiltre(TS: TStrings; Chaine: STRING = ''): STRING;
VAR
  i,j : Integer;
  slItems : TStringList ;
BEGIN
  Result := '';
  slItems := TStringList.Create ;
  slItems.Text := TS.Text  ;

  if (Chaine <> '')
    then slItems.Add(Chaine) ;

  IF slItems.Count > 0 THEN
  BEGIN

    j := 0 ;
    for i := 0 to slItems.Count - 1 do
    begin
        Result := Result + slItems[i] ;
        Inc(j) ;


        if ((j > 2) or (i = slItems.Count - 1)) then
        begin
            Result := Result + #13#10 ;
            j := 0 ;
        end else begin
            Result := Result + ' - ' ;
        end ;
    end;
  END;

  slItems.Free ;
END;

FUNCTION TStdGinKoia.ModeImpressionDevFull(dxImp: TObject; Sens: Integer; VAR Direct, ChxImp: Boolean): Boolean;
VAR
  MaxPortrait, Maxi,
    i, j, k, ft: Integer;
  Lk: ARRAY[0..5] OF Integer;
  Shrink: Boolean;
BEGIN

  Result := False;
  IsAutoWidth := False;
  NeedRestit := False;
  K := 0;
  Maxi := 0;

  Direct := True;
  ChxImp := False;
  shrink := True;

  MaxPortrait := IniCtrl.ReadInteger('DEVMOD', 'PORTRAIT', 1035);

  i := IniCtrl.ReadInteger('DEVMOD', 'IMPDIRECT', 1);
  IF i = 0 THEN Direct := False;
  i := IniCtrl.ReadInteger('DEVMOD', 'CHOIXIMP', 0);

  IF i = 1 THEN ChxImp := True;

  FOR i := 0 TO 5 DO
    Lk[i] := 0;

  IF (DxImp IS TdxDbGridReportLink) THEN
  BEGIN
    k := 0;
    FOR j := 0 TO (DxImp AS TdxDbGridReportLink).DBGrid.VisibleColumnCount - 1 DO
    BEGIN
      LK[(DxImp AS TdxDbGridReportLink).DBGrid.VisibleColumns[j].RowIndex] :=
        LK[(DxImp AS TdxDbGridReportLink).DBGrid.VisibleColumns[j].RowIndex] +
        (DxImp AS TdxDbGridReportLink).DBGrid.VisibleColumns[j].Width;
    END;

    FOR i := 0 TO 5 DO
      IF Lk[i] > k THEN k := LK[i];

    IF k >= DimPerScreen(700) THEN
      sens := 1
    ELSE
      sens := 0;
  END;
  IF (DxImp IS TdxMasterviewReportLink) THEN Sens := 1;

  i := ChoixColImpFull(DevModImp, Sens, Direct, ChxImp, shrink);
  Delai(100);
  IF i = -1 THEN Exit;

  IF Direct THEN
    IniCtrl.WriteInteger('DEVMOD', 'IMPDIRECT', 1)
  ELSE
    IniCtrl.WriteInteger('DEVMOD', 'IMPDIRECT', 0);

  IF ChxImp THEN
    IniCTRL.WriteInteger('DEVMOD', 'CHOIXIMP', 1)
  ELSE
    IniCtrl.WriteInteger('DEVMOD', 'CHOIXIMP', 0);

  IF i = 1 THEN ChxImp := True;

  // Ici c'est simplement les valeurs pour le test ...
  CASE Sens OF
    0: maxi := DimPerScreen(700);
    1: maxi := DimPerScreen(MaxPortrait);
  END;

  ft := 10;

  Result := True;
  IF (DxImp IS TdxMasterViewReportLink) THEN
  BEGIN
    //        ((DxImp AS TdxMasterViewReportLink).Component AS TWinControl).refresh;
    (DxImp AS TdxMasterViewReportLink).SupportedCustomDraw := True;
    (DxImp AS TdxMasterViewReportLink).FixedTransParent := False;
    (DxImp AS TdxMasterViewReportLink).ShrinkToPageWidth := Shrink;

    (DxImp AS TdxMasterViewReportLink).GridLineColor := ClSilver;
    (DxImp AS TdxMasterViewReportLink).Options :=
      (DxImp AS TdxMasterViewReportLink).Options - [mvpoExpandButtons];

    // L'impression du masterview ne supporte pas la redéfinition en hard des fontes
    //      (DxImp as TdxMasterViewReportLink).EvenFont.size := ft;
    //      (DxImp as TdxMasterViewReportLink).FooterFont.size := ft;
    //      (DxImp as TdxMasterViewReportLink).GroupNodeFont.size := ft;
    //      (DxImp as TdxMasterViewReportLink).HeaderFont.size := ft;
    //      (DxImp as TdxMasterViewReportLink).OddFont.size := ft;
    //      (DxImp as TdxMasterViewReportLink).Font.size := ft;
    //      (DxImp as TdxMasterViewReportLink).Font.Name := 'Arial'; //'Times New Roman';
    //
    //      (DxImp as TdxMasterViewReportLink).Name := 'Arial';
    //      (DxImp as TdxMasterViewReportLink).FooterFont.Name := 'Arial';
    //      (DxImp as TdxMasterViewReportLink).GroupNodeFont.Name := 'Arial';
    //      (DxImp as TdxMasterViewReportLink).HeaderFont.Name := 'Arial';
    //      (DxImp as TdxMasterViewReportLink).OddFont.Name := 'Arial';
    //      (DxImp as TdxMasterViewReportLink).Font.Name := 'Arial';

    IF i <> DevModImp THEN
      DevModImp := i;
    CASE i OF
      0:
        BEGIN
          (DxImp AS TdxMasterViewReportLink).DrawMode := MvdmStrict;
          (DxImp AS TdxMasterViewReportLink).FixedTransParent := False;
        END;
      1: (DxImp AS TdxMasterViewReportLink).DrawMode := MvdmBorrowSource;
      2:
        BEGIN
          (DxImp AS TdxMasterViewReportLink).DrawMode := MvdmStrict;
          (DxImp AS TdxMasterViewReportLink).FixedTransParent := True;
        END;
    END; // du case
    CASE Sens OF
      0: (DxImp AS TdxMasterViewReportLink).PrinterPage.Orientation := PoPortrait;
      1: (DxImp AS TdxMasterViewReportLink).PrinterPage.Orientation := PoLandScape;
    END;
    (DxImp AS TdxMasterviewReportLink).PrinterPage.Margins.Top := 12700;
    (DxImp AS TdxMasterviewReportLink).PrinterPage.Margins.Bottom := 12700;
    (DxImp AS TdxMasterviewReportLink).PrinterPage.Margins.Left := 6350;
    (DxImp AS TdxMasterviewReportLink).PrinterPage.Margins.Right := 6350;
    (DxImp AS TdxMasterviewReportLink).PrinterPage.Header := 6350;
    (DxImp AS TdxMasterviewReportLink).PrinterPage.Footer := 6350;
  END
  ELSE
  BEGIN
    IF (DxImp IS TdxDBGridReportLink) THEN
    BEGIN
      (DxImp AS TdxDBGridReportLink).GridLineColor := ClSilver;
      (DxImp AS TdxDBGridReportLink).EvenFont.size := ft;
      (DxImp AS TdxDBGridReportLink).FooterFont.size := ft;
      (DxImp AS TdxDBGridReportLink).GroupNodeFont.size := ft;
      (DxImp AS TdxDBGridReportLink).HeaderFont.size := ft;
      (DxImp AS TdxDBGridReportLink).OddFont.size := ft;
      (DxImp AS TdxDBGridReportLink).RowFooterFont.size := ft;
      (DxImp AS TdxDBGridReportLink).Font.size := ft;
      (DxImp AS TdxDBGridReportLink).Options := (DxImp AS TdxDBGridReportLink).Options - [tlpoExpandButtons];

      (DxImp AS TdxDBGridReportLink).BandFont.Name := 'Arial';
      (DxImp AS TdxDBGridReportLink).EvenFont.Name := 'Arial';
      (DxImp AS TdxDBGridReportLink).FooterFont.Name := 'Arial';
      (DxImp AS TdxDBGridReportLink).GroupNodeFont.Name := 'Arial';
      (DxImp AS TdxDBGridReportLink).HeaderFont.Name := 'Arial';
      (DxImp AS TdxDBGridReportLink).OddFont.Name := 'Arial';
      (DxImp AS TdxDBGridReportLink).RowFooterFont.Name := 'Arial';
      (DxImp AS TdxDBGridReportLink).Font.Name := 'Arial';

      IF (k >= Maxi) THEN
      BEGIN
        IF NOT (egoAutowidth IN (DxImp AS TdxDbGridReportLink).DBGrid.Options) THEN IsAutoWidth := True;
        IF NOT (DxImp AS TdxDbGridReportLink).ShrinkToPageWidth THEN NeedRestit := True;
      END;

      IF Shrink = False THEN
        (DxImp AS TdxDbGridReportLink).ShrinkToPageWidth := k >= Maxi
      ELSE
        (DxImp AS TdxDbGridReportLink).ShrinkToPageWidth := Shrink;

      ((DxImp AS TdxDBGridReportLink).Component AS TWinControl).refresh;
      (DxImp AS TdxDBGridReportLink).FixedTransParent := False;
      IF i <> DevModImp THEN
        DevModImp := i;
      CASE i OF
        0: (DxImp AS TdxDBGridReportLink).DrawMode := tldmStrict;
        1: (DxImp AS TdxDBGridReportLink).DrawMode := tldmBorrowSource;
        2:
          BEGIN
            (DxImp AS TdxDBGridReportLink).DrawMode := tldmStrict;
            (DxImp AS TdxDBGridReportLink).FixedTransParent := True;
          END;
      END; // du case
      CASE Sens OF
        0: (DxImp AS TdxDBGridReportLink).PrinterPage.Orientation := PoPortrait;
        1: (DxImp AS TdxDBGridReportLink).PrinterPage.Orientation := PoLandscape;
      END;
      (DxImp AS TdxDBGridReportLink).PrinterPage.Margins.Top := 12700;
      (DxImp AS TdxDBGridReportLink).PrinterPage.Margins.Bottom := 12700;
      (DxImp AS TdxDBGridReportLink).PrinterPage.Margins.Left := 6350;
      (DxImp AS TdxDBGridReportLink).PrinterPage.Margins.Right := 6350;
    END
  END;
END;

FUNCTION TStdGinKoia.ImpDevDBG(dxImp: TObject; dxPrt: TObject; OffsetPolice: Integer = 1; BestFit: Boolean = False): Boolean;
VAR
  direct, choix: Boolean;
BEGIN

  Result := False;
  TRY
    IF (DxImp IS TdxDbGridReportLink) THEN
    BEGIN
      (DxImp AS TdxDbGridReportLink).DBGrid.BEGINUpdate;

      IF BestFit THEN (DxImp AS TdxDbGridReportLink).DBGrid.ApplyBestFit(NIL);

      IF (DxImp AS TdxDbGridReportLink).DBGrid.ShowBands = True THEN
        (DxImp AS TdxDbGridReportLink).Options := (DxImp AS TdxDbGridReportLink).Options + [tlpoBands]
      ELSE
        (DxImp AS TdxDbGridReportLink).Options := (DxImp AS TdxDbGridReportLink).Options - [tlpoBands];

      IF (DxImp AS TdxDbGridReportLink).DBGrid.ShowHeader = True THEN
        (DxImp AS TdxDbGridReportLink).Options := (DxImp AS TdxDbGridReportLink).Options + [tlpoHeaders]
      ELSE
        (DxImp AS TdxDbGridReportLink).Options := (DxImp AS TdxDbGridReportLink).Options - [tlpoHeaders];

      IF (DxImp AS TdxDbGridReportLink).DBGrid.ShowSummaryFooter = True THEN
        (DxImp AS TdxDbGridReportLink).Options := (DxImp AS TdxDbGridReportLink).Options + [tlpoFooters]
      ELSE
        (DxImp AS TdxDbGridReportLink).Options := (DxImp AS TdxDbGridReportLink).Options - [tlpoFooters];

      IF ((DxImp AS TdxDbGridReportLink).PrinterPage.PageHeader.LeftTitle.Text = '') AND
        ((DxImp AS TdxDbGridReportLink).PrinterPage.PageHeader.RightTitle.Text = '') AND
        ((DxImp AS TdxDbGridReportLink).PrinterPage.PageHeader.CenterTitle.Text = '') THEN
        (DxImp AS TdxDbGridReportLink).PrinterPage.Header := 0;

      IF ((DxImp AS TdxDbGridReportLink).PrinterPage.PageFooter.LeftTitle.Text = '') AND
        ((DxImp AS TdxDbGridReportLink).PrinterPage.PageFooter.RightTitle.Text = '') AND
        ((DxImp AS TdxDbGridReportLink).PrinterPage.PageFooter.CenterTitle.Text = '') THEN
        (DxImp AS TdxDbGridReportLink).PrinterPage.Footer := 0;
    END;
    IF (DxImp IS TdxMasterViewReportLink) THEN
    BEGIN

      IF ((DxImp AS TdxMasterViewReportLink).PrinterPage.PageHeader.LeftTitle.Text = '') AND
        ((DxImp AS TdxMasterViewReportLink).PrinterPage.PageHeader.RightTitle.Text = '') AND
        ((DxImp AS TdxMasterViewReportLink).PrinterPage.PageHeader.CenterTitle.Text = '') THEN
        (DxImp AS TdxMasterViewReportLink).PrinterPage.Header := 0;

      IF ((DxImp AS TdxMasterViewReportLink).PrinterPage.PageFooter.LeftTitle.Text = '') AND
        ((DxImp AS TdxMasterViewReportLink).PrinterPage.PageFooter.RightTitle.Text = '') AND
        ((DxImp AS TdxMasterViewReportLink).PrinterPage.PageFooter.CenterTitle.Text = '') THEN
        (DxImp AS TdxMasterViewReportLink).PrinterPage.Footer := 0;
    END;

    IF ModeImpressionDevFull(DxImp, 1, Direct, Choix) THEN
    BEGIN
      Result := True;
      IF NOT Direct THEN
      BEGIN
        IF (DxImp IS TdxDbGridReportLink) THEN
        BEGIN
          IF IsAutoWidth THEN (DxImp AS TdxDbGridReportLink).DBGrid.Options := (DxImp AS TdxDbGridReportLink).DBGrid.Options + [egoAutoWidth];
          (DxImp AS TdxDBGridReportLink).Preview(true);
        END;
        IF (DxImp IS TdxMasterViewReportLink) THEN
          (DxImp AS TdxMasterViewReportLink).Preview(true);
      END
      ELSE BEGIN
        TRY
          IF (DxImp IS TdxDbGridReportLink) THEN
          BEGIN
            IF IsAutoWidth THEN (DxImp AS TdxDbGridReportLink).DBGrid.Options := (DxImp AS TdxDbGridReportLink).DBGrid.Options + [egoAutoWidth];
            (DxPrt AS TDXComponentPrinter).Print(Choix, NIL, (DxImp AS TdxDBGridReportLink));
          END;
          IF (DxImp IS TdxMasterViewReportLink) THEN
            (DxPrt AS TDXComponentPrinter).Print(Choix, NIL, (DxImp AS TdxMasterViewReportLink));
        EXCEPT
        END;
      END;
    END;
  FINALLY
    IF (DxImp IS TdxDbGridReportLink) THEN
    BEGIN
      IF IsAutoWidth THEN (DxImp AS TdxDbGridReportLink).DBGrid.Options := (DxImp AS TdxDbGridReportLink).DBGrid.Options - [egoAutoWidth];
      IF NeedRestit THEN (DxImp AS TdxDbGridReportLink).ShrinkToPageWidth := False;
      (DxImp AS TdxDbGridReportLink).DBGrid.ENDUpdate;
    END;
  END;
END;

PROCEDURE TStdGinKoia.SetDevModImp(Value: Integer);
BEGIN
  FdevModImp := Value;
  IniCtrl.WriteInteger('DEVMOD', 'PSIMP', Value);
END;

PROCEDURE TStdGinKoia.SetCanConvert(Origine: STRING; Bloque: Boolean);
VAR
  i: Integer;
BEGIN
  Origine := Uppercase(Origine);

  IF Bloque THEN
  BEGIN
    IF Str_CanConvert.Strings.IndexOf(Origine) = -1 THEN
      Str_CanConvert.Strings.add(Origine);
  END
  ELSE
  BEGIN
    i := Str_CanConvert.Strings.IndexOf(Origine);
    IF i <> -1 THEN Str_CanConvert.Strings.Delete(i);
  END;
END;

FUNCTION TStdGinKoia.CanConvert(OkMess: Boolean): Boolean;
BEGIN
  Result := Str_CanConvert.Strings.Count = 0;
  IF (NOT Result) AND OkMess THEN
    WaitMessHP(NietConvert, 2, True, 0, 0, '');
END;

PROCEDURE TStdGinKoia.SetModifTTrav(Origine: STRING; Bloque: Boolean);
VAR
  i: Integer;
BEGIN
  Origine := Uppercase(Origine);

  IF Bloque THEN
  BEGIN
    IF Str_ModifTTrav.Strings.IndexOf(Origine) = -1 THEN
      Str_ModifTTrav.Strings.add(Origine);
  END
  ELSE
  BEGIN
    i := Str_ModifTTrav.Strings.IndexOf(Origine);
    IF i <> -1 THEN Str_ModifTTrav.Strings.Delete(i);
  END;
END;

FUNCTION TStdGinKoia.ModifTTrav(OkMess: Boolean): Boolean;
BEGIN
  Result := Str_ModifTTrav.Strings.Count = 0;
  IF (NOT Result) AND OkMess THEN
    WaitMessHP(NietModifTTrav, 2, True, 0, 0, '');
END;

FUNCTION TStdGinKoia.MyComputerName: STRING;
VAR
  lpBuffer: ARRAY[0..MAX_COMPUTERNAME_LENGTH] OF char;
  nSize: dword;
BEGIN
  nSize := Length(lpBuffer);
  IF GetComputerName(lpBuffer, nSize) THEN
    result := UpperCase(lpBuffer)
  ELSE
    result := '';
END;

FUNCTION TStdGinKoia.CanDeleteArt(OkMess: Boolean): Boolean;
BEGIN
  Result := Str_ModifTTrav.Strings.Count = 0;
  IF (NOT Result) AND OkMess THEN
    WaitMessHP(NietDeleteArt, 2, True, 0, 0, '');
END;

PROCEDURE TStdGinKoia.MajAutoData(Conteneur: TComponent; UserCanModif: Boolean);
VAR
  i: Integer;
  PropInfo: PPropInfo;
BEGIN
  FOR i := 0 TO Conteneur.ComponentCount - 1 DO
  BEGIN
    Propinfo := GetPropInfo(Conteneur.components[i], 'UserCanModify');
    IF propinfo <> NIL THEN
      IF UserCanModif THEN
        SetOrdProp(Conteneur.components[i], 'UserCanModify', 1)
      ELSE
        SetOrdProp(Conteneur.components[i], 'UserCanModify', 0);
  END;
END;

PROCEDURE TStdGinKoia.LoadIniFileFromDatabase;
VAR
  Ident, Machine, dt, Np, Nm, ch, chHT: STRING;
  MaxJetons, i, iNbJetons, posi: Integer;
  FCtrlJeton, fok: Boolean;
  d: TDateTime;
BEGIN
  // Remarque :
  // TVA, Univers et origine sont initialisés à l'ouverture toujours faite de la nomenclature
  // On n'a qu'une seule origine possible à la fois (correspond à la notion d'activité )
  // sur un poste donné bien entendu ...
  // Normalement 1 origine = un univers mais la porte est ouverte pour plusieurs univers
  // liés à la même origine

  fok := False;
  FCtrlJeton := False;

  // FC 02/03/09 : Ajouts pour imprimer par PDF sans envoyer par mail
  stdGinkoia.aPdfEmail.pdfbyemail := false;
  stdGinkoia.PrintToPdf.bActive := false;

  ch := PathBase;
  posi := Pos('\GINKOIA\', ch) + 8;
  IF (posi = 0) THEN
    posi := Pos('\DATA\', ch);
  ch := SubStr(ch, 1, posi);
  ch := ChemWin(ch);

  chHT := '';
  ChHT := GetStringParamValue('HT');
  IF ChHT = '' THEN
  BEGIN
    // ne vas lire l'ini que si pas trouvé dans base et en profite
    // pour initialier la base.
    // par défaut fonctionnement TTC car "0"
    ChHT := IniCtrl.ReadString('GESTION', 'HT', '0');
    PutStringParamValue('HT', chHT);
  END;
  IF chHT = '1' THEN
    FgestionHT := True
  ELSE
    FgestionHT := False;

  SageNbre := -1;

  chHT := '';
  ChHT := GetStringParamValue('GLOSSAIREHT');
  IF ChHT = '' THEN
  BEGIN
    chHT := '0';
    IF FGestionHT THEN ChHT := '1';
    PutStringParamValue('GLOSSAIREHT', chHT);
  END;
  IF chHT = '1' THEN
    FglossaireHT := True
  ELSE
    FglossaireHT := False;

  chHT := GetStringParamValue('GROUPEDIGITAL');
  IF ChHT = 'DIGITAL' THEN
    FDigital := True
  ELSE
    FDigital := False;

  chHT := GetStringParamValue('HISTO_DUREE');
  IF ChHT = '' THEN
    FHistoDur := 6
  ELSE
    FHistoDur := StrToInt(chHt);

  // comme j'en ai raz le cul de celle là ....
  TRY
    Que_CtrlK0.Open;
    IF que_CtrlK0.FieldByName('K_ENABLED').asInteger = 0 THEN
    BEGIN
      que_CtrlK0.EDIT;
      que_CtrlK0.FieldByName('K_ENABLED').asInteger := 1;
      que_CtrlK0.POST;
    END;
  FINALLY
    que_CtrlK0.Close;
  END;

  TRY
    FRepImg := ch + 'Images\';
    IF NOT directoryExists(FRepImg) THEN forcedirectories(FRepImg);

    FNonRefRepImg := ch + 'Images_nR\';
    IF NOT directoryExists(FNonRefRepImg) THEN forcedirectories(FNonRefRepImg);
    // Gestion des repertoires images : on les trouve à côté des Data, ce qui permet de les partager entre les != poste

  EXCEPT
  END;

  FRepImg := FormateStr('ASLASH', FrepImg);
  FNonRefRepImg := FormateStr('ASLASH', FNonRefRepImg);

  FdevModImp := IniCtrl.ReadInteger('DEVMOD', 'PSIMP', 0);

  // initialisation du paramétrage des étiquettes
  FImp_Laser := IniCtrl.readString('ETIQUETTE', 'IMP_LASER', '');
  IF (FImp_Laser = '') THEN
    IniCtrl.WriteString('ETIQUETTE', 'IMP_LASER', 'Laser');
  FImp_Eltron := IniCtrl.readString('ETIQUETTE', 'IMP_ELTRON', '');
  IF (FImp_Eltron = '') THEN
    IniCtrl.WriteString('ETIQUETTE', 'IMP_ELTRON', 'Eltron');
  IF IniCtrl.readString('ETIQUETTE', 'IMP_LASERPREVIEW', '') <> '' THEN
    FLaserPreview := StrToInt(IniCtrl.readString('ETIQUETTE', 'IMP_LASERPREVIEW', ''))
  ELSE
  BEGIN
    FLaserPreview := 0;
    IniCtrl.WriteString('ETIQUETTE', 'IMP_LASERPREVIEW', '0');
  END;
  IF IniCtrl.readString('ETIQUETTE', 'IMP_PRINTREVERSE', '') <> '' THEN
    FPrintReverse := StrToInt(IniCtrl.readString('ETIQUETTE', 'IMP_PRINTREVERSE', ''))
  ELSE
  BEGIN
    FPrintReverse := 0;
    IniCtrl.WriteString('ETIQUETTE', 'IMP_PRINTREVERSE', '0');
  END;
  // DEBUT -------------------- MODE ZPL ---------------------------------------
  IF IniCtrl.readString('ETIQUETTE', 'MODEZPL', '') <> '' THEN
    ModeZPL := StrToInt(IniCtrl.readString('ETIQUETTE', 'MODEZPL', ''))
  ELSE
  BEGIN
    ModeZPL := 0;
    IniCtrl.WriteString('ETIQUETTE', 'MODEZPL', '0');
  END;

  IF IniCtrl.readString('ETIQUETTE', 'DENSITE', '') <> '' THEN
     DENSITE := StrToInt(IniCtrl.readString('ETIQUETTE', 'DENSITE', ''))
  ELSE
  BEGIN
    DENSITE := 8;
    IniCtrl.WriteString('ETIQUETTE', 'DENSITE', '8');
  END;
  IF IniCtrl.readString('ETIQUETTE', 'VITESSE', '') <> '' THEN
     VITESSE := StrToInt(IniCtrl.readString('ETIQUETTE', 'VITESSE', ''))
  ELSE
  BEGIN
    VITESSE := 3;
    IniCtrl.WriteString('ETIQUETTE', 'VITESSE', '3');
  END;
  IF IniCtrl.readString('ETIQUETTE', 'WIDEBAR', '') <> '' THEN
     WideBar := StrToInt(IniCtrl.readString('ETIQUETTE', 'WIDEBAR', ''))
  ELSE
  BEGIN
    WideBar := 3;
    IniCtrl.WriteString('ETIQUETTE', 'WIDEBAR', '3');
  END;
  IF IniCtrl.readString('ETIQUETTE', 'INTERPRETATION_LINE', '') <> '' THEN
     Interpretation_line := StrToInt(IniCtrl.readString('ETIQUETTE', 'INTERPRETATION_LINE', ''))
  ELSE
  BEGIN
    Interpretation_line := 1;
    IniCtrl.WriteString('ETIQUETTE', 'INTERPRETATION_LINE', '1');
  END;
  // FIN -------------------- MODE ZPL -----------------------------------------
  IF IniCtrl.readString('ETIQUETTE', 'ETIK_FORMAT', '') <> '' THEN
    FEtik_Format := StrToInt(IniCtrl.readString('ETIQUETTE', 'ETIK_FORMAT', ''))
  ELSE
  BEGIN
    FEtik_Format := 0;
    IniCtrl.WriteString('ETIQUETTE', 'ETIK_FORMAT', '0');
  END;
  // on veut mémoriser si la dernière impression était de Laser ou de L'Eltron
  // car la suppression des étiquettes ne se gère pas au même momment
  // Laser (1) => juste àprès l'impression afin de pouvoir compter les étiquettes restante
  // Eltron (0) => juste avant le chargement des nouvelles étiquettes pour vider le buffer en cas de pb

//N'est plus géré...
////  if IniCtrl.readString('ETIQUETTE', 'DERNIERE_IMP', '') <> '' then
////      FDerImp := StrToInt(IniCtrl.readString('ETIQUETTE', 'DERNIERE_IMP', ''))
////   else
////   begin
////      FDerImp := 0;
////      IniCtrl.WriteString('ETIQUETTE', 'DERNIERE_IMP', '0');
////   end;

  //Idem précédent mais pour les etiquettes Clients
  IF IniCtrl.readString('ETIQUETTE', 'ETIK_FORMAT_CLT', '') <> '' THEN
    FEtik_Format_Clt := StrToInt(IniCtrl.readString('ETIQUETTE', 'ETIK_FORMAT_CLT', ''))
  ELSE
  BEGIN
    FEtik_Format_Clt := 0;
    IniCtrl.WriteString('ETIQUETTE', 'ETIK_FORMAT_CLT', '0');
  END;

  //Idem précédent mais pour les etiquettes location
  IF IniCtrl.readString('ETIQUETTE', 'ETIK_FORMAT_LOC', '') <> '' THEN
    FEtik_Format_Loc := StrToInt(IniCtrl.readString('ETIQUETTE', 'ETIK_FORMAT_LOC', ''))
  ELSE
  BEGIN
    FEtik_Format_Loc := 0;
    IniCtrl.WriteString('ETIQUETTE', 'ETIK_FORMAT_LOC', '0');
  END;

  //  IniCtrl_Jeton.NetUser := True;
  //  IniCtrl_Jeton.IniFile := ChemWinIni(ExtractFilePath(PathBase), 'Ressources.Ini');

    // Initialisation du nombre de jetons

  MaxJetons := 0;
  iNbJetons := 0;
  ident := '';

  IbC_ParamBase.Open;
  Ident := IbC_ParamBase.FieldByName('PAR_STRING').AsString;
  IbC_ParamBase.Close;

  IF Trim(ident) <> '' THEN
  BEGIN
    que_Jetons.paramByName('IDENT').asString := ident;
    Que_Jetons.Open;
    IF NOT que_Jetons.IsEmpty THEN
      MaxJetons := Que_Jetons.fieldByName('BAS_JETON').asInteger
    ELSE
    BEGIN
      que_Jetons.Insert;
      que_Jetons.FieldByName('BAS_IDENT').asString := Ident;
      que_Jetons.FieldByName('BAS_JETON').asInteger := 0;
      que_Jetons.FieldByName('BAS_NOM').asString := '';
      que_Jetons.Post;
    END;
    BaseId := que_Jetons.FieldByName('BAS_ID').AsInteger;
    BasCodeTiers := Que_jetons.FieldByName('BAS_CODETIERS').AsString;
    BasGuid := Que_Jetons.FieldByName('BAS_GUID').AsString;
    Que_Jetons.Close;

    IF MaxJetons < 0 THEN
    BEGIN
      DM_Main.Database.close;
      DM_Main.Database.Databasename := '';
      DM_Main.Database.Params.clear;
      RAISE EIB_Error.Create('Invalid server operation $FF01A1F7E824FFFF');
    END
    ELSE IF MaxJetons > 0 THEN
    BEGIN
      // on récup le nombre de jetons actifs
      iNbJetons := GetActiveJetons;
    END;
  END;

  IF iNbJetons >= MaxJetons THEN FCtrlJeton := True;

  FnomTvt := NomTVT;

  NP := NOMPOSTE;
  NM := NOMDUMAG;

  FPushURL := iniCtrl.readString('PUSH', 'URL', '');
  FPushUSER := iniCtrl.readString('PUSH', 'USERNAME', '');
  FPushPASS := iniCtrl.readString('PUSH', 'PASSWORD', '');

  IF (NOT FCtrlJeton) AND (Dm_Main <> NIL) AND
    (Trim(NP) <> '') AND (Trim(NM) <> '') THEN
  BEGIN
    // On prend un jeton
    Tim_JetonTimer(NIL);

    // vérifie qu'il y a bien un slash en fin de chemin
    Fok := True;

    Que_NbreMags.Open;
    FMM := Que_NbreMags.RecordCountAll;
    Que_NbreMags.Close;

    Que_Ini.ParamByName('NOMPOSTE').AsString := NP;
    Que_Ini.ParamByName('NOMMAG').AsString := NM;

    Que_Ini.Open;

    IF NOT Que_Ini.Eof THEN
    BEGIN


      FMagasinName := Que_Ini.FieldByName('MAG_NOM').AsString;
      FMagasinAdr := Que_Ini.FieldByName('ADR_LIGNE').AsString;
      FMagasinAdrVILLE := Que_Ini.FieldByName('VIL_NOM').AsString;
      FMagasinAdrCP := Que_Ini.FieldByName('VIL_CP').AsString;
      FMagasinAdrPAYS := Que_Ini.FieldByName('PAY_NOM').AsString;
      FMagEnseigne := Que_Ini.FieldByName('MAG_ENSEIGNE').AsString;
      FPosteName := Que_Ini.FieldByName('POS_NOM').AsString;

      FMagasinID := Que_Ini.FieldByName('MAG_ID').AsInteger;
      FTvtId := Que_Ini.FieldByName('MAG_TVTID').AsInteger;
      FPosteID := Que_Ini.FieldByName('POS_ID').AsInteger;
      FMtaId := Que_Ini.FieldByName('MAG_MTAID').AsInteger;
      FMagCodeAdherent := Que_Ini.FieldByName('MAG_CODEADH').AsString;
    END;
    Que_Ini.Close;
    ChargeDonneeSociete(FMagasinID);

    Que_Prefix.open;
    FPrefix := que_Prefix.FieldByName('PAR_STRING').asString;
    que_Prefix.close;

    IF FPrefix = '' THEN Fok := False;
    IF FSocieteID = 0 THEN Fok := False;

    IF FMagasinID = 0 THEN Fok := False;
    IF FPosteID = 0 THEN FOk := False;

    TRY
      // Récupération de l'Univers définie au niveau Dossier
      IbQ_Univers.open;
      IF NOT IbQ_Univers.Locate('UNI_NOM', GetStringParamValue('UNIVERS_REF'), []) THEN
      BEGIN
        IF NOT IbQ_Univers.Eof THEN
        BEGIN
          WaitMessHP(ParamsStr(INFUnivers, vararrayof([IbQ_Univers.FieldByName('UNI_NOM').asString, StdGinkoia.GetStringParamValue
            ('UNIVERS_REF')])), 2, True, 0, 0, '');
          Univers := IbQ_Univers.FieldByName('UNI_ID').asInteger;
          Origine := IbQ_Univers.FieldByName('UNI_ORIGINE').asInteger;
          NKLevel := IbQ_Univers.FieldByName('UNI_NIVEAU').asInteger;
          PutStringParamValue('UNIVERS_REF', IbQ_Univers.FieldByName('UNI_NOM').asString);
        END
        ELSE
        BEGIN
          InfoMessHP(ErrSansUnivers, True, 0, 0, '');
          Univers := 0;
          Origine := 0;
          NKLevel := 3;
        END;
      END
      ELSE
      BEGIN
        Univers := IbQ_Univers.FieldByName('UNI_ID').asInteger;
        Origine := IbQ_Univers.FieldByName('UNI_ORIGINE').asInteger;
        NKLevel := IbQ_Univers.FieldByName('UNI_NIVEAU').asInteger;
      END;

      // FC 02/03/2009 : Ajout d'un paramètre pour connaitre le type de dossier Web
      IF GetStringParamValue('WEB-CLEONET') = '2' THEN
        webType := webCleoNetCentrale
      ELSE IF GetStringParamValue('WEB-CLEONET') = '1' THEN
        webType := webCleoNetMag
      ELSE IF GetStringParamValue('WEB-ATIPIC') = '1' THEN
        webType := webATIPIC
      ELSE if GetStringParamValue('WEB-GENERIQUE') = '1' then
        webType := webGENERIQUE
      ELSE
        webType := webInactif;

      // Récupération de la TVA définie au niveau Dossier
      Que_TVA.open;
      IF Que_TVA.Locate('TVA_TAUX', GetFloatParamValue('TVA'), []) THEN
      BEGIN
        FDefTVATAUX := Que_TVA.FieldByName('TVA_TAUX').asString;
        FDefTVA := Que_TVA.FieldByName('TVA_ID').asInteger;
      END
      ELSE
      BEGIN
        FDefTVATAUX := ' ';
        FDefTVA := 0;
        InfoMessHP(ErrSansTVA, True, 0, 0, '');
      END;

      // Récupération des varaible pour dossier Sport 2000
      IbC_Ref_dynaSp2000.Close;
      IbC_Ref_dynaSp2000.Prepare;
      IbC_Ref_dynaSp2000.ParamByName('MAGID').asinteger := FMagasinID;
      IbC_Ref_dynaSp2000.open;
      Fref_dyna_sp2000 := (IbC_Ref_dynaSp2000.FieldByName('NB').asInteger = 1);
      IbC_Ref_dynaSp2000.Close;

      IbC_CATMAN.Close;
      IbC_CATMAN.Prepare;
      IbC_CATMAN.ParamByName('MAGID').asinteger := FMagasinID;
      IbC_CATMAN.open;
      Fcatman := (IbC_CATMAN.FieldByName('NB').asInteger = 1);
      IbC_CATMAN.Close;
    FINALLY
      IbQ_Univers.close;
      que_Tva.Close;
    END;
  END;

  // Initialisation du log monitoring.
  uLog.Log.Mag := IntToStr(FMagasinID);
  uLog.Log.Ref := FBasGuid;
  uLog.Log.Open;
  uLog.Log.SaveIni;
  uLog.Log.Log('Main', 'Version', GetNumVersionSoft, logInfo, True, -1, ltBoth);


  IF FCtrlJeton THEN
  BEGIN
    InfoMessHP(CtrlJetons, True, 0, 0, '');
    Application.Terminate;
  END
  ELSE
  BEGIN
    IF NOT Fok THEN
    BEGIN
      InfoMessHP(ErrLectINI, True, 0, 0, '');
      // ici message de problème de connection
      Application.Terminate;
    END;
  END;

  // Visu des mags multiSoc
  VisuMagSoc := True;
  TRY
    Que_AffSec.Close;
    Que_AffSec.ParamByName('TIP').asInteger := 3;
    Que_AffSec.ParamByName('COD').asInteger := 30;
    Que_AffSec.ParamByName('MAGID').asInteger := StdGinkoia.MagasinId;
    Que_AffSec.Open;
    IF Que_AffSec.eof THEN
    BEGIN
      Que_AffSec.Insert;
      IF NOT Dm_Main.IBOMajPkKey(Que_AffSec, 'PRM_ID') THEN
      BEGIN
        Que_AffSec.Cancel;
      END
      ELSE BEGIN
        Que_AffSecPRM_TYPE.asInteger := 3;
        Que_AffSecPRM_CODE.AsInteger := 30;
        Que_AffSecPRM_MAGID.AsInteger := MagasinId;

        Que_AffSecPRM_INFO.AsString := 'Affichage des mags si multisoc';
        Que_AffSecPRM_String.asstring := '';
        Que_AffSecPRM_FLOAT.asFloat := 0;
        Que_AffSecPRM_INTEGER.asInteger := 1;

        Que_AffSec.Post;
      END;
    END
    ELSE VisuMagSoc := que_AffSecPRM_INTEGER.asInteger = 1;
  FINALLY
    Que_AffSec.Close;
  END;

  FPseudoTO := 0;
  FTOTWINNER := 0;
  FDEBSAISLOC := '';
  FTOWEBACTIVE := False;
  FTOWEB := 0;
  DateSurJourneaux := true;

  TRY
    Que_ToLoc.Close;
    Que_ToLoc.Open;

    WHILE NOT que_TOLOC.eof DO
    BEGIN
      i := Que_TOLOCPRM_CODE.asInteger;
      CASE i OF
        92: FPseudoTO := que_ToLocPRM_INTEGER.asInteger;
        93: FTOTWINNER := que_ToLocPRM_INTEGER.asInteger;
        94: FDEBSAISLOC := que_ToLocPRM_String.asString;
        95:
          BEGIN
            FTOWEB := que_ToLocPRM_INTEGER.asInteger;
            FTOWEBACTIVE := que_ToLocPRM_FLOAT.asInteger = 1;
          END;
        199: BEGIN
            DateSurJourneaux := que_ToLocPRM_INTEGER.asInteger = 0;
          END;
      END;
      que_TOLOC.Next;
    END;
  FINALLY
    Que_ToLOC.Close;
  END;

  ClotureEnCaisse := 2; // par defaut au mois
  Que_Param.Close;
  Que_Param.ParamByName('MAGID').AsInteger := MagasinID;
  Que_Param.ParamByName('PRMCODE').AsInteger := 1100;
  Que_Param.ParamByName('PRMTYPE').AsInteger := 1000;
  Que_Param.Open;
  TRY
    IF Que_Param.IsEmpty THEN
      ClotureEnCaisse := 2 // par defaut au mois
    ELSE IF Que_ParamPRM_INTEGER.AsInteger = 0 THEN
      ClotureEnCaisse := 0 // au jour
    ELSE IF Que_ParamPRM_INTEGER.AsInteger = 1 THEN
      ClotureEnCaisse := 1 // A la semaine
    ELSE
      ClotureEnCaisse := 2; // par defaut au mois
  FINALLY
    Que_Param.Close;
  END;

  // Affichage des secteurs dans la nomenclature
  NkAffSecteurs := 0;
  TRY
    Que_AffSec.Close;
    Que_AffSec.ParamByName('TIP').asInteger := 3;
    Que_AffSec.ParamByName('COD').asInteger := 1;
    Que_AffSec.ParamByName('MAGID').asInteger := StdGinkoia.MagasinId;
    Que_AffSec.Open;
    IF Que_AffSec.eof THEN
    BEGIN
      Que_AffSec.Insert;
      IF NOT Dm_Main.IBOMajPkKey(Que_AffSec, 'PRM_ID') THEN
      BEGIN
        Que_AffSec.Cancel;
      END
      ELSE BEGIN
        Que_AffSecPRM_TYPE.asInteger := 3;
        Que_AffSecPRM_CODE.AsInteger := 1;
        Que_AffSecPRM_MAGID.AsInteger := MagasinId;

        Que_AffSecPRM_INFO.AsString := 'Affichage secteurs dans nomenclature';
        Que_AffSecPRM_String.asstring := '';
        Que_AffSecPRM_FLOAT.asFloat := 0;
        Que_AffSecPRM_INTEGER.asInteger := 0;

        Que_AffSec.Post;
      END;
    END
    ELSE NkAffSecteurs := que_AffSecPRM_INTEGER.asInteger;
  FINALLY
    Que_AffSec.Close;
  END;

  i := Que_Ville.Sql.indexof('/*BALISE1*/') + 1;
  WHILE i < Que_Ville.Sql.Count DO
    Que_Ville.Sql.delete(i);
  Que_Ville.sql.Add('WHERE VIL_NOM STARTING :Ville');
  //    Que_Ville.sql.Add('PLAN SORT (JOIN ( GENVILLE INDEX (INX_GENVILNOM),GENPAYS INDEX (INX_GENPAYID),K INDEX (K_1)))');
  Que_Ville.sql.Add('Order By VIL_CP, VIL_NOM');
  Que_Ville.ParamByName('Ville').AsString := 'VA';
  Que_Ville.Close;
  Que_Ville.Open;

  TRY
    ibc_IdTvtWeb.Close;
    ibc_IdTvtWeb.Open;
    FidTvtWeb := ibc_IdTvtWeb.Fields[0].asInteger;
    //lab 15/07/08 Fidelite nationale twinner
    IbC_FidNatTwin.Close;
    IbC_FidNatTwin.parambyname('magid').asinteger := MagasinID;
    IbC_FidNatTwin.Open;
    FFidNatTwinner := (IbC_FidNatTwin.Fields[0].AsInteger = 1);
    FFidNatUrl := IbC_FidNatTwin.Fields[1].asstring;
  FINALLY
    IF FidTvtWeb = 0 THEN FidTvtWeb := -1;
    ibc_IdTvtWeb.Close;
    //lab 15/07/08 Fidelite nationale twinner
    IbC_FidNatTwin.close;
  END;

  SetCurrentUserId; // met idcurrentuser

  FMaxiDbgDev := 30000;
END;

procedure TStdGinKoia.ChargeDonneeSociete(magid : integer);
begin
  Que_AdresseSOCIETE.close;
  Que_AdresseSOCIETE.ParamByName('magid').asinteger := magid;
  Que_AdresseSOCIETE.Open;
  IF NOT Que_AdresseSOCIETE.Eof THEN
  begin
    FSocieteCapital := Que_AdresseSOCIETE.FieldByName('SOC_CAPITAL').AsString;
    FSocieteID := Que_AdresseSOCIETE.FieldByName('SOC_ID').AsInteger;
    FSocieteName := Que_AdresseSOCIETE.FieldByName('SOC_NOM').AsString;
    FSocieteADR := false;
    if Que_AdresseSOCIETE.FieldByName('SOC_ADRID').AsInteger <> 0 then
    begin
      FSocieteADR := ((Que_AdresseSOCIETE.FieldByName('ADR_VILID').AsInteger <> 0)
                  and (Que_AdresseSOCIETE.FieldByName('ADR_LIGNE').AsString <> ''));
    end;
  end;
end;

// renvoie true si la date du document n'est pas dans un exe comptable cloturé
function TStdGinKoia.CtrlExerciceComptable(AMagID: integer; ADateACtrl: TDatetime): boolean;
var
  QueTmp: TIBOQuery;
begin
  Result := true;   
  QueTmp := TIBOQuery.Create(Self);
  try
    QueTmp.IB_Connection := Dm_Main.Database;
    QueTmp.IB_Transaction := Dm_Main.IbT_HorsK;

    QueTmp.Close;
    QueTmp.SQL.Clear;
    QueTmp.SQL.Add('select EXC_DEBUT, EXC_FIN, EXC_CLOTURE');
    QueTmp.SQL.Add('  from GENEXERCICECOMPTABLE');
    QueTmp.SQL.Add('  JOIN K ON (K_ID=EXC_ID AND K_ENABLED=1)');
    QueTmp.SQL.Add('  join GENSOCIETE on SOC_ID=EXC_SOCID');
    QueTmp.SQL.Add('  join genmagasin on MAG_SOCID=SOC_ID');
    QueTmp.SQL.Add(' where exc_id<>0');
    QueTmp.SQL.Add('   and cast(EXC_DEBUT as DATE)<='+QuotedStr(FormatDateTime('mm/dd/yyyy', ADateACtrl)));
    QueTmp.SQL.Add('   and cast(EXC_FIN as DATE)>='+QuotedStr(FormatDateTime('mm/dd/yyyy', ADateACtrl)));
    QueTmp.SQL.Add('   and EXC_CLOTURE=1');
    QueTmp.SQL.Add('   and mag_id='+inttostr(AMagID));
    QueTmp.Open;
    QueTmp.First;
    if not(QueTmp.Eof) then
      Result := false;

    QueTmp.Close;
  finally
    QueTmp.Close;
    FreeAndNil(QueTmp);
  end;
end;

PROCEDURE TStdGinKoia.CtrlIfIsSuper;
BEGIN
  SetCurrentUserId; // met idcurrentuser
END;

PROCEDURE TStdGinKoia.InitJetons;
BEGIN
  Tim_JetonTimer(NIL);
  Tim_Jeton.Enabled := True;
END;

FUNCTION TStdGinKoia.ResteEtiquette: Integer;
BEGIN
  //   if (FDerImp = 1) then
  //   begin
  Que_EtikPro.Close;
  Que_EtikPro.ParamByName('POSID').asinteger := PosteID;
  Que_EtikPro.Open;
  IF Que_EtikPro.EOF THEN
  BEGIN
    IF (FEtik <> 1) THEN
      Result := 0
    ELSE Result := -1
  END
  ELSE
    Result := Que_EtikPro.RecordCount;
  Que_EtikPro.Close;
  //   end
  //   else Result := 0;
END;

FUNCTION TStdGinKoia.GetStringParamValue(ParamName: STRING): STRING;
BEGIN
  IbC_GetParamDossier.Close;
  IbC_GetParamDossier.Prepare;
  IbC_GetParamDossier.ParamByName('PARAM_NAME').AsString := ParamName;
  IbC_GetParamDossier.Open;
  Result := IbC_GetParamDossier.FieldByName('DOS_STRING').AsString;
END;

FUNCTION TStdGinKoia.GetFloatParamValue(ParamName: STRING): double;
BEGIN
  IbC_GetParamDossier.Close;
  IbC_GetParamDossier.Prepare;
  IbC_GetParamDossier.ParamByName('PARAM_NAME').AsString := ParamName;
  IbC_GetParamDossier.Open;
  Result := IbC_GetParamDossier.FieldByName('DOS_FLOAT').AsFloat;
END;

PROCEDURE TStdGinKoia.PutStringParamValue(ParamName, Val: STRING);
BEGIN
  Que_PutParamDos.Close;
  Que_PutParamDos.ParamByName('DOSNOM').AsString := ParamName;
  Que_PutParamDos.Open;
  IF NOT Que_PutParamDos.Eof THEN
  BEGIN
    Que_PutParamDos.Edit;
    Que_PutParamDos.FieldByName('DOS_STRING').asString := Val;
    Que_PutParamDos.Post;
  END
  ELSE
  BEGIN
    Que_PutParamDos.insert;
    Que_PutParamDos.FieldByName('DOS_NOM').asString := UPPERCASE(ParamName);
    Que_PutParamDos.FieldByName('DOS_STRING').asString := Val;
    Que_PutParamDos.FieldByName('DOS_FLOAT').asFloat := 0;
    Que_PutParamDos.Post;
  END;
  Que_PutParamDos.Close;
END;

PROCEDURE TStdGinKoia.PutFloatParamValue(ParamName: STRING; Val: Extended);
BEGIN
  Que_PutParamDos.Close;
  Que_PutParamDos.ParamByName('DOSNOM').AsString := ParamName;
  Que_PutParamDos.Open;
  IF NOT Que_PutParamDos.Eof THEN
  BEGIN
    Que_PutParamDos.Edit;
    Que_PutParamDos.FieldByName('DOS_FLOAT').asFloat := Val;
    Que_PutParamDos.Post;
  END
  ELSE
  BEGIN
    Que_PutParamDos.insert;
    Que_PutParamDos.FieldByName('DOS_NOM').asString := UPPERCASE(ParamName);
    Que_PutParamDos.FieldByName('DOS_FLOAT').asFloat := Val;
    Que_PutParamDos.FieldByName('DOS_STRING').asString := '';
    Que_PutParamDos.Post;
  END;
  Que_PutParamDos.Close;
END;

PROCEDURE TStdGinKoia.InitConvertor;
BEGIN
  Convertor.DefaultMnyRef :=
    Convertor.GetTMYTYP(GetStringParamValue('MONNAIE_REFERENCE'));
  Convertor.DefaultMnyTgt :=
    Convertor.GetTMYTYP(GetStringParamValue('MONNAIE_CIBLE'));
  Convertor.ReInit;

  // Après le passage à l'euro changer le sens des monnaies
  IF GetStringParamValue('MONNAIE_REFERENCE') = 'EUR' THEN
  BEGIN
    ConvertorEtik.DefaultMnyTgt :=
      ConvertorEtik.GetTMYTYP(GetStringParamValue('MONNAIE_REFERENCE'));
    ConvertorEtik.DefaultMnyRef :=
      ConvertorEtik.GetTMYTYP(GetStringParamValue('MONNAIE_CIBLE'));
  END
  ELSE
  BEGIN
    ConvertorEtik.DefaultMnyRef :=
      ConvertorEtik.GetTMYTYP(GetStringParamValue('MONNAIE_REFERENCE'));
    ConvertorEtik.DefaultMnyTgt :=
      ConvertorEtik.GetTMYTYP(GetStringParamValue('MONNAIE_CIBLE'));
  END;

  ConvertorEtik.ReInit;

END;

PROCEDURE TStdGinKoia.ReInitConvertor;
BEGIN
  Convertor.ReInit;
END;

FUNCTION TStdGinKoia.Convert(Value: Extended): STRING;
BEGIN
  Result := Convertor.Convert(Value);
END;

FUNCTION TStdGinKoia.ConvertBlank(Value: Extended): STRING;
BEGIN
  Result := Convertor.Convert(Value);
  IF strToFloatTry(Result) = 0 THEN Result := '';
END;

FUNCTION TStdGinKoia.ConvertEtik(Value: Extended): STRING;
BEGIN
  Result := ConvertorEtik.Convert(Value);
END;

FUNCTION TStdGinKoia.GetDefaultMnyRef: TMYTYP;
BEGIN
  Result := Convertor.DefaultMnyRef;
END;

FUNCTION TStdGinKoia.GetDefaultMnyTgt: TMYTYP;
BEGIN
  Result := Convertor.DefaultMnyTgt;
END;

FUNCTION TStdGinKoia.GetISO(Mny: TMYTYP): STRING;
BEGIN
  Result := Convertor.GetISO(Mny);
END;

FUNCTION TStdGinKoia.GetTMYTYP(ISO: STRING): TMYTYP;
BEGIN
  Result := Convertor.GetTMYTYP(ISO);
END;

PROCEDURE TStdGinKoia.Que_IniAfterPost(DataSet: TDataSet);
BEGIN
  Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TStdGinKoia.Que_IniBeforeDelete(DataSet: TDataSet);
BEGIN
  IF NOT Dm_Main.CheckAllowDelete((DataSet AS TIBODataSet).KeyRelation,
    DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
    True) THEN Abort;
END;

PROCEDURE TStdGinKoia.Que_IniBeforeEdit(DataSet: TDataSet);
BEGIN
  IF NOT Dm_Main.CheckAllowEdit((DataSet AS TIBODataSet).KeyRelation,
    DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
    True) THEN Abort;
END;

PROCEDURE TStdGinKoia.Que_IniNewRecord(DataSet: TDataSet);
BEGIN
  IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
    (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;
END;

PROCEDURE TStdGinKoia.Que_IniUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
  Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
    (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TStdGinkoia.FilterColor(Panel: TrzPanel; Filtered: Boolean);
BEGIN
  IF NOT Filtered THEN
    Panel.ParentColor := True
  ELSE
  BEGIN
    Panel.ParentColor := False;
    Panel.Color := $00B7FFFF;
  END;
END;

PROCEDURE TStdGinKoia.Que_PutParamDosAfterPost(DataSet: TDataSet);
BEGIN
  Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TStdGinKoia.Que_PutParamDosBeforeDelete(DataSet: TDataSet);
BEGIN
  IF NOT Dm_Main.CheckAllowDelete((DataSet AS TIBODataSet).KeyRelation,
    DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
    True) THEN Abort;
END;

PROCEDURE TStdGinKoia.Que_PutParamDosBeforeEdit(DataSet: TDataSet);
BEGIN
  IF NOT Dm_Main.CheckAllowEdit((DataSet AS TIBODataSet).KeyRelation,
    DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
    True) THEN Abort;
END;

PROCEDURE TStdGinKoia.Que_PutParamDosNewRecord(DataSet: TDataSet);
BEGIN
  IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
    (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;
END;

PROCEDURE TStdGinKoia.Que_PutParamDosUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
  Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
    (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TStdGinKoia.Tim_JetonTimer(Sender: TObject);
VAR
  ch: STRING;
BEGIN
  TRY
    //    ch := DatetimeToStr(Now);
    //    IniCtrl_Jeton.WriteString('POSTES', MyComputerName, ch);
    WriteJeton;
  EXCEPT
  END;
END;

PROCEDURE TStdGinKoia.Que_JetonsAfterPost(DataSet: TDataSet);
BEGIN
  Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TStdGinKoia.Que_JetonsNewRecord(DataSet: TDataSet);
BEGIN
  IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
    (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;

END;

PROCEDURE TStdGinKoia.Que_JetonsUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
  Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
    (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TStdGinKoia.DataModuleCreate(Sender: TObject);
BEGIN
  StopErrorMess := False;
  FISWEBParamOK := False;
  PanFocus := NIL;
  Frm_VPCP := NIL;
  fLaFormActive := NIL;
  ConstDoInit;
  { ConstDoInit initialise
         - nom et path init (PathAppli\NomAppli.Ini)
         - path application
         - nom fichier et path help (PathAppli\Help)
         - connecte le composant IniCtrl au fichier INI
         - initialise les Tips (charge PathAppli\NomAppli.Tip)
         - initialise les propriétés de la forme }

  Application.HelpFile := '';
  // Lorsque le fichier Help existe, supprimer cette ligne

  { A rajouter ici toute la gestion propre du fichier ini de démarrage
    Le Dm_main s'occupe de sa partie
    Nota : si on veut utiliser un autre fichier ini que celui par défaut
    il suffit d'écraser ici avec son code perso ... }

  FIdTvtWeb := -1;
  FEtik := 0;
  FDefTVATaux := '';
  FAffsec := 0;
  FDefTVA := 0;
  RefreshListCatalog := False;
  RefreshListArt := False;
  FDefMajTarRecep := True;
  FDefCollec := True;
  FIdDefCollec := 0;
  FIsXP := GetIsXP;

  LesBitMap := TstringList.Create;
END;

PROCEDURE TStdGinKoia.DataModuleDestroy(Sender: TObject);
VAR
  i: integer;
BEGIN
  FOR i := 0 TO LesBitMap.count - 1 DO
    TMemoryStream(LesBitMap.Objects[i]).free;
  LesBitMap.Free;
  IF Frm_VPCP <> NIL THEN VilleClose;
  //    If FPushProv <> Nil Then
  //       FPushPROV.Free;
  //    If FPullProv <> Nil Then
  //       FPullPROV.Free;
END;

PROCEDURE TStdGinKoia.CancelOnCache(Dset: TDataset; VAR VariantMem);
// VariantMem doit ici être un array of variant déclaré dans le module appelant
VAR
  i: Integer;
BEGIN
  IF High(TarVariant(VariantMem)) <> (Dset.FieldCount - 1) THEN
    Dset.Cancel
  ELSE
  BEGIN
    FOR i := 0 TO Dset.FieldCount - 1 DO
      Dset.Fields[i].Value := TarVariant(VariantMem)[i];
    Dset.Post;
  END;
  setlength(TarVariant(VariantMem), 0);
END;

procedure TStdGinKoia.Sablier(bActif: Boolean);
begin
  if bActif then
  begin
    Screen.Cursor := crSQLWait;
  end
  else begin
    Screen.Cursor := crDefault;
  end;
end;

PROCEDURE TStdGinKoia.SauveOnCache(Dset: TDataset; VAR VariantMem);
// VariantMem doit ici être un array of variant déclaré dans le module appelant
VAR
  i: Integer;
BEGIN

  setlength(TarVariant(VariantMem), Dset.FieldCount);
  FOR i := 0 TO Dset.FieldCount - 1 DO
    TarVariant(VariantMem)[i] := Dset.Fields[i].Value;

END;

FUNCTION TStdGinKoia.Liste_Table_Par_Id(Id: STRING): TstringList;
BEGIN
  IF Pos('_', Id) > 0 THEN
    delete(id, 1, Pos('_', Id));

  Que_RechTable.Close;
  Que_RechTable.Sql.Clear;
  Que_RechTable.Sql.ADD('Select A.rdb$field_Name ChpRef, B.rdb$field_Name Champs, A.RDB$Relation_Name Tables');
  Que_RechTable.Sql.ADD('  from rdb$relation_fields A join rdb$relation_fields B on (');
  Que_RechTable.Sql.ADD('  A.RDB$Relation_Name=B.RDB$Relation_Name and B.rdb$field_position=0)');
  Que_RechTable.Sql.ADD(' where A.rdb$field_Name like ''%/_' + Uppercase(ID) + '%'' escape ''/'' ');
  Que_RechTable.Sql.ADD(' order by B.RDB$Relation_Name');
  result := tstringList.create;
  Que_RechTable.Open;
  WHILE NOT Que_RechTable.Eof DO
  BEGIN
    result.add(Que_RechTable.Fields[2].AsString + ';' + Que_RechTable.Fields[0].AsString + ';' + Que_RechTable.Fields[1].AsString);
    Que_RechTable.Next;
  END;
  Que_RechTable.Close;

END;

FUNCTION TStdGinKoia.ID_EXISTE(Champs: STRING; Id: Integer; Excepter: ARRAY OF CONST): Boolean;
VAR
  Tsl: TstringList;
  j: Integer;
  i: integer;
  s: STRING;
  Table: STRING;
  ref, Chps: STRING;
  Afaire: Boolean;
BEGIN
  result := false;
  IF Id = 0 THEN
    Result := True // ne peut pas supprimer Id 0 (raccourci)
  ELSE BEGIN
    tsl := Liste_Table_Par_Id(Champs);
    TRY
      FOR i := 0 TO tsl.count - 1 DO
      BEGIN
        S := tsl[i];
        table := Copy(s, 1, Pos(';', s) - 1);
        delete(s, 1, pos(';', s));
        ref := Copy(s, 1, Pos(';', s) - 1);
        Chps := copy(S, Pos(';', s) + 1, 255);
        Afaire := true;
        FOR j := 0 TO high(Excepter) DO
        BEGIN
          S := '';
          CASE Excepter[j].VType OF
            vtString: S := Excepter[j].Vstring^;
            VtPChar: S := StrPas(Excepter[j].VPchar);
            vtAnsiString: S := ansiString(Excepter[j].VAnsiString);
          END;
          IF uppercase(Table) = uppercase(S) THEN
          BEGIN
            Afaire := False;
            break;
          END;
        END;

        IF Afaire THEN
        BEGIN
          Que_RechTable.Close;
          Que_RechTable.sql.clear;
          Que_RechTable.sql.add('Select Count(*)');
          Que_RechTable.sql.add('  From ' + Table);
          Que_RechTable.sql.add('  JOIN K ON (K_ID=' + Chps + ' AND K_ENABLED=1)');
          Que_RechTable.sql.add('  Where ' + ref + ' = ' + Inttostr(Id));

          Que_RechTable.Open;
          TRY
            IF Que_RechTable.fields[0].AsInteger > 0 THEN
            BEGIN
              result := true;
              break;
            END;
          FINALLY
            Que_RechTable.Close;
          END;
        END;
      END;
    FINALLY
      tsl.clear;
    END;
  END;
END;

PROCEDURE TStdGinKoia.ChgExerciceCommercial;
BEGIN
  Que_ExeCom.Close;
  LK_ExeCom.Execute;
  Que_ExeCom.Open;
END;

PROCEDURE TStdGinKoia.Que_ExeComAfterPost(DataSet: TDataSet);
BEGIN
  Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TStdGinKoia.Que_ExeComBeforeDelete(DataSet: TDataSet);
BEGIN
  IF NOT Dm_Main.CheckAllowDelete((DataSet AS TIBODataSet).KeyRelation,
    DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
    True) THEN Abort;
END;

PROCEDURE TStdGinKoia.Que_ExeComBeforeEdit(DataSet: TDataSet);
BEGIN
  IF NOT Dm_Main.CheckAllowEdit((DataSet AS TIBODataSet).KeyRelation,
    DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
    True) THEN Abort;
END;

PROCEDURE TStdGinKoia.Que_ExeComNewRecord(DataSet: TDataSet);
BEGIN
  IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
    (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;
END;

PROCEDURE TStdGinKoia.Que_ExeComUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
  Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
    (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TStdGinKoia.Que_ExeComEXE_DEBUTValidate(Sender: TField);
BEGIN
  Que_ExeCom.FieldByname('EXE_FIN').asDateTime := AddYears(Que_ExeCom.FieldByname('EXE_DEBUT').asDateTime, 1) - 1;
  IF (StrToInt(FormatDateTime('mm', Que_ExeCom.FieldByname('EXE_DEBUT').asDateTime)) > 07) THEN
    Que_ExeCom.FieldByname('EXE_ANNEE').asInteger := StrToInt(FormatDateTime('yyyy', Que_ExeCom.FieldByname('EXE_FIN').AsDateTime))
  ELSE
    Que_ExeCom.FieldByname('EXE_ANNEE').asInteger := StrToInt(FormatDateTime('yyyy', Que_ExeCom.FieldByname('EXE_DEBUT').AsDateTime)
      );
END;

PROCEDURE TStdGinKoia.DlgChpMemo(DS: TDatasource; Champ, Titre: STRING; Value: STRING = '');
VAR
  flag: Boolean;
  ch: STRING;
BEGIN
  Flag := (NOT (ds.State IN [dsInsert, dsEdit])) AND (NOT ds.Autoedit);
  IF ds.dataset.fieldByName(Champ).ReadOnly THEN Flag := True;

  IF Value <> '' THEN
    ch := Value
  ELSE
    ch := ds.dataset.fieldByName(Champ).asstring;

  IF ExecuteDlgMemo(Titre, Flag, ds.dataset.fieldByName(Champ).Size, ch) THEN
  BEGIN
    Delai(100);
    IF (NOT (ds.State IN [dsInsert, dsEdit])) AND
      (NOT ds.dataset.fieldByName(Champ).ReadOnly) THEN
    BEGIN
      IF ds.Dataset.IsEmpty THEN
        ds.Dataset.Insert
      ELSE
        ds.Dataset.Edit;
      ds.dataset.fieldByName(Champ).asString := ch;
    END;
  END;

END;

PROCEDURE TStdGinKoia.DlgMemoRv(VAR Chp: TdxDbMemoRv; Titre: STRING; GotoNextOnOk: Boolean = True);
VAR
  Ro: Boolean;
  Ladim: Integer;
  ch: STRING;
  key: Word;
BEGIN
  Ro := (NOT (Chp.datasource.State IN [dsInsert, dsEdit])) AND (NOT Chp.datasource.Autoedit);
  IF Chp.datasource.dataset.fieldByName(chp.Datafield).ReadOnly THEN Ro := True;
  Ladim := Chp.datasource.dataset.fieldByName(chp.Datafield).Size;
  ch := chp.Text;
  Key := VK_RETURN;

  IF ExecuteDlgMemo(Titre, Ro, ladim, ch) THEN
  BEGIN
    Delai(100);
    IF NOT RO THEN
    BEGIN
      IF chp.RTrimOnExit THEN
        ch := TrimRight(ch);
      IF Chp.datasource.dataset.IsEmpty THEN
        Chp.datasource.Dataset.Insert
      ELSE
        Chp.datasource.Dataset.Edit;
      Chp.datasource.dataset.fieldByName(chp.Datafield).asString := ch;
      Chp.Selstart := Length(ch);
      IF gotoNextOnOk THEN
        chp.KeyDown(Key, [ssCtrl]);
    END;
  END;

END;

PROCEDURE TStdGinKoia.DlgMemoRv(VAR Chp: TwwDBEditRv; Titre: STRING; GotoNextOnOk: Boolean = True; ForceReadOnly : boolean = false);
VAR
  Ro: Boolean;
  Ladim: Integer;
  ch: STRING;
  key: Word;
BEGIN
  Ro := (NOT (Chp.datasource.State IN [dsInsert, dsEdit])) AND (NOT Chp.datasource.Autoedit);
  if Chp.datasource.dataset.fieldByName(chp.Datafield).ReadOnly or ForceReadOnly then
    Ro := True;
  Ladim := Chp.datasource.dataset.fieldByName(chp.Datafield).Size;
  ch := chp.Text;
  Key := VK_RETURN;

  IF ExecuteDlgMemo(Titre, Ro, ladim, ch) THEN
  BEGIN
    Delai(100);
    IF NOT RO THEN
    BEGIN
      IF Chp.datasource.dataset.IsEmpty THEN
        Chp.datasource.Dataset.Insert
      ELSE
        Chp.datasource.Dataset.Edit;
      Chp.datasource.dataset.fieldByName(chp.Datafield).asString := ch;
      Chp.Selstart := Length(ch);
      IF gotoNextOnOk THEN
        chp.KeyDown(Key, [ssCtrl]);
    END;
  END;

END;

PROCEDURE TStdGinKoia.PrintTS(Caption: STRING; TS: TStrings);
VAR
  Mts: TStrings;
BEGIN
  Mts := TStringList.Create;
  TRY
    Mts.Assign(TS);
    IF Trim(Caption) <> '' THEN
    BEGIN
      MTs.Insert(0, '');
      MTs.Insert(0, Caption);
      MTs.Insert(0, '');
      MTs.Insert(0, '');
      MTs.Insert(0, '');
    END
    ELSE
    BEGIN
      MTs.Insert(0, '');
      MTs.Insert(0, '');
      MTs.Insert(0, '');
    END;

    PrtT_memo.PrintText(MTS.Text);
  FINALLY
    Mts.Free;
  END;
END;

//***********************************************************************************************************
// P.R. : 09/04/2002 : @@15 : Ajout de IsId pour permètre la recherche sur l'id sans test
//***********************************************************************************************************

FUNCTION TStdGinKoia.RechArt(Rech: STRING; DoMess: Boolean; Collection, FouId: Integer; Gros, Catalog, Virtuel, Archive: Boolean; VAR IsCB:
  Boolean; Qry: TIBOQuery; IsID: Integer = 0; RechPlus: Boolean = True): Integer;
VAR
  rc, cas         : Integer;
  i, FlagTag      : Integer;
  Merdignan       : STRING;
  DejaAcceWeb     : Boolean;
  Rech_Origine    : STRING;
  old_sql         : STRING;
  IdBaseRef       : Integer;   //Id de la base de référencement choisir
  iRechPartielle  : Integer;   // Indique si une recherche partielle a été effectuée
BEGIN
  IdBaseRef := 0; // Initialisation
  Rech_Origine := Rech;
  flagTag := Qry.Tag;
  DejaAcceWeb := false;
  // met le tag à 1 pour signaler rech en cours et éventuellement
  // shunter le after scroll dans l'unité appelante ...
  // pour par exemple éviter les sautillements d'écran !
  IsCb := False;
  Result := -1;
  Cas := -1;
  iRechPartielle := 0;
  IF Trim(rech) = '' THEN EXIT;
  rech := StringReplace(TrimRight(Rech), '''', '''''', [rfReplaceAll]);

  TRY
    screen.cursor := crSQLWait;
    qry.DisableControls;
    qry.Tag := 1;
    TRY
      IF IsId = 1 THEN
        Cas := 4
      ELSE
      BEGIN
        IF Trim(Rech) = '*' THEN
          cas := 3
        ELSE
        BEGIN
          IF (IsId <> 2) AND IsInteger(Rech, length(Rech)) THEN
          BEGIN
            Ibc_CtrlId.close;
            Ibc_CtrlId.paramByName('ARTID').asInteger := StrToInt(Rech);
            Ibc_CtrlId.Open;
            IF NOT Ibc_CtrlId.eof THEN cas := 4;
          END;

          IF cas = -1 THEN
          BEGIN
            Ibc_CtrlChrono.close;
            old_sql := Ibc_CtrlChrono.sql.text;
            IF NOT Catalog THEN Ibc_CtrlChrono.SQL.Add('AND ARF_CATALOG=0');
            IF NOT Virtuel THEN Ibc_CtrlChrono.SQL.Add('AND ARF_VIRTUEL=0');
            IF NOT Archive THEN Ibc_CtrlChrono.SQL.Add('AND ARF_ARCHIVER=0');

            Ibc_CtrlChrono.paramByName('Lechrono').asstring := Rech;
            Ibc_CtrlChrono.Open;
            rc := Ibc_CtrlChrono.RecordCount;

            // Vérifie si le résultat de la recherche a été partiellement trouvé 
            if Ibc_CtrlChrono.FindField('RECH_PARTIELLE') <> nil then
              iRechPartielle := Ibc_CtrlChrono.FieldByName('RECH_PARTIELLE').AsInteger
            else
              iRechPartielle := 0;

            IF rc = 1 THEN
            BEGIN
              Cas := 4;
              Rech := Ibc_CtrlChronoART_ID.asString;
            END
            ELSE IF rc > 1 THEN Cas := 1;
            Ibc_CtrlChrono.close;
            Ibc_CtrlChrono.sql.text := old_sql;
          END;
          // TEST  de vérification du code barre
          IF CAS = -1 THEN
          BEGIN
            IbC_CtrlCB.close;
            IbC_CtrlCB.ParamByName('RECH').asString := Rech;
            IbC_CtrlCB.Open;
            IF IbC_CtrlCB.fields[0].AsInteger > 0 THEN
              cas := 0;
            IbC_CtrlCB.close;
          END;
          IF Cas = -1 THEN
          BEGIN
            Merdignan := ControleSage(Rech);
            IF Merdignan <> Rech THEN
            BEGIN
              Ibc_CtrlSage.Close;
              Ibc_CtrlSage.paramByName('RECH').asstring := Merdignan;
              Ibc_CtrlSage.Open;
              IF Ibc_CtrlSage.Fields[0].asInteger > 0 THEN
              BEGIN
                Rech := Merdignan;
                cas := 0
              END;
              Ibc_CtrlSage.Close;
            END;
            // Test si le référencement dynamique est activé
            IF (Cas = -1) AND ((Dm_UIL.HasPermissionVisu(UILModif_FicheArt) AND Dm_UIL.HasPermissionVisu(UILRefDynGinFichArt) AND (StdGinkoia.GetParamInteger(54, 5, StdGinkoia.MagasinID, StdGinkoia.PosteID)=1)) OR (Dm_Uil.HasPermissionModule(ModulWebDyna) AND WebRechArtok)) THEN
            BEGIN
              //Demande si on veut faire la recherche sur la centrale
              IF OuiNon('', RefRech_Confirmation, false) THEN
              BEGIN
                IdBaseRef := ChoixRefDyn;
              END;

              //Traite l'ancien référencement
              IF (IdBaseRef<0) THEN
              BEGIN
                domess := false;
                DejaAcceWeb := true;
                IF fouid <> 0 THEN
                  i := ExecWebRechArt(rech, true, fouid)
                ELSE
                  i := ExecWebRechArt(rech, false, 0);
                IF i <> -1 THEN
                BEGIN
                  Cas     := 1;
                END;
              END;

              //Traite le nouveau référencement
              IF (IdBaseRef>0) THEN
              BEGIN
                Cas     := -2;    //Evite le case
                Result  := 3;     //Traitement de référencement
              END;
            END;
            IF (Cas = -1) THEN
            BEGIN
              i := Pos('-', Rech);
              IF (IsInteger(Rech, 0)) OR ((i > 0) AND (i < 4)) THEN
              BEGIN
                IF RechPlus AND OuiNon('', RechSurNom, True) THEN
                  Cas := 2
                ELSE BEGIN
                  Result := 0;
                  DoMess := False;
                END;
              END
              ELSE Cas := 2;
            END;
          END;
        END;
      END;

      CASE Cas OF
        0: // Cbarre
          BEGIN
            Qry.Close;
            Qry.SQL.Clear;
            QRY.SQL.Add('Select * FROM RECHART_CB(:PCB,:PFOUID,:PCOLID,:PCATALOG,:PVIRTUEL,:PARCHIVER)');
            QRY.ParamCheck := True;
            QRY.ParamByName('PCB').AsString := Rech;
            IF (NOT gros) AND (FOUID > 0) THEN
              QRY.ParamByName('PFOUID').AsInteger := FOUID
            else
              QRY.ParamByName('PFOUID').AsInteger := 0;
            if Collection > 0 then
              QRY.ParamByName('PCOLID').AsInteger := Collection
            else
              QRY.ParamByName('PCOLID').AsInteger := 0;

            case Catalog of
              FALSE: QRY.ParamByName('PCATALOG').AsInteger := 0;
              TRUE:  QRY.ParamByName('PCATALOG').AsInteger := 1;
            end;

            case Virtuel of
              FALSE: QRY.ParamByName('PVIRTUEL').AsInteger := 0;
              TRUE: QRY.ParamByName('PVIRTUEL').AsInteger := 1;
            end;

            Case Archive Of
              FALSE: QRY.ParamByName('PARCHIVER').AsInteger := 0;
              TRUE:  QRY.ParamByName('PARCHIVER').AsInteger := 1;
            End;

            Qry.Open;
            Result := RecUnique(Qry AS TDataset);
            IF Result = 1 THEN IsCb := True;

// 06/09/2012 -> Ancienne Version
//            Qry.SQL.Add(
//              'SELECT CBI_ID, CBI_TGFID, CBI_COUID, ARF_ID, ART_ID, ART_NOM, ART_REFMRK, ARF_CHRONO,' +
//              'TGF_NOM, COU_NOM, ARF_DIMENSION, GRE_NOM, SSF_NOM');
//            Qry.SQL.Add('FROM ARTCODEBARRE');
//            Qry.SQL.Add('JOIN K ON (K_ID=CBI_ID AND K_ENABLED=1)');
//            Qry.SQL.Add('JOIN ARTREFERENCE ON (ARF_ID=CBI_ARFID)');
//            Qry.SQL.Add('JOIN K ON (K_ID=ARF_ARTID AND K_ENABLED=1)');
//            Qry.SQL.Add('JOIN ARTARTICLE ON (ART_ID=ARF_ARTID)');
//            Qry.SQL.Add('JOIN ARTGENRE on (GRE_ID=ART_GREID)');
//            Qry.SQL.Add('join ARTRELATIONAXE ON ARX_ARTID=ART_ID');
//            Qry.SQL.Add('JOIN NKLSSFAMILLE ON SSF_ID=ARX_SSFID');
//            Qry.SQL.Add('JOIN NKLFAMILLE on FAM_ID=SSF_FAMID');
//            Qry.SQL.Add('JOIN NKLRAYON  ON RAY_ID=FAM_RAYID');
//            Qry.SQL.Add('JOIN NKLSECTEUR ON SEC_ID=RAY_SECID');
//            Qry.SQL.Add('join NKLUNIVERS ON UNI_ID=SEC_UNIID');
//            Qry.SQL.Add('join NKLACTIVITE on ACT_ID=ART_ACTID and ACT_UNIID=UNI_ID');

//            IF (NOT gros) AND (FOUID > 0) THEN
//            BEGIN
//              Qry.SQL.Add('JOIN ARTMRKFOURN ON (FMK_FOUID =' + IntToStr(Fouid) + ' AND FMK_MRKID=ART_MRKID)');
//              Qry.SQL.Add('JOIN K ON (K_ID=FMK_ID AND K_ENABLED = 1)');
//            END;
//
//            IF Collection > 0 THEN
//            BEGIN
//              Qry.SQL.Add('JOIN ARTCOLART ON (CAR_ARTID=ART_ID AND CAR_COLID=' + IntToStr(Collection) + ')');
//              Qry.SQL.Add('JOIN K ON (K_ID=CAR_ID AND K_ENABLED = 1)');
//            END;
//
//            Qry.SQL.Add('JOIN PLXCOULEUR ON (COU_ID=CBI_COUID)');
//            Qry.SQL.Add('JOIN PLXTAILLESGF ON (TGF_ID=CBI_TGFID)');
//            Qry.SQL.Add('WHERE CBI_CB=:RECH');
//            IF NOT Catalog THEN Qry.SQL.Add('AND ARF_CATALOG=0');
//            IF NOT Virtuel THEN Qry.SQL.Add('AND ARF_VIRTUEL=0');
//            IF NOT Archive THEN Qry.SQL.Add('AND ARF_ARCHIVER=0');
//
//            Qry.ParamByName('RECH').asString := Rech;
//            Qry.Open;
//            Result := RecUnique(Qry AS TDataset);
//            IF Result = 1 THEN IsCb := True;
          END;

        1: // Chrono   & ref en égalité stricte
          BEGIN
            Qry.Close;
            Qry.SQL.Clear;
            // MODERECH = 0 (Recherche sur le chrono et la RefMrk)
            QRY.SQL.Add('Select * FROM RECHART_STR(:PRECH,:PFOUID,:PCOLID,:PCATALOG,:PVIRTUEL,:PARCHIVER,0)');
            QRY.ParamCheck := True;
            QRY.ParamByName('PRECH').AsString := Rech;
            IF (NOT gros) AND (FOUID > 0) THEN
              QRY.ParamByName('PFOUID').AsInteger := FOUID
            else
              QRY.ParamByName('PFOUID').AsInteger := 0;
            if Collection > 0 then
              QRY.ParamByName('PCOLID').AsInteger := Collection
            else
              QRY.ParamByName('PCOLID').AsInteger := 0;

            case Catalog of
              FALSE: QRY.ParamByName('PCATALOG').AsInteger := 0;
              TRUE:  QRY.ParamByName('PCATALOG').AsInteger := 1;
            end;

            case Virtuel of
              FALSE: QRY.ParamByName('PVIRTUEL').AsInteger := 0;
              TRUE: QRY.ParamByName('PVIRTUEL').AsInteger := 1;
            end;

            Case Archive Of
              FALSE: QRY.ParamByName('PARCHIVER').AsInteger := 0;
              TRUE:  QRY.ParamByName('PARCHIVER').AsInteger := 1;
            End;

            Qry.Open;

//            Qry.SQL.Add('SELECT LARECH.ARF_ID, LARECH.ART_ID, LARECH.ART_NOM, LARECH.ART_REFMRK, LARECH.ARF_CHRONO, LARECH.ARF_DIMENSION, GRE_NOM, SSF_NOM');
//            Qry.SQL.Add('FROM PR_RECHARTCHRONO (:RECH) LARECH ');
//            Qry.SQL.Add('     JOIN ARTGENRE on (GRE_ID=LARECH.ART_GREID)');
//            Qry.SQL.Add('     JOIN NKLSSFAMILLE on (SSF_ID=LARECH.ART_SSFID)');
//
//            IF (NOT gros) AND (FOUID > 0) THEN
//            BEGIN
//              Qry.SQL.Add('JOIN ARTMRKFOURN ON (FMK_FOUID =' + IntToStr(Fouid) + ' AND FMK_MRKID=LARECH.ART_MRKID)');
//              Qry.SQL.Add('JOIN K ON (K_ID=FMK_ID AND K_ENABLED = 1)');
//            END;
//
//            IF Collection > 0 THEN
//            BEGIN
//              Qry.SQL.Add('JOIN ARTCOLART ON (CAR_ARTID=LARECH.ART_ID AND CAR_COLID=' + IntToStr(Collection) + ')');
//              Qry.SQL.Add('JOIN K ON (K_ID=CAR_ID AND K_ENABLED = 1)');
//            END;
//
//            Qry.SQL.Add('Where LARECH.ART_ID<>0');
//            IF NOT Catalog THEN Qry.SQL.Add('AND LARECH.ARF_CATALOG=0');
//            IF NOT Virtuel THEN Qry.SQL.Add('AND LARECH.ARF_VIRTUEL=0');
//            IF NOT Archive THEN Qry.SQL.Add('AND LARECH.ARF_ARCHIVER=0');
//
//            Qry.SQL.Add('ORDER BY LARECH.ARF_CHRONO');
//            Qry.ParamByName('RECH').asString := Rech;
//            Qry.Open;
            Result := RecUnique(Qry AS TDataset);
            IF (result = 0) AND (fouid <> 0) AND (NOT (DejaAcceWeb)) AND (Dm_Uil.HasPermissionModule(ModulWebDyna)) THEN
            BEGIN
              domess := false;
              i := ExecWebRechArt(rech_origine, true, fouid);
              IF i <> -1 THEN
              BEGIN
                rech := Inttostr(i);
                Qry.Close;
                Qry.SQL.Clear;
                QRY.SQL.Add('Select * FROM RECHART_ARTID(:PARTID,:PFOUID,:PCOLID,:PCATALOG,:PVIRTUEL,:PARCHIVER)');
                QRY.ParamCheck := True;
                QRY.ParamByName('PARTID').AsString := Rech;
                IF (NOT gros) AND (FOUID > 0) THEN
                  QRY.ParamByName('PFOUID').AsInteger := FOUID
                else
                  QRY.ParamByName('PFOUID').AsInteger := 0;
                if Collection > 0 then
                  QRY.ParamByName('PCOLID').AsInteger := Collection
                else
                  QRY.ParamByName('PCOLID').AsInteger := 0;

                case Catalog of
                  FALSE: QRY.ParamByName('PCATALOG').AsInteger := 0;
                  TRUE:  QRY.ParamByName('PCATALOG').AsInteger := 1;
                end;

                case Virtuel of
                  FALSE: QRY.ParamByName('PVIRTUEL').AsInteger := 0;
                  TRUE: QRY.ParamByName('PVIRTUEL').AsInteger := 1;
                end;

                Case Archive Of
                  FALSE: QRY.ParamByName('PARCHIVER').AsInteger := 0;
                  TRUE:  QRY.ParamByName('PARCHIVER').AsInteger := 1;
                End;

                Qry.Open;

//                Qry.SQL.Add('SELECT ARF_ID, ART_ID, ART_NOM, ART_REFMRK, ARF_CHRONO, ARF_DIMENSION, GRE_NOM, SSF_NOM');
//                Qry.SQL.Add('FROM ARTARTICLE');
//                Qry.SQL.Add('JOIN K ON (K_ID=ART_ID AND K_ENABLED=1)');
//                Qry.SQL.Add('JOIN ARTGENRE on (GRE_ID=ART_GREID)');
//                Qry.SQL.Add('join ARTRELATIONAXE ON ARX_ARTID=ART_ID');
//                Qry.SQL.Add('JOIN NKLSSFAMILLE ON SSF_ID=ARX_SSFID');
//                Qry.SQL.Add('JOIN NKLFAMILLE on FAM_ID=SSF_FAMID');
//                Qry.SQL.Add('JOIN NKLRAYON  ON RAY_ID=FAM_RAYID');
//                Qry.SQL.Add('JOIN NKLSECTEUR ON SEC_ID=RAY_SECID');
//                Qry.SQL.Add('join NKLUNIVERS ON UNI_ID=SEC_UNIID');
//                Qry.SQL.Add('join NKLACTIVITE on ACT_ID=ART_ACTID and ACT_UNIID=UNI_ID');
//                IF (NOT gros) AND (FOUID > 0) THEN
//                BEGIN
//                  Qry.SQL.Add('JOIN ARTMRKFOURN ON (FMK_FOUID =' + IntToStr(Fouid) + ' AND FMK_MRKID=ART_MRKID)');
//                  Qry.SQL.Add('JOIN K ON (K_ID=FMK_ID AND K_ENABLED = 1)');
//                END;
//                IF Collection > 0 THEN
//                BEGIN
//                  Qry.SQL.Add('JOIN ARTCOLART ON (CAR_ARTID=ART_ID AND CAR_COLID=' + IntToStr(Collection) + ')');
//                  Qry.SQL.Add('JOIN K ON (K_ID=CAR_ID AND K_ENABLED = 1)');
//                END;
//                Qry.SQL.Add('JOIN ARTREFERENCE ON (ARF_ARTID=ART_ID)');
//                Qry.SQL.Add('WHERE ART_ID=:RECH');
//                IF NOT Catalog THEN Qry.SQL.Add('AND ARF_CATALOG=0');
//                IF NOT Virtuel THEN Qry.SQL.Add('AND ARF_VIRTUEL=0');
//                IF NOT Archive THEN Qry.SQL.Add('AND ARF_ARCHIVER=0');
//                Qry.SQL.Add('ORDER BY ARF_CHRONO');
//                Qry.ParamByName('RECH').asString := Rech;
//                Qry.Open;
                Result := RecUnique(Qry AS TDataset);
              END;
            END;
          END;

        2: // Nom & Ref
          BEGIN
            Qry.Close;
            Qry.SQL.Clear;
            // MODERECH = 1 (recherche sur le nom et la désignation d'un article)
            QRY.SQL.Add('Select * FROM RECHART_STR(:PRECH,:PFOUID,:PCOLID,:PCATALOG,:PVIRTUEL,:PARCHIVER,1)');
            QRY.ParamCheck := True;
            QRY.ParamByName('PRECH').AsString := Rech;
            IF (NOT gros) AND (FOUID > 0) THEN
              QRY.ParamByName('PFOUID').AsInteger := FOUID
            else
              QRY.ParamByName('PFOUID').AsInteger := 0;
            if Collection > 0 then
              QRY.ParamByName('PCOLID').AsInteger := Collection
            else
              QRY.ParamByName('PCOLID').AsInteger := 0;

            case Catalog of
              FALSE: QRY.ParamByName('PCATALOG').AsInteger := 0;
              TRUE:  QRY.ParamByName('PCATALOG').AsInteger := 1;
            end;

            case Virtuel of
              FALSE: QRY.ParamByName('PVIRTUEL').AsInteger := 0;
              TRUE: QRY.ParamByName('PVIRTUEL').AsInteger := 1;
            end;

            Case Archive Of
              FALSE: QRY.ParamByName('PARCHIVER').AsInteger := 0;
              TRUE:  QRY.ParamByName('PARCHIVER').AsInteger := 1;
            End;

            Qry.Open;

//            Qry.SQL.Add('SELECT ARF_ID, ART_ID, ART_NOM, ART_REFMRK, ARF_CHRONO, ARF_DIMENSION, GRE_NOM, SSF_NOM');
//            Qry.SQL.Add('FROM ARTARTICLE');
//            Qry.SQL.Add('JOIN K ON (K_ID=ART_ID AND K_ENABLED=1)');
//            Qry.SQL.Add('JOIN ARTREFERENCE ON (ARF_ARTID=ART_ID)');
//            Qry.SQL.Add('JOIN ARTGENRE on (GRE_ID=ART_GREID)');
//            Qry.SQL.Add('join ARTRELATIONAXE ON ARX_ARTID=ART_ID');
//            Qry.SQL.Add('JOIN NKLSSFAMILLE ON SSF_ID=ARX_SSFID');
//            Qry.SQL.Add('JOIN NKLFAMILLE on FAM_ID=SSF_FAMID');
//            Qry.SQL.Add('JOIN NKLRAYON  ON RAY_ID=FAM_RAYID');
//            Qry.SQL.Add('JOIN NKLSECTEUR ON SEC_ID=RAY_SECID');
//            Qry.SQL.Add('join NKLUNIVERS ON UNI_ID=SEC_UNIID');
//            Qry.SQL.Add('join NKLACTIVITE on ACT_ID=ART_ACTID and ACT_UNIID=UNI_ID');
//
//            IF (NOT gros) AND (FOUID > 0) THEN
//            BEGIN
//              Qry.SQL.Add('JOIN ARTMRKFOURN ON (FMK_FOUID =' + IntToStr(Fouid) + ' AND FMK_MRKID=ART_MRKID)');
//              Qry.SQL.Add('JOIN K ON (K_ID=FMK_ID AND K_ENABLED = 1)');
//            END;
//
//            IF Collection > 0 THEN
//            BEGIN
//              Qry.SQL.Add('JOIN ARTCOLART ON (CAR_ARTID=ART_ID AND CAR_COLID=' + IntToStr(Collection) + ')');
//              Qry.SQL.Add('JOIN K ON (K_ID=CAR_ID AND K_ENABLED = 1)');
//            END;
//
//            Qry.SQL.Add('WHERE ((ART_NOM CONTAINING :RECH) OR (ART_DESCRIPTION CONTAINING :RECH) OR (ART_REFMRK CONTAINING :RECH))');
//            IF NOT Catalog THEN Qry.SQL.Add('AND ARF_CATALOG=0');
//            IF NOT Virtuel THEN Qry.SQL.Add('AND ARF_VIRTUEL=0');
//            IF NOT Archive THEN Qry.SQL.Add('AND ARF_ARCHIVER=0');
//
//            Qry.SQL.Add('ORDER BY ARF_CHRONO');
//            Qry.ParamByName('RECH').asString := Rech;
//            Qry.Open;
            Result := RecUnique(Qry AS TDataset);
          END;
        3: //  *
          BEGIN
            Qry.Close;
            Qry.SQL.Clear;
            // MODERECH = 2 (Recherche tous les articles)
            QRY.SQL.Add('Select * FROM RECHART_STR(:PRECH,:PFOUID,:PCOLID,:PCATALOG,:PVIRTUEL,:PARCHIVER,2)');
            QRY.ParamCheck := True;
            QRY.ParamByName('PRECH').AsString := Rech;
            IF (NOT gros) AND (FOUID > 0) THEN
              QRY.ParamByName('PFOUID').AsInteger := FOUID
            else
              QRY.ParamByName('PFOUID').AsInteger := 0;
            if Collection > 0 then
              QRY.ParamByName('PCOLID').AsInteger := Collection
            else
              QRY.ParamByName('PCOLID').AsInteger := 0;

            case Catalog of
              FALSE: QRY.ParamByName('PCATALOG').AsInteger := 0;
              TRUE:  QRY.ParamByName('PCATALOG').AsInteger := 1;
            end;

            case Virtuel of
              FALSE: QRY.ParamByName('PVIRTUEL').AsInteger := 0;
              TRUE: QRY.ParamByName('PVIRTUEL').AsInteger := 1;
            end;

            Case Archive Of
              FALSE: QRY.ParamByName('PARCHIVER').AsInteger := 0;
              TRUE:  QRY.ParamByName('PARCHIVER').AsInteger := 1;
            End;

            Qry.Open;

//            Qry.SQL.Add('SELECT ARF_ID, ART_ID, ART_NOM, ART_REFMRK, ARF_CHRONO, ARF_DIMENSION, GRE_NOM, SSF_NOM');
//            Qry.SQL.Add('FROM ARTARTICLE');
//            Qry.SQL.Add('JOIN K ON (K_ID=ART_ID AND K_ENABLED=1)');
//            Qry.SQL.Add('JOIN ARTGENRE on (GRE_ID=ART_GREID)');
//
//            Qry.SQL.Add('join ARTRELATIONAXE ON ARX_ARTID=ART_ID');
//            Qry.SQL.Add('JOIN NKLSSFAMILLE ON SSF_ID=ARX_SSFID');
//            Qry.SQL.Add('JOIN NKLFAMILLE on FAM_ID=SSF_FAMID');
//            Qry.SQL.Add('JOIN NKLRAYON  ON RAY_ID=FAM_RAYID');
//            Qry.SQL.Add('JOIN NKLSECTEUR ON SEC_ID=RAY_SECID');
//            Qry.SQL.Add('join NKLUNIVERS ON UNI_ID=SEC_UNIID');
//            Qry.SQL.Add('join NKLACTIVITE on ACT_ID=ART_ACTID and ACT_UNIID=UNI_ID');
//
//            IF (NOT gros) AND (FOUID > 0) THEN
//            BEGIN
//              Qry.SQL.Add('JOIN ARTMRKFOURN ON (FMK_FOUID =' + IntToStr(Fouid) + ' AND FMK_MRKID=ART_MRKID)');
//              Qry.SQL.Add('JOIN K ON (K_ID=FMK_ID AND K_ENABLED = 1)');
//            END;
//
//            IF Collection > 0 THEN
//            BEGIN
//              Qry.SQL.Add('JOIN ARTCOLART ON (CAR_ARTID=ART_ID AND CAR_COLID=' + IntToStr(Collection) + ')');
//              Qry.SQL.Add('JOIN K ON (K_ID=CAR_ID AND K_ENABLED = 1)');
//            END;
//
//            Qry.SQL.Add('JOIN ARTREFERENCE ON (ARF_ARTID=ART_ID)');
//            Qry.SQL.Add('WHERE ART_ID<>0');
//            IF NOT Catalog THEN Qry.SQL.Add('AND ARF_CATALOG=0');
//            IF NOT Virtuel THEN Qry.SQL.Add('AND ARF_VIRTUEL=0');
//            IF NOT Archive THEN Qry.SQL.Add('AND ARF_ARCHIVER=0');
//
//            Qry.SQL.Add('ORDER BY ARF_CHRONO');
//            Qry.Open;
            Result := RecUnique(Qry AS TDataset);
          END;
        4: // IdART
          BEGIN
            Qry.Close;
            Qry.SQL.Clear;
            QRY.SQL.Add('Select * FROM RECHART_ARTID(:PARTID,:PFOUID,:PCOLID,:PCATALOG,:PVIRTUEL,:PARCHIVER)');
            QRY.ParamCheck := True;
            QRY.ParamByName('PARTID').AsInteger := StrToInt(Rech);
            IF (NOT gros) AND (FOUID > 0) THEN
              QRY.ParamByName('PFOUID').AsInteger := FOUID
            else
              QRY.ParamByName('PFOUID').AsInteger := 0;
            if Collection > 0 then
              QRY.ParamByName('PCOLID').AsInteger := Collection
            else
              QRY.ParamByName('PCOLID').AsInteger := 0;

            case Catalog of
              FALSE: QRY.ParamByName('PCATALOG').AsInteger := 0;
              TRUE:  QRY.ParamByName('PCATALOG').AsInteger := 1;
            end;

            case Virtuel of
              FALSE: QRY.ParamByName('PVIRTUEL').AsInteger := 0;
              TRUE: QRY.ParamByName('PVIRTUEL').AsInteger := 1;
            end;

            Case Archive Of
              FALSE: QRY.ParamByName('PARCHIVER').AsInteger := 0;
              TRUE:  QRY.ParamByName('PARCHIVER').AsInteger := 1;
            End;

            Qry.Open;
            Result := RecUnique(Qry AS TDataset);

// 07/09/2012 ancien fonctionnement
//            Qry.SQL.Add('SELECT ARF_ID, ART_ID, ART_NOM, ART_REFMRK, ARF_CHRONO, ARF_DIMENSION, GRE_NOM, SSF_NOM');
//            Qry.SQL.Add('FROM ARTARTICLE');
//            Qry.SQL.Add('JOIN K ON (K_ID=ART_ID AND K_ENABLED=1)');
//            Qry.SQL.Add('JOIN ARTGENRE on (GRE_ID=ART_GREID)');
//
//            Qry.SQL.Add('join ARTRELATIONAXE ON ARX_ARTID=ART_ID');
//            Qry.SQL.Add('JOIN NKLSSFAMILLE ON SSF_ID=ARX_SSFID');
//            Qry.SQL.Add('JOIN NKLFAMILLE on FAM_ID=SSF_FAMID');
//            Qry.SQL.Add('JOIN NKLRAYON  ON RAY_ID=FAM_RAYID');
//            Qry.SQL.Add('JOIN NKLSECTEUR ON SEC_ID=RAY_SECID');
//            Qry.SQL.Add('join NKLUNIVERS ON UNI_ID=SEC_UNIID');
//            Qry.SQL.Add('join NKLACTIVITE on ACT_ID=ART_ACTID and ACT_UNIID=UNI_ID');
//
//            IF (NOT gros) AND (FOUID > 0) THEN
//            BEGIN
//              Qry.SQL.Add('JOIN ARTMRKFOURN ON (FMK_FOUID =' + IntToStr(Fouid) + ' AND FMK_MRKID=ART_MRKID)');
//              Qry.SQL.Add('JOIN K ON (K_ID=FMK_ID AND K_ENABLED = 1)');
//            END;
//
//            IF Collection > 0 THEN
//            BEGIN
//              Qry.SQL.Add('JOIN ARTCOLART ON (CAR_ARTID=ART_ID AND CAR_COLID=' + IntToStr(Collection) + ')');
//              Qry.SQL.Add('JOIN K ON (K_ID=CAR_ID AND K_ENABLED = 1)');
//            END;
//
//            Qry.SQL.Add('JOIN ARTREFERENCE ON (ARF_ARTID=ART_ID)');
//            Qry.SQL.Add('WHERE ART_ID=:RECH');
//            IF NOT Catalog THEN Qry.SQL.Add('AND ARF_CATALOG=0');
//            IF NOT Virtuel THEN Qry.SQL.Add('AND ARF_VIRTUEL=0');
//            IF NOT Archive THEN Qry.SQL.Add('AND ARF_ARCHIVER=0');
//
//            Qry.SQL.Add('ORDER BY ARF_CHRONO');
//            Qry.ParamByName('RECH').asString := Rech;
//            Qry.Open;
//            Result := RecUnique(Qry AS TDataset);
            IF (result = 0) AND (fouid <> 0) AND (NOT (DejaAcceWeb)) AND (Dm_Uil.HasPermissionModule(ModulWebDyna)) AND RechPlus THEN
            BEGIN
              domess := false;
              i := ExecWebRechArt(rech_origine, true, fouid);
              IF i <> -1 THEN
              BEGIN
                rech := Inttostr(i);
                Qry.Close;
                Qry.SQL.Clear;
                QRY.SQL.Add('Select * FROM RECHART_ARTID(:PARTID,:PFOUID,:PCOLID,:PCATALOG,:PVIRTUEL,:PARCHIVER)');
                QRY.ParamCheck := True;
                QRY.ParamByName('PARTID').AsInteger := StrToInt(Rech);
                IF (NOT gros) AND (FOUID > 0) THEN
                  QRY.ParamByName('PFOUID').AsInteger := FOUID
                else
                  QRY.ParamByName('PFOUID').AsInteger := 0;
                if Collection > 0 then
                  QRY.ParamByName('PCOLID').AsInteger := Collection
                else
                  QRY.ParamByName('PCOLID').AsInteger := 0;

                case Catalog of
                  FALSE: QRY.ParamByName('PCATALOG').AsInteger := 0;
                  TRUE:  QRY.ParamByName('PCATALOG').AsInteger := 1;
                end;

                case Virtuel of
                  FALSE: QRY.ParamByName('PVIRTUEL').AsInteger := 0;
                  TRUE: QRY.ParamByName('PVIRTUEL').AsInteger := 1;
                end;

                Case Archive Of
                  FALSE: QRY.ParamByName('PARCHIVER').AsInteger := 0;
                  TRUE:  QRY.ParamByName('PARCHIVER').AsInteger := 1;
                End;

                Qry.Open;

//                Qry.SQL.Add('SELECT ARF_ID, ART_ID, ART_NOM, ART_REFMRK, ARF_CHRONO, ARF_DIMENSION, GRE_NOM, SSF_NOM');
//                Qry.SQL.Add('FROM ARTARTICLE');
//                Qry.SQL.Add('JOIN K ON (K_ID=ART_ID AND K_ENABLED=1)');
//                Qry.SQL.Add('JOIN ARTGENRE on (GRE_ID=ART_GREID)');
//                Qry.SQL.Add('join ARTRELATIONAXE ON ARX_ARTID=ART_ID');
//                Qry.SQL.Add('JOIN NKLSSFAMILLE ON SSF_ID=ARX_SSFID');
//                Qry.SQL.Add('JOIN NKLFAMILLE on FAM_ID=SSF_FAMID');
//                Qry.SQL.Add('JOIN NKLRAYON  ON RAY_ID=FAM_RAYID');
//                Qry.SQL.Add('JOIN NKLSECTEUR ON SEC_ID=RAY_SECID');
//                Qry.SQL.Add('join NKLUNIVERS ON UNI_ID=SEC_UNIID');
//                Qry.SQL.Add('join NKLACTIVITE on ACT_ID=ART_ACTID and ACT_UNIID=UNI_ID');
//                IF (NOT gros) AND (FOUID > 0) THEN
//                BEGIN
//                  Qry.SQL.Add('JOIN ARTMRKFOURN ON (FMK_FOUID =' + IntToStr(Fouid) + ' AND FMK_MRKID=ART_MRKID)');
//                  Qry.SQL.Add('JOIN K ON (K_ID=FMK_ID AND K_ENABLED = 1)');
//                END;
//                IF Collection > 0 THEN
//                BEGIN
//                  Qry.SQL.Add('JOIN ARTCOLART ON (CAR_ARTID=ART_ID AND CAR_COLID=' + IntToStr(Collection) + ')');
//                  Qry.SQL.Add('JOIN K ON (K_ID=CAR_ID AND K_ENABLED = 1)');
//                END;
//                Qry.SQL.Add('JOIN ARTREFERENCE ON (ARF_ARTID=ART_ID)');
//                Qry.SQL.Add('WHERE ART_ID=:RECH');
//                IF NOT Catalog THEN Qry.SQL.Add('AND ARF_CATALOG=0');
//                IF NOT Virtuel THEN Qry.SQL.Add('AND ARF_VIRTUEL=0');
//                IF NOT Archive THEN Qry.SQL.Add('AND ARF_ARCHIVER=0');
//                Qry.SQL.Add('ORDER BY ARF_CHRONO');
//                Qry.ParamByName('RECH').asString := Rech;
//                Qry.Open;
                Result := RecUnique(Qry AS TDataset);
              END;
            END;
          END;
      ELSE

      END; // du case

      if iRechPartielle = 1 then
      begin
        OutputDebugString('Une recherche partielle a été effectuée.');
        Qry.Close();
        Qry.SQL.Clear();
        Qry.SQL.Add('SELECT *');
        Qry.SQL.Add('FROM   RECHART_STR(:PRECH, :PFOUID, :PCOLID, :PCATALOG, :PVIRTUEL, :PARCHIVER, 3)');
        Qry.ParamCheck := True;
        Qry.ParamByName('PRECH').AsString := Rech_Origine;

        if not(Gros) and (FouId > 0) then
          Qry.ParamByName('PFOUID').AsInteger := FouId
        else
          Qry.ParamByName('PFOUID').AsInteger := 0;

        if Collection > 0 then
          Qry.ParamByName('PCOLID').AsInteger := Collection
        else
          Qry.ParamByName('PCOLID').AsInteger := 0;

        if Catalog then
          Qry.ParamByName('PCATALOG').AsInteger := 1
        else
          Qry.ParamByName('PCATALOG').AsInteger := 0;

        if Virtuel then
          Qry.ParamByName('PVIRTUEL').AsInteger := 1
        else
          Qry.ParamByName('PVIRTUEL').AsInteger := 0;

        if Archive then
          Qry.ParamByName('PARCHIVER').AsInteger := 1
        else
          Qry.ParamByName('PARCHIVER').AsInteger := 0;

        Qry.Open();
              
        OutputDebugString(PChar(Format('%d article(s) a(ont) été trouvé(s).', [Qry.RecordCount])));

        Result := RecUnique(Qry as TDataSet);
      end;

    EXCEPT
      Qry.Close;
      Qry.SQL.Clear;
      QRY.SQL.Add('Select * FROM RECHART_ARTID(:PARTID,0,0,0,0,0)');
      QRY.ParamCheck := True;
      QRY.ParamByName('PARTID').Asinteger := -1;
      Qry.Open;

//      Qry.SQL.Add('SELECT ARF_ID, ART_ID, ART_NOM, ART_REFMRK, ARF_CHRONO, ARF_DIMENSION, GRE_NOM, SSF_NOM');
//      Qry.SQL.Add('FROM ARTARTICLE');
//      Qry.SQL.Add('JOIN ARTGENRE on (GRE_ID=ART_GREID)');
//      Qry.SQL.Add('join ARTRELATIONAXE ON ARX_ARTID=ART_ID');
//      Qry.SQL.Add('JOIN NKLSSFAMILLE ON SSF_ID=ARX_SSFID');
//      Qry.SQL.Add('JOIN NKLFAMILLE on FAM_ID=SSF_FAMID');
//      Qry.SQL.Add('JOIN NKLRAYON  ON RAY_ID=FAM_RAYID');
//      Qry.SQL.Add('JOIN NKLSECTEUR ON SEC_ID=RAY_SECID');
//      Qry.SQL.Add('join NKLUNIVERS ON UNI_ID=SEC_UNIID');
//      Qry.SQL.Add('join NKLACTIVITE on ACT_ID=ART_ACTID and ACT_UNIID=UNI_ID');
//      Qry.SQL.Add('JOIN K ON (K_ID=ART_ID AND K_ENABLED=1)');
//      Qry.SQL.Add('JOIN ARTREFERENCE ON (ARF_ARTID=ART_ID)');
//      Qry.SQL.Add('WHERE ART_ID<>0');
//      Qry.ParamByName('RECH').asString := '-1';
//      Qry.Open;
      Result := 0;
      // ainsi que_recherche ne donne pas de réponse mais dispose de la stucture champs
      // en sortie ce qui évite les messages d'erreur sur "ART_ID"
    END;
  FINALLY
    Ibc_CtrlChrono.close;
    Ibc_CtrlId.close;
    screen.cursor := crDefault;
    qry.Tag := flagTag;
    qry.EnableControls;
    IF (Result = 0) AND DoMess THEN
    BEGIN
      IF collection > 0 THEN
        WaitMessHP(CdeRechVideCollec, 2, True, 0, 0, '')
      ELSE
        WaitMessHP(CdeRechVide, 2, True, 0, 0, '')
    END;
  END;
END;
// *************************************

//******************* CtrlDelIdRef *************************
// Procédure simple qui retourne Result = False et message si IdRef <> 0;

FUNCTION CtrlDelIdRef(IdRef: Integer; ShowErrorMessage: Boolean): boolean;
BEGIN
  Result := True;
  IF IdRef <> 0 THEN
  BEGIN
    IF ShowErrorMessage THEN InfoMessHP(ErrNoDeleteNullRec, True, 0, 0, '');
    Result := False;
  END;
END;

//******************* CtrlEditIdRef *************************
// Procédure simple qui retourne Result = False et message si IdRef <> 0;

FUNCTION CtrlEditIdRef(IdRef: Integer; ShowErrorMessage: Boolean): boolean;
BEGIN
  Result := True;
  IF IdRef <> 0 THEN
  BEGIN
    IF ShowErrorMessage THEN InfoMessHP(ErrNoEditNullRec, True, 0, 0, '');
    Result := False;
  END;
END;

// Initialisation des variables globales, chemins, Tips ...

PROCEDURE TStdGinKoia.ConstDoInit;
BEGIN
  fBlokDate := -1;
  Appini_Main.IniFileName := ChangeFileExt(Application.ExeName, '.ini');
  FIniApp := Appini_Main.IniFileName;
  IF uppercase(ExtractFileName(Application.ExeName)) = 'INVREPARE.EXE' THEN
  BEGIN
    Appini_Main.IniFileName := ExtractFilePath(Application.ExeName) + 'GINKOIA.ini';
    FIniApp := Appini_Main.IniFileName;
  END;

  //    IF Uppercase(Application.ExeName) = 'INVENTORISTE.EXE' THEN
  //    BEGIN
  //         Appini_Main.IniFileName := ExtractFilePath(Application.ExeName) +'GINKOIA.ini';
  //         FIniApp := Appini_Main.IniFileName;
  //    END;
  FPatapp := FormateStr('ASLASH', ExtractFilePath(Application.ExeName));
  FPatHelp := FPatapp + 'Help\';
  FPatLect := ''; // non utilisé pour l'instant
  FPatRapport := FPatapp + 'BPL\';
  FPatErreurXML := FPatapp + 'ErreurXML\';
  ForceDirectories(FPatErreurXML);  // repertoire de sauvegarde des fichiers XML reçu en erreur
  Application.HelpFile := FPatHelp + ChangeFileExt(ExtractFileName(Application.ExeName), '.HLP');
  IniCtrl.IniFile := Appini_Main.IniFileName;
  // Evite d'avoir à déclarer la soupe habituelle car encapsule tout (voir aide)

  Fcl := SysInf_main.CapsLockState;
  Fnl := SysInf_main.NumLockState;
  FCalc := 0;

  PropSto_Const.Load;

  // Pour partager le Tip en reseau il faut indiquer le chemin dans le fichier INI
  // sinon par défaut le cherche en local dans le repertoire appli
  // Attention : le chemin réseau à indiquer dans l'INI est différent de celui
  // indiqué pour la base (pas les ":" après le lecteur) Ex : \\veronique\c\devis\devis.tip

  Tip_Main.IniFile := iniCtrl.readString('TIP', 'PATH', '');
  IF Tip_Main.IniFile = '' THEN
    Tip_Main.IniFile := ChangeFileExt(Application.ExeName, '.Tip')

END;

// CapsLock : propriété de la forme

PROCEDURE TStdGinKoia.SetFcl(Value: Boolean);
BEGIN
  Fcl := Value;
  SysInf_main.CapsLockState := Fcl;
END;

// NumLock : propriété de la forme

PROCEDURE TStdGinKoia.SetFnl(Value: Boolean);
BEGIN
  Fnl := Value;
  SysInf_main.NumLockState := Fnl;
END;

//--------------------------------------------------------------------------------
//Gestion des erreurs
//--------------------------------------------------------------------------------

//******************* NCNFMess *************************
// Message d'erreur

FUNCTION NCNFMess(Chaine: STRING; V: variant): Word;
BEGIN
  Result := mrNo;
  WITH StdGinkoia DO
    IF OuiNonHP(ParamsStr(chaine, v), False, False, 0, 0, ' Confirmation...') THEN Result := mrYes;
END;

//******************* ERRMess *************************
// Erreur simple bouton OK

FUNCTION ERRMess(Chaine: STRING; V: variant): Word;
BEGIN
  Result := mrYes;
  WITH StdGinkoia DO
    IF NOT StopErrorMess THEN InfoMessHP(ParamsStr(chaine, v), True, 0, 0, ' Erreur...');
END;

//******************* INFMess *************************
// Information simple Bouton OK

FUNCTION INFMess(Chaine: STRING; V: variant): Word;
BEGIN
  Result := mrYes;
  WITH StdGinkoia DO
    InfoMessHP(ParamsStr(chaine, v), True, 0, 0, ' Information...');
END;

//******************* WARMess *************************
// Warning simple bouton Ok

FUNCTION WARMess(Chaine: STRING; V: variant): Word;
BEGIN
  Result := mrYes;
  WITH StdGinkoia DO
    InfoMessHP(ParamsStr(chaine, v), True, 0, 0, ' Avertissement...');
END;

//******************* CNFMess *************************
// Confirmation O/N où o, indique le bouton par défaut
// 0 = OUI  1 = NON et OUI par défaut

FUNCTION CNFMess(Chaine: STRING; V: Variant; BtnDef: Integer): Word;
BEGIN
  Result := mrNo;
  WITH StdGinkoia DO
  BEGIN
    IF (btnDef < 0) OR (btnDef > 1) THEN btnDef := 1;
    CASE btnDef OF
      0: IF OuiNonHP(ParamsStr(chaine, v), True, True, 0, 0, ' Confirmation...') THEN Result := mrYes;
      1: IF OuiNonHP(ParamsStr(chaine, v), False, False, 0, 0, ' Confirmation...') THEN Result := mrYes;
    END;
  END;
END;

//--------------------------------------------------------------------------------
// Système et Clavier
//--------------------------------------------------------------------------------

//******************* Pause *************************
// Pause

PROCEDURE Pause(Value: Integer);
BEGIN
  // value = pause indiquée en secondes ...
  StdGinkoia.Delay_main.WaitForDelay(Value * 1000)
END;

PROCEDURE Delai(Value: Integer);
BEGIN
  // value = pause indiquée en secondes ...
  StdGinkoia.Delay_main.WaitForDelay(Value)
END;

//******************* ExecCalc *************************
// Calculatrice

FUNCTION ExecCalc: Boolean;
BEGIN
  Result := False;
  WITH StdGinkoia DO
  BEGIN
    IF Calc_Main.Execute THEN
    BEGIN
      Result := True;
      Fcalc := calc_main.CalcDisplay;
    END;
  END;
END;

//******************* ExecTip *************************
// Tip of the day

PROCEDURE ExecTip;
BEGIN
  WITH StdGinkoia DO
  BEGIN
    Tip_Main.Execute;
    PropSto_Const.Save;
  END;
END;

//******************* CreateForm *************************
// Création de Forme

FUNCTION CreateForm(AFormClass: TFormClass): TCustomForm;
BEGIN
  Result := AFormClass.Create(Application);
END;

//******************* ExecModal *************************
// Exécution modale

FUNCTION ExecModal(AForm: TForm; AClass: TFormClass): TModalResult;
BEGIN
  // Result := MrNone;
  TRY
    AForm := AClass.Create(Application);
    Result := AForm.ShowModal;
  FINALLY
    AForm.Free;
  END;
END;

PROCEDURE TstdGinkoia.DevImpPgH(DxImp: TObject; FirstLine: STRING);
BEGIN
  IF (DxImp IS TdxDbGridReportLink) THEN
  BEGIN
    IF (DxImp AS TdxDbGridReportLink).PrinterPage.PageHeader.LeftTitle.Count = 0 THEN
      (DxImp AS TdxDbGridReportLink).PrinterPage.PageHeader.LeftTitle.Add(FirstLine)
    ELSE
      (DxImp AS TdxDbGridReportLink).PrinterPage.PageHeader.LeftTitle[0] := FirstLine;
  END;
  IF (DxImp IS TdxMasterViewReportLink) THEN
  BEGIN
    IF (DxImp AS TdxMasterviewReportLink).PrinterPage.PageHeader.LeftTitle.Count = 0 THEN
      (DxImp AS TdxMasterviewReportLink).PrinterPage.PageHeader.LeftTitle.Add(FirstLine)
    ELSE
      (DxImp AS TdxMasterviewReportLink).PrinterPage.PageHeader.LeftTitle[0] := FirstLine;
  END;
END;

PROCEDURE TStdGinKoia.DevImpFilter(DxImp: TObject; GrdFilter: ARRAY OF CONST);
VAR
  ch, c: STRING;
  i, j: Integer;
BEGIN
  IF (dxImp <> NIL) THEN
  BEGIN
    IF (DxImp IS TdxDbGridReportLink) THEN
    BEGIN
      WITH (DxImp AS TdxDbGridReportLink).ReportTitle DO
      BEGIN
        Text := '';
        Mode := tmOnFirstPage;
        TextAlignX := TcxTextAlignX(taLeft);
        TextAlignY := TcxTextAlignY(taCenterY);
        Font.Name := 'Arial';
        Font.Size := 8;
        Font.Style := [];
        ch := '';
        j := 0;

        FOR i := 0 TO High(GrdFilter) DO
        BEGIN
          CASE GrdFilter[i].VType OF
            vtString: c := GrdFilter[i].Vstring^;
            VtPChar: c := StrPas(GrdFilter[i].VPchar);
            vtAnsiString: c := ansiString(GrdFilter[i].VAnsiString);
          END;
          IF c <> '' THEN
          BEGIN
            IF j = 0 THEN
              ch := c
            ELSE
              ch := ch + CrLf + c;
            inc(j);
          END
        END;
        Text := ch;
      END;
    END;
    IF (DxImp IS TdxMasterViewReportLink) THEN
    BEGIN
      WITH (DxImp AS TdxMasterviewReportLink).ReportTitle DO
      BEGIN
        Text := '';
        Mode := tmOnFirstPage;
        TextAlignX := taLeft;
        TextAlignY := taCenterY;
        Font.Name := 'Arial';
        Font.Size := 8;
        Font.Style := [];
        ch := '';
        j := 0;

        FOR i := 0 TO High(GrdFilter) DO
        BEGIN
          CASE GrdFilter[i].VType OF
            vtString: c := GrdFilter[i].Vstring^;
            VtPChar: c := StrPas(GrdFilter[i].VPchar);
            vtAnsiString: c := ansiString(GrdFilter[i].VAnsiString);
          END;
          IF c <> '' THEN
          BEGIN
            IF j = 0 THEN
              ch := c
            ELSE
              ch := ch + CrLf + c;
            inc(j);
          END
        END;
        Text := ch;
      END;
    END;
  END;
END;

PROCEDURE TStdGinKoia.LoadSmallBmp(Name: STRING; Bit: TspeedButton);
VAR
  _bt: TBitmap;
BEGIN
  _bt := TBitmap.Create;
  RVIML_Small.AssignImagesByName(Name, _bt);
  bit.Glyph := _Bt;
  _bt.free
END;

PROCEDURE TStdGinKoia.LoadLargeBmp(Name: STRING; Bit: TspeedButton);
VAR
  _bt: TBitmap;
BEGIN
  _bt := TBitmap.Create;
  RVIML_Large.AssignImagesByName(Name, _bt);
  bit.Glyph := _Bt;
  _bt.free
END;

PROCEDURE TStdGinKoia.LoadSmallBmp(Name: STRING; Bit: TLMDCUSTOMSpeedButton);
VAR
  _bt: TBitmap;
BEGIN
  _bt := TBitmap.Create;
  RVIML_Small.AssignImagesByName(Name, _bt);
  bit.Glyph := _Bt;
  _bt.free
END;

PROCEDURE TStdGinKoia.LoadLargeBmp(Name: STRING; Bit: TLMDCUSTOMSpeedButton);
VAR
  _bt: TBitmap;
BEGIN
  _bt := TBitmap.Create;
  RVIML_Large.AssignImagesByName(Name, _bt);
  bit.Glyph := _Bt;
  _bt.free
END;

PROCEDURE TStdGinKoia.LoadSmallBmp(Name: STRING; Bit: Tpicture);
VAR
  _bt: TBitmap;
BEGIN
  _bt := TBitmap.Create;
  RVIML_Small.AssignImagesByName(Name, _bt);
  bit.Bitmap := _Bt;
  _bt.free
END;

PROCEDURE TStdGinKoia.LoadLargeBmp(Name: STRING; Bit: Tpicture);
VAR
  _bt: TBitmap;
BEGIN
  _bt := TBitmap.Create;
  RVIML_Large.AssignImagesByName(Name, _bt);
  bit.Bitmap := _Bt;
  _bt.free
END;

PROCEDURE TStdGinKoia.LoadSmallBmp(Name: STRING; Bit: TLMDSpecialButton);
VAR
  _bt: TBitmap;
BEGIN
  _bt := TBitmap.Create;
  RVIML_Small.AssignImagesByName(Name, _bt);
  bit.glyph := _Bt;
  _bt.free
END;

PROCEDURE TStdGinKoia.LoadLargeBmp(Name: STRING; Bit: TLMDSpecialButton);
VAR
  _bt: TBitmap;
BEGIN
  _bt := TBitmap.Create;
  RVIML_Large.AssignImagesByName(Name, _bt);
  bit.glyph := _Bt;
  _bt.free
END;

PROCEDURE TStdGinKoia.LoadSmallBmp(Name: STRING; Bit: TRzDBButtonEdit);
VAR
  _bt: TBitmap;
BEGIN
  _bt := TBitmap.Create;
  RVIML_Small.AssignImagesByName(Name, _bt);
  bit.AltBtnGlyph := _Bt;
  _bt.free
END;

PROCEDURE TStdGinKoia.LoadLargeBmp(Name: STRING; Bit: TRzDBButtonEdit);
VAR
  _bt: TBitmap;
BEGIN
  _bt := TBitmap.Create;
  RVIML_Large.AssignImagesByName(Name, _bt);
  bit.AltBtnGlyph := _Bt;
  _bt.free
END;

PROCEDURE TStdGinKoia.LoadSmallBmp(Name: STRING; Bit: TdxBarButton);
VAR
  _bt: TBitmap;
BEGIN
  _bt := TBitmap.Create;
  RVIML_Small.AssignImagesByName(Name, _bt);
  bit.Glyph := _Bt;
  _bt.free
END;

PROCEDURE TStdGinKoia.LoadLargeBmp(Name: STRING; Bit: TdxBarButton);
VAR
  _bt: TBitmap;
BEGIN
  _bt := TBitmap.Create;
  RVIML_Large.AssignImagesByName(Name, _bt);
  bit.Glyph := _Bt;
  _bt.free
END;
      
// renvoie true si la date de migration est inférieur à la date à controler
function TStdGinKoia.CtrlMigrationIntersys(AMagID: integer; ADateACtrl: TDatetime; var ADateMigre: TDatetime): boolean;
var
  QueTmp: TIBOQuery;
begin
  Result := true;
  ADateMigre := 0;
  QueTmp := TIBOQuery.Create(Self);
  try
    QueTmp.IB_Connection := Dm_Main.Database;
    QueTmp.IB_Transaction := Dm_Main.IbT_HorsK;

    QueTmp.Close;
    QueTmp.SQL.Clear;
    QueTmp.SQL.Add('select MAG_MIGRATIONISF from genmagasin');
    QueTmp.SQL.Add('where MAG_ID='+inttostr(AMagId));
    QueTmp.Open;
    QueTmp.First;
    if not(QueTmp.Eof) then
    begin
      ADateMigre := QueTmp.fieldbyname('MAG_MIGRATIONISF').AsDateTime;
      if Trunc(ADateACtrl)<Trunc(ADateMigre) then
        Result := false;

    end;
    QueTmp.Close;
  finally
    QueTmp.Close;
    FreeAndNil(QueTmp);
  end;
end;

PROCEDURE TStdGinKoia.CtrlMrkFouPrin;
VAR
  flagOk: Boolean;
BEGIN

  FlagOk := True;
  // Ici je suis dans une transaction hors K donc pas de réplication et je
  // me moque du magasin

  TRY

    Que_CtrlRtf.Close;
    Que_CtrlRtf.ParamByName('COD').asInteger := -2;
    Que_CtrlRtf.ParamByName('MAGID').asInteger := MagasinID;
    Que_CtrlRtf.Open;

    IF Que_CtrlRTFPRM_CODE.asInteger <> -2 THEN
    BEGIN
      Que_CtrlRtf.Insert;
      IF NOT Dm_Main.IBOMajPkKey(que_CtrlRtf, 'PRM_ID') THEN
        Que_CtrlRtf.Cancel
      ELSE
        FlagOk := False;
    END
    ELSE BEGIN
      // en changeant ici la valeur nécessaire au champ on peut reforcer le contrôle
      IF que_CtrlRtfPRM_INTEGER.asInteger <> 3 THEN
      BEGIN
        que_CtrlRtf.Edit;
        Flagok := False;
      END;
    END;

    IF NOT FlagOk THEN
    BEGIN
      screen.Cursor := crSQLWait;
      ShowMessHP(MajFicMarques, True, 0, 0, '');
      que_CtrlRtfPRM_Info.AsString := 'Contrôle MrkFouPrin';
      que_CtrlRtfPRM_String.asstring := '';
      que_CtrlRtfPRM_INTEGER.asInteger := 3;
      que_CtrlRtfPRM_FLOAT.asFloat := 0;
      que_CtrlRtfPRM_CODE.AsInteger := -2;
      que_CtrlRtfPRM_MAGID.AsInteger := MagasinId;
      que_CtrlRtf.Post;

      TRY
        IbStProc_Marques.close;
        IbStProc_Marques.prepared := True;
        IbStProc_Marques.ExecProc;
      FINALLY
        IbStProc_Marques.Close;
        IbStProc_Marques.Unprepare;
        ShowCloseHP;
      END;
    END;
  FINALLY
    screen.Cursor := crDefault;
  END;
END;

PROCEDURE TStdGinKoia.GenerikAfterPost(DataSet: TDataSet);
BEGIN
  Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TStdGinKoia.GenerikUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
  Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
    (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TStdGinKoia.GesHintetButton(Panel: TWinControl);
VAR
  TC: TControl;
  i: Integer;
BEGIN
  IF (csDesigning IN Panel.ComponentState) OR (csLoading IN Panel.ComponentState) THEN EXIT;
  TRY
    FOR i := 0 TO Panel.ControlCount - 1 DO
    BEGIN
      Tc := Panel.Controls[i];
      IF (tc IS TRzDBButtonEditRv) THEN
        (tc AS TRzDBButtonEditRv).DoAutoHintEtButton
      ELSE IF (tc IS TwwDBDateTimePickerRv) THEN
        (tc AS TwwDBDateTimePickerRv).DoAutoHintEtButton
      ELSE IF (tc IS TwwDBLookupComboRv) THEN
        (tc AS TwwDBLookupComboRv).DoAutoHintEtButton
      ELSE IF (tc IS TwwDBComboBoxRv) THEN
        (tc AS TwwDBComboBoxRv).DoAutoHintEtButton
      ELSE IF (tc IS TwwDBComboDlgRv) THEN
        (tc AS TwwDBComboDlgRv).DoAutoHintEtButton
      ELSE IF (tc IS TwwDBLookupComboDlgRv) THEN
        (tc AS TwwDBLookupComboDlgRv).DoAutoHintEtButton
      ELSE IF (tc IS TWinControl) THEN
        GesHintetButton(TWinControl(TC));

    END;
  EXCEPT
  END;
END;

PROCEDURE TStdGinKoia.AffecteHintEtBmp(Panel: TWinControl);
VAR
  TC: TControl;
  zName, LH, S: STRING;
  PropInfo: PPropInfo;
  i, k, z: Integer;
  _bt: TBitmap;
BEGIN
  _bt := TBitmap.Create;
  TRY
    FOR i := 0 TO Panel.ControlCount - 1 DO
    BEGIN
      k := -1;
      S := '';
      LH := '';

      Tc := Panel.Controls[i];
      IF (tc IS TLMDSpeedButton) AND FisXP THEN
      BEGIN
        IF (tc AS TLMDSpeedButton).Style = ubsWin31 THEN
          (tc AS TLMDSpeedButton).Style := ubsAutoDetect;
      END;

      PropInfo := GetPropInfo(Tc, 'OnClick');
      IF PropInfo <> NIL THEN
      BEGIN
        PropInfo := GetPropInfo(Tc, 'Glyph');
        IF PropInfo <> NIL THEN
        BEGIN
          k := 1000;
          z := Pos('_', TC.Name);
          IF z <> 0 THEN
          BEGIN
            Zname := Copy(Tc.Name, z + 1, length(tc.name));
            Zname := Uppercase(ZName);
            z := Str_CodesBtn.Strings.IndexOF(zName);
            IF z <> -1 THEN
            BEGIN
              LH := GetStrProp(Tc, GetPropInfo(Tc, 'Hint'));
              k := z;
            END;
          END;
          IF k = 1000 THEN
          BEGIN
            FOR z := 0 TO Str_CodesBtn.Strings.Count - 1 DO
            BEGIN
              IF Pos(Uppercase(Str_CodesBtn.Strings[z]), Uppercase(TC.Name)) > 0 THEN
              BEGIN
                LH := GetStrProp(Tc, GetPropInfo(Tc, 'Hint'));
                k := z;
                BREAK;
              END;
            END;
          END;
          IF Pos('CLEARSELECTION', Uppercase(Tc.Name)) > 0 THEN
          BEGIN
            LH := '';
            K := 100;
          END;

          CASE K OF
            0: S := 'Filter';
            1:
              BEGIN
                S := 'Filtre';
                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintVoirFiltre);
              END;
            2:
              BEGIN
                S := 'Autowidth';
                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintAutoWidth);
              END;
            3:
              BEGIN
                S := 'Calcbleu';
                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintBasculeGrpFoot);
              END;
            4:
              BEGIN
                S := 'Calcgris';
                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintBtnShowFooterRow);
              END;
            5:
              BEGIN
                S := 'Calcjaune';
                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintBtnShowFooter);
              END;
            6:
              BEGIN
                S := 'Preview';
                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintBtnPreview);
              END;
            7, 8:
              BEGIN
                S := 'Openlevel';
                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintExpandLevel);
              END;
            9:
              BEGIN
                S := 'Arbreplus';
                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintFullExpand);
              END;
            10, 11:
              BEGIN
                S := 'Closelevel';
                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintCollapseLevel);
              END;
            12:
              BEGIN
                S := 'Arbremoins';
                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintFullCollapse);
              END;
            13:
              BEGIN
                S := 'Print1';
                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintEditInterne);
              END;
            14:
              BEGIN
                S := 'Print1';
                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintBtnPrintDbg);
              END;
            15:
              BEGIN
                S := 'Calendar';
                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintPeriodeEtude);
              END;
            16:
              BEGIN
                S := 'Sovecmz';
                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintBtnSoveCmz);
              END;
            17:
              BEGIN
                S := 'Cmz';
                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintBtnCmzDbg);
              END;
            18:
              BEGIN
                S := 'DiskFrom';
                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintBtnLoadCmz);
              END;
            19:
              BEGIN
                S := 'Filteroff';
                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintBtnClearFilterDbg);
              END;
            20:
              BEGIN
                S := 'Grouppanel';
                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintBtnShowGroupPanel);
              END;
            21:
              BEGIN
                S := 'Excel';
                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintBtnExcelDbg);
              END;
            22:
              BEGIN
                S := 'Prior';
                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintPriorRec);
              END;
            23:
              BEGIN
                S := 'Next';
                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintNextRec);
              END;
            24:
              BEGIN
                S := 'Outils';
                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintBtnPopup);
              END;
            25:
              BEGIN
                S := 'Refresh';
                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintBtnRefresh);
              END;
            26:
              BEGIN
                S := 'Cancel';
                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintBtnCancel);
              END;
            27:
              BEGIN
                S := 'Post';
                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintBtnPost);
              END;
            28:
              BEGIN
                S := 'Edit';
                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintBtnEdit);
              END;
            29:
              BEGIN
                S := 'Delete';
                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintBtnDelete);
              END;
            30:
              BEGIN
                S := 'Insert';
                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintBtnInsert);
              END;
            31: S := 'Quitter';
            32: IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintBtnConvert);
            33:
              BEGIN
                S := 'UndoCmz';
                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintBtnUndo);
              END;
            34:
              BEGIN
                S := 'Preco';
                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintPreco);
              END;
            35:
              BEGIN
                S := 'AutoHeight';
                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintAutoHeight);
              END;
            36:
              BEGIN
                S := 'GrandA';
                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintBtnGroupart);
              END;
            37:
              BEGIN
                S := 'PanelLeft';
                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintAffChx);
              END;
            38:
              BEGIN
                S := 'Post';
              END;
            100:
              BEGIN
                S := 'FreeBkmJ';
                IF Trim(LH) = '' THEN SetStrProp(Tc, 'Hint', HintClearSel);
              END;

          END;
          IF S <> '' THEN
          BEGIN
            RVIML_Small.AssignImagesByName(S, _bt);
            SetObjectProp(Tc, 'Glyph', _Bt);
          END;
        END;
      END;
      IF (k = -1) AND (tc IS TWinControl) THEN
        AffecteHintEtBmp(TWinControl(TC))
    END;
  FINALLY
    _bt.Free;
  END;
END;

PROCEDURE TStdGinKoia.GetFirstIdLigne(Prec, Suiv: STRING; Nbre: Integer);
VAR
  k, N, P: Double;
BEGIN
  { Le but: arriver à caser un groupe de lignes entre 2 lignes existantes
    La simple division par 2 n'est pas satisfaisante dans le cas d'insertion
    d'un groupe de nodes de plus d'une vintaine de lignes !
    ATTENTION : Dans l'utilistion de ces routines le groupe à insérer part
    de la dernière ligne vers la 1ère !!!!
  }
  k := 100000000000;
  P := StrToFloatTry(Prec);
  N := StrToFloatTry(Suiv);

  IdOffset := 0;
  IdOrdre := 0;
  TemoinIdP := StrToFloatTry(Prec);

  IF (P = 0) AND (N = 0) THEN
  BEGIN
    IF Nbre = 1 THEN
      IdOrdre := K
    ELSE
      IdOrdre := k * (Nbre + 1);
    IdOffset := k;
  END
  ELSE BEGIN
    IF (P = 0) AND (N <> 0) THEN
    BEGIN
      IdOffset := N / (Nbre + 1);
      IdOrdre := N - IdOffset;
    END
    ELSE BEGIN
      IF (P <> 0) AND (N = 0) THEN
      BEGIN
        IdOrdre := P + (k * Nbre);
        IdOffset := k;
      END
      ELSE BEGIN
        IdOffset := (N - P) / (Nbre + 1);
        IdOrdre := N - idOffset;
      END;
    END;
  END;
END;

FUNCTION TStdGinkoia.GetIdLigne(VAR IdL: STRING): Boolean;
VAR
  v: Double;
BEGIN
  // False si l'offset est < ou égal à l'id de base précédent
  IdL := '';
  Result := False;
  IF IdOrdre > TemoinIdP THEN
  BEGIN
    Result := True;
    v := Trunc(IdOrdre);
    IdL := Conv(v, 15);
    IdOrdre := IdOrdre - IdOffset;
  END;
END;

FUNCTION TStdGinKoia.rechercheCP(VAR Cp, Ville, pays: STRING; VAR Id,
  idpays: Integer; AvecPays: Boolean = False; AvecInsertion: Boolean = True): Boolean;

  PROCEDURE Valide;
  BEGIN
    TRY
      Dm_Main.StartTransaction;
      Dm_Main.IBOUpDateCache(Que_Ville);
      Dm_Main.IBOUpDateCache(Que_Pays);
      Dm_Main.Commit;
    EXCEPT
      Dm_Main.Rollback;
      Dm_Main.IBOCancelCache(Que_Ville);
      Dm_Main.IBOCancelCache(Que_Pays);
    END;
    Dm_Main.IBOCommitCache(Que_Ville);
    Dm_Main.IBOCommitCache(Que_Pays);
  END;

  PROCEDURE Cancel;
  BEGIN
    Dm_Main.IBOCancelCache(Que_Ville);
    Dm_Main.IBOCancelCache(Que_Pays);
  END;

VAR
  i: integer;
BEGIN
  LK_Ville.tag := 0;
  LK_Ville.AllowInsert := AvecInsertion;
  LK_Ville.AllowDelete := AvecInsertion;
  LK_Ville.AllowEdit := AvecInsertion;
  i := Que_Ville.Sql.indexof('/*BALISE1*/') + 1;
  WHILE i < Que_Ville.Sql.Count DO
    Que_Ville.Sql.delete(i);
  IF trim(cp) <> '' THEN
  BEGIN
    IF trim(ville) <> '' THEN
    BEGIN
      Que_Ville.sql.Add('WHERE VIL_NOM STARTING :Ville');
      Que_Ville.sql.Add('  AND VIL_CP STARTING :CP');
      IF AvecPays THEN
      BEGIN
        Que_Ville.sql.Add('  AND VIL_PAYID = ' + Inttostr(IdPays));
      END;
      //Que_Ville.sql.Add('PLAN SORT (JOIN ( GENVILLE INDEX (INX_GENVIL_CP,INX_GENVILNOM),GENPAYS INDEX (INX_GENPAYID),K INDEX (K_1)))');
      Que_Ville.sql.Add('Order By VIL_CP, VIL_NOM');
      Que_Ville.ParamByName('Ville').AsString := Ville;
      Que_Ville.ParamByName('Cp').AsString := Cp;
      Que_Ville.Close;
      Que_Ville.Open;
    END
    ELSE
    BEGIN
      Que_Ville.sql.Add('WHERE VIL_CP STARTING :CP');
      //Que_Ville.sql.Add('PLAN SORT (JOIN ( GENVILLE INDEX (INX_GENVIL_CP),GENPAYS INDEX (INX_GENPAYID),K INDEX (K_1)))');
      IF AvecPays THEN
      BEGIN
        Que_Ville.sql.Add('  AND VIL_PAYID = ' + Inttostr(IdPays));
      END;
      Que_Ville.sql.Add('Order By VIL_CP, VIL_NOM');
      Que_Ville.ParamByName('Cp').AsString := Cp;
      Que_Ville.Close;
      Que_Ville.Open;
    END
  END
  ELSE
  BEGIN
    IF trim(ville) <> '' THEN
    BEGIN
      Que_Ville.sql.Add('WHERE VIL_NOM STARTING :Ville');
      //Que_Ville.sql.Add('PLAN SORT (JOIN ( GENVILLE INDEX (INX_GENVILNOM),GENPAYS INDEX (INX_GENPAYID),K INDEX (K_1)))');
      IF AvecPays THEN
      BEGIN
        Que_Ville.sql.Add('  AND VIL_PAYID = ' + Inttostr(IdPays));
      END;
      Que_Ville.sql.Add('Order By VIL_CP, VIL_NOM');
      Que_Ville.ParamByName('Ville').AsString := Ville;
      Que_Ville.Close;
      Que_Ville.Open;
    END
    ELSE
    BEGIN
      IF AvecPays THEN
      BEGIN
        Que_Ville.sql.Add('WHERE VIL_PAYID = ' + Inttostr(IdPays));
      END;
      Que_Ville.sql.Add('Order By VIL_CP, VIL_NOM');
      Que_Ville.Close;
      Que_Ville.Open;
    END;
  END;
  IF que_ville.isempty THEN
  BEGIN
    IF (trim(Cp) <> '') AND (trim(ville) <> '') THEN
    BEGIN
      i := Que_Ville.Sql.indexof('/*BALISE1*/') + 1;
      WHILE i < Que_Ville.Sql.Count DO
        Que_Ville.Sql.delete(i);
      Que_Ville.sql.Add('WHERE (VIL_NOM STARTING :Ville');
      Que_Ville.sql.Add('  OR  VIL_CP STARTING :CP)');
      IF AvecPays THEN
      BEGIN
        Que_Ville.sql.Add('  AND VIL_PAYID = ' + Inttostr(IdPays));
      END;
      Que_Ville.sql.Add('Order By VIL_CP, VIL_NOM');
      Que_Ville.ParamByName('Ville').AsString := Ville;
      Que_Ville.ParamByName('Cp').AsString := Cp;
      Que_Ville.Close;
      Que_Ville.Open;
    END;
    LeCp := Cp;
    LaVille := Ville;
    IF Que_Ville.isempty AND NOT AvecInsertion THEN
    BEGIN
      result := false;
    END
    ELSE
    BEGIN
      IF Que_Ville.isempty THEN
        LK_Ville.tag := 1;
      IF LK_Ville.execute THEN
      BEGIN
        Valide;
        id := Que_VilleVIL_ID.AsInteger;
        result := true;
        cp := Que_VilleVIL_CP.AsString;
        ville := Que_VilleVIL_NOM.AsString;
        IdPays := Que_VilleVIL_PAYID.AsInteger;
        Pays := Que_VillePAY_NOM.AsString;
      END
      ELSE
      BEGIN
        result := false;
        cancel;
      END;
    END;
  END
  ELSE
  BEGIN
    IF que_ville.recordcount = 1 THEN
    BEGIN
      id := Que_VilleVIL_ID.AsInteger;
      result := true;
      cp := Que_VilleVIL_CP.AsString;
      ville := Que_VilleVIL_NOM.AsString;
      IdPays := Que_VilleVIL_PAYID.AsInteger;
      Pays := Que_VillePAY_NOM.AsString;
    END
    ELSE
    BEGIN
      IF LK_Ville.execute THEN
      BEGIN
        Valide;
        id := Que_VilleVIL_ID.AsInteger;
        result := true;
        cp := Que_VilleVIL_CP.AsString;
        ville := Que_VilleVIL_NOM.AsString;
        IdPays := Que_VilleVIL_PAYID.AsInteger;
        Pays := Que_VillePAY_NOM.AsString;
      END
      ELSE
      BEGIN
        result := false;
        cancel;
      END;
    END;
  END
END;

PROCEDURE TStdGinKoia.GeneBeforeDelete(DataSet: TDataSet);
BEGIN
  IF NOT Dm_Main.CheckAllowDelete((DataSet AS TIBODataSet).KeyRelation,
    DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
    True) THEN Abort;
END;

PROCEDURE TStdGinKoia.GeneBeforeEdit(DataSet: TDataSet);
BEGIN
  IF NOT Dm_Main.CheckAllowEdit((DataSet AS TIBODataSet).KeyRelation,
    DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
    True) THEN Abort;
END;

PROCEDURE TStdGinKoia.GeneNewRecord(DataSet: TDataSet);
BEGIN
  IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
    (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;
  IF Dataset = Que_Ville THEN
  BEGIN
    Que_VilleVIL_PAYID.AsInteger := 0;
  END;
  IF Dataset = Que_Modereg THEN
  BEGIN
    Que_ModeregMRG_Lib.AsString := '';
  END;

END;

PROCEDURE TStdGinKoia.GeneUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
  Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
    (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TStdGinKoia.LK_VilleInitDialog(Dialog: TwwLookupDlg);
BEGIN
  dialog.wwDBGrid1.OnBeforePaint := VilleBeforePaint;
  VillePrem := true;
END;

PROCEDURE TStdGinKoia.VilleBeforePaint(sender: Tobject);
VAR
  Key: Word;
BEGIN
  IF VillePrem THEN
  BEGIN
    VillePrem := false;
    IF LK_Ville.Tag = 1 THEN
    BEGIN
      TWWDbGrid(Sender).setFocus;
      Key := vk_INSERT;
      LK_Ville.wwDBGrid1KeyDown(Lk_ville, Key, []);
      Que_VilleVIL_CP.AsString := LeCP;
      Que_VilleVIL_NOM.AsString := LaVille;
    END;
  END;
END;

PROCEDURE TStdGinKoia.GesModereg;
VAR
  ucm: Boolean;
BEGIN
  UCM := Dm_UIL.HasPermission(UILModif_Fact);
  Lk_Modereg.AllowEdit := Ucm;
  Lk_Modereg.AllowInsert := Ucm;
  Lk_Modereg.AllowDelete := Ucm;
  LK_Modereg.Execute;

END;

PROCEDURE TStdGinKoia.ParamsBeforeDelete(DataSet: TDataSet);
BEGIN
  IF Dataset = que_Modereg THEN
    IF ID_EXISTE('MRGID', que_ModeregMRG_ID.asInteger, []) THEN
    BEGIN
      WaitMessHP(ErrNoDeleteIntChk, 2, True, 0, 0, '');
      ABORT;
    END;

END;
          
// est-ce la centrale est présent au moins dans un domaine commercial
function TStdGinKoia.IsIntersportInDomaineCommercial: boolean;
var
  QueTmpCursor: TIB_Cursor;
begin
  Result := false;

  QueTmpCursor := TIB_Cursor.Create(Self);
  try
    QueTmpCursor.IB_Connection := Dm_Main.Database;
    QueTmpCursor.IB_Transaction := Dm_Main.IbT_HorsK;
    with QueTmpCursor do
    begin
      SQL.Clear;
      SQL.Add('select ACT_ID from NKLACTIVITE');
      SQL.Add('  join k k1 on k1.k_id=ACT_ID and k_enabled=1');
      SQL.Add('  join gencentrale on CEN_ID=ACT_CENID');
      SQL.Add(' where ACT_ID<>0 and CEN_CODE=1');        // CEN_CODE=1 correspond à intersport

      Open;
      First;
      if not(Eof) then
        Result := true;
    end;
  finally
    QueTmpCursor.Close;
    FreeAndNil(QueTmpCursor);
  end;
end;

FUNCTION TStdGinKoia.IsUniqueTailCoul(Artid: Integer; VAR TGFID: Integer; VAR TGFNom: STRING; VAR Couid: Integer; VAR COUNom: STRING): Boolean;
VAR
  tem1, tem2: Boolean;
BEGIN
  Result := False;
  Tem1 := False;
  Tem2 := False;

  IF Origine = 2 THEN
  BEGIN
    Result := True;
    TgfId := 0;
    CouId := 0;
    TgfNom := '';
    CouNom := '';
    EXIT;
  END;

  TRY
    Ibc_TailleUnik.Close;
    Ibc_TailleUnik.ParamByName('ARTID').asInteger := Artid;
    Ibc_TailleUnik.Open;
    IF NOT Ibc_TailleUnik.Eof THEN
      Tem1 := Ibc_TailleUnik.Fields[2].asInteger = 1;

    Ibc_CoulUnik.Close;
    Ibc_CoulUnik.ParamByName('ARTID').asInteger := Artid;
    Ibc_CoulUnik.Open;
    IF NOT Ibc_CoulUnik.Eof THEN
      Tem2 := Ibc_CoulUnik.Fields[2].asInteger = 1;
  FINALLY
    IF Tem1 AND Tem2 THEN
    BEGIN
      Result := True;
      TGFID := Ibc_TailleUnik.Fields[0].asInteger;
      TgfNom := Ibc_TailleUnik.Fields[1].asString;
      COUID := Ibc_CoulUnik.Fields[0].asInteger;
      CouNom := Ibc_CoulUnik.Fields[1].asString;
    END;
    Ibc_CoulUnik.Close;
    Ibc_TailleUnik.Close;
  END;
END;

PROCEDURE TStdGinKoia.GenerikBeforeOpen(DataSet: TDataSet);
BEGIN
END;

PROCEDURE TStdGinKoia.Que_ModeregBeforePost(DataSet: TDataSet);
BEGIN
  IF Trim(Que_ModeregMRG_LIB.asString) = '' THEN
  BEGIN
    WaitMessHP(NoLibMrg, 2, True, 0, 0, '');
    ABORT;
  END;
END;

PROCEDURE TStdGinKoia.CTRLTypDev;
BEGIN
  TRY
    que_CtrlTypDev.Close;
    que_CtrlTypDev.ParamByName('CODE').asInteger := 102;
    que_CtrlTypDev.Open;

    IF (que_CtrlTypDevNPR_CODE.asInteger = 102) AND (que_CtrlTypDevNPR_LIBELLE.asstring <> TipDev102) THEN
    BEGIN
      que_CtrlTypDev.Edit;
      que_CtrlTypDevNPR_LIBELLE.asstring := TipDev102;
      que_CtrlTypDev.Post;
    END;

    que_CtrlTypDev.Close;
    que_CtrlTypDev.ParamByName('CODE').asInteger := 108;
    que_CtrlTypDev.Open;
    IF (que_CtrlTypDevNPR_CODE.asinteger = 108) AND (que_CtrlTypDevNPR_LIBELLE.asstring <> TipDev108) THEN
    BEGIN
      que_CtrlTypDev.Edit;
      que_CtrlTypDevNPR_LIBELLE.asstring := TipDev108;
      que_CtrlTypDev.Post;
    END;

    que_CtrlTypDev.Close;
    que_CtrlTypDev.ParamByName('CODE').asInteger := 105;
    que_CtrlTypDev.Open;
    IF (que_CtrlTypDevNPR_CODE.asInteger = 105) AND (que_CtrlTypDevNPR_LIBELLE.asstring <> TipDev105) THEN
    BEGIN
      que_CtrlTypDev.Edit;
      que_CtrlTypDevNPR_LIBELLE.asstring := TipDev105;
      que_CtrlTypDev.Post;
    END;

    que_CtrlTypDev.Close;
    que_CtrlTypDev.ParamByName('CODE').asInteger := 106;
    que_CtrlTypDev.Open;
    IF (que_CtrlTypDevNPR_CODE.asInteger = 106) AND (que_CtrlTypDevNPR_LIBELLE.asstring <> TipDev106) THEN
    BEGIN
      que_CtrlTypDev.Edit;
      que_CtrlTypDevNPR_LIBELLE.asstring := TipDev106;
      que_CtrlTypDev.Post;
    END;
  FINALLY
    que_CtrlTypDev.Close;
  END;
END;

FUNCTION TStdGinKoia.GetISXP: Boolean;
VAR
  OSVersion: TOSVersionInfo;
BEGIN
  result := false;
  OSVersion.dwOSVersionInfoSize := SizeOf(OSVersion);
  IF GetVersionEx(OSVersion) THEN
  BEGIN
    IF (OSVersion.dwPlatformID = 2) AND (OsVersion.dwMajorVersion > 4) THEN
      result := true;
  END;
  //    InfoMessHP ( ' Platform : ' + IntToStr(OSVersion.dwPlatformID) + #13#10 + 'MajorVersion : ' +IntToStr(OsVersion.dwMajorVersion),true,0,0,'');
END;

function TStdGinKoia.GetMonnaieActuelle: string;
begin
  if FMonnaieActuelle = '' then
  begin
    FMonnaieActuelle := GetParamString(9, 1, 0, 0);
    if FMonnaieActuelle = '' then
    begin
      FMonnaieActuelle := 'EUR';
    end;
  end;
  Result := FMonnaieActuelle;
end;

FUNCTION TStdGinKoia.IS98: Boolean;
VAR
  OSVersion: TOSVersionInfo;
BEGIN
  result := false;
  OSVersion.dwOSVersionInfoSize := SizeOf(OSVersion);
  IF GetVersionEx(OSVersion) THEN
  BEGIN
    IF OSVersion.dwPlatformID = VER_PLATFORM_WIN32_WINDOWS THEN
      result := true;
  END;
END;

PROCEDURE TStdGinKoia.DechargeBMP(Panel: TWinControl);

  PROCEDURE Sauve(Panel: TWinControl; tm: Tmemorystream);
  VAR
    i: Integer;
    TC: TControl;
    _tm: TmemoryStream;
    _Size: Integer;
    bt: tbitmap;
  BEGIN
    _tm := TmemoryStream.Create;
    TRY
      FOR i := 0 TO Panel.ControlCount - 1 DO
      BEGIN
        TC := Panel.Controls[i];
        IF (tc IS TBCConvertRV) THEN
        BEGIN
          // ne rien faire
        END
        ELSE IF (tc IS TSpeedButton) THEN
        BEGIN
          IF TSpeedButton(tc).glyph.Empty THEN
          BEGIN
            _Size := 0;
            tm.Write(_Size, sizeof(_Size));
          END
          ELSE
          BEGIN
            bt := tbitmap.create;
            TRY
              bt.assign(TSpeedButton(tc).glyph);
              bt.Savetostream(_tm);
            FINALLY
              bt.free;
            END;
            _Size := _Tm.Size;
            tm.Write(_Size, sizeof(_Size));
            tm.CopyFrom(_tm, 0);
            TSpeedButton(tc).glyph := NIL;
          END;
          _tm.clear;
        END
        ELSE IF (tc IS TLMDCUSTOMSpeedButton) THEN
        BEGIN
          IF TLMDCUSTOMSpeedButton(tc).glyph.Empty THEN
          BEGIN
            _Size := 0;
            tm.Write(_Size, sizeof(_Size));
          END
          ELSE
          BEGIN
            bt := tbitmap.create;
            TRY
              bt.assign(TLMDCUSTOMSpeedButton(tc).glyph);
              bt.Savetostream(_tm);
            FINALLY
              bt.free;
            END;
            _Size := _Tm.Size;
            tm.Write(_Size, sizeof(_Size));
            tm.CopyFrom(_tm, 0);
            TLMDCUSTOMSpeedButton(tc).glyph := NIL;
            _tm.clear;
          END;
        END
        ELSE IF (tc IS TImage) THEN
        BEGIN
          IF Timage(tc).Picture.Bitmap.Empty THEN
          BEGIN
            _Size := 0;
            tm.Write(_Size, sizeof(_Size));
          END
          ELSE
          BEGIN
            bt := tbitmap.create;
            TRY
              bt.assign(Timage(tc).Picture.Bitmap);
              bt.Savetostream(_tm);
            FINALLY
              bt.free;
            END;
            _Size := _Tm.Size;
            tm.Write(_Size, sizeof(_Size));
            tm.CopyFrom(_tm, 0);
            Timage(tc).Picture.Bitmap := NIL;
            _tm.clear;
          END;
        END;
      END;
    FINALLY
      _Tm.Free;
    END;
    FOR i := 0 TO Panel.ControlCount - 1 DO
    BEGIN
      TC := Panel.Controls[i];
      IF Tc IS TWinControl THEN
        Sauve(TWinControl(tc), tm);
    END;
  END;

BEGIN
  LesBitMap.AddObject(Panel.Name, TmemoryStream.Create);
  Sauve(Panel, TmemoryStream(LesBitMap.Objects[LesBitMap.Count - 1]));
END;

FUNCTION TStdGinKoia.chargeBMP(Panel: TWinControl): Boolean;
VAR
  i: Integer;

  PROCEDURE restore(Panel: TWinControl; tm: Tmemorystream);
  VAR
    i: Integer;
    TC: TControl;
    _tm: TmemoryStream;
    _Size: Integer;
    bt: tbitmap;
  BEGIN
    _tm := TmemoryStream.Create;
    TRY
      FOR i := 0 TO Panel.ControlCount - 1 DO
      BEGIN
        TC := Panel.Controls[i];
        IF (tc IS TBCConvertRV) THEN
        BEGIN
          // ne rien faire
        END
        ELSE IF (tc IS TSpeedButton) THEN
        BEGIN
          tm.read(_Size, sizeof(_Size));
          IF _Size > 0 THEN
          BEGIN
            bt := tbitmap.create;
            TRY
              _tm.copyFrom(tm, _Size);
              _Tm.seek(sofrombeginning, 0);
              bt.LoadFromstream(_tm);
              TSpeedButton(tc).glyph := Bt;
            FINALLY
              bt.free;
            END;
            _tm.clear;
          END
        END
        ELSE IF (tc IS TLMDCUSTOMSpeedButton) THEN
        BEGIN
          tm.read(_Size, sizeof(_Size));
          IF _Size > 0 THEN
          BEGIN
            bt := tbitmap.create;
            TRY
              _tm.copyFrom(tm, _Size);
              _Tm.seek(sofrombeginning, 0);
              bt.LoadFromstream(_tm);
              TLMDCUSTOMSpeedButton(tc).glyph := Bt;
            FINALLY
              bt.free;
            END;
            _tm.clear;
          END
        END
        ELSE IF (tc IS TImage) THEN
        BEGIN
          tm.read(_Size, sizeof(_Size));
          IF _Size > 0 THEN
          BEGIN
            bt := tbitmap.create;
            TRY
              _tm.copyFrom(tm, _Size);
              _Tm.seek(sofrombeginning, 0);
              bt.LoadFromstream(_tm);
              Timage(tc).Picture.Bitmap := Bt;
            FINALLY
              bt.free;
            END;
            _tm.clear;
          END
        END;
      END;
    FINALLY
      _Tm.Free;
    END;
    FOR i := 0 TO Panel.ControlCount - 1 DO
    BEGIN
      TC := Panel.Controls[i];
      IF Tc IS TWinControl THEN
        Restore(TWinControl(tc), tm);
    END;
  END;

BEGIN
  result := true;
  TRY
    i := LesBitMap.indexof(Panel.Name);
    IF i <> -1 THEN
    BEGIN
      TmemoryStream(LesBitMap.Objects[i]).Seek(SoFromBeginning, 0);
      restore(Panel, TmemoryStream(LesBitMap.Objects[i]));
      TmemoryStream(LesBitMap.Objects[i]).free;
      LesBitMap.delete(i);
    END;
  EXCEPT
    Result := false;
    LibereBMP(Panel);
  END;
END;

PROCEDURE TStdGinKoia.LibereBMP(Panel: TWinControl);
VAR
  i: Integer;
BEGIN
  IF panel <> NIL THEN
  BEGIN
    i := LesBitMap.indexof(Panel.Name);
    IF i <> -1 THEN
    BEGIN
      TmemoryStream(LesBitMap.Objects[i]).free;
      LesBitMap.delete(i);
    END;
  END;
END;

PROCEDURE TStdGinKoia.InitTestModule;
BEGIN
  { Routine d'exclusion de fonctionnalités ...
    *******************************************
    CFGOFF contient la liste des modules exclus pour le magasin
  }
  Str_Exclude.Strings.Clear;
  FisAlGol := Uppercase(Dm_Uil.CurrentUser) = 'ALGOL';

  TRY
    que_Modules.Close;
    Que_Modules.ParamByName('MAGID').asInteger := stdGinkoia.MagasinID;
    Que_Modules.ParamByName('LADATE').asDateTime := Date;
    Que_Modules.ParamByName('NIVO').asInteger := 3;
    que_Modules.Open;
    WHILE NOT que_Modules.Eof DO
    BEGIN
      IF NOT FisALGOL THEN
        Str_Exclude.Strings.add(Que_ModulesMODULEEXCLU.asstring);
      que_Modules.Next;
    END;
    que_Modules.IB_Transaction.Commit;
  FINALLY
    Que_Modules.Close;
  END;
END;

FUNCTION TStdGinKoia.TestOkModule(Name: STRING): Boolean;
BEGIN
  Name := Uppercase(Name);
  Result := Str_Exclude.Strings.IndexOf(Name) = -1;
END;

FUNCTION TStdGinKoia.NEXTID(ID: INTEGER; NOMTABLE: STRING; OkMess: Boolean = True): INTEGER;
BEGIN
  Result := 0;
  TRY
    Ibc_Next.Close;
    Ibc_Next.ParamByName('ID').asInteger := ID;
    Ibc_Next.ParamByName('TIP').asString := NOMTABLE;
    Ibc_Next.Open;
    Result := ibc_Next.Fields[0].asInteger;
  FINALLY
    IF OkMess AND (Result = 0) THEN
      WaitMessHP(FinFiches, 2, True, 0, 0, '');
    Ibc_Next.Close;
  END
END;

FUNCTION TStdGinKoia.PRIORID(ID: INTEGER; NOMTABLE: STRING; okMess: Boolean = True): INTEGER;
BEGIN
  Result := 0;
  TRY
    Ibc_Prior.Close;
    Ibc_Prior.ParamByName('ID').asInteger := ID;
    Ibc_Prior.ParamByName('TIP').asString := NOMTABLE;
    Ibc_Prior.Open;
    Result := ibc_Prior.Fields[0].asInteger;
  FINALLY
    IF OkMess AND (Result = 0) THEN
      WaitMessHP(DebFiches, 2, True, 0, 0, '');
    Ibc_Prior.Close;
  END
END;

FUNCTION TStdGinKoia.CONTROLESAGE(Text: STRING): STRING;
VAR
  ch, chres: STRING;
BEGIN
  Result := Text;

  IF sageNbre = 0 THEN EXIT; // initialisé à -1 à l'ouverture du programme
  IF SageNbre = -1 THEN
    Sage := IniCtrl.ReadString('PREFIXCB', 'CB', '');

  IF Trim(Sage) <> '' THEN
  BEGIN
    sageNbre := 1;
    IF (Length(Text) = 6) AND (IsNumStr(Text)) THEN
    BEGIN
      ch := Sage + Text;
      IF CD_EAN(ch, Chres) THEN
        Result := ChRes;
    END;
  END
  ELSE SageNbre := 0;

END;

FUNCTION TStdGinKoia.RechArtLOC(Rech: STRING; Client, LibRef, DoMess: Boolean; Virtuel, Archive: Boolean;
  VAR Qry: TIBOQuery; VAR IdClient: integer; OkFicheSecond: Boolean = True; ChronoExclusive: Boolean = False): integer;

VAR
  IdPrin: integer;
BEGIN
  //Si client = True, il faut aussi pouvoir reourner l'id d'un client en recherchant dans
  //Artcodebarrre

  //Si LibRef = True il faut faire une recherche sur
  //Le nom de l'article et sa ref Fournisseur Marque

  // Principe de recherche
  // 1 Dans code barre (si plusieurs enreg entre client et article il faut poser une question)
  // 2 Sur le code chrono
  // 3 Sur Lib & Ref

  idclient := 0;
  result := 0;
  Error_Piccolink := 'RechArtLOC 4808';

  IF Trim(rech) = '' THEN EXIT;
  rech := TrimRight(Rech);

  screen.cursor := crSQLWait;

  IF NOT ChronoExclusive THEN
  BEGIN
    IF rech = '*' THEN
    BEGIN //Rechereche sur toute la table des articles

      Error_Piccolink := 'RechArtLOC 4820';

      Qry.Close;
      Qry.SQL.Clear;
      Qry.SQL.Add('SELECT DISTINCT arl_ID,arl_nom,arl_chrono,arl_calid,cal_nom, arl_datefab, arl_dureevie, ' +
        'tgf_nom,arl_virtuel,cal_reglage,cal_flagass,arl_arlid,cal_tcaid  FROM LOCARTICLE');
      Qry.SQL.Add('JOIN K ON (K_ID=arl_ID AND K_ENABLED=1)');
      Qry.SQL.Add('JOIN LOCCATEGORIE ON (CAL_ID=ARL_CALID)');
      Qry.SQL.Add('JOIN plxtaillesgf on (tgf_id=arl_tgfid)');
      Qry.SQL.Add('WHERE arl_arlid=arl_id and arl_id<>0');
      IF NOT archive THEN
        Qry.SQL.Add('AND arl_archiver<>1');
      IF NOT virtuel THEN
        Qry.SQL.Add('and arl_virtuel<>1');
      Qry.SQL.Add('ORDER BY ARL_CHRONO');

      Qry.open;

      Error_Piccolink := 'RechArtLOC 4838';

      Result := RecUnique(Qry AS TDataset);
      screen.cursor := crDefault;
      Error_Piccolink := '' ;
      Exit; //On a forcement trouve quelque chose -> Exit
    END;

    //Recherche sur le codebarre

    Error_Piccolink := 'RechArtLOC 4847';

    Qry.Close;
    Qry.SQL.Clear;
    Qry.SQL.Add('SELECT DISTINCT ARL_ID,CBI_CLTID,ARL_NOM,arl_chrono,arl_calid,cal_nom, arl_datefab, arl_dureevie, ' +
      'tgf_nom,arl_virtuel,cal_reglage,cal_flagass,arl_arlid,cal_tcaid FROM LOCARTICLE');
    Qry.SQL.Add('JOIN K k2 ON (k2.K_ID=ARL_ID AND K_ENABLED=1)');
    Qry.SQL.Add('JOIN LOCCATEGORIE ON (CAL_ID=ARL_CALID)');
    Qry.SQL.Add('JOIN plxtaillesgf on (tgf_id=arl_tgfid)');
    Qry.SQL.Add('JOIN artcodebarre join k k1 on (k1.K_ID=CBI_ID AND K_ENABLED=1) ON (cbi_arlid=arl_id)');

    IF client THEN
      Qry.SQL.Add('where (cbi_type=2 or cbi_type=4)')
    ELSE
      Qry.SQL.Add('where cbi_type=4');

    Qry.SQL.Add('AND arl_arlid=arl_id and ((arl_id<>0) or (cbi_cltid<>0))');

    IF NOT archive THEN
      Qry.SQL.Add('and arl_archiver<>1');

    IF NOT virtuel THEN
      Qry.SQL.Add('and arl_virtuel<>1');

    Qry.SQL.Add('and cbi_cb=' + QuotedStr(Rech));
    Qry.SQL.Add('ORDER BY ARL_CHRONO');
    Qry.open;

    Error_Piccolink := 'RechArtLOC 4875';

    IF client THEN
    BEGIN
      IF qry.fieldbyname('cbi_cltid').asinteger <> 0 THEN
      BEGIN
        idclient := qry.fieldbyname('cbi_cltid').asinteger;
        result := 1;
        screen.cursor := crDefault;
        Error_Piccolink := '' ;
        EXIT;
      END;
    END;

    result := qry.recordcount;
    IF result <> 0 THEN //On a trouve ce qu'il faut dans
    BEGIN //la table des code barre -> EXIT
      screen.cursor := crDefault;
      Error_Piccolink := '' ;
      EXIT;
    END;
  END;

  Error_Piccolink := 'RechArtLOC 4896';

  //Recherche sur le code chrono
  Qry.Close;
  Qry.SQL.Clear;
  Qry.SQL.Add('SELECT DISTINCT arl_ID,arl_nom,arl_chrono,cal_nom, arl_datefab, arl_dureevie, ' +
    'arl_calid,tgf_nom,arl_virtuel,cal_reglage,cal_flagass, arl_arlid,cal_tcaid  FROM LOCARTICLE');
  Qry.SQL.Add('JOIN K ON (K_ID=arl_ID AND K_ENABLED=1)');
  Qry.SQL.Add('JOIN LOCCATEGORIE ON (CAL_ID=ARL_CALID)');
  Qry.SQL.Add('JOIN plxtaillesgf on (tgf_id=arl_tgfid)');
  Qry.SQL.Add('WHERE ARL_CHRONO=' + QuotedStr(rech));
  Qry.SQL.Add('AND arl_id<>0');
  IF NOT archive THEN
    Qry.SQL.Add('and arl_archiver<>1');
  IF NOT virtuel THEN
    Qry.SQL.Add('and arl_virtuel<>1');

  Qry.open;

  Error_Piccolink := 'RechArtLOC 4915';

  result := qry.recordcount;
  IF result <> 0 THEN //On a trouve ce qu'il faut dans
  BEGIN //les chrono -> EXIT
    IF OkFicheSecond AND (Qry.FieldByName('ARL_ID').asInteger <> Qry.FieldByName('ARL_ARLID').asInteger) THEN
    BEGIN
      Error_Piccolink := 'RechArtLOC 4922';
      idPrin := Qry.FieldByName('ARL_ARLID').asInteger;
      Qry.Close;
      Qry.SQL.Clear;
      Qry.SQL.Add('SELECT DISTINCT arl_ID,arl_nom,arl_chrono,cal_nom, arl_datefab, arl_dureevie, ' +
        'arl_calid,tgf_nom,arl_virtuel,cal_reglage,cal_flagass, arl_arlid,cal_tcaid  FROM LOCARTICLE');
      Qry.SQL.Add('JOIN K ON (K_ID=arl_ID AND K_ENABLED=1)');
      Qry.SQL.Add('JOIN LOCCATEGORIE ON (CAL_ID=ARL_CALID)');
      Qry.SQL.Add('JOIN plxtaillesgf on (tgf_id=arl_tgfid)');
      Qry.SQL.Add('WHERE ARL_ID = ' + IntToStr(IdPrin));
      Qry.SQL.Add('AND arl_arlid=arl_id and arl_id<>0');
      IF NOT archive THEN
        Qry.SQL.Add('and arl_archiver<>1');
      IF NOT virtuel THEN
        Qry.SQL.Add('and arl_virtuel<>1');

      Qry.open; 
      Error_Piccolink := 'RechArtLOC 4939';
      result := 1;
      IF domess THEN WaitMessHP(CdeRechChronoLoc, 2, True, 0, 0, '');
    END;
    screen.cursor := crDefault;
    Error_Piccolink := '' ;
    EXIT;
  END;

  Error_Piccolink := 'RechArtLOC 4947';

  IF NOT ChronoExclusive THEN
  BEGIN
    IF libref THEN
    BEGIN //Recherche sur le Nom,description et refmrk

      Error_Piccolink := 'RechArtLOC 4954';
      Qry.Close;
      Qry.SQL.Clear;
      Qry.SQL.Add('SELECT DISTINCT arl_ID,arl_nom,arl_chrono,cal_nom, arl_datefab, arl_dureevie, ' +
        'arl_calid,tgf_nom,arl_virtuel,cal_reglage,cal_flagass,arl_arlid,cal_tcaid  FROM LOCARTICLE');
      Qry.SQL.Add('JOIN K ON (K_ID=arl_ID AND K_ENABLED=1)');
      Qry.SQL.Add('JOIN LOCCATEGORIE ON (CAL_ID=ARL_CALID)');
      Qry.SQL.Add('JOIN plxtaillesgf on (tgf_id=arl_tgfid)');
      Qry.SQL.Add('WHERE ((ARL_NOM CONTAINING ' + QuotedStr(RECH) +
        ') OR (ARL_DESCRIPTION CONTAINING ' + QuotedStr(RECH) +
        ') OR (ARL_NUMSERIE CONTAINING ' + QuotedStr(RECH ) +
        ')OR (ARL_REFMRK CONTAINING ' + QuotedStr(RECH) + '))');
      Qry.SQL.Add('AND arl_arlid=arl_id and arl_id<>0');
      IF NOT archive THEN
        Qry.SQL.Add('and arl_archiver<>1');
      IF NOT virtuel THEN
        Qry.SQL.Add('and arl_virtuel<>1');

      Qry.SQL.Add('ORDER BY ARL_CHRONO');

      Qry.open;

      Error_Piccolink := 'RechArtLOC 4976';

      result := qry.recordcount;
      IF result <> 0 THEN //On a trouve ce qu'il faut dans
      BEGIN //Nom, description, refmrk -> EXIT
        screen.cursor := crDefault;
        Error_Piccolink := '' ;
        EXIT;
      END;
    END;
  END;
          
  Error_Piccolink := 'RechArtLOC 4987';
  screen.cursor := crDefault;
  IF domess THEN WaitMessHP(CdeRechVide, 2, True, 0, 0, '');
  Error_Piccolink := '' ;
END;

FUNCTION TStdGinKoia.LOCATION: boolean;
BEGIN
  //    Result := TestOkModule('LOCATION');
  Result := False;
  TRY
    Que_AffSec.Close;
    Que_AffSec.ParamByName('TIP').asInteger := 9;
    Que_AffSec.ParamByName('COD').asInteger := 90;
    Que_AffSec.ParamByName('MAGID').asInteger := StdGinkoia.MagasinId;
    Que_AffSec.Open;
    IF NOT Que_AffSec.eof THEN
      Result := Que_AffSecPRM_INTEGER.asInteger = 1;
  FINALLY
    Que_AffSec.Close;
  END;
END;

function TStdGinKoia.SetParam(ACode, AType, AMagID, APosID,
  PrmInteger: integer; PrmFloat: double; PrmString, PrmInfo: String;bNoZeroInt:Boolean=True;bNoZeroFloat:Boolean=True): Boolean;
begin
//bNoZero = False permet d'écrire des valeurs 0 dans les champs PRM_INTEGER et PRM_FLOAT
//bNoZero = True permet de conserver la valeur actuel des champs PRM_INTEGER et PRM_FLOAT si PrmInteger ou PrmFloat = 0

 Result := True;
 With Que_GenParamUpd do
 TRY
   Close;
   ParamByName('PRMCODE').AsInteger := ACode;
   ParamByName('PRMTYPE').AsInteger := AType;
   ParamByName('MAGID').AsInteger := AMagId;
   ParamByName('POSID').AsInteger := APosID;
   Open;

   if Recordcount > 0 then
   begin
     Edit;
    
     if (PrmInteger <> 0) or (Not bNoZeroInt) then
       FieldByName('PRM_INTEGER').AsInteger := PrmInteger;
     if (PrmFloat <> 0) or (Not bNoZeroFloat) then
       FieldByName('PRM_FLOAT').AsFloat     := PrmFloat;

     if PrmString = 'NULL' then
       FieldByName('PRM_STRING').AsString   :=  ''
     else if PrmString <> '' then
       FieldByName('PRM_STRING').AsString   := PrmString;

     if PrmInfo = 'NULL' then
       FieldByName('PRM_INFO').AsString     := ''
     else if PrmInfo <> '' then
       FieldByName('PRM_INFO').AsString     := PrmInfo;
      
     Post;
   end;

 Except on E:Exception do
   Result := False;
 END;
end;

procedure TStdGinKoia.SetMonnaieActuelle(const Value: string);
begin
  FMonnaieActuelle := Value;
end;

procedure TStdGinKoia.SupprimeLesIDDeTmpStat(AListeID: TStrings);
var
  QueTmpCursor: TIB_Cursor;
  sOr: string;
  sWhere: string;
  i: integer;
begin
  if AListeID.Count=0 then
    exit;

  QueTmpCursor := TIB_Cursor.Create(Self);
  try
    QueTmpCursor.IB_Connection := Dm_Main.Database;
    QueTmpCursor.IB_Transaction := Dm_Main.IbT_HorsK;

    // liste des ID à supprimer
    sOr := '';
    sWhere := '';
    for i := 1 to AListeID.Count do
    begin
      if StrToIntDef(AListeID[i-1], 0)<> 0 then
      begin
        sWhere := sWhere+sOr+'TMP_ID='+AListeID[i-1];
        sOr := ' or ';
      end;
    end;

    // execution de la requete
    if sWhere<>'' then
    begin
      QueTmpCursor.SQL.Clear;
      QueTmpCursor.SQL.Add('delete from TMPSTAT');
      QueTmpCursor.SQL.Add('where '+sWhere);
      QueTmpCursor.Execute;
      Dm_Main.IbT_HorsK.Commit;
    end;

  finally
    QueTmpCursor.Close;
    FreeAndNil(QueTmpCursor);         
  end;
end;

FUNCTION TStdGinKoia.UserCanModify(Droit: STRING): Boolean;
BEGIN
  IF Droit = 'YES_PAR_DEFAUT' THEN
    Result := True
  ELSE
    Result := Dm_UIL.HasPermissionVisu(Droit);
END;

FUNCTION TStdGinKoia.UserVisuMags: Boolean;
BEGIN
  Result := (stdGinkoia.NbreMags > 1) AND (Dm_UIL.HasPermissionVisu(UILvoir_mags));
END;

FUNCTION TStdGinKoia.UserVisuStkMM: Boolean;
BEGIN
  Result := UserVisuMags;
  IF (NOT Result) AND (stdGinkoia.NbreMags > 1) THEN
    Result := Dm_UIL.HasPermissionVisu(UILVoir_StockMags);
END;

FUNCTION TStdGinKoia.UserWebVente: Boolean;
BEGIN
  Result := WebVente AND Dm_UIL.HasPermissionVisu(UILGestion_WebVente);
END;

FUNCTION TStdGinkoia.DimPerScreen(Value: Integer): Integer;
VAR
  Pcent: Double;
BEGIN
  { Je travaille ici / à nos écrans de conception en 1024
    On indique la valeur (top, widt, left ...etc affichée dans l'IObjet en conception
    et théoriquement cela retourne la dim voulue en fonction de l'écran courant en execution
  }
  Result := 0;
  IF Value <> 0 THEN
  BEGIN
    Pcent := (Value * 100) / 1024;
    Result := Trunc(screen.Width * (Pcent / 100));
  END;
END;

FUNCTION TStdGinKoia.ChronoModifiable(Chrono: STRING): Boolean;
VAR
  i: Integer;
BEGIN
  i := Pos('-', chrono);
  Result := (i > 0) AND (Copy(chrono, 1, i - 1) = PrefixBase);
  // peut pas modifier fiches importées ni celles des autres magasins

END;

FUNCTION TStdGinKoia.PictureMaskChrono(OnOff: Boolean): STRING;
VAR
  p, ch: STRING;
  i: Integer;
BEGIN
  Result := '';
  IF OnOff THEN
  BEGIN
    P := stdGinkoia.PrefixBase;
    ch := ';';
    FOR i := 1 TO length(p) DO
      ch := ch + p[i] + ';';
    ch := ch + '-#*#';
    Result := ch;
  END;
END;

FUNCTION TStdGinKoia.DureePeriodeMoisJour(Debut, fin: TdateTime): Integer;
BEGIN
  Debut := Trunc(debut);
  Fin := Trunc(Fin);
  WHILE debut > Fin DO Fin := AddYears(Fin, 1);
  Result := DiffDays(debut, fin) + 1;

  //     // ces deux lignes me donnent en fait les dates pour l'année en cours
  //    TRY
  //       Debut := strToDate(formatDateTime('dd/mm', Debut));
  //       Fin := strToDate(formatDateTime('dd/mm', Fin));
  //    Except
  //       Debut := strToDate(formatDateTime('dd/mm/yyyy', Debut));
  //       Fin := strToDate(formatDateTime('dd/mm/yyyy', Fin));
  //    END;
  //     // et si la la date de début est postérieure à la date de Fin alors je rajoute 1 an
  //    IF Debut > Fin THEN
  //        Fin := AddYears(Fin, 1);
  //    result := Trunc(Fin - Debut) + 1;

END;
     
// enregistre le flux XML reçu en erreur dans le répertoire PathErreurXML (donc AFileName ne doit pas contenir de chemin)
procedure TStdGinKoia.EnregistreXMLErreur(AFluxXML, AFileName: string);
var
  LstTmp: TStringList;
begin
  LstTmp := TStringList.Create;
  try
    LstTmp.Text := AFluxXML;
    try
      LstTmp.SaveToFile(PathErreurXML+AFileName);
    except
    end;
  finally
    FreeAndNil(LstTmp);
  end;
end;

FUNCTION TStdGinKoia.NbrRefNKNonTraite: Integer;
BEGIN
  Que_RefGestionNk.Open;
  result := Que_RefGestionNk.recordCount;
  Que_RefGestionNk.Close;
END;

FUNCTION TStdGinKoia.NbrRefPxNonTraite: Integer;
BEGIN
  IbC_PxNonTraite.Open;
  result := IbC_PxNonTraite.FieldByName('Nombre').AsInteger;
  IbC_PxNonTraite.Close;
END;

FUNCTION TStdGinKoia.BlokDate: Boolean;
BEGIN
  IF fBlokDate = -1 THEN
  BEGIN
    Que_Gebuco.Open;
    IF Que_Gebuco.IsEmpty THEN
      fBlokDate := 0
    ELSE
    BEGIN
      fBlokDate := Que_GebucoPRM_INTEGER.AsInteger;
    END;
    Que_Gebuco.Close;
  END;
  Result := fBlokDate = 1;
END;

PROCEDURE TStdGinKoia.Do_OC(Artid: Integer = 0; Chrono: STRING = '');
BEGIN
  Dm_Main.StartTransaction;
  TRY
    IbStProc_OC.Close;
    IbStProc_OC.Prepare;
    IbStProc_OC.ParamByName('Artid').AsInteger := Artid;
    IbStProc_OC.ParamByName('Crono').AsString := Chrono;
    IbStProc_OC.execSql;
    Dm_Main.Commit;
    IbStProc_OC.Unprepare;
    IbStProc_OC.Close;
  EXCEPT
    Dm_Main.Rollback;

  END;
END;

FUNCTION SetFocusHP(Panel: TWinControl; delai: Integer = 0): Boolean;
VAR
  i: Integer;
BEGIN
  IF delai > 0 THEN
  BEGIN
    StdGinkoia.PanFocus := Panel;
    StdGinkoia.Tim_Focus.Interval := Delai;
    stdGinkoia.Tim_Focus.Enabled := TRue;
    result := true;
    EXIT;
  END;

  FOR i := 0 TO 20 DO
  BEGIN
    Result := True;
    TRY
      Sleep(10);
      IF Panel.Visible AND Panel.Enabled THEN Panel.SetFocus;
      BREAK;
    EXCEPT
      Result := False;
    END;
  END;
END;

PROCEDURE TStdGinKoia.Tim_FocusTimer(Sender: TObject);
BEGIN
  Tim_Focus.Enabled := False;
  SetFocusHP(PanFocus, 0);
  PanFocus := NIL;
END;

PROCEDURE TStdGinKoia.CtrlIsParamWebOK;
BEGIN
  TRY
    que_IsParaweb.Close;
    que_IsParaweb.Open;
    FISWEBParamOK := (que_IsParaWebPRM_INTEGER.asInteger <> 0) AND (que_IsParaWebPRM_MagId.asInteger <> 0);
  FINALLY
    que_IsParaWeb.Close;
  END;
END;

PROCEDURE TStdGinKoia.SetCurrentUserId;
BEGIN
  TRY
    Ibc_CurUserId.Close;
    Ibc_CurUserId.ParamByName('USRNOM').asstring := Dm_UIL.CurrentUser;
    Ibc_CurUserId.Open;
    FIdCurUser := Ibc_CurUserId.Fields[0].asInteger;
  FINALLY
    Ibc_CurUserId.Close;
  END
END;

FUNCTION TStdGinKoia.Getreferencementdyna: boolean;
BEGIN
  result := Dm_UIL.HasPermissionModule(ModulWebDyna);
END;

FUNCTION TStdGinKoia.GetReferencement: boolean;
BEGIN
  // Test sur Gendossier à supprimer dès la version 6.1
  IF dm_Uil.Issuper THEN
    result := TRUE
  ELSE
  BEGIN
    result := GetStringParamValue('REFERENCEMENT') = 'OUI';
    IF NOT result THEN
      result := Dm_UIL.HasPermissionModule(ModulRef);
  END;
END;

FUNCTION TStdGinKoia.GetTraiteJournaux: boolean;
BEGIN
  result := False;
  IF Referencement THEN
  BEGIN
    result := (Trunc(GetFloatParamValue('REFER_MAGASIN')) = MagasinID) AND
      (Trunc(GetFloatParamValue('REFER_POSTE')) = PosteID);
  END;
END;

function TStdGinKoia.GetTva(aTVAId: Integer): double;
begin
  Que_TVA.Open;
  if Que_TVA.Locate('TVA_ID', aTVAId, []) then
    result := Que_TVA.FieldByName('TVA_TAUX').asFloat
  else
    result := 0;
end;

FUNCTION TStdGinKoia.GetActiveJetons: integer;
BEGIN
  Result := 0;

  Que_GetActiveJeton.Close;
  TRY
    Que_GetActiveJeton.ParamByName('BASID').AsInteger := BaseID;
    Que_GetActiveJeton.ParamByName('NOMPOSTE').AsString := MyComputerName;
    Que_GetActiveJeton.Open;

    Result := Que_GetActiveJeton.Fields[0].AsInteger;
  EXCEPT
    Result := 0;
  END;
  Que_GetActiveJeton.Close;

  { Fonctionnement :
    Lorsqu'une application tourne, c'est à dire après la validation du mot
    de passe d'entrée un timer tourne en permanence et va toutes les 50 secondes
    mettre un signal dans le fichier ressources.ini situé dans le répertoire
    de la base.
    Ce signal est le nom de la machine suivi de la date/heure courante.

    Pour compter les jetons actifs la règle est simple :
    Je vais lire toutes les rubriques de la section [POSTES]
    Un jeton est considéré comme actif si
    1. son signal est du même jour que la date système
    2. son signal date de moins d'une minute
    3. il émane d'un poste différent ce celui qui interroge

    Si le nombre de jetons actifs est égal ou supérieur à celui de la limite
    autorisée l'entrée n'est pas acceptée. }
END;

FUNCTION TStdGinKoia.GetBonPrepra: boolean;
BEGIN
  //lab 1056 vérifie le droit sur le module Bon de préaration
  IF dm_Uil.Issuper THEN
    result := TRUE
  ELSE
    result := Dm_UIL.HasPermissionModule(ModulBonPrepa);
END;

FUNCTION TStdGinKoia.GetCollection: boolean;
BEGIN
  result := Dm_UIL.HasPermissionModule(ModulCollection);
END;

FUNCTION TStdGinKoia.GetWebVente: boolean;
BEGIN
  IF dm_Uil.Issuper THEN
    result := TRUE
  ELSE
    result := Dm_UIL.HasPermissionModule(ModulWebVente);
  IF result THEN CtrlIsParamWebOK;
END;

FUNCTION TStdGinKoia.GetImp_SP2000: boolean;
BEGIN
  IF dm_Uil.Issuper THEN
    result := TRUE
  ELSE
    result := Dm_UIL.HasPermissionModule(ModulSP2000);
END;

FUNCTION TStdGinKoia.LibCouleur(CODE, NOM: STRING): STRING;
VAR
  ch: STRING;
BEGIN
  ch := TRIM(CODE);

  IF ((ch = '') OR (ch = '-') OR (ch = '.')) THEN
  BEGIN
    ch := TRIM(NOM);
  END
  ELSE BEGIN
    ch := TRIM(CODE + '-' + NOM);
  END;
  IF ((ch = '-') OR (ch = '.') OR (ch = '')) THEN
    result := LabUnicolor
  ELSE
    result := ch;
END;

PROCEDURE TStdGinKoia.TypeArticle_SP2000(ARTID: INTEGER; VAR CATMAN, REFERENCE: Boolean; VAR TYPE_REF: INTEGER);
BEGIN
  // CATMAN : article appartenant à la sélection CATMAN
  //          1=OUI    0=NON
  // REFERENCE : article référencé (et donc retravaillé) par la centrale
  //             1=OUI   0=NON
  // TYPE_REF : type de récupération de l'article
  //            1=Réf. dynamique     2=Intégration CDROM/CATALOGUE      0=Inconnu
  //
  CATMAN := false;
  REFERENCE := false;
  TYPE_REF := 0;

  IbC_ARTSP2000.Close;
  IbC_ARTSP2000.Prepare;
  IbC_ARTSP2000.ParamByName('ARTID').asInteger := ARTID;
  IbC_ARTSP2000.Open;
  IF (IbC_ARTSP2000.RecordCount <> 0) THEN
  BEGIN
    CATMAN := (IbC_ARTSP2000.FieldByName('ART_SUPPRIME').asinteger = 1);
    REFERENCE := (IbC_ARTSP2000.FieldByName('ART_REFREMPLACE').asinteger <> 0);
    TYPE_REF := IbC_ARTSP2000.FieldByName('ART_GARID').asinteger;
  END;
  IbC_ARTSP2000.Close;
END;

FUNCTION TStdGinKoia.ControlePrix_SP2000(ARTID, MRKID, FOUID: INTEGER; VAR PxAchat, PxNet, PxVte: Extended): Boolean;
BEGIN
  // Si le service WEB ne reponds pas ==> RESULT = FALSE
  // Si RESULT=TRUE, les valeurs dans les prix auront un sens !!
  PxAchat := 0;
  PxNet := 0;
  PxVte := 0;
  result := false;
  // Code en attente des info des SPORT 2000
END;

FUNCTION TStdGinKoia.Md5(chaine: STRING): STRING;
BEGIN
  result := md5api.md5(chaine);
END;

PROCEDURE TStdGinKoia.MajGenImport(AGinkId, ACode, AKtb, NewGinkId,
  NewKtb: integer);
BEGIN
  TRY
    Que_MajGenImport.Close;
    Que_MajGenImport.ParamByName('ID').AsInteger := AGinkId;
    Que_MajGenImport.ParamByName('NUM').AsInteger := ACode;
    Que_MajGenImport.ParamByName('KTB').AsInteger := AKtb;
    Que_MajGenImport.Open;
    IF NOT Que_MajGenImport.Eof THEN
    BEGIN
      Que_MajGenImport.Edit;
      Que_MajGenImportIMP_GINKOIA.AsInteger := NewGinkId;
      Que_MajGenImportIMP_KTBID.AsInteger := NewKtb;
      Que_MajGenImport.Post;
    END;
  FINALLY
    Que_MajGenImport.Close;
  END;

END;

FUNCTION TStdGinKoia.GetParam(ACode, AType, AMagID, APosID: integer;
  VAR PrmInteger: integer; VAR PrmFloat: double; VAR PrmString,
  PrmInfo: STRING): boolean;
BEGIN
  Result := True;
  Que_GetParam.Close;
  TRY
    Que_GetParam.ParamByName('PRMCODE').AsInteger := ACode;
    Que_GetParam.ParamByName('PRMTYPE').AsInteger := AType;
    Que_GetParam.ParamByName('MAGID').AsInteger := AMagId;
    Que_GetParam.ParamByName('POSID').AsInteger := APosID;
    Que_GetParam.Open;
    PrmInteger := Que_GetParam.FieldByName('PRM_INTEGER').AsInteger;
    PrmFloat := Que_GetParam.FieldByName('PRM_FLOAT').AsFloat;
    PrmString := Que_GetParam.FieldByName('PRM_STRING').AsString;
    PrmInfo := Que_GetParam.FieldByName('PRM_INFO').AsString;
    Que_GetParam.Close;
  EXCEPT
    ON E: Exception DO
    BEGIN
      Result := False;
    END;
  END;
  Que_GetParam.Close;
END;

FUNCTION TStdGinKoia.GetParamFloat(ACode, AType, AMagID,
  APosID: integer): double;
VAR
  iInt: integer;
  fFlt: double;
  sStr: STRING;
  sInfo: STRING;
BEGIN
  Result := 0;
  TRY
    IF GetParam(ACode, Atype, AMagId, APosID, iInt, fFlt, sStr, sInfo) THEN
      Result := fFlt;
  EXCEPT
  END;
END;

FUNCTION TStdGinKoia.GetParamInteger(ACode, AType, AMagID,
  APosID: integer): integer;
VAR
  iInt: integer;
  fFlt: double;
  sStr: STRING;
  sInfo: STRING;
BEGIN
  Result := 0;
  TRY
    IF GetParam(ACode, Atype, AMagId, APosID, iInt, fFlt, sStr, sInfo) THEN
      Result := iInt;
  EXCEPT
  END;
END;

FUNCTION TStdGinKoia.GetParamString(ACode, AType, AMagID,
  APosID: integer): STRING;
VAR
  iInt: integer;
  fFlt: double;
  sStr: STRING;
  sInfo: STRING;
BEGIN
  Result := '';
  TRY
    IF GetParam(ACode, Atype, AMagId, APosID, iInt, fFlt, sStr, sInfo) THEN
      Result := sStr;
  EXCEPT
  END;
END;

FUNCTION TStdGinKoia.GetParamInfo(ACode, AType, AMagID,
  APosID: integer): STRING;
VAR
  iInt: integer;
  fFlt: double;
  sStr: STRING;
  sInfo: STRING;
BEGIN
  Result := '';
  TRY
    IF GetParam(ACode, Atype, AMagId, APosID, iInt, fFlt, sStr, sInfo) THEN
      Result := sInfo;
  EXCEPT
  END;
END;

FUNCTION TStdGinKoia.lengthMsgGsm(texte: STRING): integer; // FC : 09/03/2009 : Ajout pour Lab
VAR
  tailleGsm, i: integer;
  charGsm: STRING;
BEGIN
  //parcourt le message et calculer la taille gsm pour chaque caractère
  //un caractère gsm pese 1 sauf : 'form feed',{,},[,],~,|,\,€
  tailleGsm := 0;
  charGsm := '{}[]~|\€';
  FOR i := 1 TO length(texte) DO
  BEGIN
    IF pos(texte[i], charGsm) <> 0 THEN
    BEGIN
      tailleGsm := tailleGsm + 2;
    END
    ELSE
    BEGIN
      tailleGsm := tailleGsm + 1;
    END;
  END;
  result := tailleGsm;
END;

FUNCTION TStdGinKoia.creerAdresseLigne(champs1, champs2,
  champs3: STRING): STRING;
VAR
  strAdresse: STRING;
BEGIN
  //Premier ajout
  IF (champs1 <> '') THEN
  BEGIN
    strAdresse := strAdresse + champs1;
  END;
  //deuxième ajout
  IF (champs2 <> '') THEN
  BEGIN
    strAdresse := strAdresse + #10 + champs2;
  END;
  //troisième ajout
  IF (champs3 <> '') THEN
  BEGIN
    strAdresse := strAdresse + #10 + champs3;
  END;
  result := strAdresse;
END;

FUNCTION TStdGinKoia.majClientFidBecol(VAR clt_id: Integer; mode: Integer; numCb: STRING; cltData: TDataCard; VAR cbGinkoia: STRING): boolean;
VAR
  id: Integer;
  retour : boolean;
BEGIN
  //s'il y a des données client :
  retour := false;
    //initialiser la variable globale
  id := -1;
  TRY
    //recopier dans la base l'enregistremetn sélectionné
    IbStProc_LA_BECOL_MAJCLIENT.Close;
    IbStProc_LA_BECOL_MAJCLIENT.Prepared := True;
    //renseigner les variables
    IbStProc_LA_BECOL_MAJCLIENT.ParamByName('MODE').asInteger := mode;
    IbStProc_LA_BECOL_MAJCLIENT.ParamByName('NOM_CLIENT').asString := cltData.sLastName;
    IbStProc_LA_BECOL_MAJCLIENT.ParamByName('PRENOM_CLIENT').asString := cltData.sFirstName;
    IbStProc_LA_BECOL_MAJCLIENT.ParamByName('CIVNOM').asString := cltData.sTitle;
    IbStProc_LA_BECOL_MAJCLIENT.ParamByName('ADRESSE_CLIENT').asString := creerAdresseLigne(cltData.adresse.sAdresse1, cltData.adresse.sAdresse2, cltData.adresse.sAdresse3);
    IbStProc_LA_BECOL_MAJCLIENT.ParamByName('CP_CLIENT').asString := cltData.adresse.sCode;
    IbStProc_LA_BECOL_MAJCLIENT.ParamByName('VILLE_CLIENT').asString := cltData.adresse.sCity;
    IbStProc_LA_BECOL_MAJCLIENT.ParamByName('PAYS_CLIENT').asString := cltData.adresse.sCountry;
    IbStProc_LA_BECOL_MAJCLIENT.ParamByName('EMAIL_CLIENT').asString := cltData.sMail;
    IbStProc_LA_BECOL_MAJCLIENT.ParamByName('TEL_CLIENT').asString := cltData.sPhone;
    IbStProc_LA_BECOL_MAJCLIENT.ParamByName('GSM_CLIENT').asString := cltData.sMobilePhone;
    IbStProc_LA_BECOL_MAJCLIENT.ParamByName('CLTID').asInteger := clt_id;
    IbStProc_LA_BECOL_MAJCLIENT.ParamByName('MAGID').asInteger := StdGinKoia.MagasinID;
    IbStProc_LA_BECOL_MAJCLIENT.ParamByName('POSID').asInteger := StdGinKoia.PosteID;
    IbStProc_LA_BECOL_MAJCLIENT.ParamByName('EAN').asString := numCb;
    IbStProc_LA_BECOL_MAJCLIENT.ParamByName('DTNAISSANCE').asdatetime := cltData.dtBirthDate;
    IbStProc_LA_BECOL_MAJCLIENT.ExecProc;
    //stocker le résultat
    id := IbStProc_LA_BECOL_MAJCLIENT.Fields[0].asInteger;
    IF id <> -1 THEN
    BEGIN
      IbStProc_LA_BECOL_MAJCLIENT.IB_Transaction.commit;
      clt_id := id;
      cbGinkoia := IbStProc_LA_BECOL_MAJCLIENT.Fields[1].asString;
      retour := true;
    END
    ELSE
    BEGIN
      IbStProc_LA_BECOL_MAJCLIENT.IB_Transaction.Rollback;
    END;
    IbStProc_LA_BECOL_MAJCLIENT.unprepare;
  EXCEPT
    ON stan: exception DO
    BEGIN
      IbStProc_LA_BECOL_MAJCLIENT.IB_Transaction.Rollback;
    END;
  END;
  IbStProc_LA_BECOL_MAJCLIENT.unprepare;
  IbStProc_LA_BECOL_MAJCLIENT.Close;
  result := retour;
END;

FUNCTION SendMailFromGrid(DbgDxHp: TdxDbGridHP; sFieldEmail: STRING): Boolean;
VAR
  lstMail,
    lstFileList: TStringList;

  i: integer;
  OutlookMail: variant;

  SmtpServer: STRING;
  SmtpPort: Integer;
  SmtpPsw: STRING;

  CfgEmetteur: STRING;
  AdrMagasin: STRING;

  Email: TIdEMailAddressItem;
BEGIN
  Result := False;
  // Récupération de la liste des emails des clients
  lstMail := TStringList.create;
  TRY
    WITH DbgDxHp DO
    BEGIN
      IF SelectedCount > 0 THEN
        FOR i := 0 TO SelectedCount - 1 DO
        BEGIN
          lstMail.Add(GetValueByFieldName(SelectedNodes[I], sFieldEmail));
        END; // if
    END; // with

    // Ouverture de la fiche de saisie des mails
    WITH TFrm_RapMail.Create(DbgDxHp.Owner) DO
    TRY
      // ajout de la liste des clients sélectionnés dans zone de texte de destinataire
      FOR i := 0 TO lstMail.Count - 1 DO
        IF Trim(lstMail[i]) <> '' THEN
          Chp_Destinataires.Text := Chp_Destinataires.Text + lstMail[i] + ';';

      CASE ShowModal OF
        mrOk: BEGIN // si on valide on traite la mailling
            // récupération des informations de compte mail du magasin
            // Test si Outlook ou AutoMail
            Que_ParamTypeMail.ParamByName('POSID').AsInteger := StdGinKoia.PosteID;
            Que_ParamTypeMail.Open;

            IF Que_ParamTypeMail.RecordCount <> 1 THEN
            BEGIN
              InfoMessHP('Erreur lecture du PosteID', True, 0, 0, 'Erreur');
              Que_ParamTypeMail.Close;
              result := false;
              EXIT;
            END; // if

            IF Que_ParamTypeMailPRM_INTEGER.AsInteger = 1 THEN
              // Envoi Outlook
            BEGIN
              TRY
                // http://msdn.microsoft.com/en-us/library/bb208403.aspx (Aide m$ pour mail outlook)
                Custom_OutlookConnect.Connected := True;
                OutLookMail := Custom_OutlookConnect.Outbox.Items.Add;

                OutlookMail.BCC := Chp_Destinataires.Text;
                OutlookMail.Subject := Chp_Objet.Text;
                OutLookMail.Body := Custom_Commentaires.Text;
                IF Chp_PiecesJointes.Text <> '' THEN
                BEGIN
                  OutlookMail.Attachments.Add(Chp_PiecesJointes.Text);
                END; //if
                OutlookMail.Save;
                OutlookMail.Display;
              EXCEPT
                //InfoMessHP('Erreur Outlook', True, 0, 0, 'Erreur');
              END; // try
            END // if
            ELSE BEGIN
              // Envoi des mails via Indy

              // Lecture des parametres du MailAuto
              Que_ParamMailAuto.ParamByName('MAGID').AsInteger := StdGinkoia.MagasinID;
              Que_ParamMailAuto.Open;

              IF Que_ParamMailAuto.RecordCount <> 1 THEN
              BEGIN
                InfoMessHP('Erreur lecture du MagasinID', True, 0, 0, 'Erreur');
                Que_ParamTypeMail.Close;
                Que_ParamMailAuto.Close;
                result := false;
                EXIT;
              END; // if

              // Lecture Adresse Mail du Magasin
              Que_GetMailMagasin.ParamByName('MAGID').AsInteger := StdGinkoia.MagasinID;
              ;
              Que_GetMailMagasin.Open;

              IF (Que_GetMailMagasin.RecordCount <> 1) OR (Que_GetMailMagasinADR_EMAIL.AsString = '') THEN
              BEGIN
                InfoMessHP('Adresse Mail du magasin incomplète...', True, 0, 0, 'Erreur');
                Que_ParamTypeMail.Close;
                Que_ParamMailAuto.Close;
                Que_GetMailMagasin.Close;
                result := false;
                EXIT;
              END; // if

              //récupèrer la config
              SmtpServer := Que_ParamMailAutoPRM_STRING.AsString;
              SmtpPort := Que_ParamMailAutoPRM_INTEGER.AsInteger;
              SmtpPsw := Que_ParamMailAutoPSW_SMTP.asString;
              CfgEmetteur := Que_ParamMailAutoPRM_INFO.AsString;
              AdrMagasin := Que_GetMailMagasinADR_EMAIL.AsString;
              Que_ParamTypeMail.Close;
              Que_ParamMailAuto.Close;
              Que_GetMailMagasin.Close;

              WITH idSMTP DO
              BEGIN
                Host := SmtpServer;
                Port := SmtpPort;

                IF CfgEmetteur <> '' THEN
                BEGIN
                  AuthType := satDefault;
                  Username := CfgEmetteur;
                  Password := SmtpPsw;
                END // if
                ELSE
                  AuthType := satNone;
              END; //with

              WITH IdMessage DO
              BEGIN
                Clear;
                Body.Clear;
                Body.Text := Custom_Commentaires.text;
                From.Text := AdrMagasin;

                // Ajout de la liste des mails client (en mode hidden) au mail
                FOR i := 0 TO lstMail.Count - 1 DO
                BEGIN
                  IF Trim(lstMail[i]) <> '' THEN
                  BEGIN
                    Email := BccList.Add;
                    Email.Address := lstMail[i];
                  END; // if
                END; // for

                // ajout des pieces jointes au mail
                IF Trim(Chp_PiecesJointes.Text) <> '' THEN
                BEGIN
                  lstFileList := TStringList.Create;
                  TRY
                    lstFileList.Text := Chp_PiecesJointes.Text;
                    lstFileList.Text := StringReplace(lstFileList.Text, ';', #13#10, [rfReplaceAll]);
                    FOR i := 0 TO lstFileList.Count - 1 DO
                      IF Trim(lstFileList[i]) <> '' THEN
                        TIdAttachmentFile.Create(MessageParts, lstFileList[i]);
                  FINALLY
                    lstFileList.Free;
                  END; // try
                END; // if
              END; // with idmess

              TRY
                IdSMTP.Connect();
              EXCEPT
                InfoMessHP('Erreur de connection au serveur de messagerie', True, 0, 0, 'Erreur');
                result := false;
                EXIT;
              END;

              // === Tout est OK ===
              TRY
                IdSMTP.Send(IdMessage);
              EXCEPT
                // === Ne devrait normalement pas se produire ===
                InfoMessHP('Erreur SendMail', True, 0, 0, 'Erreur');
                result := false;
                EXIT;
              END;

              IdSMTP.Disconnect();
              Result := True;
            END; // else

          END; // mrOk
        mrCancel: exit; // si on annule la fichier on quitte
      END; // case

    FINALLY
      Release; // libération de la fiche mail
    END; // with try
  FINALLY
    lstMail.Free;
  END; // try
END;

FUNCTION SendSmsFromGrid(DbgDxHp: TdxDbGridHP; sFieldGsm: STRING): Boolean;
VAR
  sendService: ISendService2; //service d'envoi sms Esendex
  AccountService: IAccountService; //etat du compte
  EUserName, EPassword, EAccount: STRING;

  sTelTmp: STRING;
  sSmsMsg: STRING;
  sRetour: STRING;

  i, iNbSmsRestant, iError: integer;
  lstTel: TStringList;
BEGIN
  Result := False;
  // récupération des informations du compte sms
  WITH TIboQuery.Create(DbgDxHp.Owner) DO
  TRY
    Close;
    SQL.Add('select prm_id,prm_string, prm_info,prm_integer,prm_magid');
    SQL.Add('from genparam');
    SQL.Add('join K on (K_id=prm_id and K_enabled=1)');
    SQL.Add('where prm_code=50 and prm_type=3');
    SQL.Add('and prm_magid=:magid;');
    ParamCheck := True;
    ParambyName('magid').value := StdGinKoia.MagasinID;
    TRY
      Open;
    EXCEPT ON E: Exception DO
        InfoMessHP('Problème de récupération des informations du compte sms : ' + E.Message, True, 0, 0, 'Erreur');
    END; // try Ex

    IF RecordCount > 0 THEN
    BEGIN
      IF FieldByName('PRM_INTEGER').AsInteger <> 1 THEN
      BEGIN
        InfoMessHP(errSms + 'le compte est inactif', true, 0, 0, '');
        Exit;
      END; // if

      //découpage des paramètres
      WITH TStringList.Create DO
      TRY
        Text := FieldByName('Prm_String').AsString;
        Text := StringReplace(Text, ';', #13#10, [rfReplaceAll]);
        EUserName := Strings[0];
        EPassword := Strings[1];
        EAccount := FieldByName('PRM_INFO').AsString;
      FINALLY
        Free; // libération de la listbox
      END; // With Try

      IF (Trim(EUserName) = '') OR (Trim(EPassword) = '') AND (Trim(EAccount) = '') THEN
      BEGIN
        InfoMessHP(errSms + 'paramètrage de compte incomplet', True, 0, 0, 'Configuration nécessaire');
        Exit;
      END; // if
    END; // if
  FINALLY
    Free; // Libération de la Query
  END; // With Try

  LstTel := TStringList.Create;
  TRY
    // Récupération de la liste des numéros de téléphonne des clients sélectionnés.
    WITH DbgDxHp DO
    BEGIN
      IF SelectedCount > 0 THEN
        FOR i := 0 TO SelectedCount - 1 DO
        BEGIN
          sTelTmp := GetValueByFieldName(SelectedNodes[I], sFieldGsm);
          IF isCellulaire(sTelTmp) THEN
            lstTel.Add(sTelTmp);
        END; // For
    END; // with

    IF lstTel.Count > 0 THEN
    BEGIN
      WITH TFrm_SavMessageSms.Create(NIL) DO
      TRY
        // ouverture de la fenêtre de saisie du SMS
        IF ExecuteSavMessageSms(sSmsMsg, True) THEN
        BEGIN
          // Envoi des SMS
          CoInitialize(NIL);
          TRY
            AccountService := CoAccountService.create;
            AccountService.Initialise(EUsername, EPassword, EAccount, '0');
            iNbSmsRestant := AccountService.GetMessageLimit;

            // vérification que le nombre de sms à envoyer ne dépasse pas les sms restants du forfait
            IF iNbSmsRestant < lstTel.Count THEN
            BEGIN
              InfoMessHP(Format(msgNotEnoughSms, [IntToStr(iNbSmsRestant), IntToStr(lstTel.Count)]), True, 0, 0, 'Erreur');
              Exit;
            END; // if

            // Envoi des sms
            iError := 0;
            FOR i := 0 TO lstTel.Count - 1 DO
            BEGIN
              SendService := CoSendService2.Create;
              SendService.Initialise(EUsername, EPassword, EAccount, '0');
              //sRetour est un identifiant unique pour le message chez Esendex. Même pour un faux numéro ....(0601010101)
              TRY
                sRetour := SendService.SendMessage(lstTel[i], sSmsMsg, MESSAGE_TYPE_TEXT);
              EXCEPT
                inc(iError);
              END; // try ex
            END; // for

            // Récupère le nombre de sms restant
            iNbSmsRestant := AccountService.GetMessageLimit;
            InfoMessHP(Format(msgIsRemainSms, [IntToStr(iNbSmsRestant)]), True, 0, 0, 'Information');
            Result := True;
          FINALLY
            CoUninitialize;
          END; // try
        END; // if
      FINALLY
        Release;
      END; // With Try
    END // if
    ELSE BEGIN
      InfoMessHP(msgNoGsmFound, True, 0, 0, 'Informations');
    END;
  FINALLY
    lstTel.Free;
  END; // try
END;

FUNCTION isCellulaire(VAR numCell: STRING): boolean;
VAR
  retour: boolean;
  newNumCell: STRING;
  i: Integer;
BEGIN
  retour := false;
  //numéro international valide chez Esendex : 336 ou 00336 ou +336
  //nous le formaterons toujours 336...
  //selon la numérotation téléphonique E.164 un numéro internationnal ne peut excèder 15 chiffres
  //par précaution nous fixerons arbitrairement le mini à 10
  newNumCell := '';
  //parcourir caractère par caractère la chaine pour ne conserver que les chiffres
  FOR i := 1 TO length(numcell) DO
  BEGIN
    //si chiffre entre 0 et 9
    IF (ord(numCell[i]) >= 48) AND (ord(numCell[i]) <= 57) THEN
    BEGIN
      newNumCell := newNumCell + numCell[i];
    END;
  END;
  // si au moins 10 chiffres et au plus 15
  IF (length(newNumCell) >= 10) AND (length(newNumCell) < 16) THEN
  BEGIN
    numCell := newNumCell;
    retour := true;
  END
  ELSE
  BEGIN
    numCell := '';
  END;
  result := retour;
END;

Procedure TStdGinKoia.Log(FileLogName,Texte:String);
Var
  LogFile       : TextFile;   //Variable d'accès au fichier
  Chemin        : String;     //Chemin du fichier de log
Begin
  ForceDirectories(IncludeTrailingPathDelimiter(ExtractFilePath(Chemin)));
  AssignFile(LogFile,Chemin+FileLogName);
  if Not FileExists(Chemin+FileLogName) then
    ReWrite(LogFile)
  else
    Append(LogFile);
  try
    Writeln(LogFile,Texte);
  finally
    CloseFile(LogFile);
  end;
End;

Function TStdGinkoia.ChoixRefDyn:Integer;
//Fonction permettant de choisir la base de recherche du référencement dynamique
Var
  UrlAppel  : String;      //Url d'ancien référencement
Begin
    //Init
    Result  := 0;

    //Vide le MemData
    MemD_RefDyn_LstBases.Close;
    MemD_RefDyn_LstBases.Open;

    //Recherche d'ancien référencement
    UrlAppel := StdGinKoia.GetParamString(51,5,StdGinkoia.MagasinID);

    //Ajoute la base Sport2000
    IF ((pos(Uppercase('codeapp=3'), uppercase(UrlAppel)) > 0) OR
       (pos(Uppercase('codeapp=4'), uppercase(UrlAppel)) > 0)) THEN
    BEGIN
      MemD_RefDyn_LstBases.Append;
      MemD_RefDyn_LstBases.FieldByName('RED_ID').asInteger   := -1;
      MemD_RefDyn_LstBases.FieldByName('RED_NOM').asString   := RS_TXT_REFGIN_SP2000;
      MemD_RefDyn_LstBases.FieldByName('RED_URL').asString   := UrlAppel;
      MemD_RefDyn_LstBases.FieldByName('RED_NUM').asInteger  := 4;
      MemD_RefDyn_LstBases.FieldByName('RED_TYPE').asInteger := 1;
      MemD_RefDyn_LstBases.FieldByName('RED_URL2').asString  := '';
      MemD_RefDyn_LstBases.post;
    END;

    //Ajoute la base InterSport
    IF pos(Uppercase('http://ginkoia.yellis.net/'), uppercase(UrlAppel)) > 0 THEN
    BEGIN
      MemD_RefDyn_LstBases.Append;
      MemD_RefDyn_LstBases.FieldByName('RED_ID').asInteger   := -2;
      MemD_RefDyn_LstBases.FieldByName('RED_NOM').asString   := RS_TXT_REFGIN_INTERSPORT;
      MemD_RefDyn_LstBases.FieldByName('RED_URL').asString   := UrlAppel;
      MemD_RefDyn_LstBases.FieldByName('RED_NUM').asInteger  := 10;
      MemD_RefDyn_LstBases.FieldByName('RED_TYPE').asInteger := 2;
      MemD_RefDyn_LstBases.FieldByName('RED_URL2').asString  := '';
      MemD_RefDyn_LstBases.post;
    END;

    //Liste les bases de référencement
    if StdGinkoia.GetParamInteger(54, 5, StdGinkoia.MagasinID, StdGinkoia.PosteID)=1 then
    begin
      Que_RefDyn_Param.Close;
      Que_RefDyn_Param.Open;
      while Not Que_RefDyn_Param.eof do
      begin
        MemD_RefDyn_LstBases.Append;
        MemD_RefDyn_LstBases.FieldByName('RED_ID').asInteger   := Que_RefDyn_Param.FieldByName('RED_ID').asInteger;
        MemD_RefDyn_LstBases.FieldByName('RED_NOM').asString   := Que_RefDyn_Param.FieldByName('RED_NOM').asString;
        MemD_RefDyn_LstBases.FieldByName('RED_URL').asString   := Que_RefDyn_Param.FieldByName('RED_URL').asString;
        MemD_RefDyn_LstBases.FieldByName('RED_NUM').asInteger  := Que_RefDyn_Param.FieldByName('RED_NUM').asInteger;
        MemD_RefDyn_LstBases.FieldByName('RED_TYPE').asInteger := Que_RefDyn_Param.FieldByName('RED_TYPE').asInteger;
        MemD_RefDyn_LstBases.FieldByName('RED_URL2').asString  := Que_RefDyn_Param.FieldByName('RED_URL2').asString;
        MemD_RefDyn_LstBases.post;
        Que_RefDyn_Param.next;
      end;
    end;

    //Si plusieur base de référencement peuvent être sélectionnée on affiche la liste
    if (MemD_RefDyn_LstBases.RecordCount>1) then
    Begin
      MemD_RefDyn_LstBases.first;
      If LK_RefDyn_LstBases.Execute then
        Result  := MemD_RefDyn_LstBases.FieldByName('RED_ID').asInteger;
    End;

    //Si 1 seule base de référencement est paramétrée on effectue la recherche sur celle-ci
    if (MemD_RefDyn_LstBases.RecordCount=1) then
    Begin
      Result  := MemD_RefDyn_LstBases.FieldByName('RED_ID').asInteger;
    End;
End;

{ TCarteCadeau }

procedure TCarteCadeau.LoadParam;
var
  MAG_ID : Integer;
begin
  With StdGinKoia do
  begin
    MAG_ID := MagasinID;

    if Dm_Uil.HasPermissionModuleSansSuperUser(UILModuleCRDSVS) then
      TypeCC := tcc_SVS
    else if Dm_Uil.HasPermissionModuleSansSuperUser(UILModuleCRDProsodie) then
      TypeCC := tcc_Prosodie
    else if Dm_Uil.HasPermissionModuleSansSuperUser(UILModuleCRDCOURRIR) then
      TypeCC := tcc_Courrir
    else if Dm_Uil.HasPermissionModuleSansSuperUser(UILModuleCRDISF) then
      TypeCC := tcc_ISF
    else
      TypeCC := tcc_Generique;
    
    PseudoID := GetParamInteger(1, 13, MAG_ID);
    ModEncID := GetParamInteger(2, 13, MAG_ID);
    Devise := GetParamString(3, 13, MAG_ID);
    MerchantName := GetParamString(4, 13, MAG_ID);
    MerchantNumber := GetParamString(5, 13, MAG_ID);
    StoreNumber := MagasinCodeAdh;
    TelSVI := GetParamString (6, 13, MAG_ID);
    PxMin := GetParamInteger(7, 13, MAG_ID);
    PxMax := Trunc(GetParamFloat(7, 13, MAG_ID));
    Login := GetParamString(8, 13, MAG_ID);
    PassWord := GetParamString(9, 13, MAG_ID);
    RoutingID := GetParamString(10, 13, MAG_ID);
    ClientId := GetParamInteger(11, 13, MAG_ID);
    SSFamilleID := GetParamInteger(12, 13, MAG_ID);
    NbArtSSFam := GetNbArticleSSFamille(SSFamilleID);
    Frequence := TFrequenceFacturation(GetParamInteger(13, 13, MAG_ID));
    OrganismeCollecteur := GetParamInteger(14, 13, MAG_ID);
    UrlWebService := Trim(GetParamString(15,13,MAG_ID));
    Certificat := (GetParamInteger(15,13,MAG_ID) = 1);

    TimeOutSolde := GetParamInteger(8, 13, MAG_ID) * 1000;
    if TimeOutSolde = 0 then
      TimeOutSolde := 15000;
    TimeOutOther := GetParamInteger(9, 13, MAG_ID) * 1000;
    if TimeOutOther = 0 then
      TimeOutOther := 15000;

    AcompteWebClientID := GetParamInteger(24,16,MAG_ID);

    if (TypeCC = tcc_SVS) and (Trim(UrlWebService) = '') then
      UrlWebService := 'https://webservices.storedvalue.com:443/svsxml/services/SVSXMLWay';
    if (TypeCC = tcc_Generique) and (Frequence <> ff_CompteClient) then
      Frequence := ff_CompteClient;

    TestMode := (IniCtrl.ReadInteger('CCSVS','TESTMODE',0) = 1);
  end;
end;

function TCarteCadeau.GetNbArticleSSFamille(SSFID : integer) : Integer;
var
  lQue_Tmp: TIB_Query;
begin;
  result := 0;
  lQue_Tmp := TIB_Query.Create (nil);
  try
    lQue_Tmp.IB_Connection := Dm_Main.Database;
    lQue_Tmp.IB_Transaction := Dm_Main.IbT_Select;
    lQue_Tmp.Sql.Add ('select count(*) Nb from artarticle ');
    lQue_Tmp.Sql.Add ('join k on k_id = art_id and k_enabled = 1 ');
    lQue_Tmp.Sql.Add ('join artreference on art_id = arf_artid ');
    lQue_Tmp.Sql.Add ('join artrelationaxe on arx_artid = art_id ');
    lQue_Tmp.Sql.Add ('join nklssfamille on arx_ssfid = ssf_id ');
    lQue_Tmp.Sql.Add ('where ssf_id = :SSFID ');
    lQue_Tmp.Sql.Add ('and arf_virtuel = 1 ');
    lQue_Tmp.Sql.Add ('and arf_archiver = 0 ');
    lQue_Tmp.ParamByName ('SSFID').AsInteger := SSFID;
    lQue_Tmp.Open;
    result := lQue_Tmp.FieldByName ('Nb').AsInteger;
  finally;
    lQue_Tmp.Free;
  end;
end;

// Vérifie si la structure du code barre correspond à un code de type client
// Renvoie true si code barre client
// Seul le code barre Intersport est vérifié
function CodeBarreTypeClient (aCode: string): boolean;
begin;
  result := true;
  if (Length (aCode) <> 16)
  or (luhn (aCode) = false)
  or (Copy (aCode, 1, 5) <> '00000') then
    result := false;
end;

function luhn(arg: string): boolean;
var
  i, sum: integer;
  temp: byte;
begin
  sum := 0;
  for i:= length(arg) downto 1 do begin  // Run the characters backwards
    temp := byte(arg[i])-48;             // Convert from ASCII to byte
    if (length(arg)-i) mod 2 = 0
      then sum := sum + temp             // Odd characters just add
      else if temp < 5
         then sum := sum + 2*temp        // Even characters add double
         else sum := sum + (2*temp)-9;   // or sum the digits of the doubling
  end;
  result := sum mod 10 = 0;              // Return true if sum ends in a 0
end;

// La function permet de tester si un client dépasse son ancours avec  le montant indiqueé
// Renvoie 0 si l'encours client n'est pas dépassé
// Renvoie l'encours autorisé si le max encours est dépassé
function MaxEncoursAtteint (aMontant: currency; aClientId, aMagId: integer): currency;
var
  lQue_Tmp: TIB_Query;
begin;

  result := 0;

  // Création d'une requète provisoire
  lQue_Tmp := TIB_Query.Create (nil);
  try
    lQue_Tmp.IB_Connection := Dm_Main.Database;
    lQue_Tmp.IB_Transaction := Dm_Main.IbT_Select;

    lQue_Tmp.Sql.Add ('Select SOLDECPT, BLNONFACT, CLT_MAXENCOURS, CLT_CTRLSOLDECPT from Pr_CltDernPass (:CLT_ID, :MAG_ID )');
    lQue_Tmp.Sql.Add ('join CLTCLIENT on clt_id = :clt_id');

    // Récupère le solde et l'encours actuel
    lQue_Tmp.ParamByName ('CLT_ID').AsInteger := aClientId;
    lQue_Tmp.ParamByName ('MAG_ID').AsInteger := aMagId;
    lQue_Tmp.Open;

    // Vérification de l'encours
    if (lQue_Tmp.fieldbyname('CLT_CTRLSOLDECPT').AsInteger = 1)// Test si le controle de l'encours est actif sur ce client
    and ( (aMontant - lQue_Tmp.FieldByName ('SOLDECPT').AsFloat + lQue_Tmp.FieldByName ('BLNONFACT').AsFloat) > lQue_Tmp.FieldByName ('CLT_MAXENCOURS').AsFloat) then
      result := lQue_Tmp.FieldByName ('CLT_MAXENCOURS').AsFloat;// Encours dépassé

  finally;
  end;

  // Restitution ressource
  lQue_Tmp.Free;
end;

//JB
function SecToTime(Sec: Integer): string;
var H, M, S: string;
    ZH, ZM, ZS: Integer;
begin
   ZH := Sec div 3600;
   ZM := Sec div 60 - ZH * 60;
   ZS := Sec - (ZH * 3600 + ZM * 60) ;
   H := Format('%.2d',[ZH]) ;
   M := Format('%.2d',[ZM]) ;
   S := Format('%.2d',[ZS]) ;
   Result := H + ':' + M + ':' + S;
end;

function EnteteFichierLogStats(DateTimeDebut, DateTimeFin : TDateTime; TransactionName, Duree : String) : String;
var
  AString, BaseCentrale : String;
  QueTmp: TIBOQuery;
begin
  QueTmp := TIBOQuery.Create(nil);
  try
    QueTmp.IB_Connection := Dm_Main.Database;
    QueTmp.IB_Transaction := Dm_Main.IbT_HorsK;
    QueTmp.Close;
    QueTmp.SQL.Clear;
    QueTmp.SQL.Add('select BAS_CENTRALE from GENBASES');
    QueTmp.SQL.Add('where BAS_ID=' + Inttostr(StdGinKoia.BaseID));
    QueTmp.Open;
    BaseCentrale := QueTmp.Fieldbyname('BAS_CENTRALE').AsString;
  finally
    QueTmp.Close;
    FreeAndNil(QueTmp);
  end;

  AString := FormatDateTime('yyyy/mm/dd hh:nn:ss',DateTimeDebut);
  AString := AString + ';' + StringReplace(Trim(TransactionName),';','',[rfReplaceAll]);
  AString := AString + ';' + FormatDateTime('yyyy/mm/dd hh:nn:ss',DateTimeFin);
  AString := AString + ';' + Trim(Duree);
  AString := AString + ';' + Trim(BaseCentrale);
// AString := AString + ';' + Trim(StdGinKoia.MagasinName);
  AString := AString + ';' + Trim(StdGinKoia.MagasinEnseigne);
  AString := AString + ';' + Dm_Main.GetNomCommSoft;
  Result := AString;
end;
//

procedure TStdGinKoia.Que_ArchiveStagiaireUCPAAfterPost(DataSet: TDataSet);
begin
  Dm_Main.IBOUpDateCache ( DataSet As TIBOQuery) ;
end;

procedure TStdGinKoia.Que_ArchiveStagiaireUCPABeforeDelete(DataSet: TDataSet);
begin
  if not Dm_Main.CheckAllowDelete ( ( DataSet As TIBODataSet).KeyRelation,
  DataSet.FieldByName(( DataSet As TIBODataSet).KeyLinks.IndexNames[0]).AsString,
  True ) then Abort;
end;

procedure TStdGinKoia.Que_ArchiveStagiaireUCPABeforeEdit(DataSet: TDataSet);
begin
  if not Dm_Main.CheckAllowEdit ( ( DataSet As TIBODataSet).KeyRelation,
  DataSet.FieldByName(( DataSet As TIBODataSet).KeyLinks.IndexNames[0]).AsString,
  True ) then Abort;
end;

procedure TStdGinKoia.Que_ArchiveStagiaireUCPANewRecord(DataSet: TDataSet);
begin
  if not Dm_Main.IBOMajPkKey ( ( DataSet As TIBODataSet),
  ( DataSet As TIBODataSet).KeyLinks.IndexNames[0] ) then Abort;
end;

procedure TStdGinKoia.Que_ArchiveStagiaireUCPAUpdateRecord(DataSet: TDataSet; UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
  Dm_Main.IBOUpdateRecord ( ( DataSet As TIBODataSet).KeyRelation,
                          ( DataSet As TIBODataSet),UpdateKind, UpdateAction );
end;
//------------------------------------------------------------------------------
procedure TStdGinKoia.checkCentralModules ;
var
    iNbCentrale : Integer ;
begin
    bModuleIntersport := Dm_Uil.HasPermissionModule(UILModuleInterSport) ;
    bModuleCourir     := Dm_Uil.HasPermissionModule(UILModuleCourir) ;
    bModuleGoSport    := Dm_Uil.HasPermissionModule(UILModuleGoSport) ;
    bModuleSport2000  := Dm_Uil.HasPermissionModule(UILModuleSP2K) ;

    iNbCentrale := 0 ;
    if bModuleIntersport then Inc( iNbCentrale ) ;
    if bModuleCourir     then Inc( iNbCentrale ) ;
    if bModuleGoSport    then Inc( iNbCentrale ) ;
    if bModuleSport2000  then Inc( iNbCentrale ) ;

    if (iNbCentrale > 1) then
    begin
        InfoMess('Attention', 'Plusieurs modules centrale sont activés en même temps. Veuillez contacter Ginkoia pour corriger le problème.') ;
    end;
end;
//------------------------------------------------------------------------------
procedure TStdGinKoia.checkCrossCanal ;
begin
    bModuleCrossCanal := Dm_Uil.HasPermissionModule(UILModuleCrossCanal) ;
end;
//------------------------------------------------------------------------------
function TStdGinKoia.getTypeModeleStr(aCentrale: integer ; isSp2000:boolean = false ;  isCatman : Boolean = false): string;
begin
    Result := 'Modèle' ;

    if ((Fref_dyna_sp2000) and (aCentrale = 0)) then
    begin
        if isSp2000
          then Result := RS_TYPEMODELE_RefSP2000 ;
        if isCatman
          then Result := RS_TYPEMODELE_Catman ;
    end;
    

    if bModuleIntersport then
    begin
        case aCentrale of
            0:  Result := RS_TYPEMODELE_Modele ;
            1:  Result := RS_TYPEMODELE_ModeleISF ;
            5:  Result := RS_TYPEMODELE_ModeleLocal ;
        end;
    end;

    if bModuleCourir then
    begin
        case aCentrale of
            0:  Result := RS_TYPEMODELE_ModeleCompl ;
            6:  Result := RS_TYPEMODELE_ModeleCourir ;
        end;
    end;

    if bModuleGoSport then
    begin
        case aCentrale of
            0:  Result := RS_TYPEMODELE_ModeleCompl ;
            7:  Result := RS_TYPEMODELE_ModeleGoSport ;
            8:  Result := RS_TYPEMODELE_ModeleInt ;
        end;
    end;
end;
//------------------------------------------------------------------------------
//JB
function TStdGinKoia.SaveOrLoadDBGGrilleConfiguration(SaveOrLoad : Boolean;aDBGGrille : TdxDBGridHP; var OldConfig : Boolean) : Boolean;
begin
  Application.createform(TFrm_SaveLoadDbgConfig, Frm_SaveLoadDbgConfig);
  TRY
    Result := False;
    if Frm_SaveLoadDbgConfig.SaveOrLoadDBGGrilleConfig(SaveOrLoad, aDBGGrille) then
    begin
      if Frm_SaveLoadDbgConfig.Showmodal = mrOK
      then Result := True;
      if SaveOrLoad = False
      then OldConfig :=  Frm_SaveLoadDbgConfig.IsOldConfig;
    end;
  FINALLY
    Frm_SaveLoadDbgConfig.Release;
  END;
end;

//------------------------------------------------------------------------------

END.


