unit U_Util;
{$ALIGN ON}
{$MINENUMSIZE 4}

interface

uses windows, sysutils, TlHelp32;

const
   MAX_PATH = 260;
{ File attribute constants }

   faReadOnly = $00000001;
   faHidden = $00000002;
   faSysFile = $00000004;
   faVolumeID = $00000008;
   faDirectory = $00000010;
   faArchive = $00000020;
   faAnyFile = $0000003F;

type
   BOOL = LongBool;
   DWORD = LongWord;
   _FILETIME = record
      dwLowDateTime: DWORD;
      dwHighDateTime: DWORD;
   end;
   TFileTime = _FILETIME;
   _WIN32_FIND_DATAA = record
      dwFileAttributes: DWORD;
      ftCreationTime: TFileTime;
      ftLastAccessTime: TFileTime;
      ftLastWriteTime: TFileTime;
      nFileSizeHigh: DWORD;
      nFileSizeLow: DWORD;
      dwReserved0: DWORD;
      dwReserved1: DWORD;
      cFileName: array[0..MAX_PATH - 1] of AnsiChar;
      cAlternateFileName: array[0..13] of AnsiChar;
   end;
   TWin32FindDataA = _WIN32_FIND_DATAA;
   TWin32FindData = TWin32FindDataA;
   THandle = LongWord;
   TFileName = type string;
   TSearchRec = record
      Time: Integer;
      Size: Integer;
      Attr: Integer;
      Name: TFileName;
      ExcludeAttr: Integer;
      FindHandle: THandle;
      FindData: TWin32FindData;
   end;

//{$EXTERNALSYM tagPROCESSENTRY32}
//  tagPROCESSENTRY32 = packed record
//    dwSize: DWORD;
//    cntUsage: DWORD;
//    th32ProcessID: DWORD;       // this process
//    th32DefaultHeapID: DWORD;
//    th32ModuleID: DWORD;        // associated exe
//    cntThreads: DWORD;
//    th32ParentProcessID: DWORD; // this process's parent process
//    pcPriClassBase: Longint;    // Base priority of process's threads
//    dwFlags: DWORD;
//    szExeFile: array[0..MAX_PATH - 1] of Char;// Path
//  end;
//{$EXTERNALSYM LPPROCESSENTRY32}
//  LPPROCESSENTRY32 = ^tagPROCESSENTRY32;
//  TProcessEntry32 = tagPROCESSENTRY32;

function FindNext(var F: TSearchRec): Integer;
function FindFirst(const Path: string; Attr: Integer; var F: TSearchRec): Integer;
procedure FindClose(var F: TSearchRec);
function IncludeTrailingBackslash(const S: string): string;
function CopyFile(lpExistingFileName, lpNewFileName: PChar; bFailIfExists: BOOL): BOOL; stdcall;
{$EXTERNALSYM CopyFile}
procedure ForceDirectories(Dir: string);
function GetFileAttributes(lpFileName: PChar): DWORD; stdcall;
{$EXTERNALSYM GetFileAttributes}
function ExecuteAndWait (sExeName : String;Param : String) : Integer;
function LowerCase(const S: string): string;

function KillProcess(const ProcessName : string) : boolean;


implementation
const
   kernel32 = 'kernel32.dll';
   user32 = 'user32.dll';
   INVALID_HANDLE_VALUE = DWORD(-1);
   MAX_DEFAULTCHAR = 2; { single or double byte }
   MAX_LEADBYTES = 12; { 5 ranges, 2 bytes ea., 0 term. }
   LANG_ENGLISH = $09;
   SUBLANG_ENGLISH_US = $01; { English (USA) }
   SM_MIDEASTENABLED = 74;
   SM_DBCSENABLED = 42;
   CP_ACP = 0; { default to ANSI code page }
   FILE_ATTRIBUTE_DIRECTORY = $00000010;

type
   LCID = DWORD;
   LANGID = Word;
   UINT = LongWord;

   LongRec = packed record
      Lo, Hi: Word;
   end;
   TMbcsByteType = (mbSingleByte, mbLeadByte, mbTrailByte);
   TSysLocale = packed record
      DefaultLCID: LCID;
      PriLangID: LANGID;
      SubLangID: LANGID;
      FarEast: Boolean;
      MiddleEast: Boolean;
   end;
   _cpinfo = record
      MaxCharSize: UINT; { max length (bytes) of a char }
      DefaultChar: array[0..MAX_DEFAULTCHAR - 1] of Byte; { default character }
      LeadByte: array[0..MAX_LEADBYTES - 1] of Byte; { lead byte ranges }
   end;
   TCPInfo = _cpinfo;
   PSecurityAttributes = ^TSecurityAttributes;
   _SECURITY_ATTRIBUTES = record
      nLength: DWORD;
      lpSecurityDescriptor: Pointer;
      bInheritHandle: BOOL;
   end;
   TSecurityAttributes = _SECURITY_ATTRIBUTES;

var
   SysLocale: TSysLocale;
   LeadBytes: set of Char = [];

function GetFileAttributes; external kernel32 name 'GetFileAttributesA';
function FindFirstFile(lpFileName: PChar; var lpFindFileData: TWIN32FindData): THandle; stdcall; external kernel32 name 'FindFirstFileA';
function FindCloseSelf(hFindFile: THandle): BOOL; stdcall; external kernel32 name 'FindClose';

function DirectoryExists(const Name: string): Boolean;
var
   Code: Integer;
   Handle: THandle;
   FindData: TWin32FindData;
begin
   Handle := FindFirstFile(PChar(Name), FindData);
   if Handle <> INVALID_HANDLE_VALUE then
   begin
      FindCloseSelf(Handle);
      Code := GetFileAttributes(PChar(Name));
      Result := (Code <> -1) and (FILE_ATTRIBUTE_DIRECTORY and Code <> 0);
   end
   else
      Result := false
end;

function ByteTypeTest(P: PChar; Index: Integer): TMbcsByteType;
var
   I: Integer;
begin
   Result := mbSingleByte;
   if (P = nil) or (P[Index] = #$0) then Exit;
   if (Index = 0) then
   begin
      if P[0] in LeadBytes then Result := mbLeadByte;
   end
   else
   begin
      I := Index - 1;
      while (I >= 0) and (P[I] in LeadBytes) do Dec(I);
      if ((Index - I) mod 2) = 0 then Result := mbTrailByte
      else if P[Index] in LeadBytes then Result := mbLeadByte;
   end;
end;

function ByteType(const S: string; Index: Integer): TMbcsByteType;
begin
   Result := mbSingleByte;
   if SysLocale.FarEast then
      Result := ByteTypeTest(PChar(S), Index - 1);
end;

function StrScan(const Str: PChar; Chr: Char): PChar; assembler;
asm
        PUSH    EDI
        PUSH    EAX
        MOV     EDI,Str
        MOV     ECX,0FFFFFFFFH
        XOR     AL,AL
        REPNE   SCASB
        NOT     ECX
        POP     EDI
        MOV     AL,Chr
        REPNE   SCASB
        MOV     EAX,0
        JNE     @@1
        MOV     EAX,EDI
        DEC     EAX
@@1:    POP     EDI
end;

function LastDelimiter(const Delimiters, S: string): Integer;
var
   P: PChar;
begin
   Result := Length(S);
   P := PChar(Delimiters);
   while Result > 0 do
   begin
      if (S[Result] <> #0) and (StrScan(P, S[Result]) <> nil) then
         if (ByteType(S, Result) = mbTrailByte) then
            Dec(Result)
         else
            Exit;
      Dec(Result);
   end;
end;

function ExtractFilePath(const FileName: string): string;
var
   I: Integer;
begin
   I := LastDelimiter('\:', FileName);
   Result := Copy(FileName, 1, I);
end;

function CreateDirectory(lpPathName: PChar; lpSecurityAttributes: PSecurityAttributes): BOOL; stdcall; external kernel32 name 'CreateDirectoryA';

function CreateDir(const Dir: string): Boolean;
begin
   Result := CreateDirectory(PChar(Dir), nil);
end;

procedure ForceDirectories(Dir: string);
begin
   if Length(Dir) = 0 then Exit;
   if Dir[Length(Dir)] = '\' then
      Delete(Dir, Length(Dir), 1);
   if (Length(Dir) < 3) or DirectoryExists(Dir) or
      (ExtractFilePath(Dir) = Dir) then Exit;
   ForceDirectories(ExtractFilePath(Dir));
   CreateDir(Dir);
end;

function CopyFile; external kernel32 name 'CopyFileA';


function FindNextFile(hFindFile: THandle; var lpFindFileData: TWIN32FindData): BOOL; stdcall; external kernel32 name 'FindNextFileA';

function GetLastError: DWORD; stdcall; external kernel32 name 'GetLastError';

function FileTimeToLocalFileTime(const lpFileTime: TFileTime; var lpLocalFileTime: TFileTime): BOOL; stdcall; external kernel32 name 'FileTimeToLocalFileTime';

function FileTimeToDosDateTime(const lpFileTime: TFileTime; var lpFatDate, lpFatTime: Word): BOOL; stdcall; external kernel32 name 'FileTimeToDosDateTime';


function GetThreadLocale: LCID; stdcall; external kernel32 name 'GetThreadLocale';

function GetSystemMetrics(nIndex: Integer): Integer; stdcall; external user32 name 'GetSystemMetrics';

function GetCPInfo(CodePage: UINT; var lpCPInfo: TCPInfo): BOOL; stdcall; external kernel32 name 'GetCPInfo';


procedure InitSysLocale;
var
   DefaultLCID: LCID;
   DefaultLangID: LANGID;
   AnsiCPInfo: TCPInfo;
   I: Integer;
   J: Byte;
begin
  { Set default to English (US). }
   SysLocale.DefaultLCID := $0409;
   SysLocale.PriLangID := LANG_ENGLISH;
   SysLocale.SubLangID := SUBLANG_ENGLISH_US;

   DefaultLCID := GetThreadLocale;
   if DefaultLCID <> 0 then SysLocale.DefaultLCID := DefaultLCID;

   DefaultLangID := Word(DefaultLCID);
   if DefaultLangID <> 0 then
   begin
      SysLocale.PriLangID := DefaultLangID and $3FF;
      SysLocale.SubLangID := DefaultLangID shr 10;
   end;

   SysLocale.MiddleEast := GetSystemMetrics(SM_MIDEASTENABLED) <> 0;
   SysLocale.FarEast := GetSystemMetrics(SM_DBCSENABLED) <> 0;
   if not SysLocale.FarEast then Exit;

   GetCPInfo(CP_ACP, AnsiCPInfo);
   with AnsiCPInfo do
   begin
      I := 0;
      while (I < MAX_LEADBYTES) and ((LeadByte[I] or LeadByte[I + 1]) <> 0) do
      begin
         for J := LeadByte[I] to LeadByte[I + 1] do
            Include(LeadBytes, Char(J));
         Inc(I, 2);
      end;
   end;
end;

function IsPathDelimiter(const S: string; Index: Integer): Boolean;
begin
   Result := (Index > 0) and (Index <= Length(S)) and (S[Index] = '\')
      and (ByteType(S, Index) = mbSingleByte);
end;

function IncludeTrailingBackslash(const S: string): string;
begin
   Result := S;
   if not IsPathDelimiter(Result, Length(Result)) then Result := Result + '\';
end;


function FindMatchingFile(var F: TSearchRec): Integer;
var
   LocalFileTime: TFileTime;
begin
   with F do
   begin
      while FindData.dwFileAttributes and ExcludeAttr <> 0 do
         if not FindNextFile(FindHandle, FindData) then
         begin
            Result := GetLastError;
            Exit;
         end;
      FileTimeToLocalFileTime(FindData.ftLastWriteTime, LocalFileTime);
      FileTimeToDosDateTime(LocalFileTime, LongRec(Time).Hi,
         LongRec(Time).Lo);
      Size := FindData.nFileSizeLow;
      Attr := FindData.dwFileAttributes;
      Name := FindData.cFileName;
   end;
   Result := 0;
end;

procedure FindClose(var F: TSearchRec);
begin
   if F.FindHandle <> INVALID_HANDLE_VALUE then
   begin
      FindCloseSelf(F.FindHandle);
      F.FindHandle := INVALID_HANDLE_VALUE;
   end;
end;


function FindFirst(const Path: string; Attr: Integer;
   var F: TSearchRec): Integer;
const
   faSpecial = faHidden or faSysFile or faVolumeID or faDirectory;
begin
   F.ExcludeAttr := not Attr and faSpecial;
   F.FindHandle := FindFirstFile(PChar(Path), F.FindData);
   if F.FindHandle <> INVALID_HANDLE_VALUE then
   begin
      Result := FindMatchingFile(F);
      if Result <> 0 then FindClose(F);
   end else
      Result := GetLastError;
end;

function FindNext(var F: TSearchRec): Integer;
begin
   if FindNextFile(F.FindHandle, F.FindData) then
      Result := FindMatchingFile(F) else
      Result := GetLastError;
end;


function ExecuteAndWait (sExeName : String;Param : String) : Integer;
Var  StartInfo   : TStartupInfo;
     ProcessInfo : TProcessInformation;
     Fin         : Boolean;
     ExitCode    : Cardinal;
begin
  Result := -1;
  { Mise à zéro de la structure StartInfo }
  FillChar(StartInfo,SizeOf(StartInfo),#0);
  { Seule la taille est renseignée, toutes les autres options }
  { laissées à zéro prendront les valeurs par défaut }
  StartInfo.cb     := SizeOf(StartInfo);

  { Lancement de la ligne de commande }
  If CreateProcess(PChar(sExeName),PChar(Param) ,nil , Nil, False,
                0, Nil, Nil, StartInfo,ProcessInfo) Then
  Begin
    { L'application est bien lancée, on va en attendre la fin }
    { ProcessInfo.hProcess contient le handle du process principal de l'application }
    Fin:=False;
    Repeat
      { On attend la fin de l'application }
      Case WaitForSingleObject(ProcessInfo.hProcess, 200)Of
        WAIT_OBJECT_0 :Fin:=True; { L'application est terminée, on sort }
        WAIT_TIMEOUT  :;          { elle n'est pas terminée, on continue d'attendre }
      End;
      { Mise à jour de la fenêtre pour que l'application ne paraisse pas bloquée. }
      Sleep(1);
    Until Fin;

    GetExitCodeProcess(ProcessInfo.hProcess,ExitCode);
    Result := ExitCode;
    { C'est fini }
  End
  Else Result := GetLastError; //RaiseLastOSError
end;

function LowerCase(const S: string): string;
asm {Size = 134 Bytes}
  push    ebx
  push    edi
  push    esi
  test    eax, eax               {Test for S = NIL}
  mov     esi, eax               {@S}
  mov     edi, edx               {@Result}
  mov     eax, edx               {@Result}
  jz      @@Null                 {S = NIL}
  mov     edx, [esi-4]           {Length(S)}
  test    edx, edx
  je      @@Null                 {Length(S) = 0}
  mov     ebx, edx
  call    system.@LStrSetLength  {Create Result String}
  mov     edi, [edi]             {@Result}
  mov     eax, [esi+ebx-4]       {Convert the Last 4 Characters of String}
  mov     ecx, eax               {4 Original Bytes}
  or      eax, $80808080         {Set High Bit of each Byte}
  mov     edx, eax               {Comments Below apply to each Byte...}
  sub     eax, $5B5B5B5B         {Set High Bit if Original <= Ord('Z')}
  xor     edx, ecx               {80h if Original < 128 else 00h}
  or      eax, $80808080         {Set High Bit}
  sub     eax, $66666666         {Set High Bit if Original >= Ord('A')}
  and     eax, edx               {80h if Orig in 'A'..'Z' else 00h}
  shr     eax, 2                 {80h > 20h ('a'-'A')}
  add     ecx, eax               {Set Bit 5 if Original in 'A'..'Z'}
  mov     [edi+ebx-4], ecx
  sub     ebx, 1
  and     ebx, -4
  jmp     @@CheckDone
@@Null:
  pop     esi
  pop     edi
  pop     ebx
  jmp     System.@LStrClr
@@Loop:                          {Loop converting 4 Character per Loop}
  mov     eax, [esi+ebx]
  mov     ecx, eax               {4 Original Bytes}
  or      eax, $80808080         {Set High Bit of each Byte}
  mov     edx, eax               {Comments Below apply to each Byte...}
  sub     eax, $5B5B5B5B         {Set High Bit if Original <= Ord('Z')}
  xor     edx, ecx               {80h if Original < 128 else 00h}
  or      eax, $80808080         {Set High Bit}
  sub     eax, $66666666         {Set High Bit if Original >= Ord('A')}
  and     eax, edx               {80h if Orig in 'A'..'Z' else 00h}
  shr     eax, 2                 {80h > 20h ('a'-'A')}
  add     ecx, eax               {Set Bit 5 if Original in 'A'..'Z'}
  mov     [edi+ebx], ecx
@@CheckDone:
  sub     ebx, 4
  jnc     @@Loop
  pop     esi
  pop     edi
  pop     ebx
end;


function KillProcess(const ProcessName : string) : boolean;
var ProcessEntry32 : TProcessEntry32;
    HSnapShot : THandle;
    HProcess : THandle;
begin
  Result := False;

  HSnapShot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if HSnapShot = 0 then exit;

  ProcessEntry32.dwSize := sizeof(ProcessEntry32);
  if Process32First(HSnapShot, ProcessEntry32) then
  repeat
    if CompareText(ProcessEntry32.szExeFile, ProcessName) = 0 then
    begin
      HProcess := OpenProcess(PROCESS_TERMINATE, False, ProcessEntry32.th32ProcessID);
      if HProcess <> 0 then
      begin
        Result := TerminateProcess(HProcess, 0);
        CloseHandle(HProcess);
      end;
      Break;
    end;
  until not Process32Next(HSnapShot, ProcessEntry32);

  CloseHandle(HSnapshot);
end;

initialization
   InitSysLocale;
end.

