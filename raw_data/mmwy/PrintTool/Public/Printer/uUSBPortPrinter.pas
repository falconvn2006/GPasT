unit uUSBPortPrinter;

{$mode objfpc}
{$H+}

interface

uses
  Classes, Windows, SysUtils, StrUtils, uDevice, uPrinter, uTooanClass, uLogger;

type
  { TUsbPrinter }
  TUsbPrinter = class(TTooanAbstractClass, IPrinter)
    function GetAllPrinter: IDeviceArray;
    function Exists(const DevicePath: string): boolean;
    procedure Print(DevicePath, Content: string);
  end;

implementation

uses uDevGUID, uSetupApi;

const
  PRINTER_DS_1000: string = 'DASCOM DS-1000 Printer ';
  PRINTER_DS_650: string = 'DS-650';
  PRINTER_DS_650II: string = 'DS-650II';
  PRINTER_DS_1860: string = 'DASCOM DS-1860 Printer';
  PRINTER_DL_218Z: string = 'DL-218Z';
  PRINTER_DS_1900Y: string = 'DASCOMDS-1900Y';
  PRINTER_DASCOM_VID_PID: array [0 .. 6] of string = (
    'vid_20d1&pid_2010', // DS-1100II系列
    'vid_20d1&pid_200e', // DS-2600II系列
    'vid_0401&pid_0210', // DS-1700、DS-5400H、DS-5400III、DS-6400III系列
    'vid_08bd&pid_020b', // DS-3200IV、DS3200H系列
    'vid_2867&pid_1105', // DS-1900Y   
    'vid_2867&pid_1521', // DL-218Z
    'vid_04a9&pid_2676');
  PRINTER_START_VID_PID: array [0 .. 2] of string = (
    'vid_0aa7&pid_4300',
    'vid_1bc3&pid_0003',
    'vid_067b&pid_2305');
  PRINTER_Jolimark_MP_220DC: string = 'Jolimark MP-220DC';
  PRINTER_Jolimark_FP_830K: string = 'Jolimark FP-830K';
  PRINTER_Jolimark_FP_570KII: string = 'Jolimark FP-570KII';
  PRINTER_JOLIMARK_VID_PID: array [0 .. 2] of string = (
    'vid_1ba0&pid_2101', // Jolimark MP-220DC
    'vid_1ba0&pid_111d', // Jolimark FP-830K
    'vid_1ba0&pid_1109' // Jolimark FP-570KII
    );
  PRINTER_EPSON_LQ_80KFII: string = 'EPSON LQ-80KFII';
  PRINTER_EPSON_VID_PID: array [0 .. 0] of string = ('vid_04b8&pid_006a');


procedure _Do_Print(DevicePath, Content: string);
var
  tfOut: TextFile;
begin
  AssignFile(tfOut, DevicePath);
  try
    Rewrite(tfOut);
    Write(tfOut, Content);
    Flush(tfOut);
  except
    on E: Exception do
      logger.Error(e.Message);
  end;
  CloseFile(tfOut);
end;

{
var
  gm_DeviceHandle: THandle;
begin
  gm_DeviceHandle := CreateFile(PChar(DevicePath), GENERIC_WRITE, 0, nil, OPEN_EXISTING,
    FILE_ATTRIBUTE_NORMAL or FILE_FLAG_OVERLAPPED, 0);
  try
    if gm_DeviceHandle = INVALID_HANDLE_VALUE then
    begin
      raise TPrinterException.Create(INVALID_HANDLE_ERROR_CODE);
    end;
    WriteTo(PAnsiChar(Content), gm_DeviceHandle);
  finally
    if INVALID_HANDLE_VALUE <> gm_DeviceHandle then
    begin
      CloseHandle(gm_DeviceHandle);
    end;
  end;
end;
}

function _Get_Printer(const aDisplayName: string): string;
var
  aDeviceArray: IDeviceArray;
  aDevice: IDevice;
begin
  aDeviceArray := LoadDevices(GUID_CLASS_I82930_BULK);
  for aDevice in aDeviceArray do
  begin
    if Trim(aDevice.DisplayName) = aDisplayName then
    begin
      Result := aDevice.DevicePath;
      exit;
    end;
  end;
  raise TPrinterException.Create(INVALID_HANDLE_ERROR_CODE);
end;

function _Get_Dascom_Printer: string;
var
  aDeviceArray: IDeviceArray;
  aDevice: IDevice;
  pid: string;
begin
  aDeviceArray := LoadDevices(GUID_CLASS_I82930_BULK);
  for aDevice in aDeviceArray do
  begin
    for pid in PRINTER_DASCOM_VID_PID do
    begin
      if AnsiContainsStr(aDevice.DevicePath, pid) then
      begin
        Result := aDevice.DevicePath;
        exit;
      end;
    end;
  end;
  raise TPrinterException.Create(INVALID_HANDLE_ERROR_CODE);
end;

function _Get_Start_Printer: string;
var
  aDeviceArray: IDeviceArray;
  aDevice: IDevice;
  pid: string;
begin
  aDeviceArray := LoadDevices(GUID_CLASS_I82930_BULK);
  for aDevice in aDeviceArray do
  begin
    for pid in PRINTER_START_VID_PID do
    begin
      if AnsiContainsStr(aDevice.DevicePath, pid) then
      begin
        Result := aDevice.DevicePath;
        exit;
      end;
    end;
  end;
  raise TPrinterException.Create(INVALID_HANDLE_ERROR_CODE);
end;

function _Get_Jolimark_Printer: string;
var
  aDeviceArray: IDeviceArray;
  aDevice: IDevice;
  pid: string;
begin
  aDeviceArray := LoadDevices(GUID_CLASS_I82930_BULK);
  for aDevice in aDeviceArray do
  begin
    for pid in PRINTER_JOLIMARK_VID_PID do
    begin
      if AnsiContainsStr(aDevice.DevicePath, pid) then
      begin
        Result := aDevice.DevicePath;
        exit;
      end;
    end;
  end;
  raise TPrinterException.Create(INVALID_HANDLE_ERROR_CODE);
end;

function _Get_Epson_Printer: string;
var
  aDeviceArray: IDeviceArray;
  aDevice: IDevice;
  pid: string;
begin
  aDeviceArray := LoadDevices(GUID_CLASS_I82930_BULK);
  for aDevice in aDeviceArray do
  begin
    for pid in PRINTER_EPSON_VID_PID do
    begin
      if AnsiContainsStr(aDevice.DevicePath, pid) then
      begin
        Result := aDevice.DevicePath;
        exit;
      end;
    end;
  end;
  raise TPrinterException.Create(INVALID_HANDLE_ERROR_CODE);
end;

{ TUsbPrinter }

function TUsbPrinter.GetAllPrinter: IDeviceArray;
begin
  Result := LoadDevices(GUID_CLASS_I82930_BULK);
end;

function TUsbPrinter.Exists(const DevicePath: string): boolean;
begin
  Result := True;
end;

procedure TUsbPrinter.Print(DevicePath, Content: string);
begin
  // DASCOM DS-1000 Printer
  if DevicePath = PRINTER_DS_1000 then
  begin
    _Do_Print(_Get_Printer(PRINTER_DS_1000), Content);
    Exit;
  end;
  // DS-650
  if DevicePath = PRINTER_DS_650 then
  begin
    _Do_Print(_Get_Printer(PRINTER_DS_650), Content);
    Exit;
  end;
  // DS-650II
  if DevicePath = PRINTER_DS_650II then
  begin
    _Do_Print(_Get_Printer(PRINTER_DS_650II), Content);
    Exit;
  end;
  // DASCOM DS-1860 Printer
  if DevicePath = PRINTER_DS_1860 then
  begin
    _Do_Print(_Get_Printer(PRINTER_DS_1860), Content);
    Exit;
  end;
  // DASCOM DS_1900Y Printer
  if DevicePath = PRINTER_DS_1900Y then
  begin
    _Do_Print(_Get_Printer(PRINTER_DS_1900Y), Content);
    Exit;
  end;
  // DASCOM DL_218Z Printer
  if DevicePath = PRINTER_DL_218Z then
  begin
    _Do_Print(_Get_Printer(PRINTER_DL_218Z), Content);
    Exit;
  end;
  //DASCOM
  if DevicePath = 'DASCOM' then
  begin
    _Do_Print(_Get_Dascom_Printer, Content);
    Exit;
  end;
  //START
  if DevicePath = 'START' then
  begin
    _Do_Print(_Get_Start_Printer, Content);
    Exit;
  end;
  // Jolimark MP-220DC
  if DevicePath = PRINTER_Jolimark_MP_220DC then
  begin
    _Do_Print(_Get_Printer(PRINTER_Jolimark_MP_220DC), Content);
    Exit;
  end;
  //Jolimark FP-830K
  if DevicePath = PRINTER_Jolimark_FP_830K then
  begin
    _Do_Print(_Get_Printer(PRINTER_Jolimark_FP_830K), Content);
    Exit;
  end;
  //Jolimark FP-570KII
  if DevicePath = PRINTER_Jolimark_FP_570KII then
  begin
    _Do_Print(_Get_Printer(PRINTER_Jolimark_FP_570KII), Content);
    Exit;
  end;
  //Jolimark
  if DevicePath = 'Jolimark' then
  begin
    _Do_Print(_Get_Jolimark_Printer, Content);
    Exit;
  end;
  //EPSON LQ-80KFII
  if DevicePath = PRINTER_EPSON_LQ_80KFII then
  begin
    _Do_Print(_Get_Printer(PRINTER_EPSON_LQ_80KFII), Content);
    Exit;
  end;
  //EPSON
  if DevicePath = 'EPSON' then
  begin
    _Do_Print(_Get_Epson_Printer, Content);
    Exit;
  end;
  _Do_Print(DevicePath, Content);
end;

end.
