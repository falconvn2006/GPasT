unit uFTPUtils;

interface

uses
  Classes;

type
  TFTPLogLevel = (ftpllError, ftpllWarning, ftpllInfo, ftpllDebug);
  TFTPLogEvent = procedure(Sender: TObject; ALog: string; AWMSLogLvl: TFTPLogLevel) of object;

  procedure WriteErrorLog(AFilePath: string; ALogMessage: string);


implementation

uses
  SysUtils;

procedure WriteErrorLog(AFilePath: string; ALogMessage: string);
var
  tmpfile: TextFile;
begin
  AssignFile(tmpfile, AFilePath);
  IF NOT FileExists(AFilePath) THEN
  BEGIN
    Rewrite(tmpfile);
    CloseFile(tmpfile);
  END;
  // Log effectué dans le fichier
  Append(tmpfile);

  WriteLn(tmpfile, FormatDateTime('dd/mm/yyyy hh:mm:ss', Date + Time) + ' : ' + ALogMessage);

  CloseFile(tmpfile);
end;

end.
