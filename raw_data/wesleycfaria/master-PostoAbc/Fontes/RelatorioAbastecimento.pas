unit RelatorioAbastecimento;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, FMTBcd, DB, SqlExpr, ComCtrls;

type
  TFRelatorioAbastecimento = class(TForm)
    gbxRegistro: TGroupBox;
    Label1: TLabel;
    GroupBox2: TGroupBox;
    btnVisualizar: TButton;
    btnImprimir: TButton;
    dtpDataInicial: TDateTimePicker;
    Label2: TLabel;
    dtpDataFinal: TDateTimePicker;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure btnVisualizarClick(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
  private
  public

  end;

var
  FRelatorioAbastecimento: TFRelatorioAbastecimento;

implementation

uses uPrincipal, ConsultaTanque, RelatorioAbastecimentoImpressao;

{$R *.dfm}

procedure TFRelatorioAbastecimento.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFRelatorioAbastecimento.FormDestroy(Sender: TObject);
begin
  FRelatorioAbastecimento := nil;
end;

procedure TFRelatorioAbastecimento.btnVisualizarClick(Sender: TObject);
begin
  fRelatorioAbastecimentoImpressao.Query.Close();
  fRelatorioAbastecimentoImpressao.Query.SQL.Clear();

  fRelatorioAbastecimentoImpressao.Query.SQL.Add('SELECT DATA,                             ');
  fRelatorioAbastecimentoImpressao.Query.SQL.Add('       TANQUE.DESCRICAO AS TANQUE,       ');
  fRelatorioAbastecimentoImpressao.Query.SQL.Add('       BOMBA.DESCRICAO AS BOMBA,         ');
  fRelatorioAbastecimentoImpressao.Query.SQL.Add('       VALOR_ABASTECIMENTO               ');
  fRelatorioAbastecimentoImpressao.Query.SQL.Add('  FROM ABASTECIMENTO                     ');
  fRelatorioAbastecimentoImpressao.Query.SQL.Add('  INNER JOIN BOMBA                       ');
  fRelatorioAbastecimentoImpressao.Query.SQL.Add('     ON BOMBA.ID = ABASTECIMENTO.BOMBA_ID');
  fRelatorioAbastecimentoImpressao.Query.SQL.Add('  INNER JOIN TANQUE                      ');
  fRelatorioAbastecimentoImpressao.Query.SQL.Add('     ON TANQUE.ID = BOMBA.TANQUE_ID      ');
  fRelatorioAbastecimentoImpressao.Query.SQL.Add(' WHERE DATA >= :DATA_INICIAL             ');
  fRelatorioAbastecimentoImpressao.Query.SQL.Add('   AND DATA <= :DATA_FINAL               ');

  fRelatorioAbastecimentoImpressao.Query.ParamByName('DATA_INICIAL').Value :=
    FormatDateTime('YYYY-MM-DD', dtpDataInicial.Date);
  fRelatorioAbastecimentoImpressao.Query.ParamByName('DATA_FINAL').Value :=
    FormatDateTime('YYYY-MM-DD', dtpDataFinal.Date);

  fRelatorioAbastecimentoImpressao.Query.Open();

  if fRelatorioAbastecimentoImpressao.Query.IsEmpty then
  begin
    ShowMessage('A consulta não obteve resultados');
    fRelatorioAbastecimentoImpressao.Query.Close();
    Exit;
  end;

  fRelatorioAbastecimentoImpressao.QuickRep.DataSet :=
    fRelatorioAbastecimentoImpressao.Query;

  if Sender = btnVisualizar then
    fRelatorioAbastecimentoImpressao.QuickRep.Preview()
  else if Sender = btnImprimir then
    fRelatorioAbastecimentoImpressao.QuickRep.Print();

  fRelatorioAbastecimentoImpressao.Query.Close();
end;

procedure TFRelatorioAbastecimento.btnImprimirClick(Sender: TObject);
begin
  btnVisualizarClick(Sender);
end;

end.
