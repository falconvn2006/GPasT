// 2. Leia o denominador e o numerador, resolva o cálculo com os
// valores informados.

unit Unit12;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm3 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

procedure TForm3.Button1Click(Sender: TObject);
var
  denominador: double;
  numerador: double;
  calculo: double;

begin
  denominador := StrToFloat(Edit1.Text);
  numerador := StrToFloat(Edit2.Text);
  calculo := numerador / denominador;

  Label1.Caption := FloatToStr(calculo);

end;

end.
