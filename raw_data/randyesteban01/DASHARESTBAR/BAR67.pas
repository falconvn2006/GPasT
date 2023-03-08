unit BAR67;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, ExtCtrls, Buttons, DB, ADODB, ComCtrls,
  DBCtrls, Mask;

type
  TfrmConsVentasMod = class(TForm)
    btclose: TSpeedButton;
    QVentas: TADOQuery;
    dsVentas: TDataSource;
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
    QDetalle: TADOQuery;
    QDetalleNombre: TWideStringField;
    QDetalleCantidad: TFloatField;
    QDetallePrecio: TBCDField;
    QDetalleItbis: TBooleanField;
    QDetalleIngrediente: TBooleanField;
    QDetalleDescuento: TBCDField;
    QDetalleCosto: TBCDField;
    dsDetalle: TDataSource;
    QDetalleConItbis: TStringField;
    QDetalleValor: TFloatField;
    QDetalleVisualizar: TBooleanField;
    Label4: TLabel;
    cbestatus: TComboBox;
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
    ckIncIngrediente: TCheckBox;
    QTotalVentas: TADOQuery;
    QTotalVentascant: TIntegerField;
    QTotalVentasTExento: TBCDField;
    QTotalVentasTGrabado: TBCDField;
    QTotalVentasTItbis: TBCDField;
    QTotalVentasTDescuento: TBCDField;
    QTotalVentasTPropina: TBCDField;
    QTotalVentasTTotal: TBCDField;
    DataSource1: TDataSource;
    Panel3: TPanel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    DBEdit7: TDBEdit;
    QFPago: TADOQuery;
    QFPagoTEfectivo: TBCDField;
    QFPagoTTarjeta: TBCDField;
    QFPagoTCredito: TBCDField;
    DBEdit8: TDBEdit;
    DataSource2: TDataSource;
    DBEdit9: TDBEdit;
    DBEdit10: TDBEdit;
    mtProductos: TMemo;
    mtVentas: TMemo;
    QTotalProductos: TADOQuery;
    QTotalProductosCantidad: TFloatField;
    QTotalProductosPrecio: TFloatField;
    QTotalProductosDescuento: TBCDField;
    QTotalProductosCosto: TFloatField;
    DBEdit11: TDBEdit;
    DataSource3: TDataSource;
    DBEdit12: TDBEdit;
    DBGrid4: TDBGrid;
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
    QVentasrnc: TWideStringField;
    QVentasCliente: TWideStringField;
    QVentasCajaID: TIntegerField;
    QVentasCajeroID: TIntegerField;
    QVentasHora: TDateTimeField;
    QFormaPago: TADOQuery;
    dsFormaPago: TDataSource;
    QVentasCosto: TFloatField;
    QFormaPagoForma: TWideStringField;
    QFormaPagoPagado: TBCDField;
    QFormaPagoDevuelta: TBCDField;
    QFormaPagotipo_Tarjeta: TWideStringField;
    QFormaPagoAutorizacion: TWideStringField;
    QFormaPagoNumero_Tarjeta: TWideStringField;
    QFormaPagoBanco: TWideStringField;
    pclient: TPanel;
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
    procedure TotalizarVentas(vQ:TADOQuery);
  public
  end;

var
  frmConsVentasMod: TfrmConsVentasMod;

implementation

uses BAR04, BAR12, BAR35, BAR36, BAR01;

{$R *.dfm}

procedure TfrmConsVentasMod.TotalizarVentas(vQ:TADOQuery);
var vSTR, vSTR2 :string;
begin
  vSTR := '';
  vSTR2 := '';
  with vQ do
  begin
    DisableControls;
    First;
    vSTR := fieldbyname('facturaid').AsString;
    vSTR2 := fieldbyname('Cajeroid').AsString;
    Next;
    while not Eof do
    begin
      vSTR := vSTR+','+fieldbyname('facturaid').AsString;
      vSTR2 := vSTR2+','+fieldbyname('Cajeroid').AsString;
      Next;
    end;
    if not IsEmpty then
      begin
        QTotalVentas.Close;
        QTotalVentas.SQL.Clear;
        QTotalVentas.SQL.Add('select count(*) cant,');
        QTotalVentas.SQL.Add('sum(f.Exento) TExento, sum(f.Grabado) TGrabado, sum(f.Itbis) TItbis,');
        QTotalVentas.SQL.Add('sum(f.Descuento) TDescuento, sum(f.Propina) TPropina, sum(f.Total) TTotal');
        QTotalVentas.SQL.Add('from Factura_restbar f');
        QTotalVentas.SQL.Add('where f.FacturaID in ('+vSTR+')');
        QTotalVentas.open;

        QFPago.Close;
        QFPago.SQL.Clear;
        {QFPago.SQL.Add('select');
        QFPago.SQL.Add(' sum(case forma when '+QuotedStr('Efectivo')+' then monto - case when devuelta > 0 then devuelta else 0 end ELSE 0 end) TEfectivo');
        QFPago.SQL.Add(',sum(case forma when '+QuotedStr('Tarjeta') +' then monto ELSE 0 end) TTarjeta');
        QFPago.SQL.Add('from restbar_factura_forma_pago fp');
        QFPago.SQL.Add('where fp.FacturaID in ('+vSTR+')');
        QFPago.SQL.Add('and fp.CajeroID in ('+vSTR2+')');
         }
        QFPago.SQL.Add('select isnull(sum(case forma when '+QuotedStr('Efectivo')+' then monto - case when devuelta > 0 then devuelta else 0 end ELSE 0 end),0) TEfectivo');
        QFPago.SQL.Add(',isnull(sum(case forma when '+QuotedStr('Tarjeta')+' then monto ELSE 0 end),0) TTarjeta,');
        QFPago.SQL.Add('(select isnull(sum(total),0) from Factura_RestBar where credito = 1 and FacturaID in ('+vSTR+')');
        QFPago.SQL.Add('and CajeroID in ('+vSTR2+')) TCredito');
        QFPago.SQL.Add('from restbar_factura_forma_pago fp');
        QFPago.SQL.Add('where fp.FacturaID in ('+vSTR+')');
        QFPago.SQL.Add('and fp.CajeroID in ('+vSTR2+')');
        QFPago.Open;
      end;
    EnableControls;
  end;
end;

procedure TfrmConsVentasMod.btcloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmConsVentasMod.FormCreate(Sender: TObject);
begin
  Memo1.Lines        := QVentas.SQL;
  Memo2.Lines        := QProductos.SQL;
  mtVentas.Lines     := QTotalVentas.SQL;
  mtProductos.Lines  := QTotalProductos.SQL;
  QFormaPago.Open;

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

procedure TfrmConsVentasMod.FormActivate(Sender: TObject);
begin
//  if not QVentas.Active then
//  begin
    QCajeros.Close;
    QCajeros.Open;;
    DBLookupComboBox1.KeyValue := QCajerosUsuarioID.Value;
  //end;
end;

procedure TfrmConsVentasMod.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssAlt in Shift) and (key = vk_f4) then abort;
  if key = vk_f1 then btcloseClick(Self);
  if key = vk_f2 then btrefreshClick(Self);
  if key = vk_f8 then btanularClick(Self);
  if key = vk_f4 then btimprimirClick(self);
end;

procedure TfrmConsVentasMod.btrefreshClick(Sender: TObject);
begin
  //Facturas
  PageControl1.ActivePageIndex := 0;
  QVentas.Close;
  QVentas.SQL := Memo1.Lines;

  if (ckCajero.Checked)AND (DBLookupComboBox1.KeyValue > 0) then
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

{  QVentas.SQL.Add('group by u.Nombre, f.FacturaID, f.Fecha, f.Exento, f.Grabado, f.Itbis,');
  QVentas.SQL.Add('f.Descuento, f.Propina, f.Total, f.Estatus, f.NCF, f.Cuadrada,');
  QVentas.SQL.Add('f.rnc, f.Nombre, f.CajaID, f.CajeroID, f.Hora,');
  QVentas.SQL.Add('p.Forma, p.Monto, p.Devuelta, p.tipo_Tarjeta,');
  QVentas.SQL.Add('p.Autorizacion, p.Numero_Tarjeta, p.Banco');   //}
  QVentas.SQL.Add('order by f.FacturaID');

  hora1.Date  := fecha1.Date;
  hora2.Date  := fecha2.Date;

  QVentas.Parameters.ParamByName('fec1').DataType := ftDateTime;
  QVentas.Parameters.ParamByName('fec2').DataType := ftDateTime;
  QVentas.Parameters.ParamByName('fec1').Value := hora1.DateTime;
  QVentas.Parameters.ParamByName('fec2').Value := hora2.DateTime;
  QVentas.Open;

  TotalizarVentas(QVentas);

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
//--------------------------
  //Total Productos
  QTotalProductos.Close;
  QTotalProductos.SQL := mtProductos.Lines;

  if ckCajero.Checked then
     QTotalProductos.SQL.Add('and f.CajeroID = '+IntToStr(DBLookupComboBox1.KeyValue));

  if not ckIncIngrediente.Checked then
     QTotalProductos.SQL.Add('and d.Ingrediente = 0');

  case cbcuadre.ItemIndex of
  1: QTotalProductos.SQL.Add('and f.cuadrada = 1');
  2: QTotalProductos.SQL.Add('and f.cuadrada = 0');
  end;

  case cbestatus.ItemIndex of
  1: QTotalProductos.SQL.Add('and f.estatus = '+QuotedStr('ANU'));
  2: QTotalProductos.SQL.Add('and f.estatus = '+QuotedStr('ABI'));
  3: QTotalProductos.SQL.Add('and f.estatus = '+QuotedStr('FAC'));
  end;

  QTotalProductos.Parameters.ParamByName('fec1').DataType := ftDateTime;
  QTotalProductos.Parameters.ParamByName('fec2').DataType := ftDateTime;
  QTotalProductos.Parameters.ParamByName('fec1').Value := hora1.DateTime;
  QTotalProductos.Parameters.ParamByName('fec2').Value := hora2.DateTime;
  QTotalProductos.Open;

  DBGrid1.SetFocus;
end;

procedure TfrmConsVentasMod.cbcuadreClick(Sender: TObject);
begin
  btrefreshClick(self);
end;

procedure TfrmConsVentasMod.ckCajeroClick(Sender: TObject);
begin
  btrefreshClick(self);
end;

procedure TfrmConsVentasMod.DBGrid2DrawColumnCell(Sender: TObject;
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

procedure TfrmConsVentasMod.QVentasAfterOpen(DataSet: TDataSet);
begin
  if not QDetalle.Active then QDetalle.Open;
end;

procedure TfrmConsVentasMod.QDetalleCalcFields(DataSet: TDataSet);
begin
  if QDetalleItbis.Value then
    QDetalleConItbis.Value := 'G';

  QDetalleValor.Value := QDetalleCantidad.Value * QDetallePrecio.Value;
end;

procedure TfrmConsVentasMod.QDetalleFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  //if QDetalleVisualizar.Value = True then Accept := True else Accept := False;
end;

procedure TfrmConsVentasMod.DBGrid2Enter(Sender: TObject);
begin
  DBGrid1.SetFocus;
end;

procedure TfrmConsVentasMod.edfacturasEnter(Sender: TObject);
begin
  DBGrid1.SetFocus;
end;

procedure TfrmConsVentasMod.Timer1Timer(Sender: TObject);
begin
  CurrencyString := '';
end;

procedure TfrmConsVentasMod.btanularClick(Sender: TObject);
var
  t : tbookmark;
begin
  if MessageDlg('ESTA SEGURO?',mtConfirmation,[mbyes,mbno],0) = mryes then
  begin
    t := QVentas.GetBookmark;

    Query1.Close;
    Query1.SQL.Clear;
    Query1.SQL.Add('update Factura_Restbar set Estatus = '+QuotedStr('ANU')+',');
    Query1.SQL.Add('Exento = 0, Grabado = 0, Itbis = 0, Total = 0,');
    Query1.SQL.Add('Propina = 0');
    Query1.SQL.Add('where FacturaID = '+inttostr(QVentasFacturaID.Value));
    Query1.ExecSQL;

    Query1.Close;
    Query1.SQL.Clear;
    Query1.SQL.Add('update restbar_Factura_Forma_Pago set Monto = 0,');
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

procedure TfrmConsVentasMod.btimprimirClick(Sender: TObject);
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

procedure TfrmConsVentasMod.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  frmMain.Panel1.Enabled := true;
  Action := cafree;
end;

procedure TfrmConsVentasMod.PageControl1Change(Sender: TObject);
begin
  ckIncIngrediente.Visible := PageControl1.TabIndex = 1;
end;

end.
