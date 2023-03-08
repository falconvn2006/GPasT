unit Controller.RestReq;

interface

uses
  Pkg.Json.DTO, System.Generics.Collections, REST.Json.Types, REST.Client,
  REST.Types;

type
  TRequisicaoRest = class
  public
    FCodHttp: Integer;
    FResposta: String;
    constructor Create;
    destructor Destroy; override;
    function RESTReqHTTP(sBaseURL, sBody, jsParametros: String; rmMetodo: String; var CodHttp: Integer): TRequisicaoRest;
  published
    property CodHttp: Integer read FCodHttp write FCodHttp;
    property Resposta: String read FResposta write FResposta;
  end;

implementation

{ TRequisicaoRest }

constructor TRequisicaoRest.Create;
begin
  TRequisicaoRest.Create;
end;

destructor TRequisicaoRest.Destroy;
begin
  inherited;
end;

function TRequisicaoRest.RESTReqHTTP(sBaseURL, sBody, jsParametros: String; rmMetodo: String; var CodHttp: Integer): TRequisicaoRest;
begin
  Result.FCodHttp := 200;
  Result.Resposta := 'resposta';
end;

end.
