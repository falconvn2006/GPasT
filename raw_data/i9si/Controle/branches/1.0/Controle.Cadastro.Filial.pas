unit Controle.Cadastro.Filial;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Controle.Cadastro, Data.DB, Datasnap.DBClient,
  Datasnap.Provider, Data.Win.ADODB, uniGUIBaseClasses, uniImageList, uniButton,
  uniPanel, uniMemo, uniDBMemo, uniGroupBox, uniPageControl, uniBitBtn,
  uniSpeedButton, uniEdit, uniDBEdit, uniMultiItem, uniComboBox, uniDBComboBox,
  uniLabel, ACBrBase, ACBrSocket, ACBrCEP, uniImage, uniDBImage, jpeg,
  uniFileUpload, ACBrValidador,  uniProgressBar, uniRadioGroup,
  uniDBRadioGroup, uniSweetAlert ;

type
  TControleCadastroFilial = class(TControleCadastro)
    UniLabel42: TUniLabel;
    DbComboCRT: TUniDBComboBox;
    LabelCpfCnpj: TUniLabel;
    DBEdtCpfCnpj: TUniDBEdit;
    LabelNomeRazao: TUniLabel;
    DBEdtNome: TUniDBEdit;
    LabelPopularFantasia: TUniLabel;
    DbEditFantasia: TUniDBEdit;
    LabelRgIe: TUniLabel;
    DBEdtRg: TUniDBEdit;
    LabelOrgaoExped: TUniLabel;
    DBEdtOrgaoExped: TUniDBEdit;
    UniPagePrincipal: TUniPageControl;
    UniTabSheet1: TUniTabSheet;
    UniGroupBox1: TUniGroupBox;
    UniLabel7: TUniLabel;
    DBEditCepGeral: TUniDBEdit;
    BotaoCEP: TUniSpeedButton;
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
    UniLabel1: TUniLabel;
    CdsCadastroID: TFloatField;
    CdsCadastroCODIGO: TWideStringField;
    CdsCadastroATIVO: TWideStringField;
    CdsCadastroPESSOA_ID: TFloatField;
    CdsCadastroRAZAO_SOCIAL: TWideStringField;
    CdsCadastroNOME_FANTASIA: TWideStringField;
    CdsCadastroRG_INSC_ESTADUAL: TWideStringField;
    CdsCadastroINSC_SUBSTITUICAO: TWideStringField;
    QryCadastroID: TFloatField;
    QryCadastroCODIGO: TWideStringField;
    QryCadastroATIVO: TWideStringField;
    QryCadastroPESSOA_ID: TFloatField;
    QryCadastroRAZAO_SOCIAL: TWideStringField;
    QryCadastroNOME_FANTASIA: TWideStringField;
    QryCadastroRG_INSC_ESTADUAL: TWideStringField;
    QryCadastroINSC_SUBSTITUICAO: TWideStringField;
    QryCadastroINSC_MUNICIPAL: TWideStringField;
    UniFileUpload1: TUniFileUpload;
    UniPanel5: TUniPanel;
    ImageLogo: TUniImage;
    UniLabel2: TUniLabel;
    QryCadastroCPF_CNPJ: TWideStringField;
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
    QryCadastroCODIGO_REGIME_TRIBUTARIO: TWideStringField;
    QryCadastroLOGOMARCA_CAMINHO: TWideStringField;
    CdsCadastroINSC_MUNICIPAL: TWideStringField;
    CdsCadastroCPF_CNPJ: TWideStringField;
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
    CdsCadastroCODIGO_REGIME_TRIBUTARIO: TWideStringField;
    CdsCadastroLOGOMARCA_CAMINHO: TWideStringField;
    QryCadastroGERAL_CIDADE_ID: TFloatField;
    QryCadastroGERAL_CIDADE: TWideStringField;
    CdsCadastroGERAL_CIDADE_ID: TFloatField;
    CdsCadastroGERAL_CIDADE: TWideStringField;
    ButtonImportaImagem: TUniButton;
    BotaoApagarImagem: TUniButton;
    UniProgressBar1: TUniProgressBar;
    UniPanel7: TUniPanel;
    UniDBRadioGroup1: TUniDBRadioGroup;
    QryCadastroPLANO: TWideStringField;
    CdsCadastroPLANO: TWideStringField;
    QryCadastroATIVIDADE_PRINCIPAL: TWideStringField;
    DbComboAtividadePrincipal: TUniDBComboBox;
    CdsCadastroATIVIDADE_PRINCIPAL: TWideStringField;
    procedure UniFormShow(Sender: TObject);
    procedure UniFileUpload1Completed(Sender: TObject; AStream: TFileStream);
    procedure ButtonImportaImagemClick(Sender: TObject);
    procedure UniFormCreate(Sender: TObject);
    procedure BotaoApagarImagemClick(Sender: TObject);
    procedure BotaoCEPClick(Sender: TObject);
    procedure DBEditCepGeralExit(Sender: TObject);
    procedure UniDBRadioGroup1Click(Sender: TObject);
    procedure DBEdtCpfCnpjExit(Sender: TObject);


  private
    { Private declarations }
  public
    { Public declarations }
    // Funções
    URL_LOGO_FILIAL : String;
    tipo_pessoa: string;
    function Abrir(Id: Integer): Boolean; override;
    function Novo(): Boolean; override;
    function Editar(Id: Integer): Boolean; override;
    function Salvar: Boolean; override;
    function Descartar: Boolean; override;
    procedure CarregaImagem(URL: String);
  end;

function ControleCadastroFilial: TControleCadastroFilial;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication, Controle.Funcoes, Controle.Consulta,
  Controle.Consulta.Modal.Pessoa,
  Controle.Imagem.Informacao, Controle.Server.Module, Controle.Main;

function ControleCadastroFilial: TControleCadastroFilial;
begin
  Result := TControleCadastroFilial(ControleMainModule.GetFormInstance(TControleCadastroFilial));
end;

{ TControleCadastrofilial }
function TControleCadastroFilial.Abrir(Id: Integer): Boolean;
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

function TControleCadastroFilial.Editar(Id: Integer): Boolean;
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

  // Atualiza os botões de comando
  //  AtualizaComandos(DscCadastro);

  // Bloqueia a mudança do tipo de pessoa e cpf/cnpj na edição.
  // NOTA: Se for necessário alterar o cpf/cnpj, deve ser feito pelo cadastro
  //       de pessoa. O tipo de pessoa nunca pode ser alterado depois de
  //       cadastrado.
  DBEdtCpfCnpj.Color           := clBtnFace;
  DBEdtCpfCnpj.Enabled         := True;
//  BotaoPesquisaPessoa.Visible := False;

  Result := True;
end;

function TControleCadastroFilial.Novo(): Boolean;
begin
  Result := False;

  // Tenta abrir sem dados
  if Abrir(0) then
  begin
    // Libera o registro para edição
    DscCadastro.AutoEdit := True;

    // Adiciona um novo registro em branco
    CdsCadastro.Append;
    CdsCadastro['tipo']  := 'FÍSICA';
    CdsCadastro['ativo'] := 'SIM';

    // Libera a mudança do tipo de pessoa e cpf/cnpj na inserção
    DBEdtCpfCnpj.Color           := clWindow;
    DBEdtCpfCnpj.ReadOnly        := False;

    Result := True;
  end;
end;

function TControleCadastroFilial.Salvar: Boolean;
Var
  PessoaId, EnderecoId, Endereco: Integer;
  Erro: String;
begin
  inherited;

  Erro   := '';
  Result := False;

  if CdsCadastro.State in [dsInsert, dsEdit] then
  begin
    if Length(ControleFuncoes.RemoveMascara(DBEdtCpfCnpj.Text)) = 14 then
    begin
      tipo_pessoa := 'J';

      // Verifica o CNPJ
      if Trim(ControleFuncoes.RemoveMascara(DBEdtCpfCnpj.Text)) = '' then
      begin
        if ControleFuncoes.ValidaCNPJ(Trim(ControleFuncoes.RemoveMascara(DBEdtCpfCnpj.Text))) = False then
        begin
          ControleMainModule.MensageiroSweetAlerta('Atenção','CPF inválido!');
          Exit;
        end;

        ControleMainModule.MensageiroSweetAlerta('Atenção','É necessário informar o CNPJ.');

        if not DBEdtCpfCnpj.ReadOnly then
          DBEdtCpfCnpj.SetFocus;
        Exit;
      end;
    end
    else if Length(ControleFuncoes.RemoveMascara(DBEdtCpfCnpj.Text)) = 11 then
    begin
      tipo_pessoa := 'F';

      // Valida CNPJ/CPF
      if ControleFuncoes.ValidaCPF(Trim(ControleFuncoes.RemoveMascara(DBEdtCpfCnpj.Text))) = False then
      begin
        ControleMainModule.MensageiroSweetAlerta('Atenção','CPF inválido!');
        Exit;
      end;
    end
    else
    begin
      ControleMainModule.MensageiroSweetAlerta('Atenção','Preencha um CPF ou CNPJ válido!');
      Exit;
    end;

    // Verifica o nome da pessoa
    if DBEdtNome.Text = '' then
    begin
      ControleMainModule.MensageiroSweetAlerta('Atenção','É necessário informar a razão social.');

      DBEdtNome.SetFocus;
      Exit;
    end;

    // Valida email
    // Verifica o nome da pessoa
    if DBEditEmailGeral.Text <> '' then
    begin
      if ControleFuncoes.validarDocumentoACBr(DBEditEmailGeral.Text,
                                            docEmail)  = False then
      begin
        ControleMainModule.MensageiroSweetAlerta('Atenção','É necessário informar um email correto.');

        DBEditEmailGeral.SetFocus;
      Exit;

      end;
    end;
  end;

  // Pega os ids do registro
  CadastroId   := CdsCadastro.FieldByName('id').AsInteger;
  PessoaId     := CdsCadastro.FieldByName('pessoa_id').AsInteger;
  EnderecoId   := CdsCadastro.FieldByName('geral_endereco_id').AsInteger;

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
      QryAx1.SQL.Add('       cpf_cnpj,');
      QryAx1.SQL.Add('       rg_insc_estadual,');
      QryAx1.SQL.Add('       insc_substituicao,');
      QryAx1.SQL.Add('       insc_municipal,');
      QryAx1.SQL.Add('       codigo_regime_tributario)');
      QryAx1.SQL.Add('VALUES (');
      QryAx1.SQL.Add('       :id,');
      QryAx1.SQL.Add('       :tipo,');
      QryAx1.SQL.Add('       :razao_social,');
      QryAx1.SQL.Add('       :nome_fantasia,');
      QryAx1.SQL.Add('       :cpf_cnpj,');
      QryAx1.SQL.Add('       :rg_insc_estadual,');
      QryAx1.SQL.Add('       :insc_substituicao,');
      QryAx1.SQL.Add('       :insc_municipal,');
      QryAx1.SQL.Add('       codigo_regime_tributario)');
    end
    else
    begin
      // Update
      QryAx1.SQL.Add('UPDATE pessoa');
      QryAx1.SQL.Add('   SET tipo              = :tipo,');
      QryAx1.SQL.Add('       razao_social      = :razao_social,');
      QryAx1.SQL.Add('       nome_fantasia     = :nome_fantasia,');
      QryAx1.SQL.Add('       cpf_cnpj          = :cpf_cnpj,');
      QryAx1.SQL.Add('       rg_insc_estadual  = :rg_insc_estadual,');
      QryAx1.SQL.Add('       insc_substituicao = :insc_substituicao,');
      QryAx1.SQL.Add('       insc_municipal    = :insc_municipal,');
      QryAx1.SQL.Add('       codigo_regime_tributario  = :codigo_regime_tributario');
      QryAx1.SQL.Add(' WHERE id                = :id');
    end;

    QryAx1.Parameters.ParamByName('id').Value                      := PessoaId;
    QryAx1.Parameters.ParamByName('tipo').Value                    := tipo_pessoa;
    QryAx1.Parameters.ParamByName('razao_social').Value            := CdsCadastro.FieldByName('razao_social').AsString;
    QryAx1.Parameters.ParamByName('nome_fantasia').Value           := CdsCadastro.FieldByName('nome_fantasia').AsString;
    QryAx1.Parameters.ParamByName('cpf_cnpj').Value                := Trim(ControleFuncoes.RemoveMascara(CdsCadastro.FieldByName('cpf_cnpj').AsString));
    QryAx1.Parameters.ParamByName('rg_insc_estadual').Value        := CdsCadastro.FieldByName('rg_insc_estadual').AsString;
    QryAx1.Parameters.ParamByName('insc_substituicao').Value       := CdsCadastro.FieldByName('insc_substituicao').AsString;
    QryAx1.Parameters.ParamByName('insc_municipal').Value          := CdsCadastro.FieldByName('insc_municipal').AsString;
    if CdsCadastro.FieldByName('codigo_regime_tributario').Value = 'SIMPLES NACIONAL' then
      QryAx1.Parameters.ParamByName('codigo_regime_tributario').Value:= 1
    else
      QryAx1.Parameters.ParamByName('codigo_regime_tributario').Value:= 3;

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
    for Endereco := 1 to 1 do
    begin
      QryAx1.Parameters.Clear;
      QryAx1.SQL.Clear;

      if EnderecoId = 0 then
      begin
        // Gera um novo id para o endereço
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
          Break;
        end;
      end;
    end;
  end;

  // Passo 3 - Salva os dados do filial
  if Erro = '' then
  with ControleMainModule do
  begin
    QryAx1.Parameters.Clear;
    QryAx1.SQL.Clear;

    if CadastroId = 0 then
    begin
      // O id do filial será igual ao id da pessoa (ver modelo E/R)
      CadastroId := PessoaId;
      // Insert
      QryAx1.SQL.Add('INSERT INTO filial (');
      QryAx1.SQL.Add('       id,');
      QryAx1.SQL.Add('       ativo,');
      QryAx1.SQL.Add('       logomarca_caminho)');
      QryAx1.SQL.Add('VALUES (');
      QryAx1.SQL.Add('       :id,');
      QryAx1.SQL.Add('       :ativo,');
      QryAx1.SQL.Add('       :logomarca_caminho)');
    end
    else
    begin
      // Update
      QryAx1.SQL.Add('UPDATE filial');
      QryAx1.SQL.Add('   SET ativo      = :ativo,');
      QryAx1.SQL.Add('       logomarca_caminho = :logomarca_caminho');
      QryAx1.SQL.Add(' WHERE id         = :id');
    end;

    QryAx1.Parameters.ParamByName('id').Value         := CadastroId;
    QryAx1.Parameters.ParamByName('ativo').Value      := Copy(CdsCadastro.FieldByName('ativo').AsString, 1, 1);
    QryAx1.Parameters.ParamByName('logomarca_caminho').Value := URL_LOGO_FILIAL;

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
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Falha ao salvar os dados.');
  end
  else
  begin
    // Confirma a transação
    ControleMainModule.ADOConnection.CommitTrans;

    // Verifica se o dono é um formulário de consulta, e se o botão Confirmar do
    // formulário de consulta está visível.
   { if (Owner <> nil) and (Owner is TControleConsulta) and
      (TControleConsulta(Owner).BotaoConfirmar.Visible) then
    begin
      // Fecha e confirma que o registro atual foi salvo.
      // Isso é necessário para que o formulário de consulta carregue o registro
      // que foi salvo e execute o botão Confirmar automáticamente.
      ModalResult := mrOk;
    end;}

    // Recarrega o registro
    Abrir(CadastroId);

    //é melhor colocar a imagem na tabela cliente, assim nao precisa recarregar a tabela filial

    // UniMainModule.SelecionaFilial(UniMainModule.CdsFilial.FieldByName('id').AsInteger);
    Result := True;
  end;

  // Atualizando as variaveis globais
  With ControleMainModule do
  begin
    FFilial       := CdsCadastro.FieldByName('id').AsInteger;
    FRazaoSocial  := CdsCadastro.FieldByName('razao_social').AsString;
    FNomeFantasia := CdsCadastro.FieldByName('nome_fantasia').AsString;
    FPlano        := CdsCadastro.FieldByName('plano').AsString;

    if CdsCadastro.FieldByName('codigo_regime_tributario').AsString = 'SIMPLES NACIONAL' then
      FCodigoRegimeTributario := '1'
    else
      FCodigoRegimeTributario := '3';
  end;
end;


procedure TControleCadastroFilial.UniFileUpload1Completed(Sender: TObject;
  AStream: TFileStream);
var
  DestName : string;
  DestFolder : string;
begin
  Try
    DestFolder := ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\';
    DestName:=DestFolder+ExtractFileName(UniFileUpload1.FileName);
    CopyFile(PChar(AStream.FileName), PChar(DestName), False);
    CarregaImagem(ControleServerModule.StartPath + 'UploadFolder\'+ ControleMainModule.FSchema + '\' + UniFileUpload1.FileName);
  Except
    on e:exception do
    begin
      ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));
      Exit;
    end;
  End;

  Salvar;
end;

procedure TControleCadastroFilial.UniFormCreate(Sender: TObject);

begin
  inherited;

  // Função utilizada para traduzir o erro da mensagem de tamanho maior
  //ControleFuncoes.HookResourceString(@MAX_SIZE_ERROR, 'O tamanho do arquivo é maior do que o permitido!');

  if not DirectoryExists(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\') then
    CreateDir(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\');

  UniProgressBar1.Position := ControleMain.HdLivre;

end;

procedure TControleCadastroFilial.UniFormShow(Sender: TObject);
begin
  inherited;
  UniPagePrincipal.ActivePageIndex := 0;
  if ControleMainModule.CdsFilial.FieldByName('LOGOMARCA_CAMINHO').AsString <> '' then
  begin
    CarregaImagem(ControleMainModule.CdsFilial.FieldByName('LOGOMARCA_CAMINHO').AsString);
  end;
end;




procedure TControleCadastroFilial.UniDBRadioGroup1Click(Sender: TObject);
begin
  inherited;
  ///fazendo validação qual plano foi selecionado
  if UniDBRadioGroup1.ItemIndex = 0 then
  begin
    if ControleMainModule.FPlano = 'GRÁTIS' then
      UniDBRadioGroup1.ItemIndex := 0
    else if ControleMainModule.FPlano = 'BÁSICO' then
    begin
      UniDBRadioGroup1.ItemIndex := 1;
      ControleMainModule.MensageiroSweetAlerta('Atenção','Você não pode regredir o plano');
    end
    else if ControleMainModule.FPlano = 'PRO' then
    begin
      UniDBRadioGroup1.ItemIndex := 2;
      ControleMainModule.MensageiroSweetAlerta('Atenção','Você não pode regredir o plano');
    end;
  end
  else if UniDBRadioGroup1.ItemIndex = 1 then
  begin
    if ControleMainModule.FPlano = 'BÁSICO' then
      UniDBRadioGroup1.ItemIndex := 1
    else if ControleMainModule.FPlano = 'GRÁTIS' then
    begin
      ControleMain.ExecutaEscolhePlano();
    end
    else if ControleMainModule.FPlano = 'PRO' then
    begin
      UniDBRadioGroup1.ItemIndex := 2;
      ControleMainModule.MensageiroSweetAlerta('Alerta','Você não pode regredir o plano');
    end;
  end
  else if UniDBRadioGroup1.ItemIndex = 2 then
  begin
    if ControleMainModule.FPlano = 'PRO' then
      UniDBRadioGroup1.ItemIndex := 2
    else if ControleMainModule.FPlano = 'GRÁTIS' then
    begin
      ControleMain.ExecutaEscolhePlano();
    end
    else if ControleMainModule.FPlano = 'BÁSICO' then
    begin
      ControleMain.ExecutaEscolhePlano();
    end;
  end;
end;

procedure TControleCadastroFilial.BotaoApagarImagemClick(Sender: TObject);
var
  Erro: string;
begin
  inherited;

  // Update
  with ControleMainModule do
  begin
    ADOConnection.BeginTrans;

    // Inserindo o login do usuario em tabela temporaria,
    // Utilzado para auditoria
    Insere_Tabela_Temp_Login;

    QryAx1.Parameters.Clear;
    QryAx1.SQL.Clear;
    QryAx1.SQL.Add('UPDATE filial');
    QryAx1.SQL.Add('   SET logomarca_caminho  = null');
    QryAx1.SQL.Add(' WHERE id         = :id');
    QryAx1.Parameters.ParamByName('id').Value    := CdsCadastroID.AsInteger;

    try
      // Tenta salvar os dados
      QryAx1.ExecSQL;
      ADOConnection.CommitTrans;

      DeleteFile(URL_LOGO_FILIAL);
      CarregaImagem('');
    except
      on E: Exception do
      begin
        ADOConnection.RollbackTrans;
        Erro := ControleFuncoes.RetiraAspaSimples(E.Message);
        ControleMainModule.MensageiroSweetAlerta('Atenção', Erro);
      end;
    end;
  end;
end;

procedure TControleCadastroFilial.BotaoCEPClick(Sender: TObject);
begin
  inherited;
  VerificaCEP(BotaoCEP,
              DBEditCepGeral,
              DBEditNum);
end;

procedure TControleCadastroFilial.ButtonImportaImagemClick(Sender: TObject);
begin
  inherited;
  Try
    // Redimensiona a imagem
    // UniMainModule.ComprimirImagem(40, FUploadPath + FileName, FUploadPath + FileName);

    with UniFileUpload1 do
    begin
      MaxAllowedSize := 5000000;
      Execute;
    end;
  Except
    on e:Exception do
    begin
      ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(e.Message));
    end;
  end;
end;

procedure TControleCadastroFilial.DBEditCepGeralExit(Sender: TObject);
begin
  inherited;
  BotaoCEP.Click;
end;

procedure TControleCadastroFilial.DBEdtCpfCnpjExit(Sender: TObject);
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

function TControleCadastroFilial.Descartar: Boolean;
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

procedure TControleCadastroFilial.CarregaImagem(URL: String);
Var
  Erro: string;
begin
  if URL <> '' then
  begin
    Try
      ImageLogo.Picture.LoadFromFile(URL);
      BotaoApagarImagem.Visible := True;
      URL_LOGO_FILIAL := URL;

      // Carregando a imagem na logo do formulario principal
      // ControleMain.ImageLoginInicial.Picture.LoadFromFile(ControleMainModule.URL_LOGO_MAIN_MODULE);
      ControleMain.ImageLoginInicial.Picture.LoadFromFile(URL_LOGO_FILIAL);
    except
      on E: Exception do
      begin
        Erro := ControleFuncoes.RetiraAspaSimples(E.Message);
        //ControleMainModule.MensageiroSweetAlerta('Atenção', Erro);
      end;
    End;
  end
  else
  begin
    BotaoApagarImagem.Visible := False;
    ImageLogo.Picture := nil;
    URL_LOGO_FILIAL := '';

    // Apagando a imagem na logo do formulario principal
    ControleMain.ImageLoginInicial.Picture := nil;
  end;
end;

end.
