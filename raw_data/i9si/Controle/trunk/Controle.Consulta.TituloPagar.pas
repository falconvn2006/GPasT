unit Controle.Consulta.TituloPagar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, Controle.Consulta, Data.DB, Data.Win.ADODB,
  Datasnap.Provider, Datasnap.DBClient, uniGUIBaseClasses, uniImageList,
  uniPanel, uniBasicGrid, uniDBGrid, uniButton, uniEdit, uniLabel,
  Vcl.Imaging.pngimage, uniImage, uniCheckBox, uniRadioGroup, system.DateUtils,
  frxClass, frxDBSet, Vcl.Menus, uniMainMenu,  uniScreenMask,
  uniBitBtn, uniMenuButton,  uniGridExporters,
  frxExportBaseDialog, frxExportPDF,   uniMultiItem,
  uniComboBox, uniSweetAlert, uniDateTimePicker;

  // implementar categoria em contas a pagar

type
  TControleConsultaTituloPagar = class(TControleConsulta)
    UniPanel7: TUniPanel;
    UniPanel9: TUniPanel;
    UniPanelIntervalo: TUniPanel;
    UniBotaoMesAnterior: TUniButton;
    UniBotaoMesPosterior: TUniButton;
    uniEditAno: TUniEdit;
    UniPanel10: TUniPanel;
    UniCheckBoxIntervalo: TUniCheckBox;
    UniPanel6: TUniPanel;
    UniLabelValorTitulos: TUniFormattedNumberEdit;
    CdsConsultaID: TFloatField;
    CdsConsultaFORNECEDOR_ID: TFloatField;
    CdsConsultaNUMERO_DOCUMENTO: TWideStringField;
    CdsConsultaSEQUENCIA_PARCELAS: TFloatField;
    CdsConsultaNATUREZA: TWideStringField;
    CdsConsultaDATA_EMISSAO: TDateTimeField;
    CdsConsultaDATA_VENCIMENTO: TDateTimeField;
    CdsConsultaVALOR: TFloatField;
    CdsConsultaVENCIDO: TWideStringField;
    CdsConsultaDATA_LIQUIDACAO: TDateTimeField;
    CdsConsultaVALOR_SALDO: TFloatField;
    CdsConsultaHISTORICO: TWideStringField;
    CdsConsultaFORNECEDOR: TWideStringField;
    CdsConsultaCPF_CNPJ: TWideStringField;
    CdsConsultaCONTA_BANCARIA_ID: TFloatField;
    CdsConsultaOPCOES: TFloatField;
    CdsConsultaPOSSUI_ANEXO: TWideStringField;
    UniEdit1: TUniEdit;
    UniEdit2: TUniEdit;
    UniEdit3: TUniEdit;
    UniEdit4: TUniEdit;
    UniEdit6: TUniEdit;
    UniEdit7: TUniEdit;
    UniEdit9: TUniEdit;
    CdsConsultaSomaValor: TAggregateField;
    UniImageList2: TUniImageList;
    UniImageList3: TUniImageList;
    BotaoCancelarTitulo: TUniButton;
    BotaoQuitarTitulo: TUniButton;
    UniButton1: TUniButton;
    CdsConsultaVALOR_PAGO: TFloatField;
    UniEdit10: TUniEdit;
    UniImageList4: TUniImageList;
    UniEdit11: TUniEdit;
    CdsConsultaDATA_VENC_ORIGINAL: TDateTimeField;
    UniScreenMask1: TUniScreenMask;
    UniPanel14: TUniPanel;
    CdsConsultaNUMERO_REFERENCIA: TWideStringField;
    UniEdit12: TUniEdit;
    UniPanelOpcaoAltera: TUniPanel;
    UniRadioGroupReenvia: TUniRadioGroup;
    BotaoConfirmaRenvio: TUniButton;
    BotaoCancelaRenvio: TUniButton;
    UniImageList5: TUniImageList;
    UniPopupMenu1: TUniPopupMenu;
    Aberto1: TUniMenuItem;
    Liquidado1: TUniMenuItem;
    Pagoparcial1: TUniMenuItem;
    Inadimplente1: TUniMenuItem;
    CANCELADO1: TUniMenuItem;
    N1: TUniMenuItem;
    Maisopes1: TUniMenuItem;
    BotaoAlteraData: TUniButton;
    BotaoAlteraValor: TUniButton;
    UniPopupMenuOpcoes: TUniPopupMenu;
    cadastro1: TUniMenuItem;
    UniImageList6: TUniImageList;
    UniComboBox1: TUniComboBox;
    UniComboBox2: TUniComboBox;
    CdsConsultaCATEGORIA: TWideStringField;
    UniComboBox3: TUniComboBox;
    DspTituloCategoria: TDataSetProvider;
    CdsTituloCategoria: TClientDataSet;
    CdsTituloCategoriaDESCRICAO: TWideStringField;
    QryTituloCategoria: TADOQuery;
    DscTituloCategoria: TDataSource;
    UniSweetAlertCancelarTitulo: TUniSweetAlert;
    UniSweetAlertVerificaIntervalo: TUniSweetAlert;
    UniDateTimePickerFinal: TUniDateTimePicker;
    UniDateTimePickerInicial: TUniDateTimePicker;
    CdsConsultaSITUACAO: TWideStringField;
    CdsConsultaDIAS_ATRASO: TFloatField;
    CdsConsultaCONDICOES_PAGAMENTO_ID: TFloatField;
    CdsConsultaCONDICOES_PAGAMENTO: TWideStringField;
    CdsConsultaGERA_CARNE: TWideStringField;
    CdsConsultaGERA_BOLETO: TWideStringField;
    CdsConsultaGERA_CHEQUE: TWideStringField;
    EditPesquisaId: TUniEdit;
    CdsConsultaVALOR_JUROS: TFloatField;
    CdsConsultaVALOR_MULTA: TFloatField;
    CdsConsultaMARCADO_PARA_BAIXAR: TWideStringField;
    QryConsultaID: TFloatField;
    QryConsultaFORNECEDOR_ID: TFloatField;
    QryConsultaCONDICOES_PAGAMENTO_ID: TFloatField;
    QryConsultaNUMERO_DOCUMENTO: TWideStringField;
    QryConsultaSEQUENCIA_PARCELAS: TFloatField;
    QryConsultaNATUREZA: TWideStringField;
    QryConsultaDATA_EMISSAO: TDateTimeField;
    QryConsultaDATA_VENC_ORIGINAL: TDateTimeField;
    QryConsultaDATA_VENCIMENTO: TDateTimeField;
    QryConsultaVALOR: TFloatField;
    QryConsultaMARCADO_PARA_BAIXAR: TWideStringField;
    QryConsultaDIAS_ATRASO: TFloatField;
    QryConsultaSITUACAO: TWideStringField;
    QryConsultaVENCIDO: TWideStringField;
    QryConsultaDATA_LIQUIDACAO: TDateTimeField;
    QryConsultaVALOR_PAGO: TFloatField;
    QryConsultaVALOR_SALDO: TFloatField;
    QryConsultaHISTORICO: TWideStringField;
    QryConsultaFORNECEDOR: TWideStringField;
    QryConsultaCPF_CNPJ: TWideStringField;
    QryConsultaCONDICOES_PAGAMENTO: TWideStringField;
    QryConsultaCONTA_BANCARIA_ID: TFloatField;
    QryConsultaGERA_CARNE: TWideStringField;
    QryConsultaGERA_BOLETO: TWideStringField;
    QryConsultaGERA_CHEQUE: TWideStringField;
    QryConsultaOPCOES: TFloatField;
    QryConsultaPOSSUI_ANEXO: TWideStringField;
    QryConsultaNUMERO_REFERENCIA: TWideStringField;
    QryConsultaCATEGORIA: TWideStringField;
    QryConsultaVALOR_JUROS: TFloatField;
    QryConsultaVALOR_MULTA: TFloatField;
    QryConsultaTITULO_CATEGORIA_ID: TFloatField;
    CdsConsultaTITULO_CATEGORIA_ID: TFloatField;
    CdsBaixaMultiplo: TClientDataSet;
    CdsBaixaMultiploID: TStringField;
    CdsBaixaMultiploVALOR: TFloatField;
    CdsBaixaMultiploCLIENTE: TStringField;
    CdsBaixaMultiploCONTA_BANCARIA_ID: TStringField;
    CdsBaixaMultiploSEQUENCIA_PARCELAS: TStringField;
    CdsBaixaMultiploTITULO_CATEGORIA_ID: TStringField;
    CdsBaixaMultiploVENCIMENTO: TDateField;
    CdsBaixaMultiploSomaTotal: TAggregateField;
    CdsBaixaMultiploConta: TAggregateField;
    frxDBDataset_PagarBaixarLote: TfrxDBDataset;
    frxReport_baixa_pagar: TfrxReport;
    QryConsultaLote: TADOQuery;
    DspConsultaLote: TDataSetProvider;
    CdsConsultaLote: TClientDataSet;
    DscConsultaLote: TDataSource;
    CdsConsultaLoteID: TFloatField;
    CdsConsultaLoteFORNECEDOR_ID: TFloatField;
    CdsConsultaLoteCONDICOES_PAGAMENTO_ID: TFloatField;
    CdsConsultaLoteNUMERO_DOCUMENTO: TWideStringField;
    CdsConsultaLoteSEQUENCIA_PARCELAS: TFloatField;
    CdsConsultaLoteNATUREZA: TWideStringField;
    CdsConsultaLoteDATA_EMISSAO: TDateTimeField;
    CdsConsultaLoteDATA_VENC_ORIGINAL: TDateTimeField;
    CdsConsultaLoteDATA_VENCIMENTO: TDateTimeField;
    CdsConsultaLoteVALOR: TFloatField;
    CdsConsultaLoteMARCADO_PARA_BAIXAR: TWideStringField;
    CdsConsultaLoteDIAS_ATRASO: TFloatField;
    CdsConsultaLoteSITUACAO: TWideStringField;
    CdsConsultaLoteVENCIDO: TWideStringField;
    CdsConsultaLoteDATA_LIQUIDACAO: TDateTimeField;
    CdsConsultaLoteVALOR_PAGO: TFloatField;
    CdsConsultaLoteVALOR_SALDO: TFloatField;
    CdsConsultaLoteHISTORICO: TWideStringField;
    CdsConsultaLoteFORNECEDOR: TWideStringField;
    CdsConsultaLoteCPF_CNPJ: TWideStringField;
    CdsConsultaLoteCONDICOES_PAGAMENTO: TWideStringField;
    CdsConsultaLoteCONTA_BANCARIA_ID: TFloatField;
    CdsConsultaLoteGERA_CARNE: TWideStringField;
    CdsConsultaLoteGERA_BOLETO: TWideStringField;
    CdsConsultaLoteGERA_CHEQUE: TWideStringField;
    CdsConsultaLoteOPCOES: TFloatField;
    CdsConsultaLotePOSSUI_ANEXO: TWideStringField;
    CdsConsultaLoteNUMERO_REFERENCIA: TWideStringField;
    CdsConsultaLoteCATEGORIA: TWideStringField;
    CdsConsultaLoteTITULO_CATEGORIA_ID: TFloatField;
    CdsConsultaLoteVALOR_JUROS: TFloatField;
    CdsConsultaLoteVALOR_MULTA: TFloatField;
    CdsConsultaLoteLOTE_BAIXA: TFloatField;
    Imprimirbaixadelote1: TUniMenuItem;
    QryConsultaNUMERO_LOTE: TFloatField;
    CdsConsultaNUMERO_LOTE: TFloatField;
    UniSweetAlertImprimirBaixa: TUniSweetAlert;
    QryPesquisa: TADOQuery;
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
    WideStringField3: TWideStringField;
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
    FloatField9: TFloatField;
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
    FloatField14: TFloatField;
    CdsPesquisa: TClientDataSet;
    AggregateField1: TAggregateField;
    DspPesquisa: TDataSetProvider;
    DscPesquisa: TDataSource;
    CdsPesquisaID: TFloatField;
    CdsPesquisaFORNECEDOR_ID: TFloatField;
    CdsPesquisaCONDICOES_PAGAMENTO_ID: TFloatField;
    CdsPesquisaNUMERO_DOCUMENTO: TWideStringField;
    CdsPesquisaSEQUENCIA_PARCELAS: TFloatField;
    CdsPesquisaNATUREZA: TWideStringField;
    CdsPesquisaDATA_EMISSAO: TDateTimeField;
    CdsPesquisaDATA_VENC_ORIGINAL: TDateTimeField;
    CdsPesquisaDATA_VENCIMENTO: TDateTimeField;
    CdsPesquisaVALOR: TFloatField;
    CdsPesquisaMARCADO_PARA_BAIXAR: TWideStringField;
    CdsPesquisaDIAS_ATRASO: TFloatField;
    CdsPesquisaSITUACAO: TWideStringField;
    CdsPesquisaVENCIDO: TWideStringField;
    CdsPesquisaDATA_LIQUIDACAO: TDateTimeField;
    CdsPesquisaVALOR_PAGO: TFloatField;
    CdsPesquisaVALOR_SALDO: TFloatField;
    CdsPesquisaHISTORICO: TWideStringField;
    CdsPesquisaFORNECEDOR: TWideStringField;
    CdsPesquisaCPF_CNPJ: TWideStringField;
    CdsPesquisaCONDICOES_PAGAMENTO: TWideStringField;
    CdsPesquisaCONTA_BANCARIA_ID: TFloatField;
    CdsPesquisaGERA_CARNE: TWideStringField;
    CdsPesquisaGERA_BOLETO: TWideStringField;
    CdsPesquisaGERA_CHEQUE: TWideStringField;
    CdsPesquisaOPCOES: TFloatField;
    CdsPesquisaPOSSUI_ANEXO: TWideStringField;
    CdsPesquisaNUMERO_REFERENCIA: TWideStringField;
    CdsPesquisaCATEGORIA: TWideStringField;
    CdsPesquisaVALOR_JUROS: TFloatField;
    CdsPesquisaVALOR_MULTA: TFloatField;
    CdsPesquisaTITULO_CATEGORIA_ID: TFloatField;
    CdsPesquisaNUMERO_LOTE: TFloatField;
    procedure GrdResultadoCellClick(Column: TUniDBGridColumn);
    procedure UniBotaoMesAnteriorClick(Sender: TObject);
    procedure UniBotaoMesPosteriorClick(Sender: TObject);
    procedure UniCheckBoxIntervaloClick(Sender: TObject);
    procedure BotaoAbrirClick(Sender: TObject);
    procedure UniFrameCreate(Sender: TObject);
    procedure CdsConsultaPOSSUI_ANEXOGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure BotaoQuitarTituloClick(Sender: TObject);
    procedure BotaoCancelarTituloClick(Sender: TObject);
    procedure GrdResultadoColumnFilter(Sender: TUniDBGrid;
      const Column: TUniDBGridColumn; const Value: Variant);
    procedure CdsConsultaAfterRefresh(DataSet: TDataSet);
    procedure BotaoApagarClick(Sender: TObject);
    procedure BotaoCancelaRenvioClick(Sender: TObject);
    procedure BotaoAlteraDataClick(Sender: TObject);
    procedure BotaoAlteraValorClick(Sender: TObject);
    procedure cadastro1Click(Sender: TObject);
    procedure UniSweetAlertCancelarTituloConfirm(Sender: TObject);
    procedure UniSweetAlertVerificaIntervaloConfirm(Sender: TObject);
    procedure UniSweetAlertVerificaIntervaloDismiss(Sender: TObject;
      const Reason: TDismissType);
    procedure UniDateTimePickerInicialChange(Sender: TObject);
    procedure UniDateTimePickerFinalChange(Sender: TObject);
    procedure GrdResultadoDrawColumnCell(Sender: TObject; ACol, ARow: Integer;
      Column: TUniDBGridColumn; Attribs: TUniCellAttribs);
    procedure EditPesquisaIdKeyPress(Sender: TObject; var Key: Char);
    procedure BotaoAtualizarClick(Sender: TObject);
    procedure Imprimirbaixadelote1Click(Sender: TObject);
    procedure UniSweetAlertImprimirBaixaConfirm(Sender: TObject);
    procedure UniSweetAlertImprimirBaixaDismiss(Sender: TObject;
      const Reason: TDismissType);
    procedure UniSweetExclusaoRegistroConfirm(Sender: TObject);
    private

    procedure UniTimer1Timer(Sender: TObject);
    procedure ConsultaTitulosMes(DataInicial, DataFinal: String;
                                                          FullConsulta: String = 'N'){V - vencimento | P - Pagamento};
    procedure AlteraDataParcela(Sender: TComponent; AResult: Integer;
      AText: string);
    procedure AlteraValorParcela(Sender: TComponent; AResult: Integer;
      AText: string);
    procedure VerificaIntervalo(fullconsulta : string ='');
    procedure AlteraDataTitulo;
    procedure AlteraValorTitulo;
    procedure AbreAnexos;
    procedure DesabilitaMenusOpcoes(Popup: TUniPopupMenu);
    procedure ImprimeLote;
    function Apagar(id: Integer): Boolean;
    { Private declarations }
  public
    { Public declarations }
   procedure Novo; override;
   procedure Abrir(Id: Integer); override;
  end;

  var
  Cont : Integer;
  QtdTituloParaBaixar : Integer = 0;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, Controle.Cadastro.TituloPagar, Controle.Operacoes.TituloPagar.Documentos,
  Controle.Operacoes.CriarTituloPagar, Controle.Funcoes, 
  Controle.Consulta.TituloPagar.Opcoes, Controle.Main,
  Controle.Cadastro.BaixarTituloPagar,Controle.Consulta.Baixar.MultiplosPagar;

procedure TControleConsultaTituloPagar.BotaoAbrirClick(Sender: TObject);
begin
  if ControleCadastroTituloPagar.Abrir(CdsConsultaID.AsInteger) then
  begin
    ControleCadastroTituloPagar.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
//      if Result = 1 then
        CdsConsulta.Refresh;
    end);
  end;
end;

procedure TControleConsultaTituloPagar.BotaoAlteraDataClick(Sender: TObject);
begin
  inherited;
  AlteraDataTitulo;
end;

procedure TControleConsultaTituloPagar.BotaoAlteraValorClick(Sender: TObject);
begin
  inherited;
  AlteraValorTitulo;
end;

procedure TControleConsultaTituloPagar.BotaoApagarClick(Sender: TObject);
begin
//  inherited;
  if (CdsConsultaSITUACAO.AsString = 'ABERTO')
    OR (CdsConsultaSITUACAO.AsString = 'INADIMPLENTE') then
  begin
    UniSweetExclusaoRegistro.Show;
  end
  else
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção!', 'Não é permitido apagar um titulo na situação '+CdsConsultaSITUACAO.AsString+'.',atWarning);
  end;
end;

procedure TControleConsultaTituloPagar.BotaoAtualizarClick(Sender: TObject);
var
  bJSName :string;

begin
  //inherited;
  if ControleMainModule.PLiquidaMultiploPagar  = 'S' then
  begin
    bJSName := (BotaoQuitarTitulo).JSName;
    UniSession.AddJS(bJSName + '.setBadgeText(' + bJSName + '.getBadgeText() -'+ IntToStr(QtdTituloParaBaixar) +');');
  end;

  CdsConsulta.Close;
  CdsConsulta.Open;
  QtdTituloParaBaixar := 0;
end;

procedure TControleConsultaTituloPagar.BotaoCancelaRenvioClick(Sender: TObject);
begin
  inherited;
  UniPanel1.Enabled := True;
  UniPanelOpcaoAltera.Visible := False;
end;

procedure TControleConsultaTituloPagar.BotaoCancelarTituloClick(
  Sender: TObject);
begin
  inherited;
  UniSweetAlertCancelarTitulo.Show;
end;

procedure TControleConsultaTituloPagar.GrdResultadoCellClick(
 Column: TUniDBGridColumn);
begin
  inherited;
  if Column.FieldName = 'POSSUI_ANEXO' then
  begin
   DesabilitaMenusOpcoes(UniPopupMenuOpcoes);

   if CdsConsultaNUMERO_LOTE.AsString <> '0' then
     UniPopupMenuOpcoes.Items[1].Visible := True; //Imprime baixa lote

   UniPopupMenuOpcoes.Items[0].Visible := True; //Visualiza/Anexa documentos disponível para todos
   UniPopupMenuOpcoes.Popup(ControleMain.PosicaoMouseX +10,ControleMain.PosicaoMouseY +10) ;
  end;
end;

procedure TControleConsultaTituloPagar.GrdResultadoColumnFilter(
  Sender: TUniDBGrid; const Column: TUniDBGridColumn; const Value: Variant);
begin
  inherited;

  UniLabelValorTitulos.Text := CdsConsultaSomaValor.AsString;
  VerificaIntervalo;
end;

procedure TControleConsultaTituloPagar.GrdResultadoDrawColumnCell(
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

procedure TControleConsultaTituloPagar.Imprimirbaixadelote1Click(
  Sender: TObject);
begin
  inherited;
  ImprimeLote;
end;

procedure TControleConsultaTituloPagar.ImprimeLote;
begin
  CdsConsultaLote.close;
  CdsConsultaLote.Params.ParamByName('NUMERO_LOTE').AsString := CdsConsultaNUMERO_LOTE.AsString;
  CdsConsultaLote.Open;

  frxReport_baixa_pagar.Variables.Variables['RazaoEmpresa'] := QuotedStr(ControleMainModule.FRazaoSocial);
  ControleMainModule.ExportarPDF('Relatorio',frxReport_baixa_pagar);
end;

procedure TControleConsultaTituloPagar.UniBotaoMesAnteriorClick(
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

  //UnieditMes.Text := ControleFuncoes.MesExtenso(Cont);

  ConsultaTitulosMes(DtInicial,
                     DtFinal);
  UniDateTimePickerInicial.DateTime :=  StrToDate(DtInicial);
  UniDateTimePickerFinal.DateTime :=  StrToDate(DtFinal);
end;

procedure TControleConsultaTituloPagar.UniBotaoMesPosteriorClick(
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

procedure TControleConsultaTituloPagar.UniCheckBoxIntervaloClick(
  Sender: TObject);
begin
  inherited;
//  if UniCheckBoxIntervalo.Checked = True  then
//    UniSweetAlertVerificaIntervalo.show
//  else
//    VerificaIntervalo();
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

procedure TControleConsultaTituloPagar.UniDateTimePickerFinalChange(
  Sender: TObject);
begin
  inherited;
    ConsultaTitulosMes(DateToStr(UniDateTimePickerInicial.DateTime),
                        DateToStr(UniDateTimePickerFinal.DateTime));
end;

procedure TControleConsultaTituloPagar.UniDateTimePickerInicialChange(
  Sender: TObject);
begin
  inherited;
    ConsultaTitulosMes(DateToStr(UniDateTimePickerInicial.DateTime),
                        DateToStr(UniDateTimePickerFinal.DateTime));
end;

procedure TControleConsultaTituloPagar.UniFrameCreate(Sender: TObject);
Var
  DtInicial, DtFinal : String;
begin
//  inherited;
  uniEditAno.Text := FormatDateTime('yyyy', Date );
//  unieditMes.Text := ControleFuncoes.MesExtenso(StrToInt(FormatDateTime('mm', Date )));
  Cont := StrToInt(FormatDateTime('mm', Date ));

  UniDateTimePickerInicial.DateTime :=StartOfTheMonth(Date);
  UniDateTimePickerFinal.DateTime :=EndOfTheMonth(Date);

  DtInicial :=  DateToStr(StartOfTheMonth(Date));
  DtFinal :=  DateToStr(EndOfTheMonth(Date));

  ConsultaTitulosMes(DtInicial,
                     DtFinal);

  // Preenchendo o combo para consulta da categoria
  UniComboBox3.Clear;
  CdsTituloCategoria.Open;
  while not CdsTituloCategoria.Eof do
  begin
    UniComboBox3.Items.Add(CdsTituloCategoria.FieldByName('descricao').AsString);
    CdsTituloCategoria.Next;
  end;

    //Adiciona B
  if ControleMainModule.PLiquidaMultiploPagar ='S' then
      BotaoQuitarTitulo.ClientEvents.UniEvents.Add('beforeInit=function beforeInit(sender, config){config.style={''overflow'': ''visible''};sender.action = ''badgetext'';sender.plugins = [{ptype:''badgetext'',defaultText: 0,disableOpacity:1,disableBg: ''green'',align:''right''}];}');

  QtdTituloParaBaixar :=0;
end;

procedure TControleConsultaTituloPagar.UniSweetAlertCancelarTituloConfirm(
  Sender: TObject);
begin
  inherited;
  if ControleMainModule.CancelaTitulo(CdsConsultaID.AsInteger) then
  begin
    CdsConsulta.Refresh;
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Título cancelado com sucesso', tAlertType.atSuccess);
  end
  else
  begin
    ControleMainModule.MensageiroSweetAlerta('Falha!', 'Não foi possível apagar título');
  end;
end;

procedure TControleConsultaTituloPagar.UniSweetAlertImprimirBaixaConfirm(
  Sender: TObject);
begin
  inherited;
  BotaoAtualizar.Click;

  frxReport_baixa_pagar.Variables.Variables['RazaoEmpresa'] := QuotedStr(ControleMainModule.FRazaoSocial);
  ControleMainModule.ExportarPDF('Relatorio',frxReport_baixa_pagar);
end;

procedure TControleConsultaTituloPagar.UniSweetAlertImprimirBaixaDismiss(
  Sender: TObject; const Reason: TDismissType);
begin
  inherited;
  BotaoAtualizar.Click;
end;

procedure TControleConsultaTituloPagar.UniSweetAlertVerificaIntervaloConfirm(
  Sender: TObject);
begin
  inherited;
  VerificaIntervalo('S');
end;

procedure TControleConsultaTituloPagar.UniSweetAlertVerificaIntervaloDismiss(
  Sender: TObject; const Reason: TDismissType);
begin
  inherited;
  UniCheckBoxIntervalo.Checked := False;
end;

procedure TControleConsultaTituloPagar.UniSweetExclusaoRegistroConfirm(
  Sender: TObject);
begin
  //  inherited;
  if StrToFloatDef(CdsConsultaVALOR_PAGO.AsString,0) = 0 then
  begin
    if Apagar(CdsConsultaID.AsInteger) then
    begin
      ControleMainModule.MensageiroSweetAlerta('Sucesso!', 'O título foi apagado com sucesso.',atSuccess);
      CdsConsulta.Refresh;
    end;
  end
  else
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção!', 'Este título já sofreu baixa e por isso não pode ser apagado.',atWarning);
  end;
end;

procedure TControleConsultaTituloPagar.UniTimer1Timer(Sender: TObject);
begin
  inherited;
  if UniLabelValorTitulos.Font.Color = clGray then
    UniLabelValorTitulos.Font.Color := clGreen
  else
    UniLabelValorTitulos.Font.Color := clGray;
end;

procedure TControleConsultaTituloPagar.CdsConsultaAfterRefresh(
  DataSet: TDataSet);
begin
  inherited;
  UniLabelValorTitulos.Text := CdsConsultaSomaValor.AsString;
end;

procedure TControleConsultaTituloPagar.CdsConsultaPOSSUI_ANEXOGetText(
  Sender: TField; var Text: string; DisplayText: Boolean);
begin
  inherited;
  if CdsConsultaPOSSUI_ANEXO.AsString = 'S' then
    Text := '<img src=./files/icones/opanexo.png height=22 align="center" />'
  else
    Text := '<img src=./files/icones/opcoes.png height=22 align="center" />'
end;

procedure TControleConsultaTituloPagar.ConsultaTitulosMes(DataInicial, DataFinal: String;
                                                          FullConsulta: String = 'N'){V - vencimento | P - Pagamento};
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


procedure TControleConsultaTituloPagar.EditPesquisaIdKeyPress(Sender: TObject;
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
      CdsPesquisa.Close;
      CdsPesquisa.Params.ParamByName('ID').Value := EditPesquisaId.Text;
      CdsPesquisa.Open;

      if CdsPesquisa.RecordCount >0 then
      begin
        if   (CdsPesquisaSITUACAO.AsString  = 'ABERTO')
          or (CdsPesquisaSITUACAO.AsString  = 'INADIMPLENTE')
          or (CdsPesquisaSITUACAO.AsString  = 'PARCIAL') then
        begin
          if CdsBaixaMultiplo.Locate('Id',CdsPesquisaID.AsInteger,[]) = False then
          begin
            // Alimentando o cds temporario
            CdsBaixaMultiplo.Insert;
            CdsBaixaMultiploID.AsInteger                 := CdsPesquisaID.AsInteger;
            CdsBaixaMultiploVALOR.AsFloat                := CdsPesquisaVALOR_SALDO.AsFloat;
            CdsBaixaMultiploCLIENTE.AsString             := CdsPesquisaFORNECEDOR.AsString;
            CdsBaixaMultiploVENCIMENTO.AsDateTime        := CdsPesquisaDATA_VENCIMENTO.AsDateTime;
            CdsBaixaMultiploCONTA_BANCARIA_ID.AsString   := CdsPesquisaCONTA_BANCARIA_ID.AsString;
            CdsBaixaMultiploSEQUENCIA_PARCELAS.AsString  := CdsPesquisaSEQUENCIA_PARCELAS.AsString;
            CdsBaixaMultiploTITULO_CATEGORIA_ID.AsString := CdsPesquisaTITULO_CATEGORIA_ID.AsString;
            CdsBaixaMultiplo.Post;

            QtdTituloParaBaixar := QtdTituloParaBaixar +1;
            bJSName := (BotaoQuitarTitulo).JSName;
            UniSession.AddJS(bJSName + '.setBadgeText(' + bJSName + '.getBadgeText() + 1);');
          end
          else
          begin
            CdsBaixaMultiplo.Delete;

            QtdTituloParaBaixar := QtdTituloParaBaixar -1;
            bJSName := (BotaoQuitarTitulo).JSName;
            UniSession.AddJS(bJSName + '.setBadgeText(' + bJSName + '.getBadgeText() - 1);');
          end;
        end;
        EditPesquisaId.SelectAll;
        EditPesquisaId.SetFocus;
      end
      else
      begin
        ControleMainModule.MensageiroSweetAlerta('Atenção', 'Nenhum título encontrado com esse ID.');
      end;
    end;
    CdsConsulta.Refresh;
  end;
end;

procedure TControleConsultaTituloPagar.Novo;
begin
  inherited;

  ControleOperacoesCriarTituloPagar.ShowModal(procedure(Sender: TComponent; Result: Integer)
  begin
    CdsConsulta.Refresh;
    VerificaIntervalo;
  end);
end;

procedure TControleConsultaTituloPagar.Abrir(Id: Integer);
begin
  inherited;

  // Abre o formulário de cadastro para visualização e edição
  if ControleCadastroTituloPagar.Abrir(Id) then
  begin
    ControleCadastroTituloPagar.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
//      if Result = 1 then
        CdsConsulta.Refresh;
    end);
  end;
end;
procedure TControleConsultaTituloPagar.BotaoQuitarTituloClick(
  Sender: TObject);
begin
  inherited;
  if QtdTituloParaBaixar <> 0 then
  begin
   ControleConsultaBaixarMultiplosPagar.Abrir(CdsBaixaMultiploConta.AsString,CdsBaixaMultiploSomaTotal.AsString);
   ControleConsultaBaixarMultiplosPagar.CdsBaixaMultiplo.CloneCursor(CdsBaixaMultiplo,False,False);
   ControleConsultaBaixarMultiplosPagar.ShowModal(procedure(Sender: TComponent; Result: Integer)
   begin
    if ControleConsultaBaixarMultiplosPagar.Baixado = True then
    begin
      CdsConsultaLote.close;
      CdsConsultaLote.Params.ParamByName('NUMERO_LOTE').AsString := IntToStr(ControleConsultaBaixarMultiplosPagar.numero_lote_id);
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
      ControleCadastroBaixarTituloPagar.CalculoParaBaixa(CdsConsultaId.AsInteger,
                                                         0);

      ControleCadastroBaixarTituloPagar.ShowModal(procedure(Sender: TComponent; Result: Integer)
      begin
  //         if Result = 1 then
          CdsConsulta.Refresh;
      end);
    end
    else
      ControleMainModule.MensageiroSweetAlerta('Atenção', 'Só é permitido receber o título em situação aberto ou inadimplente.');
  end;
end;

procedure TControleConsultaTituloPagar.cadastro1Click(Sender: TObject);
begin
   AbreAnexos;
end;

Procedure TControleConsultaTituloPagar.AlteraDataParcela(Sender: TComponent; AResult:Integer; AText: string);
begin
  if AResult = mrOK then
  begin
 {   Try
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
    End;}

    if ControleMainModule.AtualizaDataTitulo(StrToDate(AText),
                                     CdsConsultaID.AsInteger) then
    begin
      CdsConsulta.Refresh;
      ControleMainModule.MensageiroSweetAlerta('Atenção', 'Data alterada com sucesso',atSuccess);
    end;
  end;
end;

Procedure TControleConsultaTituloPagar.AlteraValorParcela(Sender: TComponent; AResult:Integer; AText: string);
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

procedure TControleConsultaTituloPagar.VerificaIntervalo(fullconsulta : string ='');
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
//    UniPanelIntervalo.Enabled := True;
//    ConsultaTitulosMes(IntToStr(Cont),
//                       uniEditAno.Text);
//    UniLabelValorTitulos.Text := CdsConsultaSomaValor.AsString;
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

procedure TControleConsultaTituloPagar.AlteraDataTitulo;
begin
  if (CdsConsultaSITUACAO.AsString = 'ABERTO')
  or (CdsConsultaSITUACAO.AsString = 'INADIMPLENTE')
  or (CdsConsultaSITUACAO.AsString = 'PARCIAL')then
  begin
    Prompt('Digite nova data de vencimento.',
           DateToStr(CdsConsultaDATA_VENCIMENTO.AsDateTime),
           mtConfirmation,
           mbOKCancel,
           AlteraDataParcela);
  end
  else
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Só é possível para títulos em aberto');
  end;
end;

procedure TControleConsultaTituloPagar.AlteraValorTitulo;
begin
  if (CdsConsultaSITUACAO.AsString = 'ABERTO')
  or (CdsConsultaSITUACAO.AsString = 'INADIMPLENTE')
  or (CdsConsultaSITUACAO.AsString = 'PARCIAL')then
  begin
    Prompt('Digite o novo valor da parcela.',
           CdsConsultaVALOR.AsString,
           mtConfirmation,
           mbOKCancel,
           AlteraValorParcela);
  end
  else
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Só é possível para títulos em aberto');
  end;
end;

procedure TControleConsultaTituloPagar.AbreAnexos;
begin
  ControleMainModule.titulo_id_m := CdsConsultaID.AsInteger;
  ControleOperacoesTituloPagarDocumentos.ShowModal(procedure(Sender: TComponent; Result: Integer)
  begin
//    if Result = 1 then
      Cdsconsulta.Refresh;
  end);
end;

procedure TControleConsultaTituloPagar.DesabilitaMenusOpcoes(Popup: TUniPopupMenu);
var
  i : integer;
begin
  for i := 0 to Popup.Items.Count - 1 do begin
   Popup.Items[i].Visible := False;
  end;
end;

function TControleConsultaTituloPagar.Apagar(id:Integer):Boolean;
var
  error : string;
begin
  Result := False;
  error  := '';

  with ControleMainModule do
  begin
      // Inicia a transação
    if ADOConnection.Intransaction = False then
        ADOConnection.BeginTrans;

    Try
      QryAx3.Parameters.Clear;
      QryAx3.SQL.Clear;
      QryAx3.SQL.Text := 'DELETE FROM titulo WHERE id =:id';
      QryAx3.Parameters.ParamByName('id').Value           := id;
      QryAx3.ExecSQL
    Except
      on e:exception do
      begin
        ADOConnection.RollbackTrans;
        error := e.Message;
      End;
    end;

    if error = '' then
    begin
      Try
        QryAx4.Parameters.Clear;
        QryAx4.SQL.Clear;
        QryAx4.SQL.Text := 'DELETE FROM titulo_pagar WHERE id =:id';
        QryAx4.Parameters.ParamByName('id').Value           := id;
        QryAx4.ExecSQL
      Except
        on e:exception do
        begin
          ADOConnection.RollbackTrans;
          error := e.Message;
        End;
      end;
    end;

    if error  = '' then
    begin
      Try
        // Confirma a transação
        ADOConnection.CommitTrans;
        Result := True;
      Except
        on e:Exception do
        begin
          ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));
          // Descarta a transação
          if ADOConnection.InTransaction = True then
            ADOConnection.RollbackTrans;
        end;
      End;
    end;
  end;
end;



end.
