unit server.model.resource.conexao.databaseconfig;

interface

uses
  server.model.resource.interfaces;

Type
  TDatabaseConfig = class(TInterfacedObject, iDatabaseConfig)
  private
    FDriverID : string;
    FDatabase : string;
    FUserName : String;
    FPassword : String;
    FPort : string;
    FServer : String;
  public
    constructor Create;
    destructor Destroy; override;
    class function New : iDataBaseConfig;
    function DriverID(aValue : String) : iDatabaseConfig; overload;
    function DriverID : String; overload;
    function Database(aValue : String) : iDatabaseConfig; overload;
    function Database : String; overload;
    function UserName(aValue : String) : iDatabaseConfig; overload;
    function UserName : String; overload;
    function Password(aValue : String) : iDatabaseConfig; overload;
    function Password : String; overload;
    function Port(aValue : String) : iDatabaseConfig; overload;
    function Port : String; overload;
    function Server(aValue : String) : iDatabaseConfig; overload;
    function Server : String; overload;
  end;

implementation

{ TConfiguracaoTDatabaseConfig }

constructor TDatabaseConfig.Create;
begin

end;

function TDatabaseConfig.Database: String;
begin
  Result := FDatabase;
end;

function TDatabaseConfig.Database(aValue: String): iDatabaseConfig;
begin
  Result := Self;
  FDataBase := aValue;
end;

destructor TDatabaseConfig.Destroy;
begin

  inherited;
end;

function TDatabaseConfig.DriverID: String;
begin
  Result := FDriverID;
end;

function TDatabaseConfig.DriverID(aValue: String): iDatabaseConfig;
begin
  Result := Self;
  FDriverID := aValue;
end;

class function TDatabaseConfig.New : iDatabaseConfig;
begin
  Result := Self.Create;
end;

function TDatabaseConfig.Password: String;
begin
  Result := FPassword;
end;

function TDatabaseConfig.Password(aValue: String): iDatabaseConfig;
begin
  Result := Self;
  FPassword := aValue;
end;

function TDatabaseConfig.Port(aValue: String): iDatabaseConfig;
begin
  Result := Self;
  FPort := aValue;
end;

function TDatabaseConfig.Port: String;
begin
  Result := FPort;
end;

function TDatabaseConfig.Server(aValue: String): iDatabaseConfig;
begin
  Result := Self;
  FServer := aValue;
end;

function TDatabaseConfig.Server: String;
begin
  Result := FServer;
end;

function TDatabaseConfig.UserName(aValue: String): iDatabaseConfig;
begin
  Result := Self;
  FUserName := aValue;
end;

function TDatabaseConfig.UserName: String;
begin
  Result := FUserName;
end;

end.
