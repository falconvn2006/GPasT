//
// Created by the DataSnap proxy generator.
// 26/02/2023 16:45:26
// 

unit ClientClassesUnit1;

interface

uses System.JSON, Data.DBXCommon, Data.DBXClient, Data.DBXDataSnap, Data.DBXJSON, Datasnap.DSProxy, System.Classes, System.SysUtils, Data.DB, Data.SqlExpr, Data.DBXDBReaders, Data.DBXCDSReaders, Data.DBXJSONReflect;

type
  TServerMethods1Client = class(TDSAdminClient)
  private
    FInsertCommand: TDBXCommand;
    FUpdateCommand: TDBXCommand;
    FDeleteCommand: TDBXCommand;
    FGerarListaTemporariaCommand: TDBXCommand;
    FCadastramentoEmLoteCommand: TDBXCommand;
    FEnderecoIntegracaoCommand: TDBXCommand;
  public
    constructor Create(ADBXConnection: TDBXConnection); overload;
    constructor Create(ADBXConnection: TDBXConnection; AInstanceOwner: Boolean); overload;
    destructor Destroy; override;
    procedure Insert(flnatureza: Integer; dsdocumento: string; nmprimeiro: string; nmsegundo: string; dscep: string; dtregistro: TDateTime);
    procedure Update(idPessoa: Integer; flnatureza: Integer; dsdocumento: string; nmprimeiro: string; nmsegundo: string; dscep: string; dtregistro: TDateTime);
    procedure Delete(idPessoa: Integer);
    procedure GerarListaTemporaria(sPathFile: string);
    procedure CadastramentoEmLote(sPathFile: string);
    procedure EnderecoIntegracao;
  end;

implementation

procedure TServerMethods1Client.Insert(flnatureza: Integer; dsdocumento: string; nmprimeiro: string; nmsegundo: string; dscep: string; dtregistro: TDateTime);
begin
  if FInsertCommand = nil then
  begin
    FInsertCommand := FDBXConnection.CreateCommand;
    FInsertCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FInsertCommand.Text := 'TServerMethods1.Insert';
    FInsertCommand.Prepare;
  end;
  FInsertCommand.Parameters[0].Value.SetInt32(flnatureza);
  FInsertCommand.Parameters[1].Value.SetWideString(dsdocumento);
  FInsertCommand.Parameters[2].Value.SetWideString(nmprimeiro);
  FInsertCommand.Parameters[3].Value.SetWideString(nmsegundo);
  FInsertCommand.Parameters[4].Value.SetWideString(dscep);
  FInsertCommand.Parameters[5].Value.AsDateTime := dtregistro;
  FInsertCommand.ExecuteUpdate;
end;

procedure TServerMethods1Client.Update(idPessoa: Integer; flnatureza: Integer; dsdocumento: string; nmprimeiro: string; nmsegundo: string; dscep: string; dtregistro: TDateTime);
begin
  if FUpdateCommand = nil then
  begin
    FUpdateCommand := FDBXConnection.CreateCommand;
    FUpdateCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FUpdateCommand.Text := 'TServerMethods1.Update';
    FUpdateCommand.Prepare;
  end;
  FUpdateCommand.Parameters[0].Value.SetInt32(idPessoa);
  FUpdateCommand.Parameters[1].Value.SetInt32(flnatureza);
  FUpdateCommand.Parameters[2].Value.SetWideString(dsdocumento);
  FUpdateCommand.Parameters[3].Value.SetWideString(nmprimeiro);
  FUpdateCommand.Parameters[4].Value.SetWideString(nmsegundo);
  FUpdateCommand.Parameters[5].Value.SetWideString(dscep);
  FUpdateCommand.Parameters[6].Value.AsDateTime := dtregistro;
  FUpdateCommand.ExecuteUpdate;
end;

procedure TServerMethods1Client.Delete(idPessoa: Integer);
begin
  if FDeleteCommand = nil then
  begin
    FDeleteCommand := FDBXConnection.CreateCommand;
    FDeleteCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FDeleteCommand.Text := 'TServerMethods1.Delete';
    FDeleteCommand.Prepare;
  end;
  FDeleteCommand.Parameters[0].Value.SetInt32(idPessoa);
  FDeleteCommand.ExecuteUpdate;
end;

procedure TServerMethods1Client.GerarListaTemporaria(sPathFile: string);
begin
  if FGerarListaTemporariaCommand = nil then
  begin
    FGerarListaTemporariaCommand := FDBXConnection.CreateCommand;
    FGerarListaTemporariaCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FGerarListaTemporariaCommand.Text := 'TServerMethods1.GerarListaTemporaria';
    FGerarListaTemporariaCommand.Prepare;
  end;
  FGerarListaTemporariaCommand.Parameters[0].Value.SetWideString(sPathFile);
  FGerarListaTemporariaCommand.ExecuteUpdate;
end;

procedure TServerMethods1Client.CadastramentoEmLote(sPathFile: string);
begin
  if FCadastramentoEmLoteCommand = nil then
  begin
    FCadastramentoEmLoteCommand := FDBXConnection.CreateCommand;
    FCadastramentoEmLoteCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FCadastramentoEmLoteCommand.Text := 'TServerMethods1.CadastramentoEmLote';
    FCadastramentoEmLoteCommand.Prepare;
  end;
  FCadastramentoEmLoteCommand.Parameters[0].Value.SetWideString(sPathFile);
  FCadastramentoEmLoteCommand.ExecuteUpdate;
end;

procedure TServerMethods1Client.EnderecoIntegracao;
begin
  if FEnderecoIntegracaoCommand = nil then
  begin
    FEnderecoIntegracaoCommand := FDBXConnection.CreateCommand;
    FEnderecoIntegracaoCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FEnderecoIntegracaoCommand.Text := 'TServerMethods1.EnderecoIntegracao';
    FEnderecoIntegracaoCommand.Prepare;
  end;
  FEnderecoIntegracaoCommand.ExecuteUpdate;
end;


constructor TServerMethods1Client.Create(ADBXConnection: TDBXConnection);
begin
  inherited Create(ADBXConnection);
end;


constructor TServerMethods1Client.Create(ADBXConnection: TDBXConnection; AInstanceOwner: Boolean);
begin
  inherited Create(ADBXConnection, AInstanceOwner);
end;


destructor TServerMethods1Client.Destroy;
begin
  FInsertCommand.DisposeOf;
  FUpdateCommand.DisposeOf;
  FDeleteCommand.DisposeOf;
  FGerarListaTemporariaCommand.DisposeOf;
  FCadastramentoEmLoteCommand.DisposeOf;
  FEnderecoIntegracaoCommand.DisposeOf;
  inherited;
end;

end.

