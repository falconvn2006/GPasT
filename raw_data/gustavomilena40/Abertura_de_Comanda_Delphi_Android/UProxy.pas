//
// Created by the DataSnap proxy generator.
// 30/09/2022 09:05:54
//

unit UProxy;

interface

uses System.JSON, Data.DBXCommon, Data.DBXClient, Data.DBXDataSnap, Data.DBXJSON,
Datasnap.DSProxy, System.Classes, System.SysUtils, Data.DB, Data.SqlExpr,
Data.DBXDBReaders, Data.DBXCDSReaders, Data.DBXJSONReflect;

type
  TDSServerModule_bancoClient = class(TDSAdminClient)
  private
    FDSServerModuleCreateCommand: TDBXCommand;
    FparametroCommand: TDBXCommand;
    FEchoStringCommand: TDBXCommand;
    FReverseStringCommand: TDBXCommand;
    FsqlgenericoCommand: TDBXCommand;
    FsqlTBCLICommand: TDBXCommand;
  public
    constructor Create(ADBXConnection: TDBXConnection); overload;
    constructor Create(ADBXConnection: TDBXConnection; AInstanceOwner: Boolean); overload;
    destructor Destroy; override;
    procedure DSServerModuleCreate(Sender: TObject);
    function parametro(sParametro: string; sDefault: string): string;
    function EchoString(Value: string): string;
    function ReverseString(Value: string): string;
    procedure sqlgenerico(sqlnovo: string; tipo: string = 'C');
    procedure sqlTBCLI(sqlnovo: string);
  end;

implementation

procedure TDSServerModule_bancoClient.DSServerModuleCreate(Sender: TObject);
begin
  if FDSServerModuleCreateCommand = nil then
  begin
    FDSServerModuleCreateCommand := FDBXConnection.CreateCommand;
    FDSServerModuleCreateCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FDSServerModuleCreateCommand.Text := 'TDSServerModule_banco.DSServerModuleCreate';
    FDSServerModuleCreateCommand.Prepare;
  end;
  if not Assigned(Sender) then
    FDSServerModuleCreateCommand.Parameters[0].Value.SetNull
  else
  begin
    FMarshal := TDBXClientCommand(FDSServerModuleCreateCommand.Parameters[0].ConnectionHandler).GetJSONMarshaler;
    try
      FDSServerModuleCreateCommand.Parameters[0].Value.SetJSONValue(FMarshal.Marshal(Sender), True);
      if FInstanceOwner then
        Sender.Free
    finally
      FreeAndNil(FMarshal)
    end
    end;
  FDSServerModuleCreateCommand.ExecuteUpdate;
end;

function TDSServerModule_bancoClient.parametro(sParametro: string; sDefault: string): string;
begin
  if FparametroCommand = nil then
  begin
    FparametroCommand := FDBXConnection.CreateCommand;
    FparametroCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FparametroCommand.Text := 'TDSServerModule_banco.parametro';
    FparametroCommand.Prepare;
  end;
  FparametroCommand.Parameters[0].Value.SetWideString(sParametro);
  FparametroCommand.Parameters[1].Value.SetWideString(sDefault);
  FparametroCommand.ExecuteUpdate;
  Result := FparametroCommand.Parameters[2].Value.GetWideString;
end;

function TDSServerModule_bancoClient.EchoString(Value: string): string;
begin
  if FEchoStringCommand = nil then
  begin
    FEchoStringCommand := FDBXConnection.CreateCommand;
    FEchoStringCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FEchoStringCommand.Text := 'TDSServerModule_banco.EchoString';
    FEchoStringCommand.Prepare;
  end;
  FEchoStringCommand.Parameters[0].Value.SetWideString(Value);
  FEchoStringCommand.ExecuteUpdate;
  Result := FEchoStringCommand.Parameters[1].Value.GetWideString;
end;

function TDSServerModule_bancoClient.ReverseString(Value: string): string;
begin
  if FReverseStringCommand = nil then
  begin
    FReverseStringCommand := FDBXConnection.CreateCommand;
    FReverseStringCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FReverseStringCommand.Text := 'TDSServerModule_banco.ReverseString';
    FReverseStringCommand.Prepare;
  end;
  FReverseStringCommand.Parameters[0].Value.SetWideString(Value);
  FReverseStringCommand.ExecuteUpdate;
  Result := FReverseStringCommand.Parameters[1].Value.GetWideString;
end;

procedure TDSServerModule_bancoClient.sqlgenerico(sqlnovo: string; tipo: string);
begin
  if FsqlgenericoCommand = nil then
  begin
    FsqlgenericoCommand := FDBXConnection.CreateCommand;
    FsqlgenericoCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FsqlgenericoCommand.Text := 'TDSServerModule_banco.sqlgenerico';
    FsqlgenericoCommand.Prepare;
  end;
  FsqlgenericoCommand.Parameters[0].Value.SetWideString(sqlnovo);
  FsqlgenericoCommand.Parameters[1].Value.SetWideString(tipo);
  FsqlgenericoCommand.ExecuteUpdate;
end;

procedure TDSServerModule_bancoClient.sqlTBCLI(sqlnovo: string);
begin
  if FsqlTBCLICommand = nil then
  begin
    FsqlTBCLICommand := FDBXConnection.CreateCommand;
    FsqlTBCLICommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FsqlTBCLICommand.Text := 'TDSServerModule_banco.sqlTBCLI';
    FsqlTBCLICommand.Prepare;
  end;
  FsqlTBCLICommand.Parameters[0].Value.SetWideString(sqlnovo);
  FsqlTBCLICommand.ExecuteUpdate;
end;


constructor TDSServerModule_bancoClient.Create(ADBXConnection: TDBXConnection);
begin
  inherited Create(ADBXConnection);
end;


constructor TDSServerModule_bancoClient.Create(ADBXConnection: TDBXConnection; AInstanceOwner: Boolean);
begin
  inherited Create(ADBXConnection, AInstanceOwner);
end;


destructor TDSServerModule_bancoClient.Destroy;
begin
  FDSServerModuleCreateCommand.DisposeOf;
  FparametroCommand.DisposeOf;
  FEchoStringCommand.DisposeOf;
  FReverseStringCommand.DisposeOf;
  FsqlgenericoCommand.DisposeOf;
  FsqlTBCLICommand.DisposeOf;
  inherited;
end;

end.

