UNIT BaseModif_Frm;

INTERFACE

USES Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
    Buttons, ExtCtrls;

TYPE
    Tfrm_BaseModif = CLASS(TForm)
        OKBtn: TButton;
        CancelBtn: TButton;
        Bevel1: TBevel;
        Label1: TLabel;
        Label2: TLabel;
        Ed_Heure1: TEdit;
        Cb_Valide1: TCheckBox;
        Label4: TLabel;
        Label3: TLabel;
        Ed_Heure2: TEdit;
        Cb_Valide2: TCheckBox;
        Cb_Auto: TCheckBox;
        Label5: TLabel;
        Ed_Date: TEdit;
        Cb_Back: TCheckBox;
        Label6: TLabel;
        ed_BackTime: TEdit;
    PRIVATE
        { Private declarations }
    PUBLIC
        { Public declarations }
    END;

    {
    var
      frm_BaseModif: Tfrm_BaseModif;
    }

IMPLEMENTATION

{$R *.DFM}

END.
