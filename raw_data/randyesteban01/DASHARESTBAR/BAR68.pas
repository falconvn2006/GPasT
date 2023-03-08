unit BAR68;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, DB, ADODB;

type
  TFrmHabitaciones = class(TForm)
    edtHab: TEdit;
    lblHab: TLabel;
    pnl1: TPanel;
    bt7: TSpeedButton;
    bt8: TSpeedButton;
    bt9: TSpeedButton;
    bt6: TSpeedButton;
    bt5: TSpeedButton;
    bt4: TSpeedButton;
    bt1: TSpeedButton;
    bt2: TSpeedButton;
    bt3: TSpeedButton;
    btok: TSpeedButton;
    btclear: TSpeedButton;
    bt0: TSpeedButton;
    ADO: TADOConnection;
    Query: TADOQuery;
    procedure bt0Click(Sender: TObject);
    procedure btclearClick(Sender: TObject);
    procedure bt1Click(Sender: TObject);
    procedure bt2Click(Sender: TObject);
    procedure bt3Click(Sender: TObject);
    procedure bt4Click(Sender: TObject);
    procedure bt5Click(Sender: TObject);
    procedure bt6Click(Sender: TObject);
    procedure bt9Click(Sender: TObject);
    procedure bt8Click(Sender: TObject);
    procedure bt7Click(Sender: TObject);
    procedure btokClick(Sender: TObject);
    procedure ADOBeforeConnect(Sender: TObject);
    procedure edtHabKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmHabitaciones: TFrmHabitaciones;

implementation

uses BAR04, BAR00, BAR01, Math;

{$R *.dfm}

procedure TFrmHabitaciones.bt0Click(Sender: TObject);
begin
edtHab.Text := edtHab.Text + '0';
end;

procedure TFrmHabitaciones.btclearClick(Sender: TObject);
begin
edtHab.Clear;
end;

procedure TFrmHabitaciones.bt1Click(Sender: TObject);
begin
edtHab.Text := edtHab.Text + '1';
end;

procedure TFrmHabitaciones.bt2Click(Sender: TObject);
begin
edtHab.Text := edtHab.Text + '2';
end;

procedure TFrmHabitaciones.bt3Click(Sender: TObject);
begin
edtHab.Text := edtHab.Text + '3';
end;

procedure TFrmHabitaciones.bt4Click(Sender: TObject);
begin
edtHab.Text := edtHab.Text + '4';
end;

procedure TFrmHabitaciones.bt5Click(Sender: TObject);
begin
edtHab.Text := edtHab.Text + '5';
end;

procedure TFrmHabitaciones.bt6Click(Sender: TObject);
begin
edtHab.Text := edtHab.Text + '6';
end;

procedure TFrmHabitaciones.bt9Click(Sender: TObject);
begin
edtHab.Text := edtHab.Text + '9';
end;

procedure TFrmHabitaciones.bt8Click(Sender: TObject);
begin
edtHab.Text := edtHab.Text + '8';
end;

procedure TFrmHabitaciones.bt7Click(Sender: TObject);
begin
edtHab.Text := edtHab.Text + '7';
end;

procedure TFrmHabitaciones.btokClick(Sender: TObject);
var
vl_idhab, vl_hab, vl_reserva : Integer;
vl_user :String;
begin
with Query do begin
Close;
SQL.Clear;
SQL.Add('select b.reserva_nombre nombre, a.numero_habitacion hab, a.cod_reserva, c.Cod_habitacion from hotel_cal a');
SQL.Add('inner join Hotel_Reservas b on a.cod_reserva=b.cod_reserva');
SQL.Add('inner join Hotel_habitaciones c on a.numero_habitacion=c.numero_habitacion');
SQL.Add('where fecha = cast(cast(getdate() as char(11)) as datetime) and a.numero_habitacion = :hab');
Parameters[0].Value := Trim(edtHab.Text);
Open;
if IsEmpty then begin
ShowMessage('Esta Habitacion no esta ocupada...'+Char(13)+
            'Favor verificar este dato....');
Abort;
end;

if not IsEmpty then begin
vl_hab     := StrToInt(edtHab.Text);
vl_idhab   := Query.FieldbyName('Cod_habitacion').AsInteger;
vl_reserva := Query.FieldbyName('cod_reserva').AsInteger;

if MessageDlg('La habitacion #'+edtHab.Text+', pertenece a '+FieldByName('nombre').Text+'?',
mtConfirmation,[mbYes,mbNo],0)=mryes then begin
      frmPOS.QDetalle.DisableControls;
      frmPOS.QDetalle.First;
      while not frmPOS.QDetalle.Eof do
      begin
        frmPOS.QDetalle.Edit;
        frmPOS.QDetalleCajeroID.Value := frmMain.Usuario;
        frmPOS.QDetalle.Post;
        frmPOS.QDetalle.Next;
      end;
      frmPOS.QDetalle.First;
      frmPOS.QDetalle.EnableControls;
      frmPOS.QDetalle.UpdateBatch;

      frmPOS.QFactura.Edit;
      frmPOS.QFacturaHold.Value    := False;
      frmPOS.QFacturaEstatus.Value := 'SER';
      frmPOS.QFacturaNombre.Value  := 'Hab.NO. '+Trim(edtHab.Text);
      frmPOS.QFacturaHora.Value    := Now;
      frmPOS.QFacturaFecha.Value   := Date;
      frmPOS.QFacturaTipoNCF.Value := frmPOS.TipoNCF;
      frmPOS.QFacturaConItbis.Value   := frmPOS.ckItbis;
      frmPOS.QFacturaConPropina.Value := frmPOS.ckPropina;
      frmPOS.QFacturaimprimeNCF.Value := frmPOS.ckNCF;
      frmPOS.QFacturaCajeroID.Value   := frmMain.Usuario;

      //Insertando Forma de Pago
      frmPOS.QForma.Insert;
      frmPOS.QFormaCajeroID.Value  := frmPOS.QFacturaCajeroID.Value;
      frmPOS.QFormaFacturaID.Value := frmPOS.QFacturaFacturaID.Value;
      frmPOS.QFormaCajaID.Value    := frmPOS.QFacturaCajaID.Value;
      frmPOS.QFormaDetalleID.Value := 1;
      frmPOS.QFormaMonto.Value     := 0;
      frmPOS.QFormaDevuelta.Value  := 0;
      frmPOS.QFormaForma.Value     := 'Servicio';
      frmPOS.QForma.Post;
      frmPOS.QForma.UpdateBatch;

      //Buscando comprobante
      if frmPOS.TipoNCF = 1 then
      begin
        frmPOS.QFacturarnc.Clear;
      end;

   if frmPOS.QFacturaimprimeNCF.Value then
      begin
      Query.Close;
      Query.SQL.Clear;
      Query.SQL.Add('select isnull(NCF_Secuencia,0) sec,NCF_FIJO NCF from ncf');
      Query.SQL.Add('where ncf_fijo = case when :tipo = 1 then '+QuotedStr('B02'));
			Query.SQL.Add('                   	  when :tipo = 2 then '+QuotedStr('B01'));
			Query.SQL.Add('                   	  when :tipo = 3 then '+QuotedStr('B15'));
			Query.SQL.Add('                   	  when :tipo = 4 then '+QuotedStr('B14'));
			Query.SQL.Add('END');
      Query.Parameters.ParamByName('tipo').Value := frmPOS.TipoNCF;
      Query.Open;
      if Query.RecordCount > 0 then
      begin
        frmPOS.QFacturaNCF.Value := Query.FieldByName('NCF').Value + FormatFloat('00000000', Query.FieldByName('Sec').AsInteger);

        Query.Close;
        Query.SQL.Clear;
        Query.SQL.Add('update NCF set NCF_Secuencia = NCF_Secuencia + 1 ');
        Query.SQL.Add('where ncf_fijo = case when :tipo = 1 then '+QuotedStr('B02'));
			  Query.SQL.Add('                   	  when :tipo = 2 then '+QuotedStr('B01'));
			  Query.SQL.Add('                   	  when :tipo = 3 then '+QuotedStr('B15'));
			  Query.SQL.Add('                   	  when :tipo = 4 then '+QuotedStr('B14'));
        Query.SQL.Add('END');
        Query.Parameters.ParamByName('tipo').Value := frmPOS.TipoNCF;
        Query.ExecSQL;
      end;
      end;

      frmPOS.QFactura.Post;


      if frmPOS.QFacturaMesaID.Value > 0 then
      begin
        //Actualizando Mesa
        dm.Query1.Close;
        dm.Query1.SQL.Clear;
        dm.Query1.SQL.Add('update Mesas set Estatus = :st where MesaID = :mesa');
        dm.Query1.Parameters.ParamByName('st').Value   := 'DISP';
        dm.Query1.Parameters.ParamByName('mesa').Value := frmPOS.QFacturaMesaID.Value;
        dm.Query1.ExecSQL;
      end;

      with Query do begin

      //Buscar Usuario
      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('select SUBSTRING(nombre,1,30) nombre from dashabar.dbo.usuarios where UsuarioID = '+QuotedStr(IntToStr(frmMain.Usuario)));
      dm.Query1.Open;
      If not IsEmpty then
      vl_user := dm.Query1.FieldByName('nombre').Text;
      dm.Query1.Close;

      //Registro hotel_servicio_consumidos
      Close;
      SQL.Clear;
      SQL.Add('insert into hotel_servicio_consumidos');
      SQL.Add('(cod_reserva, cod_habitacion, numero_habitacion, cod_servicio, servicio,');
      SQL.Add('precio, fecha, user_codi, propleg, itbis, subtotal, cod_orden)');
      SQL.Add('select :res, :habid, :hab, :ser, :serN,');
      SQL.Add(':prec, :fec, :user, :proleg, :itbis, :subtotal, :orden');
      Parameters.ParamByName('res').Value      := vl_reserva;
      Parameters.ParamByName('habid').Value    := vl_idhab;
      Parameters.ParamByName('hab').Value      := vl_hab;
      Parameters.ParamByName('ser').Value      := 0;
      Parameters.ParamByName('serN').Value     := 'Consumo Bar/Rest. '+frmPOS.QFacturaFacturaID.Text;
      Parameters.ParamByName('user').Value     := vl_user;
      Parameters.ParamByName('orden').Value    := frmPOS.QFacturaFacturaID.Value;
      Parameters.ParamByName('prec').Value     := frmPOS.QFacturaTotal.Value;
      Parameters.ParamByName('fec').Value      := frmPOS.QFacturaFecha.Value;
      Parameters.ParamByName('proleg').Value   := frmPOS.QFacturaPropina.Value;
      Parameters.ParamByName('itbis').Value    := frmPOS.QFacturaItbis.Value;
      Parameters.ParamByName('subtotal').Value := frmPOS.QFacturaTotal.Value - frmPOS.QFacturaItbis.Value;
      ExecSQL;

      //Registro Hotel_cuenta_reserva - subtotal
      Close;
      SQL.Clear;
      SQL.Add('update Hotel_cuenta_reserva');
      SQL.Add('set subtotal_cons = (select isnull(sum(subtotal),0) from hotel_servicio_consumidos where cod_reserva = '+QuotedStr(frmPOS.QFacturaFacturaID.Text)+')');
      SQL.Add('where cod_reserva = '+QuotedStr(frmPOS.QFacturaFacturaID.Text));
      ExecSQL;

      //Registro Hotel_cuenta_reserva - itbis
      Close;
      SQL.Clear;
      SQL.Add('update Hotel_cuenta_reserva');
      SQL.Add('set itbis_cons = (select isnull(sum(itbis),0) from hotel_servicio_consumidos where cod_reserva = '+QuotedStr(frmPOS.QFacturaFacturaID.Text)+')');
      SQL.Add('where cod_reserva = '+QuotedStr(frmPOS.QFacturaFacturaID.Text));
      ExecSQL;

      //Registro Hotel_cuenta_reserva - propleg
      Close;
      SQL.Clear;
      SQL.Add('update Hotel_cuenta_reserva');
      SQL.Add('set propleg_cons = (select isnull(sum(propleg),0) from hotel_servicio_consumidos where cod_reserva = '+QuotedStr(frmPOS.QFacturaFacturaID.Text)+')');
      SQL.Add('where cod_reserva = '+QuotedStr(frmPOS.QFacturaFacturaID.Text));
      ExecSQL;

      //Registro HotEL_DET_CONSUMO
      if frmPOS.QDetalle.RecordCount > 0 then begin
      frmPOS.QDetalle.First;
      while not frmPOS.QDetalle.Eof do begin
      Close;
      SQL.Clear;
      SQL.Add('insert into HotEL_DET_CONSUMO');
      SQL.Add('(cod_reserva, cod_orden, cod_producto, prod_name, cantidad, precio, subtotal)');
      SQL.Add('select :res, :orden, :prod, :prodN, :cant, :prec, :subtotal');
      Parameters.ParamByName('res').Value      := vl_reserva;
      Parameters.ParamByName('orden').Value    := frmPOS.QDetalleFacturaID.Value;
      Parameters.ParamByName('prod').Value     := frmPOS.QDetalleProductoID.Value;
      Parameters.ParamByName('prodN').Value    := frmPOS.QDetalleNombre.Value;
      Parameters.ParamByName('cant').Value     := frmPOS.QDetalleCantidad.Value;
      Parameters.ParamByName('prec').Value     := frmPOS.QDetallePrecio.Value;
      Parameters.ParamByName('subtotal').Value := frmPOS.QDetalleTotalsubTotal.Value;
      ExecSQL;
      frmPOS.QDetalle.Next;
      end;
      end;

      end;


      //Imprimiendo
      frmPOS.ImpTicket;

      frmPOS.TExento    := 0;
      frmPOS.TItbis     := 0;
      frmPOS.TPropina   := 0;
      frmPOS.TGrabado   := 0;
      frmPOS.TDescuento := 0;
      frmPOS.Total      := 0;
      frmPOS.ckPropina  := true;
      frmPOS.ckItbis    := true;

      frmPOS.lbtotal.Caption     := '0.00';
      frmPOS.lbpropina.Caption   := '0.00';
      frmPOS.lbsubtotal.Caption  := '0.00';
      frmPOS.lbdescuento.Caption := '0.00';
      frmPOS.lbitbis.Caption     := '0.00';
      frmPOS.lbexento.Caption    := '0.00';

      frmPOS.QFactura.Close;
      frmPOS.QFactura.Parameters.ParamByName('caj').Value := frmMain.Usuario;
      frmPOS.QFactura.Parameters.ParamByName('fac').Value := -1;
      frmPOS.QFactura.Parameters.ParamByName('caja').Value := 1;
      frmPOS.QFactura.Open;

      frmPOS.QForma.Close;
      frmPOS.QForma.Parameters.ParamByName('caj').Value := frmMain.Usuario;
      frmPOS.QForma.Parameters.ParamByName('fac').Value := -1;
      frmPOS.QForma.Parameters.ParamByName('caja').Value := 1;
      frmPOS.QForma.Open;

      frmPOS.QDetalle.Close;
      frmPOS.QDetalle.Parameters.ParamByName('caj').Value := frmMain.Usuario;
      frmPOS.QDetalle.Parameters.ParamByName('fac').Value := -1;
      frmPOS.QDetalle.Parameters.ParamByName('caja').Value := 1;
      frmPOS.QDetalle.Open;

      frmPOS.QDetalleTotal.Close;
      frmPOS.QDetalleTotal.Open;


      frmPOS.lbmesa.Caption := 'FACTURA DIRECTA';
      frmPOS.TipoNCF := 1;

      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('select nombre from ncf where tipo = :cod');
      dm.Query1.Parameters.ParamByName('cod').Value := frmPOS.TipoNCF;
      dm.Query1.Open;
      frmPOS.lbrnc.Caption := dm.Query1.FieldByName('nombre').AsString;

      frmPOS.rnc := '';
      frmPOS.razon_social := '';


end;
FrmHabitaciones.Close;
end;
end;
end;

procedure TFrmHabitaciones.ADOBeforeConnect(Sender: TObject);
var
  ar : textfile;
  db : string;
begin
  assignfile(ar, '.\DashaSQL.ini');
  reset(ar);
  read(ar, db);
  ADO.ConnectionString := db+ConnectionStringPlus;
  closefile(ar);

end;

procedure TFrmHabitaciones.edtHabKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
btokClick(Sender);
end;

end.
