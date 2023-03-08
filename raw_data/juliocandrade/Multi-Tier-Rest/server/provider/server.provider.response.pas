unit server.provider.response;

interface
type
  TProviderResponse = class
  private
    FResultStatusCode : Integer;
    FResultStatus : String;
    FBody : String;
    function GetBody: String;
    procedure SetBody(const Value: String);
    function GetResultStatus: string;
    function GetResultStatusCode: Integer;
    procedure SetResultStatus(const Value: string);
    procedure SetResultStatusCode(const Value: Integer);
  public
    property ResultStatusCode : Integer read GetResultStatusCode write SetResultStatusCode;
    property ResultStatus : string read GetResultStatus write SetResultStatus;
    property Body : String read GetBody write SetBody;
  end;
implementation

{ TProviderResponse }


function TProviderResponse.GetBody: String;
begin
  Result := FBody;
end;

function TProviderResponse.GetResultStatus: string;
begin
  Result := FResultStatus;
end;

function TProviderResponse.GetResultStatusCode: Integer;
begin
  Result := FResultStatusCode;
end;

procedure TProviderResponse.SetBody(const Value: String);
begin
  FBody := Value;
end;

procedure TProviderResponse.SetResultStatus(const Value: string);
begin
  FResultStatus := Value;
end;

procedure TProviderResponse.SetResultStatusCode(const Value: Integer);
begin
  FResultStatusCode := Value;
end;

end.
