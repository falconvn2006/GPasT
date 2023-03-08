unit NetEvenAccess_Dm;

interface

uses
  SysUtils, Classes, InvokeRegistry, Rio, SOAPHTTPClient;

type
  TDm_NetEvenAccess = class(TDataModule)
    ServiceNETEVEN: THTTPRIO;
    procedure ServiceNETEVENBeforeExecute(const MethodName: string;
      var SOAPRequest: WideString);
  private
    { Déclarations privées }
  public
  end;

var
  Dm_NetEvenAccess: TDm_NetEvenAccess;


function Echo(AEcho: string): string;

implementation

{$R *.dfm}

uses Nws;

{ TDm_NetEvenAccess }

function Echo(AEcho: string): string;
var
  erTest: EchoRequestType;
  eaTest: EchoResponseType;


  sService: NWSServerPortType;

//  rConnect: TestConnectionRequest;
//  aConnect: TestConnectionResponse;
//  aConnect := TestConnectionResponse.Create;
//  rConnect := TestConnectionRequest.Create;
//  aConnect.Free;
//  rConnect.Free;


//  rCdes: GetOrders;
//  aCdes: GetOrdersResponse;
//  rCdes := GetOrders.Create;
//  aCdes := GetOrdersResponse.Create;
//  aCdes.Free;
//  rCdes.Free;



//  tmpDT: TXSDateTime;
begin

 Dm_NetEvenAccess := TDm_NetEvenAccess.Create(nil);

 TRY

 sService := GetNWSServerPortType('', '', Dm_NetEvenAccess.ServiceNETEVEN);

//  Edit1.Text := IntToStr(THTTPRIO(sService).SoapHeaders.SendCount);

  erTest := EchoRequestType.Create;
  eaTest := EchoResponseType.Create;
  TRY
    erTest.EchoInput := AEcho;
//    eaTest := sService.Echo(erTest);
//    //
//    Edit1.Text := eaTest.EchoOutput;

//    tmpDT.AsDateTime := Now - 10;
//    rCdes.DateSaleFrom := tmpDt;
//    //
//    tmpDT.AsDateTime := Now;
//    rCdes.DateSaleTo := tmpDt;
    //

//    aConnect := sService.TestConnection(rConnect);
//
//    CASE aConnect.TestConnectionResult OF
//      Accepted: Edit2.Text := 'OK';
//      Canceled: Edit2.Text := 'Cancel';
//      NonConformantAuthorization: Edit2.Text := 'NCA';
//      NonConformantFormat: Edit2.Text := 'NCF';
//      Rejected: Edit2.Text := 'Reject';
//      UnexpectedInformation: Edit2.Text := 'Unexp';
//      //      Inserted: ShowMessage('Ins');
//      //      Updated: ShowMessage('Upd');
//      Error: Edit2.Text := 'Error';
//      else Edit2.Text := 'Else';
//    end;


    //   aCdes := sService.GetOrders(rCdes);

    //   ShowMessage(ACdes.GetOrdersResult[0].ID);
  FINALLY
    erTest.Free;
    eaTest.Free;
  END;
  FreeAndNil(sService);
 Finally
   Dm_NetEvenAccess.Free;
 end;
end;

end.
