unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm4 = class(TForm)
    EdtN1: TEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    EdtAcha: TEdit;
    Label1: TLabel;
    EdtResul: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Button5: TButton;
    Button6: TButton;
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}

procedure TForm4.Button4Click(Sender: TObject);
var
n1, n2, res : double;
begin
n1 := STRTOFLOAT(EdtN1.Text);
res := STRTOFLOAT(EdtResul.Text);
n2 := res-n1;
EdtAcha.Text:=FLOATTOSTR(n2);
label2.Caption:='+';
end;
procedure TForm4.Button3Click(Sender: TObject);
var
n1, n2, res : double;
begin
n1 := STRTOFLOAT(EdtN1.Text);
res := STRTOFLOAT(EdtResul.Text);
n2 := n1-res;
EdtAcha.Text:=FLOATTOSTR(n2);
label2.Caption:='-';
end;

procedure TForm4.Button2Click(Sender: TObject);
var
n1, n2, res : double;
begin
n1 := STRTOFLOAT(EdtN1.Text);
res := STRTOFLOAT(EdtResul.Text);
n2 := n1/res;
EdtAcha.Text:=FLOATTOSTR(n2);
label2.Caption:='/';
end;

procedure TForm4.Button1Click(Sender: TObject);
var
n1, n2, res : double;
begin
n1 := STRTOFLOAT(EdtN1.Text);
res := STRTOFLOAT(EdtResul.Text);
n2 := res/n1;
EdtAcha.Text:=FLOATTOSTR(n2);
label2.Caption:='*';
end;

procedure TForm4.Button5Click(Sender: TObject);
begin
form4.Close;
end;

procedure TForm4.Button6Click(Sender: TObject);
begin
EdtN1.text:='';
EdtAcha.text:='         ?   ';
EdtResul.text:='';
label2.Caption:='';
end;

end.
