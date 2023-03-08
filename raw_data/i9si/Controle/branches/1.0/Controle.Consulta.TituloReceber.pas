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
  uniDateTimePicker, Vcl.Menus, uniSweetAlert;

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
    UniLabelValorTitulos: TUniFormattedNumberEdit;
    UniPopupMenuLegenda: TUniPopupMenu;
    UniImageList4: TUniImageList;
    CdsConsultaCarneNUMERO_DOCUMENTO: TWideStringField;
    UniCheckBoxIntervalo: TUniCheckBox;
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
    UniEdit14: TUniEdit;
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
    UniPanel3: TUniPanel;
    LabelQtdTituloGerar: TUniLabel;
    BotaoNegociarTitulos: TUniButton;
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
    CdsConsultaClone: TClientDataSet;
    FloatField1: TFloatField;
    FloatField2: TFloatField;
    FloatField3: TFloatField;
    WideStringField1: TWideStringField;
    FloatField4: TFloatField;
    WideStringField2: TWideStringField;
    WideStringField3: TWideStringField;
    DateTimeField1: TDateTimeField;
    DateTimeField2: TDateTimeField;
    DateTimeField3: TDateTimeField;
    FloatField5: TFloatField;
    FloatField6: TFloatField;
    WideStringField4: TWideStringField;
    WideStringField5: TWideStringField;
    DateTimeField4: TDateTimeField;
    FloatField7: TFloatField;
    FloatField8: TFloatField;
    WideStringField6: TWideStringField;
    WideStringField7: TWideStringField;
    WideStringField8: TWideStringField;
    WideStringField9: TWideStringField;
    WideStringField10: TWideStringField;
    WideStringField11: TWideStringField;
    FloatField9: TFloatField;
    WideStringField12: TWideStringField;
    WideStringField13: TWideStringField;
    WideStringField14: TWideStringField;
    WideStringField15: TWideStringField;
    FloatField10: TFloatField;
    WideStringField16: TWideStringField;
    WideStringField17: TWideStringField;
    WideStringField18: TWideStringField;
    FloatField11: TFloatField;
    FloatField12: TFloatField;
    FloatField13: TFloatField;
    WideStringField19: TWideStringField;
    WideStringField20: TWideStringField;
    WideStringField21: TWideStringField;
    WideStringField22: TWideStringField;
    AggregateField1: TAggregateField;
    CdsConsParcelasID: TFloatField;
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
  CPF_CNPJ_Negociado: string;

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
  Controle.Operacoes.Integracao.NegociarTituloReceber;

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
  qtdlabel, I : integer;
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

      // Alterando o label
      qtdlabel := StrToInt(LabelQtdTituloGerar.Caption);
      qtdlabel := qtdlabel + 1;
      LabelQtdTituloGerar.Caption := IntToStr(qtdlabel);
    end
    else
    begin
      CdsConsultaNEGOCIADO.AsString := 'N';

      // Alimentando o cds temporario
      if CdsTitulosGerar.Locate('NUMERO_REFERENCIA', CdsConsultaID.AsString, []) then
        CdsTitulosGerar.Delete;

      // Alterando o label
      qtdlabel := StrToInt(LabelQtdTituloGerar.Caption);
      qtdlabel := qtdlabel - 1;
      LabelQtdTituloGerar.Caption := IntToStr(qtdlabel);

      if qtdlabel = 0 then
        CPF_CNPJ_Negociado := '';
    end;
    CdsConsulta.Post;
  end
  else
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Só é possível para títulos em atraso');
  end;
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

  ConsultaTitulosMes(DtInicial,
                     DtFinal);

  PreencheFiltrosGrid;
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
  if UniLabelValorTitulos.Font.Color = clGray then
    UniLabelValorTitulos.Font.Color := clGreen
  else
    UniLabelValorTitulos.Font.Color := clGray;
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

procedure TControleConsultaTituloReceber.BotaoCancelarTituloClick(
  Sender: TObject);

begin
  if CdsConsultaSITUACAO.AsString = 'ABERTO' then
    UniSweetCancelarTitulo.show
  else
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Só é possível para títulos em aberto',atInfo);
end;

procedure TControleConsultaTituloReceber.BotaoNegociarTitulosClick(
  Sender: TObject);
  var
  qtdlabel : Integer;
begin
  inherited;

  if CdsTitulosGerar.RecordCount = 0 then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Selecione pelo menos um título para calcular os juros!');
    Exit;
  end;

  ControleOperacoesIntegracaoCalculoJuros.UniEdtValorOriginal.Text := CdsTitulosGerarSomaValorTotal.AsString;
  ControleOperacoesIntegracaoCalculoJuros.UniEdtDiasAtraso.Text    := CdsTitulosGerarMediaDiasAtraso.AsString;
  ControleOperacoesIntegracaoCalculoJuros.UniEdtMultaAtraso.Text   := FloatToStr(ControleMainModule.percentual_multa);
  ControleOperacoesIntegracaoCalculoJuros.UniEdtJurosMes.Text      := FloatToStr(ControleMainModule.percentual_juros);

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

          qtdlabel := 0;
          LabelQtdTituloGerar.Caption := IntToStr(qtdlabel);
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
begin
  inherited;
  if (CdsConsultaSITUACAO.AsString = 'ABERTO')  or (CdsConsultaSITUACAO.AsString = 'INADIMPLENTE')then
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

procedure TControleConsultaTituloReceber.cadastro1Click(Sender: TObject);
begin
  AbreAnexos;
end;

procedure TControleConsultaTituloReceber.CdsConsultaAfterRefresh(
  DataSet: TDataSet);
begin
  inherited;
  UniLabelValorTitulos.Text := CdsConsultaSomaValor.AsString;
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

  UniLabelValorTitulos.Text := CdsConsultaSomaValor.AsString;
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
    case AnsiIndexStr(CdsConsulta.FieldByName('SITUACAO').AsString,['LIQUIDADO','INADIMPLENTE']) of
      0:begin
          UniPopupMenuOpcoes.Items[4].Visible := True; //Imprimir recibo
        end;

      1:begin
          UniPopupMenuOpcoes.Items[8].Visible := True; //Marca para negociação
        end;
    end;

    UniPopupMenuOpcoes.Items[1].Visible := True; //Visualiza/Anexa documentos disponível para todos
    UniPopupMenuOpcoes.Popup(ControleMain.PosicaoMouseX +10,ControleMain.PosicaoMouseY +10);
  end;
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
    else if CdsConsultaSITUACAO.AsString = 'LIQUIDADO' then
      Attribs.Font.Color := clGreen
    else if CdsConsultaSITUACAO.AsString = 'NEGOCIADO' then
      Attribs.Font.Color := clPurple
    else if CdsConsultaSITUACAO.AsString = 'CANCELADO' then
      Attribs.Font.Color := clWebOrange
  end;
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
  inherited;
  CdsConsParcelas.Close;
  QryConsParcelas.Parameters.ParamByName('id').Value := CdsConsultaID.AsString;
  CdsConsParcelas.Open;


  CdsConsultaClone.CloneCursor(CdsConsulta,False,false);

  CdsConsultaClone.Close;
  CdsConsultaClone.Filtered := False;
  CdsConsultaClone.Filter := 'id = ' + CdsConsultaID.AsString;
  CdsConsultaClone.Filtered := True;
  CdsConsultaClone.Open;

  Conexao_Recibo.DataSet := CdsConsultaClone;

  Relatorio_Recibo.Variables.Variables['RazaoEmpresa'] := QuotedStr(ControleMainModule.FRazaoSocial);
  ControleMainModule.ExportarPDF('Relatorio',Relatorio_Recibo);
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

procedure TControleConsultaTituloReceber.EnviaCarneParcelaEmailBoleto(
  Sender: TComponent; AResult: Integer; AText: string);
begin

end;

procedure TControleConsultaTituloReceber.AlteraValorTitulo;
begin
  if ((CdsConsultaSITUACAO.AsString = 'ABERTO') or
     (CdsConsultaSITUACAO.AsString = 'INADIMPLENTE')) then
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

procedure TControleConsultaTituloReceber.AlteraDataTitulo;
begin
  if ((CdsConsultaSITUACAO.AsString = 'ABERTO') or
     (CdsConsultaSITUACAO.AsString = 'INADIMPLENTE')) then
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
  UniLabelValorTitulos.Text := CdsConsultaSomaValor.AsString;
  if UniCheckBoxIntervalo.Checked = True then
  begin
    UniPanelIntervalo.Enabled := False;
    CdsConsulta.Filtered := False;
    UniLabelValorTitulos.Text := CdsConsultaSomaValor.AsString;
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
    UniLabelValorTitulos.Text := CdsConsultaSomaValor.AsString;
  end;
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


end.
