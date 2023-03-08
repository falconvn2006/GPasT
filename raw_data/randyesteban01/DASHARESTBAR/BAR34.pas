unit BAR34;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, DBCtrls, Mask, ComCtrls, ToolEdit, CurrEdit;

type
  TfrmDescuento = class(TForm)
    btclose: TSpeedButton;
    btaceptar: TSpeedButton;
    DBText1: TDBText;
    DBEdit1: TDBEdit;
    Label1: TLabel;
    btteclado: TSpeedButton;
    Label2: TLabel;
    DBEdit2: TDBEdit;
    pcDescuento: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    DBEdit3: TDBEdit;
    DBText2: TDBText;
    Label3: TLabel;
    Label4: TLabel;
    DBMemo1: TDBMemo;
    DBCheckBox1: TDBCheckBox;
    ckDescuentoGlobal: TDBCheckBox;
    CEdt_DescGlobal: TCurrencyEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btcloseClick(Sender: TObject);
    procedure bttecladoClick(Sender: TObject);
    procedure btaceptarClick(Sender: TObject);
    procedure ckDescuentoGlobalClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Acepto : integer;
  end;

var
  frmDescuento: TfrmDescuento;

implementation

uses BAR00, BAR33, DateUtils, DB, BAR04;

{$R *.dfm}

procedure TfrmDescuento.FormCreate(Sender: TObject);
begin
  btclose.Caption   := 'F1'+#13+'SALIR';
  btteclado.Caption := 'F3' + #13 + 'TECLADO';
  btaceptar.Caption := 'F10'+#13+'ACEPTAR';
  if frmPOS.QFacturaDescuento.Value > 0 then begin
  CEdt_DescGlobal.Value := (frmPOS.QFacturaDescuento.Value/(frmPOS.QFacturaTotal.Value-frmPOS.QFacturaItbis.Value+frmPOS.QFacturaDescuento.Value))*100;
  pcDescuento.TabIndex := 1;
  end;
  if not ckDescuentoGlobal.Checked then begin
  pcDescuento.TabIndex := 0;
  CEdt_DescGlobal.Value := 0;
  end;
  //ckDescuentoGlobal.OnClick(nil);
end;

procedure TfrmDescuento.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_f1 then btcloseClick(Self);
end;

procedure TfrmDescuento.btcloseClick(Sender: TObject);
begin
  Acepto := 0;
  Close;
end;

procedure TfrmDescuento.bttecladoClick(Sender: TObject);
begin
  Application.CreateForm(tfrmTeclado, frmTeclado);
  frmTeclado.ShowModal;
  if frmTeclado.Acepto = 1 then
    if DBEdit1.Focused then
      frmPOS.QDetallePrecio.Value := StrToFloat(frmTeclado.edteclado.Text)
    else if DBEdit2.Focused then
      frmPOS.QDetalleDescuento.Value := StrToFloat(frmTeclado.edteclado.Text);

  frmTeclado.Release;
end;

procedure TfrmDescuento.btaceptarClick(Sender: TObject);
begin
  if ckDescuentoGlobal.Checked then begin
  with frmPOS.QDetalle do begin
  frmPOS.QDetalle.DisableControls;
  frmPOS.QDetalle.First;
  while not Eof do begin
  frmPOS.QDetalle.Edit;
  frmPOS.QDetalleDescuento.Value := CEdt_DescGlobal.Value;
  frmPOS.QDetalle.Post;
  frmPOS.QDetalle.Next;
  end;
  frmPOS.QDetalle.EnableControls;
  frmPOS.QDetalle.UpdateBatch;
  frmPOS.Totalizar;
  frmPOS.QDetalle.Edit;
  frmPOS.QFactura.Edit;
  end;
  end;
  if CEdt_DescGlobal.Value = 0 then
  ckDescuentoGlobal.Checked := False else
  ckDescuentoGlobal.Checked := True;
  Acepto := 1;
  Close;
end;

procedure TfrmDescuento.ckDescuentoGlobalClick(Sender: TObject);
begin
  case ckDescuentoGlobal.Checked of
    true :  pcDescuento.TabIndex := 1;
    false:  pcDescuento.TabIndex := 0;
  end;  
end;

end.
