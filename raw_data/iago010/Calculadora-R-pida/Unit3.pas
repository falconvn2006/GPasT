unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm3 = class(TForm)
    Edit1: TEdit;
    Label2: TLabel;
    Button1: TButton;
    Edit2: TEdit;
    Button2: TButton;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

uses Unit2;

{$R *.dfm}

procedure TForm3.Button1Click(Sender: TObject);
var
f,c: double;
begin
C:= STRTOFLOAT(Edit1.Text);
f:=(9*c+160)/5;
Edit2.text:=floattostr(f);
end;

procedure TForm3.Button2Click(Sender: TObject);
begin
form3.Close;
end;

end.
