unit Unit6;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, maskedit, Buttons, CheckLst, Spin;

type

  { TForm6 }

  TForm6 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    Button1: TButton;
    Button13: TButton;
    Button17: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckListBox1: TCheckListBox;
    FloatSpinEdit1: TFloatSpinEdit;
    FloatSpinEdit2: TFloatSpinEdit;
    FloatSpinEdit3: TFloatSpinEdit;
    FloatSpinEdit4: TFloatSpinEdit;
    FloatSpinEdit5: TFloatSpinEdit;
    FloatSpinEdit6: TFloatSpinEdit;
    FloatSpinEdit7: TFloatSpinEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    ToggleBox1: TToggleBox;
    TrackBar2: TTrackBar;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure CheckBox3Change(Sender: TObject);
    procedure FloatSpinEdit1EditingDone(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure floatspinedit1Change(Sender: TObject);
    procedure floatspinedit2Change(Sender: TObject);
    procedure floatspinedit3Change(Sender: TObject);
    procedure floatspinedit4Change(Sender: TObject);
    procedure floatspinedit5Change(Sender: TObject);
    procedure floatspinedit6Change(Sender: TObject);
    procedure floatspinedit7Change(Sender: TObject);
    procedure RadioButton1Change(Sender: TObject);
    procedure ToggleBox1Change(Sender: TObject);
    procedure TrackBar2Change(Sender: TObject);
    procedure TrackBar2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form6: TForm6;
  u:byte;
  v:real;

implementation

{$R *.lfm}

{ TForm6 }

uses
  Unit1;

procedure TForm6.CheckBox1Change(Sender: TObject);
begin
  if checkbox1.checked then begin checkbox2.Enabled:=true;
  floatspinedit1.Enabled:=true; floatspinedit2.Enabled:=true; floatspinedit5.Enabled:=true;
  togglebox1.Enabled:=true; trackbar2.Enabled:=true;
  f6V:=true; end
  else begin f6V:=false; checkbox2.Enabled:=false;floatspinedit1.Enabled:=false;
  floatspinedit2.Enabled:=false; floatspinedit5.Enabled:=false; togglebox1.Enabled:=false;
  trackbar2.Enabled:=false; end;
end;

procedure TForm6.CheckBox2Change(Sender: TObject);
begin
  if checkbox2.checked then begin f6H:=true; floatspinedit3.Enabled:=true; floatspinedit6.Enabled:=true; end
  else begin f6H:=false; floatspinedit3.Enabled:=false; floatspinedit6.Enabled:=false; end;
end;

procedure TForm6.CheckBox3Change(Sender: TObject);
begin
  if checkbox3.checked then begin f6M:=true; floatspinedit4.Enabled:=true; floatspinedit7.Enabled:=true; end
  else begin f6M:=false; floatspinedit4.Enabled:=false; floatspinedit7.Enabled:=false; end;
end;

procedure TForm6.FloatSpinEdit1EditingDone(Sender: TObject);
begin
  while floatspinedit1.value>360 do floatspinedit1.value:=floatspinedit1.value-360;
  while floatspinedit1.value<0 do floatspinedit1.value:=floatspinedit1.value+360;
end;

procedure TForm6.FormActivate(Sender: TObject);
begin
  if tryb=4 then begin tryb:=0; floatspinedit1.value:=f6alfa; end;
  if tryb=0 then togglebox1.Checked:=false;
end;

procedure TForm6.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  button17.setfocus;okienko:=2;Lwar:=PreLwar;form6open:=false;
end;

procedure TForm6.FormShow(Sender: TObject);
begin
  if rodzajpodpory=1 then begin f6V:=true; f6H:=true; f6M:=true end;
  if rodzajpodpory=2 then begin f6V:=true; f6H:=false; f6M:=true end;
  if rodzajpodpory=3 then begin f6V:=true; f6H:=true; f6M:=false end;
  if rodzajpodpory=4 then begin f6V:=true; f6H:=false; f6M:=false end;
  if rodzajpodpory=5 then begin f6V:=false; f6H:=false; f6M:=true end;
  if f6V=true then checkbox1.checked:=true else checkbox1.checked:=false;
  if f6H=true then checkbox2.checked:=true else checkbox2.checked:=false;
  if f6M=true then checkbox3.checked:=true else checkbox3.checked:=false;
  floatspinedit1.value:=f6alfa;
  floatspinedit2.value:=f6DV;
  floatspinedit3.value:=f6DH;
  if radiobutton1.checked then begin f6DM:=f6DM*180/pi; f6DM:=round(f6DM*10000)/10000; end;
  floatspinedit4.value:=f6DM;
  floatspinedit5.value:=f6KV;
  floatspinedit6.value:=f6KH;
  floatspinedit7.value:=f6KM;
  checklistbox1.Clear;
  if warianty>0 then for i:=1 to warianty do begin
    checklistbox1.items.Add(wariantnazwa[i]);
    if formwariant[i]=true then checklistbox1.checked[i-1]:=true else checklistbox1.checked[i-1]:=false;
  end;
  if floatspinedit1.enabled=true then floatspinedit1.SetFocus else
    if floatspinedit4.enabled=true then floatspinedit4.SetFocus else button1.setfocus;
  form6.Left:=form1.left+form1.Width-form6.width-10;
  form6.top:=form1.top+form1.ToolBar1.Height+70;
end;

procedure TForm6.Button13Click(Sender: TObject);
begin
  floatspinedit2.value:=0;
  floatspinedit3.value:=0;
  floatspinedit4.value:=0;
  floatspinedit5.value:=0;
  floatspinedit6.value:=0;
  floatspinedit7.value:=0;
  button1.setfocus;
end;

procedure TForm6.Button17Click(Sender: TObject);
begin
  anulowano:=true; close;
end;

procedure TForm6.Button1Click(Sender: TObject);
begin
  button1.setfocus;
  f6alfa:=floatspinedit1.value;
  f6DV:=floatspinedit2.value;
  f6DH:=floatspinedit3.value;
  f6DM:=floatspinedit4.value;
  if radiobutton1.checked=true then f6DM:=F6DM*pi/180;
  f6KV:=floatspinedit5.value;
  f6KH:=floatspinedit6.value;
  f6KM:=floatspinedit7.value;
  Lwar:=PreLwar;
  for i:=1 to Lw do
    if Zaznaczonywezel[i]=true then begin
      if (f6H=true) or (f6V=true) or (f6M=true) then begin Lwar:=Lwar+1; fipod[Lwar]:=f6alfa; s[Lwar]:=i; end;
      if (f6V=false) and (f6H=false) and (f6M=true) then Rpod[lwar]:=1;
      if (f6V=true)  and (f6H=true)  and (f6M=true) then Rpod[lwar]:=2;
      if (f6V=true)  and (f6H=true)  and (f6M=false)then Rpod[lwar]:=3;
      if (f6V=true)  and (f6H=false) and (f6M=true) then Rpod[lwar]:=4;
      if (f6V=true)  and (f6H=false) and (f6M=false)then Rpod[lwar]:=5;
      if (f6V=true) then begin DV[Lwar]:=f6DV/100; KV[Lwar]:=f6KV end else begin DV[Lwar]:=0; KV[Lwar]:=0 end;
      if (f6H=true) then begin DH[Lwar]:=f6DH/100; KH[Lwar]:=f6KH end else begin DH[Lwar]:=0; KH[Lwar]:=0 end;
      if (f6M=true) then begin DM[Lwar]:=f6DM; KM[Lwar]:=f6KM end else begin DM[Lwar]:=0; KM[Lwar]:=0 end;
      wariantPod[Lwar,0]:=true;
      for x:=1 to warianty do if checklistbox1.checked[x-1]=true then wariantPod[Lwar,x]:=true else wariantPod[Lwar,x]:=false;
    end;
  PreLwar:=Lwar; for u:=1 to Lw do Zaznaczonywezel[u]:=false; for u:=1 to Le do Zaznaczonypret[u]:=false;
  for i:=Lwar+1 to Lw do s[i]:=0;
  close;
end;

procedure TForm6.BitBtn5Click(Sender: TObject);
begin
  checkbox1.checked:=true; checkbox2.checked:=true; checkbox3.checked:=false;
  button1.setfocus;
end;

procedure TForm6.BitBtn4Click(Sender: TObject);
begin
  checkbox1.checked:=true; checkbox2.checked:=false; checkbox3.checked:=false;
  button1.setfocus;
end;

procedure TForm6.BitBtn3Click(Sender: TObject);
begin
  checkbox1.checked:=true; checkbox2.checked:=true; checkbox3.checked:=true;
  button1.setfocus;
end;

procedure TForm6.BitBtn2Click(Sender: TObject);
begin
  checkbox1.checked:=true; checkbox2.checked:=false; checkbox3.checked:=true;
  button1.setfocus;
end;

procedure TForm6.BitBtn1Click(Sender: TObject);
begin
  checkbox1.checked:=false; checkbox2.checked:=false; checkbox3.checked:=true;
  button1.setfocus;
end;

{$-}
procedure TForm6.floatspinedit1Change(Sender: TObject);
begin
  f6alfa:=floatspinedit1.value;
  trackbar2.position:=trunc(f6alfa);
  if (trackbar2.focused=false) and (floatspinedit1.enabled=true) then floatspinedit1.setfocus;
  if (floatspinedit1.value>360) and ((v=floatspinedit1.value-floatspinedit1.increment) OR (v=floatspinedit1.value+floatspinedit1.increment)) then while floatspinedit1.value>360 do floatspinedit1.value:=floatspinedit1.value-360;
  if (floatspinedit1.value<0) and ((v=floatspinedit1.value-floatspinedit1.increment) OR (v=floatspinedit1.value+floatspinedit1.increment)) then while floatspinedit1.value<0 do floatspinedit1.value:=floatspinedit1.value+360;
  v:=floatspinedit1.value;
  if trackbar2.focused=false then if floatspinedit1.enabled=true then floatspinedit1.SetFocus else floatspinedit4.SetFocus;
end;

procedure TForm6.floatspinedit2Change(Sender: TObject);
begin
  f6DV:=floatspinedit2.value;
  if floatspinedit2.enabled=true then floatspinedit2.setfocus;
end;

procedure TForm6.floatspinedit3Change(Sender: TObject);
begin
  f6DH:=floatspinedit3.value;
  if floatspinedit3.enabled=true then floatspinedit3.setfocus;
end;

procedure TForm6.floatspinedit4Change(Sender: TObject);
begin
  f6DM:=floatspinedit4.value;
  if radiobutton1.checked=true then f6DM:=F6DM*pi/180;
  if floatspinedit4.enabled=true then floatspinedit4.setfocus;
end;

procedure TForm6.floatspinedit5Change(Sender: TObject);
begin
  f6KV:=floatspinedit5.value;
  if floatspinedit5.enabled=true then floatspinedit5.setfocus;
end;

procedure TForm6.floatspinedit6Change(Sender: TObject);
begin
  f6KH:=floatspinedit6.value;
  if floatspinedit6.enabled=true then floatspinedit6.setfocus;
end;

procedure TForm6.floatspinedit7Change(Sender: TObject);
begin
  f6KM:=floatspinedit7.value;
  if floatspinedit7.enabled=true then floatspinedit7.setfocus;
end;

procedure TForm6.RadioButton1Change(Sender: TObject);
begin
  if radiobutton1.checked=true then begin f6DM:=f6DM*180/pi; f6DM:=round(f6DM*10000)/10000  end;
  floatspinedit4.value:=f6DM;
end;

{$+}

procedure TForm6.ToggleBox1Change(Sender: TObject);
begin
  if Togglebox1.Checked then tryb:=3 else tryb:=0;
  if floatspinedit1.enabled=true then floatspinedit1.SetFocus else floatspinedit4.SetFocus;
end;

procedure TForm6.TrackBar2Change(Sender: TObject);
begin
  if trackbar2.focused=true then floatspinedit1.text:=floattostr(trackbar2.Position);
end;

procedure TForm6.TrackBar2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if floatspinedit1.enabled=true then floatspinedit1.setfocus;
end;

end.

