unit uWinSpoolUtils;

{$mode objfpc}{$H+}

interface

uses
  Windows, Classes, SysUtils, winspool, LConvEncoding, uLogger;

type
  TPaper = record
    PageSize: integer;
    Name: string;
    Width: integer;
    Height: integer;
  end;
  TAllPaper = array of TPaper;
  TAllPrinter = array of string;

function GetAllPrinter: TAllPrinter;
function GetDefaultPrinter: string;
function GetAllPaper: TAllPaper;
function GetAllPaper(const PrinterName: string): TAllPaper; overload;
function GetPaper(const PaperName: string): TPaper;
function GetPaper(const PrinterName, PaperName: string): TPaper; overload;
function SetDefaultPaper(const PaperName: string): boolean;
function SetDefaultPaper(const PrinterName, PaperName: string): boolean; overload;
function AddCustomPaper(const PaperName: string; const PaperWidth, PaperHeight: integer): boolean;
function AddCustomPaper(const PrinterName, PaperName: string; const PaperWidth, PaperHeight: integer): boolean; overload;
function DeleteCustomPaper(const PaperName: string): boolean;
function DeleteCustomPaper(const PrinterName, PaperName: string): boolean; overload;

implementation

function GetDefaultPrinter: string;
var
  DefaultString: array [0..256] of char;
  ReturnedString: array [0..256] of char;
begin
  GetProfileString(PChar('Windows'), PChar('device'), DefaultString, ReturnedString, Sizeof(ReturnedString));
  Result := Copy(ReturnedString, 0, Pos(',', ReturnedString) - 1);
end;

function GetAllPrinter: TAllPrinter;
var
  i: integer;
  Flags: DWORD = PRINTER_ENUM_CONNECTIONS or PRINTER_ENUM_LOCAL;
  cReturned, cbNeeded: DWORD;
  Buffer, pPrinterEnum: PByte;
begin
  SetLength(Result, 0);
  EnumPrinters(Flags, nil, DWORD(2), nil, 0, @cbNeeded, @cReturned);
  if cbNeeded <= 0 then
  begin
    Exit;
  end;
  GetMem(Buffer, cbNeeded);
  Fillchar(Buffer^, cbNeeded, 0);
  try
    if EnumPrinters(Flags, nil, DWORD(2), Buffer, cbNeeded, @cbNeeded, @cReturned) then
    begin
      pPrinterEnum := Buffer;
      for i := 0 to cReturned - 1 do
      begin
        SetLength(Result, i + 1);
        Result[i] := CP936ToUTF8(StrPas(PPRINTER_INFO_2(pPrinterEnum)^.pPrinterName));
        Inc(pPrinterEnum, SizeOf(PRINTER_INFO_2));
      end;
    end;
  finally
    FreeMem(Buffer);
  end;
end;

function GetAllPaper: TAllPaper;
begin
  Result := GetAllPaper(GetDefaultPrinter);
end;

function GetAllPaper(const PrinterName: string): TAllPaper;
var
  i: integer;
  hPrinter: HANDLE;
  Buffer, pForm: LPBYTE;
  cbNeeded, cReturned: DWORD;
begin
  SetLength(Result, 0);
  if not OpenPrinter(PChar(PrinterName), @hPrinter, nil) then
  begin
    logger.Error('GetAllPaper OpenPrinter(%s)=False', [PrinterName]);
    Exit;
  end;
  EnumForms(hPrinter, DWORD(1), nil, 0, @cbNeeded, @cReturned);
  if cbNeeded > 0 then
  begin
    GetMem(Buffer, cbNeeded);
    Fillchar(Buffer^, cbNeeded, 0);
    try
      if EnumForms(hPrinter, DWORD(1), Buffer, cbNeeded, @cbNeeded, @cReturned) then
      begin
        pForm := Buffer;
        for i := 0 to cReturned - 1 do
        begin
          SetLength(Result, i + 1);
          Result[i].PageSize := i + 1;
          Result[i].Name := CP936ToUTF8(StrPas(LPFORM_INFO_1(pForm)^.pName));
          Result[i].Width := LPFORM_INFO_1(pForm)^.Size.Width div 100;
          Result[i].Height := LPFORM_INFO_1(pForm)^.Size.Height div 100;
          Inc(pForm, SizeOf(FORM_INFO_1));
        end;
      end;
    finally
      FreeMem(Buffer);
    end;
  end;
  ClosePrinter(hPrinter);
end;

function GetPaper(const PaperName: string): TPaper;
begin
  Result := GetPaper(GetDefaultPrinter, PaperName);
end;

function GetPaper(const PrinterName, PaperName: string): TPaper;
var
  i: integer;
  AllPaper: TAllPaper;
begin
  AllPaper := GetAllPaper(PrinterName);
  for  i := 0 to Length(AllPaper) - 1 do
  begin
    if AllPaper[i].Name = PaperName then
    begin
      Result := AllPaper[i];
      Exit;
    end;
  end;
end;

function SetDefaultPaper(const PaperName: string): boolean;
begin
  Result := SetDefaultPaper(GetDefaultPrinter, PaperName);
end;

function SetDefaultPaper(const PrinterName, PaperName: string): boolean;
var
  Paper: TPaper;
  hPrinter: HANDLE;
  Buffer, pPrinter: LPBYTE;
  cbNeeded: DWORD;
  pDMode: PDevMode;
begin
  Result := False;
  Paper := GetPaper(PaperName);
  if not OpenPrinter(PChar(PrinterName), @hPrinter, nil) then
  begin
    logger.Error('SetDefaultPaper OpenPrinter(%s)=False', [PrinterName]);
    Exit;
  end;
  GetPrinter(hPrinter, DWORD(2), nil, 0, @cbNeeded);
  if cbNeeded <= 0 then
  begin
    Exit;
  end;
  GetMem(Buffer, cbNeeded);
  Fillchar(Buffer^, cbNeeded, 0);
  try
    if not GetPrinter(hPrinter, DWORD(2), Buffer, cbNeeded, @cbNeeded) then
    begin
      Exit;
    end;
    pPrinter := Buffer;
    pDMode := LPPRINTER_INFO_2(pPrinter)^.pDevMode;
    pDMode^.dmPaperSize := Paper.PageSize;
    SetPrinter(hPrinter, DWORD(2), pPrinter, DWORD(0));
    Result := True;
  finally
    FreeMem(Buffer);
    ClosePrinter(hPrinter);
  end;

end;

function AddCustomPaper(const PaperName: string; const PaperWidth, PaperHeight: integer): boolean;
begin
  Result := AddCustomPaper(GetDefaultPrinter, PaperName, PaperWidth, PaperHeight);
end;

function AddCustomPaper(const PrinterName, PaperName: string; const PaperWidth, PaperHeight: integer): boolean;
var
  hPrinter: HANDLE;
  aSize: SIZEL;
  aImageableArea: RECTL;
  FormInfo: FORM_INFO_1;
begin
  Result := False;
  if not OpenPrinter(PChar(PrinterName), @hPrinter, nil) then
  begin
    logger.Error('AddCustomPaper OpenPrinter(%s)=False', [PrinterName]);
    Exit;
  end;
  try
    FormInfo.Flags := FORM_USER;
    FormInfo.pName := PChar(PaperName);
    aSize.Width := PaperWidth * 100;
    aSize.Height := PaperHeight * 100;
    FormInfo.Size := aSize;
    aImageableArea.left := 0;
    aImageableArea.top := 0;
    aImageableArea.right := aSize.Width;
    aImageableArea.bottom := aSize.Height;
    FormInfo.ImageableArea := aImageableArea;
    Result := AddForm(hPrinter, DWORD(1), @FormInfo);
  finally
    ClosePrinter(hPrinter);
  end;
end;

function DeleteCustomPaper(const PaperName: string): boolean;
begin
  Result := DeleteCustomPaper(GetDefaultPrinter, PaperName);
end;

function DeleteCustomPaper(const PrinterName, PaperName: string): boolean;
var
  hPrinter: HANDLE;
begin
  Result := False;
  if not OpenPrinter(PChar(PrinterName), @hPrinter, nil) then
  begin
    logger.Error('DeleteCustomPaper OpenPrinter(%s)=False', [PrinterName]);
    Exit;
  end;
  try
    Result := DeleteForm(hPrinter, PChar(PaperName));
  finally
    ClosePrinter(hPrinter);
  end;
end;

end.
