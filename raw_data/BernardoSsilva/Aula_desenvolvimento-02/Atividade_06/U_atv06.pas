unit U_atv06;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  Tfmr_principal = class(TForm)
    lb_cod: TLabel;
    txt_cod: TEdit;
    btn_class: TButton;
    procedure btn_classClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmr_principal: Tfmr_principal;

implementation

{$R *.dfm}

procedure Tfmr_principal.btn_classClick(Sender: TObject);
var
cod : integer;
begin
cod := strtoint(txt_cod.text);

if cod = 1 then
  showmessage('Alimento não perecivel')
  else
    if  (cod = 2) or (cod = 3) or (cod = 4) then
       showmessage('Alimento perecivel')
       else
          if (cod = 5) or (cod=6) then
            showmessage('Vestuário')
            else
              if (cod = 7) then
                showmessage('Higiene pessoal')
                else
                if (cod = 8) or (cod=9) or (cod=10) then
                showmessage('Utensilios domésticos ')
                else
                showmessage('Codigo invalido')




end;

end.
