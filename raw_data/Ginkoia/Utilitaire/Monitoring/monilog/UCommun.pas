unit UCommun;

interface

uses
Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, Db, Winsock, Variants,
  ShellAPi,inifiles,registry,Tlhelp32, WinSvc;

type
    TVGSE = packed record
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


function DateTimeToUNIXTimeFAST(DelphiTime : TDateTime): LongWord;
function CreateNewFileName(BaseFileName: String; Ext: String;
  AlwaysUseNumber: Boolean = True): String;
function GetFileSize(const APath: string): int64;
function DataSetToJson(ADataSet:TDataSet):String;
function CaseOfString(s: string; a: array of string): Integer;
function DateTimeToISO(DelphiTime : TDateTime): string;

var VGSE:TVGSE;
    buffer:array[0..255] of Char;

implementation


function CaseOfString(s: string; a: array of string): Integer;
begin
Result := 0;
while (Result < Length(a)) and (a[Result] <> s) do
Inc(Result);
if a[Result] <> s then
Result := -1;
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


function GetFileSize(const APath: string): int64;
var
  Sr : TSearchRec;
begin
  if FindFirst(APath,faAnyFile,Sr)=0 then
  try
    Result := Int64(Sr.FindData.nFileSizeHigh) shl 32 + Sr.FindData.nFileSizeLow;
  finally
    FindClose(Sr);
  end
  else
    Result := 0;
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

function DateTimeToUNIXTimeFAST(DelphiTime : TDateTime): LongWord;
begin
     if DelphiTime<>0
      then Result  := Round((DelphiTime - 25569) * 86400)
      else Result  := 0;
end;

function DateTimeToISO(DelphiTime : TDateTime): string;
begin
     if DelphiTime<>0
      then Result  := FormatDateTime('yyyy-mm-dd hh:nn:ss',DelphiTime)
      else Result  := '0000-00-00 00:00:00';
end;

begin
     FormatSettings.DecimalSeparator  := '.';
     SetCurrentDir(ExtractFileDir(ParamStr(0)));
     VGSE.Exe_Directory := GetCurrentDir+ '\';
end.
