unit MotPasse_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TFrm_MotPasse = class(TForm)
    Pan_Banniere: TPanel;
    Lab_Titre: TLabel;
    Pan_Boutons: TPanel;
    Nbt_Ok: TBitBtn;
    Nbt_Annuler: TBitBtn;
    Lab_MotPasse: TLabel;
    Txt_MotPasse: TEdit;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Frm_MotPasse: TFrm_MotPasse;

implementation

{$R *.dfm}

end.
