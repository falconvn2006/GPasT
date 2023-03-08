unit uParallelPortPrinter;

{$mode objfpc}
{$H+}

interface

uses
  Classes, SysUtils, Windows, uDevice, uPrinter, uTooanClass, uLogger;

type

  { TParallelPortPrinter }
  TParallelPortPrinter = class(TTooanAbstractClass, IPrinter)
    function GetAllPrinter: IDeviceArray;
    function Exists(const DevicePath: string): boolean;
    procedure Print(DevicePath, Content: string);
  end;

implementation

{ TParallelPortPrinter }
function TParallelPortPrinter.GetAllPrinter: IDeviceArray;
var
  i: integer;
  aDevice: IDevice;
  PortName: string;
  gm_DeviceHandle: THandle;
begin
  //Result := LoadPortsFromRegistry('\HARDWARE\DEVICEMAP\PARALLEL PORTS');
  SetLength(Result, 0);
  for i := 0 to 3 do
  begin
    PortName := Format('\\.\LPT%d', [i]);
    gm_DeviceHandle := CreateFile(PChar(PortName), GENERIC_WRITE, 0, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
    try
      if gm_DeviceHandle <> INVALID_HANDLE_VALUE then
      begin
        aDevice := TDevice.Create(Format('LPT%d', [i]));
        SetLength(Result, Length(Result) + 1);
        Result[Length(Result) - 1] := aDevice;
      end;
    finally
      if INVALID_HANDLE_VALUE <> gm_DeviceHandle then
      begin
        CloseHandle(gm_DeviceHandle);
      end;
    end;
  end;
end;

function TParallelPortPrinter.Exists(const DevicePath: string): boolean;
begin
  Result := True;
end;

procedure TParallelPortPrinter.Print(DevicePath, Content: string);
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

end.
