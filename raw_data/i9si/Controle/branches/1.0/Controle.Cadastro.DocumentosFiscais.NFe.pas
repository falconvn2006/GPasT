unit Controle.Cadastro.DocumentosFiscais.NFe;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Controle.Cadastro, uniSweetAlert, ACBrBase,
  ACBrSocket, ACBrCEP, Data.DB, Datasnap.DBClient, Datasnap.Provider,
  Data.Win.ADODB, uniGUIBaseClasses, uniImageList, uniBitBtn, uniSpeedButton,
  uniLabel, uniButton, uniPanel, uniEdit, uniDBEdit, uniRadioGroup,
  uniDBRadioGroup, uniPageControl, uniGroupBox, uniFileUpload, ACBrDFe, ACBrNFe,
  pcnConversao, uniBasicGrid, uniDBGrid;

type
  TControleCadastroDocumentosFiscaisNFe = class(TControleCadastro)
    CdsCadastroID: TFloatField;
    CdsCadastroNFE_NUMERO: TFloatField;
    CdsCadastroNFE_SERIE: TWideStringField;
    CdsCadastroNFE_DATA_EMISSAO: TDateTimeField;
    CdsCadastroNFE_DATA_SAIDA: TDateTimeField;
    CdsCadastroNFE_NATUREZA_OPERACAO: TWideStringField;
    CdsCadastroNFE_FORMA_EMISSAO: TWideStringField;
    CdsCadastroNFE_FORMA_PAGAMENTO: TWideStringField;
    CdsCadastroNFE_TIPO_DOCUMENTO: TWideStringField;
    CdsCadastroNFE_FINALIDADE_EMISSAO: TWideStringField;
    CdsCadastroNFE_SITUACAO: TWideStringField;
    CdsCadastroNFE_CHAVE_CARTA_CORRECAO: TWideStringField;
    CdsCadastroDESTINATARIO_TIPO: TWideStringField;
    CdsCadastroDESTINATARIO_CNPJ_CPF: TWideStringField;
    CdsCadastroDESTINATARIO_INSCRICAO: TWideStringField;
    CdsCadastroDESTINATARIO_INSCRICAO_SUFRAMA: TWideStringField;
    CdsCadastroDESTINATARIO_RAZAO_SOCIAL: TWideStringField;
    CdsCadastroDESTINATARIO_NOME_FANTASIA: TWideStringField;
    CdsCadastroDESTINATARIO_EMAIL: TWideStringField;
    CdsCadastroDESTINATARIO_END_LOGRADOURO: TWideStringField;
    CdsCadastroDESTINATARIO_END_NUMERO: TWideStringField;
    CdsCadastroDESTINATARIO_COMPLEMENTO: TWideStringField;
    CdsCadastroDESTINATARIO_BAIRRO: TWideStringField;
    CdsCadastroDESTINATARIO_CIDADE: TWideStringField;
    CdsCadastroDESTINATARIO_CEP: TWideStringField;
    CdsCadastroDESTINATARIO_UF: TWideStringField;
    CdsCadastroDESTINATARIO_IBGE_MUN: TWideStringField;
    CdsCadastroDESTINATARIO_IIBGE_UF: TWideStringField;
    CdsCadastroEMITENTE_TIPO: TWideStringField;
    CdsCadastroEMITENTE_CNPJ_CPF: TWideStringField;
    CdsCadastroEMITENTE_INSCRICAO: TWideStringField;
    CdsCadastroEMITENTE_INSCRICAO_SUFRAMA: TWideStringField;
    CdsCadastroEMITENTE_RAZAO_SOCIAL: TWideStringField;
    CdsCadastroEMITENTE_NOME_FANTASIA: TWideStringField;
    CdsCadastroEMITENTE_EMAIL: TWideStringField;
    CdsCadastroEMITENTE_END_LOGRADOURO: TWideStringField;
    CdsCadastroEMITENTE_END_NUMERO: TWideStringField;
    CdsCadastroEMITENTE_COMPLEMENTO: TWideStringField;
    CdsCadastroEMITENTE_BAIRRO: TWideStringField;
    CdsCadastroEMITENTE_CIDADE: TWideStringField;
    CdsCadastroEMITENTE_CEP: TWideStringField;
    CdsCadastroEMITENTE_UF: TWideStringField;
    CdsCadastroEMITENTE_IBGE_MUN: TWideStringField;
    CdsCadastroEMITENTE_IIBGE_UF: TWideStringField;
    CdsCadastroTRANSPORTE_MODALIDADE: TWideStringField;
    CdsCadastroTRANSPORTE_RAZAO_SOCIAL: TWideStringField;
    CdsCadastroTRANSPORTE_NOME_FANTASIA: TWideStringField;
    CdsCadastroTRANSPORTE_CNPJ_CPF: TWideStringField;
    CdsCadastroTRANSPORTE_LOGRADOURO: TWideStringField;
    CdsCadastroTRANSPORTE_NUMERO: TWideStringField;
    CdsCadastroTRANSPORTE_COMPLEMENTO: TWideStringField;
    CdsCadastroTRANSPORTE_BAIRRO: TWideStringField;
    CdsCadastroTRANSPORTE_CIDADE: TWideStringField;
    CdsCadastroTRANSPORTE_CEP: TWideStringField;
    CdsCadastroTRANSPORTE_UF: TWideStringField;
    CdsCadastroTRANSPORTE_FONE: TWideStringField;
    CdsCadastroOBSERVACAO_COMPLEMENTAR: TWideStringField;
    CdsCadastroOBSERVACAO_FISCO: TWideStringField;
    QryCadastroID: TFloatField;
    QryCadastroNFE_NUMERO: TFloatField;
    QryCadastroNFE_SERIE: TWideStringField;
    QryCadastroNFE_DATA_EMISSAO: TDateTimeField;
    QryCadastroNFE_DATA_SAIDA: TDateTimeField;
    QryCadastroNFE_NATUREZA_OPERACAO: TWideStringField;
    QryCadastroNFE_FORMA_EMISSAO: TWideStringField;
    QryCadastroNFE_FORMA_PAGAMENTO: TWideStringField;
    QryCadastroNFE_TIPO_DOCUMENTO: TWideStringField;
    QryCadastroNFE_FINALIDADE_EMISSAO: TWideStringField;
    QryCadastroNFE_SITUACAO: TWideStringField;
    QryCadastroNFE_CHAVE_CARTA_CORRECAO: TWideStringField;
    QryCadastroDESTINATARIO_TIPO: TWideStringField;
    QryCadastroDESTINATARIO_CNPJ_CPF: TWideStringField;
    QryCadastroDESTINATARIO_INSCRICAO: TWideStringField;
    QryCadastroDESTINATARIO_INSCRICAO_SUFRAMA: TWideStringField;
    QryCadastroDESTINATARIO_RAZAO_SOCIAL: TWideStringField;
    QryCadastroDESTINATARIO_NOME_FANTASIA: TWideStringField;
    QryCadastroDESTINATARIO_EMAIL: TWideStringField;
    QryCadastroDESTINATARIO_END_LOGRADOURO: TWideStringField;
    QryCadastroDESTINATARIO_END_NUMERO: TWideStringField;
    QryCadastroDESTINATARIO_COMPLEMENTO: TWideStringField;
    QryCadastroDESTINATARIO_BAIRRO: TWideStringField;
    QryCadastroDESTINATARIO_CIDADE: TWideStringField;
    QryCadastroDESTINATARIO_CEP: TWideStringField;
    QryCadastroDESTINATARIO_UF: TWideStringField;
    QryCadastroDESTINATARIO_IBGE_MUN: TWideStringField;
    QryCadastroDESTINATARIO_IIBGE_UF: TWideStringField;
    QryCadastroEMITENTE_TIPO: TWideStringField;
    QryCadastroEMITENTE_CNPJ_CPF: TWideStringField;
    QryCadastroEMITENTE_INSCRICAO: TWideStringField;
    QryCadastroEMITENTE_INSCRICAO_SUFRAMA: TWideStringField;
    QryCadastroEMITENTE_RAZAO_SOCIAL: TWideStringField;
    QryCadastroEMITENTE_NOME_FANTASIA: TWideStringField;
    QryCadastroEMITENTE_EMAIL: TWideStringField;
    QryCadastroEMITENTE_END_LOGRADOURO: TWideStringField;
    QryCadastroEMITENTE_END_NUMERO: TWideStringField;
    QryCadastroEMITENTE_COMPLEMENTO: TWideStringField;
    QryCadastroEMITENTE_BAIRRO: TWideStringField;
    QryCadastroEMITENTE_CIDADE: TWideStringField;
    QryCadastroEMITENTE_CEP: TWideStringField;
    QryCadastroEMITENTE_UF: TWideStringField;
    QryCadastroEMITENTE_IBGE_MUN: TWideStringField;
    QryCadastroEMITENTE_IIBGE_UF: TWideStringField;
    QryCadastroTRANSPORTE_MODALIDADE: TWideStringField;
    QryCadastroTRANSPORTE_RAZAO_SOCIAL: TWideStringField;
    QryCadastroTRANSPORTE_NOME_FANTASIA: TWideStringField;
    QryCadastroTRANSPORTE_CNPJ_CPF: TWideStringField;
    QryCadastroTRANSPORTE_LOGRADOURO: TWideStringField;
    QryCadastroTRANSPORTE_NUMERO: TWideStringField;
    QryCadastroTRANSPORTE_COMPLEMENTO: TWideStringField;
    QryCadastroTRANSPORTE_BAIRRO: TWideStringField;
    QryCadastroTRANSPORTE_CIDADE: TWideStringField;
    QryCadastroTRANSPORTE_CEP: TWideStringField;
    QryCadastroTRANSPORTE_UF: TWideStringField;
    QryCadastroTRANSPORTE_FONE: TWideStringField;
    QryCadastroOBSERVACAO_COMPLEMENTAR: TWideStringField;
    QryCadastroOBSERVACAO_FISCO: TWideStringField;
    UniPageControl1: TUniPageControl;
    UniTabSheet1: TUniTabSheet;
    UniTabSheet2: TUniTabSheet;
    UniLabel1: TUniLabel;
    UniDBEdit1: TUniDBEdit;
    UniLabel5: TUniLabel;
    UniDBEdit5: TUniDBEdit;
    DBEdtNome: TUniDBEdit;
    LabelNomeRazao: TUniLabel;
    UniLabel2: TUniLabel;
    UniDBEdit2: TUniDBEdit;
    UniLabel3: TUniLabel;
    UniDBEdit3: TUniDBEdit;
    UniLabel4: TUniLabel;
    UniDBEdit4: TUniDBEdit;
    UniDBRadioGroup2: TUniDBRadioGroup;
    UniDBRadioGroup3: TUniDBRadioGroup;
    UniLabel7: TUniLabel;
    UniDBEdit7: TUniDBEdit;
    UniLabel8: TUniLabel;
    UniDBEdit8: TUniDBEdit;
    UniPageControl2: TUniPageControl;
    UniTabSheet3: TUniTabSheet;
    UniPanel3: TUniPanel;
    UniButton1: TUniButton;
    UniButton2: TUniButton;
    UniButton3: TUniButton;
    UniButton4: TUniButton;
    UniButton5: TUniButton;
    UniButton7: TUniButton;
    UniButton6: TUniButton;
    UniTabSheet5: TUniTabSheet;
    UniTabSheet6: TUniTabSheet;
    UniLabel9: TUniLabel;
    UniDBEdit9: TUniDBEdit;
    UniLabel10: TUniLabel;
    UniLabel11: TUniLabel;
    UniLabel12: TUniLabel;
    UniLabel13: TUniLabel;
    UniLabel14: TUniLabel;
    UniLabel15: TUniLabel;
    UniLabel16: TUniLabel;
    UniLabel17: TUniLabel;
    FCP: TUniLabel;
    UniDBEdit10: TUniDBEdit;
    UniDBEdit11: TUniDBEdit;
    UniDBEdit12: TUniDBEdit;
    UniDBEdit13: TUniDBEdit;
    UniDBEdit14: TUniDBEdit;
    UniDBEdit15: TUniDBEdit;
    UniDBEdit16: TUniDBEdit;
    UniDBEdit17: TUniDBEdit;
    UniDBEdit18: TUniDBEdit;
    UniDBEdit19: TUniDBEdit;
    UniDBEdit20: TUniDBEdit;
    UniLabel18: TUniLabel;
    UniLabel19: TUniLabel;
    UniLabel20: TUniLabel;
    UniDBEdit21: TUniDBEdit;
    UniLabel21: TUniLabel;
    UniDBEdit22: TUniDBEdit;
    Emitente: TUniGroupBox;
    UniPanel4: TUniPanel;
    UniPanel5: TUniPanel;
    UniLabel22: TUniLabel;
    UniDBEdit23: TUniDBEdit;
    UniLabel23: TUniLabel;
    UniDBEdit24: TUniDBEdit;
    UniLabel24: TUniLabel;
    UniDBEdit25: TUniDBEdit;
    UniLabel25: TUniLabel;
    UniDBEdit26: TUniDBEdit;
    UniLabel26: TUniLabel;
    UniDBEdit27: TUniDBEdit;
    UniLabel27: TUniLabel;
    UniDBEdit28: TUniDBEdit;
    UniLabel28: TUniLabel;
    UniDBEdit29: TUniDBEdit;
    UniLabel29: TUniLabel;
    UniDBEdit30: TUniDBEdit;
    UniLabel30: TUniLabel;
    UniDBEdit31: TUniDBEdit;
    UniLabel31: TUniLabel;
    UniDBEdit32: TUniDBEdit;
    UniLabel32: TUniLabel;
    UniDBEdit33: TUniDBEdit;
    UniLabel34: TUniLabel;
    UniDBEdit35: TUniDBEdit;
    UniLabel35: TUniLabel;
    UniDBEdit36: TUniDBEdit;
    UniLabel36: TUniLabel;
    UniDBEdit37: TUniDBEdit;
    UniLabel37: TUniLabel;
    UniDBEdit38: TUniDBEdit;
    UniGroupBox1: TUniGroupBox;
    UniPanel7: TUniPanel;
    UniLabel38: TUniLabel;
    UniDBEdit39: TUniDBEdit;
    UniLabel39: TUniLabel;
    UniDBEdit40: TUniDBEdit;
    UniLabel40: TUniLabel;
    UniDBEdit41: TUniDBEdit;
    UniLabel41: TUniLabel;
    UniDBEdit42: TUniDBEdit;
    UniLabel42: TUniLabel;
    UniDBEdit43: TUniDBEdit;
    UniLabel44: TUniLabel;
    UniDBEdit45: TUniDBEdit;
    UniLabel45: TUniLabel;
    UniDBEdit46: TUniDBEdit;
    UniLabel46: TUniLabel;
    UniDBEdit47: TUniDBEdit;
    UniLabel47: TUniLabel;
    UniDBEdit48: TUniDBEdit;
    UniPanel8: TUniPanel;
    UniLabel48: TUniLabel;
    UniDBEdit49: TUniDBEdit;
    UniLabel49: TUniLabel;
    UniDBEdit50: TUniDBEdit;
    UniLabel50: TUniLabel;
    UniDBEdit51: TUniDBEdit;
    UniLabel51: TUniLabel;
    UniDBEdit52: TUniDBEdit;
    UniLabel52: TUniLabel;
    UniDBEdit53: TUniDBEdit;
    UniLabel53: TUniLabel;
    UniDBEdit54: TUniDBEdit;
    UniFileUpload1: TUniFileUpload;
    ACBrNFe1: TACBrNFe;
    Unilabel55: TUniLabel;
    UniDBEdit6: TUniDBEdit;
    QryCadastroNFE_CHAVE: TWideStringField;
    QryCadastroNFE_NUMERO_REFERENCIA: TWideStringField;
    CdsCadastroNFE_CHAVE: TWideStringField;
    CdsCadastroNFE_NUMERO_REFERENCIA: TWideStringField;
    QryCadastroTOTAL_PRODUTO: TFloatField;
    QryCadastroTOTAL_DESCONTO: TFloatField;
    QryCadastroTOTAL_BASE_ICMS: TFloatField;
    QryCadastroTOTAL_VALOR_ICMS: TFloatField;
    QryCadastroTOTAL_BASE_ICMS_ST: TFloatField;
    QryCadastroTOTAL_VALOR_ICMS_ST: TFloatField;
    QryCadastroTOTAL_IPI: TFloatField;
    QryCadastroTOTAL_PIS: TFloatField;
    QryCadastroTOTAL_COFINS: TFloatField;
    QryCadastroTOTAL_FCP: TFloatField;
    QryCadastroTOTAL_OUTRAS_DESPESAS: TFloatField;
    QryCadastroTOTAL_FRETE: TFloatField;
    QryCadastroTOTAL_SEGURO: TFloatField;
    QryCadastroTOTAL_TOTAL: TFloatField;
    CdsCadastroTOTAL_PRODUTO: TFloatField;
    CdsCadastroTOTAL_DESCONTO: TFloatField;
    CdsCadastroTOTAL_BASE_ICMS: TFloatField;
    CdsCadastroTOTAL_VALOR_ICMS: TFloatField;
    CdsCadastroTOTAL_BASE_ICMS_ST: TFloatField;
    CdsCadastroTOTAL_VALOR_ICMS_ST: TFloatField;
    CdsCadastroTOTAL_IPI: TFloatField;
    CdsCadastroTOTAL_PIS: TFloatField;
    CdsCadastroTOTAL_COFINS: TFloatField;
    CdsCadastroTOTAL_FCP: TFloatField;
    CdsCadastroTOTAL_OUTRAS_DESPESAS: TFloatField;
    CdsCadastroTOTAL_FRETE: TFloatField;
    CdsCadastroTOTAL_SEGURO: TFloatField;
    CdsCadastroTOTAL_TOTAL: TFloatField;
    UniTabSheet4: TUniTabSheet;
    UniLabel6: TUniLabel;
    UniDBEdit56: TUniDBEdit;
    UniEditformaPag: TUniEdit;
    UniDBRadioGroup1: TUniDBRadioGroup;
    QryProduto: TADOQuery;
    CdsProduto: TClientDataSet;
    DspProduto: TDataSetProvider;
    DscProduto: TDataSource;
    GrdResultado: TUniDBGrid;
    CdsProdutoID: TFloatField;
    CdsProdutoPRODUTO_ID: TWideStringField;
    CdsProdutoDESCRICAO: TWideStringField;
    CdsProdutoQUANTIDADE: TFloatField;
    CdsProdutoVALOR_UNITARIO: TFloatField;
    CdsProdutoVALOR_TOTAL: TFloatField;
    CdsProdutoDOCUMENTO_FISCAL_NFE_ID: TFloatField;
    CdsProdutoUNIDADE: TWideStringField;
    CdsProdutoCFOP: TWideStringField;
    CdsProdutoNCM: TWideStringField;
    CdsProdutoOUTRAS_DESPESAS: TFloatField;
    CdsProdutoFRETE: TFloatField;
    CdsProdutoSEGURO: TFloatField;
    CdsProdutoDESCONTO: TFloatField;
    CdsProdutoCOD_BARRAS: TWideStringField;
    CdsProdutoICMS_ORIGEM: TWideStringField;
    CdsProdutoICMS_MODALIDADE_DETERMINACAO: TWideStringField;
    CdsProdutoICMS_PERCENTUAL_REDUCAO_BC: TFloatField;
    CdsProdutoICMS_BASE_CALCULO: TFloatField;
    CdsProdutoICMS_ALIQUOTA: TFloatField;
    CdsProdutoICMS_VALOR: TFloatField;
    CdsProdutoICMS_ST_MODALIDADE_DETERMINACA: TWideStringField;
    CdsProdutoICMS_ST_PERCENTUAL_REDUCAO_BC: TFloatField;
    CdsProdutoICMS_ST_BASE_CALCULO: TFloatField;
    CdsProdutoICMS_ST_ALIQUOTA_PERCENTUAL: TFloatField;
    CdsProdutoICMS_ST_VALOR: TFloatField;
    CdsProdutoICMS_CRED_PERCENTUAL: TFloatField;
    CdsProdutoICMS_CRED_VALOR: TFloatField;
    CdsProdutoICMS_SITUACAO_TRIBUTARIA: TWideStringField;
    CdsProdutoICMS_SITUACAO_TRIBUTARIA_ST: TWideStringField;
    CdsProdutoIPI_SITUACAO_TRIBUTARIA: TWideStringField;
    CdsProdutoIPI_CLASSE_ENQUADRAMENTO: TWideStringField;
    CdsProdutoIPI_CODIGO_ENQUADRAMENTO: TWideStringField;
    CdsProdutoIPI_CNPJPRODUTOR: TWideStringField;
    CdsProdutoIPI_CODIGO_SELO_CONTROLE: TWideStringField;
    CdsProdutoIPI_TIPO_CALCULO: TWideStringField;
    CdsProdutoIPI_VALOR_BASE_CALCULO: TFloatField;
    CdsProdutoIPI_QUANT_UNIDADE_PADRAO: TFloatField;
    CdsProdutoIPI_ALIQUOTA_PERCENTUAL: TFloatField;
    CdsProdutoIPI_VALOR_UNIDADE: TFloatField;
    CdsProdutoIPI_VALOR_IPI: TFloatField;
    CdsProdutoIPI_QUANT_SELO_CONTROLE: TFloatField;
    CdsProdutoPIS_SITUACAO_TRIBUTARIA: TWideStringField;
    CdsProdutoPIS_TIPO_CALCULO: TWideStringField;
    CdsProdutoPIS_VALOR_BASE_CALCULO: TFloatField;
    CdsProdutoPIS_VALOR_ALIQUOTA: TFloatField;
    CdsProdutoPIS_QUANT_VENDIDA: TFloatField;
    CdsProdutoPIS_VALOR: TFloatField;
    CdsProdutoCOFINS_VALOR_BASE_CALCULO: TFloatField;
    CdsProdutoCOFINS_VALOR_ALIQUOTA: TFloatField;
    CdsProdutoCOFINS_QUANT_VENDIDA: TFloatField;
    CdsProdutoCOFINS_VALOR: TFloatField;
    CdsProdutoCOFINS_SITUACAO_TRIBUTARIA: TWideStringField;
    CdsProdutoCOFINS_TIPO_CALCULO: TWideStringField;
    CdsProdutoPIS_ST_SITUACAO_TRIBUTARIA: TWideStringField;
    CdsProdutoPIS_ST_TIPO_CALCULO: TWideStringField;
    CdsProdutoPIS_ST_VALOR_BASE_CALCULO: TFloatField;
    CdsProdutoPIS_ST_VALOR_ALIQUOTA: TFloatField;
    CdsProdutoPIS_ST_QUANT_VENDIDA: TFloatField;
    CdsProdutoPIS_ST_VALOR: TFloatField;
    CdsProdutoCOFINS_ST_SITUACAO_TRIBUTARIA: TWideStringField;
    CdsProdutoCOFINS_ST_TIPO_CALCULO: TWideStringField;
    CdsProdutoCOFINS_ST_VALOR_ALIQUOTA: TFloatField;
    CdsProdutoCOFINS_ST_QUANT_VENDIDA: TFloatField;
    CdsProdutoCOFINS_ST_VALOR: TFloatField;
    CdsProdutoCOFINS_ST_VALOR_BASE_CALCULO: TFloatField;
    UniPanel9: TUniPanel;
    BotaoNovo: TUniButton;
    BotaoAbrir: TUniButton;
    BotaoApagar: TUniButton;
    BotaoAtualizar: TUniButton;
    UniPanel10: TUniPanel;
    procedure UniButton6Click(Sender: TObject);
    procedure UniFileUpload1Completed(Sender: TObject; AStream: TFileStream);
    procedure UniPageControl1Change(Sender: TObject);
    procedure BotaoNovoClick(Sender: TObject);
    procedure BotaoAbrirClick(Sender: TObject);
  private
    procedure ImportaXML(Caminho: String);
    function FiltraTexto(Texto: String): String;
    { Private declarations }
  public
    { Public declarations }
    function Abrir(Id: Integer): Boolean; override;
    function Novo(): Boolean; override;
    function Editar(Id: Integer): Boolean; override;
    function Salvar: Boolean; override;
    function Descartar: Boolean; override;
  end;

function ControleCadastroDocumentosFiscaisNFe: TControleCadastroDocumentosFiscaisNFe;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication, Controle.Funcoes, Controle.Server.Module,
  pcnConversaoNFe, Controle.Cadastro.DocumentosFiscais.NFe.Produto;

function ControleCadastroDocumentosFiscaisNFe: TControleCadastroDocumentosFiscaisNFe;
begin
  Result := TControleCadastroDocumentosFiscaisNFe(ControleMainModule.GetFormInstance(TControleCadastroDocumentosFiscaisNFe));
end;

function TControleCadastroDocumentosFiscaisNFe.Abrir(Id: Integer): Boolean;
begin
  Result := False;

  // Abre o registro
  CdsCadastro.Close;
  QryCadastro.Parameters.ParamByName('id').Value := Id;
  CdsCadastro.Open;

  // Abre o registro
  CdsProduto.Close;
  QryProduto.Parameters.ParamByName('documento_fiscal_nfe_id').Value := Id;
  CdsProduto.Open;

  // Se algum registro foi solicitado, deve parar se não encontrar
  if (Id > 0) and CdsCadastro.IsEmpty then
    Exit;

  // Bloqueia o registro para edição
  DscCadastro.AutoEdit := False;

  UniPageControl1.ActivePageIndex := 0;
  UniPageControl2.ActivePageIndex := 0;

  Result := True;
end;

procedure TControleCadastroDocumentosFiscaisNFe.BotaoAbrirClick(
  Sender: TObject);
begin
  inherited;
  // Abre o formulário de cadastro para visualização e edição
  // := TControleCadastroBanco.Create(Self);
  if ControleCadastroDocumentosFiscaisNFeProduto.Abrir(CdsProdutoID.AsInteger) then
  begin
    ControleCadastroDocumentosFiscaisNFeProduto.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
//      if Result = 1 then
//      CdsConsulta.Refresh;
    end);
  end;
end;

procedure TControleCadastroDocumentosFiscaisNFe.BotaoNovoClick(Sender: TObject);
begin
  inherited;
  if ControleCadastroDocumentosFiscaisNFeProduto.Novo() then
  begin
    ControleCadastroDocumentosFiscaisNFeProduto.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
//      if Result = 1 then
//      CdsProduto.Refresh;
    end);
  end;
end;

function TControleCadastroDocumentosFiscaisNFe.Descartar: Boolean;
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

function TControleCadastroDocumentosFiscaisNFe.Editar(Id: Integer): Boolean;
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

function TControleCadastroDocumentosFiscaisNFe.Novo(): Boolean;
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

function TControleCadastroDocumentosFiscaisNFe.Salvar: Boolean;
var
  PessoaId, EnderecoId: Integer;
  Erro: String;
begin
  inherited;

  Erro   := '';
  Result := False;

  with ControleMainModule do
  begin
    if CdsCadastro.State in [dsInsert, dsEdit] then
    begin
      // Verifica a VARIAVEL01
      if Trim(DBEdtNome.Text) = '' then
      begin
        MessageDlg('É necessário informar VARIAVEL01.'^M''+ 'Dados incompletos', mtWarning, [mbOK]);
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
      // Gera um novo id para a tabela documento_fiscal_nfe
      CadastroId := GeraId('documento_fiscal_nfe');
      // Insert
      QryAx1.SQL.Text :=
                             'INSERT INTO documento_fiscal_nfe ('
                           + ' id,'
                           + ' nfe_numero,'
                           + ' nfe_serie,'
                           + ' nfe_data_emissao,'
                           + ' nfe_data_saida,'
                           + ' nfe_natureza_operacao,'
                           + ' nfe_forma_emissao,'
                           + ' nfe_forma_pagamento,'
                           + ' nfe_tipo_documento,'
                           + ' nfe_finalidade_emissao,'
                           + ' nfe_chave,'
                           + ' nfe_situacao,'
                           + ' nfe_numero_referencia,'
                           + ' nfe_chave_carta_correcao,'
                           + ' destinatario_tipo,'
                           + ' destinatario_cnpj_cpf,'
                           + ' destinatario_inscricao,'
                           + ' destinatario_inscricao_suframa,'
                           + ' destinatario_razao_social,'
                           + ' destinatario_nome_fantasia,'
                           + ' destinatario_email,'
                           + ' destinatario_end_logradouro,'
                           + ' destinatario_end_numero,'
                           + ' destinatario_complemento,'
                           + ' destinatario_bairro,'
                           + ' destinatario_cidade,'
                           + ' destinatario_cep,'
                           + ' destinatario_uf,'
                           + ' destinatario_ibge_mun,'
                           + ' destinatario_iibge_uf,'
                           + ' emitente_tipo,'
                           + ' emitente_cnpj_cpf,'
                           + ' emitente_inscricao,'
                           + ' emitente_inscricao_suframa,'
                           + ' emitente_razao_social,'
                           + ' emitente_nome_fantasia,'
                           + ' emitente_email,'
                           + ' emitente_end_logradouro,'
                           + ' emitente_end_numero,'
                           + ' emitente_complemento,'
                           + ' emitente_bairro,'
                           + ' emitente_cidade,'
                           + ' emitente_cep,'
                           + ' emitente_uf,'
                           + ' emitente_ibge_mun,'
                           + ' emitente_iibge_uf,'
                           + ' transporte_modalidade,'
                           + ' transporte_razao_social,'
                           + ' transporte_nome_fantasia,'
                           + ' transporte_cnpj_cpf,'
                           + ' transporte_logradouro,'
                           + ' transporte_numero,'
                           + ' transporte_complemento,'
                           + ' transporte_bairro,'
                           + ' transporte_cidade,'
                           + ' transporte_cep,'
                           + ' transporte_uf,'
                           + ' transporte_fone,'
                           + ' observacao_complementar,'
                           + ' observacao_fisco,'
                           + ' total_produto,'
                           + ' total_desconto,'
                           + ' total_base_icms,'
                           + ' total_valor_icms,'
                           + ' total_base_icms_st,'
                           + ' total_valor_icms_st,'
                           + ' total_ipi,'
                           + ' total_pis,'
                           + ' total_cofins,'
                           + ' total_fcp,'
                           + ' total_outras_despesas,'
                           + ' total_frete,'
                           + ' total_seguro,'
                           + ' total_total)'
                           + ' VALUES ('
                           + ' :id,'
                           + ' :nfe_numero,'
                           + ' :nfe_serie,'
                           + ' :nfe_data_emissao,'
                           + ' :nfe_data_saida,'
                           + ' :nfe_natureza_operacao,'
                           + ' :nfe_forma_emissao,'
                           + ' :nfe_forma_pagamento,'
                           + ' :nfe_tipo_documento,'
                           + ' :nfe_finalidade_emissao,'
                           + ' :nfe_chave,'
                           + ' :nfe_situacao,'
                           + ' :nfe_numero_referencia,'
                           + ' :nfe_chave_carta_correcao,'
                           + ' :destinatario_tipo,'
                           + ' :destinatario_cnpj_cpf,'
                           + ' :destinatario_inscricao,'
                           + ' :destinatario_inscricao_suframa,'
                           + ' :destinatario_razao_social,'
                           + ' :destinatario_nome_fantasia,'
                           + ' :destinatario_email,'
                           + ' :destinatario_end_logradouro,'
                           + ' :destinatario_end_numero,'
                           + ' :destinatario_complemento,'
                           + ' :destinatario_bairro,'
                           + ' :destinatario_cidade,'
                           + ' :destinatario_cep,'
                           + ' :destinatario_uf,'
                           + ' :destinatario_ibge_mun,'
                           + ' :destinatario_iibge_uf,'
                           + ' :emitente_tipo,'
                           + ' :emitente_cnpj_cpf,'
                           + ' :emitente_inscricao,'
                           + ' :emitente_inscricao_suframa,'
                           + ' :emitente_razao_social,'
                           + ' :emitente_nome_fantasia,'
                           + ' :emitente_email,'
                           + ' :emitente_end_logradouro,'
                           + ' :emitente_end_numero,'
                           + ' :emitente_complemento,'
                           + ' :emitente_bairro,'
                           + ' :emitente_cidade,'
                           + ' :emitente_cep,'
                           + ' :emitente_uf,'
                           + ' :emitente_ibge_mun,'
                           + ' :emitente_iibge_uf,'
                           + ' :transporte_modalidade,'
                           + ' :transporte_razao_social,'
                           + ' :transporte_nome_fantasia,'
                           + ' :transporte_cnpj_cpf,'
                           + ' :transporte_logradouro,'
                           + ' :transporte_numero,'
                           + ' :transporte_complemento,'
                           + ' :transporte_bairro,'
                           + ' :transporte_cidade,'
                           + ' :transporte_cep,'
                           + ' :transporte_uf,'
                           + ' :transporte_fone,'
                           + ' :observacao_complementar,'
                           + ' :observacao_fisco,'
                           + ' :total_produto,'
                           + ' :total_desconto,'
                           + ' :total_base_icms,'
                           + ' :total_valor_icms,'
                           + ' :total_base_icms_st,'
                           + ' :total_valor_icms_st,'
                           + ' :total_ipi,'
                           + ' :total_pis,'
                           + ' :total_cofins,'
                           + ' :total_fcp,'
                           + ' :total_outras_despesas,'
                           + ' :total_frete,'
                           + ' :total_seguro,'
                           + ' :total_total)';
    end
    else
    begin
      // Update
      QryAx1.SQL.Text :=
                                ' UPDATE documento_fiscal_nfe SET'
                              + ' nfe_numero      = :nfe_numero,'
                              + ' nfe_serie      = :nfe_serie,'
                              + ' nfe_data_emissao      = :nfe_data_emissao,'
                              + ' nfe_data_saida      = :nfe_data_saida,'
                              + ' nfe_natureza_operacao      = :nfe_natureza_operacao,'
                              + ' nfe_forma_emissao      = :nfe_forma_emissao,'
                              + ' nfe_forma_pagamento      = :nfe_forma_pagamento,'
                              + ' nfe_tipo_documento      = :nfe_tipo_documento,'
                              + ' nfe_finalidade_emissao      = :nfe_finalidade_emissao,'
                              + ' nfe_chave      = :nfe_chave,'
                              + ' nfe_situacao      = :nfe_situacao,'
                              + ' nfe_numero_referencia      = :nfe_numero_referencia,'
                              + ' nfe_chave_carta_correcao      = :nfe_chave_carta_correcao,'
                              + ' destinatario_tipo      = :destinatario_tipo,'
                              + ' destinatario_cnpj_cpf      = :destinatario_cnpj_cpf,'
                              + ' destinatario_inscricao      = :destinatario_inscricao,'
                              + ' destinatario_inscricao_suframa      = :destinatario_inscricao_suframa,'
                              + ' destinatario_razao_social      = :destinatario_razao_social,'
                              + ' destinatario_nome_fantasia      = :destinatario_nome_fantasia,'
                              + ' destinatario_email      = :destinatario_email,'
                              + ' destinatario_end_logradouro      = :destinatario_end_logradouro,'
                              + ' destinatario_end_numero      = :destinatario_end_numero,'
                              + ' destinatario_complemento      = :destinatario_complemento,'
                              + ' destinatario_bairro      = :destinatario_bairro,'
                              + ' destinatario_cidade      = :destinatario_cidade,'
                              + ' destinatario_cep      = :destinatario_cep,'
                              + ' destinatario_uf      = :destinatario_uf,'
                              + ' destinatario_ibge_mun      = :destinatario_ibge_mun,'
                              + ' destinatario_iibge_uf      = :destinatario_iibge_uf,'
                              + ' emitente_tipo      = :emitente_tipo,'
                              + ' emitente_cnpj_cpf      = :emitente_cnpj_cpf,'
                              + ' emitente_inscricao      = :emitente_inscricao,'
                              + ' emitente_inscricao_suframa      = :emitente_inscricao_suframa,'
                              + ' emitente_razao_social      = :emitente_razao_social,'
                              + ' emitente_nome_fantasia      = :emitente_nome_fantasia,'
                              + ' emitente_email      = :emitente_email,'
                              + ' emitente_end_logradouro      = :emitente_end_logradouro,'
                              + ' emitente_end_numero      = :emitente_end_numero,'
                              + ' emitente_complemento      = :emitente_complemento,'
                              + ' emitente_bairro      = :emitente_bairro,'
                              + ' emitente_cidade      = :emitente_cidade,'
                              + ' emitente_cep      = :emitente_cep,'
                              + ' emitente_uf      = :emitente_uf,'
                              + ' emitente_ibge_mun      = :emitente_ibge_mun,'
                              + ' emitente_iibge_uf      = :emitente_iibge_uf,'
                              + ' transporte_modalidade      = :transporte_modalidade,'
                              + ' transporte_razao_social      = :transporte_razao_social,'
                              + ' transporte_nome_fantasia      = :transporte_nome_fantasia,'
                              + ' transporte_cnpj_cpf      = :transporte_cnpj_cpf,'
                              + ' transporte_logradouro      = :transporte_logradouro,'
                              + ' transporte_numero      = :transporte_numero,'
                              + ' transporte_complemento      = :transporte_complemento,'
                              + ' transporte_bairro      = :transporte_bairro,'
                              + ' transporte_cidade      = :transporte_cidade,'
                              + ' transporte_cep      = :transporte_cep,'
                              + ' transporte_uf      = :transporte_uf,'
                              + ' transporte_fone      = :transporte_fone,'
                              + ' observacao_complementar      = :observacao_complementar,'
                              + ' observacao_fisco      = :observacao_fisco,'
                              + ' total_produto      = :total_produto,'
                              + ' total_desconto      = :total_desconto,'
                              + ' total_base_icms      = :total_base_icms,'
                              + ' total_valor_icms      = :total_valor_icms,'
                              + ' total_base_icms_st      = :total_base_icms_st,'
                              + ' total_valor_icms_st      = :total_valor_icms_st,'
                              + ' total_ipi      = :total_ipi,'
                              + ' total_pis      = :total_pis,'
                              + ' total_cofins      = :total_cofins,'
                              + ' total_fcp      = :total_fcp,'
                              + ' total_outras_despesas      = :total_outras_despesas,'
                              + ' total_frete      = :total_frete,'
                              + ' total_seguro      = :total_seguro,'
                              + ' total_total      = :total_total'
                              + ' WHERE id          = :id ';
    end;

    QryAx1.Parameters.ParamByName('id').Value          := CadastroId;
    QryAx1.Parameters.ParamByName('nfe_numero').Value       := CdsCadastro.FieldByName('nfe_numero').AsString;
    QryAx1.Parameters.ParamByName('nfe_serie').Value       := CdsCadastro.FieldByName('nfe_serie').AsString;
    QryAx1.Parameters.ParamByName('nfe_data_emissao').Value       := CdsCadastro.FieldByName('nfe_data_emissao').AsString;
    QryAx1.Parameters.ParamByName('nfe_data_saida').Value       := CdsCadastro.FieldByName('nfe_data_saida').AsString;
    QryAx1.Parameters.ParamByName('nfe_natureza_operacao').Value       := CdsCadastro.FieldByName('nfe_natureza_operacao').AsString;
    QryAx1.Parameters.ParamByName('nfe_forma_emissao').Value       := CdsCadastro.FieldByName('nfe_forma_emissao').AsString;
    QryAx1.Parameters.ParamByName('nfe_forma_pagamento').Value       := CdsCadastro.FieldByName('nfe_forma_pagamento').AsString;
    QryAx1.Parameters.ParamByName('nfe_tipo_documento').Value       := CdsCadastro.FieldByName('nfe_tipo_documento').AsString;
    QryAx1.Parameters.ParamByName('nfe_finalidade_emissao').Value       := CdsCadastro.FieldByName('nfe_finalidade_emissao').AsString;
    QryAx1.Parameters.ParamByName('nfe_chave').Value       := CdsCadastro.FieldByName('nfe_chave').AsString;
    QryAx1.Parameters.ParamByName('nfe_situacao').Value       := CdsCadastro.FieldByName('nfe_situacao').AsString;
    QryAx1.Parameters.ParamByName('nfe_numero_referencia').Value       := CdsCadastro.FieldByName('nfe_numero_referencia').AsString;
    QryAx1.Parameters.ParamByName('nfe_chave_carta_correcao').Value       := CdsCadastro.FieldByName('nfe_chave_carta_correcao').AsString;
    QryAx1.Parameters.ParamByName('destinatario_tipo').Value       := CdsCadastro.FieldByName('destinatario_tipo').AsString;
    QryAx1.Parameters.ParamByName('destinatario_cnpj_cpf').Value       := CdsCadastro.FieldByName('destinatario_cnpj_cpf').AsString;
    QryAx1.Parameters.ParamByName('destinatario_inscricao').Value       := CdsCadastro.FieldByName('destinatario_inscricao').AsString;
    QryAx1.Parameters.ParamByName('destinatario_inscricao_suframa').Value       := CdsCadastro.FieldByName('destinatario_inscricao_suframa').AsString;
    QryAx1.Parameters.ParamByName('destinatario_razao_social').Value       := CdsCadastro.FieldByName('destinatario_razao_social').AsString;
    QryAx1.Parameters.ParamByName('destinatario_nome_fantasia').Value       := CdsCadastro.FieldByName('destinatario_nome_fantasia').AsString;
    QryAx1.Parameters.ParamByName('destinatario_email').Value       := CdsCadastro.FieldByName('destinatario_email').AsString;
    QryAx1.Parameters.ParamByName('destinatario_end_logradouro').Value       := CdsCadastro.FieldByName('destinatario_end_logradouro').AsString;
    QryAx1.Parameters.ParamByName('destinatario_end_numero').Value       := CdsCadastro.FieldByName('destinatario_end_numero').AsString;
    QryAx1.Parameters.ParamByName('destinatario_complemento').Value       := CdsCadastro.FieldByName('destinatario_complemento').AsString;
    QryAx1.Parameters.ParamByName('destinatario_bairro').Value       := CdsCadastro.FieldByName('destinatario_bairro').AsString;
    QryAx1.Parameters.ParamByName('destinatario_cidade').Value       := CdsCadastro.FieldByName('destinatario_cidade').AsString;
    QryAx1.Parameters.ParamByName('destinatario_cep').Value       := CdsCadastro.FieldByName('destinatario_cep').AsString;
    QryAx1.Parameters.ParamByName('destinatario_uf').Value       := CdsCadastro.FieldByName('destinatario_uf').AsString;
    QryAx1.Parameters.ParamByName('destinatario_ibge_mun').Value       := CdsCadastro.FieldByName('destinatario_ibge_mun').AsString;
    QryAx1.Parameters.ParamByName('destinatario_iibge_uf').Value       := CdsCadastro.FieldByName('destinatario_iibge_uf').AsString;
    QryAx1.Parameters.ParamByName('emitente_tipo').Value       := CdsCadastro.FieldByName('emitente_tipo').AsString;
    QryAx1.Parameters.ParamByName('emitente_cnpj_cpf').Value       := CdsCadastro.FieldByName('emitente_cnpj_cpf').AsString;
    QryAx1.Parameters.ParamByName('emitente_inscricao').Value       := CdsCadastro.FieldByName('emitente_inscricao').AsString;
    QryAx1.Parameters.ParamByName('emitente_inscricao_suframa').Value       := CdsCadastro.FieldByName('emitente_inscricao_suframa').AsString;
    QryAx1.Parameters.ParamByName('emitente_razao_social').Value       := CdsCadastro.FieldByName('emitente_razao_social').AsString;
    QryAx1.Parameters.ParamByName('emitente_nome_fantasia').Value       := CdsCadastro.FieldByName('emitente_nome_fantasia').AsString;
    QryAx1.Parameters.ParamByName('emitente_email').Value       := CdsCadastro.FieldByName('emitente_email').AsString;
    QryAx1.Parameters.ParamByName('emitente_end_logradouro').Value       := CdsCadastro.FieldByName('emitente_end_logradouro').AsString;
    QryAx1.Parameters.ParamByName('emitente_end_numero').Value       := CdsCadastro.FieldByName('emitente_end_numero').AsString;
    QryAx1.Parameters.ParamByName('emitente_complemento').Value       := CdsCadastro.FieldByName('emitente_complemento').AsString;
    QryAx1.Parameters.ParamByName('emitente_bairro').Value       := CdsCadastro.FieldByName('emitente_bairro').AsString;
    QryAx1.Parameters.ParamByName('emitente_cidade').Value       := CdsCadastro.FieldByName('emitente_cidade').AsString;
    QryAx1.Parameters.ParamByName('emitente_cep').Value       := CdsCadastro.FieldByName('emitente_cep').AsString;
    QryAx1.Parameters.ParamByName('emitente_uf').Value       := CdsCadastro.FieldByName('emitente_uf').AsString;
    QryAx1.Parameters.ParamByName('emitente_ibge_mun').Value       := CdsCadastro.FieldByName('emitente_ibge_mun').AsString;
    QryAx1.Parameters.ParamByName('emitente_iibge_uf').Value       := CdsCadastro.FieldByName('emitente_iibge_uf').AsString;
    QryAx1.Parameters.ParamByName('transporte_modalidade').Value       := CdsCadastro.FieldByName('transporte_modalidade').AsString;
    QryAx1.Parameters.ParamByName('transporte_razao_social').Value       := CdsCadastro.FieldByName('transporte_razao_social').AsString;
    QryAx1.Parameters.ParamByName('transporte_nome_fantasia').Value       := CdsCadastro.FieldByName('transporte_nome_fantasia').AsString;
    QryAx1.Parameters.ParamByName('transporte_cnpj_cpf').Value       := CdsCadastro.FieldByName('transporte_cnpj_cpf').AsString;
    QryAx1.Parameters.ParamByName('transporte_logradouro').Value       := CdsCadastro.FieldByName('transporte_logradouro').AsString;
    QryAx1.Parameters.ParamByName('transporte_numero').Value       := CdsCadastro.FieldByName('transporte_numero').AsString;
    QryAx1.Parameters.ParamByName('transporte_complemento').Value       := CdsCadastro.FieldByName('transporte_complemento').AsString;
    QryAx1.Parameters.ParamByName('transporte_bairro').Value       := CdsCadastro.FieldByName('transporte_bairro').AsString;
    QryAx1.Parameters.ParamByName('transporte_cidade').Value       := CdsCadastro.FieldByName('transporte_cidade').AsString;
    QryAx1.Parameters.ParamByName('transporte_cep').Value       := CdsCadastro.FieldByName('transporte_cep').AsString;
    QryAx1.Parameters.ParamByName('transporte_uf').Value       := CdsCadastro.FieldByName('transporte_uf').AsString;
    QryAx1.Parameters.ParamByName('transporte_fone').Value       := CdsCadastro.FieldByName('transporte_fone').AsString;
    QryAx1.Parameters.ParamByName('observacao_complementar').Value       := CdsCadastro.FieldByName('observacao_complementar').AsString;
    QryAx1.Parameters.ParamByName('observacao_fisco').Value       := CdsCadastro.FieldByName('observacao_fisco').AsString;
    QryAx1.Parameters.ParamByName('total_produto').Value       := CdsCadastro.FieldByName('total_produto').AsString;
    QryAx1.Parameters.ParamByName('total_desconto').Value       := CdsCadastro.FieldByName('total_desconto').AsString;
    QryAx1.Parameters.ParamByName('total_base_icms').Value       := CdsCadastro.FieldByName('total_base_icms').AsString;
    QryAx1.Parameters.ParamByName('total_valor_icms').Value       := CdsCadastro.FieldByName('total_valor_icms').AsString;
    QryAx1.Parameters.ParamByName('total_base_icms_st').Value       := CdsCadastro.FieldByName('total_base_icms_st').AsString;
    QryAx1.Parameters.ParamByName('total_valor_icms_st').Value       := CdsCadastro.FieldByName('total_valor_icms_st').AsString;
    QryAx1.Parameters.ParamByName('total_ipi').Value       := CdsCadastro.FieldByName('total_ipi').AsString;
    QryAx1.Parameters.ParamByName('total_pis').Value       := CdsCadastro.FieldByName('total_pis').AsString;
    QryAx1.Parameters.ParamByName('total_cofins').Value       := CdsCadastro.FieldByName('total_cofins').AsString;
    QryAx1.Parameters.ParamByName('total_fcp').Value       := CdsCadastro.FieldByName('total_fcp').AsString;
    QryAx1.Parameters.ParamByName('total_outras_despesas').Value       := CdsCadastro.FieldByName('total_outras_despesas').AsString;
    QryAx1.Parameters.ParamByName('total_frete').Value       := CdsCadastro.FieldByName('total_frete').AsString;
    QryAx1.Parameters.ParamByName('total_seguro').Value       := CdsCadastro.FieldByName('total_seguro').AsString;
    QryAx1.Parameters.ParamByName('total_total').Value       := CdsCadastro.FieldByName('total_total').AsString;

    try
      // Tenta salvar os dados
      QryAx1.ExecSQL;
    except
      on E: Exception do
      begin
        // Descarta a transação
        ADOConnection.RollbackTrans;
        MessageDlg('Não foi possível salvar os dados alterados.'^M''+ 'Erro de gravação '+ E.Message, mtWarning, [mbOK]);
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

procedure TControleCadastroDocumentosFiscaisNFe.UniButton6Click(
  Sender: TObject);
begin
  Try
    with UniFileUpload1 do
    begin
      MaxAllowedSize := 5000000;
      Execute;
    end;
  Except
    on e:Exception do
    begin
      ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));
    end;
  End;
end;

procedure TControleCadastroDocumentosFiscaisNFe.UniFileUpload1Completed(
  Sender: TObject; AStream: TFileStream);
var
  DestName : string;
  DestFolder : string;
begin
  Try
    if not DirectoryExists(ControleServerModule.StartPath+'UploadFolder\') then
      CreateDir(ControleServerModule.StartPath+'UploadFolder\');

    if not DirectoryExists(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\') then
      CreateDir(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\');

    if not DirectoryExists(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\'+ 'xml\' ) then
      CreateDir(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\'+ 'xml\' );

    DestFolder  := ControleServerModule.StartPath + 'UploadFolder\' + ControleMainModule.FSchema + '\' + 'xml\';
    DestName    := DestFolder + ExtractFileName(UniFileUpload1.FileName);
    CopyFile(PChar(AStream.FileName), PChar(DestName), False);

    ImportaXML(DestName);
  Except
    on e:exception do
    begin
      ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(e.Message));
    end;
  End;
end;

procedure TControleCadastroDocumentosFiscaisNFe.UniPageControl1Change(
  Sender: TObject);
begin
  inherited;
  if UniPageControl1.ActivePageIndex = 2 then
  begin
   // CdsProduto.Refresh;
  end;

end;

procedure TControleCadastroDocumentosFiscaisNFe.ImportaXML(Caminho: String);
var
  i, n: integer;
begin
  ACBrNFe1.NotasFiscais.LoadFromFile(Caminho);

  with ACBrNFe1.NotasFiscais.Items[0].NFe do
  begin
    With CdsCadastro do
    begin
      // Cabeçalho
      CdsCadastroNFE_NUMERO.AsString            := IntToStr(Ide.nNF);
      CdsCadastroNFE_SERIE.AsString             := IntToStr(Ide.serie);
      CdscadastroNFE_DATA_EMISSAO.AsString      := DateToStr(Ide.dEmi);
//      CdscadastroNFE_DATA_SAIDA.AsString        := DateToStr(Ide.dSaiEnt);
      CdsCadastroNFE_NATUREZA_OPERACAO.AsString := Ide.natOp;
//      CdsCadastroNFE_HORA_SAIDA                 := Ide.hSaiEnt;
      CdsCadastroNFE_CHAVE.AsString             := '';// Seré gerada a nova chave, pois a nfe é de devolução
      CdsCadastroNFE_NUMERO_REFERENCIA.AsString := Copy(infNFe.ID,4,44);
      CdsCadastroNFE_FORMA_PAGAMENTO.AsString   := FormaPagamentoToStr(pag.Items[0].tPag);
      UniEditformaPag.Text                      := FormaPagamentoToDescricao(pag.Items[0].tPag);
//      CdsCadastroNFE_TIPO_DOCUMENTO             := StrToPercTrib(ide.tpEmis);
      CdsCadastroNFE_FINALIDADE_EMISSAO.AsString:=  '4';//devolução
      CdsCadastroNFE_TIPO_DOCUMENTO.AsString    := TpEmisToStr(Ide.tpEmis);

      // EMITENTE
      CdsCadastroEMITENTE_CNPJ_CPF.AsString             := Dest.CNPJCPF;
      CdsCadastroEMITENTE_RAZAO_SOCIAL.AsString         := Dest.xNome;
      CdsCadastroEMITENTE_NOME_FANTASIA.AsString        := Dest.xNome;
      CdsCadastroEMITENTE_INSCRICAO.AsString            := Dest.IE;
      CdsCadastroEMITENTE_INSCRICAO_SUFRAMA.AsString    := Dest.ISUF;
      CdsCadastroEMITENTE_EMAIL.AsString                := Dest.Email;

      // Endereço EMITENTE
      CdsCadastroEMITENTE_END_LOGRADOURO.AsString       := Dest.EnderDest.xLgr;
      CdsCadastroEMITENTE_END_NUMERO.AsString           := Dest.EnderDest.nro;
      CdsCadastroEMITENTE_COMPLEMENTO.AsString          := Dest.EnderDest.xCpl;
      CdsCadastroEMITENTE_BAIRRO.AsString               := Dest.EnderDest.xBairro;
      CdsCadastroEMITENTE_CIDADE.AsString               := Dest.EnderDest.xMun;
      CdsCadastroEMITENTE_UF.AsString                   := Dest.EnderDest.UF;
      CdsCadastroEMITENTE_IBGE_MUN.AsString             := IntToStr(Dest.EnderDest.cMun);
      CdsCadastroEMITENTE_IIBGE_UF.AsString             := Copy(IntToStr(Dest.EnderDest.cMun),1,2);
      CdsCadastroEMITENTE_CEP.AsString                  := IntToStr(Dest.EnderDest.CEP);

      // DESTINATARIO
      CdsCadastroDESTINATARIO_CNPJ_CPF.AsString             := Emit.CNPJCPF;
      CdsCadastroDESTINATARIO_RAZAO_SOCIAL.AsString         := Emit.xNome;
      CdsCadastroDESTINATARIO_NOME_FANTASIA.AsString        := Emit.xNome;
      CdsCadastroDESTINATARIO_INSCRICAO.AsString            := Emit.IE;
      CdsCadastroDESTINATARIO_INSCRICAO_SUFRAMA.AsString    := Emit.IEST;
//      CdsCadastroDESTINATARIO_EMAIL.AsString                := Emit.En;

      // Endereço DESTINATARIO
      CdsCadastroDESTINATARIO_END_LOGRADOURO.AsString       := Emit.EnderEmit.xLgr;
      CdsCadastroDESTINATARIO_END_NUMERO.AsString           := Emit.EnderEmit.nro;
      CdsCadastroDESTINATARIO_COMPLEMENTO.AsString          := Emit.EnderEmit.xCpl;
      CdsCadastroDESTINATARIO_BAIRRO.AsString               := Emit.EnderEmit.xBairro;
      CdsCadastroDESTINATARIO_CIDADE.AsString               := Emit.EnderEmit.xMun;
      CdsCadastroDESTINATARIO_UF.AsString                   := Emit.EnderEmit.UF;
      CdsCadastroDESTINATARIO_IBGE_MUN.AsString             := IntToStr(Emit.EnderEmit.cMun);
      CdsCadastroDESTINATARIO_IIBGE_UF.AsString             := Copy(IntToStr(Emit.EnderEmit.cMun),1,2);
      CdsCadastroDESTINATARIO_CEP.AsString                  := IntToStr(Emit.EnderEmit.CEP);

      // Totais
      CdsCadastroTOTAL_IPI.AsString             := FloatToStr(Total.ICMSTot.vIPI);
      CdsCadastroTOTAL_PIS.AsString             := FloatToStr(Total.ICMSTot.vPIS);
      CdsCadastroTOTAL_FCP.AsString             := FloatToStr(Total.ICMSTot.vFCP);
      CdsCadastroTOTAL_TOTAL.AsString           := FloatToStr(Total.ICMSTot.vNF);
      CdsCadastroTOTAL_FRETE.AsString           := FloatToStr(Total.ICMSTot.vFrete);
      CdsCadastroTOTAL_COFINS.AsString          := FloatToStr(Total.ICMSTot.vCOFINS);
      CdsCadastroTOTAL_SEGURO.AsString          := FloatToStr(Total.ICMSTot.vSeg);
      CdsCadastroTOTAL_PRODUTO.AsString         := FloatToStr(Total.ICMSTot.vProd);
      CdsCadastroTOTAL_DESCONTO.AsString        := FloatToStr(Total.ICMSTot.vDesc);
      CdsCadastroTOTAL_BASE_ICMS.AsString       := FloatToStr(Total.ICMSTot.vBC);
      CdsCadastroTOTAL_VALOR_ICMS.AsString      := FloatToStr(Total.ICMSTot.vICMS);
      CdsCadastroTOTAL_BASE_ICMS_ST.AsString    := FloatToStr(Total.ICMSTot.vBCST);
      CdsCadastroTOTAL_VALOR_ICMS_ST.AsString   := FloatToStr(Total.ICMSTot.vST);
      CdsCadastroTOTAL_OUTRAS_DESPESAS.AsString := FloatToStr(Total.ICMSTot.vOutro);

      for i := 0 to Det.Count-1 do
      begin
        with Det.Items[I] do
        begin
          // Inserindo produto
          CdsProduto.Insert;

          CdsProdutoDOCUMENTO_FISCAL_NFE_ID.AsInteger := CdsCadastroID.AsInteger;
          CdsProdutoPRODUTO_ID.AsString               := Prod.cProd;
          CdsProdutoDESCRICAO.AsString                := FiltraTexto(Prod.xProd);
          CdsProdutoUNIDADE.AsString                  := Prod.uCom;
          CdsProdutoQUANTIDADE.AsString               := FloatToStr(Prod.qCom);
          CdsProdutoVALOR_UNITARIO.AsString           := FloatToStr(Prod.vUnCom);
          CdsProdutoVALOR_TOTAL.AsString              := FloatToStr(Prod.vProd);
          CdsProdutoCFOP.AsString                     := Prod.CFOP;
          CdsProdutoNCM.AsString                      := Prod.NCM;
          CdsProdutoOUTRAS_DESPESAS.AsString          := FloatToStr(Prod.vOutro);
          CdsProdutoFRETE.AsString                    := FloatToStr(Prod.vFrete);
          CdsProdutoSEGURO.AsString                   := FloatToStr(Prod.vSeg);
          CdsProdutoDESCONTO.AsString                 := FloatToStr(Prod.vDesc);
          CdsProdutoCOD_BARRAS.AsString               := Prod.cEAN;

          with Imposto do
          begin
            with ICMS do
            begin
              //inserindo impostos
              CdsProdutoICMS_SITUACAO_TRIBUTARIA.AsString := CSTICMSToStr(ICMS.CST);
              CdsProdutoICMS_ORIGEM.AsString                    := OrigToStr(ICMS.orig);
              CdsProdutoICMS_MODALIDADE_DETERMINACAO.AsString   := modBCToStr(ICMS.modBC);
              CdsProdutoICMS_PERCENTUAL_REDUCAO_BC.AsString     := FloatToStr(ICMS.pRedBC);
              CdsProdutoICMS_BASE_CALCULO.AsString              := FloatToStr(ICMS.vBC);
              CdsProdutoICMS_ALIQUOTA.AsString                  := FloatToStr(ICMS.pICMS);
              CdsProdutoICMS_VALOR.AsString                     := FloatToStr(ICMS.vICMS);
              CdsProdutoICMS_ST_MODALIDADE_DETERMINACA.AsString := modBCSTToStr(ICMS.modBCST);
              CdsProdutoICMS_ST_ALIQUOTA_PERCENTUAL.AsString    := FloatToStr(ICMS.pRedBCST);
              CdsProdutoICMS_ST_BASE_CALCULO.AsString           := FloatToStr(ICMS.vBCST);
              CdsProdutoICMS_ST_ALIQUOTA_PERCENTUAL.AsString    := FloatToStr(ICMS.pICMSST);
              CdsProdutoICMS_ST_VALOR.AsString                  := FloatToStr(ICMS.vICMSST);
              CdsProdutoICMS_CRED_PERCENTUAL.AsString           := FloatToStr(ICMS.pCredSN);
              CdsProdutoICMS_CRED_VALOR.AsString                := FloatToStr(ICMS.vCredICMSSN);
            end;

            with IPI do
            begin
              CdsProdutoIPI_SITUACAO_TRIBUTARIA.AsString        := '49';
              CdsProdutoIPI_CLASSE_ENQUADRAMENTO.AsString       := clEnq;
              CdsProdutoIPI_CODIGO_ENQUADRAMENTO.AsString       := cEnq;
              CdsProdutoIPI_CNPJPRODUTOR.AsString               := CNPJProd;
              CdsProdutoIPI_CODIGO_SELO_CONTROLE.AsString       := cSelo;
              CdsProdutoIPI_QUANT_SELO_CONTROLE.AsString        := IntToStr(qSelo);
              CdsProdutoIPI_TIPO_CALCULO.AsString               := '01';//nao encontrei referencia
              //valores
              CdsProdutoIPI_VALOR_BASE_CALCULO.AsString         := FloatToStr(vBC);
              CdsProdutoIPI_QUANT_UNIDADE_PADRAO.AsString       := FloatToStr(qUnid);
              CdsProdutoIPI_ALIQUOTA_PERCENTUAL.AsString        := FloatToStr(pIPI);
              CdsProdutoIPI_VALOR_UNIDADE.AsString              := FloatToStr(vUnid);
              CdsProdutoIPI_VALOR_IPI.AsString                  := FloatToStr(vIPI);
            end;

            With PIS do
            begin
              CdsProdutoPIS_SITUACAO_TRIBUTARIA.AsString := CSTPISToStr(CST);
              CdsProdutoPIS_VALOR_BASE_CALCULO.AsString  := FloatToStr(PIS.vBC);
              CdsProdutoPIS_VALOR_ALIQUOTA.AsString      := FloatToStr(PIS.pPIS);
              CdsProdutoPIS_QUANT_VENDIDA.AsString       := FloatToStr(qBCProd);
              CdsProdutoPIS_VALOR.AsString               := FloatToStr(PIS.vPIS);
            end;

            With COFINS do
            begin
              CdsProdutoCOFINS_SITUACAO_TRIBUTARIA.AsString := CSTCOFINSToStr(CST);
              CdsProdutoCOFINS_VALOR_BASE_CALCULO.AsString  := FloatToStr(COFINS.vBC);
              CdsProdutoCOFINS_VALOR_ALIQUOTA.AsString      := FloatToStr(COFINS.pCOFINS);
              CdsProdutoCOFINS_QUANT_VENDIDA.AsString       := FloatToStr(qBCProd);
              CdsProdutoCOFINS_VALOR.AsString               := FloatToStr(COFINS.vCOFINS);
            end;

            With PISST do
            begin
//              CdsProdutoPIS_ST_SITUACAO_TRIBUTARIA.AsString := CSTPISToStr(CST);
              CdsProdutoPIS_ST_VALOR_BASE_CALCULO.AsString  := FloatToStr(PISST.vBC);
              CdsProdutoPIS_ST_VALOR_ALIQUOTA.AsString      := FloatToStr(PISST.pPIS);
//              CdsProdutoPIS_ST_QUANT_VENDIDA.AsString       := FloatToStr(qBCSTProd);
              CdsProdutoPIS_ST_VALOR.AsString               := FloatToStr(PISST.vPIS);
            end;

            With COFINSST do
            begin
//              CdsProdutoCOFINS_ST_SITUACAO_TRIBUTARIA.AsString := CSTPISToStr(CST);
              CdsProdutoCOFINS_ST_VALOR_BASE_CALCULO.AsString  := FloatToStr(COFINSST.vBC);
              CdsProdutoCOFINS_ST_VALOR_ALIQUOTA.AsString      := FloatToStr(COFINSST.pCOFINS);
  //            CdsProdutoCOFINS_ST_QUANT_VENDIDA.AsString       := FloatToStr(qBCProd);
              CdsProdutoCOFINS_ST_VALOR.AsString               := FloatToStr(COFINSST.vCOFINS);
            end;
          end;
          CdsProduto.Post;
        end;
      end;
    end;
  end;
end;

function TControleCadastroDocumentosFiscaisNFe.FiltraTexto(Texto: String): String;
var
  i: Integer;
  Teste,Teste2 : String;
  Cont  : Word;
begin
  Result := StringReplace(Texto, '''', '', []);
end;

end.
