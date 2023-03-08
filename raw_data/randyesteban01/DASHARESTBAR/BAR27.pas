unit BAR27;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, ExtCtrls, Buttons, DB, ADODB, ComCtrls,
  DBCtrls;

type
  TfrmConsVentas = class(TForm)
    btclose: TSpeedButton;
    QVentas: TADOQuery;
    dsVentas: TDataSource;
    QVentasNombre: TWideStringField;
    QVentasFacturaID: TIntegerField;
    QVentasFecha: TDateTimeField;
    QVentasExento: TBCDField;
    QVentasGrabado: TBCDField;
    QVentasItbis: TBCDField;
    QVentasDescuento: TBCDField;
    QVentasPropina: TBCDField;
    QVentasTotal: TBCDField;
    QVentasEstatus: TWideStringField;
    QVentasNCF: TWideStringField;
    QVentasCuadrada: TBooleanField;
    GroupBox1: TGroupBox;
    fecha1: TDateTimePicker;
    fecha2: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    btrefresh: TSpeedButton;
    GroupBox2: TGroupBox;
    ckCajero: TCheckBox;
    DBLookupComboBox1: TDBLookupComboBox;
    Label3: TLabel;
    cbcuadre: TComboBox;
    QCajeros: TADOQuery;
    QCajerosUsuarioID: TAutoIncField;
    QCajerosNombre: TWideStringField;
    dsCajeros: TDataSource;
    QVentasrnc: TWideStringField;
    QVentasCliente: TWideStringField;
    QDetalle: TADOQuery;
    QDetalleNombre: TWideStringField;
    QDetalleCantidad: TFloatField;
    QDetallePrecio: TBCDField;
    QDetalleItbis: TBooleanField;
    QDetalleIngrediente: TBooleanField;
    QDetalleDescuento: TBCDField;
    QDetalleCosto: TBCDField;
    dsDetalle: TDataSource;
    QVentasCajaID: TIntegerField;
    QVentasCajeroID: TIntegerField;
    QDetalleConItbis: TStringField;
    QDetalleValor: TFloatField;
    QDetalleVisualizar: TBooleanField;
    Label4: TLabel;
    cbestatus: TComboBox;
    QVentasHora: TDateTimeField;
    QVentasForma: TWideStringField;
    QVentasPagado: TBCDField;
    QVentasDevuelta: TBCDField;
    QVentastipo_Tarjeta: TWideStringField;
    QVentasAutorizacion: TWideStringField;
    QVentasNumero_Tarjeta: TWideStringField;
    QVentasBanco: TWideStringField;
    Panel2: TPanel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    edfacturas: TEdit;
    edexento: TEdit;
    edgrabado: TEdit;
    editbis: TEdit;
    eddescuento: TEdit;
    edpropina: TEdit;
    edtotal: TEdit;
    edcosto: TEdit;
    Timer1: TTimer;
    btanular: TSpeedButton;
    Query1: TADOQuery;
    hora1: TDateTimePicker;
    hora2: TDateTimePicker;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Panel1: TPanel;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    DBGrid3: TDBGrid;
    QProductos: TADOQuery;
    QProductosNombre: TWideStringField;
    QProductosCantidad: TFloatField;
    QProductosPrecio: TFloatField;
    QProductosDescuento: TFloatField;
    dsProductos: TDataSource;
    Memo1: TMemo;
    Memo2: TMemo;
    btimprimir: TSpeedButton;
    QProductosCosto: TFloatField;
    QVentasCosto: TFloatField;
    edefectivo: TEdit;
    Label13: TLabel;
    edtarjeta: TEdit;
    Label14: TLabel;
    edcredito: TEdit;
    Label15: TLabel;
    ckIncIngrediente: TCheckBox;
    procedure btcloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btrefreshClick(Sender: TObject);
    procedure cbcuadreClick(Sender: TObject);
    procedure ckCajeroClick(Sender: TObject);
    procedure DBGrid2DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure QVentasAfterOpen(DataSet: TDataSet);
    procedure QDetalleCalcFields(DataSet: TDataSet);
    procedure QDetalleFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure DBGrid2Enter(Sender: TObject);
    procedure edfacturasEnter(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btanularClick(Sender: TObject);
    procedure btimprimirClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PageControl1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure totalizar;
  end;

var
  frmConsVentas: TfrmConsVentas;

implementation

uses BAR04, BAR12, BAR35, BAR36, BAR01;

{$R *.dfm}

procedure TfrmConsVentas.btcloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmConsVentas.FormCreate(Sender: TObject);
begin
  Memo1.Lines := QVentas.SQL;
  Memo2.Lines := QProductos.SQL;
  
  btclose.Caption    := 'F1'+#13+'SALIR';
  btrefresh.Caption  := 'F2'+#13+'CONSULTAR';
  btanular.Caption   := 'F8'+#13+'ANULAR';
  btimprimir.Caption := 'F4'+#13+'IMPRIMIR';
  fecha1.Date := date;
  fecha2.Date := date;
  hora1.Date  := Date;
  hora2.Date  := Date;
  hora1.Time  := StrToTime('06:00:00');
  hora2.Time  := StrToTime('23:59:59');
end;

procedure TfrmConsVentas.FormActivate(Sender: TObject);
begin
  if not QVentas.Active then
  begin
    QCajeros.Open;;
    DBLookupComboBox1.KeyValue := QCajerosUsuarioID.Value;
  end;
end;

procedure TfrmConsVentas.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssAlt in Shift) and (key = vk_f4) then abort;
  if key = vk_f1 then btcloseClick(Self);
  if key = vk_f2 then btrefreshClick(Self);
  if key = vk_f8 then btanularClick(Self);
  if key = vk_f4 then btimprimirClick(self);
end;

procedure TfrmConsVentas.btrefreshClick(Sender: TObject);
begin
  //Facturas
  PageControl1.ActivePageIndex := 0;
  QVentas.Close;
  QVentas.SQL := Memo1.Lines;

  if ckCajero.Checked then
     QVentas.SQL.Add('and f.CajeroID = '+IntToStr(DBLookupComboBox1.KeyValue));

  case cbcuadre.ItemIndex of
  1: QVentas.SQL.Add('and f.cuadrada = 1');
  2: QVentas.SQL.Add('and f.cuadrada = 0');
  end;

  case cbestatus.ItemIndex of
  1: QVentas.SQL.Add('and f.estatus = '+QuotedStr('ANU'));
  2: QVentas.SQL.Add('and f.estatus = '+QuotedStr('ABI'));
  3: QVentas.SQL.Add('and f.estatus = '+QuotedStr('FAC'));
  end;

  QVentas.SQL.Add('group by u.Nombre, f.FacturaID, f.Fecha, f.Exento, f.Grabado, f.Itbis,');
  QVentas.SQL.Add('f.Descuento, f.Propina, f.Total, f.Estatus, f.NCF, f.Cuadrada,');
  QVentas.SQL.Add('f.rnc, f.Nombre, f.CajaID, f.CajeroID, f.Hora,');
  QVentas.SQL.Add('p.Forma, p.Monto, p.Devuelta, p.tipo_Tarjeta,');
  QVentas.SQL.Add('p.Autorizacion, p.Numero_Tarjeta, p.Banco');
  QVentas.SQL.Add('order by f.FacturaID');

  hora1.Date  := fecha1.Date;
  hora2.Date  := fecha2.Date;

  QVentas.Parameters.ParamByName('fec1').DataType := ftDateTime;
  QVentas.Parameters.ParamByName('fec2').DataType := ftDateTime;
  QVentas.Parameters.ParamByName('fec1').Value := hora1.DateTime;
  QVentas.Parameters.ParamByName('fec2').Value := hora2.DateTime;
  QVentas.Open;

  //Productos
  QProductos.Close;
  QProductos.SQL := Memo2.Lines;

  if ckCajero.Checked then
     QProductos.SQL.Add('and f.CajeroID = '+IntToStr(DBLookupComboBox1.KeyValue));

  if not ckIncIngrediente.Checked then
     QProductos.SQL.Add('and d.Ingrediente = 0');

  case cbcuadre.ItemIndex of
  1: QProductos.SQL.Add('and f.cuadrada = 1');
  2: QProductos.SQL.Add('and f.cuadrada = 0');
  end;

  case cbestatus.ItemIndex of
  1: QProductos.SQL.Add('and f.estatus = '+QuotedStr('ANU'));
  2: QProductos.SQL.Add('and f.estatus = '+QuotedStr('ABI'));
  3: QProductos.SQL.Add('and f.estatus = '+QuotedStr('FAC'));
  end;

  QProductos.SQL.Add('group by d.Nombre');
  QProductos.SQL.Add('order by d.Nombre');

  QProductos.Parameters.ParamByName('fec1').DataType := ftDateTime;
  QProductos.Parameters.ParamByName('fec2').DataType := ftDateTime;
  QProductos.Parameters.ParamByName('fec1').Value := hora1.DateTime;
  QProductos.Parameters.ParamByName('fec2').Value := hora2.DateTime;
  QProductos.Open;

  totalizar;
  DBGrid1.SetFocus;
end;

procedure TfrmConsVentas.cbcuadreClick(Sender: TObject);
begin
  btrefreshClick(self);
end;

procedure TfrmConsVentas.ckCajeroClick(Sender: TObject);
begin
  btrefreshClick(self);
end;

procedure TfrmConsVentas.DBGrid2DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  if QDetalleIngrediente.Value then
  begin
     DBGrid2.canvas.font.Name  := 'Arial';
     DBGrid2.canvas.font.Size  := 6;
     DBGrid2.canvas.font.Color := clBlue;
     if Datacol >= 1 then
        DBGrid2.canvas.font.Color := clWhite
     else
     DBGrid2.canvas.font.Color := clBlue;
     DBGrid2.DefaultDrawcolumnCell(Rect, DataCol, Column, State);
  end;
end;

procedure TfrmConsVentas.QVentasAfterOpen(DataSet: TDataSet);
begin
  if not QDetalle.Active then QDetalle.Open;
end;

procedure TfrmConsVentas.QDetalleCalcFields(DataSet: TDataSet);
begin
  if QDetalleItbis.Value then
    QDetalleConItbis.Value := 'G';

  QDetalleValor.Value := QDetalleCantidad.Value * QDetallePrecio.Value;
end;

procedure TfrmConsVentas.QDetalleFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  //if QDetalleVisualizar.Value = True then Accept := True else Accept := False;
end;

procedure TfrmConsVentas.DBGrid2Enter(Sender: TObject);
begin
  DBGrid1.SetFocus;
end;

procedure TfrmConsVentas.totalizar;
var
   t : tbookmark;
   tfacturas, texento, tgrabado, ttotal, titbis, tdescuento,
   tpropina, tefectivo, ttarjeta, tcredito, tcosto : double;
begin
   t := QVentas.GetBookmark;

   QVentas.DisableControls;
   QVentas.First;

   tfacturas := 0;
   texento   := 0;
   tgrabado  := 0;
   ttotal    := 0;
   titbis    := 0;
   tdescuento:= 0;
   tpropina  := 0;
   tefectivo := 0;
   ttarjeta  := 0;
   tcredito  := 0;
   tcosto    := 0;
   while not QVentas.Eof do
   begin
     tfacturas := tfacturas + 1;
     texento   := texento + QVentasExento.Value;
     tgrabado  := tgrabado + QVentasGrabado.Value;
     ttotal    := ttotal + QVentasTotal.Value;
     titbis    := titbis + QVentasItbis.Value;
     tdescuento:= tdescuento + QVentasDescuento.Value;
     tpropina  := tpropina + QVentasPropina.Value;
     if QVentasForma.Value = 'Efectivo' then
       tefectivo := tefectivo + QVentasTotal.Value - QVentasDevuelta.Value
     else if QVentasForma.Value = 'Tarjeta' then
       ttarjeta := ttarjeta + QVentasTotal.Value
     else if QVentasForma.Value = 'Credito' then
       tcredito := tcredito + QVentasTotal.Value;
     QVentas.Next;
   end;
   QVentas.GotoBookmark(t);
   QVentas.EnableControls;

   QProductos.DisableControls;
   QProductos.First;
   while not QProductos.Eof do
   begin
     QProductos.Next;
     tcosto := tcosto + QProductosCosto.Value;
   end;
   QProductos.First;
   QProductos.EnableControls;

   edfacturas.Text := floattostr(tfacturas);
   edexento.Text   := format('%n',[texento]);
   edgrabado.Text  := format('%n',[tgrabado]);
   editbis.Text    := format('%n',[titbis]);
   eddescuento.Text:= format('%n',[tdescuento]);
   edpropina.Text  := format('%n',[tpropina]);
   edtotal.Text    := format('%n',[ttotal]);
   edcosto.Text    := format('%n',[tcosto]);
   edefectivo.Text := format('%n',[tefectivo]);
   edtarjeta.Text  := format('%n',[ttarjeta]);
   edcredito.Text  := format('%n',[tcredito]); //}
end;

procedure TfrmConsVentas.edfacturasEnter(Sender: TObject);
begin
  DBGrid1.SetFocus;
end;

procedure TfrmConsVentas.Timer1Timer(Sender: TObject);
begin
  CurrencyString := '';
end;

procedure TfrmConsVentas.btanularClick(Sender: TObject);
var
  t : tbookmark;
begin
  if MessageDlg('ESTA SEGURO?',mtConfirmation,[mbyes,mbno],0) = mryes then
  begin
    t := QVentas.GetBookmark;
    
    Query1.Close;
    Query1.SQL.Clear;
    Query1.SQL.Add('update Factura set Estatus = '+QuotedStr('ANU')+',');
    Query1.SQL.Add('Exento = 0, Grabado = 0, Itbis = 0, Total = 0,');
    Query1.SQL.Add('Propina = 0');
    Query1.SQL.Add('where FacturaID = '+inttostr(QVentasFacturaID.Value));
    Query1.ExecSQL;

    Query1.Close;
    Query1.SQL.Clear;
    Query1.SQL.Add('update Factura_Forma_Pago set Monto = 0,');
    Query1.SQL.Add('Devuelta = 0');
    Query1.SQL.Add('where FacturaID = '+inttostr(QVentasFacturaID.Value));
    Query1.ExecSQL;

    Query1.Close;
    Query1.SQL.Clear;
    Query1.SQL.Add('update Factura_Items set Precio = 0,');
    Query1.SQL.Add('Descuento = 0, Costo = 0');
    Query1.SQL.Add('where FacturaID = '+inttostr(QVentasFacturaID.Value));
    Query1.ExecSQL;

    btrefreshClick(Self);

    QVentas.GotoBookmark(t);
  end;
end;

procedure TfrmConsVentas.btimprimirClick(Sender: TObject);
begin
  hora1.Date  := fecha1.Date;
  hora2.Date  := fecha2.Date;
  if PageControl1.ActivePageIndex = 0 then
  begin
    Application.CreateForm(TRVentas, RVentas);
    RVentas.QVentas.SQL := QVentas.SQL;
    RVentas.lbfecha.Caption := 'De '+DateTimeToStr(hora1.DateTime)+' A '+DateTimeToStr(hora2.DateTime);
    RVentas.QVentas.Parameters.ParamByName('fec1').DataType := ftDateTime;
    RVentas.QVentas.Parameters.ParamByName('fec2').DataType := ftDateTime;
    RVentas.QVentas.Parameters.ParamByName('fec1').Value := hora1.DateTime;
    RVentas.QVentas.Parameters.ParamByName('fec2').Value := hora2.DateTime;
    RVentas.QVentas.Open;
    RVentas.PrinterSetup;
    RVentas.Preview;
    RVentas.Destroy;
  end
  else
  begin
    Application.CreateForm(TRVentasProductos, RVentasProductos);
    RVentasProductos.QProductos.SQL := QProductos.SQL;
    RVentasProductos.lbfecha.Caption := 'De '+DateTimeToStr(hora1.DateTime)+' A '+DateTimeToStr(hora2.DateTime);
    RVentasProductos.QProductos.Parameters.ParamByName('fec1').DataType := ftDateTime;
    RVentasProductos.QProductos.Parameters.ParamByName('fec2').DataType := ftDateTime;
    RVentasProductos.QProductos.Parameters.ParamByName('fec1').Value := hora1.DateTime;
    RVentasProductos.QProductos.Parameters.ParamByName('fec2').Value := hora2.DateTime;
    RVentasProductos.QProductos.Open;
    RVentasProductos.PrinterSetup;
    RVentasProductos.Preview;
    RVentasProductos.Destroy;
  end;
end;

procedure TfrmConsVentas.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  frmMain.Panel1.Enabled := true;
  Action := cafree;
end;

procedure TfrmConsVentas.PageControl1Change(Sender: TObject);
begin
  ckIncIngrediente.Visible := PageControl1.TabIndex = 1;
end;

end.
