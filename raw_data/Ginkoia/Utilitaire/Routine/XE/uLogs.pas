unit uLogs;

interface

uses SysUtils, StdCtrls, Classes, Dialogs;

Type
  TLogs = class
  private
    FPath: String;
    FFilename: String;
    FMemo: TMemo;

  public
    constructor Create;

    procedure AddToLogs(AText : String; AShowInMemo : Boolean = True);
  published
    property FileName : String read FFilename write FFileName;
    property Path : String read FPath write FPath;
    property Memo : TMemo read FMemo write FMemo;
  end;

  var
   Logs : TLogs;

implementation


{ TLogs }

procedure TLogs.AddToLogs(AText: String; AShowInMemo: Boolean);
var
  FFile : TFileStream;
  sLigne : String;
  Buffer : TBytes;
  {$IFNDEF VER185}
  Encoding : TEncoding;
  {$ENDIF}
begin
  if Trim(FFilename) = '' then
    raise Exception.Create('Nom de fichier obligatoire');

  if Trim(FPath) = '' then
    raise Exception.Create('Chemin de destination du fichier obligatoire');

  sLigne := FormatDateTime('[DD/MM/YYYY hh:mm:ss] ',Now) + AText + #13#10;

  if Assigned(FMemo) and AShowInMemo then
  begin
    while FMemo.lines.count > 200 do
      FMemo.Lines.Delete(0);
    FMemo.Lines.Add(Trim(sLigne));
  end;

  if FileExists(FPath + FFileName) then
  begin
    FFile := TFileStream.Create(FPath + FFileName,fmOpenReadWrite);
    FFile.Seek(0,soFromEnd);
  end else
    FFile := TFileStream.Create(FPath + FFileName,fmCreate);

  Try
    Try
      {$IFNDEF VER185}
      Encoding := TEncoding.Default;
      Buffer := Encoding.GetBytes(sLigne);
      FFile.Write(Buffer[0],Length(Buffer));
      {$ELSE}
      FFile.Write(sLigne[1],Length(sLigne));
      {$ENDIF}
    Except on E:Exception do
      if Assigned(FMemo) then
        FMemo.Lines.Add(Trim(sLigne));
    End;
  Finally
    FFile.Free;
  End;
  Sleep(50);
end;

constructor TLogs.Create;
begin
  inherited Create;
end;


initialization
  Logs := Tlogs.Create;
finalization
  FreeAndNil(Logs);
end.
