unit Dog.Entity;

interface
uses
  MVCFramework.Serializer.Commons;
type TDogEntity = class
  private
    FIdDog: String;
    FRateNumber: Integer;
    FRating: Double;
    FUrl: String;
    
  public
    [MVCDoNotSerialize]
    property IdDog: String read FIdDog write FIdDog;
    property RateNumber: Integer read FRateNumber write FRateNumber;
    property Rating: Double read FRating write FRating;
    property Url: String read FUrl write FUrl;

end;

implementation

end.
