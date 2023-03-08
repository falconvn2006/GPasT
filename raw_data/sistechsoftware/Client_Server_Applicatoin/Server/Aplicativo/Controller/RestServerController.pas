unit RestServerController;

interface

uses
  uRESTDWMasterDetailData, uRESTDWServerEvents;

type
  TRestServerController = class
    private
    FRestServer: TDWServerEvents;

    public
      property RestServer : TDWServerEvents read FRestServer write FRestServer;

      constructor Create; overload;
  end;

implementation

uses
  System.Classes, uDWConsts;

{ TRestClientController }
constructor TRestServerController.Create;
var
  eventList : TDWEventList;
  event : TDWEvent;
  teste : TCollection;
  teste2 : TCollectionItem;
begin
  FRestServer := TDWServerEvents.Create(Nil);

  with event do
  begin
    TDWEvent.Create(Nil);
    event.EventName := 'NovoCliente';
    event.JsonMode  := jmPureJSON;
    event.NeedAuthorization := True;
    event.Routes    := [crGet];
  end;

  eventList := TDWEventList.Create(Nil, Nil);
  teste2 :=  eventList.Add;
  FRestServer.Events := eventList;
end;

end.
