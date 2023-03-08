unit Controle.Caixa.Model.Connection;

interface

uses
  Controle.Caixa.Model.Connection.Interfaces,
  Data.DB,
  Firedac.Stan.Intf,
  Firedac.Stan.Option,
  Firedac.Stan.Error,
  Firedac.UI.Intf,
  Firedac.Phys.Intf,
  Firedac.Stan.Def,
  Firedac.Stan.Pool,
  Firedac.Stan.Async,
  Firedac.Phys,
  Firedac.VCLUI.Wait,
  Firedac.Stan.ExprFuncs,
  Firedac.Phys.SQLiteWrapper.Stat,
  Firedac.Phys.SQLiteDef,
  Firedac.Phys.SQLite,
  Firedac.Comp.UI,
  Firedac.Comp.Client,
  System.SysUtils,
  Firedac.Phys.MySQL,
  System.IniFiles;

type
  TModelConnection = class(TInterfacedObject, iConnection)
  private
    FConn: TFDConnection;
    DriverLink: TFDPhysMySQLDriverLink;
    IniFile: TIniFile;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: iConnection;
    function Connection: TFDConnection;
  end;

implementation

{ TModelConnection }

function TModelConnection.Connection: TFDConnection;
begin
  Result := FConn;
end;

constructor TModelConnection.Create;
var
  dll: string;
begin
  FConn := TFDConnection.Create(nil);
  DriverLink := TFDPhysMySQLDriverLink.Create(nil);
  FConn.DriverName := 'MySQL';
  FConn.LoginPrompt := False;
  IniFile := TIniFile.Create(GetCurrentDir + PathDelim + 'config.ini');
  FConn.Params.Database := IniFile.ReadString('DATABASE', 'DBName', '');
  FConn.Params.userName := IniFile.ReadString('DATABASE', 'UserName', '');
  FConn.Params.Password := IniFile.ReadString('DATABASE', 'pass', '');
  dll := GetCurrentDir + PathDelim + IniFile.ReadString('DATABASE', 'Dll', '');
  DriverLink.VendorLib := dll;

  FConn.Connected := True;
end;

destructor TModelConnection.Destroy;
begin
  FreeAndNil(FConn);
  FreeAndNil(DriverLink);
  FreeAndNil(IniFile);
  inherited;
end;

class function TModelConnection.New: iConnection;
begin
  Result := Self.Create;
end;

end.
