unit Dog.Entity;

interface
uses
  MVCFramework.Serializer.Commons;
type TDogEntity = class
  private
    FIdDog: Integer;
    FIdApiDog: String;
    FDogURL: String;
    FRateNumber: Integer;
    FRating: Double;
    
  public
    [MVCDoNotSerialize]
    property IdDog: Integer read FIdDog write FIdDog;
    property IdApiDog: String read FIdApiDog write FIdApiDog;
    property DogUrl: String read FDogUrl write FDogUrl;
    property RateNumber: Integer read FRateNumber write FRateNumber;
    property Rating: Double read FRating write FRating;

end;

implementation

end.
