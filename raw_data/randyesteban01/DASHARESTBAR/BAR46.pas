unit BAR46;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, Grids, DBGrids, DB, ADODB;

type
  TfrmBuscaNC = class(TForm)
    btclose: TSpeedButton;
    btrefresh: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    btaceptar: TSpeedButton;
    QDevolucion: TADOQuery;
    QDevolucionFecha: TDateTimeField;
    QDevolucionSupervisorID: TIntegerField;
    QDevolucionCajaID: TIntegerField;
    QDevolucionCajeroID: TIntegerField;
    QDevolucionFacturaID: TIntegerField;
    QDevolucionEstatus: TWideStringField;
    QDevolucionNCF: TWideStringField;
    QDevolucionHora: TDateTimeField;
    QDevolucionItbis: TBCDField;
    QDevolucionPropina: TBCDField;
    QDevolucionDescuento: TBCDField;
    QDevolucionTotal: TBCDField;
    QDevolucionNCF_Modifica: TWideStringField;
    QDevolucionDevolucionID: TIntegerField;
    QDevolucionCliente: TWideStringField;
    dsDevolucion: TDataSource;
    DBGrid1: TDBGrid;
    procedure btcloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btrefreshClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure btaceptarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    acepto : integer;
  end;

var
  frmBuscaNC: TfrmBuscaNC;

implementation

uses BAR04;

{$R *.dfm}

procedure TfrmBuscaNC.btcloseClick(Sender: TObject);
begin
  acepto := 0;
  Close;
end;

procedure TfrmBuscaNC.FormCreate(Sender: TObject);
begin
  btclose.Caption := 'F1'+#13+'SALIR';
  btaceptar.Caption := 'F10'+#13+'ACEPTAR';
  btrefresh.Caption  := 'F2'+#13+'CONSULTAR';
end;

procedure TfrmBuscaNC.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_f1  then btcloseClick(Self);
  if key = vk_f10 then btaceptarClick(Self);
  if key = vk_f2 then btrefreshClick(Self);
end;

procedure TfrmBuscaNC.btrefreshClick(Sender: TObject);
begin
  QDevolucion.Close;
  QDevolucion.Open;
  DBGrid1.SetFocus;
end;

procedure TfrmBuscaNC.SpeedButton1Click(Sender: TObject);
begin
  QDevolucion.DisableControls;
  if not QDevolucion.Bof then
    QDevolucion.Prior;
  QDevolucion.EnableControls;
end;

procedure TfrmBuscaNC.SpeedButton2Click(Sender: TObject);
begin
  QDevolucion.DisableControls;
  if not QDevolucion.Eof then
    QDevolucion.Next;
  QDevolucion.EnableControls;
end;

procedure TfrmBuscaNC.btaceptarClick(Sender: TObject);
begin
  acepto := 1;
  close;
end;

end.
