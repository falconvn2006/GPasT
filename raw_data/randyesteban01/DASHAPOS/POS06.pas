unit POS06;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TfrmCheque = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    edcheque: TEdit;
    btcalc: TSpeedButton;
    lbtotal: TStaticText;
    btimprimir: TBitBtn;
    btsalir: TBitBtn;
    lbTarjeta: TStaticText;
    Label3: TLabel;
    SpeedButton1: TSpeedButton;
    edMonto: TEdit;
    btdevolucion: TBitBtn;
    Label5: TLabel;
    Label4: TLabel;
    lbdevolucion: TStaticText;
    lbsubtotal: TStaticText;
    procedure btsalirClick(Sender: TObject);
    procedure btcalcClick(Sender: TObject);
    procedure btimprimirClick(Sender: TObject);
    procedure edchequeKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SpeedButton1Click(Sender: TObject);
    procedure edMontoKeyPress(Sender: TObject; var Key: Char);
    procedure btdevolucionClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    Facturo : integer;
    total, devolucion : double;
  end;

var
  frmCheque: TfrmCheque;

implementation

uses POS02, POS22, POS00;

{$R *.dfm}

procedure TfrmCheque.btsalirClick(Sender: TObject);
begin
  Facturo := 0;
  Close;
end;

procedure TfrmCheque.btcalcClick(Sender: TObject);
begin
  Application.CreateForm(tfrmCalc, frmCalc);
  frmCalc.ShowModal;
  edcheque.Text := IntToStr(Trunc(StrToFloat(frmCalc.lbTotal.Caption)));
  frmCalc.Release;
end;

procedure TfrmCheque.btimprimirClick(Sender: TObject);
begin
  if Trim(edMonto.Text) = '' then edMonto.Text := '0';

  if StrToFloat(format('%10.2F',[strtofloat(edMonto.Text)])) < (StrToFloat(format('%10.2F',[total])) -
     StrToFloat(format('%10.2F',[devolucion]))) then
    begin
      MessageDlg('EL MONTO NO PUEDE SE MENOR AL TOTAL',mtError,[mbok],0);
      edMonto.SetFocus;
    end
  else
    if StrToFloat(format('%10.2F',[strtofloat(edMonto.Text)])) >= 50000 then
      begin
        edMonto.SetFocus;
        edMonto.Text := '';
      end
    else
      begin
        Facturo := 1;
        Close;
      end;
end;

procedure TfrmCheque.edchequeKeyPress(Sender: TObject; var Key: Char);
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

procedure TfrmCheque.FormCreate(Sender: TObject);
begin
  Facturo := 0;
end;

procedure TfrmCheque.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_escape then btsalirClick(Self);
  if key = vk_f1 then edcheque.SetFocus;
  if key = vk_f2 then btdevolucionClick(self);
  if key = vk_f3 then edMonto.SetFocus;
end;

procedure TfrmCheque.SpeedButton1Click(Sender: TObject);
begin
  Application.CreateForm(tfrmCalc, frmCalc);
  frmCalc.ShowModal;
  edMonto.Text := IntToStr(Trunc(StrToFloat(frmCalc.lbTotal.Caption)));
  frmCalc.Release;
end;

procedure TfrmCheque.edMontoKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    //if Trim(edMonto.Text) = '' then edMonto.Text := floattostr(total);
    btimprimirClick(Self);
    key := #0;
  end;
end;

procedure TfrmCheque.btdevolucionClick(Sender: TObject);
begin
  application.CreateForm(tfrmDevoluciones, frmDevoluciones);
  frmDevoluciones.ShowModal;
  frmDevoluciones.vl_forma := 'Cheque';
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

procedure TfrmCheque.FormActivate(Sender: TObject);
begin
  frmMain.DisplayTotal;
end;

end.
