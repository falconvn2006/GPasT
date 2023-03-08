unit Rate.DAO;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  Uni,
  Data.Connection,
  Rate.Entity;

type
  TRateDao = class
    FDataStream: TDataStream;
  public
    constructor Create(ADataStream: TDataStream); overload;
    procedure Insert(ADog: TRateEntity);
    function GetByDogId(ADogId: Integer): TArray<TRateEntity>;
  end;

implementation

constructor TRateDao.Create(ADataStream: TDataStream);
begin
  FDataStream := ADataStream;
end;

procedure TRateDao.Insert(ADog: TRateEntity);
var
  LSQLQuery: TUniQuery;
begin
  try
    LSQLQuery            := TUniQuery.Create(nil);
    LSQLQuery.Connection := FDataStream.con;

    LSQLQuery.SQL.Add('INSERT INTO rate(rate, dog_id) ' + //
      'VALUES (:rate, :dog_id)');
    LSQLQuery.ParamByName('rate').AsInteger   := ADog.Rate;
    LSQLQuery.ParamByName('dog_id').AsInteger := ADog.DogId;

    LSQLQuery.Execute;
  finally
    LSQLQuery.Free;
  end;
end;

function TRateDao.GetByDogId(ADogId: Integer):TArray<TRateEntity>;
var
  LSQLQuery: TUniQuery;
  rate: TObject;
begin
  try
    LSQLQuery            := TUniQuery.Create(nil);
    LSQLQuery.Connection := FDataStream.con;
    LSQLQuery.SQL.Add('SELECT * FROM rate WHERE dog_id = :dog_id;');
    LSQLQuery.ParamByName('dog_id').AsInteger := ADogId;
    LSQLQuery.Execute;
    LSQLQuery.Open;
    if LSQLQuery.IsEmpty then
      raise Exception.Create('Id not Found');
    result := TArray<TRateEntity>.Create();
    for rate in LSQLQuery do
    begin
      raise Exception.Create(rate.ToString);
    end;

  finally
    LSQLQuery.Free;
  end;
end;
end.
