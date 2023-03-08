unit ChxMag_frm;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  Tfrm_ChxMag = class(TForm)
    OKBtn: TButton;
    Bevel1: TBevel;
    Lb_Mag: TListBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_ChxMag: Tfrm_ChxMag;

implementation

{$R *.DFM}

end.
