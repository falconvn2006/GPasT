unit UCommun;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Dialogs, StdCtrls, magwmi, magsubs1, Registry,
  Winapi.ShellAPI;

Const ClassComPort = '{4D36E978-E325-11CE-BFC1-08002BE10318}';

type TOSInfos = packed record
      WinVersion     : string;
      ServicePack    : string;
      OSArchitecture : string;
      BuildNumber    : string;
      end;
     TVGSE = packed record
       OSInfos : TOSInfos;
       ExePath : string;
     end;

function Auto_Detect_TPE(Const AModel:string='SAGEM MONETEL'):string; // reponse COM1,COM2 ou COM3 etc..
function Get_Serial_Ports:TStringList;
function SecondsIdle: DWord;
function GetOsInfos:TOSInfos;
function Get_USB_VID_PIL(Const AModel:string=''):string;
function GetDosOutput(CommandLine: string; Work: string = 'C:\'): string;
function TestPresenceTPE_WMI_HKLM(aPortCom:string;AutoDetect:Boolean;SearchName:string):Boolean;
function TestPresence_Com_HKLM_DEVICEMAP(aPortCom:string):boolean;

Var VGSE: TVGSE; // Variable Glabale du Soft et de l'Environnnement

implementation

function TestPresence_Com_HKLM_DEVICEMAP(aPortCom:string):boolean;
var Reg         : TRegistry;
    Values      : TStringList;
    ComStr : string;
    i           : Integer;
begin
  result:=false;
  try
    Reg := TRegistry.Create;
    try
      Reg.RootKey := HKEY_LOCAL_MACHINE;
      if Reg.OpenKeyReadOnly('HARDWARE\DEVICEMAP\SERIALCOMM\') then
      begin
        try
          Values := TStringList.Create;
          try
            Reg.GetValueNames(Values);
            for i := 0 to Pred(Values.Count) do
            begin
              if Reg.GetDataType(Values[i]) = rdString then
              begin
                ComStr := Reg.ReadString(Values[i]);
                if UpperCase(aPortCom)=UpperCase(ComStr) then
                  result:=true;
              end;
            end;
          finally
            Values.Free;
          end;
        finally
          Reg.CloseKey;
        end;
      end;
    finally
      Reg.Free;
    end;
  except
    on EAssertionFailed do raise;
  end;
end;


function TestPresenceTPE_WMI_HKLM(aPortCom:string;AutoDetect:Boolean;SearchName:string):Boolean;
var aCOM:string;
begin
     if AutoDetect then
       begin
         aCOM:=Auto_Detect_TPE(SearchName);
       end
     else
       begin
         aCom:=aPortCom;
       end;
     result:=TestPresence_Com_HKLM_DEVICEMAP(aPortCom);
end;


function GetDosOutput(CommandLine: string; Work: string = 'C:\'): string;
var
  SA: TSecurityAttributes;
  SI: TStartupInfo;
  PI: TProcessInformation;
  StdOutPipeRead, StdOutPipeWrite: THandle;
  WasOK: Boolean;
  Buffer: array[0..255] of AnsiChar;
  BytesRead: Cardinal;
  WorkDir: string;
  Handle: Boolean;
begin
  Result := '';
  with SA do begin
    nLength := SizeOf(SA);
    bInheritHandle := True;
    lpSecurityDescriptor := nil;
  end;
  CreatePipe(StdOutPipeRead, StdOutPipeWrite, @SA, 0);
  try
    with SI do
    begin
      FillChar(SI, SizeOf(SI), 0);
      cb := SizeOf(SI);
      dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
      wShowWindow := SW_HIDE;
      hStdInput := GetStdHandle(STD_INPUT_HANDLE); // don't redirect stdin
      hStdOutput := StdOutPipeWrite;
      hStdError := StdOutPipeWrite;
    end;
    WorkDir := Work;
    Handle := CreateProcess(nil, PChar('cmd.exe /C ' + CommandLine),
                            nil, nil, True, 0, nil,
                            PChar(WorkDir), SI, PI);
    CloseHandle(StdOutPipeWrite);
    if Handle then
      try
        repeat
          WasOK := ReadFile(StdOutPipeRead, Buffer, 255, BytesRead, nil);
          if BytesRead > 0 then
          begin
            Buffer[BytesRead] := #0;
            Result := Result + Buffer;
          end;
        until not WasOK or (BytesRead = 0);
        WaitForSingleObject(PI.hProcess, INFINITE);
      finally
        CloseHandle(PI.hThread);
        CloseHandle(PI.hProcess);
      end;
  finally
    CloseHandle(StdOutPipeRead);
  end;
end;


function Get_USB_VID_PIL(Const AModel:string=''):string;
var Reg: TRegistry;
    SubKeyNames: TStringList;
    i:integer;
    stemp:string;
begin
   Result := '';
   if (AModel='') then
     begin
          exit;
     end;
   Reg := TRegistry.Create(KEY_READ);
   try
      Reg.RootKey := HKEY_LOCAL_MACHINE;
      Reg.OpenKeyReadOnly('\SYSTEM\CurrentControlSet\Control\Class\'+ClassComPort);
      SubKeyNames := TStringList.Create;
      try
        Reg.GetKeyNames(SubKeyNames);
        Reg.CloseKey;
        for i:=0 to SubKeyNames.Count-1 do
          begin
            if (SubKeyNames.Strings[i]<>'Properties')  then
              begin
                   Reg.OpenKeyReadOnly('\SYSTEM\CurrentControlSet\Control\Class\'+ClassComPort+'\'+SubKeyNames.Strings[i]);
                   stemp:=Reg.ReadString('DriverDesc');
                   // MessageDlg(stemp, mtWarning, [mbOK], 0);
                   If (AnsiPos(Amodel,stemp)>=1) then
                      begin
                           // MessageDlg('MatchingDeviceId', mtWarning, [mbOK], 0);
                           result:=Reg.ReadString('MatchingDeviceId');
                           // MessageDlg(result, mtWarning, [mbOK], 0);
                      end;
              end;
            if result<>'' then exit;
          end;
        Finally
          SubKeyNames.Free;
          Reg.CloseKey;
      end;
   finally
     Reg.Free;
   end;
end;


function GetOsInfos:TOSInfos;
var rows, instances, I, J: integer;
    WmiResults: T2DimStrArray;
    errstr:string;
begin
    result.WinVersion:='?';
    result.ServicePack:='?';
    result.OSArchitecture:='?';
    result.BuildNumber:='?';
    try
       rows := MagWmiGetInfoEx ('.', 'root\CIMV2', '','',
                  'SELECT BuildNumber, Caption, CSDVersion, OSArchitecture FROM Win32_OperatingSystem', WmiResults, instances, errstr) ;
        if rows > 0 then
        begin
             result.BuildNumber := WmiResults[1, 1];
             result.WinVersion  := WmiResults[1, 2 ];
             result.ServicePack := WmiResults[1, 3 ];
             result.OSArchitecture := WmiResults[1, 4 ];
        end;
    finally
        // Screen.Cursor := OldCursor ;
        WmiResults := Nil ;
    end ;
end;

function SecondsIdle: DWord;
var
   liInfo: TLastInputInfo;
begin
   liInfo.cbSize := SizeOf(TLastInputInfo) ;
   GetLastInputInfo(liInfo) ;
   Result := (GetTickCount - liInfo.dwTime) DIV 1000;
end;

function Auto_Detect_TPE(Const AModel:string='SAGEM MONETEL'):string;
var rows, instances, I, J: integer;
    WmiResults: T2DimStrArray;
    errstr:string;
begin
    result := '';
    try
       rows := MagWmiGetInfoEx ('.', 'root\CIMV2', '','',
                  'SELECT Caption, DeviceID FROM Win32_SerialPort WHERE Caption LIKE "%'+Amodel+'%"', WmiResults, instances, errstr) ;
        if rows > 0 then
        begin
             // result:= StrToIntDef(StringReplace(WmiResults[1, 2],'COM','',[rfReplaceAll, rfIgnoreCase]),0);
             result := WmiResults[1, 2];
        end;
    finally
        // Screen.Cursor := OldCursor ;
        WmiResults := Nil ;
    end ;
end;

function Get_Serial_Ports:TStringList;
var rows, instances, I, J: integer;
    WmiResults: T2DimStrArray;
    errstr:string;
begin
    result := TStringList.Create;
    try
       rows := MagWmiGetInfoEx ('.', 'root\CIMV2', '','',
                  'SELECT Caption, DeviceID FROM Win32_SerialPort'  {WHERE DeviceID LIKE "%COM%" 'Win32_SerialPort'}, WmiResults, instances, errstr) ;
        if rows > 0 then
        begin
            for J := 1 to instances do
                 begin
                      result.Add(WmiResults [J, 1]);
                 end;
        end;
    finally
        WmiResults := Nil ;
    end ;
end;

begin
     VGSE.OSInfos:=GetOsInfos;
     VGSE.ExePath:=ExtractFilePath(ParamStr(0));
end.
