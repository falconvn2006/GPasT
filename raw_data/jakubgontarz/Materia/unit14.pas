unit Unit14;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls;

type

  { TForm14 }

  TForm14 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Image1: TImage;
    StaticText1: TStaticText;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form14: TForm14;
  wym1,wym2,wym3,wym4,wym5,wym6:real;

implementation

uses
  unit1;

{$R *.lfm}

{ TForm14 }

procedure TForm14.Button1Click(Sender: TObject);
begin
  close;
end;

procedure TForm14.Button2Click(Sender: TObject);
var   hh:integer;
begin
  button2.setfocus;
  trystrtofloat(edit1.text,wym1);
  trystrtofloat(edit2.text,wym2);
  trystrtofloat(edit3.text,wym3);
  trystrtofloat(edit4.text,wym4);
  trystrtofloat(edit5.text,wym5);
  trystrtofloat(edit6.text,wym6);
  if (wym1<=0) or (wym2<=0) or (wym3<=0) or (wym4<=0) or (wym5<=0) or (wym6<=0) then
  MessageDlg('Ostrzeżenie!', 'Wymiary muszą być większe od 0.', mtwarning, [mbOK], 0)  else
    begin
      Lw:=Lw+16;
      Le:=Le+16;
      Xw[Lw-15]:=1000;                       Yw[Lw-15]:=1000;
      Xw[Lw-14]:=1000+wym4;                  Yw[Lw-14]:=1000;
      Xw[Lw-13]:=1000+wym4+wym5;             Yw[Lw-13]:=1000;
      Xw[Lw-12]:=1000+wym4+wym5+wym6;        Yw[Lw-12]:=1000;
      Xw[Lw-11]:=1000+wym4-wym3;             Yw[Lw-11]:=1002;
      Xw[Lw-10]:=1000+wym4;                  Yw[Lw-10]:=1002;
      Xw[Lw-9]:=1000+wym4+wym2;              Yw[Lw-9]:=1002;
      Xw[Lw-8]:=1000+wym4+wym2+wym1;         Yw[Lw-8]:=1002;
      Xw[Lw-7]:=1000+wym4+wym5-wym3;         Yw[Lw-7]:=1001;
      Xw[Lw-6]:=1000+wym4+wym5;              Yw[Lw-6]:=1001;
      Xw[Lw-5]:=1000+wym4+wym5+wym2;         Yw[Lw-5]:=1001;
      Xw[Lw-4]:=1000+wym4+wym5+wym2+wym1;   Yw[Lw-4]:=1001;
      Xw[Lw-3]:=1000+wym2;                   Yw[Lw-3]:=1003;
      Xw[Lw-2]:=1000+wym2+wym4;              Yw[Lw-2]:=1003;
      Xw[Lw-1]:=1000+wym2+wym4+wym5;         Yw[Lw-1]:=1003;
      Xw[Lw  ]:=1000+wym2+wym4+wym5+wym6;    Yw[Lw]:=1003;
      Wp[Le-15]:=Lw-15; Wk[Le-15]:=Lw-14;
      Wp[Le-14]:=Lw-14; Wk[Le-14]:=Lw-13;
      Wp[Le-13]:=Lw-13; Wk[Le-13]:=Lw-12;
      Wp[Le-12]:=Lw-11; Wk[Le-12]:=Lw-10;
      Wp[Le-11]:=Lw-10; Wk[Le-11]:=Lw-9;
      Wp[Le-10]:=Lw-9; Wk[Le-10]:=Lw-8;
      Wp[Le-9]:=Lw-7; Wk[Le-9]:=Lw-6;
      Wp[Le-8]:=Lw-6; Wk[Le-8]:=Lw-5;
      Wp[Le-7]:=Lw-5; Wk[Le-7]:=Lw-4;
      Wp[Le-6]:=Lw-3; Wk[Le-6]:=Lw-2;
      Wp[Le-5]:=Lw-2; Wk[Le-5]:=Lw-1;
      Wp[Le-4]:=Lw-1; Wk[Le-4]:=Lw;
      Wp[Le-3]:=Lw-14; Wk[Le-3]:=Lw-10;
      Wp[Le-2]:=Lw-13; Wk[Le-2]:=Lw-6;
      Wp[Le-1]:=Lw-9; Wk[Le-1]:=Lw-2;
      Wp[Le]:=Lw-5; Wk[Le]:=Lw-1;
      for hh:=Le-15 to Le-4 do typs[hh]:=1;
      for hh:=Le-3 to Le do typs[hh]:=4;
      noweLw:=16;noweLe:=16;
      form14open:=true; close;
    end;
end;

procedure TForm14.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  button1.setfocus;
end;

end.

