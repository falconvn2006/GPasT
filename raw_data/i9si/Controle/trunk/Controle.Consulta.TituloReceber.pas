unit Controle.Consulta.TituloReceber;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, Controle.Consulta, Data.DB, Data.Win.ADODB,
  Datasnap.Provider, Datasnap.DBClient, uniGUIBaseClasses, uniImageList,
  uniPanel, uniBasicGrid, uniDBGrid, uniButton, uniEdit, uniGUIApplication,
  uniLabel, uniChart, uniHTMLFrame, uniCheckBox, uniGroupBox, uniRadioGroup,
  uniTimer, Vcl.Imaging.pngimage, uniImage, uniMemo, uniScreenMask, 
  uniMainMenu,
  REST.Response.Adapter, system.StrUtils, frxClass,
  frxDBSet, frxExportPDF, uniDBEdit, uniMultiItem, uniComboBox, uniBitBtn,
  uniMenuButton,  ShellApi, frxExportBaseDialog,
  uniGridExporters,   Controle.Cadastro.BaixarTituloReceber,
  uniDateTimePicker, Vcl.Menus, uniSweetAlert, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.Types;

type
  TControleConsultaTituloReceber = class(TControleConsulta)
    UniEdit1: TUniEdit;
    UniEdit2: TUniEdit;
    UniEdit3: TUniEdit;
    UniEdit6: TUniEdit;
    UniEdit7: TUniEdit;
    UniEdit8: TUniEdit;
    UniEdit9: TUniEdit;
    UniImageList2: TUniImageList;
    UniPanel7: TUniPanel;
    UniPanel9: TUniPanel;
    UniPanelIntervalo: TUniPanel;
    UniBotaoMesAnterior: TUniButton;
    UniBotaoMesPosterior: TUniButton;
    uniEditAno: TUniEdit;
    UniPanel10: TUniPanel;
    UniTimer1: TUniTimer;
    UniPanel6: TUniPanel;
    BotaoQuitarTitulo: TUniButton;
    BotaoCancelarTitulo: TUniButton;
    UniImageList3: TUniImageList;
    BotaoVerificarPagamento: TUniButton;
    UniScreenMask1: TUniScreenMask;
    frxDBDataset1: TfrxDBDataset;
    frxReport1: TfrxReport;
    QryConsultaCarne: TADOQuery;
    DspConsultaCarne: TDataSetProvider;
    CdsConsultaCarne: TClientDataSet;
    DscConsultaCarne: TDataSource;
    CdsConsultaCarneID: TFloatField;
    CdsConsultaCarneDATA_VENCIMENTO: TDateTimeField;
    CdsConsultaCarneVALOR: TFloatField;
    CdsConsultaCarneRAZAO_SOCIAL: TWideStringField;
    CdsConsultaCarneCPF_CNPJ: TWideStringField;
    CdsConsultaCarneLOGRADOURO: TWideStringField;
    CdsConsultaCarneCIDADE: TWideStringField;
    CdsConsultaCarneTELEFONE: TWideStringField;
    CdsConsultaCarneDATA_EMISSAO: TWideStringField;
    CdsConsultaCarneSomaTitulos: TAggregateField;
    CdsConsultaCarneQuantParcela: TAggregateField;
    CdsConsultaCarneSEQUENCIA_PARCELAS: TFloatField;
    CdsConsultaCarneLOGOMARCA_CAMINHO: TWideStringField;
    frxPDFExport1: TfrxPDFExport;
    CdsConsultaCarneSITUACAO: TWideStringField;
    UniEdit10: TUniEdit;
    UniLabelValorRestante: TUniFormattedNumberEdit;
    UniPopupMenuLegenda: TUniPopupMenu;
    UniImageList4: TUniImageList;
    CdsConsultaCarneNUMERO_DOCUMENTO: TWideStringField;
    UniPanel14: TUniPanel;
    CdsConsultaCarneDATA_VENC_ORIGINAL: TDateTimeField;
    UniEdit11: TUniEdit;
    CdsConsultaSomaValor: TAggregateField;
    UniEdit12: TUniEdit;
    UniEdit13: TUniEdit;
    UniImageList5: TUniImageList;
    N1: TUniMenuItem;
    Maisopes1: TUniMenuItem;
    BotaoAlteraData: TUniButton;
    BotaoAlteraValor: TUniButton;
    UniPopupMenuOpcoes: TUniPopupMenu;
    cadastro1: TUniMenuItem;
    sair1: TUniMenuItem;
    CompartilharEmail1: TUniMenuItem;
    Parcelaatual1: TUniMenuItem;
    Carncompleto1: TUniMenuItem;
    Visualizarttulo1: TUniMenuItem;
    UniImageList6: TUniImageList;
    Cheque1: TUniMenuItem;
    N2: TUniMenuItem;
    UniComboBox1: TUniComboBox;
    UniEdit4: TUniEdit;
    UniEdit5: TUniEdit;
    ComBoxCondicoesPagamento: TUniComboBox;
    EditPesquisaId: TUniEdit;
    QryTituloCategoria: TADOQuery;
    CdsTituloCategoria: TClientDataSet;
    DspTituloCategoria: TDataSetProvider;
    DscTituloCategoria: TDataSource;
    CdsTituloCategoriaDESCRICAO: TWideStringField;
    UniComboBox3: TUniComboBox;
    UniSweetCancelarTitulo: TUniSweetAlert;
    UniSweetAlertVerificaIntervalo: TUniSweetAlert;
    UniDateTimePickerInicial: TUniDateTimePicker;
    UniDateTimePickerFinal: TUniDateTimePicker;
    Imprimirrecibo1: TUniMenuItem;
    Conexao_Recibo: TfrxDBDataset;
    Conexao_recibo_pagamento: TfrxDBDataset;
    QryConsParcelas: TADOQuery;
    DspConsParcelas: TDataSetProvider;
    Relatorio_Recibo: TfrxReport;
    CdsConsParcelas: TClientDataSet;
    CdsConsParcelasFORMA_PAGAMENTO: TWideStringField;
    CdsConsParcelasVALOR_PAGO: TFloatField;
    ImprimirCarn1: TUniMenuItem;
    UniSweetAlertaImprimeCarne: TUniSweetAlert;
    ConferenciaAssinatura1: TUniMenuItem;
    Negociar1: TUniMenuItem;
    CdsTitulosGerar: TClientDataSet;
    CdsTitulosGerarDIAS_ATRASO: TIntegerField;
    CdsTitulosGerarVALOR_CORRIGIDO: TFloatField;
    CdsTitulosGerarNUMERO_REFERENCIA: TIntegerField;
    CdsTitulosGerarSomaValorTotal: TAggregateField;
    CdsTitulosGerarMediaDiasAtraso: TAggregateField;
    QryConsultaID: TFloatField;
    QryConsultaCLIENTE_ID: TFloatField;
    QryConsultaCONDICOES_PAGAMENTO_ID: TFloatField;
    QryConsultaNUMERO_DOCUMENTO: TWideStringField;
    QryConsultaSEQUENCIA_PARCELAS: TFloatField;
    QryConsultaNATUREZA: TWideStringField;
    QryConsultaDATA_EMISSAO: TDateTimeField;
    QryConsultaDATA_VENCIMENTO: TDateTimeField;
    QryConsultaDATA_VENC_ORIGINAL: TDateTimeField;
    QryConsultaVALOR: TFloatField;
    QryConsultaDIAS_ATRASO: TFloatField;
    QryConsultaSITUACAO: TWideStringField;
    QryConsultaVENCIDO: TWideStringField;
    QryConsultaDATA_LIQUIDACAO: TDateTimeField;
    QryConsultaVALOR_PAGO: TFloatField;
    QryConsultaVALOR_SALDO: TFloatField;
    QryConsultaHISTORICO: TWideStringField;
    QryConsultaCLIENTE: TWideStringField;
    QryConsultaCPF_CNPJ: TWideStringField;
    QryConsultaDESCRICAO_CONDICOES_PAGAMENTO: TWideStringField;
    QryConsultaCONTA_BANCARIA_ID: TFloatField;
    QryConsultaNUMERO_CARNE: TWideStringField;
    QryConsultaGERA_BOLETO: TWideStringField;
    QryConsultaGERA_CARNE: TWideStringField;
    QryConsultaGERA_CHEQUE: TWideStringField;
    QryConsultaOPCOES: TFloatField;
    QryConsultaPOSSUI_ANEXO: TWideStringField;
    QryConsultaNUMERO_REFERENCIA: TWideStringField;
    QryConsultaCELULAR: TWideStringField;
    QryConsultaVALOR_DESCONTO: TFloatField;
    QryConsultaVALOR_MULTA: TFloatField;
    QryConsultaVALOR_JUROS: TFloatField;
    QryConsultaCALCULA_JUROS: TWideStringField;
    QryConsultaCALCULA_MULTA: TWideStringField;
    QryConsultaCATEGORIA: TWideStringField;
    QryConsultaNEGOCIADO: TWideStringField;
    CdsConsultaID: TFloatField;
    CdsConsultaCLIENTE_ID: TFloatField;
    CdsConsultaCONDICOES_PAGAMENTO_ID: TFloatField;
    CdsConsultaNUMERO_DOCUMENTO: TWideStringField;
    CdsConsultaSEQUENCIA_PARCELAS: TFloatField;
    CdsConsultaNATUREZA: TWideStringField;
    CdsConsultaDATA_EMISSAO: TDateTimeField;
    CdsConsultaDATA_VENCIMENTO: TDateTimeField;
    CdsConsultaDATA_VENC_ORIGINAL: TDateTimeField;
    CdsConsultaVALOR: TFloatField;
    CdsConsultaDIAS_ATRASO: TFloatField;
    CdsConsultaSITUACAO: TWideStringField;
    CdsConsultaVENCIDO: TWideStringField;
    CdsConsultaDATA_LIQUIDACAO: TDateTimeField;
    CdsConsultaVALOR_PAGO: TFloatField;
    CdsConsultaVALOR_SALDO: TFloatField;
    CdsConsultaHISTORICO: TWideStringField;
    CdsConsultaCLIENTE: TWideStringField;
    CdsConsultaCPF_CNPJ: TWideStringField;
    CdsConsultaDESCRICAO_CONDICOES_PAGAMENTO: TWideStringField;
    CdsConsultaCONTA_BANCARIA_ID: TFloatField;
    CdsConsultaNUMERO_CARNE: TWideStringField;
    CdsConsultaGERA_BOLETO: TWideStringField;
    CdsConsultaGERA_CARNE: TWideStringField;
    CdsConsultaGERA_CHEQUE: TWideStringField;
    CdsConsultaOPCOES: TFloatField;
    CdsConsultaPOSSUI_ANEXO: TWideStringField;
    CdsConsultaNUMERO_REFERENCIA: TWideStringField;
    CdsConsultaCELULAR: TWideStringField;
    CdsConsultaVALOR_DESCONTO: TFloatField;
    CdsConsultaVALOR_MULTA: TFloatField;
    CdsConsultaVALOR_JUROS: TFloatField;
    CdsConsultaCALCULA_JUROS: TWideStringField;
    CdsConsultaCALCULA_MULTA: TWideStringField;
    CdsConsultaCATEGORIA: TWideStringField;
    CdsConsultaNEGOCIADO: TWideStringField;
    DspCondicoesPagamento: TDataSetProvider;
    CdsCondicoesPagamento: TClientDataSet;
    DscCondicoesPagamento: TDataSource;
    QryCondicoesPagamento: TADOQuery;
    CdsCondicoesPagamentoID: TFloatField;
    CdsCondicoesPagamentoDESCRICAO: TWideStringField;
    CdsCondicoesPagamentoTIPO: TWideStringField;
    CdsCondicoesPagamentoORDEM_EXIBICAO: TFloatField;
    CdsCondicoesPagamentoGERA_CARNE: TWideStringField;
    CdsCondicoesPagamentoGERA_BOLETO: TWideStringField;
    CdsCondicoesPagamentoGERA_CHEQUE: TWideStringField;
    CdsConsParcelasID: TFloatField;
    CdsConsParcelasDATA: TDateTimeField;
    BotaoNegociarTitulos: TUniButton;
    UniSweetAlertImprimirBaixa: TUniSweetAlert;
    frxReport_baixa_receber: TfrxReport;
    frxDBDataset_ReceberBaixarLote: TfrxDBDataset;
    DscConsultaLote: TDataSource;
    CdsConsultaLote: TClientDataSet;
    DspConsultaLote: TDataSetProvider;
    QryConsultaLote: TADOQuery;
    CdsConsultaLoteID: TFloatField;
    CdsConsultaLoteCLIENTE_ID: TFloatField;
    CdsConsultaLoteCONDICOES_PAGAMENTO_ID: TFloatField;
    CdsConsultaLoteNUMERO_DOCUMENTO: TWideStringField;
    CdsConsultaLoteSEQUENCIA_PARCELAS: TFloatField;
    CdsConsultaLoteNATUREZA: TWideStringField;
    CdsConsultaLoteDATA_EMISSAO: TDateTimeField;
    CdsConsultaLoteDATA_VENCIMENTO: TDateTimeField;
    CdsConsultaLoteDATA_VENC_ORIGINAL: TDateTimeField;
    CdsConsultaLoteVALOR: TFloatField;
    CdsConsultaLoteDIAS_ATRASO: TFloatField;
    CdsConsultaLoteSITUACAO: TWideStringField;
    CdsConsultaLoteVENCIDO: TWideStringField;
    CdsConsultaLoteDATA_LIQUIDACAO: TDateTimeField;
    CdsConsultaLoteVALOR_PAGO: TFloatField;
    CdsConsultaLoteVALOR_SALDO: TFloatField;
    CdsConsultaLoteHISTORICO: TWideStringField;
    CdsConsultaLoteCLIENTE: TWideStringField;
    CdsConsultaLoteCPF_CNPJ: TWideStringField;
    CdsConsultaLoteDESCRICAO_CONDICOES_PAGAMENTO: TWideStringField;
    CdsConsultaLoteCONTA_BANCARIA_ID: TFloatField;
    CdsConsultaLoteNUMERO_CARNE: TWideStringField;
    CdsConsultaLoteGERA_BOLETO: TWideStringField;
    CdsConsultaLoteGERA_CARNE: TWideStringField;
    CdsConsultaLoteGERA_CHEQUE: TWideStringField;
    CdsConsultaLoteOPCOES: TFloatField;
    CdsConsultaLotePOSSUI_ANEXO: TWideStringField;
    CdsConsultaLoteNUMERO_REFERENCIA: TWideStringField;
    CdsConsultaLoteCELULAR: TWideStringField;
    CdsConsultaLoteVALOR_DESCONTO: TFloatField;
    CdsConsultaLoteVALOR_MULTA: TFloatField;
    CdsConsultaLoteVALOR_JUROS: TFloatField;
    CdsConsultaLoteCALCULA_JUROS: TWideStringField;
    CdsConsultaLoteCALCULA_MULTA: TWideStringField;
    CdsConsultaLoteCATEGORIA: TWideStringField;
    CdsConsultaLoteNEGOCIADO: TWideStringField;
    CdsConsultaLoteLOTE_BAIXA: TFloatField;
    QryConsultaTITULO_CATEGORIA_ID: TFloatField;
    QryConsultaNUMERO_LOTE: TFloatField;
    CdsConsultaTITULO_CATEGORIA_ID: TFloatField;
    CdsConsultaNUMERO_LOTE: TFloatField;
    Imprimirbaixadelote1: TUniMenuItem;
    CdsBaixaMultiplo: TClientDataSet;
    CdsBaixaMultiploID: TStringField;
    CdsBaixaMultiploVALOR: TFloatField;
    CdsBaixaMultiploCLIENTE: TStringField;
    CdsBaixaMultiploCONTA_BANCARIA_ID: TStringField;
    CdsBaixaMultiploSEQUENCIA_PARCELAS: TStringField;
    CdsBaixaMultiploTITULO_CATEGORIA_ID: TStringField;
    CdsBaixaMultiploVENCIMENTO: TDateField;
    CdsBaixaMultiploCLIENTE_ID: TIntegerField;
    CdsBaixaMultiploDIAS_ATRASO: TIntegerField;
    CdsBaixaMultiploNUMERO_CARNE: TStringField;
    CdsBaixaMultiploSomaTotal: TAggregateField;
    CdsBaixaMultiploConta: TAggregateField;
    Produtosdopedido1: TUniMenuItem;
    QryProdutoPdve: TADOQuery;
    DspProdutoPdve: TDataSetProvider;
    CdsProdutoPdve: TClientDataSet;
    CdsProdutoPdveDESCRICAO: TWideStringField;
    CdsProdutoPdveQUANTIDADE: TFloatField;
    CdsProdutoPdveVALOR_UNITARIO: TFloatField;
    CdsProdutoPdveSUBTOTAL: TFloatField;
    CdsProdutoPdveDESCONTO: TFloatField;
    CdsProdutoPdveVALOR_TOTAL: TFloatField;
    CdsProdutoPdveNUMERO_ITEM_CUPOM: TIntegerField;
    CdsProdutoPdveCANCELADO: TWideStringField;
    Conexao_ProdutosPdve: TfrxDBDataset;
    DscProdutoPdve: TDataSource;
    Relatorio_ProdutosPdve: TfrxReport;
    CdsProdutoPdvePEDIDO_VENDA_ID: TFloatField;
    CdsProdutoPdveDATA_INCLUSAO: TWideStringField;
    CdsTemp: TClientDataSet;
    CdsTempnumero: TStringField;
    FDQueryProdutoIntegracao: TFDQuery;
    DataSource2: TDataSource;
    FDQueryProdutoIntegracaoSEQ: TIntegerField;
    FDQueryProdutoIntegracaoCODPROD: TIntegerField;
    FDQueryProdutoIntegracaoDESCRICAO: TStringField;
    FDQueryProdutoIntegracaoUNIDADE: TStringField;
    FDQueryProdutoIntegracaoQUANTIDADE: TFloatField;
    FDQueryProdutoIntegracaoVALORUNIT: TFloatField;
    FDQueryProdutoIntegracaoTOTAL: TFloatField;
    Conexao_ProdutosIntegracao: TfrxDBDataset;
    Relatorio_ProdutosIntegracao: TfrxReport;
    DataSource3: TDataSource;
    FDQueryProdutoIntegracaoNUMERO: TIntegerField;
    FDQueryProdutoIntegracaoDATA: TDateField;
    Notapromissria1: TUniMenuItem;
    frxReportPromissoria: TfrxReport;
    CdsConsultaCarnePromissoria: TClientDataSet;
    AggregateField2: TAggregateField;
    AggregateField3: TAggregateField;
    QryConsultaCarnePromissoria: TADOQuery;
    DscConsultaCarnePromissoria: TDataSource;
    DspConsultaCarnePromissoria: TDataSetProvider;
    FrxConsultaCarnePromissoria: TfrxDBDataset;
    CdsConsultaCarnePromissoriaID: TFMTBCDField;
    CdsConsultaCarnePromissoriaNUMERO_DOCUMENTO: TWideStringField;
    CdsConsultaCarnePromissoriaDATA_EMISSAO: TWideStringField;
    CdsConsultaCarnePromissoriaDATA_VENCIMENTO: TDateTimeField;
    CdsConsultaCarnePromissoriaDATA_VENC_ORIGINAL: TDateTimeField;
    CdsConsultaCarnePromissoriaVALOR: TBCDField;
    CdsConsultaCarnePromissoriaRAZAO_SOCIAL: TWideStringField;
    CdsConsultaCarnePromissoriaCPF_CNPJ: TWideStringField;
    CdsConsultaCarnePromissoriaLOGRADOURO: TWideStringField;
    CdsConsultaCarnePromissoriaCIDADE: TWideStringField;
    CdsConsultaCarnePromissoriaTELEFONE: TWideStringField;
    CdsConsultaCarnePromissoriaSEQUENCIA_PARCELAS: TFMTBCDField;
    CdsConsultaCarnePromissoriaLOGOMARCA_CAMINHO: TWideStringField;
    CdsConsultaCarnePromissoriaSITUACAO: TWideStringField;
    CdsConsultaCarnePromissoriaCATEGORIA: TWideStringField;
    Apagarttulo1: TUniMenuItem;
    UniSweetAlertExcluirTítuloReceber: TUniSweetAlert;
    CdsConsultaSomaPago: TAggregateField;
    CdsConsultaCarnePromissoriaHISTORICO: TWideStringField;
    CdsConsultaCarneHISTORICO: TWideStringField;
    CdsConsultaCarnePromissoriaNUMERO: TWideStringField;
    CdsConsultaCarnePromissoriaBAIRRO: TWideStringField;
    UniEdit14: TUniEdit;
    UniLabelValorAReceber: TUniFormattedNumberEdit;
    UniLabelValorPago: TUniFormattedNumberEdit;
    UniLabel1: TUniLabel;
    UniLabel2: TUniLabel;
    UniLabel3: TUniLabel;
    Relatorio: TfrxReport;
    Conexao_pagar: TfrxDBDataset;
    QryConsultaDebitos: TADOQuery;
    FloatField16: TFloatField;
    FloatField17: TFloatField;
    FloatField18: TFloatField;
    WideStringField20: TWideStringField;
    FloatField19: TFloatField;
    WideStringField21: TWideStringField;
    DateTimeField5: TDateTimeField;
    DateTimeField6: TDateTimeField;
    DateTimeField7: TDateTimeField;
    FloatField20: TFloatField;
    FloatField21: TFloatField;
    WideStringField22: TWideStringField;
    WideStringField23: TWideStringField;
    DateTimeField8: TDateTimeField;
    FloatField22: TFloatField;
    FloatField23: TFloatField;
    WideStringField24: TWideStringField;
    WideStringField25: TWideStringField;
    WideStringField26: TWideStringField;
    WideStringField27: TWideStringField;
    FloatField24: TFloatField;
    WideStringField28: TWideStringField;
    WideStringField29: TWideStringField;
    WideStringField30: TWideStringField;
    WideStringField31: TWideStringField;
    FloatField25: TFloatField;
    WideStringField32: TWideStringField;
    WideStringField33: TWideStringField;
    WideStringField34: TWideStringField;
    FloatField26: TFloatField;
    FloatField27: TFloatField;
    FloatField28: TFloatField;
    WideStringField35: TWideStringField;
    WideStringField36: TWideStringField;
    WideStringField37: TWideStringField;
    WideStringField38: TWideStringField;
    FloatField29: TFloatField;
    FloatField30: TFloatField;
    CdsConsultaDebitos: TClientDataSet;
    FloatField31: TFloatField;
    FloatField32: TFloatField;
    FloatField33: TFloatField;
    WideStringField39: TWideStringField;
    FloatField34: TFloatField;
    WideStringField40: TWideStringField;
    DateTimeField9: TDateTimeField;
    DateTimeField10: TDateTimeField;
    DateTimeField11: TDateTimeField;
    FloatField35: TFloatField;
    FloatField36: TFloatField;
    WideStringField41: TWideStringField;
    WideStringField42: TWideStringField;
    DateTimeField12: TDateTimeField;
    FloatField37: TFloatField;
    FloatField38: TFloatField;
    WideStringField43: TWideStringField;
    WideStringField44: TWideStringField;
    WideStringField45: TWideStringField;
    WideStringField46: TWideStringField;
    FloatField39: TFloatField;
    WideStringField47: TWideStringField;
    WideStringField48: TWideStringField;
    WideStringField49: TWideStringField;
    WideStringField50: TWideStringField;
    FloatField40: TFloatField;
    WideStringField51: TWideStringField;
    WideStringField52: TWideStringField;
    WideStringField53: TWideStringField;
    FloatField41: TFloatField;
    FloatField42: TFloatField;
    FloatField43: TFloatField;
    WideStringField54: TWideStringField;
    WideStringField55: TWideStringField;
    WideStringField56: TWideStringField;
    WideStringField57: TWideStringField;
    FloatField44: TFloatField;
    FloatField45: TFloatField;
    DspConsultaDebitos: TDataSetProvider;
    Dbitosdocliente1: TUniMenuItem;
    QryConsultaDebitosLOGRADOURO: TWideStringField;
    QryConsultaDebitosNUMERO: TWideStringField;
    QryConsultaDebitosBAIRRO: TWideStringField;
    QryConsultaDebitosCIDADE: TWideStringField;
    CdsConsultaDebitosLOGRADOURO: TWideStringField;
    CdsConsultaDebitosNUMERO: TWideStringField;
    CdsConsultaDebitosBAIRRO: TWideStringField;
    CdsConsultaDebitosCIDADE: TWideStringField;
    DscConsultaDebitos: TDataSource;
    QryConsultaDebitosTOTAL_COM_JUROS: TFloatField;
    QryConsultaDebitosVALOR_JUROS_1: TFloatField;
    CdsConsultaDebitosTOTAL_COM_JUROS: TFloatField;
    CdsConsultaDebitosVALOR_JUROS_1: TFloatField;
    UniSweetAlertJuros: TUniSweetAlert;
    CdsConsultaCarnePromissoriaCODCLI: TFMTBCDField;
    UCBOcultaTitulosPagos: TUniCheckBox;
    UniCheckBoxIntervalo: TUniCheckBox;
    CdsProdutoPdvePRODUTO_ID: TFloatField;
    CdsProdutoPdveNOME_VENDEDOR: TWideStringField;
    FDQueryProdutoIntegracaoVENDEDOR: TStringField;
    CdsConsultaClone: TClientDataSet;
    FloatField1: TFloatField;
    FloatField2: TFloatField;
    FloatField3: TFloatField;
    WideStringField1: TWideStringField;
    FloatField4: TFloatField;
    WideStringField2: TWideStringField;
    DateTimeField1: TDateTimeField;
    DateTimeField2: TDateTimeField;
    DateTimeField3: TDateTimeField;
    FloatField5: TFloatField;
    FloatField6: TFloatField;
    WideStringField3: TWideStringField;
    WideStringField4: TWideStringField;
    DateTimeField4: TDateTimeField;
    FloatField7: TFloatField;
    FloatField8: TFloatField;
    WideStringField5: TWideStringField;
    WideStringField6: TWideStringField;
    WideStringField7: TWideStringField;
    WideStringField8: TWideStringField;
    FloatField9: TFloatField;
    WideStringField9: TWideStringField;
    WideStringField10: TWideStringField;
    WideStringField11: TWideStringField;
    WideStringField12: TWideStringField;
    FloatField10: TFloatField;
    WideStringField13: TWideStringField;
    WideStringField14: TWideStringField;
    WideStringField15: TWideStringField;
    FloatField11: TFloatField;
    FloatField12: TFloatField;
    FloatField13: TFloatField;
    WideStringField16: TWideStringField;
    WideStringField17: TWideStringField;
    WideStringField18: TWideStringField;
    WideStringField19: TWideStringField;
    FloatField14: TFloatField;
    FloatField15: TFloatField;
    AggregateField1: TAggregateField;
    AggregateField4: TAggregateField;
    QryConsultaDebitosVALOR_JUROS_CALCULADOS: TFloatField;
    CdsConsultaDebitosVALOR_JUROS_CALCULADOS: TFloatField;
    DscPessoa: TDataSource;
    CdsPessoa: TClientDataSet;
    DspPessoa: TDataSetProvider;
    QryPessoa: TADOQuery;
    CdsPessoaID: TFloatField;
    CdsPessoaATIVO: TWideStringField;
    CdsPessoaTIPO: TWideStringField;
    CdsPessoaCPF_CNPJ: TWideStringField;
    CdsPessoaRAZAO_SOCIAL: TWideStringField;
    CdsPessoaNOME_FANTASIA: TWideStringField;
    CdsPessoaDATA_NASCIMENTO: TDateTimeField;
    CdsPessoaRG_INSC_ESTADUAL: TWideStringField;
    CdsPessoaCODIGO_REGIME_TRIBUTARIO: TWideStringField;
    CdsPessoaTELEFONE: TWideStringField;
    CdsPessoaCELULAR: TWideStringField;
    CdsPessoaEMAIL: TWideStringField;
    CdsPessoaLOGRADOURO: TWideStringField;
    CdsPessoaNUMERO: TWideStringField;
    CdsPessoaBAIRRO: TWideStringField;
    CdsPessoaCEP: TWideStringField;
    CdsPessoaCIDADE: TWideStringField;
    QryConsultaENDERECO: TWideStringField;
    CdsConsultaENDERECO: TWideStringField;
    procedure UniFrameCreate(Sender: TObject);
    procedure UniCheckBoxIntervaloClick(Sender: TObject);
    procedure UniBotaoMesPosteriorClick(Sender: TObject);
    procedure UniBotaoMesAnteriorClick(Sender: TObject);
    procedure UniTimer1Timer(Sender: TObject);
    procedure BotaoCancelarTituloClick(Sender: TObject);
    procedure BotaoQuitarTituloClick(Sender: TObject);
    procedure CdsConsultaPOSSUI_ANEXOGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure BotaoAbrirClick(Sender: TObject);
    procedure CdsConsultaAfterRefresh(DataSet: TDataSet);
    procedure GrdResultadoColumnFilter(Sender: TUniDBGrid;
      const Column: TUniDBGridColumn; const Value: Variant);
    procedure GrdResultadoColumnSummaryResult(Column: TUniDBGridColumn;
      GroupFieldValue: Variant; Attribs: TUniCellAttribs; var Result: string);
    procedure GrdResultadoCellClick(Column: TUniDBGridColumn);
    procedure BotaoAlteraDataClick(Sender: TObject);
    procedure BotaoAlteraValorClick(Sender: TObject);
    procedure cadastro1Click(Sender: TObject);
    procedure sair1Click(Sender: TObject);
    procedure Visualizarttulo1Click(Sender: TObject);
    procedure Parcelaatual1Click(Sender: TObject);
    procedure Cheque1Click(Sender: TObject);
    procedure UniSweetCancelarTituloConfirm(Sender: TObject);
    procedure UniSweetAlertVerificaIntervaloConfirm(Sender: TObject);
    procedure UniSweetAlertVerificaIntervaloDismiss(Sender: TObject;
      const Reason: TDismissType);
    procedure UniDateTimePickerFinalChange(Sender: TObject);
    procedure UniDateTimePickerInicialChange(Sender: TObject);
    procedure GrdResultadoDrawColumnCell(Sender: TObject; ACol, ARow: Integer;
      Column: TUniDBGridColumn; Attribs: TUniCellAttribs);
    procedure Imprimirrecibo1Click(Sender: TObject);
    procedure ImprimirCarn1Click(Sender: TObject);
    procedure UniSweetAlertaImprimeCarneConfirm(Sender: TObject);
    procedure ConferenciaAssinatura1Click(Sender: TObject);
    procedure BotaoNegociarTitulosClick(Sender: TObject);
    procedure Negociar1Click(Sender: TObject);
    procedure EditPesquisaIdKeyPress(Sender: TObject; var Key: Char);
    procedure Imprimirbaixadelote1Click(Sender: TObject);
    procedure BotaoAtualizarClick(Sender: TObject);
    procedure UniSweetAlertImprimirBaixaConfirm(Sender: TObject);
    procedure UniSweetAlertImprimirBaixaDismiss(Sender: TObject;
      const Reason: TDismissType);
    procedure Produtosdopedido1Click(Sender: TObject);
    procedure Notapromissria1Click(Sender: TObject);
    procedure Apagarttulo1Click(Sender: TObject);
    procedure UniSweetAlertExcluirTítuloReceberConfirm(Sender: TObject);
    procedure Dbitosdocliente1Click(Sender: TObject);
    procedure UniSweetAlertJurosConfirm(Sender: TObject);
    procedure UCBOcultaTitulosPagosClick(Sender: TObject);
  private
    function ConverterDataGerencianet(dataGerencianet: string): TDateTime;
//    procedure CarregaCarne(titulo_id: integer);
    procedure EnviaCarneParcelaEmailBoleto(Sender: TComponent; AResult: Integer;
      AText: string);
    procedure AlteraCelular(Sender: TComponent; AResult: Integer;
      AText: string);
    procedure AlteraDataParcela(Sender: TComponent; AResult: Integer;
      AText: string);
    procedure AlteraValorParcela(Sender: TComponent; AResult: Integer;
      AText: string);
    procedure AbreAnexos;
    procedure VisualizaTitulo;
//    procedure EnviaTituloWhatsapp;
//   procedure EnviaBoletoCarneParcelaEmail;
    procedure AlteraValorTitulo;
    procedure AlteraDataTitulo;
    procedure VerificaIntervalo(fullconsulta : string ='');
    procedure AlteraDataParcelaCarne(Sender: TComponent; AResult: Integer;
      AText: string);
    function Verificase_Cliente_Negociar_e_igual(CNPJ_CPF_cliente: String): Boolean;
    procedure DesabilitaMenusOpcoes(Popup: TUniPopupMenu);
    procedure PreencheFiltrosGrid;
    procedure ImprimeLote;
    procedure RetornaValoresSeparados(texto: string;
                                                                 caractereSeparador: string);
    procedure PesquisaProdutosFirebirdIntegracao;
    function separaTituloParcela(nTituloParcela: String): TStringDynArray;
    procedure AtualizaLabeltotal;
    procedure AtualizaLabeltotalComAcrescimo;
    procedure AtualizaLabeltotalRestante;
    { Private declarations }
  public
    { Public declarations }
    procedure ConsultaTitulosMes(DataInicial, DataFinal: String;
                                                            FullConsulta: string ='N');
    procedure Novo; override;
    procedure Abrir(Id: Integer); override;
  end;

var
  Cont : Integer;
  QtdNegociado : Integer = 0;
  CPF_CNPJ_Negociado: string;
  QtdTituloParaBaixar : Integer = 0;

implementation

{$R *.dfm}

uses Controle.Cadastro.TituloReceber, Controle.Main,
     Controle.Main.Module, Controle.Operacoes.CriarTituloReceber, System.DateUtils,
     Controle.Impressao.Carne,
     Controle.Operacoes.Titulos.Carne,
     Controle.Operacoes.TituloReceber.Documentos,
     Controle.Impressao.Documento, Controle.Funcoes, Controle.Server.Module,
     Controle.Consulta.TituloReceber.Opcoes, Controle.Cadastro.Cheque,
     Controle.Operacoes.NegociarTituloReceber,
     Controle.Operacoes.ConferenciaAssinatura,
     Controle.Operacoes.Integracao.CalculoJuros,
     Controle.Operacoes.Integracao.NegociarTituloReceber,
     Controle.Consulta.Baixar.MultiplosReceber, IdHashMessageDigest;

{ TControleConsultaTituloReceber }

procedure TControleConsultaTituloReceber.Abrir(Id: Integer);
begin
  inherited;

  // Abre o formulário de cadastro para visualização e edição
  if ControleCadastroTituloReceber.Abrir(Id) then
  begin
//    if ControleMainModule.ConfereTituloGeraBoleto(CdsConsultaTIPO_TITULO_ID.AsInteger)  = 'S' then
//      ControleCadastroTituloReceber.GeraBoleto := 'S';

    ControleCadastroTituloReceber.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
//      if Result = 1 then
        CdsConsulta.Refresh;
    end);
  end;
end;

{ Rateio do valor na geração do titulo
 Não permitir negociação de titulos de varias pessoas
 verificar codigo todo}

procedure TControleConsultaTituloReceber.Negociar1Click(Sender: TObject);
var
  bJSName: string;
begin
  inherited;
  if CdsConsultaSITUACAO.AsString = 'INADIMPLENTE' then
  begin
    CdsConsulta.Edit;
    if CdsConsultaNEGOCIADO.AsString = 'N' then
    begin
      // Verifica se tem permissão para negociar títulos de clientes diferentes
      if ControleMainModule.negociar_titulo_varios_clientes = 'N' then
      begin
        // Preenchendo a variavel de negociação, se ainda nao foi preenchida
        if CPF_CNPJ_Negociado = '' then
          CPF_CNPJ_Negociado := CdsConsultaCPF_CNPJ.AsString
        else
        begin
          // Válida se o usuário está tentando negociar títulos de clientes diferentes.
          if Verificase_Cliente_Negociar_e_igual(CdsConsultaCPF_CNPJ.AsString) = False then
          begin
            ControleMainModule.MensageiroSweetAlerta('Atenção', 'Só é possível negociar títulos do mesmo cliente!');
            Exit;
          end;
        end;
      end;

      CdsConsultaNEGOCIADO.AsString := 'S';

      // Alimentando o cds temporario para fazer a nagociação
      CdsTitulosGerar.Insert;
      CdsTitulosGerarNUMERO_REFERENCIA.AsString := CdsConsultaID.AsString;
      CdsTitulosGerarDIAS_ATRASO.AsInteger      := CdsConsultaDIAS_ATRASO.AsInteger;
      CdsTitulosGerarVALOR_CORRIGIDO.AsFloat    := CdsConsultaVALOR.AsFloat;
      CdsTitulosGerar.Post;

//      // Alterando o label
//      qtdlabel := StrToInt(LabelQtdTituloGerar.Caption);
      QtdNegociado := QtdNegociado + 1;
//      LabelQtdTituloGerar.Caption := IntToStr(qtdlabel);
      bJSName := (BotaoNegociarTitulos).JSName;
      UniSession.AddJS(bJSName + '.setBadgeText(' + bJSName + '.getBadgeText() + 1);');
    end
    else
    begin
      CdsConsultaNEGOCIADO.AsString := 'N';

      // Alimentando o cds temporario
      if CdsTitulosGerar.Locate('NUMERO_REFERENCIA', CdsConsultaID.AsString, []) then
        CdsTitulosGerar.Delete;

//      // Alterando o label
//      qtdlabel := StrToInt(LabelQtdTituloGerar.Caption);
//      qtdlabel := qtdlabel - 1;
//      LabelQtdTituloGerar.Caption := IntToStr(qtdlabel);

      bJSName := (BotaoNegociarTitulos).JSName;
      UniSession.AddJS(bJSName + '.setBadgeText(' + bJSName + '.getBadgeText() - 1);');

      QtdNegociado := QtdNegociado - 1;

      if QtdNegociado = 0 then
        CPF_CNPJ_Negociado := '';
    end;
    CdsConsulta.Post;
  end
  else
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Só é possível para títulos em atraso');
  end;
end;

procedure TControleConsultaTituloReceber.Notapromissria1Click(Sender: TObject);
var
  caminho_logo : string;
begin
  inherited;
  caminho_logo := ControleMainModule.CdsFilial.fieldByName('logomarca_caminho').Asstring;

  CdsconsultaCarne.Close;
  CdsconsultaCarne.Params.ParamByName('numero_documento').Value  := CdsConsulta.FieldByName('numero_documento').AsString;//ControleMainModule.NumeroDocumentoTitulo;
  CdsconsultaCarne.Open;

  CdsconsultaCarnePromissoria.Close;
  CdsconsultaCarnePromissoria.Params.ParamByName('numero_documento').Value  := CdsConsulta.FieldByName('numero_documento').AsString;//ControleMainModule.NumeroDocumentoTitulo;
  CdsconsultaCarnePromissoria.Open;


 { if ( FileExists(caminho_logo) and (Relatorio_NotaPromissoria.FindComponent('Picture2')<> nil ) ) then
  begin
    TfrxPictureView(Relatorio_NotaPromissoria.FindComponent('Picture2')).Visible := True;
    TfrxPictureView(Relatorio_NotaPromissoria.FindComponent('Picture2')).Picture.LoadFromFile(caminho_logo);
  end
  else
  begin
    TfrxPictureView(Relatorio_NotaPromissoria.FindComponent('RazaoEmpresa')).Visible := True;
    Relatorio_NotaPromissoria.Variables.Variables['RazaoEmpresa'] := QuotedStr(ControleMainModule.FRazaoSocial);
  end; }

  TfrxPictureView(frxReportPromissoria.FindComponent('RazaoEmpresa')).Visible := True;
  frxReportPromissoria.Variables.Variables['RazaoEmpresa'] := QuotedStr(ControleMainModule.FRazaoSocial);

  //  TfrxPictureView(frxReport1.FindObject('Picture2')).Picture.LoadFromFile(ControleMainModule.CdsFilial.fieldByName('logomarca_caminho').Asstring);
  ControleMainModule.ExportarPDF('Relatorio',frxReportPromissoria);
//  frxReportPromissoria.ShowReport(True);
//  ControleMainModule.NumeroDocumentoTitulo :='0';
end;

procedure TControleConsultaTituloReceber.Novo;
begin
  inherited;

  ControleOperacoesCriarTituloReceber.ShowModal(procedure(Sender: TComponent; Result: Integer)
  begin
    if Result = 1 then
    begin
      if CdsConsultaGERA_CARNE.AsString = 'S' then
      begin
        UniSweetAlertaImprimeCarne.Show();
      end;

      CdsConsulta.Refresh;
      VerificaIntervalo;
    end;
  end);
end;

procedure TControleConsultaTituloReceber.Parcelaatual1Click(Sender: TObject);
begin
  //EnviaBoletoCarneParcelaEmail;
end;

procedure TControleConsultaTituloReceber.sair1Click(Sender: TObject);
begin
  //EnviaTituloWhatsapp;
end;

procedure TControleConsultaTituloReceber.UniBotaoMesAnteriorClick(
  Sender: TObject);
var
  DtInicial,DtFinal :string;
begin
  inherited;
  DtInicial := DateToStr(StartOfTheMonth(UniDateTimePickerInicial.DateTime-1));
  DtFinal := DateToStr(EndOfTheMonth(StrToDate(DtInicial)));

  Cont := Cont - 1;
  if Cont = 0 then
  begin
    Cont := 12;
    UniEditAno.Text := IntToStr(StrToInt(UniEditAno.Text) - 1);
  end;

//  UnieditMes.Text := ControleFuncoes.MesExtenso(Cont);

  ConsultaTitulosMes(DtInicial,
                     DtFinal);
  UniDateTimePickerInicial.DateTime :=  StrToDate(DtInicial);
  UniDateTimePickerFinal.DateTime :=  StrToDate(DtFinal);

end;

procedure TControleConsultaTituloReceber.UniBotaoMesPosteriorClick(
  Sender: TObject);
var
  DtInicial,DtFinal :string;
begin
  inherited;
  DtFinal := DateToStr(EndOfTheMonth(UniDateTimePickerFinal.DateTime +1));
  DtInicial := DateToStr(StartOfTheMonth(StrToDate(DtFinal)));

  Cont := Cont + 1;
  if Cont = 13 then
  begin
    Cont := 1;
    UniEditAno.Text := IntToStr(StrToInt(UniEditAno.Text) + 1);
  end;

  //UnieditMes.Text := ControleFuncoes.MesExtenso(Cont);
  ConsultaTitulosMes(DtInicial,
                     DtFinal);
  UniDateTimePickerInicial.DateTime := StrToDate(DtInicial);
  UniDateTimePickerFinal.DateTime :=   StrToDate(DtFinal);
end;

procedure TControleConsultaTituloReceber.UCBOcultaTitulosPagosClick(Sender: TObject);
begin
  inherited;
  if UCBOcultaTitulosPagos.Checked = True  then
   begin
    CdsConsulta.Params.ParamByName( 'notInSituacao' ).Value := 'L';
    CdsConsulta.Refresh;
   end
  else
  begin
    CdsConsulta.Params.ParamByName( 'notInSituacao' ).Value := '0';
    CdsConsulta.Refresh;
  end;
end;

procedure TControleConsultaTituloReceber.UniCheckBoxIntervaloClick(Sender: TObject);
begin
  inherited;
  if UniCheckBoxIntervalo.Checked = True  then
   begin
     UniPanelIntervalo.Enabled := False;
     UniSweetAlertVerificaIntervalo.show;
   end
  else
  begin
    UniPanelIntervalo.Enabled := True;
    UniCheckBoxIntervalo.Enabled := True;
    VerificaIntervalo();
  end;
end;

procedure TControleConsultaTituloReceber.UniDateTimePickerFinalChange(
  Sender: TObject);
begin
  inherited;
    ConsultaTitulosMes(DateToStr(UniDateTimePickerInicial.DateTime),
                        DateToStr(UniDateTimePickerFinal.DateTime));
end;

procedure TControleConsultaTituloReceber.UniDateTimePickerInicialChange(
  Sender: TObject);
begin
  inherited;
    ConsultaTitulosMes(DateToStr(UniDateTimePickerInicial.DateTime),
                        DateToStr(UniDateTimePickerFinal.DateTime));
end;

procedure TControleConsultaTituloReceber.UniFrameCreate(Sender: TObject);
Var
  DtInicial, DtFinal : String;
begin
  // Várivel que permite verificar se o cnpj já foi escolhido para negociação, esta atrelado ao parametro (NEGOCIAR_TITULO_VARIOS_CLIENTES)
  CPF_CNPJ_Negociado := '';
  //  inherited;
  uniEditAno.Text := FormatDateTime('yyyy', Date );
   // ControleFuncoes.MesExtenso(StrToInt(FormatDateTime('mm', Date )));
  Cont := StrToInt(FormatDateTime('mm', Date ));

  UniDateTimePickerInicial.DateTime :=StartOfTheMonth(Date);
  UniDateTimePickerFinal.DateTime :=EndOfTheMonth(Date);

  DtInicial :=  DateToStr(StartOfTheMonth(Date));
  DtFinal :=  DateToStr(EndOfTheMonth(Date));

  //29/06/22 agora é iniciado com a consulta full
  //  ConsultaTitulosMes(DtInicial,
  //                     DtFinal);
  VerificaIntervalo('S');
  UniPanelIntervalo.Enabled := False;

  PreencheFiltrosGrid;

  //Adiciona B
  if ControleMainModule.PLiquidaMultiploReceber ='S' then
    BotaoQuitarTitulo.ClientEvents.UniEvents.Add('beforeInit=function beforeInit(sender, config){config.style={''overflow'': ''visible''};sender.action = ''badgetext'';sender.plugins = [{ptype:''badgetext'',defaultText: 0,disableOpacity:1,disableBg: ''green'',align:''right''}];}');
end;

procedure TControleConsultaTituloReceber.UniSweetAlertaImprimeCarneConfirm(
  Sender: TObject);
var
  caminho_logo : string;
begin
  inherited;
  caminho_logo := ControleMainModule.CdsFilial.fieldByName('logomarca_caminho').Asstring;
  CdsconsultaCarne.Close;
  CdsconsultaCarne.Params.ParamByName('numero_documento').Value  := ControleMainModule.NumeroDocumentoTitulo;
  CdsconsultaCarne.Open;

  if ( FileExists(caminho_logo) and (frxReport1.FindComponent('Picture2')<> nil ) ) then
  begin
    TfrxPictureView(frxReport1.FindComponent('Picture2')).Visible := True;
    TfrxPictureView(frxReport1.FindComponent('Picture2')).Picture.LoadFromFile(caminho_logo);
  end
  else
  begin
    TfrxPictureView(frxReport1.FindComponent('RazaoEmpresa')).Visible := True;
    frxReport1.Variables.Variables['RazaoEmpresa'] := QuotedStr(ControleMainModule.FRazaoSocial);
  end;

  ControleMainModule.ExportarPDF('Relatorio',frxReport1);
  ControleMainModule.NumeroDocumentoTitulo :='0';
end;

procedure TControleConsultaTituloReceber.UniSweetAlertExcluirTítuloReceberConfirm(
  Sender: TObject);
  var
    SenhaDigitada : string;
    MD5: TIdHashMessageDigest5;
    UsuarioTemPermissao : string;
begin
  inherited;

  // Encripta a senha em Hash MD5
  MD5 := TIdHashMessageDigest5.Create;
  try
    SenhaDigitada := MD5.HashStringAsHex(UniSweetAlertExcluirTítuloReceber.InputResult);

  finally
    MD5.Free;
  end;

  //Procura senha no banco
  UsuarioTemPermissao := ControleMainModule.ProcuraUsuarioPermissaoDelTitulo(SenhaDigitada);

  //verifica qual foi o retorno e executa
  case AnsiIndexStr(UsuarioTemPermissao,['P','B']) of
    0:begin
        if ControleMainModule.ApagaTituloReceber(CdsConsultaID.AsInteger) then
        begin
          ControleMainModule.MensageiroSweetAlerta('Excluído','O título foi excluído com sucesso!',atSuccess);
          BotaoAtualizar.Click;
        end;
      end;

    1:begin
       ControleMainModule.MensageiroSweetAlerta('Sem permissão!','A senha digitada não tem permissão de exclusão!',atWarning);
      end;
  else
    ControleMainModule.MensageiroSweetAlerta('Não cadastrado!','A senha informada não foi encontrada!',atWarning);
  end;
end;

procedure TControleConsultaTituloReceber.UniSweetAlertImprimirBaixaConfirm(
  Sender: TObject);
begin
  inherited;
  frxReport_baixa_receber.Variables.Variables['RazaoEmpresa'] := QuotedStr(ControleMainModule.FRazaoSocial);
  ControleMainModule.ExportarPDF('Relatorio',frxReport_baixa_receber);
  BotaoAtualizar.Click;
end;

procedure TControleConsultaTituloReceber.UniSweetAlertImprimirBaixaDismiss(
  Sender: TObject; const Reason: TDismissType);
begin
  inherited;
  BotaoAtualizar.Click;
end;

procedure TControleConsultaTituloReceber.UniSweetAlertJurosConfirm(
  Sender: TObject);
begin
  inherited;
  CdsConsultaDebitos.Close;
  CdsConsultaDebitos.Params.ParamByName('cliente_id').Value := CdsConsultaCLIENTE_ID.AsInteger;
  CdsConsultaDebitos.Params.ParamByName('percentual_juros_1').Value := StrToInt(UniSweetAlertJuros.inputResult)/100;
  CdsConsultaDebitos.Params.ParamByName('percentual_juros_2').Value := StrToInt(UniSweetAlertJuros.inputResult)/100;
  CdsConsultaDebitos.Params.ParamByName('percentual_juros_3').Value := StrToInt(UniSweetAlertJuros.inputResult)/100;
  CdsConsultaDebitos.Params.ParamByName('cliente_id').Value := CdsConsultaCLIENTE_ID.AsInteger;
  CdsConsultaDebitos.Open;

  CdsPessoa.Close;
  CdsPessoa.Params.ParamByName('id').Value := CdsConsultaCLIENTE_ID.AsInteger;
  CdsPessoa.Open;

  if CdsPessoa.RecordCount = 1 then
  begin
    Relatorio.Variables.Variables['RazaoEmpresa']         := QuotedStr(ControleMainModule.FRazaoSocial);
    Relatorio.Variables.Variables['NomeCliente']          := QuotedStr(CdsPessoaRAZAO_SOCIAL.AsString);
    Relatorio.Variables.Variables['CpfCliente']           := QuotedStr(CdsPessoaCPF_CNPJ.AsString);
    Relatorio.Variables.Variables['EnderecoCliente']      := QuotedStr(CdsPessoaLOGRADOURO.AsString + ' - ' + CdsPessoaNUMERO.AsString);
    Relatorio.Variables.Variables['CelularCliente']       := QuotedStr(CdsPessoaCELULAR.AsString + '/' + CdsPessoaTELEFONE.AsString);
    Relatorio.Variables.Variables['CidadeCliente']        := QuotedStr(CdsPessoaCIDADE.AsString);
    Relatorio.Variables.Variables['BairroCliente']        := QuotedStr(CdsPessoaBAIRRO.AsString);
    //Relatorio.ShowReport();
    ControleMainModule.ExportarPDF('Relatorio',relatorio);
  end
  else if CdsPessoa.RecordCount >1 then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Foram encontrados mais de um cadastro para esse ID de cliente. Por favor verifique o cadastro.',atInfo);
  end
  else
      ControleMainModule.MensageiroSweetAlerta('Atenção', 'Cadastro do cliente não encontrado');
end;

procedure TControleConsultaTituloReceber.UniSweetAlertVerificaIntervaloConfirm(
  Sender: TObject);
begin
  inherited;
  VerificaIntervalo('S');
end;

procedure TControleConsultaTituloReceber.UniSweetAlertVerificaIntervaloDismiss(
  Sender: TObject; const Reason: TDismissType);
begin
  inherited;
  UniCheckBoxIntervalo.Checked := False;
  UniPanelIntervalo.Enabled := True;
end;

procedure TControleConsultaTituloReceber.UniSweetCancelarTituloConfirm(
  Sender: TObject);
begin
  inherited;
  ControleMainModule.CancelaTitulo(CdsConsultaID.AsInteger);
  CdsConsulta.Refresh;

  ControleMainModule.MensageiroSweetAlerta('Atenção', 'Título cancelado com sucesso');
end;

procedure TControleConsultaTituloReceber.UniTimer1Timer(Sender: TObject);
begin
  inherited;
  if UniLabelValorRestante.Font.Color = clGray then
    UniLabelValorRestante.Font.Color := clGreen
  else
    UniLabelValorRestante.Font.Color := clGray;
end;

procedure TControleConsultaTituloReceber.BotaoAbrirClick(Sender: TObject);
begin
    ControleCadastroTituloReceber.Abrir(CdsConsultaID.AsInteger);
    ControleCadastroTituloReceber.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
//      if Result = 1 then
        CdsConsulta.Refresh;
    end);
end;

procedure TControleConsultaTituloReceber.BotaoAlteraDataClick(Sender: TObject);
begin
  inherited;
  AlteraDataTitulo;
end;

procedure TControleConsultaTituloReceber.BotaoAlteraValorClick(Sender: TObject);
begin
  inherited;
  AlteraValorTitulo;
end;

procedure TControleConsultaTituloReceber.BotaoAtualizarClick(Sender: TObject);
var
  bJSName :string;
begin
  //inherited;
  if ControleMainModule.PLiquidaMultiploReceber  = 'S' then
  begin
    bJSName := (BotaoQuitarTitulo).JSName;
    UniSession.AddJS(bJSName + '.setBadgeText(' + bJSName + '.getBadgeText() -'+ IntToStr(QtdTituloParaBaixar) +');');
  end;

  CdsConsulta.Close;
  CdsConsulta.Open;
  QtdTituloParaBaixar := 0;
end;

procedure TControleConsultaTituloReceber.BotaoCancelarTituloClick(
  Sender: TObject);

begin
  if (CdsConsultaSITUACAO.AsString = 'INADIMPLENTE') or (CdsConsultaSITUACAO.AsString = 'ABERTO') then
    UniSweetCancelarTitulo.show
  else
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Só é possível para títulos em aberto',atInfo);
end;

procedure TControleConsultaTituloReceber.BotaoNegociarTitulosClick(
  Sender: TObject);
var
  bJSName : string;
  verificaCaixaFechadoDeHojeParaUsuario: Integer;
begin
  inherited;

  // Verifica se o usuario tem algum caixa para o dia de hoje que esta fechado
  verificaCaixaFechadoDeHojeParaUsuario := ControleMainModule.VerificaCaixaFechadoDoDia(ControleMainModule.FUsuarioId,
                                                                                        Date());

  // Verifica se o usuario tem algum caixa para o dia de hoje que esta fechado
  if verificaCaixaFechadoDeHojeParaUsuario > 0 then
  begin
    ControleMainModule.ReabreCaixa(ControleMainModule.FNumeroCaixaLogado);
  end;

  if CdsTitulosGerar.RecordCount = 0 then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Selecione pelo menos um título para calcular os juros!');
    Exit;
  end;

  ControleOperacoesIntegracaoCalculoJuros.UniEdtValorOriginal.Text   := CdsTitulosGerarSomaValorTotal.AsString;
  ControleOperacoesIntegracaoCalculoJuros.UniEdtDiasAtraso.Text      := CdsTitulosGerarMediaDiasAtraso.AsString;
  ControleOperacoesIntegracaoCalculoJuros.UniEdtMultaAtraso.Text     := FloatToStr(ControleMainModule.percentual_multa);
  ControleOperacoesIntegracaoCalculoJuros.UniEdtJurosMes.Text        := FloatToStr(ControleMainModule.percentual_juros);
  ControleOperacoesIntegracaoCalculoJuros.UniDateTituloOriginal.Text := CdsConsultaDATA_VENCIMENTO.AsString;

  ControleOperacoesIntegracaoCalculoJuros.ShowModal(procedure(Sender: TComponent; Result: Integer)
  begin
    if Result = 1 then
    begin
      ControleOperacoesIntegracaoNegociarTituloReceber.UniDataVencimento.Text := ControleOperacoesIntegracaoCalculoJuros.UniDateTitulo.Text;
      ControleOperacoesIntegracaoNegociarTituloReceber.UniEdtValor.Text       := ControleOperacoesIntegracaoCalculoJuros.UniEdtValorAtualizado.Text;

      ControleOperacoesIntegracaoNegociarTituloReceber.CdsTitulosGerado := CdsTitulosGerar;

      // Verifica se tem permissão para negociar títulos de clientes diferentes
      if ControleMainModule.negociar_titulo_varios_clientes = 'N' then
      begin
        // Envia o cliente para o formulario e bloqueia a alteração/cadastro de clientes
        ControleOperacoesIntegracaoNegociarTituloReceber.UnibtnConsultaCliente.Enabled := False;
        ControleOperacoesIntegracaoNegociarTituloReceber.PessoaId                      := CdsConsultaCLIENTE_ID.AsInteger;
        ControleOperacoesIntegracaoNegociarTituloReceber.UniEdtResponsavel.Text        := CdsConsultaCLIENTE.AsString;
        ControleOperacoesIntegracaoNegociarTituloReceber.OperacaoTitulos               := 'Ped. Negociação nº ';
      end
      else
        ControleOperacoesIntegracaoNegociarTituloReceber.UnibtnConsultaCliente.Enabled := True;

      ControleOperacoesIntegracaoNegociarTituloReceber.ShowModal(procedure(Sender: TComponent; Result: Integer)
      begin
        if Result = 1 then
        begin
          CdsTitulosGerar.First;
          while not CdsTitulosGerar.Eof do
          begin
            if CdsConsulta.Locate('id', CdsTitulosGerar.FieldByName('NUMERO_REFERENCIA').AsString, []) then
            begin
              CdsConsulta.Edit;
              CdsConsultaNegociado.AsString := 'N';
              CdsConsulta.Post;

              //MUDA STATUS DE TITULO ATUAL PARA NEGOCIADO
              with ControleMainModule do
              begin
                if ADOConnection.Intransaction = False then
                  ADOConnection.BeginTrans;

                CdsAx4.Close;
                QryAx4.Parameters.Clear;
                QryAx4.SQL.Clear;
                QryAx4.SQL.Text :=
                                'UPDATE titulo            '
                              + '   SET situacao  = ''N'' '
                              + ' WHERE id        = :id   ';
                QryAx4.Parameters.ParamByName('id').Value := CdsConsultaID.AsInteger;

                try
                  // Tenta salvar os dados PASSO 4º
                  QryAx4.ExecSQL;
                  ADOConnection.CommitTrans;
                except
                on E: Exception do
                  begin
                    ADOConnection.RollbackTrans;
                    ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));
                  end;
                 end;
               end;
            end;
            CdsTitulosGerar.Next;
          end;

          CdsTitulosGerar.First;
          while not CdsTitulosGerar.Eof do
          begin
            CdsTitulosGerar.Delete;
          end;

          //zera Badge do negociar.
          bJSName := (BotaoNegociarTitulos).JSName;
          UniSession.AddJS(bJSName + '.setBadgeText(' + bJSName + '.getBadgeText() -'+ IntToStr(QtdNegociado) +');');
          CPF_CNPJ_Negociado := '';

          cdsconsulta.Refresh;
        end;
      end);
    end;
  end
  );
end;

procedure TControleConsultaTituloReceber.BotaoQuitarTituloClick(
  Sender: TObject);
var
  verificaCaixaFechadoDeHojeParaUsuario: Integer;
begin
  inherited;

  // Verifica se o usuario tem algum caixa para o dia de hoje que esta fechado
  verificaCaixaFechadoDeHojeParaUsuario := ControleMainModule.VerificaCaixaFechadoDoDia(ControleMainModule.FUsuarioId,
                                                                                        Date());

  // Verifica se o usuario tem algum caixa para o dia de hoje que esta fechado
  if verificaCaixaFechadoDeHojeParaUsuario > 0 then
  begin
    ControleMainModule.ReabreCaixa(ControleMainModule.FNumeroCaixaLogado);
  end;

  if QtdTituloParaBaixar <> 0 then
  begin
   ControleConsultaBaixarMultiplosReceber.Abrir(CdsBaixaMultiploConta.AsString,CdsBaixaMultiploSomaTotal.AsString);
   ControleConsultaBaixarMultiplosReceber.CdsBaixaMultiplo.CloneCursor(CdsBaixaMultiplo,False,False);
   ControleConsultaBaixarMultiplosReceber.ShowModal(procedure(Sender: TComponent; Result: Integer)
   begin
     if ControleConsultaBaixarMultiplosReceber.Baixado = True then
     begin
       CdsConsultaLote.close;
       CdsConsultaLote.Params.ParamByName('NUMERO_LOTE').AsString := IntToStr(ControleConsultaBaixarMultiplosReceber.numero_lote_id);
       CdsConsultaLote.Open;

       UniSweetAlertImprimirBaixa.show;
     end;
   end);
  end
  else
  begin
    if (CdsConsultaSITUACAO.AsString = 'ABERTO')
    or (CdsConsultaSITUACAO.AsString = 'INADIMPLENTE')
    or (CdsConsultaSITUACAO.AsString = 'PARCIAL')then
    begin
      ControleCadastroBaixarTituloReceber.CalculoParaBaixa(CdsConsultaId.AsInteger,
                                                    CdsConsultaVALOR_DESCONTO.AsFloat);

      ControleCadastroBaixarTituloReceber.ShowModal(procedure(Sender: TComponent; Result: Integer)
      begin
  //         if Result = 1 then
          CdsConsulta.Refresh;
      end);
    end
    else
      ControleMainModule.MensageiroSweetAlerta('Atenção', 'Só é permitido receber o título em situação aberto ou inadimplente.');
  end;
end;

procedure TControleConsultaTituloReceber.cadastro1Click(Sender: TObject);
begin
  AbreAnexos;
end;

procedure TControleConsultaTituloReceber.CdsConsultaAfterRefresh(
  DataSet: TDataSet);
begin
  inherited;

  AtualizaLabeltotal;
  AtualizaLabeltotalComAcrescimo;
  AtualizaLabeltotalRestante;
end;

procedure TControleConsultaTituloReceber.CdsConsultaPOSSUI_ANEXOGetText(
  Sender: TField; var Text: string; DisplayText: Boolean);
begin
  inherited;
  if CdsConsultaNEGOCIADO.AsString <> 'S' then
  begin
    if CdsConsultaPOSSUI_ANEXO.AsString = 'S' then
      Text := '<img src=./files/icones/opanexo.png height=22 align="center" />'
    else
      Text := '<img src=./files/icones/opcoes.png height=22 align="center" />'
  end
  else
    Text := '<img src=./files/icones/opcoes_negociacao.png height=22 align="center" />';
end;

procedure TControleConsultaTituloReceber.Cheque1Click(Sender: TObject);
begin
  inherited;
  ControleCadastroCheque.Abrir(CdsConsultaID.AsInteger);
  ControleCadastroCheque.ShowModal;
end;

procedure TControleConsultaTituloReceber.ConferenciaAssinatura1Click(
  Sender: TObject);
begin
  inherited;
  if ControleOperacoesConferenciaAssinatura.abrir(CdsConsultaCLIENTE_ID.AsInteger) then
    ControleOperacoesConferenciaAssinatura.ShowModal
  else
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Não exite imagens de assinaturas para serem conferidas. Verifique se no cadastro do cliente a assinatura foi adicionada ou se o título foi assinado.');
    ControleOperacoesConferenciaAssinatura.Close;
  end;

end;

procedure TControleConsultaTituloReceber.ConsultaTitulosMes(DataInicial, DataFinal: String;
                                                            FullConsulta: string ='N');
begin
  if FullConsulta = 'N' then
  begin
    CdsConsulta.Params.ParamByName('vencimento_inicial').Value := DataInicial;
    CdsConsulta.Params.ParamByName('vencimento_final').Value   := DataFinal;
  end
  else if FullConsulta = 'S' then
  begin
    CdsConsulta.Params.ParamByName('vencimento_inicial').Value := '01/01/2000';
    CdsConsulta.Params.ParamByName('vencimento_final').Value   := '31/12/2099';
  end;

  CdsConsulta.Filtered := True;
  if CdsConsulta.Active = False then
    CdsConsulta.Open;
  CdsConsulta.Refresh;

  AtualizaLabeltotal;
  AtualizaLabeltotalComAcrescimo;
  AtualizaLabeltotalRestante;
end;

procedure TControleConsultaTituloReceber.GrdResultadoCellClick(
  Column: TUniDBGridColumn);
begin
  inherited;
  if Column.FieldName = 'POSSUI_ANEXO' then
  begin
    //desativa todos os menus
    DesabilitaMenusOpcoes(UniPopupMenuOpcoes);

    //habilita menu com base no CONDIÇÃO DE PAGAMENTO
    if CdsConsultaGERA_CARNE.AsString = 'S' then
    begin
      UniPopupMenuOpcoes.Items[5].Visible := True; //Imprimir carnê
      UniPopupMenuOpcoes.Items[7].Visible := True; //Conferência de assinatura
    end
    else if CdsConsultaGERA_BOLETO.AsString = 'S' then
    begin
      UniPopupMenuOpcoes.Items[2].Visible := true; //compartilha whastapp
      UniPopupMenuOpcoes.Items[3].Visible := true; //Compartilha por e-mail
    end
    else if CdsConsultaGERA_CHEQUE.AsString = 'S' then
    begin
     UniPopupMenuOpcoes.Items[6].Visible := True; //Dados do cheque
    end;

    //habilita menu com base na SITUAÇÃO
    case AnsiIndexStr(CdsConsulta.FieldByName('SITUACAO').AsString,['LIQUIDADO','INADIMPLENTE','PARCIAL','ABERTO']) of
      0:begin
          UniPopupMenuOpcoes.Items[4].Visible := True; //Imprimir recibo
        end;
      1:begin
          UniPopupMenuOpcoes.Items[8].Visible := True; //Marca para negociação
          UniPopupMenuOpcoes.Items[12].Visible := True; //Excluir título a receber
        end;
      2:begin
          UniPopupMenuOpcoes.Items[4].Visible := True; //Marca para negociação
        end;
      3:begin
          UniPopupMenuOpcoes.Items[12].Visible := True; //Excluir título a receber
        end;

    end;

    if CdsConsultaNUMERO_LOTE.AsString <> '0' then
     UniPopupMenuOpcoes.Items[9].Visible := True; //Imprime baixa lote

    if CdsConsultaNUMERO_REFERENCIA.AsString <> '' then
     UniPopupMenuOpcoes.Items[10].Visible := True; //Imprime lista de produtos

    UniPopupMenuOpcoes.Items[11].Visible := True; //imprime promissoria
    UniPopupMenuOpcoes.Items[1].Visible := True; //Visualiza/Anexa documentos disponível para todos
    UniPopupMenuOpcoes.Items[13].Visible := True; //Visualiza/Anexa débitos do cliente
    UniPopupMenuOpcoes.Popup(ControleMain.PosicaoMouseX +10,ControleMain.PosicaoMouseY +10);
  end;
end;

procedure TControleConsultaTituloReceber.Dbitosdocliente1Click(Sender: TObject);
begin
  inherited;
  UniSweetAlertJuros.InputValue := FloatToStr(ControleMainModule.percentual_juros);
  UniSweetAlertJuros.show;
end;

procedure TControleConsultaTituloReceber.DesabilitaMenusOpcoes(Popup: TUniPopupMenu);
var
  i : integer;
begin
  for i := 0 to Popup.Items.Count - 1 do begin
   Popup.Items[i].Visible := False;
  end;
end;


procedure TControleConsultaTituloReceber.GrdResultadoColumnFilter(
  Sender: TUniDBGrid; const Column: TUniDBGridColumn; const Value: Variant);
begin
  inherited;
  VerificaIntervalo;
end;

procedure TControleConsultaTituloReceber.GrdResultadoColumnSummaryResult(
  Column: TUniDBGridColumn; GroupFieldValue: Variant; Attribs: TUniCellAttribs;
  var Result: string);
{ var
  I : Integer;
  F : Real;}
begin
  inherited;
{  if SameText(Column.FieldName, 'VALOR') then
  begin
    F:=Column.AuxValue;
    Result:='Total Cost: ' + FormatCurr('0,0.00 ', F) + FmtSettings.CurrencyString;
    Attribs.Font.Style:=[fsBold];
    Attribs.Font.Color:=clNavy;
  end;
  Column.AuxValue:=NULL;}
end;


procedure TControleConsultaTituloReceber.GrdResultadoDrawColumnCell(
  Sender: TObject; ACol, ARow: Integer; Column: TUniDBGridColumn;
  Attribs: TUniCellAttribs);
begin
  inherited;
  if Column.FieldName = 'SITUACAO' then
  begin
    if CdsConsultaSITUACAO.AsString = 'ABERTO' then
      Attribs.Font.Color := clBlue
    else if CdsConsultaSITUACAO.AsString = 'INADIMPLENTE' then
      Attribs.Font.Color := clRed
    else if CdsConsultaSITUACAO.AsString = 'PARCIAL' then
      Attribs.Font.Color := clOlive
    else if CdsConsultaSITUACAO.AsString = 'LIQUIDADO' then
      Attribs.Font.Color := clGreen
    else if CdsConsultaSITUACAO.AsString = 'NEGOCIADO' then
      Attribs.Font.Color := clPurple
    else if CdsConsultaSITUACAO.AsString = 'CANCELADO' then
      Attribs.Font.Color := clWebOrange
  end;
end;

procedure TControleConsultaTituloReceber.Imprimirbaixadelote1Click(
  Sender: TObject);
begin
  inherited;
  ImprimeLote;
end;

procedure TControleConsultaTituloReceber.ImprimeLote;
begin
  CdsConsultaLote.close;
  CdsConsultaLote.Params.ParamByName('NUMERO_LOTE').AsString := CdsConsultaNUMERO_LOTE.AsString;
  CdsConsultaLote.Open;

  frxReport_baixa_receber.Variables.Variables['RazaoEmpresa'] := QuotedStr(ControleMainModule.FRazaoSocial);
  ControleMainModule.ExportarPDF('Relatorio',frxReport_baixa_receber);
end;

procedure TControleConsultaTituloReceber.ImprimirCarn1Click(Sender: TObject);
var
  caminho_logo : string;
begin
  inherited;

  caminho_logo := ControleMainModule.CdsFilial.fieldByName('logomarca_caminho').Asstring;

  CdsconsultaCarne.Close;
  CdsconsultaCarne.Params.ParamByName('numero_documento').Value  := CdsConsulta.FieldByName('numero_documento').AsString;//ControleMainModule.NumeroDocumentoTitulo;
  CdsconsultaCarne.Open;


  if ( FileExists(caminho_logo) and (frxReport1.FindComponent('Picture2')<> nil ) ) then
  begin
    TfrxPictureView(frxReport1.FindComponent('Picture2')).Visible := True;
    TfrxPictureView(frxReport1.FindComponent('Picture2')).Picture.LoadFromFile(caminho_logo);
  end
  else
  begin
    TfrxPictureView(frxReport1.FindComponent('RazaoEmpresa')).Visible := True;
    frxReport1.Variables.Variables['RazaoEmpresa'] := QuotedStr(ControleMainModule.FRazaoSocial);
  end;

//  TfrxPictureView(frxReport1.FindObject('Picture2')).Picture.LoadFromFile(ControleMainModule.CdsFilial.fieldByName('logomarca_caminho').Asstring);
  ControleMainModule.ExportarPDF('Relatorio',frxReport1);
//  ControleMainModule.NumeroDocumentoTitulo :='0';
end;

procedure TControleConsultaTituloReceber.Imprimirrecibo1Click(Sender: TObject);
begin
//  inherited;
  CdsConsParcelas.Close;
  QryConsParcelas.Parameters.ParamByName('id').Value := CdsConsultaID.AsString;
  CdsConsParcelas.Open;

  CdsConsultaClone.CloneCursor(CdsConsulta,True,True);

  Try
    CdsConsultaClone.Close;
    CdsConsultaClone.Filtered := False;
    CdsConsultaClone.Filter := 'id = ' + CdsConsultaID.AsString;
    CdsConsultaClone.Filtered := True;
    CdsConsultaClone.Open;
  except
    on e:Exception do
    begin
      ShowMessage(e.Message);
    end;
  End;

  if CdsConsultaClone.RecordCount >0 then
  begin
    Conexao_Recibo.DataSet := CdsConsultaClone;

    Relatorio_Recibo.Variables.Variables['RazaoEmpresa'] := QuotedStr(ControleMainModule.FRazaoSocial);
    ControleMainModule.ExportarPDF('Relatorio',Relatorio_Recibo);
    //Relatorio_Recibo.ShowReport();
  end
  else
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Não existe registros a serem exibidos.');
  end;
end;

function TControleConsultaTituloReceber.ConverterDataGerencianet(dataGerencianet: string): TDateTime;
var
  novadata, dia, mes, ano, hora, minuto, segundo: String;
begin
  dia      := copy(dataGerencianet, 9, 2);
  mes      := copy(dataGerencianet, 6, 2);
  ano      := copy(dataGerencianet, 1, 4);
  hora     := copy(dataGerencianet, 12, 2);
  minuto   := copy(dataGerencianet, 15, 2);
  segundo  := copy(dataGerencianet, 18, 2);
  novadata :=  dia + '/' + mes + '/' + ano + ' ' + hora + ':' + minuto + ':' + segundo;
  Result   := StrToDateTime(novadata);
end;

Procedure TControleConsultaTituloReceber.AlteraDataParcelaCarne(Sender: TComponent; AResult:Integer; AText: string);
var
  Body : String;
  UpdateParcelParams : String;
  Retorno : String;
begin
  if AResult = mrOK then
  begin
    Try
      if StrToDate(AText) >= Date then
      begin
        if StrToDate(AText) < CdsConsultaDATA_VENCIMENTO.AsDateTime then
        begin
          ControleMainModule.MensageiroSweetAlerta('Atenção', 'Só é possível alterar a data para no mínimo 5(cinco) dias após o vencimento');
          Exit;
        end
      end
      else
      begin
        ControleMainModule.MensageiroSweetAlerta('Atenção', 'A data não pode ser menor que a data atual');
        Exit;
      end;
    Except
      on e:exception do
      begin
        ControleMainModule.MensageiroSweetAlerta('Atenção', 'Por favor, digite uma data válida');
        Exit;
      end;
    End;
  end;
end;

Procedure TControleConsultaTituloReceber.AlteraCelular(Sender: TComponent; AResult:Integer; AText: string);
var
  URL_WhatsApp: String;
begin
  if AResult = mrOK then
  begin
  //URL_WhatsApp := 'https://web.whatsapp.com/send?phone=55' + ControleFuncoes.RemoveMascara(AText) + '?text=' + '%20' + 'Prezado cliente, segue o link do boleto da empresa ' + ControleMainModule.FNomeFantasia +' : '+ CdsConsultaLINK_WHATSAPP.AsString + '%20';
  //URL_WhatsApp := 'https://wa.me/55' + ControleFuncoes.RemoveMascara(AText) + '?text=' + '%20' + 'Prezado cliente, segue o link do boleto da empresa ' + ControleMainModule.FNomeFantasia +' : '+ CdsConsultaLINK_WHATSAPP.AsString + '%20';
  //UniSession.AddJS('window.open('+'"'+ URL_WhatsApp + '"'+')');
  end;
end;

Procedure TControleConsultaTituloReceber.AlteraDataParcela(Sender: TComponent; AResult:Integer; AText: string);

begin
  if AResult = mrOK then
  begin
    Try
      if StrToDate(AText) < CdsConsultaDATA_VENCIMENTO.AsDateTime then
      begin
        ControleMainModule.MensageiroSweetAlerta('Atenção', 'Não é possível antecipar o vencimento');
        Exit;
      end
    Except
      on e:exception do
      begin
        ControleMainModule.MensageiroSweetAlerta('Atenção', 'Por favor, digite uma data válida');
        Exit;
      end;
    End;


    if ControleMainModule.AtualizaDataTitulo(StrToDate(AText),
                                             CdsConsultaID.AsInteger) then
    begin
      CdsConsulta.Refresh;
      ControleMainModule.MensageiroSweetAlerta('Atenção', 'Data alterada com sucesso',atSuccess);
    end;
  end;
end;

Procedure TControleConsultaTituloReceber.AlteraValorParcela(Sender: TComponent; AResult:Integer; AText: string);
var
  ValorString: string;
  ValorDouble: double;
begin
  if AResult = mrOK then
  begin
    ValorString := AText;
    if not TryStrToFloat(ValorString, ValorDouble) then
    begin
      ControleMainModule.MensageiroSweetAlerta('Atenção', 'Digite um valor válido');
      Exit;
    end;

    if StrToFloat(AText) < 0 then
    begin
      ControleMainModule.MensageiroSweetAlerta('Atenção', 'Digite um valor válido');
      Exit;
    end;

    if ControleMainModule.AtualizaValorTitulo(AText,
                                         CdsConsultaID.AsInteger) = True then
    begin
      CdsConsulta.Refresh;
      ControleMainModule.MensageiroSweetAlerta('Atenção', 'Valor alterado com sucesso',atSuccess);
    end;
  end;
end;

procedure TControleConsultaTituloReceber.AbreAnexos;
begin
  ControleMainModule.titulo_id_m := CdsConsultaID.AsInteger;
  ControleOperacoesTituloReceberDocumentos.ShowModal(procedure(Sender: TComponent; Result: Integer)
  begin
//    if Result = 1 then
      Cdsconsulta.Refresh;
  end);
end;

procedure TControleConsultaTituloReceber.Visualizarttulo1Click(Sender: TObject);
begin
  VisualizaTitulo;
end;

procedure TControleConsultaTituloReceber.VisualizaTitulo;
begin
//  if CdsConsultaSITUACAO.AsString = 'ABERTO' then
//  begin
//    if CdsConsultaTIPO_TITULO.AsString = 'CARNE' then
//    begin
//      if CdsConsultaLINK_BOLETO.AsString <> '' then
//      begin
//        ControleImpressaoCarne.titulo_id := CdsConsultaID.AsInteger;
//        ControleImpressaoCarne.ShowModal();
//      end
//      else
//      begin
//        //CarregaCarne(CdsConsultaID.AsInteger);
//      end;
//    end
//    else if CdsConsultaTIPO_TITULO.AsString = 'BOLETO' then
//    begin
//      ControleImpressaoCarne.titulo_id := CdsConsultaID.AsInteger;
//      ControleImpressaoCarne.ShowModal();
//    end
//    else
//      ControleMainModule.MensageiroSweetAlerta('Atenção', 'Esse tipo de título não possui impressão disponível');
//  end
//  else
//    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Só é possível para títulos em aberto');
end;

//procedure TControleConsultaTituloReceber.EnviaTituloWhatsapp;
//begin
//  if CdsConsultaSITUACAO.AsString = 'ABERTO' then
//  begin
//    if CdsConsultaTIPO_TITULO.AsString = 'CARNE' then
//    begin
//      if CdsConsultaLINK_BOLETO.AsString <> '' then
//      begin
//        // Abrindo o numero de telefone para o usuario alterar,se desejar
//        Prompt('Confirme o celular.',
//               CdsConsultaCELULAR.AsString,
//               mtConfirmation,
//               mbOKCancel,
//               AlteraCelular);
//      end
//      else
//      begin
//        ControleMainModule.MensageiroSweetAlerta('Atenção', 'Esse tipo de título não possui impressão disponível');
//      end;
//    end
//    else if CdsConsultaTIPO_TITULO.AsString = 'BOLETO' then
//    begin
//      if CdsConsultaLINK_BOLETO.AsString <> '' then
//      begin
//        // Abrindo o numero de telefone para o usuario alterar,se desejar
//        Prompt('Confirme o celular.',
//               CdsConsultaCELULAR.AsString,
//               mtConfirmation,
//               mbOKCancel,
//               AlteraCelular);
//      end
//      else
//      begin
//        ControleMainModule.MensageiroSweetAlerta('Atenção', 'Esse tipo de título não possui impressão disponível');
//      end;
//    end
//    else
//    begin
//      ControleMainModule.MensageiroSweetAlerta('Atenção', 'Esse tipo de título não possui impressão disponível');
//    end;
//  end
//  else
//  begin
//    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Só é possível para títulos em aberto');
//  end;
//end;

//procedure TControleConsultaTituloReceber.EnviaBoletoCarneParcelaEmail;
//begin
//  if CdsConsultaTIPO_TITULO.AsString = 'BOLETO' then
//  begin
//    if CdsConsultaSITUACAO.AsString = 'ABERTO' then
//    begin
//      if CdsConsultaLINK_BOLETO.AsString <> '' then
//      begin
//        Prompt('Confirme ou altere o email',
//               ControleMainModule.SelecionaEmail(CdsConsultaCLIENTE_ID.AsInteger),
//               mtConfirmation,
//               mbOKCancel,
//               EnviaCarneParcelaEmailBoleto);
//      end
//      else
//      begin
//        ControleMainModule.MensageiroSweetAlerta('Atenção', 'Essa opção só pode ser usada por títulos que geram boletos');
//      end;
//    end
//    else
//    begin
//      ControleMainModule.MensageiroSweetAlerta('Atenção', 'Só é possível para títulos em aberto');
//    end;
//  end
//  else
//  begin
//    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Essa modalidade não permite reenvio');
//  end;
//end;

procedure TControleConsultaTituloReceber.EditPesquisaIdKeyPress(Sender: TObject;
  var Key: Char);
var
  bJSName : string;
begin
  inherited;
    //Adiciona B
  if ControleMainModule.PLiquidaMultiploPagar ='S' then
  begin
    if Key = #13 then
    begin
      if (CdsConsultaSITUACAO.AsString = 'ABERTO')
      or (CdsConsultaSITUACAO.AsString = 'INADIMPLENTE')
      or (CdsConsultaSITUACAO.AsString = 'PARCIAL')then
      begin
        if CdsBaixaMultiplo.Locate('Id',CdsConsultaID.AsInteger,[]) = False then
        begin
          // Alimentando o cds temporario
          CdsBaixaMultiplo.Insert;
          CdsBaixaMultiploID.AsInteger                 := CdsConsultaID.AsInteger;
          CdsBaixaMultiploVALOR.AsFloat                := CdsConsultaVALOR_SALDO.AsFloat;
          CdsBaixaMultiploCLIENTE.AsString             := CdsConsultaCLIENTE.AsString;
          CdsBaixaMultiploVENCIMENTO.AsDateTime        := CdsConsultaDATA_VENCIMENTO.AsDateTime;
          CdsBaixaMultiploCONTA_BANCARIA_ID.AsString   := CdsConsultaCONTA_BANCARIA_ID.AsString;
          CdsBaixaMultiploSEQUENCIA_PARCELAS.AsString  := CdsConsultaSEQUENCIA_PARCELAS.AsString;
          CdsBaixaMultiploTITULO_CATEGORIA_ID.AsString := CdsConsultaTITULO_CATEGORIA_ID.AsString;
          CdsBaixaMultiploCLIENTE_ID.AsInteger         := CdsConsultaCLIENTE_ID.AsInteger;
          CdsBaixaMultiploDIAS_ATRASO.AsInteger        := CdsConsultaDIAS_ATRASO.AsInteger;
          CdsBaixaMultiploNUMERO_CARNE.AsString        := CdsConsultaNUMERO_CARNE.AsString;
          CdsBaixaMultiplo.Post;

          QtdTituloParaBaixar := QtdTituloParaBaixar +1;
          bJSName := (BotaoQuitarTitulo).JSName;
          UniSession.AddJS(bJSName + '.setBadgeText(' + bJSName + '.getBadgeText() + 1);');
        end
        else
        begin
          CdsBaixaMultiplo.Delete;

          QtdTituloParaBaixar := QtdTituloParaBaixar +1;
          bJSName := (BotaoQuitarTitulo).JSName;
          UniSession.AddJS(bJSName + '.setBadgeText(' + bJSName + '.getBadgeText() - 1);');
        end;
      end;
      EditPesquisaId.SelectAll;
      EditPesquisaId.SetFocus;
    end;
    CdsConsulta.Refresh;
  end;
end;

procedure TControleConsultaTituloReceber.EnviaCarneParcelaEmailBoleto(
  Sender: TComponent; AResult: Integer; AText: string);
begin

end;

procedure TControleConsultaTituloReceber.AlteraValorTitulo;
begin
  if (CdsConsultaSITUACAO.AsString = 'ABERTO')
  or (CdsConsultaSITUACAO.AsString = 'INADIMPLENTE')
  or (CdsConsultaSITUACAO.AsString = 'PARCIAL') then
  begin
    Prompt('Digite o novo valor da parcela.',
           CdsConsultaVALOR.AsString,
           mtConfirmation,
           mbOKCancel,
           AlteraValorParcela);
  end
  else
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Não é possível negociar um título '+ CdsConsultaSITUACAO.AsString);
    Exit;
  end;
end;

procedure TControleConsultaTituloReceber.Apagarttulo1Click(Sender: TObject);
begin
  inherited;
  UniSweetAlertExcluirTítuloReceber.Show;
end;

procedure TControleConsultaTituloReceber.AlteraDataTitulo;
begin
  if (CdsConsultaSITUACAO.AsString = 'ABERTO')
  or (CdsConsultaSITUACAO.AsString = 'INADIMPLENTE')
  or (CdsConsultaSITUACAO.AsString = 'PARCIAL') then
  begin
    if CdsConsultaGERA_BOLETO.AsString = 'S' then
    begin
      //InputBox('Informe o novo vencimento','Vencimento: ',DateToStr(Date));
      Prompt('Digite nova data de vencimento.',
           DateToStr(CdsConsultaDATA_VENCIMENTO.AsDateTime),
           mtConfirmation,
           mbOKCancel,
           AlteraDataParcelaCarne);
    end
    else
    begin
       Prompt('Digite nova data de vencimento.',
           DateToStr(CdsConsultaDATA_VENCIMENTO.AsDateTime),
           mtConfirmation,
           mbOKCancel,
           AlteraDataParcela);
    end;
  end
  else
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Não é possível negociar um título '+ CdsConsultaSITUACAO.AsString);
    Exit;
  end;
end;

procedure TControleConsultaTituloReceber.VerificaIntervalo(fullconsulta : string ='');
begin
  if UniCheckBoxIntervalo.Checked = True then
  begin
    UniPanelIntervalo.Enabled := False;
    CdsConsulta.Filtered := False;

    if fullconsulta = 'S' then
    begin
      ConsultaTitulosMes(DateToStr(UniDateTimePickerInicial.DateTime),
                       DateToStr(UniDateTimePickerFinal.DateTime),
                       fullconsulta);
    end
  end
  else
  begin
    UniPanelIntervalo.Enabled := True;
    if fullconsulta = 'S' then
    begin
      ConsultaTitulosMes(DateToStr(UniDateTimePickerInicial.DateTime),
                       DateToStr(UniDateTimePickerFinal.DateTime),
                       fullconsulta);
    end
    else
    begin
      ConsultaTitulosMes(DateToStr(UniDateTimePickerInicial.DateTime),
                       DateToStr(UniDateTimePickerFinal.DateTime));
    end;
  end;

  AtualizaLabeltotal;
  AtualizaLabeltotalComAcrescimo;
  AtualizaLabeltotalRestante;
end;

function TControleConsultaTituloReceber.Verificase_Cliente_Negociar_e_igual(CNPJ_CPF_cliente: String):Boolean;
begin
  Result := True;

  // Verifica se o cnpj é igual ao que guardou na variavel a primeira vez
  if CPF_CNPJ_Negociado <> CNPJ_CPF_cliente then
    Result := False;
end;


procedure TControleConsultaTituloReceber.PreencheFiltrosGrid;
begin
  //preenche combo com as condições de COBRANÇA
  With ComBoxCondicoesPagamento do
  begin
    Clear;
    CdsCondicoesPagamento.Close;
    CdsCondicoesPagamento.Open;
    CdsCondicoesPagamento.First;
    while not CdsCondicoesPagamento.eof do
    begin
      Items.Add(CdsCondicoesPagamentoDESCRICAO.AsString);
      CdsCondicoesPagamento.Next;
    end;
  end;


   // Preenchendo o combo para consulta da categoria
  With UniComboBox3 do
  begin
    Clear;
    CdsTituloCategoria.Close;
    CdsTituloCategoria.Open;
    CdsTituloCategoria.First;
    while not CdsTituloCategoria.eof do
    begin
      Items.Add(CdsTituloCategoriaDESCRICAO.AsString);
      CdsTituloCategoria.Next;
    end;
  end;
end;

procedure TControleConsultaTituloReceber.Produtosdopedido1Click(
  Sender: TObject);
  var
    Sql : string;
begin
  inherited;
  // Se a conexão existe verificamos se o pedido é oriundo de integração
  if Copy(Cdsconsultahistorico.AsString,1,15) = 'Ped. Integração' then
  begin
    PesquisaProdutosFirebirdIntegracao;
    Exit;
  end;

  with ControleMainModule do
  begin
    if CdsConsultaNUMERO_REFERENCIA.AsString = '' then
    begin
      MensageiroSweetAlerta('Atenção', 'Não existe numero de referencia para esse título',atWarning);
      Exit;
    end;

    if FSchemaPdve = '' then
    begin
      MensageiroSweetAlerta('Atenção','O Schema do Pdv-e não foi configurado no config.ini!');
      Exit;
    end;

    Sql := '';

    CdsProdutoPdve.Close;
    QryProdutoPdve.SQL.Clear;
    QryProdutoPdve.Parameters.Clear;
    Sql := '	SELECT'
          +'    pvi.produto_id,'
          +'    p.descricao,'
          +'		pvi.quantidade,'
          +'		pvi.valor_unitario,'
          +'		pvi.subtotal,'
          +'		pvi.desconto,'
          +'		pvi.valor_total,'
          +'		to_char(pvi.data_inclusao,''dd/mm/yyyy'') data_inclusao,'
          +'		pvi.numero_item_cupom,'
          +'		PVI.CANCELADO,'
          +'    PVI.PEDIDO_VENDA_ID,'
          +'    PES.NOME_FANTASIA NOME_VENDEDOR'
          +'	FROM '+ FSchemaPdve +'.pedido_venda_item pvi'
          +'  INNER JOIN '+ FSchemaPdve +'.produto p ON pvi.produto_id = p.id'
          +'  INNER JOIN '+ FSchemaPdve +'.pedido_venda pv ON PVI.PEDIDO_VENDA_ID = PV.ID'
          +'  LEFT JOIN '+ FSchemaPdve +'.VENDEDOR VEN ON VEN.ID = PV.VENDEDOR_ID'
          +'  LEFT JOIN '+ FSchemaPdve +'.PESSOA PES ON PES.ID = VEN.ID'
          +'	where PVI.PEDIDO_VENDA_ID = :id';

    QryProdutoPdve.SQL.Text := Sql;
    QryProdutoPdve.SQL.SaveToFile('ref.txt');
    QryProdutoPdve.Parameters.ParamByName('id').Value := CdsConsultaNUMERO_REFERENCIA.AsString;
    CdsProdutoPdve.Open;

    if CdsProdutoPdve.RecordCount > 0 then
    begin
      Relatorio_ProdutosPdve.Variables.Variables['RazaoEmpresa'] := QuotedStr(FRazaoSocial);
      Relatorio_ProdutosPdve.Variables.Variables['NumeroTitulo'] := QuotedStr(CdsConsultaID.AsString);
      ExportarPDF('Relatorio',Relatorio_ProdutosPdve);
//      Relatorio_ProdutosPdve.ShowReport();
    end;

    if CdsProdutoPdve.RecordCount = 0 then
    begin
      MensageiroSweetAlerta('Atenção', 'Não existe numero de referencia para esse título.',atWarning);
    end;
  end;
end;

procedure TControleConsultaTituloReceber.RetornaValoresSeparados(texto: string;
                                                                 caractereSeparador: string);
var
  textoComCaracteres, textoSemCaracteres: string;   // conteúdo da linha
  Posicao, i: Integer;
  Campo: array[1..5] of string; // ajustar para a quantidade de campos
begin
  textoSemCaracteres := texto;

  CdsTemp.First;
  While not CdsTemp.Eof do
  begin
    CdsTemp.Delete;
  end;

  i := 0;
  repeat
    // incrementa o índice do campo lido
    Inc(i);
    // localiza a primeira vírgula existente na linha
    Posicao := Pos(caractereSeparador, textoSemCaracteres);

    if Posicao = 0 then // se não existe vírgula na linha
      Posicao := Length(textoSemCaracteres) + 1; // lê o resto da linha

    // armazena a parte da linha que corresponde ao campo
    Campo[i] := Copy(textoSemCaracteres, 1, Pred(Posicao));

    CdsTemp.Append;
    CdsTempnumero.AsString := Trim(Campo[i]);
    CdsTemp.Post;

    // elimina o campo lido da linha
    Delete(textoSemCaracteres, 1, Posicao);
  until Posicao >= Length(textoSemCaracteres);
end;

procedure TControleConsultaTituloReceber.PesquisaProdutosFirebirdIntegracao;
var
  Texto, TextoFormatado: string;
  i: Integer;
  stringTituloParcelaSeparado: TStringDynArray;
begin
  inherited;
  // Verifica se o pedido veio de integração
  with ControleMainModule do
  begin
   if ConectaBancoIntegracao then
   begin
     // Preenche o CDsTemp com os itens dos pedidos
     RetornaValoresSeparados(Copy(Cdsconsultahistorico.AsString,19, Length(Cdsconsultahistorico.AsString)),
                             '|');

     CdsTemp.First;
     i := 1;
     while not CdsTemp.eof do
     begin
       stringTituloParcelaSeparado := separaTituloParcela(CdsTempnumero.AsString);

       if i = 1 then
       begin
         Texto := Texto + ' WHERE ped.numero =  '+ stringTituloParcelaSeparado[0];
         CdsTemp.Next;
       end;

       i := i + 1;

       Texto := Texto + ' OR ped.numero =  '+ stringTituloParcelaSeparado[0];

       CdsTemp.Next;
     end;

     TextoFormatado := copy(Texto,1,Length(Texto) -1);

     // Agora vamos montar o sql
     With FDQueryProdutoIntegracao do
     begin
       Close;
       Params.Clear;
       SQL.Clear;
       SQL.Text :=
                    'SELECT ped.numero,'
                    +'      pdt.seq,'
                    +'      ped.data,'
                    +'      pdt.codprod,'
                    +'      pro.descricao,'
                    +'      pro.unidade,'
                    +'      pdt.quantidade,'
                    +'      pdt.valorunit,'
                    +'      (pdt.quantidade * pdt.valorunit) total,'
                    +'      ped.vendedor'
                    +'  FROM pedidos ped'
                    +'  LEFT JOIN itemped pdt'
                    +'    ON ped.numero = pdt.numero'
                    +'  LEFT JOIN produtos pro'
                    +'    ON pro.codigo = pdt.codprod';
       SQL.Text := SQL.Text + TextoFormatado;
//       SQL.SaveToFile('teste.txt');
       Open;
     end;

     if FDQueryProdutoIntegracao.RecordCount > 0 then
     begin
       Relatorio_ProdutosIntegracao.Variables.Variables['RazaoEmpresa'] := QuotedStr(FRazaoSocial);
       Relatorio_ProdutosIntegracao.Variables.Variables['NumeroTitulo'] := QuotedStr(CdsConsultaID.AsString);
       ExportarPDF('Relatorio',Relatorio_ProdutosIntegracao);
     end;
   end;
  end;
end;

function TControleConsultaTituloReceber.separaTituloParcela(nTituloParcela: String): TStringDynArray;
begin
  Result := SplitString(nTituloParcela, '-');
end;

procedure TControleConsultaTituloReceber.AtualizaLabeltotal;
begin
  inherited;
  UniLabelValorAReceber.Value := StrToFloatDef(CdsConsultaSomaValor.AsString,0);
end;

procedure TControleConsultaTituloReceber.AtualizaLabeltotalComAcrescimo;
var
  vTotal, vPago: Double;
begin
  inherited;
  UniLabelValorPago.Value := StrToFloatDef(CdsConsultaSomaPago.AsString,0);
end;

procedure TControleConsultaTituloReceber.AtualizaLabeltotalRestante;
var
  vTotal, vPago: Double;
begin
  inherited;
  VTotal := StrToFloatDef(CdsConsultaSomaValor.AsString,0);
  VPago := StrToFloatDef(CdsConsultaSomaPago.AsString,0);

  if (vTotal - vPago) >= 0 then
    UniLabelValorRestante.Value := vTotal - vPago;

  if (vTotal - vPago) < 0 then
    UniLabelValorRestante.Value := 0;
end;





end.
