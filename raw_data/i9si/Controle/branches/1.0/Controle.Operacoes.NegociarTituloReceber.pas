unit Controle.Operacoes.NegociarTituloReceber;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Controle.Operacoes,  
  Data.Win.ADODB, Datasnap.Provider, Data.DB, Datasnap.DBClient,
  uniGUIBaseClasses, uniImageList, uniBitBtn, uniSpeedButton, uniLabel,
  uniButton, uniPanel, uniEdit, uniGroupBox, uniBasicGrid, uniDBGrid,
  uniMultiItem, uniComboBox, uniDateTimePicker, uniDBEdit, uniDBDateTimePicker,
  uniRadioGroup;

type
  TControleOperacoesNegociarTituloReceber = class(TControleOperacoes)
    UniGroupBox1: TUniGroupBox;
    UniLabel1: TUniLabel;
    UniLabel2: TUniLabel;
    UniLabel10: TUniLabel;
    UniLabel4: TUniLabel;
    UniGroupBox2: TUniGroupBox;
    EditValorParcela: TUniFormattedNumberEdit;
    UniLabel6: TUniLabel;
    UniDBGrid1: TUniDBGrid;
    UniEditResponsavelTitulo: TUniDBEdit;
    UniEditTipoTitulo: TUniDBEdit;
    UniEditNumeroReferencia: TUniDBEdit;
    UniFormattedNumberValor: TUniDBEdit;
    UniDBDateTimePicker1: TUniDBDateTimePicker;
    QryCadastroID: TFloatField;
    QryCadastroNUMERO_DOCUMENTO: TWideStringField;
    QryCadastroDATA_VENCIMENTO: TDateTimeField;
    QryCadastroVALOR: TFloatField;
    QryCadastroRAZAO_SOCIAL: TWideStringField;
    QryCadastroDESCRICAO_CATEGORIA: TWideStringField;
    QryCadastroDESCRICAO_FORMA_PAGAMENTO: TWideStringField;
    CdsCadastroID: TFloatField;
    CdsCadastroNUMERO_DOCUMENTO: TWideStringField;
    CdsCadastroDATA_VENCIMENTO: TDateTimeField;
    CdsCadastroVALOR: TFloatField;
    CdsCadastroRAZAO_SOCIAL: TWideStringField;
    CdsCadastroDESCRICAO_CATEGORIA: TWideStringField;
    CdsCadastroDESCRICAO_FORMA_PAGAMENTO: TWideStringField;
    DscAdd: TDataSource;
    EditFormaPgDescricao: TUniEdit;
    UniLabel8: TUniLabel;
    UniSpeedButtonCobranca: TUniSpeedButton;
    UniButton1: TUniButton;
    UniLabel5: TUniLabel;
    LabelSomaParcelas: TUniLabel;
    UniLabel9: TUniLabel;
    Vencimento_negociacao: TUniDateTimePicker;
    CdsAdd: TClientDataSet;
    CdsAddVENCIMENTO: TDateField;
    CdsAddNUM_TITULO_ORIGINAL: TStringField;
    CdsAddVALOR: TFloatField;
    CdsAddPARCELA: TFloatField;
    CdsAddSomaParcelas: TAggregateField;
    CdsAddContaParcela: TAggregateField;
    QryCadastroTITULO_CATEGORIA_ID: TFloatField;
    QryCadastroCONTA_BANCARIA_ID: TFloatField;
    CdsCadastroTITULO_CATEGORIA_ID: TFloatField;
    CdsCadastroCONTA_BANCARIA_ID: TFloatField;
    QryCadastroCLIENTE_ID: TFloatField;
    CdsCadastroCLIENTE_ID: TFloatField;
    CdsAddGERA_BOLETO: TBooleanField;
    CdsAddTIPO_TITULO_ID: TStringField;
    CdsAddTIPO_TITULO_DESCRICAO: TStringField;
    CdsAddTIPO_TITULO_PREFIXO: TStringField;
    QryCadastroPREFIXO_FORMA_PAGAMENTO: TWideStringField;
    CdsCadastroPREFIXO_FORMA_PAGAMENTO: TWideStringField;
    UniLabel3: TUniLabel;
    QryCategoria: TADOQuery;
    CdsCategoria: TClientDataSet;
    DspCategoria: TDataSetProvider;
    DscCategoria: TDataSource;
    CdsCategoriaID: TFloatField;
    CdsCategoriaDESCRICAO: TWideStringField;
    CdsCategoriaTIPO_TITULO: TWideStringField;
    UniComboBoxCategoria: TUniComboBox;
    UniLabel7: TUniLabel;
    procedure BotaoSalvarClick(Sender: TObject);
    procedure UniSpeedButtonCobrancaClick(Sender: TObject);
    procedure UniButton1Click(Sender: TObject);
    procedure UniFormCreate(Sender: TObject);
    procedure UniFormShow(Sender: TObject);
    procedure UniComboBoxCategoriaChange(Sender: TObject);
  private
    CategoriaId,
    TipoTituloId_negociado,
    TipoTituloPrefixo_negociado,
    TipoTituloDescricao_negociado : string;
    GeraBoleto_negociado : Boolean;
    DiaPadrao: Word;
    function RetornaDataProximoTitulo(DataVenc: TDateTime): TDateTime;
    function CalculaParcela(Vencimento: TDateTime; Valor: string): Boolean;

    { Private declarations }
  public
    function abrir(id: Integer): boolean;
    { Public declarations }
  end;

function ControleOperacoesNegociarTituloReceber: TControleOperacoesNegociarTituloReceber;

implementation

{$R *.dfm}

uses
  Controle.Main.Module,
  uniGUIApplication,
  Controle.Funcoes,
  
  Controle.Consulta.Modal.TipoTitulo;

function ControleOperacoesNegociarTituloReceber: TControleOperacoesNegociarTituloReceber;
begin
  Result := TControleOperacoesNegociarTituloReceber(ControleMainModule.GetFormInstance(TControleOperacoesNegociarTituloReceber));
end;

function TControleOperacoesNegociarTituloReceber.abrir(id: Integer): boolean;
begin
  //preenche a categoria.
  CdsCategoria.Open;
  CdsCategoria.First;
  while not CdsAdd.Eof do
  begin
    UniComboBoxCategoria.Items.Add(CdsCategoriaDESCRICAO.AsString);
    CdsCategoria.Next;
  end;

  CdsCadastro.Close;
  CdsCadastro.ParamByName('id_titulo').Value := id;
  CdsCadastro.Open;

  Result := CdsCadastro.Active;
end;

procedure TControleOperacoesNegociarTituloReceber.BotaoSalvarClick(
  Sender: TObject);
var
  QtdParcelas,
  Erro: string;
  CadastroId: Integer;
  IdContaBancaria : Double;
  vSomaParcela: string;
begin
  inherited;
   IdContaBancaria := StrToFloatDef(CdsCadastroCONTA_BANCARIA_ID.AsString,0);

  // Inicia a transação
  if ControleMainModule.ADOConnection.InTransaction = False then
    ControleMainModule.ADOConnection.BeginTrans;

  vSomaParcela := CdsAddSomaParcelas.AsString;

  if StrToFloatDef(vSomaParcela,0) <> 0 then
  begin
    if StrToFloatDef(vSomaParcela,0) < CdsCadastroVALOR.AsFloat then
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
      QtdParcelas := CdsAddContaParcela.AsString;
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
        QryAx1.SQL.Add('       tipo_titulo_id,');
        if IdContaBancaria <> 0 then
          QryAx1.SQL.Add('       conta_bancaria_id,');
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
        QryAx1.SQL.Add('       :tipo_titulo_id,');
        if IdContaBancaria <> 0 then
          QryAx1.SQL.Add('       :conta_bancaria_id,');
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
        QryAx1.SQL.Add('       ''0.00'',');
        QryAx1.SQL.Add('       ''0.00'',');
        QryAx1.SQL.Add('       NULL,');
        QryAx1.SQL.Add('       :observacao,');
        QryAx1.SQL.Add('       :sequencia_parcelas,');
        QryAx1.SQL.Add('       :numero_referencia)');

        QryAx1.Parameters.ParamByName('id').Value                 := CadastroId;
        QryAx1.Parameters.ParamByName('filial_id').Value          := 1;
        QryAx1.Parameters.ParamByName('tipo_titulo_id').Value     := CdsAddTIPO_TITULO_ID.AsString;
        if IdContaBancaria <> 0 then
          QryAx1.Parameters.ParamByName('conta_bancaria_id').Value := IdContaBancaria;
        QryAx1.Parameters.ParamByName('titulo_categoria_id').Value := CategoriaId;//CdsCadastroTITULO_CATEGORIA_ID.AsString;
        // C - Cobranca | L - Liquidação
        QryAx1.Parameters.ParamByName('natureza').Value           := 'C';
        QryAx1.Parameters.ParamByName('numero_documento').Value   := CdsAddNUM_TITULO_ORIGINAL.AsString;
        QryAx1.Parameters.ParamByName('data_vencimento').Value    := CdsAddVENCIMENTO.Value;
        QryAx1.Parameters.ParamByName('data_venc_original').Value := CdsAddVENCIMENTO.Value;
        QryAx1.Parameters.ParamByName('valor').Value              := CdsAddVALOR.AsString;
        QryAx1.Parameters.ParamByName('valor_original').Value     := CdsAddVALOR.AsString;
        QryAx1.Parameters.ParamByName('valor_desconto').Value     := '0';
        QryAx1.Parameters.ParamByName('Observacao').Value         := '';
        QryAx1.Parameters.ParamByName('sequencia_parcelas').Value := CdsAddPARCELA.AsString;
        QryAx1.Parameters.ParamByName('numero_referencia').Value  := CdsAddNUM_TITULO_ORIGINAL.AsString;

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
          QryAx2.Parameters.ParamByName('cliente_id').Value    := CdsCadastroCLIENTE_ID.AsString;

          // Tenta salvar os dados PASSO 2º
          try
            QryAx2.ExecSQL;
          except
          on E: Exception do
            begin
              Erro := ControleFuncoes.RetiraAspaSimples(E.Message);
              ControleMainModule.MensageiroSweetAlerta('Atenção', Erro);
            end;
          end;
        end;

        // Passo 3 - Salva os dados na tabela cheque, caso exitam
        if CdsAddTIPO_TITULO_PREFIXO.AsString = 'CH' then
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
            QryAx3.Parameters.ParamByName('cliente_id').Value           := CdsCadastroCLIENTE_ID.AsString;
            QryAx3.Parameters.ParamByName('cliente_emitente_id').Value  := CdsCadastroCLIENTE_ID.AsString;
            QryAx3.Parameters.ParamByName('situacao').Value             := 'DEPOSITAR';

            // Tenta salvar os dados PASSO 3º
            try
              QryAx3.ExecSQL;
            except
            on E: Exception do
              begin
                Erro := ControleFuncoes.RetiraAspaSimples(E.Message);
                ControleMainModule.MensageiroSweetAlerta('Atenção', Erro);
              end;
            end;
          end;
        end;
        CdsAdd.Next;
      end;

      //4º MUDAR STATUS DE TITULO ATUAL PARA NEGOCIADO
      if Erro = '' then
      begin
       CdsAx4.Close;
       QryAx4.Parameters.Clear;
       QryAx4.SQL.Clear;
       QryAx4.SQL.Text :=
                       'UPDATE titulo            '
                     + '   SET situacao  = ''N'' '
                     + ' WHERE id        = :id   ';
       QryAx4.Parameters.ParamByName('id').Value := CdsCadastroID.AsInteger;

       try
        // Tenta salvar os dados PASSO 4º
        QryAx4.ExecSQL;
       except
       on E: Exception do
         begin
           ADOConnection.RollbackTrans;
           ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));
         end;
        end;
      end;

      //5º EXECUTA COMMIT
      if Erro = '' then
      begin
       try
        ControleMainModule.ADOConnection.CommitTrans;
        ControleMainModule.MensageiroSweetAlerta('Negociado!', 'O título original '+CdsAddNUM_TITULO_ORIGINAL.AsString+' agora está na situação negociado e foram criados '+QtdParcelas+' novas pacelas.');
        Close;
       except
         on E: Exception do
         begin
            ADOConnection.RollbackTrans;
            ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));
         end;
        end;
      end;
    end;
  end;
end;

function TControleOperacoesNegociarTituloReceber.CalculaParcela(Vencimento: TDateTime;
                                                                Valor: string): Boolean;
var
  Periodo,Parcela,I : Integer;

begin
  inherited;
//
//  CdsAdd.Close;
//  CdsAdd.CreateDataSet;
//
//  Parcela :=  1;
//
//  for I := 1 to Parcela do
//  begin
//    CdsAdd.Append;
//    CdsAddParcela.AsString        := IntToStr(I);
//    CdsAddVencimento.AsDateTime   := RetornaDataProximoTitulo(Vencimento);
//    CdsAddValor.AsString          := valor;
//    CdsAdd.Post;
//
//    if Periodo = 30 then
//    begin
//        Vencimento := RetornaDataProximoTitulo(Vencimento);
//    end
//    else
//      Vencimento := Vencimento + Periodo;
//  end;
end;

Function TControleOperacoesNegociarTituloReceber.RetornaDataProximoTitulo(DataVenc: TDateTime): TDateTime;
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

procedure TControleOperacoesNegociarTituloReceber.UniButton1Click(
  Sender: TObject);
var
ContaParcela,
SomaParcela,
ValorDigitado,
valorTitulo : Double;

begin
  ValorDigitado := StrToFloatDef(EditValorParcela.Text,0);
  ValorTitulo   := StrToFloatDef(UniFormattedNumberValor.Text,0);
  SomaParcela   := StrToFloatDef(CdsAddSomaParcelas.AsString,0);
  ContaParcela  := StrToFloatDef(CdsAddContaParcela.AsString,0);

  if ValorDigitado = 0 then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção','O valor da parcela não pode ser zerado.');
    Exit;
  end;

  if EditFormaPgDescricao.Text = '' then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção','Escolha uma forma de pagamento.');
    Exit;
  end;

  if ValorDigitado <= ValorTitulo then
  begin
    if (SomaParcela + ValorDigitado) > ValorTitulo then
    begin
      ControleMainModule.MensageiroSweetAlerta('Atenção','O total das parcelas não pode ultrapassar o valor original do título.');
      Exit;
    end
    else
    begin

      CdsAdd.Append;
      CdsAddTIPO_TITULO_DESCRICAO.AsString   := EditFormaPgDescricao.Text;
      CdsAddTIPO_TITULO_ID.AsString          := TipoTituloId_negociado;
      CdsAddVALOR.AsString                   := EditValorParcela.Text;
      CdsAddVENCIMENTO.AsDateTime            := Vencimento_negociacao.DateTime;
      CdsAddGERA_BOLETO.Value                := GeraBoleto_negociado;
      CdsAddNUM_TITULO_ORIGINAL.AsString     := CdsCadastroID.AsString; //pega id do titulo de origem ao qual está em negociação e colocar nos outros como referencia.
      CdsAddTIPO_TITULO_PREFIXO.AsString     := TipoTituloPrefixo_negociado;

      if ContaParcela = 0 then
        CdsAddPARCELA.AsString            :='1'
      else
        CdsAddPARCELA.AsString              := FloatToStr(ContaParcela + 1);

      CdsAdd.Post;

      Vencimento_negociacao.DateTime :=  RetornaDataProximoTitulo(Vencimento_negociacao.DateTime);
      LabelSomaParcelas.Caption := 'R$ ' + Format('%7.2f',[StrToFloatDef(CdsAddSomaParcelas.AsString,0)]);
      EditValorParcela.SetFocus;
    end;
  end
  else
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção','O valor da parcela é mais alto que o valor do título original.');
  end;
end;

procedure TControleOperacoesNegociarTituloReceber.UniComboBoxCategoriaChange(
  Sender: TObject);
begin
  inherited;
  CategoriaId := CdsCategoriaID.AsString;
end;

procedure TControleOperacoesNegociarTituloReceber.UniFormCreate(
  Sender: TObject);
begin
  inherited;
  CdsAdd.Close;
  CdsAdd.CreateDataSet;

end;

procedure TControleOperacoesNegociarTituloReceber.UniFormShow(Sender: TObject);
begin
  inherited;
  Vencimento_negociacao.DateTime :=  RetornaDataProximoTitulo(CdsCadastroDATA_VENCIMENTO.Value);
end;

procedure TControleOperacoesNegociarTituloReceber.UniSpeedButtonCobrancaClick(
  Sender: TObject);
begin
  inherited;

  TipoTituloId_negociado := '0';
  // Abre o formulário em modal e aguarda
  ControleConsultaModalTipoTitulo.ShowModal(procedure(Sender: TComponent; Result: Integer)
  begin
    TipoTituloPrefixo_negociado := ControleConsultaModalTipoTitulo.CdsConsulta.FieldByName('prefixo').AsString;
    TipoTituloId_negociado      := ControleConsultaModalTipoTitulo.CdsConsulta.FieldByName('id').AsString;
    EditFormaPgDescricao.Text   := ControleConsultaModalTipoTitulo.CdsConsulta.FieldByName('descricao').AsString;

    if ControleConsultaModalTipoTitulo.CdsConsulta.FieldByName('gera_boleto').AsString = 'SIM' then
       GeraBoleto_negociado := True
      else
      GeraBoleto_negociado := False;

  end);
end;

end.
