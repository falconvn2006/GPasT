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

type TtipoCaltulos = record
     TipoCalcDesconto : string;
     TipoCalcJuros    : string;
     TipoCalcMulta    : string;
end;


type
  TControleCadastroBaixartituloPagar = class(TUniForm)
    UniPanel2: TUniPanel;
    UniPageControl1: TUniPageControl;
    UniTabSheet1: TUniTabSheet;
    UniFormattedNumberEditValorPago: TUniFormattedNumberEdit;
    UniDBLookupComboBoxFormaPag: TUniDBLookupComboBox;
    UniLabel11: TUniLabel;
    UniLabel12: TUniLabel;
    UniFormattedNumberEditJuros: TUniFormattedNumberEdit;
    UniFormattedNumberEditMulta: TUniFormattedNumberEdit;
    UniFormattedNumberEditDesconto: TUniFormattedNumberEdit;
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
    UniPanel23: TUniPanel;
    UniPanel24: TUniPanel;
    UniPanel25: TUniPanel;
    UniImage10: TUniImage;
    UniPanel26: TUniPanel;
    UniLabel16: TUniLabel;
    LabelOriginal: TUniLabel;
    UniPanel27: TUniPanel;
    UniPanel28: TUniPanel;
    UniImage11: TUniImage;
    UniPanel30: TUniPanel;
    UniLabel19: TUniLabel;
    LabelPago: TUniLabel;
    UniPanel29: TUniPanel;
    UniPanel31: TUniPanel;
    UniImage12: TUniImage;
    UniPanel32: TUniPanel;
    UniLabel20: TUniLabel;
    LabelAtualizado: TUniLabel;
    UniPanel33: TUniPanel;
    UniPanel34: TUniPanel;
    UniImage13: TUniImage;
    UniPanel35: TUniPanel;
    UniLabel22: TUniLabel;
    LabelSaldo: TUniLabel;
    UniPanel9: TUniPanel;
    UniPanel8: TUniPanel;
    UniPanel14: TUniPanel;
    UniImage6: TUniImage;
    UniPanel13: TUniPanel;
    UniLabel4: TUniLabel;
    LabelDiasAtraso: TUniLabel;
    UniPanel10: TUniPanel;
    UniPanel16: TUniPanel;
    UniImage7: TUniImage;
    UniPanel17: TUniPanel;
    UniLabel7: TUniLabel;
    LabelMulta: TUniLabel;
    UniPanel12: TUniPanel;
    UniPanel18: TUniPanel;
    UniImage8: TUniImage;
    UniPanel19: TUniPanel;
    UniLabel9: TUniLabel;
    LabelJuros: TUniLabel;
    UniPanel15: TUniPanel;
    UniPanel20: TUniPanel;
    UniImage9: TUniImage;
    UniPanel22: TUniPanel;
    UniLabel14: TUniLabel;
    LabelDesconto: TUniLabel;
    UniPanel1: TUniPanel;
    BtnTipoCalculoJuros: TUniButton;
    UniPanel3: TUniPanel;
    BtnTipoCalculoMulta: TUniButton;
    UniPanel4: TUniPanel;
    BtnTipoCalculoDesconto: TUniButton;
    DspTituloPagamentos: TDataSetProvider;
    DscTituloPagamentos: TDataSource;
    CdsTituloPagamentos: TClientDataSet;
    CdsTituloPagamentosID: TFloatField;
    CdsTituloPagamentosTITULO_ID: TFloatField;
    CdsTituloPagamentosCONDICOES_PAGAMENTO_ID: TFloatField;
    CdsTituloPagamentosDESCRICAO: TWideStringField;
    CdsTituloPagamentosVALOR_PAGO: TFloatField;
    CdsTituloPagamentosDATA: TDateTimeField;
    CdsTituloPagamentosSOMA_TOTAL_PAGO: TAggregateField;
    QryTituloPagamentos: TADOQuery;
    procedure BtCancelarClick(Sender: TObject);
    procedure BtReceberClick(Sender: TObject);
    procedure UniFormClose(Sender: TObject; var Action: TCloseAction);
    procedure UniFormCreate(Sender: TObject);
    procedure UniFormShow(Sender: TObject);
    procedure UniSpeedCaptionCloseClick(Sender: TObject);
    procedure UniFormattedNumberEditValorPagoEnter(Sender: TObject);
    procedure UniSweetAlertaFechaFormularioConfirm(Sender: TObject);
    procedure UniSweetAlertaFechaFormularioDismiss(Sender: TObject;
      const Reason: TDismissType);
    procedure BtnTipoCalculoJurosClick(Sender: TObject);
    procedure UniFormattedNumberEditJurosExit(Sender: TObject);
    procedure UniFormattedNumberEditJurosKeyPress(Sender: TObject;
      var Key: Char);
    procedure UniFormattedNumberEditMultaKeyPress(Sender: TObject;
      var Key: Char);
    procedure UniFormattedNumberEditDescontoKeyPress(Sender: TObject;
      var Key: Char);
    procedure UniFormattedNumberEditJurosEnter(Sender: TObject);
    procedure UniFormattedNumberEditMultaEnter(Sender: TObject);
    procedure UniFormattedNumberEditDescontoEnter(Sender: TObject);
    procedure UniFormattedNumberEditMultaExit(Sender: TObject);
    procedure UniFormattedNumberEditDescontoExit(Sender: TObject);
    procedure BtnTipoCalculoMultaClick(Sender: TObject);
    procedure BtnTipoCalculoDescontoClick(Sender: TObject);
  private
    TipoCalculos : TtipoCaltulos;
    titulo_pagamentos_id : Integer;
    SomaFormasPagamentoRecebidas : Double;
    function RegistraTituloPagamentos(IdDoTitulo, IdDaFormaDePagamento: Integer;
      ValorPagoParaEssaFormaDePagamento: Double): Boolean;
    procedure CalculoJurosMultaManual;
    procedure PreecheCampos;
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

procedure TControleCadastroBaixartituloPagar.BtnTipoCalculoDescontoClick(
  Sender: TObject);
begin
  //P porcentagem R real
  if TipoCalculos.TipoCalcDesconto = 'P' then
  begin
    BtnTipoCalculoDesconto.Caption := 'Desconto R$';
    TipoCalculos.TipoCalcDesconto := 'R';
  end
  else
  begin
    BtnTipoCalculoDesconto.Caption := 'Desconto %';
    TipoCalculos.TipoCalcDesconto := 'P';
  end;
end;

procedure TControleCadastroBaixartituloPagar.BtnTipoCalculoJurosClick(
  Sender: TObject);
begin
   //P porcentagem R real
  if TipoCalculos.TipoCalcJuros = 'P' then
  begin
    BtnTipoCalculoJuros.Caption := 'Juros R$';
    TipoCalculos.TipoCalcJuros := 'R';
  end
  else
  begin
    BtnTipoCalculoJuros.Caption := 'Juros %';
    TipoCalculos.TipoCalcJuros := 'P';
  end;
end;

procedure TControleCadastroBaixartituloPagar.BtnTipoCalculoMultaClick(
  Sender: TObject);
begin
   //P porcentagem R real
  if TipoCalculos.TipoCalcMulta = 'P' then
  begin
    BtnTipoCalculoMulta.Caption := 'Multa R$';
    TipoCalculos.TipoCalcMulta := 'R';
  end
  else
  begin
    BtnTipoCalculoMulta.Caption := 'Multa %';
    TipoCalculos.TipoCalcMulta := 'P';
  end;
end;

procedure TControleCadastroBaixartituloPagar.BtReceberClick(Sender: TObject);
var
  condicoes_pagamento_id : Integer;
  ValorPago: Double;
begin
///1º validação dos campos

  if TryStrToFloat(UniFormattedNumberEditValorPago.Text, ValorPago) = False then
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
    UniFormattedNumberEditValorPago.SetFocus;
    Exit;
  end
  else if RoundTo((ValorPago),-2) >  RoundTo((Calcula.ValorSaldo),-2) then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção','O valor informado é maior que o valor do saldo a pagar');
    UniFormattedNumberEditValorPago.SetFocus;
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

    //Registra primeiro os pagamentos na tabela titulos_pagamentos para depois informar o id na movimentação do caixa
    RegistraTituloPagamentos(CdsCadastroID.AsInteger,
                                CdsCondicoesPagamentoID.AsInteger,
                                ValorPago);

    //2º dá insert no movimento do caixa
    registra_movimento(FNumeroCaixaLogado,
                 'D',
                 'PG',
                 ValorPago,
                 CdsCondicoesPagamentoID.AsInteger,
                 titulo_pagamentos_id,
                 'Referente ao título n.º '+ inttoStr(CdsCadastroID.AsInteger));

    UniFormattedNumberEditValorPago.Text :=  FloatToStr(RoundTo((Calcula.ValorAtualizado),-2) - RoundTo((SomaFormasPagamentoRecebidas),-2));

    //4º faz baixa do título
    if RoundTo((SomaFormasPagamentoRecebidas),-2) =  RoundTo((Calcula.ValorAtualizado),-2) then
    begin
      Try
        ControleMainModule.BaixaTituloPagar(CdsCadastroID.AsInteger,
                                            CdsCadastroCONTA_BANCARIA_ID.AsInteger,
                                            RoundTo(CdsCadastroVALOR.AsFloat,-2),
                                            Calcula.ValorJuros,
                                            Calcula.ValorMulta,
                                            SomaFormasPagamentoRecebidas,
                                            UniFormattedNumberEditDesconto.Value,
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


function TControleCadastroBaixartituloPagar.RegistraTituloPagamentos(IdDoTitulo :Integer;
                                                                          IdDaFormaDePagamento : Integer;
                                                                          ValorPagoParaEssaFormaDePagamento :Double):Boolean;
begin
    with ControleMainModule do
    begin
      Result := False;

       //Id usado para salvar na tabela titulo_forma_pagamento grava com quantas formas de pagamento o titulo foi pago
      titulo_pagamentos_id := GeraId('titulo_pagamentos');

      // Passo Unico - Salva os dados da cidade
      QryAx4.Parameters.Clear;
      QryAx4.SQL.Clear;

      // Insert
      QryAx4.SQL.Add('INSERT INTO titulo_pagamentos (');
      QryAx4.SQL.Add('       id,');
      QryAx4.SQL.Add('       titulo_id,');
      QryAx4.SQL.Add('       condicoes_pagamento_id,');
      QryAx4.SQL.Add('       data,');
      QryAx4.SQL.Add('       valor_pago)');
      QryAx4.SQL.Add('VALUES (');
      QryAx4.SQL.Add('       :pid,');
      QryAx4.SQL.Add('       :ptitulo_id,');
      QryAx4.SQL.Add('       :pcondicoes_pagamento_id,');
      QryAx4.SQL.Add('       TO_DATE(''' + Trim(DateToStr(Date)) + ''', ''dd/mm/yyyy''),');
      QryAx4.SQL.Add('       :pvalor_pago)');

      QryAx4.Parameters.ParamByName('pid').Value                      := titulo_pagamentos_id;
      QryAx4.Parameters.ParamByName('ptitulo_id').Value               := IdDoTitulo;
      QryAx4.Parameters.ParamByName('pcondicoes_pagamento_id').Value  := IdDaFormaDePagamento;
      QryAx4.Parameters.ParamByName('pvalor_pago').Value              := ValorPagoParaEssaFormaDePagamento;

      try
        // Tenta salvar os dados
        QryAx4.ExecSQL;

        //Atualiza Cds para preencher dbgrid
        CdsTituloPagamentos.Insert;
        CdsTituloPagamentosDESCRICAO.AsString  := CdsCondicoesPagamentoDESCRICAO.AsString;
        CdsTituloPagamentosVALOR_PAGO.AsFloat  := ValorPagoParaEssaFormaDePagamento;
        CdsTituloPagamentosDATA.AsDateTime     := Date;
        CdsTituloPagamentos.Post;

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

procedure TControleCadastroBaixartituloPagar.UniFormattedNumberEditValorPagoEnter(
  Sender: TObject);
begin
  UniFormattedNumberEditValorPago.SelectAll;
end;

procedure TControleCadastroBaixartituloPagar.UniFormattedNumberEditDescontoEnter(
  Sender: TObject);
begin
  UniFormattedNumberEditDesconto.SelectAll;
end;

procedure TControleCadastroBaixartituloPagar.UniFormattedNumberEditDescontoExit(
  Sender: TObject);
begin
  if trim(UniFormattedNumberEditDesconto.Text) = ''then
    UniFormattedNumberEditDesconto.Text := '0,00';

  if TipoCalculos.TipoCalcDesconto = 'P' then
  begin
    Calcula.ValorDesconto := ((UniFormattedNumberEditDesconto.Value * Calcula.ValorSaldo)/100);
    UniFormattedNumberEditDesconto.Value := Calcula.ValorDesconto;
    BtnTipoCalculoDesconto.Click;
  end;
 CalculoJurosMultaManual;
end;

procedure TControleCadastroBaixartituloPagar.UniFormattedNumberEditDescontoKeyPress(
  Sender: TObject; var Key: Char);
begin
  UniFormattedNumberEditValorPago.setfocus;
end;

procedure TControleCadastroBaixartituloPagar.UniFormattedNumberEditJurosEnter(
  Sender: TObject);
begin
  UniFormattedNumberEditJuros.SelectAll;
end;

procedure TControleCadastroBaixartituloPagar.UniFormattedNumberEditJurosExit(
  Sender: TObject);
begin
  if trim(UniFormattedNumberEditJuros.Text) = ''then
    UniFormattedNumberEditJuros.Text := '0,00';

  if TipoCalculos.TipoCalcJuros = 'P' then
  begin
    Calcula.ValorJuros := ((UniFormattedNumberEditJuros.Value * ((Calcula.ValorOriginal - Calcula.ValorPago) - Calcula.ValorDesconto))/100);
    UniFormattedNumberEditJuros.Value := Calcula.ValorJuros;
    BtnTipoCalculoJuros.Click;
  end;
  CalculoJurosMultaManual;
end;

procedure TControleCadastroBaixartituloPagar.UniFormattedNumberEditJurosKeyPress(
  Sender: TObject; var Key: Char);
begin
   UniFormattedNumberEditMulta.setfocus;
end;

procedure TControleCadastroBaixartituloPagar.UniFormattedNumberEditMultaEnter(
  Sender: TObject);
begin
  UniFormattedNumberEditMulta.SelectAll;
end;

procedure TControleCadastroBaixartituloPagar.UniFormattedNumberEditMultaExit(
  Sender: TObject);
begin
  if trim(UniFormattedNumberEditMulta.Text) = ''then
    UniFormattedNumberEditMulta.Text := '0,00';

  if TipoCalculos.TipoCalcMulta = 'P' then
  begin
    Calcula.ValorMulta := ((UniFormattedNumberEditMulta.Value * ((Calcula.ValorOriginal - Calcula.ValorPago) - Calcula.ValorDesconto))/100);
    UniFormattedNumberEditMulta.Value := Calcula.ValorMulta;
    BtnTipoCalculoMulta.Click;
  end;
  CalculoJurosMultaManual;
end;

procedure TControleCadastroBaixartituloPagar.UniFormattedNumberEditMultaKeyPress(
  Sender: TObject; var Key: Char);
begin
  UniFormattedNumberEditDesconto.setfocus;
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

procedure TControleCadastroBaixartituloPagar.CalculoJurosMultaManual;
begin
  Calcula.ValorJuros        := UniFormattedNumberEditJuros.Value;
  Calcula.ValorMulta        := UniFormattedNumberEditMulta.Value;
  Calcula.ValorDesconto     := UniFormattedNumberEditDesconto.Value;
  Calcula.ValorOriginal     := CdsCadastroVALOR.AsFloat;
  Calcula.ValorPago         := StrToFloatDef(CdsTituloPagamentosSOMA_TOTAL_PAGO.AsString,0);
  Calcula.ValorAtualizado   := ((Calcula.ValorOriginal +
                                Calcula.ValorJuros +
                                Calcula.ValorMulta) -
                                Calcula.ValorDesconto);
  Calcula.ValorSaldo        := (Calcula.ValorAtualizado - Calcula.ValorPago);

  PreecheCampos;
end;

procedure TControleCadastroBaixartituloPagar.PreecheCampos;
begin
  LabelDiasAtraso.Caption := CdsCadastroDIAS_ATRASO.AsString;
  LabelOriginal.Caption   := formatfloat('R$ #,##0.00', Calcula.ValorOriginal);
  LabelMulta.Caption      := formatfloat('R$ #,##0.00', Calcula.ValorMulta);
  LabelJuros.Caption      := formatfloat('R$ #,##0.00', Calcula.ValorJuros);
  LabelDesconto.Caption   := formatfloat('R$ #,##0.00', Calcula.ValorDesconto);
  LabelAtualizado.Caption := formatfloat('R$ #,##0.00', Calcula.ValorAtualizado);
  LabelPago.Caption       := formatfloat('R$ #,##0.00', Calcula.ValorPago);
  LabelSaldo.Caption      := formatfloat('R$ #,##0.00', Calcula.ValorSaldo);

  UniFormattedNumberEditMulta.Text     := formatfloat('0.00', Calcula.ValorMulta);
  UniFormattedNumberEditJuros.Text     := formatfloat('0.00', Calcula.ValorJuros);
  UniFormattedNumberEditDesconto.Text  := formatfloat('0.00', Calcula.ValorDesconto);
  UniFormattedNumberEditValorPago.Text := formatfloat('0.00', Calcula.ValorSaldo);
end;

procedure TControleCadastroBaixartituloPagar.CalculoParaBaixa(Id: Integer;
                                                         Valor_desconto : Double);
begin
  CdsCadastro.Close;
  QryCadastro.Parameters.ParamByName('id').Value := id;
  CdsCadastro.Open;

  CdsTituloPagamentos.Close;
  QryTituloPagamentos.Parameters.ParamByName('TITULO_ID').Value := id;
  CdsTituloPagamentos.Open;

  CdsCondicoesPagamento.Open;

  Calcula := ControleMainModule.CalculaJurosMulta(CdsCadastroDIAS_ATRASO.AsInteger,
                                                  CdsCadastroVALOR.AsFloat,
                                                  ControleMainModule.percentual_juros,
                                                  ControleMainModule.percentual_multa,
                                                  CdsCadastroDIAS_ATRASO.AsInteger,
                                                  valor_desconto);

  Calcula.ValorOriginal    := CdsCadastroVALOR.AsFloat;
  Calcula.ValorPago        := StrToFloatDef(CdsTituloPagamentosSOMA_TOTAL_PAGO.AsString,0);
  Calcula.ValorSaldo       := (Calcula.ValorAtualizado - Calcula.ValorPago);

  PreecheCampos;
end;

end.
