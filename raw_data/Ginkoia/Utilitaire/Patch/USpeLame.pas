unit USpeLame;

interface

uses
   Xml_Unit,
   IcXMLParser,
   Upost,
   comobj,
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   StdCtrls, Db, IBCustomDataSet, IBQuery, IBDatabase, IpUtils, IpSock,
   IpHttp, IpHttpClientGinkoia, IBSQL, ComCtrls, CheckLst, wwriched,
   wwDBRichEditRv;

type
   TForm1 = class(TForm)
      Label1: TLabel;
      Go: TButton;
      data: TIBDatabase;
      tran: TIBTransaction;
    Qry: TIBQuery;
      SQL: TIBSQL;
      Label2: TLabel;
      PB: TProgressBar;
      Label3: TLabel;
      Memo1: TMemo;
      Cb_serveur: TCheckListBox;
      Button1: TButton;
      Od: TOpenDialog;
      OdDatabases: TOpenDialog;
      Button2: TButton;
      Chp_Rtf: TwwDBRichEditRv;
      ds_adresse: TDataSource;
      procedure GoClick(Sender: TObject);
      procedure FormCreate(Sender: TObject);
      procedure FormPaint(Sender: TObject);
      procedure Button2Click(Sender: TObject);
   private
      procedure parcour(machine: string);
      procedure execute(Machine, databases: string);
    { Déclarations privées }
   public
    { Déclarations publiques }
      first: boolean;
      Version6plus: boolean;
      faitlelog: boolean;
      log: tstringlist;
   end;

var
   Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.execute(Machine, databases: string);
var
   Xml: TmonXML;
   passXML: TIcXMLElement;
   passXML2: TIcXMLElement;
   LaBase: string;
   NomClient: string;
   LaMachine: string;
   LaCentrale: string;

   s: string;
begin
   s := databases;
   while pos('\', S) > 0 do
      s[pos('\', S)] := '/';
   while s[1] <> 'V' do
      delete(S, 1, pos('/', s));
   s := Copy(S, 1, pos('/', s) - 1);
   caption := S;

   Xml := TmonXML.Create;

   Label3.caption := databases;
   Label3.Update;
   xml.LoadFromFile(databases);
   passXML := Xml.find('/DataSources');
   pb.position := 0;
   pb.max := PassXML.GetNodeList.Length;
   passXML := Xml.find('/DataSources/DataSource');
   while (PassXML <> nil) do
   begin
      pb.position := pb.position + 1;

      NomClient := Xml.ValueTag(passXml, 'Name');
      passXML2 := xml.FindTag(passxml, 'Params');
      passXML2 := xml.FindTag(passxml2, 'Param');

      while (passXML2 <> nil) and (Xml.ValueTag(passXML2, 'Name') <> 'SERVER NAME') do
         passXML2 := passXML2.NextSibling;

      if Xml.ValueTag(passXML2, 'Name') = 'SERVER NAME' then
      begin
         LaBase := Xml.ValueTag(passXML2, 'Value');
         if (labase <> '') then
         begin
            if pos(':', labase) < 3 then
            begin
               labase := machine + ':' + labase;
            end;
            LaMachine := copy(labase, 1, pos(':', labase) - 1);
            LaCentrale := labase;
            Delete(LaCentrale, 1, pos('\', LaCentrale));
            Delete(LaCentrale, 1, pos('\', LaCentrale));
            LaCentrale := Copy(LaCentrale, 1, pos('\', LaCentrale) - 1);

            Label2.caption := '';
            Label2.Update;
            Label1.caption := ('Traitement : ' + labase);
            memo1.lines.add(labase);
            Label1.Update;
            data.DatabaseName := labase;
            try
               data.open;
               tran.active := true;
               try
                  sql.sql.text := 'DROP PROCEDURE PR_RECH_BR';
                  sql.ExecQuery;
               except
               end;
               sql.sql.Clear;
               sql.sql.add('CREATE PROCEDURE PR_RECH_BR');
               sql.sql.add('RETURNS (');
               sql.sql.add('    BRE_ID INTEGER,');
               sql.sql.add('    BRE_DATE DATE,');
               sql.sql.add('    BRE_NUMERO VARCHAR (32),');
               sql.sql.add('    DATEPROB DATE)');
               sql.sql.add('AS');
               sql.sql.add('BEGIN');
               sql.sql.add('  /* Procedure body */');
               sql.sql.add('  for select bre_id, bre_date, bre_numero');
               sql.sql.add('    from recbr join k on (k_id=bre_id)');
               sql.sql.add('   where k_inserted < ''01/01/1950''');
               sql.sql.add('   into :bre_id, :bre_date, :bre_numero');
               sql.sql.add('   do');
               sql.sql.add('  begin');
               sql.sql.add('    select max(k_inserted)');
               sql.sql.add('    from k');
               sql.sql.add('    where k_id between (:bre_id-100) and (:bre_id)');
               sql.sql.add('      into :DateProb ;');
               sql.sql.add('    if (:DateProb<>:bre_date) then');
               sql.sql.add('        suspend ;');
               sql.sql.add('  end');
               sql.sql.add('END');
               sql.ExecQuery;
               if tran.InTransaction then
               begin
                  tran.commit;
                  tran.active := true;
               end;
               qry.sql.clear;
               qry.sql.Add('select BRE_ID, BRE_DATE, BRE_NUMERO, DATEPROB');
               qry.sql.Add('from PR_RECH_BR ');
               qry.Open;
               if not qry.eof then
               begin
                  log.Add('=============================================================');
                  log.Add(LaMachine + ' ' + LaCentrale + ' ' + data.DatabaseName);
                  log.Add('');
                  while not qry.eof do
                  begin
                     log.Add('Le BR ' + qry.fields[0].AsString + ' N°:' + qry.fields[2].AsString + ' En date du ' + qry.fields[1].AsString + ' devrait sans doute être en date du ' + qry.fields[3].AsString);
                     qry.next;
                  end;
               end;
               qry.close;
               // Traitement
               sql.sql.text := 'DROP PROCEDURE PR_RECH_BR';
               sql.ExecQuery;
               if tran.InTransaction then
               begin
                  tran.commit;
                  tran.active := true;
               end;
            except
               memo1.lines.add('prob sur labase');
            end;
            data.Close;
         end;
      end;
      PassXML := PassXML.NextSibling;
   end;
   xml.free;
end;

procedure TForm1.parcour(machine: string);
var
   f: tsearchrec;
   rep: string;
begin
   memo1.lines.add(machine + ' en cours');
   rep := '\\' + machine + '\d$\EAI\';
   if findfirst(rep + '*.*', faanyfile, f) = 0 then
   begin
      repeat
         if (Copy(f.name, 1, 1) = 'V') and ((f.attr and faDirectory) = faDirectory) then
         begin
            if FileExists(rep + f.name + '\DelosQPMAgent.Databases.xml') then
            begin
               execute(machine, rep + f.name + '\DelosQPMAgent.Databases.xml');
            end;
         end;
      until findnext(f) <> 0;
   end;
   findclose(f);
end;

procedure TForm1.GoClick(Sender: TObject);
var
   i: integer;
begin
   faitlelog := true;
   log := Tstringlist.create;
   for i := 0 to Cb_serveur.items.count - 1 do
      if Cb_serveur.Checked[i] then
         parcour(Cb_serveur.items[i]);
   //   parcour('PASCAL_FIX');
   if sender <> nil then
      application.MessageBox('c''est fini', 'fini', mb_ok);
   log.savetofile(IncludeTrailingBackslash(ExtractFilePath(application.exename)) + 'Probleme.txt');
   log.free;
   faitlelog := false;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
   i: integer;
begin
   faitlelog := false;
   label1.caption := ''; label2.caption := '';
   Label3.caption := '';
   first := true;
   Version6plus := false;
   for i := 0 to Cb_serveur.items.count - 1 do
      Cb_serveur.Checked[i] := true;
end;

procedure TForm1.FormPaint(Sender: TObject);
begin
   if first then
   begin
      first := false;
      if paramcount > 0 then
      begin
         GoClick(nil);
         close;
      end;
   end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
   s: string;
   Machine: string;
begin
   if OdDatabases.execute then
   begin
      S := OdDatabases.FileName;
      if pos('//', s) = 1 then
      begin
         delete(S, 1, 2);
         Machine := Copy(S, 1, pos('/', s) - 1);
         execute(Machine, OdDatabases.FileName);
      end
      else
         execute('pascal_fix', OdDatabases.FileName);
   end;
end;

end.

