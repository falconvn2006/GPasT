unit BAR43;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TfrmBono = class(TForm)
    btclose: TSpeedButton;
    btteclado: TSpeedButton;
    btok: TSpeedButton;
    lbtotal: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    edbono: TEdit;
    edmonto: TEdit;
    procedure btcloseClick(Sender: TObject);
    procedure bttecladoClick(Sender: TObject);
    procedure btokClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    total : double;
    acepto : integer;
  end;

var
  frmBono: TfrmBono;

implementation

uses BAR33;

{$R *.dfm}

procedure TfrmBono.btcloseClick(Sender: TObject);
begin
  Acepto := 0;
  Close;
end;

procedure TfrmBono.bttecladoClick(Sender: TObject);
begin
  Application.CreateForm(tfrmTeclado, frmTeclado);
  frmTeclado.ShowModal;
  if frmTeclado.Acepto = 1 then
    if edbono.Focused then
      edbono.Text := frmTeclado.edteclado.Text
    else if edmonto.Focused then
      edmonto.Text := frmTeclado.edteclado.Text;

  frmTeclado.Release;
end;

procedure TfrmBono.btokClick(Sender: TObject);
begin
  if length(Trim(edbono.Text)) < 1 then
  begin
    MessageDlg('DEBE DEGITAR EL NUMERO DEL BONO',mtError,[mbok],0);
    edbono.SetFocus;
  end
  else if strtofloat(trim(edmonto.Text)) <= 0 then
  begin
    MessageDlg('EL MONTO NO PUEDE SER CERO (0)',mtError,[mbok],0);
    edmonto.SetFocus;
  end
  else
  begin
    Acepto := 1;
    Close;
  end;
end;

procedure TfrmBono.FormCreate(Sender: TObject);
begin
  btok.Caption := 'OK' + #13 + 'F10';
  btteclado.Caption := 'F3' + #13 + 'TECLADO';
end;

procedure TfrmBono.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_f1  then btcloseClick(Self);
  if key = vk_f3  then bttecladoClick(Self);
  if key = vk_f10 then btokClick(Self);
end;

procedure TfrmBono.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    perform(wm_nextdlgctl, 0, 0);
    key := #0;
  end;
end;

end.
