unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, ExtCtrls, CheckLst, EditBtn, Spin;

type

  { TForm2 }

  TForm2 = class(TForm)
    Button1: TButton;
    Button10: TButton;
    Button12: TButton;
    Button13: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    CheckListBox1: TCheckListBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    FloatSpinEdit1: TFloatSpinEdit;
    FloatSpinEdit2: TFloatSpinEdit;
    FloatSpinEdit3: TFloatSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    TrackBar1: TTrackBar;
    TrackBar2: TTrackBar;
    procedure Button10Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure FloatSpinEdit1Change(Sender: TObject);
    procedure FloatSpinEdit2Change(Sender: TObject);
    procedure FloatSpinEdit3EditingDone(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure floatspinedit3Change(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure TrackBar1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TrackBar2Change(Sender: TObject);
    procedure TrackBar2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form2: TForm2;
  u:byte;
  v:real;
  buforx,bufory,bufor:real;

implementation

{$R *.lfm}

{ TForm2 }

uses
  Unit1;

procedure TForm2.Button13Click(Sender: TObject);
begin
  u:=0;
  repeat inc(u); until (zaznaczonypret[u]=true) or (u>Le);
  if u>Le then exit;
  if Lx[u]<>0 then v:=-arctan(Ly[u]/Lx[u])*180/pi() else v:=-90*abs(Ly[u])/Ly[u];
  if v<0 then v:=v+360;
  floatspinedit3.value:=v;
  floatspinedit3.setfocus;
  floatspinedit3.SelectAll;
end;

procedure TForm2.Button5Click(Sender: TObject);
begin
  floatspinedit1.value:=floatspinedit1.Value-10;
end;

procedure TForm2.Button6Click(Sender: TObject);
begin
  floatspinedit1.value:=floatspinedit1.Value+10;
end;

procedure TForm2.Button7Click(Sender: TObject);
begin
  floatspinedit1.value:=-floatspinedit1.value;
  floatspinedit1.setfocus;
end;


procedure TForm2.FormActivate(Sender: TObject);
begin
  edit1.Enabled:=true;
  edit2.Enabled:=true;
  edit3.Enabled:=true;
  buforx:=100000; bufory:=100000;bufor:=100000;
  for i:=1 to Le do
    if zaznaczonypret[i]=true then
    begin
      if buforx=100000 then begin buforx:=Lx[i]; edit1.text:=floattostrf(buforx*form2x,fffixed,8,4); end;
      if bufory=100000 then begin bufory:=Ly[i]; edit2.text:=floattostrf(bufory*form2x,fffixed,8,4); end;
      if bufor=100000 then begin bufor:=L[i]; edit3.text:=floattostrf(bufor*form2x,fffixed,8,4); end;
      if Lx[i]=0 then begin edit1.enabled:=false; edit1.Text:=''; end;
      if Ly[i]=0 then begin edit2.enabled:=false; edit2.Text:=''; end;
      if Lx[i]<>buforx then begin edit1.enabled:=false; edit1.Text:=''; end;
      if Ly[i]<>bufory then begin edit2.enabled:=false; edit2.Text:=''; end;
      if L[i]<>bufor then begin edit3.enabled:=false; edit3.Text:=''; end;
    end;
end;

procedure TForm2.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  button12.setfocus;okienko:=2;RowsPp:=PreRowsPp;form2open:=false;
end;

procedure TForm2.FormShow(Sender: TObject);
begin
  floatspinedit1.value:=form2P;
  floatspinedit2.value:=form2x;
  floatspinedit3.text:=floattostr(form2alfa);
  checklistbox1.Clear;
  if warianty>0 then for i:=1 to warianty do begin
    checklistbox1.items.Add(wariantnazwa[i]);
    if formwariant[i]=true then checklistbox1.checked[i-1]:=true else checklistbox1.checked[i-1]:=false;
  end;
  floatspinedit1.SetFocus;
  form2.Left:=form1.left+form1.Width-form2.width-10;
  form2.top:=form1.top+form1.ToolBar1.Height+70;
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
  button1.SetFocus;
  form2P:=floatspinedit1.value;
  form2x:=floatspinedit2.value;
  tryStrtofloat(floatspinedit3.text,form2alfa);
  RowsPp:=PreRowsPp;
  for u:=1 to Le do
    if Zaznaczonypret[u]=true then begin
      RowsPp:=RowsPp+1;
      P[RowsPp]:=form2P;
      xp[RowsPp]:=form2x;
      alfap[RowsPp]:=form2alfa;
      np[RowsPp]:=u;
      wariantP[RowsPp,0]:=true;
      for x:=1 to warianty do if checklistbox1.checked[x-1]=true then wariantP[RowsPp,x]:=true else wariantP[RowsPp,x]:=false;
    end;
  PreRowsPp:=RowsPp;
  for u:=1 to Le do Zaznaczonypret[u]:=false; for u:=1 to Lw do Zaznaczonywezel[u]:=false; close;
end;

procedure TForm2.Button12Click(Sender: TObject);
begin
  anulowano:=true; close;
end;

procedure TForm2.Button10Click(Sender: TObject);
begin
  floatspinedit2.value:=1-floatspinedit2.value;
  floatspinedit2.setfocus;
end;

{$-}
procedure TForm2.FloatSpinEdit1Change(Sender: TObject);
begin
  form2P:=floatspinedit1.value;
  floatspinedit1.setfocus;
end;

procedure TForm2.FloatSpinEdit2Change(Sender: TObject);
begin
  form2x:=floatspinedit2.value;
  trackbar1.position:=trunc(form2x*100);
  if (edit1.Enabled=true) and (buforx<100000) and (edit1.focused=false) then edit1.text:=floattostrf(buforx*form2x,fffixed,8,4);
  if (edit2.Enabled=true) and (bufory<100000) and (edit2.focused=false) then edit2.text:=floattostrf(bufory*form2x,fffixed,8,4);
  if (edit3.Enabled=true) and (bufor<100000) and (edit3.focused=false) then edit3.text:=floattostrf(bufor*form2x,fffixed,8,4);
  if button10.Focused=true then floatspinedit2.setfocus;
end;

procedure TForm2.FloatSpinEdit3EditingDone(Sender: TObject);
begin
  while floatspinedit3.value>360 do floatspinedit3.value:=floatspinedit3.value-360;
  while floatspinedit3.value<0 do floatspinedit3.value:=floatspinedit3.value+360;
end;

procedure TForm2.floatspinedit3Change(Sender: TObject);
begin
  form2alfa:=floatspinedit3.value;
  trackbar2.position:=trunc(form2alfa);
  if trackbar2.focused=false then floatspinedit3.setfocus;
  if (floatspinedit3.value>360) and ((v=floatspinedit3.value-floatspinedit3.increment) OR (v=floatspinedit3.value+floatspinedit3.increment)) then while floatspinedit3.value>360 do floatspinedit3.value:=floatspinedit3.value-360;
  if (floatspinedit3.value<0) and ((v=floatspinedit3.value-floatspinedit3.increment) OR (v=floatspinedit3.value+floatspinedit3.increment)) then while floatspinedit3.value<0 do floatspinedit3.value:=floatspinedit3.value+360;
  v:=floatspinedit3.value;
end;

procedure TForm2.edit1Change(Sender: TObject);
var buff:real;
begin
  trystrtofloat(edit1.text,buff);
  if (edit1.Focused=true) and (buforx<>0) then floatspinedit2.value:=buff/buforx;
end;

procedure TForm2.edit2Change(Sender: TObject);
var buff:real;
begin
  trystrtofloat(edit2.text,buff);
  if (edit2.Focused=true) and (bufory<>0)  then floatspinedit2.value:=buff/bufory;
end;

procedure TForm2.edit3Change(Sender: TObject);
var buff:real;
begin
  trystrtofloat(edit3.text,buff);
  if (edit3.Focused=true) and (bufor<>0)  then floatspinedit2.value:=buff/bufor;
end;

{$+}

procedure TForm2.TrackBar1Change(Sender: TObject);
begin
  if trackbar1.focused=true then floatspinedit2.value:=trackbar1.Position/100;
end;

procedure TForm2.TrackBar1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  floatspinedit2.setfocus;
end;

procedure TForm2.TrackBar2Change(Sender: TObject);
begin
  if trackbar2.focused=true then floatspinedit3.text:=floattostr(trackbar2.Position);
end;

procedure TForm2.TrackBar2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  floatspinedit3.setfocus;
end;

end.

