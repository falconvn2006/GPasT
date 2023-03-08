unit UPost;

{
Adaptation de la version d'origine pour XE :
1. Remlacement de IpHttp par IdHttp
2. Suppression de XML_Unit et et utilisation de TClientDataSet et TXMLTransformProvider
3. Création des fichiers XTR avec XMLMapper
4. Allègement global pour ne conserver que la fonction select, la seule ayant un intérêt ici
}

interface
uses
   forms,
   windows,
   StdCtrls,
   Classes, sysutils,
   IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdMultiPartFormData,
   IdHTTP, HttpApp, IdStrings;

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
      function GetVersion(AGUID : String) : String;
   end;

var
  YellisConnexion : Tconnexion;

const
  URL_SERVEUR_YELLIS = 'yellis.ginkoia.net';

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

destructor Tconnexion.Destroy;
begin
   clt.free;
   HTTPReponse.Free;
   inherited;
end;

function Tconnexion.GetVersion(AGUID: String): String;
var
   tpd: TPostData;
begin
  HTTPReponse.Clear;
  tpd := TPostData.create;
  try
    if base <> '' then
       tpd.add('db', base);
    tpd.add('action', 'VERSION');
    tpd.add('guid', AGUID);
    Result := '';
    if tpd.PostWaitTimeOut(clt, 'http://' + URL_SERVEUR_YELLIS + '/admin/get_version.php', 30000, HTTPReponse) then
    begin
      with TStringStream.Create('') do
      try
         CopyFrom(HTTPReponse, 0);
         Result := DataString;
      finally
         Free;
      end;
    end;
  finally
     tpd.Free;
  end;
  Application.processmessages;
end;

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
         if tpd.PostWaitTimeOut(clt, 'http://' + URL_SERVEUR_YELLIS + '/admin/base.php', 30000, HTTPReponse) then
         begin
         with TStringStream.Create('') do
              try
                 CopyFrom(HTTPReponse, 0);
                 //insertion de l'en-tête XML
                 Result := StringReplace( DataString, '<XML>', '<?xml version="1.0" encoding="ISO-8859-1"?><XML>',[]);

                 //pour continuer les tests, je remets le decode manuel
                 Result := StringReplace(Result, '&eacute', 'é', [rfReplaceAll]);
                 Result := StringReplace(Result, '&egrave', 'è', [rfReplaceAll]);
                 Result := StringReplace(Result, '&ccedil', 'ç', [rfReplaceAll]);
                 Result := StringReplace(Result, '&Eacute', 'É', [rfReplaceAll]);

                 //Format date non importable (en Delphi 0 = 1899-12-30 12:00:00)
                 Result := StringReplace(Result, '1899-12-30 00:00:00', '0', [rfReplaceAll]) ;
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

initialization
  YellisConnexion := Tconnexion.create;
finalization
  FreeAndNil(YellisConnexion);
end.

