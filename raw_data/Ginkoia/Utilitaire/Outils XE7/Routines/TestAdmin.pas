unit TestAdmin;

interface

function IsUserAdmin() : boolean;

implementation

uses
  Winapi.Windows;

function IsUserAdmin() : boolean;
const
  CAdminSia : TSidIdentifierAuthority = (value: (0, 0, 0, 0, 0, 5));
var
  sid : PSid;
  ctm : function (token: dword; sid: pointer; var isMember: bool) : bool; stdcall;
  b1  : bool;
begin
  result := false;
  ctm := GetProcAddress(LoadLibrary('advapi32.dll'), 'CheckTokenMembership');
  if (@ctm <> nil) and AllocateAndInitializeSid(CAdminSia, 2, $20, $220, 0, 0, 0, 0, 0, 0, sid) then
  begin
    result := ctm(0, sid, b1) and b1;
    FreeSid(sid);
  end;
end;

end.
