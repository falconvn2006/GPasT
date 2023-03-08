unit FrameHeureMinute;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ComCtrls, Mask, AdvDropDown, AdvTimePickerDropDown;

type
  THeureMinuteFrame = class(TFrame)
    dtpTime: TAdvTimePickerDropDown;
    procedure dtpTimeExit(Sender: TObject);
  private
    FEnabled: Boolean;
    function GetTime: TDateTime;
    procedure SetTime(const Value: TDateTime);
    function GetReset: Boolean;
    procedure SetReset(const Value: Boolean);
    procedure SetAEnabled(const Value: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    procedure Initialize(Const AStep: integer = 1);
    property Reset: Boolean read GetReset write SetReset;
    property ATime: TDateTime read GetTime write SetTime;
    property AEnabled: Boolean read FEnabled write SetAEnabled;
  end;

implementation

{$R *.dfm}

{ THeureMinuteFrame }

constructor THeureMinuteFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEnabled:= True;
end;

procedure THeureMinuteFrame.dtpTimeExit(Sender: TObject);
begin
  dtpTime.Time := StrToDateTime(dtpTime.EditText);
end;

function THeureMinuteFrame.GetReset: Boolean;
begin
  Result := (dtpTime.Time = StrToTime('00:00:00'));
end;

function THeureMinuteFrame.GetTime: TDateTime;
begin
  if dtpTime.Time = 0 then
    Result := 0
  else
    Result := dtpTime.Time;
end;

procedure THeureMinuteFrame.Initialize(Const AStep: integer);
var
  i, vM: integer;
  Buffer: String;
begin
//  for i:= 0 to 23 do
//    CmbxH.Items.Append(IntToStr(i));
//  vM:= 0;
//  for i:= 0 to (60 div AStep) -1 do
//    begin
//      Buffer:= IntToStr(vM);
//      if vM in [0..9] then
//        Buffer:= '0' + Buffer;
//      CmbxM.Items.Append(Buffer);
//      Inc(vM, AStep);
//    end;
end;

procedure THeureMinuteFrame.SetAEnabled(const Value: Boolean);
begin
  FEnabled := Value;
  dtpTime.Enabled:=FEnabled;
end;

procedure THeureMinuteFrame.SetReset(const Value: Boolean);
begin
  if Value then
  begin
    dtpTime.Time := StrToTime('00:00:00');
  end;
end;

procedure THeureMinuteFrame.SetTime(const Value: TDateTime);
begin
  dtpTime.Time := Value;
end;

end.
