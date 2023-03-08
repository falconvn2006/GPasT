//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------

unit Cst_Dm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ActionRv, Db, dxmdaset, MemDataImportRV, StrHlder, IBDataset, splashms,
  IB_Components, vgStndrt;

type
  TDm_Cst = class(TDataModule)
    Grd_Close: TGroupDataRv;
    Que_Rayon: TIBOQuery;
    Que_Famille: TIBOQuery;
    Que_SF: TIBOQuery;
    Que_Univ: TIBOQuery;
    Que_Tva: TIBOQuery;
    Que_TCT: TIBOQuery;
    Msp_Cpt: TSplashMessage;
    Que_Fourn: TIBOQuery;
    Que_Pays: TIBOQuery;
    Que_Adresse: TIBOQuery;
    Que_Ville: TIBOQuery;
    Que_Marque: TIBOQuery;
    Que_Article: TIBOQuery;
    Que_MrkFourn: TIBOQuery;
    Que_TarFourn: TIBOQuery;
    Que_FouPrin: TIBOQuery;
    Que_ArtRef: TIBOQuery;
    Que_PxVente: TIBOQuery;
    Que_FouDet: TIBOQuery;
    IbC_SCat: TIB_Cursor;
    IbC_Fourn: TIB_Cursor;
    IbC_Marque: TIB_Cursor;
    IbC_Famille: TIB_Cursor;
    IbC_SF: TIB_Cursor;
    IbC_Unitaire: TIB_Cursor;
    MemD_Rapport: TdxMemData;
    MemD_RapportRef: TStringField;
    MemD_RapportMarque: TStringField;
    MemD_RapportPA: TIntegerField;
    MemD_RapportRem: TIntegerField;
    MemD_RapportPVte: TIntegerField;
    MemD_Tarif: TdxMemData;
    MemD_TarifART: TStringField;
    MemD_TarifPX: TStringField;
    MemD_TarifMTR1: TStringField;
    MemD_TarifMTR2: TStringField;
    MemD_TarifMTR3: TStringField;
    Str_Ray: TStrHolder;
    Str_IdRay: TStrHolder;
    Que_MrkFournFMK_ID: TIntegerField;
    Que_MrkFournFMK_FOUID: TIntegerField;
    Que_MrkFournFMK_MRKID: TIntegerField;
    Que_MrkFournFMK_PRIN: TIntegerField;
    Que_MarqueMRK_ID: TIntegerField;
    Que_MarqueMRK_IDREF: TIntegerField;
    Que_MarqueMRK_NOM: TStringField;
    Que_MarqueMRK_CONDITION: TMemoField;
    Que_MarqueMRK_CODE: TStringField;
    Que_FournFOU_ID: TIntegerField;
    Que_FournFOU_IDREF: TIntegerField;
    Que_FournFOU_NOM: TStringField;
    Que_FournFOU_ADRID: TIntegerField;
    Que_FournFOU_TEL: TStringField;
    Que_FournFOU_FAX: TStringField;
    Que_FournFOU_EMAIL: TStringField;
    Que_FournFOU_REMISE: TIBOFloatField;
    Que_FournFOU_GROS: TIntegerField;
    Que_FournFOU_CDTCDE: TStringField;
    Que_FournFOU_CODE: TStringField;
    Que_FournFOU_TEXTCDE: TMemoField;
    Que_RayonRAY_ID: TIntegerField;
    Que_RayonRAY_UNIID: TIntegerField;
    Que_RayonRAY_IDREF: TIntegerField;
    Que_RayonRAY_NOM: TStringField;
    Que_RayonRAY_ORDREAFF: TIBOFloatField;
    Que_RayonRAY_VISIBLE: TIntegerField;
    Que_RayonRAY_SECID: TIntegerField;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure Que_RayonAfterPost(DataSet: TDataSet);
    procedure Que_RayonNewRecord(DataSet: TDataSet);
    procedure Que_RayonUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
    procedure Que_FamilleAfterPost(DataSet: TDataSet);
    procedure Que_FamilleNewRecord(DataSet: TDataSet);
    procedure Que_FamilleUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
    procedure Que_SFAfterPost(DataSet: TDataSet);
    procedure Que_SFNewRecord(DataSet: TDataSet);
    procedure Que_SFUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
    procedure Que_FournAfterPost(DataSet: TDataSet);
    procedure Que_FournNewRecord(DataSet: TDataSet);
    procedure Que_FournUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
    procedure Que_PaysAfterPost(DataSet: TDataSet);
    procedure Que_PaysNewRecord(DataSet: TDataSet);
    procedure Que_PaysUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
    procedure Que_AdresseAfterPost(DataSet: TDataSet);
    procedure Que_AdresseNewRecord(DataSet: TDataSet);
    procedure Que_AdresseUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
    procedure Que_VilleAfterPost(DataSet: TDataSet);
    procedure Que_VilleNewRecord(DataSet: TDataSet);
    procedure Que_VilleUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
    procedure Que_MarqueAfterPost(DataSet: TDataSet);
    procedure Que_MarqueNewRecord(DataSet: TDataSet);
    procedure Que_MarqueUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
    procedure Que_ArticleAfterPost(DataSet: TDataSet);
    procedure Que_ArticleNewRecord(DataSet: TDataSet);
    procedure Que_ArticleUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
    procedure Que_MrkFournAfterPost(DataSet: TDataSet);
    procedure Que_MrkFournNewRecord(DataSet: TDataSet);
    procedure Que_MrkFournUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
    procedure Que_TarFournAfterPost(DataSet: TDataSet);
    procedure Que_TarFournNewRecord(DataSet: TDataSet);
    procedure Que_TarFournUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
    procedure Que_ArtRefAfterPost(DataSet: TDataSet);
    procedure Que_ArtRefNewRecord(DataSet: TDataSet);
    procedure Que_ArtRefUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
    procedure Que_PxVenteAfterPost(DataSet: TDataSet);
    procedure Que_PxVenteNewRecord(DataSet: TDataSet);
    procedure Que_PxVenteUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
    procedure Que_FouPrinAfterPost(DataSet: TDataSet);
    procedure Que_FouPrinNewRecord(DataSet: TDataSet);
    procedure Que_FouPrinUpdateRecord(DataSet: TDataSet;
      UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
    procedure Que_FouDetAfterPost(DataSet: TDataSet);
    procedure Que_FouDetNewRecord(DataSet: TDataSet);
    procedure Que_FouDetUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
    procedure Msp_CptCloseForm(Sender: TObject);
  private
    { Déclarations privées }

    MajNom, okTxt: boolean;
  public
    { Déclarations publiques }
    cheminCS: String;
    Function DoImport: boolean;
  end;

var
  Dm_Cst: TDm_Cst;

//------------------------------------------------------------------------------
// Ressources strings
//------------------------------------------------------------------------------
//ResourceString

implementation

uses Main_Frm, Main_Dm, GinkoiaStd, GinkoiaResStr, stdUtils,
//ConstStd,
  Rapport_Frm;

{$R *.DFM}

procedure TDm_Cst.DataModuleCreate(Sender: TObject);
var desig: String;
begin
    CheminCs := '';
    MajNom := False;
    OkTxt := False;
    WITH stdGinkoia DO
    BEGIN
        CheminCS := UpperCase ( iniCtrl.readString ( 'CSTATION', 'PATH', '' ) ) ;
        Desig := iniCtrl.readString ( 'CSTATION', 'DESIGNATION', '' );
        If Desig <> 'OK' Then
        Begin
           MajNom := True;
           iniCtrl.WriteString ( 'CSTATION', 'DESIGNATION', 'OK' );
        END;
    END;
    If CheminCS = '' Then
       showmessage('Chemin des txt d''import non trouvé ... ')
    Else
    begin
       OkTxt := True;
       CheminCS := FormateStr ( 'ASLASH' , CheminCS );
    End;
end;

Function TDm_Cst.DoImport: boolean;
var univ: Integer;
    u, rayFam, q, k, TctId, Tvaid, Cptc, ssf, artid, flag, Fou, Mrk, Prin, vil, Pays, leRay, adr, i: Integer;
    MaxRay, v, TxEuro : extended;
    frf, jevire : boolean;
    ssfNom, mrkNom, d3, m3, ch2, ch, catNom : string;
    FFF, FlagRef, erreur : Boolean;
    flagU : Integer;
    ts, tc, tsRay : Tstrings;
    xh,yh : Integer;
    xch : string;
    cch : string;
begin
TRY
  TS := TstringList.create;
  tc := TstringList.create;
  tsray := TstringList.create;

  Ts.Clear;
  TsRay.Clear;
  Str_ray.Clear;
  Str_IdRay.Clear;

  result := False;
  erreur := False;
  jevire := False;
  Flagref := False;
  FlagU := -1;
  Memd_Rapport.Close;
  Memd_Rapport.Open;

  Ibc_Unitaire.Open;
  If Not Ibc_Unitaire.Eof Then
     FlagU := Ibc_Unitaire.fieldByName('CAT_ID').asInteger;
  Ibc_Unitaire.Close;

  TxEuro := 6.55957;
  LeRay := 0; pays := 0; adr := 0; vil := 0; TvaId := 0; TctId := 0;
  Try
    Frm_Main.Chr_Tim.Reset;
    Frm_Main.chr_tim.Start;

    Que_Famille.Open;
    Que_Univ.Open;
    Que_Rayon.Open;

    TRY

         ts.clear;
         ts.LoadFromFile(CheminCs+'T_Famille.Txt');
         MaxRay := 0;

         If que_Univ.RecordCount = 1 Then
         Begin
              tsRay.clear;
              tsRay.LoadFromFile(CheminCs+'T_Nature.Txt');

              que_Rayon.First;
              WHILE NOT que_Rayon.eof DO
              BEGIN
                   IF que_RayonRay_ordreaff.asFloat > MaxRay THEN MaxRay := que_RayonRay_ordreaff.asFloat;
                   Que_Rayon.Next;
              END;
              que_Rayon.First;

              Que_Univ.First;
              Univ := que_Univ.FieldByName('Uni_Id').asInteger;

              FOR xh := 1 to tsRay.count -1 do
              BEGIN
                   tc.clear;
                   StrToTS ( TsRay[xh],';', tc ) ;
                   Str_Ray.strings.Add(tc[0]);

                   If Not que_Rayon.Locate('RAY_NOM', Tc[1] , [loCaseInsensitive] ) THEN
                   BEGIN
                       MaxRay := MaxRay + 1000;
                       que_Rayon.Insert;
                       que_Rayon.FieldByName('RAY_UNIID').asInteger := Univ;
                       que_Rayon.FieldByName('RAY_NOM').asString := Tc[1];
                       que_Rayon.FieldByName('RAY_IDREF').asInteger := 0;
                       que_Rayon.FieldByName('RAY_VISIBLE').asInteger := 1;
                       que_Rayon.FieldByName('RAY_SECID').asInteger := 0;
                       que_Rayon.FieldByName('RAY_ORDREAFF').asFloat := MaxRay;
                       str_IdRay.strings.Add(que_Rayon.FieldByName('RAY_ID').asstring);
                       que_Rayon.Post;
                   End
                   Else
                       str_IdRay.strings.Add(que_Rayon.FieldByName('RAY_ID').asstring);
              END;

              Msp_Cpt.Gauge.Progress := 0;
              Msp_Cpt.MessageText := 'Fichier des familles';
              Msp_Cpt.Gauge.MaxValue := ts.count;
              Msp_Cpt.Splash;

              FOR xh := 1 to ts.count -1 do
              BEGIN
                  tc.clear;
                  StrToTS ( Ts[xh],';', tc ) ;

                  RayFam := str_Ray.strings.IndexOF(tc[2]);
                  IF RayFam = -1 THEN RayFam := str_Ray.strings.IndexOF('BR');

                  k := StrToIntTry(tc[0]);
                  If not que_Famille.Locate('FAM_IDREF', k, []) Then
                  Begin
                       que_Famille.Insert;
                       que_Famille.FieldByName('FAM_IDREF').asInteger := k;
                       que_Famille.FieldByName('FAM_VISIBLE').asInteger := 1;
                       que_Famille.FieldByName('FAM_CTFID').asInteger := 0;
                       que_Famille.FieldByName('FAM_ORDREAFF').asFloat := que_Famille.FieldByName('FAM_IDREF').asfloat*1000;
                       que_Famille.FieldByName('FAM_NOM').asstring := tc[1];
                       IF RayFam = - 1 THEN
                          que_Famille.FieldByName('FAM_RAYID').asInteger := 0
                       ELSE
                          que_Famille.FieldByName('FAM_RAYID').asInteger := StrToInt(str_IdRay.strings[RayFam]);
                       que_Famille.Post;
                  End
                  Else BEGIN
                      FFF := False;
                      IF RayFam = -1 THEN FFF := True;
                      IF Uppercase(que_Famille.FieldByName('FAM_NOM').asstring) <> Uppercase(tc[1]) THEN FFF := True;
                      IF ( RayFam <> - 1 ) AND ( que_Famille.FieldByName('FAM_RAYID').asInteger <> StrToInt(str_IdRay.strings[RayFam])) THEN FFF := True;
                      IF FFF THEN
                      BEGIN
                          que_Famille.Edit;
                          que_Famille.FieldByName('FAM_NOM').asstring := tc[1];
                          IF RayFam = - 1 THEN
                              que_Famille.FieldByName('FAM_RAYID').asInteger := 0
                          ELSE
                              que_Famille.FieldByName('FAM_RAYID').asInteger := StrToInt(str_IdRay.strings[RayFam]);
                          que_Famille.Post;
                      END;
                  END;

                  Msp_Cpt.Gauge.Progress := Msp_Cpt.Gauge.Progress +1;
                  Application.ProcessMessages;
              End;
         End;
     EXCEPT
     End;

     msp_cpt.Stop;
     Que_Sf.Open;
     Que_TCT.Open;
     que_TVA.Open;
     TvaId := que_Tva.FieldByName('TVA_ID').asInteger;
     TctId := que_TCT.FieldByName('TCT_ID').asInteger;

     TRY
         ts.clear;
         ts.LoadFromFile(CheminCs+'T_Sous_Famille.Txt');

         Msp_Cpt.Gauge.Progress := 0;
         Msp_Cpt.MessageText := 'Fichier des sous-familles';
         Msp_Cpt.Gauge.MaxValue := Ts.Count;
         Msp_Cpt.Splash;

         FOR xh := 1 to ts.count -1 do
         BEGIN
              tc.clear;
              StrToTS ( Ts[xh],';', tc ) ;

              q := StrToIntTry(tc[0]);
              k := StrToIntTry(tc[1]);

              if que_famille.Locate('FAM_IDREF', q , [] ) Then
              begin
                  If not que_sf.Locate('SSF_FAMID, SSF_IDREF', varArrayOf ([
                       que_Famille.FieldByName('FAM_ID').asInteger, k ]) , []) Then
                  Begin

                       que_Sf.Insert;

                       que_Sf.FieldByName('SSF_IDREF').asInteger := k;
                       que_Sf.FieldByName('SSF_FAMID').asInteger :=
                              que_Famille.FieldByName('FAM_ID').Asinteger;

                       que_SF.FieldByName('SSF_VISIBLE').asInteger := 1;
                       que_SF.FieldByName('SSF_CATID').asInteger := 0;

                       que_SF.FieldByName('SSF_TVAID').asInteger := TvaId;
                       que_SF.FieldByName('SSF_TCTID').asInteger := Tctid;

                       que_SF.FieldByName('SSF_ORDREAFF').asFloat := que_Sf.FieldByName('SSF_IDREF').asFloat*1000;
                       que_Sf.FieldByName('SSF_NOM').asstring := tc[2];
                       que_Sf.Post;
                  End
                  Else BEGIN
                       IF Uppercase(que_Sf.FieldByName('SSF_NOM').asstring) <> Uppercase( tc[2] ) THEN
                       BEGIN
                          que_Sf.Edit;
                          que_Sf.FieldByName('SSF_NOM').asstring := tc[2];
                          que_SF.Post;
                       END;
                  END;
              End;

              Msp_Cpt.Gauge.Progress := Msp_Cpt.Gauge.Progress +1;
              Application.ProcessMessages;

         End;
     EXCEPT
     END;

     msp_cpt.Stop;
     grd_close.Close;

     Que_Fourn.Open;
     Que_FouDet.Open;
     Que_Adresse.Open;
     Que_Ville.Open;
     que_Pays.Open;

     TRY
         ts.clear;
         ts.LoadFromFile(CheminCs+'T_Fournisseur.Txt');

         Msp_Cpt.Gauge.Progress := 0;
         Msp_Cpt.MessageText := 'Fichier des Fournisseurs';
         Msp_Cpt.Gauge.MaxValue := Ts.Count;
         Msp_Cpt.Splash;

         If not que_Pays.Locate('PAY_NOM', 'FRANCE', [] ) Then
         begin
               que_Pays.Insert;
               que_Pays.FieldByName('PAY_NOM').asstring := 'FRANCE';
               que_Pays.Post;
               Pays := que_Pays.FieldByName('PAY_ID').asInteger;
         End
         else Pays := que_Pays.FieldByName('PAY_ID').asInteger;

         FOR xh := 1 to ts.count -1 do
         BEGIN
              tc.clear;
              StrToTS ( Ts[xh],';', tc ) ;

              If not que_Ville.Locate('VIL_NOM', TC[5], []) Then
              Begin
                   que_Ville.Insert;
                   que_Ville.FieldByName('VIL_NOM').asstring := Tc[5];
                   que_Ville.FieldByName('VIL_CP').asstring := TC[4];
                   que_Ville.FieldByName('VIL_PAYID').asinteger := Pays;
                   que_Ville.Post;
                   Vil := que_Ville.fieldByName('VIL_ID').asInteger;
              End
              Else vil := que_Ville.fieldByName('VIL_ID').asInteger;

              If not que_Fourn.Locate('FOU_CODE', TC[0] , [] ) Then
              Begin
                   que_Adresse.Insert;
                   que_Adresse.fieldByName('ADR_LIGNE').asString := TC[2];
                   IF Trim(TC[3]) <> '' Then
                           que_Adresse.fieldByName('ADR_LIGNE').asString :=
                           que_Adresse.fieldByName('ADR_LIGNE').asString + #13+#10+ Tc[3];
                   que_Adresse.fieldByName('ADR_VILID').asInteger := vil;
                   que_Adresse.Post;
                   Adr := que_Adresse.fieldByName('ADR_ID').asInteger;

                   que_Fourn.Insert;
                   que_Fourn.FieldByName('FOU_CODE').asstring := TC[0];
                   que_Fourn.FieldByName('FOU_NOM').asstring := TC[1];
                   if que_Fourn.FieldByName('FOU_NOM').asstring = '' THEN
                        que_Fourn.FieldByName('FOU_NOM').asstring :=  TC[0];

                   que_Fourn.FieldByName('FOU_IDREF').asInteger := 0;
                   que_Fourn.FieldByName('FOU_ADRID').asInteger := Adr;
                   que_Fourn.FieldByName('FOU_TEL').asString := TC[7];
                   que_Fourn.FieldByName('FOU_FAX').asString := TC[8];
                   que_Fourn.FieldByName('FOU_EMAIL').asString := '';
                   que_Fourn.FieldByName('FOU_REMISE').asFloat := 0;
                   que_Fourn.FieldByName('FOU_GROS').asInteger := 0;
                   que_Fourn.FieldByName('FOU_CDTCDE').asString := '';

                   que_Fourn.Post;

                   que_FouDet.Insert;
                   que_FouDet.FieldByName('FOD_FOUID').asInteger := que_Fourn.FieldByName('FOU_ID').asInteger;
                   que_FouDet.FieldByName('FOD_MAGID').asInteger := 0;
                   cch := '';
                   IF tc.Count >= 18 THEN
                   BEGIN
                       cch := 'Franco : Qté ' + Tc[11] + ' - Mt ' + Tc[12] + ' - Comm ' + Tc[13] + #13#10 +
                           'Sav1 ' + Tc[14] + #13#10 +
                           'Sav2 ' + Tc[15] + #13#10 +
                           'CP ' + Tc[16] + ' Ville ' + Tc[17];
                   END;

                   que_FouDet.FieldByName('FOD_NUMCLIENT').asString := '';
                   que_FouDet.FieldByName('FOD_COMENT').asString := cch;
                   que_FouDet.FieldByName('FOD_FTOID').asInteger := 0;
                   que_FouDet.FieldByName('FOD_MRGID').asInteger := 0;
                   que_FouDet.FieldByName('FOD_CPAID').asInteger := 0;
                   que_FouDet.FieldByName('FOD_ENCOURSA').asFloat := 0;
                   que_Foudet.Post;

              End;

              Msp_Cpt.Gauge.Progress := Msp_Cpt.Gauge.Progress +1;
              Application.ProcessMessages;

         End;
     EXCEPT
     End;

     msp_cpt.Stop;
     Que_Adresse.Close;
     Que_Ville.Close;
     que_Pays.Close;
     que_FouDet.Close;

     que_Marque.Open;

     TRY
         ts.clear;
         ts.LoadFromFile(CheminCs+'T_MARQUE.Txt');

         Msp_Cpt.Gauge.Progress := 0;
         Msp_Cpt.MessageText := 'Fichier des Marques';
         Msp_Cpt.Gauge.MaxValue := Ts.Count;
         Msp_Cpt.Splash;

         FOR xh := 1 to ts.count -1 do
         BEGIN
              tc.clear;
              StrToTS ( Ts[xh],';', tc ) ;

              If not que_Marque.Locate('MRK_CODE', TC[0], []) Then
              Begin
                       que_Marque.Insert;
                       que_Marque.FieldByName('MRK_NOM').asstring := TC[1];
                       que_Marque.FieldByName('MRK_CODE').asString := TC[0];

                       if que_Marque.FieldByName('MRK_NOM').asstring = '' then
                            que_Marque.FieldByName('MRK_NOM').asstring := TC[0];

                       que_Marque.FieldByName('MRK_IDREF').asInteger := 0;
                       que_Marque.FieldByName('MRK_CONDITION').asString := '';
                       que_Marque.Post;
              End;

              Msp_Cpt.Gauge.Progress := Msp_Cpt.Gauge.Progress +1;
              Application.ProcessMessages;

          End;
     EXCEPT
     End;

     msp_cpt.Stop;
     Grd_Close.Close;

     cptc := 0;

     TRY
         ts.clear;
         ts.LoadFromFile(CheminCs+'T_Tarification.Txt');

         Msp_Cpt.Gauge.Progress := 0;
         Msp_Cpt.MessageText := 'Tarification Phase 1';
         Msp_Cpt.Gauge.MaxValue := Ts.Count;
         Msp_Cpt.Splash;

         Memd_Tarif.close;
         Memd_Tarif.DelimiterChar := ';';
         Memd_Tarif.SortedField := 'ART';
         Memd_Tarif.Open;

         FOR xh := 1 to ts.count -1 do
         BEGIN
              tc.clear;
              StrToTS ( Ts[xh],';', tc ) ;
              Memd_Tarif.Append;
              Tc[16] := ReplaceStr ( TC[16], ',', '.', FALSE );
              Tc[21] := ReplaceStr ( TC[21], ',', '.', FALSE );
              Tc[26] := ReplaceStr ( TC[26], ',', '.', FALSE );
              Tc[31] := ReplaceStr ( TC[31], ',', '.', FALSE );

              Memd_TarifART.asString := TC[0];
              Memd_TarifPX.asString := Tc[16];
              memd_TarifMTR1.asstring  := TC[21];
              memd_TarifMTR2.asstring  := TC[26];
              memd_TarifMTR3.asstring  := TC[31];
              memd_Tarif.Post;
              Msp_Cpt.Gauge.Progress := Msp_Cpt.Gauge.Progress +1;
              Application.ProcessMessages;
         END;
         Memd_Tarif.SaveToTextFile(CheminCs+'Tarif.txt');
     EXCEPT
     END;


     IF memd_Tarif.active AND ( NOT memd_Tarif.IsEmpty ) THEN
     BEGIN

         TRY
             ts.clear;
             ts.LoadFromFile(CheminCs+'T_Référencement.Txt');

             Msp_Cpt.Gauge.Progress := 0;
             Msp_Cpt.MessageText := 'Fichier de Référencement';
             Msp_Cpt.Gauge.MaxValue := Ts.Count;
             Msp_Cpt.Splash;

             FOR xh := 1 to ts.count -1 do
             BEGIN

                  tc.clear;
                  StrToTS ( Ts[xh],';', tc ) ;

                  Ibc_Fourn.Close;
                  ibc_Marque.close;
                  ibc_Famille.close;
                  ibc_Sf.close;
                  ibc_SCat.Close;

                  que_Article.Close;
                  que_MrkFourn.Close;
                  que_TarFourn.Close;
                  que_ArtRef.Close;
                  que_PxVente.Close;

                  CatNom := '';
                  MrkNom := '';
                  ssfNom := '';
                  Flag := 0;
                  Fou := 0;
                  Mrk := 0;
                  Artid := 0;
                  ssf := 0;
                  FlagRef := False;

                  Ibc_Fourn.ParamByName('FOUCODE').asstring := TC[1];  //Code fournisseur
                  Ibc_Fourn.Open;
                  if Not Ibc_Fourn.Eof Then
                  begin
                       Flag := 1;
                       Fou := Ibc_Fourn.fieldByName('FOU_ID').asInteger;
                       Ibc_Marque.ParamByName('MRKCODE').asstring := TC[2]; // Code marque
                       Ibc_Marque.Open;
                       If Not Ibc_Marque.Eof Then
                       begin
                           Flag := Flag +2;
                           Mrk := Ibc_Marque.fieldByName('MRK_ID').asInteger;
                           mrkNom := Ibc_Marque.FieldByName('Mrk_Nom').asString;
                           Ibc_Famille.ParamByName('FAMIDREF').asInteger := StrToIntTry(TC[3]);//Code famille;
                           Ibc_Famille.Open;
                           If Not Ibc_Famille.Eof Then
                           Begin
                               Flag := Flag + 3;
                               Ibc_SF.ParamByName('FAMID').asInteger := Ibc_Famille.FieldByName('FAM_ID').asInteger;
                               Ibc_SF.ParamByName('SSFIDREF').asInteger := StrToIntTry(TC[4]);//Code sous_famille;
                               Ibc_Sf.Open;
                               if Not Ibc_SF.Eof Then
                               begin
                                    Flag := Flag + 5;
                                    Ssf := Ibc_Sf.FieldByName('SSF_ID').asInteger;
                                    ssfNom := Ibc_Sf.FieldByName('SSF_NOM').asString;
                                    Ibc_Scat.ParamByName('CATID').asInteger := Ibc_SF.FieldByName('SSF_CATID').asInteger;
                                    Ibc_SCat.Open;
                                    if Not Ibc_SCAT.Eof Then catNom := Ibc_SCAT.FieldByName('CAT_NOM').asstring;
                               End;
                          End;
                       End;
                  End;

                  If Flag = 11 Then
                  begin
                      // on ne peut importer des articles que si fourn, marque et Nk OK!

                      que_MrkFourn.Close;
                      que_MrkFourn.ParamByName('FOUID').asInteger := Fou;
                      que_MrkFourn.ParamByName('MRKID').asInteger := Mrk;
                      que_MrkFourn.Open;
                      que_MrkFourn.First;

                      If (que_MrkFourn.FieldByName('FMK_FOUID').asInteger <> Fou) OR
                         (que_MrkFourn.FieldByName('FMK_MRKID').asInteger <> Mrk) THEN
                      BEGIN
                            que_MrkFourn.Insert;
                            que_MrkFourn.FieldByName('FMK_FOUID').asInteger := Fou;
                            que_MrkFourn.FieldByName('FMK_MRKID').asInteger := Mrk;
                            que_MrkFourn.FieldByName('FMK_PRIN').asInteger := 0;
                            // boucle d'optimisation des fouprin en fin de traitement
                            que_MrkFourn.Post;
                      End;

                      { ATTENTION : je mets le code de référence dans code centrale
                      car j'assure ainsi l'unicité de la recherche car sinon si je
                      me contente de la zone référence j'ai le risque de doublons
                      entre deux fournisseurs !
                      }

                      Que_Article.ParamByName('CODE').asstring := TC[0];  // Code article;
                      Que_Article.Open;
                      FFF := False;

                      if Que_Article.Eof Then
                      Begin

                           Que_Article.Insert;
                           Que_Article.FieldByName('ART_MRKID').asInteger := Mrk;

                           if catNom = '' Then CatNom :=TC[0]; //Code article;
                           Que_Article.FieldByName('ART_NOM').asString := CatNom + ' ' + MrkNom; //TC[18] + ' [' + Tc[0] + ']';
                           Que_Article.FieldByName('ART_IDREF').asInteger := 0;
                           Que_Article.FieldByName('ART_ORIGINE').asInteger := 2;
                           Que_Article.FieldByName('ART_PUB').asInteger := 0;
                           Que_Article.FieldByName('ART_GTFID').asInteger := 0;
                           Que_Article.FieldByName('ART_SESSION').asString := '';
                           Que_Article.FieldByName('ART_GREID').asInteger := 0;
                           Que_Article.FieldByName('ART_THEME').asString := '';
                           Que_Article.FieldByName('ART_GAMME').asString := '';

                           Que_Article.FieldByName('ART_CODECENTRALE').asString := TC[0]; //Code article;
                           Que_Article.FieldByName('ART_TAILLES').asString := '';
                           Que_Article.FieldByName('ART_SUPPRIME').asInteger := 0;
                           Que_Article.FieldByName('ART_REFREMPLACE').asInteger := 0;
                           Que_Article.FieldByName('ART_GARID').asInteger := 0;
                           Que_Article.FieldByName('ART_CODEGS').asInteger := 0;
                           Que_Article.FieldByName('ART_COMENT1').asString := '';
                           Que_Article.FieldByName('ART_COMENT2').asString := '';
                           Que_Article.FieldByName('ART_COMENT3').asString := '';
                           Que_Article.FieldByName('ART_COMENT4').asString := '';
                           Que_Article.FieldByName('ART_COMENT5').asString := '';
                           // ffffffffff
                           Que_Article.FieldByName('ART_SSFID').asInteger := SSF;
                           Que_Article.FieldByName('ART_DESCRIPTION').asString := TC[14]+#13#10+'CB : ' +Tc[20];  //Commentaire;
                           Que_Article.FieldByName('ART_REFMRK').asString := tc[0];// Code article;
                           Que_Article.FieldByName('ART_POS').asString := tc[5]; //Lettre de positionnement;
                           Que_Article.FieldByName('ART_GAMPF').asString := tc[6];  //   Gamme_PF;
                           Que_Article.FieldByName('ART_POINT').asString := tc[7]; // Point Digit;
                           Que_Article.FieldByName('ART_GAMPRODUIT').asString := tc[8];// Gamme de produit;

                      End
                      ELSE Begin
                          FFF := False;
                          IF Que_Article.FieldByName('ART_SSFID').asInteger <> SSF THEN FFF := True;
                          IF Uppercase( Que_Article.FieldByName('ART_REFMRK').asString ) <> Uppercase ( tc[0]) THEN FFF := True;// Code article;
                          IF Uppercase( Que_Article.FieldByName('ART_POS').asString ) <> Uppercase( tc[5] ) THEN FFF := True; //Lettre de positionnement;
                          IF Uppercase ( Que_Article.FieldByName('ART_GAMPF').asString ) <> Uppercase ( tc[6] ) THEN FFF := True;  //   Gamme_PF;
                          IF Uppercase ( Que_Article.FieldByName('ART_POINT').asString ) <> Uppercase ( tc[7] ) THEN FFF := True; // Point Digit;
                          IF Uppercase ( Que_Article.FieldByName('ART_GAMPRODUIT').asString ) <> Uppercase (tc[8] ) THEN FFF := True;// Gamme de produit;

                          IF FFF THEN
                          BEGIN
                              Que_Article.Edit;

                              Que_Article.FieldByName('ART_SSFID').asInteger := SSF;
                              Que_Article.FieldByName('ART_DESCRIPTION').asString := TC[14]+#13#10+'CB : ' +Tc[20];  //Commentaire;
                              Que_Article.FieldByName('ART_REFMRK').asString := tc[0];// Code article;
                              Que_Article.FieldByName('ART_POS').asString := tc[5]; //Lettre de positionnement;
                              Que_Article.FieldByName('ART_GAMPF').asString := tc[6];  //   Gamme_PF;
                              Que_Article.FieldByName('ART_POINT').asString := tc[7]; // Point Digit;
                              Que_Article.FieldByName('ART_GAMPRODUIT').asString := tc[8];// Gamme de produit;
                          END;
                      END;

                      artid := Que_Article.FieldByName('ART_ID').asInteger;

                      que_ArtRef.ParamByName('ARTID').asInteger := Artid;
                      que_ArtRef.Open;

                      If que_ArtRef.Eof Then
                      begin
                           que_artRef.Insert;
                           que_artRef.FieldByName('ARF_ARTID').asInteger := artid;
                           que_artRef.FieldByName('ARF_TVAID').asInteger := Tvaid;
                           que_artRef.FieldByName('ARF_TCTID').asInteger := Tctid;
                           que_artRef.FieldByName('ARF_CATID').asInteger := 0;
                           que_artRef.FieldByName('ARF_ICLID1').asInteger := 0;
                           que_artRef.FieldByName('ARF_ICLID2').asInteger := 0;
                           que_artRef.FieldByName('ARF_ICLID3').asInteger := 0;
                           que_artRef.FieldByName('ARF_ICLID4').asInteger := 0;
                           que_artRef.FieldByName('ARF_ICLID5').asInteger := 0;
                           que_artRef.FieldByName('ARF_CHRONO').asString := '';
                           que_artRef.FieldByName('ARF_DIMENSION').asInteger := 0;
                           que_artRef.FieldByName('ARF_DEPRECIATION').asInteger := 0;
                           que_artRef.FieldByName('ARF_VIRTUEL').asInteger := 0;
                           que_artRef.FieldByName('ARF_SERVICE').asInteger := 0;
                           que_artRef.FieldByName('ARF_COEFT').asFloat := 0;
                           que_artRef.FieldByName('ARF_STOCKI').asFloat := 0;
                           que_artRef.FieldByName('ARF_VTFRAC').asInteger := 0;
                           que_artRef.FieldByName('ARF_CDNMT').asInteger := 0;
                           que_artRef.FieldByName('ARF_CDNMTQTE').asFloat := 0;
                           que_artRef.FieldByName('ARF_UNITE').asString := '';
                           que_artRef.FieldByName('ARF_CDNMTOBLI').asInteger := 0;
                           que_artRef.FieldByName('ARF_GUELT').asInteger := 0;
                           que_artRef.FieldByName('ARF_CPFA').asFloat := 1;
                           que_artRef.FieldByName('ARF_FIDELITE').asInteger := 0;
                           que_artRef.FieldByName('ARF_ARCHIVER').asInteger := 0;
                           que_artRef.FieldByName('ARF_FIDPOINT').asFloat := 0;
                           que_artRef.FieldByName('ARF_DEPTAUX').asFloat := 0;
                           que_artRef.FieldByName('ARF_DEPMOTIF').asString := '';
                           que_artRef.FieldByName('ARF_CGTID').asInteger := 0;
                           que_artRef.FieldByName('ARF_GLTMONTANT').asFloat := 0;
                           que_artRef.FieldByName('ARF_GLTPXV').asFloat := 0;
                           que_artRef.FieldByName('ARF_GLTMARGE').asFloat := 0;
                           que_artRef.FieldByName('ARF_MAGORG').asInteger := 0;
                           que_artRef.FieldByName('ARF_CATALOG').asInteger := 1;
                      END;

                      if catNom = '' Then CatNom := tc[0];  //Code article;
                      Flagref := que_artRef.FieldByName('ARF_CATALOG').asInteger = 0;
                      // article référencé

                      IF Trim(tc[15]) <> '' Then   //Date de Modification;
                      Begin
                           ch := Trim(Tc[15]);  //Date de Modification;
                           d3 := copy (ch,1,3);
                           m3 := copy (ch,4,3);
                           ch2 := m3+d3+copy(ch,7,30);
                           IF que_artRef.FieldByName('ARF_MODIF').asDateTime <> StrToDateTIME (ch) THEN
                           BEGIN
                              que_ArtRef.Edit;
                              que_artRef.FieldByName('ARF_MODIF').asDateTime := StrToDateTIME (ch);
                           END;
                      End;

                      If MajNom OR (que_artRef.FieldByName('ARF_CHRONO').asString = '') OR
                          ( Que_Article.FieldByName('ART_NOM').asString = TC[18] + ' [' + Tc[0] + ']') Then
                      Begin
                          // mise à jour du nom théoriquement la 1ère fois seulement
                          // mais peut être redéclenché en supprimant le "OK" de DESIGNATION dans l'INI
                          IF Not ( que_Article.State In [dsInsert, dsEdit] ) THEN que_Article.Edit;
                          Que_Article.FieldByName('ART_NOM').asString := CatNom + ' ' + MrkNom;
                      End;

                      IF que_Article.State IN [dsInsert,dsEdit] THEN Que_Article.Post;
                      IF que_ArtRef.State IN [dsInsert,dsEdit] THEN que_ArtRef.Post;

                      que_TarFourn.ParamByName('ARTID').asInteger := Artid;
                      que_TarFourn.ParamByName('FOUID').asInteger := Fou;
                      que_TarFourn.Open;

                      FFF := False;

                      If que_TarFourn.Eof Then
                      Begin
                           que_TarFourn.Insert;
                           que_TarFourn.FieldByName('CLG_ARTID').AsInteger := artid;
                           que_TarFourn.FieldByName('CLG_FOUID').AsInteger := Fou;
                           que_TarFourn.FieldByName('CLG_TGFID').AsInteger := 0;
                           que_TarFourn.FieldByName('CLG_PRINCIPAL').AsInteger := 1;
                           que_TarFourn.FieldByName('CLG_RA1').AsFloat := 0;
                           que_TarFourn.FieldByName('CLG_RA2').AsFloat := 0;
                           que_TarFourn.FieldByName('CLG_RA3').AsFloat := 0;
                           que_TarFourn.FieldByName('CLG_TAXE').AsFloat := 0;
                           que_TarFourn.FieldByName('CLG_PX').AsFloat := 0;
                           que_TarFourn.FieldByName('CLG_PXNEGO').AsFloat := 0;
                           que_TarFourn.FieldByName('CLG_PXVI').AsFloat := 0;
                           FFF := True;
                      END
                      Else que_TarFourn.Edit;

                      If FlagRef Then
                      Begin
                          MemD_Rapport.Insert;
                          MemD_RapportRef.asstring := tc[0];  //Code article;
                          MemD_RapportMarque.Asstring := mrkNom;
                          Memd_RapportPA.asInteger := 0;
                          Memd_RapportRem.AsInteger := 0;
                          MemD_RapportPvte.AsInteger := 0;
                      End;

                      Frf := False;
                      If Uppercase (tc[16]) = 'FF' THEN  // Monnaie;
                         Frf := True;


                      Tc[9] := ReplaceStr ( TC[9], ',', '.', FALSE );
                      V := strToFloatTry(Tc[9]); // Prix fournisseur;
                      If Frf and ( v <> 0 ) Then v := RoundRv(( v/TxEuro ),7);

                      If ( v <> 0 ) AND Flagref and
                         ( roundRv(v,2) <> roundRv(que_TarFourn.FieldByName('CLG_PX').AsFloat,2) ) THEN
                             MemD_RapportPA.asInteger := 1;

                      IF Not FFF THEN
                      BEGIN
                          IF que_TarFourn.FieldByName('CLG_PX').AsFloat <> v THEN FFF := True;
                          IF que_TarFourn.FieldByName('CLG_PXNEGO').AsFloat <> v THEN FFF := True;
                      END;

                      que_TarFourn.FieldByName('CLG_PX').AsFloat := v;
                      que_TarFourn.FieldByName('CLG_PXNEGO').AsFloat := v;

                      Tc[13] := ReplaceStr ( TC[13], ',', '.', FALSE );
                      V := StrToFloatTry(Tc[13]);    //PVGC
                      If Frf and ( v <> 0 ) Then v := RoundRv(( v/TxEuro ),7);

                      If Flagref and
                         ( roundRv(v,2) <> roundRv(que_TarFourn.FieldByName('CLG_PXVI').AsFloat,2) ) THEN
                             MemD_RapportPVte.asInteger := 1;

                      IF Not FFF THEN
                      BEGIN
                          IF que_TarFourn.FieldByName('CLG_PXVI').AsFloat <> v THEN FFF := true;
                      END;
                      que_TarFourn.FieldByName('CLG_PXVI').AsFloat := v;

                      If Memd_Tarif.Locate('Art', tc[0], [] ) Then
                      begin

                          ch := Memd_Tarif.FieldByName('PX').asstring;
                          v := StrToFloatTry( ch );
                          if v <> 0 Then
                          begin
                             If Frf Then v := RoundRv(( v/TxEuro ),7);
                             If Flagref and
                                 ( roundRv(v,2) <> roundRv(que_TarFourn.FieldByName('CLG_PXNEGO').AsFloat,2) ) THEN
                                     MemD_RapportPA.asInteger := 1;

                             IF Not FFF THEN
                             BEGIN
                                  IF que_TarFourn.FieldByName('CLG_PXNEGO').AsFloat <> v THEN FFF := True;
                             END;

                             que_TarFourn.FieldByName('CLG_PXNEGO').AsFloat := v;


                             // si le prix fournisseur est à 0 on lui met le px nego
                             IF que_TarFourn.FieldByName('CLG_PX').AsFloat = 0 THEN
                             BEGIN
                                  FFF := True;
                                  que_TarFourn.FieldByName('CLG_PX').AsFloat :=
                                       que_TarFourn.FieldByName('CLG_PXNEGO').AsFloat;
                             END;
                          end;

                          ch := Memd_Tarif.FieldByName('MTR1').asstring;
                          v := StrToFloatTry( ch );
                          if v <> 0 Then
                          begin
                             If Frf Then v := RoundRv(( v/TxEuro ),7);

                             If Flagref and
                                 ( roundRv(v,2) <> roundRv(que_TarFourn.FieldByName('CLG_RA1').AsFloat,2) ) THEN
                                     MemD_RapportRem.asInteger := 1;

                             IF Not FFF THEN
                             BEGIN
                                  IF que_TarFourn.FieldByName('CLG_RA1').AsFloat <> v THEN FFF := True;
                             END;
                             que_TarFourn.FieldByName('CLG_RA1').AsFloat := v;
                          end;

                          ch := Memd_Tarif.FieldByName('MTR2').asstring;
                          v := StrToFloatTry( ch );
                          if v <> 0 Then
                          begin
                             If Frf Then v := RoundRv(( v/TxEuro ),7);

                             If Flagref and
                                 ( roundRv(v,2) <> roundRv(que_TarFourn.FieldByName('CLG_RA2').AsFloat,2) ) THEN
                                     MemD_RapportRem.asInteger := 1;

                             IF NOT FFF THEN
                             BEGIN
                                  IF que_TarFourn.FieldByName('CLG_RA2').AsFloat <> v THEN FFF := True;
                             END;
                             que_TarFourn.FieldByName('CLG_RA2').AsFloat := v;
                          end;

                          ch := Memd_Tarif.FieldByName('MTR3').asstring;
                          v := StrToFloatTry( ch );
                          if v <> 0 Then
                          begin
                             If Frf Then v := RoundRv(( v/TxEuro ),7);
                             If Flagref and
                                 ( roundRv(v,2) <> roundRv(que_TarFourn.FieldByName('CLG_RA3').AsFloat,2) ) THEN
                                     MemD_RapportRem.asInteger := 1;

                             IF NOT FFF THEN
                             BEGIN
                                  IF que_TarFourn.FieldByName('CLG_RA3').AsFloat <> v THEN FFF := True;
                             END;
                             que_TarFourn.FieldByName('CLG_RA3').AsFloat := v;
                          end;

                          ch := Memd_Tarif.FieldByName('PX').asstring;
                          v := StrToFloatTry( ch );

                          if que_TarFourn.FieldByName('CLG_PX').AsFloat = 0 Then
                          BEGIN
                                FFF := True;
                                que_TarFourn.FieldByName('CLG_PX').AsFloat := v;
                          END;
                          if que_TarFourn.FieldByName('CLG_PXNEGO').AsFloat = 0 Then
                          BEGIN
                                FFF := True;
                                que_TarFourn.FieldByName('CLG_PXNEGO').AsFloat := v;
                          END;

                         { la taxe reste à 0 sur la demande de M.Sneoual

                          Pnet := strToFloatTry(Memd_Tarif.FieldByName('Prix_Net').asString);
                          // c'est le prix net Comstation

                          Taxe := Pnet-(Pneg+ra1+ra2+ra3);
                          if ( Taxe > 0 ) and (Taxe < Pnet) Then
                          begin
                             If Frf Then
                             Begin

                             Taxe := RoundRv(( taxe/TxEuro ),7);
                             que_TarFourn.FieldByName('CLG_TAXE').AsFloat := Taxe;
                          end;
                          }
                      end
                      Else BEGIN
                          IF que_TarFourn.FieldByName('CLG_RA1').AsFloat <> 0 THEN FFF := True;
                          IF que_TarFourn.FieldByName('CLG_RA2').AsFloat <> 0 THEN FFF := True;
                          IF que_TarFourn.FieldByName('CLG_RA3').AsFloat <> 0 THEN FFF := True;

                          que_TarFourn.FieldByName('CLG_RA1').AsFloat := 0;
                          que_TarFourn.FieldByName('CLG_RA2').AsFloat := 0;
                          que_TarFourn.FieldByName('CLG_RA3').AsFloat := 0;
                          que_TarFourn.FieldByName('CLG_TAXE').AsFloat := 0;

                          If Flagref and
                              (( que_TarFourn.FieldByName('CLG_RA1').AsFloat <> 0 ) OR
                              ( que_TarFourn.FieldByName('CLG_RA2').AsFloat <> 0 ) OR
                              ( que_TarFourn.FieldByName('CLG_RA3').AsFloat <> 0 )) THEN
                                     MemD_RapportRem.asInteger := 1;

                      END;


                      If Flagref THEN
                      BEGIN
                           if (Memd_RapportPA.asinteger = 1 ) OR (Memd_RapportPVte.asinteger = 1 ) OR
                              (Memd_RapportRem.asinteger = 1 ) THEN
                              Memd_Rapport.Post
                           Else
                              Memd_rapport.Cancel;
                      END;

                      if flagref and (que_ArtRef.fieldByName('ARF_CATID').asInteger = FlagU) THEN
                         // demande de SNeoual sur les articles de cat "UNITAIRE', ne pas toucher au tarif
                         que_TarFourn.Cancel
                      Else BEGIN
                         IF FFF THEN   // car nouveau ou modif
                            que_TarFourn.Post
                         ELSE
                            que_TarFourn.Cancel;
                      END;

                      que_PxVente.ParamByName('ARTID').asInteger := Artid;
                      Que_PxVente.Open;

                      If que_PxVente.Eof Then
                      Begin
                             que_PxVente.Insert;
                             que_PxVente.FieldByName('PVT_TVTID').asInteger := 0;
                             que_PxVente.FieldByName('PVT_TGFID').asInteger := 0;
                             que_PxVente.FieldByName('PVT_ARTID').asInteger := artid;
                             que_PxVente.FieldByName('PVT_PX').asfloat := que_TarFourn.FieldByName('CLG_PXVI').AsFloat;
                             que_PxVente.Post;
                      End
                      Else Begin
                          if Not FlagRef Then
                          begin
                             // si article référencé ne modifie pas le prix de vente
                             IF que_PxVente.FieldByName('PVT_PX').asfloat <> que_TarFourn.FieldByName('CLG_PXVI').AsFloat THEN
                             BEGIN
                                 que_PxVente.Edit;
                                 que_PxVente.FieldByName('PVT_PX').asfloat := que_TarFourn.FieldByName('CLG_PXVI').AsFloat;
                                 que_PxVente.Post;
                             END;
                          End;
                      End;
                  End;

                  Msp_Cpt.Gauge.Progress := Msp_Cpt.Gauge.Progress +1;
                  Application.ProcessMessages;

                  if frm_main.Kit Then
                     if MessageDlg('Confirmez que vous voulez interrompre le traitement...', mtConfirmation, [mbYes, mbNo], 0) = mrYes Then
                     begin
                         Jevire := True;
                         break;
                     End;

             End;
         EXCEPT
         End;
    End;

    Msp_Cpt.Stop;
    Grd_close.Close;

    que_Marque.Open;
    que_FouPrin.Open;

    Msp_Cpt.Gauge.Progress := 0;
    Msp_Cpt.MessageText := 'Fournisseurs principaux';
    Msp_Cpt.Gauge.MaxValue := que_Marque.RecordCount;
    Msp_Cpt.Splash;

    que_Marque.First;
    While not que_Marque.Eof do
    begin
          que_FouPrin.Close;
          que_FouPrin.ParamByName('MRKID').asInteger := que_Marque.fieldByName('Mrk_id').asInteger;
          que_FouPrin.Open;
          if que_FouPrin.RecordCount = 1 Then
          begin
               que_Fouprin.Edit;
               que_FouPrin.FieldByName('FMK_PRIN').asInteger := 1;
               que_FouPrin.Post;
          End;
          que_Marque.Next;
          Msp_Cpt.Gauge.Progress := Msp_Cpt.Gauge.Progress +1;
          Application.ProcessMessages;

    End;

    msp_cpt.stop;
    Grd_close.Close;
    memd_Tarif.close;

    Frm_Main.chr_tim.Stop;
    Result := Not Jevire;

    If Not Memd_Rapport.IsEmpty THEN
    BEGIN
         Result := False; // supprime le message de fin inutile si rapport
         RapExecute;
    END;

  Except
     memd_Rapport.Close;
     msp_cpt.stop;
     memd_Tarif.close;
     grd_close.Close;
     Frm_Main.chr_tim.Stop;
     MessageDlg('Erreur durant la mise à jour du catalogue... ', mtError, [mbOK], 0);
     //raise;
  End;
FINALLY
  Ts.Free;
  tc.Free;
  tsRay.Free;
END;

end;


procedure TDm_Cst.DataModuleDestroy(Sender: TObject);
begin
  Grd_Close.Close;
end;

procedure TDm_Cst.Que_RayonAfterPost(DataSet: TDataSet);
begin
  Dm_Main.IBOUpDateCache ( DataSet As TIBOQuery) ;
end;

procedure TDm_Cst.Que_RayonNewRecord(DataSet: TDataSet);
begin
  if not Dm_Main.IBOMajPkKey ( ( DataSet As TIBODataSet),
  ( DataSet As TIBODataSet).KeyLinks.IndexNames[0] ) then Abort;
end;

procedure TDm_Cst.Que_RayonUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
  Dm_Main.IBOUpdateRecord ( ( DataSet As TIBODataSet).KeyRelation,
                          ( DataSet As TIBODataSet),UpdateKind, UpdateAction );
end;

procedure TDm_Cst.Que_FamilleAfterPost(DataSet: TDataSet);
begin
  Dm_Main.IBOUpDateCache ( DataSet As TIBOQuery) ;
end;

procedure TDm_Cst.Que_FamilleNewRecord(DataSet: TDataSet);
begin
  if not Dm_Main.IBOMajPkKey ( ( DataSet As TIBODataSet),
  ( DataSet As TIBODataSet).KeyLinks.IndexNames[0] ) then Abort;
end;

procedure TDm_Cst.Que_FamilleUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
  Dm_Main.IBOUpdateRecord ( ( DataSet As TIBODataSet).KeyRelation,
                          ( DataSet As TIBODataSet),UpdateKind, UpdateAction );
end;

procedure TDm_Cst.Que_SFAfterPost(DataSet: TDataSet);
begin
  Dm_Main.IBOUpDateCache ( DataSet As TIBOQuery) ;
end;

procedure TDm_Cst.Que_SFNewRecord(DataSet: TDataSet);
begin
  if not Dm_Main.IBOMajPkKey ( ( DataSet As TIBODataSet),
  ( DataSet As TIBODataSet).KeyLinks.IndexNames[0] ) then Abort;
end;

procedure TDm_Cst.Que_SFUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
  Dm_Main.IBOUpdateRecord ( ( DataSet As TIBODataSet).KeyRelation,
                          ( DataSet As TIBODataSet),UpdateKind, UpdateAction );
end;

procedure TDm_Cst.Que_FournAfterPost(DataSet: TDataSet);
begin
  Dm_Main.IBOUpDateCache ( DataSet As TIBOQuery) ;
end;


procedure TDm_Cst.Que_FournNewRecord(DataSet: TDataSet);
begin
  if not Dm_Main.IBOMajPkKey ( ( DataSet As TIBODataSet),
  ( DataSet As TIBODataSet).KeyLinks.IndexNames[0] ) then Abort;
end;

procedure TDm_Cst.Que_FournUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
  Dm_Main.IBOUpdateRecord ( ( DataSet As TIBODataSet).KeyRelation,
                          ( DataSet As TIBODataSet),UpdateKind, UpdateAction );
end;

procedure TDm_Cst.Que_PaysAfterPost(DataSet: TDataSet);
begin
  Dm_Main.IBOUpDateCache ( DataSet As TIBOQuery) ;
end;


procedure TDm_Cst.Que_PaysNewRecord(DataSet: TDataSet);
begin
  if not Dm_Main.IBOMajPkKey ( ( DataSet As TIBODataSet),
  ( DataSet As TIBODataSet).KeyLinks.IndexNames[0] ) then Abort;
end;

procedure TDm_Cst.Que_PaysUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
  Dm_Main.IBOUpdateRecord ( ( DataSet As TIBODataSet).KeyRelation,
                          ( DataSet As TIBODataSet),UpdateKind, UpdateAction );
end;

procedure TDm_Cst.Que_AdresseAfterPost(DataSet: TDataSet);
begin
  Dm_Main.IBOUpDateCache ( DataSet As TIBOQuery) ;
end;

procedure TDm_Cst.Que_AdresseNewRecord(DataSet: TDataSet);
begin
  if not Dm_Main.IBOMajPkKey ( ( DataSet As TIBODataSet),
  ( DataSet As TIBODataSet).KeyLinks.IndexNames[0] ) then Abort;
end;

procedure TDm_Cst.Que_AdresseUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
  Dm_Main.IBOUpdateRecord ( ( DataSet As TIBODataSet).KeyRelation,
                          ( DataSet As TIBODataSet),UpdateKind, UpdateAction );
end;

procedure TDm_Cst.Que_VilleAfterPost(DataSet: TDataSet);
begin
  Dm_Main.IBOUpDateCache ( DataSet As TIBOQuery) ;
end;


procedure TDm_Cst.Que_VilleNewRecord(DataSet: TDataSet);
begin
  if not Dm_Main.IBOMajPkKey ( ( DataSet As TIBODataSet),
  ( DataSet As TIBODataSet).KeyLinks.IndexNames[0] ) then Abort;
end;

procedure TDm_Cst.Que_VilleUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
  Dm_Main.IBOUpdateRecord ( ( DataSet As TIBODataSet).KeyRelation,
                          ( DataSet As TIBODataSet),UpdateKind, UpdateAction );
end;


procedure TDm_Cst.Que_MarqueAfterPost(DataSet: TDataSet);
begin
  Dm_Main.IBOUpDateCache ( DataSet As TIBOQuery) ;
end;


procedure TDm_Cst.Que_MarqueNewRecord(DataSet: TDataSet);
begin
  if not Dm_Main.IBOMajPkKey ( ( DataSet As TIBODataSet),
  ( DataSet As TIBODataSet).KeyLinks.IndexNames[0] ) then Abort;
end;

procedure TDm_Cst.Que_MarqueUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
  Dm_Main.IBOUpdateRecord ( ( DataSet As TIBODataSet).KeyRelation,
                          ( DataSet As TIBODataSet),UpdateKind, UpdateAction );
end;

procedure TDm_Cst.Que_ArticleAfterPost(DataSet: TDataSet);
begin
  Dm_Main.IBOUpDateCache ( DataSet As TIBOQuery) ;
end;

procedure TDm_Cst.Que_ArticleNewRecord(DataSet: TDataSet);
begin
  if not Dm_Main.IBOMajPkKey ( ( DataSet As TIBODataSet),
  ( DataSet As TIBODataSet).KeyLinks.IndexNames[0] ) then Abort;
end;

procedure TDm_Cst.Que_ArticleUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
  Dm_Main.IBOUpdateRecord ( ( DataSet As TIBODataSet).KeyRelation,
                          ( DataSet As TIBODataSet),UpdateKind, UpdateAction );
end;

procedure TDm_Cst.Que_MrkFournAfterPost(DataSet: TDataSet);
begin
  Dm_Main.IBOUpDateCache ( DataSet As TIBOQuery) ;
end;

procedure TDm_Cst.Que_MrkFournNewRecord(DataSet: TDataSet);
begin
  if not Dm_Main.IBOMajPkKey ( ( DataSet As TIBODataSet),
  ( DataSet As TIBODataSet).KeyLinks.IndexNames[0] ) then Abort;
end;

procedure TDm_Cst.Que_MrkFournUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
  Dm_Main.IBOUpdateRecord ( ( DataSet As TIBODataSet).KeyRelation,
                          ( DataSet As TIBODataSet),UpdateKind, UpdateAction );
end;

procedure TDm_Cst.Que_TarFournAfterPost(DataSet: TDataSet);
begin
  Dm_Main.IBOUpDateCache ( DataSet As TIBOQuery) ;
end;

procedure TDm_Cst.Que_TarFournNewRecord(DataSet: TDataSet);
begin
  if not Dm_Main.IBOMajPkKey ( ( DataSet As TIBODataSet),
  ( DataSet As TIBODataSet).KeyLinks.IndexNames[0] ) then Abort;
end;

procedure TDm_Cst.Que_TarFournUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
  Dm_Main.IBOUpdateRecord ( ( DataSet As TIBODataSet).KeyRelation,
                          ( DataSet As TIBODataSet),UpdateKind, UpdateAction );
end;

procedure TDm_Cst.Que_ArtRefAfterPost(DataSet: TDataSet);
begin
  Dm_Main.IBOUpDateCache ( DataSet As TIBOQuery) ;
end;

procedure TDm_Cst.Que_ArtRefNewRecord(DataSet: TDataSet);
begin
  if not Dm_Main.IBOMajPkKey ( ( DataSet As TIBODataSet),
  ( DataSet As TIBODataSet).KeyLinks.IndexNames[0] ) then Abort;
end;

procedure TDm_Cst.Que_ArtRefUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
  Dm_Main.IBOUpdateRecord ( ( DataSet As TIBODataSet).KeyRelation,
                          ( DataSet As TIBODataSet),UpdateKind, UpdateAction );
end;

procedure TDm_Cst.Que_PxVenteAfterPost(DataSet: TDataSet);
begin
  Dm_Main.IBOUpDateCache ( DataSet As TIBOQuery) ;
end;

procedure TDm_Cst.Que_PxVenteNewRecord(DataSet: TDataSet);
begin
  if not Dm_Main.IBOMajPkKey ( ( DataSet As TIBODataSet),
  ( DataSet As TIBODataSet).KeyLinks.IndexNames[0] ) then Abort;
end;

procedure TDm_Cst.Que_PxVenteUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
  Dm_Main.IBOUpdateRecord ( ( DataSet As TIBODataSet).KeyRelation,
                          ( DataSet As TIBODataSet),UpdateKind, UpdateAction );
end;

procedure TDm_Cst.Que_FouPrinAfterPost(DataSet: TDataSet);
begin
  Dm_Main.IBOUpDateCache ( DataSet As TIBOQuery) ;
end;

procedure TDm_Cst.Que_FouPrinNewRecord(DataSet: TDataSet);
begin
  if not Dm_Main.IBOMajPkKey ( ( DataSet As TIBODataSet),
  ( DataSet As TIBODataSet).KeyLinks.IndexNames[0] ) then Abort;
end;

procedure TDm_Cst.Que_FouPrinUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
  Dm_Main.IBOUpdateRecord ( ( DataSet As TIBODataSet).KeyRelation,
                          ( DataSet As TIBODataSet),UpdateKind, UpdateAction );

end;

procedure TDm_Cst.Que_FouDetAfterPost(DataSet: TDataSet);
begin
  Dm_Main.IBOUpDateCache ( DataSet As TIBOQuery) ;
end;

procedure TDm_Cst.Que_FouDetNewRecord(DataSet: TDataSet);
begin
  if not Dm_Main.IBOMajPkKey ( ( DataSet As TIBODataSet),
  ( DataSet As TIBODataSet).KeyLinks.IndexNames[0] ) then Abort;
end;

procedure TDm_Cst.Que_FouDetUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
  Dm_Main.IBOUpdateRecord ( ( DataSet As TIBODataSet).KeyRelation,
                          ( DataSet As TIBODataSet),UpdateKind, UpdateAction );
end;

procedure TDm_Cst.Msp_CptCloseForm(Sender: TObject);
begin
     if Msp_Cpt.Canceled Then frm_Main.KeyKit := True;
end;

end.
