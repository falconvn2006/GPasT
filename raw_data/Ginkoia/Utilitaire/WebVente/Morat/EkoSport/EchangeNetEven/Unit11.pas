UNIT Unit11;

INTERFACE

USES
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls, InvokeRegistry, Rio, SOAPHTTPClient;

TYPE
  TForm11 = CLASS(TForm)
    Btn_: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Btn_soapit: TButton;
    HTTPRIO1: THTTPRIO;
    PROCEDURE Btn_Click(Sender: TObject);
    PROCEDURE Btn_2Click(Sender: TObject);
    procedure Btn_soapitClick(Sender: TObject);
    procedure HTTPRIO1BeforeExecute(const MethodName: string;
      var SOAPRequest: WideString);
  PRIVATE
    { Déclarations privées }
  PUBLIC
    { Déclarations publiques }
  END;

VAR
  Form11: TForm11;

IMPLEMENTATION
{$R *.dfm}

USES NWS,
  XSBuiltIns,
  XMLCursor,
  StdXML_TLB,
  soapOperation;

PROCEDURE TForm11.Btn_2Click(Sender: TObject);
BEGIN
//  soapit;
END;

PROCEDURE TForm11.Btn_Click(Sender: TObject);
VAR
  erTest: EchoRequestType;
  eaTest: EchoResponseType;

  rCdes: GetOrders;
  aCdes: GetOrdersResponse;

  sService: NWSServerPortType;

  rConnect: TestConnectionRequest;
  aConnect: TestConnectionResponse;


  tmpDT: TXSDateTime;

BEGIN
  sService := GetNWSServerPortType('laurent@ekosport.fr', '2fsarl73', HTTPRIO1);

//  Edit1.Text := IntToStr(THTTPRIO(sService).SoapHeaders.SendCount);

  erTest := EchoRequestType.Create;
  eaTest := EchoResponseType.Create;
  rCdes := GetOrders.Create;
  aCdes := GetOrdersResponse.Create;
  aConnect := TestConnectionResponse.Create;
  rConnect := TestConnectionRequest.Create;
  TRY
//    erTest.EchoInput := 'Pipo';
//    eaTest := sService.Echo(erTest);
//    //
//    Edit1.Text := eaTest.EchoOutput;

//    tmpDT.AsDateTime := Now - 10;
//    rCdes.DateSaleFrom := tmpDt;
//    //
//    tmpDT.AsDateTime := Now;
//    rCdes.DateSaleTo := tmpDt;
    //

    aConnect := sService.TestConnection(rConnect);

    CASE aConnect.TestConnectionResult OF
      Accepted: Edit2.Text := 'OK';
      Canceled: Edit2.Text := 'Cancel';
      NonConformantAuthorization: Edit2.Text := 'NCA';
      NonConformantFormat: Edit2.Text := 'NCF';
      Rejected: Edit2.Text := 'Reject';
      UnexpectedInformation: Edit2.Text := 'Unexp';
      //      Inserted: ShowMessage('Ins');
      //      Updated: ShowMessage('Upd');
      Error: Edit2.Text := 'Error';
      else Edit2.Text := 'Else';
    end;


    //   aCdes := sService.GetOrders(rCdes);

    //   ShowMessage(ACdes.GetOrdersResult[0].ID);
  FINALLY
    aCdes.Free;
    rCdes.Free;

    aConnect.Free;
    rConnect.Free;
    
    erTest.Free;
    eaTest.Free;
  END;
  FreeAndNil(sService);
END;

procedure TForm11.Btn_soapitClick(Sender: TObject);
begin
  //SoapIt;
end;



procedure TForm11.HTTPRIO1BeforeExecute(const MethodName: string;
  var SOAPRequest: WideString);
begin
  // Test
//  ShowMessage(SoapRequest);

  SoapRequest := StringReplace(SoapRequest, #13#10, '', [rfIgnoreCase, rfReplaceAll]);

  SoapRequest := StringReplace(SoapRequest, '<?xml version="1.0"?>', '<?xml version="1.0" encoding="UTF-8"?>', [rfIgnoreCase, rfReplaceAll]);

end;

END.

