unit Controle.Cadastro.Responsavel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Controle.Cadastro, ACBrBase, ACBrSocket, ACBrCEP,
  Data.DB, Datasnap.DBClient, Datasnap.Provider, Data.Win.ADODB,
  uniGUIBaseClasses, uniImageList, uniButton, uniPanel, uniMemo, uniDBMemo,
  uniGroupBox, uniPageControl, uniBitBtn, uniSpeedButton, uniEdit, uniDBEdit,
  uniMultiItem, uniComboBox, uniDBComboBox, uniLabel;

type
  TControleCadastroResponsavel = class(TControleCadastro)
    UniLabel1: TUniLabel;
    DbComboTipo: TUniDBComboBox;
    UniLabel2: TUniLabel;
    UniDBComboBox1: TUniDBComboBox;
    LabelCRT: TUniLabel;
    DbComboCRT: TUniDBComboBox;
    DBEdtCpfCnpj: TUniDBEdit;
    BotaoPesquisaPessoa: TUniSpeedButton;
    LabelNomeRazao: TUniLabel;
    DBEdtNome: TUniDBEdit;
    LabelPopularFantasia: TUniLabel;
    DbEditFantasia: TUniDBEdit;
    LabelNascimento: TUniLabel;
    DBEdtNascimento: TUniDBEdit;
    LabelSexo: TUniLabel;
    DBComboSexo: TUniDBComboBox;
    DBEdtOrgaoExped: TUniDBEdit;
    LabelOrgaoExped: TUniLabel;
    DBEdtDataExped: TUniDBEdit;
    LabelDataExped: TUniLabel;
    DBEdtRg: TUniDBEdit;
    LabelRgIe: TUniLabel;
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
    UniTabSheet3: TUniTabSheet;
    UniGroupBox3: TUniGroupBox;
    UniLabel3: TUniLabel;
    DBEditCepComercial: TUniDBEdit;
    BotaoCEPComercial: TUniSpeedButton;
    UniLabel4: TUniLabel;
    UniDBEdit15: TUniDBEdit;
    UniLabel5: TUniLabel;
    UniDBEdit16: TUniDBEdit;
    UniLabel6: TUniLabel;
    UniDBEdit17: TUniDBEdit;
    UniLabel20: TUniLabel;
    UniDBEdit18: TUniDBEdit;
    UniLabel21: TUniLabel;
    UniDBEdit19: TUniDBEdit;
    UniLabel22: TUniLabel;
    UniDBEdit20: TUniDBEdit;
    ButtonPesquisaCidadeComercial: TUniSpeedButton;
    UniGroupBox4: TUniGroupBox;
    UniLabel24: TUniLabel;
    UniLabel25: TUniLabel;
    UniDBEdit22: TUniDBEdit;
    UniDBEdit23: TUniDBEdit;
    UniLabel26: TUniLabel;
    UniDBEdit24: TUniDBEdit;
    UniLabel27: TUniLabel;
    UniDBEdit25: TUniDBEdit;
    UniDBEdit26: TUniDBEdit;
    UniLabel28: TUniLabel;
    UniTabSheet4: TUniTabSheet;
    UniGroupBox5: TUniGroupBox;
    UniLabel29: TUniLabel;
    DBEditCepCobranca: TUniDBEdit;
    BotaoCEPCobranca: TUniSpeedButton;
    UniLabel30: TUniLabel;
    UniDBEdit28: TUniDBEdit;
    UniLabel31: TUniLabel;
    UniDBEdit29: TUniDBEdit;
    UniLabel32: TUniLabel;
    UniDBEdit30: TUniDBEdit;
    UniLabel33: TUniLabel;
    UniDBEdit31: TUniDBEdit;
    UniLabel34: TUniLabel;
    UniDBEdit32: TUniDBEdit;
    UniLabel35: TUniLabel;
    UniDBEdit33: TUniDBEdit;
    ButtonPesquisaCidadeCobranca: TUniSpeedButton;
    UniGroupBox6: TUniGroupBox;
    UniLabel37: TUniLabel;
    UniLabel38: TUniLabel;
    UniDBEdit35: TUniDBEdit;
    UniDBEdit36: TUniDBEdit;
    UniLabel39: TUniLabel;
    UniDBEdit37: TUniDBEdit;
    UniLabel40: TUniLabel;
    UniDBEdit38: TUniDBEdit;
    UniDBEdit39: TUniDBEdit;
    UniLabel41: TUniLabel;
    UniTabSheet2: TUniTabSheet;
    UniDBMemo1: TUniDBMemo;
    QryCadastroID: TFloatField;
    QryCadastroATIVO: TWideStringField;
    QryCadastroOBSERVACAO: TWideStringField;
    QryCadastroPESSOA_ID: TFloatField;
    QryCadastroTIPO: TWideStringField;
    QryCadastroRAZAO_SOCIAL: TWideStringField;
    QryCadastroNOME_FANTASIA: TWideStringField;
    QryCadastroCPF_CNPJ: TWideStringField;
    QryCadastroRG_INSC_ESTADUAL: TWideStringField;
    QryCadastroDATA_EXPEDICAO_RG: TDateTimeField;
    QryCadastroORGAO_EXPEDIDOR_RG: TWideStringField;
    QryCadastroDATA_NASCIMENTO: TDateTimeField;
    QryCadastroSEXO: TWideStringField;
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
    QryCadastroCOMERCIAL_ENDERECO_ID: TFloatField;
    QryCadastroCOMERCIAL_LOGRADOURO: TWideStringField;
    QryCadastroCOMERCIAL_NUMERO: TWideStringField;
    QryCadastroCOMERCIAL_COMPLEMENTO: TWideStringField;
    QryCadastroCOMERCIAL_PONTO_REFERENCIA: TWideStringField;
    QryCadastroCOMERCIAL_CEP: TWideStringField;
    QryCadastroCOMERCIAL_BAIRRO: TWideStringField;
    QryCadastroCOMERCIAL_NOME_CONTATO: TWideStringField;
    QryCadastroCOMERCIAL_TELEFONE_1: TWideStringField;
    QryCadastroCOMERCIAL_TELEFONE_2: TWideStringField;
    QryCadastroCOMERCIAL_CELULAR: TWideStringField;
    QryCadastroCOMERCIAL_EMAIL: TWideStringField;
    QryCadastroCOMERCIAL_CIDADE_ID: TFloatField;
    QryCadastroCOMERCIAL_CIDADE: TWideStringField;
    QryCadastroCOBRANCA_ENDERECO_ID: TFloatField;
    QryCadastroCOBRANCA_LOGRADOURO: TWideStringField;
    QryCadastroCOBRANCA_NUMERO: TWideStringField;
    QryCadastroCOBRANCA_COMPLEMENTO: TWideStringField;
    QryCadastroCOBRANCA_PONTO_REFERENCIA: TWideStringField;
    QryCadastroCOBRANCA_CEP: TWideStringField;
    QryCadastroCOBRANCA_BAIRRO: TWideStringField;
    QryCadastroCOBRANCA_NOME_CONTATO: TWideStringField;
    QryCadastroCOBRANCA_TELEFONE_1: TWideStringField;
    QryCadastroCOBRANCA_TELEFONE_2: TWideStringField;
    QryCadastroCOBRANCA_CELULAR: TWideStringField;
    QryCadastroCOBRANCA_EMAIL: TWideStringField;
    QryCadastroCOBRANCA_CIDADE_ID: TFloatField;
    QryCadastroCOBRANCA_CIDADE: TWideStringField;
    QryCadastroCODIGO_REGIME_TRIBUTARIO: TWideStringField;
    CdsCadastroID: TFloatField;
    CdsCadastroATIVO: TWideStringField;
    CdsCadastroOBSERVACAO: TWideStringField;
    CdsCadastroPESSOA_ID: TFloatField;
    CdsCadastroTIPO: TWideStringField;
    CdsCadastroRAZAO_SOCIAL: TWideStringField;
    CdsCadastroNOME_FANTASIA: TWideStringField;
    CdsCadastroCPF_CNPJ: TWideStringField;
    CdsCadastroRG_INSC_ESTADUAL: TWideStringField;
    CdsCadastroDATA_EXPEDICAO_RG: TDateTimeField;
    CdsCadastroORGAO_EXPEDIDOR_RG: TWideStringField;
    CdsCadastroDATA_NASCIMENTO: TDateTimeField;
    CdsCadastroSEXO: TWideStringField;
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
    CdsCadastroCOMERCIAL_ENDERECO_ID: TFloatField;
    CdsCadastroCOMERCIAL_LOGRADOURO: TWideStringField;
    CdsCadastroCOMERCIAL_NUMERO: TWideStringField;
    CdsCadastroCOMERCIAL_COMPLEMENTO: TWideStringField;
    CdsCadastroCOMERCIAL_PONTO_REFERENCIA: TWideStringField;
    CdsCadastroCOMERCIAL_CEP: TWideStringField;
    CdsCadastroCOMERCIAL_BAIRRO: TWideStringField;
    CdsCadastroCOMERCIAL_NOME_CONTATO: TWideStringField;
    CdsCadastroCOMERCIAL_TELEFONE_1: TWideStringField;
    CdsCadastroCOMERCIAL_TELEFONE_2: TWideStringField;
    CdsCadastroCOMERCIAL_CELULAR: TWideStringField;
    CdsCadastroCOMERCIAL_EMAIL: TWideStringField;
    CdsCadastroCOMERCIAL_CIDADE_ID: TFloatField;
    CdsCadastroCOMERCIAL_CIDADE: TWideStringField;
    CdsCadastroCOBRANCA_ENDERECO_ID: TFloatField;
    CdsCadastroCOBRANCA_LOGRADOURO: TWideStringField;
    CdsCadastroCOBRANCA_NUMERO: TWideStringField;
    CdsCadastroCOBRANCA_COMPLEMENTO: TWideStringField;
    CdsCadastroCOBRANCA_PONTO_REFERENCIA: TWideStringField;
    CdsCadastroCOBRANCA_CEP: TWideStringField;
    CdsCadastroCOBRANCA_BAIRRO: TWideStringField;
    CdsCadastroCOBRANCA_NOME_CONTATO: TWideStringField;
    CdsCadastroCOBRANCA_TELEFONE_1: TWideStringField;
    CdsCadastroCOBRANCA_TELEFONE_2: TWideStringField;
    CdsCadastroCOBRANCA_CELULAR: TWideStringField;
    CdsCadastroCOBRANCA_EMAIL: TWideStringField;
    CdsCadastroCOBRANCA_CIDADE_ID: TFloatField;
    CdsCadastroCOBRANCA_CIDADE: TWideStringField;
    CdsCadastroCODIGO_REGIME_TRIBUTARIO: TWideStringField;
    BotaoGeraCPF: TUniSpeedButton;
    LabelCpfCnpj: TUniLabel;
    UniImageList5: TUniImageList;
    procedure UniFormShow(Sender: TObject);
    procedure BotaoCEPGeralClick(Sender: TObject);
    procedure ButtonPesquisaCidadeGeralClick(Sender: TObject);
    procedure BotaoPesquisaPessoaClick(Sender: TObject);
    procedure DbComboTipoChange(Sender: TObject);
    procedure DBEditCepGeralExit(Sender: TObject);
    procedure BotaoGeraCPFClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function Abrir(Id: Integer): Boolean; override;
    function Novo(): Boolean; override;
    function Editar(Id: Integer): Boolean; override;
    function Salvar: Boolean; override;
    function Descartar: Boolean; override;
    procedure ConfiguraTipoPessoa;
  end;

function ControleCadastroResponsavel: TControleCadastroResponsavel;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, Base.Util, Controle.Consulta,
  Controle.Consulta.Modal.Pessoa, Controle.Consulta.Modal.Cidade;

function ControleCadastroResponsavel: TControleCadastroResponsavel;
begin
  Result := TControleCadastroResponsavel(UniMainModule.GetFormInstance(TControleCadastroResponsavel));
end;

{ TControleCadastroResponsavel }

function TControleCadastroResponsavel.Abrir(Id: Integer): Boolean;
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

  // Configura os componentes de acordo com o tipo de pessoa
  ConfiguraTipoPessoa;

  Result := True;
end;

procedure TControleCadastroResponsavel.BotaoCEPGeralClick(Sender: TObject);
begin
  inherited;
  VerificaCEP(BotaoCEPGeral,
              DBEditCepGeral,
              DBEditNum);
end;

procedure TControleCadastroResponsavel.BotaoGeraCPFClick(Sender: TObject);
begin
  inherited;
  DBEdtCpfCnpj.Text := UniMainModule.GeraCPF(False);
  DBEdtNome.SetFocus;
end;

procedure TControleCadastroResponsavel.BotaoPesquisaPessoaClick(
  Sender: TObject);
var
  PessoaId: Integer;
begin
  inherited;

  PessoaId := 0;

  with ControleConsultaModalPessoa do
  begin
    // Define o filtro fixo para a pesquisa (Tipo de Pessoa = F, J ou FJ)
    QryConsulta.Parameters.ParamByName('tipo').Value := 'FJ';

    // Abre o formulário em modal e aguarda
    if ShowModal = mrOk then
      // Pega o id da pessoa selecionada
      PessoaId := CdsConsulta.FieldByName('id').AsInteger;
  end;

  // Recarrega o responsavel com os dados da nova pessoa selecionada
  if PessoaId > 0 then
  begin
    // Recarrega os dados
    CdsCadastro.Close;
    QryCadastro.Parameters.ParamByName('id').Value := PessoaId;
    CdsCadastro.Open;

    CdsCadastro.Edit;
    CdsCadastro['ativo'] := 'SIM';

    // Não permite alterar o tipo de pessoa e cpf/cnpj após carregar
    // uma pessoa existente
    DBEdtCpfCnpj.Color    := clBtnFace;
    DBEdtCpfCnpj.ReadOnly := True;
    DBComboTipo.Enabled   := False;

    DbEditFantasia.SetFocus;
  end;
end;

procedure TControleCadastroResponsavel.ButtonPesquisaCidadeGeralClick(
  Sender: TObject);
var
  Tipo: String;
begin
  inherited;

  // Abre o formulário em modal e aguarda
  if ControleConsultaModalCidade.ShowModal = mrOk then
  with UniMainModule, ControleConsultaModalCidade do
  begin
    // Identifica o tipo de endereço que está sendo editado
    if Pos('COMERCIAL', UpperCase(TUniSpeedButton(Sender).Name)) > 0 then
      Tipo := 'comercial'
    else if Pos('COBRANCA', UpperCase(TUniSpeedButton(Sender).Name)) > 0 then
      Tipo := 'cobranca'
    else
      Tipo := 'geral';

    CdsCadastro.Edit;
    CdsCadastro[Tipo + '_cidade_id'] := CdsConsulta.FieldByName('id').AsInteger;
    CdsCadastro[Tipo + '_cidade']    := CdsConsulta.FieldByName('nome').AsString +
      ' / ' + CdsConsulta.FieldByName('uf').AsString;
  end;
end;

procedure TControleCadastroResponsavel.ConfiguraTipoPessoa;
begin

end;

procedure TControleCadastroResponsavel.DbComboTipoChange(Sender: TObject);
begin
  inherited;
  // Configura os componentes de acordo com o tipo de pessoa
  ConfiguraTipoPessoa;
  DBEdtCpfCnpj.Clear;
end;

procedure TControleCadastroResponsavel.DBEditCepGeralExit(Sender: TObject);
begin
  inherited;
//  if MessageDlg('Deseja consultar o cep?', mtConfirmation, mbYesNo) = mrYes then
//  begin
    BotaoCEPGeral.Click;
//  end;
end;

function TControleCadastroResponsavel.Descartar: Boolean;
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

function TControleCadastroResponsavel.Editar(Id: Integer): Boolean;
begin
  Result := False;

  // Pega o id do registro aberto se não tiver sido passado
  // como parâmtro
  if Id = 0 then
    Id := CdsCadastro.FieldByName('id').AsInteger;

  // Tenta abrir o registro
  if Abrir(Id) then
  begin
    // Libera o registro para edição
    CdsCadastro.Edit;

    // Bloqueia a mudança do tipo de pessoa e cpf/cnpj na edição.
    // NOTA: Se for necessário alterar o cpf/cnpj, deve ser feito pelo cadastro
    //       de pessoa. O tipo de pessoa nunca pode ser alterado depois de
    //       cadastrado.
    DBEdtCpfCnpj.Color           := clBtnFace;
    DBEdtCpfCnpj.Enabled         := True;
    DBComboTipo.Enabled          := False;
    //  BotaoPesquisaPessoa.Visible := False;

    Result := True;
  end;
end;

function TControleCadastroResponsavel.Novo(): Boolean;
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

    // Configura os componentes de acordo com o tipo de pessoa
    ConfiguraTipoPessoa;

    // Libera a mudança do tipo de pessoa e cpf/cnpj na inserção
    DBEdtCpfCnpj.Color           := clWindow;
    DBEdtCpfCnpj.ReadOnly        := False;
    DBComboTipo.Enabled          := True;
    BotaoPesquisaPessoa.Visible := True;

    Result := True;
  end;
end;

function TControleCadastroResponsavel.Salvar: Boolean;
Var
  PessoaId, EnderecoGEId, EnderecoCOId, EnderecoCBId, Endereco: Integer;
  Erro, Tipo: String;
begin
  inherited;

  Erro   := '';
  Result := False;

  if CdsCadastro.State in [dsInsert, dsEdit] then
  begin
    // Verifica o CNPJ
    if Trim(BaseUtil.RemoveMascara(DBEdtCpfCnpj.Text)) = '' then
    begin
      if Copy(DBComboTipo.Text, 1, 1) = 'F' then
        MessageDlg('É necessário informar o CPF.'^M''+ 'Dados incompletos', mtWarning, [mbOK])
      else
        MessageDlg('É necessário informar o CNPJ.'^M''+ 'Dados incompletos', mtWarning, [mbOK]);

      if not DBEdtCpfCnpj.ReadOnly then
        DBEdtCpfCnpj.SetFocus;
      Exit;
    end;

    // Valida CNPJ/CPF
    if Copy(DBComboTipo.Text, 1, 1) = 'F' then
    begin
      if BaseUtil.ValidaCPF(BaseUtil.RemoveMascara(Trim(DBEdtCpfCnpj.Text))) = False then
      begin
        MessageDlg('CPF inválido'^M''+ 'Dados incorretos', mtWarning, [mbOK]);
        Exit;
      end;
    end
    else if Copy(DBComboTipo.Text, 1, 1) = 'J' then
    begin
      if BaseUtil.ValidaCNPJ(BaseUtil.RemoveMascara(Trim(DBEdtCpfCnpj.Text))) = False then
      begin
        MessageDlg('CNPJ inválido'^M''+ 'Dados incorretos', mtWarning, [mbOK]);
        Exit;
      end;
    end;

    // Verifica o nome da pessoa
    if DBEdtNome.Text = '' then
    begin
      if Copy(DBComboTipo.Text, 1, 1) = 'F' then
        MessageDlg('É necessário informar o nome.'^M''+
                   'Dados incompletos', mtWarning, [mbOK])
      else
        MessageDlg('É necessário informar a razão social.'^M''+
                   'Dados incompletos', mtWarning, [mbOK]);

      DBEdtNome.SetFocus;
      Exit;
    end;

    // Valida email
    // Verifica o nome da pessoa
    if DBEditEmailGeral.Text <> '' then
    begin
      if ValidaEMail(DBEditEmailGeral.Text) = False then
      begin
        MessageDlg('É necessário informar um email correto.'^M''+
                   'Dados incompletos', mtWarning, [mbOK]);

        DBEditEmailGeral.SetFocus;
      Exit;

      end;
    end;

    // Verifica se é uma nova pessoa (pessoa_id = 0), e se é preciso
    // verificar a duplicidade do cpf/cnpj informado.
    //
    // NOTA: Os CPFs/CNPJs preenchidos com zeros são considerados nulos
    //       e são os unicos que podem ser repetidos. Nos demais caso, não
    //       deve ser permitido cadastrar mais de uma pessoa com o mesmo
    //       numero de cpf/cnpj.
    if (CdsCadastro.FieldByName('pessoa_id').AsInteger = 0) and
      (Trim(BaseUtil.RemoveMascara(DBEdtCpfCnpj.Text)) <> '00000000000') and
      (Trim(BaseUtil.RemoveMascara(DBEdtCpfCnpj.Text)) <> '00000000000000') then
    with UniMainModule do
    begin
      // Pesquisa o cpf/cnpj
      CdsAx1.Close;
      QryAx1.Parameters.Clear;
      QryAx1.SQL.Clear;
      QryAx1.SQL.Add('SELECT id');
      QryAx1.SQL.Add('  FROM pessoa');
      QryAx1.SQL.Add(' WHERE cpf_cnpj = :cpf_cnpj');
      QryAx1.Parameters.ParamByName('cpf_cnpj').Value := BaseUtil.RemoveMascara(DBEdtCpfCnpj.Text);
      CdsAx1.Open;

      // Verifica se encontrou alguma pessoa com o cpf/cnpj informado
      if not CdsAx1.IsEmpty and (CdsAx1.FieldByName('id').AsInteger > 0) then
      begin
        if Copy(DBComboTipo.Text, 1, 1) = 'F' then
           MessageDlg('O CNPJ informado já existe em outro cadastro (Vendedor, Fornecedor, etc..).'^M''+
                      'Utilize o botão de pesquisa, ao lado do campo CPF,' +
                      'para carregar os dados do cadastro existente.',mtWarning, [mbOK])
        else
           MessageDlg('O CNPJ informado já existe em outro cadastro (Vendedor, Fornecedor, etc..).'^M''+
                      'Utilize o botão de pesquisa, ao lado do campo CNPJ,' +
                      'para carregar os dados do cadastro existente.', mtWarning, [mbOK]);
        DBEdtCpfCnpj.SetFocus;
        CdsAx1.Close;
        Exit;
      end
      else
        CdsAx1.Close;
    end;

    // Confirma os dados
    CdsCadastro.Post;
  end;

  // Pega os ids do registro
  CadastroId   := CdsCadastro.FieldByName('id').AsInteger;
  PessoaId     := CdsCadastro.FieldByName('pessoa_id').AsInteger;
  EnderecoGEId := CdsCadastro.FieldByName('geral_endereco_id').AsInteger;
  EnderecoCOId := CdsCadastro.FieldByName('comercial_endereco_id').AsInteger;
  EnderecoCBId := CdsCadastro.FieldByName('cobranca_endereco_id').AsInteger;

  with UniMainModule do
  begin
    // Inicia a transação
    ADOConnection.BeginTrans;

    // Passo 1 - Salva os dados da pessoa
    QryAx1.Parameters.Clear;
    QryAx1.SQL.Clear;

    if PessoaId = 0 then
    begin
      // Gera um novo id para a pessoa
      PessoaId := GeraId('responsavel');

      // Insert
      QryAx1.SQL.Add('INSERT INTO pessoa (');
      QryAx1.SQL.Add('       id,');
      QryAx1.SQL.Add('       tipo,');
      QryAx1.SQL.Add('       razao_social,');
      QryAx1.SQL.Add('       nome_fantasia,');
      QryAx1.SQL.Add('       cpf_cnpj,');
      QryAx1.SQL.Add('       rg_insc_estadual,');
      QryAx1.SQL.Add('       data_expedicao_rg,');
      QryAx1.SQL.Add('       orgao_expedidor_rg,');
      QryAx1.SQL.Add('       data_nascimento,');
      QryAx1.SQL.Add('       sexo,');
      QryAx1.SQL.Add('       codigo_regime_tributario)');
      QryAx1.SQL.Add('VALUES (');
      QryAx1.SQL.Add('       :id,');
      QryAx1.SQL.Add('       :tipo,');
      QryAx1.SQL.Add('       :razao_social,');
      QryAx1.SQL.Add('       :nome_fantasia,');
      QryAx1.SQL.Add('       :cpf_cnpj,');
      QryAx1.SQL.Add('       :rg_insc_estadual,');
      QryAx1.SQL.Add('       :data_expedicao_rg,');
      QryAx1.SQL.Add('       :orgao_expedidor_rg,');
      QryAx1.SQL.Add('       :data_nascimento,');
      QryAx1.SQL.Add('       :sexo,');
      QryAx1.SQL.Add('       :codigo_regime_tributario)');
    end
    else
    begin
      // Update
      QryAx1.SQL.Add('UPDATE pessoa');
      QryAx1.SQL.Add('   SET tipo               = :tipo,');
      QryAx1.SQL.Add('       razao_social       = :razao_social,');
      QryAx1.SQL.Add('       nome_fantasia      = :nome_fantasia,');
      QryAx1.SQL.Add('       cpf_cnpj           = :cpf_cnpj,');
      QryAx1.SQL.Add('       rg_insc_estadual   = :rg_insc_estadual,');
      QryAx1.SQL.Add('       data_expedicao_rg  = :data_expedicao_rg,');
      QryAx1.SQL.Add('       orgao_expedidor_rg = :orgao_expedidor_rg,');
      QryAx1.SQL.Add('       data_nascimento    = :data_nascimento,');
      QryAx1.SQL.Add('       sexo               = :sexo,');
      QryAx1.SQL.Add('       codigo_regime_tributario  = :codigo_regime_tributario');
      QryAx1.SQL.Add(' WHERE id = :id');
    end;

    QryAx1.Parameters.ParamByName('id').Value                 := PessoaId;
    QryAx1.Parameters.ParamByName('tipo').Value               := Copy(CdsCadastro.FieldByName('tipo').AsString, 1, 1);
    QryAx1.Parameters.ParamByName('razao_social').Value       := CdsCadastro.FieldByName('razao_social').AsString;
    QryAx1.Parameters.ParamByName('nome_fantasia').Value      := CdsCadastro.FieldByName('nome_fantasia').AsString;
    QryAx1.Parameters.ParamByName('cpf_cnpj').Value           := Trim(BaseUtil.RemoveMascara(CdsCadastro.FieldByName('cpf_cnpj').AsString));
    QryAx1.Parameters.ParamByName('rg_insc_estadual').Value   := CdsCadastro.FieldByName('rg_insc_estadual').AsString;
    QryAx1.Parameters.ParamByName('orgao_expedidor_rg').Value := CdsCadastro.FieldByName('orgao_expedidor_rg').AsString;
    QryAx1.Parameters.ParamByName('sexo').Value               := Copy(CdsCadastro.FieldByName('sexo').AsString, 1, 1);

    if CdsCadastro.FieldByName('data_expedicao_rg').AsString <> '' then
      QryAx1.Parameters.ParamByName('data_expedicao_rg').Value := CdsCadastro.FieldByName('data_expedicao_rg').AsDateTime
    else
      QryAx1.Parameters.ParamByName('data_expedicao_rg').Value := '';

    if CdsCadastro.FieldByName('data_nascimento').AsString <> '' then
      QryAx1.Parameters.ParamByName('data_nascimento').Value := CdsCadastro.FieldByName('data_nascimento').AsDateTime
    else
      QryAx1.Parameters.ParamByName('data_nascimento').Value := '';

    QryAx1.Parameters.ParamByName('codigo_regime_tributario').Value := Copy(CdsCadastro.FieldByName('codigo_regime_tributario').AsString, 1, 1);

    try
      // Tenta salvar os dados

      QryAx1.ExecSQL;
    except
      on E: Exception do
        Erro := 'Não foi possível salvar os dados da pessoa.' + #13#13 + E.Message;
    end;
  end;

  // Passo 2 - Salva os enderecos da pessoa
  if Erro = '' then
  with UniMainModule do
  begin
    for Endereco := 1 to 1 do
    begin
      QryAx1.Parameters.Clear;
      QryAx1.SQL.Clear;

      if ((Endereco = 1) and (EnderecoGEId = 0)) or
         ((Endereco = 2) and (EnderecoCOId = 0)) or
         ((Endereco = 3) and (EnderecoCBId = 0)) then
      begin
        // Gera um novo id para o endereço
        if Endereco = 1 then
          // Endereço geral
          EnderecoGEId := GeraId('pessoa_endereco')
        else if Endereco = 2 then
          // Endereço comercial
          EnderecoCOId := GeraId('pessoa_endereco')
        else
          // Endereço de cobranca
          EnderecoCBId := GeraId('pessoa_endereco');

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

      if Endereco = 1 then
      begin
        // Endereço geral
        Tipo                                        := 'geral';
        QryAx1.Parameters.ParamByName('id').Value   := EnderecoGEId;
        QryAx1.Parameters.ParamByName('tipo').Value := 'GE';
      end
      else if Endereco = 2 then
      begin
        // Endereço comercial
        Tipo                                        := 'comercial';
        QryAx1.Parameters.ParamByName('id').Value   := EnderecoCOId;
        QryAx1.Parameters.ParamByName('tipo').Value := 'CO';
      end
      else
      begin
        // Endereço de cobrança
        Tipo                                        := 'cobranca';
        QryAx1.Parameters.ParamByName('id').Value   := EnderecoCBId;
        QryAx1.Parameters.ParamByName('tipo').Value := 'CB';
      end;

      QryAx1.Parameters.ParamByName('logradouro').Value       := CdsCadastro.FieldByName(Tipo + '_logradouro').AsString;
      QryAx1.Parameters.ParamByName('numero').Value           := CdsCadastro.FieldByName(Tipo + '_numero').AsString;
      QryAx1.Parameters.ParamByName('complemento').Value      := CdsCadastro.FieldByName(Tipo + '_complemento').AsString;
      QryAx1.Parameters.ParamByName('ponto_referencia').Value := CdsCadastro.FieldByName(Tipo + '_ponto_referencia').AsString;
      QryAx1.Parameters.ParamByName('cep').Value              := CdsCadastro.FieldByName(Tipo + '_cep').AsString;
      QryAx1.Parameters.ParamByName('bairro').Value           := CdsCadastro.FieldByName(Tipo + '_bairro').AsString;
      QryAx1.Parameters.ParamByName('nome_contato').Value     := CdsCadastro.FieldByName(Tipo + '_nome_contato').AsString;
      QryAx1.Parameters.ParamByName('telefone_1').Value       := CdsCadastro.FieldByName(Tipo + '_telefone_1').AsString;
      QryAx1.Parameters.ParamByName('telefone_2').Value       := CdsCadastro.FieldByName(Tipo + '_telefone_2').AsString;
      QryAx1.Parameters.ParamByName('celular').Value          := CdsCadastro.FieldByName(Tipo + '_celular').AsString;
      QryAx1.Parameters.ParamByName('email').Value            := CdsCadastro.FieldByName(Tipo + '_email').AsString;


      if CdsCadastro.FieldByName(Tipo + '_cidade_id').AsString <> '' then
        QryAx1.Parameters.ParamByName('cidade_id').Value := CdsCadastro.FieldByName(Tipo + '_cidade_id').AsInteger
      else
        QryAx1.Parameters.ParamByName('cidade_id').Value := '';

      try
        // Tenta salvar os dados
        QryAx1.ExecSQL;
      except
        on E: Exception do
        begin
          Erro := 'Não foi possível salvar os dados do endereço ' + tipo + '.'
            + #13#13 + E.Message;
          Break;
        end;
      end;
    end;
  end;

  // Passo 3 - Salva os dados do responsavel
  if Erro = '' then
  with UniMainModule do
  begin
    QryAx1.Parameters.Clear;
    QryAx1.SQL.Clear;

    if CadastroId = 0 then
    begin
      // O id do responsavel será igual ao id da pessoa (ver modelo E/R)
      CadastroId := PessoaId;
      // Insert
      QryAx1.SQL.Add('INSERT INTO responsavel (');
      QryAx1.SQL.Add('       id,');
      QryAx1.SQL.Add('       ativo,');
      QryAx1.SQL.Add('       observacao)');
      QryAx1.SQL.Add('VALUES (');
      QryAx1.SQL.Add('       :id,');
      QryAx1.SQL.Add('       :ativo,');
      QryAx1.SQL.Add('       :observacao)');
    end
    else
    begin
      // Update
      QryAx1.SQL.Add('UPDATE responsavel');
      QryAx1.SQL.Add('   SET ativo      = :ativo,');
      QryAx1.SQL.Add('       observacao = :observacao');
      QryAx1.SQL.Add(' WHERE id         = :id');
    end;

    QryAx1.Parameters.ParamByName('id').Value         := CadastroId;
    QryAx1.Parameters.ParamByName('ativo').Value      := Copy(CdsCadastro.FieldByName('ativo').AsString, 1, 1);
    QryAx1.Parameters.ParamByName('observacao').Value := CdsCadastro.FieldByName('observacao').AsString;

    try
      // Tenta salvar os dados
      QryAx1.ExecSQL;
    except
      on E: Exception do
        Erro := 'Não foi possível salvar os dados do responsável.' + #13#13 + E.Message;
    end;
  end;

  if Erro <> '' then
  begin
    // Descarta a transação
    UniMainModule.ADOConnection.RollbackTrans;
    MessageDlg('Falha ao salvar os dados.'^M''+ PChar(Erro), mtWarning, [mbOK]);
    CdsCadastro.Edit;
  end
  else
  begin
    // Confirma a transação
    UniMainModule.ADOConnection.CommitTrans;

    // Recarrega o registro
    Abrir(CadastroId);
    Result := True;
  end;
end;

procedure TControleCadastroResponsavel.UniFormShow(Sender: TObject);
begin
  inherited;
  UniPagePrincipal.Pages[1].Visible := False;
  UniPagePrincipal.Pages[2].Visible := False;
  UniPagePrincipal.ActivePageIndex := 0;
end;

end.
