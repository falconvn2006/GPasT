unit uServiceControler;

interface

uses
  Types,
  Classes;

{
SERVICE_STATUS structure : http://msdn.microsoft.com/en-us/library/windows/desktop/ms685996%28v=vs.85%29.aspx

dwCurrentState
    The current state of the service. This member can be one of the following values.
			SERVICE_STOPPED          0x00000001 The service is not running.
			SERVICE_START_PENDING    0x00000002 The service is starting.
			SERVICE_STOP_PENDING     0x00000003 The service is stopping.
			SERVICE_RUNNING          0x00000004 The service is running.
			SERVICE_CONTINUE_PENDING 0x00000005 The service continue is pending.
			SERVICE_PAUSE_PENDING    0x00000006 The service pause is pending.
			SERVICE_PAUSED           0x00000007 The service is paused.

dwWin32ExitCode
    The error code the service uses to report an error that occurs when it is starting or stopping.
    To return an error code specific to the service, the service must set this value to
    ERROR_SERVICE_SPECIFIC_ERROR to indicate that the dwServiceSpecificExitCode member contains the
    error code. The service should set this value to NO_ERROR when it is running and on normal
    termination.

dwServiceSpecificExitCode
    A service-specific error code that the service returns when an error occurs while the service
    is starting or stopping. This value is ignored unless the dwWin32ExitCode member is set to
    ERROR_SERVICE_SPECIFIC_ERROR.


dwCheckPoint
    The check-point value the service increments periodically to report its progress during a 
		lengthy start, stop, pause, or continue operation. For example, the service should increment 
		this value as it completes each step of its initialization when it is starting up. The user 
		interface program that invoked the operation on the service uses this value to track the 
		progress of the service during a lengthy operation. This value is not valid and should be zero 
		when the service does not have a start, stop, pause, or continue operation pending.

dwWaitHint
    The estimated time required for a pending start, stop, pause, or continue operation, in
    milliseconds. Before the specified amount of time has elapsed, the service should make its next
    call to the SetServiceStatus function with either an incremented dwCheckPoint value or a change
    in dwCurrentState. If the amount of time specified by dwWaitHint passes, and dwCheckPoint has
    not been incremented or dwCurrentState has not changed, the service control manager or service
    control program can assume that an error has occurred and the service should be stopped.
    However, if the service shares a process with other services, the service control manager
    cannot terminate the service application because it would have to terminate the other services
    sharing the process as well.
}

const
  //
  // Service Types
  //
  SERVICE_KERNEL_DRIVER       = $00000001;
  SERVICE_FILE_SYSTEM_DRIVER  = $00000002;
  SERVICE_ADAPTER             = $00000004;
  SERVICE_RECOGNIZER_DRIVER   = $00000008;
  SERVICE_DRIVER              =
    (SERVICE_KERNEL_DRIVER or
     SERVICE_FILE_SYSTEM_DRIVER or
     SERVICE_RECOGNIZER_DRIVER);
  SERVICE_WIN32_OWN_PROCESS   = $00000010;
  SERVICE_WIN32_SHARE_PROCESS = $00000020;
  SERVICE_WIN32               =
    (SERVICE_WIN32_OWN_PROCESS or
     SERVICE_WIN32_SHARE_PROCESS);
  SERVICE_INTERACTIVE_PROCESS = $00000100;
  SERVICE_TYPE_ALL            =
    (SERVICE_WIN32 or
     SERVICE_ADAPTER or
     SERVICE_DRIVER  or
     SERVICE_INTERACTIVE_PROCESS);

function ServiceGetList(sMachine : string; dwServiceType, dwServiceState : DWord; slServicesList : TStrings; DisplayName : boolean = true) : boolean;

function ServiceExist(sMachine, sService : string) : boolean;
function ServiceGetStatus(sMachine, sService : string): word;

function CanManageService(sMachine : string; sService : string = 'Netlogon') : boolean;

procedure InstallService(servicePath, serviceExe : string);
procedure UnInstallService(servicePath, serviceExe : string);
function ServiceStart(sMachine, sService : string) : boolean;
function ServiceStop(sMachine, sService : string) : boolean;

function ServiceWaitStart(sMachine, sService : string; MaxTime : Cardinal) : boolean;
function ServiceWaitStop(sMachine, sService : string; MaxTime : Cardinal) : boolean;

implementation

uses
  WinSvc,
  SysUtils,
  ShellAPI,
  Windows;

//-------------------------------------
// Get a list of services
//
// return TRUE if successful
//
// sMachine:
//   machine name, ie: \SERVER
//   empty = local machine
//
// dwServiceType
//   SERVICE_WIN32,
//   SERVICE_DRIVER or
//   SERVICE_TYPE_ALL
//
// dwServiceState
//   SERVICE_ACTIVE,
//   SERVICE_INACTIVE or
//   SERVICE_STATE_ALL
//
// slServicesList
//   TStrings variable to storage
//

function ServiceGetList(sMachine : string; dwServiceType, dwServiceState : DWord; slServicesList : TStrings; DisplayName : boolean) : boolean;
const
  //
  // assume that the total number of
  // services is less than 4096.
  // increase if necessary
  cnMaxServices = 4096;
type
  TSvcA = array[0..cnMaxServices] of TEnumServiceStatus;
  PSvcA = ^TSvcA;
var
  //
  // temp. use
  j : integer;
  //
  // service control
  // manager handle
  schm          : SC_Handle;
  //
  // bytes needed for the
  // next buffer, if any
  nBytesNeeded,
  //
  // number of services
  nServices,
  //
  // pointer to the
  // next unread service entry
  nResumeHandle : DWord;
  //
  // service status array
  ssa : PSvcA;
begin
  Result := false;

  // connect to the service
  // control manager
  schm := OpenSCManager(
    PChar(sMachine),
    Nil,
    SC_MANAGER_ALL_ACCESS);

  // if successful...
  if(schm > 0)then
  begin
    nResumeHandle := 0;

    New(ssa);

    EnumServicesStatus(
      schm,
      dwServiceType,
      dwServiceState,
      ssa^[0],
      SizeOf(ssa^),
      nBytesNeeded,
      nServices,
      nResumeHandle );

    //
    // assume that our initial array
    // was large enough to hold all
    // entries. add code to enumerate
    // if necessary.
    //
    
    for j := 0 to nServices-1 do
    begin
      if DisplayName then
        slServicesList.Add(StrPas(ssa^[j].lpDisplayName))
      else
        slServicesList.Add(StrPas(ssa^[j].lpServiceName));
    end;

    Result := true;

    Dispose(ssa);

    // close service control
    // manager handle
    CloseServiceHandle(schm);
  end;
end;

function ServiceExist(sMachine, sService : string) : boolean;
var
  // service control
  // manager and service handle
  schm, schs : SC_Handle;
begin
  result := false;

  // connect to the service
  // control manager
  schm := OpenSCManager(PChar(sMachine), nil, SC_MANAGER_CONNECT);

  // if successful...
  if schm > 0 then
  begin
    // open a handle to
    // the specified service
    // we want to start the service and  query service status
    schs := OpenService(schm, PChar(sService), SERVICE_QUERY_STATUS);

    // if successful...
    if schs > 0 then
    begin
      Result := true;

      // close service handle
      CloseServiceHandle(schs);
    end;
    // close service control
    // manager handle
    CloseServiceHandle(schm);
  end;
end;

function ServiceGetStatus(sMachine, sService : string): WORD;
  {******************************************}
  {*** Parameters: ***}
  {*** sService: specifies the name of the service to open
  {*** sMachine: specifies the name of the target computer
  {*** ***}
  {*** Return Values: ***}
  {*** -1 = Error opening service ***}
  {*** 1 = SERVICE_STOPPED ***}
  {*** 2 = SERVICE_START_PENDING ***}
  {*** 3 = SERVICE_STOP_PENDING ***}
  {*** 4 = SERVICE_RUNNING ***}
  {*** 5 = SERVICE_CONTINUE_PENDING ***}
  {*** 6 = SERVICE_PAUSE_PENDING ***}
  {*** 7 = SERVICE_PAUSED ***}
  {******************************************}
  // Retour defini dans "Winapi.WinSvc"
var
  SCManHandle, SvcHandle: SC_Handle;
  SS: TServiceStatus;
  dwStat: WORD;
begin
  dwStat := 0;
  // Open service manager handle.
  SCManHandle := OpenSCManager(PChar(sMachine), nil, SC_MANAGER_CONNECT);
  if (SCManHandle > 0) then
  begin
    SvcHandle := OpenService(SCManHandle, PChar(sService), SERVICE_QUERY_STATUS);
    // if Service installed
    if (SvcHandle > 0) then
    begin
      // SS structure holds the service status (TServiceStatus);
      if (QueryServiceStatus(SvcHandle, SS)) then
        dwStat := ss.dwCurrentState;
      CloseServiceHandle(SvcHandle);
    end;
    CloseServiceHandle(SCManHandle);
  end;
  Result := dwStat;
end;

function CanManageService(sMachine : string; sService : string) : boolean;
var
  // service control
  // manager and service handle
  schm, schs : SC_Handle;
begin
  Result := false;

  // connect to the service
  // control manager
  schm := OpenSCManager(PChar(sMachine), nil, SC_MANAGER_CONNECT);

  // if successful...
  if schm > 0 then
  begin
    // open a handle to
    // the specified service
    // we want to start the service and  query service status
    schs := OpenService(schm, PChar(sService), SERVICE_START or SERVICE_STOP or SERVICE_QUERY_STATUS);

    // if successful...
    if schs > 0 then
    begin

      // si on arrive ici c'est qu'on a le droit !
      Result := true;

    end;
    // close service control
    // manager handle
    CloseServiceHandle(schm);
  end;
end;

procedure InstallService(servicePath, serviceExe : string);
begin
  ShellExecute(0, 'open', PChar(IncludeTrailingPathDelimiter(servicePath) + serviceExe),
               '/install /silent', PChar(servicePath), SW_HIDE);
end;

procedure UnInstallService(servicePath, serviceExe : string);
begin
  ShellExecute(0, 'open', PChar(IncludeTrailingPathDelimiter(servicePath) + serviceExe),
               '/uninstall /silent', PChar(servicePath), SW_HIDE);
end;

function ServiceStart(sMachine, sService : string) : boolean;
var
  // service control
  // manager and service handle
  schm, schs : SC_Handle;
  // service status
  ss : TServiceStatus;
  // temp char pointer
  psTemp : PChar;
  // check point
  dwChkP : DWord;
begin
  // connect to the service
  // control manager
  schm := OpenSCManager(PChar(sMachine), nil, SC_MANAGER_CONNECT);

  // if successful...
  if schm > 0 then
  begin
    // open a handle to
    // the specified service
    // we want to start the service and  query service status
    schs := OpenService(schm, PChar(sService), SERVICE_START or SERVICE_QUERY_STATUS);

    // if successful...
    if schs > 0 then
    begin
      psTemp := Nil;
      if StartService(schs, 0, psTemp) then
      begin
        // check status
        if QueryServiceStatus(schs, ss) then
        begin
          while ss.dwCurrentState <> SERVICE_RUNNING do
          begin
            //
            // dwCheckPoint contains a
            // value that the service
            // increments periodically
            // to report its progress
            // during a lengthy
            // operation.
            //
            // save current value
            //
            dwChkP := ss.dwCheckPoint;

            //
            // wait a bit before
            // checking status again
            //
            // dwWaitHint is the
            // estimated amount of time
            // the calling program
            // should wait before calling
            // QueryServiceStatus() again
            //
            // idle events should be
            // handled here...
            //
            Sleep(ss.dwWaitHint);

            if not QueryServiceStatus(schs, ss) then
            begin
              // couldn't check status
              // break from the loop
              break;
            end;

            if ss.dwCheckPoint < dwChkP then
            begin
              // QueryServiceStatus
              // didn't increment
              // dwCheckPoint as it
              // should have.
              // avoid an infinite
              // loop by breaking
              break;
            end;
          end;
        end;
      end;
      // close service handle
      CloseServiceHandle(schs);
    end;
    // close service control
    // manager handle
    CloseServiceHandle(schm);
  end;

  // return TRUE if
  // the service status is running
  Result := (ss.dwCurrentState = SERVICE_RUNNING);
end;

function ServiceStop(sMachine, sService : string) : boolean;
var
  // service control
  // manager and service handle
  schm, schs : SC_Handle;
  // service status
  ss : TServiceStatus;
  // check point
  dwChkP : DWord;
begin
  // connect to the service
  // control manager
  schm := OpenSCManager(PChar(sMachine), nil, SC_MANAGER_CONNECT);

  // if successful...
  if schm > 0 then
  begin
    // open a handle to
    // the specified service
    // we want to stop the service and query service status
    schs := OpenService(schm, PChar(sService), SERVICE_STOP or SERVICE_QUERY_STATUS);

    // if successful...
    if schs > 0 then
    begin
      if ControlService(schs, SERVICE_CONTROL_STOP, ss) then
      begin
        // check status
        if QueryServiceStatus(schs, ss) then
        begin
          while ss.dwCurrentState <> SERVICE_STOPPED do
          begin
            //
            // dwCheckPoint contains a
            // value that the service
            // increments periodically
            // to report its progress
            // during a lengthy
            // operation.
            //
            // save current value
            //
            dwChkP := ss.dwCheckPoint;

            //
            // wait a bit before
            // checking status again
            //
            // dwWaitHint is the
            // estimated amount of time
            // the calling program
            // should wait before calling
            // QueryServiceStatus() again
            //
            // idle events should be
            // handled here...
            //
            Sleep(ss.dwWaitHint);

            if not QueryServiceStatus(schs, ss) then
            begin
              // couldn't check status
              // break from the loop
              break;
            end;

            if ss.dwCheckPoint < dwChkP then
            begin
              // QueryServiceStatus
              // didn't increment
              // dwCheckPoint as it
              // should have.
              // avoid an infinite
              // loop by breaking
              break;
            end;
          end;
        end;
      end;
      // close service handle
      CloseServiceHandle(schs);
    end;
    // close service control
    // manager handle
    CloseServiceHandle(schm);
  end;

  // return TRUE if
  // the service status is stopped
  Result := (ss.dwCurrentState = SERVICE_STOPPED);
end;

function ServiceWaitStart(sMachine, sService : string; MaxTime : Cardinal) : boolean;
var
  // service control
  // manager and service handle
  schm, schs : SC_Handle;
  // service status
  ss : TServiceStatus;
  // temp char pointer
  psTemp : PChar;
  // check point
  dwChkP : DWord;
  // Start time for wait
  StartTime : Cardinal;
begin
  // get start time
  StartTime := GetTickCount();

  // connect to the service
  // control manager
  schm := OpenSCManager(PChar(sMachine), nil, SC_MANAGER_CONNECT);

  // if successful...
  if schm > 0 then
  begin
    // open a handle to
    // the specified service
    // we want to start the service and  query service status
    schs := OpenService(schm, PChar(sService), SERVICE_START or SERVICE_QUERY_STATUS);

    // if successful...
    if schs > 0 then
    begin
      psTemp := Nil;
      if StartService(schs, 0, psTemp) then
      begin
        // check status
        if QueryServiceStatus(schs, ss) then
        begin
          while ss.dwCurrentState <> SERVICE_RUNNING do
          begin
            //
            // dwCheckPoint contains a
            // value that the service
            // increments periodically
            // to report its progress
            // during a lengthy
            // operation.
            //
            // save current value
            //
            dwChkP := ss.dwCheckPoint;

            //
            // wait a bit before
            // checking status again
            //
            // dwWaitHint is the
            // estimated amount of time
            // the calling program
            // should wait before calling
            // QueryServiceStatus() again
            //
            // idle events should be
            // handled here...
            //
            Sleep(ss.dwWaitHint);

            if not QueryServiceStatus(schs, ss) then
            begin
              // couldn't check status
              // break from the loop
              break;
            end;

            if ss.dwCheckPoint < dwChkP then
            begin
              // QueryServiceStatus
              // didn't increment
              // dwCheckPoint as it
              // should have.
              // avoid an infinite
              // loop by breaking
              break;
            end;

            if GetTickCount() - StartTime > MaxTime then
            begin
              // Wait for too long...
              Break;
            end;
          end;
        end;
      end;
      // close service handle
      CloseServiceHandle(schs);
    end;
    // close service control
    // manager handle
    CloseServiceHandle(schm);
  end;

  // return TRUE if
  // the service status is running
  Result := (ss.dwCurrentState = SERVICE_RUNNING);
end;

function ServiceWaitStop(sMachine, sService : string; MaxTime : Cardinal) : boolean;
var
  // service control
  // manager and service handle
  schm, schs : SC_Handle;
  // service status
  ss : TServiceStatus;
  // check point
  dwChkP : DWord;
  // Start time for wait
  StartTime : Cardinal;
begin
  // get start time
  StartTime := GetTickCount();

  // connect to the service
  // control manager
  schm := OpenSCManager(PChar(sMachine), nil, SC_MANAGER_CONNECT);

  // if successful...
  if schm > 0 then
  begin
    // open a handle to
    // the specified service
    // we want to stop the service and query service status
    schs := OpenService(schm, PChar(sService), SERVICE_STOP or SERVICE_QUERY_STATUS);

    // if successful...
    if schs > 0 then
    begin
      if ControlService(schs, SERVICE_CONTROL_STOP, ss) then
      begin
        // check status
        if QueryServiceStatus(schs, ss) then
        begin
          while ss.dwCurrentState <> SERVICE_STOPPED do
          begin
            //
            // dwCheckPoint contains a
            // value that the service
            // increments periodically
            // to report its progress
            // during a lengthy
            // operation.
            //
            // save current value
            //
            dwChkP := ss.dwCheckPoint;

            //
            // wait a bit before
            // checking status again
            //
            // dwWaitHint is the
            // estimated amount of time
            // the calling program
            // should wait before calling
            // QueryServiceStatus() again
            //
            // idle events should be
            // handled here...
            //
            Sleep(ss.dwWaitHint);

            if not QueryServiceStatus(schs, ss) then
            begin
              // couldn't check status
              // break from the loop
              break;
            end;

            if ss.dwCheckPoint < dwChkP then
            begin
              // QueryServiceStatus
              // didn't increment
              // dwCheckPoint as it
              // should have.
              // avoid an infinite
              // loop by breaking
              break;
            end;

            if GetTickCount() - StartTime > MaxTime then
            begin
              // Wait for too long...
              Break;
            end;
          end;
        end;
      end;
      // close service handle
      CloseServiceHandle(schs);
    end;
    // close service control
    // manager handle
    CloseServiceHandle(schm);
  end;

  // return TRUE if
  // the service status is stopped
  Result := (ss.dwCurrentState = SERVICE_STOPPED);
end;

end.
