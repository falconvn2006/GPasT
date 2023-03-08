unit server.model.exceptions;

interface

uses
  System.SysUtils;
type
  ECampoInvalido = class(Exception)
  end;
  EProviderException = class(Exception)
  private
    FError: string;
    FStatus: Integer;
  public
    constructor Create; reintroduce;
    class function New : EProviderException;
    function Error(AValue : String) : EProviderException; overload;
    function Error : String; overload;
    function Status(AValue : Integer) : EProviderException; overload;
    function Status : Integer; overload;
    function ToJSONText : String;
  end;
implementation

{ EProviderException }

function EProviderException.Error(AValue: String): EProviderException;
begin
  Result := Self;
  FError := aValue;
end;

constructor EProviderException.Create;
begin
  FError := EmptyStr;
  FStatus := 500;
end;

function EProviderException.Error: String;
begin
  Result := FError;
end;

class function EProviderException.New: EProviderException;
begin
  Result := Self.Create;
end;

function EProviderException.Status(AValue: Integer): EProviderException;
begin
  Result := Self;
  FStatus := aValue;
end;

function EProviderException.Status: Integer;
begin
  Result := FStatus;
end;

function EProviderException.ToJSONText: String;
begin
  Result := Format('{"error": "%s"}', [FError]);
end;

end.
