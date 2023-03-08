unit uLaunchAsAdmin;

// Appeler la fonction LaunchAsAdministrator au tout début du DPR,
// si il y a l'unité UneInstance, bien mettre la fonction avant le RunOnlyOne
// LaunchAsAdministrator;
// if not(RunOnlyOne) then
//   exit;
//
// Application.Initialize;
// ...


interface

uses
  SysUtils, Windows, Classes,
  {$IF CompilerVersion > 27}
  Vcl.Forms;
  {$ELSE}
  Forms;
  {$IFEND}
type
  PUnitInfo = ^TUnitInfo;

  TUnitInfo = record
    UnitName: string;
    Found: PBoolean;
  end;

procedure HasUnitProc(const Name: string; NameType: TNameType; Flags: Byte; Param: Pointer);
function LaunchAsAdministrator: boolean;
function IsUnitCompiledIn(Module: HMODULE; const UnitName: string): boolean;

implementation

uses
  IniFiles, Registry, ShellAPI;

function LaunchAsAdministrator: boolean;
var
  reg: TRegistry;
  launchAsAdmin: string;
  i: integer;
  isRestartApplication: boolean;
  vParamList: String;
begin
  Result := False;
  isRestartApplication := False;

  // pour savoir si c'est un restart, on cherche le paramètre
  if ParamCount() > 0 then
  begin
    for i := 1 to ParamCount() do
    begin
      if UpperCase(ParamStr(i)) = 'RESTART' then
        isRestartApplication := True;

      vParamList := vParamList + ParamStr(i) + ' ';
    end;
  end;

  // on ne fait les tests que si on est pas en mode administrateur
  if not isRestartApplication then
  begin
    // lecture de la clé pour lancer en mode administrateur
    reg := TRegistry.Create(KEY_READ);
    try
      reg.RootKey := HKEY_CURRENT_USER;
      reg.OpenKey('Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers', False);

      launchAsAdmin := reg.ReadString(application.ExeName);
    finally
      reg.closekey;
      reg.Free;
    end;

    // si la clé n'existe pas, on la créé, en cas de succès, on redémarre le programme
    if launchAsAdmin = '' then
    begin
      try
        reg := TRegistry.Create(KEY_WRITE);
        try
          reg.RootKey := HKEY_CURRENT_USER;
          reg.OpenKey('Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers', True);
          reg.WriteString(application.ExeName, 'RUNASADMIN');
        finally
          reg.closekey;
          reg.Free;
        end;


        // la clé est écrite, on redémarre le programme
        {$IF CompilerVersion > 27}
        ShellExecute(0, 'Open', PWideChar(application.ExeName),  PWideChar(vParamList + 'RESTART'), Nil, SW_SHOWDEFAULT);
        {$ELSE}
        ShellExecute(0, 'Open', PChar(application.ExeName), PChar(vParamList + 'RESTART'), Nil, SW_SHOWDEFAULT);
        {$IFEND}


        application.Terminate
      except
        //application.MessageBox('Les droits Administrateur sont obligatoires pour modifier les registres', 'Attention', Mb_Ok);
      end;
    end;
  end
  else
  begin
    if IsUnitCompiledIn(HInstance, 'UneInstance') then
      Sleep(10000);
  end;
end;

procedure HasUnitProc(const Name: string; NameType: TNameType; Flags: Byte; Param: Pointer);
begin
  case NameType of
    ntContainsUnit:
      with PUnitInfo(Param)^ do
        if SameText(Name, UnitName) then
          Found^ := True;
  end;
end;

function IsUnitCompiledIn(Module: HMODULE; const UnitName: string): boolean;
var
  Info: TUnitInfo;
  Flags: integer;
begin
  Result := False;
  Info.UnitName := UnitName;
  Info.Found := @Result;
  GetPackageInfo(Module, @Info, Flags, HasUnitProc);
end;

end.
