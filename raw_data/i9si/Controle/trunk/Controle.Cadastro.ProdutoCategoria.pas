unit Controle.Cadastro.ProdutoCategoria;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Controle.Cadastro, 
  ACBrBase, ACBrSocket, ACBrCEP, Data.DB, Datasnap.DBClient, Datasnap.Provider,
  Data.Win.ADODB, uniGUIBaseClasses, uniGUIClasses, uniImageList, uniBitBtn,
  uniSpeedButton, uniLabel, uniButton, uniPanel, uniEdit, uniDBEdit,
  uniMultiItem, uniComboBox, uniDBComboBox, uniDBLookupComboBox, uniSweetAlert;

type
  TControleCadastroProdutoCategoria = class(TControleCadastro)
    LabelCpfCnpj: TUniLabel;
    DBEdtDescricaoCategoria: TUniDBEdit;
    QryCadastroID: TFloatField;
    QryCadastroDESCRICAO_CATEGORIA_REC: TWideStringField;
    QryCadastroPRODUTO_CATEGORIA_ID: TFloatField;
    QryCadastroORDEM: TFloatField;
    QryCadastroDESCRICAO_CATEGORIA: TWideStringField;
    CdsCadastroID: TFloatField;
    CdsCadastroDESCRICAO_CATEGORIA_REC: TWideStringField;
    CdsCadastroPRODUTO_CATEGORIA_ID: TFloatField;
    CdsCadastroORDEM: TFloatField;
    CdsCadastroDESCRICAO_CATEGORIA: TWideStringField;
  private
    { Private declarations }
  public
    { Public declarations }
    function Abrir(Id: Integer): Boolean; override;
    function NovoTreeView(Id: Integer = 0): Boolean; override;
    function Editar(Id: Integer): Boolean; override;
    function Salvar: Boolean; override;
    function Descartar: Boolean; override;
  end;

  function ControleCadastroProdutoCategoria: TControleCadastroProdutoCategoria;

implementation

{$R *.dfm}

uses
  Controle.Main.Module;

function ControleCadastroProdutoCategoria: TControleCadastroProdutoCategoria;
begin
  Result := TControleCadastroProdutoCategoria(ControleMainModule.GetFormInstance(TControleCadastroProdutoCategoria));
end;

{ TControleCadastroProdutoCategoria }

function TControleCadastroProdutoCategoria.Abrir(Id: Integer): Boolean;
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

function TControleCadastroProdutoCategoria.Descartar: Boolean;
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

function TControleCadastroProdutoCategoria.Editar(Id: Integer): Boolean;
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

function TControleCadastroProdutoCategoria.NovoTreeView(Id: Integer): Boolean;
begin
  Result := False;

  // Tenta abrir sem dados
  if Abrir(0) then
  begin
    // Libera o registro para edição
    DscCadastro.AutoEdit := True;

    // Adiciona um novo registro em branco
    CdsCadastro.Append;
    CdsCadastroPRODUTO_CATEGORIA_ID.AsInteger := Id;

    Result := True;
  end;
end;

function TControleCadastroProdutoCategoria.Salvar: Boolean;
begin
  inherited;

  Result := False;

  with ControleMainModule do
  begin
    if CdsCadastro.State in [dsInsert, dsEdit] then
    begin
      // Verifica a VARIAVEL01
      if Trim(DBEdtDescricaoCategoria.Text) = '' then
      begin
        MessageDlg('É necessário informar a descrição da categoria.'^M''+ 'Dados incompletos', mtWarning, [mbOK]);
        DBEdtDescricaoCategoria.SetFocus;
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
      // Gera um novo id para a tabela produto_categoria
      CadastroId := GeraId('produto_categoria');
      // Insert
      QryAx1.SQL.Add('INSERT INTO produto_categoria (');
      QryAx1.SQL.Add('       id,');
      QryAx1.SQL.Add('       descricao,');
      QryAx1.SQL.Add('       produto_categoria_id,');
      QryAx1.SQL.Add('       ordem)');
      QryAx1.SQL.Add('VALUES (');
      QryAx1.SQL.Add('       :id,');
      QryAx1.SQL.Add('       :descricao,');
      QryAx1.SQL.Add('       :produto_categoria_id,');
      QryAx1.SQL.Add('       :ordem)');
    end
    else
    begin
      // Update
      QryAx1.SQL.Add('UPDATE produto_categoria SET');
      QryAx1.SQL.Add('       descricao      = :descricao,');
      QryAx1.SQL.Add('       produto_categoria_id      = :produto_categoria_id,');
      QryAx1.SQL.Add('       ordem      = :ordem');
      QryAx1.SQL.Add(' WHERE id          = :id');
     end;

    QryAx1.Parameters.ParamByName('id').Value          := CadastroId;
    QryAx1.Parameters.ParamByName('descricao').Value       := CdsCadastro.FieldByName('descricao_categoria_rec').AsString;
    if CdsCadastro.FieldByName('produto_categoria_id').AsString = '0' then
      QryAx1.Parameters.ParamByName('produto_categoria_id').Value := CadastroId
    else
      QryAx1.Parameters.ParamByName('produto_categoria_id').Value := CdsCadastro.FieldByName('produto_categoria_id').AsInteger;
    QryAx1.Parameters.ParamByName('ordem').Value       := CdsCadastro.FieldByName('ordem').AsString;

    try
      // Tenta salvar os dados
      QryAx1.ExecSQL;
    except
      on E: Exception do
      begin
        // Descarta a transação
        ADOConnection.RollbackTrans;
        ControleMainModule.MensageiroSweetAlerta('Atenção','Não foi possível salvar os dados alterados. ' + e.Message);
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
