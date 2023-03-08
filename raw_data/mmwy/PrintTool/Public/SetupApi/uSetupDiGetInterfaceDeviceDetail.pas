unit uSetupDiGetInterfaceDeviceDetail;

{$mode objfpc}
{$H+}

interface

uses
  Windows,
  uSetupApi,
  uSetupDiEnumDeviceInfo,
  uSetupDiEnumDeviceInterfaces;

type
{$IFDEF UNICODE}
  PSPDeviceInterfaceDetailDataW = ^TSPDeviceInterfaceDetailDataW;

  SP_DEVICE_INTERFACE_DETAIL_DATA_W = packed record
    cbSize: DWORD;
    DevicePath: array [0 .. ANYSIZE_ARRAY - 1] of widechar;
  end;

  TSPDeviceInterfaceDetailDataW = SP_DEVICE_INTERFACE_DETAIL_DATA_W;
  TSPDeviceInterfaceDetailData = TSPDeviceInterfaceDetailDataW;
  PSPDeviceInterfaceDetailData = PSPDeviceInterfaceDetailDataW;
  TSPInterfaceDeviceDetailDataW = TSPDeviceInterfaceDetailDataW;
  PSPInterfaceDeviceDetailDataW = PSPDeviceInterfaceDetailDataW;
  TSPInterfaceDeviceDetailData = TSPInterfaceDeviceDetailDataW;
  PSPInterfaceDeviceDetailData = PSPInterfaceDeviceDetailDataW;
{$ELSE}
  PSPDeviceInterfaceDetailDataA = ^TSPDeviceInterfaceDetailDataA;

  SP_DEVICE_INTERFACE_DETAIL_DATA_A = packed record
    cbSize: DWORD;
    DevicePath: array [0 .. ANYSIZE_ARRAY - 1] of AnsiChar;
  end;

  TSPDeviceInterfaceDetailDataA = SP_DEVICE_INTERFACE_DETAIL_DATA_A;
  TSPDeviceInterfaceDetailData = TSPDeviceInterfaceDetailDataA;
  PSPDeviceInterfaceDetailData = PSPDeviceInterfaceDetailDataA;
  TSPInterfaceDeviceDetailDataA = TSPDeviceInterfaceDetailDataA;
  PSPInterfaceDeviceDetailDataA = PSPDeviceInterfaceDetailDataA;
  TSPInterfaceDeviceDetailData = TSPInterfaceDeviceDetailDataA;
  PSPInterfaceDeviceDetailData = PSPInterfaceDeviceDetailDataA;

{$ENDIF UNICODE}
{$IFDEF UNICODE}
function SetupDiGetInterfaceDeviceDetail(DeviceInfoSet: HDEVINFO; DeviceInterfaceData: PSPDeviceInterfaceData;
  DeviceInterfaceDetailData: PSPDeviceInterfaceDetailData; DeviceInterfaceDetailDataSize: DWORD;
  RequiredSize: PDWORD; Device: PSPDevInfoData): BOOL; stdcall;
  external 'SetupApi.dll' Name 'SetupDiGetDeviceInterfaceDetailW';
{$ELSE}
function SetupDiGetInterfaceDeviceDetail(DeviceInfoSet: HDEVINFO; DeviceInterfaceData: PSPDeviceInterfaceData;
  DeviceInterfaceDetailData: PSPDeviceInterfaceDetailData; DeviceInterfaceDetailDataSize: DWORD;
  RequiredSize: PDWORD; Device: PSPDevInfoData): BOOL; stdcall;
  external 'SetupApi.dll' Name 'SetupDiGetDeviceInterfaceDetailA';
{$ENDIF UNICODE}

implementation

end.
