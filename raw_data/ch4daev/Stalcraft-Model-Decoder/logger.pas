unit Logger;

{$mode objfpc}{$H+}

interface

type

  { TLogger }

  TLogger = class
  public
    procedure Log(s:string); virtual; abstract;

    class procedure Log(l:TLogger; s:string);
  end;

implementation

{ TLogger }

class procedure TLogger.Log(l: TLogger; s: string);
begin
     if l<>nil then begin
       l.Log(s);
     end;
end;

end.

