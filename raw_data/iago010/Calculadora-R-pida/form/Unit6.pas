unit Unit6;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm6 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    EdtMed: TEdit;
    EdtN1: TEdit;
    EdtN2: TEdit;
    EdtN3: TEdit;
    EdtN4: TEdit;
    BtnCalc: TButton;
    GroupBox1: TGroupBox;
    Label7: TLabel;
    Button1: TButton;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    procedure BtnCalcClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form6: TForm6;

implementation

{$R *.dfm}

procedure TForm6.BtnCalcClick(Sender: TObject);
var
N1, N2, N3, N4, med, res : double;
begin
N1 := STRTOFLOAT(EdtN1.Text);
N2 := STRTOFLOAT(EdtN2.Text);
N3 := STRTOFLOAT(EdtN3.Text);
N4 := STRTOFLOAT(EdtN4.Text);
med := STRTOFLOAT(EdtMed.Text);
if med <= (n1+n2+n3+n4)/4 then
label7.caption:='Média Atingida - Aprovado'
else
label7.caption:='Média Não Atingida - Reprovado';
 res := (n1+n2+n3+n4)/4;
 label10.Caption:=FLOATTOSTR(res);
end;

procedure TForm6.Button1Click(Sender: TObject);
begin
form6.Close;
end;

end.
