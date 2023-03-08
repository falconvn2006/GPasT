unit Unit5;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  maskedit, Menus, CheckLst, Spin;

type

  { TForm5 }

  TForm5 = class(TForm)
    Button1: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button16: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button9: TButton;
    CheckListBox1: TCheckListBox;
    FloatSpinEdit1: TFloatSpinEdit;
    FloatSpinEdit2: TFloatSpinEdit;
    Label1: TLabel;
    Label12: TLabel;
    Label2: TLabel;
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure floatspinedit1Change(Sender: TObject);
    procedure floatspinedit2Change(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form5: TForm5;
  u:byte;
  v:real;

implementation

{$R *.lfm}

uses
  Unit1;

{ TForm5 }

procedure TForm5.Button10Click(Sender: TObject);
begin
   floatspinedit2.value:=floatspinedit2.value+10;
end;

procedure TForm5.Button16Click(Sender: TObject);
begin
  anulowano:=true; close;
end;

procedure TForm5.Button1Click(Sender: TObject);
begin
  button1.setfocus;
  form5g:=floatspinedit1.value;
  form5d:=floatspinedit2.value;
  RowsPt:=PreRowsPt;
  for u:=1 to Le do
    if Zaznaczonypret[u]=true then begin
      RowsPt:=RowsPt+1;
      Tg[RowsPt]:=form5g;
      Td[RowsPt]:=form5d;
      nt[RowsPt]:=u;
      wariantT[RowsPt,0]:=true;
      for x:=1 to warianty do if checklistbox1.checked[x-1]=true then wariantT[RowsPt,x]:=true else wariantT[RowsPt,x]:=false;
    end;
  PreRowsPt:=RowsPt; for u:=1 to Le do Zaznaczonypret[u]:=false; for u:=1 to Lw do Zaznaczonywezel[u]:=false; close;
end;

procedure TForm5.Button5Click(Sender: TObject);
begin
   floatspinedit1.value:=floatspinedit1.value-10;
end;

procedure TForm5.Button6Click(Sender: TObject);
begin
  floatspinedit1.value:=floatspinedit1.value+10;
end;

procedure TForm5.Button9Click(Sender: TObject);
begin
 floatspinedit2.value:=floatspinedit2.value-10;
end;

procedure TForm5.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  button16.setfocus;okienko:=2;RowsPt:=PreRowsPt;form5open:=false;
end;

procedure TForm5.FormShow(Sender: TObject);
begin
  floatspinedit1.value:=form5g;
  floatspinedit2.value:=form5d;
  checklistbox1.Clear;
  if warianty>0 then for i:=1 to warianty do begin
    checklistbox1.items.Add(wariantnazwa[i]);
    if formwariant[i]=true then checklistbox1.checked[i-1]:=true else checklistbox1.checked[i-1]:=false;
  end;
  floatspinedit1.SetFocus;
  form5.Left:=form1.left+form1.Width-form5.width-10;
  form5.top:=form1.top+form1.ToolBar1.Height+70;
end;

{$-}
procedure TForm5.floatspinedit1Change(Sender: TObject);
begin
  form5g:=floatspinedit1.value;
  floatspinedit1.setfocus;
end;

procedure TForm5.floatspinedit2Change(Sender: TObject);
begin
  form5d:=floatspinedit2.value;
  floatspinedit2.setfocus;
end;

procedure TForm5.Button7Click(Sender: TObject);
begin
  floatspinedit2.value:=-floatspinedit2.value;
  floatspinedit1.value:=-floatspinedit1.value;
  floatspinedit1.setfocus;
end;

procedure TForm5.Button11Click(Sender: TObject);
begin
  v:=floatspinedit1.value;
  floatspinedit1.value:=floatspinedit2.value;
  floatspinedit2.value:=v;
  floatspinedit1.setfocus;
end;

procedure TForm5.Button12Click(Sender: TObject);
begin
  floatspinedit2.value:=floatspinedit1.value;
  floatspinedit1.setfocus;
end;

{$+}

end.

