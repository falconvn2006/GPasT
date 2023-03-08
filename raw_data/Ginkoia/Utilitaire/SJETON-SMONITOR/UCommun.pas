unit UCommun;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, Db, Winsock, Variants,
  ShellAPi,inifiles,registry,Tlhelp32, WinSvc;

Const PosV11_X=1;
      PosV12_X=2;
      PosV13_X=3;
      MAX_JSONLENGTH=100;
      MAX_WDPOSTEXE=20;

      //--------------------------
      script        = 'ws.php';
      script_hr     = 'ws_hr.php';
      script_hr0    = 'ws_hr0.php';
      path_script   = 'http://127.0.0.1/';

      ws_monitor_script     = 'ws_monitor.php';
      ws_monitor_log_script = 'ws_monitor_log.php';
      ws_ginkoia_bases      = 'ws_ginkoia_bases.php';
      ws_ginkoia_magasins   = 'ws_ginkoia_magasins.php';
      ws_ginkoia_version    = 'ws_ginkoia_version.php';
      ws_ginkoia_module     = 'ws_ginkoia_module.php';
      ws_ordre              = 'ws_ordre.php';
      VMonitior_procedure   = 'VMONITOR_LAST_REPLIC(30)';


  Type
     TGlobals = packed record
      Exe_Directory:string;
      PathReg:string;
      Temp:String;  // Variable globale Temporaire a utiliser pour les va-et vient
      DEBUG:Boolean;
      Directory:string;
      LogFile:string;
      ErrFile:string;
      DebugFile:string;
      IP:string;
      UserName:string;
      ComputerName:string;
      WindowsVersion:string;
     end;


function LancementWDPOST:boolean;
function GetTmpDir:string;
function CreateUniqueGUIDFileName(sPath, sPrefix, sExtension : string) : string;
function GetInfo(Const Ressource:String): String;
function CompareVersion(left, right: string): Integer;
function SplitString(src: string; delim: string; var dest1: string;
		var dest2: string): Boolean;
// Load & Save en Base de registre
function LoadFromRegInt(Const AKey :string;Const DefautValue:Integer):integer;
function LoadFromRegFloat(Const AKey :string;Const DefautValue:double):double;
function LoadFromRegBool(Const AKey :string;Const DefautValue:boolean):boolean;
function LoadFromRegStr(Const AKey :string;Const DefautValue:String):string;
procedure SaveToRegInt(AKey :string;AValue : Integer);
procedure SaveToRegFloat(AKey :string;AValue : double);
procedure SaveToRegStr(AKey :string;AValue : string);
procedure SaveToRegBool(AKey :string;AValue : boolean);
procedure WriteOnDebugFile(Astr:string);
function DateTimeToUNIXTimeFAST(DelphiTime : TDateTime): LongWord;
function GetIntegerGinkoiaVX(astring:string):integer;
procedure FixDBGridColumnsWidth(const DBGrid: TDBGrid);
function SaveStrToFile(AfileName:string;astring:string):boolean;
function Controle_PASSWORD(Const ASession: string;Const APASSWORD:string):boolean;
// procedure KillProcess(hWindowHandle: HWND);
// function ServiceGetStatus(sMachine,sService : string ) : DWord;
// function ServiceRunning(sMachine,sService : string ) : boolean;
// function GetServiceRunning(sService : string ) : boolean;
function DataSetToJson(ADataSet:TDataSet):String;
function WDPost(adossier:string;ajson:string;Aauto:string;AFullUrl:string;APSK:string):Boolean;
procedure CustomFileCopy(const ASourceFileName, ADestinationFileName: TFileName);
function CreateLongFileName(const ALongFileName: String; SharingMode: DWORD): THandle; overload;
function OpenLongFileName(const ALongFileName: String; SharingMode: DWORD): THandle; overload;

var VAR_GLOB:TGlobals;
    buffer:array[0..255] of Char;
    nbWDPOSTexe:Integer;

implementation

Uses GestionLog;

function OpenLongFileName(const ALongFileName: String; SharingMode: DWORD): THandle; overload;
begin
  if CompareMem(@(ALongFileName[1]), @('\\'[1]), 2) then
    { Allready an UNC path }
    Result := CreateFileW(PWideChar(WideString(ALongFileName)), GENERIC_READ, SharingMode, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0)
  else
    Result := CreateFileW(PWideChar(WideString('\\?\' + ALongFileName)), GENERIC_READ, SharingMode, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
end;

function CreateLongFileName(const ALongFileName: String; SharingMode: DWORD): THandle; overload;
begin
  if CompareMem(@(ALongFileName[1]), @('\\'[1]), 2) then
    { Allready an UNC path }
    Result := CreateFileW(PWideChar(WideString(ALongFileName)), GENERIC_WRITE, SharingMode, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0)
  else
    Result := CreateFileW(PWideChar(WideString('\\?\' + ALongFileName)), GENERIC_WRITE, SharingMode, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
end;

procedure CustomFileCopy(const ASourceFileName, ADestinationFileName: TFileName);
const
  BufferSize = 1024; // 1KB blocks, change this to tune your speed
var
  Buffer : array of Byte;
  ASourceFile, ADestinationFile: THandle;
  FileSize: DWORD;
  BytesRead, BytesWritten, BytesWritten2: DWORD;
begin
  SetLength(Buffer, BufferSize);
  ASourceFile := OpenLongFileName(ASourceFileName, 0);
  if ASourceFile <> 0 then
  try
    FileSize := FileSeek(ASourceFile, 0, FILE_END);
    FileSeek(ASourceFile, 0, FILE_BEGIN);
    ADestinationFile :=  CreateLongFileName(ADestinationFileName, FILE_SHARE_READ);
    if ADestinationFile <> 0 then
    try
      while (FileSize - FileSeek(ASourceFile, 0, FILE_CURRENT)) >= BufferSize do
      begin
        if (not ReadFile(ASourceFile, Buffer[0], BufferSize, BytesRead, nil)) and (BytesRead = 0) then
         Continue;
        WriteFile(ADestinationFile, Buffer[0], BytesRead, BytesWritten, nil);
        if BytesWritten < BytesRead then
        begin
          WriteFile(ADestinationFile, Buffer[BytesWritten], BytesRead - BytesWritten, BytesWritten2, nil);
          if (BytesWritten2 + BytesWritten) < BytesRead then
            RaiseLastOSError;
        end;
      end;
      if FileSeek(ASourceFile, 0, FILE_CURRENT)  < FileSize then
      begin
        if (not ReadFile(ASourceFile, Buffer[0], FileSize - FileSeek(ASourceFile, 0, FILE_CURRENT), BytesRead, nil)) and (BytesRead = 0) then
         ReadFile(ASourceFile, Buffer[0], FileSize - FileSeek(ASourceFile, 0, FILE_CURRENT), BytesRead, nil);
        WriteFile(ADestinationFile, Buffer[0], BytesRead, BytesWritten, nil);
        if BytesWritten < BytesRead then
        begin
          WriteFile(ADestinationFile, Buffer[BytesWritten], BytesRead - BytesWritten, BytesWritten2, nil);
          if (BytesWritten2 + BytesWritten) < BytesRead then
            RaiseLastOSError;
        end;
      end;
    finally
      CloseHandle(ADestinationFile);
    end;
  finally
    CloseHandle(ASourceFile);
  end;
end;


function WDPost(adossier:string;ajson:string;Aauto:string;AFullUrl:string;APSK:string):Boolean;
var sNewFileName:string;
    Parametres:string;
begin
// problème avec les " si pas dans un fichier
//    if (length(ajson)>MAX_JSONLENGTH) then
//        begin
           sNewFileName := CreateUniqueGUIDFileName(GetTmpDir,'ws_','.tmp');
           SaveStrToFile(sNewFileName,Format('"d":"%s","j":[%s]',[adossier,ajson]));
           Parametres:=Format('%s-url=%s -psk=%s -file="%s"',[
             Aauto,
             AFullUrl,
             Apsk,
             sNewFileName]);
//        end
//    else
//       begin
//            Parametres:=Format('%s-url=%s -psk=%s -json="d":"%s","j":[%s]',[
//             Aauto,
//             AFullUrl,
//             Apsk,
//             adossier,
//             ajson]);
//       end;
    Log_Write('WDPOST.exe ' + Parametres, el_Debug);
    ShellExecute(0,'Open',PChar('WDPOST.exe'),PChar(Parametres),Nil,SW_SHOWDEFAULT);
    result:=true;
end;

function DataSetToJson(ADataSet:TDataSet):String;
var i:integer;
    DField:string;
    DRecord:string;
    tmp:string;
begin;
      DField:='';
      DRecord:='';
      result:='';
      ADataSet.Open;
      while not(ADataSet.Eof) do
          begin
               DField:='';
               tmp:='';
               for i := 0 to ADataSet.FieldCount-1 do
                  begin
                       tmp:= tmp + Format('%s"%s":"%s"',[DField,ADataSet.Fields[i].FieldName,ADataSet.Fields[i].asstring]);
                       DField:=',';
                  end;
               result := result + Format('%s{%s}',[DRecord,tmp]);
               DRecord:=',';
               ADataSet.Next;
          end;
      ADataSet.Close;
end;


function EnumProcess(hHwnd: HWND; lParam : integer): boolean; stdcall;
var
  pPid : DWORD;
  title, ClassName : string;
begin
  if (hHwnd=NULL) then
  begin
    result := false;
  end
  else
  begin
    GetWindowThreadProcessId(hHwnd,pPid);
    SetLength(ClassName, 255);
    SetLength(ClassName,
              GetClassName(hHwnd,
                           PChar(className),
                           Length(className)));
    SetLength(title, 255);
    SetLength(title, GetWindowText(hHwnd, PChar(title), Length(title)));
    if (UpperCase(title)='WDPOST') AND (UpperCase(className)='TAPPLICATION')
      then nbWDPOSTexe:=nbWDPOSTexe+1;
    Result := true;
  end;
end;


function LancementWDPOST:boolean;
begin
     nbWDPOSTexe:=0;
     result:=false;
     if EnumWindows(@EnumProcess,0) = false then exit;
     if (nbWDPOSTexe < MAX_WDPOSTEXE)
       then result:=true
       else result:=false;
end;

function Controle_PASSWORD(Const ASession: string;Const APASSWORD:string):boolean;
begin
     result:= StrToInt(FormatDateTime('d',Now())) + StrToInt(FormatDateTime('m',Now())) + StrToInt(ASession) = StrToInt(APASSWORD);
end;

function CreateUniqueGUIDFileName(sPath, sPrefix, sExtension : string) : string;
   var sFileName : string;
        Guid : TGUID;
begin
  Result := '';
  repeat
   SFileName := '';
   CreateGUID(Guid);
   SFileName := sPath + sPrefix + GUIDtoString(GUID);
   Result := ChangeFileExt(sFileName, sExtension)
  until not FileExists(Result);
end;

function SaveStrToFile(AfileName:string;astring:string):boolean;
var MyText : TStringlist;
    fs     : TFileStream;
begin
  MyText := TStringlist.create;
  fs     := TFileStream.Create(AfileName,fmCreate);
  try
    try
      MyText.Text:=astring;
      MyText.SaveToStream(fs, TEncoding.ANSI);
      fs.Size := fs.Size - Length(System.sLineBreak);
      result:=true;
    Except
      result:=false;
    end;
  finally
    MyText.Free;
    fs.Free;
  end;
end;



procedure FixDBGridColumnsWidth(const DBGrid: TDBGrid);
var
  i : integer;
  TotWidth : integer;
  VarWidth : integer;
  ResizableColumnCount : integer;
  AColumn : TColumn;
begin
  //total width of all columns before resize
  TotWidth := 0;
  //how to divide any extra space in the grid
  VarWidth := 0;
  //how many columns need to be auto-resized
  ResizableColumnCount := 0;

  for i := 0 to -1 + DBGrid.Columns.Count do
  begin
    TotWidth := TotWidth + DBGrid.Columns[i].Width;
    if DBGrid.Columns[i].Field.Tag <> 0 then
      Inc(ResizableColumnCount);
  end;

  //add 1px for the column separator line
  if dgColLines in DBGrid.Options then
    TotWidth := TotWidth + DBGrid.Columns.Count;

  //add indicator column width
  if dgIndicator in DBGrid.Options then
    TotWidth := TotWidth + IndicatorWidth;

  //width vale "left"
  VarWidth :=  DBGrid.ClientWidth - TotWidth;

  //Equally distribute VarWidth
  //to all auto-resizable columns
  if ResizableColumnCount > 0 then
    VarWidth := varWidth div ResizableColumnCount;

  for i := 0 to -1 + DBGrid.Columns.Count do
  begin
    AColumn := DBGrid.Columns[i];
    if AColumn.Field.Tag <> 0 then
    begin
      AColumn.Width := AColumn.Width + VarWidth;
      if AColumn.Width < AColumn.Field.Tag then
        AColumn.Width := AColumn.Field.Tag;
    end;
  end;
end;


function GetIntegerGinkoiaVX(astring:string):integer;
begin
     result:=0;
     if astring='11' then result:=PosV11_X;
     if astring='12' then result:=PosV12_X;
     if astring='13' then result:=PosV13_X;
end;

function DateTimeToUNIXTimeFAST(DelphiTime : TDateTime): LongWord;
begin
     if DelphiTime<>0
      then Result  := Round((DelphiTime - 25569) * 86400)
      else Result  := 0;
end;


function FileSize(const aFilename: String): Int64;
var info: TWin32FileAttributeData;
begin
    result := -1;

    if NOT GetFileAttributesEx(PWideChar(aFileName), GetFileExInfoStandard, @info) then
      EXIT;

    result := info.nFileSizeLow or (info.nFileSizeHigh shl 32);
end;

function GetInfo(Const Ressource:String): String;
//     ReadFileInfo(Application.ExeName,Ressource);
var VerInfoSize: DWord;
    VerInfo: Pointer;
    VerValueSize: DWord;
    VerValue: PVSFixedFileInfo;
    Dummy: DWord;
begin
     result:='';
     VerInfoSize := GetFileVersionInfoSize(PChar(ParamStr(0)), Dummy);
     if VerInfoSize <> 0
        then
            begin
                 GetMem(VerInfo, VerInfoSize);
                 GetFileVersionInfo(PChar(ParamStr(0)), 0, VerInfoSize, VerInfo);
                 if Ressource='Version'
                    then
                        begin
                             VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
                             with VerValue^ do
                                  begin
                                       result := IntTostr(dwFileVersionMS shr 16);
                                       result := result+'.'+ IntTostr(dwFileVersionMS and $FFFF);
                                       result := result+'.'+ IntTostr(dwFileVersionLS shr 16);
                                       result := result+'.'+ IntTostr(dwFileVersionLS and $FFFF);
                                  end;
                        end;
                 if Ressource='LegalCopyright'
                    then
                        begin
                             {$IFDEF VER150}
                             VerQueryValue(VerInfo, PChar('\\StringFileInfo\\040C04E4\\LegalCopyright'),Pointer(VerValue), VerValueSize);
                             Result:=StrPas(Pointer(VerValue));
                             {$ENDIF}
                             {$IFDEF VER210}
                             VerQueryValue(VerInfo, PChar('\\StringFileInfo\\040C04E4\\LegalCopyright'),Pointer(VerValue), VerValueSize);
                             Result:=StrPas(PWideChar(VerValue));
                             {$ENDIF}
                        end;
                 if Ressource='InternalName'
                    then
                        begin
                             {$IFDEF VER150}
                             VerQueryValue(VerInfo, PChar('\\StringFileInfo\\040C04E4\\InternalName'),Pointer(VerValue), VerValueSize);
                             Result:=StrPas(Pointer(VerValue));
                             {$ENDIF}
                             {$IF CompilerVersion>=22}
                             VerQueryValue(VerInfo, PChar('\StringFileInfo\040C04E4\InternalName'),Pointer(VerValue), VerValueSize);
                             Result:=StrPas(PWideChar(VerValue));
                             {$IFEND}
                        end;
                 //   then
                 //       begin
                 //            VerQueryValue(VerInfo, PChar('\\StringFileInfo\\040C04E4\\LegalCopyright'),Pointer(VerValue), VerValueSize);
                 //            Result:=StrPas(Pointer(VerValue));
                 //       end;
                 FreeMem(VerInfo, VerInfoSize);
            end
        else result:='';
end;

procedure WriteOnDebugFile(Astr:string);
var F: TextFile;
begin
     Assign(F,Var_Glob.DebugFile);
     try
        Append(F);
        except
        ReWrite(F);
     end;
     try
        Write(F, FormatDateTime('c', Now));
        Writeln(F, ' > ' + Astr);
        Flush(F);
     finally
        CloseFile(F);
     end;
end;

function CreateNewFileName(BaseFileName: String; Ext: String;
  AlwaysUseNumber: Boolean = True): String;
var
  DocIndex: Integer;
  FileName: String;
  FileNameFound: Boolean;
begin
  DocIndex := 1;
  Filenamefound := False;
  {if number not required and basefilename doesn't exist, use that.}
  if not(AlwaysUseNumber) and (not(fileexists(BaseFilename + ext))) then
  begin
    Filename := BaseFilename + ext;
    FilenameFound := true;
  end;
  while not (FileNameFound) do
  begin
    filename := BaseFilename + inttostr(DocIndex) + Ext;
    if fileexists(filename) then
      inc(DocIndex)
    else
      FileNameFound := true;
  end;
  Result := filename;
end;


function GetTmpDir:string;
var Path : Array[0..MAX_PATH] Of Char ;
begin
     // Récupération du répertoire temporaire (éventuellement, celui de l'application).
     If (GetTempPath(MAX_PATH,@Path)=0) Then
        StrCopy(@Path,PChar(ExtractFileDir(Application.ExeName)));
     result:=Path;
end;

function SplitString(src: string; delim: string; var dest1: string;
		var dest2: string): Boolean;
var min, c, j: integer;
begin
	min := 0;
	for c := 1 to length(delim) do begin
		j := Pos(delim[c], src);
		if ((j < min) or (min = 0)) and (j > 0) then min := j;
	end;

	if min > 0 then begin
		dest1 := Copy(src, 1, min - 1);
		dest2 := Copy(src, min + 1, Length(src));
		SplitString := true;
	end else begin
		dest1 := src;
		dest2 := '';
		SplitString := false;
	end;
end;

function CompareVersion(left, right: string): Integer;
var leftpart, rightpart : string;
	lpos, rpos : integer;
begin
	result := CompareText(left, right);

	while (left <> '') and (right <> '') do begin
		SplitString(left, '.', leftpart, left);
		SplitString(right, '.', rightpart, right);
		// Justify the numbers
		lpos := LastDelimiter('0123456789*', leftpart);
		rpos := LastDelimiter('0123456789*', rightpart);
		while (lpos > rpos) do begin
			rightpart := ' ' + rightpart;
			inc(rpos);
		end;
		while (rpos > lpos) do begin
			leftpart := ' ' + leftpart;
			inc(lpos);
		end;
		if (leftpart = '*') or (rightpart = '*') then break;
		result := CompareText(leftpart, rightpart);

		if (result <> 0) then break;
	end;
end;

function LoadFromRegInt(Const AKey :string;Const DefautValue:Integer):integer;
var Reg: TRegistry;
    tmp:integer;
begin
     tmp:=DefautValue;
     Reg := TRegistry.Create;
     Reg.RootKey := HKEY_CURRENT_USER;
     if Reg.OpenKey(VAR_GLOB.PathReg, false)
        then
            begin
                 If Reg.ValueExists(AKey)
                    then tmp:=Reg.ReadInteger(AKey);
            end;
     Reg.CloseKey;
     Reg.Free;
     result:=tmp;
end;


//------------------------------------------------------------------------------

function LoadFromRegStr(Const AKey :string;Const DefautValue:String):string;
var Reg: TRegistry;
    tmp:string;
begin
     tmp:=DefautValue;
     Reg := TRegistry.Create;
     Reg.RootKey := HKEY_CURRENT_USER;
     if Reg.OpenKey(VAR_GLOB.PathReg, false)
        then
            begin
                 If Reg.ValueExists(AKey)
                    then tmp:=Reg.ReadString(AKey);
            end;
     Reg.CloseKey;
     Reg.Free;
     result:=tmp;
end;


function LoadFromRegFloat(Const AKey :string;Const DefautValue:double):double;
var Reg: TRegistry;
    tmp:double;
begin
     tmp:=DefautValue;
     Reg := TRegistry.Create;
     Reg.RootKey := HKEY_CURRENT_USER;
     if Reg.OpenKey(VAR_GLOB.PathReg, false)
        then
            begin
                 If Reg.ValueExists(AKey)
                    then tmp:=Reg.ReadFloat(AKey);
            end;
     Reg.CloseKey;
     Reg.Free;
     result:=tmp;
end;
function LoadFromRegBool(Const AKey :string;Const DefautValue:boolean):boolean;
var Reg: TRegistry;
    tmp:boolean;
begin
     tmp:=DefautValue;
     Reg := TRegistry.Create;
     Reg.RootKey := HKEY_CURRENT_USER;
     if Reg.OpenKey(VAR_GLOB.PathReg, false)
        then
            begin
                 If Reg.ValueExists(AKey)
                    then tmp:=Reg.ReadBool(AKey);
            end;
     Reg.CloseKey;
     Reg.Free;
     result:=tmp;
end;

//------------------------------------------------------------------------------

procedure SaveToRegFloat(AKey :string;AValue : double);
var Reg: TRegistry;
begin
     Reg := TRegistry.Create;
     try
        Reg.RootKey := HKEY_CURRENT_USER;
        if Reg.OpenKey(VAR_GLOB.PathReg, True)
           then Reg.WriteFloat(AKey,AValue);
        finally
        Reg.CloseKey;
        Reg.Free;
     end;
end;

procedure SaveToRegInt(AKey :string;AValue : Integer);
var Reg: TRegistry;
begin
     Reg := TRegistry.Create;
     try
        Reg.RootKey := HKEY_CURRENT_USER;
        if Reg.OpenKey(VAR_GLOB.PathReg, True)
           then Reg.WriteInteger(AKey,AValue);
        finally
        Reg.CloseKey;
        Reg.Free;
     end;
end;

//------------------------------------------------------------------------------

procedure SaveToRegBool(AKey :string;AValue : boolean);
var Reg: TRegistry;
begin
     Reg := TRegistry.Create;
     try
        Reg.RootKey := HKEY_CURRENT_USER;
        if Reg.OpenKey(VAR_GLOB.PathReg, True)
           then Reg.WriteBool(AKey,AValue);
        finally
        Reg.CloseKey;
        Reg.Free;
     end;
end;


//------------------------------------------------------------------------------

function ComputerName: string;
var
  lpBuffer: array[0..MAX_COMPUTERNAME_LENGTH] of char;
  nSize: dword;
begin
  nSize:= Length(lpBuffer);
  if GetComputerName(lpBuffer, nSize) then
    result:= lpBuffer
  else
    result:= '';
end;

//------------------------------------------------------------------------------

function UserName:string;
var Utilisateur:Array[0..255] Of Char;
    Taille:Cardinal;
begin
     Taille := SizeOf(Utilisateur);
     If GetUserName(@Utilisateur,Taille)
        then Result := strpas(Utilisateur)
        else Result := '';
end;

//------------------------------------------------------------------------------

procedure SaveToRegStr(AKey :string;AValue : string);
var Reg: TRegistry;
begin
     Reg := TRegistry.Create;
     try
        Reg.RootKey := HKEY_CURRENT_USER;
        if Reg.OpenKey(VAR_GLOB.PathReg, True)
           then Reg.WriteString(AKey,AValue);
        finally
        Reg.CloseKey;
        Reg.Free;
     end;
end;
(*
procedure KillProcess(hWindowHandle: HWND);
var hprocessID: INTEGER;
    processHandle: THandle;
    DWResult: DWORD;
begin
  SendMessageTimeout(hWindowHandle, WM_CLOSE, 0, 0,
  SMTO_ABORTIFHUNG or SMTO_NORMAL, 5000, DWResult);
  if isWindow(hWindowHandle) then
  begin
    // PostMessage(hWindowHandle, WM_QUIT, 0, 0);
    GetWindowThreadProcessID(hWindowHandle, @hprocessID);
    if hprocessID <> 0 then
      begin
      { Get the process handle }
      processHandle := OpenProcess(PROCESS_TERMINATE or PROCESS_QUERY_INFORMATION, False, hprocessID);
      if processHandle <> 0 then
        begin
        { Terminate the process }
        TerminateProcess(processHandle, 0);
        CloseHandle(ProcessHandle);
        end;
      end;
  end;
end;
*)

begin
     FormatSettings.DecimalSeparator  := '.';
     SetCurrentDir(ExtractFileDir(ParamStr(0)));
     VAR_GLOB.Exe_Directory := GetCurrentDir+ '\';
     VAR_GLOB.PathReg:=Format('SOFTWARE\GINKOIA\%s\',['monitor']);
end.
