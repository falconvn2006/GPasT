unit FramUpDown;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, Buttons, ExtCtrls;

type
  TUpDownFram = class(TFrame)
    pnlUpDown: TPanel;
    SpdBtnUp: TSpeedButton;
    SpdBtnDown: TSpeedButton;
  private
  public
  end;

implementation

{$R *.dfm}

end.
