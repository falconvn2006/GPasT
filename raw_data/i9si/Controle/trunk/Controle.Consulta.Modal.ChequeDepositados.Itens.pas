unit Controle.Consulta.Modal.ChequeDepositados.Itens;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Controle.Consulta.Modal, Data.DB,
  Data.Win.ADODB, Datasnap.Provider, Datasnap.DBClient, uniGUIBaseClasses,
  uniGUIClasses, uniImageList, uniPanel, uniBasicGrid, uniDBGrid, uniButton,
  uniEdit, uniLabel, frxClass, frxDBSet, uniBitBtn, uniSpeedButton;

type
  TControleConsultaModalChequeDepositadosItens = class(TControleConsultaModal)
    CdsConsultaCHEQUE_BAIXA_CABECALHO_ID: TFloatField;
    CdsConsultaCHEQUE_ID: TFloatField;
    CdsConsultaCLIENTE: TWideStringField;
    UniEdit1: TUniEdit;
    UniEdit2: TUniEdit;
    UniEdit3: TUniEdit;
    CdsConsultaID: TFloatField;
    CdsConsultaDATA_DEPOSITO: TDateTimeField;
    CdsConsultaSITUACAO: TWideStringField;
    frxConsulta: TfrxDBDataset;
    RlConsulta: TfrxReport;
    CdsConsultaDATA: TDateTimeField;
    CdsConsultaDESTINO: TWideStringField;
    UniImageList2: TUniImageList;
    CdsConsultaSomaValor: TAggregateField;
    CdsConsultaVALOR_CHEQUE: TFloatField;
    CdsConsultaDATA_DEVOLUCAO: TDateTimeField;
    procedure CdsConsultaCHEQUE_SITUACAOGetText(Sender: TField;
      var Text: string; DisplayText: Boolean);
    procedure BotaoNovoClick(Sender: TObject);
    procedure BotaoConfirmaClick(Sender: TObject);
  private
    LoteId : Integer;
    function AlteraChequeDevolvido: Boolean;
    { Private declarations }
  public
    { Public declarations }
    function Abrir(Id: Integer): Boolean;
  end;


function ControleConsultaModalChequeDepositadosItens: TControleConsultaModalChequeDepositadosItens;

implementation

{$R *.dfm}

uses Controle.Main.Module, Controle.Operacoes.DevolverCheque;

function ControleConsultaModalChequeDepositadosItens: TControleConsultaModalChequeDepositadosItens;
begin
  Result := TControleConsultaModalChequeDepositadosItens(ControleMainModule.GetFormInstance(TControleConsultaModalChequeDepositadosItens));
end;

function TControleConsultaModalChequeDepositadosItens.Abrir(Id: Integer): Boolean;
begin
  Result := False;

  // Abre o registro
  CdsConsulta.Close;
  CdsConsulta.Params.ParamByName('id').Value := Id;
  CdsConsulta.Open;

  // Se algum registro foi solicitado, deve parar se não encontrar
  if (Id > 0) and CdsConsulta.IsEmpty then
    Exit;

  // Bloqueia o registro para edição
  DscConsulta.AutoEdit := False;

  LoteId := Id;

  Result := True;
end;

procedure TControleConsultaModalChequeDepositadosItens.CdsConsultaCHEQUE_SITUACAOGetText(
  Sender: TField; var Text: string; DisplayText: Boolean);
begin
  inherited;
  if Sender.AsString = 'DEPOSITAR' then
    Text := '<img src=./files/icones/upload.png height=20 align="center" />'
  else if Sender.AsString = 'DEPOSITADO' then
    Text := '<img src=./files/icones/check-outline.png height=20 align="center" />'
  else if Sender.AsString = 'DEVOLVIDO' then
    Text := '<img src=./files/icones/check-message-alert.png height=20 align="center" />'
end;

function TControleConsultaModalChequeDepositadosItens.AlteraChequeDevolvido: Boolean;
var
  CadastroId, cAdastroItensId : Integer;
  Erro : String;
begin
 { inherited;

  Result := False;

  with ControleMainModule do
  begin
    // Inicia a transação
    ADOConnection.BeginTrans;

    if Erro = '' then
    begin
      QryAx1.SQL.Clear;
      QryAx1.SQL.Add('UPDATE titulo_receber SET');
      QryAx1.SQL.Add('       cheque_data_devolucao   = TO_DATE(''' + Trim(UniDateTimeDataDeposito.Text) + ''', ''dd/mm/yyyy''),');
      QryAx1.SQL.Add('       cheque_destino_id      = :cheque_destino_id,');
      QryAx1.SQL.Add('       cheque_observacao      = :cheque_observacao,');
      QryAx1.SQL.Add('       cheque_situacao        = :cheque_situacao');
      QryAx1.SQL.Add(' WHERE id                     = :id');

      QryAx1.Parameters.ParamByName('cheque_destino_id').Value       := CdsChequeDestinoID.AsInteger;
      QryAx1.Parameters.ParamByName('cheque_observacao').Value       := UniMemoObservacao.Text;
      QryAx1.Parameters.ParamByName('cheque_situacao').Value         := 'DEPOSITADO';
      QryAx1.Parameters.ParamByName('id').Value                      := CdsConsultaID.AsInteger;

      try
        // Tenta salvar os dados
        QryAx1.ExecSQL;
        ADOConnection.CommitTrans;
        Controle.Consulta.Modal := True;
      except
        on E: Exception do
        begin
          Erro := E.Message;
        end;
      end;
    end;
  end;  }
end;

procedure TControleConsultaModalChequeDepositadosItens.BotaoConfirmaClick(
  Sender: TObject);
begin
  //inherited;
  if ControleOperacoesDevolverCheque.Abrir(CdsConsultaCHEQUE_ID.AsInteger,CdsConsultaCLIENTE.AsString) then
  ControleOperacoesDevolverCheque.ShowModal(procedure(Sender: TComponent; Result: Integer)
  begin
    CdsConsulta.Refresh;
  end);

end;

procedure TControleConsultaModalChequeDepositadosItens.BotaoNovoClick(
  Sender: TObject);
begin
  inherited;
  RlConsulta.Variables.Variables['RazaoEmpresa'] := QuotedStr(ControleMainModule.FRazaoSocial);
//  RlConsulta.ShowReport(True);
  ControleMainModule.ExportarPDF('Relatorio', RlConsulta);
end;



end.
