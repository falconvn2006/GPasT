unit Data.Source;

interface

uses
  System.SysUtils,
  MVCFramework.RESTClient,
  MVCFramework.RESTClient.Intf,
  System.JSON,
  REST.JSON;

type
  TDataSoruce = class
    FAPIClient: TMVCRESTClient;
  Public
    constructor Create(); overload;
    function GetDog(): TJSONValue;
    destructor Destroy; override;
  end;

implementation

constructor TDataSoruce.Create();
begin
  FAPIClient := TMVCRESTClient.Create;
  FAPIClient.BaseURL('https://api.thedogapi.com/v1/');
end;

function TDataSoruce.GetDog(): TJSONValue;
Var
  LAPIResponse: IMVCRESTResponse;
  LJSONArray  : TJSONArray;
begin
  LJSONArray := nil;
  try
    LJSONArray := TJSONArray.Create;

    LAPIResponse := FAPIClient.Get('images/search');
    if not LAPIResponse.Success then
      raise Exception.Create('No dogs found =(');

    LJSONArray := TJSONArray.Create(TJSONObject.ParseJSONValue(LAPIResponse.Content) as TJSONArray);

    Result := LJSONArray[0];
  finally
  end;

end;

destructor TDataSoruce.Destroy;
begin
  if FAPIClient <> nil then
    FAPIClient.Free;

  inherited;
end;

end.
