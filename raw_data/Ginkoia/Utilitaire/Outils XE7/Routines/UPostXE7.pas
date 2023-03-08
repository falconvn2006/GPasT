unit UPostXE7;

interface

uses
  Vcl.Forms,
  Winapi.windows,
  Vcl.StdCtrls,
  System.Classes,
  System.SysUtils,
  IdHTTP,
  Datasnap.DBClient;

type
  TPostData = class
  private
    FLeschamps: tstringlist;
  public
    constructor Create(); reintroduce;
    destructor Destroy(); override;

    procedure Add(nom, valeur: string);
    procedure Clear;
    function PostWaitTimeOut(clt: TIdHTTP; url: string; timeout: integer; Reponse : TStream; Memo: TMemo = nil): boolean;
  end;

  TConnexion = class
  private
    Base : string;
    clt : TIdHTTP;
  public
    constructor Create(); reintroduce;
    destructor Destroy(); override;

    function traitechaine(s: string): string;
    function Select(Qry: string; Memo: TMemo = nil): TstringList;
    function ordre(qry: string; Memo: TMemo = nil): boolean;
    function insert(qry: string; Memo: TMemo = nil): integer;
    procedure FreeResult(ts: tstringlist);
    function recordCount(ts: tstringlist): integer;
    function UneValeur(ts: tstringlist; col: string; Num: integer = 0): string;
    function UneValeurEntiere(ts: tstringlist; col: string; Num: integer = 0): Integer;
    function DateTime(D: TdateTime): string;
    procedure remplie(qry: string; mem: TClientDataset);

    function HTMLEncode(astr: String): String;
    function HTMLDecode(astr: String; SkipXml : boolean = true): String;
  end;

implementation

uses
  System.Variants,
  Xml.XMLIntf,
  Xml.XMLDoc,
  Data.DB,
  UXmlUtils;

const
  URL_SERVEUR = 'ginkoia.yellis.net';

{ TPostData }

constructor TPostData.Create();
begin
  inherited Create();
  FLeschamps := TStringList.Create();
end;

destructor TPostData.Destroy();
begin
  FreeAndNil(FLeschamps);
  inherited Destroy();
end;

procedure TPostData.Add(nom, valeur: string);
begin
  FLeschamps.Values[nom] := valeur;
end;

procedure TPostData.Clear();
begin
  FLeschamps.Clear();
end;

function TPostData.PostWaitTimeOut(clt : TIdHTTP; url : string; timeout: integer; Reponse : TStream; Memo: TMemo = nil): boolean;
var
  RequeteString, Tag : AnsiString;
  i : integer;
  Requete : TMemoryStream;
begin
  result := false;

  randomize();
  tag := '_MOI' + AnsiString(IntToStr(Random(999999) + 1)) + '_';
  RequeteString := '';
  for i := 0 to FLeschamps.Count - 1 do
    RequeteString := RequeteString + '--' + tag + #13#10
                   + 'Content-Disposition: form-data; name="' + AnsiString(FLeschamps.Names[i]) + '"'#13#10#13#10
                   + AnsiString(FLeschamps.Values[FLeschamps.Names[i]]) + #13#10;
  RequeteString := RequeteString + '--' + tag + '--'#13#10;

  try
    Requete := tmemorystream.create;
    Requete.Write(pointer(RequeteString)^, length(RequeteString));
    Requete.seek(soFromBeginning, 0);

    if memo <> nil then
      memo.lines.add(String(RequeteString));

    clt.Request.Clear();
    clt.Request.Method := 'POST';
    clt.Request.ContentType := 'multipart/form-data;boundary="' + String(tag) + '"';
    clt.Request.ContentLength := length(RequeteString);

    clt.ReadTimeout := timeout;

    try
      clt.Post(url, Requete, Reponse);
      result := true;
    except
      on e : Exception do
        Reponse.Write(pointer(e.Message)^, length(e.Message))
    end;
  finally
    FreeAndNil(Requete);
  end;
end;

{ TConnexion }

constructor TConnexion.Create();
begin
  inherited Create();
  Base := '';
  clt := TIdHTTP.create(nil);
end;

destructor TConnexion.Destroy();
begin
  FreeAndNil(clt);
  inherited;
end;

// utils ??

function TConnexion.DateTime(D: TdateTime): string;
begin
  result := FormatDateTime('yyyy-mm-dd hh:nn:ss', D);
end;

procedure TConnexion.FreeResult(ts: tstringlist);
var
  i: integer;
begin
  for i := 0 to ts.count - 1 do
    tstringlist(ts.Objects[i]).free;
  ts.free;
end;

function TConnexion.recordCount(ts: tstringlist): integer;
begin
  if ts.Count = 0 then
    result := 0
  else
  begin
    result := tstringlist(ts.objects[0]).count;
  end;
end;

procedure TConnexion.remplie(qry: string; mem: TClientDataset);
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
  FreeResult(result);
  mem.first;
end;

function TConnexion.traitechaine(s: string): string;
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

// requetage

function TConnexion.insert(qry: string; Memo: TMemo = nil): integer;
var
  tpd: TPostData;
  Body: TStringStream;
  s: string;
  i: integer;
  XmlDoc : IXMLDocument;
  NodeResult : IXMLNode;
begin
  Result := -1;
  tpd := nil;
  Body := nil;
  qry := traitechaine(qry);
  if memo <> nil then
    memo.Lines.add(qry);
  for i := 1 to 5 do
  begin
    try
      tpd := TPostData.create;
      Body := TStringStream.Create('');

      if base <> '' then
        tpd.add('db', base);
      tpd.add('action', 'QRY');
      tpd.add('qry1', qry);
      if tpd.PostWaitTimeOut(clt, 'http://' + URL_SERVEUR + '/admin/base.php', 30000, Body) then
      begin
        S := BODY.DataString;
        if pos('<HTML>', Uppercase(S)) > 0 then
        begin
          if memo <> nil then
            memo.lines.add(s);
          S := '';
        end;
      end
      else
        s := '';
    finally
      FreeAndNil(tpd);
      FreeAndNil(Body);
    end;

    if trim(S) <> '' then
      BREAK;
    Application.processmessages;
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
  XmlDoc := TXMLDocument.Create(nil);
  XmlDoc.XML.Text := S;
  XmlDoc.Active := true;
  NodeResult := GetRootNodeFromName('qry1', XmlDoc);
  if assigned(NodeResult) then
    result := NodeResult.NodeValue;
end;

function TConnexion.ordre(qry: string; Memo: TMemo = nil): boolean;
var
  tpd: TPostData;
  Body: TStringStream;
  s: string;
  i: integer;
  XmlDoc : IXMLDocument;
  NodeResult : IXMLNode;
begin
  tpd := nil;
  Body := nil;
  qry := traitechaine(qry);
  if memo <> nil then
    memo.Lines.add(qry);
  for i := 1 to 5 do
  begin
    try
      tpd := TPostData.create;
      Body := TStringStream.Create('');

      if base <> '' then
        tpd.add('db', base);
      tpd.add('action', 'QRY');
      tpd.add('qry1', qry);
      if tpd.PostWaitTimeOut(clt, 'http://' + URL_SERVEUR + '/admin/base.php', 30000, Body) then
      begin
        S := BODY.DataString;
        if pos('<HTML>', Uppercase(S)) > 0 then
          S := '';
      end
      else
        s := '';
    finally
      FreeAndNil(tpd);
      FreeAndNil(Body);
    end;

    if trim(S) <> '' then
      BREAK;
    Application.processmessages;
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
  XmlDoc := TXMLDocument.Create(nil);
  XmlDoc.XML.Text := S;
  XmlDoc.Active := true;
  NodeResult := GetRootNodeFromName('RESULT', XmlDoc);
  result := assigned(NodeResult) and (NodeResult.NodeValue = 'OK');
end;

function TConnexion.Select(Qry: string; Memo: TMemo = nil): TstringList;
var
  tpd: TPostData;
  Body: TStringStream;
  s : string;
  i, j, idx : integer;
  XmlDoc : IXMLDocument;
  NodeResult, NodeNbLigne, NodeLignes : IXMLNode;
begin
  qry := traitechaine(qry);
  tpd := nil;
  Body := nil;
  result := TStringList.Create;
  if Memo <> nil then
    Memo.Lines.Add(qry);
  for i := 1 to 5 do
  begin
    try
      tpd := TPostData.create;
      Body := TStringStream.Create('');

      if base <> '' then
        tpd.add('db', base);
      tpd.add('action', 'SEL');
      tpd.add('sel', qry);
      if tpd.PostWaitTimeOut(clt, 'http://' + URL_SERVEUR + '/admin/base.php', 30000, Body, Memo) then
      begin
        S := BODY.DataString;
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
    finally
      FreeAndNil(tpd);
      FreeAndNil(Body);
    end;

    if trim(S) <> '' then
      BREAK;
    Application.processmessages;
  end;
  if trim(s) = '' then
  begin
{$IFDEF debug}
    application.messagebox('Chaîne vide en réponse', 'Problème', MB_OK);
{$ENDIF}
  end;
  if memo <> nil then
    memo.Lines.add(S);

  S := HtmlDecode(S);

  XmlDoc := TXMLDocument.Create(nil);
  XmlDoc.XML.Text := S;
  XmlDoc.Active := true;
  NodeResult := GetRootNodeFromName('RESULT', XmlDoc);
  if assigned(NodeResult) and (NodeResult.NodeValue = 'OK') then
  begin
    NodeNbLigne  := GetRootNodeFromName('NBLIGNE', XmlDoc);
    if Assigned(NodeNbLigne) and (NodeNbLigne.NodeValue > 0) then
    begin
      NodeLignes := GetRootNodeFromName('LIGNES', XmlDoc);
      if Assigned(NodeLignes) then
      begin
        // recup des entete
        for i := 0 to NodeLignes.ChildNodes[0].ChildNodes.Count -1 do
          result.AddObject(NodeLignes.ChildNodes[0].ChildNodes[i].NodeName, TstringList.create());
        // recup des lignes
        for i := 0 to NodeLignes.ChildNodes.Count -1 do
        begin
          for j := 0 to NodeLignes.ChildNodes[i].ChildNodes.Count -1 do
          begin
            idx := Result.IndexOf(NodeLignes.ChildNodes[i].ChildNodes[j].NodeName);
            if VarIsNull(NodeLignes.ChildNodes[i].ChildNodes[j].NodeValue) then
              TstringList(result.Objects[idx]).add('NULL')
            else
              TstringList(result.Objects[idx]).add(NodeLignes.ChildNodes[i].ChildNodes[j].NodeValue);
          end;
        end;
      end;
    end;
  end;
end;

// accesseur au valeur

function TConnexion.UneValeur(ts: tstringlist; col: string; Num: integer = 0): string;
begin
  if ts.indexof(col) > -1 then
    result := tstringlist(ts.objects[ts.indexof(col)]).strings[num]
  else
    result := '';
end;

function TConnexion.UneValeurEntiere(ts: tstringlist; col: string; Num: integer): Integer;
var
  S: string;
begin
  S := UneValeur(ts, col, Num);
  if s = '' then
    result := 0
  else
    result := Strtoint(UneValeur(ts, col, Num));
end;

// encodage et decodage

function TConnexion.HTMLEncode(astr: String): String;
begin
  Result := astr;
  Result := StringReplace(Result, '"', '&quot;',    [rfReplaceAll]);
  Result := StringReplace(Result, '&', '&amp;',     [rfReplaceAll]);
  Result := StringReplace(Result, '<', '&lt;',      [rfReplaceAll]);
  Result := StringReplace(Result, '>', '&gt;',      [rfReplaceAll]);
  Result := StringReplace(Result, ' ', '&nbsp;',    [rfReplaceAll]);
  Result := StringReplace(Result, '¡', '&iexcl;',   [rfReplaceAll]);
  Result := StringReplace(Result, '¢', '&cent;',    [rfReplaceAll]);
  Result := StringReplace(Result, '£', '&pound;',   [rfReplaceAll]);
  Result := StringReplace(Result, '¤', '&curren;',  [rfReplaceAll]);
  Result := StringReplace(Result, '¥', '&yen;',     [rfReplaceAll]);
  Result := StringReplace(Result, '¦', '&brvbar;',  [rfReplaceAll]);
  Result := StringReplace(Result, '§', '&sect;',    [rfReplaceAll]);
  Result := StringReplace(Result, '¨', '&uml;',     [rfReplaceAll]);
  Result := StringReplace(Result, '©', '&copy;',    [rfReplaceAll]);
  Result := StringReplace(Result, 'ª', '&ordf;',    [rfReplaceAll]);
  Result := StringReplace(Result, '«', '&laquo;',   [rfReplaceAll]);
  Result := StringReplace(Result, '¬', '&not;',     [rfReplaceAll]);
  Result := StringReplace(Result, '­', '&shy;',     [rfReplaceAll]);
  Result := StringReplace(Result, '®', '&reg;',     [rfReplaceAll]);
  Result := StringReplace(Result, '¯', '&macr;',    [rfReplaceAll]);
  Result := StringReplace(Result, '°', '&deg;',     [rfReplaceAll]);
  Result := StringReplace(Result, '±', '&plusmn;',  [rfReplaceAll]);
  Result := StringReplace(Result, '²', '&sup2;',    [rfReplaceAll]);
  Result := StringReplace(Result, '³', '&sup3;',    [rfReplaceAll]);
  Result := StringReplace(Result, '´', '&acute;',   [rfReplaceAll]);
  Result := StringReplace(Result, 'µ', '&micro;',   [rfReplaceAll]);
  Result := StringReplace(Result, '¶', '&para;',    [rfReplaceAll]);
  Result := StringReplace(Result, '·', '&middot;',  [rfReplaceAll]);
  Result := StringReplace(Result, '¸', '&cedil;',   [rfReplaceAll]);
  Result := StringReplace(Result, '¹', '&sup1;',    [rfReplaceAll]);
  Result := StringReplace(Result, 'º', '&ordm;',    [rfReplaceAll]);
  Result := StringReplace(Result, '»', '&raquo;',   [rfReplaceAll]);
  Result := StringReplace(Result, '¼', '&frac14;',  [rfReplaceAll]);
  Result := StringReplace(Result, '½', '&frac12;',  [rfReplaceAll]);
  Result := StringReplace(Result, '¾', '&frac34;',  [rfReplaceAll]);
  Result := StringReplace(Result, '¿', '&iquest;',  [rfReplaceAll]);
  Result := StringReplace(Result, 'À', '&Agrave;',  [rfReplaceAll]);
  Result := StringReplace(Result, 'Á', '&Aacute;',  [rfReplaceAll]);
  Result := StringReplace(Result, 'Â', '&Acirc;',   [rfReplaceAll]);
  Result := StringReplace(Result, 'Ã', '&Atilde;',  [rfReplaceAll]);
  Result := StringReplace(Result, 'Ä', '&Auml;',    [rfReplaceAll]);
  Result := StringReplace(Result, 'Å', '&Aring;',   [rfReplaceAll]);
  Result := StringReplace(Result, 'Æ', '&AElig;',   [rfReplaceAll]);
  Result := StringReplace(Result, 'Ç', '&Ccedil;',  [rfReplaceAll]);
  Result := StringReplace(Result, 'È', '&Egrave;',  [rfReplaceAll]);
  Result := StringReplace(Result, 'É', '&Eacute;',  [rfReplaceAll]);
  Result := StringReplace(Result, 'Ê', '&Ecirc;',   [rfReplaceAll]);
  Result := StringReplace(Result, 'Ë', '&Euml;',    [rfReplaceAll]);
  Result := StringReplace(Result, 'Ì', '&Igrave;',  [rfReplaceAll]);
  Result := StringReplace(Result, 'Í', '&Iacute;',  [rfReplaceAll]);
  Result := StringReplace(Result, 'Î', '&Icirc;',   [rfReplaceAll]);
  Result := StringReplace(Result, 'Ï', '&Iuml;',    [rfReplaceAll]);
  Result := StringReplace(Result, 'Ð', '&ETH;',     [rfReplaceAll]);
  Result := StringReplace(Result, 'Ñ', '&Ntilde;',  [rfReplaceAll]);
  Result := StringReplace(Result, 'Ò', '&Ograve;',  [rfReplaceAll]);
  Result := StringReplace(Result, 'Ó', '&Oacute;',  [rfReplaceAll]);
  Result := StringReplace(Result, 'Ô', '&Ocirc;',   [rfReplaceAll]);
  Result := StringReplace(Result, 'Õ', '&Otilde;',  [rfReplaceAll]);
  Result := StringReplace(Result, 'Ö', '&Ouml;',    [rfReplaceAll]);
  Result := StringReplace(Result, '×', '&times;',   [rfReplaceAll]);
  Result := StringReplace(Result, 'Ø', '&Oslash;',  [rfReplaceAll]);
  Result := StringReplace(Result, 'Ù', '&Ugrave;',  [rfReplaceAll]);
  Result := StringReplace(Result, 'Ú', '&Uacute;',  [rfReplaceAll]);
  Result := StringReplace(Result, 'Û', '&Ucirc;',   [rfReplaceAll]);
  Result := StringReplace(Result, 'Ü', '&Uuml;',    [rfReplaceAll]);
  Result := StringReplace(Result, 'Ý', '&Yacute;',  [rfReplaceAll]);
  Result := StringReplace(Result, 'Þ', '&THORN;',   [rfReplaceAll]);
  Result := StringReplace(Result, 'ß', '&szlig;',   [rfReplaceAll]);
  Result := StringReplace(Result, 'à', '&agrave;',  [rfReplaceAll]);
  Result := StringReplace(Result, 'á', '&aacute;',  [rfReplaceAll]);
  Result := StringReplace(Result, 'â', '&acirc;',   [rfReplaceAll]);
  Result := StringReplace(Result, 'ã', '&atilde;',  [rfReplaceAll]);
  Result := StringReplace(Result, 'ä', '&auml;',    [rfReplaceAll]);
  Result := StringReplace(Result, 'å', '&aring;',   [rfReplaceAll]);
  Result := StringReplace(Result, 'æ', '&aelig;',   [rfReplaceAll]);
  Result := StringReplace(Result, 'ç', '&ccedil;',  [rfReplaceAll]);
  Result := StringReplace(Result, 'è', '&egrave;',  [rfReplaceAll]);
  Result := StringReplace(Result, 'é', '&eacute;',  [rfReplaceAll]);
  Result := StringReplace(Result, 'ê', '&ecirc;',   [rfReplaceAll]);
  Result := StringReplace(Result, 'ë', '&euml;',    [rfReplaceAll]);
  Result := StringReplace(Result, 'ì', '&igrave;',  [rfReplaceAll]);
  Result := StringReplace(Result, 'í', '&iacute;',  [rfReplaceAll]);
  Result := StringReplace(Result, 'î', '&icirc;',   [rfReplaceAll]);
  Result := StringReplace(Result, 'ï', '&iuml;',    [rfReplaceAll]);
  Result := StringReplace(Result, 'ð', '&eth;',     [rfReplaceAll]);
  Result := StringReplace(Result, 'ñ', '&ntilde;',  [rfReplaceAll]);
  Result := StringReplace(Result, 'ò', '&ograve;',  [rfReplaceAll]);
  Result := StringReplace(Result, 'ó', '&oacute;',  [rfReplaceAll]);
  Result := StringReplace(Result, 'ô', '&ocirc;',   [rfReplaceAll]);
  Result := StringReplace(Result, 'õ', '&otilde;',  [rfReplaceAll]);
  Result := StringReplace(Result, 'ö', '&ouml;',    [rfReplaceAll]);
  Result := StringReplace(Result, '÷', '&divide;',  [rfReplaceAll]);
  Result := StringReplace(Result, 'ø', '&oslash;',  [rfReplaceAll]);
  Result := StringReplace(Result, 'ù', '&ugrave;',  [rfReplaceAll]);
  Result := StringReplace(Result, 'ú', '&uacute;',  [rfReplaceAll]);
  Result := StringReplace(Result, 'û', '&ucirc;',   [rfReplaceAll]);
  Result := StringReplace(Result, 'ü', '&uuml;',    [rfReplaceAll]);
  Result := StringReplace(Result, 'ý', '&yacute;',  [rfReplaceAll]);
  Result := StringReplace(Result, 'þ', '&thorn;',   [rfReplaceAll]);
  Result := StringReplace(Result, 'ÿ', '&yuml;',    [rfReplaceAll]);
end;

function TConnexion.HTMLDecode(astr: String; SkipXml : boolean): String;
begin
  Result := astr;
  if not SkipXml then
  begin
    Result := StringReplace(Result, '&quot;',    '"', [rfReplaceAll]);
    Result := StringReplace(Result, '&amp;',     '&', [rfReplaceAll]);
  end;
  Result := StringReplace(Result, '&lt;',      '<', [rfReplaceAll]);
  Result := StringReplace(Result, '&gt;',      '>', [rfReplaceAll]);
  Result := StringReplace(Result, '&nbsp;',    ' ', [rfReplaceAll]);
  Result := StringReplace(Result, '&iexcl;',   '¡', [rfReplaceAll]);
  Result := StringReplace(Result, '&cent;',    '¢', [rfReplaceAll]);
  Result := StringReplace(Result, '&pound;',   '£', [rfReplaceAll]);
  Result := StringReplace(Result, '&curren;',  '¤', [rfReplaceAll]);
  Result := StringReplace(Result, '&yen;',     '¥', [rfReplaceAll]);
  Result := StringReplace(Result, '&brvbar;',  '¦', [rfReplaceAll]);
  Result := StringReplace(Result, '&sect;',    '§', [rfReplaceAll]);
  Result := StringReplace(Result, '&uml;',     '¨', [rfReplaceAll]);
  Result := StringReplace(Result, '&copy;',    '©', [rfReplaceAll]);
  Result := StringReplace(Result, '&ordf;',    'ª', [rfReplaceAll]);
  Result := StringReplace(Result, '&laquo;',   '«', [rfReplaceAll]);
  Result := StringReplace(Result, '&not;',     '¬', [rfReplaceAll]);
  Result := StringReplace(Result, '&shy;',     '­', [rfReplaceAll]);
  Result := StringReplace(Result, '&reg;',     '®', [rfReplaceAll]);
  Result := StringReplace(Result, '&macr;',    '¯', [rfReplaceAll]);
  Result := StringReplace(Result, '&deg;',     '°', [rfReplaceAll]);
  Result := StringReplace(Result, '&plusmn;',  '±', [rfReplaceAll]);
  Result := StringReplace(Result, '&sup2;',    '²', [rfReplaceAll]);
  Result := StringReplace(Result, '&sup3;',    '³', [rfReplaceAll]);
  Result := StringReplace(Result, '&acute;',   '´', [rfReplaceAll]);
  Result := StringReplace(Result, '&micro;',   'µ', [rfReplaceAll]);
  Result := StringReplace(Result, '&para;',    '¶', [rfReplaceAll]);
  Result := StringReplace(Result, '&middot;',  '·', [rfReplaceAll]);
  Result := StringReplace(Result, '&cedil;',   '¸', [rfReplaceAll]);
  Result := StringReplace(Result, '&sup1;',    '¹', [rfReplaceAll]);
  Result := StringReplace(Result, '&ordm;',    'º', [rfReplaceAll]);
  Result := StringReplace(Result, '&raquo;',   '»', [rfReplaceAll]);
  Result := StringReplace(Result, '&frac14;',  '¼', [rfReplaceAll]);
  Result := StringReplace(Result, '&frac12;',  '½', [rfReplaceAll]);
  Result := StringReplace(Result, '&frac34;',  '¾', [rfReplaceAll]);
  Result := StringReplace(Result, '&iquest;',  '¿', [rfReplaceAll]);
  Result := StringReplace(Result, '&Agrave;',  'À', [rfReplaceAll]);
  Result := StringReplace(Result, '&Aacute;',  'Á', [rfReplaceAll]);
  Result := StringReplace(Result, '&Acirc;',   'Â', [rfReplaceAll]);
  Result := StringReplace(Result, '&Atilde;',  'Ã', [rfReplaceAll]);
  Result := StringReplace(Result, '&Auml;',    'Ä', [rfReplaceAll]);
  Result := StringReplace(Result, '&Aring;',   'Å', [rfReplaceAll]);
  Result := StringReplace(Result, '&AElig;',   'Æ', [rfReplaceAll]);
  Result := StringReplace(Result, '&Ccedil;',  'Ç', [rfReplaceAll]);
  Result := StringReplace(Result, '&Egrave;',  'È', [rfReplaceAll]);
  Result := StringReplace(Result, '&Eacute;',  'É', [rfReplaceAll]);
  Result := StringReplace(Result, '&Ecirc;',   'Ê', [rfReplaceAll]);
  Result := StringReplace(Result, '&Euml;',    'Ë', [rfReplaceAll]);
  Result := StringReplace(Result, '&Igrave;',  'Ì', [rfReplaceAll]);
  Result := StringReplace(Result, '&Iacute;',  'Í', [rfReplaceAll]);
  Result := StringReplace(Result, '&Icirc;',   'Î', [rfReplaceAll]);
  Result := StringReplace(Result, '&Iuml;',    'Ï', [rfReplaceAll]);
  Result := StringReplace(Result, '&ETH;',     'Ð', [rfReplaceAll]);
  Result := StringReplace(Result, '&Ntilde;',  'Ñ', [rfReplaceAll]);
  Result := StringReplace(Result, '&Ograve;',  'Ò', [rfReplaceAll]);
  Result := StringReplace(Result, '&Oacute;',  'Ó', [rfReplaceAll]);
  Result := StringReplace(Result, '&Ocirc;',   'Ô', [rfReplaceAll]);
  Result := StringReplace(Result, '&Otilde;',  'Õ', [rfReplaceAll]);
  Result := StringReplace(Result, '&Ouml;',    'Ö', [rfReplaceAll]);
  Result := StringReplace(Result, '&times;',   '×', [rfReplaceAll]);
  Result := StringReplace(Result, '&Oslash;',  'Ø', [rfReplaceAll]);
  Result := StringReplace(Result, '&Ugrave;',  'Ù', [rfReplaceAll]);
  Result := StringReplace(Result, '&Uacute;',  'Ú', [rfReplaceAll]);
  Result := StringReplace(Result, '&Ucirc;',   'Û', [rfReplaceAll]);
  Result := StringReplace(Result, '&Uuml;',    'Ü', [rfReplaceAll]);
  Result := StringReplace(Result, '&Yacute;',  'Ý', [rfReplaceAll]);
  Result := StringReplace(Result, '&THORN;',   'Þ', [rfReplaceAll]);
  Result := StringReplace(Result, '&szlig;',   'ß', [rfReplaceAll]);
  Result := StringReplace(Result, '&agrave;',  'à', [rfReplaceAll]);
  Result := StringReplace(Result, '&aacute;',  'á', [rfReplaceAll]);
  Result := StringReplace(Result, '&acirc;',   'â', [rfReplaceAll]);
  Result := StringReplace(Result, '&atilde;',  'ã', [rfReplaceAll]);
  Result := StringReplace(Result, '&auml;',    'ä', [rfReplaceAll]);
  Result := StringReplace(Result, '&aring;',   'å', [rfReplaceAll]);
  Result := StringReplace(Result, '&aelig;',   'æ', [rfReplaceAll]);
  Result := StringReplace(Result, '&ccedil;',  'ç', [rfReplaceAll]);
  Result := StringReplace(Result, '&egrave;',  'è', [rfReplaceAll]);
  Result := StringReplace(Result, '&eacute;',  'é', [rfReplaceAll]);
  Result := StringReplace(Result, '&ecirc;',   'ê', [rfReplaceAll]);
  Result := StringReplace(Result, '&euml;',    'ë', [rfReplaceAll]);
  Result := StringReplace(Result, '&igrave;',  'ì', [rfReplaceAll]);
  Result := StringReplace(Result, '&iacute;',  'í', [rfReplaceAll]);
  Result := StringReplace(Result, '&icirc;',   'î', [rfReplaceAll]);
  Result := StringReplace(Result, '&iuml;',    'ï', [rfReplaceAll]);
  Result := StringReplace(Result, '&eth;',     'ð', [rfReplaceAll]);
  Result := StringReplace(Result, '&ntilde;',  'ñ', [rfReplaceAll]);
  Result := StringReplace(Result, '&ograve;',  'ò', [rfReplaceAll]);
  Result := StringReplace(Result, '&oacute;',  'ó', [rfReplaceAll]);
  Result := StringReplace(Result, '&ocirc;',   'ô', [rfReplaceAll]);
  Result := StringReplace(Result, '&otilde;',  'õ', [rfReplaceAll]);
  Result := StringReplace(Result, '&ouml;',    'ö', [rfReplaceAll]);
  Result := StringReplace(Result, '&divide;',  '÷', [rfReplaceAll]);
  Result := StringReplace(Result, '&oslash;',  'ø', [rfReplaceAll]);
  Result := StringReplace(Result, '&ugrave;',  'ù', [rfReplaceAll]);
  Result := StringReplace(Result, '&uacute;',  'ú', [rfReplaceAll]);
  Result := StringReplace(Result, '&ucirc;',   'û', [rfReplaceAll]);
  Result := StringReplace(Result, '&uuml;',    'ü', [rfReplaceAll]);
  Result := StringReplace(Result, '&yacute;',  'ý', [rfReplaceAll]);
  Result := StringReplace(Result, '&thorn;',   'þ', [rfReplaceAll]);
  Result := StringReplace(Result, '&yuml;',    'ÿ', [rfReplaceAll]);
end;

end.

