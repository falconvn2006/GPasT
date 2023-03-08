unit Controle.Operacoes.DevolverCheque;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Controle.Operacoes, uniEdit, uniMemo,
  Data.Win.ADODB, Datasnap.Provider, Data.DB, Datasnap.DBClient,
  uniGUIBaseClasses, uniImageList, uniBitBtn, uniSpeedButton, uniLabel,
  uniButton, uniPanel, uniSweetAlert, uniDBText;

type
  TControleOperacoesDevolverCheque = class(TControleOperacoes)
    MemoJustificativaDevolucao: TUniMemo;
    UniLabel1: TUniLabel;
    UniLabel2: TUniLabel;
    UniSweetAlertSucesso: TUniSweetAlert;
    UniLabel25: TUniLabel;
    EditCliente: TUniEdit;
    UniLabel3: TUniLabel;
    EditIdCheque: TUniEdit;
    EditDataDevolucao: TUniEdit;
    procedure BotaoSalvarClick(Sender: TObject);
  private
    Cheque_id: Integer;
    { Private declarations }
  public
    function Abrir(Id: Integer; cliente: string): Boolean;
    function Salvar: Boolean;
    { Public declarations }
  end;


function ControleOperacoesDevolverCheque: TControleOperacoesDevolverCheque;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication, Controle.Funcoes;

function ControleOperacoesDevolverCheque: TControleOperacoesDevolverCheque;
begin
  Result := TControleOperacoesDevolverCheque(ControleMainModule.GetFormInstance(TControleOperacoesDevolverCheque));
end;

function TControleOperacoesDevolverCheque.Abrir(Id: Integer; cliente: string): Boolean;
begin
  Cheque_id :=  Id;
  EditIdCheque.text := IntToStr(Id);
  EditDataDevolucao.Text := DateToStr(Date);
  EditCliente.text := cliente;
  Result := True;
end;

procedure TControleOperacoesDevolverCheque.BotaoSalvarClick(Sender: TObject);
begin
  inherited;
  Salvar;
end;

Function TControleOperacoesDevolverCheque.Salvar: Boolean;
begin
  With ControleMainModule do
  begin
    // Inicia a transação
    ADOConnection.BeginTrans;

    // Passo Unico - Salva os dados da cidade
    QryAx3.Parameters.Clear;
    QryAx3.SQL.Clear;


    // Update
    QryAx3.SQL.Add('UPDATE cheque SET');
    QryAx3.SQL.Add('       data_devolucao     = TO_DATE(''' + Trim(EditDataDevolucao.Text) + ''', ''dd/mm/yyyy''),');
    QryAx3.SQL.Add('       motivo_devolucao   = :motivo');
    QryAx3.SQL.Add(' WHERE id                 = :id');

    QryAx3.Parameters.ParamByName('id').Value := Cheque_id;
    QryAx3.Parameters.ParamByName('motivo').Value := MemoJustificativaDevolucao.Text;

    try
      // Tenta salvar os dados
      QryAx3.ExecSQL;
      // Confirma a transação
      ADOConnection.CommitTrans;
      Result := True;
      UniSweetAlertSucesso.Show;
    except
      on E: Exception do
      begin
        // Descarta a transação
        ADOConnection.RollbackTrans;
        ControleMainModule.MensageiroSweetAlerta('Atenção', 'Não foi possível salvar os dados alterados: ' +ControleFuncoes.RetiraAspaSimples(E.Message));
        Result := False;
      end;
    end;
  end;
end;
end.
