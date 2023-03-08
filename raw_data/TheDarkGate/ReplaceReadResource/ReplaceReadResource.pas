program Test;
uses Windows, SysUtils;

{$R resource.Res} // resource.rc = EXE FILE "Hello.exe" //

type
  { Resource Dir String }
  PImageResourceDirString = ^TImageResourceDirString;
  TImageResourceDirString = packed record
    Length: Word;
    NameString: array[0..0] of WCHAR;
  end;
  { Data Entry }
  PImageResourceDataEntry = ^TImageResourceDataEntry;
  TImageResourceDataEntry = packed record
    OffsetToData: DWORD;
    Size: DWORD;
    CodePage: DWORD;
    Reserved: DWORD;
  end;
  { Dir Entry }
  PImageResourceDirectoryEntry = ^TImageResourceDirectoryEntry;
  TImageResourceDirectoryEntry = packed record
    Name: DWORD;
    OffsetToData: DWORD;
  end;
  { Directory }
  PImageResourceDirectory = ^TImageResourceDirectory;
  TImageResourceDirectory = packed record
    Characteristics: DWORD;
    TimeDateStamp: DWORD;
    MajorVersion: Word;
    MinorVersion: Word;
    NumberOfNamedEntries: Word;
    NumberOfIdEntries: Word;
  end;

const
  IMAGE_RESOURCE_DATA_IS_DIRECTORY: DWORD = $80000000;
  IMAGE_STRIP_HIGH_BIT:             DWORD = $7FFFFFFF;

function StripHighBit(dwValue:DWORD):DWORD;
begin
  Result := dwValue and IMAGE_STRIP_HIGH_BIT;
end;

function IsDirectory(dwValue:DWORD):Boolean;
begin
  Result := FALSE;
  if ((dwValue and IMAGE_RESOURCE_DATA_IS_DIRECTORY) <> 0) then
    Result := TRUE;
end;

function WideCharToMultiByteEx(var lp: PWideChar): string; // function from ErazerZ's UntPeFile
var
  len: Word;
begin
  len := Word(lp^);
  SetLength(Result, len);
  Inc(lp);
  WideCharToMultiByte(CP_ACP, 0, lp, Len, PChar(Result), Len +1, nil, nil);
  Inc(lp, len);
  Result := PChar(Result);
end;

function GetResource(szResourceType:string; szResourceName:string; var pResource:Pointer; var dwResourceSize:DWORD):Boolean;
var
  IDH:              PImageDosHeader;
  INH:              PImageNtHeaders;
  i:                DWORD;
  RootIRD:          PImageResourceDirectory;
  SubIRD:           PImageResourceDirectory;
  DataIRD:          PImageResourceDirectory;
  RootEntry:        PImageResourceDirectoryEntry;
  SubEntry:         PImageResourceDirectoryEntry;
  DataEntry:        PImageResourceDirectoryEntry;
  ResData:          PImageResourceDataEntry;
  ResType:          PImageResourceDirString;
  ResName:          PImageResourceDirString;
  hModule:          DWORD;
  szResType:        string;
  szResName:        string;
begin
  Result := FALSE;
  hModule := GetModuleHandle(nil);
  if (hModule <> 0) then
  begin
    IDH := Pointer(hModule);
    if (IDH^.e_magic = IMAGE_DOS_SIGNATURE) then
    begin
      INH := Pointer(hModule + IDH^._lfanew);
      if (INH^.Signature = IMAGE_NT_SIGNATURE) then
      begin
        if (INH^.OptionalHeader.DataDirectory[2].VirtualAddress > 0) then
        begin
          RootIRD := Pointer(hModule + INH^.OptionalHeader.DataDirectory[2].VirtualAddress);
          RootEntry := Pointer(DWORD(RootIRD) + SizeOf(TImageResourceDirectory));
          for i := 0 to (RootIRD^.NumberOfNamedEntries + RootIRD^.NumberOfIdEntries) - 1 do
          begin
            if (IsDirectory(RootEntry^.Name)) then
            begin
              ResType := Pointer(hModule + INH^.OptionalHeader.DataDirectory[2].VirtualAddress + StripHighBit(RootEntry^.Name));
              szResType := WideCharToMultiByteEx(PWideChar(DWORD(ResType)));
              if (szResType = szResourceType) then
              begin
                SubIRD := Pointer(DWORD(RootIRD) + StripHighBit(RootEntry^.OffsetToData));
                SubEntry := Pointer(DWORD(SubIRD) + SizeOf(TImageResourceDirectory));
                if (IsDirectory(SubEntry^.Name)) then
                begin
                  ResName := Pointer(DWORD(RootIRD) + StripHighBit(SubEntry^.Name));
                  szResName := WideCharToMultiByteEx(PWideChar(DWORD(ResName)));
                  if (szResName = szResourceName) then
                  begin
                    Result := TRUE;
                    DataIRD := Pointer(DWORD(RootIRD) + StripHighBit(SubEntry^.OffsetToData));
                    DataEntry := Pointer(DWORD(DataIRD) + SizeOf(TImageResourceDirectory));
                    ResData := Pointer(DWORD(RootIRD) + DataEntry^.OffsetToData);
                    pResource := Pointer(hModule + ResData^.OffsetToData);
                    dwResourceSize := ResData^.Size;
                    Exit;
                  end;
                end;
              end;
            end;                                
            Inc(RootEntry);
          end;
        end;
      end;                       
    end;
  end;
end;

var
  pRes:   Pointer;
  dwSize: DWORD;
  szMsg:  string;
begin
  if (GetResource('FILE', 'EXE', pRes, dwSize)) then
  begin
    szMsg := 'Address: ' + IntToHex(DWORD(pRes), 8) + #13#10 +
    'Size: ' + IntToHex(dwSize, 8) + #13#10 +
    'First byte: ' + IntToHex(PByte(pRes)^, 0);
    MessageBoxA(0, PChar(szMsg), 'RESOURCES', 0);
  end;
end.
