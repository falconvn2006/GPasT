unit uSetupDiEnumDeviceInterfaces;

{$mode objfpc}
{$H+}

interface

uses
  Windows,
  uSetupApi,
  uSetupDiEnumDeviceInfo;

type
  PSPDeviceInterfaceData = ^TSPDeviceInterfaceData;

  SP_DEVICE_INTERFACE_DATA = packed record
    cbSize: DWORD;
    InterfaceClassGuid: TGUID;
    Flags: DWORD;
    Reserved: ULONG_PTR;
  end;
  TSPDeviceInterfaceData = SP_DEVICE_INTERFACE_DATA;

function SetupDiEnumDeviceInterfaces(DeviceInfoSet: HDEVINFO; DeviceInfoData: PSPDevInfoData;
  const InterfaceClassGuid: TGUID; MemberIndex: DWORD; var DeviceInterfaceData: TSPDeviceInterfaceData): BOOL;
  stdcall; external 'SetupApi.dll';

implementation

end.
