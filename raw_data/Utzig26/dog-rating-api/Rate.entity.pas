unit Rate.entity;

interface
uses
  MVCFramework.Serializer.Commons;
type TRateEntity = class
  private
    FIdRate: Integer;
    FRate: Integer;
    FDogId: Integer;

  public
    [MVCDoNotSerialize]
    property IdRate: Integer read FIdRate write FIdRate;
    property Rate: Integer read FRate write FRate;
    property DogId: Integer read FDogId write FDogId;
end;

implementation

end.
