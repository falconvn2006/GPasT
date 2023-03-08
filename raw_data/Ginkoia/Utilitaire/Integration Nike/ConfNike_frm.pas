UNIT ConfNike_frm;

INTERFACE

USES Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
    Buttons, ExtCtrls, Dialogs, Mask, RzLabel,
    RzBorder, Spin;

TYPE
    Tfrm_ConfNike = CLASS(TForm)
    Pan_Right: TPanel;
    OKBtn: TButton;
    CancelBtn: TButton;
    Pan_Client: TPanel;
    OD: TOpenDialog;
    Gbx_Bottom: TGroupBox;
    chp_max: TSpinEdit;
    RzLabel1: TRzLabel;
    Gbx_Top: TGroupBox;
    Label1: TLabel;
    SpeedButton1: TSpeedButton;
    Label3: TLabel;
    Label4: TLabel;
    SpeedButton2: TSpeedButton;
    Edit1: TEdit;
    Panel1: TPanel;
    Label2: TLabel;
    Rb_Ete: TRadioButton;
    Rb_Hiver: TRadioButton;
    CB_CPAID: TComboBox;
    CB_TYPID: TComboBox;
    Edit2: TEdit;
    Chk_PasFEDAS: TCheckBox;
    Lab_BL: TLabel;
    Nbt_BL: TSpeedButton;
    Edit3: TEdit;
        PROCEDURE SpeedButton1Click(Sender: TObject);
        PROCEDURE Edit1Exit(Sender: TObject);
        PROCEDURE OKBtnClick(Sender: TObject);
        PROCEDURE SpeedButton2Click(Sender: TObject);
    procedure Nbt_BLClick(Sender: TObject);
    PRIVATE
    { Private declarations }
    PUBLIC
    { Public declarations }
    END;

VAR
    frm_ConfNike: Tfrm_ConfNike;

IMPLEMENTATION

{$R *.DFM}

PROCEDURE Tfrm_ConfNike.SpeedButton1Click(Sender: TObject);
BEGIN
    IF od.execute THEN
        edit1.text := IncludeTrailingBackslash(extractfilepath(od.filename));
END;

PROCEDURE Tfrm_ConfNike.Edit1Exit(Sender: TObject);
BEGIN
    edit1.text := IncludeTrailingBackslash(edit1.text);
END;

procedure Tfrm_ConfNike.Nbt_BLClick(Sender: TObject);
begin
    IF od.execute THEN
        edit3.text := IncludeTrailingBackslash(extractfilepath(od.filename));
end;

PROCEDURE Tfrm_ConfNike.OKBtnClick(Sender: TObject);
BEGIN
    IF strtoint(chp_max.text) > 1000 THEN
        MessageDlg('Attention un nombre d''articles supérieur à 1000 peut mettre en péril votre réplication...', mtWarning, [], 0);

    IF (trim(Edit1.Text) = '') OR (trim(Edit2.Text) = '') OR (trim(Edit3.Text) = '') THEN
        application.messagebox('Veuillez renseigner les noms de tous les répertoires', 'Attention', Mb_OK)
    ELSE
        Modalresult := MrOk;
END;

PROCEDURE Tfrm_ConfNike.SpeedButton2Click(Sender: TObject);
BEGIN
    IF od.execute THEN
        edit2.text := IncludeTrailingBackslash(extractfilepath(od.filename));
END;

END.
