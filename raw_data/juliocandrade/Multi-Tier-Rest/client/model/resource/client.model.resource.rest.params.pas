unit client.model.resource.rest.params;

interface
uses
  client.model.resource.interfaces;
type
  TClientRestParams = class(TInterfacedObject, iRestParams)
  private
    [weak]
    FParent : iRest;
    FBaseURL : string;
    FEndPoint : string;
    FAccept : string;
    FBody : string;
  public
    constructor Create(Parent : iRest);
    class function New(Parent : iRest) : iRestParams;
    function BaseURL (aValue : string) : iRestParams; overload;
    function BaseURL : String; overload;
    function EndPoint (aValue : string) : iRestParams; overload;
    function EndPoint : String; overload;
    function Body(aValue : string) : iRestParams; overload;
    function Body : string; overload;
    function Accept(aValue : string) : iRestParams; overload;
    function Accept : string; overload;
    function &End : iRest;
  end;
implementation

{ TClientRestParams }

function TClientRestParams.Accept(aValue: string): iRestParams;
begin
  Result := Self;
  FAccept := aValue;
end;

function TClientRestParams.Accept: string;
begin
  Result := FAccept;
end;

function TClientRestParams.BaseURL(aValue: string): iRestParams;
begin
  Result := Self;
  FBaseURL := aValue;
end;

function TClientRestParams.BaseURL: String;
begin
  Result := FBaseURL;
end;

function TClientRestParams.Body: string;
begin
  Result := FBody;
end;

constructor TClientRestParams.Create(Parent: iRest);
begin
  FParent := Parent;
end;

function TClientRestParams.Body(aValue: string): iRestParams;
begin
  Result := Self;
  FBody := aValue
end;

function TClientRestParams.&End: iRest;
begin
  Result := FParent;
end;

function TClientRestParams.EndPoint(aValue: string): iRestParams;
begin
  Result := Self;
  FEndPoint := aValue;
end;

function TClientRestParams.EndPoint: String;
begin
  Result := FEndPoint;
end;

class function TClientRestParams.New(Parent : iRest): iRestParams;
begin
  Result := Self.Create(Parent);
end;

end.
