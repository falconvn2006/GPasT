unit BAR14;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, ExtCtrls, DIMime, jpeg;

type
  TfrmAcceso = class(TForm)
    bt7: TSpeedButton;
    bt8: TSpeedButton;
    bt9: TSpeedButton;
    bt6: TSpeedButton;
    bt5: TSpeedButton;
    bt4: TSpeedButton;
    bt1: TSpeedButton;
    bt2: TSpeedButton;
    bt3: TSpeedButton;
    btok: TSpeedButton;
    btclear: TSpeedButton;
    bt0: TSpeedButton;
    edclave: TEdit;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure btclearClick(Sender: TObject);
    procedure bt0Click(Sender: TObject);
    procedure bt1Click(Sender: TObject);
    procedure bt2Click(Sender: TObject);
    procedure bt3Click(Sender: TObject);
    procedure bt4Click(Sender: TObject);
    procedure bt5Click(Sender: TObject);
    procedure bt6Click(Sender: TObject);
    procedure bt7Click(Sender: TObject);
    procedure bt8Click(Sender: TObject);
    procedure bt9Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btokClick(Sender: TObject);
    procedure edclaveChange(Sender: TObject);
    procedure edclaveKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    Acepto : integer;
  end;

var
  frmAcceso: TfrmAcceso;

implementation

uses BAR04, BAR01;

{$R *.dfm}

procedure TfrmAcceso.FormCreate(Sender: TObject);
begin
  btclear.Caption := 'F3'+#13+'CLR';
  btok.Caption    := 'F10'+#13+'OK';
end;

procedure TfrmAcceso.btclearClick(Sender: TObject);
begin
  edclave.Text := '';
end;

procedure TfrmAcceso.bt0Click(Sender: TObject);
begin
  edclave.Text     := edclave.text + '0';
  edclave.SelStart := length(edclave.text);
end;

procedure TfrmAcceso.bt1Click(Sender: TObject);
begin
  edclave.Text     := edclave.text + '1';
  edclave.SelStart := length(edclave.text);
end;

procedure TfrmAcceso.bt2Click(Sender: TObject);
begin
  edclave.Text     := edclave.text + '2';
  edclave.SelStart := length(edclave.text);
end;

procedure TfrmAcceso.bt3Click(Sender: TObject);
begin
  edclave.Text     := edclave.text + '3';
  edclave.SelStart := length(edclave.text);
end;

procedure TfrmAcceso.bt4Click(Sender: TObject);
begin
  edclave.Text     := edclave.text + '4';
  edclave.SelStart := length(edclave.text);
end;

procedure TfrmAcceso.bt5Click(Sender: TObject);
begin
  edclave.Text     := edclave.text + '5';
  edclave.SelStart := length(edclave.text);
end;

procedure TfrmAcceso.bt6Click(Sender: TObject);
begin
  edclave.Text     := edclave.text + '6';
  edclave.SelStart := length(edclave.text);
end;

procedure TfrmAcceso.bt7Click(Sender: TObject);
begin
  edclave.Text     := edclave.text + '7';
  edclave.SelStart := length(edclave.text);
end;

procedure TfrmAcceso.bt8Click(Sender: TObject);
begin
  edclave.Text     := edclave.text + '8';
  edclave.SelStart := length(edclave.text);
end;

procedure TfrmAcceso.bt9Click(Sender: TObject);
begin
  edclave.Text     := edclave.text + '9';
  edclave.SelStart := length(edclave.text);
end;

procedure TfrmAcceso.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssAlt in Shift) and (key = vk_f4) then abort;
  if edclave.Text <> '' then
     if key = VK_RETURN then btokClick(self);
  if key = vk_f10 then btokClick(self);
  if key = vk_f3 then btclearClick(self);
end;

procedure TfrmAcceso.btokClick(Sender: TObject);
begin
{  if Trim(edclave.Text) = '' then
  begin
    Acepto := 0;
    Close;
  end
  else
  begin
 }
    Acepto := 1;
    Close;
 // end;
end;

procedure TfrmAcceso.edclaveChange(Sender: TObject);
begin
{  if copy(edclave.Text, length(edclave.Text), 1) = '_' then
  begin
    btokClick(self);
  end;}
end;

procedure TfrmAcceso.edclaveKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
btokClick(self);
end;

end.
