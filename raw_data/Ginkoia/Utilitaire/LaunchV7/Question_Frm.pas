UNIT Question_Frm;

INTERFACE

USES Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
    Buttons, ExtCtrls;

TYPE
    TFrm_Question = CLASS(TForm)
        OKBtn: TButton;
        CancelBtn: TButton;
        Bevel1: TBevel;
        ed_Question: TEdit;
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

END.
