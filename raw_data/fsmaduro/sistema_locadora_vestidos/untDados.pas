unit untDados;

interface

uses
  SysUtils, Classes, IBDatabase, DB, IBCustomDataSet, IBQuery, IniFiles,
  Windows, Messages, Variants, Graphics, Controls, Forms,
  Dialogs, IBUpdateSQL, ExtCtrls, ComObj, FUNCAO, ppComm, ppRelatv, ppDB,
  ppDBPipe, ppPrnabl, ppClass, ppCtrls, ppBands, ppCache, ppProd, ppReport,
  ppVar, IBTable, ppParameter, Registry, backup, Sockets, ppDesignLayer,
  StdCtrls, Gauges, IBScript, ImgList, cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage,
  cxEdit, cxDBData, cxCheckBox, Menus, cxLookAndFeelPainters, 
  cxButtons, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxClasses, cxControls, cxGridCustomView, cxGrid, cxVariants;

type

  TPublicMalaDireta = record
     Iniciar: Boolean;
     EnviarEmail: Boolean;
     EnviarSMS: Boolean;
     Filtro: String;
     Mensagem: String;
  end;

  TcxGridTableControllerAccess = class (TcxGridTableController);

  TMycxGridDBTableView = class (TcxGridDBTableView)
  protected
    function GetViewDataClass: TcxCustomGridViewDataClass; override;
  end;

  TMycxGridViewData = class (TcxGridViewData)
  protected
    function GetFilterRowClass: TcxGridFilterRowClass; override;
  end;

  TMycxGridFilterRow = class (TcxGridFilterRow)
  protected
    procedure SetValue(Index: Integer; const Value: Variant); override;
  end;

  TcxGridDBTableView = class (TMycxGridDBTableView);

  TWordReplaceFlags = set of (wrfReplaceAll, wrfMatchCase, wrfMatchWildcards);
  TTipoConfig = (tcTexto, tcInteiro, tcMemo, tcReal, tcData, tcHora, tcCheck, tcCodigoLookup, tcCor);
  TTipoURL = (tuProduto, tuPerfil);
  TRetValorConfig = record
    vcString : String;
    vcDate: TDate;
    vcTime: TTime;
    vcDateTime: TDateTime;
    vcInteger: Integer;
    vcReal: Real;
    vcBoolean: Boolean;
    vcMemo: TStringList;
    vcCor: Integer;
  end;

type
  TProdutosContrato = record
    CodigoProduto : Integer;
    Valor : Currency;
  end;

type
  TDados = class(TDataModule)
    IBDatabase: TIBDatabase;
    IBTransaction: TIBTransaction;
    Geral: TIBQuery;
    qryLog: TIBQuery;
    udpLog: TIBUpdateSQL;
    dtsLog: TDataSource;
    qryLogCODIGOUSUARIO: TIntegerField;
    qryLogDATA: TDateField;
    qryLogHORA: TTimeField;
    qryLogID: TIntegerField;
    qryRelatorios: TIBQuery;
    qryComunidade: TIBQuery;
    qryRelParcFinanceiro: TIBQuery;
    qryRelParcFinanceiroNOMEALUNO: TIBStringField;
    qryRelParcFinanceiroNOMETURMA: TIBStringField;
    qryRelParcFinanceiroNOMERESPONSAVEL: TIBStringField;
    qryRelParcFinanceiroVENCIMENTO: TDateField;
    qryRelParcFinanceiroVALOR: TIBBCDField;
    qryRelParcFinanceiroVALORPAGO: TIBBCDField;
    qryRelParcFinanceiroCODIGOPARCELARENEGOCIACAO: TIntegerField;
    qryRelParcFinanceiroPARCELA: TIntegerField;
    qryRelParcFinanceiroFINANCEIRO: TIntegerField;
    qryRelParcFinanceiroTIPO: TIntegerField;
    qryRelParcFinanceiroPARCELAORIGINAL: TIntegerField;
    qryRelParcFinanceiroDESCRICAOFPG: TIBStringField;
    qryRelParcFinanceiroDESCRICAOTELA: TStringField;
    qryRelParcFinanceiroDIAS: TIntegerField;
    qryRelParcFinanceiroNUMEROCHEQUE: TIBStringField;
    qryLogTEXTO: TMemoField;
    dtsGeral: TDataSource;
    pipComunidade: TppDBPipeline;
    dtsComunidade: TDataSource;
    qryComunidadeNOMECOMUNIDADE: TIBStringField;
    qryComunidadeNOMEPAROQUIA: TIBStringField;
    qryComunidadeNOMEDIOCESE: TIBStringField;
    qryComunidadeURLLOGO: TMemoField;
    qryComunidadeENDERECO1: TIBStringField;
    qryComunidadeENDERECO2: TIBStringField;
    qryComunidadeTELEFONES: TIBStringField;
    qryComunidadeEMAILSITE: TIBStringField;
    ReportBase: TppReport;
    ppHeaderBand1: TppHeaderBand;
    ppDetailBand1: TppDetailBand;
    ppFooterBand1: TppFooterBand;
    ppImage1: TppImage;
    ppDBText1: TppDBText;
    ppDBText2: TppDBText;
    ppDBText3: TppDBText;
    ppLine1: TppLine;
    ppLine2: TppLine;
    OME: TppLabel;
    ppLine3: TppLine;
    ppDBText4: TppDBText;
    ppDBText5: TppDBText;
    ppLine4: TppLine;
    ppSystemVariable1: TppSystemVariable;
    ppSystemVariable2: TppSystemVariable;
    qryLista: TIBQuery;
    pipLista: TppDBPipeline;
    dtsLista: TDataSource;
    rbiLista: TppReport;
    ppHeaderBand2: TppHeaderBand;
    ppImage2: TppImage;
    ppDBText6: TppDBText;
    ppDBText7: TppDBText;
    ppDBText8: TppDBText;
    ppLine5: TppLine;
    ppLine6: TppLine;
    lblNomeRelatorio: TppLabel;
    ppLine7: TppLine;
    ppDBText9: TppDBText;
    ppDBText10: TppDBText;
    ppDetailBand2: TppDetailBand;
    ppFooterBand2: TppFooterBand;
    ppLine8: TppLine;
    ppSystemVariable3: TppSystemVariable;
    ppSystemVariable4: TppSystemVariable;
    qryRelLog: TIBQuery;
    pipRelLog: TppDBPipeline;
    dtsRelLog: TDataSource;
    rbiLog: TppReport;
    ppHeaderBand3: TppHeaderBand;
    ppLine9: TppLine;
    ppLine10: TppLine;
    ppLabel2: TppLabel;
    ppLine11: TppLine;
    ppDetailBand3: TppDetailBand;
    ppFooterBand3: TppFooterBand;
    ppLine12: TppLine;
    ppSystemVariable5: TppSystemVariable;
    ppSystemVariable6: TppSystemVariable;
    qryRelLogID: TIntegerField;
    qryRelLogDATA: TDateField;
    qryRelLogHORA: TTimeField;
    qryRelLogCODIGOUSUARIO: TIntegerField;
    qryRelLogTEXTO: TMemoField;
    qryRelLogUSERNAME: TIBStringField;
    qryRelLogNOME: TIBStringField;
    ppGroup1: TppGroup;
    ppGroupHeaderBand1: TppGroupHeaderBand;
    ppGroupFooterBand1: TppGroupFooterBand;
    ppLabel3: TppLabel;
    ppLine13: TppLine;
    ppLabel4: TppLabel;
    ppLabel5: TppLabel;
    ppLabel6: TppLabel;
    ppDBText16: TppDBText;
    ppLabel7: TppLabel;
    ppDBText17: TppDBText;
    ppDBText18: TppDBText;
    ppDBText19: TppDBText;
    ppDBText20: TppDBText;
    lblNomeCodigo: TppLabel;
    lblNomeNome: TppLabel;
    CampoCodigo: TppDBText;
    CampoNome: TppDBText;
    CampoExtra: TppDBText;
    lblCampoExtra: TppLabel;
    esquerda: TppLabel;
    direita: TppLabel;
    rbiFechamentoTurno: TppReport;
    ppHeaderBand4: TppHeaderBand;
    ppDBText21: TppDBText;
    ppDBText22: TppDBText;
    ppDBText23: TppDBText;
    ppLine14: TppLine;
    ppLine15: TppLine;
    ppLabel1: TppLabel;
    ppLine16: TppLine;
    ppDBText24: TppDBText;
    ppDBText25: TppDBText;
    ppDetailBand4: TppDetailBand;
    ppLabel8: TppLabel;
    ppLabel9: TppLabel;
    ppLabel10: TppLabel;
    varNomeTurno: TppVariable;
    varNomeServo: TppVariable;
    varDataEmissao: TppVariable;
    ppLine18: TppLine;
    ppLabel11: TppLabel;
    ppLabel12: TppLabel;
    ppLabel13: TppLabel;
    ppLabel14: TppLabel;
    varTotalDizimo: TppVariable;
    varTotalColetasComunidade: TppVariable;
    varTotalColetasEspeciais: TppVariable;
    ppLabel15: TppLabel;
    ppLabel16: TppLabel;
    varTotalOutrasOfertas: TppVariable;
    varTotalFestas: TppVariable;
    ppLine19: TppLine;
    ppLine20: TppLine;
    ppLabel18: TppLabel;
    ppLabel19: TppLabel;
    varTotal1: TppVariable;
    ppLabel20: TppLabel;
    varTotal2: TppVariable;
    ppLabel21: TppLabel;
    varTotal3: TppVariable;
    ppLabel22: TppLabel;
    varTotal4: TppVariable;
    ppLine21: TppLine;
    ppLine22: TppLine;
    ppLine23: TppLine;
    ppParameterList1: TppParameterList;
    ppLabel17: TppLabel;
    ppDBText26: TppDBText;
    qryComunidadeCNPJ: TIBStringField;
    BackupFile1: TBackupFile;
    TcpClient1: TTcpClient;
    ibsScript: TIBScript;
    GetConfig: TIBQuery;
    ImageList1: TImageList;
    updHistoricoSituacao: TIBUpdateSQL;
    dtsHistoricoSituacao: TDataSource;
    qryHistoricoSituacao: TIBQuery;
    qryHistoricoSituacaoCODIGOORIGEM: TIntegerField;
    qryHistoricoSituacaoID: TIntegerField;
    qryHistoricoSituacaoTIPO: TIntegerField;
    qryHistoricoSituacaoDATA: TDateField;
    qryHistoricoSituacaoHORA: TTimeField;
    qryHistoricoSituacaoCODIGOSITUACAO: TIntegerField;
    qryHistoricoSituacaoDESCRICAOSITUACAO: TIBStringField;
    qryHistoricoSituacaoDATAFIM: TDateField;
    qryHistoricoSituacaoHORAFIM: TTimeField;
    Geral2: TIBQuery;
    Geral3: TIBQuery;
    qryHistoricoSituacaoCODIGOUSUARIO: TIntegerField;
    qryHistoricoSituacaoHISTORICOTRANSFERENCIA: TIBStringField;
    qryHistoricoSituacaoCODIGOQUESTIONARIO: TIntegerField;
    procedure DataModuleCreate(Sender: TObject);
    procedure qryLogNewRecord(DataSet: TDataSet);
    procedure qryLogAfterPost(DataSet: TDataSet);
    procedure qryRelParcFinanceiroCalcFields(DataSet: TDataSet);
    procedure qryComunidadeBeforeOpen(DataSet: TDataSet);
    procedure ppImage1Print(Sender: TObject);
    procedure ppImage3Print(Sender: TObject);
    procedure ppImage2Print(Sender: TObject);
    procedure ppImage4Print(Sender: TObject);
    procedure ppHeaderBand4BeforeGenerate(Sender: TObject);
    procedure IBDatabaseAfterConnect(Sender: TObject);
  private
    xDataFechamentoEspecifico: TDate;
    NomeTurno,  NomeServo : String;
    TotalContribuicoes,
    TotalOfertasComunidade,
    TotalOfertasEspeciais,
    TotalOutrasOfertas,
    TotalOfertasFestas: Currency;
    Function VerificaRegistro(NomeComunidade, ChaveLiberacao: String): Boolean;
    { Private declarations }
  public
    CodigoTurnoCorrente,
    CodigoComunidadeCorrente,
    LimiteDizimistas : Integer;
    NomeComunidadeRegistro: String;
    PORTA_IMPRESSORA: sTRING;
    regMalaDireta: TPublicMalaDireta;
    procedure GerarOS(CodigoAgenda: Integer;
                      CodigoPrestador: Integer;
                      CodigoServico: integer;
                      Observacoes: String;
                      Produtos: Array of integer);
    procedure CancelarAgenda(CodigoAgenda: Integer;
                             Motivo: String);
    procedure ConfirmarAgenda(CodigoAgenda: Integer);
    procedure FinalizarAgenda(CodigoAgenda: Integer);
    function Agendar(CodigoPedido: Integer;
                      CodigoPerfil: integer;
                      CodigoProduto: Integer;
                      DataInicio: TDate;
                      DataFim: TDate;
                      HoraInicio: TTime;
                      HoraFim: TTime;
                      Descricao: String;
                      IdEvento: Integer = 0): integer;
    procedure ShowConfig(Form: TForm);
    function Config(Form: TForm;
                    NomeConfig: String;
                    Caption: String;
                    Descricao: String;
                    ValorDefault: Variant;
                    TipoConfiguracao: TTipoConfig;
                    SqlLookup: String = '';
                    CampoDisplayLookup: String = '';
                    CampoValorLookup: String = ''): TRetValorConfig;
    function ValorConfig(NomeForm: String;
                    NomeConfig: String;
                    ValorDefault: Variant;
                    TipoConfiguracao: TTipoConfig): TRetValorConfig;
    procedure BackupSeguranca;
    procedure apontamento;
    procedure ExecutarScript(vGauge : TGauge; vLabel: TLabel);
    procedure GetImage(var Sender: TppImage);
    procedure Log(Tipo: Integer; Texto: String);
    procedure ImprimirRelatorios(Arquivo, NomeRelatorio: String; Parametros: array of String; Valores: array of String);
    function UrlLogoEmpresa: String;
    Function Word_StringReplace(ADocument: TFileName; SearchString, ReplaceString: Array of string; Flags: TWordReplaceFlags): Boolean;
    Function AbrirDocumentoWord(ADocument: TFileName):Boolean;
    Function DigitarValor(Pergunta:String; ValorPadrao:String = ''):String;
    Function DigitarValorBD(Pergunta:String; Tabela: String; CodigoPadrao:Integer = 0; CampoNome: String = 'Nome'; CampoCodigo: String = 'Codigo'; Ordem: String = ''; Where: String = ''):Integer;
    Function Escolher(Pergunta:String; Valores: Array of String):Integer;
    Procedure Aguarde(Operacao: String; Gauge: Boolean = False; QtdOperacoes: Integer = 0);
    procedure AddProcesso(Processo: String);
    procedure ProcessoTerminado;
    procedure NovoRegistro(var Query: TIBQuery);
    procedure LancarCaixa(Financeiro, Parcela, Aluno: String; ValorPago: Currency; Renegociado: Boolean = False; CodigoParcelaRenegociado: String = ''; DATALANC: TDate = 01/01/1000);
    function NovoCodigo(TABELA: STRING; CAMPOCODIGO: STRING = 'CODIGO'; FILTROADD: STRING = ''; PRIMEIROCODIGO: INTEGER = 0): INTEGER;
    procedure MostraAniversariantesDia(DataAtual:TDate);
//    procedure FecharTurno(Data: TDate; CodigoTurno: Integer; TurnoCorrente: Boolean = False; ID : Integer = 0);
    procedure ListaUniversal(Titulo,
                             NomeCampoCodigo,
                             FieldCampoCódigo,
                             NomeCampoNome,
                             FieldCampoNome,
                             NomeCampoExtra,
                             FieldCampoExtra,
                             Sql: String;
                             ImprimeCampoExtra: Boolean = False;
                             CampoExtraMoeda: Boolean = False;
                             CampoExtraData: Boolean = False);
    procedure VerificaPermicaoOPBD(NOMEMENU: String; DataSorce: TDataSource; Deletar : Boolean = False);
    procedure Fala(Texto: String; Valume: Integer = 100);
    procedure Saudacao;
    function Mensagem : String;
    function NumeroLicencas(Chave, NomeComunidade: String): Integer;
    procedure InserirHistorico(CodigoQuestionario, CodigoOrigem,Tipo,CodigoSituacao:Integer;NomeSituacao:String;DataVigencia:String;HoraVigencia:String);
    procedure AjustaRelatorio(Relatorio : TObject);
    function InserirContrato(CodigoCliente:Integer;ProdutosContrato:array of TProdutosContrato;Orcamento:Integer;Agenda: Integer = 0):Integer;
    function InserirOrcamento(CodigoCliente:Integer;ProdutosContrato:array of TProdutosContrato;Pedido:Integer;Agenda: Integer = 0):Integer;
    function AddCaracter(Texto: string; Tamanho: Integer; Posicao: string; Carac: string): string;
    function InserirOrdemServico(CodigoPrestador,Servico:Integer;ProdutosContrato:array of TProdutosContrato; Observacoes : String = '';CodigoOrdemServico:Integer=0) : Integer;
    function InserirFinanceiro(CodigoCliente: Integer;
                               CodigoFormaPagamento: integer;
                               Tipo: Integer;
                               DataEmissao : TDate;
                               DataVencimento : TDate;
                               CodigoSituacao : Integer;
                               Valor : Currency;
                               Observacoes:String;
                               CodigoContrato:Integer=0;
                               GerarPrevisao:Boolean=False): integer;
    Function RetornaSituacaoProduto(DataInicio,DataFim : TDateTime; Produto: Integer): String;
    Function ValidaURL(Tipo: TTipoURL): String;
    Procedure ConfigurarPesquisa(Tabela: String);
    Function MontarSQL(Tabela: String; Where: String = ''): String;
    procedure CopiarCaracteristicaAgenda(CodigoAgenda,CodigoNovaAgenda:Integer;Data:TDate;Hora:TTime);
    procedure AbrirAgenda(Codigo:Integer);
    procedure CriarModeloPainel(Tela: String;grdPedidosDBTableView1: TcxGridDBTableView);
    procedure SelecionarModeloPainel(grdPedidosDBTableView1: TcxGridDBTableView;Codigo:Integer);
    procedure ExcluirModeloPainel(Codigo:Integer);
    procedure ImprimirPDF(RepBui: TppReport; NArquivo: String);
    procedure GerarDevolucao(CodigoRegistro,Tipo,CodigoProduto:Integer);

  end;

var
  Dados: TDados;
  CodigoUsuarioCorrente: Integer;
  RelParcFinanceiroLiquidados : Boolean;
  Raquel: OLEVariant;

const
  PRINT = 10;  //Print and line feed
  PRINT_CARRIED_RETURN = 13; //Print and carriage return
  ESC = 27;
  GS = 29;
  TAB  =  09;
  DLE  = 16;
  EOT = 04;
  FS = 28;

implementation

uses form_valor_universal, form_escolha, form_aguarde,
  form_valor_universal_BD, RxLookup, form_aniversariantes,
  form_configuracoes, untContrato, untConfigPesquisa,
  untAgenda;



{$R *.dfm}

{procedure TDados.PrintLineUrano(Texto: String);
var
 SELECT_PRINT_MODE : String;
 UNDERLINE : String;
 LINE_SPACING_DEFAULT  : String;
 LINE_SPACING  : String;
 RIGHT_SIDE_CHAR : String;
 PARCIAL_CUT  : String;
 CUTTER : String;
 START_PRINTER : String;
 NEW_LINE : String;
 CHAR_SIZE : String;
 HRI_CHARS_POSITION : String;
 BAR_CODE_HEIGHT : String;
 BAR_CODE_WIDTH : String;
 PRINT_BAR_CODE : String;
 SET_PAGE_MODE  : String;
 SELECT_PRINTER  : String;
 SELECT_BIT_IMAGE_MODE  : String;
 TRANSMIT_STATUS  : String;
 SET_CHINESE_CHAR   : String;
 BRING_IMPULSE  : String;
 UPSIDE_DOWN   : String;
 HORIZONTAL_TAB_POSITION   : String;
 PRINT_LINE_FEED  : String;
 SET_CUT_SHEET_EJECT_LENGHT : String;
 SET_ABSOLUTE_POSITION  : String;

 begin
  SELECT_PRINT_MODE := chr(ESC) + '!';
	UNDERLINE  := chr(ESC) + '-';
	LINE_SPACING_DEFAULT  := chr(ESC)+ '2';
	LINE_SPACING  := chr(ESC) + '3';

  SELECT_PRINT_MODE := chr(ESC) + '!';
	UNDERLINE  := chr(ESC) + '-';
  LINE_SPACING_DEFAULT  := chr(ESC) + '2';
	LINE_SPACING  := chr(ESC) + '3';
	RIGHT_SIDE_CHAR := chr(ESC) + chr(32);
  PARCIAL_CUT  := chr(ESC) + 'i';
	CUTTER := chr(GS) + 'V' ;
	START_PRINTER  := chr(ESC) + '@';
  NEW_LINE := '\n';
  CHAR_SIZE := chr(GS) + '!' ; //ok
	HRI_CHARS_POSITION := chr(GS) + 'H'; //ok
	BAR_CODE_HEIGHT := chr(GS) + 'h' ; //ok
	BAR_CODE_WIDTH := chr(GS) + 'w' ; //ok
	PRINT_BAR_CODE := chr(GS) + 'k' ; //ok

  SET_PAGE_MODE  := chr(ESC) + 'W';
	SELECT_PRINTER  := chr(ESC) + ':=';
	SELECT_BIT_IMAGE_MODE := chr(ESC) + '*';
	TRANSMIT_STATUS := chr(DLE) + chr(EOT);
	SET_CHINESE_CHAR  := chr(FS) + '!';
	BRING_IMPULSE := chr(GS) + 'p' ;
	UPSIDE_DOWN  := chr(ESC) + '{';
	HORIZONTAL_TAB_POSITION  := chr(ESC) + 'D';
	PRINT_LINE_FEED := chr(ESC) + 'J';
	SET_CUT_SHEET_EJECT_LENGHT  := chr(ESC) + 'C';
	SET_ABSOLUTE_POSITION  := chr(ESC) + '$';


  TcpClient1.RemoteHost := edtRemoteHost.Text;
  TcpClient1.RemotePort := edtRemotePort.Text;
  try
    if TcpClient1.Connect then
    begin
      TcpClient1.Sendln(START_PRINTER);
      TcpClient1.Sendln(SELECT_PRINT_MODE + chr(00));
      TcpClient1.Sendln(LINE_SPACING +  chr(80) + 'teste' + NEW_LINE);
      TcpClient1.Sendln(UNDERLINE + chr(01) + 'MODO SUBLINHADO LIGADO' + NEW_LINE ); //ok
      TcpClient1.Sendln(UNDERLINE + chr(00) + 'M0DO SUBLINHADO DESLIGADO' + NEW_LINE ); //ok

      TcpClient1.Sendln(LINE_SPACING + chr(80) + 'teste' + NEW_LINE); //ok
      TcpClient1.Sendln(LINE_SPACING + chr(00));  //ok
      TcpClient1.Sendln(RIGHT_SIDE_CHAR + chr(80) + 'teste' + NEW_LINE); //ok
      TcpClient1.Sendln(CHAR_SIZE + chr(04) + 'Teste '+ NEW_LINE ); //ok
      TcpClient1.Sendln(CHAR_SIZE + chr(64) + 'Teste '+ NEW_LINE ); //ok
      TcpClient1.Sendln(CHAR_SIZE + chr(68) + 'Teste '+ NEW_LINE ); //ok
      TcpClient1.Sendln(CHAR_SIZE + chr(00) + 'Teste '+ NEW_LINE ); //ok

      TcpClient1.Sendln(HRI_CHARS_POSITION + chr(01)); //ok
      TcpClient1.Sendln(BAR_CODE_HEIGHT + chr(48)); //ok
      TcpClient1.Sendln(BAR_CODE_WIDTH + chr(02)); //ok
      TcpClient1.Sendln(PRINT_BAR_CODE + chr(02) + '2000000000015' + chr(00)); //ok

      TcpClient1.Sendln(HRI_CHARS_POSITION + chr(02)); //ok
      TcpClient1.Sendln(BAR_CODE_HEIGHT + chr(96)); //ok
      TcpClient1.Sendln(BAR_CODE_WIDTH + chr(04)); //ok
      TcpClient1.Sendln(PRINT_BAR_CODE + chr(03) + '2000000000015' + chr(00)); //ok

      TcpClient1.Sendln(HRI_CHARS_POSITION + chr(03)); //ok
      TcpClient1.Sendln(BAR_CODE_HEIGHT + chr(144)); //ok
      TcpClient1.Sendln(BAR_CODE_WIDTH + chr(06)); //ok
      TcpClient1.Sendln(PRINT_BAR_CODE + chr(03) + '2000000000015' + chr(00)); //ok
    end;
  finally
    TcpClient1.Disconnect;
  end;

  NEW_LINE := '\n';
end;  }

Procedure TDados.ConfigurarPesquisa(Tabela: String);
begin
  If Application.FindComponent('frmConfigPesquisa') = Nil then
    Application.CreateForm(TfrmConfigPesquisa, frmConfigPesquisa);

  frmConfigPesquisa.dseConfig.Params[0].AsString := Tabela;
  frmConfigPesquisa.qryFields.Params[0].AsString := Tabela;
  frmConfigPesquisa.qryFields2.Params[0].AsString := Tabela;

  frmConfigPesquisa.ShowModal;
end;

Function TDados.MontarSQL(Tabela: String; Where: String = ''): String;
var
  strCampos: String;
begin
  strCampos := '';

  Geral.SQL.Text := 'Select * from TABCONTROLEPESQUISACAMPOS where TABELA = '+QuotedStr(Tabela)+' order by ORDEM ';
  Geral.Open;

  while not Geral.Eof do
  begin
    strCampos := strCampos + iif(strCampos <> '',', ','')+Geral.FieldByName('FieldName').AsString+' "'+Geral.FieldByName('TITULO').AsString+'"'  ;
    Geral.Next;
  end;

  Result := 'Select '+strCampos+' from '+Tabela+iif(Trim(Where) <> '',' Where ','')+Trim(Where);

end;

Function TDados.ValidaURL(Tipo: TTipoURL): String;
var
  vTempURL: String;
begin
  vTempURL := ValorConfig('principal','URL_FOTOS',ExtractFilePath(Application.ExeName)+'FOTOS',tcTexto).vcString;

  if not DirectoryExists(vTempURL) then
  begin
    if vTempURL = ExtractFilePath(Application.ExeName)+'FOTOS' then
    begin
        if not CreateDir(vTempURL) then
          Application.MessageBox(Pchar('Falha ao criar Diretório "'+vTempURL+'"!'),'Falha',MB_OK+MB_ICONERROR);
    end
    else
    begin
      Application.MessageBox(Pchar('Diretórios "'+vTempURL+'" não Encontrado!'),'Diretório Inválido',MB_OK+MB_ICONERROR);
    end;
  end;

  if not DirectoryExists(vTempURL+'\PERFIL') then
    if not CreateDir(vTempURL+'\PERFIL') then
      Application.MessageBox(Pchar('Falha ao criar Diretório "'+vTempURL+'\PERFIL'+'"!'),'Falha',MB_OK+MB_ICONERROR);

  if not DirectoryExists(vTempURL+'\PRODUTO') then
    if not CreateDir(vTempURL+'\PRODUTO') then
      Application.MessageBox(Pchar('Falha ao criar Diretório "'+vTempURL+'\PRODUTO'+'"!'),'Falha',MB_OK+MB_ICONERROR);

  if Tipo = tuProduto then
    Result := vTempURL+'\PRODUTO\'
  else
    Result := vTempURL+'\PERFIL\';
end;

procedure TDados.VerificaPermicaoOPBD(NOMEMENU: String; DataSorce: TDataSource; Deletar : Boolean = False);
var
  Alterar, Inserir, Excluir: Boolean;
begin
  geral.sql.text := 'select ALTERAR, EXCLUIR, INSERIR from tabpermicoesusuario where codigousuario = '+IntToStr(untdados.CodigoUsuarioCorrente)+
                          ' and nomemenu = '+#39+NOMEMENU+#39;
  geral.Open;
   Alterar := geral.FieldByName('ALTERAR').AsInteger = 1;
   Inserir := geral.FieldByName('INSERIR').AsInteger = 1;
   Excluir := geral.FieldByName('EXCLUIR').AsInteger = 1;
  geral.Close;
  if DataSorce.State = dsEdit then
  begin
    if Alterar then
      Exit;
    Application.MessageBox('Operação de Alteração de Registro não Permitida!', 'Permissão', mb_ok+MB_ICONEXCLAMATION);
    DataSorce.DataSet.Cancel;
    Abort;
  end
  else if DataSorce.State = dsInsert then
  begin
    if Inserir then
      Exit;
    Application.MessageBox('Operação de Inserção de Registro não Permitida!', 'Permissão', mb_ok+MB_ICONEXCLAMATION);
    DataSorce.DataSet.Cancel;
    Abort;
  end
  else if Deletar then
  begin
    if Excluir then
      Exit;
    Application.MessageBox('Operação de Exclusão de Registro não Permitida!', 'Permissão', mb_ok+MB_ICONEXCLAMATION);
    DataSorce.DataSet.Cancel;
    Abort;
  end
end;

procedure TDados.AbrirAgenda(Codigo: Integer);
begin

  if Application.FindComponent('frmAgenda') = Nil then
    Application.CreateForm(TfrmAgenda, frmAgenda);

  frmAgenda.Show;

  Geral.Close;
  Geral.sql.Text := 'Select DATA,DATAFIM from TABAGENDA where CODIGO =0' + intToStr(Codigo);
  Geral.Open;

  With frmAgenda do
  begin
    edtDtInicial.Date := dados.Geral.FieldByName('DATA').AsDateTime;
    edtDtFinal.Date   := dados.Geral.FieldByName('DATAFIM').AsDateTime;
    cxButton1.Click;

    cxScheduler1.GoToDate(dados.Geral.FieldByName('DATA').AsDateTime);
    cxScheduler1.viewDay.Active := true;
    cxScheduler1.DateNavigator.Date :=  cxScheduler1.SelStart;
    ComboBox1.ItemIndex := 0;
  end;

end;

procedure TDados.MostraAniversariantesDia(DataAtual:TDate);
begin
  If Application.FindComponent('AniversariantesDia') = Nil then
    Application.CreateForm(TAniversariantesDia, AniversariantesDia);

  geral.SQL.Text := 'Select Nome "Nome", TelResidencial "Telefone" '+
                    ' from TABDIZIMISTA '+
                    ' where extract(day from Nascimento) = '+#39+formatDateTime('DD',DataAtual)+#39+
                    ' and extract(month from Nascimento) = '+#39+formatDateTime('MM',DataAtual)+#39;

  geral.Open;

  if not geral.IsEmpty then
    AniversariantesDia.ShowModal;

  geral.Close;

end;

function TDados.NovoCodigo(TABELA: STRING; CAMPOCODIGO: STRING = 'CODIGO'; FILTROADD: STRING = ''; PRIMEIROCODIGO: INTEGER = 0): INTEGER;
begin
  geral.SQL.Text := 'Select max('+CAMPOCODIGO+') as codigo from ' + TABELA +
  iif(FILTROADD <> '', ' WHERE '+ FILTROADD, '');
  geral.Open;
    if (geral.FieldByName('codigo').AsInteger + 1)<PRIMEIROCODIGO then
      Result := PRIMEIROCODIGO
    else
      Result := geral.FieldByName('codigo').AsInteger + 1;
  geral.Close;
end;

procedure TDados.LancarCaixa(Financeiro, Parcela, Aluno: String; ValorPago: Currency; Renegociado: Boolean = False; CodigoParcelaRenegociado: String = ''; DATALANC: TDate = 01/01/1000);
var
 Tipo,
 Renegociacao,
 NovoCodigo: String;
begin

  DATALANC := iif(DATALANC = 01/01/1000, Date, DATALANC);

  geral.sql.Text := 'Select tipo from TabFinanceiro where codigo = ' + Financeiro;
  geral.Open;

  if geral.FieldByName('tipo').Value = 1 then   // Curso
    Tipo := '2'
  else
    Tipo := '1';

  if Renegociado then
    Renegociacao := #39+'Parcela Renegociada que o Saldo Remanescente Gerou a Parcela de Nº: '+ CodigoParcelaRenegociado+#39
  else
    Renegociacao := 'null';

  Geral.sql.Text := 'select max(codigo) as ultimocodigo from TABLANCAMENTOCAIXA';
  geral.Open;
    NovoCodigo := IntToStr(geral.FieldByName('ultimocodigo').AsInteger + 1);


  Geral.Close;
  Geral.sql.Text := ' Insert into TABLANCAMENTOCAIXA ('+
                    ' CODIGO,'+
                    ' DATACADASTRO,'+
                    ' CODIGOCLASSEFINANCEIRA,'+
                    ' CODIGOSUBCLASSEFINANCEIRA,'+
                    ' NOME,'+
                    ' VALORTOTAL,'+
                    ' OBSERVACAO,'+
                    ' TIPO,'+
                    ' CODIGOALUNO'+
                    ' ) VALUES ( '+
                    NovoCodigo+','+
                    #39+ FormatDateTime('mm/dd/yyyy', DATALANC) + #39 +','+
                    '1,'+
                    Tipo+','+
                    #39+'Pagamento Parcela:' + Parcela +#39+','+
                    ':Valor,'+
                    Renegociacao+','+
                    '2,'+
                    Aluno+')';
  Geral.ParamByName('Valor').AsCurrency := ValorPago;
  Geral.ExecSQL;
  Geral.Close;
  
end;

procedure TDados.NovoRegistro(var Query: TIBQuery);
begin

//  if not Query.Active then
//    Query.Open;

//  if Application.MessageBox('Deseja Inserir Novo Registro?', 'Novo', MB_YESNO + MB_ICONQUESTION) = idyes then
//    Query.Insert
//  else
//    Query.First;
    
end;

procedure TDados.ppHeaderBand4BeforeGenerate(Sender: TObject);
begin
  varNomeTurno.value := NomeTurno;
  varNomeServo.value := NomeServo;
  varDataEmissao.value := FormatDateTime('DD/MM/YYYY',xDataFechamentoEspecifico);
  varTotalDizimo.value := TotalContribuicoes;
  varTotalColetasComunidade.value :=  TotalOfertasComunidade;
  varTotalColetasEspeciais.value :=  TotalOfertasEspeciais;
  varTotalOutrasOfertas.value := TotalOutrasOfertas;
  varTotalFestas.value := TotalOfertasFestas;
  varTotal1.Value := TotalOfertasComunidade+
                     TotalOfertasEspeciais+
                     TotalOfertasFestas;
  varTotal2.Value := TotalContribuicoes+
                     TotalOfertasComunidade+
                     TotalOfertasEspeciais+
                     TotalOfertasFestas;
  varTotal3.Value := TotalOutrasOfertas;
  varTotal4.Value := TotalContribuicoes+
                     TotalOfertasComunidade+
                     TotalOfertasEspeciais+
                     TotalOfertasFestas+
                     TotalOutrasOfertas;
end;

procedure TDados.ppImage1Print(Sender: TObject);
begin
  Dados.GetImage(ppImage1);
end;

procedure TDados.ppImage2Print(Sender: TObject);
begin
  Dados.GetImage(ppImage2);
end;

procedure TDados.ppImage3Print(Sender: TObject);
begin
//  Dados.GetImage(ppImage3);
end;

procedure TDados.ppImage4Print(Sender: TObject);
begin
//  Dados.GetImage(ppImage4);
end;

procedure TDados.GerarDevolucao(CodigoRegistro, Tipo, CodigoProduto: Integer);
begin

  try

    if Tipo = 1 then
    begin
    
      Geral2.Close;
      Geral2.Sql.Text := 'UPDATE TABCONTRATODETALHE '+
                         '   SET DEVOLVIDO = 1, '+
                         '       DATAHORADEVOLUCAO = CURRENT_TIMESTAMP, '+
                         '       USUARIODEVOLUCAO =0'+intToStr(CodigoUsuarioCorrente)+
                         ' where CODIGO =0'+IntToStr(CodigoRegistro) +
                         '   AND CODIGOPRODUTO =0'+intToStr(CodigoProduto)+
                         '   AND COALESCE(DEVOLVIDO,0) = 0 ';
      Geral2.ExecSql;
      
    end
    else
    if Tipo = 2 then
    begin

      Geral2.Close;
      Geral2.Sql.Text := 'UPDATE TABOSDETALHE '+
                         '   SET DEVOLVIDO = 1, '+
                         '       DATAHORADEVOLUCAO = CURRENT_TIMESTAMP, '+
                         '       USUARIODEVOLUCAO =0'+intToStr(CodigoUsuarioCorrente)+', '+
                         '       DATAFIM = CURRENT_DATE, '+
                         '       HORAFIM = CURRENT_TIME '+
                         ' where CODIGOOS =0'+IntToStr(CodigoRegistro) +
                         '   AND CODIGOPRODUTO =0'+intToStr(CodigoProduto)+
                         '   AND COALESCE(DEVOLVIDO,0) = 0 ';
      Geral2.ExecSql;
          
    end;

    Geral2.Transaction.CommitRetaining;

  except
    on E: Exception do
      raise Exception.Create(E.Message);
  end;

end;

procedure TDados.GerarOS(CodigoAgenda: Integer;
                         CodigoPrestador: Integer;
                         CodigoServico: integer;
                         Observacoes: String;
                         Produtos: Array of integer);
var
  xCodigo, xID: Integer;
  i: integer;
begin
  Geral.Sql.Text := 'select * from tabos os '#13+
                    ' where os.codigoperfil = :perfil '#13+
                    '   and os.codigoservico = :servico '#13+
                    '   and os.codigoagenda = :agenda ';
  Geral.ParamByName('perfil').AsInteger  := CodigoPrestador;
  Geral.ParamByName('servico').AsInteger := CodigoServico;
  Geral.ParamByName('agenda').AsInteger  := CodigoAgenda;
  Geral.Open;
  if Geral.IsEmpty then
  begin
    Geral2.Sql.Text := 'select Max(codigo) xid from tabos';
    Geral2.Open;
    xCodigo := Geral2.Fields[0].AsInteger + 1;

    Geral2.Sql.Text := 'INSERT INTO TABOS (CODIGO, DATA, '#13+
         'CODIGOPERFIL, CODIGOSERVICO, '#13+
         'OBSERVACOES, SITUACAO, CODIGOUSUARIO, CODIGOAGENDA) VALUES ('+
         ':CODIGO, CURRENT_DATE, '#13+
         ':CODIGOPERFIL, :CODIGOSERVICO, '#13+
         ':OBSERVACOES, 1, :CODIGOUSUARIO, :CODIGOAGENDA)';
    Geral2.ParamByName('CODIGO').AsInteger          := xCodigo;
    Geral2.ParamByName('CODIGOPERFIL').AsInteger    := CodigoPrestador;
    Geral2.ParamByName('CODIGOSERVICO').AsInteger   := CodigoServico;
    Geral2.ParamByName('OBSERVACOES').AsString      := Observacoes;
    Geral2.ParamByName('CODIGOUSUARIO').AsInteger   := CodigoUsuarioCorrente;
    Geral2.ParamByName('CODIGOAGENDA').AsInteger    := CodigoAgenda;
    Geral2.ExecSql;
    Geral2.Transaction.CommitRetaining;
  end
  else
    xCodigo := Geral.Fields[0].AsInteger;

  for i := 0 to length(Produtos) - 1 do
  begin

    Geral.Sql.Text := 'select * from tabosdetalhe d '#13+
                      ' where d.codigoos = :os '#13+
                      '   and d.codigoproduto = :produto ';
    Geral.ParamByName('os').AsInteger      := xCodigo;
    Geral.ParamByName('produto').AsInteger := Produtos[i];
    Geral.Open;

    if Geral.IsEmpty then
    begin
      Geral2.Sql.Text := 'select Max(d.id) xid from tabosdetalhe d '#13+
                         ' where d.codigoos = :os ';
      Geral2.ParamByName('os').AsInteger      := xCodigo;
      Geral2.Open;
      xID := Geral2.Fields[0].AsInteger + 1;

      Geral2.Sql.Text := 'INSERT INTO TABOSDETALHE (CODIGOOS, ID, CODIGOPRODUTO, '#13+
           'VALORSERVICO) VALUES ( '#13+
           ':CODIGOOS, :ID, :CODIGOPRODUTO, '#13+
           ':VALORSERVICO)';
      Geral2.ParamByName('CODIGOOS').AsInteger      := xCodigo;
      Geral2.ParamByName('ID').AsInteger            := xID;
      Geral2.ParamByName('CODIGOPRODUTO').AsInteger := Produtos[i];
      Geral2.ParamByName('VALORSERVICO').AsFloat    := 0;
      Geral2.ExecSql;
      Geral2.Transaction.CommitRetaining;
    end;

  end;

end;

procedure TDados.CancelarAgenda(CodigoAgenda: Integer;
                         Motivo: String);
begin
  Geral.Sql.Text := 'update TABAGENDA set SITUACAO = 2, MOTIVOCANCELAMENTO = :MOTIVO where CODIGO = '+IntToStr(CodigoAgenda);
  Geral.ParamByName('MOTIVO').AsString := Motivo;
  Geral.ExecSql;
  Geral.Transaction.CommitRetaining;
end;

procedure TDados.ConfirmarAgenda(CodigoAgenda: Integer);
begin
  Geral.Sql.Text := 'update TABAGENDA set SITUACAO = 3 where CODIGO = '+IntToStr(CodigoAgenda);
  Geral.ExecSql;
  Geral.Transaction.CommitRetaining;
end;

procedure TDados.CopiarCaracteristicaAgenda(CodigoAgenda,CodigoNovaAgenda:Integer;Data:TDate;Hora:TTime);
begin

  Geral.Close;
  Geral.SQL.Text := 'SELECT * '+
                    '  FROM TABMOVIMENTACAOCONTRATO D '+
                    ' WHERE D.CODIGOREGISTRO =0'+intToStr(CodigoAgenda) +
                    '   AND D.TIPO IN (1,2,3,4) ';
  Geral.Open;

  if not Geral.IsEmpty then
  begin

    Geral2.Sql.Text := 'update TABMOVIMENTACAOCONTRATO '+
                      '   set CODIGOREGISTRO =0'+intToStr(CodigoNovaAgenda)+', '+
                      '       DATA = '+QuotedStr(FormatDateTime('mm/dd/yyyy', Data))+', '+
                      '       HORA = '+QuotedStr(FormatDateTime('hh:mm:ss', Hora)) +
                      ' where CODIGO =0'+Geral.FieldByName('CODIGO').Text+
                      '   and ID =0'+Geral.FieldByName('ID').Text;
    Geral2.ExecSql;

    if Geral.FieldByName('TIPO').AsInteger = 3 then
    begin
      Geral2.Sql.Text := 'update TABCONTRATO '+
                        '   set DATARESERVA = '+QuotedStr(FormatDateTime('mm/dd/yyyy', Data))+', '+
                        '       HORARESERVA = '+QuotedStr(FormatDateTime('hh:mm:ss', Hora))+
                        ' where CODIGO =0'+Geral.FieldByName('CODIGO').Text;
      Geral2.ExecSql;

    end
    else
    if Geral.FieldByName('TIPO').AsInteger = 4 then
    begin
      Geral2.Sql.Text := 'update TABCONTRATO '+
                        '   set DATARETORNO = '+QuotedStr(FormatDateTime('mm/dd/yyyy', Data))+', '+
                        '       HORARETORNO = '+QuotedStr(FormatDateTime('hh:mm:ss', Hora))+
                        ' where CODIGO =0'+Geral.FieldByName('CODIGO').Text;
      Geral2.ExecSql;
    end;

    Geral2.Transaction.CommitRetaining;

  end;

end;

procedure TDados.CriarModeloPainel(Tela: String;
  grdPedidosDBTableView1: TcxGridDBTableView);
var
   Nome, NomeArquivo, Detalhamento, Texto, Caminho : String;
   ArquivoRel : TStringList;
   Codigo : Integer;
begin
  try

    Nome := DigitarValor('Nome do Relatório');

    if nome = '' then Exit;

    Caminho := ExtractFilePath(Application.ExeName)+'\Paineis';

    if not DirectoryExists(Caminho) then
      ForceDirectories(Caminho);

    Codigo := NovoCodigo('TABPAINEIS');

    NomeArquivo := Tela+'_'+grdPedidosDBTableView1.Name+'_'+intToStr(Codigo)+'.ini';

    grdPedidosDBTableView1.StoreToIniFile(Caminho+'\'+NomeArquivo, True, [gsoUseFilter, gsoUseSummary]);

    ArquivoRel := TStringList.Create;

    ArquivoRel.LoadFromFile(Caminho+'\'+NomeArquivo);

    Geral.Close;
    Geral.Sql.Text := 'INSERT INTO TABPAINEIS (CODIGO, DATA, NOMERELATORIO, NOMEARQUIVO, DETALHEARQUIVO, TELA, COMPONENTE) '#13+
                      ' VALUES (:CODIGO, :DATA, :NOMERELATORIO, :NOMEARQUIVO, :DETALHEARQUIVO, :TELA, :COMPONENTE)';

    Geral.ParamByName('CODIGO').AsInteger        := Codigo;
    Geral.ParamByName('DATA').AsDateTime         := Date;
    Geral.ParamByName('NOMERELATORIO').AsString  := Nome;
    Geral.ParamByName('NOMEARQUIVO').AsString    := NomeArquivo;
    Geral.ParamByName('DETALHEARQUIVO').AsString := Trim(ArquivoRel.Text);
    Geral.ParamByName('TELA').AsString           := Tela;
    Geral.ParamByName('COMPONENTE').AsString     := grdPedidosDBTableView1.Name;
    Geral.ExecSql;
    Geral.Transaction.CommitRetaining;

  except
    on e:Exception do
      application.MessageBox(Pchar('Erro 21254.'+#13+E.message),'ERRO',mb_OK+MB_ICONERROR);
  end;
end;
procedure TDados.FinalizarAgenda(CodigoAgenda: Integer);
begin
  Geral.Sql.Text := 'update TABAGENDA set SITUACAO = 4 where CODIGO = '+IntToStr(CodigoAgenda);
  Geral.ExecSql;
  Geral.Transaction.CommitRetaining;
end;

function TDados.Agendar(CodigoPedido: Integer;
                      CodigoPerfil: integer;
                      CodigoProduto: Integer;
                      DataInicio: TDate;
                      DataFim: TDate;
                      HoraInicio: TTime;
                      HoraFim: TTime;
                      Descricao: String;
                      IdEvento: Integer = 0): Integer;
var
  Codigo: Integer;
  vDataFim: TDate;
  vHoraFim: TTime;
  vTempoMinimo: TTime;
begin
  Geral.SQL.Text := 'Select max(codigo) xCod from TABAGENDA';
  Geral.Open;
  Codigo := Geral.FieldByName('xCod').AsInteger + 1;

  if DataFim < DataInicio then
    vDataFim := DataInicio
  else
    vDataFim := DataFim;

  if HoraFim = 0 then
  begin
    vTempoMinimo := ValorConfig('frmAgenda','TEMPOMINIMO',StrToTime('00:30:00'),tcHora).vcTime;
    vHoraFim := HoraInicio + vTempoMinimo;
  end
  else
    vHoraFim := HoraFim;

  Geral.SQL.Text := 'INSERT INTO TABAGENDA ( ' +
                    'CODIGO, '+
                    'DATA, '+
                    'HORA, '+
                    'IDPEDIDOAGENDA, '+
                    'IDPERFIL, '+
                    'CODIGOPRODUTO, '+
                    'DESCRICAO, '+
                    'DATAFIM, '+
                    'HORAFIM, '+
                    'SITUACAO, '+
                    'IDEVENTO) VALUES ('+
                    ':CODIGO, :DATAINICIO, :HORAINICIO, :PEDIDOAGENDA, :PERFIL, '+
                    ':PRODUTO, :DESCRICAO, :DATAFIM, :HORAFIM, :SITUACAO, :IDEVENTO)';
  Geral.ParamByName('CODIGO').AsInteger := Codigo;
  Geral.ParamByName('DATAINICIO').AsDateTime := DataInicio;
  Geral.ParamByName('HORAINICIO').AsDateTime := HoraInicio;
  Geral.ParamByName('PEDIDOAGENDA').AsInteger := CodigoPedido;
  Geral.ParamByName('PERFIL').AsInteger := CodigoPerfil;
  Geral.ParamByName('PRODUTO').AsInteger := CodigoProduto;
  Geral.ParamByName('DESCRICAO').AsString := Descricao;
  Geral.ParamByName('DATAFIM').AsDateTime := vDataFim;
  Geral.ParamByName('HORAFIM').AsDateTime := vHoraFim;
  Geral.ParamByName('SITUACAO').AsInteger := 1;
  Geral.ParamByName('IDEVENTO').AsInteger := IdEvento;
  Geral.ExecSql;
  Geral.Transaction.CommitRetaining;

  result := Codigo;
end;

procedure TDados.ShowConfig(Form: TForm);
begin
  If Application.FindComponent('frmConfiguracoes') = Nil then
    Application.CreateForm(TfrmConfiguracoes, frmConfiguracoes);

  frmConfiguracoes.FormChamado := Form;
  frmConfiguracoes.ShowModal;
end;

function TDados.Config(Form: TForm;
                       NomeConfig: String;
                       Caption: String;
                       Descricao: String;
                       ValorDefault: Variant;
                       TipoConfiguracao: TTipoConfig;
                       SqlLookup: String = '';
                       CampoDisplayLookup: String = '';
                       CampoValorLookup: String = ''): TRetValorConfig;
begin
  GetConfig.Close();
  GetConfig.SQL.Text := 'Select * from TABCONFIGURACOES '+
                        ' where FORM_NAME = '+QuotedStr(Form.Name)+
                        '   and CONFIG_NAME = '+QuotedStr(NomeConfig);
  GetConfig.Open();
  if GetConfig.IsEmpty then
  begin
    GetConfig.Close();
    GetConfig.SQL.Text := 'INSERT INTO TABCONFIGURACOES ( '+
       '   FORM_NAME, CONFIG_NAME, CONFIG_CAPTION, DESCRICAO, TIPOCONFIG, '+
       '   VALOR_INTEIRO, VALOR_STRING, VALOR_MEMO, VALOR_LOGICO, VALOR_DATA, '+
       '   VALOR_HORA,VALORREAL, SQL_LOOKUP, DISPLAY_LOOKUP, KEYVALUE_LOOKUP) '+
       ' VALUES (:FORM_NAME, :CONFIG_NAME, :CONFIG_CAPTION, :DESCRICAO, :TIPOCONFIG, '+
       '   :VALOR_INTEIRO, :VALOR_STRING, :VALOR_MEMO, :VALOR_LOGICO, :VALOR_DATA, '+
       '   :VALOR_HORA, :VALORREAL, :SQL_LOOKUP, :DISPLAY_LOOKUP, :KEYVALUE_LOOKUP)';

    GetConfig.ParamByName('FORM_NAME').AsString := Form.Name;
    GetConfig.ParamByName('CONFIG_NAME').AsString := NomeConfig;
    GetConfig.ParamByName('CONFIG_CAPTION').AsString := Caption;
    GetConfig.ParamByName('DESCRICAO').AsString := Descricao;

    GetConfig.ParamByName('SQL_LOOKUP').AsString := SqlLookup;
    GetConfig.ParamByName('DISPLAY_LOOKUP').AsString := CampoDisplayLookup;
    GetConfig.ParamByName('KEYVALUE_LOOKUP').AsString := CampoValorLookup;

    GetConfig.ParamByName('VALOR_INTEIRO').Value := Null;
    GetConfig.ParamByName('VALOR_STRING' ).Value := Null;
    GetConfig.ParamByName('VALOR_MEMO'   ).Value := Null;
    GetConfig.ParamByName('VALOR_LOGICO' ).Value := Null;
    GetConfig.ParamByName('VALOR_DATA'   ).Value := Null;
    GetConfig.ParamByName('VALOR_HORA'   ).Value := Null;
    GetConfig.ParamByName('VALORREAL'    ).Value := Null;

    case TipoConfiguracao of
      tcTexto : begin
        GetConfig.ParamByName('VALOR_STRING' ).AsString := VarToStrDef(ValorDefault,'');
        GetConfig.ParamByName('TIPOCONFIG' ).AsInteger := 1;
        result.vcString := VarToStrDef(ValorDefault,'');
      end;
      tcInteiro : begin
        GetConfig.ParamByName('VALOR_INTEIRO' ).Value := ValorDefault;
        GetConfig.ParamByName('TIPOCONFIG' ).AsInteger := 2;
        result.vcInteger := ValorDefault;
      end;
      tcMemo : begin
        GetConfig.ParamByName('VALOR_MEMO' ).AsString := VarToStrDef(ValorDefault,'');
        GetConfig.ParamByName('TIPOCONFIG' ).AsInteger := 3;
        result.vcMemo := TStringList.Create;
        result.vcMemo.Text := VarToStrDef(ValorDefault,'');
      end;
      tcReal : begin
        GetConfig.ParamByName('VALORREAL' ).Value := ValorDefault;
        GetConfig.ParamByName('TIPOCONFIG' ).AsInteger := 4;
        result.vcReal := ValorDefault;
      end;
      tcData : begin
        GetConfig.ParamByName('VALOR_DATA' ).AsDateTime := VarToDateTime(ValorDefault);
        GetConfig.ParamByName('TIPOCONFIG' ).AsInteger := 5;
        result.vcDate := VarToDateTime(ValorDefault);
      end;
      tcHora : begin
        GetConfig.ParamByName('VALOR_HORA' ).AsDateTime := VarToDateTime(ValorDefault);
        GetConfig.ParamByName('TIPOCONFIG' ).AsInteger := 6;
        result.vcTime := VarToDateTime(ValorDefault);
      end;
      tcCheck : begin
        GetConfig.ParamByName('VALOR_LOGICO' ).Value := ValorDefault;
        GetConfig.ParamByName('TIPOCONFIG' ).AsInteger := 7;
        result.vcBoolean := ValorDefault = 1;
      end;
      tcCodigoLookup : begin
        GetConfig.ParamByName('VALOR_INTEIRO' ).Value := ValorDefault;
        GetConfig.ParamByName('TIPOCONFIG' ).AsInteger := 8;
        result.vcInteger := ValorDefault;
      end;
      tcCor : begin
        GetConfig.ParamByName('VALOR_INTEIRO' ).Value := ValorDefault;
        GetConfig.ParamByName('TIPOCONFIG' ).AsInteger := 9;
        result.vcCor := ValorDefault;
      end;
    end;

    GetConfig.ExecSQL();
    GetConfig.Transaction.CommitRetaining;
  end
  else
  begin
    case TipoConfiguracao of
      tcTexto        : result.vcString  := GetConfig.FieldByName('VALOR_STRING'  ).AsString;
      tcInteiro,
      tcCodigoLookup : result.vcInteger := GetConfig.FieldByName('VALOR_INTEIRO' ).AsInteger;
      tcCor          : result.vcCor     := GetConfig.FieldByName('VALOR_INTEIRO' ).AsInteger;
      tcReal         : result.vcReal    := GetConfig.FieldByName('VALORREAL'     ).AsFloat;
      tcData         : result.vcDate    := GetConfig.FieldByName('VALOR_DATA'    ).AsDateTime;
      tcHora         : result.vcTime    := GetConfig.FieldByName('VALOR_HORA'    ).AsDateTime;
      tcCheck        : result.vcBoolean := GetConfig.FieldByName('VALOR_LOGICO'  ).AsInteger = 1;
      tcMemo         : begin
                         result.vcMemo := TStringList.Create;
                         result.vcMemo.Text := GetConfig.FieldByName('VALOR_MEMO' ).AsString;
                       end;
    end;
  end;
end;

function TDados.ValorConfig(NomeForm: String;
                       NomeConfig: String;
                       ValorDefault: Variant;
                       TipoConfiguracao: TTipoConfig): TRetValorConfig;
begin
  GetConfig.Close();
  GetConfig.SQL.Text := 'Select * from TABCONFIGURACOES '+
                        ' where FORM_NAME = '+QuotedStr(NomeForm)+
                        '   and CONFIG_NAME = '+QuotedStr(NomeConfig);
  GetConfig.Open();
  if GetConfig.IsEmpty then
  begin

    case TipoConfiguracao of
      tcTexto : result.vcString := VarToStrDef(ValorDefault,'');
      tcInteiro : result.vcInteger := ValorDefault;
      tcCor     : result.vcCor     := ValorDefault;
      tcMemo : begin
        result.vcMemo := TStringList.create;
        result.vcMemo.Text := VarToStrDef(ValorDefault,'');
      end;
      tcReal : result.vcReal := ValorDefault;
      tcData : result.vcDate := VarToDateTime(ValorDefault);
      tcHora : result.vcTime := VarToDateTime(ValorDefault);
      tcCheck : result.vcBoolean := ValorDefault = 1;
      tcCodigoLookup : result.vcInteger := ValorDefault;
    end;
  end
  else
  begin
    case TipoConfiguracao of
      tcTexto        : result.vcString  := GetConfig.FieldByName('VALOR_STRING'  ).AsString;
      tcInteiro,
      tcCodigoLookup : result.vcInteger := GetConfig.FieldByName('VALOR_INTEIRO' ).AsInteger;
      tcCor          : result.vcCor     := GetConfig.FieldByName('VALOR_INTEIRO' ).AsInteger;
      tcReal         : result.vcReal    := GetConfig.FieldByName('VALORREAL'     ).AsFloat;
      tcData         : result.vcDate    := GetConfig.FieldByName('VALOR_DATA'    ).AsDateTime;
      tcHora         : result.vcTime    := GetConfig.FieldByName('VALOR_HORA'    ).AsDateTime;
      tcCheck        : result.vcBoolean := GetConfig.FieldByName('VALOR_LOGICO'  ).AsInteger = 1;
      tcMemo         : begin
                         result.vcMemo := TStringList.create;
                         result.vcMemo.Text := GetConfig.FieldByName('VALOR_MEMO' ).AsString;
                       end;
    end;
  end;
end;

procedure TDados.ExcluirModeloPainel(Codigo: Integer);
begin
  if application.MessageBox('Deseja realmente excluir o relatório?','',MB_YESNO+MB_ICONQUESTION)=idyes then
  begin
    Geral.Close;
    Geral.Sql.Text := 'DELETE FROM TABPAINEIS WHERE CODIGO =0'+intToStr(Codigo);
    Geral.ExecSql;
    Geral.Transaction.CommitRetaining;
  end;
end;

procedure TDados.ExecutarScript(vGauge : TGauge; vLabel: TLabel);
var
  Script : TStringList;
  i, x: Integer;
  ScriptLinhas: StringArray;
begin

  Script := TStringList.Create();
  try
    vGauge.Progress := 0;
    x := 0;
    if FileExists(ExtractFilePath(Application.ExeName)+'SLScript.txt') then
    begin

      Script.LoadFromFile(ExtractFilePath(Application.ExeName)+'SLScript.txt');

      ScriptLinhas := Split(Script.Text, ';;');

      if length(ScriptLinhas) > 0 then
      begin
        vGauge.MaxValue := length(ScriptLinhas) - 1;
        for i := 0 to length(ScriptLinhas) - 1 do
        begin

          inc(x);
          ibsScript.Script.add(StringReplace(ScriptLinhas[i],';;','',[]));
          vLabel.Caption := 'Executando Script - '+IntToStr(x);
          Application.ProcessMessages;
          try
            ibsScript.ExecuteScript;
            ibsScript.transaction.CommitRetaining();
          except
          end;
          ibsScript.Script.Clear();
          vGauge.Progress := i;

        end;

      end;

    end;

  finally
    FreeAndNil(Script);
  end;


end;

procedure TDados.GetImage(var Sender: TppImage);
begin
 //Colocar Imagem
 try
   sender.Picture.LoadFromFile(qryComunidadeURLLOGO.AsString);
 except
 end;
end;

Procedure TDados.Aguarde(Operacao: String; Gauge: Boolean = False; QtdOperacoes: Integer = 0);
begin
  If Application.FindComponent('frmAguarde') = Nil then
    Application.CreateForm(TfrmAguarde, frmAguarde);

  frmAguarde.lblMensagem.Caption := Operacao;
  frmAguarde.lblMensagem.Repaint;

  frmAguarde.Gauge.Visible := Gauge;
  frmAguarde.Gauge.Repaint;

  frmAguarde.Gauge.MaxValue := QtdOperacoes;

  frmAguarde.Show;
end;

procedure TDados.AjustaRelatorio(Relatorio: TObject);
begin

 (Relatorio as TppReport).AllowPrintToFile         := True;
 (Relatorio as TppReport).EmailSettings.PreviewInEmailClient := true;
 (Relatorio as TppReport).EmailSettings.Enabled := true;
 (Relatorio as TppReport).PreviewFormSettings.PageIncrement  := 0;
 (Relatorio as TppReport).PreviewFormSettings.SinglePageOnly := True;
 (Relatorio as TppReport).PreviewFormSettings.ZoomPercentage := 120;
 (Relatorio as TppReport).CachePages  := false;
 (Relatorio as TppReport).ThumbnailSettings.visible := false;
 (Relatorio as TppReport).ThumbnailSettings.enabled := false;
 (Relatorio as TppReport).OpenFile :=true;
 (Relatorio as TppReport).PreviewForm.WindowState := wsMaximized;

end;

function TDados.AddCaracter(Texto: string; Tamanho: Integer; Posicao: string; Carac: string): string;
var
  x: Integer;
begin
  Result := Texto;

  if Posicao = 'E' then
  begin
    while Length(Result) < Tamanho do
      Result := Carac + Result;
  end
  else
    if Posicao = 'D' then
    begin
      while Length(Result) < Tamanho do
        Result := Result + Carac;
    end
    else
    begin

      for x := 1 to ((Tamanho - Length(Texto)) div 2) do
        Result := Carac + Result;
      while Length(Result) < Tamanho do
        Result := Result + Carac;
    end;
end;

procedure Tdados.AddProcesso(Processo: String);
begin
  try
    frmAguarde.Gauge.Progress :=  frmAguarde.Gauge.Progress + 1;
    frmAguarde.Gauge.Repaint;
    frmAguarde.lblProcesso.Caption := Processo;
    frmAguarde.lblProcesso.Repaint;
  except
  end;
end;

procedure Tdados.ProcessoTerminado;
begin
  frmAguarde.lblMensagem.Caption := '';

  frmAguarde.Gauge.Visible := false;

  frmAguarde.Gauge.MaxValue := 0;

  frmAguarde.Gauge.Progress := 0;

  frmAguarde.lblProcesso.Caption := '';

  frmAguarde.Close;
end;

Function TDados.Escolher(Pergunta:String; Valores: Array of String):Integer;
var
  I : Integer;
begin
  If Application.FindComponent('EscolhaUniversal') = Nil then
    Application.CreateForm(TEscolhaUniversal, EscolhaUniversal);

  EscolhaUniversal.lbItens.Clear;
  
  EscolhaUniversal.lblPergunta.Caption := Pergunta;
  for I := 0 to length(Valores)-1 do
    EscolhaUniversal.lbItens.Items.add(Valores[I]);
  EscolhaUniversal.OK := False;

  EscolhaUniversal.ShowModal;

  if EscolhaUniversal.OK then
    result := EscolhaUniversal.Valor;
end;

Function TDados.DigitarValor(Pergunta:String; ValorPadrao:String = ''):String;
begin
  If Application.FindComponent('Valor_Universal') = Nil then
         Application.CreateForm(TValor_Universal, Valor_Universal);

  Valor_Universal.lblPergunta.Caption := Pergunta;
  Valor_Universal.edtValor.Text := ValorPadrao;
  Valor_Universal.OK := False;

  Valor_Universal.ShowModal;

  if Valor_Universal.OK then
    result := Valor_Universal.edtValor.Text;

end;

Function TDados.DigitarValorBD(Pergunta:String; Tabela: String; CodigoPadrao:Integer = 0;
                               CampoNome: String = 'Nome'; CampoCodigo: String = 'Codigo'; Ordem: String = ''; Where: String = ''):Integer;
begin
  If Application.FindComponent('Valor_Universal_BD') = Nil then
         Application.CreateForm(TValor_Universal_BD, Valor_Universal_BD);

  Valor_Universal_BD.lblPergunta.Caption := Pergunta;

  Valor_Universal_BD.qryConsulta.Close;

  Valor_Universal_BD.qryConsulta.SQL.Strings[
                Valor_Universal_BD.qryConsulta.SQL.IndexOf('-- Tabela2') + 1] := ' from '+ Tabela;

  Valor_Universal_BD.qryConsulta.SQL.Strings[
                Valor_Universal_BD.qryConsulta.SQL.IndexOf('-- Campo Codigo') + 1] :=  CampoCodigo;

  Valor_Universal_BD.qryConsulta.SQL.Strings[
                Valor_Universal_BD.qryConsulta.SQL.IndexOf('-- Campo Nome') + 1] :=  CampoNome;

  Valor_Universal_BD.qryConsulta.SQL.Strings[
                Valor_Universal_BD.qryConsulta.SQL.IndexOf('-- and') + 1] :=  Where;

  Valor_Universal_BD.qryConsulta.SQL.Strings[
                Valor_Universal_BD.qryConsulta.SQL.IndexOf('-- Ordem') + 1] :=  Ordem;

  Valor_Universal_BD.qryConsulta.Open;

  Valor_Universal_BD.edtValor.KeyValue := CodigoPadrao;
  Valor_Universal_BD.OK := False;

  Valor_Universal_BD.ShowModal;

  if Valor_Universal_BD.OK then
  begin
    try
      result := Valor_Universal_BD.edtValor.KeyValue;
    except
      result := -1;
    end;
    
  end;

end;

function TDados.UrlLogoEmpresa: String;
begin
  geral.SQL.Text := 'Select first 1 URLLOGO FROM TABEMPRESA';
  geral.Open;
  result := geral.fieldbyname('URLLOGO').Text;
  geral.Close;
end;

procedure TDados.IBDatabaseAfterConnect(Sender: TObject);
begin
//  try
//    Geral.SQL.Text := 'ALTER TABLE TABCONFIGURACOES ADD SEQUENCIAFECHAMENTOTURNO INTEIRO DEFAULT 0';
//    Geral.ExecSQL;
//    Geral.Transaction.CommitRetaining;
//  Except
//
//  end;
end;

procedure TDados.ImprimirRelatorios(Arquivo, NomeRelatorio: String; Parametros: array of String; Valores: array of String);
var
  i : integer;
begin
  {try
    qryEmpresa.Close;
    qryEmpresa.Open;
    qryRelatorios.Close;
    qryRelatorios.open;
  except
    application.MessageBox('Erro ao abrir consulta com banco de dados','ERRO',mb_OK+MB_ICONERROR);
    Abort;
  end;

  RvProject.Active := False;
  RvProject.ProjectFile := ExtractFilePath(Application.ExeName) + 'relatorios\'+Arquivo;
  RvProject.ExecuteReport(NomeRelatorio);
  
  // Parametros
  RvProject.SetParam('NomeRelatorio', NomeRelatorio);

  for i := 0 to length(Parametros) - 1 do
    RvProject.SetParam(Parametros[i], Valores[i]);

  RvProject.Execute;

  dados.Log(6, NomeRelatorio);}

end;

function TDados.InserirContrato(CodigoCliente:Integer;ProdutosContrato:array of TProdutosContrato;Orcamento:Integer;Agenda: Integer = 0):Integer;
var
  SQLPrincipal, SQLDetalhe : String;
  Codigo, Id, i : Integer;
begin
  try

    Geral.Close;
    Geral.SQL.Text := 'Select max(codigo) xCod from TABCONTRATO';
    Geral.Open;
    Codigo := Geral.FieldByName('xCod').AsInteger + 1;

    Geral.SQL.Text := 'INSERT INTO TABCONTRATO ( ' +
                      'CODIGO, '+
                      'DATA, '+
                      'DATARESERVA, '+
                      'HORARESERVA, '+
                      'CODIGOUSUARIO, '+
                      'CODIGOCLIENTE, '+
                      'CODIGOORCAMENTO, ' +
                      'OBSERVACOES, ' +
                      'CODIGOAGENDA, ' +
                      'CODIGOSITUACAO ) VALUES ('+
                      ':CODIGO, :DATA, :DATARESERVA, :HORARESERVA, '+
                      ':CODIGOUSUARIO, :CODIGOCLIENTE, :CODIGOORCAMENTO, :OBSERVACOES, :CODIGOAGENDA, :CODIGOSITUACAO)';
    Geral.ParamByName('CODIGO').AsInteger := Codigo;
    Geral.ParamByName('DATA').AsDateTime := Date;
    Geral.ParamByName('DATARESERVA').AsDateTime := Date;
    Geral.ParamByName('HORARESERVA').AsDateTime := Time;
    Geral.ParamByName('CODIGOUSUARIO').AsInteger :=  untDados.CodigoUsuarioCorrente;
    Geral.ParamByName('CODIGOCLIENTE').AsInteger := CodigoCliente;
    Geral.ParamByName('CODIGOORCAMENTO').AsInteger := Orcamento;
    Geral.ParamByName('CODIGOAGENDA').AsInteger := Agenda;
    Geral.ParamByName('CODIGOSITUACAO').AsInteger := 1;
    Geral.ExecSql;
    Geral.Transaction.CommitRetaining;



    for i:= 0 to length(ProdutosContrato) - 1 do
    begin

      Geral.SQL.Text := 'Select max(id) xid from TABCONTRATODETALHE WHERE CODIGO ='+intToStr(Codigo);
      Geral.Open;
      Id := Geral.FieldByName('xid').AsInteger + 1;

      Geral.SQL.Text := 'INSERT INTO TABCONTRATODETALHE ( ' +
                        'CODIGO, '+
                        'ID, '+
                        'CODIGOPRODUTO, '+
                        'VALOR) VALUES ('+
                        ':CODIGO, :ID, :CODIGOPRODUTO, :VALOR)';
      Geral.ParamByName('CODIGO').AsInteger := Codigo;
      Geral.ParamByName('ID').AsInteger := Id;
      Geral.ParamByName('CODIGOPRODUTO').AsInteger := ProdutosContrato[i].CodigoProduto;
      Geral.ParamByName('VALOR').AsCurrency := ProdutosContrato[i].Valor;
      Geral.ExecSql;

      Geral.Transaction.CommitRetaining;
    end;

    result := Codigo;

  except
    on E:Exception do
      application.MessageBox(Pchar('Erro 2121.'+#13+E.message),'ERRO',mb_OK+MB_ICONERROR);
  end;
end;

function TDados.InserirOrcamento(CodigoCliente:Integer;ProdutosContrato:array of TProdutosContrato;Pedido:Integer;Agenda: Integer = 0):Integer;
var
  SQLPrincipal, SQLDetalhe : String;
  Codigo, Id, i : Integer;
begin
  try

    Geral.Close;
    Geral.SQL.Text := 'Select max(codigo) xCod from  TABORCAMENTO';
    Geral.Open;
    Codigo := Geral.FieldByName('xCod').AsInteger + 1;

    Geral.SQL.Text := 'insert into TABORCAMENTO ' +
                      '  (CODIGO, CODIGOCLIENTE, CODIGOPEDIDO, CODIGOUSUARIO, ' +
                      '   DATACADASTRO, CODIGOAGENDA) ' +
                      'values  ' +
                      '  (:CODIGO, :CODIGOCLIENTE, :CODIGOPEDIDO, :CODIGOUSUARIO, ' +
                      '   :DATACADASTRO, :CODIGOAGENDA)';
    Geral.ParamByName('CODIGO').AsInteger := Codigo;
    Geral.ParamByName('DATACADASTRO').AsDateTime := Date;
    Geral.ParamByName('CODIGOAGENDA').AsInteger := Agenda;
    Geral.ParamByName('CODIGOUSUARIO').AsInteger :=  untDados.CodigoUsuarioCorrente;
    Geral.ParamByName('CODIGOCLIENTE').AsInteger := CodigoCliente;
    Geral.ParamByName('CODIGOPEDIDO').AsInteger := Pedido;
    Geral.ExecSql;
    Geral.Transaction.CommitRetaining;  

    for i:= 0 to length(ProdutosContrato) - 1 do
    begin

      Geral.SQL.Text := 'Select max(id) xid from TABORCAMENTODETALHE WHERE CODIGO ='+intToStr(Codigo);
      Geral.Open;
      Id := Geral.FieldByName('xid').AsInteger + 1;

      Geral.SQL.Text := 'INSERT INTO TABORCAMENTODETALHE ( ' +
                        'CODIGO, '+
                        'ID, '+
                        'CODIGOPRODUTO, '+
                        'VALOR) VALUES ('+
                        ':CODIGO, :ID, :CODIGOPRODUTO, :VALOR)';
      Geral.ParamByName('CODIGO').AsInteger := Codigo;
      Geral.ParamByName('ID').AsInteger := Id;
      Geral.ParamByName('CODIGOPRODUTO').AsInteger := ProdutosContrato[i].CodigoProduto;
      Geral.ParamByName('VALOR').AsCurrency := ProdutosContrato[i].Valor;
      Geral.ExecSql;

      Geral.Transaction.CommitRetaining;
    end;

    result := Codigo;

  except
    on E:Exception do
      application.MessageBox(Pchar('Erro 2121.'+#13+E.message),'ERRO',mb_OK+MB_ICONERROR);
  end;
end;

function TDados.InserirFinanceiro(CodigoCliente, CodigoFormaPagamento,
  Tipo: Integer; DataEmissao, DataVencimento: TDate; CodigoSituacao: Integer;
  Valor: Currency;Observacoes:String;CodigoContrato:Integer=0;GerarPrevisao:Boolean=False): integer;
var
  Codigo, Id, i, cCodigoSituacao : Integer;
begin
  try

    Geral.Close;
    Geral.SQL.Text := 'Select max(codigo) xCod from TABFINANCEIRO';
    Geral.Open;
    Codigo := Geral.FieldByName('xCod').AsInteger + 1;

    Geral.SQL.Text := 'INSERT INTO TABFINANCEIRO ( ' +
                      'CODIGO, '+
                      'DATA, '+
                      'DATAEMISSAO, '+
                      'CODIGOCLIENTE, '+
                      'TIPO, '+
                      'CODIGOFORMAPAGAMENTO, '+
                      'OBSERVACOES, '+
                      'CODIGOUSUARIO ) VALUES ('+
                      ':CODIGO, :DATA, :DATAEMISSAO, :CODIGOCLIENTE, '+
                      ':TIPO, :CODIGOFORMAPAGAMENTO, :OBSERVACOES, :CODIGOUSUARIO)';
    Geral.ParamByName('CODIGO').AsInteger := Codigo;
    Geral.ParamByName('DATA').AsDateTime := Date;
    Geral.ParamByName('DATAEMISSAO').AsDateTime := DataEmissao;
    Geral.ParamByName('CODIGOCLIENTE').AsInteger := CodigoCliente;
    Geral.ParamByName('TIPO').AsInteger :=  Tipo;
    Geral.ParamByName('CODIGOFORMAPAGAMENTO').AsInteger := CodigoFormaPagamento;
    Geral.ParamByName('OBSERVACOES').Text := Observacoes;
    Geral.ParamByName('CODIGOUSUARIO').AsInteger := untDados.CodigoUsuarioCorrente;
    Geral.ExecSql;
    Geral.Transaction.CommitRetaining;

    if CodigoSituacao = 0 then
    begin
      Geral.SQL.Text := 'SELECT CODIGO FROM TABSITUACAOPRODUTO WHERE APLICACAO IN(5,99) AND OPERACAO = 0';
      Geral.Open;

      CodigoSituacao := Geral.FieldByName('CODIGO').AsInteger;
    end;

    if not GerarPrevisao then
    begin

      Geral2.Close;
      Geral2.SQL.Text := 'SELECT * FROM TABFORMAPAGAMENTOPARCELAS WHERE CODIGOFORMAPAGAMENTO =0'+intToStr(CodigoFormaPagamento);
      Geral2.Open;

      While not Geral2.Eof do
      begin

        Geral.SQL.Text := 'INSERT INTO TABFINANCEIRODETALHE ( ' +
                          'CODIGO, '+
                          'PARCELA, '+
                          'DATAVENCIMENTO, '+
                          'CODIGOSITUACAO, '+
                          'VALOR, '+
                          'CODIGOTIPODOCUMENTO ) VALUES ('+
                          ':CODIGO, :PARCELA, :DATAVENCIMENTO, :CODIGOSITUACAO, :VALOR, :CODIGOTIPODOCUMENTO)';
        Geral.ParamByName('CODIGO').AsInteger               := Codigo;
        Geral.ParamByName('PARCELA').AsInteger              := Geral2.FieldByName('PARCELA').AsInteger;
        Geral.ParamByName('DATAVENCIMENTO').AsDateTime      := DataVencimento + Geral2.FieldByName('DIASPARAVENCER').AsInteger;
        Geral.ParamByName('CODIGOSITUACAO').AsInteger       := CodigoSituacao;
        Geral.ParamByName('VALOR').AsCurrency               := Valor * (Geral2.FieldByName('PORCENTAGEM').AsFloat/100);
        Geral.ParamByName('CODIGOTIPODOCUMENTO').AsInteger  := Geral2.FieldByName('CODIGOTIPODOCUMENTO').AsInteger;
        Geral.ExecSql;

        Geral2.Next;

      end;

    end
    else
    begin

      Geral.SQL.Text := 'Select max(PARCELA) xid from TABFINANCEIRODETALHE WHERE CODIGO ='+intToStr(Codigo);
      Geral.Open;
      Id := Geral.FieldByName('xid').AsInteger + 1;

      Geral2.Close;
      Geral2.SQL.Text := 'select D.* from TABCONTRATOPREVISAO D where D.CODIGO='+intToStr(CodigoContrato)+' order by D.TIPO';
      Geral2.Open;

      While not Geral2.Eof do
      begin

        Geral3.Close;
        Geral3.SQL.Text := 'SELECT * FROM TABFORMAPAGAMENTOPARCELAS WHERE CODIGOFORMAPAGAMENTO =0'+Geral2.FieldByName('CODIGOFORMAPAGAMENTO').Text;
        Geral3.Open;

        DataVencimento := Geral2.FieldByName('DATA').AsDateTime;
        Valor := Geral2.FieldByName('VALOR').AsCurrency;

        While not Geral3.Eof do
        begin

          Geral.SQL.Text := 'INSERT INTO TABFINANCEIRODETALHE ( ' +
                            'CODIGO, '+
                            'PARCELA, '+
                            'DATAVENCIMENTO, '+
                            'CODIGOSITUACAO, '+
                            'VALOR, '+
                            'CODIGOTIPODOCUMENTO ) VALUES ('+
                            ':CODIGO, :PARCELA, :DATAVENCIMENTO, :CODIGOSITUACAO, :VALOR, :CODIGOTIPODOCUMENTO)';
          Geral.ParamByName('CODIGO').AsInteger               := Codigo;
          Geral.ParamByName('PARCELA').AsInteger              := id;
          Geral.ParamByName('DATAVENCIMENTO').AsDateTime      := DataVencimento + Geral3.FieldByName('DIASPARAVENCER').AsInteger;
          Geral.ParamByName('CODIGOSITUACAO').AsInteger       := CodigoSituacao;
          Geral.ParamByName('VALOR').AsCurrency               := Valor * (Geral3.FieldByName('PORCENTAGEM').AsFloat/100);
          Geral.ParamByName('CODIGOTIPODOCUMENTO').AsInteger  := Geral3.FieldByName('CODIGOTIPODOCUMENTO').AsInteger;
          Geral.ExecSql;

          inc(Id);

          Geral3.Next;

        end;
        
        Geral2.Next;
        
      end;

    end;

    Geral.Transaction.CommitRetaining;

    result := Codigo;

  except
    on E:Exception do
      application.MessageBox(Pchar('Erro 47147.'+#13+E.message),'ERRO',mb_OK+MB_ICONERROR);
  end;
end;

procedure TDados.InserirHistorico(CodigoQuestionario, CodigoOrigem, Tipo, CodigoSituacao: Integer;
  NomeSituacao: String; DataVigencia: String; HoraVigencia: String);
var
  cCodigo, cCodigoPerfil : Integer;
  cNomePerfil : String;
begin

  try

    qryHistoricoSituacao.Close;
    qryHistoricoSituacao.SQL.Strings[qryHistoricoSituacao.SQL.IndexOf('--and')+1] := 'and CODIGOORIGEM =0' + IntToStr(CodigoOrigem);
    qryHistoricoSituacao.Open;

    Geral.Close;
    Geral.SQL.Text := 'select operacao from tabsituacaoproduto where codigo ='+intToStr(CodigoSituacao);
    Geral.Open;

    cNomePerfil := '';
    
    if Geral.FieldByName('operacao').AsInteger = 2 then
    begin

      cCodigoPerfil := dados.DigitarValorBD('Selecione o perfil para a transferência do produto','TABPERFIL');

      Geral.Close;
      Geral.SQL.Text := 'select nome from tabperfil where codigo ='+intToStr(cCodigoPerfil);
      Geral.Open;

      cNomePerfil := 'Transferido para: Id ' +intToStr(cCodigoPerfil) +' Nome '+ Geral.FieldByName('nome').AsString;
    
    end;

    if not qryHistoricoSituacao.IsEmpty then
    begin
    
      qryHistoricoSituacao.Last;

      qryHistoricoSituacao.Edit;
      qryHistoricoSituacaoDATAFIM.AsDateTime := Date;
      qryHistoricoSituacaoHORAFIM.AsDateTime := Time;
      qryHistoricoSituacao.Post;

    end;

    Geral.Close;
    Geral.SQL.Text := 'select GEN_ID(GEN_HISTORICO,1) novocodigo from rdb$database';
    Geral.Open;

    cCodigo := Geral.fieldbyname('novocodigo').AsInteger;

    qryHistoricoSituacao.Insert;
    qryHistoricoSituacaoID.AsInteger                    := cCodigo;
    qryHistoricoSituacaoCODIGOORIGEM.AsInteger          := CodigoOrigem;
    qryHistoricoSituacaoCODIGOQUESTIONARIO.AsInteger    := CodigoQuestionario;
    qryHistoricoSituacaoTIPO.AsInteger                  := Tipo;
    qryHistoricoSituacaoDATA.AsDateTime                 := Date;
    qryHistoricoSituacaoHORA.AsDateTime                 := Time;
    qryHistoricoSituacaoCODIGOSITUACAO.AsInteger        := CodigoSituacao;
    qryHistoricoSituacaoDESCRICAOSITUACAO.Text          := NomeSituacao;
    qryHistoricoSituacaoDATAFIM.Text                    := DataVigencia;
    qryHistoricoSituacaoHORAFIM.Text                    := HoraVigencia;
    qryHistoricoSituacaoCODIGOUSUARIO.AsInteger         := untdados.CodigoUsuarioCorrente;
    qryHistoricoSituacaoHISTORICOTRANSFERENCIA.AsString := cNomePerfil;

    qryHistoricoSituacao.Post;

    IBTransaction.CommitRetaining;

  except
    on E:Exception do
      application.MessageBox(Pchar('Erro 15248.'+#13+E.message),'ERRO',mb_OK+MB_ICONERROR);
  end;

end;


function TDados.InserirOrdemServico(CodigoPrestador, Servico: Integer; ProdutosContrato: array of TProdutosContrato; Observacoes : String = '';CodigoOrdemServico:Integer=0): Integer;
var
  Codigo, i, id : Integer;

begin
  try

    if CodigoOrdemServico = 0 then
    begin

      Geral.Close;
      Geral.SQL.Text := 'Select max(codigo) xCod from TABOS';
      Geral.Open;
      Codigo := Geral.FieldByName('xCod').AsInteger + 1;

      Geral.SQL.Text := 'INSERT INTO TABOS ( ' +
                        'CODIGO, '+
                        'DATA, '+
                        'CODIGOUSUARIO, '+
                        'CODIGOPERFIL, '+
                        'CODIGOSERVICO, ' +
                        'OBSERVACOES, ' +
                        'SITUACAO) VALUES ('+
                        ':CODIGO, :DATA, :CODIGOUSUARIO, :CODIGOPERFIL, :CODIGOSERVICO, :OBSERVACOES, 1)';
      Geral.ParamByName('CODIGO').AsInteger := Codigo;
      Geral.ParamByName('DATA').AsDateTime := Date;
      Geral.ParamByName('CODIGOUSUARIO').AsInteger :=  untDados.CodigoUsuarioCorrente;
      Geral.ParamByName('CODIGOPERFIL').AsInteger := CodigoPrestador;
      Geral.ParamByName('CODIGOSERVICO').AsInteger := Servico;
      Geral.ParamByName('OBSERVACOES').Text := Observacoes;
      Geral.ExecSql;
      Geral.Transaction.CommitRetaining;

    end
    else
      Codigo := CodigoOrdemServico;

    for i:= 0 to length(ProdutosContrato) - 1 do
    begin

      Geral.SQL.Text := 'Select max(id) xid from TABOSDETALHE WHERE CODIGOOS ='+intToStr(Codigo);
      Geral.Open;
      Id := Geral.FieldByName('xid').AsInteger + 1;

      Geral.SQL.Text := 'INSERT INTO TABOSDETALHE ( ' +
                        'CODIGOOS, '+
                        'ID, '+
                        'CODIGOPRODUTO, '+
                        'VALORSERVICO) VALUES ('+
                        ':CODIGOOS, :ID, :CODIGOPRODUTO, :VALORSERVICO)';
      Geral.ParamByName('CODIGOOS').AsInteger := Codigo;
      Geral.ParamByName('ID').AsInteger := Id;
      Geral.ParamByName('CODIGOPRODUTO').AsInteger := ProdutosContrato[i].CodigoProduto;
      Geral.ParamByName('VALORSERVICO').AsCurrency := ProdutosContrato[i].Valor;
      Geral.ExecSql;

      Geral.Transaction.CommitRetaining;
    end;

    result := Codigo;

  except
    on E:Exception do
      application.MessageBox(Pchar('Erro 4571.'+#13+E.message),'ERRO',mb_OK+MB_ICONERROR);
  end;
end;

Function TDados.NumeroLicencas(Chave, NomeComunidade: String): Integer;
var
  i: Integer;
  SerialComunidade, Modulo: Real;
begin
  Result := -1;

  Modulo := 1;
  for I := 1 to 9 do
    Modulo := Modulo * I;

  SerialComunidade := StrToFloat(Copy(Transcrever(RemoveCaracter(Trim(NomeComunidade),' ')),1,15));

  for I := 1 to 9 do
  begin
    if ((StrToFloat(Chave) - SerialComunidade) / I) = Modulo then
    begin
      Result := (I+1) * 1000;
      Break;
    end;
  end;
end;

procedure TDados.apontamento;
Var
  Registro : TRegistry;
  Local : boolean;
  IP,
  Path_DB,
  user_name ,
  password,
  NomeComunidade,
  ChaveLiberacao,
  chLimiteDizimistas : string;
Begin

  Registro := TRegistry.Create;

  Registro.RootKey := HKEY_CURRENT_USER;

  if not Registro.KeyExists('\Software\SysLocar') then
  begin
    Registro.OpenKey('\Software\SysLocar\BANCO_DE_DADOS', True);
    Registro.WriteString('LOCAL'        ,'SIM');
    Registro.WriteString('IP_SERVIDOR'  ,'');
    Registro.WriteString('PATH_SERVIDOR',ExtractFilePath(Application.ExeName) +'bd\'+ 'SYSLOCAR' +'.FDB');
    Registro.WriteString('USERNAME'     ,'SYSDBA');
    Registro.WriteString('PASSWORD'     ,'masterkey');
    Registro.WriteString('PORTA_IMPRESSORA'     ,'LPT1');
    Registro.CloseKey;

    Registro.OpenKey('\Software\SysLocar\REGISTRO', True);
    Registro.WriteString('NOME_EMPRESA','SEM REGISTRO');
    Registro.WriteString('CHAVE_LIBERACAO','');
    Registro.WriteString('LIMITE_CONTRATOS','');
    Registro.CloseKey;
  end;

  Registro.OpenKey('\Software\SysLocar\BANCO_DE_DADOS', False);
  Local       := Registro.ReadString('LOCAL') <> 'NAO';
  IP          := Registro.ReadString('IP_SERVIDOR');
  Path_DB     := Registro.ReadString('PATH_SERVIDOR');
  user_name   := Registro.ReadString('USERNAME');
  password    := Registro.ReadString('PASSWORD');
  PORTA_IMPRESSORA := Registro.ReadString('PORTA_IMPRESSORA');
  Registro.CloseKey;

  Registro.OpenKey('\Software\SysLocar\REGISTRO', False);
  NomeComunidade := Registro.ReadString('NOME_EMPRESA');
  ChaveLiberacao := Registro.ReadString('CHAVE_LIBERACAO');
  chLimiteDizimistas := Registro.ReadString('LIMITE_CONTRATOS');
  Registro.CloseKey;

  Registro.Free;

//  if not VerificaRegistro(NomeComunidade,ChaveLiberacao) then
//  begin
//    Application.MessageBox('Versão não Registrada!'+#13+
//                           'Para Registrar Ligue para 27 3328-3286'+#13+
//                           'ou no site www.softeweb.com.br.', 'Registro', MB_OK + MB_ICONINFORMATION);
//    Application.Terminate;
//  end;

  if Path_DB = '' then
    Path_DB := ExtractFilePath(Application.ExeName) +'bd\'+ 'SYSLOCAR' +'.FDB';

  If Not Local Then
    Path_DB := IP+':'+Path_DB
  Else
  Begin
    //Testa se o banco existe
//    If Not FileExists(Path_DB) Then
//    Begin
//      ShowMessage('Banco de Dados não encontrato no caminho indicado na chave de registro');
//      Application.Terminate;
//    End;
  End;

  IBDatabase.Connected := False;
  IBTransaction.Active:= False;
  IBDatabase.DatabaseName := Path_DB;
  IBDatabase.Params.Clear;
  IBDatabase.Params.Add('user_name=' + user_name);
  IBDatabase.Params.Add('password=' + password);

  IBDatabase.Connected := true;
  IBTransaction.Active:= true;

End;

Function TDados.VerificaRegistro(NomeComunidade, ChaveLiberacao: String): Boolean;
var
  SerialComunidade, SerialHD, Serial : Real;
begin

  if NomeComunidade = '' then
  begin
    result := False;
    Exit;
  end;

  SerialComunidade := StrToFloat(Copy(Transcrever(RemoveCaracter(Trim(NomeComunidade),' ')),1,15));
  SerialHD := StrToFloat(Transcrever(SerialNumHD(copy(ExtractFilePath(Application.ExeName),1,1))));

  Serial :=  (((SerialComunidade + SerialHD) / 2) * 10) / 4;

  result := FormatFloat('0',Trunc(Serial)) = ChaveLiberacao;
end;

procedure TDados.DataModuleCreate(Sender: TObject);
begin
  Raquel := CreateOLEObject ('SAPI.SpVoice');
//  apontamento;
end;

procedure TDados.BackupSeguranca;
var
  List: TStringList;
  NomeBanco,
  Arquivo: String;
begin
  List := TStringList.Create;

  IBDatabase.Connected := False;

  NomeBanco := IBDatabase.DatabaseName;

  List.Add(NomeBanco);

  if not DirectoryExists(ExtractFilePath(Application.ExeName)+'\Auto-Backup\') then
    CreateDir(Pchar(ExtractFilePath(Application.ExeName)+'\Auto-Backup\'),);

  Arquivo := ExtractFilePath(Application.ExeName)+'\Auto-Backup\'+FormatDateTime('DD', Date)+
                                                         FormatDateTime('MM', Date)+
                                                         FormatDateTime('YYYY', Date)+'.bck';

  BackupFile1.Backup(List, Arquivo);
  BackupFile1.Stop;

  List.Destroy;
end;

procedure Tdados.Log(Tipo: Integer; Texto: String);
begin
  try
    qryLog.Insert;
    case tipo of
      1: qryLogTEXTO.Text := 'Abriu Janela - ' + Texto;
      2: qryLogTEXTO.Text := 'Efetuou Consulta - ' + Texto;
      3: qryLogTEXTO.Text := 'Inseriu Dados - ' + Texto;
      4: qryLogTEXTO.Text := 'Alterou Dados - ' + Texto;
      5: qryLogTEXTO.Text := 'Excluiu Dados - ' + Texto;
      6: qryLogTEXTO.Text := 'Imprimiu Relatório - ' + Texto;
      7: qryLogTEXTO.Text := 'Efetivou - ' + Texto;
    end;
    qryLog.Post;
  except
  end;
end;

procedure TDados.qryLogNewRecord(DataSet: TDataSet);
begin
  Geral.Close;
  Geral.sql.Text := 'select max(id) as ultimocodigo from tabLog';
  Geral.Open;
  qryLogID.Value := geral.FieldByName('ultimocodigo').AsInteger + 1;
  qryLogCODIGOUSUARIO.AsInteger := CodigoUsuarioCorrente;
  qryLogDATA.AsDateTime := Date;
  qryLogHORA.AsDateTime := Time;
end;

procedure TDados.qryComunidadeBeforeOpen(DataSet: TDataSet);
begin
  qryComunidade.SQL.Strings[qryComunidade.SQL.IndexOf('where 1=1')+1] := 'and E.codigo = ' + IntToStr(CodigoComunidadeCorrente);
end;

procedure TDados.qryLogAfterPost(DataSet: TDataSet);
begin
  IBTransaction.CommitRetaining;
end;

Function TDados.Word_StringReplace(ADocument: TFileName; SearchString, ReplaceString: Array of string; Flags: TWordReplaceFlags): Boolean;
const wdFindContinue = 1;
      wdReplaceOne = 1;
      wdReplaceAll = 2;
      wdDoNotSaveChanges = 0;
var WordApp: OLEVariant;
    i : integer;
begin
  Result := False;
  if not FileExists(ADocument) then begin
    ShowMessage('O Documento '+ADocument+' não foi encontrado!');
    ProcessoTerminado;
    Exit;
  end;

  try
    WordApp := CreateOLEObject('Word.Application');
  except
    on E: Exception do
    begin
      ProcessoTerminado;
      E.Message := 'Instale o Microsoft Word!';
      raise;
    end;
  end;

  try
    WordApp.Visible := False;
    WordApp.Documents.Open(ADocument);

    for i := 0 to length(SearchString) - 1  do
    begin
      AddProcesso(SearchString[i]);
      WordApp.Selection.Find.ClearFormatting;
      WordApp.Selection.Find.Text := SearchString[i];
      WordApp.Selection.Find.Replacement.Text := ReplaceString[i];
      WordApp.Selection.Find.Forward := True;
      WordApp.Selection.Find.Wrap := wdFindContinue;
      WordApp.Selection.Find.Format := False;
      WordApp.Selection.Find.MatchCase := wrfMatchCase in Flags;
      WordApp.Selection.Find.MatchWholeWord := False;
      WordApp.Selection.Find.MatchWildcards := wrfMatchWildcards in Flags;
      WordApp.Selection.Find.MatchSoundsLike := False;
      WordApp.Selection.Find.MatchAllWordForms := False;
      if wrfReplaceAll in Flags then
        WordApp.Selection.Find.Execute(Replace := wdReplaceAll)
      else
        WordApp.Selection.Find.Execute(Replace := wdReplaceOne);
    end;

    WordApp.ActiveDocument.SaveAs(ADocument);
    Result := True;
    WordApp.ActiveDocument.Close(wdDoNotSaveChanges);
  finally
    WordApp.Quit;
    WordApp := Unassigned;
  end;
end;

Function TDados.AbrirDocumentoWord(ADocument: TFileName):Boolean;
var WordApp: OLEVariant;
begin

  try
    WordApp := CreateOLEObject('Word.Application');
  except
    on E: Exception do
    begin
      E.Message := 'Instale o Microsoft Word!';
      raise;
    end;
  end;

  WordApp.Visible := True;
  WordApp.Documents.Open(ADocument);

  result := True;

end;

procedure TDados.qryRelParcFinanceiroCalcFields(DataSet: TDataSet);
var Dias: Variant;
begin
  if qryRelParcFinanceiroTIPO.Value = 1 then
    qryRelParcFinanceiroDESCRICAOTELA.Text := 'Curso'
  else
    qryRelParcFinanceiroDESCRICAOTELA.Text := 'Material Didático';

  if not RelParcFinanceiroLiquidados then
  begin
    IF qryRelParcFinanceiroVENCIMENTO.AsDateTime > DATE THEN
      Dias := qryRelParcFinanceiroVENCIMENTO.AsDateTime - DATE
    ELSE
      Dias := DATE - qryRelParcFinanceiroVENCIMENTO.AsDateTime;

      qryRelParcFinanceiroDIAS.Value := Dias;
  end
  else
    qryRelParcFinanceiroDIAS.IsNull;
end;

function TDados.RetornaSituacaoProduto(DataInicio, DataFim: TDateTime; Produto: Integer): String;
begin


  Geral.Close;
  Geral.SQL.Text := 'SELECT * '+
                    '  FROM VIEWHISTORICOPRODUTO '+
                    ' WHERE CODIGOPRODUTO =0'+intToStr(Produto)+
                    '   AND (('+QuotedStr(FormatDateTime('MM/DD/YYYY HH:NN:SS',DataInicio)) + ' BETWEEN DATAHORAINICIO and DATAHORAFINAL) OR ' +
                    '        ('+QuotedStr(FormatDateTime('MM/DD/YYYY HH:NN:SS',DataFim)) + ' BETWEEN DATAHORAINICIO and DATAHORAFINAL)) ';
  Geral.Open;


  if not Geral.IsEmpty then
    Result := 'Produto '+intToStr(Produto)+' está bloqueado no período informado! '+
              Trim(Geral.FieldByName('NOMETIPO').AsString)+': '+Trim(Geral.FieldByName('CODIGOREGISTRO').AsString)
  else
    Result := ''

end;

procedure Tdados.ListaUniversal(Titulo,
                                NomeCampoCodigo,
                                FieldCampoCódigo,
                                NomeCampoNome,
                                FieldCampoNome,
                                NomeCampoExtra,
                                FieldCampoExtra,
                                Sql: String;
                                ImprimeCampoExtra: Boolean = False;
                                CampoExtraMoeda: Boolean = False;
                                CampoExtraData: Boolean = False);
begin
  qryLista.Close;
  qryLista.SQL.Text := Sql;
  qryLista.Open;

  lblNomeCodigo.Caption := NomeCampoCodigo;
  CampoCodigo.DataField := FieldCampoCódigo;

  lblNomeNome.Caption := NomeCampoNome;
  CampoNome.DataField := FieldCampoNome;

  if ImprimeCampoExtra then
  begin
    lblCampoExtra.Caption := NomeCampoExtra;
    CampoExtra.DataField := FieldCampoExtra;
    if CampoExtraMoeda then
    begin
      CampoExtra.DisplayFormat := '#,##0.00';
      CampoExtra.TextAlignment :=  direita.TextAlignment;
      lblCampoExtra.TextAlignment :=  direita.TextAlignment;
    end
    else
    begin
      if CampoExtraData then
        CampoExtra.DisplayFormat := 'dd/mm/yyyy'
      else
        CampoExtra.DisplayFormat := '';
      CampoExtra.TextAlignment :=  esquerda.TextAlignment;
      lblCampoExtra.TextAlignment :=  esquerda.TextAlignment;
    end
  end;

  lblCampoExtra.Visible := ImprimeCampoExtra;
  CampoExtra.Visible := ImprimeCampoExtra;

  lblNomeRelatorio.Caption :=  Titulo;

  rbiLista.Print;
end;

procedure Tdados.Fala(Texto: String; Valume: Integer = 100);
begin
  if Texto = '' then Exit;
  Raquel.Volume := Valume;//só é necessário caso queira reduzir ou aumentar o volume
  Raquel.Speak(Texto,0);
end;

procedure Tdados.Saudacao;
var
  hora1,
  hora2,
  hora3,
  hora4: TTime;
  Texto: String;
begin
  hora1 := Strtotime('18:00:00');
  hora2 := Strtotime('23:59:59');
  hora3 := Strtotime('00:00:00');
  hora4 := Strtotime('00:04:59');
  if ((time >= hora1) and (time <= hora2)) or
     ((time >= hora3) and (time <= hora4)) then
    Texto := 'Boa noite ';

  hora1 := Strtotime('05:00:00');
  hora2 := Strtotime('11:59:59');
  if ((time >= hora1) and (time <= hora2)) then
    Texto := 'Bom dia ';

  hora1 := Strtotime('12:00:00');
  hora2 := Strtotime('17:59:59');
  if ((time >= hora1) and (time <= hora2)) then
    Texto := 'Boa tarde ';

  geral.sql.Text := 'Select D.Nome, D.NASCIMENTO from tabdizimista d '+#13+
                    'left join tabusuarios u on u.codigoservo = d.codigo '+#13+
                    'where u.codigo = '+IntToStr(CodigoUsuarioCorrente);
  geral.open;
    Texto := Texto + Copy(geral.fieldbyname('Nome').text,1,pos(' ',geral.fieldbyname('Nome').text)-1) + '!';
    if FormatDateTime('dd/mm',geral.fieldbyname('NASCIMENTO').AsDateTime) = FormatDateTime('dd/mm',Date)  then
      Texto := Texto + ' Feliz Aniversário!';
  geral.Close;

  Fala(Texto);

end;

procedure TDados.SelecionarModeloPainel(
  grdPedidosDBTableView1: TcxGridDBTableView; Codigo: Integer);
var
  ArquivoRel : TStringList;
  Caminho : String;
begin
  try

    if grdPedidosDBTableView1.DataController.RecordCount > 0 then
    begin

      Geral.Close;
      Geral.SQL.Text := 'SELECT * FROM TABPAINEIS WHERE CODIGO = '+intToStr(Codigo);
      Geral.Open;

      Caminho := ExtractFilePath(Application.ExeName)+'\Paineis';

      if not DirectoryExists(Caminho) then
        ForceDirectories(Caminho);

      Caminho := Caminho +'\'+ Geral.FieldByName('NOMEARQUIVO').AsString;

      if not(FileExists(Caminho)) then
      begin
        ArquivoRel := TStringList.Create;
        ArquivoRel.Add(Trim(Geral.FieldByName('DETALHEARQUIVO').AsString));
        ArquivoRel.SaveToFile(Caminho);
      end;

      grdPedidosDBTableView1.DataController.Refresh;

      grdPedidosDBTableView1.RestoreFromIniFile(Caminho, False, False, [gsoUseFilter, gsoUseSummary]);

    end
    else
      Application.MessageBox('Grid sem registros!', '', mb_ok+MB_ICONEXCLAMATION);

  except
    on e:Exception do
      Application.MessageBox('Erro ao exibir relatório!', '', mb_ok+MB_ICONEXCLAMATION);
  end;
end;

function Tdados.Mensagem : String;
var
  Num: Integer;
begin
  randomize;
  num := Round(random(94));
  geral.sql.Text := 'Select mensagen from mensagens where id = '+IntToStr(num);
  geral.open;
    result := geral.FieldByName('mensagen').AsString;
  geral.Close;
end;


{ TMycxGridFilterRow }

procedure TMycxGridFilterRow.SetValue(Index: Integer;
  const Value: Variant);
var
  AGridView: TcxGridTableView;
  AColumn: TcxGridColumn;
  AValue: Variant;
begin
  AGridView := GridView;
  TcxGridTableControllerAccess(AGridView.Controller).KeepFilterRowFocusing := True;
  try
    AColumn := AGridView.Columns[Index];
    if VarIsSoftNull(Value) then
      AColumn.DataBinding.Filtered := False
    else
    begin
      DataController.Filter.BeginUpdate;
      try
        DataController.Filter.Active := True;
        if Copy(VarToStr(Value),1,1) <> '%' then
          AValue := '%' + Value
        else
          AValue := Value;
        AColumn.DataBinding.AddToFilter(nil,
          GetFilterOperatorKind(AValue, True), AValue,
          GetDisplayTextForValue(Index, AValue), True);
      finally
        DataController.Filter.EndUpdate;
      end;
    end;
  finally
    TcxGridTableControllerAccess(AGridView.Controller).KeepFilterRowFocusing := False;
  end;
end;

{ TMycxGridViewData }

function TMycxGridViewData.GetFilterRowClass: TcxGridFilterRowClass;
begin
  Result := TMycxGridFilterRow;
end;

{ TMycxGridDBTableView }

function TMycxGridDBTableView.GetViewDataClass: TcxCustomGridViewDataClass;
begin
  Result := TMycxGridViewData;
end;

procedure Tdados.ImprimirPDF(RepBui: TppReport; NArquivo: String);

begin
  try
    RepBui.TextFileName := NArquivo;
    RepBui.DeviceType := 'PDF';
    RepBui.AllowPrintToFile := True;
    RepBui.ShowPrintDialog := False;
    RepBui.SaveAsTemplate := True;
    RepBui.SavePrinterSetup := True;
    RepBui.Print;
  except
    on E: Exception do
      Application.MessageBox('Erro ao exibir criar PDF!', '', mb_ok+MB_ICONEXCLAMATION);
  end;
end;

end.
