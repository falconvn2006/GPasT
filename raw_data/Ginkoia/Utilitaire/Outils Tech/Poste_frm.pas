unit Poste_frm;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls;

type
  Tfrm_poste = class(TForm)
    Bevel1: TBevel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    ed_Nom: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_poste: Tfrm_poste;

implementation

{$R *.DFM}

end.
