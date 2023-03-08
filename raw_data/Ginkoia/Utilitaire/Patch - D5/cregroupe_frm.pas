//$Log:
// 1    Utilitaires1.0         19/09/2016 10:08:37    Ludovic MASSE   
//$
//$NoKeywords$
//
unit cregroupe_frm;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  Tfrm_crergroupe = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    Label1: TLabel;
    Edit1: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_crergroupe: Tfrm_crergroupe;

implementation

{$R *.DFM}

end.
