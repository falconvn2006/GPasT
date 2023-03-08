unit UCommun;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, Db, DBTables, Winsock, Variants,
  ShellAPi,inifiles,registry;

Const PosV11_X=0;
      PosV12_X=1;
      PosV13_X=2;
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

function GetTmpDir:string;
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


var VAR_GLOB:TGlobals;
    buffer:array[0..255] of Char;

implementation

Uses UdxTranslate;


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
     if astring='11.X' then result:=PosV11_X;
     if astring='12.X' then result:=PosV12_X;
     if astring='13.X' then result:=PosV13_X;
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
                             {$IFDEF VER220}
                             VerQueryValue(VerInfo, PChar('\\StringFileInfo\\040C04E4\\InternalName'),Pointer(VerValue), VerValueSize);
                             Result:=StrPas(PWideChar(VerValue));
                             {$ENDIF}
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

begin
     GetCurrentDirectory(255,buffer);
     VAR_GLOB.DEBUG:=false;
     VAR_GLOB.Exe_Directory:=string(buffer) + '\';
     VAR_GLOB.PathReg:='SOFTWARE\GINKOIA\GCTRLB\';
     Chargement_Langue;
end.
