unit Rate.Entity;

interface
uses
  MVCFramework.Serializer.Commons;
type TRateEntity = class
  private
    FIdRate: Integer;
    FRate: Integer;
    FIdDog: String;

  public
    property IdRate: Integer read FIdRate write FIdRate;
    property Rate: Integer read FRate write FRate;
    property IdDog: String read FIdDog write FIdDog;

end;

implementation

end.
