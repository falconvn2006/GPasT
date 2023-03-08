unit U_atv13;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  Tfrm_main = class(TForm)
    lb_HE: TLabel;
    lb_ME: TLabel;
    lb_hs: TLabel;
    lb_ms: TLabel;
    txt_he: TEdit;
    txt_me: TEdit;
    txt_hs: TEdit;
    txt_ms: TEdit;
    btn_preco: TButton;
    procedure btn_precoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_main: Tfrm_main;

implementation

{$R *.dfm}

procedure Tfrm_main.btn_precoClick(Sender: TObject);
var
he, me, hs, ms, tempo, i: INTEGER;
preco : real;
begin
  he := strtoint(txt_he.Text);
  me := strtoint(txt_me.Text);
  hs := strtoint(txt_hs.Text);
  ms := strtoint(txt_ms.Text);

  if ms > 0 then
  begin
    hs := hs + 1;
  end;

  tempo := hs - he ;

  if tempo = 1 then
  preco := 4.00
    else
      if tempo = 2 then
       preco := 6.00
        else

          if tempo > 2 then
          begin
            tempo := tempo - 2;
            preco := 6.00;
             for i := 1 to tempo do
             begin
               preco := preco + 1;
             end;
          end;

    showmessage('O valor a ser pago é: R$'+floattostr(preco));
end;

end.
