unit UConstantes;

interface

uses
  IdExplicitTLSClientServerBase, IdSSLOpenSSL, windows;

type
  TMessageEvent = procedure(Sender: TObject; Text: String) of object;
  TProgressEvent = procedure(Sender: TObject; Progress: integer) of object;

  TParamMail = record
    FromAddress : string;
    SmtpPort    : integer;
    SmtpHost    : string;
    SmtpUsername: string;
    SmtpPassword: string;
    SmtpUseTLS  : TIdUseTLS;
    SSLVersion  : TIdSSLVersion;
  end;
  function GetCompName: string;



implementation
  function GetCompName: string;
  var
    dwLength: dword;
  begin
    dwLength := 253;
    SetLength(result, dwLength+1);
    if not Windows.GetComputerName(pchar(result), dwLength) then
      Result := '';
    result := pchar(result);
  end;
end.
