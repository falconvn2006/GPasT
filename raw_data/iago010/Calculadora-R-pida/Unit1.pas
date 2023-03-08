unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Edt1: TEdit;
    Label5: TLabel;
    Edt2: TEdit;
    BtnMais: TButton;
    BtnMenos: TButton;
    BtnDiv: TButton;
    BtnMult: TButton;
    Label6: TLabel;
    EdtRes: TEdit;
    BtnLimpa: TButton;
    Button1: TButton;
    MainMenu1: TMainMenu;
    Skins1: TMenuItem;
    Amarelo1: TMenuItem;
    Azul1: TMenuItem;
    Roxo1: TMenuItem;
    Preto1: TMenuItem;
    Vermelho1: TMenuItem;
    Rosa1: TMenuItem;
    Branco1: TMenuItem;
    Cinza1: TMenuItem;
    Verde31: TMenuItem;
    PADRO1: TMenuItem;
    Verde41: TMenuItem;
    Azul21: TMenuItem;
    Rosa2: TMenuItem;
    Cinza2: TMenuItem;
    fghft1: TMenuItem;
    Marom1: TMenuItem;
    Azul31: TMenuItem;
    Sobre1: TMenuItem;
    PretoRed1: TMenuItem;
    Formulas1: TMenuItem;
    CVolume1: TMenuItem;
    CF1: TMenuItem;
    Fechar1: TMenuItem;
    OperaoInversa1: TMenuItem;
    Desenvolvimento1: TMenuItem;
    Ajuda1: TMenuItem;
    Button2: TButton;
    BtnCopia: TButton;
    CalcMdia1: TMenuItem;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Button15: TButton;
    Button16: TButton;
    Button17: TButton;
    Button18: TButton;
    Button19: TButton;
    Button20: TButton;
    Button21: TButton;
    Button22: TButton;
    Button23: TButton;
    Button24: TButton;
    Button25: TButton;
    Button26: TButton;
    Button27: TButton;
    GeradordeTabuada1: TMenuItem;
    procedure BtnMaisClick(Sender: TObject);
    procedure BtnMenosClick(Sender: TObject);
    procedure BtnDivClick(Sender: TObject);
    procedure BtnMultClick(Sender: TObject);
    procedure BtnLimpaClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Amarelo1Click(Sender: TObject);
    procedure Azul1Click(Sender: TObject);
    procedure Roxo1Click(Sender: TObject);
    procedure Preto1Click(Sender: TObject);
    procedure Vermelho1Click(Sender: TObject);
    procedure Rosa1Click(Sender: TObject);
    procedure Branco1Click(Sender: TObject);
    procedure Cinza1Click(Sender: TObject);
    procedure Verde31Click(Sender: TObject);
    procedure PADRO1Click(Sender: TObject);
    procedure Verde41Click(Sender: TObject);
    procedure Azul21Click(Sender: TObject);
    procedure Rosa2Click(Sender: TObject);
    procedure Cinza2Click(Sender: TObject);
    procedure fghft1Click(Sender: TObject);
    procedure Marom1Click(Sender: TObject);
    procedure Azul31Click(Sender: TObject);
    procedure PADRO2Click(Sender: TObject);
    procedure PretoRed1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure CVolume1Click(Sender: TObject);
    procedure CF1Click(Sender: TObject);
    procedure Fechar1Click(Sender: TObject);
    procedure OperaoInversa1Click(Sender: TObject);
    procedure Desenvolvimento1Click(Sender: TObject);
    procedure Ajuda1Click(Sender: TObject);
    procedure BtnCopiaClick(Sender: TObject);
    procedure CalcMdia1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure Button19Click(Sender: TObject);
    procedure Button20Click(Sender: TObject);
    procedure Button21Click(Sender: TObject);
    procedure Button22Click(Sender: TObject);
    procedure Button23Click(Sender: TObject);
    procedure Button24Click(Sender: TObject);
    procedure Button25Click(Sender: TObject);
    procedure Button26Click(Sender: TObject);
    procedure Button27Click(Sender: TObject);
    procedure GeradordeTabuada1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses Unit2, Unit3, Unit4, Unit5, Unit6, Unit7;

{$R *.dfm}

procedure TForm1.BtnMaisClick(Sender: TObject);
var
n1, n2, res : double;
begin
n1 := STRTOFLOAT(Edt1.Text);
n2 := STRTOFLOAT(Edt2.Text);
res := n1+n2;
EdtRes.Text:=FLOATTOSTR(res);
end;

procedure TForm1.BtnMenosClick(Sender: TObject);
var
n1, n2, res : double;
begin
n1 := STRTOFLOAT(Edt1.Text);
n2 := STRTOFLOAT(Edt2.Text);
res := n1-n2;
EdtRes.Text:=FLOATTOSTR(res);

end;

procedure TForm1.BtnDivClick(Sender: TObject);
var
n1, n2, res : double;
begin
n1 := STRTOFLOAT(Edt1.Text);
n2 := STRTOFLOAT(Edt2.Text);
res := n1/n2;
EdtRes.Text:=FLOATTOSTR(res);

end;

procedure TForm1.BtnMultClick(Sender: TObject);
var
n1, n2, res : double;
begin
n1 := STRTOFLOAT(Edt1.Text);
n2 := STRTOFLOAT(Edt2.Text);
res := n1*n2;
EdtRes.Text:=FLOATTOSTR(res);

end;

procedure TForm1.BtnLimpaClick(Sender: TObject);
begin
Edt1.text:='';
Edt2.text:='';
EdtRes.text:='';
end;

procedure TForm1.Button1Click(Sender: TObject);
var
n1, res : double;
begin
N1 := STRTOFLOAT(Edt2.Text);
res := (N1/100);
Edt2.Text:=FLOATTOSTR(res);
end;

procedure TForm1.Amarelo1Click(Sender: TObject);
begin
form1.color:=clyellow;
label1.font.color:=clblack;
label2.font.color:=clblack;
label3.font.color:=clblack;
label4.font.color:=clblack;
label5.font.color:=clblack;
label6.font.color:=clblack;
end;

procedure TForm1.Azul1Click(Sender: TObject);
begin
form1.color:=clblue;
label1.font.color:=clblack;
label2.font.color:=clblack;
label3.font.color:=clwhite;
label4.font.color:=clwhite;
label5.font.color:=clwhite;
label6.font.color:=clwhite;
end;

procedure TForm1.Roxo1Click(Sender: TObject);
begin
form1.color:=clpurple;
label1.font.color:=clblack;
label2.font.color:=clblack;
label3.font.color:=clwhite;
label4.font.color:=clwhite;
label5.font.color:=clwhite;
label6.font.color:=clwhite;
end;

procedure TForm1.Preto1Click(Sender: TObject);
begin
form1.color:=clblack;
label1.font.color:=clwhite;
label2.font.color:=clwhite;
label3.font.color:=clwhite;
label4.font.color:=clwhite;
label5.font.color:=clwhite;
label6.font.color:=clwhite;
end;

procedure TForm1.Vermelho1Click(Sender: TObject);
begin
form1.color:=clred;
label1.font.color:=clblack;
label2.font.color:=clblack;
label3.font.color:=clwhite;
label4.font.color:=clwhite;
label5.font.color:=clwhite;
label6.font.color:=clwhite;
end;

procedure TForm1.Rosa1Click(Sender: TObject);
begin
form1.color:=clgreen;
label1.font.color:=clblack;
label2.font.color:=clblack;
label3.font.color:=clwhite;
label4.font.color:=clwhite;
label5.font.color:=clwhite;
label6.font.color:=clwhite;
end;

procedure TForm1.Branco1Click(Sender: TObject);
begin
form1.color:=clwhite;
label1.font.color:=clblack;
label2.font.color:=clblack;
label3.font.color:=clred;
label4.font.color:=clred;
label5.font.color:=clred;
label6.font.color:=clred;
end;

procedure TForm1.Cinza1Click(Sender: TObject);
begin
form1.color:=cllime;
label1.font.color:=clblack;
label2.font.color:=clblack;
label3.font.color:=clwhite;
label4.font.color:=clwhite;
label5.font.color:=clwhite;
label6.font.color:=clwhite;
end;

procedure TForm1.Verde31Click(Sender: TObject);
begin
form1.color:=clgraytext;
label1.font.color:=clblack;
label2.font.color:=clblack;
label3.font.color:=clwhite;
label4.font.color:=clwhite;
label5.font.color:=clwhite;
label6.font.color:=clwhite;
end;

procedure TForm1.PADRO1Click(Sender: TObject);
begin
form1.color:=clhotlight;
label1.font.color:=clblack;
label2.font.color:=clblack;
label3.font.color:=clwhite;
label4.font.color:=clwhite;
label5.font.color:=clwhite;
label6.font.color:=clwhite;
end;

procedure TForm1.Verde41Click(Sender: TObject);
begin
form1.color:=clmoneygreen;
label1.font.color:=clblack;
label2.font.color:=clblack;
label3.font.color:=clwhite;
label4.font.color:=clwhite;
label5.font.color:=clwhite;
label6.font.color:=clwhite;
end;

procedure TForm1.Azul21Click(Sender: TObject);
begin
form1.color:=claqua;
label1.font.color:=clblack;
label2.font.color:=clblack;
label3.font.color:=clwhite;
label4.font.color:=clwhite;
label5.font.color:=clwhite;
label6.font.color:=clwhite;
end;

procedure TForm1.Rosa2Click(Sender: TObject);
begin
form1.color:=clfuchsia;
label1.font.color:=clblack;
label2.font.color:=clblack;
label3.font.color:=clwhite;
label4.font.color:=clwhite;
label5.font.color:=clwhite;
label6.font.color:=clwhite;
end;

procedure TForm1.Cinza2Click(Sender: TObject);
begin
form1.color:=clsilver;
label1.font.color:=clblack;
label2.font.color:=clblack;
label3.font.color:=clwhite;
label4.font.color:=clwhite;
label5.font.color:=clwhite;
label6.font.color:=clwhite;
end;

procedure TForm1.fghft1Click(Sender: TObject);
begin
form1.color:=clolive;
label1.font.color:=clblack;
label2.font.color:=clblack;
label3.font.color:=clwhite;
label4.font.color:=clwhite;
label5.font.color:=clwhite;
label6.font.color:=clwhite;
end;

procedure TForm1.Marom1Click(Sender: TObject);
begin
form1.color:=clmaroon;
label1.font.color:=clblack;
label2.font.color:=clblack;
label3.font.color:=clwhite;
label4.font.color:=clwhite;
label5.font.color:=clwhite;
label6.font.color:=clwhite;
end;

procedure TForm1.Azul31Click(Sender: TObject);
begin
form1.color:=clteal;
label1.font.color:=clblack;
label2.font.color:=clblack;
label3.font.color:=clwhite;
label4.font.color:=clwhite;
label5.font.color:=clwhite;
label6.font.color:=clwhite;
end;

procedure TForm1.PADRO2Click(Sender: TObject);
begin
label1.font.name:='arial';
label2.font.name:='palatino linotype';
end;

procedure TForm1.PretoRed1Click(Sender: TObject);
begin
form1.color:=clblack;
label1.font.color:=clred;
label2.font.color:=clred;
label3.font.color:=clred;
label4.font.color:=clred;
label5.font.color:=clred;
label6.font.color:=clred;
end;

procedure TForm1.Button2Click(Sender: TObject);

var
n1, res : double;
begin
n1 := STRTOFLOAT(Edt1.Text);
res := n1*n1;
EdtRes.Text:=FLOATTOSTR(res);
end;

procedure TForm1.CVolume1Click(Sender: TObject);
begin
form2.Show;
end;

procedure TForm1.CF1Click(Sender: TObject);
begin
form3.show;
end;

procedure TForm1.Fechar1Click(Sender: TObject);
begin
form1.Close;
end;

procedure TForm1.OperaoInversa1Click(Sender: TObject);
begin
form4.show;
end;

procedure TForm1.Desenvolvimento1Click(Sender: TObject);
begin
ShowMessage('Calculadora Rápida desenvolvida por MACHINE Studio'+#13+ 'Iago Vinicius Russi Novaes');
end;

procedure TForm1.Ajuda1Click(Sender: TObject);
begin
form5.show;
end;

procedure TForm1.BtnCopiaClick(Sender: TObject);
begin
Edt1.text:=edtRes.text;
Edt2.text:='';
EdtRes.text:='';
end;

procedure TForm1.CalcMdia1Click(Sender: TObject);
begin
form6.show;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
Edt2.text:=edtRes.text;
Edt1.text:='';
EdtRes.text:='';
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
edt1.text := edt1.text+'1';
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
edt1.text := edt1.text+'2';
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
edt1.text := edt1.text+'3';
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
edt1.text := edt1.text+'4';
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
edt1.text := edt1.text+'5';
end;

procedure TForm1.Button9Click(Sender: TObject);
begin
edt1.text := edt1.text+'6';
end;

procedure TForm1.Button10Click(Sender: TObject);
begin
edt1.text := edt1.text+'7';
end;

procedure TForm1.Button11Click(Sender: TObject);
begin
edt1.text := edt1.text+'8';
end;

procedure TForm1.Button12Click(Sender: TObject);
begin
edt1.text := edt1.text+'9';
end;

procedure TForm1.Button13Click(Sender: TObject);
begin
edt1.text := edt1.text+'0';
end;

procedure TForm1.Button14Click(Sender: TObject);
begin
edt1.text := edt1.text+',';
end;

procedure TForm1.Button15Click(Sender: TObject);
begin
 edt2.text := edt2.text+'1';
end;

procedure TForm1.Button16Click(Sender: TObject);
begin
edt2.text := edt2.text+'2';
end;

procedure TForm1.Button17Click(Sender: TObject);
begin
edt2.text := edt2.text+'3';
end;

procedure TForm1.Button18Click(Sender: TObject);
begin
edt2.text := edt2.text+'4';
end;

procedure TForm1.Button19Click(Sender: TObject);
begin
edt2.text := edt2.text+'5';
end;

procedure TForm1.Button20Click(Sender: TObject);
begin
edt2.text := edt2.text+'6';
end;

procedure TForm1.Button21Click(Sender: TObject);
begin
edt2.text := edt2.text+'7';
end;

procedure TForm1.Button22Click(Sender: TObject);
begin
 edt2.text := edt2.text+'8';
end;

procedure TForm1.Button23Click(Sender: TObject);
begin
edt2.text := edt2.text+'9';
end;

procedure TForm1.Button24Click(Sender: TObject);
begin
edt2.text := edt2.text+'0';
end;

procedure TForm1.Button25Click(Sender: TObject);
begin
 edt2.text := edt2.text+',';
end;

procedure TForm1.Button26Click(Sender: TObject);
begin
edt1.text := '-';
end;

procedure TForm1.Button27Click(Sender: TObject);
begin
edt2.text := '-';
end;

procedure TForm1.GeradordeTabuada1Click(Sender: TObject);
begin
form7.show;
end;

end.
