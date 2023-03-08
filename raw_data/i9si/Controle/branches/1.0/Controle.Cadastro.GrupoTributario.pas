unit Controle.Cadastro.GrupoTributario;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Controle.Cadastro, 
  ACBrBase, ACBrSocket, ACBrCEP, Data.DB, Datasnap.DBClient, Datasnap.Provider,
  Data.Win.ADODB, uniGUIBaseClasses, uniGUIClasses, uniImageList, uniBitBtn,
  uniSpeedButton, uniLabel, uniButton, uniPanel, uniEdit, uniDBEdit,
  uniPageControl, uniMultiItem, uniComboBox, uniDBComboBox, uniGroupBox,
  uniSweetAlert, uniCheckBox, uniDBCheckBox, uniMemo, uniScrollBox,
  uniBasicGrid, uniDBGrid, uniDBNavigator, uniHTMLFrame;

type
  TtipoPanel = (tp01, tp02, tp03, tp04, tp05);


type
  TControleCadastroGrupoTributario = class(TControleCadastro)
    QryCadastroID: TFloatField;
    QryCadastroDESCRICAO: TWideStringField;
    QryCadastroCFOP: TWideStringField;
    QryCadastroICMS_SITUACAO_TRIBUTARIA: TWideStringField;
    QryCadastroICMS_MODALIDADE_BC: TWideStringField;
    QryCadastroICMS_ALIQUOTA: TFloatField;
    QryCadastroICMS_MODALIDADE_BC_ST: TWideStringField;
    QryCadastroICMS_ALIQUOTA_REDUCAO: TFloatField;
    QryCadastroICMS_ALIQUOTA_ST: TFloatField;
    QryCadastroIPI_SITUACAO_TRIBUTARIA: TWideStringField;
    QryCadastroIPI_TIPO_CALCULO: TWideStringField;
    QryCadastroIPI_VALOR_UNIDADE: TFloatField;
    QryCadastroIPI_CNPJ_PRODUTOR: TWideStringField;
    QryCadastroIPI_COD_ENQUADRAMENTO: TWideStringField;
    QryCadastroIPI_COD_SELO: TWideStringField;
    QryCadastroIPI_QUANT_SELO: TFloatField;
    QryCadastroPIS_SITUACAO_TRIBUTARIA: TWideStringField;
    QryCadastroPIS_TIPO_CALCULO: TWideStringField;
    QryCadastroPIS_ALIQUOTA: TFloatField;
    QryCadastroPIS_TIPO_CALCULO_ST: TWideStringField;
    QryCadastroPIS_ALIQUOTA_ST: TFloatField;
    QryCadastroCOFINS_SITUACAO_TRIBUTARIA: TWideStringField;
    QryCadastroCOFINS_TIPO_CALCULO: TWideStringField;
    QryCadastroCOFINS_ALIQUOTA: TFloatField;
    QryCadastroCOFINS_TIPO_CALCULO_ST: TWideStringField;
    QryCadastroCOFINS_ALIQUOTA_ST: TFloatField;
    CdsCadastroID: TFloatField;
    CdsCadastroDESCRICAO: TWideStringField;
    CdsCadastroCFOP: TWideStringField;
    CdsCadastroICMS_SITUACAO_TRIBUTARIA: TWideStringField;
    CdsCadastroICMS_MODALIDADE_BC: TWideStringField;
    CdsCadastroICMS_ALIQUOTA: TFloatField;
    CdsCadastroICMS_MODALIDADE_BC_ST: TWideStringField;
    CdsCadastroICMS_ALIQUOTA_REDUCAO: TFloatField;
    CdsCadastroICMS_ALIQUOTA_ST: TFloatField;
    CdsCadastroIPI_SITUACAO_TRIBUTARIA: TWideStringField;
    CdsCadastroIPI_TIPO_CALCULO: TWideStringField;
    CdsCadastroIPI_VALOR_UNIDADE: TFloatField;
    CdsCadastroIPI_CNPJ_PRODUTOR: TWideStringField;
    CdsCadastroIPI_COD_ENQUADRAMENTO: TWideStringField;
    CdsCadastroIPI_COD_SELO: TWideStringField;
    CdsCadastroIPI_QUANT_SELO: TFloatField;
    CdsCadastroPIS_SITUACAO_TRIBUTARIA: TWideStringField;
    CdsCadastroPIS_TIPO_CALCULO: TWideStringField;
    CdsCadastroPIS_ALIQUOTA: TFloatField;
    CdsCadastroPIS_TIPO_CALCULO_ST: TWideStringField;
    CdsCadastroPIS_ALIQUOTA_ST: TFloatField;
    CdsCadastroCOFINS_SITUACAO_TRIBUTARIA: TWideStringField;
    CdsCadastroCOFINS_TIPO_CALCULO: TWideStringField;
    CdsCadastroCOFINS_ALIQUOTA: TFloatField;
    CdsCadastroCOFINS_TIPO_CALCULO_ST: TWideStringField;
    CdsCadastroCOFINS_ALIQUOTA_ST: TFloatField;
    QryCadastroCFOP_DIFERENTE_UF_FORA_ESTADO: TWideStringField;
    CdsCadastroCFOP_DIFERENTE_UF_FORA_ESTADO: TWideStringField;
    QryCadastroICMS_ALIQUOTA_DEF: TFloatField;
    CdsCadastroICMS_ALIQUOTA_DEF: TFloatField;
    CdsProdutoTributosVariacao: TClientDataSet;
    DspProdutoTributosVariacao: TDataSetProvider;
    QryProdutoTributosVariacao: TADOQuery;
    DscProdutoTributosVariacao: TDataSource;
    QryProdutoTributosVariacaoID: TFMTBCDField;
    QryProdutoTributosVariacaoESTADO_ID: TFMTBCDField;
    QryProdutoTributosVariacaoUF: TWideStringField;
    QryProdutoTributosVariacaoCFOP: TWideStringField;
    QryProdutoTributosVariacaoICMS_SITUACAO_TRIBUTARIA: TWideStringField;
    QryProdutoTributosVariacaoICMS_ALIQUOTA_INTERESTADUAL: TBCDField;
    QryProdutoTributosVariacaoICMS_ALIQUOTA_MVA_ST: TBCDField;
    QryProdutoTributosVariacaoICMS_ALIQUOTA_ST: TBCDField;
    QryProdutoTributosVariacaoGRUPO_TRIBUTOS_ID: TFMTBCDField;
    CdsProdutoTributosVariacaoID: TFMTBCDField;
    CdsProdutoTributosVariacaoESTADO_ID: TFMTBCDField;
    CdsProdutoTributosVariacaoUF: TWideStringField;
    CdsProdutoTributosVariacaoCFOP: TWideStringField;
    CdsProdutoTributosVariacaoICMS_SITUACAO_TRIBUTARIA: TWideStringField;
    CdsProdutoTributosVariacaoICMS_ALIQUOTA_INTERESTADUAL: TBCDField;
    CdsProdutoTributosVariacaoICMS_ALIQUOTA_MVA_ST: TBCDField;
    CdsProdutoTributosVariacaoICMS_ALIQUOTA_ST: TBCDField;
    CdsProdutoTributosVariacaoGRUPO_TRIBUTOS_ID: TFMTBCDField;
    UniImageList3: TUniImageList;
    UniSweetExclusaoRegistro: TUniSweetAlert;
    QryCadastroCFOP_UF_DIFERENTE: TWideStringField;
    CdsCadastroCFOP_UF_DIFERENTE: TWideStringField;
    UniScrollBox1: TUniScrollBox;
    UniContainerPanelCFOP: TUniContainerPanel;
    UniGroupBoxCfop_tp01: TUniGroupBox;
    UniDBEdit1: TUniDBEdit;
    UniDBCheckBoxCfopSimples: TUniDBCheckBox;
    UniMemo1: TUniMemo;
    UniGroupBoxCfop_tp02: TUniGroupBox;
    UniDBEdit9: TUniDBEdit;
    UniMemo2: TUniMemo;
    UniDBEdit10: TUniDBEdit;
    UniDBCheckBoxCfopDetalhado: TUniDBCheckBox;
    UniContainerPanelICMS: TUniContainerPanel;
    UniGroupBoxICMS_tp01: TUniGroupBox;
    icms_01: TUniDBComboBox;
    UniGroupBoxICMS_tp02: TUniGroupBox;
    icms_02: TUniDBComboBox;
    icms_03: TUniDBComboBox;
    icms_04: TUniDBFormattedNumberEdit;
    UniGroupBoxICMS_tp03: TUniGroupBox;
    icms_06: TUniDBComboBox;
    icms_08: TUniDBComboBox;
    icms_07: TUniDBFormattedNumberEdit;
    UniGroupBoxICMS_tp04: TUniGroupBox;
    icms_12: TUniDBComboBox;
    icms_13: TUniDBComboBox;
    icms_14: TUniDBComboBox;
    icms_15: TUniDBEdit;
    icms_16: TUniDBFormattedNumberEdit;
    UniGroupBoxICMS_tp05: TUniGroupBox;
    icms_17: TUniDBComboBox;
    icms_18: TUniDBComboBox;
    icms_19: TUniDBFormattedNumberEdit;
    icms_20: TUniDBComboBox;
    UniGroupBoxICMS_tp06: TUniGroupBox;
    icms_24: TUniDBComboBox;
    icms_25: TUniDBComboBox;
    UniGroupBoxICMS_tp07: TUniGroupBox;
    icms_34: TUniDBComboBox;
    icms_35: TUniDBComboBox;
    UniGroupBoxICMS_tp08: TUniGroupBox;
    icms_26: TUniDBComboBox;
    icms_27: TUniDBComboBox;
    icms_31: TUniDBComboBox;
    icms_28: TUniDBComboBox;
    icms_29: TUniDBEdit;
    icms_30: TUniDBFormattedNumberEdit;
    UniContainerPanelIPI: TUniContainerPanel;
    UniGroupBoxIPI_tp01: TUniGroupBox;
    IPI_01: TUniDBComboBox;
    UniGroupBoxIPI_tp03: TUniGroupBox;
    IPI_02: TUniDBComboBox;
    IPI_03: TUniDBEdit;
    IPI_04: TUniDBEdit;
    IPI_06: TUniDBFormattedNumberEdit;
    IPI_05: TUniDBEdit;
    UniGroupBoxIPI_tp02: TUniGroupBox;
    IPI_07: TUniDBComboBox;
    IPI_10: TUniDBEdit;
    IPI_11: TUniDBEdit;
    IPI_13: TUniDBFormattedNumberEdit;
    IPI_09: TUniDBFormattedNumberEdit;
    IPI_08: TUniDBComboBox;
    IPI_12: TUniDBEdit;
    UniPanel7: TUniPanel;
    UniDBEdit8: TUniDBEdit;
    UniDBCheckBox2: TUniDBCheckBox;
    UniPanelICMSVariacaoEstado: TUniPanel;
    UniDBGridGrupoTribVar: TUniDBGrid;
    UniPanel5: TUniPanel;
    BotaoNovo: TUniButton;
    BotaoAbrir: TUniButton;
    BotaoApagar: TUniButton;
    UniContainerPanelPIS: TUniContainerPanel;
    UniGroupBoxPIS_tp01: TUniGroupBox;
    PIS_01: TUniDBComboBox;
    UniGroupBoxPIS_tp04: TUniGroupBox;
    PIS_10: TUniDBComboBox;
    UniGroupBoxPIS_tp02: TUniGroupBox;
    PIS_02: TUniDBComboBox;
    PIS_05: TUniDBFormattedNumberEdit;
    PIS_04: TUniDBComboBox;
    PIS_03: TUniDBFormattedNumberEdit;
    PIS_11: TUniDBComboBox;
    PIS_12: TUniDBFormattedNumberEdit;
    PIS_13: TUniDBComboBox;
    PIS_14: TUniDBFormattedNumberEdit;
    UniGroupBoxPIS_tp03: TUniGroupBox;
    PIS_06: TUniDBComboBox;
    PIS_09: TUniDBFormattedNumberEdit;
    PIS_08: TUniDBComboBox;
    PIS_07: TUniDBFormattedNumberEdit;
    QryCadastroICMS_MOTIVO_DESONERACAO: TWideStringField;
    CdsCadastroICMS_MOTIVO_DESONERACAO: TWideStringField;
    QryCadastroICMS_MARGEM_VALOR_ADICIONADO: TFloatField;
    CdsCadastroICMS_MARGEM_VALOR_ADICIONADO: TFloatField;
    QryCadastroICMS_ALIQUOTA_REDUCAO_ST: TFloatField;
    CdsCadastroICMS_ALIQUOTA_REDUCAO_ST: TFloatField;
    UniContainerPanelCOFINS: TUniContainerPanel;
    UniGroupBoxCOFINS_tp01: TUniGroupBox;
    COFINS_01: TUniDBComboBox;
    UniGroupBoxCOFINS_tp03: TUniGroupBox;
    COFINS_06: TUniDBComboBox;
    COFINS_09: TUniDBFormattedNumberEdit;
    COFINS_08: TUniDBComboBox;
    COFINS_07: TUniDBFormattedNumberEdit;
    UniGroupBoxCOFINS_tp04: TUniGroupBox;
    COFINS_10: TUniDBComboBox;
    COFINS_11: TUniDBComboBox;
    COFINS_12: TUniDBFormattedNumberEdit;
    COFINS_13: TUniDBComboBox;
    COFINS_14: TUniDBFormattedNumberEdit;
    UniGroupBoxCOFINS_tp02: TUniGroupBox;
    COFINS_02: TUniDBComboBox;
    COFINS_05: TUniDBFormattedNumberEdit;
    COFINS_04: TUniDBComboBox;
    COFINS_03: TUniDBFormattedNumberEdit;
    icms_05: TUniDBComboBox;
    icms_09: TUniDBFormattedNumberEdit;
    icms_10: TUniDBFormattedNumberEdit;
    icms_11: TUniDBFormattedNumberEdit;
    icms_21: TUniDBFormattedNumberEdit;
    icms_22: TUniDBFormattedNumberEdit;
    icms_23: TUniDBFormattedNumberEdit;
    icms_32: TUniDBFormattedNumberEdit;
    icms_33: TUniDBFormattedNumberEdit;
    icms_36: TUniDBFormattedNumberEdit;
    icms_37: TUniDBFormattedNumberEdit;
    icms_38: TUniDBFormattedNumberEdit;
    QryCadastroPIS_VALOR_UNIDADE: TFloatField;
    QryCadastroPIS_VALOR_UNIDADE_ST: TFloatField;
    CdsCadastroPIS_VALOR_UNIDADE: TFloatField;
    CdsCadastroPIS_VALOR_UNIDADE_ST: TFloatField;
    QryCadastroIPI_ALIQUOTA: TFloatField;
    CdsCadastroIPI_ALIQUOTA: TFloatField;
    QryCadastroCOFINS_VALOR_UNIDADE_ST: TFloatField;
    CdsCadastroCOFINS_VALOR_UNIDADE_ST: TFloatField;
    QryCadastroICMS_PRECO_UNITARIO_PAUTA_ST: TFloatField;
    CdsCadastroICMS_PRECO_UNITARIO_PAUTA_ST: TFloatField;
    procedure UniFormShow(Sender: TObject);
    procedure UniDBCheckBoxCfopSimplesClick(Sender: TObject);
    procedure icms_01Change(Sender: TObject);
    procedure BotaoNovoClick(Sender: TObject);
    procedure BotaoAbrirClick(Sender: TObject);
    procedure BotaoApagarClick(Sender: TObject);
    procedure UniSweetExclusaoRegistroConfirm(Sender: TObject);
    procedure CdsProdutoTributosVariacaoAfterRefresh(DataSet: TDataSet);
    procedure CdsProdutoTributosVariacaoAfterOpen(DataSet: TDataSet);
    procedure UniPanelICMSVariacaoEstadoResize(Sender: TUniControl; OldWidth,
      OldHeight: Integer);
    procedure IPI_01Change(Sender: TObject);
    procedure PIS_01Change(Sender: TObject);
    procedure icms_20Change(Sender: TObject);
    procedure icms_08Change(Sender: TObject);
    procedure COFINS_01Change(Sender: TObject);
    procedure PIS_04Change(Sender: TObject);
    procedure PIS_08Change(Sender: TObject);
    procedure PIS_13Change(Sender: TObject);
    procedure COFINS_04Change(Sender: TObject);
    procedure COFINS_08Change(Sender: TObject);
    procedure COFINS_13Change(Sender: TObject);
    procedure IPI_08Change(Sender: TObject);
    procedure PIS_11Change(Sender: TObject);
  private
    procedure HabilitaDesabilitaPanelCFOP(tipo: TtipoPanel);
    procedure HabilitaDesabilitaPanelICMS(CST_CSOSN: string);
    procedure HabilitaDesabilitaPanelIPI(CST_IPI: string);
    procedure RedimensionaGrid;
    procedure Apagar(Id: Integer; tabela: String);
    procedure PreencheSituacaoTributariaICMS;
    procedure PreencheSituacaoTributariaIPI;
    procedure PreencheSituacaoTributariaPIS;
    procedure PreencheSituacaoTributariaCOFINS;
    procedure ExibeControlesCFOP;
    procedure HabilitaDesabilitaPanelPIS(CST_PIS: string);
    procedure HabilitaDesabilitaPanelCOFINS(CST_COFINS: string);
    procedure VerificaSituacaoICMS_20;
    procedure VerificaSituacaoICMS_08;
    procedure VerificaSituacaoIPI_08;
    procedure VerificaSituacaoPIS_05;
    procedure VerificaSituacaoPIS_09;
    procedure VerificaSituacaoPIS_14;
    procedure VerificaSituacaoCOFINS_05;
    procedure VerificaSituacaoCOFINS_09;
    procedure VerificaSituacaoCOFINS_14;
    procedure VerificaSituacaoPIS_12;
    procedure CarregaGrupoTributos;
    function ValidaCampos: Boolean;
    procedure Mensagem(Campo: string);

    { Private declarations }
  public
    { Public declarations }
    function Abrir(Id: Integer): Boolean; override;
    function Novo(): Boolean; override;
    function Editar(Id: Integer): Boolean; override;
    function Salvar: Boolean; override;
    function Descartar: Boolean; override;
  end;

function
  ControleCadastroGrupoTributario: TControleCadastroGrupoTributario;

implementation

{$R *.dfm}

uses Controle.Main.Module, Controle.Cadastro.GrupoTributario.Estados,
  Controle.Funcoes;

var
  Retorno: Boolean;

{ TControleCadastroGrupoTributario }

function ControleCadastroGrupoTributario: TControleCadastroGrupoTributario;
begin
  Result := TControleCadastroGrupoTributario(ControleMainModule.GetFormInstance(TControleCadastroGrupoTributario));
end;

function TControleCadastroGrupoTributario.Abrir(Id: Integer): Boolean;
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

function TControleCadastroGrupoTributario.Descartar: Boolean;
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

function TControleCadastroGrupoTributario.Editar(Id: Integer): Boolean;
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

function TControleCadastroGrupoTributario.Novo: Boolean;
begin
  Result := False;

  // Tenta abrir sem dados
  if Abrir(0) then
  begin
    // Libera o registro para edição
    DscCadastro.AutoEdit := True;

    // Adiciona um novo registro em branco
    CdsCadastro.Append;
   // Se for simples - crt = 1
    if ControleMainModule.FCodigoRegimeTributario = '1' then
      CdsCadastroICMS_SITUACAO_TRIBUTARIA.AsString := '101 : Tributada pelo Simples Nacional com permissão de crédito'
    else if ControleMainModule.FCodigoRegimeTributario = '3' then
      CdsCadastroICMS_SITUACAO_TRIBUTARIA.AsString := '00 : Tributada integralmente';
    CdsCadastroCFOP_DIFERENTE_UF_FORA_ESTADO.AsString := 'N';

    CdsCadastroIPI_SITUACAO_TRIBUTARIA.AsString    := 'Não usar';
    CdsCadastroPIS_SITUACAO_TRIBUTARIA.AsString    := 'Não usar';
    CdsCadastroPIS_TIPO_CALCULO_ST.AsString        := 'Não usar';
    CdsCadastroCOFINS_SITUACAO_TRIBUTARIA.AsString := 'Não usar';

    Result := True;
  end;
end;

function TControleCadastroGrupoTributario.Salvar: Boolean;
begin
  inherited;

  Result := False;

  // Validaçoes de campos
  if Trim(CdsCadastroCFOP.AsString) = '' then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção','É necessário informar o cfop.');
    Exit;
  end;

  if Length(Trim(CdsCadastroCFOP.AsString)) <> 4 then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção','É necessário informar o cfop com 4 digitos.');
    Exit;
  end;

  // Validação demais campos
  if ValidaCampos = False then
    Exit;

  with ControleMainModule do
  begin
    if CdsCadastro.State in [dsInsert, dsEdit] then
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
      // Gera um novo id para a tabela grupo_tributos
      CadastroId := GeraId('grupo_tributos');
      // Insert
      QryAx1.SQL.Text :=
                             'INSERT INTO grupo_tributos ('
                           + ' id,'
                           + ' descricao,'
                           + ' cfop,'
                           + ' cfop_uf_diferente,'
                           + ' icms_situacao_tributaria,'
                           + ' icms_modalidade_bc,'
                           + ' icms_aliquota,'
                           + ' icms_modalidade_bc_st,'
                           + ' icms_aliquota_reducao,'
                           + ' icms_aliquota_st,'
                           + ' icms_motivo_desoneracao,'
                           + ' icms_margem_valor_adicionado,'
                           + ' icms_aliquota_reducao_st,'
                           + ' ipi_situacao_tributaria,'
                           + ' ipi_tipo_calculo,'
                           + ' ipi_valor_unidade,'
                           + ' ipi_cnpj_produtor,'
                           + ' ipi_cod_enquadramento,'
                           + ' ipi_cod_selo,'
                           + ' ipi_quant_selo,'
                           + ' pis_situacao_tributaria,'
                           + ' pis_tipo_calculo,'
                           + ' pis_aliquota,'
                           + ' pis_tipo_calculo_st,'
                           + ' pis_aliquota_st,'
                           + ' pis_valor_unidade,'
                           + ' pis_valor_unidade_st,'
                           + ' cofins_situacao_tributaria,'
                           + ' cofins_tipo_calculo,'
                           + ' cofins_aliquota,'
                           + ' cofins_tipo_calculo_st,'
                           + ' cofins_aliquota_st,'
                           + ' cfop_diferente_uf_fora_estado)'
                           + ' VALUES ('
                           + ' :id,'
                           + ' :descricao,'
                           + ' :cfop,'
                           + ' :cfop_uf_diferente,'
                           + ' :icms_situacao_tributaria,'
                           + ' :icms_modalidade_bc,'
                           + ' :icms_aliquota,'
                           + ' :icms_modalidade_bc_st,'
                           + ' :icms_aliquota_reducao,'
                           + ' :icms_aliquota_st,'
                           + ' :icms_motivo_desoneracao,'
                           + ' :icms_margem_valor_adicionado,'
                           + ' :icms_aliquota_reducao_st,'
                           + ' :ipi_situacao_tributaria,'
                           + ' :ipi_tipo_calculo,'
                           + ' :ipi_valor_unidade,'
                           + ' :ipi_cnpj_produtor,'
                           + ' :ipi_cod_enquadramento,'
                           + ' :ipi_cod_selo,'
                           + ' :ipi_quant_selo,'
                           + ' :pis_situacao_tributaria,'
                           + ' :pis_tipo_calculo,'
                           + ' :pis_aliquota,'
                           + ' :pis_tipo_calculo_st,'
                           + ' :pis_aliquota_st,'
                           + ' :pis_valor_unidade,'
                           + ' :pis_valor_unidade_st,'
                           + ' :cofins_situacao_tributaria,'
                           + ' :cofins_tipo_calculo,'
                           + ' :cofins_aliquota,'
                           + ' :cofins_tipo_calculo_st,'
                           + ' :cofins_aliquota_st,'
                           + ' :cfop_diferente_uf_fora_estado)';
    end
    else
    begin
      // Update
      QryAx1.SQL.Text :=
                              ' UPDATE grupo_tributos SET'
                            + '        descricao      = :descricao,'
                            + '        cfop      = :cfop,'
                            + '        cfop_uf_diferente      = :cfop_uf_diferente,'
                            + '        icms_situacao_tributaria      = :icms_situacao_tributaria,'
                            + '        icms_modalidade_bc      = :icms_modalidade_bc,'
                            + '        icms_aliquota      = :icms_aliquota,'
                            + '        icms_modalidade_bc_st      = :icms_modalidade_bc_st,'
                            + '        icms_aliquota_reducao      = :icms_aliquota_reducao,'
                            + '        icms_aliquota_st      = :icms_aliquota_st,'
                            + '        icms_motivo_desoneracao      = :icms_motivo_desoneracao,'
                            + '        icms_margem_valor_adicionado      = :icms_margem_valor_adicionado,'
                            + '        icms_aliquota_reducao_st      = :icms_aliquota_reducao_st,'
                            + '        ipi_situacao_tributaria      = :ipi_situacao_tributaria,'
                            + '        ipi_tipo_calculo      = :ipi_tipo_calculo,'
                            + '        ipi_valor_unidade      = :ipi_valor_unidade,'
                            + '        ipi_cnpj_produtor      = :ipi_cnpj_produtor,'
                            + '        ipi_cod_enquadramento      = :ipi_cod_enquadramento,'
                            + '        ipi_cod_selo      = :ipi_cod_selo,'
                            + '        ipi_quant_selo      = :ipi_quant_selo,'
                            + '        pis_situacao_tributaria      = :pis_situacao_tributaria,'
                            + '        pis_tipo_calculo      = :pis_tipo_calculo,'
                            + '        pis_aliquota      = :pis_aliquota,'
                            + '        pis_tipo_calculo_st      = :pis_tipo_calculo_st,'
                            + '        pis_aliquota_st      = :pis_aliquota_st,'
                            + '        pis_valor_unidade      = :pis_valor_unidade,'
                            + '        pis_valor_unidade_st      = :pis_valor_unidade_st,'
                            + '        cofins_situacao_tributaria      = :cofins_situacao_tributaria,'
                            + '        cofins_tipo_calculo      = :cofins_tipo_calculo,'
                            + '        cofins_aliquota      = :cofins_aliquota,'
                            + '        cofins_tipo_calculo_st      = :cofins_tipo_calculo_st,'
                            + '        cofins_aliquota_st      = :cofins_aliquota_st,'
                            + '        cfop_diferente_uf_fora_estado   = :cfop_diferente_uf_fora_estado'
                            + '  WHERE id          = :id';
    end;

    QryAx1.Parameters.ParamByName('id').Value          := CadastroId;
    QryAx1.Parameters.ParamByName('descricao').Value       := CdsCadastro.FieldByName('descricao').AsString;
    QryAx1.Parameters.ParamByName('cfop').Value       := 'x' + Copy(CdsCadastro.FieldByName('cfop').AsString,2,3);
    if CdsCadastro.FieldByName('cfop_diferente_uf_fora_estado').AsString = 'S' then
      QryAx1.Parameters.ParamByName('cfop_uf_diferente').Value       := 'x' + Copy(CdsCadastro.FieldByName('cfop_uf_diferente').AsString,2,3)
    else if CdsCadastro.FieldByName('cfop_diferente_uf_fora_estado').AsString = 'N' then
      QryAx1.Parameters.ParamByName('cfop_uf_diferente').Value       := '';
    QryAx1.Parameters.ParamByName('icms_situacao_tributaria').Value       := CdsCadastro.FieldByName('icms_situacao_tributaria').AsString;
    QryAx1.Parameters.ParamByName('icms_modalidade_bc').Value       := CdsCadastro.FieldByName('icms_modalidade_bc').AsString;
    QryAx1.Parameters.ParamByName('icms_aliquota').Value       := StringReplace(CdsCadastro.FieldByName('icms_aliquota').AsString,',','.',[rfReplaceAll, rfIgnoreCase]);
    QryAx1.Parameters.ParamByName('icms_modalidade_bc_st').Value       := CdsCadastro.FieldByName('icms_modalidade_bc_st').AsString;
    QryAx1.Parameters.ParamByName('icms_aliquota_reducao').Value       := StringReplace(CdsCadastro.FieldByName('icms_aliquota_reducao').AsString,',','.',[rfReplaceAll, rfIgnoreCase]);
    QryAx1.Parameters.ParamByName('icms_aliquota_st').Value       := StringReplace(CdsCadastro.FieldByName('icms_aliquota_st').AsString,',','.',[rfReplaceAll, rfIgnoreCase]);
    QryAx1.Parameters.ParamByName('icms_motivo_desoneracao').Value       := CdsCadastro.FieldByName('icms_motivo_desoneracao').AsString;
    QryAx1.Parameters.ParamByName('icms_margem_valor_adicionado').Value       := StringReplace(CdsCadastro.FieldByName('icms_margem_valor_adicionado').AsString,',','.',[rfReplaceAll, rfIgnoreCase]);
    QryAx1.Parameters.ParamByName('icms_aliquota_reducao_st').Value       := StringReplace(CdsCadastro.FieldByName('icms_aliquota_reducao_st').AsString,',','.',[rfReplaceAll, rfIgnoreCase]);
    QryAx1.Parameters.ParamByName('ipi_situacao_tributaria').Value       := CdsCadastro.FieldByName('ipi_situacao_tributaria').AsString;
    QryAx1.Parameters.ParamByName('ipi_tipo_calculo').Value       := CdsCadastro.FieldByName('ipi_tipo_calculo').AsString;
    QryAx1.Parameters.ParamByName('ipi_valor_unidade').Value       := StringReplace(CdsCadastro.FieldByName('ipi_valor_unidade').AsString,',','.',[rfReplaceAll, rfIgnoreCase]);
    QryAx1.Parameters.ParamByName('ipi_cnpj_produtor').Value       := CdsCadastro.FieldByName('ipi_cnpj_produtor').AsString;
    QryAx1.Parameters.ParamByName('ipi_cod_enquadramento').Value       := CdsCadastro.FieldByName('ipi_cod_enquadramento').AsString;
    QryAx1.Parameters.ParamByName('ipi_cod_selo').Value       := CdsCadastro.FieldByName('ipi_cod_selo').AsString;
    QryAx1.Parameters.ParamByName('ipi_quant_selo').Value       := CdsCadastro.FieldByName('ipi_quant_selo').AsString;
    QryAx1.Parameters.ParamByName('pis_situacao_tributaria').Value       := CdsCadastro.FieldByName('pis_situacao_tributaria').AsString;
    QryAx1.Parameters.ParamByName('pis_tipo_calculo').Value       := CdsCadastro.FieldByName('pis_tipo_calculo').AsString;
    QryAx1.Parameters.ParamByName('pis_aliquota').Value       := StringReplace(CdsCadastro.FieldByName('pis_aliquota').AsString,',','.',[rfReplaceAll, rfIgnoreCase]);
    QryAx1.Parameters.ParamByName('pis_tipo_calculo_st').Value       := CdsCadastro.FieldByName('pis_tipo_calculo_st').AsString;
    QryAx1.Parameters.ParamByName('pis_aliquota_st').Value       := StringReplace(CdsCadastro.FieldByName('pis_aliquota_st').AsString,',','.',[rfReplaceAll, rfIgnoreCase]);
    QryAx1.Parameters.ParamByName('pis_valor_unidade').Value       := StringReplace(CdsCadastro.FieldByName('pis_valor_unidade').AsString,',','.',[rfReplaceAll, rfIgnoreCase]);
    QryAx1.Parameters.ParamByName('pis_valor_unidade_st').Value       := StringReplace(CdsCadastro.FieldByName('pis_valor_unidade_st').AsString,',','.',[rfReplaceAll, rfIgnoreCase]);
    QryAx1.Parameters.ParamByName('cofins_situacao_tributaria').Value       := CdsCadastro.FieldByName('cofins_situacao_tributaria').AsString;
    QryAx1.Parameters.ParamByName('cofins_tipo_calculo').Value       := CdsCadastro.FieldByName('cofins_tipo_calculo').AsString;
    QryAx1.Parameters.ParamByName('cofins_aliquota').Value       := StringReplace(CdsCadastro.FieldByName('cofins_aliquota').AsString,',','.',[rfReplaceAll, rfIgnoreCase]);
    QryAx1.Parameters.ParamByName('cofins_tipo_calculo_st').Value       := CdsCadastro.FieldByName('cofins_tipo_calculo_st').AsString;
    QryAx1.Parameters.ParamByName('cofins_aliquota_st').Value       := StringReplace(CdsCadastro.FieldByName('cofins_aliquota_st').AsString,',','.',[rfReplaceAll, rfIgnoreCase]);
    QryAx1.Parameters.ParamByName('cfop_diferente_uf_fora_estado').Value       := CdsCadastro.FieldByName('cfop_diferente_uf_fora_estado').AsString;

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

procedure TControleCadastroGrupoTributario.BotaoAbrirClick(Sender: TObject);
begin
  inherited;
  // Abre o formulário de cadastro para visualização e edição
  // := TControleCadastroBanco.Create(Self);
  ControleCadastroGrupoTributarioEstados.grupo_tributos_id := CdsCadastroID.AsInteger;
  if ControleCadastroGrupoTributarioEstados.Abrir(CdsProdutoTributosVariacaoID.AsInteger) then
  begin
    ControleCadastroGrupoTributarioEstados.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
//      if Result = 1 then
      CdsProdutoTributosVariacao.Refresh;
    end);
  end;
end;

procedure TControleCadastroGrupoTributario.BotaoApagarClick(Sender: TObject);
begin
  inherited;
  UniSweetExclusaoRegistro.Show;
end;

procedure TControleCadastroGrupoTributario.BotaoNovoClick(Sender: TObject);
begin
  inherited;
  ControleCadastroGrupoTributarioEstados.grupo_tributos_id := CdsCadastroID.AsInteger;
  if ControleCadastroGrupoTributarioEstados.Novo() then
  begin
    ControleCadastroGrupoTributarioEstados.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
//      if Result = 1 then
        CdsProdutoTributosVariacao.Refresh;
    end);
  end;
end;

procedure TControleCadastroGrupoTributario.CdsProdutoTributosVariacaoAfterOpen(
  DataSet: TDataSet);
begin
  inherited;
  RedimensionaGrid;
end;

procedure TControleCadastroGrupoTributario.CdsProdutoTributosVariacaoAfterRefresh(
  DataSet: TDataSet);
begin
  inherited;
  RedimensionaGrid;
end;

procedure TControleCadastroGrupoTributario.UniDBCheckBoxCfopSimplesClick(Sender: TObject);
begin
  inherited;
  Salvar;
  BotaoEditar.Click;
end;

procedure TControleCadastroGrupoTributario.icms_08Change(
  Sender: TObject);
begin
  inherited;
  VerificaSituacaoICMS_08;
end;

procedure TControleCadastroGrupoTributario.icms_20Change(
  Sender: TObject);
begin
  inherited;
  VerificaSituacaoICMS_20;
end;

procedure TControleCadastroGrupoTributario.COFINS_01Change(
  Sender: TObject);
begin
  inherited;
  HabilitaDesabilitaPanelCOFINS(Copy(CdsCadastroCOFINS_SITUACAO_TRIBUTARIA.AsString,1,2));
end;

procedure TControleCadastroGrupoTributario.COFINS_04Change(Sender: TObject);
begin
  inherited;
  VerificaSituacaoCOFINS_05;
end;

procedure TControleCadastroGrupoTributario.COFINS_08Change(Sender: TObject);
begin
  inherited;
  VerificaSituacaoCOFINS_09;
end;

procedure TControleCadastroGrupoTributario.COFINS_13Change(Sender: TObject);
begin
  inherited;
  VerificaSituacaoCOFINS_14;
end;

procedure TControleCadastroGrupoTributario.icms_01Change(
  Sender: TObject);
begin
  inherited;
  HabilitaDesabilitaPanelICMS(Copy(CdsCadastroICMS_SITUACAO_TRIBUTARIA.AsString,1,2));
end;

procedure TControleCadastroGrupoTributario.IPI_01Change(
  Sender: TObject);
begin
  inherited;
  HabilitaDesabilitaPanelIPI(Copy(CdsCadastroIPI_SITUACAO_TRIBUTARIA.AsString,1,2));
end;

procedure TControleCadastroGrupoTributario.IPI_08Change(Sender: TObject);
begin
  inherited;
  VerificaSituacaoIPI_08;
end;

procedure TControleCadastroGrupoTributario.PIS_01Change(
  Sender: TObject);
begin
  inherited;
  HabilitaDesabilitaPanelPIS(Copy(CdsCadastroPIS_SITUACAO_TRIBUTARIA.AsString,1,2));
end;

procedure TControleCadastroGrupoTributario.PIS_04Change(Sender: TObject);
begin
  inherited;
  VerificaSituacaoPIS_05;
end;

procedure TControleCadastroGrupoTributario.PIS_08Change(Sender: TObject);
begin
  inherited;
  VerificaSituacaoPIS_09;
end;

procedure TControleCadastroGrupoTributario.PIS_11Change(Sender: TObject);
begin
  inherited;
  VerificaSituacaoPIS_12;
end;

procedure TControleCadastroGrupoTributario.PIS_13Change(Sender: TObject);
begin
  inherited;
  VerificaSituacaoPIS_14;
end;

procedure TControleCadastroGrupoTributario.UniFormShow(Sender: TObject);
begin
  inherited;
  ControleCadastroGrupoTributario.Height := 700;

  CarregaGrupoTributos;

  // Filtrando as variações do grupo tributario por estado
  CdsProdutoTributosVariacao.Close;
  QryProdutoTributosVariacao.Parameters.ParamByName('grupo_tributos_id').Value := CdsCadastroID.AsInteger;
  CdsProdutoTributosVariacao.Open;

  RedimensionaGrid;
end;

procedure TControleCadastroGrupoTributario.UniPanelICMSVariacaoEstadoResize(
  Sender: TUniControl; OldWidth, OldHeight: Integer);
begin
  inherited;
  RedimensionaGrid;
end;

procedure TControleCadastroGrupoTributario.UniSweetExclusaoRegistroConfirm(
  Sender: TObject);
begin
  inherited;
  Apagar(CdsProdutoTributosVariacao.FieldByName('id').AsInteger,
         'grupo_tributos_variacao_uf');
end;

procedure TControleCadastroGrupoTributario.HabilitaDesabilitaPanelCFOP(tipo: TtipoPanel); // simples - // detalhado
begin
  if tipo = tp01 then
  begin
    UniGroupBoxCfop_tp01.Visible := True;
    UniGroupBoxCfop_tp02.Visible := False;
    UniContainerPanelCFOP.Height :=  UniGroupBoxCfop_tp01.Height + 5;
  end
  else if tipo = tp02 then
  begin
    UniGroupBoxCfop_tp01.Visible := False;
    UniGroupBoxCfop_tp02.Visible := True;
    UniContainerPanelCFOP.Height :=  UniGroupBoxCfop_tp02.Height + 5;
  end;
end;

procedure TControleCadastroGrupoTributario.HabilitaDesabilitaPanelICMS(CST_CSOSN: string);
begin
  UniGroupBoxICMS_tp01.Visible   := False;
  UniGroupBoxICMS_tp02.Visible   := False;
  UniGroupBoxICMS_tp03.Visible   := False;
  UniGroupBoxICMS_tp04.Visible   := False;
  UniGroupBoxICMS_tp05.Visible   := False;
  UniGroupBoxICMS_tp06.Visible   := False;
  UniGroupBoxICMS_tp07.Visible   := False;
  UniGroupBoxICMS_tp08.Visible   := False;

  if ControleMainModule.FCodigoRegimeTributario = '1' then
  begin

  end
  else if ControleMainModule.FCodigoRegimeTributario = '3' then
  begin
    if (CST_CSOSN) = '00'  then
    begin
      UniGroupBoxICMS_tp02.Visible      := True;
      UniContainerPanelICMS.Height := UniGroupBoxICMS_tp02.Height + 5;
    end
    else if CST_CSOSN = '10' then
    begin
      UniGroupBoxICMS_tp03.Visible      := True;
      UniContainerPanelICMS.Height := UniGroupBoxICMS_tp03.Height + 5;
    end
    else if CST_CSOSN = '20' then
    begin
      UniGroupBoxICMS_tp04.Visible      := True;
      UniContainerPanelICMS.Height := UniGroupBoxICMS_tp04.Height + 5;
    end
    else if CST_CSOSN = '30' then
    begin
      UniGroupBoxICMS_tp05.Visible      := True;
      UniContainerPanelICMS.Height := UniGroupBoxICMS_tp05.Height + 5;
    end
    else if (CST_CSOSN = '40') or (CST_CSOSN = '41') or (CST_CSOSN = '50') then
    begin
      UniGroupBoxICMS_tp06.Visible      := True;
      UniContainerPanelICMS.Height := UniGroupBoxICMS_tp06.Height + 5;
    end
    else if CST_CSOSN = '51' then
    begin
      UniGroupBoxICMS_tp07.Visible      := True;
      UniContainerPanelICMS.Height := UniGroupBoxICMS_tp07.Height + 5;
    end
    else if CST_CSOSN = '60' then
    begin
      UniGroupBoxICMS_tp01.Visible      := True;
      UniContainerPanelICMS.Height := UniGroupBoxICMS_tp01.Height + 5;
    end
    else if (CST_CSOSN = '70') or (CST_CSOSN = '90') then
    begin
      UniGroupBoxICMS_tp08.Visible      := True;
      UniContainerPanelICMS.Height := UniGroupBoxICMS_tp08.Height + 5;
    end
    else
    begin
      UniGroupBoxICMS_tp01.Visible      := True;
      UniContainerPanelICMS.Height := UniGroupBoxICMS_tp01.Height + 5;
    end;
  end;
end;

procedure TControleCadastroGrupoTributario.HabilitaDesabilitaPanelIPI(CST_IPI: string);
begin
  UniGroupBoxIPI_tp01.Visible   := False;
  UniGroupBoxIPI_tp02.Visible   := False;
  UniGroupBoxIPI_tp03.Visible   := False;

  if CST_IPI = '00' then
  begin
    UniGroupBoxIPI_tp02.Visible      := True;
    UniContainerPanelIPI.Height := UniGroupBoxIPI_tp02.Height + 5;
  end
  else if (CST_IPI = '01') or (CST_IPI = '02') or (CST_IPI = '03') or (CST_IPI = '04') or (CST_IPI = '05') then
  begin
    UniGroupBoxIPI_tp03.Visible      := True;
    UniContainerPanelIPI.Height := UniGroupBoxIPI_tp03.Height + 5;
  end
  else if (CST_IPI = '49') or (CST_IPI = '50') then
  begin
    UniGroupBoxIPI_tp02.Visible      := True;
    UniContainerPanelIPI.Height := UniGroupBoxIPI_tp02.Height + 5;
  end
  else if (CST_IPI = '51') or (CST_IPI = '52') or (CST_IPI = '53') or (CST_IPI = '54') or (CST_IPI = '55') then
  begin
    UniGroupBoxIPI_tp03.Visible      := True;
    UniContainerPanelIPI.Height := UniGroupBoxIPI_tp03.Height + 5;
  end
  else if CST_IPI = '99' then
  begin
    UniGroupBoxIPI_tp02.Visible      := True;
    UniContainerPanelIPI.Height := UniGroupBoxIPI_tp02.Height + 5;
  end
  else
  begin
    UniGroupBoxIPI_tp01.Visible      := True;
    UniContainerPanelIPI.Height := UniGroupBoxIPI_tp01.Height + 5;
  end;
end;

procedure TControleCadastroGrupoTributario.HabilitaDesabilitaPanelPIS(CST_PIS: string);
begin
  UniGroupBoxPIS_tp01.Visible   := False;
  UniGroupBoxPIS_tp02.Visible   := False;
  UniGroupBoxPIS_tp03.Visible   := False;
  UniGroupBoxPIS_tp04.Visible   := False;

  if (CST_PIS = '01') or (CST_PIS = '02') then
  begin
    UniGroupBoxPIS_tp02.Visible := True;
    PIS_03.Visible := True;
    UniContainerPanelPIS.Height := UniGroupBoxPIS_tp02.Height + 5;
  end
  else if CST_PIS = '03' then
  begin
    UniGroupBoxPIS_tp03.Visible := True;
    PIS_07.Visible := True;
    UniContainerPanelPIS.Height := UniGroupBoxPIS_tp03.Height + 5;
  end
  else if (CST_PIS = '04') or (CST_PIS = '05') or (CST_PIS = '06') or (CST_PIS = '07') or (CST_PIS = '08') or (CST_PIS = '09')then
  begin
    UniGroupBoxPIS_tp02.Visible := True;
    PIS_03.Visible := False;
    UniContainerPanelPIS.Height := UniGroupBoxPIS_tp02.Height + 5;
  end
  else if (CST_PIS = '49') or (CST_PIS = '50') or (CST_PIS = '51') or (CST_PIS = '52') or (CST_PIS = '53') or (CST_PIS = '54') or
          (CST_PIS = '55') or (CST_PIS = '56') or (CST_PIS = '60') or (CST_PIS = '61') or (CST_PIS = '62') or (CST_PIS = '63') or
          (CST_PIS = '64') or (CST_PIS = '70') or (CST_PIS = '71') or (CST_PIS = '72') or (CST_PIS = '73') or (CST_PIS = '74') or
          (CST_PIS = '75') or (CST_PIS = '98') or (CST_PIS = '99') then
  begin
    UniGroupBoxPIS_tp04.Visible := True;
    UniContainerPanelPIS.Height := UniGroupBoxPIS_tp04.Height + 5;
  end
  else
  begin
    UniGroupBoxPIS_tp01.Visible      := True;
    UniContainerPanelPIS.Height := UniGroupBoxPIS_tp01.Height + 5;
  end;
end;

procedure TControleCadastroGrupoTributario.HabilitaDesabilitaPanelCOFINS(CST_COFINS: string);
begin
  UniGroupBoxCOFINS_tp01.Visible   := False;
  UniGroupBoxCOFINS_tp02.Visible   := False;
  UniGroupBoxCOFINS_tp03.Visible   := False;
  UniGroupBoxCOFINS_tp04.Visible   := False;

  if (CST_COFINS = '01') or (CST_COFINS = '02') then
  begin
    UniGroupBoxCOFINS_tp02.Visible := True;
    COFINS_03.Visible := True;
    UniContainerPanelCOFINS.Height := UniGroupBoxCOFINS_tp02.Height + 5;
  end
  else if CST_COFINS = '03' then
  begin
    UniGroupBoxCOFINS_tp03.Visible := True;
    COFINS_07.Visible := True;
    UniContainerPanelCOFINS.Height := UniGroupBoxCOFINS_tp03.Height + 5;
  end
  else if (CST_COFINS = '04') or (CST_COFINS = '05') or (CST_COFINS = '06') or (CST_COFINS = '07') or (CST_COFINS = '08') or (CST_COFINS = '09')then
  begin
    UniGroupBoxCOFINS_tp02.Visible := True;
    COFINS_03.Visible := False;
    UniContainerPanelCOFINS.Height := UniGroupBoxCOFINS_tp02.Height + 5;
  end
  else if (CST_COFINS = '49') or (CST_COFINS = '50') or (CST_COFINS = '51') or (CST_COFINS = '52') or (CST_COFINS = '53') or (CST_COFINS = '54') or
          (CST_COFINS = '55') or (CST_COFINS = '56') or (CST_COFINS = '60') or (CST_COFINS = '61') or (CST_COFINS = '62') or (CST_COFINS = '63') or
          (CST_COFINS = '64') or (CST_COFINS = '70') or (CST_COFINS = '71') or (CST_COFINS = '72') or (CST_COFINS = '73') or (CST_COFINS = '74') or
          (CST_COFINS = '75') or (CST_COFINS = '98') or (CST_COFINS = '99') then
  begin
    UniGroupBoxCOFINS_tp04.Visible := True;
    UniContainerPanelCOFINS.Height := UniGroupBoxCOFINS_tp04.Height + 5;
  end
  else
  begin
    UniGroupBoxCOFINS_tp01.Visible      := True;
    UniContainerPanelCOFINS.Height := UniGroupBoxCOFINS_tp01.Height + 5;
  end;
end;

procedure TControleCadastroGrupoTributario.RedimensionaGrid;
Var
  alturaPanelInicio, tamanhoGrid : Integer;
begin
  inherited;
  alturaPanelInicio := 150;
  tamanhoGrid       := CdsProdutoTributosVariacao.RecordCount * 30;

  UniPanelICMSVariacaoEstado.Height := alturaPanelInicio + tamanhoGrid;
end;

procedure TControleCadastroGrupoTributario.Apagar(Id: Integer; tabela: String);
var
  Erro: String;
begin
  Erro := '';
  with ControleMainModule do
  begin
    // Inicia a transação
    ADOConnection.BeginTrans;

    QryAx1.Parameters.Clear;
    QryAx1.SQL.Clear;
    QryAx1.SQL.Text :=
        'DELETE FROM '+ tabela +''
      + ' WHERE id = :id';
    QryAx1.Parameters.ParamByName('id').Value := Id;

    try
      // Tenta apagar o registro
      QryAx1.ExecSQL;
    except
      on E: Exception do
      begin
        Erro := ControleFuncoes.RetiraAspaSimples(E.Message);
        ControleMainModule.MensageiroSweetAlerta('Atenção', Erro);
      end;
    end;

    if Erro = '' then
    begin
      // Confirma a transação
      ADOConnection.CommitTrans;

      // Atualiza a lista
      CdsProdutoTributosVariacao.Refresh;
    end
    else
    begin
      // Descarta a transação
      ADOConnection.RollbackTrans;
    end;
  end;
end;

procedure TControleCadastroGrupoTributario.PreencheSituacaoTributariaICMS;
begin
    // Preenchendo a situação tributario com base no codigo de regime tributario

  // Se for simples - crt = 1
  if ControleMainModule.FCodigoRegimeTributario = '1' then
  begin
    icms_01.Clear;
    // Simples Nacional
    with icms_01 do
    begin
      Items.Add('');
      Items.Add('101 : Tributada pelo Simples Nacional com permissão de crédito');
      Items.Add('102 : Tributada pelo Simples Nacional sem permissão de crédito');
      Items.Add('103 : Isenção do ICMS no Simples Nacional para faixa de receita bruta');
      Items.Add('201 : Tributada pelo Simples Nacional com permissão de créd e com cobrança do ICMS por subst tribut');
      Items.Add('202 : Tributada pelo Simples Nacional sem permissão de créd e com cobrança do ICMS por subst tribut');
      Items.Add('203 : Isenção do ICMS no Simples Nacional com cobrança do ICMS por subst tribut');
      Items.Add('300 : Imune');
      Items.Add('400 : Não tributada pelo Simples Nacional');
      Items.Add('500 : ICMS cobrado anteriormente por substituição tributária (substituído) ou por antecipação');
      Items.Add('900 :- Outro');
    end;
  end
  else if ControleMainModule.FCodigoRegimeTributario = '3' then
  begin
    // Regime normal
    icms_01.Clear;
    with icms_01 do
    begin
      Items.Add('');
      Items.Add('00 : Tributada integralmente');
      Items.Add('10 : Tributada e com cobrança do ICMS por substituição tributária');
      Items.Add('20 : Com redução da BC');
      Items.Add('30 : Isenta / não tributada e com cobrança do ICMS por substituição tributária');
      Items.Add('40 : Isenta');
      Items.Add('41 : Não tributada');
      Items.Add('50 : Com suspensão');
      Items.Add('51 : Com diferimento');
      Items.Add('60 : ICMS cobrado anteriormente por substituição tributária');
      Items.Add('70 : Com redução da BC e cobrança do ICMS por substituição tributária');
      Items.Add('90 : Outras');
    end;
  end;

  icms_02.Clear;
  icms_02.Items.Text := icms_01.Items.Text;

  icms_05.Clear;
  icms_05.Items.Text := icms_01.Items.Text;

  icms_12.Clear;
  icms_12.Items.Text := icms_01.Items.Text;

  icms_17.Clear;
  icms_17.Items.Text := icms_01.Items.Text;

  icms_24.Clear;
  icms_24.Items.Text := icms_01.Items.Text;

  icms_26.Clear;
  icms_26.Items.Text := icms_01.Items.Text;

  icms_34.Clear;
  icms_34.Items.Text := icms_01.Items.Text;
end;

procedure TControleCadastroGrupoTributario.PreencheSituacaoTributariaIPI;
begin
  IPI_01.Clear;
  // Simples Nacional
  with IPI_01 do
  begin
    Items.Add('Não usar');
    Items.Add('00: Entrada com recuperação de crédito');
    Items.Add('01: Entrada tributada com alíquota zero');
    Items.Add('02: Entrada isenta');
    Items.Add('03: Entrada não-tributada');
    Items.Add('04: Entrada imune');
    Items.Add('05: Entrada com suspensão');
    Items.Add('49: Outras entradas');
    Items.Add('50: Saída tributada');
    Items.Add('51: Saída tributada com alíquota zero');
    Items.Add('52: Saída isenta');
    Items.Add('53: Saída não-tributada');
    Items.Add('54: Saída imune');
    Items.Add('55: Saída com suspensão');
    Items.Add('99: Outras saídas');
  end;

  IPI_02.Clear;
  IPI_02.Items.Text := IPI_01.Items.Text ;

  IPI_07.Clear;
  IPI_07.Items.Text := IPI_01.Items.Text;
end;

procedure TControleCadastroGrupoTributario.PreencheSituacaoTributariaPIS;
begin
  PIS_01.Clear;
  PIS_02.Clear;
  PIS_06.Clear;
  PIS_10.Clear;

  // Simples Nacional
  with PIS_01 do
  begin
    Items.Add('Não usar');
    Items.Add('01: Tributável. BC = alíq normal (cumul/não cumul)');
    Items.Add('02: Tributável. BC = valor da oper (alíq difer)');
    Items.Add('03: Tributável. BC = quant x alíq por unid de prod');
    Items.Add('04: Tributável. Monofásica, alíquota zero');
    Items.Add('05: Tributável. Substituição tributária');
    Items.Add('06: Tributável. Alíquota zero');
    Items.Add('07: Isenta da contribuição');
    Items.Add('08: Sem incidência da contribuição');
    Items.Add('09: Com suspensão da contribuição');
    Items.Add('49: Outras Operações de Saída');
    Items.Add('50: Direito a Crédito. Vinculada Exclusivamente a Receita Tributada no Mercado Interno');
    Items.Add('51: Direito a Crédito. Vinculada Exclusivamente a Receita Não Tributada no Mercado Interno');
    Items.Add('52: Direito a Crédito. Vinculada Exclusivamente a Receita de Exportação');
    Items.Add('53: Direito a Crédito. Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno');
    Items.Add('54: Direito a Crédito. Vinculada a Receitas Tributadas no Mercado Interno e de Exportação');
    Items.Add('55: Direito a Crédito. Vinculada a Receitas Não-Trib. no Mercado Interno e de Exportação');
    Items.Add('56: Direito a Crédito. Vinculada a Rec. Trib. e Não-Trib. Mercado Interno e Exportação');
    Items.Add('60: Créd. Presumido. Aquisição Vinc. Exclusivamente a Receita Tributada no Mercado Interno');
    Items.Add('61: Créd. Presumido. Aquisição Vinc. Exclusivamente a Rec. Não-Trib. no Mercado Interno');
    Items.Add('62: Créd. Presumido. Aquisição Vinc. Exclusivamente a Receita de Exportação');
    Items.Add('63: Créd. Presumido. Aquisição Vinc. a Rec. Trib. e Não-Trib. no Mercado Interno');
    Items.Add('64: Créd. Presumido. Aquisição Vinc. a Rec. Trib. no Mercado Interno e de Exportação');
    Items.Add('65: Créd. Presumido. Aquisição Vinc. a Rec. Não-Trib. Mercado Interno e Exportação');
    Items.Add('66: Créd. Presumido. Aquisição Vinc. a Rec. Trib. e Não-Trib. Mercado Interno e Exportação');
    Items.Add('67: Crédito Presumido - Outras Operações');
    Items.Add('70: Operação de Aquisição sem Direito a Crédito');
    Items.Add('71: Operação de Aquisição com Isenção');
    Items.Add('72: Operação de Aquisição com Suspensão');
    Items.Add('73: Operação de Aquisição a Alíquota Zero');
    Items.Add('74: Operação de Aquisição sem Incidência da Contribuição');
    Items.Add('75: Operação de Aquisição por Substituição Tributária');
    Items.Add('98: Outras Operações de Entrada');
    Items.Add('99: Outras operações');
  end;

  PIS_02.Clear;
  PIS_02.Items.Text := PIS_01.Items.Text ;

  PIS_06.Clear;
  PIS_06.Items.Text := PIS_01.Items.Text;

  PIS_10.Clear;
  PIS_10.Items.Text := PIS_01.Items.Text;
end;

procedure TControleCadastroGrupoTributario.PreencheSituacaoTributariaCOFINS;
begin
  COFINS_01.Clear;
  COFINS_02.Clear;
  COFINS_06.Clear;
  COFINS_10.Clear;

  // Simples Nacional
  with COFINS_01 do
  begin
    Items.Add('Não usar');
    Items.Add('01: Tributável. BC = alíq normal (cumul/não cumul)');
    Items.Add('02: Tributável. BC = valor da oper (alíq difer)');
    Items.Add('03: Tributável. BC = quant x alíq por unid de prod');
    Items.Add('04: Tributável. Monofásica, alíquota zero');
    Items.Add('05: Tributável. Substituição tributária');
    Items.Add('06: Tributável. Alíquota zero');
    Items.Add('07: Isenta da contribuição');
    Items.Add('08: Sem incidência da contribuição');
    Items.Add('09: Com suspensão da contribuição');
    Items.Add('49: Outras Operações de Saída');
    Items.Add('50: Direito a Crédito. Vinculada Exclusivamente a Receita Tributada no Mercado Interno');
    Items.Add('51: Direito a Crédito. Vinculada Exclusivamente a Receita Não Tributada no Mercado Interno');
    Items.Add('52: Direito a Crédito. Vinculada Exclusivamente a Receita de Exportação');
    Items.Add('53: Direito a Crédito. Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno');
    Items.Add('54: Direito a Crédito. Vinculada a Receitas Tributadas no Mercado Interno e de Exportação');
    Items.Add('55: Direito a Crédito. Vinculada a Receitas Não-Trib. no Mercado Interno e de Exportação');
    Items.Add('56: Direito a Crédito. Vinculada a Rec. Trib. e Não-Trib. Mercado Interno e Exportação');
    Items.Add('60: Créd. Presumido. Aquisição Vinc. Exclusivamente a Receita Tributada no Mercado Interno');
    Items.Add('61: Créd. Presumido. Aquisição Vinc. Exclusivamente a Rec. Não-Trib. no Mercado Interno');
    Items.Add('62: Créd. Presumido. Aquisição Vinc. Exclusivamente a Receita de Exportação');
    Items.Add('63: Créd. Presumido. Aquisição Vinc. a Rec. Trib. e Não-Trib. no Mercado Interno');
    Items.Add('64: Créd. Presumido. Aquisição Vinc. a Rec. Trib. no Mercado Interno e de Exportação');
    Items.Add('65: Créd. Presumido. Aquisição Vinc. a Rec. Não-Trib. Mercado Interno e Exportação');
    Items.Add('66: Créd. Presumido. Aquisição Vinc. a Rec. Trib. e Não-Trib. Mercado Interno e Exportação');
    Items.Add('67: Crédito Presumido - Outras Operações');
    Items.Add('70: Operação de Aquisição sem Direito a Crédito');
    Items.Add('71: Operação de Aquisição com Isenção');
    Items.Add('72: Operação de Aquisição com Suspensão');
    Items.Add('73: Operação de Aquisição a Alíquota Zero');
    Items.Add('74: Operação de Aquisição sem Incidência da Contribuição');
    Items.Add('75: Operação de Aquisição por Substituição Tributária');
    Items.Add('98: Outras Operações de Entrada');
    Items.Add('99: Outras operações');
  end;

  COFINS_02.Clear;
  COFINS_02.Items.Text := COFINS_01.Items.Text ;

  COFINS_06.Clear;
  COFINS_06.Items.Text := COFINS_01.Items.Text;

  COFINS_10.Clear;
  COFINS_10.Items.Text := COFINS_01.Items.Text;
end;

Procedure TControleCadastroGrupoTributario.ExibeControlesCFOP;
begin
  if CdsCadastroCFOP_DIFERENTE_UF_FORA_ESTADO.AsString = 'N' then
    HabilitaDesabilitaPanelCFOP(tp01)
  else if CdsCadastroCFOP_DIFERENTE_UF_FORA_ESTADO.AsString = 'S' then
    HabilitaDesabilitaPanelCFOP(tp02);
end;

procedure TControleCadastroGrupoTributario.VerificaSituacaoICMS_20;
begin
  if icms_20.ItemIndex = 0 then
    icms_23.Visible := True
  else if icms_20.ItemIndex = 1 then
    icms_23.Visible := True
  else
    icms_23.Visible := False;
end;


procedure TControleCadastroGrupoTributario.VerificaSituacaoIPI_08;
begin
  if CdsCadastroIPI_TIPO_CALCULO.AsString = 'Porcentagem' then
  begin
    IPI_09.FieldLabel := 'Aliquota IPI';
    IPI_09.DataField  := 'IPI_ALIQUOTA';
    IPI_09.Visible    := True;
  end
  else if CdsCadastroIPI_TIPO_CALCULO.AsString = 'Valor' then
  begin
    IPI_09.FieldLabel := 'Valor IPI/unid.';
    IPI_09.DataField  := 'IPI_VALOR_UNIDADE';
    IPI_09.Visible    := True;
  end
  else
    IPI_09.Visible    := False;

  IPI_09.Text := '';
end;


procedure TControleCadastroGrupoTributario.VerificaSituacaoPIS_05;
begin
  if CdsCadastroPIS_TIPO_CALCULO_ST.AsString = 'Porcentagem' then
  begin
    PIS_05.FieldLabel := 'Aliquota PIS ST';
    PIS_05.DataField  := 'PIS_ALIQUOTA_ST';
    PIS_05.Visible    := True;
  end
  else if CdsCadastroPIS_TIPO_CALCULO_ST.AsString = 'Valor' then
  begin
    PIS_05.FieldLabel := 'Valor PIS ST/unid.';
    PIS_05.DataField  := 'PIS_VALOR_UNIDADE_ST';
    PIS_05.Visible    := True;
  end
  else
    PIS_05.Visible    := False;

  PIS_05.Text := '';
end;

procedure TControleCadastroGrupoTributario.VerificaSituacaoPIS_09;
begin
  if CdsCadastroPIS_TIPO_CALCULO_ST.AsString = 'Porcentagem' then
  begin
    PIS_09.FieldLabel := 'Aliquota PIS ST';
    PIS_09.DataField  := 'PIS_ALIQUOTA_ST';
    PIS_09.Visible    := True;
  end
  else if CdsCadastroPIS_TIPO_CALCULO_ST.AsString = 'Valor' then
  begin
    PIS_09.FieldLabel := 'Valor PIS ST/unid.';
    PIS_09.DataField  := 'PIS_VALOR_UNIDADE_ST';
    PIS_09.Visible    := True;
  end
  else
    PIS_09.Visible    := False;

  PIS_09.Text := '';
end;

procedure TControleCadastroGrupoTributario.VerificaSituacaoPIS_14;
begin
  if CdsCadastroPIS_TIPO_CALCULO_ST.AsString = 'Porcentagem' then
  begin
    PIS_14.FieldLabel := 'Aliquota PIS ST';
    PIS_14.DataField  := 'PIS_ALIQUOTA_ST';
    PIS_14.Visible    := True;
  end
  else if CdsCadastroPIS_TIPO_CALCULO_ST.AsString = 'Valor' then
  begin
    PIS_14.FieldLabel := 'Valor PIS ST/unid.';
    PIS_14.DataField  := 'PIS_VALOR_UNIDADE_ST';
    PIS_14.Visible    := True;
  end
  else
    PIS_14.Visible    := False;

  PIS_14.Text := '';
end;

procedure TControleCadastroGrupoTributario.VerificaSituacaoPIS_12;
begin
  if CdsCadastroPIS_TIPO_CALCULO.AsString = 'Porcentagem' then
  begin
    PIS_12.FieldLabel := 'Aliquota PIS';
    PIS_12.DataField  := 'PIS_ALIQUOTA';
    PIS_12.Visible    := True;
  end
  else if CdsCadastroPIS_TIPO_CALCULO.AsString = 'Valor' then
  begin
    PIS_12.FieldLabel := 'Valor PIS unid.';
    PIS_12.DataField  := 'PIS_VALOR_UNIDADE';
    PIS_12.Visible    := True;
  end
  else
    PIS_12.Visible    := False;

  PIS_12.Text := '';
end;


procedure TControleCadastroGrupoTributario.VerificaSituacaoCOFINS_05;
begin
  if CdsCadastroCOFINS_TIPO_CALCULO_ST.AsString = 'Porcentagem' then
  begin
    COFINS_05.FieldLabel := 'Aliquota COFINS ST';
    COFINS_05.DataField  := 'COFINS_ALIQUOTA_ST';
    COFINS_05.Visible    := True;
  end
  else if CdsCadastroCOFINS_TIPO_CALCULO_ST.AsString = 'Valor' then
  begin
    COFINS_05.FieldLabel := 'Valor COFINS ST/unid.';
    COFINS_05.DataField  := 'COFINS_VALOR_UNIDADE_ST';
    COFINS_05.Visible    := True;
  end
  else
    COFINS_05.Visible    := False;

  COFINS_05.Text := '';
end;

procedure TControleCadastroGrupoTributario.VerificaSituacaoCOFINS_09;
begin
  if CdsCadastroCOFINS_TIPO_CALCULO_ST.AsString = 'Porcentagem' then
  begin
    COFINS_09.FieldLabel := 'Aliquota COFINS ST';
    COFINS_09.DataField  := 'COFINS_ALIQUOTA_ST';
    COFINS_09.Visible    := True;
  end
  else if CdsCadastroCOFINS_TIPO_CALCULO_ST.AsString = 'Valor' then
  begin
    COFINS_09.FieldLabel := 'Valor COFINS ST/unid.';
    COFINS_09.DataField  := 'COFINS_VALOR_UNIDADE_ST';
    COFINS_09.Visible    := True;
  end
  else
    COFINS_09.Visible    := False;

  COFINS_09.Text := '';
end;

procedure TControleCadastroGrupoTributario.VerificaSituacaoCOFINS_14;
begin
  if CdsCadastroCOFINS_TIPO_CALCULO_ST.AsString = 'Porcentagem' then
  begin
    COFINS_14.FieldLabel := 'Aliquota COFINS ST';
    COFINS_14.DataField  := 'COFINS_ALIQUOTA_ST';
    COFINS_14.Visible    := True;
  end
  else if CdsCadastroCOFINS_TIPO_CALCULO_ST.AsString = 'Valor' then
  begin
    COFINS_14.FieldLabel := 'Valor COFINS ST/unid.';
    COFINS_14.DataField  := 'COFINS_VALOR_UNIDADE_ST';
    COFINS_14.Visible    := True;
  end
  else
    COFINS_14.Visible    := False;

  COFINS_14.Text := '';
end;

procedure TControleCadastroGrupoTributario.VerificaSituacaoICMS_08;
  procedure CarregaCampos1;
  begin
    with icms_11 do
    begin
      Visible := True;
      FieldLabel :=  'MargValor adic.';
      DataField  :=  'ICMS_MARGEM_VALOR_ADICIONADO';
    end;
  end;

  procedure CarregaCampos2;
  begin
    with icms_11 do
    begin
      Visible := True;
      FieldLabel :=  'Preço unit. Pauta ST';
      DataField  :=  'ICMS_PRECO_UNITARIO_PAUTA_ST';
    end;
  end;

  procedure CarregaCampos3;
  begin
    with icms_11 do
    begin
      Visible := False;
      DataField  :=  'ICMS_PRECO_UNITARIO_PAUTA_ST';
      Text       :=  '';
      DataField  :=  'ICMS_MARGEM_VALOR_ADICIONADO';
      Text       :=  '';
    end;
  end;
begin
  if CdsCadastroICMS_MODALIDADE_BC_ST.AsString = 'MargValor agregado (%)' then
    CarregaCampos1
  else if CdsCadastroICMS_MODALIDADE_BC_ST.AsString = 'Pauta (valor)' then
    CarregaCampos2
  else if CdsCadastroICMS_MODALIDADE_BC_ST.AsString = 'Tabelado ou máx. sugerido' then
    CarregaCampos3
  else if CdsCadastroICMS_MODALIDADE_BC_ST.AsString = 'Lista negativa (valor)' then
    CarregaCampos3
  else if CdsCadastroICMS_MODALIDADE_BC_ST.AsString = 'Lista positiva (valor)' then
    CarregaCampos3
  else if CdsCadastroICMS_MODALIDADE_BC_ST.AsString = 'Lista (neutra)' then
    CarregaCampos3
  else if CdsCadastroICMS_MODALIDADE_BC_ST.AsString = 'Valor da operação' then
    CarregaCampos3;
end;

procedure TControleCadastroGrupoTributario.CarregaGrupoTributos;
begin
  ExibeControlesCFOP;

  HabilitaDesabilitaPanelICMS(Copy(CdsCadastroICMS_SITUACAO_TRIBUTARIA.AsString,1,2));
  HabilitaDesabilitaPanelIPI(Copy(CdsCadastroIPI_SITUACAO_TRIBUTARIA.AsString,1,2));
  HabilitaDesabilitaPanelPIS(Copy(CdsCadastroPIS_SITUACAO_TRIBUTARIA.AsString,1,2));
  HabilitaDesabilitaPanelCOFINS(Copy(CdsCadastroCOFINS_SITUACAO_TRIBUTARIA.AsString,1,2));

  PreencheSituacaoTributariaICMS;
  PreencheSituacaoTributariaIPI;
  PreencheSituacaoTributariaPIS;
  PreencheSituacaoTributariaCOFINS;

  VerificaSituacaoICMS_08;
  VerificaSituacaoICMS_20;

  VerificaSituacaoPIS_05;
  VerificaSituacaoIPI_08;
  VerificaSituacaoPIS_09;
  VerificaSituacaoPIS_12;
  VerificaSituacaoPIS_14;

  VerificaSituacaoCOFINS_05;
  VerificaSituacaoCOFINS_09;
  VerificaSituacaoCOFINS_14;
end;

function TControleCadastroGrupoTributario.ValidaCampos: Boolean;
  Procedure CarregaCampo1;
  begin
    if icms_03.IsBlank = True then
      Mensagem(icms_03.FieldLabel);

    if icms_04.IsBlank = True then
      Mensagem(icms_03.FieldLabel);
  end;

  Procedure CarregaCampo2;
  begin
    if icms_18.IsBlank = True then
      Mensagem(icms_18.FieldLabel);
  end;

  Procedure CarregaCampo3;
  begin
    if icms_27.IsBlank = True then
      Mensagem(icms_27.FieldLabel);

    if icms_29.IsBlank = True then
      Mensagem(icms_29.FieldLabel);

    if icms_30.IsBlank = True then
      Mensagem(icms_30.FieldLabel);

    if icms_32.IsBlank = True then
      Mensagem(icms_32.FieldLabel);

    if icms_33.IsBlank = True then
      Mensagem(icms_33.FieldLabel);
  end;

  Procedure CarregaCampo4;
  begin
    if icms_35.IsBlank = True then
      Mensagem(icms_35.FieldLabel);

    if icms_36.IsBlank = True then
      Mensagem(icms_36.FieldLabel);

    if icms_37.IsBlank = True then
      Mensagem(icms_37.FieldLabel);

    if icms_38.IsBlank = True then
      Mensagem(icms_38.FieldLabel);
  end;

  Procedure CarregaCampo5;
  begin
    if icms_07.IsBlank = True then
      Mensagem(icms_07.FieldLabel);

    if icms_09.IsBlank = True then
      Mensagem(icms_09.FieldLabel);

    if icms_10.IsBlank = True then
      Mensagem(icms_10.FieldLabel);

    if icms_11.Visible = True then
      if icms_11.IsBlank = True then
        Mensagem(icms_11.FieldLabel);
  end;

  Procedure CarregaCampo6;
  begin
    if icms_13.IsBlank = True then
      Mensagem(icms_13.FieldLabel);

    if icms_15.IsBlank = True then
      Mensagem(icms_15.FieldLabel);

    if icms_16.IsBlank = True then
      Mensagem(icms_16.FieldLabel);
  end;

  Procedure CarregaCampo7;
  begin
    if icms_18.IsBlank = True then
      Mensagem(icms_18.FieldLabel);

    if icms_19.IsBlank = True then
      Mensagem(icms_19.FieldLabel);

    if icms_21.IsBlank = True then
      Mensagem(icms_21.FieldLabel);

    if icms_22.IsBlank = True then
      Mensagem(icms_22.FieldLabel);

    if icms_23.IsBlank = True then
      Mensagem(icms_23.FieldLabel);
  end;

  procedure CarregaCampo8;
  begin
    if icms_01.IsBlank = True then
      Mensagem(icms_01.FieldLabel);
  end;
begin
  Retorno := True;

  if CdsCadastroICMS_SITUACAO_TRIBUTARIA.AsString = '00 : Tributada integralmente' then
    CarregaCampo1
  else if CdsCadastroICMS_SITUACAO_TRIBUTARIA.AsString = '10 : Tributada e com cobrança do ICMS por substituição tributária' then
    CarregaCampo5
  else if CdsCadastroICMS_SITUACAO_TRIBUTARIA.AsString = '20 : Com redução da BC' then
    CarregaCampo6
  else if CdsCadastroICMS_SITUACAO_TRIBUTARIA.AsString = '30 : Isenta / não tributada e com cobrança do ICMS por substituição tributária' then
    CarregaCampo7
  else if CdsCadastroICMS_SITUACAO_TRIBUTARIA.AsString = '40 : Isenta' then
    CarregaCampo2
  else if CdsCadastroICMS_SITUACAO_TRIBUTARIA.AsString = '41 : Não tributada' then
    CarregaCampo2
  else if CdsCadastroICMS_SITUACAO_TRIBUTARIA.AsString = '50 : Com suspensão' then
    CarregaCampo2
  else if CdsCadastroICMS_SITUACAO_TRIBUTARIA.AsString = '51 : Com diferimento' then
    CarregaCampo4
  else if CdsCadastroICMS_SITUACAO_TRIBUTARIA.AsString = '60 : ICMS cobrado anteriormente por substituição tributária' then
    // Sem validação
  else if CdsCadastroICMS_SITUACAO_TRIBUTARIA.AsString = '70 : Com redução da BC e cobrança do ICMS por substituição tributária' then
    CarregaCampo3
  else if CdsCadastroICMS_SITUACAO_TRIBUTARIA.AsString = '90 : Outras' then
    CarregaCampo3
  else
    CarregaCampo8;
end;

procedure TControleCadastroGrupoTributario.Mensagem(Campo: string);
begin
  ControleMainModule.MensageiroSweetAlerta('Atenção', 'O ' + Campo + ' é de preenchimento obrigatório');
  Retorno := False;
end;

end.
