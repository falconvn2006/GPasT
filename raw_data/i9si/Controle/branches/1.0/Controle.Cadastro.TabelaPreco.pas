unit Controle.Cadastro.TabelaPreco;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Controle.Cadastro, uniMultiItem, uniComboBox,
  uniDBComboBox, uniEdit, uniDBEdit,  ACBrBase, ACBrSocket,
  ACBrCEP, Data.DB, Datasnap.DBClient, Datasnap.Provider, Data.Win.ADODB,
  uniGUIBaseClasses, uniImageList, uniBitBtn, uniSpeedButton, uniLabel,
  uniButton, uniPanel, uniSweetAlert;

type
  TControleCadastroTabelaPreco = class(TControleCadastro)
    UniDBEdit1: TUniDBEdit;
    UniDBComboBox1: TUniDBComboBox;
    UniLabel1: TUniLabel;
    UniLabel2: TUniLabel;
    UniLabel3: TUniLabel;
    CdsCadastroID: TFloatField;
    CdsCadastroDESCRICAO: TWideStringField;
    CdsCadastroFATOR: TWideStringField;
    CdsCadastroVALOR: TFloatField;
    QryCadastroID: TFloatField;
    QryCadastroDESCRICAO: TWideStringField;
    QryCadastroFATOR: TWideStringField;
    QryCadastroVALOR: TFloatField;
    UniDBNumberEdit1: TUniDBNumberEdit;
  private
    { Private declarations }
  public
    { Public declarations }
    function Abrir(Id: Integer): Boolean; override;
    function Salvar: Boolean; override;
    function Novo: Boolean; override;
    function Editar(Id: Integer): Boolean; override;
    function Descartar: Boolean; override;
  end;

function ControleCadastroTabelaPreco: TControleCadastroTabelaPreco;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication, Controle.Funcoes;

function ControleCadastroTabelaPreco: TControleCadastroTabelaPreco;
begin
  Result := TControleCadastroTabelaPreco(ControleMainModule.GetFormInstance(TControleCadastroTabelaPreco));
end;

function TControleCadastroTabelaPreco.Abrir(Id: Integer): Boolean;
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

function TControleCadastroTabelaPreco.Editar(Id: Integer): Boolean;
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

function TControleCadastroTabelaPreco.Descartar: Boolean;
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


function TControleCadastroTabelaPreco.Novo(): Boolean;
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


function TControleCadastroTabelaPreco.Salvar: Boolean;
begin
  inherited;

  Result := False;

  if CdsCadastro.State in [dsInsert, dsEdit] then
  begin
    // Confirma os dados
    CdsCadastro.Post;
  end;

  // Pega o id do registro
  CadastroId := CdsCadastro.FieldByName('id').AsInteger;

  with ControleMainModule do
  begin
    // Inicia a transação
    ADOConnection.BeginTrans;

    // Passo Unico - Salva os dados da cidade
    QryAx1.Parameters.Clear;
    QryAx1.SQL.Clear;

    if CadastroId = 0 then
    begin
      // Gera um novo id para a tabela tipo_titulo
      CadastroId := GeraId('tabela_preco');
      // Insert
      QryAx1.SQL.Add('INSERT INTO tabela_preco (');
      QryAx1.SQL.Add('       id,');
      QryAx1.SQL.Add('       descricao,');
      QryAx1.SQL.Add('       fator,');
      QryAx1.SQL.Add('       valor)');
      QryAx1.SQL.Add('VALUES (');
      QryAx1.SQL.Add('       :id,');
      QryAx1.SQL.Add('       :descricao,');
      QryAx1.SQL.Add('       :fator,');
      QryAx1.SQL.Add('       :valor)');
    end
    else
    begin
      // Update
      QryAx1.SQL.Add('UPDATE tabela_preco SET');
      QryAx1.SQL.Add('       descricao      = :descricao,');
      QryAx1.SQL.Add('       fator          = :fator,');
      QryAx1.SQL.Add('       valor          = :valor');
      QryAx1.SQL.Add(' WHERE id             = :id');
     end;

    QryAx1.Parameters.ParamByName('id').Value          := CadastroId;
    QryAx1.Parameters.ParamByName('descricao').Value   := CdsCadastro.FieldByName('descricao').AsString;
    QryAx1.Parameters.ParamByName('fator').Value       := copy(CdsCadastro.FieldByName('fator').AsString,1,1);
    QryAx1.Parameters.ParamByName('valor').Value       := CdsCadastro.FieldByName('valor').AsFloat;

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


end.
