unit UCst;

interface

const
   //URL = 'http://localHost/tech/AccesBase.dll/';
   URL = 'http://lame2.no-ip.com/tech/AccesBase.dll/';
   //URL = 'http://192.168.13.20/tech/AccesBase.dll/';
   LecteurLame='D';

FUNCTION traitechaine(S: string): string;

implementation

FUNCTION traitechaine(S: string): string;
var
   kk: Integer;
begin
   while pos(' ', S) > 0 do
   begin
      kk := pos(' ', S);
      delete(S, kk, 1);
      Insert('%20', S, kk);
   end;
   result := S;
end;


end.
