unit Controle.Operacoes.CriarTituloPagar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Controle.Operacoes,  Data.Win.ADODB,
  Datasnap.Provider, Data.DB, Datasnap.DBClient, uniGUIBaseClasses,
  uniImageList, uniBitBtn, uniSpeedButton, uniLabel, uniButton, uniPanel,
  uniMultiItem, uniComboBox, uniMemo, uniEdit, uniCheckBox, uniDateTimePicker,
  uniSweetAlert, uniDBComboBox, uniDBLookupComboBox;

type
  TControleOperacoesCriarTituloPagar = class(TControleOperacoes)
    UniPanel5: TUniPanel;
    UniLabel1: TUniLabel;
    UniEditResponsavelTitulo: TUniEdit;
    UniLabel3: TUniLabel;
    UniSpeedButton2: TUniSpeedButton;
    UniPanel8: TUniPanel;
    UniLabel2: TUniLabel;
    UniDateTitulo: TUniDateTimePicker;
    UniLabel4: TUniLabel;
    UniCheckBoxRepetir: TUniCheckBox;
    UniFormattedNumberValor: TUniFormattedNumberEdit;
    UniPanel7: TUniPanel;
    UniMemoObs: TUniMemo;
    UniPanel9: TUniPanel;
    UniPanel10: TUniPanel;
    UniLabel7: TUniLabel;
    UniLabel10: TUniLabel;
    UniEditNumeroReferencia: TUniEdit;
    UniLabel11: TUniLabel;
    UniSweetCriarTitOutroFornecedor: TUniSweetAlert;
    UniPanelPeriodo: TUniPanel;
    UniLabel5: TUniLabel;
    UniComboBoxQuantParc: TUniComboBox;
    UniLabel6: TUniLabel;
    UniComboBoxPeriodo: TUniComboBox;
    UniPanel6: TUniPanel;
    QryCondicoesPagamento: TADOQuery;
    QryCondicoesPagamentoID: TFloatField;
    QryCondicoesPagamentoDESCRICAO: TWideStringField;
    QryTituloCategoria: TADOQuery;
    FloatField2: TFloatField;
    WideStringField2: TWideStringField;
    DscTituloCategoria: TDataSource;
    DscCondicoesPagamento: TDataSource;
    CdsCondicoesPagamento: TClientDataSet;
    CdsCondicoesPagamentoID: TFloatField;
    CdsCondicoesPagamentoDESCRICAO: TWideStringField;
    CdsTituloCategoria: TClientDataSet;
    CdsTituloCategoriaID: TFloatField;
    CdsTituloCategoriaDESCRICAO: TWideStringField;
    DspTituloCategoria: TDataSetProvider;
    DspCondicoesPagamento: TDataSetProvider;
    ComboBoxCategoria: TUniComboBox;
    ComboBoxCondPagamento: TUniComboBox;
    procedure BotaoSalvarClick(Sender: TObject);
    procedure UniSpeedButton2Click(Sender: TObject);
    procedure UniCheckBoxRepetirClick(Sender: TObject);
    procedure UniFormShow(Sender: TObject);
    procedure UniSweetCriarTitOutroFornecedorConfirm(Sender: TObject);
    procedure UniSweetCriarTitOutroFornecedorDismiss(Sender: TObject;
      const Reason: TDismissType);
    procedure ComboBoxCondPagamentoChange(Sender: TObject);
    procedure ComboBoxCategoriaChange(Sender: TObject);
  private
    CondicoesPagamentoId : Integer;
    TituloCategoriaId : Integer;
    PessoaId: Integer;
    //GeraBoleto: Boolean;
    NumeroDocumentoTituloPagar : String;
    DiaPadrao: Word;

    procedure GerarTitulos;
    function RetornaDataProximoTitulo(DataVenc: TDateTime): TDateTime;
    procedure PreencheFiltros;

    { Private declarations }
  public
    { Public declarations }
    PrimeiraDataDoCarne: TDateTime;
  end;

function ControleOperacoesCriarTituloPagar: TControleOperacoesCriarTituloPagar;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication, Controle.Consulta.Modal.TipoTitulo,
  Controle.Consulta.Modal.Pessoa.TituloPagar,
   Controle.Main, Controle.Funcoes,
   Controle.Consulta.Modal.TituloCategoria.Pagar;

function ControleOperacoesCriarTituloPagar: TControleOperacoesCriarTituloPagar;
begin
  Result := TControleOperacoesCriarTituloPagar(ControleMainModule.GetFormInstance(TControleOperacoesCriarTituloPagar));
end;

procedure TControleOperacoesCriarTituloPagar.BotaoSalvarClick(Sender: TObject);
begin
  inherited;
  GerarTitulos;
end;

procedure TControleOperacoesCriarTituloPagar.ComboBoxCategoriaChange(
  Sender: TObject);
begin
  inherited;
  CdsTituloCategoria.Locate('DESCRICAO',ComboBoxCategoria.Text,[]);
  TituloCategoriaId := CdsTituloCategoriaID.AsInteger;
end;

procedure TControleOperacoesCriarTituloPagar.ComboBoxCondPagamentoChange(
  Sender: TObject);
begin
  inherited;
  CdsCondicoesPagamento.Locate('DESCRICAO',ComboBoxCondPagamento.Text,[]);
  CondicoesPagamentoId := CdsCondicoesPagamentoID.AsInteger;
end;

Procedure TControleOperacoesCriarTituloPagar.GerarTitulos();
var
  CadastroId, I: Integer;
  Periodo,Parcelas: Integer;
  Valor: String;
  ValorCur : currency;
begin
  inherited;

  if Trim(UniEditResponsavelTitulo.Text) = '' then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar o responsável financeiro da cobrança.');
    UniEditResponsavelTitulo.SetFocus;
    Exit;
  end;

  if Trim(ComboBoxCondPagamento.Text) = '' then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar a forma de cobrança.');
    ComboBoxCondPagamento.SetFocus;
    Exit;
  end;

  if Trim(ComboBoxCategoria.Text) = '' then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário escolher uma categoria.');
    ComboBoxCategoria.SetFocus;
    Exit;
  end;

  if UniFormattedNumberValor.Value = 0 then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar o valor da cobrança.');
    UniFormattedNumberValor.SetFocus;
    Exit;
  end;

  if UniCheckBoxRepetir.Checked = True then
  begin
    if UniComboBoxQuantParc.ItemIndex = -1 then
    begin
      ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar a quantidade de parcelas para gerar a cobrança.');
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

  if ControleMainModule.GravandoTituloPagar(CondicoesPagamentoId,
                                              TituloCategoriaId,
                                              PessoaId,
                                              'D',
                                              '0', // Será substituido pelo número do título
                                              UniDateTitulo.DateTime,
                                              UniFormattedNumberValor.Value,
                                              0,
                                              UniMemoObs.Text,
                                              Periodo,
                                              StrToInt(UniComboBoxQuantParc.Text),
                                              UniEditNumeroReferencia.Text) then
  begin
    UniSweetCriarTitOutroFornecedor.Show;
  end;
end;

Function TControleOperacoesCriarTituloPagar.RetornaDataProximoTitulo(DataVenc: TDateTime): TDateTime;
var
  Periodo: Integer;
  DiaBase: Integer;
  NovoMes: Integer;
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
     ControleMainModule.MensageiroSweetAlerta('Atenção: ', ControleFuncoes.RetiraAspaSimples(E.Message));
  End;
end;

procedure TControleOperacoesCriarTituloPagar.UniCheckBoxRepetirClick(
  Sender: TObject);
begin
  inherited;

  if UniCheckBoxRepetir.Checked = True then
  begin
    UniPanelPeriodo.Visible := True;
    Height := 450;
  end
  else
  begin
    UniPanelPeriodo.Visible := False;
    Height := 380;
  end;

end;

procedure TControleOperacoesCriarTituloPagar.UniFormShow(Sender: TObject);
begin
  inherited;
  UniDateTitulo.DateTime := Date();
  UniPanelPeriodo.Visible := False;
  Height := 380;
  PreencheFiltros;
end;

procedure TControleOperacoesCriarTituloPagar.UniSpeedButton2Click(
  Sender: TObject);
begin
  inherited;

  PessoaId := 0;

  // Define o filtro fixo para a pesquisa (Tipo de Pessoa = F, J ou FJ)
  ControleConsultaModalPessoaTituloPagar.QryConsulta.Parameters.ParamByName('tipo').Value := 'FJ';

  // Abre o formulário em modal e aguarda
  ControleConsultaModalPessoaTituloPagar.ShowModal(procedure(Sender: TComponent; Result: Integer)
  begin
{    if Result = 1 then
    begin}
      // Pega o id da pessoa selecionada
      PessoaId := ControleConsultaModalPessoaTituloPagar.CdsConsulta.FieldByName('id').AsInteger;
      UniEditResponsavelTitulo.Text := ControleConsultaModalPessoaTituloPagar.CdsConsulta.FieldByName('nome_fantasia').AsString;
//    end;
  end);
end;

procedure TControleOperacoesCriarTituloPagar.UniSweetCriarTitOutroFornecedorConfirm(
  Sender: TObject);
begin
  inherited;
  UniEditResponsavelTitulo.Text := '';
  PessoaId := 0;
end;

procedure TControleOperacoesCriarTituloPagar.UniSweetCriarTitOutroFornecedorDismiss(
  Sender: TObject; const Reason: TDismissType);
begin
  inherited;
  Close;
end;

procedure TControleOperacoesCriarTituloPagar.PreencheFiltros;
begin
  //preenche combo com as condições de COBRANÇA
  With ComboBoxCondPagamento do
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
  With ComboBoxCategoria do
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
