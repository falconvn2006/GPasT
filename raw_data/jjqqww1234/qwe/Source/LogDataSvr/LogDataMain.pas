unit LogDataMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IniFiles, ExtCtrls, IdBaseComponent, IdComponent, IdUDPBase,
  IdUDPServer, IdSocketHandle;

const
  LogBaseDir: string = 'D:\';

type
  TFrmLogData = class(TForm)
    Label3:  TLabel;
    Label4:  TLabel;
    Timer1:  TTimer;
    IdUDPServer: TIdUDPServer;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure IdUDPServerUDPRead(Sender: TObject; AData: TStream;
      ABinding: TIdSocketHandle);
  private
    LogList: TStringList;
  public
    procedure WriteLogs;
  end;

var
  FrmLogData: TFrmLogData;

implementation

{$R *.DFM}


procedure TFrmLogData.FormCreate(Sender: TObject);
var
  ini: TIniFile;
begin
  LogList := TStringList.Create;

  ini := TIniFile.Create('.\logdata.ini');
  if ini <> nil then begin
    LogBaseDir := ini.ReadString('setup', 'basedir', LogBaseDir);
    FrmLogData.Caption := FrmLogData.Caption + ' (' +
      ini.ReadString('setup', 'caption', '') + ')';

    IdUDPServer.DefaultPort := ini.ReadInteger('setup', 'port', 10000);
    IdUDPServer.Active := True;
    ini.Free;
  end;
end;

procedure TFrmLogData.FormDestroy(Sender: TObject);
begin
  LogList.Free;
end;

procedure TFrmLogData.IdUDPServerUDPRead(Sender: TObject; AData: TStream;
  ABinding: TIdSocketHandle);
var
  DataLen: Integer;
  TmpStr: String;
begin
  DataLen := AData.Size;
  if DataLen > 0 then begin
    SetLength(TmpStr, DataLen);
    AData.Read(TmpStr[1], DataLen);
    //Memo1.Lines.Add(FromIP+': '+TmpStr);
    LogList.Add(TmpStr);
  end;
end;

procedure TFrmLogData.WriteLogs;

  function IntTo_Str(val: integer): string;
  begin
    if val < 10 then
      Result := '0' + IntToStr(val)
    else
      Result := IntToStr(val);
  end;

var
  ayear, amon, aday, ahour, amin, asec, amsec: word;
  dirname, flname, fmtdatetime: string;
  f: TextFile;
  i: integer;
begin
  if LogList.Count = 0 then
    exit;

  DecodeDate(Date, ayear, amon, aday);
  DecodeTime(Time, ahour, amin, asec, amsec);
  dirname := LogBaseDir + IntToStr(ayear) + '-' + IntTo_Str(amon) +
    '-' + IntTo_Str(aday);
  if not DirectoryExists(dirname) then begin
    if not CreateDir(dirname) then exit;
  end;
  flname := dirname + '\Log-' + IntTo_Str(ahour) + 'h' +
    IntTo_Str(amin div 10 * 10) + 'm.txt';
  Label4.Caption := flname;

  AssignFile(f, flname);
  if not FileExists(flname) then
    Rewrite(f)
  else
    Append(f);

  fmtdatetime := FormatDateTime('yyyy-mm-dd hh:mm:ss', now);
  for i := 0 to LogList.Count - 1 do begin
    WriteLn(f, LogList[i] + ''#9 + fmtdatetime);
  end;
  LogList.Clear;

  CloseFile(f);
end;

procedure TFrmLogData.Timer1Timer(Sender: TObject);
begin
  WriteLogs;
end;

end.
