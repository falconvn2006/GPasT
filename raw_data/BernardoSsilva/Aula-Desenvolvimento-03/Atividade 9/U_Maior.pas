unit U_Maior;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  Tfmr_principal = class(TForm)
    Label1: TLabel;
    txt_idade: TEdit;
    btn_somar: TButton;
    Btn_registrar: TButton;
    lb_resultado: TLabel;
    procedure btn_registrarClick(Sender: TObject);
    procedure btn_somarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmr_principal: Tfmr_principal;
  idades: array [1..1000] of integer;
  i: integer=1;
implementation

{$R *.dfm}

procedure Tfmr_principal.btn_registrarClick(Sender: TObject);

begin
   idades[i]:= strtoint(txt_idade.Text);
   i := i + 1;
   txt_idade.Clear

end;

procedure Tfmr_principal.btn_somarClick(Sender: TObject);
var
j, s17, s35, s50, s65, smaior: integer;
a17, a35, a50, a65, maior: array[1..1000] of integer;
p17, p35, p50, p65,pmaior :real;
begin
s17 := 1;
s35 := 1;
s50 := 1;
s65 := 1;
smaior := 1;

for j := 0 to i - 1 do
begin
 if (idades[j] <= 17) and (idades[j] > 0) then
 begin
   a17[s17] := idades[j];
   s17 := s17+1
 end
 else
 if (idades[j] > 17) and (idades[j] <= 35) then
 begin
   a35[s35] := idades[j];
   s35 := s35+1
 end
 else
 if (idades[j] <= 50) and (idades[j] > 35)then
 begin
   a50[s50] := idades[j];
   s50 := s50+1
 end
 else
 if (idades[j] <= 65) and (idades[j] > 50) then
 begin
   a65[s65] := idades[j];
   s65 := s65+1
 end
 else
 begin
  maior[smaior] := idades[j];
  smaior := smaior+1
 end;

end;

smaior := smaior-1;

p17 := ((s17 - 1) / (i-1))*100;
p35 := ((s35 - 1) / (i-1))*100;
p50 := ((s50 - 1) / (i-1))*100;
p65 := ((s65 - 1) / (i-1))*100;
pmaior := ((smaior - 1)/(i-1)) *100;


  lb_resultado.Caption := inttostr(i-1) + ' Idades registradas' + #13 + floattostr(p17)+'% Entre 0 e 17'+ #13 + floattostr(p35)+'% Entre 18 e 35'+#13 + floattostr(p50)+'% Entre 36 e 50'+#13+ floattostr(p65)+'% Entre 51 e 65'+#13 + floattostr(pmaior)+'% Acima de 65';
  lb_resultado.Visible := true;

end;

end.

