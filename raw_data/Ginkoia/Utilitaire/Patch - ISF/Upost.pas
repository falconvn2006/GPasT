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
   idHttp,
   HTTPApp, uLog, iniFiles; 
   //IpUtils, IpSock, IpHttp;

type
   TDataType = (dtString, dtInteger, dtDel);
   TOperationType = (otWrite, otRead, otDel);

   TPostData = class
      Leschamps: tstringlist;
      procedure add(nom, valeur: string);
      procedure clear;
      constructor create;
      destructor destroy; override;
      function PostWaitTimeOut(clt: TIdHttp; url: string; timeout: integer; Memo: TMemo = nil ; outStream : TStream = nil): boolean;
      function GetWaitTimeOut(clt: TIdHttp; url: string): boolean;
   end;

   Tconnexion = class
      Base: string;
      clt: TIdHttp;
      function traitechaine(s: string): string;
      constructor create;
      destructor destroy; override;
      function Select(Qry: string; Memo: TMemo = nil): TstringList;
      function ordre(qry: string; Memo: TMemo = nil): boolean;
      function insert(qry: string; Memo: TMemo = nil): integer;
      procedure updateGT(aGuidSource, aGuidDest, aURLTools: string);
      procedure FreeResult(ts: tstringlist);
      function recordCount(ts: tstringlist): integer;
      function UneValeur(ts: tstringlist; col: string; Num: integer = 0): string;
      function UneValeurEntiere(ts: tstringlist; col: string; Num: integer = 0): Integer;
      function DateTime(D: TdateTime): string;
      procedure remplie(qry: string; mem: TdxMemData);
   private
      FUrlYellis: String;
   end;

   function ReadWriteDelIni(aSection, aKey: String; aValue: variant; aDataType: TDataType; aOperationType: TOperationType): Variant;

implementation
{ TPostData }
const
  cURL_YELLIS = 'yellis.ginkoia.net';

procedure AddLog(aMsg : string);
begin
  Log.Log('uPost', 'Log', aMsg, logDebug, false, -1, ltLocal) ;
end;

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

function TPostData.PostWaitTimeOut(clt: TIdHttp; url: string;
   timeout: integer; Memo: TMemo = nil ; outStream : TStream = nil): boolean;
var
   S: string;
   Tag: string;
   i: integer;
   tms: tmemorystream;
begin
  Result := false ;

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
  try
    tms.Write(pointer(s)^, length(s));
    tms.seek(soFromBeginning, 0);

    if memo <> nil
      then memo.lines.add(s);

//   clt.RequestFields.clear;
//   clt.RequestFields.add('Content-type: multipart/form-data;boundary="' + tag + '"');
//   clt.RequestFields.add('Content-length: ' + inttostr(length(s)));
//   result := clt.PostWaitTimeout(url, tms, TimeOut);

    clt.Request.Clear ;
    clt.Request.ContentType := 'multipart/form-data;boundary="' + tag + '"' ;
    clt.Request.ContentLength := length(s) ;
    clt.ConnectTimeout := 10000 ;
    clt.ReadTimeout    := 30000 ;
    clt.Post(url, tms, outStream) ;
    Result := (clt.ResponseCode = 200) ;
  finally
      tms.free ;
  end ;
end;

procedure Tconnexion.updateGT(aGuidSource, aGuidDest, aURLTools: string);
var
  tpd: TPostData;
  fullURL: string;
begin
  tpd := TPostData.create;
  try
    fullURL := IncludeTrailingBackslash(aURLTools) + 'api/ginkoia/update/setMajStatusSynchro.php?guidsynchro='+aGuidDest+'&guidserveur='+aGuidSource;

    tpd.GetWaitTimeOut(clt, fullURL);
  finally
    tpd.free;
  end;

end;

function TPostData.GetWaitTimeOut(clt: TIdHttp; url: string): boolean;
var
   returnText: string;
   sLog: TStringList;
begin
  Result := false ;

  try
    clt.Request.Clear ;
    clt.ConnectTimeout := 10000 ;
    clt.ReadTimeout    := 30000 ;
    clt.Get(url);
    Result := (clt.ResponseCode = 200);
    returnText := clt.ResponseText;

    if not (Result) then  // si retour pas ok, on log
    begin
      AddLog('Erreur envoi Tools : ' + returnText);
//      sLog := TStringList.Create ;
//      try
//        sLog.Add('Erreur envoi Tools : ' + returnText) ;
//        ForceDirectories(ExtractFilePath(paramstr(0)) + 'Logs\Debug') ;
//        sLog.SaveToFile(ExtractFilePath(paramstr(0)) + 'Logs\Debug\Verification_Debug_' + FormatDateTime('yyyy-mm-dd_hh_nn_ss_zzz', now) + '-'+IntToStr(random(999)) + '.log');
//      finally
//        sLog.Free ;
//      end;
    end;
  except
    on e : Exception do
    begin
      AddLog('Erreur envoi Tools : ' + e.ClassName + ' - ' + e.Message + ' Retour : ' + returnText);
//      sLog := TStringList.Create ;
//      try
//        sLog.Add('Erreur envoi Tools : ' + e.ClassName + ' - ' + e.Message + ' Retour : ' + returnText) ;
//        ForceDirectories(ExtractFilePath(paramstr(0)) + 'Logs\Debug') ;
//        sLog.SaveToFile(ExtractFilePath(paramstr(0)) + 'Logs\Debug\Verification_Debug_' + FormatDateTime('yyyy-mm-dd_hh_nn_ss_zzz', now) + '-'+IntToStr(random(999)) + '.log');
//      finally
//        sLog.Free ;
//      end;
    end;
  end;
end;

{ Tconnexion }

constructor Tconnexion.create;
begin
   Base := '';

   // paramètre pour l'URL de Yellis
  FUrlYellis := ReadWriteDelIni('Verification', 'UrlYellis', '', dtString, otRead);
  if FUrlYellis = '' then
  begin
    FUrlYellis := cURL_YELLIS;
    ReadWriteDelIni('Verification', 'UrlYellis', FUrlYellis, dtString, otWrite);
  end;

   clt := TIdHttp.create(nil);
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
   vDelay : Integer ;
begin
  Result := 0 ;
   vDelay := 1000 ;
   qry := traitechaine(qry);
   if memo <> nil then
      memo.Lines.add(qry);
   for i := 1 to 5 do
   begin
      tpd := TPostData.create;
      Body := TStringStream.Create('');
      try
        if base <> '' then
           tpd.add('db', base);
        tpd.add('action', 'QRY');
        tpd.add('qry1', qry);

        if tpd.PostWaitTimeOut(clt, 'http://' + FUrlYellis + '/admin/base.php', 30000, nil, Body) then
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
        tpd.Free;
        Body.free;
      end;

      if trim(S) <> '' then BREAK;
//      Application.processmessages;
//      clt.FreeLink('http://' + FUrlYellis + '/admin/base.php');
      Application.processmessages;

      sleep(vDelay);
      vDelay := vDelay * 2 ;
   end;
   if trim(s) = '' then
   begin
{$IFDEF debug}
      application.messagebox('Chaîne vide en réponse', 'Problème', MB_OK);
{$ENDIF}
      Exit ;
   end;
   if memo <> nil then
      memo.Lines.add(S);
   Xml := TmonXML.Create;
   xml.loadfromstring(S);
   pass := Xml.find('/XML/qry1');
   result := Strtoint(pass.GetFirstNode.GetValue);
   Xml.free;
//   clt.FreeLink('http://' + FUrlYellis + '/admin/base.php');
end;

function Tconnexion.ordre(qry: string; Memo: TMemo = nil): boolean;
var
   tpd: TPostData;
   Body: TStringStream;
   s: string;
   Xml: TmonXML;
   Pass: TIcXMLElement;
   i: integer;
   vDelay : Integer ;
   sLog : TStringList ;
begin
   Result := false ;
   vDelay := 1000 ;
   qry := traitechaine(qry);
   if memo <> nil then
      memo.Lines.add(qry);
   for i := 1 to 5 do
   begin
      tpd := TPostData.create;
      Body := TStringStream.Create('');
      try
        if base <> ''
          then tpd.add('db', base);

        tpd.add('action', 'QRY');
        tpd.add('qry1', qry);

        if tpd.PostWaitTimeOut(clt, 'http://' + FUrlYellis + '/admin/base.php', 30000, nil, Body) then
        begin
           S := BODY.DataString;

           try
             ForceDirectories(ExtractFilePath(paramstr(0)) + 'Logs\Debug') ;

{$IFDEF debug}
//             sLog := TStringList.Create ;
//             sLog.Add('Query :') ;
//             sLog.Add(Qry) ;
//             sLog.Add('Reply :') ;
//             sLog.Add(s) ;
//             sLog.SaveToFile(ExtractFilePath(paramstr(0)) + 'Logs\Debug\Verification_Debug_' + FormatDateTime('yyyy-mm-dd_hh_nn_ss_zzz', now) + '-'+IntToStr(random(999))+'.log');
//             sLog.Free ;
             AddLog('Query :');
             AddLog(Qry);
             AddLog('Reply :');
             AddLog(s);
{$ENDIF}
           except
           end;


           if pos('<HTML>', Uppercase(S)) > 0 then
           begin
//              sLog := TStringList.Create ;
//              try
//                sLog.Add(s) ;
//                try
//                  ForceDirectories(ExtractFilePath(paramstr(0)) + 'Logs\Debug') ;
//                  sLog.SaveToFile(ExtractFilePath(paramstr(0)) + 'Logs\Debug\Verification_Debug_' + FormatDateTime('yyyy-mm-dd_hh_nn_ss_zzz', now) + '-'+IntToStr(random(999)) + '.log');
//                except
//                end;
//              finally
//                sLog.Free ;
//              end;
              AddLog(s);
              s := '';
           end;
        end else begin
           s := '';
           try
             ForceDirectories(ExtractFilePath(paramstr(0)) + 'Logs\Debug') ;

{$IFDEF debug}
//             sLog := TStringList.Create ;
//             sLog.Add('Query :') ;
//             sLog.Add(Qry) ;
//             sLog.Add('Reply : Empty') ;
//             sLog.SaveToFile(ExtractFilePath(paramstr(0)) + 'Logs\Debug\Verification_Debug_' + FormatDateTime('yyyy-mm-dd_hh_nn_ss_zzz', now) + '-'+IntToStr(random(999))+'.log');
//             sLog.Free ;
             AddLog('Query :');
             AddLog(Qry);
             AddLog('Reply :');
             AddLog(s);
{$ENDIF}
           except
           end;
        end;

      finally
        Body.free;
        tpd.Free;
      end;

      if trim(s) <> '' then BREAK;          // Ok on sort

      Application.processmessages;
//      clt.FreeLink('http://' + FUrlYellis + '/admin/base.php');
      Application.processmessages;

      sleep(vDelay);
      vDelay := vDelay * 2 ;
   end; // End For

   if trim(s) = '' then
   begin
{$IFDEF debug}
      application.messagebox('Chaîne vide en réponse', 'Problème', MB_OK);
{$ENDIF}
      Exit;
   end;

   if memo <> nil then
      memo.Lines.add(S);
   Xml := TmonXML.Create;
   xml.loadfromstring(S);
   pass := Xml.find('/XML/RESULT');
   result := pass.GetFirstNode.GetValue = 'OK';
   Xml.free;
//   clt.FreeLink('http://' + FUrlYellis + '/admin/base.php');
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
   vDelay : Integer ;
begin
   vDelay := 1000 ;
   qry := traitechaine(qry);
   result := tstringlist.create;
   if memo <> nil then
      memo.lines.add(qry);
   for i := 1 to 5 do
   begin
      tpd := TPostData.create;
      Body := TStringStream.Create('');
      try
        if base <> '' then
           tpd.add('db', base);
        tpd.add('action', 'SEL');
        tpd.add('sel', qry);
        if tpd.PostWaitTimeOut(clt, 'http://' + FUrlYellis + '/admin/base.php', 30000, Memo, Body) then
        begin
           S := Body.DataString ;

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
        tpd.Free;
        Body.Free ; 
      end;

      if trim(S) <> '' then BREAK;
      Application.processmessages;
//      clt.FreeLink('http://' + FUrlYellis + '/admin/base.php');
      Application.processmessages;

      sleep(vDelay);
      vDelay := vDelay * 2 ;
   end;

   if trim(s) = '' then
   begin
{$IFDEF debug}
      application.messagebox('Chaîne vide en réponse', 'Problème', MB_OK);
{$ENDIF}
      Exit ;
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
//   clt.FreeLink('http://' + FUrlYellis + '/admin/base.php');
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

function ReadWriteDelIni(aSection, aKey: String; aValue: variant; aDataType: TDataType; aOperationType: TOperationType): Variant;
var
  IniFile: TIniFile;
begin
  Result := '';
  IniFile := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));

  case aOperationType of
    otWrite:
    begin
      case aDataType of
        dtString: IniFile.WriteString(aSection, aKey, aValue);
        dtInteger: IniFile.WriteInteger(aSection, aKey, aValue);
      end;
    end;
    otRead:
    begin
      case aDataType of
        dtString: Result := IniFile.ReadString(aSection, aKey, aValue);
        dtInteger: Result := IniFile.ReadInteger(aSection, aKey, aValue);
      end;
    end;
    otDel:
    begin
      Inifile.EraseSection(aSection);
    end;
  end;
end;

end.
