unit MotDePasse_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AlgolDialogForms, AdvGlowButton, StdCtrls, RzLabel, ExtCtrls, RzPanel,
  Mask;

type
  TFrm_MotDePasse = class(TAlgolDialogForm)
    ed_Question: TEdit;
    Pan_Btn: TRzPanel;
    Nbt_Cancel: TRzLabel;
    Lab_OuAnnuler: TRzLabel;
    Nbt_Post: TAdvGlowButton;
    procedure Nbt_CancelClick(Sender: TObject);
    procedure Nbt_PostClick(Sender: TObject);
    procedure AlgolDialogFormCreate(Sender: TObject);
    procedure AlgolDialogFormVkReturnKey(Sender: TObject; var AKey: Word;
      var ADone: Boolean);
    procedure AlgolDialogFormVkEscapeKey(Sender: TObject; var AKey: Word;
      var ADone: Boolean);
  private
    { Déclarations privées }
  public
    FUNCTION execute(titre: STRING; VAR Valeur: STRING; Mdp: Boolean): Boolean;
    { Déclarations publiques }
  end;

var
  Frm_MotDePasse: TFrm_MotDePasse;

implementation

USES GinkoiaStyle_DM;
{$R *.dfm}

procedure TFrm_MotDePasse.AlgolDialogFormVkEscapeKey(Sender: TObject;
  var AKey: Word; var ADone: Boolean);
begin
  ModalResult := mrCancel;
end;

procedure TFrm_MotDePasse.AlgolDialogFormVkReturnKey(Sender: TObject;
  var AKey: Word; var ADone: Boolean);
begin
  ModalResult := mrOk;
end;

FUNCTION TFrm_MotDePasse.execute(titre: STRING; VAR Valeur: STRING; Mdp: Boolean): Boolean;
BEGIN
    Caption := '  ' + titre;
    ed_Question.text := Valeur;
    IF mdp THEN
        ed_Question.PasswordChar := '*';
    IF showModal = MrOk THEN
    BEGIN
        result := true;
        valeur := ed_Question.text;
    END
    ELSE
        result := false;
END;

procedure TFrm_MotDePasse.AlgolDialogFormCreate(Sender: TObject);
begin
  Dm_GinkoiaStyle.AppliqueAllStyleAdvGlowButton(Self);
end;

procedure TFrm_MotDePasse.Nbt_CancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFrm_MotDePasse.Nbt_PostClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;


end.
