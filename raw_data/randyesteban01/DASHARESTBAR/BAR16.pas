unit BAR16;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TfrmCash = class(TForm)
    lbtotal: TStaticText;
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
    edmonto: TEdit;
    StaticText2: TStaticText;
    lbdevuelta: TStaticText;
    Panel1: TPanel;
    StaticText4: TStaticText;
    bt10: TSpeedButton;
    bt20: TSpeedButton;
    bt50: TSpeedButton;
    bt100: TSpeedButton;
    bt200: TSpeedButton;
    bt500: TSpeedButton;
    bt1000: TSpeedButton;
    bt2000: TSpeedButton;
    btexacto: TSpeedButton;
    btclose: TSpeedButton;
    StaticText1: TStaticText;
    StaticText3: TStaticText;
    StaticText5: TStaticText;
    StaticText6: TStaticText;
    StaticText7: TStaticText;
    StaticText8: TStaticText;
    StaticText9: TStaticText;
    StaticText10: TStaticText;
    procedure btcloseClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
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
    procedure FormActivate(Sender: TObject);
    procedure edmontoChange(Sender: TObject);
    procedure bt10Click(Sender: TObject);
    procedure bt20Click(Sender: TObject);
    procedure bt50Click(Sender: TObject);
    procedure bt100Click(Sender: TObject);
    procedure bt200Click(Sender: TObject);
    procedure bt500Click(Sender: TObject);
    procedure bt1000Click(Sender: TObject);
    procedure bt2000Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btexactoClick(Sender: TObject);
    procedure btokClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Total, Monto, Devuelta : Double;
    Facturo : Integer;
    facturando, pagoCombinado : Boolean;
  end;

var
  frmCash: TfrmCash;

implementation

{$R *.dfm}

procedure TfrmCash.btcloseClick(Sender: TObject);
begin
  Facturo := 0;
  Close;
end;

procedure TfrmCash.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssAlt in Shift) and (key = vk_f4) then abort;
  if key = vk_f1 then btcloseClick(Self);
  if key = vk_f2 then bt10Click(Self);
  if key = vk_f3 then bt20Click(Self);
  if key = vk_f4 then bt50Click(Self);
  if key = vk_f5 then bt100Click(Self);
  if key = vk_f6 then bt200Click(Self);
  if key = vk_f7 then bt500Click(Self);
  if key = vk_f8 then bt1000Click(Self);
  if key = vk_f9 then bt2000Click(Self);
  if key = vk_f10 then btokClick(Self);
  if key = vk_f11 then btexactoClick(Self);
end;

procedure TfrmCash.btclearClick(Sender: TObject);
begin
  edmonto.Text := '';
end;

procedure TfrmCash.bt0Click(Sender: TObject);
begin
  edmonto.Text     := edmonto.text + '0';
  edmonto.SelStart := length(edmonto.text);
end;

procedure TfrmCash.bt1Click(Sender: TObject);
begin
  edmonto.Text     := edmonto.text + '1';
  edmonto.SelStart := length(edmonto.text);
end;

procedure TfrmCash.bt2Click(Sender: TObject);
begin
  edmonto.Text     := edmonto.text + '2';
  edmonto.SelStart := length(edmonto.text);
end;

procedure TfrmCash.bt3Click(Sender: TObject);
begin
  edmonto.Text     := edmonto.text + '3';
  edmonto.SelStart := length(edmonto.text);
end;

procedure TfrmCash.bt4Click(Sender: TObject);
begin
  edmonto.Text     := edmonto.text + '4';
  edmonto.SelStart := length(edmonto.text);
end;

procedure TfrmCash.bt5Click(Sender: TObject);
begin
  edmonto.Text     := edmonto.text + '5';
  edmonto.SelStart := length(edmonto.text);
end;

procedure TfrmCash.bt6Click(Sender: TObject);
begin
  edmonto.Text     := edmonto.text + '6';
  edmonto.SelStart := length(edmonto.text);
end;

procedure TfrmCash.bt7Click(Sender: TObject);
begin
  edmonto.Text     := edmonto.text + '7';
  edmonto.SelStart := length(edmonto.text);
end;

procedure TfrmCash.bt8Click(Sender: TObject);
begin
  edmonto.Text     := edmonto.text + '8';
  edmonto.SelStart := length(edmonto.text);
end;

procedure TfrmCash.bt9Click(Sender: TObject);
begin
  edmonto.Text     := edmonto.text + '9';
  edmonto.SelStart := length(edmonto.text);
end;

procedure TfrmCash.FormActivate(Sender: TObject);
begin
  lbtotal.Caption := 'MONTO A PAGAR'+#13+format('%n',[Total]);
end;

procedure TfrmCash.edmontoChange(Sender: TObject);
begin
  if edmonto.Text <> '' then
    Monto := StrToFloat(format('%10.2F',[strtofloat(edmonto.Text)]))
  else
    Monto := 0;
    
  Devuelta := Monto - Total;
  if Total > Monto then
  begin
    lbdevuelta.Color   := clLime;
    lbdevuelta.Caption := 'PENDIENTE COBRAR'+#13+format('%n',[Devuelta]);
  end
  else
  begin
    lbdevuelta.Color   := clRed;
    lbdevuelta.Caption := 'MONTO A DEVOLVER'+#13+format('%n',[Devuelta]);
  end;
end;

procedure TfrmCash.bt10Click(Sender: TObject);
begin
  edmonto.Text := '10';
end;

procedure TfrmCash.bt20Click(Sender: TObject);
begin
  edmonto.Text := '20';
end;

procedure TfrmCash.bt50Click(Sender: TObject);
begin
  edmonto.Text := '50';
end;

procedure TfrmCash.bt100Click(Sender: TObject);
begin
  edmonto.Text := '100';
end;

procedure TfrmCash.bt200Click(Sender: TObject);
begin
  edmonto.Text := '200';
end;

procedure TfrmCash.bt500Click(Sender: TObject);
begin
  edmonto.Text := '500';
end;

procedure TfrmCash.bt1000Click(Sender: TObject);
begin
  edmonto.Text := '1000';
end;

procedure TfrmCash.bt2000Click(Sender: TObject);
begin
  edmonto.Text := '2000';
end;

procedure TfrmCash.FormCreate(Sender: TObject);
begin
  btexacto.Caption := 'PAGO EXACTO' + #13 + 'F11';
  btok.Caption     := 'OK' + #13 + 'F10';
  pagoCombinado    := false;
  Total     := 0;
  Monto     := 0;
  Devuelta  := 0;
end;

procedure TfrmCash.btexactoClick(Sender: TObject);
begin
  edmonto.Text := Trim(format('%10.2F',[Total]));
end;

procedure TfrmCash.btokClick(Sender: TObject);
begin
  if pagoCombinado then
     begin
        Facturo := 1;
        Close;
     end
  else
  if StrToFloat(format('%10.2F',[Total])) <= StrToFloat(format('%10.2F',[Monto])) then
  begin
    Facturo := 1;
    Close;
  end;
end;

end.
