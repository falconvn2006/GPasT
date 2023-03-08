unit FenetrePrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.ExtCtrls, Vcl.ToolWin;

type
    TCalculatrice = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button0: TButton;
    ButtonPlus: TButton;
    ButtonMinus: TButton;
    ButtonMult: TButton;
    ButtonDiv: TButton;
    ButtonClear: TButton;
    editResult: TEdit;
    ButtonEqual: TButton;
    ButtonDecim: TButton;
    Title: TLabel;
    procedure Button0Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure ButtonEqualClick(Sender: TObject);
    procedure ButtonPlusClick(Sender: TObject);
    procedure ButtonMinusClick(Sender: TObject);
    procedure ButtonMultClick(Sender: TObject);
    procedure ButtonDivClick(Sender: TObject);
    procedure ButtonClearClick(Sender: TObject);
    procedure ButtonDecimClick(Sender: TObject);
  private
  var num1, num2, result: Double;
  operation: Char;
    { D�clarations priv�es }
  public
    { D�clarations publiques }
  end;

var
  Calculatrice: TCalculatrice;

implementation

{$R *.dfm}

procedure TCalculatrice.Button0Click(Sender: TObject);
begin
  editResult.Text := editResult.Text + '0';
end;

procedure TCalculatrice.Button1Click(Sender: TObject);
begin
  editResult.Text := editResult.Text + '1';
end;

procedure TCalculatrice.Button2Click(Sender: TObject);
begin
  editResult.Text := editResult.Text + '2';
end;

procedure TCalculatrice.Button3Click(Sender: TObject);
begin
  editResult.Text := editResult.Text + '3';
end;

procedure TCalculatrice.Button4Click(Sender: TObject);
begin
  editResult.Text := editResult.Text + '4';
end;

procedure TCalculatrice.Button5Click(Sender: TObject);
begin
  editResult.Text := editResult.Text + '5';
end;

procedure TCalculatrice.Button6Click(Sender: TObject);
begin
  editResult.Text := editResult.Text + '6';
end;

procedure TCalculatrice.Button7Click(Sender: TObject);
begin
  editResult.Text := editResult.Text + '7';
end;

procedure TCalculatrice.Button8Click(Sender: TObject);
begin
  editResult.Text := editResult.Text + '8';
end;

procedure TCalculatrice.Button9Click(Sender: TObject);
begin
  editResult.Text := editResult.Text + '9';
end;

procedure TCalculatrice.ButtonClearClick(Sender: TObject);
begin
editResult.Text := '';
end;

procedure TCalculatrice.ButtonDecimClick(Sender: TObject);
begin
editResult.Text := editResult.Text + ',';
end;

procedure TCalculatrice.ButtonDivClick(Sender: TObject);
begin
  operation := '/';
  num1 := StrToFloat(editResult.Text);
  editResult.Text := '';
end;

procedure TCalculatrice.ButtonEqualClick(Sender: TObject);

begin
   num2 := StrToFloat(editResult.Text);

if (operation = '/') and (num2 = 0) then
  begin
  ShowMessage('Op�ration interdite : Division par z�ro');
    exit;
  end;

  case operation of
    '+': result := num1 + num2;
    '-': result := num1 - num2;
    '*': result := num1 * num2;
    '/': result := num1 / num2;
  end;

  editResult.Text := FloatToStr(result);
end;

procedure TCalculatrice.ButtonMinusClick(Sender: TObject);

begin
  operation := '-';
  num1 := StrToFloat(editResult.Text);
  editResult.Text := '';
end;

procedure TCalculatrice.ButtonMultClick(Sender: TObject);

begin
  operation := '*';
  num1 := StrToFloat(editResult.Text);
  editResult.Text := '';
end;

procedure TCalculatrice.ButtonPlusClick(Sender: TObject);

begin
  operation := '+';
  num1 := StrToFloat(editResult.Text);
  editResult.Text := '';
end;

end.
