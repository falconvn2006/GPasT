//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------

UNIT ParamInit_Dm;

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
    dxmdaset,
    //IBoDataset,
    wwDialog,
    wwidlg,
    wwLookupDialogRv, IBODataset,variants;

TYPE
    TDm_ParamInit = CLASS(TDataModule)
        Grd_Que: TGroupDataRv;
        Que_Genre: TIBOQuery;
        MemD_Genre: TdxMemData;
        MemD_GenreGRE_NOM: TStringField;
        MemD_GenreGRE_IDREF: TIntegerField;
        Que_TCT: TIBOQuery;
        MemD_TCT: TdxMemData;
        MemD_TCTTCT_NOM: TStringField;
        MemD_TCTTCT_CODE: TStringField;
        Que_TVA: TIBOQuery;
        MemD_TVA: TdxMemData;
        MemD_TVATAUX: TStringField;
        MemD_TVACODE: TStringField;
        Que_Classement: TIBOQuery;
        MemD_Classement: TdxMemData;
        MemD_ClassementCLA_NOM: TStringField;
        MemD_ClassementCLA_TYPE: TStringField;
        MemD_ClassementCLA_NUM: TIntegerField;
        Que_ClaItem: TIBOQuery;
        Que_Civilite: TIBOQuery;
        MemD_Civilite: TdxMemData;
        MemD_CiviliteCIV_NOM: TStringField;
        MemD_CiviliteCIV_SEXE: TIntegerField;
        Que_CiviliteCIV_ID: TIntegerField;
        Que_CiviliteCIV_NOM: TStringField;
        Que_CiviliteCIV_SEXE: TIntegerField;
        Que_ModeR: TIBOQuery;
        MemD_ModeR: TdxMemData;
        MemD_ModeRMRG_LIB: TStringField;
        Que_CdtPaie: TIBOQuery;
        MemD_CdtPaie: TdxMemData;
        MemD_CdtPaieCPA_NOM: TStringField;
        Que_CptVente: TIBOQuery;
        MemD_CptVente: TdxMemData;
        MemD_CptVenteCVA_TYPE: TStringField;
        MemD_CptVenteCVA_TVA: TStringField;
        MemD_CptVenteCVA_VENTE: TStringField;
        MemD_CptVenteCVA_EXPORT: TStringField;
        MemD_CptVenteCVA_RETRO: TStringField;
        Que_GenreGRE_ID: TIntegerField;
        Que_GenreGRE_IDREF: TIntegerField;
        Que_GenreGRE_NOM: TStringField;
        Que_GenreGRE_SEXE: TIntegerField;
        MemD_CdtPaieCPA_CODE: TStringField;
        MemD_GenreGRE_SEXE: TStringField;
        Que_TVATVA_ID: TIntegerField;
        Que_TVATVA_TAUX: TIBOFloatField;
        Que_TVATVA_CODE: TStringField;
        Que_CptVenteCVA_ID: TIntegerField;
        Que_CptVenteCVA_TVAID: TIntegerField;
        Que_CptVenteCVA_TCTID: TIntegerField;
        Que_CptVenteCVA_ACHAT: TStringField;
        Que_CptVenteCVA_VENTE: TStringField;
        Que_CptVenteCVA_EXPORT: TStringField;
        Que_CptVenteCVA_RETRO: TStringField;
        Que_CptVenteTVA_TAUX: TIBOFloatField;
        Que_CptVenteTCT_NOM: TStringField;
        Ibq_conso: TIBOQuery;
        Que_ExeCom: TIBOQuery;
        LK_ExeCom: TwwLookupDialogRV;
        Que_ExeComEXE_ID: TIntegerField;
        Que_ExeComEXE_NOM: TStringField;
        Que_ExeComEXE_DEBUT: TDateTimeField;
        Que_ExeComEXE_FIN: TDateTimeField;
        Que_ExeComEXE_ANNEE: TIntegerField;
        PROCEDURE DataModuleCreate(Sender: TObject);
        PROCEDURE DataModuleDestroy(Sender: TObject);
        PROCEDURE Que_GenreAfterPost(DataSet: TDataSet);
        PROCEDURE Que_GenreBeforeDelete(DataSet: TDataSet);
        PROCEDURE Que_GenreBeforeEdit(DataSet: TDataSet);
        PROCEDURE Que_GenreNewRecord(DataSet: TDataSet);
        PROCEDURE Que_GenreUpdateRecord(DataSet: TDataSet;
            UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
        PROCEDURE Que_TCTAfterPost(DataSet: TDataSet);
        PROCEDURE Que_TCTBeforeDelete(DataSet: TDataSet);
        PROCEDURE Que_TCTBeforeEdit(DataSet: TDataSet);
        PROCEDURE Que_TCTNewRecord(DataSet: TDataSet);
        PROCEDURE Que_TCTUpdateRecord(DataSet: TDataSet;
            UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
        PROCEDURE Que_TVAAfterPost(DataSet: TDataSet);
        PROCEDURE Que_TVABeforeDelete(DataSet: TDataSet);
        PROCEDURE Que_TVABeforeEdit(DataSet: TDataSet);
        PROCEDURE Que_TVANewRecord(DataSet: TDataSet);
        PROCEDURE Que_TVAUpdateRecord(DataSet: TDataSet;
            UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
        PROCEDURE Que_ClassementAfterPost(DataSet: TDataSet);
        PROCEDURE Que_ClassementBeforeDelete(DataSet: TDataSet);
        PROCEDURE Que_ClassementBeforeEdit(DataSet: TDataSet);
        PROCEDURE Que_ClassementNewRecord(DataSet: TDataSet);
        PROCEDURE Que_ClassementUpdateRecord(DataSet: TDataSet;
            UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
        PROCEDURE Que_ClaItemAfterPost(DataSet: TDataSet);
        PROCEDURE Que_ClaItemBeforeDelete(DataSet: TDataSet);
        PROCEDURE Que_ClaItemBeforeEdit(DataSet: TDataSet);
        PROCEDURE Que_ClaItemNewRecord(DataSet: TDataSet);
        PROCEDURE Que_ClaItemUpdateRecord(DataSet: TDataSet;
            UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
        PROCEDURE Que_CiviliteAfterPost(DataSet: TDataSet);
        PROCEDURE Que_CiviliteBeforeDelete(DataSet: TDataSet);
        PROCEDURE Que_CiviliteBeforeEdit(DataSet: TDataSet);
        PROCEDURE Que_CiviliteNewRecord(DataSet: TDataSet);
        PROCEDURE Que_CiviliteUpdateRecord(DataSet: TDataSet;
            UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
        PROCEDURE Que_ModeRAfterPost(DataSet: TDataSet);
        PROCEDURE Que_ModeRBeforeDelete(DataSet: TDataSet);
        PROCEDURE Que_ModeRBeforeEdit(DataSet: TDataSet);
        PROCEDURE Que_ModeRNewRecord(DataSet: TDataSet);
        PROCEDURE Que_ModeRUpdateRecord(DataSet: TDataSet;
            UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
        PROCEDURE Que_CdtPaieAfterPost(DataSet: TDataSet);
        PROCEDURE Que_CdtPaieBeforeDelete(DataSet: TDataSet);
        PROCEDURE Que_CdtPaieBeforeEdit(DataSet: TDataSet);
        PROCEDURE Que_CdtPaieNewRecord(DataSet: TDataSet);
        PROCEDURE Que_CdtPaieUpdateRecord(DataSet: TDataSet;
            UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
        PROCEDURE Que_CptVenteAfterPost(DataSet: TDataSet);
        PROCEDURE Que_CptVenteBeforeDelete(DataSet: TDataSet);
        PROCEDURE Que_CptVenteBeforeEdit(DataSet: TDataSet);
        PROCEDURE Que_CptVenteNewRecord(DataSet: TDataSet);
        PROCEDURE Que_CptVenteUpdateRecord(DataSet: TDataSet;
            UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
        PROCEDURE Que_CiviliteCIV_SEXEGetText(Sender: TField; VAR Text: STRING;
            DisplayText: Boolean);
        PROCEDURE Que_GenreGRE_SEXEGetText(Sender: TField; VAR Text: STRING;
            DisplayText: Boolean);
        PROCEDURE Ibq_consoAfterDelete(DataSet: TDataSet);
        PROCEDURE Ibq_consoBeforeDelete(DataSet: TDataSet);
        PROCEDURE Ibq_consoBeforeEdit(DataSet: TDataSet);
        PROCEDURE Ibq_consoNewRecord(DataSet: TDataSet);
        PROCEDURE Ibq_consoUpdateRecord(DataSet: TDataSet;
            UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
        PROCEDURE Que_ExeComAfterPost(DataSet: TDataSet);
        PROCEDURE Que_ExeComBeforeDelete(DataSet: TDataSet);
        PROCEDURE Que_ExeComBeforeEdit(DataSet: TDataSet);
        PROCEDURE Que_ExeComNewRecord(DataSet: TDataSet);
        PROCEDURE Que_ExeComUpdateRecord(DataSet: TDataSet;
            UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
        PROCEDURE Que_ExeComEXE_DEBUTValidate(Sender: TField);
    PRIVATE
    { Déclarations privées }
    PUBLIC
    { Déclarations publiques }
        PROCEDURE Refresh;
        PROCEDURE Genre; //1
        PROCEDURE TypeComptable; //2
        PROCEDURE TVA; //3
        PROCEDURE Classement; //4
        PROCEDURE Civilite; //5
        PROCEDURE ModeReglement; //6
        PROCEDURE ConditionPaie; //7
        PROCEDURE CptVente; //8
        PROCEDURE Conso; //9

    END;

VAR
    Dm_ParamInit: TDm_ParamInit;

//------------------------------------------------------------------------------
// Ressources strings
//------------------------------------------------------------------------------
RESOURCESTRING
    NomHomme = 'Homme';
    NomFemme = 'Femme';
    NomEnfant = 'Enfant';

IMPLEMENTATION
USES ginkoiastd,
    ginkoiaresstr,
    Main_Dm,
    Main_Frm,
    StdDateUtils;
{$R *.DFM}

//------------------------------------------------------------------------------
// Procédures et fonctions internes
//------------------------------------------------------------------------------

PROCEDURE TDm_ParamInit.Refresh;
BEGIN
    Grd_Que.Refresh;
END;

PROCEDURE TDm_ParamInit.Genre;
BEGIN
    Que_Genre.Open;
    MemD_Genre.Close;
    MemD_Genre.DelimiterChar := ';';
    MemD_Genre.Open;
    MemD_Genre.LoadFromTextFile(Frm_Main.cheminFicInit + 'Genre.txt');
    MemD_Genre.First;
    WHILE NOT MemD_Genre.Eof DO
    BEGIN
        IF NOT Que_Genre.Locate('GRE_NOM', MemD_Genre.FieldByName('GRE_NOM').asString, []) THEN
        BEGIN
            Que_Genre.Insert;
            Que_Genre.FieldByName('GRE_NOM').asString := MemD_Genre.FieldByName('GRE_NOM').asString;
            Que_Genre.FieldByName('GRE_SEXE').asInteger := StrToInt(MemD_Genre.FieldByName('GRE_SEXE').asString);
            Que_Genre.FieldByName('GRE_IDREF').asInteger := MemD_Genre.FieldByName('GRE_IDREF').asInteger;
            Que_Genre.Post;
        END
        ELSE
        BEGIN
            Que_Genre.Edit;
            Que_Genre.FieldByName('GRE_NOM').asString := MemD_Genre.FieldByName('GRE_NOM').asString;
            Que_Genre.FieldByName('GRE_SEXE').asInteger := StrToInt(MemD_Genre.FieldByName('GRE_SEXE').asString);
            Que_Genre.FieldByName('GRE_IDREF').asInteger := MemD_Genre.FieldByName('GRE_IDREF').asInteger;
            Que_Genre.Post;
        END;
        MemD_Genre.next;
    END;
    Que_Genre.Close;
    Que_Genre.Open;
END;

PROCEDURE TDm_ParamInit.TypeComptable;
BEGIN
    Que_TCT.Open;
    MemD_TCT.Close;
    MemD_TCT.DelimiterChar := ';';
    MemD_TCT.Open;
    MemD_TCT.LoadFromTextFile(Frm_Main.cheminFicInit + 'TypeComptabledeVente.txt');
    MemD_TCT.First;
    WHILE NOT MemD_TCT.Eof DO
    BEGIN
        IF NOT Que_TCT.Locate('TCT_NOM', MemD_TCT.FieldByName('TCT_NOM').asString, []) THEN
        BEGIN
            Que_TCT.Insert;
            Que_TCT.FieldByName('TCT_NOM').asString := MemD_TCT.FieldByName('TCT_NOM').asString;
            Que_TCT.FieldByName('TCT_CODE').asInteger := MemD_TCT.FieldByName('TCT_CODE').asInteger;
            Que_TCT.Post;
        END
        ELSE
        BEGIN
            Que_TCT.Edit;
            Que_TCT.FieldByName('TCT_NOM').asString := MemD_TCT.FieldByName('TCT_NOM').asString;
            Que_TCT.FieldByName('TCT_CODE').asInteger := MemD_TCT.FieldByName('TCT_CODE').asInteger;
            Que_TCT.Post;
        END;
        MemD_TCT.next;
    END;
    Que_TCT.Close;
    Que_TCT.Open;
END;

PROCEDURE TDm_ParamInit.TVA;
BEGIN
    Que_TVA.Open;
    MemD_TVA.Close;
    MemD_TVA.DelimiterChar := ';';
    MemD_TVA.Open;
    MemD_TVA.LoadFromTextFile(Frm_Main.cheminFicInit + 'TVA.txt');
    MemD_TVA.First;
    WHILE NOT MemD_TVA.Eof DO
    BEGIN
        IF NOT Que_TVA.Locate('TVA_TAUX', MemD_TVA.FieldByName('TVA_TAUX').asString, []) THEN
        BEGIN
            Que_TVA.Insert;
            Que_TVA.FieldByName('TVA_TAUX').asFloat := StrToFloat(MemD_TVA.FieldByName('TVA_TAUX').asString);
            Que_TVA.FieldByName('TVA_CODE').asInteger := StrtoInt(MemD_TVA.FieldByName('TVA_CODE').asString);
            Que_TVA.Post;
        END
        ELSE
        BEGIN
            Que_TVA.Edit;
            Que_TVA.FieldByName('TVA_TAUX').asFloat := StrToFloat(MemD_TVA.FieldByName('TVA_TAUX').asString);
            Que_TVA.FieldByName('TVA_CODE').asInteger := StrtoInt(MemD_TVA.FieldByName('TVA_CODE').asString);
            Que_TVA.Post;
        END;
        MemD_TVA.next;
    END;
    Que_TVA.Close;
    Que_TVA.Open;
END;

PROCEDURE TDm_ParamInit.Classement;
BEGIN
    Que_Classement.Open;
    Que_ClaItem.Open;
    MemD_Classement.Close;
    MemD_Classement.DelimiterChar := ';';
    MemD_Classement.Open;
    MemD_Classement.LoadFromTextFile(Frm_Main.cheminFicInit + 'Classement.txt');
    MemD_Classement.First;
    WHILE NOT MemD_Classement.Eof DO
    BEGIN
        IF (MemD_Classement.FieldByName('CLA_NUM').asString <> '') AND NOT Que_Classement.Locate('CLA_TYPE;CLA_NUM', vararrayof([MemD_Classement.FieldByName('CLA_TYPE').asString, StrToInt(MemD_Classement.FieldByName('CLA_NUM').asString)]), []) THEN
        BEGIN
            Que_Classement.Insert;
            Que_Classement.FieldByName('CLA_NOM').asString := MemD_Classement.FieldByName('CLA_NOM').asString;
            Que_Classement.FieldByName('CLA_TYPE').asString := MemD_Classement.FieldByName('CLA_TYPE').asString;
            Que_Classement.FieldByName('CLA_NUM').asInteger := MemD_Classement.FieldByName('CLA_NUM').asInteger;
            Que_Classement.Post;
            Que_ClaItem.Insert;
            Que_ClaItem.FieldByName('CIT_CLAID').asInteger := Que_Classement.FieldByName('CLA_ID').asInteger;
            Que_ClaItem.FieldByName('CIT_ICLID').asInteger := 0;
            Que_ClaItem.Post;
        END
        ELSE
        BEGIN
            Que_Classement.Edit;
            Que_Classement.FieldByName('CLA_NOM').asString := MemD_Classement.FieldByName('CLA_NOM').asString;
            Que_Classement.FieldByName('CLA_TYPE').asString := MemD_Classement.FieldByName('CLA_TYPE').asString;
            Que_Classement.FieldByName('CLA_NUM').asInteger := MemD_Classement.FieldByName('CLA_NUM').asInteger;
            Que_Classement.Post;
        END;
        MemD_Classement.next;
    END;
    Que_ClaItem.close;
    Que_Classement.Close;
    Que_Classement.Open;
END;

PROCEDURE TDm_ParamInit.Civilite; //5
BEGIN
    Que_Civilite.Open;
    MemD_Civilite.Close;
    MemD_Civilite.DelimiterChar := ';';
    MemD_Civilite.Open;
    MemD_Civilite.LoadFromTextFile(Frm_Main.cheminFicInit + 'Civilite.txt');
    MemD_Civilite.First;
    WHILE NOT MemD_Civilite.Eof DO
    BEGIN
        IF NOT Que_Civilite.Locate('CIV_NOM', MemD_Civilite.FieldByName('CIV_NOM').asString, []) THEN
        BEGIN
            Que_Civilite.Insert;
            Que_Civilite.FieldByName('CIV_NOM').asString := MemD_Civilite.FieldByName('CIV_NOM').asString;
            Que_Civilite.FieldByName('CIV_SEXE').asInteger := MemD_Civilite.FieldByName('CIV_SEXE').asInteger;
            Que_Civilite.Post;
        END
        ELSE
        BEGIN
            Que_Civilite.Edit;
            Que_Civilite.FieldByName('CIV_NOM').asString := MemD_Civilite.FieldByName('CIV_NOM').asString;
            Que_Civilite.FieldByName('CIV_SEXE').asInteger := MemD_Civilite.FieldByName('CIV_SEXE').asInteger;
            Que_Civilite.Post;
        END;
        MemD_Civilite.next;
    END;
    Que_Civilite.Close;
    Que_Civilite.Open;
END;

PROCEDURE TDm_ParamInit.ModeReglement; //6
BEGIN
    Que_ModeR.Open;
    MemD_ModeR.Close;
    MemD_ModeR.DelimiterChar := ';';
    MemD_ModeR.Open;
    MemD_ModeR.LoadFromTextFile(Frm_Main.cheminFicInit + 'ModeRglt.txt');
    MemD_ModeR.First;
    WHILE NOT MemD_ModeR.Eof DO
    BEGIN
        IF NOT Que_ModeR.Locate('MRG_LIB', MemD_ModeR.FieldByName('MRG_LIB').asString, []) THEN
        BEGIN
            Que_ModeR.Insert;
            Que_ModeR.FieldByName('MRG_LIB').asString := MemD_ModeR.FieldByName('MRG_LIB').asString;
            Que_ModeR.Post;
        END
        ELSE
        BEGIN
            Que_ModeR.Edit;
            Que_ModeR.FieldByName('MRG_LIB').asString := MemD_ModeR.FieldByName('MRG_LIB').asString;
            Que_ModeR.Post;
        END;
        MemD_ModeR.next;
    END;
    Que_ModeR.Close;
    Que_ModeR.Open;
END;

PROCEDURE TDm_ParamInit.ConditionPaie; //7
BEGIN
    Que_CdtPaie.Open;
    MemD_CdtPaie.Close;
    MemD_CdtPaie.DelimiterChar := ';';
    MemD_CdtPaie.Open;
    MemD_CdtPaie.LoadFromTextFile(Frm_Main.cheminFicInit + 'ConditionPaie.txt');
    MemD_CdtPaie.First;
    WHILE NOT MemD_CdtPaie.Eof DO
    BEGIN
        IF NOT Que_CdtPaie.Locate('CPA_NOM', MemD_CdtPaie.FieldByName('CPA_NOM').asString, []) THEN
        BEGIN
            Que_CdtPaie.Insert;
            Que_CdtPaie.FieldByName('CPA_NOM').asString := MemD_CdtPaie.FieldByName('CPA_NOM').asString;
            IF (MemD_CdtPaie.FieldByName('CPA_CODE').asString <> '') THEN
                Que_CdtPaie.FieldByName('CPA_CODE').asInteger := StrToInt(MemD_CdtPaie.FieldByName('CPA_CODE').asString)
            ELSE Que_CdtPaie.FieldByName('CPA_CODE').asInteger := 0;
            Que_CdtPaie.Post;
        END
        ELSE
        BEGIN
            Que_CdtPaie.Edit;
            Que_CdtPaie.FieldByName('CPA_NOM').asString := MemD_CdtPaie.FieldByName('CPA_NOM').asString;
            IF (MemD_CdtPaie.FieldByName('CPA_CODE').asString <> '') THEN
                Que_CdtPaie.FieldByName('CPA_CODE').asInteger := StrToInt(MemD_CdtPaie.FieldByName('CPA_CODE').asString)
            ELSE Que_CdtPaie.FieldByName('CPA_CODE').asInteger := 0;
            Que_CdtPaie.Post;
        END;
        MemD_CdtPaie.next;
    END;
    Que_CdtPaie.Close;
    Que_CdtPaie.Open;
END;

PROCEDURE TDm_ParamInit.CptVente; //8
VAR TVA, TCT: Integer;
BEGIN
    Que_TCT.Open;
    Que_TVA.Open;
    Que_CptVente.Open;
    MemD_CptVente.Close;
    MemD_CptVente.DelimiterChar := ';';
    MemD_CptVente.Open;
    MemD_CptVente.LoadFromTextFile(Frm_Main.cheminFicInit + 'CptVente.txt');
    MemD_CptVente.First;
    WHILE NOT MemD_CptVente.Eof DO
    BEGIN
        IF Que_TVA.Locate('TVA_TAUX', MemD_CptVente.FieldByName('CVA_TVA').asString, []) THEN
            TVA := Que_TVA.FieldByName('TVA_ID').asInteger
        ELSE
            TVA := 0;
        IF Que_TCT.Locate('TCT_NOM', MemD_CptVente.FieldByName('CVA_TYPE').asString, []) THEN
            TCT := Que_TCT.FieldByName('TCT_ID').asInteger
        ELSE
            TCT := 0;
        IF NOT Que_CptVente.Locate('CVA_TVAID;CVA_TCTID', vararrayof([TVA, TCT]), []) THEN
        BEGIN
            Que_CptVente.Insert;
            Que_CptVente.FieldByName('CVA_TVAID').asInteger := TVA;
            Que_CptVente.FieldByName('CVA_TCTID').asInteger := TCT;
            Que_CptVente.FieldByName('CVA_VENTE').asString := MemD_CptVente.FieldByName('CVA_VENTE').asString;
            Que_CptVente.FieldByName('CVA_EXPORT').asString := MemD_CptVente.FieldByName('CVA_EXPORT').asString;
            Que_CptVente.FieldByName('CVA_RETRO').asString := MemD_CptVente.FieldByName('CVA_RETRO').asString;
            Que_CptVente.Post;
        END
        ELSE
        BEGIN
            Que_CptVente.Edit;
            Que_CptVente.FieldByName('CVA_TVAID').asInteger := TVA;
            Que_CptVente.FieldByName('CVA_TCTID').asInteger := TCT;
            Que_CptVente.FieldByName('CVA_VENTE').asString := MemD_CptVente.FieldByName('CVA_VENTE').asString;
            Que_CptVente.FieldByName('CVA_EXPORT').asString := MemD_CptVente.FieldByName('CVA_EXPORT').asString;
            Que_CptVente.FieldByName('CVA_RETRO').asString := MemD_CptVente.FieldByName('CVA_RETRO').asString;
            Que_CptVente.Post;
        END;
        MemD_CptVente.next;
    END;
    Que_CptVente.Close;
    Que_CptVente.Open;
    Que_TCT.Close;
    Que_TVA.Close;
END;

PROCEDURE TDm_ParamInit.Conso; //9
BEGIN

    ibq_conso.open;
    IF NOT ibq_conso.Locate('TYP_LIB;TYP_COD;TYP_CATEG', vararrayof(['Régularisation de stock', 20, 7]), []) THEN
    BEGIN
        ibq_conso.insert;
        ibq_conso.fieldbyname('typ_lib').asstring := 'Régularisation de stock';
        ibq_conso.fieldbyname('typ_cod').asinteger := 20;
        ibq_conso.fieldbyname('typ_Categ').asinteger := 7;
        Ibq_conso.post;
    END;

    IF NOT ibq_conso.Locate('TYP_LIB;TYP_COD;TYP_CATEG', vararrayof(['Vol ou perte connu', 21, 7]), []) THEN
    BEGIN
        ibq_conso.insert;
        ibq_conso.fieldbyname('typ_lib').asstring := 'Vol ou perte connu';
        ibq_conso.fieldbyname('typ_cod').asinteger := 21;
        ibq_conso.fieldbyname('typ_Categ').asinteger := 7;
        Ibq_conso.post;
    END;

    IF NOT ibq_conso.Locate('TYP_LIB;TYP_COD;TYP_CATEG', vararrayof(['Prélèvement personnel', 22, 4]), []) THEN
    BEGIN
        ibq_conso.insert;
        ibq_conso.fieldbyname('typ_lib').asstring := 'Prélèvement personnel';
        ibq_conso.fieldbyname('typ_cod').asinteger := 22;
        ibq_conso.fieldbyname('typ_Categ').asinteger := 4;
        Ibq_conso.post;
    END;

    IF NOT ibq_conso.Locate('TYP_LIB;TYP_COD;TYP_CATEG', vararrayof(['Mis en location', 23, 4]), []) THEN
    BEGIN
        ibq_conso.insert;
        ibq_conso.fieldbyname('typ_lib').asstring := 'Mis en location';
        ibq_conso.fieldbyname('typ_cod').asinteger := 23;
        ibq_conso.fieldbyname('typ_Categ').asinteger := 4;
        Ibq_conso.post;
    END;

    IF NOT ibq_conso.Locate('TYP_LIB;TYP_COD;TYP_CATEG', vararrayof(['Atelier', 24, 4]), []) THEN
    BEGIN
        ibq_conso.insert;
        ibq_conso.fieldbyname('typ_lib').asstring := 'Atelier';
        ibq_conso.fieldbyname('typ_cod').asinteger := 24;
        ibq_conso.fieldbyname('typ_Categ').asinteger := 4;
        Ibq_conso.post;
    END;

    IF NOT ibq_conso.Locate('TYP_LIB;TYP_COD;TYP_CATEG', vararrayof(['Cadeaux', 25, 7]), []) THEN
    BEGIN
        ibq_conso.insert;
        ibq_conso.fieldbyname('typ_lib').asstring := 'Cadeaux';
        ibq_conso.fieldbyname('typ_cod').asinteger := 25;
        ibq_conso.fieldbyname('typ_Categ').asinteger := 7;
        Ibq_conso.post;
    END;

    IF NOT ibq_conso.Locate('TYP_LIB;TYP_COD;TYP_CATEG', vararrayof(['Autres sorties', 26, 4]), []) THEN
    BEGIN
        ibq_conso.insert;
        ibq_conso.fieldbyname('typ_lib').asstring := 'Autres sorties';
        ibq_conso.fieldbyname('typ_cod').asinteger := 26;
        ibq_conso.fieldbyname('typ_Categ').asinteger := 4;
        Ibq_conso.post;
    END;

    IF NOT ibq_conso.Locate('TYP_LIB;TYP_COD;TYP_CATEG', vararrayof(['Ventes Normales', 1, 5]), []) THEN
    BEGIN
        ibq_conso.insert;
        ibq_conso.fieldbyname('typ_lib').asstring := 'Ventes Normales';
        ibq_conso.fieldbyname('typ_cod').asinteger := 1;
        ibq_conso.fieldbyname('typ_Categ').asinteger := 5;
        Ibq_conso.post;
    END;

    IF NOT ibq_conso.Locate('TYP_LIB;TYP_COD;TYP_CATEG', vararrayof(['Ventes Promo', 3, 5]), []) THEN
    BEGIN
        ibq_conso.insert;
        ibq_conso.fieldbyname('typ_lib').asstring := 'Ventes Promo';
        ibq_conso.fieldbyname('typ_cod').asinteger := 3;
        ibq_conso.fieldbyname('typ_Categ').asinteger := 5;
        Ibq_conso.post;
    END;

    IF NOT ibq_conso.Locate('TYP_LIB;TYP_COD;TYP_CATEG', vararrayof(['Ventes Soldées', 2, 5]), []) THEN
    BEGIN
        ibq_conso.insert;
        ibq_conso.fieldbyname('typ_lib').asstring := 'Ventes Soldées';
        ibq_conso.fieldbyname('typ_cod').asinteger := 2;
        ibq_conso.fieldbyname('typ_Categ').asinteger := 5;
        Ibq_conso.post;
    END;

    IF NOT ibq_conso.Locate('TYP_LIB;TYP_COD;TYP_CATEG', vararrayof(['Ventes aux Professionnels', 5, 5]), []) THEN
    BEGIN
        ibq_conso.insert;
        ibq_conso.fieldbyname('typ_lib').asstring := 'Ventes aux Professionnels';
        ibq_conso.fieldbyname('typ_cod').asinteger := 5;
        ibq_conso.fieldbyname('typ_Categ').asinteger := 5;
        Ibq_conso.post;
    END;

    IF NOT ibq_conso.Locate('TYP_LIB;TYP_COD;TYP_CATEG', vararrayof(['Rétrocessions externes', 6, 4]), []) THEN
    BEGIN
        ibq_conso.insert;
        ibq_conso.fieldbyname('typ_lib').asstring := 'Rétrocessions externes';
        ibq_conso.fieldbyname('typ_cod').asinteger := 6;
        ibq_conso.fieldbyname('typ_Categ').asinteger := 4;
        Ibq_conso.post;
    END;

    Ibq_conso.close;
    Ibq_conso.Open;
END;

//------------------------------------------------------------------------------
// Gestionnaires d'événements
//------------------------------------------------------------------------------

PROCEDURE TDm_ParamInit.DataModuleCreate(Sender: TObject);
BEGIN
//  Grd_Que.Open;
END;

PROCEDURE TDm_ParamInit.DataModuleDestroy(Sender: TObject);
BEGIN
    Grd_Que.Close;
END;

PROCEDURE TDm_ParamInit.Que_GenreAfterPost(DataSet: TDataSet);
BEGIN
    Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TDm_ParamInit.Que_GenreBeforeDelete(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.CheckAllowDelete((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN Abort;
END;

PROCEDURE TDm_ParamInit.Que_GenreBeforeEdit(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.CheckAllowEdit((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN Abort;
END;

PROCEDURE TDm_ParamInit.Que_GenreNewRecord(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
        (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;
    Que_Genre.FieldByName('GRE_IDREF').asInteger := 0;
END;

PROCEDURE TDm_ParamInit.Que_GenreUpdateRecord(DataSet: TDataSet;
    UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
    Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
        (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TDm_ParamInit.Que_TCTAfterPost(DataSet: TDataSet);
BEGIN
    Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TDm_ParamInit.Que_TCTBeforeDelete(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.CheckAllowDelete((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN Abort;
END;

PROCEDURE TDm_ParamInit.Que_TCTBeforeEdit(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.CheckAllowEdit((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN Abort;
END;

PROCEDURE TDm_ParamInit.Que_TCTNewRecord(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
        (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;
END;

PROCEDURE TDm_ParamInit.Que_TCTUpdateRecord(DataSet: TDataSet;
    UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
    Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
        (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TDm_ParamInit.Que_TVAAfterPost(DataSet: TDataSet);
BEGIN
    Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TDm_ParamInit.Que_TVABeforeDelete(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.CheckAllowDelete((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN Abort;
END;

PROCEDURE TDm_ParamInit.Que_TVABeforeEdit(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.CheckAllowEdit((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN Abort;
END;

PROCEDURE TDm_ParamInit.Que_TVANewRecord(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
        (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;
END;

PROCEDURE TDm_ParamInit.Que_TVAUpdateRecord(DataSet: TDataSet;
    UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
    Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
        (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TDm_ParamInit.Que_ClassementAfterPost(DataSet: TDataSet);
BEGIN
    Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TDm_ParamInit.Que_ClassementBeforeDelete(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.CheckAllowDelete((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN Abort;
END;

PROCEDURE TDm_ParamInit.Que_ClassementBeforeEdit(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.CheckAllowEdit((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN Abort;
END;

PROCEDURE TDm_ParamInit.Que_ClassementNewRecord(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
        (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;
END;

PROCEDURE TDm_ParamInit.Que_ClassementUpdateRecord(DataSet: TDataSet;
    UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
    Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
        (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TDm_ParamInit.Que_ClaItemAfterPost(DataSet: TDataSet);
BEGIN
    Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TDm_ParamInit.Que_ClaItemBeforeDelete(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.CheckAllowDelete((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN Abort;
END;

PROCEDURE TDm_ParamInit.Que_ClaItemBeforeEdit(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.CheckAllowEdit((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN Abort;
END;

PROCEDURE TDm_ParamInit.Que_ClaItemNewRecord(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
        (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;
END;

PROCEDURE TDm_ParamInit.Que_ClaItemUpdateRecord(DataSet: TDataSet;
    UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
    Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
        (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TDm_ParamInit.Que_CiviliteAfterPost(DataSet: TDataSet);
BEGIN
    Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TDm_ParamInit.Que_CiviliteBeforeDelete(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.CheckAllowDelete((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN Abort;
END;

PROCEDURE TDm_ParamInit.Que_CiviliteBeforeEdit(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.CheckAllowEdit((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN Abort;
END;

PROCEDURE TDm_ParamInit.Que_CiviliteNewRecord(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
        (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;
    Que_Civilite.FieldByName('CIV_SEXE').asInteger := 0;
END;

PROCEDURE TDm_ParamInit.Que_CiviliteUpdateRecord(DataSet: TDataSet;
    UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
    Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
        (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TDm_ParamInit.Que_ModeRAfterPost(DataSet: TDataSet);
BEGIN
    Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TDm_ParamInit.Que_ModeRBeforeDelete(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.CheckAllowDelete((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN Abort;
END;

PROCEDURE TDm_ParamInit.Que_ModeRBeforeEdit(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.CheckAllowEdit((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN Abort;
END;

PROCEDURE TDm_ParamInit.Que_ModeRNewRecord(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
        (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;
END;

PROCEDURE TDm_ParamInit.Que_ModeRUpdateRecord(DataSet: TDataSet;
    UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
    Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
        (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TDm_ParamInit.Que_CdtPaieAfterPost(DataSet: TDataSet);
BEGIN
    Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TDm_ParamInit.Que_CdtPaieBeforeDelete(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.CheckAllowDelete((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN Abort;
END;

PROCEDURE TDm_ParamInit.Que_CdtPaieBeforeEdit(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.CheckAllowEdit((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN Abort;
END;

PROCEDURE TDm_ParamInit.Que_CdtPaieNewRecord(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
        (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;
END;

PROCEDURE TDm_ParamInit.Que_CdtPaieUpdateRecord(DataSet: TDataSet;
    UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
    Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
        (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TDm_ParamInit.Que_CptVenteAfterPost(DataSet: TDataSet);
BEGIN
    Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TDm_ParamInit.Que_CptVenteBeforeDelete(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.CheckAllowDelete((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN Abort;
END;

PROCEDURE TDm_ParamInit.Que_CptVenteBeforeEdit(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.CheckAllowEdit((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN Abort;
END;

PROCEDURE TDm_ParamInit.Que_CptVenteNewRecord(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
        (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;
    Que_CptVente.FieldByName('CVA_TVAID').asInteger := 0;
    Que_CptVente.FieldByName('CVA_TCTID').asInteger := 0;
END;

PROCEDURE TDm_ParamInit.Que_CptVenteUpdateRecord(DataSet: TDataSet;
    UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
    Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
        (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TDm_ParamInit.Que_CiviliteCIV_SEXEGetText(Sender: TField;
    VAR Text: STRING; DisplayText: Boolean);
BEGIN
    CASE Que_Civilite.FieldByName('CIV_SEXE').asInteger OF
        0: Text := ' ';
        1: Text := NomHomme;
        2: Text := NomFemme;
        3: Text := NomEnfant;
    END;
END;

PROCEDURE TDm_ParamInit.Que_GenreGRE_SEXEGetText(Sender: TField;
    VAR Text: STRING; DisplayText: Boolean);
BEGIN
    CASE Que_Genre.FieldByName('GRE_SEXE').asInteger OF
        0: Text := ' ';
        1: Text := NomHomme;
        2: Text := NomFemme;
        3: Text := NomEnfant;
    END;
END;

PROCEDURE TDm_ParamInit.Ibq_consoAfterDelete(DataSet: TDataSet);
BEGIN
    Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TDm_ParamInit.Ibq_consoBeforeDelete(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.CheckAllowDelete((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN Abort;
END;

PROCEDURE TDm_ParamInit.Ibq_consoBeforeEdit(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.CheckAllowEdit((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN Abort;

END;

PROCEDURE TDm_ParamInit.Ibq_consoNewRecord(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
        (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;
END;

PROCEDURE TDm_ParamInit.Ibq_consoUpdateRecord(DataSet: TDataSet;
    UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
    Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
        (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TDm_ParamInit.Que_ExeComAfterPost(DataSet: TDataSet);
BEGIN
    Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TDm_ParamInit.Que_ExeComBeforeDelete(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.CheckAllowDelete((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN Abort;
END;

PROCEDURE TDm_ParamInit.Que_ExeComBeforeEdit(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.CheckAllowEdit((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN Abort;
END;

PROCEDURE TDm_ParamInit.Que_ExeComNewRecord(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
        (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;
END;

PROCEDURE TDm_ParamInit.Que_ExeComUpdateRecord(DataSet: TDataSet;
    UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
    Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
        (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TDm_ParamInit.Que_ExeComEXE_DEBUTValidate(Sender: TField);
BEGIN
    Que_ExeCom.FieldByname('EXE_FIN').asDateTime := AddYears(Que_ExeCom.FieldByname('EXE_DEBUT').asDateTime, 1) - 1;
    IF (StrToInt(FormatDateTime('mm', Que_ExeCom.FieldByname('EXE_DEBUT').asDateTime)) > 07) THEN
        Que_ExeCom.FieldByname('EXE_ANNEE').asInteger := StrToInt(FormatDateTime('yyyy', Que_ExeCom.FieldByname('EXE_FIN').AsDateTime))
    ELSE
        Que_ExeCom.FieldByname('EXE_ANNEE').asInteger := StrToInt(FormatDateTime('yyyy', Que_ExeCom.FieldByname('EXE_DEBUT').AsDateTime));
END;

END.
