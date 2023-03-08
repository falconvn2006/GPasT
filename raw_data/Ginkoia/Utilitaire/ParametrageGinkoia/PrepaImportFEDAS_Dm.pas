//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------

UNIT PrepaImportFEDAS_Dm;

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
    splashms;

TYPE
    TDm_PrepaImportFEDAS = CLASS(TDataModule)
        Grd_Close: TGroupDataRv;
        MemD_CSV: TdxMemData;
        MemD_CSVCAT_REF: TStringField;
        MemD_CSVCATEGORIE: TStringField;
        MemD_CSVACT_REF: TStringField;
        MemD_CSVACTIVITE: TStringField;
        MemD_CSVGRP_REF: TStringField;
        MemD_CSVGROUPE: TStringField;
        MemD_CSVSSG_REF: TStringField;
        MemD_CSVSSGROUPE: TStringField;
        MemD_NK_TXT: TdxMemData;
        MemD_NK_TXTUNI_NOM: TStringField;
    MemD_NK_TXTCATEGORIE: TStringField;
        MemD_NK_TXTSEC_REF: TStringField;
        MemD_NK_TXTRAYON: TStringField;
        MemD_NK_TXTRAY_REF: TStringField;
        MemD_NK_TXTFAMILLE: TStringField;
        MemD_NK_TXTFAM_REF: TStringField;
        MemD_NK_TXTSOUS_FAMILLE: TStringField;
        MemD_NK_TXTSSF_REF: TStringField;
        MemD_UnivTXT: TdxMemData;
        MemD_UnivTXTREF: TStringField;
        MemD_UnivTXTNOM: TStringField;
        MemD_UnivTXTNIVEAU: TStringField;
        MemD_UnivTXTORIGINE: TStringField;
        Splash_: TSplashMessage;
        MemD_CSVTEST: TStringField;
    MemD_NK_TXTFAM_N: TStringField;
    MemD_NK_TXTSSF_N: TStringField;
    MemD_NK_TXTSECTEUR: TStringField;
    MemD_NK_TXTCAT_REF: TStringField;
        PROCEDURE DataModuleDestroy(Sender: TObject);
    PRIVATE
    { Déclarations privées }
    PUBLIC
    { Déclarations publiques }
        FUNCTION TransformeCSV(Fich: STRING): Boolean;
        FUNCTION CSVtoTXT(Chemin: STRING): Boolean;

    END;

RESOURCESTRING
    UnivTXT = 'Le fichier Univ_FEDAS.txt est créé !';

VAR
    Dm_PrepaImportFEDAS: TDm_PrepaImportFEDAS;

IMPLEMENTATION
USES
    GinkoiaStd;

//   ConstStd;    // Si pas Ginkoia
{$R *.DFM}

PROCEDURE TDm_PrepaImportFEDAS.DataModuleDestroy(Sender: TObject);
BEGIN
    Grd_Close.Close;
END;

FUNCTION TDm_PrepaImportFEDAS.TransformeCSV(Fich: STRING): Boolean;
VAR Memo: TStringList;
    ch: STRING;
BEGIN
    ch := ExtractFilePath(Fich);
    Memo := TStringList.create;
    TRY
        TRY
            Memo.LoadFromFile(Fich);
            Memo.Strings[0] := 'CAT_REF;CATEGORIE;ACT_REF;ACTIVITE;GRP_REF;GROUPE;SSG_REF;SSGROUPE;;';
            Memo.SaveToFile(ch + 'FEDAS_TEMP.csv');
        EXCEPT
            Memo.Free;
            //Result := False;
        END;
    FINALLY
        Memo.Free;
        Result := True;
    END;
END;

FUNCTION TDm_PrepaImportFEDAS.CSVtoTXT(Chemin: STRING): Boolean;
var RefACT, RefGRP : String;
BEGIN
    //Result := False;
     // Création de Univ_FEDAS.txt
    MemD_UnivTXT.Close;
    MemD_UnivTXT.DelimiterChar := ';';
    MemD_UnivTXT.Open;
    MemD_UnivTXT.Insert;
    MemD_UnivTXTREF.AsString := '0';
    MemD_UnivTXTNOM.AsString := 'FEDAS 2';
    MemD_UnivTXTNIVEAU.AsString := '3';
    MemD_UnivTXTORIGINE.AsString := '1';
    MemD_UnivTXT.Post;
    MemD_UnivTXT.SaveToTextFile(Chemin + 'Univ_Fedas2.txt');

     // Création de NK_FEDAS.txt
    MemD_CSV.Close;
    MemD_CSV.DelimiterChar := ';';
    MemD_CSV.LoadFromTextFile(Chemin + 'FEDAS_TEMP.csv');

    MemD_NK_TXT.Close;
    MemD_NK_TXT.DelimiterChar := ';';
    MemD_NK_TXT.Open;
    Splash_.Gauge.Progress := 1;
    Splash_.Gauge.MaxValue := MemD_CSV.RecordCount;
    Splash_.Splash;

    MemD_CSV.First;
    WHILE NOT MemD_CSV.Eof DO
    BEGIN
        Splash_.Gauge.Progress := Splash_.Gauge.Progress + 1;
        MemD_NK_TXT.Insert;
        MemD_NK_TXTUNI_NOM.AsString := 'FEDAS 2';
        MemD_NK_TXTSECTEUR.AsString := 'FEDAS';
        MemD_NK_TXTCATEGORIE.AsString := MemD_CSV.FieldByName('CATEGORIE').asString;
        MemD_NK_TXTCAT_REF.AsString := IntToStr(MemD_CSVCAT_REF.AsInteger);
        MemD_NK_TXTRAYON.AsString := MemD_CSVACTIVITE.AsString;
        IF  (MemD_CSVACT_REF.AsInteger < 10) then
         RefACT := '0'+ IntToStr(MemD_CSVACT_REF.AsInteger)
        ELSE RefACT := MemD_CSVACT_REF.AsString;
        MemD_NK_TXTRAY_REF.AsString := RefACT; // au niveau du rayon on ne note pas la catégorie ==> Famille
        MemD_NK_TXTFAMILLE.AsString := MemD_CSVGROUPE.AsString;
        MemD_NK_TXTFAM_N.AsString := IntToStr(MemD_CSVGRP_REF.asInteger);
        IF  (MemD_CSVGRP_REF.AsInteger < 10) then
         RefGRP := '0'+ IntToStr(MemD_CSVGRP_REF.AsInteger)
        ELSE RefGRP := MemD_CSVGRP_REF.AsString;
        MemD_NK_TXTFAM_REF.AsString := IntToStr(MemD_CSVCAT_REF.AsInteger)+MemD_NK_TXTRAY_REF.AsString+ RefGRP;
        MemD_NK_TXTSOUS_FAMILLE.AsString := MemD_CSVSSGROUPE.AsString;
        MemD_NK_TXTSSF_N.AsString := IntToStr(MemD_CSVSSG_REF.AsInteger);
        MemD_NK_TXTSSF_REF.AsString := MemD_NK_TXTFAM_REF.AsString + MemD_CSVSSG_REF.AsString;
                                    //MemD_CSVFEDAS.AsString;
        MemD_NK_TXT.Post;
        MemD_CSV.Next;
    END;
    Splash_.Stop;
    MemD_NK_TXT.SortedField := 'SSF_REF';
    MemD_NK_TXT.SaveToTextFile(Chemin + 'NK_Fedas2.txt');
    MemD_NK_TXT.Close;
    MemD_CSV.Close;
    MemD_UnivTXT.Close;
    Result := True;
END;

END.

