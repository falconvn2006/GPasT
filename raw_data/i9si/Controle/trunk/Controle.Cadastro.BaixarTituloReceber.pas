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

type TtipoCaltulos = record
     TipoCalcDesconto : string;
     TipoCalcJuros    : string;
     TipoCalcMulta    : string;
end;

type
  TControleCadastroBaixarTituloReceber = class(TUniForm)
    UniPanel2: TUniPanel;
    UniLabel12: TUniLabel;
    UniFormattedNumberEditValorPago: TUniFormattedNumberEdit;
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
    UniFormattedNumberEditJuros: TUniFormattedNumberEdit;
    UniFormattedNumberEditMulta: TUniFormattedNumberEdit;
    UniFormattedNumberEditDesconto: TUniFormattedNumberEdit;
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
    CdsPagamentoDATA_PAGAMENTO: TDateField;
    UniSweetAlertParcial: TUniSweetAlert;
    QryTituloPagamentos: TADOQuery;
    CdsTituloPagamentos: TClientDataSet;
    CdsTituloPagamentosID: TFloatField;
    CdsTituloPagamentosTITULO_ID: TFloatField;
    CdsTituloPagamentosCONDICOES_PAGAMENTO_ID: TFloatField;
    CdsTituloPagamentosDESCRICAO: TWideStringField;
    CdsTituloPagamentosVALOR_PAGO: TFloatField;
    CdsTituloPagamentosDATA: TDateTimeField;
    DscTituloPagamentos: TDataSource;
    DspTituloPagamentos: TDataSetProvider;
    CdsTituloPagamentosSOMA_TOTAL_PAGO: TAggregateField;
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
    CdsCadastroVALOR_DESCONTO: TFloatField;
    UniPanel1: TUniPanel;
    BtnTipoCalculoJuros: TUniButton;
    BtnJurosPadrao: TUniButton;
    UniPanel4: TUniPanel;
    BtnTipoCalculoDesconto: TUniButton;
    UniPanel3: TUniPanel;
    BtnTipoCalculoMulta: TUniButton;
    procedure BtReceberClick(Sender: TObject);
    procedure BtCancelarClick(Sender: TObject);
    procedure UniFormShow(Sender: TObject);
    procedure UniFormClose(Sender: TObject; var Action: TCloseAction);
    procedure UniSweetAlertaImprimeReciboConfirm(Sender: TObject);
    procedure UniSweetAlertaImprimeReciboDismiss(Sender: TObject;
      const Reason: TDismissType);
    procedure UniSpeedCaptionCloseClick(Sender: TObject);
    procedure UniFormCreate(Sender: TObject);
    procedure UniFormattedNumberEditValorPagoEnter(Sender: TObject);
    procedure AlertCadastroChequeConfirm(Sender: TObject);
    procedure UniSweetAlertParcialConfirm(Sender: TObject);
    procedure UniSweetAlertParcialDismiss(Sender: TObject;
      const Reason: TDismissType);
    procedure UniFormattedNumberEditDescontoExit(Sender: TObject);
    procedure BtnJurosPadraoClick(Sender: TObject);
    procedure UniFormattedNumberEditJurosExit(Sender: TObject);
    procedure UniFormattedNumberEditMultaExit(Sender: TObject);
    procedure UniFormattedNumberEditJurosKeyPress(Sender: TObject;
      var Key: Char);
    procedure UniFormattedNumberEditMultaKeyPress(Sender: TObject;
      var Key: Char);
    procedure UniFormattedNumberEditDescontoKeyPress(Sender: TObject;
      var Key: Char);
    procedure UniFormattedNumberEditJurosEnter(Sender: TObject);
    procedure UniFormattedNumberEditMultaEnter(Sender: TObject);
    procedure UniFormattedNumberEditDescontoEnter(Sender: TObject);
    procedure BtnTipoCalculoJurosClick(Sender: TObject);
    procedure BtnTipoCalculoMultaClick(Sender: TObject);
    procedure BtnTipoCalculoDescontoClick(Sender: TObject);
  private
    TipoCalculos : TtipoCaltulos;
    RecebeParcial : string;
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
    procedure CalculoJurosMultaManual;
    procedure PreecheCampos;
    procedure RecebeParametrosFonte;
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

procedure TControleCadastroBaixarTituloReceber.UniFormattedNumberEditValorPagoEnter(Sender: TObject);
begin
  UniFormattedNumberEditValorPago.SelectAll;
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
  situacao : string;
  Forma_pagamento_id : Integer;
  ValorPago: Double;
begin
  if TryStrToFloat(UniFormattedNumberEditValorPago.Text, ValorPago) = False then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção','Digite um valor válido');
    Exit;
  end;

  //soma total ja pago com o valor pago agora
  SomaFormasPagamentoRecebidas := (StrToFloatDef(CdsTituloPagamentosSOMA_TOTAL_PAGO.AsString,0)
                                   + ValorPago) ;

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
  else if RoundTo((SomaFormasPagamentoRecebidas),-2) >  RoundTo((Calcula.ValorAtualizado),-2) then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção','O valor informado é maior que o valor do saldo a pagar');
    UniFormattedNumberEditValorPago.SetFocus;
    Exit;
  end;

  with ControleMainModule do
  begin
    // Inicia a transação
    if ADOConnection.Connected = false then
      ADOConnection.Open;

    if ADOConnection.InTransaction = False then
      ADOConnection.BeginTrans;

    //1ºregistra as formas de recebimento no título_pagamentos
    //para depois usar o id do pagamento na movimentação do caixa e cheque
    RegistraTituloPagamentos(CdsCadastroID.AsInteger,
                              CdsCondicoesPagamentoID.AsInteger,
                              ValorPago);

    //2º registra movimento do caixa
    registra_movimento(FNumeroCaixaLogado,
                        'C',
                        'RC',
                        ValorPago,
                        CdsCondicoesPagamentoID.AsInteger,
                        Titulo_Pagamentos_id,
                        'Referente ao título n.º '+ inttoStr(CdsCadastroID.AsInteger));



    //3º Registra informações do cheque.
    if CdsCondicoesPagamentoGERA_CHEQUE.AsString = 'S' then
    begin
      if RegistraCheque(Titulo_Pagamentos_id,
                     CdsCondicoesPagamentoID.AsInteger,
                     CdsCadastroCLIENTE_ID.AsInteger,
                     ValorPago,
                     CdsCadastroDATA_VENCIMENTO.AsDateTime)= True then
    end;

    UniFormattedNumberEditValorPago.Text :=  FloatToStr(RoundTo((Calcula.ValorAtualizado),-2) - RoundTo((SomaFormasPagamentoRecebidas),-2));

    if RecebeParcial = 'S' then //RecebeParcial parametro fonte
    begin
      if RoundTo((SomaFormasPagamentoRecebidas),-2) =  RoundTo((Calcula.ValorAtualizado),-2) then
        situacao := 'L'
      else
        situacao := 'P';

      Try
        ControleMainModule.BaixaTituloReceber(CdsCadastroID.AsInteger,
                                              CdsCadastroCONTA_BANCARIA_ID.AsInteger,
                                              RoundTo(CdsCadastroVALOR.AsFloat,-2),
                                              Calcula.ValorJuros,
                                              Calcula.ValorMulta,
                                              SomaFormasPagamentoRecebidas,//valor total pago
                                              UniFormattedNumberEditDesconto.Value,
                                              CdsCadastroHISTORICO.AsString,
                                              situacao,
                                              CdsCadastroDATA_VENCIMENTO.AsDateTime,
                                              Date,
                                              CdsCadastroDIAS_ATRASO.AsInteger,
                                              CdsCadastroNUMERO_CARNE.AsString,
                                              CdsCadastroSEQUENCIA_PARCELAS.AsString,
                                              CdsCondicoesPagamentoID.AsInteger);

        // Confirma a transação
        ADOConnection.CommitTrans;

        if situacao = 'P' then
          UniSweetAlertParcial.Show()
        else
          UniSweetAlertaImprimeRecibo.Show();
      Except
        on E: Exception do
        begin
          // Descarta a transação
          ADOConnection.RollbackTrans;
          ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));
        end;
      End;
    end
    else
    begin
      if RoundTo((SomaFormasPagamentoRecebidas),-2) =  RoundTo((Calcula.ValorAtualizado),-2) then
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
                                                'L', //situação liquidado pois não atende o parametro e so entra aqui se receber o valor total.
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
        end;
      end;
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
    QryAx4.SQL.Add('       data,');
    QryAx4.SQL.Add('       valor_pago)');
    QryAx4.SQL.Add('VALUES (');
    QryAx4.SQL.Add('       :pid,');
    QryAx4.SQL.Add('       :ptitulo_id,');
    QryAx4.SQL.Add('       :pcondicoes_pagamento_id,');
    QryAx4.SQL.Add('       TO_DATE(''' + Trim(DateToStr(Date)) + ''', ''dd/mm/yyyy''),');
    QryAx4.SQL.Add('       :pvalor_pago)');

    QryAx4.Parameters.ParamByName('pid').Value                      := Titulo_Pagamentos_id;
    QryAx4.Parameters.ParamByName('ptitulo_id').Value               := CdsCadastroID.AsInteger;
    QryAx4.Parameters.ParamByName('pcondicoes_pagamento_id').Value  := CdsCondicoesPagamentoID.AsInteger;
    QryAx4.Parameters.ParamByName('pvalor_pago').Value              := ValorPagoParaEssaFormaDePagamento;

    try
      // Tenta salvar os dados
      QryAx4.ExecSQL;

      CdsTituloPagamentos.Insert;
      CdsTituloPagamentosDESCRICAO.AsString   := CdsCondicoesPagamentoDESCRICAO.AsString;
      CdsTituloPagamentosVALOR_PAGO.AsFloat   := ValorPagoParaEssaFormaDePagamento;
      CdsTituloPagamentosDATA.AsDateTime      := Date;
      CdsTituloPagamentos.Post;
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

procedure TControleCadastroBaixarTituloReceber.BtnJurosPadraoClick(Sender: TObject);
begin
 CalculoParaBaixa(CdsCadastroID.AsInteger,
                  UniFormattedNumberEditDesconto.Value);
end;

procedure TControleCadastroBaixarTituloReceber.BtnTipoCalculoDescontoClick(
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

procedure TControleCadastroBaixarTituloReceber.BtnTipoCalculoJurosClick(
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

procedure TControleCadastroBaixarTituloReceber.BtnTipoCalculoMultaClick(
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

procedure TControleCadastroBaixarTituloReceber.UniFormattedNumberEditDescontoEnter(
  Sender: TObject);
begin
  UniFormattedNumberEditDesconto.SelectAll;
end;

procedure TControleCadastroBaixarTituloReceber.UniFormattedNumberEditDescontoKeyPress(
  Sender: TObject; var Key: Char);
begin
  UniFormattedNumberEditValorPago.setfocus;
end;

procedure TControleCadastroBaixarTituloReceber.UniFormattedNumberEditJurosEnter(
  Sender: TObject);
begin
  UniFormattedNumberEditJuros.SelectAll;
end;

procedure TControleCadastroBaixarTituloReceber.UniFormattedNumberEditDescontoExit(
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

procedure TControleCadastroBaixarTituloReceber.UniFormattedNumberEditJurosExit(
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

procedure TControleCadastroBaixarTituloReceber.UniFormattedNumberEditMultaExit(
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

procedure TControleCadastroBaixarTituloReceber.UniFormattedNumberEditJurosKeyPress(
  Sender: TObject; var Key: Char);
begin
   UniFormattedNumberEditMulta.setfocus;
end;

procedure TControleCadastroBaixarTituloReceber.UniFormattedNumberEditMultaEnter(
  Sender: TObject);
begin
  UniFormattedNumberEditMulta.SelectAll;
end;

procedure TControleCadastroBaixarTituloReceber.UniFormattedNumberEditMultaKeyPress(
  Sender: TObject; var Key: Char);
begin
  UniFormattedNumberEditDesconto.setfocus;
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

  RecebeParametrosFonte;
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

procedure TControleCadastroBaixarTituloReceber.UniSweetAlertParcialConfirm(
  Sender: TObject);
begin
  BtCancelar.Enabled :=False;
  CdsTituloPagamentos.Close;
  CdsTituloPagamentos.Open;
  CalculoJurosMultaManual;
  Exit;
end;

procedure TControleCadastroBaixarTituloReceber.UniSweetAlertParcialDismiss(
  Sender: TObject; const Reason: TDismissType);
begin
  UniSweetAlertaImprimeRecibo.Show();
end;

procedure TControleCadastroBaixarTituloReceber.UniSweetAlertaImprimeReciboConfirm(
  Sender: TObject);
begin
  Relatorio_Recibo.Variables.Variables['Razaoempresa']  := QuotedStr(ControleMainModule.FRazaoSocial);
  Relatorio_Recibo.Variables.Variables['EditJuros']     := UniFormattedNumberEditJuros.Value;
  Relatorio_Recibo.Variables.Variables['EditMulta']     := UniFormattedNumberEditMulta.Value;
  Relatorio_Recibo.Variables.Variables['EditDesconto']  := UniFormattedNumberEditDesconto.Value;
  Relatorio_Recibo.Variables.Variables['EditSaldoAPagar'] := SomaFormasPagamentoRecebidas;
  ControleMainModule.ExportarPDF('Relatorio',Relatorio_Recibo);
  Close;
end;

procedure TControleCadastroBaixarTituloReceber.UniSweetAlertaImprimeReciboDismiss(
  Sender: TObject; const Reason: TDismissType);
begin
  Close;
end;

procedure TControleCadastroBaixarTituloReceber.CalculoJurosMultaManual;
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

procedure TControleCadastroBaixarTituloReceber.PreecheCampos;
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


procedure TControleCadastroBaixarTituloReceber.RecebeParametrosFonte;
begin
   //Verifica se recebe parcial
  if ControleMainModule.CdsParametros.Locate('campo','RECEBE_PARCIAL',[])= True then
    RecebeParcial := ControleMainModule.CdsParametros.FieldByName('valor').AsString
  else
    RecebeParcial := 'N';

  //Verifica se tem % de juros e multa cadastrados
  if ControleMainModule.percentual_juros= 0 then
    BtnJurosPadrao.Visible := False
  else if ControleMainModule.percentual_multa= 0 then
    BtnJurosPadrao.Visible := False;

  TipoCalculos.TipoCalcJuros    := 'R';
  TipoCalculos.TipoCalcMulta    := 'R';
  TipoCalculos.TipoCalcDesconto := 'R';
end;



{ TCalculaAcrescimoDesconto }

end.
