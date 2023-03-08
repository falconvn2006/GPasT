//$Log:
// 1    Utilitaires1.0         01/10/2012 16:06:38    Loic G          
//$
//$NoKeywords$
//
unit UsaisiePtch;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  TsaisiePtch = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    mem: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  saisiePtch: TsaisiePtch;

implementation

{$R *.DFM}

end.
