unit Controle.Consulta.ChequesRecebidos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, Controle.Consulta,  frxClass, frxDBSet,
  frxExportBaseDialog, frxExportPDF, uniGridExporters, uniBasicGrid,
   Data.DB, Data.Win.ADODB, Datasnap.Provider,
  Datasnap.DBClient, uniGUIBaseClasses, uniImageList, uniCheckBox, uniLabel,
  uniPanel, uniDBGrid, Vcl.Imaging.pngimage, uniImage, uniBitBtn, 
  uniButton, uniEdit, uniScreenMask, uniMenuButton, Vcl.Menus, uniMainMenu,
  uniSweetAlert, uniDateTimePicker, uniMultiItem, uniComboBox;

type
  TControleConsultaChequesRecebidos = class(TControleConsulta)
    UniEdit1: TUniEdit;
    UniEdit2: TUniEdit;
    UniEdit3: TUniEdit;
    UniEdit4: TUniEdit;
    UniEdit5: TUniEdit;
    UniEdit6: TUniEdit;
    CdsBaixaCheque: TClientDataSet;
    CdsBaixaChequeID: TIntegerField;
    CdsBaixaChequeVALOR: TFloatField;
    CdsBaixaChequeVENCIMENTO: TDateField;
    CdsBaixaChequeBANCO: TStringField;
    CdsBaixaChequeCLIENTE: TStringField;
    UniPanel7: TUniPanel;
    UniPanel9: TUniPanel;
    UniPanel10: TUniPanel;
    UniCheckBoxIntervalo: TUniCheckBox;
    UniPanel6: TUniPanel;
    UniLabelValorTitulos: TUniFormattedNumberEdit;
    CdsConsultaSomaValor: TAggregateField;
    UniSweetAlertVerificaIntervalo: TUniSweetAlert;
    UniPanel3: TUniPanel;
    BotaoBaixarCheque: TUniButton;
    LabelQtdBaixaCh: TUniLabel;
    UniImageList2: TUniImageList;
    UniPanelIntervalo: TUniPanel;
    UniBotaoMesAnterior: TUniButton;
    UniBotaoMesPosterior: TUniButton;
    uniEditAno: TUniEdit;
    UniDateTimePickerInicial: TUniDateTimePicker;
    UniDateTimePickerFinal: TUniDateTimePicker;
    CdsConsultaID: TFloatField;
    CdsConsultaCLIENTE_ID: TFloatField;
    CdsConsultaCIDADE_ID: TFloatField;
    CdsConsultaVENDEDOR_ID: TFloatField;
    CdsConsultaDESTINO_ID: TFloatField;
    CdsConsultaCLIENTE_EMITENTE_ID: TFloatField;
    CdsConsultaLOTE_NUMERO: TWideStringField;
    CdsConsultaPROPRIO_CLIENTE: TWideStringField;
    CdsConsultaNUMERO: TWideStringField;
    CdsConsultaDIGITO: TWideStringField;
    CdsConsultaCONTA_CORRENTE: TWideStringField;
    CdsConsultaBANCO_ID: TFloatField;
    CdsConsultaAGENCIA: TWideStringField;
    CdsConsultaDATA_DEPOSITO: TDateTimeField;
    CdsConsultaOBSERVACAO: TWideStringField;
    CdsConsultaCODIGO_CMC7: TWideStringField;
    CdsConsultaDATA_DEVOLUCAO: TDateTimeField;
    CdsConsultaMOTIVO_DEVOLUCAO: TWideStringField;
    CdsConsultaVALOR_CHEQUE: TFloatField;
    CdsConsultaATIVO: TWideStringField;
    CdsConsultaOBSERVACAO_1: TWideStringField;
    CdsConsultaPESSOA_ID: TFloatField;
    CdsConsultaTIPO: TWideStringField;
    CdsConsultaCLIENTE: TWideStringField;
    CdsConsultaCPF_CNPJ: TWideStringField;
    CdsConsultaSEXO: TWideStringField;
    CdsConsultaGERAL_ENDERECO_ID: TFloatField;
    CdsConsultaGERAL_LOGRADOURO: TWideStringField;
    CdsConsultaGERAL_NUMERO: TWideStringField;
    CdsConsultaGERAL_COMPLEMENTO: TWideStringField;
    CdsConsultaGERAL_PONTO_REFERENCIA: TWideStringField;
    CdsConsultaGERAL_CEP: TWideStringField;
    CdsConsultaGERAL_BAIRRO: TWideStringField;
    CdsConsultaGERAL_NOME_CONTATO: TWideStringField;
    CdsConsultaGERAL_TELEFONE_1: TWideStringField;
    CdsConsultaGERAL_TELEFONE_2: TWideStringField;
    CdsConsultaGERAL_CELULAR: TWideStringField;
    CdsConsultaGERAL_EMAIL: TWideStringField;
    CdsConsultaGERAL_CIDADE_ID: TFloatField;
    CdsConsultaGERAL_CIDADE: TWideStringField;
    CdsConsultaCIDADE: TWideStringField;
    CdsConsultaCLIENTE_EMITENTE: TWideStringField;
    CdsConsultaCPF_CNPJ_EMITENTE_CHEQUE: TWideStringField;
    CdsConsultaDATA_VENCIMENTO: TWideStringField;
    CdsConsultaDATA_CADASTRO: TWideStringField;
    CdsConsultaSITUACAO: TWideStringField;
    CdsConsultaCHEQUE_SITUACAO: TWideStringField;
    CdsConsultaMARCADO_PARA_DEPOSITAR: TWideStringField;
    procedure GrdResultadoCellClick(Column: TUniDBGridColumn);
    procedure BotaoBaixarChequeClick(Sender: TObject);
    procedure CdsConsultaCHEQUE_SITUACAOGetText(Sender: TField;
      var Text: string; DisplayText: Boolean);
    procedure UniFrameCreate(Sender: TObject);
    procedure UniCheckBoxIntervaloClick(Sender: TObject);
    procedure UniSweetAlertVerificaIntervaloConfirm(Sender: TObject);
    procedure UniSweetAlertVerificaIntervaloDismiss(Sender: TObject;
      const Reason: TDismissType);
    procedure UniBotaoMesAnteriorClick(Sender: TObject);
    procedure UniBotaoMesPosteriorClick(Sender: TObject);
    procedure UniDateTimePickerInicialChange(Sender: TObject);
    procedure UniDateTimePickerFinalChange(Sender: TObject);
    procedure UniSweetExclusaoRegistroConfirm(Sender: TObject);
    procedure BotaoAtualizarClick(Sender: TObject);
  private
    procedure ConsultaTitulosMes(DataInicial, DataFinal: String; FullConsulta: String = 'N');
    procedure VerificaIntervalo(fullconsulta: string = 'N');
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

uses Controle.Main.Module, Controle.Cadastro.Cheque, Controle.Main,
  Controle.Consulta.ChequesRecebidos.Baixa,Controle.Funcoes, System.DateUtils;


procedure TControleConsultaChequesRecebidos.BotaoAtualizarClick(
  Sender: TObject);
begin
//  inherited;
 CdsConsulta.Close;
 CdsConsulta.Open;
end;

procedure TControleConsultaChequesRecebidos.BotaoBaixarChequeClick(
  Sender: TObject);
begin
  inherited;
  if CdsBaixaCheque.RecordCount = 0 then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção',
                         'Primeiro você deve selecionar os cheques para depois realizar as baixas!');
  end
  else
  begin
    ControleConsultaChequesRecebidosBaixa.CdsConsulta.CloneCursor(CdsBaixaCheque,False,false);
    ControleConsultaChequesRecebidosBaixa.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
      if Result = 1 then
      begin
        LabelQtdBaixaCh.Caption := '0';
        CdsConsulta.Close;
        CdsConsulta.Open;
      end;
//      else
//      begin
////        LabelQtdBaixaCh.Caption := '0';
////        CdsBaixaCheque.Close;
////        CdsBaixaCheque.CreateDataSet;
//        //UniSweetExclusaoRegistro.Show;
//      end;
    end);
  end;
end;

procedure TControleConsultaChequesRecebidos.CdsConsultaCHEQUE_SITUACAOGetText(
  Sender: TField; var Text: string; DisplayText: Boolean);
begin
  inherited;
  if Sender.AsString = 'DEPOSITAR' then
  begin
    if CdsConsultaMARCADO_PARA_DEPOSITAR.AsString = 'N' then
      Text := '<img src=./files/icones/upload.png height=20 align="center" />'
    else
      Text := '<img src=./files/icones/dowup.png height=20 align="center" />'
  end
  else if Sender.AsString = 'DEPOSITADO' then
    Text := '<img src=./files/icones/check-outline.png height=20 align="center" />'
  else if Sender.AsString = 'DEVOLVIDO' then
    Text := '<img src=./files/icones/check-message-alert.png height=20 align="center" />'
end;

procedure TControleConsultaChequesRecebidos.GrdResultadoCellClick(
  Column: TUniDBGridColumn);
var
  qtdlabel : Integer;
begin
  inherited;
  if Column.FieldName = 'CHEQUE_SITUACAO' then
  begin
    if CdsConsultaSITUACAO.AsString = 'DEPOSITAR' then
    begin
      if CdsConsultaMARCADO_PARA_DEPOSITAR.AsString = 'N' then
      begin
        // Alimentando o cds temporario
        CdsBaixaCheque.Insert;
        CdsBaixaChequeID.AsInteger          := CdsConsultaID.AsInteger;
        CdsBaixaChequeVALOR.AsFloat         := CdsConsultaVALOR_CHEQUE.AsFloat;
        //CdsBaixaChequeBANCO.AsString        := CdsConsultaBANCO.AsString;
        CdsBaixaChequeCLIENTE.AsString      := CdsConsultaCLIENTE.AsString;
        CdsBaixaChequeVENCIMENTO.AsDateTime := CdsConsultaDATA_VENCIMENTO.AsDateTime;
        CdsBaixaCheque.Post;

        qtdlabel := StrToInt(LabelQtdBaixaCh.Caption);
        qtdlabel := qtdlabel +1;
        LabelQtdBaixaCh.Caption := IntToStr(qtdlabel);

        CdsConsulta.Edit;
        CdsConsultaMARCADO_PARA_DEPOSITAR.AsString := 'S';
        CdsConsulta.Post;
      end
      else
      begin
        CdsBaixaCheque.Delete;

        qtdlabel := StrToInt(LabelQtdBaixaCh.Caption);
        qtdlabel := qtdlabel -1;
        LabelQtdBaixaCh.Caption := IntToStr(qtdlabel);

        CdsConsulta.Edit;
        CdsConsultaMARCADO_PARA_DEPOSITAR.AsString := 'N';
        CdsConsulta.Post;
      end;
    end;
  end;
  //CdsConsulta.Post;
end;

procedure TControleConsultaChequesRecebidos.Novo;
begin
  if ControleCadastroCheque.Novo() then
  begin
    ControleCadastroCheque.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
      CdsConsulta.Close;
      CdsConsulta.Open;
    end);
  end;
end;

procedure TControleConsultaChequesRecebidos.UniBotaoMesAnteriorClick(
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

procedure TControleConsultaChequesRecebidos.UniBotaoMesPosteriorClick(
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

procedure TControleConsultaChequesRecebidos.UniCheckBoxIntervaloClick(
  Sender: TObject);
begin
  inherited;
  if UniCheckBoxIntervalo.Checked = True  then
    UniSweetAlertVerificaIntervalo.show
  else
     VerificaIntervalo();
end;

procedure TControleConsultaChequesRecebidos.VerificaIntervalo(fullconsulta : string ='N');
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

procedure TControleConsultaChequesRecebidos.UniFrameCreate(Sender: TObject);
Var
  DtInicial, DtFinal : String;
begin
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

  LabelQtdBaixaCh.Caption := '0';
  FNomeTabela := 'cheque';
end;

procedure TControleConsultaChequesRecebidos.UniSweetAlertVerificaIntervaloConfirm(
  Sender: TObject);
begin
  inherited;
  VerificaIntervalo('S');
end;

procedure TControleConsultaChequesRecebidos.UniSweetAlertVerificaIntervaloDismiss(
  Sender: TObject; const Reason: TDismissType);
begin
  inherited;
  UniCheckBoxIntervalo.Checked := False;
end;

procedure TControleConsultaChequesRecebidos.UniSweetExclusaoRegistroConfirm(
  Sender: TObject);
begin
  inherited;
  LabelQtdBaixaCh.Caption := '0';
  CdsBaixaCheque.Close;
  CdsBaixaCheque.CreateDataSet;
end;

procedure TControleConsultaChequesRecebidos.ConsultaTitulosMes(DataInicial, DataFinal: String;
                                                          FullConsulta: String = 'N');

begin


  CdsConsulta.Filtered := False;

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


// -------------------------------------------------------------------------- //
procedure TControleConsultaChequesRecebidos.Abrir(Id: Integer);
begin
  // Abre o formulário de cadastro para visualização e edição
  if ControleCadastroCheque.Abrir(Id) then
  begin
    ControleCadastroCheque.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
//      if Result = 1 then
        CdsConsulta.Refresh;
    end);
  end;
end;

procedure TControleConsultaChequesRecebidos.UniDateTimePickerFinalChange(
  Sender: TObject);
begin
  inherited;
    ConsultaTitulosMes(DateToStr(UniDateTimePickerInicial.DateTime),
                        DateToStr(UniDateTimePickerFinal.DateTime));
end;

procedure TControleConsultaChequesRecebidos.UniDateTimePickerInicialChange(
  Sender: TObject);
begin
  inherited;
    ConsultaTitulosMes(DateToStr(UniDateTimePickerInicial.DateTime),
                        DateToStr(UniDateTimePickerFinal.DateTime));
end;

end.
