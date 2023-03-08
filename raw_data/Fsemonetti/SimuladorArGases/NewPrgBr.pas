//************************************************************************//
//                                                                        //
//                                                                        //
//  ProgressBar com dois novos eventos:                                   //
//                                                                        //
//  - OnChange.....: A cada mudança feita na propriedade "Position" este  //
//                   evento é chamado                                     //
//  - OnChanging...: Antes  que a  propriedade "Position" seja alterada,  //
//                   este evento é disparado. E se o valor  da  variável  //
//                   "AllowChange" for TRUE a alteração  da  propriedade  //
//                   "Position" poderá  ser  feita  e  se  for  FALSE  a  //
//                   alteração será desprezada.                           //
//                                                                        //
//                                                                        //
//************************************************************************//
unit NewPrgBr;

{$MODE Delphi}

interface

uses Messages, LCLIntf, LCLType, LMessages, SysUtils, CommCtrl, Classes, Controls, Forms,
  Menus, Graphics, StdCtrls, ToolWin, ExtCtrls;

type
{ TNewProgressBar }

  TPrgRange         = Integer;
  TPrgChangeEvent   = procedure(Sender: TObject; Position: Integer) of object;
  TPrgChangingEvent = procedure(Sender: TObject; Position: Integer; var AllowChange: Boolean) of object;

  TPrgBrOrientation = (pbHorizontal, pbVertical);

  TNewProgressBar = class(TWinControl)
  private
    F32BitMode: Boolean;
    FMin: Integer;
    FMax: Integer;
    FPosition: Integer;
    FStep: Integer;
    FOrientation: TPrgBrOrientation;
    FSmooth: Boolean;
    FOnChange: TPrgChangeEvent;
    FOnChanging: TPrgChangingEvent;
    function GetMin: Integer;
    function GetMax: Integer;
    function GetPosition: Integer;
    procedure SetParams(AMin, AMax: Integer);
    procedure SetMin(Value: Integer);
    procedure SetMax(Value: Integer);
    procedure SetPosition(Value: Integer);
    procedure SetStep(Value: Integer);
    procedure SetOrientation(Value: TPrgBrOrientation);
    procedure SetSmooth(Value: Boolean);
  protected
    function  CanChange(Value: Integer): Boolean; dynamic;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure StepIt;
    procedure StepBy(Delta: Integer);
  published
    property Align;
    property Anchors;
    property BorderWidth;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Hint;
    property Constraints;
    property Min: Integer read GetMin write SetMin;
    property Max: Integer read GetMax write SetMax;
    property Orientation: TPrgBrOrientation read FOrientation write SetOrientation default pbHorizontal;
    property ParentShowHint;
    property PopupMenu;
    property Position: Integer read GetPosition write SetPosition default 0;
    property Smooth: Boolean read FSmooth write SetSmooth default False;
    property Step: Integer read FStep write SetStep default 10;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
    property OnChange: TPrgChangeEvent read FOnChange write FOnChange;
    property OnChanging: TPrgChangingEvent read FOnChanging write FOnChanging;
  end;

procedure Register;

function InitCommonControl(CC: Integer): Boolean;
procedure CheckCommonControl(CC: Integer);

implementation

uses Consts, ComStrs;

procedure Register;
begin
  RegisterComponents('Fabricio', [TNewProgressBar]);
end;

{ TNewProgressBar }

const
  Limit16 = 65535;

function InitCommonControl(CC: Integer): Boolean;
var
  ICC: TInitCommonControlsEx;
begin
  ICC.dwSize := SizeOf(TInitCommonControlsEx);
  ICC.dwICC := CC;
  Result := InitCommonControlsEx(ICC);

  if not Result then
     InitCommonControls;
end;

procedure CheckCommonControl(CC: Integer);
begin
  if not InitCommonControl(CC) then
    raise EComponentError.Create(SInvalidComCtl32);
end;

procedure ProgressLimitError;
begin
  raise Exception.CreateFmt(SOutOfRange, [0, Limit16]);
end;

constructor TNewProgressBar.Create(AOwner: TComponent);
begin
  F32BitMode := InitCommonControl(ICC_PROGRESS_CLASS);

  inherited Create(AOwner);

  Width        := 150;
  Height       := GetSystemMetrics(SM_CYVSCROLL);
  FMin         := 0;
  FMax         := 100;
  FStep        := 10;
  FOrientation := pbHorizontal;
end;

procedure TNewProgressBar.CreateParams(var Params: TCreateParams);
begin
  if not F32BitMode then
     InitCommonControls;

  inherited CreateParams(Params);

  CreateSubClass(Params, PROGRESS_CLASS);
end;

procedure TNewProgressBar.CreateWnd;
begin
  inherited CreateWnd;

  if F32BitMode then
     SendMessage(Handle, PBM_SETRANGE32, FMin, FMax)
  else
     SendMessage(Handle, PBM_SETRANGE, 0, MakeLong(FMin, FMax));

  SendMessage(Handle, PBM_SETSTEP, FStep, 0);
  Position := FPosition;
end;

function TNewProgressBar.GetMin: Integer;
begin
  if HandleAllocated and F32BitMode then
    Result := SendMessage(Handle, PBM_GetRange, 1, 0)
  else
    Result := FMin;
end;

function TNewProgressBar.GetMax: Integer;
begin
  if HandleAllocated and F32BitMode then
    Result := SendMessage(Handle, PBM_GetRange, 0, 0)
  else
    Result := FMax;
end;

function TNewProgressBar.GetPosition: Integer;
begin
  if HandleAllocated then begin
     if F32BitMode then
        Result := SendMessage(Handle, PBM_GETPOS, 0, 0)
     else
        Result := SendMessage(Handle, PBM_DELTAPOS, 0, 0)
  end else
     Result := FPosition;
end;

procedure TNewProgressBar.SetParams(AMin, AMax: Integer);
begin
  if AMax < AMin then
     raise EInvalidOperation.CreateFmt(SPropertyOutOfRange, [Self.Classname]);

  if not F32BitMode and ((AMin < 0) or (AMin > Limit16) or (AMax < 0) or (AMax > Limit16)) then
     ProgressLimitError;

  if (FMin <> AMin) or (FMax <> AMax) then begin
     if HandleAllocated then begin
        if F32BitMode then
           SendMessage(Handle, PBM_SETRANGE32, AMin, AMax)
        else
           SendMessage(Handle, PBM_SETRANGE, 0, MakeLong(AMin, AMax));

        if FMin > AMin then
           SendMessage(Handle, PBM_SETPOS, AMin, 0);
     end;

     FMin := AMin;
     FMax := AMax;
  end;
end;

procedure TNewProgressBar.SetMin(Value: Integer);
begin
  SetParams(Value, FMax);
end;

procedure TNewProgressBar.SetMax(Value: Integer);
begin
  SetParams(FMin, Value);
end;

procedure TNewProgressBar.SetPosition(Value: Integer);
begin
  if not F32BitMode and ((Value < 0) or (Value > Limit16)) then
    ProgressLimitError;
  if HandleAllocated then begin
     if CanChange(Value) then begin
        SendMessage(Handle, PBM_SETPOS, Value, 0);
        if Assigned(FOnChange) then
           FOnChange(Self, Value);
     end;
  end else
     if CanChange(Value) then begin
        FPosition := Value;
        if Assigned(FOnChange) then
           FOnChange(Self, Value);
     end;
end;

procedure TNewProgressBar.SetStep(Value: Integer);
begin
  if Value <> FStep then begin
     FStep := Value;
     if HandleAllocated then
        SendMessage(Handle, PBM_SETSTEP, FStep, 0);
  end;
end;

procedure TNewProgressBar.StepIt;
begin
  if HandleAllocated then begin
     SendMessage(Handle, PBM_STEPIT, 0, 0);

     if Assigned(FOnChange) then
        FOnChange(Self, Position);
  end;
end;

procedure TNewProgressBar.StepBy(Delta: Integer);
begin
  if HandleAllocated then begin
     SendMessage(Handle, PBM_DELTAPOS, Delta, 0);

     if Assigned(FOnChange) then
        FOnChange(Self, Position);
  end;
end;

procedure TNewProgressBar.SetOrientation(Value: TPrgBrOrientation);
begin
  if FOrientation <> Value then begin
     FOrientation := Value;
     RecreateWnd(Self); { *Convertido de RecreateWnd* }
  end;
end;

procedure TNewProgressBar.SetSmooth(Value: Boolean);
begin
  if FSmooth <> Value then begin
     FSmooth := Value;
     RecreateWnd(Self); { *Convertido de RecreateWnd* }
  end;
end;

function TNewProgressBar.CanChange(Value: Integer): Boolean;
begin
  Result := True;
  if Assigned(FOnChanging) then
     FOnChanging(Self, Value, Result);
end;

end.
