unit server.utils;

interface
uses
  Data.DB;
type
  TServerUtils = class
    class function DecodeURI(URI : String) : String;
    class function GetParamsFromURI(URI : String) : TArray<String>;
    class procedure SetEmptyParamsToNull(aParams : TParams);
    class procedure SetEmptyParamToNull(aParam : TParam);
    class function ApenasNumeros(valor : String) : String;
  end;
implementation

uses
  System.SysUtils,
  System.Classes;

{ TServerUtils }

class function TServerUtils.ApenasNumeros(valor: String): String;
var
  i: Integer;
begin
  for i := 0 to Length(valor) - 1 do
    if not CharInSet(valor[i], ['0' .. '9']) then
      delete(valor, i, 1);

  valor := StringReplace(valor, ' ', '', [rfReplaceAll]);
  Result := valor;
end;

class function TServerUtils.DecodeURI(URI: String): String;
var
  LURIParts : TArray<String>;
begin
  LURIParts := URI.Split(['/']);
  Result := '/' + LURIParts[1] + StringOfChar('/', Length(LURIParts) - 2);
end;

class function TServerUtils.GetParamsFromURI(URI: String): TArray<String>;
begin
  Result := URI.Split(['/']);
  Delete(Result,0, 2);
end;

class procedure TServerUtils.SetEmptyParamToNull(aParam: TParam);
begin
  case aParam.DataType of
    ftString,
    ftWideString :
      if aParam.AsString.IsEmpty then
        aParam.Clear;
  end;
end;

class procedure TServerUtils.SetEmptyParamsToNull(aParams: TParams);
var
  I : Integer;
begin
  if Assigned(aParams) then
    for I := 0 to Pred(aParams.count) do
      SetEmptyParamToNull(aParams.Items[I]);
end;

end.
