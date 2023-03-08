//$Log:
// 6    Utilitaires1.5         23/11/2007 12:06:19    Sandrine MEDEIROS
//      Correction pour ne pas traiter les articles Obsolet dans WinMag
// 5    Utilitaires1.4         08/08/2005 09:04:17    pascal         
//      Modification suite ? la transpo de M. Travaillot
// 4    Utilitaires1.3         13/07/2005 10:11:56    Sandrine MEDEIROS
//      R?activation du traitement de contr?le des pump avec prise en compte de
//      la remise sur les r?ceptions
// 3    Utilitaires1.2         12/07/2005 09:13:54    pascal          pb
//      transpo TRAVAILLOT:
//      lenteur cr?ation des CB
//      Pb de pump
// 2    Utilitaires1.1         13/06/2005 11:51:25    pascal         
//      Suppression du message au d?marage de la transpo de WinMag
// 1    Utilitaires1.0         27/04/2005 10:41:37    pascal          
//$
//$NoKeywords$
//
unit USuite;

interface

uses
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   IBDatabase, Db, IBSQL, IBCustomDataSet, IBQuery, DBTables, ComCtrls;

type
   TForm1 = class(TForm)
      Db: TIBDatabase;
      Tran: TIBTransaction;
      sql: TIBSQL;
      qry_art: TIBQuery;
      Qry_rech2: TQuery;
      Qry_rech2ARTRE_PA: TFloatField;
      Qry_Rech: TQuery;
      Qry_RechARTRE_PA: TFloatField;
      Qry_table: TIBQuery;
      Qry_tableBRE_DATE: TDateTimeField;
      Qry_tableBRL_ID: TIntegerField;
      Qry_tableBRL_QTE: TFloatField;
      Qry_tableBRL_PXNN: TFloatField;
      Qry_tableBRL_PXACHAT: TFloatField;
      Qry_tableART_REFMRK: TIBStringField;
      tran2: TIBTransaction;
      sql_K: TIBSQL;
      IBQue_CB: TIBQuery;
      IBQue_CBNEWNUM: TIBStringField;
      IBQue_Key: TIBQuery;
      IBQue_KeyNEWKEY: TIntegerField;
      Sql_CB: TIBSQL;
      IBQue_Count: TIBQuery;
      pb: TProgressBar;
      IBQue_CountNBR: TIntegerField;
      IBQue_UnCB: TIBQuery;
      IBQue_UnCBNBR: TIntegerField;
      qry_artTMP_ARTID: TIntegerField;
      qry_artTMP_COUID: TIntegerField;
      qry_artTMP_TGFID: TIntegerField;
      IBQue_NbrCbMarque: TIBQuery;
      IBQue_NbrCbMarqueNBR: TIntegerField;
      IBQue_CBPresent: TIBQuery;
      IBQue_CBPresentCBI_ARFID: TIntegerField;
      IBQue_CBPresentCBI_COUID: TIntegerField;
      IBQue_CBPresentCBI_TGFID: TIntegerField;
      IBSql_MarqueCb: TIBSQL;
      DbWinShop: TDatabase;
      IB_RECPUPCB: TIBQuery;
    Qry_tableBRE_ID: TIntegerField;
    IB_lesID: TIBQuery;
    IB_lesIDDE: TIntegerField;
    IB_lesIDVERS: TIntegerField;
      procedure FormCreate(Sender: TObject);
      procedure FormPaint(Sender: TObject);
   private
    { Déclarations privées }
      premier: Boolean;
      procedure Suite;
   public
    { Déclarations publiques }
      procedure start;
   end;

var
   Form1: TForm1;

implementation
uses
   Inifiles;

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
   premier := true;
end;

procedure TForm1.FormPaint(Sender: TObject);
begin
   if premier then
   begin
      premier := false;
      Update;
      Start;
   end
end;

procedure TForm1.Suite;
{
var
   i: integer;
   tsl: TstringList;
   S: string;
   ok: Boolean;
   BREID : Integer ;
}   
begin
{
   BREID := 0 ;
   repeat
      Db.close;
      Db.Open;
      tran.Active := true;
      tran2.active := true;
      ok := true;
      tsl := TstringList.Create;
      try
         Caption := 'Création du script ' + IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) + 'Correction.sql '; Update;
         i := 0;
         DecimalSeparator := '.';
         try
            Qry_table.ParamByName('BREID').Asinteger := BREID ;
            Qry_table.Open;
            while not Qry_table.EOF do
            begin
               Qry_Rech.ParamByName('REF').AsString := Qry_tableART_REFMRK.AsString;
               Qry_Rech.ParamByName('DATEFIN').AsDateTime := Qry_tableBRE_DATE.AsDateTime;
               Qry_Rech.Open;
               if (Qry_RechARTRE_PA.IsNull) or
                  (Qry_RechARTRE_PA.AsFloat = 0) then
               begin
                  Qry_Rech2.ParamByName('REF').AsString := Qry_tableART_REFMRK.AsString;
                  Qry_Rech2.ParamByName('DATEFIN').AsDateTime := Qry_tableBRE_DATE.AsDateTime;
                  Qry_Rech2.Open;
                  if not ((Qry_Rech2ARTRE_PA.IsNull) or
                     (Qry_Rech2ARTRE_PA.AsFloat = 0)) then
                  begin
                     if ABS(Qry_Rech2ARTRE_PA.AsFloat - Qry_tableBRL_PXNN.AsFloat) > 0.009 then
                     begin
                        Tsl.Add('UPDATE RECBRL SET BRL_PXNN=' + Qry_Rech2ARTRE_PA.AsString + ', Brl_PXACHAT=' +
                           Qry_Rech2ARTRE_PA.AsString + ' WHERE BRL_ID=' + Qry_tableBRL_ID.AsString + '; ');
                        inc(i);
                        if i > 100 then
                        begin
                           BREID := Qry_tableBRE_ID.AsInteger ;
                           Tsl.Add('COMMIT ;');
                           tsl.savetofile(IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) + 'Correction.sql');
                           i := 0;
                        end;
                     end;
                  end;
                  Qry_Rech2.Close;
               end
               else
               begin
                  if ABS(Qry_RechARTRE_PA.AsFloat - Qry_tableBRL_PXNN.AsFloat) > 0.009 then
                  begin
                     Tsl.Add('UPDATE RECBRL SET BRL_PXNN=' + Qry_RechARTRE_PA.AsString + ', Brl_PXACHAT=' +
                        Qry_RechARTRE_PA.AsString + ' WHERE BRL_ID=' + Qry_tableBRL_ID.AsString + '; ');
                     inc(i);
                     if i > 100 then
                     begin
                        BREID := Qry_tableBRE_ID.AsInteger ;
                        Tsl.Add('COMMIT ;');
                        tsl.savetofile(IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) + 'Correction.sql');
                        i := 0;
                     end;
                  end;
               end;
               Qry_Rech.Close;
               Qry_table.Next;
            end;
         except
            ok := false;
         end;
         Db.close;
         Db.Open;
         tran.Active := true;
         tran2.active := true;
         if i <> 0 then
            Tsl.Add('COMMIT ;');
         Qry_table.Close;
         tsl.savetofile(IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) + 'Correction.sql');
         Caption := 'Passage du script ' + IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) + 'Correction.sql '; Update;
         pb.position := 0;
         pb.max := tsl.count;
         i := 1;
         while tsl.count > 0 do
         begin
            pb.position := pb.position + 1;
            S := tsl[0];
            tsl.delete(0);
            if (copy(S, 1, 6) <> 'COMMIT') and (trim(S) <> '') then
            begin
               Sql.Sql.Clear;
               Sql.Sql.Add(S);
               Sql.ExecQuery;
               if tran.InTransaction then
                  tran.Commit;
               tran.active := true;
               if i > 1000 then
               begin
                  Db.Close;
                  Db.Open;
                  tran.Active := true;
                  tran2.active := true;
               end;
            end;
         end;
      finally
         tsl.free;
      end;
   until ok;
}
end;

procedure TForm1.start;
var
   reg: tinifile;
   S: string;
   ttsl: tstringlist;
//   Numcb: string;
//   kid: integer;
   i,
      nombre: Integer;
   toto: Integer;
begin
  //
   if fileexists(IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) + 'Import_Husky.ini') then
      reg := tinifile.Create(IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) + 'Import_Husky.ini')
   else
      reg := tinifile.Create('C:\IP_HUSKY\Import_Husky.ini');
   S := reg.readstring('DATABASE', 'PATH', '');
   try
      if s <> '' then
      begin
         Caption := 'Passage des script en cours'; Update;
         Db.DatabaseName := S;
         Db.Open;
         tran.Active := true;
         tran2.active := true;

         toto := 0;
         if reg.readstring('PASCAL', 'PATH', '') = S then
            toto := reg.readInteger('PASCAL', 'ENCOURS', 0);
            // Application.messagebox (Pchar(Inttostr(toto)), 'TOTO', mb_OK) ;

         reg.Writestring('PASCAL', 'PATH', S);
            // Correction des code barre articles
            // Passage des CB actuel en CB Fournisseur
         if toto < 1 then
         begin
            { plus besoin
            Caption := 'Passage des CB en type 3'; Update;
            Sql.sql.clear;
            Sql.sql.Add('Update artcodebarre set CBI_TYPE=3 where CBI_TYPE=1');
            Sql.ExecQuery;
            if tran.InTransaction then
               tran.Commit;
            tran.active := true;
            Db.Close;
            Db.Open;
            tran.Active := true;
            tran2.active := true;
            }
            // marquage de l'id en cours
            Sql.sql.clear;
            Sql.sql.Add('Insert into TMPSTAT (TMP_ID,TMP_ARTID) Values (-98, GEN_ID(GENERAL_ID,0))');
            Sql.ExecQuery;
            if tran.InTransaction then
               tran.Commit;
            tran.active := true;
            reg.WriteInteger('PASCAL', 'ENCOURS', 1);
         end;

         if toto < 2 then
         begin
            Caption := 'Création de l''index TMPSTATP'; Update;
            try
               Sql.sql.clear;
               Sql.sql.Add('CREATE INDEX INX_TMPALL ON TMPSTAT (TMP_ID, TMP_ARTID, TMP_COUID, TMP_TGFID)');
               Sql.ExecQuery;
               if tran.InTransaction then
                  tran.Commit;
               tran.active := true;
            except
            end;
            try
               Sql.sql.clear;
               Sql.sql.Add('CREATE INDEX INX_TMPAS ON TMPSTAT (TMP_ID, TMP_MAGID, TMP_ARTID, TMP_COUID, TMP_TGFID)');
               Sql.ExecQuery;
               if tran.InTransaction then
                  tran.Commit;
               tran.active := true;
            except
            end;
            try
            Caption := 'Création de la proc stockés'; Update;
            Sql.sql.clear;
            Sql.sql.Add('CREATE PROCEDURE PR_AS_RECUPCB');
            Sql.sql.Add('RETURNS (');
            Sql.sql.Add('    NBR INTEGER)');
            Sql.sql.Add('AS');
            Sql.sql.Add('declare variable ARTID integer ;');
            Sql.sql.Add('declare variable COUID integer ;');
            Sql.sql.Add('declare variable TGFID integer ;');
            Sql.sql.Add('declare variable NEWNUM VARCHAR (13) ;');
            Sql.sql.Add('declare variable NEWKEY integer ;');
            Sql.sql.Add('BEGIN');
            Sql.sql.Add('  Nbr = 0 ;');
            Sql.sql.Add('  For Select  TMP_ARTID,  TMP_COUID, TMP_TGFID');
            Sql.sql.Add('        From tmpstat');
            Sql.sql.Add('       where tmp_id=-1');
            Sql.sql.Add('         and tmp_magid=0');
            Sql.sql.Add('  into :ARTID,  :COUID, :TGFID');
            Sql.sql.Add('  do');
            Sql.sql.Add('  begin');
            Sql.sql.Add('    nbr = nbr+1 ;');
            Sql.sql.Add('    Update tmpstat');
            Sql.sql.Add('       set tmp_magid=1');
            Sql.sql.Add('     Where tmp_id=-1');
            Sql.sql.Add('       and TMP_ARTID = :artid');
            Sql.sql.Add('       and TMP_COUID = :couid');
            Sql.sql.Add('       and TMP_TGFID = :tgfid');
            Sql.sql.Add('       And tmp_magid=0 ;');
            Sql.sql.Add('    Select NEWNUM From Art_CB into :NEWNUM ;');
            Sql.sql.Add('    NEWKEY = Gen_id(general_id,1) ;');
            Sql.sql.Add('    INSERT INTO K');
            Sql.sql.Add('      (K_ID,KRH_ID,KTB_ID,K_VERSION,K_ENABLED,KSE_OWNER_ID,KSE_INSERT_ID,K_INSERTED,KSE_DELETE_ID,K_DELETED,KSE_UPDATE_ID,K_UPDATED,KSE_LOCK_ID,KMA_LOCK_ID)');
            Sql.sql.Add('    VALUES');
            Sql.sql.Add('      (:NEWKEY,-101,-11111379,:NEWKEY,1,-1,-1,Current_timestamp,0,''12/30/1899'',0,Current_timestamp,0,0);');
            Sql.sql.Add('    INSERT INTO artcodebarre');
            Sql.sql.Add('      (CBI_ID,CBI_ARFID,CBI_TGFID,CBI_COUID,CBI_CB,CBI_TYPE,CBI_CLTID,CBI_ARLID,CBI_LOC)');
            Sql.sql.Add('    VALUES');
            Sql.sql.Add('      (:NEWKEY,:ARTID,:TGFID,:COUID,:NEWNUM,1,0,0,0);');
            Sql.sql.Add('    if (nbr>349) then');
            Sql.sql.Add('    begin');
            Sql.sql.Add('      SUSPEND;');
            Sql.sql.Add('      exit ;');
            Sql.sql.Add('    end');
            Sql.sql.Add('  end');
            Sql.sql.Add('  SUSPEND;');
            Sql.sql.Add('END');
            Sql.ExecQuery;
            if tran.InTransaction then
               tran.Commit;
            tran.active := true;
            except
            end;
            
            Db.Close;
            Db.Open;
            tran.Active := true;
            tran2.active := true;
            reg.WriteInteger('PASCAL', 'ENCOURS', 2);
         end;

         if toto < 3 then
         begin
            Caption := 'Vidage de la table tmpstat'; Update;
            Sql.sql.clear;
            Sql.sql.Add('DELETE FROM TMPSTAT WHERE TMP_ID=-1');
            Sql.ExecQuery;
            if tran.InTransaction then
               tran.Commit;
            tran.Active := true;
            reg.WriteInteger('PASCAL', 'ENCOURS', 3);
            Db.Close;
            Db.Open;
            tran.Active := true;
            tran2.active := true;
         end;

         if toto < 4 then
         begin
            IB_lesID.Open ;
            Sql.sql.clear;
            Caption := 'Préparation de la liste des CB'; Update;
            Sql.sql.Add('Insert into TMPSTAT (TMP_ID, TMP_ARTID, TMP_COUID, TMP_TGFID, TMP_MAGID)');
            Sql.sql.Add('SELECT -1, Arf_id,COU_iD,TTV_TGFID, 0');
            Sql.sql.Add('FROM ARTREFERENCE JOIN K ON (K_ID=ARF_ID AND K_ENABLED=1)');
            Sql.sql.Add('                  JOIN PLXTAILLESTRAV ON (TTV_ARTID=ARF_ARTID)');
            Sql.sql.Add('                  JOIN PLXCOULEUR ON (COU_ARTID=ARF_ARTID)');
            Sql.sql.Add('Where ARF_ID<>0');
            IF not(IB_lesID.IsEmpty) then
            	Sql.sql.Add('  and ARF_ID between '+IB_lesIDDE.AsString+' AND '+IB_lesIDVERS.AsString);
            Sql.ExecQuery;
            if tran.InTransaction then
               tran.Commit;
            tran.Active := true;
            reg.WriteInteger('PASCAL', 'ENCOURS', 4);
         end;

         if toto < 5 then
         begin
            Sql.sql.clear;
            IBQue_NbrCbMarque.Open;
            pb.Position := 0;
            pb.Max := IBQue_NbrCbMarqueNBR.AsInteger;
            IBQue_NbrCbMarque.Close;
            Caption := 'Marquage des CB déja présent'; Update;

            nombre := 0;
            IBQue_CBPresent.Open;
            IBQue_CBPresent.First;
            while not IBQue_CBPresent.Eof do
            begin
               pb.Position := pb.Position + 1;
               IBSql_MarqueCb.Params[0].AsInteger := IBQue_CBPresentCBI_ARFID.AsInteger;
               IBSql_MarqueCb.Params[1].AsInteger := IBQue_CBPresentCBI_COUID.AsInteger;
               IBSql_MarqueCb.Params[2].AsInteger := IBQue_CBPresentCBI_TGFID.AsInteger;
               IBSql_MarqueCb.ExecQuery;
               Inc(nombre);
               if nombre > 100 then
               begin
                  Update;
                  if tran2.Intransaction then
                     tran2.commit;
                  tran2.active := true;
                  nombre := 0;
               end;
               IBQue_CBPresent.Next;
            end;
            IBQue_CBPresent.Close;
            if tran2.Intransaction then
               tran2.commit;
            tran2.active := true;
            Db.Close;
            Db.Open;
            tran.Active := true;
            tran2.active := true;

            Caption := 'Récupération des CB'; Update;
        // Création des codes barres
            IBQue_Count.Open;
            pb.Position := 0;
            pb.Max := IBQue_CountNBR.AsInteger;
            IBQue_Count.Close;

            repeat
               IB_RECPUPCB.Open;
               i := IB_RECPUPCB.fields[0].AsInteger;
               pb.position := pb.position + i;
               if tran2.Intransaction then
                  tran2.commit;
               tran2.active := true;
               Update;
            until i = 0;
            pb.position := Pb.Max;
            if tran2.Intransaction then
               tran2.commit;
            tran2.active := true;
            qry_art.Close;
            Tran.Active := true;
            Db.Close;
            Db.Open;
            tran.Active := true;
            tran2.active := true;
            Sql.sql.Clear;
            Sql.sql.Add('DROP PROCEDURE PR_AS_RECUPCB');
            Sql.ExecQuery;
            if tran.InTransaction then
               tran.Commit;
            tran.Active := true;
            tran2.active := true;
            Sql.sql.Clear;
            Sql.sql.Add('DROP INDEX INX_TMPAS');
            Sql.ExecQuery;
            if tran.InTransaction then
               tran.Commit;
            Db.Close;
            Db.Open;
            tran.Active := true;
            tran2.active := true;
            reg.WriteInteger('PASCAL', 'ENCOURS', 5);
         end;
         if toto < 6 then
         begin
            ttsl := tstringlist.Create;
            ttsl.loadfromfile('SuiteAS.sql');
            while ttsl.count > 0 do
            begin
               Update;
               Sql.sql.clear;
               while (ttsl.count > 0) and (trim(ttsl[0]) <> '<----->') do
               begin
                  if trim(ttsl[0]) <> '' then
                     Sql.sql.Add(ttsl[0]);
                  ttsl.delete(0);
               end;
               if (ttsl.count > 0) then
                  ttsl.delete(0);
               if sql.sql.count > 0 then
               begin
                  Caption := Sql.sql[0];
                  Sql.ExecQuery;
                  if tran.InTransaction then
                     tran.Commit;
                  tran.active := true;
               end;
            end;
            ttsl.free;
            reg.WriteInteger('PASCAL', 'ENCOURS', 6);
         end;
         Suite;
         reg.WriteInteger('PASCAL', 'ENCOURS', 0);
         reg.Writestring('PASCAL', 'PATH', '');
         Application.MessageBox('C''est fini', 'FINI', Mb_OK);
      end
      else
      begin
         Suite;
         Close;
      end;
   finally
      reg.free;
   end;
  //
end;

end.

