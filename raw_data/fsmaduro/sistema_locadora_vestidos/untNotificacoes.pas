unit untNotificacoes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, Wwdbigrd, Wwdbgrid, StdCtrls, dxGDIPlusClasses, ExtCtrls,
  Buttons, DB, IBCustomDataSet, IBQuery;

type
  TfrmNotificacoes = class(TForm)
    Panel_btns_cad: TPanel;
    btn_ok: TSpeedButton;
    Panel1: TPanel;
    Image1: TImage;
    Label1: TLabel;
    wwDBGrid1: TwwDBGrid;
    qryNotificacoes: TIBQuery;
    dtsNotificacoes: TDataSource;
    qryNotificacoesID: TIntegerField;
    qryNotificacoesDESCRICAO: TIBStringField;
    qryNotificacoesXCOUNT: TIntegerField;
    procedure btn_okClick(Sender: TObject);
    procedure qryNotificacoesBeforeOpen(DataSet: TDataSet);
    procedure FormShow(Sender: TObject);
  private
    vDiasAlertaPedido: Integer;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmNotificacoes: TfrmNotificacoes;

implementation

uses untDados;

{$R *.dfm}

procedure TfrmNotificacoes.btn_okClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmNotificacoes.FormShow(Sender: TObject);
begin
  vDiasAlertaPedido := Dados.ValorConfig('frmAcompanhaPedidoAgenda','DIASALERTA',30,tcInteiro).vcInteger;

  qryNotificacoes.Close;
  qryNotificacoes.Open;
end;

procedure TfrmNotificacoes.qryNotificacoesBeforeOpen(DataSet: TDataSet);
begin
  qryNotificacoes.ParamByName('datainicio').AsDateTime := now;
  qryNotificacoes.ParamByName('horainicio').AsDateTime := now;
  qryNotificacoes.ParamByName('datapedido').AsDateTime := now;
  qryNotificacoes.ParamByName('datahistorico').AsDateTime := now;
  qryNotificacoes.ParamByName('dataFinanceiroPagar').AsDateTime := now;
  qryNotificacoes.ParamByName('dataFinanceiroReceber').AsDateTime := now;
  qryNotificacoes.ParamByName('dataFinanceiroPagarHoje').AsDateTime := now;
  qryNotificacoes.ParamByName('dataFinanceiroReceberHoje').AsDateTime := now;
  qryNotificacoes.ParamByName('diasAlertaPedido').AsInteger := vDiasAlertaPedido;
end;

end.
