
{*************************************************************************}
{                                                                         }
{                         Liaison de données XML                          }
{                                                                         }
{         Généré le : 06/09/2013 16:46:53                                 }
{       Généré depuis : D:\Tech\V11_1_0Bin\DelosQPMAgent.InitParams.xml   }
{                                                                         }
{*************************************************************************}

unit uXmlDelosQPMAgentInitParams;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Décl. Forward }

  IXMLInitParamsType = interface;
  IXMLXMLCType = interface;
  IXMLQPMType = interface;

{ IXMLInitParamsType }

  IXMLInitParamsType = interface(IXMLNode)
    ['{D03A81ED-E9CE-4F57-8D14-95153FE13D17}']
    { Accesseurs de propriétés }
    function Get_XMLC: IXMLXMLCType;
    function Get_QPM: IXMLQPMType;
    { Méthodes & propriétés }
    property XMLC: IXMLXMLCType read Get_XMLC;
    property QPM: IXMLQPMType read Get_QPM;
  end;

{ IXMLXMLCType }

  IXMLXMLCType = interface(IXMLNode)
    ['{DFBA91D3-D3D0-41B9-9371-C853E3B4D5C0}']
    { Accesseurs de propriétés }
    function Get_XMLC_AdmXMLPath: UnicodeString;
    function Get_XMLC_CallStack: Integer;
    function Get_XMLC_CookiesPath: UnicodeString;
    function Get_XMLC_Debug: Integer;
    function Get_XMLC_DefaultAction: UnicodeString;
    function Get_XMLC_GenIDFile: UnicodeString;
    function Get_XMLC_GenIDURL: UnicodeString;
    function Get_XMLC_HTTPDName: UnicodeString;
    function Get_XMLC_IDEName: UnicodeString;
    function Get_XMLC_InstanceName: UnicodeString;
    function Get_XMLC_Log: Integer;
    function Get_XMLC_MaxConcurrentRemoteHostRequests: Integer;
    function Get_XMLC_MaxRequestsExceeded: UnicodeString;
    function Get_XMLC_MaxWaitingTime: Integer;
    function Get_XMLC_OSCulture: UnicodeString;
    function Get_XMLC_Params: UnicodeString;
    function Get_XMLC_Port: Integer;
    function Get_XMLC_Portal: UnicodeString;
    function Get_XMLC_PoweredBy: UnicodeString;
    function Get_XMLC_ProductName: UnicodeString;
    function Get_XMLC_ProductVersion: UnicodeString;
    function Get_XMLC_RegisteredEmail: UnicodeString;
    function Get_XMLC_RegisterURL: UnicodeString;
    function Get_XMLC_SaveEventLog: Integer;
    function Get_XMLC_SecurityFile: UnicodeString;
    function Get_XMLC_SupervisorEmail: UnicodeString;
    function Get_XMLC_SupervisorPassword: UnicodeString;
    function Get_XMLC_Threads: Integer;
    function Get_XMLC_ThreadsPerProc: UnicodeString;
    function Get_XMLC_ThreadsAdditional: UnicodeString;
    procedure Set_XMLC_AdmXMLPath(Value: UnicodeString);
    procedure Set_XMLC_CallStack(Value: Integer);
    procedure Set_XMLC_CookiesPath(Value: UnicodeString);
    procedure Set_XMLC_Debug(Value: Integer);
    procedure Set_XMLC_DefaultAction(Value: UnicodeString);
    procedure Set_XMLC_GenIDFile(Value: UnicodeString);
    procedure Set_XMLC_GenIDURL(Value: UnicodeString);
    procedure Set_XMLC_HTTPDName(Value: UnicodeString);
    procedure Set_XMLC_IDEName(Value: UnicodeString);
    procedure Set_XMLC_InstanceName(Value: UnicodeString);
    procedure Set_XMLC_Log(Value: Integer);
    procedure Set_XMLC_MaxConcurrentRemoteHostRequests(Value: Integer);
    procedure Set_XMLC_MaxRequestsExceeded(Value: UnicodeString);
    procedure Set_XMLC_MaxWaitingTime(Value: Integer);
    procedure Set_XMLC_OSCulture(Value: UnicodeString);
    procedure Set_XMLC_Params(Value: UnicodeString);
    procedure Set_XMLC_Port(Value: Integer);
    procedure Set_XMLC_Portal(Value: UnicodeString);
    procedure Set_XMLC_PoweredBy(Value: UnicodeString);
    procedure Set_XMLC_ProductName(Value: UnicodeString);
    procedure Set_XMLC_ProductVersion(Value: UnicodeString);
    procedure Set_XMLC_RegisteredEmail(Value: UnicodeString);
    procedure Set_XMLC_RegisterURL(Value: UnicodeString);
    procedure Set_XMLC_SaveEventLog(Value: Integer);
    procedure Set_XMLC_SecurityFile(Value: UnicodeString);
    procedure Set_XMLC_SupervisorEmail(Value: UnicodeString);
    procedure Set_XMLC_SupervisorPassword(Value: UnicodeString);
    procedure Set_XMLC_Threads(Value: Integer);
    procedure Set_XMLC_ThreadsPerProc(Value: UnicodeString);
    procedure Set_XMLC_ThreadsAdditional(Value: UnicodeString);
    { Méthodes & propriétés }
    property XMLC_AdmXMLPath: UnicodeString read Get_XMLC_AdmXMLPath write Set_XMLC_AdmXMLPath;
    property XMLC_CallStack: Integer read Get_XMLC_CallStack write Set_XMLC_CallStack;
    property XMLC_CookiesPath: UnicodeString read Get_XMLC_CookiesPath write Set_XMLC_CookiesPath;
    property XMLC_Debug: Integer read Get_XMLC_Debug write Set_XMLC_Debug;
    property XMLC_DefaultAction: UnicodeString read Get_XMLC_DefaultAction write Set_XMLC_DefaultAction;
    property XMLC_GenIDFile: UnicodeString read Get_XMLC_GenIDFile write Set_XMLC_GenIDFile;
    property XMLC_GenIDURL: UnicodeString read Get_XMLC_GenIDURL write Set_XMLC_GenIDURL;
    property XMLC_HTTPDName: UnicodeString read Get_XMLC_HTTPDName write Set_XMLC_HTTPDName;
    property XMLC_IDEName: UnicodeString read Get_XMLC_IDEName write Set_XMLC_IDEName;
    property XMLC_InstanceName: UnicodeString read Get_XMLC_InstanceName write Set_XMLC_InstanceName;
    property XMLC_Log: Integer read Get_XMLC_Log write Set_XMLC_Log;
    property XMLC_MaxConcurrentRemoteHostRequests: Integer read Get_XMLC_MaxConcurrentRemoteHostRequests write Set_XMLC_MaxConcurrentRemoteHostRequests;
    property XMLC_MaxRequestsExceeded: UnicodeString read Get_XMLC_MaxRequestsExceeded write Set_XMLC_MaxRequestsExceeded;
    property XMLC_MaxWaitingTime: Integer read Get_XMLC_MaxWaitingTime write Set_XMLC_MaxWaitingTime;
    property XMLC_OSCulture: UnicodeString read Get_XMLC_OSCulture write Set_XMLC_OSCulture;
    property XMLC_Params: UnicodeString read Get_XMLC_Params write Set_XMLC_Params;
    property XMLC_Port: Integer read Get_XMLC_Port write Set_XMLC_Port;
    property XMLC_Portal: UnicodeString read Get_XMLC_Portal write Set_XMLC_Portal;
    property XMLC_PoweredBy: UnicodeString read Get_XMLC_PoweredBy write Set_XMLC_PoweredBy;
    property XMLC_ProductName: UnicodeString read Get_XMLC_ProductName write Set_XMLC_ProductName;
    property XMLC_ProductVersion: UnicodeString read Get_XMLC_ProductVersion write Set_XMLC_ProductVersion;
    property XMLC_RegisteredEmail: UnicodeString read Get_XMLC_RegisteredEmail write Set_XMLC_RegisteredEmail;
    property XMLC_RegisterURL: UnicodeString read Get_XMLC_RegisterURL write Set_XMLC_RegisterURL;
    property XMLC_SaveEventLog: Integer read Get_XMLC_SaveEventLog write Set_XMLC_SaveEventLog;
    property XMLC_SecurityFile: UnicodeString read Get_XMLC_SecurityFile write Set_XMLC_SecurityFile;
    property XMLC_SupervisorEmail: UnicodeString read Get_XMLC_SupervisorEmail write Set_XMLC_SupervisorEmail;
    property XMLC_SupervisorPassword: UnicodeString read Get_XMLC_SupervisorPassword write Set_XMLC_SupervisorPassword;
    property XMLC_Threads: Integer read Get_XMLC_Threads write Set_XMLC_Threads;
    property XMLC_ThreadsPerProc: UnicodeString read Get_XMLC_ThreadsPerProc write Set_XMLC_ThreadsPerProc;
    property XMLC_ThreadsAdditional: UnicodeString read Get_XMLC_ThreadsAdditional write Set_XMLC_ThreadsAdditional;
  end;

{ IXMLQPMType }

  IXMLQPMType = interface(IXMLNode)
    ['{6CC57595-C042-49C0-B39E-8F5B3840020F}']
    { Accesseurs de propriétés }
    function Get_DEFAULT_BATCH_URL: UnicodeString;
    function Get_DEFAULT_BATCH_USERNAME: UnicodeString;
    function Get_DEFAULT_BATCH_PASSWORD: UnicodeString;
    function Get_BATCH_DIRECTORY: UnicodeString;
    function Get_DEFAULT_EXTRACT_URL: UnicodeString;
    function Get_DEFAULT_EXTRACT_USERNAME: UnicodeString;
    function Get_DEFAULT_EXTRACT_PASSWORD: UnicodeString;
    function Get_EXTRACT_DIRECTORY: UnicodeString;
    function Get_LOG_DIRECTORY: UnicodeString;
    function Get_QPM_MaxLoop: Integer;
    function Get_QPM_BatchBeforeXMLService: UnicodeString;
    function Get_QPM_BatchStarting: UnicodeString;
    function Get_QPM_BatchDone: UnicodeString;
    function Get_QPM_BatchException: UnicodeString;
    function Get_QPM_ExtractBeforeXMLService: UnicodeString;
    function Get_QPM_ExtractStarting: UnicodeString;
    function Get_QPM_ExtractDone: UnicodeString;
    function Get_QPM_ExtractException: UnicodeString;
    function Get_QPM_PullBeforeXMLService: UnicodeString;
    function Get_QPM_PullStarting: UnicodeString;
    function Get_QPM_PullDone: UnicodeString;
    function Get_QPM_PullException: UnicodeString;
    function Get_QPM_PushBeforeXMLService: UnicodeString;
    function Get_QPM_PushStarting: UnicodeString;
    function Get_QPM_PushDone: UnicodeString;
    function Get_QPM_PushException: UnicodeString;
    function Get_QPM_NotifyHTTP: Integer;
    function Get_QPM_OptionASPClient: Integer;
    function Get_QPM_OptionPullGroup: Integer;
    function Get_QPM_OptionPullLoop: Integer;
    function Get_QPM_OptionPushGroup: Integer;
    function Get_QPM_OptionPushLoop: Integer;
    function Get_QPM_OptionZip: Integer;
    function Get_QPM_Track: Integer;
    function Get_QPM_TrackZip: Integer;
    procedure Set_DEFAULT_BATCH_URL(Value: UnicodeString);
    procedure Set_DEFAULT_BATCH_USERNAME(Value: UnicodeString);
    procedure Set_DEFAULT_BATCH_PASSWORD(Value: UnicodeString);
    procedure Set_BATCH_DIRECTORY(Value: UnicodeString);
    procedure Set_DEFAULT_EXTRACT_URL(Value: UnicodeString);
    procedure Set_DEFAULT_EXTRACT_USERNAME(Value: UnicodeString);
    procedure Set_DEFAULT_EXTRACT_PASSWORD(Value: UnicodeString);
    procedure Set_EXTRACT_DIRECTORY(Value: UnicodeString);
    procedure Set_LOG_DIRECTORY(Value: UnicodeString);
    procedure Set_QPM_MaxLoop(Value: Integer);
    procedure Set_QPM_BatchBeforeXMLService(Value: UnicodeString);
    procedure Set_QPM_BatchStarting(Value: UnicodeString);
    procedure Set_QPM_BatchDone(Value: UnicodeString);
    procedure Set_QPM_BatchException(Value: UnicodeString);
    procedure Set_QPM_ExtractBeforeXMLService(Value: UnicodeString);
    procedure Set_QPM_ExtractStarting(Value: UnicodeString);
    procedure Set_QPM_ExtractDone(Value: UnicodeString);
    procedure Set_QPM_ExtractException(Value: UnicodeString);
    procedure Set_QPM_PullBeforeXMLService(Value: UnicodeString);
    procedure Set_QPM_PullStarting(Value: UnicodeString);
    procedure Set_QPM_PullDone(Value: UnicodeString);
    procedure Set_QPM_PullException(Value: UnicodeString);
    procedure Set_QPM_PushBeforeXMLService(Value: UnicodeString);
    procedure Set_QPM_PushStarting(Value: UnicodeString);
    procedure Set_QPM_PushDone(Value: UnicodeString);
    procedure Set_QPM_PushException(Value: UnicodeString);
    procedure Set_QPM_NotifyHTTP(Value: Integer);
    procedure Set_QPM_OptionASPClient(Value: Integer);
    procedure Set_QPM_OptionPullGroup(Value: Integer);
    procedure Set_QPM_OptionPullLoop(Value: Integer);
    procedure Set_QPM_OptionPushGroup(Value: Integer);
    procedure Set_QPM_OptionPushLoop(Value: Integer);
    procedure Set_QPM_OptionZip(Value: Integer);
    procedure Set_QPM_Track(Value: Integer);
    procedure Set_QPM_TrackZip(Value: Integer);
    { Méthodes & propriétés }
    property DEFAULT_BATCH_URL: UnicodeString read Get_DEFAULT_BATCH_URL write Set_DEFAULT_BATCH_URL;
    property DEFAULT_BATCH_USERNAME: UnicodeString read Get_DEFAULT_BATCH_USERNAME write Set_DEFAULT_BATCH_USERNAME;
    property DEFAULT_BATCH_PASSWORD: UnicodeString read Get_DEFAULT_BATCH_PASSWORD write Set_DEFAULT_BATCH_PASSWORD;
    property BATCH_DIRECTORY: UnicodeString read Get_BATCH_DIRECTORY write Set_BATCH_DIRECTORY;
    property DEFAULT_EXTRACT_URL: UnicodeString read Get_DEFAULT_EXTRACT_URL write Set_DEFAULT_EXTRACT_URL;
    property DEFAULT_EXTRACT_USERNAME: UnicodeString read Get_DEFAULT_EXTRACT_USERNAME write Set_DEFAULT_EXTRACT_USERNAME;
    property DEFAULT_EXTRACT_PASSWORD: UnicodeString read Get_DEFAULT_EXTRACT_PASSWORD write Set_DEFAULT_EXTRACT_PASSWORD;
    property EXTRACT_DIRECTORY: UnicodeString read Get_EXTRACT_DIRECTORY write Set_EXTRACT_DIRECTORY;
    property LOG_DIRECTORY: UnicodeString read Get_LOG_DIRECTORY write Set_LOG_DIRECTORY;
    property QPM_MaxLoop: Integer read Get_QPM_MaxLoop write Set_QPM_MaxLoop;
    property QPM_BatchBeforeXMLService: UnicodeString read Get_QPM_BatchBeforeXMLService write Set_QPM_BatchBeforeXMLService;
    property QPM_BatchStarting: UnicodeString read Get_QPM_BatchStarting write Set_QPM_BatchStarting;
    property QPM_BatchDone: UnicodeString read Get_QPM_BatchDone write Set_QPM_BatchDone;
    property QPM_BatchException: UnicodeString read Get_QPM_BatchException write Set_QPM_BatchException;
    property QPM_ExtractBeforeXMLService: UnicodeString read Get_QPM_ExtractBeforeXMLService write Set_QPM_ExtractBeforeXMLService;
    property QPM_ExtractStarting: UnicodeString read Get_QPM_ExtractStarting write Set_QPM_ExtractStarting;
    property QPM_ExtractDone: UnicodeString read Get_QPM_ExtractDone write Set_QPM_ExtractDone;
    property QPM_ExtractException: UnicodeString read Get_QPM_ExtractException write Set_QPM_ExtractException;
    property QPM_PullBeforeXMLService: UnicodeString read Get_QPM_PullBeforeXMLService write Set_QPM_PullBeforeXMLService;
    property QPM_PullStarting: UnicodeString read Get_QPM_PullStarting write Set_QPM_PullStarting;
    property QPM_PullDone: UnicodeString read Get_QPM_PullDone write Set_QPM_PullDone;
    property QPM_PullException: UnicodeString read Get_QPM_PullException write Set_QPM_PullException;
    property QPM_PushBeforeXMLService: UnicodeString read Get_QPM_PushBeforeXMLService write Set_QPM_PushBeforeXMLService;
    property QPM_PushStarting: UnicodeString read Get_QPM_PushStarting write Set_QPM_PushStarting;
    property QPM_PushDone: UnicodeString read Get_QPM_PushDone write Set_QPM_PushDone;
    property QPM_PushException: UnicodeString read Get_QPM_PushException write Set_QPM_PushException;
    property QPM_NotifyHTTP: Integer read Get_QPM_NotifyHTTP write Set_QPM_NotifyHTTP;
    property QPM_OptionASPClient: Integer read Get_QPM_OptionASPClient write Set_QPM_OptionASPClient;
    property QPM_OptionPullGroup: Integer read Get_QPM_OptionPullGroup write Set_QPM_OptionPullGroup;
    property QPM_OptionPullLoop: Integer read Get_QPM_OptionPullLoop write Set_QPM_OptionPullLoop;
    property QPM_OptionPushGroup: Integer read Get_QPM_OptionPushGroup write Set_QPM_OptionPushGroup;
    property QPM_OptionPushLoop: Integer read Get_QPM_OptionPushLoop write Set_QPM_OptionPushLoop;
    property QPM_OptionZip: Integer read Get_QPM_OptionZip write Set_QPM_OptionZip;
    property QPM_Track: Integer read Get_QPM_Track write Set_QPM_Track;
    property QPM_TrackZip: Integer read Get_QPM_TrackZip write Set_QPM_TrackZip;
  end;

{ Décl. Forward }

  TXMLInitParamsType = class;
  TXMLXMLCType = class;
  TXMLQPMType = class;

{ TXMLInitParamsType }

  TXMLInitParamsType = class(TXMLNode, IXMLInitParamsType)
  protected
    { IXMLInitParamsType }
    function Get_XMLC: IXMLXMLCType;
    function Get_QPM: IXMLQPMType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLXMLCType }

  TXMLXMLCType = class(TXMLNode, IXMLXMLCType)
  protected
    { IXMLXMLCType }
    function Get_XMLC_AdmXMLPath: UnicodeString;
    function Get_XMLC_CallStack: Integer;
    function Get_XMLC_CookiesPath: UnicodeString;
    function Get_XMLC_Debug: Integer;
    function Get_XMLC_DefaultAction: UnicodeString;
    function Get_XMLC_GenIDFile: UnicodeString;
    function Get_XMLC_GenIDURL: UnicodeString;
    function Get_XMLC_HTTPDName: UnicodeString;
    function Get_XMLC_IDEName: UnicodeString;
    function Get_XMLC_InstanceName: UnicodeString;
    function Get_XMLC_Log: Integer;
    function Get_XMLC_MaxConcurrentRemoteHostRequests: Integer;
    function Get_XMLC_MaxRequestsExceeded: UnicodeString;
    function Get_XMLC_MaxWaitingTime: Integer;
    function Get_XMLC_OSCulture: UnicodeString;
    function Get_XMLC_Params: UnicodeString;
    function Get_XMLC_Port: Integer;
    function Get_XMLC_Portal: UnicodeString;
    function Get_XMLC_PoweredBy: UnicodeString;
    function Get_XMLC_ProductName: UnicodeString;
    function Get_XMLC_ProductVersion: UnicodeString;
    function Get_XMLC_RegisteredEmail: UnicodeString;
    function Get_XMLC_RegisterURL: UnicodeString;
    function Get_XMLC_SaveEventLog: Integer;
    function Get_XMLC_SecurityFile: UnicodeString;
    function Get_XMLC_SupervisorEmail: UnicodeString;
    function Get_XMLC_SupervisorPassword: UnicodeString;
    function Get_XMLC_Threads: Integer;
    function Get_XMLC_ThreadsPerProc: UnicodeString;
    function Get_XMLC_ThreadsAdditional: UnicodeString;
    procedure Set_XMLC_AdmXMLPath(Value: UnicodeString);
    procedure Set_XMLC_CallStack(Value: Integer);
    procedure Set_XMLC_CookiesPath(Value: UnicodeString);
    procedure Set_XMLC_Debug(Value: Integer);
    procedure Set_XMLC_DefaultAction(Value: UnicodeString);
    procedure Set_XMLC_GenIDFile(Value: UnicodeString);
    procedure Set_XMLC_GenIDURL(Value: UnicodeString);
    procedure Set_XMLC_HTTPDName(Value: UnicodeString);
    procedure Set_XMLC_IDEName(Value: UnicodeString);
    procedure Set_XMLC_InstanceName(Value: UnicodeString);
    procedure Set_XMLC_Log(Value: Integer);
    procedure Set_XMLC_MaxConcurrentRemoteHostRequests(Value: Integer);
    procedure Set_XMLC_MaxRequestsExceeded(Value: UnicodeString);
    procedure Set_XMLC_MaxWaitingTime(Value: Integer);
    procedure Set_XMLC_OSCulture(Value: UnicodeString);
    procedure Set_XMLC_Params(Value: UnicodeString);
    procedure Set_XMLC_Port(Value: Integer);
    procedure Set_XMLC_Portal(Value: UnicodeString);
    procedure Set_XMLC_PoweredBy(Value: UnicodeString);
    procedure Set_XMLC_ProductName(Value: UnicodeString);
    procedure Set_XMLC_ProductVersion(Value: UnicodeString);
    procedure Set_XMLC_RegisteredEmail(Value: UnicodeString);
    procedure Set_XMLC_RegisterURL(Value: UnicodeString);
    procedure Set_XMLC_SaveEventLog(Value: Integer);
    procedure Set_XMLC_SecurityFile(Value: UnicodeString);
    procedure Set_XMLC_SupervisorEmail(Value: UnicodeString);
    procedure Set_XMLC_SupervisorPassword(Value: UnicodeString);
    procedure Set_XMLC_Threads(Value: Integer);
    procedure Set_XMLC_ThreadsPerProc(Value: UnicodeString);
    procedure Set_XMLC_ThreadsAdditional(Value: UnicodeString);
  end;

{ TXMLQPMType }

  TXMLQPMType = class(TXMLNode, IXMLQPMType)
  protected
    { IXMLQPMType }
    function Get_DEFAULT_BATCH_URL: UnicodeString;
    function Get_DEFAULT_BATCH_USERNAME: UnicodeString;
    function Get_DEFAULT_BATCH_PASSWORD: UnicodeString;
    function Get_BATCH_DIRECTORY: UnicodeString;
    function Get_DEFAULT_EXTRACT_URL: UnicodeString;
    function Get_DEFAULT_EXTRACT_USERNAME: UnicodeString;
    function Get_DEFAULT_EXTRACT_PASSWORD: UnicodeString;
    function Get_EXTRACT_DIRECTORY: UnicodeString;
    function Get_LOG_DIRECTORY: UnicodeString;
    function Get_QPM_MaxLoop: Integer;
    function Get_QPM_BatchBeforeXMLService: UnicodeString;
    function Get_QPM_BatchStarting: UnicodeString;
    function Get_QPM_BatchDone: UnicodeString;
    function Get_QPM_BatchException: UnicodeString;
    function Get_QPM_ExtractBeforeXMLService: UnicodeString;
    function Get_QPM_ExtractStarting: UnicodeString;
    function Get_QPM_ExtractDone: UnicodeString;
    function Get_QPM_ExtractException: UnicodeString;
    function Get_QPM_PullBeforeXMLService: UnicodeString;
    function Get_QPM_PullStarting: UnicodeString;
    function Get_QPM_PullDone: UnicodeString;
    function Get_QPM_PullException: UnicodeString;
    function Get_QPM_PushBeforeXMLService: UnicodeString;
    function Get_QPM_PushStarting: UnicodeString;
    function Get_QPM_PushDone: UnicodeString;
    function Get_QPM_PushException: UnicodeString;
    function Get_QPM_NotifyHTTP: Integer;
    function Get_QPM_OptionASPClient: Integer;
    function Get_QPM_OptionPullGroup: Integer;
    function Get_QPM_OptionPullLoop: Integer;
    function Get_QPM_OptionPushGroup: Integer;
    function Get_QPM_OptionPushLoop: Integer;
    function Get_QPM_OptionZip: Integer;
    function Get_QPM_Track: Integer;
    function Get_QPM_TrackZip: Integer;
    procedure Set_DEFAULT_BATCH_URL(Value: UnicodeString);
    procedure Set_DEFAULT_BATCH_USERNAME(Value: UnicodeString);
    procedure Set_DEFAULT_BATCH_PASSWORD(Value: UnicodeString);
    procedure Set_BATCH_DIRECTORY(Value: UnicodeString);
    procedure Set_DEFAULT_EXTRACT_URL(Value: UnicodeString);
    procedure Set_DEFAULT_EXTRACT_USERNAME(Value: UnicodeString);
    procedure Set_DEFAULT_EXTRACT_PASSWORD(Value: UnicodeString);
    procedure Set_EXTRACT_DIRECTORY(Value: UnicodeString);
    procedure Set_LOG_DIRECTORY(Value: UnicodeString);
    procedure Set_QPM_MaxLoop(Value: Integer);
    procedure Set_QPM_BatchBeforeXMLService(Value: UnicodeString);
    procedure Set_QPM_BatchStarting(Value: UnicodeString);
    procedure Set_QPM_BatchDone(Value: UnicodeString);
    procedure Set_QPM_BatchException(Value: UnicodeString);
    procedure Set_QPM_ExtractBeforeXMLService(Value: UnicodeString);
    procedure Set_QPM_ExtractStarting(Value: UnicodeString);
    procedure Set_QPM_ExtractDone(Value: UnicodeString);
    procedure Set_QPM_ExtractException(Value: UnicodeString);
    procedure Set_QPM_PullBeforeXMLService(Value: UnicodeString);
    procedure Set_QPM_PullStarting(Value: UnicodeString);
    procedure Set_QPM_PullDone(Value: UnicodeString);
    procedure Set_QPM_PullException(Value: UnicodeString);
    procedure Set_QPM_PushBeforeXMLService(Value: UnicodeString);
    procedure Set_QPM_PushStarting(Value: UnicodeString);
    procedure Set_QPM_PushDone(Value: UnicodeString);
    procedure Set_QPM_PushException(Value: UnicodeString);
    procedure Set_QPM_NotifyHTTP(Value: Integer);
    procedure Set_QPM_OptionASPClient(Value: Integer);
    procedure Set_QPM_OptionPullGroup(Value: Integer);
    procedure Set_QPM_OptionPullLoop(Value: Integer);
    procedure Set_QPM_OptionPushGroup(Value: Integer);
    procedure Set_QPM_OptionPushLoop(Value: Integer);
    procedure Set_QPM_OptionZip(Value: Integer);
    procedure Set_QPM_Track(Value: Integer);
    procedure Set_QPM_TrackZip(Value: Integer);
  end;

{ Fonctions globales }

function GetInitParams(Doc: IXMLDocument): IXMLInitParamsType;
function LoadInitParams(const FileName: string): IXMLInitParamsType;
function NewInitParams: IXMLInitParamsType;

const
  TargetNamespace = '';

implementation

{ Fonctions globales }

function GetInitParams(Doc: IXMLDocument): IXMLInitParamsType;
begin
  Result := Doc.GetDocBinding('InitParams', TXMLInitParamsType, TargetNamespace) as IXMLInitParamsType;
end;

function LoadInitParams(const FileName: string): IXMLInitParamsType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('InitParams', TXMLInitParamsType, TargetNamespace) as IXMLInitParamsType;
end;

function NewInitParams: IXMLInitParamsType;
begin
  Result := NewXMLDocument.GetDocBinding('InitParams', TXMLInitParamsType, TargetNamespace) as IXMLInitParamsType;
end;

{ TXMLInitParamsType }

procedure TXMLInitParamsType.AfterConstruction;
begin
  RegisterChildNode('XMLC', TXMLXMLCType);
  RegisterChildNode('QPM', TXMLQPMType);
  inherited;
end;

function TXMLInitParamsType.Get_XMLC: IXMLXMLCType;
begin
  Result := ChildNodes['XMLC'] as IXMLXMLCType;
end;

function TXMLInitParamsType.Get_QPM: IXMLQPMType;
begin
  Result := ChildNodes['QPM'] as IXMLQPMType;
end;

{ TXMLXMLCType }

function TXMLXMLCType.Get_XMLC_AdmXMLPath: UnicodeString;
begin
  Result := ChildNodes['XMLC_AdmXMLPath'].Text;
end;

procedure TXMLXMLCType.Set_XMLC_AdmXMLPath(Value: UnicodeString);
begin
  ChildNodes['XMLC_AdmXMLPath'].NodeValue := Value;
end;

function TXMLXMLCType.Get_XMLC_CallStack: Integer;
begin
  Result := ChildNodes['XMLC_CallStack'].NodeValue;
end;

procedure TXMLXMLCType.Set_XMLC_CallStack(Value: Integer);
begin
  ChildNodes['XMLC_CallStack'].NodeValue := Value;
end;

function TXMLXMLCType.Get_XMLC_CookiesPath: UnicodeString;
begin
  Result := ChildNodes['XMLC_CookiesPath'].Text;
end;

procedure TXMLXMLCType.Set_XMLC_CookiesPath(Value: UnicodeString);
begin
  ChildNodes['XMLC_CookiesPath'].NodeValue := Value;
end;

function TXMLXMLCType.Get_XMLC_Debug: Integer;
begin
  Result := ChildNodes['XMLC_Debug'].NodeValue;
end;

procedure TXMLXMLCType.Set_XMLC_Debug(Value: Integer);
begin
  ChildNodes['XMLC_Debug'].NodeValue := Value;
end;

function TXMLXMLCType.Get_XMLC_DefaultAction: UnicodeString;
begin
  Result := ChildNodes['XMLC_DefaultAction'].Text;
end;

procedure TXMLXMLCType.Set_XMLC_DefaultAction(Value: UnicodeString);
begin
  ChildNodes['XMLC_DefaultAction'].NodeValue := Value;
end;

function TXMLXMLCType.Get_XMLC_GenIDFile: UnicodeString;
begin
  Result := ChildNodes['XMLC_GenIDFile'].Text;
end;

procedure TXMLXMLCType.Set_XMLC_GenIDFile(Value: UnicodeString);
begin
  ChildNodes['XMLC_GenIDFile'].NodeValue := Value;
end;

function TXMLXMLCType.Get_XMLC_GenIDURL: UnicodeString;
begin
  Result := ChildNodes['XMLC_GenIDURL'].Text;
end;

procedure TXMLXMLCType.Set_XMLC_GenIDURL(Value: UnicodeString);
begin
  ChildNodes['XMLC_GenIDURL'].NodeValue := Value;
end;

function TXMLXMLCType.Get_XMLC_HTTPDName: UnicodeString;
begin
  Result := ChildNodes['XMLC_HTTPDName'].Text;
end;

procedure TXMLXMLCType.Set_XMLC_HTTPDName(Value: UnicodeString);
begin
  ChildNodes['XMLC_HTTPDName'].NodeValue := Value;
end;

function TXMLXMLCType.Get_XMLC_IDEName: UnicodeString;
begin
  Result := ChildNodes['XMLC_IDEName'].Text;
end;

procedure TXMLXMLCType.Set_XMLC_IDEName(Value: UnicodeString);
begin
  ChildNodes['XMLC_IDEName'].NodeValue := Value;
end;

function TXMLXMLCType.Get_XMLC_InstanceName: UnicodeString;
begin
  Result := ChildNodes['XMLC_InstanceName'].Text;
end;

procedure TXMLXMLCType.Set_XMLC_InstanceName(Value: UnicodeString);
begin
  ChildNodes['XMLC_InstanceName'].NodeValue := Value;
end;

function TXMLXMLCType.Get_XMLC_Log: Integer;
begin
  Result := ChildNodes['XMLC_Log'].NodeValue;
end;

procedure TXMLXMLCType.Set_XMLC_Log(Value: Integer);
begin
  ChildNodes['XMLC_Log'].NodeValue := Value;
end;

function TXMLXMLCType.Get_XMLC_MaxConcurrentRemoteHostRequests: Integer;
begin
  Result := ChildNodes['XMLC_MaxConcurrentRemoteHostRequests'].NodeValue;
end;

procedure TXMLXMLCType.Set_XMLC_MaxConcurrentRemoteHostRequests(Value: Integer);
begin
  ChildNodes['XMLC_MaxConcurrentRemoteHostRequests'].NodeValue := Value;
end;

function TXMLXMLCType.Get_XMLC_MaxRequestsExceeded: UnicodeString;
begin
  Result := ChildNodes['XMLC_MaxRequestsExceeded'].Text;
end;

procedure TXMLXMLCType.Set_XMLC_MaxRequestsExceeded(Value: UnicodeString);
begin
  ChildNodes['XMLC_MaxRequestsExceeded'].NodeValue := Value;
end;

function TXMLXMLCType.Get_XMLC_MaxWaitingTime: Integer;
begin
  Result := ChildNodes['XMLC_MaxWaitingTime'].NodeValue;
end;

procedure TXMLXMLCType.Set_XMLC_MaxWaitingTime(Value: Integer);
begin
  ChildNodes['XMLC_MaxWaitingTime'].NodeValue := Value;
end;

function TXMLXMLCType.Get_XMLC_OSCulture: UnicodeString;
begin
  Result := ChildNodes['XMLC_OSCulture'].Text;
end;

procedure TXMLXMLCType.Set_XMLC_OSCulture(Value: UnicodeString);
begin
  ChildNodes['XMLC_OSCulture'].NodeValue := Value;
end;

function TXMLXMLCType.Get_XMLC_Params: UnicodeString;
begin
  Result := ChildNodes['XMLC_Params'].Text;
end;

procedure TXMLXMLCType.Set_XMLC_Params(Value: UnicodeString);
begin
  ChildNodes['XMLC_Params'].NodeValue := Value;
end;

function TXMLXMLCType.Get_XMLC_Port: Integer;
begin
  Result := ChildNodes['XMLC_Port'].NodeValue;
end;

procedure TXMLXMLCType.Set_XMLC_Port(Value: Integer);
begin
  ChildNodes['XMLC_Port'].NodeValue := Value;
end;

function TXMLXMLCType.Get_XMLC_Portal: UnicodeString;
begin
  Result := ChildNodes['XMLC_Portal'].Text;
end;

procedure TXMLXMLCType.Set_XMLC_Portal(Value: UnicodeString);
begin
  ChildNodes['XMLC_Portal'].NodeValue := Value;
end;

function TXMLXMLCType.Get_XMLC_PoweredBy: UnicodeString;
begin
  Result := ChildNodes['XMLC_PoweredBy'].Text;
end;

procedure TXMLXMLCType.Set_XMLC_PoweredBy(Value: UnicodeString);
begin
  ChildNodes['XMLC_PoweredBy'].NodeValue := Value;
end;

function TXMLXMLCType.Get_XMLC_ProductName: UnicodeString;
begin
  Result := ChildNodes['XMLC_ProductName'].Text;
end;

procedure TXMLXMLCType.Set_XMLC_ProductName(Value: UnicodeString);
begin
  ChildNodes['XMLC_ProductName'].NodeValue := Value;
end;

function TXMLXMLCType.Get_XMLC_ProductVersion: UnicodeString;
begin
  Result := ChildNodes['XMLC_ProductVersion'].Text;
end;

procedure TXMLXMLCType.Set_XMLC_ProductVersion(Value: UnicodeString);
begin
  ChildNodes['XMLC_ProductVersion'].NodeValue := Value;
end;

function TXMLXMLCType.Get_XMLC_RegisteredEmail: UnicodeString;
begin
  Result := ChildNodes['XMLC_RegisteredEmail'].Text;
end;

procedure TXMLXMLCType.Set_XMLC_RegisteredEmail(Value: UnicodeString);
begin
  ChildNodes['XMLC_RegisteredEmail'].NodeValue := Value;
end;

function TXMLXMLCType.Get_XMLC_RegisterURL: UnicodeString;
begin
  Result := ChildNodes['XMLC_RegisterURL'].Text;
end;

procedure TXMLXMLCType.Set_XMLC_RegisterURL(Value: UnicodeString);
begin
  ChildNodes['XMLC_RegisterURL'].NodeValue := Value;
end;

function TXMLXMLCType.Get_XMLC_SaveEventLog: Integer;
begin
  Result := ChildNodes['XMLC_SaveEventLog'].NodeValue;
end;

procedure TXMLXMLCType.Set_XMLC_SaveEventLog(Value: Integer);
begin
  ChildNodes['XMLC_SaveEventLog'].NodeValue := Value;
end;

function TXMLXMLCType.Get_XMLC_SecurityFile: UnicodeString;
begin
  Result := ChildNodes['XMLC_SecurityFile'].Text;
end;

procedure TXMLXMLCType.Set_XMLC_SecurityFile(Value: UnicodeString);
begin
  ChildNodes['XMLC_SecurityFile'].NodeValue := Value;
end;

function TXMLXMLCType.Get_XMLC_SupervisorEmail: UnicodeString;
begin
  Result := ChildNodes['XMLC_SupervisorEmail'].Text;
end;

procedure TXMLXMLCType.Set_XMLC_SupervisorEmail(Value: UnicodeString);
begin
  ChildNodes['XMLC_SupervisorEmail'].NodeValue := Value;
end;

function TXMLXMLCType.Get_XMLC_SupervisorPassword: UnicodeString;
begin
  Result := ChildNodes['XMLC_SupervisorPassword'].Text;
end;

procedure TXMLXMLCType.Set_XMLC_SupervisorPassword(Value: UnicodeString);
begin
  ChildNodes['XMLC_SupervisorPassword'].NodeValue := Value;
end;

function TXMLXMLCType.Get_XMLC_Threads: Integer;
begin
  Result := ChildNodes['XMLC_Threads'].NodeValue;
end;

procedure TXMLXMLCType.Set_XMLC_Threads(Value: Integer);
begin
  ChildNodes['XMLC_Threads'].NodeValue := Value;
end;

function TXMLXMLCType.Get_XMLC_ThreadsPerProc: UnicodeString;
begin
  Result := ChildNodes['XMLC_ThreadsPerProc'].Text;
end;

procedure TXMLXMLCType.Set_XMLC_ThreadsPerProc(Value: UnicodeString);
begin
  ChildNodes['XMLC_ThreadsPerProc'].NodeValue := Value;
end;

function TXMLXMLCType.Get_XMLC_ThreadsAdditional: UnicodeString;
begin
  Result := ChildNodes['XMLC_ThreadsAdditional'].Text;
end;

procedure TXMLXMLCType.Set_XMLC_ThreadsAdditional(Value: UnicodeString);
begin
  ChildNodes['XMLC_ThreadsAdditional'].NodeValue := Value;
end;

{ TXMLQPMType }

function TXMLQPMType.Get_DEFAULT_BATCH_URL: UnicodeString;
begin
  Result := ChildNodes['DEFAULT_BATCH_URL'].Text;
end;

procedure TXMLQPMType.Set_DEFAULT_BATCH_URL(Value: UnicodeString);
begin
  ChildNodes['DEFAULT_BATCH_URL'].NodeValue := Value;
end;

function TXMLQPMType.Get_DEFAULT_BATCH_USERNAME: UnicodeString;
begin
  Result := ChildNodes['DEFAULT_BATCH_USERNAME'].Text;
end;

procedure TXMLQPMType.Set_DEFAULT_BATCH_USERNAME(Value: UnicodeString);
begin
  ChildNodes['DEFAULT_BATCH_USERNAME'].NodeValue := Value;
end;

function TXMLQPMType.Get_DEFAULT_BATCH_PASSWORD: UnicodeString;
begin
  Result := ChildNodes['DEFAULT_BATCH_PASSWORD'].Text;
end;

procedure TXMLQPMType.Set_DEFAULT_BATCH_PASSWORD(Value: UnicodeString);
begin
  ChildNodes['DEFAULT_BATCH_PASSWORD'].NodeValue := Value;
end;

function TXMLQPMType.Get_BATCH_DIRECTORY: UnicodeString;
begin
  Result := ChildNodes['BATCH_DIRECTORY'].Text;
end;

procedure TXMLQPMType.Set_BATCH_DIRECTORY(Value: UnicodeString);
begin
  ChildNodes['BATCH_DIRECTORY'].NodeValue := Value;
end;

function TXMLQPMType.Get_DEFAULT_EXTRACT_URL: UnicodeString;
begin
  Result := ChildNodes['DEFAULT_EXTRACT_URL'].Text;
end;

procedure TXMLQPMType.Set_DEFAULT_EXTRACT_URL(Value: UnicodeString);
begin
  ChildNodes['DEFAULT_EXTRACT_URL'].NodeValue := Value;
end;

function TXMLQPMType.Get_DEFAULT_EXTRACT_USERNAME: UnicodeString;
begin
  Result := ChildNodes['DEFAULT_EXTRACT_USERNAME'].Text;
end;

procedure TXMLQPMType.Set_DEFAULT_EXTRACT_USERNAME(Value: UnicodeString);
begin
  ChildNodes['DEFAULT_EXTRACT_USERNAME'].NodeValue := Value;
end;

function TXMLQPMType.Get_DEFAULT_EXTRACT_PASSWORD: UnicodeString;
begin
  Result := ChildNodes['DEFAULT_EXTRACT_PASSWORD'].Text;
end;

procedure TXMLQPMType.Set_DEFAULT_EXTRACT_PASSWORD(Value: UnicodeString);
begin
  ChildNodes['DEFAULT_EXTRACT_PASSWORD'].NodeValue := Value;
end;

function TXMLQPMType.Get_EXTRACT_DIRECTORY: UnicodeString;
begin
  Result := ChildNodes['EXTRACT_DIRECTORY'].Text;
end;

procedure TXMLQPMType.Set_EXTRACT_DIRECTORY(Value: UnicodeString);
begin
  ChildNodes['EXTRACT_DIRECTORY'].NodeValue := Value;
end;

function TXMLQPMType.Get_LOG_DIRECTORY: UnicodeString;
begin
  Result := ChildNodes['LOG_DIRECTORY'].Text;
end;

procedure TXMLQPMType.Set_LOG_DIRECTORY(Value: UnicodeString);
begin
  ChildNodes['LOG_DIRECTORY'].NodeValue := Value;
end;

function TXMLQPMType.Get_QPM_MaxLoop: Integer;
begin
  Result := ChildNodes['QPM_MaxLoop'].NodeValue;
end;

procedure TXMLQPMType.Set_QPM_MaxLoop(Value: Integer);
begin
  ChildNodes['QPM_MaxLoop'].NodeValue := Value;
end;

function TXMLQPMType.Get_QPM_BatchBeforeXMLService: UnicodeString;
begin
  Result := ChildNodes['QPM_BatchBeforeXMLService'].Text;
end;

procedure TXMLQPMType.Set_QPM_BatchBeforeXMLService(Value: UnicodeString);
begin
  ChildNodes['QPM_BatchBeforeXMLService'].NodeValue := Value;
end;

function TXMLQPMType.Get_QPM_BatchStarting: UnicodeString;
begin
  Result := ChildNodes['QPM_BatchStarting'].Text;
end;

procedure TXMLQPMType.Set_QPM_BatchStarting(Value: UnicodeString);
begin
  ChildNodes['QPM_BatchStarting'].NodeValue := Value;
end;

function TXMLQPMType.Get_QPM_BatchDone: UnicodeString;
begin
  Result := ChildNodes['QPM_BatchDone'].Text;
end;

procedure TXMLQPMType.Set_QPM_BatchDone(Value: UnicodeString);
begin
  ChildNodes['QPM_BatchDone'].NodeValue := Value;
end;

function TXMLQPMType.Get_QPM_BatchException: UnicodeString;
begin
  Result := ChildNodes['QPM_BatchException'].Text;
end;

procedure TXMLQPMType.Set_QPM_BatchException(Value: UnicodeString);
begin
  ChildNodes['QPM_BatchException'].NodeValue := Value;
end;

function TXMLQPMType.Get_QPM_ExtractBeforeXMLService: UnicodeString;
begin
  Result := ChildNodes['QPM_ExtractBeforeXMLService'].Text;
end;

procedure TXMLQPMType.Set_QPM_ExtractBeforeXMLService(Value: UnicodeString);
begin
  ChildNodes['QPM_ExtractBeforeXMLService'].NodeValue := Value;
end;

function TXMLQPMType.Get_QPM_ExtractStarting: UnicodeString;
begin
  Result := ChildNodes['QPM_ExtractStarting'].Text;
end;

procedure TXMLQPMType.Set_QPM_ExtractStarting(Value: UnicodeString);
begin
  ChildNodes['QPM_ExtractStarting'].NodeValue := Value;
end;

function TXMLQPMType.Get_QPM_ExtractDone: UnicodeString;
begin
  Result := ChildNodes['QPM_ExtractDone'].Text;
end;

procedure TXMLQPMType.Set_QPM_ExtractDone(Value: UnicodeString);
begin
  ChildNodes['QPM_ExtractDone'].NodeValue := Value;
end;

function TXMLQPMType.Get_QPM_ExtractException: UnicodeString;
begin
  Result := ChildNodes['QPM_ExtractException'].Text;
end;

procedure TXMLQPMType.Set_QPM_ExtractException(Value: UnicodeString);
begin
  ChildNodes['QPM_ExtractException'].NodeValue := Value;
end;

function TXMLQPMType.Get_QPM_PullBeforeXMLService: UnicodeString;
begin
  Result := ChildNodes['QPM_PullBeforeXMLService'].Text;
end;

procedure TXMLQPMType.Set_QPM_PullBeforeXMLService(Value: UnicodeString);
begin
  ChildNodes['QPM_PullBeforeXMLService'].NodeValue := Value;
end;

function TXMLQPMType.Get_QPM_PullStarting: UnicodeString;
begin
  Result := ChildNodes['QPM_PullStarting'].Text;
end;

procedure TXMLQPMType.Set_QPM_PullStarting(Value: UnicodeString);
begin
  ChildNodes['QPM_PullStarting'].NodeValue := Value;
end;

function TXMLQPMType.Get_QPM_PullDone: UnicodeString;
begin
  Result := ChildNodes['QPM_PullDone'].Text;
end;

procedure TXMLQPMType.Set_QPM_PullDone(Value: UnicodeString);
begin
  ChildNodes['QPM_PullDone'].NodeValue := Value;
end;

function TXMLQPMType.Get_QPM_PullException: UnicodeString;
begin
  Result := ChildNodes['QPM_PullException'].Text;
end;

procedure TXMLQPMType.Set_QPM_PullException(Value: UnicodeString);
begin
  ChildNodes['QPM_PullException'].NodeValue := Value;
end;

function TXMLQPMType.Get_QPM_PushBeforeXMLService: UnicodeString;
begin
  Result := ChildNodes['QPM_PushBeforeXMLService'].Text;
end;

procedure TXMLQPMType.Set_QPM_PushBeforeXMLService(Value: UnicodeString);
begin
  ChildNodes['QPM_PushBeforeXMLService'].NodeValue := Value;
end;

function TXMLQPMType.Get_QPM_PushStarting: UnicodeString;
begin
  Result := ChildNodes['QPM_PushStarting'].Text;
end;

procedure TXMLQPMType.Set_QPM_PushStarting(Value: UnicodeString);
begin
  ChildNodes['QPM_PushStarting'].NodeValue := Value;
end;

function TXMLQPMType.Get_QPM_PushDone: UnicodeString;
begin
  Result := ChildNodes['QPM_PushDone'].Text;
end;

procedure TXMLQPMType.Set_QPM_PushDone(Value: UnicodeString);
begin
  ChildNodes['QPM_PushDone'].NodeValue := Value;
end;

function TXMLQPMType.Get_QPM_PushException: UnicodeString;
begin
  Result := ChildNodes['QPM_PushException'].Text;
end;

procedure TXMLQPMType.Set_QPM_PushException(Value: UnicodeString);
begin
  ChildNodes['QPM_PushException'].NodeValue := Value;
end;

function TXMLQPMType.Get_QPM_NotifyHTTP: Integer;
begin
  Result := ChildNodes['QPM_NotifyHTTP'].NodeValue;
end;

procedure TXMLQPMType.Set_QPM_NotifyHTTP(Value: Integer);
begin
  ChildNodes['QPM_NotifyHTTP'].NodeValue := Value;
end;

function TXMLQPMType.Get_QPM_OptionASPClient: Integer;
begin
  Result := ChildNodes['QPM_OptionASPClient'].NodeValue;
end;

procedure TXMLQPMType.Set_QPM_OptionASPClient(Value: Integer);
begin
  ChildNodes['QPM_OptionASPClient'].NodeValue := Value;
end;

function TXMLQPMType.Get_QPM_OptionPullGroup: Integer;
begin
  Result := ChildNodes['QPM_OptionPullGroup'].NodeValue;
end;

procedure TXMLQPMType.Set_QPM_OptionPullGroup(Value: Integer);
begin
  ChildNodes['QPM_OptionPullGroup'].NodeValue := Value;
end;

function TXMLQPMType.Get_QPM_OptionPullLoop: Integer;
begin
  Result := ChildNodes['QPM_OptionPullLoop'].NodeValue;
end;

procedure TXMLQPMType.Set_QPM_OptionPullLoop(Value: Integer);
begin
  ChildNodes['QPM_OptionPullLoop'].NodeValue := Value;
end;

function TXMLQPMType.Get_QPM_OptionPushGroup: Integer;
begin
  Result := ChildNodes['QPM_OptionPushGroup'].NodeValue;
end;

procedure TXMLQPMType.Set_QPM_OptionPushGroup(Value: Integer);
begin
  ChildNodes['QPM_OptionPushGroup'].NodeValue := Value;
end;

function TXMLQPMType.Get_QPM_OptionPushLoop: Integer;
begin
  Result := ChildNodes['QPM_OptionPushLoop'].NodeValue;
end;

procedure TXMLQPMType.Set_QPM_OptionPushLoop(Value: Integer);
begin
  ChildNodes['QPM_OptionPushLoop'].NodeValue := Value;
end;

function TXMLQPMType.Get_QPM_OptionZip: Integer;
begin
  Result := ChildNodes['QPM_OptionZip'].NodeValue;
end;

procedure TXMLQPMType.Set_QPM_OptionZip(Value: Integer);
begin
  ChildNodes['QPM_OptionZip'].NodeValue := Value;
end;

function TXMLQPMType.Get_QPM_Track: Integer;
begin
  Result := ChildNodes['QPM_Track'].NodeValue;
end;

procedure TXMLQPMType.Set_QPM_Track(Value: Integer);
begin
  ChildNodes['QPM_Track'].NodeValue := Value;
end;

function TXMLQPMType.Get_QPM_TrackZip: Integer;
begin
  Result := ChildNodes['QPM_TrackZip'].NodeValue;
end;

procedure TXMLQPMType.Set_QPM_TrackZip(Value: Integer);
begin
  ChildNodes['QPM_TrackZip'].NodeValue := Value;
end;

end.