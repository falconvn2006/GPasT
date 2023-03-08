unit Calculadora;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons;

type
  Tfrm_calculadora = class(TForm)
    btn_7: TButton;
    btn_9: TButton;
    btn_8: TButton;
    btn_multi: TButton;
    btn_4: TButton;
    btn_6: TButton;
    btn_5: TButton;
    btn_subtrai: TButton;
    btn_1: TButton;
    btn_3: TButton;
    btn_2: TButton;
    btn_soma: TButton;
    btn_0: TButton;
    btn_virgula: TButton;
    btn_result: TButton;
    btn_limpa: TButton;
    btn_apaga: TButton;
    btn_divide: TButton;
    lb_operador: TLabel;
    lb_v2: TLabel;
    lb_v1: TLabel;
    procedure btn_resultClick(Sender: TObject);
    procedure btn_divideClick(Sender: TObject);
    procedure btn_multiClick(Sender: TObject);
    procedure btn_subtraiClick(Sender: TObject);
    procedure btn_somaClick(Sender: TObject);
    procedure btn_1Click(Sender: TObject);
    procedure btn_2Click(Sender: TObject);
    procedure btn_3Click(Sender: TObject);
    procedure btn_4Click(Sender: TObject);
    procedure btn_5Click(Sender: TObject);
    procedure btn_6Click(Sender: TObject);
    procedure btn_7Click(Sender: TObject);
    procedure btn_8Click(Sender: TObject);
    procedure btn_9Click(Sender: TObject);
    procedure btn_limpaClick(Sender: TObject);
    procedure btn_0Click(Sender: TObject);
    procedure btn_virgulaClick(Sender: TObject);
    procedure btn_apagaClick(Sender: TObject);
    procedure Limpar();

  private

  public

  end;

var
  frm_calculadora: Tfrm_calculadora;

implementation

{$R *.dfm}

// Procedures dos bot�es num�ricos

procedure Tfrm_calculadora.btn_0Click(Sender: TObject);
begin

  if lb_operador.Caption = '.' then
  begin
    lb_v1.Caption := lb_v1.Caption + '0';
  end
  else
  begin
    lb_v2.Caption := lb_v2.Caption + '0';
  end;

end;

procedure Tfrm_calculadora.btn_1Click(Sender: TObject);
begin

  if lb_operador.Caption = '.' then
  begin
    lb_v1.Caption := lb_v1.Caption + '1';
  end
  else
  begin
    lb_v2.Caption := lb_v2.Caption + '1';
  end;

end;

procedure Tfrm_calculadora.btn_2Click(Sender: TObject);
begin

  if lb_operador.Caption = '.' then
  begin
    lb_v1.Caption := lb_v1.Caption + '2';
  end
  else
  begin
    lb_v2.Caption := lb_v2.Caption + '2';
  end;

end;

procedure Tfrm_calculadora.btn_3Click(Sender: TObject);
begin

  if lb_operador.Caption = '.' then
  begin
    lb_v1.Caption := lb_v1.Caption + '3';
  end
  else
  begin
    lb_v2.Caption := lb_v2.Caption + '3';
  end;

end;

procedure Tfrm_calculadora.btn_4Click(Sender: TObject);
begin

  if lb_operador.Caption = '.' then
  begin
    lb_v1.Caption := lb_v1.Caption + '4';
  end
  else
  begin
    lb_v2.Caption := lb_v2.Caption + '4';
  end;

end;

procedure Tfrm_calculadora.btn_5Click(Sender: TObject);
begin

  if lb_operador.Caption = '.' then
  begin
    lb_v1.Caption := lb_v1.Caption + '5';
  end
  else
  begin
    lb_v2.Caption := lb_v2.Caption + '5';
  end;

end;

procedure Tfrm_calculadora.btn_6Click(Sender: TObject);
begin

  if lb_operador.Caption = '.' then
  begin
    lb_v1.Caption := lb_v1.Caption + '6';
  end
  else
  begin
    lb_v2.Caption := lb_v2.Caption + '6';
  end;

end;

procedure Tfrm_calculadora.btn_7Click(Sender: TObject);
begin

  if lb_operador.Caption = '.' then
  begin
    lb_v1.Caption := lb_v1.Caption + '7';
  end
  else
  begin
    lb_v2.Caption := lb_v2.Caption + '7';
  end;

end;

procedure Tfrm_calculadora.btn_8Click(Sender: TObject);
begin

  if lb_operador.Caption = '.' then
  begin
    lb_v1.Caption := lb_v1.Caption + '8';
  end
  else
  begin
    lb_v2.Caption := lb_v2.Caption + '8';
  end;

end;

procedure Tfrm_calculadora.btn_9Click(Sender: TObject);
begin

  if lb_operador.Caption = '.' then
  begin
    lb_v1.Caption := lb_v1.Caption + '9';
  end
  else
  begin
    lb_v2.Caption := lb_v2.Caption + '9';
  end;

end;

// Procedures dos bot�es operadores

// divide
procedure Tfrm_calculadora.btn_divideClick(Sender: TObject);
begin
  lb_operador.Caption := '/';
end;

// multiplica
procedure Tfrm_calculadora.btn_multiClick(Sender: TObject);
begin
  lb_operador.Caption := 'X';
end;

// soma
procedure Tfrm_calculadora.btn_somaClick(Sender: TObject);
begin
  lb_operador.Caption := '+';
end;

// subtrai
procedure Tfrm_calculadora.btn_subtraiClick(Sender: TObject);
begin
  lb_operador.Caption := '-';
end;

// Procedure bot�o apagar

procedure Tfrm_calculadora.btn_apagaClick(Sender: TObject);
begin

  if lb_operador.Caption = '.' then
  begin
    lb_v1.Caption := copy(lb_v1.Caption, 0, length(lb_v1.Caption) - 1);
  end
  else
  begin
    lb_v2.Caption := copy(lb_v2.Caption, 0, length(lb_v2.Caption) - 1);
  end;

end;

// Procedure bot�o de virgula

procedure Tfrm_calculadora.btn_virgulaClick(Sender: TObject);
begin

  if lb_operador.Caption = '.' then
  begin
    lb_v1.Caption := lb_v1.Caption + ',';
  end
  else
  begin
    lb_v2.Caption := lb_v2.Caption + ',';
  end;

end;

// Procedure do bot�o limpar (C)

procedure Tfrm_calculadora.btn_limpaClick(Sender: TObject);
begin
  // Chama a fun��o limpar
  Limpar();
end;

// Procedure do bot�o igual (=)

procedure Tfrm_calculadora.btn_resultClick(Sender: TObject);
var v1, v2 : double;
var x : char;
begin
  v1 := StrToFloat(lb_v1.Caption);
  v2 := StrToFloat(lb_v2.Caption);

  // Alternativa usando if

//  if lb_operador.Caption = '+' then
//  begin
//    ShowMessage(FloatToStr(v1 + v2));
//  end;
//
//  if lb_operador.Caption = '/' then
//  begin
//    ShowMessage(FloatToStr(v1 / v2));
//  end;
//
//  if lb_operador.Caption = 'X' then
//  begin
//    ShowMessage(FloatToStr(v1 * v2));
//  end;
//
//  if lb_operador.Caption = '-' then
//  begin
//    ShowMessage(FloatToStr(v1 - v2));
//  end;

  // Aqui usamos o case

  x := lb_operador.Caption[1];
  case x of

    '+' : begin
      ShowMessage(FloatToStr(v1 + v2));
    end;

    '-' : begin
      ShowMessage(FloatToStr(v1 - v2));
    end;

     'X' : begin
      ShowMessage(FloatToStr(v1 * v2));
    end;

     '/' : begin
      ShowMessage(FloatToStr(v1 / v2));
    end;

  end;

  // Chama a fun��o limpar
  Limpar();
end;

// Limpa os labels ap�s o resultado final
procedure Tfrm_calculadora.Limpar();
begin
  lb_v1.Caption := '';
  lb_v2.Caption := '';
  lb_operador.Caption := '.';
end;

end.
