unit Controle.Cadastro.TituloPagar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Controle.Cadastro, ACBrBase, ACBrSocket, ACBrCEP,
  Data.DB, Datasnap.DBClient, Datasnap.Provider, Data.Win.ADODB,
  uniGUIBaseClasses, uniImageList, uniBitBtn, uniSpeedButton, uniLabel,
  uniButton, uniPanel, uniMemo, uniDBMemo, uniDateTimePicker,
  uniDBDateTimePicker, uniEdit, uniDBEdit,  uniMultiItem, uniComboBox,
  uniDBComboBox, uniDBLookupComboBox, uniSweetAlert, Vcl.Imaging.pngimage,
  uniImage, uniPageControl, uniGroupBox, uniBasicGrid, uniDBGrid;

type
  TControleCadastroTituloPagar = class(TControleCadastro)
    DscFormaReceb: TDataSource;
    CdsFormaReceb: TClientDataSet;
    DspFormaReceb: TDataSetProvider;
    QryFormaReceb: TADOQuery;
    QryFormaRecebID: TFloatField;
    QryFormaRecebDESCRICAO: TWideStringField;
    CdsFormaRecebID: TFloatField;
    CdsFormaRecebDESCRICAO: TWideStringField;
    UniSweetAlertCancelarTitulo: TUniSweetAlert;
    UniImageList3: TUniImageList;
    UniPageControl1: TUniPageControl;
    UniTabSheet3: TUniTabSheet;
    UniPanel11: TUniPanel;
    LabelValorTitulo: TUniLabel;
    UniLabelRecebimento: TUniLabel;
    UniImage6: TUniImage;
    UniPanel5: TUniPanel;
    LabelValorEncargos: TUniLabel;
    UniLabel22: TUniLabel;
    UniImage1: TUniImage;
    UniPanel7: TUniPanel;
    LabelValorTotal: TUniLabel;
    UniLabel24: TUniLabel;
    UniImage2: TUniImage;
    UniTabSheet1: TUniTabSheet;
    UniDBMemo1: TUniDBMemo;
    UniPanelClient: TUniPanel;
    LabelNomeRazao: TUniLabel;
    DBEdtNome: TUniDBEdit;
    ButtonPesquisaFornecedor: TUniSpeedButton;
    UniDBEdit2: TUniDBEdit;
    UniLabel11: TUniLabel;
    UniLabel3: TUniLabel;
    UniLabel23: TUniLabel;
    UniDBResponsavel2: TUniDBEdit;
    UniLabel13: TUniLabel;
    UniDBEdit6: TUniDBEdit;
    UniLabel1: TUniLabel;
    UniDBEdit1: TUniDBEdit;
    UniDBEditDataLiquidacao: TUniDBDateTimePicker;
    UniLabel6: TUniLabel;
    UniDBEditDataVencimento: TUniDBDateTimePicker;
    UniLabel5: TUniLabel;
    UniDBEdit3: TUniDBEdit;
    UniLabel7: TUniLabel;
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
    UniDBLookupComboBox1: TUniDBLookupComboBox;
    DspTituloCategoria: TDataSetProvider;
    CdsTituloCategoria: TClientDataSet;
    DscTituloCategoria: TDataSource;
    QryTituloCategoria: TADOQuery;
    FloatField2: TFloatField;
    WideStringField2: TWideStringField;
    CdsTituloCategoriaID: TFloatField;
    CdsTituloCategoriaDESCRICAO: TWideStringField;
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
    UniDBEdit8: TUniDBEdit;
    UniLabel8: TUniLabel;
    UniPanelCalculo: TUniPanel;
    UniPanel9: TUniPanel;
    UniPanel4: TUniPanel;
    UniPanel14: TUniPanel;
    UniImage5: TUniImage;
    UniPanel13: TUniPanel;
    UniLabel4: TUniLabel;
    LabelDiasAtraso: TUniLabel;
    UniPanel3: TUniPanel;
    UniPanel16: TUniPanel;
    UniImage4: TUniImage;
    UniPanel17: TUniPanel;
    UniLabel10: TUniLabel;
    LabelMultaPrevista: TUniLabel;
    UniPanel8: TUniPanel;
    UniPanel18: TUniPanel;
    UniImage3: TUniImage;
    UniPanel19: TUniPanel;
    UniLabel15: TUniLabel;
    LabelValorJurosPrevisto: TUniLabel;
    UniPanel10: TUniPanel;
    UniPanel12: TUniPanel;
    UniImage7: TUniImage;
    UniPanel15: TUniPanel;
    UniLabel9: TUniLabel;
    LabelDesconto: TUniLabel;
    UniPanel20: TUniPanel;
    UniPanel22: TUniPanel;
    UniPanel23: TUniPanel;
    UniImage8: TUniImage;
    UniPanel24: TUniPanel;
    UniLabel2: TUniLabel;
    LabelValorOriginal: TUniLabel;
    UniPanel25: TUniPanel;
    UniPanel26: TUniPanel;
    UniImage9: TUniImage;
    UniPanel30: TUniPanel;
    UniLabel12: TUniLabel;
    LabelPago: TUniLabel;
    UniPanel27: TUniPanel;
    UniPanel28: TUniPanel;
    UniImage10: TUniImage;
    UniPanel29: TUniPanel;
    UniLabel17: TUniLabel;
    LabelValorAtualizado: TUniLabel;
    UniPanel31: TUniPanel;
    UniPanel32: TUniPanel;
    UniImage11: TUniImage;
    UniPanel33: TUniPanel;
    UniLabel14: TUniLabel;
    LabelSaldo: TUniLabel;
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
    UniTabSheet2: TUniTabSheet;
    UniDBGrid1: TUniDBGrid;
    QryCadastroVALOR_DESCONTO: TFloatField;
    CdsCadastroVALOR_DESCONTO: TFloatField;
    procedure UniFormCreate(Sender: TObject);
    procedure UniSweetAlertCancelarTituloConfirm(Sender: TObject);
    procedure ButtonPesquisaFornecedorClick(Sender: TObject);
    procedure BotaoSalvarClick(Sender: TObject);
    procedure UniDBLookupComboBox1Change(Sender: TObject);
  private
    procedure ExecutaCalculo;
    { Private declarations }
  public
    { Public declarations }
    TituloCategoriaId : Integer;
    vFornecedor_id: string;
    /// Código da finalidade do arquivo - TRegistro0000
    function Abrir(Id: Integer): Boolean; override;
    function Novo(): Boolean; override;
    function Editar(Id: Integer): Boolean; override;
    function Salvar: Boolean; override;
    function Descartar: Boolean; override;
  end;

function ControleCadastroTituloPagar: TControleCadastroTituloPagar;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication, Controle.Consulta.TituloPagar,
  Controle.Funcoes,Controle.Consulta.Modal.TituloCategoria.Pagar,
  Controle.Consulta.Modal.Pessoa.TituloPagar;

function ControleCadastroTituloPagar: TControleCadastroTituloPagar;
begin
  Result := TControleCadastroTituloPagar(ControleMainModule.GetFormInstance(TControleCadastroTituloPagar));
end;

function TControleCadastroTituloPagar.Abrir(Id: Integer): Boolean;
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

  vFornecedor_id     := CdsCadastroFORNECEDOR_ID.AsString;
  TituloCategoriaId  := CdsCadastroTITULO_CATEGORIA_ID.AsInteger;

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


procedure TControleCadastroTituloPagar.BotaoSalvarClick(Sender: TObject);
begin
  inherited;
  if TituloCategoriaId = 0 then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Escolha uma categoria para o título.');
    UniDBLookupComboBox1.SetFocus;
    Exit;

  end;
end;

procedure TControleCadastroTituloPagar.ButtonPesquisaFornecedorClick(
  Sender: TObject);
begin
  inherited;
  if (CdsCadastroSITUACAO.AsString = 'ABERTO')  or (CdsCadastroSITUACAO.AsString = 'INADIMPLENTE')then
  begin
    // Define o filtro fixo para a pesquisa (Tipo de Pessoa = F, J ou FJ)
    ControleConsultaModalPessoaTituloPagar.QryConsulta.Parameters.ParamByName('tipo').Value := 'FJ';

    // Abre o formulário em modal e aguarda
    ControleConsultaModalPessoaTituloPagar.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
      if Result = 1 then
      begin
        // Pega o id da pessoa selecionada
        vFornecedor_id := ControleConsultaModalPessoaTituloPagar.CdsConsulta.FieldByName('id').AsString;
        DBEdtNome.Text := ControleConsultaModalPessoaTituloPagar.CdsConsulta.FieldByName('nome_fantasia').AsString;
      end;
    end);
  end
  else
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Só é permitido receber o título em situação aberto ou inadimplente.');


end;

function TControleCadastroTituloPagar.Descartar: Boolean;
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

function TControleCadastroTituloPagar.Editar(Id: Integer): Boolean;
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

    TituloCategoriaId := CdsCadastroTITULO_CATEGORIA_ID.AsInteger;
  end;


  Result := True;
end;

function TControleCadastroTituloPagar.Novo(): Boolean;
begin
  // nao existe nesse form
end;

function TControleCadastroTituloPagar.Salvar: Boolean;
var
  Erro : string;
begin
  Erro := '';

  with ControleMainModule do
  begin
    if CdsCadastro.State in [dsInsert, dsEdit] then
    begin
      // Inicia a transação
      if ADOConnection.Intransaction = False then
          ADOConnection.BeginTrans;

      Try
        // Passo Unico - Salva os dados da cidade
        QryAx3.Parameters.Clear;
        QryAx3.SQL.Clear;

        // Update
        QryAx3.SQL.Add('UPDATE titulo SET');
        QryAx3.SQL.Add('       historico           = :historico,');
        QryAx3.SQL.Add('       NUMERO_REFERENCIA   = :NUMERO_REFERENCIA,');
        QryAx3.SQL.Add('       titulo_categoria_id = :categoria_id');
        QryAx3.SQL.Add(' WHERE id                  = :id');

        QryAx3.Parameters.ParamByName('id').Value           := CdsCadastroID.AsInteger;
        QryAx3.Parameters.ParamByName('historico').Value    := CdsCadastroHISTORICO.AsString;
        QryAx3.Parameters.ParamByName('NUMERO_REFERENCIA').Value := CdsCadastroNUMERO_REFERENCIA.AsString;
        QryAx3.Parameters.ParamByName('categoria_id').Value := TituloCategoriaId;
        QryAx3.ExecSQL
      Except
        on e:exception do
          Erro := e.Message;
      End;

      if Erro = '' then
      begin
        QryAx1.SQL.Clear;
        QryAx1.SQL.Add('UPDATE titulo_pagar SET');
        QryAx1.SQL.Add('       fornecedor_id      = :fornecedor_id');
        QryAx1.SQL.Add(' WHERE id                     = :id');

        QryAx1.Parameters.ParamByName('id').Value              := CdsCadastroID.AsInteger;
        QryAx1.Parameters.ParamByName('fornecedor_id').Value   := vFornecedor_id;

        try
          // Tenta salvar os dados
          QryAx1.ExecSQL;
        except
          on E: Exception do
          begin
            ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));
            // Descarta a transação
            if ADOConnection.InTransaction = True then
              ADOConnection.RollbackTrans;
          end;
        end;
      end;

      if Erro = '' then
      begin
        Try
          // Confirma a transação
          ADOConnection.CommitTrans;
        Except
          on e:Exception do
          begin
            ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));
            // Descarta a transação
            if ADOConnection.InTransaction = True then
              ADOConnection.RollbackTrans;
          end;
        End;
      end;
    end;
  end;
  CdsCadastro.Post;
end;

procedure TControleCadastroTituloPagar.UniDBLookupComboBox1Change(
  Sender: TObject);
begin
  inherited;
  TituloCategoriaId := CdsTituloCategoriaID.AsInteger;
end;

procedure TControleCadastroTituloPagar.UniFormCreate(Sender: TObject);
begin
  inherited;
  CdsFormaReceb.Open;
  CdsTituloCategoria.Open;
end;

procedure TControleCadastroTituloPagar.UniSweetAlertCancelarTituloConfirm(
  Sender: TObject);
begin
  inherited;
  ControleMainModule.CancelaTitulo(CdsCadastroID.AsInteger);
  Abrir(CdsCadastroID.AsInteger);
end;

procedure TControleCadastroTituloPagar.ExecutaCalculo;
begin
  LabelDiasAtraso.Caption         := CdsCadastroDIAS_ATRASO.AsString;
  LabelValorOriginal.Caption      := formatfloat('R$ #,##0.00', CdsCadastroVALOR.AsFloat);
  LabelMultaPrevista.Caption      := formatfloat('R$ #,##0.00', CdsCadastroVALOR_MULTA.AsFloat);
  LabelValorJurosPrevisto.Caption := formatfloat('R$ #,##0.00', CdsCadastroVALOR_JUROS.AsFloat);
  LabelValorAtualizado.Caption    := formatfloat('R$ #,##0.00', ((CdsCadastroVALOR.AsFloat +
                                                                CdsCadastroVALOR_MULTA.AsFloat +
                                                                CdsCadastroVALOR_JUROS.AsFloat)- CdsCadastroVALOR_DESCONTO.AsFloat));
  LabelSaldo.Caption              := formatfloat('R$ #,##0.00', CdsCadastroVALOR_SALDO.AsFloat);
  LabelDesconto.Caption           := formatfloat('R$ #,##0.00', CdsCadastroVALOR_DESCONTO.AsFloat);
  LabelPago.Caption               := formatfloat('R$ #,##0.00', CdsCadastroVALOR_PAGO.AsFloat);
end;


end.
