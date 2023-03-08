unit Main_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ScktComp, StdCtrls, Winsock, Buttons;

type
  TFrm_Main = class(TForm)
    Client: TClientSocket;
    Edt1: TEdit;
    RTest: TRadioButton;
    RDebit: TRadioButton;
    Nbt_send: TBitBtn;
    RAnnul: TRadioButton;
    Memo1: TMemo;
    Label1: TLabel;
    BitBtn1: TBitBtn;
    Lab_Actif: TLabel;
    Nbt_ClearMemo: TBitBtn;
    RCheq: TRadioButton;
    Tim_Maj: TTimer;
    Chk_Timer: TCheckBox;
    Chk_AncVersion: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure ClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure Nbt_sendClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure ClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure Nbt_ClearMemoClick(Sender: TObject);
    procedure Tim_MajTimer(Sender: TObject);
    procedure Chk_TimerClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Frm_Main: TFrm_Main;

implementation

{$R *.dfm}

procedure TFrm_Main.BitBtn1Click(Sender: TObject);
begin
  Client.Active := not(Client.Active);
end;

procedure TFrm_Main.Chk_TimerClick(Sender: TObject);
begin
  Tim_Maj.Enabled := Chk_Timer.Checked;
end;

procedure TFrm_Main.ClientConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  Lab_Actif.Caption := 'Actif'
end;

procedure TFrm_Main.ClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  Lab_Actif.Caption := 'Non actif';
end;

procedure TFrm_Main.ClientRead(Sender: TObject; Socket: TCustomWinSocket);
var
  sRcv: string;
begin
  sRcv := Socket.ReceiveText;
  if Length(sRcv)=0 then
    exit;

  Memo1.Lines.Add('Recu '+FormatDateTime('hh:nn:ss', now)+' :');
  Memo1.Lines.Add(sRcv);
  Memo1.Lines.Add('');

end;

procedure TFrm_Main.FormCreate(Sender: TObject);
begin
  memo1.Clear;
end;

procedure TFrm_Main.Nbt_ClearMemoClick(Sender: TObject);
begin
  Memo1.Clear;
end;

procedure TFrm_Main.Nbt_sendClick(Sender: TObject);
var
  s: string;
  v: Double;
begin
  if not(Client.Active) then
    Client.Active := true;

  if Chk_AncVersion.Checked then
  begin
    s := '';
    if RTest.Checked then
      s:='>TPE'
    else if RDebit.Checked then
    begin
      s:='>MT;';
      v := StrToFloatDef(Edt1.Text, 1);
      s := s+FloatToStr(v);
    end
    else if RCheq.Checked then
    begin
      s:='>CHQ;';
      v := StrToFloatDef(Edt1.Text, 1);
      s := s+FloatToStr(v);
    end
    else if RAnnul.Checked then
      s := '!CANCEL';
  end
  else
  begin
    s := '';
    if RTest.Checked then
      s:='?TPE'
    else if RDebit.Checked then
    begin
      s:='?MT;';
      v := StrToFloatDef(Edt1.Text, 1);
      s := s+FloatToStr(v);
    end
    else if RCheq.Checked then
    begin
      s:='?CHQ;';
      v := StrToFloatDef(Edt1.Text, 1);
      s := s+FloatToStr(v);
    end
    else if RAnnul.Checked then
      s := '!CANCEL';
  end;

  if s='' then
    exit;

  Client.Socket.SendText(s);
end;

procedure TFrm_Main.Tim_MajTimer(Sender: TObject);
begin
  if Client.Active then
    Client.Socket.SendText('!');
end;

end.
