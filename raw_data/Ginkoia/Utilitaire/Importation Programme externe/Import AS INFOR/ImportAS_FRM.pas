//$Log:
// 9    Utilitaires1.8         22/06/2009 09:52:05    Florent CHEVILLON
//      Annulation de la correction
// 8    Utilitaires1.7         12/06/2009 17:22:20    Sandrine MEDEIROS
//      Correction multi-magasin pour Transpo MORIN
// 7    Utilitaires1.6         23/10/2007 09:48:48    Sandrine MEDEIROS Ecarter
//      le rayon "OLD" dans toutes les requets
// 6    Utilitaires1.5         19/10/2007 16:12:23    Sandrine MEDEIROS
//      Modification pour ne pas traiter les elt de la NK "OLD" + modification
//      de l'extraction de la NK en prennant directement dans la table produits
//      car l'abressf ne contennait pas les info du nv rayon cr?er pour M.
//      Badot
// 5    Utilitaires1.4         19/10/2007 14:43:50    pascal          ignorer
//      le rayon OLD
// 4    Utilitaires1.3         08/08/2005 09:02:57    pascal         
//      Modification suite ? la transpo de travaillot
// 3    Utilitaires1.2         13/07/2005 10:10:56    Sandrine MEDEIROS Enrg de
//      NK.txt dans le traitement des articles avec la ligne finale
//      correctement positionn?e
// 2    Utilitaires1.1         12/07/2005 09:13:54    pascal          pb
//      transpo TRAVAILLOT:
//      lenteur cr?ation des CB
//      Pb de pump
// 1    Utilitaires1.0         27/04/2005 10:40:55    pascal          
//$
//$NoKeywords$
//
unit ImportAS_FRM;

interface

uses
   inifiles,
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   StdCtrls, DBTables, Db, dxmdaset, IBSQL, IBDatabase, variants;

type
   TFrm_ASInfort = class(TForm)
      Data: TDatabase;
      que_GrilleTaille: TQuery;
      Button1: TButton;
      que_GrilleTaillenum: TFloatField;
      que_GrilleTailleLibGT: TStringField;
      que_GrilleTailleTail: TSmallintField;
      que_GrilleTailleLibCourt: TStringField;
      que_GrilleTailleLibLong: TStringField;
      que_GrilleTailleRef: TFloatField;
      que_Magasin: TQuery;
      que_MagasinNum: TFloatField;
      que_MagasinLibLong: TStringField;
      que_MagasinLibCourt: TStringField;
      que_MagasinRS: TStringField;
      que_MagasinADR: TStringField;
      que_MagasinCP: TStringField;
      que_MagasinVILLE: TStringField;
      que_MagasinTel: TStringField;
      que_MagasinFax: TStringField;
      que_MagasinRC: TStringField;
      que_MagasinComent: TStringField;
      que_MagasinCDADH: TIntegerField;
      que_NK: TQuery;
      que_Fournisseur: TQuery;
      que_FournisseurNum: TFloatField;
      que_FournisseurRS: TStringField;
      que_FournisseurAdr: TStringField;
      que_FournisseurCP: TStringField;
      que_FournisseurVille: TStringField;
      que_FournisseurTel: TStringField;
      que_FournisseurFax: TStringField;
      que_FournisseurNoCli: TStringField;
      que_FournisseurCorres: TStringField;
      que_FournisseurRemise: TFloatField;
      que_Article: TQuery;
      que_Tarif: TQuery;
      que_NKRAY_ID: TFloatField;
      que_NKFAM_ID: TFloatField;
      que_NKSFAM_ID: TFloatField;
      que_NKRayon: TStringField;
      que_NKFam: TStringField;
      que_NKSF: TStringField;
      que_NKR: TIntegerField;
      que_NKF: TIntegerField;
      que_NKS: TIntegerField;
      que_ArticleRAY_ID: TFloatField;
      que_ArticleFAM_ID: TFloatField;
      que_ArticleSFAM_ID: TFloatField;
      que_ArticleCode: TFloatField;
      que_Articlechrono: TStringField;
      que_ArticleDesi: TStringField;
      que_ArticleDescrip: TStringField;
      que_ArticleGT: TFloatField;
      que_ArticleDtCrea: TDateTimeField;
      que_ArticleTxDep: TIntegerField;
      que_ArticleDtDep: TStringField;
      que_ArticleLibDep: TStringField;
      que_ArticleFourn: TFloatField;
      que_ArticleRefFourn: TStringField;
      que_ArticleArchi: TIntegerField;
      que_ArticleCritere: TStringField;
      que_ArticleTVA: TFloatField;
      que_ArticleSecteur: TStringField;
      que_ArticleGenre: TStringField;
      que_ArticleFidel: TIntegerField;
      que_ArticleCC1: TStringField;
      que_ArticleCL1: TStringField;
      que_ArticlePseudo: TStringField;
      que_ArticleCRIT3: TStringField;
      que_ArticleCRIT4: TStringField;
      que_ArticleCrit5: TStringField;
      que_TarifRAY_ID: TFloatField;
      que_TarifFAM_ID: TFloatField;
      que_TarifSFAM_ID: TFloatField;
      que_TarifPROD_ID: TFloatField;
      que_TarifTail_Position: TSmallintField;
      que_TarifProd_PA: TFloatField;
      que_TarifART_PA: TFloatField;
      que_TarifART_PV1: TFloatField;
      que_TarifCAR_PV2: TFloatField;
      que_TarifCAR_PV3: TFloatField;
      que_TarifFour_Id: TFloatField;
      que_CB: TQuery;
      que_CBRAY_ID: TFloatField;
      que_CBFAM_ID: TFloatField;
      que_CBSFAM_ID: TFloatField;
      que_CBPROD_ID: TFloatField;
      que_CBTAIL_POSITION: TSmallintField;
      que_CBCOU: TIntegerField;
      que_CBCB_CODEBARRE: TStringField;
      que_StkInitial: TQuery;
      que_StkInitialRAY_ID: TFloatField;
      que_StkInitialFAM_ID: TFloatField;
      que_StkInitialSFAM_ID: TFloatField;
      que_StkInitialProd_Id: TFloatField;
      que_StkInitialMag_Id: TFloatField;
      que_StkInitialTAIL_POSITION: TSmallintField;
      que_StkInitialCoul: TIntegerField;
      que_StkInitialHist_QteInitiale: TFloatField;
      que_StkInitialQTE: TFloatField;
      que_StkInitialPAU: TFloatField;
      que_StkInitialPVU: TFloatField;
      que_StkInitialPAGL: TFloatField;
      que_StkInitialPVGL: TFloatField;
      que_StkInitialTVA: TFloatField;
      que_StkInitialLad: TDateTimeField;
      que_StkInitialFOUR_ID: TFloatField;
      que_Histo: TQuery;
      que_HistoTes: TIntegerField;
      que_HistoRAY_ID: TFloatField;
      que_HistoFAM_ID: TFloatField;
      que_HistoSFAM_ID: TFloatField;
      que_HistoProd_Id: TFloatField;
      que_HistoMag_Id: TFloatField;
      que_HistoTAIL_POSITION: TSmallintField;
      que_HistoCoul: TIntegerField;
      que_HistoHist_QteRecept: TFloatField;
      que_HistoQTE: TFloatField;
      que_HistoPAU: TFloatField;
      que_HistoPVU: TFloatField;
      que_HistoPAGL: TFloatField;
      que_HistoPVGL: TFloatField;
      que_HistoTVA: TFloatField;
      que_HistoLad: TDateTimeField;
      que_HistoFOUR_ID: TFloatField;
      que_HistoPAMP: TFloatField;
      que_Commande: TQuery;
      que_CommandeCMD_ID: TFloatField;
      que_CommandeRAy_ID: TFloatField;
      que_CommandeFAM_ID: TFloatField;
      que_CommandeSFAM_ID: TFloatField;
      que_CommandePROD_ID: TFloatField;
      que_CommandeTAIL_POSITION: TSmallintField;
      que_CommandeCOUL: TIntegerField;
      que_CommandeMAG_LIV_ID: TFloatField;
      que_CommandeCMD_REFERENCE: TStringField;
      que_CommandeQte: TFloatField;
      que_CommandeARTCO_PA: TFloatField;
      que_CommandeR1: TFloatField;
      que_CommandeR2: TIntegerField;
      que_CommandeR3: TIntegerField;
      que_CommandePxNN: TFloatField;
      que_CommandeTVA: TFloatField;
      que_CommandeDtLiv: TDateTimeField;
      que_CommandeDtLim: TIntegerField;
      que_CommandeARTCO_PV: TFloatField;
      que_CommandeFOUR_ID: TFloatField;
      que_CommandeC_RBP: TFloatField;
      que_CommandeC_Date: TDateTimeField;
      que_CommandeC_Dliv: TDateTimeField;
      que_CommandeC_Offset: TIntegerField;
      que_CommandeCMD_COMMENT: TStringField;
      que_Client: TQuery;
      que_ClientNom: TStringField;
      que_ClientPrenom: TStringField;
      que_ClientAdresse: TStringField;
      que_ClientCP: TStringField;
      que_ClientVille: TStringField;
      que_ClientPolitesse: TStringField;
      que_ClientDPP: TDateTimeField;
      que_ClientDdp: TDateTimeField;
      que_ClientObservation: TStringField;
      que_ClientTelp: TStringField;
      que_ClientTelt: TStringField;
      que_ClientCF: TIntegerField;
      que_ClientSexe: TSmallintField;
      que_ClientJanni: TDateTimeField;
      que_ClientCateg: TStringField;
      que_ClientCrit1: TStringField;
      que_ClientCrit2: TStringField;
      que_ClientCrit3: TStringField;
      que_ClientCrit4: TStringField;
      que_ClientCrit5: TStringField;
      que_ClientPays: TStringField;
      que_ClientTA: TStringField;
      que_ClientNumero: TFloatField;
      que_ClientGarant: TIntegerField;
      MemD_ARTICLE: TdxMemData;
      MemD_ARTICLEART_ID: TStringField;
      MemD_ARTICLERRFFSS: TStringField;
      MemD_ARTICLEREFART: TStringField;
      MemD_ARTICLENum: TIntegerField;
      que_ClientCLT_PLAFONDENCOURS: TFloatField;
      MemD_GT: TdxMemData;
      MemD_GTGTID: TStringField;
      MemD_GTNum: TIntegerField;
      MemD_Fourn: TdxMemData;
      MemD_FournFOU_ID: TStringField;
      MemD_FournNum: TIntegerField;
      MemD_Client: TdxMemData;
      MemD_ClientCLT_ID: TStringField;
      MemD_ClientNum: TIntegerField;
      que_ArticleStk: TFloatField;
      que_StkFinal: TQuery;
      que_StkFinalRAY_ID: TFloatField;
      que_StkFinalFAM_ID: TFloatField;
      que_StkFinalSFAM_ID: TFloatField;
      que_StkFinalProd_Id: TFloatField;
      que_StkFinalMag_Id: TFloatField;
      que_StkFinalTAIL_POSITION: TSmallintField;
      que_StkFinalCoul: TIntegerField;
      que_StkFinalArt_QteStk: TFloatField;
      que_StkFinalQte: TFloatField;
      que_StkFinalDemarque: TFloatField;
      que_StkFinalTVA: TFloatField;
      que_StkFinalFOUR_ID: TFloatField;
      que_RecupStk: TQuery;
      que_RecupStkRAY_ID: TFloatField;
      que_RecupStkFAM_ID: TFloatField;
      que_RecupStkSFAM_ID: TFloatField;
      que_RecupStkProd_Id: TFloatField;
      que_RecupStkMag_Id: TFloatField;
      que_RecupStkTAIL_POSITION: TSmallintField;
      que_RecupStkCoul: TIntegerField;
      que_RecupStkArt_QteStk: TFloatField;
      que_RecupStkDemarque: TFloatField;
      que_RecupStkTVA: TFloatField;
      que_RecupStkFOUR_ID: TFloatField;
      que_ArticleRay_libelle: TStringField;
      que_Articlefam_libelle: TStringField;
      que_ArticleSfam_libelle: TStringField;
      que_Execute: TQuery;
      Qry_Rech: TQuery;
      Qry_rech2: TQuery;
      Qry_RechARTRE_PA: TFloatField;
      Qry_rech2ARTRE_PA: TFloatField;
      que_StkFinalTAIL_ID: TFloatField;
      que_RecupStkTAIL_ID: TFloatField;
      que_CommandeTAIL_ID: TFloatField;
      que_HistoTAIL_ID: TFloatField;
      que_TarifTAIL_ID: TFloatField;
      que_CBTAIL_ID: TFloatField;
      que_StkInitialTAIL_ID: TFloatField;
      que_StkInitialPAMP: TFloatField;
      CheckBox1: TCheckBox;
      DataGinkoia: TIBDatabase;
      tranGinkoia: TIBTransaction;
      Sql1: TIBSQL;
      Sql2: TIBSQL;
      CB_VELO: TCheckBox;
    Fichier: TCheckBox;
      procedure Button1Click(Sender: TObject);
   private
      function TraiteSt(S: string): string;
      function TraiteStNb(S: string): string;
    { Déclarations privées }
   public
    { Déclarations publiques }
      Increment: integer;
   end;

var
   Frm_ASInfort: TFrm_ASInfort;

implementation

{$R *.DFM}

function TFrm_ASInfort.TraiteSt(S: string): string;
begin
   while pos(';', S) > 0 do
      S[pos(';', S)] := ' ';
   if trim(S) = '' then
      result := ''
   else result := S;
end;

function cmplgauche(S: string; Nb: integer): string;
begin
   while length(s) < nb do S := '0' + S;
   result := S;
end;

function traitetsl(tsl: TstringList; S: string): string;
var
   i: integer;
begin
   result := '00';
   for i := 0 to Tsl.count - 1 do
   begin
      if Copy(TSL[i], 1, Length(S) + 1) = S + ';' then
      begin
         Result := trim(Copy(Tsl[i], Length(S) + 2, 2));
         result := Cmplgauche(Result, 2);
         break;
      end;
   end;
end;

procedure TFrm_ASInfort.Button1Click(Sender: TObject);
var
   tsl: tstringList;
   ttsl: TstringList;
   tsl_tarif: TstringList;
   chrono: Integer;
   S: string;
   i: integer;

   Log,
      Ray: TstringList;
   ArtSup: TstringList;

   LesNomenclatures: TstringList;
   s1: string;

   LePrix: string;
   Pass: string;

   ini: tinifile;

   function TraiteDate(D: TDate): string;
   var
      A, M, J: Word;
   begin
      decodedate(D, A, M, J);
      if A >= 2000 then
         result := '2'
      else
         result := '1';
      result := result + formatDateTime('YYMM', D);
   end;

   function Numeric_En3(Num: Integer): string;
   var
      S: string;
   begin
      S := '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
      Result := S[(Num mod Length(S)) + 1];
      Num := Num div Length(S);
      Result := Result + S[(Num mod Length(S)) + 1];
      Num := Num div Length(S);
      Result := Result + S[(Num mod Length(S)) + 1];
   end;

   procedure Article_Ajoute(R, F, S, ART: string);
   var
      Pass: string;
      Num: Integer;
      S1: string;
   begin
      Art := trim(art);
      S1 := R + '/' + F + '/' + S;
      Pass := '000000';
      num := 0;
      while (num < ray.count) and (Copy(ray[num], 1, length(S1) + 1) <> S1 + ';') do
         inc(num);
      if Copy(ray[num], 1, length(S1) + 1) = S1 + ';' then
      begin
         Pass := Copy(ray[num], length(ray[num]) - 5, 6);
      end;
      num := 0;
      MemD_ARTICLE.First;
      while not MemD_ARTICLE.Eof do
      begin
         if MemD_ARTICLERRFFSS.AsString = Pass then
         begin
            if MemD_ARTICLENum.AsInteger > Num then
               Num := MemD_ARTICLENum.AsInteger;
         end;
         MemD_ARTICLE.Next;
      end;
      Inc(num);
      MemD_ARTICLE.Append;
      MemD_ARTICLEART_ID.AsString := Art;
      MemD_ARTICLERRFFSS.AsString := Pass;
      MemD_ARTICLEREFART.AsString := Pass + Numeric_En3(Num);
      MemD_ARTICLENum.AsInteger := Num;
        {
        IF num > 999 THEN
        BEGIN
            RAISE exception.create('problème plus de 999 dans une sous famille');
        END;
        }
      MemD_ARTICLE.Post;
   end;

   function Code_Article(ART: string): string;
   begin
      result := '';
      MemD_ARTICLE.First;
      while not MemD_ARTICLE.Eof do
      begin
         if MemD_ARTICLEART_ID.AsString = Art then
         begin
            result := MemD_ARTICLEREFART.AsString;
            BREAK;
         end;
         MemD_ARTICLE.Next;
      end;
      if result = '' then
         Log.add('Impossible de trouver l''Article ' + ART);
   end;

   function trouve_gt(taille: string; err: boolean): Boolean;
   begin
      MemD_GT.Locate('GTID', VarArrayOf([taille]), []);
      if MemD_GTGTID.AsString <> Taille then
      begin
         MemD_GT.First;
         while not (MemD_GT.eof) and (MemD_GTGTID.AsString <> Taille) do
            MemD_GT.Next;
      end;
      if err and (MemD_GTGTID.AsString <> Taille) then
      begin
         result := false;
            // Application.messageBox('problème Pas trouvé Grille taille', Pchar(Taille), Mb_Ok);
      end
      else
         result := true;

   end;

   procedure Trouve_fou(fou: string);
   begin
      MemD_Fourn.Locate('FOU_ID', VarArrayOf([fou]), []);
      if MemD_FournFOU_ID.AsString <> fou then
      begin
         MemD_Fourn.First;
         while not (MemD_Fourn.Eof) and (MemD_FournFOU_ID.AsString <> fou) do
            MemD_Fourn.next;
      end;
      if MemD_FournFOU_ID.AsString <> fou then
         raise exception.create('problème Pas trouvé fournisseur');
   end;

   function traitetaille(ID: Integer; position: string): string;
   begin
      if id = 0 then
         result := '1'
      else
         result := position;
   end;

begin
   if CheckBox1.Checked then
      increment := 1
   else
      increment := 0;
   data.open;
   decimalseparator := '.';

   Caption := 'Execution des proc AS INFOR';
   que_Execute.Sql.Clear;
   que_Execute.Sql.Add('Execute Pss_Hist_Mouvement ''C:\Temp.txt''');
   que_Execute.ExecSQL;
   que_Execute.Sql.Clear;
   que_Execute.Sql.Add('Execute Pss_Hist_Reception ''C:\Temp.txt''');
   que_Execute.ExecSQL;
   que_Execute.Sql.Clear;
   que_Execute.Sql.Add('Execute Pss_Hist_Vente ''C:\Temp.txt''');
   que_Execute.ExecSQL;
   Caption := 'Commit AS INFOR';
   Repaint;
   if Data.InTransaction then
      Data.Commit;
   Caption := 'FIN DES PROC';
   Repaint;

   tsl := tstringList.create;
   Ray := tstringList.create;
   Log := tstringList.create;
   ArtSup := tstringList.create;
   LesNomenclatures := tstringList.create;
   try
      Caption := 'Grille taille';
      Repaint;
      Log.add('Importation des grilles de taille');
      MemD_GT.Close;
      MemD_GT.Open;
      que_GrilleTaille.open;
      que_GrilleTaille.first;
      tsl.clear;
      tsl.add('Num;LibGT;Tail;LibCourt;LibLong;Ref');
      MemD_GT.Insert;
      MemD_GTGTID.AsString := '0';
      MemD_GTNum.Asinteger := 1;
      MemD_GT.Post;
      tsl.add(TraiteSt('1') + ';' +
         TraiteSt('UniTaille') + ';' +
         TraiteSt('1') + ';' +
         TraiteSt('Uni') + ';' +
         TraiteSt('UniTaille') + ';' +
         TraiteSt('0'));
      i := 1;
      while not que_GrilleTaille.Eof do
      begin
            // Cyprien
            {
            IF (UpperCase(Copy(que_GrilleTailleLibGT.AsString, 1, 1)) = 'Z')
                OR
                (trim(que_GrilleTaillenum.AsString) = '5') OR
                (trim(que_GrilleTaillenum.AsString) = '1') OR
                (trim(que_GrilleTaillenum.AsString) = '3') OR
                (trim(que_GrilleTaillenum.AsString) = '14') OR
                (trim(que_GrilleTaillenum.AsString) = '16') OR
                (trim(que_GrilleTaillenum.AsString) = '22') OR
                (trim(que_GrilleTaillenum.AsString) = '25') OR
                (trim(que_GrilleTaillenum.AsString) = '26') OR
                (trim(que_GrilleTaillenum.AsString) = '27') OR
                (trim(que_GrilleTaillenum.AsString) = '29') OR
                (trim(que_GrilleTaillenum.AsString) = '32') OR
                (trim(que_GrilleTaillenum.AsString) = '42') OR
                (trim(que_GrilleTaillenum.AsString) = '1000000006') OR
                (trim(que_GrilleTaillenum.AsString) = '1000000024')
                THEN
            }
         begin
            trouve_gt(que_GrilleTaillenum.AsString, False);
            if MemD_GTGTID.AsString <> que_GrilleTaillenum.AsString then
            begin
               inc(i);
               MemD_GT.Insert;
               MemD_GTGTID.AsString := que_GrilleTaillenum.AsString;
               MemD_GTNum.Asinteger := i;
               MemD_GT.Post;
            end;
            tsl.add(TraiteSt(MemD_GTNum.AsString) + ';' +
               TraiteSt(que_GrilleTailleLibGT.AsString) + ';' +
               TraiteSt(que_GrilleTailleTail.AsString) + ';' +
               TraiteSt(que_GrilleTailleLibCourt.AsString) + ';' +
               TraiteSt(que_GrilleTailleLibLong.AsString) + ';' +
               TraiteSt(que_GrilleTailleRef.AsString));
         end;
         que_GrilleTaille.Next;
      end;
      que_GrilleTaille.Close;
      tsl.add('Num;%FINI%;Tail;LibCourt;LibLong;Ref');
      tsl.savetofile('GT.TXT');

      Caption := 'Magasin';
      Repaint;
      Log.add('Importation des magasins');
      Que_Magasin.Open;
      Que_Magasin.First;
      tsl.clear;
      tsl.add('Num;LibLong;LibCourt;RS;ADR;CP;VILLE;Tel;Fax;RC;Coment;CDADH');
      while not Que_Magasin.Eof do
      begin
         tsl.add(TraiteSt(Inttostr(que_MagasinNum.AsInteger + Increment)) + ';' +
            TraiteSt(que_MagasinLibLong.AsString) + ';' +
            TraiteSt(que_MagasinLibCourt.AsString) + ';' +
            TraiteSt(que_MagasinRS.AsString) + ';' +
            TraiteSt(que_MagasinADR.AsString) + ';' +
            TraiteSt(que_MagasinCP.AsString) + ';' +
            TraiteSt(que_MagasinVILLE.AsString) + ';' +
            TraiteSt(que_MagasinTel.AsString) + ';' +
            TraiteSt(que_MagasinFax.AsString) + ';' +
            TraiteSt(que_MagasinRC.AsString) + ';' +
            TraiteSt(que_MagasinComent.AsString) + ';' +
            TraiteSt(que_MagasinCDADH.AsString));
         Que_Magasin.next;
      end;
      Que_Magasin.close;
      tsl.add('Num;%FINI%;LibCourt;RS;ADR;CP;VILLE;Tel;Fax;RC;Coment;CDADH');
      tsl.savetofile('Magasin.TXT');

      tsl.clear;
      tsl.add('Num;Rayon;Fam;SF;rv;fv;sv');
      Caption := 'Nomenclature';
      Repaint;
      Log.add('Importation de la nomenclature');
      Que_Nk.Open;
      Que_Nk.First;
      while not Que_Nk.Eof do
      begin
         S := cmplgauche(que_NKR.AsString, 2) +
            cmplgauche(que_NKF.AsString, 2) +
            cmplgauche(que_NKS.AsString, 2);
         LesNomenclatures.Add(S);
         Ray.Add(que_NKRAY_ID.AsString + '/' + que_NKFAM_ID.AsString + '/' + que_NKSFAM_ID.AsString +
            ';' + S);
            {
            Fam.Add(que_NKFAM_ID.AsString + ';' + cmplgauche(que_NKF.AsString, 2));
            SFF.Add(que_NKSFAM_ID.AsString + ';' + cmplgauche(que_NKS.AsString, 2));
            }
         tsl.add(TraiteSt(S) + ';' +
            TraiteSt(que_NKRayon.AsString) + ';' +
            TraiteSt(que_NKFam.AsString) + ';' +
            TraiteSt(que_NKSF.AsString) + ';1;1;1');
         Que_Nk.next;
      end;
      Que_Nk.close;
      Pass := tsl[0];
      tsl.delete(0);
      tsl.Sort;
      tsl.insert(0, Pass);
      tsl.add('%FINI%;Rayon;Fam;SF;rv;fv;sv');
      tsl.savetofile('NK.Txt');

      Caption := 'Fournisseur';
      Repaint;
      Log.add('Importation des fournisseurs');
      tsl.clear;
      tsl.add('Num;RS;Adr;Cp;Ville;Tel;Fax;NoCli;Corres;Remise');
      que_Fournisseur.open;
      que_Fournisseur.first;
      I := 1;
      MemD_Fourn.Close; MemD_Fourn.Open;
      while not que_Fournisseur.eof do
      begin
         MemD_Fourn.Append;
         MemD_FournFOU_ID.AsString := que_FournisseurNum.AsString;
         MemD_FournNum.AsInteger := I; Inc(i);
         MemD_Fourn.Post;
         if CB_VELO.checked then
            tsl.add(TraiteSt(MemD_FournNum.AsString) + ';' +
               '[AS]-' + TraiteSt(que_FournisseurRS.AsString) + ';' +
               TraiteSt(que_FournisseurAdr.AsString) + ';' +
               TraiteSt(que_FournisseurCP.AsString) + ';' +
               TraiteSt(que_FournisseurVille.AsString) + ';' +
               TraiteSt(que_FournisseurTel.AsString) + ';' +
               TraiteSt(que_FournisseurFax.AsString) + ';' +
               TraiteSt(que_FournisseurNoCli.AsString) + ';' +
               TraiteSt(que_FournisseurCorres.AsString) + ';' +
               TraiteSt(que_FournisseurRemise.AsString))
         else
            tsl.add(TraiteSt(MemD_FournNum.AsString) + ';' +
               TraiteSt(que_FournisseurRS.AsString) + ';' +
               TraiteSt(que_FournisseurAdr.AsString) + ';' +
               TraiteSt(que_FournisseurCP.AsString) + ';' +
               TraiteSt(que_FournisseurVille.AsString) + ';' +
               TraiteSt(que_FournisseurTel.AsString) + ';' +
               TraiteSt(que_FournisseurFax.AsString) + ';' +
               TraiteSt(que_FournisseurNoCli.AsString) + ';' +
               TraiteSt(que_FournisseurCorres.AsString) + ';' +
               TraiteSt(que_FournisseurRemise.AsString));
         que_Fournisseur.next;
      end;
      que_Fournisseur.close;
      tsl.add('%FINI%;RS;Adr;Cp;Ville;Tel;Fax;NoCli;Corres;Remise');
      tsl.savetofile('Fourn.txt');

      Caption := 'Articles';
      Repaint;
      Log.add('Importation des articles');
      tsl.clear;
      tsl.add('Code;Chrono;Desi;Descript;GT;DtCrea;TxDep;DtDep;LibDep;Fourn;ReFourn;Archi;Critere;TVA;Secteur;' +
         'Genre;Fidel;CC1;CC2;CC3;CC4;CC5;CC6;CC7;CC8;CC9;CC10;CC11;CC12;CC13;CC14;CC15;CC16;' +
         'CC17;CC18;CC19;CC20;CL1;CL2;CL3;CL4;CL5;CL6;CL7;CL8;CL9;CL10;CL11;CL12;CL13;CL14;CL15;CL16;' +
         'CL17;CL18;CL19;CL20;Peudo;Crit3;Crit4;Crit5');
      Que_Article.Open;
      MemD_ARTICLE.Close;
      MemD_ARTICLE.Open;
      chrono := 1001;
      while not Que_Article.Eof do
      begin
            // Cyprien
            {
            IF (que_ArticleStk.AsFloat > 0) OR
                (trim(que_ArticleCritere.AsString) = '2003/04HIVER') THEN
            }
         begin
            if trouve_gt(que_ArticleGT.AsString, true) then
            begin
               Article_Ajoute(que_ArticleRAY_ID.AsString, que_ArticleFAM_ID.AsString, que_ArticleSFAM_ID.AsString, que_ArticleCode.AsString);
               Trouve_fou(que_ArticleFourn.AsString);
               S := Code_Article(que_ArticleCode.AsString);
               if LesNomenclatures.IndexOf(Copy(S, 1, 6)) < 0 then
               begin
                  Log.add('Création de la nomenclature ' + Copy(S, 1, 6) + ' ' +
                     que_ArticleRAY_ID.AsString + ' ' + que_ArticleFAM_ID.AsString + ' ' + que_ArticleSFAM_ID.AsString);
                  ttsl := TStringList.Create;
                  try
                     ttsl.LoadFromfile('NK.Txt');
                     Pass := ttsl[0];
                     ttsl.delete(0);
                     ttsl.Delete(ttsl.Count - 1); //%FINI%;Rayon;Fam;SF;rv;fv;sv
                     S1 := Copy(S, 1, 6);
                     LesNomenclatures.Add(S1);
                     ttsl.add(TraiteSt(S1) + ';' +
                        TraiteSt(que_ArticleRay_libelle.AsString) + ';' +
                        TraiteSt(que_Articlefam_libelle.AsString) + ';' +
                        TraiteSt(que_ArticleSfam_libelle.AsString) + ';1;1;1');
                     ttsl.Sort;
                     ttsl.insert(0, Pass);
                     ttsl.add('%FINI%;Rayon;Fam;SF;rv;fv;sv');
                     ttsl.savetofile('NK.Txt');
                  finally
                     ttsl.free;
                  end;
               end;
               if s <> '' then
               begin
                  tsl.add(TraiteSt(S) + ';' +
                     '0-' + inttostr(chrono) + ';' +
                     TraiteSt(que_ArticleDesi.AsString) + ';' +
                     TraiteSt(que_ArticleDescrip.AsString) + ';' +
                     TraiteSt(MemD_GTNum.AsString) + ';' +
                     TraiteSt(formatdateTime('DD/MM/YY', que_ArticleDtCrea.AsDateTime)) + ';' +
                     TraiteSt(que_ArticleTxDep.AsString) + ';' +
                     TraiteSt(trim(que_ArticleDtDep.AsString)) + ';' +
                     TraiteSt(que_ArticleLibDep.AsString) + ';' +
                     TraiteSt(MemD_FournNum.AsString) + ';' +
                     TraiteSt(que_ArticleRefFourn.AsString) + ';' +
                     TraiteSt(que_ArticleArchi.AsString) + ';' +
                     TraiteSt(que_ArticleCritere.AsString) + ';' +
                     TraiteSt(que_ArticleTVA.AsString) + ';' +
                     TraiteSt(que_ArticleSecteur.AsString) + ';' +
                     TraiteSt(que_ArticleGenre.AsString) + ';' +
                     TraiteSt(que_ArticleFidel.AsString) + ';' +
                     TraiteSt(que_ArticleCC1.AsString) + ';;;;;;;;;;;;;;;;;;;;' +
                     TraiteSt(que_ArticleCL1.AsString) + ';;;;;;;;;;;;;;;;;;;;' +
                     TraiteSt(que_ArticlePseudo.AsString) + ';' +
                     TraiteSt(que_ArticleCrit3.AsString) + ';' +
                     TraiteSt(que_ArticleCrit4.AsString) + ';' +
                     TraiteSt(que_ArticleCrit5.AsString));
                  inc(chrono);
               end;
            end
            else
            begin
               Log.add('Article ' + que_ArticleCode.AsString + ' ' + que_ArticleDescrip.AsString + ' n''à pas de grille de taille ' + que_ArticleGT.AsString);
            end;
            {
            END
            ELSE
            BEGIN
                ArtSup.Add(que_ArticleCode.AsString);
            }
         end;
         Que_Article.next;
      end;
      Que_Article.close;
      tsl.add('%FINI%;Chrono;Desi;Descrip;GT;DtCrea;TxDep;DtDep;LibDep;Fourn;ReFourn;Archi;Critere;TVA;Secteur;Genre;' +
         'Fidel;CC1;CC2;CC3;CC4;CC5;CC6;CC7;CC8;CC9;CC10;CC11;CC12;CC13;CC14;CC15;CC16;CC17;CC18;CC19;CC20;CL1;CL2;' +
         'CL3;CL4;CL5;CL6;CL7;CL8;CL9;CL10;CL11;CL12;CL13;CL14;CL15;CL16;CL17;CL18;CL19;CL20;Peudo;Crit3;Crit4;Crit5');
      tsl.savetofile('Article.txt');

      Caption := 'Tarifs';
      Repaint;
      Log.add('Importation des tarifs');
      tsl.clear;
      tsl.Add('Code;Tail;Catal;Achat;Vente;vente2;vente3;Fourn');
      que_Tarif.Open;
      tsl_tarif := tstringList.create;
      try
         while not (que_Tarif.Eof) do
         begin
            if ArtSup.IndexOf(que_TarifPROD_ID.AsString) = -1 then
            begin
               S := Code_Article(que_TarifPROD_ID.AsString);
               if S <> '' then
               begin
                  Trouve_fou(que_TarifFour_Id.AsString);
                  if tsl_tarif.indexof(s) = -1 then
                  begin
                     tsl_tarif.add(S);
                     tsl.add(TraiteSt(S) + ';00;' +
                        TraiteSt(que_TarifProd_PA.AsString) + ';' +
                        TraiteSt(que_TarifART_PA.AsString) + ';' +
                        TraiteSt(que_TarifART_PV1.AsString) + ';' +
                        TraiteSt(que_TarifCAR_PV2.AsString) + ';' +
                        TraiteSt(que_TarifCAR_PV3.AsString) + ';' +
                        TraiteSt(MemD_FournNum.AsString));
                  end;
                  tsl.add(TraiteSt(S) + ';' +
                     TraiteSt(traitetaille(que_TarifTail_ID.AsInteger, que_TarifTail_Position.AsString)) + ';' +
                     TraiteSt(que_TarifProd_PA.AsString) + ';' +
                     TraiteSt(que_TarifART_PA.AsString) + ';' +
                     TraiteSt(que_TarifART_PV1.AsString) + ';' +
                     TraiteSt(que_TarifCAR_PV2.AsString) + ';' +
                     TraiteSt(que_TarifCAR_PV3.AsString) + ';' +
                     TraiteSt(MemD_FournNum.AsString));
               end;
            end;
            que_Tarif.Next;
         end;
         que_Tarif.Close;
         tsl.Add('%FINI%;Tail;Achat;Vente;vente2;vente3;Fourn');
         tsl.SavetoFile('Tarifs.Txt');
      finally
         tsl_tarif.free;
      end;

      Caption := 'Code Barre';
      Repaint;
      Log.add('Importation des codes barres');
      tsl.clear;
      tsl.Add('Article;Tail;Coul;CB');
      que_CB.Open;
      que_CB.First;
      while not que_CB.eof do
      begin
         if ArtSup.IndexOf(que_CBPROD_ID.AsString) = -1 then
         begin
            S := Code_Article(que_CBPROD_ID.AsString);
            if s <> '' then
            begin
               tsl.add(TraiteSt(S) + ';' +
                  TraiteSt(traitetaille(que_CBTAIL_ID.AsInteger, que_CBTAIL_POSITION.AsString)) + ';' +
                  TraiteSt(que_CBCOU.AsString) + ';' +
                  TraiteSt(que_CBCB_CODEBARRE.AsString));
            end;
         end;
         que_CB.next;
      end;
      que_CB.close;
      tsl.Add('%FINI%;Tail;Coul;CB');
      tsl.SavetoFile('CB.Txt');

      tsl.clear;
      tsl.add('Code;Mag;Tail;Coul;Tes;Qte;Pxb;Pxn;tva;SAAMM;Fourn');

      Caption := 'Stock Initial';
      Repaint;
      Log.add('Importation du stock initial');
      que_StkInitial.Open;
      que_StkInitial.first;
      while not que_StkInitial.eof do
      begin
         if ArtSup.IndexOf(que_StkInitialProd_Id.AsString) = -1 then
         begin
            S := Code_Article(que_StkInitialProd_Id.AsString);
            if s <> '' then
            begin
               if que_StkInitialHist_QteInitiale.AsFloat > 0 then
               begin
                  if Abs(que_StkInitialPAMP.AsFloat) > 0.01 then
                     LePrix := que_StkInitialPAMP.AsString
                  else
                     LePrix := que_StkInitialPAU.AsString;
                        // Entrée
                  Trouve_fou(que_StkInitialFOUR_ID.AsString);
                  Qry_Rech.Close;
                  Qry_Rech.ParamByName('PRDID').AsInteger := Que_HistoProd_Id.AsInteger;
                  Qry_Rech.ParamByName('DATEFIN').AsDateTime := que_StkInitialLad.AsDateTime;
                  Qry_Rech.Open;
                  if (Qry_RechARTRE_PA.IsNull) or
                     (Qry_RechARTRE_PA.AsFloat = 0) then
                  begin
                     Qry_Rech2.Close;
                     Qry_Rech2.ParamByName('PRDID').AsInteger := Que_HistoProd_Id.AsInteger;
                     Qry_Rech2.ParamByName('DATEFIN').AsDateTime := que_StkInitialLad.AsDateTime;
                     Qry_Rech2.Open;
                     if not ((Qry_Rech2ARTRE_PA.IsNull) or
                        (Qry_Rech2ARTRE_PA.AsFloat = 0)) then
                     begin
                        LePrix := Qry_Rech2ARTRE_PA.AsString;
                     end;
                     Qry_Rech2.Close;
                  end
                  else
                     LePrix := Qry_RechARTRE_PA.AsString;
                  Qry_Rech.Close;

                  tsl.add(TraiteSt(S) + ';' +
                     TraiteSt(Inttostr(que_StkInitialMag_Id.AsInteger + Increment)) + ';' +
                     TraiteSt(traitetaille(que_StkInitialTAIL_ID.AsInteger, que_StkInitialTAIL_POSITION.AsString)) + ';' +
                     TraiteSt(que_StkInitialCoul.AsString) + ';50;' +
                     TraiteSt(que_StkInitialQTE.AsString) + ';' +
                     TraiteSt(LePrix) + ';' +
                     TraiteSt(LePrix) + ';' +
                     TraiteSt(que_StkInitialTVA.AsString) + ';' +
                     TraiteDate(que_StkInitialLad.AsDateTime) + ';' +
                     TraiteSt(MemD_FournNum.AsString));
               end
               else
               begin
                  Trouve_fou(que_StkInitialFOUR_ID.AsString);
                  tsl.add(TraiteSt(S) + ';' +
                     TraiteSt(Inttostr(que_StkInitialMag_Id.AsInteger + Increment)) + ';' +
                     TraiteSt(traitetaille(que_StkInitialTAIL_ID.AsInteger, que_StkInitialTAIL_POSITION.AsString)) + ';' +
                     TraiteSt(que_StkInitialCoul.AsString) + ';01;' +
                     TraiteSt(que_StkInitialQTE.AsString) + ';' +
                     TraiteSt(que_StkInitialPVGL.AsString) + ';' +
                     TraiteSt(que_StkInitialPVGL.AsString) + ';' +
                     TraiteSt(que_StkInitialTVA.AsString) + ';' +
                     TraiteDate(que_StkInitialLad.AsDateTime) + ';' +
                     TraiteSt(MemD_FournNum.AsString));
               end;
            end;
         end;
         que_StkInitial.next;
      end;
      que_StkInitial.close;

      Caption := 'Historique';
      Repaint;
      Log.add('Importation historique de stock');
      Que_Histo.Open;
      Que_Histo.First;
      while not Que_Histo.eof do
      begin
         if ArtSup.IndexOf(Que_HistoProd_Id.AsString) = -1 then
         begin
            S := Code_Article(Que_HistoProd_Id.AsString);
            if s <> '' then
            begin
               case que_HistoTes.AsInteger of
                  50: // Livraison
                     begin
                        if Abs(que_HistoPAMP.AsFloat) > 0.01 then
                           LePrix := TraiteSt(que_HistoPAMP.AsString)
                        else
                           LePrix := TraiteSt(Que_HistoPAU.AsString);
                                // Recherche du bon PUMP
                        Trouve_fou(Que_HistoFOUR_ID.AsString);
                        Qry_Rech.Close;
                        Qry_Rech.ParamByName('PRDID').AsInteger := Que_HistoProd_Id.AsInteger;
                        Qry_Rech.ParamByName('DATEFIN').AsDateTime := Que_HistoLad.AsDateTime;
                        Qry_Rech.Open;
                        if (Qry_RechARTRE_PA.IsNull) or
                           (Qry_RechARTRE_PA.AsFloat = 0) then
                        begin
                           Qry_Rech2.Close;
                           Qry_Rech2.ParamByName('PRDID').AsInteger := Que_HistoProd_Id.AsInteger;
                           Qry_Rech2.ParamByName('DATEFIN').AsDateTime := Que_HistoLad.AsDateTime;
                           Qry_Rech2.Open;
                           if not ((Qry_Rech2ARTRE_PA.IsNull) or
                              (Qry_Rech2ARTRE_PA.AsFloat = 0)) then
                           begin
                              LePrix := TraiteSt(Qry_Rech2ARTRE_PA.AsString);
                           end;
                           Qry_Rech2.Close;
                        end
                        else
                           LePrix := TraiteSt(Qry_RechARTRE_PA.AsString);
                        Qry_Rech.Close;

                        tsl.add(TraiteSt(S) + ';' +
                           TraiteSt(Inttostr(Que_HistoMag_Id.AsInteger + Increment)) + ';' +
                           TraiteSt(traitetaille(Que_HistoTAIL_ID.AsInteger, Que_HistoTAIL_POSITION.AsString)) + ';' +
                           TraiteSt(Que_HistoCoul.AsString) + ';50;' +
                           TraiteSt(Que_HistoQTE.AsString) + ';' +
                           LePrix + ';' +
                           LePrix + ';' +
                           TraiteSt(Que_HistoTVA.AsString) + ';' +
                           TraiteDate(Que_HistoLad.AsDateTime) + ';' +
                           TraiteSt(MemD_FournNum.AsString));
                     end;
                  27: // Transfert inter mag
                     begin
                        if que_HistoHist_QteRecept.AsFloat > 0 then
                        begin
                           Trouve_fou(Que_HistoFOUR_ID.AsString);
                           tsl.add(TraiteSt(S) + ';' +
                              TraiteSt(Inttostr(Que_HistoMag_Id.AsInteger + Increment)) + ';' +
                              TraiteSt(traitetaille(Que_HistoTAIL_ID.AsInteger, Que_HistoTAIL_POSITION.AsString)) + ';' +
                              TraiteSt(Que_HistoCoul.AsString) + ';64;' +
                              TraiteSt(Que_HistoQTE.AsString) + ';' +
                              TraiteSt(Que_HistoPAU.AsString) + ';' +
                              TraiteSt(Que_HistoPAU.AsString) + ';' +
                              TraiteSt(Que_HistoTVA.AsString) + ';' +
                              TraiteDate(Que_HistoLad.AsDateTime) + ';' +
                              TraiteSt(MemD_FournNum.AsString));
                        end
                        else
                        begin
                           Trouve_fou(Que_HistoFOUR_ID.AsString);
                           tsl.add(TraiteSt(S) + ';' +
                              TraiteSt(Inttostr(Que_HistoMag_Id.AsInteger + Increment)) + ';' +
                              TraiteSt(traitetaille(Que_HistoTAIL_ID.AsInteger, Que_HistoTAIL_POSITION.AsString)) + ';' +
                              TraiteSt(Que_HistoCoul.AsString) + ';27;' +
                              TraiteSt(Que_HistoQTE.AsString) + ';' +
                              TraiteSt(Que_HistoPAU.AsString) + ';' +
                              TraiteSt(Que_HistoPAU.AsString) + ';' +
                              TraiteSt(Que_HistoTVA.AsString) + ';' +
                              TraiteDate(Que_HistoLad.AsDateTime) + ';' +
                              TraiteSt(MemD_FournNum.AsString));
                        end;
                     end;
                  21: // Conso Div
                     begin
                        Trouve_fou(Que_HistoFOUR_ID.AsString);
                        tsl.add(TraiteSt(S) + ';' +
                           TraiteSt(Inttostr(Que_HistoMag_Id.AsInteger + Increment)) + ';' +
                           TraiteSt(traitetaille(Que_HistoTAIL_ID.AsInteger, Que_HistoTAIL_POSITION.AsString)) + ';' +
                           TraiteSt(Que_HistoCoul.AsString) + ';21;' +
                           TraiteSt(Que_HistoQTE.AsString) + ';' +
                           TraiteSt(Que_HistoPVGL.AsString) + ';' +
                           TraiteSt(Que_HistoPVGL.AsString) + ';' +
                           TraiteSt(Que_HistoTVA.AsString) + ';' +
                           TraiteDate(Que_HistoLad.AsDateTime) + ';' +
                           TraiteSt(MemD_FournNum.AsString));
                     end;
                  1: // Vente
                     begin
                        Trouve_fou(Que_HistoFOUR_ID.AsString);
                        tsl.add(TraiteSt(S) + ';' +
                           TraiteSt(Inttostr(Que_HistoMag_Id.AsInteger + Increment)) + ';' +
                           TraiteSt(traitetaille(Que_HistoTAIL_ID.AsInteger, Que_HistoTAIL_POSITION.AsString)) + ';' +
                           TraiteSt(Que_HistoCoul.AsString) + ';01;' +
                           TraiteSt(Que_HistoQTE.AsString) + ';' +
                           TraiteSt(Que_HistoPVGL.AsString) + ';' +
                           TraiteSt(Que_HistoPVGL.AsString) + ';' +
                           TraiteSt(Que_HistoTVA.AsString) + ';' +
                           TraiteDate(Que_HistoLad.AsDateTime) + ';' +
                           TraiteSt(MemD_FournNum.AsString));
                     end;
               end;
            end;
         end;
         Que_Histo.next;
      end;
      Que_Histo.close;

      Caption := 'Régul';
      Repaint;
      Log.add('Importation régularisation du stock');

      que_StkFinal.Open;
      que_StkFinal.first;
      while not que_StkFinal.eof do
      begin
         if ArtSup.IndexOf(que_StkFinalProd_Id.AsString) = -1 then
         begin
            S := Code_Article(que_StkFinalProd_Id.AsString);
            if s <> '' then
            begin
               Trouve_fou(que_StkFinalFOUR_ID.AsString);
               tsl.add(TraiteSt(S) + ';' +
                  TraiteSt(Inttostr(que_StkFinalMag_Id.AsInteger + Increment)) + ';' +
                  TraiteSt(traitetaille(que_StkFinalTAIL_ID.AsInteger, que_StkFinalTAIL_POSITION.AsString)) + ';' +
                  TraiteSt(que_StkFinalCoul.AsString) + ';26;' +
                  TraiteSt(que_StkFinalDemarque.AsString) + ';' +
                  TraiteSt('0') + ';' +
                  TraiteSt('0') + ';' +
                  TraiteSt(que_StkFinalTVA.AsString) + ';' +
                  TraiteDate(Date) + ';' +
                  TraiteSt(MemD_FournNum.AsString));
            end;
         end;
         que_StkFinal.next;
      end;
      que_StkFinal.close;

      Caption := 'Régul des articles sans mouvement';
      Repaint;
      Log.add('Importation régularisation du stock sans mouvement');

      que_RecupStk.Open;
      que_RecupStk.first;
      while not que_RecupStk.eof do
      begin
         if ArtSup.IndexOf(que_RecupStkProd_Id.AsString) = -1 then
         begin
            S := Code_Article(que_RecupStkProd_Id.AsString);
            if s <> '' then
            begin
               Trouve_fou(que_RecupStkFOUR_ID.AsString);
               tsl.add(TraiteSt(S) + ';' +
                  TraiteSt(Inttostr(que_RecupStkMag_Id.AsInteger + Increment)) + ';' +
                  TraiteSt(traitetaille(que_RecupStkTAIL_ID.AsInteger, que_RecupStkTAIL_POSITION.AsString)) + ';' +
                  TraiteSt(que_RecupStkCoul.AsString) + ';26;' +
                  TraiteSt(que_RecupStkDemarque.AsString) + ';' +
                  TraiteSt('0') + ';' +
                  TraiteSt('0') + ';' +
                  TraiteSt(que_RecupStkTVA.AsString) + ';' +
                  TraiteDate(Date) + ';' +
                  TraiteSt(MemD_FournNum.AsString));
            end;
         end;
         que_RecupStk.next;
      end;
      que_RecupStk.close;

      tsl.add('%FINI%;Mag;Tail;Coul;Tes;Qte;Pxb;Pxn;tva;SAAMM;fourn');
      tsl.SavetoFile('StockTot.txt');

      Caption := 'Commandes';
      Repaint;
      Log.add('Importation des commandes');

      tsl.Clear;
      tsl.add('Code;tail;coul;mag;NumCde;Qte;PxCatal;r1;r2;r3;pxnn;tva;DtLiv;DtLim;PxVente;C_Fourn;C_Rbp;C_Date;C_Dliv;C_offset;C_Coment');
      que_Commande.Open;
      que_Commande.First;
      while not que_Commande.Eof do
      begin
         if ArtSup.IndexOf(que_CommandeProd_Id.AsString) = -1 then
         begin
            S := Code_Article(que_CommandeProd_Id.AsString);
            if s <> '' then
            begin
               Trouve_fou(que_CommandeFOUR_ID.AsString);
               tsl.add(TraiteSt(S) + ';' +
                  TraiteSt(traitetaille(que_CommandeTAIL_ID.AsInteger, que_CommandeTAIL_POSITION.AsString)) + ';' +
                  TraiteSt(que_CommandeCOUL.AsString) + ';' +
                  TraiteSt(que_CommandeMAG_LIV_ID.AsString) + ';' +
                  TraiteSt(que_CommandeCMD_REFERENCE.AsString) + ';' +
                  TraiteSt(que_CommandeQte.AsString) + ';' +
                  TraiteSt(que_CommandeARTCO_PA.AsString) + ';' +
                  TraiteSt(que_CommandeR1.AsString) + ';' +
                  TraiteSt(que_CommandeR2.AsString) + ';' +
                  TraiteSt(que_CommandeR3.AsString) + ';' +
                  TraiteStNb(que_CommandePxNN.AsString) + ';' +
                  TraiteSt(que_CommandeTVA.AsString) + ';' +
                  TraiteSt(FormatDateTime('DD/MM/YY', que_CommandeDtLiv.AsDatetime)) + ';' +
                  TraiteSt(que_CommandeDtLim.AsString) + ';' +
                  TraiteStNb(que_CommandeARTCO_PV.AsString) + ';' +
                  TraiteSt(MemD_FournNum.AsString) + ';' +
                  TraiteSt(que_CommandeC_RBP.AsString) + ';' +
                  TraiteSt(FormatDateTime('DD/MM/YY', que_CommandeC_Date.AsDateTime)) + ';' +
                  TraiteSt(FormatDateTime('DD/MM/YY', que_CommandeC_Dliv.AsDateTime)) + ';' +
                  TraiteSt(que_CommandeC_Offset.AsString) + ';' +
                  TraiteSt(que_CommandeCMD_COMMENT.AsString));
            end;
         end;
         que_Commande.Next;
      end;
      que_Commande.Close;
      tsl.add('%FINI%;tail;coul;mag;NumCde;Qte;PxCatal;r1;r2;r3;pxnn;tva;DtLiv;DtLim;PxVente;C_Fourn;C_Rbp;C_Date;C_Dliv;C_offset;C_coment');
      tsl.SavetoFile('Commande.txt');

      Tsl.Clear;
      tsl.add('nom;prenom;adresse;cp;ville;politesse;dpp;ddp;obs;telp;telt;CF;Sexe;JAnni;EnCours;categ;Crit1;Crit2;Crit3;Crit4;Crit5;pays;Ta;Numero;Garant');
      que_Client.Open;
      que_Client.First;
      MemD_Client.Close; MemD_Client.Open;
      I := 1000;
      while not que_Client.eof do
      begin
         if Copy(trim(uppercase(que_ClientNom.AsString)), 1, 3) <> 'ZZZ' then
         begin
            MemD_Client.insert;
            MemD_ClientCLT_ID.AsString := que_ClientNumero.AsString;
            MemD_ClientNum.AsInteger := i;
            Inc(i);
            MemD_Client.Post;
            tsl.add(TraiteSt(que_ClientNom.AsString) + ';' +
               TraiteSt(que_ClientPrenom.AsString) + ';' +
               TraiteSt(que_ClientAdresse.AsString) + ';' +
               TraiteSt(que_ClientCP.AsString) + ';' +
               TraiteSt(que_ClientVille.AsString) + ';' +
               TraiteSt(que_ClientPolitesse.AsString) + ';' +
               TraiteSt(FormatDateTime('DD/MM/YY', que_ClientDPP.AsDateTime)) + ';' +
               TraiteSt(FormatDateTime('DD/MM/YY', que_ClientDdp.AsDateTime)) + ';' +
               TraiteSt(que_ClientObservation.AsString) + ';' +
               TraiteSt(que_ClientTelt.AsString) + ';' +
               TraiteSt(que_ClientTelp.AsString) + ';' +
               TraiteSt(que_ClientCF.AsString) + ';' +
               TraiteSt(que_ClientSexe.AsString) + ';' +
               TraiteSt(FormatDateTime('DD/MM/YY', que_ClientJanni.AsDateTime)) + ';' +
               TraiteSt(que_ClientCLT_PLAFONDENCOURS.AsString) + ';' +
               TraiteSt(que_ClientCateg.AsString) + ';' +
               TraiteSt(que_ClientCrit1.AsString) + ';' +
               TraiteSt(que_ClientCrit2.AsString) + ';' +
               TraiteSt(que_ClientCrit3.AsString) + ';' +
               TraiteSt(que_ClientCrit4.AsString) + ';' +
               TraiteSt(que_ClientCrit5.AsString) + ';' +
               TraiteSt(que_ClientPays.AsString) + ';' +
               TraiteSt(que_ClientTA.AsString) + ';' +
               TraiteSt(MemD_ClientNum.AsString) + ';' +
               TraiteSt(que_ClientGarant.AsString));
         end;
         que_Client.next;
      end;
      que_Client.close;
      tsl.add('%FINI%;prenom;adresse;cp;ville;politesse;dpp;ddp;obs;telp;telt;CF;Sexe;JAnni;EnCours;categ;Crit1;Crit2;Crit3;Crit4;Crit5;pays;Ta;numero;Garant');
      tsl.SavetoFile('Clients.txt');

      Tsl.Clear;
      tsl.add('Code;Mag;Lib;Date;Debit;Credit;DtReg');
      tsl.add('%FINI%;Mag;Lib;Date;Debit;Credit;DtReg');
      tsl.SavetoFile('cptcli.txt');

      Tsl.Clear;
      tsl.add('Code;Lib;Date;Credit');
      tsl.add('%FINI%;Lib;Date;Credit');
      tsl.SavetoFile('Fidelite.txt');
   finally
      Log.add('Importation terminée');
      Log.savetofile('LOG.txt');
      LesNomenclatures.free;
      ArtSup.free;
      tsl.free;
      Ray.free;
      Caption := 'Import terminé';
      Repaint;
   end;
   // marquage de l'id en cours
   ini := tinifile.create(IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) + 'IMPORT_HUSKY.INI');

   DataGinkoia.DatabaseName := ini.ReadString('DATABASE', 'PATH', '');
   DataGinkoia.Open ;
   tranGinkoia.Active := true ;
   sql1.ExecQuery;
   sql2.ExecQuery;
   if tranGinkoia.InTransaction then
      tranGinkoia.commit;
   DataGinkoia.close;
   // Si option pour ne pas lancer la transpo HUSKY s'arrêter
   if (Fichier.Checked) then
          ShowMessage('Génération de fichier terminée!')
   else Winexec('C:\IP_HUSKY\IMPORT_HUSKY.EXE AUTO NON C:\IP_HUSKY\SUITEAS.EXE', 0);
   close;
end;

function TFrm_ASInfort.TraiteStNb(S: string): string;
begin
   result := TraiteSt(S);
   if result = '' then result := '0';
end;

end.

