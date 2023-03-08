//$Log:
// 2    Utilitaires1.1         30/05/2005 08:55:21    pascal         
//      Modification pour une execution automatique par la MAJ Ginkoia
// 1    Utilitaires1.0         27/04/2005 10:41:35    pascal          
//$
//$NoKeywords$
//
unit UParam;

interface

uses
   Registry,
   Umapping,
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   IBSQL, StdCtrls, Buttons, Db, IBCustomDataSet, IBQuery, IBDatabase,
   ComCtrls;

type
   TForm1 = class(TForm)
      Base: TIBDatabase;
      Tran: TIBTransaction;
      IBQue_ListeRepli: TIBQuery;
      IBQue_ListeRepliREPLNO: TIntegerField;
      Edit1: TEdit;
      Label1: TLabel;
      Edit2: TEdit;
      Label2: TLabel;
      SpeedButton1: TSpeedButton;
      SpeedButton2: TSpeedButton;
      Od: TOpenDialog;
      Button1: TButton;
      Sql: TIBSQL;
      Label3: TLabel;
      Edit3: TEdit;
      SpeedButton3: TSpeedButton;
      IBQue_ListeTable: TIBQuery;
      IBQue_ListeTableNOM: TIBStringField;
      IBQue_ListeProc: TIBQuery;
      IBQue_ListeProcNOM: TIBStringField;
      Pb: TProgressBar;
      IBQue_ListeRepliPUBDBNO: TIntegerField;
      IBQue_ListeRepliSUBDBNO: TIntegerField;
      IBQue_Relations: TIBQuery;
      IBQue_RelationsRELATIONNO: TIntegerField;
      IBQue_RelationsRELATIONNAME: TIBStringField;
      Que_lestriggers: TIBQuery;
      Que_lestriggersTRIG: TIBStringField;
      IBQue_ReplExists: TIBQuery;
      IBQue_ReplExistsNAME: TIBStringField;
      IBQue_RelationsFIELDNAME: TIBStringField;
      procedure Button1Click(Sender: TObject);
      procedure SpeedButton3Click(Sender: TObject);
      procedure SpeedButton1Click(Sender: TObject);
      procedure SpeedButton2Click(Sender: TObject);
      procedure FormShow(Sender: TObject);
      procedure FormCreate(Sender: TObject);
      procedure FormActivate(Sender: TObject);
   private
    { Déclarations privées }
   public
    { Déclarations publiques }
      refrepli: string;
      BaseMaitre: string;
      BaseEleve: string;
      Premier: Boolean;
   end;

var
   Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
var
   reg: TRegistry;
   REPLNO: string;
   PUBDBNO: string;
   SUBDBNO: string;
   tsl: tstringlist;
   i: integer;
   S, S1, S2, S3: string;
   S5: string;
begin
   enabled := false;
   try
    //
      refrepli := Edit3.Text;
      BaseMaitre := Edit1.Text;
      BaseEleve := Edit2.Text;
      reg := Tregistry.Create;
      try
         reg.Access := KEY_WRITE;
         Reg.RootKey := HKEY_LOCAL_MACHINE;
         reg.OpenKey('Software\Algol\Ginkoia', True);
         reg.WriteString('REPL_REFERENCE', refrepli);
         reg.WriteString('REPL_MAITRE', BaseMaitre);
         reg.WriteString('REPL_ELEVE', BaseEleve);
      finally
         reg.free;
      end;

        // référence de la réplication
      reg := Tregistry.Create;
      try
         reg.Access := KEY_WRITE;
         Reg.RootKey := HKEY_LOCAL_MACHINE;
         reg.OpenKey('SOFTWARE\Synectics Software\Replicator\Configurations', True);
         reg.WriteString('DefaultCfg', 'Algol replication');
         reg.CloseKey;
         reg.OpenKey('SOFTWARE\Synectics Software\Replicator\Configurations\Algol replication', True);
         reg.WriteString('DbName', refrepli);
         reg.WriteString('Password', 'öMHEaÅé?');
         reg.WriteString('Username', 'sysdba');
      finally
         reg.free;
      end;

      screen.cursor := crhourglass;
      tsl := tstringlist.create;
      try
         Base.close;
         Base.DatabaseName := refrepli;
         Base.Open;
         Tran.Active := true;
         IBQue_ListeRepli.Open;
         REPLNO := IBQue_ListeRepliREPLNO.AsString;
         PUBDBNO := IBQue_ListeRepliPUBDBNO.AsString;
         SUBDBNO := IBQue_ListeRepliSUBDBNO.AsString;
         IBQue_ListeRepli.Close;
         Sql.sql.clear;
         Sql.Sql.Add('Update DATABASES');
         Sql.Sql.Add('SET DBPATH=' + QuotedStr(BaseMaitre));
         Sql.Sql.Add('WHERE DBNO=' + PUBDBNO);
         Sql.ExecQuery;

         Sql.Sql.Clear;
         Sql.Sql.Add('Update DATABASES');
         Sql.Sql.Add('SET DBPATH=' + QuotedStr(BaseEleve));
         Sql.Sql.Add('WHERE DBNO=' + SUBDBNO);
         Sql.ExecQuery;

         if Tran.InTransaction then
            Tran.commit;
         Tran.Active := true;

         IBQue_Relations.Open;
         IBQue_Relations.First;
         while not IBQue_Relations.Eof do
         begin
            tsl.add(IBQue_RelationsRELATIONNO.AsString + ';' + IBQue_RelationsRELATIONNAME.AsString + ';' + IBQue_RelationsFIELDNAME.AsString);
            IBQue_Relations.next;
         end;
         IBQue_Relations.close;

         Base.close;

         Base.databasename := BaseMaitre;
         Base.Open;
         tran.active := true;

        // Suppression des anciens triggers
         Que_lestriggers.Open;
         Que_lestriggers.Last;
         Que_lestriggers.first;
         Pb.Max := Que_lestriggers.RecordCount + tsl.count;
         Pb.Position := 0;
         while not Que_lestriggers.eof do
         begin
            Pb.Position := Pb.Position + 1;
            Sql.Sql.Clear;
            Sql.Sql.Add('drop trigger ' + Que_lestriggersTRIG.AsString);
            Sql.ExecQuery;
            Que_lestriggers.next;
         end;
         Que_lestriggers.close;
         if Tran.InTransaction then
            Tran.commit;
         Tran.Active := true;

        // Création des tables et divers
         IBQue_ReplExists.Open;
         if IBQue_ReplExists.IsEmpty then
         begin
            Sql.Sql.Clear;
            Sql.Sql.Add('CREATE GENERATOR REPL_GENERATOR ;');
            Sql.ExecQuery;
            Sql.Sql.Clear;
            Sql.Sql.Add('CREATE TABLE MANUAL_LOG (');
            Sql.Sql.Add('    REPLNO INTEGER NOT NULL,');
            Sql.Sql.Add('    PUBDBNO INTEGER NOT NULL,');
            Sql.Sql.Add('    SUBDBNO INTEGER NOT NULL,');
            Sql.Sql.Add('    SEQNO INTEGER NOT NULL,');
            Sql.Sql.Add('    RELATIONNO INTEGER NOT NULL,');
            Sql.Sql.Add('    REPTYPE CHAR (1) CHARACTER SET NONE COLLATE NONE,');
            Sql.Sql.Add('    OLDKEY VARCHAR (256) CHARACTER SET NONE COLLATE NONE,');
            Sql.Sql.Add('    NEWKEY VARCHAR (256) CHARACTER SET NONE COLLATE NONE,');
            Sql.Sql.Add('    FORCECOUNT INTEGER DEFAULT 0,');
            Sql.Sql.Add('    ERROR_CODE INTEGER,');
            Sql.Sql.Add('    ERROR_MSG VARCHAR (256) CHARACTER SET NONE COLLATE NONE);');
            try Sql.ExecQuery; except; end; Sql.Sql.Clear;
            Sql.Sql.Add('ALTER TABLE MANUAL_LOG ADD PRIMARY KEY (REPLNO, PUBDBNO, SUBDBNO, SEQNO);');
            try Sql.ExecQuery; except; end; Sql.Sql.Clear;
            Sql.Sql.Add('GRANT ALL ON MANUAL_LOG TO GINKOIA');
            try Sql.ExecQuery; except; end; Sql.Sql.Clear;
            Sql.Sql.Add('GRANT ALL ON MANUAL_LOG TO REPL');
            try Sql.ExecQuery; except; end; Sql.Sql.Clear;
            Sql.Sql.Add('CREATE TABLE REPL_LOG (');
            Sql.Sql.Add('    REPLNO INTEGER NOT NULL,');
            Sql.Sql.Add('    PUBDBNO INTEGER NOT NULL,');
            Sql.Sql.Add('    SUBDBNO INTEGER NOT NULL,');
            Sql.Sql.Add('    SEQNO INTEGER NOT NULL,');
            Sql.Sql.Add('    RELATIONNO INTEGER NOT NULL,');
            Sql.Sql.Add('    REPTYPE CHAR (1) CHARACTER SET NONE COLLATE NONE,');
            Sql.Sql.Add('    OLDKEY VARCHAR (256) CHARACTER SET NONE COLLATE NONE,');
            Sql.Sql.Add('    NEWKEY VARCHAR (256) CHARACTER SET NONE COLLATE NONE,');
            Sql.Sql.Add('    FORCECOUNT INTEGER DEFAULT 0);');
            try Sql.ExecQuery; except; end; Sql.Sql.Clear;
            Sql.Sql.Add('ALTER TABLE REPL_LOG ADD PRIMARY KEY (REPLNO, PUBDBNO, SUBDBNO, SEQNO);');
            try Sql.ExecQuery; except; end; Sql.Sql.Clear;
            Sql.Sql.Add('CREATE INDEX I_REPL_LOG ON REPL_LOG (SEQNO);');
            try Sql.ExecQuery; except; end; Sql.Sql.Clear;
            Sql.Sql.Add('GRANT ALL ON REPL_LOG TO GINKOIA');
            try Sql.ExecQuery; except; end; Sql.Sql.Clear;
            Sql.Sql.Add('GRANT ALL ON REPL_LOG TO REPL');
            try Sql.ExecQuery; except; end; Sql.Sql.Clear;
            Sql.Sql.Add('CREATE TRIGGER REPL_GEN_SEQNO FOR REPL_LOG ACTIVE');
            Sql.Sql.Add('       BEFORE INSERT POSITION 0');
            Sql.Sql.Add('AS');
            Sql.Sql.Add('BEGIN');
            Sql.Sql.Add('  NEW.SEQNO = GEN_ID(REPL_GENERATOR,1);');
            Sql.Sql.Add('  POST_EVENT ''REPLNOW'';');
            Sql.Sql.Add('END ;');
            try Sql.ExecQuery; except; end; Sql.Sql.Clear;
            Sql.Sql.Add('CREATE TABLE REPL_SEPARATOR (');
            Sql.Sql.Add('    REPLNO INTEGER NOT NULL,');
            Sql.Sql.Add('    PUBDBNO INTEGER NOT NULL,');
            Sql.Sql.Add('    SUBDBNO INTEGER NOT NULL,');
            Sql.Sql.Add('    RELATIONNO INTEGER NOT NULL,');
            Sql.Sql.Add('    RELATIONNAME VARCHAR (100) CHARACTER SET NONE NOT NULL COLLATE NONE,');
            Sql.Sql.Add('    SEP CHAR (1) CHARACTER SET NONE COLLATE NONE);');
            try Sql.ExecQuery; except; end; Sql.Sql.Clear;
            Sql.Sql.Add('ALTER TABLE REPL_SEPARATOR ADD PRIMARY KEY (REPLNO, PUBDBNO, SUBDBNO, RELATIONNO);');
            try Sql.ExecQuery; except; end; Sql.Sql.Clear;
            try Sql.ExecQuery; except; end; Sql.Sql.Clear;
            Sql.Sql.Add('GRANT ALL ON REPL_SEPARATOR TO GINKOIA');
            try Sql.ExecQuery; except; end; Sql.Sql.Clear;
            Sql.Sql.Add('GRANT ALL ON REPL_SEPARATOR TO REPL');
            try Sql.ExecQuery; except; end; Sql.Sql.Clear;
         end;
         IBQue_ReplExists.Close;
         if Tran.InTransaction then
            Tran.commit;
         Tran.Active := true;
        // Repmlissage de la table REPL_SEPARATOR
         Sql.Sql.Clear;
         Sql.Sql.Add('DELETE FROM REPL_SEPARATOR ');
         Sql.ExecQuery;
         if Tran.InTransaction then
            Tran.commit;
         Tran.Active := true;
         for i := 0 to tsl.count - 1 do
         begin
            Pb.Position := Pb.Position + 1;
            S := Tsl[i];
            S1 := Copy(S, 1, pos(';', S) - 1); delete(S, 1, Pos(';', S));
            S2 := Copy(S, 1, pos(';', S) - 1); delete(S, 1, Pos(';', S));
            S3 := S;
            Sql.Sql.Clear;
            Sql.Sql.Add('INSERT INTO REPL_SEPARATOR (REPLNO,PUBDBNO,SUBDBNO,RELATIONNO,RELATIONNAME,SEP)');
            Sql.Sql.Add('VALUES (' + REPLNO + ',' + PUBDBNO + ',' + SUBDBNO + ',' + S1 + ',''' + S2 + ''','''')');
            Sql.ExecQuery;
            if Tran.InTransaction then
               Tran.commit;
            Tran.Active := true;
            Sql.Sql.Clear;
            S5 := Copy(S2 + S1, 1, 20);
            Caption := 'REPL$D' + S5;
            Sql.Sql.Add('CREATE TRIGGER REPL$' + S5 + '_D FOR ' + S2 + ' ACTIVE');
            Sql.Sql.Add('AFTER DELETE POSITION 32767');
            Sql.Sql.Add('AS');
            Sql.Sql.Add('BEGIN ');
            Sql.Sql.Add('  IF (USER <> ''REPL'') THEN');
            Sql.Sql.Add('  BEGIN');
            Sql.Sql.Add('    INSERT INTO REPL_LOG(REPLNO,PUBDBNO,SUBDBNO,RELATIONNO,REPTYPE,OLDKEY)');
            Sql.Sql.Add('    SELECT REPLNO,PUBDBNO,SUBDBNO,RELATIONNO,''D'',OLD.' + S3);
            Sql.Sql.Add('      FROM REPL_SEPARATOR');
            Sql.Sql.Add('     WHERE REPLNO=' + REPLNO);
            Sql.Sql.Add('       AND PUBDBNO=' + PUBDBNO);
            Sql.Sql.Add('       AND RELATIONNO=' + S1 + ';');
            Sql.Sql.Add('  END');
            Sql.Sql.Add('END');
            Sql.ExecQuery;
            if Tran.InTransaction then Tran.commit;
            Tran.Active := true;
            Sql.Sql.Clear;
            Caption := 'REPL$I' + S5;
            Sql.Sql.Add('CREATE TRIGGER REPL$' + S5 + '_I FOR ' + S2 + ' ACTIVE');
            Sql.Sql.Add('AFTER INSERT POSITION 32767');
            Sql.Sql.Add('AS');
            Sql.Sql.Add('BEGIN');
            Sql.Sql.Add('  IF (USER <> ''REPL'') THEN');
            Sql.Sql.Add('  BEGIN');
            Sql.Sql.Add('     INSERT INTO REPL_LOG(REPLNO,PUBDBNO,SUBDBNO,RELATIONNO,REPTYPE,NEWKEY)');
            Sql.Sql.Add('    SELECT REPLNO,PUBDBNO,SUBDBNO,RELATIONNO,''I'',NEW.' + S3);
            Sql.Sql.Add('      FROM REPL_SEPARATOR');
            Sql.Sql.Add('     WHERE REPLNO=' + REPLNO);
            Sql.Sql.Add('       AND PUBDBNO=' + PUBDBNO);
            Sql.Sql.Add('       AND RELATIONNO=' + S1 + ';');
            Sql.Sql.Add('  END');
            Sql.Sql.Add('END');
            Sql.ExecQuery;
            if Tran.InTransaction then Tran.commit;
            Tran.Active := true;
            Sql.Sql.Clear;
            Caption := 'REPL$U' + S5;
            Sql.Sql.Add('CREATE TRIGGER REPL$' + S5 + '_U FOR ' + S2 + ' ACTIVE');
            Sql.Sql.Add('AFTER UPDATE POSITION 32767');
            Sql.Sql.Add('AS');
            Sql.Sql.Add('BEGIN');
            Sql.Sql.Add('  IF (USER <> ''REPL'') THEN');
            Sql.Sql.Add('  BEGIN');
            Sql.Sql.Add('    INSERT INTO REPL_LOG(REPLNO,PUBDBNO,SUBDBNO,RELATIONNO,REPTYPE,OLDKEY,NEWKEY)');
            Sql.Sql.Add('    SELECT REPLNO,PUBDBNO,SUBDBNO,RELATIONNO,''U'',OLD.' + S3 + ',NEW.' + S3);
            Sql.Sql.Add('      FROM REPL_SEPARATOR');
            Sql.Sql.Add('     WHERE REPLNO=' + REPLNO);
            Sql.Sql.Add('       AND PUBDBNO=' + PUBDBNO);
            Sql.Sql.Add('       AND RELATIONNO=' + S1 + ';');
            Sql.Sql.Add('  END');
            Sql.Sql.Add('END');
            Sql.ExecQuery;
            if Tran.InTransaction then Tran.commit;
            Tran.Active := true;
            Sql.Sql.Clear;
         end;

        // création des utilisateurs
         IBQue_ListeTable.Open;
         IBQue_ListeTable.First;
         while not IBQue_ListeTable.Eof do
         begin
            Sql.sql.Text := 'GRANT ALL ON TABLE ' + trim(IBQue_ListeTableNOM.AsString) + ' TO REPL';
            Sql.ExecQuery;
            IBQue_ListeTable.next;
         end;
         IBQue_ListeTable.Close;
         if tran.Intransaction then
            tran.Commit;
         tran.active := true;

         IBQue_ListeProc.Open;
         IBQue_ListeProc.First;
         while not IBQue_ListeProc.Eof do
         begin
            Sql.sql.Text := 'GRANT EXECUTE ON PROCEDURE "' + trim(IBQue_ListeProcNOM.AsString) + '" TO REPL';
            Sql.ExecQuery;
            IBQue_ListeProc.next;
         end;
         IBQue_ListeProc.Close;
         if tran.Intransaction then
            tran.Commit;
         tran.active := true;
         Base.Close;

         try
            Base.databasename := edit2.text;
            Base.Open;
            tran.active := true;
            IBQue_ListeTable.Open;
            IBQue_ListeTable.First;
            while not IBQue_ListeTable.Eof do
            begin
               Sql.sql.Text := 'GRANT ALL ON TABLE ' + trim(IBQue_ListeTableNOM.AsString) + ' TO REPL';
               Sql.ExecQuery;
               IBQue_ListeTable.next;
            end;
            IBQue_ListeTable.Close;
            if tran.Intransaction then
               tran.Commit;
            tran.active := true;

            IBQue_ListeProc.Open;
            IBQue_ListeProc.First;
            while not IBQue_ListeProc.Eof do
            begin
               Sql.sql.Text := 'GRANT EXECUTE ON PROCEDURE "' + trim(IBQue_ListeProcNOM.AsString) + '" TO REPL';
               Sql.ExecQuery;
               IBQue_ListeProc.next;
            end;
            IBQue_ListeProc.Close;
            if tran.Intransaction then
               tran.Commit;
            tran.active := true;
            Base.Close;
         except
         end;
      finally
         tsl.free;
         screen.cursor := crdefault;
      end;
   finally
      enabled := true;
      if (paramcount > 0) and (uppercase(paramstr(1)) = 'AUTO') then
         close;
   end;
end;

procedure TForm1.SpeedButton3Click(Sender: TObject);
begin
   if od.execute then
      edit3.text := od.filename;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
   if od.execute then
      edit1.text := od.filename;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
   if od.execute then
      edit2.text := od.filename;
end;

procedure TForm1.FormShow(Sender: TObject);
var
   reg: TRegistry;
begin
    //
   reg := Tregistry.Create;
   try
      reg.Access := KEY_READ;
      Reg.RootKey := HKEY_LOCAL_MACHINE;
      reg.OpenKey('Software\Algol\Ginkoia', False);
      refrepli := reg.ReadString('REPL_REFERENCE');
      BaseMaitre := reg.ReadString('REPL_MAITRE');
      BaseEleve := reg.ReadString('REPL_ELEVE');
      if refrepli <> '' then
         Edit3.Text := refrepli;
      if BaseMaitre <> '' then
         Edit1.Text := BaseMaitre;
      if BaseEleve <> '' then
         Edit2.Text := BaseEleve;
   finally
      reg.free;
   end;
    //
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
   Premier := true;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
   if premier then
   begin
      premier := false;
      if (paramcount > 0) and (uppercase(paramstr(1)) = 'AUTO') and (refrepli <> '') then
      begin
         MapGinkoia.PingStop := true;
         try
            Update;
            Button1Click(nil);
         finally
            MapGinkoia.PingStop := false;
         end;
      end;
   end;
end;

end.

