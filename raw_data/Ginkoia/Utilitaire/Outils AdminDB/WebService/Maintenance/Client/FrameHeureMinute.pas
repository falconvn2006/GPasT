unit FrameHeureMinute;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls;

type
  THeureMinuteFrame = class(TFrame)
    lblH: TLabel;
    CmbxH: TComboBox;
    CmbxM: TComboBox;
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

function THeureMinuteFrame.GetReset: Boolean;
begin
  Result:= (CmbxH.ItemIndex = -1) and (CmbxM.ItemIndex = -1);
end;

function THeureMinuteFrame.GetTime: TDateTime;
begin
  if (CmbxH.ItemIndex = -1) and (CmbxM.ItemIndex = -1) then
    Result:= 0
  else
    Result:= EncodeTime(StrToInt(CmbxH.Items[CmbxH.ItemIndex]), StrToInt(CmbxM.Items[CmbxM.ItemIndex]), 0, 0);
end;

procedure THeureMinuteFrame.Initialize(Const AStep: integer);
var
  i, vM: integer;
  Buffer: String;
begin
  for i:= 0 to 23 do
    CmbxH.Items.Append(IntToStr(i));
  vM:= 0;
  for i:= 0 to (60 div AStep) -1 do
    begin
      Buffer:= IntToStr(vM);
      if vM in [0..9] then
        Buffer:= '0' + Buffer;
      CmbxM.Items.Append(Buffer);
      Inc(vM, AStep);
    end;
end;

procedure THeureMinuteFrame.SetAEnabled(const Value: Boolean);
begin
  FEnabled := Value;
  CmbxH.Enabled:= FEnabled;
  CmbxM.Enabled:= FEnabled;
end;

procedure THeureMinuteFrame.SetReset(const Value: Boolean);
begin
 if Value then
   begin
     CmbxH.ItemIndex:= -1;
     CmbxM.ItemIndex:= -1;
   end;
end;

procedure THeureMinuteFrame.SetTime(const Value: TDateTime);
var
  vH, vM, vS, vMls: Word;
  Buffer: String;
begin
  DecodeTime(Value, vH, vM, vS, vMls);
  CmbxH.ItemIndex:= CmbxH.Items.IndexOf(IntToStr(vH));
  Buffer:= IntToStr(vM);
  if Length(Buffer) = 1 then
    Buffer:= Buffer + '0';
  CmbxM.ItemIndex:= CmbxM.Items.IndexOf(Buffer);
end;

end.
