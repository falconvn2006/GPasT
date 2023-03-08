unit NetEvenGestion;

interface

uses Windows, Classes, Variants, InvokeRegistry, SOAPHTTPClient, SOAPPasInv, Types, XSBuiltIns, Dialogs, NetEvenWS;

TYPE
  TGestionNetEven = CLASS(TComponent)
  PRIVATE
    FRIO: THTTPRIO;
    FURL, FLogin, FPassword: STRING;
    FHAppel: STRING;
    FFileNameQ: STRING;
    FFileNameR: STRING;
    FPathSvg: STRING;
    FFonction: STRING;
    FDoSaveFile: Boolean;
  PUBLIC
    PROCEDURE MyRioBeforeExecute(CONST MethodName: STRING; SOAPRequest: TStream);
    PROCEDURE MyRioAfterExecute(CONST MethodName: STRING; SOAPResponse: TStream);

    CONSTRUCTOR Create(Owner: TComponent; AURL, ALogin, APassword, APath: STRING); OVERLOAD;
    DESTRUCTOR Destroy; OVERRIDE;

    FUNCTION ServerIsHere(): Boolean;
    FUNCTION TestConnection(): STRING;
    FUNCTION GetCommandes(DateDeb, DateFin: TDateTime; ACodeSite: integer;  ANumPage : integer = 1): GetOrdersResponse;
    FUNCTION PostCommandes(ACdeIdWeb, ATypeRgl: Integer; ADateRegl, ADateEnvoi: TDateTime; ANumColis: STRING): String;
    // TODO : PostOrders pour la remontée
    // TODO : Inventaires GetItems/PostItems

    PROPERTY RIO: THTTPRIO READ FRIO WRITE FRIO;

  END;

var
  MyHeader: AuthenticationHeader;



FUNCTION NWSServerPrepare(AURL, ALogin, APassword: STRING; ARIO: THTTPRIO): NWSServerPortType;
FUNCTION CreerNWSServer(AURL, ALogin, APassword, APath: STRING): TGestionNetEven;
PROCEDURE CloseNWSServer(ANWSToFree: TGestionNetEven);
FUNCTION ComputeSignature(ALogin, AStamp, ASeed, APassword: STRING): STRING;

implementation
 USES SysUtils,
  IdBaseComponent,
  IdGlobal,
  IdCoder,
  IdCoder3to4,
  IdCoderMIME,
  IdHashMessageDigest,
  RIO;

FUNCTION ComputeSignature(ALogin, AStamp, ASeed, APassword: STRING): STRING;
VAR
  sToCrypt, sMD5Crypted, sBase64Crypted: STRING;
  i: integer;
  Base64: TIdEncoderMIME;

  MD5Hash: TIdHashMessageDigest5; // FC Migration : Changement du calcul md5 unité n'était plus compatible
  LeHash : TIdBytes;
BEGIN
  Result := '';

  sToCrypt := UTF8Encode(ALogin + '/' + AStamp + '/' + ASeed + '/' + APassword);
  //  exemple : 'laurent@ekosport.fr/2009-11-18T16:22:48/MySeed/2fsarl73';

  // Hachage en MD5
  MD5Hash := TIdHashMessageDigest5.Create();
  try
    LeHash := MD5Hash.HashString(sToCrypt);

    sMD5Crypted := '';
    FOR i := 0 TO 15 DO
    BEGIN
      sMD5Crypted := sMD5Crypted + Chr(LeHash[i]);
    END;
  finally
    MD5Hash.Free;
  end;

  // Encodage en Base64
  Base64 := TIdEncoderMime.Create;
  TRY
    sBase64Crypted := Base64.Encode(sMD5Crypted);
  FINALLY
    Base64.Free;
  END;

  Result := sBase64Crypted;
END;

CONSTRUCTOR TGestionNetEven.Create(Owner: TComponent; AURL, ALogin, APassword, APath: STRING);
BEGIN
  INHERITED Create(Owner);

  FLogin := ALogin;
  FPassword := APassword;
  FURL := AURL;
  FPathSvg := APath;

  if FPathSvg <> '' then
  begin
    FPathSvg := IncludeTrailingPathDelimiter(FPathSvg) + FormatDateTime('yyyy\mm\dd\', Now);
    ForceDirectories(FPathSvg);
  end;

  FRIO := THTTPRio.Create(Self);
  FRIO.OnBeforeExecute := MyRioBeforeExecute;
  FRIO.OnAfterExecute := MyRioAfterExecute;

END;

DESTRUCTOR TGestionNetEven.Destroy;
BEGIN
  INHERITED;
END;

PROCEDURE TGestionNetEven.MyRioAfterExecute(CONST MethodName: STRING; SOAPResponse: TStream);
BEGIN
  IF (FPathSvg <> '') AND (FDoSaveFile) THEN
    TMemoryStream(SOAPResponse).SaveToFile(FFileNameR);
END;

PROCEDURE TGestionNetEven.MyRioBeforeExecute(CONST MethodName: STRING; SOAPRequest: TStream);
VAR
  bNotExist: Boolean;
  TS: TStringList;
BEGIN
  IF (FPathSvg <> '') AND (FDoSaveFile) THEN
  BEGIN
    REPEAT
      FHAppel := FormatDateTime('yyyymmddhhnnss', Now);
      FFileNameQ := IncludeTrailingPathDelimiter(FPathSvg) + FFonction + '_Request_' + FHAppel + '.xml';
      FFileNameR := IncludeTrailingPathDelimiter(FPathSvg) + FFonction + '_Response_' + FHAppel + '.xml';
      bNotExist := (NOT FileExists(FFileNameQ)) AND (NOT FileExists(FFileNameR));

      sleep(100);
    UNTIL bNotExist;
  END;

  IF FDoSaveFile THEN
  BEGIN
    TS := TStringList.Create;
    TRY
      TMemoryStream(SOAPRequest).SaveToFile(FFileNameQ);
      TS.LoadFromFile(FFileNameQ);
      TS.Text := StringReplace(TS.Text, #13#10, '', [rfIgnoreCase, rfReplaceAll]);
      TS.Text := StringReplace(TS.Text, '<?xml version="1.0"?>', '<?xml version="1.0" encoding="UTF-8"?>', [rfIgnoreCase, rfReplaceAll]);
      TS.SaveToFile(FFileNameQ);
    FINALLY
      TS.Free;
    END;
  END;

END;

FUNCTION TGestionNetEven.PostCommandes(ACdeIdWeb, ATypeRgl: Integer;
  ADateRegl, ADateEnvoi: TDateTime; ANumColis: STRING): String;

VAR
  sService: NWSServerPortType;

  rCdes: PostOrders; // Request
  aCdes: PostOrdersResponse; // Answer

  MyArray : ArrayOfMarketPlaceOrder;

BEGIN
  FFonction := 'PostOrders';
  FDoSaveFile := True;

  rCdes := PostOrders.Create;
  TRY
    //   (Accepted, Canceled, NonConformantAuthorization, NonConformantFormat, Rejected, UnexpectedInformation, Inserted, Updated, Error);

    sService := NWSServerPrepare(FURL, FLogin, FPassword, FRIO);


    SetLength(MyArray, 1);

    MyArray[0] := MarketPlaceOrder.Create;

    rCdes.Orders := MyArray;

    rCdes.Orders[0].OrderID := IntToStr(ACdeIdWeb);

    IF ADateRegl <> 0 THEN
    BEGIN
      IF (ATypeRgl < 0) OR (ATypeRgl > 4) THEN
        ATypeRgl := 3; // Other quand on sait pas ce que c'est

      rCdes.Orders[0].DatePayment := TXSDateTime.Create();
      rCdes.Orders[0].DatePayment.AsDateTime := ADateRegl;
      rCdes.Orders[0].PaymentMethod := PaymentMethodEnum(ATypeRgl);
    END;

    IF ADateEnvoi >= 0 THEN
    BEGIN
      rCdes.Orders[0].DateShipping := TXSDateTime.Create();

      IF ADateEnvoi = 0 THEN
        rCdes.Orders[0].DateShipping.XSToNative('')
      else
        rCdes.Orders[0].DateShipping.AsDateTime := ADateEnvoi;
        
      rCdes.Orders[0].TrackingNumber := ANumColis;
    END;

    aCdes := sService.PostOrders(rCdes);
    // (Accepted, Canceled, NonConformantAuthorization, NonConformantFormat, Rejected, UnexpectedInformation, Inserted, Updated, Error);
    CASE aCdes.PostOrdersResult[0].StatusResponse OF
      NetEvenWS.Accepted: Result := 'Accepted';
      NetEvenWS.Canceled: Result := 'Canceled';
      NetEvenWS.NonConformantAuthorization: Result := 'NCA';
      NetEvenWS.NonConformantFormat: Result := 'NCF';
      NetEvenWS.Rejected: Result := 'Rejected';
      NetEvenWS.UnexpectedInformation: Result := 'UnexpectedInformation';
      NetEvenWS.Inserted: Result := 'Inserted';
      NetEvenWS.Updated: Result := 'Updated';
      NetEvenWS.Error: Result := 'Error';
    END;

  FINALLY
    rCdes.Free;
  END;
END;

FUNCTION TGestionNetEven.ServerIsHere: Boolean;
VAR
  erTest: EchoRequestType;
  eaTest: EchoResponseType;

  sService: NWSServerPortType;
BEGIN
  FFonction := 'Echo';
  FDoSaveFile := False;

  erTest := EchoRequestType.Create;
  TRY
    erTest.EchoInput := ComputeSignature('Server', 'Are', 'You', 'Here');
    sService := NWSServerPrepare(FURL, FLogin, FPassword, FRIO);

    eaTest := sService.Echo(erTest);

    IF eaTest.EchoOutput = erTest.EchoInput THEN
      Result := True
    ELSE
      Result := False;

  FINALLY
    eaTest.Free;
    erTest.Free;
  END;
END;

FUNCTION TGestionNetEven.GetCommandes(DateDeb, DateFin: TDateTime; ACodeSite: integer;  ANumPage : integer = 1): GetOrdersResponse;
VAR
  rCdes: GetOrders;

  sService: NWSServerPortType;
BEGIN
  FFonction := 'GetOrders';
  FDoSaveFile := True;

  rCdes := GetOrders.Create;
  TRY
    sService := NWSServerPrepare(FURL, FLogin, FPassword, FRIO);

//    rCdes.DateCreationFrom := TXSDateTime.Create;
//    rCdes.DateCreationTo := TXSDateTime.Create;
//
//    rCdes.DateCreationFrom.AsDateTime := DateDeb;
//    rCdes.DateCreationTo.AsDateTime := DateFin;

    rCdes.PageNumber := IntToStr(ANumPage);

    rCdes.DateModificationFrom := TXSDateTime.Create;
    rCdes.DateModificationTo := TXSDateTime.Create;

    rCdes.DateModificationFrom.AsDateTime := DateDeb;
    rCdes.DateModificationTo.AsDateTime := DateFin;

    if ACodeSite <> 0 then
    begin
      rCdes.MarketPlaceId := IntToStr(ACodeSite);
    end;

    Result := sService.GetOrders(rCdes);
  FINALLY
    rCdes.Free;
  END;
END;

FUNCTION TGestionNetEven.TestConnection: STRING;
VAR
  rConnect: TestConnectionRequest;
  aConnect: TestConnectionResponse;

  sService: NWSServerPortType;
BEGIN
  FFonction := 'TestConnection';
  FDoSaveFile := False;

  rConnect := TestConnectionRequest.Create;
  TRY
    sService := NWSServerPrepare(FURL, FLogin, FPassword, FRIO);
    TRY
      aConnect := sService.TestConnection(rConnect);

      CASE aConnect.TestConnectionResult OF
        NetEvenWS.Accepted: Result := 'OK';
        NetEvenWS.Canceled: Result := 'Cancel';
        NetEvenWS.NonConformantAuthorization: Result := 'NCA';
        NetEvenWS.NonConformantFormat: Result := 'NCF';
        NetEvenWS.Rejected: Result := 'Reject';
        NetEvenWS.UnexpectedInformation: Result := 'Unexp';
        NetEvenWS.Error: Result := 'Error';
      ELSE Result := 'Else';
      END; // CASE
    EXCEPT
      Result := 'Error';
    END;
  FINALLY
    IF Assigned(aConnect) THEN
      aConnect.Free;
    IF Assigned(rConnect) THEN
      rConnect.Free;
  END;
END;

FUNCTION CreerNWSServer(AURL, ALogin, APassword, APath: STRING): TGestionNetEven;
BEGIN
  Result := TGestionNetEven.Create(NIL, AURL, ALogin, APassword, APath);
END;

PROCEDURE CloseNWSServer(ANWSToFree: TGestionNetEven);
BEGIN
  IF Assigned(ANWSToFree) THEN
    FreeAndNil(ANWSToFree);

  IF Assigned(MyHeader) THEN
    FreeAndNil(MyHeader);

END;

FUNCTION NWSServerPrepare(AURL, ALogin, APassword: STRING; ARIO: THTTPRIO): NWSServerPortType;
CONST
  defWSDL = 'http://ws2.neteven.com/NWS';
  defURL = 'http://ws2.neteven.com/NWS';
  defSvc = 'NWS';
  defPrt = 'NWSServerPortType';
VAR
  utcTime: SystemTime;
BEGIN
  Result := NIL;

  TRY
    IF AURL = '' THEN
      AURL := defWSDL;

    // URL et params divers
    ARIO.WSDLLocation := AURL;
    ARIO.Service := defSvc;
    ARIO.Port := defPrt;
    ARIO.URL := AURL;

    MyHeader := AuthenticationHeader.Create;
    MyHeader.Method := '*';
    MyHeader.Login := ALogin;
    MyHeader.Seed := 'MySeed';

    GetSystemTime(utcTime);
    MyHeader.Stamp := FormatDateTime('yyyy-mm-dd"T"hh:nn:ss', SystemTimeToDateTime(utcTime));
    MyHeader.Signature := ComputeSignature(MyHeader.Login, MyHeader.Stamp, MyHeader.Seed, APassword);

    (ARIO AS ISOAPHeaders).Send(MyHeader);

    Result := (ARIO AS NWSServerPortType);

//    MyHeader.Free;
  FINALLY

  END;
end;
end.
