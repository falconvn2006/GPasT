UNIT Reference_Frm;

INTERFACE

USES Windows,
  SysUtils,
  Classes,
  Graphics,
  Forms,
  Controls,
  StdCtrls,
  Buttons,
  ExtCtrls,
  AdvGlowButton,
  RzLabel,
  RzPanel,
  GinPanel,
  RzButton,
  RzRadChk;

TYPE
  TFRM_Reference = CLASS(TForm)
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
    PanFond: TGinPanel;
    Pan_Btn: TRzPanel;
    Nbt_Cancel: TRzLabel;
    Lab_OuAnnuler: TRzLabel;
    Nbt_Post: TAdvGlowButton;
    Chk_Plateforme: TRzCheckBox;
    Pan_Selecteur: TRzPanel;
    Btn_RefUp: TAdvGlowButton;
    Btn_RefDown: TAdvGlowButton;
    Btn_RefAdd: TAdvGlowButton;
    Btn_RefRecup: TAdvGlowButton;
    Btn_LigRecup: TAdvGlowButton;
    Btn_LigAdd: TAdvGlowButton;
    PROCEDURE Lbx_RefClick(Sender: TObject);
    PROCEDURE Lbx_ReflClick(Sender: TObject);
    PROCEDURE UrlExit(Sender: TObject);
    PROCEDURE OrdreExit(Sender: TObject);
    PROCEDURE ParamExit(Sender: TObject);
    PROCEDURE Lbx_ReflKeyDown(Sender: TObject; VAR Key: Word; Shift: TShiftState);
    PROCEDURE Lbx_RefKeyDown(Sender: TObject; VAR Key: Word; Shift: TShiftState);
    PROCEDURE rb1Click(Sender: TObject);
    PROCEDURE Rec1Click(Sender: TObject);
    PROCEDURE Rec2Click(Sender: TObject);
    PROCEDURE Sb_UpClick(Sender: TObject);
    PROCEDURE SB_DownClick(Sender: TObject);
    PROCEDURE AJ1Click(Sender: TObject);
    PROCEDURE Aj2Click(Sender: TObject);
    procedure Chk_PlateformeClick(Sender: TObject);
    procedure Nbt_PostClick(Sender: TObject);
    procedure Nbt_CancelClick(Sender: TObject);
  PRIVATE
    { Private declarations }
    LaList: Tlist;
  PUBLIC
    { Public declarations }
    FUNCTION execute(list: Tlist): boolean;
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

FUNCTION TFRM_Reference.execute(list: Tlist): boolean;
BEGIN
  LaList := list;
  initDisplay(LeNum);
  result := ShowModal = MrOk;
END;

PROCEDURE TFRM_Reference.initDisplay(Num: Integer);
VAR
  i: Integer;
BEGIN
  Chk_Plateforme.Visible := (Num = 2);

  Lbx_Ref.Clear;
  FOR i := 0 TO LaList.count - 1 DO
    IF TLesReference(LaList[i]).Place = Num THEN
    BEGIN
      IF TLesReference(LaList[i]).Supp THEN
        Lbx_Ref.Items.AddObject('(Supp)' + TLesReference(LaList[i]).Ordre, LaList[i])
      ELSE
        Lbx_Ref.Items.AddObject(TLesReference(LaList[i]).Ordre, LaList[i]);
    END;
  Lbx_Ref.ItemIndex := 0;
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

procedure TFRM_Reference.Nbt_CancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFRM_Reference.Nbt_PostClick(Sender: TObject);
begin
  ModalResult := MrOk;
end;

PROCEDURE TFRM_Reference.Lbx_RefClick(Sender: TObject);
VAR
  Ref: TLesReference;
  i  : Integer;
BEGIN
  Lbx_Refl.Clear;
  IF Lbx_Ref.ItemIndex > -1 THEN
  BEGIN
    Ref                    := TLesReference(Lbx_Ref.Items.Objects[Lbx_Ref.ItemIndex]);
    Url.text               := Ref.Url;
    Ordre.text             := Ref.Ordre;
    Chk_Plateforme.checked := (Ref.Plateforme = 1);
    FOR i                  := 0 TO Ref.LignesCount - 1 DO
    BEGIN
      IF TLesReferenceLig(Ref.LesLig[i]).Supp THEN
        Lbx_Refl.Items.AddObject('(Supp)' + TLesReferenceLig(Ref.LesLig[i]).Param, Ref.LesLig[i])
      ELSE
        Lbx_Refl.Items.AddObject(TLesReferenceLig(Ref.LesLig[i]).Param, Ref.LesLig[i]);
    END;
  END
  ELSE
  BEGIN
    Url.text               := '';
    Ordre.text             := '';
    Chk_Plateforme.checked := False;
  END;
  Lbx_Refl.ItemIndex       := 0;
  Lbx_ReflClick(NIL);
END;

PROCEDURE TFRM_Reference.Lbx_ReflClick(Sender: TObject);
VAR
  refl: TLesReferenceLig;
BEGIN
  IF Lbx_Refl.ItemIndex > -1 THEN
  BEGIN
    refl       := TLesReferenceLig(Lbx_Refl.Items.Objects[Lbx_Refl.ItemIndex]);
    Param.text := refl.Param;
  END
  ELSE
  BEGIN
    Param.text := '';
  END;
END;

PROCEDURE TFRM_Reference.UrlExit(Sender: TObject);
VAR
  Ref: TLesReference;
BEGIN
  IF Lbx_Ref.ItemIndex > -1 THEN
  BEGIN
    Ref := TLesReference(Lbx_Ref.Items.Objects[Lbx_Ref.ItemIndex]);
    IF Url.text <> Ref.Url THEN
    BEGIN
      Ref.Change := true;
      Ref.Url    := Url.text;
      IF (Length(Ref.Url) > 0) and (Ref.Url[Length(Ref.Url)] <> '/') then
        Ref.Url  := Ref.Url + '/';
    END;
  END;
END;

PROCEDURE TFRM_Reference.OrdreExit(Sender: TObject);
VAR
  Ref: TLesReference;
BEGIN
  IF Lbx_Ref.ItemIndex > -1 THEN
  BEGIN
    Ref := TLesReference(Lbx_Ref.Items.Objects[Lbx_Ref.ItemIndex]);
    IF Ordre.text <> Ref.Ordre THEN
    BEGIN
      Ref.Change       := true;
      Ref.Ordre        := Ordre.text;
      if Chk_Plateforme.checked then
        Ref.Plateforme := 1
      else
        Ref.Plateforme := 0;

      IF Ref.Supp THEN
        Lbx_Ref.Items[Lbx_Ref.ItemIndex] := '(Supp)' + Ref.Ordre
      ELSE
        Lbx_Ref.Items[Lbx_Ref.ItemIndex] := Ref.Ordre;
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
    IF Param.text <> refl.Param THEN
    BEGIN
      refl.Change                          := true;
      refl.Param                           := Param.text;
      IF refl.Supp THEN
        Lbx_Refl.Items[Lbx_Refl.ItemIndex] := '(Supp)' + refl.Param
      ELSE
        Lbx_Refl.Items[Lbx_Refl.ItemIndex] := refl.Param;
    END;
  END
END;

PROCEDURE TFRM_Reference.Lbx_ReflKeyDown(Sender: TObject; VAR Key: Word; Shift: TShiftState);
VAR
  Ref: TLesReferenceLig;
BEGIN
  IF Key = VK_delete THEN
  BEGIN
    IF Lbx_Refl.ItemIndex > -1 THEN
    BEGIN
      Ref                                := TLesReferenceLig(Lbx_Refl.Items.Objects[Lbx_Refl.ItemIndex]);
      Ref.Supp                           := true;
      Lbx_Refl.Items[Lbx_Refl.ItemIndex] := '(Supp)' + Ref.Param;
    END;
  END;
END;

PROCEDURE TFRM_Reference.Lbx_RefKeyDown(Sender: TObject; VAR Key: Word; Shift: TShiftState);
VAR
  Ref: TLesReference;
BEGIN
  IF Key = VK_delete THEN
  BEGIN
    IF Lbx_Ref.ItemIndex > -1 THEN
    BEGIN
      Ref                              := TLesReference(Lbx_Ref.Items.Objects[Lbx_Ref.ItemIndex]);
      Ref.Supp                         := true;
      Lbx_Ref.Items[Lbx_Ref.ItemIndex] := '(Supp)' + Ref.Ordre;
    END;
  END;
END;

PROCEDURE TFRM_Reference.rb1Click(Sender: TObject);
BEGIN
  initDisplay(LeNum);
END;

PROCEDURE TFRM_Reference.Rec1Click(Sender: TObject);
VAR
  Ref: TLesReference;
BEGIN
  IF Lbx_Ref.ItemIndex > -1 THEN
  BEGIN
    Ref := TLesReference(Lbx_Ref.Items.Objects[Lbx_Ref.ItemIndex]);
    IF Ref.Supp THEN
    BEGIN
      Ref.Supp                         := False;
      Lbx_Ref.Items[Lbx_Ref.ItemIndex] := Ref.Ordre;
    END;
  END;
END;

PROCEDURE TFRM_Reference.Rec2Click(Sender: TObject);
VAR
  Ref: TLesReferenceLig;
BEGIN
  IF Lbx_Refl.ItemIndex > -1 THEN
  BEGIN
    Ref := TLesReferenceLig(Lbx_Refl.Items.Objects[Lbx_Refl.ItemIndex]);
    IF Ref.Supp THEN
    BEGIN
      Ref.Supp                           := False;
      Lbx_Refl.Items[Lbx_Refl.ItemIndex] := Ref.Param;
    END;
  END;
END;

PROCEDURE TFRM_Reference.Sb_UpClick(Sender: TObject);
VAR
  i       : Integer;
  OldOrdre: Integer;
BEGIN
  IF Lbx_Ref.ItemIndex > 0 THEN
  BEGIN
    i := Lbx_Ref.ItemIndex;
    Lbx_Ref.Items.Exchange(i, i - 1);
    LaList.Exchange(i, i - 1);

    TLesReference(LaList[i]).Change       := true;
    TLesReference(LaList[i - 1]).Change   := true;

    OldOrdre                              := TLesReference(LaList[i]).Position;
    TLesReference(LaList[i]).Position     := TLesReference(LaList[i - 1]).Position;
    TLesReference(LaList[i - 1]).Position := OldOrdre;

    Lbx_Ref.ItemIndex                     := i - 1;
  END;
END;

PROCEDURE TFRM_Reference.SB_DownClick(Sender: TObject);
VAR
  i       : Integer;
  OldOrdre: Integer;
BEGIN
  IF Lbx_Ref.ItemIndex < Lbx_Ref.Items.count - 1 THEN
  BEGIN
    i := Lbx_Ref.ItemIndex;
    Lbx_Ref.Items.Exchange(i, i + 1);
    LaList.Exchange(i, i + 1);
    TLesReference(LaList[i]).Change       := true;
    TLesReference(LaList[i + 1]).Change   := true;
    OldOrdre                              := TLesReference(LaList[i]).Position;
    TLesReference(LaList[i]).Position     := TLesReference(LaList[i + 1]).Position;
    TLesReference(LaList[i + 1]).Position := OldOrdre;
    Lbx_Ref.ItemIndex                     := i + 1;
  END;
END;

PROCEDURE TFRM_Reference.AJ1Click(Sender: TObject);
VAR
  Ref: TLesReference;
BEGIN
  Ref            := TLesReference.Create;
  Ref.id         := -1;
  Ref.Ordre      := 'Nouveau';
  Ref.Place      := LeNum;
  Ref.Url        := 'Nouveau';
  IF Lbx_Ref.Items.count > 0 THEN
    Ref.Position := TLesReference(Lbx_Ref.Items.Objects[Lbx_Ref.Items.count - 1]).Position + 1
  ELSE
    Ref.Position := 1;
  LaList.add(Ref);
  Lbx_Ref.Items.AddObject(Ref.Ordre, Ref);
  Lbx_Ref.ItemIndex := Lbx_Ref.Items.count - 1;
  Lbx_RefClick(NIL);
  Url.SetFocus;
END;

PROCEDURE TFRM_Reference.Aj2Click(Sender: TObject);
VAR
  Ref : TLesReference;
  refl: TLesReferenceLig;
BEGIN
  IF Lbx_Ref.ItemIndex > -1 THEN
  BEGIN
    Ref        := TLesReference(Lbx_Ref.Items.Objects[Lbx_Ref.ItemIndex]);
    refl       := TLesReferenceLig.Create;
    refl.id    := -1;
    refl.Param := 'Nouveau';
    Ref.LesLig.add(refl);
    Lbx_Refl.Items.AddObject(refl.Param, refl);
    Lbx_Refl.ItemIndex := Lbx_Refl.Items.count - 1;
    Lbx_ReflClick(NIL);
    Param.SetFocus;
  END;
END;

procedure TFRM_Reference.Chk_PlateformeClick(Sender: TObject);
VAR
  Ref: TLesReference;
begin
  IF Lbx_Ref.ItemIndex > -1 THEN
  BEGIN
    Ref := TLesReference(Lbx_Ref.Items.Objects[Lbx_Ref.ItemIndex]);
    Ref.Change := true;
    IF Chk_Plateforme.checked then
      Ref.Plateforme := 1
    else
      Ref.Plateforme := 0;

    IF Ref.Supp THEN
      Lbx_Ref.Items[Lbx_Ref.ItemIndex] := '(Supp)' + Ref.Ordre
    ELSE
      Lbx_Ref.Items[Lbx_Ref.ItemIndex] := Ref.Ordre;
  END;
end;

END.
