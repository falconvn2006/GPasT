unit Controle.Cadastro.TituloCategoria;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Controle.Cadastro, uniMultiItem,
  uniComboBox, uniDBComboBox, uniGUIClasses, uniEdit, uniDBEdit,
   ACBrBase, ACBrSocket, ACBrCEP, Data.DB, Datasnap.DBClient,
  Datasnap.Provider, Data.Win.ADODB, uniGUIBaseClasses, uniImageList, uniBitBtn,
  uniSpeedButton, uniLabel, uniButton, uniPanel, uniSweetAlert;

type
  TControleCadastroTituloCategoria = class(TControleCadastro)
    UniLabel1: TUniLabel;
    DBEdtNome: TUniDBEdit;
    UniLabel2: TUniLabel;
    UniDBComboBox1: TUniDBComboBox;
    CdsCadastroID: TFloatField;
    CdsCadastroDESCRICAO: TWideStringField;
    CdsCadastroTIPO_TITULO: TWideStringField;
    QryCadastroID: TFloatField;
    QryCadastroDESCRICAO: TWideStringField;
    QryCadastroTIPO_TITULO: TWideStringField;
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

  function ControleCadastroTituloCategoria: TControleCadastroTituloCategoria;

implementation

uses
  Controle.Main.Module, Controle.Funcoes;

{$R *.dfm}


function ControleCadastroTituloCategoria: TControleCadastroTituloCategoria;
begin
  Result := TControleCadastroTituloCategoria(ControleMainModule.GetFormInstance(TControleCadastroTituloCategoria));
end;

{ TControleCadastroTipoTitulo }

function TControleCadastroTituloCategoria.Abrir(Id: Integer): Boolean;
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

function TControleCadastroTituloCategoria.Descartar: Boolean;
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

function TControleCadastroTituloCategoria.Editar(Id: Integer): Boolean;
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

function TControleCadastroTituloCategoria.Novo(): Boolean;
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

function TControleCadastroTituloCategoria.Salvar: Boolean;
begin
  inherited;

  Result := False;

  with ControleMainModule do
  begin
    if CdsCadastro.State in [dsInsert, dsEdit] then
    begin
      // Verifica se a descriçao esta preenchida
      if DBEdtNome.Text = '' then
      begin
        ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar a descrição.');

        DBEdtNome.SetFocus;
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
      // Gera um novo id para a tabela tipo_titulo
      CadastroId := GeraId('titulo_categoria');
      // Insert
      QryAx1.SQL.Add('INSERT INTO titulo_categoria (');
      QryAx1.SQL.Add('       id,');
      QryAx1.SQL.Add('       descricao,');
      QryAx1.SQL.Add('       tipo_titulo)');
      QryAx1.SQL.Add('VALUES (');
      QryAx1.SQL.Add('       :id,');
      QryAx1.SQL.Add('       :descricao,');
      QryAx1.SQL.Add('       :tipo_titulo)');
    end
    else
    begin
      // Update
      QryAx1.SQL.Add('UPDATE titulo_categoria SET');
      QryAx1.SQL.Add('       descricao      = :descricao,');
      QryAx1.SQL.Add('       tipo_titulo    = :tipo_titulo');
      QryAx1.SQL.Add(' WHERE id             = :id');
     end;

    QryAx1.Parameters.ParamByName('id').Value          := CadastroId;
    QryAx1.Parameters.ParamByName('descricao').Value   := CdsCadastro.FieldByName('descricao').AsString;
    QryAx1.Parameters.ParamByName('tipo_titulo').Value := copy(CdsCadastro.FieldByName('tipo_titulo').AsString,1,1);

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
