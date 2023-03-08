unit uWSConfig;

interface

uses
  Windows, Classes, SysUtils, IniFiles, Registry;


Const
  cWS              = 'Web service : ';
  cWSStarted       = cWS + 'Started';
  cWSFailed        = cWS + 'Failed';

  // -- Parametres INI
  Sec_Gen              = 'Général';
  Sec_Log              = 'Log';

  Itm_LogOnStart       = 'LogOnStart';   // --> Log au demarrage du Web Service
  Itm_LogException     = 'LogException'; // --> Log sur les exceptions du Web Service
  Itm_Traceur          = 'Traceur';      // --> Log de traçage (utile dans les procedures ou functions)
  Itm_FileNameDB       = 'FileNameDB';   // --> Chemin de la base de données + le fichier .IB
  Itm_InitialDb        = 'InitialDb';    // --> Catalog de la base de données (SQL SERVEUR)
  Itm_LoginDB          = 'LoginDB';      // --> Login de connexion base de données
  Itm_PasswordDB       = 'PasswordDB';   // --> Password de connexion base de données
  Itm_ServicePath      = 'ServicePath';  // --> Chemin du Web Service

Type
  TCustomWSConfig = class(TComponent)
  private
    FServiceName     : String;
    FServicePath     : String;
    FTraceur         : Boolean;
    FLogOnStart      : Boolean;
    FFileNameIni     : String;
    FFileNameDB      : String;
    FLoginDB         : string;
    FPasswordDB      : string;
    FLogException    : Boolean;
    FOptions         : TStringList;
    FInitalDb: string;
  protected
    function GetServiceFileName: String; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetTime: String; virtual;
    procedure Load; virtual;

    { Permet de créer un log conditionné par un permission }
    procedure SaveFile(Const FileName: String; Const ASL: TStringList; Const Allow: Boolean); virtual;

    { Chemin + le nom du fichier ini de config }
    property FileNameIni: String read FFileNameIni;

    { Config generique du Web Service }
    property ServiceName: String read FServiceName write FServiceName;
    property ServicePath: String read FServicePath;
    property ServiceFileName: String read GetServiceFileName;
    property LogOnStart: Boolean read FLogOnStart write FLogOnStart;
    property LogException: Boolean read FLogException write FLogException;
    property Traceur: Boolean read FTraceur write FTraceur;
    property FileNameDB: String read FFileNameDB write FFileNameDB;
    property InitialDb : string read FInitalDb write FInitalDb;
    property LoginDB : string read FLoginDB write FLoginDB;
    property PasswordDB : string read FPasswordDB write FPasswordDB;

    { Regroupe tous les parametres de config du fichier ini <> de la config generique }
    property Options: TStringList read FOptions;
  end;

  TWSConfig = class(TCustomWSConfig);

implementation

function GetModuleName: string;
var
  szFileName: array[0..MAX_PATH] of Char;
begin
  FillChar(szFileName, SizeOf(szFileName), #0);
  GetModuleFileName(hInstance, szFileName, MAX_PATH);
  Result := szFileName;
  if Copy(Result, 1, 4) = '\\?\' then
    Result := Copy(Result, 5, Length(Result));
end;

{ TCustomWSConfig }

constructor TCustomWSConfig.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FOptions      := TStringList.Create;
  FServiceName  := ChangeFileExt(ExtractFileName(GetModuleName), '');
  FServicePath  := ExtractFilePath(GetModuleName);
  FTraceur      := True;
  FLogOnStart   := False;
  FFileNameIni  := '';
  FFileNameDB   := '';
  FLogException := True;
end;

destructor TCustomWSConfig.Destroy;
begin
  FreeAndNil(FOptions);
  inherited Destroy;
end;

function TCustomWSConfig.GetServiceFileName: String;
begin
  Result   := '';
  if (FServiceName <> '') and (FServicePath <> '') then
    Result := FServicePath + FServiceName;
end;

function TCustomWSConfig.GetTime: String;
begin
  Result := '_' + FormatDateTime('hh_nn_ss_zzz', Now);
end;

procedure TCustomWSConfig.Load;
var
  i, j       : integer;
  vIniFile   : TIniFile;
  vSLSec, vSL: TStrings;
  vReg       : TRegistry;
  Buffer: String;
begin
  vReg := TRegistry.Create;
  try

    { ******* Probleme de lecture et ecriture de la Registry lié aux droits ******* }

    { Chargement du chemin du fichier de config du WebService depuis la registry }
    // vReg.RootKey:= HKEY_CURRENT_USER;
    // vReg.OpenKey('\ginkoia\WebService\' + FServiceName, True);
    // if vReg.ValueExists(cKeyPathIni) then
    // begin
    // FServicePath:= vReg.ReadString(cKeyPathIni);
    // if (Trim(FServicePath) <> '') and (FServicePath[Length(FServicePath)] <> '\') then
    // FServicePath:= FServicePath + '\';
    // end
    // else
    // vReg.WriteString(cKeyPathIni, '');

    { ***************************************************************************** }

    { En attendant de trouver la solution des droits de la Registry, les fichiers
      de config des Web Service devront etre dans le repertoire de IIS (c:\windows\system32\inetsrv\) }
    FFileNameIni := ExtractFilePath(ParamStr(0)) + FServiceName + '.ini';

    if not FileExists(FFileNameIni) then
      FFileNameIni := ChangeFileExt(GetModuleName, '.ini');

    if (FileNameIni <> '') and (FileExists(FFileNameIni)) then
      begin
        { Chargement du fichier de config }
        vIniFile := TIniFile.Create(FileNameIni);
        vSLSec   := TStringList.Create;
        vSL      := TStringList.Create;
        FOptions.Clear;
        try
          FServicePath      := vIniFile.ReadString(Sec_Gen, Itm_ServicePath, FServicePath);
          FServicePath      := IncludeTrailingPathDelimiter(FServicePath);
          FileNameDB        := vIniFile.ReadString(Sec_Gen, Itm_FileNameDB, '');
          InitialDb         := vIniFile.ReadString(Sec_Gen, Itm_InitialDb,'');
          LoginDB           := vIniFile.ReadString(Sec_Gen, Itm_LoginDB, 'ginkoia');
          PasswordDB        := vIniFile.ReadString(Sec_Gen, Itm_PasswordDB, 'ginkoia');

          LogOnStart        := vIniFile.ReadBool(Sec_Log, Itm_LogOnStart, LogOnStart);
          LogException      := vIniFile.ReadBool(Sec_Log, Itm_LogException, LogException);
          Traceur           := vIniFile.ReadBool(Sec_Log, Itm_Traceur, Traceur);

          { La property "Options" doit rester generique, c'est la raison pour
            laquelle on charge toutes les keys <> "Sec_Gen" et "Sec_Log" }
          vIniFile.ReadSections(vSLSec);
          for i := 0 to vSLSec.Count - 1 do
            begin
              if (vSLSec.Strings[i] <> Sec_Gen) and (vSLSec.Strings[i] <> Sec_Log) then
                begin
                  vIniFile.ReadSection(vSLSec.Strings[i], vSL);
                  for j:= 0 to vSL.Count -1 do
                    begin
                      Buffer:= vIniFile.ReadString(vSLSec.Strings[i], vSL.Strings[j], '');
                      if Buffer <> '' then
                        FOptions.Append(vSL.Strings[j] + '=' + Buffer);
                    end;
                end;
            end;
        finally
          FreeAndNil(vIniFile);
          FreeAndNil(vSLSec);
          FreeAndNil(vSL);
        end;
      end;
  finally
    FreeAndNil(vReg);
  end;
end;

procedure TCustomWSConfig.SaveFile(Const FileName: String; const ASL: TStringList; Const Allow: Boolean);
begin
  if not Allow then
    Exit;
  if DirectoryExists(ExtractFilePath(FileName)) then
    ASL.SaveToFile(FileName)
  else
    { Permet la creation d'un fichier quand le chemin n'existe pas }
    ASL.SaveToFile('C:\' + ExtractFileName(FileName));
end;

end.
