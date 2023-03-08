unit uCommunicationAPI;

interface

uses Classes, SysUtils, IdHTTP, uJSON;

type
  TApiResult<T : class, constructor> = class(TPersistent)
  private
    FErrNo : Integer;
    FError : String;
    FResult : TPersistent;
  public
    constructor Create;
    destructor Destroy ; override ;
    procedure Get(sURL, sParam : String);
    function getResult : T ;
  published
    property ErrNo : Integer  read FErrNo   write FErrNo;
    property Error : String   read FError   write FError;
    property Result : TPersistent  read FResult  write FResult;
  end;

  TSendObjToApi<T : class, constructor>= class(TPersistent)
  private
    FErrNo : Integer;
    FError : String;
    FResult : boolean;
  public
    function Send(Obj : T; sURL, sParam : String) : boolean;
  published
    property ErrNo : Integer  read FErrNo   write FErrNo;
    property Error : String   read FError   write FError;
    property Result : boolean  read FResult  write FResult;
  end;

implementation

{ TApiResult<T> }

constructor TApiResult<T>.Create;
begin
  inherited;
  FResult := TPersistent(T.Create) ;
end;

destructor TApiResult<T>.Destroy;
begin
  if Assigned(FResult)
    then FResult.Destroy ;

  inherited;
end;

procedure TApiResult<T>.Get(sURL, sParam: String);
var
  Http : TIdHTTP;
  vResponse : TStringStream;
begin
  try
    try
      Http := TIdHTTP.Create(nil);
      Http.ConnectTimeout := 2000;
      Http.Request.ContentType := 'application/json';
      vResponse := TStringStream.Create('');
      Http.Get(sURL + sParam, vResponse);
      if Http.ResponseCode = 200 then
          TJSON.JSONToObject(vResponse.DataString, self);
    except
      on E:Exception do
      begin

      end;
    end;
  finally
    Http.Free;
    vResponse.Free;
  end;
end;

function TApiResult<T>.getResult: T;
begin
  Result := T(FResult) ;
end;

{ TSendObjToApi<T> }

function TSendObjToApi<T>.Send(Obj: T; sURL, sParam: String): boolean;
var
  Http : TIdHTTP;
  vText : string;
  vSend : TStringStream;
  vResponse : TStringStream;
begin
  result := false;
  try
    try
      Http := TIdHTTP.Create(nil);
      Http.ConnectTimeout := 2000;
      Http.Request.ContentType := 'application/json';
      vResponse := TStringStream.Create('');
      vText := TJSON.ObjectToJSON(TPersistent(Obj));
      vSend := TStringStream.Create(vText);
      Http.Post(sURL + sParam, vSend, vResponse);
      if Http.ResponseCode = 200 then
          TJSON.JSONToObject(vResponse.DataString, self)
      else
      begin
        raise Exception.Create('Result http error : ' + Http.ResponseText);
      end;
      result := FResult;
    except on E:Exception do
      begin
      end;
    end;
  finally
    Http.Free;
    vResponse.Free;
  end;
end;

end.
