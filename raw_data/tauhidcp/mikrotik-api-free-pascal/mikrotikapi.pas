unit mikrotikapi;

interface

uses routerosapi, Classes, SysUtils;

type

{ TMikrotikAPI }

  TMikrotikAPI = class
  private
     ROS  : TRosApiClient;
  public
     Host : AnsiString;
     User : AnsiString;
     Pass : AnsiString;
     Port : AnsiString;
     Res  : TRosApiResult;
     Login : Boolean;
    function Connect:Boolean;
    function Execute(Command : String) : String;
    function getResult(Command:String) : TRosApiResult;
  end;

implementation

procedure Split(Delimiter: Char; Str: string; ListOfStrings: TStrings);
begin
   ListOfStrings.Clear;
   ListOfStrings.Delimiter       := Delimiter;
   ListOfStrings.StrictDelimiter := True;
   ListOfStrings.DelimitedText   := Str;
end;

function TMikrotikAPI.Connect:Boolean;
begin
  try
    ROS    := TRosApiClient.Create;
    Login  := ROS.Connect(Host, User, Pass, Port);
    Result := Login;
  except
    Result := False;
  end;
end;

function TMikrotikAPI.Execute(Command : String): String;
var
  Pecah : TStringList;
  Perintah : array of String;
  i,j : integer;
begin
   try
     Pecah := TStringList.Create;
     Split(' ', Command, Pecah);
       if (Pecah.Count >= 1) then
       begin
          i := 1;
          SetLength(Perintah, Pecah.Count);
          Perintah[0] := Trim(Pecah[0]);
         for j := 1 to (Pecah.Count-1) do begin
          Perintah[j] := '='+Trim(Pecah[j]);
          end;
       end;
       if High(Perintah) >= 1 then ROS.Execute(Perintah) else Result := ROS.LastError;
       if ROS.LastError <> '' then Result := ROS.LastError;
       Pecah.Free;
       SetLength(Perintah, 0);
       Result := 'Done!';
   except
   Result := 'Failed!';
   end;
end;

function TMikrotikAPI.getResult(Command : String): TRosApiResult;
begin
  try
    Res    := ROS.Query([Command], True);
    Result := Res;
  except
  end;
end;

end.





