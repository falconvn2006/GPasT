unit Unit1;

interface

uses
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   StdCtrls, Buttons, Db, IBCustomDataSet, IBQuery, IBDatabase, IBSQL;

type
   TForm1 = class(TForm)
      Edit1: TEdit;
      SpeedButton1: TSpeedButton;
      Edit2: TEdit;
      Label1: TLabel;
      Button1: TButton;
      OD: TOpenDialog;
      base: TIBDatabase;
      tran: TIBTransaction;
      VerifSession: TIBQuery;
      LaSession: TIBQuery;
      VerifTke1: TIBQuery;
      VerifTke2: TIBQuery;
      Sql: TIBSQL;
      QExec: TIBQuery;
      Memo1: TMemo;
      VerifTke3: TIBQuery;
      RecupEspece: TIBQuery;
      Button2: TButton;
      Edit3: TEdit;
      CorTicket100: TIBQuery;
      LB: TListBox;
      Button3: TButton;
      Label2: TLabel;
      ddeb: TEdit;
      dfin: TEdit;
      RechSessionDate: TIBQuery;
      RechSessionDateSES_NUMERO: TIBStringField;
      Lab_Etat: TLabel;
      RechSessionDateSES_ID: TIntegerField;
      Verif100: TIBQuery;
      VerifUnTke: TIBQuery;
      VerifEncaissement: TIBQuery;
      VerifTke4: TIBQuery;
      VerifTke4TKE_ID: TIntegerField;
      VerifTke4TKE_NUMERO: TIntegerField;
      VerifTke5: TIBQuery;
      VerifTke5TKE_NUMERO: TIntegerField;
      VerifTke5Bis: TIBQuery;
      VerifTke5TKE_ID: TIntegerField;
      VerifTke5MONTANT: TFloatField;
      VerifTke5BisMONTANT: TFloatField;
      VerifTke5MONTANT2: TFloatField;
      VerifTke4Bis: TIBQuery;
      VerifTke4BisTKE_ID: TIntegerField;
      VerifTke4BisTKE_NUMERO: TIntegerField;
      CorigeTKE4: TIBQuery;
      CorigeTKE4FDC_ID: TIntegerField;
      CorigeTKE4MEN_ID: TIntegerField;
      CorigeTKE4FDC_MONTANT: TFloatField;
      VerifTke4BisTKE_TOTNETA1: TFloatField;
      VerifTke4TKE_TOTNETA1: TFloatField;
      VerifTke2TKE_ID: TIntegerField;
      VerifTke2TKE_NUMERO: TIntegerField;
      VerifTke2TKE_TOTNETA1: TFloatField;
      VerifTke2Bis: TIBQuery;
      VerifTke2BisCREDEB: TFloatField;
      VerifTke2Ter: TIBQuery;
      VerifTke2TerENCMONTANT: TFloatField;
      VerifTke5Ter: TIBQuery;
      VerifTke5TerENC_ID: TIntegerField;
      VerifTke5TerENC_MONTANT: TFloatField;
      CorigeTKE4FDC_TYP: TIntegerField;
      VerifTke5TerMONTANT: TFloatField;
      VerifTke2TKE_TOTNETA2: TFloatField;
      VerifTke1Bis: TIBQuery;
      QryDiv: TIBQuery;
      QryDivNOM: TIBStringField;
      QryDivSOURCE: TIBStringField;
      VerifTke1TKE_ID: TIntegerField;
      VerifTke1TKE_TOTNETA1: TFloatField;
      VerifTke1MONTANT: TFloatField;
      VerifTke1TKE_NUMERO: TIntegerField;
      veriff150: TIBQuery;
      veriff150MONTANT: TFloatField;
      procedure SpeedButton1Click(Sender: TObject);
      procedure Button1Click(Sender: TObject);
      procedure Button2Click(Sender: TObject);
      procedure Button3Click(Sender: TObject);
      procedure FormCreate(Sender: TObject);
      procedure LBDblClick(Sender: TObject);
   private
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
   if od.execute then
   begin
      edit1.text := od.filename;
      base.close;
      Base.DatabaseName := Edit1.text;
      Base.Open;
      tran.active := true;
      Memo1.lines.clear;
   end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
   sesid: integer;
   Mt: Double;
   ok: boolean;

   function CorrigeTKE4(TKEID, TKEMONTANT: string): Boolean;
   begin
      result := false;
      CorigeTKE4.Params[0].Asinteger := SesId;
      CorigeTKE4.Open;
      if not (CorigeTKE4.IsEmpty) then
      begin
         while (not CorigeTKE4.eof) and (CorigeTKE4FDC_TYP.AsInteger = 0) do
            CorigeTKE4.Next;
         if CorigeTKE4.eof then
            CorigeTKE4.first;
         Memo1.Lines.Add('	INSERT INTO K ');
         Memo1.Lines.Add('	(K_ID,KRH_ID,KTB_ID,K_VERSION,K_ENABLED,KSE_OWNER_ID,KSE_INSERT_ID,K_INSERTED,KSE_DELETE_ID,K_DELETED,KSE_UPDATE_ID,K_UPDATED,KSE_LOCK_ID,KMA_LOCK_ID)');
         Memo1.Lines.Add('	VALUES');
         Memo1.Lines.Add('	(GEN_ID(GENERAL_ID,1),GEN_ID(GENERAL_ID,0),-11111411,GEN_ID(GENERAL_ID,0),1,-1,-1,Current_timestamp,0,''12/30/1899'',0,Current_timestamp,GEN_ID(GENERAL_ID,0),GEN_ID(GENERAL_ID,0));');

         Memo1.Lines.Add('Insert into CSHENCAISSEMENT ');
         Memo1.Lines.Add('(ENC_ID, ENC_TKEID, ENC_MENID, ENC_MONTANT, ENC_ECHEANCE, ENC_DEPENSE, ENC_MOTIF, ENC_LETTRAGE)');
         Memo1.Lines.Add('VALUES');
         Memo1.Lines.Add('(GEN_ID(GENERAL_ID,0), ' + TKEID + ',' +
            CorigeTKE4MEN_ID.AsString + ',' +
            TKEMONTANT + ', Current_timestamp, 0, '''', 0) ;');

         QryDiv.Open; QryDiv.First;
         if not QryDiv.IsEmpty then
         begin
            Memo1.Lines.Add('UPDATE CSHENCAISSEMENT');
            if (trim(QryDivSOURCE.AsString) = 'ALGOL_DOUBLE') or
               (trim(QryDivSOURCE.AsString) = 'ALGOL_FLOAT') or
               (trim(QryDivSOURCE.AsString) = 'ALGOL_INTEGER') or
               (trim(QryDivSOURCE.AsString) = 'ALGOL_KEY') then
               Memo1.Lines.Add('SET ' + QryDivNOM.AsString + ' = 0 ')
            else if Copy(trim(QryDivSOURCE.AsString), 1, 13) = 'ALGOL_VARCHAR' then
               Memo1.Lines.Add('SET ' + QryDivNOM.AsString + ' = '''' ')
            else
               Memo1.Lines.Add('SET ' + QryDivNOM.AsString + ' = NULL ');
            QryDiv.Next;
            while not QryDiv.Eof do
            begin
               if (trim(QryDivSOURCE.AsString) = 'ALGOL_DOUBLE') or
                  (trim(QryDivSOURCE.AsString) = 'ALGOL_FLOAT') or
                  (trim(QryDivSOURCE.AsString) = 'ALGOL_INTEGER') or
                  (trim(QryDivSOURCE.AsString) = 'ALGOL_KEY') then
                  Memo1.Lines.Add(', ' + QryDivNOM.AsString + ' = 0 ')
               else if Copy(trim(QryDivSOURCE.AsString), 1, 13) = 'ALGOL_VARCHAR' then
                  Memo1.Lines.Add(', ' + QryDivNOM.AsString + ' = '''' ')
               else
                  Memo1.Lines.Add(', ' + QryDivNOM.AsString + ' = NULL ');
               QryDiv.Next;
            end;
            Memo1.Lines.add('WHERE ENC_ID=GEN_ID(GENERAL_ID,0)');
         end;
         QryDiv.Close;


         Memo1.Lines.Add('Update k');
         Memo1.Lines.Add('set k_version=gen_id(general_id,1), KRH_ID=gen_id(general_id,0), KSE_LOCK_ID=gen_id(general_id,0),KMA_LOCK_ID=gen_id(general_id,0)');
         Memo1.Lines.Add('where k_id=' + CorigeTKE4FDC_ID.AsString + '; ');

         Memo1.Lines.Add('Update CshFondcaisse');
         Memo1.Lines.Add('set fdc_Montant= ' + CorigeTKE4FDC_MONTANT.AsString + '-' + TKEMONTANT);
         Memo1.Lines.Add('where fdc_id=' + CorigeTKE4FDC_ID.AsString + ' ;');

         Sql.Sql.Clear;
         Sql.Sql.Add('	INSERT INTO K ');
         Sql.Sql.Add('	(K_ID,KRH_ID,KTB_ID,K_VERSION,K_ENABLED,KSE_OWNER_ID,KSE_INSERT_ID,K_INSERTED,KSE_DELETE_ID,K_DELETED,KSE_UPDATE_ID,K_UPDATED,KSE_LOCK_ID,KMA_LOCK_ID)');
         Sql.Sql.Add('	VALUES');
         Sql.Sql.Add('	(GEN_ID(GENERAL_ID,1),gen_id(general_id,0),-11111411,GEN_ID(GENERAL_ID,0),1,-1,-1,Current_timestamp,0,''12/30/1899'',0,Current_timestamp,gen_id(general_id,0),gen_id(general_id,0));');
         SQL.ExecQuery;

         Sql.Sql.Clear;
         Sql.Sql.Add('Insert into CSHENCAISSEMENT ');
         Sql.Sql.Add('(ENC_ID, ENC_TKEID, ENC_MENID, ENC_MONTANT, ENC_ECHEANCE, ENC_DEPENSE, ENC_MOTIF, ENC_LETTRAGE)');
         Sql.Sql.Add('VALUES');
         Sql.Sql.Add('(GEN_ID(GENERAL_ID,0), ' + TKEID + ',' + CorigeTKE4MEN_ID.AsString + ',' + TKEMONTANT + ', Current_timestamp, 0, '''', 0) ;');
         SQL.ExecQuery;
         Sql.Sql.Clear;
         QryDiv.Open; QryDiv.First;
         if not QryDiv.IsEmpty then
         begin
            Sql.Sql.Add('UPDATE CSHENCAISSEMENT');
            if (trim(QryDivSOURCE.AsString) = 'ALGOL_DOUBLE') or
               (trim(QryDivSOURCE.AsString) = 'ALGOL_FLOAT') or
               (trim(QryDivSOURCE.AsString) = 'ALGOL_INTEGER') or
               (trim(QryDivSOURCE.AsString) = 'ALGOL_KEY') then
               Sql.Sql.Add('SET ' + QryDivNOM.AsString + ' = 0 ')
            else if Copy(trim(QryDivSOURCE.AsString), 1, 13) = 'ALGOL_VARCHAR' then
               Sql.Sql.Add('SET ' + QryDivNOM.AsString + ' = '''' ')
            else
               Sql.Sql.Add('SET ' + QryDivNOM.AsString + ' = NULL ');
            QryDiv.Next;
            while not QryDiv.Eof do
            begin
               if (trim(QryDivSOURCE.AsString) = 'ALGOL_DOUBLE') or
                  (trim(QryDivSOURCE.AsString) = 'ALGOL_FLOAT') or
                  (trim(QryDivSOURCE.AsString) = 'ALGOL_INTEGER') or
                  (trim(QryDivSOURCE.AsString) = 'ALGOL_KEY') then
                  Sql.Sql.Add(', ' + QryDivNOM.AsString + ' = 0 ')
               else if Copy(trim(QryDivSOURCE.AsString), 1, 13) = 'ALGOL_VARCHAR' then
                  Sql.Sql.Add(', ' + QryDivNOM.AsString + ' = '''' ')
               else
                  Sql.Sql.Add(', ' + QryDivNOM.AsString + ' = NULL ');
               QryDiv.Next;
            end;
            Sql.Sql.add('WHERE ENC_ID=GEN_ID(GENERAL_ID,0)');
            SQL.ExecQuery;
            Sql.Sql.Clear;
         end;
         QryDiv.Close;

         Sql.Sql.Clear;
         Sql.Sql.Add('Update k');
         Sql.Sql.Add('set k_version=gen_id(general_id,1), KRH_ID=gen_id(general_id,0), KSE_LOCK_ID=gen_id(general_id,0),KMA_LOCK_ID=gen_id(general_id,0)');
         Sql.Sql.Add('where k_id=' + CorigeTKE4FDC_ID.AsString + '; ');
         SQL.ExecQuery;
         Sql.Sql.Clear;

         Sql.Sql.Add('Update CshFondcaisse');
         Sql.Sql.Add('set fdc_Montant= ' + CorigeTKE4FDC_MONTANT.AsString + '-' + TKEMONTANT);
         Sql.Sql.Add('where fdc_id=' + CorigeTKE4FDC_ID.AsString + ' ;');
         SQL.ExecQuery;
         Sql.Sql.Clear;

         Result := true;
      end;
      CorigeTKE4.Close;
   end;

begin
   Base.close;
   Base.open;
   LaSession.ParamByName('Numero').AsString := edit2.text;
   LaSession.Open;
   sesid := LaSession.FieldByName('SES_ID').AsInteger;
   LaSession.Close;
   Caption := 'Vérification de la cohérence de la session';
   VerifSession.ParamByName('SESID').Asinteger := SesId;
   VerifSession.Open;
   VerifSession.Last;
   Mt := VerifSession.fields[0].AsFloat;
   VerifSession.Close;
   if abs(Mt) < 0.01 then
      application.messageBox('JE NE CORRIGE PAS LES SESSIONS JUSTES', 'ATTENTION', Mb_Ok)
   else
   begin
      repeat
         ok := false;
         Caption := 'Recherche de Ticket non équilibrés';
         VerifTke1.Params[0].Asinteger := SesId;
         VerifTke1.Open;
         if not VerifTke1.IsEmpty then
         begin
            // erreur de ticket entre TKE et TKL
            Ok := false ;
            while not VerifTke1.Eof do
            begin
               veriff150.Params[0].Asinteger := VerifTke1.Fields[0].Asinteger;
               veriff150.Open;
               if Abs(veriff150MONTANT.AsFloat) > 0.009 then
               begin
                  veriff150.close;
                  VerifTke1.next ;
                  continue;
               end;
               veriff150.close ;
               Memo1.Lines.Add('SES ' + Edit2.text + '  TCK ' + VerifTke1.Fields[3].AsString + '  Non Equilibré ');
               Memo1.Update;
               Verif100.Params[0].Asinteger := VerifTke1.Fields[0].Asinteger;
               Verif100.Open;
               if not Verif100.IsEmpty then
               begin
                  Memo1.Lines.Add('   une Lignes du ticket n''est pas conforme ');
                  Memo1.Update;
                  while not Verif100.Eof do
                  begin
                     Sql.sql.clear;
                     Sql.sql.Add('UPDATE K SET K_VERSION=Gen_id(general_id,1), KRH_ID=gen_id(general_id,0), KSE_LOCK_ID=gen_id(general_id,0),KMA_LOCK_ID=gen_id(general_id,0) where K_ID = :ID');
                     Sql.Params[0].Asinteger := Verif100.Fields[0].AsInteger;
                     Sql.ExecQuery;
                     Sql.sql.clear;
                     Sql.sql.Add('UPDATE CshTicketL SET TKL_PXNN=TKL_PXNET/TKL_QTE where TKL_ID = :ID');
                     Sql.Params[0].Asinteger := Verif100.Fields[0].AsInteger;
                     Sql.ExecQuery;
                     Verif100.Next;
                  end;
               end;
               Verif100.Close;

               verifunTke.Params[0].AsInteger := VerifTke1.Fields[0].Asinteger;
               verifunTke.Open;
               if Abs(verifunTke.fields[0].AsFloat - verifunTke.fields[1].AsFloat) > 0.009 then
               begin
                  Memo1.Lines.Add('   La somme du ticket est différente du montant ');
                  Memo1.Update;
                  VerifEncaissement.Params[0].AsInteger := VerifTke1.Fields[0].Asinteger;
                  VerifEncaissement.Open;
                  if abs((VerifEncaissement.Fields[1].AsFloat - verifunTke.fields[1].AsFloat)) < 0.01 then
                  begin
                            // le montant du ticket est faux mais l'encaissement correspond à la somme des lignes
                     Memo1.Lines.Add('      Montant du ticket diff de l''encaissement');
                     Memo1.Update;
                     Sql.sql.clear;
                     Sql.sql.Add('UPDATE K SET K_VERSION=Gen_id(general_id,1), KRH_ID=gen_id(general_id,0), KSE_LOCK_ID=gen_id(general_id,0),KMA_LOCK_ID=gen_id(general_id,0) where K_ID = :ID');
                     Sql.Params[0].Asinteger := VerifTke1.Fields[0].Asinteger;
                     Sql.ExecQuery;
                     Qexec.sql.clear;
                     Qexec.sql.Add('UPDATE CshTicket SET TKE_TOTNETA1= :Montant where TKE_ID = :ID');
                     Qexec.Prepare;
                     Qexec.paramByName('ID').AsInteger := VerifTke1.Fields[0].Asinteger;
                     Qexec.paramByName('MONTANT').AsFloat := VerifEncaissement.Fields[1].AsFloat;
                     Qexec.ExecSQL;
                     Qexec.UnPrepare;
                  end
                  else
                  begin
                     Memo1.Lines.Add('      Somme des lignes diff de l''encaissement');
                     Memo1.Lines.Add('      Peut pas corriger');
                     Ok := true;
                  end;
               end;
               verifunTke.Close;
               VerifTke1.Next;
            end;
            if tran.intransaction then
               tran.commit;
         end;
         VerifTke1.Close;
         VerifTke1Bis.Params[0].Asinteger := SesId;
         VerifTke1Bis.Open;
         if not VerifTke1Bis.IsEmpty then
         begin
            while not VerifTke1Bis.Eof do
            begin
               Memo1.Lines.Add('LOCATION SES ' + Edit2.text + '  TCK ' + VerifTke1Bis.Fields[3].AsString + '  Non Equilibré ');
               Memo1.Update;
               VerifTke1Bis.Next;
            end;
         end;
         VerifTke1Bis.Close;

         if not ok then
         begin
            Caption := 'Recherche de problème en encaissement';
            VerifTke3.Params[0].Asinteger := SesId;
            VerifTke3.Open;
            if not VerifTke3.isempty then
            begin
               // erreur entre encaissement et compte client
               ok := true;
               while not VerifTke3.Eof do
               begin
                  Memo1.Lines.Add('SES ' + Edit2.text + '  TCK ' + VerifTke3.Fields[0].AsString + '  Encaissement sur ID 0 ');
                  Memo1.Update;
                  RecupEspece.Params[0].Asinteger := SesId;
                  RecupEspece.Open;
                  if RecupEspece.IsEmpty then
                  begin
                     Memo1.Lines.Add('Peut pas le corriger, pas de fond de caisse en espece ');
                     Memo1.Update;
                  end
                  else
                  begin
                     Sql.sql.clear;
                     Sql.sql.Add('UPDATE K SET K_VERSION=Gen_id(general_id,1), KRH_ID=gen_id(general_id,0), KSE_LOCK_ID=gen_id(general_id,0),KMA_LOCK_ID=gen_id(general_id,0) where K_ID = :ID');
                     Sql.Params[0].Asinteger := VerifTke3.Fields[1].AsInteger;
                     Sql.ExecQuery;
                     QExec.sql.clear;
                     QExec.sql.Add('Update CSHEncaissement');
                     QExec.sql.Add('SET ENC_MENID=:MENID');
                     QExec.sql.Add('WHERE ENC_ID = :ID');
                     QExec.Prepare;
                     QExec.ParamByName('ID').AsInteger := VerifTke3.Fields[1].AsInteger;
                     QExec.ParamByName('MENID').AsInteger := RecupEspece.Fields[0].AsInteger;
                     QExec.ExecSql;
                     QExec.UnPrepare;

                     Sql.sql.clear;
                     Sql.sql.Add('UPDATE K SET K_VERSION=Gen_id(general_id,1), KRH_ID=gen_id(general_id,0), KSE_LOCK_ID=gen_id(general_id,0),KMA_LOCK_ID=gen_id(general_id,0) where K_ID = :ID');
                     Sql.Params[0].Asinteger := RecupEspece.Fields[1].AsInteger;
                     Sql.ExecQuery;
                     QExec.sql.clear;
                     QExec.sql.Add('Update CSHfondcaisse');
                     QExec.sql.Add('SET FDC_MONTANT=FDC_MONTANT-:MT');
                     QExec.sql.Add('WHERE FDC_ID = :ID');
                     QExec.Prepare;
                     QExec.ParamByName('ID').AsInteger := RecupEspece.Fields[1].AsInteger;
                     QExec.ParamByName('MT').AsFloat := VerifTke3.Fields[2].AsFloat;
                     QExec.ExecSql;
                     QExec.UnPrepare;
                  end;
                  RecupEspece.Close;
                  VerifTke3.Next;
               end;
               if tran.intransaction then
                  tran.commit;
               tran.active := true;
            end;
            VerifTke3.Close;
         end;
         if not ok then
         begin
            Caption := 'Recherche de problème sans encaissement';
            VerifTke4.Params[0].Asinteger := SesId;
            VerifTke4.Open;
            if not VerifTke4.isempty then
            begin
               while not VerifTke4.Eof do
               begin
                  Memo1.lines.add('Le ticket ' + VerifTke4TKE_NUMERO.AsString + ' N''à pas d''encaissement ');
                  Memo1.Update;
                  if not ok then
                     OK := CorrigeTKE4(VerifTke4TKE_ID.AsString, VerifTke4TKE_TOTNETA1.AsString)
                  else
                     CorrigeTKE4(VerifTke4TKE_ID.AsString, VerifTke4TKE_TOTNETA1.AsString);
                  Memo1.Update;
                  VerifTke4.Next;
               end;
            end;
            VerifTke4.close;

            VerifTke4Bis.Params[0].Asinteger := SesId;
            VerifTke4Bis.Open;
            if not VerifTke4Bis.isempty then
            begin
               while not VerifTke4Bis.Eof do
               begin
                  Memo1.lines.add('Le ticket ' + VerifTke4BisTKE_NUMERO.AsString + ' N''à pas d''encaissement ');
                  Memo1.Update;
                  if not ok then
                     OK := CorrigeTKE4(VerifTke4BisTKE_ID.AsString, VerifTke4BisTKE_TOTNETA1.AsString)
                  else
                     CorrigeTKE4(VerifTke4BisTKE_ID.AsString, VerifTke4BisTKE_TOTNETA1.AsString);
                  Memo1.Update;
                  VerifTke4Bis.Next;
               end;
            end;
            VerifTke4Bis.close;
         end;

         if not ok then
         begin
            Caption := 'Recherche de problème sur un encaissement';
            VerifTke5.Params[0].Asinteger := SesId;
            VerifTke5.Open;
            if not VerifTke5.isempty then
            begin
               while not VerifTke5.Eof do
               begin
                  veriff150.Params[0].Asinteger := VerifTke5TKE_ID.AsInteger;
                  veriff150.Open;
                  if Abs(veriff150MONTANT.AsFloat) > 0.009 then
                  begin
                     veriff150.close;
                     VerifTke5.next ;
                     continue;
                  end;
                  veriff150.close;

                  VerifTke5Bis.ParamByName('TKE_ID').AsInteger := VerifTke5TKE_ID.AsInteger;
                  VerifTke5Bis.Open;
                  if Abs(VerifTke5MONTANT.AsFloat - VerifTke5BisMONTANT.AsFloat - VerifTke5MONTANT2.AsFloat) > 0.009 then
                  begin
                     Memo1.lines.add('Le ticket ' + VerifTke5TKE_NUMERO.AsString + ' à un encaissement différent de la somme');
                     VerifTke5Ter.ParamByName('TKE_ID').AsInteger := VerifTke5TKE_ID.AsInteger;
                     VerifTke5Ter.open;
                     if Abs(VerifTke5MONTANT.AsFloat - VerifTke5BisMONTANT.AsFloat - VerifTke5MONTANT2.AsFloat - VerifTke5TerENC_MONTANT.AsFloat - VerifTke5TerENC_MONTANT.AsFloat) < 0.009 then
                     begin
                        if not VerifTke5Ter.Eof then
                        begin
                           Memo1.lines.add('Update K');
                           Memo1.lines.add('set K_VERSION=GEN_ID(GENERAL_ID,1), KRH_ID=gen_id(general_id,0), KSE_LOCK_ID=gen_id(general_id,0),KMA_LOCK_ID=gen_id(general_id,0)');
                           Memo1.lines.add('where K_id= ' + VerifTke5TerENC_ID.AsString + ';');

                           Memo1.lines.add('Update CshEncaissement');
                           if VerifTke5TerENC_MONTANT.AsFloat > 0 then
                              Memo1.lines.add('set enc_montant=-' + VerifTke5TerENC_MONTANT.AsString)
                           else
                              Memo1.lines.add('set enc_montant=' + VerifTke5TerMONTANT.AsString);
                           Memo1.lines.add('where enc_id= ' + VerifTke5TerENC_ID.AsString + ';');

                           SQL.SQL.CLEAR;
                           SQL.SQL.add('Update K');
                           SQL.SQL.add('set K_VERSION=GEN_ID(GENERAL_ID,1), KRH_ID=gen_id(general_id,0), KSE_LOCK_ID=gen_id(general_id,0),KMA_LOCK_ID=gen_id(general_id,0)');
                           SQL.SQL.add('where K_id= ' + VerifTke5TerENC_ID.AsString + ';');
                           SQL.ExecQuery;
                           SQL.SQL.CLEAR;

                           SQL.SQL.add('Update CshEncaissement');
                           if VerifTke5TerENC_MONTANT.AsFloat > 0 then
                              SQL.SQL.add('set enc_montant=-' + VerifTke5TerENC_MONTANT.AsString)
                           else
                              SQL.SQL.add('set enc_montant=' + VerifTke5TerMONTANT.AsString);
                           SQL.SQL.add('where enc_id= ' + VerifTke5TerENC_ID.AsString + ';');
                           SQL.ExecQuery;
                           ok := true;
                        end;
                     end
                     else
                           ok := true;
                     VerifTke5Ter.Close;
                  end;
                  VerifTke5Bis.Close;
                  Memo1.Update;
                  VerifTke5.Next;
               end;
            end;
            VerifTke5.close;
         end;

         if not ok then
         begin
            Caption := 'Recherche de problème en compte client';
            VerifTke2.Params[0].Asinteger := SesId;
            VerifTke2.Open;
            if not VerifTke2.isempty then
            begin
                     // erreur entre encaissement et compte client
               while not VerifTke2.Eof do
               begin
                  VerifTke2Bis.Params[0].AsInteger := VerifTke2TKE_ID.AsInteger;
                  VerifTke2Ter.Params[0].AsInteger := VerifTke2TKE_ID.AsInteger;
                  VerifTke2Bis.Open; VerifTke2Ter.Open;

                  if Abs(VerifTke2TKE_TOTNETA1.AsFloat + VerifTke2TKE_TOTNETA2.AsFloat + VerifTke2BisCREDEB.AsFloat - VerifTke2TerENCMONTANT.AsFloat) > 0.009 then
                  begin
                     Memo1.Lines.Add('SES ' + Edit2.text + '  TCK ' + VerifTke2.Fields[1].AsString + '  sans doute Prob Compte Client ');
                     Memo1.Update;
                  end;
                  VerifTke2Ter.Close;
                  VerifTke2Bis.Close;

                  VerifTke2.Next;
               end;
               if tran.intransaction then
                  tran.commit;
               tran.active := true;
            end;
            VerifTke2.Close;
         end;
         if tran.intransaction then
            tran.commit;
         tran.active := true;
         if ok then
         begin
            Caption := 'Vérification de la cohérence de la session';
            VerifSession.Open;
            VerifSession.Last;
            Mt := VerifSession.fields[0].AsFloat;
            VerifSession.Close;
         end;
      UNTIL (ok) or (Abs(mt) < 0.01);
      if abs(Mt) < 0.01 then
         application.messageBox('SESSION CORRIGE', 'OK', Mb_Ok)
      else
         application.messageBox('ATTENTION LA SESSION N''EST PAS CORRIGE', 'ATTENTION', Mb_Ok);
      Caption := 'Attente';
   end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
   sesid: integer;
begin
   DecimalSeparator := '.';
   LaSession.ParamByName('Numero').AsString := edit2.text;
   LaSession.Open;
   sesid := LaSession.FieldByName('SES_ID').AsInteger;
   LaSession.Close;
   CorTicket100.ParamByName('SESID').AsInteger := SESID;
   CorTicket100.ParamByName('NUM').AsString := edit3.text;
   CorTicket100.Open;
   while not CorTicket100.EOF do
   begin
      Sql.sql.clear;
      Sql.sql.Add('UPDATE K SET K_VERSION=Gen_id(general_id,1), KRH_ID=gen_id(general_id,0), KSE_LOCK_ID=gen_id(general_id,0),KMA_LOCK_ID=gen_id(general_id,0) where K_ID = :ID');
      Sql.Params[0].Asinteger := CorTicket100.Fields[0].AsInteger;
      Sql.ExecQuery;
      Sql.sql.clear;
      Sql.sql.Add('UPDATE CshTicketL SET TKL_PXNN=TKL_PXNET/TKL_QTE where TKL_ID = :ID');
      Sql.Params[0].Asinteger := CorTicket100.Fields[0].AsInteger;
      Sql.ExecQuery;
      CorTicket100.Next;
   end;
   CorTicket100.Close;
   if tran.intransaction then
      tran.commit;
   tran.active := true;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
   Nb: string;
   i: integer;
begin
   RechSessionDate.parambyname('DDEB').AsDateTime := StrToDate(ddeb.text);
   RechSessionDate.parambyname('DFIN').AsDateTime := StrToDate(dFin.text);
   RechSessionDate.Open;
   RechSessionDate.Last;
   RechSessionDate.first;
   Nb := Inttostr(RechSessionDate.RecordCount);
   i := 0;
   Lb.items.clear;
   while not RechSessionDate.eof do
   begin
      inc(i);
      Lab_etat.Caption := RechSessionDateSES_NUMERO.AsString + '   ' + Inttostr(i) + '/' + nb;
      Lab_etat.update;
      if Pos('-', RechSessionDateSES_NUMERO.AsString) > 0 then
      begin
         VerifSession.paramByName('SESID').AsInteger := RechSessionDateSES_ID.Asinteger;
         VerifSession.Open;
         VerifSession.Last;
         if abs(VerifSession.fields[0].AsFloat) > 0.009 then
         begin
            Lb.items.Add(RechSessionDateSES_NUMERO.AsString);
            Lb.Update;
         end;
         VerifSession.close;
      end;
      RechSessionDate.next;
   end;
   RechSessionDate.close;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
   DecimalSeparator := '.';
end;

procedure TForm1.LBDblClick(Sender: TObject);
begin
   if lb.itemindex > -1 then
   begin
      edit2.text := lb.items[lb.itemIndex];
   end;
end;

end.

