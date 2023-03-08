unit StdXML_TLB;

{ This file contains pascal declarations imported from a type library.
  This file will be written during each import or refresh of the type
  library editor.  Changes to this file will be discarded during the
  refresh process. }

{ XMLComponents Framework Library }
{ Version 1.0 }

interface

{$IFNDEF MSWINDOWS}
	{$IFDEF WIN32}
		{$DEFINE MSWINDOWS}
  {$ENDIF}
{$ENDIF}

uses
	Classes,
{$IFDEF MSWINDOWS}
	Windows, ActiveX, Graphics, OleCtrls,
  StdVCL,
{$ENDIF}
  DAC_TLB;

const
  LIBID_StdXML: TGUID = '{18537E00-2B5A-11D5-88C0-0060087D03E0}';

type

{ Forward declarations: Interfaces }
  IXMLContext = interface;
  IXMLContextDisp = dispinterface;
  IXMLCursor = interface;
  IXMLCursorDisp = dispinterface;
  IXSLProc = interface;
  IXSLProcDisp = dispinterface;
  IXMLCache = interface;
  IXMLCacheDisp = dispinterface;
  IXMLRequest = interface;
  IXMLRequestDisp = dispinterface;
  IXMLCollection = interface;
  IXMLCollectionDisp = dispinterface;
  IXMLService = interface;
  IXMLServiceDisp = dispinterface;
  IXMLGram = interface;
  IXMLGramDisp = dispinterface;
  IXMLInstruction = interface;
  IXMLInstructionDisp = dispinterface;
  IXMLApplication = interface;
  IXMLApplicationDisp = dispinterface;
  IXMLGenerator = interface;
  IXMLGeneratorDisp = dispinterface;
  ISoapOperation = interface;
  ISoapOperationDisp = dispinterface;

{ Context while processing HTTP request }

  IXMLContext = interface(IDispatch)
    ['{18537E02-2B5A-11D5-88C0-0060087D03E0}']
    procedure Assign(const Context: IXMLContext); safecall;
    procedure AssignValues(const Values: IXMLContext); safecall;
    procedure Clear; safecall;
    function Clone: IXMLContext; safecall;
    function GetName(Index: Integer): WideString; safecall;
    function GetObjectReference: Integer; safecall;
    function GetValue(const Name: WideString): WideString; safecall;
    function GetValueNo(Index: Integer): WideString; safecall;
    function GetXML(const RootElement: WideString): WideString; safecall;
    function IndexOfName(const Name: WideString): Integer; safecall;
    procedure SetValue(const Name, Value: WideString); safecall;
    function Get_CommaText: WideString; safecall;
    procedure Set_CommaText(const Value: WideString); safecall;
    function Get_Count: Integer; safecall;
    function Get_Text: WideString; safecall;
    procedure Set_Text(const Value: WideString); safecall;
    function Get_Values(const Name: WideString): WideString; safecall;
    procedure Set_Values(const Name: WideString; const Value: WideString); safecall;
    property CommaText: WideString read Get_CommaText write Set_CommaText;
    property Count: Integer read Get_Count;
    property Text: WideString read Get_Text write Set_Text;
    property Values[const Name: WideString]: WideString read Get_Values write Set_Values;
  end;

{ DispInterface declaration for Dual Interface IXMLContext }

  IXMLContextDisp = dispinterface
    ['{18537E02-2B5A-11D5-88C0-0060087D03E0}']
    procedure Assign(const Context: IXMLContext); dispid 1;
    procedure AssignValues(const Values: IXMLContext); dispid 2;
    procedure Clear; dispid 3;
    function Clone: IXMLContext; dispid 4;
    function GetName(Index: Integer): WideString; dispid 7;
    function GetObjectReference: Integer; dispid 8;
    function GetValue(const Name: WideString): WideString; dispid 10;
    function GetValueNo(Index: Integer): WideString; dispid 11;
    function GetXML(const RootElement: WideString): WideString; dispid 12;
    function IndexOfName(const Name: WideString): Integer; dispid 13;
    procedure SetValue(const Name, Value: WideString); dispid 16;
    property CommaText: WideString dispid 18;
    property Count: Integer readonly dispid 19;
    property Text: WideString dispid 21;
    property Values[const Name: WideString]: WideString dispid 5;
  end;

{ XMLCursor interfaces DOM Document }

  IXMLCursor = interface(IDispatch)
    ['{18537E03-2B5A-11D5-88C0-0060087D03E0}']
    function AppendChild(const ElementName, Value: WideString): IXMLCursor; safecall;
    procedure AppendXMLCursor(const XMLCursor: IXMLCursor); safecall;
    function ContainerXML: WideString; safecall;
    function Count: Integer; safecall;
    procedure Delete; safecall;
    function Document: IXMLCursor; safecall;
    function EOF: WordBool; safecall;
    procedure First; safecall;
    function GetName: WideString; safecall;
    function GetValue(const XPath: WideString): WideString; safecall;
    function InsertBefore(const ElementName, Value: WideString): IXMLCursor; safecall;
    function InsertAfter(const ElementName, Value: WideString): IXMLCursor; safecall;
    procedure Last; safecall;
    procedure Load(const FileName: WideString); safecall;
    procedure LoadXML(const XMLString: WideString); safecall;
    procedure MoveTo(Index: Integer); safecall;
    procedure Next; safecall;
    function RecNo: Integer; safecall;
    procedure ReplaceWithXMLCursor(const XMLCursor: IXMLCursor); safecall;
    procedure Save(const FileName: WideString); safecall;
    function Select(const XPath: WideString): IXMLCursor; safecall;
    procedure SetAttributeValue(const AttributeName, Value: WideString); safecall;
    procedure SetValue(const ElementName, Value: WideString); safecall;
    procedure SetCValue(const ElementName, Value: WideString); safecall;
    function XML: WideString; safecall;
    function XMLDOMDocument: IUnknown; safecall;
    function XMLDOMNode: IUnknown; safecall;
    function Get_Values(const Name: WideString): WideString; safecall;
    procedure Set_Values(const Name: WideString; const Value: WideString); safecall;
    property Values[const Name: WideString]: WideString read Get_Values write Set_Values;
  end;

{ DispInterface declaration for Dual Interface IXMLCursor }

  IXMLCursorDisp = dispinterface
    ['{18537E03-2B5A-11D5-88C0-0060087D03E0}']
    function AppendChild(const ElementName, Value: WideString): IXMLCursor; dispid 1;
    procedure AppendXMLCursor(const XMLCursor: IXMLCursor); dispid 2;
    function ContainerXML: WideString; dispid 3;
    function Count: Integer; dispid 4;
    procedure Delete; dispid 6;
    function Document: IXMLCursor; dispid 7;
    function EOF: WordBool; dispid 8;
    procedure First; dispid 9;
    function GetName: WideString; dispid 10;
    function GetValue(const XPath: WideString): WideString; dispid 11;
    function InsertBefore(const ElementName, Value: WideString): IXMLCursor; dispid 12;
    function InsertAfter(const ElementName, Value: WideString): IXMLCursor; dispid 13;
    procedure Last; dispid 14;
    procedure Load(const FileName: WideString); dispid 15;
    procedure LoadXML(const XMLString: WideString); dispid 16;
    procedure MoveTo(Index: Integer); dispid 17;
    procedure Next; dispid 18;
    function RecNo: Integer; dispid 19;
    procedure ReplaceWithXMLCursor(const XMLCursor: IXMLCursor); dispid 20;
    procedure Save(const FileName: WideString); dispid 21;
    function Select(const XPath: WideString): IXMLCursor; dispid 22;
    procedure SetAttributeValue(const AttributeName, Value: WideString); dispid 23;
    procedure SetValue(const ElementName, Value: WideString); dispid 24;
    procedure SetCValue(const ElementName, Value: WideString); dispid 25;
    function XML: WideString; dispid 26;
    function XMLDOMDocument: IUnknown; dispid 27;
    function XMLDOMNode: IUnknown; dispid 28;
    property Values[const Name: WideString]: WideString dispid 5;
  end;

  IXSLProc = interface(IDispatch)
    ['{18537E04-2B5A-11D5-88C0-0060087D03E0}']
    function IsUpToDate: WordBool; safecall;
    procedure Load(const AFileName: WideString); safecall;
    function Process(const Document: IXMLCursor): WideString; safecall;
  end;

{ DispInterface declaration for Dual Interface IXSLProc }

  IXSLProcDisp = dispinterface
    ['{18537E04-2B5A-11D5-88C0-0060087D03E0}']
    function IsUpToDate: WordBool; dispid 1;
    procedure Load(const AFileName: WideString); dispid 2;
    function Process(const Document: IXMLCursor): WideString; dispid 3;
  end;

{ Caching List }

  IXMLCache = interface(IDispatch)
    ['{18537E06-2B5A-11D5-88C0-0060087D03E0}']
    procedure AddObject(const Name: WideString; Version: Integer; Unknown: IUnknown); safecall;
    procedure Clear; safecall;
    function GetObject(const Name: WideString): IUnknown; safecall;
    function GetObjectNo(Index: Integer): IUnknown; safecall;
    function GetVersion(const Name: WideString): Integer; safecall;
    procedure RemoveObject(const Name: WideString); safecall;
    procedure RemoveObjectNo(Index: Integer); safecall;
    function Get_Count: Integer; safecall;
    property Count: Integer read Get_Count;
  end;

{ DispInterface declaration for Dual Interface IXMLCache }

  IXMLCacheDisp = dispinterface
    ['{18537E06-2B5A-11D5-88C0-0060087D03E0}']
    procedure AddObject(const Name: WideString; Version: Integer; Unknown: IUnknown); dispid 1;
    procedure Clear; dispid 2;
    function GetObject(const Name: WideString): IUnknown; dispid 3;
    function GetObjectNo(Index: Integer): IUnknown; dispid 4;
    function GetVersion(const Name: WideString): Integer; dispid 5;
    procedure RemoveObject(const Name: WideString); dispid 6;
    procedure RemoveObjectNo(Index: Integer); dispid 7;
    property Count: Integer readonly dispid 8;
  end;

{ Inrefaces HTTP server }

  IXMLRequest = interface(IDispatch)
    ['{18537E07-2B5A-11D5-88C0-0060087D03E0}']
    procedure AddCookie(const Name, Value, Domain, Path: WideString; Expires: TDateTime); safecall;
    procedure CheckSupervisor(const ActionName: WideString); safecall;
    function GetCallStack: WideString; safecall;
    function GetCookie(const Name: WideString): WideString; safecall;
    function GetErrorLog: WideString; safecall;
    function GetFileNo(Index: Integer): WideString; safecall;
    function GetFileCount: Integer; safecall;
    function GetFileName(Index: Integer): WideString; safecall;
    procedure InsertError(const Value: WideString); safecall;
    function IsKilled: WordBool; safecall;
    procedure Kill; safecall;
    procedure LogError(const Value: WideString); safecall;
    procedure RestoreContext; safecall;
    procedure SaveContext; safecall;
    procedure SendRedirect(const URI: WideString); safecall;
    procedure SetContent(const Value: WideString); safecall;
    procedure SetContentStream(Stream: Integer); safecall;
    procedure SetContentType(const Value: WideString); safecall;
    procedure SetCookie(const Name, Value: WideString); safecall;
    procedure SetCustomHeader(const Name, Value: WideString); safecall;
    procedure SetDate(Value: TDateTime); safecall;
    procedure SetExpires(Value: TDateTime); safecall;
    procedure SendResponse; safecall;
    procedure Stack(const MethodName: WideString); safecall;
    procedure Unstack; safecall;
    procedure WriteString(const S: WideString); safecall;
    function Get_Context: IXMLContext; safecall;
    property Context: IXMLContext read Get_Context;
  end;

{ DispInterface declaration for Dual Interface IXMLRequest }

  IXMLRequestDisp = dispinterface
    ['{18537E07-2B5A-11D5-88C0-0060087D03E0}']
    procedure AddCookie(const Name, Value, Domain, Path: WideString; Expires: TDateTime); dispid 1;
    procedure CheckSupervisor(const ActionName: WideString); dispid 2;
    function GetCallStack: WideString; dispid 3;
    function GetCookie(const Name: WideString): WideString; dispid 4;
    function GetErrorLog: WideString; dispid 5;
    function GetFileNo(Index: Integer): WideString; dispid 6;
    function GetFileCount: Integer; dispid 7;
    function GetFileName(Index: Integer): WideString; dispid 8;
    procedure InsertError(const Value: WideString); dispid 9;
    function IsKilled: WordBool; dispid 10;
    procedure Kill; dispid 11;
    procedure LogError(const Value: WideString); dispid 12;
    procedure RestoreContext; dispid 13;
    procedure SaveContext; dispid 14;
    procedure SendRedirect(const URI: WideString); dispid 15;
    procedure SetContent(const Value: WideString); dispid 16;
    procedure SetContentStream(Stream: Integer); dispid 17;
    procedure SetContentType(const Value: WideString); dispid 18;
    procedure SetCookie(const Name, Value: WideString); dispid 19;
    procedure SetCustomHeader(const Name, Value: WideString); dispid 20;
    procedure SetDate(Value: TDateTime); dispid 21;
    procedure SetExpires(Value: TDateTime); dispid 22;
    procedure SendResponse; dispid 23;
    procedure Stack(const MethodName: WideString); dispid 24;
    procedure Unstack; dispid 25;
    procedure WriteString(const S: WideString); dispid 26;
    property Context: IXMLContext readonly dispid 27;
  end;

{ XMLCollection contains multiple XMLServices }

  IXMLCollection = interface(IDispatch)
    ['{18537E08-2B5A-11D5-88C0-0060087D03E0}']
    procedure DBBatch(const QueryName: WideString); safecall;
    procedure DBExtract(const QueryName: WideString); safecall;
    procedure DBFetch(const Query: IDacQuery); safecall;
    procedure Execute(const XMLService: WideString); safecall;
    function Execute2(const XMLService: WideString; const InputDoc, OutputDoc: IXMLCursor): IXMLCursor; safecall;
    procedure ExecuteSoapOperation(const Name: WideString); safecall;
    procedure ExecuteXMLInstruction(const XMLService, XMLInstruction: WideString; const InputDoc, OutputDoc: IXMLCursor); safecall;
    function FindXMLService(const Name: WideString): IXMLService; safecall;
    function GetDatabase(const DatabaseName: WideString): IDacDatabase; safecall;
    function GetDatabaseCount: Integer; safecall;
    function GetDatabaseNo(Index: Integer): IDacDatabase; safecall;
    function GetQuery(const Name: WideString): IDacQuery; safecall;
    function GetSoapOperation(const Name: WideString): ISoapOperation; safecall;
    function GetXMLService(const Name: WideString): IXMLService; safecall;
    procedure Pivot(const FieldName: WideString); safecall;
    procedure Unpivot(const FieldName, DestFieldName: WideString); safecall;
    function Get_XMLCache: IXMLCache; safecall;
    function Get_XMLRequest: IXMLRequest; safecall;
    function Get_XSLCache: IXMLCache; safecall;
    property XMLCache: IXMLCache read Get_XMLCache;
    property XMLRequest: IXMLRequest read Get_XMLRequest;
    property XSLCache: IXMLCache read Get_XSLCache;
  end;

{ DispInterface declaration for Dual Interface IXMLCollection }

  IXMLCollectionDisp = dispinterface
    ['{18537E08-2B5A-11D5-88C0-0060087D03E0}']
    procedure DBBatch(const QueryName: WideString); dispid 1;
    procedure DBExtract(const QueryName: WideString); dispid 2;
    procedure DBFetch(const Query: IDacQuery); dispid 3;
    procedure Execute(const XMLService: WideString); dispid 4;
    function Execute2(const XMLService: WideString; const InputDoc, OutputDoc: IXMLCursor): IXMLCursor; dispid 5;
    procedure ExecuteSoapOperation(const Name: WideString); dispid 6;
    procedure ExecuteXMLInstruction(const XMLService, XMLInstruction: WideString; const InputDoc, OutputDoc: IXMLCursor); dispid 7;
    function FindXMLService(const Name: WideString): IXMLService; dispid 8;
    function GetDatabase(const DatabaseName: WideString): IDacDatabase; dispid 9;
    function GetDatabaseCount: Integer; dispid 10;
    function GetDatabaseNo(Index: Integer): IDacDatabase; dispid 11;
    function GetQuery(const Name: WideString): IDacQuery; dispid 12;
    function GetSoapOperation(const Name: WideString): ISoapOperation; dispid 13;
    function GetXMLService(const Name: WideString): IXMLService; dispid 14;
    procedure Pivot(const FieldName: WideString); dispid 15;
    procedure Unpivot(const FieldName, DestFieldName: WideString); dispid 16;
    property XMLCache: IXMLCache readonly dispid 17;
    property XMLRequest: IXMLRequest readonly dispid 18;
    property XSLCache: IXMLCache readonly dispid 19;
  end;

  IXMLService = interface(IDispatch)
    ['{18537E0B-2B5A-11D5-88C0-0060087D03E0}']
    procedure Execute; safecall;
    function Execute2(const InputDoc, OutputDoc: IXMLCursor): IXMLCursor; safecall;
    procedure ExecuteXMLInstruction(const XMLInstruction: WideString; const InputDoc, OutputDoc: IXMLCursor); safecall;
    function Get_Handled: WordBool; safecall;
    procedure Set_Handled(Value: WordBool); safecall;
    property Handled: WordBool read Get_Handled write Set_Handled;
  end;

{ DispInterface declaration for Dual Interface IXMLService }

  IXMLServiceDisp = dispinterface
    ['{18537E0B-2B5A-11D5-88C0-0060087D03E0}']
    procedure Execute; dispid 1;
    function Execute2(const InputDoc, OutputDoc: IXMLCursor): IXMLCursor; dispid 2;
    procedure ExecuteXMLInstruction(const XMLInstruction: WideString; const InputDoc, OutputDoc: IXMLCursor); dispid 3;
    property Handled: WordBool dispid 4;
  end;

  IXMLGram = interface(IDispatch)
    ['{18537E0C-2B5A-11D5-88C0-0060087D03E0}']
    function GetXMLInstruction(const Name: WideString): IXMLInstruction; safecall;
    procedure Process(const AInputDoc, AOutputDoc: IXMLCursor); safecall;
    procedure ProcessXMLInstruction(const XMLInstruction: IXMLInstruction; const AInputDoc, AOutputDoc: IXMLCursor); safecall;
    function Get_InputDoc: IXMLCursor; safecall;
    function Get_OutputDoc: IXMLCursor; safecall;
    function Get_Precompile: WordBool; safecall;
    function Get_Name: WideString; safecall;
    function Get_Skip: WordBool; safecall;
    procedure Set_Skip(Value: WordBool); safecall;
    property InputDoc: IXMLCursor read Get_InputDoc;
    property OutputDoc: IXMLCursor read Get_OutputDoc;
    property Precompile: WordBool read Get_Precompile;
    property Name: WideString read Get_Name;
    property Skip: WordBool read Get_Skip write Set_Skip;
  end;

{ DispInterface declaration for Dual Interface IXMLGram }

  IXMLGramDisp = dispinterface
    ['{18537E0C-2B5A-11D5-88C0-0060087D03E0}']
    function GetXMLInstruction(const Name: WideString): IXMLInstruction; dispid 15;
    procedure Process(const AInputDoc, AOutputDoc: IXMLCursor); dispid 17;
    procedure ProcessXMLInstruction(const XMLInstruction: IXMLInstruction; const AInputDoc, AOutputDoc: IXMLCursor); dispid 18;
    property InputDoc: IXMLCursor readonly dispid 20;
    property OutputDoc: IXMLCursor readonly dispid 21;
    property Precompile: WordBool readonly dispid 22;
    property Name: WideString readonly dispid 1;
    property Skip: WordBool dispid 2;
  end;

  IXMLInstruction = interface(IDispatch)
    ['{18537E0D-2B5A-11D5-88C0-0060087D03E0}']
    procedure PrepareFromDOMElement(const Element: IXMLCursor); safecall;
    procedure Process(const Context: IXMLContext; const Input, Output: IXMLCursor); safecall;
    function Get_Name: WideString; safecall;
    function Get_ObjectReference: Integer; safecall;
    function Get_Operation: WideString; safecall;
    function Get_PreserveContext: WordBool; safecall;
    function Get_Skip: WordBool; safecall;
    procedure Set_Skip(Value: WordBool); safecall;
    property Name: WideString read Get_Name;
    property ObjectReference: Integer read Get_ObjectReference;
    property Operation: WideString read Get_Operation;
    property PreserveContext: WordBool read Get_PreserveContext;
    property Skip: WordBool read Get_Skip write Set_Skip;
  end;

{ DispInterface declaration for Dual Interface IXMLInstruction }

  IXMLInstructionDisp = dispinterface
    ['{18537E0D-2B5A-11D5-88C0-0060087D03E0}']
    procedure PrepareFromDOMElement(const Element: IXMLCursor); dispid 1;
    procedure Process(const Context: IXMLContext; const Input, Output: IXMLCursor); dispid 2;
    property Name: WideString readonly dispid 3;
    property ObjectReference: Integer readonly dispid 4;
    property Operation: WideString readonly dispid 5;
    property PreserveContext: WordBool readonly dispid 6;
    property Skip: WordBool dispid 7;
  end;

  IXMLApplication = interface(IDispatch)
    ['{22613FC0-42B8-11D5-88C8-0060087D03E0}']
    function Get_Aliases: IXMLCursor; safecall;
    function Get_AppFileName: WideString; safecall;
    function Get_AppPath: WideString; safecall;
    function Get_Config: IXMLContext; safecall;
    function Get_DataSources: IXMLCursor; safecall;
    function Get_GlobalParams: IXMLContext; safecall;
    function Get_InitParams: IXMLContext; safecall;
    function Get_NeedToInitialize: WordBool; safecall;
    procedure Set_NeedToInitialize(Value: WordBool); safecall;
    property Aliases: IXMLCursor read Get_Aliases;
    property AppFileName: WideString read Get_AppFileName;
    property AppPath: WideString read Get_AppPath;
    property Config: IXMLContext read Get_Config;
    property DataSources: IXMLCursor read Get_DataSources;
    property GlobalParams: IXMLContext read Get_GlobalParams;
    property InitParams: IXMLContext read Get_InitParams;
    property NeedToInitialize: WordBool read Get_NeedToInitialize write Set_NeedToInitialize;
  end;

{ DispInterface declaration for Dual Interface IXMLApplication }

  IXMLApplicationDisp = dispinterface
    ['{22613FC0-42B8-11D5-88C8-0060087D03E0}']
    property Aliases: IXMLCursor readonly dispid 1;
    property AppFileName: WideString readonly dispid 2;
    property AppPath: WideString readonly dispid 3;
    property Config: IXMLContext readonly dispid 4;
    property DataSources: IXMLCursor readonly dispid 5;
    property GlobalParams: IXMLContext readonly dispid 6;
    property InitParams: IXMLContext readonly dispid 7;
    property NeedToInitialize: WordBool dispid 8;
  end;

  IXMLGenerator = interface(IDispatch)
    ['{134B0E12-4D0C-11D5-88CD-0060087D03E0}']
    function GetNewID(const GeneratorName: WideString): WideString; safecall;
    function IncValue(const GeneratorName, Step: WideString): WideString; safecall;
  end;

{ DispInterface declaration for Dual Interface IXMLGenerator }

  IXMLGeneratorDisp = dispinterface
    ['{134B0E12-4D0C-11D5-88CD-0060087D03E0}']
    function GetNewID(const GeneratorName: WideString): WideString; dispid 1;
    function IncValue(const GeneratorName, Step: WideString): WideString; dispid 2;
  end;

  ISoapOperation = interface(IDispatch)
    ['{A7F39C60-5F85-11D5-88CF-0060087D03E0}']
    procedure Close; safecall;
    function EOF: WordBool; safecall;
    procedure Execute; safecall;
    function FieldCount: Integer; safecall;
    procedure First; safecall;
    function GetFieldName(Index: Integer): WideString; safecall;
    function GetFieldAsString(const FieldName: WideString): WideString; safecall;
    function GetParamName(Index: Integer): WideString; safecall;
    function GetValue(const Name: WideString): WideString; safecall;
    procedure Next; safecall;
    procedure Open; safecall;
    function ParamCount: Integer; safecall;
    procedure Prepare; safecall;
    function Prepared: WordBool; safecall;
    procedure SetParamAsString(const Name, Value: WideString); safecall;
    procedure Unprepare; safecall;
    function Get_InputMessage: IXMLCursor; safecall;
    function Get_KeepNameSpaces: WordBool; safecall;
    procedure Set_KeepNameSpaces(Value: WordBool); safecall;
    function Get_Message: WideString; safecall;
    procedure Set_Message(const Value: WideString); safecall;
    function Get_OutputMessage: IXMLCursor; safecall;
    function Get_Password: WideString; safecall;
    procedure Set_Password(const Value: WideString); safecall;
    function Get_Response: WideString; safecall;
    function Get_SoapAction: WideString; safecall;
    procedure Set_SoapAction(const Value: WideString); safecall;
    function Get_TimeOut: Integer; safecall;
    procedure Set_TimeOut(Value: Integer); safecall;
    function Get_URL: WideString; safecall;
    procedure Set_URL(const Value: WideString); safecall;
    function Get_UserName: WideString; safecall;
    procedure Set_UserName(const Value: WideString); safecall;
    function Get_Values(const Name: WideString): WideString; safecall;
    procedure Set_Values(const Name: WideString; const Value: WideString); safecall;
    function Get_WSDL: WideString; safecall;
    procedure Set_WSDL(const Value: WideString); safecall;
    property InputMessage: IXMLCursor read Get_InputMessage;
    property KeepNameSpaces: WordBool read Get_KeepNameSpaces write Set_KeepNameSpaces;
    property Message: WideString read Get_Message write Set_Message;
    property OutputMessage: IXMLCursor read Get_OutputMessage;
    property Password: WideString read Get_Password write Set_Password;
    property Response: WideString read Get_Response;
    property SoapAction: WideString read Get_SoapAction write Set_SoapAction;
    property TimeOut: Integer read Get_TimeOut write Set_TimeOut;
    property URL: WideString read Get_URL write Set_URL;
    property UserName: WideString read Get_UserName write Set_UserName;
    property Values[const Name: WideString]: WideString read Get_Values write Set_Values;
    property WSDL: WideString read Get_WSDL write Set_WSDL;
  end;

{ DispInterface declaration for Dual Interface ISoapOperation }

  ISoapOperationDisp = dispinterface
    ['{A7F39C60-5F85-11D5-88CF-0060087D03E0}']
    procedure Close; dispid 1;
    function EOF: WordBool; dispid 2;
    procedure Execute; dispid 3;
    function FieldCount: Integer; dispid 4;
    procedure First; dispid 5;
    function GetFieldName(Index: Integer): WideString; dispid 6;
    function GetFieldAsString(const FieldName: WideString): WideString; dispid 7;
    function GetParamName(Index: Integer): WideString; dispid 8;
    function GetValue(const Name: WideString): WideString; dispid 9;
    procedure Next; dispid 10;
    procedure Open; dispid 11;
    function ParamCount: Integer; dispid 12;
    procedure Prepare; dispid 13;
    function Prepared: WordBool; dispid 14;
    procedure SetParamAsString(const Name, Value: WideString); dispid 15;
    procedure Unprepare; dispid 16;
    property InputMessage: IXMLCursor readonly dispid 17;
    property KeepNameSpaces: WordBool dispid 18;
    property Message: WideString dispid 19;
    property OutputMessage: IXMLCursor readonly dispid 20;
    property Password: WideString dispid 21;
    property Response: WideString readonly dispid 22;
    property SoapAction: WideString dispid 23;
    property TimeOut: Integer dispid 24;
    property URL: WideString dispid 25;
    property UserName: WideString dispid 26;
    property Values[const Name: WideString]: WideString dispid 27;
    property WSDL: WideString dispid 28;
  end;



implementation


end.
