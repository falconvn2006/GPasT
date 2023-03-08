unit server.model.resource.conexao.conexaofiredac;

interface

uses
  server.model.resource.interfaces,
  System.SysUtils,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Phys.PG,
  FireDAC.Phys.PGDef,
  FireDAC.VCLUI.Wait,
  Data.DB,
  FireDAC.Comp.Client;

Type
  TConexaoFiredac = class(TInterfacedObject, iconexao)
  private
    FConfiguracao : iDataBaseConfig;
    FConn : TFDConnection;
  public
    constructor Create(Configuracao : iDatabaseConfig);
    destructor Destroy; override;
    class function New(Configuracao : iDatabaseConfig) : iconexao;
    function Connect : TCustomConnection;
    procedure Disconnect;
    procedure StartTransaction;
    procedure Commit;
    procedure Rollback;
  end;

implementation

{ TConexaoFiredac }

procedure TConexaoFiredac.Commit;
begin
  FConn.Commit;
end;

function TConexaoFiredac.Connect: TCustomConnection;
begin
  try
    FConn.Params.DriverID := FConfiguracao.DriverID;
    FConn.Params.Database := FConfiguracao.Database;
    FConn.Params.UserName := FConfiguracao.UserName;
    FConn.Params.Password := FConfiguracao.Password;
    FConn.Params.Add('Port=' + FConfiguracao.Port);
    FConn.Params.Add('Server=' + FConfiguracao.Server);
    FConn.Connected := true;
    Result := FConn;
  except
    raise Exception.Create('Não foi possível realizar a conexão');
  end;
end;

constructor TConexaoFiredac.Create(Configuracao : iDatabaseConfig);
begin
  FConn := TFDConnection.Create(nil);
  FConn.FetchOptions.Mode := fmAll;
  FConfiguracao := Configuracao;
end;

destructor TConexaoFiredac.Destroy;
begin
  FConn.Connected := false;
  FConn.Free;
  inherited;
end;

procedure TConexaoFiredac.Disconnect;
begin
  FConn.Connected := false;
end;

class function TConexaoFiredac.New (Configuracao : iDatabaseConfig) : iconexao;
begin
  Result := Self.Create(Configuracao);
end;

procedure TConexaoFiredac.Rollback;
begin
  FConn.Rollback;
end;

procedure TConexaoFiredac.StartTransaction;
begin
  FConn.StartTransaction;
end;

end.
