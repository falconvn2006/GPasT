unit uPrinter;

{$mode objfpc}
{$H+}

interface

uses
  SysUtils, StrUtils, uDevice, uTooanClass;

type
  { IPrinter }
  IPrinter = interface(ITooanIface)
    function GetAllPrinter: IDeviceArray;
    function Exists(const DevicePath: string): boolean;
    procedure Print(DevicePath, Content: string);
  end;

  { TPrinterCreateFactory }
  TPrinterCreateFactory = class
  public
    class  function CreatePrinter(const PortType: string): IPrinter;
  end;

implementation

uses
  uParallelPortPrinter, uSerialPortPrinter, uUSBPortPrinter, uDriverPrinter, uNetworkPrinter;

{ TPrinterCreateFactory }

class  function TPrinterCreateFactory.CreatePrinter(const PortType: string): IPrinter;
const
  Support_PortType: array[0..4] of string = ('LPT', 'COM', 'USB', 'DRIVER', 'NETWORK');
begin
  case AnsiIndexStr(UpperCase(PortType), Support_PortType) of
    0: Result := TParallelPortPrinter.Create;
    1: Result := TSerialPortPrinter.Create;
    2: Result := TUsbPrinter.Create;
    3: Result := TDriverPrinter.Create;
    4: Result := TNetworkPrinter.Create;
    else
      raise TPrinterException.Create(UNSUPPORT_PORTTYPE_ERROR_CODE, PortType + ' is UnSupport PortType');
  end;
end;

end.
