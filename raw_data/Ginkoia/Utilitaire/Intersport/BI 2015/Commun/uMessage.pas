unit uMessage;

interface

uses
  Winapi.Windows,
  Winapi.Messages;

const
  WM_START_TRT = WM_USER +1;
  WM_HIDE_WINDOW = WM_USER +2;
  WM_ASK_TO_KILL = WM_USER +3;
  WM_TERMINATED = WM_USER +4;

implementation

end.
