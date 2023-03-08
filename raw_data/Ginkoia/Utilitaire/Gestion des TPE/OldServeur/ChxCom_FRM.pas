UNIT ChxCom_FRM;

INTERFACE

USES Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
    Buttons, ExtCtrls, Spin;

TYPE
    TFRM_ChxCom = CLASS(TForm)
        OKBtn: TButton;
        CancelBtn: TButton;
        Bevel1: TBevel;
        Label1: TLabel;
        SpinEdit1: TSpinEdit;
    PRIVATE
    { Private declarations }
    PUBLIC
    { Public declarations }
        FUNCTION execute(com: integer): integer;
    END;

VAR
    FRM_ChxCom: TFRM_ChxCom;

IMPLEMENTATION

{$R *.DFM}

{ TFRM_ChxCom }

FUNCTION TFRM_ChxCom.execute(com: integer): integer;
BEGIN
    SpinEdit1.value := com;
    IF showmodal = mrok THEN
        result := SpinEdit1.value
    ELSE
        result := com;
END;

END.

