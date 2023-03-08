unit uSetupDiGetClassDevs;

{$mode objfpc}
{$H+}

interface

uses
  Windows,
  uSetupApi;


  {$IFDEF UNICODE}
function SetupDiGetClassDevs(ClassGuid: PGUID; const Enumerator: PAnsiChar; hwndParent: HWND;
  Flags: DWORD): HDEVINFO; stdcall; external 'SetupApi.dll' Name 'SetupDiGetClassDevsW';
  {$ELSE}
function SetupDiGetClassDevs(ClassGuid: PGUID; const Enumerator: PAnsiChar; hwndParent: HWND;
  Flags: DWORD): HDEVINFO; stdcall; external 'SetupApi.dll' Name 'SetupDiGetClassDevsA';
  {$ENDIF UNICODE}

implementation

end.
