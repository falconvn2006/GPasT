unit BAR41;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, Grids, DBGrids, ExtCtrls, StdCtrls;

type
  TfrmCombinado = class(TForm)
    btclose: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    btaceptar: TSpeedButton;
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    btcash: TSpeedButton;
    bttarjeta: TSpeedButton;
    lbtotal: TStaticText;
    lbdevuelta: TStaticText;
    btresta: TSpeedButton;
    lbmonto: TStaticText;
    btcheque: TSpeedButton;
    btnota: TSpeedButton;
    btbono: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure btcloseClick(Sender: TObject);
    procedure btaceptarClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure btcashClick(Sender: TObject);
    procedure bttarjetaClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btrestaClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btchequeClick(Sender: TObject);
    procedure btbonoClick(Sender: TObject);
    procedure btnotaClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Total, Monto, DEvuelta: Double;
    Facturo : integer;
  end;

var
  frmCombinado: TfrmCombinado;

implementation

uses BAR00, BAR33, BAR16, BAR04, BAR30, BAR01, DB, BAR42, BAR43, BAR46;

{$R *.dfm}

procedure TfrmCombinado.FormCreate(Sender: TObject);
begin
  btclose.Caption   := 'F1'+#13+'SALIR';
  btcash.Caption    := 'F4'+#13+'CASH';
  bttarjeta.Caption := 'F5'+#13+'TARJETA';
  btaceptar.Caption := 'F10'+#13+'ACEPTAR';
end;

procedure TfrmCombinado.btcloseClick(Sender: TObject);
begin
  if StrToFloat(format('%10.2F',[Total])) <= StrToFloat(format('%10.2F',[Monto])) then
  begin
    Facturo := 0;
    Close;
  end
  else
  begin
    MessageDlg('DEBE COMPLETAR EL PAGO DE LA CUENTA',mtError,[mbok],0);
    DBGrid1.SetFocus;
  end;
end;

procedure TfrmCombinado.btaceptarClick(Sender: TObject);
begin
  if StrToFloat(format('%10.2F',[Total])) <= StrToFloat(format('%10.2F',[Monto])) then
  begin
    Facturo := 1;
    Close;
  end
  else
  begin
    MessageDlg('DEBE COMPLETAR EL PAGO DE LA CUENTA',mtError,[mbok],0);
    DBGrid1.SetFocus;
  end;
end;

procedure TfrmCombinado.SpeedButton1Click(Sender: TObject);
begin
  frmPos.QForma.DisableControls;
  if not frmPos.QForma.Bof then
    frmPos.QForma.Prior;
  frmPos.QForma.EnableControls;
end;

procedure TfrmCombinado.SpeedButton2Click(Sender: TObject);
begin
  frmPos.QForma.DisableControls;
  if not frmPos.QForma.Eof then
    frmPos.QForma.Next;
  frmPos.QForma.EnableControls;
end;

procedure TfrmCombinado.btcashClick(Sender: TObject);
begin
  Application.CreateForm(tfrmCash, frmCash);
  frmCash.pagoCombinado := true;
  frmCash.Total := Total - Monto;
  frmCash.Monto := 0;
  frmCash.Devuelta := frmCash.Total - frmCash.Monto;
  frmCash.facturando := false;
  frmCash.lbdevuelta.Caption := 'PENDIENTE COBRAR'+#13+format('%n',[frmCash.Devuelta]);
  frmCash.ShowModal;
  //Insertando Forma de Pago
  if frmCash.Facturo = 1 then
  begin
      frmPos.QDetalle.DisableControls;
      frmPos.QDetalle.First;
      while not frmPos.QDetalle.Eof do
      begin
        frmPos.QDetalle.Edit;
        frmPos.QDetalleCajeroID.Value := frmMain.Usuario;
        frmPos.QDetalle.Post;
        frmPos.QDetalle.Next;
      end;
      frmPos.QDetalle.First;
      frmPos.QDetalle.EnableControls;
      frmPos.QDetalle.UpdateBatch;

    frmPOS.combinado := true;
    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select ISNULL(max(DetalleID),0) as maximo from RestBar_Factura_Forma_Pago');
    dm.Query1.SQL.Add('where cajeroid = :usu and facturaid = :fac');
    dm.Query1.SQL.Add('and cajaid = :caj');
    dm.Query1.Parameters.ParamByName('usu').Value := frmMain.Usuario; //frmPos.QFacturaCajeroID.Value;
    dm.Query1.Parameters.ParamByName('fac').Value := frmPos.QFacturaFacturaID.Value;
    dm.Query1.Parameters.ParamByName('caj').Value := frmPos.QFacturaCajaID.Value;
    dm.Query1.Open;
    dm.Query1.Open;

    frmPos.QForma.Insert;
    frmPos.QFormaCajeroID.Value  := frmMain.Usuario; //frmPos.QFacturaCajeroID.Value;
    frmPos.QFormaFacturaID.Value := frmPos.QFacturaFacturaID.Value;
    frmPos.QFormaCajaID.Value    := frmPos.QFacturaCajaID.Value;
    frmPos.QFormaDetalleID.Value := dm.Query1.FieldByName('maximo').AsInteger + 1;
    frmPos.QFormaMonto.Value     := frmCash.Monto;
    frmPos.QFormaDevuelta.Value  := frmCash.Devuelta;
    frmPos.QFormaForma.Value     := 'Efectivo';
    frmPos.QForma.Post;
    frmPos.QForma.UpdateBatch;

  {  frmPos.QFactura.Edit;
    frmPos.QFacturaConbinado.Value := true;
    frmPos.QFacturaPagado.Value := frmPos.QFacturaPagado.Value + frmCash.Monto;
    frmPos.QFactura.Post;
    frmPos.QFactura.UpdateBatch;
   }
    Monto := Monto + frmCash.Monto; //20171012 frmPos.QFacturaPagado.Value;
    lbmonto.Caption := 'MONTO PAGADO'+#13+format('%n',[Monto]);

    Devuelta := Monto - Total;
    if Total > Monto then
    begin
      lbdevuelta.Color   := clLime;
      lbdevuelta.Caption := 'PENDIENTE COBRAR'+#13+format('%n',[Devuelta]);
    end
    else
    begin
      lbdevuelta.Color   := clRed;
      lbdevuelta.Caption := 'MONTO A DEVOLVER'+#13+format('%n',[Devuelta]);
    end;
  end;
  frmCash.Release;
end;

procedure TfrmCombinado.bttarjetaClick(Sender: TObject);
begin
  Application.CreateForm(tfrmTarjeta, frmTarjeta);
  frmTarjeta.edmonto.visible := true;
  frmTarjeta.StaticText3.visible := true;
  frmTarjeta.lbtotal.visible := true;
  frmTarjeta.edmonto.Enabled := true;

  frmTarjeta.total := Total-Monto;
  frmTarjeta.lbtotal.Caption := 'TOTAL PENDIENTE'+#13+format('%n',[Total-Monto]);
  frmTarjeta.ShowModal;
  //Insertando Forma de Pago
  if frmTarjeta.Acepto = 1 then
  begin
      frmPos.QDetalle.DisableControls;
      frmPos.QDetalle.First;
      while not frmPos.QDetalle.Eof do
      begin
        frmPos.QDetalle.Edit;
        frmPos.QDetalleCajeroID.Value := frmMain.Usuario;
        frmPos.QDetalle.Post;
        frmPos.QDetalle.Next;
      end;
      frmPos.QDetalle.First;
      frmPos.QDetalle.EnableControls;
      frmPos.QDetalle.UpdateBatch;

    frmPOS.combinado := true;
    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select ISNULL(max(DetalleID),0) as maximo from RestBar_Factura_Forma_Pago');
    dm.Query1.SQL.Add('where cajeroid = :usu and facturaid = :fac');
    dm.Query1.SQL.Add('and cajaid = :caj');
    dm.Query1.Parameters.ParamByName('usu').Value := frmMain.Usuario; //frmPos.QFacturaCajeroID.Value;
    dm.Query1.Parameters.ParamByName('fac').Value := frmPos.QFacturaFacturaID.Value;
    dm.Query1.Parameters.ParamByName('caj').Value := frmPos.QFacturaCajaID.Value;
    dm.Query1.Open;

    frmPos.QForma.Insert;
    frmPos.QFormaCajeroID.Value  := frmMain.Usuario; //frmPos.QFacturaCajeroID.Value;
    frmPos.QFormaFacturaID.Value := frmPos.QFacturaFacturaID.Value;
    frmPos.QFormaCajaID.Value    := frmPos.QFacturaCajaID.Value;
    frmPos.QFormaDetalleID.Value := dm.Query1.FieldByName('maximo').AsInteger + 1;
    frmPos.QFormaMonto.Value     := strtofloat(frmTarjeta.edmonto.Text);
    frmPos.QFormaForma.Value     := 'Tarjeta';
    frmPos.QFormaTipo_Tarjeta.Value   := frmTarjeta.ComboBox1.Text;
    frmPos.QFormaAutorizacion.Value   := frmTarjeta.edautorizacion.Text;
    frmPos.QFormaNumero_Tarjeta.Value := frmTarjeta.edtarjeta.Text;
    frmPos.QFormaBanco.Value          := frmTarjeta.DBLookupComboBox1.Text;
    frmPos.QForma.Post;
    frmPos.QForma.UpdateBatch;

   { frmPos.QFactura.Edit;
    frmPos.QFacturaConbinado.Value  := true;
    frmPos.QFacturaPagado.Value     := frmPos.QFacturaPagado.Value + strtofloat(frmTarjeta.edmonto.Text);
    frmPos.QFactura.Post;
    }
    Monto := Monto + strtofloat(frmTarjeta.edmonto.Text); //frmPos.QFacturaPagado.Value;
    lbmonto.Caption := 'MONTO PAGADO'+#13+format('%n',[Monto]);

    Devuelta := Monto - Total;
    if Total > Monto then
    begin
      lbdevuelta.Color   := clLime;
      lbdevuelta.Caption := 'PENDIENTE COBRAR'+#13+format('%n',[Devuelta]);
    end
    else
    begin
      lbdevuelta.Color   := clRed;
      lbdevuelta.Caption := 'MONTO A DEVOLVER'+#13+format('%n',[Devuelta]);
    end;
  end;
  frmTarjeta.edmonto.visible      := false;
  frmTarjeta.StaticText3.visible  := false;
  frmTarjeta.lbtotal.visible      := false;
  frmTarjeta.edmonto.Enabled      := false;
  frmTarjeta.Release;
end;

procedure TfrmCombinado.FormActivate(Sender: TObject);
begin
  lbtotal.Caption := 'MONTO A PAGAR'+#13+format('%n',[Total]);
  lbmonto.Caption := 'MONTO PAGADO'+#13+format('%n',[Monto]);
end;

procedure TfrmCombinado.btrestaClick(Sender: TObject);
begin
  if not frmPOS.QForma.Eof then
  begin
    Monto := Monto - frmPOS.QFormaMonto.Value;

    if frmPOS.QFormaForma.AsString = 'Nota CR' then
    begin
      dm.Query1.Close;
      dm.Query1.SQL.Clear;
      dm.Query1.SQL.Add('update Devolucion set Estatus = :st where Devolucionid = :dev');
      dm.Query1.Parameters.ParamByName('st').Value  := 'EMI';
      dm.Query1.Parameters.ParamByName('dev').Value := strtoint(frmPOS.QFormaNumero_Tarjeta.AsString);
      dm.Query1.ExecSQL;
    end;

    frmPOS.QFactura.Edit;
    frmPOS.QFacturaPagado.Value := frmPOS.QFacturaPagado.Value - frmPOS.QFormaMonto.Value;
    frmPOS.QFactura.Post;


    frmPOS.QForma.Delete;
    frmPOS.QForma.UpdateBatch;



    Devuelta := Monto - Total;
    if Total > Monto then
    begin
      lbdevuelta.Color   := clLime;
      lbdevuelta.Caption := 'PENDIENTE COBRAR'+#13+format('%n',[Devuelta]);
    end
    else
    begin
      lbdevuelta.Color   := clRed;
      lbdevuelta.Caption := 'MONTO A DEVOLVER'+#13+format('%n',[Devuelta]);
    end;
  end;
end;

procedure TfrmCombinado.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_f1 then btcloseClick(Self);
  if key = vk_f10 then btaceptarClick(Self);
  if key = vk_f4 then btcashClick(Self);
  if key = vk_f5 then bttarjetaClick(Self);
end;

procedure TfrmCombinado.btchequeClick(Sender: TObject);
begin
  Application.CreateForm(tfrmCheque, frmCheque);
  frmCheque.total := Total-Monto;
  frmCheque.lbtotal.Caption := 'TOTAL PENDIENTE'+#13+format('%n',[Total-Monto]);
  frmCheque.edmonto.Enabled := true;
  frmCheque.ShowModal;
  //Insertando Forma de Pago
  if frmCheque.Acepto = 1 then
  begin
    frmPOS.combinado := true;
    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select ISNULL(max(DetalleID),0) as maximo from RestBar_Factura_Forma_Pago');
    dm.Query1.SQL.Add('where cajeroid = :usu and facturaid = :fac');
    dm.Query1.SQL.Add('and cajaid = :caj');
    dm.Query1.Parameters.ParamByName('usu').Value := frmMain.Usuario; //frmPos.QFacturaCajeroID.Value;
    dm.Query1.Parameters.ParamByName('fac').Value := frmPos.QFacturaFacturaID.Value;
    dm.Query1.Parameters.ParamByName('caj').Value := frmPos.QFacturaCajaID.Value;
    dm.Query1.Open;

    frmPos.QForma.Insert;
    frmPos.QFormaCajeroID.Value  := frmMain.Usuario; //frmPos.QFacturaCajeroID.Value;
    frmPos.QFormaFacturaID.Value := frmPos.QFacturaFacturaID.Value;
    frmPos.QFormaCajaID.Value    := frmPos.QFacturaCajaID.Value;
    frmPos.QFormaDetalleID.Value := dm.Query1.FieldByName('maximo').AsInteger + 1;
    frmPos.QFormaMonto.Value     := strtofloat(frmCheque.edmonto.Text);
    frmPos.QFormaForma.Value     := 'Cheque';
    frmPos.QFormaNumero_Tarjeta.Value := frmCheque.edcheque.Text;
    frmPos.QFormaBanco.Value          := frmCheque.DBLookupComboBox1.Text;
    frmPos.QForma.Post;
    frmPos.QForma.UpdateBatch;

    {frmPos.QFactura.Edit;
    frmPos.QFacturaConbinado.Value  := true;
    frmPos.QFacturaPagado.Value     := frmPos.QFacturaPagado.Value + strtofloat(frmCheque.edmonto.Text);
    frmPos.QFactura.Post;
     }

    Monto := Monto + strtofloat(frmCheque.edmonto.Text);
    lbmonto.Caption := 'MONTO PAGADO'+#13+format('%n',[Monto]);

    Devuelta := Monto - Total;
    if Total > Monto then
    begin
      lbdevuelta.Color   := clLime;
      lbdevuelta.Caption := 'PENDIENTE COBRAR'+#13+format('%n',[Devuelta]);
    end
    else
    begin
      lbdevuelta.Color   := clRed;
      lbdevuelta.Caption := 'MONTO A DEVOLVER'+#13+format('%n',[Devuelta]);
    end;
  end;
  frmCheque.Release;
end;

procedure TfrmCombinado.btbonoClick(Sender: TObject);
begin
  Application.CreateForm(tfrmBono, frmBono);
  frmBono.total := Total-Monto;
  frmBono.lbtotal.Caption := 'TOTAL PENDIENTE'+#13+format('%n',[Total-Monto]);
  frmBono.edmonto.Enabled := true;
  frmBono.ShowModal;
  //Insertando Forma de Pago
  if frmBono.Acepto = 1 then
  begin
    frmPOS.combinado := true;
    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select ISNULL(max(DetalleID),0) as maximo from RestBar_Factura_Forma_Pago');
    dm.Query1.SQL.Add('where cajeroid = :usu and facturaid = :fac');
    dm.Query1.SQL.Add('and cajaid = :caj');
    dm.Query1.Parameters.ParamByName('usu').Value := frmMain.Usuario; //frmPos.QFacturaCajeroID.Value;
    dm.Query1.Parameters.ParamByName('fac').Value := frmPos.QFacturaFacturaID.Value;
    dm.Query1.Parameters.ParamByName('caj').Value := frmPos.QFacturaCajaID.Value;
    dm.Query1.Open;

    frmPos.QForma.Insert;
    frmPos.QFormaCajeroID.Value  := frmMain.Usuario; //frmPos.QFacturaCajeroID.Value;
    frmPos.QFormaFacturaID.Value := frmPos.QFacturaFacturaID.Value;
    frmPos.QFormaCajaID.Value    := frmPos.QFacturaCajaID.Value;
    frmPos.QFormaDetalleID.Value := dm.Query1.FieldByName('maximo').AsInteger + 1;
    frmPos.QFormaMonto.Value     := strtofloat(frmBono.edmonto.Text);
    frmPos.QFormaForma.Value     := 'Bono';
    frmPos.QFormaNumero_Tarjeta.Value := frmBono.edbono.Text;
    frmPos.QForma.Post;
    frmPos.QForma.UpdateBatch;

    frmPos.QFactura.Edit;
    frmPos.QFacturaConbinado.Value  := true;
    frmPos.QFacturaPagado.Value     := frmPos.QFacturaPagado.Value + strtofloat(frmBono.edmonto.Text);
    frmPos.QFactura.Post;

    Monto := strtofloat(frmBono.edmonto.Text);
    lbmonto.Caption := 'MONTO PAGADO'+#13+format('%n',[Monto]);

    Devuelta := Monto - Total;
    if Total > Monto then
    begin
      lbdevuelta.Color   := clLime;
      lbdevuelta.Caption := 'PENDIENTE COBRAR'+#13+format('%n',[Devuelta]);
    end
    else
    begin
      lbdevuelta.Color   := clRed;
      lbdevuelta.Caption := 'MONTO A DEVOLVER'+#13+format('%n',[Devuelta]);
    end;
  end;
  frmBono.Release;
end;

procedure TfrmCombinado.btnotaClick(Sender: TObject);
begin
  Application.CreateForm(tfrmBuscaNC, frmBuscaNC);
  frmBuscaNC.QDevolucion.Open;
  frmBuscaNC.ShowModal;
  //Insertando Forma de Pago
  if frmBuscaNC.Acepto = 1 then
  begin
    if MessageDlg('ESTA SEGURO QUE DESEA INCLUIR ESTA DEVOLUCION?', mtConfirmation, [mbyes,mbno],0) = mryes then
    begin
      if format('%10.2F',[frmBuscaNC.QDevolucionTotal.Value]) > format('%10.2F',[Total - Monto]) then
        MessageDlg('EL MONTO DE LA DEVOLUCION ES MAYOR AL TOTAL DE LA FACTURA', mtError, [mbok],0)
      else
      begin
        frmPOS.combinado := true;
        dm.Query1.Close;
        dm.Query1.SQL.Clear;
        dm.Query1.SQL.Add('select max(DetalleID) as maximo from RestBar_Factura_Forma_Pago');
        dm.Query1.SQL.Add('where cajeroid = :usu and facturaid = :fac');
        dm.Query1.SQL.Add('and cajaid = :caj');
        dm.Query1.Parameters.ParamByName('usu').Value := frmMain.Usuario; //frmPos.QFacturaCajeroID.Value;
        dm.Query1.Parameters.ParamByName('fac').Value := frmPos.QFacturaFacturaID.Value;
        dm.Query1.Parameters.ParamByName('caj').Value := frmPos.QFacturaCajaID.Value;
        dm.Query1.Open;

        frmPos.QForma.Insert;
        frmPos.QFormaCajeroID.Value  := frmMain.Usuario; //frmPos.QFacturaCajeroID.Value;
        frmPos.QFormaFacturaID.Value := frmPos.QFacturaFacturaID.Value;
        frmPos.QFormaCajaID.Value    := frmPos.QFacturaCajaID.Value;
        frmPos.QFormaDetalleID.Value := dm.Query1.FieldByName('maximo').AsInteger + 1;
        frmPos.QFormaMonto.Value     := frmBuscaNC.QDevolucionTotal.Value;
        frmPos.QFormaForma.Value     := 'Nota CR';
        frmPos.QFormaNumero_Tarjeta.Value := frmBuscaNC.QDevolucionDevolucionID.AsString;
        frmPos.QForma.Post;
        frmPos.QForma.UpdateBatch;

        frmPos.QFactura.Edit;
        frmPos.QFacturaConbinado.Value  := true;
        frmPos.QFacturaPagado.Value     := frmPos.QFacturaPagado.Value + frmBuscaNC.QDevolucionTotal.Value;
        frmPos.QFactura.Post;

        dm.Query1.Close;
        dm.Query1.SQL.Clear;
        dm.Query1.SQL.Add('update Devolucion set Estatus = :st where Devolucionid = :dev');
        dm.Query1.Parameters.ParamByName('st').Value  := 'FAC';
        dm.Query1.Parameters.ParamByName('dev').Value := frmBuscaNC.QDevolucionDevolucionID.Value;
        dm.Query1.ExecSQL;

        Monto := frmBuscaNC.QDevolucionTotal.Value;
        lbmonto.Caption := 'MONTO PAGADO'+#13+format('%n',[Monto]);

        Devuelta := Monto - Total;
        if Total > Monto then
        begin
          lbdevuelta.Color   := clLime;
          lbdevuelta.Caption := 'PENDIENTE COBRAR'+#13+format('%n',[Devuelta]);
        end
        else
        begin
          lbdevuelta.Color   := clRed;
          lbdevuelta.Caption := 'MONTO A DEVOLVER'+#13+format('%n',[Devuelta]);
        end;
      end;
    end;
  end;
  frmBuscaNC.Release;
end;

end.
