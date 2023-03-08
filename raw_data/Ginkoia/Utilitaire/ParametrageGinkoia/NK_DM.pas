//$Log:
// 10   Utilitaires1.9         29/04/2010 15:06:35    Loic G         
//      Traitement du rayon Multisport de la nomenclature FEDAS
// 9    Utilitaires1.8         24/02/2010 09:41:07    Lionel ABRY     migration
// 8    Utilitaires1.7         20/06/2007 12:18:32    pascal          Probleme
//      d'importation famille// ssfamille dans la fedas
// 7    Utilitaires1.6         07/06/2007 09:52:40    pascal         
//      Correction de l'indentation des famille et sous famille dans
//      l'importation
// 6    Utilitaires1.5         28/07/2006 12:13:56    Sandrine MEDEIROS PB sur
//      IDREF=-1
// 5    Utilitaires1.4         06/01/2006 17:25:17    Sandrine MEDEIROS
//      Int?gration NK FEDAS sport2000
// 4    Utilitaires1.3         12/10/2005 17:28:12    Sandrine MEDEIROS
//      Modification de l'int?gration de la NK
// 3    Utilitaires1.2         11/10/2005 14:50:55    Sandrine MEDEIROS
//      correction bug : int?gration de NK sans IDREF
// 2    Utilitaires1.1         07/06/2005 15:18:30    Sandrine MEDEIROS
//      Int?gartion du NK dans une base existante. Les anciens Rayons sont
//      renom?s avec "[*]" afin de pouvoir visualiser anciens rayons / rayons
//      int?gr?s
// 1    Utilitaires1.0         27/04/2005 10:41:01    pascal          
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

unit NK_DM;

interface

uses
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
   splashms,
   BmDelay,
   IB_Components,
   IB_StoredProc, IBODataset,
   variants;

type
   TDm_NK = class(TDataModule)
      Grd_Que: TGroupDataRv;
      MemD_NK: TdxMemData;
      MemD_NKRayon: TStringField;
      MemD_NKRAY_REF: TStringField;
      MemD_NKFAMILLE: TStringField;
      MemD_NKFAM_REF: TStringField;
      MemD_NKSOUS_FAMILLE: TStringField;
      MemD_NKREF_SSF: TStringField;
      Que_Rayon: TIBOQuery;
      Que_Famille: TIBOQuery;
      Que_SSFamille: TIBOQuery;
      Que_Univers: TIBOQuery;
      MemD_Univers: TdxMemData;
      MemD_UniversRef: TStringField;
      MemD_UniversNOM: TStringField;
      MemD_UniversNIVEAU: TStringField;
      MemD_UniversORIGINE: TStringField;
      Splash_: TSplashMessage;
      Que_SSFGTS: TIBOQuery;
      Que_TypeGT: TIBOQuery;
      MemD_TypeGT: TdxMemData;
      MemD_TypeGTTGT_NOM: TStringField;
      Que_GTF: TIBOQuery;
      Que_TGF: TIBOQuery;
      MemD_GTF: TdxMemData;
      MemD_GTFTGT_NOM: TStringField;
      MemD_GTFGTF_NOM: TStringField;
      MemD_GTFGTF_IDREF: TStringField;
      MemD_GTFTGF_NOM: TStringField;
      MemD_GTFTGFIDREF: TStringField;
      MemD_GTFTGF_CORRES: TStringField;
      MemD_GTFTGF_STAT: TStringField;
      Que_GTS: TIBOQuery;
      Que_TGS: TIBOQuery;
      Que_ITS: TIBOQuery;
      MemD_GTS: TdxMemData;
      MemD_GTSTGT_NOM: TStringField;
      MemD_GTSGTS_NOM: TStringField;
      MemD_GTSTGS_NOM: TStringField;
      MemD_GTSTGS_INDICE: TStringField;
      MemD_GTSITS_INDICE: TStringField;
      IbStProc_GenId: TIB_StoredProc;
      MemD_NKUNI_NOM: TStringField;
      IbC_TVA: TIB_Cursor;
      IbC_TCT: TIB_Cursor;
      MemD_NKCATEGORIE: TStringField;
      MemD_NKSEC_REF: TStringField;
      Que_Secteur: TIBOQuery;
      Que_RenomeSecteur: TIBOQuery;
      Que_Categ: TIBOQuery;
      Que_RenomeRayon: TIBOQuery;
      Que_RenomeRayonRAY_ID: TIntegerField;
      Que_RenomeRayonRAY_UNIID: TIntegerField;
      Que_RenomeRayonRAY_IDREF: TIntegerField;
      Que_RenomeRayonRAY_NOM: TStringField;
      Que_RenomeRayonRAY_ORDREAFF: TIBOFloatField;
      Que_RenomeRayonRAY_VISIBLE: TIntegerField;
      Que_RenomeRayonRAY_SECID: TIntegerField;
      MemD_NKSECTEUR: TStringField;
      IB_AffSSF: TIB_Cursor;
      IB_AffRAY: TIB_Cursor;
      IB_AffFAM: TIB_Cursor;
      MemD_NKFAM_N: TStringField;
      MemD_NKSSF_N: TStringField;
      MemD_NKCAT_REF: TStringField;
      procedure DataModuleCreate(Sender: TObject);
      procedure DataModuleDestroy(Sender: TObject);
      procedure Que_RayonBeforeDelete(DataSet: TDataSet);
      procedure Que_RayonBeforeEdit(DataSet: TDataSet);
      procedure Que_RayonNewRecord(DataSet: TDataSet);
      procedure Que_RayonUpdateRecord(DataSet: TDataSet;
         UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
      procedure Que_FamilleBeforeDelete(DataSet: TDataSet);
      procedure Que_FamilleBeforeEdit(DataSet: TDataSet);
      procedure Que_FamilleNewRecord(DataSet: TDataSet);
      procedure Que_FamilleUpdateRecord(DataSet: TDataSet;
         UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
      procedure Que_SSFamilleBeforeDelete(DataSet: TDataSet);
      procedure Que_SSFamilleBeforeEdit(DataSet: TDataSet);
      procedure Que_SSFamilleNewRecord(DataSet: TDataSet);
      procedure Que_SSFamilleUpdateRecord(DataSet: TDataSet;
         UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
      procedure Que_UniversBeforeDelete(DataSet: TDataSet);
      procedure Que_UniversBeforeEdit(DataSet: TDataSet);
      procedure Que_UniversNewRecord(DataSet: TDataSet);
      procedure Que_UniversUpdateRecord(DataSet: TDataSet;
         UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
      procedure Que_SSFGTSBeforeDelete(DataSet: TDataSet);
      procedure Que_SSFGTSBeforeEdit(DataSet: TDataSet);
      procedure Que_SSFGTSNewRecord(DataSet: TDataSet);
      procedure Que_SSFGTSUpdateRecord(DataSet: TDataSet;
         UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
      procedure Que_TypeGTBeforeDelete(DataSet: TDataSet);
      procedure Que_TypeGTBeforeEdit(DataSet: TDataSet);
      procedure Que_TypeGTNewRecord(DataSet: TDataSet);
      procedure Que_TypeGTUpdateRecord(DataSet: TDataSet;
         UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
      procedure Que_GTFAfterPost(DataSet: TDataSet);
      procedure Que_GTFBeforeDelete(DataSet: TDataSet);
      procedure Que_GTFBeforeEdit(DataSet: TDataSet);
      procedure Que_GTFNewRecord(DataSet: TDataSet);
      procedure Que_GTFUpdateRecord(DataSet: TDataSet;
         UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
      procedure Que_TGFAfterPost(DataSet: TDataSet);
      procedure Que_TGFBeforeDelete(DataSet: TDataSet);
      procedure Que_TGFBeforeEdit(DataSet: TDataSet);
      procedure Que_TGFNewRecord(DataSet: TDataSet);
      procedure Que_TGFUpdateRecord(DataSet: TDataSet;
         UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
      procedure Que_GTSAfterPost(DataSet: TDataSet);
      procedure Que_GTSBeforeDelete(DataSet: TDataSet);
      procedure Que_GTSBeforeEdit(DataSet: TDataSet);
      procedure Que_GTSNewRecord(DataSet: TDataSet);
      procedure Que_GTSUpdateRecord(DataSet: TDataSet;
         UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
      procedure Que_TGSAfterPost(DataSet: TDataSet);
      procedure Que_TGSBeforeDelete(DataSet: TDataSet);
      procedure Que_TGSBeforeEdit(DataSet: TDataSet);
      procedure Que_TGSNewRecord(DataSet: TDataSet);
      procedure Que_TGSUpdateRecord(DataSet: TDataSet;
         UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
      procedure Que_ITSAfterPost(DataSet: TDataSet);
      procedure Que_ITSBeforeDelete(DataSet: TDataSet);
      procedure Que_ITSBeforeEdit(DataSet: TDataSet);
      procedure Que_ITSNewRecord(DataSet: TDataSet);
      procedure Que_ITSUpdateRecord(DataSet: TDataSet;
         UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
      procedure Que_TypeGTAfterPost(DataSet: TDataSet);
      procedure Que_UniversAfterPost(DataSet: TDataSet);
      procedure Que_RayonAfterPost(DataSet: TDataSet);
      procedure Que_FamilleAfterPost(DataSet: TDataSet);
      procedure Que_SSFamilleAfterPost(DataSet: TDataSet);
      procedure Que_SSFGTSAfterPost(DataSet: TDataSet);
      procedure Que_SecteurAfterPost(DataSet: TDataSet);
      procedure Que_SecteurBeforeDelete(DataSet: TDataSet);
      procedure Que_SecteurBeforeEdit(DataSet: TDataSet);
      procedure Que_SecteurNewRecord(DataSet: TDataSet);
      procedure Que_SecteurUpdateRecord(DataSet: TDataSet;
         UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
      procedure Que_RenomeSecteurAfterPost(DataSet: TDataSet);
      procedure Que_RenomeSecteurBeforeDelete(DataSet: TDataSet);
      procedure Que_RenomeSecteurBeforeEdit(DataSet: TDataSet);
      procedure Que_RenomeSecteurNewRecord(DataSet: TDataSet);
      procedure Que_RenomeSecteurUpdateRecord(DataSet: TDataSet;
         UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
      procedure GenerikAfterCancel(DataSet: TDataSet);
      procedure GenerikAfterPost(DataSet: TDataSet);
      procedure GenerikBeforeDelete(DataSet: TDataSet);
      procedure GenerikNewRecord(DataSet: TDataSet);
      procedure GenerikUpdateRecord(DataSet: TDataSet;
         UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
   private
    { Déclarations privées }
      AffRay, AffFam, AffSSF, AffTypeGT: Extended;
      AffGTF, AffTGF, AffGTS, FEDAS: Integer;
      Fich_Univers, Fich_NK: string;
   public
    { Déclarations publiques }
      procedure Refresh;
      function ChargeFichier(NomFich: string): boolean;
      function Univers: Boolean;
      function NKRay: Boolean;
      function NKfam: Boolean;
      function NKssfam: Boolean;
      procedure RenomeAncienSecteur;
      procedure RenomeAncienRayon(Cas: Integer);
      function AddNKRay: Boolean;
      function AddNKfam: Boolean;
      function AddNKssfam: Boolean;
      function TypeGT: Boolean;
      function GTF: Boolean;
      function TGF: Boolean;
      function GTS: Boolean;
      function TGS: Boolean;
      function ITS: Boolean;
   end;

var
   Dm_NK: TDm_NK;

//------------------------------------------------------------------------------
// Ressources strings
//------------------------------------------------------------------------------
resourcestring
   ErrPasGTF = 'Votre Grille de Taille Fournisseur : §0 est introuvable !';
   ErrPasGTS = 'Votre Grille de Taille Stat. : §0 est introuvable !';
   ErrPasTGS = 'Votre Taille de Grille Stat. : §0 est introuvable !';
   ErrPasUni = 'Votre Univers §0 est introuvable !';
   ErrPasRay = 'Votre Rayon §0 est introuvable !';
   ErrPasFam = 'Votre Famille §0 est introuvable !';
   NoUniv = 'L' + #39 + 'univers par défaut n' + #39 + 'est pas défini !';
   ErrRay = 'Integration des Rayons';
   ErrFam = 'Integration des Familles';
   ErrSSF = 'Integration des Sous-Familles';

implementation
uses GinkoiaStd,
   GinkoiaResStr,
   Main_Frm,
   Main_Dm,
   StdUtils;
{$R *.DFM}

//------------------------------------------------------------------------------
// Procédures et fonctions internes
//------------------------------------------------------------------------------

procedure TDm_NK.Refresh;
begin
   Grd_Que.Refresh;
end;

function TDm_NK.ChargeFichier(NomFich: string): boolean;
begin
   Result := False;
   if (NomFich <> '') then
   begin
      Fich_Nk := NomFich;
      Fich_Univers := StringReplace(NomFich, 'NK_', 'Univ_', [rfIgnoreCase]);
      Result := FileExists(Fich_Univers);
   end;
end;

function TDm_NK.Univers: Boolean;
begin
   MemD_Univers.Close;
   MemD_Univers.DelimiterChar := ';';
   MemD_Univers.Open;
   MemD_Univers.LoadFromTextFile(Fich_Univers);
   Que_Univers.Open;

   Splash_.caption := 'Import Univers';
   Splash_.Gauge.Progress := 1;
   Splash_.Gauge.MaxValue := MemD_Univers.RecordCount;
   Splash_.Splash;

   MemD_Univers.First;
   try
      while not MemD_Univers.Eof do
      begin
         Splash_.Gauge.Progress := Splash_.Gauge.Progress + 1;
         if not Que_Univers.Locate('UNI_NOM', MemD_Univers.FieldByName('NOM').asString, []) then
         begin
            Que_Univers.Insert;
            if (MemD_Univers.FieldByName('REF').asString <> '') then
               Que_Univers.FieldByName('UNI_IDREF').asInteger := StrToInt(DeleteChars(MemD_Univers.FieldByName('REF').asString, ' '))
            else Que_Univers.FieldByName('UNI_IDREF').asInteger := 0;
            Que_Univers.FieldByName('UNI_NOM').asString := MemD_Univers.FieldByName('NOM').asString;
            if (MemD_Univers.FieldByName('NIVEAU').asString <> '') and
               ((StrToInt(DeleteChars(MemD_Univers.FieldByName('NIVEAU').asString, ' ')) > 0) and (StrToInt(DeleteChars(MemD_Univers.FieldByName('NIVEAU').asString, ' ')) <= 3)) then
               Que_Univers.FieldByName('UNI_NIVEAU').asInteger := StrToInt(DeleteChars(MemD_Univers.FieldByName('NIVEAU').asString, ' '))
            else Que_Univers.FieldByName('UNI_NIVEAU').asInteger := 3;
            if (MemD_Univers.FieldByName('ORIGINE').asString <> '') and
               ((StrToInt(DeleteChars(MemD_Univers.FieldByName('ORIGINE').asString, ' ')) > 0) and (StrToInt(DeleteChars(MemD_Univers.FieldByName('ORIGINE').asString, ' ')) <= 2)) then
               Que_Univers.FieldByName('UNI_ORIGINE').asInteger := StrToInt(DeleteChars(MemD_Univers.FieldByName('ORIGINE').asString, ' '))
            else Que_Univers.FieldByName('UNI_ORIGINE').asInteger := 1;
            Que_Univers.Post;
         end;
         MemD_Univers.next;
      end;
   except
   end;
   Result := True;
   Splash_.Stop;
   Que_Univers.Close;
end;

function TDm_NK.NKRay: Boolean;
begin
   result := False;
   Que_Univers.Open;

   MemD_NK.Close;
   MemD_NK.DelimiterChar := ';';
   MemD_NK.Open;
   MemD_NK.LoadFromTextFile(Fich_Nk);

   Splash_.caption := 'Import Rayon';
   Splash_.Gauge.Progress := 1;
   Splash_.Gauge.MaxValue := MemD_NK.RecordCount;
   Splash_.Splash;

//    Que_Secteur.Open;
//    Que_Rayon.open;
//    MemD_NK.First;
//    result := True;
//    TRY
////      Récupération du secteur
//        IF NOT Que_Univers.Locate('UNI_NOM', MemD_NK.FieldByName('UNI_NOM').asString, []) THEN
//            RAISE EAbort.Create;
//
//        IF (Que_Secteur.ParamByName('UNI_ID').asInteger <> Que_Univers.FieldByname('UNI_ID').asInteger) THEN
//        BEGIN
//            Que_Secteur.Close;
//            Que_Secteur.ParamByName('UNI_ID').asInteger := Que_Univers.FieldByname('UNI_ID').asInteger;
//            Que_Secteur.Open;
//        END;
//
//        WHILE NOT MemD_NK.Eof DO
//        BEGIN
//            Splash_.Gauge.Progress := Splash_.Gauge.Progress + 1;
//
//            IF (MemD_NK.FieldByName('SECTEUR').asString <> '') THEN
//            BEGIN
//                IF NOT Que_Secteur.Locate('SEC_NOM', MemD_NK.FieldByName('SECTEUR').asString, []) THEN
//                BEGIN
//                    Que_Secteur.Insert;
//                    Que_Secteur.FieldByName('SEC_NOM').asString := MemD_NK.FieldByName('SECTEUR').asString;
//                    Que_Secteur.FieldByName('SEC_UNIID').asInteger := Que_Univers.FieldByname('UNI_ID').asInteger;
//                    Que_Secteur.FieldByName('SEC_IDREF').asInteger := MemD_NK.FieldByName('SEC_REF').asString;
//                    Que_Secteur.Post;
//                END;
//                secid := Que_Secteur.FieldByName('SEC_ID').asInteger;
//            END
//            ELSE secid := 0;
//
//            IDREF := StrToInt(DeleteChars(MemD_NK.FieldByName('RAY_REF').asString, ' '));
////                NOM := MemD_NK.FieldByName('RAY_REF').asString+' - '+MemD_NK.FieldByName('RAYON').asString;
//            NOM := MemD_NK.FieldByName('RAYON').asString;
//            IF NOT Que_Rayon.Locate('UNI_NOM;RAY_IDREF', vararrayof([MemD_NK.FieldByName('UNI_NOM').asString, IDREF]), []) THEN
//            BEGIN
//                Que_Rayon.Insert;
//                Que_Rayon.FieldByName('RAY_NOM').asString := NOM;
//                Que_Rayon.FieldByName('RAY_UNIID').asInteger := Que_Univers.FieldByname('UNI_ID').asInteger;
//                IF (MemD_NK.FieldByName('RAY_REF').asString <> '') THEN
//                BEGIN
//                    Que_Rayon.FieldByName('RAY_IDREF').asInteger := IDREF;
//                    Que_Rayon.FieldByName('RAY_ORDREAFF').asFloat := IDREF;
//                END
//                ELSE
//                BEGIN
//                    Que_Rayon.FieldByName('RAY_IDREF').asInteger := 0;
//                    AffRay := AffRay + 10;
//                    Que_Rayon.FieldByName('RAY_ORDREAFF').asFloat := AffRay;
//                END;
//                Que_Rayon.FieldByName('RAY_SECID').asInteger := secid;
//                Que_Rayon.Post;
//            END
//            ELSE
//            BEGIN
//                IF (MemD_NK.FieldByName('RAYON').asString <> '') AND (NOM <> Que_Rayon.FieldByName('RAY_NOM').asString) THEN
//                BEGIN
//                    Que_Rayon.Edit;
//                    Que_Rayon.FieldByName('RAY_NOM').asString := NOM;
//                    Que_Rayon.Post;
//                END;
//                IF (secid <> Que_Rayon.FieldByName('RAY_SECID').asInteger) THEN
//                BEGIN
//                    Que_Rayon.Edit;
//                    Que_Rayon.FieldByName('RAY_SECID').asInteger := secid;
//                    Que_Rayon.Post;
//                END;
//            END;
//
//            Que_Rayon.Close;
//            Que_Rayon.Open;
//            MemD_NK.next;
//        END;
//    EXCEPT
//        Result := False;
//    END;
   Splash_.Stop;
   Que_Univers.Close;
   Que_Secteur.Close;
   Que_Rayon.Close;
end;

function TDm_NK.NKfam: Boolean;
begin
   result := False;
   MemD_NK.Close;
   MemD_NK.DelimiterChar := ';';
   MemD_NK.Open;
   MemD_NK.LoadFromTextFile(Fich_Nk);

   Splash_.caption := 'Import Famille';
   Splash_.Gauge.Progress := 1;
   Splash_.Gauge.MaxValue := MemD_NK.RecordCount;
   Splash_.Splash;

//    Que_Univers.open;
//    Que_Rayon.open;
//    Que_Famille.open;
//    Que_Categ.open;
//    MemD_NK.First;
//    result := True;
//    TRY
//        WHILE NOT MemD_NK.Eof DO
//        BEGIN
//            Splash_.Gauge.Progress := Splash_.Gauge.Progress + 1;
//
//            IDREF_R := StrToInt(DeleteChars(MemD_NK.FieldByName('RAY_REF').asString, ' '));
//            IDREF_F := StrToInt(DeleteChars(MemD_NK.FieldByName('FAM_REF').asString, ' '));
////            NOM := MemD_NK.FieldByName('FAM_N').asString+' - '+MemD_NK.FieldByName('FAMILLE').asString;
//            NOM := MemD_NK.FieldByName('FAMILLE').asString;
//            IF Que_Univers.Locate('UNI_NOM', MemD_NK.FieldByName('UNI_NOM').asString, []) THEN
//            BEGIN
//                IF Que_Rayon.Locate('UNI_NOM;RAY_IDREF', vararrayof([MemD_NK.FieldByName('UNI_NOM').asString, IDREF_R]), []) THEN
//                BEGIN
//                    // Récupération de la categorie
//                    IF (Que_Categ.ParamByName('UNI_ID').asInteger <> Que_Univers.FieldByname('UNI_ID').asInteger) THEN
//                    BEGIN
//                        Que_Categ.Close;
//                        Que_Categ.ParamByName('UNI_ID').asInteger := Que_Univers.FieldByname('UNI_ID').asInteger;
//                        Que_Categ.Open;
//                    END;
////                    NOM_C := MemD_NK.FieldByName('SEC_REF').asString+' - '+MemD_NK.FieldByName('CATEGORIE').asString;
//                    NOM_C := MemD_NK.FieldByName('CATEGORIE').asString;
//
//                    IF (MemD_NK.FieldByName('CATEGORIE').asString <> '') THEN
//                    BEGIN
//                        IF NOT Que_Categ.Locate('CTF_NOM', NOM_C, []) THEN
//                        BEGIN
//                            Que_Categ.Insert;
//                            Que_Categ.FieldByName('CTF_NOM').asString := NOM_C;
//                            Que_Categ.FieldByName('CTF_UNIID').asInteger := Que_Univers.FieldByname('UNI_ID').asInteger;
//                            Que_Categ.Post;
//                        END;
//                        CTFID := Que_Categ.FieldByName('CTF_ID').asInteger;
//                    END
//                    ELSE CTFID := 0;
//
//                    IF NOT Que_Famille.Locate('UNI_NOM;RAY_IDREF;FAM_IDREF', vararrayof([MemD_NK.FieldByName('UNI_NOM').asString, IDREF_R, IDREF_F]), []) THEN
//                    BEGIN
//                        Que_Famille.Insert;
//                        Que_Famille.FieldByName('FAM_NOM').asString := NOM;
//                        Que_Famille.FieldByName('FAM_RAYID').asInteger := Que_Rayon.FieldByname('RAY_ID').asInteger;
//                        IF (MemD_NK.FieldByName('FAM_REF').asString <> '') THEN
//                        BEGIN
//                            Que_Famille.FieldByName('FAM_IDREF').asInteger := IDREF_F;
//                            Que_Famille.FieldByName('FAM_ORDREAFF').asFloat := IDREF_F;
//                        END
//                        ELSE
//                        BEGIN
//                            Que_Famille.FieldByName('FAM_IDREF').asInteger := 0;
//                            AffFam := AffFam + 10;
//                            Que_Famille.FieldByName('FAM_ORDREAFF').asFloat := AffFam;
//                        END;
//                        Que_Famille.FieldByName('RAY_IDREF').asInteger := IDREF_R;
//                        Que_Famille.FieldByName('FAM_CTFID').asInteger := CTFID;
//                        Que_Famille.Post;
//                    END
//                    ELSE
//                    BEGIN
//                        IF (MemD_NK.FieldByName('FAMILLE').asString <> '') AND (NOM <> Que_Famille.FieldByName('FAM_NOM').asString) THEN
//                        BEGIN
//                            Que_Famille.Edit;
//                            Que_Famille.FieldByName('FAM_NOM').asString := NOM;
//                            Que_Famille.Post;
//                        END;
//                        IF (CTFID <> Que_Famille.FieldByName('FAM_CTFID').asInteger) THEN
//                        BEGIN
//                            Que_Famille.Edit;
//                            Que_Famille.FieldByName('FAM_CTFID').asInteger := CTFID;
//                            Que_Famille.Post;
//                        END;
//                    END;
//                END
//                ELSE
//                BEGIN
//                    ErrMess(ErrPasRay, MemD_NK.FieldByName('RAYON').asString);
//                    result := False;
//                    Break;
//                END;
//            END
//            ELSE
//            BEGIN
//                ErrMess(ErrPasUni, MemD_NK.FieldByName('UNI_NOM').asString);
//                result := False;
//                Break;
//            END;
//            Que_Famille.Close;
//            Que_Famille.Open;
//            MemD_NK.next;
//        END;
//    EXCEPT
//        Result := False;
//    END;
   Splash_.Stop;
   Que_Rayon.Close;
   Que_Famille.Close;
   Que_Univers.close;
end;

function TDm_NK.NKssfam: Boolean;
begin
   result := False;
   MemD_NK.Close;
   MemD_NK.DelimiterChar := ';';
   MemD_NK.Open;
   MemD_NK.LoadFromTextFile(Fich_Nk);

   Splash_.caption := 'Import SSFamille';
   Splash_.Gauge.Progress := 1;
   Splash_.Gauge.MaxValue := MemD_NK.RecordCount;
   Splash_.Splash;

//    IbC_TVA.open;
//    IbC_TCT.open;
//
//    Que_Univers.open;
//    Que_Famille.open;
//    Que_SSFamille.open;
//    Que_SSFGTS.Open;
//    MemD_NK.First;
//    result := True;
//    TRY
//        WHILE NOT MemD_NK.Eof DO
//        BEGIN
//            Splash_.Gauge.Progress := Splash_.Gauge.Progress + 1;
//            IDREF_R := StrToInt(DeleteChars(MemD_NK.FieldByName('RAY_REF').asString, ' '));
//            IDREF_F := StrToInt(DeleteChars(MemD_NK.FieldByName('FAM_REF').asString, ' '));
//            IDREF_S := StrToInt(DeleteChars(MemD_NK.FieldByName('SSF_REF').asString, ' '));
////            NOM := MemD_NK.FieldByName('SSF_N').asString+' - '+MemD_NK.FieldByName('SOUS_FAMILLE').asString;
//            NOM := MemD_NK.FieldByName('SOUS_FAMILLE').asString;
//            IF Que_Univers.Locate('UNI_NOM', MemD_NK.FieldByName('UNI_NOM').asString, []) THEN
//            BEGIN
//
//                IF Que_Famille.Locate('UNI_NOM;RAY_IDREF;FAM_IDREF', vararrayof([MemD_NK.FieldByName('UNI_NOM').asString, IDREF_R, IDREF_F]), []) THEN
//                BEGIN
//                    IF NOT Que_SSFamille.Locate('UNI_NOM;RAY_IDREF;FAM_IDREF;SSF_IDREF', vararrayof([MemD_NK.FieldByName('UNI_NOM').asString, IDREF_R, IDREF_F, IDREF_S]), []) THEN
//                    BEGIN
//                        Que_SSFamille.Insert;
//                        Que_SSFamille.FieldByName('SSF_NOM').asString := NOM;
//                        Que_SSFamille.FieldByName('SSF_FAMID').asInteger := Que_Famille.FieldByname('FAM_ID').asInteger;
//                        IF (MemD_NK.FieldByName('SSF_REF').asString <> '') THEN
//                        BEGIN
//                            Que_SSFamille.FieldByName('SSF_IDREF').asInteger := IDREF_S;
//                            Que_SSFamille.FieldByName('SSF_ORDREAFF').asFloat := IDREF_S;
//                        END
//                        ELSE
//                        BEGIN
//                            Que_SSFamille.FieldByName('SSF_IDREF').asInteger := 0;
//                            AffSSF := AffSSF + 10;
//                            Que_SSFamille.FieldByName('SSF_ORDREAFF').asFloat := AffSSF;
//                        END;
//                        Que_SSFamille.FieldByName('RAY_IDREF').asInteger := IDREF_R;
//                        Que_SSFamille.FieldByName('FAM_IDREF').asInteger := IDREF_F;
//                        Que_SSFamille.Post;
//
//                        Que_SSFGTS.Insert;
//                        Que_SSFGTS.FieldByName('REL_SSFID').asInteger := Que_SSFamille.FieldByName('SSF_ID').asInteger;
//                        Que_SSFGTS.Post;
//                    END
//                    ELSE
//                    BEGIN
//                        IF (MemD_NK.FieldByName('SOUS_FAMILLE').asString <> '') AND (NOM <> Que_SSFamille.FieldByName('SSF_NOM').asSTRING) THEN
//                        BEGIN
//                            Que_SSFamille.Edit;
//                            Que_SSFamille.FieldByName('SSF_NOM').asString := NOM;
//                            Que_SSFamille.Post;
//                        END;
//                    END;
//                END
//                ELSE
//                BEGIN
//                    ErrMess(ErrPasFam, MemD_NK.FieldByName('FAMILLE').asString);
//                    result := False;
//                    Break;
//                END
//            END
//            ELSE
//            BEGIN
//                ErrMess(ErrPasUni, MemD_NK.FieldByName('UNI_NOM').asString);
//                result := False;
//                Break;
//            END;
//            Que_SSFamille.Close;
//            Que_SSFamille.Open;
//            MemD_NK.next;
//        END;
//    EXCEPT
//        Result := False;
//    END;
   Splash_.Stop;

   Que_Famille.Close;
   Que_SSFamille.Close;
   Que_SSFGTS.Close;
   IbC_TVA.close;
   IbC_TCT.close;
   Que_Univers.Close;

end;

procedure TDm_NK.RenomeAncienSecteur;
begin
     // Renomer tous les anciens secteurs qui n'ont pas d'IdRef
   Que_RenomeSecteur.Open;
   Que_RenomeSecteur.First;
   while not Que_RenomeSecteur.Eof do
   begin
      if Que_RenomeSecteur.FieldByName('SEC_IDREF').asInteger = 0 then
         if (Pos('* OLD *', Que_RenomeSecteur.FieldByName('SEC_NOM').asString) = 0) then
         begin
            Que_RenomeSecteur.Edit;
            Que_RenomeSecteur.FieldByName('SEC_NOM').asString := Que_RenomeSecteur.FieldByName('SEC_NOM').asString + '* OLD *';
            Que_RenomeSecteur.Post;
         end;
      Que_RenomeSecteur.next;
   end;
   Que_RenomeSecteur.Close;
end;

procedure TDm_NK.RenomeAncienRayon(Cas: Integer);
begin
     // cas=0 : Renomer tous les anciens Rayons qui n'ont pas d'IdRef
     // cas=1 : Renomer tous les anciens Rayons qui n'ont pas d'IdRef et passer IdRef=0

   Que_RenomeRayon.Open;
   Que_RenomeRayon.First;
   while not Que_RenomeRayon.Eof do
   begin
      if (Pos('[*]', Que_RenomeRayonRAY_NOM.asString) = 0) and
         ((cas = 1) or ((cas = 0) and (Que_RenomeRayonRAY_IDREF.asInteger = 0))) then
      begin
         Que_RenomeRayon.Edit;
         Que_RenomeRayonRAY_NOM.asString := Que_RenomeRayonRAY_NOM.asString + ' [*]';
         if ((cas = 1) and (Que_RenomeRayonRAY_IDREF.asInteger <> -1)) then
            Que_RenomeRayonRAY_IDREF.asInteger := 0;
         Que_RenomeRayon.Post;
      end;
      Que_RenomeRayon.next;
   end;
   Que_RenomeRayon.Close;

end;

function TDm_NK.AddNKRay: Boolean;
var IDREF, SECID: INTEGER;
   NOM: string;
   trouver: Boolean;
begin
   //**********
   // on travail sur les IdRef car c'est eux qui rendent l'info unique !
   //**********
   result := False;
   Que_Univers.Open;
   // se possitionner sur l'univers courant de travail
   if not Que_Univers.Locate('UNI_NOM', StdGinkoia.GetStringParamValue('UNIVERS_REF'), []) then
   begin
      InfMess(NoUniv, '');
      EXIT;
   end;

   // Récupération des secteurs de l'univers courant
   Que_Secteur.Close;
   Que_Secteur.ParamByName('UNI_ID').asInteger := Que_Univers.FieldByname('UNI_ID').asInteger;
   Que_Secteur.Open;

   MemD_NK.Close;
   MemD_NK.DelimiterChar := ';';
   MemD_NK.Open;
   MemD_NK.LoadFromTextFile(Fich_Nk);

   Splash_.caption := 'Import Rayon';
   Splash_.Gauge.Progress := 1;
   Splash_.Gauge.MaxValue := MemD_NK.RecordCount;
   Splash_.Splash;

   if (Pos('FEDAS', MemD_NK.FieldByName('UNI_NOM').asString) <> 0) then
      FEDAS := 1;

   IB_AffRAY.open;
   AffRAY := IB_AffRAY.fieldByName('ORDREAFF').asFloat;
   IB_AffRAY.Close;

   Que_Rayon.open;
   MemD_NK.First;
   result := True;
   try
      while not MemD_NK.Eof do
      begin
         Splash_.Gauge.Progress := Splash_.Gauge.Progress + 1;
            // Rechercher le secteur associé au rayon
         SECID := 0;
         if (MemD_NK.FieldByName('SECTEUR').asString <> '') then
         begin
            if not Que_Secteur.Locate('SEC_NOM', MemD_NK.FieldByName('SECTEUR').asString, []) then
            begin
               Que_Secteur.Insert;
               Que_Secteur.FieldByName('SEC_NOM').asString := MemD_NK.FieldByName('SECTEUR').asString;
               Que_Secteur.FieldByName('SEC_UNIID').asInteger := Que_Univers.FieldByname('UNI_ID').asInteger;
               Que_secteur.FieldByName('SEC_TYPE').asInteger := 1;
               if (MemD_NK.FieldByName('SEC_REF').asString <> '') then
                  secid := StrToInt(DeleteChars(MemD_NK.FieldByName('SEC_REF').asString, ' '))
               else
                  secid := 0;
               Que_Secteur.FieldByName('SEC_IDREF').asInteger := secid;
               Que_Secteur.Post;
            end;
            secid := Que_Secteur.FieldByName('SEC_ID').asInteger;
         end;

         Splash_.Gauge.Progress := Splash_.Gauge.Progress + 1;
         NOM := MemD_NK.FieldByName('RAYON').asString;
         if (MemD_NK.FieldByName('RAY_REF').asString <> '')
            and ((StrToInt(DeleteChars(MemD_NK.FieldByName('RAY_REF').asString, ' ')) <> 0)or((StrToInt(DeleteChars(MemD_NK.FieldByName('RAY_REF').asString, ' ')) = 0)and(NOM = 'Multisport'))) then
         begin
            IDREF := StrToInt(DeleteChars(MemD_NK.FieldByName('RAY_REF').asString, ' '));
            trouver := Que_Rayon.Locate('UNI_NOM;RAY_IDREF', vararrayof([Que_Univers.FieldByname('UNI_NOM').asString, IDREF]), []);
         end
         else
         begin
            IDREF := 0;
            trouver := Que_Rayon.Locate('UNI_NOM;RAY_NOM', vararrayof([Que_Univers.FieldByname('UNI_NOM').asString, MemD_NK.FieldByName('RAYON').asString]), []);
         end;

         if not trouver then
         begin
            Que_Rayon.Insert;
            Que_Rayon.FieldByName('RAY_NOM').asString := NOM;
            Que_Rayon.FieldByName('RAY_UNIID').asInteger := Que_Univers.FieldByname('UNI_ID').asInteger;
            Que_Rayon.FieldByName('RAY_IDREF').asInteger := IDREF;
            AffRay := AffRay + 10;
            Que_Rayon.FieldByName('RAY_ORDREAFF').asFloat := AffRay;
            Que_Rayon.FieldByName('RAY_SECID').asInteger := secid;
            Que_Rayon.Post;
         end
         else
         begin
            if (MemD_NK.FieldByName('RAYON').asString <> '') and (NOM <> Que_Rayon.FieldByName('RAY_NOM').asString) then
            begin
               Que_Rayon.Edit;
               Que_Rayon.FieldByName('RAY_NOM').asString := NOM;
               Que_Rayon.Post;
            end;
            if (secid <> Que_Rayon.FieldByName('RAY_SECID').asInteger) then
            begin
               Que_Rayon.Edit;
               Que_Rayon.FieldByName('RAY_SECID').asInteger := secid;
               Que_Rayon.Post;
            end;
         end;
         Que_Rayon.Close;
         Que_Rayon.Open;
         MemD_NK.next;
      end
   except
      Result := False;
      ErrMess(ErrRay, '');
   end;
   Splash_.Stop;
   Que_Univers.Close;
   Que_Secteur.Close;
   Que_Rayon.Close;
   MemD_NK.Close;
end;

function TDm_NK.AddNKfam: Boolean;
var IDREF_R, IDREF_F, CTFID: INTEGER;
   NOM, NOM_C: string;
   trouver: boolean;
begin
   result := False;
   Que_Univers.Open;
   if not Que_Univers.Locate('UNI_NOM', StdGinkoia.GetStringParamValue('UNIVERS_REF'), []) then
   begin
      InfMess(NoUniv, '');
      EXIT;
   end;

   MemD_NK.Close;
   MemD_NK.DelimiterChar := ';';
   MemD_NK.Open;
   MemD_NK.LoadFromTextFile(Fich_Nk);

   Splash_.caption := 'Import Famille';
   Splash_.Gauge.Progress := 1;
   Splash_.Gauge.MaxValue := MemD_NK.RecordCount;
   Splash_.Splash;

   Que_Rayon.open;
   Que_Famille.open;
   MemD_NK.First;
   result := True;
   try
      while not MemD_NK.Eof do
      begin
         Splash_.Gauge.Progress := Splash_.Gauge.Progress + 1;

         if FEDAS = 1 then
            NOM := MemD_NK.FieldByName('FAM_REF').asString + ' - ' + MemD_NK.FieldByName('FAMILLE').asString
         else
            NOM := MemD_NK.FieldByName('FAMILLE').asString;

        // Récupération de la categorie
         if (Que_Categ.ParamByName('UNI_ID').asInteger <> Que_Univers.FieldByname('UNI_ID').asInteger) then
         begin
            Que_Categ.Close;
            Que_Categ.ParamByName('UNI_ID').asInteger := Que_Univers.FieldByname('UNI_ID').asInteger;
            Que_Categ.Open;
         end;
         if FEDAS = 1 then
            NOM_C := MemD_NK.FieldByName('CAT_REF').asString + ' - ' + MemD_NK.FieldByName('CATEGORIE').asString
         else
            NOM_C := MemD_NK.FieldByName('CATEGORIE').asString;
         if (MemD_NK.FieldByName('CATEGORIE').asString <> '') then
         begin
            if not Que_Categ.Locate('CTF_NOM', NOM_C, []) then
            begin
               Que_Categ.Insert;
               Que_Categ.FieldByName('CTF_NOM').asString := NOM_C;
               Que_Categ.FieldByName('CTF_UNIID').asInteger := Que_Univers.FieldByname('UNI_ID').asInteger;
               Que_Categ.Post;
            end;
            CTFID := Que_Categ.FieldByName('CTF_ID').asInteger;
         end
         else CTFID := 0;

        // Récupération du Rayon
         if ((MemD_NK.FieldByName('RAY_REF').asString <> '')
            and ((StrToInt(DeleteChars(MemD_NK.FieldByName('RAY_REF').asString, ' ')) <> 0)or((StrToInt(DeleteChars(MemD_NK.FieldByName('RAY_REF').asString, ' ')) = 0)and(NOM = 'Multisport')))) then
         begin
            IDREF_R := StrToInt(DeleteChars(MemD_NK.FieldByName('RAY_REF').asString, ' '));
            if not Que_Rayon.Locate('UNI_NOM,RAY_IDREF', vararrayof([Que_Univers.FieldByName('UNI_NOM').asString, IDREF_R, ' ']), []) then
            begin
               ErrMess(ErrPasRay, MemD_NK.FieldByName('RAYON').asString);
               result := False;
               Break;
            end;
            IB_AffFAM.ParamByName('RAYID').Asinteger := Que_Rayon.FieldByname('RAY_ID').asInteger;
            IB_AffFAM.open;
            AffFAM := IB_AffFAM.fieldByName('ORDREAFF').asFloat;
            IB_AffFAM.Close;
         end
         else
         begin
                // IDREF_R := 0;
            if not Que_Rayon.Locate('UNI_NOM,RAY_NOM', vararrayof([Que_Univers.FieldByName('UNI_NOM').asString, MemD_NK.FieldByName('RAYON').asString]), []) then
            begin
               ErrMess(ErrPasRay, MemD_NK.FieldByName('RAYON').asString);
               result := False;
               Break;
            end;
            IB_AffFAM.ParamByName('RAYID').Asinteger := Que_Rayon.FieldByname('RAY_ID').asInteger;
            IB_AffFAM.open;
            AffFAM := IB_AffFAM.fieldByName('ORDREAFF').asFloat;
            IB_AffFAM.Close;
         end;

         if (MemD_NK.FieldByName('FAM_REF').asString <> '')
            and (StrToInt(DeleteChars(MemD_NK.FieldByName('FAM_REF').asString, ' ')) <> 0) then
         begin
            IDREF_F := StrToInt(DeleteChars(MemD_NK.FieldByName('FAM_REF').asString, ' '));
            trouver := Que_Famille.Locate('UNI_NOM;RAY_ID;FAM_IDREF', vararrayof([Que_Univers.FieldByname('UNI_NOM').asString, Que_Rayon.FieldByname('RAY_ID').asInteger, IDREF_F]), []);
         end
         else
         begin
            IDREF_F := 0;
            trouver := Que_Famille.Locate('UNI_NOM;RAY_ID;FAM_NOM', vararrayof([Que_Univers.FieldByname('UNI_NOM').asString, Que_Rayon.FieldByname('RAY_ID').asInteger, NOM]), []);
         end;

         if not trouver then
         begin
            Que_Famille.Insert;
            Que_Famille.FieldByName('FAM_NOM').asString := NOM;
            Que_Famille.FieldByName('FAM_RAYID').asInteger := Que_Rayon.FieldByname('RAY_ID').asInteger;
            Que_Famille.FieldByName('FAM_IDREF').asInteger := IDREF_F;
            AffFam := AffFam + 10;
            Que_Famille.FieldByName('FAM_ORDREAFF').asFloat := AffFam;
            Que_Famille.FieldByName('RAY_ID').asInteger := Que_Rayon.FieldByname('RAY_ID').asInteger;
            Que_Famille.FieldByName('FAM_CTFID').asInteger := CTFID;
            Que_Famille.Post;
         end
         else
         begin
            if (MemD_NK.FieldByName('FAMILLE').asString <> '') and (NOM <> Que_Famille.FieldByName('FAM_NOM').asString) then
            begin
               Que_Famille.Edit;
               Que_Famille.FieldByName('FAM_NOM').asString := NOM;
               Que_Famille.Post;
            end;
            if (CTFID <> Que_Famille.FieldByName('FAM_CTFID').asInteger) then
            begin
               Que_Famille.Edit;
               Que_Famille.FieldByName('FAM_CTFID').asInteger := CTFID;
               Que_Famille.Post;
            end;
         end;

         Que_Famille.Close;
         Que_Famille.Open;
         MemD_NK.next;
      end;
   except
      Result := False;
      ErrMess(ErrFam, '');
   end;
   Splash_.Stop;
   Que_Rayon.Close;
   Que_Famille.Close;
   Que_Univers.Close;
end;

function TDm_NK.AddNKssfam: Boolean;
var IDREF_R, IDREF_F, IDREF_S: INTEGER;
   NOM: string;
   trouver: Boolean;

begin
   result := False;

   Que_Univers.Open;
   if not Que_Univers.Locate('UNI_NOM', StdGinkoia.GetStringParamValue('UNIVERS_REF'), []) then
   begin
      InfMess(NoUniv, '');
      EXIT;
   end;

   MemD_NK.Close;
   MemD_NK.DelimiterChar := ';';
   MemD_NK.Open;
   MemD_NK.LoadFromTextFile(Fich_Nk);

   Splash_.caption := 'Import SSFamille';
   Splash_.Gauge.Progress := 1;
   Splash_.Gauge.MaxValue := MemD_NK.RecordCount;
   Splash_.Splash;

   IbC_TVA.open; // TVA pour le code 1
   IbC_TCT.open; // Type Comptable pour le code 1

   Que_Rayon.open;
   Que_Famille.open;
   Que_SSFamille.open;
   Que_SSFGTS.Open;
   MemD_NK.First;
   Result := True;
   try
      while not MemD_NK.Eof do
      begin
         Splash_.Gauge.Progress := Splash_.Gauge.Progress + 1;

         if FEDAS = 1 then
            NOM := MemD_NK.FieldByName('SOUS_FAMILLE').asString + ' [' + MemD_NK.FieldByName('SSF_REF').asString + ']'
         else
            NOM := MemD_NK.FieldByName('SOUS_FAMILLE').asString;

            // Récupération du Rayon
         if (MemD_NK.FieldByName('RAY_REF').asString <> '')
            and ((StrToInt(DeleteChars(MemD_NK.FieldByName('RAY_REF').asString, ' ')) <> 0)or((StrToInt(DeleteChars(MemD_NK.FieldByName('RAY_REF').asString, ' ')) = 0)and(NOM = 'Multisport'))) then
         begin
            IDREF_R := StrToInt(DeleteChars(MemD_NK.FieldByName('RAY_REF').asString, ' '));
            if not Que_Rayon.Locate('UNI_NOM,RAY_IDREF', vararrayof([Que_Univers.FieldByName('UNI_NOM').asString, IDREF_R]), []) then
            begin
               ErrMess(ErrPasRay, MemD_NK.FieldByName('RAYON').asString);
               result := False;
               Break;
            end;
         end
         else
         begin
                // IDREF_R := 0;
            if not Que_Rayon.Locate('UNI_NOM,RAY_NOM', vararrayof([Que_Univers.FieldByName('UNI_NOM').asString, MemD_NK.FieldByName('RAYON').asString]), []) then
            begin
               ErrMess(ErrPasRay, MemD_NK.FieldByName('RAYON').asString);
               result := False;
               Break;
            end;
         end;

            // Récupération de la Famille
         if (MemD_NK.FieldByName('FAM_REF').asString <> '')
            and (StrToInt(DeleteChars(MemD_NK.FieldByName('FAM_REF').asString, ' ')) <> 0) then
         begin
            IDREF_F := StrToInt(DeleteChars(MemD_NK.FieldByName('FAM_REF').asString, ' '));
            if not Que_Famille.Locate('UNI_NOM;RAY_ID;FAM_IDREF', vararrayof([Que_Univers.FieldByName('UNI_NOM').asString, Que_Rayon.FieldByname('RAY_ID').asInteger, IDREF_F]), []) then
            begin
               ErrMess(ErrPasRay, MemD_NK.FieldByName('FAMILLE').asString);
               result := False;
               Break;
            end;
            IB_AffSSF.ParamByName('FAMID').AsInteger := Que_Famille.FieldByname('FAM_ID').asInteger;
            IB_AffSSF.open;
            AffSSF := IB_AffSSF.fieldByName('ORDREAFF').asFloat;
            IB_AffSSF.Close;

         end
         else
         begin
                // IDREF_F := 0;
            if not Que_Famille.Locate('UNI_NOM;RAY_ID;FAM_NOM', vararrayof([Que_Univers.FieldByName('UNI_NOM').asString, Que_Rayon.FieldByname('RAY_ID').asInteger, MemD_NK.FieldByName('FAMILLE').asString]), []) then
            begin
               ErrMess(ErrPasRay, MemD_NK.FieldByName('FAMILLE').asString);
               result := False;
               Break;
            end;
            IB_AffSSF.ParamByName('FAMID').AsInteger := Que_Famille.FieldByname('FAM_ID').asInteger;
            IB_AffSSF.open;
            AffSSF := IB_AffSSF.fieldByName('ORDREAFF').asFloat;
            IB_AffSSF.Close;

         end;

         if (MemD_NK.FieldByName('SSF_REF').asString <> '')
            and (StrToInt(DeleteChars(MemD_NK.FieldByName('SSF_REF').asString, ' ')) <> 0) then
         begin
            IDREF_S := StrToInt(DeleteChars(MemD_NK.FieldByName('SSF_REF').asString, ' '));
            trouver := Que_SSFamille.Locate('UNI_NOM;RAY_ID;FAM_ID;SSF_IDREF', vararrayof([Que_Univers.FieldByName('UNI_NOM').asString, Que_Rayon.FieldByname('RAY_ID').asInteger, Que_Famille.FieldByname('FAM_ID').asInteger, IDREF_S]), []);
         end
         else
         begin
            IDREF_S := 0;
            trouver := Que_SSFamille.Locate('UNI_NOM;RAY_ID;FAM_ID;SSF_NOM', vararrayof([Que_Univers.FieldByName('UNI_NOM').asString, Que_Rayon.FieldByname('RAY_ID').asInteger, Que_Famille.FieldByname('FAM_ID').asInteger, NOM]), []);
         end;

         if not trouver then
         begin
            Que_SSFamille.Insert;
            Que_SSFamille.FieldByName('SSF_NOM').asString := NOM;
            Que_SSFamille.FieldByName('SSF_FAMID').asInteger := Que_Famille.FieldByname('FAM_ID').asInteger;
            Que_SSFamille.FieldByName('SSF_IDREF').asInteger := IDREF_S;
            AffSSF := AffSSF + 10;
            Que_SSFamille.FieldByName('SSF_ORDREAFF').asFloat := AffSSF;
            Que_SSFamille.FieldByName('RAY_ID').asInteger := Que_Rayon.FieldByname('RAY_ID').asInteger;
            Que_SSFamille.FieldByName('FAM_ID').asInteger := Que_Famille.FieldByname('FAM_ID').asInteger;
            Que_SSFamille.Post;

            Que_SSFGTS.Insert;
            Que_SSFGTS.FieldByName('REL_SSFID').asInteger := Que_SSFamille.FieldByName('SSF_ID').asInteger;
            Que_SSFGTS.Post;
         end
         else
         begin
            if (MemD_NK.FieldByName('SOUS_FAMILLE').asString <> '') and (NOM <> Que_SSFamille.FieldByName('SSF_NOM').asSTRING) then
            begin
               Que_SSFamille.Edit;
               Que_SSFamille.FieldByName('SSF_NOM').asString := NOM;
               Que_SSFamille.Post;
            end;
         end;
         Que_SSFamille.Close;
         Que_SSFamille.Open;
         MemD_NK.next;
      end;
   except
      Result := False;
      ErrMess(ErrSSF, '');
   end;
   Splash_.Stop;

   Que_Rayon.Close;
   Que_Famille.Close;
   Que_SSFamille.Close;
   Que_SSFGTS.Close;
   IbC_TVA.close;
   IbC_TCT.close;
   Que_Univers.close;

end;

function TDm_NK.TypeGT: Boolean;
begin
    // Result := False;
   MemD_TypeGT.Close;
   MemD_TypeGT.DelimiterChar := ';';
   MemD_TypeGT.Open;
   MemD_TypeGT.LoadFromTextFile(Frm_Main.CheminFicImport + 'TypeGT.txt');
   Que_TypeGT.Open;

   Splash_.caption := 'Import Type GT';
   Splash_.Gauge.Progress := 1;
   Splash_.Gauge.MaxValue := MemD_TypeGT.RecordCount;
   Splash_.Splash;

   MemD_TypeGT.First;
   Result := True;
   try
      while not MemD_TypeGT.Eof do
      begin
         Splash_.Gauge.Progress := Splash_.Gauge.Progress + 1;
         if not Que_TypeGT.Locate('TGT_NOM', MemD_TypeGT.FieldByName('TGT_NOM').asString, []) then
         begin
            Que_TypeGT.Insert;
            Que_TypeGT.FieldByName('TGT_NOM').asString := MemD_TypeGT.FieldByName('TGT_NOM').asString;
            Que_TypeGT.Post;
         end;
         MemD_TypeGT.next;
      end;
   except
      Result := False;
   end;
   Que_TypeGT.Close;
   Splash_.Stop;
end;

function TDm_NK.GTF: Boolean;
begin
    // Result := False;
   MemD_GTF.Close;
   MemD_GTF.DelimiterChar := ';';
   MemD_GTF.Open;
   MemD_GTF.LoadFromTextFile(Frm_Main.CheminFicImport + 'GrilleTailleF.txt');
   Que_GTF.open;
   Que_TypeGT.Open;

   Splash_.caption := 'Import des GTF';
   Splash_.Gauge.Progress := 1;
   Splash_.Gauge.MaxValue := MemD_GTF.RecordCount;
   Splash_.Splash;

   MemD_GTF.First;
   Result := True;
   try
      while not MemD_GTF.Eof do
      begin
         Splash_.Gauge.Progress := Splash_.Gauge.Progress + 1;
         if not Que_GTF.Locate('GTF_NOM', MemD_GTF.FieldByName('GTF_NOM').asString, []) then
         begin
            Que_GTF.Insert;
            Que_GTF.FieldByName('GTF_NOM').asString := MemD_GTF.FieldByName('GTF_NOM').asString;
            if (MemD_GTF.FieldByName('GTF_IDREF').asString <> '') then
               Que_GTF.FieldByName('GTF_IDREF').asInteger := StrToInt(DeleteChars(MemD_GTF.FieldByName('GTF_IDREF').asString, ' '))
            else Que_GTF.FieldByName('GTF_IDREF').asInteger := 0;
            Que_GTF.FieldByName('GTF_IMPORT').asInteger := 0;
            if Que_TypeGT.Locate('TGT_NOM', MemD_GTF.FieldByName('TGT_NOM').asString, []) then
               Que_GTF.FieldByName('GTF_TGTID').asInteger := Que_TypeGT.FieldByName('TGT_ID').asInteger
            else
               Que_GTF.FieldByName('GTF_TGTID').asInteger := 0;
            Que_GTF.Post;
         end;
         MemD_GTF.next;
      end;
   except
      Result := False;
   end;
   Splash_.Stop;
   Que_GTF.Close;
   Que_TypeGT.Close;
end;

function TDm_NK.TGF: Boolean;
begin
    // Result := False;
   MemD_GTF.Close;
   MemD_GTF.DelimiterChar := ';';
   MemD_GTF.Open;
   MemD_GTF.LoadFromTextFile(Frm_Main.CheminFicImport + 'GrilleTailleF.txt');
   Que_GTF.open;
   Que_TGF.open;

   Splash_.caption := 'Import des TGF';
   Splash_.Gauge.Progress := 1;
   Splash_.Gauge.MaxValue := MemD_GTF.RecordCount;
   Splash_.Splash;

   MemD_GTF.First;
   Result := True;
   try
      while not MemD_GTF.Eof do
      begin
         Splash_.Gauge.Progress := Splash_.Gauge.Progress + 1;
         if Que_GTF.Locate('GTF_NOM', MemD_GTF.FieldByName('GTF_NOM').asString, []) then
         begin
            if not Que_TGF.Locate('GTF_NOM;TGF_NOM', vararrayof([MemD_GTF.FieldByName('GTF_NOM').asString, MemD_GTF.FieldByName('TGF_NOM').asString]), []) then
            begin
               Que_TGF.Insert;
               Que_TGF.FieldByName('TGF_NOM').asString := MemD_GTF.FieldByName('TGF_NOM').asString;
               Que_TGF.FieldByName('TGF_TGFID').asInteger := Que_TGF.FieldByName('TGF_ID').asInteger;
               Que_TGF.FieldByName('TGF_GTFID').asInteger := Que_GTF.FieldByName('GTF_ID').asInteger;
               if (MemD_GTF.FieldByName('TGF_IDREF').asString <> '') then
                  Que_TGF.FieldByName('TGF_IDREF').asInteger := StrToInt(DeleteChars(MemD_GTF.FieldByName('TGF_IDREF').asString, ' '))
               else Que_TGF.FieldByName('TGF_IDREF').asInteger := 0;
               Que_TGF.FieldByName('TGF_CORRES').asString := MemD_GTF.FieldByName('TGF_CORRES').asString;
               if (MemD_GTF.FieldByName('TGF_STAT').asString <> '') then
                  Que_TGF.FieldByName('TGF_STAT').asInteger := StrToInt(DeleteChars(MemD_GTF.FieldByName('TGF_STAT').asString, ' '))
               else Que_GTF.FieldByName('TGF_STAT').asInteger := 0;
               Que_TGF.Post;
               Que_TGF.Close;
               Que_TGF.Open;
            end;
            MemD_GTF.next;
         end
         else
         begin
            ErrMess(ErrPasGTF, MemD_GTF.FieldByName('GTF_NOM').asString);
            result := False;
            Break;
         end;
      end;
   except
      Result := False;
   end;
   Splash_.Stop;
   Que_GTF.Close;
   Que_TGF.Close;
end;

function TDm_NK.GTS: Boolean;
begin
    // result := False;
   MemD_GTS.Close;
   MemD_GTS.DelimiterChar := ';';
   MemD_GTS.Open;
   MemD_GTS.LoadFromTextFile(Frm_Main.CheminFicImport + 'GrilleTailleS.txt');
   Que_GTS.open;
   Que_TypeGT.open;

   Splash_.caption := 'Import des GTS';
   Splash_.Gauge.Progress := 1;
   Splash_.Gauge.MaxValue := MemD_GTS.RecordCount;
   Splash_.Splash;

   MemD_GTS.First;
   result := True;
   try
      while not MemD_GTS.Eof do
      begin
         Splash_.Gauge.Progress := Splash_.Gauge.Progress + 1;
         if not Que_GTS.Locate('GTS_NOM', MemD_GTS.FieldByName('GTS_NOM').asString, []) then
         begin
            Que_GTS.Insert;
            Que_GTS.FieldByName('GTS_NOM').asString := MemD_GTS.FieldByName('GTS_NOM').asString;
            if Que_TypeGT.Locate('TGT_NOM', MemD_GTS.FieldByName('TGT_NOM').asString, []) then
               Que_GTS.FieldByName('GTS_TGTID').asInteger := Que_TypeGT.FieldByName('TGT_ID').asInteger
            else
               Que_GTS.FieldByName('GTS_TGTID').asInteger := 0;
            Que_GTS.Post;
         end;
         MemD_GTS.next;
      end;
   except
      result := False;
   end;
   Splash_.Stop;
   Que_GTS.Close;
   Que_TypeGT.close;
end;

function TDm_NK.TGS: Boolean;
begin
    // result := False;
   MemD_GTS.Close;
   MemD_GTS.DelimiterChar := ';';
   MemD_GTS.Open;
   MemD_GTS.LoadFromTextFile(Frm_Main.CheminFicImport + 'GrilleTailleS.txt');
   Que_GTS.open;
   Que_TGS.open;

   Splash_.caption := 'Import des TGS';
   Splash_.Gauge.Progress := 1;
   Splash_.Gauge.MaxValue := MemD_GTS.RecordCount;
   Splash_.Splash;

   MemD_GTS.First;
   result := True;
   try
      while not MemD_GTS.Eof do
      begin
         Splash_.Gauge.Progress := Splash_.Gauge.Progress + 1;
         if Que_GTS.Locate('GTS_NOM', MemD_GTS.FieldByName('GTS_NOM').asString, []) then
         begin
            if not Que_TGS.Locate('GTS_NOM;TGS_NOM', vararrayof([MemD_GTS.FieldByName('GTS_NOM').asString, MemD_GTS.FieldByName('TGS_NOM').asString]), []) then
            begin
               Que_TGS.Insert;
               Que_TGS.FieldByName('TGS_NOM').asString := MemD_GTS.FieldByName('TGS_NOM').asString;
               Que_TGS.FieldByName('TGS_GTSID').asInteger := Que_GTS.FieldByname('GTS_ID').asInteger;
               if (MemD_GTS.FieldByName('TGS_INDICE').asString <> '') then
                  Que_TGS.FieldByName('TGS_INDICE').asInteger := StrToInt(DeleteChars(MemD_GTS.FieldByName('TGS_INDICE').asString, ' '))
               else Que_TGS.FieldByName('TGS_INDICE').asInteger := 0;
               Que_TGS.Post;
               Que_TGS.Close;
               Que_TGS.Open;
            end;
         end
         else
         begin
            ErrMess(ErrPasGTS, MemD_GTS.FieldByName('GTS_NOM').asString);
            result := False;
            Break;
         end;
         MemD_GTS.next;
      end;
   except
      result := False;
   end;
   Splash_.Stop;
   Que_GTS.Close;
   Que_TGS.Close;
end;

function TDm_NK.ITS: boolean;
begin
    // result := False;
   MemD_GTS.Close;
   MemD_GTS.DelimiterChar := ';';
   MemD_GTS.Open;
   MemD_GTS.LoadFromTextFile(Frm_Main.CheminFicImport + 'GrilleTailleS.txt');
   Que_TGS.open;
   Que_ITS.open;

   Splash_.caption := 'Import des ITS';
   Splash_.Gauge.Progress := 1;
   Splash_.Gauge.MaxValue := MemD_GTS.RecordCount;
   Splash_.Splash;

   MemD_GTS.First;
   result := True;
   try
      while not MemD_GTS.Eof do
      begin
         Splash_.Gauge.Progress := Splash_.Gauge.Progress + 1;
         if Que_TGS.Locate('GTS_NOM;TGS_NOM', vararrayof([MemD_GTS.FieldByName('GTS_NOM').asString, MemD_GTS.FieldByName('TGS_NOM').asString]), []) then
         begin
            if (MemD_GTS.FieldByName('ITS_INDICE').asString <> '') and not Que_ITS.Locate('TGS_NOM;ITS_INDICE', vararrayof([MemD_GTS.FieldByName('TGS_NOM').asString, StrToInt(DeleteChars(MemD_GTS.FieldByName('ITS_INDICE').asString, ''))]), []) then
            begin
               Que_ITS.Insert;
               Que_ITS.FieldByName('ITS_TGSID').asInteger := Que_TGS.FieldByname('TGS_ID').asInteger;
               if (MemD_GTS.FieldByName('ITS_INDICE').asString <> '') then
                  Que_ITS.FieldByName('ITS_INDICE').asInteger := StrToInt(DeleteChars(MemD_GTS.FieldByName('ITS_INDICE').asString, ' '))
               else Que_ITS.FieldByName('ITS_INDICE').asInteger := 0;
               Que_ITS.Post;
               Que_ITS.Close;
               Que_ITS.Open;
            end;
         end
         else
         begin
            ErrMess(ErrPasTGS, MemD_GTS.FieldByName('TGS_NOM').asString);
            result := False;
            Break;
         end;
         MemD_GTS.next;
      end;
   except
      result := False;
   end;
   Splash_.Stop;

   Que_TGS.Close;
   Que_ITS.Close;
end;

//------------------------------------------------------------------------------
// Gestionnaires d'événements
//------------------------------------------------------------------------------

procedure TDm_NK.DataModuleCreate(Sender: TObject);
begin
   Grd_Que.Open;
   AffRay := 0;
   AffFam := 0;
   AffSSF := 0;
   Fich_Nk := '';
   Fich_Univers := '';
   FEDAS := 0;
end;

procedure TDm_NK.DataModuleDestroy(Sender: TObject);
begin
   Grd_Que.Close;
end;

procedure TDm_NK.Que_RayonBeforeDelete(DataSet: TDataSet);
begin
   if not Dm_Main.CheckAllowDelete((DataSet as TIBODataSet).KeyRelation,
      DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
      True) then Abort;
end;

procedure TDm_NK.Que_RayonBeforeEdit(DataSet: TDataSet);
begin
   if not Dm_Main.CheckAllowEdit((DataSet as TIBODataSet).KeyRelation,
      DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
      True) then Abort;
end;

procedure TDm_NK.Que_RayonNewRecord(DataSet: TDataSet);
begin
   if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
      (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
   Que_Rayon.FieldByName('RAY_VISIBLE').asInteger := 1;
   Que_Rayon.FieldByName('RAY_SECID').asInteger := 0;
//    AffRay := AffRay + 10;
//    Que_Rayon.FieldByName('RAY_ORDREAFF').asFloat := AffRay;
end;

procedure TDm_NK.Que_RayonUpdateRecord(DataSet: TDataSet;
   UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
   Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
      (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;

procedure TDm_NK.Que_FamilleBeforeDelete(DataSet: TDataSet);
begin
   if not Dm_Main.CheckAllowDelete((DataSet as TIBODataSet).KeyRelation,
      DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
      True) then Abort;
end;

procedure TDm_NK.Que_FamilleBeforeEdit(DataSet: TDataSet);
begin
   if not Dm_Main.CheckAllowEdit((DataSet as TIBODataSet).KeyRelation,
      DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
      True) then Abort;
end;

procedure TDm_NK.Que_FamilleNewRecord(DataSet: TDataSet);
begin
   if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
      (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
   Que_Famille.FieldByName('FAM_VISIBLE').asInteger := 1;
   Que_Famille.FieldByName('FAM_CTFID').asInteger := 0;
//    AffFam := AffFam + 10;
//    Que_Famille.FieldByName('FAM_ORDREAFF').asFloat := AffFam;
end;

procedure TDm_NK.Que_FamilleUpdateRecord(DataSet: TDataSet;
   UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
   Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
      (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;

procedure TDm_NK.Que_SSFamilleBeforeDelete(DataSet: TDataSet);
begin
   if not Dm_Main.CheckAllowDelete((DataSet as TIBODataSet).KeyRelation,
      DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
      True) then Abort;
end;

procedure TDm_NK.Que_SSFamilleBeforeEdit(DataSet: TDataSet);
begin
   if not Dm_Main.CheckAllowEdit((DataSet as TIBODataSet).KeyRelation,
      DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
      True) then Abort;
end;

procedure TDm_NK.Que_SSFamilleNewRecord(DataSet: TDataSet);
begin
   if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
      (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
   Que_SSFamille.FieldByName('SSF_VISIBLE').asInteger := 1;
   Que_SSFamille.FieldByName('SSF_CATID').asInteger := 0;
   Que_SSFamille.FieldByName('SSF_TVAID').asInteger := IbC_TVA.fieldByName('TVA_ID').asInteger;
   Que_SSFamille.FieldByName('SSF_TCTID').asInteger := IbC_TCT.fieldByName('TCT_ID').asInteger;
//    AffSSF := AffSSF + 10;
//    Que_SSFamille.FieldByName('SSF_ORDREAFF').asFloat := AffSSF;
end;

procedure TDm_NK.Que_SSFamilleUpdateRecord(DataSet: TDataSet;
   UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
   Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
      (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;

procedure TDm_NK.Que_UniversBeforeDelete(DataSet: TDataSet);
begin
   if not Dm_Main.CheckAllowDelete((DataSet as TIBODataSet).KeyRelation,
      DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
      True) then Abort;
end;

procedure TDm_NK.Que_UniversBeforeEdit(DataSet: TDataSet);
begin
   if not Dm_Main.CheckAllowEdit((DataSet as TIBODataSet).KeyRelation,
      DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
      True) then Abort;
end;

procedure TDm_NK.Que_UniversNewRecord(DataSet: TDataSet);
begin
   if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
      (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
end;

procedure TDm_NK.Que_UniversUpdateRecord(DataSet: TDataSet;
   UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
   Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
      (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;

procedure TDm_NK.Que_SSFGTSBeforeDelete(DataSet: TDataSet);
begin
   if not Dm_Main.CheckAllowDelete((DataSet as TIBODataSet).KeyRelation,
      DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
      True) then Abort;
end;

procedure TDm_NK.Que_SSFGTSBeforeEdit(DataSet: TDataSet);
begin
   if not Dm_Main.CheckAllowEdit((DataSet as TIBODataSet).KeyRelation,
      DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
      True) then Abort;
end;

procedure TDm_NK.Que_SSFGTSNewRecord(DataSet: TDataSet);
begin
   if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
      (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
   Que_SSFGTS.FieldByName('REL_GTSID').asFloat := 0;
end;

procedure TDm_NK.Que_SSFGTSUpdateRecord(DataSet: TDataSet;
   UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
   Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
      (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;

procedure TDm_NK.Que_TypeGTBeforeDelete(DataSet: TDataSet);
begin
   if not Dm_Main.CheckAllowDelete((DataSet as TIBODataSet).KeyRelation,
      DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
      True) then Abort;
end;

procedure TDm_NK.Que_TypeGTBeforeEdit(DataSet: TDataSet);
begin
   if not Dm_Main.CheckAllowEdit((DataSet as TIBODataSet).KeyRelation,
      DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
      True) then Abort;
end;

procedure TDm_NK.Que_TypeGTNewRecord(DataSet: TDataSet);
begin
   if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
      (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
   AffTypeGT := AffTypeGT + 10;
   Que_TypeGT.FieldByName('TGT_ORDREAFF').asFloat := AffTypeGT;
end;

procedure TDm_NK.Que_TypeGTUpdateRecord(DataSet: TDataSet;
   UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
   Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
      (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;

procedure TDm_NK.Que_GTFAfterPost(DataSet: TDataSet);
begin
   Dm_Main.IBOUpDateCache(DataSet as TIBOQuery);
end;

procedure TDm_NK.Que_GTFBeforeDelete(DataSet: TDataSet);
begin
   if not Dm_Main.CheckAllowDelete((DataSet as TIBODataSet).KeyRelation,
      DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
      True) then Abort;
end;

procedure TDm_NK.Que_GTFBeforeEdit(DataSet: TDataSet);
begin
   if not Dm_Main.CheckAllowEdit((DataSet as TIBODataSet).KeyRelation,
      DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
      True) then Abort;
end;

procedure TDm_NK.Que_GTFNewRecord(DataSet: TDataSet);
begin
   if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
      (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
   AffGTF := AffGTF + 10;
   Que_GTF.FieldByName('GTF_ORDREAFF').asFloat := AffGTF;
end;

procedure TDm_NK.Que_GTFUpdateRecord(DataSet: TDataSet;
   UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
   Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
      (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;

procedure TDm_NK.Que_TGFAfterPost(DataSet: TDataSet);
begin
   Dm_Main.IBOUpDateCache(DataSet as TIBOQuery);
end;

procedure TDm_NK.Que_TGFBeforeDelete(DataSet: TDataSet);
begin
   if not Dm_Main.CheckAllowDelete((DataSet as TIBODataSet).KeyRelation,
      DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
      True) then Abort;
end;

procedure TDm_NK.Que_TGFBeforeEdit(DataSet: TDataSet);
begin
   if not Dm_Main.CheckAllowEdit((DataSet as TIBODataSet).KeyRelation,
      DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
      True) then Abort;
end;

procedure TDm_NK.Que_TGFNewRecord(DataSet: TDataSet);
begin
   if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
      (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
   AffTGF := AffTGF + 10;
   Que_TGF.FieldByName('TGF_ORDREAFF').asFloat := AffTGF;
end;

procedure TDm_NK.Que_TGFUpdateRecord(DataSet: TDataSet;
   UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
   Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
      (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;

procedure TDm_NK.Que_GTSAfterPost(DataSet: TDataSet);
begin
   Dm_Main.IBOUpDateCache(DataSet as TIBOQuery);
end;

procedure TDm_NK.Que_GTSBeforeDelete(DataSet: TDataSet);
begin
   if not Dm_Main.CheckAllowDelete((DataSet as TIBODataSet).KeyRelation,
      DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
      True) then Abort;
end;

procedure TDm_NK.Que_GTSBeforeEdit(DataSet: TDataSet);
begin
   if not Dm_Main.CheckAllowEdit((DataSet as TIBODataSet).KeyRelation,
      DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
      True) then Abort;
end;

procedure TDm_NK.Que_GTSNewRecord(DataSet: TDataSet);
begin
   if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
      (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
   AffGTS := AffGTS + 10;
   Que_GTS.FieldByName('GTS_ORDREAFF').asFloat := AffGTS;
end;

procedure TDm_NK.Que_GTSUpdateRecord(DataSet: TDataSet;
   UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
   Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
      (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;

procedure TDm_NK.Que_TGSAfterPost(DataSet: TDataSet);
begin
   Dm_Main.IBOUpDateCache(DataSet as TIBOQuery);
end;

procedure TDm_NK.Que_TGSBeforeDelete(DataSet: TDataSet);
begin
   if not Dm_Main.CheckAllowDelete((DataSet as TIBODataSet).KeyRelation,
      DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
      True) then Abort;
end;

procedure TDm_NK.Que_TGSBeforeEdit(DataSet: TDataSet);
begin
   if not Dm_Main.CheckAllowEdit((DataSet as TIBODataSet).KeyRelation,
      DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
      True) then Abort;
end;

procedure TDm_NK.Que_TGSNewRecord(DataSet: TDataSet);
begin
   if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
      (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
end;

procedure TDm_NK.Que_TGSUpdateRecord(DataSet: TDataSet;
   UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
   Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
      (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;

procedure TDm_NK.Que_ITSAfterPost(DataSet: TDataSet);
begin
   Dm_Main.IBOUpDateCache(DataSet as TIBOQuery);
end;

procedure TDm_NK.Que_ITSBeforeDelete(DataSet: TDataSet);
begin
   if not Dm_Main.CheckAllowDelete((DataSet as TIBODataSet).KeyRelation,
      DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
      True) then Abort;
end;

procedure TDm_NK.Que_ITSBeforeEdit(DataSet: TDataSet);
begin
   if not Dm_Main.CheckAllowEdit((DataSet as TIBODataSet).KeyRelation,
      DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
      True) then Abort;
end;

procedure TDm_NK.Que_ITSNewRecord(DataSet: TDataSet);
begin
   if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
      (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
end;

procedure TDm_NK.Que_ITSUpdateRecord(DataSet: TDataSet;
   UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
   Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
      (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;

procedure TDm_NK.Que_TypeGTAfterPost(DataSet: TDataSet);
begin
   Dm_Main.IBOUpDateCache(DataSet as TIBOQuery);
end;

procedure TDm_NK.Que_UniversAfterPost(DataSet: TDataSet);
begin
   Dm_Main.IBOUpDateCache(DataSet as TIBOQuery);
end;

procedure TDm_NK.Que_RayonAfterPost(DataSet: TDataSet);
begin
   Dm_Main.IBOUpDateCache(DataSet as TIBOQuery);
end;

procedure TDm_NK.Que_FamilleAfterPost(DataSet: TDataSet);
begin
   Dm_Main.IBOUpDateCache(DataSet as TIBOQuery);
end;

procedure TDm_NK.Que_SSFamilleAfterPost(DataSet: TDataSet);
begin
   Dm_Main.IBOUpDateCache(DataSet as TIBOQuery);
end;

procedure TDm_NK.Que_SSFGTSAfterPost(DataSet: TDataSet);
begin
   Dm_Main.IBOUpDateCache(DataSet as TIBOQuery);
end;

procedure TDm_NK.Que_SecteurAfterPost(DataSet: TDataSet);
begin
   Dm_Main.IBOUpDateCache(DataSet as TIBOQuery);
end;

procedure TDm_NK.Que_SecteurBeforeDelete(DataSet: TDataSet);
begin
   if not Dm_Main.CheckAllowDelete((DataSet as TIBODataSet).KeyRelation,
      DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
      True) then Abort;
end;

procedure TDm_NK.Que_SecteurBeforeEdit(DataSet: TDataSet);
begin
   if not Dm_Main.CheckAllowEdit((DataSet as TIBODataSet).KeyRelation,
      DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
      True) then Abort;
end;

procedure TDm_NK.Que_SecteurNewRecord(DataSet: TDataSet);
begin
   if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
      (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
end;

procedure TDm_NK.Que_SecteurUpdateRecord(DataSet: TDataSet;
   UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
   Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
      (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;

procedure TDm_NK.Que_RenomeSecteurAfterPost(DataSet: TDataSet);
begin
   Dm_Main.IBOUpDateCache(DataSet as TIBOQuery);
end;

procedure TDm_NK.Que_RenomeSecteurBeforeDelete(DataSet: TDataSet);
begin
   if not Dm_Main.CheckAllowDelete((DataSet as TIBODataSet).KeyRelation,
      DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
      True) then Abort;
end;

procedure TDm_NK.Que_RenomeSecteurBeforeEdit(DataSet: TDataSet);
begin
   if not Dm_Main.CheckAllowEdit((DataSet as TIBODataSet).KeyRelation,
      DataSet.FieldByName((DataSet as TIBODataSet).KeyLinks.IndexNames[0]).AsString,
      True) then Abort;
end;

procedure TDm_NK.Que_RenomeSecteurNewRecord(DataSet: TDataSet);
begin
   if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
      (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
end;

procedure TDm_NK.Que_RenomeSecteurUpdateRecord(DataSet: TDataSet;
   UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
   Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
      (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;

procedure TDm_NK.GenerikAfterCancel(DataSet: TDataSet);
begin
   Dm_Main.IBOCancelCache(DataSet as TIBOQuery);
end;

procedure TDm_NK.GenerikAfterPost(DataSet: TDataSet);
begin
   Dm_Main.IBOUpDateCache(DataSet as TIBOQuery);
end;

procedure TDm_NK.GenerikBeforeDelete(DataSet: TDataSet);
begin
{ A achever ...
    IF StdGinkoia.ID_EXISTE('KEYID', que_QueryKEY_ID.asInteger, []) THEN
    BEGIN
        StdGinKoia.DelayMess(ErrNoDeleteIntChk, 3);
        ABORT;
    END;
}
end;

procedure TDm_NK.GenerikNewRecord(DataSet: TDataSet);
begin
   if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
      (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
end;

procedure TDm_NK.GenerikUpdateRecord(DataSet: TDataSet;
   UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
   Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
      (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;

end.

