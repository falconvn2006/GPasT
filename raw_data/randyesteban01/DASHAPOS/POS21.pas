unit POS21;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ToolWin, ComCtrls, Grids, DBGrids, DB, ADODB;

type
  TfrmBuscaTemporal = class(TForm)
    ToolBar1: TToolBar;
    btsalir: TSpeedButton;
    btconsultar: TSpeedButton;
    DBGrid1: TDBGrid;
    QTicket: TADOQuery;
    QTicketticket: TIntegerField;
    QTicketfecha_hora: TDateTimeField;
    QTicketfecha: TDateTimeField;
    QTickettotal: TBCDField;
    QTicketitbis: TBCDField;
    dsTicket: TDataSource;
    QDetalle: TADOQuery;
    QDetalleusu_codigo: TIntegerField;
    QDetallefecha: TDateTimeField;
    QDetalleticket: TIntegerField;
    QDetallesecuencia: TIntegerField;
    QDetallehora: TStringField;
    QDetalleproducto: TIntegerField;
    QDetalledescripcion: TStringField;
    QDetallecantidad: TBCDField;
    QDetalleprecio: TBCDField;
    QDetalleempaque: TStringField;
    QDetalleitbis: TBCDField;
    QDetalleCosto: TBCDField;
    QDetalleValor: TFloatField;
    QDetallecaja: TIntegerField;
    QDetallePrecioItbis: TFloatField;
    QDetalleCalcItbis: TFloatField;
    QDetalleExcento: TStringField;
    QDetalledescuento: TBCDField;
    QDetalledevuelta: TBCDField;
    QDetalleTotalDescuento: TFloatField;
    QDetalleTotalPrecio: TFloatField;
    QDetalleRealizo_Oferta: TStringField;
    QDetalleOferta: TBCDField;
    dsDetalle: TDataSource;
    DBGrid2: TDBGrid;
    QTicketusu_codigo: TIntegerField;
    QTicketcaja: TIntegerField;
    procedure QDetalleCalcFields(DataSet: TDataSet);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btsalirClick(Sender: TObject);
    procedure btconsultarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DBGrid2Enter(Sender: TObject);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    seleccion : integer;
  end;

var
  frmBuscaTemporal: TfrmBuscaTemporal;

implementation

uses POS01;

{$R *.dfm}

procedure TfrmBuscaTemporal.QDetalleCalcFields(DataSet: TDataSet);
var
  Venta, NumItbis : Double;
begin
  if QDetalleITBIS.value > 0 then
  begin
    NumItbis := strtofloat(format('%10.2f',[(QDetalleITBIS.value/100)+1]));
    Venta    := strtofloat(format('%10.4f',[(QDetallePRECIO.value)/NumItbis]));

    //showmessage(floattostr(venta));

    QDetalleTotalDescuento.Value := (Venta * QDetalledescuento.Value) / 100;


    Venta := Venta - QDetalleTotalDescuento.Value;

    //showmessage(floattostr(venta));

    QDetalleCalcItbis.value   := strtofloat(format('%10.4f',[((Venta)*
                                 strtofloat(format('%10.2f',[QDetalleITBIS.Value])))/100]));

    QDetalleTotalPrecio.Value := strtofloat(format('%10.4f',[Venta])) +
                    strtofloat(format('%10.2f',[QDetalleCalcItbis.value]));
    QDetallePrecioItbis.value := strtofloat(format('%10.2f',[Venta]));
    QDetalleValor.value       := ((strtofloat(format('%10.2f',[Venta])))+
                                 strtofloat(format('%10.2f',[QDetalleCalcItbis.value])))*
                                 strtofloat(format('%10.2f',[QDetalleCANTIDAD.value]));
  end
  else
  begin
    Venta := strtofloat(format('%10.2f',[QDetallePRECIO.value]));

    QDetalleTotalDescuento.Value := (Venta * QDetalledescuento.Value) / 100;
    Venta := Venta - QDetalleTotalDescuento.Value;

    QDetalleValor.value       := strtofloat(format('%10.2f',[(Venta)*QDetalleCANTIDAD.value]));
    QDetalleTotalPrecio.Value := strtofloat(format('%10.2f',[Venta])) +
                    strtofloat(format('%10.4f',[QDetalleCalcItbis.value]));
    QDetallePrecioItbis.value := strtofloat(format('%10.2f',[Venta]));
    QDetalleCalcItbis.value   := 0;
  end;
  //QDetalleValor.Value := QDetalleprecio.Value * QDetallecantidad.Value;

  if QDetalleitbis.Value >0 then
    QDetalleExcento.Value := ''
  else
    QDetalleExcento.Value := 'E';
end;

procedure TfrmBuscaTemporal.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_escape then btsalirClick(self);
end;

procedure TfrmBuscaTemporal.btsalirClick(Sender: TObject);
begin
  seleccion := 0;
  close;
end;

procedure TfrmBuscaTemporal.btconsultarClick(Sender: TObject);
begin
  seleccion := 1;
  close;
end;

procedure TfrmBuscaTemporal.FormCreate(Sender: TObject);
begin
  QTicket.Parameters
end;

procedure TfrmBuscaTemporal.DBGrid2Enter(Sender: TObject);
begin
  DBGrid1.SetFocus;
end;

procedure TfrmBuscaTemporal.DBGrid1KeyPress(Sender: TObject;
  var Key: Char);
begin
  if key = #13 then btconsultarClick(self);
end;

end.
