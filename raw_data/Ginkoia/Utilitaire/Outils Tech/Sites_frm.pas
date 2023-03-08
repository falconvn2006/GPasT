unit Sites_frm;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Spin;

type
  TFrm_Sites = class(TForm)
    Bevel1: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    SpinEdit1: TSpinEdit;
    Label3: TLabel;
    Label4: TLabel;
    ed_Nom: TEdit;
    ed_Ident: TEdit;
    ed_PLage: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_Sites: TFrm_Sites;

implementation

{$R *.DFM}

end.
