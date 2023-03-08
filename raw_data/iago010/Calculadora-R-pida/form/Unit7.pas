unit Unit7;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm7 = class(TForm)
    Memo1: TMemo;
    Edit1: TEdit;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    BtnFechar: TButton;
    BtnLimpar: TButton;
    procedure Button1Click(Sender: TObject);
    procedure BtnLimparClick(Sender: TObject);
    procedure BtnFecharClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form7: TForm7;

implementation

{$R *.dfm}

procedure TForm7.Button1Click(Sender: TObject);
var
n, res : double;
y : integer;
begin
n := STRTOFLOAT(Edit1.Text);
for y := 1 to 30 do
begin
res:=n*y;
memo1.Lines.Add(FloatToStr(n)+' X '+FloatToStr(y)+' = '+FloatToStr(res));
end;


end;

procedure TForm7.BtnLimparClick(Sender: TObject);
begin
Memo1.Clear;
end;

procedure TForm7.BtnFecharClick(Sender: TObject);
begin
form7.close;
end;

end.
