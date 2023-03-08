unit uSetupDiGetDeviceRegistryProperty;

{$mode objfpc}
{$H+}

interface

uses
  SysUtils,
  Windows,
  uSetupApi,
  uSetupDiEnumDeviceInfo;


  {$IFDEF UNICODE}
function SetupDiGetDeviceRegistryProperty(DeviceInfoSet: HDEVINFO; const DeviceInfoData: TSPDevInfoData;
  Property_: DWORD; var PropertyRegDataType: DWORD; PropertyBuffer: PBYTE; PropertyBufferSize: DWORD;
  var RequiredSize: DWORD): BOOL; stdcall; external 'SetupApi.dll' Name 'SetupDiGetDeviceRegistryPropertyW';
  {$ELSE}
function SetupDiGetDeviceRegistryProperty(DeviceInfoSet: HDEVINFO; const DeviceInfoData: TSPDevInfoData;
  Property_: DWORD; var PropertyRegDataType: DWORD; PropertyBuffer: PBYTE; PropertyBufferSize: DWORD;
  var RequiredSize: DWORD): BOOL; stdcall; external 'SetupApi.dll' Name 'SetupDiGetDeviceRegistryPropertyA';
  {$ENDIF UNICODE}

function ConstructDeviceName(DeviceInfoSet: hDevInfo; DeviceInfoData: TSPDevInfoData;
  Buffer: PChar; dwLength: DWord): boolean;

implementation



function GetRegistryProperty(PnPHandle: HDEVINFO; DevData: TSPDevInfoData; Prop: DWORD;
  Buffer: PChar; dwLength: DWord): boolean;
var
  aBuffer: array[0..256] of char;
begin
  dwLength := 0;
  aBuffer[0] := #0;
  SetupDiGetDeviceRegistryProperty(PnPHandle, DevData, Prop, Prop, PBYTE(@aBuffer[0]), SizeOf(aBuffer), dwLength);
  StrCopy(Buffer, aBuffer);
  Result := Buffer^ <> #0;
end;

function ConstructDeviceName(DeviceInfoSet: hDevInfo; DeviceInfoData: TSPDevInfoData;
  Buffer: PChar; dwLength: DWord): boolean;
const
  UnknownDevice = '<Unknown Device>';
begin
  if (not GetRegistryProperty(DeviceInfoSet, DeviceInfoData, SPDRP_FRIENDLYNAME, Buffer, dwLength)) then
  begin
    if (not GetRegistryProperty(DeviceInfoSet, DeviceInfoData, SPDRP_DEVICEDESC, Buffer, dwLength)) then
    begin
      if (not GetRegistryProperty(DeviceInfoSet, DeviceInfoData, SPDRP_CLASS, Buffer, dwLength)) then
      begin
        if (not GetRegistryProperty(DeviceInfoSet, DeviceInfoData, SPDRP_CLASSGUID, Buffer, dwLength)) then
        begin
          dwLength := DWord(SizeOf(UnknownDevice));
          Buffer := Pointer(LocalAlloc(LPTR, cardinal(dwLength)));
          StrCopy(Buffer, UnknownDevice);
        end;
      end;
    end;
  end;
  Result := True;
end;

end.
