unit Controle.Consulta.Baixar.MultiplosPagar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Controle.Consulta.Modal, Data.DB, Data.Win.ADODB,
  Datasnap.Provider, Datasnap.DBClient, uniGUIBaseClasses, uniImageList,
  uniPanel, uniBasicGrid, uniDBGrid, uniBitBtn, uniSpeedButton, uniLabel,
  uniButton, uniEdit, uniMemo, uniMultiItem, uniComboBox;

type
  TControleConsultaBaixarMultiplosPagar = class(TControleConsultaModal)
    UniPanel5: TUniPanel;
    UniLabel12: TUniLabel;
    ComBoxCondicoesPagamento: TUniComboBox;
    UniLabel2: TUniLabel;
    UniMemoObservacao: TUniMemo;
    UniLabel4: TUniLabel;
    UniLabel5: TUniLabel;
    EditTotal: TUniFormattedNumberEdit;
    EditQtd: TUniFormattedNumberEdit;
    QryCondicoesPagamento: TADOQuery;
    CdsCondicoesPagamento: TClientDataSet;
    CdsCondicoesPagamentoID: TFloatField;
    CdsCondicoesPagamentoDESCRICAO: TWideStringField;
    CdsCondicoesPagamentoTIPO: TWideStringField;
    CdsCondicoesPagamentoATIVO: TWideStringField;
    CdsCondicoesPagamentoORDEM_EXIBICAO: TFloatField;
    CdsCondicoesPagamentoGERA_CARNE: TWideStringField;
    CdsCondicoesPagamentoGERA_BOLETO: TWideStringField;
    CdsCondicoesPagamentoGERA_CHEQUE: TWideStringField;
    DscCondicoesPagamento: TDataSource;
    DspCondicoesPagamento: TDataSetProvider;
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
    procedure UniFormShow(Sender: TObject);
    procedure UniFormCreate(Sender: TObject);
    procedure BotaoConfirmaClick(Sender: TObject);
    procedure ComBoxCondicoesPagamentoChange(Sender: TObject);
  private
    titulo_pagamentos_id :Integer;
    CondicoesPagamentoId : Integer;
    procedure PreencheFiltros;
    function RegistraTituloPagamentos(IdDoTitulo, IdDaFormaDePagamento: Integer;
      ValorPagoParaEssaFormaDePagamento: Double): Boolean;
    function RegistraTituloPagarBaixaLote(IdDoTitulo: Integer): Boolean;
    { Private declarations }
  public
    numero_lote_id : Integer;
    Baixado : Boolean;
    procedure Abrir(Qtd, Soma: string);
    { Public declarations }
  end;


function ControleConsultaBaixarMultiplosPagar: TControleConsultaBaixarMultiplosPagar;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication, uniSweetAlert;

function ControleConsultaBaixarMultiplosPagar: TControleConsultaBaixarMultiplosPagar;
begin
  Result := TControleConsultaBaixarMultiplosPagar(ControleMainModule.GetFormInstance(TControleConsultaBaixarMultiplosPagar));
end;

procedure TControleConsultaBaixarMultiplosPagar.BotaoConfirmaClick(
  Sender: TObject);
begin
  Baixado := False;
  inherited;
  if ComBoxCondicoesPagamento.Text = '' then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Escolha uma condição de pagamento');
    ComBoxCondicoesPagamento.SetFocus;
    Exit;
  end;

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

    Try
      CdsBaixaMultiplo.First; //vá para o inicio do cds
      while not CdsBaixaMultiplo.Eof do
      begin
        //1º Registra primeiro os pagamentos na tabela titulos_pagamentos para depois informar o id na movimentação do caixa
        RegistraTituloPagamentos(CdsBaixaMultiploID.AsInteger,
                                    CdsCondicoesPagamentoID.AsInteger,
                                    CdsBaixaMultiploVALOR.AsFloat);

        //2º dá insert no movimento do caixa
        registra_movimento(FNumeroCaixaLogado,
                     'D',
                     'PG',
                     CdsBaixaMultiploVALOR.AsFloat,
                     CdsCondicoesPagamentoID.AsInteger,
                     titulo_pagamentos_id,
                     'Referente ao título n.º '+ inttoStr(CdsBaixaMultiploID.AsInteger));

        //3º Registra o lote da baixa
        RegistraTituloPagarBaixaLote(CdsBaixaMultiploID.AsInteger);

        //4º Baixa o título
        BaixaTituloPagar(CdsBaixaMultiploID.AsInteger,
                        StrToIntDef(CdsBaixaMultiploCONTA_BANCARIA_ID.AsString,0),
                        CdsBaixaMultiploVALOR.AsFloat,
                        0,
                        0,
                        CdsBaixaMultiploVALOR.AsFloat,
                        0,
                        UniMemoObservacao.Text,
                        Date,
                        '',
                        CdsBaixaMultiploSEQUENCIA_PARCELAS.AsString,
                        '',
                        CdsCondicoesPagamentoID.AsInteger,
                        CdsBaixaMultiploTITULO_CATEGORIA_ID.AsString);

        CdsBaixaMultiplo.Next;
      end;
      // Confirma a transação
      ADOConnection.CommitTrans;
      Baixado := True;
      ControleMainModule.MensageiroSweetAlerta('Baixados!','Todos os títulos foram baixados com sucesso.!',atSuccess);
    Except
      on E: Exception do
      begin
        // Descarta a transação
        ADOConnection.RollbackTrans;
        ControleMainModule.MensageiroSweetAlerta('Atenção', E.Message);
      end;
    End;
  end;
end;

procedure TControleConsultaBaixarMultiplosPagar.ComBoxCondicoesPagamentoChange(
  Sender: TObject);
begin
  inherited;
  CdsCondicoesPagamento.Locate('DESCRICAO',ComBoxCondicoesPagamento.Text,[]);
  CondicoesPagamentoId := CdsCondicoesPagamentoID.AsInteger;
end;

procedure TControleConsultaBaixarMultiplosPagar.PreencheFiltros;
begin
  numero_lote_id :=0;
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
    CdsCondicoesPagamento.First;
  end;
end;

procedure TControleConsultaBaixarMultiplosPagar.UniFormCreate(Sender: TObject);
begin
//  inherited;
end;

procedure TControleConsultaBaixarMultiplosPagar.UniFormShow(Sender: TObject);
begin
  //inherited;
  PreencheFiltros;
end;

procedure TControleConsultaBaixarMultiplosPagar.Abrir(Qtd: String;Soma:string);
begin
  EditTotal.Text  := Soma;
  EditQtd.Text    := Qtd;
end;

function TControleConsultaBaixarMultiplosPagar.RegistraTituloPagamentos(IdDoTitulo :Integer;
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
    Except
      on E: Exception do
      begin
        // Descarta a transação
        ADOConnection.RollbackTrans;
        ControleMainModule.MensageiroSweetAlerta('Atenção',(E.Message));
      end;
    End;
  end;
end;

function TControleConsultaBaixarMultiplosPagar.RegistraTituloPagarBaixaLote(IdDoTitulo :Integer):Boolean;
var
  TituloPagarBaixaLote_ID : Integer;
begin
  Result := False;

  with ControleMainModule do
  begin
     //Gera id
    TituloPagarBaixaLote_ID := GeraId('titulo_pagar_baixa_lote');

    //Salva numero de lote para usar nos próximos
    if numero_lote_id = 0 then
      numero_lote_id := TituloPagarBaixaLote_ID;

    QryAx3.Parameters.Clear;
    QryAx3.SQL.Clear;

    // Insert
    QryAx3.SQL.Add('INSERT INTO titulo_pagar_baixa_lote (');
    QryAx3.SQL.Add('       id,');
    QryAx3.SQL.Add('       titulo_id,');
    QryAx3.SQL.Add('       numero_lote)');
    QryAx3.SQL.Add('VALUES (');
    QryAx3.SQL.Add('       :id,');
    QryAx3.SQL.Add('       :titulo_id,');
    QryAx3.SQL.Add('       :numero_lote)');

    QryAx3.Parameters.ParamByName('id').Value           := TituloPagarBaixaLote_ID;
    QryAx3.Parameters.ParamByName('titulo_id').Value    := IdDoTitulo;
    QryAx3.Parameters.ParamByName('numero_lote').Value  := numero_lote_id;

    try
      // Tenta salvar os dados
      QryAx3.ExecSQL;
      Result := True;
    Except
      on E: Exception do
      begin
        // Descarta a transação
        ADOConnection.RollbackTrans;
        ControleMainModule.MensageiroSweetAlerta('Atenção',(E.Message));
      end;
    End;
  end;
end;

end.
