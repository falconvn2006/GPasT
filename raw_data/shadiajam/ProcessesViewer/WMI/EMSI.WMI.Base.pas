unit EMSI.WMI.Base;

interface

uses
  SysUtils,
  ActiveX,
  ComObj,
  DateUtils,
  Variants;

Type
  TEMSI_WMIQuery = class;

  TEMSI_WMIOnQueryStartEvent = procedure(WMIQuery:TEMSI_WMIQuery) of object;
  TEMSI_WMIOnQueryGetDataEvent = procedure(WMIQuery:TEMSI_WMIQuery;WbemObject:OLEVariant) of object;
  TEMSI_WMIOnQueryEndEvent = procedure(WMIQuery:TEMSI_WMIQuery) of object;

  TEMSI_WMIQuery = class(TObject) {ToDo : inherit it from dataset}
  private
    FSWbemLocator : OLEVariant;
    FWMIService   : OLEVariant;
    FOnStartEvent : TEMSI_WMIOnQueryStartEvent;
    FOnGetDataEvent : TEMSI_WMIOnQueryGetDataEvent;
    FOnEndEvent : TEMSI_WMIOnQueryEndEvent;
    WbemUser            :string;
    WbemPassword        :string;
    WbemComputer        :string;
    WbemNameSpace : string;
    wbemFlagForwardOnly :integer;
    FQuery: String;

    procedure SetDefualts;
    procedure ConnectService;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;


    property OnStartEvent : TEMSI_WMIOnQueryStartEvent read FOnStartEvent write FOnStartEvent;
    property OnGetDataEvent : TEMSI_WMIOnQueryGetDataEvent read FOnGetDataEvent write FOnGetDataEvent;
    property OnEndEvent : TEMSI_WMIOnQueryEndEvent read FOnEndEvent write FOnEndEvent;
    property Query : String read FQuery write FQuery;

    function Execute:boolean;
  end;


function WMIStr(OleVar: OLEVariant): string;
function WMIStrDateTimeToDateTime(const StartTime: string): TDateTime;


implementation

function WMIStr(OleVar : OLEVariant) : string;
begin
  Result := '';
  if OleVar<>null  then
    Result := string(OleVar);
end;

function WMIStrDateTimeToDateTime(const StartTime: string): TDateTime;
var
  Year, Month, Day, Hour, Minute, Second: Word;
  DateStr: string;
begin
  // Extract the date and time values from the StartTime string
  Year := StrToInt(Copy(StartTime, 1, 4));
  Month := StrToInt(Copy(StartTime, 5, 2));
  Day := StrToInt(Copy(StartTime, 7, 2));
  Hour := StrToInt(Copy(StartTime, 9, 2));
  Minute := StrToInt(Copy(StartTime, 11, 2));
  Second := StrToInt(Copy(StartTime, 13, 2));

  Result := EncodeDateTime(Year, Month, Day, Hour, Minute, Second, 0);
end;

{ TEMSI_WMI_Query }

procedure TEMSI_WMIQuery.AfterConstruction;
begin
  inherited;
  SetDefualts;
  CoInitialize(nil);
  ConnectService;
end;

procedure TEMSI_WMIQuery.BeforeDestruction;
begin
  inherited;
  CoUninitialize;
end;

procedure TEMSI_WMIQuery.ConnectService;
begin
  FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  FWMIService   := FSWbemLocator.ConnectServer(WbemComputer,WbemNameSpace , WbemUser, WbemPassword);

end;

function TEMSI_WMIQuery.Execute: boolean;
var FWbemObjectSet: OLEVariant;
    FWbemObject   : OLEVariant;
    oEnum         : IEnumvariant;
    iValue        : LongWord;
begin
  FWbemObjectSet:= FWMIService.ExecQuery(Query,'WQL',wbemFlagForwardOnly);
  oEnum         := IUnknown(FWbemObjectSet._NewEnum) as IEnumVariant;
  if Assigned(FOnStartEvent) then
    FOnStartEvent(Self);

  while oEnum.Next(1, FWbemObject, iValue) = 0 do
  begin
    if Assigned(FOnGetDataEvent) then
      FOnGetDataEvent(Self,FWbemObject);
    FWbemObject:=Unassigned;
  end;

  if Assigned(FOnEndEvent) then
    FOnEndEvent(Self);

end;

procedure TEMSI_WMIQuery.SetDefualts;
begin
  WbemUser            :='';
  WbemPassword        :='';
  WbemComputer        :='localhost';
  wbemFlagForwardOnly := $00000020;
  WbemNameSpace := 'root\CIMV2';
  FSWbemLocator := null;
  FWMIService   := null;

end;

end.



procedure  GetWin32_LogonSessionInfo;
const
  WbemUser            ='';
  WbemPassword        ='';
  WbemComputer        ='localhost';
  wbemFlagForwardOnly = $00000020;
var
  FSWbemLocator : OLEVariant;
  FWMIService   : OLEVariant;
  FWbemObjectSet: OLEVariant;
  FWbemObject   : OLEVariant;
  oEnum         : IEnumvariant;
  iValue        : LongWord;
begin;
  FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  FWMIService   := FSWbemLocator.ConnectServer(WbemComputer, 'root\CIMV2', WbemUser, WbemPassword);
  FWbemObjectSet:= FWMIService.ExecQuery('SELECT * FROM Win32_LogonSession','WQL',wbemFlagForwardOnly);
  oEnum         := IUnknown(FWbemObjectSet._NewEnum) as IEnumVariant;
  while oEnum.Next(1, FWbemObject, iValue) = 0 do
  begin

    Writeln(Format('AuthenticationPackage    %s',[WMIStr(FWbemObject.AuthenticationPackage)]));// String
    Writeln(Format('Description              %s',[WMIStr(FWbemObject.Description)]));// String
    Writeln(Format('InstallDate              %s',[WMIStr(FWbemObject.InstallDate)]));// Datetime
    Writeln(Format('LogonId                  %s',[WMIStr(FWbemObject.LogonId)]));// String
    Writeln(Format('LogonType                %d',[Integer(FWbemObject.LogonType)]));// Uint32
    Writeln(Format('Name                     %s',[WMIStr(FWbemObject.Name)]));// String
    Writeln(Format('StartTime                %s',[WMIStr(FWbemObject.StartTime)]));// Datetime
    Writeln(Format('Status                   %s',[WMIStr(FWbemObject.Status)]));// String

    Writeln('');
    FWbemObject:=Unassigned;
  end;
end;

procedure  GetWin32_LoggedOnUserInfo;
const
  WbemUser            ='';
  WbemPassword        ='';
  WbemComputer        ='localhost';
  wbemFlagForwardOnly = $00000020;
var
  FSWbemLocator : OLEVariant;
  FWMIService   : OLEVariant;
  FWbemObjectSet: OLEVariant;
  FWbemObject   : OLEVariant;
  oEnum         : IEnumvariant;
  iValue        : LongWord;
begin;
  FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  FWMIService   := FSWbemLocator.ConnectServer(WbemComputer, 'root\CIMV2', WbemUser, WbemPassword);
  FWbemObjectSet:= FWMIService.ExecQuery('SELECT * FROM Win32_LoggedOnUser','WQL',wbemFlagForwardOnly);
  oEnum         := IUnknown(FWbemObjectSet._NewEnum) as IEnumVariant;
  while oEnum.Next(1, FWbemObject, iValue) = 0 do
  begin

    Writeln('Antecedent:'+WMIStr(FWbemObject.Antecedent));
    Writeln('Dependent:'+WMIStr(FWbemObject.Dependent));
    FWbemObject:=Unassigned;
  end;
end;




begin
 try
    CoInitialize(nil);
    try
      GetWin32_LogonSessionInfo;
      GetWin32_LoggedOnUserInfo;
    finally
      CoUninitialize;
    end;
 except
    on E:EOleException do
        Writeln(Format('EOleException %s %x', [E.Message,E.ErrorCode]));
    on E:Exception do
        Writeln(E.Classname, ':', E.Message);
 end;
 Writeln('Press Enter to exit');
 Readln;


