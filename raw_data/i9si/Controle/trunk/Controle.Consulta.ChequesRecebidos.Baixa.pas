unit Controle.Consulta.ChequesRecebidos.Baixa;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Data.DB, Datasnap.DBClient, uniButton, uniPanel,
  uniGUIBaseClasses, uniBasicGrid, uniDBGrid, uniImageList, uniBitBtn,
  uniSpeedButton, uniLabel,  Data.Win.ADODB, Datasnap.Provider,
  uniMultiItem, uniComboBox, uniMemo, uniDateTimePicker, uniSweetAlert,
  frxClass, frxDBSet, uniEdit;

type
  TControleConsultaChequesRecebidosBaixa = class(TUniForm)
    UniDBGrid1: TUniDBGrid;
    UniPanel1: TUniPanel;
    BotaoConfirma: TUniButton;
    UniButton1: TUniButton;
    UniImageList1: TUniImageList;
    UniImageCaptionClose: TUniImageList;
    UniPanelCaption: TUniPanel;
    UniLabelCaption: TUniLabel;
    UniSpeedCaptionClose: TUniSpeedButton;
    UniImageCaptionMaximizar: TUniSpeedButton;
    UniPanel2: TUniPanel;
    UniLabel12: TUniLabel;
    DscChequeDestino: TDataSource;
    CdsChequeDestino: TClientDataSet;
    CdsChequeDestinoID: TFloatField;
    CdsChequeDestinoDESCRICAO: TWideStringField;
    DspChequeDestino: TDataSetProvider;
    QryChequeDestino: TADOQuery;
    UniComboBoxChequeDestino: TUniComboBox;
    UniDateTimeDataDeposito: TUniDateTimePicker;
    UniLabel1: TUniLabel;
    UniMemoObservacao: TUniMemo;
    UniLabel2: TUniLabel;
    UniSweetAlertaFechaFormulario: TUniSweetAlert;
    UniLabel4: TUniLabel;
    UniLabel5: TUniLabel;
    EditTotal: TUniFormattedNumberEdit;
    EditQtd: TUniFormattedNumberEdit;
    BotaoImprimir: TUniButton;
    DscConsulta: TDataSource;
    CdsConsulta: TClientDataSet;
    DspConsulta: TDataSetProvider;
    QryConsulta: TADOQuery;
    CdsConsultaID: TFloatField;
    CdsConsultaSITUACAO: TWideStringField;
    CdsConsultaCHEQUE_SITUACAO: TWideStringField;
    CdsConsultaCLIENTE_ID: TFloatField;
    CdsConsultaCIDADE_ID: TFloatField;
    CdsConsultaVENDEDOR_ID: TFloatField;
    CdsConsultaDESTINO_ID: TFloatField;
    CdsConsultaCLIENTE_EMITENTE_ID: TFloatField;
    CdsConsultaLOTE_NUMERO: TWideStringField;
    CdsConsultaDATA_CADASTRO: TWideStringField;
    CdsConsultaPROPRIO_CLIENTE: TWideStringField;
    CdsConsultaNUMERO: TWideStringField;
    CdsConsultaDIGITO: TWideStringField;
    CdsConsultaCONTA_CORRENTE: TWideStringField;
    CdsConsultaBANCO_ID: TFloatField;
    CdsConsultaAGENCIA: TWideStringField;
    CdsConsultaDATA_DEPOSITO: TDateTimeField;
    CdsConsultaOBSERVACAO: TWideStringField;
    CdsConsultaCODIGO_CMC7: TWideStringField;
    CdsConsultaDATA_DEVOLUCAO: TDateTimeField;
    CdsConsultaDATA_VENCIMENTO: TWideStringField;
    CdsConsultaMOTIVO_DEVOLUCAO: TWideStringField;
    CdsConsultaVALOR_CHEQUE: TFloatField;
    CdsConsultaMARCADO: TWideStringField;
    CdsConsultaSomaTotal: TAggregateField;
    CdsConsultaQtd: TAggregateField;
    CdsConsultaRAZAO_CLIENTE: TWideStringField;
    CdsConsultaCPF_CNPJ_CLIENTE: TWideStringField;
    CdsConsultaRAZAO_EMITENTE: TWideStringField;
    CdsConsultaCPF_CNPJ_EMITENTE: TWideStringField;
    frxReport_baixa_cheque: TfrxReport;
    frxDBDataset1: TfrxDBDataset;
    CdsConsultaDADOS_BANCARIOS: TWideStringField;
    UniSweetAlertImprimir: TUniSweetAlert;
    procedure UniButton1Click(Sender: TObject);
    procedure UniFormShow(Sender: TObject);
    procedure UniImageCaptionMaximizarClick(Sender: TObject);
    procedure UniSpeedCaptionCloseClick(Sender: TObject);
    procedure UniSweetAlertaFechaFormularioConfirm(Sender: TObject);
    procedure BotaoImprimirClick(Sender: TObject);
    procedure UniSweetAlertImprimirRelatorioConfirm(Sender: TObject);
    procedure UniSweetAlertImprimirRelatorioDismiss(Sender: TObject;
      const Reason: TDismissType);
    procedure UniSweetAlertImprimirConfirm(Sender: TObject);
    procedure BotaoConfirmaClick(Sender: TObject);
    procedure UniSweetAlertImprimirDismiss(Sender: TObject;
      const Reason: TDismissType);
  private
    function Salvar: Boolean;
    procedure PreencheLabel;

    { Private declarations }
  public
    SomaTotal,
    Qtd : string;
    Depositado : Boolean;
    function Abrir: Boolean;
    { Public declarations }
  end;

function ControleConsultaChequesRecebidosBaixa: TControleConsultaChequesRecebidosBaixa;

implementation

{$R *.dfm}

uses
  Controle.Main, Controle.Main.Module, uniGUIApplication;

function ControleConsultaChequesRecebidosBaixa: TControleConsultaChequesRecebidosBaixa;
begin
  Result := TControleConsultaChequesRecebidosBaixa(ControleMainModule.GetFormInstance(TControleConsultaChequesRecebidosBaixa));
end;

procedure TControleConsultaChequesRecebidosBaixa.UniButton1Click(
  Sender: TObject);
begin
  CdsConsulta.Delete;
end;

procedure TControleConsultaChequesRecebidosBaixa.UniFormShow(Sender: TObject);
begin
  UniLabelCaption.Text := Self.Caption;
  UniDateTimeDataDeposito.DateTime := Date;

  // Alimentando Cds
  With UniComboBoxChequeDestino do
  begin
    Clear;
    CdsChequeDestino.Open;
    CdsChequeDestino.First;
    while not CdsChequeDestino.eof do
    begin
      Items.Add(CdsChequeDestinoDescricao.AsString);
      CdsChequeDestino.Next;
    end;
  end;
  PreencheLabel;
end;

procedure TControleConsultaChequesRecebidosBaixa.UniImageCaptionMaximizarClick(
  Sender: TObject);
begin
  WindowState := wsMaximized;
  UniImageCaptionMaximizar.Visible := False;
end;

procedure TControleConsultaChequesRecebidosBaixa.UniSpeedCaptionCloseClick(
  Sender: TObject);
begin
  if CdsConsulta.State in [dsInsert, dsEdit] then
    UniSweetAlertaFechaFormulario.Show // O código fica no evento do componente!
  else
    Close;
end;

procedure TControleConsultaChequesRecebidosBaixa.UniSweetAlertaFechaFormularioConfirm(
  Sender: TObject);
begin
  close;
end;

procedure TControleConsultaChequesRecebidosBaixa.UniSweetAlertImprimirConfirm(
  Sender: TObject);
begin
  BotaoImprimir.Click;
  ControleConsultaChequesRecebidosBaixa.Close;
end;

procedure TControleConsultaChequesRecebidosBaixa.UniSweetAlertImprimirDismiss(
  Sender: TObject; const Reason: TDismissType);
begin
  ControleConsultaChequesRecebidosBaixa.Close;
end;

procedure TControleConsultaChequesRecebidosBaixa.UniSweetAlertImprimirRelatorioConfirm(
  Sender: TObject);
begin
  BotaoImprimir.Click;
end;

procedure TControleConsultaChequesRecebidosBaixa.UniSweetAlertImprimirRelatorioDismiss(
  Sender: TObject; const Reason: TDismissType);
begin
  Close;
end;

function TControleConsultaChequesRecebidosBaixa.Salvar: Boolean;
var
  CadastroId, cAdastroItensId : Integer;
  Erro : String;
begin
  inherited;

  Result := False;

  CdsChequeDestino.Locate('DESCRICAO',UniComboBoxChequeDestino.Text,[]);

  if Trim(UniComboBoxChequeDestino.Text) = '' then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção',
                         'É necessário informar o destino dos cheques!');
    UniComboBoxChequeDestino.SetFocus;
    Exit;
  end;

  if Trim(UniDateTimeDataDeposito.Text) = '30/12/1899' then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'É necessário informar a data de depósito dos cheque');
    UniDateTimeDataDeposito.SetFocus;
    Exit;
  end;

  with ControleMainModule do
  begin
    // Inicia a transação
    ADOConnection.BeginTrans;

    // Inserindo na tabela pai
    QryAx1.Parameters.Clear;
    QryAx1.SQL.Clear;

    // Gera um novo id para a tabela cheque_baixa_cabecalho
    CadastroId := GeraId('cheque_baixa_cabecalho');
    // Insert
    QryAx1.SQL.Add('INSERT INTO cheque_baixa_cabecalho (');
    QryAx1.SQL.Add('       id,');
    QryAx1.SQL.Add('       data,');
    QryAx1.SQL.Add('       cheque_destino_id)');
    QryAx1.SQL.Add('VALUES (');
    QryAx1.SQL.Add('       :id,');
    QryAx1.SQL.Add('       TO_DATE(''' + Trim(UniDateTimeDataDeposito.Text) + ''', ''dd/mm/yyyy''),');
    QryAx1.SQL.Add('       :cheque_destino_id)');

    QryAx1.Parameters.ParamByName('id').Value                := CadastroId;
    QryAx1.Parameters.ParamByName('cheque_destino_id').Value := CdsChequeDestinoID.AsInteger;

    try
      // Tenta salvar os dados
      QryAx1.ExecSQL;
    except
      on E: Exception do
      begin
        Depositado :=False;
        Erro := E.Message;
      end;
    end;

    if Erro = '' then
    begin
      CdsConsulta.first;
      while not CdsConsulta.eof do
      begin
        // Atualizando a tabela titulos_receber(parte do cheque)
        // Colocando o cheque_destino_id, data_deposito, observacao
        CadastroItensId := GeraId('cheque_baixa_itens');

        QryAx2.SQL.Clear;
        QryAx2.SQL.Add('INSERT INTO cheque_baixa_itens (');
        QryAx2.SQL.Add('       id,');
        QryAx2.SQL.Add('       cheque_baixa_cabecalho_id,');
        QryAx2.SQL.Add('       cheque_id)');
        QryAx2.SQL.Add('VALUES (');
        QryAx2.SQL.Add('       :id,');
        QryAx2.SQL.Add('       :cheque_baixa_cabecalho_id,');
        QryAx2.SQL.Add('       :cheque_id)');

        QryAx2.Parameters.ParamByName('id').Value                        := CadastroItensId;
        QryAx2.Parameters.ParamByName('cheque_baixa_cabecalho_id').Value := CadastroId;
        QryAx2.Parameters.ParamByName('cheque_id').Value                 := CdsConsultaID.AsInteger;

        try
          // Tenta salvar os dados
          QryAx2.ExecSQL;
        except
          on E: Exception do
          begin
            Depositado :=False;
            Erro := E.Message;
          end;
        end;

        if Erro = '' then
        begin
          QryAx3.SQL.Clear;
          QryAx3.SQL.Add('UPDATE cheque SET');
          QryAx3.SQL.Add('       data_deposito   = TO_DATE(''' + Trim(UniDateTimeDataDeposito.Text) + ''', ''dd/mm/yyyy''),');
          QryAx3.SQL.Add('       destino_id      = :destino_id,');
          QryAx3.SQL.Add('       observacao      = :observacao,');
          QryAx3.SQL.Add('       situacao        = :situacao');
          QryAx3.SQL.Add(' WHERE id              = :id');

          QryAx3.Parameters.ParamByName('destino_id').Value       := CdsChequeDestinoID.AsInteger;
          QryAx3.Parameters.ParamByName('observacao').Value       := UniMemoObservacao.Text;
          QryAx3.Parameters.ParamByName('situacao').Value         := 'DEPOSITADO';
          QryAx3.Parameters.ParamByName('id').Value               := CdsConsultaID.AsInteger;

          try
            // Tenta salvar os dados
            QryAx3.ExecSQL;
          except
            on E: Exception do
            begin
              Depositado :=False;
              Erro := E.Message;
            end;
          end;
        end;

        CdsConsulta.Next;
      end;
    end;

    if Erro = '' then
    begin
      try
        // Confirma a transação
        ADOConnection.CommitTrans;
        Result := True;
        Depositado := True;
        UniSweetAlertImprimir.Show;
      except
        on E: Exception do
        begin
          // Descarta a transação
          ADOConnection.RollbackTrans;
          ControleMainModule.MensageiroSweetAlerta('Atenção','Não foi possível salvar os dados alterados. ' + e.Message);
          Depositado :=False;
          Exit;
        end;
      end;
    end;
  end;
end;

procedure TControleConsultaChequesRecebidosBaixa.BotaoConfirmaClick(
  Sender: TObject);
begin
  Salvar;
end;

procedure TControleConsultaChequesRecebidosBaixa.BotaoImprimirClick(
  Sender: TObject);
begin
  frxReport_baixa_cheque.Variables.Variables['Destino'] := QuotedStr(UniComboBoxChequeDestino.Text);
  frxReport_baixa_cheque.Variables.Variables['DtDeposito'] := QuotedStr(DateToStr(UniDateTimeDataDeposito.DateTime));
  frxReport_baixa_cheque.Variables.Variables['RazaoEmpresa'] := QuotedStr(ControleMainModule.FRazaoSocial);
  ControleMainModule.ExportarPDF('Relatorio',frxReport_baixa_cheque);
end;

procedure TControleConsultaChequesRecebidosBaixa.PreencheLabel;
begin
  EditTotal.Text  := CdsConsultaSomaTotal.AsString;
  EditQtd.Text    := CdsConsultaQtd.AsString;
end;

function TControleConsultaChequesRecebidosBaixa.Abrir:Boolean;
begin
  CdsConsulta.Close;
  CdsConsulta.Params.ParamByName('usuarioid').Value := ControleMainModule.FUsuarioId;
  CdsConsulta.Open;
end;

end.
