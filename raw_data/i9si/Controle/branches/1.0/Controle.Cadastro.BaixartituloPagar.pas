unit Controle.Cadastro.BaixartituloPagar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, frxClass, uniSweetAlert, frxExportBaseDialog,
  frxExportPDF, frxDBSet, uniGUIBaseClasses, uniImageList, Data.DB,
  Datasnap.Provider, Datasnap.DBClient, Data.Win.ADODB, uniButton, uniBitBtn,
  uniSpeedButton, uniBasicGrid, uniDBGrid, uniMultiItem, uniComboBox,
  uniDBComboBox, uniDBLookupComboBox, uniEdit, uniPageControl,
  Vcl.Imaging.pngimage, uniImage, uniLabel, uniPanel, Controle.Main.Module;

type
  TControleCadastroBaixartituloPagar = class(TUniForm)
    UniPanel1: TUniPanel;
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
    UniPanel2: TUniPanel;
    UniPageControl1: TUniPageControl;
    UniTabSheet1: TUniTabSheet;
    EditValorPago: TUniFormattedNumberEdit;
    UniDBLookupComboBoxFormaPag: TUniDBLookupComboBox;
    UniLabel11: TUniLabel;
    UniLabel12: TUniLabel;
    UniLabel1: TUniLabel;
    UniFormattedNumberEditJuros: TUniFormattedNumberEdit;
    UniFormattedNumberEditMulta: TUniFormattedNumberEdit;
    UniFormattedNumberEditDesconto: TUniFormattedNumberEdit;
    UniLabel5: TUniLabel;
    UniLabel6: TUniLabel;
    UniTabSheet2: TUniTabSheet;
    UniDBGrid1: TUniDBGrid;
    UniPanel6: TUniPanel;
    UniPanel21: TUniPanel;
    UniPanelCaption: TUniPanel;
    UniLabelCaption: TUniLabel;
    UniSpeedCaptionClose: TUniSpeedButton;
    UniImageCaptionMaximizar: TUniSpeedButton;
    BtReceber: TUniButton;
    BtCancelar: TUniButton;
    QryCondicoesPagamento: TADOQuery;
    QryCondicoesPagamentoID: TFloatField;
    QryCondicoesPagamentoDESCRICAO: TWideStringField;
    QryCadastro: TADOQuery;
    CdsCondicoesPagamento: TClientDataSet;
    CdsCondicoesPagamentoID: TFloatField;
    CdsCondicoesPagamentoDESCRICAO: TWideStringField;
    CdsCadastro: TClientDataSet;
    DspCondicoesPagamento: TDataSetProvider;
    DspCadastro: TDataSetProvider;
    DscCondicoesPagamento: TDataSource;
    DscCadastro: TDataSource;
    CdsPagamento: TClientDataSet;
    CdsPagamentoFORMA_PAGAMENTO: TStringField;
    CdsPagamentoVALOR_PAGO: TFloatField;
    DscPagamento: TDataSource;
    Relatorio_Export: TfrxPDFExport;
    UniSweetAlertaFechaFormulario: TUniSweetAlert;
    UniImageCaptionClose: TUniImageList;
    UniImageList1: TUniImageList;
    QryCadastroID: TFloatField;
    QryCadastroFORNECEDOR_ID: TFloatField;
    QryCadastroCONDICOES_PAGAMENTO_ID: TFloatField;
    QryCadastroNUMERO_DOCUMENTO: TWideStringField;
    QryCadastroSEQUENCIA_PARCELAS: TFloatField;
    QryCadastroNATUREZA: TWideStringField;
    QryCadastroDATA_EMISSAO: TDateTimeField;
    QryCadastroDATA_VENC_ORIGINAL: TDateTimeField;
    QryCadastroDATA_VENCIMENTO: TDateTimeField;
    QryCadastroVALOR: TFloatField;
    QryCadastroDIAS_ATRASO: TFloatField;
    QryCadastroSITUACAO: TWideStringField;
    QryCadastroVENCIDO: TWideStringField;
    QryCadastroDATA_LIQUIDACAO: TDateTimeField;
    QryCadastroVALOR_PAGO: TFloatField;
    QryCadastroVALOR_SALDO: TFloatField;
    QryCadastroHISTORICO: TWideStringField;
    QryCadastroFORNECEDOR: TWideStringField;
    QryCadastroCPF_CNPJ: TWideStringField;
    QryCadastroCONDICOES_PAGAMENTO: TWideStringField;
    QryCadastroCONTA_BANCARIA_ID: TFloatField;
    QryCadastroGERA_CARNE: TWideStringField;
    QryCadastroGERA_BOLETO: TWideStringField;
    QryCadastroGERA_CHEQUE: TWideStringField;
    QryCadastroOPCOES: TFloatField;
    QryCadastroPOSSUI_ANEXO: TWideStringField;
    QryCadastroNUMERO_REFERENCIA: TWideStringField;
    QryCadastroCATEGORIA: TWideStringField;
    QryCadastroTITULO_CATEGORIA_ID: TFloatField;
    QryCadastroVALOR_JUROS: TFloatField;
    QryCadastroVALOR_MULTA: TFloatField;
    CdsCadastroID: TFloatField;
    CdsCadastroFORNECEDOR_ID: TFloatField;
    CdsCadastroCONDICOES_PAGAMENTO_ID: TFloatField;
    CdsCadastroNUMERO_DOCUMENTO: TWideStringField;
    CdsCadastroSEQUENCIA_PARCELAS: TFloatField;
    CdsCadastroNATUREZA: TWideStringField;
    CdsCadastroDATA_EMISSAO: TDateTimeField;
    CdsCadastroDATA_VENC_ORIGINAL: TDateTimeField;
    CdsCadastroDATA_VENCIMENTO: TDateTimeField;
    CdsCadastroVALOR: TFloatField;
    CdsCadastroDIAS_ATRASO: TFloatField;
    CdsCadastroSITUACAO: TWideStringField;
    CdsCadastroVENCIDO: TWideStringField;
    CdsCadastroDATA_LIQUIDACAO: TDateTimeField;
    CdsCadastroVALOR_PAGO: TFloatField;
    CdsCadastroVALOR_SALDO: TFloatField;
    CdsCadastroHISTORICO: TWideStringField;
    CdsCadastroFORNECEDOR: TWideStringField;
    CdsCadastroCPF_CNPJ: TWideStringField;
    CdsCadastroCONDICOES_PAGAMENTO: TWideStringField;
    CdsCadastroCONTA_BANCARIA_ID: TFloatField;
    CdsCadastroGERA_CARNE: TWideStringField;
    CdsCadastroGERA_BOLETO: TWideStringField;
    CdsCadastroGERA_CHEQUE: TWideStringField;
    CdsCadastroOPCOES: TFloatField;
    CdsCadastroPOSSUI_ANEXO: TWideStringField;
    CdsCadastroNUMERO_REFERENCIA: TWideStringField;
    CdsCadastroCATEGORIA: TWideStringField;
    CdsCadastroTITULO_CATEGORIA_ID: TFloatField;
    CdsCadastroVALOR_JUROS: TFloatField;
    CdsCadastroVALOR_MULTA: TFloatField;
    procedure BtCancelarClick(Sender: TObject);
    procedure BtReceberClick(Sender: TObject);
    procedure UniFormattedNumberEditJurosChange(Sender: TObject);
    procedure UniFormattedNumberEditMultaChange(Sender: TObject);
    procedure UniFormClose(Sender: TObject; var Action: TCloseAction);
    procedure UniFormCreate(Sender: TObject);
    procedure UniFormShow(Sender: TObject);
    procedure UniSpeedCaptionCloseClick(Sender: TObject);
    procedure EditValorPagoEnter(Sender: TObject);
    procedure UniSweetAlertaFechaFormularioConfirm(Sender: TObject);
    procedure UniSweetAlertaFechaFormularioDismiss(Sender: TObject;
      const Reason: TDismissType);
  private
    SomaFormasPagamentoRecebidas : Double;
    function RegistraFormaPagamentoTitulo(IdDoTitulo, IdDaFormaDePagamento: Integer;
      ValorPagoParaEssaFormaDePagamento: Double): Boolean;
    { Private declarations }
  public
    { Public declarations }
    Calcula : TCalJurosMulta;
    procedure CalculoParaBaixa(Id: Integer; Valor_desconto: Double);
  end;

function ControleCadastroBaixartituloPagar: TControleCadastroBaixartituloPagar;

implementation

{$R *.dfm}

uses
  System.Math, uniGUIApplication,Controle.Funcoes;

function ControleCadastroBaixartituloPagar: TControleCadastroBaixartituloPagar;
begin
  Result := TControleCadastroBaixartituloPagar(ControleMainModule.GetFormInstance(TControleCadastroBaixartituloPagar));
end;

procedure TControleCadastroBaixartituloPagar.BtCancelarClick(Sender: TObject);
begin
  //Verifica se tem transação aberta e descarta
  if ControleMainModule.ADOConnection.InTransaction = True then
    ControleMainModule.ADOConnection.RollbackTrans;

  Close;
end;

procedure TControleCadastroBaixartituloPagar.BtReceberClick(Sender: TObject);
var
  condicoes_pagamento_id : Integer;
  ValorPago: Double;
begin
///1º validação dos campos

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
    with ControleMainModule do
    begin
      if ADOConnection.Connected = false then
          ADOConnection.Open;

      if ADOConnection.InTransaction = False then
        ADOConnection.BeginTrans;
    end;


///2º dá insert no movimento do caixa
    //registra movimento do caixa
    registra_movimento(FNumeroCaixaLogado,
                 'D',
                 'PG',
                 ValorPago,
                 CdsCondicoesPagamentoID.AsInteger,
                 'Referente ao título n.º '+ inttoStr(CdsCadastroID.AsInteger));

///3º dá insert na tabela forma de pagamento do título
    //registra as formas de pagamento que o título foi pago
    RegistraFormaPagamentoTitulo(CdsCadastroID.AsInteger,
                                CdsCondicoesPagamentoID.AsInteger,
                                ValorPago);

    EditValorPago.Text :=  FloatToStr(RoundTo((Calcula.ValorAtualizadoComDesconto),-2) - RoundTo((SomaFormasPagamentoRecebidas),-2));

///4º faz baixa do título
    if RoundTo((SomaFormasPagamentoRecebidas),-2) =  RoundTo((Calcula.ValorAtualizadoComDesconto),-2) then
    begin
      Try
        ControleMainModule.BaixaTituloPagar(CdsCadastroID.AsInteger,
                                            CdsCadastroCONTA_BANCARIA_ID.AsInteger,
                                            RoundTo(CdsCadastroVALOR.AsFloat,-2),
                                            Calcula.ValorJuros,
                                            Calcula.ValorMulta,
                                            SomaFormasPagamentoRecebidas,
                                            CdsCadastroHISTORICO.AsString,
                                            Date,
                                            '',
                                            CdsCadastroSEQUENCIA_PARCELAS.AsString,
                                            '',
                                            CdsCondicoesPagamentoID.AsInteger,
                                            CdsCadastroTITULO_CATEGORIA_ID.AsString);
        // Confirma a transação
        ADOConnection.CommitTrans;
        Close;
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


function TControleCadastroBaixartituloPagar.RegistraFormaPagamentoTitulo(IdDoTitulo :Integer;
                                                                          IdDaFormaDePagamento : Integer;
                                                                          ValorPagoParaEssaFormaDePagamento :Double):Boolean;
var
  condicoes_pagamento_id : Integer;
begin
    with ControleMainModule do
    begin
      Result := False;

       //Id usado para salvar na tabela titulo_forma_pagamento grava com quantas formas de pagamento o titulo foi pago
      condicoes_pagamento_id := GeraId('titulo_pagamentos');

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

      QryAx4.Parameters.ParamByName('pid').Value                      := condicoes_pagamento_id;
      QryAx4.Parameters.ParamByName('ptitulo_id').Value               := IdDoTitulo;
      QryAx4.Parameters.ParamByName('pcondicoes_pagamento_id').Value  := IdDaFormaDePagamento;
      QryAx4.Parameters.ParamByName('pvalor_pago').Value              := ValorPagoParaEssaFormaDePagamento;

      try
        // Tenta salvar os dados
        QryAx4.ExecSQL;

        //Atualiza Cds para preencher dbgrid
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
      End;
    end;
end;




procedure TControleCadastroBaixartituloPagar.CalculoParaBaixa(Id: Integer;
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

procedure TControleCadastroBaixartituloPagar.EditValorPagoEnter(
  Sender: TObject);
begin
  EditValorPago.SelectAll;
end;

procedure TControleCadastroBaixartituloPagar.UniFormattedNumberEditJurosChange(
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

procedure TControleCadastroBaixartituloPagar.UniFormattedNumberEditMultaChange(
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

procedure TControleCadastroBaixartituloPagar.UniFormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if ControleMainModule.ADOConnection.InTransaction = True then
    ControleMainModule.ADOConnection.RollbackTrans;
end;

procedure TControleCadastroBaixartituloPagar.UniFormCreate(Sender: TObject);
begin
  self.BorderStyle := bsNone;
end;

procedure TControleCadastroBaixartituloPagar.UniFormShow(Sender: TObject);
begin
  CdsPagamento.CreateDataSet;
  CdsPagamento.Open;

  UniLabelCaption.Text := Self.Caption;
end;

procedure TControleCadastroBaixartituloPagar.UniSpeedCaptionCloseClick(
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

procedure TControleCadastroBaixartituloPagar.UniSweetAlertaFechaFormularioConfirm(
  Sender: TObject);
begin
  Close;
end;

procedure TControleCadastroBaixartituloPagar.UniSweetAlertaFechaFormularioDismiss(
  Sender: TObject; const Reason: TDismissType);
begin
  Close;
end;

end.
