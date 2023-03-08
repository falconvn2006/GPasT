unit ServiceControler;

interface

/// <summary>Verifie si le service existe</summary>
/// <param name="sMachine">machine name, ie: \SERVER (empty = local machine)</param>
/// <param name="sService">service name, ie: Alerter</param>
/// <returns>return TRUE si le service est installer sur la machine</returns>
function ServiceExist(sMachine, sService : string) : boolean;

/// <summary>Installation d'un service</summary>
/// <param name="servicePath">repertoire ou se trouve l'exe du service</param>
/// <param name="serviceExe">nom de l'exe du service</param>
/// <remarks>Cette fonction provoque l'apparition de boite de dialogue (installation reussit ou non).</remarks>
procedure InstallService(servicePath, serviceExe : string);

/// <summary>start service</summary>
/// <param name="sMachine">machine name, ie: \SERVER (empty = local machine)</param>
/// <param name="sService">service name, ie: Alerter</param>
/// <returns>return TRUE if successful</returns>
function ServiceStart(sMachine, sService : string) : boolean;
/// <summary>stop service
/// <param name="sMachine>machine name, ie: \SERVER (empty = local machine)</param>
/// <param name="sService>service name, ie: Alerter</param>
/// <returns>return TRUE if successful</returns>
function ServiceStop(sMachine, sService : string) : boolean;
function ServiceGetStatus(sMachine, sService: PChar): word;


implementation

uses
  WinSvc, Types, SysUtils, ShellAPI, Windows;


function ServiceGetStatus(sMachine, sService: PChar): WORD;
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
var
  SCManHandle, SvcHandle: SC_Handle;
  SS: TServiceStatus;
  dwStat: WORD;
begin
  dwStat := 0;
  // Open service manager handle.
  SCManHandle := OpenSCManager(sMachine, nil, SC_MANAGER_CONNECT);
  if (SCManHandle > 0) then
  begin
    SvcHandle := OpenService(SCManHandle, sService, SERVICE_QUERY_STATUS);
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

procedure InstallService(servicePath, serviceExe : string);
begin
  ShellExecute(0, 'open', PWideChar(IncludeTrailingPathDelimiter(servicePath) + serviceExe),
               '/install', PWideChar(servicePath), SW_HIDE);
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

end.