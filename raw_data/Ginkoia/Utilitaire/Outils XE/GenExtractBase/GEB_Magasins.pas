unit GEB_Magasins;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, CheckLst, ExtCtrls;

type
  Tfrm_GEBMagasins = class(TForm)
    Pan_Boutons: TPanel;
    Pan_Titre: TPanel;
    Lab_Titre: TLabel;
    Pan_Liste: TPanel;
    Clb_Liste: TCheckListBox;
    Nbt_Ok: TBitBtn;
    Nbt_Annuler: TBitBtn;
    Chk_Tous: TCheckBox;
    procedure Chk_TousClick(Sender: TObject);
    procedure Clb_ListeClickCheck(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frm_GEBMagasins: Tfrm_GEBMagasins;

implementation

{$R *.dfm}

procedure Tfrm_GEBMagasins.Chk_TousClick(Sender: TObject);
begin

  if Chk_Tous.Checked then
    Clb_Liste.CheckAll(cbChecked)
  else
    Clb_Liste.CheckAll(cbUnchecked);
end;

procedure Tfrm_GEBMagasins.Clb_ListeClickCheck(Sender: TObject);
var
  bTous: Boolean;
  i: Integer;
begin
  bTous := True;
  for i := 0 to Clb_Liste.Count - 1 do
  begin
    if not(Clb_Liste.Checked[i]) then
    begin
      bTous := False;
      Break;
    end;
  end;

  Chk_Tous.OnClick := nil;
  Chk_Tous.Checked := bTous;
  Chk_Tous.OnClick := Chk_TousClick;
end;

end.
