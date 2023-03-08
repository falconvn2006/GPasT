unit U_Atvidade01;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TFrm_principal = class(TForm)
    Lb_nota1: TLabel;
    txt_nota1: TEdit;
    txt_nota2: TEdit;
    Lb_nota2: TLabel;
    btn_calcular: TButton;
    procedure btn_calcularClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_principal: TFrm_principal;
  media: real;

implementation

{$R *.dfm}

procedure TFrm_principal.btn_calcularClick(Sender: TObject);
begin
  media := (strtofloat(txt_nota1.text) + strtofloat(txt_nota2.text))/2;
  if media >= 7 then
  begin
    SHOWMESSAGE('Aprovado, media ' + floattostr(media));
  end
  else
    showmessage('REPROVADO');
end;

end.
