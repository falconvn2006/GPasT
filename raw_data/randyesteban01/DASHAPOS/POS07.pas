unit POS07;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ECRti_Framework_TLB, uJSON, Mask,
  ToolEdit, CurrEdit;

type
  TfrmCombinado = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    btcalc: TSpeedButton;
    lbtotal: TStaticText;
    btimprimir: TBitBtn;
    btsalir: TBitBtn;
    Label3: TLabel;
    SpeedButton1: TSpeedButton;
    Label4: TLabel;
    SpeedButton2: TSpeedButton;
    Label5: TLabel;
    lbitbis: TStaticText;
    lbTarjeta: TStaticText;
    Label6: TLabel;
    SpeedButton3: TSpeedButton;
    Label7: TLabel;
    SpeedButton4: TSpeedButton;
    Label8: TLabel;
    lbpendiente: TStaticText;
    Label9: TLabel;
    SpeedButton5: TSpeedButton;
    btnPOS: TBitBtn;
    cbbCantCuotas: TComboBox;
    lbCantCuotas: TLabel;
    rgTipoVenta: TRadioGroup;
    edrecibido: TCurrencyEdit;
    edtarjeta: TCurrencyEdit;
    edcheque: TCurrencyEdit;
    edcredito: TCurrencyEdit;
    edBonoClub: TCurrencyEdit;
    edBonoOtro: TCurrencyEdit;
    procedure btsalirClick(Sender: TObject);
    procedure btcalcClick(Sender: TObject);
    procedure btimprimirClick(Sender: TObject);
    procedure edrecibidoKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtarjetaKeyPress(Sender: TObject; var Key: Char);
    procedure edchequeKeyPress(Sender: TObject; var Key: Char);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure edBonoClubKeyPress(Sender: TObject; var Key: Char);
    procedure edBonoOtroKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure edCreditoKeyPress(Sender: TObject; var Key: Char);
    procedure SpeedButton5Click(Sender: TObject);
    procedure btnPOSClick(Sender: TObject);
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
  public
    Facturo, invoiceId : integer;
    Total, Pagado, Pendiente : Double;
  end;

var
  frmCombinado: TfrmCombinado;

implementation

uses POS02, POS00, POS14, POS01, Math;

{$R *.dfm}

procedure TfrmCombinado.btsalirClick(Sender: TObject);
begin
  Facturo := 0;
  Close;
end;

procedure TfrmCombinado.btcalcClick(Sender: TObject);
begin
  Application.CreateForm(tfrmCalc, frmCalc);
  frmCalc.ShowModal;
  edrecibido.Value := StrToFloat(frmCalc.lbTotal.Caption);
  frmCalc.Release;
end;

procedure TfrmCombinado.btimprimirClick(Sender: TObject);
begin
  {if Trim(edtarjeta.Text)  = '' then edtarjeta.Text  := '0';
  if Trim(edcheque.Text)   = '' then edcheque.Text   := '0';
  if Trim(edrecibido.Text) = '' then edrecibido.Text := '0';
  if Trim(edBonoClub.Text) = '' then edBonoClub.Text := '0';
  if Trim(edBonoOtro.Text) = '' then edBonoOtro.Text := '0';
  if Trim(edCredito.Text)  = '' then edCredito.Text  := '0';
  }
  Pagado := edtarjeta.Value + edcheque.Value + edrecibido.Value + edBonoClub.Value + edBonoOtro.Value + edCredito.Value;




  lbpendiente.Caption := format('%n',[Total - Pagado]); 

  if Total > Pagado then
    lbpendiente.Caption := format('%n',[Total - Pagado])
  else
    lbpendiente.Caption := '0.00';

  {if StrToFLoat(Format('%10.2F',[Pagado]))  > StrToFLoat(Format('%10.2F',[Total])) then
  begin
    MessageDlg('USTED ESTA PAGANDO MAS QUE EL TOTAL, PRESIONE [ENTER]',mtError,[mbok],0);
    edrecibido.SetFocus;
  end
  else }
  if edtarjeta.Value > Total then
  begin
    MessageDlg('NO PUEDE PAGAR ESTE MONTO CON TARJETA, PRESIONE [ENTER]',mtError,[mbok],0);
    edtarjeta.Value := 0;
    edtarjeta.SetFocus;
  end
  else if edCredito.Value > Total then
  begin
    MessageDlg('NO PUEDE FACTURAR ESTE MONTO A CREDITO, PRESIONE [ENTER]',mtError,[mbok],0);
    edCredito.Value := 0;
    edCredito.SetFocus;
  end
  else if Pagado < Total then
  begin
    MessageDlg('USTED ESTA PAGANDO MENOS QUE EL TOTAL, PRESIONE [ENTER]',mtError,[mbok],0);
    edrecibido.SetFocus;
  end
  else
  begin
    Facturo := 1;
    Close;
  end;
end;

procedure TfrmCombinado.edrecibidoKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    btimprimirClick(Self);
    key := #0;
  end;
end;

procedure TfrmCombinado.FormCreate(Sender: TObject);
begin
  Facturo := 0;

  //Buscar Datos de Veriphone Cardnet
WITH DM.Query1 do begin
  Close;
  SQL.Clear;
  SQL.Add('SELECT IP, PORTCAJA, PORTPOS, TIMEOUT, CAJA FROM VerifoneEnCaja');
  SQL.Add('WHERE CAJA ='+QuotedStr(DM.GetIPAddress));
  Open;
  IF not (IsEmpty) THEN
  BEGIN
  core := TCore.Create(Self);

  btnPOS.Visible  := True;
  frmCombinado.Width      := 581;
  rgTipoVenta.Visible   := btnPOS.Visible;
  lbCantCuotas.Visible  := btnPOS.Visible;
  cbbCantCuotas.Visible := btnPOS.Visible;


  frmMain.vl_respverifone := '';
  frmMain.vl_tarjeta := '';

  ipLocal     := DM.Query1.FieldByName('CAJA').Text;
  portLocal   := DM.Query1.FieldByName('PORTCAJA').Value;
  ipRemote    := DM.Query1.FieldByName('IP').Text;
  portRemote  := DM.Query1.FieldByName('PORTPOS').Value;
  timeout     := DM.Query1.FieldByName('TIMEOUT').Value;

  result := core.SetTimeOut(timeOut);
  result := core.SetLocalEndPoint(ipLocal, portLocal);
  result := core.SetRemoteEndPoint(ipRemote, portRemote);
  frmMain.vp_verifone := False;

  end
  else
  begin
  btnPOS.Visible := False;
  frmCombinado.Width     := 432;
  rgTipoVenta.Visible  := btnPOS.Visible;
  lbCantCuotas.Visible := btnPOS.Visible;
  cbbCantCuotas.Visible:= btnPOS.Visible;

  frmMain.vl_respverifone := '';
end;
end;
end;

procedure TfrmCombinado.SpeedButton1Click(Sender: TObject);
begin
  Application.CreateForm(tfrmCalc, frmCalc);
  frmCalc.ShowModal;
  edtarjeta.Text := IntToStr(Trunc(StrToFloat(frmCalc.lbTotal.Caption)));
  frmCalc.Release;
end;

procedure TfrmCombinado.SpeedButton2Click(Sender: TObject);
begin
  Application.CreateForm(tfrmCalc, frmCalc);
  frmCalc.ShowModal;
  edcheque.Text := IntToStr(Trunc(StrToFloat(frmCalc.lbTotal.Caption)));
  frmCalc.Release;
end;

procedure TfrmCombinado.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then
  begin
    btsalirClick(Self);
    key := #0;
  end;
end;

procedure TfrmCombinado.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_f1 then
  begin
   { if Trim(edtarjeta.Text)  = '' then edtarjeta.Text  := '0';
    if Trim(edcheque.Text)   = '' then edcheque.Text   := '0';
    if Trim(edrecibido.Text) = '' then edrecibido.Text := '0';
    if Trim(edBonoClub.Text) = '' then edBonoClub.Text := '0';
    if Trim(edBonoOtro.Text) = '' then edBonoOtro.Text := '0';
    if Trim(edCredito.Text) = '' then edCredito.Text := '0';
      }
  Pagado := edtarjeta.Value + edcheque.Value + edrecibido.Value + edBonoClub.Value + edBonoOtro.Value + edCredito.Value;

    if Total > Pagado then
      lbpendiente.Caption := format('%n',[Total - Pagado])
    else
      lbpendiente.Caption := '0.00';
    edrecibido.SetFocus;
  end;

  if key = vk_f2 then
  begin
{    if Trim(edtarjeta.Text)  = '' then edtarjeta.Text  := '0';
    if Trim(edcheque.Text)   = '' then edcheque.Text   := '0';
    if Trim(edrecibido.Text) = '' then edrecibido.Text := '0';
    if Trim(edBonoClub.Text) = '' then edBonoClub.Text := '0';
    if Trim(edBonoOtro.Text) = '' then edBonoOtro.Text := '0';
    if Trim(edCredito.Text) = '' then edCredito.Text := '0';
  }
  Pagado := edtarjeta.Value + edcheque.Value + edrecibido.Value + edBonoClub.Value + edBonoOtro.Value + edCredito.Value;

    if Total > Pagado then
      lbpendiente.Caption := format('%n',[Total - Pagado])
    else
      lbpendiente.Caption := '0.00';
    edtarjeta.SetFocus;
  end;
  if key = vk_f3 then
  begin
  {  if Trim(edtarjeta.Text)  = '' then edtarjeta.Text  := '0';
    if Trim(edcheque.Text)   = '' then edcheque.Text   := '0';
    if Trim(edrecibido.Text) = '' then edrecibido.Text := '0';
    if Trim(edBonoClub.Text) = '' then edBonoClub.Text := '0';
    if Trim(edBonoOtro.Text) = '' then edBonoOtro.Text := '0';
    if Trim(edCredito.Text) = '' then edCredito.Text := '0';
}
  Pagado := edtarjeta.Value + edcheque.Value + edrecibido.Value + edBonoClub.Value + edBonoOtro.Value + edCredito.Value;

    if Total > Pagado then
      lbpendiente.Caption := format('%n',[Total - Pagado])
    else
      lbpendiente.Caption := '0.00';
    edcheque.SetFocus;
  end;
  if key = vk_f4 then
  begin
    Application.CreateForm(tfrmClientes, frmClientes);
    frmClientes.total := frmMain.QTickettotal.value;
    if frmMain.SeleccionTipo = 'CRE' then
    begin
      frmClientes.ActiveControl := frmClientes.DBGrid1;
      frmClientes.QClientes.Close;
      frmClientes.QClientes.SQL.Clear;
      frmClientes.QClientes.SQL.Add('select');
      frmClientes.QClientes.SQL.Add('distinct emp_codigo, cli_codigo, cli_nombre, cli_rnc, cli_cedula, cli_direccion,cli_localidad,');
      frmClientes.QClientes.SQL.Add('isnull(cli_limite,0) as cli_limite, cli_balance, emp_numero, cli_telefono, tfa_codigo,');
      frmClientes.QClientes.SQL.Add('cli_facturarbce, cli_facturarvencida, Aumento');
      frmClientes.QClientes.SQL.Add('from clientes');
      frmClientes.QClientes.SQL.Add('where cli_codigo = '+IntToStr(frmMain.SeleccionCliente));
      frmClientes.QClientes.SQL.Add('and emp_codigo = '+IntToStr(frmMain.SeleccionEmpresa));
      frmClientes.QClientes.SQL.Add('order by cli_nombre');
      frmClientes.QClientes.Open;
    end;
    frmClientes.ShowModal;
    frmMain.credito := 'False';
    if frmClientes.Seleccion = 1 then
    begin
      frmMain.empresa := frmClientes.QClientesemp_codigo.Value;
      frmMain.cliente := frmClientes.QClientescli_codigo.Value;
      frmMain.NombreCliente := frmClientes.QClientescli_nombre.Value;
      if Trim(frmClientes.qclientescli_rnc.Value) <> '' then
        frmMain.rncCliente  := frmClientes.qclientescli_rnc.Value
      else
        frmMain.rncCliente  := frmClientes.QClientescli_cedula.Value;

      frmMain.credito := 'True'
    end;
 {
    if Trim(edtarjeta.Text)  = '' then edtarjeta.Text  := '0';
    if Trim(edcheque.Text)   = '' then edcheque.Text   := '0';
    if Trim(edrecibido.Text) = '' then edrecibido.Text := '0';
    if Trim(edBonoClub.Text) = '' then edBonoClub.Text := '0';
    if Trim(edBonoOtro.Text) = '' then edBonoOtro.Text := '0';
    if Trim(edCredito.Text)  = '' then edCredito.Text := '0';
}
  Pagado := edtarjeta.Value + edcheque.Value + edrecibido.Value + edBonoClub.Value + edBonoOtro.Value + edCredito.Value;


    if Total > Pagado then
      lbpendiente.Caption := format('%n',[Total - Pagado])
    else
      lbpendiente.Caption := '0.00';
    edCredito.SetFocus;
  end;
  if key = vk_f5 then
  begin
   { if Trim(edtarjeta.Text)  = '' then edtarjeta.Text  := '0';
    if Trim(edcheque.Text)   = '' then edcheque.Text   := '0';
    if Trim(edrecibido.Text) = '' then edrecibido.Text := '0';
    if Trim(edBonoClub.Text) = '' then edBonoClub.Text := '0';
    if Trim(edBonoOtro.Text) = '' then edBonoOtro.Text := '0';
    if Trim(edCredito.Text) = '' then edCredito.Text := '0';
}
  Pagado := edtarjeta.Value + edcheque.Value + edrecibido.Value + edBonoClub.Value + edBonoOtro.Value + edCredito.Value;

    if Total > Pagado then
      lbpendiente.Caption := format('%n',[Total - Pagado])
    else
      lbpendiente.Caption := '0.00';
    edBonoClub.SetFocus;
  end;
  if key = vk_f6 then
  begin
    {if Trim(edtarjeta.Text)  = '' then edtarjeta.Text  := '0';
    if Trim(edcheque.Text)   = '' then edcheque.Text   := '0';
    if Trim(edrecibido.Text) = '' then edrecibido.Text := '0';
    if Trim(edBonoClub.Text) = '' then edBonoClub.Text := '0';
    if Trim(edBonoOtro.Text) = '' then edBonoOtro.Text := '0';
    if Trim(edCredito.Text) = '' then edCredito.Text := '0';
}
  Pagado := edtarjeta.Value + edcheque.Value + edrecibido.Value + edBonoClub.Value + edBonoOtro.Value + edCredito.Value;

    if Total > Pagado then
      lbpendiente.Caption := format('%n',[Total - Pagado])
    else
      lbpendiente.Caption := '0.00';
    edBonoOtro.SetFocus;
  end;

end;

procedure TfrmCombinado.edtarjetaKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    if btnPOS.Visible = False then
    btimprimirClick(Self);
    if btnPOS.Visible = True then begin
    if MessageDlg('DESEA UTILIZAR EL VERIFONE AUTOMATICO PARA ESTA TRANSACCION?',mtConfirmation,[mbYes,mbNo],0)=mrYes THEN BEGIN
    btnPOSClick(Sender);
    end;
    end;
    key := #0;
  end;
end;

procedure TfrmCombinado.edchequeKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    btimprimirClick(Self);
    key := #0;
  end;
end;

procedure TfrmCombinado.SpeedButton3Click(Sender: TObject);
begin
  Application.CreateForm(tfrmCalc, frmCalc);
  frmCalc.ShowModal;
  edBonoClub.Text := IntToStr(Trunc(StrToFloat(frmCalc.lbTotal.Caption)));
  frmCalc.Release;
end;

procedure TfrmCombinado.SpeedButton4Click(Sender: TObject);
begin
  Application.CreateForm(tfrmCalc, frmCalc);
  frmCalc.ShowModal;
  edBonoOtro.Text := IntToStr(Trunc(StrToFloat(frmCalc.lbTotal.Caption)));
  frmCalc.Release;
end;

procedure TfrmCombinado.edBonoClubKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    btimprimirClick(Self);
    key := #0;
  end;
end;

procedure TfrmCombinado.edBonoOtroKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    btimprimirClick(Self);
    key := #0;
  end;
end;

procedure TfrmCombinado.FormActivate(Sender: TObject);
begin
  frmMain.DisplayTotal;
end;

procedure TfrmCombinado.edCreditoKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    btimprimirClick(Self);
    key := #0;
  end;
end;

procedure TfrmCombinado.SpeedButton5Click(Sender: TObject);
begin
  Application.CreateForm(tfrmCalc, frmCalc);
  frmCalc.ShowModal;
  edCredito.Text := IntToStr(Trunc(StrToFloat(frmCalc.lbTotal.Caption)));
  frmCalc.Release;
end;

procedure TfrmCombinado.btnPOSClick(Sender: TObject);
var
ResponseMemo : String;
amount, tax, otherTaxes, quantyOfPayments : Integer;
tamount, ttax :Currency;
a : myJSONItem;
begin
try
  if edtarjeta.Text = '' then
  lbTarjeta.Caption := format('%n',[Total - Pagado]);



  IF Pagado = 0 THEN BEGIN
   ShowMessage('DEBES INDICAR EL MONTO A PAGAR....');
   edtarjeta.SetFocus;
   Exit;
  end;
  btnPOS.Enabled := False;

  ResponseMemo := '';

  if rgTipoVenta.ItemIndex = 0 then
  quantyOfPayments := 0 else
  quantyOfPayments := StrToInt(cbbCantCuotas.Text);


  if ((Trim(edtarjeta.Text)<>'') and ((frmMain.QTicketitbis.Value) > 0)) then
  ttax :=  edtarjeta.Value*0.18 else
  ttax := 0;

  tax := StrToInt(DM.QuitarPuntosDecimal(ttax));

  tamount := edtarjeta.Value;

  amount := StrToInt(dm.QuitarPuntosDecimal(tamount));


  otherTaxes := 0;

  invoiceId := frmMain.QTicketticket.Value;

  result := core.Initialice();
  case rgTipoVenta.ItemIndex of
  0:response := core.ProcessNormalSale(amount, tax, otherTaxes, invoiceId);
  1:response := core.ProcessDeferredSale(amount, tax, otherTaxes, invoiceId, quantyOfPayments);
  end;

  case rgTipoVenta.ItemIndex of
  0:dm.GrabaLogCardNet(DM.QEmpresaemp_codigo.Value,1,dm.Usuario,invoiceId,response,'N','T',amount,tax);
  1:dm.GrabaLogCardNet(DM.QEmpresaemp_codigo.Value,1,dm.Usuario,invoiceId,response,'O','T',amount,tax);
  end;


  ResponseMemo := response;

  frmMain.vl_respverifone := ResponseMemo;


  if Length(ResponseMemo)< 180 then begin
  a := myJSONItem.Create;
  a.Code :=  ResponseMemo;
  ShowMessage('FAVOR REVISE LA CONEXION, FALLO LA TRANSACCION '+Char(13)+ResponseMemo);
  frmMain.vp_verifone := False;
  btnPOS.Enabled := True;
  edtarjeta.SetFocus;
  end
  else
  if Length(ResponseMemo)> 180 then begin
  a := myJSONItem.Create;
  a.Code :=  ResponseMemo;

  //edDescrip.Text := DM.Query1.FieldByName('CardNumber').Text + ' / '+
  //                  DM.Query1.FieldByName('AuthorizationNumber').Text;

  {edtarjeta.Text := copy(a['Card']['CardNumber'].getStr,Length(a['Card']['CardNumber'].getStr)-3,Length(a['Card']['CardNumber'].getStr)) + ' / '+
                    a['Transaction']['AuthorizationNumber'].getStr;
   }
  frmMain.vp_verifone := True;
  btimprimirClick(Sender);
  end
  else
  begin
  frmMain.vp_verifone := True;
  end;
except
    on E : Exception do
      ShowMessage(E.ClassName+' error raised, with message : '+E.Message);
end;

end;

end.
