unit uUptime;

interface

type
  TUptimeRec = record
  strict private
    class function GetUptime: TDateTime; static;
  public
    class property Uptime: TDateTime read GetUptime;
    class var CreationTime: TDateTime;
  end;

implementation

uses
  Winapi.Windows, System.SysUtils;

//Convert then FileTime to TDatetime format
function FileTime2DateTime(FileTime: TFileTime): TDateTime;
var
  LocalTime: TFileTime;
  DOSTime  : Integer;
begin
  FileTimeToLocalFileTime( FileTime, LocalTime );
  FileTimeToDosDateTime(
    LocalTime,
    LongRec( DOSTime ).Hi,
    LongRec( DOSTime ).Lo
  );
  Exit( FileDateToDateTime( DOSTime ) );
end;

var
  lpCreationTime, lpExitTime, lpKernelTime, lpUserTime: TFileTime;

{ TTime }

class function TUptimeRec.GetUptime: TDateTime;
begin
  Exit( Now - TUptimeRec.CreationTime );
end;

initialization
  GetProcessTimes(
    GetCurrentProcess,
    lpCreationTime,
    lpExitTime,
    lpKernelTime,
    lpUserTime
  );
  TUptimeRec.CreationTime := FileTime2DateTime( lpCreationTime );

end.
