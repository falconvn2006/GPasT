unit Date_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AdvGlowButton, StdCtrls, ComCtrls, AdvDateTimePicker;

type
  TFrm_Date = class(TForm)
    dtpDate: TAdvDateTimePicker;
    Lab_Info1: TLabel;
    Nbt_Valider: TAdvGlowButton;
    Nbt_Annuler: TAdvGlowButton;
    procedure Nbt_AnnulerClick(Sender: TObject);
    procedure Nbt_ValiderClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    dDateDebut  : TDate;
    bTraitement : Boolean;
    { Déclarations publiques }
  end;

var
  Frm_Date: TFrm_Date;

implementation

{$R *.dfm}

procedure TFrm_Date.Nbt_AnnulerClick(Sender: TObject);
begin
  bTraitement := False;
  Self.Close;
end;

procedure TFrm_Date.Nbt_ValiderClick(Sender: TObject);
begin
  dDateDebut  := dtpDate.Date;
  bTraitement := True;
  Self.Close;
end;

end.
