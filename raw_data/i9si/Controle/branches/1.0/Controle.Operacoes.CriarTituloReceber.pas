unit Controle.Operacoes.CriarTituloReceber;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Controle.Operacoes, uniBitBtn, uniSpeedButton,
  uniLabel, uniButton, uniGUIBaseClasses, uniPanel, Data.Win.ADODB,
  Datasnap.Provider, Data.DB, Datasnap.DBClient, uniImageList, uniEdit,
  uniDateTimePicker, uniMemo, uniCheckBox, uniRadioGroup, uniMultiItem,
  uniComboBox, uniDBComboBox, uniGroupBox, uniSweetAlert, frxClass, frxDBSet,
  Controle.Consulta.TituloReceber, uniBasicGrid, uniDBGrid;

type
  TControleOperacoesCriarTituloReceber = class(TControleOperacoes)
    UniPanel5: TUniPanel;
    UniPanel6: TUniPanel;
    UniLabel1: TUniLabel;
    UniEditResponsavelTitulo: TUniEdit;
    UniLabel3: TUniLabel;
    UniSpeedButtonResponsavel: TUniSpeedButton;
    UniLabel11: TUniLabel;
    UniPanel8: TUniPanel;
    UniLabel2: TUniLabel;
    UniDateTitulo: TUniDateTimePicker;
    UniLabel4: TUniLabel;
    UniCheckBoxRepetir: TUniCheckBox;
    UniFormattedNumberValor: TUniFormattedNumberEdit;
    UniLabel10: TUniLabel;
    UniEditNumeroReferencia: TUniEdit;
    UniSpeedButtonPesquisaNFCe: TUniSpeedButton;
    UniPanelPeriodo: TUniPanel;
    UniLabel5: TUniLabel;
    UniComboBoxQuantParc: TUniComboBox;
    UniLabel6: TUniLabel;
    UniComboBoxPeriodo: TUniComboBox;
    UniPanel7: TUniPanel;
    UniMemoObs: TUniMemo;
    UniPanel9: TUniPanel;
    UniPanel10: TUniPanel;
    UniLabel7: TUniLabel;
    UniSweetAlertRepeteOperacao: TUniSweetAlert;
    UniLabelValorTituloRateado: TUniLabel;
    UniLabelValorParcela: TUniLabel;
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
    QryTituloCategoria: TADOQuery;
    CdsTituloCategoria: TClientDataSet;
    CdsTituloCategoriaID: TFloatField;
    CdsTituloCategoriaDESCRICAO: TWideStringField;
    CdsTituloCategoriaTIPO_TITULO: TWideStringField;
    DspTituloCategoria: TDataSetProvider;
    DscTituloCategoria: TDataSource;
    UniDBComboBoxCondicaoPagamento: TUniComboBox;
    UniDBComboBoxCategoria: TUniComboBox;
    procedure UniFormShow(Sender: TObject);
    procedure UniSpeedButtonResponsavelClick(Sender: TObject);
    procedure UniCheckBoxRepetirClick(Sender: TObject);
    procedure BotaoSalvarClick(Sender: TObject);
    procedure BotaoDescartarClick(Sender: TObject);
    procedure UniSweetAlertRepeteOperacaoConfirm(Sender: TObject);
    procedure UniSweetAlertRepeteOperacaoDismiss(Sender: TObject;
      const Reason: TDismissType);
    procedure UniSpeedButtonPesquisaNFCeClick(Sender: TObject);
    procedure UniComboBoxQuantParcChange(Sender: TObject);
    procedure UniDBComboBoxCondicaoPagamentoChange(Sender: TObject);
    procedure UniDBComboBoxCategoriaChange(Sender: TObject);
  private
    CondicaoPagamento_id : Integer;
    TituloCategoriaId : Integer;
    NumeroDocumentoTitulo : String;
    DiaPadrao: Word;
    procedure GerarTitulos;
    procedure PreencheFiltros;
    { Private declarations }
  public
    PessoaId: Integer;
    PrimeiraDataDoCarne: TDateTime;
    { Public declarations }
  end;

function ControleOperacoesCriarTituloReceber: TControleOperacoesCriarTituloReceber;

implementation

{$R *.dfm}

uses
 Controle.Main.Module, uniGUIApplication,
  Controle.Consulta.Modal.TipoTitulo,
System.DateUtils, Controle.Funcoes,
  System.Math, Controle.Consulta.Modal.Pessoa.TituloReceber, Controle.Main,
   Controle.Consulta.Modal.TituloCategoria.Receber;

function ControleOperacoesCriarTituloReceber: TControleOperacoesCriarTituloReceber;
begin
  Result := TControleOperacoesCriarTituloReceber(ControleMainModule.GetFormInstance(TControleOperacoesCriarTituloReceber));
end;


procedure TControleOperacoesCriarTituloReceber.BotaoDescartarClick(
  Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TControleOperacoesCriarTituloReceber.BotaoSalvarClick(
  Sender: TObject);
begin
  inherited;
  GerarTitulos;
end;

Procedure TControleOperacoesCriarTituloReceber.GerarTitulos();
var
  CadastroId, I: Integer;
  Periodo,Parcelas: Integer;
  Valor: String;
  ValorCur  : currency;
  rateio    : Double;
begin
  inherited;

  if Trim(UniEditResponsavelTitulo.Text) = '' then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar o responsável financeiro da cobrança');

    UniEditResponsavelTitulo.SetFocus;
    Exit;
  end;

  if Trim(UniDBComboBoxCondicaoPagamento.Text) = '' then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar a forma de cobrança');

    UniDBComboBoxCondicaoPagamento.SetFocus;
    Exit;
  end;

  if Trim(UniDBComboBoxCategoria.Text) = '' then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar uma categoria para o título.');

    UniDBComboBoxCategoria.SetFocus;
    Exit;
  end;

  if UniFormattedNumberValor.Value = 0 then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar o valor da cobrança');

    UniFormattedNumberValor.SetFocus;
    Exit;
  end;

  if UniCheckBoxRepetir.Checked = True then
  begin
    if UniComboBoxQuantParc.ItemIndex = -1 then
    begin
      ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar a quantidade de parcelas para gerar a cobrança');
      Exit;
    end;
  end;

  // Verificando se é titulo parcelado
  if UniCheckBoxRepetir.Visible = True then
  begin
    if UniComboBoxPeriodo.Text = 'Anos' then
      Periodo := 372
    else if UniComboBoxPeriodo.Text = 'Semestres' then
      Periodo := 186
    else if UniComboBoxPeriodo.Text = 'Trimestres' then
      Periodo := 93
    else if UniComboBoxPeriodo.Text = 'Bimestres' then
      Periodo := 62
    else if UniComboBoxPeriodo.Text = 'Meses' then
    begin
      Periodo := 30;
    end
    else if UniComboBoxPeriodo.Text = 'Quinzenas' then
      Periodo := 15
    else if UniComboBoxPeriodo.Text = 'Semanas' then
      Periodo := 7
    else if UniComboBoxPeriodo.Text = 'Dias' then
      Periodo := 1;
  end;

  if ControleMainModule.tipo_geracao_titulos = 'S' then
    rateio := UniFormattedNumberValor.Value / StrToInt(UniComboBoxQuantParc.Text)
  else
    rateio := UniFormattedNumberValor.Value;

  if ControleMainModule.GravandoTituloReceber(CondicaoPagamento_id,
                                              TituloCategoriaId,
                                              PessoaId,
                                              'C',
                                              '0', // Será substituido pelo número do título
                                              UniDateTitulo.DateTime,
                                              RoundTo(rateio,-2),
                                              0,
                                              UniMemoObs.Text,
                                              Periodo,
                                              StrToInt(UniComboBoxQuantParc.Text),
                                              UniEditNumeroReferencia.Text) then
  begin
    UniSweetAlertRepeteOperacao.Show; // O código fica no evento do componente!
  end;
end;

procedure TControleOperacoesCriarTituloReceber.UniCheckBoxRepetirClick(
  Sender: TObject);
begin
  inherited;

  if UniCheckBoxRepetir.Checked = True then
  begin
    UniPanelPeriodo.Visible := True;
    Height := 470;
  end
  else
  begin
    UniPanelPeriodo.Visible := False;
    Height := 400;
  end;
end;

procedure TControleOperacoesCriarTituloReceber.UniComboBoxQuantParcChange(
  Sender: TObject);
begin
  inherited;
  if StrToInt(UniComboBoxQuantParc.Text) >1 then
  begin
    UniLabelValorParcela.Visible := True;
    UniLabelValorParcela.Text := formatfloat('Valor de cada parcela é R$ #,##0.00', RoundTo(UniFormattedNumberValor.Value / StrToInt(UniComboBoxQuantParc.Text),-2));
  end
  else
  UniLabelValorParcela.Visible := False;
end;

procedure TControleOperacoesCriarTituloReceber.UniDBComboBoxCategoriaChange(
  Sender: TObject);
begin
  inherited;
  CdsTituloCategoria.Locate('DESCRICAO',UniDBComboBoxCategoria.Text,[]);
  TituloCategoriaId := CdsTituloCategoriaID.AsInteger;
end;

procedure TControleOperacoesCriarTituloReceber.UniDBComboBoxCondicaoPagamentoChange(
  Sender: TObject);
begin
  CdsCondicoesPagamento.Locate('DESCRICAO',UniDBComboBoxCondicaoPagamento.Text,[]);
  CondicaoPagamento_id := CdsCondicoesPagamentoID.AsInteger;
end;

procedure TControleOperacoesCriarTituloReceber.UniFormShow(Sender: TObject);
begin
  inherited;
  UniDateTitulo.DateTime := Date();
  UniPanelPeriodo.Visible := False;
  Height := 400;
  BotaoSalvar.Top := 5;
  BotaoDescartar.Top := 5;

  if ControleMainModule.tipo_geracao_titulos = 'S' then
  begin
    UniLabelValorTituloRateado.Text := 'Esse valor será dividido pela quantidade de parcelas';
    UniCheckBoxRepetir.Caption := 'Parcelar?';
  end
  else
  begin
    UniLabelValorTituloRateado.Text := 'Valor de cada parcela';
    UniCheckBoxRepetir.Caption := 'Repetir lançamento?';
  end;

  PreencheFiltros;

  //Se não colocar aqui e caso não realize nenhuma mudança no combobox fica zero
  TituloCategoriaId := CdsTituloCategoriaID.AsInteger;
  CondicaoPagamento_id := CdsCondicoesPagamentoID.AsInteger;
end;

procedure TControleOperacoesCriarTituloReceber.UniSpeedButtonPesquisaNFCeClick(
  Sender: TObject);
var
  CdsCabecalhoPedido, CdsCliente: TClientDataSet;
begin
  inherited;
  // Criando ClientDataset em tempo de execução
  CdsCabecalhoPedido := TClientDataSet.Create(UniApplication);

  if UniEditNumeroReferencia.Text <> '' then
  begin
    // Atribuindo o retorno da função ao clientdataset criado anteriormente
    Try
      CdsCabecalhoPedido := ControleMainModule.SelecioPedidoCabecalhoGestor(StrToInt(UniEditNumeroReferencia.Text));
    except
      on e:Exception do
      begin
        ControleMainModule.MensageiroSweetAlerta('Atenção', 'Schema GESTOR não encontrado! '+ e.Message);
        Exit;
      end;
    End;

    if CdsCabecalhoPedido.RecordCount <> 0 then
    begin
      if RoundTo(CdsCabecalhoPedido.FieldByName('valor_total').AsFloat,-2) = 0 then
      begin
        ControleMainModule.MensageiroSweetAlerta('Atenção', 'As condições de pagamento desse pedido não geram cobranças financeiras!');
        Exit;
      end;

      UniFormattedNumberValor.Text := CdsCabecalhoPedido.FieldByName('valor_total').AsString;

      if CdsCabecalhoPedido.FieldByName('cpf_cnpj').AsString <> '00000000000' then
      begin
        // Verificando se o cpf/cnpj está cadastrado no banco do controle
        CdsCliente := TClientDataSet.Create(UniApplication);
        CdsCliente := ControleMainModule.SelecionaCliente(CdsCabecalhoPedido.FieldByName('cpf_cnpj').AsString);

        if CdsCliente.RecordCount > 0 {Encontrou o cliente} then
        begin
          PessoaId := CdsCliente.FieldByName('id').AsInteger;
          UniEditResponsavelTitulo.Text := CdsCliente.FieldByName('razao_social').AsString;
        end;
      end;
    end
    else
      ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar o número de nfce já emitida para importar os dados.');
  end
  else
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar o número de nfce já emitida para importar os dados.');
  end;
end;

procedure TControleOperacoesCriarTituloReceber.UniSpeedButtonResponsavelClick(
  Sender: TObject);
begin
  inherited;
  PessoaId := 0;

  // Define o filtro fixo para a pesquisa (Tipo de Pessoa = F, J ou FJ)
  ControleConsultaModalPessoaTituloReceber.QryConsulta.Parameters.ParamByName('tipo').Value := 'FJ';
  ControleConsultaModalPessoaTituloReceber.UniEditRazao.Text := UniEditResponsavelTitulo.Text;

  // Abre o formulário em modal e aguarda
  ControleConsultaModalPessoaTituloReceber.ShowModal(procedure(Sender: TComponent; Result: Integer)
  begin
    if Result = 1 then
    begin
      // Pega o id da pessoa selecionada
      PessoaId := ControleConsultaModalPessoaTituloReceber.CdsConsulta.FieldByName('id').AsInteger;
      UniEditResponsavelTitulo.Text := ControleConsultaModalPessoaTituloReceber.CdsConsulta.FieldByName('razao_social').AsString;
    end;
  end);
end;

procedure TControleOperacoesCriarTituloReceber.UniSweetAlertRepeteOperacaoConfirm(
  Sender: TObject);
begin
  inherited;
  UniEditResponsavelTitulo.Text := '';
  UniEditNumeroReferencia.Text := '';
  PessoaId := 0;
end;

procedure TControleOperacoesCriarTituloReceber.UniSweetAlertRepeteOperacaoDismiss(
  Sender: TObject; const Reason: TDismissType);
begin
  inherited;
  Close;
end;


procedure TControleOperacoesCriarTituloReceber.PreencheFiltros;
begin
  //preenche combo com as condições de COBRANÇA
  With UniDBComboBoxCondicaoPagamento do
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


   // Preenchendo o combo para consulta da categoria
  With UniDBComboBoxCategoria do
  begin
    Clear;
    CdsTituloCategoria.Close;
    CdsTituloCategoria.Open;
    CdsTituloCategoria.First;
    while not CdsTituloCategoria.eof do
    begin
      Items.Add(CdsTituloCategoriaDESCRICAO.AsString);
      CdsTituloCategoria.Next;
    end;
    CdsTituloCategoria.First;
  end;
end;

end.
