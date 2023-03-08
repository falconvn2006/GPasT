unit server.provider.request;

interface
type
  TProviderRequest = class
  private
    FBody : String;
    FParams : Tarray<string>;
  public
    constructor Create(aBody: String; aParams: TArray<String>);
    function Params : Tarray<string>;
    function Body : String;
  end;
implementation

{ TProviderRequest }

function TProviderRequest.Body: String;
begin
  Result := FBody;
end;

constructor TProviderRequest.Create(aBody: String; aParams: TArray<String>);
begin
  FBody := aBody;
  FParams := aParams;
end;

function TProviderRequest.Params: Tarray<string>;
begin
  Result := FParams;
end;

end.
