unit Unit4;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, maskedit, CheckLst, Spin;

type

  { TForm4 }

  TForm4 = class(TForm)
    Button1: TButton;
    Button10: TButton;
    Button12: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    CheckListBox1: TCheckListBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    FloatSpinEdit1: TFloatSpinEdit;
    FloatSpinEdit2: TFloatSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    TrackBar1: TTrackBar;
    procedure Button10Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure FloatSpinEdit2Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure floatspinedit1Change(Sender: TObject);
    procedure edit1Change(Sender: TObject);
    procedure edit2Change(Sender: TObject);
    procedure edit3Change(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure TrackBar1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form4: TForm4;
  u:byte;
  v:real;
  buforx,bufory,bufor:real;

implementation

{$R *.lfm}

{ TForm4 }

uses
  Unit1;

procedure TForm4.Button5Click(Sender: TObject);
begin
  floatspinedit1.value:=floatspinedit1.value-10;
end;

procedure TForm4.Button6Click(Sender: TObject);
begin
  floatspinedit1.value:=floatspinedit1.value+10;
end;

procedure TForm4.Button7Click(Sender: TObject);
begin
 floatspinedit1.value:=-floatspinedit1.value;
 floatspinedit1.setfocus;
end;

procedure TForm4.FormActivate(Sender: TObject);
begin
  edit1.Enabled:=true;
  edit2.Enabled:=true;
  edit3.Enabled:=true;
  buforx:=100000; bufory:=100000;bufor:=100000;
  for i:=1 to Le do
    if zaznaczonypret[i]=true then
    begin
      if buforx=100000 then begin buforx:=Lx[i]; edit1.text:=floattostr(buforx*form4x); end;
      if bufory=100000 then begin bufory:=Ly[i]; edit2.text:=floattostr(bufory*form4x); end;
      if bufor=100000 then begin bufor:=L[i]; edit3.text:=floattostr(bufor*form4x); end;
      if Lx[i]=0 then begin edit1.enabled:=false; edit1.Text:=''; end;
      if Ly[i]=0 then begin edit2.enabled:=false; edit2.Text:=''; end;
      if Lx[i]<>buforx then begin edit1.enabled:=false; edit1.Text:=''; end;
      if Ly[i]<>bufory then begin edit2.enabled:=false; edit2.Text:=''; end;
      if L[i]<>bufor then begin edit3.enabled:=false; edit3.Text:=''; end;
    end;
end;

procedure TForm4.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  button12.setfocus;okienko:=2;RowsPm:=PreRowsPm;form4open:=false;
end;

procedure TForm4.FormShow(Sender: TObject);
begin
  floatspinedit1.value:=form4M;
  floatspinedit2.value:=form4x;
  checklistbox1.Clear;
  if warianty>0 then for i:=1 to warianty do begin
    checklistbox1.items.Add(wariantnazwa[i]);
    if formwariant[i]=true then checklistbox1.checked[i-1]:=true else checklistbox1.checked[i-1]:=false;
  end;
  floatspinedit1.SetFocus;
  form4.Left:=form1.left+form1.Width-form4.width-10;
  form4.top:=form1.top+form1.ToolBar1.Height+70;
end;

{$-}
procedure TForm4.floatspinedit1Change(Sender: TObject);
begin
  form4M:=floatspinedit1.value;
  floatspinedit1.setfocus;
end;

procedure TForm4.floatspinedit2Change(Sender: TObject);
begin
  form4x:=floatspinedit2.value;
  if form4x<0 then form4x:=0;
  if form4x>1 then form4x:=1;
  trackbar1.position:=trunc(form4x*100);
  if (edit1.Enabled=true) and (buforx<100000) and (edit1.focused=false) then edit1.text:=floattostrf(buforx*form4x,fffixed,8,4);
  if (edit2.Enabled=true) and (bufory<100000) and (edit2.focused=false) then edit2.text:=floattostrf(bufory*form4x,fffixed,8,4);
  if (edit3.Enabled=true) and (bufor<100000) and (edit3.focused=false) then edit3.text:=floattostrf(bufor*form4x,fffixed,8,4);
  if button10.Focused=true then floatspinedit2.setfocus;
end;

procedure TForm4.edit1Change(Sender: TObject);
var buff:real;
begin
  trystrtofloat(edit1.text,buff);
  if (edit1.Focused=true) and (buforx<>0) then floatspinedit2.value:=buff/buforx;
end;

procedure TForm4.edit2Change(Sender: TObject);
var buff:real;
begin
  trystrtofloat(edit2.text,buff);
  if (edit2.Focused=true) and (bufory<>0)  then floatspinedit2.value:=buff/bufory;
end;

procedure TForm4.edit3Change(Sender: TObject);
var buff:real;
begin
  trystrtofloat(edit3.text,buff);
  if (edit3.Focused=true) and (bufor<>0)  then floatspinedit2.value:=buff/bufor;
end;

{$+}

procedure TForm4.TrackBar1Change(Sender: TObject);
begin
  if trackbar1.focused=true then floatspinedit2.value:=trackbar1.Position/100;
end;

procedure TForm4.TrackBar1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  floatspinedit2.setfocus;
end;

procedure TForm4.Button10Click(Sender: TObject);
begin
  floatspinedit2.value:=1-floatspinedit2.value;
  floatspinedit2.setfocus;
end;

procedure TForm4.Button12Click(Sender: TObject);
begin
  anulowano:=true; close;
end;

procedure TForm4.Button1Click(Sender: TObject);
begin
  button1.setfocus;
  form4M:=floatspinedit1.value;
  form4x:=floatspinedit2.value;
  RowsPm:=PreRowsPm;
  for u:=1 to Le do
    if Zaznaczonypret[u]=true then begin
      RowsPm:=RowsPm+1;
      Pm[RowsPm]:=form4M;
      xm[RowsPm]:=form4x;
      nm[RowsPm]:=u;
      wariantM[RowsPm,0]:=true;
      for x:=1 to warianty do if checklistbox1.checked[x-1]=true then wariantM[RowsPm,x]:=true else wariantM[RowsPm,x]:=false;
    end;
  PreRowsPm:=RowsPm;for u:=1 to Le do Zaznaczonypret[u]:=false; for u:=1 to Lw do Zaznaczonywezel[u]:=false; close;
end;


end.

