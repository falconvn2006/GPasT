unit UPost;

interface
uses
   dxmdaset,
   Xml_Unit,
   forms,
   windows,
   IcXMLParser,
   StdCtrls,
   Classes, sysutils,
   IpUtils, IpSock, IpHttp;

type
   TPostData = class
      Leschamps: tstringlist;
      procedure add(nom, valeur: string);
      procedure clear;
      constructor create;
      destructor destroy; override;
      function PostWaitTimeOut(clt: TIpHttpClient; url: string; timeout: integer; Memo: TMemo = nil): boolean;
   end;

   Tconnexion = class
      Base: string;
      clt: TIpHttpClient;
      function traitechaine(s: string): string;
      constructor create;
      destructor destroy; override;
      function Select(Qry: string; Memo: TMemo = nil): TstringList;
      function ordre(qry: string; Memo: TMemo = nil): boolean;
      function insert(qry: string; Memo: TMemo = nil): integer;
      procedure FreeResult(ts: tstringlist);
      function recordCount(ts: tstringlist): integer;
      function UneValeur(ts: tstringlist; col: string; Num: integer = 0): string;
      function UneValeurEntiere(ts: tstringlist; col: string; Num: integer = 0): Integer;
      function DateTime(D: TdateTime): string;
      procedure remplie(qry: string; mem: TdxMemData);
   end;

implementation
{ TPostData }
const
   URL_YELLIS = 'yellis.ginkoia.net';
   
procedure TPostData.add(nom, valeur: string);
begin
   Leschamps.Values[nom] := valeur;
end;

procedure TPostData.clear;
begin
   leschamps.clear;
end;

constructor TPostData.create;
begin
   leschamps := TStringList.create;
end;

destructor TPostData.destroy;
begin
   leschamps.free;
   inherited;
end;

function TPostData.PostWaitTimeOut(clt: TIpHttpClient; url: string;
   timeout: integer; Memo: TMemo = nil): boolean;
var
   S: string;
   Tag: string;
   i: integer;
   tms: tmemorystream;
begin
   randomize;
   tag := '_MOI' + inttostr(random(999999) + 1) + '_';
   S := '';
   for i := 0 to Leschamps.Count - 1 do
   begin
      s := s + '--' + tag + #13#10 +
         'Content-Disposition: form-data; name="' + Leschamps.Names[i] + '"'#13#10#13#10 +
         Leschamps.Values[Leschamps.Names[i]] + #13#10;
   end;
   s := s + '--' + tag + '--'#13#10;
   tms := tmemorystream.create;
   tms.Write(pointer(s)^, length(s));
   tms.seek(soFromBeginning, 0);
   if memo <> nil then
      memo.lines.add(s);
   clt.RequestFields.clear;
   clt.RequestFields.add('Content-type: multipart/form-data;boundary="' + tag + '"');
   clt.RequestFields.add('Content-length: ' + inttostr(length(s)));
   result := clt.PostWaitTimeout(url, tms, TimeOut);
   tms.free;
end;

{ Tconnexion }

constructor Tconnexion.create;
begin
   Base := '';
   clt := TIpHttpClient.create(nil);
end;

function Tconnexion.DateTime(D: TdateTime): string;
begin
   result := FormatDateTime('yyyy-mm-dd hh:nn:ss', D);
end;

destructor Tconnexion.destroy;
begin
   clt.free;
   inherited;
end;

procedure Tconnexion.FreeResult(ts: tstringlist);
var
   i: integer;
begin
   for i := 0 to ts.count - 1 do
      tstringlist(ts.Objects[i]).free;
   ts.free;
end;

function Tconnexion.insert(qry: string; Memo: TMemo = nil): integer;
var
   tpd: TPostData;
   Body: TStringStream;
   s: string;
   Xml: TmonXML;
   Pass: TIcXMLElement;
   i: integer;
begin
   qry := traitechaine(qry);
   if memo <> nil then
      memo.Lines.add(qry);
   for i := 1 to 5 do
   begin
      tpd := TPostData.create;
      if base <> '' then
         tpd.add('db', base);
      tpd.add('action', 'QRY');
      tpd.add('qry1', qry);
      if tpd.PostWaitTimeOut(clt, 'http://' + URL_YELLIS + '/admin/base.php', 30000) then
      begin
         Body := TStringStream.Create('');
         Body.CopyFrom(clt.BodyStream['http://' + URL_YELLIS + '/admin/base.php'], 0);
         S := BODY.DataString;
         Body.free;
         if pos('<HTML>', Uppercase(S)) > 0 then
         begin
            if memo <> nil then
               memo.lines.add(s);
            S := '';
         end;
      end
      else
         s := '';
      tpd.Free;
      if trim(S) <> '' then BREAK;
      Application.processmessages;
      clt.FreeLink('http://' + URL_YELLIS + '/admin/base.php');
      Application.processmessages;
      sleep(100);
   end;
   if trim(s) = '' then
   begin
{$IFDEF debug}
      application.messagebox('Chaîne vide en réponse', 'Problème', MB_OK);
{$ELSE}
      halt;
{$ENDIF}
   end;
   if memo <> nil then
      memo.Lines.add(S);
   Xml := TmonXML.Create;
   xml.loadfromstring(S);
   pass := Xml.find('/XML/qry1');
   result := Strtoint(pass.GetFirstNode.GetValue);
   Xml.free;
   clt.FreeLink('http://' + URL_YELLIS + '/admin/base.php');
end;

function Tconnexion.ordre(qry: string; Memo: TMemo = nil): boolean;
var
   tpd: TPostData;
   Body: TStringStream;
   s: string;
   Xml: TmonXML;
   Pass: TIcXMLElement;
   i: integer;
begin
   qry := traitechaine(qry);
   if memo <> nil then
      memo.Lines.add(qry);
   for i := 1 to 5 do
   begin
      tpd := TPostData.create;
      if base <> '' then
         tpd.add('db', base);
      tpd.add('action', 'QRY');
      tpd.add('qry1', qry);
      if tpd.PostWaitTimeOut(clt, 'http://' + URL_YELLIS + '/admin/base.php', 30000) then
      begin
         Body := TStringStream.Create('');
         Body.CopyFrom(clt.BodyStream['http://' + URL_YELLIS + '/admin/base.php'], 0);
         S := BODY.DataString;
         Body.free;
         if pos('<HTML>', Uppercase(S)) > 0 then
            S := '';
      end
      else
         s := '';
      tpd.Free;
      if trim(S) <> '' then BREAK;
      Application.processmessages;
      clt.FreeLink('http://' + URL_YELLIS + '/admin/base.php');
      Application.processmessages;
      sleep(100);
   end;
   if trim(s) = '' then
   begin
{$IFDEF debug}
      application.messagebox('Chaîne vide en réponse', 'Problème', MB_OK);
{$ELSE}
      halt;
{$ENDIF}
   end;
   if memo <> nil then
      memo.Lines.add(S);
   Xml := TmonXML.Create;
   xml.loadfromstring(S);
   pass := Xml.find('/XML/RESULT');
   result := pass.GetFirstNode.GetValue = 'OK';
   Xml.free;
   clt.FreeLink('http://' + URL_YELLIS + '/admin/base.php');
end;

function Tconnexion.recordCount(ts: tstringlist): integer;
begin
   if ts.Count = 0 then
      result := 0
   else
   begin
      result := tstringlist(ts.objects[0]).count;
   end;
end;

procedure Tconnexion.remplie(qry: string; mem: TdxMemData);
var
   result: tstringlist;
   i: integer;
   j: integer;
begin
   mem.close;
   mem.open;
   result := Select(qry);
   for i := 0 to recordCount(result) - 1 do
   begin
      mem.Append;
      for j := 1 to mem.FieldCount - 1 do
         mem.fields[j].AsString := UneValeur(result, mem.fields[j].FieldName, i);
      mem.post;
   end;
   FreeResult (result) ;
   mem.first;
end;

function Tconnexion.Select(Qry: string; Memo: TMemo = nil): TstringList;
var
   tpd: TPostData;
   Body: TStringStream;
   s: string;
   Xml: TmonXML;
   Pass: TIcXMLElement;
   elem: TIcXMLElement;
   i: integer;
begin
   qry := traitechaine(qry);
   result := tstringlist.create;
   if memo <> nil then
      memo.lines.add(qry);
   for i := 1 to 5 do
   begin
      tpd := TPostData.create;
      if base <> '' then
         tpd.add('db', base);
      tpd.add('action', 'SEL');
      tpd.add('sel', qry);
      if tpd.PostWaitTimeOut(clt, 'http://' + URL_YELLIS + '/admin/base.php', 30000, Memo) then
      begin
         Body := TStringStream.Create('');
         Body.CopyFrom(clt.BodyStream['http://' + URL_YELLIS + '/admin/base.php'], 0);
         S := BODY.DataString;
         Body.free;
         if pos('<HTML>', Uppercase(S)) > 0 then
         begin
            if memo <> nil then
            begin
               memo.lines.add(s);
            end;
            S := '';
         end;
      end
      else
      begin
         S := '';
         if memo <> nil then
         begin
            memo.lines.add('Time Out');
         end;
      end;
      tpd.Free;
      if trim(S) <> '' then BREAK;
      Application.processmessages;
      clt.FreeLink('http://' + URL_YELLIS + '/admin/base.php');
      Application.processmessages;
      sleep(100);
   end;
   if trim(s) = '' then
   begin
{$IFDEF debug}
      application.messagebox('Chaîne vide en réponse', 'Problème', MB_OK);
{$ELSE}
      halt;
{$ENDIF}
   end;
   if memo <> nil then
      memo.Lines.add(S);
   Xml := TmonXML.Create;
   xml.loadfromstring(S);
   pass := Xml.find('/XML/RESULT');
   if pass.GetFirstNode.GetValue = 'OK' then
   begin
      pass := Xml.find('/XML/NBLIGNE');
      if pass.GetFirstNode.GetValue <> '0' then
      begin
         Pass := Xml.find('/XML/LIGNES/LIGNE');
         elem := pass.GetFirstChild;
         while elem <> nil do
         begin
            result.AddObject(elem.GetName, TstringList.create);
            elem := elem.NextSibling;
         end;
         while (Pass <> nil) and (pass.getname = 'LIGNE') do
         begin
            elem := pass.GetFirstChild;
            while elem <> nil do
            begin
               i := result.IndexOf(elem.GetName);
               if elem.GetFirstNode = nil then
                  TstringList(result.Objects[i]).add('')
               else
                  TstringList(result.Objects[i]).add(elem.GetFirstNode.GetValue);
               elem := elem.NextSibling;
            end;
            pass := Pass.NextSibling;
         end;
      end;
   end;
   Xml.free;
   clt.FreeLink('http://' + URL_YELLIS + '/admin/base.php');
end;

function Tconnexion.traitechaine(s: string): string;
var
   i: integer;
begin
   while pos('\', s) > 0 do
   begin
      s[pos('\', s)] := '¤';
   end;
   while pos('¤', s) > 0 do
   begin
      i := pos('¤', s);
      s[i] := '\';
      system.insert('\', S, i);
   end;
   result := S;
end;

function Tconnexion.UneValeur(ts: tstringlist; col: string; Num: integer = 0): string;
begin
   if ts.indexof(col) > -1 then
      result := tstringlist(ts.objects[ts.indexof(col)]).strings[num]
   else
      result := '';
end;

function Tconnexion.UneValeurEntiere(ts: tstringlist; col: string;
   Num: integer): Integer;
var
   S: string;
begin
   S := UneValeur(ts, col, Num);
   if s = '' then
      result := 0
   else
      result := Strtoint(UneValeur(ts, col, Num));
end;

end.

