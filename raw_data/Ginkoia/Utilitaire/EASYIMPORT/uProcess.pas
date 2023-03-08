unit uProcess;

interface

uses
  Types;

type
  TExecResultEvent = procedure(Resultat: Cardinal; Error: string) of object;

// base
function ExecProcess(commande, params: string; Show: boolean = false; path: string = ''): THandle; overload;

function ExecProcess(commande, params: string; ReadPipe, WritePipe: THandle; Show: boolean = false; path: string = ''): THandle; overload;

procedure NotifyEndOfProcess(Process: THandle; NotifyFct: TExecREsultEvent);
{$IF CompilerVersion>18.5}
//function WaitProcess(ProcessID : DWORD; threaded : boolean = false; ttw : Cardinal = 100) : Cardinal; overload;
{$IFEND}

function WaitProcess(Process: THandle; threaded: boolean = false; ttw: Cardinal = 100): Cardinal; overload;
// combiné

function ExecProcessAndNotify(commande, params: string; NotifyFct: TExecResultEvent; Show: boolean = false; path: string = ''): THandle;

function ExecAndWaitProcess(out Error: string; commande, params: string; Show: boolean = false; path: string = ''; threaded: boolean = false; ttw: Cardinal = 100): Cardinal; overload;
// autres

function ExecAndWaitProcess(out Error, Output: string; commande, params: string; Show: boolean = false; path: string = ''; threaded: boolean = false; ttw: Cardinal = 100): Cardinal; overload;

function ExecAndWaitProcessTimeout(out sError: string; sCommande, sParams: string; nTimeout: Integer; bShow: Boolean = False; sPath: string = ''; bThreaded: Boolean = False; nTtw: Cardinal = 100): Cardinal;
// avec shellExecuteEx, paramètre timeout optionnel

function ShellExecuteAndWait(sCommande: string; sParams: string = ''; nTimeout: Integer = 0): Integer;


procedure KillProcessus(ExeAKill: string);
function ExecuterProcess(cmdLine: string; timeout: integer; Const OkMontrer: boolean = true): boolean;

implementation

uses
  Classes, ShellAPI, SysUtils, Windows, Forms, Tlhelp32, DateUtils;

type
  TExecProcessThread = class(TThread)
  private
    FProcess: THandle;
    FNotifyFct: TExecREsultEvent;
  protected
    procedure Execute(); override;
  public
    constructor Create(Process: THandle; NotifyFct: TExecREsultEvent; CreateSuspended: Boolean = false); reintroduce;
    destructor Destroy(); override;
  end;

// Utilitaire

function ExtractQuotedFilePath(const FileName: string): string;
begin
  if FileName[1] = '"' then
    Result := ExtractFilePath(Copy(FileName, 2, Length(FileName) - 2))
  else
    Result := ExtractFilePath(FileName);
end;

// fonctions de base

function ExecProcess(commande, params: string; Show: boolean; path: string): THandle;
var
  seinfos: SHELLEXECUTEINFO;
begin
  Result := 0;
  // valeur des paramètre
  if Trim(path) = '' then
    path := ExtractQuotedFilePath(commande);
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

function ExecProcess(commande, params: string; ReadPipe, WritePipe: THandle; Show: boolean; path: string): THandle;
var
  cpsecurity: TSecurityAttributes;
  cpinfos: TStartUpInfo;
  cprocess: TProcessInformation;
  pCommande, pPath: PChar;
begin
  Result := 0;
  // valeur des paramètre
  if (Trim(path) = '') then
    path := ExtractQuotedFilePath(commande);
  if (Length(params) > 0) and not (params[1] = ' ') then
    params := ' ' + params;
  // valeurs
  if Trim(commande) = '' then
    pCommande := nil
  else
    pCommande := PChar(commande);
  if Trim(path) = '' then
    pPath := nil
  else
    pPath := PChar(path);
  // structure de securité
  ZeroMemory(@cpsecurity, SizeOf(TSecurityAttributes));
  cpsecurity.nlength := SizeOf(TSecurityAttributes);
  cpsecurity.lpsecuritydescriptor := nil;
  cpsecurity.binherithandle := true;
  // structure de demarage
  ZeroMemory(@cpinfos, SizeOf(TStartUpInfo));
  cpinfos.cb := SizeOf(TStartUpInfo);
  cpinfos.dwFlags := STARTF_USESTDHANDLES + STARTF_USESHOWWINDOW;
  if Show then
    cpinfos.wShowWindow := SW_SHOW
  else
    cpinfos.wShowWindow := SW_HIDE;
  if not (ReadPipe = 0) then
    cpinfos.hStdInput := ReadPipe;
  if not (WritePipe = 0) then
    cpinfos.hStdOutput := WritePipe;
  // lancement !
  if CreateProcess(pCommande, PChar(commande + params), nil, nil, false, NORMAL_PRIORITY_CLASS, nil, pPath, cpinfos, cprocess) then
  begin
    CloseHandle(cprocess.hThread);
    Result := cprocess.hProcess;
  end;
end;

procedure NotifyEndOfProcess(Process: THandle; NotifyFct: TExecREsultEvent);
begin
  TExecProcessThread.Create(Process, NotifyFct);
end;

{$IF CompilerVersion>18.5}
//function WaitProcess(ProcessID : DWORD; threaded : boolean; ttw : Cardinal) : Cardinal;
//var
//  tmpProcess : THandle;
//begin
//  tmpProcess := OpenProcess(SYNCHRONIZE or PROCESS_QUERY_INFORMATION, true, ProcessID);
//  Result := WaitProcess(tmpProcess, threaded, ttw);
//end;
{$IFEND}

function WaitProcess(Process: THandle; threaded: boolean; ttw: Cardinal): Cardinal;
var
  WaitRes: DWORD;
  ProcessRet: Cardinal;
begin
  Result := High(Cardinal);
  WaitRes := WaitForSingleObject(Process, ttw);
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

// execution complète

function ExecProcessAndNotify(commande, params: string; NotifyFct: TExecResultEvent; Show: boolean; path: string): THandle;
begin
  Result := ExecProcess(commande, params, Show, path);
  TExecProcessThread.Create(Result, NotifyFct);
end;

function ExecAndWaitProcess(out Error: string; commande, params: string; Show: boolean; path: string; threaded: boolean; ttw: Cardinal): Cardinal;
var
  tmpHandle: THandle;
  ShellExRet: Cardinal;
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

function ExecAndWaitProcess(out Error, Output: string; commande, params: string; Show: boolean; path: string; threaded: boolean; ttw: Cardinal): Cardinal;
const
  ReadBuffer = 4096;
var
  ReadPipe, WritePipe: THandle;
  cpsecurity: TSecurityAttributes;
  cpinfos: TStartUpInfo;
  cprocess: TProcessInformation;
  pCommande, pPath: PChar;
  ProcessRet: Cardinal;
  Buffer: PAnsiChar;
  BytesRead: DWord;
  dAvailable: DWORD;
begin
  Buffer := nil;
  Error := '';
  Output := '';
  // valeur des paramètre
  if (Trim(path) = '') then
    path := ExtractQuotedFilePath(commande);
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
                PeekNamedPipe(ReadPipe, nil, 0, nil, @dAvailable, nil);
                if dAvailable > 0 then
                begin
                  repeat
                    if ReadFile(ReadPipe, Buffer[0], ReadBuffer, BytesRead, nil) then
                    begin
                      if BytesRead > 0 then
                      begin
                        Buffer[BytesRead] := #0;
                        Output := Output + string(Buffer);
                      end;
                    end;
                  until BytesRead < ReadBuffer;
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
                  Output := Output + string(Buffer);
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

function ExecAndWaitProcessTimeout(out sError: string; sCommande, sParams: string; nTimeout: Integer; bShow: Boolean; sPath: string; bThreaded: Boolean; nTtw: Cardinal): Cardinal;
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
      if (GetTickCount - nDebut) > Cardinal(nTimeout * 1000) then
        TerminateProcess(HandleProcessus, High(Cardinal) - 1);

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

function ShellExecuteAndWait(sCommande: string; sParams: string; nTimeout: Integer): Integer;
var
  SEInfo: TShellExecuteInfo;
  ExitCode: DWORD;
  //nDebut := Cardinal;
  nDebut: TDateTime;
  elapsed: Integer;
begin
  try
    nDebut := Now;

    FillChar(SEInfo, SizeOf(SEInfo), 0);
    SEInfo.cbSize := SizeOf(TShellExecuteInfo);

    //SEInfo.fMask := SEE_MASK_NOCLOSEPROCESS;
    SEInfo.fMask := SEE_MASK_FLAG_NO_UI or SEE_MASK_NOCLOSEPROCESS;
    SEInfo.Wnd := Application.Handle;
    SEInfo.lpFile := PChar(sCommande);
    SEInfo.lpVerb := 'open';

    if sParams <> '' then
      SEInfo.lpParameters := PChar(sParams);

    SEInfo.nShow := SW_SHOWNORMAL;

    if ShellExecuteEx(@SEInfo) then
    begin
      repeat
        Sleep(50);
        elapsed := SecondsBetween(Now, nDebut);
        Application.ProcessMessages;

        // si on depasse le temps maximum alors on tue le process
        if (elapsed > nTimeout) and (nTimeout > 0) then
          TerminateProcess(SEInfo.hProcess, STATUS_TIMEOUT);

        GetExitCodeProcess(SEInfo.hProcess, ExitCode);
      until (ExitCode <> STILL_ACTIVE) or (Application.Terminated) or (SEInfo.hInstApp <= 32);

      if SEInfo.hInstApp <= 32 then
        result := GetLastError()
      else
        Result := ExitCode;
    end
    else
    begin
      Result := GetLastError();
    end;

  except
    Result := GetLastError();
  end;
end;

{ TExecProcessThread }

procedure TExecProcessThread.Execute();
var
  ProcessRet, tmpProcessRet: Cardinal;
  Error: string;
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

constructor TExecProcessThread.Create(Process: THandle; NotifyFct: TExecREsultEvent; CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);
  FProcess := Process;
  FNotifyFct := NotifyFct;
  FreeOnTerminate := true;
end;

destructor TExecProcessThread.Destroy();
begin
  inherited Destroy();
end;

procedure KillProcessus(ExeAKill: string);
var
  ProcessEntry32: TProcessEntry32;
  HSnapShot: THandle;
  HProcess: THandle;
  bOk: boolean;
  s: string;
begin
  HSnapShot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if HSnapShot = 0 then
    exit;
  ProcessEntry32.dwSize := sizeof(ProcessEntry32);
  bOk := Process32First(HSnapShot, ProcessEntry32);
  while bOk do
  begin
    s := string(ProcessEntry32.szExeFile);
    if UpperCase(s) = UpperCase(ExeAKill) then
    begin
      HProcess := OpenProcess(PROCESS_TERMINATE, False, ProcessEntry32.th32ProcessID);
      if HProcess <> 0 then
      begin
        TerminateProcess(HProcess, 0);
        CloseHandle(HProcess);
      end;
      Break;
    end;
    bOk := Process32Next(HSnapShot, ProcessEntry32);
  end;
  CloseHandle(HSnapShot);
end;



function ExecuterProcess(cmdLine: string; timeout: integer; Const OkMontrer: boolean = true): boolean;
var
  StartInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
begin
  Result := false;
  //fonction qui crée un process cmdline et attends sa fin ou celle du timeout pour rend la main et signaler le résultat
  //renvoi true si fini ok ou false si fini car timeout
  //timeout -1 signifie que l'on n'attends pas la fin de l'execution du process, mais seulement la fin de sa création
      { Mise à zéro de la structure StartInfo }
  FillChar(StartInfo, SizeOf(StartInfo), #0);
  { Seule la taille est renseignée, toutes les autres options }
  { laissées à zéro prendront les valeurs par défaut }
  StartInfo.cb := SizeOf(StartInfo);
  if not(OkMontrer) then
    StartInfo.wShowWindow := SW_HIDE;

  // on touche pas au Cursor dans une telle fonction !!!
  // Screen.Cursor := crHourGlass;
  //
  { Lancement de la ligne de commande }
  IF CreateProcess(NIL, Pchar(cmdLine), NIL, NIL, False,
    0, NIL, NIL, StartInfo, ProcessInfo) THEN
  BEGIN
    Result := true;
    { L'application est bien lancée, on va en attendre la fin }
    { ProcessInfo.hProcess contient le handle du process principal de l'application }
    IF timeout <> 0 THEN
    BEGIN
      Result := false;
      //Application.ProcessMessages;
      CASE WaitForSingleObject(ProcessInfo.hProcess, timeout) OF
        WAIT_OBJECT_0: Result := True;
        WAIT_TIMEOUT: ;
      END;
    END;
  END;
END;


end.

