unit U_hotpaes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    Label4: TLabel;
    Edit4: TEdit;
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
broas:double;
paes:double;
desconto:double;
result:double;
begin
broas:=strtofloat(edit1.text) * 0.12;
paes:=strtofloat(edit2.text) * 1.50;
result:= paes + broas;
desconto:=(10 * result) / 100;
edit3.text:=floattostr(desconto);
edit4.Text:= floattostr(result);
end;

end.
