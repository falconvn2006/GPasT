unit Controle.Cadastro.CondicoesPagamento;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Controle.Cadastro, ACBrBase, ACBrSocket, ACBrCEP,
  Data.DB, Datasnap.DBClient, Datasnap.Provider, Data.Win.ADODB,
  uniGUIBaseClasses, uniImageList, uniBitBtn, uniSpeedButton, uniLabel,
  uniButton, uniPanel, uniEdit, uniDBEdit, uniMultiItem, uniComboBox,
  uniDBComboBox, uniSweetAlert;

type
  TControleCadastroCondicoesPagamento = class(TControleCadastro)
    UniLabel1: TUniLabel;
    DBEdtNome: TUniDBEdit;
    UniLabel3: TUniLabel;
    UniDBComboBoxAtivo: TUniDBComboBox;
    UniDBComboBoxTipo: TUniDBComboBox;
    UniLabel2: TUniLabel;
    QryCadastroID: TFloatField;
    QryCadastroDESCRICAO: TWideStringField;
    QryCadastroTIPO: TWideStringField;
    QryCadastroATIVO: TWideStringField;
    QryCadastroORDEM_EXIBICAO: TFloatField;
    CdsCadastroID: TFloatField;
    CdsCadastroDESCRICAO: TWideStringField;
    CdsCadastroTIPO: TWideStringField;
    CdsCadastroATIVO: TWideStringField;
    CdsCadastroORDEM_EXIBICAO: TFloatField;
    UniLabel4: TUniLabel;
    UniDBComboBoxOrdem: TUniDBComboBox;
    CdsCadastroMAX_ORDEM: TAggregateField;
    QryMax: TADOQuery;
    CdsMax: TClientDataSet;
    DspMax: TDataSetProvider;
    DscMax: TDataSource;
    CdsMaxORDEM_EXIBICAO: TFloatField;
    UniDBComboBox1: TUniDBComboBox;
    UniLabel5: TUniLabel;
    QryCadastroMOVIMENTA_CAIXA: TWideStringField;
    CdsCadastroMOVIMENTA_CAIXA: TWideStringField;
    procedure UniFormShow(Sender: TObject);
  private
    procedure OrdemDeExibicao;
    { Private declarations }
  public
    { Public declarations }
    function Abrir(Id: Integer): Boolean; override;
    function Novo(): Boolean; override;
    function Editar(Id: Integer): Boolean; override;
    function Salvar: Boolean; override;
    function Descartar: Boolean; override;
  end;

function ControleCadastroCondicoesPagamento: TControleCadastroCondicoesPagamento;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication, Controle.Funcoes, Controle.Consulta;

function ControleCadastroCondicoesPagamento: TControleCadastroCondicoesPagamento;
begin
  Result := TControleCadastroCondicoesPagamento(ControleMainModule.GetFormInstance(TControleCadastroCondicoesPagamento));
end;

{ TControleCadastroTipoTitulo }

function TControleCadastroCondicoesPagamento.Abrir(Id: Integer): Boolean;
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

function TControleCadastroCondicoesPagamento.Descartar: Boolean;
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

function TControleCadastroCondicoesPagamento.Editar(Id: Integer): Boolean;
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

function TControleCadastroCondicoesPagamento.Novo(): Boolean;
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

function TControleCadastroCondicoesPagamento.Salvar: Boolean;
begin
  inherited;

  Result := False;

  with ControleMainModule do
  begin
    if DBEdtNome.Text = '' then
    begin
      MensageiroSweetAlerta('Atenção', 'A descrição é obrigatória.');
      DBEdtNome.SetFocus;
    end;

    if UniDBComboBoxOrdem.Text = '' then
    begin
      MensageiroSweetAlerta('Atenção', 'Escolha a ordem de exibição.');
      UniDBComboBoxOrdem.SetFocus;
    end;

    if UniDBComboBoxTipo.Text = '' then
    begin
      MensageiroSweetAlerta('Atenção', 'Escolha um tipo.');
      UniDBComboBoxTipo.SetFocus;
    end;

    // Pega o id do registro
    CadastroId := CdsCadastro.FieldByName('id').AsInteger;

    // Inicia a transação
    ADOConnection.BeginTrans;

    // Passo Unico - Salva os dados da cidade
    QryAx1.Parameters.Clear;
    QryAx1.SQL.Clear;

    if CadastroId = 0 then
    begin
      // Gera um novo id para a tabela tipo_titulo
      CadastroId := GeraId('condicoes_pagamento');
      // Insert
      QryAx1.SQL.Add('INSERT INTO condicoes_pagamento (');
      QryAx1.SQL.Add('       id,');
      QryAx1.SQL.Add('       descricao,');
      QryAx1.SQL.Add('       tipo,');
      QryAx1.SQL.Add('       ativo,');
      QryAx1.SQL.Add('       movimenta_caixa,');
      QryAx1.SQL.Add('       ordem_exibicao)');
      QryAx1.SQL.Add('VALUES (');
      QryAx1.SQL.Add('       :id,');
      QryAx1.SQL.Add('       :descricao,');
      QryAx1.SQL.Add('       :tipo,');
      QryAx1.SQL.Add('       :ativo,');
      QryAx1.SQL.Add('       :movimenta_caixa,');
      QryAx1.SQL.Add('       :ordem_exibicao)');
    end
    else
    begin
      // Update
      QryAx1.SQL.Add('UPDATE condicoes_pagamento SET');
      QryAx1.SQL.Add('       descricao       = :descricao,');
      QryAx1.SQL.Add('       tipo            = :tipo,');
      QryAx1.SQL.Add('       ativo           = :ativo,');
      QryAx1.SQL.Add('       movimenta_caixa = :movimenta_caixa,');
      QryAx1.SQL.Add('       ordem_exibicao  = :ordem_exibicao');
      QryAx1.SQL.Add(' WHERE id              = :id');
    end;

    QryAx1.Parameters.ParamByName('id').Value              := CadastroId;
    QryAx1.Parameters.ParamByName('descricao').Value       := CdsCadastro.FieldByName('descricao').AsString;
    QryAx1.Parameters.ParamByName('tipo').Value            := copy(CdsCadastro.FieldByName('tipo').AsString,1,1);
    QryAx1.Parameters.ParamByName('ativo').Value           := copy(CdsCadastro.FieldByName('ativo').AsString,1,1);
    QryAx1.Parameters.ParamByName('movimenta_caixa').Value := copy(CdsCadastro.FieldByName('movimenta_caixa').AsString,1,1);
    QryAx1.Parameters.ParamByName('ordem_exibicao').Value  := CdsCadastro.FieldByName('ordem_exibicao').AsString;

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

procedure TControleCadastroCondicoesPagamento.UniFormShow(Sender: TObject);
begin
  inherited;
  OrdemDeExibicao;
end;

procedure TControleCadastroCondicoesPagamento.OrdemDeExibicao;
var
  Qtd,I : Integer;
begin
 CdsMax.Close;
 CdsMax.Open;

 Qtd := CdsMaxORDEM_EXIBICAO.AsInteger;
 Qtd := Qtd + 1;

  for I := 1 to Qtd do
  begin
    UniDBComboBoxOrdem.Items.Add(IntToStr(I));
  end;

end;


end.
