unit BAR40;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls;

type
  TfrmDesembolso = class(TForm)
    btclose: TSpeedButton;
    btteclado: TSpeedButton;
    btaceptar: TSpeedButton;
    StaticText1: TStaticText;
    edmonto: TEdit;
    StaticText2: TStaticText;
    edconcepto: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure bttecladoClick(Sender: TObject);
    procedure btcloseClick(Sender: TObject);
    procedure btaceptarClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    Acepto : integer;
  end;

var
  frmDesembolso: TfrmDesembolso;

implementation

uses BAR33;

{$R *.dfm}

procedure TfrmDesembolso.FormCreate(Sender: TObject);
begin
  btclose.Caption := 'F1'+#13+'SALIR';
  btaceptar.Caption := 'F10'+#13+'ACEPTAR';
  btteclado.Caption := 'F6'+#13+'TECLADO';
end;

procedure TfrmDesembolso.bttecladoClick(Sender: TObject);
begin
  Application.CreateForm(tfrmTeclado, frmTeclado);
  frmTeclado.ShowModal;
  if frmTeclado.Acepto = 1 then
    if edmonto.Focused then
      edmonto.Text := frmTeclado.edteclado.Text
    else if edconcepto.Focused then
      edconcepto.Text := frmTeclado.edteclado.Text;
  frmTeclado.Release;
end;

procedure TfrmDesembolso.btcloseClick(Sender: TObject);
begin
  Acepto := 0;
  Close;
end;

procedure TfrmDesembolso.btaceptarClick(Sender: TObject);
begin
  if length(trim(edmonto.Text)) < 2 then
  begin
    MessageDlg('DEBE ESPECIFICAR UN MONTO VALIDO',mtError, [mbok], 0);
    edmonto.SetFocus;
  end
  else if length(trim(edconcepto.Text)) < 10 then
  begin
    MessageDlg('DEBE ESPECIFICAR UN CONCEPTO VALIDO',mtError, [mbok], 0);
    edconcepto.SetFocus;
  end
  else
  begin
    Acepto := 1;
    Close;
  end;
end;

procedure TfrmDesembolso.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_f1 then btcloseClick(Self);
  if key = vk_f6 then bttecladoClick(Self);
  if key = vk_f10 then btaceptarClick(Self);
end;

end.
