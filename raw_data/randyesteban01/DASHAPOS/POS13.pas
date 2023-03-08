unit POS13;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ToolWin, ComCtrls, Grids, DBGrids, DB, ADODB;

type
  TfrmEliminar = class(TForm)
    ToolBar1: TToolBar;
    btsalir: TSpeedButton;
    bteliminar: TSpeedButton;
    dsDetalle: TDataSource;
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
    DBGrid1: TDBGrid;
    btdelregistro: TSpeedButton;
    QProductos: TADOQuery;
    QProductospro_codigo: TIntegerField;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btsalirClick(Sender: TObject);
    procedure QDetalleCalcFields(DataSet: TDataSet);
    procedure bteliminarClick(Sender: TObject);
    procedure btdelregistroClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    cantidad : double;
    Elimino : integer;
  end;

var
  frmEliminar: TfrmEliminar;

implementation

uses POS01, POS00;

{$R *.dfm}

procedure TfrmEliminar.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_escape then btsalirClick(Self);
  if key = vk_f1     then bteliminarClick(Self);
  if key = vk_f2     then btdelregistroClick(Self);
end;

procedure TfrmEliminar.btsalirClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmEliminar.QDetalleCalcFields(DataSet: TDataSet);
var
  Venta, NumItbis : Double;
begin
  if QDetalleITBIS.value > 0 then
  begin
    NumItbis := strtofloat(format('%10.2f',[(QDetalleITBIS.value/100)+1]));
    Venta    := strtofloat(format('%10.4f',[(QDetallePRECIO.value)/NumItbis]));

    QDetallePrecioItbis.value := strtofloat(format('%10.2f',[Venta]));
    QDetalleCalcItbis.value   := strtofloat(format('%10.2f',[((Venta)*
                                 strtofloat(format('%10.2f',[QDetalleITBIS.Value])))/100]));
    {QDetalleValor.value       := ((strtofloat(format('%10.4f',[Venta])))+
                                 strtofloat(format('%10.2f',[QDetalleCalcItbis.value])))*
                                 strtofloat(format('%10.2f',[QDetalleCANTIDAD.value]));}
  end
  else
  begin
    Venta := strtofloat(format('%10.2f',[QDetallePRECIO.value]));
    QDetallePrecioItbis.value := strtofloat(format('%10.2f',[Venta]));
    QDetalleCalcItbis.value   := 0;
    //QDetalleValor.value       := strtofloat(format('%10.2f',[(Venta)*QDetalleCANTIDAD.value]));
  end;
  QDetalleValor.Value := QDetalleprecio.Value * QDetallecantidad.Value;

  if QDetalleitbis.Value >0 then
    QDetalleExcento.Value := ''
  else
    QDetalleExcento.Value := 'E';
end;

procedure TfrmEliminar.bteliminarClick(Sender: TObject);
var
  cant, prod : string;
begin
  prod := InputBox('Eliminando producto','Codigo','');
  if Trim(prod) <> '' then
  begin
    QProductos.Close;
    QProductos.Parameters.ParamByName('cod').Value := Trim(prod);
    QProductos.Parameters.ParamByName('emp').Value := frmMain.empresainv;
    QProductos.Open;
    if QProductos.RecordCount > 0 then
    begin
      if QDetalle.Locate('producto',QProductospro_codigo.Value,[]) then
      begin
        QDetalle.Delete;
        frmMain.DisplayProductoEliminado(QDetalledescripcion.AsString, format('%n',[QDetalleValor.AsFloat]));
        QDetalle.UpdateBatch;
      end;
      Elimino := 2;
    end;
  end
  else
    Elimino := 0;

  Close;
end;

procedure TfrmEliminar.btdelregistroClick(Sender: TObject);
begin
  frmMain.DisplayProductoEliminado(QDetalledescripcion.AsString, format('%n',[QDetalleValor.AsFloat]));
  QDetalle.Delete;
  QDetalle.UpdateBatch;
  Elimino := 2;
end;

end.
