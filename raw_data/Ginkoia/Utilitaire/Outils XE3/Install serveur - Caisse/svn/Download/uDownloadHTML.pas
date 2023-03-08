unit uDownloadHTML;

interface

uses
  System.Classes,
  Vcl.ComCtrls;
//  FMX.StdCtrls; -> pour une implementation FMX possible et ultérieur

function FileExistsHTTP(const AUrl : string) : boolean; overload;
function FileExistsHTTP(const AUrl : string; out FileSize : int64; out FileDate : TDateTime) : boolean; overload;
function FileExistsHTTP(const AUrl, Login, Password : string) : boolean; overload;
function FileExistsHTTP(const AUrl, Login, Password : string; out FileSize : int64; out FileDate : TDateTime) : boolean; overload;

function DownloadHTTP(const AUrl, FileName : string; Progress : TProgressbar = nil) : boolean; overload;
function DownloadHTTP(const AUrl, FileName, Login, Password : string; Progress : TProgressbar = nil) : boolean; overload;
function DownloadHTTP(const AUrl : string; out Content : TStringList; Progress : TProgressbar = nil) : boolean; overload;
function DownloadHTTP(const AUrl : string; out Content : TStringList; const Login, Password : string; Progress : TProgressbar = nil) : boolean; overload;

implementation

uses
  Winapi.Windows,
  Winapi.CommCtrl,
  System.SysUtils,
  System.Math,
  Vcl.Controls,
  IdURI,
  IdHTTP,
  IdComponent,
  IdCompressorZLib,
  IdAuthentication,
  IdHeaderList,
  IdAuthenticationSSPI,
  IdSSL,
  IdSSLOpenSSL,
  IdExplicitTLSClientServerBase;

type
  TIdHTTPUtils = class(TObject)
  private
    FProgress : TProgressBar;
    FFileSize : Int64;
    FFilePos : Int64;
    FFacteur : integer;
    FStep : Int64;
  public
    constructor Create(Progress : TProgressBar; FileSize : Int64);
    // fonction de progression
    procedure DoWorkBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Int64);
    procedure DoWorkEnd(ASender: TObject; AWorkMode: TWorkMode);
    procedure DoWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
    // autentification
    procedure DoSelectAuthorization(Sender: TObject; var AuthenticationClass: TIdAuthenticationClass; AuthInfo: TIdHeaderList);
    procedure DoAuthorization(Sender: TObject; Authentication: TIdAuthentication; var Handled: Boolean);
  end;

function FileExistsHTTP(const AUrl : string) : boolean;
var
  FileSize : int64;
  FileDate : TDateTime;
begin
  Result := FileExistsHTTP(AUrl, '', '', FileSize, FileDate);
end;

function FileExistsHTTP(const AUrl : string; out FileSize : int64; out FileDate : TDateTime) : boolean;
begin
  Result := FileExistsHTTP(AUrl, '', '', FileSize, FileDate);
end;

function FileExistsHTTP(const AUrl, Login, Password : string) : boolean;
var
  FileSize : int64;
  FileDate : TDateTime;
begin
  Result := FileExistsHTTP(AUrl, Login, Password, FileSize, FileDate);
end;

function FileExistsHTTP(const AUrl, Login, Password : string; out FileSize : int64; out FileDate : TDateTime) : boolean;
var
  IdHTTP : TIdHTTP;
  IdCompres : TIdCompressorZLib;
  IdIoHandler : TIdSSLIOHandlerSocketOpenSSL;
begin
  Result := false;
  FileSize := 0;
  FileDate := 0;
  IdHTTP := nil;
  IdCompres := nil;
  IdIoHandler := nil;

  if Trim(AUrl) = '' then
    Exit;

  try
    IdHTTP :=  TIdHTTP.Create(nil);
    if not ((Trim(login) = '') and (Trim(password) = '')) then
    begin
      IdHTTP.Request.UserName := login;
      IdHTTP.Request.Password := password;
      IdHTTP.Request.BasicAuthentication := False;
      IdHTTP.HTTPOptions := IdHTTP.HTTPOptions + [hoInProcessAuth];
    end;
    if UpperCase(Copy(AUrl, 1, 5)) = 'HTTPS' then
    begin
      IdIoHandler := TIdSSLIOHandlerSocketOpenSSL.Create();
      IdIoHandler.Destination := AUrl;
//      IdIoHandler.Host := serveur;
//      IdIoHandler.Port := port;
      IdIoHandler.SSLOptions.Method := sslvSSLv23;
      IdHTTP.IOHandler := IdIoHandler;
//      IdHTTP.UseTLS := utUseImplicitTLS;
    end;
    // recup de taille de fichier ...
    try
      IdHTTP.Head(TIdURI.URLEncode(AUrl));
      Result := ((IdHTTP.ResponseCode >= 200) and (IdHTTP.ResponseCode < 300));
      if Result then
      begin
        FileSize := IdHTTP.Response.ContentLength;
        FileDate := IdHTTP.Response.LastModified;
      end;
    except
      Result := false;
    end;
  finally
    FreeAndNil(IdIoHandler);
    FreeAndNil(IdCompres);
    FreeAndNil(IdHTTP);
  end;
end;

function DownloadHTTP(const AUrl, FileName : string; Progress : TProgressbar) : boolean;
begin
  Result := DownloadHTTP(AUrl, FileName, '', '', Progress);
end;

function DownloadHTTP(const AUrl, FileName, Login, Password : string; Progress : TProgressbar) : boolean;
const
  ChunkSize = 65536;
var
  IdHTTP : TIdHTTP;
  IdCompres : TIdCompressorZLib;
  IdIoHandler : TIdSSLIOHandlerSocketOpenSSL;
  TempUtils : TIdHTTPUtils;
  FileStream : TStream;
  FileSize : int64;
begin
  Result := false;
  IdHTTP := nil;
  IdCompres := nil;
  IdIoHandler := nil;
  TempUtils := nil;
  FileStream := nil;

  if Trim(AUrl) = '' then
    Exit;

  try
    IdHTTP :=  TIdHTTP.Create(nil);
    if not ((Trim(login) = '') and (Trim(password) = '')) then
    begin
      IdHTTP.Request.UserName := login;
      IdHTTP.Request.Password := password;
      IdHTTP.Request.BasicAuthentication := False;
      IdHTTP.HTTPOptions := IdHTTP.HTTPOptions + [hoInProcessAuth];
    end;
    if UpperCase(Copy(AUrl, 1, 5)) = 'HTTPS' then
    begin
      IdIoHandler := TIdSSLIOHandlerSocketOpenSSL.Create();
      IdIoHandler.Destination := AUrl;
//      IdIoHandler.Host := serveur;
//      IdIoHandler.Port := port;
      IdIoHandler.SSLOptions.Method := sslvSSLv23;
      IdHTTP.IOHandler := IdIoHandler;
//      IdHTTP.UseTLS := utUseImplicitTLS;
    end;
    // recup de taille de fichier ...
    IdHTTP.Head(TIdURI.URLEncode(AUrl));
    FileSize := IdHTTP.Response.ContentLength;
    // paramètyrage du composant
    IdCompres := TIdCompressorZLib.Create();
    IdHTTP.Compressor := IdCompres;
    IdHTTP.HandleRedirects := true;
    IdHTTP.RedirectMaximum := 15;
    IdHTTP.Request.AcceptEncoding := 'gzip,deflate';
    IdHTTP.Request.ContentEncoding := 'gzip';
    try
      TempUtils := TIdHTTPUtils.Create(Progress, FileSize);
      // progressbar ?
      IdHTTP.OnWorkBegin := TempUtils.DoWorkBegin;
      IdHTTP.OnWorkEnd := TempUtils.DoWorkEnd;
      IdHTTP.OnWork := TempUtils.DoWork;
      // telechargement !
      try
        if FileExists(FileName) then
        begin
          FileStream := TFileStream.Create(FileName, fmOpenReadWrite or fmShareDenyWrite);
          if FileStream.Size >= FileSize then
          begin
            Result := true;
            Exit;
          end
          else
            FileStream.Seek(Max(0, FileStream.Size - ChunkSize), soBeginning);
        end
        else
          FileStream := TFileStream.Create(FileName, fmCreate or fmShareDenyWrite);

        repeat
          if FileStream.Position + ChunkSize > FileSize then
            IdHTTP.Request.Range := IntToStr(FileStream.Position) + '-'
          else
            IdHTTP.Request.Range := IntToStr(FileStream.Position) + '-' + IntToStr(FileStream.Position + ChunkSize);
          IdHTTP.Get(TIdURI.URLEncode(AUrl), FileStream);
        until FileStream.Size >= FileSize;

        Result := true;
      except
      end;
    finally
      FreeAndNil(TempUtils)
    end;
  finally
    FreeAndNil(FileStream);
    FreeAndNil(IdIoHandler);
    FreeAndNil(IdCompres);
    FreeAndNil(IdHTTP);
  end;
end;

function DownloadHTTP(const AUrl : string; out Content : TStringList; Progress : TProgressbar) : boolean;
begin
  Result := DownloadHTTP(AUrl, Content, '', '', Progress);
end;

function DownloadHTTP(const AUrl : string; out Content : TStringList; const Login, Password : string; Progress : TProgressbar) : boolean;
var
  IdHTTP : TIdHTTP;
  IdCompres : TIdCompressorZLib;
  TempUtils : TIdHTTPUtils;
  StringStream : TStream;
  FileSize : int64;
begin
  Result := false;
  IdHTTP := nil;
  IdCompres := nil;
  TempUtils := nil;
  StringStream := nil;

  if Trim(AUrl) = '' then
    Exit;

  Content := TStringList.Create();
  try
    IdHTTP :=  TIdHTTP.Create(nil);
    if not ((Trim(login) = '') and (Trim(password) = '')) then
    begin
      IdHTTP.Request.UserName := login;
      IdHTTP.Request.Password := password;
      idHttp.Request.BasicAuthentication := False;
      IdHTTP.HTTPOptions := IdHTTP.HTTPOptions + [hoInProcessAuth];
    end;
    // recup de taille de fichier ...
    IdHTTP.Head(TIdURI.URLEncode(AUrl));
    FileSize := IdHTTP.Response.ContentLength;
    // paramètyrage du composant
    IdCompres := TIdCompressorZLib.Create();
    IdHTTP.Compressor := IdCompres;
    IdHTTP.HandleRedirects := true;
    IdHTTP.RedirectMaximum := 15;
    IdHTTP.Request.AcceptEncoding := 'gzip,deflate';
    IdHTTP.Request.ContentEncoding := 'gzip';
    try
      TempUtils := TIdHTTPUtils.Create(Progress, FileSize);
      // progressbar ?
      IdHTTP.OnWorkBegin := TempUtils.DoWorkBegin;
      IdHTTP.OnWorkEnd := TempUtils.DoWorkEnd;
      IdHTTP.OnWork := TempUtils.DoWork;
      // telechargement !
      try
        StringStream := TStringStream.Create();
        IdHTTP.Get(TIdURI.URLEncode(AUrl), StringStream);
        StringStream.Seek(0, soBeginning);
        Content.LoadFromStream(StringStream);
        Result := true;
      except
        Result := false;
      end;
    finally
      FreeAndNil(TempUtils)
    end;
  finally
    FreeAndNil(StringStream);
    FreeAndNil(IdCompres);
    FreeAndNil(IdHTTP);
  end;
end;

{ TIdHTTPUtils }

constructor TIdHTTPUtils.Create(Progress : TProgressBar; FileSize : Int64);
begin
  Inherited Create();
  FProgress := Progress;
  FFileSize := FileSize;
  FFilePos := 0;
  FFacteur := 1;
  // reduction avec facteur pour "tenir" dans le max de l'integer
  while FFileSize > MaxInt do
  begin
    FFacteur := FFacteur *10;
    FFileSize := Trunc(FFileSize /10);
  end;
  // init de la prograssbar
  if Assigned(FProgress) then
  begin
    if FFileSize > 0 then
    begin
      PostMessage(FProgress.Handle, PBM_SETPOS, 0, 0);
      PostMessage(FProgress.Handle, PBM_SETSTEP, 1, 0);
      PostMessage(FProgress.Handle, PBM_SETRANGE32, 0, FFileSize);
    end
    else
    begin
      // sinon ... marquee !
      PostMessage(FProgress.Handle, PBM_SETMARQUEE, WPARAM(True), LPARAM(0));
    end;
  end;
end;

procedure TIdHTTPUtils.DoWorkBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Int64);
begin
  FStep := Trunc(AWorkCountMax / FFacteur);
end;

procedure TIdHTTPUtils.DoWorkEnd(ASender: TObject; AWorkMode: TWorkMode);
begin
  FFilePos := FFilePos + FStep;
end;

procedure TIdHTTPUtils.DoWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
begin
  if Assigned(FProgress) and (FFileSize > 0) then
    PostMessage(FProgress.Handle, PBM_SETPOS, FFilePos + Trunc(AWorkCount / FFacteur), 0);
end;

procedure TIdHTTPUtils.DoSelectAuthorization(Sender: TObject; var AuthenticationClass: TIdAuthenticationClass; AuthInfo: TIdHeaderList);
begin
  // eurf
end;

procedure TIdHTTPUtils.DoAuthorization(Sender: TObject; Authentication: TIdAuthentication; var Handled: Boolean);
begin
  // eurf
end;

end.
