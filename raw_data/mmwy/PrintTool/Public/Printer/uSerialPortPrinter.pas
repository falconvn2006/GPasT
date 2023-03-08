unit uSerialPortPrinter;

{$mode objfpc}
{$H+}

interface

uses
  Classes, SysUtils, uDevice, uPrinter, uTooanClass;

type

  { TSerialPortPrinter }
  TSerialPortPrinter = class(TTooanAbstractClass, IPrinter)
    function GetAllPrinter: IDeviceArray;
    function Exists(const DevicePath: string): boolean;
    procedure Print(DevicePath, Content: string);
  end;


implementation

uses uDevGUID, serial;

{ TSerialPortPrinter }
function TSerialPortPrinter.GetAllPrinter: IDeviceArray;
begin
  Result := LoadDevices(GUID_DEVCLASS_PORTS);
end;

function TSerialPortPrinter.Exists(const DevicePath: string): boolean;
begin
  Result := True;
end;

procedure TSerialPortPrinter.Print(DevicePath, Content: string);
var
  serialhandle: TSerialHandle;
  status: longint;
begin
  serialhandle := SerOpen(DevicePath);
  if serialhandle <= 0 then
  begin
    raise TPrinterException.Create(OPEN_PRINTER_ERROR_CODE, 'device ' + DevicePath + ' could not be found.');
  end;
  try
    SerSetParams(serialhandle, 9600, 8, NoneParity, 1, []);
    status := SerWrite(serialhandle, ansistring(Content)[1], length(ansistring(Content)));
    if status <= 0 then
    begin
      raise TPrinterException.Create(UNKNOW_ERROR_CODE, 'ERROR - Unable to send.');
    end;
  finally
    SerSync(serialhandle);
    SerFlushOutput(serialhandle);
    SerClose(serialhandle);
  end;
end;

end.
