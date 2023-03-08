//------------------------------------------------------------------------------
// Nom de l'unité :  ConstStd
// Rôle           : Mise en place des variables globales de l'application
// Auteur         : Herve PULLUARD
// Historique     :
// 14/02/2001 - SG - v 1.4 : Ajout de GetStringParamValue, GetFloatParamValue
//                           Ajout du composant Convertor pour les devises
// 01/02/2001 - SM - v 1.3 : Mise en place des varaibles FSocieteName,FSocieteID
// 01/2001    - SG - v 1.2 : Mise en place des varaibles FMagasinName,FMagasinID,
//                          FPosteName,FPosteID
//                          De la restauration et la sauvegarde d'un fichier ini
//                          dans la table GENPOSTE
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
    RxCalc, IB_Components, Db, IBDataset, Wwdbgrid, ConvertorRv,EUGen;

TYPE
    TStdConst = CLASS ( TDataModule )
        Calc_Main: TRxCalculator;
        Mbox_Mess: TLMDMessageBoxDlg;
        SysInf_Main: TLMDSysInfo;
        Delay_Main: TBmDelay;
        Tip_Main: TALSTipDlg;
        PropSto_Const: TPropStorage;
        AppIni_Main: TAppIniFile;
        IniCtrl: TLMDIniCtrl;
    CurSto_Main: TCurrencyStorage;
    Que_Ini: TIBOQuery;
    MemoDlg_: TwwMemoDialog;
    IbC_GetParamDossier: TIB_Cursor;
    Convertor: TConvertorRv;
        PROCEDURE DataModuleCreate ( Sender: TObject ) ;
    procedure Que_IniAfterPost(DataSet: TDataSet);
    procedure Que_IniBeforeDelete(DataSet: TDataSet);
    procedure Que_IniBeforeEdit(DataSet: TDataSet);
    procedure Que_IniNewRecord(DataSet: TDataSet);
    procedure Que_IniUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
    Private
    { Déclarations privées }
        Fnl, Fcl: Boolean;
        FCalc: Double;
        FIniApp, FPatLect, FPatApp, FPatHelp: STRING;
        FSocieteName,FMagasinName,FPosteName  : String;
        FSocieteID,FMagasinID,FPosteID : Integer;
        PROCEDURE SetFnl ( Value: Boolean ) ;
        PROCEDURE SetFcl ( Value: Boolean ) ;
        PROCEDURE ConstDoInit;

    Public
    { Déclarations publiques }
        PROPERTY NumLock: Boolean Read Fnl Write SetFnl;
        PROPERTY Capslock: Boolean Read Fcl Write SetFcl;
        PROPERTY CalcResult: Double Read FCalc;

        PROPERTY IniFileName: STRING Read FIniApp;
        PROPERTY PathApp: STRING Read FPatApp;
        PROPERTY PathLecteur: STRING Read FPatLect;
        PROPERTY PathHelp: STRING Read FPatHelp;

        PROCEDURE LoadIniFileFromDatabase;
        PROCEDURE SaveIniFileToDatabase;

        FUNCTION GetStringParamValue ( ParamName : string ) : string;
        FUNCTION GetFloatParamValue ( ParamName : string ) : double;

        PROCEDURE InitConvertor;
        PROCEDURE ReInitConvertor;
        FUNCTION Convert ( Value : Extended ) : string;
        FUNCTION GetDefaultMnyRef : TMYTYP;
        FUNCTION GetDefaultMnyTgt : TMYTYP;

        FUNCTION GetISO ( Mny : TMYTYP ): string;
        FUNCTION GetTMYTYP ( ISO : string ): TMYTYP;

    Published
        property SocieteName : String read FSocieteName write FSocieteName;
        property MagasinName : String read FMagasinName write FMagasinName;
        property PosteName   : String read FPosteName write FPosteName;
        property SocieteID   : Integer read FSocieteID write FSocieteID;
        property MagasinID   : Integer read FMagasinID write FMagasinID;
        property PosteID     : Integer read FPosteID write FPosteID;
    END;

VAR
    StdConst: TStdConst;

//------------------------------------------------------------------------------
// Ressources strings
//------------------------------------------------------------------------------
RESOURCESTRING
{$I C:\Borland\Algol\Standards\Includes\ConstRes.Pas}
// **************************************************
// Ce fichier inclu contient toutes les ressources globales communes à nos applications
// ***********************************************************************

{$I C:\Borland\Algol\Standards\Includes\ConstUIL.Pas}
// **************************************************
// Ce fichier inclu contient toutes les ressources globales pour la gestion des droits utilisateur communes à nos applications
// ***********************************************************************

// Déclarer ci-dessous les ressources globales de cette application
// ***********************************************************************

{$I C:\Borland\Algol\Standards\Includes\ConstRoutines.Pas}
// *******************************************************
// Ce fichier inclu contient la déclaration de toutes les routines globales
// communes à nos applications
// ***********************************************************************
// Déclarer ci-dessous les routines globales de cette application
// ***********************************************************************

IMPLEMENTATION

USES StdUtils, Main_Dm;
{$R *.DFM}
{$I C:\Borland\Algol\Standards\Includes\ConstCode.Pas}
// ***************************************************
// Ce fichier inclu contient tout le code des routines globales communes

//------------------------------------------------------------------------------
// Procédures et fonctions internes
//------------------------------------------------------------------------------
PROCEDURE TStdConst.LoadIniFileFromDatabase;
BEGIN
  if (Dm_Main <> Nil) then begin
    if (ParamCount > 1) then
      Que_Ini.ParamByName('NOMPOSTE').AsString := UpperCase( ParamStr(2))
    else
      Que_Ini.ParamByName('NOMPOSTE').AsString := UpperCase( SysInf_Main.ComputerName );

    Que_Ini.Open;
    if not Que_Ini.Eof then
    begin
       FSocieteName := Que_Ini.FieldByName('SOC_NOM').AsString;
       FMagasinName := Que_Ini.FieldByName('MAG_NOM').AsString;
       FPosteName := Que_Ini.FieldByName('POS_NOM').AsString;
       FSocieteID := Que_Ini.FieldByName('SOC_ID').AsInteger;
       FMagasinID := Que_Ini.FieldByName('MAG_ID').AsInteger;
       FPosteID := Que_Ini.FieldByName('POS_ID').AsInteger;
       if (Que_Ini.FieldByName('POS_PARAM').AsString<>'') then
       begin
           MemoDlg_.Lines.Add(Que_Ini.FieldByName('POS_PARAM').AsString);
           MemoDlg_.Lines.SaveToFile(Appini_Main.IniFileName);
           PropSto_Const.Load;
       end;
    end;
    Que_Ini.Close;
  end;
END;

PROCEDURE TStdConst.SaveIniFileToDatabase;
BEGIN
  if (Dm_Main <> Nil) then begin
    if (ParamCount > 1) then
      Que_Ini.ParamByName('NOMPOSTE').AsString := UpperCase( ParamStr(2))
    else
      Que_Ini.ParamByName('NOMPOSTE').AsString := UpperCase( SysInf_Main.ComputerName );

    Que_Ini.Open;
    if not Que_Ini.Eof then begin
      Que_Ini.Edit;
      MemoDlg_.Lines.LoadFromFile(Appini_Main.IniFileName);
      Que_Ini.FieldByName('POS_PARAM').asString := MemoDlg_.Lines.Text;
      Que_Ini.Post;
    end;
    Que_Ini.Close;
  end;
END;

FUNCTION TStdConst.GetStringParamValue ( ParamName : string ) : string;
BEGIN
  IbC_GetParamDossier.Close;
  IbC_GetParamDossier.Prepare;
  IbC_GetParamDossier.ParamByName('PARAM_NAME').AsString := ParamName;
  IbC_GetParamDossier.Open;
  Result := IbC_GetParamDossier.FieldByName('DOS_STRING').AsString;
END;

FUNCTION TStdConst.GetFloatParamValue ( ParamName : string ) : double;
BEGIN
  IbC_GetParamDossier.Close;
  IbC_GetParamDossier.Prepare;
  IbC_GetParamDossier.ParamByName('PARAM_NAME').AsString := ParamName;
  IbC_GetParamDossier.Open;
  Result := IbC_GetParamDossier.FieldByName('DOS_FLOAT').AsFloat;
END;

PROCEDURE TStdConst.InitConvertor;
BEGIN
  Convertor.DefaultMnyRef :=
     Convertor.GetTMYTYP ( GetStringParamValue ( 'MONNAIE_REFERENCE' ) );
  Convertor.DefaultMnyTgt :=
     Convertor.GetTMYTYP ( GetStringParamValue ( 'MONNAIE_CIBLE' ) );
  Convertor.ReInit;
END;

PROCEDURE TStdConst.ReInitConvertor;
BEGIN
  Convertor.ReInit;
END;

FUNCTION TStdConst.Convert ( Value : Extended ) : string;
BEGIN
  Result := Convertor.Convert( Value );
END;

FUNCTION TStdConst.GetDefaultMnyRef : TMYTYP;
BEGIN
  Result := Convertor.DefaultMnyRef;
END;

FUNCTION TStdConst.GetDefaultMnyTgt : TMYTYP;
BEGIN
  Result := Convertor.DefaultMnyTgt;
END;

FUNCTION TStdConst.GetISO ( Mny : TMYTYP ): string;
BEGIN
  Result := Convertor.GetISO ( Mny );
END;

FUNCTION TStdConst.GetTMYTYP ( ISO : string ): TMYTYP;
BEGIN
  Result := Convertor.GetTMYTYP ( ISO );
END;


//------------------------------------------------------------------------------
// Gestionnaires d'événements
//------------------------------------------------------------------------------

PROCEDURE TStdConst.DataModuleCreate ( Sender: TObject ) ;
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

procedure TStdConst.Que_IniAfterPost(DataSet: TDataSet);
begin
  Dm_Main.IBOUpDateCache ( DataSet As TIBOQuery) ;
end;

procedure TStdConst.Que_IniBeforeDelete(DataSet: TDataSet);
begin
  if not Dm_Main.CheckAllowDelete ( ( DataSet As TIBODataSet).KeyRelation,
  DataSet.FieldByName(( DataSet As TIBODataSet).KeyLinks.IndexNames[0]).AsString,
  True ) then Abort;
end;

procedure TStdConst.Que_IniBeforeEdit(DataSet: TDataSet);
begin
  if not Dm_Main.CheckAllowEdit ( ( DataSet As TIBODataSet).KeyRelation,
  DataSet.FieldByName(( DataSet As TIBODataSet).KeyLinks.IndexNames[0]).AsString,
  True ) then Abort;
end;

procedure TStdConst.Que_IniNewRecord(DataSet: TDataSet);
begin
  if not Dm_Main.IBOMajPkKey ( ( DataSet As TIBODataSet),
  ( DataSet As TIBODataSet).KeyLinks.IndexNames[0] ) then Abort;
end;

procedure TStdConst.Que_IniUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
  Dm_Main.IBOUpdateRecord ( ( DataSet As TIBODataSet).KeyRelation,
                          ( DataSet As TIBODataSet),UpdateKind, UpdateAction );
end;

END.

