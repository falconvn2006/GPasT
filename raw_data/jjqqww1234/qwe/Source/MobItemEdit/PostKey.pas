unit PostKey;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;


implementation

procedure PostKeyEx( hWindow: HWnd; key: Word; Const shift: TShiftState; specialkey: Boolean );
type
TBuffers = Array [0..1] of TKeyboardState;
var
pKeyBuffers : ^TBuffers;
lparam: LongInt;
begin
{check if the target window exists}
if IsWindow(hWindow) then
begin
{set local variables to default values}
pKeyBuffers := Nil;
lparam := MakeLong(0, MapVirtualKey(key, 0));
{modify lparam if special key requested}
if specialkey then
lparam := lparam or $1000000;
{allocate space for the key state buffers}
New(pKeyBuffers);
try
{Fill buffer 1 with current state so we can later restore it. Null out buffer 0 to get a
"no key pressed" state.}
GetKeyboardState( pKeyBuffers^[1] );
FillChar(pKeyBuffers^[0], Sizeof(TKeyboardState), 0);
{set the requested modifier keys to "down" state in the buffer}
if ssShift in Shift then
pKeyBuffers^[0][VK_SHIFT] := $80;
if ssAlt in Shift then
begin
{Alt needs special treatment since a bit in lparam needs also be set}
pKeyBuffers^[0][VK_MENU] := $80;
lparam := lparam or $20000000;
end;
if ssCtrl in Shift then
pKeyBuffers^[0][VK_CONTROL] := $80;
if ssLeft in Shift then
pKeyBuffers^[0][VK_LBUTTON] := $80;
if ssRight in Shift then
pKeyBuffers^[0][VK_RBUTTON] := $80;
if ssMiddle in Shift then
pKeyBuffers^[0][VK_MBUTTON] := $80;
{make out new key state array the active key state map}
SetKeyboardState( pKeyBuffers^[0] );
{post the key messages}
if ssAlt in Shift then
begin
PostMessage( hWindow, WM_SYSKEYDOWN, key, lparam);
PostMessage( hWindow, WM_SYSKEYUP, key, lparam or $C0000000);
end
else
begin
PostMessage( hWindow, WM_KEYDOWN, key, lparam);
PostMessage( hWindow, WM_KEYUP, key, lparam or $C0000000);
end;
{process the messages}
Application.ProcessMessages;
{restore the old key state map}
SetKeyboardState( pKeyBuffers^[1] );
finally
{free the memory for the key state buffers}
if pKeyBuffers <> Nil then
Dispose( pKeyBuffers );
end;
end;
end;

end.
 