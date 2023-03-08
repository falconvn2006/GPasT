//------------------------------------------------------------------------------
// Nom de l'unité :  ConstStd
// Rôle           : Mise en place des variables globales de l'application
// Auteur         : Herve PULLUARD
// Historique     :
//------------------------------------------------------------------------------

UNIT ConstStd;

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
    LMDIniCtrl,
    vgStndrt,
    ALSTDlg,
    BmDelay,
    LMDSysInfo,
    LMDCustomComponent,
    LMDContainerComponent,
    lmdmsg,
    RxCalc;

TYPE
    TStdConst = CLASS(TDataModule)
        Calc_Main: TRxCalculator;
        Mbox_Mess: TLMDMessageBoxDlg;
        SysInf_Main: TLMDSysInfo;
        Delay_Main: TBmDelay;
        Tip_Main: TALSTipDlg;
        PropSto_Const: TPropStorage;
        AppIni_Main: TAppIniFile;
        IniCtrl: TLMDIniCtrl;
        CurSto_Main: TCurrencyStorage;
        TimeSto_Main: TDateTimeStorage;
        PROCEDURE DataModuleCreate(Sender: TObject);
    PRIVATE
    { Déclarations privées }
        Fnl, Fcl: Boolean;
        FCalc: Double;

        FNM, FNP, FPatBase, FIniApp, FPatLect, FPatApp, FPatHelp: STRING;
        PROCEDURE SetFnl(Value: Boolean);
        PROCEDURE SetFcl(Value: Boolean);
        PROCEDURE ConstDoInit;

    PUBLIC
    { Déclarations publiques }
        PROPERTY NumLock: Boolean READ Fnl WRITE SetFnl;
        PROPERTY Capslock: Boolean READ Fcl WRITE SetFcl;
        PROPERTY CalcResult: Double READ FCalc;

        PROPERTY IniFileName: STRING READ FIniApp;
        PROPERTY PathApp: STRING READ FPatApp;
        PROPERTY PathLecteur: STRING READ FPatLect;
        PROPERTY PathHelp: STRING READ FPatHelp;
        PROPERTY PathBase: STRING READ FPatBase WRITE FPatBase;
        PROPERTY NomPoste: STRING READ FNP WRITE FNP;
        PROPERTY NomDuMag: STRING READ FNM WRITE FNM;

    PUBLISHED
    END;

VAR
    StdConst: TStdConst;

//------------------------------------------------------------------------------
// Ressources strings
//------------------------------------------------------------------------------
RESOURCESTRING
{$I ConstRes.Pas}
// **************************************************
// Ce fichier inclu contient toutes les ressources globales communes à nos applications
// ***********************************************************************

{$I ConstUIL.Pas}
// **************************************************
// Ce fichier inclu contient toutes les ressources globales pour la gestion des droits utilisateur communes à nos applications
// ***********************************************************************

// Déclarer ci-dessous les ressources globales de cette application
// ***********************************************************************

{$I ConstRoutines.Pas}
// *******************************************************
// Ce fichier inclu contient la déclaration de toutes les routines globales
// communes à nos applications
// ***********************************************************************
// Déclarer ci-dessous les routines globales de cette application
// ***********************************************************************

IMPLEMENTATION

USES StdUtils;

{$R *.DFM}
{$I ConstCode.Pas}
// ***************************************************
// Ce fichier inclu contient tout le code des routines globales communes

//------------------------------------------------------------------------------
// Procédures et fonctions internes
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Gestionnaires d'événements
//------------------------------------------------------------------------------

PROCEDURE TStdConst.DataModuleCreate(Sender: TObject);
BEGIN

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

END;


END.

