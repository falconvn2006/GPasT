unit U_mediaEx;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  Tfmr_principal = class(TForm)
    lb_nota1: TLabel;
    lb_nota2: TLabel;
    lb_notaE: TLabel;
    txt_nota1: TEdit;
    txt_nota2: TEdit;
    txt_notaE: TEdit;
    btn_calculo: TButton;
    btn_recalc: TButton;
    procedure btn_calculoClick(Sender: TObject);
    procedure btn_recalcClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmr_principal: Tfmr_principal;
  media, mediaE : double;

implementation

{$R *.dfm}

procedure Tfmr_principal.btn_calculoClick(Sender: TObject);
begin
  media := (strtofloat(txt_nota1.Text) + strtofloat(txt_nota2.Text))/2;
  if media >= 7 then
  begin
    showmessage('Aprovado');
  end
  else
  if (media < 7) and (media >=3) then
  begin
    showmessage('Recalcule com a nota do exame');
    lb_notaE.Visible := true;
    txt_notaE.Visible := true;
    btn_recalc.Visible := true;
  end
  else
  if media < 3 then
    showmessage('Reprovado');


end;

procedure Tfmr_principal.btn_recalcClick(Sender: TObject);
begin
  mediaE := (media + strtofloat(txt_notaE.Text))/2;
  if mediaE >= 5 then
    showmessage('Aprovado no exame com media '+ floattostr(mediaE))
  else
    showmessage('Reprovado no exame com media '+floattostr(mediaE))

end;

end.
