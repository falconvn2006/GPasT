unit ufrmMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  ExtCtrls, RTTICtrls, Types;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    btnReset: TSpeedButton;
    btnStart: TSpeedButton;
    lbHours: TLabel;
    lbSep1: TLabel;
    lbMinutes: TLabel;
    lbSep2: TLabel;
    lbSeconds: TLabel;
    tmrTick: TTimer;
    procedure btnResetClick(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lbHoursMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure lbHoursMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure lbMinutesMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure lbMinutesMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure lbSecondsMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure lbSecondsMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure tmrTickTimer(Sender: TObject);
  private
    initialCount: Int64;
    currentCount: Int64;
    procedure updateDisplay;
  public

  end;

var
  frmMain: TfrmMain;

implementation

{$R *.lfm}

{ TfrmMain }

const
  MAX_DISPLAY_COUNT = (9 * 3600) + (59 * 60) + 59;

function formatCount(count: int64): String;
var
  h, m, s: int64;
begin
  h:= count div 3600;
  count:= count mod 3600;
  m:= count div 60;
  s:= count mod 60;
  Result:= format('%2.2d:%2.2d:%2.2d',[h, m, s]);
end;

procedure TfrmMain.updateDisplay;
var
  r, h, m, s: int64;
begin
  r:= abs(currentCount);
  h:= r div 3600;
  r:= r mod 3600;
  m:= r div 60;
  s:= r mod 60;

  lbHours.caption:= format('%2.2d',[h]);
  lbMinutes.caption:= format('%2.2d',[m]);
  lbSeconds.caption:= format('%2.2d',[s]);

  if currentCount < 0 then
  begin
    lbHours.Font.Color:= clRed;
    lbMinutes.Font.Color:= clRed;
    lbSeconds.Font.Color:= clRed;
  end else
  begin
    lbHours.Font.Color:= clBlack;
    lbMinutes.Font.Color:= clBlack;
    lbSeconds.Font.Color:= clBlack;
  end;
end;

procedure TfrmMain.btnResetClick(Sender: TObject);
begin
  currentCount:= initialCount;
  updateDisplay;
end;

procedure TfrmMain.btnStartClick(Sender: TObject);
begin
  tmrTick.Enabled:= not tmrTick.Enabled;
  updateDisplay;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  i: Int64;
begin
  if (ParamStr(1) <> EmptyStr) and TryStrToInt64(ParamStr(1), i) and (i > 1) and (i < 99) then
    initialCount:= 60 * i
  else
    initialCount:= 60 * 25;
  btnReset.Click;
end;

procedure TfrmMain.lbHoursMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  if initialCount > 3600 then
  begin
    dec(initialCount, 3600);
    btnReset.Click;
  end;
end;

procedure TfrmMain.lbHoursMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  if (initialCount + 3600) < MAX_DISPLAY_COUNT then
  begin
    inc(initialCount, 3600);
    btnReset.Click;
  end;
end;

procedure TfrmMain.lbMinutesMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  if initialCount > 60 then
  begin
    dec(initialCount, 60);
    btnReset.Click;
  end;
end;

procedure TfrmMain.lbMinutesMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  if (initialCount + 60) < MAX_DISPLAY_COUNT then
  begin
    inc(initialCount, 60);
    btnReset.Click;
  end;
end;

procedure TfrmMain.lbSecondsMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  if initialCount > 1 then
  begin
    dec(initialCount);
    btnReset.Click;
  end;
end;

procedure TfrmMain.lbSecondsMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  if (initialCount) < MAX_DISPLAY_COUNT then
  begin
    inc(initialCount);
    btnReset.Click;
  end;
end;

procedure TfrmMain.tmrTickTimer(Sender: TObject);
begin
  if currentCount > (-MAX_DISPLAY_COUNT) then
    dec(currentCount);
  updateDisplay;
end;

end.

