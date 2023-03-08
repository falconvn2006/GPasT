unit Controle.Cadastro.ProdutoEmbalagem;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Controle.Cadastro, uniEdit, uniDBEdit,
   ACBrBase, ACBrSocket, ACBrCEP, Data.DB, Datasnap.DBClient,
  Datasnap.Provider, Data.Win.ADODB, uniGUIBaseClasses, uniImageList, uniBitBtn,
  uniSpeedButton, uniLabel, uniButton, uniPanel, uniMultiItem, uniComboBox,
  uniDBComboBox, uniSweetAlert;

type
  TControleCadastroProdutoEmbalagem = class(TControleCadastro)
    UniDBEditCodigoEAN: TUniDBEdit;
    UniLabel1: TUniLabel;
    ButtonPesquisaCidadeGeral: TUniSpeedButton;
    UniLabel2: TUniLabel;
    UniDBEdit2: TUniDBEdit;
    UniDBEdit3: TUniDBEdit;
    UniLabel3: TUniLabel;
    UniDBComboBox1: TUniDBComboBox;
    UniLabel4: TUniLabel;
  private
    function Abrir(Id: Integer): Boolean; override;
    function Descartar: Boolean; override;
    function Editar(Id: Integer): Boolean; override;
    function Novo: Boolean; override;
    function Salvar: Boolean; override;
    { Private declarations }
  public
    { Public declarations }
  end;

function ControleCadastroProdutoEmbalagem: TControleCadastroProdutoEmbalagem;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication, Controle.Funcoes;

function ControleCadastroProdutoEmbalagem: TControleCadastroProdutoEmbalagem;
begin
  Result := TControleCadastroProdutoEmbalagem(ControleMainModule.GetFormInstance(TControleCadastroProdutoEmbalagem));
end;


function TControleCadastroProdutoEmbalagem.Abrir(Id: Integer): Boolean;
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

function TControleCadastroProdutoEmbalagem.Descartar: Boolean;
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

function TControleCadastroProdutoEmbalagem.Editar(Id: Integer): Boolean;
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

function TControleCadastroProdutoEmbalagem.Novo(): Boolean;
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

function TControleCadastroProdutoEmbalagem.Salvar: Boolean;
begin
  inherited;

  Result := False;

  with ControleMainModule do
  begin
    if CdsCadastro.State in [dsInsert, dsEdit] then
    begin
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
      // Gera um novo id para a tabela tipo_titulo
      CadastroId := GeraId('produto_embalagem');
      // Insert
      QryAx1.SQL.Add('INSERT INTO produto_embalagem (');
      QryAx1.SQL.Add('       id,');
      QryAx1.SQL.Add('       produto_id,');
      QryAx1.SQL.Add('       unidade_medida_id,');
      QryAx1.SQL.Add('       codigo_ean,');
      QryAx1.SQL.Add('       controla_estoque,');
      QryAx1.SQL.Add('       acrescimo_desconto,');
      QryAx1.SQL.Add('       ativo)');
      QryAx1.SQL.Add('VALUES (');
      QryAx1.SQL.Add('       :id,');
      QryAx1.SQL.Add('       :produto_id,');
      QryAx1.SQL.Add('       :unidade_medida_id,');
      QryAx1.SQL.Add('       :codigo_ean,');
      QryAx1.SQL.Add('       :controla_estoque,');
      QryAx1.SQL.Add('       :acrescimo_desconto,');
      QryAx1.SQL.Add('       :ativo)');
    end
    else
    begin
      // Update
      QryAx1.SQL.Add('UPDATE produto_embalagem SET');
      QryAx1.SQL.Add('       produto_id           = :produto_id,');
      QryAx1.SQL.Add('       unidade_medida_id    = :unidade_medida_id,');
      QryAx1.SQL.Add('       codigo_ean           = :codigo_ean,');
      QryAx1.SQL.Add('       controla_estoque     = :controla_estoque,');
      QryAx1.SQL.Add('       acrescimo_desconto   = :acrescimo_desconto,');
      QryAx1.SQL.Add('       ativo                = :ativo');
      QryAx1.SQL.Add(' WHERE id                   = :id');
     end;

    QryAx1.Parameters.ParamByName('id').Value                   := CadastroId;
    QryAx1.Parameters.ParamByName('produto_id').Value           := CdsCadastro.FieldByName('produto_id').AsString;
    QryAx1.Parameters.ParamByName('unidade_medida_id').Value    := CdsCadastro.FieldByName('unidade_medida_id').AsString;
    QryAx1.Parameters.ParamByName('codigo_ean').Value           := CdsCadastro.FieldByName('codigo_ean').AsString;
    QryAx1.Parameters.ParamByName('controla_estoque').Value     := copy(CdsCadastro.FieldByName('controla_estoque').AsString,1,1);
    QryAx1.Parameters.ParamByName('acrescimo_desconto').Value   := copy(CdsCadastro.FieldByName('acrescimo_desconto').AsString,1,1);
    QryAx1.Parameters.ParamByName('ativo').Value                := copy(CdsCadastro.FieldByName('ativo').AsString,1,1);

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
