unit Controle.Cadastro.BaixarTituloReceber;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, uniButton, Vcl.Imaging.pngimage, uniImage, uniEdit,
  uniMultiItem, uniComboBox, uniDBComboBox, uniDBLookupComboBox, uniLabel,
  uniGUIBaseClasses, uniPanel, Data.DB, Datasnap.Provider, Datasnap.DBClient,
  Data.Win.ADODB,  uniBasicGrid, uniDBGrid, uniPageControl,
  uniDBEdit, uniImageList, frxClass, frxExportBaseDialog, frxExportPDF, frxDBSet,
  uniSweetAlert, Controle.Main.Module, uniBitBtn, uniSpeedButton;

type
  TControleCadastroBaixarTituloReceber = class(TUniForm)
    UniPanel1: TUniPanel;
    UniPanel2: TUniPanel;
    UniLabel12: TUniLabel;
    EditValorPago: TUniFormattedNumberEdit;
    UniLabel11: TUniLabel;
    QryCondicoesPagamento: TADOQuery;
    QryCadastro: TADOQuery;
    CdsCondicoesPagamento: TClientDataSet;
    CdsCadastro: TClientDataSet;
    DspCondicoesPagamento: TDataSetProvider;
    DspCadastro: TDataSetProvider;
    DscCondicoesPagamento: TDataSource;
    DscCadastro: TDataSource;
    UniDBLookupComboBoxFormaPag: TUniDBLookupComboBox;
    UniDBGrid1: TUniDBGrid;
    UniPageControl1: TUniPageControl;
    UniTabSheet1: TUniTabSheet;
    UniTabSheet2: TUniTabSheet;
    CdsPagamento: TClientDataSet;
    DscPagamento: TDataSource;
    UniImageList1: TUniImageList;
    Conexao_recibo_pagamento: TfrxDBDataset;
    Relatorio_Export: TfrxPDFExport;
    UniSweetAlertaImprimeRecibo: TUniSweetAlert;
    Conexao_Recibo: TfrxDBDataset;
    CdsPagamentoFORMA_PAGAMENTO: TStringField;
    Relatorio_Recibo: TfrxReport;
    CdsPagamentoVALOR_PAGO: TFloatField;
    UniLabel1: TUniLabel;
    UniFormattedNumberEditJuros: TUniFormattedNumberEdit;
    UniLabel5: TUniLabel;
    UniFormattedNumberEditMulta: TUniFormattedNumberEdit;
    UniLabel6: TUniLabel;
    UniFormattedNumberEditDesconto: TUniFormattedNumberEdit;
    UniPanelCalculo: TUniPanel;
    UniPanel11: TUniPanel;
    LabelValorOriginal: TUniLabel;
    UniLabelRecebimento: TUniLabel;
    UniImage3: TUniImage;
    UniPanel5: TUniPanel;
    LabelValorJurosPrevisto: TUniLabel;
    UniLabel15: TUniLabel;
    UniImage1: TUniImage;
    UniPanel7: TUniPanel;
    LabelValorAtualizado: TUniLabel;
    UniLabel17: TUniLabel;
    UniImage2: TUniImage;
    UniPanel3: TUniPanel;
    LabelMultaPrevista: TUniLabel;
    UniLabel10: TUniLabel;
    UniImage4: TUniImage;
    UniPanel4: TUniPanel;
    LabelDiasAtraso: TUniLabel;
    UniLabel2: TUniLabel;
    UniImage5: TUniImage;
    UniPanel6: TUniPanel;
    UniPanel21: TUniPanel;
    UniPanelCaption: TUniPanel;
    UniLabelCaption: TUniLabel;
    UniSpeedCaptionClose: TUniSpeedButton;
    UniImageCaptionMaximizar: TUniSpeedButton;
    BtReceber: TUniButton;
    BtCancelar: TUniButton;
    UniSweetAlertaFechaFormulario: TUniSweetAlert;
    UniImageCaptionClose: TUniImageList;
    CdsCadastroID: TFloatField;
    CdsCadastroCLIENTE_ID: TFloatField;
    CdsCadastroNUMERO_DOCUMENTO: TWideStringField;
    CdsCadastroNUMERO_CARNE: TWideStringField;
    CdsCadastroNATUREZA: TWideStringField;
    CdsCadastroDATA_EMISSAO: TDateTimeField;
    CdsCadastroDATA_VENCIMENTO: TDateTimeField;
    CdsCadastroVALOR: TFloatField;
    CdsCadastroVALOR_MULTA: TFloatField;
    CdsCadastroVALOR_JUROS: TFloatField;
    CdsCadastroDIAS_ATRASO: TFloatField;
    CdsCadastroVALOR_LIQUIDADO: TFloatField;
    CdsCadastroVALOR_SALDO: TFloatField;
    CdsCadastroVALOR_PAGO: TFloatField;
    CdsCadastroSITUACAO: TWideStringField;
    CdsCadastroVENCIDO: TWideStringField;
    CdsCadastroDATA_LIQUIDACAO: TDateTimeField;
    CdsCadastroHISTORICO: TWideStringField;
    CdsCadastroCLIENTE: TWideStringField;
    CdsCadastroCPF_CNPJ: TWideStringField;
    CdsCadastroCONDICOES_PAGAMENTO_DESCRICAO: TWideStringField;
    CdsCadastroSEQUENCIA_PARCELAS: TFloatField;
    CdsCadastroCONTA_BANCARIA_ID: TFloatField;
    CdsCadastroCONDICOES_PAGAMENTO_ID: TFloatField;
    CdsCondicoesPagamentoID: TFloatField;
    CdsCondicoesPagamentoDESCRICAO: TWideStringField;
    CdsCondicoesPagamentoTIPO: TWideStringField;
    CdsCondicoesPagamentoATIVO: TWideStringField;
    CdsCondicoesPagamentoORDEM_EXIBICAO: TFloatField;
    CdsCondicoesPagamentoGERA_CARNE: TWideStringField;
    CdsCondicoesPagamentoGERA_BOLETO: TWideStringField;
    CdsCondicoesPagamentoGERA_CHEQUE: TWideStringField;
    AlertCadastroCheque: TUniSweetAlert;
    procedure BtReceberClick(Sender: TObject);
    procedure BtCancelarClick(Sender: TObject);
    procedure UniFormShow(Sender: TObject);
    procedure UniFormClose(Sender: TObject; var Action: TCloseAction);
    procedure UniSweetAlertaImprimeReciboConfirm(Sender: TObject);
    procedure UniSweetAlertaImprimeReciboDismiss(Sender: TObject;
      const Reason: TDismissType);
    procedure UniFormattedNumberEditJurosChange(Sender: TObject);
    procedure UniFormattedNumberEditMultaChange(Sender: TObject);
    procedure UniFormattedNumberEditDescontoChange(Sender: TObject);
    procedure UniSpeedCaptionCloseClick(Sender: TObject);
    procedure UniFormCreate(Sender: TObject);
    procedure EditValorPagoEnter(Sender: TObject);
    procedure AlertCadastroChequeConfirm(Sender: TObject);
  private
    SomaFormasPagamentoRecebidas : Double;
    ChequeId, Titulo_Pagamentos_id : Integer;
    function RegistraTituloPagamentos(IdDoTitulo :Integer;
                                      IdDaFormaDePagamento : Integer;
                                      ValorPagoParaEssaFormaDePagamento :Double): Boolean;
    function RegistraCheque(IdDoTitulo,
                            IdCondicoesPagamento: Integer;
                            IdDoCliente : Integer;
                            Valor: Double;
                            DataDoVencimento: TDateTime): Boolean;
    { Private declarations }
  public
    Calcula : TCalJurosMulta;
    procedure CalculoParaBaixa(Id: Integer;
                               Valor_desconto : Double);
    { Public declarations }
  end;


function ControleCadastroBaixarTituloReceber: TControleCadastroBaixarTituloReceber;

implementation

{$R *.dfm}

uses
  System.Math, uniGUIApplication,Controle.Funcoes,Controle.Cadastro.Cheque;

function ControleCadastroBaixarTituloReceber: TControleCadastroBaixarTituloReceber;
begin
  Result := TControleCadastroBaixarTituloReceber(ControleMainModule.GetFormInstance(TControleCadastroBaixarTituloReceber));
end;

procedure TControleCadastroBaixarTituloReceber.CalculoParaBaixa(Id: Integer;
                                                         Valor_desconto : Double);
begin
  CdsCadastro.Close;
  QryCadastro.Parameters.ParamByName('id').Value := id;
  CdsCadastro.Open;

  CdsCondicoesPagamento.Open;

  Calcula := ControleMainModule.CalculaJurosMulta(CdsCadastroDIAS_ATRASO.AsInteger,
                                                  CdsCadastroVALOR.AsFloat,
                                                  ControleMainModule.percentual_juros,
                                                  ControleMainModule.percentual_multa,
                                                  CdsCadastroDIAS_ATRASO.AsInteger,
                                                  valor_desconto);

  LabelDiasAtraso.Caption         := CdsCadastroDIAS_ATRASO.AsString;
  LabelValorOriginal.Caption      := formatfloat('R$ #,##0.00', CdsCadastroVALOR.AsFloat);
  LabelMultaPrevista.Caption      := formatfloat('R$ #,##0.00', Calcula.ValorMulta);
  LabelValorJurosPrevisto.Caption := formatfloat('R$ #,##0.00', Calcula.ValorJuros);
  LabelValorAtualizado.Caption    := formatfloat('R$ #,##0.00', Calcula.ValorAtualizadoComDesconto);

  UniFormattedNumberEditJuros.Text     := formatfloat('0.00', Calcula.ValorJuros);
  UniFormattedNumberEditMulta.Text     := formatfloat('0.00', Calcula.ValorMulta);
  UniFormattedNumberEditDesconto.Text  := formatfloat('0.00', 0);
  EditValorPago.Text                   := formatfloat('0.00', Calcula.ValorAtualizadoComDesconto);
end;

procedure TControleCadastroBaixarTituloReceber.EditValorPagoEnter(Sender: TObject);
begin
  EditValorPago.SelectAll;
end;

procedure TControleCadastroBaixarTituloReceber.AlertCadastroChequeConfirm(
  Sender: TObject);
begin
  ControleCadastroCheque.Abrir(ChequeId);
  ControleCadastroCheque.ShowModal;
end;

procedure TControleCadastroBaixarTituloReceber.BtCancelarClick(Sender: TObject);
begin
  //Verifica se tem transação aberta e descarta
  if ControleMainModule.ADOConnection.InTransaction = False then
    ControleMainModule.ADOConnection.CommitTrans;

  Close;
end;

procedure TControleCadastroBaixarTituloReceber.BtReceberClick(Sender: TObject);
var
  Forma_pagamento_id : Integer;
  ValorPago: Double;
begin
  if TryStrToFloat(EditValorPago.Text, ValorPago) = False then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção','Digite um valor válido');
    Exit;
  end;

  if UniDBLookupComboBoxFormaPag.Text = '' then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção','Escolha uma forma de pagamento');
    UniDBLookupComboBoxFormaPag.SetFocus;
    Exit;
  end
  else if ValorPago <= 0 then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção','O valor recebido tem que ser maior que zero.');
    EditValorPago.SetFocus;
    Exit;
  end
  else if RoundTo((ValorPago),-2) >  RoundTo((Calcula.ValorAtualizadoComDesconto),-2) then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção','O valor informado é maior que o valor do saldo a pagar');
    EditValorPago.SetFocus;
    Exit;
  end;

  SomaFormasPagamentoRecebidas := SomaFormasPagamentoRecebidas + ValorPago;

  with ControleMainModule do
  begin
    // Inicia a transação
    if ADOConnection.Connected = false then
      ADOConnection.Open;

    if ADOConnection.InTransaction = False then
      ADOConnection.BeginTrans;

    //registra movimento do caixa
    registra_movimento(FNumeroCaixaLogado,
                        'C',
                        'RC',
                        ValorPago,
                        CdsCondicoesPagamentoID.AsInteger,
                        'Referente ao título n.º '+ inttoStr(CdsCadastroID.AsInteger));

    //registra as formas de recebimento no título_pagamentos
    RegistraTituloPagamentos(CdsCadastroID.AsInteger,
                              CdsCondicoesPagamentoID.AsInteger,
                              ValorPago);

    //Registra informações do cheque.
    if CdsCondicoesPagamentoGERA_CHEQUE.AsString = 'S' then
    begin
      if RegistraCheque(Titulo_Pagamentos_id,
                     CdsCondicoesPagamentoID.AsInteger,
                     CdsCadastroCLIENTE_ID.AsInteger,
                     ValorPago,
                     CdsCadastroDATA_VENCIMENTO.AsDateTime)= True then
    end;

    EditValorPago.Text :=  FloatToStr(RoundTo((Calcula.ValorAtualizadoComDesconto),-2) - RoundTo((SomaFormasPagamentoRecebidas),-2));

    if RoundTo((SomaFormasPagamentoRecebidas),-2) =  RoundTo((Calcula.ValorAtualizadoComDesconto),-2) then
    begin
      Try
        ControleMainModule.BaixaTituloReceber(CdsCadastroID.AsInteger,
                                              CdsCadastroCONTA_BANCARIA_ID.AsInteger,
                                              RoundTo(CdsCadastroVALOR.AsFloat,-2),
                                              Calcula.ValorJuros,
                                              Calcula.ValorMulta,
                                              SomaFormasPagamentoRecebidas,//valor total pago
                                              UniFormattedNumberEditDesconto.Value,
                                              CdsCadastroHISTORICO.AsString,
                                              CdsCadastroDATA_VENCIMENTO.AsDateTime,
                                              Date,
                                              CdsCadastroDIAS_ATRASO.AsInteger,
                                              CdsCadastroNUMERO_CARNE.AsString,
                                              CdsCadastroSEQUENCIA_PARCELAS.AsString,
                                              CdsCondicoesPagamentoID.AsInteger);

        // Confirma a transação
        ADOConnection.CommitTrans;

        UniSweetAlertaImprimeRecibo.Show();
      Except
        on E: Exception do
        begin
          // Descarta a transação
          ADOConnection.RollbackTrans;
          ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));
        end;
      End;
    end;
  end;
end;
function TControleCadastroBaixarTituloReceber.RegistraTituloPagamentos(IdDoTitulo :Integer;
                                                                          IdDaFormaDePagamento : Integer;
                                                                          ValorPagoParaEssaFormaDePagamento :Double):Boolean;
begin
  with ControleMainModule do
  begin
    Titulo_Pagamentos_id := GeraId('titulo_pagamentos');

      // Passo Unico - Salva os dados da cidade
    QryAx4.Parameters.Clear;
    QryAx4.SQL.Clear;
    // Insert
    QryAx4.SQL.Add('INSERT INTO titulo_pagamentos (');
    QryAx4.SQL.Add('       id,');
    QryAx4.SQL.Add('       titulo_id,');
    QryAx4.SQL.Add('       condicoes_pagamento_id,');
    QryAx4.SQL.Add('       valor_pago)');
    QryAx4.SQL.Add('VALUES (');
    QryAx4.SQL.Add('       :pid,');
    QryAx4.SQL.Add('       :ptitulo_id,');
    QryAx4.SQL.Add('       :pcondicoes_pagamento_id,');
    QryAx4.SQL.Add('       :pvalor_pago)');

    QryAx4.Parameters.ParamByName('pid').Value                      := Titulo_Pagamentos_id;
    QryAx4.Parameters.ParamByName('ptitulo_id').Value               := CdsCadastroID.AsInteger;
    QryAx4.Parameters.ParamByName('pcondicoes_pagamento_id').Value  := CdsCondicoesPagamentoID.AsInteger;
    QryAx4.Parameters.ParamByName('pvalor_pago').Value              := ValorPagoParaEssaFormaDePagamento;

    try
      // Tenta salvar os dados
      QryAx4.ExecSQL;

      CdsPagamento.Insert;
      CdsPagamentoforma_pagamento.AsString  := CdsCondicoesPagamentoDESCRICAO.AsString;
      CdsPagamentovalor_pago.AsFloat        := ValorPagoParaEssaFormaDePagamento;
      CdsPagamento.Post;
    Except
      on E: Exception do
      begin
        // Descarta a transação
        ADOConnection.RollbackTrans;
        ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));
      end;
    End;;
  end;
end;


function TControleCadastroBaixarTituloReceber.RegistraCheque(IdDoTitulo : Integer;
                                                             IdCondicoesPagamento : Integer;
                                                             IdDoCliente : Integer;
                                                             Valor : Double;
                                                             DataDoVencimento : TDateTime): Boolean;
begin
  Result := False;

  with ControleMainModule do
  begin
    ChequeId := GeraId('cheque');

    QryAx3.Parameters.Clear;
    QryAx3.SQL.Clear;

    // Insert
    QryAx3.SQL.Add('INSERT INTO cheque (');
    QryAx3.SQL.Add('       id,');
    QryAx3.SQL.Add('       cliente_id,');
    QryAx3.SQL.Add('       cliente_emitente_id,');
    QryAx3.SQL.Add('       situacao,');
    QryAx3.SQL.Add('       titulo_pagamento_id,');
    QryAx3.SQL.Add('       valor_cheque,');
    QryAx3.SQL.Add('       data_vencimento)');
    QryAx3.SQL.Add('VALUES (');
    QryAx3.SQL.Add('       :id,');
    QryAx3.SQL.Add('       :cliente_id,');
    QryAx3.SQL.Add('       :cliente_emitente_id,');
    QryAx3.SQL.Add('       :situacao,');
    QryAx3.SQL.Add('       :titulo_pagamento_id,');
    QryAx3.SQL.Add('       :valor_cheque,');
    QryAx3.SQL.Add('       :data_vencimento)');

    QryAx3.Parameters.ParamByName('id').Value                     := ChequeId;
    QryAx3.Parameters.ParamByName('cliente_id').Value             := IdDoCliente;
    QryAx3.Parameters.ParamByName('cliente_emitente_id').Value    := IdDoCliente;
    QryAx3.Parameters.ParamByName('situacao').Value               := 'DEPOSITAR';
    QryAx3.Parameters.ParamByName('titulo_pagamento_id').Value    := IdDoTitulo;
    QryAx3.Parameters.ParamByName('valor_cheque').Value           := Valor;
    QryAx3.Parameters.ParamByName('data_vencimento').Value        := DataDoVencimento;

    try
      // Tenta salvar os dados
      QryAx3.ExecSQL;
      Result := True;
    except
      on E: Exception do
      begin
        ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));
      end;
    end;
  end;
end;

procedure TControleCadastroBaixarTituloReceber.UniFormattedNumberEditDescontoChange(
  Sender: TObject);
var
  valor_Desconto : Double;
begin
  if TryStrToFloat(UniFormattedNumberEditJuros.Text, valor_Desconto) then
  begin
    if valor_Desconto > 0 then
    begin
      CalculoParaBaixa(CdsCadastroID.AsInteger,
                       UniFormattedNumberEditDesconto.Value);
    end;
  end
  else
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Digite um valor válido');
  end;
  CalculoParaBaixa(CdsCadastroID.AsInteger,
                   UniFormattedNumberEditDesconto.Value);
end;

procedure TControleCadastroBaixarTituloReceber.UniFormattedNumberEditJurosChange(
  Sender: TObject);
var
  valor_Juros : Double;
begin
  if TryStrToFloat(UniFormattedNumberEditJuros.Text, valor_Juros) then
  begin
    if valor_Juros > 0 then
    begin
      CalculoParaBaixa(CdsCadastroID.AsInteger,
                       UniFormattedNumberEditJuros.Value);
    end;
  end
  else
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Digite um valor válido');
  end;
end;

procedure TControleCadastroBaixarTituloReceber.UniFormattedNumberEditMultaChange(
  Sender: TObject);
var
  valor_Multa : Double;
begin
  if TryStrToFloat(UniFormattedNumberEditMulta.Text, valor_Multa) then
  begin
    if valor_Multa > 0 then
    begin
      CalculoParaBaixa(CdsCadastroID.AsInteger,
                       UniFormattedNumberEditMulta.Value);
    end;
  end
  else
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Digite um valor válido');
  end;
end;

procedure TControleCadastroBaixarTituloReceber.UniFormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if ControleMainModule.ADOConnection.InTransaction = True then
    ControleMainModule.ADOConnection.RollbackTrans;
end;

procedure TControleCadastroBaixarTituloReceber.UniFormCreate(Sender: TObject);
begin
  self.BorderStyle := bsNone;
end;

procedure TControleCadastroBaixarTituloReceber.UniFormShow(Sender: TObject);
begin
  CdsPagamento.CreateDataSet;
  CdsPagamento.Open;

  UniLabelCaption.Text := Self.Caption;
end;

procedure TControleCadastroBaixarTituloReceber.UniSpeedCaptionCloseClick(
  Sender: TObject);
begin
  if CdsCadastro.State in [dsInsert, dsEdit] then
  begin
    if Self.Tag <> 5 then
    begin
      UniSweetAlertaFechaFormulario.Show; // O código fica no evento do componente!
    end
    else
      Close;
  end
  else
    Close;
end;

procedure TControleCadastroBaixarTituloReceber.UniSweetAlertaImprimeReciboConfirm(
  Sender: TObject);
begin
  Relatorio_Recibo.Variables.Variables['Razaoempresa']  := QuotedStr(ControleMainModule.FRazaoSocial);
  Relatorio_Recibo.Variables.Variables['EditJuros']     := UniFormattedNumberEditJuros.Value;
  Relatorio_Recibo.Variables.Variables['EditMulta']     := UniFormattedNumberEditMulta.Value;
  Relatorio_Recibo.Variables.Variables['EditDesconto']  := UniFormattedNumberEditDesconto.Value;
  ControleMainModule.ExportarPDF('Relatorio',Relatorio_Recibo);
  Close;
end;

procedure TControleCadastroBaixarTituloReceber.UniSweetAlertaImprimeReciboDismiss(
  Sender: TObject; const Reason: TDismissType);
begin
  Close;
end;

{ TCalculaAcrescimoDesconto }

end.
