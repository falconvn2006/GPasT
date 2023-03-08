unit uDownloadFTP;

interface

uses
  System.Classes,
  Vcl.ComCtrls;
//  FMX.StdCtrls; -> pour une implementation FMX possible et ultérieur

function FileExistsFTP(const AUrl, Login, Password : string) : boolean; overload;
function FileExistsFTP(const AUrl, Login, Password : string; out FileSize : int64; out FileDate : TDateTime) : boolean; overload;

function DownloadFTP(const AUrl, FileName, Login, Password : string; Progress : TProgressbar = nil) : boolean; overload;

implementation

uses
  Winapi.Windows,
  Winapi.CommCtrl,
  System.SysUtils,
  System.Math,
  Vcl.Controls,
  IdGlobal,
  IdComponent,
  IdFTPCommon,
  IdFTP,
  IdSSLOpenSSL,
  IdAllFTPListParsers,
  uFileUtils;

type
  TIdFTPUtils = class(TObject)
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
  end;

function SplitURL(const URL : string; out Serveur, Path, Name : string) : boolean;
var
  tmpURL : string;
  Position : Integer;
begin
  Result := false;
  Serveur := '';
  Path := '';
  Name := '';
  tmpURL := URL;
  if Copy(tmpURL, 1, 3) = 'ftp' then
    tmpURL := Copy(tmpURL, 7, Length(tmpURL));

  Position := Pos('/', tmpURL);
  if Position > 0 then
  begin
    serveur := Copy(tmpURL, 1, Position -1);
    tmpURL := Copy(tmpURL, Position, Length(tmpURL));
  end;

  Position := 2;
  while Pos('/', tmpURL, Position) > 0 do
    Position := Pos('/', tmpURL, Position) +1;

  Path := Copy(tmpURL, 1, Position -1);
  Name := Copy(tmpURL, Position, Length(tmpURL));

  Result := not ((Serveur = '') or
                 (Path = '') or
                 (Name = ''));
end;

function FileExistsFTP(const AUrl, Login, Password : string) : boolean;
var
  FileSize : int64;
  FileDate : TDateTime;
begin
  Result := FileExistsFTP(AUrl, Login, Password, FileSize, FileDate);
end;

function FileExistsFTP(const AUrl, Login, Password : string; out FileSize : int64; out FileDate : TDateTime) : boolean;
var
  Serveur, Path, Name : string;
  Ftp : TIdFTP;
begin
  Result := False;
  if SplitURL(AUrl, Serveur, Path, Name) then
  begin
    try
      Ftp := TIdFTP.Create(nil);
      Ftp.Host := Serveur;
      Ftp.Passive := true;
      Ftp.UseMLIS := false;
      Ftp.Username := Login;
      Ftp.Password := Password;
      try
        Ftp.Connect();
        Ftp.ChangeDir(Path);
        Ftp.List(Name);
        if (Ftp.DirectoryListing.Count = 1) and (Ftp.DirectoryListing[0].FileName = Name) then
        begin
          Result := True;
          FileSize := Ftp.DirectoryListing[0].Size;
          FileDate := Ftp.DirectoryListing[0].ModifiedDate;
        end;
      finally
        Ftp.Disconnect();
      end;
    finally
      FreeAndNil(Ftp);
    end;
  end;
end;

function DownloadFTP(const AUrl, FileName, Login, Password : string; Progress : TProgressbar = nil) : boolean;
var
  Serveur, Path, Name : string;
  TempUtils : TIdFTPUtils;
  Ftp : TIdFTP;
begin
  Result := False;
  if SplitURL(AUrl, Serveur, Path, Name) then
  begin
    try
      Ftp := TIdFTP.Create(nil);
      Ftp.Host := Serveur;
      Ftp.Passive := true;
      Ftp.UseMLIS := false;
      Ftp.TransferType := ftBinary;
      Ftp.Username := Login;
      Ftp.Password := Password;

      try
        Ftp.Connect();
        Ftp.ChangeDir(Path);
        Ftp.List(Name);
        if (Ftp.DirectoryListing.Count = 1) and (Ftp.DirectoryListing[0].FileName = Name) then
        begin
          try
            TempUtils := TIdFTPUtils.Create(Progress, Ftp.DirectoryListing[0].Size);
            Ftp.OnWorkBegin := TempUtils.DoWorkBegin;
            Ftp.OnWorkEnd := TempUtils.DoWorkEnd;
            Ftp.OnWork := TempUtils.DoWork;
            Ftp.Get(Name, FileName);
            Result := True;
          finally
            FreeAndNil(TempUtils);
          end;
        end;
      finally
        Ftp.Disconnect();
      end;
    finally
      FreeAndNil(Ftp);
    end;
  end;
end;

{ TIdFTPUtils }

constructor TIdFTPUtils.Create(Progress : TProgressBar; FileSize : Int64);
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

procedure TIdFTPUtils.DoWorkBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Int64);
begin
  FStep := Trunc(AWorkCountMax / FFacteur);
end;

procedure TIdFTPUtils.DoWorkEnd(ASender: TObject; AWorkMode: TWorkMode);
begin
  FFilePos := FFilePos + FStep;
end;

procedure TIdFTPUtils.DoWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
begin
  if Assigned(FProgress) and (FFileSize > 0) then
    PostMessage(FProgress.Handle, PBM_SETPOS, FFilePos + Trunc(AWorkCount / FFacteur), 0);
end;

end.
