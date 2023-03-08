UNIT ProvSubs_frm;

INTERFACE

USES
    CstLaunch,
    Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
    Buttons, ExtCtrls;

TYPE
    Tfrm_ProvSubs = CLASS(TForm)
        OKBtn: TButton;
        CancelBtn: TButton;
        Bevel1: TBevel;
        Lb_Prov: TListBox;
        Ed_Champs: TEdit;
        Cb_Loop: TCheckBox;
        Sb_Up: TSpeedButton;
        SB_Down: TSpeedButton;
        Button1: TButton;
        Button2: TButton;
        PROCEDURE Lb_ProvClick(Sender: TObject);
        PROCEDURE Ed_ChampsChange(Sender: TObject);
        PROCEDURE Cb_LoopClick(Sender: TObject);
        PROCEDURE Button2Click(Sender: TObject);
        PROCEDURE Lb_ProvKeyDown(Sender: TObject; VAR Key: Word;
            Shift: TShiftState);
        PROCEDURE Sb_UpClick(Sender: TObject);
        PROCEDURE Button1Click(Sender: TObject);
        PROCEDURE SB_DownClick(Sender: TObject);
    PRIVATE
        { Private declarations }
        LaList: Tlist;
    PUBLIC
        { Public declarations }
        FUNCTION execute(list: tlist): boolean;
    END;

    {
    var
      frm_ProvSubs: Tfrm_ProvSubs;
     }

IMPLEMENTATION

{$R *.DFM}

{ Tfrm_ProvSubs }

FUNCTION Tfrm_ProvSubs.execute(list: tlist): boolean;
VAR
    i: integer;
    Prov: TLesProvider;
BEGIN
    LaList := List;
    FOR i := 0 TO lalist.count - 1 DO
    BEGIN
        prov := TLesProvider(LaList[i]);
        IF Prov.Loop = 0 THEN
            Lb_Prov.Items.Add(Prov.Nom)
        ELSE
            Lb_Prov.Items.Add(Prov.Nom + '             LOOP');
        IF i > 0 THEN
        BEGIN
            IF prov.Ordre <= TLesProvider(LaList[i - 1]).Ordre THEN
            BEGIN
                prov.Ordre := TLesProvider(LaList[i - 1]).Ordre + 1;
                prov.Change := true;
            END;
        END;
    END;
    Lb_Prov.ItemIndex := 0;
    Lb_ProvClick(NIL);
    result := ShowModal = MrOk;
END;

PROCEDURE Tfrm_ProvSubs.Lb_ProvClick(Sender: TObject);
BEGIN
    IF Lb_Prov.itemIndex >= 0 THEN
    BEGIN
        ed_Champs.Text := TLesProvider(LaList[Lb_Prov.itemIndex]).Nom;
        Cb_loop.Checked := TLesProvider(LaList[Lb_Prov.itemIndex]).Loop = 1;
    END;
END;

PROCEDURE Tfrm_ProvSubs.Ed_ChampsChange(Sender: TObject);
BEGIN
    IF Lb_Prov.itemIndex >= 0 THEN
    BEGIN
        TLesProvider(LaList[Lb_Prov.itemIndex]).Nom := ed_Champs.Text;
        TLesProvider(LaList[Lb_Prov.itemIndex]).Change := true;
        IF TLesProvider(LaList[Lb_Prov.itemIndex]).Loop = 0 THEN
            Lb_Prov.items[Lb_Prov.itemIndex] := TLesProvider(LaList[Lb_Prov.itemIndex]).Nom
        ELSE
            Lb_Prov.items[Lb_Prov.itemIndex] := TLesProvider(LaList[Lb_Prov.itemIndex]).Nom + '             LOOP';
        IF TLesProvider(LaList[Lb_Prov.itemIndex]).Supp THEN
            Lb_Prov.items[Lb_Prov.itemIndex] := '(Supprimé) ' + Lb_Prov.items[Lb_Prov.itemIndex];
    END;
END;

PROCEDURE Tfrm_ProvSubs.Cb_LoopClick(Sender: TObject);
BEGIN
    IF Lb_Prov.itemIndex >= 0 THEN
    BEGIN
        IF Cb_Loop.Checked THEN
            TLesProvider(LaList[Lb_Prov.itemIndex]).Loop := 1
        ELSE
            TLesProvider(LaList[Lb_Prov.itemIndex]).Loop := 0;
        TLesProvider(LaList[Lb_Prov.itemIndex]).Change := true;
        IF TLesProvider(LaList[Lb_Prov.itemIndex]).Loop = 0 THEN
            Lb_Prov.items[Lb_Prov.itemIndex] := TLesProvider(LaList[Lb_Prov.itemIndex]).Nom
        ELSE
            Lb_Prov.items[Lb_Prov.itemIndex] := TLesProvider(LaList[Lb_Prov.itemIndex]).Nom + '             LOOP';
        IF TLesProvider(LaList[Lb_Prov.itemIndex]).Supp THEN
            Lb_Prov.items[Lb_Prov.itemIndex] := '(Supprimé) ' + Lb_Prov.items[Lb_Prov.itemIndex];
    END;
END;

PROCEDURE Tfrm_ProvSubs.Button2Click(Sender: TObject);
BEGIN
    IF Lb_Prov.itemIndex >= 0 THEN
    BEGIN
        TLesProvider(LaList[Lb_Prov.itemIndex]).Supp := False;
        IF TLesProvider(LaList[Lb_Prov.itemIndex]).Loop = 0 THEN
            Lb_Prov.items[Lb_Prov.itemIndex] := TLesProvider(LaList[Lb_Prov.itemIndex]).Nom
        ELSE
            Lb_Prov.items[Lb_Prov.itemIndex] := TLesProvider(LaList[Lb_Prov.itemIndex]).Nom + '             LOOP';
        IF TLesProvider(LaList[Lb_Prov.itemIndex]).Supp THEN
            Lb_Prov.items[Lb_Prov.itemIndex] := Lb_Prov.items[Lb_Prov.itemIndex];
    END;
END;

PROCEDURE Tfrm_ProvSubs.Lb_ProvKeyDown(Sender: TObject; VAR Key: Word;
    Shift: TShiftState);
BEGIN
    IF key = VK_DELETE THEN
    BEGIN
        IF Lb_Prov.itemIndex >= 0 THEN
        BEGIN
            key := 0;
            TLesProvider(LaList[Lb_Prov.itemIndex]).Supp := true;
            IF TLesProvider(LaList[Lb_Prov.itemIndex]).Loop = 0 THEN
                Lb_Prov.items[Lb_Prov.itemIndex] := TLesProvider(LaList[Lb_Prov.itemIndex]).Nom
            ELSE
                Lb_Prov.items[Lb_Prov.itemIndex] := TLesProvider(LaList[Lb_Prov.itemIndex]).Nom + '             LOOP';
            IF TLesProvider(LaList[Lb_Prov.itemIndex]).Supp THEN
                Lb_Prov.items[Lb_Prov.itemIndex] := '(Supprimé) ' + Lb_Prov.items[Lb_Prov.itemIndex];
        END;
    END;
END;

PROCEDURE Tfrm_ProvSubs.Sb_UpClick(Sender: TObject);
VAR
    i: integer;
    OldOrdre: Integer;
BEGIN
    IF Lb_Prov.ItemIndex > 0 THEN
    BEGIN
        i := Lb_Prov.ItemIndex;
        Lb_Prov.items.Exchange(I, i - 1);
        Lalist.Exchange(i, I - 1);
        TLesProvider(Lalist[i]).Change := true;
        TLesProvider(Lalist[i - 1]).Change := true;
        OldOrdre := TLesProvider(Lalist[i]).Ordre;
        TLesProvider(Lalist[i]).Ordre := TLesProvider(Lalist[i - 1]).Ordre;
        TLesProvider(Lalist[i - 1]).Ordre := OldOrdre;
        Lb_Prov.ItemIndex := i - 1;
    END;
END;

PROCEDURE Tfrm_ProvSubs.Button1Click(Sender: TObject);
VAR
    Prov: TLesProvider;
BEGIN
    Prov := TLesProvider.Create;
    Prov.ID := -1;
    Prov.Nom := ' Nouveau ';
    IF Lalist.Count > 0 THEN
        Prov.Ordre := TLesProvider(Lalist[Lalist.Count - 1]).Ordre + 1
    ELSE
        Prov.Ordre := 1;
    Prov.Loop := 0;
    Prov.Change := true;
    LaList.Add(Prov);
    Lb_Prov.Items.Add(Prov.Nom);
    Lb_Prov.Itemindex := Lb_Prov.Items.Count - 1;
    Lb_ProvClick(NIL);
END;

PROCEDURE Tfrm_ProvSubs.SB_DownClick(Sender: TObject);
VAR
    i: integer;
    OldOrdre: Integer;
BEGIN
    IF Lb_Prov.ItemIndex < Lb_Prov.Items.Count - 1 THEN
    BEGIN
        i := Lb_Prov.ItemIndex;
        Lb_Prov.items.Exchange(I, i + 1);
        Lalist.Exchange(i, I + 1);
        TLesProvider(Lalist[i]).Change := true;
        TLesProvider(Lalist[i + 1]).Change := true;
        OldOrdre := TLesProvider(Lalist[i]).Ordre;
        TLesProvider(Lalist[i]).Ordre := TLesProvider(Lalist[i + 1]).Ordre;
        TLesProvider(Lalist[i + 1]).Ordre := OldOrdre;
        Lb_Prov.ItemIndex := i + 1;
    END;
END;

END.

