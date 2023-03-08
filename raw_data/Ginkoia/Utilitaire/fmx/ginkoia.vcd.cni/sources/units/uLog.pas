unit uLog;

interface

uses
  System.Classes, System.SysUtils;

type
  TLog = record
    class var Filename: String;
    class procedure Add(const Text: String); static;
  end;

implementation

{ TLog }

class procedure TLog.Add(const Text: String);
var
//  FileStream: TFileStream;
  StreamWriter: TStreamWriter;
begin
//  FileStream := TFileStream.Create( TLog.Filename, fmCreate or fmOpenWrite or fmShareDenyWrite );
//  try
//    StreamWriter := TStreamWriter.Create( FileStream );
    StreamWriter := TStreamWriter.Create( TLog.Filename, True, TEncoding.UTF8 );
    try
      StreamWriter.WriteLine( Text );
      StreamWriter.Flush;
    finally
      StreamWriter.Free;
    end;
//  finally
//    FileStream.Free;
//  end;
end;

initialization
  TLog.Filename := 'log.txt';

finalization

end.
