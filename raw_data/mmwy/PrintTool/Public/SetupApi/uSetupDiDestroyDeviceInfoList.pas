unit uSetupDiDestroyDeviceInfoList;

{$mode objfpc}
{$H+}

interface

uses
  Windows,
  uSetupApi;

function SetupDiDestroyDeviceInfoList(DeviceInfoSet: HDEVINFO): BOOL; stdcall; external 'SetupApi.dll';

implementation

end.
