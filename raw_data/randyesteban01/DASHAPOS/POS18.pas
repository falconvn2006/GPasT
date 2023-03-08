unit POS18;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ToolWin, ComCtrls, Grids, DBGrids, DB, ADODB, StdCtrls,
  ExtCtrls;

type
  TfrmDesgloce = class(TForm)
    ToolBar1: TToolBar;
    btsalir: TSpeedButton;
    DBGrid1: TDBGrid;
    QMontos: TADOQuery;
    QMontosmonto: TBCDField;
    dsMontos: TDataSource;
    QMontoscantidad: TIntegerField;
    QMontosValor: TFloatField;
    btimprimir: TSpeedButton;
    Panel1: TPanel;
    lbtotal: TStaticText;
    procedure QMontosCalcFields(DataSet: TDataSet);
    procedure btsalirClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure DBGrid1ColEnter(Sender: TObject);
    procedure DBGrid1Enter(Sender: TObject);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure QMontosAfterInsert(DataSet: TDataSet);
    procedure QMontosBeforeDelete(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
    procedure btimprimirClick(Sender: TObject);
    procedure QMontosAfterPost(DataSet: TDataSet);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    grabo : integer;
    procedure totalizar;
  end;

var
  frmDesgloce: TfrmDesgloce;

implementation

uses POS01, POS00;

{$R *.dfm}

procedure TfrmDesgloce.QMontosCalcFields(DataSet: TDataSet);
begin
  QMontosValor.Value := QMontosmonto.Value * QMontoscantidad.Value;
end;

procedure TfrmDesgloce.btsalirClick(Sender: TObject);
begin
  grabo := 0;
  Close;
end;

procedure TfrmDesgloce.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then
  begin
    btsalirClick(Self);
    key := #0;
  end;
end;

procedure TfrmDesgloce.DBGrid1ColEnter(Sender: TObject);
begin
  if DBGrid1.SelectedIndex <> 1 then DBGrid1.SelectedIndex := 1;
end;

procedure TfrmDesgloce.DBGrid1Enter(Sender: TObject);
begin
  DBGrid1.SelectedIndex := 1;
end;

procedure TfrmDesgloce.DBGrid1KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then QMontos.Next;
end;

procedure TfrmDesgloce.QMontosAfterInsert(DataSet: TDataSet);
begin
  QMontos.Cancel;
end;

procedure TfrmDesgloce.QMontosBeforeDelete(DataSet: TDataSet);
begin
  Abort;
end;

procedure TfrmDesgloce.FormCreate(Sender: TObject);
begin
  QMontos.Open;
end;

procedure TfrmDesgloce.btimprimirClick(Sender: TObject);
begin
  grabo := 1;
  close;
end;

procedure TfrmDesgloce.totalizar;
var
  punt : tbookmark;
  total : double;
begin
  total := 0;
  punt := QMontos.GetBookmark;
  QMontos.DisableControls;
  QMontos.First;
  while not QMontos.Eof do
  begin
    total := total + QMontosValor.Value;
    QMontos.Next;
  end;
  QMontos.GotoBookmark(punt);
  QMontos.EnableControls;
end;

procedure TfrmDesgloce.QMontosAfterPost(DataSet: TDataSet);
begin
  totalizar;
end;

procedure TfrmDesgloce.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_f2 then btimprimirClick(self);
end;

end.
