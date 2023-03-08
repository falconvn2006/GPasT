unit BAR45;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, DBCtrls, ComCtrls, Grids, DBGrids, DB, ADODB,
  ExtCtrls;

type
  TfrmConsDev = class(TForm)
    btclose: TSpeedButton;
    btrefresh: TSpeedButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    fecha1: TDateTimePicker;
    fecha2: TDateTimePicker;
    hora1: TDateTimePicker;
    hora2: TDateTimePicker;
    GroupBox2: TGroupBox;
    Label4: TLabel;
    ckCajero: TCheckBox;
    DBLookupComboBox1: TDBLookupComboBox;
    cbestatus: TComboBox;
    DBGrid1: TDBGrid;
    QDevolucion: TADOQuery;
    QDevolucionFecha: TDateTimeField;
    QDevolucionSupervisorID: TIntegerField;
    QDevolucionCajaID: TIntegerField;
    QDevolucionCajeroID: TIntegerField;
    QDevolucionFacturaID: TIntegerField;
    QDevolucionTotal: TBCDField;
    QDevolucionEstatus: TWideStringField;
    QDevolucionNCF: TWideStringField;
    QDevolucionHora: TDateTimeField;
    QDevolucionItbis: TBCDField;
    QDevolucionPropina: TBCDField;
    QDevolucionDescuento: TBCDField;
    QDevolucionNCF_Modifica: TWideStringField;
    dsDevolucion: TDataSource;
    Memo1: TMemo;
    QCajeros: TADOQuery;
    QCajerosUsuarioID: TAutoIncField;
    QCajerosNombre: TWideStringField;
    dsCajeros: TDataSource;
    Query1: TADOQuery;
    Timer1: TTimer;
    QDevolucionDevolucionID: TIntegerField;
    QDevolucionCliente: TWideStringField;
    procedure FormCreate(Sender: TObject);
    procedure btrefreshClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btcloseClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmConsDev: TfrmConsDev;

implementation

uses BAR04;

{$R *.dfm}

procedure TfrmConsDev.FormCreate(Sender: TObject);
begin
  Memo1.Lines := QDevolucion.SQL;

  btclose.Caption    := 'F1'+#13+'SALIR';
  btrefresh.Caption  := 'F2'+#13+'CONSULTAR';
  fecha1.Date := date;
  fecha2.Date := date;
  hora1.Date  := Date;
  hora2.Date  := Date;
  hora1.Time  := StrToTime('06:00:00');
  hora2.Time  := StrToTime('23:59:59');
end;

procedure TfrmConsDev.btrefreshClick(Sender: TObject);
begin
  QDevolucion.Close;
  QDevolucion.SQL := Memo1.Lines;

  if ckCajero.Checked then
     QDevolucion.SQL.Add('and d.CajeroID = '+IntToStr(DBLookupComboBox1.KeyValue));

  case cbestatus.ItemIndex of
  1: QDevolucion.SQL.Add('and d.estatus = '+QuotedStr('ANU'));
  2: QDevolucion.SQL.Add('and d.estatus = '+QuotedStr('EMI'));
  end;

  QDevolucion.SQL.Add('order by d.DevolucionID');

  hora1.Date  := fecha1.Date;
  hora2.Date  := fecha2.Date;

  QDevolucion.Parameters.ParamByName('fec1').DataType := ftDateTime;
  QDevolucion.Parameters.ParamByName('fec2').DataType := ftDateTime;
  QDevolucion.Parameters.ParamByName('fec1').Value := hora1.DateTime;
  QDevolucion.Parameters.ParamByName('fec2').Value := hora2.DateTime;
  
  QDevolucion.Open;
  DBGrid1.SetFocus;
end;

procedure TfrmConsDev.FormActivate(Sender: TObject);
begin
  if not QDevolucion.Active then
  begin
    btrefreshClick(Self);

    QCajeros.Open;
    DBLookupComboBox1.KeyValue := QCajerosUsuarioID.Value;
  end;
end;

procedure TfrmConsDev.Timer1Timer(Sender: TObject);
begin
  CurrencyString := '';
end;

procedure TfrmConsDev.btcloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmConsDev.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssAlt in Shift) and (key = vk_f4) then abort;
  if key = vk_f1 then btcloseClick(Self);
  if key = vk_f2 then btrefreshClick(Self);
end;

end.
