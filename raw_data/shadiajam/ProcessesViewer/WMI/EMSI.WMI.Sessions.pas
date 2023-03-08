unit EMSI.WMI.Sessions;

interface

uses
  SysUtils,
  ActiveX,
  ComObj,
  DateUtils,
  Variants,
  System.Generics.Collections,
  EMSI.WMI.Base;

type
  TEMSI_WMISession = class(TObject)
  private
    function GetLogonTypeStr: string;
  public
    AuthenticationPackage: string;
    LogonId: string;
    LogonType: integer;
    StartTime: TDateTime;
    Domain:string;
    User:string;
    property LogonTypeStr : string read GetLogonTypeStr;
  end;

  TEMSI_WMISessionList = class(TObjectList<TEMSI_WMISession>)
  private
    procedure QueryGetData_LogonSessionInfo(WMIQuery:TEMSI_WMIQuery;WbemObject:OLEVariant);
    procedure QueryGetData_LoggedOnUserInfo(WMIQuery:TEMSI_WMIQuery;WbemObject:OLEVariant);
    function FindSessionByLogonID(LogonId: string):TEMSI_WMISession;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    procedure FillList;
  end;

implementation
uses
  RegularExpressions;


{ TEMSI_WMISession }

function TEMSI_WMISession.GetLogonTypeStr: string;
begin

  case LogonType of
    2: Result := 'Interactive logon';
    3: Result := 'Network logon';
    4: Result := 'Batch logon';
    5: Result := 'Service logon';
    7: Result := 'Unlock logon';
    8: Result := 'NetworkCleartext logon';
    9: Result := 'NewCredentials logon';
    10: Result := 'RemoteInteractive logon';
    11: Result := 'CachedInteractive logon';
    else
      Result := 'Unknown';
  end;
end;

{ TEMSI_WMISessionList }

procedure TEMSI_WMISessionList.AfterConstruction;
begin
  inherited;

end;

procedure TEMSI_WMISessionList.BeforeDestruction;
begin
  inherited;

end;

procedure TEMSI_WMISessionList.FillList;
var WMIQuery : TEMSI_WMIQuery;
begin
  try
    WMIQuery := TEMSI_WMIQuery.Create;
    WMIQuery.Query := 'SELECT * FROM Win32_LogonSession';
    WMIQuery.OnGetDataEvent := QueryGetData_LogonSessionInfo;
    WMIQuery.Execute;

    WMIQuery.Query := 'SELECT * FROM Win32_LoggedOnUser';
    WMIQuery.OnGetDataEvent := QueryGetData_LoggedOnUserInfo;
    WMIQuery.Execute;
  finally
    WMIQuery.Free;
  end;
end;

function TEMSI_WMISessionList.FindSessionByLogonID(
  LogonId: string): TEMSI_WMISession;
var I:integer;
begin
  Result:=nil;
  for I := 0 to Count-1 do
    if Items[I].LogonId = LogonId then
      exit(Items[I]);
end;


function ExtractFieldValue(const FieldName:string;const AString: string): string;
var
  RegEx: TRegEx;
  Match: TMatch;
begin
  RegEx := TRegEx.Create(FieldName+'="([^"]+)"');
  Match := RegEx.Match(AString);
  if Match.Success then
    Result := Match.Groups[1].Value
  else
    Result := '';
end;

procedure TEMSI_WMISessionList.QueryGetData_LoggedOnUserInfo(
  WMIQuery: TEMSI_WMIQuery; WbemObject: OLEVariant);
var Antecedent,         // example \\.\root\cimv2:Win32_Account.Domain="SHADI-LAPTOP",Name="shadi"
    Dependent : string; // example \\.\root\cimv2:Win32_LogonSession.LogonId="417010"
    LogonId:string;
    Domain:string;
    UserName:string;
    ASession : TEMSI_WMISession;
begin
  Antecedent:= WMIStr(WbemObject.Antecedent);
  Dependent:= WMIStr(WbemObject.Dependent);
  LogonId := ExtractFieldValue('LogonId',Dependent);
  Domain := ExtractFieldValue('Domain',Antecedent);
  UserName := ExtractFieldValue('Name',Antecedent);
  ASession := FindSessionByLogonID(LogonId);
  if ASession <> nil then
  begin
    ASession.User := UserName;
    ASession.Domain := Domain;
  end;
end;

procedure TEMSI_WMISessionList.QueryGetData_LogonSessionInfo(
  WMIQuery: TEMSI_WMIQuery; WbemObject: OLEVariant);
var ASession : TEMSI_WMISession;
begin
  ASession := TEMSI_WMISession.Create;

  ASession.LogonId := WMIStr(WbemObject.LogonId);
  ASession.AuthenticationPackage := WMIStr(WbemObject.AuthenticationPackage);
  ASession.LogonType := integer(WbemObject.LogonType);
  ASession.StartTime := WMIStrDateTimeToDateTime( WMIStr(WbemObject.StartTime));
  Add(ASession);
end;

end.
