
{****************************************************************************}
{                                                                            }
{ XMLComponents Library                                                      }
{                                                                            }
{ Copyright (c) 1999,2002 e-delos.com / XMLComponents. All rights reserved.  }
{ See license before use.                                                    }
{                                                                            }
{ http://xmlcomponents.com                                                   }
{ http://xmlrad.com                                                          }
{                                                                            }
{****************************************************************************}

unit SoapOperation;

interface

{$I XMLCLX.inc}

{$IFDEF NATIVE}
uses Classes,
  {$IFDEF MSWINDOWS}
    Windows, ComObj, XMLCOMApp_TLB,
  {$ENDIF}
  XMLClasses, StdXML_TLB, XMLHTTP;
{$ENDIF}
{$IFDEF CLR}
uses
  XMLCLX.Classes, //Borland.Vcl.Classes,
  XMLClasses,
	XMLCLX.StdXML_TLB, XMLCLX.XMLHTTP;
{$ENDIF}

type
{$IFDEF MSWINDOWS}
  TCustomSoapOperation = class(TAutoIntfObject, ISoapOperation)
{$ENDIF}
{$IFDEF LINUX}
  TCustomSoapOperation = class(TInterfacedObject, ISoapOperation)
	protected
    function GetTypeInfoCount(out Count: Integer): HResult; stdcall;
    function GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HResult; stdcall;
    function GetIDsOfNames(const IID: TGUID; Names: Pointer;
      NameCount, LocaleID: Integer; DispIDs: Pointer): HResult; stdcall;
    function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HResult; stdcall;
{$ENDIF}
{$IFDEF CLR}
  TCustomSoapOperation = class(TInterfacedObject, ISoapOperation)
{$ENDIF}
  protected
    FInputMessage: IXMLCursor;
    FInputParams: TWideStrings;
    FKeepNameSpaces: WordBool;
  	FMessage: WideString;
    FPrepared: WordBool;
    FSoapRequest: IXMLCursor;
    FOutputMessage: IXMLCursor;
  	FSoapAction: WideString;
    FSoapResponse: IXMLCursor;
    FWSDL: WideString;
    FResponse: WideString;
    FURL: WideString;
    procedure InternalExecute(const SoapRequest: WideString); virtual; abstract;
    procedure InternalPrepare; virtual; abstract;
	public
  	{ ISoapOperation }
    procedure Close; {$IFDEF MSWINDOWS} safecall; {$ENDIF}
    function EOF: WordBool; {$IFDEF MSWINDOWS} safecall; {$ENDIF}
    procedure Execute; {$IFDEF MSWINDOWS} safecall; {$ENDIF}
    function FieldCount: Integer; {$IFDEF MSWINDOWS} safecall; {$ENDIF}
    procedure First; {$IFDEF MSWINDOWS} safecall; {$ENDIF}
    function Get_InputMessage: IXMLCursor; {$IFDEF MSWINDOWS} safecall; {$ENDIF}
    function Get_KeepNameSpaces: WordBool; {$IFDEF MSWINDOWS} safecall; {$ENDIF}
  	function Get_Message: WideString; {$IFDEF MSWINDOWS} safecall; {$ENDIF}
    function Get_OutputMessage: IXMLCursor; {$IFDEF MSWINDOWS} safecall; {$ENDIF}
  	function Get_Password: WideString; virtual; {$IFDEF MSWINDOWS} safecall; {$ENDIF}
    function Get_Response: WideString; {$IFDEF MSWINDOWS} safecall; {$ENDIF}
		function Get_SoapAction: WideString; {$IFDEF MSWINDOWS} safecall; {$ENDIF}
    function Get_TimeOut: Integer; virtual; {$IFDEF MSWINDOWS} safecall; {$ENDIF}
  	function Get_URL: WideString; {$IFDEF MSWINDOWS} safecall; {$ENDIF}
  	function Get_UserName: WideString; virtual; {$IFDEF MSWINDOWS} safecall; {$ENDIF}
    function Get_Values(const Name: WideString): WideString; {$IFDEF MSWINDOWS} safecall; {$ENDIF}
    function GetFieldName(Index: Integer): WideString; {$IFDEF MSWINDOWS} safecall; {$ENDIF}
    function GetFieldAsString(const FieldName: WideString): WideString; {$IFDEF MSWINDOWS} safecall; {$ENDIF}
    function GetParamName(Index: Integer): WideString; {$IFDEF MSWINDOWS} safecall; {$ENDIF}
    function GetValue(const Name: WideString): WideString; {$IFDEF MSWINDOWS} safecall; {$ENDIF}
    function Get_WSDL: WideString; {$IFDEF MSWINDOWS} safecall; {$ENDIF}
    procedure Next; {$IFDEF MSWINDOWS} safecall; {$ENDIF}
    procedure Open; {$IFDEF MSWINDOWS} safecall; {$ENDIF}
    function ParamCount: Integer; {$IFDEF MSWINDOWS} safecall; {$ENDIF}
    procedure Prepare; {$IFDEF MSWINDOWS} safecall; {$ENDIF}
		function Prepared: WordBool; {$IFDEF MSWINDOWS} safecall; {$ENDIF}
    procedure Set_KeepNameSpaces(Value: WordBool); {$IFDEF MSWINDOWS} safecall; {$ENDIF}
    procedure Set_Message(const Value: WideString); {$IFDEF MSWINDOWS} safecall; {$ENDIF}
    procedure Set_Password(const Value: WideString); virtual; {$IFDEF MSWINDOWS} safecall; {$ENDIF}
    procedure Set_SoapAction(const Value: WideString); virtual; {$IFDEF MSWINDOWS} safecall; {$ENDIF}
    procedure Set_TimeOut(Value: Integer); virtual; {$IFDEF MSWINDOWS} safecall; {$ENDIF}
    procedure Set_URL(const Value: WideString); {$IFDEF MSWINDOWS} safecall; {$ENDIF}
    procedure Set_UserName(const Value: WideString); virtual; {$IFDEF MSWINDOWS} safecall; {$ENDIF}
    procedure Set_Values(const Name: WideString; const Value: WideString); {$IFDEF MSWINDOWS} safecall; {$ENDIF}
    procedure Set_WSDL(const Value: WideString); {$IFDEF MSWINDOWS} safecall; {$ENDIF}
    procedure SetParamAsString(const Name, Value: WideString); {$IFDEF MSWINDOWS} safecall; {$ENDIF}
    procedure Unprepare; {$IFDEF MSWINDOWS} safecall; {$ENDIF}
  public
    constructor Create; virtual;
    destructor Destroy; override;
  end;

  TSoapOperation = class(TCustomSoapOperation)
  private
    FXMLHTTP: TXMLHTTP;
  protected
    procedure InternalExecute(const SoapRequest: WideString); override;
    procedure InternalPrepare; override;
  public
  	function Get_Password: WideString; override; {$IFDEF MSWINDOWS} safecall; {$ENDIF}
    function Get_TimeOut: Integer; override; {$IFDEF MSWINDOWS} safecall; {$ENDIF}
  	function Get_UserName: WideString; override; {$IFDEF MSWINDOWS} safecall; {$ENDIF}
    procedure Set_Password(const Value: WideString); override; {$IFDEF MSWINDOWS} safecall; {$ENDIF}
    procedure Set_SoapAction(const Value: WideString); override; {$IFDEF MSWINDOWS} safecall; {$ENDIF}
    procedure Set_TimeOut(Value: Integer); override; {$IFDEF MSWINDOWS} safecall; {$ENDIF}
    procedure Set_UserName(const Value: WideString); override; {$IFDEF MSWINDOWS} safecall; {$ENDIF}

  public
    constructor Create; override;
    destructor Destroy; override; 
  end;

{$IFDEF NATIVE}
  TLibSoapFunc = function (SoapRequest: PChar): PChar; stdcall;

  TLibOperation = class(TCustomSoapOperation)
  private
    FLibHandle: THandle;
    FLibSoapFunc: TLibSoapFunc;
  protected
    procedure InternalExecute(const SoapRequest: WideString); override;
    procedure InternalPrepare; override;
  public
    destructor Destroy; override;
  end;
{$ENDIF}

{$IFDEF MSWINDOWS}
  TCOMOperation = class(TCustomSoapOperation)
  private
    FCOMApp: IXMLCOMApp;
  protected
    procedure InternalExecute(const SoapRequest: WideString); override;
    procedure InternalPrepare; override;
  public
    destructor Destroy; override;
  end;
{$ENDIF}

implementation

{$IFDEF NATIVE}
uses
  {$IFDEF MSWINDOWS}
    ActiveX,  
  {$ENDIF}
  {$IFDEF LINUX}
    Libc,
  {$ENDIF}
  SysUtils,
	XMLCursor;
{$ENDIF}
{$IFDEF CLR}
uses
	Borland.Vcl.SysUtils,
	XMLCLX.XMLCursor;
{$ENDIF}

function PosEx(const SubStr, S: WideString; Offset: Cardinal): Integer;
var
  I,X: Integer;
  Len, LenSubStr: Integer;
begin
  if Offset = 1 then
    Result := Pos(SubStr, S)
  else
  begin
    I := Offset;
    LenSubStr := Length(SubStr);
    Len := Length(S) - LenSubStr + 1;
    while I <= Len do
    begin
      if S[I] = SubStr[1] then
      begin
        X := 1;
        while (X < LenSubStr) and (S[I + X] = SubStr[X + 1]) do
          Inc(X);
        if (X = LenSubStr) then
        begin
          Result := I;
          Exit;
        end;
      end;
      Inc(I);
    end;
    Result := 0;
  end;
end;

{$IFDEF MSWINDOWS}
var
  StdXMLTypeLib: ITypeLib = nil;

function GetStdXMLTypeLib: ITypeLib;
resourcestring
	StdXMLTLB = 'StdXML.tlb';
var
  AppFileName: string;
  StdXMLTLBPath: WideString;
begin
  if StdXMLTypeLib = nil then
  begin
  	// Check if StdXML.tlb is in the application directory
    SetLength(AppFileName, MAX_PATH);
    SetLength(AppFileName, GetModuleFileName(hInstance, PChar(AppFileName), MAX_PATH));
    StdXMLTLBPath := ExtractFilePath(AppFileName)+StdXMLTLB;
    if not FileExists(StdXMLTLBPath) then
			StdXMLTLBPath := StdXMLTLB;
		OleCheck(LoadTypeLib(PWideChar(WideString(StdXMLTLB)), StdXMLTypeLib));
  end;
  Result := StdXMLTypeLib;
end;
{$ENDIF}
  
// -----------------------------------------------------------------------------
// TCustomSoapOperation
// -----------------------------------------------------------------------------

constructor TCustomSoapOperation.Create;
begin
{$IFDEF MSWINDOWS}
  inherited Create(GetStdXMLTypeLib, ISoapOperation);
{$ENDIF}
{$IFDEF LINUX}
  inherited;
{$ENDIF}
{$IFDEF CLR}
  inherited;
{$ENDIF}
  FInputParams := TWideStrings.Create;
  FKeepNameSpaces := True;
end;

destructor TCustomSoapOperation.Destroy;
begin
	Unprepare;
  FInputParams.Free;
  inherited;
end;

{$IFDEF LINUX}
function TCustomSoapOperation.GetIDsOfNames(const IID: TGUID; Names: Pointer;
  NameCount, LocaleID: Integer; DispIDs: Pointer): HResult;
begin
	Result := E_NOTIMPL;
end;

function TCustomSoapOperation.GetTypeInfo(Index, LocaleID: Integer;
  out TypeInfo): HResult;
begin
	Result := E_NOTIMPL;
end;

function TCustomSoapOperation.GetTypeInfoCount(out Count: Integer): HResult;
begin
	Result := E_NOTIMPL;
end;

function TCustomSoapOperation.Invoke(DispID: Integer; const IID: TGUID;
  LocaleID: Integer; Flags: Word; var Params; VarResult, ExcepInfo,
  ArgErr: Pointer): HResult;
begin
	Result := E_NOTIMPL;
end;
{$ENDIF}

procedure TCustomSoapOperation.Close;
begin
	FResponse := '';
	FSoapResponse := nil;
  FOutputMessage := nil;
end;

function TCustomSoapOperation.EOF: WordBool;
begin
	if FOutputMessage = nil then
  	raise Exception.Create('TCustomSoapOperation.EOF - OutputMessage is nil');
	Result := FOutputMessage.EOF;
end;

function TranslateStrToStr(const S, OldPattern, NewPattern: WideString): WideString;
var
  SearchStr, Patt, NewStr: WideString;
  Offset: Integer;
begin
  SearchStr := WideUpperCase(S);
  Patt := WideUpperCase(OldPattern);
  NewStr := S;
  Result := '';
  while SearchStr <> '' do
  begin
    Offset := Pos(Patt, SearchStr);
    if Offset = 0 then
    begin
      Result := Result + NewStr;
      Break;
    end;
    Result := Result + Copy(NewStr, 1, Offset - 1) + NewPattern;
    NewStr := Copy(NewStr, Offset + Length(OldPattern), MaxInt);
    SearchStr := Copy(SearchStr, Offset + Length(Patt), MaxInt);
  end;
end;


procedure TCustomSoapOperation.Execute;

  function CleanNameSpaces(Response: WideString): WideString;
  var
  	Pos1: Integer;
    NameSpace: WideString;
  begin
  	Result := Response;
    while True do
    begin
      Pos1 := Pos('xmlns:', Response);
      if Pos1 = 0 then
        Exit;
      Delete(Response, 1, Pos1+Length('xmlns:')-1);
      Pos1 := Pos('=', Response);
      if Pos1 = 0 then
      	Exit;
			NameSpace := Copy(Response, 1, Pos1-1);
      if NameSpace <> 'SOAP-ENV' then
	      Result := TranslateStrToStr(Result, NameSpace+':', '');
      Delete(Response, 1, Pos1);
    end;
  end;

  function PurgeCRLF(const S: WideString): WideString;
  var
  	I: Integer;
  begin
  	Result := S;
    I := 1;
		while I <= Length(Result) do
    begin
    	if (Result[I] = #13) or	(Result[I] = #10) or (Result[I] = #9) then
      begin
	      {$IFDEF NATIVE} System.Delete(Result, I, 1); {$ENDIF}
	      {$IFDEF CLR} Delete(Result, I, 1); {$ENDIF}
      end
      else
	      Inc(I);
    end;
  end;

  FUNCTION xmlns ( Requete: WideString): WideString;
  var pos1:integer;
  begin
     Result := Requete;
     Pos1 := Pos('getMessageElement xmlns=""', Result);
     Delete(Result, Pos1, 26);
     insert('getMessageElement',result,pos1);
  END;


  function PurgeResponse(const S: WideString): WideString;
  var
  	Pos1, Pos2: Integer;
  begin
  	Result := S;
    Pos1 := Pos('<?', Result);
    Pos2 := Pos('?>', Result);
    if (Pos1 <> 0) and (Pos2 <> 0) then
    begin
	    {$IFDEF NATIVE} System.Delete(Result, Pos1, Pos2 - Pos1 + 2); {$ENDIF}
	    {$IFDEF CLR} Delete(Result, Pos1, Pos2 - Pos1 + 2); {$ENDIF}
    end;
  end;

var
	FaultCode, FaultString: WideString;
  SSoapRequest: WideString;
begin
	if not FPrepared then
  	raise Exception.Create('TCustomSoapOperation.Execute - SoapOperation not prepared');
	if FSoapRequest = nil then
  	raise Exception.Create('TCustomSoapOperation.Execute - SoapRequest is nil');
  SSoapRequest := FSoapRequest.XML;
  SSoapRequest := PurgeCRLF(SSoapRequest);
  ssoapRequest :=xmlns(  ssoapRequest);
//  if XMLC_TraceVerbose then Eventlog.TraceVerbose(nil, 'TCustomSoapOperation', 'SoapRequest: '+SSoapRequest);
  InternalExecute(SSoapRequest);
//  if XMLC_TraceVerbose then Eventlog.TraceVerbose(nil, 'TCustomSoapOperation', 'SoapResponse: '+FResponse);
  if FKeepNameSpaces = False then
	  FResponse := CleanNameSpaces(FResponse);
  FResponse := PurgeResponse(FResponse);
//  if XMLC_TraceVerbose then Eventlog.TraceVerbose(nil, 'TCustomSoapOperation', 'SoapResponse purged: '+FResponse);
  FSoapResponse := TXMLCursor.Create;
  FSoapResponse.LoadXML(FResponse);
//  FOutputMessage := FSoapResponse.Select('/SOAP-ENV:Envelope/SOAP-ENV:Body/*'); // KW 20030506
  FOutputMessage := FSoapResponse.Select('*');
  FOutputMessage := FOutputMessage.Select('*');
  if FOutputMessage.EOF then
  begin
		// it may be a .Net Soap response where elements are not prefixed by SOAP-ENV namespace
	  FOutputMessage := FSoapResponse.Select('/Envelope/Body/*');
  end;
  if FOutputMessage.GetName = 'SOAP-ENV:Fault' then
  begin
		FaultCode := FOutputMessage.GetValue('SOAP-ENV:faultcode');
		FaultString := FOutputMessage.GetValue('SOAP-ENV:faultstring');
    if FaultCode = '' then
    begin
  		FaultCode := FOutputMessage.GetValue('faultcode');
	  	FaultString := FOutputMessage.GetValue('faultstring');
    end;
    raise Exception.Create(FaultString);
  end;
  if FOutputMessage.GetName = 'Fault' then
  begin
		// it may be a .Net Soap response where elements are not prefixed by SOAP-ENV namespace
		FaultCode := FOutputMessage.GetValue('faultcode');
		FaultString := FOutputMessage.GetValue('faultstring');
    raise Exception.Create(FaultString);
  end;
end;

function TCustomSoapOperation.FieldCount: Integer;
var
	Fields: IXMLCursor;
begin
	if FOutputMessage = nil then
  	raise Exception.Create('TCustomSoapOperation.FieldCount - OutputMessage is nil');
  Fields := FOutputMessage.Select('*');
  Result := Fields.Count;
end;

procedure TCustomSoapOperation.First;
begin
	if FOutputMessage = nil then
  	raise Exception.Create('TCustomSoapOperation.First - OutputMessage is nil');
	FOutputMessage.First;
end;

function TCustomSoapOperation.Get_InputMessage: IXMLCursor;
begin
	Result := FInputMessage;
end;

function TCustomSoapOperation.Get_KeepNameSpaces: WordBool;
begin
	Result := FKeepNameSpaces;
end;

function TCustomSoapOperation.Get_Message: WideString;
begin
	Result := FMessage;
end;

function TCustomSoapOperation.Get_OutputMessage: IXMLCursor;
begin
	Result := FOutputMessage;
end;

function TCustomSoapOperation.Get_Password: WideString;
begin
	Result := '';
end;

function TCustomSoapOperation.Get_Response: WideString;
begin
	Result := FResponse;
end;

function TCustomSoapOperation.Get_SoapAction: WideString;
begin
	Result := FSoapAction;
end;

function TCustomSoapOperation.Get_TimeOut: Integer;
begin
	Result := 0;                               
end;

function TCustomSoapOperation.GetValue(const Name: WideString): WideString;
begin
	if not FPrepared then
  	raise Exception.Create('TCustomSoapOperation.GetValue - SoapOperation not prepared');
	if FSoapResponse = nil then
  	raise Exception.Create('TCustomSoapOperation.GetValue - SoapResponse is nil');
	if FOutputMessage = nil then
  	raise Exception.Create('TCustomSoapOperation.GetValue - OutputMessage is nil');
	if FOutputMessage.EOF then
  	raise Exception.Create('TCustomSoapOperation.GetValue - OutputMessage is empty');
  Result := FOutputMessage.GetValue(Name);
end;

function TCustomSoapOperation.Get_Values(const Name: WideString): WideString;
begin
	Result := GetValue(Name);
end;

function TCustomSoapOperation.Get_URL: WideString;
begin
	Result := FURL;
end;

function TCustomSoapOperation.Get_UserName: WideString;
begin
	Result := '';
end;

function TCustomSoapOperation.GetFieldName(Index: Integer): WideString;
var
	Fields: IXMLCursor;
begin
	if FOutputMessage = nil then
  	raise Exception.Create('TCustomSoapOperation.Next - OutputMessage is nil');
  Fields := FOutputMessage.Select('*');
  Fields.MoveTo(Index);
  if Fields.EOF then
  	raise Exception.Create('TCustomSoapOperation.GetFieldName - Index out of range ['+IntToStr(Index)+']');
  Result := Fields.GetName;
end;

function TCustomSoapOperation.GetFieldAsString(const FieldName: WideString): WideString;
begin
	Result := GetValue(FieldName);
end;

function TCustomSoapOperation.GetParamName(Index: Integer): WideString;
begin
	if not FPrepared then
  	raise Exception.Create('TCustomSoapOperation.GetParamName - SoapOperation not prepared');
	if FWSDL = '' then
  	raise Exception.Create('TCustomSoapOperation.GetParamName - WSDL is blank');
  Result := FInputParams.Names[Index];
end;

function TCustomSoapOperation.Get_WSDL: WideString;
begin
	Result := FWSDL;
end;

procedure TCustomSoapOperation.Next;
begin
	if FOutputMessage = nil then
  	raise Exception.Create('TCustomSoapOperation.Next - OutputMessage is nil');
	FOutputMessage.Next;
end;

procedure TCustomSoapOperation.Open;
begin
	Execute;
  FOutputMessage := FOutputMessage.Select('*');
end;

function TCustomSoapOperation.ParamCount: Integer;
begin
	if not FPrepared then
  	raise Exception.Create('TCustomSoapOperation.ParamCount - SoapOperation not prepared');
	if FWSDL = '' then
  	raise Exception.Create('TCustomSoapOperation.ParamCount - WSDL is blank');
  Result := FInputParams.Count;
end;

procedure TCustomSoapOperation.Prepare;
resourcestring
  EBlankMessage = 'Message cannot be blank.';
resourcestring
 // SXMLSOAPEnvelope = '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns="urn:soap.FideS.fr"/>';
   SXMLSOAPEnvelope = '<soapenv:Envelope xmlns="urn:soap.FideS.fr" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"/>';

	SSOAPHeader = 'soapenv:Header'; //'SOAP-ENV:Header';
	SSOAPBody = 'soapenv:Body'; //'SOAP-ENV:Body';
var
	SoapBody: IXMLCursor;
begin
	if FPrepared then
  	Exit;
  if FMessage = '' then
  	raise Exception.Create(EBlankMessage);
	FSoapRequest := TXMLCursor.Create;
  FSoapRequest.LoadXML(SXMLSOAPEnvelope);
  SoapBody := FSoapRequest.AppendChild(SSOAPBody, '');
  FInputMessage := SoapBody.AppendChild(FMessage, '');
  InternalPrepare;
	FPrepared := True;
end;

function TCustomSoapOperation.Prepared: WordBool;
begin
	Result := FPrepared;
end;

procedure TCustomSoapOperation.Set_KeepNameSpaces(Value: WordBool);
begin
	FKeepNameSpaces := Value;	
end;

procedure TCustomSoapOperation.Set_Message(const Value: WideString);
begin
  Unprepare;
	FMessage := Value;
end;

procedure TCustomSoapOperation.Set_Password(const Value: WideString);
begin
end;

procedure TCustomSoapOperation.SetParamAsString(const Name, Value: WideString);
begin
	if not FPrepared then
  	Prepare;
  if FInputMessage = nil then
  	raise Exception.Create('TCustomSoapOperation.SetParamAsString - InputMessage is nil');
  FInputMessage.SetValue(Name, Value);
end;

procedure TCustomSoapOperation.Set_SoapAction(const Value: WideString);
begin
	if FSoapAction = Value then
  	Exit;
	FSoapAction := Value;
end;

procedure TCustomSoapOperation.Set_TimeOut(Value: Integer);
begin
end;

procedure TCustomSoapOperation.Set_URL(const Value: WideString);
begin
	FURL := Value;
end;

procedure TCustomSoapOperation.Set_UserName(const Value: WideString);
begin
end;

procedure TCustomSoapOperation.Set_Values(const Name: WideString; const Value: WideString);
begin
	SetParamAsString(Name, Value);
end;

procedure TCustomSoapOperation.Set_WSDL(const Value: WideString);
begin
	FWSDL := Value;
end;

procedure TCustomSoapOperation.Unprepare;
begin
	FSoapRequest := nil;
  FInputMessage := nil;
  FSoapResponse := nil;
  FOutputMessage := nil;
  FPrepared := False;
end;

// -----------------------------------------------------------------------------
// TSoapOperation
// -----------------------------------------------------------------------------

constructor TSoapOperation.Create;
begin
  inherited;
  FXMLHTTP := TXMLHTTP.Create;
end;

destructor TSoapOperation.Destroy;
begin
	FXMLHTTP.Free;
  FXMLHTTP := nil;
  inherited;
end;

function TSoapOperation.Get_Password: WideString;
begin
	Result := FXMLHTTP.Password;
end;

function TSoapOperation.Get_TimeOut: Integer;
begin
	Result := FXMLHTTP.TimeOut;
end;

function TSoapOperation.Get_UserName: WideString;
begin
	Result := FXMLHTTP.UserName;
end;

function CleanDefaultNameSpace(const Response: WideString): WideString;
var
  Pos1, Pos2: Integer;
begin
  Result := Response;
  while True do
  begin
    Pos1 := Pos('xmlns="', Result);
    if Pos1 = 0 then
      Exit;
    Pos2 := PosEx('"', Result, Pos1 + Length('xmlns="'));
    Delete(Result, Pos1, Pos2-Pos1+1);
  end;
end;






procedure TSoapOperation.InternalExecute(const SoapRequest: WideString);
begin
  FXMLHTTP.PostData.Text := SoapRequest;
  try
  	FResponse := FXMLHTTP.Post(FURL);
  except on E: Exception do
    raise Exception.CreateFmt('TSoapOperation.Execute - Cannot invoke http action (URL=%s) ' + E.Message, [FURL]);
  end;
end;

procedure TSoapOperation.InternalPrepare;
var
	ParamName, ParamType: WideString;
	Response: WideString;
  WSDLResponse: IXMLCursor;
  WSDLMessage: IXMLCursor;
  Parts: IXMLCursor;
begin
  FXMLHTTP.Headers.Clear;
  FXMLHTTP.Headers.Text := 'Content-Type: text/xml'#13#10'SOAPAction: "'+FSoapAction+'"';
  if FWSDL = '' then
    Exit;
  Response := SimpleGet(FWSDL);
  if Trim(Response) = '' then
    raise Exception.Create('TCustomSoapOperation.Prepare - Cannot retrieve WDSL');
  WSDLResponse := TXMLCursor.Create;
  Response := CleanDefaultNameSpace(Response);
  WSDLResponse.LoadXML(Response);
  WSDLMessage := WSDLResponse.Select('message[@name="'+FMessage+'"]');
  if WSDLMessage.EOF then
    raise Exception.Create('TCustomSoapOperation.Prepare - Cannot locate message '+FMessage+' in WSDL');
  Parts := WSDLMessage.Select('part');
  while not Parts.EOF do
  begin
    ParamName := Parts.GetValue('@name');
    ParamType := Parts.GetValue('@type');
    FInputParams.Add(ParamName+'='+ParamType);
    Parts.Next;
  end;
end;

procedure TSoapOperation.Set_Password(const Value: WideString);
begin
	FXMLHTTP.Password := Value;
end;

procedure TSoapOperation.Set_SoapAction(const Value: WideString);
begin
  inherited;
  FXMLHTTP.Headers.Clear;
  FXMLHTTP.Headers.Text := 'Content-Type: text/xml'#13#10'SOAPAction: "'+FSoapAction+'"';
end;

procedure TSoapOperation.Set_TimeOut(Value: Integer);
begin
	FXMLHTTP.TimeOut := Value;
end;

procedure TSoapOperation.Set_UserName(const Value: WideString);
begin
	FXMLHTTP.UserName := Value;
end;

// -----------------------------------------------------------------------------
// TLibOperation
// -----------------------------------------------------------------------------

{$IFDEF NATIVE}
destructor TLibOperation.Destroy;
begin
  if FLibHandle <> 0 then
    FreeLibrary(FLibHandle);
  inherited;
end;

procedure TLibOperation.InternalExecute(const SoapRequest: Widestring);
var
  SSoapRequest: string;
begin
  if not Assigned(FLibSoapFunc) then
    Exit;
  SSoapRequest := SoapRequest;
  FResponse := FLibSoapFunc(PChar(SSoapRequest));
end;

procedure TLibOperation.InternalPrepare;
var
  SURL: string;
  Func: string;
begin
  SURL := FURL;
  FLibHandle := LoadLibrary(PChar(SURL));
  if FLibHandle = 0 then
    raise Exception.Create('Cannot load ' + SURL);
  Func := FSoapAction;
  FLibSoapFunc := GetProcAddress(FLibHandle, PChar(Func));
  if not Assigned(FLibSoapFunc) then
    raise Exception.Create('Cannot find function ' + Func + ' in ' + SURL);
end;
{$ENDIF}

// -----------------------------------------------------------------------------
// TComOperation
// -----------------------------------------------------------------------------

{$IFDEF MSWINDOWS}
destructor TComOperation.Destroy;
begin
  FCOMApp := nil;
  inherited;
end;

procedure TComOperation.InternalExecute(const SoapRequest: WideString);
var
  ClassID: TCLSID;
  Obj: IUnknown;
begin
  try
    ClassID := ProgIDToClassID(FURL);
  except
    ClassID := StringToGUID(FURL);
  end;
  Obj := CreateComObject(ClassID);
  FCOMApp := Obj as IXMLCOMApp;
  FResponse := FCOMApp.Invoke(SoapRequest);
  FCOMApp := nil;  // Reset COMApp if KeepConnection = False
end;

procedure TComOperation.InternalPrepare;
begin
  // connect to COM server if KeepConnection = True
end;
{$ENDIF}

end.

