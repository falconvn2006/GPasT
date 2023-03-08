UNIT Reference_Frm;

INTERFACE

USES Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
    Buttons, ExtCtrls;

TYPE
    TFRM_Reference = CLASS(TForm)
        OKBtn: TButton;
        CancelBtn: TButton;
        Bevel1: TBevel;
        Sb_Up: TSpeedButton;
        SB_Down: TSpeedButton;
        Lbx_Ref: TListBox;
        Url: TEdit;
        Label1: TLabel;
        rb1: TRadioButton;
        rb2: TRadioButton;
        Rb3: TRadioButton;
        Ordre: TEdit;
        Label2: TLabel;
        Lbx_Refl: TListBox;
        Label3: TLabel;
        Param: TEdit;
        Label4: TLabel;
    AJ1: TButton;
    Rec1: TButton;
    Rec2: TButton;
    Aj2: TButton;
        PROCEDURE Lbx_RefClick(Sender: TObject);
        PROCEDURE Lbx_ReflClick(Sender: TObject);
        PROCEDURE UrlExit(Sender: TObject);
        PROCEDURE OrdreExit(Sender: TObject);
        PROCEDURE ParamExit(Sender: TObject);
        PROCEDURE Lbx_ReflKeyDown(Sender: TObject; VAR Key: Word;
            Shift: TShiftState);
        PROCEDURE Lbx_RefKeyDown(Sender: TObject; VAR Key: Word;
            Shift: TShiftState);
        PROCEDURE rb1Click(Sender: TObject);
        PROCEDURE Rec1Click(Sender: TObject);
        PROCEDURE Rec2Click(Sender: TObject);
        PROCEDURE Sb_UpClick(Sender: TObject);
        PROCEDURE SB_DownClick(Sender: TObject);
        PROCEDURE AJ1Click(Sender: TObject);
        PROCEDURE Aj2Click(Sender: TObject);
    PRIVATE
    { Private declarations }
        LaList: Tlist;
    PUBLIC
    { Public declarations }
        FUNCTION execute(list: tlist): boolean;
        PROCEDURE initDisplay(Num: Integer);
        FUNCTION LeNum: Integer;
    END;

VAR
    FRM_Reference: TFRM_Reference;

IMPLEMENTATION
{$R *.DFM}
USES
    CstLaunch;

{ TFRM_Reference }

FUNCTION TFRM_Reference.execute(list: tlist): boolean;
BEGIN
    LaList := List;
    initDisplay(lenum);
    result := ShowModal = MrOk;
END;

PROCEDURE TFRM_Reference.initDisplay(Num: Integer);
VAR
    i: integer;
BEGIN
    Lbx_ref.Clear;
    FOR i := 0 TO Lalist.count - 1 DO
        IF TLesReference(Lalist[i]).Place = Num THEN
        BEGIN
            IF TLesReference(Lalist[i]).Supp THEN
                Lbx_ref.Items.AddObject('(Supp)' + TLesReference(Lalist[i]).Ordre, Lalist[i])
            ELSE
                Lbx_ref.Items.AddObject(TLesReference(Lalist[i]).Ordre, Lalist[i]);
        END;
    Lbx_ref.ItemIndex := 0;
    Lbx_RefClick(NIL);
END;

FUNCTION TFRM_Reference.LeNum: Integer;
BEGIN
    IF rb1.checked THEN
        result := 1
    ELSE IF rb2.checked THEN
        result := 2
    ELSE
        result := 3;
END;

PROCEDURE TFRM_Reference.Lbx_RefClick(Sender: TObject);
VAR
    ref: TLesReference;
    i: Integer;
BEGIN
    Lbx_Refl.Clear;
    IF Lbx_Ref.ItemIndex > -1 THEN
    BEGIN
        ref := TLesReference(Lbx_Ref.Items.Objects[Lbx_Ref.ItemIndex]);
        URL.text := ref.URL;
        Ordre.text := ref.Ordre;
        FOR i := 0 TO ref.LignesCount - 1 DO
        BEGIN
            IF TLesReferenceLig(ref.LesLig[i]).Supp THEN
                Lbx_Refl.Items.AddObject('(Supp)' + TLesReferenceLig(ref.LesLig[i]).PARAM, ref.LesLig[i])
            ELSE
                Lbx_Refl.Items.AddObject(TLesReferenceLig(ref.LesLig[i]).PARAM, ref.LesLig[i]);
        END;
    END
    ELSE
    BEGIN
        URL.text := '';
        Ordre.text := '';
    END;
    Lbx_refl.ItemIndex := 0;
    Lbx_ReflClick(NIL);
END;

PROCEDURE TFRM_Reference.Lbx_ReflClick(Sender: TObject);
VAR
    refl: TLesReferenceLig;
BEGIN
    IF Lbx_Refl.ItemIndex > -1 THEN
    BEGIN
        refl := TLesReferenceLig(Lbx_Refl.Items.Objects[Lbx_Refl.ItemIndex]);
        Param.text := refl.PARAM;
    END
    ELSE
    BEGIN
        Param.text := '';
    END;
END;

PROCEDURE TFRM_Reference.UrlExit(Sender: TObject);
VAR
    ref: TLesReference;
BEGIN
    IF Lbx_Ref.ItemIndex > -1 THEN
    BEGIN
        ref := TLesReference(Lbx_Ref.Items.Objects[Lbx_Ref.ItemIndex]);
        IF url.Text <> ref.URL THEN
        BEGIN
            ref.Change := true;
            ref.url := url.Text;
            IF (Length(ref.url)>0) and (ref.url[Length(ref.url)]<>'/') then
              ref.url := ref.url+'/' ;
        END;
    END;
END;

PROCEDURE TFRM_Reference.OrdreExit(Sender: TObject);
VAR
    ref: TLesReference;
BEGIN
    IF Lbx_Ref.ItemIndex > -1 THEN
    BEGIN
        ref := TLesReference(Lbx_Ref.Items.Objects[Lbx_Ref.ItemIndex]);
        IF Ordre.Text <> ref.Ordre THEN
        BEGIN
            ref.Change := true;
            ref.Ordre := Ordre.Text;
            IF ref.supp THEN
                Lbx_Ref.Items[Lbx_Ref.ItemIndex] := '(Supp)' + ref.Ordre
            ELSE
                Lbx_Ref.Items[Lbx_Ref.ItemIndex] := ref.Ordre;
        END;
    END;
END;

PROCEDURE TFRM_Reference.ParamExit(Sender: TObject);
VAR
    refl: TLesReferenceLig;
BEGIN
    IF Lbx_Refl.ItemIndex > -1 THEN
    BEGIN
        refl := TLesReferenceLig(Lbx_Refl.Items.Objects[Lbx_Refl.ItemIndex]);
        IF Param.text <> refl.PARAM THEN
        BEGIN
            refl.Change := true;
            refl.PARAM := Param.text;
            IF refl.supp THEN
                Lbx_Refl.Items[Lbx_Refl.ItemIndex] := '(Supp)' + refl.PARAM
            ELSE
                Lbx_Refl.Items[Lbx_Refl.ItemIndex] := refl.PARAM;
        END;
    END
END;

PROCEDURE TFRM_Reference.Lbx_ReflKeyDown(Sender: TObject; VAR Key: Word;
    Shift: TShiftState);
VAR
    ref: TLesReferenceLig;
BEGIN
    IF key = VK_delete THEN
    BEGIN
        IF Lbx_Refl.ItemIndex > -1 THEN
        BEGIN
            ref := TLesReferenceLig(Lbx_Refl.Items.Objects[Lbx_Refl.ItemIndex]);
            ref.Supp := true;
            Lbx_Refl.items[Lbx_Refl.ItemIndex] := '(Supp)' + ref.PARAM;
        END;
    END;
END;

PROCEDURE TFRM_Reference.Lbx_RefKeyDown(Sender: TObject; VAR Key: Word;
    Shift: TShiftState);
VAR
    ref: TLesReference;
BEGIN
    IF key = VK_delete THEN
    BEGIN
        IF Lbx_Ref.ItemIndex > -1 THEN
        BEGIN
            ref := TLesReference(Lbx_Ref.Items.Objects[Lbx_Ref.ItemIndex]);
            ref.Supp := true;
            Lbx_Ref.items[Lbx_Ref.ItemIndex] := '(Supp)' + ref.Ordre;
        END;
    END;
END;

PROCEDURE TFRM_Reference.rb1Click(Sender: TObject);
BEGIN
    initDisplay(lenum);
END;

PROCEDURE TFRM_Reference.Rec1Click(Sender: TObject);
VAR
    ref: TLesReference;
BEGIN
    IF Lbx_Ref.ItemIndex > -1 THEN
    BEGIN
        ref := TLesReference(Lbx_Ref.Items.Objects[Lbx_Ref.ItemIndex]);
        IF ref.supp THEN
        BEGIN
            ref.Supp := False;
            Lbx_Ref.items[Lbx_Ref.ItemIndex] := ref.Ordre;
        END;
    END;
END;

PROCEDURE TFRM_Reference.Rec2Click(Sender: TObject);
VAR
    ref: TLesReferenceLig;
BEGIN
    IF Lbx_Refl.ItemIndex > -1 THEN
    BEGIN
        ref := TLesReferenceLig(Lbx_Refl.Items.Objects[Lbx_Refl.ItemIndex]);
        IF ref.supp THEN
        BEGIN
            ref.Supp := false;
            Lbx_Refl.items[Lbx_Refl.ItemIndex] := ref.PARAM;
        END;
    END;
END;

PROCEDURE TFRM_Reference.Sb_UpClick(Sender: TObject);
VAR
    i: integer;
    OldOrdre: Integer;
BEGIN
    IF Lbx_Ref.ItemIndex > 0 THEN
    BEGIN
        i := Lbx_Ref.ItemIndex;
        Lbx_Ref.items.Exchange(I, i - 1);
        Lalist.Exchange(i, I - 1);

        TLesReference(Lalist[i]).Change := true;
        TLesReference(Lalist[i - 1]).Change := true;

        OldOrdre := TLesReference(Lalist[i]).Position;
        TLesReference(Lalist[i]).Position := TLesReference(Lalist[i - 1]).Position;
        TLesReference(Lalist[i - 1]).Position := OldOrdre;

        Lbx_Ref.ItemIndex := i - 1;
    END;
END;

PROCEDURE TFRM_Reference.SB_DownClick(Sender: TObject);
VAR
    i: integer;
    OldOrdre: Integer;
BEGIN
    IF Lbx_Ref.ItemIndex < Lbx_Ref.Items.Count - 1 THEN
    BEGIN
        i := Lbx_Ref.ItemIndex;
        Lbx_Ref.items.Exchange(I, i + 1);
        Lalist.Exchange(i, I + 1);
        TLesReference(Lalist[i]).Change := true;
        TLesReference(Lalist[i + 1]).Change := true;
        OldOrdre := TLesReference(Lalist[i]).Position;
        TLesReference(Lalist[i]).Position := TLesReference(Lalist[i + 1]).Position;
        TLesReference(Lalist[i + 1]).Position := OldOrdre;
        Lbx_Ref.ItemIndex := i + 1;
    END;
END;

PROCEDURE TFRM_Reference.AJ1Click(Sender: TObject);
VAR
    ref: TLesReference;
BEGIN
    ref := TLesReference.Create;
    ref.id := -1;
    ref.Ordre := 'Nouveau';
    ref.Place := LeNum;
    ref.URL := 'Nouveau';
    IF Lbx_Ref.Items.Count > 0 THEN
        ref.Position := TLesReference(Lbx_Ref.Items.Objects[Lbx_Ref.Items.Count - 1]).Position + 1
    ELSE
        ref.Position := 1;
    LaList.add(ref);
    Lbx_Ref.Items.AddObject(ref.Ordre, ref);
    Lbx_Ref.itemIndex := Lbx_Ref.items.count - 1;
    Lbx_RefClick(NIL);
    Url.SetFocus ;
END;

PROCEDURE TFRM_Reference.Aj2Click(Sender: TObject);
VAR
    ref: TLesReference;
    refl: TLesReferenceLig;
BEGIN
    IF Lbx_Ref.ItemIndex > -1 THEN
    BEGIN
        ref := TLesReference(Lbx_Ref.Items.Objects[Lbx_Ref.ItemIndex]);
        refl := TLesReferenceLig.Create;
        refl.ID := -1;
        refl.param := 'Nouveau';
        ref.LesLig.add(Refl);
        Lbx_refl.items.AddObject(refl.param, refl);
        Lbx_refl.itemIndex := Lbx_refl.items.count - 1;
        Lbx_ReflClick(NIL);
        Param.SetFocus ;
    END;
END;

END.

