unit POS09;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ToolWin, ComCtrls, Grids, DBGrids, DB, ADODB;

type
  TfrmBuscaProducto = class(TForm)
    ToolBar1: TToolBar;
    btsalir: TSpeedButton;
    btseleccionar: TSpeedButton;
    DBGrid1: TDBGrid;
    QProductos: TADOQuery;
    QProductospro_nombre: TStringField;
    QProductospro_precio1: TBCDField;
    QProductospro_precio2: TBCDField;
    dsProductos: TDataSource;
    QProductospro_roriginal: TStringField;
    QProductospro_codigo: TIntegerField;
    QProductosPrecio: TFloatField;
    QProductospro_precio3: TBCDField;
    QProductospro_precio4: TBCDField;
    QProductosexi_cantidad: TBCDField;
    procedure btsalirClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure QProductosCalcFields(DataSet: TDataSet);
    procedure QProductosBeforeOpen(DataSet: TDataSet);
  private
    { Private declarations }
  public
    Selec : integer;
    Precio : string;
  end;

var
  frmBuscaProducto: TfrmBuscaProducto;

implementation

uses POS01, POS00;

{$R *.dfm}

procedure TfrmBuscaProducto.btsalirClick(Sender: TObject);
begin
  Selec := 0;
  Close;
end;

procedure TfrmBuscaProducto.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_escape then btsalirClick(Self);
end;

procedure TfrmBuscaProducto.DBGrid1KeyPress(Sender: TObject;
  var Key: Char);
begin
  if key = #13 then
  begin
    Selec := 1;
    Close;
  end;
end;

procedure TfrmBuscaProducto.QProductosCalcFields(DataSet: TDataSet);
begin
  if Precio = 'Precio1' then
    QProductosPrecio.Value := QProductospro_precio1.Value + ((QProductospro_precio1.Value * frmmain.porciento)/100)
  else if Precio = 'Precio2' then
    QProductosPrecio.Value := QProductospro_precio2.Value + ((QProductospro_precio2.Value * frmmain.porciento)/100)
  else if Precio = 'Precio3' then
    QProductosPrecio.Value := QProductospro_precio3.Value + ((QProductospro_precio3.Value * frmmain.porciento)/100)
  else if Precio = 'Precio4' then
    QProductosPrecio.Value := QProductospro_precio4.Value + ((QProductospro_precio4.Value * frmmain.porciento)/100);
end;

procedure TfrmBuscaProducto.QProductosBeforeOpen(DataSet: TDataSet);
begin
  QProductos.Parameters.ParamByName('alm').Value := frmMain.almacen;
  QProductos.Parameters.ParamByName('emp').Value := frmMain.empresainv;
end;

end.
