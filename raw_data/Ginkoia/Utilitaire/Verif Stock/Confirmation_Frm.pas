unit Confirmation_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, LMDCustomButton, LMDButton, ExtCtrls, RzLabel;

type
  TFrm_Confirmation = class(TForm)
    Lab_InfoAction: TRzLabel;
    Chk_Minimize: TCheckBox;
    Chk_Restore: TCheckBox;
    Bevel1: TBevel;
    Nbt_Ok: TLMDButton;
    Nbt_Cancel: TLMDButton;
    procedure Chk_MinimizeClick(Sender: TObject);
  private
    { Déclarations privées }
    Cas: integer;
  public
    { Déclarations publiques }
    procedure SetInfo(ACas: integer);
  end;

var
  Frm_Confirmation: TFrm_Confirmation;

implementation

{$R *.dfm}

procedure TFrm_Confirmation.SetInfo(ACas: integer);
begin
  Cas := ACas;
  case ACas of
    1:
    begin
      Lab_InfoAction.Caption := 'Lancer la recherche de tous les articles '+#13#10+'dont le stock courant est différent de l''histo stock';
    end;
    2:
    begin    
      Lab_InfoAction.Caption := 'Lancer le recalcule du stock';
    end;
  end;   
  Chk_Restore.Enabled := Chk_Minimize.Checked;
end;

procedure TFrm_Confirmation.Chk_MinimizeClick(Sender: TObject);
begin
  Chk_Restore.Enabled := Chk_Minimize.Checked;
end;

end.
