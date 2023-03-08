unit UPost;

{
Adaptation de la version d'origine pour XE :
1. Remlacement de IpHttp par IdHttp
2. Suppression de XML_Unit et et utilisation de TClientDataSet et TXMLTransformProvider
3. Création des fichiers XTR avec XMLMapper
4. Allègement global pour ne conserver que la fonctin select, la seule ayant un intérêt ici
}

interface
uses
   forms,
   windows,
   StdCtrls,
   Classes, sysutils,
   IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdMultiPartFormData, IdHTTP, HttpApp, IdStrings;

type
   TPostData = class
      Leschamps: tstringlist;
      procedure add(nom, valeur: string);
      procedure clear;
      constructor create;
      destructor Destroy; override;
      function PostWaitTimeOut(clt: TIdHTTP; url: string; timeout: integer; reponse : TStream; Memo: TMemo = nil): boolean;
   end;

   Tconnexion = class
      Base: string;
      clt: TIdHTTP;
      HTTPReponse : TMemoryStream;
      function traitechaine(s: string): string;
      constructor create;
      destructor Destroy; override;
      function Select(Qry: string): string;
{      function ordre(qry: string; Memo: TMemo = nil): boolean;
      function insert(qry: string; Memo: TMemo = nil): integer;
      procedure FreeResult(ts: tstringlist);
      function recordCount(ts: tstringlist): integer;
      function UneValeur(ts: tstringlist; col: string; Num: integer = 0): string;
      function UneValeurEntiere(ts: tstringlist; col: string; Num: integer = 0): Integer;
      function DateTime(D: TdateTime): string;
      procedure remplie(qry: string; mem: TdxMemData);}
   end;

implementation
{ TPostData }

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

destructor TPostData.Destroy;
begin
   leschamps.free;
   inherited;
end;

function TPostData.PostWaitTimeOut(clt: TIdHTTP; url: string;
   timeout: integer; reponse : TStream; Memo: TMemo = nil): boolean;
var
   S: string;
   Tag: string;
   i: integer;
   tmpfds : TIdMultiPartFormDataStream;
begin
   randomize;
   tag := '_MOI' + inttostr(random(999999) + 1) + '_';
   S := '';
   tmpfds := TIdMultiPartFormDataStream.Create;
   try
      for i := 0 to Leschamps.Count - 1 do
          tmpfds.AddFormField(Leschamps.Names[i], Leschamps.Values[Leschamps.Names[i]]);
      clt.Request.ContentType := 'multipart/form-data; boundary="' + Tag + '"';
     Result := True;
     try
        clt.Post(url, tmpfds, reponse);
     except
        on E : Exception do
           Result := False;
     end;
   finally
      tmpfds.Free;
   end;
end;

{ Tconnexion }

constructor Tconnexion.create;
begin
   Base := '';
   clt := TIdHTTP.create(nil);
   HTTPReponse := TMemoryStream.Create;
end;

{function Tconnexion.DateTime(D: TdateTime): string;
begin
   result := FormatDateTime('yyyy-mm-dd hh:nn:ss', D);
end;}

destructor Tconnexion.Destroy;
begin
   clt.free;
   HTTPReponse.Free;
   inherited;
end;

(*procedure Tconnexion.FreeResult(ts: tstringlist);
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
      HTTPReponse.Clear;
      if tpd.PostWaitTimeOut(clt, 'http://ginkoia.yellis.net/admin/base.php', 30000, HTTPReponse) then
      begin
         Body := TStringStream.Create('');
         Body.CopyFrom(HTTPReponse, 0);
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
      if tpd.PostWaitTimeOut(clt, 'http://ginkoia.yellis.net/admin/base.php', 30000, HTTPReponse) then
      begin
         Body := TStringStream.Create('');
         Body.CopyFrom(HTTPReponse, 0);
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
*)

function Tconnexion.Select(Qry: string): string;
var
   tpd: TPostData;
   i: integer;
begin
   qry := traitechaine(qry);
   HTTPReponse.Clear;
   for i := 1 to 5 do
   begin
      tpd := TPostData.create;
      try
         if base <> '' then
            tpd.add('db', base);
         tpd.add('action', 'SEL');
         tpd.add('sel', qry);
         Result := '';
         if tpd.PostWaitTimeOut(clt, 'http://ginkoia.yellis.net/admin/base.php', 30000, HTTPReponse) then
         begin
         with TStringStream.Create('') do
              try
                 CopyFrom(HTTPReponse, 0);
                 //insertion de l'en-tête XML
                 Result := StringReplace( DataString, '<XML>', '<?xml version="1.0" encoding="ISO-8859-1"?><XML>',[]);

//               impossible d'inclure du DTD directement dans le XML
//               <!ENTITY egrave CDATA "&#232;">,<!ENTITY eacute CDATA "&#233;">


//TODO : EConvertError sur le premier &eacute
//                 Result := HtmlDecode(Result);

//En fait la version de httpapp et celle de Indy font la même chose, elles traitent seulement 4 caractères
(*function StrHtmlDecode (const AStr: String): String;
begin
  Result := StringReplace(AStr,   '&quot;', '"',[rfReplaceAll]); {do not localize}
  Result := StringReplace(Result, '&gt;',   '>',[rfReplaceAll]); {do not localize}
  Result := StringReplace(Result, '&lt;',   '<',[rfReplaceAll]); {do not localize}
  Result := StringReplace(Result, '&amp;',  '&',[rfReplaceAll]); {do not localize}
end;*)

//pour continuer les tests, je remets le decode manuel
                 Result := StringReplace(Result, '&eacute', 'é', [rfReplaceAll]);
                 Result := StringReplace(Result, '&egrave', 'è', [rfReplaceAll]);
                 Result := StringReplace(Result, '&ccedil', 'ç', [rfReplaceAll]);
                 Result := StringReplace(Result, '&Eacute', 'É', [rfReplaceAll]);

                 //Format date non importable (en Delphi 0 = 1899-12-30 12:00:00)
                 Result := StringReplace(Result, '1899-12-30 00:00:00', '0', [rfReplaceAll]);
                 Result := StringReplace(Result, '0000-00-00 00:00:00', '0', [rfReplaceAll]);

              finally
                 Free;
              end;
         end;
      finally
         tpd.Free;
      end;
      if trim(Result) <> '' then BREAK;
      Application.processmessages;
      sleep(100);
   end;
(*   if trim(s) = '' then
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
   Xml.free; *)
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

(*
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
*)

end.

