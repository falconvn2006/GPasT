unit server.model.resource.config;

interface

uses
  server.model.resource.interfaces;
type
  TResourceConfig = class
  private
    class var FDatabaseConfig : iDataBaseConfig;
  public
    class constructor Create;
    class function Database : iDataBaseConfig;
  end;
implementation

uses
  server.model.resource.conexao.databaseconfig;

{ TResourceConfig }

class function TResourceConfig.Database: iDataBaseConfig;
begin
  Result := FDatabaseConfig;
end;

class constructor TResourceConfig.Create;
begin
  FDatabaseConfig := TDatabaseConfig.New;
end;

end.
