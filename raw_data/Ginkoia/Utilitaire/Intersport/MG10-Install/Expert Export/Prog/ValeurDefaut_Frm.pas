unit ValeurDefaut_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AlgolDialogForms, AdvGlowButton, RzLabel, ExtCtrls, RzPanel, StdCtrls;

type
  TFrm_ValeurDefaut = class(TAlgolDialogForm)
    Label1: TLabel;
    Cmb_Ordre: TComboBox;
    Chk_GrantGinkoia: TCheckBox;
    Chk_GrantRepl: TCheckBox;
    Chk_OkDrop: TCheckBox;
    Pan_Btn: TRzPanel;
    Pan_Edition: TRzPanel;
    Lab_ou: TRzLabel;
    Nbt_Cancel: TRzLabel;
    Nbt_Post: TAdvGlowButton;
    procedure Nbt_PostClick(Sender: TObject);
    procedure Nbt_CancelClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Frm_ValeurDefaut: TFrm_ValeurDefaut;

implementation

{$R *.dfm}

procedure TFrm_ValeurDefaut.Nbt_CancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFrm_ValeurDefaut.Nbt_PostClick(Sender: TObject);
begin
  ModalResult := mrok;
end;

end.
