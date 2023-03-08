unit Controle.Cadastro.ContaBancaria;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Controle.Cadastro, ACBrBase, ACBrSocket, ACBrCEP,
  Data.DB, Datasnap.DBClient, Datasnap.Provider, Data.Win.ADODB,
  uniGUIBaseClasses, uniImageList, uniBitBtn, uniSpeedButton, uniLabel,
  uniButton, uniPanel, uniMultiItem, uniComboBox, uniDBComboBox,
  uniDBLookupComboBox, uniEdit, uniDBEdit, uniSweetAlert;

type
  TControleCadastroContaBancaria = class(TControleCadastro)
    UniLabel1: TUniLabel;
    UniLabel2: TUniLabel;
    DBLComboBanco: TUniDBLookupComboBox;
    DscBanco: TDataSource;
    CdsBanco: TClientDataSet;
    DspBanco: TDataSetProvider;
    QryBanco: TADOQuery;
    CdsBancoID: TFloatField;
    CdsBancoNOME: TWideStringField;
    CdsCadastroID: TFloatField;
    CdsCadastroBANCO_ID: TFloatField;
    CdsCadastroGERENCIANET_CLIENT_ID: TWideStringField;
    CdsCadastroGERENCIANET_CLIENT_SECRET: TWideStringField;
    UniLabel3: TUniLabel;
    DbGerenciaNetClientID: TUniDBEdit;
    DbGerenciaNetClientSecret: TUniDBEdit;
    UniLabel4: TUniLabel;
    UniLabel5: TUniLabel;
    UniDBComboAmbiente: TUniDBComboBox;
    DBEdtDescricao: TUniDBEdit;
    CdsCadastroDESCRICAO: TWideStringField;
    QryCadastroID: TFloatField;
    QryCadastroDESCRICAO: TWideStringField;
    QryCadastroBANCO_ID: TFloatField;
    QryCadastroGERENCIANET_CLIENT_ID: TWideStringField;
    QryCadastroGERENCIANET_CLIENT_SECRET: TWideStringField;
    QryCadastroGERENCIANET_TIPOAMBIENTE: TWideStringField;
    CdsCadastroGERENCIANET_TIPOAMBIENTE: TWideStringField;
    procedure UniFormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function Abrir(Id: Integer): Boolean; override;
    function Novo(): Boolean; override;
    function Editar(Id: Integer): Boolean; override;
    function Salvar: Boolean; override;
    function Descartar: Boolean; override;
  end;

function ControleCadastroContaBancaria: TControleCadastroContaBancaria;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication, Controle.Main, Controle.Funcoes;

function ControleCadastroContaBancaria: TControleCadastroContaBancaria;
begin
  Result := TControleCadastroContaBancaria(ControleMainModule.GetFormInstance(TControleCadastroContaBancaria));
end;

function TControleCadastroContaBancaria.Abrir(Id: Integer): Boolean;
begin
  Result := False;

  // Abre o registro
  CdsCadastro.Close;
  QryCadastro.Parameters.ParamByName('id').Value := Id;
  CdsCadastro.Open;

  // Se algum registro foi solicitado, deve parar se não encontrar
  if (Id > 0) and CdsCadastro.IsEmpty then
    Exit;

  // Bloqueia o registro para edição
  DscCadastro.AutoEdit := False;

  Result := True;
end;

function TControleCadastroContaBancaria.Descartar: Boolean;
var
  Fechar: Boolean;
begin
  inherited;

  Fechar := False;

  // Se o formulário foi aberto para inclusão, deve ser fechado ao
  // clicar em Descartar.
  if CdsCadastro.IsEmpty or (CdsCadastro.FieldByName('id').AsInteger = 0) then
    Fechar := True;

  // Descartar a alterações
  CdsCadastro.Cancel;

  if Fechar then
    // Fecha o cadastro
    Close;

  Result := True;
end;

function TControleCadastroContaBancaria.Editar(Id: Integer): Boolean;
begin

  Result := False;

  // Pega o id do registro aberto se não tiver sido passado
  // como parâmtro
  if Id = 0 then
    Id := CdsCadastro.FieldByName('id').AsInteger;

  // Tenta abrir o registro
  if Abrir(Id) then
  // Libera o registro para edição
    CdsCadastro.Edit;


  Result := True;
end;

function TControleCadastroContaBancaria.Novo(): Boolean;
begin
  Result := False;

  // Tenta abrir sem dados
  if Abrir(0) then
  begin
    // Libera o registro para edição
    DscCadastro.AutoEdit := True;

    // Adiciona um novo registro em branco
    CdsCadastro.Append;

    Result := True;
  end;
end;

function TControleCadastroContaBancaria.Salvar: Boolean;
begin
  inherited;

  Result := False;

  with ControleMainModule do
  begin
    if CdsCadastro.State in [dsInsert, dsEdit] then
    begin
      // Verifica a banco
      if Trim(DBLComboBanco.Text) = '' then
      begin
        ControleMainModule.MensageiroSweetAlerta('Atenção','É necessário informar o banco.');
        DBLComboBanco.SetFocus;
        Exit;
      end;

      // Verifica a banco
      if Trim(DBEdtDescricao.Text) = '' then
      begin
        ControleMainModule.MensageiroSweetAlerta('Atenção','É necessário informar a descrição.');
        DBEdtDescricao.SetFocus;
        Exit;
      end;

      // Verifica a banco
      if Trim(DbGerenciaNetClientID.Text) = '' then
      begin
        ControleMainModule.MensageiroSweetAlerta('Atenção','É necessário informar client_id do gerencianet');
        DbGerenciaNetClientID.SetFocus;
        Exit;
      end;

      // Verifica a banco
      if Trim(DbGerenciaNetClientSecret.Text) = '' then
      begin
        ControleMainModule.MensageiroSweetAlerta('Atenção','É necessário informar client secret do gerencianet.');
        DbGerenciaNetClientSecret.SetFocus;
        Exit;
      end;

      // Verifica a banco
      if Trim(UniDBComboAmbiente.Text) = '' then
      begin
        ControleMainModule.MensageiroSweetAlerta('Atenção','É necessário informar tipo de ambiente.');
        UniDBComboAmbiente.SetFocus;
        Exit;
      end;

      // Confirma os dados
      CdsCadastro.Post;
    end;

    // Pega o id do registro
    CadastroId := CdsCadastro.FieldByName('id').AsInteger;
  end;

  with ControleMainModule do
  begin
    // Inicia a transação
    ADOConnection.BeginTrans;

    // Passo Unico - Salva os dados da cidade
    QryAx1.Parameters.Clear;
    QryAx1.SQL.Clear;

    if CadastroId = 0 then
    begin
      // Gera um novo id para a tabela conta_bancaria
      CadastroId := GeraId('conta_bancaria');
      // Insert
      QryAx1.SQL.Add('INSERT INTO conta_bancaria (');
      QryAx1.SQL.Add('       id,');
      QryAx1.SQL.Add('       descricao,');
      QryAx1.SQL.Add('       banco_id,');
      QryAx1.SQL.Add('       gerencianet_client_id,');
      QryAx1.SQL.Add('       gerencianet_client_secret,');
      QryAx1.SQL.Add('       gerencianet_tipoambiente)');
      QryAx1.SQL.Add('VALUES (');
      QryAx1.SQL.Add('       :id,');
      QryAx1.SQL.Add('       :descricao,');
      QryAx1.SQL.Add('       :banco_id,');
      QryAx1.SQL.Add('       :gerencianet_client_id,');
      QryAx1.SQL.Add('       :gerencianet_client_secret,');
      QryAx1.SQL.Add('       :gerencianet_tipoambiente)');
    end
    else
    begin
      // Update
      QryAx1.SQL.Add('UPDATE conta_bancaria SET');
      QryAx1.SQL.Add('       descricao      = :descricao,');
      QryAx1.SQL.Add('       banco_id      = :banco_id,');
      QryAx1.SQL.Add('       gerencianet_client_id      = :gerencianet_client_id,');
      QryAx1.SQL.Add('       gerencianet_client_secret      = :gerencianet_client_secret,');
      QryAx1.SQL.Add('       gerencianet_tipoambiente      = :gerencianet_tipoambiente');
      QryAx1.SQL.Add(' WHERE id          = :id');
    end;

    QryAx1.Parameters.ParamByName('id').Value                            := CadastroId;
    QryAx1.Parameters.ParamByName('descricao').Value                     := CdsCadastro.FieldByName('descricao').AsString;
    QryAx1.Parameters.ParamByName('banco_id').Value                      := CdsCadastro.FieldByName('banco_id').AsString;
    QryAx1.Parameters.ParamByName('gerencianet_client_id').Value         := CdsCadastro.FieldByName('gerencianet_client_id').AsString;
    QryAx1.Parameters.ParamByName('gerencianet_client_secret').Value     := CdsCadastro.FieldByName('gerencianet_client_secret').AsString;
    QryAx1.Parameters.ParamByName('gerencianet_tipoambiente').Value      := copy(CdsCadastro.FieldByName('gerencianet_tipoambiente').AsString,1,1);

    try
      // Tenta salvar os dados
      QryAx1.ExecSQL;
    except
      on E: Exception do
      begin
        // Descarta a transação
        ADOConnection.RollbackTrans;
        ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));
        CdsCadastro.Edit;

        Exit;
      end;
    end;

    // Confirma a transação
    ADOConnection.CommitTrans;

    // Recarrega o registro
    Abrir(CadastroId);
    Result := True;
  end;
end;

procedure TControleCadastroContaBancaria.UniFormCreate(Sender: TObject);
begin
  inherited;
  // Abre as tabelas
  CdsBanco.Open;
end;

end.
