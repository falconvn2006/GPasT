unit Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, DateUtils;

type
  TFrmPrincipal = class(TForm)
    PnlSenha: TPanel;
    BtnGerarSenha: TButton;
    procedure BtnGerarSenhaClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.dfm}


procedure TFrmPrincipal.BtnGerarSenhaClick(Sender: TObject);
var
  vDia, VMes: Integer;
begin
  vDia := DayOf(Date);
  VMes := MonthOf(Date);
  vDia := vDia + 20;
  VMes := VMes + 11;
  PnlSenha.Caption := 'A senha de Hoje é: ' + vDia.ToString + VMes.ToString;
end;

end.
