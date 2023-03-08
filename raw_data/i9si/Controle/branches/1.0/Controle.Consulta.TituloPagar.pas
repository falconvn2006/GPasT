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
    UniPopupMenu2: TUniPopupMenu;
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
    { Private declarations }
  public
    { Public declarations }
   procedure Novo; override;
   procedure Abrir(Id: Integer); override;
  end;

  var
  Cont : Integer;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, Controle.Cadastro.TituloPagar, Controle.Operacoes.TituloPagar.Documentos,
  Controle.Operacoes.CriarTituloPagar, Controle.Funcoes, 
  Controle.Consulta.TituloPagar.Opcoes, Controle.Main,
  Controle.Cadastro.BaixarTituloPagar;

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
  ControleMainModule.MensageiroSweetAlerta('Atenção', 'O título não pode ser excluído, caso deseje você pode cancelar o mesmo');
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
   UniPopupMenu2.Popup(ControleMain.PosicaoMouseX +10,ControleMain.PosicaoMouseY +10) ;
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
end;

procedure TControleConsultaTituloPagar.UniSweetAlertCancelarTituloConfirm(
  Sender: TObject);
begin
  inherited;
  ControleMainModule.CancelaTitulo(CdsConsultaID.AsInteger);
  CdsConsulta.Refresh;

  ControleMainModule.MensageiroSweetAlerta('Atenção', 'Título cancelado com sucesso', tAlertType.atSuccess);

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
  if (CdsConsultaSITUACAO.AsString = 'ABERTO')  or (CdsConsultaSITUACAO.AsString = 'INADIMPLENTE')then
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
  if (CdsConsultaSITUACAO.AsString = 'ABERTO')  or (CdsConsultaSITUACAO.AsString = 'INADIMPLENTE')then
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
  if (CdsConsultaSITUACAO.AsString = 'ABERTO')  or (CdsConsultaSITUACAO.AsString = 'INADIMPLENTE')then
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

end.
