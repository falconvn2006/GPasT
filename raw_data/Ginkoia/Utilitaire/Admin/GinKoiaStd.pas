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

        IF StdConst.Tip_Main.ShowAtStartup THEN ExecTip;

    END;
 ****************************************************************}

UNIT GinKoiaStd;

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
    IBDataset,
    TypInfo,
    Inifiles,       // unité utilisée dans le code
    FileCtrl,       // unité utilisée dans le code
    RzPanel,        // unité utilisée dans le code
    EUGen,          // unité utilisée dans le code
    dxPSdxDBGrLnk,  // unité utilisée dans le code
    dxPSdxMVLnk,    // unité utilisée dans le code
    dxPSdxTlLnk,    // unité utilisée dans le code
    dxPrnDev,       // unité utilisée dans le code
    ConvertorRv,    // unité utilisée dans le code
    LMDTimer,
    IB_Components,
    LMDCustomComponent,
    LMDIniCtrl,
    StrHlder,
    Db,
    dxmdaset;

TYPE

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
        IbC_CB: TIB_Cursor;
        IbC_Chrono: TIB_Cursor;
        IbC_REF: TIB_Cursor;
        Que_Recherche: TIBOQuery;
        Que_RechercheARF_ID: TIntegerField;
        Que_RechercheART_ID: TIntegerField;
        Que_RechercheART_NOM: TStringField;
        Que_RechercheART_REFMRK: TStringField;
        Que_RechercheARF_CHRONO: TStringField;
        Que_RechercheCOU_ID: TIntegerField;
        Que_RechercheCOU_NOM: TStringField;
        Que_RechercheTGF_ID: TIntegerField;
        Que_RechercheTGF_NOM: TStringField;
        Que_RechercheTVA_TAUX: TIBOFloatField;
        Str_CanConvert: TStrHolder;
        Que_Prefix: TIBOQuery;
        IniCtrl_Jeton: TLMDIniCtrl;
        Str_Jeton: TStrHolder;
        Tim_Jeton: TLMDHiTimer;
        Que_Jetons: TIBOQuery;
        IbC_ParamBase: TIB_Cursor;
        Str_ModifTTrav: TStrHolder;
        Que_EtikPro: TIBOQuery;
        Que_recherchB: TIB_Query;
        MemD_EtikProLinId: TIntegerField;
        MemD_EtikProRetik: TIntegerField;
        ConvertorEtik: TConvertorRv;
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

    Private
        FSocieteName, FMagasinName, FPosteName, FPrefServeur, FRepImg, FNonRefRepImg: STRING;
        Funi, Forig, FMM, FSocieteID, FMagasinID, FPosteID, FTvtID: Integer;
        FDevModImp, FEtik, FLaserPreview, FEtik_Format, FDerImp: Integer;
        FPrefix, FnomTvt, FImp_Laser, FImp_Eltron: STRING;

        // Push - Pull Cogisoft
        FPushURL, FPushUSER, FPushPASS: STRING;
        FPullURL, FPullUSER, FPullPASS: STRING;
        FPushPROV, FPullPROV: TStrings;

        PROCEDURE SetDevModimp ( Value: Integer ) ;

    { Déclarations privées }
    Public
        RefreshListArt, RefreshListCatalog: Boolean;
        // refresh de la liste catalog si référencement

        PROCEDURE LoadIniFileFromDatabase;

        FUNCTION GetStringParamValue ( ParamName: STRING ) : STRING;
        FUNCTION GetFloatParamValue ( ParamName: STRING ) : double;
        PROCEDURE PutStringParamValue ( ParamName, Val: STRING ) ;
        PROCEDURE PutFloatParamValue ( ParamName: STRING; Val: Extended ) ;

        PROCEDURE InitConvertor;
        PROCEDURE ReInitConvertor;
        FUNCTION Convert ( Value: Extended ) : STRING;
        FUNCTION ConvertEtik ( Value: Extended ) : STRING;
        FUNCTION GetDefaultMnyRef: TMYTYP;
        FUNCTION GetDefaultMnyTgt: TMYTYP;

        FUNCTION GetISO ( Mny: TMYTYP ) : STRING;
        FUNCTION GetTMYTYP ( ISO: STRING ) : TMYTYP;

        PROCEDURE FilterColor ( Panel: TrzPanel; Filtered: Boolean ) ;
        PROCEDURE MajAutoData ( Conteneur: TComponent; UserCanModif: Boolean ) ;

        FUNCTION Article ( Texte: STRING; chrono: boolean; CB: boolean;
            RefUnique: boolean; Ref: boolean; Desi: boolean; client: boolean;
            VAR clt_id: integer; VAR clt_nompren: STRING ) : integer;

        PROCEDURE SetCanConvert ( Origine: STRING; Bloque: Boolean ) ;
        FUNCTION CanConvert ( OkMess: Boolean ) : Boolean;

        PROCEDURE SetModifTTrav ( Origine: STRING; Bloque: Boolean ) ;
        FUNCTION ModifTTrav ( OkMess: Boolean ) : Boolean;
        FUNCTION CanDeleteArt ( OkMess: Boolean ) : Boolean;

        PROCEDURE InitJetons;

        FUNCTION ResteEtiquette: Integer;

        FUNCTION ModeImpressionDev ( DxImp: TObject ) : Boolean;
        // Choix de mode d'impression (couleur) de devexpress ...
        FUNCTION ModeImpressionDevSens ( DxImp: TObject; Sens: Integer ) : Boolean;
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

    END;

VAR
    StdGinKoia: TStdGinKoia;

    TVA: Integer;   //clé de la TVA par défault de l'application
    TVA_TAUX: STRING; // Libelle de la TVA par défault de l'application

IMPLEMENTATION
USES ConstStd,
    GinkoiaResStr,
    StdUtils,
    StdDateUtils,
    Main_dm,
    ChxcolImp_Frm;

{$R *.DFM}

FUNCTION TStdGinKoia.ModeImpressionDev ( DxImp: TObject ) : Boolean;
VAR
    i: Integer;
BEGIN
    Result := False;
    i := ChoixColImp ( DevModImp ) ;
    IF i = -1 THEN Exit;

    Result := True;
    IF ( DxImp IS TdxMasterViewReportLink ) THEN
    BEGIN
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
    END
    ELSE
    BEGIN
        IF ( DxImp IS TdxDBGridReportLink ) THEN
        BEGIN
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
        END
    END;

END;

{ Modifié RV Le : 20/10/2001  -  Procedure }

FUNCTION TStdGinKoia.ModeImpressionDevSens ( DxImp: TObject; Sens: Integer ) : Boolean;
VAR
    i: Integer;
BEGIN
    Result := False;
    i := ChoixColImpSens ( DevModImp, Sens ) ;
    IF i = -1 THEN Exit;

    Result := True;
    IF ( DxImp IS TdxMasterViewReportLink ) THEN
    BEGIN
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
    END
    ELSE
    BEGIN
        IF ( DxImp IS TdxDBGridReportLink ) THEN
        BEGIN
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
        END
    END;

END;

PROCEDURE TStdGinKoia.SetDevModImp ( Value: Integer ) ;
BEGIN
    FdevModImp := Value;
    StdConst.IniCtrl.WriteInteger ( 'DEVMOD', 'PSIMP', Value ) ;
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
        INFMess ( NietConvert, '' ) ;
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
        INFMess ( NietModifTTrav, '' ) ;
END;

FUNCTION TStdGinKoia.CanDeleteArt ( OkMess: Boolean ) : Boolean;
BEGIN
    Result := Str_ModifTTrav.Strings.Count = 0;
    IF ( NOT Result ) AND OkMess THEN
        INFMess ( NietDeleteArt, '' ) ;
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
    MaxJetons, i, j, posi, K: Integer;
    FCtrlJeton, fok, trouve: Boolean;
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
    MaxJetons := 0;

    ch := StdConst.PathBase;
    posi := Pos ( '\GINKOIA\', ch ) + 8;
    ch := SubStr ( ch, 1, posi ) ;
    ch := ChemWin ( ch ) ;

    FRepImg := ch + 'Images\';
    IF NOT directoryExists ( FRepImg ) THEN forcedirectories ( FRepImg ) ;

    FNonRefRepImg := ch + 'Images_nR\';
    IF NOT directoryExists ( FNonRefRepImg ) THEN forcedirectories ( FNonRefRepImg ) ;
    // Gestion des repertoires images : on les trouve à côté des Data, ce qui permet de les partager entre les != poste

    FRepImg := FormateStr ( 'ASLASH', FrepImg ) ;
    FNonRefRepImg := FormateStr ( 'ASLASH', FNonRefRepImg ) ;

    FdevModImp := StdConst.IniCtrl.ReadInteger ( 'DEVMOD', 'PSIMP', 0 ) ;

    // initialisation du paramétrage des étiquettes
    FImp_Laser := StdConst.IniCtrl.readString ( 'ETIQUETTE', 'IMP_LASER', '' ) ;
    IF ( FImp_Laser = '' ) THEN
        StdConst.IniCtrl.WriteString ( 'ETIQUETTE', 'IMP_LASER', 'Laser' ) ;
    FImp_Eltron := StdConst.IniCtrl.readString ( 'ETIQUETTE', 'IMP_ELTRON', '' ) ;
    IF ( FImp_Eltron = '' ) THEN
        StdConst.IniCtrl.WriteString ( 'ETIQUETTE', 'IMP_ELTRON', 'Eltron' ) ;
    IF StdConst.IniCtrl.readString ( 'ETIQUETTE', 'IMP_LASERPREVIEW', '' ) <> '' THEN
        FLaserPreview := StrToInt ( StdConst.IniCtrl.readString ( 'ETIQUETTE', 'IMP_LASERPREVIEW', '' ) )
    ELSE
    BEGIN
        FLaserPreview := 0;
        StdConst.IniCtrl.WriteString ( 'ETIQUETTE', 'IMP_LASERPREVIEW', '0' ) ;
    END;
    IF StdConst.IniCtrl.readString ( 'ETIQUETTE', 'ETIK_FORMAT', '' ) <> '' THEN
        FEtik_Format := StrToInt ( StdConst.IniCtrl.readString ( 'ETIQUETTE', 'ETIK_FORMAT', '' ) )
    ELSE
    BEGIN
        FEtik_Format := 0;
        StdConst.IniCtrl.WriteString ( 'ETIQUETTE', 'ETIK_FORMAT', '0' ) ;
    END;
    // on veut mémoriser si la dernière impression était de Laser ou de L'Eltron
    // car la suppression des étiquettes ne se gère pas au même momment
    // Laser (1) => juste àprès l'impression afin de pouvoir compter les étiquettes restante
    // Eltron (0) => juste avant le chargement des nouvelles étiquettes pour vider le buffer en cas de pb
    IF StdConst.IniCtrl.readString ( 'ETIQUETTE', 'DERNIERE_IMP', '' ) <> '' THEN
        FDerImp := StrToInt ( StdConst.IniCtrl.readString ( 'ETIQUETTE', 'DERNIERE_IMP', '' ) )
    ELSE
    BEGIN
        FDerImp := 0;
        StdConst.IniCtrl.WriteString ( 'ETIQUETTE', 'DERNIERE_IMP', '0' ) ;
    END;

    IniCtrl_Jeton.NetUser := True;
    IniCtrl_Jeton.IniFile := ChemWinIni ( ExtractFilePath ( StdConst.PathBase ) , 'Ressources.Ini' ) ;

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

    NP := StdConst.NOMPOSTE;
    NM := StdConst.NOMDUMAG;

    FPushURL := StdConst.iniCtrl.readString ( 'PUSH', 'URL', '' ) ;
    FPushUSER := StdConst.iniCtrl.readString ( 'PUSH', 'USERNAME', '' ) ;
    FPushPASS := StdConst.iniCtrl.readString ( 'PUSH', 'PASSWORD', '' ) ;
//    FPushPROV := TStringList.Create;
//    Trouve := True;
//    i := 0;
//    WHILE Trouve DO
//    BEGIN
//        ch := StdConst.iniCtrl.readString ( 'PUSH', 'PROVIDER' + IntToStr ( i ) , '' ) ;
//        Inc ( i ) ;
//        IF ( ch <> '' ) THEN
//        BEGIN
//            FPushPROV.Add ( ch ) ;
//        END
//        ELSE Trouve := False;
//    END;
//
//    FPullURL := StdConst.iniCtrl.readString ( 'PULL', 'URL', '' ) ;
//    FPullUSER := StdConst.iniCtrl.readString ( 'PULL', 'USERNAME', '' ) ;
//    FPullPASS := StdConst.iniCtrl.readString ( 'PULL', 'PASSWORD', '' ) ;
//    FPullPROV := TStringList.Create;
//    Trouve := True;
//    i := 0;
//    WHILE Trouve DO
//    BEGIN
//        ch := StdConst.iniCtrl.readString ( 'PULL', 'PROVIDER' + IntToStr ( i ) , '' ) ;
//        Inc ( i ) ;
//        IF ( ch <> '' ) THEN
//        BEGIN
//            FPullPROV.Add ( ch ) ;
//        END
//        ELSE Trouve := False;
//    END;

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

    END;

    IF FCtrlJeton THEN
    BEGIN
        INFMESS ( CtrlJetons, '' ) ;
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

    ConvertorEtik.DefaultMnyRef :=
        ConvertorEtik.GetTMYTYP ( GetStringParamValue ( 'MONNAIE_REFERENCE' ) ) ;
    ConvertorEtik.DefaultMnyTgt :=
        ConvertorEtik.GetTMYTYP ( GetStringParamValue ( 'MONNAIE_CIBLE' ) ) ;
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

FUNCTION TStdGinKoia.Article ( Texte: STRING; chrono: boolean; CB: boolean;
    RefUnique: boolean; Ref: boolean; Desi: boolean; client: boolean;
    VAR clt_id: integer; VAR clt_nompren: STRING ) : integer;
VAR
    CD: STRING;
    resultat: integer;
    idtc: integer;
BEGIN

     //Cette fonction permet via 'Texte' de retrouver un ou plusieurs articles
     //ainsi qu'un CB Client .

     //Les Variables en entrée Chrono,CB,Ref,desi permettent d'optimiser les recherches.
     //Ex : Si seulement Chrono est à True, la recherche se fera uniquement sur le code chrono,
     //si tout est à true, la recherche de 'Texte' se fera sur tous les champs.

     //En retour la fonction retourne le nombre d'article trouvé(s).
     //Les données ne sont retournées directement, elles sont accessible
     //dans la Query Rechereche
     //Si 'Texte' correspondait à un CB les variables tgf_id et cou_id sont rensignées,
     //si le texte correspondait à un chrono, tgf_id et cou_id sont retournées avec -1.
     //Je ne peux pas les laisser à zéro, car le CB d'un article Pseudo retournera normalement
     //tgf_ud et cou_id à 0.   (SAUF SI ORIGINE = 2 Appli Monotaille/couleur)
     //Si Texte correspond à un Code Barre client, les champs
     //clt_id,clt_nompren sont aussi renseignés:
    screen.Cursor := crSQLWait;

    CASE Origine OF
        1: idtc := -1;
        2: idtc := 0;
    END;

    result := 0;

    //---Init des variables de retour

    clt_id := 0;
    clt_nompren := '';
    que_recherche.close;
    ibc_chrono.close;
    Ibc_cb.close;
    Ibc_ref.close;

    //*******Recherche sur le code barre****************
    IF cb AND stdutils.CD_EAN ( texte, Cd ) THEN
    BEGIN           //Il faut faire une recherche sur le code barre
        ibc_cb.close;
        ibc_cb.parambyname ( 'CB' ) .asstring := texte;
        ibc_cb.open;

        IF NOT ibc_cb.eof THEN
        BEGIN
            //--- C'est un code barre
            IF ( ibc_cb.fieldbyname ( 'cbi_type' ) .asinteger = 1 ) OR
                ( ibc_cb.fieldbyname ( 'cbi_type' ) .asinteger = 3 ) THEN
            BEGIN
                //---C'est un CB Article
                inc ( result ) ;
            END
            ELSE
            BEGIN
                //---C'est un client
                IF client THEN
                BEGIN
                    clt_id := ibc_cb.fieldbyname ( 'cbi_cltid' ) .asinteger;
                    clt_nompren := ibc_cb.fieldbyname ( 'nompren' ) .asstring;
                END;
            END;

        END
    END;

      //*******Recherche sur le chrono****************
    IF chrono AND ( result = 0 ) THEN
    BEGIN
           //Si result est <> 0 , texte = CB et donc le format ne peut pas
           //correspondre à un code Chrono

        ibc_chrono.close;
        ibc_chrono.parambyname ( 'CHRONO' ) .asstring := texte;
        ibc_chrono.open;

        IF NOT ibc_chrono.eof THEN
        BEGIN
            inc ( result ) ;
        END
    END;

     //*******Recherche sur la ref fournisseur****************
    IF RefUnique THEN
    BEGIN
        ibc_ref.close;
        ibc_ref.parambyname ( 'REF' ) .asstring := texte;
        ibc_ref.open;

        IF NOT ibc_ref.eof THEN
        BEGIN
            inc ( result ) ;
        END
    END;

     //*******Recherche sur la désignation et/ou la ref Marque****************
    IF desi OR ref THEN
    BEGIN
        Que_RecherchB.SQL.Clear;
        Que_RecherchB.KeyLinks.Clear;
        Que_RecherchB.JoinLinks.Clear;
        Que_RecherchB.SQL.Add ( 'select ARF_ID, ART_ID, ART_NOM, ART_REFMRK, ARF_CHRONO,' +
            'COU_ID,COU_NOM,TGF_ID,TGF_NOM,tva_taux' ) ;
        Que_RecherchB.SQL.Add ( 'from artarticle, artreference, k,PLXTAILLESGF,PLXCOULEUR,arttva' ) ;
        Que_RecherchB.SQL.Add ( 'where k_enabled=1' ) ;

        IF texte <> '*' THEN
        BEGIN
            IF desi AND ref THEN
                Que_RecherchB.SQL.Add ( 'and ((art_nom containing :RECH) or (art_refmrk containing :RECH))' )
            ELSE
            BEGIN
                IF desi THEN
                    Que_RecherchB.SQL.Add ( 'and (art_nom containing :RECH) ' )
                ELSE
                    Que_RecherchB.SQL.Add ( 'and (art_refmrk containing :RECH)' ) ;
            END;
        END;
        Que_RecherchB.SQL.Add ( 'and arf_chrono<>'''' ' ) ;
        Que_RecherchB.SQL.Add ( 'ORDER BY ARF_CHRONO' ) ;
        Que_RecherchB.KeyRelation := 'ARTARTICLE';
        Que_RecherchB.KeyLinks.Add ( 'ARF_ID' ) ;
        Que_RecherchB.JoinLinks.Add ( 'arf_id=k_id' ) ;
        Que_RecherchB.JoinLinks.Add ( 'arf_artid=art_id' ) ;
        Que_RecherchB.JoinLinks.Add ( 'cou_id=0' ) ;
        Que_RecherchB.JoinLinks.Add ( 'tgf_id=0' ) ;
        Que_RecherchB.JoinLinks.Add ( 'arf_tvaid=tva_id' ) ;
        IF texte <> '*' THEN
            Que_RecherchB.ParamByName ( 'RECH' ) .asString := texte;
        Que_RecherchB.Open;

        IF que_recherchB.recordcount <> 0 THEN
        BEGIN
            que_recherche.open;
            que_recherchB.first;
            WHILE NOT que_recherchB.eof DO
            BEGIN
                que_recherche.insert;
                que_recherche.fieldbyname ( 'arf_id' ) .asinteger := que_recherchB.fieldbyname ( 'arf_id' ) .asinteger;
                que_recherche.fieldbyname ( 'art_id' ) .asinteger := que_recherchB.fieldbyname ( 'art_id' ) .asinteger;
                que_recherche.fieldbyname ( 'arf_chrono' ) .asstring := que_recherchB.fieldbyname ( 'arf_chrono' ) .asstring;
                que_recherche.fieldbyname ( 'art_nom' ) .asstring := que_recherchB.fieldbyname ( 'art_nom' ) .asstring;
                que_recherche.fieldbyname ( 'art_refmrk' ) .asstring := que_recherchB.fieldbyname ( 'art_refmrk' ) .asstring;
                que_recherche.fieldbyname ( 'tgf_id' ) .asinteger := idtc;
                que_recherche.fieldbyname ( 'tgf_nom' ) .asstring := '';
                que_recherche.fieldbyname ( 'cou_id' ) .asinteger := idtc;
                que_recherche.fieldbyname ( 'cou_nom' ) .asstring := '';
                que_recherche.fieldbyname ( 'tva_taux' ) .asfloat := que_recherchB.fieldbyname ( 'tva_taux' ) .asfloat;
                que_recherche.post;
                que_recherchB.Next;
            END;
        END;

    END;

    IF que_recherche.active THEN
        result := result + que_recherche.RecordCount;

        //Les recherches abouties des sripts sont insérées dans la Query
        // Recherche
    IF NOT que_recherche.active THEN
        que_recherche.open;

        // Les réponses positives des scripts doivent être ajoutées dans la Query

    IF NOT ibc_cb.eof AND ( ibc_cb.fieldbyname ( 'arf_artid' ) .asinteger <> 0 )
        AND ( ibc_cb.active ) THEN
    BEGIN
        que_recherche.first;
        WHILE NOT que_recherche.eof DO
        BEGIN
            IF ibc_cb.fieldbyname ( 'cbi_artid' ) .asinteger =
                que_recherche.fieldbyname ( 'art_id' ) .asinteger THEN
                Break
            ELSE
                que_recherche.next;
        END;
        IF que_recherche.eof THEN
        BEGIN
            que_recherche.insert;
            que_recherche.fieldbyname ( 'arf_id' ) .asinteger := ibc_cb.fieldbyname ( 'cbi_arfid' ) .asinteger;
            que_recherche.fieldbyname ( 'art_id' ) .asinteger := ibc_cb.fieldbyname ( 'arf_artid' ) .asinteger;
            que_recherche.fieldbyname ( 'arf_chrono' ) .asstring := ibc_cb.fieldbyname ( 'arf_chrono' ) .asstring;
            que_recherche.fieldbyname ( 'art_nom' ) .asstring := ibc_cb.fieldbyname ( 'art_nom' ) .asstring;
            que_recherche.fieldbyname ( 'art_refmrk' ) .asstring := ibc_cb.fieldbyname ( 'art_refmrk' ) .asstring;
            que_recherche.fieldbyname ( 'tgf_id' ) .asinteger := ibc_cb.fieldbyname ( 'cbi_tgfid' ) .asinteger;
            que_recherche.fieldbyname ( 'tgf_nom' ) .asstring := ibc_cb.fieldbyname ( 'tgf_nom' ) .asstring;
            que_recherche.fieldbyname ( 'cou_id' ) .asinteger := ibc_cb.fieldbyname ( 'cbi_couid' ) .asinteger;
            que_recherche.fieldbyname ( 'cou_nom' ) .asstring := ibc_cb.fieldbyname ( 'cou_nom' ) .asstring;
            que_recherche.fieldbyname ( 'tva_taux' ) .asfloat := ibc_cb.fieldbyname ( 'tva_taux' ) .asfloat;
            que_recherche.post;
        END;
    END;

    IF ( NOT ibc_chrono.eof ) AND ( ibc_chrono.active ) THEN
    BEGIN
        que_recherche.first;
        WHILE NOT que_recherche.eof DO
        BEGIN
            IF ibc_chrono.fieldbyname ( 'arf_artid' ) .asinteger =
                que_recherche.fieldbyname ( 'art_id' ) .asinteger THEN
                Break
            ELSE
                que_recherche.next;
        END;
        IF que_recherche.eof THEN
        BEGIN
            que_recherche.insert;
            que_recherche.fieldbyname ( 'arf_id' ) .asinteger := ibc_chrono.fieldbyname ( 'arf_id' ) .asinteger;
            que_recherche.fieldbyname ( 'art_id' ) .asinteger := ibc_chrono.fieldbyname ( 'arf_artid' ) .asinteger;
            que_recherche.fieldbyname ( 'arf_chrono' ) .asstring := texte;
            que_recherche.fieldbyname ( 'art_nom' ) .asstring := ibc_chrono.fieldbyname ( 'art_nom' ) .asstring;
            que_recherche.fieldbyname ( 'art_refmrk' ) .asstring := ibc_chrono.fieldbyname ( 'art_refmrk' ) .asstring;
            que_recherche.fieldbyname ( 'tgf_id' ) .asinteger := idtc;
            que_recherche.fieldbyname ( 'tgf_nom' ) .asstring := '';
            que_recherche.fieldbyname ( 'cou_id' ) .asinteger := idtc;
            que_recherche.fieldbyname ( 'cou_nom' ) .asstring := '';
            que_recherche.fieldbyname ( 'tva_taux' ) .asfloat := ibc_chrono.fieldbyname ( 'tva_taux' ) .asfloat;

            que_recherche.post;
        END;
    END;

    IF ( NOT ibc_ref.eof ) AND ( ibc_ref.active ) THEN
    BEGIN
        que_recherche.first;
        WHILE NOT que_recherche.eof DO
        BEGIN
            IF ibc_ref.fieldbyname ( 'arf_artid' ) .asinteger =
                que_recherche.fieldbyname ( 'art_id' ) .asinteger THEN
                Break
            ELSE
                que_recherche.next;
        END;
        IF que_recherche.eof THEN
        BEGIN
            que_recherche.insert;
            que_recherche.fieldbyname ( 'arf_id' ) .asinteger := ibc_ref.fieldbyname ( 'arf_id' ) .asinteger;
            que_recherche.fieldbyname ( 'art_id' ) .asinteger := ibc_ref.fieldbyname ( 'arf_artid' ) .asinteger;
            que_recherche.fieldbyname ( 'arf_chrono' ) .asstring := ibc_ref.fieldbyname ( 'arf_chrono' ) .asstring;
            que_recherche.fieldbyname ( 'art_nom' ) .asstring := ibc_ref.fieldbyname ( 'art_nom' ) .asstring;
            que_recherche.fieldbyname ( 'art_refmrk' ) .asstring := texte;
            que_recherche.fieldbyname ( 'tgf_id' ) .asinteger := idtc;
            que_recherche.fieldbyname ( 'tgf_nom' ) .asstring := '';
            que_recherche.fieldbyname ( 'cou_id' ) .asinteger := idtc;
            que_recherche.fieldbyname ( 'cou_nom' ) .asstring := '';
            que_recherche.fieldbyname ( 'tva_taux' ) .asfloat := ibc_ref.fieldbyname ( 'tva_taux' ) .asfloat;
            que_recherche.post;
        END;
    END;

    screen.Cursor := crDefault;

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
BEGIN
    FEtik := 0;
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

END.

