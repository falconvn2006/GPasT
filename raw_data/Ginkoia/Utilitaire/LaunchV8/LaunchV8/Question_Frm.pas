UNIT Question_Frm;

INTERFACE

USES Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, Dialogs,
    Buttons, ExtCtrls, AlgolDialogForms, AdvGlowButton, RzLabel, RzPanel;

TYPE
    TFrm_Question = CLASS(TAlgolDialogForm)
        ed_Question: TEdit;
    Pan_Btn: TRzPanel;
    Nbt_Cancel: TRzLabel;
    Lab_OuAnnuler: TRzLabel;
    Nbt_Post: TAdvGlowButton;
    procedure FormCreate(Sender: TObject);
    procedure Nbt_PostClick(Sender: TObject);
    procedure Nbt_CancelClick(Sender: TObject);
    PRIVATE
        { Private declarations }
    PUBLIC
        { Public declarations }
        FUNCTION execute(titre: STRING; VAR Valeur: STRING; Mdp: Boolean): Boolean;
    END;

    {
    var
      Frm_Question: TFrm_Question;
    }

IMPLEMENTATION

USES GinkoiaStyle_DM;
{$R *.DFM}

{ TFrm_Question }

FUNCTION TFrm_Question.execute(titre: STRING; VAR Valeur: STRING; Mdp: Boolean): Boolean;
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

procedure TFrm_Question.FormCreate(Sender: TObject);
begin
  Dm_GinkoiaStyle.AppliqueAllStyleAdvGlowButton(Self);
end;

procedure TFrm_Question.Nbt_CancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFrm_Question.Nbt_PostClick(Sender: TObject);
begin
  Showmessage(inttostr(Nbt_post.height));
  ModalResult := mrOk;
end;

END.
