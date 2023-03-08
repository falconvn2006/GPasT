unit BAR39;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TfrmImpuestos = class(TForm)
    ckitbis: TCheckBox;
    ckpropina: TCheckBox;
    btclose: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure btcloseClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ckitbisClick(Sender: TObject);
    procedure ckpropinaClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmImpuestos: TfrmImpuestos;

implementation

uses BAR00;

{$R *.dfm}

procedure TfrmImpuestos.FormCreate(Sender: TObject);
begin
  btclose.Caption   := 'F1'+#13+'SALIR';
  ckitbis.Checked   := frmPOS.ckItbis;
  ckpropina.Checked := frmPOS.ckPropina;
end;

procedure TfrmImpuestos.btcloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmImpuestos.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_f1 then btcloseClick(Self);
  if key = vk_f3 then ckitbis.Checked   := not ckitbis.Checked;
  if key = vk_f4 then ckpropina.Checked := not ckpropina.Checked;
end;

procedure TfrmImpuestos.ckitbisClick(Sender: TObject);
begin
  frmPOS.ckItbis := ckitbis.Checked;
  frmPOS.QFactura.Edit;
  frmPOS.QFacturaConItbis.AsBoolean := ckItbis.Checked;
  frmPOS.QFacturaimprimeNCF.Value := ckitbis.Checked;
  frmPOS.ckNCF                    := ckitbis.Checked;
  frmPOS.Totalizar;

end;

procedure TfrmImpuestos.ckpropinaClick(Sender: TObject);
begin
  frmPOS.ckPropina := ckpropina.Checked;
  frmPOS.QFactura.Edit;
  frmPOS.QFacturaConPropina.AsBoolean := ckPropina.Checked;
  frmPOS.Totalizar;
end;

end.
