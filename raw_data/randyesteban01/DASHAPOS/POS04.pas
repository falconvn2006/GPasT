unit POS04;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, DBGrids;

type
  TfrmEfectivo = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    edrecibido: TEdit;
    btcalc: TSpeedButton;
    lbtotal: TStaticText;
    btimprimir: TBitBtn;
    btsalir: TBitBtn;
    lbTarjeta: TStaticText;
    Label3: TLabel;
    lbdevolucion: TStaticText;
    btdevolucion: TBitBtn;
    Label4: TLabel;
    Label5: TLabel;
    lbsubtotal: TStaticText;
    Label6: TLabel;
    procedure btsalirClick(Sender: TObject);
    procedure btcalcClick(Sender: TObject);
    procedure btimprimirClick(Sender: TObject);
    procedure edrecibidoKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btdevolucionClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    Facturo : integer;
    total, devolucion : double;
  end;

var
  frmEfectivo: TfrmEfectivo;

implementation

uses POS02, POS00, POS01, POS22;

{$R *.dfm}

procedure TfrmEfectivo.btsalirClick(Sender: TObject);
begin
  Facturo := 0;
  Close;
end;

procedure TfrmEfectivo.btcalcClick(Sender: TObject);
begin
  Application.CreateForm(tfrmCalc, frmCalc);
  frmCalc.ShowModal;
  if strtofloat(frmCalc.lbTotal.Caption) > 0 then
    edrecibido.Text := frmCalc.lbTotal.Caption;
  frmCalc.Release;
end;

procedure TfrmEfectivo.btimprimirClick(Sender: TObject);
begin
  if Trim(edrecibido.Text) = '' then edrecibido.Text := '0';

  if StrToFloat(format('%10.2F',[strtofloat(edrecibido.Text)])) < StrToFloat(format('%10.2F',[total-devolucion])) then
  begin
    edrecibido.SetFocus;
    edrecibido.Text := '';
  end
  {else if StrToFloat(format('%10.2F',[strtofloat(edrecibido.Text)])) >= 200000 then
  begin
    edrecibido.SetFocus;
    edrecibido.Text := '';
  end                     }
  else
  begin
    Facturo := 1;
    Close;
  end;
end;

procedure TfrmEfectivo.edrecibidoKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    {if Trim(edrecibido.Text) = '' then
    begin
      if StrToFloat(format('%10.2F',[devolucion])) < StrToFloat(format('%10.2F',[total])) then
        edrecibido.Text := FloatToStr(StrToFloat(format('%10.2F',[total])) - StrToFloat(format('%10.2F',[devolucion])))
      else if StrToFloat(format('%10.2F',[devolucion])) > StrToFloat(format('%10.2F',[total])) then
        edrecibido.Text := '0.00';
    end;}

    btimprimirClick(Self);
    key := #0;
  end;
end;

procedure TfrmEfectivo.FormCreate(Sender: TObject);
begin
  devolucion := 0;
  Facturo := 0;
end;

procedure TfrmEfectivo.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then
  begin
    btsalirClick(Self);
    key := #0;
  end;
end;

procedure TfrmEfectivo.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_f2 then btdevolucionClick(self);
  if key = vk_f3 then
    begin
      edrecibido.Text:= FloatToStr(total-devolucion);
     // btimprimirClick(self);
    end;

end;

procedure TfrmEfectivo.btdevolucionClick(Sender: TObject);
begin
  application.CreateForm(tfrmDevoluciones, frmDevoluciones);
  frmDevoluciones.ShowModal;
  frmDevoluciones.vl_forma := 'Efectivo';
  devolucion := 0;
  if frmMain.QFormaPago.Active then
  begin
    frmMain.QFormaPago.First;
    while not frmMain.QFormaPago.Eof do
    begin
      if (frmMain.QFormaPagoforma.Value = 'DEV') and (edrecibido.Text <> '')  then
        devolucion := StrToCurr(lbtotal.Caption);//devolucion + frmMain.QFormaPagopagado.Value;
      frmMain.QFormaPago.Next;
    end;
    frmMain.QFormaPago.First;
  end;
  frmDevoluciones.Release;
  lbdevolucion.Caption := format('%n',[devolucion]);
  lbsubtotal.Caption := format('%n',[total-devolucion]);
end;

procedure TfrmEfectivo.FormActivate(Sender: TObject);
begin
  frmMain.DisplayTotal;
end;

end.
