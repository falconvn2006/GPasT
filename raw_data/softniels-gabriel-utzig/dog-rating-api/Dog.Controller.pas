unit Dog.Controller;

interface

uses
  MVCFramework,
  MVCFramework.Commons,
  MVCFramework.Serializer.Commons;

type

  [MVCPath('/api')]
  TDogs = class(TMVCController)

  public
    [MVCPath]
    [MVCHTTPMethod([httpGET])]
    procedure Index;

    [MVCPath('/dogs')]
    [MVCHTTPMethod([httpGET])]
    procedure GetDogs;

    [MVCPath('/dogs/($id)')]
    [MVCHTTPMethod([httpGET])]
    procedure getDog(id: String);

    [MVCPath('/dogs/rate/($id)')]
    [MVCHTTPMethod([httpPOST])]
    procedure RateDog(id: String);

  end;

implementation

uses
  System.SysUtils,
  MVCFramework.Logger,
  System.StrUtils,
  MVCFramework.RESTClient,
  MVCFramework.RESTClient.Intf,
  System.JSON,
  REST.JSON,
  Data.Connection,
  Dog.DAO,
  Dog.Entity;

procedure TDogs.Index;
begin
  render(200, '{"message":"Dog Rating API. =)"}')
end;

procedure TDogs.GetDogs;
var
  LAPIClient     : IMVCRESTClient;
  LAPIResponse   : TJSONObject;
  LDogDAO        : TDogDAO;
  LDogEntity     : TDogEntity;
  LJsonResponse  : TJSONArray;
  LDataConnection: TDataStream;
  ArrayElement   : TJSonValue;
  LAPISource     : IMVCRESTResponse;
  LDogSerialized : TJSONObject;

begin
  LAPIClient      := nil;
  LJsonResponse   := nil;
  LDataConnection := nil;
  LDogDAO         := nil;
  LAPIResponse    := nil;
  LAPISource      := nil;
  LDogEntity      := nil;
  ArrayElement    := nil;

  try
    LDataConnection := TDataStream.Create(nil);
    LDogEntity      := TDogEntity.Create;
    LDogDAO         := TDogDAO.Create(LDataConnection);

    LAPIClient := TMVCRESTClient.Create;
    LAPIClient.BaseURL('https://api.thedogapi.com/v1/');

    LAPISource := LAPIClient.Get('images/search');

    if LAPISource.Success then
    begin
      LJsonResponse := TJSONArray.Create;
      LJsonResponse := TJSONObject.ParseJSONValue(LAPISource.Content) as TJSONArray;
      try
        LDogEntity := LDogDAO.FindById(LJsonResponse[0].GetValue<string>('id'));
      except
        on E: Exception do
        begin
          LDogEntity.IdApiDog   := LJsonResponse[0].GetValue<string>('id');
          LDogEntity.DogUrl     := LJsonResponse[0].GetValue<string>('url');
          LDogEntity.RateNumber := 0;
          LDogEntity.Rating     := 0;
          LDogDAO.Insert(LDogEntity);
        end;
      end;

      render(201, LDogEntity);
    end;
  finally
    LJsonResponse.Free;
    LDataConnection.Free;
    LDogDAO.Free;
    LAPIResponse.Free;
    ArrayElement.Free;
  end;
end;

procedure TDogs.getDog(id: String);
var
  LDataConnection: TDataStream;
  LDogDAO        : TDogDAO;
  LDogEntity     : TDogEntity;

begin
  LDataConnection := nil;
  LDogDAO         := nil;
  LDogEntity      := nil;
  try
    LDataConnection := TDataStream.Create(nil);
    LDogEntity      := TDogEntity.Create;
    LDogDAO         := TDogDAO.Create(LDataConnection);
    try
      LDogEntity := LDogDAO.FindById(id);
      render(200, LDogEntity)
    except
      on E: Exception do
        render(404, '{"error":"' + E.Message + '"');
    end;
  finally
    LDogDAO.Free;
    LDataConnection.Free;
  end;

end;

procedure TDogs.RateDog(id: String);
var
  LRating        : TJSonValue;
  LDataConnection: TDataStream;
  LDogDAO        : TDogDAO;
  LDogEntity     : TDogEntity;

begin
  LDataConnection := nil;
  LDogDAO         := nil;
  LRating         := nil;
  LDogEntity      := nil;

  try
    LDataConnection := TDataStream.Create(nil);
    LDogDAO         := TDogDAO.Create(LDataConnection);
    LDogEntity      := TDogEntity.Create;
    try
      LRating := TJSONObject.ParseJSONValue(Context.Request.Body);
      LDogDAO.Rate(id, LRating.FindValue('rating').AsType<Integer>);
      LDogEntity := LDogDAO.FindById(id);
      render(200, LDogEntity);

    except
      on E: Exception do
    end;
  finally

  end;
end;

end.
