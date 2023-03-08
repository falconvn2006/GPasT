unit ucsystray;
  { removes dead system tray icons, by Glenn1234 @ stackoverflow.com
    since this uses "less than supported by Microsoft" means, it may
    not work on all operating system.  It was tested on Windows XP }
interface
  uses commCtrl, shellapi, windows;
type
  TTrayInfo = packed record
    hWnd: HWnd;
    uID: UINT;
    uCallBackMessage: UINT;
    Reserved1: array[0..1] of longint;
    Reserved2: array[0..2] of longint;
    hIcon: HICON;
  end;
  PTBButton = ^TTBButton;
  _TBBUTTON = packed record
    iBitmap: Integer;
    idCommand: Integer;
    fsState: Byte;
    fsStyle: Byte;
    bReserved: array[1..2] of Byte;
    dwData: Longint;
    iString: Integer;
  end;
  TTBButton = _TBBUTTON;

procedure RemoveStaleTrayIcons;

implementation

procedure RemoveStaleTrayIcons;
const
  VMFLAGS = PROCESS_VM_OPERATION or PROCESS_VM_READ OR PROCESS_VM_WRITE;
var
  ProcessID: THandle;
  ProcessHandle: THandle;
  trayhandle: HWnd;
  ExplorerButtonInfo: Pointer;
  i: integer;
  ButtonCount: Longint;
  BytesRead: Longint;
  ButtonInfo: TTBButton;
  TrayInfo: TTrayInfo;
  ClassNameA: Array[0..255] of char;
  outlen: integer;
  TrayIconData: TNotifyIconData;
begin
  // walk down the window hierarchy to find the notification area window
  trayhandle := FindWindow('Shell_TrayWnd', '');
  trayhandle := FindWindowEx(trayhandle, 0, 'TrayNotifyWnd', nil);
  trayhandle := FindWindowEx(trayhandle, 0, 'SysPager', nil);
  trayhandle := FindWindowEx(trayhandle, 0, 'ToolbarWindow32', nil);
  if trayhandle = 0 then exit;
  // find the notification area process and open it up for reading.
  GetWindowThreadProcessId(trayhandle, @ProcessID);
  ProcessHandle := OpenProcess(VMFLAGS, false, ProcessID);
  ExplorerButtonInfo := VirtualAllocEx(ProcessHandle, nil, Sizeof(TTBButton),
       MEM_RESERVE or MEM_COMMIT, PAGE_READWRITE);
  // the notification area is a tool bar.  Get the number of buttons.
  ButtonCount := SendMessage(trayhandle, TB_BUTTONCOUNT, 0, 0);
  if ExplorerButtonInfo <> nil then
    try
      // iterate the buttons & check.
      for i := (ButtonCount - 1) downto 0 do
        begin
          // get button information.
          SendMessage(trayhandle, TB_GETBUTTON, i, LParam(ExplorerButtonInfo));
          ReadProcessMemory(ProcessHandle, ExplorerButtonInfo, @ButtonInfo,
             Sizeof(TTBButton), BytesRead);
          // if there's tray data, read and process
          if Buttoninfo.dwData <> 0 then
            begin
              ReadProcessMemory(ProcessHandle, PChar(ButtonInfo.dwData),
                                @TrayInfo, Sizeof(TTrayInfo), BytesRead);
              // here's the validation test, this fails if the master window is invalid
              outlen := GetClassName(TrayInfo.hWnd, ClassNameA, 256);
              if outlen < 1 then
                begin
                  // duplicate the shell icon removal, i.e. my component's DeleteTray
                  TrayIconData.cbSize := sizeof(TrayIconData);
                  TrayIconData.Wnd := TrayInfo.hWnd;
                  TrayiconData.uID := TrayInfo.uID;
                  TrayIconData.uCallbackMessage := TrayInfo.uCallBackMessage;
                  Shell_NotifyIcon(NIM_DELETE, @TrayIconData);
                end;
            end;
        end;
    finally
      VirtualFreeEx(ProcessID, ExplorerButtonInfo, Sizeof(TTBButton), MEM_RELEASE);
    end;
end;

end.
