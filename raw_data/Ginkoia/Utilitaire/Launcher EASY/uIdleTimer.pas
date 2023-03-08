unit uIdleTimer;

interface

uses
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	ExtCtrls;

type
	TIdleTimer = class(TTimer)
	private
		FEnabled: Boolean;
		procedure SetEnabled(Value: Boolean);
		function GetLastActivity: TDateTime;
		procedure SetLastActivity(const t: TDateTime);
		function GetIdleTime: TDateTime;
		function GetIdleMinutes: integer;
	protected
		//
	public
		constructor Create(AOwner: TComponent);override;
		destructor Destroy;override;
		property LastActivity: TDateTime read GetLastActivity write SetLastActivity;
			// last user activity.
		property IdleTime: TDateTime read GetIdleTime;
			// time passed since last user activity
		property IdleMinutes: Integer read GetIdleMinutes;
			// minutes passed since last user activity
	published
		property Enabled: Boolean read FEnabled write SetEnabled default True;
			// Enabled is the same as TTimer.Enabled, but it also controls
			// monitoring user activity for ALL allocated TIdleTimers. Use this
			// for temporary interruptions of monitoring.
	end;


implementation

var
	GLastActivity: TDateTime;
	GInstanceCount: Integer;
	whKeyboard,whMouse: HHook;

procedure GReset;
begin
	GLastActivity := Now;
end;

{$IFDEF WIN32}
function MouseHookCallBack(Code: integer; Msg: WPARAM; MouseHook: LPARAM): LRESULT; stdcall;
{$ELSE}
function MouseHookCallBack(Code: integer; Msg: word; MouseHook: longint): longint; export;
{$ENDIF}
begin
	if Code >= 0 then GReset;
	Result := CallNextHookEx(whMouse,Code,Msg,MouseHook);
end;

{$IFDEF WIN32}
function KeyboardHookCallBack(Code: integer; Msg: WPARAM; KeyboardHook: LPARAM): LRESULT; stdcall;
{$ELSE}
function KeyboardHookCallBack(Code: integer; Msg: word; KeyboardHook: longint): longint; export;
{$ENDIF}
begin
	if Code >= 0 then GReset;
	Result := CallNextHookEx(whKeyboard,Code,Msg,KeyboardHook);
end;

function HookActive: Boolean;
begin
	Result := whKeyboard <> 0;
end;

procedure CreateHooks;
	function GetModuleHandleFromInstance: THandle;
	var
		s: array[0..512] of char;
	begin
		GetModuleFileName(hInstance,s,sizeof(s)-1);
		Result := GetModuleHandle(s);
	end;
begin
	if not HookActive then begin
		whMouse := SetWindowsHookEx(WH_MOUSE,MouseHookCallBack,
																GetModuleHandleFromInstance,
																{$IFDEF WIN32}GetCurrentThreadID{$ELSE}GetCurrentTask{$ENDIF});
		whKeyboard := SetWindowsHookEx(WH_KEYBOARD,KeyboardHookCallBack,
																	 GetModuleHandleFromInstance,
																	 {$IFDEF WIN32}GetCurrentThreadID{$ELSE}GetCurrentTask{$ENDIF});
	end;
end;

procedure RemoveHooks;
begin
	if HookActive then
		try
			UnhookWindowsHookEx(whKeyboard);
			UnhookWindowsHookEx(whMouse);
		finally
			whKeyboard := 0;
			whMouse := 0;
		end;
end;

constructor TIdleTimer.Create;
begin
	inherited;
	CreateHooks;
	if GInstanceCount = 0 then GReset;
	Inc(GInstanceCount);
end;

destructor TIdleTimer.Destroy;
begin
	Dec(GInstanceCount);
	if GInstanceCount <= 0 then RemoveHooks;
	inherited;
end;

procedure TIdleTimer.SetEnabled(Value: Boolean);
begin
	if Value <> FEnabled then
	begin
		FEnabled := Value;
		inherited Enabled := Value;
		if FEnabled then
			CreateHooks
		else
			RemoveHooks
	end;
end;

function TIdleTimer.GetLastActivity: TDateTime;
begin
	Result := GLastActivity;
end;

procedure TIdleTimer.SetLastActivity(const t: TDateTime);
begin
	GLastActivity := t;
end;

function TIdleTimer.GetIdleTime: TDateTime;
begin
	Result := Now - GLastActivity;
end;

function TIdleTimer.GetIdleMinutes: Integer;
begin
	Result := Trunc(IdleTime*1440.1);
end;

initialization
	GInstanceCount := 0;
	whKeyboard := 0;
	whMouse := 0;
end.
