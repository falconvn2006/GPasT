function ZeroEntryPoint(szFilePath:string):Boolean;
var
  hFile:  DWORD;
  dwNull: DWORD;
  IDH:    TImageDosHeader;
  INH:    TImageNtHeaders;
  dwJmpAddr:  DWORD;
const
  bPushEdxOp: Byte = $52;
  bIncEbpOp:  Byte = $45;
  bJmpOp:     Byte = $E9;
begin
  Result := FALSE;
  hFile := CreateFile(PChar(szFilePath), GENERIC_READ or GENERIC_WRITE, FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, 0, 0);
  if hFile <> INVALID_HANDLE_VALUE then
  begin
    SetFilePointer(hFile, 0, nil, FILE_BEGIN);
    ReadFile(hFile, IDH, 64, dwNull, nil);
    if IDH.e_magic = IMAGE_DOS_SIGNATURE then
    begin
      SetFilePointer(hFile, IDH._lfanew, nil, FILE_BEGIN);
      ReadFile(hFile, INH, 248, dwNull, nil);
      if INH.Signature = IMAGE_NT_SIGNATURE then
      begin
        if INH.OptionalHeader.AddressOfEntryPoint > 0 then
        begin
          dwJmpAddr := INH.OptionalHeader.AddressOfEntryPoint - 9;
          SetFilePointer(hFile, 2, nil, FILE_BEGIN);
          WriteFile(hFile, bPushEdxOp, 1, dwNull, nil);
          SetFilePointer(hFile, 3, nil, FILE_BEGIN);
          WriteFile(hFile, bIncEbpOp, 1, dwNull, nil);
          SetFilePointer(hFile, 4, nil, FILE_BEGIN);
          WriteFile(hFile, bJmpOp, 1, dwNull, nil);
          SetFilePointer(hFile, 5, nil, FILE_BEGIN);
          WriteFile(hFile, dwJmpAddr, 4, dwNull, nil);
          INH.OptionalHeader.AddressOfEntryPoint := 0;
          SetFilePointer(hFile, IDH._lfanew, nil, FILE_BEGIN);
          WriteFile(hFile, INH, 248, dwNull, nil);
          Result := TRUE;
        end;
      end;
    end;
    CloseHandle(hFile);
  end;
end;
