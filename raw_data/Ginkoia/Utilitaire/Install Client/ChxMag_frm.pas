//$Log:
// 1    Utilitaires1.0         25/11/2005 08:09:36    pascal          
//$
//$NoKeywords$
//
unit ChxMag_frm;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  Tfrm_ChxMag = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    cb_location: TCheckBox;
    ed_nom: TEdit;
    Ed_Ident: TEdit;
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
