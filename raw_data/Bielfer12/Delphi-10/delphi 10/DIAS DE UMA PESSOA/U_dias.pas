unit U_dias;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Button1: TButton;
    Edit3: TEdit;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
nome:string;
idade:double;
result:double;
begin
nome:=(edit1.text);
idade:=strtofloat(edit2.text) * 365;
result:=idade;
//edit3.text:=floattostr(result);
showmessage('O nome da pessoa é ' + nome + ' e ela viveu ' + floattostr(result));

end;

end.
