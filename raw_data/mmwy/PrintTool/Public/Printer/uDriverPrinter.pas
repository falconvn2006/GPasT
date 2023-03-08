unit uDriverPrinter;

{$mode objfpc}
{$H+}

interface

uses
  Classes, SysUtils, Windows, winspool, uDevice, uPrinter, uTooanClass, uLogger, uWinSpoolUtils;

type

  { TDriverPrinter }

  TDriverPrinter = class(TTooanAbstractClass, IPrinter)
    function GetAllPrinter: IDeviceArray;
    function Exists(const DevicePath: string): boolean;
    procedure Print(DevicePath, Content: string);
  end;

implementation


const
  DefaultDocName: string = 'uDriverPrinter';
  SupportDataType: string = 'RAW';


{ TDriverPrinter }

function TDriverPrinter.GetAllPrinter: IDeviceArray;
var
  i: integer;
  aDevice: IDevice;
  AllPrinter: TAllPrinter;
begin
  AllPrinter := uWinSpoolUtils.GetAllPrinter;
  SetLength(Result, Length(AllPrinter));
  for i := 0 to Length(AllPrinter) - 1 do
  begin
    aDevice := TDevice.Create(AllPrinter[i]);
    Result[i] := aDevice;
  end;
end;

function TDriverPrinter.Exists(const DevicePath: string): boolean;
var
  prn: string;
begin
  Result := False;
  for prn in uWinSpoolUtils.GetAllPrinter do
  begin
    if prn = DevicePath then
    begin
      Result := True;
      Exit;
    end;
  end;
end;

procedure TDriverPrinter.Print(DevicePath, Content: string);
var
  Handle: THandle;
  N: DWORD;
  DocInfo1: DOC_INFO_1;
begin
  if not OpenPrinter(PChar(DevicePath), @Handle, nil) then
  begin
    raise TPrinterException.Create(OPEN_PRINTER_ERROR_CODE);
  end;
  try
    with DocInfo1 do
    begin
      pDocName := PChar(DefaultDocName);
      pOutputFile := nil;
      pDataType := PChar(SupportDataType);
    end;
    if StartDocPrinter(Handle, 1, @DocInfo1) = 0 then
    begin
      raise TPrinterException.Create(START_DOC_PRINTER_ERROR_CODE);
    end;
    try
      if not StartPagePrinter(Handle) then
      begin
        raise TPrinterException.Create(START_PAGE_PRINTER_ERROR_CODE);
      end;
      try
        if not WritePrinter(Handle, PChar(Content), Length(Content), @N) then
        begin
          raise TPrinterException.Create(WRITE_PRINTER_ERROR_CODE);
        end;
      finally
        EndPagePrinter(Handle);
      end;
    finally
      EndDocPrinter(Handle);
    end;
  finally
    ClosePrinter(Handle);
  end;
end;

end.
