unit Controle.Cadastro.Schema;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Controle.Cadastro, uniCheckBox, uniDBCheckBox,
  uniEdit, uniDBEdit, uniLabel, Data.DB, Datasnap.DBClient, Datasnap.Provider,
  Data.Win.ADODB, uniGUIBaseClasses, uniImageList, uniButton, uniPanel,
  ACBrBase, ACBrSocket, ACBrCEP, uniBitBtn, uniSpeedButton, uniSweetAlert;

type
  TControleCadastroSchema = class(TControleCadastro)
    UniLabel1: TUniLabel;
    DBEdtDescricao: TUniDBEdit;
    UniDBCheckBox1: TUniDBCheckBox;
    CdsCadastroID: TFloatField;
    CdsCadastroDESCRICAO: TWideStringField;
    QryCadastroID: TFloatField;
    QryCadastroDESCRICAO: TWideStringField;
    QryCadastroATIVO: TWideStringField;
    CdsCadastroATIVO: TWideStringField;
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

function ControleCadastroSchema: TControleCadastroSchema;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication, Controle.Funcoes, Controle.Main;

function ControleCadastroSchema: TControleCadastroSchema;
begin
  Result := TControleCadastroSchema(ControleMainModule.GetFormInstance(TControleCadastroSchema));
end;

{ TControleCadastro1 }

function TControleCadastroSchema.Abrir(Id: Integer): Boolean;
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

function TControleCadastroSchema.Descartar: Boolean;
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

function TControleCadastroSchema.Editar(Id: Integer): Boolean;
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

function TControleCadastroSchema.Novo(): Boolean;
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

function TControleCadastroSchema.Salvar: Boolean;
begin
  inherited;

  Result := False;

  with ControleMainModule do
  begin
    if CdsCadastro.State in [dsInsert, dsEdit] then
    begin
      if Trim(DBEdtDescricao.Text) = '' then
      begin
        ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar a descrição do schema.');
        DBEdtDescricao.SetFocus;
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
    QryAx1.Connection := ADOConnectionLogin;

    // Inicia a transação
    ADOConnectionLogin.BeginTrans;

    // Passo Unico - Salva os dados da cidade
    QryAx1.Parameters.Clear;
    QryAx1.SQL.Clear;

    if CadastroId = 0 then
    begin
      // Gera um novo id para a cidade
      CadastroId := GeraUsuarioId('tschema');
      // Insert
      QryAx1.SQL.Add('INSERT INTO tschema (');
      QryAx1.SQL.Add('       id,');
      QryAx1.SQL.Add('       descricao,');
      QryAx1.SQL.Add('       ativo)');
      QryAx1.SQL.Add('VALUES (');
      QryAx1.SQL.Add('       :id,');
      QryAx1.SQL.Add('       :descricao,');
      QryAx1.SQL.Add('       :ativo)');
    end
    else
    begin
      // Update
      QryAx1.SQL.Add('UPDATE tschema');
      QryAx1.SQL.Add('   SET descricao   = :descricao,');
      QryAx1.SQL.Add('       ativo       = :ativo');
      QryAx1.SQL.Add(' WHERE id          = :id');
    end;

    QryAx1.Parameters.ParamByName('id').Value         := CadastroId;
    QryAx1.Parameters.ParamByName('descricao').Value  := CdsCadastro.FieldByName('descricao').AsString;
    QryAx1.Parameters.ParamByName('ativo').Value      := copy(CdsCadastro.FieldByName('ativo').AsString,1,1);

    try
      // Tenta salvar os dados
      QryAx1.ExecSQL;
    except
      on E: Exception do
      begin
        // Descarta a transação
        ADOConnectionLogin.RollbackTrans;
        ControleMainModule.QryAx1.Connection := ControleMainModule.ADOConnection;
        ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));
        CdsCadastro.Edit;

        Exit;
      end;
    end;

    // Confirma a transação
    ADOConnectionLogin.CommitTrans;
    ControleMainModule.QryAx1.Connection := ControleMainModule.ADOConnection;
  end;

  // Recarrega o registro
  Abrir(CadastroId);
  Result := True;
end;

end.
