unit BAR37;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ComCtrls, StdCtrls, DBCtrls, DB, ADODB, cxControls,
  cxContainer, cxEdit, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar;

type
  TfrmCuadre = class(TForm)
    btclose: TSpeedButton;
    btimprimir: TSpeedButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    QCajeros: TADOQuery;
    QCajerosUsuarioID: TAutoIncField;
    QCajerosNombre: TWideStringField;
    dsCajeros: TDataSource;
    DBLookupComboBox1: TDBLookupComboBox;
    Label3: TLabel;
    Memo1: TMemo;
    hora1: TDateTimePicker;
    fecha1: TDateTimePicker;
    hora2: TDateTimePicker;
    fecha2: TDateTimePicker;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btimprimirClick(Sender: TObject);
    procedure btcloseClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCuadre: TfrmCuadre;

implementation

uses BAR04;

{$R *.dfm}

procedure TfrmCuadre.FormCreate(Sender: TObject);
begin
  Memo1.Width := 400;
  btclose.Caption    := 'F1'+#13+'SALIR';
  btimprimir.Caption := 'F2'+#13+'IMPRIMIR';

  fecha1.Date := date;
  fecha2.Date := date;
  hora1.Date  := Date;
  hora2.Date  := Date;
  hora1.Time  := StrToTime('06:00:00');
  hora2.Time  := StrToTime('23:59:59');

end;

procedure TfrmCuadre.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action := cafree;
end;

procedure TfrmCuadre.btimprimirClick(Sender: TObject);
var
  arch : textfile;
  s, s1, s2, s3, s4, s5, s6, s7 : array[0..100] of char;
  exento, grabado, itbis, propina, descuento, total, efectivo, tarjeta, credito : Double;
  Puerto : string;
  a, cant : integer;
begin
if DBLookupComboBox1.KeyValue < 0 then
   ShowMessage('DEBE SELECCIONAR UN CAJERO')
else begin

  hora1.Date  := fecha1.Date;
  hora2.Date  := fecha2.Date;

  if not FileExists('.\puerto.ini') then
  begin
    assignfile(arch, '.\puerto.ini');
    rewrite(arch);
    writeln(arch,'PRN');
  end
  else
  begin
    assignfile(arch, '.\puerto.ini');
    reset(arch);
    readln(arch, Puerto);
  end;
  closefile(arch);

  assignfile(arch,'.\impcuadre.bat');
  {I-}
  rewrite(arch);
  {I+}
  writeln(arch, 'type '+'.\cuadre.txt > '+Puerto);
  closefile(arch);

  assignfile(arch,'.\cuadre.txt');
  {I-}
  rewrite(arch);
  {I+}
  writeln(arch, dm.centro(dm.QEmpresaNombre.Value));
  memo1.Lines.Clear;
  memo1.Lines.Add(dm.QEmpresaDireccion.Value);
  for a := 0 to memo1.Lines.Count-1 do
  begin
    writeln(arch, dm.centro(memo1.lines[a]));
  end;
  writeln(arch, dm.centro(dm.QEmpresaTelefono.Value));
  writeln(arch, dm.centro('RNC:'+dm.QEmpresaRNC.Value));
  writeln(arch, ' ');
  writeln(arch, dm.centro('*** CUADRE DE CAJA ***'));
  writeln(arch, ' ');
  writeln(arch, dm.centro('De  '+FormatDateTime('dd/mm/yyyy 06:00:00',fecha1.Date)));
  writeln(arch, dm.centro(' Al '+FormatDateTime('dd/mm/yyyy 23:59:59',fecha2.Date)));
  writeln(arch, dm.centro('Cajero: '+DBLookupComboBox1.Text));

  writeln(arch, '----------------------------------------');

  //efectivo
  dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('select sum(monto-devuelta) as total from Factura_RestBar f, RestBar_Factura_Forma_Pago p where f.FacturaID = p.FacturaID');
  dm.Query1.SQL.Add('and f.CajaID = p.CajaID and f.CajeroID = p.CajeroID and f.hora between :fec1');
  dm.Query1.SQL.Add('and :fec2 and f.CajeroID = :caj and p.Forma = '+QuotedStr('Efectivo'));
  dm.Query1.Parameters.ParamByName('fec1').DataType := ftDate;
  dm.Query1.Parameters.ParamByName('fec2').DataType := ftDate;
  dm.Query1.Parameters.ParamByName('caj').Value  := DBLookupComboBox1.KeyValue;
  dm.Query1.Parameters.ParamByName('fec1').Value := hora1.Date;
  dm.Query1.Parameters.ParamByName('fec2').Value := hora2.Date;
  dm.Query1.SQL.SaveToFile('efectivo.txt');
  dm.Query1.Open;
  efectivo := dm.Query1.fieldbyname('total').AsFloat;

  //tarjeta
  dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('select sum(monto) as total from Factura_RestBar f, RestBar_Factura_Forma_Pago p where f.FacturaID = p.FacturaID');
  dm.Query1.SQL.Add('and f.CajaID = p.CajaID and f.CajeroID = p.CajeroID and f.hora between :fec1');
  dm.Query1.SQL.Add('and :fec2 and f.CajeroID = :caj and p.Forma = '+QuotedStr('Tarjeta'));
  dm.Query1.Parameters.ParamByName('fec1').DataType := ftDate;
  dm.Query1.Parameters.ParamByName('fec2').DataType := ftDate;
  dm.Query1.Parameters.ParamByName('caj').Value  := DBLookupComboBox1.KeyValue;
  dm.Query1.Parameters.ParamByName('fec1').Value := hora1.Date;
  dm.Query1.Parameters.ParamByName('fec2').Value := hora2.Date;
  dm.Query1.SQL.SaveToFile('efectivo.txt');
  dm.Query1.Open;
  tarjeta := dm.Query1.fieldbyname('total').AsFloat;

  //Credito
  dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('select sum(monto ) as total from Factura_RestBar f, RestBar_Factura_Forma_Pago p where f.FacturaID = p.FacturaID');
  dm.Query1.SQL.Add('and f.CajaID = p.CajaID and f.CajeroID = p.CajeroID and f.hora between :fec1');
  dm.Query1.SQL.Add('and :fec2 and f.CajeroID = :caj and p.Forma = '+QuotedStr('Credito'));
  dm.Query1.Parameters.ParamByName('fec1').DataType := ftDate;
  dm.Query1.Parameters.ParamByName('fec2').DataType := ftDate;
  dm.Query1.Parameters.ParamByName('caj').Value  := DBLookupComboBox1.KeyValue;
  dm.Query1.Parameters.ParamByName('fec1').Value := hora1.Date;
  dm.Query1.Parameters.ParamByName('fec2').Value := hora2.Date;
  dm.Query1.SQL.SaveToFile('Credito.txt');
  dm.Query1.Open;
  credito := dm.Query1.fieldbyname('total').AsFloat;

  s1:= '';
  FillChar(s1, 18-length('$'+format('%n',[efectivo])), ' ');

  s2:= '';
  FillChar(s2, 18-length('$'+format('%n',[tarjeta])), ' ');

  s3:= '';
  FillChar(s3, 18-length('$'+format('%n',[credito])), ' ');

  writeln(arch, 'TOTAL EFECTIVO  : '+s1+'$'+format('%n',[efectivo]));
  writeln(arch, 'TOTAL TARJETA   : '+s2+'$'+format('%n',[tarjeta]));
  writeln(arch, 'TOTAL CREDITO   : '+s3+'$'+format('%n',[credito]));
  writeln(arch, ' ');

  dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('select count(*) as cant, sum(Exento) as exento,');
  dm.Query1.SQL.Add('sum(Grabado) as grabado, sum(Itbis) as itbis,');
  dm.Query1.SQL.Add('sum(Propina) as propina, sum(Total) as total,');
  dm.Query1.SQL.Add('sum(Descuento) as descuento');
  dm.Query1.SQL.Add('from Factura_RestBar');
  dm.Query1.SQL.Add('where hora between :fec1');
  dm.Query1.SQL.Add('and :fec2 and CajeroID = '+IntToStr(DBLookupComboBox1.KeyValue));
  dm.Query1.Parameters.ParamByName('fec1').DataType := ftDate;
  dm.Query1.Parameters.ParamByName('fec2').DataType := ftDate;
  dm.Query1.Parameters.ParamByName('fec1').Value := hora1.Date;
  dm.Query1.Parameters.ParamByName('fec2').Value := hora2.Date;
  dm.Query1.Open;
  cant      := dm.Query1.fieldbyname('cant').AsInteger;
  exento    := dm.Query1.fieldbyname('exento').AsFloat;
  grabado   := dm.Query1.fieldbyname('grabado').AsFloat;
  itbis     := dm.Query1.fieldbyname('itbis').AsFloat;
  descuento := dm.Query1.fieldbyname('descuento').AsFloat;
  total     := dm.Query1.fieldbyname('total').AsFloat;
  propina   := dm.Query1.fieldbyname('propina').AsFloat;

  s1:= '';
  FillChar(s1, 18-length(inttostr(cant)), ' ');

  s2:= '';
  FillChar(s2, 18-length('$'+format('%n',[exento])), ' ');

  s3:= '';
  FillChar(s3, 18-length('$'+format('%n',[grabado])), ' ');

  s4:= '';
  FillChar(s4, 18-length('$'+format('%n',[itbis])), ' ');

  s5:= '';
  FillChar(s5, 18-length('$'+format('%n',[descuento])), ' ');

  s6:= '';
  FillChar(s6, 18-length('$'+format('%n',[propina])), ' ');

  s7:= '';
  FillChar(s7, 18-length('$'+format('%n',[total])), ' ');

  writeln(arch, 'CANTIDAD DE TKs : '+s1+inttostr(cant));
  writeln(arch, 'TOTAL EXENTO    : '+s2+'$'+format('%n',[exento]));
  writeln(arch, 'TOTAL GRABADO   : '+s3+'$'+format('%n',[grabado]));
  writeln(arch, 'TOTAL DESCUENTO : '+s5+'$'+format('%n',[descuento]));
  writeln(arch, 'TOTAL ITBIS     : '+s4+'$'+format('%n',[itbis]));
  writeln(arch, 'TOTAL PROPINA   : '+s6+'$'+format('%n',[propina]));
  writeln(arch, '----------------------------------------');
  writeln(arch, 'TOTAL EN VENTA  : '+s7+'$'+format('%n',[total]));

  dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('select sum(Monto) as total from RestBar_Desembolso');
  dm.Query1.SQL.Add('where CajeroID = :usu and CajaID = 1');
  dm.Query1.SQL.Add('and Fecha between :fec1 and :fec2');
  dm.Query1.Parameters.ParamByName('fec1').DataType := ftDateTime;
  dm.Query1.Parameters.ParamByName('fec2').DataType := ftDateTime;
  dm.Query1.Parameters.ParamByName('usu').Value  := DBLookupComboBox1.KeyValue;
  dm.Query1.Parameters.ParamByName('fec1').Value := hora1.Date;
  dm.Query1.Parameters.ParamByName('fec2').Value := hora2.Date;
  dm.Query1.Open;

  total := total - dm.Query1.FieldByName('total').AsFloat;

  s6:= '';
  FillChar(s6, 18-length('$'+format('%n',[dm.Query1.FieldByName('total').AsFloat])), ' ');

  s7:= '';
  FillChar(s7, 18-length('$'+format('%n',[total])), ' ');

  writeln(arch, 'TOTAL DESEMBOLSO: '+s6+'$'+format('%n',[dm.Query1.FieldByName('total').AsFloat]));
  writeln(arch, 'TOTAL EN CAJA   : '+s7+'$'+format('%n',[total]));

  closefile(Arch);
  winexec(pchar(ExtractFilePath(Application.ExeName)+'impcuadre.bat'),0);
  end;
end;

procedure TfrmCuadre.btcloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCuadre.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_f1 then btcloseClick(self);
  if key = vk_f2 then btimprimirClick(self);
end;

procedure TfrmCuadre.FormActivate(Sender: TObject);
begin
  if not QCajeros.Active then QCajeros.Open;
end;

end.
