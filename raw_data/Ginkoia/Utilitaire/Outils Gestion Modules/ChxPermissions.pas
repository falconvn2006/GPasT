UNIT ChxPermissions;

INTERFACE

USES Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
    Buttons, ExtCtrls;

TYPE
    TCxhPermission = CLASS(TForm)
        OKBtn: TButton;
        CancelBtn: TButton;
        Bevel1: TBevel;
        Lbx_Chx: TListBox;
        PROCEDURE FormCreate(Sender: TObject);
        PROCEDURE FormDestroy(Sender: TObject);
    PRIVATE
    { Private declarations }
    PUBLIC
    { Public declarations }
        Selection: TstringList;
        FUNCTION Execute(Titre : string; ListePerm, ListeEnleve: Tstrings): Integer;
    END;

{
var
  CxhPermission: TCxhPermission;
}

IMPLEMENTATION

{$R *.DFM}

{ TCxhPermission }

FUNCTION TCxhPermission.Execute(Titre : String ;ListePerm, ListeEnleve: Tstrings): Integer;
VAR
    i: integer;
BEGIN
    Lbx_Chx.items.Clear;
    FOR i := 0 TO ListePerm.Count - 1 DO
        IF ListeEnleve.IndexOf(ListePerm[i]) < 0 THEN
            Lbx_Chx.items.Add(ListePerm[i]);
    Selection.clear;
    Caption := Titre ;
    result := ShowModal;
    IF result = MRok THEN
    BEGIN
        FOR i := 0 TO Lbx_Chx.items.Count - 1 DO
        BEGIN
            IF Lbx_Chx.Selected[i] THEN
                selection.add(Lbx_Chx.items[i]);
        END;
    END;
END;

PROCEDURE TCxhPermission.FormCreate(Sender: TObject);
BEGIN
    Selection := TstringList.create;
END;

PROCEDURE TCxhPermission.FormDestroy(Sender: TObject);
BEGIN
    Selection.free;
END;

END.

