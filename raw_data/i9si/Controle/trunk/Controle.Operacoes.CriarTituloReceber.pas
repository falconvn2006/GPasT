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
  uniBasicGrid, uniDBGrid, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.Types;

type
  TPessoa = record
  id : Integer;
  CpfCnpj : string;
  nome : string;
end;

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
    UniDateTitulo: TUniEdit;
    SweetAlertSucesso: TUniSweetAlert;
    FDQuery2: TFDQuery;
    FDQuery2CNPJCPF: TStringField;
    FDQuery2NOME: TStringField;
    FDQuery2ORIGINAL: TFloatField;
    FDQuery2VENCIM: TDateField;
    FDQuery2PARC: TIntegerField;
    FDQuery2INSCRG: TStringField;
    FDQuery2MAE: TStringField;
    FDQuery2PAI: TStringField;
    FDQuery2RAZAOSOCIAL: TStringField;
    FDQuery2ENDERECO: TStringField;
    FDQuery2BAIRRO: TStringField;
    FDQuery2ESTADO: TStringField;
    FDQuery2CEP: TStringField;
    FDQuery2FONES: TStringField;
    FDQuery2FAX: TStringField;
    FDQuery2CELULAR: TStringField;
    FDQuery2EMAIL: TStringField;
    FDQuery2DTNASC: TDateField;
    FDQuery2DTCAD: TDateField;
    FDQuery2OBS: TMemoField;
    FDQuery2SEXO: TStringField;
    FDQuery2ESTCIV: TStringField;
    CdsTitulosGerar: TClientDataSet;
    CdsTitulosGerarDIAS_ATRASO: TIntegerField;
    CdsTitulosGerarVALOR_CORRIGIDO: TFloatField;
    CdsTitulosGerarNUMERO_REFERENCIA: TIntegerField;
    CdsTitulosGerarSomaValorTotal: TAggregateField;
    CdsTitulosGerarMediaDiasAtraso: TAggregateField;
    FDQuery2NUMPEDIDO: TIntegerField;
    FDQuery1: TFDQuery;
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
    procedure UniDateTituloEnter(Sender: TObject);
    procedure UniEditResponsavelTituloKeyPress(Sender: TObject; var Key: Char);
    procedure UniDBComboBoxCondicaoPagamentoKeyPress(Sender: TObject;
      var Key: Char);
    procedure UniDBComboBoxCategoriaKeyPress(Sender: TObject; var Key: Char);
    procedure UniDateTituloKeyPress(Sender: TObject; var Key: Char);
    procedure UniEditNumeroReferenciaKeyPress(Sender: TObject; var Key: Char);
    procedure UniFormattedNumberValorEnter(Sender: TObject);
    procedure UniFormattedNumberValorKeyPress(Sender: TObject; var Key: Char);
    procedure SweetAlertSucessoConfirm(Sender: TObject);
  private
    CondicaoPagamento_id : Integer;
    TituloCategoriaId : Integer;
    NumeroDocumentoTitulo : String;
    DiaPadrao: Word;
    procedure GerarTitulos;
    procedure PreencheFiltros;
    function ProcuraPessoa(ClienteId: Integer): Boolean;
    function SelecionaTituloNumeroReferencia(numero_referencia: string): Boolean;
    procedure ImportaPedidoPDVe(NumeroPedido: String);
    procedure ImportaPedidoFirebird(NumeroPedido: String);
    function SelecionaTituloFirebird(nTitulo: String): TFDQuery;
    function separaTituloParcela(nTituloParcela: String): TStringDynArray;
    procedure AtualizaStatusReceberFirebird(numPedido, num_parcela: String);
    function SelecionaStatusReceberFirebird(numPedido: string; num_parcela: String): Boolean;
    procedure AtualizaHistoricoTitulo(pedido_id: Integer);
    procedure ProcessaTitulo(cpf_cnpj: string;
                             FDQ: TFDQuery;
                             nPed: string);

    { Private declarations }
  public
    PessoaId: Integer;
    PrimeiraDataDoCarne: TDateTime;
    { Public declarations }
  end;

function ControleOperacoesCriarTituloReceber: TControleOperacoesCriarTituloReceber;

var
  Cliente : TPessoa;
  PedidoIntegracao : Boolean;
  stringTituloParcelaSeparado: TStringDynArray;

implementation

{$R *.dfm}

uses
 Controle.Main.Module, uniGUIApplication,
  Controle.Consulta.Modal.TipoTitulo,
System.DateUtils, Controle.Funcoes,
  System.Math, Controle.Consulta.Modal.Pessoa.TituloReceber, Controle.Main,
   Controle.Consulta.Modal.TituloCategoria.Receber,
  System.StrUtils, Controle.Operacoes.Integracao.NegociarTituloReceber,
  Controle.Operacoes.Integracao.CalculoJuros, Controle.Consulta.TituloReceber,
  Controle.Consulta.Modal.CPFCliente;

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

{  if ControleFuncoes.ConfereData(UniDateTitulo.Text) = False then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Data inválida');
    UniDateTitulo.SetFocus;
    Exit;
  end;}

{  if Pos('/', DateToStr(UniDateTitulo.DateTime)) = 0 then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'A data precisa ter as barras /  /');
    UniDateTitulo.SetFocus;
    Exit;
  end;}

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

  CadastroId:= ControleMainModule.GravandoTituloReceber(CondicaoPagamento_id,
                                              TituloCategoriaId,
                                              PessoaId,
                                              'C',
                                              '0', // Será substituido pelo número do título
                                              StrToDate(UniDateTitulo.Text),
                                              RoundTo(rateio,-2),
                                              0,
                                              UniMemoObs.Text,
                                              Periodo,
                                              StrToInt(UniComboBoxQuantParc.Text),
                                              UniEditNumeroReferencia.Text);
  if CadastroId <> 0 then
  begin
    BotaoSalvar.ModalResult := mrOk;
    SweetAlertSucesso.Text := 'O título: '+ IntToStr(CadastroId)+' foi incluído com sucesso!';
    SweetAlertSucesso.show;

    if PedidoIntegracao = True then
    begin
      if stringTituloParcelaSeparado[0] <> null then
      begin
        AtualizaStatusReceberFirebird(stringTituloParcelaSeparado[0],
                                      stringTituloParcelaSeparado[1]);
      end;
    end;

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

procedure TControleOperacoesCriarTituloReceber.UniDateTituloEnter(
  Sender: TObject);
begin
  inherited;
  UniDateTitulo.SelectAll;
end;

procedure TControleOperacoesCriarTituloReceber.UniDateTituloKeyPress(
  Sender: TObject; var Key: Char);
begin
  inherited;
  if Key = #13 then
    UniEditNumeroReferencia.SetFocus;
end;

procedure TControleOperacoesCriarTituloReceber.UniDBComboBoxCategoriaChange(
  Sender: TObject);
begin
  inherited;
  CdsTituloCategoria.Locate('DESCRICAO',UniDBComboBoxCategoria.Text,[]);
  TituloCategoriaId := CdsTituloCategoriaID.AsInteger;
end;

procedure TControleOperacoesCriarTituloReceber.UniDBComboBoxCategoriaKeyPress(
  Sender: TObject; var Key: Char);
begin
  inherited;
  if Key = #13 then
  begin
    UniDBComboBoxCategoria.ItemIndex := 0;
    CdsTituloCategoria.Locate('DESCRICAO',UniDBComboBoxCategoria.Text,[]);
    TituloCategoriaId := CdsTituloCategoriaID.AsInteger;

    UniDateTitulo.SetFocus;
  end;
end;

procedure TControleOperacoesCriarTituloReceber.UniDBComboBoxCondicaoPagamentoChange(
  Sender: TObject);
begin
  CdsCondicoesPagamento.Locate('DESCRICAO',UniDBComboBoxCondicaoPagamento.Text,[]);
  CondicaoPagamento_id := CdsCondicoesPagamentoID.AsInteger;

  if CdsCondicoesPagamentoGERA_CARNE.AsString = 'S' then
    UniDateTitulo.Text :=  DateToStr(IncMonth(Date,1));
end;

procedure TControleOperacoesCriarTituloReceber.UniDBComboBoxCondicaoPagamentoKeyPress(
  Sender: TObject; var Key: Char);
begin
  inherited;
  if Key = #13 then
  begin
    UniDBComboBoxCondicaoPagamento.ItemIndex := 0;
    CdsCondicoesPagamento.Locate('DESCRICAO',UniDBComboBoxCondicaoPagamento.Text,[]);
    CondicaoPagamento_id := CdsCondicoesPagamentoID.AsInteger;

    UniDBComboBoxCategoria.SetFocus;
  end;
end;

procedure TControleOperacoesCriarTituloReceber.UniEditNumeroReferenciaKeyPress(
  Sender: TObject; var Key: Char);
begin
  inherited;
  if Key = #13 then
  begin
    UniFormattedNumberValor.SetFocus;
    if UniEditNumeroReferencia.Text <> '' then
      UniSpeedButtonPesquisaNFCe.Click;
  end;
end;

procedure TControleOperacoesCriarTituloReceber.UniEditResponsavelTituloKeyPress(
  Sender: TObject; var Key: Char);
begin
  inherited;
 if StrToIntDef(UniEditResponsavelTitulo.Text,0) <> 0 then
  begin
    if Key = #13 then
    begin
      if ProcuraPessoa( StrToIntDef(UniEditResponsavelTitulo.Text,0) ) then
      begin
        if Cliente.id <> 0 then
        begin
          PessoaId := Cliente.id;
          UniEditResponsavelTitulo.Text := Cliente.nome;
          UniDBComboBoxCondicaoPagamento.SetFocus;
        end;
      end
      else
      begin
        UniEditResponsavelTitulo.Text := '';
        UniEditResponsavelTitulo.SetFocus;
      end;
    end;
  end
  else
  begin
    UniEditResponsavelTitulo.Text := '';
    PessoaId := 0;
  end;
end;

procedure TControleOperacoesCriarTituloReceber.UniFormattedNumberValorEnter(
  Sender: TObject);
begin
  inherited;
  UniFormattedNumberValor.SelectAll;
end;

procedure TControleOperacoesCriarTituloReceber.UniFormattedNumberValorKeyPress(
  Sender: TObject; var Key: Char);
begin
  inherited;
  if Key = #13 then
    UniMemoObs.SetFocus;
end;

procedure TControleOperacoesCriarTituloReceber.UniFormShow(Sender: TObject);
begin
  inherited;
  UniDateTitulo.Text := DateToStr(Date());
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
begin
  if Pos('-', UniEditNumeroReferencia.Text) > 0 then
    ImportaPedidoFirebird(UniEditNumeroReferencia.Text)
  else
    ImportaPedidoPDVe(UniEditNumeroReferencia.Text);
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

function TControleOperacoesCriarTituloReceber.ProcuraPessoa(ClienteId: Integer): Boolean;
begin
  Result := False;

  // Carregando as permissões do usuário
  with ControleMainModule do
  begin
    CdsAx4.Close;
    QryAx4.SQL.Clear;
    QryAx4.Parameters.Clear;
    QryAx4.SQL.Text :=
                     '	SELECT                                                                      '
                    +'		cli.id,                                                                 '
                    +'		DECODE(cli.ativo, ''S'', ''SIM'', ''NÃO'') ativo,                             '
                    +'		DECODE(pes.tipo, ''F'', ''FÍSICA'', ''J'', ''JURÍDICA'') tipo,                  '
                    +'		(                                                                       '
                    +'		SELECT                                                                  '
                    +'			formata_cpf_cnpj(pes.cpf_cnpj)                                      '
                    +'		FROM                                                                    '
                    +'			dual) cpf_cnpj,                                                     '
                    +'		UPPER(pes.razao_social) razao_social,                                   '
                    +'		UPPER(pes.nome_fantasia) nome_fantasia,                                 '
                    +'		pes.data_nascimento,                                                    '
                    +'		pes.rg_insc_estadual,                                                   '
                    +'		DECODE(pes.codigo_regime_tributario,                                    '
                    +'	                       ''1'', ''1 – SIMPLES NACIONAL'',                         '
                    +'	                       ''3'', ''3 – REGIME NORMAL'') codigo_regime_tributario   '
                    +'	FROM                                                                        '
                    +'		cliente cli                                                          '
                    +'	INNER JOIN pessoa pes                                                       '
                    +'	           ON                                                               '
                    +'		pes.id = cli.id                                                         '
                    +'	WHERE                                                                       '
                    +'		cli.id = :cliente_id';

    QryAx4.Parameters.ParamByName('cliente_id').Value := ClienteId;
    CdsAx4.Open;

    if CdsAx4.RecordCount >0 then
    begin
      Cliente.id       :=  CdsAx4.FieldByName('id').AsInteger;
      Cliente.CpfCnpj  :=  CdsAx4.FieldByName('cpf_cnpj').AsString;
      Cliente.nome     :=  CdsAx4.FieldByName('razao_social').AsString;
      Result := True;
    end
    else
    begin
      Cliente.id  := 0;
    end;
  end;
end;

procedure TControleOperacoesCriarTituloReceber.SweetAlertSucessoConfirm(
  Sender: TObject);
begin
  inherited;
  UniSweetAlertRepeteOperacao.show;
end;

function TControleOperacoesCriarTituloReceber.SelecionaTituloNumeroReferencia(numero_referencia: string): Boolean;
begin
  Result := False;
  // Verificando se o título já foi importado
  with ControleMainModule do
  begin
    CdsAx1.Close;
    QryAx1.SQL.Clear;
    QryAx1.Parameters.Clear;
    QryAx1.SQL.Text := 'SELECT id'
                      +'  FROM titulo'
                      +' WHERE numero_referencia = '''+ UniEditNumeroReferencia.Text +'''';
    Try
      CdsAx1.Open;
      if CdsAx1.RecordCount > 0 then
        Result := True;
    except
      on e:Exception do
      begin
        ControleMainModule.MensageiroSweetAlerta('Atenção', e.Message);
      end;
    End;
  end;
end;

procedure TControleOperacoesCriarTituloReceber.ImportaPedidoPDVe(NumeroPedido: String);
var
  CdsCabecalhoPedido, CdsCliente: TClientDataSet;
  cnpj_cpf, EnderecoId: string;
begin
  if NumeroPedido = '' then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar o número do pedido para importar os dados.');
    Exit;
  end;

  if SelecionaTituloNumeroReferencia(Trim(NumeroPedido)) then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção','O título já foi importado!');
    Exit;
  end;

  if ControleMainModule.FSchemaPdve = '' then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção','O Schema do Pdv-e não foi configurado no config.ini!');
    Exit;
  end;

  // Criando ClientDataset em tempo de execução
  CdsCabecalhoPedido := TClientDataSet.Create(UniApplication);

  // Atribuindo o retorno da função ao clientdataset criado anteriormente
  Try
    CdsCabecalhoPedido := ControleMainModule.SelecioPedidoCabecalhoGestor(StrToInt(NumeroPedido));
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
      cnpj_cpf := CdsCabecalhoPedido.FieldByName('cpf_cnpj').AsString;
      EnderecoId := CdsCabecalhoPedido.FieldByName('cliente_id').AsString;

      // Verificando se o cpf/cnpj está cadastrado no banco do controle
      CdsCliente := TClientDataSet.Create(UniApplication);
      CdsCliente := ControleMainModule.SelecionaCliente(CdsCabecalhoPedido.FieldByName('cpf_cnpj').AsString);

      if CdsCliente.RecordCount > 0 {Encontrou o cliente} then
      begin
        PessoaId := CdsCliente.FieldByName('id').AsInteger;
        UniEditResponsavelTitulo.Text := CdsCliente.FieldByName('razao_social').AsString;
      end
      else
      begin
        // se o cliente existir no gestor então importa o mesmo
        if ControleMainModule.SelecionaClienteGestor(cnpj_cpf) then
        begin
          if ControleMainModule.CadastraCliente(cnpj_cpf, EnderecoId) then
          begin
            CdsCliente := ControleMainModule.SelecionaCliente(cnpj_cpf);
            PessoaId := CdsCliente.FieldByName('id').AsInteger;
            UniEditResponsavelTitulo.Text := CdsCliente.FieldByName('razao_social').AsString;
          end;
        end;
      end;
    end;
  end
  else
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar o número do pedido para importar os dados.');
end;

procedure TControleOperacoesCriarTituloReceber.ImportaPedidoFirebird(NumeroPedido: String);
var
  FDQretorno: TFDQuery;
  vcnpjcpf: string;
begin
  inherited;

  PedidoIntegracao := False;

  stringTituloParcelaSeparado := separaTituloParcela(NumeroPedido);

  if NumeroPedido = '' then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar o número do pedido para importar os dados.');
    Exit;
  end;

  if SelecionaStatusReceberFirebird(stringTituloParcelaSeparado[0],
                                    stringTituloParcelaSeparado[1]) then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção','O título/parcela já foi importado!');
    Exit;
  end;

  // Seleciona os dados da titulo e parcela
  FDQretorno := SelecionaTituloFirebird(NumeroPedido);

  if FDQretorno.RecordCount = 0 then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção','Pedido não encontrado!');
    Exit;
  end;

  // Verificando se o cliente tem o cpf valido, caso nao esteja abre um modal pra ele dizer qual é
  if ControleFuncoes.ValidaCPF(Trim(ControleFuncoes.RemoveMascara(Trim(FDQretorno.FieldByName('cnpjcpf').AsString)))) = False then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção','Esse cliente não possui CPF, por favor, faça o cadastro manualmente');
    Abort;
  end
  else
  begin
    vcnpjcpf := ControleFuncoes.RemoveMascara(Trim(FDQretorno.FieldByName('cnpjcpf').AsString));
    ProcessaTitulo(vcnpjcpf,
                   FDQretorno,
                   NumeroPedido);
  end;
end;


procedure TControleOperacoesCriarTituloReceber.ProcessaTitulo(cpf_cnpj: string;
                                                              FDQ: TFDQuery;
                                                              nPed: string);
var
  Texto, TextoFormatado: string;
  i: Integer;
  CdsCliente: TClientDataSet;
begin
  // Verificando se o cpf/cnpj está cadastrado no banco do controle
  CdsCliente := TClientDataSet.Create(UniApplication);
  CdsCliente := ControleMainModule.SelecionaCliente(cpf_cnpj);

  if CdsCliente.RecordCount = 0 {Encontrou o cliente} then
  begin
    // se o cliente existir no gestor então importa o mesmo
    if ControleMainModule.CadastraClienteDoFirebird(FDQ) then
    begin
      CdsCliente := ControleMainModule.SelecionaCliente(cpf_cnpj);
    end;
  end;

  ControleMainModule.cnpj_cpf_cliente_integracao := ControleFuncoes.RemoveMascara(cpf_cnpj);

  // Enviando os dados para a tela de calculo
  ControleOperacoesIntegracaoCalculoJuros.UniEdtValorOriginal.Text   := FDQ.FieldByName('original').AsString;
  if FDQ.FieldByName('vencim').AsDateTime < date then
  begin
    ControleOperacoesIntegracaoCalculoJuros.UniEdtDiasAtraso.Text      := IntToStr(DaysBetween(FDQ.FieldByName('vencim').AsDateTime,now()));
    ControleOperacoesIntegracaoCalculoJuros.UniEdtMultaAtraso.Text     := FloatToStr(ControleMainModule.percentual_multa);
  end
  else
  begin
    ControleOperacoesIntegracaoCalculoJuros.UniEdtDiasAtraso.Text      := '0';
    ControleOperacoesIntegracaoCalculoJuros.UniEdtMultaAtraso.Text     := '0';
  end;


  ControleOperacoesIntegracaoCalculoJuros.UniEdtJurosMes.Text        := FloatToStr(ControleMainModule.percentual_juros);
  ControleOperacoesIntegracaoCalculoJuros.UniDateTituloOriginal.text := FDQ.FieldByName('vencim').AsString;

  ControleOperacoesIntegracaoCalculoJuros.ShowModal(procedure(Sender: TComponent; Result: Integer)
  begin
    if Result = 1 then
    begin
      UniFormattedNumberValor.Text := ControleOperacoesIntegracaoCalculoJuros.UniEdtValorAtualizado.Text;

      PessoaId                      := CdsCliente.FieldByName('id').AsInteger;
      UniEditResponsavelTitulo.Text := CdsCliente.FieldByName('razao_social').AsString;

      UniMemoObs.Text := 'Ped. Integração nº '+ nPed;

      PedidoIntegracao := True;
    end;
  end
  );
end;

function TControleOperacoesCriarTituloReceber.SelecionaTituloFirebird(nTitulo: String): TFDQuery;
var
  titulo: integer;
  parcela: integer;
  stringTituloParcelaSeparado_2: TStringDynArray;
begin
  stringTituloParcelaSeparado_2 := separaTituloParcela(nTitulo);

  Result := nil;

  // Verifica se o pedido veio de integração
  with ControleMainModule do
  begin
    if ConectaBancoIntegracao then
    begin
      // Agora vamos montar o sql
      With FDQuery2 do
      begin
        Close;
        Params.Clear;
        SQL.Clear;
        SQL.Text :=
                      '      SELECT'
                     +'             cli.cnpjcpf,'
                     +'             cli.razaosocial,'
                     +'             cli.endereco,'
                     +'             cli.bairro,'
                     +'             cli.cnpjcpf,'
                     +'             cli.inscrg,'
                     +'             cli.estado,'
                     +'             cli.cep,'
                     +'             cli.fones,'
                     +'             cli.fax,'
                     +'             cli.celular,'
                     +'             cli.email,'
                     +'             cli.dtnasc,'
                     +'             cli.dtcad,'
                     +'             cli.obs,'
                     +'             cli.sexo,'
                     +'             cli.estciv,'
                     +'             cli.mae,'
                     +'             cli.pai,'
                     +'             rec.nome,'
                     +'             rec.original,'
                     +'             rec.vencim,'
                     +'             rec.parc,'
                     +'             rec.original,'
                     +'             rec.vencim,'
                     +'             rec.parc,'
                     +'             rec.numpedido,'
                     +'             rec.transferido'
                     +'        FROM receber rec'
                     +'        LEFT JOIN clientes cli ON'
                     +'             cli.codigo = rec.codcli'
                     +'       WHERE rec.numpedido  = '+ stringTituloParcelaSeparado_2[0] +''
                     +'         AND rec.parc = '+ stringTituloParcelaSeparado_2[1]
                     +'         AND rec.nome is not null';
//        SQL.SaveToFile('teste8.txt');
        Open;

        Result := FDQuery2;
      end;
    end;
  end;
end;

// Separando o numero do título da parcela
function TControleOperacoesCriarTituloReceber.separaTituloParcela(nTituloParcela: String): TStringDynArray;
begin
  Result := SplitString(nTituloParcela, '-');
end;

procedure TControleOperacoesCriarTituloReceber.AtualizaStatusReceberFirebird(numPedido: string; num_parcela: String);
begin
  with ControleMainModule do
  begin
    if ConectaBancoIntegracao then
    begin
      With FDQuery2 do
      begin
        SQL.Clear;
        SQL.Add('UPDATE receber');
        SQL.Add('   SET transferido = ''S''');
        SQL.Add(' WHERE numpedido = '+ numPedido +'');
        SQL.Add('   AND parc      = '+ num_parcela +'');
        ExecSQL;
      end;
    end;
  end
end;

function TControleOperacoesCriarTituloReceber.SelecionaStatusReceberFirebird(numPedido: string; num_parcela: String): Boolean;
begin
  Result := False;
  with ControleMainModule do
  begin
    if ConectaBancoIntegracao then
    begin
      With FDQuery1 do
      begin
        SQL.Clear;
        SQL.Add('SELECT numero');
        SQL.Add('  FROM receber');
        SQL.Add(' WHERE numpedido   = '+ numPedido +'');
        SQL.Add('   AND parc        = '+ num_parcela +'');
        SQL.Add('   AND transferido = ''S''');
        Open;
      end;
    end;

    if FDQuery1.RecordCount <> 0 then
      Result := True;
  end
end;

procedure TControleOperacoesCriarTituloReceber.AtualizaHistoricoTitulo(pedido_id: Integer);
begin
  with ControleMainModule do
  begin
    if ADOConnection.Intransaction = False then
      ADOConnection.BeginTrans;

    CdsAx4.Close;
    QryAx4.Parameters.Clear;
    QryAx4.SQL.Clear;
    QryAx4.SQL.Text :=
                     'UPDATE titulo'
                   + '   SET historico  = ''N'' '
                   + ' WHERE id        = :id   ';
    QryAx4.Parameters.ParamByName('id').Value := pedido_id;

    try
      // Tenta salvar os dados PASSO 4º
      QryAx4.ExecSQL;
      ADOConnection.CommitTrans;
    except
    on E: Exception do
      begin
        ADOConnection.RollbackTrans;
        ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));
      end;
     end;
  end;
end;

end.
