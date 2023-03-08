unit UFrmHeure;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls;

type
  TFrmHeure = class(TForm)
    btn_Enregistrer: TButton;
    btn_Annuler: TButton;
    lbl_Titre: TLabel;
    dtp_Heure: TDateTimePicker;
    procedure btn_EnregistrerKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  FrmHeure: TFrmHeure;

implementation

{$R *.dfm}

procedure TFrmHeure.btn_EnregistrerKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
    btn_Annuler.Click
  else if Key = #13 then
    btn_Enregistrer.Click;
end;

procedure TFrmHeure.FormShow(Sender: TObject);
begin
  dtp_Heure.SetFocus;
end;

end.
