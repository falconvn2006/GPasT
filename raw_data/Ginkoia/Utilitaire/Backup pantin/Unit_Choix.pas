UNIT Unit_Choix;

INTERFACE

USES
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    Buttons, StdCtrls;

TYPE
    TFrm_Choix = CLASS(TForm)
        Lb: TListBox;
        lab_titre: TLabel;
        Ajouter: TSpeedButton;
        SpeedButton1: TSpeedButton;
        SpeedButton2: TSpeedButton;
        sd: TSaveDialog;
        PROCEDURE SpeedButton1Click(Sender: TObject);
        PROCEDURE SpeedButton2Click(Sender: TObject);
        PROCEDURE LbKeyDown(Sender: TObject; VAR Key: Word;
            Shift: TShiftState);
    PRIVATE
    { Déclarations privées }
        toto: TstringList;
    PUBLIC
    { Déclarations publiques }
    END;

PROCEDURE Chxexecute(TitreFen, Titre: STRING; Valeurs: TstringList; Ajoute: TNotifyEvent; DblCkick: TNotifyEvent = NIL);

IMPLEMENTATION

{$R *.DFM}

PROCEDURE Chxexecute(TitreFen, Titre: STRING; Valeurs: TstringList; Ajoute: TNotifyEvent; DblCkick: TNotifyEvent = NIL);
VAR
    Frm_Choix: TFrm_Choix;
BEGIN
    Application.CreateForm(TFrm_Choix, Frm_Choix);
    Frm_Choix.Caption := TitreFen;
    Frm_Choix.toto := Valeurs;
    Frm_Choix.lab_titre.Caption := Titre;
    Frm_Choix.lb.items.Clear;
    Frm_Choix.lb.items.Assign(Valeurs);
    Frm_Choix.Ajouter.OnClick := Ajoute;
    Frm_Choix.lb.OnDblClick := DblCkick;
    Frm_Choix.ShowModal;
    Valeurs.Assign(Frm_Choix.lb.items);
    Frm_Choix.release;
END;

PROCEDURE TFrm_Choix.SpeedButton1Click(Sender: TObject);
BEGIN
    Modalresult := MrOk;
END;

PROCEDURE TFrm_Choix.SpeedButton2Click(Sender: TObject);
BEGIN
    IF sd.execute THEN
    BEGIN
        Lb.items.SaveToFile(sd.FileName);
    END;
END;

PROCEDURE TFrm_Choix.LbKeyDown(Sender: TObject; VAR Key: Word;
    Shift: TShiftState);
BEGIN
    IF (Lb.Itemindex >= 0) AND (key = vk_delete) THEN
    BEGIN
        IF application.MessageBox('Etes vous sur de vouloir supprimer ?', '   ATTENTION', Mb_YESNO OR Mb_defbutton2) = MrYes THEN
        BEGIN
            toto.delete(Lb.Itemindex);
            lb.items.delete(Lb.Itemindex);
        END;
    END;
END;

END.
