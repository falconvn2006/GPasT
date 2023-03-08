//$Log:
// 1    Utilitaires1.0         25/11/2005 08:09:37    pascal          
//$
//$NoKeywords$
//
unit ChxSociete_frm;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  Tfrm_ChxSociete = class(TForm)
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
  frm_ChxSociete: Tfrm_ChxSociete;

implementation

{$R *.DFM}

end.
