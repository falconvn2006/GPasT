//$Log:
// 2    Utilitaires1.1         25/02/2009 11:04:33    Bruno NICOLAFRANSCECO
//      Traif TO sport 2000
// 1    Utilitaires1.0         19/12/2006 08:48:55    pascal          
//$
//$NoKeywords$
//
unit main_frm;

interface

uses
   xml_unit, IcXMLParser, Client_frm,
   fileutil,
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   StdCtrls, IBDatabase, Db, ComCtrls, IBCustomDataSet, IBQuery, IBSQL,
   IBStoredProc, IpUtils, IpSock, IpFtp;

type
   TFrm_Main = class(TForm)
      Label1: TLabel;
      data: TIBDatabase;
      tran: TIBTransaction;
      Pb: TProgressBar;
      qry: TIBQuery;
      sql: TIBSQL;
      IBST_CB: TIBStoredProc;
      IBSt_LOC: TIBStoredProc;
      lb: TListBox;
      Label2: TLabel;
      Button2: TButton;
      Button3: TButton;
      qry2: TIBQuery;
      IpFtp: TIpFtpClient;
      Button1: TButton;
      procedure FormCreate(Sender: TObject);
      procedure Button2Click(Sender: TObject);
      procedure lbDblClick(Sender: TObject);
      procedure Button3Click(Sender: TObject);
      procedure IpFtpFtpStatus(Sender: TObject; StatusCode: TIpFtpStatusCode;
         const Info: string);
      procedure Button1Click(Sender: TObject);
   private
      procedure FaireListeFichier;
      procedure RecupLeFichier(S, path: string);
    { Déclarations privées }
   public
    { Déclarations publiques }
      Lesbase: TmonXML;
      ListeFichierFtp: TstringList;
      function integration(fichier: string): Boolean;
      function id_table(table: string): string;
      function ktb_table(table: string): string;
      function existe(ktbid: string; id: string): string;
      function existestr(ktbid: string; id: string): string;
      procedure addGenimport(ktbid, ginid, id: string);
      procedure addGenimportstr(ktbid, ginid, id: string);
      function unkversion(id: string): string;
      function reformatDate(d: string): string;
      function enfloat(s: string): string;
   end;

var
   Frm_Main: TFrm_Main;

implementation
{$R *.DFM}
const
   RepSp2000 = '/tarifTO/';

{ TFrm_Main }

function TFrm_Main.integration(fichier: string): Boolean;
var
   tsl: tstringlist;
   xml: TmonXML;
   doc: TIcXMLElement;
   base: TIcXMLElement;
   adh: string;
   _to: TIcXMLElement;
   Cltid: string;
   chrono: string;
   adrid: string;
   s: string;
   s1, s2: string;
   cbiid: string;
   ktbid: string;
   _n1: TIcXMLElement;
   _n2: TIcXMLElement;
   _n3: TIcXMLElement;
   rapid: string;
   fapid: string;
   comid: string;
   prdid: string;
   TVAID: string;
   TCTID: string;
   _periode: TIcXMLElement;
   _tarif: TIcXMLElement;
   perid: string;
   trfid: string;
   trlid: string;
   kversion: string;
   lpnid: string;
   duree: string;
   mtaid:string;
   numgt:string;
begin
   result := False;
   tsl := tstringlist.create;
   tsl.loadfromfile(fichier);
   if Copy(TSL[0], 1, length('<?xml version')) <> '<?xml version' then
   begin
      tsl.Insert(0, '<?xml version="1.0" encoding="ISO-8859-1"?>');
      tsl.savetofile(fichier);
   end;
   tsl.free;
   xml := TmonXML.create;
   xml.LoadFromFile(fichier);
   doc := xml.find('/Document');
   adh := xml.ValueTag(doc, 'CODE_ADHERENT');
   base := lesbase.find('/theo/bases').GetFirstChild;
   while (base <> nil) and (base.GetAttributeNode('adh').Value <> adh) do
      base := base.NextSibling;
   if base <> nil then
   begin
      result := true;
      Label1.caption := 'Intégration de ' + lesbase.ValueTag(base, 'nom');
      Label1.Update;
      data.DatabaseName := lesbase.ValueTag(base, 'database');
      data.open;
      tran.active := true;

      mtaid:=lesbase.ValueTag(base, 'mta_id');
      IF mtaid='' THEN mtaid:='0';
      numgt:=lesbase.ValueTag(base, 'numGT');
      IF numgt='' THEN numgt:='0';

      qry.close;
      qry.sql.text := 'Select TVA_ID from ARTTVA join k on (k_id=TVA_ID and k_ENABled=1) where TVA_TAUX=19.6';
      qry.Open;
      TVAID := qry.fields[0].AsString;
      qry.close;
      qry.sql.text := 'Select TCT_ID from ARTTYPECOMPTABLE join k on (k_id=TCT_ID and k_ENABled=1) where TCT_NOM=' + quotedstr('LOCATION');
      qry.Open;
      TCTID := qry.fields[0].AsString;

      _to := xml.FindTag(doc, 'TOS');
      pb.Position := 0;
      pb.Max := xml.NbEnfants(_to);
      _to := xml.FindTag(_to, 'TO');
      while _to <> nil do
      begin
        // import = 15
         pb.Position := pb.Position + 1; update;
         ktbid := ktb_table('CLTCLIENT');
         s := xml.ValueTag(_to, 'NOM');
         cltid := existe(ktbid, xml.ValueTag(_to, 'ID'));
         if cltid = '' then
         begin
            Cltid := id_table('CLTCLIENT');
            qry.close;
            qry.Sql.text := 'Select NEWNUM FROM CLIENT_CHRONO';
            qry.open;
            chrono := qry.fields[0].AsString;
            adrid := id_table('GENADRESSE');
            Sql.sql.Text := 'Insert into GENADRESSE ' +
               ' (ADR_ID, ADR_VILID) Values  (' + adrid + ',0)';
            sql.ExecQuery;

            Sql.Sql.text := 'INSERT INTO CLTCLIENT (' +
               'CLT_ID, CLT_GCLID, CLT_NUMERO, CLT_NOM, CLT_PRENOM,' +
               'CLT_CIVID, CLT_ADRID, CLT_NAISSANCE, CLT_TYPE, CLT_CLTID,' +
               'CLT_COMPTA, CLT_BL, CLT_FIDELITE, CLT_COMMENT, CLT_TELEPHONE,' +
               'CLT_TELTRAVAIL_FAX, CLT_TELPORTABLE, CLT_EMAIL, CLT_PREMIERPASS, CLT_DERNIERPASS,' +
               'CLT_ECAUTORISE, CLT_CPTBLOQUE, CLT_AFADRID, CLT_AFTELEPHONE, CLT_AFFAX,' +
               'CLT_AFEMAIL, CLT_AFAUTRE, CLT_RETRAIT, CLT_MRGID, CLT_CPAID,' +
               'CLT_RIBBANQUE, CLT_RIBGUICHET, CLT_RIBCOMPTE, CLT_RIBCLE, CLT_RIBDOMICILIATION,' +
               'CLT_CODETVA, CLT_ICLID1, CLT_ICLID2, CLT_ICLID3, CLT_ICLID4,' +
               'CLT_ICLID5, CLT_NUMFACTOR, CLT_DATECF, CLT_ADRLIV, CLT_MAGID,' +
               'CLT_ARCHIVE, CLT_RESID, CLT_STAADRID, CLT_ORGID, CLT_NUMCB,' +
               'CLT_NBJLOC, CLT_CLIPROLOCATION, CLT_TOFACTURATION,CLT_LOCREMISE,CLT_VTEREMISE,' +
               'CLT_TOCLTID, CLT_IDTHEO,CLT_TOSUPPLEMENT,CLT_NMODIF,CLT_DUREEVO,' +
               'CLT_DUREEVODATE, CLT_VTEREMISEPRO, CLT_MDP, CLT_DEBUTSEJOURVO, CLT_REFDYNA' +
               ') Values (' +
               cltid + ',0,' + quotedstr(chrono) + ',' + quotedstr(xml.ValueTag(_to, 'NOM') + ' [SP2000]') + ',' + quotedstr('') + ',' +
               '0' + ',' + adrid + ',NULL,1,0,' +
               QuotedStr('') + ',0,0,'''','''',' +
               ''''','''',' + quotedstr(xml.ValueTag(_to, 'ID')) + ',current_date,current_date,' +
               '0,0,0,'''','''',' +
               ''''','''','''',0,0,' +
               '0,0,'''',0,'''',' +
               ''''',0,0,0,0,' +
               '0,'''',NULL,0,0,' +
               '0,0,0,0,'''',' +
               '0,1,1,0,0,' +
               '0,0,0,1,0,' +
               'NULL,0,'''',NULL,0)';
            Sql.ExecQuery;

            IBST_CB.Prepare;
            IBST_CB.ExecProc;
            S := IBST_CB.Parambyname('NEWNUM').AsString;
            IBST_CB.UnPrepare;
            cbiid := id_table('ARTCODEBARRE');
            sql.sql.text := 'INSERT INTO ARTCODEBARRE (' +
               'CBI_ID,CBI_ARFID,CBI_TGFID,CBI_COUID,CBI_CB,' +
               'CBI_TYPE,CBI_CLTID,CBI_ARLID,CBI_LOC' +
               ') values (' +
               CBIID + ',0,0,0,' + QuotedStr(s) + ',' +
               '2,' + cltid + ',0,0)';
            sql.ExecQuery;

            // ajout dans la table genimport
            addGenimport(ktbid, cltid, xml.ValueTag(_to, 'ID'));
         end;

         _n1 := xml.FindTag(_to, 'N1S');
         _n1 := xml.FindTag(_n1, 'N1');
         while (_n1 <> nil) do
         begin
            ktbid := ktb_table('LOCNKRAYON');
            rapid := existe(ktbid, xml.ValueTag(_n1, 'ID'));
            if rapid = '' then
            begin
               rapid := id_table('LOCNKRAYON');
               qry.close;
               qry.sql.text := 'select max(RAP_ORDREAFF)+1 from LOCNKRAYON';
               qry.Open;
               if qry.isempty then
                  s := '0'
               else
                  s := qry.fields[0].AsString;
               sql.sql.text := 'insert into LOCNKRAYON (' +
                  'RAP_ID,RAP_NOM,RAP_ORDREAFF,RAP_THEO,rap_visible) values (' +
                  rapid + ',' + quotedstr(xml.ValueTag(_n1, 'LIBELLE')) + ',' + s + ',' + xml.ValueTag(_n1, 'ID') + ',1)';
               sql.ExecQuery;
               addGenimport(ktbid, rapid, xml.ValueTag(_n1, 'ID'));
            end;
            _n2 := xml.FindTag(_n1, 'N2S');
            _n2 := xml.FindTag(_n2, 'N2');
            while (_n2 <> nil) do
            begin
               ktbid := ktb_table('LOCNKFAMILLE');
               s := xml.ValueTag(_n1, 'ID') + '_' + xml.ValueTag(_n2, 'ID');
               fapid := existestr(ktbid, s);
               if fapid = '' then
               begin
                  fapid := id_table('LOCNKFAMILLE');
                  qry.close;
                  qry.sql.text := 'select max(FAP_ORDREAFF)+1 from LOCNKFAMILLE';
                  qry.Open;
                  if qry.isempty then
                     s := '0'
                  else
                     s := qry.fields[0].AsString;
                  sql.sql.text := 'insert into LOCNKFAMILLE (' +
                     'FAP_ID,FAP_RAPID,FAP_NOM,FAP_ORDREAFF,FAP_THEO,FAP_CFLID,FAP_COUL,fap_visible) values (' +
                     fapid + ',' + rapid + ',' + quotedstr(xml.valuetag(_n2, 'LIBELLE')) + ',' + s +
                     ',' + xml.valuetag(_n2, 'ID') + ',0,0,1)';
                  sql.ExecQuery;
                  addGenimportstr(ktbid, fapid, xml.ValueTag(_n1, 'ID') + '_' + xml.ValueTag(_n2, 'ID'));
               end;
               _n3 := xml.FindTag(_n2, 'N3S');
               _n3 := xml.FindTag(_n3, 'N3');
               while (_n3 <> nil) do
               begin
                  ktbid := ktb_table('LOCPRODUIT');
                  s := xml.ValueTag(_n1, 'ID') + '_' + xml.ValueTag(_n2, 'ID') + '_' + xml.ValueTag(_n3, 'ID');
                  prdid := existestr(ktbid, s);
                  if prdid = '' then
                  begin
                     prdid := id_table('LOCPRODUIT');
                     comid := id_table('LOCNKCOMPOSITION');
                     IBSt_LOC.Prepare;
                     IBSt_LOC.ExecProc;
                     S := IBSt_LOC.Parambyname('NEWNUM').AsString;
                     IBSt_LOC.UnPrepare;
                     sql.sql.text := 'insert into LOCPRODUIT (' +
                        'PRD_ID,PRD_NOM,PRD_DESCRIPTION,PRD_CAUTION,' +
                        'PRD_COMID,PRD_MAGASIN,PRD_RAPIDO,PRD_CHRONO) values (' +
                        prdid + ',' + quotedstr(xml.valuetag(_n3, 'LIBELLE')) + ',' + quotedstr(xml.valuetag(_n3, 'LIBELLE')) + ',0,' +
                        comid + ',1,'''',' + quotedstr(s) + ')';
                     sql.ExecQuery;
                     addGenimportstr(ktbid, prdid, xml.ValueTag(_n1, 'ID') + '_' + xml.ValueTag(_n2, 'ID') + '_' + xml.ValueTag(_n3, 'ID'));
                     qry.close;
                     qry.close;
                     qry.sql.text := 'select max(COM_ORDREAFF)+1 from LOCNKCOMPOSITION';
                     qry.Open;
                     if qry.isempty then
                        s := '0'
                     else
                        s := qry.fields[0].AsString;
                     sql.sql.text := 'insert into LOCNKCOMPOSITION (' +
                        'COM_ID,COM_FAPID,COM_NOM,COM_ORDREAFF,COM_THEO,COM_TVAID,COM_TCTID,com_visible) values (' +
                        comid + ',' + fapid + ',' + quotedstr(xml.valuetag(_n3, 'LIBELLE')) + ',' + s + ',' +
                        xml.valuetag(_n3, 'ID') + ',' + tvaid + ',' + tctid + ',1)';
                     sql.ExecQuery;
                     ktbid := ktb_table('LOCNKCOMPOSITION');
                     addGenimport(ktbid, comid, xml.ValueTag(_n3, 'ID'));
                  end;
                  _periode := xml.FindTag(_n3, 'PERIODES');
                  _periode := xml.FindTag(_periode, 'PERIODE');
                  while (_periode <> nil) do
                  begin
                     ktbid := ktb_table('LOCPERIODE');
                     s := xml.ValueTag(_periode, 'ID') + '_' + xml.ValueTag(_periode, 'DEBUT') + '_' + xml.ValueTag(_periode, 'FIN');
                     perid := existestr(ktbid, s);
                     if (perid = '') then
                     begin
                        perid := id_table('LOCPERIODE');
                        sql.sql.text := 'Insert into LOCPERIODE (' +
                           'PER_ID, PER_NOM, PER_DEBUT, PER_FIN, PER_IMPORTWEB) values (' +
                           perid + ',' + quotedstr(xml.ValueTag(_periode, 'LIBELLE')) + ',' +
                           quotedstr(reformatDate(xml.ValueTag(_periode, 'DEBUT'))) + ',' +
                           quotedstr(reformatDate(xml.ValueTag(_periode, 'FIN'))) + ',1)';
                        sql.ExecQuery;
                        addGenimportstr(ktbid, perid, s);
                     end;
                     // l'entete de tarif c'est si
                     // TRF_PRDID, TRF_PERID, TRF_CLTID
                     _tarif := xml.FindTag(_periode, 'TARIFS');
                     if _tarif <> nil then
                     begin
                        ktbid := ktb_table('LOCTARIF');
                        s1 := xml.ValueTag(_periode, 'DEBUT');
                        s1 := copy(s1, 1, 2) + copy(s1, 4, 2) + copy(s1, 9, 2);
                        s2 := xml.ValueTag(_periode, 'FIN');
                        s2 := copy(s2, 1, 2) + copy(s2, 4, 2) + copy(s2, 9, 2);
                        S := xml.ValueTag(_to, 'ID') + '_' + xml.ValueTag(_n1, 'ID') + '_' +
                           xml.ValueTag(_n2, 'ID') + '_' + xml.ValueTag(_n3, 'ID') +
                           '_' + xml.ValueTag(_periode, 'ID') + s1 + s2+ '_'+numgt;
                        trfid := existestr(ktbid, s);
                        if trfid = '' then
                        begin
                           trfid := id_table('LOCTARIF');
                           sql.sql.text := 'Insert into LOCTARIF (' +
                              'TRF_ID,TRF_DEGID,TRF_PRDID,TRF_ORGID,TRF_PERID,TRF_MTAID,' +
                              'TRF_NOM,TRF_IMPORTWEB,TRF_CLTID) values (' +
                              trfid + ',0,' + prdid + ',0,' + perid + ','+MTAID+',' +
                              quotedstr(copy(xml.ValueTag(_n1, 'LIBELLE') + ' ' + xml.ValueTag(_n2, 'LIBELLE') + ' ' + xml.ValueTag(_n3, 'LIBELLE') +
                              ' ' + xml.ValueTag(_periode, 'LIBELLE'), 1, 63)) + ',1,' + cltid + ')';
                           sql.ExecQuery;
                           addGenimportstr(ktbid, trfid, s);
                        end
                        else
                        begin
                          // modifier le libelle ?!?
                           kversion := unkversion(trfid);
                           sql.sql.text := 'Update LOCTARIF set TRF_NOM=' +
                              quotedstr(copy(xml.ValueTag(_n1, 'LIBELLE') + ' ' + xml.ValueTag(_n2, 'LIBELLE') + ' ' + xml.ValueTag(_n3, 'LIBELLE') +
                              ' ' + xml.ValueTag(_periode, 'LIBELLE'), 1, 63)) +
                              ' where trf_id=' + trfid;
                           sql.ExecQuery;
                        end;
                        _tarif := xml.FindTag(_tarif, 'TARIF');
                        ktbid := ktb_table('LOCTARIFLIGNE');
                        while (_tarif <> nil) do
                        begin
                           duree := xml.ValueTag(_tarif, 'DUREE');
                           if duree = '15' then duree := 'JS';
                           qry.close;
                           qry.sql.text := 'Select LPN_ID ' +
                              '   from LOCPARAMNONK join k on (k_id=LPN_ID and k_enabled=1) ' +
                              '  where LPN_CODE = ' + quotedstr(duree);
                           qry.open;
                           if qry.isempty then
                           begin
                             // gestion de l'erreur
                           end
                           else
                           begin
                              lpnid := qry.fields[0].AsString;
                              qry.close;
                              qry.sql.text := 'Select TRL_ID ' +
                                 '   from LOCTARIFLIGNE join k on (k_id=TRL_ID and k_enabled=1) ' +
                                 '  where TRL_LPNID = ' + lpnid +
                                 '    and TRL_TRFID = ' + trfid;
                              qry.open;
                              trlid := qry.fields[0].asString;
                              if trlid = '' then
                              begin
                                 trlid := id_table('LOCTARIFLIGNE');
                                 sql.sql.text := 'Insert into LOCTARIFLIGNE(' +
                                    'TRL_ID, TRL_TRFID, TRL_MONTANT, TRL_LPNID,TRL_DISPOWEB, TRL_CB) values (' +
                                    trlid + ',' + trfid + ',' + enfloat(xml.ValueTag(_tarif, 'PRIX')) + ',' + lpnid + ',0,'''')';
                                 sql.ExecQuery;
                              end
                              else
                              begin
                                 kversion := unkversion(trlid);
                                 sql.sql.text := 'Update LOCTARIFLIGNE set ' +
                                    ' TRL_MONTANT = ' + enfloat(xml.ValueTag(_tarif, 'PRIX')) +
                                    ' Where TRL_ID = ' + trlid;
                                 sql.ExecQuery;
                              end;
                           end;
                           _tarif := _tarif.NextSibling;
                        end;
                           // ici on regarde si ya pas des lignes a créer

                        qry2.close;
                        qry2.sql.text :=
                           ' select LPN_ID ' +
                           ' from LOCPARAMNONK join k on (k_id=LPN_ID and k_enabled=1) ' +
                           ' where lpn_id<>0 ' +
                           '   and not exists ( ' +
                           '      select TRL_ID from LOCTARIFLIGNE join k on (k_id=trl_ID and k_enabled=1) ' +
                           '        where trl_LPNID=LOCPARAMNONK.LPN_ID ' +
                           '          and trl_trfid = ' + trfid +
                           '        ) ';
                        qry2.open;
                        while not qry2.eof do
                        begin
                           trlid := id_table('LOCTARIFLIGNE');
                           sql.sql.text := 'Insert into LOCTARIFLIGNE(' +
                              'TRL_ID, TRL_TRFID, TRL_MONTANT, TRL_LPNID,TRL_DISPOWEB, TRL_CB) values (' +
                              trlid + ',' + trfid + ',0,' + qry2.fields[0].asstring + ',0,'''')';
                           sql.ExecQuery;
                           qry2.next;
                        end;
                        qry2.close;
                     end;
                     _periode := _periode.NextSibling;
                  end;
                  _n3 := _n3.NextSibling;
               end;
               _n2 := _n2.NextSibling;
            end;
            _n1 := _n1.NextSibling;
         end;

         if tran.intransaction then
            tran.commit;
         tran.active := true;
         _to := _to.NextSibling;
      end;
      data.close;
   end;
   xml.free;
end;

procedure TFrm_Main.RecupLeFichier(S, path: string);
begin
   enabled := false;
   if ipftp.Login('194.250.124.9', 'be-ginkoia', 'gk58mlpo', '') then
   begin
      while ipftp.inprogress do application.processmessages;
      ipftp.retrieve(RepSp2000 + S, path + extractfilename(s), rmreplace, 0);
      while ipftp.inprogress do
      begin
        label1.caption := 'récupération de '+S+' ('+inttostr(ipftp.BytesTransferred)+')' ;
        application.processmessages;
      END ;
      while ipftp.Logout do
      begin
         application.processmessages;
         application.processmessages;
         sleep(100);
         application.processmessages;
         application.processmessages;
      end;
      // integration('Tarif_17322.xml');
   end;
   enabled := true;
end;

procedure TFrm_Main.FaireListeFichier;
begin
   enabled := false;
   if ipftp.Login('194.250.124.9', 'be-ginkoia', 'gk58mlpo', '') then
   begin
      while ipftp.inprogress do application.processmessages;
      ipftp.ListDir(RepSp2000, false);
      while ipftp.inprogress do application.processmessages;
      while ipftp.Logout do
      begin
         application.processmessages;
         application.processmessages;
         sleep(100);
         application.processmessages;
         application.processmessages;
      end;
      // integration('Tarif_17322.xml');
   end;
   enabled := true;
end;

procedure TFrm_Main.FormCreate(Sender: TObject);
var
   base: TIcXMLElement;
begin
   Label1.caption := '';
   Lesbase := TmonXML.create;
   if fileexists(changefileext(application.exename, '.xml')) then
      Lesbase.LoadFromFile(changefileext(application.exename, '.xml'))
   else
      lesbase.loadfromstring('<?xml version="1.0" encoding="ISO-8859-1"?><theo></theo>');
   lb.items.clear;
   base := lesbase.find('/theo/bases');
   if base <> nil then
      base := base.GetFirstChild;
   while base <> nil do
   begin
      lb.items.add(lesbase.ValueTag(base, 'nom') + ' (' + base.GetAttributeNode('adh').Value + ')');
      base := base.NextSibling;
   end;
   ListeFichierFtp := TstringList.create;
end;

function TFrm_Main.id_table(table: string): string;
begin
   qry.close;
   qry.Sql.text := 'SELECT ID FROM PR_NEWK (''' + table + ''')';
   qry.open;
   result := qry.fields[0].AsString;
end;

function TFrm_Main.ktb_table(table: string): string;
begin
   qry.close;
   qry.Sql.text := 'SELECT KTB_ID FROM KTB where KTB_NAME=''' + table + '''';
   qry.open;
   result := qry.fields[0].AsString;
end;

function TFrm_Main.existe(ktbid, id: string): string;
begin
   qry.close;
   qry.Sql.text :=
      ' Select imp_ginkoia ' +
      '   from genimport join k on (k_id=imp_id and k_enabled=1)' +
      '  where imp_num=15 ' +
      '    and imp_ktbid=' + ktbid +
      '    and imp_ref=' + id;
   qry.open;
   if qry.isempty then
      result := ''
   else
      result := qry.fields[0].AsString;
end;

procedure TFrm_Main.addGenimport(ktbid, ginid, id: string);
var
   impid: string;
begin
            // ajout dans la table genimport
   impid := id_table('GENIMPORT');
   sql.sql.text := 'insert into GENIMPORT ' +
      '(IMP_ID,IMP_KTBID,IMP_GINKOIA,IMP_REF,IMP_NUM) values (' +
      impid + ',' + ktbid + ',' + ginid + ',' + id + ',15)';
   sql.ExecQuery;
end;

function TFrm_Main.unkversion(id: string): string;
begin
   qry.close;
   qry.Sql.text := 'select gen_id(general_id,1) from k where k_id=0';
   qry.Open;
   result := qry.fields[0].asstring;
   qry.close;
   sql.sql.text := 'update k set k_version=' + result + ' where k_id=' + id;
   sql.ExecQuery;
end;

function TFrm_Main.reformatDate(d: string): string;
var
   s1, s2: string;
begin
   if d = '' then d := '01/01/2006';
   s1 := copy(d, 1, pos('/', d) - 1);
   delete(d, 1, pos('/', d));
   s2 := copy(d, 1, pos('/', d) - 1);
   delete(d, 1, pos('/', d));
   result := s2 + '/' + s1 + '/' + d;
end;

procedure TFrm_Main.Button2Click(Sender: TObject);
var
   frm_client: Tfrm_client;
   base: TIcXMLElement;
begin
   application.CreateForm(Tfrm_client, frm_client);
   try
      if frm_client.showmodal = mrok then
      begin
         base := lesbase.home;
         if base = nil then
            base := Lesbase.AddNode('theo', '');
         base := lesbase.FindTag(base, 'bases');
         if base = nil then
            base := Lesbase.AddNode('bases', '', base);
         base := lesbase.AddNode('base', '', base);
         base.SetAttribute('adh', frm_client.ed_adh.Text);
         lesbase.AddNode('nom', frm_client.ed_clt.text, base);
         lesbase.AddNode('database', frm_client.ed_base.text, base);
         lesbase.SaveToFile(changefileext(application.exename, '.xml'));
         lb.items.clear;
         base := lesbase.find('/theo/bases');
         if base <> nil then
            base := base.GetFirstChild;
         while base <> nil do
         begin
            lb.items.add(lesbase.ValueTag(base, 'nom') + ' (' + base.GetAttributeNode('adh').Value + ')');
            base := base.NextSibling;
         end;
      end;
   finally
      frm_client.release;
   end;
end;

procedure TFrm_Main.lbDblClick(Sender: TObject);
var
   base: TIcXMLElement;
   frm_client: Tfrm_client;
begin
 // modif
   if lb.itemindex >= 0 then
   begin
      base := lesbase.find('/theo/bases');
      if base <> nil then
         base := base.GetFirstChild;
      while base <> nil do
      begin
         if lesbase.ValueTag(base, 'nom') + ' (' + base.GetAttributeNode('adh').Value + ')' = lb.Items[lb.itemindex] then
         begin
            BREAK;
         end;
         base := base.NextSibling;
      end;
      if base <> nil then
      begin
         application.CreateForm(Tfrm_client, frm_client);
         try
            frm_client.ed_base.text := lesbase.ValueTag(base, 'database');
            frm_client.ed_clt.text := lesbase.ValueTag(base, 'nom');
            frm_client.ed_adh.text := base.GetAttributeNode('adh').Value;
            if frm_client.showmodal = mrok then
            begin
               lesbase.SetTag(base, 'database', frm_client.ed_base.text);
               lesbase.SetTag(base, 'nom', frm_client.ed_clt.text);
               base.SetAttribute('adh', frm_client.ed_adh.text);
               lesbase.SaveToFile(changefileext(application.exename, '.xml'));
               lb.items.clear;
               base := lesbase.find('/theo/bases');
               if base <> nil then
                  base := base.GetFirstChild;
               while base <> nil do
               begin
                  lb.items.add(lesbase.ValueTag(base, 'nom') + ' (' + base.GetAttributeNode('adh').Value + ')');
                  base := base.NextSibling;
               end;
            end;
         finally
            frm_client.release;
         end;
      end;
   end;
end;

procedure TFrm_Main.Button3Click(Sender: TObject);
var
   base: TIcXMLElement;
begin
   if lb.itemindex >= 0 then
   begin
      if application.messagebox(pchar('supprimer ' + lb.Items[lb.itemindex]), 'attention', mb_yesno) = mryes then
      begin
         base := lesbase.find('/theo/bases');
         if base <> nil then
            base := base.GetFirstChild;
         while base <> nil do
         begin
            if lesbase.ValueTag(base, 'nom') + ' (' + base.GetAttributeNode('adh').Value + ')' = lb.Items[lb.itemindex] then
            begin
               TIcXMLElement(base.GetParent).RemoveChild(base);
               BREAK;
            end;
            base := base.NextSibling;
         end;
         lesbase.SaveToFile(changefileext(application.exename, '.xml'));
         lb.items.clear;
         base := lesbase.find('/theo/bases');
         if base <> nil then
            base := base.GetFirstChild;
         while base <> nil do
         begin
            lb.items.add(lesbase.ValueTag(base, 'nom') + ' (' + base.GetAttributeNode('adh').Value + ')');
            base := base.NextSibling;
         end;
      end;
   end;
end;

function TFrm_Main.existestr(ktbid, id: string): string;
begin
   qry.close;
   qry.Sql.text :=
      ' Select imp_ginkoia ' +
      '   from genimport join k on (k_id=imp_id and k_enabled=1)' +
      '  where imp_num=15 ' +
      '    and imp_ktbid=' + ktbid +
      '    and IMP_REFSTR=' + quotedstr(id);
   qry.open;
   if qry.isempty then
      result := ''
   else
      result := qry.fields[0].AsString;
end;

procedure TFrm_Main.addGenimportstr(ktbid, ginid, id: string);
var
   impid: string;
begin
            // ajout dans la table genimport
   impid := id_table('GENIMPORT');
   sql.sql.text := 'insert into GENIMPORT ' +
      '(IMP_ID,IMP_KTBID,IMP_GINKOIA,IMP_REFSTR,IMP_NUM) values (' +
      impid + ',' + ktbid + ',' + ginid + ',' + quotedstr(id) + ',15)';
   sql.ExecQuery;
end;

function TFrm_Main.enfloat(s: string): string;
begin
   if s = '' then
      result := '0'
   else
   begin
      while pos(',', s) > 0 do
         s[pos(',', s)] := '.';
      result := trim(s);
   end;
end;

procedure TFrm_Main.IpFtpFtpStatus(Sender: TObject;
   StatusCode: TIpFtpStatusCode; const Info: string);
begin
   if StatusCode = fscDirList then
      ListeFichierFtp.Text := info;
end;

procedure TFrm_Main.Button1Click(Sender: TObject);
var
   i: integer;
   path: string;
   f: tsearchrec;
begin
   path := IncludeTrailingBackslash(ExtractfilePath(application.exename));
   FaireListeFichier;
   for i := 0 to ListeFichierFtp.count - 1 do
   begin
      if fileexists(Path + ListeFichierFtp[i]) or
         fileexists(Path + 'OK\' + ListeFichierFtp[i]) then
        // on fait rien
      else
      begin
         Label1.caption := 'récupération de ' + ListeFichierFtp[i];
         Update;
         RecupLeFichier(ListeFichierFtp[i], path);
      end;
   end;
   // on traite les fichier en XML
   if findfirst(path + '*.xml', faanyfile, f) = 0 then
      repeat
         if uppercase(extractfileext(f.name)) = '.XML' then
         begin
            Label1.caption := 'Intégration de ' + f.name;
            Update;
            if integration(f.name) then
            begin
               ForceDirectories(path + 'OK\');
               if FileExists(path + 'OK\' + f.name) then
                  DeleteFile(path + 'OK\' + f.name);
               MoveFile(pchar(path + f.name), pchar(path + 'OK\' + f.name));
            end;
         end;
      until findnext(f) <> 0;
   findclose(f);
   label1.caption := ''; update;
   application.messagebox('C''est fini', 'fin', mb_ok);
end;

initialization
   DecimalSeparator := '.';
end.

