unit POS22;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ToolWin, ComCtrls, Grids, DBGrids, StdCtrls, DB, ADODB;

type
  TfrmDevoluciones = class(TForm)
    ToolBar1: TToolBar;
    btsalir: TSpeedButton;
    bteliminar: TSpeedButton;
    DBGrid1: TDBGrid;
    Label1: TLabel;
    ednumero: TEdit;
    Query1: TADOQuery;
    procedure btsalirClick(Sender: TObject);
    procedure ednumeroKeyPress(Sender: TObject; var Key: Char);
    procedure bteliminarClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid1ColEnter(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    NoDevolucion : Integer;
  public
    vl_balance : Double;
    vl_forma : String;
    { Public declarations }
  end;

var
  frmDevoluciones: TfrmDevoluciones;

implementation

uses POS00, POS01, POS04, POS05, POS06;

{$R *.dfm}

procedure TfrmDevoluciones.btsalirClick(Sender: TObject);
begin
  close;
end;

procedure TfrmDevoluciones.ednumeroKeyPress(Sender: TObject;
  var Key: Char);
begin
  if key = #13 then
  begin
    if trim(ednumero.Text) <> '' then
    begin
      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('select dev_total, dev_status, dev_montousado from devolucion');
      dm.Query1.SQL.Add('where emp_codigo = :emp');
      dm.Query1.SQL.Add('and suc_codigo = 1');
      dm.Query1.SQL.Add('and dev_numero = :num');
      dm.Query1.Parameters.ParamByName('emp').Value := frmMain.empresainv;
      dm.Query1.Parameters.ParamByName('num').Value := StrToInt(Trim(ednumero.Text));
      dm.Query1.Open;
      if dm.Query1.RecordCount = 0 then
        MessageDlg('ESTA DEVOLUCION NO EXISTE, PRESIONE [ENTER] PARA SALIR',mtError,[mbok],0)
      else
      begin
        if dm.Query1.FieldByName('dev_status').Value = 'ANU' then
          MessageDlg('ESTA DEVOLUCION ESTA ANULADA, PRESIONE [ENTER] PARA SALIR',mtError,[mbok],0)
        else
        begin
          {Query1.close;
          Query1.SQL.Clear;
          Query1.SQL.Add('select pagado from formas_pago_ticket f, montos_ticket m');
          Query1.SQL.Add('where m.caja = f.caja and m.usu_codigo = f.usu_codigo');
          Query1.SQL.Add('and m.fecha = f.fecha and m.ticket = f.ticket');
          Query1.SQL.Add('and f.forma = '+QuotedStr('DEV'));
          Query1.SQL.Add('and f.documento = :num');
          Query1.SQL.Add('and m.status <> '+QuotedStr('ANU'));
          Query1.Parameters.ParamByName('num').Value := Trim(ednumero.Text);
          Query1.Open;
          if Query1.RecordCount > 0 then}
          if (dm.Query1.FieldByName('dev_total').Value-
              dm.Query1.FieldByName('dev_montousado').Value) <= 0 then BEGIN
            IF frmEfectivo.Active THEN 
            frmEfectivo.Facturo := 1;
            MessageDlg('ESTA DEVOLUCION YA FUE UTILIZADA, PRESIONE [ENTER] PARA SALIR',mtError,[mbok],0);
          end
          else
          begin
            frmMain.QFormaPago.Close;
            if frmMain.forma_numeracion = 1 then
            begin
              frmMain.QFormaPago.SQL.Clear;
              frmMain.QFormaPago.SQL.Add('select caja, usu_codigo, fecha, ticket, forma, pagado,');
              frmMain.QFormaPago.SQL.Add('devuelta, empresa, credito, cliente, banco, documento');
              frmMain.QFormaPago.SQL.Add('from formas_pago_ticket');
              frmMain.QFormaPago.SQL.Add('where caja = :caj');
              frmMain.QFormaPago.SQL.Add('and ticket = :tik');
              frmMain.QFormaPago.SQL.Add('and fecha = convert(datetime, :fec, 105)');
              frmMain.QFormaPago.SQL.Add('and usu_codigo = :usu');
              frmMain.QFormaPago.Parameters.ParamByName('fec').DataType := ftDate;
              frmMain.QFormaPago.Parameters.ParamByName('fec').Value    := Date;
              frmMain.QFormaPago.Parameters.ParamByName('usu').Value    := dm.Usuario;
            end;

            frmMain.QFormaPago.Parameters.ParamByName('caj').Value    := StrToInt(Trim(frmMain.edcaja.Caption));
            frmMain.QFormaPago.Parameters.ParamByName('tik').Value    := frmMain.QTicketticket.Value;
            frmMain.QFormaPago.Open;

            frmMain.QFormaPago.Append;
            frmMain.QFormaPagocaja.Value       := StrToInt(frmMain.edcaja.Caption);
            frmMain.QFormaPagousu_codigo.Value := dm.Usuario;
            frmMain.QFormaPagofecha.Value      := Date;
            frmMain.QFormaPagoticket.Value     := frmMain.QTicketticket.Value;
            frmMain.QFormaPagoforma.Value      := 'DEV';
            if frmMain.QTickettotal.Value <= (dm.Query1.FieldByName('dev_total').AsFloat - dm.Query1.FieldByName('dev_montousado').AsFloat) then
            frmMain.QFormaPagopagado.Value     :=  frmMain.QTickettotal.Value else
            frmMain.QFormaPagopagado.Value     := dm.Query1.FieldByName('dev_total').AsFloat-
                                                  dm.Query1.FieldByName('dev_montousado').AsFloat;
            frmMain.QFormaPagodevuelta.Value   := 0;
            frmMain.QFormaPagoempresa.Value    := frmMain.empresa;
            frmMain.QFormaPagodocumento.Value  := Trim(ednumero.Text);
            frmMain.QFormaPagocredito.Value    := 'False';
            frmMain.QFormaPago.Post;
            frmMain.QFormaPago.UpdateBatch;

            with Query1 do begin
            Close;
            SQL.Clear;
            SQL.Add('update devolucion');
            SQL.Add('set dev_montousado = (select isnull(sum(pagado),0) from formas_pago_ticket where empresa = '+IntToStr(frmMain.empresa)+' and documento = '+QuotedStr(ednumero.Text)+' AND FORMA ='+QuotedStr('DEV')+')');
            SQL.Add('where emp_codigo = :emp and suc_codigo = :suc and dev_numero = :dev ');
            Parameters.ParamByName('emp').DataType := ftInteger;
            Parameters.ParamByName('suc').DataType := ftInteger;
            Parameters.ParamByName('dev').DataType := ftInteger;
            Parameters.ParamByName('emp').Value := frmMain.empresa;
            Parameters.ParamByName('suc').Value := 1;
            Parameters.ParamByName('dev').Value := ednumero.Text;
            ExecSQL;
            end;
          end;
        end
      end;
    end;
    ednumero.Text := '';
    ednumero.SetFocus;
  end;
end;

procedure TfrmDevoluciones.bteliminarClick(Sender: TObject);
begin
  frmMain.QFormaPago.Close;
  if frmMain.forma_numeracion = 1 then
  begin
    frmMain.QFormaPago.SQL.Clear;
    frmMain.QFormaPago.SQL.Add('select caja, usu_codigo, fecha, ticket, forma, pagado,');
    frmMain.QFormaPago.SQL.Add('devuelta, empresa, credito, cliente, banco, documento');
    frmMain.QFormaPago.SQL.Add('from formas_pago_ticket');
    frmMain.QFormaPago.SQL.Add('where caja = :caj');
    frmMain.QFormaPago.SQL.Add('and ticket = :tik');
    frmMain.QFormaPago.SQL.Add('and fecha = convert(datetime, :fec, 105)');
    frmMain.QFormaPago.SQL.Add('and usu_codigo = :usu');
    frmMain.QFormaPago.Parameters.ParamByName('fec').DataType := ftDate;
    frmMain.QFormaPago.Parameters.ParamByName('fec').Value    := Date;
    frmMain.QFormaPago.Parameters.ParamByName('usu').Value    := dm.Usuario;
  end;

  frmMain.QFormaPago.Parameters.ParamByName('caj').Value    := StrToInt(Trim(frmMain.edcaja.Caption));
  frmMain.QFormaPago.Parameters.ParamByName('tik').Value    := frmMain.QTicketticket.Value;
  frmMain.QFormaPago.Open;

  frmMain.QFormaPago.Delete;
  frmMain.QFormaPago.UpdateBatch;

  if NoDevolucion > 0 then begin
  with Query1 do begin
            Close;
            SQL.Clear;
            SQL.Add('update devolucion');
            SQL.Add('set dev_montousado = 0');
            SQL.Add('where emp_codigo = :emp and suc_codigo = :suc and dev_numero = :dev');
            Parameters.ParamByName('emp').DataType := ftInteger;
            Parameters.ParamByName('suc').DataType := ftInteger;
            Parameters.ParamByName('dev').DataType := ftInteger;
            Parameters.ParamByName('emp').Value := frmMain.empresa;
            Parameters.ParamByName('suc').Value := 1;
            Parameters.ParamByName('dev').Value := NoDevolucion;
            ExecSQL;
  end;
  with Query1 do begin
            Close;
            SQL.Clear;
            SQL.Add('delete FORMAS_PAGO_TICKET');
            SQL.Add('where empresa = :emp and caja = :caja and usu_codigo = :cajero and fecha = :fecha and ticket = :ticket');
            Parameters.ParamByName('emp').DataType := ftInteger;
            Parameters.ParamByName('caja').DataType := ftInteger;
            Parameters.ParamByName('cajero').DataType := ftInteger;
            Parameters.ParamByName('fecha').DataType := ftDate;
            Parameters.ParamByName('ticket').DataType := ftInteger;
            Parameters.ParamByName('emp').Value  := frmMain.empresa;
            Parameters.ParamByName('caja').Value := frmMain.caja;
            Parameters.ParamByName('cajero').Value := frmMain.Cajero;
            Parameters.ParamByName('fecha').Value := frmMain.QTicketfecha.Value;
            Parameters.ParamByName('ticket').Value := frmMain.QTicketticket.Value;
            ExecSQL;
  end;
  end;

  ednumero.SetFocus;
  if vl_forma = 'Efectivo' then
  frmEfectivo.Facturo := 0;
  if vl_forma = 'Tarjeta' then
  frmTarjeta.Facturo := 0;
  if vl_forma = 'Cheque' then
  frmCheque.Facturo := 0;


end;

procedure TfrmDevoluciones.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_escape then btsalirClick(self);
  if key = vk_f1     then bteliminarClick(self);
end;

procedure TfrmDevoluciones.DBGrid1ColEnter(Sender: TObject);
begin
  ednumero.SetFocus;
end;

procedure TfrmDevoluciones.FormShow(Sender: TObject);
begin
if DBGrid1.DataSource.DataSet.RecordCount > 0 then
NoDevolucion := DBGrid1.DataSource.DataSet.fieldbyname('documento').AsInteger;
end;

end.
