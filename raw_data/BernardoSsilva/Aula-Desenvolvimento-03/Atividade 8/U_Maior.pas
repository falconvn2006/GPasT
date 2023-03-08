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
  idades, maiores : array [1..1000] of integer;
  media: double;
  i: integer=1;
  m: integer=0;
implementation

{$R *.dfm}

procedure Tfmr_principal.btn_registrarClick(Sender: TObject);

begin
   idades[i]:= strtoint(txt_idade.Text);
   i := i + 1;
   if strtoint(txt_idade.Text) >= 18 then
   begin
     maiores[m] := strtoint(txt_idade.Text);
     m := m+1
   end;

   txt_idade.Clear;

end;

procedure Tfmr_principal.btn_somarClick(Sender: TObject);
var
j, s: integer;
begin
s := 0;
  for j := 0 to m do
  begin
     s := s + maiores[j];
  end;
  media := s / m;

  lb_resultado.visible:= true;
  lb_resultado.caption := 'São '+inttostr(m)+' pessoas maiores de idade'+#13+'A soma das idades é de: '+inttostr(s) +#13 +'A media de idades é: ' +floattostr(media);

end;

end.

