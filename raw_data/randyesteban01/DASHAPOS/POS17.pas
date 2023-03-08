unit POS17;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, ToolWin, StdCtrls, ExtCtrls, DBCtrls, DB,
  ADODB, Grids, DBGrids;

type
  TfrmReporteVentas = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    ToolBar1: TToolBar;
    btsalir: TSpeedButton;
    btimprimir: TSpeedButton;
    cbtipo: TRadioGroup;
    QCajas: TADOQuery;
    QCajascaja: TIntegerField;
    QCajeros: TADOQuery;
    QCajerosusu_codigo: TIntegerField;
    QCajerosusu_nombre: TStringField;
    dsCajeros: TDataSource;
    dsCajas: TDataSource;
    btconsultar: TSpeedButton;
    QGeneral: TADOQuery;
    QGeneralcaja: TIntegerField;
    QGeneralusu_codigo: TIntegerField;
    QGeneralticket: TIntegerField;
    QGeneraltotal: TBCDField;
    QGeneralncf_fijo: TStringField;
    QGeneralncf_secuencia: TBCDField;
    QGeneralitbis: TBCDField;
    QGeneralgrabado: TBCDField;
    QGeneralexcento: TBCDField;
    QGeneralnombre: TStringField;
    QGeneralstatus: TStringField;
    QGeneralfecha_hora: TDateTimeField;
    dsGeneral: TDataSource;
    QGeneralusu_nombre: TStringField;
    QGeneralNCF: TStringField;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    QProductos: TADOQuery;
    dsProductos: TDataSource;
    QProductosdescripcion: TStringField;
    QProductoscantidad: TBCDField;
    QProductosmonto: TBCDField;
    cborden: TComboBox;
    Label5: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    fecha1: TDateTimePicker;
    fecha2: TDateTimePicker;
    hora1: TDateTimePicker;
    hora2: TDateTimePicker;
    DBLookupComboBox1: TDBLookupComboBox;
    DBLookupComboBox2: TDBLookupComboBox;
    ckCaja: TCheckBox;
    ckCajero: TCheckBox;
    GroupBox1: TGroupBox;
    lNombres: TListBox;
    Label3: TLabel;
    edProd: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    lCodigos: TListBox;
    procedure QGeneralCalcFields(DataSet: TDataSet);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btsalirClick(Sender: TObject);
    procedure btconsultarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbtipoClick(Sender: TObject);
    procedure ckCajaClick(Sender: TObject);
    procedure ckCajeroClick(Sender: TObject);
    procedure edProdKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure cbordenClick(Sender: TObject);
    procedure btimprimirClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure RefrescaProducto;
  end;

var
  frmReporteVentas: TfrmReporteVentas;

implementation

uses POS01, POS09, POS00;

{$R *.dfm}

procedure TfrmReporteVentas.QGeneralCalcFields(DataSet: TDataSet);
begin
  if not QGeneralncf_fijo.IsNull then
    QGeneralNCF.Value := QGeneralncf_fijo.Value + FormatFloat('00000000',QGeneralncf_secuencia.Value)
  else
    QGeneralNCF.Value := '';
end;

procedure TfrmReporteVentas.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then
  begin
    btsalirClick(Self);
    key := #0;
  end;
end;

procedure TfrmReporteVentas.btsalirClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmReporteVentas.btconsultarClick(Sender: TObject);
begin
  hora1.Date := fecha1.Date;
  hora2.Date := fecha2.Date;

  //General
  QGeneral.Close;
  QGeneral.SQL.Clear;
  QGeneral.SQL.Add('select m.caja, m.usu_codigo, m.ticket, m.total,');
  QGeneral.SQL.Add('m.ncf_fijo, m.ncf_secuencia, m.itbis,');
  QGeneral.SQL.Add('m.nombre, m.status, m.fecha_hora, u.usu_nombre');
  QGeneral.SQL.Add('from montos_ticket m, usuarios u');
  QGeneral.SQL.Add('where m.usu_codigo = u.usu_codigo');
  QGeneral.SQL.Add('and m.fecha_hora between convert(datetime, :fecha1, 113)');
  QGeneral.SQL.Add('and convert(datetime, :fecha2, 113)');

  if ckCaja.Checked then
     QGeneral.SQL.Add('and m.caja = '+IntToStr(DBLookupComboBox1.KeyValue));

  if ckCajero.Checked then
     QGeneral.SQL.Add('and m.usu_codigo = '+IntToStr(DBLookupComboBox2.KeyValue));

  case cbtipo.ItemIndex of
  1 : QGeneral.SQL.Add('and m.status = '+QuotedStr('FAC'));
  2 : QGeneral.SQL.Add('and m.status = '+QuotedStr('ANU'));
  3 : QGeneral.SQL.Add('and m.status = '+QuotedStr('CAN'));
  4 : QGeneral.SQL.Add('and m.status in ('+QuotedStr('ANU')+','+QuotedStr('CAN')+')');
  end;

  QGeneral.Parameters.ParamByName('fecha1').DataType := ftDateTime;
  QGeneral.Parameters.ParamByName('fecha1').Value    := hora1.DateTime;
  QGeneral.Parameters.ParamByName('fecha2').DataType := ftDateTime;
  QGeneral.Parameters.ParamByName('fecha2').Value    := hora2.DateTime;
  QGeneral.Open;

  RefrescaProducto;
end;

procedure TfrmReporteVentas.FormCreate(Sender: TObject);
begin
  fecha1.Date := Date;
  fecha2.Date := Date;
  hora1.Date  := Date;
  hora2.Date  := Date;
  hora1.Time  := StrToTime('08:00:00');
  hora2.Time  := StrToTime('12:59:59');
end;

procedure TfrmReporteVentas.FormActivate(Sender: TObject);
begin
  if not QCajas.Active then
  begin
    QCajas.Open;
    QCajeros.Open;
    //btconsultarClick(Self);
  end;
end;

procedure TfrmReporteVentas.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_f1 then btconsultarClick(Self);
  if key = vk_f2 then btimprimirClick(Self);
end;

procedure TfrmReporteVentas.cbtipoClick(Sender: TObject);
begin
  btconsultarClick(Self);
end;

procedure TfrmReporteVentas.ckCajaClick(Sender: TObject);
begin
  btconsultarClick(Self);
end;

procedure TfrmReporteVentas.ckCajeroClick(Sender: TObject);
begin
  btconsultarClick(Self);
end;

procedure TfrmReporteVentas.edProdKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_return then
  begin
    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select pro_nombre, pro_codigo from productos');
    dm.Query1.SQL.Add('where emp_codigo = :emp');
    dm.Query1.Parameters.ParamByName('emp').Value := frmMain.empresainv;
    dm.Query1.SQL.Add('and pro_roriginal = '+QuotedStr(Trim(edProd.Text)));
    dm.Query1.Open;
    if dm.Query1.RecordCount > 0 then
    begin
      lNombres.Items.Add(dm.Query1.FieldByName('pro_nombre').Value);
      lCodigos.Items.Add(dm.Query1.FieldByName('pro_codigo').AsString);
    end;
    edProd.Text := '';
    edProd.SetFocus;
  end;
end;

procedure TfrmReporteVentas.BitBtn2Click(Sender: TObject);
begin
  lCodigos.Items.Delete(lNombres.ItemIndex);
  lNombres.Items.Delete(lNombres.ItemIndex);
end;

procedure TfrmReporteVentas.RefrescaProducto;
var
  a : integer;
begin
  //Por Producto
  QProductos.Close;
  QProductos.SQL.Clear;
  QProductos.SQL.Add('select t.descripcion, sum(t.cantidad) as cantidad,');
  QProductos.SQL.Add('sum(t.cantidad*t.precio) as monto');
  QProductos.SQL.Add('from montos_ticket m, ticket t');
  QProductos.SQL.Add('where m.fecha = t.fecha');
  QProductos.SQL.Add('and m.usu_codigo = t.usu_codigo');
  QProductos.SQL.Add('and m.caja = t.caja');
  QProductos.SQL.Add('and m.ticket = t.ticket');
  QProductos.SQL.Add('and m.fecha_hora between convert(datetime, :fecha1, 113)');
  QProductos.SQL.Add('and convert(datetime, :fecha2, 113)');

  if ckCaja.Checked then
     QProductos.SQL.Add('and m.caja = '+IntToStr(DBLookupComboBox1.KeyValue));

  if ckCajero.Checked then
     QProductos.SQL.Add('and m.usu_codigo = '+IntToStr(DBLookupComboBox2.KeyValue));

  if lCodigos.Items.Count > 0 then
    QProductos.SQL.Add('and t.producto in (');
  for a := 0 to lCodigos.Items.Count-1 do
    QProductos.SQL.Add(lCodigos.Items[a]+',');
  if lCodigos.Items.Count > 0 then
    QProductos.SQL.Add(lCodigos.Items[lCodigos.Items.Count-1]+')');

  QProductos.SQL.Add('group by t.descripcion');

  case cborden.ItemIndex of
  0 : QProductos.SQL.Add('order by 1');
  1 : QProductos.SQL.Add('order by 2 DESC');
  2 : QProductos.SQL.Add('order by 3 DESC');
  end;

  QProductos.Parameters.ParamByName('fecha1').DataType := ftDateTime;
  QProductos.Parameters.ParamByName('fecha1').Value    := hora1.DateTime;
  QProductos.Parameters.ParamByName('fecha2').DataType := ftDateTime;
  QProductos.Parameters.ParamByName('fecha2').Value    := hora2.DateTime;
  QProductos.Open;
end;

procedure TfrmReporteVentas.BitBtn1Click(Sender: TObject);
begin
  if Trim(edprod.Text) <> '' then
  begin
    Application.CreateForm(tfrmBuscaProducto, frmBuscaProducto);
    frmBuscaProducto.QProductos.SQL.Clear;
    frmBuscaProducto.QProductos.SQL.Add('select p.pro_nombre, p.pro_precio1, e.exi_cantidad, p.pro_precio2,');
    frmBuscaProducto.QProductos.SQL.Add('p.pro_codigo, p.pro_roriginal, p.pro_servicio, p.pro_precio3, p.pro_precio4');
    frmBuscaProducto.QProductos.SQL.Add('from productos p, existencias e');
    frmBuscaProducto.QProductos.SQL.Add('where p.emp_codigo = e.emp_codigo');
    frmBuscaProducto.QProductos.SQL.Add('and p.pro_codigo = e.pro_codigo');
    frmBuscaProducto.QProductos.SQL.Add('and p.emp_codigo = :emp');
    frmBuscaProducto.QProductos.SQL.Add('and e.alm_codigo = :alm');
    frmBuscaProducto.QProductos.SQL.Add('and p.pro_nombre like '+QuotedStr('%'+edprod.Text+'%'));
    frmBuscaProducto.QProductos.SQL.Add('order by p.pro_nombre');
    frmBuscaProducto.QProductos.Parameters.ParamByName('emp').Value := frmMain.empresainv;
    frmBuscaProducto.QProductos.Open;
    frmBuscaProducto.ShowModal;
    if frmBuscaProducto.Selec = 1 then
    begin
      lNombres.Items.Add(frmBuscaProducto.QProductospro_nombre.Value);
      lCodigos.Items.Add(frmBuscaProducto.QProductospro_codigo.AsString);
    end
    else
      edprod.Text := '';
    frmBuscaProducto.Release;

    RefrescaProducto;
  end;
end;

procedure TfrmReporteVentas.cbordenClick(Sender: TObject);
begin
  RefrescaProducto;
end;

procedure TfrmReporteVentas.btimprimirClick(Sender: TObject);
var
  arch : textfile;
  s, s1 : array[0..100] of char;
begin
  if PageControl1.ActivePageIndex = 0 then
  begin
    assignfile(arch,'.\imprep.bat');
    rewrite(arch);

    writeln(arch, 'type .\reporte.txt > prn');
    closefile(arch);

    assignfile(arch,'.\reporte.txt');
    rewrite(arch);
    writeln(arch, dm.centro(dm.QEmpresaemp_nombre.Value));
    writeln(arch, dm.centro(dm.QEmpresaemp_direccion.Value));
    writeln(arch, dm.centro(dm.QEmpresaEMP_LOCALIDAD.Value));
    writeln(arch, dm.centro(dm.QEmpresaEMP_TELEFONO.Value));
    writeln(arch, dm.centro('RNC:'+dm.QEmpresaEMP_RNC.Value));
    writeln(arch, ' ');
    writeln(arch, dm.centro('REPORTE DE VENTAS'));
    writeln(arch, ' ');
    writeln(arch, 'Desde  : '+DateToStr(fecha1.Date)+' '+TimeToStr(Hora1.Time));
    writeln(arch, 'Hasta  : '+DateToStr(fecha2.Date)+' '+TimeToStr(Hora2.Date));

    if ckCajero.Checked then
    writeln(arch, 'Cajero : '+DBLookupComboBox2.Text)
    else
    writeln(arch, 'Cajero : [TODOS]');

    if ckCaja.Checked then
    writeln(arch, 'Caja   : '+DBLookupComboBox1.Text)
    else
    writeln(arch, 'Caja   : [TODAS]');

    writeln(arch, ' ');

    writeln(arch, '---------------------------------------');
    writeln(arch, 'NOMBRE DEL PRODUCTO               CANT.');
    writeln(arch, '---------------------------------------');

    QProductos.DisableControls;
    while not QProductos.Eof do
    begin
      s := '';
      FillChar(s, 30-length(Trim(QProductosdescripcion.Value)), ' ');
      s1 := '';
      FillChar(s1, 8-length(trim(FORMAT('%n',[QProductoscantidad.Value]))), ' ');

      writeln(arch, copy(Trim(QProductosdescripcion.Value),1,30)+s+' '+s1+FORMAT('%n',[QProductoscantidad.Value]));

      QProductos.Next;
    end;
    QProductos.First;
    QProductos.EnableControls;

    writeln(arch, ' ');
    writeln(arch, ' ');
    writeln(arch, ' ');
    writeln(arch, ' ');
    writeln(arch, ' ');
    writeln(arch, ' ');
    
    closefile(arch);
    winexec('.\imprep.bat',0);
  end;
end;

end.
