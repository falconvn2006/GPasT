unit Controle.Operacoes.Integracao.NegociarTituloReceber;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Controle.Operacoes, Data.Win.ADODB,
  Datasnap.Provider, Data.DB, Datasnap.DBClient, uniGUIBaseClasses,
  uniImageList, uniBitBtn, uniSpeedButton, uniLabel, uniButton, uniPanel,
  uniDateTimePicker, uniEdit, uniBasicGrid, uniDBGrid, uniDBDateTimePicker,
  uniDBEdit, uniGroupBox, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  uniMultiItem, uniComboBox,System.math, uniCheckBox;

type
  TControleOperacoesIntegracaoNegociarTituloReceber = class(TControleOperacoes)
    UniGroupBox1: TUniGroupBox;
    UniLabel1: TUniLabel;
    UniLabel2: TUniLabel;
    UniLabel4: TUniLabel;
    UniGroupBox2: TUniGroupBox;
    UniDBGrid1: TUniDBGrid;
    UniPanel5: TUniPanel;
    LabelSomaParcelas: TUniLabel;
    UniLabel5: TUniLabel;
    UniPanel6: TUniPanel;
    UniLabel8: TUniLabel;
    EditValorParcela: TUniFormattedNumberEdit;
    UniLabel6: TUniLabel;
    UniLabel9: TUniLabel;
    Vencimento_negociacao: TUniDateTimePicker;
    UniButton1: TUniButton;
    DscAdd: TDataSource;
    UniEdtResponsavel: TUniEdit;
    UnibtnConsultaCliente: TUniSpeedButton;
    UniDataVencimento: TUniDateTimePicker;
    UniEdtValor: TUniFormattedNumberEdit;
    FDQuery1: TFDQuery;
    FDQuery1NUMPEDIDO: TIntegerField;
    FDQuery1NOME: TStringField;
    FDQuery1VALOR: TFloatField;
    FDQuery1VENCIM: TDateField;
    FDQuery1DIAS_ATRASO: TIntegerField;
    FDQuery1TRANSFERIDO: TStringField;
    FDQuery2: TFDQuery;
    IntegerField1: TIntegerField;
    StringField1: TStringField;
    FloatField1: TFloatField;
    DateField1: TDateField;
    IntegerField2: TIntegerField;
    StringField2: TStringField;
    UniLabel7: TUniLabel;
    UniComboBoxCategoria: TUniComboBox;
    DscCategoria: TDataSource;
    DspCategoria: TDataSetProvider;
    CdsCategoria: TClientDataSet;
    CdsCategoriaID: TFloatField;
    CdsCategoriaDESCRICAO: TWideStringField;
    CdsCategoriaTIPO_TITULO: TWideStringField;
    QryCategoria: TADOQuery;
    UniComboBoxFormaCobranca: TUniComboBox;
    DscCondicoesPagamento: TDataSource;
    CdsCondicoesPagamento: TClientDataSet;
    CdsCondicoesPagamentoID: TFloatField;
    CdsCondicoesPagamentoDESCRICAO: TWideStringField;
    CdsCondicoesPagamentoTIPO: TWideStringField;
    CdsCondicoesPagamentoORDEM_EXIBICAO: TFloatField;
    CdsCondicoesPagamentoGERA_CARNE: TWideStringField;
    CdsCondicoesPagamentoGERA_BOLETO: TWideStringField;
    CdsCondicoesPagamentoGERA_CHEQUE: TWideStringField;
    DspCondicoesPagamento: TDataSetProvider;
    QryCondicoesPagamento: TADOQuery;
    CdsAdd: TClientDataSet;
    CdsAddVENCIMENTO: TDateField;
    CdsAddCONDICOES_PAGAMENTO: TStringField;
    CdsAddCONDICOES_PAGAMENTO_ID: TStringField;
    CdsAddVALOR: TFloatField;
    CdsAddPARCELA: TIntegerField;
    CdsAddGERA_BOLETO: TStringField;
    CdsAddGERA_CARNE: TStringField;
    CdsAddGERA_CHEQUE: TStringField;
    CdsAddSomaParcelas: TAggregateField;
    CdsAddContaParcelas: TAggregateField;
    procedure BotaoDescartarClick(Sender: TObject);
    procedure UniButton1Click(Sender: TObject);
    procedure UnibtnConsultaClienteClick(Sender: TObject);
    procedure BotaoSalvarClick(Sender: TObject);
    procedure UniFormShow(Sender: TObject);
    procedure UniFormCreate(Sender: TObject);
    procedure UniComboBoxCategoriaChange(Sender: TObject);
    procedure UniComboBoxFormaCobrancaChange(Sender: TObject);
  private
    CategoriaId : string;
    function RetornaDataProximoTitulo(DataVenc: TDateTime): TDateTime;
    { Private declarations }
  public
    { Public declarations }
    PessoaId : integer;
    CondicoesPagamento_negociado,
    TipoTituloPrefixo_negociado,
    TipoTituloDescricao_negociado : string;
    GeraBoleto_negociado : Boolean;
    DiaPadrao: Word;
    CdsTitulosGerado : TClientDataSet;
    OperacaoTitulos : string;
  end;


function ControleOperacoesIntegracaoNegociarTituloReceber: TControleOperacoesIntegracaoNegociarTituloReceber;

implementation

{$R *.dfm}


uses
  Controle.Main.Module, uniGUIApplication, Controle.Consulta.Modal.TipoTitulo,
  Controle.Funcoes, Controle.Consulta.Modal.Pessoa.TituloReceber;

function ControleOperacoesIntegracaoNegociarTituloReceber: TControleOperacoesIntegracaoNegociarTituloReceber;
begin
  Result := TControleOperacoesIntegracaoNegociarTituloReceber(ControleMainModule.GetFormInstance(TControleOperacoesIntegracaoNegociarTituloReceber));
end;

procedure TControleOperacoesIntegracaoNegociarTituloReceber.BotaoDescartarClick(
  Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TControleOperacoesIntegracaoNegociarTituloReceber.UniButton1Click(
  Sender: TObject);
var
  ContaParcela,
  SomaParcela,
  ValorDigitado,
  valorTitulo : Double;
begin
  ValorDigitado := StrToFloatDef(EditValorParcela.Text,0);
  ValorTitulo   := StrToFloatDef(UniEdtValor.Text,0);
  SomaParcela   := StrToFloatDef(CdsAddSomaParcelas.AsString,0);
  ContaParcela  := StrToFloatDef(CdsAddContaParcelas.AsString,0);

  if UniEdtResponsavel.Text = '' then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção','Escolha o cliente, caso não encontre cadastre o mesmo!');
    Exit;
  end;

  if ValorDigitado = 0 then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção','O valor da parcela não pode ser zerado.');
    Exit;
  end;

  if UniComboBoxFormaCobranca.Text = '' then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção','Escolha uma forma de pagamento.');
    Exit;
  end;

  if RoundTo(ValorDigitado,-2) <= RoundTo(ValorTitulo,-2) then
  begin
    if RoundTo((SomaParcela + ValorDigitado),-2) > RoundTo(ValorTitulo,-2) then
    begin
      ControleMainModule.MensageiroSweetAlerta('Atenção','O total das parcelas não pode ultrapassar o valor original do título.');
      Exit;
    end
    else
    begin
      CdsAdd.Open;
      CdsAdd.Append;
      CdsAddCONDICOES_PAGAMENTO.AsString     := CdsCondicoesPagamentoDESCRICAO.AsString;
      CdsAddCONDICOES_PAGAMENTO_ID.AsString  := CdsCondicoesPagamentoID.AsString;
      CdsAddVALOR.AsString                   := EditValorParcela.Text;
      CdsAddVENCIMENTO.AsDateTime            := Vencimento_negociacao.DateTime;
      CdsAddGERA_CARNE.Value                 := CdsCondicoesPagamentoGERA_CARNE.AsString;
      CdsAddGERA_BOLETO.Value                := CdsCondicoesPagamentoGERA_BOLETO.AsString;
      CdsAddGERA_CHEQUE.Value                := CdsCondicoesPagamentoGERA_CHEQUE.AsString;

      if ContaParcela = 0 then
        CdsAddPARCELA.AsString            :='1'
      else
        CdsAddPARCELA.AsString              := FloatToStr(ContaParcela + 1);

      CdsAdd.Post;

      Vencimento_negociacao.DateTime  :=  RetornaDataProximoTitulo(Vencimento_negociacao.DateTime);
      LabelSomaParcelas.Caption       := 'R$ ' + Format('%7.2f',[StrToFloatDef(CdsAddSomaParcelas.AsString,0)]);
      EditValorParcela.Text           := FloatToStr(RoundTo(ValorTitulo,-2) - RoundTo((SomaParcela + ValorDigitado),-2));
      EditValorParcela.SetFocus;
    end;
  end
  else
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção','O valor da parcela é mais alto que o valor do título original.');
  end;

end;

procedure TControleOperacoesIntegracaoNegociarTituloReceber.UniComboBoxCategoriaChange(
  Sender: TObject);
begin
  inherited;
  CdsCategoria.Locate('DESCRICAO',UniComboBoxCategoria.Text,[]);
  CategoriaId := CdsCategoriaID.AsString;
end;

procedure TControleOperacoesIntegracaoNegociarTituloReceber.UniComboBoxFormaCobrancaChange(
  Sender: TObject);
begin
  inherited;
   CdsCondicoesPagamento.Locate('DESCRICAO',UniComboBoxFormaCobranca.Text,[]);
  CondicoesPagamento_negociado      := CdsCondicoesPagamentoID.AsString;
end;

procedure TControleOperacoesIntegracaoNegociarTituloReceber.UniFormCreate(
  Sender: TObject);
begin
  inherited;
  CdsAdd.CreateDataSet;
  CdsTitulosGerado := TClientDataSet.Create(UniApplication);
end;

procedure TControleOperacoesIntegracaoNegociarTituloReceber.UniFormShow(
  Sender: TObject);
var
  CdsCliente: TClientDataSet;
begin
  inherited;
  CdsCliente := TClientDataSet.Create(UniApplication);
  CdsCliente := ControleMainModule.SelecionaCliente(ControleFuncoes.RemoveMascara(Trim(ControleMainModule.cnpj_cpf_cliente_integracao)));

  PessoaId := CdsCliente.FieldByName('id').AsInteger;
  UniEdtResponsavel.Text := CdsCliente.FieldByName('razao_social').AsString;

  //preenche a categoria.
  CdsCategoria.Open;
  CdsCategoria.First;
  while not CdsCategoria.Eof do
  begin
    UniComboBoxCategoria.Items.Add(CdsCategoriaDESCRICAO.AsString);
    CdsCategoria.Next;
  end;

  //preenche a forma de cobrança.
  CdsCondicoesPagamento.Open;
  CdsCondicoesPagamento.First;
  while not CdsCondicoesPagamento.Eof do
  begin
    UniComboBoxFormaCobranca.Items.Add(CdsCondicoesPagamentoDESCRICAO.AsString);
    CdsCondicoesPagamento.Next;
  end;
  Vencimento_negociacao.DateTime := Date;
end;

procedure TControleOperacoesIntegracaoNegociarTituloReceber.UnibtnConsultaClienteClick(
  Sender: TObject);
begin
  inherited;
  PessoaId := 0;

  // Define o filtro fixo para a pesquisa (Tipo de Pessoa = F, J ou FJ)
  ControleConsultaModalPessoaTituloReceber.QryConsulta.Parameters.ParamByName('tipo').Value := 'FJ';

  // Abre o formulário em modal e aguarda
  ControleConsultaModalPessoaTituloReceber.ShowModal(procedure(Sender: TComponent; Result: Integer)
  begin
{    if Result = 1 then
    begin}
      // Pega o id da pessoa selecionada
      PessoaId := ControleConsultaModalPessoaTituloReceber.CdsConsulta.FieldByName('id').AsInteger;
      UniEdtResponsavel.Text := ControleConsultaModalPessoaTituloReceber.CdsConsulta.FieldByName('razao_social').AsString;
//    end;
  end);
end;

procedure TControleOperacoesIntegracaoNegociarTituloReceber.BotaoSalvarClick(
  Sender: TObject);
var
  QtdParcelas,
  Erro: string;
  CadastroId: Integer;
  IdContaBancaria : Double;
  vSomaParcela: string;
  ObservacaoNumeroReferencia : string;
begin
  inherited;

  CdsTitulosGerado.First;
  while not CdsTitulosGerado.Eof do
  begin
    ObservacaoNumeroReferencia := ObservacaoNumeroReferencia +  CdsTitulosGerado.FieldByName('NUMERO_REFERENCIA').AsString + ' | ';
    CdsTitulosGerado.Next;
  end;

  // Inicia a transação
  if ControleMainModule.ADOConnection.InTransaction = False then
    ControleMainModule.ADOConnection.BeginTrans;

  vSomaParcela := CdsAddSomaParcelas.AsString;

  if StrToFloatDef(vSomaParcela,0) <> 0 then
  begin
    if StrToFloatDef(vSomaParcela,0) < StrToFloatDef(UniEdtValor.Text,0) then
    begin
      ControleMainModule.MensageiroSweetAlerta('Atenção',
                                               'O valor negociado não pode ser inferior ao valor original do título');
      Exit;
    end;
  end
  else
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção',
                                             'Adicione ao menos 1(uma) parcela para realizar a negociação!');
    Exit;
  end;

  with ControleMainModule do
  begin
    //1º CRIA NOVOS TITULOS COM NEGOCIAÇÃO
    if CdsAdd.RecordCount <> 0 then
    begin
      QtdParcelas := CdsAddContaParcelas.AsString;
      CdsAdd.First; //vá para o inicio do cds

      while not CdsAdd.Eof do
      begin
        QryAx1.Parameters.Clear;
        QryAx1.SQL.Clear;

        // Gera um novo id para a tabela titulo
        CadastroId := GeraId('titulo');

        // Insert
        QryAx1.SQL.Add('INSERT INTO titulo (');
        QryAx1.SQL.Add('       id,');
        QryAx1.SQL.Add('       filial_id,');
        QryAx1.SQL.Add('       condicoes_pagamento_id,');
        QryAx1.SQL.Add('       titulo_categoria_id,');
        QryAx1.SQL.Add('       natureza,');
        QryAx1.SQL.Add('       numero_documento,');
        QryAx1.SQL.Add('       data_emissao,');
        QryAx1.SQL.Add('       data_vencimento,');
        QryAx1.SQL.Add('       data_venc_original,');
        QryAx1.SQL.Add('       valor,');
        QryAx1.SQL.Add('       valor_original,');
        QryAx1.SQL.Add('       valor_desconto,');
        QryAx1.SQL.Add('       situacao,');
        QryAx1.SQL.Add('       data_liquidacao,');
        QryAx1.SQL.Add('       data_cancelamento,');
        QryAx1.SQL.Add('       valor_juros,');
        QryAx1.SQL.Add('       valor_multa,');
        QryAx1.SQL.Add('       valor_pago,');
        QryAx1.SQL.Add('       valor_liquidado,');
        QryAx1.SQL.Add('       historico,');
        QryAx1.SQL.Add('       observacao,');
        QryAx1.SQL.Add('       sequencia_parcelas,');
        QryAx1.SQL.Add('       numero_referencia)');
        QryAx1.SQL.Add('VALUES (');
        QryAx1.SQL.Add('       :id,');
        QryAx1.SQL.Add('       :filial_id,');
        QryAx1.SQL.Add('       :condicoes_pagamento_id,');
        QryAx1.SQL.Add('       :titulo_categoria_id,');
        QryAx1.SQL.Add('       :natureza,');
        QryAx1.SQL.Add('       :numero_documento,');
        QryAx1.SQL.Add('       SYSDATE,');
        QryAx1.SQL.Add('       :data_vencimento,');
        QryAx1.SQL.Add('       :data_venc_original,'); // Coloca a mesma data do vencimento, caso altere a data de vencimento esta continuará intacta
        QryAx1.SQL.Add('       :valor,');
        QryAx1.SQL.Add('       :valor_original,');
        QryAx1.SQL.Add('       :valor_desconto,');
        QryAx1.SQL.Add('       ''A'','); // Marca o título como aberto
        QryAx1.SQL.Add('       NULL,');
        QryAx1.SQL.Add('       NULL,');
        QryAx1.SQL.Add('       ''0.00'',');
        QryAx1.SQL.Add('       ''0.00'',');
        QryAx1.SQL.Add('       :valor_pago,');
        QryAx1.SQL.Add('       :valor_liquidado,');
        QryAx1.SQL.Add('       :historico,');
        QryAx1.SQL.Add('       :observacao,');
        QryAx1.SQL.Add('       :sequencia_parcelas,');
        QryAx1.SQL.Add('       :numero_referencia)');

        QryAx1.Parameters.ParamByName('id').Value                     := CadastroId;
        QryAx1.Parameters.ParamByName('filial_id').Value              := 1;
        QryAx1.Parameters.ParamByName('condicoes_pagamento_id').Value := CdsAddCONDICOES_PAGAMENTO_ID.AsString;
        QryAx1.Parameters.ParamByName('titulo_categoria_id').Value    := CategoriaId;
        QryAx1.Parameters.ParamByName('natureza').Value               := 'C';
        QryAx1.Parameters.ParamByName('numero_documento').Value       := CdsTitulosGerado.FieldByName('NUMERO_REFERENCIA').AsString;
        QryAx1.Parameters.ParamByName('data_vencimento').Value        := CdsAddVENCIMENTO.Value;
        QryAx1.Parameters.ParamByName('data_venc_original').Value     := CdsAddVENCIMENTO.Value;
        QryAx1.Parameters.ParamByName('valor').Value                  := StringReplace(CdsAddVALOR.AsString,',','.',[]);
        QryAx1.Parameters.ParamByName('valor_original').Value         := StringReplace(CdsAddVALOR.AsString,',','.',[]);
        QryAx1.Parameters.ParamByName('valor_desconto').Value         := '0';
        QryAx1.Parameters.ParamByName('Observacao').Value             := ObservacaoNumeroReferencia;
        QryAx1.Parameters.ParamByName('sequencia_parcelas').Value     := CdsAddPARCELA.AsString;
        QryAx1.Parameters.ParamByName('numero_referencia').Value      := CdsTitulosGerado.FieldByName('NUMERO_REFERENCIA').AsString;
        QryAx1.Parameters.ParamByName('historico').Value              := OperacaoTitulos+ ObservacaoNumeroReferencia;
        QryAx1.Parameters.ParamByName('valor_pago').Value             := '0.00';
        QryAx1.Parameters.ParamByName('valor_liquidado').Value        := '0.00';

        // Tenta salvar os dados PASSO 1º
        try
          QryAx1.ExecSQL;
        except
        on E: Exception do
          begin
            Erro := ControleFuncoes.RetiraAspaSimples(E.Message);
            ControleMainModule.MensageiroSweetAlerta('Atenção', Erro);
          end;
        end;

        // Passo 2 - Salva os dados do titulo a receber
        if Erro='' then
        begin
          QryAx2.Parameters.Clear;
          QryAx2.SQL.Clear;

          // Insert
          QryAx2.SQL.Add('INSERT INTO titulo_receber (');
          QryAx2.SQL.Add('       id,');
          QryAx2.SQL.Add('       cliente_id)');
          QryAx2.SQL.Add('VALUES (');
          QryAx2.SQL.Add('       :id,');
          QryAx2.SQL.Add('       :cliente_id)');

          QryAx2.Parameters.ParamByName('id').Value           := CadastroId; // O id do titulo a receber será igual ao id do titulo
          QryAx2.Parameters.ParamByName('cliente_id').Value   := PessoaId;

          // Tenta salvar os dados PASSO 2º
          try
            QryAx2.ExecSQL;
          except
          on E: Exception do
            begin
              Erro := ControleFuncoes.RetiraAspaSimples(E.Message);
              ControleMainModule.MensageiroSweetAlerta('Atenção', Erro);
              BotaoSalvar.ModalResult := mrNone;
            end;
          end;
        end;

        // Passo 3 - Salva os dados na tabela cheque, caso exitam
        if CdsAddGERA_CHEQUE.AsString = 'S' then
        begin
          if Erro = '' then
          begin
            QryAx3.Parameters.Clear;
            QryAx3.SQL.Clear;

            // Insert
            QryAx3.SQL.Add('INSERT INTO cheque (');
            QryAx3.SQL.Add('       id,');
            QryAx3.SQL.Add('       cliente_id,');
            QryAx3.SQL.Add('       cliente_emitente_id,');
            QryAx3.SQL.Add('       situacao)');
            QryAx3.SQL.Add('VALUES (');
            QryAx3.SQL.Add('       :id,');
            QryAx3.SQL.Add('       :cliente_id,');
            QryAx3.SQL.Add('       :cliente_emitente_id,');
            QryAx3.SQL.Add('       :situacao)');

            QryAx3.Parameters.ParamByName('id').Value                   := CadastroId;
            QryAx3.Parameters.ParamByName('cliente_id').Value           := PessoaId;
            QryAx3.Parameters.ParamByName('cliente_emitente_id').Value  := PessoaId;
            QryAx3.Parameters.ParamByName('situacao').Value             := 'DEPOSITAR';

            // Tenta salvar os dados PASSO 3º
            try
              QryAx3.ExecSQL;
            except
            on E: Exception do
              begin
                Erro := ControleFuncoes.RetiraAspaSimples(E.Message);
                ControleMainModule.MensageiroSweetAlerta('Atenção', Erro);
                BotaoSalvar.ModalResult := mrNone;
              end;
            end;
          end;
        end;
        CdsAdd.Next;
      end;

      //5º EXECUTA COMMIT
      if Erro = '' then
      begin
        try
          ControleMainModule.ADOConnection.CommitTrans;
        except
          on E: Exception do
          begin
            ADOConnection.RollbackTrans;
            ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));
            BotaoSalvar.ModalResult := mrNone;
          end;
        end;
      end;
    end;
  end;
end;

Function TControleOperacoesIntegracaoNegociarTituloReceber.RetornaDataProximoTitulo(DataVenc: TDateTime): TDateTime;
var
  Dia, Mes, Ano : Word;
begin
  DecodeDate(DataVenc, Ano, Mes, Dia);

  if DiaPadrao = 0 then
    DiaPadrao := Dia;

  if DiaPadrao <> 0 then
    Dia := DiaPadrao;

  if Mes = 12 then
  begin
     Mes := 0;
     Ano := Ano + 1;
  end;

  Mes := Mes + 1;

  if Mes = 2 then
  begin
    // Fevereiro
    if Dia > 28 then
      if IsLeapYear(Ano) then
        Dia := 29
      else
        Dia := 28;
  end
  else if Mes = 4 then
  begin
    //Abril
    if dia = 31 then
      dia := 30;
  end
  else if Mes = 6 then
  begin
    //Junho
    if dia = 31 then
      dia := 30;
  end
  else if Mes = 9 then
  begin
    //Setembro
    if dia = 31 then
      dia := 30;
  end
  else if Mes = 11 then
  begin
    //Novembro
    if dia = 31 then
      dia := 30;
  end;

  Try
    Result := EncodeDate(Ano, Mes, Dia);
  Except
   on e:Exception do
     ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(e.Message));
  End;
end;


end.
