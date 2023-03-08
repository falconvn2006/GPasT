unit client.utils;

interface
type
  TClientUtils = class
    class function ApenasNumeros(valor : String) : String;
  end;

implementation

uses
  System.SysUtils;

{ TClientUtils }

class function TClientUtils.ApenasNumeros(valor: String): String;
var
  i: Integer;
begin
  for i := 0 to Length(valor) - 1 do
    if not CharInSet(valor[i], ['0' .. '9']) then
      delete(valor, i, 1);

  valor := StringReplace(valor, ' ', '', [rfReplaceAll]);
  Result := valor;
end;

end.
