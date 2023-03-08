{ ******************************************************************************
  Title: InitialPascal
  Description: View relacionado à [Main]

  @author Fabiano Morais (fcpm_mike@hotmail.com)
  @add Initial
  **************************************************************************** }
unit initialPascal.View.Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ActnList, SpkToolbar,
  spkt_Tab, spkt_Pane, spkt_Buttons;

type

  { TFViewMain }

  TFViewMain = class(TForm)
    acList: TActionList;
    acClose: TAction;
    imgList64: TImageList;
    imgList32: TImageList;
    imgList16: TImageList;
    panClose: TSpkPane;
    spkBtnClose: TSpkLargeButton;
    tabSystem: TSpkTab;
    SpkToolbar1: TSpkToolbar;
  private

  public

  end;

var
  FViewMain: TFViewMain;

implementation

{$R *.lfm}

end.

