unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm2 = class(TForm)
    Label1: TLabel;
    EdtComp: TEdit;
    Label2: TLabel;
    EdtLar: TEdit;
    Label3: TLabel;
    EdtAlt: TEdit;
    Label4: TLabel;
    BtnCalc: TButton;
    Label6: TLabel;
    EdtVol: TEdit;
    Button1: TButton;
    Button2: TButton;
    procedure BtnCalcClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.BtnCalcClick(Sender: TObject);
var
n1, n2, n3, res : double;
begin
n1 := STRTOFLOAT(EdtComp.Text);
n2 := STRTOFLOAT(EdtLar.Text);
n3 := STRTOFLOAT(EdtAlt.Text);
res := n1*n2*n3;
EdtVol.Text:=FLOATTOSTR(res);

end;

procedure TForm2.Button1Click(Sender: TObject);
begin
EdtAlt.text:='';
EdtComp.text:='';
EdtLar.text:='';
EdtVol.Text:='RESULTADO';
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
form2.Close;
end;

end.
