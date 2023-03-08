unit Unit7;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, maskedit, Spin;

type

  { TForm7 }

  TForm7 = class(TForm)
    Button1: TButton;
    Button10: TButton;
    Button17: TButton;
    FloatSpinEdit1: TFloatSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    SpinEdit1: TSpinEdit;
    TrackBar1: TTrackBar;
    procedure Button10Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure floatspinedit1Change(Sender: TObject);
    procedure spinedit1Change(Sender: TObject);
    procedure RadioButton1Change(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure TrackBar1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form7: TForm7;
  u,uu:byte;
  v:real;

implementation

{$R *.lfm}

{ TForm7 }

uses
  Unit1;

procedure TForm7.RadioButton1Change(Sender: TObject);
begin
  if radiobutton1.checked then begin spinedit1.enabled:=true; form7type:=true;
  button10.enabled:=false; floatspinedit1.enabled:=false; trackbar1.Enabled:=false; end;
  if not radiobutton1.checked then begin spinedit1.enabled:=false; form7type:=false;
  button10.enabled:=true; floatspinedit1.enabled:=true; trackbar1.Enabled:=true; end;
end;

procedure TForm7.TrackBar1Change(Sender: TObject);
begin
  if trackbar1.Focused=true then floatspinedit1.value:=trackbar1.position/100;
end;

procedure TForm7.TrackBar1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  floatspinedit1.setfocus;
end;

procedure TForm7.Button10Click(Sender: TObject);
begin
  floatspinedit1.value:=1-floatspinedit1.value;
  floatspinedit1.setfocus;
end;

procedure TForm7.Button17Click(Sender: TObject);
begin
  close;
end;

procedure TForm7.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  button17.setfocus;okienko:=2;form7open:=false;
end;

procedure TForm7.FormShow(Sender: TObject);
begin
  spinedit1.enabled:=true;floatspinedit1.enabled:=true;
  if radiobutton1.Checked=true then begin form7type:=true; floatspinedit1.enabled:=false; spinedit1.SetFocus; end else begin form7type:=false; spinedit1.enabled:=false; floatspinedit1.SetFocus; end;
  form7.Left:=form1.left+form1.Width-form7.width-10;
  form7.top:=form1.top+form1.ToolBar1.Height+70;
end;

{$-}
procedure TForm7.floatspinedit1Change(Sender: TObject);
begin
  form7x:=floatspinedit1.value;
  trackbar1.position:=trunc(form7x*100);
  if trackbar1.focused=false then floatspinedit1.setfocus;
end;

procedure TForm7.spinedit1Change(Sender: TObject);
begin
  form7podz:=spinedit1.value;
  spinedit1.SetFocus;
end;

{$+}

procedure TForm7.Button1Click(Sender: TObject);
var Nr,Nr2,cale:integer;
    iks:real;
begin
  button1.setfocus;
  if (form7type=true) and (form7podz>1) then
  for u:=1 to Le do if zaznaczonypret[u]=true then
  begin
    for uu:=1 to form7podz-1 do
      begin
        Xw[Lw+uu]:=(Xw[Wk[u]]-Xw[Wp[u]])*uu/form7podz+Xw[Wp[u]];
        Yw[Lw+uu]:=(Yw[Wk[u]]-Yw[Wp[u]])*uu/form7podz+Yw[Wp[u]];
      end;
    for uu:=1 to form7podz-2 do
      begin
        Wp[Le+uu]:=Lw+uu;
        Wk[Le+uu]:=Lw+uu+1;
        Prz[Le+uu]:=Prz[u];
        Typs[Le+uu]:=1;
      end;
    Wp[Le+form7Podz-1]:=Lw+form7podz-1;
    Wk[Le+form7Podz-1]:=Wk[u];
    Le:=Le+form7podz-1;
    Wk[u]:=Lw+1;
    Lw:=Lw+form7podz-1;
    Prz[Le]:=Prz[u];
    Typs[Le]:=1;
    if Typs[u]=3 then begin Typs[u]:=1; Typs[Le]:=3; end;
    if Typs[u]=4 then begin Typs[u]:=2; Typs[Le]:=3; end;
    for i:=1 to RowsPp do if np[i]=u then
      begin
        if (trunc(xp[i]*form7podz)=xp[i]*form7podz) and (xp[i]*form7podz>0) then Nr:=trunc(xp[i]*form7podz) else Nr:=trunc(xp[i]*form7podz+1);
        xp[i]:=xp[i]*form7podz-(Nr-1);
        if Nr>1 then np[i]:=Le-form7podz+Nr;
        zaznaczoneP[i]:=false;
      end;
    for i:=1 to RowsPm do if nm[i]=u then
      begin
        if (trunc(xm[i]*form7podz)=xm[i]*form7podz) and (xm[i]*form7podz>0) then Nr:=trunc(xm[i]*form7podz) else Nr:=trunc(xm[i]*form7podz+1);
        xm[i]:=xm[i]*form7podz-(Nr-1);
        if Nr>1 then nm[i]:=Le-form7podz+Nr;
        zaznaczonem[i]:=false;
      end;
    for i:=1 to RowsPt do if nt[i]=u then for uu:=1 to form7podz-1 do begin inc(rowsPt); tg[RowsPt]:=tg[u]; td[RowsPt]:=td[u]; nt[RowsPt]:=Le-form7podz+1+uu; zaznaczoneT[i]:=false;  end;
    for i:=1 to RowsPq do if nq[i]=u then
      begin
        if (trunc(xqi[i]*form7podz)=xqi[i]*form7podz) and (xqi[i]*form7podz>0) then Nr:=trunc(xqi[i]*form7podz) else Nr:=trunc(xqi[i]*form7podz+1);
        if (trunc(xqj[i]*form7podz)=xqj[i]*form7podz) and (xqj[i]*form7podz>0) then Nr2:=trunc(xqj[i]*form7podz) else Nr2:=trunc(xqj[i]*form7podz+1);
        cale:=Nr2-Nr-1;
        if Nr2>Nr+1 then for uu:=1 to cale do
          begin
            inc(RowsPq);
            xqi[RowsPq]:=0;xqj[RowsPq]:=1; alfaq[rowsPq]:=alfaq[i]; nq[RowsPq]:=Le-form7podz+Nr+uu;
            iks:=(Nr+uu-1)/form7podz;
            Pqi[RowsPq]:=(Pqj[i]-Pqi[i])/(xqj[i]-xqi[i])*(iks-xqi[i])+Pqi[i];
            Pqj[RowsPq]:=(Pqj[i]-Pqi[i])/(xqj[i]-xqi[i])*(iks+1/form7podz-xqi[i])+Pqi[i];
          end;
        if Nr>1 then nq[i]:=Le-form7podz+Nr;
        if Nr2>Nr then begin
          inc(RowsPq);
          xqj[RowsPq]:=xqj[i]*form7podz-(Nr2-1);
          nq[RowsPq]:=Le-form7podz+Nr2;
          alfaq[RowsPq]:=alfaq[i];
          Pqj[RowsPq]:=Pqj[i];
          Pqi[RowsPq]:=(Pqj[i]-Pqi[i])/(xqj[i]-xqi[i])*((Nr2-1)/form7podz-xqi[i])+Pqi[i];
          Pqj[i]:=(Pqj[i]-Pqi[i])/(xqj[i]-xqi[i])*(Nr/form7podz-xqi[i])+Pqi[i];
          xqi[RowsPq]:=0;xqj[i]:=1;
        end else begin xqj[i]:=xqj[i]*form7podz-(Nr2-1); if Nr>1 then nq[i]:=Le-form7podz+Nr; end;
        xqi[i]:=xqi[i]*form7podz-(Nr-1);
        zaznaczoneQ[i]:=false;
      end;
    v:=1000;
  end;
  if (form7type=false) and (form7x>0) and (form7x<1) then
  for u:=1 to Le do if zaznaczonypret[u]=true then
  begin
    Xw[Lw+1]:=(Xw[Wk[u]]-Xw[Wp[u]])*form7x+Xw[Wp[u]];
    Yw[Lw+1]:=(Yw[Wk[u]]-Yw[Wp[u]])*form7x+Yw[Wp[u]];
    Wp[Le+1]:=Lw+1;
    Wk[Le+1]:=Wk[u];
    Le:=Le+1;
    Wk[u]:=Lw+1;
    Lw:=Lw+1;
    Prz[Le]:=Prz[u];
    Typs[Le]:=1;
    if Typs[u]=3 then begin Typs[u]:=1; Typs[Le]:=3; end;
    if Typs[u]=4 then begin Typs[u]:=2; Typs[Le]:=3; end;
    for i:=1 to RowsPp do if np[i]=u then
      if xp[i]<=form7x then xp[i]:=xp[i]/form7x
        else begin xp[i]:=(form7x-xp[i])/(form7x-1); np[i]:=Le; end;
    for i:=1 to RowsPm do if nm[i]=u then
      if xm[i]<=form7x then xm[i]:=xm[i]/form7x
        else begin xm[i]:=(form7x-xm[i])/(form7x-1); nm[i]:=Le; end;
    for i:=1 to RowsPt do if nt[i]=u then
      begin inc(RowsPt); tg[RowsPt]:=tg[u]; td[RowsPt]:=td[u]; nt[RowsPt]:=Le; zaznaczoneT[i]:=false; end;
    for i:=1 to RowsPq do if nq[i]=u then
    begin
      if (xqi[i]<form7x) and (xqj[i]>form7x) then
        begin inc(RowsPq); Pqj[RowsPq]:=Pqj[i]; Pqi[RowsPq]:=(Pqj[i]-Pqi[i])/(xqj[i]-xqi[i])*(form7x-xqi[i])+Pqi[i]; Pqj[i]:=Pqi[RowsPq];
        alfaq[rowsPq]:=alfaq[i]; xqi[i]:=xqi[i]/form7x; xqj[RowsPq]:=(form7x-xqj[i])/(form7x-1); xqi[RowsPq]:=0;xqj[i]:=1;nq[RowsPq]:=Le end;
      if xqj[i]<=form7x then begin xqj[i]:=xqj[i]/form7x; xqi[i]:=xqi[i]/form7x; end;
      if xqi[i]>=form7x then begin xqj[i]:=(form7x-xqj[i])/(form7x-1); xqi[i]:=(form7x-xqi[i])/(form7x-1); nq[i]:=Le; end;
      zaznaczoneQ[i]:=false;
    end;
    v:=1000;
  end;
  if v=1000 then begin
  for i:=1 to Le do
   begin
     Lx[i]:=Xw[Wk[i]]-Xw[Wp[i]];
     Ly[i]:=Yw[Wk[i]]-Yw[Wp[i]];
     L[i]:=sqrt(sqr(Lx[i])+sqr(Ly[i]));
     if Lx[i]=0 then alfapr[i]:=pi()/2*abs(Ly[i])/Ly[i] else alfapr[i]:=arctan(Ly[i]/Lx[i]);
     if Lx[i]<0 then alfapr[i]:=alfapr[i]+pi();
     zaznaczonypret[i]:=false;
   end;
  for i:=1 to Lw do zaznaczonywezel[i]:=false;
  end;
  close;
  form1.sprawdzwezly;
end;

end.

