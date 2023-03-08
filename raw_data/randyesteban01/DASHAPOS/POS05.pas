unit POS05;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ECRti_Framework_TLB, uJSON;

type
  TfrmTarjeta = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    edtarjeta: TEdit;
    btcalc: TSpeedButton;
    lbtotal: TStaticText;
    btimprimir: TBitBtn;
    btsalir: TBitBtn;
    Label3: TLabel;
    lbitbis: TStaticText;
    lbTarjeta: TStaticText;
    Label4: TLabel;
    SpeedButton1: TSpeedButton;
    edMonto: TEdit;
    btdevolucion: TBitBtn;
    Label5: TLabel;
    lbdevolucion: TStaticText;
    Label6: TLabel;
    lbsubtotal: TStaticText;
    btnPOS: TBitBtn;
    rgTipoVenta: TRadioGroup;
    lbCantCuotas: TLabel;
    cbbCantCuotas: TComboBox;
    procedure btsalirClick(Sender: TObject);
    procedure btcalcClick(Sender: TObject);
    procedure btimprimirClick(Sender: TObject);
    procedure edtarjetaKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edMontoKeyPress(Sender: TObject; var Key: Char);
    procedure btdevolucionClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);

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
    total, devolucion : double;
    VL_MONTO, VL_ITBIS, VL_OTROIMP : String;
  end;

var
  frmTarjeta: TfrmTarjeta;

implementation

uses POS02, POS22, POS00, POS01;

{$R *.dfm}

procedure TfrmTarjeta.btsalirClick(Sender: TObject);
begin
  Facturo := 0;
  Close;
end;

procedure TfrmTarjeta.btcalcClick(Sender: TObject);
begin
  Application.CreateForm(tfrmCalc, frmCalc);
  frmCalc.ShowModal;
  edtarjeta.Text := IntToStr(Trunc(StrToFloat(frmCalc.lbTotal.Caption)));
  frmCalc.Release;
end;

procedure TfrmTarjeta.btimprimirClick(Sender: TObject);
var
  MtoTarjeta:double;

begin
  if Trim(edMonto.Text) = '' then edMonto.Text := '0';

  MtoTarjeta := StrToFloat(format('%10.2F',[strtofloat(edMonto.Text)]));
 // caption := 'Tarjeta : ' +  MtoTarjeta
//  if StrToFloat(format('%10.2F',[strtofloat(edMonto.Text)])) <>
 // (StrToFloat(format('%10.2F',[total])) - StrToFloat(format('%10.2F',[devolucion]))) then

  if ( MtoTarjeta <> (total -  devolucion)) then
  begin
    MessageDlg('DEBE DIGITAR EL MONTO EXACTO ',mtError,[mbok],0);
    edMonto.SetFocus;
  end
  else
  begin
    Facturo := 1;
    Close;
  end;
end;

procedure TfrmTarjeta.edtarjetaKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    if Trim(edMonto.Text) = '' then
      edMonto.SetFocus
    else
    begin
      btimprimirClick(Self);
      key := #0;
    end;
  end;
end;

procedure TfrmTarjeta.FormCreate(Sender: TObject);
begin
  Facturo := 0;
  devolucion :=0;

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
  frmTarjeta.Width      := 615;
  rgTipoVenta.Visible   := btnPOS.Visible;
  lbCantCuotas.Visible  := btnPOS.Visible;
  cbbCantCuotas.Visible := btnPOS.Visible;
  edMonto.Text          := frmMain.QTickettotal.Text;


  frmMain.vl_respverifone := '';

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
  frmTarjeta.Width     := 475;
  rgTipoVenta.Visible  := btnPOS.Visible;
  lbCantCuotas.Visible := btnPOS.Visible;
  cbbCantCuotas.Visible:= btnPOS.Visible;

  frmMain.vl_respverifone := '';
  end;
end;
end;

procedure TfrmTarjeta.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then
  begin
    btsalirClick(Self);
    key := #0;
  end;
end;

procedure TfrmTarjeta.SpeedButton1Click(Sender: TObject);
begin
  Application.CreateForm(tfrmCalc, frmCalc);
  frmCalc.ShowModal;
  edMonto.Text := IntToStr(Trunc(StrToFloat(frmCalc.lbTotal.Caption)));
  frmCalc.Release;
end;

procedure TfrmTarjeta.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_f1 then edtarjeta.SetFocus;
  if key = vk_f2 then btnPOSClick(self);
  if key = vk_f4 then btdevolucionClick(self);
  if key = vk_f3 then edMonto.SetFocus;
end;

procedure TfrmTarjeta.edMontoKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    if Trim(edMonto.Text) = '' then edMonto.Text := floattostr(total);
    btimprimirClick(Self);
    key := #0;
  end;
end;

procedure TfrmTarjeta.btdevolucionClick(Sender: TObject);
begin
  application.CreateForm(tfrmDevoluciones, frmDevoluciones);
  frmDevoluciones.ShowModal;
  frmDevoluciones.vl_forma := 'Tarjeta';
  devolucion := 0;
  if frmMain.QFormaPago.Active then
  begin
    frmMain.QFormaPago.First;
    while not frmMain.QFormaPago.Eof do
    begin
      if frmMain.QFormaPagoforma.Value = 'DEV' then
        devolucion := devolucion + frmMain.QFormaPagopagado.Value;
      frmMain.QFormaPago.Next;
    end;
    frmMain.QFormaPago.First;
  end;
  frmDevoluciones.Release;
  lbdevolucion.Caption := format('%n',[devolucion]);
  lbsubtotal.Caption := format('%n',[total-devolucion]);
end;

procedure TfrmTarjeta.FormActivate(Sender: TObject);
begin
  frmMain.DisplayTotal;
end;


procedure TfrmTarjeta.btnPOSClick(Sender: TObject);
var
ResponseMemo : String;
amount, tax, otherTaxes, quantyOfPayments : Integer;
tamount, ttax :Currency;
a : myJSONItem;
begin
try
  btnPOS.Enabled := False;

  ResponseMemo := '';

  if rgTipoVenta.ItemIndex = 0 then
  quantyOfPayments := 0 else
  quantyOfPayments := StrToInt(cbbCantCuotas.Text);

  if frmMain.QTicketitbis.Value > 0 then
  ttax :=  frmMain.QTicketitbis.Value else
  ttax := 0;

  tax := StrToInt(dm.QuitarPuntosDecimal(ttax));

  tamount := frmMain.QTickettotal.Value;

  amount := StrToInt(dm.QuitarPuntosDecimal(tamount));


  otherTaxes := 0;

  invoiceId := frmMain.QTicketticket.Value;

  result := core.Initialice();
  case rgTipoVenta.ItemIndex of
  0:begin
    response := core.ProcessNormalSale(amount, tax, otherTaxes, invoiceId);
    end;
  1:begin
    response := core.ProcessDeferredSale(amount, tax, otherTaxes, invoiceId, quantyOfPayments);
    end;
  end;

  //emp, suc, usu, facticket:Integer;resultado, tipo, tipofacticket:String;monto,itbis:Double
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
  edMonto.SetFocus;
  end
  else
  if Length(ResponseMemo)> 180 then begin
  a := myJSONItem.Create;
  a.Code :=  ResponseMemo;

  //edDescrip.Text := DM.Query1.FieldByName('CardNumber').Text + ' / '+
  //                  DM.Query1.FieldByName('AuthorizationNumber').Text;

  edtarjeta.Text := copy(a['Card']['CardNumber'].getStr,Length(a['Card']['CardNumber'].getStr)-3,Length(a['Card']['CardNumber'].getStr)) + ' / '+
                    a['Transaction']['AuthorizationNumber'].getStr;

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
