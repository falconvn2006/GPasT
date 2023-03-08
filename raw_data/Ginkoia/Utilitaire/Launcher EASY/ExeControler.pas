unit ExeControler;

interface

USes Types, SysUtils, ShellAPI, Windows, TlHelp32, Vcl.Controls, Vcl.ComCtrls;


function ProcessExists(exeFileName: string): boolean;
function ExeStart(exeName: string; params:string = ''): boolean;
function ExeStop(exeName: string): boolean;



implementation


function ProcessExists(exeFileName: string): Boolean;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  Result := False;
  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile))
      = UpperCase(exeFileName)) or (UpperCase(FProcessEntry32.szExeFile)
      = UpperCase(exeFileName))) then
    begin
      Result := True;
    end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

function ExeStart(exeName: string; params:string = ''): boolean;
var
  codeRetour: integer;
  exePath: string;
begin
  Result := False;

  exePath := extractFilePath(ParamStr(0)) + exeName;



  codeRetour := ShellExecute(0, 'Open', PWideChar(exePath), PWideChar(params), Nil, SW_SHOWDEFAULT);

  if codeRetour > 32 then
    Result := True;
end;

function ExeStop(exeName: string): boolean;
var
  codeRetour: LongBool;
  ProcessEntry32 : TProcessEntry32;
  HSnapShot : THandle;
  HProcess : THandle;
  bOk:boolean;
  s:string;
begin
  Result := False;

  HSnapShot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if HSnapShot = 0 then
    exit;
  ProcessEntry32.dwSize := sizeof(ProcessEntry32);
  bOk:=Process32First(HSnapShot, ProcessEntry32);
  while bOk do begin
    s := String(ProcessEntry32.szExeFile);
    if UpperCase(s)=UpperCase(exeName) then
    begin
      HProcess := OpenProcess(PROCESS_TERMINATE, False, ProcessEntry32.th32ProcessID);
      if HProcess <> 0 then
      begin
        codeRetour := TerminateProcess(HProcess, 0);
        CloseHandle(HProcess);

        if codeRetour then
          Result := True;
      end;
      Break;
    end;
    bOk := Process32Next(HSnapShot, ProcessEntry32);
  end;
  CloseHandle(HSnapshot);
end;


end.
