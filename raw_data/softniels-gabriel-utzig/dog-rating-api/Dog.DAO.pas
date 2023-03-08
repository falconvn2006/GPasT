unit Dog.DAO;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  Uni,
  Data.Connection,
  Dog.Entity,
  Rate.DAO,
  Rate.Entity;

type
  TDogDAO = class
    FDataStream: TDataStream;
  public
    constructor Create(ADataStream: TDataStream); overload;
    procedure Insert(ADog: TDogEntity);
    procedure Rate(AIdApiDog: String; ARating: Integer);
    function FindById(AIdApiDog: String): TDogEntity;
    // function FindAll: TObjectList<TDogEntity>;
  end;

implementation

constructor TDogDAO.Create(ADataStream: TDataStream);
begin
  FDataStream := ADataStream;
end;

procedure TDogDAO.Insert(ADog: TDogEntity);
var
  LSQLQuery: TUniQuery;
begin
  try
    LSQLQuery            := TUniQuery.Create(nil);
    LSQLQuery.Connection := FDataStream.con;

    LSQLQuery.SQL.Add('INSERT INTO dog(id_api_dog, rate_number, rating, url) ' + //
      'VALUES (:id_api_dog, :rate_number, :rating, :url)');
    LSQLQuery.ParamByName('id_api_dog').AsString   := ADog.IdApiDog;
    LSQLQuery.ParamByName('rate_number').AsInteger := ADog.RateNumber;
    LSQLQuery.ParamByName('rating').AsCurrency     := ADog.Rating;
    LSQLQuery.ParamByName('url').AsString          := ADog.DogUrl;

    LSQLQuery.Execute;
  finally
    LSQLQuery.Free;
  end;
end;

procedure TDogDAO.Rate(AIdApiDog: String; ARating: Integer);
var
  LSQLQuery   : TUniQuery;
  LRateDAO    : TRateDao;
  LRateEntity : TRateEntity;
  LDogEntity  : TDogEntity;
  LAvarageRate: Currency;
  LRateNumber: Integer;
begin
  LRateDAO     := nil;
  LRateEntity  := nil;
  LDogEntity   := nil;
  LAvarageRate := 0.0;
  LRateNumber  := 0;
  if (ARating < 0) OR (ARating > 5) then
    raise Exception.Create('Rating must be between 1 and 5.');

  try
    LRateDAO          := TRateDao.Create(FDataStream);
    LRateEntity       := TRateEntity.Create;
    LDogEntity        := self.FindById(AIdApiDog);
    LRateEntity.Rate  := ARating;
    LRateEntity.DogId := LDogEntity.IdDog;
    LRateDAO.Insert(LRateEntity);

    LSQLQuery            := TUniQuery.Create(nil);
    LSQLQuery.Connection := FDataStream.con;
    LSQLQuery.SQL.Add('SELECT AVG(rate), COUNT(id_rate) FROM rate WHERE dog_id = :dog_id');
    LSQLQuery.ParamByName('dog_id').AsInteger := LDogEntity.IdDog;
    LSQLQuery.Execute;
    LSQLQuery.Open;
    LRateNumber := LSQLQuery.FieldByName('COUNT(id_rate)').AsInteger;
    LAvarageRate := LSQLQuery.FieldByName('AVG(rate)').AsCurrency;
    LSQLQuery.SQL.Clear;
    LSQLQuery.SQL.Add('UPDATE dog SET rate_number = :rate_number, rating = :rating ' + //
      'WHERE id_dog = :id_dog');
    LSQLQuery.ParamByName('id_dog').AsInteger  := LDogEntity.IdDog;
    LSQLQuery.ParamByName('rating').AsCurrency := LAvarageRate;
    LSQLQuery.ParamByName('rate_number').AsInteger := LRateNumber;

    LSQLQuery.Execute;
  finally
    LSQLQuery.Free;
  end;

end;

function TDogDAO.FindById(AIdApiDog: String): TDogEntity;
var
  LSQLQuery: TUniQuery;
begin
  try
    LSQLQuery            := TUniQuery.Create(nil);
    LSQLQuery.Connection := FDataStream.con;
    LSQLQuery.SQL.Add('SELECT * FROM dog where id_api_dog = :id_api_dog');
    LSQLQuery.ParamByName('id_api_dog').AsString := AIdApiDog;
    LSQLQuery.Execute;
    LSQLQuery.Open;

    if LSQLQuery.IsEmpty then
      raise Exception.Create('Id not Found');
    Result            := TDogEntity.Create;
    Result.IdDog      := LSQLQuery.FieldByName('id_dog').AsInteger;
    Result.IdApiDog   := LSQLQuery.FieldByName('id_api_dog').AsString;
    Result.RateNumber := LSQLQuery.FieldByName('rate_number').AsInteger;
    Result.Rating     := LSQLQuery.FieldByName('rating').AsCurrency;
    Result.DogUrl     := LSQLQuery.FieldByName('url').AsString;
  finally
    LSQLQuery.Free;
  end;
end;

end.
