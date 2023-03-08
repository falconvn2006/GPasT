unit CFGExc_frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AlgolDialogForms, StdCtrls, Mask, DBCtrls, AdvGlowButton, RzLabel,
  ExtCtrls, RzPanel, Main_DM;

type
  Tfrm_CfgExc = class(TAlgolDialogForm)
    Pan_Btn: TRzPanel;
    Pan_Edition: TRzPanel;
    Lab_Ou: TRzLabel;
    Nbt_Cancel: TRzLabel;
    Nbt_Post: TAdvGlowButton;
    Lab_Exclude: TLabel;
    DBEdit1: TDBEdit;
    procedure Nbt_CancelClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frm_CfgExc: Tfrm_CfgExc;

implementation

{$R *.dfm}

procedure Tfrm_CfgExc.Nbt_CancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
