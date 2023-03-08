unit UDownloadHTML;

interface

uses
  System.Classes,
  Vcl.ComCtrls;
//  FMX.StdCtrls; -> pour une implementation FMX possible et ultérieur

function DownloadHTTP(const AUrl, FileName : string; Progress : TProgressbar = nil) : boolean; overload
function DownloadHTTP(const AUrl, FileName : string; Login, Password : string; Progress : TProgressbar = nil) : boolean; overload
function DownloadHTTP(const AUrl : string; out Content : TStringList; Progress : TProgressbar = nil) : boolean; overload
function DownloadHTTP(const AUrl : string; out Content : TStringList; Login, Password : string; Progress : TProgressbar = nil) : boolean; overload

implementation

uses
  Winapi.Windows,
  Winapi.CommCtrl,
  System.SysUtils,
  Vcl.Controls,
  IdURI,
  IdHTTP,
  IdComponent,
  IdCompressorZLib,
  IdAuthentication,
  IdHeaderList,
  IdAuthenticationSSPI;

type
  TIdHTTPUtils = class(TObject)
  private
    FProgress : TProgressBar;
    FFileSize : Int64;
    FFacteur : integer;
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

function DownloadHTTP(const AUrl, FileName : string; Progress : TProgressbar) : boolean;
begin
  Result := DownloadHTTP(AUrl, FileName, '', '', Progress);
end;

function DownloadHTTP(const AUrl, FileName : string; Login, Password : string; Progress : TProgressbar) : boolean;
var
  IdHTTP : TIdHTTP;
  IdCompres : TIdCompressorZLib;
  TempUtils : TIdHTTPUtils;
  FileStream : TStream;
  FileSize : int64;
begin
  Result := false;
  IdHTTP := nil;
  IdCompres := nil;
  TempUtils := nil;
  FileStream := nil;

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
        FileStream := TFileStream.Create(FileName, fmCreate);
        IdHTTP.Get(TIdURI.URLEncode(AUrl), FileStream);
        Result := true;
      except
      end;
    finally
      FreeAndNil(TempUtils)
    end;
  finally
    FreeAndNil(FileStream);
    FreeAndNil(IdCompres);
    FreeAndNil(IdHTTP);
  end;
end;

function DownloadHTTP(const AUrl : string; out Content : TStringList; Progress : TProgressbar) : boolean;
begin
  Result := DownloadHTTP(AUrl, Content, '', '', Progress);
end;

function DownloadHTTP(const AUrl : string; out Content : TStringList; Login, Password : string; Progress : TProgressbar) : boolean;
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
  FFacteur := 1;
end;

procedure TIdHTTPUtils.DoWorkBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Int64);
begin
  if Assigned(FProgress) then
  begin
    // recherche de max
    if AWorkCountMax > 0 then
      FFileSize := AWorkCountMax;
    // reduction avec facteur pour "tenir" dans le max de l'integer
    while FFileSize > MaxInt do
    begin
      FFacteur := FFacteur *10;
      FFileSize := Trunc(AWorkCountMax /10);
    end;
    // init de la prograssbar
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

procedure TIdHTTPUtils.DoWorkEnd(ASender: TObject; AWorkMode: TWorkMode);
begin
  if Assigned(FProgress) and (FFileSize > 0) then
    PostMessage(FProgress.Handle, PBM_SETPOS, FProgress.Max, 0);
end;

procedure TIdHTTPUtils.DoWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
begin
  if Assigned(FProgress) and (FFileSize > 0) then
    PostMessage(FProgress.Handle, PBM_SETPOS, Trunc(AWorkCount / FFacteur), 0);
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
