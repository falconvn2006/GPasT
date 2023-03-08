unit uTranslate;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.JSON, System.Net.HTTPClient,
  System.NetEncoding;

function GoogleTranslate(const AValue, ConstSourceLang, ConstTargetLang: String): String;

implementation

function GoogleTranslate(const AValue, ConstSourceLang, ConstTargetLang: String): String;
var
  AResponce: IHTTPResponse;
  FHTTPClient: THTTPClient;
  AAPIUrl: String;
  j: Integer;
begin
  if AValue <> '' then
  begin
    AAPIUrl := 'https://translate.googleapis.com/translate_a/single?client=gtx&sl=' + ConstSourceLang + '&tl=' + ConstTargetLang + '&dt=t&q=' + TNetEncoding.URL.Encode(AValue);
    FHTTPClient := THTTPClient.Create;
    FHTTPClient.UserAgent := 'Mozilla/5.0 (Windows; U; Windows NT 6.1; ru-RU) Gecko/20100625 Firefox/3.6.6';
    result := '';
    AResponce := FHTTPClient.Get(AAPIUrl);
    if Not Assigned(AResponce) then
    begin
      result := result + 'unknow.';
      Exit;
    end;

    try
      for j := 0 to TJSONArray(TJSONArray(TJSONObject.ParseJSONValue(AResponce.ContentAsString)).Items[0]).Count - 1 do
        result := result + TJSONArray(TJSONArray(TJSONArray(TJSONObject.ParseJSONValue(AResponce.ContentAsString)).Items[0]).Items[j]).Items[0].Value;
    except
      result := '';
      Exit;
    end;
  end;
end;

end.
