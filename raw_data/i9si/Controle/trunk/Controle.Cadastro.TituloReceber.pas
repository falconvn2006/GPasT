unit Controle.Cadastro.TituloReceber;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Controle.Cadastro, ACBrBase, ACBrSocket, ACBrCEP,
  Data.DB, Datasnap.DBClient, Datasnap.Provider, Data.Win.ADODB,
  uniGUIBaseClasses, uniImageList, uniBitBtn, uniSpeedButton, uniLabel,
  uniButton, uniPanel, uniEdit, uniDBEdit, uniPageControl, uniMemo,
  uniDateTimePicker, uniDBDateTimePicker, uniScreenMask,  uniDBMemo,
  uniTabControl, uniBasicGrid, uniDBGrid, uniMultiItem, uniComboBox,
  uniDBComboBox, uniDBLookupComboBox,  uniGroupBox,
  Vcl.Imaging.pngimage, uniImage,  uniCheckBox,
  uniDBCheckBox, uniSweetAlert;

type
  TControleCadastroTituloReceber = class(TControleCadastro)
    UniScreenMask1: TUniScreenMask;
    UniPageControl1: TUniPageControl;
    UniTabSheet1: TUniTabSheet;
    UniTabSheet2: TUniTabSheet;
    UniDBMemo1: TUniDBMemo;
    UniDBGrid1: TUniDBGrid;
    UniTabSheet3: TUniTabSheet;
    UniImageList3: TUniImageList;
    UniPanelClient: TUniPanel;
    LabelNomeRazao: TUniLabel;
    DBEdtNome: TUniDBEdit;
    UniLabel8: TUniLabel;
    UniLabel3: TUniLabel;
    UniDBEdit7: TUniDBEdit;
    UniDBEdit2: TUniDBEdit;
    UniLabel2: TUniLabel;
    UniDBEdit1: TUniDBEdit;
    UniLabel1: TUniLabel;
    UniDBEditParcela: TUniDBEdit;
    UniLabel19: TUniLabel;
    UniLabel7: TUniLabel;
    UniDBEdit3: TUniDBEdit;
    UniLabel5: TUniLabel;
    UniDateTitulo: TUniDBEdit;
    UniLabel6: TUniLabel;
    UniDBEditDataLiquidacao: TUniDBDateTimePicker;
    UniLabel23: TUniLabel;
    UniPanelCalculo: TUniPanel;
    DspCondicoesPagamento: TDataSetProvider;
    QryCondicoesPagamento: TADOQuery;
    CdsCondicoesPagamento: TClientDataSet;
    CdsCondicoesPagamentoID: TFloatField;
    CdsCondicoesPagamentoDESCRICAO: TWideStringField;
    CdsCondicoesPagamentoTIPO: TWideStringField;
    CdsCondicoesPagamentoORDEM_EXIBICAO: TFloatField;
    CdsCondicoesPagamentoGERA_CARNE: TWideStringField;
    CdsCondicoesPagamentoGERA_BOLETO: TWideStringField;
    CdsCondicoesPagamentoGERA_CHEQUE: TWideStringField;
    DscCondicoesPagamento: TDataSource;
    QryCadastroID: TFloatField;
    QryCadastroCLIENTE_ID: TFloatField;
    QryCadastroCONDICOES_PAGAMENTO_ID: TFloatField;
    QryCadastroNUMERO_DOCUMENTO: TWideStringField;
    QryCadastroSEQUENCIA_PARCELAS: TFloatField;
    QryCadastroNATUREZA: TWideStringField;
    QryCadastroDATA_EMISSAO: TDateTimeField;
    QryCadastroDATA_VENCIMENTO: TDateTimeField;
    QryCadastroDATA_VENC_ORIGINAL: TDateTimeField;
    QryCadastroVALOR: TFloatField;
    QryCadastroDIAS_ATRASO: TFloatField;
    QryCadastroSITUACAO: TWideStringField;
    QryCadastroVENCIDO: TWideStringField;
    QryCadastroDATA_LIQUIDACAO: TDateTimeField;
    QryCadastroVALOR_PAGO: TFloatField;
    QryCadastroVALOR_SALDO: TFloatField;
    QryCadastroHISTORICO: TWideStringField;
    QryCadastroCLIENTE: TWideStringField;
    QryCadastroCPF_CNPJ: TWideStringField;
    QryCadastroDESCRICAO_CONDICOES_PAGAMENTO: TWideStringField;
    QryCadastroCONTA_BANCARIA_ID: TFloatField;
    QryCadastroNUMERO_CARNE: TWideStringField;
    QryCadastroGERA_BOLETO: TWideStringField;
    QryCadastroGERA_CARNE: TWideStringField;
    QryCadastroGERA_CHEQUE: TWideStringField;
    QryCadastroOPCOES: TFloatField;
    QryCadastroPOSSUI_ANEXO: TWideStringField;
    QryCadastroNUMERO_REFERENCIA: TWideStringField;
    QryCadastroCELULAR: TWideStringField;
    QryCadastroVALOR_DESCONTO: TFloatField;
    QryCadastroVALOR_MULTA: TFloatField;
    QryCadastroVALOR_JUROS: TFloatField;
    QryCadastroCALCULA_JUROS: TWideStringField;
    QryCadastroCALCULA_MULTA: TWideStringField;
    QryCadastroCATEGORIA: TWideStringField;
    QryCadastroNEGOCIADO: TWideStringField;
    CdsCadastroID: TFloatField;
    CdsCadastroCLIENTE_ID: TFloatField;
    CdsCadastroCONDICOES_PAGAMENTO_ID: TFloatField;
    CdsCadastroNUMERO_DOCUMENTO: TWideStringField;
    CdsCadastroSEQUENCIA_PARCELAS: TFloatField;
    CdsCadastroNATUREZA: TWideStringField;
    CdsCadastroDATA_EMISSAO: TDateTimeField;
    CdsCadastroDATA_VENCIMENTO: TDateTimeField;
    CdsCadastroDATA_VENC_ORIGINAL: TDateTimeField;
    CdsCadastroVALOR: TFloatField;
    CdsCadastroDIAS_ATRASO: TFloatField;
    CdsCadastroSITUACAO: TWideStringField;
    CdsCadastroVENCIDO: TWideStringField;
    CdsCadastroDATA_LIQUIDACAO: TDateTimeField;
    CdsCadastroVALOR_PAGO: TFloatField;
    CdsCadastroVALOR_SALDO: TFloatField;
    CdsCadastroHISTORICO: TWideStringField;
    CdsCadastroCLIENTE: TWideStringField;
    CdsCadastroCPF_CNPJ: TWideStringField;
    CdsCadastroDESCRICAO_CONDICOES_PAGAMENTO: TWideStringField;
    CdsCadastroCONTA_BANCARIA_ID: TFloatField;
    CdsCadastroNUMERO_CARNE: TWideStringField;
    CdsCadastroGERA_BOLETO: TWideStringField;
    CdsCadastroGERA_CARNE: TWideStringField;
    CdsCadastroGERA_CHEQUE: TWideStringField;
    CdsCadastroOPCOES: TFloatField;
    CdsCadastroPOSSUI_ANEXO: TWideStringField;
    CdsCadastroNUMERO_REFERENCIA: TWideStringField;
    CdsCadastroCELULAR: TWideStringField;
    CdsCadastroVALOR_DESCONTO: TFloatField;
    CdsCadastroVALOR_MULTA: TFloatField;
    CdsCadastroVALOR_JUROS: TFloatField;
    CdsCadastroCALCULA_JUROS: TWideStringField;
    CdsCadastroCALCULA_MULTA: TWideStringField;
    CdsCadastroCATEGORIA: TWideStringField;
    CdsCadastroNEGOCIADO: TWideStringField;
    QryCadastroTITULO_CATEGORIA_ID: TFloatField;
    CdsCadastroTITULO_CATEGORIA_ID: TFloatField;
    DspTituloPagamentos: TDataSetProvider;
    DscTituloPagamentos: TDataSource;
    CdsTituloPagamentos: TClientDataSet;
    QryTituloPagamentos: TADOQuery;
    CdsTituloPagamentosID: TFloatField;
    CdsTituloPagamentosTITULO_ID: TFloatField;
    CdsTituloPagamentosCONDICOES_PAGAMENTO_ID: TFloatField;
    CdsTituloPagamentosDESCRICAO: TWideStringField;
    CdsTituloPagamentosVALOR_PAGO: TFloatField;
    QryTituloCategoria: TADOQuery;
    CdsTituloCategoria: TClientDataSet;
    CdsTituloCategoriaID: TFloatField;
    CdsTituloCategoriaDESCRICAO: TWideStringField;
    CdsTituloCategoriaTIPO_TITULO: TWideStringField;
    DspTituloCategoria: TDataSetProvider;
    DscTituloCategoria: TDataSource;
    UniDBLookupComboBoxCategoria: TUniDBLookupComboBox;
    UniPanel9: TUniPanel;
    UniPanel4: TUniPanel;
    UniPanel14: TUniPanel;
    UniImage5: TUniImage;
    UniPanel3: TUniPanel;
    UniPanel16: TUniPanel;
    UniPanel17: TUniPanel;
    UniImage4: TUniImage;
    LabelMultaPrevista: TUniLabel;
    UniLabel10: TUniLabel;
    UniPanel5: TUniPanel;
    UniPanel18: TUniPanel;
    UniPanel19: TUniPanel;
    UniImage1: TUniImage;
    UniLabel15: TUniLabel;
    LabelValorJurosPrevisto: TUniLabel;
    UniPanel12: TUniPanel;
    UniPanel11: TUniPanel;
    UniPanel22: TUniPanel;
    UniPanel23: TUniPanel;
    UniPanel7: TUniPanel;
    UniPanel25: TUniPanel;
    UniPanel26: TUniPanel;
    UniPanel27: TUniPanel;
    UniPanel28: TUniPanel;
    UniImage8: TUniImage;
    UniPanel29: TUniPanel;
    UniLabel14: TUniLabel;
    LabelSaldo: TUniLabel;
    UniImage3: TUniImage;
    UniLabelRecebimento: TUniLabel;
    LabelValorOriginal: TUniLabel;
    UniImage2: TUniImage;
    UniLabel17: TUniLabel;
    LabelValorAtualizado: TUniLabel;
    UniPanel13: TUniPanel;
    UniLabel4: TUniLabel;
    LabelDiasAtraso: TUniLabel;
    UniPanel8: TUniPanel;
    UniPanel10: TUniPanel;
    UniImage6: TUniImage;
    UniPanel15: TUniPanel;
    UniLabel9: TUniLabel;
    LabelDesconto: TUniLabel;
    UniPanel20: TUniPanel;
    UniPanel24: TUniPanel;
    UniImage7: TUniImage;
    UniPanel30: TUniPanel;
    UniLabel11: TUniLabel;
    LabelPago: TUniLabel;
    CdsTituloPagamentosDATA: TDateTimeField;
    UniDBLookupComboBoxCondicaoPagamento: TUniDBLookupComboBox;
    procedure UniFormCreate(Sender: TObject);
    procedure UniFormShow(Sender: TObject);

  private
    TituloCategoriaId : Integer;
    vTotal : Double;
    procedure ExecutaCalculo;

    { Private declarations }
  public
    { Public declarations }
    GeraBoleto : String;
    /// Código da finalidade do arquivo - TRegistro0000
    function Abrir(Id: Integer): Boolean; override;
    function Novo(): Boolean; override;
    function Editar(Id: Integer): Boolean; override;
    function Salvar: Boolean; override;
    function Descartar: Boolean; override;
  end;

function ControleCadastroTituloReceber: TControleCadastroTituloReceber;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication, Controle.Consulta.TituloReceber,
  System.Math, Controle.Funcoes, Controle.Cadastro.BaixarTituloReceber,
  Controle.Consulta.Modal.TituloCategoria.Receber;

function ControleCadastroTituloReceber: TControleCadastroTituloReceber;
begin
  Result := TControleCadastroTituloReceber(ControleMainModule.GetFormInstance(TControleCadastroTituloReceber));
end;

{ TControleCadastroTituloReceber }

function TControleCadastroTituloReceber.Abrir(Id: Integer): Boolean;
begin
  Result := False;

  // Abre o registro
  CdsCadastro.Close;
  QryCadastro.Parameters.ParamByName('id').Value := Id;
  CdsCadastro.Open;

  // Se algum registro foi solicitado, deve parar se não encontrar
  if (Id > 0) and CdsCadastro.IsEmpty then
    Exit;

  // Bloqueia o registro para edição
  DscCadastro.AutoEdit := False;

  //Abre as formas que o título foi pago.
  CdsTituloPagamentos.Close;
  QryTituloPagamentos.Parameters.ParamByName('TITULO_ID').Value := Id;
  CdsTituloPagamentos.Open;

  if CdsTituloPagamentos.RecordCount >0 then
    UniPageControl1.Pages[1].Visible := True
  else
    UniPageControl1.Pages[1].Visible := False;

  ExecutaCalculo;

  Result := True;
end;

function TControleCadastroTituloReceber.Descartar: Boolean;
var
  Fechar: Boolean;
begin
  inherited;

  Fechar := False;

  // Se o formulário foi aberto para inclusão, deve ser fechado ao
  // clicar em Descartar.
  if CdsCadastro.IsEmpty or (CdsCadastro.FieldByName('id').AsInteger = 0) then
    Fechar := True;

  // Descartar a alterações
  CdsCadastro.Cancel;

  if Fechar then
    // Fecha o cadastro
    Close;

  Result := True;
end;


function TControleCadastroTituloReceber.Editar(Id: Integer): Boolean;
begin
  Result := False;

  // Pega o id do registro aberto se não tiver sido passado
  // como parâmtro
  if Id = 0 then
    Id := CdsCadastro.FieldByName('id').AsInteger;

  // Tenta abrir o registro
  if Abrir(Id) then
  begin
    // Libera o registro para edição
    CdsCadastro.Edit;
  end;

  Result := True;
end;

function TControleCadastroTituloReceber.Novo(): Boolean;
begin
  // nao existe nesse form
  Result := False;
end;

function TControleCadastroTituloReceber.Salvar: Boolean;
begin
  with ControleMainModule do
  begin
    if CdsCadastro.State in [dsInsert, dsEdit] then
    begin
      // Inicia a transação
      ADOConnection.BeginTrans;

      // Passo Unico - Salva os dados da cidade
      QryAx3.Parameters.Clear;
      QryAx3.SQL.Clear;

      // Update
      QryAx3.SQL.Add('UPDATE titulo SET');
      QryAx3.SQL.Add('       historico           = :historico,');
      QryAx3.SQL.Add('       numero_referencia   = :numero_referencia,');
      QryAx3.SQL.Add('       condicoes_pagamento_id   = :condicoes_pagamento_id,');
      QryAx3.SQL.Add('       titulo_categoria_id = :categoria_id');
      QryAx3.SQL.Add(' WHERE id                  = :id');

      QryAx3.Parameters.ParamByName('id').Value           := CdsCadastroID.AsInteger;
      QryAx3.Parameters.ParamByName('historico').Value    := CdsCadastroHISTORICO.AsString;
      QryAx3.Parameters.ParamByName('numero_referencia').Value    := CdsCadastroNUMERO_REFERENCIA.AsString;
      QryAx3.Parameters.ParamByName('categoria_id').Value := CdsTituloCategoriaID.AsInteger;
      QryAx3.Parameters.ParamByName('condicoes_pagamento_id').Value := CdsCadastroCONDICOES_PAGAMENTO_ID.AsInteger;

      CdsCadastro.Post;
    end;

    try
      // Tenta salvar os dados
      QryAx3.ExecSQL;
      // Confirma a transação
      ADOConnection.CommitTrans;
    except
      on E: Exception do
      begin
        // Descarta a transação
        ADOConnection.RollbackTrans;
        ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));
      end;
    end;
  end;
end;

procedure TControleCadastroTituloReceber.UniFormCreate(Sender: TObject);
begin
  inherited;
  CdsTituloCategoria.Close;
  CdsTituloCategoria.Open;

  CdsCondicoesPagamento.Close;
  CdsCondicoesPagamento.Open;
end;

procedure TControleCadastroTituloReceber.UniFormShow(Sender: TObject);
begin
  inherited;
  if CdsCadastroSITUACAO.AsString = 'LIQUIDADO' then
    UniDBLookupComboBoxCondicaoPagamento.ReadOnly := True;
end;

procedure TControleCadastroTituloReceber.ExecutaCalculo;
var
  Calcula : TCalJurosMulta;
begin
  Calcula := ControleMainModule.CalculaJurosMulta(UniDBEditDataLiquidacao.DateTime,
                                                  CdsCadastroVALOR.AsFloat,
                                                  ControleMainModule.percentual_juros,
                                                  ControleMainModule.percentual_multa,
                                                  CdsCadastroDIAS_ATRASO.AsInteger,
                                                  0);

  LabelDiasAtraso.Caption         := CdsCadastroDIAS_ATRASO.AsString;
  LabelValorOriginal.Caption      := formatfloat('R$ #,##0.00', CdsCadastroVALOR.AsFloat);
  LabelMultaPrevista.Caption      := formatfloat('R$ #,##0.00', Calcula.ValorMulta);
  LabelValorJurosPrevisto.Caption := formatfloat('R$ #,##0.00', Calcula.ValorJuros);
  LabelValorAtualizado.Caption    := formatfloat('R$ #,##0.00', Calcula.ValorAtualizado);
  LabelSaldo.Caption              := formatfloat('R$ #,##0.00', CdsCadastroVALOR_SALDO.AsFloat);
  LabelDesconto.Caption           := formatfloat('R$ #,##0.00', CdsCadastroVALOR_DESCONTO.AsFloat);
  LabelPago.Caption               := formatfloat('R$ #,##0.00', CdsCadastroVALOR_PAGO.AsFloat);
end;

end.
