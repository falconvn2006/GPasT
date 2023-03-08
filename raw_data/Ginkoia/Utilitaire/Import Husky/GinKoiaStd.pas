{***************************************************************
 *
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
    Windows,
    Printers,
    Messages,
    SysUtils,
    Classes,
    Graphics,
    Controls,
    Forms,
    Dialogs,
    IBDataset,
    TypInfo,
    Inifiles,       // unité utilisée dans le code
    FileCtrl,       // unité utilisée dans le code
    RzPanel,        // unité utilisée dans le code
    EUGen,          // unité utilisée dans le code
    dxPSdxDBGrLnk,  // unité utilisée dans le code
    dxPSGlBl,
    dxPSdxMVLnk,    // unité utilisée dans le code
    dxPSdxTlLnk,    // unité utilisée dans le code
    dxPSCore,       // unité utilisée dans le code
    dxPrnDev,       // unité utilisée dans le code
    ConvertorRv,    // unité utilisée dans le code
    LMDTimer,
    IB_Components,
    LMDCustomComponent,
    LMDIniCtrl,
    StrHlder,
    Db,
    dxmdaset,
    wwDialog,
    wwidlg,
    stdCtrls,
    wwLookupDialogRv,
    splashms,
    LMDTxtPrinter,
    Wwdbgrid,
    UserDlg,
    ActionRv,
    vgStndrt,
    ALSTDlg,
    BmDelay,
    LMDSysInfo,
    LMDContainerComponent,
    lmdmsg,
    RxCalc, LMDOneInstance;

TYPE

    TArVariant = ARRAY OF Variant;

    TStdGinKoia = CLASS ( TDataModule )
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
        Tim_Jeton: TLMDHiTimer;
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
        Dlg_Wait: TSplashMessage;
        Dlg_Gauge: TSplashMessage;
        Dlg_Delay: TSplashMessage;
        PrtT_Memo: TLMDTxtPrinter;
        Dlg_OuiNOn: TUserDlg;
        Dlg_Info: TUserDlg;
        Grd_Close: TGroupDataRv;
        IbC_CtrlId: TIB_Cursor;
        IbC_CtrlChrono: TIB_Cursor;
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
    OnlyInst_Ginkoia: TLMDOneInstance;
        PROCEDURE Que_IniAfterPost ( DataSet: TDataSet ) ;
        PROCEDURE Que_IniBeforeDelete ( DataSet: TDataSet ) ;
        PROCEDURE Que_IniBeforeEdit ( DataSet: TDataSet ) ;
        PROCEDURE Que_IniNewRecord ( DataSet: TDataSet ) ;
        PROCEDURE Que_IniUpdateRecord ( DataSet: TDataSet; UpdateKind: TUpdateKind; VAR UpdateAction:
            TUpdateAction ) ;
        PROCEDURE Que_PutParamDosAfterPost ( DataSet: TDataSet ) ;
        PROCEDURE Que_PutParamDosBeforeDelete ( DataSet: TDataSet ) ;
        PROCEDURE Que_PutParamDosBeforeEdit ( DataSet: TDataSet ) ;
        PROCEDURE Que_PutParamDosNewRecord ( DataSet: TDataSet ) ;
        PROCEDURE Que_PutParamDosUpdateRecord ( DataSet: TDataSet;
            UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction ) ;
        PROCEDURE Tim_JetonTimer ( Sender: TObject ) ;
        PROCEDURE Que_JetonsAfterPost ( DataSet: TDataSet ) ;
        PROCEDURE Que_JetonsNewRecord ( DataSet: TDataSet ) ;
        PROCEDURE Que_JetonsUpdateRecord ( DataSet: TDataSet;
            UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction ) ;
        PROCEDURE DataModuleCreate ( Sender: TObject ) ;
        PROCEDURE DataModuleDestroy ( Sender: TObject ) ;
        PROCEDURE Que_ExeComAfterPost ( DataSet: TDataSet ) ;
        PROCEDURE Que_ExeComBeforeDelete ( DataSet: TDataSet ) ;
        PROCEDURE Que_ExeComBeforeEdit ( DataSet: TDataSet ) ;
        PROCEDURE Que_ExeComNewRecord ( DataSet: TDataSet ) ;
        PROCEDURE Que_ExeComUpdateRecord ( DataSet: TDataSet;
            UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction ) ;
        PROCEDURE Que_ExeComEXE_DEBUTValidate ( Sender: TField ) ;

    Private
        FDefTvaTaux: STRING;
        FNkLevel, FdefTva: Integer;

        FSocieteName, FMagasinName, FPosteName,
        // FPrefServeur,
        FRepImg, FNonRefRepImg: STRING;
        Funi, Forig, FMM, FSocieteID, FMagasinID, FPosteID, FTvtID: Integer;
        FDevModImp, FEtik, FLaserPreview, FEtik_Format, FDerImp: Integer;
        FPrefix, FnomTvt, FImp_Laser, FImp_Eltron: STRING;

        FEtik_Format_clt: integer;

        // Push - Pull Cogisoft
        FPushURL, FPushUSER, FPushPASS: STRING;
        FPullURL, FPullUSER, FPullPASS: STRING;
        FPushPROV, FPullPROV: TStrings;
        FgestionHT: Boolean;

        Fnl, Fcl: Boolean;
        FCalc: Double;

        FNM, FNP, FPatBase, FIniApp, FPatLect, FPatApp, FPatHelp, FPatEAI, FPatEAIexe, FPatRapport: STRING;
        PROCEDURE SetFnl ( Value: Boolean ) ;
        PROCEDURE SetFcl ( Value: Boolean ) ;
        PROCEDURE ConstDoInit;

        PROCEDURE SetDevModimp ( Value: Integer ) ;

    { Déclarations privées }
    Public
        LastTickCount: DWord;
        RefreshListArt, RefreshListCatalog: Boolean;
        FichartArtENKour: Integer;
        // refresh de la liste catalog si référencement

        FUNCTION TexteFiltre ( TS: TStrings ) : STRING;
        PROCEDURE LoadIniFileFromDatabase;

        FUNCTION GetStringParamValue ( ParamName: STRING ) : STRING;
        FUNCTION GetFloatParamValue ( ParamName: STRING ) : double;
        PROCEDURE PutStringParamValue ( ParamName, Val: STRING ) ;
        PROCEDURE PutFloatParamValue ( ParamName: STRING; Val: Extended ) ;

        PROCEDURE InitConvertor;
        PROCEDURE ReInitConvertor;
        FUNCTION Convert ( Value: Extended ) : STRING;
        FUNCTION ConvertBlank ( Value: Extended ) : STRING;
        FUNCTION ConvertEtik ( Value: Extended ) : STRING;
        FUNCTION GetDefaultMnyRef: TMYTYP;
        FUNCTION GetDefaultMnyTgt: TMYTYP;

        FUNCTION GetISO ( Mny: TMYTYP ) : STRING;
        FUNCTION GetTMYTYP ( ISO: STRING ) : TMYTYP;

        PROCEDURE FilterColor ( Panel: TrzPanel; Filtered: Boolean ) ;
        PROCEDURE MajAutoData ( Conteneur: TComponent; UserCanModif: Boolean ) ;

        PROCEDURE SetCanConvert ( Origine: STRING; Bloque: Boolean ) ;
        FUNCTION CanConvert ( OkMess: Boolean ) : Boolean;

        PROCEDURE SetModifTTrav ( Origine: STRING; Bloque: Boolean ) ;
        FUNCTION ModifTTrav ( OkMess: Boolean ) : Boolean;
        FUNCTION CanDeleteArt ( OkMess: Boolean ) : Boolean;

        PROCEDURE InitJetons;

        FUNCTION ResteEtiquette: Integer;

        FUNCTION ModeImpressionDevFull ( DxImp: TObject; Sens: Integer; VAR Direct, ChxImp: Boolean ) : Boolean;

        PROCEDURE DevImpPgH ( DxImp: TObject; FirstLine : String);
        // Page Header est de type TStrings
        // Charge first line dans la première ligne du page header
        // si cette ligne n'existe pas elle est crée
        // ne touche à aucune ligne existant éventuellement sauf laère (item )

        PROCEDURE DevImpFilter(DxImp: TObject; GrdFilter: array OF const);
        // Travaille sur "ReportTitle" propriété de type string et qui s'imprime
        // en dessous du pageHeader.
        // Réinitialise et reconfigure entièrement ReportTitle
        // met les chaînes de fitre dans le titre et configure
        // arial 8 normal
        // à gauche
        // uniquement sur 1ère page
        // si modif standard nécessaire, la coder après appel

        PROCEDURE CancelOnCache ( Dset: TDataset; VAR VariantMem ) ;
        PROCEDURE SauveOnCache ( Dset: TDataset; VAR VariantMem ) ;

        FUNCTION DateRgltCODE ( DateDoc: TDateTime; CPACode: Integer ) : TDateTime;
        FUNCTION DateRgltID ( DateDoc: TDateTime; CPAID: Integer ) : TDateTime;
        PROCEDURE ChpDateRgltCODE ( DateDoc: TDateTime; CPACode: Integer; VAR Chp: TDateTimeField ) ;

        // renvoi la liste de Table;Champs correspondant au champs ID ex ARTID, CLTID FOUID etc...
        FUNCTION Liste_Table_Par_Id ( Id: STRING ) : TstringList;
        // Cherche si Id existe dans les tables correspondant au champs ex ARTID, CLTID FOUID etc...
        FUNCTION ID_EXISTE ( Champs: STRING; Id: Integer; Excepter: ARRAY OF CONST ) : Boolean;
        PROCEDURE ChgExerciceCommercial;
        FUNCTION OkDeVise: Boolean;

        PROCEDURE WaitMess ( Msg: STRING ) ;
        PROCEDURE WaitClose;
        PROCEDURE InitGaugeMess ( Msg: STRING; MaxCount: Integer ) ;
        PROCEDURE CloseGaugeMess;
        FUNCTION IncGaugeMess: Boolean;
        PROCEDURE InitGaugeBtn ( Msg: STRING; MaxCount: Integer ) ;
        FUNCTION ValGauge: Integer;
        PROCEDURE MaxGaugeMess ( MaxCount: Integer ) ;
        PROCEDURE PositionGaugeMess ( Count: Integer ) ;

        PROCEDURE DelayMess ( Msg: STRING; DelaiSec: Integer ) ;
        PROCEDURE DlgChpMemo ( DS: TDatasource; Champ, Titre: STRING ) ;

        FUNCTION OuiNon ( Caption, Text: STRING; BtnDef: Boolean ) : Boolean;
        // result := True SSI OUI ...
        PROCEDURE InfoMess ( Caption, Text: STRING ) ;
        PROCEDURE PrintTS ( Caption: STRING; TS: TStrings ) ;
        FUNCTION RechArt ( Rech: STRING; DoMess: Boolean; Collection, FouId: Integer; Gros, Catalog, Virtuel, Archive: Boolean; VAR IsCB: Boolean;
            Qry: TIBOQuery; IsID: boolean = False ) : Integer;


    Published
        PROPERTY SocieteName: STRING Read FSocieteName Write FSocieteName;
        PROPERTY MagasinName: STRING Read FMagasinName Write FMagasinName;
        PROPERTY PosteName: STRING Read FPosteName Write FPosteName;
        PROPERTY SocieteID: Integer Read FSocieteID Write FSocieteID;
        PROPERTY MagasinID: Integer Read FMagasinID Write FMagasinID;
        PROPERTY PosteID: Integer Read FPosteID Write FPosteID;
        PROPERTY PrefixBase: STRING Read FPrefix Write FPrefix;

        PROPERTY TvtID: Integer Read FTvtID Write FTvtID;
        PROPERTY TvtNom: STRING Read FNomTvt Write FNomTvt;
        PROPERTY NbreMags: Integer Read FMM Write FMM;

        PROPERTY RepImg: STRING Read FrepImg Write FRepImg;
        PROPERTY RepNonRefImg: STRING Read FNonRefRepImg Write FNonRefRepImg;
        PROPERTY UniVers: Integer Read Funi Write Funi;
        PROPERTY Origine: Integer Read Forig Write Forig;

        PROPERTY ResteEtiK: Integer Read FEtik Write FEtik;
        PROPERTY Imp_Laser: STRING Read FImp_Laser Write FImp_Laser;
        PROPERTY Imp_Eltron: STRING Read FImp_Eltron Write FImp_Eltron;
        PROPERTY LaserPreview: Integer Read FLaserPreview Write FLaserPreview;
        PROPERTY Etik_Format: Integer Read FEtik_Format Write FEtik_Format;
        PROPERTY DernierImpression: Integer Read FDerImp Write FDerImp;

        PROPERTY Etik_Format_clt: Integer Read FEtik_Format_clt Write FEtik_Format_clt;

        // Push - Pull Cogisoft
        PROPERTY PushURL: STRING Read FPushURL Write FPushURL;
        PROPERTY PushUSER: STRING Read FPushUSER Write FPushUSER;
        PROPERTY PushPASS: STRING Read FPushPASS Write FPushPASS;
        PROPERTY PushPROV: TStrings Read FPushPROV Write FPushPROV;
        PROPERTY PullURL: STRING Read FPullURL Write FPullURL;
        PROPERTY PullUSER: STRING Read FPullUSER Write FPullUSER;
        PROPERTY PullPASS: STRING Read FPullPASS Write FPullPASS;
        PROPERTY PullPROV: TStrings Read FPullPROV Write FPullPROV;

        PROPERTY DevModImp: Integer Read FDevModImp Write SetDevModimp;
        PROPERTY GestionHT: Boolean Read FgestionHT Write FGestionHT;
        PROPERTY DefTvaTaux: STRING Read FDefTVATaux Write FDefTVATaux;
        PROPERTY DefTvaId: Integer Read FDefTVA Write FDefTVA;
        PROPERTY NKLevel: Integer Read FNkLevel Write FNkLevel;

        // ---------------------->

        PROPERTY NumLock: Boolean Read Fnl Write SetFnl;
        PROPERTY Capslock: Boolean Read Fcl Write SetFcl;
        PROPERTY CalcResult: Double Read FCalc;

        PROPERTY IniFileName: STRING Read FIniApp;
        PROPERTY PathApp: STRING Read FPatApp;
        PROPERTY PathLecteur: STRING Read FPatLect;
        PROPERTY PathHelp: STRING Read FPatHelp;
        PROPERTY PathBase: STRING Read FPatBase Write FPatBase;
        PROPERTY PathRapport: STRING Read FPatRapport Write FPatRapport;
        PROPERTY PathEAI: STRING Read FPatEAI Write FPatEAI;
        PROPERTY ExeEAI: STRING Read FPatEAIexe Write FPatEAIexe;
        PROPERTY NomPoste: STRING Read FNP Write FNP;
        PROPERTY NomDuMag: STRING Read FNM Write FNM;

    END;

VAR
    StdGinKoia: TStdGinKoia;

    TVA: Integer;   //clé de la TVA par défault de l'application
    TVA_TAUX: STRING; // Libelle de la TVA par défault de l'application

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

FUNCTION ERRMess ( Chaine: STRING; V: variant ) : Word;
FUNCTION INFMess ( Chaine: STRING; V: variant ) : Word;
FUNCTION WARMess ( Chaine: STRING; V: variant ) : Word;
FUNCTION CNFMess ( Chaine: STRING; V: Variant; BtnDef: Integer ) : Word;
FUNCTION NCNFMess ( Chaine: STRING; V: variant ) : Word;
{ *****************************************************************************
  Message de confirmation avec NON PAR DEFAUT
 ***************************************************************************** }

FUNCTION CtrlDelIdRef ( IdRef: Integer; ShowErrorMessage: Boolean ) : boolean;
FUNCTION CtrlEditIdRef ( IdRef: Integer; ShowErrorMessage: Boolean ) : boolean;
{ *****************************************************************************
  Fonctions génériques qui retournent False et éventuellement un message d'erreur
  si le paramètre d'entrée IdRef <> 0.
  Dans Pollux nous n'aurons pas besoin de plus pour contrôler lorsque ce sera
  nécessaire les enregs de référence ...
 ***************************************************************************** }

//--------------------------------------------------------------------------------
// Routines Globales "outils"
//--------------------------------------------------------------------------------

PROCEDURE Pause ( Value: Integer ) ; // secondes
PROCEDURE Delai ( Value: Integer ) ; // milisecondes
PROCEDURE ExecTip;
FUNCTION ExecCalc: Boolean;
// le résultat est dans la propriété CalcResult de la forme

FUNCTION CreateForm ( AFormClass: TFormClass ) : TCustomForm;
FUNCTION ExecModal ( AForm: TForm; AClass: TFormClass ) : TModalResult;

IMPLEMENTATION
USES
    GinkoiaResStr,
    StdUtils,
    StdBdeUtils,
    StdDateUtils,
    Main_dm,
    ChxcolImp_Frm,
    DlgMemo_Frm;

{$R *.DFM}

FUNCTION TStdGinKoia.OuiNon ( Caption, Text: STRING; BtnDef: Boolean ) : Boolean;
BEGIN
    Result := False;
    Dlg_OuiNon.Message.Clear;

    IF BtnDef THEN
        dlg_OuiNon.Default := 0
    ELSE
        dlg_OuiNon.Default := 1;

    IF Trim ( Caption ) <> '' THEN
        Dlg_OUINON.Title := Caption
    ELSE
        Dlg_OuiNon.Title := ' ' + LibConf + '...';

    IF Trim ( Text ) <> '' THEN
        Dlg_OuiNon.Message.text := Text
    ELSE
        Dlg_OuiNon.Message.text := DefOuiNon;

    IF dlg_ouiNon.Message.Count < 4 THEN
        Dlg_OuiNon.Message.Insert ( 0, '' ) ;

    IF Dlg_OuiNon.Show = 0 THEN Result := True;
END;

PROCEDURE TStdGinKoia.InfoMess ( Caption, Text: STRING ) ;
BEGIN

    Dlg_Info.Message.Clear;

    IF Trim ( Caption ) <> '' THEN
        Dlg_Info.Title := Caption
    ELSE
        Dlg_Info.Title := ' ' + LibInfo + '...';

    Dlg_Info.Message.Text := Text;
    IF dlg_info.Message.Count < 4 THEN
        Dlg_info.Message.Insert ( 0, '' ) ;

    Dlg_Info.Show;
END;

PROCEDURE TStdGinKoia.WaitMess ( Msg: STRING ) ;
BEGIN
    Dlg_Wait.Tag := 1;
    Dlg_Wait.MessageText := Msg;
    Dlg_Wait.Splash;
END;

PROCEDURE TStdGinKoia.WaitClose;
BEGIN

    IF dlg_Wait.Tag = 1 THEN
    BEGIN
       Delai(500);
       Dlg_Wait.Stop;
    END;
    Dlg_Wait.Tag := 0;
END;

PROCEDURE TStdGinKoia.MaxGaugeMess ( MaxCount: Integer ) ;
BEGIN
    IF Dlg_Gauge.Gauge.Progress < MaxCount THEN
        Dlg_Gauge.Gauge.MaxValue := MaxCount;
END;

PROCEDURE TStdGinKoia.PositionGaugeMess ( Count: Integer ) ;
BEGIN
    IF dlg_gauge.Gauge.Progress + Count <= Dlg_Gauge.Gauge.MaxValue THEN
        Dlg_Gauge.Gauge.Progress := Count
    ELSE
    BEGIN
        Dlg_Gauge.Gauge.MaxValue := Dlg_Gauge.Gauge.MaxValue * 2;
        Dlg_Gauge.Gauge.Progress := Count;
    END;
END;

PROCEDURE TStdGinKoia.InitGaugeMess ( Msg: STRING; MaxCount: Integer ) ;
BEGIN
    Dlg_Gauge.Gauge.Progress := 0;
    Dlg_Gauge.Gauge.MaxValue := MaxCount;
    Dlg_Gauge.MessageText := Msg;
    Dlg_Gauge.Splash;
END;

FUNCTION TStdGinKoia.VAlGauge: Integer;
BEGIN
    Result := Dlg_Gauge.Gauge.Progress;
END;

PROCEDURE TStdGinKoia.InitGaugeBtn ( Msg: STRING; MaxCount: Integer ) ;
BEGIN
    Dlg_Gauge.Buttons := [smCancel];
    Dlg_Gauge.Modal := True;
    InitGaugeMess ( Msg, MaxCount ) ;
    LastTickCount := GetTickCount;
END;

PROCEDURE TStdGinKoia.CloseGaugeMess;
BEGIN
    Dlg_Gauge.Stop;
    Dlg_Gauge.Modal := False;
    Dlg_Gauge.Buttons := [];
END;

//@@21 Pascal 23/05/2002 le test sur le GetTickCount est à l'envers
FUNCTION TStdGinKoia.IncGaugeMess: Boolean;
BEGIN
    Result := False;
    IF dlg_gauge.Gauge.Progress < Dlg_Gauge.Gauge.MaxValue THEN
        Dlg_Gauge.Gauge.Progress := Dlg_Gauge.Gauge.Progress + 1
    ELSE
    BEGIN
        Dlg_Gauge.Gauge.MaxValue := Dlg_Gauge.Gauge.MaxValue * 2;
        Dlg_Gauge.Gauge.Progress := Dlg_Gauge.Gauge.Progress + 1;
    END;

    IF Dlg_Gauge.Buttons <> [] THEN
    BEGIN
        IF LastTickCount + 5000 < GetTickCount THEN
        BEGIN
            LastTickCount := GetTickCount;
            Application.ProcessMessages;
            Result := Dlg_Gauge.Canceled;
        END;
    END;
END;

PROCEDURE TStdGinKoia.DelayMess ( Msg: STRING; DelaiSec: Integer ) ;
BEGIN
    IF DelaiSec = 0 THEN
        DelaiSec := 3000
    ELSE
        DelaiSec := DelaiSec * 1000;
    Dlg_Delay.MessageText := Msg;
    Dlg_Delay.SplashDelay ( DelaiSec ) ;
END;

PROCEDURE TStdGinKoia.ChpDateRgltCODE ( DateDoc: TDateTime; CPACode: Integer; VAR Chp: TDateTimeField ) ;
VAR
    T: TDateTime;
BEGIN
    T := DateRgltCODE ( DateDoc, CPACode ) ;
    IF T = 0 THEN
        chp.Clear
    ELSE
        chp.asDateTime := T;
END;

FUNCTION TStdGinKoia.OkDeVise: Boolean;
BEGIN
    Result := True;
    IF GetIso ( stdGinkoia.Convertor.MnyRef ) <>
        GetIso ( stdGinkoia.Convertor.DefaultMnyRef ) THEN
    BEGIN
        StdGinKoia.DelayMess ( NoGoodDevise, 3 ) ;
        Result := False;
    END;
END;

FUNCTION TStdGinKoia.DateRgltCODE ( DateDoc: TDateTime; CPACode: Integer ) : TDateTime;
BEGIN
    Result := 0;
    CASE CPACode OF
        2: Result := DateDoc + 3;
        3: Result := AddDays ( DateDoc, 30 ) ;
        4: Result := AddDays ( DateDoc, 60 ) ;
        5: Result := AddDays ( DateDoc, 90 ) ;
        6: Result := AddDays ( DateDoc, 120 ) ;

        7: Result := LastDayOfMonth ( AddDays ( DateDoc, 30 ) ) ;
        8: Result := LastDayOfMonth ( AddDays ( DateDoc, 60 ) ) ;
        9: Result := LastDayOfMonth ( AddDays ( DateDoc, 90 ) ) ;
        10: Result := LastDayOfMonth ( AddDays ( DateDoc, 120 ) ) ;

        11: Result := AddDays ( LastDayOfMonth ( AddDays ( DateDoc, 30 ) ) , 10 ) ;
        12: Result := AddDays ( LastDayOfMonth ( AddDays ( DateDoc, 60 ) ) , 10 ) ;
        13: Result := AddDays ( LastDayOfMonth ( AddDays ( DateDoc, 90 ) ) , 10 ) ;
        14: Result := AddDays ( LastDayOfMonth ( AddDays ( DateDoc, 120 ) ) , 10 ) ;

    END;
END;

FUNCTION TStdGinKoia.DateRgltID ( DateDoc: TDateTime; CPAID: Integer ) : TDateTime;
BEGIN
    TRY
        Ibc_CdtPmt.Close;
        Ibc_CdtPmt.ParamByName ( 'CPAID' ) .asInteger := CPAID;
        Ibc_CdtPmt.Open;

        Result := DateRgltCODE ( DateDoc, Ibc_CdtPmt.fieldByName ( 'CPA_CODE' ) .asInteger ) ;
    FINALLY
        Ibc_CdtPmt.Close;
    END;
END;

FUNCTION TStdGinKoia.TexteFiltre ( TS: TStrings ) : STRING;
BEGIN
    Result := TsToSTRSep ( ' - ', TS ) + CrLf + ' ';
END;

FUNCTION TStdGinKoia.ModeImpressionDevFull ( dxImp: TObject; Sens: Integer; VAR Direct, ChxImp: Boolean ) : Boolean;
VAR
    Maxi, u, z, i, j, k: Integer;
    rat: Extended;
BEGIN
    Result := False;
    K := 0;
    Maxi := 0;

    Direct := True;
    ChxImp := False;

    i := IniCtrl.ReadInteger ( 'DEVMOD', 'IMPDIRECT', 1 ) ;
    IF i = 0 THEN Direct := False;
    i := IniCtrl.ReadInteger ( 'DEVMOD', 'CHOIXIMP', 0 ) ;
    IF i = 1 THEN ChxImp := True;

    IF ( DxImp IS TdxDbGridReportLink ) THEN
    BEGIN
        k := 0;
        FOR j := 0 TO ( DxImp AS TdxDbGridReportLink ) .DBGrid.VisibleColumnCount - 1 DO
            IF ( DxImp AS TdxDbGridReportLink ) .DBGrid.VisibleColumns[j].RowIndex = 0 THEN
                k := k + ( DxImp AS TdxDbGridReportLink ) .DBGrid.VisibleColumns[j].Width;
        IF k > 700 THEN
            sens := 1
        ELSE
            sens := 0;
    END;

    i := ChoixColImpFull ( DevModImp, Sens, Direct, ChxImp ) ;
    Delai ( 100 ) ;
    IF i = -1 THEN Exit;

    IF Direct THEN
        IniCtrl.WriteInteger ( 'DEVMOD', 'IMPDIRECT', 1 )
    ELSE
        IniCtrl.WriteInteger ( 'DEVMOD', 'IMPDIRECT', 0 ) ;

    IF ChxImp THEN
        IniCTRL.WriteInteger ( 'DEVMOD', 'CHOIXIMP', 1 )
    ELSE
        IniCtrl.WriteInteger ( 'DEVMOD', 'CHOIXIMP', 0 ) ;

    IF i = 1 THEN ChxImp := True;

    // Ici c'est simplement les valeurs pour le test ...
    CASE Sens OF
        0: maxi := 700;
        1: maxi := 1035;
    END;

    Result := True;
    IF ( DxImp IS TdxMasterViewReportLink ) THEN
    BEGIN
        ( ( DxImp AS TdxMasterViewReportLink ) .Component AS TWinControl ) .refresh;
        ( DxImp AS TdxMasterViewReportLink ) .FixedTransParent := False;
        IF i <> DevModImp THEN
            DevModImp := i;
        CASE i OF
            0: ( DxImp AS TdxMasterViewReportLink ) .DrawMode := MvdmStrict;
            1: ( DxImp AS TdxMasterViewReportLink ) .DrawMode := MvdmBorrowSource;
            2:
                BEGIN
                    ( DxImp AS TdxMasterViewReportLink ) .DrawMode := MvdmStrict;
                    ( DxImp AS TdxMasterViewReportLink ) .FixedTransParent := True;
                END;
        END;        // du case
        CASE Sens OF
            0: ( DxImp AS TdxMasterViewReportLink ) .PrinterPage.Orientation := PoPortrait;
            1: ( DxImp AS TdxMasterViewReportLink ) .PrinterPage.Orientation := PoLandScape;
        END;
        ( DxImp AS TdxMasterviewReportLink ) .PrinterPage.Margins.Top := 12700;
        ( DxImp AS TdxMasterviewReportLink ) .PrinterPage.Margins.Bottom := 12700;
        ( DxImp AS TdxMasterviewReportLink ) .PrinterPage.Margins.Left := 6350;
        ( DxImp AS TdxMasterviewReportLink ) .PrinterPage.Margins.Right := 6350;
        ( DxImp AS TdxMasterviewReportLink ) .PrinterPage.Header := 6350;
        ( DxImp AS TdxMasterviewReportLink ) .PrinterPage.Footer := 6350;
    END
    ELSE
    BEGIN
        IF ( DxImp IS TdxDBGridReportLink ) THEN
        BEGIN
            IF k > Maxi THEN
            BEGIN
                IF Maxi = 700 THEN
                    Maxi := 735
                ELSE Maxi := 1070;
               // 96 c'est mon écran
                maxi := Trunc ( ( Maxi / 96 ) * Screen.PixelsPerInch ) ;

                ( DxImp AS TdxDbGridReportLink ) .DBGrid.BeginUpdate;
                TRY
                    rat := k / Maxi;
                    FOR j := 0 TO ( DxImp AS TdxDbGridReportLink ) .DBGrid.VisibleColumnCount - 1 DO
                        IF ( DxImp AS TdxDbGridReportLink ) .DBGrid.VisibleColumns[j].RowIndex = 0 THEN
                        BEGIN
                            z := ( DxImp AS TdxDbGridReportLink ) .DBGrid.VisibleColumns[j].Width;
                            u := Trunc ( RoundRv ( z / Rat, 0 ) ) ;
                            IF ( DxImp AS TdxDbGridReportLink ) .DBGrid.VisibleColumns[j].Width > Trunc ( u ) THEN
                                ( DxImp AS TdxDbGridReportLink ) .DBGrid.VisibleColumns[j].MinWidth := u;
                            ( DxImp AS TdxDbGridReportLink ) .DBGrid.VisibleColumns[j].Width := u;
                        END;
                FINALLY
                    ( DxImp AS TdxDbGridReportLink ) .DBGrid.EndUpdate;
                END
            END;
            ( ( DxImp AS TdxDBGridReportLink ) .Component AS TWinControl ) .refresh;
            ( DxImp AS TdxDBGridReportLink ) .FixedTransParent := False;
            IF i <> DevModImp THEN
                DevModImp := i;
            CASE i OF
                0: ( DxImp AS TdxDBGridReportLink ) .DrawMode := tldmStrict;
                1: ( DxImp AS TdxDBGridReportLink ) .DrawMode := tldmBorrowSource;
                2:
                    BEGIN
                        ( DxImp AS TdxDBGridReportLink ) .DrawMode := tldmStrict;
                        ( DxImp AS TdxDBGridReportLink ) .FixedTransParent := True;
                    END;
            END;    // du case
            CASE Sens OF
                0: ( DxImp AS TdxDBGridReportLink ) .PrinterPage.Orientation := PoPortrait;
                1: ( DxImp AS TdxDBGridReportLink ) .PrinterPage.Orientation := PoLandscape;
            END;
            ( DxImp AS TdxDBGridReportLink ) .PrinterPage.Margins.Top := 12700;
            ( DxImp AS TdxDBGridReportLink ) .PrinterPage.Margins.Bottom := 12700;
            ( DxImp AS TdxDBGridReportLink ) .PrinterPage.Margins.Left := 6350;
            ( DxImp AS TdxDBGridReportLink ) .PrinterPage.Margins.Right := 6350;
            ( DxImp AS TdxDBGridReportLink ) .PrinterPage.Header := 6350;
            ( DxImp AS TdxDBGridReportLink ) .PrinterPage.Footer := 6350;
        END
    END;
END;

PROCEDURE TStdGinKoia.SetDevModImp ( Value: Integer ) ;
BEGIN
    FdevModImp := Value;
    IniCtrl.WriteInteger ( 'DEVMOD', 'PSIMP', Value ) ;
END;

PROCEDURE TStdGinKoia.SetCanConvert ( Origine: STRING; Bloque: Boolean ) ;
VAR
    i: Integer;
BEGIN
    Origine := Uppercase ( Origine ) ;

    IF Bloque THEN
    BEGIN
        IF Str_CanConvert.Strings.IndexOf ( Origine ) = -1 THEN
            Str_CanConvert.Strings.add ( Origine ) ;
    END
    ELSE
    BEGIN
        i := Str_CanConvert.Strings.IndexOf ( Origine ) ;
        IF i <> -1 THEN Str_CanConvert.Strings.Delete ( i ) ;
    END;
END;

FUNCTION TStdGinKoia.CanConvert ( OkMess: Boolean ) : Boolean;
BEGIN
    Result := Str_CanConvert.Strings.Count = 0;
    IF ( NOT Result ) AND OkMess THEN
        StdGinKoia.DelayMess ( NietConvert, 3 ) ;
END;

PROCEDURE TStdGinKoia.SetModifTTrav ( Origine: STRING; Bloque: Boolean ) ;
VAR
    i: Integer;
BEGIN
    Origine := Uppercase ( Origine ) ;

    IF Bloque THEN
    BEGIN
        IF Str_ModifTTrav.Strings.IndexOf ( Origine ) = -1 THEN
            Str_ModifTTrav.Strings.add ( Origine ) ;
    END
    ELSE
    BEGIN
        i := Str_ModifTTrav.Strings.IndexOf ( Origine ) ;
        IF i <> -1 THEN Str_ModifTTrav.Strings.Delete ( i ) ;
    END;
END;

FUNCTION TStdGinKoia.ModifTTrav ( OkMess: Boolean ) : Boolean;
BEGIN
    Result := Str_ModifTTrav.Strings.Count = 0;
    IF ( NOT Result ) AND OkMess THEN
        StdGinKoia.DelayMess ( NietModifTTrav, 3 ) ;
END;

FUNCTION TStdGinKoia.CanDeleteArt ( OkMess: Boolean ) : Boolean;
BEGIN
    Result := Str_ModifTTrav.Strings.Count = 0;
    IF ( NOT Result ) AND OkMess THEN
        StdGinKoia.DelayMess ( NietDeleteArt, 3 ) ;
END;

PROCEDURE TStdGinKoia.MajAutoData ( Conteneur: TComponent; UserCanModif: Boolean ) ;
VAR
    i: Integer;
    PropInfo: PPropInfo;
BEGIN
    FOR i := 0 TO Conteneur.ComponentCount - 1 DO
    BEGIN
        Propinfo := GetPropInfo ( Conteneur.components[i], 'UserCanModify' ) ;
        IF propinfo <> NIL THEN
            IF UserCanModif THEN
                SetOrdProp ( Conteneur.components[i], 'UserCanModify', 1 )
            ELSE
                SetOrdProp ( Conteneur.components[i], 'UserCanModify', 0 ) ;
    END;
END;

PROCEDURE TStdGinKoia.LoadIniFileFromDatabase;
VAR
    Ident, Machine, dt, Np, Nm, ch: STRING;
    MaxJetons, i, j, posi: Integer;
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

    ch := PathBase;
    posi := Pos ( '\GINKOIA\', ch ) + 8;
    ch := SubStr ( ch, 1, posi ) ;
    ch := ChemWin ( ch ) ;

    // Provisoire : gestion de la fiche article en HT "1" ou pas "0"
    i := IniCtrl.ReadInteger ( 'GESTION', 'HT', 0 ) ;
    IF i = 0 THEN
        FgestionHT := False
    ELSE
        FgestionHT := True;

    FRepImg := ch + 'Images\';
    IF NOT directoryExists ( FRepImg ) THEN forcedirectories ( FRepImg ) ;

    FNonRefRepImg := ch + 'Images_nR\';
    IF NOT directoryExists ( FNonRefRepImg ) THEN forcedirectories ( FNonRefRepImg ) ;
    // Gestion des repertoires images : on les trouve à côté des Data, ce qui permet de les partager entre les != poste

    FRepImg := FormateStr ( 'ASLASH', FrepImg ) ;
    FNonRefRepImg := FormateStr ( 'ASLASH', FNonRefRepImg ) ;

    FdevModImp := IniCtrl.ReadInteger ( 'DEVMOD', 'PSIMP', 0 ) ;

    // initialisation du paramétrage des étiquettes
    FImp_Laser := IniCtrl.readString ( 'ETIQUETTE', 'IMP_LASER', '' ) ;
    IF ( FImp_Laser = '' ) THEN
        IniCtrl.WriteString ( 'ETIQUETTE', 'IMP_LASER', 'Laser' ) ;
    FImp_Eltron := IniCtrl.readString ( 'ETIQUETTE', 'IMP_ELTRON', '' ) ;
    IF ( FImp_Eltron = '' ) THEN
        IniCtrl.WriteString ( 'ETIQUETTE', 'IMP_ELTRON', 'Eltron' ) ;
    IF IniCtrl.readString ( 'ETIQUETTE', 'IMP_LASERPREVIEW', '' ) <> '' THEN
        FLaserPreview := StrToInt ( IniCtrl.readString ( 'ETIQUETTE', 'IMP_LASERPREVIEW', '' ) )
    ELSE
    BEGIN
        FLaserPreview := 0;
        IniCtrl.WriteString ( 'ETIQUETTE', 'IMP_LASERPREVIEW', '0' ) ;
    END;
    IF IniCtrl.readString ( 'ETIQUETTE', 'ETIK_FORMAT', '' ) <> '' THEN
        FEtik_Format := StrToInt ( IniCtrl.readString ( 'ETIQUETTE', 'ETIK_FORMAT', '' ) )
    ELSE
    BEGIN
        FEtik_Format := 0;
        IniCtrl.WriteString ( 'ETIQUETTE', 'ETIK_FORMAT', '0' ) ;
    END;
    // on veut mémoriser si la dernière impression était de Laser ou de L'Eltron
    // car la suppression des étiquettes ne se gère pas au même momment
    // Laser (1) => juste àprès l'impression afin de pouvoir compter les étiquettes restante
    // Eltron (0) => juste avant le chargement des nouvelles étiquettes pour vider le buffer en cas de pb
    IF IniCtrl.readString ( 'ETIQUETTE', 'DERNIERE_IMP', '' ) <> '' THEN
        FDerImp := StrToInt ( IniCtrl.readString ( 'ETIQUETTE', 'DERNIERE_IMP', '' ) )
    ELSE
    BEGIN
        FDerImp := 0;
        IniCtrl.WriteString ( 'ETIQUETTE', 'DERNIERE_IMP', '0' ) ;
    END;

    //Idem précédent mais pour les etiquettes Clients
    IF IniCtrl.readString ( 'ETIQUETTE', 'ETIK_FORMAT_CLT', '' ) <> '' THEN
        FEtik_Format_Clt := StrToInt ( IniCtrl.readString ( 'ETIQUETTE', 'ETIK_FORMAT_CLT', '' ) )
    ELSE
    BEGIN
        FEtik_Format_Clt := 0;
        IniCtrl.WriteString ( 'ETIQUETTE', 'ETIK_FORMAT_CLT', '0' ) ;
    END;

    IniCtrl_Jeton.NetUser := True;
    IniCtrl_Jeton.IniFile := ChemWinIni ( ExtractFilePath ( PathBase ) , 'Ressources.Ini' ) ;

    // Initialisation du nombre de jetons

    MaxJetons := 0;
    j := 0;
    ident := '';

    IbC_ParamBase.Open;
    Ident := IbC_ParamBase.FieldByName ( 'PAR_STRING' ) .AsString;
    IbC_ParamBase.Close;

    IF Trim ( ident ) <> '' THEN
    BEGIN
        que_Jetons.paramByName ( 'IDENT' ) .asString := ident;
        Que_Jetons.Open;
        IF NOT que_Jetons.IsEmpty THEN
            MaxJetons := Que_Jetons.fieldByName ( 'BAS_JETON' ) .asInteger
        ELSE
        BEGIN
            que_Jetons.Insert;
            que_Jetons.FieldByName ( 'BAS_IDENT' ) .asString := Ident;
            que_Jetons.FieldByName ( 'BAS_JETON' ) .asInteger := 0;
            que_Jetons.FieldByName ( 'BAS_NOM' ) .asString := '';
            que_Jetons.Post;
        END;
        Que_Jetons.Close;

        IF MaxJetons > 0 THEN
        BEGIN
            Str_Jeton.Clear;
            IniCtrl_Jeton.ReadSectionValues ( 'POSTES', str_jeton.Strings ) ;

            j := 0;

            IF str_jeton.strings.count > 0 THEN
            BEGIN
                FOR i := 0 TO str_jeton.strings.count - 1 DO
                BEGIN
                    ch := str_jeton.strings[i];
                    posi := Pos ( '=', ch ) ;
                    dt := copy ( ch, posi + 1, length ( ch ) ) ;
                    d := Strtodatetime ( dt ) ;
                    machine := SubStr ( ch, 1, posi - 1 ) ;
                    IF DiffDays ( d, Now ) = 0 THEN // même jour
                        IF DiffMinutes ( d, Now ) < 1 THEN // en travail car mise à jour moins de 2 minute
                            IF Machine <> IniCtrl_Jeton.User THEN // autre machine que la présente
                                Inc ( J ) ;
                END;
            END;

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
    END;

    IF J >= MaxJetons THEN FCtrlJeton := True;

    FnomTvt := NomTVT;

    NP := NOMPOSTE;
    NM := NOMDUMAG;

    FPushURL := iniCtrl.readString ( 'PUSH', 'URL', '' ) ;
    FPushUSER := iniCtrl.readString ( 'PUSH', 'USERNAME', '' ) ;
    FPushPASS := iniCtrl.readString ( 'PUSH', 'PASSWORD', '' ) ;

    IF ( NOT FCtrlJeton ) AND ( Dm_Main <> NIL ) AND
        ( Trim ( NP ) <> '' ) AND ( Trim ( NM ) <> '' ) THEN
    BEGIN

        // vérifie qu'il y a bien un slash en fin de chemin
        Fok := True;

        Que_NbreMags.Open;
        FMM := Que_NbreMags.RecordCountAll;
        Que_NbreMags.Close;

        Que_Ini.ParamByName ( 'NOMPOSTE' ) .AsString := NP;
        Que_Ini.ParamByName ( 'NOMMAG' ) .AsString := NM;

        Que_Ini.Open;
        IF NOT Que_Ini.Eof THEN
        BEGIN

            FSocieteName := Que_Ini.FieldByName ( 'SOC_NOM' ) .AsString;
            FMagasinName := Que_Ini.FieldByName ( 'MAG_NOM' ) .AsString;
            FPosteName := Que_Ini.FieldByName ( 'POS_NOM' ) .AsString;
            FSocieteID := Que_Ini.FieldByName ( 'SOC_ID' ) .AsInteger;
            FMagasinID := Que_Ini.FieldByName ( 'MAG_ID' ) .AsInteger;
            FTvtId := Que_Ini.FieldByName ( 'MAG_TVTID' ) .AsInteger;
            FPosteID := Que_Ini.FieldByName ( 'POS_ID' ) .AsInteger;

        END;
        Que_Ini.Close;

        Que_Prefix.open;
        FPrefix := que_Prefix.FieldByName ( 'PAR_STRING' ) .asString;
        que_Prefix.close;

        IF FPrefix = '' THEN Fok := False;
        IF FSocieteID = 0 THEN Fok := False;
        ;
        IF FMagasinID = 0 THEN Fok := False;
        IF FPosteID = 0 THEN FOk := False;

        TRY
            // Récupération de l'Univers définie au niveau Dossier
            IbQ_Univers.open;
            IF NOT IbQ_Univers.Locate ( 'UNI_NOM', GetStringParamValue ( 'UNIVERS_REF' ) , [] ) THEN
            BEGIN
                IF NOT IbQ_Univers.Eof THEN
                BEGIN
                    DelayMess ( ParamsStr ( INFUnivers, vararrayof ( [IbQ_Univers.FieldByName ( 'UNI_NOM' ) .asString, StdGinkoia.GetStringParamValue
                        ( 'UNIVERS_REF' ) ] ) ) , 3 ) ;
                    Univers := IbQ_Univers.FieldByName ( 'UNI_ID' ) .asInteger;
                    Origine := IbQ_Univers.FieldByName ( 'UNI_ORIGINE' ) .asInteger;
                    NKLevel := IbQ_Univers.FieldByName ( 'UNI_NIVEAU' ) .asInteger;
                    PutStringParamValue ( 'UNIVERS_REF', IbQ_Univers.FieldByName ( 'UNI_NOM' ) .asString ) ;
                END
                ELSE
                BEGIN
                    InfoMess ( '', ErrSansUnivers ) ;
                    Univers := 0;
                    Origine := 0;
                    NKLevel := 3;
                END;
            END
            ELSE
            BEGIN
                Univers := IbQ_Univers.FieldByName ( 'UNI_ID' ) .asInteger;
                Origine := IbQ_Univers.FieldByName ( 'UNI_ORIGINE' ) .asInteger;
                NKLevel := IbQ_Univers.FieldByName ( 'UNI_NIVEAU' ) .asInteger;
            END;

            // Récupération de la TVA définie au niveau Dossier
            Que_TVA.open;
            IF Que_TVA.Locate ( 'TVA_TAUX', GetFloatParamValue ( 'TVA' ) , [] ) THEN
            BEGIN
                FDefTVATAUX := Que_TVA.FieldByName ( 'TVA_TAUX' ) .asString;
                FDefTVA := Que_TVA.FieldByName ( 'TVA_ID' ) .asInteger;
            END
            ELSE
            BEGIN
                FDefTVATAUX := ' ';
                FDefTVA := 0;
                InfoMess ( '', ErrSansTVA ) ;
            END;

        FINALLY
            IbQ_Univers.close;
            que_Tva.Close;
        END;
    END;

    IF FCtrlJeton THEN
    BEGIN
        StdGinKoia.InfoMess ( '', CtrlJetons ) ;
        Application.Terminate;
    END
    ELSE
    BEGIN
        IF NOT Fok THEN
        BEGIN
            ERRMess ( ErrLectINI, '' ) ;
            // ici message de problème de connection
            Application.Terminate;
        END;
    END;

END;

PROCEDURE TStdGinKoia.InitJetons;
BEGIN
    Tim_JetonTimer ( NIL ) ;
    Tim_Jeton.Enabled := True;
END;

FUNCTION TStdGinKoia.ResteEtiquette: Integer;
BEGIN
    IF ( FDerImp = 1 ) THEN
    BEGIN
        Que_EtikPro.Close;
        Que_EtikPro.ParamByName ( 'POSID' ) .asinteger := PosteID;
        Que_EtikPro.Open;
        IF Que_EtikPro.EOF THEN
        BEGIN
            IF ( FEtik <> 1 ) THEN
                Result := 0
            ELSE Result := -1
        END
        ELSE
            Result := Que_EtikPro.RecordCount;
        Que_EtikPro.Close;
    END
    ELSE Result := 0;
END;

FUNCTION TStdGinKoia.GetStringParamValue ( ParamName: STRING ) : STRING;
BEGIN
    IbC_GetParamDossier.Close;
    IbC_GetParamDossier.Prepare;
    IbC_GetParamDossier.ParamByName ( 'PARAM_NAME' ) .AsString := ParamName;
    IbC_GetParamDossier.Open;
    Result := IbC_GetParamDossier.FieldByName ( 'DOS_STRING' ) .AsString;
END;

FUNCTION TStdGinKoia.GetFloatParamValue ( ParamName: STRING ) : double;
BEGIN
    IbC_GetParamDossier.Close;
    IbC_GetParamDossier.Prepare;
    IbC_GetParamDossier.ParamByName ( 'PARAM_NAME' ) .AsString := ParamName;
    IbC_GetParamDossier.Open;
    Result := IbC_GetParamDossier.FieldByName ( 'DOS_FLOAT' ) .AsFloat;
END;

PROCEDURE TStdGinKoia.PutStringParamValue ( ParamName, Val: STRING ) ;
BEGIN
    Que_PutParamDos.Close;
    Que_PutParamDos.ParamByName ( 'DOSNOM' ) .AsString := ParamName;
    Que_PutParamDos.Open;
    IF NOT Que_PutParamDos.Eof THEN
    BEGIN
        Que_PutParamDos.Edit;
        Que_PutParamDos.FieldByName ( 'DOS_STRING' ) .asString := Val;
        Que_PutParamDos.Post;
    END
    ELSE
    BEGIN
        Que_PutParamDos.insert;
        Que_PutParamDos.FieldByName ( 'DOS_NOM' ) .asString := UPPERCASE ( ParamName ) ;
        Que_PutParamDos.FieldByName ( 'DOS_STRING' ) .asString := Val;
        Que_PutParamDos.Post;
    END;
    Que_PutParamDos.Close;
END;

PROCEDURE TStdGinKoia.PutFloatParamValue ( ParamName: STRING; Val: Extended ) ;
BEGIN
    Que_PutParamDos.Close;
    Que_PutParamDos.ParamByName ( 'DOSNOM' ) .AsString := ParamName;
    Que_PutParamDos.Open;
    IF NOT Que_PutParamDos.Eof THEN
    BEGIN
        Que_PutParamDos.Edit;
        Que_PutParamDos.FieldByName ( 'DOS_FLOAT' ) .asFloat := Val;
        Que_PutParamDos.Post;
    END
    ELSE
    BEGIN
        Que_PutParamDos.insert;
        Que_PutParamDos.FieldByName ( 'DOS_NOM' ) .asString := UPPERCASE ( ParamName ) ;
        Que_PutParamDos.FieldByName ( 'DOS_FLOAT' ) .asFloat := Val;
        Que_PutParamDos.Post;
    END;
    Que_PutParamDos.Close;
END;

PROCEDURE TStdGinKoia.InitConvertor;
BEGIN
    Convertor.DefaultMnyRef :=
        Convertor.GetTMYTYP ( GetStringParamValue ( 'MONNAIE_REFERENCE' ) ) ;
    Convertor.DefaultMnyTgt :=
        Convertor.GetTMYTYP ( GetStringParamValue ( 'MONNAIE_CIBLE' ) ) ;
    Convertor.ReInit;

    // Après le passage à l'euro changer le sens des monnaies
    IF GetStringParamValue ( 'MONNAIE_REFERENCE' ) = 'EUR' THEN
    BEGIN
        ConvertorEtik.DefaultMnyTgt :=
            ConvertorEtik.GetTMYTYP ( GetStringParamValue ( 'MONNAIE_REFERENCE' ) ) ;
        ConvertorEtik.DefaultMnyRef :=
            ConvertorEtik.GetTMYTYP ( GetStringParamValue ( 'MONNAIE_CIBLE' ) ) ;
    END
    ELSE
    BEGIN
        ConvertorEtik.DefaultMnyRef :=
            ConvertorEtik.GetTMYTYP ( GetStringParamValue ( 'MONNAIE_REFERENCE' ) ) ;
        ConvertorEtik.DefaultMnyTgt :=
            ConvertorEtik.GetTMYTYP ( GetStringParamValue ( 'MONNAIE_CIBLE' ) ) ;
    END;

    ConvertorEtik.ReInit;

END;

PROCEDURE TStdGinKoia.ReInitConvertor;
BEGIN
    Convertor.ReInit;
END;

FUNCTION TStdGinKoia.Convert ( Value: Extended ) : STRING;
BEGIN
    Result := Convertor.Convert ( Value ) ;
END;

FUNCTION TStdGinKoia.ConvertBlank ( Value: Extended ) : STRING;
BEGIN
    Result := Convertor.Convert ( Value ) ;
    IF strToFloatTry ( Result ) = 0 THEN Result := '';
END;

FUNCTION TStdGinKoia.ConvertEtik ( Value: Extended ) : STRING;
BEGIN
    Result := ConvertorEtik.Convert ( Value ) ;
END;

FUNCTION TStdGinKoia.GetDefaultMnyRef: TMYTYP;
BEGIN
    Result := Convertor.DefaultMnyRef;
END;

FUNCTION TStdGinKoia.GetDefaultMnyTgt: TMYTYP;
BEGIN
    Result := Convertor.DefaultMnyTgt;
END;

FUNCTION TStdGinKoia.GetISO ( Mny: TMYTYP ) : STRING;
BEGIN
    Result := Convertor.GetISO ( Mny ) ;
END;

FUNCTION TStdGinKoia.GetTMYTYP ( ISO: STRING ) : TMYTYP;
BEGIN
    Result := Convertor.GetTMYTYP ( ISO ) ;
END;

PROCEDURE TStdGinKoia.Que_IniAfterPost ( DataSet: TDataSet ) ;
BEGIN
    Dm_Main.IBOUpDateCache ( DataSet AS TIBOQuery ) ;
END;

PROCEDURE TStdGinKoia.Que_IniBeforeDelete ( DataSet: TDataSet ) ;
BEGIN
    IF NOT Dm_Main.CheckAllowDelete ( ( DataSet AS TIBODataSet ) .KeyRelation,
        DataSet.FieldByName ( ( DataSet AS TIBODataSet ) .KeyLinks.IndexNames[0] ) .AsString,
        True ) THEN Abort;
END;

PROCEDURE TStdGinKoia.Que_IniBeforeEdit ( DataSet: TDataSet ) ;
BEGIN
    IF NOT Dm_Main.CheckAllowEdit ( ( DataSet AS TIBODataSet ) .KeyRelation,
        DataSet.FieldByName ( ( DataSet AS TIBODataSet ) .KeyLinks.IndexNames[0] ) .AsString,
        True ) THEN Abort;
END;

PROCEDURE TStdGinKoia.Que_IniNewRecord ( DataSet: TDataSet ) ;
BEGIN
    IF NOT Dm_Main.IBOMajPkKey ( ( DataSet AS TIBODataSet ) ,
        ( DataSet AS TIBODataSet ) .KeyLinks.IndexNames[0] ) THEN Abort;
END;

PROCEDURE TStdGinKoia.Que_IniUpdateRecord ( DataSet: TDataSet;
    UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction ) ;
BEGIN
    Dm_Main.IBOUpdateRecord ( ( DataSet AS TIBODataSet ) .KeyRelation,
        ( DataSet AS TIBODataSet ) , UpdateKind, UpdateAction ) ;
END;

PROCEDURE TStdGinkoia.FilterColor ( Panel: TrzPanel; Filtered: Boolean ) ;
BEGIN
    IF NOT Filtered THEN
        Panel.ParentColor := True
    ELSE
    BEGIN
        Panel.ParentColor := False;
        Panel.Color := $00B7FFFF;
    END;
END;

PROCEDURE TStdGinKoia.Que_PutParamDosAfterPost ( DataSet: TDataSet ) ;
BEGIN
    Dm_Main.IBOUpDateCache ( DataSet AS TIBOQuery ) ;
END;

PROCEDURE TStdGinKoia.Que_PutParamDosBeforeDelete ( DataSet: TDataSet ) ;
BEGIN
    IF NOT Dm_Main.CheckAllowDelete ( ( DataSet AS TIBODataSet ) .KeyRelation,
        DataSet.FieldByName ( ( DataSet AS TIBODataSet ) .KeyLinks.IndexNames[0] ) .AsString,
        True ) THEN Abort;
END;

PROCEDURE TStdGinKoia.Que_PutParamDosBeforeEdit ( DataSet: TDataSet ) ;
BEGIN
    IF NOT Dm_Main.CheckAllowEdit ( ( DataSet AS TIBODataSet ) .KeyRelation,
        DataSet.FieldByName ( ( DataSet AS TIBODataSet ) .KeyLinks.IndexNames[0] ) .AsString,
        True ) THEN Abort;
END;

PROCEDURE TStdGinKoia.Que_PutParamDosNewRecord ( DataSet: TDataSet ) ;
BEGIN
    IF NOT Dm_Main.IBOMajPkKey ( ( DataSet AS TIBODataSet ) ,
        ( DataSet AS TIBODataSet ) .KeyLinks.IndexNames[0] ) THEN Abort;
END;

PROCEDURE TStdGinKoia.Que_PutParamDosUpdateRecord ( DataSet: TDataSet;
    UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction ) ;
BEGIN
    Dm_Main.IBOUpdateRecord ( ( DataSet AS TIBODataSet ) .KeyRelation,
        ( DataSet AS TIBODataSet ) , UpdateKind, UpdateAction ) ;
END;

PROCEDURE TStdGinKoia.Tim_JetonTimer ( Sender: TObject ) ;
VAR
    ch: STRING;
BEGIN
    ch := DatetimeToStr ( Now ) ;
    IniCtrl_Jeton.WriteString ( 'POSTES', IniCtrl_Jeton.User, ch ) ;
END;

PROCEDURE TStdGinKoia.Que_JetonsAfterPost ( DataSet: TDataSet ) ;
BEGIN
    Dm_Main.IBOUpDateCache ( DataSet AS TIBOQuery ) ;
END;

PROCEDURE TStdGinKoia.Que_JetonsNewRecord ( DataSet: TDataSet ) ;
BEGIN
    IF NOT Dm_Main.IBOMajPkKey ( ( DataSet AS TIBODataSet ) ,
        ( DataSet AS TIBODataSet ) .KeyLinks.IndexNames[0] ) THEN Abort;

END;

PROCEDURE TStdGinKoia.Que_JetonsUpdateRecord ( DataSet: TDataSet;
    UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction ) ;
BEGIN
    Dm_Main.IBOUpdateRecord ( ( DataSet AS TIBODataSet ) .KeyRelation,
        ( DataSet AS TIBODataSet ) , UpdateKind, UpdateAction ) ;
END;

PROCEDURE TStdGinKoia.DataModuleCreate ( Sender: TObject ) ;
var ch:string;
BEGIN
    //Si param 4 contient le chemein de la base je mets à jour directement le point.ini
    IF paramCount > 3 THEN
    BEGIN
        ch := ParamStr(4);
        IniCtrl.WriteString ( 'DATABASE', 'PATH', ch+'ginkoia.gdb' ) ;
    END;

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

    FEtik := 0;
    FDefTVATaux := '';
    FDefTVA := 0;
    RefreshListCatalog := False;
    RefreshListArt := False;
END;

PROCEDURE TStdGinKoia.DataModuleDestroy ( Sender: TObject ) ;
BEGIN
//    If FPushProv <> Nil Then
//       FPushPROV.Free;
//    If FPullProv <> Nil Then
//       FPullPROV.Free;
END;

PROCEDURE TStdGinKoia.CancelOnCache ( Dset: TDataset; VAR VariantMem ) ;
// VariantMem doit ici être un array of variant déclaré dans le module appelant
VAR
    i: Integer;
BEGIN
    IF High ( TarVariant ( VariantMem ) ) <> ( Dset.FieldCount - 1 ) THEN
        Dset.Cancel
    ELSE
    BEGIN
        FOR i := 0 TO Dset.FieldCount - 1 DO
            Dset.Fields[i].Value := TarVariant ( VariantMem ) [i];
        Dset.Post;
    END;
    setlength ( TarVariant ( VariantMem ) , 0 ) ;
END;

PROCEDURE TStdGinKoia.SauveOnCache ( Dset: TDataset; VAR VariantMem ) ;
// VariantMem doit ici être un array of variant déclaré dans le module appelant
VAR
    i: Integer;
BEGIN

    setlength ( TarVariant ( VariantMem ) , Dset.FieldCount ) ;
    FOR i := 0 TO Dset.FieldCount - 1 DO
        TarVariant ( VariantMem ) [i] := Dset.Fields[i].Value;

END;

FUNCTION TStdGinKoia.Liste_Table_Par_Id ( Id: STRING ) : TstringList;
BEGIN
    IF Pos ( '_', Id ) > 0 THEN
        delete ( id, 1, Pos ( '_', Id ) ) ;

    Que_RechTable.Close;
    Que_RechTable.Sql.Clear;
    Que_RechTable.Sql.ADD ( 'Select rdb$field_Name Champs, RDB$Relation_Name Tables' ) ;
    Que_RechTable.Sql.ADD ( '  from rdb$relation_fields ' ) ;
    Que_RechTable.Sql.ADD ( ' where rdb$field_Name like ''%/_' + Uppercase ( ID ) + '%'' escape ''/'' ' ) ;
    Que_RechTable.Sql.ADD ( ' order by RDB$Relation_Name' ) ;
    result := tstringList.create;
    Que_RechTable.Open;
    WHILE NOT Que_RechTable.Eof DO
    BEGIN
        result.add ( Que_RechTable.Fields[1].AsString + ';' + Que_RechTable.Fields[0].AsString ) ;
        Que_RechTable.Next;
    END;
    Que_RechTable.Close;

END;

FUNCTION TStdGinKoia.ID_EXISTE ( Champs: STRING; Id: Integer; Excepter: ARRAY OF CONST ) : Boolean;
VAR
    Tsl: TstringList;
    j: Integer;
    i: integer;
    s: STRING;
    Table: STRING;
    Chps: STRING;
    Afaire: Boolean;
BEGIN
    result := false;
    tsl := Liste_Table_Par_Id ( Champs ) ;
    TRY
        FOR i := 0 TO tsl.count - 1 DO
        BEGIN
            S := tsl[i];
            table := Copy ( s, 1, Pos ( ';', s ) - 1 ) ;
            Chps := copy ( S, Pos ( ';', s ) + 1, 255 ) ;
            Afaire := true;
            FOR j := 0 TO high ( Excepter ) DO
            BEGIN
                S := '';
                CASE Excepter[j].VType OF
                    vtString: S := Excepter[j].Vstring^;
                    VtPChar: S := StrPas ( Excepter[j].VPchar ) ;
                    vtAnsiString: S := ansiString ( Excepter[j].VAnsiString ) ;
                END;
                IF uppercase ( Table ) = uppercase ( S ) THEN
                BEGIN
                    Afaire := False;
                    break;
                END;
            END;

            IF Afaire THEN
            BEGIN
                Que_RechTable.Close;
                Que_RechTable.sql.clear;
                Que_RechTable.sql.add ( 'Select Count(*)' ) ;
                Que_RechTable.sql.add ( '  From ' + Table ) ;
                Que_RechTable.sql.add ( '  JOIN K ON (K_ID=' + Chps + ' AND K_ENABLED=1)' ) ;
                Que_RechTable.sql.add ( '  Where ' + Chps + ' = ' + Inttostr ( Id ) ) ;

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

PROCEDURE TStdGinKoia.ChgExerciceCommercial;
BEGIN
    Que_ExeCom.Close;
    LK_ExeCom.Execute;
    Que_ExeCom.Open;
END;

PROCEDURE TStdGinKoia.Que_ExeComAfterPost ( DataSet: TDataSet ) ;
BEGIN
    Dm_Main.IBOUpDateCache ( DataSet AS TIBOQuery ) ;
END;

PROCEDURE TStdGinKoia.Que_ExeComBeforeDelete ( DataSet: TDataSet ) ;
BEGIN
    IF NOT Dm_Main.CheckAllowDelete ( ( DataSet AS TIBODataSet ) .KeyRelation,
        DataSet.FieldByName ( ( DataSet AS TIBODataSet ) .KeyLinks.IndexNames[0] ) .AsString,
        True ) THEN Abort;
END;

PROCEDURE TStdGinKoia.Que_ExeComBeforeEdit ( DataSet: TDataSet ) ;
BEGIN
    IF NOT Dm_Main.CheckAllowEdit ( ( DataSet AS TIBODataSet ) .KeyRelation,
        DataSet.FieldByName ( ( DataSet AS TIBODataSet ) .KeyLinks.IndexNames[0] ) .AsString,
        True ) THEN Abort;
END;

PROCEDURE TStdGinKoia.Que_ExeComNewRecord ( DataSet: TDataSet ) ;
BEGIN
    IF NOT Dm_Main.IBOMajPkKey ( ( DataSet AS TIBODataSet ) ,
        ( DataSet AS TIBODataSet ) .KeyLinks.IndexNames[0] ) THEN Abort;
END;

PROCEDURE TStdGinKoia.Que_ExeComUpdateRecord ( DataSet: TDataSet;
    UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction ) ;
BEGIN
    Dm_Main.IBOUpdateRecord ( ( DataSet AS TIBODataSet ) .KeyRelation,
        ( DataSet AS TIBODataSet ) , UpdateKind, UpdateAction ) ;
END;

PROCEDURE TStdGinKoia.Que_ExeComEXE_DEBUTValidate ( Sender: TField ) ;
BEGIN
    Que_ExeCom.FieldByname ( 'EXE_FIN' ) .asDateTime := AddYears ( Que_ExeCom.FieldByname ( 'EXE_DEBUT' ) .asDateTime, 1 ) - 1;
    IF ( StrToInt ( FormatDateTime ( 'mm', Que_ExeCom.FieldByname ( 'EXE_DEBUT' ) .asDateTime ) ) > 07 ) THEN
        Que_ExeCom.FieldByname ( 'EXE_ANNEE' ) .asInteger := StrToInt ( FormatDateTime ( 'yyyy', Que_ExeCom.FieldByname ( 'EXE_FIN' ) .AsDateTime ) )
    ELSE
        Que_ExeCom.FieldByname ( 'EXE_ANNEE' ) .asInteger := StrToInt ( FormatDateTime ( 'yyyy', Que_ExeCom.FieldByname ( 'EXE_DEBUT' ) .AsDateTime )
            ) ;
END;

PROCEDURE TStdGinKoia.DlgChpMemo ( DS: TDatasource; Champ, Titre: STRING ) ;
VAR
    flag: Boolean;
    ch: STRING;
BEGIN
    Flag := ( NOT ( ds.State IN [dsInsert, dsEdit] ) ) AND ( NOT ds.Autoedit ) ;
    IF ds.dataset.fieldByName ( Champ ) .ReadOnly THEN Flag := True;

    ch := ds.dataset.fieldByName ( Champ ) .asString;
    IF ExecuteDlgMemo ( Titre, Flag, ds.dataset.fieldByName ( Champ ) .Size, ch ) THEN
    BEGIN
        IF ( NOT ( ds.State IN [dsInsert, dsEdit] ) ) AND
            ( NOT ds.dataset.fieldByName ( Champ ) .ReadOnly ) THEN
        BEGIN
            IF ds.Dataset.IsEmpty THEN
                ds.Dataset.Insert
            ELSE
                ds.Dataset.Edit;
        END;
        ds.dataset.fieldByName ( Champ ) .asString := ch;
    END;

END;

PROCEDURE TStdGinKoia.PrintTS ( Caption: STRING; TS: TStrings ) ;
VAR
    Mts: TStrings;
BEGIN
    Mts := TStringList.Create;
    TRY
        Mts.Assign ( TS ) ;
        IF Trim ( Caption ) <> '' THEN
        BEGIN
            MTs.Insert ( 0, '' ) ;
            MTs.Insert ( 0, Caption ) ;
            MTs.Insert ( 0, '' ) ;
            MTs.Insert ( 0, '' ) ;
            MTs.Insert ( 0, '' ) ;
        END
        ELSE
        BEGIN
            MTs.Insert ( 0, '' ) ;
            MTs.Insert ( 0, '' ) ;
            MTs.Insert ( 0, '' ) ;
        END;

        PrtT_memo.PrintText ( MTS.Text ) ;
    FINALLY
        Mts.Free;
    END;
END;

//***********************************************************************************************************
// P.R. : 09/04/2002 : @@15 : Ajout de IsId pour permètre la recherche sur l'id sans test
//***********************************************************************************************************

FUNCTION TStdGinKoia.RechArt ( Rech: STRING; DoMess: Boolean; Collection, FouId: Integer; Gros, Catalog, Virtuel, Archive: Boolean; VAR IsCB:
    Boolean; Qry: TIBOQuery; IsID: boolean = False ) : Integer;
VAR
    cas: Integer;
    FlagTag: Integer;
BEGIN
    flagTag := Qry.Tag;
    // met le tag à 1 pour signaler rech en cours et éventuellement
    // shunter le after scroll dans l'unité appelante ...
    // pour par exemple éviter les sautillements d'écran !
    IsCb := False;
    Result := -1;
    Cas := -1;
    IF Trim ( rech ) = '' THEN EXIT;
    rech := TrimRight ( Rech ) ;

    TRY
        screen.cursor := crSQLWait;
        qry.DisableControls;
        qry.Tag := 1;
        TRY
            IF IsId THEN
                Cas := 4
            ELSE
            BEGIN
                IF Trim ( Rech ) = '*' THEN
                    cas := 3
                ELSE
                BEGIN
                    IF ( Length ( Rech ) >= 12 ) AND TEST_EAN ( Rech ) THEN
                        cas := 0
                    ELSE
                    BEGIN
                        IF IsInteger ( Rech, length ( Rech ) ) THEN
                        BEGIN
                            Ibc_CtrlId.close;
                            Ibc_CtrlId.paramByName ( 'ARTID' ) .asInteger := StrToInt ( Rech ) ;
                            Ibc_CtrlId.Open;
                            IF NOT Ibc_CtrlId.eof THEN cas := 4;
                        END;
                        IF Result = -1 THEN
                        BEGIN
                            Ibc_CtrlChrono.close;
                            Ibc_CtrlChrono.paramByName ( 'Lechrono' ) .asstring := Rech;
                            Ibc_CtrlChrono.Open;
                            IF NOT Ibc_CtrlChrono.eof THEN Cas := 1;
                        END
                    END;
                END;
                IF Cas = -1 THEN Cas := 2;
                Qry.Close;
                Qry.SQL.Clear;
            END;

            CASE Cas OF
                0:  // Cbarre
                    BEGIN
                        Qry.SQL.Add (
                            'SELECT CBI_ID, CBI_TGFID, CBI_COUID, ARF_ID, ART_ID, ART_NOM, ART_REFMRK, ARF_CHRONO, TGF_NOM, COU_NOM, ARF_DIMENSION' ) ;
                        Qry.SQL.Add ( 'FROM ARTCODEBARRE' ) ;
                        Qry.SQL.Add ( 'JOIN K ON (K_ID=CBI_ID AND K_ENABLED=1)' ) ;
                        Qry.SQL.Add ( 'JOIN ARTREFERENCE ON (ARF_ID=CBI_ARFID)' ) ;
                        Qry.SQL.Add ( 'JOIN K ON (K_ID=ARF_ARTID AND K_ENABLED=1)' ) ;
                        Qry.SQL.Add ( 'JOIN ARTARTICLE ON (ART_ID=ARF_ARTID)' ) ;

                        IF ( NOT gros ) AND ( FOUID > 0 ) THEN
                        BEGIN
                            Qry.SQL.Add ( 'JOIN ARTMRKFOURN ON (FMK_FOUID =' + IntToStr ( Fouid ) + ' AND FMK_MRKID=ART_MRKID)' ) ;
                            Qry.SQL.Add ( 'JOIN K ON (K_ID=FMK_ID AND K_ENABLED = 1)' ) ;
                        END;

                        IF Collection > 0 THEN
                        BEGIN
                            Qry.SQL.Add ( 'JOIN ARTCOLART ON (CAR_ARTID=ART_ID AND CAR_COLID=' + IntToStr ( Collection ) + ')' ) ;
                            Qry.SQL.Add ( 'JOIN K ON (K_ID=CAR_ID AND K_ENABLED = 1)' ) ;
                        END;

                        Qry.SQL.Add ( 'JOIN PLXCOULEUR ON (COU_ID=CBI_COUID)' ) ;
                        Qry.SQL.Add ( 'JOIN PLXTAILLESGF ON (TGF_ID=CBI_TGFID)' ) ;
                        Qry.SQL.Add ( 'WHERE CBI_CB=:RECH' ) ;
                        IF NOT Catalog THEN Qry.SQL.Add ( 'AND ARF_CATALOG=0' ) ;
                        IF NOT Virtuel THEN Qry.SQL.Add ( 'AND ARF_VIRTUEL=0' ) ;
                        IF NOT Archive THEN Qry.SQL.Add ( 'AND ARF_ARCHIVER=0' ) ;

                        Qry.ParamByName ( 'RECH' ) .asString := Rech;
                        Qry.Open;
                        Result := RecUnique ( Qry AS TDataset ) ;
                        IF Result = 1 THEN IsCb := True;
                    END;

                1:  // Chrono
                    BEGIN
                        Qry.SQL.Clear;
                        Qry.SQL.Add ( 'SELECT ARF_ID, ART_ID, ART_NOM, ART_REFMRK, ARF_CHRONO, ARF_DIMENSION' ) ;
                        Qry.SQL.Add ( '  FROM PR_RECHARTCHRONO (:RECH)' ) ;

                        IF ( NOT gros ) AND ( FOUID > 0 ) THEN
                        BEGIN
                            Qry.SQL.Add ( 'JOIN ARTMRKFOURN ON (FMK_FOUID =' + IntToStr ( Fouid ) + ' AND FMK_MRKID=ART_MRKID)' ) ;
                            Qry.SQL.Add ( 'JOIN K ON (K_ID=FMK_ID AND K_ENABLED = 1)' ) ;
                        END;

                        IF Collection > 0 THEN
                        BEGIN
                            Qry.SQL.Add ( 'JOIN ARTCOLART ON (CAR_ARTID=ART_ID AND CAR_COLID=' + IntToStr ( Collection ) + ')' ) ;
                            Qry.SQL.Add ( 'JOIN K ON (K_ID=CAR_ID AND K_ENABLED = 1)' ) ;
                        END;

                        Qry.SQL.Add ( 'Where ART_ID<>0' ) ;
                        IF NOT Catalog THEN Qry.SQL.Add ( 'AND ARF_CATALOG=0' ) ;
                        IF NOT Virtuel THEN Qry.SQL.Add ( 'AND ARF_VIRTUEL=0' ) ;
                        IF NOT Archive THEN Qry.SQL.Add ( 'AND ARF_ARCHIVER=0' ) ;

                        Qry.SQL.Add ( 'ORDER BY ARF_CHRONO' ) ;
                        Qry.ParamByName ( 'RECH' ) .asString := Rech;
                        Qry.Open;
                        Result := RecUnique ( Qry AS TDataset ) ;
                    END;

                2:  // Nom & Ref
                    BEGIN
                        Qry.SQL.Clear;
                        Qry.SQL.Add ( 'SELECT ARF_ID, ART_ID, ART_NOM, ART_REFMRK, ARF_CHRONO, ARF_DIMENSION' ) ;
                        Qry.SQL.Add ( 'FROM ARTARTICLE' ) ;
                        Qry.SQL.Add ( 'JOIN K ON (K_ID=ART_ID AND K_ENABLED=1)' ) ;
                        Qry.SQL.Add ( 'JOIN ARTREFERENCE ON (ARF_ARTID=ART_ID)' ) ;

                        IF ( NOT gros ) AND ( FOUID > 0 ) THEN
                        BEGIN
                            Qry.SQL.Add ( 'JOIN ARTMRKFOURN ON (FMK_FOUID =' + IntToStr ( Fouid ) + ' AND FMK_MRKID=ART_MRKID)' ) ;
                            Qry.SQL.Add ( 'JOIN K ON (K_ID=FMK_ID AND K_ENABLED = 1)' ) ;
                        END;

                        IF Collection > 0 THEN
                        BEGIN
                            Qry.SQL.Add ( 'JOIN ARTCOLART ON (CAR_ARTID=ART_ID AND CAR_COLID=' + IntToStr ( Collection ) + ')' ) ;
                            Qry.SQL.Add ( 'JOIN K ON (K_ID=CAR_ID AND K_ENABLED = 1)' ) ;
                        END;

                        Qry.SQL.Add ( 'WHERE ((ART_NOM CONTAINING :RECH) OR (ART_DESCRIPTION CONTAINING :RECH) OR (ART_REFMRK CONTAINING :RECH))' ) ;
                        IF NOT Catalog THEN Qry.SQL.Add ( 'AND ARF_CATALOG=0' ) ;
                        IF NOT Virtuel THEN Qry.SQL.Add ( 'AND ARF_VIRTUEL=0' ) ;
                        IF NOT Archive THEN Qry.SQL.Add ( 'AND ARF_ARCHIVER=0' ) ;

                        Qry.SQL.Add ( 'ORDER BY ARF_CHRONO' ) ;
                        Qry.ParamByName ( 'RECH' ) .asString := Rech;
                        Qry.Open;
                        Result := RecUnique ( Qry AS TDataset ) ;
                    END;
                3:  //  *
                    BEGIN
                        Qry.SQL.Clear;
                        Qry.SQL.Add ( 'SELECT ARF_ID, ART_ID, ART_NOM, ART_REFMRK, ARF_CHRONO, ARF_DIMENSION' ) ;
                        Qry.SQL.Add ( 'FROM ARTARTICLE' ) ;
                        Qry.SQL.Add ( 'JOIN K ON (K_ID=ART_ID AND K_ENABLED=1)' ) ;

                        IF ( NOT gros ) AND ( FOUID > 0 ) THEN
                        BEGIN
                            Qry.SQL.Add ( 'JOIN ARTMRKFOURN ON (FMK_FOUID =' + IntToStr ( Fouid ) + ' AND FMK_MRKID=ART_MRKID)' ) ;
                            Qry.SQL.Add ( 'JOIN K ON (K_ID=FMK_ID AND K_ENABLED = 1)' ) ;
                        END;

                        IF Collection > 0 THEN
                        BEGIN
                            Qry.SQL.Add ( 'JOIN ARTCOLART ON (CAR_ARTID=ART_ID AND CAR_COLID=' + IntToStr ( Collection ) + ')' ) ;
                            Qry.SQL.Add ( 'JOIN K ON (K_ID=CAR_ID AND K_ENABLED = 1)' ) ;
                        END;

                        Qry.SQL.Add ( 'JOIN ARTREFERENCE ON (ARF_ARTID=ART_ID)' ) ;
                        Qry.SQL.Add ( 'WHERE ART_ID<>0' ) ;
                        IF NOT Catalog THEN Qry.SQL.Add ( 'AND ARF_CATALOG=0' ) ;
                        IF NOT Virtuel THEN Qry.SQL.Add ( 'AND ARF_VIRTUEL=0' ) ;
                        IF NOT Archive THEN Qry.SQL.Add ( 'AND ARF_ARCHIVER=0' ) ;

                        Qry.SQL.Add ( 'ORDER BY ARF_CHRONO' ) ;
                        Qry.Open;
                        Result := RecUnique ( Qry AS TDataset ) ;
                    END;
                4:  // IdART
                    BEGIN
                        Qry.SQL.Clear;
                        Qry.SQL.Add ( 'SELECT ARF_ID, ART_ID, ART_NOM, ART_REFMRK, ARF_CHRONO, ARF_DIMENSION' ) ;
                        Qry.SQL.Add ( 'FROM ARTARTICLE' ) ;
                        Qry.SQL.Add ( 'JOIN K ON (K_ID=ART_ID AND K_ENABLED=1)' ) ;

                        IF ( NOT gros ) AND ( FOUID > 0 ) THEN
                        BEGIN
                            Qry.SQL.Add ( 'JOIN ARTMRKFOURN ON (FMK_FOUID =' + IntToStr ( Fouid ) + ' AND FMK_MRKID=ART_MRKID)' ) ;
                            Qry.SQL.Add ( 'JOIN K ON (K_ID=FMK_ID AND K_ENABLED = 1)' ) ;
                        END;

                        IF Collection > 0 THEN
                        BEGIN
                            Qry.SQL.Add ( 'JOIN ARTCOLART ON (CAR_ARTID=ART_ID AND CAR_COLID=' + IntToStr ( Collection ) + ')' ) ;
                            Qry.SQL.Add ( 'JOIN K ON (K_ID=CAR_ID AND K_ENABLED = 1)' ) ;
                        END;

                        Qry.SQL.Add ( 'JOIN ARTREFERENCE ON (ARF_ARTID=ART_ID)' ) ;
                        Qry.SQL.Add ( 'WHERE ART_ID=:RECH' ) ;
                        IF NOT Catalog THEN Qry.SQL.Add ( 'AND ARF_CATALOG=0' ) ;
                        IF NOT Virtuel THEN Qry.SQL.Add ( 'AND ARF_VIRTUEL=0' ) ;
                        IF NOT Archive THEN Qry.SQL.Add ( 'AND ARF_ARCHIVER=0' ) ;

                        Qry.SQL.Add ( 'ORDER BY ARF_CHRONO' ) ;
                        Qry.ParamByName ( 'RECH' ) .asString := Rech;
                        Qry.Open;
                        Result := RecUnique ( Qry AS TDataset ) ;
                    END;
            ELSE
            END;    // du case

        EXCEPT
        END;
    FINALLY
        Ibc_CtrlChrono.close;
        Ibc_CtrlId.close;
        screen.cursor := crDefault;
        qry.Tag := flagTag;
        qry.EnableControls;
        IF ( Result = 0 ) AND DoMess THEN
        BEGIN
            IF collection > 0 THEN
                StdGinkoia.DelayMess ( CdeRechVideCollec, 0 )
            ELSE
                StdGinkoia.DelayMess ( CdeRechVide, 0 )
        END;
    END;
END;
// *************************************

//******************* CtrlDelIdRef *************************
// Procédure simple qui retourne Result = False et message si IdRef <> 0;

FUNCTION CtrlDelIdRef ( IdRef: Integer; ShowErrorMessage: Boolean ) : boolean;
BEGIN
    Result := True;
    IF IdRef <> 0 THEN
    BEGIN
        IF ShowErrorMessage THEN ERRMESS ( ErrNoDeleteNullRec, '' ) ;
        Result := False;
    END;
END;

//******************* CtrlEditIdRef *************************
// Procédure simple qui retourne Result = False et message si IdRef <> 0;

FUNCTION CtrlEditIdRef ( IdRef: Integer; ShowErrorMessage: Boolean ) : boolean;
BEGIN
    Result := True;
    IF IdRef <> 0 THEN
    BEGIN
        IF ShowErrorMessage THEN ERRMESS ( ErrNoEditNullRec, '' ) ;
        Result := False;
    END;
END;

// Initialisation des variables globales, chemins, Tips ...

PROCEDURE TStdGinKoia.ConstDoInit;
BEGIN

    Appini_Main.IniFileName := ChangeFileExt ( Application.ExeName, '.ini' ) ;
    FIniApp := Appini_Main.IniFileName;

    FPatapp := FormateStr ( 'ASLASH', ExtractFilePath ( Application.ExeName ) ) ;
    FPatHelp := FPatapp + 'Help\';
    FPatLect := ''; // non utilisé pour l'instant
    Application.HelpFile := FPatHelp + ChangeFileExt ( ExtractFileName ( Application.ExeName ) , '.HLP' ) ;
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

    Tip_Main.IniFile := iniCtrl.readString ( 'TIP', 'PATH', '' ) ;
    IF Tip_Main.IniFile = '' THEN
        Tip_Main.IniFile := ChangeFileExt ( Application.ExeName, '.Tip' )

END;

// CapsLock : propriété de la forme

PROCEDURE TStdGinKoia.SetFcl ( Value: Boolean ) ;
BEGIN
    Fcl := Value;
    SysInf_main.CapsLockState := Fcl;
END;

// NumLock : propriété de la forme

PROCEDURE TStdGinKoia.SetFnl ( Value: Boolean ) ;
BEGIN
    Fnl := Value;
    SysInf_main.NumLockState := Fnl;
END;

//--------------------------------------------------------------------------------
//Gestion des erreurs
//--------------------------------------------------------------------------------

//******************* NCNFMess *************************
// Message d'erreur

FUNCTION NCNFMess ( Chaine: STRING; V: variant ) : Word;
BEGIN
    Result := mrNo;
    WITH StdGinkoia DO
        IF StdGinKoia.OuiNon ( ' Confirmation...', ParamsStr ( chaine, v ) , False ) THEN Result := mrYes;
END;

//******************* ERRMess *************************
// Erreur simple bouton OK

FUNCTION ERRMess ( Chaine: STRING; V: variant ) : Word;
BEGIN
    Result := mrYes;
    WITH StdGinkoia DO
        StdGinKoia.InfoMess ( ' Erreur...', ParamsStr ( chaine, v ) ) ;
END;

//******************* INFMess *************************
// Information simple Bouton OK

FUNCTION INFMess ( Chaine: STRING; V: variant ) : Word;
BEGIN
    Result := mrYes;
    WITH StdGinkoia DO
        StdGinKoia.InfoMess ( ' Information...', ParamsStr ( chaine, v ) ) ;
END;

//******************* WARMess *************************
// Warning simple bouton Ok

FUNCTION WARMess ( Chaine: STRING; V: variant ) : Word;
BEGIN
    Result := mrYes;
    WITH StdGinkoia DO
        StdGinKoia.InfoMess ( ' Avertissement...', ParamsStr ( chaine, v ) ) ;
END;

//******************* CNFMess *************************
// Confirmation O/N où o, indique le bouton par défaut
// 0 = OUI  1 = NON et OUI par défaut

FUNCTION CNFMess ( Chaine: STRING; V: Variant; BtnDef: Integer ) : Word;
BEGIN
    Result := mrNo;
    WITH StdGinkoia DO
    BEGIN
        IF ( btnDef < 0 ) OR ( btnDef > 1 ) THEN btnDef := 1;
        CASE btnDef OF
            0: IF StdGinKoia.OuiNon ( ' Confirmation...', ParamsStr ( chaine, v ) , True ) THEN Result := mrYes;
            1: IF StdGinKoia.OuiNon ( ' Confirmation...', ParamsStr ( chaine, v ) , False ) THEN Result := mrYes;
        END;
    END;
END;

//--------------------------------------------------------------------------------
// Système et Clavier
//--------------------------------------------------------------------------------

//******************* Pause *************************
// Pause

PROCEDURE Pause ( Value: Integer ) ;
BEGIN
   // value = pause indiquée en secondes ...
    StdGinkoia.Delay_main.WaitForDelay ( Value * 1000 )
END;

PROCEDURE Delai ( Value: Integer ) ;
BEGIN
   // value = pause indiquée en secondes ...
    StdGinkoia.Delay_main.WaitForDelay ( Value )
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

FUNCTION CreateForm ( AFormClass: TFormClass ) : TCustomForm;
BEGIN
    Result := AFormClass.Create ( Application ) ;
END;

//******************* ExecModal *************************
// Exécution modale

FUNCTION ExecModal ( AForm: TForm; AClass: TFormClass ) : TModalResult;
BEGIN
    // Result := MrNone;
    TRY
        AForm := AClass.Create ( Application ) ;
        Result := AForm.ShowModal;
    FINALLY
        AForm.Free;
    END;
END;

PROCEDURE TstdGinkoia.DevImpPgH ( DxImp: TObject; FirstLine : String);
begin
    IF ( DxImp IS TdxDbGridReportLink ) THEN
    BEGIN
        IF ( DxImp AS TdxDbGridReportLink ) .PrinterPage.PageHeader.LeftTitle.Count = 0 THEN
              ( DxImp AS TdxDbGridReportLink ) .PrinterPage.PageHeader.LeftTitle.Add (FirstLine)
        ELSE
              ( DxImp AS TdxDbGridReportLink ) .PrinterPage.PageHeader.LeftTitle[0] := FirstLine;
    END;
    IF ( DxImp IS TdxMasterViewReportLink ) THEN
    BEGIN
        IF ( DxImp AS TdxMasterviewReportLink ) .PrinterPage.PageHeader.LeftTitle.Count = 0 THEN
              ( DxImp AS TdxMasterviewReportLink ) .PrinterPage.PageHeader.LeftTitle.Add (FirstLine)
        ELSE
              ( DxImp AS TdxMasterviewReportLink ) .PrinterPage.PageHeader.LeftTitle[0] := FirstLine;
    END;
end;

procedure TStdGinKoia.DevImpFilter(DxImp: TObject; GrdFilter: array OF const);
var ch, c : String;
    i, j : Integer;
BEGIN
     IF ( dxImp <> Nil ) THEN
     BEGIN
          WITH ( DxImp AS TdxDbGridReportLink ) .ReportTitle Do
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

              for i := 0 to High(GrdFilter) DO
              BEGIN
                  CASE GrdFilter[i].VType OF
                    vtString :     c := GrdFilter[i].Vstring^;
                    VtPChar :      c := StrPas ( GrdFilter[i].VPchar ) ;
                    vtAnsiString : c := ansiString ( GrdFilter[i].VAnsiString ) ;
                  END;
                  IF c <> '' THEN
                  BEGIN
                      IF j = 0 THEN
                           ch := c
                      ELSE
                           ch := ch + CrLf + c;
                      inc (j);
                  END
              END;
              Text := ch;
          END;
     END;
END;



END.
