unit Unit3;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, ActnList, Menus, CheckLst, Spin;

type

  { TForm3 }

  TForm3 = class(TForm)
    Button1: TButton;
    Button10: TButton;
    Button16: TButton;
    Button17: TButton;
    Button18: TButton;
    Button19: TButton;
    Button2: TButton;
    Button20: TButton;
    Button3: TButton;
    Button5: TButton;
    Button6: TButton;
    Button9: TButton;
    CheckListBox1: TCheckListBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    floatspinedit1: TFloatSpinEdit;
    floatspinedit2: TFloatSpinEdit;
    FloatSpinEdit3: TFloatSpinEdit;
    FloatSpinEdit4: TFloatSpinEdit;
    FloatSpinEdit5: TFloatSpinEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    PopupMenu1: TPopupMenu;
    TrackBar1: TTrackBar;
    TrackBar2: TTrackBar;
    TrackBar3: TTrackBar;
    procedure Button10Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure Button19Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button20Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure floatspinedit1Change(Sender: TObject);
    procedure floatspinedit2Change(Sender: TObject);
    procedure FloatSpinEdit5EditingDone(Sender: TObject);
    procedure Formshow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure edit3Change(Sender: TObject);
    procedure edit5Change(Sender: TObject);
    procedure floatspinedit4Change(Sender: TObject);
    procedure floatspinedit3Change(Sender: TObject);
    procedure floatspinedit5Change(Sender: TObject);
    procedure edit2Change(Sender: TObject);
    procedure edit4Change(Sender: TObject);
    procedure edit6Change(Sender: TObject);
    procedure edit1Change(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure TrackBar1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TrackBar2Change(Sender: TObject);
    procedure TrackBar2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TrackBar3Change(Sender: TObject);
    procedure TrackBar3MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form3: TForm3;
  u:byte;
  v:real;
  buforx,bufory,bufor:real;
  vv:boolean;

implementation

{$R *.lfm}

{ TForm3 }

uses
  Unit1;

procedure TForm3.Button3Click(Sender: TObject);
begin
  floatspinedit1.value:=-floatspinedit1.value;
  floatspinedit1.setfocus;
  if floatspinedit1.value=floatspinedit2.Value then vv:=true else vv:=false;
end;

procedure TForm3.Button5Click(Sender: TObject);
begin
  floatspinedit2.value:=floatspinedit2.value-10;
end;

procedure TForm3.Button6Click(Sender: TObject);
begin
    floatspinedit2.value:=floatspinedit2.value+10;
end;

procedure TForm3.Button9Click(Sender: TObject);
begin
  floatspinedit1.value:=floatspinedit1.value-10;
  floatspinedit1.setfocus;
  if floatspinedit1.value=floatspinedit2.Value then vv:=true else vv:=false;
end;

procedure TForm3.floatspinedit1Change(Sender: TObject);
begin
  form3qk:=floatspinedit1.value;
  if (floatspinedit1.value=floatspinedit2.Value) and (floatspinedit1.Focused=true) then vv:=true;
  if (floatspinedit1.value<>floatspinedit2.Value) and (floatspinedit1.Focused=true) then vv:=false;
end;

procedure TForm3.floatspinedit2Change(Sender: TObject);
begin
  form3qp:=floatspinedit2.value;
  if vv=true then floatspinedit1.value:=floatspinedit2.value;
  floatspinedit2.setfocus;

end;

procedure TForm3.FloatSpinEdit5EditingDone(Sender: TObject);
begin
  while floatspinedit5.value>360 do floatspinedit5.value:=floatspinedit5.value-360;
  while floatspinedit5.value<0 do floatspinedit5.value:=floatspinedit5.value+360;
end;

procedure TForm3.Formshow(Sender: TObject);
begin
  floatspinedit2.value:=form3qp;
  floatspinedit4.value:=form3xp;
  floatspinedit1.value:=form3qk;
  floatspinedit3.value:=form3xk;
  if floatspinedit2.value=floatspinedit1.value then vv:=true else vv:=false;
  floatspinedit5.value:=form3alfa;
  checklistbox1.Clear;
  if warianty>0 then for i:=1 to warianty do begin
    checklistbox1.items.Add(wariantnazwa[i]);
    if formwariant[i]=true then checklistbox1.checked[i-1]:=true else checklistbox1.checked[i-1]:=false;
  end;
  floatspinedit2.SetFocus;
  form3.Left:=form1.left+form1.Width-form3.width-10;
  form3.top:=form1.top+form1.ToolBar1.Height+70;
end;

procedure TForm3.FormActivate(Sender: TObject);
begin
  edit2.Enabled:=true;   edit1.Enabled:=true;
  edit4.Enabled:=true;   edit3.Enabled:=true;
  edit6.Enabled:=true;   edit5.Enabled:=true;
  buforx:=100000; bufory:=100000;bufor:=100000;
  for i:=1 to Le do
    if zaznaczonypret[i]=true then
    begin
      if buforx=100000 then begin buforx:=Lx[i]; edit2.text:=floattostr(buforx*form3xp); edit1.text:=floattostr(buforx*form3xk); end;
      if bufory=100000 then begin bufory:=Ly[i]; edit4.text:=floattostr(bufory*form3xp); edit3.text:=floattostr(bufory*form3xk); end;
      if bufor=100000 then begin bufor:=L[i]; edit6.text:=floattostr(bufor*form3xp); edit5.text:=floattostr(bufor*form3xk); end;
      if Lx[i]=0 then begin edit2.enabled:=false; edit2.Text:=''; edit1.enabled:=false; edit1.Text:=''; end;
      if Ly[i]=0 then begin edit4.enabled:=false; edit4.Text:=''; edit3.enabled:=false; edit3.Text:=''; end;
      if Lx[i]<>buforx then begin edit2.enabled:=false; edit2.Text:=''; edit1.enabled:=false; edit1.Text:=''; end;
      if Ly[i]<>bufory then begin edit4.enabled:=false; edit4.Text:=''; edit3.enabled:=false; edit3.Text:=''; end;
      if L[i]<>bufor then begin edit6.enabled:=false; edit6.Text:=''; edit5.enabled:=false; edit5.Text:='';end;
    end;
end;

procedure TForm3.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
 button16.setfocus;okienko:=2;RowsPq:=PreRowsPq;form3open:=false;
end;

{$-}

procedure TForm3.floatspinedit4Change(Sender: TObject);
begin
  form3xp:=floatspinedit4.value;
  trackbar1.position:=trunc(form3xp*100);
  if (edit2.Enabled=true) and (buforx<100000) and (edit2.focused=false) then edit2.text:=floattostrf(buforx*form3xp,fffixed,8,4);
  if (edit4.Enabled=true) and (bufory<100000) and (edit4.focused=false) then edit4.text:=floattostrf(bufory*form3xp,fffixed,8,4);
  if (edit6.Enabled=true) and (bufor<100000) and (edit6.focused=false) then edit6.text:=floattostrf(bufor*form3xp,fffixed,8,4);
  if button18.Focused=true then floatspinedit4.setfocus;
end;

procedure TForm3.floatspinedit3Change(Sender: TObject);
begin
  form3xk:=floatspinedit3.value;
  trackbar2.position:=trunc(form3xk*100);
  if (edit1.Enabled=true) and (buforx<100000) and (edit1.focused=false) then edit1.text:=floattostrf(buforx*form3xk,fffixed,8,4);
  if (edit3.Enabled=true) and (bufory<100000) and (edit3.focused=false) then edit3.text:=floattostrf(bufory*form3xk,fffixed,8,4);
  if (edit5.Enabled=true) and (bufor<100000) and (edit5.focused=false) then edit5.text:=floattostrf(bufor*form3xk,fffixed,8,4);
  if button19.Focused=true then floatspinedit3.setfocus;
end;

procedure TForm3.floatspinedit5Change(Sender: TObject);
begin
  form3alfa:=floatspinedit5.value;
  trackbar3.position:=trunc(form3alfa);
  if trackbar3.focused=false then floatspinedit5.setfocus;
  if (floatspinedit5.value>360) and ((v=floatspinedit5.value-floatspinedit5.increment) OR (v=floatspinedit5.value+floatspinedit5.increment)) then while floatspinedit5.value>360 do floatspinedit5.value:=floatspinedit5.value-360;
  if (floatspinedit5.value<0) and ((v=floatspinedit5.value-floatspinedit5.increment) OR (v=floatspinedit5.value+floatspinedit5.increment)) then while floatspinedit5.value<0 do floatspinedit5.value:=floatspinedit5.value+360;
  v:=floatspinedit5.value;
end;

procedure TForm3.edit2Change(Sender: TObject);
var buff:real;
begin
  trystrtofloat(edit2.text,buff);
  if (edit2.Focused=true) and (buforx<>0) then floatspinedit4.value:=buff/buforx;
end;

procedure TForm3.edit4Change(Sender: TObject);
var buff:real;
begin
  trystrtofloat(edit4.text,buff);
  if (edit4.Focused=true) and (bufory<>0)  then floatspinedit4.value:=buff/bufory;
end;

procedure TForm3.edit6Change(Sender: TObject);
var buff:real;
begin
  trystrtofloat(edit6.text,buff);
  if (edit6.Focused=true) and (bufor<>0)  then floatspinedit4.value:=buff/bufor;
end;

procedure TForm3.edit1Change(Sender: TObject);
var buff:real;
begin
  trystrtofloat(edit1.text,buff);
  if (edit1.Focused=true) and (buforx<>0) then floatspinedit3.value:=buff/buforx;
end;

procedure TForm3.edit3Change(Sender: TObject);
var buff:real;
begin
  trystrtofloat(edit3.text,buff);
  if (edit3.Focused=true) and (bufory<>0)  then floatspinedit3.value:=buff/bufory;
end;

procedure TForm3.edit5Change(Sender: TObject);
var buff:real;
begin
  trystrtofloat(edit5.text,buff);
  if (edit5.Focused=true) and (bufor<>0)  then floatspinedit3.value:=buff/bufor;
end;

procedure TForm3.MenuItem1Click(Sender: TObject);
begin
  u:=0;
  repeat
    u:=u+1;
    if zaznaczonypret[u]=True then if Ly[u]<>0 then begin form3qp:=form3qp*abs(Ly[u])/L[u]; form3qk:=form3qk*abs(Ly[u])/L[u];end;
    floatspinedit2.value:=form3qp; floatspinedit1.value:=form3qk;
  until zaznaczonypret[u]=True;
end;

procedure TForm3.MenuItem2Click(Sender: TObject);
begin
  u:=0;
  repeat
    u:=u+1;
    if zaznaczonypret[u]=True then if Lx[u]<>0 then begin form3qp:=form3qp*abs(Lx[u])/L[u]; form3qk:=form3qk*abs(Lx[u])/L[u];end;
    floatspinedit2.value:=form3qp;  floatspinedit1.value:=form3qk;
  until zaznaczonypret[u]=True;
end;

procedure TForm3.MenuItem3Click(Sender: TObject);
var vvv:real;
begin
  vvv:=floatspinedit2.value;floatspinedit2.value:=floatspinedit1.value;floatspinedit1.value:=vvv;
  floatspinedit2.setfocus;
end;

{$+}

procedure TForm3.TrackBar1Change(Sender: TObject);
begin
 if trackbar1.focused=true then floatspinedit4.text:=floattostr(trackbar1.position/100);
end;

procedure TForm3.TrackBar1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  floatspinedit4.setfocus;
end;

procedure TForm3.TrackBar2Change(Sender: TObject);
begin
  if trackbar2.focused=true then floatspinedit3.text:=floattostr(trackbar2.position/100);
end;

procedure TForm3.TrackBar2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  floatspinedit3.setfocus;
end;

procedure TForm3.TrackBar3Change(Sender: TObject);
begin
  if trackbar3.focused=true then floatspinedit5.value:=trackbar3.position;
end;

procedure TForm3.TrackBar3MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  floatspinedit5.setfocus;
end;

procedure TForm3.Button10Click(Sender: TObject);
begin
  floatspinedit1.value:=floatspinedit1.value+10;
  floatspinedit1.setfocus;
  if floatspinedit1.value=floatspinedit2.Value then vv:=true else vv:=false;
end;

procedure TForm3.Button16Click(Sender: TObject);
begin
  anulowano:=true; close;
end;

procedure TForm3.Button18Click(Sender: TObject);
begin
  floatspinedit4.value:=1-floatspinedit4.value;
  floatspinedit4.setfocus;
end;

procedure TForm3.Button19Click(Sender: TObject);
begin
  floatspinedit3.value:=1-floatspinedit3.value;
  floatspinedit3.setfocus;
end;

procedure TForm3.Button1Click(Sender: TObject);
begin
  button1.setfocus;
  form3qp:=floatspinedit2.value;
  form3qk:=floatspinedit1.value;
  form3xp:=floatspinedit4.value;
  form3xk:=floatspinedit3.value;
  form3alfa:=floatspinedit5.value;
  if form3xp<form3xk then begin
    RowsPq:=PreRowsPq;
    for u:=1 to Le do
      if Zaznaczonypret[u]=true then begin
        RowsPq:=RowsPq+1;
        Pqi[RowsPq]:=form3qp;
        Pqj[RowsPq]:=form3qk;
        xqi[RowsPq]:=form3xp;
        xqj[RowsPq]:=form3xk;
        alfaq[RowsPq]:=form3alfa;
        nq[RowsPq]:=u;
        wariantQ[RowsPq,0]:=true;
        for x:=1 to warianty do if checklistbox1.checked[x-1]=true then wariantQ[RowsPq,x]:=true else wariantQ[RowsPq,x]:=false;
      end;
  PreRowsPq:=RowsPq; for u:=1 to Le do Zaznaczonypret[u]:=false; for u:=1 to Lw do Zaznaczonywezel[u]:=false; close; end
  else MessageDlg('Ostrzeżenie', 'xk musi być większe od xp!', mtError, [mbOK], 0);
end;

procedure TForm3.Button20Click(Sender: TObject);
begin
  Popupmenu1.PopUp;
  floatspinedit2.setfocus;
end;

procedure TForm3.Button2Click(Sender: TObject);
begin
  floatspinedit2.value:=-floatspinedit2.value;
end;

procedure TForm3.Button17Click(Sender: TObject);
begin
  u:=0;
  for u:=Le downto 1 do
    if zaznaczonypret[u]=True then
    begin
      if Lx[u]<>0 then v:=-arctan(Ly[u]/Lx[u])*180/pi() else v:=-90*abs(Ly[u])/Ly[u];
    end;
    if v<0 then v:=v+360;
    blabla:=floattostrf(v,fffixed,10,6);
    trackbar3.position:=trunc(v);
    floatspinedit5.text:=blabla; floatspinedit5.text:=blabla;
    floatspinedit5.setfocus;
    floatspinedit5.selectall;
end;

end.

