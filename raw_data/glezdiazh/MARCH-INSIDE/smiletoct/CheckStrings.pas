unit CheckStrings;

interface
uses StrUtils;
function occurrenceX( substr: char; str2check: string):integer;
procedure GetEntryStr (StrInput:String; OType : Integer ;var S1, S2 : string);

implementation

function occurrenceX( substr: char; str2check: string):integer;
var
 i,j : integer;
begin
 j:= 0;
 for I := 1 to length (Str2Check) do
  begin
   if Str2Check [i] = substr then Inc (J);
end;
 occurrencex := j;
end;

procedure GetEntryStr (StrInput:String; OType : Integer ;var S1, S2 : string);
Var
 j : Integer;
begin
 StrInput:= AnsiReplaceStr(StrInput, chr(9), ' ');
 while StrInput[1]=' '  do Delete(StrInput,1,1);
 j := Pos(' ',StrInput);
 case Otype of
  0:begin
    S1 := Copy(StrInput,j+1, Length(StrInput));
    S2 := Copy(StrInput,1, j-1);
    end;
  1:begin
     S2 := Copy(StrInput, j, Length(StrInput)) ;
     S1 := Copy(StrInput, 1, J-1);
    end;
 end;
 While pos(' ', S1)<> 0 do delete(S1, pos(' ',S1), 1);
end;
end.
