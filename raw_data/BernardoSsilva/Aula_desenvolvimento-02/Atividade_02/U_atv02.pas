unit U_atv02;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TFrm_principal = class(TForm)
    lb_titulo: TLabel;
    txt_idade: TEdit;
    btn_calcular: TButton;
    procedure btn_calcularClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_principal: TFrm_principal;

implementation

{$R *.dfm}

procedure TFrm_principal.btn_calcularClick(Sender: TObject);
begin
  if strtoint(txt_idade.text) >= 18 then
  begin
    showmessage('você é maior de idade');
  end
  else
    showmessage('você é menor de idade');

end;

end.
