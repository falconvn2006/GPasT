//$Log:
// 1    Utilitaires1.0         25/11/2005 08:09:37    pascal          
//$
//$NoKeywords$
//
unit ChxSite_frm;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Spin;

type
  Tfrm_ChxSite = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    Nom: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Cb_secour: TCheckBox;
    Ed_nom: TEdit;
    Se_jet: TSpinEdit;
    Se_nb: TSpinEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_ChxSite: Tfrm_ChxSite;

implementation

{$R *.DFM}

end.
