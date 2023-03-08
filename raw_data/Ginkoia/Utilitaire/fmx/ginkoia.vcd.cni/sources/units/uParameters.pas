unit uParameters;

interface

uses
   uPermissions, uDocuments;

type
  TParameters = class
    Debug: Boolean;
    Directory: String;
    DocumentFormat: TDocumentFormat;
    ID: String;
    Permissions: TPermissions;
    constructor Create(const Directory: String; const Permissions: TPermissions;
      const DocumentFormat: TDocumentFormat; const Debug: Boolean = False);
    destructor Destroy; override;
    class function Parse: TParameters; static;
    class function Default: TParameters; static;
  end;

implementation

uses
  System.SysUtils, System.StrUtils;

{ TParameters }

constructor TParameters.Create(const Directory: String;
  const Permissions: TPermissions; const DocumentFormat: TDocumentFormat;
  const Debug: Boolean);
begin
  inherited Create;
  Self.Debug := Debug;
  Self.Directory := Directory;
  Self.DocumentFormat := DocumentFormat;
  Self.Permissions := Permissions;
end;

class function TParameters.Default: TParameters;
begin
  Result := TParameters.Create(
    ExtractFilePath( ParamStr( 0 ) ),
    TPermissions.Default,
    TDocumentFormatRec.JPG
  );
end;

destructor TParameters.Destroy;
begin
  Permissions.Free;
  inherited;
end;

class function TParameters.Parse: TParameters;
var
  sCmdLineValue: String;
  iCmdLineValue: Integer;
  Permission: TPermission;
begin
  Result := TParameters.Default;
  if FindCmdLineSwitch( 'd', sCmdLineValue ) then
    Result.Directory := sCmdLineValue;
  if FindCmdLineSwitch( 'f', sCmdLineValue ) then
    case AnsiIndexStr( sCmdLineValue, [ 'jpg', 'png', 'bmp' ] ) of
      0: Result.DocumentFormat := TDocumentFormatRec.JPG;
      1: Result.DocumentFormat := TDocumentFormatRec.PNG;
      2: Result.DocumentFormat := TDocumentFormatRec.BMP;
    end;
  if FindCmdLineSwitch( 'p', sCmdLineValue ) and TryStrToInt( sCmdLineValue, iCmdLineValue ) then begin
    if Assigned( Result.Permissions ) then
      FreeAndNil( Result.Permissions );
    Result.Permissions := TPermissions.IntToPermissions( iCmdLineValue );
  end;
  if FindCmdLineSwitch( 'id', sCmdLineValue ) then
    Result.ID := sCmdLineValue;
  if FindCmdLineSwitch( 'debug', True ) then
    Result.Debug := True;
end;

end.
