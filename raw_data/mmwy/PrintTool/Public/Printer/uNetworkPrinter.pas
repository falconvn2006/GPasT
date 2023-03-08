unit uNetworkPrinter;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, uDevice, uPrinter, uTooanClass;

type

  { TSerialPortPrinter }

  { TNetworkPrinter }

  TNetworkPrinter = class(TTooanAbstractClass, IPrinter)
    function GetAllPrinter: IDeviceArray;
    function Exists(const DevicePath: string): boolean;
    procedure Print(DevicePath, Content: string);
  end;

implementation

uses
  LConvEncoding,
  IdGlobal, IdTelnet;

{ TNetworkPrinter }

function TNetworkPrinter.GetAllPrinter: IDeviceArray;
begin

end;

function TNetworkPrinter.Exists(const DevicePath: string): boolean;
begin

end;

procedure TNetworkPrinter.Print(DevicePath, Content: string);
var
  AStrings: TStringList = nil;
  Host: string;
  Port: integer;
  Telnet: TIdTelnet = nil;
begin
  AStrings := TStringList.Create;
  try
    SplitDelimitedString(DevicePath, AStrings, True, ':');
    Host := AStrings.Strings[0];
    if AStrings.Count > 1 then
      Port := StrToInt(AStrings.Strings[1])
    else
      Port := 9100;
  finally
    FreeAndNil(AStrings);
  end;
  Telnet := TIdTelnet.Create;
  try
    Telnet.Host := Host;
    Telnet.Port := Port;
    Telnet.Connect;
    Telnet.IOHandler.DefStringEncoding := IndyTextEncoding_OSDefault;
    Telnet.SendString(Content);
    Telnet.Disconnect;
  finally
    FreeAndNil(Telnet);
  end;
end;

end.
