unit UParams;

interface

uses
  System.Classes;

type
  TRepareBase = class
  private
    class var
      RepareBase: TRepareBase;
    var
      FPwd: string;
      FHost: string;
      FPort: Integer;
      FLibrary: string;
      FDBUser: string;
      FDBPwd: string;
      FProtocol: string;
      FLauncherName: string;
      FNoAllowedNames: TStrings;
    FComputerName: string;
    function GetPwd: string;
    function GetRebootAllowed: Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure ReadParams;
    property Host: string read FHost;
    property PassWord: string read GetPwd;
    property Port: Integer read FPort;
    property DBUser: string read FDBUser;
    property DBPassWord: string read FDBPwd;
    property LibraryName: string read FLibrary;
    property LauncherName: string read FLauncherName;
    property Protocol: string read FProtocol;
    property ComputerName: string read FComputerName;
    property RebootAllowed: Boolean read GetRebootAllowed;
    property NoAllowedNames: TStrings read FNoAllowedNames;
  end;

function SRepareBase: TRepareBase;

implementation

uses
  SysUtils, Forms, IniFiles,
  DCPbase64, BaseCrypt, UConstants, UUtils;

{ TRepareBase }

constructor TRepareBase.Create;
begin
  //
  FComputerName := UUtils.ComputerName;
  //
  FNoAllowedNames := TStringList.Create;
  //
  ReadParams;
end;

destructor TRepareBase.Destroy;
begin
  FNoAllowedNames.Free;
  inherited;
end;

function TRepareBase.GetPwd: string;
begin
  Result := DecryptString(Base64DecodeStr(FPwd), PWD_KEY);
end;

function TRepareBase.GetRebootAllowed: Boolean;
var
  i: Integer;
begin
  for i := 0 to FNoAllowedNames.Count - 1 do
    if Pos(UpperCase(FNoAllowedNames[i]), UpperCase(FComputerName)) > 0 then
      Exit(False);
  //
  Result := True;
end;

procedure TRepareBase.ReadParams;
var
  IniFile: TIniFile;
  i, p: Integer;
begin
  IniFile := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  try
    FPwd := IniFile.ReadString(INI_SECTION_APP, INI_APP_PWD, PWD_DEFAULT);
    FHost := IniFile.ReadString(INI_SECTION_DB, INI_DB_HOST, DEFAULT_HOST);
    FPort := IniFile.ReadInteger(INI_SECTION_DB, INI_DB_PORT, DEFAULT_PORT);
    FDBUser := IniFile.ReadString(INI_SECTION_DB, INI_DB_USER, DEFAULT_DB_USER);
    FDBPwd := IniFile.ReadString(INI_SECTION_DB, INI_DB_PWD, DEFAULT_DB_PWD);
    FLibrary := IniFile.ReadString(INI_SECTION_DB, INI_DB_LIBRARY, DEFAULT_DB_LIB);
    FLauncherName := IniFile.ReadString(INI_SECTION_DIV, INI_LAUNCHER, LAUNCHER_EXE_NAME);
    //
    FProtocol := 'TCPIP';
    //
    IniFile.ReadSectionValues(INI_SECTION_INTERDIT, FNoAllowedNames);
    for i  := 0 to FNoAllowedNames.Count - 1 do
    begin
      p := Pos('=', FNoAllowedNames[i]);
      FNoAllowedNames[i] := Copy(FNoAllowedNames[i], p + 1, Length(FNoAllowedNames[i]) - p);
    end;
    // Ajout des prédéfinis
    FNoAllowedNames.Insert(0, INTERDIT1);
    FNoAllowedNames.Insert(1, INTERDIT2);
    FNoAllowedNames.Insert(2, INTERDIT3);
    FNoAllowedNames.Insert(3, INTERDIT4);
    FNoAllowedNames.Insert(4, INTERDIT5);
  finally
    IniFile.Free;
  end;
end;

function SRepareBase: TRepareBase;
begin
  if TRepareBase.RepareBase = nil then
    TRepareBase.RepareBase := TRepareBase.Create;
  Result := TRepareBase.RepareBase;
end;

initialization

finalization
  TRepareBase.RepareBase.Free;

end.
