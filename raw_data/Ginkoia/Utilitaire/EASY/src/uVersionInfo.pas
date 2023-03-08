unit uVersionInfo;

interface

uses
  System.Classes, // TStringList
  System.Types;   // TValueRelationship
  
const
  FileInfos : array [1..8] of string = ('FileDescription', 'CompanyName', 'FileVersion', 'InternalName',
                                        'LegalCopyRight', 'OriginalFileName', 'ProductName', 'ProductVersion');

type
  TInfoSurExe = record
    FileDescription,
    CompanyName,
    FileVersion,
    InternalName,
    LegalCopyright,
    OriginalFileName,
    ProductName,
    ProductVersion: String;
  end;

// lecture des information de version d'un fichier
function ReadFileVersion(Fichier : string = ''; Precision : Integer = 4) : String;
// lecture des information d'un fichier
function ReadFileInfos(fichier : string = '') : TStringList;
function ReadFileInfosStruct(Fichier : string = '') : TInfoSurExe;
// Lecture de partie des infos du fichier
function ReadOriginalFileName(fichier : string) : string;
// Lecture des dates d'un fichier
function ReadFileDateCreation(fichier : string = '') : TDateTime;
function ReadFileDateModification(fichier : string = '') : TDateTime;
function ReadFileDateDernierAcces(fichier : string = '') : TDateTime;

// comparaison de version
function CompareVersion(A, B : string) : TValueRelationship;

implementation

uses
  System.SysUtils, // Exception
  System.StrUtils, // CompareStr
  System.UITypes,  // MessageDlg (etendu)
  System.Math,     // CompareValue
  Vcl.Dialogs,     // MessageDlg
  Winapi.Windows;  // DWORD, PVSFixedFileInfo

// version...

function ReadFileVersion(Fichier : string; Precision : Integer)  : String;
var
  Dummy : DWORD;
  Info : Pointer;
  InfoSize : Cardinal;
  VerValue : PVSFixedFileInfo;
  InfoDataSize : Cardinal;
begin
  Result := '';

  if Trim(Fichier) = '' then
    Fichier := ParamStr(0);
  if FileExists(Fichier) then
  begin
    try
      InfoSize := GetFileVersionInfoSize(PChar(Fichier), Dummy);
      GetMem(Info, InfoSize);
      try
        if not GetFileVersionInfo(PChar(Fichier), Dummy, InfoSize, Info) then
          RaiseLastOSError();
        if not VerQueryValue(Info, '\', Pointer(VerValue), InfoDataSize) then
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
        FreeMem(Info, InfoSize);
      end;
    except
      on e : exception do
      begin
        MessageDlg('Erreur : ' + e.Message, mtError, [mbOK], 0);
        Result := '';
      end;
    end;
  end;
end;

// informations...

function ReadFileInfos(fichier : string) : TStringList;
var
  Dummy : DWORD;
  Info : pointer;
  InfoSize : Cardinal;
  LangPtr : pointer;
  InfoData : pointer;
  InfoDataSize : Cardinal;
  InfoType : string;
  i : integer;
begin
  Result := TStringList.Create();

  if Trim(Fichier) = '' then
    Fichier := ParamStr(0);
  if FileExists(Fichier) then
  begin
    try
      InfoSize := GetFileVersionInfoSize(PChar(Fichier), Dummy);
      GetMem(Info, InfoSize);
      try
        if not GetFileVersionInfo(PChar(Fichier), Dummy, InfoSize, Info) then
          RaiseLastOSError();
        for i := Low(FileInfos) to High(FileInfos) do
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
  end;
end;

function ReadFileInfosStruct(fichier : string) : TInfoSurExe;
var
  Dummy : DWORD;
  Info : pointer;
  InfoSize : Cardinal;
  LangPtr : pointer;
  InfoData : pointer;
  InfoDataSize : Cardinal;
  InfoType : string;
  i : integer;
begin
  Result.FileDescription := '';
  Result.CompanyName := '';
  Result.FileVersion := '';
  Result.InternalName := '';
  Result.LegalCopyright := '';
  Result.OriginalFileName := '';
  Result.ProductName := '';
  Result.ProductVersion := '';

  if Trim(Fichier) = '' then
    Fichier := ParamStr(0);
  if FileExists(Fichier) then
  begin
    try
      InfoSize := GetFileVersionInfoSize(PChar(Fichier), Dummy);
      GetMem(Info, InfoSize);
      try
        if not GetFileVersionInfo(PChar(Fichier), Dummy, InfoSize, Info) then
          RaiseLastOSError();
        for i := Low(FileInfos) to High(FileInfos) do
        begin
          InfoType := FileInfos[i];
          if VerQueryValue(Info, '\VarFileInfo\Translation', LangPtr, InfoDataSize) then
            Infotype := Format('\StringFileInfo\%0.4x%0.4x\%s'#0, [LoWord(LongInt(LangPtr^)), HiWord(LongInt(LangPtr^)), InfoType]);
          if not VerQueryValue(Info, @InfoType[1], InfoData, InfoDataSize) then
            RaiseLastOSError();
          case i of
            1 : Result.FileDescription := StrPas(PChar(InfoData));
            2 : Result.CompanyName := StrPas(PChar(InfoData));
            3 : Result.FileVersion := StrPas(PChar(InfoData));
            4 : Result.InternalName := StrPas(PChar(InfoData));
            5 : Result.LegalCopyright := StrPas(PChar(InfoData));
            6 : Result.OriginalFileName := StrPas(PChar(InfoData));
            7 : Result.ProductName := StrPas(PChar(InfoData));
            8 : Result.ProductVersion := StrPas(PChar(InfoData));
          end;
        end;
      finally
        FreeMem(Info, InfoSize);
      end;
    except
      on e : exception do
      begin
        MessageDlg('Erreur : ' + e.Message, mtError, [mbOK], 0);
      end;
    end;
  end;
end;

// partie d'info !

function ReadOriginalFileName(fichier : string) : string;
var
  InfoExe : TInfoSurExe;
begin
  InfoExe := ReadFileInfosStruct();
  Result := InfoExe.OriginalFileName;
end;

// dates !

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

  if Trim(Fichier) = '' then
    Fichier := ParamStr(0);
  if FileExists(Fichier) then
  begin
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

  if Trim(Fichier) = '' then
    Fichier := ParamStr(0);
  if FileExists(Fichier) then
  begin
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

  if Trim(Fichier) = '' then
    Fichier := ParamStr(0);
  if FileExists(Fichier) then
  begin
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
end;

function CompareVersion(A, B : string) : TValueRelationship;
var
  ListValA, ListValB : TStringList;
  ValA, ValB, i, nb : integer;
begin
  Result := EqualsValue;
  try
    While (Length(A) > 0) and not CharInSet(A[1], ['0'..'9'])  do
      Delete(A, 1, 1);
    While (Length(B) > 0) and not CharInSet(B[1], ['0'..'9']) do
      Delete(B, 1, 1);

    ListValA := TStringList.Create();
    ListValA.Delimiter := '.';
    ListValA.DelimitedText := Trim(A);
    ListValB := TStringList.Create();
    ListValB.Delimiter := '.';
    ListValB.DelimitedText := Trim(B);

    nb := Max(ListValA.Count, ListValB.Count);
    while ListValA.Count < nb do
      ListValA.Add('0');
    while ListValB.Count < nb do
      ListValB.Add('0');

    for i := 0 to nb -1 do
    begin
      if TryStrToInt(ListValA[i], ValA) and TryStrToInt(ListValB[i], ValB) then
        Result := CompareValue(ValA, ValB)
      else
        Result := CompareStr(ListValA[i], ListValB[i]);
      if not (Result = EqualsValue) then
        Exit;
    end;
  finally
    FreeAndNil(ListValA);
    FreeAndNil(ListValB);
  end;
end;

end.
