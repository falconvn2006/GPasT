unit Magasin_frm;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls;

type
  Tfrm_magasin = class(TForm)
    Bevel1: TBevel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    ed_Nom: TEdit;
    Label2: TLabel;
    ed_Ident: TEdit;
    Label3: TLabel;
    Lb_Soc: TComboBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_magasin: Tfrm_magasin;

implementation

{$R *.DFM}

end.
