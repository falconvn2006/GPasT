UNIT DlgStd_Frm;

INTERFACE

USES
    Windows,
    Messages,
    SysUtils,
    Classes,
    Graphics,
    Controls,
    Forms,
    Dialogs,
    LMDControl,
    LMDBaseControl,
    LMDBaseGraphicButton,
    LMDCustomSpeedButton,
    LMDSpeedButton,
    ExtCtrls,
    RzPanel,
    StdCtrls,
    LMDCustomButton,
    LMDButton,
    BmDelay,
    RzLabel,
    ComCtrls,
    RzPanelRv, LMDBaseGraphicControl;

TYPE
    TFrm_DlgStd = CLASS(TForm)
        Pan_Fond: TRzPanel;
        Pan_Btn: TRzPanel;
        Pan_Text: TRzPanel;
        Nbt_Cancel: TLMDSpeedButton;
        Nbt_Ok: TLMDSpeedButton;
        Tim_D: TTimer;
        Memo_Mess: TRzLabel;
        Pan_Avi: TRzPanelRv;
        Animate1: TAnimate;
        Lab_Plus: TRzLabel;
        PROCEDURE Nbt_OkClick(Sender: TObject);
        PROCEDURE Nbt_CancelClick(Sender: TObject);
        PROCEDURE FormKeyDown(Sender: TObject; VAR Key: Word;
            Shift: TShiftState);
        PROCEDURE Tim_DTimer(Sender: TObject);
        PROCEDURE FormCloseQuery(Sender: TObject; VAR CanClose: Boolean);
        PROCEDURE FormCreate(Sender: TObject);
        PROCEDURE Memo_MessMouseDown(Sender: TObject; Button: TMouseButton;
            Shift: TShiftState; X, Y: Integer);
        PROCEDURE FormKeyPress(Sender: TObject; VAR Key: Char);
    PRIVATE
        Okn, ATouch, DefTrue: Boolean;
        HintOkn: STRING;
    { Déclarations privées }
    PUBLIC
    { Déclarations publiques }
    END;

FUNCTION OuiNonHP(LeTexte: STRING; BtnDef: Boolean; Gras: Boolean; Lrg, Ht: Integer; Titre: STRING = ''; TextePlus: STRING = ''): Boolean;
FUNCTION OkCancelHP(LeTexte: STRING; BtnDef: Boolean; Gras: Boolean; Lrg, Ht: Integer; Titre: STRING = ''; TextePlus: STRING = ''): Boolean;
PROCEDURE InfoMessHP(LeTexte: STRING; Gras: Boolean; Lrg, Ht: Integer; Titre: STRING = ''; TextePlus: STRING = '');
PROCEDURE WaitMessHP(LeTexte: STRING; Dure: Integer; Gras: Boolean; Lrg, Ht: Integer; Titre: STRING = ''; TextePlus: STRING = '');
PROCEDURE ShowMessHPAvi(LeTexte: STRING; Gras: Boolean; Lrg, Ht: Integer; Titre: STRING = '');
PROCEDURE ShowMessHP(LeTexte: STRING; Gras: Boolean; Lrg, Ht: Integer; Titre: STRING = ''; TextePlus: STRING = '');
PROCEDURE ShowCloseHP ( Sender : TForm = NIL );

IMPLEMENTATION
{$R *.dfm}
USES GinkoiaStd,
    ginkoiaResStr,
    stdUtils;

VAR
    Frm_DlgStd: TFrm_DlgStd;
    Frm_DlgStdS: TFrm_DlgStd;

PROCEDURE ShowMessHP(LeTexte: STRING; Gras: Boolean; Lrg, Ht: Integer; Titre: STRING = ''; TextePlus: STRING = '');
BEGIN
    IF Frm_DlgStdS <> NIL THEN EXIT;
    Application.createform(TFrm_DlgStd, Frm_DlgStdS);
    WITH Frm_DlgStdS DO
    BEGIN
        IF Trim(Titre) = '' THEN
            Caption := LibInfo + '...'
        ELSE
            Caption := Titre;
        IF Length(Letexte) > 255 THEN Letexte := copy(Letexte, 1, 255);
        IF Length(textePlus) > 255 THEN textePlus := copy(textePlus, 1, 255);

        IF Gras THEN Memo_Mess.Font.Style := [fsBold];
        IF lrg > 0 THEN width := lrg;
        IF Ht > 0 THEN Height := ht;
        Okn := False;
        Pan_Btn.Visible := False;
        Height := Height - Pan_Btn.Height;

        IF Trim(textePlus) <> '' THEN
        BEGIN
            Pan_Avi.Visible := True;
            Animate1.Visible := False;
            Lab_Plus.Visible := True;
            Lab_Plus.Caption := TextePlus;
            Height := Height + 65;
        END;

        Hint := Caption;
        Memo_Mess.Caption := LeTexte;
        StdGinkoia.AffecteHintEtBmp(Frm_DlgStdS);

        Show;
        Delai(100);

    END;
END;

PROCEDURE ShowCloseHP ( Sender : TForm = NIL );
BEGIN
    IF Frm_DlgStdS = NIL THEN
       EXIT;

    TRY
        Frm_DlgStdS.Hide;
        IF sender <> NIL THEN ( Sender as TForm ).BringToFront ;
        application.ProcessMessages ;
        Frm_DlgStdS.Animate1.Active := False;
        Frm_DlgStdS.Free;
        Frm_DlgStdS := NIL;
        
    EXCEPT
    END;
END;

PROCEDURE WaitMessHP(LeTexte: STRING; Dure: Integer; Gras: Boolean; Lrg, Ht: Integer; Titre: STRING = ''; TextePlus: STRING = '');
BEGIN
    Application.createform(TFrm_DlgStd, Frm_DlgStd);
    WITH Frm_DlgStd DO
    BEGIN
        TRY
            IF Trim(Titre) = '' THEN
                Caption := LibInfo + '...'
            ELSE
                Caption := Titre;
            IF Length(Letexte) > 255 THEN Letexte := copy(Letexte, 1, 255);
            IF Length(textePlus) > 255 THEN textePlus := copy(textePlus, 1, 255);
            Okn := False;
            StdGinkoia.AffecteHintEtBmp(Frm_DlgStd);
            IF Gras THEN Memo_Mess.Font.Style := [fsBold];
            IF lrg > 0 THEN width := lrg;
            IF Ht > 0 THEN Height := ht;

            Pan_Btn.Visible := False;
            Height := Height - Pan_Btn.Height;
            Hint := Caption;
            Memo_Mess.Caption := LeTexte;

            IF Trim(textePlus) <> '' THEN
            BEGIN
                Pan_Avi.Visible := True;
                Animate1.Visible := False;
                Lab_Plus.Visible := True;
                Lab_Plus.Caption := TextePlus;
                Height := Height + 65;
            END;

            IF Dure = 99 THEN
            BEGIN
                Tim_D.Interval := (5 * 1000) + 150;
                Tim_D.Enabled := True;

                IF NOT Pan_AVI.Visible THEN
                BEGIN
                    Pan_Avi.Visible := True;
                    Animate1.Visible := False;
                    Lab_Plus.Visible := True;
                    Lab_Plus.Caption := 'Une touche ou clic pour abréger ce message...';
                    Height := Height + 65;
                END;
            END
            ELSE BEGIN
                IF Dure = 999 THEN
                BEGIN
                    ATouch := True;
                    IF NOT Pan_Avi.Visible THEN
                    BEGIN
                        Pan_Avi.Visible := True;
                        Animate1.Visible := False;
                        Lab_Plus.Visible := True;
                        Lab_Plus.Caption := 'Une touche pour continuer...';
                        Height := Height + 65;
                    END;
                END
                ELSE BEGIN
                    Tim_D.Interval := (Dure * 1000) + 150;
                    Tim_D.Enabled := True;
                END;
            END;

            Showmodal;
        FINALLY
            Free;
            Frm_DlgStd := NIL ;
            Delai(100);
        END;
    END;
END;

PROCEDURE ShowMessHPAvi(LeTexte: STRING; Gras: Boolean; Lrg, Ht: Integer; Titre: STRING = '');
BEGIN
    IF Frm_DlgStdS <> NIL THEN EXIT;
    Application.createform(TFrm_DlgStd, Frm_DlgStdS);
    WITH Frm_DlgStdS DO
    BEGIN

        IF Trim(Titre) = '' THEN
            Caption := LibInfo + '...'
        ELSE
            Caption := Titre;
        IF Length(Letexte) > 255 THEN Letexte := copy(Letexte, 1, 255);
        Okn := False;
        Pan_Avi.Visible := True;
        IF Gras THEN Memo_Mess.Font.Style := [fsBold];
        IF lrg > 0 THEN width := lrg;
        IF ht > 0 THEN
            Height := ht + Pan_AVI.Height
        ELSE
            Height := Height + Pan_AVI.Height;
        Animate1.Active := True;

        Pan_Btn.Visible := False;
        Height := Height - Pan_Btn.Height;
        Hint := Caption;
        Memo_Mess.Caption := LeTexte;
        StdGinkoia.AffecteHintEtBmp(Frm_DlgStdS);

        Show;
        Delai(100);

    END;
END;

PROCEDURE InfoMessHP(LeTexte: STRING; Gras: Boolean; Lrg, Ht: Integer; Titre: STRING = ''; TextePlus: STRING = '');
BEGIN
    Application.createform(TFrm_DlgStd, Frm_DlgStd);
    WITH Frm_DlgStd DO
    BEGIN
        TRY
            IF Trim(Titre) = '' THEN
                Caption := LibInfo + '...'
            ELSE
                Caption := Titre;
            IF Length(Letexte) > 255 THEN Letexte := copy(Letexte, 1, 255);
            IF Length(textePlus) > 255 THEN textePlus := copy(textePlus, 1, 255);
            Okn := False;
            StdGinkoia.AffecteHintEtBmp(Frm_DlgStd);
            IF Gras THEN Memo_Mess.Font.Style := [fsBold];
            IF lrg > 0 THEN width := lrg;
            IF Ht > 0 THEN Height := ht;

            IF Trim(textePlus) <> '' THEN
            BEGIN
                Pan_Avi.Visible := True;
                Animate1.Visible := False;
                Lab_Plus.Visible := True;
                Lab_Plus.Caption := TextePlus;
                Height := Height + 65;
            END;

            DefTrue := True;
            Nbt_Cancel.Visible := False;
            Nbt_Cancel.glyph := NIL;
            Hint := HintOkDef;
            Memo_Mess.Caption := LeTexte;

            Showmodal;
        FINALLY
            Free;
            Frm_DlgStd := NIL ;
            Delai(100);
        END;
    END;
END;

FUNCTION OuiNonHP(LeTexte: STRING; BtnDef: Boolean; Gras: Boolean; Lrg, Ht: Integer; Titre: STRING = ''; TextePlus: STRING = ''): Boolean;
VAR
    i: Integer;
BEGIN
    Result := False;
    Application.createform(TFrm_DlgStd, Frm_DlgStd);
    WITH Frm_DlgStd DO
    BEGIN
        TRY
            IF Trim(Titre) = '' THEN
                Caption := LibConf + '...'
            ELSE
                Caption := Titre;
            Okn := True;
            IF Length(Letexte) > 255 THEN Letexte := copy(Letexte, 1, 255);
            IF Length(textePlus) > 255 THEN textePlus := copy(textePlus, 1, 255);

            StdGinkoia.AffecteHintEtBmp(Frm_DlgStd);
            IF Gras THEN Memo_Mess.Font.Style := [fsBold];
            IF lrg > 0 THEN width := lrg;
            IF Ht > 0 THEN Height := ht;

            Nbt_Cancel.glyph := NIL;
            Nbt_OK.glyph := NIL;
            Nbt_Ok.Caption := CapYes;
            Nbt_Cancel.Caption := CapNo;
            IF BtnDef THEN
            BEGIN
                Nbt_Ok.Font.Style := [fsBold];
                Nbt_Cancel.Font.Style := [];
            END
            ELSE BEGIN
                Nbt_Ok.Font.Style := [];
                Nbt_Cancel.Font.Style := [fsBold];
            END;

            Hint := '[Entrée] Valide le bouton actif  [Espace] Change le bouton actif  [Echap] Abandonner';
            DefTrue := BtnDef;
            IF Trim(textePlus) <> '' THEN
            BEGIN
                Pan_Avi.Visible := True;
                Animate1.Visible := False;
                Lab_Plus.Visible := True;
                Lab_Plus.Caption := TextePlus;
                Height := Height + 65;
            END;
            Memo_Mess.Caption := LeTexte;

            IF Showmodal = mrOk THEN Result := True;
        FINALLY
            Free;
            Frm_DlgStd := NIL ;
            Delai(100);
        END;
    END;
END;

FUNCTION OkCancelHP(LeTexte: STRING; BtnDef: Boolean; Gras: Boolean; Lrg, Ht: Integer; Titre: STRING = ''; TextePlus: STRING = ''): Boolean;
BEGIN
    Result := False;
    Application.createform(TFrm_DlgStd, Frm_DlgStd);
    WITH Frm_DlgStd DO
    BEGIN
        TRY
            IF Trim(Titre) = '' THEN
                Caption := libConf + '...'
            ELSE
                Caption := Titre;
            Okn := True;
            IF Length(Letexte) > 255 THEN Letexte := copy(Letexte, 1, 255);
            IF Length(textePlus) > 255 THEN textePlus := copy(textePlus, 1, 255);

            StdGinkoia.AffecteHintEtBmp(Frm_DlgStd);
            IF Gras THEN Memo_Mess.Font.Style := [fsBold];
            IF lrg > 0 THEN width := lrg;
            IF Ht > 0 THEN Height := ht;

            Nbt_Cancel.glyph := NIL;
            Nbt_OK.glyph := NIL;

            IF BtnDef THEN
            BEGIN
                Nbt_Ok.Font.Style := [fsBold];
                Nbt_Cancel.Font.Style := [];
            END
            ELSE BEGIN
                Nbt_Ok.Font.Style := [];
                Nbt_Cancel.Font.Style := [fsBold];
            END;

            Hint := '[Entrée] Valide le bouton actif  [Espace] Change le bouton actif  [Echap] Abandonner';
            DefTrue := BtnDef;
            IF Trim(textePlus) <> '' THEN
            BEGIN
                Pan_Avi.Visible := True;
                Animate1.Visible := False;
                Lab_Plus.Visible := True;
                Lab_Plus.Caption := TextePlus;
                Height := Height + 65;
            END;
            Memo_Mess.Caption := LeTexte;

            Memo_Mess.Caption := LeTexte;

            IF Showmodal = mrOk THEN Result := True;
        FINALLY
            Free;
            Frm_DlgStd := NIL ;
            Delai(100);
        END;
    END;
END;

PROCEDURE TFrm_DlgStd.Nbt_OkClick(Sender: TObject);
BEGIN
    IF NOT Tim_D.Enabled THEN ModalResult := MrOk;
END;

PROCEDURE TFrm_DlgStd.Nbt_CancelClick(Sender: TObject);
BEGIN
    IF NOT Tim_D.Enabled THEN ModalResult := MrCancel;
END;

PROCEDURE TFrm_DlgStd.FormKeyDown(Sender: TObject; VAR Key: Word;
    Shift: TShiftState);
BEGIN
    IF Tim_D.Enabled OR Atouch THEN
    BEGIN
        Tim_D.Enabled := False;
        ModalResult := mrOk;
    END
    ELSE BEGIN
        CASE KEY OF
            VK_F12: IF nbt_ok.Visible THEN ModalResult := MrOK;
            VK_LEFT, VK_RIGHT:
                BEGIN
                    IF Okn THEN
                    BEGIN
                        Deftrue := NOT DefTrue;
                        IF Deftrue THEN
                        BEGIN
                            Nbt_Ok.Font.Style := [fsBold];
                            Nbt_Cancel.Font.Style := [];
                        END
                        ELSE BEGIN
                            Nbt_Ok.Font.Style := [];
                            Nbt_Cancel.Font.Style := [fsBold];
                        END;
                    END;
                END;
            VK_RETURN:
                BEGIN
                    IF DefTrue THEN
                        ModalResult := MrOk
                    ELSE
                        ModalResult := MrCancel;
                END;
            VK_ESCAPE: ModalResult := mrCancel;
        END;
    END;
END;

PROCEDURE TFrm_DlgStd.Tim_DTimer(Sender: TObject);
BEGIN
    Tim_D.Enabled := False;
    ModalResult := MrOk;
END;

PROCEDURE TFrm_DlgStd.FormCloseQuery(Sender: TObject;
    VAR CanClose: Boolean);
BEGIN
    CanClose := NOT Tim_D.Enabled;
END;

PROCEDURE TFrm_DlgStd.FormCreate(Sender: TObject);
BEGIN
    ATouch := False;
END;

PROCEDURE TFrm_DlgStd.Memo_MessMouseDown(Sender: TObject;
    Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
BEGIN
    IF Tim_D.Enabled OR Atouch THEN
    BEGIN
        Tim_D.Enabled := False;
        ModalResult := mrOk;
    END;
END;

PROCEDURE TFrm_DlgStd.FormKeyPress(Sender: TObject; VAR Key: Char);
BEGIN
    IF NOT (Tim_D.Enabled OR Atouch) THEN
    BEGIN
        CASE Key OF
            'o', 'O', 'a', 'A': ;
        ELSE BEGIN
                IF Okn THEN
                BEGIN
                    Deftrue := NOT DefTrue;
                    IF Deftrue THEN
                    BEGIN
                        Nbt_Ok.Font.Style := [fsBold];
                        Nbt_Cancel.Font.Style := [];
                    END
                    ELSE BEGIN
                        Nbt_Ok.Font.Style := [];
                        Nbt_Cancel.Font.Style := [fsBold];
                    END;
                END;
            END;
        END;
    END;
END;

END.
