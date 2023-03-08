unit uCMD;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  uLog, Vcl.Dialogs, Winapi.ShellAPI;

procedure RunCMD(cmdLine: string; WindowMode: integer);

implementation

procedure RunCMD(cmdLine: string; WindowMode: integer);

  procedure ShowWindowsErrorMessage(r: integer);
  var
    sMsg: string;
  begin
    sMsg := SysErrorMessage(r);
    if (sMsg = '') and (r = ERROR_BAD_EXE_FORMAT) then
      sMsg := SysErrorMessage(ERROR_BAD_FORMAT);
    MessageDlg(sMsg, mtError, [mbOK], 0);
  end;

var
  si: TStartupInfo;
  pi: TProcessInformation;
  sei: TShellExecuteInfo;
  err: Integer;
begin
  // We need a function which does following:
  // 1. Replace the Environment strings, e.g. %SystemRoot%  --> ExpandEnvStr
  // 2. Runs EXE files with parameters (e.g. "cmd.exe /?")  --> WinExec
  // 3. Runs EXE files without path (e.g. "calc.exe")       --> WinExec
  // 4. Runs EXE files without extension (e.g. "calc")      --> WinExec
  // 5. Runs non-EXE files (e.g. "Letter.doc")              --> ShellExecute
  // 6. Commands with white spaces (e.g. "C:\Program Files\xyz.exe") must be enclosed in quotes.

  cmdLine := ExpandEnvStr(cmdLine);
  {$IFDEF UNICODE}
  UniqueString(cmdLine);
  {$ENDIF}

  ZeroMemory(@si, sizeof(si));
  si.cb := sizeof(si);
  si.dwFlags := STARTF_USESHOWWINDOW;
  si.wShowWindow := WindowMode;

  if CreateProcess(nil, PChar(cmdLine), nil, nil, False, 0, nil, nil, si, pi) then
  begin
    CloseHandle(pi.hThread);
    CloseHandle(pi.hProcess);
    Exit;
  end;

  err := GetLastError;
  if (err = ERROR_BAD_EXE_FORMAT) or
     (err = ERROR_BAD_FORMAT) then
  begin
    ZeroMemory(@sei, sizeof(sei));
    sei.cbSize := sizeof(sei);
    sei.lpFile := PChar(cmdLine);
    sei.nShow := WindowMode;

    if ShellExecuteEx(@sei) then Exit;
    err := GetLastError;
  end;

  ShowWindowsErrorMessage(err);
end;

end.
