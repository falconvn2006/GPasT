unit UTools;

interface

uses
  SysUtils, Classes, StdCtrls, Variants, Windows, Registry, WinSvc;
function InterbaseRunning : boolean;
function ShutDownInterbase : boolean;
function StartInterbase : boolean;
function ShutDownWinUpdate : boolean;
function StartWinUpdate : boolean;

implementation

function ServiceStart(sMachine, sService : string ) : boolean;
var
  schm, schs  : SC_Handle;
  ss          : TServiceStatus;
  psTemp      : PChar;
  dwChkP      : DWord;
begin
  ss.dwCurrentState := 0;
  schm := OpenSCManager(PChar(sMachine),Nil,SC_MANAGER_CONNECT);
  if(schm > 0)then
  begin
    schs := OpenService(schm,PChar(sService),SERVICE_START or SERVICE_QUERY_STATUS);
    if (schs > 0) then
    begin
      psTemp := Nil;
      if (StartService(schs,0,psTemp)) then
      begin
        if (QueryServiceStatus(schs,ss)) then
        begin
          while (SERVICE_RUNNING <> ss.dwCurrentState) do
          begin
            dwChkP := ss.dwCheckPoint;
            Sleep(ss.dwWaitHint);
            if (not QueryServiceStatus(schs,ss)) then
            begin
              break;
            end;
            if (ss.dwCheckPoint < dwChkP) then
            begin
              break;
            end;
          end;
        end;
      end;
      CloseServiceHandle(schs);
    end;
    CloseServiceHandle(schm);
  end;
  Result := SERVICE_RUNNING = ss.dwCurrentState;
end;

function ServiceStop(sMachine, sService : string ) : boolean;
var
  schm, schs  : SC_Handle;
  ss          : TServiceStatus;
  dwChkP      : DWord;
begin
  schm := OpenSCManager(PChar(sMachine),Nil,SC_MANAGER_CONNECT);
  if(schm > 0)then
  begin
    schs := OpenService(schm,PChar(sService),SERVICE_STOP or SERVICE_QUERY_STATUS);
    if(schs > 0)then
    begin
      if (ControlService(schs,SERVICE_CONTROL_STOP,ss)) then
      begin
        if (QueryServiceStatus(schs,ss)) then
        begin
          while (SERVICE_STOPPED <> ss.dwCurrentState) do
          begin
            dwChkP := ss.dwCheckPoint;
            Sleep(ss.dwWaitHint);
            if (not QueryServiceStatus(schs,ss))then
            begin
              break;
            end;
            if (ss.dwCheckPoint < dwChkP) then
            begin
              break;
            end;
          end;
        end;
      end;
      CloseServiceHandle(schs);
    end;
    CloseServiceHandle(schm);
  end;
  Result := (SERVICE_STOPPED = ss.dwCurrentState);
end;

function InterbaseRunning : boolean;
begin
  result := boolean(FindWindow('IB_Server','InterBase Server') or FindWindow('IB_Guard','InterBase Guardian'));
end;

function ShutDownInterbase : boolean;
var
  IBSRVHandle,IBGARHandle : THandle;
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
    result := ServiceStop('','InterBaseGuardian');
  end
  else
  begin
    IBGARHandle := FindWindow('IB_Guard','InterBase Guardian');
    if IBGARHandle > 0 then
    begin
      PostMessage(IBGARHandle,31,0,0);
      PostMessage(IBGARHandle,16,0,0);
    end;
    IBSRVHandle := FindWindow('IB_Server','InterBase Server');
    if IBSRVHandle > 0 then
    begin
      PostMessage(IBSRVHandle,31,0,0);
      PostMessage(IBSRVHandle,16,0,0);
    end;
    result := InterbaseRunning;
  end;
end;

function ShutDownWinUpdate: boolean;
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
    Result := ServiceStop('','wuauserv');
  end
  else
  begin
    Result := False;
  end;
end;

//-----------------------------------------------------------------------------
// Starts Interbase
//-----------------------------------------------------------------------------
function StartInterbase : boolean;
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
    result := ServiceStart('','InterBaseGuardian');
  end
  else
    result := false;
end;

function StartWinUpdate: boolean;
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
    Result := ServiceStart('','wuauserv');
  end
  else
  begin
    Result := False;
  end;
end;

end.
