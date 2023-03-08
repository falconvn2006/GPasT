unit U_mais;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label5: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
num1:double;
num2:double;
result:double;
implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);

begin
num1:=strtofloat(edit1.text);
num2:=strtofloat(edit2.text);
result:= num1 + num2;
showmessage(floattostr(result));

end;


