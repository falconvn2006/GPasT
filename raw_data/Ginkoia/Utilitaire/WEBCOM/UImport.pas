unit UImport;

interface

uses
   Upost,
   FileUtil,
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   ApFolderDlg, StdCtrls, Buttons, Db, dxmdaset, ComCtrls, ZipMstr;

type
   TForm1 = class(TForm)
      ed_Repcat: TEdit;
      SpeedButton1: TSpeedButton;
      Button1: TButton;
      ORep: TApFolderDialog;
      memfedas: TdxMemData;
      memfedasFED_CAT: TStringField;
      memfedasFED_CATLIB: TStringField;
      memfedasFED_ACT: TStringField;
      memfedasFED_ACTLIB: TStringField;
      memfedasFED_GRP: TStringField;
      memfedasFED_GRPLIB: TStringField;
      memfedasFED_SSF: TStringField;
      memfedasFED_SSFLIB: TStringField;
      memfedasFED_SAISIE: TStringField;
      memfedasFED_IDSAISIE: TStringField;
      memfedasFED_MODIF: TStringField;
      memfedasFED_IDMODIF: TStringField;
      Pb: TProgressBar;
      catalogue: TdxMemData;
      catalogueCAT_ID: TStringField;
      catalogueCAT_CODE: TStringField;
      catalogueCAT_FOUID: TStringField;
      catalogueCAT_ANNEE: TStringField;
      catalogueCAT_MOIS: TStringField;
      catalogueCAT_LIBELLE: TStringField;
      catalogueCAT_NOM: TStringField;
      catalogueCAT_STATUT: TStringField;
      catalogueCAT_TIMESTAMP: TStringField;
      catalogueCAT_DATESAISIE: TStringField;
      catalogueCAT_IDSAISIE: TStringField;
      catalogueCAT_DATEMODIF: TStringField;
      catalogueCAT_IDMODIF: TStringField;
      catalogueCAT_VALID: TStringField;
      memfedasFED_ID: TStringField;
      memfedasFED_CODE: TStringField;
      Lab_etat: TLabel;
      fournisseurs: TdxMemData;
      fournisseursFOU_ID: TStringField;
      fournisseursFOU_NUM: TStringField;
      fournisseursFOU_NOM: TStringField;
      fedas: TdxMemData;
      fedasFED_CAT: TStringField;
      fedasFED_CATLIB: TStringField;
      fedasFED_ACT: TStringField;
      fedasFED_ACTLIB: TStringField;
      fedasFED_GRP: TStringField;
      fedasFED_GRPLIB: TStringField;
      fedasFED_SSF: TStringField;
      fedasFED_SSFLIB: TStringField;
      fedasFED_SAISIE: TStringField;
      fedasFED_IDSAISIE: TStringField;
      fedasFED_MODIF: TStringField;
      fedasFED_IDMODIF: TStringField;
      fedasFED_ID: TStringField;
      fedasFED_CODE: TStringField;
      grille_lig: TdxMemData;
      grille_ligTAL_ID: TStringField;
      grille_ligTAL_RANG: TStringField;
      grille_ligTAL_TAEID: TStringField;
      grille_ligTAL_LIBELLE: TStringField;
      cat_lig: TdxMemData;
      cat_ligCTL_ID: TStringField;
      cat_ligCTL_ARTCHRONO: TStringField;
      Zip: TZipMaster;
      Label1: TLabel;
      Ed_Ref: TEdit;
      Chercher: TButton;
      procedure SpeedButton1Click(Sender: TObject);
      procedure Button1Click(Sender: TObject);
      procedure ChercherClick(Sender: TObject);
   private
      procedure ImportFedas(fich: string);
      procedure Importcatalogue(cat: string);
      procedure Recherche(cat: string);
      function suiv(var s: string): string;
      function Cherche(mem: TdxMemData; chp, value: string; chp2: string = ''; value2: string = ''): boolean;
    { Déclarations privées }
   public
    { Déclarations publiques }
   end;

var
   Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
   if orep.Execute then
      ed_Repcat.text := IncludeTrailingBackslash(orep.FolderName);
end;

procedure TForm1.ImportFedas(fich: string);
var
   result: tstringList;
   tsl: tstringList;
   tc: Tconnexion;
   fedid: integer;
begin
   exit;
   lab_etat.caption := 'Importation FEDAS'; lab_etat.Update;
   pb.Position := 0;
   tsl := tstringList.create;
   tsl.loadfromfile(fich);
   tsl.insert(0, 'FED_CAT;FED_CATLIB;FED_ACT;FED_ACTLIB;FED_GRP;FED_GRPLIB;FED_SSF;FED_SSFLIB;FED_SAISIE;FED_IDSAISIE;FED_MODIF;FED_IDMODIF');
   tsl.Savetofile(changefileext(application.exename, '.ttt'));
   tsl.free;
   memfedas.Close;
   memfedas.DelimiterChar := ';';
   memfedas.LoadFromTextFile(changefileext(application.exename, '.ttt'));
   memfedas.Open;
   memfedas.first;
   pb.max := memfedas.RecordCount;
   tc := Tconnexion.create;
   tc.Base := 'ginkoia_db2';
   while not memfedas.eof do
   begin
      pb.Position := pb.Position + 1;
      if not cherche(fedas, 'FED_CODE', memfedasFED_CAT.AsString +
         memfedasFED_ACT.AsString +
         memfedasFED_GRP.AsString +
         memfedasFED_SSF.AsString) then
      begin
         result := tc.Select('select count(*) Nb from fed_inter where fedas = ' +
            QuotedStr(memfedasFED_CAT.AsString +
            memfedasFED_ACT.AsString +
            memfedasFED_GRP.AsString +
            memfedasFED_SSF.AsString));
         if tc.UneValeurEntiere(result, 'Nb') < 1 then
         begin
            tc.ordre('insert into fed_inter(fedas,inter) values (' +
               QuotedStr(memfedasFED_CAT.AsString +
               memfedasFED_ACT.AsString +
               memfedasFED_GRP.AsString +
               memfedasFED_SSF.AsString) + ',' +
               QuotedStr('99999999'));
         end;
         tc.FreeResult(result);
         fedid := tc.insert('insert into fedas (' +
            'FED_CAT,FED_CATLIB,FED_ACT,FED_ACTLIB,FED_GRP,FED_GRPLIB,' +
            'FED_SSF,FED_SSFLIB,FED_SAISIE,FED_IDSAISIE,FED_MODIF,' +
            'FED_IDMODIF,FED_CODE) values (' +
            quotedStr(memfedasFED_CAT.AsString) + ',' +
            quotedStr(memfedasFED_CATLIB.AsString) + ',' +
            quotedStr(memfedasFED_ACT.AsString) + ',' +
            quotedStr(memfedasFED_ACTLIB.AsString) + ',' +
            quotedStr(memfedasFED_GRP.AsString) + ',' +
            quotedStr(memfedasFED_GRPLIB.AsString) + ',' +
            quotedStr(memfedasFED_SSF.AsString) + ',' +
            quotedStr(memfedasFED_SSFLIB.AsString) + ',' +
            quotedStr(memfedasFED_SAISIE.AsString) + ',' +
            quotedStr(memfedasFED_IDSAISIE.AsString) + ',' +
            quotedStr(memfedasFED_MODIF.AsString) + ',' +
            quotedStr(memfedasFED_IDMODIF.AsString) + ',' +
            QuotedStr(memfedasFED_CAT.AsString +
            memfedasFED_ACT.AsString +
            memfedasFED_GRP.AsString +
            memfedasFED_SSF.AsString) +
            ')');
         fedas.append;
         fedasFED_ID.asinteger := fedid;
         fedasFED_CODE.AsString := memfedasFED_CAT.AsString +
            memfedasFED_ACT.AsString +
            memfedasFED_GRP.AsString +
            memfedasFED_SSF.AsString;
         fedas.post;
      end;
      memfedas.next;
   end;
   memfedas.close;
   tc.free;
end;

function TForm1.suiv(var s: string): string;
begin
   if pos(';', s) > 0 then
   begin
      result := copy(s, 1, pos(';', s) - 1);
      delete(s, 1, pos(';', s));
   end
   else
   begin
      result := s;
      s := '';
   end;
end;

function TForm1.Cherche(mem: TdxMemData; chp, value: string; chp2: string = ''; value2: string = ''): boolean;
var
   tf: tfield;
begin
   mem.first;
   tf := mem.FieldByName(chp);
   while not mem.eof do
   begin
      if tf.asstring = value then
      begin
         if chp2 <> '' then
         begin
            if mem.FieldByName(chp2).AsString = value2 then
               break;
         end
         else
            break;
      end;
      mem.next;
   end;
   if chp2 = '' then
      result := tf.asstring = value
   else
      result := (tf.asstring = value) and (mem.FieldByName(chp2).AsString = value2);

end;

type
   tunchrono = class
      ID: string;
      ARTCHRONO,
         SAISIE,
         MODIF: string;
      CATID: string;
      afaire: boolean;
      constructor create;
   end;

procedure TForm1.Importcatalogue(cat: string);
var
   tsl: tstringlist;
   s1,
      s: string;
   Numfou: string;
   NomFou: string;
   CAT_ANNEE,
      CAT_MOIS,
      CAT_CODE: string;
   CAT_LIBELLE,
      CAT_NOM,
      CAT_STATUT,
      CAT_TIMESTAMP,
      CAT_DATESAISIE,
      CAT_IDSAISIE,
      CAT_DATEMODIF,
      CAT_IDMODIF,
      CAT_VALID: string;
   tc: Tconnexion;
   fouid: Integer;
   catid: integer;
   lig: integer;
   ent: string;
   qry: string;
   lerep: string;
   chrono: string;
   i: integer;

   res: tstringlist;
   ligexist: tstringlist;

   ddeb, dmod: string;
   taille: string;
   tatrang: string;
   S2: string;
   Pass: tstringlist;
   jour, mois,Lannee:Word;
   annee: string;

begin
   lerep := IncludeTrailingBackslash(extractfilepath(cat));
   cat := extractfilename(cat);
   delete(cat, 1, 7);
   S := cat;
   delete(s, 1, 1);
   delete(s, 1, pos('_', s));
   S := Copy(S, 1, 6);
   // Copy(S,1,4) --> année
   if Strtoint(Copy(S, 1, 4)) < 2006 then exit;
   if Copy(S, 1, 4) = '9999' then
   begin
     // teste pour les annees 99999
//      Tsl := TstringList.create;
//      tsl.loadfromfile(lerep + 'CT0201P' + cat);
//      S := tsl[0];
//      tsl.free;
//      suiv(s);
//      suiv(s);
//      suiv(s);
//      suiv(s);
//      suiv(s);
//      s := suiv(s);
//      while (length(s) > 0) and not (s[length(s)] in ['0'..'9']) do
//         delete(s, length(s), 1);
//      i := Length(s);
//      if i > 0 then
//      begin
//         while s[i] in ['0'..'9', '.'] do
//            dec(i);
//         S := Copy(s, i + 1, 255);
//         if (pos('.', S) = 3) then
//         begin
//         // année . année
//            if Strtoint(Copy(S, 1, 2)) < 6 then exit;
//         end
//         else if Strtoint(Copy(S, 1, 4)) < 2006 then exit;
//      end;
       decodedate(Now,Lannee,mois,jour);
       annee := intTostr(Lannee);
   end
   else
       annee := Copy(S, 1, 4);

   tc := Tconnexion.create;
   tc.Base := 'ginkoia_db2';
   s := cat;
   delete(s, 1, 1);
   delete(s, 1, pos('_', s));
   delete(s, 1, pos('_', s));
   lab_etat.Caption := 'importation ' + changefileext(s, ''); lab_etat.update;
  // entête est CT0201P
   Tsl := TstringList.create;
   tsl.loadfromfile(lerep + 'CT0201P' + cat);
   S := tsl[0];
   Numfou := suiv(s);
   Nomfou := suiv(s);
   CAT_ANNEE := annee;
   suiv(s);
   CAT_MOIS := suiv(s);
   CAT_CODE := suiv(s);

   if not cherche(catalogue, 'CAT_CODE', CAT_CODE, 'CAT_FOUID', NumFou) then
   begin
      // vérification du fournisseur
      if not cherche(fournisseurs, 'FOU_NUM', Numfou) then
      begin
       // création du fourniseur ;
         FouId := tc.insert('insert into fournisseurs (FOU_NUM, FOU_NOM) values (' +
            quotedStr(Numfou) + ',' + quotedStr(NomFou) + ')');
         fournisseurs.Append;
         fournisseursFOU_ID.AsInteger := FouId;
         fournisseursFOU_NUM.AsString := numfou;
         fournisseursFOU_NOM.AsString := Nomfou;
         fournisseurs.post;
      end;
      // création entete catalogue
      CAT_LIBELLE := suiv(s);
      CAT_NOM := suiv(s);
      CAT_STATUT := suiv(s);
      CAT_TIMESTAMP := suiv(s);
      CAT_DATESAISIE := suiv(s);
      CAT_IDSAISIE := suiv(s);
      CAT_DATEMODIF := suiv(s);
      CAT_IDMODIF := suiv(s);
      CAT_VALID := '1';
      catid := tc.insert('insert into catalogue (' +
         'CAT_CODE,CAT_FOUID,CAT_ANNEE,CAT_MOIS,' +
         'CAT_LIBELLE,CAT_NOM,CAT_STATUT,CAT_TIMESTAMP,' +
         'CAT_DATESAISIE,CAT_IDSAISIE,CAT_DATEMODIF,' +
         'CAT_IDMODIF,CAT_VALID) values (' +
         quotedStr(CAT_CODE) + ',' +
         fournisseursFOU_NUM.AsString + ',' +
         quotedStr(CAT_ANNEE) + ',' +
         quotedStr(CAT_MOIS) + ',' +
         quotedStr(CAT_LIBELLE) + ',' +
         quotedStr(CAT_NOM) + ',' +
         quotedStr(CAT_STATUT) + ',' +
         quotedStr(CAT_TIMESTAMP) + ',' +
         quotedStr(CAT_DATESAISIE) + ',' +
         quotedStr(CAT_IDSAISIE) + ',' +
         quotedStr(CAT_DATEMODIF) + ',' +
         quotedStr(CAT_IDMODIF) + ',' +
         quotedStr(CAT_VALID) + ')');
      catalogue.Append;
      catalogueCAT_ID.Asinteger := catid;
      catalogueCAT_CODE.AsString := CAT_CODE;
      catalogueCAT_FOUID.AsString := fournisseursFOU_NUM.AsString;
      catalogueCAT_ANNEE.AsString := CAT_ANNEE;
      catalogueCAT_MOIS.AsString := CAT_MOIS;
      catalogueCAT_LIBELLE.AsString := CAT_LIBELLE;
      catalogueCAT_NOM.AsString := CAT_NOM;
      catalogueCAT_STATUT.AsString := CAT_STATUT;
      catalogueCAT_TIMESTAMP.AsString := CAT_TIMESTAMP;
      catalogueCAT_DATESAISIE.AsString := CAT_DATESAISIE;
      catalogueCAT_IDSAISIE.AsString := CAT_IDSAISIE;
      catalogueCAT_DATEMODIF.AsString := CAT_DATEMODIF;
      catalogueCAT_IDMODIF.AsString := CAT_IDMODIF;
      catalogueCAT_VALID.AsString := CAT_VALID;
      catalogue.Post;
      tsl.loadfromfile(lerep + 'CT0203P' + cat);
      pb.Position := 0; pb.max := tsl.count;
      qry := 'Select CTL_ID, CTL_ARTCHRONO, CTL_SAISIE, CTL_MODIF, CTL_CATID ' +
         ' from catalogue_lig join catalogue on (CAT_ID=CTL_CATID) ' +
         ' Where CAT_FOUID= ' + fournisseursFOU_NUM.AsString +
         ' And CTL_ARTCHRONO in (';
      for lig := 0 to tsl.count - 1 do
      begin
         S := tsl[lig];
         suiv(s); suiv(s); suiv(s); suiv(s);
         qry := qry + quotedstr(suiv(s)) + ',';
      end;
      delete(qry, length(qry), 1);
      qry := qry + ')';

      res := tc.Select(qry);
      ligexist := Tstringlist.create;
      for lig := 0 to tc.recordCount(res) - 1 do
      begin
         i := ligexist.AddObject(tc.UneValeur(res, 'CTL_ARTCHRONO', lig), tunchrono.create);
         tunchrono(ligexist.Objects[i]).ARTCHRONO := tc.UneValeur(res, 'CTL_ARTCHRONO', lig);
         tunchrono(ligexist.Objects[i]).SAISIE := tc.UneValeur(res, 'CTL_SAISIE', lig);
         tunchrono(ligexist.Objects[i]).MODIF := tc.UneValeur(res, 'CTL_MODIF', lig);
         tunchrono(ligexist.Objects[i]).ID := tc.UneValeur(res, 'CTL_ID', lig);
         tunchrono(ligexist.Objects[i]).CATID := tc.UneValeur(res, 'CTL_CATID', lig);
      end;
      tc.FreeResult(res);
      // ajout des nouvelles lignes
      ent := 'INSERT INTO catalogue_lig (' +
         'CTL_CATID,CTL_ARTCHRONO,CTL_LIBELLE,CTL_MOVEX,' +
         'CTL_FEDID ,CTL_CODEREP,CTL_NOMREP,CTL_DATELIV,CTL_MRQCODE,' +
         'CTL_TYPECOM,CTL_MRQLIBELLE,CTL_ARTTYPE,CTL_ARTNOM,CTL_ARTPXMIN,' +
         'CTL_REFFOURN,CTL_ARTLIBELLE,CTL_ARTBASIC,CTL_COLISAGE,' +
         'CLT_PERMANENT,CTL_BESTSELLER,CTL_DEBBEST,CTL_FINBEST,' +
         'CTL_SAISIE,CTL_IDSAIS,CTL_MODIF,CTL_IDMODIF,CTL_GTA,CTL_TALID) ';
      qry := '';
      pb.Position := 0; pb.max := tsl.count;
      for lig := 0 to tsl.count - 1 do
      begin
         pb.Position := lig;
         S := tsl[lig];
         suiv(s); suiv(s); suiv(s); suiv(s);
         chrono := suiv(s);
         i := ligexist.IndexOf(chrono);
         if i < 0 then
         begin
            if qry <> '' then qry := qry + ' UNION ';
            qry := qry + 'SELECT ' + catalogueCAT_ID.AsString + ', ' +
               quotedstr(chrono) + ', ' +
               quotedstr(suiv(s)) + ', ' +
               quotedstr(suiv(s)) + ', ';
         // recherche fedas
            cherche(fedas, 'FED_CODE', suiv(s) + suiv(s) + suiv(s) + suiv(s));
            qry := qry + quotedstr(fedasFED_ID.AsString) + ', ' +
               quotedstr(suiv(s)) + ', ' +
               quotedstr(suiv(s)) + ', ' +
               quotedstr(suiv(s)) + ', ' +
               quotedstr(suiv(s)) + ', ' +
               quotedstr(suiv(s)) + ', ' +
               quotedstr(suiv(s)) + ', ' +
               quotedstr(suiv(s)) + ', ' +
               quotedstr(suiv(s)) + ', ' +
               quotedstr(suiv(s)) + ', ' +
               quotedstr(suiv(s)) + ', ' +
               quotedstr(suiv(s)) + ', ' +
               quotedstr(suiv(s)) + ', ' +
               quotedstr(suiv(s)) + ', ' +
               quotedstr(suiv(s)) + ', ' +
               quotedstr(suiv(s)) + ', ' +
               quotedstr(suiv(s)) + ', ' +
               quotedstr(suiv(s)) + ', ' +
               quotedstr(suiv(s)) + ', ' +
               quotedstr(suiv(s)) + ', ' +
               quotedstr(suiv(s)) + ', ' +
               quotedstr(suiv(s)) + ', ' +
               quotedstr(s) + ', ';
            cherche(grille_lig, 'TAL_TAEID', inttostr(strtoint(copy(s, 1, 2))), 'TAL_RANG', inttostr(strtoint(copy(s, 3, 2))));
            qry := qry + grille_ligTAL_ID.AsString;
            if length(qry) > 8000 then
            begin
               tc.ordre(ent + qry);
               qry := '';
            end;
         end
         else
         begin
           // deux cas
            s1 := s;
            suiv(s1); suiv(s1); suiv(s1); suiv(s1); suiv(s1); suiv(s1); suiv(s1); suiv(s1); suiv(s1); suiv(s1);
            suiv(s1); suiv(s1); suiv(s1); suiv(s1); suiv(s1); suiv(s1); suiv(s1); suiv(s1); suiv(s1); suiv(s1);
            suiv(s1); suiv(s1); suiv(s1);
            ddeb := suiv(s1);
            suiv(s1);
            dmod := suiv(s1);
            if dmod = '' then dmod := '0';
            if tunchrono(ligexist.Objects[i]).MODIF = '' then
               tunchrono(ligexist.Objects[i]).MODIF := '0';
            if (strtoint(dmod) > strtoint(tunchrono(ligexist.Objects[i]).Modif)) then
            begin
               // suppression
               S1 := 'delete from catalogue_lig where CTL_ID=' + tunchrono(ligexist.Objects[i]).ID;
               tc.ordre(S1);
               S1 := 'update catalogue_coultai ' + // bascule sur le bon catalogue
                  ' set CTC_CATID= ' + catalogueCAT_ID.AsString +
                  ' where CTC_CTLID=' + tunchrono(ligexist.Objects[i]).ID;
               tc.ordre(S1);
               // insertion
               S1 := 'INSERT INTO catalogue_lig (' +
                  'CTL_ID,CTL_CATID,CTL_ARTCHRONO,CTL_LIBELLE,CTL_MOVEX,' +
                  'CTL_FEDID ,CTL_CODEREP,CTL_NOMREP,CTL_DATELIV,CTL_MRQCODE,' +
                  'CTL_TYPECOM,CTL_MRQLIBELLE,CTL_ARTTYPE,CTL_ARTNOM,CTL_ARTPXMIN,' +
                  'CTL_REFFOURN,CTL_ARTLIBELLE,CTL_ARTBASIC,CTL_COLISAGE,' +
                  'CLT_PERMANENT,CTL_BESTSELLER,CTL_DEBBEST,CTL_FINBEST,' +
                  'CTL_SAISIE,CTL_IDSAIS,CTL_MODIF,CTL_IDMODIF,CTL_GTA, CTL_TALID) ';
               S1 := S1 + ' SELECT ' + tunchrono(ligexist.Objects[i]).ID + ', ' +
                  catalogueCAT_ID.AsString + ', ' +
                  quotedstr(chrono) + ', ' +
                  quotedstr(suiv(s)) + ', ' +
                  quotedstr(suiv(s)) + ', ';
                 // recherche fedas
               cherche(fedas, 'FED_CODE', suiv(s) + suiv(s) + suiv(s) + suiv(s));
               S1 := s1 + quotedstr(fedasFED_ID.AsString) + ', ' +
                  quotedstr(suiv(s)) + ', ' +
                  quotedstr(suiv(s)) + ', ' +
                  quotedstr(suiv(s)) + ', ' +
                  quotedstr(suiv(s)) + ', ' +
                  quotedstr(suiv(s)) + ', ' +
                  quotedstr(suiv(s)) + ', ' +
                  quotedstr(suiv(s)) + ', ' +
                  quotedstr(suiv(s)) + ', ' +
                  quotedstr(suiv(s)) + ', ' +
                  quotedstr(suiv(s)) + ', ' +
                  quotedstr(suiv(s)) + ', ' +
                  quotedstr(suiv(s)) + ', ' +
                  quotedstr(suiv(s)) + ', ' +
                  quotedstr(suiv(s)) + ', ' +
                  quotedstr(suiv(s)) + ', ' +
                  quotedstr(suiv(s)) + ', ' +
                  quotedstr(suiv(s)) + ', ' +
                  quotedstr(suiv(s)) + ', ' +
                  quotedstr(suiv(s)) + ', ' +
                  quotedstr(suiv(s)) + ', ' +
                  quotedstr(suiv(s)) + ', ' +
                  quotedstr(s) + ', ';
               cherche(grille_lig, 'TAL_TAEID', inttostr(strtoint(copy(s, 1, 2))), 'TAL_RANG', inttostr(strtoint(copy(s, 3, 2))));
               s1 := s1 + grille_ligTAL_ID.AsString;
               tc.ordre(S1);
               tunchrono(ligexist.Objects[i]).afaire := true;
            end
         end;
      end;
      if qry <> '' then
         tc.ordre(ent + qry);
      tc.remplie('select CTL_ID, CTL_ARTCHRONO from catalogue_lig where CTL_CATID = ' + catalogueCAT_ID.AsString, cat_lig);
      tsl.LoadFromFile(lerep + 'CT0204P' + cat);
      pb.Position := 0; pb.max := tsl.count;
      ent := 'insert into catalogue_dateliv ( ' +
         'CTD_CATID, CTD_ARTCHRONO, CTD_DATELIV, CTD_LIBELLE, CTD_SAISIE,' +
         'CTD_IDSAISIE, CTD_MODIF, CTD_IDMODIF) ';
      qry := '';
      for lig := 0 to tsl.count - 1 do
      begin
         pb.Position := lig;
         S := tsl[lig];
         suiv(s); suiv(s); suiv(s); suiv(s);
         if qry <> '' then qry := qry + ' UNION ';
         qry := qry + 'SELECT ' + catalogueCAT_ID.AsString + ', ' +
            quotedstr(suiv(s)) + ', ' +
            quotedstr(suiv(s)) + ', ' +
            quotedstr(suiv(s)) + ', ' +
            quotedstr(suiv(s)) + ', ' +
            quotedstr(suiv(s)) + ', ' +
            quotedstr(suiv(s)) + ', ' +
            quotedstr(suiv(s));
         if length(qry) > 8000 then
         begin
            tc.ordre(ent + qry);
            qry := '';
         end;
      end;
      if qry <> '' then
         tc.ordre(ent + qry);
      tsl.LoadFromFile(lerep + 'CT0207P' + cat);
      pb.Position := 0; pb.max := tsl.count;
      ent := 'insert into catalogue_coultai (' +
         'CTC_CATID,CTC_ARTCHRONO,CTC_COUL,CTC_LIBCOUL,CTC_TAI,' +
         'CTC_EAN,CTC_MOVEX,CTC_LOT,CTC_VTLOT,CTC_PXACHT,' +
         'CTC_PXVTE,CTC_PRECO,CTC_AFFECT,CTC_SMU,CTC_COMMU,' +
         'CTC_PROMO,CTC_BEST,CTC_STAT1,CTC_STAT2,CTC_STAT3,' +
         'CTC_STAT4,CTC_STAT5,CTC_SAISIE,CTC_IDSAISIE,' +
         'CTC_MODIF,CTC_IDMODIF,CTC_TATRANG,CTC_COUID,CTC_CTLID) ';
      qry := '';
      for lig := 0 to tsl.count - 1 do
      begin
         pb.Position := lig;
         S := tsl[lig];
         suiv(s); suiv(s); suiv(s); suiv(s);
         chrono := suiv(s);
         i := ligexist.IndexOf(chrono);
         if (i > -1) and not (tunchrono(ligexist.Objects[i]).afaire) then
         begin
            S1 := S;
            S2 := 'Select CTC_ID from catalogue_coultai where ' +
               ' CTC_CATID = ' + tunchrono(ligexist.Objects[i]).CATID +
               ' and CTC_ARTCHRONO = ' + quotedstr(chrono) +
               ' and CTC_COUL = ' + quotedstr(suiv(s1));
            suiv(s1);
            S2 := S2 + ' and CTC_TAI = ' + quotedstr(suiv(s1));
            pass := tc.select(S2);
            if tc.recordCount(pass) > 0 then
            begin
               tc.FreeResult(pass);
               continue; // la ligne existe mais est plus rescente
            end;
            tc.FreeResult(pass);
         end;
         if (i > -1) and (tunchrono(ligexist.Objects[i]).afaire) then
         begin
            S1 := S;
            S2 := 'delete from catalogue_coultai where ' +
               ' CTC_CATID = ' + catalogueCAT_ID.AsString +
               ' and CTC_ARTCHRONO = ' + quotedstr(chrono) +
               ' and CTC_COUL = ' + quotedstr(suiv(s1));
            suiv(s1);
            S2 := S2 + ' and CTC_TAI = ' + quotedstr(suiv(s1));
            tc.ordre(s2);
         end;
         if qry <> '' then qry := qry + ' UNION ';
         qry := qry + 'SELECT ' + catalogueCAT_ID.AsString + ', ' +
            quotedstr(chrono) + ', ' +
            quotedstr(suiv(s)) + ', ' +
            quotedstr(suiv(s)) + ', ';
         taille := suiv(s);
         qry := qry + quotedstr(taille) + ', ' +
            quotedstr(suiv(s)) + ', ' +
            quotedstr(suiv(s)) + ', ' +
            quotedstr(suiv(s)) + ', ' +
            quotedstr(suiv(s)) + ', ' +
            quotedstr(suiv(s)) + ', ' +
            quotedstr(suiv(s)) + ', ' +
            quotedstr(suiv(s)) + ', ' +
            quotedstr(suiv(s)) + ', ' +
            quotedstr(suiv(s)) + ', ' +
            quotedstr(suiv(s)) + ', ' +
            quotedstr(suiv(s)) + ', ' +
            quotedstr(suiv(s)) + ', ' +
            quotedstr(suiv(s)) + ', ' +
            quotedstr(suiv(s)) + ', ' +
            quotedstr(suiv(s)) + ', ' +
            quotedstr(suiv(s)) + ', ' +
            quotedstr(suiv(s)) + ', ' +
            quotedstr(suiv(s)) + ', ' +
            quotedstr(suiv(s)) + ', ' +
            quotedstr(suiv(s)) + ', ' +
            quotedstr(suiv(s)) + ', ';
         tatrang := suiv(s);
         qry := qry +
            quotedstr(tatrang) + ', ' +
            '0, ';
         cherche(cat_lig, 'CTL_ARTCHRONO', chrono);
         qry := qry + cat_ligCTL_ID.AsString;
         if length(qry) > 8000 then
         begin
            tc.ordre(ent + qry);
            qry := '';
         end;
      end;
      if qry <> '' then
         tc.ordre(ent + qry);

      // on marque l'ordre des couleurs
      S := 'Update catalogue_coultai ct join ( ' +
         ' select A.Chro, A.Coul, count(*) nb ' +
         ' from ' +
         ' (select max(ctc_id) id,  CTC_ARTCHRONO Chro, CTC_LIBCOUL coul ' +
         ' from catalogue_coultai ' +
         '  WHERE CTC_COUID=0 ' +
         ' group by chro, coul) as A ' +
         '  join ' +
         ' (select max(ctc_id) id,  CTC_ARTCHRONO Chro, CTC_LIBCOUL coul ' +
         ' from catalogue_coultai ' +
         '  WHERE CTC_COUID=0 ' +
         ' group by chro, coul) as B on (A.chro=B.chro and A.id<=B.id) ' +
         ' group by A.Chro, A.Coul) C on (ct.CTC_ARTCHRONO=C.Chro and ct.CTC_LIBCOUL=C.Coul) ' +
         ' set ct.CTC_COUID = C.nb ' +
         ' where ct.CTC_COUID=0 ';
      tc.ordre(s);
      for i := 0 to ligexist.count - 1 do
         tunchrono(ligexist.objects[i]).free;
      ligexist.free;

      // Problème des grilles de tailles
      // initialisation des ID
      S := 'Update catalogue_coultai ' +
         '   Join catalogue_lig on (CTL_ID=CTC_CTLID) ' +
         '   join grille_lig on (TAL_ID=CTL_TALID) ' +
         '   Join grille_taille on (TAT_LIBELLE=CTC_TAI and TAT_TALID=CTL_TALID) ' +
         ' set CTC_TATID=TAT_ID ' +
         ' where CTC_TATID=0 ';
      tc.ordre(s);

      // ajout des tailles manquantes
      S := ' Insert into grille_taille (TAT_TALID, TAT_LIBELLE ,TAT_RANG, TAT_FLAG) ' +
         ' Select distinct CTL_TALID, CTC_TAI, CTC_TATRANG, "N" ' +
         '  from catalogue_coultai ' +
         '      Join catalogue_lig on (CTL_ID=CTC_CTLID) ' +
         ' Where CTC_TATID=0 ';
      tc.ordre(s);

      // initialisation des ID manquant
      S := 'Update catalogue_coultai ' +
         '   Join catalogue_lig on (CTL_ID=CTC_CTLID) ' +
         '   join grille_lig on (TAL_ID=CTL_TALID) ' +
         '   Join grille_taille on (TAT_LIBELLE=CTC_TAI and TAT_TALID=CTL_TALID) ' +
         ' set CTC_TATID=TAT_ID ' +
         ' where CTC_TATID=0 ';
      tc.ordre(s);

      // cas de 2 tailles de même rang
      S := 'Update grille_taille join ( ' +
         '   select TAT_TALID, TAT_RANG, MIN(TAT_ID) mini ' +
         '   from grille_taille ' +
         '   where tat_rang<>0 ' +
         '   group by TAT_TALID, TAT_RANG ' +
         '   having count(*)>1) A ' +
         ' set grille_taille.tat_rang=grille_taille.tat_rang+0.1 ' +
         ' where A.tat_talid=grille_taille.tat_talid ' +
         ' and   A.tat_rang=grille_taille.tat_rang ' +
         ' and   A.mini <>grille_taille.tat_ID ';
      tc.ordre(s);
      // au cas ou yen ai trois
      tc.ordre(s);
   end;
   tsl.free;
   tc.free;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
   tc: Tconnexion;
   f: tsearchrec;
   f2: tsearchrec;
begin
   Lab_etat.Caption := 'Décompression des ZIP'; Lab_etat.Update;
   if findfirst(ed_Repcat.text + '*.zip', faAnyFile, f) = 0 then
   begin
      repeat
         ForceDirectories(ed_Repcat.text + Changefileext(f.name, ''));
         zip.ZipFileName := ed_Repcat.text + f.name;
         zip.ExtrBaseDir := ed_Repcat.text + Changefileext(f.name, '') + '\';
         zip.Extract;
      until findnext(f) <> 0;
   end;
   findclose(f);
   tc := Tconnexion.create;
   tc.Base := 'ginkoia_db2';
   Lab_etat.Caption := 'Chargement des catalogues'; Lab_etat.Update;
   tc.remplie('select * from catalogue', catalogue);
   Lab_etat.Caption := 'Chargement de la FEDAS'; Lab_etat.Update;
   tc.remplie('select * from fedas', fedas);
   Lab_etat.Caption := 'Chargement des fournisseurs'; Lab_etat.Update;
   tc.remplie('select * from fournisseurs', fournisseurs);
   Lab_etat.Caption := 'Chargement des tailles'; Lab_etat.Update;
   tc.remplie('select * from grille_lig', grille_lig);
   tc.free;
  // 1° vérifier la fedas
   if FileExists(ed_Repcat.text + 'FEDAS\CT0018P.csv') then
   begin
      ImportFedas(ed_Repcat.text + 'FEDAS\CT0018P.csv');
   end;
   if findfirst(ed_repcat.text + '\*. ', faDirectory, f) = 0 then
   begin
      repeat
         if (f.name <> '.') and (f.name <> '..') and (f.name <> 'FEDAS') then
         begin
            if (f.Attr and fadirectory) = fadirectory then
            begin
               if findfirst(ed_repcat.text + '\' + f.name + '\CT0201P_*.csv', faAnyFile, f2) = 0 then
               begin
                  caption := f.name;
                  Importcatalogue(ed_repcat.text + '\' + f.name + '\' + f2.name);
               end;
               findclose(f2);
            end;
         end;
      until findnext(f) <> 0;
   end;
   findclose(f);
   application.messagebox('C''est fini', 'FIN', mb_ok);
end;

{ tunchrono }


{ tunchrono }

constructor tunchrono.create;
begin
   afaire := false;
end;

procedure TForm1.ChercherClick(Sender: TObject);
var
   f: tsearchrec;
   f2: tsearchrec;
begin
   if findfirst(ed_repcat.text + '\*. ', faDirectory, f) = 0 then
   begin
      repeat
         if (f.name <> '.') and (f.name <> '..') and (f.name <> 'FEDAS') then
         begin
            if (f.Attr and fadirectory) = fadirectory then
            begin
               if findfirst(ed_repcat.text + '\' + f.name + '\CT0203P_*.csv', faAnyFile, f2) = 0 then
               begin
                  ReCherche(ed_repcat.text + '\' + f.name + '\' + f2.name);
               end;
               findclose(f2);
            end;
         end;
      until findnext(f) <> 0;
   end;
   findclose(f);
   application.messagebox('C''est fini', 'FIN', mb_ok);
end;

procedure TForm1.Recherche(cat: string);
var
   tsl: tstringlist;
   i: integer;
   s: string;
begin
 //
   lab_etat.Caption := extractfilepath(cat); lab_etat.update;
   tsl := tstringlist.create;
   tsl.loadfromfile(cat);
   for i := 0 to tsl.count - 1 do
   begin
      s := tsl[i];
      delete(s, 1, pos(';', s));
      delete(s, 1, pos(';', s));
      delete(s, 1, pos(';', s));
      delete(s, 1, pos(';', s));
      S := Copy(s, 1, pos(';', s) - 1);
      if s = ed_ref.text then
      begin
         application.messagebox(pchar(cat), 'trouvé la', mb_ok);
         break;
      end;
   end;
   tsl.free;
 //
end;

initialization
   decimalseparator := '.';
end.

