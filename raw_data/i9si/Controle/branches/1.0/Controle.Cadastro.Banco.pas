unit Controle.Cadastro.Banco;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Controle.Cadastro, ACBrBase, ACBrSocket, ACBrCEP,
  Data.DB, Datasnap.DBClient, Datasnap.Provider, Data.Win.ADODB,
  uniGUIBaseClasses, uniImageList, uniBitBtn, uniSpeedButton, uniLabel,
  uniButton, uniPanel, uniMemo, uniDBMemo, uniGroupBox, uniPageControl, uniEdit,
  uniDBEdit, ACBrValidador, uniSweetAlert;

type
  TControleCadastroBanco = class(TControleCadastro)
    LabelCpfCnpj: TUniLabel;
    DBEdtCpfCnpj: TUniDBEdit;
    LabelNomeRazao: TUniLabel;
    DBEdtNome: TUniDBEdit;
    LabelPopularFantasia: TUniLabel;
    DbEditFantasia: TUniDBEdit;
    UniPagePrincipal: TUniPageControl;
    UniTabSheet1: TUniTabSheet;
    UniGroupBox1: TUniGroupBox;
    UniLabel7: TUniLabel;
    DBEditCepGeral: TUniDBEdit;
    BotaoCEPGeral: TUniSpeedButton;
    UniLabel8: TUniLabel;
    UniDBEdit3: TUniDBEdit;
    UniLabel9: TUniLabel;
    DBEditNum: TUniDBEdit;
    UniLabel10: TUniLabel;
    UniDBEdit5: TUniDBEdit;
    UniLabel11: TUniLabel;
    UniDBEdit6: TUniDBEdit;
    UniLabel12: TUniLabel;
    UniDBEdit7: TUniDBEdit;
    UniLabel13: TUniLabel;
    UniDBEdit8: TUniDBEdit;
    ButtonPesquisaCidadeGeral: TUniSpeedButton;
    UniGroupBox2: TUniGroupBox;
    UniLabel14: TUniLabel;
    UniLabel15: TUniLabel;
    DBEditEmailGeral: TUniDBEdit;
    UniDBEdit10: TUniDBEdit;
    UniLabel16: TUniLabel;
    UniDBEdit11: TUniDBEdit;
    UniLabel17: TUniLabel;
    UniDBEdit12: TUniDBEdit;
    UniDBEdit13: TUniDBEdit;
    UniLabel19: TUniLabel;
    QryCadastroID: TFloatField;
    QryCadastroCODIGO: TWideStringField;
    QryCadastroATIVO: TWideStringField;
    QryCadastroPESSOA_ID: TFloatField;
    QryCadastroRAZAO_SOCIAL: TWideStringField;
    QryCadastroNOME_FANTASIA: TWideStringField;
    QryCadastroCPF_CNPJ: TWideStringField;
    CdsCadastroID: TFloatField;
    CdsCadastroCODIGO: TWideStringField;
    CdsCadastroATIVO: TWideStringField;
    CdsCadastroPESSOA_ID: TFloatField;
    CdsCadastroRAZAO_SOCIAL: TWideStringField;
    CdsCadastroNOME_FANTASIA: TWideStringField;
    CdsCadastroCPF_CNPJ: TWideStringField;
    UniLabel1: TUniLabel;
    UniDBEdit1: TUniDBEdit;
    QryCadastroGERAL_ENDERECO_ID: TFloatField;
    QryCadastroGERAL_LOGRADOURO: TWideStringField;
    QryCadastroGERAL_NUMERO: TWideStringField;
    QryCadastroGERAL_COMPLEMENTO: TWideStringField;
    QryCadastroGERAL_PONTO_REFERENCIA: TWideStringField;
    QryCadastroGERAL_CEP: TWideStringField;
    QryCadastroGERAL_BAIRRO: TWideStringField;
    QryCadastroGERAL_NOME_CONTATO: TWideStringField;
    QryCadastroGERAL_TELEFONE_1: TWideStringField;
    QryCadastroGERAL_TELEFONE_2: TWideStringField;
    QryCadastroGERAL_CELULAR: TWideStringField;
    QryCadastroGERAL_EMAIL: TWideStringField;
    QryCadastroGERAL_CIDADE_ID: TFloatField;
    QryCadastroGERAL_CIDADE: TWideStringField;
    CdsCadastroGERAL_ENDERECO_ID: TFloatField;
    CdsCadastroGERAL_LOGRADOURO: TWideStringField;
    CdsCadastroGERAL_NUMERO: TWideStringField;
    CdsCadastroGERAL_COMPLEMENTO: TWideStringField;
    CdsCadastroGERAL_PONTO_REFERENCIA: TWideStringField;
    CdsCadastroGERAL_CEP: TWideStringField;
    CdsCadastroGERAL_BAIRRO: TWideStringField;
    CdsCadastroGERAL_NOME_CONTATO: TWideStringField;
    CdsCadastroGERAL_TELEFONE_1: TWideStringField;
    CdsCadastroGERAL_TELEFONE_2: TWideStringField;
    CdsCadastroGERAL_CELULAR: TWideStringField;
    CdsCadastroGERAL_EMAIL: TWideStringField;
    CdsCadastroGERAL_CIDADE_ID: TFloatField;
    CdsCadastroGERAL_CIDADE: TWideStringField;
    QryCadastroTIPO: TWideStringField;
    CdsCadastroTIPO: TWideStringField;
    procedure BotaoCEPGeralClick(Sender: TObject);
    procedure ButtonPesquisaCidadeGeralClick(Sender: TObject);
    procedure DBEditCepGeralExit(Sender: TObject);
    procedure DBEdtCpfCnpjExit(Sender: TObject);
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

function ControleCadastroBanco: TControleCadastroBanco;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication, Controle.Funcoes, Controle.Consulta,
  Controle.Consulta.Modal.Pessoa, Controle.Consulta.Modal.Cidade;

function ControleCadastroBanco: TControleCadastroBanco;
begin
  Result := TControleCadastroBanco(ControleMainModule.GetFormInstance(TControleCadastroBanco));
end;

{ TControleCadastroBanco }


procedure TControleCadastroBanco.BotaoCEPGeralClick(Sender: TObject);
begin
  inherited;
  VerificaCEP(BotaoCEPGeral,
              DBEditCepGeral,
              DBEditNum);
end;

procedure TControleCadastroBanco.ButtonPesquisaCidadeGeralClick(
  Sender: TObject);
begin
  inherited;

  // Abre o formulário em modal e aguarda
  ControleConsultaModalCidade.ShowModal(procedure(Sender: TComponent; Result: Integer)
  begin
{    if Result = 1 then
    begin}
      CdsCadastro.Edit;
      CdsCadastro['geral_cidade_id'] := ControleConsultaModalCidade.CdsConsulta.FieldByName('id').AsInteger;
      CdsCadastro['geral_cidade']    := ControleConsultaModalCidade.CdsConsulta.FieldByName('nome').AsString +
        ' / ' + ControleConsultaModalCidade.CdsConsulta.FieldByName('uf').AsString;
//    end;
  end);
end;

procedure TControleCadastroBanco.DBEditCepGeralExit(Sender: TObject);
begin
  inherited;
  BotaoCEPGeral.Click;
end;

procedure TControleCadastroBanco.DBEdtCpfCnpjExit(Sender: TObject);
begin
  inherited;
  with ControleMainModule do
  begin
    // Pesquisa o cpf/cnpj
    CdsAx1.Close;
    QryAx1.Parameters.Clear;
    QryAx1.SQL.Clear;
    QryAx1.SQL.Add('SELECT id');
    QryAx1.SQL.Add('  FROM pessoa');
    QryAx1.SQL.Add(' WHERE cpf_cnpj = :cpf_cnpj');
    QryAx1.Parameters.ParamByName('cpf_cnpj').Value := ControleFuncoes.RemoveMascara(DBEdtCpfCnpj.Text);
    CdsAx1.Open;

    // Recarrega o cliente com os dados da nova pessoa selecionada
    if CdsAx1.RecordCount > 0 then
    begin
      // Recarrega os dados
      CdsCadastro.Close;
      QryCadastro.Parameters.ParamByName('id').Value := CdsAx1.FieldByName('id').AsInteger;
      CdsCadastro.Open;

      CdsCadastro.Edit;
      CdsCadastro['ativo'] := 'SIM';
    end;
  end;
end;

function TControleCadastroBanco.Abrir(Id: Integer): Boolean;
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

function TControleCadastroBanco.Descartar: Boolean;
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

function TControleCadastroBanco.Editar(Id: Integer): Boolean;
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

function TControleCadastroBanco.Novo(): Boolean;
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

function TControleCadastroBanco.Salvar: Boolean;
var
  PessoaId, EnderecoId: Integer;
  Erro: String;
begin
  inherited;

  Erro   := '';
  Result := False;

  if CdsCadastro.State in [dsInsert, dsEdit] then
  begin
    // Verifica o CNPJ
    if Trim(ControleFuncoes.RemoveMascara(DBEdtCpfCnpj.Text)) = '' then
    begin
      ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar o CNPJ.');

      if not DBEdtCpfCnpj.ReadOnly then
        DBEdtCpfCnpj.SetFocus;
      Exit;
    end;

    if Length(DBEdtCpfCnpj.Text) <> 14 then
    begin
      ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar o CNPJ com 14 digitos.');

      if not DBEdtCpfCnpj.ReadOnly then
        DBEdtCpfCnpj.SetFocus;
      Exit;
    end;

    if CdsCadastroTipo.AsString = 'J' then
    begin
      if ControleFuncoes.ValidaCNPJ(ControleFuncoes.RemoveMascara(Trim(DBEdtCpfCnpj.Text))) = False then
      begin
        ControleMainModule.MensageiroSweetAlerta('Atenção', 'CNPJ inválido');
        Exit;
      end;
    end;

    // Verifica o nome da pessoa
    if DBEdtNome.Text = '' then
    begin
      ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar a razão social.');

      DBEdtNome.SetFocus;
      Exit;
    end;

    // Valida email
    // Verifica o nome da pessoa
    if DBEditEmailGeral.Text <> '' then
    begin
      if ControleFuncoes.validarDocumentoACBr(DBEditEmailGeral.Text,
                                            docEmail) = False then
      begin
        ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar um email correto.');

        DBEditEmailGeral.SetFocus;
      Exit;

      end;
    end;

    // Confirma os dados
    CdsCadastro.Post;
  end;

  // Pega os ids do registro
  CadastroId := CdsCadastro.FieldByName('id').AsInteger;
  PessoaId   := CdsCadastro.FieldByName('pessoa_id').AsInteger;
  EnderecoId := CdsCadastro.FieldByName('geral_endereco_id').AsInteger;

  with ControleMainModule do
  begin
    // Inicia a transação
    ADOConnection.BeginTrans;

    // Passo 1 - Salva os dados da pessoa
    QryAx1.Parameters.Clear;
    QryAx1.SQL.Clear;

      if PessoaId = 0 then
    begin
      // Gera um novo id para a pessoa
      PessoaId := GeraId('pessoa');

      // Insert
      QryAx1.SQL.Add('INSERT INTO pessoa (');
      QryAx1.SQL.Add('       id,');
      QryAx1.SQL.Add('       tipo,');
      QryAx1.SQL.Add('       razao_social,');
      QryAx1.SQL.Add('       nome_fantasia,');
      QryAx1.SQL.Add('       cpf_cnpj)');
      QryAx1.SQL.Add('VALUES (');
      QryAx1.SQL.Add('       :id,');
      QryAx1.SQL.Add('       :tipo,');
      QryAx1.SQL.Add('       :razao_social,');
      QryAx1.SQL.Add('       :nome_fantasia,');
      QryAx1.SQL.Add('       :cpf_cnpj)');
    end
    else
    begin
      // Update
      QryAx1.SQL.Add('UPDATE pessoa');
      QryAx1.SQL.Add('   SET tipo          = :tipo,');
      QryAx1.SQL.Add('       razao_social  = :razao_social,');
      QryAx1.SQL.Add('       nome_fantasia = :nome_fantasia,');
      QryAx1.SQL.Add('       cpf_cnpj      = :cpf_cnpj');
      QryAx1.SQL.Add(' WHERE id            = :id');
    end;

    QryAx1.Parameters.ParamByName('id').Value            := PessoaId;
    QryAx1.Parameters.ParamByName('tipo').Value          := 'J';
    QryAx1.Parameters.ParamByName('razao_social').Value  := CdsCadastro.FieldByName('razao_social').AsString;
    QryAx1.Parameters.ParamByName('nome_fantasia').Value := CdsCadastro.FieldByName('nome_fantasia').AsString;
    QryAx1.Parameters.ParamByName('cpf_cnpj').Value      := CdsCadastro.FieldByName('cpf_cnpj').AsString;

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

  // Passo 2 - Salva os enderecos da pessoa
  if Erro = '' then
  with ControleMainModule do
  begin
    QryAx1.Parameters.Clear;
    QryAx1.SQL.Clear;

    if EnderecoId = 0 then
    begin
      EnderecoId := GeraId('pessoa_endereco');

      // Insert
      QryAx1.SQL.Add('INSERT INTO pessoa_endereco (');
      QryAx1.SQL.Add('       id,');
      QryAx1.SQL.Add('       pessoa_id,');
      QryAx1.SQL.Add('       tipo,');
      QryAx1.SQL.Add('       logradouro,');
      QryAx1.SQL.Add('       numero,');
      QryAx1.SQL.Add('       complemento,');
      QryAx1.SQL.Add('       ponto_referencia,');
      QryAx1.SQL.Add('       cep,');
      QryAx1.SQL.Add('       bairro,');
      QryAx1.SQL.Add('       cidade_id,');
      QryAx1.SQL.Add('       nome_contato,');
      QryAx1.SQL.Add('       telefone_1,');
      QryAx1.SQL.Add('       telefone_2,');
      QryAx1.SQL.Add('       celular,');
      QryAx1.SQL.Add('       email)');
      QryAx1.SQL.Add('VALUES (');
      QryAx1.SQL.Add('       :id,');
      QryAx1.SQL.Add('       :pessoa_id,');
      QryAx1.SQL.Add('       :tipo,');
      QryAx1.SQL.Add('       :logradouro,');
      QryAx1.SQL.Add('       :numero,');
      QryAx1.SQL.Add('       :complemento,');
      QryAx1.SQL.Add('       :ponto_referencia,');
      QryAx1.SQL.Add('       :cep,');
      QryAx1.SQL.Add('       :bairro,');
      QryAx1.SQL.Add('       :cidade_id,');
      QryAx1.SQL.Add('       :nome_contato,');
      QryAx1.SQL.Add('       :telefone_1,');
      QryAx1.SQL.Add('       :telefone_2,');
      QryAx1.SQL.Add('       :celular,');
      QryAx1.SQL.Add('       :email)');
      QryAx1.Parameters.ParamByName('pessoa_id').Value := PessoaId;
    end
    else
    begin
      // Update
      QryAx1.SQL.Add('UPDATE pessoa_endereco');
      QryAx1.SQL.Add('   SET tipo             = :tipo,');
      QryAx1.SQL.Add('       logradouro       = :logradouro,');
      QryAx1.SQL.Add('       numero           = :numero,');
      QryAx1.SQL.Add('       complemento      = :complemento,');
      QryAx1.SQL.Add('       ponto_referencia = :ponto_referencia,');
      QryAx1.SQL.Add('       cep              = :cep,');
      QryAx1.SQL.Add('       bairro           = :bairro,');
      QryAx1.SQL.Add('       cidade_id        = :cidade_id,');
      QryAx1.SQL.Add('       nome_contato     = :nome_contato,');
      QryAx1.SQL.Add('       telefone_1       = :telefone_1,');
      QryAx1.SQL.Add('       telefone_2       = :telefone_2,');
      QryAx1.SQL.Add('       celular          = :celular,');
      QryAx1.SQL.Add('       email            = :email');
      QryAx1.SQL.Add(' WHERE id               = :id');
    end;

    QryAx1.Parameters.ParamByName('id').Value               := EnderecoId;
    QryAx1.Parameters.ParamByName('tipo').Value             := 'GE';
    QryAx1.Parameters.ParamByName('logradouro').Value       := CdsCadastro.FieldByName('geral_logradouro').AsString;
    QryAx1.Parameters.ParamByName('numero').Value           := CdsCadastro.FieldByName('geral_numero').AsString;
    QryAx1.Parameters.ParamByName('complemento').Value      := CdsCadastro.FieldByName('geral_complemento').AsString;
    QryAx1.Parameters.ParamByName('ponto_referencia').Value := CdsCadastro.FieldByName('geral_ponto_referencia').AsString;
    QryAx1.Parameters.ParamByName('cep').Value              := CdsCadastro.FieldByName('geral_cep').AsString;
    QryAx1.Parameters.ParamByName('bairro').Value           := CdsCadastro.FieldByName('geral_bairro').AsString;
    QryAx1.Parameters.ParamByName('nome_contato').Value     := CdsCadastro.FieldByName('geral_nome_contato').AsString;
    QryAx1.Parameters.ParamByName('telefone_1').Value       := CdsCadastro.FieldByName('geral_telefone_1').AsString;
    QryAx1.Parameters.ParamByName('telefone_2').Value       := CdsCadastro.FieldByName('geral_telefone_2').AsString;
    QryAx1.Parameters.ParamByName('celular').Value          := CdsCadastro.FieldByName('geral_celular').AsString;
    QryAx1.Parameters.ParamByName('email').Value            := CdsCadastro.FieldByName('geral_email').AsString;


    if CdsCadastro.FieldByName('geral_cidade_id').AsString <> '' then
      QryAx1.Parameters.ParamByName('cidade_id').Value := CdsCadastro.FieldByName('geral_cidade_id').AsInteger
    else
      QryAx1.Parameters.ParamByName('cidade_id').Value := '';

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

  // Passo 3 - Salva os dados do cliente
  if Erro = '' then
  with ControleMainModule do
  begin
    QryAx1.Parameters.Clear;
    QryAx1.SQL.Clear;

    if CadastroId = 0 then
    begin
      // O id do cliente será igual ao id da pessoa (ver modelo E/R)
      CadastroId := PessoaId;
      // Insert
      QryAx1.SQL.Add('INSERT INTO banco (');
      QryAx1.SQL.Add('       id,');
      QryAx1.SQL.Add('       codigo,');
      QryAx1.SQL.Add('       ativo)');
      QryAx1.SQL.Add('VALUES (');
      QryAx1.SQL.Add('       :id,');
      QryAx1.SQL.Add('       :codigo,');
      QryAx1.SQL.Add('       :ativo)');
    end
    else
    begin
      // Update
      QryAx1.SQL.Add('UPDATE banco SET');
      QryAx1.SQL.Add('       codigo      = :codigo,');
      QryAx1.SQL.Add('       ativo       = :ativo');
      QryAx1.SQL.Add(' WHERE id          = :id');
    end;

    QryAx1.Parameters.ParamByName('id').Value         := CadastroId;
    QryAx1.Parameters.ParamByName('codigo').Value     := CdsCadastro.FieldByName('codigo').AsString;
    QryAx1.Parameters.ParamByName('ativo').Value      := Copy(CdsCadastro.FieldByName('ativo').AsString, 1, 1);

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
