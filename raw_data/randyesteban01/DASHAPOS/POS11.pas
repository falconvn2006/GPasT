unit POS11;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ToolWin, ComCtrls, Grids, StdCtrls, DBCtrls, DB, ADODB,
  DBGrids, cxControls, cxContainer, cxEdit, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, uJSON, ECRti_Framework_TLB, OCXFISLib_TLB,iFiscal,Tfhkaif,
  ExtCtrls;

type
  TfrmCuadre = class(TForm)
    ToolBar1: TToolBar;
    btsalir: TSpeedButton;
    btimprimir: TSpeedButton;
    sGrid: TStringGrid;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    DBLookupComboBox1: TDBLookupComboBox;
    DBLookupComboBox2: TDBLookupComboBox;
    Label4: TLabel;
    QCajas: TADOQuery;
    QCajascaja: TIntegerField;
    QCajeros: TADOQuery;
    QCajerosusu_codigo: TIntegerField;
    QCajerosusu_nombre: TStringField;
    dsCajeros: TDataSource;
    SpeedButton1: TSpeedButton;
    QEfectivo: TADOQuery;
    QEfectivoticket: TIntegerField;
    QEfectivopagado: TBCDField;
    QEfectivototal: TBCDField;
    QEfectivoitbis: TBCDField;
    QTarjeta: TADOQuery;
    QTarjetaticket: TIntegerField;
    QTarjetapagado: TBCDField;
    QTarjetatotal: TBCDField;
    QTarjetaitbis: TBCDField;
    QCheque: TADOQuery;
    QChequeticket: TIntegerField;
    QChequepagado: TBCDField;
    QChequetotal: TBCDField;
    QChequeitbis: TBCDField;
    QCredito: TADOQuery;
    QCreditoticket: TIntegerField;
    QCreditopagado: TBCDField;
    QCreditototal: TBCDField;
    QCreditoitbis: TBCDField;
    QCuadre: TADOQuery;
    QCuadrefecha: TDateTimeField;
    QCuadrecaja: TIntegerField;
    QCuadreusu_codigo: TIntegerField;
    QCuadreefectivo_cajero: TBCDField;
    QCuadrecheque_cajero: TBCDField;
    QCuadretarjeta_cajero: TBCDField;
    QCuadreefectivo_total: TBCDField;
    QCuadrecheque_total: TBCDField;
    QCuadretarjeta_total: TBCDField;
    QCuadreefectivo_asignado: TBCDField;
    cktickets: TCheckBox;
    QEfectivoncf_fijo: TStringField;
    QEfectivoncf_secuencia: TBCDField;
    QTarjetancf_fijo: TStringField;
    QTarjetancf_secuencia: TBCDField;
    QChequencf_fijo: TStringField;
    QChequencf_secuencia: TBCDField;
    QEfectivoNCF: TStringField;
    QTarjetaNCF: TStringField;
    QChequeNCF: TStringField;
    QCreditoncf_fijo: TStringField;
    QCreditoncf_secuencia: TBCDField;
    QCreditoNCF: TStringField;
    Label1: TLabel;
    ckproductos: TCheckBox;
    QProductos: TADOQuery;
    QProductosproducto: TIntegerField;
    QProductosdescripcion: TStringField;
    QProductoscantidad: TBCDField;
    dsCajas: TDataSource;
    QCuadrefecha_hora: TDateTimeField;
    QAnulados: TADOQuery;
    QAnuladosticket: TIntegerField;
    QAnuladospagado: TBCDField;
    QAnuladostotal: TBCDField;
    QAnuladositbis: TBCDField;
    QAnuladosncf_fijo: TStringField;
    QAnuladosncf_secuencia: TBCDField;
    QAnuladosncf: TStringField;
    QNCF: TADOQuery;
    QNCFncf_fijo: TStringField;
    QNCFtotal: TBCDField;
    btnPOS: TSpeedButton;
    QBonosClub: TADOQuery;
    QBonosClubticket: TIntegerField;
    QBonosClubpagado: TBCDField;
    QBonosClubtotal: TBCDField;
    QBonosClubitbis: TBCDField;
    QBonosClubncf_fijo: TStringField;
    QBonosClubncf_secuencia: TBCDField;
    QBonosOtros: TADOQuery;
    QBonosOtrosticket: TIntegerField;
    QBonosOtrospagado: TBCDField;
    QBonosOtrostotal: TBCDField;
    QBonosOtrositbis: TBCDField;
    QBonosOtrosncf_fijo: TStringField;
    QBonosOtrosncf_secuencia: TBCDField;
    QBonosClubNCF: TStringField;
    QBonosOtrosNCF: TStringField;
    QCuadrebonosclub_total: TBCDField;
    QCuadrebonosotros_total: TBCDField;
    QDevolucion: TADOQuery;
    QDevolucionticket: TIntegerField;
    QDevolucionpagado: TBCDField;
    QDevoluciontotal: TBCDField;
    QDevolucionitbis: TBCDField;
    QDevolucionncf_fijo: TStringField;
    QDevolucionncf_secuencia: TBCDField;
    QDevolucionNCF: TStringField;
    QCuadredevolucion_total: TBCDField;
    QChequedevuelta: TBCDField;
    Query1: TADOQuery;
    QCuadreSecuencia: TAutoIncField;
    QCuadrecredito_total: TCurrencyField;
    hora1: TDateTimePicker;
    hora2: TDateTimePicker;
    fecha2: TDateTimePicker;
    fecha1: TDateTimePicker;
    btdeno: TSpeedButton;
    pnMsgImpresion: TPanel;
    lblWait: TLabel;
    btnRepDetPinpad: TSpeedButton;
    Edt1: TEdit;
    procedure FormActivate(Sender: TObject);
    procedure btsalirClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure sGridEnter(Sender: TObject);
    procedure sGridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure sGridKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBLookupComboBox1Click(Sender: TObject);
    procedure DBLookupComboBox2Click(Sender: TObject);
    procedure QEfectivoCalcFields(DataSet: TDataSet);
    procedure QTarjetaCalcFields(DataSet: TDataSet);
    procedure QChequeCalcFields(DataSet: TDataSet);
    procedure QCreditoCalcFields(DataSet: TDataSet);
    procedure QAnuladosCalcFields(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure QBonosClubCalcFields(DataSet: TDataSet);
    procedure QBonosOtrosCalcFields(DataSet: TDataSet);
    procedure QDevolucionCalcFields(DataSet: TDataSet);
    procedure btdenoClick(Sender: TObject);
    procedure btnPOSClick(Sender: TObject);
    procedure ImpCCierreCardNet;
    procedure ImpDetTransCardNet;
    Procedure ImpTicketFiscalCardNet(aCopia:byte = 0);
    procedure ImprimirCuadre;
    procedure btimprimirClick(Sender: TObject);
    procedure ImpCuadreNoFiscalEpson(ImpresoraFiscal: TImpresora);
    procedure ImpCuadreNoFiscalBixolon(ImpresoraFiscal: TImpresora);
    procedure btnRepDetPinpadClick(Sender: TObject);
  private
    { Private declarations }
    core : TCore;
      result : string;
      response: String;

      ipLocal: string;
      ipRemote: String;

      timeout : Integer;
      portLocal: Integer;
      portRemote: Integer;
      ID        : Integer;
      vl_lote, vl_loteAMEX   : String;
      
      procedure setLimpiarVariables;
  public
    { Public declarations }
    IP   : String;
    caja : integer;
    RealizoDesgloce, realizo : Boolean;
    TotalDesgloce : DOuble;
    procedure graba;

  end;

var
  frmCuadre: TfrmCuadre;

    arch, ptocaja : textfile;
  s, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11 : array[0..100] of char;
  TFac, MontoItbis, Venta, Efectivo, Tarjeta, Cheque, Credito, TGrabado,
  TExcento, TCancelados, Anulados, MontoExento, BonosClub, BonosOtros, Devolucion, Total : double;
  PuntosPrinc, FactorPrin, Puntos, TotalPuntos, devuelta : Double;
  Msg1, Msg2, Msg3, Msg4, Puerto, forma, tipo_cuadre, Cuadrar_Empresa : String;
  cantcredito, cantcontado, cancelados, boletos, empresa_caja : integer;
  err: integer;

implementation

uses POS01, POS03, POS18, POS00;

{$R *.dfm}

procedure TfrmCuadre.FormActivate(Sender: TObject);
begin
  if not QCajas.Active then
  begin
    QCajas.Open;

    DBLookupComboBox1.KeyValue := Caja;

    QCajeros.Close;
    QCajeros.Parameters.ParamByName('caj').Value  := DBLookupComboBox1.KeyValue;
    QCajeros.Parameters.ParamByName('fec1').DataType := ftDateTime;
    QCajeros.Parameters.ParamByName('fec1').Value    := hora1.Date;
    QCajeros.Parameters.ParamByName('fec2').DataType := ftDateTime;
    QCajeros.Parameters.ParamByName('fec2').Value    := hora2.Date;;
    QCajeros.Open;

    DBLookupComboBox2.KeyValue := QCajerosusu_codigo.Value;

    graba;

    QCuadre.Close;
    QCuadre.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
    QCuadre.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
    QCuadre.Parameters.ParamByName('fec1').DataType := ftDateTime;
    QCuadre.Parameters.ParamByName('fec1').Value    := hora1.Date;
    QCuadre.Parameters.ParamByName('fec2').DataType := ftDateTime;
    QCuadre.Parameters.ParamByName('fec2').Value    := hora2.Date;;
    QCuadre.Open;
    if QCuadre.RecordCount > 0 then
    begin
      sGrid.Cells[1,1] := FloatToStr(QCuadreefectivo_total.Value);
      sGrid.Cells[1,2] := FloatToStr(QCuadretarjeta_total.Value);
      sGrid.Cells[1,3] := FloatToStr(QCuadrecheque_total.Value);
      sGrid.Cells[1,4] := FloatToStr(QCuadrebonosclub_total.Value);
      sGrid.Cells[1,5] := FloatToStr(QCuadrebonosotros_total.Value);
      sGrid.Cells[1,6] := FloatToStr(QCuadredevolucion_total.Value);
      sGrid.Cells[1,7] := FloatToStr(QCuadreefectivo_asignado.Value);
      sGrid.Cells[1,8] := FloatToStr(QCuadrecredito_total.Value);
    end;

    QEfectivo.Close;
    QEfectivo.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
    QEfectivo.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
    QEfectivo.Parameters.ParamByName('fec1').DataType := ftDateTime;
    QEfectivo.Parameters.ParamByName('fec1').Value    := hora1.Date;
    QEfectivo.Parameters.ParamByName('fec2').DataType := ftDateTime;
    QEfectivo.Parameters.ParamByName('fec2').Value    := hora1.Date;
    QEfectivo.Open;

    QCheque.Close;
    QCheque.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
    QCheque.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
    QCheque.Parameters.ParamByName('fec1').DataType := ftDateTime;
    QCheque.Parameters.ParamByName('fec1').Value    := hora1.Date;
    QCheque.Parameters.ParamByName('fec2').DataType := ftDateTime;
    QCheque.Parameters.ParamByName('fec2').Value    := hora2.Date;;
    QCheque.Open;

    QTarjeta.Close;
    QTarjeta.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
    QTarjeta.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
    QTarjeta.Parameters.ParamByName('fec1').DataType := ftDateTime;
    QTarjeta.Parameters.ParamByName('fec1').Value    := hora1.Date;
    QTarjeta.Parameters.ParamByName('fec2').DataType := ftDateTime;
    QTarjeta.Parameters.ParamByName('fec2').Value    := hora2.Date;;
    QTarjeta.Open;

    QCredito.Close;
    QCredito.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
    QCredito.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
    QCredito.Parameters.ParamByName('fec1').DataType := ftDateTime;
    QCredito.Parameters.ParamByName('fec1').Value    := hora1.Date;
    QCredito.Parameters.ParamByName('fec2').DataType := ftDateTime;
    QCredito.Parameters.ParamByName('fec2').Value    := hora2.Date;;
    QCredito.Open;

    QBonosClub.Close;
    QBonosClub.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
    QBonosClub.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
    QBonosClub.Parameters.ParamByName('fec1').DataType := ftDateTime;
    QBonosClub.Parameters.ParamByName('fec1').Value    := hora1.Date;
    QBonosClub.Parameters.ParamByName('fec2').DataType := ftDateTime;
    QBonosClub.Parameters.ParamByName('fec2').Value    := hora2.Date;;
    QBonosClub.Open;

    QBonosOtros.Close;
    QBonosOtros.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
    QBonosOtros.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
    QBonosOtros.Parameters.ParamByName('fec1').DataType := ftDateTime;
    QBonosOtros.Parameters.ParamByName('fec1').Value    := hora1.Date;
    QBonosOtros.Parameters.ParamByName('fec2').DataType := ftDateTime;
    QBonosOtros.Parameters.ParamByName('fec2').Value    := hora2.Date;;
    QBonosOtros.Open;

    QDevolucion.Close;
    QDevolucion.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
    QDevolucion.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
    QDevolucion.Parameters.ParamByName('fec1').DataType := ftDateTime;
    QDevolucion.Parameters.ParamByName('fec1').Value    := hora1.Date;
    QDevolucion.Parameters.ParamByName('fec2').DataType := ftDateTime;
    QDevolucion.Parameters.ParamByName('fec2').Value    := hora2.Date;;
    QDevolucion.Open;
  end;

  sGrid.Cells[1,0] := '       Monto';
  sGrid.Cells[2,0] := '  Diferencia';

  sGrid.Cells[0,1] := 'EFECTIVO';
  sGrid.Cells[0,2] := 'TARJETA';
  sGrid.Cells[0,3] := 'CHEQUE';
  sGrid.Cells[0,4] := 'BONOS CLUB';
  sGrid.Cells[0,5] := 'BONOS OTROS';
  sGrid.Cells[0,6] := 'NOTAS CR';
  sGrid.Cells[0,7] := 'DEPOSITO EFECTIVO';
  sGrid.Cells[0,8] := 'CREDITO';
end;

procedure TfrmCuadre.btsalirClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCuadre.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then
  begin
    btsalirClick(Self);
    key := #0;
  end;
end;

procedure TfrmCuadre.FormCreate(Sender: TObject);
begin
  realizo := false;
  RealizoDesgloce := False;
  fecha1.Date := date;
  fecha2.Date := date;
  hora1.Date  := Date;
  hora2.Date  := Date;
  hora1.Time  := StrToTime('00:00:00');
  hora2.Time  := StrToTime('23:59:59');
  dm.getParametrosPrinterFiscal;

  //Buscar Datos de Veriphone Cardnet
WITH DM.Query1 do begin
  Close;
  SQL.Clear;
  SQL.Add('SELECT IP, PORTCAJA, PORTPOS, TIMEOUT, CAJA FROM VerifoneEnCaja WHERE CAJA ='+QuotedStr(DM.GetIPAddress));
  Open;
  IF not IsEmpty THEN
  BEGIN
  core := TCore.Create(Self);

  ipLocal     := DM.Query1.FieldByName('CAJA').Text;
  portLocal   := DM.Query1.FieldByName('PORTCAJA').Value;
  ipRemote    := DM.Query1.FieldByName('IP').Text;
  portRemote  := DM.Query1.FieldByName('PORTPOS').Value;
  timeout     := DM.Query1.FieldByName('TIMEOUT').Value;

  result := core.SetTimeOut(timeOut);
  result := core.SetLocalEndPoint(ipLocal, portLocal);
  result := core.SetRemoteEndPoint(ipRemote, portRemote);
  btnPOS.Visible := True;
end
ELSE
btnPOS.Visible := False;
end;
end;

procedure TfrmCuadre.SpeedButton1Click(Sender: TObject);
 var
  arch, ptocaja : textfile;
  s, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11 : array[0..100] of char;
  TFac, MontoItbis, Venta, Efectivo, Tarjeta, Cheque, Credito, TGrabado,
  TExcento, TCancelados, Anulados, MontoExento, BonosClub, BonosOtros, Devolucion, Total : double;
  PuntosPrinc, FactorPrin, Puntos, TotalPuntos, devuelta : Double;
  Msg1, Msg2, Msg3, Msg4, Puerto, forma, tipo_cuadre, Cuadrar_Empresa : String;
  cantcredito, cantcontado, cancelados, boletos, empresa_caja : integer;
begin
{  hora1.Date := hora1.Date;
  hora2.Date := hora2.Date;;

  QCuadre.Close;
  QCuadre.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
  QCuadre.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
  QCuadre.Parameters.ParamByName('fec1').DataType := ftDateTime;
  QCuadre.Parameters.ParamByName('fec1').Value    := hora1.Date;
  QCuadre.Parameters.ParamByName('fec2').DataType := ftDateTime;
  QCuadre.Parameters.ParamByName('fec2').Value    := hora2.Date;
  QCuadre.Open;

  sGrid.Cells[1,1] := FloatToStr(QCuadreefectivo_total.Value);
  sGrid.Cells[1,2] := FloatToStr(QCuadretarjeta_total.Value);
  sGrid.Cells[1,3] := FloatToStr(QCuadrecheque_total.Value);
  sGrid.Cells[1,4] := FloatToStr(QCuadrebonosclub_total.Value);
  sGrid.Cells[1,5] := FloatToStr(QCuadrebonosotros_total.Value);
  sGrid.Cells[1,6] := FloatToStr(QCuadredevolucion_total.Value);
  sGrid.Cells[1,7] := FloatToStr(QCuadreefectivo_asignado.Value);
  sGrid.Cells[1,8] := FloatToStr(QCuadrecredito_total.Value);

  sGrid.Cells[2,1] := '';
  sGrid.Cells[2,2] := '';

  QAnulados.Close;
  QAnulados.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
  QAnulados.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
  QAnulados.Parameters.ParamByName('fec1').DataType := ftDateTime;
  QAnulados.Parameters.ParamByName('fec1').Value    := hora1.Date;
  QAnulados.Parameters.ParamByName('fec2').DataType := ftDateTime;
  QAnulados.Parameters.ParamByName('fec2').Value    := hora2.Date;
  QAnulados.Open;

  QEfectivo.Close;
  QEfectivo.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
  QEfectivo.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
  QEfectivo.Parameters.ParamByName('fec1').DataType := ftDateTime;
  QEfectivo.Parameters.ParamByName('fec1').Value    := hora1.Date;
  QEfectivo.Parameters.ParamByName('fec2').DataType := ftDateTime;
  QEfectivo.Parameters.ParamByName('fec2').Value    := hora2.Date;
  QEfectivo.Open;

  QCheque.Close;
  QCheque.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
  QCheque.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
  QCheque.Parameters.ParamByName('fec1').DataType := ftDateTime;
  QCheque.Parameters.ParamByName('fec1').Value    := hora1.Date;
  QCheque.Parameters.ParamByName('fec2').DataType := ftDateTime;
  QCheque.Parameters.ParamByName('fec2').Value    := hora2.Date;
  QCheque.Open;

  QTarjeta.Close;
  QTarjeta.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
  QTarjeta.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
  QTarjeta.Parameters.ParamByName('fec1').DataType := ftDateTime;
  QTarjeta.Parameters.ParamByName('fec1').Value    := hora1.Date;
  QTarjeta.Parameters.ParamByName('fec2').DataType := ftDateTime;
  QTarjeta.Parameters.ParamByName('fec2').Value    := hora2.Date;
  QTarjeta.Open;

  QCredito.Close;
  QCredito.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
  QCredito.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
  QCredito.Parameters.ParamByName('fec1').DataType := ftDateTime;
  QCredito.Parameters.ParamByName('fec1').Value    := hora1.Date;
  QCredito.Parameters.ParamByName('fec2').DataType := ftDateTime;
  QCredito.Parameters.ParamByName('fec2').Value    := hora2.Date;
  QCredito.Open;

  QBonosClub.Close;
  QBonosClub.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
  QBonosClub.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
  QBonosClub.Parameters.ParamByName('fec1').DataType := ftDateTime;
  QBonosClub.Parameters.ParamByName('fec1').Value    := hora1.Date;
  QBonosClub.Parameters.ParamByName('fec2').DataType := ftDateTime;
  QBonosClub.Parameters.ParamByName('fec2').Value    := hora2.Date;
  QBonosClub.Open;

  QBonosOtros.Close;
  QBonosOtros.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
  QBonosOtros.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
  QBonosOtros.Parameters.ParamByName('fec1').DataType := ftDateTime;
  QBonosOtros.Parameters.ParamByName('fec1').Value    := hora1.Date;
  QBonosOtros.Parameters.ParamByName('fec2').DataType := ftDateTime;
  QBonosOtros.Parameters.ParamByName('fec2').Value    := hora2.Date;
  QBonosOtros.Open;

  QDevolucion.Close;
  QDevolucion.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
  QDevolucion.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
  QDevolucion.Parameters.ParamByName('fec1').DataType := ftDateTime;
  QDevolucion.Parameters.ParamByName('fec1').Value    := hora1.Date;
  QDevolucion.Parameters.ParamByName('fec2').DataType := ftDateTime;
  QDevolucion.Parameters.ParamByName('fec2').Value    := hora2.Date;
  QDevolucion.Open;   }

  hora1.Date  := fecha1.Date;
  hora2.Date  := fecha2.Date;
  

  MontoItbis := 0;
  Venta:= 0;
  Efectivo:= 0;
  Tarjeta:= 0;
  Cheque:= 0;
  Credito:= 0;
  

  dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('select emp_codigo, puerto, Tipo_Cuadre, Cuadrar_Empresa from cajas_IP');
  dm.Query1.SQL.Add('where caja = :caj');
  dm.Query1.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
  dm.Query1.Open;
  Puerto := dm.Query1.FieldByName('puerto').AsString;
  tipo_cuadre := dm.Query1.FieldByName('Tipo_Cuadre').AsString;
  Cuadrar_Empresa := dm.Query1.FieldByName('Cuadrar_Empresa').AsString;
  empresa_caja := dm.Query1.FieldByName('emp_codigo').AsInteger;

      if (Cuadrar_Empresa = 'C') and (not realizo) then
  begin
    realizo := true;
    QEfectivo.SQL.Add('and m.emp_codigo = '+inttostr(empresa_caja));
    QCheque.SQL.Add('and m.emp_codigo = '+inttostr(empresa_caja));
    QTarjeta.SQL.Add('and m.emp_codigo = '+inttostr(empresa_caja));
    QCredito.SQL.Add('and m.emp_codigo = '+inttostr(empresa_caja));
    QBonosClub.SQL.Add('and m.emp_codigo = '+inttostr(empresa_caja));
    QBonosOtros.SQL.Add('and m.emp_codigo = '+inttostr(empresa_caja));
  end;

  QAnulados.Close;
  QAnulados.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
  QAnulados.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
  QAnulados.Parameters.ParamByName('fec1').DataType := ftDateTime;
  QAnulados.Parameters.ParamByName('fec1').Value    := hora1.Date;
  QAnulados.Parameters.ParamByName('fec2').DataType := ftDateTime;
  QAnulados.Parameters.ParamByName('fec2').Value    := hora2.Date;
  QAnulados.Open;

  QNCF.Close;
  QNCF.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
  QNCF.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
  QNCF.Parameters.ParamByName('fec1').DataType := ftDateTime;
  QNCF.Parameters.ParamByName('fec1').Value    := hora1.Date;
  QNCF.Parameters.ParamByName('fec2').DataType := ftDateTime;
  QNCF.Parameters.ParamByName('fec2').Value    := hora2.Date;
  QNCF.Open;

  QEfectivo.Close;
  QEfectivo.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
  QEfectivo.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
  QEfectivo.Parameters.ParamByName('fec1').DataType := ftDateTime;
  QEfectivo.Parameters.ParamByName('fec1').Value    := hora1.Date;
  QEfectivo.Parameters.ParamByName('fec2').DataType := ftDateTime;
  QEfectivo.Parameters.ParamByName('fec2').Value    := hora2.Date;
  QEfectivo.Open;

  QCheque.Close;
  QCheque.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
  QCheque.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
  QCheque.Parameters.ParamByName('fec1').DataType := ftDateTime;
  QCheque.Parameters.ParamByName('fec1').Value    := hora1.Date;
  QCheque.Parameters.ParamByName('fec2').DataType := ftDateTime;
  QCheque.Parameters.ParamByName('fec2').Value    := hora2.Date;
  QCheque.Open;

  QTarjeta.Close;
  QTarjeta.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
  QTarjeta.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
  QTarjeta.Parameters.ParamByName('fec1').DataType := ftDateTime;
  QTarjeta.Parameters.ParamByName('fec1').Value    := hora1.Date;
  QTarjeta.Parameters.ParamByName('fec2').DataType := ftDateTime;
  QTarjeta.Parameters.ParamByName('fec2').Value    := hora2.Date;
  QTarjeta.Open;

  QCredito.Close;
  QCredito.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
  QCredito.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
  QCredito.Parameters.ParamByName('fec1').DataType := ftDateTime;
  QCredito.Parameters.ParamByName('fec1').Value    := hora1.Date;
  QCredito.Parameters.ParamByName('fec2').DataType := ftDateTime;
  QCredito.Parameters.ParamByName('fec2').Value    := hora2.Date;
  QCredito.Open;

  QBonosClub.Close;
  QBonosClub.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
  QBonosClub.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
  QBonosClub.Parameters.ParamByName('fec1').DataType := ftDateTime;
  QBonosClub.Parameters.ParamByName('fec1').Value    := hora1.Date;
  QBonosClub.Parameters.ParamByName('fec2').DataType := ftDateTime;
  QBonosClub.Parameters.ParamByName('fec2').Value    := hora2.Date;
  QBonosClub.Open;

  QBonosOtros.Close;
  QBonosOtros.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
  QBonosOtros.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
  QBonosOtros.Parameters.ParamByName('fec1').DataType := ftDateTime;
  QBonosOtros.Parameters.ParamByName('fec1').Value    := hora1.Date;
  QBonosOtros.Parameters.ParamByName('fec2').DataType := ftDateTime;
  QBonosOtros.Parameters.ParamByName('fec2').Value    := hora2.Date;
  QBonosOtros.Open;

  QDevolucion.Close;
  QDevolucion.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
  QDevolucion.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
  QDevolucion.Parameters.ParamByName('fec1').DataType := ftDateTime;
  QDevolucion.Parameters.ParamByName('fec1').Value    := hora1.Date;
  QDevolucion.Parameters.ParamByName('fec2').DataType := ftDateTime;
  QDevolucion.Parameters.ParamByName('fec2').Value    := hora2.Date;
  QDevolucion.Open;



  graba;

  sGrid.Cells[1,1] := FloatToStr(QCuadreefectivo_total.Value);
  sGrid.Cells[1,2] := FloatToStr(QCuadretarjeta_total.Value);
  sGrid.Cells[1,3] := FloatToStr(QCuadrecheque_total.Value);
  sGrid.Cells[1,4] := FloatToStr(QCuadrebonosclub_total.Value);
  sGrid.Cells[1,5] := FloatToStr(QCuadrebonosotros_total.Value);
  sGrid.Cells[1,6] := FloatToStr(QCuadredevolucion_total.Value);
  sGrid.Cells[1,7] := FloatToStr(QCuadreefectivo_asignado.Value);
  sGrid.Cells[1,8] := FloatToStr(QCuadrecredito_total.Value);

  sGrid.Cells[2,1] := '';
  sGrid.Cells[2,2] := '';

end;

procedure TfrmCuadre.sGridEnter(Sender: TObject);
begin
  sGrid.Col := 1;
end;

procedure TfrmCuadre.sGridSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  CanSelect := ACol = 1;
end;

procedure TfrmCuadre.sGridKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    if sGrid.Row <> 5 then
      sGrid.Row := sGrid.Row + 1
    else
      sGrid.Row := 1;
  end;
end;

procedure TfrmCuadre.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_f2 then btimprimirClick(Self);
  if key = vk_f3 then btdenoClick(Self);
end;

procedure TfrmCuadre.DBLookupComboBox1Click(Sender: TObject);
begin
  QCajeros.Close;
  QCajeros.Parameters.ParamByName('caj').Value  := DBLookupComboBox1.KeyValue;
  QCajeros.Parameters.ParamByName('fec1').DataType := ftDateTime;
  QCajeros.Parameters.ParamByName('fec1').Value    := hora1.Date;
  QCajeros.Parameters.ParamByName('fec2').DataType := ftDateTime;
  QCajeros.Parameters.ParamByName('fec2').Value    := hora2.Date;
  QCajeros.Open;

  DBLookupComboBox2.KeyValue := QCajerosusu_codigo.Value;

  SpeedButton1Click(Self);
end;

procedure TfrmCuadre.DBLookupComboBox2Click(Sender: TObject);
begin
  SpeedButton1Click(Sender);
end;

procedure TfrmCuadre.graba;
var
  empresa_caja : integer;
  Cuadrar_Empresa : string;
begin
  hora1.Date := fecha1.Date;
  hora2.Date := fecha2.Date;


  QCuadre.Close;
  QCuadre.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
  QCuadre.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
  QCuadre.Parameters.ParamByName('fec1').DataType := ftDateTime;
  QCuadre.Parameters.ParamByName('fec1').Value    := hora1.Date;
  QCuadre.Parameters.ParamByName('fec2').DataType := ftDateTime;
  QCuadre.Parameters.ParamByName('fec2').Value    := hora2.Date;;
  QCuadre.Open;

  dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('select emp_codigo, puerto, Tipo_Cuadre, Cuadrar_Empresa from cajas_IP');
  dm.Query1.SQL.Add('where caja = :caj');
  dm.Query1.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
  dm.Query1.Open;
  Cuadrar_Empresa := dm.Query1.FieldByName('Cuadrar_Empresa').AsString;
  empresa_caja := dm.Query1.FieldByName('emp_codigo').AsInteger;

 { dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('select');
  dm.Query1.SQL.Add('f.forma, sum((f.pagado-f.devuelta)) as total, sum(f.pagado) as pagado');
  dm.Query1.SQL.Add('from formas_pago_ticket f, montos_ticket m');
  dm.Query1.SQL.Add('where f.fecha = m.fecha');
  dm.Query1.SQL.Add('and f.caja = m.caja');
  dm.Query1.SQL.Add('and f.usu_codigo = m.usu_codigo');
  dm.Query1.SQL.Add('and f.ticket = m.ticket');
  dm.Query1.SQL.Add('and m.fecha_hora between :fec1 and :fec2');
  dm.Query1.SQL.Add('and f.usu_codigo = :usu');
  dm.Query1.SQL.Add('and f.caja = :caj');
  if Cuadrar_Empresa = 'C' then
  dm.Query1.SQL.Add('and m.emp_codigo = '+inttostr(empresa_caja));
  dm.Query1.SQL.Add('group by forma');
  dm.Query1.SQL.Add('order by forma');
  dm.Query1.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
  dm.Query1.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
  dm.Query1.Parameters.ParamByName('fec1').DataType := ftDateTime;
  dm.Query1.Parameters.ParamByName('fec1').Value    := hora1.Date;
  dm.Query1.Parameters.ParamByName('fec2').DataType := ftDateTime;
  dm.Query1.Parameters.ParamByName('fec2').Value    := hora2.Date;
  dm.Query1.Open;
  while not dm.Query1.Eof do
  begin
    if dm.Query1.FieldByName('forma').AsString = 'EFE' then
      sGrid.Cells[1,1] := dm.Query1.FieldByName('total').AsString;
    if dm.Query1.FieldByName('forma').AsString = 'TAR' then
      sGrid.Cells[1,2] := dm.Query1.FieldByName('total').AsString;
    if dm.Query1.FieldByName('forma').AsString = 'CHE' then
      sGrid.Cells[1,3] := dm.Query1.FieldByName('pagado').AsString;
    if dm.Query1.FieldByName('forma').AsString = 'BOC' then
      sGrid.Cells[1,4] := dm.Query1.FieldByName('total').AsString;
    if dm.Query1.FieldByName('forma').AsString = 'OBO' then
      sGrid.Cells[1,5] := dm.Query1.FieldByName('total').AsString;
    if dm.Query1.FieldByName('forma').AsString = 'DEV' then
      sGrid.Cells[1,6] := dm.Query1.FieldByName('pagado').AsString;
    dm.Query1.Next;
  end;  }

  dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('select');
  dm.Query1.SQL.Add('sum((m.total)) as total');
  dm.Query1.SQL.Add('from montos_ticket m');
  dm.Query1.SQL.Add('where m.mov_numero is not null and m.fecha_hora between convert(datetime, :fec1, 113) and convert(datetime, :fec2, 113)');
  dm.Query1.SQL.Add('and m.usu_codigo = :usu');
  dm.Query1.SQL.Add('and m.caja = :caj');
  if Cuadrar_Empresa = 'C' then
  dm.Query1.SQL.Add('and m.emp_codigo = '+inttostr(empresa_caja));
  dm.Query1.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
  dm.Query1.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
  dm.Query1.Parameters.ParamByName('fec1').DataType := ftDateTime;
  dm.Query1.Parameters.ParamByName('fec1').Value    := hora1.Date;
  dm.Query1.Parameters.ParamByName('fec2').DataType := ftDateTime;
  dm.Query1.Parameters.ParamByName('fec2').Value    := hora2.Date;;
  dm.Query1.Open;
  sGrid.Cells[1,8] := dm.Query1.FieldByName('total').AsString;


  if QCuadre.RecordCount = 0 then
    QCuadre.Insert
  else
    QCuadre.Edit;

  if Trim(sGrid.Cells[1,1]) = '' then
    sGrid.Cells[1,1] := '0';

  if Trim(sGrid.Cells[1,2]) = '' then
    sGrid.Cells[1,2] := '0';

  if Trim(sGrid.Cells[1,3]) = '' then
    sGrid.Cells[1,3] := '0';

  if Trim(sGrid.Cells[1,4]) = '' then
    sGrid.Cells[1,4] := '0';

  if Trim(sGrid.Cells[1,5]) = '' then
    sGrid.Cells[1,5] := '0';

  if Trim(sGrid.Cells[1,6]) = '' then
    sGrid.Cells[1,6] := '0';

  if Trim(sGrid.Cells[1,7]) = '' then
    sGrid.Cells[1,7] := '0';

  if Trim(sGrid.Cells[1,8]) = '' then
    sGrid.Cells[1,8] := '0';

  QCuadrefecha.Value             := hora1.Date;
  QCuadrecaja.Value              := DBLookupComboBox1.KeyValue;
  QCuadreusu_codigo.Value        := DBLookupComboBox2.KeyValue;
  QCuadreefectivo_total.Value    := StrToFloat(sGrid.Cells[1,1]);
  QCuadretarjeta_total.Value     := StrToFloat(sGrid.Cells[1,2]);
  QCuadrecheque_total.Value      := StrToFloat(sGrid.Cells[1,3]);
  QCuadrebonosclub_total.Value   := StrToFloat(sGrid.Cells[1,4]);
  QCuadrebonosotros_total.Value  := StrToFloat(sGrid.Cells[1,5]);
  //QCuadreefectivo_asignado.Value := StrToFloat(sGrid.Cells[1,6]);
  QCuadredevolucion_total.Value  := StrToFloat(sGrid.Cells[1,6]);
  QCuadrecredito_total.Value     := StrToFloat(sGrid.Cells[1,8]);

  dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('select sum(isnull(a.efectivo,0)) as Efectivo,');
  dm.Query1.SQL.Add('sum(isnull(a.tarjeta,0)) as Tarjeta,');
  dm.Query1.SQL.Add('sum(isnull(a.cheque,0)) as Cheque,');
  dm.Query1.SQL.Add('sum(isnull(a.bonosclub,0)) as BonosClub,');
  dm.Query1.SQL.Add('sum(isnull(a.bonosotros,0)) as BonosOtros,');
  dm.Query1.SQL.Add('sum(isnull(a.devolucion,0)) as devolucion');
  dm.Query1.SQL.Add('from');
  dm.Query1.SQL.Add('(select');
  dm.Query1.SQL.Add('case f.forma');
  dm.Query1.SQL.Add('  when '+QuotedStr('EFE')+' then (f.pagado-f.devuelta)');
  dm.Query1.SQL.Add('end as efectivo,');
  dm.Query1.SQL.Add('case f.forma');
  dm.Query1.SQL.Add('  when '+QuotedStr('TAR')+' then (f.pagado-f.devuelta)');
  dm.Query1.SQL.Add('end as Tarjeta,');
  dm.Query1.SQL.Add('case f.forma');
  dm.Query1.SQL.Add('  when '+QuotedStr('CHE')+' then f.pagado');
  dm.Query1.SQL.Add('end as Cheque,');
  dm.Query1.SQL.Add('case f.forma');
  dm.Query1.SQL.Add('  when '+QuotedStr('DEV')+' then f.pagado');
  dm.Query1.SQL.Add('end as Devolucion,');
  dm.Query1.SQL.Add('case f.forma');
  dm.Query1.SQL.Add('  when '+QuotedStr('BOC')+' then f.pagado');
  dm.Query1.SQL.Add('end as BonosClub,');
  dm.Query1.SQL.Add('case f.forma');
  dm.Query1.SQL.Add('  when '+QuotedStr('OBO')+' then f.pagado');
  dm.Query1.SQL.Add('end as BonosOtros');
  dm.Query1.SQL.Add('from');
  dm.Query1.SQL.Add('formas_pago_ticket f, montos_ticket m ');
  dm.Query1.SQL.Add('where f.fecha = m.fecha and f.caja = m.caja and f.usu_codigo = m.usu_codigo');
  dm.Query1.SQL.Add('and f.ticket = m.ticket  and f.credito <> ''True'' ');
  dm.Query1.SQL.Add('and m.fecha_hora between convert(datetime, :fec1, 113) and convert(datetime, :fec2, 113)');
  dm.Query1.SQL.Add('and m.status = ''FAC''');
  dm.Query1.SQL.Add('and f.usu_codigo = :usu');
  if Cuadrar_Empresa = 'C' then
     dm.Query1.SQL.Add('and m.emp_codigo = '+inttostr(empresa_caja));
  dm.Query1.SQL.Add('and f.caja = :caj) a');

  dm.Query1.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
  dm.Query1.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
  dm.Query1.Parameters.ParamByName('fec1').DataType := ftDateTime;
  dm.Query1.Parameters.ParamByName('fec1').Value    := hora1.Date;
  dm.Query1.Parameters.ParamByName('fec2').DataType := ftDateTime;
  dm.Query1.Parameters.ParamByName('fec2').Value    := hora2.Date;;
  dm.Query1.Open;

  QCuadreefectivo_total.Value   := dm.Query1.FieldByName('efectivo').AsFloat;
  QCuadrecheque_total.Value     := dm.Query1.FieldByName('cheque').AsFloat;
  QCuadretarjeta_total.Value    := dm.Query1.FieldByName('tarjeta').AsFloat;
  QCuadrebonosclub_total.Value  := dm.Query1.FieldByName('bonosclub').AsFloat;
  QCuadrebonosclub_total.Value  := dm.Query1.FieldByName('bonosotros').AsFloat;
//  QCuadredevolucion_total.Value := dm.Query1.FieldByName('Devolucion').AsFloat;
  QCuadrecredito_total.Value    := dm.Query1.FieldByName('bonosotros').AsFloat;
  QCuadrefecha_hora.Value       := Now;

  dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('select');
  dm.Query1.SQL.Add('sum((m.total)) as total');
  dm.Query1.SQL.Add('from montos_ticket m');
  dm.Query1.SQL.Add('where m.mov_numero is not null and m.fecha_hora between convert(datetime, :fec1, 113) and convert(datetime, :fec2, 113)');
  dm.Query1.SQL.Add('and m.usu_codigo = :usu');
  dm.Query1.SQL.Add('and m.caja = :caj');
  if Cuadrar_Empresa = 'C' then
  dm.Query1.SQL.Add('and m.emp_codigo = '+inttostr(empresa_caja));
  dm.Query1.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
  dm.Query1.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
  dm.Query1.Parameters.ParamByName('fec1').DataType := ftDateTime;
  dm.Query1.Parameters.ParamByName('fec1').Value    := hora1.Date;
  dm.Query1.Parameters.ParamByName('fec2').DataType := ftDateTime;
  dm.Query1.Parameters.ParamByName('fec2').Value    := hora2.Date;
  dm.Query1.Open;
  if not dm.Query1.FieldByName('total').IsNull then
  QCuadrecredito_total.Value := dm.Query1.FieldByName('total').Value else
  QCuadrecredito_total.Value := 0;

  QCuadre.Post;
  QCuadre.UpdateBatch;
end;

procedure TfrmCuadre.QEfectivoCalcFields(DataSet: TDataSet);
begin
  if not QEfectivoncf_fijo.IsNull then
    QEfectivoNCF.Value := QEfectivoncf_fijo.Value + FormatFloat('00000000',QEfectivoncf_secuencia.Value)
  else
    QEfectivoNCF.Value := '';
end;

procedure TfrmCuadre.QTarjetaCalcFields(DataSet: TDataSet);
begin
  if not QTarjetancf_fijo.IsNull then
    QTarjetaNCF.Value := QTarjetancf_fijo.Value + FormatFloat('00000000',QTarjetancf_secuencia.Value)
  else
    QTarjetaNCF.Value := '';
end;

procedure TfrmCuadre.QChequeCalcFields(DataSet: TDataSet);
begin
  if not QChequencf_fijo.IsNull then
    QChequeNCF.Value := QChequencf_fijo.Value + FormatFloat('00000000',QChequencf_secuencia.Value)
  else
    QChequeNCF.Value := '';
end;

procedure TfrmCuadre.QCreditoCalcFields(DataSet: TDataSet);
begin
  if not QCreditoncf_fijo.IsNull then
    QCreditoNCF.Value := QCreditoncf_fijo.Value + FormatFloat('00000000',QCreditoncf_secuencia.Value)
  else
    QCreditoNCF.Value := '';
end;

procedure TfrmCuadre.QAnuladosCalcFields(DataSet: TDataSet);
begin
  if not QAnuladosncf_fijo.IsNull then
    QAnuladosncf.Value := QAnuladosncf_fijo.Value + FormatFloat('00000000',QAnuladosncf_secuencia.Value)
  else
    QAnuladosncf.Value := '';
end;

procedure TfrmCuadre.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if TotalDesgloce > 0 then frmDesgloce.Destroy;
end;

procedure TfrmCuadre.QBonosClubCalcFields(DataSet: TDataSet);
begin
  if not QBonosClubncf_fijo.IsNull then
    QBonosClubNCF.Value := QAnuladosncf_fijo.Value + FormatFloat('00000000',QBonosClubncf_secuencia.Value)
  else
    QBonosClubNCF.Value := '';
end;

procedure TfrmCuadre.QBonosOtrosCalcFields(DataSet: TDataSet);
begin
  if not QBonosOtrosNCF_Fijo.IsNull then
    QBonosOtrosNCF.Value := QAnuladosncf_fijo.Value + FormatFloat('00000000',QBonosOtrosncf_secuencia.Value)
  else
    QBonosOtrosNCF.Value := '';
end;

procedure TfrmCuadre.QDevolucionCalcFields(DataSet: TDataSet);
begin
  if not QDevolucionncf_fijo.IsNull then
    QDevolucionNCF.Value := QDevolucionncf_fijo.Value + FormatFloat('00000000',QDevolucionncf_secuencia.Value)
  else
    QDevolucionNCF.Value := '';
end;

procedure TfrmCuadre.btdenoClick(Sender: TObject);
begin
  RealizoDesgloce := False;
  if TotalDesgloce = 0 then Application.CreateForm(tfrmDesgloce, frmDesgloce);
  frmDesgloce.ShowModal;
  TotalDesgloce := 0;
  frmDesgloce.QMontos.First;
  while not frmDesgloce.QMontos.Eof do
  begin
    TotalDesgloce := TotalDesgloce + frmDesgloce.QMontosValor.Value;
    frmDesgloce.QMontos.Next;
  end;
  if TotalDesgloce > 0 then
    RealizoDesgloce := True;
end;

procedure TfrmCuadre.btnPOSClick(Sender: TObject);
var
  b : myJSONItem;

begin
 if MessageDlg('DESEA EJECUTAR EL CIERRE',mtConfirmation,[mbyes, mbno],0) = mryes then
  begin
    pnMsgImpresion.visible :=true;
    lblWait.Caption:='Generando Cierre Cardnet...';
    Application.ProcessMessages();
    response := core.Initialice;
    response := core.ProcessClose();
      //response := Edt1.Text;
      b := myJSONItem.Create;
      b.Code :=  response;
      dm.GrabaLogCardNet(DM.QEmpresaemp_codigo.Value,1,dm.Usuario,-1,response,'C','T',-1,-1);
      if Length(response)>=180 then begin
      dm.adoMultiUso.Close;
      dm.adoMultiUso.SQL.Clear;
      dm.adoMultiUso.SQL.Add('INSERT INTO CierreCardNet (IDVerif,  FechaCierre, Lote, responde, usu_codigo)');
      dm.adoMultiUso.SQL.Add('SELECT :ID,  getdate(), :lote, :responde, :usu');
      dm.adoMultiUso.Parameters.ParamByName('ID').DataType          :=  ftInteger;
      dm.adoMultiUso.Parameters.ParamByName('lote').DataType        :=  ftString;
      dm.adoMultiUso.Parameters.ParamByName('responde').DataType    :=  ftString;
      dm.adoMultiUso.Parameters.ParamByName('usu').DataType         :=  ftString;

      vl_lote :=  b['Closures']['0']['Batch'].getStr;
      vl_loteAMEX :=  b['Closures']['1']['Batch'].getStr;
      dm.adoMultiUso.Parameters.ParamByName('ID').Value             :=  ID;
      dm.adoMultiUso.Parameters.ParamByName('lote').Value           :=  vl_lote;
      dm.adoMultiUso.Parameters.ParamByName('responde').Value       :=  response;
      dm.adoMultiUso.Parameters.ParamByName('usu').Value            :=  DM.Usuario;
      dm.adoMultiUso.ExecSQL;
      lblWait.Caption:='Imprimiento Cierre Cardnet...';
      Application.ProcessMessages();
      CASE Impresora.IDPrinter OF
      0:ImpCCierreCardNet;
      1 : {EPSON (TMU-220)}      ImpTicketFiscalCardNet(impresora.copia);
      end;
      lblWait.Caption:='';
      pnMsgImpresion.visible :=false;
      MessageDlg('PROCESO DE CIERRE EJECUTADO',mtInformation,[mbok],0);
      end
      else
      MessageDlg('EL CIERRE NO FUE EJECUTADO, NO SE ENCONTRARON LOTES PARA EL CIERRE',mtWarning,[mbOK],0);

   end;
end;


procedure TfrmCuadre.ImpCCierreCardNet;
var
  arch, puertopeq : textfile;
  s, s1, s2, s3, s4, s5,s6 : array [0..20] of char;
  Tfac, Saldo : double;
  puerto, lbitbis, impcodigo,
  param1, param2, param3, param4, param5, param6, param7, param8, param9, param10,
  param11, param12, param13, param14, param15, param16, param17, param18, param19,
  Unidad, codigoabre, par_monto, par_autoriz, par_tarjeta,
  par_mont, par_autor, par_tarj, batch_cierre, batch_boucher : string;
  a,x, vCant : integer;
  b,c, d, e : myJSONItem;
  vTotal, vTax : Currency;

begin
if VL_LOTE <> '' THEN BEGIN
  codigoabre := Trim(DM.QParametrosPAR_CODIGO_ABRE_CAJA.Value);

  if FileExists('.\puerto.txt') then
  begin
    assignfile(puertopeq, '.\puerto.txt');
    reset(puertopeq);
    readln(puertopeq, puerto);
  end
  else
    puerto := 'PRN';

  closefile(puertopeq);

  AssignFile(arch, '.\impcverifone.bat');
  rewrite(arch);
  writeln(arch, 'type .\cverifone.txt > '+puerto);
  closefile(arch);


  AssignFile(arch, '.\cverifone.txt');
  rewrite(arch);
  param1 := DM.QEmpresaemp_nombre.Text;
  writeln(arch,dm.centro(param1));
  param1 := DM.QEmpresaEMP_RNC.Text;
  writeln(arch,dm.centro(param1));
  param1 := DM.QEmpresaEMP_LOCALIDAD.Text;
  writeln(arch,dm.centro(param1));
  param1 := DM.QEmpresaEMP_DIRECCION.Text;
  writeln(arch,dm.centro(param1));
  writeln(arch,'');
  writeln(arch,'');

  b := myJSONItem.Create;
  b.Code :=  response;
  IF b['Closures']['0']['Host'].getStr = 'CREDITO' THEN BEGIN
  param1 := 'HOST: '+ b['Closures']['0']['Host'].getStr;
  param2 := 'LOTE: '+ b['Closures']['0']['Batch'].getStr;
  param3 := DM.FillSpaces(param2,40-Length(param1));
  writeln(arch,param1+PARAM3);
  param4 := 'FECHA: '+trim(copy(b['Closures']['0']['DataTime'].getStr,1,10));
  param5 := 'HORA: '+trim(copy(b['Closures']['0']['DataTime'].getStr,11,16));
  param6 := DM.FillSpaces(param5,40-Length(param4));
  writeln(arch,param4+PARAM6);
  writeln(arch,'');
  writeln(arch,'');
  ///TOTAL DE VENTAS SIN AMEX
  writeln(arch,dm.centro('D E T A L L E S   D E   V E N T AS'));
  writeln(arch,dm.centro('======================================='));
  writeln(arch,dm.centro(''));

  //Detallado
  dm.Query1.Close;
  DM.Query1.SQL.Clear;
  dm.Query1.SQL.Add('SELECT * FROM(');
  DM.Query1.SQL.Add('select fecha, resultado JSON, cast ((cast (monto as numeric(18,2))/100) as numeric(18,2)) monto');
  DM.Query1.SQL.Add('from adLogVeriphone fp');
  DM.Query1.SQL.Add('where resultado like '+QuotedStr('%succes%'));
  DM.Query1.SQL.Add('AND TIPO = '+QuotedStr('N'));
  dm.Query1.SQL.Add('and usu_codigo = :usu');
  dm.Query1.SQL.Add('and fecha between :fec1 and :fec2');
  dm.Query1.SQL.Add('and len(resultado)>180');
  dm.Query1.SQL.Add('and resultado like '+QuotedStr('%"Batch":'+vl_lote+'%'));
  dm.Query1.SQL.Add('and emp_codigo = :emp and suc_codigo = :suc');
  dm.Query1.SQL.Add(') AS TEMP WHERE monto > 0');
  dm.Query1.SQL.Add('order by fecha desc');
  dm.Query1.Parameters.ParamByName('usu').Value    := DBLookupComboBox2.KeyValue;
  dm.Query1.Parameters.ParamByName('fec1').DataType := ftDate;
  dm.Query1.Parameters.ParamByName('fec2').DataType := ftDate;
  dm.Query1.Parameters.ParamByName('fec1').Value    := fecha1.Date;
  dm.Query1.Parameters.ParamByName('fec2').Value    := hora2.DateTime;
  dm.Query1.Parameters.ParamByName('emp').Value     := frmMain.empcaja;
  dm.Query1.Parameters.ParamByName('suc').Value     := frmMain.vp_suc;
  dm.Query1.Open;
  IF NOT DM.Query1.IsEmpty THEN BEGIN
  Writeln(arch,'MONTO        TARJETA       AUTORIZACION');
  writeln(arch,dm.centro('======================================='));
  while not DM.Query1.Eof DO BEGIN
  c               := myJSONItem.Create;
  c.Code          := DM.Query1.FieldByName('JSON').Value;
  FillChar(s,8-length(trim(DM.Query1.FieldByName('monto').Text)),' ');
  FillChar(s1, 20-length(c['Card']['CardNumber'].getStr),' ');
  FillChar(s2, 8-length(c['Transaction']['AuthorizationNumber'].getStr),' ');
  writeln(arch, DM.Query1.FieldByName('monto').Text+s+' '+
                c['Card']['CardNumber'].getStr+s1+' '+
                c['Transaction']['AuthorizationNumber'].getStr);
  DM.Query1.Next;
  END;
  END;

  ///TOTAL DE VENTAS SIN AMEX
  writeln(arch,'');
  writeln(arch,'');
  writeln(arch,dm.centro('D E T A L L E S   A N U L A C I O N'));
  writeln(arch,dm.centro('======================================='));
  writeln(arch,dm.centro(''));

  //Detallado
  dm.Query1.Close;
  DM.Query1.SQL.Clear;
  dm.Query1.SQL.Add('SELECT top 1 * FROM(');
  dm.Query1.SQL.Add('select fp.fecha, fp2.resultado JSON, cast ((cast (fp2.monto as numeric(18,2))/100) as numeric(18,2)) monto');
  dm.Query1.SQL.Add('from adLogVeriphone fp');
  dm.Query1.SQL.Add('inner join adLogVeriphone fp2 on fp.emp_codigo = fp2.emp_codigo and fp.suc_codigo = fp2.suc_codigo and fp.facticket = fp2.facticket  and fp.usu_codigo = fp2.usu_codigo');
  dm.Query1.SQL.Add('where fp.resultado like '+QuotedStr('%Successful Annulment%'));
  dm.Query1.SQL.Add('AND fp.TIPO =  '+QuotedStr('A'));
  dm.Query1.SQL.Add('and fp.usu_codigo = :usu');
  dm.Query1.SQL.Add('and len(fp.resultado)>=55');
  dm.Query1.SQL.Add('and fp.emp_codigo = :emp and fp.suc_codigo = :suc');
  dm.Query1.SQL.Add('and fp.fecha between (select case when max(fecha) = '+QuotedStr('')+' then cast(cast(GETDATE() as char(11)) as datetime) else max(fecha) end from adlogveriphone where emp_codigo = fp.emp_codigo and usu_codigo = fp.usu_codigo and suc_codigo = fp.suc_codigo and tipo = '+QuotedStr('C')+') and getdate()');
  dm.Query1.SQL.Add(') AS TEMP WHERE monto > 0');
  dm.Query1.SQL.Add('order by fecha desc');
  dm.Query1.Parameters.ParamByName('usu').Value    := DBLookupComboBox2.KeyValue;
  dm.Query1.Parameters.ParamByName('emp').Value     := frmMain.empcaja;
  dm.Query1.Parameters.ParamByName('suc').Value     := frmMain.vp_suc;
  dm.Query1.Open;
  IF NOT DM.Query1.IsEmpty THEN BEGIN
  Writeln(arch,'MONTO        TARJETA       AUTORIZACION');
  writeln(arch,dm.centro('======================================='));
  while not DM.Query1.Eof DO BEGIN
  c               := myJSONItem.Create;
  c.Code          := DM.Query1.FieldByName('JSON').Value;
  FillChar(s,8-length(trim(DM.Query1.FieldByName('monto').Text)),' ');
  FillChar(s1, 20-length(c['Card']['CardNumber'].getStr),' ');
  FillChar(s2, 8-length(c['Transaction']['AuthorizationNumber'].getStr),' ');
  writeln(arch, DM.Query1.FieldByName('monto').Text+s+' '+
                c['Card']['CardNumber'].getStr+s1+' '+
                c['Transaction']['AuthorizationNumber'].getStr);
  DM.Query1.Next;
  END;
  END;


  writeln(arch,dm.centro('======================================='));
  writeln(arch,dm.centro('T O T A L   D E   V E N T AS'));
  writeln(arch,dm.centro('======================================='));

  //Ventas
  param7 := 'Ventas: ';
  param8 := b['Closures']['0']['Purchase']['Quantity'].getStr+'  RD$';
  param9 := DM.FillSpaces(param8,20-Length(param7));
  vTotal := 0;
  vTax   := 0;
  param10:= FormatCurr('#,0.00',StrToCurr(b['Closures']['0']['Purchase']['Amount'].getStr));
  param11:= DM.FillSpaces(param10,20);
  writeln(arch,param7+PARAM9+param11);

  param12 := 'ITBIS: ';
  param13 := 'RD$';
  param14 := DM.FillSpaces(param13,20-Length(param12));
  IF b['Closures']['0']['Purchase']['Tax'].getStr<>'' THEN
  param15:= FormatCurr('#,0.00',StrToCurr(b['Closures']['0']['Purchase']['Tax'].getStr)) ELSE
  param15:= '0.00';
  param16:= DM.FillSpaces(param15,20);
  writeln(arch,param12+PARAM14+param16);

  vCant  := StrToInt(b['Closures']['0']['Purchase']['Quantity'].getStr);
  vTotal := StrToCurr(b['Closures']['0']['Purchase']['Amount'].getStr);
  vTax   := StrToCurr(b['Closures']['0']['Purchase']['Tax'].getStr);

  //Totales
  param7 := 'Total: ';
  param8 := IntToStr(vCant)+'  RD$';
  param9 := DM.FillSpaces(param8,20-Length(param7));
  param10:= FormatCurr('#,0.00',vTotal);
  param11:= DM.FillSpaces(param10,20);
  writeln(arch,param7+PARAM9+param11);

  param12 := 'TOTAL ITBIS: ';
  param13 := 'RD$';
  param14 := DM.FillSpaces(param13,20-Length(param12));
  param15:= FormatCurr('#,0.00',vTax);
  param16:= DM.FillSpaces(param15,20);
  writeln(arch,param12+PARAM14+param16);

  //Devolucion
  param7 := 'Devolucion: ';
  param8 := b['Closures']['0']['Return']['Quantity'].getStr+'  RD$';
  param9 := DM.FillSpaces(param8,20-Length(param7));
  IF b['Closures']['0']['Return']['Amount'].getStr<>'' THEN
  param10:= FormatCurr('#,0.00',StrToCurr(b['Closures']['0']['Return']['Amount'].getStr)) ELSE
  param10:= '0.00';
  param11:= DM.FillSpaces(param10,20);
  writeln(arch,param7+PARAM9+param11);
  end;

  writeln(arch,dm.centro('======================================='));
  writeln(arch,dm.centro('LOTE TRANSMITIDO'));

  for X:= 1 to 15 do begin
    writeln(arch,'');
  end;

  if codigoabre = 'Termica' then
  writeln(arch,chr(27)+chr(109));

  CloseFile(arch);

 winexec('.\impcverifone.bat',0);
 END;

 // IMPRIMIENDO CIERRE AMEX
 if vl_loteAMEX <> '' THEN BEGIN
  codigoabre := Trim(DM.QParametrosPAR_CODIGO_ABRE_CAJA.Value);

  if FileExists('.\puerto.txt') then
  begin
    assignfile(puertopeq, '.\puerto.txt');
    reset(puertopeq);
    readln(puertopeq, puerto);
  end
  else
    puerto := 'PRN';

  closefile(puertopeq);

  AssignFile(arch, '.\impcverifoneAMEX.bat');
  rewrite(arch);
  writeln(arch, 'type .\cverifoneAMEX.txt > '+puerto);
  closefile(arch);


  AssignFile(arch, '.\cverifoneAMEX.txt');
  rewrite(arch);
  param1 := DM.QEmpresaemp_nombre.Text;
  writeln(arch,dm.centro(param1));
  param1 := DM.QEmpresaEMP_RNC.Text;
  writeln(arch,dm.centro(param1));
  param1 := DM.QEmpresaEMP_LOCALIDAD.Text;
  writeln(arch,dm.centro(param1));
  param1 := DM.QEmpresaEMP_DIRECCION.Text;
  writeln(arch,dm.centro(param1));
  writeln(arch,'');
  writeln(arch,'');

  b := myJSONItem.Create;
  b.Code :=  response;
  IF b['Closures']['1']['Host'].getStr = 'AMEX' THEN BEGIN
  param1 := 'HOST: '+ b['Closures']['1']['Host'].getStr;
  param2 := 'LOTE: '+ vl_loteAMEX;
  param3 := DM.FillSpaces(param2,40-Length(param1));
  writeln(arch,param1+PARAM3);
  param4 := 'FECHA: '+trim(copy(b['Closures']['1']['DataTime'].getStr,1,10));
  param5 := 'HORA: '+trim(copy(b['Closures']['1']['DataTime'].getStr,11,16));
  param6 := DM.FillSpaces(param5,40-Length(param4));
  writeln(arch,param4+PARAM6);
  writeln(arch,'');
  writeln(arch,'');

  //Detallado
  dm.Query1.Close;
  DM.Query1.SQL.Clear;
  dm.Query1.SQL.Add('SELECT * FROM(');
  DM.Query1.SQL.Add('select fecha, resultado JSON, cast ((cast (monto as numeric(18,2))/100) as numeric(18,2)) monto');
  DM.Query1.SQL.Add('from adLogVeriphone fp');
  DM.Query1.SQL.Add('where TIPO = '+QuotedStr('N'));
  dm.Query1.SQL.Add('and usu_codigo = :usu');
  dm.Query1.SQL.Add('and fecha between :fec1 and :fec2');
  dm.Query1.SQL.Add('and resultado like '+QuotedStr('%"Batch":'+vl_loteAMEX+'%'));
  dm.Query1.SQL.Add('and emp_codigo = :emp and suc_codigo = :suc');
  dm.Query1.SQL.Add(') AS TEMP WHERE monto > 0');
  dm.Query1.SQL.Add('order by fecha desc');
  dm.Query1.Parameters.ParamByName('usu').Value    := DBLookupComboBox2.KeyValue;
  dm.Query1.Parameters.ParamByName('fec1').DataType := ftDate;
  dm.Query1.Parameters.ParamByName('fec2').DataType := ftDate;
  dm.Query1.Parameters.ParamByName('fec1').Value    := fecha1.Date;
  dm.Query1.Parameters.ParamByName('fec2').Value    := hora2.DateTime;
  dm.Query1.Parameters.ParamByName('emp').Value     := frmMain.empcaja;
  dm.Query1.Parameters.ParamByName('suc').Value     := frmMain.vp_suc;
  dm.Query1.Open;
  IF NOT DM.Query1.IsEmpty THEN BEGIN
  ///TOTAL DE VENTAS SIN AMEX
  writeln(arch,dm.centro('D E T A L L E S   D E   V E N T AS'));
  writeln(arch,dm.centro('======================================='));
  writeln(arch,dm.centro(''));

  Writeln(arch,'MONTO        TARJETA       AUTORIZACION');
  writeln(arch,dm.centro('======================================='));
  while not DM.Query1.Eof DO BEGIN
  c               := myJSONItem.Create;
  c.Code          := DM.Query1.FieldByName('JSON').Value;
  FillChar(s,8-length(trim(DM.Query1.FieldByName('monto').Text)),' ');
  FillChar(s1, 20-length(c['Card']['CardNumber'].getStr),' ');
  FillChar(s2, 8-length(c['Transaction']['AuthorizationNumber'].getStr),' ');
  writeln(arch, DM.Query1.FieldByName('monto').Text+s+' '+
                c['Card']['CardNumber'].getStr+s1+' '+
                c['Transaction']['AuthorizationNumber'].getStr);
  DM.Query1.Next;
  END;
  END;

  writeln(arch,dm.centro('======================================='));
  writeln(arch,dm.centro('T O T A L   D E   V E N T AS'));
  writeln(arch,dm.centro('======================================='));

  //Ventas
  param7 := 'Ventas: ';
  param8 := b['Closures']['1']['Purchase']['Quantity'].getStr+'  RD$';
  param9 := DM.FillSpaces(param8,20-Length(param7));
  vTotal := 0;
  vTax   := 0;
  param10:= FormatCurr('#,0.00',StrToCurr(b['Closures']['1']['Purchase']['Amount'].getStr));
  param11:= DM.FillSpaces(param10,20);
  writeln(arch,param7+PARAM9+param11);

  {param12 := 'ITBIS: ';
  param13 := 'RD$';
  param14 := DM.FillSpaces(param13,20-Length(param12));
  IF b['Closures']['1']['Purchase']['Ta x'].getStr<>'' THEN
  param15:= FormatCurr('#,0.00',StrToCurr(b['Closures']['1']['Purchase']['Ta x'].getStr)) ELSE
  param15:= '0.00';
  param16:= DM.FillSpaces(param15,20);
  writeln(arch,param12+PARAM14+param16);
   }

  vCant  := StrToInt(b['Closures']['1']['Purchase']['Quantity'].getStr);
  vTotal := StrToCurr(b['Closures']['1']['Purchase']['Amount'].getStr);
  //vTax   := StrToCurr(b['Closures']['1']['Purchase']['Ta x'].getStr);

  //Totales
  param7 := 'Total: ';
  param8 := IntToStr(vCant)+'  RD$';
  param9 := DM.FillSpaces(param8,20-Length(param7));
  param10:= FormatCurr('#,0.00',vTotal);
  param11:= DM.FillSpaces(param10,20);
  writeln(arch,param7+PARAM9+param11);

  {param12 := 'TOTAL ITBIS: ';
  param13 := 'RD$';
  param14 := DM.FillSpaces(param13,20-Length(param12));
  param15:= FormatCurr('#,0.00',vTax);
  param16:= DM.FillSpaces(param15,20);
  writeln(arch,param12+PARAM14+param16);
   }

  //Devolucion
  param7 := 'Devolucion: ';
  param8 := b['Closures']['1']['Return']['Quantity'].getStr+'  RD$';
  param9 := DM.FillSpaces(param8,20-Length(param7));
  IF b['Closures']['1']['Return']['Amount'].getStr<>'' THEN
  param10:= FormatCurr('#,0.00',StrToCurr(b['Closures']['1']['Return']['Amount'].getStr)) ELSE
  param10:= '0.00';
  param11:= DM.FillSpaces(param10,20);
  writeln(arch,param7+PARAM9+param11);
  end;

  writeln(arch,dm.centro('======================================='));
  writeln(arch,dm.centro('LOTE TRANSMITIDO'));

  for X:= 1 to 15 do begin
    writeln(arch,'');
  end;

  if codigoabre = 'Termica' then
  writeln(arch,chr(27)+chr(109));

  CloseFile(arch);

 winexec('.\impcverifoneAMEX.bat',0);
 END;


end;

procedure TfrmCuadre.ImprimirCuadre;
var
  Host, Err: string;
  arch, ptocaja : textfile;
  s, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11 : array[0..100] of char;
  TFac, MontoItbis, Venta, Efectivo, Tarjeta, Cheque, Credito, TGrabado,
  TExcento, TCancelados, Anulados, MontoExento, BonosClub, BonosOtros, Devolucion, Total : double;
  PuntosPrinc, FactorPrin, Puntos, TotalPuntos, devuelta : Double;
  Msg1, Msg2, Msg3, Msg4, Puerto, forma, tipo_cuadre, Cuadrar_Empresa : String;
  cantcredito, cantcontado, cancelados, boletos, empresa_caja : integer;
begin

  MontoItbis := 0;
  Venta:= 0;
  Efectivo:= 0;
  Tarjeta:= 0;
  Cheque:= 0;
  Credito:= 0;

  hora1.Date  := fecha1.Date;
  hora2.Date  := fecha2.Date;


  dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('select emp_codigo, puerto, Tipo_Cuadre, Cuadrar_Empresa from cajas_IP');
  {dm.Query1.SQL.Add('where caja = :caj');
  dm.Query1.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;}
  dm.Query1.SQL.Add('where ip = :ip');
  dm.Query1.Parameters.ParamByName('ip').Value := frmMain.IPCaja;
  dm.Query1.Open;
  Puerto := dm.Query1.FieldByName('puerto').AsString;
  tipo_cuadre := dm.Query1.FieldByName('Tipo_Cuadre').AsString;
  Cuadrar_Empresa := dm.Query1.FieldByName('Cuadrar_Empresa').AsString;
  empresa_caja := dm.Query1.FieldByName('emp_codigo').AsInteger;

  if (Cuadrar_Empresa = 'C') and (not realizo) then
  begin
    realizo := true;
    QEfectivo.SQL.Add('and m.emp_codigo = '+inttostr(empresa_caja));
    QCheque.SQL.Add('and m.emp_codigo = '+inttostr(empresa_caja));
    QTarjeta.SQL.Add('and m.emp_codigo = '+inttostr(empresa_caja));
    QCredito.SQL.Add('and m.emp_codigo = '+inttostr(empresa_caja));
    QBonosClub.SQL.Add('and m.emp_codigo = '+inttostr(empresa_caja));
    QBonosOtros.SQL.Add('and m.emp_codigo = '+inttostr(empresa_caja));
  end;

  graba;

  QAnulados.Close;
  QAnulados.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
  QAnulados.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
  QAnulados.Parameters.ParamByName('fec1').DataType := ftDateTime;
  QAnulados.Parameters.ParamByName('fec1').Value    := hora1.Date;
  QAnulados.Parameters.ParamByName('fec2').DataType := ftDateTime;
  QAnulados.Parameters.ParamByName('fec2').Value    := hora2.Date;
  QAnulados.Open;

  QNCF.Close;
  QNCF.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
  QNCF.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
  QNCF.Parameters.ParamByName('fec1').DataType := ftDateTime;
  QNCF.Parameters.ParamByName('fec1').Value    := hora1.Date;
  QNCF.Parameters.ParamByName('fec2').DataType := ftDateTime;
  QNCF.Parameters.ParamByName('fec2').Value    := hora2.Date;
  QNCF.Open;

  QEfectivo.Close;
  QEfectivo.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
  QEfectivo.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
  QEfectivo.Parameters.ParamByName('fec1').DataType := ftDateTime;
  QEfectivo.Parameters.ParamByName('fec1').Value    := hora1.Date;
  QEfectivo.Parameters.ParamByName('fec2').DataType := ftDateTime;
  QEfectivo.Parameters.ParamByName('fec2').Value    := hora2.Date;;
  QEfectivo.Open;

  QCheque.Close;
  QCheque.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
  QCheque.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
  QCheque.Parameters.ParamByName('fec1').DataType := ftDateTime;
  QCheque.Parameters.ParamByName('fec1').Value    := hora1.Date;
  QCheque.Parameters.ParamByName('fec2').DataType := ftDateTime;
  QCheque.Parameters.ParamByName('fec2').Value    := hora2.Date;;
  QCheque.Open;

  QTarjeta.Close;
  QTarjeta.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
  QTarjeta.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
  QTarjeta.Parameters.ParamByName('fec1').DataType := ftDateTime;
  QTarjeta.Parameters.ParamByName('fec1').Value    := hora1.Date;
  QTarjeta.Parameters.ParamByName('fec2').DataType := ftDateTime;
  QTarjeta.Parameters.ParamByName('fec2').Value    := hora2.Date;;
  QTarjeta.Open;

  QCredito.Close;
  QCredito.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
  QCredito.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
  QCredito.Parameters.ParamByName('fec1').DataType := ftDateTime;
  QCredito.Parameters.ParamByName('fec1').Value    := hora1.Date;
  QCredito.Parameters.ParamByName('fec2').DataType := ftDateTime;
  QCredito.Parameters.ParamByName('fec2').Value    := hora2.Date;;
  QCredito.Open;

  QBonosClub.Close;
  QBonosClub.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
  QBonosClub.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
  QBonosClub.Parameters.ParamByName('fec1').DataType := ftDateTime;
  QBonosClub.Parameters.ParamByName('fec1').Value    := hora1.Date;
  QBonosClub.Parameters.ParamByName('fec2').DataType := ftDateTime;
  QBonosClub.Parameters.ParamByName('fec2').Value    := hora2.Date;;
  QBonosClub.Open;

  QBonosOtros.Close;
  QBonosOtros.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
  QBonosOtros.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
  QBonosOtros.Parameters.ParamByName('fec1').DataType := ftDateTime;
  QBonosOtros.Parameters.ParamByName('fec1').Value    := hora1.Date;
  QBonosOtros.Parameters.ParamByName('fec2').DataType := ftDateTime;
  QBonosOtros.Parameters.ParamByName('fec2').Value    := hora2.Date;;
  QBonosOtros.Open;

  QDevolucion.Close;
  QDevolucion.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
  QDevolucion.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
  QDevolucion.Parameters.ParamByName('fec1').DataType := ftDateTime;
  QDevolucion.Parameters.ParamByName('fec1').Value    := hora1.Date;
  QDevolucion.Parameters.ParamByName('fec2').DataType := ftDateTime;
  QDevolucion.Parameters.ParamByName('fec2').Value    := hora2.Date;;
  QDevolucion.Open;

  assignfile(arch,'imp.bat');
  rewrite(arch);

  writeln(arch, 'type cuadre.txt > '+Puerto);
  closefile(arch);

  
  dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('SELECT EMP_NOMBRE, EMP_DIRECCION, EMP_LOCALIDAD, emp_telefono, emp_rnc');
  dm.Query1.SQL.Add('FROM EMPRESAS');
  dm.Query1.SQL.Add('WHERE emp_codigo = (select top 1 emp_codigo from cajas_ip where ip = '+QuotedStr(frmMain.IPCaja)+')' );
  DM.Query1.Open;

  assignfile(arch,'cuadre.txt');
  rewrite(arch);
  writeln(arch, dm.centro(dm.Query1.fieldbyname('emp_nombre').Value));
  writeln(arch, dm.centro(dm.Query1.fieldbyname('emp_direccion').Value));
  writeln(arch, dm.centro(dm.Query1.fieldbyname('EMP_LOCALIDAD').Value));
  writeln(arch, dm.centro(dm.Query1.fieldbyname('EMP_TELEFONO').Value));
  writeln(arch, dm.centro('RNC:'+dm.Query1.fieldbyname('EMP_RNC').Value));
  writeln(arch, ' ');
  writeln(arch, ' ');
  writeln(arch, dm.centro('CUADRE DE CAJA'));
  writeln(arch, ' ');
  writeln(arch, 'Cuadre#: '+QCuadresecuencia.asstring);
  writeln(arch, 'Desde  : '+ FormatDateTime('dd/mm/yyyy hh:mm',hora1.Date));
  writeln(arch, 'Hasta  : '+ FormatDateTime('dd/mm/yyyy hh:mm',hora2.Date));
  writeln(arch, 'Cajero : '+DBLookupComboBox2.Text);
  writeln(arch, 'Caja   : '+DBLookupComboBox1.Text);
  writeln(arch, ' ');
  
  if tipo_cuadre = 'D' then
  begin
    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select sum(boletos) as boletos from montos_ticket');
    dm.Query1.SQL.Add('where caja = :caj');
    dm.Query1.SQL.Add('and usu_codigo = :usu');
    dm.Query1.SQL.Add('and fecha_hora between convert(datetime, :fec1, 113) and convert(datetime, :fec2, 113)');
    dm.Query1.SQL.Add('and status = '+QuotedStr('FAC'));
    if Cuadrar_Empresa = 'C' then
       dm.Query1.SQL.Add('and emp_codigo = '+inttostr(empresa_caja));
    dm.Query1.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
    dm.Query1.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
    dm.Query1.Parameters.ParamByName('fec1').DataType := ftDateTime;
    dm.Query1.Parameters.ParamByName('fec1').Value    := hora1.Date;
    dm.Query1.Parameters.ParamByName('fec2').DataType := ftDateTime;
    dm.Query1.Parameters.ParamByName('fec2').Value    := hora2.Date;;
    dm.Query1.Open;
    boletos := dm.Query1.FieldByName('boletos').AsInteger;

    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select count(*) as cantidad from montos_ticket');
    dm.Query1.SQL.Add('where caja = :caj');
    dm.Query1.SQL.Add('and usu_codigo = :usu');
    dm.Query1.SQL.Add('and fecha_hora between convert(datetime, :fec1, 113) and convert(datetime, :fec2, 113)');
    dm.Query1.SQL.Add('and status in (:st1, :st2)');
    if Cuadrar_Empresa = 'C' then
       dm.Query1.SQL.Add('and emp_codigo = '+inttostr(empresa_caja));
    dm.Query1.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
    dm.Query1.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
    dm.Query1.Parameters.ParamByName('fec1').DataType := ftDateTime;
    dm.Query1.Parameters.ParamByName('fec1').Value    := hora1.Date;
    dm.Query1.Parameters.ParamByName('fec2').DataType := ftDateTime;
    dm.Query1.Parameters.ParamByName('fec2').Value    := hora2.Date;;
    dm.Query1.Parameters.ParamByName('st1').Value  := 'ANU';
    dm.Query1.Parameters.ParamByName('st2').Value  := 'CAN';
    dm.Query1.Open;
    cancelados := dm.Query1.FieldByName('cantidad').AsInteger;

    Query1.Close;
    Query1.SQL.Clear;
    Query1.SQL.Add('select 1, '+QuotedStr('EFECTIVO')+' as nombre');
    Query1.SQL.Add('union select 2, '+QuotedStr('TARJETA'));
    Query1.SQL.Add('union select 3, '+QuotedStr('CHEQUE'));
    Query1.SQL.Add('union select 4, '+QuotedStr('BONOS CLUB'));
    Query1.SQL.Add('union select 5, '+QuotedStr('OTROS'));
    Query1.SQL.Add('union select 6, '+QuotedStr('NOTAS DE CREDITO'));
    Query1.SQL.Add('union select 7, '+QuotedStr('CREDITO'));
    Query1.Open;

    writeln(arch,'---------------------------------');
    writeln(arch,'DESCRIPCION       |    MONTO    |');
    writeln(arch,'---------------------------------');
    Total       := 0;
    devuelta    := 0;
    Devolucion  := 0;
    credito     := 0;
    cantcredito := 0;
    cantcontado := 0;
    while not Query1.Eof do
    begin
      forma := '';
      if Query1.FieldByName('nombre').AsString = 'EFECTIVO' then
        forma := 'EFE'
      else if Query1.FieldByName('nombre').AsString = 'CHEQUE' then
        forma := 'CHE'
      else if Query1.FieldByName('nombre').AsString = 'TARJETA' then
        forma := 'TAR'
      else if Query1.FieldByName('nombre').AsString = 'BONOS CLUB' then
        forma := 'BOC'
      else if Query1.FieldByName('nombre').AsString = 'OTROS' then
        forma := 'OBO'
      else if Query1.FieldByName('nombre').AsString = 'CREDITO' then
        forma := 'CRE'
      else if Query1.FieldByName('nombre').AsString = 'NOTAS DE CREDITO' then
        forma := 'DEV';

      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('select sum(f.pagado) as pagado, sum(f.pagado-f.devuelta) as total,');
      dm.Query1.SQL.Add('sum(f.devuelta) as devuelta, sum(m.total) as monto_total');
      dm.Query1.SQL.Add('from montos_ticket m, formas_pago_ticket f');
      dm.Query1.SQL.Add('where m.caja = f.caja');
      dm.Query1.SQL.Add('and m.usu_codigo = f.usu_codigo');
      dm.Query1.SQL.Add('and m.fecha = f.fecha');
      dm.Query1.SQL.Add('and m.ticket = f.ticket');
      dm.Query1.SQL.Add('and m.status = '+QuotedStr('FAC'));
      dm.Query1.SQL.Add('and m.caja = :caj');
      dm.Query1.SQL.Add('and m.usu_codigo = :usu');
      dm.Query1.SQL.Add('and m.fecha_hora between convert(datetime, :fec1, 113) and convert(datetime, :fec2, 113)');
      dm.Query1.SQL.Add('and f.forma = '+QuotedStr(forma));
      if Cuadrar_Empresa = 'C' then
         dm.Query1.SQL.Add('and m.emp_codigo = '+inttostr(empresa_caja));
      dm.Query1.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
      dm.Query1.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
      dm.Query1.Parameters.ParamByName('fec1').DataType := ftDateTime;
      dm.Query1.Parameters.ParamByName('fec1').Value    := hora1.Date;
      dm.Query1.Parameters.ParamByName('fec2').DataType := ftDateTime;
      dm.Query1.Parameters.ParamByName('fec2').Value    := hora2.Date;;
      dm.Query1.Open;

      if forma = 'DEV' then
      begin
        Devolucion := Devolucion + dm.Query1.FieldByName('pagado').AsFloat;
        if dm.Query1.FieldByName('pagado').AsFloat > 0 then
          cantcontado := cantcontado - 1;
      end
      else if forma = 'CRE' then
      begin
        credito := credito + dm.Query1.FieldByName('monto_total').AsFloat;
        if dm.Query1.FieldByName('monto_total').AsFloat > 0 then
          cantcredito := cantcredito + 1;
      end
      else
      begin
        s  := '';
        FillChar(s, 12-length(format('%n',[dm.Query1.FieldByName('pagado').AsFloat])),' ');
        s1 := '';
        FillChar(s1, 18-length(Query1.FieldByName('nombre').AsString),' ');
        writeln(arch,Query1.FieldByName('nombre').AsString+s1+'|'+s+'$'+format('%n',[dm.Query1.FieldByName('pagado').AsFloat])+'|'+'(+)');

        devuelta := devuelta + dm.Query1.FieldByName('devuelta').AsFloat;
        Total := Total + dm.Query1.FieldByName('pagado').AsFloat;
        cantcontado := cantcontado + 1;
      end;

      Query1.Next;
    end;
    writeln(arch,'                  --------------|');
    s  := '';
    FillChar(s, 12-length(format('%n',[total])),' ');
    s1  := '';
    FillChar(s1, 12-length(format('%n',[devuelta])),' ');
    s2  := '';
    FillChar(s2, 12-length(format('%n',[(total-devuelta)+devolucion+credito])),' ');
    s3  := '';
    FillChar(s3, 12-length(format('%n',[QCuadreefectivo_asignado.Value])),' ');
    s7 := '';
    FillChar(s7, 12-length(format('%n',[devolucion])),' ');
    s5  := '';
    FillChar(s5, 12-length(format('%n',[(total-devuelta)+QCuadreefectivo_asignado.Value+devolucion+credito])),' ');
    s8  := '';
    FillChar(s8, 12-length(format('%n',[credito])),' ');
    s9  := '';
    FillChar(s9, 12-length(format('%n',[(total-devuelta)])),' ');

    writeln(arch,'SUBTOTAL          |'+s +'$'+format('%n',[total])+'|');
    writeln(arch,'EFECTIVO DEVUELTO |'+s1+'$'+format('%n',[devuelta])+'|'+'(-)');
    writeln(arch,'                  --------------|');
    writeln(arch,'SUBTOTAL          |'+s9+'$'+format('%n',[(total-devuelta)])+'|');
    writeln(arch,'CREDITO           |'+s8 +'$'+format('%n',[credito])+'|'+'(+)');
    writeln(arch,'NOTAS DE CREDITO  |'+s7 +'$'+format('%n',[devolucion])+'|'+'(-)');
    writeln(arch,'                  --------------|');
    writeln(arch,'TOTAL VENDIDO     |'+s2 +'$'+format('%n',[(total-devuelta)+devolucion+credito])+'|');
    writeln(arch,'DEPOSITO EN CAJA  |'+s3 +'$'+format('%n',[QCuadreefectivo_asignado.Value])+'|'+'(+)');
    writeln(arch,'CANTIDAD BOLETOS  |'+inttostr(boletos));
    writeln(arch,'                  --------------|');
    writeln(arch,'TOTAL EN CAJA     |'+s5 +'$'+format('%n',[(total-devuelta) +QCuadreefectivo_asignado.Value+devolucion+credito])+'|');
    writeln(arch,'                  ===============');
    writeln(arch,' ');
    writeln(arch,'---------------------------------');
    writeln(arch,'TIPO        |CANT.|    MONTO    |');
    writeln(arch,'---------------------------------');

    s  := '';
    FillChar(s, 5-length(inttostr(cantcontado)),' ');
    s1  := '';
    FillChar(s1, 12-length(format('%n',[(total-devuelta)+devolucion])),' ');
    s2  := '';
    FillChar(s2, 5-length(inttostr(cantcredito)),' ');
    s4  := '';
    FillChar(s4, 5-length(inttostr(cancelados)),' ');
    s5  := '';
    FillChar(s5, 5-length(inttostr(cantcontado+cantcredito+cancelados)),' ');
    s6  := '';
    FillChar(s6, 12-length(format('%n',[(total-devuelta)+credito+devolucion])),' ');
    s9  := '';
    FillChar(s9, 12-length(format('%n',[(total-devuelta)+credito])),' ');

    writeln(arch,'CONTADO     |'+s+inttostr(cantcontado)+'|'+s1+'$'+format('%n',[(total-devuelta)+devolucion])+'|(+)');
    writeln(arch,'CREDITO     |'+s2+inttostr(cantcredito)+'|'+s8+'$'+format('%n',[credito])+'|(+)');
    writeln(arch,'ANULADOS    |'+s4+inttostr(cancelados)+'|'+'        $0.00|(+)');
    writeln(arch,'            --------------------|');
    writeln(arch,'SUBTOTAL    |'+s5+inttostr(cantcontado+cantcredito+cancelados)+'|'+s6+'$'+format('%n',[(total-devuelta)+devolucion+credito])+'|');
    writeln(arch,'NOTAS DE CR |     |'+s7+'$'+format('%n',[devolucion])+'|(-)');
    writeln(arch,'            --------------------|');
    writeln(arch,'TOTAL       |'+s5+inttostr(cantcontado+cantcredito+cancelados)+'|'+s9+'$'+format('%n',[(total-devuelta)+credito])+'|');
    writeln(arch,'            =====================');
    writeln(arch,' ');
    writeln(arch,'---------------------------------');
    writeln(arch,'DESCRIPCION       |    MONTO    |');
    writeln(arch,'---------------------------------');

    s  := '';
    FillChar(s, 12-length(format('%n',[TExcento])),' ');
    s1  := '';
    FillChar(s1, 12-length(format('%n',[TGrabado])),' ');
    s2  := '';
    FillChar(s2, 12-length(format('%n',[MontoItbis])),' ');
    s3  := '';
    FillChar(s3, 12-length(format('%n',[TExcento+TGrabado+MontoItbis])),' ');

    //writeln(arch,'VENTA EXENTA      |'+s+'$'+format('%n',[TExcento])+'|(+)');
    //writeln(arch,'VENTA GRABADA     |'+s1+'$'+format('%n',[TGrabado])+'|(+)');
    writeln(arch,'TOTAL ITBIS       |'+s2+'$'+format('%n',[MontoItbis])+'|(+)');
    writeln(arch,'                  --------------|');
    writeln(arch,'TOTAL             |'+s3+'$'+format('%n',[TExcento+TGrabado+MontoItbis])+'|(+)');
    writeln(arch,'                  ===============');
    writeln(arch, ' ');
    writeln(arch, ' ');
    writeln(arch, ' ');
    writeln(arch, ' ');
    writeln(arch, ' ');
    writeln(arch, ' ');
    writeln(arch, '------------------------');
    writeln(arch, 'Firma del Cajero');
    writeln(arch, ' ');
    writeln(arch, ' ');
    writeln(arch, ' ');
    writeln(arch, ' ');
    writeln(arch, ' ');
    writeln(arch, '------------------------');
    writeln(arch, 'Firma del Supervisor');
    writeln(arch, ' ');
    writeln(arch, ' ');
    writeln(arch, ' ');
    writeln(arch, ' ');
    writeln(arch, ' ');
    writeln(arch, ' ');
    writeln(arch, ' ');
    writeln(arch, ' ');
  end
  else
  begin  
    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select sum(isnull(itbis,0)) as itbis from montos_ticket');
    dm.Query1.SQL.Add('where caja = :caj');
    dm.Query1.SQL.Add('and usu_codigo = :usu');
    dm.Query1.SQL.Add('and fecha_hora between convert(datetime, :fec1, 113) and convert(datetime, :fec2, 113)');
    dm.Query1.SQL.Add('and status = '+QuotedStr('FAC'));
    if Cuadrar_Empresa = 'C' then
       dm.Query1.SQL.Add('and emp_codigo = '+inttostr(empresa_caja));
    dm.Query1.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
    dm.Query1.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
    dm.Query1.Parameters.ParamByName('fec1').DataType := ftDateTime;
    dm.Query1.Parameters.ParamByName('fec1').Value    := hora1.Date;
    dm.Query1.Parameters.ParamByName('fec2').DataType := ftDateTime;
    dm.Query1.Parameters.ParamByName('fec2').Value    := hora2.Date;;
    dm.Query1.Open;
    MontoItbis := dm.Query1.FieldByName('itbis').AsFloat;

    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select sum(boletos) as boletos from montos_ticket');
    dm.Query1.SQL.Add('where caja = :caj');
    dm.Query1.SQL.Add('and usu_codigo = :usu');
    dm.Query1.SQL.Add('and fecha_hora between convert(datetime, :fec1, 113) and convert(datetime, :fec2, 113)');
    dm.Query1.SQL.Add('and status = '+QuotedStr('FAC'));
    if Cuadrar_Empresa = 'C' then
       dm.Query1.SQL.Add('and emp_codigo = '+inttostr(empresa_caja));
    dm.Query1.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
    dm.Query1.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
    dm.Query1.Parameters.ParamByName('fec1').DataType := ftDateTime;
    dm.Query1.Parameters.ParamByName('fec1').Value    := hora1.Date;
    dm.Query1.Parameters.ParamByName('fec2').DataType := ftDateTime;
    dm.Query1.Parameters.ParamByName('fec2').Value    := hora2.Date;;
    dm.Query1.Open;
    boletos := dm.Query1.FieldByName('boletos').AsInteger;

    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select count(*) as cantidad from montos_ticket');
    dm.Query1.SQL.Add('where caja = :caj');
    dm.Query1.SQL.Add('and usu_codigo = :usu');
    dm.Query1.SQL.Add('and fecha_hora between convert(datetime, :fec1, 113) and convert(datetime, :fec2, 113)');
    if Cuadrar_Empresa = 'C' then
       dm.Query1.SQL.Add('and emp_codigo = '+inttostr(empresa_caja));
    dm.Query1.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
    dm.Query1.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
    dm.Query1.Parameters.ParamByName('fec1').DataType := ftDateTime;
    dm.Query1.Parameters.ParamByName('fec1').Value    := hora1.Date;
    dm.Query1.Parameters.ParamByName('fec2').DataType := ftDateTime;
    dm.Query1.Parameters.ParamByName('fec2').Value    := hora2.Date;;
    dm.Query1.Open;

    //Efectivo
    if QEfectivo.RecordCount > 0 then
    begin
      if cktickets.Checked then
      begin
        writeln(arch, dm.Centro('EFECTIVO'));
        writeln(arch, dm.Centro('--------'));
        writeln(arch, '#Ticket       N. C. F.         Monto   ');
        writeln(arch, '---------------------------------------');
      end;
      QEfectivo.DisableControls;

      QEfectivo.First;
      while not QEfectivo.eof do
      begin
        s := '';
        FillChar(s, 4-length(floattostr(QEfectivoticket.value)),' ');
        s1 := '';
        FillChar(s1, 12-length(FORMAT('%n',[QEfectivopagado.value])),' ');

        if cktickets.Checked then
          writeln(arch, '  '+s+floattostr(QEfectivoticket.value)+' '+QEfectivoNCF.Value+' '+
          s1+FORMAT('%n',[QEfectivopagado.value]));

        Efectivo := Efectivo + QEfectivopagado.value;
        QEfectivo.next;
      end;
      QEfectivo.First;
      QEfectivo.EnableControls;
      if cktickets.Checked then
      begin
        writeln(arch, '---------------------------------------');
        s2 := '';
        FillChar(s2, 12-length(trim(FORMAT('%n',[Efectivo]))), ' ');
        writeln(arch, 'Total : '+s2+format('%n',[Efectivo]));
      end;
    end;

    //Tarjeta
    Tarjeta := 0;
    //MontoItbis := 0;
    if QTarjeta.RecordCount > 0 then
    begin
      if cktickets.Checked then
      begin
        writeln(arch, ' ');
        writeln(arch, dm.Centro('TARJETA'));
        writeln(arch, dm.Centro('-------'));
        writeln(arch, '#Ticket       N. C. F.         Monto   ');
        writeln(arch, '---------------------------------------');
      end;
      QTarjeta.DisableControls;
      QTarjeta.First;
      while not QTarjeta.eof do
      begin
        s := '';
        FillChar(s, 4-length(floattostr(QTarjetaticket.value)),' ');
        s1 := '';
        FillChar(s1, 12-length(FORMAT('%n',[QTarjetapagado.value])), ' ');

        if cktickets.Checked then
          writeln(arch, '  '+s+floattostr(QTarjetaticket.value)+' '+QTarjetaNCF.Value+' '+
          s1+FORMAT('%n',[QTarjetapagado.value]));

        Tarjeta := Tarjeta + QTarjetapagado.value;
        QTarjeta.next;
      end;
      QTarjeta.First;
      QTarjeta.EnableControls;
      if cktickets.Checked then
      begin
        writeln(arch, '---------------------------------------');
        s2 := '';
        FillChar(s2, 12-length(trim(FORMAT('%n',[Tarjeta]))), ' ');
        writeln(arch, 'Total : '+s2+format('%n',[Tarjeta]));
      end;
    end;

    //Cheque
    Cheque := 0;
    //MontoItbis := 0;
    if QCheque.RecordCount > 0 then
    begin
      if cktickets.Checked then
      begin
        writeln(arch, ' ');
        writeln(arch, dm.Centro('CHEQUE'));
        writeln(arch, dm.Centro('------'));
        writeln(arch, '#Ticket       N. C. F.         Monto   ');
        writeln(arch, '---------------------------------------');
      end;
      QCheque.DisableControls;
      QCheque.First;
      while not QCheque.eof do
      begin
        s := '';
        FillChar(s, 4-length(floattostr(QChequeticket.value)),' ');
        s1 := '';
        FillChar(s1, 12-length(FORMAT('%n',[QChequepagado.value])), ' ');

        if cktickets.Checked then
          writeln(arch, '  '+s+floattostr(QChequeticket.value)+' '+QChequeNCF.Value+' '+
          s1+FORMAT('%n',[QChequepagado.value]));

        Cheque := Cheque + QChequepagado.value;
        devuelta := devuelta + QChequedevuelta.Value;
        QCheque.next;
      end;
      QCheque.First;
      QCheque.EnableControls;
      if cktickets.Checked then
      begin
        writeln(arch, '---------------------------------------');
        s2 := '';
        FillChar(s2, 12-length(trim(FORMAT('%n',[Cheque]))), ' ');
        writeln(arch, 'Total : '+s2+format('%n',[Cheque]));
      end;
    end;

    //Credito
    Credito := 0;
    //MontoItbis := 0;
    if QCredito.RecordCount > 0 then
    begin
      if cktickets.Checked then
      begin
        writeln(arch, ' ');
        writeln(arch, dm.Centro('CREDITO'));
        writeln(arch, dm.Centro('-------'));
        writeln(arch, '#Ticket       N. C. F.         Monto   ');
        writeln(arch, '---------------------------------------');
      end;
      QCredito.DisableControls;
      QCredito.First;
      while not QCredito.eof do
      begin
        s := '';
        FillChar(s, 4-length(floattostr(QCreditoticket.value)),' ');
        s1 := '';
        FillChar(s1, 12-length(FORMAT('%n',[QCreditopagado.value])), ' ');

        if cktickets.Checked then
          writeln(arch, '  '+s+floattostr(QCreditoticket.value)+' '+QCreditoNCF.Value+' '+
          s1+FORMAT('%n',[QCreditopagado.value]));

        Credito := Credito + QCreditopagado.value;
        QCredito.next;
      end;
      QCredito.First;
      QCredito.EnableControls;
      if cktickets.Checked then
      begin
        writeln(arch, '---------------------------------------');
        s2 := '';
        FillChar(s2, 12-length(trim(FORMAT('%n',[Credito]))), ' ');
        writeln(arch, 'Total : '+s2+format('%n',[Credito]));
      end;
    end;

    //Anulados
    Anulados := 0;
    TCancelados := 0;
    //MontoItbis := 0;
    if QAnulados.RecordCount > 0 then
    begin
      if cktickets.Checked then
      begin
        writeln(arch, ' ');
        writeln(arch, dm.Centro('ANULADOS/CANCELADOS'));
        writeln(arch, dm.Centro('-------------------'));
        writeln(arch, '#Ticket       N. C. F.         Monto   ');
        writeln(arch, '---------------------------------------');
      end;
      QAnulados.DisableControls;
      QAnulados.First;
      while not QAnulados.eof do
      begin
        s := '';
        FillChar(s, 4-length(floattostr(QAnuladosticket.value)),' ');
        s1 := '';
        FillChar(s1, 12-length(FORMAT('%n',[QAnuladospagado.value])), ' ');

        if cktickets.Checked then
          writeln(arch, '  '+s+floattostr(QAnuladosticket.value)+' '+QAnuladosNCF.Value+' '+
          s1+FORMAT('%n',[QAnuladospagado.value]));

        Anulados := Anulados + QAnuladostotal.value;
        QAnulados.next;
      end;
      QAnulados.First;
      QAnulados.EnableControls;
      if cktickets.Checked then
      begin
        writeln(arch, '---------------------------------------');
        s2 := '';
        FillChar(s2, 12-length(trim(FORMAT('%n',[Anulados]))), ' ');
        writeln(arch, 'Total : '+s2+format('%n',[Anulados]));
      end;
    end;

    //Bonos del Club
    BonosClub := 0;
    //MontoItbis := 0;
    if QBonosClub.RecordCount > 0 then
    begin
      if cktickets.Checked then
      begin
        writeln(arch, ' ');
        writeln(arch, dm.Centro('BONOS CLUB'));
        writeln(arch, dm.Centro('----------'));
        writeln(arch, '#Ticket       N. C. F.         Monto   ');
        writeln(arch, '---------------------------------------');
      end;
      QBonosClub.DisableControls;
      QBonosClub.First;
      while not QBonosClub.eof do
      begin
        s := '';
        FillChar(s, 4-length(floattostr(QBonosClubticket.value)),' ');
        s1 := '';
        FillChar(s1, 12-length(FORMAT('%n',[QBonosClubpagado.value])), ' ');

        if cktickets.Checked then
          writeln(arch, '  '+s+floattostr(QBonosClubticket.value)+' '+QBonosClubNCF.Value+' '+
          s1+FORMAT('%n',[QBonosClubpagado.value]));

        BonosClub := BonosClub + QBonosClubpagado.value;
        QBonosClub.next;
      end;
      QBonosClub.First;
      QBonosClub.EnableControls;
      if cktickets.Checked then
      begin
        writeln(arch, '---------------------------------------');
        s2 := '';
        FillChar(s2, 12-length(trim(FORMAT('%n',[BonosClub]))), ' ');
        writeln(arch, 'Total : '+s2+format('%n',[BonosClub]));
      end;
    end;

    //Otros Bonos
    BonosOtros := 0;
    //MontoItbis := 0;
    if QBonosOtros.RecordCount > 0 then
    begin
      if cktickets.Checked then
      begin
        writeln(arch, ' ');
        writeln(arch, dm.Centro('OTROS'));
        writeln(arch, dm.Centro('-----'));
        writeln(arch, '#Ticket       N. C. F.         Monto   ');
        writeln(arch, '---------------------------------------');
      end;
      QBonosOtros.DisableControls;
      QBonosOtros.First;
      while not QBonosOtros.eof do
      begin
        s := '';
        FillChar(s, 4-length(floattostr(QBonosOtrosticket.value)),' ');
        s1 := '';
        FillChar(s1, 12-length(FORMAT('%n',[QBonosOtrospagado.value])), ' ');

        if cktickets.Checked then
          writeln(arch, '  '+s+floattostr(QBonosOtrosticket.value)+' '+QBonosOtrosNCF.Value+' '+
          s1+FORMAT('%n',[QBonosOtrospagado.value]));

        BonosOtros := BonosOtros + QBonosOtrospagado.value;
        QBonosOtros.next;
      end;
      QBonosOtros.First;
      QBonosOtros.EnableControls;
      if cktickets.Checked then
      begin
        writeln(arch, '---------------------------------------');
        s2 := '';
        FillChar(s2, 12-length(trim(FORMAT('%n',[BonosOtros]))), ' ');
        writeln(arch, 'Total : '+s2+format('%n',[BonosOtros]));
      end;
    end;

    //Devoluciones
    Devolucion := 0;
    //MontoItbis := 0;
    if QDevolucion.RecordCount > 0 then
    begin
      if cktickets.Checked then
      begin
        writeln(arch, ' ');
        writeln(arch, dm.Centro('NOTAS DE CR'));
        writeln(arch, dm.Centro('-----------'));
        writeln(arch, '#Ticket       N. C. F.         Monto   ');
        writeln(arch, '---------------------------------------');
      end;
      QDevolucion.DisableControls;
      QDevolucion.First;
      while not QDevolucion.eof do
      begin
        s := '';
        FillChar(s, 4-length(floattostr(QDevolucionticket.value)),' ');
        s1 := '';
        FillChar(s1, 12-length(FORMAT('%n',[QDevolucionpagado.value])), ' ');

        if cktickets.Checked then
          writeln(arch, '  '+s+floattostr(QDevolucionticket.value)+' '+QDevolucionNCF.Value+' '+
          s1+FORMAT('%n',[QDevolucionpagado.value]));

        Devolucion := Devolucion + QDevolucionpagado.value;
        QDevolucion.next;
      end;
      QDevolucion.First;
      QDevolucion.EnableControls;
      if cktickets.Checked then
      begin
        writeln(arch, '---------------------------------------');
        s2 := '';
        FillChar(s2, 12-length(trim(FORMAT('%n',[Devolucion]))), ' ');
        writeln(arch, 'Total : '+s2+format('%n',[Devolucion]));
      end;
    end;

    //MontoItbis := dm.Query1.FieldByName('itbis').AsFloat;
    //TGrabado   := (MontoItbis * 100)/16;

    s := '';
    FillChar(s, 12-length(trim(FORMAT('%n',[Efectivo]))), ' ');
    s1 := '';
    FillChar(s1, 12-length(trim(FORMAT('%n',[Tarjeta]))), ' ');
    s2 := '';
    FillChar(s2, 12-length(trim(FORMAT('%n',[Cheque]))), ' ');
    s3 := '';
    FillChar(s3, 12-length(trim(FORMAT('%n',[Efectivo + Tarjeta +Cheque + BonosClub + BonosOtros]))), ' ');
    s4 := '';
    FillChar(s4, 12-length(trim(FORMAT('%n',[MontoItbis]))), ' ');
    s5 := '';
    FillChar(s5, 12-length(trim(FORMAT('%n',[Credito]))), ' ');
    s6 := '';
    FillChar(s6, 12-length(trim(FORMAT('%n',[TGrabado]))), ' ');
    s7 := '';
    FillChar(s7, 12-length(trim(FORMAT('%n',[TExcento]))), ' ');
    s8 := '';
    FillChar(s8, 12-length(trim(FORMAT('%n',[Anulados]))), ' ');
    s9 := '';
    FillChar(s9, 12-length(trim(FORMAT('%n',[BonosClub]))), ' ');
    s10 := '';
    FillChar(s10, 12-length(trim(FORMAT('%n',[BonosOtros]))), ' ');
    s11 := '';
    FillChar(s11, 12-length(trim(FORMAT('%n',[QCuadreefectivo_asignado.Value]))), ' ');

    writeln(arch, ' ');
    writeln(arch, dm.Centro('VENTA POR FORMA DE PAGO'));
    writeln(arch, dm.Centro('-----------------------'));
    writeln(arch, 'DEPOSITO      : '+s11+format('%n',[QCuadreefectivo_asignado.Value]));

    s11 := '';
    FillChar(s11, 12-length(trim(FORMAT('%n',[Devolucion]))), ' ');

    writeln(arch, 'TOTAL EFECTIVO: '+s+format('%n',[Efectivo]));
    writeln(arch, 'TOTAL TARJETA : '+s1+format('%n',[Tarjeta]));
    writeln(arch, 'TOTAL CHEQUE  : '+s2+format('%n',[Cheque]));
    writeln(arch, 'BONOS CLUB    : '+s9+FORMAT('%n',[BonosClub]));
    writeln(arch, 'OTROS         : '+s10+FORMAT('%n',[BonosOtros]));
    writeln(arch, 'NOTAS DE CR   : '+s11+FORMAT('%n',[Devolucion]));
    writeln(arch, '---------------------------------------');
    writeln(arch, 'TOTAL CONTADO : '+s3+FORMAT('%n',[(Efectivo + Tarjeta + Cheque + BonosClub + BonosOtros) - Devuelta]));
    writeln(arch, 'TOTAL NOTAS CR: '+s11+FORMAT('%n',[Devolucion]));
    writeln(arch, 'TOTAL CREDITO : '+s5+FORMAT('%n',[Credito]));

    Query1.Close;
    Query1.SQL.Clear;
    Query1.SQL.Add('select t.itbis, sum(case t.itbis when 0 then 0 else (((t.precio-((t.precio*isnull(t.descuento,0))/100))*t.cantidad) / ((t.itbis/100)+1)) end) as grabado');
    Query1.SQL.Add('from montos_ticket m, cajas_ip c, ticket t');
    Query1.SQL.Add('where m.caja = c.caja');
    Query1.SQL.Add('and m.fecha = t.fecha');
    Query1.SQL.Add('and m.caja = t.caja');
    Query1.SQL.Add('and m.ticket = t.ticket');
    Query1.SQL.Add('and m.usu_codigo = t.usu_codigo');
    Query1.SQL.Add('and m.fecha_hora between convert(datetime, :fec1, 113) and convert(datetime, :fec2, 113)');
    Query1.SQL.Add('and m.caja = :caj');
    Query1.SQL.Add('and m.usu_codigo = :usu');
    Query1.SQL.Add('and m.status = '+QuotedStr('FAC'));
    if Cuadrar_Empresa = 'C' then
       Query1.SQL.Add('and m.emp_codigo = '+inttostr(empresa_caja));
    Query1.SQL.Add('and t.itbis > 0');
    Query1.SQL.Add('group by t.itbis');
    Query1.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
    Query1.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
    Query1.Parameters.ParamByName('fec1').DataType := ftDateTime;
    Query1.Parameters.ParamByName('fec1').Value    := hora1.Date;
    Query1.Parameters.ParamByName('fec2').DataType := ftDateTime;
    Query1.Parameters.ParamByName('fec2').Value    := hora2.Date;;
    Query1.Open;

    TGrabado := 0;
    while not Query1.Eof do
    begin
      s6 := '';
      FillChar(s6, 12-length(trim(FORMAT('%n',[Query1.FieldByName('grabado').asFloat]))), ' ');
      writeln(arch, 'GRABADO '+formatfloat('00',Query1.FieldByName('itbis').asFloat)+'%' + '   : '+s6+
        FORMAT('%n',[Query1.FieldByName('grabado').asFloat]));

      TGrabado := TGrabado + Query1.FieldByName('grabado').asFloat;
      Query1.next;
    end;

    //Excento
    Query1.Close;
    Query1.SQL.Clear;
    Query1.SQL.Add('select sum(m.exento)exento');
    Query1.SQL.Add('from montos_ticket m');
    Query1.SQL.Add('where m.fecha_hora between convert(datetime, :fec1, 113) and convert(datetime, :fec2, 113)');
    Query1.SQL.Add('and m.caja = :caj');
    Query1.SQL.Add('and m.usu_codigo = :usu');
    Query1.SQL.Add('and m.status = '+QuotedStr('FAC'));
    if Cuadrar_Empresa = 'C' then
       Query1.SQL.Add('and m.emp_codigo = '+inttostr(empresa_caja));
    Query1.SQL.Add('and m.exento > 0');
    Query1.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
    Query1.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
    Query1.Parameters.ParamByName('fec1').DataType := ftDateTime;
    Query1.Parameters.ParamByName('fec1').Value    := hora1.Date;
    Query1.Parameters.ParamByName('fec2').DataType := ftDateTime;
    Query1.Parameters.ParamByName('fec2').Value    := hora2.Date;;
    Query1.Open;

    TExcento := 0;
    while not Query1.Eof do
    begin
      TExcento := TExcento + Query1.FieldByName('exento').asFloat;
      Query1.next;
    end;

    //TExcento := (Efectivo+Tarjeta+Cheque+Credito+BonosClub+BonosOtros+QCuadreefectivo_asignado.Value) - devuelta - (TGrabado + MontoItbis);
    if TExcento < 0 then TExcento := 0;

    s7 := '';
    FillChar(s7, 12-length(trim(FORMAT('%n',[TExcento]))), ' ');

    writeln(arch, 'TOTAL ITBIS   : '+s4+FORMAT('%n',[MontoItbis]));
    writeln(arch, 'TOTAL EXENTO  : '+s7+FORMAT('%n',[TExcento]));
    writeln(arch, 'TOTAL ANULADOS: '+s8+FORMAT('%n',[Anulados]));
    writeln(arch, 'CANT.  BOLETOS: '+inttostr(boletos));

    s := '';
    FillChar(s, 12-length(dm.Query1.FieldByName('cantidad').AsString), ' ');
    writeln(arch, 'CANTIDAD TKS  : '+s+dm.Query1.FieldByName('cantidad').AsString);

    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select count(*) as cantidad from montos_ticket');
    dm.Query1.SQL.Add('where caja = :caj');
    dm.Query1.SQL.Add('and usu_codigo = :usu');
    dm.Query1.SQL.Add('and fecha_hora between convert(datetime, :fec1, 113) and convert(datetime, :fec2, 113)');
    dm.Query1.SQL.Add('and status = :st');
    if Cuadrar_Empresa = 'C' then
       dm.Query1.SQL.Add('and emp_codigo = '+inttostr(empresa_caja));
    dm.Query1.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
    dm.Query1.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
    dm.Query1.Parameters.ParamByName('fec1').DataType := ftDateTime;
    dm.Query1.Parameters.ParamByName('fec1').Value    := hora1.Date;
    dm.Query1.Parameters.ParamByName('fec2').DataType := ftDateTime;
    dm.Query1.Parameters.ParamByName('fec2').Value    := hora2.Date;;
    dm.Query1.Parameters.ParamByName('st').Value      := 'ANU';
    dm.Query1.Open;

    s := '';
    FillChar(s, 12-length(dm.Query1.FieldByName('cantidad').AsString), ' ');

    writeln(arch, 'TKS ANULADOS  : '+s+dm.Query1.FieldByName('cantidad').AsString);
    writeln(arch, 'TOTAL EN CAJA : '+s3+format('%n',[(Efectivo+Tarjeta+Cheque+Credito+BonosClub+BonosOtros+QCuadreefectivo_asignado.Value) - devuelta]));

    if TotalDesgloce > 0 then
    begin
      writeln(arch, '');
      writeln(arch, '---------------------------------------');
      writeln(arch, '   M O N T O  CANTIDAD   V A L O R ');
      writeln(arch, '---------------------------------------');
      frmDesgloce.QMontos.First;
      while not frmDesgloce.QMontos.Eof do
      begin
        s := '';
        FillChar(s, 12-length(Format('%n',[frmDesgloce.QMontosmonto.AsFloat])),' ');
        s1 := '';
        FillChar(s1, 5-length(IntToStr(frmDesgloce.QMontoscantidad.AsInteger)),' ');
        s2 := '';
        FillChar(s2, 12-length(Format('%n',[frmDesgloce.QMontosValor.AsFloat])),' ');

        writeln(arch, s+Format('%n',[frmDesgloce.QMontosmonto.AsFloat])+' '+s1+
               IntToStr(frmDesgloce.QMontoscantidad.AsInteger)+'        '+s2+
               Format('%n',[frmDesgloce.QMontosValor.AsFloat]));

        frmDesgloce.QMontos.Next;
      end;
      frmDesgloce.QMontos.First;
      s := '';
      FillChar(s, 29-length(Format('%n',[frmDesgloce.QMontosValor.AsFloat - TotalDesgloce])),' ');
      s1 := '';
      FillChar(s1, 28-length(Format('%n',[frmDesgloce.QMontosValor.AsFloat - TotalDesgloce])),' ');
      s2 := '';
      FillChar(s2, 29-length(Format('%n',[((Efectivo + Tarjeta + Cheque + BonosClub + BonosOtros) - Devuelta) - TotalDesgloce])),' ');

      writeln(arch, '---------------------------------------');
      writeln(arch, 'T O T A L  '+s+Format('%n',[TotalDesgloce]));
      writeln(arch, 'DIFERENCIA '+s2+Format('%n',[TotalDesgloce - ((Efectivo + Tarjeta + Cheque + BonosClub + BonosOtros) - Devuelta)]));
      writeln(arch, '');
    end;

    writeln(arch, ' ');
    writeln(arch, ' ');
    writeln(arch, ' ');
    writeln(arch, ' ');
    writeln(arch, ' ');
    writeln(arch, ' ');
    writeln(arch, '------------------------');
    writeln(arch, 'Firma del Cajero');
    writeln(arch, ' ');
    writeln(arch, ' ');
    writeln(arch, ' ');
    writeln(arch, ' ');
    writeln(arch, ' ');
    writeln(arch, '------------------------');
    writeln(arch, 'Firma del Supervisor');
    writeln(arch, ' ');
    writeln(arch, ' ');
    writeln(arch, ' ');
    writeln(arch, ' ');
    writeln(arch, ' ');
    writeln(arch, ' ');
    writeln(arch, ' ');
    writeln(arch, ' ');
    
  end;

  {writeln(arch, '');
  writeln(arch, '---------------------------------------');
  writeln(arch, 'N.C.F         TOTAL');
  writeln(arch, '---------------------------------------');
  while not QNCF.Eof do
  begin
    s := '';
    FillChar(s, 12-length(format('%n',[QNCFtotal.Value])), ' ');
    writeln(arch, QNCFncf_fijo.value+' '+s+format('%n',[QNCFtotal.Value]));

    QNCF.Next;
  end;
  writeln(arch, '');}

  {if ckproductos.Checked then
  begin
    writeln(arch, '');
    writeln(arch, '---------------------------------------');
    writeln(arch, 'DESCRIPCION DEL PRODUCTO       CANTIDAD');  
    writeln(arch, '---------------------------------------');

    QProductos.Close;
    QProductos.Parameters.ParamByName('caj').Value     := DBLookupComboBox1.KeyValue;
    QProductos.Parameters.ParamByName('usu').Value     := DBLookupComboBox2.KeyValue;
    QProductos.Parameters.ParamByName('fec1').DataType := ftDateTime;
    QProductos.Parameters.ParamByName('fec1').Value    := hora1.Date;
    QProductos.Parameters.ParamByName('fec2').DataType := ftDateTime;
    QProductos.Parameters.ParamByName('fec2').Value    := hora2.Date;
    QProductos.Open;

    while not QProductos.Eof do
    begin
      s := '';
      FillChar(s, 30-length(Trim(QProductosdescripcion.Value)), ' ');
      s1 := '';
      FillChar(s1, 8-length(trim(FORMAT('%n',[QProductoscantidad.Value]))), ' ');

      writeln(arch, copy(Trim(QProductosdescripcion.Value),1,30)+s+' '+s1+FORMAT('%n',[QProductoscantidad.Value]));

      QProductos.Next;
    end;
  end;

  writeln(arch, ' ');
  writeln(arch, ' ');
  writeln(arch, ' ');
  writeln(arch, ' ');
  writeln(arch, ' ');
  writeln(arch, ' ');
  writeln(arch, '------------------------');
  writeln(arch, 'Firma del Cajero');
  writeln(arch, ' ');
  writeln(arch, ' ');
  writeln(arch, ' ');
  writeln(arch, ' ');
  writeln(arch, ' ');
  writeln(arch, ' ');}

  closefile(Arch);
  winexec('imp.bat',0);
end;

procedure TfrmCuadre.btimprimirClick(Sender: TObject);
begin
    //Envia la factura a la impresora
  case Impresora.IDPrinter of
    0 : ImprimirCuadre;
    1 : {EPSON (TMU-220)} ImpCuadreNoFiscalEpson(Impresora);
    //2 : {CITIZEN ( CT-S310 )}  ImpTicketVmaxFiscal(impresora.puerto,impresora.velocidad,impresora.copia,impresora.Tipo,impresora.Precioconitbis);
    //3 : {CITIZEN (GSX-190)}    ImpTicketVmaxFiscal(impresora.puerto,impresora.velocidad,impresora.copia,impresora.Tipo,impresora.Precioconitbis);
    //4 : {STAR (TSP650FP)}      ImpTicketVmaxFiscal(impresora.puerto,impresora.velocidad,impresora.copia,impresora.Tipo,impresora.Precioconitbis);
    5 : {Bixolon SRP-350iiHG}  ImpCuadreNoFiscalBixolon(Impresora);
  end;
end;

procedure TfrmCuadre.ImpCuadreNoFiscalEpson(ImpresoraFiscal: TImpresora);
VAR
    DriverFiscal1 : TDriverFiscal;
begin

  Puerto := PuertoSerial[Impresora.Puerto -1];
  DriverFiscal1 := TDriverFiscal.Create(Self);
  DriverFiscal1.SerialNumber := '27-0163848-435';

  try
    err := DriverFiscal1.IF_OPEN(puerto, ImpresoraFiscal.Velocidad);
    if (err <> 0 ) then
      begin
        ShowMessage('Error : No hay comunicacion con el printer'+#13+#10+
        'Impresion cancelada');
        exit;
      end;

    err := DriverFiscal1.IF_WRITE('@OpenNonFiscalReceipt');

    setLimpiarVariables();
    hora1.Date := fecha1.Date;
    hora2.Date := fecha2.Date;

    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select emp_codigo, puerto, Tipo_Cuadre, Cuadrar_Empresa from cajas_IP');
    dm.Query1.SQL.Add('where caja = :caj');
    dm.Query1.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
    dm.Query1.Open;
    Puerto := dm.Query1.FieldByName('puerto').AsString;
    tipo_cuadre := dm.Query1.FieldByName('Tipo_Cuadre').AsString;
    Cuadrar_Empresa := dm.Query1.FieldByName('Cuadrar_Empresa').AsString;
    empresa_caja := dm.Query1.FieldByName('emp_codigo').AsInteger;

    if (Cuadrar_Empresa = 'C') and (not realizo) then
    begin
      realizo := true;
      QEfectivo.SQL.Add('and m.emp_codigo = '+inttostr(empresa_caja));
      QCheque.SQL.Add('and m.emp_codigo = '+inttostr(empresa_caja));
      QTarjeta.SQL.Add('and m.emp_codigo = '+inttostr(empresa_caja));
      QCredito.SQL.Add('and m.emp_codigo = '+inttostr(empresa_caja));
      QBonosClub.SQL.Add('and m.emp_codigo = '+inttostr(empresa_caja));
      QBonosOtros.SQL.Add('and m.emp_codigo = '+inttostr(empresa_caja));
    end;

    graba;

    QNCF.Close;
    QNCF.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
    QNCF.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
    QNCF.Parameters.ParamByName('fec1').DataType := ftDateTime;
    QNCF.Parameters.ParamByName('fec1').Value    := hora1.DateTime;
    QNCF.Parameters.ParamByName('fec2').DataType := ftDateTime;
    QNCF.Parameters.ParamByName('fec2').Value    := hora2.DateTime;
    QNCF.Open;

    QEfectivo.Close;
    QEfectivo.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
    QEfectivo.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
    QEfectivo.Parameters.ParamByName('fec1').DataType := ftDateTime;
    QEfectivo.Parameters.ParamByName('fec1').Value    := hora1.DateTime;
    QEfectivo.Parameters.ParamByName('fec2').DataType := ftDateTime;
    QEfectivo.Parameters.ParamByName('fec2').Value    := hora2.DateTime;
    QEfectivo.Open;

    QCheque.Close;
    QCheque.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
    QCheque.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
    QCheque.Parameters.ParamByName('fec1').DataType := ftDateTime;
    QCheque.Parameters.ParamByName('fec1').Value    := hora1.DateTime;
    QCheque.Parameters.ParamByName('fec2').DataType := ftDateTime;
    QCheque.Parameters.ParamByName('fec2').Value    := hora2.DateTime;
    QCheque.Open;

    QTarjeta.Close;
    QTarjeta.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
    QTarjeta.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
    QTarjeta.Parameters.ParamByName('fec1').DataType := ftDateTime;
    QTarjeta.Parameters.ParamByName('fec1').Value    := hora1.DateTime;
    QTarjeta.Parameters.ParamByName('fec2').DataType := ftDateTime;
    QTarjeta.Parameters.ParamByName('fec2').Value    := hora2.DateTime;
    QTarjeta.Open;

    QCredito.Close;
    QCredito.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
    QCredito.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
    QCredito.Parameters.ParamByName('fec1').DataType := ftDateTime;
    QCredito.Parameters.ParamByName('fec1').Value    := hora1.DateTime;
    QCredito.Parameters.ParamByName('fec2').DataType := ftDateTime;
    QCredito.Parameters.ParamByName('fec2').Value    := hora2.DateTime;
    QCredito.Open;

    QAnulados.Close;
    QAnulados.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
    QAnulados.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
    QAnulados.Parameters.ParamByName('fec1').DataType := ftDateTime;
    QAnulados.Parameters.ParamByName('fec1').Value    := hora1.DateTime;
    QAnulados.Parameters.ParamByName('fec2').DataType := ftDateTime;
    QAnulados.Parameters.ParamByName('fec2').Value    := hora2.DateTime;
    QAnulados.Open;

    QBonosClub.Close;
    QBonosClub.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
    QBonosClub.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
    QBonosClub.Parameters.ParamByName('fec1').DataType := ftDateTime;
    QBonosClub.Parameters.ParamByName('fec1').Value    := hora1.DateTime;
    QBonosClub.Parameters.ParamByName('fec2').DataType := ftDateTime;
    QBonosClub.Parameters.ParamByName('fec2').Value    := hora2.DateTime;
    QBonosClub.Open;

    QBonosOtros.Close;
    QBonosOtros.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
    QBonosOtros.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
    QBonosOtros.Parameters.ParamByName('fec1').DataType := ftDateTime;
    QBonosOtros.Parameters.ParamByName('fec1').Value    := hora1.DateTime;
    QBonosOtros.Parameters.ParamByName('fec2').DataType := ftDateTime;
    QBonosOtros.Parameters.ParamByName('fec2').Value    := hora2.DateTime;
    QBonosOtros.Open;

    QDevolucion.Close;
    QDevolucion.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
    QDevolucion.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
    QDevolucion.Parameters.ParamByName('fec1').DataType := ftDateTime;
    QDevolucion.Parameters.ParamByName('fec1').Value    := hora1.DateTime;
    QDevolucion.Parameters.ParamByName('fec2').DataType := ftDateTime;
    QDevolucion.Parameters.ParamByName('fec2').Value    := hora2.DateTime;
    QDevolucion.Open;

    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+dm.centro(dm.QEmpresaemp_nombre.Value));
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+dm.centro(dm.QEmpresaemp_direccion.Value));
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+dm.centro(dm.QEmpresaEMP_LOCALIDAD.Value));
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+dm.centro(dm.QEmpresaEMP_TELEFONO.Value));
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+dm.centro('RNC:'+dm.QEmpresaEMP_RNC.Value));
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+' ');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+dm.centro('CUADRE DE CAJA'));
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+' ');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'Cuadre#: '+QCuadresecuencia.asstring);
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'Desde  : '+DateToStr(fecha1.Date)+' '+TimeToStr(Hora1.Time));
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'Hasta  : '+DateToStr(fecha2.Date)+' '+TimeToStr(Hora2.Time));
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'Cajero : '+DBLookupComboBox2.Text);
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'Caja   : '+DBLookupComboBox1.Text);
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+' ');

  if tipo_cuadre = 'D' then
  begin
    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select sum(boletos) as boletos from montos_ticket');
    dm.Query1.SQL.Add('where caja = :caj');
    dm.Query1.SQL.Add('and usu_codigo = :usu');
    dm.Query1.SQL.Add('and fecha_hora between convert(datetime, :fec1, 113) and convert(datetime, :fec2, 113)');
    dm.Query1.SQL.Add('and status = '+QuotedStr('FAC'));
    if Cuadrar_Empresa = 'C' then
       dm.Query1.SQL.Add('and emp_codigo = '+inttostr(empresa_caja));
    dm.Query1.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
    dm.Query1.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
    dm.Query1.Parameters.ParamByName('fec1').DataType := ftDateTime;
    dm.Query1.Parameters.ParamByName('fec1').Value    := hora1.DateTime;
    dm.Query1.Parameters.ParamByName('fec2').DataType := ftDateTime;
    dm.Query1.Parameters.ParamByName('fec2').Value    := hora2.DateTime;
    dm.Query1.Open;
    boletos := dm.Query1.FieldByName('boletos').AsInteger;

    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select count(*) as cantidad from montos_ticket');
    dm.Query1.SQL.Add('where caja = :caj');
    dm.Query1.SQL.Add('and usu_codigo = :usu');
    dm.Query1.SQL.Add('and fecha_hora between convert(datetime, :fec1, 113) and convert(datetime, :fec2, 113)');
    dm.Query1.SQL.Add('and status in (:st1, :st2)');
    if Cuadrar_Empresa = 'C' then
       dm.Query1.SQL.Add('and emp_codigo = '+inttostr(empresa_caja));
    dm.Query1.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
    dm.Query1.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
    dm.Query1.Parameters.ParamByName('fec1').DataType := ftDateTime;
    dm.Query1.Parameters.ParamByName('fec1').Value    := hora1.DateTime;
    dm.Query1.Parameters.ParamByName('fec2').DataType := ftDateTime;
    dm.Query1.Parameters.ParamByName('fec2').Value    := hora2.DateTime;
    dm.Query1.Parameters.ParamByName('st1').Value  := 'ANU';
    dm.Query1.Parameters.ParamByName('st2').Value  := 'CAN';
    dm.Query1.Open;
    cancelados := dm.Query1.FieldByName('cantidad').AsInteger;

    Query1.Close;
    Query1.SQL.Clear;
    Query1.SQL.Add('select 1, '+QuotedStr('EFECTIVO')+' as nombre');
    Query1.SQL.Add('union select 2, '+QuotedStr('TARJETA'));
    Query1.SQL.Add('union select 3, '+QuotedStr('CHEQUE'));
    Query1.SQL.Add('union select 4, '+QuotedStr('BONOS CLUB'));
    Query1.SQL.Add('union select 5, '+QuotedStr('OTROS'));
    Query1.SQL.Add('union select 6, '+QuotedStr('NOTAS DE CREDITO'));
    Query1.SQL.Add('union select 7, '+QuotedStr('CREDITO'));
    Query1.Open;

    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'---------------------------------');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'DESCRIPCION       |    MONTO    |');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'---------------------------------');
    Total       := 0;
    devuelta    := 0;
    Devolucion  := 0;
    credito     := 0;
    cantcredito := 0;
    cantcontado := 0;

    while not Query1.Eof do
    begin
      forma := '';
      if Query1.FieldByName('nombre').AsString = 'EFECTIVO' then
        forma := 'EFE'
      else if Query1.FieldByName('nombre').AsString = 'CHEQUE' then
        forma := 'CHE'
      else if Query1.FieldByName('nombre').AsString = 'TARJETA' then
        forma := 'TAR'
      else if Query1.FieldByName('nombre').AsString = 'BONOS CLUB' then
        forma := 'BOC'
      else if Query1.FieldByName('nombre').AsString = 'OTROS' then
        forma := 'OBO'
      else if Query1.FieldByName('nombre').AsString = 'CREDITO' then
        forma := 'CRE'
      else if Query1.FieldByName('nombre').AsString = 'NOTAS DE CREDITO' then
        forma := 'DEV';

      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('select sum(f.pagado) as pagado, sum(f.pagado-f.devuelta) as total,');
      dm.Query1.SQL.Add('sum(f.devuelta) as devuelta, sum(m.total) as monto_total');
      dm.Query1.SQL.Add('from montos_ticket m, formas_pago_ticket f');
      dm.Query1.SQL.Add('where m.caja = f.caja');
      dm.Query1.SQL.Add('and m.usu_codigo = f.usu_codigo');
      dm.Query1.SQL.Add('and m.fecha = f.fecha');
      dm.Query1.SQL.Add('and m.ticket = f.ticket');
      dm.Query1.SQL.Add('and m.status = '+QuotedStr('FAC'));
      dm.Query1.SQL.Add('and m.caja = :caj');
      dm.Query1.SQL.Add('and m.usu_codigo = :usu');
      dm.Query1.SQL.Add('and m.fecha_hora between convert(datetime, :fec1, 113) and convert(datetime, :fec2, 113)');
      dm.Query1.SQL.Add('and f.forma = '+QuotedStr(forma));
      if Cuadrar_Empresa = 'C' then
         dm.Query1.SQL.Add('and m.emp_codigo = '+inttostr(empresa_caja));
      dm.Query1.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
      dm.Query1.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
      dm.Query1.Parameters.ParamByName('fec1').DataType := ftDateTime;
      dm.Query1.Parameters.ParamByName('fec1').Value    := hora1.DateTime;
      dm.Query1.Parameters.ParamByName('fec2').DataType := ftDateTime;
      dm.Query1.Parameters.ParamByName('fec2').Value    := hora2.DateTime;
      dm.Query1.Open;

      if forma = 'DEV' then
      begin
        Devolucion := Devolucion + dm.Query1.FieldByName('pagado').AsFloat;
        if dm.Query1.FieldByName('pagado').AsFloat > 0 then
          cantcontado := cantcontado - 1;
      end
      else if forma = 'CRE' then
      begin
        credito := credito + dm.Query1.FieldByName('monto_total').AsFloat;
        if dm.Query1.FieldByName('monto_total').AsFloat > 0 then
          cantcredito := cantcredito + 1;
      end
      else
      begin
        s  := '';
        FillChar(s, 12-length(format('%n',[dm.Query1.FieldByName('pagado').AsFloat])),' ');
        s1 := '';
        FillChar(s1, 18-length(Query1.FieldByName('nombre').AsString),' ');
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+Query1.FieldByName('nombre').AsString+s1+'|'+s+'$'+format('%n',[dm.Query1.FieldByName('pagado').AsFloat])+'|'+'(+)');

        devuelta := devuelta + dm.Query1.FieldByName('devuelta').AsFloat;
        Total := Total + dm.Query1.FieldByName('pagado').AsFloat;
        cantcontado := cantcontado + 1;
      end;

      Query1.Next;
    end;
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'                  --------------|');
    s  := '';
    FillChar(s, 12-length(format('%n',[total])),' ');
    s1  := '';
    FillChar(s1, 12-length(format('%n',[devuelta])),' ');
    s2  := '';
    FillChar(s2, 12-length(format('%n',[(total-devuelta)+devolucion+credito])),' ');
    s3  := '';
    FillChar(s3, 12-length(format('%n',[QCuadreefectivo_asignado.Value])),' ');
    s7 := '';
    FillChar(s7, 12-length(format('%n',[devolucion])),' ');
    s5  := '';
    FillChar(s5, 12-length(format('%n',[(total-devuelta)+QCuadreefectivo_asignado.Value+devolucion+credito])),' ');
    s8  := '';
    FillChar(s8, 12-length(format('%n',[credito])),' ');
    s9  := '';
    FillChar(s9, 12-length(format('%n',[(total-devuelta)])),' ');

    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'SUBTOTAL          |'+s +'$'+format('%n',[total])+'|');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'EFECTIVO DEVUELTO |'+s1+'$'+format('%n',[devuelta])+'|'+'(-)');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'                  --------------|');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'SUBTOTAL          |'+s9+'$'+format('%n',[(total-devuelta)])+'|');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'CREDITO           |'+s8 +'$'+format('%n',[credito])+'|'+'(+)');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'NOTAS DE CREDITO  |'+s7 +'$'+format('%n',[devolucion])+'|'+'(-)');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'                  --------------|');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'TOTAL VENDIDO     |'+s2 +'$'+format('%n',[(total-devuelta)+devolucion+credito])+'|');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'DEPOSITO EN CAJA  |'+s3 +'$'+format('%n',[QCuadreefectivo_asignado.Value])+'|'+'(+)');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'CANTIDAD BOLETOS  |'+inttostr(boletos));
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'                  --------------|');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'TOTAL EN CAJA     |'+s5 +'$'+format('%n',[(total-devuelta) +QCuadreefectivo_asignado.Value+devolucion+credito])+'|');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'                  ===============');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+' ');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'---------------------------------');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'TIPO        |CANT.|    MONTO    |');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'---------------------------------');

    s  := '';
    FillChar(s, 5-length(inttostr(cantcontado)),' ');
    s1  := '';
    FillChar(s1, 12-length(format('%n',[(total-devuelta)+devolucion])),' ');
    s2  := '';
    FillChar(s2, 5-length(inttostr(cantcredito)),' ');
    s4  := '';
    FillChar(s4, 5-length(inttostr(cancelados)),' ');
    s5  := '';
    FillChar(s5, 5-length(inttostr(cantcontado+cantcredito+cancelados)),' ');
    s6  := '';
    FillChar(s6, 12-length(format('%n',[(total-devuelta)+credito+devolucion])),' ');
    s9  := '';
    FillChar(s9, 12-length(format('%n',[(total-devuelta)+credito])),' ');

    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'CONTADO     |'+s+inttostr(cantcontado)+'|'+s1+'$'+format('%n',[(total-devuelta)+devolucion])+'|(+)');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'CREDITO     |'+s2+inttostr(cantcredito)+'|'+s8+'$'+format('%n',[credito])+'|(+)');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'ANULADOS    |'+s4+inttostr(cancelados)+'|'+'        $0.00|(+)');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'            --------------------|');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'SUBTOTAL    |'+s5+inttostr(cantcontado+cantcredito+cancelados)+'|'+s6+'$'+format('%n',[(total-devuelta)+devolucion+credito])+'|');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'NOTAS DE CR |     |'+s7+'$'+format('%n',[devolucion])+'|(-)');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'            --------------------|');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'TOTAL       |'+s5+inttostr(cantcontado+cantcredito+cancelados)+'|'+s9+'$'+format('%n',[(total-devuelta)+credito])+'|');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'            =====================');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+' ');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'---------------------------------');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'DESCRIPCION       |    MONTO    |');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'---------------------------------');

    s  := '';
    FillChar(s, 12-length(format('%n',[TExcento])),' ');
    s1  := '';
    FillChar(s1, 12-length(format('%n',[TGrabado])),' ');
    s2  := '';
    FillChar(s2, 12-length(format('%n',[MontoItbis])),' ');
    s3  := '';
    FillChar(s3, 12-length(format('%n',[TExcento+TGrabado+MontoItbis])),' ');

    //writeln(arch,'VENTA EXENTA      |'+s+'$'+format('%n',[TExcento])+'|(+)');
    //writeln(arch,'VENTA GRABADA     |'+s1+'$'+format('%n',[TGrabado])+'|(+)');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'TOTAL ITBIS       |'+s2+'$'+format('%n',[MontoItbis])+'|(+)');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'                  --------------|');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'TOTAL             |'+s3+'$'+format('%n',[TExcento+TGrabado+MontoItbis])+'|(+)');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'                  ===============');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ ' ');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ ' ');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ ' ');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ ' ');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ ' ');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ ' ');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ '------------------------');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'Firma del Cajero');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ ' ');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ ' ');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ ' ');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ ' ');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ ' ');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ '------------------------');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'Firma del Supervisor');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ ' ');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ ' ');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ ' ');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ ' ');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ ' ');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ ' ');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ ' ');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ ' ');
  end
  else
  begin
    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select sum(isnull(itbis,0)) as itbis from montos_ticket');
    dm.Query1.SQL.Add('where caja = :caj');
    dm.Query1.SQL.Add('and usu_codigo = :usu');
    dm.Query1.SQL.Add('and fecha_hora between convert(datetime, :fec1, 113) and convert(datetime, :fec2, 113)');
    dm.Query1.SQL.Add('and status = '+QuotedStr('FAC'));
    if Cuadrar_Empresa = 'C' then
       dm.Query1.SQL.Add('and emp_codigo = '+inttostr(empresa_caja));
    dm.Query1.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
    dm.Query1.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
    dm.Query1.Parameters.ParamByName('fec1').DataType := ftDateTime;
    dm.Query1.Parameters.ParamByName('fec1').Value    := hora1.DateTime;
    dm.Query1.Parameters.ParamByName('fec2').DataType := ftDateTime;
    dm.Query1.Parameters.ParamByName('fec2').Value    := hora2.DateTime;
    dm.Query1.Open;
    MontoItbis := dm.Query1.FieldByName('itbis').AsFloat;

    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select sum(boletos) as boletos from montos_ticket');
    dm.Query1.SQL.Add('where caja = :caj');
    dm.Query1.SQL.Add('and usu_codigo = :usu');
    dm.Query1.SQL.Add('and fecha_hora between convert(datetime, :fec1, 113) and convert(datetime, :fec2, 113)');
    dm.Query1.SQL.Add('and status = '+QuotedStr('FAC'));
    if Cuadrar_Empresa = 'C' then
       dm.Query1.SQL.Add('and emp_codigo = '+inttostr(empresa_caja));
    dm.Query1.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
    dm.Query1.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
    dm.Query1.Parameters.ParamByName('fec1').DataType := ftDateTime;
    dm.Query1.Parameters.ParamByName('fec1').Value    := hora1.DateTime;
    dm.Query1.Parameters.ParamByName('fec2').DataType := ftDateTime;
    dm.Query1.Parameters.ParamByName('fec2').Value    := hora2.DateTime;
    dm.Query1.Open;
    boletos := dm.Query1.FieldByName('boletos').AsInteger;

    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select count(*) as cantidad from montos_ticket');
    dm.Query1.SQL.Add('where caja = :caj');
    dm.Query1.SQL.Add('and usu_codigo = :usu');
    dm.Query1.SQL.Add('and fecha_hora between convert(datetime, :fec1, 113) and convert(datetime, :fec2, 113)');
    if Cuadrar_Empresa = 'C' then
       dm.Query1.SQL.Add('and emp_codigo = '+inttostr(empresa_caja));
    dm.Query1.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
    dm.Query1.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
    dm.Query1.Parameters.ParamByName('fec1').DataType := ftDateTime;
    dm.Query1.Parameters.ParamByName('fec1').Value    := hora1.DateTime;
    dm.Query1.Parameters.ParamByName('fec2').DataType := ftDateTime;
    dm.Query1.Parameters.ParamByName('fec2').Value    := hora2.DateTime;
    dm.Query1.Open;

    //Efectivo
    if QEfectivo.RecordCount > 0 then
    begin
      if cktickets.Checked then
      begin
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ dm.Centro('EFECTIVO'));
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ dm.Centro('--------'));
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ '#Ticket       N. C. F.         Monto   ');
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ '---------------------------------------');
      end;
      QEfectivo.DisableControls;
      QEfectivo.First;
      while not QEfectivo.eof do
      begin
        s := '';
        FillChar(s, 4-length(floattostr(QEfectivoticket.value)),' ');
        s1 := '';
        FillChar(s1, 12-length(FORMAT('%n',[QEfectivopagado.value])), ' ');

        if cktickets.Checked then
          err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ '  '+s+floattostr(QEfectivoticket.value)+' '+QEfectivoNCF.Value+' '+
          s1+FORMAT('%n',[QEfectivopagado.value]));

        Efectivo := Efectivo + QEfectivopagado.value;
        QEfectivo.next;
      end;
      QEfectivo.First;
      QEfectivo.EnableControls;
      if cktickets.Checked then
      begin
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ '---------------------------------------');
        s2 := '';
        FillChar(s2, 12-length(trim(FORMAT('%n',[Efectivo]))), ' ');
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'Total : '+s2+format('%n',[Efectivo]));
      end;
    end;

    //Tarjeta
    Tarjeta := 0;
    //MontoItbis := 0;
    if QTarjeta.RecordCount > 0 then
    begin
      if cktickets.Checked then
      begin
        writeln(arch, ' ');
        writeln(arch, dm.Centro('TARJETA'));
        writeln(arch, dm.Centro('-------'));
        writeln(arch, '#Ticket       N. C. F.         Monto   ');
        writeln(arch, '---------------------------------------');
      end;
      QTarjeta.DisableControls;
      QTarjeta.First;
      while not QTarjeta.eof do
      begin
        s := '';
        FillChar(s, 4-length(floattostr(QTarjetaticket.value)),' ');
        s1 := '';
        FillChar(s1, 12-length(FORMAT('%n',[QTarjetapagado.value])), ' ');

        if cktickets.Checked then
          err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ '  '+s+floattostr(QTarjetaticket.value)+' '+QTarjetaNCF.Value+' '+
          s1+FORMAT('%n',[QTarjetapagado.value]));

        Tarjeta := Tarjeta + QTarjetapagado.value;
        QTarjeta.next;
      end;
      QTarjeta.First;
      QTarjeta.EnableControls;
      if cktickets.Checked then
      begin
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ '---------------------------------------');
        s2 := '';
        FillChar(s2, 12-length(trim(FORMAT('%n',[Tarjeta]))), ' ');
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'Total : '+s2+format('%n',[Tarjeta]));
      end;
    end;

    //Cheque
    Cheque := 0;
    //MontoItbis := 0;
    if QCheque.RecordCount > 0 then
    begin
      if cktickets.Checked then
      begin
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ ' ');
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ dm.Centro('CHEQUE'));
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ dm.Centro('------'));
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ '#Ticket       N. C. F.         Monto   ');
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ '---------------------------------------');
      end;
      QCheque.DisableControls;
      QCheque.First;
      while not QCheque.eof do
      begin
        s := '';
        FillChar(s, 4-length(floattostr(QChequeticket.value)),' ');
        s1 := '';
        FillChar(s1, 12-length(FORMAT('%n',[QChequepagado.value])), ' ');

        if cktickets.Checked then
          err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ '  '+s+floattostr(QChequeticket.value)+' '+QChequeNCF.Value+' '+
          s1+FORMAT('%n',[QChequepagado.value]));

        Cheque := Cheque + QChequepagado.value;
        devuelta := devuelta + QChequedevuelta.Value;
        QCheque.next;
      end;
      QCheque.First;
      QCheque.EnableControls;
      if cktickets.Checked then
      begin
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ '---------------------------------------');
        s2 := '';
        FillChar(s2, 12-length(trim(FORMAT('%n',[Cheque]))), ' ');
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'Total : '+s2+format('%n',[Cheque]));
      end;
    end;

    //Credito
    Credito := 0;
    //MontoItbis := 0;
    if QCredito.RecordCount > 0 then
    begin
      if cktickets.Checked then
      begin
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ ' ');
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ dm.Centro('CREDITO'));
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ dm.Centro('-------'));
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ '#Ticket       N. C. F.         Monto   ');
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ '---------------------------------------');
      end;
      QCredito.DisableControls;
      QCredito.First;
      while not QCredito.eof do
      begin
        s := '';
        FillChar(s, 4-length(floattostr(QCreditoticket.value)),' ');
        s1 := '';
        FillChar(s1, 12-length(FORMAT('%n',[QCreditopagado.value])), ' ');

        if cktickets.Checked then
          err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ '  '+s+floattostr(QCreditoticket.value)+' '+QCreditoNCF.Value+' '+
          s1+FORMAT('%n',[QCreditopagado.value]));

        Credito := Credito + QCreditopagado.value;
        QCredito.next;
      end;
      QCredito.First;
      QCredito.EnableControls;
      if cktickets.Checked then
      begin
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ '---------------------------------------');
        s2 := '';
        FillChar(s2, 12-length(trim(FORMAT('%n',[Credito]))), ' ');
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'Total : '+s2+format('%n',[Credito]));
      end;
    end;

    //Anulados
    Anulados := 0;
    TCancelados := 0;
    //MontoItbis := 0;
    if QAnulados.RecordCount > 0 then
    begin
      if cktickets.Checked then
      begin
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ ' ');
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ dm.Centro('ANULADOS/CANCELADOS'));
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ dm.Centro('-------------------'));
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ '#Ticket       N. C. F.         Monto   ');
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ '---------------------------------------');
      end;
      QAnulados.DisableControls;
      QAnulados.First;
      while not QAnulados.eof do
      begin
        s := '';
        FillChar(s, 4-length(floattostr(QAnuladosticket.value)),' ');
        s1 := '';
        FillChar(s1, 12-length(FORMAT('%n',[QAnuladospagado.value])), ' ');

        if cktickets.Checked then
          err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ '  '+s+floattostr(QAnuladosticket.value)+' '+QAnuladosNCF.Value+' '+
          s1+FORMAT('%n',[QAnuladospagado.value]));

        Anulados := Anulados + QAnuladostotal.value;
        QAnulados.next;
      end;
      QAnulados.First;
      QAnulados.EnableControls;
      if cktickets.Checked then
      begin
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ '---------------------------------------');
        s2 := '';
        FillChar(s2, 12-length(trim(FORMAT('%n',[Anulados]))), ' ');
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'Total : '+s2+format('%n',[Anulados]));
      end;
    end;

    //Bonos del Club
    BonosClub := 0;
    //MontoItbis := 0;
    if QBonosClub.RecordCount > 0 then
    begin
      if cktickets.Checked then
      begin
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ ' ');
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ dm.Centro('BONOS CLUB'));
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ dm.Centro('----------'));
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ '#Ticket       N. C. F.         Monto   ');
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ '---------------------------------------');
      end;
      QBonosClub.DisableControls;
      QBonosClub.First;
      while not QBonosClub.eof do
      begin
        s := '';
        FillChar(s, 4-length(floattostr(QBonosClubticket.value)),' ');
        s1 := '';
        FillChar(s1, 12-length(FORMAT('%n',[QBonosClubpagado.value])), ' ');

        if cktickets.Checked then
          err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ '  '+s+floattostr(QBonosClubticket.value)+' '+QBonosClubNCF.Value+' '+
          s1+FORMAT('%n',[QBonosClubpagado.value]));

        BonosClub := BonosClub + QBonosClubpagado.value;
        QBonosClub.next;
      end;
      QBonosClub.First;
      QBonosClub.EnableControls;
      if cktickets.Checked then
      begin
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ '---------------------------------------');
        s2 := '';
        FillChar(s2, 12-length(trim(FORMAT('%n',[BonosClub]))), ' ');
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'Total : '+s2+format('%n',[BonosClub]));
      end;
    end;

    //Otros Bonos
    BonosOtros := 0;
    //MontoItbis := 0;
    if QBonosOtros.RecordCount > 0 then
    begin
      if cktickets.Checked then
      begin
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ ' ');
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ dm.Centro('OTROS'));
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ dm.Centro('-----'));
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ '#Ticket       N. C. F.         Monto   ');
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ '---------------------------------------');
      end;
      QBonosOtros.DisableControls;
      QBonosOtros.First;
      while not QBonosOtros.eof do
      begin
        s := '';
        FillChar(s, 4-length(floattostr(QBonosOtrosticket.value)),' ');
        s1 := '';
        FillChar(s1, 12-length(FORMAT('%n',[QBonosOtrospagado.value])), ' ');

        if cktickets.Checked then
          err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ '  '+s+floattostr(QBonosOtrosticket.value)+' '+QBonosOtrosNCF.Value+' '+
          s1+FORMAT('%n',[QBonosOtrospagado.value]));

        BonosOtros := BonosOtros + QBonosOtrospagado.value;
        QBonosOtros.next;
      end;
      QBonosOtros.First;
      QBonosOtros.EnableControls;
      if cktickets.Checked then
      begin
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ '---------------------------------------');
        s2 := '';
        FillChar(s2, 12-length(trim(FORMAT('%n',[BonosOtros]))), ' ');
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'Total : '+s2+format('%n',[BonosOtros]));
      end;
    end;

    //Devoluciones
    Devolucion := 0;
    //MontoItbis := 0;
    if QDevolucion.RecordCount > 0 then
    begin
      if cktickets.Checked then
      begin
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ ' ');
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ dm.Centro('NOTAS DE CR'));
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ dm.Centro('-----------'));
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ '#Ticket       N. C. F.         Monto   ');
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ '---------------------------------------');
      end;
      QDevolucion.DisableControls;
      QDevolucion.First;
      while not QDevolucion.eof do
      begin
        s := '';
        FillChar(s, 4-length(floattostr(QDevolucionticket.value)),' ');
        s1 := '';
        FillChar(s1, 12-length(FORMAT('%n',[QDevolucionpagado.value])), ' ');

        if cktickets.Checked then
          err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ '  '+s+floattostr(QDevolucionticket.value)+' '+QDevolucionNCF.Value+' '+
          s1+FORMAT('%n',[QDevolucionpagado.value]));

        Devolucion := Devolucion + QDevolucionpagado.value;
        QDevolucion.next;
      end;
      QDevolucion.First;
      QDevolucion.EnableControls;
      if cktickets.Checked then
      begin
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ '---------------------------------------');
        s2 := '';
        FillChar(s2, 12-length(trim(FORMAT('%n',[Devolucion]))), ' ');
        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'Total : '+s2+format('%n',[Devolucion]));
      end;
    end;

    //MontoItbis := dm.Query1.FieldByName('itbis').AsFloat;
    //TGrabado   := (MontoItbis * 100)/16;

    s := '';
    FillChar(s, 12-length(trim(FORMAT('%n',[Efectivo]))), ' ');
    s1 := '';
    FillChar(s1, 12-length(trim(FORMAT('%n',[Tarjeta]))), ' ');
    s2 := '';
    FillChar(s2, 12-length(trim(FORMAT('%n',[Cheque]))), ' ');
    s3 := '';
    FillChar(s3, 12-length(trim(FORMAT('%n',[Efectivo + Tarjeta +Cheque + BonosClub + BonosOtros]))), ' ');
    s4 := '';
    FillChar(s4, 12-length(trim(FORMAT('%n',[MontoItbis]))), ' ');
    s5 := '';
    FillChar(s5, 12-length(trim(FORMAT('%n',[Credito]))), ' ');
    s6 := '';
    FillChar(s6, 12-length(trim(FORMAT('%n',[TGrabado]))), ' ');
    s7 := '';
    FillChar(s7, 12-length(trim(FORMAT('%n',[TExcento]))), ' ');
    s8 := '';
    FillChar(s8, 12-length(trim(FORMAT('%n',[Anulados]))), ' ');
    s9 := '';
    FillChar(s9, 12-length(trim(FORMAT('%n',[BonosClub]))), ' ');
    s10 := '';
    FillChar(s10, 12-length(trim(FORMAT('%n',[BonosOtros]))), ' ');
    s11 := '';
    FillChar(s11, 12-length(trim(FORMAT('%n',[QCuadreefectivo_asignado.Value]))), ' ');

    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ ' ');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ dm.Centro('VENTA POR FORMA DE PAGO'));
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ dm.Centro('-----------------------'));
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'DEPOSITO      : '+s11+format('%n',[QCuadreefectivo_asignado.Value]));

    s11 := '';
    FillChar(s11, 12-length(trim(FORMAT('%n',[Devolucion]))), ' ');

    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'TOTAL EFECTIVO: '+s+format('%n',[Efectivo]));
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'TOTAL TARJETA : '+s1+format('%n',[Tarjeta]));
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'TOTAL CHEQUE  : '+s2+format('%n',[Cheque]));
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'BONOS CLUB    : '+s9+FORMAT('%n',[BonosClub]));
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'OTROS         : '+s10+FORMAT('%n',[BonosOtros]));
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'NOTAS DE CR   : '+s11+FORMAT('%n',[Devolucion]));
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ '---------------------------------------');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'TOTAL CONTADO : '+s3+FORMAT('%n',[(Efectivo + Tarjeta + Cheque + BonosClub + BonosOtros) - Devuelta]));
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'TOTAL NOTAS CR: '+s11+FORMAT('%n',[Devolucion]));
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'TOTAL CREDITO : '+s5+FORMAT('%n',[Credito]));

    Query1.Close;
    Query1.SQL.Clear;
    Query1.SQL.Add('select t.itbis, sum(case t.itbis when 0 then 0 else ((t.precio*t.cantidad) / ((t.itbis/100)+1)) end) as grabado');
    Query1.SQL.Add('from montos_ticket m, cajas_ip c, ticket t');
    Query1.SQL.Add('where m.caja = c.caja');
    Query1.SQL.Add('and m.fecha = t.fecha');
    Query1.SQL.Add('and m.caja = t.caja');
    Query1.SQL.Add('and m.ticket = t.ticket');
    Query1.SQL.Add('and m.usu_codigo = t.usu_codigo');
    Query1.SQL.Add('and m.fecha_hora between convert(datetime, :fec1, 113) and convert(datetime, :fec2, 113)');
    Query1.SQL.Add('and m.caja = :caj');
    Query1.SQL.Add('and m.usu_codigo = :usu');
    Query1.SQL.Add('and m.status = '+QuotedStr('FAC'));
    if Cuadrar_Empresa = 'C' then
       Query1.SQL.Add('and m.emp_codigo = '+inttostr(empresa_caja));
    Query1.SQL.Add('and t.itbis > 0');
    Query1.SQL.Add('group by t.itbis');
    Query1.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
    Query1.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
    Query1.Parameters.ParamByName('fec1').DataType := ftDateTime;
    Query1.Parameters.ParamByName('fec1').Value    := hora1.DateTime;
    Query1.Parameters.ParamByName('fec2').DataType := ftDateTime;
    Query1.Parameters.ParamByName('fec2').Value    := hora2.DateTime;
    Query1.Open;

    TGrabado := 0;
    while not Query1.Eof do
    begin
      s6 := '';
      FillChar(s6, 12-length(trim(FORMAT('%n',[Query1.FieldByName('grabado').asFloat]))), ' ');
      err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'GRABADO '+formatfloat('00',Query1.FieldByName('itbis').asFloat)+'%' + '   : '+s6+
        FORMAT('%n',[Query1.FieldByName('grabado').asFloat]));

      TGrabado := TGrabado + Query1.FieldByName('grabado').asFloat;
      Query1.next;
    end;
    TExcento := (Efectivo+Tarjeta+Cheque+Credito+BonosClub+BonosOtros+QCuadreefectivo_asignado.Value) - devuelta - (TGrabado + MontoItbis);
    s7 := '';
    FillChar(s7, 12-length(trim(FORMAT('%n',[TExcento]))), ' ');

    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'TOTAL ITBIS   : '+s4+FORMAT('%n',[MontoItbis]));
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'TOTAL EXENTO  : '+s7+FORMAT('%n',[TExcento]));
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'TOTAL ANULADOS: '+s8+FORMAT('%n',[Anulados]));
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'CANT.  BOLETOS: '+inttostr(boletos));

    s := '';
    FillChar(s, 12-length(dm.Query1.FieldByName('cantidad').AsString), ' ');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'CANTIDAD TKS  : '+s+dm.Query1.FieldByName('cantidad').AsString);

    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select count(*) as cantidad from montos_ticket');
    dm.Query1.SQL.Add('where caja = :caj');
    dm.Query1.SQL.Add('and usu_codigo = :usu');
    dm.Query1.SQL.Add('and fecha_hora between convert(datetime, :fec1, 113) and convert(datetime, :fec2, 113)');
    dm.Query1.SQL.Add('and status = :st');
    if Cuadrar_Empresa = 'C' then
       dm.Query1.SQL.Add('and emp_codigo = '+inttostr(empresa_caja));
    dm.Query1.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
    dm.Query1.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
    dm.Query1.Parameters.ParamByName('fec1').DataType := ftDateTime;
    dm.Query1.Parameters.ParamByName('fec1').Value    := hora1.DateTime;
    dm.Query1.Parameters.ParamByName('fec2').DataType := ftDateTime;
    dm.Query1.Parameters.ParamByName('fec2').Value    := hora2.DateTime;
    dm.Query1.Parameters.ParamByName('st').Value      := 'ANU';
    dm.Query1.Open;

    s := '';
    FillChar(s, 12-length(dm.Query1.FieldByName('cantidad').AsString), ' ');

    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'TKS ANULADOS  : '+s+dm.Query1.FieldByName('cantidad').AsString);
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'TOTAL EN CAJA : '+s3+format('%n',[(Efectivo+Tarjeta+Cheque+Credito+BonosClub+BonosOtros+QCuadreefectivo_asignado.Value) - devuelta]));

    if TotalDesgloce > 0 then
    begin
      err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ '');
      err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ '---------------------------------------');
      err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ '   M O N T O  CANTIDAD   V A L O R ');
      err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ '---------------------------------------');
      frmDesgloce.QMontos.First;
      while not frmDesgloce.QMontos.Eof do
      begin
        s := '';
        FillChar(s, 12-length(Format('%n',[frmDesgloce.QMontosmonto.AsFloat])),' ');
        s1 := '';
        FillChar(s1, 5-length(IntToStr(frmDesgloce.QMontoscantidad.AsInteger)),' ');
        s2 := '';
        FillChar(s2, 12-length(Format('%n',[frmDesgloce.QMontosValor.AsFloat])),' ');

        err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+s+Format('%n',[frmDesgloce.QMontosmonto.AsFloat])+' '+s1+
               IntToStr(frmDesgloce.QMontoscantidad.AsInteger)+'        '+s2+
               Format('%n',[frmDesgloce.QMontosValor.AsFloat]));

        frmDesgloce.QMontos.Next;
      end;
      frmDesgloce.QMontos.First;
      s := '';
      FillChar(s, 29-length(Format('%n',[frmDesgloce.QMontosValor.AsFloat - TotalDesgloce])),' ');
      s1 := '';
      FillChar(s1, 28-length(Format('%n',[frmDesgloce.QMontosValor.AsFloat - TotalDesgloce])),' ');
      s2 := '';
      FillChar(s2, 29-length(Format('%n',[((Efectivo + Tarjeta + Cheque + BonosClub + BonosOtros) - Devuelta) - TotalDesgloce])),' ');

      err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ '---------------------------------------');
      err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'T O T A L  '+s+Format('%n',[TotalDesgloce]));
      err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'DIFERENCIA '+s2+Format('%n',[TotalDesgloce - ((Efectivo + Tarjeta + Cheque + BonosClub + BonosOtros) - Devuelta)]));
      err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ '');
    end;

    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ ' ');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ ' ');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ ' ');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ '------------------------');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'Firma del Cajero');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ ' ');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ ' ');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ ' ');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ '------------------------');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ 'Firma del Supervisor');
    err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+ ' ');
  end;
  err := DriverFiscal1.IF_WRITE('@CloseNonFiscalReceipt|C');
  err := DriverFiscal1.IF_CLOSE;

  finally
    DriverFiscal1.Destroy;
  end;

end;

procedure TfrmCuadre.ImpCuadreNoFiscalBixolon(ImpresoraFiscal: TImpresora);
var
  puertoFiscalOpen,Respuesta:boolean;

  Stat, Err, X: Integer;
begin

{
configurará la impresora en Modo Fast Food
Respuesta = SendCmd(status, error, "PJ3200")

configurará la impresora en Modo Retail
Respuesta = SendCmd(status, error, "PJ3201")
}
  Puerto := PuertoSerial[Impresora.Puerto -1];

  if not Impresora.isConected then
    OpenFpctrl(PChar(Puerto));

  Respuesta := CheckFprinter();
  if Not Respuesta then
  begin
    ShowMessage('Impresora NO conectada');
    Abort;
  end;

  setLimpiarVariables();
  hora1.Date := fecha1.Date;
  hora2.Date := fecha2.Date;

  dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('select emp_codigo, puerto, Tipo_Cuadre, Cuadrar_Empresa from cajas_IP');
  dm.Query1.SQL.Add('where caja = :caj');
  dm.Query1.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
  dm.Query1.Open;
  Puerto := dm.Query1.FieldByName('puerto').AsString;
  tipo_cuadre := dm.Query1.FieldByName('Tipo_Cuadre').AsString;
  Cuadrar_Empresa := dm.Query1.FieldByName('Cuadrar_Empresa').AsString;
  empresa_caja := dm.Query1.FieldByName('emp_codigo').AsInteger;

  if (Cuadrar_Empresa = 'C') and (not realizo) then
  begin
    realizo := true;
    QEfectivo.SQL.Add('and m.emp_codigo = '+inttostr(empresa_caja));
    QCheque.SQL.Add('and m.emp_codigo = '+inttostr(empresa_caja));
    QTarjeta.SQL.Add('and m.emp_codigo = '+inttostr(empresa_caja));
    QCredito.SQL.Add('and m.emp_codigo = '+inttostr(empresa_caja));
    QBonosClub.SQL.Add('and m.emp_codigo = '+inttostr(empresa_caja));
    QBonosOtros.SQL.Add('and m.emp_codigo = '+inttostr(empresa_caja));
  end;

  graba;

  QNCF.Close;
  QNCF.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
  QNCF.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
  QNCF.Parameters.ParamByName('fec1').DataType := ftDateTime;
  QNCF.Parameters.ParamByName('fec1').Value    := hora1.DateTime;
  QNCF.Parameters.ParamByName('fec2').DataType := ftDateTime;
  QNCF.Parameters.ParamByName('fec2').Value    := hora2.DateTime;
  QNCF.Open;

  QEfectivo.Close;
  QEfectivo.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
  QEfectivo.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
  QEfectivo.Parameters.ParamByName('fec1').DataType := ftDateTime;
  QEfectivo.Parameters.ParamByName('fec1').Value    := hora1.DateTime;
  QEfectivo.Parameters.ParamByName('fec2').DataType := ftDateTime;
  QEfectivo.Parameters.ParamByName('fec2').Value    := hora2.DateTime;
  QEfectivo.Open;

  QCheque.Close;
  QCheque.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
  QCheque.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
  QCheque.Parameters.ParamByName('fec1').DataType := ftDateTime;
  QCheque.Parameters.ParamByName('fec1').Value    := hora1.DateTime;
  QCheque.Parameters.ParamByName('fec2').DataType := ftDateTime;
  QCheque.Parameters.ParamByName('fec2').Value    := hora2.DateTime;
  QCheque.Open;

  QTarjeta.Close;
  QTarjeta.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
  QTarjeta.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
  QTarjeta.Parameters.ParamByName('fec1').DataType := ftDateTime;
  QTarjeta.Parameters.ParamByName('fec1').Value    := hora1.DateTime;
  QTarjeta.Parameters.ParamByName('fec2').DataType := ftDateTime;
  QTarjeta.Parameters.ParamByName('fec2').Value    := hora2.DateTime;
  QTarjeta.Open;

  QCredito.Close;
  QCredito.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
  QCredito.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
  QCredito.Parameters.ParamByName('fec1').DataType := ftDateTime;
  QCredito.Parameters.ParamByName('fec1').Value    := hora1.DateTime;
  QCredito.Parameters.ParamByName('fec2').DataType := ftDateTime;
  QCredito.Parameters.ParamByName('fec2').Value    := hora2.DateTime;
  QCredito.Open;

  QAnulados.Close;
  QAnulados.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
  QAnulados.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
  QAnulados.Parameters.ParamByName('fec1').DataType := ftDateTime;
  QAnulados.Parameters.ParamByName('fec1').Value    := hora1.DateTime;
  QAnulados.Parameters.ParamByName('fec2').DataType := ftDateTime;
  QAnulados.Parameters.ParamByName('fec2').Value    := hora2.DateTime;
  QAnulados.Open;

  QBonosClub.Close;
  QBonosClub.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
  QBonosClub.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
  QBonosClub.Parameters.ParamByName('fec1').DataType := ftDateTime;
  QBonosClub.Parameters.ParamByName('fec1').Value    := hora1.DateTime;
  QBonosClub.Parameters.ParamByName('fec2').DataType := ftDateTime;
  QBonosClub.Parameters.ParamByName('fec2').Value    := hora2.DateTime;
  QBonosClub.Open;

  QBonosOtros.Close;
  QBonosOtros.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
  QBonosOtros.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
  QBonosOtros.Parameters.ParamByName('fec1').DataType := ftDateTime;
  QBonosOtros.Parameters.ParamByName('fec1').Value    := hora1.DateTime;
  QBonosOtros.Parameters.ParamByName('fec2').DataType := ftDateTime;
  QBonosOtros.Parameters.ParamByName('fec2').Value    := hora2.DateTime;
  QBonosOtros.Open;

  QDevolucion.Close;
  QDevolucion.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
  QDevolucion.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
  QDevolucion.Parameters.ParamByName('fec1').DataType := ftDateTime;
  QDevolucion.Parameters.ParamByName('fec1').Value    := hora1.DateTime;
  QDevolucion.Parameters.ParamByName('fec2').DataType := ftDateTime;
  QDevolucion.Parameters.ParamByName('fec2').Value    := hora2.DateTime;
  QDevolucion.Open;

  SendCmd(Stat, Err, PChar('800'+dm.centro(dm.QEmpresaemp_nombre.Value)));
  SendCmd(Stat, Err, PChar('800'+dm.centro(dm.QEmpresaemp_direccion.Value)));
  SendCmd(Stat, Err, PChar('800'+dm.centro(dm.QEmpresaEMP_LOCALIDAD.Value)));
  SendCmd(Stat, Err, PChar('800'+dm.centro(dm.QEmpresaEMP_TELEFONO.Value)));
  SendCmd(Stat, Err, PChar('800'+dm.centro('RNC:'+dm.QEmpresaEMP_RNC.Value)));
  SendCmd(Stat, Err, PChar('800'+' '));
  SendCmd(Stat, Err, PChar('800'+dm.centro('CUADRE DE CAJA')));
  SendCmd(Stat, Err, PChar('800'+' '));
  SendCmd(Stat, Err, PChar('800'+'Cuadre#: '+QCuadresecuencia.asstring));
  SendCmd(Stat, Err, PChar('800'+'Desde  : '+DateToStr(fecha1.Date)+' '+TimeToStr(Hora1.Time)));
  SendCmd(Stat, Err, PChar('800'+'Hasta  : '+DateToStr(fecha2.Date)+' '+TimeToStr(Hora2.Time)));
  SendCmd(Stat, Err, PChar('800'+'Cajero : '+DBLookupComboBox2.Text));
  SendCmd(Stat, Err, PChar('800'+'Caja   : '+DBLookupComboBox1.Text));
  SendCmd(Stat, Err, PChar('800'+' '));

  if tipo_cuadre = 'D' then
  begin
    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select sum(boletos) as boletos from montos_ticket');
    dm.Query1.SQL.Add('where caja = :caj');
    dm.Query1.SQL.Add('and usu_codigo = :usu');
    dm.Query1.SQL.Add('and fecha_hora between convert(datetime, :fec1, 113) and convert(datetime, :fec2, 113)');
    dm.Query1.SQL.Add('and status = '+QuotedStr('FAC'));
    if Cuadrar_Empresa = 'C' then
       dm.Query1.SQL.Add('and emp_codigo = '+inttostr(empresa_caja));
    dm.Query1.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
    dm.Query1.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
    dm.Query1.Parameters.ParamByName('fec1').DataType := ftDateTime;
    dm.Query1.Parameters.ParamByName('fec1').Value    := hora1.DateTime;
    dm.Query1.Parameters.ParamByName('fec2').DataType := ftDateTime;
    dm.Query1.Parameters.ParamByName('fec2').Value    := hora2.DateTime;
    dm.Query1.Open;
    boletos := dm.Query1.FieldByName('boletos').AsInteger;

    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select count(*) as cantidad from montos_ticket');
    dm.Query1.SQL.Add('where caja = :caj');
    dm.Query1.SQL.Add('and usu_codigo = :usu');
    dm.Query1.SQL.Add('and fecha_hora between convert(datetime, :fec1, 113) and convert(datetime, :fec2, 113)');
    dm.Query1.SQL.Add('and status in (:st1, :st2)');
    if Cuadrar_Empresa = 'C' then
       dm.Query1.SQL.Add('and emp_codigo = '+inttostr(empresa_caja));
    dm.Query1.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
    dm.Query1.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
    dm.Query1.Parameters.ParamByName('fec1').DataType := ftDateTime;
    dm.Query1.Parameters.ParamByName('fec1').Value    := hora1.DateTime;
    dm.Query1.Parameters.ParamByName('fec2').DataType := ftDateTime;
    dm.Query1.Parameters.ParamByName('fec2').Value    := hora2.DateTime;
    dm.Query1.Parameters.ParamByName('st1').Value  := 'ANU';
    dm.Query1.Parameters.ParamByName('st2').Value  := 'CAN';
    dm.Query1.Open;
    cancelados := dm.Query1.FieldByName('cantidad').AsInteger;

    Query1.Close;
    Query1.SQL.Clear;
    Query1.SQL.Add('select 1, '+QuotedStr('EFECTIVO')+' as nombre');
    Query1.SQL.Add('union select 2, '+QuotedStr('TARJETA'));
    Query1.SQL.Add('union select 3, '+QuotedStr('CHEQUE'));
    Query1.SQL.Add('union select 4, '+QuotedStr('BONOS CLUB'));
    Query1.SQL.Add('union select 5, '+QuotedStr('OTROS'));
    Query1.SQL.Add('union select 6, '+QuotedStr('NOTAS DE CREDITO'));
    Query1.SQL.Add('union select 7, '+QuotedStr('CREDITO'));
    Query1.Open;

    SendCmd(Stat, Err, PChar('800'+'---------------------------------'));
    SendCmd(Stat, Err, PChar('800'+'DESCRIPCION       |    MONTO    |'));
    SendCmd(Stat, Err, PChar('800'+'---------------------------------'));
    Total       := 0;
    devuelta    := 0;
    Devolucion  := 0;
    credito     := 0;
    cantcredito := 0;
    cantcontado := 0;
    while not Query1.Eof do
    begin
      forma := '';
      if Query1.FieldByName('nombre').AsString = 'EFECTIVO' then
        forma := 'EFE'
      else if Query1.FieldByName('nombre').AsString = 'CHEQUE' then
        forma := 'CHE'
      else if Query1.FieldByName('nombre').AsString = 'TARJETA' then
        forma := 'TAR'
      else if Query1.FieldByName('nombre').AsString = 'BONOS CLUB' then
        forma := 'BOC'
      else if Query1.FieldByName('nombre').AsString = 'OTROS' then
        forma := 'OBO'
      else if Query1.FieldByName('nombre').AsString = 'CREDITO' then
        forma := 'CRE'
      else if Query1.FieldByName('nombre').AsString = 'NOTAS DE CREDITO' then
        forma := 'DEV';

      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('select sum(f.pagado) as pagado, sum(f.pagado-f.devuelta) as total,');
      dm.Query1.SQL.Add('sum(f.devuelta) as devuelta, sum(m.total) as monto_total');
      dm.Query1.SQL.Add('from montos_ticket m, formas_pago_ticket f');
      dm.Query1.SQL.Add('where m.caja = f.caja');
      dm.Query1.SQL.Add('and m.usu_codigo = f.usu_codigo');
      dm.Query1.SQL.Add('and m.fecha = f.fecha');
      dm.Query1.SQL.Add('and m.ticket = f.ticket');
      dm.Query1.SQL.Add('and m.status = '+QuotedStr('FAC'));
      dm.Query1.SQL.Add('and m.caja = :caj');
      dm.Query1.SQL.Add('and m.usu_codigo = :usu');
      dm.Query1.SQL.Add('and m.fecha_hora between convert(datetime, :fec1, 113) and convert(datetime, :fec2, 113)');
      dm.Query1.SQL.Add('and f.forma = '+QuotedStr(forma));
      if Cuadrar_Empresa = 'C' then
         dm.Query1.SQL.Add('and m.emp_codigo = '+inttostr(empresa_caja));
      dm.Query1.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
      dm.Query1.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
      dm.Query1.Parameters.ParamByName('fec1').DataType := ftDateTime;
      dm.Query1.Parameters.ParamByName('fec1').Value    := hora1.DateTime;
      dm.Query1.Parameters.ParamByName('fec2').DataType := ftDateTime;
      dm.Query1.Parameters.ParamByName('fec2').Value    := hora2.DateTime;
      dm.Query1.Open;

      if forma = 'DEV' then
      begin
        Devolucion := Devolucion + dm.Query1.FieldByName('pagado').AsFloat;
        if dm.Query1.FieldByName('pagado').AsFloat > 0 then
          cantcontado := cantcontado - 1;
      end
      else if forma = 'CRE' then
      begin
        credito := credito + dm.Query1.FieldByName('monto_total').AsFloat;
        if dm.Query1.FieldByName('monto_total').AsFloat > 0 then
          cantcredito := cantcredito + 1;
      end
      else
      begin
        s  := '';
        FillChar(s, 12-length(format('%n',[dm.Query1.FieldByName('pagado').AsFloat])),' ');
        s1 := '';
        FillChar(s1, 18-length(Query1.FieldByName('nombre').AsString),' ');
        SendCmd(Stat, Err, PChar('800'+Query1.FieldByName('nombre').AsString+s1+'|'+s+'$'+format('%n',[dm.Query1.FieldByName('pagado').AsFloat])+'|'+'(+)'));

        devuelta := devuelta + dm.Query1.FieldByName('devuelta').AsFloat;
        Total := Total + dm.Query1.FieldByName('pagado').AsFloat;
        cantcontado := cantcontado + 1;
      end;

      Query1.Next;
    end;
    SendCmd(Stat, Err, PChar('800'+'                  --------------|'));
    s  := '';
    FillChar(s, 12-length(format('%n',[total])),' ');
    s1  := '';
    FillChar(s1, 12-length(format('%n',[devuelta])),' ');
    s2  := '';
    FillChar(s2, 12-length(format('%n',[(total-devuelta)+devolucion+credito])),' ');
    s3  := '';
    FillChar(s3, 12-length(format('%n',[QCuadreefectivo_asignado.Value])),' ');
    s7 := '';
    FillChar(s7, 12-length(format('%n',[devolucion])),' ');
    s5  := '';
    FillChar(s5, 12-length(format('%n',[(total-devuelta)+QCuadreefectivo_asignado.Value+devolucion+credito])),' ');
    s8  := '';
    FillChar(s8, 12-length(format('%n',[credito])),' ');
    s9  := '';
    FillChar(s9, 12-length(format('%n',[(total-devuelta)])),' ');

    SendCmd(Stat, Err, PChar('800'+'SUBTOTAL          |'+s +'$'+format('%n',[total])+'|'));
    SendCmd(Stat, Err, PChar('800'+'EFECTIVO DEVUELTO |'+s1+'$'+format('%n',[devuelta])+'|'+'(-)'));
    SendCmd(Stat, Err, PChar('800'+'                  --------------|'));
    SendCmd(Stat, Err, PChar('800'+'SUBTOTAL          |'+s9+'$'+format('%n',[(total-devuelta)])+'|'));
    SendCmd(Stat, Err, PChar('800'+'CREDITO           |'+s8 +'$'+format('%n',[credito])+'|'+'(+)'));
    SendCmd(Stat, Err, PChar('800'+'NOTAS DE CREDITO  |'+s7 +'$'+format('%n',[devolucion])+'|'+'(-)'));
    SendCmd(Stat, Err, PChar('800'+'                  --------------|'));
    SendCmd(Stat, Err, PChar('800'+'TOTAL VENDIDO     |'+s2 +'$'+format('%n',[(total-devuelta)+devolucion+credito])+'|'));
    SendCmd(Stat, Err, PChar('800'+'DEPOSITO EN CAJA  |'+s3 +'$'+format('%n',[QCuadreefectivo_asignado.Value])+'|'+'(+)'));
    SendCmd(Stat, Err, PChar('800'+'CANTIDAD BOLETOS  |'+inttostr(boletos)));
    SendCmd(Stat, Err, PChar('800'+'                  --------------|'));
    SendCmd(Stat, Err, PChar('800'+'TOTAL EN CAJA     |'+s5 +'$'+format('%n',[(total-devuelta) +QCuadreefectivo_asignado.Value+devolucion+credito])+'|'));
    SendCmd(Stat, Err, PChar('800'+'                  ==============='));
    SendCmd(Stat, Err, PChar('800'+' '));
    SendCmd(Stat, Err, PChar('800'+'---------------------------------'));
    SendCmd(Stat, Err, PChar('800'+'TIPO        |CANT.|    MONTO    |'));
    SendCmd(Stat, Err, PChar('800'+'---------------------------------'));

    s  := '';
    FillChar(s, 5-length(inttostr(cantcontado)),' ');
    s1  := '';
    FillChar(s1, 12-length(format('%n',[(total-devuelta)+devolucion])),' ');
    s2  := '';
    FillChar(s2, 5-length(inttostr(cantcredito)),' ');
    s4  := '';
    FillChar(s4, 5-length(inttostr(cancelados)),' ');
    s5  := '';
    FillChar(s5, 5-length(inttostr(cantcontado+cantcredito+cancelados)),' ');
    s6  := '';
    FillChar(s6, 12-length(format('%n',[(total-devuelta)+credito+devolucion])),' ');
    s9  := '';
    FillChar(s9, 12-length(format('%n',[(total-devuelta)+credito])),' ');

    SendCmd(Stat, Err, PChar('800'+'CONTADO     |'+s+inttostr(cantcontado)+'|'+s1+'$'+format('%n',[(total-devuelta)+devolucion])+'|(+)'));
    SendCmd(Stat, Err, PChar('800'+'CREDITO     |'+s2+inttostr(cantcredito)+'|'+s8+'$'+format('%n',[credito])+'|(+)'));
    SendCmd(Stat, Err, PChar('800'+'ANULADOS    |'+s4+inttostr(cancelados)+'|'+'        $0.00|(+)'));
    SendCmd(Stat, Err, PChar('800'+'            --------------------|'));
    SendCmd(Stat, Err, PChar('800'+'SUBTOTAL    |'+s5+inttostr(cantcontado+cantcredito+cancelados)+'|'+s6+'$'+format('%n',[(total-devuelta)+devolucion+credito])+'|'));
    SendCmd(Stat, Err, PChar('800'+'NOTAS DE CR |     |'+s7+'$'+format('%n',[devolucion])+'|(-)'));
    SendCmd(Stat, Err, PChar('800'+'            --------------------|'));
    SendCmd(Stat, Err, PChar('800'+'TOTAL       |'+s5+inttostr(cantcontado+cantcredito+cancelados)+'|'+s9+'$'+format('%n',[(total-devuelta)+credito])+'|'));
    SendCmd(Stat, Err, PChar('800'+'            ====================='));
    SendCmd(Stat, Err, PChar('800'+' '));
    SendCmd(Stat, Err, PChar('800'+'---------------------------------'));
    SendCmd(Stat, Err, PChar('800'+'DESCRIPCION       |    MONTO    |'));
    SendCmd(Stat, Err, PChar('800'+'---------------------------------'));

    s  := '';
    FillChar(s, 12-length(format('%n',[TExcento])),' ');
    s1  := '';
    FillChar(s1, 12-length(format('%n',[TGrabado])),' ');
    s2  := '';
    FillChar(s2, 12-length(format('%n',[MontoItbis])),' ');
    s3  := '';
    FillChar(s3, 12-length(format('%n',[TExcento+TGrabado+MontoItbis])),' ');

    //writeln(arch,'VENTA EXENTA      |'+s+'$'+format('%n',[TExcento])+'|(+)'));
    //writeln(arch,'VENTA GRABADA     |'+s1+'$'+format('%n',[TGrabado])+'|(+)'));
    SendCmd(Stat, Err, PChar('800'+'TOTAL ITBIS       |'+s2+'$'+format('%n',[MontoItbis])+'|(+)'));
    SendCmd(Stat, Err, PChar('800'+'                  --------------|'));
    SendCmd(Stat, Err, PChar('800'+'TOTAL             |'+s3+'$'+format('%n',[TExcento+TGrabado+MontoItbis])+'|(+)'));
    SendCmd(Stat, Err, PChar('800'+'                  ==============='));
    SendCmd(Stat, Err, PChar('800'+ ' '));
    SendCmd(Stat, Err, PChar('800'+ ' '));
    SendCmd(Stat, Err, PChar('800'+ ' '));
    SendCmd(Stat, Err, PChar('800'+ ' '));
    SendCmd(Stat, Err, PChar('800'+ ' '));
    SendCmd(Stat, Err, PChar('800'+ ' '));
    SendCmd(Stat, Err, PChar('800'+ '------------------------'));
    SendCmd(Stat, Err, PChar('800'+ 'Firma del Cajero'));
    SendCmd(Stat, Err, PChar('800'+ ' '));
    SendCmd(Stat, Err, PChar('800'+ ' '));
    SendCmd(Stat, Err, PChar('800'+ ' '));
    SendCmd(Stat, Err, PChar('800'+ ' '));
    SendCmd(Stat, Err, PChar('800'+ ' '));
    SendCmd(Stat, Err, PChar('800'+ '------------------------'));
    SendCmd(Stat, Err, PChar('800'+ 'Firma del Supervisor'));
    SendCmd(Stat, Err, PChar('800'+ ' '));
    SendCmd(Stat, Err, PChar('800'+ ' '));
    SendCmd(Stat, Err, PChar('800'+ ' '));
    SendCmd(Stat, Err, PChar('800'+ ' '));
    SendCmd(Stat, Err, PChar('800'+ ' '));
    SendCmd(Stat, Err, PChar('800'+ ' '));
    SendCmd(Stat, Err, PChar('800'+ ' '));
    SendCmd(Stat, Err, PChar('800'+ ' '));
  end
  else
  begin
    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select sum(isnull(itbis,0)) as itbis from montos_ticket');
    dm.Query1.SQL.Add('where caja = :caj');
    dm.Query1.SQL.Add('and usu_codigo = :usu');
    dm.Query1.SQL.Add('and fecha_hora between convert(datetime, :fec1, 113) and convert(datetime, :fec2, 113)');
    dm.Query1.SQL.Add('and status = '+QuotedStr('FAC'));
    if Cuadrar_Empresa = 'C' then
       dm.Query1.SQL.Add('and emp_codigo = '+inttostr(empresa_caja));
    dm.Query1.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
    dm.Query1.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
    dm.Query1.Parameters.ParamByName('fec1').DataType := ftDateTime;
    dm.Query1.Parameters.ParamByName('fec1').Value    := hora1.DateTime;
    dm.Query1.Parameters.ParamByName('fec2').DataType := ftDateTime;
    dm.Query1.Parameters.ParamByName('fec2').Value    := hora2.DateTime;
    dm.Query1.Open;
    MontoItbis := dm.Query1.FieldByName('itbis').AsFloat;

    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select sum(boletos) as boletos from montos_ticket');
    dm.Query1.SQL.Add('where caja = :caj');
    dm.Query1.SQL.Add('and usu_codigo = :usu');
    dm.Query1.SQL.Add('and fecha_hora between convert(datetime, :fec1, 113) and convert(datetime, :fec2, 113)');
    dm.Query1.SQL.Add('and status = '+QuotedStr('FAC'));
    if Cuadrar_Empresa = 'C' then
       dm.Query1.SQL.Add('and emp_codigo = '+inttostr(empresa_caja));
    dm.Query1.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
    dm.Query1.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
    dm.Query1.Parameters.ParamByName('fec1').DataType := ftDateTime;
    dm.Query1.Parameters.ParamByName('fec1').Value    := hora1.DateTime;
    dm.Query1.Parameters.ParamByName('fec2').DataType := ftDateTime;
    dm.Query1.Parameters.ParamByName('fec2').Value    := hora2.DateTime;
    dm.Query1.Open;
    boletos := dm.Query1.FieldByName('boletos').AsInteger;

    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select count(*) as cantidad from montos_ticket');
    dm.Query1.SQL.Add('where caja = :caj');
    dm.Query1.SQL.Add('and usu_codigo = :usu');
    dm.Query1.SQL.Add('and fecha_hora between convert(datetime, :fec1, 113) and convert(datetime, :fec2, 113)');
    if Cuadrar_Empresa = 'C' then
       dm.Query1.SQL.Add('and emp_codigo = '+inttostr(empresa_caja));
    dm.Query1.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
    dm.Query1.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
    dm.Query1.Parameters.ParamByName('fec1').DataType := ftDateTime;
    dm.Query1.Parameters.ParamByName('fec1').Value    := hora1.DateTime;
    dm.Query1.Parameters.ParamByName('fec2').DataType := ftDateTime;
    dm.Query1.Parameters.ParamByName('fec2').Value    := hora2.DateTime;
    dm.Query1.Open;

    //Efectivo
    if QEfectivo.RecordCount > 0 then
    begin
      if cktickets.Checked then
      begin
        SendCmd(Stat, Err, PChar('800'+ dm.Centro('EFECTIVO')));
        SendCmd(Stat, Err, PChar('800'+ dm.Centro('--------')));
        SendCmd(Stat, Err, PChar('800'+ '#Ticket       N. C. F.         Monto   '));
        SendCmd(Stat, Err, PChar('800'+ '---------------------------------------'));
      end;
      QEfectivo.DisableControls;
      QEfectivo.First;
      while not QEfectivo.eof do
      begin
        s := '';
        FillChar(s, 4-length(floattostr(QEfectivoticket.value)),' ');
        s1 := '';
        FillChar(s1, 12-length(FORMAT('%n',[QEfectivopagado.value])), ' ');

        if cktickets.Checked then
          SendCmd(Stat, Err, PChar('800'+ '  '+s+floattostr(QEfectivoticket.value)+' '+QEfectivoNCF.Value+' '+ s1+FORMAT('%n',[QEfectivopagado.value])));

        Efectivo := Efectivo + QEfectivopagado.value;
        QEfectivo.next;
      end;
      QEfectivo.First;
      QEfectivo.EnableControls;
      if cktickets.Checked then
      begin
        SendCmd(Stat, Err, PChar('800'+ '---------------------------------------'));
        s2 := '';
        FillChar(s2, 12-length(trim(FORMAT('%n',[Efectivo]))), ' ');
        SendCmd(Stat, Err, PChar('800'+ 'Total : '+s2+format('%n',[Efectivo])));
      end;
    end;

    //Tarjeta
    Tarjeta := 0;
    //MontoItbis := 0;
    if QTarjeta.RecordCount > 0 then
    begin
      if cktickets.Checked then
      begin
        SendCmd(Stat, Err, PChar('800'+' '));
        SendCmd(Stat, Err, PChar('800'+ dm.Centro('TARJETA')));
       SendCmd(Stat, Err, PChar('800'+dm.Centro('-------')));
        SendCmd(Stat, Err, PChar('800'+ '#Ticket       N. C. F.         Monto   '));
        SendCmd(Stat, Err, PChar('800'+'---------------------------------------'));
      end;
      QTarjeta.DisableControls;
      QTarjeta.First;
      while not QTarjeta.eof do
      begin
        s := '';
        FillChar(s, 4-length(floattostr(QTarjetaticket.value)),' ');
        s1 := '';
        FillChar(s1, 12-length(FORMAT('%n',[QTarjetapagado.value])), ' ');

        if cktickets.Checked then
          SendCmd(Stat, Err, PChar('800'+ '  '+s+floattostr(QTarjetaticket.value)+' '+QTarjetaNCF.Value+' '+
          s1+FORMAT('%n',[QTarjetapagado.value])));

        Tarjeta := Tarjeta + QTarjetapagado.value;
        QTarjeta.next;
      end;
      QTarjeta.First;
      QTarjeta.EnableControls;
      if cktickets.Checked then
      begin
        SendCmd(Stat, Err, PChar('800'+ '---------------------------------------'));
        s2 := '';
        FillChar(s2, 12-length(trim(FORMAT('%n',[Tarjeta]))), ' ');
        SendCmd(Stat, Err, PChar('800'+ 'Total : '+s2+format('%n',[Tarjeta])));
      end;
    end;

    //Cheque
    Cheque := 0;
    //MontoItbis := 0;
    if QCheque.RecordCount > 0 then
    begin
      if cktickets.Checked then
      begin
        SendCmd(Stat, Err, PChar('800'+ ' '));
        SendCmd(Stat, Err, PChar('800'+ dm.Centro('CHEQUE')));
        SendCmd(Stat, Err, PChar('800'+ dm.Centro('------')));
        SendCmd(Stat, Err, PChar('800'+ '#Ticket       N. C. F.         Monto   '));
        SendCmd(Stat, Err, PChar('800'+ '---------------------------------------'));
      end;
      QCheque.DisableControls;
      QCheque.First;
      while not QCheque.eof do
      begin
        s := '';
        FillChar(s, 4-length(floattostr(QChequeticket.value)),' ');
        s1 := '';
        FillChar(s1, 12-length(FORMAT('%n',[QChequepagado.value])), ' ');

        if cktickets.Checked then
          SendCmd(Stat, Err, PChar('800'+ '  '+s+floattostr(QChequeticket.value)+' '+QChequeNCF.Value+' '+
          s1+FORMAT('%n',[QChequepagado.value])));

        Cheque := Cheque + QChequepagado.value;
        devuelta := devuelta + QChequedevuelta.Value;
        QCheque.next;
      end;
      QCheque.First;
      QCheque.EnableControls;
      if cktickets.Checked then
      begin
        SendCmd(Stat, Err, PChar('800'+ '---------------------------------------'));
        s2 := '';
        FillChar(s2, 12-length(trim(FORMAT('%n',[Cheque]))), ' ');
        SendCmd(Stat, Err, PChar('800'+ 'Total : '+s2+format('%n',[Cheque])));
      end;
    end;

    //Credito
    Credito := 0;
    //MontoItbis := 0;
    if QCredito.RecordCount > 0 then
    begin
      if cktickets.Checked then
      begin
        SendCmd(Stat, Err, PChar('800'+ ' '));
        SendCmd(Stat, Err, PChar('800'+ dm.Centro('CREDITO')));
        SendCmd(Stat, Err, PChar('800'+ dm.Centro('-------')));
        SendCmd(Stat, Err, PChar('800'+ '#Ticket       N. C. F.         Monto   '));
        SendCmd(Stat, Err, PChar('800'+ '---------------------------------------'));
      end;
      QCredito.DisableControls;
      QCredito.First;
      while not QCredito.eof do
      begin
        s := '';
        FillChar(s, 4-length(floattostr(QCreditoticket.value)),' ');
        s1 := '';
        FillChar(s1, 12-length(FORMAT('%n',[QCreditopagado.value])), ' ');

        if cktickets.Checked then
          SendCmd(Stat, Err, PChar('800'+ '  '+s+floattostr(QCreditoticket.value)+' '+QCreditoNCF.Value+' '+
          s1+FORMAT('%n',[QCreditopagado.value])));

        Credito := Credito + QCreditopagado.value;
        QCredito.next;
      end;
      QCredito.First;
      QCredito.EnableControls;
      if cktickets.Checked then
      begin
        SendCmd(Stat, Err, PChar('800'+ '---------------------------------------'));
        s2 := '';
        FillChar(s2, 12-length(trim(FORMAT('%n',[Credito]))), ' ');
        SendCmd(Stat, Err, PChar('800'+ 'Total : '+s2+format('%n',[Credito])));
      end;
    end;

    //Anulados
    Anulados := 0;
    TCancelados := 0;
    //MontoItbis := 0;
    if QAnulados.RecordCount > 0 then
    begin
      if cktickets.Checked then
      begin
        SendCmd(Stat, Err, PChar('800'+ ' '));
        SendCmd(Stat, Err, PChar('800'+ dm.Centro('ANULADOS/CANCELADOS')));
        SendCmd(Stat, Err, PChar('800'+ dm.Centro('-------------------')));
        SendCmd(Stat, Err, PChar('800'+ '#Ticket       N. C. F.         Monto   '));
        SendCmd(Stat, Err, PChar('800'+ '---------------------------------------'));
      end;
      QAnulados.DisableControls;
      QAnulados.First;
      while not QAnulados.eof do
      begin
        s := '';
        FillChar(s, 4-length(floattostr(QAnuladosticket.value)),' ');
        s1 := '';
        FillChar(s1, 12-length(FORMAT('%n',[QAnuladospagado.value])), ' ');

        if cktickets.Checked then
          SendCmd(Stat, Err, PChar('800'+ '  '+s+floattostr(QAnuladosticket.value)+' '+QAnuladosNCF.Value+' '+
          s1+FORMAT('%n',[QAnuladospagado.value])));

        Anulados := Anulados + QAnuladostotal.value;
        QAnulados.next;
      end;
      QAnulados.First;
      QAnulados.EnableControls;
      if cktickets.Checked then
      begin
        SendCmd(Stat, Err, PChar('800'+ '---------------------------------------'));
        s2 := '';
        FillChar(s2, 12-length(trim(FORMAT('%n',[Anulados]))), ' ');
        SendCmd(Stat, Err, PChar('800'+ 'Total : '+s2+format('%n',[Anulados])));
      end;
    end;

    //Bonos del Club
    BonosClub := 0;
    //MontoItbis := 0;
    if QBonosClub.RecordCount > 0 then
    begin
      if cktickets.Checked then
      begin
        SendCmd(Stat, Err, PChar('800'+ ' '));
        SendCmd(Stat, Err, PChar('800'+ dm.Centro('BONOS CLUB')));
        SendCmd(Stat, Err, PChar('800'+ dm.Centro('----------')));
        SendCmd(Stat, Err, PChar('800'+ '#Ticket       N. C. F.         Monto   '));
        SendCmd(Stat, Err, PChar('800'+ '---------------------------------------'));
      end;
      QBonosClub.DisableControls;
      QBonosClub.First;
      while not QBonosClub.eof do
      begin
        s := '';
        FillChar(s, 4-length(floattostr(QBonosClubticket.value)),' ');
        s1 := '';
        FillChar(s1, 12-length(FORMAT('%n',[QBonosClubpagado.value])), ' ');

        if cktickets.Checked then
          SendCmd(Stat, Err, PChar('800'+ '  '+s+floattostr(QBonosClubticket.value)+' '+QBonosClubNCF.Value+' '+
          s1+FORMAT('%n',[QBonosClubpagado.value])));

        BonosClub := BonosClub + QBonosClubpagado.value;
        QBonosClub.next;
      end;
      QBonosClub.First;
      QBonosClub.EnableControls;
      if cktickets.Checked then
      begin
        SendCmd(Stat, Err, PChar('800'+ '---------------------------------------'));
        s2 := '';
        FillChar(s2, 12-length(trim(FORMAT('%n',[BonosClub]))), ' ');
        SendCmd(Stat, Err, PChar('800'+ 'Total : '+s2+format('%n',[BonosClub])));
      end;
    end;

    //Otros Bonos
    BonosOtros := 0;
    //MontoItbis := 0;
    if QBonosOtros.RecordCount > 0 then
    begin
      if cktickets.Checked then
      begin
        SendCmd(Stat, Err, PChar('800'+ ' '));
        SendCmd(Stat, Err, PChar('800'+ dm.Centro('OTROS')));
        SendCmd(Stat, Err, PChar('800'+ dm.Centro('-----')));
        SendCmd(Stat, Err, PChar('800'+ '#Ticket       N. C. F.         Monto   '));
        SendCmd(Stat, Err, PChar('800'+ '---------------------------------------'));
      end;
      QBonosOtros.DisableControls;
      QBonosOtros.First;
      while not QBonosOtros.eof do
      begin
        s := '';
        FillChar(s, 4-length(floattostr(QBonosOtrosticket.value)),' ');
        s1 := '';
        FillChar(s1, 12-length(FORMAT('%n',[QBonosOtrospagado.value])), ' ');

        if cktickets.Checked then
          SendCmd(Stat, Err, PChar('800'+ '  '+s+floattostr(QBonosOtrosticket.value)+' '+QBonosOtrosNCF.Value+' '+
          s1+FORMAT('%n',[QBonosOtrospagado.value])));

        BonosOtros := BonosOtros + QBonosOtrospagado.value;
        QBonosOtros.next;
      end;
      QBonosOtros.First;
      QBonosOtros.EnableControls;
      if cktickets.Checked then
      begin
        SendCmd(Stat, Err, PChar('800'+ '---------------------------------------'));
        s2 := '';
        FillChar(s2, 12-length(trim(FORMAT('%n',[BonosOtros]))), ' ');
        SendCmd(Stat, Err, PChar('800'+ 'Total : '+s2+format('%n',[BonosOtros])));
      end;
    end;

    //Devoluciones
    Devolucion := 0;
    //MontoItbis := 0;
    if QDevolucion.RecordCount > 0 then
    begin
      if cktickets.Checked then
      begin
        SendCmd(Stat, Err, PChar('800'+ ' '));
        SendCmd(Stat, Err, PChar('800'+ dm.Centro('NOTAS DE CR')));
        SendCmd(Stat, Err, PChar('800'+ dm.Centro('-----------')));
        SendCmd(Stat, Err, PChar('800'+ '#Ticket       N. C. F.         Monto   '));
        SendCmd(Stat, Err, PChar('800'+ '---------------------------------------'));
      end;
      QDevolucion.DisableControls;
      QDevolucion.First;
      while not QDevolucion.eof do
      begin
        s := '';
        FillChar(s, 4-length(floattostr(QDevolucionticket.value)),' ');
        s1 := '';
        FillChar(s1, 12-length(FORMAT('%n',[QDevolucionpagado.value])), ' ');

        if cktickets.Checked then
          SendCmd(Stat, Err, PChar('800'+ '  '+s+floattostr(QDevolucionticket.value)+' '+QDevolucionNCF.Value+' '+
          s1+FORMAT('%n',[QDevolucionpagado.value])));

        Devolucion := Devolucion + QDevolucionpagado.value;
        QDevolucion.next;
      end;
      QDevolucion.First;
      QDevolucion.EnableControls;
      if cktickets.Checked then
      begin
        SendCmd(Stat, Err, PChar('800'+ '---------------------------------------'));
        s2 := '';
        FillChar(s2, 12-length(trim(FORMAT('%n',[Devolucion]))), ' ');
        SendCmd(Stat, Err, PChar('800'+ 'Total : '+s2+format('%n',[Devolucion])));
      end;
    end;

    //MontoItbis := dm.Query1.FieldByName('itbis').AsFloat;
    //TGrabado   := (MontoItbis * 100)/16;

    s := '';
    FillChar(s, 12-length(trim(FORMAT('%n',[Efectivo]))), ' ');
    s1 := '';
    FillChar(s1, 12-length(trim(FORMAT('%n',[Tarjeta]))), ' ');
    s2 := '';
    FillChar(s2, 12-length(trim(FORMAT('%n',[Cheque]))), ' ');
    s3 := '';
    FillChar(s3, 12-length(trim(FORMAT('%n',[Efectivo + Tarjeta +Cheque + BonosClub + BonosOtros]))), ' ');
    s4 := '';
    FillChar(s4, 12-length(trim(FORMAT('%n',[MontoItbis]))), ' ');
    s5 := '';
    FillChar(s5, 12-length(trim(FORMAT('%n',[Credito]))), ' ');
    s6 := '';
    FillChar(s6, 12-length(trim(FORMAT('%n',[TGrabado]))), ' ');
    s7 := '';
    FillChar(s7, 12-length(trim(FORMAT('%n',[TExcento]))), ' ' );
    s8 := '';
    FillChar(s8, 12-length(trim(FORMAT('%n',[Anulados]))), ' ');
    s9 := '';
    FillChar(s9, 12-length(trim(FORMAT('%n',[BonosClub]))), ' ');
    s10 := '';
    FillChar(s10, 12-length(trim(FORMAT('%n',[BonosOtros]))), ' ');
    s11 := '';
    FillChar(s11, 12-length(trim(FORMAT('%n',[QCuadreefectivo_asignado.Value]))), ' ');

    SendCmd(Stat, Err, PChar('800'+ ' '));
    SendCmd(Stat, Err, PChar('800'+ dm.Centro('VENTA POR FORMA DE PAGO')));
    SendCmd(Stat, Err, PChar('800'+ dm.Centro('-----------------------')));
    SendCmd(Stat, Err, PChar('800'+ 'DEPOSITO      : '+s11+format('%n',[QCuadreefectivo_asignado.Value])));

    s11 := '';
    FillChar(s11, 12-length(trim(FORMAT('%n',[Devolucion]))), ' ');

    SendCmd(Stat, Err, PChar('800'+ 'TOTAL EFECTIVO: '+s+format('%n',[Efectivo])));
    SendCmd(Stat, Err, PChar('800'+ 'TOTAL TARJETA : '+s1+format('%n',[Tarjeta])));
    SendCmd(Stat, Err, PChar('800'+ 'TOTAL CHEQUE  : '+s2+format('%n',[Cheque])));
    SendCmd(Stat, Err, PChar('800'+ 'BONOS CLUB    : '+s9+FORMAT('%n',[BonosClub])));
    SendCmd(Stat, Err, PChar('800'+ 'OTROS         : '+s10+FORMAT('%n',[BonosOtros])));
    SendCmd(Stat, Err, PChar('800'+ 'NOTAS DE CR   : '+s11+FORMAT('%n',[Devolucion])));
    SendCmd(Stat, Err, PChar('800'+ '---------------------------------------'));
    SendCmd(Stat, Err, PChar('800'+ 'TOTAL CONTADO : '+s3+FORMAT('%n',[(Efectivo + Tarjeta + Cheque + BonosClub + BonosOtros) - Devuelta])));
    SendCmd(Stat, Err, PChar('800'+ 'TOTAL NOTAS CR: '+s11+FORMAT('%n',[Devolucion])));
    SendCmd(Stat, Err, PChar('800'+ 'TOTAL CREDITO : '+s5+FORMAT('%n',[Credito])));

    Query1.Close;
    Query1.SQL.Clear;
    Query1.SQL.Add('select t.itbis, sum(case t.itbis when 0 then 0 else ((t.precio*t.cantidad) / ((t.itbis/100)+1)) end) as grabado');
    Query1.SQL.Add('from montos_ticket m, cajas_ip c, ticket t');
    Query1.SQL.Add('where m.caja = c.caja');
    Query1.SQL.Add('and m.fecha = t.fecha');
    Query1.SQL.Add('and m.caja = t.caja');
    Query1.SQL.Add('and m.ticket = t.ticket');
    Query1.SQL.Add('and m.usu_codigo = t.usu_codigo');
    Query1.SQL.Add('and m.fecha_hora between convert(datetime, :fec1, 113) and convert(datetime, :fec2, 113)');
    Query1.SQL.Add('and m.caja = :caj');
    Query1.SQL.Add('and m.usu_codigo = :usu');
    Query1.SQL.Add('and m.status = '+QuotedStr('FAC'));
    if Cuadrar_Empresa = 'C' then
       Query1.SQL.Add('and m.emp_codigo = '+inttostr(empresa_caja));
    Query1.SQL.Add('and t.itbis > 0');
    Query1.SQL.Add('group by t.itbis');
    Query1.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
    Query1.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
    Query1.Parameters.ParamByName('fec1').DataType := ftDateTime;
    Query1.Parameters.ParamByName('fec1').Value    := hora1.DateTime;
    Query1.Parameters.ParamByName('fec2').DataType := ftDateTime;
    Query1.Parameters.ParamByName('fec2').Value    := hora2.DateTime;
    Query1.Open;

    TGrabado := 0;
    while not Query1.Eof do
    begin
      s6 := '';
      FillChar(s6, 12-length(trim(FORMAT('%n',[Query1.FieldByName('grabado').asFloat]))), ' ');
      SendCmd(Stat, Err, PChar('800'+ 'GRABADO '+formatfloat('00',Query1.FieldByName('itbis').asFloat)+'%' + '   : '+s6+
        FORMAT('%n',[Query1.FieldByName('grabado').asFloat])));

      TGrabado := TGrabado + Query1.FieldByName('grabado').asFloat;
      Query1.next;
    end;
    TExcento := (Efectivo+Tarjeta+Cheque+Credito+BonosClub+BonosOtros+QCuadreefectivo_asignado.Value) - devuelta - (TGrabado + MontoItbis);
    s7 := '';
    FillChar(s7, 12-length(trim(FORMAT('%n',[TExcento]))), ' ');

    SendCmd(Stat, Err, PChar('800'+ 'TOTAL ITBIS   : '+s4+FORMAT('%n',[MontoItbis])));
    SendCmd(Stat, Err, PChar('800'+ 'TOTAL EXENTO  : '+s7+FORMAT('%n',[TExcento])));
    SendCmd(Stat, Err, PChar('800'+ 'TOTAL ANULADOS: '+s8+FORMAT('%n',[Anulados])));
    SendCmd(Stat, Err, PChar('800'+ 'CANT.  BOLETOS: '+inttostr(boletos)));

    s := '';
    FillChar(s, 12-length(dm.Query1.FieldByName('cantidad').AsString), ' ');
    SendCmd(Stat, Err, PChar('800'+ 'CANTIDAD TKS  : '+s+dm.Query1.FieldByName('cantidad').AsString));

    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select count(*) as cantidad from montos_ticket');
    dm.Query1.SQL.Add('where caja = :caj');
    dm.Query1.SQL.Add('and usu_codigo = :usu');
    dm.Query1.SQL.Add('and fecha_hora between convert(datetime, :fec1, 113) and convert(datetime, :fec2, 113)');
    dm.Query1.SQL.Add('and status = :st');
    if Cuadrar_Empresa = 'C' then
       dm.Query1.SQL.Add('and emp_codigo = '+inttostr(empresa_caja));
    dm.Query1.Parameters.ParamByName('caj').Value := DBLookupComboBox1.KeyValue;
    dm.Query1.Parameters.ParamByName('usu').Value := DBLookupComboBox2.KeyValue;
    dm.Query1.Parameters.ParamByName('fec1').DataType := ftDateTime;
    dm.Query1.Parameters.ParamByName('fec1').Value    := hora1.DateTime;
    dm.Query1.Parameters.ParamByName('fec2').DataType := ftDateTime;
    dm.Query1.Parameters.ParamByName('fec2').Value    := hora2.DateTime;
    dm.Query1.Parameters.ParamByName('st').Value      := 'ANU';
    dm.Query1.Open;

    s := '';
    FillChar(s, 12-length(dm.Query1.FieldByName('cantidad').AsString), ' ');

    SendCmd(Stat, Err, PChar('800'+ 'TKS ANULADOS  : '+s+dm.Query1.FieldByName('cantidad').AsString));
    SendCmd(Stat, Err, PChar('800'+ 'TOTAL EN CAJA : '+s3+format('%n',[(Efectivo+Tarjeta+Cheque+Credito+BonosClub+BonosOtros+QCuadreefectivo_asignado.Value) - devuelta])));

    if TotalDesgloce > 0 then
    begin
      SendCmd(Stat, Err, PChar('800'+ ''));
      SendCmd(Stat, Err, PChar('800'+ '---------------------------------------'));
      SendCmd(Stat, Err, PChar('800'+ '   M O N T O  CANTIDAD   V A L O R '));
      SendCmd(Stat, Err, PChar('800'+ '---------------------------------------'));
      frmDesgloce.QMontos.First;
      while not frmDesgloce.QMontos.Eof do
      begin
        s := '';
        FillChar(s, 12-length(Format('%n',[frmDesgloce.QMontosmonto.AsFloat])),' ');
        s1 := '';
        FillChar(s1, 5-length(IntToStr(frmDesgloce.QMontoscantidad.AsInteger)),' ');
        s2 := '';
        FillChar(s2, 12-length(Format('%n',[frmDesgloce.QMontosValor.AsFloat])),' ');

        SendCmd(Stat, Err, PChar('800'+s+Format('%n',[frmDesgloce.QMontosmonto.AsFloat])+' '+s1+
               IntToStr(frmDesgloce.QMontoscantidad.AsInteger)+'        '+s2+
               Format('%n',[frmDesgloce.QMontosValor.AsFloat])));

        frmDesgloce.QMontos.Next;
      end;
      frmDesgloce.QMontos.First;
      s := '';
      FillChar(s, 29-length(Format('%n',[frmDesgloce.QMontosValor.AsFloat - TotalDesgloce])),' ');
      s1 := '';
      FillChar(s1, 28-length(Format('%n',[frmDesgloce.QMontosValor.AsFloat - TotalDesgloce])),' ');
      s2 := '';
      FillChar(s2, 29-length(Format('%n',[((Efectivo + Tarjeta + Cheque + BonosClub + BonosOtros) - Devuelta) - TotalDesgloce])),' ');

      SendCmd(Stat, Err, PChar('800'+ '---------------------------------------'));
      SendCmd(Stat, Err, PChar('800'+ 'T O T A L  '+s+Format('%n',[TotalDesgloce])));
      SendCmd(Stat, Err, PChar('800'+ 'DIFERENCIA '+s2+Format('%n',[TotalDesgloce - ((Efectivo + Tarjeta + Cheque + BonosClub + BonosOtros) - Devuelta)])));
      SendCmd(Stat, Err, PChar('800'+ ''));
    end;

    SendCmd(Stat, Err, PChar('800'+ ' '));
    SendCmd(Stat, Err, PChar('800'+ ' '));
    SendCmd(Stat, Err, PChar('800'+ ' '));
    SendCmd(Stat, Err, PChar('800'+ '------------------------'));
    SendCmd(Stat, Err, PChar('800'+ 'Firma del Cajero'));
    SendCmd(Stat, Err, PChar('800'+ ' '));
    SendCmd(Stat, Err, PChar('800'+ ' '));
    SendCmd(Stat, Err, PChar('800'+ ' '));
    SendCmd(Stat, Err, PChar('800'+ '------------------------'));
    SendCmd(Stat, Err, PChar('800'+ 'Firma del Supervisor'));
    SendCmd(Stat, Err, PChar('810'+ ' '));
  end;



  //------------------
 ///cierra el puerto cuando cierra el programa -->  CloseFpctrl;


end;

procedure TfrmCuadre.setLimpiarVariables;
begin
  Efectivo :=0;
  Tarjeta :=0;
  Cheque :=0;
  BonosClub :=0;
  BonosOtros :=0;
  Devolucion :=0;
  Credito :=0;

end;

procedure TfrmCuadre.ImpTicketFiscalCardNet(aCopia: byte);
var
  arch, ptocaja : textfile;
  s, s1, s2, s3, s4, s5, s6, s7, s8 : array[0..100] of char;
  TFac, MontoItbis, Venta, tCambio : double;
  PuntosPrinc, FactorPrin, TotalPuntos, CalcDesc, NumItbis, TotalDescuento : Double;
  Puntos, a, ln, pg, cantpg : integer;
  Msg1, Msg2, Msg3, Msg4, Forma, ImpItbis, lbItbis : String;
  err, x, vCant: integer;
  puerto, parametro : string;
  DriverFiscal1 : TDriverFiscal;
  b : myJSONItem;
  Saldo, vTotal, vTax : double;
  impcodigo,
  param1, param2, param3, param4, param5, param6, param7, param8, param9, param10,
  param11, param12, param13, param14, param15, param16, param17, param18, param19,
  Unidad, codigoabre : string;

begin


  if FileExists('.\puerto.ini') then
  begin
    assignfile(ptocaja, '.\puerto.ini');
    reset(ptocaja);
    readln(ptocaja, puerto);
  end
  else
    puerto := 'COM1';


  codigoabre := Trim(DM.QParametrosPAR_CODIGO_ABRE_CAJA.Value);

  DriverFiscal1 := TDriverFiscal.Create(Self);
  DriverFiscal1.SerialNumber := '27-0163848-435';
  try
  //Original Comercio
  err := DriverFiscal1.IF_OPEN(puerto, 9600);
  err := DriverFiscal1.IF_WRITE('@OpenNonFiscalReceipt');

  param1 := DM.QEmpresaemp_nombre.Text;
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+dm.centro(param1));
  param1 := DM.QEmpresaemp_rnc.Text;
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+dm.centro(param1));
  param1 := DM.QEmpresaEMP_LOCALIDAD.Text;
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+dm.centro(param1));
  param1 := DM.QEmpresaEMP_DIRECCION.Text;
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+dm.centro(param1));
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'');
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'');

  b := myJSONItem.Create;
  b.Code :=  response;

  param1 := 'HOST: '+ b['Closures']['0']['Host'].getStr;
  param2 := 'LOTE: '+ b['Closures']['0']['Batch'].getStr;
  param3 := DM.FillSpaces(param2,40-Length(param1));
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+param1+PARAM3);
  param4 := 'FECHA: '+trim(copy(b['Closures']['0']['DataTime'].getStr,1,9));
  param5 := 'HORA: '+trim(copy(b['Closures']['0']['DataTime'].getStr,10,15));
  param6 := DM.FillSpaces(param5,40-Length(param4));
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+param4+PARAM6);
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'');
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+'');
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+dm.centro('T O T A L  D E  V E N T A S'));
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+dm.centro('======================================='));
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+dm.centro(''));

  //Ventas
  param7 := 'Ventas: ';
  param8 := b['Closures']['0']['Purchase']['Quantity'].getStr+'  RD$';
  param9 := DM.FillSpaces(param8,20-Length(param7));
  vTotal := 0;
  vTax   := 0;
  param10:= FormatCurr('#,0.00',StrToCurr(b['Closures']['0']['Purchase']['Amount'].getStr));
  param11:= DM.FillSpaces(param10,20);
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+param7+PARAM9+param11);

  param12 := 'ITBIS: ';
  param13 := 'RD$';
  param14 := DM.FillSpaces(param13,20-Length(param12));
  param15:= FormatCurr('#,0.00',StrToCurr(b['Closures']['0']['Purchase']['Tax'].getStr));
  param16:= DM.FillSpaces(param15,20);
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+param12+PARAM14+param16);

  vCant  := StrToInt(b['Closures']['0']['Purchase']['Quantity'].getStr);
  vTotal := StrToCurr(b['Closures']['0']['Purchase']['Amount'].getStr);
  vTax   := StrToCurr(b['Closures']['0']['Purchase']['Tax'].getStr);

  //Devolucion
  param7 := 'Devolucion: ';
  param8 := b['Closures']['0']['Return']['Quantity'].getStr+'  RD$';
  param9 := DM.FillSpaces(param8,20-Length(param7));
  param10:= FormatCurr('#,0.00',StrToCurr(b['Closures']['0']['Return']['Amount'].getStr));
  param11:= DM.FillSpaces(param10,20);
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+param7+PARAM9+param11);

  param12 := 'ITBIS: ';
  param13 := 'RD$';
  param14 := DM.FillSpaces(param13,20-Length(param12));
  param15:= FormatCurr('#,0.00',StrToCurr(b['Closures']['0']['Return']['Tax'].getStr));
  param16:= DM.FillSpaces(param15,20);
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+param12+PARAM14+param16);

  vCant  := vCant - StrToInt(b['Closures']['0']['Return']['Quantity'].getStr);
  vTotal := vTotal - StrToCurr(b['Closures']['0']['Return']['Amount'].getStr);
  vTax   := vTax - StrToCurr(b['Closures']['0']['Return']['Tax'].getStr);


  //Totales
  param7 := 'Total: ';
  param8 := IntToStr(vCant)+'  RD$';
  param9 := DM.FillSpaces(param8,20-Length(param7));
  param10:= FormatCurr('#,0.00',vTotal);
  param11:= DM.FillSpaces(param10,20);
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+param7+PARAM9+param11);

  param12 := 'TOTAL ITBIS: ';
  param13 := 'RD$';
  param14 := DM.FillSpaces(param13,20-Length(param12));
  param15:= FormatCurr('#,0.00',vTax);
  param16:= DM.FillSpaces(param15,20);
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+param12+PARAM14+param16);

  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+dm.centro('======================================='));
  err := DriverFiscal1.IF_WRITE('@PrintNonFiscalText|'+dm.centro('LOTE TRANSMITIDO'));



  if codigoabre = 'Termica' then
  err := DriverFiscal1.IF_WRITE('@PaperCut|P');

  err := DriverFiscal1.IF_WRITE('@CloseNonFiscalReceipt|C');
  err := DriverFiscal1.IF_CLOSE;
  pnMsgImpresion.visible :=false;


  finally
    DriverFiscal1.Destroy;
  end;

end;

procedure TfrmCuadre.ImpDetTransCardNet;
var
  arch, puertopeq : textfile;
  s, s1, s2, s3, s4, s5,s6 : array [0..20] of char;
  Tfac, Saldo : double;
  puerto, lbitbis, impcodigo,
  param1, param2, param3, param4, param5, param6, param7, param8, param9, param10,
  param11, param12, param13, param14, param15, param16, param17, param18, param19,
  Unidad, codigoabre, par_monto, par_autoriz, par_tarjeta,
  par_mont, par_autor, par_tarj, batch_cierre, batch_boucher : string;
  a,x, vCant, vCantDev, vCantAMEX : integer;
  b,c, d, e : myJSONItem;
  vTotal, vTotalAMEX, vTotalDev : Currency;

begin
  vCant := 0;
  vCantDev := 0;
  vCantAMEX := 0;
  vTotal := 0;
  vTotalDev := 0;
  vTotalAMEX := 0;

  codigoabre := Trim(DM.QParametrosPAR_CODIGO_ABRE_CAJA.Value);

  if FileExists('.\puerto.txt') then
  begin
    assignfile(puertopeq, '.\puerto.txt');
    reset(puertopeq);
    readln(puertopeq, puerto);
  end
  else
    puerto := 'PRN';

  closefile(puertopeq);

  AssignFile(arch, '.\impdetverifone.bat');
  rewrite(arch);
  writeln(arch, 'type .\detverifone.txt > '+puerto);
  closefile(arch);


  AssignFile(arch, '.\detverifone.txt');
  rewrite(arch);
  param1 := DM.QEmpresaemp_nombre.Text;
  writeln(arch,dm.centro(param1));
  param1 := DM.QEmpresaEMP_RNC.Text;
  writeln(arch,dm.centro(param1));
  param1 := DM.QEmpresaEMP_LOCALIDAD.Text;
  writeln(arch,dm.centro(param1));
  param1 := DM.QEmpresaEMP_DIRECCION.Text;
  writeln(arch,dm.centro(param1));
  writeln(arch,'');
  writeln(arch,'');


  ///TOTAL DE VENTAS SIN AMEX
  writeln(arch,dm.centro('D E T A L L E S   D E   V E N T AS'));
  writeln(arch,dm.centro('======================================='));
  writeln(arch,dm.centro(''));

  //Detallado
  dm.Query1.Close;
  DM.Query1.SQL.Clear;
  dm.Query1.SQL.Add('DECLARE @EMP INT, @SUC INT, @USU INT, @FEC1 DATETIME, @FEC2 DATETIME');
  dm.Query1.SQL.Add('SET @EMP = :EMP');
  dm.Query1.SQL.Add('SET @SUC = :SUC');
  dm.Query1.SQL.Add('SET @USU = :USU');
  dm.Query1.SQL.Add('SET @FEC1 = :FEC1');
  dm.Query1.SQL.Add('SET @FEC2 = (SELECT GETDATE())');
  dm.Query1.SQL.Add('SELECT * FROM(');
  DM.Query1.SQL.Add('SELECT FECHA, Resultado JSON, cast ((cast (monto as numeric(18,2))/100) as numeric(18,2)) monto');
  DM.Query1.SQL.Add('FROM ADLOGVERIPHONE');
  DM.Query1.SQL.Add('WHERE FECHA > ');
  DM.Query1.SQL.Add('(SELECT ISNULL(MAX(FECHA),CAST(CAST(GETDATE() AS CHAR(11)) AS DATETIME))');
  DM.Query1.SQL.Add('FROM ADLOGVERIPHONE WHERE TIPO = '+QuotedStr('C')+' AND EMP_CODIGO = @EMP ');
  DM.Query1.SQL.Add('AND SUC_CODIGO = @SUC AND USU_CODIGO= @USU AND FECHA BETWEEN @FEC1 AND @FEC2)');
  DM.Query1.SQL.Add('AND TIPO ='+QuotedStr('N'));
  DM.Query1.SQL.Add('and RESULTADO not LIKE '+QuotedStr('%AMEX%'));
  dm.Query1.SQL.Add(') AS TEMP WHERE monto > 0');
  dm.Query1.SQL.Add('order by fecha desc');
  dm.Query1.Parameters.ParamByName('usu').Value    := DBLookupComboBox2.KeyValue;
  dm.Query1.Parameters.ParamByName('fec1').DataType := ftDate;
  dm.Query1.Parameters.ParamByName('fec1').Value    := fecha1.Date;
  dm.Query1.Parameters.ParamByName('emp').Value     := frmMain.empcaja;
  dm.Query1.Parameters.ParamByName('suc').Value     := frmMain.vp_suc;
  dm.Query1.Open;
  IF NOT DM.Query1.IsEmpty THEN BEGIN
  Writeln(arch,'MONTO        TARJETA       AUTORIZACION');
  writeln(arch,dm.centro('======================================='));
  while not DM.Query1.Eof DO BEGIN
  c               := myJSONItem.Create;
  c.Code          := DM.Query1.FieldByName('JSON').Value;
  FillChar(s,8-length(trim(DM.Query1.FieldByName('monto').Text)),' ');
  FillChar(s1, 20-length(c['Card']['CardNumber'].getStr),' ');
  FillChar(s2, 8-length(c['Transaction']['AuthorizationNumber'].getStr),' ');
  writeln(arch, DM.Query1.FieldByName('monto').Text+s+' '+
                c['Card']['CardNumber'].getStr+s1+' '+
                c['Transaction']['AuthorizationNumber'].getStr);
  vCant := vCant + 1;
  vTotal := vTotal + DM.Query1.FieldByName('monto').Value;
  DM.Query1.Next;
  END;
  END;



  //Detallado
  dm.Query1.Close;
  DM.Query1.SQL.Clear;
  dm.Query1.Close;
  DM.Query1.SQL.Clear;
  dm.Query1.SQL.Add('DECLARE @EMP INT, @SUC INT, @USU INT, @FEC1 DATETIME, @FEC2 DATETIME');
  dm.Query1.SQL.Add('SET @EMP = :EMP');
  dm.Query1.SQL.Add('SET @SUC = :SUC');
  dm.Query1.SQL.Add('SET @USU = :USU');
  dm.Query1.SQL.Add('SET @FEC1 = :FEC1');
  dm.Query1.SQL.Add('SET @FEC2 = (SELECT GETDATE())');
  dm.Query1.SQL.Add('SELECT * FROM(');
  dm.Query1.SQL.Add('SELECT FP.fecha, FP2.Resultado JSON, cast ((cast (FP.monto as numeric(18,2))/100) as numeric(18,2)) monto, FP2.tipo');
  dm.Query1.SQL.Add('FROM ADLOGVERIPHONE FP');
  dm.Query1.SQL.Add('inner join adLogVeriphone fp2 on fp.emp_codigo = fp2.emp_codigo and fp.suc_codigo = fp2.suc_codigo and fp.facticket = fp2.facticket  and fp.usu_codigo = fp2.usu_codigo');
  dm.Query1.SQL.Add('where fp.resultado like '+QuotedStr('%Successful Annulment%'));
  dm.Query1.SQL.Add('AND fp2.TIPO =  '+QuotedStr('N'));
  dm.Query1.SQL.Add('AND FP.FECHA >');
  dm.Query1.SQL.Add('(SELECT ISNULL(MAX(FECHA),CAST(CAST(GETDATE() AS CHAR(11)) AS DATETIME))');
  dm.Query1.SQL.Add('FROM ADLOGVERIPHONE WHERE TIPO = '+QuotedStr('C')+' AND EMP_CODIGO = @EMP AND SUC_CODIGO = @SUC AND USU_CODIGO= @USU AND FECHA BETWEEN @FEC1 AND @FEC2)');
  dm.Query1.SQL.Add(') AS TEMP WHERE monto > 0');
  dm.Query1.SQL.Add('order by fecha desc');
  dm.Query1.Parameters.ParamByName('usu').Value    := DBLookupComboBox2.KeyValue;
  dm.Query1.Parameters.ParamByName('fec1').DataType := ftDate;
  dm.Query1.Parameters.ParamByName('fec1').Value    := fecha1.Date;
  dm.Query1.Parameters.ParamByName('emp').Value     := frmMain.empcaja;
  dm.Query1.Parameters.ParamByName('suc').Value     := frmMain.vp_suc;
  dm.Query1.Open;
  IF NOT DM.Query1.IsEmpty THEN BEGIN
  ///TOTAL DE VENTAS SIN AMEX
  writeln(arch,'');
  writeln(arch,'');
  writeln(arch,dm.centro('D E T A L L E S   A N U L A C I O N'));
  writeln(arch,dm.centro('======================================='));
  writeln(arch,dm.centro(''));

  Writeln(arch,'MONTO        TARJETA       AUTORIZACION');
  writeln(arch,dm.centro('======================================='));
  while not DM.Query1.Eof DO BEGIN
  c               := myJSONItem.Create;
  c.Code          := DM.Query1.FieldByName('JSON').Value;
  FillChar(s,8-length(trim(DM.Query1.FieldByName('monto').Text)),' ');
  FillChar(s1, 20-length(c['Card']['CardNumber'].getStr),' ');
  FillChar(s2, 8-length(c['Transaction']['AuthorizationNumber'].getStr),' ');
  writeln(arch, DM.Query1.FieldByName('monto').Text+s+' '+
                c['Card']['CardNumber'].getStr+s1+' '+
                c['Transaction']['AuthorizationNumber'].getStr);
  vCantDev := vCantDev + 1;
  vTotalDev := vTotalDev + DM.Query1.FieldByName('monto').Value;
  DM.Query1.Next;
  END;
  END;


  //Detallado
  dm.Query1.Close;
  DM.Query1.SQL.Clear;
  dm.Query1.SQL.Add('DECLARE @EMP INT, @SUC INT, @USU INT, @FEC1 DATETIME, @FEC2 DATETIME');
  dm.Query1.SQL.Add('SET @EMP = :EMP');
  dm.Query1.SQL.Add('SET @SUC = :SUC');
  dm.Query1.SQL.Add('SET @USU = :USU');
  dm.Query1.SQL.Add('SET @FEC1 = :FEC1');
  dm.Query1.SQL.Add('SET @FEC2 = (SELECT GETDATE())');
  dm.Query1.SQL.Add('SELECT * FROM(');
  DM.Query1.SQL.Add('SELECT FECHA, Resultado JSON, cast ((cast (monto as numeric(18,2))/100) as numeric(18,2)) monto');
  DM.Query1.SQL.Add('FROM ADLOGVERIPHONE');
  DM.Query1.SQL.Add('WHERE FECHA > ');
  DM.Query1.SQL.Add('(SELECT ISNULL(MAX(FECHA),CAST(CAST(GETDATE() AS CHAR(11)) AS DATETIME))');
  DM.Query1.SQL.Add('FROM ADLOGVERIPHONE WHERE TIPO = '+QuotedStr('C')+' AND EMP_CODIGO = @EMP ');
  DM.Query1.SQL.Add('AND SUC_CODIGO = @SUC AND USU_CODIGO= @USU AND FECHA BETWEEN @FEC1 AND @FEC2)');
  DM.Query1.SQL.Add('AND TIPO ='+QuotedStr('N'));
  DM.Query1.SQL.Add('and RESULTADO LIKE '+QuotedStr('%AMEX%'));
  dm.Query1.SQL.Add(') AS TEMP WHERE monto > 0');
  dm.Query1.SQL.Add('order by fecha desc');
  dm.Query1.Parameters.ParamByName('usu').Value    := DBLookupComboBox2.KeyValue;
  dm.Query1.Parameters.ParamByName('fec1').DataType := ftDate;
  dm.Query1.Parameters.ParamByName('fec1').Value    := fecha1.Date;
  dm.Query1.Parameters.ParamByName('emp').Value     := frmMain.empcaja;
  dm.Query1.Parameters.ParamByName('suc').Value     := frmMain.vp_suc;
  dm.Query1.Open;
  IF NOT DM.Query1.IsEmpty THEN BEGIN
  writeln(arch,'');
  writeln(arch,'');
  ///TOTAL DE VENTAS SIN AMEX
  writeln(arch,dm.centro('D E T A L L E S   V E N T A S  A M E X'));
  writeln(arch,dm.centro('======================================='));
  writeln(arch,dm.centro(''));
  Writeln(arch,'MONTO        TARJETA       AUTORIZACION');
  writeln(arch,dm.centro('======================================='));
  while not DM.Query1.Eof DO BEGIN
  c               := myJSONItem.Create;
  c.Code          := DM.Query1.FieldByName('JSON').Value;
  FillChar(s,8-length(trim(DM.Query1.FieldByName('monto').Text)),' ');
  FillChar(s1, 20-length(c['Card']['CardNumber'].getStr),' ');
  FillChar(s2, 8-length(c['Transaction']['AuthorizationNumber'].getStr),' ');
  writeln(arch, DM.Query1.FieldByName('monto').Text+s+' '+
                c['Card']['CardNumber'].getStr+s1+' '+
                c['Transaction']['AuthorizationNumber'].getStr);
  vCantAMEX := vCantAMEX + 1;
  vTotalAMEX := vTotalAMEX + DM.Query1.FieldByName('monto').Value;
  DM.Query1.Next;
  END;
  END;

  writeln(arch,'');
  writeln(arch,'');
  writeln(arch,dm.centro('======================================='));
  writeln(arch,dm.centro('T O T A L   D E   V E N T AS'));
  writeln(arch,dm.centro('======================================='));

  //Ventas
  param7 := 'Ventas: ';
  param8 := IntToStr(vCant)+'  RD$';
  param9 := DM.FillSpaces(param8,20-Length(param7));
  param10:= FormatCurr('#,0.00',vTotal);
  param11:= DM.FillSpaces(param10,20);
  writeln(arch,param7+PARAM9+param11);

  //Ventas AMEX
  param7 := 'Ventas AMEX: ';
  param8 := IntToStr(vCantAMEX)+'  RD$';
  param9 := DM.FillSpaces(param8,20-Length(param7));
  param10:= FormatCurr('#,0.00',vTotalAMEX);
  param11:= DM.FillSpaces(param10,20);
  writeln(arch,param7+PARAM9+param11);

  //Devolucion
  param7 := 'Devolucion: ';
  param8 := IntToStr(vCantDev)+'  RD$';
  param9 := DM.FillSpaces(param8,20-Length(param7));
  param10:= FormatCurr('#,0.00',vTotalDev);
  param11:= DM.FillSpaces(param10,20);
  writeln(arch,param7+PARAM9+param11);

  writeln(arch,'');
  writeln(arch,'');
  writeln(arch,dm.centro('======================================='));
  writeln(arch,dm.centro('T O T A L   G E N E R A L'));
  writeln(arch,dm.centro('======================================='));

  //Ventas
  param7 := 'TOTAL GRAL: ';
  param8 := IntToStr(vCant+vCantAMEX-vCantDev)+'  RD$';
  param9 := DM.FillSpaces(param8,20-Length(param7));
  param10:= FormatCurr('#,0.00',vTotal+vTotalAMEX-vTotalDev);
  param11:= DM.FillSpaces(param10,20);
  writeln(arch,param7+PARAM9+param11);


  for X:= 1 to 15 do begin
    writeln(arch,'');
  end;

  if codigoabre = 'Termica' then
  writeln(arch,chr(27)+chr(109));

  CloseFile(arch);

 winexec('.\impdetverifone.bat',0);

END;



procedure TfrmCuadre.btnRepDetPinpadClick(Sender: TObject);
begin
if MessageDlg('DESEA IMPRIMIR LAS TRASACCIONES ACTIVAS EN EL VERIPHONE?',mtConfirmation,[mbyes, mbno],0) = mryes then
  begin
    pnMsgImpresion.visible :=true;
    lblWait.Caption:='Imprimiento Detalle de Transacciones...';
    Application.ProcessMessages();
      CASE Impresora.IDPrinter OF
      0:ImpDetTransCardNet;
      //1 : {EPSON (TMU-220)}      ImpTicketFiscalCardNet(impresora.copia);
      end;
      lblWait.Caption:='';
      pnMsgImpresion.visible :=false;
      end;
end;

end.
