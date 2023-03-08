unit uCopythread;

interface

uses
  Classes, SysUtils;
{
type
  TCopyThread = class(TThread)
  private
    FIn, FOut : string;
    procedure copyfile;
  public
    procedure Execute ; override;
    constructor create (const source, dest : string);
  end;
}
implementation
{
procedure TCopyThread.Execute;
begin
 // CopyResult := CopyFileEx(CurrentName, NewName, CopyProgressRoutine, Self,
//    @Cancel, CopyFlags);
end;

}


end.
