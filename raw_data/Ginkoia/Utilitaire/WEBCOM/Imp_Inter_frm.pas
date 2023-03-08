unit Imp_Inter_frm;

interface

uses
   Upost,
   adh_frm,
   chxmag_frm,
   FileCtrl,
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   ApFolderDlg, Buttons, StdCtrls, ZipMstr, Db, dxmdaset, ComCtrls,
   IBDatabase, IBCustomDataSet, IBQuery;

type
   Tfrm_Imp_Inter = class(TForm)
      Label1: TLabel;
      ed_rep: TEdit;
      SpeedButton1: TSpeedButton;
      Od: TApFolderDialog;
      ZIP: TZipMaster;
      Button1: TButton;
      MemD_Entete: TdxMemData;
      MemD_EnteteBNR: TStringField;
      MemD_EnteteKNR: TStringField;
      MemD_EnteteLNR: TStringField;
      MemD_EnteteTYP: TStringField;
      MemD_EnteteSAJ: TStringField;
      MemD_EnteteSAC: TStringField;
      MemD_EnteteSTA: TStringField;
      MemD_EnteteIWS: TStringField;
      MemD_EnteteDAT: TStringField;
      MemD_EnteteAWR: TStringField;
      MemD_EnteteAAP: TStringField;
      MemD_EnteteEDT: TStringField;
      MemD_EnteteEBI: TStringField;
      MemD_EnteteMDT: TStringField;
      MemD_EnteteMBI: TStringField;
      MemD_EnteteIWF: TStringField;
      MemD_Lignes: TdxMemData;
      MemD_LignesBNR: TStringField;
      MemD_LignesBSZ: TStringField;
      MemD_LignesLNR: TStringField;
      MemD_LignesANR: TStringField;
      MemD_LignesFNR: TStringField;
      MemD_LignesKOL: TStringField;
      MemD_LignesLDA: TStringField;
      MemD_LignesAUM: TStringField;
      MemD_LignesAMG: TStringField;
      MemD_LignesEKP: TStringField;
      MemD_LignesDVP: TStringField;
      MemD_LignesEDT: TStringField;
      MemD_LignesEBI: TStringField;
      MemD_LignesMDT: TStringField;
      MemD_LignesMBI: TStringField;
      MemD_LignesEAN: TStringField;
      MemD_LignesAB1: TStringField;
      MemD_LignesFB1: TStringField;
      MemD_LignesGT1: TStringField;
      MemD_LignesRAN: TStringField;
      MemD_LignesID_ENT: TIntegerField;
      Lab_et1: TLabel;
      lab_et2: TLabel;
      MemD_Articles: TdxMemData;
      MemD_ArticlesCTL_ID: TIntegerField;
      MemD_ArticlesCTL_CATID: TIntegerField;
      MemD_ArticlesCTL_CHRONO: TStringField;
      Lab_et3: TLabel;
      pb2: TProgressBar;
      pb3: TProgressBar;
      data: TIBDatabase;
      tran: TIBTransaction;
      qry: TIBQuery;
      MemD_LignesART_ID: TIntegerField;
      qry2: TIBQuery;
      qryk: TIBQuery;
      Rb_etee: TRadioButton;
      Rb_Hivers: TRadioButton;
      Cb_Commande: TCheckBox;
      MemD_ArticlesCTL_ARTTYPE: TIntegerField;
      MemD_ArticlesCTL_ARTPACK: TIntegerField;
      MemD_LignesART_TYPE: TIntegerField;
      MemD_LignesCTL_ID: TIntegerField;
      procedure SpeedButton1Click(Sender: TObject);
      procedure Button1Click(Sender: TObject);
      procedure FormCreate(Sender: TObject);
   private
      function importation(rep: string): boolean;
      function newk(table: string): string;
      function insertT(table: string; chp, val: array of string): string;
    { Déclarations privées }
   public
    { Déclarations publiques }
      LesAdherent: TstringList;
      lesfou: TstringList;
      lesbases: TstringList;
      rapport: TstringList;
   end;

var
   frm_Imp_Inter: Tfrm_Imp_Inter;

implementation

{$R *.DFM}

procedure Tfrm_Imp_Inter.SpeedButton1Click(Sender: TObject);
begin
   if od.execute then
      ed_rep.Text := IncludeTrailingBackslash(od.FolderName);
end;

function Tfrm_Imp_Inter.newk(table: string): string;
begin
   qryk.close;
   qryk.sql.text := 'select ID from PR_NEWK (' + quotedstr(uppercase(trim(table))) + ')';
   qryk.Open;
   result := qryk.fields[0].AsString;
end;

function Tfrm_Imp_Inter.insertT(table: string; chp, val: array of string): string;
var
   s: string;
   i: integer;
begin
   result := newk(table);
   s := 'insert into ' + table + '(';
   for i := 0 to high(chp) - 1 do
      s := s + chp[i] + ',';
   s := s + chp[high(chp)] + ') values (' + result;
   for i := 0 to high(val) do
      if val[i] = 'result' then
         s := s + ',' + result
      else
         s := s + ',' + val[i];
   s := s + ')';
   qryk.close;
   qryk.sql.text := s;
   qryk.execsql;
end;

function Tfrm_Imp_Inter.importation(rep: string): boolean;
var
   f: TSearchRec;
   s: string;
   tsl: Tstringlist;
   tc: Tconnexion;
   LesArticles: TstringList;
   i: integer;
   res: tstringlist;
   res_pas: tstringlist;
   Adh, Clt, Base: string;
   magid: Integer;
   fouid: string;
   mrkid: string;
   ssfid: string;
   Gr_CB: TstringList;
   Gr_ligne: TstringList;
   Gr_ligne2: TstringList;
   Gr_Taille: TstringList;
   TGTID: string;
   ordreaff: string;
   gtfid: string;
   artid: string;
   arfid: string;
   tvaid: string;
   tctid: string;
   chrono: string;
   couid: string;
   ean: string;
   j: integer;
   pvi: string;
   lastt: string;

   procedure importFou;
   var
      i: integer;
      adrid: string;
      fouid: string;
      fodid: string;
      lesmrk: TstringList;
      j: integer;
      mrkid: string;
      fmkprin: string;
   begin
      if lesbases.indexof(Uppercase(base)) < 0 then
      begin
         lesbases.add(Uppercase(base));
         pb3.position := 0;
         pb3.max := tc.recordCount(lesfou);
         for i := 0 to tc.recordCount(lesfou) - 1 do
         begin
            pb3.position := pb3.position + 1;
            qry.close;
            qry.sql.text := ' Select FOU_ID, IMP_REF ' +
               ' from artfourn Join k on (k_id=FOU_ID and K_ENABLED=1)' +
               ' Join GENIMPORT ' +
               ' join k ' +
               ' Join ktb on (IMP_KTBID=KTB_ID) ' +
               ' on (k_id=imp_id and k_enabled=1) ' +
               ' on (fou_ID=IMP_GINKOIA) ' +
               ' where fou_id<>0 ' +
               ' and KTB_NAME = ''ARTFOURN'' ' +
               ' And IMP_NUM = 10 ' +
               ' and IMP_REF = ' + tc.UneValeur(lesfou, 'FOU_NUM', i);
            qry.open;
            if qry.IsEmpty then
            begin
               // création ou affectation du fournisseur
               qry2.close;
               qry2.sql.text := 'Select FOU_ID ' +
                  ' from artfourn Join k on (k_id=FOU_ID and K_ENABLED=1) ' +
                  ' where fou_id<>0 ' +
                  '   and fou_nom = ' + quotedstr(tc.UneValeur(lesfou, 'FOU_NOM', i));

               if qry2.isempty then
               begin
                  adrid := insertT('GENADRESSE', ['ADR_ID', 'ADR_VILID'], ['0']);
                  fouid := insertT('artfourn',
                     ['fou_id', 'fou_adrid', 'fou_idref', 'fou_nom'],
                     [adrid, '0', quotedstr(tc.UneValeur(lesfou, 'FOU_NOM', i))]);
                  fodid := insertT('ARTFOURNDETAIL',
                     ['fod_id', 'fod_fouid'], [fouid]);
                  rapport.Add('');
                  rapport.Add('Création du fournisseur ' + tc.UneValeur(lesfou, 'FOU_NOM', i));
                  rapport.Add('Marques associées');
               end
               else
               begin
                  // affectation du fournisseur
                  fouid := qry2.fields[0].AsString;
               end;
               insertT('GENIMPORT',
                  ['IMP_ID', 'IMP_NUM', 'IMP_KTBID', 'IMP_GINKOIA', 'IMP_REF'],
                  ['10', '-11111385', fouid, tc.UneValeur(lesfou, 'FOU_NUM', i)]);
            end
            else
               fouid := Qry.fields[0].AsString;

            lesmrk := tc.Select('SELECT DISTINCT CTL_MRQLIBELLE' +
               ' FROM fournisseurs ' +
               ' JOIN catalogue ON ( CAT_FOUID = FOU_NUM and CAT_VALID=1) ' +
               ' JOIN catalogue_lig ON ( CTL_CATID = CAT_ID ) ' +
               ' WHERE FOU_NUM=' + tc.UneValeur(lesfou, 'FOU_NUM', i));
            for j := 0 to tc.recordCount(lesmrk) - 1 do
            begin
               qry.close;
               qry.sql.text := 'Select MRK_ID ' +
                  ' from artmarque Join k on (k_id=MRK_ID and K_ENABLED=1) ' +
                  ' where MRK_id<>0 ' +
                  '   and MRK_Nom = ' + quotedstr(copy(tc.UneValeur(lesmrk, 'CTL_MRQLIBELLE', j), 1, 64));
               qry.open;
               if qry.isempty then
               begin
                  mrkid := InsertT('artmarque',
                     ['MRK_ID', 'MRK_NOM', 'MRK_CODE'],
                     [quotedstr(copy(tc.UneValeur(lesmrk, 'CTL_MRQLIBELLE', j), 1, 64)),
                     quotedstr(copy(tc.UneValeur(lesmrk, 'CTL_MRQLIBELLE', j), 1, 32))]);
                  fmkprin := '1';
                  rapport.Add('   ' + copy(tc.UneValeur(lesmrk, 'CTL_MRQLIBELLE', j), 1, 32));
               end
               else
               begin
                  mrkid := qry.fields[0].asString;
                  fmkprin := '0';
               end;
               qry.close;
               qry.sql.text := 'Select artmrkfourn.* ' +
                  ' from artmrkfourn join k on (k_id=fmk_id and k_enabled=1) ' +
                  ' where FMK_FOUID = ' + fouid +
                  ' and   FMK_MRKID = ' + mrkid;
               qry.open;
               if qry.isempty then
               begin
                  InsertT('artmrkfourn',
                     ['fmk_id', 'fmk_fouid', 'fmk_mrkid', 'FMK_PRIN'],
                     [fouid, mrkid, fmkprin]);
               end;
               qry.close;
            end;
            tc.FreeResult(lesmrk);
         end;
      end;
   end;

var
   cdeid: string;
   EXE_ID: string;
   dliv: string;
   prix: double;
   s1: string;
   tgfid: string;
   ordre: string;
   colid: string;
   artpack: Tstringlist;
   nbrartpack: integer;
begin
   result := true;
   colid := '0';
   tc := Tconnexion.create;
   tc.Base := 'ginkoia_db2';
// a enlever
//   tc.HttpPath := 'http://localhost/intersport/' ;

   LesArticles := TstringList.Create;
   if FindFirst(rep + 'CT0007P*.csv', faanyfile, f) = 0 then
   begin
      s := f.name;
      delete(s, 1, 7);
      if fileexists(rep + 'CT0007P' + s) and fileexists(rep + 'CT0008P' + s) then
      begin
         Lab_et2.Caption := 'Chargement des données'; Lab_et2.Update;
         tsl := tstringlist.create;
         tsl.loadfromfile(rep + 'CT0007P' + s);
         tsl.insert(0, 'BNR;KNR;LNR;TYP;SAJ;SAC;STA;IWS;DAT;AWR;AAP;EDT;EBI;MDT;MBI;IWF');
         tsl.Savetofile(changefileext(application.exename, '.tmp'));
         MemD_Entete.close;
         MemD_Entete.open;
         MemD_Entete.DelimiterChar := ';';
         MemD_Entete.LoadFromTextFile(changefileext(application.exename, '.tmp'));
         // traitement des , !!!
         MemD_Entete.first;
         while not MemD_Entete.eof do
         begin
            if pos(',', MemD_EnteteAWR.AsString) > 0 then
            begin
               MemD_Entete.edit;
               S1 := MemD_EnteteAWR.AsString;
               S1[pos(',', s1)] := '.';
               MemD_EnteteAWR.AsString := S1;
               MemD_Entete.post;
            end;
            MemD_Entete.next;
         end;

         tsl.loadfromfile(rep + 'CT0008P' + s);
         tsl.insert(0, 'BNR;BSZ;LNR;ANR;FNR;KOL;LDA;AUM;AMG;EKP;DVP;EDT;EBI;MDT;MBI;EAN;AB1;FB1;GT1;RAN;ID_ENT;ART_ID;ART_TYPE;CLT_ID;');
         i := 0;
         while i < tsl.count do
            if trim(tsl[i]) <> '' then
            begin
               inc(i);
            end
            else
               tsl.Delete(i);
         tsl.Savetofile(changefileext(application.exename, '.tmp'));
         MemD_Lignes.close;
         MemD_Lignes.open;
         MemD_Lignes.DelimiterChar := ';';
         try
            MemD_Lignes.LoadFromTextFile(changefileext(application.exename, '.tmp'));
         except
            application.MessageBox('Probleme au chargement du fichier', 'Gros problème', MB_OK);
            raise;
         end;
         // traitement des , !!!
         MemD_Lignes.first;
         while not MemD_Lignes.eof do
         begin
            if pos(',', MemD_LignesEKP.AsString) > 0 then
            begin
               S1 := MemD_LignesEKP.AsString;
               S1[pos(',', s1)] := '.';
               MemD_Lignes.edit;
               MemD_LignesEKP.AsString := S1;
               MemD_Lignes.post;
            end;
            if pos(',', MemD_LignesDVP.AsString) > 0 then
            begin
               S1 := MemD_LignesDVP.AsString;
               S1[pos(',', s1)] := '.';
               MemD_Lignes.edit;
               MemD_LignesDVP.AsString := S1;
               MemD_Lignes.post;
            end;
            MemD_Lignes.next;
         end;
         Lab_et2.Caption := 'initialisation des lignes'; Lab_et2.Update;
         MemD_Lignes.first;
         while not MemD_Lignes.eof do
         begin
            if LesArticles.indexof(MemD_LignesANR.AsString) < 0 then
               LesArticles.Add(MemD_LignesANR.AsString);
        // recherche de la commande ;
            MemD_Entete.first;
            while not (MemD_Entete.eof) and (MemD_EnteteBNR.AsString <> MemD_LignesBNR.AsString) do
               MemD_Entete.next;
            if MemD_EnteteBNR.AsString = MemD_LignesBNR.AsString then
            begin
               MemD_Lignes.Edit;
               MemD_LignesID_ENT.AsInteger := MemD_Entete.fields[0].AsInteger;
               MemD_Lignes.Post;
            end
            else
            begin
               rapport.Add(' **** Une ligne existe sans entête de commande **** ');
               rapport.Add('Ref ' + MemD_LignesBNR.AsString);
               rapport.Add('');
            end;

            MemD_Lignes.next;
         end;
         Lab_et2.Caption := 'recherches des articles'; Lab_et2.Update;
         s := 'select CTL_ID, CTL_CATID, CTL_ARTCHRONO as CTL_CHRONO, CTL_ARTTYPE, CTL_ARTPACK from catalogue_lig ' +
            'where (CTL_ARTTYPE=1 or CTL_ARTPACK<>0) ' +
            ' and CTL_ARTCHRONO in (';
         for i := 0 to LesArticles.count - 2 do
            S := S + quotedstr(LesArticles[i]) + ',';
         S := S + quotedstr(LesArticles[LesArticles.count - 1]) + ')';
         res := tc.Select(s);
         tc.toMemDataset(res, MemD_Articles);
         tc.FreeResult(res);
         Lab_et2.Caption := 'Intégration des commandes'; Lab_et2.Update;
         pb2.position := 0;
         pb2.Max := MemD_Entete.recordcount;
         MemD_Entete.first;
         Adh := '';
         magid := 0;
         Clt := '';
         while not MemD_Entete.eof do
         begin
            pb2.position := pb2.position + 1;
            S := MemD_EnteteKNR.AsString + ';';
            Base := '';
            for i := 0 to LesAdherent.count - 1 do
               if copy(LesAdherent[i], 1, length(s)) = s then
               begin
                  S := LesAdherent[i];
                  if Copy(S, 1, pos(';', s) - 1) <> Adh then
                     data.connected := false;
                  Adh := Copy(S, 1, pos(';', s) - 1);
                  delete(s, 1, pos(';', s));
                  clt := Copy(S, 1, pos(';', s) - 1);
                  delete(s, 1, pos(';', s));
                  Base := Copy(S, 1, pos(';', s) - 1);
                  delete(s, 1, pos(';', s));
                  if Strtoint(s) <> magid then
                     data.connected := false;
                  magid := Strtoint(s);
                  if base <> '' then
                     BREAK;
               end;
            if base = '' then
            begin
             // faire saisir le client
               data.connected := false;
               application.CreateForm(Tfrm_adh, frm_adh);
               frm_adh.ed_code.text := MemD_EnteteKNR.AsString;
               frm_adh.showModal;
               Adh := frm_adh.ed_code.text;
               Clt := frm_adh.ed_nom.text;
               Base := frm_adh.ed_base.text;
               magid := frm_adh.magid;
               if trim(base) = '' then EXIT;
               LesAdherent.Add(Adh + ';' + Clt + ';' + Base + ';' + inttostr(magid));
               LesAdherent.Savetofile(changefileext(application.exename, '.ini'));
            end;
            Lab_et3.caption := 'Ouverture de la base'; Lab_et3.Update;
            if not (data.Connected) or
               (base <> data.databasename) then
            begin
               data.close;
               data.databasename := base;
               data.open;
               rapport.Add('Client :' + Clt);
               rapport.Add('Adhérent :' + Adh);
               rapport.Add('Base :' + base);
               rapport.Add('');
               qry.close;
               qry.sql.text := 'select count(*) ' +
                  ' from nklssfamille join k on (k_enabled=1 and k_id=ssf_id) ' +
                  ' where ssf_idref=18020300 ';
               qry.open;
               if qry.fields[0].asinteger < 1 then
               begin
                  application.messagebox('Impossible d''intégrer les commandes '#13#10 +
                     'dans une base sans Nomenclature intersport ', ' ERREUR ', MB_ok);
                  result := false;
                  data.close;
                  EXIT;
               end;
               qry.close;
               Lab_et3.caption := 'vérification des fournisseurs'; Lab_et3.Update;
               importFou;
               rapport.Add('');

               // choix de la collection
               application.createform(Tfrm_ChxMag, frm_ChxMag);
               try
                  qry.close;
                  qry.sql.text := 'select COL_ID, COL_NOM ' +
                     ' from artcollection join k on (k_id=col_id and k_enabled=1) ' +
                     ' where col_id<>0 ';
                  qry.open;
                  frm_ChxMag.caption := ' Choix de la collection ';
                  frm_ChxMag.lb_mag.items.addObject('Aucune', pointer(0));
                  while not qry.eof do
                  begin
                     frm_ChxMag.lb_mag.items.addObject(qry.fields[1].AsString, pointer(qry.fields[0].AsInteger));
                     qry.next;
                  end;
                  qry.close;
                  frm_ChxMag.lb_mag.itemindex := 0;
                  if not frm_ChxMag.showmodal = mrok then halt;
                  colid := IntToStr(integer(frm_ChxMag.lb_mag.items.Objects[frm_ChxMag.lb_mag.itemindex]))
               finally
                  frm_ChxMag.release;
               end;

               if not (Cb_Commande.checked) then
               begin
                  // choix de l'exercice
                  application.createform(Tfrm_ChxMag, frm_ChxMag);
                  try
                     qry.close;
                     qry.sql.text := 'select EXE_ID, EXE_NOM ' +
                        ' from GENEXERCICECOMMERCIAL join k on (k_id=exe_id and k_enabled=1) ' +
                        ' where exe_id<>0 ' +
                        ' and exe_fin > current_date';
                     qry.open;
                     frm_ChxMag.caption := ' Choix de l''exercice ';
                     while not qry.eof do
                     begin
                        frm_ChxMag.lb_mag.items.addObject(qry.fields[1].AsString, pointer(qry.fields[0].AsInteger));
                        qry.next;
                     end;
                     qry.close;
                     frm_ChxMag.lb_mag.itemindex := 0;
                     if not frm_ChxMag.showmodal = mrok then halt;
                     exe_id := IntToStr(integer(frm_ChxMag.lb_mag.items.Objects[frm_ChxMag.lb_mag.itemindex]))
                  finally
                     frm_ChxMag.release;
                  end;
               end
               else
                  exe_id := '0';
            end;
            Lab_et3.Caption := Adh + ' ' + MemD_EnteteBNR.AsString; Lab_et3.Update;

            // recherche le fou
            qry.close;
            qry.sql.text := ' Select FOU_ID ' +
               ' from artfourn Join k on (k_id=FOU_ID and K_ENABLED=1)' +
               ' Join GENIMPORT ' +
               ' join k ' +
               ' Join ktb on (IMP_KTBID=KTB_ID) ' +
               ' on (k_id=imp_id and k_enabled=1) ' +
               ' on (fou_ID=IMP_GINKOIA) ' +
               ' where fou_id<>0 ' +
               ' and KTB_NAME = ''ARTFOURN'' ' +
               ' And IMP_NUM = 10 ' +
               ' and IMP_REF = ' + MemD_EnteteLNR.AsString;
            qry.open;
            fouid := qry.fields[0].AsString;
            if fouid = '' then
            begin
              // la commande existe on vat plus loin
               rapport.Add('************************************************');
               rapport.Add('La commande ' + MemD_EnteteBNR.AsString + ' Ne peut pas être importée ');
               rapport.Add('Elle fait référence à un fournisseur inconnu ');
               rapport.Add('Fournisseur : ' + MemD_EnteteLNR.AsString);
               rapport.Add('Montant : ' + MemD_EnteteAWR.AsString);
               rapport.Add('Nb de ligne : ' + MemD_EnteteAAP.AsString);
               rapport.Add('************************************************');
               MemD_Entete.next;
               continue;
            end;

            // vérifier si la commande est à importer
            qry.close;
            qry.sql.text := 'select CDE_ID from COMBCDE where ' +
               ' CDE_FOUID = ' + fouid +
               ' and CDE_NUMFOURN = ' + quotedstr(MemD_EnteteBNR.AsString);
            qry.open;
            if not (qry.isempty) then
            begin
              // la commande existe on vat plus loin
               rapport.Add('commande ' + MemD_EnteteBNR.AsString + ' déjà existante ');
               MemD_Entete.next;
               continue;
            end;

            pb3.position := 0;
            pb3.max := MemD_Lignes.recordcount * 2;
            MemD_Lignes.first;
            dliv := '';
            while not MemD_Lignes.eof do
            begin
               pb3.position := pb3.position + 1;
               if MemD_LignesID_ENT.AsInteger = MemD_Entete.fields[0].asInteger then
               begin
                 // recherche de l'article
                  if dliv = '' then
                     dliv := trim(MemD_LignesLDA.AsString);
                  MemD_Articles.first;
                  while not (MemD_Articles.eof) and (MemD_ArticlesCTL_CHRONO.AsString <> MemD_LignesANR.AsString) do
                     MemD_Articles.next;
                  if MemD_ArticlesCTL_CHRONO.AsString <> MemD_LignesANR.AsString then
                  begin
                     // application.MessageBox('gros prob', 'prob', mb_ok);
                     // Article inexistant
                  end
                  else
                  begin
                     if MemD_ArticlesCTL_ARTTYPE.AsInteger = 3 then
                     begin
                        // l'article existe déjà ?
                        qry.close;
                        qry.sql.text := 'Select IMP_GINKOIA ' +
                           ' from GenImport Join k on (k_id=IMP_ID and k_enabled=1) ' +
                           ' where IMP_NUM = 10 ' +
                           ' and IMP_REF = ' + MemD_ArticlesCTL_ARTPACK.AsString +
                           ' And IMP_KTBID = -11111375';
                        qry.open;
                     end
                     else
                     begin
                        // l'article existe déjà ?
                        qry.close;
                        qry.sql.text := 'Select IMP_GINKOIA ' +
                           ' from GenImport Join k on (k_id=IMP_ID and k_enabled=1) ' +
                           ' where IMP_NUM = 10 ' +
                           ' and IMP_REF = ' + MemD_ArticlesCTL_ID.AsString +
                           ' And IMP_KTBID = -11111375';
                        qry.open;
                     end;
                     if qry.isempty then
                     begin
                       // création de l'article
                        S := 'SELECT CTL_ID, CTL_ARTCHRONO, CTL_MRQLIBELLE, CTL_ARTPXMIN, CTL_TALID, ' +
                           ' CTL_LIBELLE, CTL_ARTLIBELLE, CTL_REFFOURN, fedas.*, inter ' +
                           ' FROM catalogue_lig ' +
                           ' JOIN catalogue ON ( CAT_ID = CTL_CATID AND CAT_VALID =1 ) ' +
                           ' JOIN fournisseurs ON ( FOU_NUM = CAT_FOUID ) ' +
                           ' JOIN fedas ON ( FED_ID = CTL_FEDID ) ' +
                           ' JOIN fed_inter ON ( FED_CODE = fedas ) ';
                        if MemD_ArticlesCTL_ARTTYPE.AsInteger = 3 then
                           s := s + ' WHERE CTL_ID =  ' + MemD_ArticlesCTL_ARTPACK.AsString
                        else
                           s := s + ' WHERE CTL_ID =  ' + MemD_ArticlesCTL_ID.AsString;
                        res := tc.Select(S);
                        if tc.recordCount(res) = 0 then
                        begin
                        end
                        else
                        begin
                        // chercher la marque
                           qry.close;
                           qry.sql.text := ' select MRK_ID ' +
                              ' from artmrkfourn join artmarque on (mrk_id = fmk_mrkid) ' +
                              ' Join k on (k_id=MRK_ID and K_ENABLED=1) ' +
                              ' Join k on (k_id=FMK_ID and K_ENABLED=1) ' +
                              ' where fmk_fouid = ' + fouid +
                              ' and mrk_nom=' + quotedstr(copy(tc.UneValeur(res, 'CTL_MRQLIBELLE'), 1, 64));
                           qry.open;
                           if qry.IsEmpty then
                           begin
                          // faire la liaison
                              qry.Close;
                              qry.sql.text := 'Select MRK_ID ' +
                                 ' from artmarque Join k on (k_id=MRK_ID and K_ENABLED=1) ' +
                                 ' where MRK_id<>0 ' +
                                 '   and MRK_Nom = ' + quotedstr(copy(tc.UneValeur(res, 'CTL_MRQLIBELLE'), 1, 64));
                              qry.open;
                              mrkid := qry.fields[0].AsString;
                              InsertT('artmrkfourn',
                                 ['fmk_id', 'fmk_fouid', 'fmk_mrkid', 'FMK_PRIN'],
                                 [fouid, mrkid, '0']);
                           end
                           else
                              mrkid := qry.fields[0].AsString;
                        // recherche de la sous famille
                           qry.close;
                           qry.sql.text := ' select SSF_ID ' +
                              ' from nklssfamille join k on (k_id=ssf_id and k_enabled=1) ' +
                              ' where ssf_idref = ' + tc.UneValeur(res, 'inter');
                           qry.open;
                           ssfid := qry.fields[0].AsString;
                           if ssfid = '' then
                           begin
                              // rechercher dans genimport
                              S := 'Select int_id from intersport where int_code = ' + tc.UneValeur(res, 'inter');
                              res_pas := tc.Select(S);
                              if tc.recordCount(res_pas) <> 0 then
                              begin
                                 qry.close;
                                 qry.sql.text := ' select IMP_GINKOIA ' +
                                    ' from genimport join k on (k_id=imp_id and k_enabled=1)' +
                                    ' where imp_num=10 and imp_ktbid=-11111359' +
                                    ' and imp_REF = ' + tc.UneValeur(res_pas, 'int_id');
                                 qry.open;
                                 ssfid := qry.fields[0].AsString;
                              end;
                              tc.FreeResult(res_pas);
                              if ssfid = '' then
                              begin
                                 application.MessageBox('La nomenclature du client est incomplète, refaire l''importation', 'ERREUR', MB_OK);
                                 EXIT;
                              end;
                           end;
                           qry.close;
                        // recherche la grille de taille
                           qry.sql.text := ' Select GTF_ID ' +
                              ' from PLXGTF Join k on (k_id=GTF_ID and K_ENABLED=1) ' +
                              ' Join GENIMPORT join k ' +
                              '   Join ktb on (IMP_KTBID=KTB_ID) ' +
                              ' on (k_id=imp_id and k_enabled=1) ' +
                              ' on (GTF_ID=IMP_GINKOIA) ' +
                              ' where GTF_id<>0 ' +
                              ' and KTB_NAME = ''PLXGTF'' ' +
                              ' And IMP_NUM = 10 ' +
                              ' And IMP_REF =  ' + tc.UneValeur(res, 'CTL_TALID');
                           qry.open;
                           if qry.isempty then
                           begin
                           // création de la grille de taille
                              Gr_Taille := tc.select('select TAE_ID, TAE_NOM, TAL_ID, TAL_RANG, TAL_LIBELLE ' +
                                 ' from grille_lig join grille_ent on (TAE_ID=TAL_TAEID) ' +
                                 ' where TAL_ID = ' + tc.UneValeur(res, 'CTL_TALID'));
                              qry.close;
                              qry.sql.text := 'Select TGT_ID ' +
                                 ' from PLXTYPEGT Join k on (k_id=TGT_ID and K_ENABLED=1) ' +
                                 ' Join GENIMPORT ' +
                                 ' join k ' +
                                 ' Join ktb on (IMP_KTBID=KTB_ID) ' +
                                 ' on (k_id=imp_id and k_enabled=1) ' +
                                 ' on (TGT_ID=IMP_GINKOIA) ' +
                                 ' where TGT_id<>0 ' +
                                 ' and KTB_NAME = ''PLXTYPEGT''  ' +
                                 ' And IMP_NUM = 10 ' +
                                 ' AND IMP_REF = ' + tc.UneValeur(Gr_Taille, 'TAE_ID');
                              qry.open;
                              if qry.isempty then
                              begin
                                 qry.close;
                                 qry.sql.text := 'select max(TGT_ORDREAFF)+10 from PLXTYPEGT';
                                 qry.Open;
                                 ordreaff := qry.fields[0].AsString;
                                 TGTID := insertT('PLXTYPEGT',
                                    ['TGT_ID', 'TGT_NOM', 'TGT_ORDREAFF'],
                                    [quotedstr(tc.UneValeur(Gr_Taille, 'TAE_NOM')), ordreaff]);
                                 insertT('genimport',
                                    ['IMP_ID', 'IMP_NUM', 'IMP_KTBID', 'IMP_GINKOIA', 'IMP_REF'],
                                    ['10', '-11111374', tgtid, tc.UneValeur(Gr_Taille, 'TAE_ID')]);
                              end
                              else
                                 TGTID := qry.fields[0].AsString;
                              gtfid := insertT('PLXGTF',
                                 ['GTF_ID', 'GTF_NOM', 'GTF_TGTID', 'GTF_IMPORT', 'GTF_ORDREAFF'],
                                 [quotedstr(tc.UneValeur(Gr_Taille, 'TAL_LIBELLE')), TGTID, '1', tc.UneValeur(Gr_Taille, 'TAL_RANG')]);
                              insertT('genimport',
                                 ['IMP_ID', 'IMP_NUM', 'IMP_KTBID', 'IMP_GINKOIA', 'IMP_REF'],
                                 ['10', '-11111364', gtfid, tc.UneValeur(res, 'CTL_TALID')]);

                           // création des tailles
                              Gr_ligne := tc.select('select * from grille_taille where TAT_TALID=' + tc.unevaleur(Gr_Taille, 'TAL_ID'));
                              for i := 0 to tc.recordcount(Gr_ligne) - 1 do
                              begin
                                 insertT('PLXTAILLESGF',
                                    ['TGF_ID', 'TGF_GTFID', 'TGF_TGFID', 'TGF_NOM', 'TGF_ORDREAFF', 'TGF_STAT'],
                                    [gtfid, 'result', quotedstr(uppercase(tc.unevaleur(Gr_Ligne, 'TAT_LIBELLE', i))),
                                    tc.unevaleur(Gr_Ligne, 'TAT_RANG', i), tc.unevaleur(Gr_Ligne, 'TAT_RANG', i)]);
                              end;
                              tc.freeresult(Gr_ligne);
                              tc.freeresult(Gr_Taille);
                           end
                           else
                              gtfid := qry.fields[0].AsString;

                        // création de l'article
                           artid := insertT('artarticle',
                              ['ART_ID', 'ART_IDREF', 'ART_NOM', 'ART_ORIGINE',
                              'ART_DESCRIPTION', 'ART_MRKID', 'ART_REFMRK',
                                 'ART_SSFID', 'ART_GTFID'],
                                 [tc.UneValeur(res, 'CTL_ID'), quotedstr(tc.UneValeur(res, 'CTL_LIBELLE')), '1',
                              quotedstr(tc.UneValeur(res, 'CTL_ARTLIBELLE')), mrkid, quotedstr(tc.UneValeur(res, 'CTL_ARTCHRONO')),
                                 ssfid, gtfid]);

                        // Tailles travaillées
                           Gr_ligne := tc.select('select distinct CTC_TAI from catalogue_coultai where CTC_CTLID=' + tc.UneValeur(res, 'CTL_ID'));
                           for i := 0 to tc.recordcount(Gr_ligne) - 1 do
                           begin
                              qry.close;
                              qry.sql.text := ' Select TGF_ID ' +
                                 ' from PLXTAILLESGF Join k on (k_id=TGF_ID and K_ENABLED=1) ' +
                                 ' where TGF_ID <>0 ' +
                                 ' And upper(TGF_NOM) = ' + quotedstr(Uppercase(tc.unevaleur(Gr_ligne, 'CTC_TAI', i))) +
                                 ' and TGF_GTFID = ' + GTFID;
                              qry.open;
                              if qry.isempty then
                              begin
                                 Gr_ligne2 := tc.select('select * from grille_taille where TAT_TALID=' + tc.UneValeur(res, 'CTL_TALID') +
                                    ' and TAT_LIBELLE=' + quotedstr(Uppercase(tc.unevaleur(Gr_ligne, 'CTC_TAI', i))));
                                 if tc.recordcount(Gr_ligne2) > 0 then
                                 begin
                                    insertT('PLXTAILLESGF',
                                       ['TGF_ID', 'TGF_GTFID', 'TGF_TGFID', 'TGF_NOM', 'TGF_ORDREAFF', 'TGF_STAT'],
                                       [gtfid, 'result', quotedstr(uppercase(tc.unevaleur(Gr_Ligne2, 'TAT_LIBELLE'))),
                                       tc.unevaleur(Gr_Ligne2, 'TAT_RANG'), tc.unevaleur(Gr_Ligne2, 'TAT_RANG')]);
                                    tc.freeresult(Gr_ligne2);
                                 end;
                                 qry.close;
                                 qry.Open;
                              end;
                              if not qry.eof then
                                 insertT('PLXTAILLESTRAV',
                                    ['TTV_ID', 'TTV_ARTID', 'TTV_TGFID'],
                                    [artid, qry.fields[0].AsString]);
                           end;

                           tc.freeresult(Gr_ligne);
                           qry.close;
                           qry.sql.text := ' Select TVA_ID ' +
                              ' from GENDOSSIER join k on (k_id=DOS_ID and k_enabled=1) ' +
                              '                 join Arttva Join k on (k_id=tva_id and k_enabled=1) ' +
                              '                    on (TVA_TAUX=DOS_FLOAT) ' +
                              ' Where DOS_NOM=''TVA'' ';
                           qry.open;
                           if qry.IsEmpty then
                              tvaid := '144'
                           else
                              tvaid := qry.fields[0].AsString;
                           qry.close;
                           qry.sql.text := ' Select TCT_ID ' +
                              ' from ARTTYPECOMPTABLE join k on (k_id=TCT_ID and k_enabled=1) ' +
                              ' Where TCT_NOM=''PRODUIT'' ';
                           qry.open;
                           if qry.isempty then
                              tctid := '138'
                           else
                              tctid := qry.fields[0].AsString;
                           qry.close;
                           qry.sql.text := 'select NEWNUM from ART_CHRONO';
                           qry.open;
                           chrono := qry.fields[0].asstring;
                           rapport.Add('Création article ' + Chrono + ' ---- ref fou : ' + tc.UneValeur(res, 'CTL_ARTCHRONO'));
                           arfid := insertT('artreference',
                              ['ARF_ID', 'ARF_ARTID', 'ARF_TVAID', 'ARF_TCTID',
                              'ARF_CREE', 'ARF_MODIF', 'ARF_CHRONO',
                                 'ARF_DIMENSION', 'ARF_MAGORG', 'ARF_FIDELITE'],
                                 [artid, tvaid, tctid,
                              'current_date', 'current_date', quotedstr(chrono),
                                 '1', inttostr(magid), '1']);

                           if MemD_ArticlesCTL_ARTTYPE.AsInteger = 3 then
                              gr_ligne := tc.select('select distinct CTC_COUL,CTC_LIBCOUL from catalogue_coultai where CTC_CTLID=' + MemD_ArticlesCTL_ID.AsString)
                           else
                              gr_ligne := tc.select('select distinct CTC_COUL,CTC_LIBCOUL from catalogue_coultai where CTC_CTLID=' + tc.UneValeur(res, 'CTL_ID'));
                           for i := 0 to tc.recordcount(gr_ligne) - 1 do
                           begin
                              couid := insertt('PLXCOULEUR',
                                 ['COU_ID', 'COU_ARTID', 'COU_CODE',
                                 'COU_NOM'],
                                    [artid, quotedstr(tc.UneValeur(gr_ligne, 'CTC_COUL', i)),
                                 quotedstr(tc.UneValeur(gr_ligne, 'CTC_LIBCOUL', i))]);

                              if MemD_ArticlesCTL_ARTTYPE.AsInteger <> 3 then
                              begin
                                 Gr_CB := tc.select('select CTC_TAI, CTC_EAN from catalogue_coultai where CTC_CTLID=' + tc.UneValeur(res, 'CTL_ID') +
                                    ' and CTC_COUL = "' + tc.UneValeur(gr_ligne, 'CTC_COUL', i) + '" ' +
                                    ' and CTC_LIBCOUL = "' + tc.UneValeur(gr_ligne, 'CTC_LIBCOUL', i) + '" ');
                           // CB fournisseur
                                 for j := 0 to tc.recordcount(gr_CB) - 1 do
                                 begin
                                    qry.close;
                                    qry.sql.text := 'Select TGF_ID ' +
                                       ' from PLXTAILLESGF Join k on (k_id=TGF_ID and K_ENABLED=1) ' +
                                       ' where TGF_ID <>0 ' +
                                       '   And upper(TGF_NOM) = ' + quotedstr(Uppercase(tc.unevaleur(Gr_CB, 'CTC_TAI', j))) +
                                       '   and TGF_GTFID = ' + gtfid;
                                    qry.Open;
                                    InsertT('artcodebarre',
                                       ['cbi_id', 'CBI_ARFID', 'CBI_TGFID', 'CBI_COUID',
                                       'CBI_CB', 'CBI_TYPE'],
                                          [arfid, qry.fields[0].asString, couid,
                                       quotedstr(tc.unevaleur(Gr_CB, 'CTC_EAN', j)), '3']);
                                 end;
                                 tc.freeresult(Gr_CB);
                              end;
                           // CB Ginkoia
                              Gr_CB := tc.select('select distinct CTC_TAI from catalogue_coultai where CTC_CTLID=' + tc.UneValeur(res, 'CTL_ID'));
                              for j := 0 to tc.recordcount(Gr_CB) - 1 do
                              begin
                                 qry.close;
                                 qry.sql.text := 'Select TGF_ID ' +
                                    ' from PLXTAILLESGF Join k on (k_id=TGF_ID and K_ENABLED=1) ' +
                                    ' where TGF_ID <>0 ' +
                                    '   And Upper(TGF_NOM) = ' + quotedstr(Uppercase(tc.unevaleur(Gr_CB, 'CTC_TAI', j))) +
                                    '   and TGF_GTFID = ' + gtfid;
                                 qry.Open;
                                 if not qry.isempty then
                                 begin
                                    qry2.close;
                                    qry2.sql.text := 'select NEWNUM from art_cb';
                                    qry2.open;
                                    ean := qry2.fields[0].asString;
                                    InsertT('artcodebarre',
                                       ['cbi_id', 'CBI_ARFID', 'CBI_TGFID', 'CBI_COUID',
                                       'CBI_CB', 'CBI_TYPE'],
                                          [arfid, qry.fields[0].asString, couid,
                                       quotedstr(ean), '1']);
                                 end;
                              end;
                              tc.freeresult(gr_CB);
                           end;
                           tc.freeresult(gr_ligne);



                           Gr_ligne := tc.select('select distinct CTC_PXACHT, CTC_PXVTE from catalogue_coultai where CTC_CTLID=' + tc.UneValeur(res, 'CTL_ID') + ' order by CTC_PXACHT');
                           if tc.recordCount(Gr_ligne) > 0 then
                           begin
                              S := tc.unevaleur(Gr_ligne, 'CTC_PXVTE');
                              if S = '' then s := '0';
                              while pos(',', s) > 0 do
                                 S[pos(',', s)] := '.';
                           end
                           else s := '0';
                           pvi := s;

                           insertt('TARPRIXVENTE',
                              ['PVT_ID', 'PVT_TVTID', 'PVT_ARTID', 'PVT_TGFID', 'PVT_PX'],
                              ['0', artid, '0', s]);

                           if tc.recordCount(Gr_ligne) > 0 then
                           begin
                              S := tc.unevaleur(Gr_ligne, 'CTC_PXACHT');
                              if S = '' then s := '0';
                              while pos(',', s) > 0 do
                                 S[pos(',', s)] := '.';
                           end
                           else
                              s := '0';
                           insertt('TarCLGFourn',
                              ['CLG_ID', 'CLG_ARTID', 'CLG_FOUID', 'CLG_TGFID',
                              'CLG_PX', 'CLG_PXNEGO', 'CLG_PXVI', 'CLG_PRINCIPAL'],
                                 [artid, fouid, '0',
                              s, s, pvi, '1']);

                           if MemD_ArticlesCTL_ARTTYPE.AsInteger <> 3 then
                           begin
                              if tc.recordcount(Gr_ligne) > 1 then
                              begin
                                 tc.freeresult(Gr_Ligne);
                                 lastt := '';
                                 Gr_ligne := tc.select('select distinct CTC_TAI, CTC_PXACHT from catalogue_coultai where CTC_CTLID=' + tc.UneValeur(res, 'CTL_ID') + ' order by CTC_TAI,CTC_PXACHT');
                                 for i := 0 to tc.recordcount(Gr_ligne) - 1 do
                                 begin
                                    if tc.unevaleur(Gr_ligne, 'CTC_TAI', i) <> lastt then
                                    begin
                                       qry.close;
                                       qry.sql.text := 'Select TGF_ID ' +
                                          ' from PLXTAILLESGF Join k on (k_id=TGF_ID and K_ENABLED=1) ' +
                                          ' where TGF_ID <>0 ' +
                                          '   And upper(TGF_NOM) = ' + quotedstr(Uppercase(tc.unevaleur(Gr_ligne, 'CTC_TAI', i))) +
                                          '   and TGF_GTFID = ' + gtfid;
                                       qry.Open;
                                       S := tc.unevaleur(Gr_ligne, 'CTC_PXACHT', i);
                                       if S = '' then s := '0';
                                       while pos(',', s) > 0 do
                                          S[pos(',', s)] := '.';
                                       insertt('TarCLGFourn',
                                          ['CLG_ID', 'CLG_ARTID', 'CLG_FOUID', 'CLG_TGFID',
                                          'CLG_PX', 'CLG_PXNEGO', 'CLG_PXVI', 'CLG_PRINCIPAL'],
                                             [artid, fouid, qry.fields[0].asstring,
                                          s, s, '0', '1']);
                                    end;
                                    lastt := tc.unevaleur(Gr_ligne, 'CTC_TAI', i);
                                 end;
                              end;
                           end;
                           tc.freeresult(Gr_Ligne);

                           insertT('genimport',
                              ['IMP_ID', 'IMP_GINKOIA', 'IMP_KTBID', 'IMP_REF', 'IMP_NUM'],
                              [artid, '-11111375', tc.UneValeur(res, 'CTL_ID'), '10']);
                           MemD_Lignes.edit;
                           MemD_LignesART_ID.AsString := artid;
                           MemD_LignesART_type.AsInteger := MemD_ArticlesCTL_ARTTYPE.AsInteger;
                           MemD_LignesCTL_ID.AsString := tc.UneValeur(res, 'CTL_ID');
                           MemD_Lignes.post;
                        end;
                     end
                     else
                     begin
                        MemD_Lignes.edit;
                        MemD_LignesART_ID.AsInteger := Qry.fields[0].asinteger;
                        MemD_LignesART_type.AsInteger := MemD_ArticlesCTL_ARTTYPE.AsInteger;
                        if MemD_ArticlesCTL_ARTTYPE.AsInteger = 3 then
                           MemD_LignesCTL_ID.AsString := MemD_ArticlesCTL_ARTPACK.AsString
                        else
                           MemD_LignesCTL_ID.AsString := MemD_ArticlesCTL_ID.AsString;
                        MemD_Lignes.post;
                     end;
                  end;
               end;
               MemD_Lignes.next;
            end;

            // création de la commande
            {
            qry.close;
            qry.sql.text := 'select EXE_ID from GENEXERCICECOMMERCIAL ' +
               Format('where %s between EXE_DEBUT and EXE_FIN', [Quotedstr(FormatDatetime('MM/DD/YYYY', Date))]);
            qry.open;

            if qry.IsEmpty then
            begin
               qry.close;
               qry.sql.text := 'select EXE_ID from GENEXERCICECOMMERCIAL ' +
                  'where EXE_ID<>0 ORDER BY EXE_DEBUT DESC';
               qry.open;
            end;
            EXE_ID := qry.Fields[0].AsString;
            }

            qry.close;
            qry.sql.text := ' Select FOU_ID' +
               ' from artfourn Join k on (k_id=FOU_ID and K_ENABLED=1)' +
               ' Join GENIMPORT ' +
               ' join k ' +
               ' Join ktb on (IMP_KTBID=KTB_ID) ' +
               ' on (k_id=imp_id and k_enabled=1) ' +
               ' on (fou_ID=IMP_GINKOIA) ' +
               ' where fou_id<>0 ' +
               ' and KTB_NAME = ''ARTFOURN'' ' +
               ' And IMP_NUM = 10 ' +
               ' and IMP_REF = ' + MemD_EnteteLNR.AsString;
            qry.open;
            fouid := qry.fields[0].AsString;
            dliv := Copy(dliv, 5, 2) + '/' + Copy(dliv, 7, 2) + '/' + Copy(dliv, 1, 4);
            // CPAID --> 234
            // -101408013 -> pré saison
            // -101408014 -> ré assort

            if not (Cb_Commande.Checked) then
            begin
               qry.close;
               qry.sql.text := 'SELECT NEWNUM FROM BC_NEWNUM';
               qry.Open;
               S := qry.fields[0].AsString;
               rapport.Add('Création de la commande ' + s + '  référence : ' + MemD_EnteteBNR.AsString);

               if rb_etee.Checked then
                  cdeid := insertt('COMBCDE',
                     ['CDE_ID', 'CDE_NUMERO', 'CDE_EXEID', 'CDE_CPAID',
                     'CDE_MAGID', 'CDE_FOUID', 'CDE_NUMFOURN', 'CDE_DATE',
                        'CDE_FRANCO', 'CDE_LIVRAISON', 'CDE_TYPID'],
                        [quotedstr(s), EXE_ID, '234',
                     inttostr(magid), fouid, quotedstr(MemD_EnteteBNR.AsString), 'current_date',
                        '1', quotedstr(Dliv), '-101408013'])
               else
                  cdeid := insertt('COMBCDE',
                     ['CDE_ID', 'CDE_NUMERO', 'CDE_EXEID', 'CDE_CPAID',
                     'CDE_MAGID', 'CDE_FOUID', 'CDE_NUMFOURN', 'CDE_DATE',
                        'CDE_FRANCO', 'CDE_LIVRAISON', 'CDE_TYPID', 'CDE_SAISON'],
                        [quotedstr(s), EXE_ID, '234',
                     inttostr(magid), fouid, quotedstr(MemD_EnteteBNR.AsString), 'current_date',
                        '1', quotedstr(Dliv), '-101408013', '1']);
            end
            else
            begin
               rapport.Add('Pré-Création de la commande référence : ' + MemD_EnteteBNR.AsString);
            end;
            prix := 0;
            MemD_Lignes.first;
            while not MemD_Lignes.eof do
            begin
               pb3.position := pb3.position + 1;
               if MemD_LignesID_ENT.AsInteger = MemD_Entete.fields[0].asInteger then
               begin
                  if MemD_LignesART_ID.AsInteger = 0 then
                  begin
                     rapport.Add('***************************************');
                     rapport.Add('Probleme Sur l''article  ' + MemD_LignesANR.AsString);
                     rapport.Add(MemD_LignesAB1.AsString);
                     rapport.Add('Taille : ' + Uppercase(MemD_LignesKOL.AsString));
                     rapport.Add('Couleur : ' + MemD_LignesFNR.AsString);
                     rapport.Add(MemD_LignesFB1.AsString);
                     rapport.Add('Qte : ' + MemD_LignesAUM.AsString);
                     rapport.Add('Px Achat : ' + MemD_LignesEKP.AsString);
                     rapport.Add('Px Vente : ' + MemD_LignesDVP.AsString);
                     rapport.Add('Code EAN : ' + MemD_LignesEAN.AsString);
                     rapport.Add('l''article n''exite pas dans les catalogues ');
                     rapport.Add('***************************************');
                  end
                  else
                  begin
                     tgfid := '';
                     couid := '';
                     if MemD_LignesART_TYPE.AsInteger = 3 then
                     begin
                        qry.close;
                        // fabrication d'une query vide pour passer par création coul/taille
                        qry.sql.text := 'select K_ID CBI_TGFID, KRH_ID CBI_COUID ' +
                           ' from k                                 ' +
                           ' where (k_id=-1) and (k_id=-2)          ';
                        qry.open;
                     end
                     else
                     begin
                        qry.close;
                        qry.sql.text := 'select CBI_TGFID, CBI_COUID ' +
                           ' from artcodebarre join k on (k_id=cbi_id and k_enabled=1) ' +
                           ' join artreference on (arf_id=cbi_arfid) ' +
                           ' where cbi_type=3 ' +
                           ' and arf_artid = ' + MemD_LignesART_ID.AsString +
                           ' and cbi_cb = ' + quotedstr(MemD_LignesEAN.AsString);
                        qry.open;
                     end;
                     if qry.isempty then
                     begin
                       // creation de la taille // ean.
                       // recherche couid
                        qry.close;
                        qry.sql.text := ' select COU_ID ' +
                           ' from PLXCOULEUR join k on(k_id=cou_id and k_enabled=1) ' +
                           ' where cou_artid = ' + MemD_LignesART_ID.AsString +
                           ' and COU_CODE = ' + quotedstr(MemD_LignesFNR.asString);
                        qry.open;
                        if qry.isempty then
                        begin
                          // création de la couleur
                           couid := insertt('PLXCOULEUR',
                              ['COU_ID', 'COU_ARTID', 'COU_CODE',
                              'COU_NOM'],
                                 [MemD_LignesART_ID.AsString, quotedstr(MemD_LignesFNR.asString),
                              quotedstr(MemD_LignesFB1.asString)]);
                          // créer les CB pour Ginkoia
                           qry.close;
                           qry.sql.text := ' select arf_id, TTV_TGFID, Cou_id ' +
                              ' from plxcouleur join k on (k_id=cou_id and k_enabled=1) ' +
                              ' join artreference on (arf_artid=cou_artid) ' +
                              ' join plxtaillestrav join k on (k_id=ttv_id and k_enabled=1) ' +
                              ' on (ttv_artid=arf_artid) ' +
                              ' where Cou_ARTID = ' + MemD_LignesART_ID.AsString +
                              ' and not exists ( ' +
                              ' select * from artcodebarre join k on (k_id=cbi_id and k_enabled=1) ' +
                              ' where cbi_arfid=artreference.arf_id ' +
                              '    and cbi_couid=plxcouleur.cou_id ' +
                              '    and cbi_tgfid=plxtaillestrav.ttv_tgfid ' +
                              '    and cbi_type=1) ';
                           qry.open;
                           while not qry.eof do
                           begin
                              qry2.close;
                              qry2.sql.text := 'select NEWNUM from art_cb';
                              qry2.open;
                              ean := qry2.fields[0].asString;
                              InsertT('artcodebarre',
                                 ['cbi_id', 'CBI_ARFID', 'CBI_TGFID', 'CBI_COUID',
                                 'CBI_CB', 'CBI_TYPE'],
                                    [qry.fields[0].asstring, qry.fields[1].asString, qry.fields[2].asString,
                                 quotedstr(ean), '1']);
                              qry.next;
                           end;
                           qry.close;
                           qry.sql.text := ' select COU_ID ' +
                              ' from PLXCOULEUR join k on(k_id=cou_id and k_enabled=1) ' +
                              ' where cou_artid = ' + MemD_LignesART_ID.AsString +
                              ' and COU_CODE = ' + quotedstr(MemD_LignesFNR.asString);
                           qry.open;
                        end;

                        if not qry.isempty then
                        begin
                           couid := qry.fields[0].AsString;
                           qry.close;
                           if MemD_LignesART_TYPE.AsInteger <> 3 then
                           begin
                              Qry.sql.text := ' select tgf_id, arf_id' +
                                 ' from artarticle join plxtaillesgf on (Art_gtfid=TGF_gtfid) ' +
                                 ' join k on (k_id=tgf_id and k_enabled=1) ' +
                                 ' join artreference on (arf_artid=art_id) ' +
                                 ' where art_id= ' + MemD_LignesART_ID.AsString +
                                 ' and Upper(tgf_nom)= ' + quotedstr(Uppercase(MemD_LignesKOL.asString));
                              Qry.Open;
                              if Qry.isempty then
                              begin
                                 // essayons de créer la taille
                                 Qry.close;
                                 qry.sql.text := ' select Art_gtfid ' +
                                    ' from artarticle ' +
                                    ' where art_id= ' + MemD_LignesART_ID.AsString;
                                 qry.open;
                                 gtfid := qry.fields[0].asString;
                                 Qry.close;
                                 ordre := '';
                                 Qry.Sql.text := ' select * ' +
                                    ' from plxtaillesgf join k on (k_id=tgf_id and k_enabled=1) ' +
                                    ' where TGF_ORDREAFF = ' + MemD_LignesRAN.AsString +
                                    ' and tgf_gtfid = ' + gtfid;
                                 qry.open;
                                 if not qry.isempty then
                                 begin
                                    Qry.close;
                                    Qry.Sql.text := ' select * ' +
                                       ' from plxtaillesgf join k on (k_id=tgf_id and k_enabled=1) ' +
                                       ' where TGF_ORDREAFF = ' + MemD_LignesRAN.AsString + ' +0.9' +
                                       ' and tgf_gtfid = ' + gtfid;
                                    qry.open;
                                    if not qry.isempty then
                                    begin
                                       Qry.close;
                                       Qry.Sql.text := ' select * ' +
                                          ' from plxtaillesgf join k on (k_id=tgf_id and k_enabled=1) ' +
                                          ' where TGF_ORDREAFF = ' + MemD_LignesRAN.AsString + ' +0.8' +
                                          ' and tgf_gtfid = ' + gtfid;
                                       qry.open;
                                       if not qry.isempty then
                                       begin
                                          Qry.close;
                                          Qry.Sql.text := ' select * ' +
                                             ' from plxtaillesgf join k on (k_id=tgf_id and k_enabled=1) ' +
                                             ' where TGF_ORDREAFF = ' + MemD_LignesRAN.AsString + ' +0.7' +
                                             ' and tgf_gtfid = ' + gtfid;
                                          qry.open;
                                          if qry.isEmpty then
                                             ordre := MemD_LignesRAN.AsString + ' +0.7 '
                                       end
                                       else
                                          ordre := MemD_LignesRAN.AsString + ' +0.8 '
                                    end
                                    else
                                       ordre := MemD_LignesRAN.AsString + ' +0.9 '
                                 end
                                 else
                                    ordre := MemD_LignesRAN.AsString;
                                 if ordre <> '' then
                                 begin
                                    // ajout de la taille ;
                                    insertT('PLXTAILLESGF',
                                       ['TGF_ID', 'TGF_GTFID', 'TGF_TGFID', 'TGF_NOM', 'TGF_ORDREAFF', 'TGF_STAT'],
                                       [gtfid, 'result', quotedstr(Uppercase(MemD_LignesKOL.AsString)),
                                       ordre, ordre]);
                                    qry.close;
                                 // créer les CB pour ginkoia
                                    qry.sql.text := ' select arf_id, TTV_TGFID, Cou_id ' +
                                       ' from plxcouleur join k on (k_id=cou_id and k_enabled=1) ' +
                                       ' join artreference on (arf_artid=cou_artid) ' +
                                       ' join plxtaillestrav join k on (k_id=ttv_id and k_enabled=1) ' +
                                       ' on (ttv_artid=arf_artid) ' +
                                       ' where Cou_ARTID = ' + MemD_LignesART_ID.AsString +
                                       ' and not exists ( ' +
                                       ' select * from artcodebarre join k on (k_id=cbi_id and k_enabled=1) ' +
                                       ' where cbi_arfid=artreference.arf_id ' +
                                       '    and cbi_couid=plxcouleur.cou_id ' +
                                       '    and cbi_tgfid=plxtaillestrav.ttv_tgfid ' +
                                       '    and cbi_type=1) ';
                                    qry.open;
                                    while not qry.eof do
                                    begin
                                       qry2.close;
                                       qry2.sql.text := 'select NEWNUM from art_cb';
                                       qry2.open;
                                       ean := qry2.fields[0].asString;
                                       InsertT('artcodebarre',
                                          ['cbi_id', 'CBI_ARFID', 'CBI_TGFID', 'CBI_COUID',
                                          'CBI_CB', 'CBI_TYPE'],
                                             [qry.fields[0].asstring, qry.fields[1].asString, qry.fields[2].asString,
                                          quotedstr(ean), '1']);
                                       qry.next;
                                    end;
                                    qry.close;

                                    Qry.sql.text := ' select tgf_id, arf_id' +
                                       ' from artarticle join plxtaillesgf on (Art_gtfid=TGF_gtfid) ' +
                                       ' join k on (k_id=tgf_id and k_enabled=1) ' +
                                       ' join artreference on (arf_artid=art_id) ' +
                                       ' where art_id= ' + MemD_LignesART_ID.AsString +
                                       ' and upper(tgf_nom)= ' + quotedstr(Uppercase(MemD_LignesKOL.asString));
                                    Qry.Open;
                                 end
                                 else
                                    qry.close;
                              end;
                              if qry.Active and (not Qry.isempty) then
                              begin
                                 tgfid := qry.fields[0].AsString;
                                 arfid := qry.fields[1].AsString;
                                 qry.close;
                                 qry.sql.text := ' Select * ' +
                                    ' from plxtaillestrav join k on (TTV_ID=K_ID and k_enabled=1) ' +
                                    ' where ttv_artid=' + MemD_LignesART_ID.AsString +
                                    ' and ttv_tgfid=' + tgfid;
                                 qry.open;
                                 if qry.isempty then
                                 begin
                                    insertT('PLXTAILLESTRAV',
                                       ['TTV_ID', 'TTV_ARTID', 'TTV_TGFID'],
                                       [MemD_LignesART_ID.AsString, tgfid]);
                                    qry.close;
                                 // créer les CB pour ginkoia
                                    qry.sql.text := ' select arf_id, TTV_TGFID, Cou_id ' +
                                       ' from plxcouleur join k on (k_id=cou_id and k_enabled=1) ' +
                                       ' join artreference on (arf_artid=cou_artid) ' +
                                       ' join plxtaillestrav join k on (k_id=ttv_id and k_enabled=1) ' +
                                       ' on (ttv_artid=arf_artid) ' +
                                       ' where Cou_ARTID = ' + MemD_LignesART_ID.AsString +
                                       ' and not exists ( ' +
                                       ' select * from artcodebarre join k on (k_id=cbi_id and k_enabled=1) ' +
                                       ' where cbi_arfid=artreference.arf_id ' +
                                       '    and cbi_couid=plxcouleur.cou_id ' +
                                       '    and cbi_tgfid=plxtaillestrav.ttv_tgfid ' +
                                       '    and cbi_type=1) ';
                                    qry.open;
                                    while not qry.eof do
                                    begin
                                       qry2.close;
                                       qry2.sql.text := 'select NEWNUM from art_cb';
                                       qry2.open;
                                       ean := qry2.fields[0].asString;
                                       InsertT('artcodebarre',
                                          ['cbi_id', 'CBI_ARFID', 'CBI_TGFID', 'CBI_COUID',
                                          'CBI_CB', 'CBI_TYPE'],
                                             [qry.fields[0].asstring, qry.fields[1].asString, qry.fields[2].asString,
                                          quotedstr(ean), '1']);
                                       qry.next;
                                    end;
                                 end;
                                 if trim(MemD_LignesEAN.AsString) <> '' then
                                 begin
                                    InsertT('artcodebarre',
                                       ['cbi_id', 'CBI_ARFID', 'CBI_TGFID', 'CBI_COUID',
                                       'CBI_CB', 'CBI_TYPE'],
                                          [arfid, tgfid, couid,
                                       quotedstr(MemD_LignesEAN.AsString), '3']);
                                 end;
                              end;
                           end;
                        end;
                     end
                     else
                     begin
                        tgfid := qry.fields[0].AsString;
                        Couid := qry.fields[1].AsString;
                     end;


                     if (MemD_LignesART_TYPE.AsInteger <> 3) and ((tgfid = '') or (couid = '')) then
                     begin
                        rapport.Add('***************************************');
                        rapport.Add('Probleme une taille de l''article ' + MemD_LignesANR.AsString);
                        rapport.Add(MemD_LignesAB1.AsString);
                        rapport.Add('Taille : ' + Uppercase(MemD_LignesKOL.AsString));
                        rapport.Add('Couleur : ' + MemD_LignesFNR.AsString);
                        rapport.Add(MemD_LignesFB1.AsString);
                        rapport.Add('Qte : ' + MemD_LignesAUM.AsString);
                        rapport.Add('Px Achat : ' + MemD_LignesEKP.AsString);
                        rapport.Add('Px Vente : ' + MemD_LignesDVP.AsString);
                        rapport.Add('Code EAN : ' + MemD_LignesEAN.AsString);
                        rapport.Add('***************************************');
                     end
                     else
                     begin
                        dliv := trim(MemD_LignesLDA.AsString);
                        dliv := Copy(dliv, 5, 2) + '/' + Copy(dliv, 7, 2) + '/' + Copy(dliv, 1, 4);
                        if not (Cb_Commande.Checked) then
                        begin
                           if (MemD_LignesART_TYPE.AsInteger <> 3) then
                           begin
                              insertt('COMBCDEL',
                                 ['CDL_ID', 'CDL_CDEID', 'CDL_ARTID',
                                 'CDL_TGFID', 'CDL_COUID',
                                    'CDL_QTE', 'CDL_PXCTLG', 'CDL_PXACHAT',
                                    'CDL_TVA', 'CDL_PXVENTE',
                                    'CDL_LIVRAISON'],
                                    [cdeid, MemD_LignesART_ID.AsString,
                                 tgfid, couid,
                                    MemD_LignesAUM.AsString, MemD_LignesEKP.AsString, MemD_LignesEKP.AsString,
                                    '19.6', MemD_LignesDVP.AsString,
                                    quotedstr(dliv)]);
                              prix := prix + (MemD_LignesEKP.AsFloat * MemD_LignesAUM.AsFloat);
                           end
                           else
                           begin
                             // pour un pack boucler sur les lignes du pack
                             // ID du pack dans MemD_LignesCTL_ID.AsString
                             // Attention 2 cas :
                             // si taille = T.U alors c'est toutes les tailles
                             // si taille renseigné c'est que cette taille
                              S := 'select CTC_TAI, PCK_QTE  ' +
                                 ' from packs join catalogue_coultai on (CTC_ID = PCK_CTCID)' +
                                 ' where PCK_CTLARTID = ' + MemD_LignesCTL_ID.AsString;
                              if Uppercase(MemD_LignesKOL.asString) <> 'T.U' then
                              begin
                                 s := s + ' and CTC_TAI = ' + QuotedStr(Uppercase(MemD_LignesKOL.asString));
                              end;
                              artpack := tc.select(s);
                              if tc.recordCount(artpack) = 0 then
                              begin
                                 rapport.Add('************************************************');
                                 rapport.Add('Le pack ' + MemD_LignesANR.AsString + ' Ne peut pas être importée dans la commande');
                                 rapport.Add('Il fait référence à une taille inconnue ');
                                 rapport.Add(MemD_LignesAB1.AsString);
                                 rapport.Add('Taille : ' + Uppercase(MemD_LignesKOL.AsString));
                                 rapport.Add('Couleur : ' + MemD_LignesFNR.AsString);
                                 rapport.Add(MemD_LignesFB1.AsString);
                                 rapport.Add('Qte : ' + MemD_LignesAUM.AsString);
                                 rapport.Add('Px Achat : ' + MemD_LignesEKP.AsString);
                                 rapport.Add('Px Vente : ' + MemD_LignesDVP.AsString);
                                 rapport.Add('Code EAN : ' + MemD_LignesEAN.AsString);
                                 rapport.Add('***********************************************');
                              end
                              else
                              begin
                                 nbrartpack := 0;
                                 for i := 0 to tc.recordCount(artpack) - 1 do
                                    nbrartpack := nbrartpack + tc.UneValeurEntiere(artpack, 'PCK_QTE', i);
                                 if nbrartpack = 0 then nbrartpack := 1;
                                 for i := 0 to tc.recordCount(artpack) - 1 do
                                 begin
                                 // recherche de la taille
                                    Qry.sql.text := ' select tgf_id, arf_id' +
                                       ' from artarticle join plxtaillesgf on (Art_gtfid=TGF_gtfid) ' +
                                       ' join k on (k_id=tgf_id and k_enabled=1) ' +
                                       ' join artreference on (arf_artid=art_id) ' +
                                       ' where art_id= ' + MemD_LignesART_ID.AsString +
                                       ' and upper(tgf_nom)= ' + quotedstr(Uppercase(tc.UneValeur(artpack, 'CTC_TAI', i)));
                                    Qry.Open;
                                    if not qry.isempty then
                                    begin
                                       insertt('COMBCDEL',
                                          ['CDL_ID', 'CDL_CDEID', 'CDL_ARTID',
                                          'CDL_TGFID', 'CDL_COUID',
                                             'CDL_QTE', 'CDL_PXCTLG', 'CDL_PXACHAT',
                                             'CDL_TVA', 'CDL_PXVENTE',
                                             'CDL_LIVRAISON'],
                                             [cdeid, MemD_LignesART_ID.AsString,
                                          Qry.fields[0].AsString, couid,
                                             Floattostr(MemD_LignesAUM.AsFloat * tc.UneValeurEntiere(artpack, 'PCK_QTE', i)),
                                             Floattostr(MemD_LignesEKP.AsFloat / nbrartpack), Floattostr(MemD_LignesEKP.AsFloat / nbrartpack),
                                             '19.6', Floattostr(MemD_LignesDVP.AsFloat / NbrArtPack),
                                             quotedstr(dliv)]);
                                    end
                                    else
                                    begin
                                    end;
                                 end;
                                 prix := prix + (MemD_LignesEKP.AsFloat * MemD_LignesAUM.AsFloat);
                              end;
                              tc.FreeResult(artpack);
                           end;
                        end;
                        if COLID <> '0' then
                        begin
                           qry.close;
                           qry.sql.text := 'Select * from artcolart join k on (k_id=car_id and k_enabled=1) ' +
                              ' where car_artid = ' + MemD_LignesART_ID.AsString +
                              ' and car_colid = ' + colid;
                           qry.open;
                           if qry.isempty then
                           begin
                              insertt('ARTCOLART', ['CAR_ID', 'CAR_ARTID', 'CAR_COLID'],
                                 [MemD_LignesART_ID.AsString, COLID]);
                           end;
                        end;
                     end;
                  end;
               end;
               MemD_Lignes.next;
            end;
            if not (Cb_Commande.Checked) then
            begin
               qry.close;
               qry.sql.text := 'update combcde ' +
                  ' set CDE_TVAHT1= ' + floattostr(prix) + ',' +
                  ' CDE_TVATAUX1=19.6,' +
                  ' CDE_TVA1=' + floattostr(prix * 0.196) +
                  ' where cde_id=' + cdeid;
               qry.execsql;
            end;
            rapport.Add('Montant de la commande ' + floattostr(prix));
            rapport.Add('');
            if tran.Active and tran.InTransaction then
            begin
               tran.commit;
               tran.active := true;
            end;
            MemD_Entete.next;
         end;
      end
      else
         result := false;
   end
   else
      result := false;
   findclose(f);
   LesArticles.free;
   tc.free;
end;

procedure Tfrm_Imp_Inter.Button1Click(Sender: TObject);
var
   f: TSearchRec;
   tc: Tconnexion;
begin
   Enabled := false;
   rapport := tstringlist.create;
   try
      rapport.add('Importation intersport le ' + Datetimetostr(now));
      rapport.add('   ==================   ');
      rapport.add('');
      tc := Tconnexion.create;
      tc.Base := 'ginkoia_db2';
// a enlever
//   tc.HttpPath := 'http://localhost/intersport/' ;

      lesfou := tc.Select('SELECT DISTINCT FOU_NUM, FOU_NOM' +
         ' FROM fournisseurs ' +
         ' JOIN catalogue ON ( CAT_FOUID = FOU_NUM and CAT_VALID=1) ' +
         ' JOIN catalogue_lig ON ( CTL_CATID = CAT_ID ) ');
      tc.free;
      try
         lesbases := tstringlist.create;
         if findfirst(ed_Rep.text + '*.zip', faAnyFile, f) = 0 then
         begin
            repeat
               rapport.add('Fichier : ' + F.Name);

               Lab_et1.Caption := 'Traitement de ' + F.Name; Lab_et1.Update;
               ForceDirectories(trim(ed_Rep.text + Changefileext(f.name, '')));
               zip.ZipFileName := ed_Rep.text + f.name;
               zip.ExtrBaseDir := trim(ed_Rep.text + Changefileext(f.name, '')) + '\';
               zip.Extract;
               if importation(trim(ed_Rep.text + Changefileext(f.name, '')) + '\') then
               begin
                  rapport.add('Importation OK');
                  rapport.add('  ');
                  ForceDirectories(ed_Rep.text + 'OK');
                  MoveFile(Pchar(ed_Rep.text + f.name), Pchar(ed_Rep.text + 'OK\' + f.name));
               end
               else
               begin
                  ForceDirectories(ed_Rep.text + 'PROBLEME');
                  MoveFile(Pchar(ed_Rep.text + f.name), Pchar(ed_Rep.text + 'PROBLEME\' + f.name));
                  rapport.add('Probleme à l''importation');
                  rapport.add('  ');
               end;
            until findnext(f) <> 0;
         end;
         findclose(f);
         lesbases.free;
      finally
         rapport.Savetofile(IncludeTrailingBackslash(extractfilepath(application.exename)) + 'RAP_' +
            FormatDateTime('dd_mm_yy-hh_nn', Now) + '.txt');
         rapport.free;
      end;
   finally
      Enabled := true;
   end;
   Application.MessageBox('C''est fini', 'fin', Mb_OK);
end;

procedure Tfrm_Imp_Inter.FormCreate(Sender: TObject);
begin
   LesAdherent := TstringList.create;
   if fileexists(changefileext(application.exename, '.ini')) then
      LesAdherent.Loadfromfile(changefileext(application.exename, '.ini'));
end;

initialization
   DecimalSeparator := '.';
end.

