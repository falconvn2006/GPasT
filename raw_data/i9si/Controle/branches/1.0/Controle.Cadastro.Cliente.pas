unit Controle.Cadastro.Cliente;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Controle.Cadastro, uniGUIBaseClasses, uniImageList,
  uniButton, uniPanel, uniMultiItem, uniComboBox, uniDBComboBox, uniEdit,
  uniDBEdit, uniLabel, uniBitBtn, uniSpeedButton, Data.DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, uniPageControl, uniMemo, uniDBMemo,
  uniGroupBox, ACBrBase, ACBrSocket, ACBrCEP, Datasnap.DBClient,
  Datasnap.Provider, Data.Win.ADODB, uniImage, uniDBLookupComboBox, ACBrValidador,
  uniSweetAlert, uniFileUpload, Vcl.Imaging.GIFImg, Funcoes.client,
  uniBasicGrid, uniDBGrid, uniTimer, Vcl.Imaging.pngimage, System.Math,
  uniCheckBox, uniDBCheckBox;

type
  TrecebeRetorno = class
  private
    FnRetorno: TRetornos;
    procedure SetnRetorno(const Value: TRetornos);
  published
    property nRetorno : TRetornos read FnRetorno write SetnRetorno;
  end;

type
  TBase64 = class
  private
    FArquivoBase64: string;
  published
    property ArquivoBase64: string read FArquivoBase64 write FArquivoBase64;
  end;


type
  TControleCadastroCliente = class(TControleCadastro)
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
    UniPanel5: TUniPanel;
    QryCadastroCODIGO_REGIME_TRIBUTARIO: TWideStringField;
    CdsCadastroCODIGO_REGIME_TRIBUTARIO: TWideStringField;
    DbComboCRT: TUniDBComboBox;
    ACBrCEP1: TACBrCEP;
    UniFileUpload1: TUniFileUpload;
    QryCadastroFOTO_CAMINHO: TWideStringField;
    CdsCadastroFOTO_CAMINHO: TWideStringField;
    BotaoEnviaMensagem: TUniButton;
    QryEnviaMensagem: TADOQuery;
    QryEnviaMensagemID: TFMTBCDField;
    QryEnviaMensagemURL_API: TWideStringField;
    QryEnviaMensagemTOKEN_API: TWideStringField;
    QryEnviaMensagemTEXTO_ANTES_VENCIMENTO: TWideStringField;
    QryEnviaMensagemTEXTO_DEPOIS_VENCIMENTO: TWideStringField;
    QryEnviaMensagemDIAS_ANTES_VENCIMENTO: TFMTBCDField;
    QryEnviaMensagemDIAS_DEPOIS_VENCIMENTO: TFMTBCDField;
    QryEnviaMensagemDIAS_INTERVALO_ENTRE_COBRANCA: TFMTBCDField;
    QryEnviaMensagemQUANT_DIAS_DE_COBRANCA: TFMTBCDField;
    QryEnviaMensagemFOTO_CAMINHO: TWideStringField;
    ProvEnviaMensagem: TDataSetProvider;
    CdsEnviaMensagem: TClientDataSet;
    CdsEnviaMensagemID: TFMTBCDField;
    CdsEnviaMensagemURL_API: TWideStringField;
    CdsEnviaMensagemTOKEN_API: TWideStringField;
    CdsEnviaMensagemTEXTO_ANTES_VENCIMENTO: TWideStringField;
    CdsEnviaMensagemTEXTO_DEPOIS_VENCIMENTO: TWideStringField;
    CdsEnviaMensagemDIAS_ANTES_VENCIMENTO: TFMTBCDField;
    CdsEnviaMensagemDIAS_DEPOIS_VENCIMENTO: TFMTBCDField;
    CdsEnviaMensagemDIAS_INTERVALO_ENTRE_COBRANCA: TFMTBCDField;
    CdsEnviaMensagemQUANT_DIAS_DE_COBRANCA: TFMTBCDField;
    CdsEnviaMensagemFOTO_CAMINHO: TWideStringField;
    CdsCloneTotais: TClientDataSet;
    DspCloneTotais: TDataSetProvider;
    DscCloneTotais: TDataSource;
    DscConsulta: TDataSource;
    DspConsulta: TDataSetProvider;
    ClientDataSet1: TClientDataSet;
    FloatField1: TFloatField;
    CdsCadastroURL_API: TWideStringField;
    CdsCadastroTOKEN_API: TWideStringField;
    CdsCadastroTEXTO_ANTES_VENCIMENTO: TWideStringField;
    CdsCadastroTEXTO_DEPOIS_VENCIMENTO: TWideStringField;
    CdsCadastroDIAS_ANTES_VENCIMENTO: TFloatField;
    CdsCadastroDIAS_DEPOIS_VENCIMENTO: TFloatField;
    CdsCadastroDIAS_INTERVALO_ENTRE_COBRANCA: TFloatField;
    CdsCadastroQUANT_DIAS_DE_COBRANCA: TFloatField;
    WideStringField1: TWideStringField;
    CdsClone: TClientDataSet;
    DataSetProvider1: TDataSetProvider;
    DataSource1: TDataSource;
    DscCloneItens: TDataSource;
    DspCloneItens: TDataSetProvider;
    CdsCloneItens: TClientDataSet;
    CdsCloneItens2: TClientDataSet;
    DspCloneItens2: TDataSetProvider;
    DscCloneItens2: TDataSource;
    QryEnviaMensagemTEXTO_BOAS_VINDAS: TWideStringField;
    CdsEnviaMensagemTEXTO_BOAS_VINDAS: TWideStringField;
    QryEnviaMensagemURL_RETORNO: TWideStringField;
    CdsEnviaMensagemURL_RETORNO: TWideStringField;
    UniTimerEnviaWhatsappTeste: TUniTimer;
    QryCadastroASSINATURA_CAMINHO: TWideStringField;
    CdsCadastroASSINATURA_CAMINHO: TWideStringField;
    UniFileUpload2: TUniFileUpload;
    QryCadastroLIMITE_CREDITO: TFloatField;
    CdsCadastroLIMITE_CREDITO: TFloatField;
    DspTitulos: TDataSetProvider;
    DscTitulos: TDataSource;
    CdsTitulos: TClientDataSet;
    QryTitulos: TADOQuery;
    CdsTitulosID: TFloatField;
    CdsTitulosDATA_EMISSAO: TWideStringField;
    CdsTitulosDATA_VENCIMENTO: TWideStringField;
    CdsTitulosVALOR: TFloatField;
    CdsTitulosSITUACAO: TWideStringField;
    CdsTitulosTOTAL_EM_ATRASO: TFloatField;
    CdsTitulosTOTAL_EM_ABERTO: TFloatField;
    UniPagePrincipal: TUniPageControl;
    UniTabSheet14: TUniTabSheet;
    UniTabSheet15: TUniTabSheet;
    UniPanel8: TUniPanel;
    DBComboSexo: TUniDBComboBox;
    DbComboTipo: TUniDBComboBox;
    DbEditFantasia: TUniDBEdit;
    DBEdtCpfCnpj: TUniDBEdit;
    DBEdtDataExped: TUniDBEdit;
    DBEdtNascimento: TUniDBEdit;
    DBEdtNome: TUniDBEdit;
    DBEdtOrgaoExped: TUniDBEdit;
    DBEdtRg: TUniDBEdit;
    LabelCpfCnpj: TUniLabel;
    LabelCRT: TUniLabel;
    LabelDataExped: TUniLabel;
    LabelNascimento: TUniLabel;
    LabelNomeRazao: TUniLabel;
    LabelOrgaoExped: TUniLabel;
    LabelPopularFantasia: TUniLabel;
    LabelRgIe: TUniLabel;
    LabelSexo: TUniLabel;
    UniDBComboBox1: TUniDBComboBox;
    UniLabel1: TUniLabel;
    UniLabel2: TUniLabel;
    UniPageDadosPrincipais: TUniPageControl;
    UniTabSheet1: TUniTabSheet;
    UniGroupBox1: TUniGroupBox;
    UniLabel7: TUniLabel;
    DBEditCepGeral: TUniDBEdit;
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
    BotaoCEPGeral: TUniSpeedButton;
    UniGroupBox2: TUniGroupBox;
    UniLabel14: TUniLabel;
    UniLabel15: TUniLabel;
    DBEditEmailGeral: TUniDBEdit;
    UniDBEdit10: TUniDBEdit;
    UniLabel16: TUniLabel;
    DBEditCelular: TUniDBEdit;
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
    UniTabSheet5: TUniTabSheet;
    UniPageControlPrincipal: TUniPageControl;
    UniTabSheet6: TUniTabSheet;
    DBGridDadosTotais: TUniDBGrid;
    UniTabSheet7: TUniTabSheet;
    DBGridDadosItens: TUniDBGrid;
    UniTabSheet11: TUniTabSheet;
    MemoEnvioUrl: TUniMemo;
    UniTabSheet12: TUniTabSheet;
    MemoEnvioJson: TUniMemo;
    UniTabSheet13: TUniTabSheet;
    MemoRetorno: TUniMemo;
    UniPageFotoAssinatura: TUniPageControl;
    UniTabSheet8: TUniTabSheet;
    UniPanel3: TUniPanel;
    ImageFoto: TUniImage;
    ButtonImportaImagem: TUniButton;
    BotaoApagarImagem: TUniButton;
    UniLabel18: TUniLabel;
    UniTabSheet9: TUniTabSheet;
    BotaoApagarAssinatura: TUniButton;
    ButtonImportaAssinatura: TUniButton;
    UniLabel23: TUniLabel;
    UniPanel4: TUniPanel;
    ImageAssinatura: TUniImage;
    UniGroupBox7: TUniGroupBox;
    UniLabel36: TUniLabel;
    UniDBEditMae: TUniDBEdit;
    UniLabel43: TUniLabel;
    UniDBEditCelularMae: TUniDBEdit;
    UniDBEditCelularPai: TUniDBEdit;
    UniLabel46: TUniLabel;
    UniLabel49: TUniLabel;
    UniDBEditCelularOutrasPessoas: TUniDBEdit;
    UniDBEditOutrasPessoas: TUniDBEdit;
    UniDBEditPai: TUniDBEdit;
    UniLabel44: TUniLabel;
    UniLabel48: TUniLabel;
    UniGroupBox8: TUniGroupBox;
    UniPanel9: TUniPanel;
    UniDBGrid2: TUniDBGrid;
    UniPanel10: TUniPanel;
    LabelTotalAtraso: TUniLabel;
    UniLabel45: TUniLabel;
    UniImage2: TUniImage;
    UniPanel12: TUniPanel;
    LabelTotalAberto: TUniLabel;
    UniLabel47: TUniLabel;
    UniImage4: TUniImage;
    UniPanel7: TUniPanel;
    UniLabel42: TUniLabel;
    EditNumberLimiteCredito: TUniDBFormattedNumberEdit;
    QryCadastroDADOS_ADICIONAIS_ID: TFloatField;
    QryCadastroNOME_MAE: TWideStringField;
    QryCadastroNOME_PAI: TWideStringField;
    QryCadastroNOME_OUTRAS_PESSOAS: TWideStringField;
    QryCadastroCELULAR_MAE: TWideStringField;
    QryCadastroCELULAR_PAI: TWideStringField;
    QryCadastroCELULAR_OUTRAS_PESSOAS: TWideStringField;
    CdsCadastroDADOS_ADICIONAIS_ID: TFloatField;
    CdsCadastroNOME_MAE: TWideStringField;
    CdsCadastroNOME_PAI: TWideStringField;
    CdsCadastroNOME_OUTRAS_PESSOAS: TWideStringField;
    CdsCadastroCELULAR_MAE: TWideStringField;
    CdsCadastroCELULAR_PAI: TWideStringField;
    CdsCadastroCELULAR_OUTRAS_PESSOAS: TWideStringField;
    QryCadastroACEITA_ENVIO_MENSAGEM: TWideStringField;
    CdsCadastroACEITA_ENVIO_MENSAGEM: TWideStringField;
    UniDBCheckBox1: TUniDBCheckBox;
    procedure BotaoCEPGeralClick(Sender: TObject);
    procedure BotaoCEPComercialClick(Sender: TObject);
    procedure BotaoCEPCobrancaClick(Sender: TObject);
    procedure UniFormShow(Sender: TObject);
    procedure ButtonPesquisaCidadeGeralClick(Sender: TObject);
    procedure DbComboTipoChange(Sender: TObject);
    procedure DBEditCepGeralExit(Sender: TObject);
    procedure DBEdtCpfCnpjExit(Sender: TObject);
    procedure ButtonImportaImagemClick(Sender: TObject);
    procedure UniFileUpload1Completed(Sender: TObject; AStream: TFileStream);
    procedure BotaoApagarImagemClick(Sender: TObject);
    procedure BotaoEnviaMensagemClick(Sender: TObject);
    procedure UniTimerEnviaWhatsappTesteTimer(Sender: TObject);
    procedure UniFileUpload2Completed(Sender: TObject; AStream: TFileStream);
    procedure ButtonImportaAssinaturaClick(Sender: TObject);
    procedure BotaoApagarAssinaturaClick(Sender: TObject);
    procedure UniPagePrincipalChange(Sender: TObject);
  private
    recebeRetorno : TrecebeRetorno;
    function SubstituiTextoMensagem(Texto: string): String;
    procedure AlimentaConfiguracoes(url, tokenAPI, cryptKey, uuid_safe: String);
      stdcall;
    function EnviaMensagemVerificaAPIAtiva: TRetornos;
    function EnviaMensagem(Celular: string;
                                                Texto: string;
                                                TokenApi: string;
                                                ArquivoBase64: String = '';
                                                NumeroClient: String = '1';
                                                UrlRetorno: string = '';
                                                TestaWhatsapp: string = 'N'): TRetornos;
    function EnviaMensagemCancelaVerificaWhatsAppAtivo(
      Celular: string): TRetornos;
    procedure PreencheLimiteCredito;
    Procedure AtualizaStatusWhatsapp(id: Integer;
                                                         Tipo: String);
    { Private declarations }
  public
    { Public declarations }
   // Funções

    URL_LOGO : String;
    URL_ASSINATURA : String;
    TempoLimite: integer;
    IgnoraCampos : string;
    function Abrir(Id: Integer): Boolean; override;
    function Novo(): Boolean; override;
    function Editar(Id: Integer): Boolean; override;
    function Salvar: Boolean; override;
    function Descartar: Boolean; override;
    procedure ConfiguraTipoPessoa;
  end;

function ControleCadastroCliente: TControleCadastroCliente;

var
  Base64 : TBase64;
  ListaOrdenada: string;
  ArquivoBase64: String;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication, Controle.Funcoes, Controle.Consulta,
  Controle.Consulta.Modal.Pessoa, Controle.Consulta.Modal.Cidade,
  Controle.Server.Module, Envia.Recebe.Dados.Json, REST.Types, System.AnsiStrings,
  Client.Aguarde;
function ControleCadastroCliente: TControleCadastroCliente;
begin
  Result := TControleCadastroCliente(ControleMainModule.GetFormInstance(TControleCadastroCliente));
end;

{ TControleCadastroCliente }

function TControleCadastroCliente.Abrir(Id: Integer): Boolean;
begin
  Result := False;

  // Abre o registro
  CdsCadastro.Close;
  QryCadastro.Parameters.ParamByName('id').Value := Id;
  CdsCadastro.Open;

  URL_LOGO := CdsCadastroFOTO_CAMINHO.AsString;
  URL_ASSINATURA := CdsCadastroASSINATURA_CAMINHO.AsString;
  // carregando a imagem
  ControleFuncoes.CarregaImagemGeral(CdsCadastroFOTO_CAMINHO.AsString,
                                     ImageFoto);
  ControleFuncoes.CarregaImagemGeral(CdsCadastroASSINATURA_CAMINHO.AsString,
                                     ImageAssinatura);


  // Se algum registro foi solicitado, deve parar se não encontrar
  if (Id > 0) and CdsCadastro.IsEmpty then
    Exit;

  // Bloqueia o registro para edição
  DscCadastro.AutoEdit := False;

  // Configura os componentes de acordo com o tipo de pessoa
  ConfiguraTipoPessoa;

  Result := True;
end;

function TControleCadastroCliente.Editar(Id: Integer): Boolean;
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

function TControleCadastroCliente.Novo(): Boolean;
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

    Result := True;
  end;
end;

function TControleCadastroCliente.Salvar: Boolean;
Var
  PessoaId, EnderecoGEId, EnderecoCOId, EnderecoCBId, Endereco, DadosAdicionaisId: Integer;
  Erro, Tipo: String;
begin
  inherited;

  Erro   := '';
  Result := False;

  if CdsCadastro.State in [dsInsert, dsEdit] then
  begin
    // Verifica o CNPJ
    if Trim(ControleFuncoes.RemoveMascara(DBEdtCpfCnpj.Text)) = '' then
    begin
      if Copy(DBComboTipo.Text, 1, 1) = 'F' then
        ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar o CPF.')
      else
        ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar o CNPJ.');

      if not DBEdtCpfCnpj.ReadOnly then
        DBEdtCpfCnpj.SetFocus;
      Exit;
    end;

    // Valida CNPJ/CPF
    if Copy(DBComboTipo.Text, 1, 1) = 'F' then
    begin
      if ControleFuncoes.ValidaCPF(ControleFuncoes.RemoveMascara(Trim(DBEdtCpfCnpj.Text))) = False then
      begin
        ControleMainModule.MensageiroSweetAlerta('Atenção', 'CPF inválido');
        Exit;
      end;
    end
    else if Copy(DBComboTipo.Text, 1, 1) = 'J' then
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
      if Copy(DBComboTipo.Text, 1, 1) = 'F' then
        ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar o nome.')
      else
        ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar a razão social.');

      DBEdtNome.SetFocus;
      Exit;
    end;

    // Valida nome fantasia
    if DbEditFantasia.Text = '' then
    begin
      ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário o nome fantasia, caso não tenha, repetir o nome da razão social.');
      DbEditFantasia.SetFocus;
      Exit;
    end;

    //Definido para que possa cadastra clientes com somente cpf/cnpj e nome utilizado no cheque.
    if IgnoraCampos <> 'S' then
    begin
      // Valida email
      if DBEditEmailGeral.Text = '' then
      begin
        ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar um email.');
        DBEditEmailGeral.SetFocus;
        Exit;
      end;

      // Valida email
      if DBEditEmailGeral.Text <> '' then
      begin
        if ControleFuncoes.validarDocumentoACBr(DBEditEmailGeral.Text,
                                                docEmail)  = False then
        begin
          ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar um email correto.');

          DBEditEmailGeral.SetFocus;
          Exit;
        end;
      end;

      // Valida celular
      if DBEditCelular.Text = '' then
      begin
        ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar um celular.');
        DBEditCelular.SetFocus;
        Exit;
      end
      else
      begin
        if ControleFuncoes.ValidCelular(DBEditCelular.Text)= False then
        begin
          ControleMainModule.MensageiroSweetAlerta('Atenção',
                                              'É necessário informar um celular válido' +
                                              ' no cadastro do associado' +
                                              ' Informar um celular');

          DBEditCelular.SetFocus;
          Exit;
        end;
      end;

      // Confirma os dados
      CdsCadastro.Post;
    end;
  end;

  // Pega os ids do registro
  CadastroId         := CdsCadastro.FieldByName('id').AsInteger;
  PessoaId           := CdsCadastro.FieldByName('pessoa_id').AsInteger;
  EnderecoGEId       := CdsCadastro.FieldByName('geral_endereco_id').AsInteger;
  EnderecoCOId       := CdsCadastro.FieldByName('comercial_endereco_id').AsInteger;
  EnderecoCBId       := CdsCadastro.FieldByName('cobranca_endereco_id').AsInteger;
  DadosAdicionaisId  := CdsCadastro.FieldByName('dados_adicionais_id').AsInteger;

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
    QryAx1.Parameters.ParamByName('cpf_cnpj').Value           := Trim(ControleFuncoes.RemoveMascara(CdsCadastro.FieldByName('cpf_cnpj').AsString));
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
      begin
        ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));
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
          Erro := ControleFuncoes.RetiraAspaSimples(E.Message);
          ControleMainModule.MensageiroSweetAlerta('Atenção', Erro);
          Break;
        end;
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
      QryAx1.SQL.Add('INSERT INTO cliente (');
      QryAx1.SQL.Add('       id,');
      QryAx1.SQL.Add('       ativo,');
      QryAx1.SQL.Add('       foto_caminho,');
      QryAx1.SQL.Add('       assinatura_caminho,');
      QryAx1.SQL.Add('       observacao,');
      QryAx1.SQL.Add('       limite_credito)');
      QryAx1.SQL.Add('VALUES (');
      QryAx1.SQL.Add('       :id,');
      QryAx1.SQL.Add('       :ativo,');
      QryAx1.SQL.Add('       :foto_caminho,');
      QryAx1.SQL.Add('       :assinatura_caminho,');
      QryAx1.SQL.Add('       :observacao,');
      QryAx1.SQL.Add('       :limite_credito)');
    end
    else
    begin
      // Update
      QryAx1.SQL.Add('UPDATE cliente');
      QryAx1.SQL.Add('   SET ativo                = :ativo,');
      QryAx1.SQL.Add('       observacao           = :observacao,');
      QryAx1.SQL.Add('       foto_caminho         = :foto_caminho,');
      QryAx1.SQL.Add('       assinatura_caminho   = :assinatura_caminho,');
      QryAx1.SQL.Add('       limite_credito       = :limite_credito');
      QryAx1.SQL.Add(' WHERE id                   = :id');
    end;

    QryAx1.Parameters.ParamByName('id').Value                 := CadastroId;
    QryAx1.Parameters.ParamByName('ativo').Value              := Copy(CdsCadastro.FieldByName('ativo').AsString, 1, 1);
    QryAx1.Parameters.ParamByName('observacao').Value         := CdsCadastro.FieldByName('observacao').AsString;
    QryAx1.Parameters.ParamByName('foto_caminho').Value       := URL_LOGO;
    QryAx1.Parameters.ParamByName('assinatura_caminho').Value := URL_ASSINATURA;
    QryAx1.Parameters.ParamByName('limite_credito').Value     := RoundTo(EditNumberLimiteCredito.Value,-2);

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


  // Passo 4 - Salva os dados adicionais do cliente
  if Erro = '' then
  with ControleMainModule do
  begin
    QryAx1.Parameters.Clear;
    QryAx1.SQL.Clear;

    if DadosAdicionaisId = 0 then
    begin
      //gera novo codigo
      DadosAdicionaisId:= GeraId('cliente_dados_adicionais');

      // Insert
      QryAx1.SQL.Add('INSERT INTO cliente_dados_adicionais (');
      QryAx1.SQL.Add('       id,');
      QryAx1.SQL.Add('       cliente_id,');
      QryAx1.SQL.Add('       nome_mae,');
      QryAx1.SQL.Add('       nome_pai,');
      QryAx1.SQL.Add('       nome_outras_pessoas,');
      QryAx1.SQL.Add('       celular_mae,');
      QryAx1.SQL.Add('       celular_pai,');
      QryAx1.SQL.Add('       celular_outras_pessoas)');
      QryAx1.SQL.Add('VALUES (');
      QryAx1.SQL.Add('       :id,');
      QryAx1.SQL.Add('       :cliente_id,');
      QryAx1.SQL.Add('       :nome_mae,');
      QryAx1.SQL.Add('       :nome_pai,');
      QryAx1.SQL.Add('       :nome_outras_pessoas,');
      QryAx1.SQL.Add('       :celular_mae,');
      QryAx1.SQL.Add('       :celular_pai,');
      QryAx1.SQL.Add('       :celular_outras_pessoas)');
    end
    else
    begin
      // Update
      QryAx1.SQL.Add('UPDATE cliente_dados_adicionais');
      QryAx1.SQL.Add('   SET cliente_id              = :cliente_id,');
      QryAx1.SQL.Add('       nome_mae                = :nome_mae,');
      QryAx1.SQL.Add('       nome_pai                = :nome_pai,');
      QryAx1.SQL.Add('       nome_outras_pessoas     = :nome_outras_pessoas,');
      QryAx1.SQL.Add('       celular_mae             = :celular_mae,');
      QryAx1.SQL.Add('       celular_pai             = :celular_pai,');
      QryAx1.SQL.Add('       celular_outras_pessoas  = :celular_outras_pessoas');
      QryAx1.SQL.Add(' WHERE id                      = :id');
    end;

    QryAx1.Parameters.ParamByName('id').Value                      := DadosAdicionaisId;
    QryAx1.Parameters.ParamByName('cliente_id').Value              := PessoaId;
    QryAx1.Parameters.ParamByName('nome_mae').Value                := UniDBEditMae.Text;
    QryAx1.Parameters.ParamByName('nome_pai').Value                := UniDBEditPai.Text;
    QryAx1.Parameters.ParamByName('nome_outras_pessoas').Value     := UniDBEditOutrasPessoas.Text;
    QryAx1.Parameters.ParamByName('celular_mae').Value             := ControleFuncoes.RemoveMascara(UniDBEditCelularMae.Text);
    QryAx1.Parameters.ParamByName('celular_pai').Value             := ControleFuncoes.RemoveMascara(UniDBEditCelularPai.Text);
    QryAx1.Parameters.ParamByName('celular_outras_pessoas').Value  := ControleFuncoes.RemoveMascara(UniDBEditCelularOutrasPessoas.Text);

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

procedure TControleCadastroCliente.UniFileUpload1Completed(Sender: TObject;
  AStream: TFileStream);
var
  DestName : string;
  DestFolder : string;
begin
  Try
    if not DirectoryExists(ControleServerModule.StartPath+'UploadFolder\') then
      CreateDir(ControleServerModule.StartPath+'UploadFolder\');

    if not DirectoryExists(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\') then
      CreateDir(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\');

    if not DirectoryExists(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\'+ 'Cliente\' ) then
      CreateDir(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\'+ 'Cliente\' );

    if not DirectoryExists(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\'+ 'Cliente\'+ CdsCadastroID.AsString) then
      CreateDir(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\'+ 'Cliente\'+ CdsCadastroID.AsString);

    DestFolder  := ControleServerModule.StartPath + 'UploadFolder\' + ControleMainModule.FSchema + '\' + 'Cliente\' + CdsCadastroID.AsString +'\';
    DestName    := DestFolder + ExtractFileName(UniFileUpload1.FileName);
    CopyFile(PChar(AStream.FileName), PChar(DestName), False);
    ControleFuncoes.CarregaImagemGeral(DestName, ImageFoto);
    URL_LOGO := DestName;
  Except
    on e:exception do
    begin
      ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(e.Message));
    end;
  End;

  Salvar;
end;

procedure TControleCadastroCliente.UniFileUpload2Completed(Sender: TObject;
  AStream: TFileStream);
var
  DestName : string;
  DestFolder : string;
begin
  Try
    if not DirectoryExists(ControleServerModule.StartPath+'UploadFolder\') then
      CreateDir(ControleServerModule.StartPath+'UploadFolder\');

    if not DirectoryExists(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\') then
      CreateDir(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\');

    if not DirectoryExists(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\'+ 'Cliente\' ) then
      CreateDir(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\'+ 'Cliente\' );

    if not DirectoryExists(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\'+ 'Cliente\'+ CdsCadastroID.AsString) then
      CreateDir(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\'+ 'Cliente\'+ CdsCadastroID.AsString);

    DestFolder  := ControleServerModule.StartPath + 'UploadFolder\' + ControleMainModule.FSchema + '\' + 'Cliente\' + CdsCadastroID.AsString +'\';
    DestName    := DestFolder + ExtractFileName(UniFileUpload2.FileName);
    CopyFile(PChar(AStream.FileName), PChar(DestName), False);
    ControleFuncoes.CarregaImagemGeral(DestName, ImageAssinatura);
    URL_ASSINATURA := DestName;
  Except
    on e:exception do
    begin
      ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(e.Message));
    end;
  End;

  Salvar;
end;

procedure TControleCadastroCliente.UniFormShow(Sender: TObject);
begin
  inherited;
  // Criando a pasta no servidor, caso nao exista
  if not DirectoryExists(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\' +
                        'Cliente\') then
  begin
    CreateDir(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\' +
             'Cliente\');
  end;

  // Criando a pasta no servidor, caso nao exista
  if not DirectoryExists(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\' +
                        'Cliente\' + CdsCadastroID.AsString) then
  begin
    CreateDir(ControleServerModule.StartPath+'UploadFolder\'+ ControleMainModule.FSchema + '\' +
             'Cliente\' + CdsCadastroID.AsString);
  end;

  UniPageDadosPrincipais.Pages[1].Visible := False;
  UniPageDadosPrincipais.Pages[2].Visible := False;
  UniPageDadosPrincipais.Pages[4].Visible := False;
  UniPagePrincipal.ActivePageIndex := 0;
  if ImageFoto.Picture = nil then
    BotaoApagarImagem.Visible := False;

  if ImageAssinatura.Picture = nil then
    BotaoApagarAssinatura.Visible := False;

  CdsEnviaMensagem.Open;

  AlimentaConfiguracoes(CdsEnviaMensagemURL_API.AsString,
                        CdsEnviaMensagemTOKEN_API.AsString,
                        '',
                        '');

  // Convertendo Base a imagem para Base64
  if CdsEnviaMensagemFOTO_CAMINHO.AsString <> '' then
  begin
    ArquivoBase64 := ControleMainModule.ConverteToBase64(CdsEnviaMensagemFOTO_CAMINHO.AsString,
                                                        'BannerI9ST.txt');
  end;
end;

procedure TControleCadastroCliente.UniPagePrincipalChange(Sender: TObject);
begin
  inherited;
  if UniPagePrincipal.ActivePageIndex = 1 then
  begin
    PreencheLimiteCredito;
  end;
end;

procedure TControleCadastroCliente.PreencheLimiteCredito;
begin
  CdsTitulos.Close;
  QryTitulos.Parameters.ParamByName('id').Value := CdsCadastroID.AsInteger;
  CdsTitulos.Open;

  LabelTotalAtraso.Caption := 'R$ '+ FloatToStr(StrToFloatDef(CdsTitulosTOTAL_EM_ATRASO.AsString,0));
  LabelTotalAberto.Caption := 'R$ '+ FloatToStr(StrToFloatDef(CdsTitulosTOTAL_EM_ABERTO.AsString,0));
end;


procedure TControleCadastroCliente.UniTimerEnviaWhatsappTesteTimer(
  Sender: TObject);
begin
  inherited;
  TempoLimite := TempoLimite + 1;

  if TempoLimite < 120 then
  begin
    ClientAguarde.UniProgressBar1.Position := TempoLimite;
    if ControleServerModule.RecebeCallBack = snConcorda then
    begin
      UniTimerEnviaWhatsappTeste.Enabled := False;
      ControleServerModule.RecebeCallBack := snNulo;
      TempoLimite := 0;
      ClientAguarde.Close;
      AtualizaStatusWhatsapp(CdsCadastroID.AsInteger, 'S');
      ControleMainModule.MensageiroSweetAlerta('Atenção', 'O cliente aceitou o envio', atSuccess)
    end
    else if ControleServerModule.RecebeCallBack = snNaoConcorda then
    begin
      UniTimerEnviaWhatsappTeste.Enabled := False;
      ControleServerModule.RecebeCallBack := snNulo;
      TempoLimite := 0;
      ClientAguarde.Close;
      AtualizaStatusWhatsapp(CdsCadastroID.AsInteger, 'N');
      ControleMainModule.MensageiroSweetAlerta('Atenção', 'O cliente NÃO aceitou o envio')
    end;
  end
  else
  begin
    UniTimerEnviaWhatsappTeste.Enabled := False;
    ControleServerModule.RecebeCallBack := snExpirou;
    TempoLimite := 0;
   // EnviaMensagemCancelaVerificaWhatsAppAtivo(ControleFuncoes.RemoveMascara(CdsCadastroGERAL_CELULAR.AsString));
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Tempo de resposta excedido');
    BotaoEnviaMensagem.Enabled := True;
    ClientAguarde.Close;
  end;
end;

procedure TControleCadastroCliente.BotaoCEPComercialClick(Sender: TObject);
begin
  inherited;
  VerificaCEP(BotaoCEPComercial,
              DBEditCepComercial,
              DBEditNum);
end;

procedure TControleCadastroCliente.BotaoApagarAssinaturaClick(Sender: TObject);
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
    QryAx1.SQL.Add('UPDATE cliente');
    QryAx1.SQL.Add('   SET assinatura_caminho  = null');
    QryAx1.SQL.Add(' WHERE id            = :id');
    QryAx1.Parameters.ParamByName('id').Value    := CdsCadastroID.AsInteger;

    try
      // Tenta salvar os dados
      QryAx1.ExecSQL;
      ADOConnection.CommitTrans;

      DeleteFile(URL_ASSINATURA);
      ControleFuncoes.CarregaImagemGeral('', ImageAssinatura);
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

procedure TControleCadastroCliente.BotaoApagarImagemClick(Sender: TObject);
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
    QryAx1.SQL.Add('UPDATE cliente');
    QryAx1.SQL.Add('   SET foto_caminho  = null');
    QryAx1.SQL.Add(' WHERE id            = :id');
    QryAx1.Parameters.ParamByName('id').Value    := CdsCadastroID.AsInteger;

    try
      // Tenta salvar os dados
      QryAx1.ExecSQL;
      ADOConnection.CommitTrans;

      DeleteFile(URL_LOGO);
      ControleFuncoes.CarregaImagemGeral('', ImageFoto);
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

procedure TControleCadastroCliente.BotaoCEPCobrancaClick(Sender: TObject);
begin
  inherited;
  VerificaCEP(BotaoCEPCobranca,
              DBEditCepCobranca,
              DBEditNum);
end;

procedure TControleCadastroCliente.BotaoCEPGeralClick(Sender: TObject);
var
  teste : Integer;
  CidadeId: Integer;
  Tipo, CodigoIbge, Cidade, Uf_: String;
  Erro, Cep, Retorno: String;
begin
  inherited;

  // Não executa se o botão estiver desabilitado
  if not TUniSpeedButton(Sender).Enabled then
    Exit;

  // Identifica o tipo de endereço que está sendo editado
  if Pos('COMERCIAL', UpperCase(TUniSpeedButton(Sender).Name)) > 0 then
  begin
    Tipo := 'comercial';
    Cep  := ControleFuncoes.RemoveMascara(Trim(DBEditCepComercial.Text));
  end
  else if Pos('COBRANCA', UpperCase(TUniSpeedButton(Sender).Name)) > 0 then
  begin
    Tipo := 'cobranca';
    Cep  := ControleFuncoes.RemoveMascara(Trim(DBEditCepCobranca.Text));
  end
  else
  begin
    Tipo := 'geral';
    Cep  := ControleFuncoes.RemoveMascara(Trim(DBEditCepGeral.Text));
  end;

  // Verifica se o cep foi informado
  if Cep = '' then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Informe o CEP que deseja consultar.');
    Exit;
  end;

  // Verifica se o cep é válido
  if Length(Cep) <> 8 then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Informe o CEP com 8 digitos.');
    Exit;
  end;

  try
     teste := ACBrCEP1.BuscarPorCEP(DBEditCepGeral.Text);

     if ACBrCEP1.Enderecos.Count < 1 then
     begin
       ControleMainModule.MensageiroSweetAlerta('Atenção', 'Nenhum Endereço encontrado');
       UniDBEdit3.SetFocus;
     end
     else
     begin
       with ACBrCEP1.Enderecos[0] do
       begin
         // Coloca o dataset em modo de edição se ainda não estiver
         CdsCadastro.Edit;

         // Redefine o logradouro
         if Logradouro <> '' then
           CdsCadastro[Tipo + '_logradouro'] := Trim(Logradouro)
         else
           CdsCadastro[Tipo + '_logradouro'] := '';

         // Redefine o complemento
         if Complemento <> '' then
           CdsCadastro[Tipo + '_complemento'] := Trim(Complemento)
         else
           CdsCadastro[Tipo + '_complemento'] := '';

         // Redefine o bairro
         if Bairro <> '' then
           CdsCadastro[Tipo + '_bairro'] := Trim(Bairro)
         else
           CdsCadastro[Tipo + '_bairro'] := '';

         // Pega o código ibge
         if IBGE_Municipio <> '' then
           CodigoIbge := Trim(IBGE_Municipio);

         // Pega a cidade
         if Municipio <> '' then
           Cidade := Trim(Municipio);

         // Pega a uf
         if UF <> '' then
           Uf_ := Trim(UF);

         with ControleMainModule do
         begin
            CidadeId := 0;

            // Tenta localizar a cidade pelo código ibge
            CdsAx1.Close;
            QryAx1.Parameters.Clear;
            QryAx1.SQL.Clear;
            QryAx1.SQL.Text :=
                'SELECT cid.id,'
              + '       cid.nome,'
              + '       est.uf'
              + '  FROM fonte.cidade cid'
              + '  LEFT OUTER JOIN fonte.estado est'
              + '    ON est.id = cid.estado_id'
              + ' WHERE cid.codigo_ibge = :codigo_ibge';
            QryAx1.Parameters.ParamByName('codigo_ibge').Value := CodigoIbge;
            CdsAx1.Open;

            if (CodigoIbge <> '') and (CdsAx1.FieldByName('id').AsInteger <> 0) then
            begin
              CidadeId := CdsAx1.FieldByName('id').AsInteger;
              Cidade   := CdsAx1.FieldByName('nome').AsString;
              Uf       := CdsAx1.FieldByName('uf').AsString;
            end
            else
            begin
              // Tenta localizar a cidade pelo nome e uf
              CdsAx1.Close;
              QryAx1.Parameters.Clear;
              QryAx1.SQL.Clear;
              QryAx1.SQL.Text :=
                  'SELECT cid.id,'
                + '       cid.nome,'
                + '       est.uf'
                + '  FROM cidade cid'
                + ' INNER JOIN fonte.estado est'
                + '    ON est.id = cid.estado_id'
                + ' WHERE UPPER(TRIM(cid.nome)) = UPPER(:nome)'
                + '   AND UPPER(TRIM(est.uf))   = UPPER(:uf)';
              QryAx1.Parameters.ParamByName('nome').Value := Cidade;
              QryAx1.Parameters.ParamByName('uf').Value   := Uf;
              CdsAx1.Open;

              if (Cidade <> '') and (CdsAx1.FieldByName('id').AsInteger <> 0) then
              begin
                CidadeId := CdsAx1.FieldByName('id').AsInteger;
                Cidade   := CdsAx1.FieldByName('nome').AsString;
                Uf       := CdsAx1.FieldByName('uf').AsString;
              end;
            end;

            // Cadastra a cidade retornada pelo VIACEP se ainda não estiver cadastrada.
            if (CidadeId = 0) and (Cidade <> '') and (Uf <> '') then
            begin
              // Inicia a transação
              ADOConnection.BeginTrans;

              CidadeId := GeraId('cidade');

              // Insere a nova cidade
              CdsAx1.Close;
              QryAx1.Parameters.Clear;
              QryAx1.SQL.Clear;
              QryAx1.SQL.Text :=
                  'INSERT INTO fonte.cidade ('
                + '       id,'
                + '       nome,'
                + '       estado_id,'
                + '       codigo_ibge)'
                + 'VALUES ('
                + '       :id,'
                + '       :nome,'
                + '       (SELECT id'
                + '          FROM fonte.estado'
                + '         WHERE UPPER(uf) = UPPER(:uf)'
                + '           AND ROWNUM = 1),'
                + '       :codigo_ibge)';
              QryAx1.Parameters.ParamByName('id').Value          := CidadeId;
              QryAx1.Parameters.ParamByName('nome').Value        := Cidade;
              QryAx1.Parameters.ParamByName('uf').Value          := Uf;
              QryAx1.Parameters.ParamByName('codigo_ibge').Value := CodigoIbge;

              try
                // Tenta salvar os dados
                QryAx1.ExecSQL;
                // Confirma a transação
                ADOConnection.CommitTrans;
              except
                on E: Exception do
                begin
                  Erro := ControleFuncoes.RetiraAspaSimples(E.Message);
                  ControleMainModule.MensageiroSweetAlerta('Atenção', Erro);
                  // Descarta a transação
                  ADOConnection.RollbackTrans;
                end;
              end;
            end;

            if (Erro = '') and (CidadeId > 0) then
            begin
              // Redefine a cidade
              CdsCadastro[Tipo + '_cidade_id'] := CidadeId;
              CdsCadastro[Tipo + '_cidade']    := Cidade + ' / ' + Uf;
            end;

            DBEditNum.SetFocus;
         end;
       end;
     end ;
  except
     On E : Exception do
     begin
       ControleMainModule.MensageiroSweetAlerta('Atenção', 'O servidor de busca CEPs encontra-se instável, tente novamente mais tarde.');//ControleFuncoes.RetiraAspaSimples(E.Message));
     end ;
  end ;
end;

procedure TControleCadastroCliente.BotaoEnviaMensagemClick(Sender: TObject);
var
  nCelular, ddd, celularsemddd : string;
begin
  inherited;

  BotaoEnviaMensagem.Enabled := False;

  // Testando se API esta online
{  Try
    EnviaMensagemVerificaAPIAtiva();
  Except
    on e:Exception do
    begin
      if AnsiContainsStr(e.Message, 'REST request failed') then
      begin
        ControleMainModule.MensageiroSweetAlerta('Atenção', 'O sistema de envio de mensagens não está ativo ou não está configurado, verifique as configurações e tente novamente!');
        BotaoEnviaMensagem.Enabled := True;
        Exit;
      end;
    end;
  End;  }

  // Enviando mensagem para que o cliente aceite o envio de promoções/cobrança no whatsapp
  Try
    // Removendo a mascara do celular
    nCelular := ControleFuncoes.RemoveMascara(CdsCadastroGERAL_CELULAR.AsString);

    // Removendo o 9 digito caso exista
    if Length(nCelular) =  11 then
    begin
      ddd           := copy(nCelular,1,2);
      celularsemddd := copy(nCelular,4,8);
    end;

{    if ControleFuncoes.ValidCelular(celularsemddd) = False then
    begin
      ControleMainModule.MensageiroSweetAlerta('Atenção', 'Celular inválido!', atError);
      Exit;
    end;}
    UniTimerEnviaWhatsappTeste.Enabled := True;

    recebeRetorno := TrecebeRetorno.Create;
    recebeRetorno.nRetorno  :=  EnviaMensagem(ddd + celularsemddd,
                                              FuncoesClient.RetiraEnterFinalFrase(SubstituiTextoMensagem(CdsEnviaMensagemTEXTO_BOAS_VINDAS.AsString)),
                                              CdsEnviaMensagemTOKEN_API.AsString,
                                              ArquivoBase64,
                                              '1',
                                              CdsEnviaMensagemURL_RETORNO.AsString,
                                              'S');
  Except
    on e:Exception do
    begin
      if AnsiContainsStr(e.Message, 'REST request failed') then
      begin
        ControleMainModule.MensageiroSweetAlerta('Atenção', 'O servidor da API está desligado ou o host está inválido!', atError);
        BotaoEnviaMensagem.Enabled := True;
        Exit;
      end;
    end;
  End;

 { if BotaoSalvar.Enabled = True then
    BotaoSalvar.Click; }

  BotaoEnviaMensagem.Enabled := True;
end;

procedure TControleCadastroCliente.ButtonImportaAssinaturaClick(
  Sender: TObject);
begin
  Try
    with UniFileUpload2 do
    begin
      MaxAllowedSize := 5000000;
      Execute;
    end;
    BotaoApagarAssinatura.Visible := True;
  Except
    on e:Exception do
    begin
      ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));
    end;
  End;
end;

procedure TControleCadastroCliente.ButtonImportaImagemClick(Sender: TObject);
begin
  Try
    with UniFileUpload1 do
    begin
      MaxAllowedSize := 5000000;
      Execute;
    end;
    BotaoApagarImagem.Visible := True;
  Except
    on e:Exception do
    begin
      ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));
    end;
  End;
end;

procedure TControleCadastroCliente.ButtonPesquisaCidadeGeralClick(Sender: TObject);
var
  Tipo: String;
begin
  inherited;

  // Abre o formulário em modal e aguarda
  ControleConsultaModalCidade.ShowModal(procedure(Sender: TComponent; Result: Integer)
  begin
{    if Result = 1 then
    begin}
      // Identifica o tipo de endereço que está sendo editado
      if Pos('COMERCIAL', UpperCase(TUniSpeedButton(Sender).Name)) > 0 then
        Tipo := 'comercial'
      else if Pos('COBRANCA', UpperCase(TUniSpeedButton(Sender).Name)) > 0 then
        Tipo := 'cobranca'
      else
        Tipo := 'geral';

      CdsCadastro.Edit;
      CdsCadastro[Tipo + '_cidade_id'] := ControleConsultaModalCidade.CdsConsulta.FieldByName('id').AsInteger;
      CdsCadastro[Tipo + '_cidade']    := ControleConsultaModalCidade.CdsConsulta.FieldByName('nome').AsString +
        ' / ' + ControleConsultaModalCidade.CdsConsulta.FieldByName('uf').AsString;
//    end;
  end);
end;

procedure TControleCadastroCliente.DbComboTipoChange(Sender: TObject);
begin
  inherited;
  // Configura os componentes de acordo com o tipo de pessoa
  ConfiguraTipoPessoa;
  DBEdtCpfCnpj.Clear;
end;

procedure TControleCadastroCliente.DBEditCepGeralExit(Sender: TObject);
begin
  inherited;
  BotaoCEPGeral.Click;
end;

procedure TControleCadastroCliente.DBEdtCpfCnpjExit(Sender: TObject);
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

function TControleCadastroCliente.Descartar: Boolean;
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

procedure TControleCadastroCliente.ConfiguraTipoPessoa;
begin
  if Copy(DBComboTipo.Text, 1, 1) = 'F' then
  begin
    // Pessoa Física
    LabelNomeRazao.Caption       := 'Nome';
    LabelCpfCnpj.Caption         := 'CPF';
    LabelPopularFantasia.Caption := 'Nome papular';
    LabelRgIe.Caption            := 'RG';

    LabelNascimento.Font.Color   := clBlack;
    LabelSexo.Font.Color         := clBlack;
    DbComboCRT.Font.Color        := clSilver;
    LabelDataExped.Font.Color    := clBlack;
    LabelOrgaoExped.Font.Color   := clBlack;

    DBEdtNascimento.Enabled      := True;
    DBComboSexo.Enabled          := True;
    DbComboCRT.Enabled           := False;
    DBEdtDataExped.Enabled       := True;
    DBEdtOrgaoExped.Enabled      := True;
    DbComboCRT.Visible           := False;
    LabelCRT.Visible             := False;

    if CdsCadastro.State in [dsInsert, dsEdit] then
      CdsCadastro['tipo'] := 'FÍSICA';

   // UniSession.JSCode('$("#' + DBEdtCpfCnpj.JSName + '_id-inputEl").inputmask("999.999.999-99");');
  end
  else
  begin
    // Pessoa Jurídica
    LabelNomeRazao.Caption       := 'Razão social';
    LabelCpfCnpj.Caption         := 'CNPJ';
    LabelPopularFantasia.Caption := 'Nome fantasia';
    LabelRgIe.Caption            := 'Inscrição estadual';

    LabelNascimento.Font.Color   := clSilver;
    LabelSexo.Font.Color         := clSilver;
    DbComboCRT.Font.Color        := clBlack;
    LabelDataExped.Font.Color    := clSilver;
    LabelOrgaoExped.Font.Color   := clSilver;

    DBEdtNascimento.Enabled      := False;
    DBComboSexo.Enabled          := False;
    DbComboCRT.Enabled           := True;
    DBEdtDataExped.Enabled       := False;
    DBEdtOrgaoExped.Enabled      := False;
    DbComboCRT.Visible           := True;
    LabelCRT.Visible             := True;


    if CdsCadastro.State in [dsInsert, dsEdit] then
      CdsCadastro['tipo'] := 'JURÍDICA';

   // UniSession.JSCode('$("#' + DBEdtCpfCnpj.JSName + '_id-inputEl").inputmask("99.999.999/9999-99");');
  end;
end;

function TControleCadastroCliente.EnviaMensagem(Celular: string;
                                                Texto: string;
                                                TokenApi: string;
                                                ArquivoBase64: String = '';
                                                NumeroClient: String = '1';
                                                UrlRetorno: string = '';
                                                TestaWhatsapp: string = 'N'): TRetornos;
begin
  try
    Base64 := TBase64.create;
    Base64.ArquivoBase64 := 'json_base64';

    // código temporario, o correto é passar pelo body, passando na url apenas a url com a autenticação
    With EnviaRecebeDadosJson do
    begin
      FuncoesClient.Add_StrListPar(StrListPar,
                             'celular',
                              Celular);

      FuncoesClient.Add_StrListPar(StrListPar,
                             'texto',
                              Texto);

      FuncoesClient.Add_StrListPar(StrListPar,
                             'tokenapi',
                              TokenApi);

      FuncoesClient.Add_StrListPar(StrListPar,
                             'numclient',
                              NumeroClient);

      FuncoesClient.Add_StrListPar(StrListPar,
                             'urlretorno',
                              UrlRetorno);

      FuncoesClient.Add_StrListPar(StrListPar,
                             'testawhatsapp',
                              TestaWhatsapp);
    end;

    ListaOrdenada := '';
    ListaOrdenada := '/whatsapp/mensagem?' +
                     FuncoesClient.RetornaStringList(EnviaRecebeDadosJson.StrListPar, 'celular') +
                     '&' +
                     FuncoesClient.RetornaStringList(EnviaRecebeDadosJson.StrListPar, 'texto') +
                     '&' +
                     FuncoesClient.RetornaStringList(EnviaRecebeDadosJson.StrListPar, 'tokenapi') +
                     '&' +
                     FuncoesClient.RetornaStringList(EnviaRecebeDadosJson.StrListPar, 'numclient') +
                     '&' +
                     FuncoesClient.RetornaStringList(EnviaRecebeDadosJson.StrListPar, 'urlretorno') +
                     '&' +
                     FuncoesClient.RetornaStringList(EnviaRecebeDadosJson.StrListPar, 'testawhatsapp');

  finally
    Result := EnviaRecebeDadosJson.EnviaRequisicaoAPI(FuncoesClient.RetornaJson(Base64,
                                                                                '{"arquivoBase64":"',
                                                                                '',
                                                                                '"}',
                                                                                ''),
                                                      FuncoesClient.ConverteStringToStrinList(ListaOrdenada).Values['strlist'],
                                                      TRESTRequestMethod.rmPOST,
                                                      ArquivoBase64);
  end;
end;


Function TControleCadastroCliente.SubstituiTextoMensagem(Texto: string):String;
begin
  Result  := StringReplace(Texto,  '<NOME_CLIENTE>', CdsCadastroNOME_FANTASIA.AsString, [rfReplaceAll]);
  Result  := StringReplace(Result, '<NOME_LOJA>', ControleMainModule.FNomeFantasia, [rfReplaceAll]);
end;

procedure TControleCadastroCliente.AlimentaConfiguracoes(url,
                                                      tokenAPI,
                                                      cryptKey,
                                                      uuid_safe: String); stdcall;

begin
  EnviaRecebeDadosJson := TEnviaRecebeDadosJson.Create;
  With EnviaRecebeDadosJson do
  begin
    if not Assigned(StrListPar) then
      StrListPar := TStringList.Create;

    // Adicionando os parametros iniciais
    FuncoesClient.Add_StrListPar(StrListPar,
                           'url',
                            url);
  end;
end;

procedure TrecebeRetorno.SetnRetorno(const Value: TRetornos);
begin
  Try
    // FnRetorno := Value;
    // Alimentando os componentes visuais
    With ControleCadastroCliente do
    begin
      if Value.rClientDataSetCabecalho <> nil then
      begin
        CDSCloneTotais.CloneCursor(Value.rClientDataSetCabecalho, false, false);
        CDSCloneTotais.Open;

        DBGridDadosTotais.DataSource    := DscCloneTotais;

        if Value.rClientDataSetItens <> nil then
        begin
          CDSCloneItens.CloneCursor(Value.rClientDataSetItens, false, false);
          CDSCloneItens.Open;

          DBGridDadosItens.DataSource    := DscCloneItens;
        end;
      end
      else
      begin
        DBGridDadosTotais.DataSource    := Value.rDatasource;
        DBGridDadosItens.DataSource     := nil;
        // Clonando o resultado para um clientdataset
        CDSClone.CloneCursor(Value.rClientDataSet, false, false);
        CDSClone.Open;
      end;

      if Value.rClientDataSetItens2 <> nil then
      begin
        CDSCloneItens2.CloneCursor(Value.rClientDataSetItens2, false, false);
        CDSCloneItens2.Open;
      end;

      MemoEnvioUrl.Text      := Value.rUrlEnvio;
      MemoEnvioJson.Text     := Value.rJsonEnvio;
      MemoRetorno.Text       := Value.rJsonRetorno;
    end;
  Finally
    // metodos para deixar free aqui
  End;
end;

function TControleCadastroCliente.EnviaMensagemVerificaAPIAtiva(): TRetornos;
begin
  try
    // código temporario, o correto é passar pelo body, passando na url apenas a url com a autenticação
    With EnviaRecebeDadosJson do
    begin
      FuncoesClient.Add_StrListPar(StrListPar,
                             'testaapi',
                              'True');
    end;

    ListaOrdenada := '';
    ListaOrdenada := '/whatsapp/mensagem?' +
                     FuncoesClient.RetornaStringList(EnviaRecebeDadosJson.StrListPar, 'testaapi');

  finally
    Result := EnviaRecebeDadosJson.EnviaRequisicaoAPI('',
                                                      FuncoesClient.ConverteStringToStrinList(ListaOrdenada).Values['strlist'],
                                                      TRESTRequestMethod.rmPOST,
                                                      '');
  end;
end;

function TControleCadastroCliente.EnviaMensagemCancelaVerificaWhatsAppAtivo(
      Celular: string): TRetornos;
begin
  try
    // código temporario, o correto é passar pelo body, passando na url apenas a url com a autenticação
    With EnviaRecebeDadosJson do
    begin
      FuncoesClient.Add_StrListPar(StrListPar,
                              'cancelatestawhatsapp',
                              'True');

      FuncoesClient.Add_StrListPar(StrListPar,
                             'celular',
                              Celular);
    end;

    ListaOrdenada := '';
    ListaOrdenada := '/whatsapp/mensagem?' +
                     FuncoesClient.RetornaStringList(EnviaRecebeDadosJson.StrListPar, 'cancelatestawhatsapp')+
                     '&' +
                     FuncoesClient.RetornaStringList(EnviaRecebeDadosJson.StrListPar, 'celular');

  finally
    Result := EnviaRecebeDadosJson.EnviaRequisicaoAPI(FuncoesClient.RetornaJson(Base64,
                                                                                '{"arquivoBase64":"',
                                                                                '',
                                                                                '"}',
                                                                                ''),
                                                      FuncoesClient.ConverteStringToStrinList(ListaOrdenada).Values['strlist'],
                                                      TRESTRequestMethod.rmPOST,
                                                      ArquivoBase64);
  end;
end;

Procedure TControleCadastroCliente.AtualizaStatusWhatsapp(id: Integer;
                                                         Tipo: String);
begin
  with ControleMainModule do
  begin
    Try
      // Inicia a transação
      ADOConnection.BeginTrans;

      // Update
      QryAx1.SQL.Clear;
      QryAx1.SQL.Add('UPDATE cliente');
      QryAx1.SQL.Add('   SET aceita_envio_mensagem = '''+ Tipo +'''');
      QryAx1.SQL.Add(' WHERE id  = '+ IntToStr(id) +'');
      QryAx1.ExecSQL;

      CdsCadastro.Edit;
      CdsCadastroACEITA_ENVIO_MENSAGEM.AsString := Tipo;
      CdsCadastro.Post;

      ADOConnection.CommitTrans;
    except
      on E: Exception do
      begin
        ADOConnection.RollbackTrans;
        ControleMainModule.MensageiroSweetAlerta('Atenção', e.Message);
      end;
    end;
  end;
end;


end.
