unit BAR28;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons;

type
  TfrmNCF = class(TForm)
    btclose: TSpeedButton;
    btcomp1: TSpeedButton;
    btcomp2: TSpeedButton;
    btcomp3: TSpeedButton;
    btcomp4: TSpeedButton;
    procedure btcloseClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btcomp1Click(Sender: TObject);
    procedure btcomp2Click(Sender: TObject);
    procedure btcomp3Click(Sender: TObject);
    procedure btcomp4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Comprobante : integer;
    rnc, nombre : string;
    Acepto : integer;
  end;

var
  frmNCF: TfrmNCF;

implementation

uses BAR29, BAR00;

{$R *.dfm}

procedure TfrmNCF.btcloseClick(Sender: TObject);
begin
  Acepto := 0;
  Close;
end;

procedure TfrmNCF.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_f1 then btcloseClick(Self);
  if key = vk_f2 then btcomp1Click(Self);
  if key = vk_f3 then btcomp2Click(Self);
  if key = vk_f4 then btcomp3Click(Self);
  if key = vk_f5 then btcomp4Click(Self);
end;

procedure TfrmNCF.btcomp1Click(Sender: TObject);
begin
  Comprobante := 1;
  rnc := '';
  nombre := '';
  Close;
end;

procedure TfrmNCF.btcomp2Click(Sender: TObject);
begin
  Comprobante := 2;
  Application.CreateForm(tfrmBuscaRNC, frmBuscaRNC);
  frmBuscaRNC.ShowModal;
  if frmBuscaRNC.Acepto = 1 then
  begin
    rnc := frmBuscaRNC.QRNCrnc_cedula.Value;
    nombre := frmBuscaRNC.QRNCrazon_social.Value;
    frmBuscaRNC.Release;
    Acepto := 1;
    Close;
  end
  else
  begin
    Acepto := 0;
    frmBuscaRNC.Release;
  end;
end;

procedure TfrmNCF.btcomp3Click(Sender: TObject);
begin
  Comprobante := 3;
  Application.CreateForm(tfrmBuscaRNC, frmBuscaRNC);
  frmBuscaRNC.ShowModal;
  if frmBuscaRNC.Acepto = 1 then
  begin
    rnc := frmBuscaRNC.QRNCrnc_cedula.Value;
    nombre := frmBuscaRNC.QRNCrazon_social.Value;
    frmBuscaRNC.Release;
    Acepto := 1;
    Close;
  end
  else
  begin
    Acepto := 0;
    frmBuscaRNC.Release;
  end;
end;

procedure TfrmNCF.btcomp4Click(Sender: TObject);
begin
  Comprobante := 4;
  Application.CreateForm(tfrmBuscaRNC, frmBuscaRNC);
  frmBuscaRNC.ShowModal;
  if frmBuscaRNC.Acepto = 1 then
  begin
    rnc := frmBuscaRNC.QRNCrnc_cedula.Value;
    nombre := frmBuscaRNC.QRNCrazon_social.Value;
    frmBuscaRNC.Release;
  frmPOS.ckItbis := False;
  frmPOS.QFactura.Edit;
  frmPOS.QFacturaConItbis.AsBoolean := frmPOS.ckItbis;
  frmPOS.QFacturaimprimeNCF.Value := frmPOS.ckItbis;
  frmPOS.ckNCF                    := frmPOS.ckItbis;
  frmPOS.Totalizar;

    Acepto := 1;
    Close;
  end
  else
  begin
    Acepto := 0;
    frmBuscaRNC.Release;
  end;
end;

end.
