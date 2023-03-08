unit uSetupDiEnumDeviceInfo;

{$mode objfpc}
{$H+}

interface

uses
  Windows,
  uSetupApi;

type
  PSPDevInfoData = ^TSPDevInfoData;

  SP_DEVINFO_DATA = packed record
    cbSize: DWORD;
    ClassGuid: TGUID;
    DevInst: DWORD; // DEVINST handle
    Reserved: ULONG_PTR;
  end;
  TSPDevInfoData = SP_DEVINFO_DATA;

function SetupDiEnumDeviceInfo(DeviceInfoSet: HDEVINFO; MemberIndex: DWORD;
  var DeviceInfoData: TSPDevInfoData): longbool; stdcall; external 'SetupApi.dll';

implementation

end.
