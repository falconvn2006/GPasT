unit Uversion;

interface

uses
  Classes; // TStringList

const
  FileInfos : array [1..8] of string = ('FileDescription', 'CompanyName', 'FileVersion', 'InternalName',
                                        'LegalCopyRight', 'OriginalFileName', 'ProductName', 'ProductVersion');

// lecture des information de version d'un fichier
function ReadFileVersion(Fichier : string; Precision : Integer = 4)  : String;
// lecture des information d'un fichier
function ReadFileInfos(fichier : string) : TStringList;
// Lecture des dates d'un fichier
function ReadFileDateCreation(fichier : string) : TDateTime;
function ReadFileDateModification(fichier : string) : TDateTime;
function ReadFileDateDernierAcces(fichier : string) : TDateTime;
function ReadFileInfo(fichier:string;AInfo:string) : string;


implementation

uses
  SysUtils, // Exception
  Dialogs,  // MessageDlg
  Windows;  // DWORD, PVSFixedFileInfo

function ReadFileInfo(fichier:string;AInfo:string) : string;
var Infos:TStringList;
begin
     Infos:=ReadFileInfos(fichier);
     Try
        result:=Infos.Values[AInfo];
     Finally
        Infos.Free;
     End;
end;


function ReadFileVersion(Fichier : string; Precision : Integer)  : String;
var
  VerInfoSize : DWORD;
  VerInfo : Pointer;
  VerValueSize : DWORD;
  VerValue : PVSFixedFileInfo;
  Dummy : DWORD;
begin
  Result := '';
  try
    VerInfoSize := GetFileVersionInfoSize(PChar(Fichier), Dummy);
    GetMem(VerInfo, VerInfoSize);
    try
      if not GetFileVersionInfo(PChar(Fichier), 0, VerInfoSize, VerInfo) then
        RaiseLastOSError();
      if not VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize) then
        RaiseLastOSError();
      with VerValue^ do
      begin
        if Precision > 0 then
          Result := IntToStr(VerValue^.dwFileVersionMS shr 16);
        if Precision > 1 then
          Result := Result + '.' + IntToStr(VerValue^.dwFileVersionMS and $FFFF);
        if Precision > 2 then
          Result := Result + '.' + IntToStr(VerValue^.dwFileVersionLS shr 16);
        if Precision > 3 then
          Result := Result + '.' + IntToStr(VerValue^.dwFileVersionLS and $FFFF);
      end;
    finally
      FreeMem(VerInfo, VerInfoSize);
    end;
  except
    on e : exception do
    begin
      MessageDlg('Erreur : ' + e.Message, mtError, [mbOK], 0);
      Result := '';
    end;
  end;
end;

function ReadFileInfos(fichier : string) : TStringList;
var
  Dummy : DWORD;
  Info : pointer;
  InfoSize : LongInt;
  LangPtr : pointer;
  InfoData : pointer;
  InfoDataSize : UInt;
  InfoType : string;
  i : integer;
begin
  Result := TStringList.Create();
  try
    InfoSize := GetFileVersionInfoSize(PChar(Fichier), Dummy);
    GetMem(Info, InfoSize);
    try
      if not GetFileVersionInfo(PChar(Fichier), Dummy, InfoSize, Info) then
        RaiseLastOSError();
      for i := 1 to 8 do
      begin
        InfoType := FileInfos[i];
        if VerQueryValue(Info, '\VarFileInfo\Translation', LangPtr, InfoDataSize) then
          Infotype := Format('\StringFileInfo\%0.4x%0.4x\%s'#0, [LoWord(LongInt(LangPtr^)), HiWord(LongInt(LangPtr^)), InfoType]);
        if not VerQueryValue(Info, @InfoType[1], InfoData, InfoDataSize) then
          RaiseLastOSError();
        Result.Add(FileInfos[i] + '=' + StrPas(PChar(InfoData)));
      end;

    finally
      FreeMem(Info, InfoSize);
    end;
  except
    on e : exception do
    begin
      MessageDlg('Erreur : ' + e.Message, mtError, [mbOK], 0);
      Result.Clear();
    end;
  end;
//  InfoSize := GetFileVersionInfoSize(PChar(Fichier), Dummy);
//  if InfoSize > 0 then
//  begin
//    GetMem(Info, InfoSize);
//    try
//      if GetFileVersionInfo(PChar(Fichier), Dummy, InfoSize, Info) then
//      begin
//        for i := 1 to 8 do
//        begin
//          InfoType := VersionInfo[i];
//          if VerQueryValue(Info, '\VarFileInfo\Translation', LangPtr, InfoDataSize) then
//            Infotype := Format('\StringFileInfo\%0.4x%0.4x\%s'#0, [LoWord(LongInt(LangPtr^)), HiWord(LongInt(LangPtr^)), InfoType]);
//          if VerQueryValue(Info, @InfoType[1], InfoData, InfoDataSize) then
//            Result.Add(VersionInfo[i] + '=' + StrPas(InfoData));
//        end;
//      end;
//    finally
//      FreeMem(Info, InfoSize);
//    end;
//  end;
end;

function ReadFileDateCreation(fichier : string) : TDateTime;
var
  handle : THandle;
  DateC, DateA, DateM : TFileTime;
  SysTimeStruct : SYSTEMTIME;
  TimeZoneInfo : TTimeZoneInformation;
  Bias : Double;
begin
  Result := 0;
  Bias := 0;

  Handle := FileOpen(fichier, fmOpenRead or fmShareDenyNone);
  if handle > 0 then
  begin
    try
      if GetTimeZoneInformation(TimeZoneInfo) <> $FFFFFFFF then
        Bias := TimeZoneInfo.Bias / 1440; // 60*24
      GetFileTime(handle, @DateC, @DateA, @DateM);
      if FileTimeToSystemTime(DateC, SysTimeStruct) then
        Result := SystemTimeToDateTime(SysTimeStruct) - Bias;
    finally
      FileClose(Handle);
    end;
  end;
end;

function ReadFileDateModification(fichier : string) : TDateTime;
var
  handle : THandle;
  DateC, DateA, DateM : TFileTime;
  SysTimeStruct : SYSTEMTIME;
  TimeZoneInfo : TTimeZoneInformation;
  Bias : Double;
begin
  Result := 0;
  Bias := 0;

  Handle := FileOpen(fichier, fmOpenRead or fmShareDenyNone);
  if handle > 0 then
  begin
    try
      if GetTimeZoneInformation(TimeZoneInfo) <> $FFFFFFFF then
        Bias := TimeZoneInfo.Bias / 1440; // 60*24
      GetFileTime(handle, @DateC, @DateA, @DateM);
      if FileTimeToSystemTime(DateM, SysTimeStruct) then
        Result := SystemTimeToDateTime(SysTimeStruct) - Bias;
    finally
      FileClose(Handle);
    end;
  end;
end;

function ReadFileDateDernierAcces(fichier : string) : TDateTime;
var
  handle : THandle;
  DateC, DateA, DateM : TFileTime;
  SysTimeStruct : SYSTEMTIME;
  TimeZoneInfo : TTimeZoneInformation;
  Bias : Double;
begin
  Result := 0;
  Bias := 0;

  Handle := FileOpen(fichier, fmOpenRead or fmShareDenyNone);
  if handle > 0 then
  begin
    try
      if GetTimeZoneInformation(TimeZoneInfo) <> $FFFFFFFF then
        Bias := TimeZoneInfo.Bias / 1440; // 60*24
      GetFileTime(handle, @DateC, @DateA, @DateM);
      if FileTimeToSystemTime(DateA, SysTimeStruct) then
        Result := SystemTimeToDateTime(SysTimeStruct) - Bias;
    finally
      FileClose(Handle);
    end;
  end;
end;

end.

