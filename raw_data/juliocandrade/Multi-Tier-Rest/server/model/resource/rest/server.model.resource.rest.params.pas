unit server.model.resource.rest.params;

interface
uses
  server.model.resource.interfaces;
type
  TRestParams = class(TInterfacedObject, iRestParams)
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

{ TRestParams }

function TRestParams.Accept(aValue: string): iRestParams;
begin
  Result := Self;
  FAccept := aValue;
end;

function TRestParams.Accept: string;
begin
  Result := FAccept;
end;

function TRestParams.BaseURL(aValue: string): iRestParams;
begin
  Result := Self;
  FBaseURL := aValue;
end;

function TRestParams.BaseURL: String;
begin
  Result := FBaseURL;
end;

function TRestParams.Body: string;
begin
  Result := FBody;
end;

constructor TRestParams.Create(Parent: iRest);
begin
  FParent := Parent;
end;

function TRestParams.Body(aValue: string): iRestParams;
begin
  Result := Self;
  FBody := aValue
end;

function TRestParams.&End: iRest;
begin
  Result := FParent;
end;

function TRestParams.EndPoint(aValue: string): iRestParams;
begin
  Result := Self;
  FEndPoint := aValue;
end;

function TRestParams.EndPoint: String;
begin
  Result := FEndPoint;
end;

class function TRestParams.New(Parent : iRest): iRestParams;
begin
  Result := Self.Create(Parent);
end;

end.
