unit Utraitement;

interface

uses
   UBase, IBQuery, IBDatabase, Upost,
   SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs;

type
   TEnProgres = function(Sender: TObject; Action: string; actu, max: Integer):boolean of object;
   TTraitement = class(TBaseGinkoia)
   protected
      fOnNetoi_HistoEvt: TEnProgres;
   public
      function Apres_ModifHPP: Boolean;
      procedure Netoi_HistoEvt;
      procedure PR_CORRIGE_DATE;
      procedure PR_RECALCULESTOCK(client: string);
      property OnNetoi_HistoEvt: TEnProgres read fOnNetoi_HistoEvt write fOnNetoi_HistoEvt;
   end;


implementation

{ TTraitement }

procedure TTraitement.PR_CORRIGE_DATE;
begin
   sql.sql.text := ('DROP PROCEDURE PR_CORRIGE_DATE ');
   try sql.ExecQuery; except end;
   sql.ParamCheck := false ;
   sql.sql.Clear;
   sql.sql.Add('CREATE PROCEDURE PR_CORRIGE_DATE ');
   sql.sql.Add('AS ');
   sql.sql.Add('  declare variable ladate Timestamp ; ');
   sql.sql.Add('  declare variable sesid integer ; ');
   sql.sql.Add('  declare variable sesdebut Timestamp ; ');
   sql.sql.Add('  declare variable breid integer ; ');
   sql.sql.Add('  declare variable kid integer ; ');
   sql.sql.Add('  declare variable strdate varchar(32) ; ');
   sql.sql.Add('  declare variable lapos integer ; ');
   sql.sql.Add('BEGIN ');
   sql.sql.Add('  /* Procedure body */ ');
//   sql.sql.Add('  for select SES_ID, SES_DEBUT,  MIN(tke_date) ');
//   sql.sql.Add('    from cshsession left join cshticket on (tke_sesid=ses_id) ');
//   sql.sql.Add('   where ses_debut<''01/01/1980'' ');
//   sql.sql.Add('     or  ses_debut>''10/01/2007'' ');
//   sql.sql.Add('  group by SES_ID, SES_DEBUT ');
//   sql.sql.Add('  into :sesid, :sesdebut, :ladate ');
//   sql.sql.Add('  do ');
//   sql.sql.Add('  begin ');
//   sql.sql.Add('    if (ladate is not null) then ');
//   sql.sql.Add('    begin ');
//   sql.sql.Add('      update k set k_version=gen_id(general_id,1) where k_id = :sesid ; ');
//   sql.sql.Add('      update cshsession set ses_debut=:ladate where ses_id = :sesid ; ');
//   sql.sql.Add('    end ');
//   sql.sql.Add('  end ');
   sql.sql.Add('  for select bre_id ');
   sql.sql.Add('       from recbr join k on (k_id=bre_id and k_enabled=1) ');
   sql.sql.Add('      where bre_date=''12/30/1899'' ');
   sql.sql.Add('        and bre_id<>0 ');
   sql.sql.Add('  into :breid ');
   sql.sql.Add('  do ');
   sql.sql.Add('  begin ');
   sql.sql.Add('    update recbr set bre_date = ''01/13/2007'' ');
   sql.sql.Add('    where bre_id=:breid; ');
   sql.sql.Add('    for select brl_id ');
   sql.sql.Add('      from recbrl join k on (k_id=brl_id and k_enabled=1) ');
   sql.sql.Add('      where brl_breid = :breid ');
   sql.sql.Add('    into :kid ');
   sql.sql.Add('    do ');
   sql.sql.Add('    begin ');
   sql.sql.Add('      update k set k_version=gen_id(general_id,1) where k_id = :kid ; ');
   sql.sql.Add('    end ');
   sql.sql.Add('    update k set k_version=gen_id(general_id,1) where k_id = :breid ; ');
   sql.sql.Add('  end ');
   sql.sql.Add('  for select bre_id, bre_date ');
   sql.sql.Add('       from recbr join k on (k_id=bre_id and k_enabled=1) ');
   sql.sql.Add('      where bre_date>''06/01/2007'' ');
   sql.sql.Add('        and bre_id<>0 ');
   sql.sql.Add('  into :breid, :strdate ');
   sql.sql.Add('  do ');
   sql.sql.Add('  begin ');
   sql.sql.Add('    select LAPOS from PR_POSCHAR(''-'',:strdate,0) into :lapos ;');
   sql.sql.Add('    if (lapos=-1) then');
   sql.sql.Add('    Begin');
   sql.sql.Add('      update recbr set bre_date = f_linewrap (:strdate,3,3)||f_linewrap (:strdate,0,3)||f_linewrap (:strdate,6,4) ');
   sql.sql.Add('      where bre_id=:breid ; ');
   sql.sql.Add('    end');
   sql.sql.Add('    else');
   sql.sql.Add('    begin');
   sql.sql.Add('      update recbr set bre_date = f_linewrap (:strdate,0,5)||f_linewrap (:strdate,8,2)||f_linewrap (:strdate,4,3) ');
   sql.sql.Add('      where bre_id=:breid ; ');
   sql.sql.Add('    end');
   sql.sql.Add('    for select brl_id ');
   sql.sql.Add('      from recbrl join k on (k_id=brl_id and k_enabled=1) ');
   sql.sql.Add('      where brl_breid = :breid ');
   sql.sql.Add('    into :kid ');
   sql.sql.Add('    do ');
   sql.sql.Add('    begin ');
   sql.sql.Add('      update k set k_version=gen_id(general_id,1) where k_id = :kid ; ');
   sql.sql.Add('    end ');
   sql.sql.Add('    update k set k_version=gen_id(general_id,1) where k_id = :breid ; ');
   sql.sql.Add('  end ');
   sql.sql.Add('END ');
   sql.ExecQuery;
   sql.sql.text := ('EXECUTE PROCEDURE PR_CORRIGE_DATE ');
   sql.ExecQuery;
   commit;
   sql.sql.text := ('DROP PROCEDURE PR_CORRIGE_DATE ');
   sql.ExecQuery;
   commit;
end;

procedure TTraitement.Netoi_HistoEvt;
var
   Actu, max: Integer;
begin
   qry.sql.clear;
   qry.sql.add('select count(*)');
   qry.sql.add('   from genhistoevt');
   qry.sql.add('       join k on (k_id=hev_id and k_enabled=1)');
   qry.sql.add('where HEV_DATE > CURRENT_DATE');
   qry.Open;
   actu := 0;
   max := qry.fields[0].AsInteger + 1;
   qry.close;

   qry.sql.clear;
   qry.sql.add('select hev_id');
   qry.sql.add('   from genhistoevt');
   qry.sql.add('       join k on (k_id=hev_id and k_enabled=1)');
   qry.sql.add('where HEV_DATE > CURRENT_DATE');
   qry.Open;
   while not qry.eof do
   begin
      inc(actu);
      if assigned(fOnNetoi_HistoEvt) then
         OnNetoi_HistoEvt(self, 'Netoyage', actu, max);
      sql.sql.clear;
      sql.sql.add('Update K set KRH_ID=gen_id(general_id,1), K_VERSION=gen_id(general_id,0),');
      sql.sql.add(' KSE_LOCK_ID=gen_id(general_id,0), KMA_LOCK_ID=gen_id(general_id,0), k_enabled=0');
      sql.sql.add('Where ');
      sql.sql.add('K_ID = ' + qry.fields[0].asstring);
      sql.ExecQuery;
      qry.next;
   end;
   qry.close;
   commit;
end;

function TTraitement.Apres_ModifHPP: Boolean;
begin
   qry.sql.clear;
   qry.sql.add('Select count(*)');
   qry.sql.add('from kfld');
   qry.sql.add('where KFLD_NAME = ''HPP_SOCID''');
   qry.open;
   result := qry.fields[0].AsInteger = 0;
   qry.close;
end;

procedure TTraitement.PR_RECALCULESTOCK(client: string);
var
   New: Boolean;
   Qry_LitAgregat: TIBQuery;
   Qry_ENTREE: TIBQuery;
   Qry_BLL: TIBQuery;
   QRY_TKE: TIBQuery;
   Qry_FCE: TIBQuery;
   Qry_CDV: TIBQuery;
   Qry_RET: TIBQuery;
   QRY_ART: TIBQuery;
   QRY_CONSO: TIBQuery;
   max, position: integer;
   tran_read: TIBTransaction;
   Valeur: DOUBLE;
   Tsl: TstringList;
begin
   Tsl := TstringList.Create;
   tsl.add('=============== DEBUT : ' + DateToStr(DATE) + ' ==========');
   tsl.add('Correction ' + client);
   sql.sql.text := 'DROP PROCEDURE PR_RECALCULESTOCK';
   sql.ParamCheck := false;
   try sql.ExecQuery; except end;
   commit;
   new := Apres_ModifHPP;
   if new then
      sql.sql.LoadFromFile(IncludeTrailingBackslash(ExtractFilePath(application.exename)) + 'PR_RECALCULESTOCK1.sql')
   else
      sql.sql.LoadFromFile(IncludeTrailingBackslash(ExtractFilePath(application.exename)) + 'PR_RECALCULESTOCK2.sql');
   sql.ExecQuery;
   commit;
   qry.sql.clear;
   qry.sql.add(' select Count(Distinct STC_ARTID) NBR');
   qry.sql.add('    from agrstockcour');
   qry.sql.add('  where STC_ARTID<>0');
   qry.Open;
   Max := qry.fields[0].AsInteger;
   Position := 0;
   qry.close;
   tran_read := NewTran;
   Qry_LitAgregat := NewQry(tran_read);
   Qry_LitAgregat.sql.add('select STC_ARTID ARTID, SUM(STC_QTE) QTE');
   Qry_LitAgregat.sql.add('   from agrstockcour');
   Qry_LitAgregat.sql.add(' where STC_ARTID<>0');
   Qry_LitAgregat.sql.add('group by STC_ARTID');

   Qry_ENTREE := NewQry;
   with Qry_ENTREE.sql do
   begin
      add('SELECT SUM(BRL_QTE) Num');
      add('      FROM RECBRL  JOIN K ON (K_ID=BRL_ID AND K_ENABLED=1)');
      add('     WHERE BRL_ARTID=:ARTID');
   end;

   Qry_BLL := NewQry;
   with Qry_BLL.sql do
   begin
      add('SELECT SUM(BLL_QTE) Num');
      add('  FROM NEGBLL');
      add('    JOIN K ON (K_ID=BLL_ID AND K_ENABLED=1)');
      add('WHERE BLL_ARTID=:ARTID');
   end;

   QRY_TKE := NewQry;
   with QRY_TKE.sql do
   begin
      add('SELECT SUM(TKL_QTE) Num');
      add('  FROM CSHTICKETL');
      add('    JOIN K ON (K_ID=TKL_ID AND K_ENABLED=1)');
      add(' WHERE TKL_ARTID=:ARTID');
   end;

   Qry_FCE := NewQry;
   with Qry_FCE.sql do
   begin
      add('SELECT SUM(FCL_QTE) Num');
      add('  FROM NEGFACTUREL');
      add('    JOIN K ON (K_ID=FCL_ID AND K_ENABLED=1)');
      add('  JOIN NEGFACTURE ON (FCE_ID=FCL_FCEID)');
      add(' WHERE FCL_ARTID=:ARTID');
      add('   AND FCE_MODELE=0');
      add('   AND FCL_FROMBLL=0');
   end;

   Qry_CDV := NewQry;
   with Qry_CDV.sql do
   begin
      add('SELECT SUM(CDV_QTE) Num');
      add('  FROM CONSODIV');
      add('    JOIN K ON (K_ID=CDV_ID AND K_ENABLED=1)');
      add(' WHERE CDV_ARTID=:ARTID');
   end;

   Qry_RET := NewQry;
   with Qry_RET.sql do
   begin
      add('Select SUM (REL_QTE) Num');
      add('   from comretourl Join K on (K_ID=REL_ID And K_Enabled = 1)');
      add('   Where REL_ARTID=:ARTID');
   end;

   QRY_ART := NewQry;
   with QRY_ART.sql do
   begin
      add('Select ARF_CHRONO');
      add('from ARTREFERENCE');
      add('Where ARF_ARTID = :ARTID');
   end;

   QRY_CONSO := NewQry;
   with QRY_CONSO.sql do
   begin
      add('select *');
      add('from consodiv');
      add('where cdv_artid=:artid');
      add('and cdv_date > ''01/08/2007''');
   end;

   Qry_ENTREE.Prepare;
   Qry_BLL.Prepare;
   QRY_TKE.Prepare;
   Qry_FCE.Prepare;
   Qry_CDV.Prepare;
   Qry_RET.Prepare;
   QRY_ART.Prepare;

   Qry_LitAgregat.Open;
   Qry_LitAgregat.first;
   while not Qry_LitAgregat.eof do
   begin
      inc(position);
      if assigned(fOnNetoi_HistoEvt) then
         IF not OnNetoi_HistoEvt(self, 'Vérification des stocks', position, max) then
           BREAK ;
      Qry_ENTREE.Params[0].AsString := Qry_LitAgregat.fields[0].AsString;
      Qry_BLL.Params[0].AsString := Qry_LitAgregat.fields[0].AsString;
      QRY_TKE.Params[0].AsString := Qry_LitAgregat.fields[0].AsString;
      Qry_FCE.Params[0].AsString := Qry_LitAgregat.fields[0].AsString;
      Qry_CDV.Params[0].AsString := Qry_LitAgregat.fields[0].AsString;
      Qry_RET.Params[0].AsString := Qry_LitAgregat.fields[0].AsString;
      Qry_ENTREE.Open; Valeur := Qry_ENTREE.fields[0].AsFloat; Qry_ENTREE.close;
      Qry_BLL.Open; Valeur := Valeur - Qry_BLL.fields[0].AsFloat; Qry_BLL.close;
      QRY_TKE.Open; Valeur := Valeur - QRY_TKE.fields[0].AsFloat; QRY_TKE.close;
      Qry_FCE.Open; Valeur := Valeur - Qry_FCE.fields[0].AsFloat; Qry_FCE.close;
      Qry_CDV.Open; Valeur := Valeur - Qry_CDV.fields[0].AsFloat; Qry_CDV.close;
      Qry_RET.Open; Valeur := Valeur - Qry_RET.fields[0].AsFloat; Qry_RET.close;
      if Abs(Valeur - Qry_LitAgregat.fields[1].AsFloat) > 0.5 then
      begin
         // traitement de l'article
         QRY_ART.Params[0].AsString := Qry_LitAgregat.fields[0].AsString;
         QRY_ART.Open;
         QRY_Conso.Params[0].AsString := Qry_LitAgregat.fields[0].AsString;
         QRY_Conso.Open;
         if QRY_Conso.IsEmpty then
            Tsl.Add('Article ' + QRY_ART.fields[0].AsString + ' (' + Qry_LitAgregat.fields[0].AsString + ') Agrégat : ' + Qry_LitAgregat.fields[1].AsString + ' -> Somme : ' + FloatToStr(Valeur))
         else
            Tsl.Add(' CONSO DIV ---- Article ' + QRY_ART.fields[0].AsString + ' (' + Qry_LitAgregat.fields[0].AsString + ') Agrégat : ' + Qry_LitAgregat.fields[1].AsString + ' -> Somme : ' + FloatToStr(Valeur));
         QRY_Conso.Close;
         sql.sql.text := 'EXECUTE PROCEDURE PR_RECALCULESTOCK ( ' + quotedstr(QRY_ART.fields[0].AsString) + ' ) ';
         sql.ExecQuery;
         commit;
         QRY_ART.close;
        //
      end;
      Qry_LitAgregat.next;
   end;

   sql.sql.text := 'DROP PROCEDURE PR_RECALCULESTOCK';
   sql.ExecQuery;
   commit;
   Qry_ENTREE.free;
   Qry_BLL.free;
   QRY_TKE.free;
   Qry_FCE.free;
   Qry_CDV.free;
   Qry_RET.free;
   QRY_ART.free;
   Qry_LitAgregat.close;
   Qry_LitAgregat.free;
   tran_read.free;

   tsl.add('=============== FIN ===============');
   UPost.sendmail('dev@ginkoia.fr',
      'stanislas.chaucheprat@ginkoia.fr,bruno.nicolafrancesco@ginkoia.fr,Sandrine.Medeiros@ginkoia.fr',
      'Correction auto lame3 : ' + client,
      Tsl.text);
   Tsl.Free;

end;

end.

