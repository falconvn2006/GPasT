unit uFFundamentos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, math,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.StdCtrls;

type
  TFFundamentos = class(TForm)
    pcMenuPrincipal: TPageControl;
    TabAchivo: TTabSheet;
    Panel1: TPanel;
    Panel2: TPanel;
    sbOperaciones: TSpeedButton;
    mSalida: TMemo;
    Panel3: TPanel;
    sbSumarNumeros: TSpeedButton;
    Panel4: TPanel;
    Panel5: TPanel;
    gbNum2: TGroupBox;
    edNum2: TEdit;
    gbNum1: TGroupBox;
    edNum1: TEdit;
    Panel6: TPanel;
    sbCalcularTeoremaPitagoras: TSpeedButton;
    Panel7: TPanel;
    Panel8: TPanel;
    gbCatB: TGroupBox;
    edCatB: TEdit;
    gbCatA: TGroupBox;
    edCatA: TEdit;
    procedure sbSumarNumerosClick(Sender: TObject);
    procedure sbOperacionesClick(Sender: TObject);
    procedure edNum2KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure sbCalcularTeoremaPitagorasClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FFundamentos: TFFundamentos;

implementation

{$R *.dfm}

procedure TFFundamentos.edNum2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = $0D then
  begin
    sbOperacionesClick(Self);
  end;
end;

procedure TFFundamentos.sbCalcularTeoremaPitagorasClick(Sender: TObject);
var
  a, b, h: real; { Definimos las variables para resolver el problema }
begin
  { Obtener valores de las cajas }
  a := StrToFloat(edCatA.Text);
  b := StrToFloat(edCatB.Text);

  h := sqrt(power(a, 2) + power(b, 2));

  mSalida.Lines.Add('=========Teorema de Pitágoras=========');
  mSalida.Lines.Add('Cateto A = ' + FloatToStr(a) + ' y Cateto B = ' + FloatToStr(b) +
    ' generan la hipotenusa ' + ' = ' + FloatToStr(h));
end;

procedure TFFundamentos.sbOperacionesClick(Sender: TObject);
var
  a, b, c: integer; { se definen las variables de tipo integer
    que van desde -2147483648..2147483647; }
  d: real;
begin
  { tomar los valores de las cajas de texto mediante la función
    String to Integer => StrToInt }
  a := StrToInt(edNum1.Text);
  b := StrToInt(edNum2.Text);

  mSalida.Lines.Add('=========Calculadora======================');

  c := a + b;
  mSalida.Lines.Add(IntToStr(a) + ' + ' + IntToStr(b) + ' = ' + IntToStr(c));

  c := a - b;
  mSalida.Lines.Add(IntToStr(a) + ' - ' + IntToStr(b) + ' = ' + IntToStr(c));

  c := a * b;
  mSalida.Lines.Add(IntToStr(a) + ' * ' + IntToStr(b) + ' = ' + IntToStr(c));

  // Esta linea corresponde al video 005

  d := a / b;
  mSalida.Lines.Add(IntToStr(a) + ' / ' + IntToStr(b) + ' = ' + FloatToStr(d));

end;

procedure TFFundamentos.sbSumarNumerosClick(Sender: TObject);
var
  a, b, c: Word; { Se estan definiendo los tipos de variable de tipo entero que
    contiene valores entre 0 y 65535 }
begin
  a := 5478;
  b := 6234;

  // CTRL + D formatea el codigo
  // Definimos la suma
  c := a + b;

  // Mostrar en pantalla (IntToStr) => Integer to String IntToStr

  mSalida.Lines.Add(IntToStr(a) + ' + ' + IntToStr(b) + ' = ' + IntToStr(c));
end;

end.

// CTRL + SHIFT + F9 compila
