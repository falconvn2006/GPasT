unit Probleme_frm;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, RzLabel;

type
  TDial_Probleme = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    RzLabel1: TRzLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Dial_Probleme: TDial_Probleme;

implementation

{$R *.DFM}

end.
