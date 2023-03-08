unit BAR38;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, Grids, DBGrids, DB, ADODB, ComCtrls, StdCtrls;

type
  TfrmBuscaFactura = class(TForm)
    btclose: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    QFactura: TADOQuery;
    QFacturaNombre: TWideStringField;
    QFacturaFacturaID: TIntegerField;
    QFacturaFecha: TDateTimeField;
    QFacturaExento: TBCDField;
    QFacturaGrabado: TBCDField;
    QFacturaItbis: TBCDField;
    QFacturaDescuento: TBCDField;
    QFacturaPropina: TBCDField;
    QFacturaTotal: TBCDField;
    QFacturaEstatus: TWideStringField;
    QFacturaNCF: TWideStringField;
    QFacturaCuadrada: TBooleanField;
    QFacturarnc: TWideStringField;
    QFacturaCliente: TWideStringField;
    QFacturaCajaID: TIntegerField;
    QFacturaCajeroID: TIntegerField;
    QFacturaHora: TDateTimeField;
    QFacturaForma: TWideStringField;
    QFacturaPagado: TBCDField;
    QFacturaDevuelta: TBCDField;
    QFacturatipo_Tarjeta: TWideStringField;
    QFacturaAutorizacion: TWideStringField;
    QFacturaNumero_Tarjeta: TWideStringField;
    QFacturaBanco: TWideStringField;
    dsVentas: TDataSource;
    DBGrid1: TDBGrid;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    fecha1: TDateTimePicker;
    fecha2: TDateTimePicker;
    hora1: TDateTimePicker;
    hora2: TDateTimePicker;
    btrefresh: TSpeedButton;
    QForma: TADOQuery;
    QFormaCajeroID: TIntegerField;
    QFormaFacturaID: TIntegerField;
    QFormaCajaID: TIntegerField;
    QFormaDetalleID: TIntegerField;
    QFormaForma: TWideStringField;
    QFormaMonto: TBCDField;
    QFormaDevuelta: TBCDField;
    QFormaTipo_Tarjeta: TWideStringField;
    QFormaAutorizacion: TWideStringField;
    QFormaNumero_Tarjeta: TWideStringField;
    QFormaBanco: TWideStringField;
    QDetalle: TADOQuery;
    QDetalleProductoID: TIntegerField;
    QDetalleNombre: TWideStringField;
    QDetallePrecio: TBCDField;
    QDetalleItbis: TBooleanField;
    QDetalleDetalleID: TIntegerField;
    QDetalleConItbis: TStringField;
    QDetalleValor: TFloatField;
    QDetalleCantidad: TFloatField;
    QDetalleFacturaID: TIntegerField;
    QDetalleIngrediente: TBooleanField;
    QDetalleCantidadIngredientes: TIntegerField;
    QDetalleDescuento: TBCDField;
    QDetalleCajeroID: TIntegerField;
    QDetalleVisualizar: TBooleanField;
    QDetalleImprimir: TBooleanField;
    QDetalleCajaID: TIntegerField;
    QDetalleCosto: TBCDField;
    QDetalleTotalDescuento: TFloatField;
    btaceptar: TSpeedButton;
    QFacturacredito: TBooleanField;
    QFacturatiponcf: TIntegerField;
    QFacturamesaid: TIntegerField;
    QDetalleTotales: TADOQuery;
    QDetalleTotalessubTotal: TFloatField;
    QDetalleTotalesdescuentoTotal: TBCDField;
    QDetalleSubTotal: TCurrencyField;
    QDetalleMontoItbis: TCurrencyField;
    QDetalleTotalItbis: TCurrencyField;
    procedure btcloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btrefreshClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btimprimirClick(Sender: TObject);
    procedure QFacturaAfterOpen(DataSet: TDataSet);
    procedure btaceptarClick(Sender: TObject);
    procedure QDetalleCalcFields(DataSet: TDataSet);
    procedure QDetalleBeforeOpen(DataSet: TDataSet);
    procedure QDetalleTotalesBeforeOpen(DataSet: TDataSet);
    procedure QFormaBeforeOpen(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
    acepto : integer;
  end;

var
  frmBuscaFactura: TfrmBuscaFactura;

implementation

uses BAR04;

{$R *.dfm}

procedure TfrmBuscaFactura.btcloseClick(Sender: TObject);
begin
  acepto := 0;
  Close;
end;

procedure TfrmBuscaFactura.FormCreate(Sender: TObject);
begin
  btclose.Caption := 'F1'+#13+'SALIR';
  btaceptar.Caption := 'F10'+#13+'ACEPTAR';
  btrefresh.Caption  := 'F2'+#13+'CONSULTAR';

  fecha1.Date := date;
  fecha2.Date := date;
  hora1.Date  := Date;
  hora2.Date  := Date;
  hora1.Time  := StrToTime('06:00:00');
  hora2.Time  := StrToTime('23:59:59');  
end;

procedure TfrmBuscaFactura.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_f1  then btcloseClick(Self);
  if key = vk_f10 then btaceptarClick(Self);
  if key = vk_f2 then btrefreshClick(Self);
end;

procedure TfrmBuscaFactura.btrefreshClick(Sender: TObject);
begin
  //Facturas
  QFactura.Close;
  hora1.Date  := fecha1.Date;
  hora2.Date  := fecha2.Date;
  QFactura.Parameters.ParamByName('fec1').DataType := ftDateTime;
  QFactura.Parameters.ParamByName('fec2').DataType := ftDateTime;
  QFactura.Parameters.ParamByName('fec1').Value := hora1.DateTime;
  QFactura.Parameters.ParamByName('fec2').Value := hora2.DateTime;
  QFactura.Open;
  DBGrid1.SetFocus;
end;

procedure TfrmBuscaFactura.FormActivate(Sender: TObject);
begin
  if not QFactura.Active then
  begin
    btrefreshClick(Self);
  end;
end;

procedure TfrmBuscaFactura.btimprimirClick(Sender: TObject);
begin
  acepto := 1;
  Close;
end;

procedure TfrmBuscaFactura.QFacturaAfterOpen(DataSet: TDataSet);
begin
  if not QDetalle.Active then
  begin
    QDetalle.Open;
    QForma.Open;
    QDetalleTotales.Open;
  end;
end;

procedure TfrmBuscaFactura.btaceptarClick(Sender: TObject);
begin
  acepto := 1;
  close;
end;

procedure TfrmBuscaFactura.QDetalleCalcFields(DataSet: TDataSet);
var
  Venta, NumItbis : Double;
begin
Venta := 0;
NumItbis := 0;

if QDetalleProductoID.Text <> '' then begin
dm.Query1.Close;
dm.Query1.SQL.Clear;
dm.Query1.SQL.Add('select (cast(case when p.pro_itbis = ''S'' and pro_montoitbis > 0  then pro_montoitbis else 0 end as numeric(18,2))/100)+1 pro_itbis');
dm.Query1.SQL.Add('from Productos P');
dm.Query1.SQL.Add('inner join Parametros PA on p.emp_codigo = pa.emp_codigo');
dm.Query1.SQL.Add('where pro_codigo = '+QDetalleProductoID.Text);
dm.Query1.Open;
NumItbis := DM.Query1.fieldbyname('pro_itbis').Value;
end
else
NumItbis := 0;



  if (NumItbis > 0) and (QDetalleItbis.Value = True) then
  begin
    IF (DM.QParametrospar_itbisincluido.Value = 'True') and (QDetalleItbis.Value = True) then
    Venta    := (QDetallePrecio.value/NumItbis)*QDetalleCantidad.Value else
    Venta    := QDetallePrecio.value*QDetalleCantidad.Value;
    QDetalleConItbis.Value := 'G';
  end
  else
  if (NumItbis > 0)  then
  begin
    IF (DM.QParametrospar_itbisincluido.Value = 'True')  then
    Venta    := (QDetallePrecio.value/NumItbis)*QDetalleCantidad.Value else
    Venta    := QDetallePrecio.value*QDetalleCantidad.Value;
    QDetalleConItbis.Value := 'E';
  end
  else
  begin
    Venta    := (QDetallePrecio.value*QDetalleCantidad.Value);
    QDetalleConItbis.Value := 'E';
  end;
  QDetalleTotalDescuento.Value := (Venta * QDetalleDescuento.Value)/100;
  QDetalleSubTotal.Value := Venta;
  if QDetalleItbis.Value = True then
  QDetalleTotalItbis.Value := (Venta-QDetalleTotalDescuento.Value) * (NumItbis-1) else
  QDetalleTotalItbis.Value := 0;

  QDetalleValor.Value := Round(Venta - QDetalleTotalDescuento.Value + QDetalleTotalItbis.Value);

end;

procedure TfrmBuscaFactura.QDetalleBeforeOpen(DataSet: TDataSet);
begin
QDetalle.Parameters.ParamByName('CajeroID').Value  := QFacturaCajeroID.Value;
QDetalle.Parameters.ParamByName('CajaID').Value    := QFacturaCajaID.Value;
QDetalle.Parameters.ParamByName('FacturaID').Value := QFacturaFacturaID.Value;
end;

procedure TfrmBuscaFactura.QDetalleTotalesBeforeOpen(DataSet: TDataSet);
begin
QDetalleTotales.Parameters.ParamByName('CajeroID').Value  := QFacturaCajeroID.Value;
QDetalleTotales.Parameters.ParamByName('CajaID').Value    := QFacturaCajaID.Value;
QDetalleTotales.Parameters.ParamByName('FacturaID').Value := QFacturaFacturaID.Value;

end;

procedure TfrmBuscaFactura.QFormaBeforeOpen(DataSet: TDataSet);
begin
QForma.Parameters.ParamByName('CajeroID').Value  := QFacturaCajeroID.Value;
QForma.Parameters.ParamByName('CajaID').Value    := QFacturaCajaID.Value;
QForma.Parameters.ParamByName('FacturaID').Value := QFacturaFacturaID.Value;
end;

end.
