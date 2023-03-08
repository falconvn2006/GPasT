unit Controle.Cadastro.Cheque.Destino;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Controle.Cadastro,  ACBrBase,
  ACBrSocket, ACBrCEP, Data.DB, Datasnap.DBClient, Datasnap.Provider,
  Data.Win.ADODB, uniGUIBaseClasses, uniImageList, uniBitBtn, uniSpeedButton,
  uniLabel, uniButton, uniPanel, uniEdit, uniDBEdit, uniSweetAlert;

type
  TControleCadastroChequeDestino = class(TControleCadastro)
    LabelNomeRazao: TUniLabel;
    DBEdtNome: TUniDBEdit;
    QryCadastroID: TFloatField;
    QryCadastroDESCRICAO: TWideStringField;
    CdsCadastroID: TFloatField;
    CdsCadastroDESCRICAO: TWideStringField;
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

function ControleCadastroChequeDestino: TControleCadastroChequeDestino;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication, Controle.Funcoes;

function ControleCadastroChequeDestino: TControleCadastroChequeDestino;
begin
  Result := TControleCadastroChequeDestino(ControleMainModule.GetFormInstance(TControleCadastroChequeDestino));
end;

function TControleCadastroChequeDestino.Abrir(Id: Integer): Boolean;
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

function TControleCadastroChequeDestino.Descartar: Boolean;
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

function TControleCadastroChequeDestino.Editar(Id: Integer): Boolean;
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

function TControleCadastroChequeDestino.Novo(): Boolean;
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

function TControleCadastroChequeDestino.Salvar: Boolean;
var
  Erro: string;
begin
  inherited;

  Result := False;
  Erro := '';

  if CdsCadastro.State in [dsInsert, dsEdit] then
  begin
    // Verifica o nome da pessoa
    if DBEdtNome.Text = '' then
    begin
      ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar a descrição do destino.');

      DBEdtNome.SetFocus;
      Exit;
    end;

    // Confirma os dados
    CdsCadastro.Post;
  end;

  // Pega os ids do registro
  CadastroId := CdsCadastro.FieldByName('id').AsInteger;

  with ControleMainModule do
  begin
    // Inicia a transação
    ADOConnection.BeginTrans;

    // Passo 1 - Salva os dados da pessoa
    QryAx1.Parameters.Clear;
    QryAx1.SQL.Clear;

    if CadastroId = 0 then
    begin
      // Gera um novo id para a pessoa
      CadastroId := GeraId('cheque_destino');

      // Insert
      QryAx1.SQL.Add('INSERT INTO cheque_destino (');
      QryAx1.SQL.Add('       id,');
      QryAx1.SQL.Add('       descricao)');
      QryAx1.SQL.Add('VALUES (');
      QryAx1.SQL.Add('       :id,');
      QryAx1.SQL.Add('       :descricao)');
    end
    else
    begin
      // Update
      QryAx1.SQL.Add('UPDATE cheque_destino');
      QryAx1.SQL.Add('   SET descricao  = :descricao');
      QryAx1.SQL.Add(' WHERE id            = :id');
    end;

    QryAx1.Parameters.ParamByName('id').Value            := CadastroId;
    QryAx1.Parameters.ParamByName('descricao').Value     := CdsCadastro.FieldByName('descricao').AsString;

    try
      // Tenta salvar os dados
      QryAx1.ExecSQL;
    except
      on E: Exception do
      begin
        Erro := ControleFuncoes.RetiraAspaSimples(E.Message);
        ControleMainModule.MensageiroSweetAlerta('Atenção', Erro);
      end;
    end;
  end;

  if Erro <> '' then
  begin
    // Descarta a transação
    ControleMainModule.ADOConnection.RollbackTrans;
    ControleMainModule.MensageiroSweetAlerta('Atenção', Erro);
    CdsCadastro.Edit;
  end
  else
  begin
    // Confirma a transação
    ControleMainModule.ADOConnection.CommitTrans;
    Abrir(CadastroId);
    Result := True;
  end;
end;

end.
