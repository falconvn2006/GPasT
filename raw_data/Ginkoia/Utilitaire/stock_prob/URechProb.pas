unit URechProb;

interface

uses
   UPost,
   Umapping,
   registry,
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   Db, IBCustomDataSet, IBQuery, IBDatabase, StdCtrls, ComCtrls, IBSQL;

type
   TFrm_RechProb = class(TForm)
      Data: TIBDatabase;
      TranRead: TIBTransaction;
      TranWrite: TIBTransaction;
      Qry_LitAgregat: TIBQuery;
      Qry_LitAgregatARTID: TIntegerField;
      Qry_LitAgregatQTE: TFloatField;
      Pb: TProgressBar;
      Lab_ETAT: TLabel;
      Qry_CptAgr: TIBQuery;
      Qry_CptAgrNBR: TIntegerField;
      Qry_ENTREE: TIBQuery;
      Qry_ENTREENUM: TFloatField;
      Qry_BLL: TIBQuery;
      Qry_BLLNUM: TFloatField;
      QRY_TKE: TIBQuery;
      QRY_TKENUM: TFloatField;
      Qry_FCE: TIBQuery;
      Qry_FCENUM: TFloatField;
      Qry_CDV: TIBQuery;
      Qry_CDVNUM: TFloatField;
      Qry_RET: TIBQuery;
      Qry_RETNUM: TFloatField;
      QRY_ART: TIBQuery;
      QRY_ARTARF_CHRONO: TIBStringField;
      QRY_Version: TIBQuery;
      SqlSup: TIBSQL;
      PR_RECALCULESTOCK24: TIBSQL;
      PR_RECALCULESTOCK: TIBSQL;
      CORRIGE: TIBSQL;
      Sql: TIBSQL;
      Qry: TIBQuery;
      QRY_Conso: TIBQuery;
      QRY_BASE: TIBQuery;
      QRY_BASEBAS_NOM: TIBStringField;
      IBQue_Base: TIBQuery;
      IBQue_BaseBAS_NOM: TIBStringField;
      IBQue_BaseBAS_ID: TIntegerField;
      QRY_BASEBAS_ID: TIntegerField;
      IBQue_Tousart: TIBQuery;
      IBQue_TousartART_ID: TIntegerField;
      IBQue_NbrArt: TIBQuery;
      IBQue_NbrArtNBR: TIntegerField;
      sql_correction: TIBSQL;
      procedure FormCreate(Sender: TObject);
      procedure FormPaint(Sender: TObject);
      procedure FormDestroy(Sender: TObject);
   private
      procedure Traitement;
      procedure Traitement2;
    { Déclarations privées }
   public
    { Déclarations publiques }
      Params: TStringList;
      First: Boolean;
      debut, fin: TDateTime;
   end;

var
   Frm_RechProb: TFrm_RechProb;

implementation

{$R *.DFM}

procedure TFrm_RechProb.FormCreate(Sender: TObject);
var
   i: integer;
   reg: tregistry;
   s: string;
   j: integer;
begin
   Lab_ETAT.Caption := '';
   Params := TStringList.create;
   Params.Values['PROG'] := Application.ExeName;
   Params.Values['PROG_COURT'] := ExtractFileName(Application.ExeName);
   Params.Values['PATH'] := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName));
   Params.Values['CORRIGE'] := 'OUI';
   Params.Values['USER'] := 'SYSDBA';
   Params.Values['PASSW'] := 'masterkey';
   reg := TRegistry.Create(KEY_READ);
   try
      reg.RootKey := HKEY_LOCAL_MACHINE;
      reg.OpenKey('Software\Algol\Ginkoia', False);
      Params.Values['BASE'] := reg.ReadString('Base0');
   finally
      reg.free;
   end;
   for i := 1 to paramcount do
   begin
      S := paramstr(i);
      j := pos('=', s);
      if j > 0 then
         Params.values[Copy(s, 1, j - 1)] := Copy(s, j + 1, 255);
   end;
   data.Close;
   data.DatabaseName := params.values['BASE'];
   data.Params.Values['user_name'] := Params.Values['USER'];
   data.Params.Values['password'] := Params.Values['PASSW'];
   First := True;
end;

procedure TFrm_RechProb.Traitement;
var
   Valeur: DOUBLE;
   tsl: Tstringlist;
   new: boolean;
   titre: string;
begin
   Screen.Cursor := CrHourGlass;
   Tsl := TstringList.Create;
   if FileExists(ChangeFileExt(Params.Values['PROG'], '.txt')) then
      tsl.LoadFromFile(ChangeFileExt(Params.Values['PROG'], '.txt'));
   tsl.add('=============== DEBUT : ' + DateToStr(DATE) + ' ==========');
   Data.Open;
   TranRead.active := true;
   TranWrite.active := true;
   IBQue_Base.Open;
   QRY_BASE.Open;
   titre := '';
   while not QRY_BASE.Eof do
   begin
      if IBQue_BaseBAS_ID.AsString = QRY_BASEBAS_ID.AsString then
      begin
         tsl.add('**** ' + QRY_BASEBAS_NOM.AsString + ' ****');
         titre := 'Resultat Correction ' + QRY_BASEBAS_NOM.AsString;
      end
      else
         tsl.add(QRY_BASEBAS_NOM.AsString);
      QRY_BASE.Next;
   end;
   if titre = '' then
      titre := 'Resultat Correction Base inconnue';
   QRY_BASE.Close;
   try
      qry.sql.clear;
      qry.sql.add('select count(*)');
      qry.sql.add('   from genhistoevt');
      qry.sql.add('       join k on (k_id=hev_id and k_enabled=1)');
      qry.sql.add('where HEV_DATE > CURRENT_DATE');
      qry.Open;
      Pb.position := 0;
      Pb.max := qry.fields[0].AsInteger + 1;
      qry.close;
      qry.sql.clear;
      qry.sql.add('select hev_id');
      qry.sql.add('   from genhistoevt');
      qry.sql.add('       join k on (k_id=hev_id and k_enabled=1)');
      qry.sql.add('where HEV_DATE > CURRENT_DATE');
      qry.Open;
      while not qry.eof do
      begin
         Pb.position := Pb.position + 1;
         sql.sql.clear;
         sql.sql.add('Update K set KRH_ID=gen_id(general_id,1), K_VERSION=gen_id(general_id,0),');
         sql.sql.add(' KSE_LOCK_ID=gen_id(general_id,0), KMA_LOCK_ID=gen_id(general_id,0), k_enabled=0');
         sql.sql.add('Where ');
         sql.sql.add('K_ID = ' + qry.fields[0].asstring);
         sql.ExecQuery;
         qry.next;
      end;
   except
   end;
   if sql.Transaction.InTransaction then
   begin
      sql.Transaction.Commit;
      sql.Transaction.active := true;
   end;

   sql.sql.text := ('DROP PROCEDURE PR_CORRIGE_DATE ');
   try sql.ExecQuery; except end;
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
   sql.sql.Add('      where bre_date>current_date ');
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
   if sql.Transaction.InTransaction then
   begin
      sql.Transaction.Commit;
      sql.Transaction.active := true;
   end;

   sql.sql.text := ('DROP PROCEDURE PR_CORRIGE_DATE ');
   sql.ExecQuery;


   Qry_ENTREE.Prepare;
   Qry_BLL.Prepare;
   QRY_TKE.Prepare;
   Qry_FCE.Prepare;
   Qry_CDV.Prepare;
   Qry_RET.Prepare;
   QRY_ART.Prepare;

   QRY_Version.Open;
   if QRY_Version.IsEmpty then
      New := true
   else
      New := false;
   QRY_Version.Close;
   try
      sqlSUP.ExecQuery;
      if sqlSUP.Transaction.InTransaction then
      begin
         sqlSUP.Transaction.Commit;
         sqlSUP.Transaction.Active := true;
      end;
   except
   end;

   if new then
   begin
      PR_RECALCULESTOCK.ExecQuery;
      if PR_RECALCULESTOCK.Transaction.InTransaction then
      begin
         PR_RECALCULESTOCK.Transaction.Commit;
         PR_RECALCULESTOCK.Transaction.Active := true;
      end;
   end
   else
   begin
      PR_RECALCULESTOCK24.ExecQuery;
      if PR_RECALCULESTOCK24.Transaction.InTransaction then
      begin
         PR_RECALCULESTOCK24.Transaction.Commit;
         PR_RECALCULESTOCK24.Transaction.Active := true;
      end;
   end;

   Qry_CptAgr.Open;
   Pb.Max := Qry_CptAgrNBR.AsInteger;
   Pb.Position := 0;
   Qry_CptAgr.close;
   Qry_LitAgregat.Open;
   Qry_LitAgregat.first;
   while not Qry_LitAgregat.eof do
   begin
      Pb.Position := pb.position + 1;
      Qry_ENTREE.Params[0].AsString := Qry_LitAgregatARTID.AsString;
      Qry_BLL.Params[0].AsString := Qry_LitAgregatARTID.AsString;
      QRY_TKE.Params[0].AsString := Qry_LitAgregatARTID.AsString;
      Qry_FCE.Params[0].AsString := Qry_LitAgregatARTID.AsString;
      Qry_CDV.Params[0].AsString := Qry_LitAgregatARTID.AsString;
      Qry_RET.Params[0].AsString := Qry_LitAgregatARTID.AsString;
      Qry_ENTREE.Open; Valeur := Qry_ENTREENUM.AsFloat; Qry_ENTREE.close;
      Qry_BLL.Open; Valeur := Valeur - Qry_BLLNUM.AsFloat; Qry_BLL.close;
      QRY_TKE.Open; Valeur := Valeur - QRY_TKENUM.AsFloat; QRY_TKE.close;
      Qry_FCE.Open; Valeur := Valeur - Qry_FCENUM.AsFloat; Qry_FCE.close;
      Qry_CDV.Open; Valeur := Valeur - Qry_CDVNUM.AsFloat; Qry_CDV.close;
      Qry_RET.Open; Valeur := Valeur - Qry_RETNUM.AsFloat; Qry_RET.close;
      if Abs(Valeur - Qry_LitAgregatQTE.AsFloat) > 0.5 then
      begin
        // traitement de l'article
         QRY_ART.Params[0].AsString := Qry_LitAgregatARTID.AsString;
         QRY_ART.Open;
         QRY_Conso.Params[0].AsString := Qry_LitAgregatARTID.AsString;
         QRY_Conso.Open;
         if QRY_Conso.IsEmpty then
            Tsl.Add('Article ' + QRY_ARTARF_CHRONO.AsString + ' (' + Qry_LitAgregatARTID.AsString + ') Agrégat : ' + Qry_LitAgregatQTE.AsString + ' -> Somme : ' + FloatToStr(Valeur))
         else
            Tsl.Add(' CONSO DIV ---- Article ' + QRY_ARTARF_CHRONO.AsString + ' (' + Qry_LitAgregatARTID.AsString + ') Agrégat : ' + Qry_LitAgregatQTE.AsString + ' -> Somme : ' + FloatToStr(Valeur));
         QRY_Conso.Close;
         if Params.Values['CORRIGE'] = 'OUI' then
         begin
            CORRIGE.Params[0].AsString := QRY_ARTARF_CHRONO.AsString;
            CORRIGE.ExecQuery;
            if CORRIGE.Transaction.InTransaction then
            begin
               CORRIGE.Transaction.Commit;
               CORRIGE.Transaction.Active := true;
            end;
         end;
         QRY_ART.close;
        //
      end;
      Qry_LitAgregat.Next;
   end;

   sqlSUP.ExecQuery;
   Data.close;
   Screen.Cursor := crDefault;
   tsl.add('=============== FIN ===============');
   Tsl.SaveToFile(ChangeFileExt(Params.Values['PROG'], '.txt'));
   UPost.sendmail('dev@ginkoia.fr',
      'stanislas.chaucheprat@ginkoia.fr,bruno.nicolafrancesco@ginkoia.fr,sandrine.medeiros@ginkoia.fr',
      titre,
      Tsl.text);
   Tsl.Free;
end;

procedure TFrm_RechProb.Traitement2;
var
   NbArticle,
      NbFait: Integer;
   StartTime: TDatetime ;
   moyenne: TDatetime ;
begin
   enabled := false;
   try
      Screen.Cursor := CrHourGlass;
      Data.Open;
      TranRead.active := true;
      TranWrite.active := true;
      IBQue_NbrArt.open;
      Pb.Position := 0;
      NbArticle := IBQue_NbrArtNBR.AsInteger;
      NbFait := 0;
      Pb.Max := IBQue_NbrArtNBR.AsInteger;
      IBQue_NbrArt.close;
      IBQue_Tousart.Open;
      StartTime := Now;
      while not IBQue_Tousart.eof do
      begin
         if nbFait > 0 then
         begin
           moyenne := (Now-StartTime)/nbfait ;
           Lab_Etat.caption := format('Démarage du traitement à %s pour %d articles fait %d écoulé %s reste %s moyenne %s',
           [formatdateTime('dd/mm hh:nn:ss', StartTime), NbArticle, nbFait,formatdateTime('hh:nn:ss', Now-StartTime),
           formatdateTime('hh:nn:ss',moyenne*(NbArticle-nbfait)),
           formatdateTime('nn:ss',moyenne)
           ]);
         end
         else
         begin
            Lab_Etat.caption := format('Démarage du traitement à %s pour %d articles', [
               formatdateTime('dd/mm hh:nn:ss', StartTime), NbArticle]);
         end;
         Pb.Position := pb.position + 1;
         Application.processMessages;
         sql_correction.Params[0].AsInteger := IBQue_TousartART_ID.AsInteger;
         sql_correction.ExecQuery;
         if sql_correction.Transaction.InTransaction then
         begin
            sql_correction.Transaction.Commit;
            sql_correction.Transaction.Active := true;
         end;
         IBQue_Tousart.Next;
         inc(nbFait);
      end;
      IBQue_Tousart.close;
   finally
      enabled := true;
   end;
   Application.MessageBox('C''est fini', 'fin', mb_ok);
end;

procedure TFrm_RechProb.FormPaint(Sender: TObject);
begin
   if first then
   begin
      first := false;
      Update;
      // un petit délai pour ne pas pauser de problème
      {
      sleep(1000 * 60);
      while MapGinkoia.Backup do
         sleep(1000 * 60);
      }
      debut := time;
//      Traitement2;
      Traitement;
      fin := time;
      fin := fin - debut;
      caption := timetostr(fin);
      close;
   end;
end;

procedure TFrm_RechProb.FormDestroy(Sender: TObject);
begin
   Params.free;
end;

end.

