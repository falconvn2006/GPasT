unit ULaunchProcess;

interface

uses
  System.Types;

type
  TExecResultEvent = procedure(Resultat : Cardinal; Error : string) of object;

// base
function ExecProcess(commande, params : string; Show : boolean = false; path : string = '') : THandle;
procedure NotifyEndOfProcess(Process : THandle; NotifyFct : TExecREsultEvent);
function WaitProcess(ProcessID : DWORD; threaded : boolean = false; ttw : Cardinal = 100) : Cardinal; overload;
function WaitProcess(Process : THandle; threaded : boolean = false; ttw : Cardinal = 100) : Cardinal; overload;
// combiné
function ExecProcessAndNotify(commande, params : string; NotifyFct : TExecResultEvent; Show : boolean = false; path : string = '') : THandle;
function ExecAndWaitProcess(out Error : string; commande, params : string; Show : boolean = false; path : string = ''; threaded : boolean = false; ttw : Cardinal = 100) : Cardinal; overload;
// autres
function ExecAndWaitProcess(out Error, Output : string; commande, params : string; Show : boolean = false; path : string = ''; threaded : boolean = false; ttw : Cardinal = 100) : Cardinal; overload;
function ExecAndWaitProcessTimeout(out sError: String; sCommande, sParams: String; nTimeout: Integer; bShow: Boolean = False; sPath: String = ''; bThreaded: Boolean = False; nTtw: Cardinal = 100): Cardinal;

implementation

uses
  Winapi.ShellAPI,
  Winapi.Windows,
  Winapi.Tlhelp32,
  System.Classes,
  System.SysUtils,
{$IFDEF DEBUG}
  System.UITypes,
  Vcl.Dialogs,
{$ENDIF}
  Vcl.Forms;

type
  TExecProcessThread = class(TThread)
  private
    FProcess : THandle;
    FNotifyFct : TExecREsultEvent;
  protected
    procedure Execute(); override;
  public
    constructor Create(Process : THandle; NotifyFct : TExecREsultEvent; CreateSuspended: Boolean = false); reintroduce;
    destructor Destroy(); override;
  end;

// Utilitaire

function ExtractQuotedFilePath(const FileName : string) : string;
begin
  if FileName[1] = '"' then
    Result := ExtractFilePath(Copy(FileName, 2, Length(FileName) -2))
  else
    Result := ExtractFilePath(FileName);
end;

// fonctions de base

function ExecProcess(commande, params : string; Show : boolean; path : string) : THandle;
var
  seinfos : SHELLEXECUTEINFO;
begin
  Result := 0;
  // valeur des paramètre
  if Trim(Path) = '' then
    Path := ExtractQuotedFilePath(commande);
  if (Length(params) > 0) and not (params[1] = ' ') then
    params := ' ' + params;
  // info de lancement
  ZeroMemory(@seinfos, SizeOf(seinfos));
  seinfos.cbSize := SizeOf(seinfos);
  seinfos.fMask := SEE_MASK_NOCLOSEPROCESS;
  seinfos.Wnd := 0;
  seinfos.lpVerb := 'open';
  if Trim(commande) = '' then
    seinfos.lpFile := nil
  else
    seinfos.lpFile := PChar(commande);
  if Trim(params) = '' then
    seinfos.lpParameters := nil
  else
    seinfos.lpParameters := PChar(params);
  if Trim(path) = '' then
    seinfos.lpDirectory := nil
  else
    seinfos.lpDirectory := PChar(path);
  if Show then
    seinfos.nShow := SW_SHOW
  else
    seinfos.nShow := SW_HIDE;
  // lancement !
  if ShellExecuteEx(@seinfos) then
    Result := seinfos.hProcess;
end;

procedure NotifyEndOfProcess(Process : THandle; NotifyFct : TExecREsultEvent);
begin
  TExecProcessThread.Create(Process, NotifyFct);
end;

function WaitProcess(ProcessID : DWORD; threaded : boolean = false; ttw : Cardinal = 100) : Cardinal;
var
  tmpProcess : THandle;
begin
  tmpProcess := OpenProcess(STANDARD_RIGHTS_REQUIRED or SYNCHRONIZE or PROCESS_QUERY_INFORMATION, true, ProcessID);
  if tmpProcess = 0 then
    Result := GetLastError()
  else
    Result := WaitProcess(tmpProcess, threaded, ttw);
end;

function WaitProcess(Process : THandle; threaded : boolean; ttw : Cardinal) : Cardinal;
var
  WaitRes : DWORD;
  ProcessRet : Cardinal;
begin
  Result := High(Cardinal);
  WaitRes := WaitForSingleObject(Process, ttw);
  case WaitRes of
    WAIT_ABANDONED:
      begin
        // outch !
        {
        The specified object is a mutex object that was not released by the thread that owned the
        mutex object before the owning thread terminated. Ownership of the mutex object is
        granted to the calling thread and the mutex state is set to nonsignaled.

        If the mutex was protecting persistent state information, you should check it for consistency.
        }
{$IFDEF DEBUG}
        MessageDlg('Erreor dans le WaitForSingleObject -> WAIT_ABANDONED', mtError, [mbOK], 0);
{$ENDIF}
      end;
    WAIT_OBJECT_0:
      begin
        // rien a faire, c'est déjà terminé !
        if GetExitCodeProcess(Process, ProcessRet) then
          Result := ProcessRet;
        // et on close
        CloseHandle(Process);
      end;
    WAIT_TIMEOUT:
      begin
        // en attente du thread, on continue a attendre
        while WaitRes = WAIT_TIMEOUT do
        begin
          if not threaded then
            Application.ProcessMessages();
          WaitRes := WaitForSingleObject(Process, ttw);
        end;
        // resultat ??
        if GetExitCodeProcess(Process, ProcessRet) then
          Result := ProcessRet;
        // et on close
        CloseHandle(Process);
      end;
    WAIT_FAILED:
      begin
        // outch !
{$IFDEF DEBUG}
        MessageDlg('Erreor dans le WaitForSingleObject -> WAIT_FAILED', mtError, [mbOK], 0);
{$ENDIF}
        Result := GetLastError();
      end;
  end;
end;

// execution complète

function ExecProcessAndNotify(commande, params : string; NotifyFct : TExecResultEvent; Show : boolean; path : string) : THandle;
begin
  Result := ExecProcess(commande, params, Show, path);
  TExecProcessThread.Create(Result, NotifyFct);
end;

function ExecAndWaitProcess(out Error : string; commande, params : string; Show : boolean; path : string; threaded : boolean; ttw : Cardinal) : Cardinal;
var
  tmpHandle : THandle;
  ShellExRet : Cardinal;
begin
  Result := High(Cardinal);
  tmpHandle := ExecProcess(commande, params, Show, path);
  if tmpHandle = 0 then
  begin
    ShellExRet := GetLastError();
    Error := 'Code : "' + IntToStr(ShellExRet) + '" - Libelle : "' + SysErrorMessage(ShellExRet) + '"';
  end
  else
  begin
    Result := WaitProcess(tmpHandle, threaded, ttw);
    Error := 'Retour du process : "' + IntToStr(Result) + '"';
  end;
end;

// fonction a part !

function ExecAndWaitProcess(out Error, Output : string; commande, params : string; Show : boolean; path : string; threaded : boolean; ttw : Cardinal) : Cardinal;
const
  ReadBuffer = 4096;
var
  ReadPipe, WritePipe : THandle;
  cpsecurity : TSecurityAttributes;
  cpinfos : TStartUpInfo;
  cprocess : TProcessInformation;
  pCommande, pPath : PChar;
  ProcessRet : Cardinal;
  Buffer : PAnsiChar;
  BytesRead : DWord;
begin
  Buffer := nil;
  Error := '';
  output := '';
  // valeur des paramètre
  if (Trim(Path) = '') then
    Path := ExtractQuotedFilePath(commande);
  if (Length(params) > 0) and not (params[1] = ' ') then
    params := ' ' + params;
  // structure de securité
  ZeroMemory(@cpsecurity, SizeOf(TSecurityAttributes));
  cpsecurity.nlength := SizeOf(TSecurityAttributes);
  cpsecurity.lpsecuritydescriptor := nil;
  cpsecurity.binherithandle := true;
  // creation des pipe de données
  if Createpipe(ReadPipe, WritePipe, @cpsecurity, 0) then
  begin
    try
      // structure de demarage
      ZeroMemory(@cpinfos, SizeOf(TStartUpInfo));
      cpinfos.cb := SizeOf(TStartUpInfo);
      cpinfos.dwFlags := STARTF_USESTDHANDLES + STARTF_USESHOWWINDOW;
      if Trim(commande) = '' then
        pCommande := nil
      else
        pCommande := PChar(commande);
      if Trim(path) = '' then
        pPath := nil
      else
        pPath := PChar(path);
      if Show then
        cpinfos.wShowWindow := SW_SHOW
      else
        cpinfos.wShowWindow := SW_HIDE;
      cpinfos.hStdInput := ReadPipe;
      cpinfos.hStdOutput := WritePipe;

      if CreateProcess(pCommande, PChar(commande + params), @cpsecurity, @cpsecurity, true, NORMAL_PRIORITY_CLASS, nil, pPath, cpinfos, cprocess) then
      begin
        try
          try
            Buffer := AllocMem(ReadBuffer + 1);

            // attente
            while WaitForSingleObject(cprocess.hProcess, ttw) = WAIT_TIMEOUT do
            begin
              // Si supérieur à XP.
              if Win32MajorVersion > 5 then
              begin
                // lecture du buffer au fur et à messure
                BytesRead := 0;
                if ReadFile(ReadPipe, Buffer[0], ReadBuffer, BytesRead, nil) then
                begin
                  if BytesRead > 0 then
                  begin
                    Buffer[BytesRead] := #0;
                    Output := Output + String(Buffer);
                  end;
                end;
              end;

              // attente du process
              if not threaded then
                Application.ProcessMessages;
            end;

            // fermeture du pipe d'écriture
            CloseHandle(WritePipe);

            // Récupération de la fin du buffer au cas où.
            repeat
              BytesRead := 0;
              if ReadFile(ReadPipe, Buffer[0], ReadBuffer, BytesRead, nil) then
              begin
                if BytesRead > 0 then
                begin
                  Buffer[BytesRead] := #0;
                  Output := Output + String(Buffer);
                end;
              end;
            until (BytesRead < ReadBuffer);
          finally
            FreeMem(Buffer);
          end;

          // resultat ??
          if GetExitCodeProcess(cprocess.hProcess, ProcessRet) then
          begin
            Result := ProcessRet;
            Error := 'Retour du process : "' + IntToStr(Result) + '"';
          end
          else
          begin
            Result := GetLastError();
            Error := SysErrorMessage(Result);
          end;
        finally
          CloseHandle(cprocess.hProcess);
          CloseHandle(cprocess.hThread);
        end;
      end
      else
      begin
        Result := GetLastError();
        Error := SysErrorMessage(Result);
        CloseHandle(WritePipe);
      end;
    finally
      CloseHandle(ReadPipe);
    end;
  end
  else
  begin
    Result := GetLastError();
    Error := SysErrorMessage(Result);
  end;
end;

function ExecAndWaitProcessTimeout(out sError: String; sCommande, sParams: String; nTimeout: Integer; bShow: Boolean; sPath: String; bThreaded: Boolean; nTtw: Cardinal): Cardinal;
var
  HandleProcessus: THandle;
  nDebut, nProcessRet, nShellExRet: Cardinal;
begin
  Result := High(Cardinal);
  nDebut := GetTickCount;

  HandleProcessus := ExecProcess(sCommande, sParams, bShow, sPath);
  if HandleProcessus = 0 then
  begin
    nShellExRet := GetLastError;
    sError := 'Code : "' + IntToStr(nShellExRet) + '" - Libelle : "' + SysErrorMessage(nShellExRet) + '"';
  end
  else
  begin
    while WaitForSingleObject(HandleProcessus, nTtw) = WAIT_TIMEOUT do
    begin
      // Si timeout.
      if(GetTickCount - nDebut) > Cardinal(nTimeout * 1000) then
        TerminateProcess(HandleProcessus, High(Cardinal) -1);

      if not bThreaded then
        Application.ProcessMessages;
    end;

    // Résultat ??
    if GetExitCodeProcess(HandleProcessus, nProcessRet) then
      Result := nProcessRet;
    sError := 'Retour du process : "' + IntToStr(Result) + '"';

    // Fermeture.
    CloseHandle(HandleProcessus);
  end;
end;

{ TExecProcessThread }

procedure TExecProcessThread.Execute();
var
  ProcessRet, tmpProcessRet : Cardinal;
  Error : string;
begin
  ProcessRet := High(Cardinal);
  while WaitForSingleObject(FProcess, 100) = WAIT_TIMEOUT do
    Sleep(100);
  // resultat ??
  if GetExitCodeProcess(FProcess, tmpProcessRet) then
  begin
    ProcessRet := tmpProcessRet;
    Error := 'Retour du process : "' + IntToStr(ProcessRet) + '"';
  end
  else
    Error := SysErrorMessage(GetLastError());
  if Assigned(FNotifyFct) then
    FNotifyFct(ProcessRet, Error);
end;

constructor TExecProcessThread.Create(Process : THandle; NotifyFct : TExecREsultEvent; CreateSuspended: Boolean);
begin
  Inherited Create(CreateSuspended);
  FProcess := Process;
  FNotifyFct := NotifyFct;
  FreeOnTerminate := true;
end;

destructor TExecProcessThread.Destroy();
begin
  Inherited Destroy();
end;

end.

