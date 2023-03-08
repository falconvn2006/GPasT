unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    But: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    sem: TButton;
    ymnozhit: TButton;
    Button11: TButton;
    STEPAN: TButton;
    delit: TButton;
    vosem: TButton;
    devyat: TButton;
    tyt: TButton;
    minus: TButton;
    Button4: TButton;
    Button7: TButton;
    nol: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    GO: TButton;
    IZI: TButton;
    kliptomaka2: TButton;
    kliptomaka: TButton;
    procedure ButClick(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure delitClick(Sender: TObject);
    procedure deleteClick(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure STEPANClick(Sender: TObject);
    procedure ymnozhitClick(Sender: TObject);
    procedure devyatClick(Sender: TObject);
    procedure semClick(Sender: TObject);
    procedure vosemClick(Sender: TObject);
    procedure tytClick(Sender: TObject);
    procedure minusClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure skobkiClick(Sender: TObject);
    procedure tochkaClick(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure nolClick(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure IZIClick(Sender: TObject);
    procedure GOClick(Sender: TObject);
    procedure kliptomaka2Click(Sender: TObject);
    procedure kliptomakaClick(Sender: TObject);
  private
    { private declarations }
    a: array[1..100] of String;
  public
    { public declarations }
  end;

var
  Form1: TForm1;
  b, c, g, t: integer;


implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.kliptomakaClick(Sender: TObject);
begin
  Edit1.Text:= Edit1.Text+'1';
 // a:= 1;   kjblklkblblk
end;

procedure TForm1.kliptomaka2Click(Sender: TObject);
begin
  Edit1.Text:=Edit1.Text+'2';
  b:= 2;

end;

procedure TForm1.GOClick(Sender: TObject);
begin
   Edit1.Text:=Edit1.Text+'3';
   c:= 3;
end;

procedure TForm1.IZIClick(Sender: TObject);
begin
     Edit1.Text:=Edit1.Text+'4';
     g:= 4;
end;

procedure TForm1.Edit1Change(Sender: TObject);
begin

end;

procedure TForm1.FormCreate(Sender: TObject);
begin

end;

procedure TForm1.tytClick(Sender: TObject);
begin
   Edit1.Text:=Edit1.Text+'6';
end;

procedure TForm1.minusClick(Sender: TObject);
begin
  a[1] := Edit1.Text;
     a[2] :='-';
     Edit2.Text := Edit1.Text + a[2];
     Edit1.Text := '';
end;

procedure TForm1.ButClick(Sender: TObject);
begin
   Edit1.Text:=Edit1.Text+'5';
end;

procedure TForm1.Button11Click(Sender: TObject);
begin

  Edit1.Text := copy( Edit1.Text, 1, length(Edit1.Text) - 1);

end;

procedure TForm1.delitClick(Sender: TObject);
begin
  a[1] := Edit1.Text;
     a[2] :='/';
     Edit2.Text := Edit1.Text + a[2];
     Edit1.Text := '';
end;

procedure TForm1.deleteClick(Sender: TObject);
begin
  a[1] := Edit1.Text;
     a[2] :='%';
     Edit2.Text := Edit1.Text + a[2];
     Edit1.Text := '';
end;

procedure TForm1.Edit2Change(Sender: TObject);
begin

end;

procedure TForm1.STEPANClick(Sender: TObject);
begin
  a[1] := Edit1.Text;
     a[2] :='X^';
     Edit2.Text := Edit1.Text + a[2];
     Edit1.Text := '';
end;

procedure TForm1.ymnozhitClick(Sender: TObject);
begin
  a[1] := Edit1.Text;
     a[2] :='*';
     Edit2.Text := Edit1.Text + a[2];
     Edit1.Text := '';
end;

procedure TForm1.devyatClick(Sender: TObject);
begin
   Edit1.Text:=Edit1.Text+'9';
end;

procedure TForm1.semClick(Sender: TObject);
begin
   Edit1.Text:=Edit1.Text+'7';
end;

procedure TForm1.vosemClick(Sender: TObject);
begin
   Edit1.Text:=Edit1.Text+'8';
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
     a[1] := Edit1.Text;
     a[2] :='+';
     Edit2.Text := Edit1.Text + a[2];
     Edit1.Text := '';
end;

procedure TForm1.skobkiClick(Sender: TObject);
begin

end;

procedure TForm1.Button7Click(Sender: TObject);
var
  p, n, i, o: integer;
begin
   a[3] := Edit1.Text;
   case a[2] of
   '+' :Edit1.Text :=IntToStr( strtoint(a[1]) + StrToInt ( a[3]) );
   '-' :Edit1.Text :=IntToStr( StrToInt(a[1]) - StrToInt ( a[3]) );
   '*' :Edit1.Text :=IntToStr( StrToInt(a[1]) * StrToInt ( a[3]) );
   '/' :Edit1.Text :=FloatToStr( StrToFloat(a[1]) / StrToFloat ( a[3]) );
   'X^': begin
          o:=strtoint(a[1]);
          p := o;
          n := strtoint(a[3]);
          for i :=2 to n do
            p:=p*o;
          Edit1.Text:= IntToStr(p);
         end;
   else
     Edit1.Text := 'Ошибка!'
   end;


//  Edit1.Text := IntToStr( c);

end;


procedure TForm1.tochkaClick(Sender: TObject);
begin

end;

procedure TForm1.nolClick(Sender: TObject);
begin
  Edit1.Text:= Edit1.Text+'0'
end;

end.

