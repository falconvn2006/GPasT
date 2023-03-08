UNIT Connexion_frm;

INTERFACE

USES
    RASAPI,
    Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
    Buttons, ExtCtrls;

TYPE
    TFrm_Connexion = CLASS(TForm)
        OKBtn: TButton;
        CancelBtn: TButton;
        Bevel1: TBevel;
        Ed_Nom: TEdit;
        Ed_Tel: TEdit;
        Cb_Routeur: TCheckBox;
        Label1: TLabel;
        Label2: TLabel;
        Cb_Connexion: TComboBox;
        Label3: TLabel;
        Button1: TButton;
        PROCEDURE FormCreate(Sender: TObject);
        PROCEDURE Button1Click(Sender: TObject);
    PRIVATE
        { Private declarations }
    PUBLIC
        { Public declarations }
    END;
    {
    VAR
        Frm_Connexion: TFrm_Connexion;
    }

IMPLEMENTATION

{$R *.DFM}

PROCEDURE TFrm_Connexion.FormCreate(Sender: TObject);
VAR
    Connex: ARRAY OF TRasEntryName;
    TailleBuf,
        Nombre: DWord;
    i: integer;
BEGIN
    SetLength(Connex, 1);
    Connex[0].Size := sizeof(TRasEntryName);
    TailleBuf := sizeof(TRasEntryName);
    Nombre := 1;
    RasEnumEntries(NIL, NIL, @Connex[0], TailleBuf, Nombre);
    IF nombre > 0 THEN
    BEGIN
        SetLength(Connex, Nombre);
        FOR i := 0 TO Nombre - 1 DO
            Connex[i].Size := sizeof(TRasEntryName);
        RasEnumEntries(NIL, NIL, @Connex[0], TailleBuf, Nombre);
        Cb_Connexion.items.clear;
        FOR i := 0 TO Nombre - 1 DO
            Cb_Connexion.items.Add(connex[i].pEntryName);
    END
    ELSE
    BEGIN
        Cb_Connexion.items.clear;
    END;
END;

PROCEDURE TFrm_Connexion.Button1Click(Sender: TObject);
VAR
    Tp: TRasDialParams;
    Pass: BOOl;
BEGIN
    IF Cb_Connexion.itemIndex >= 0 THEN
    BEGIN
        Tp.Size := Sizeof(tp);
        StrPcopy(tp.pEntryName, Cb_Connexion.Items[Cb_Connexion.itemIndex]);
        RasGetEntryDialParams(NIL, TP, Pass);
        Ed_Nom.Text := tp.pEntryName;
        Ed_Tel.Text := tp.pPhoneNumber;
        Cb_Routeur.checked := false;
    END;
END;

END.
