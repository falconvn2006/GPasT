unit CalDAV;

interface

{.$DEFINE DEMO}

uses
  Classes,
  Contnrs,
  Windows,
  IdHTTP,
  IdSSLOpenSSL,
  IdSSLOpenSSLHeaders,
  IdCoderQuotedPrintable,
  IdCTypes,
  IdSSL,
  IdComponent,
  IdSocks,
  XMLDoc,
  TZDB,
  IdWebDAV,
  SyncObjs,
  IdLogFile;

{$IF DECLARED(RTLVersion)}
  {$IF RTLVersion >= 22}
    {$DEFINE SUPPORTS_TTIMEZONE}
  {$IFEND}
{$IFEND}

{$IFDEF VER210}
  {$DEFINE 2010ANDLATER}
{$ENDIF}

{$IFDEF VER220}
  {$DEFINE 2010ANDLATER}
  {$DEFINE XEANDLATER}
{$ENDIF}

{$IFDEF VER230}
  {$DEFINE 2010ANDLATER}
  {$DEFINE XEANDLATER}
  {$DEFINE XE2ANDLATER}
{$ENDIF}

{$IFDEF VER240}
  {$DEFINE 2010ANDLATER}
  {$DEFINE XEANDLATER}
  {$DEFINE XE2ANDLATER}
  {$DEFINE XE3ANDLATER}
{$ENDIF}

{$IFDEF VER250}
  {$DEFINE 2010ANDLATER}
  {$DEFINE XEANDLATER}
  {$DEFINE XE2ANDLATER}
  {$DEFINE XE3ANDLATER}
  {$DEFINE XE4ANDLATER}
{$ENDIF}

{$IFDEF VER260}
  {$DEFINE 2010ANDLATER}
  {$DEFINE XEANDLATER}
  {$DEFINE XE2ANDLATER}
  {$DEFINE XE3ANDLATER}
  {$DEFINE XE4ANDLATER}
  {$DEFINE XE5ANDLATER}
{$ENDIF}

{$IFDEF VER270}
  {$DEFINE 2010ANDLATER}
  {$DEFINE XEANDLATER}
  {$DEFINE XE2ANDLATER}
  {$DEFINE XE3ANDLATER}
  {$DEFINE XE4ANDLATER}
  {$DEFINE XE5ANDLATER}
  {$DEFINE XE6ANDLATER}
{$ENDIF}

{$IFDEF VER280}
  {$DEFINE 2010ANDLATER}
  {$DEFINE XEANDLATER}
  {$DEFINE XE2ANDLATER}
  {$DEFINE XE3ANDLATER}
  {$DEFINE XE4ANDLATER}
  {$DEFINE XE5ANDLATER}
  {$DEFINE XE6ANDLATER}
  {$DEFINE XE7ANDLATER}
{$ENDIF}

type
  PDynamicTimeZoneInformation = ^TDynamicTimeZoneInformation;
  _TIME_DYNAMIC_ZONE_INFORMATION = record
    Bias: Longint;
    StandardName: array[0..31] of WCHAR;
    StandardDate: TSystemTime;
    StandardBias: Longint;
    DaylightName: array[0..31] of WCHAR;
    DaylightDate: TSystemTime;
    DaylightBias: Longint;
    TimeZoneKeyName: array[0..127] of WCHAR;
    DynamicDaylightTimeDisabled: Boolean;
  end;
  {$EXTERNALSYM _TIME_DYNAMIC_ZONE_INFORMATION}
  TDynamicTimeZoneInformation = _TIME_DYNAMIC_ZONE_INFORMATION;
  TIME_DYNAMIC_ZONE_INFORMATION = _TIME_DYNAMIC_ZONE_INFORMATION;
  {$EXTERNALSYM _TIME_DYNAMIC_ZONE_INFORMATION}

  TBundledTimeZone = TZDB.TBundledTimeZone;

  TIdWebDAV = class(IdWebDAV.TIdWebDAV)
  public
    procedure DoRequest(const AMethod: TIdHTTPMethod; AURL: string; ASource, AResponseContent: TStream;
      AIgnoreReplies: array of SmallInt); override;
  end;

  TCalDavProxyType = (ptNone, ptHTTP, ptSocks4, ptSocks5);

  TCDCalendar = class;
  TCDItem = class;

  TReminderPeriod = (rpMinutes, rpHours, rpDays, rpWeeks, rpDateTime);
  TReminderMethod = (rmPopUp, rmEmail);

  TStoreProgressEvent = procedure(Sender: TCDCalendar; Current, Total: Cardinal; var Cancel: Boolean) of object;
  TStoreErrorEvent = procedure(Sender: TCDItem; ErrorMessage: String) of object;

  TCDReminder = class
  private
    FMethod: TReminderMethod;
    FPeriod: TReminderPeriod;
    FPeriodsCount: Integer;
    FDateTime: TDateTime;
    FCalendar: TCDCalendar;
    function GetDateTimeDef: TDateTime;
    function GetDateTimeLoc: TDateTime;
    procedure SetDateTimeDef(const Value: TDateTime);
    procedure SetDateTimeLoc(const Value: TDateTime);
  public
    constructor Create(Calendar: TCDCalendar);
    property PeriodsCount: Integer read FPeriodsCount write FPeriodsCount;
    property Period: TReminderPeriod read FPeriod write FPeriod;
    property Method: TReminderMethod read FMethod write FMethod;
    property DateTime: TDateTime read FDateTime write FDateTime;
    property DateTimeInDefaultTZ: TDateTime read GetDateTimeDef write SetDateTimeDef;
    property DateTimeInLocalTZ: TDateTime read GetDateTimeLoc write SetDateTimeLoc;
  end;

  TEventPrivacy = (epDefault, epPrivate, epPublic);

  TMultigetThread = class;
  TStoreThread = class;

  TCDItem = class
  private
    FCalendar: TCDCalendar;
    FiCal: TStringList;
    FHRef: String;
    FTitle: WideString;
    FDescription: WideString;
    FStartTime: TDateTime;
    FEndTime: TDateTime;
    FLocation: WideString;
    FPrivacy: TEventPrivacy;
    FRepeatRule: String;
    FItemBegin: Integer;
    FSequence: Integer;
    FLastModified: TDateTime;
    FDTStamp: TDateTime;
    FReminders: TObjectList;
    FStartTimeTZ: TBundledTimeZone;
    FEndTimeTZ: TBundledTimeZone;
    FETag: String;
    FCustomFields: TStringList;
    FETagOnly: Boolean;
    FGetOnNextMultiget: Boolean;
    FLoaded: Boolean;
    FToDelete: Boolean;
    FToStore: Boolean;
    FStoreThread: TStoreThread;
    FStoreError: String;
    FCategories: WideString;
    FStored: Boolean;
    function GetReminderCount: Integer;
    function GetiCal: WideString;
    procedure SetiCal(const Value: WideString); virtual;
    function FindProp(const Prop: String; const Params: array of String): Integer;
    procedure SetPropValue(const Prop: String; const Params: array of String; const Value: WideString;
      const NewProp: String = '');
    procedure DeleteProp(const Prop: String);
    procedure SetTitle(const Value: WideString);
    procedure SetDescription(const Value: WideString);
    procedure SetStartTime(const Value: TDateTime); virtual; abstract;
    procedure SetLocation(const Value: WideString);
    procedure SetPrivacy(const Value: TEventPrivacy);
    procedure SetRepeatRule(const Value: String);
    procedure SetStartTimeTZ(const Value: TBundledTimeZone); virtual; abstract;
    function GetStartTimeDef: TDateTime;
    function GetStartTimeLoc: TDateTime;
    procedure SetStartTimeDef(const Value: TDateTime);
    procedure SetStartTimeLoc(const Value: TDateTime);
    function GetLastModifiedLocal: TDateTime;
    function GetLastModified: TDateTime;
    function GetID: String;
    procedure SetCategories(const Value: WideString);
  protected
    constructor Create(Calendar: TCDCalendar);
  public
    destructor Destroy; override;
    procedure Store(ABatch: Boolean = False);
    procedure Delete(ABatch: Boolean = False);
    procedure AddReminder(Value: TCDReminder);
    function GetReminder(Index: Integer): TCDReminder;
    procedure SetReminder(Index: Integer; Value: TCDReminder);
    procedure DeleteReminder(Index: Integer);
    procedure ResetStoring;
    property iCal: WideString read GetiCal write SetiCal;
    property ID: String read GetID;
    property Title: WideString read FTitle write SetTitle;
    property Description: WideString read FDescription write SetDescription;
    property Categories: WideString read FCategories write SetCategories;
    property StartTime: TDateTime read FStartTime write SetStartTime;
    property StartTimeInDefaultTZ: TDateTime read GetStartTimeDef write SetStartTimeDef;
    property StartTimeInLocalTZ: TDateTime read GetStartTimeLoc write SetStartTimeLoc;
    property StartTimeTZ: TBundledTimeZone read FStartTimeTZ write SetStartTimeTZ;
    property Location: WideString read FLocation write SetLocation;
    property Privacy: TEventPrivacy read FPrivacy write SetPrivacy;
    property RepeatRule: String read FrepeatRule write SetRepeatRule;
    property LastModified: TDateTime read GetLastModified;
    property LastModifiedInLocalTZ: TDateTime read GetLastModifiedLocal;
    property ReminderCount: Integer read GetReminderCount;
    property Calendar: TCDCalendar read FCalendar;
    property ETag: String read FEtag;
    property ETagOnly: Boolean read FETagOnly;
    property GetOnNextMultiget: Boolean read FGetOnNextMultiget write FGetOnNextMultiget;
    property CustomFields: TStringList read FCustomFields;
    property ToDelete: Boolean read FToDelete;
    property ToStore: Boolean read FToStore;
    property StoreError: String read FStoreError;
  end;

  TCDEvent = class(TCDItem)
  private
    FAllDay: Boolean;
    procedure SetiCal(const Value: WideString); override;
    procedure SetAllDay(const Value: Boolean);
    procedure SetStartTime(const Value: TDateTime); override;
    procedure SetStartTimeTZ(const Value: TBundledTimeZone); override;
    procedure SetEndTime(const Value: TDateTime);
    function GetEndTime: TDateTime;
    procedure SetEndTimeTZ(const Value: TBundledTimeZone);
    function GetEndTimeDef: TDateTime;
    function GetEndTimeLoc: TDateTime;
    procedure SetEndTimeDef(const Value: TDateTime);
    procedure SetEndTimeLoc(const Value: TDateTime);
  protected
    constructor Create(Calendar: TCDCalendar);
  public
    property AllDay: Boolean read FAllDay write SetAllDay;
    property EndTime: TDateTime read GetEndTime write SetEndTime;
    property EndTimeInDefaultTZ: TDateTime read GetEndTimeDef write SetEndTimeDef;
    property EndTimeInLocalTZ: TDateTime read GetEndTimeLoc write SetEndTimeLoc;
    property EndTimeTZ: TBundledTimeZone read FEndTimeTZ write SetEndTimeTZ;
  end;

  TCDTask = class(TCDItem)
  private
    FCompleted: Boolean;
    FPriority: Byte;
    procedure SetiCal(const Value: WideString); override;
    procedure SetStartTime(const Value: TDateTime); override;
    procedure SetStartTimeTZ(const Value: TBundledTimeZone); override;
    procedure SetDueTime(const Value: TDateTime);
    procedure SetCompleted(const Value: Boolean);
    function GetDueTime: TDateTime;
    procedure SetPriority(const Value: Byte);
    procedure SetDueTimeTZ(const Value: TBundledTimeZone);
    function GetDueTimeDef: TDateTime;
    function GetDueTimeLoc: TDateTime;
    procedure SetDueTimeDef(const Value: TDateTime);
    procedure SetDueTimeLoc(const Value: TDateTime);
  protected
    constructor Create(Calendar: TCDCalendar);
  public
    property DueTime: TDateTime read GetDueTime write SetDueTime;
    property DueTimeInDefaultTZ: TDateTime read GetDueTimeDef write SetDueTimeDef;
    property DueTimeInLocalTZ: TDateTime read GetDueTimeLoc write SetDueTimeLoc;
    property DueTimeTZ: TBundledTimeZone read FEndTimeTZ write SetDueTimeTZ;
    property Completed: Boolean read FCompleted write SetCompleted;
    property Priority: Byte read FPriority write SetPriority;
  end;

  TCDCollection = class
  private
    FName: String;
    FSupportVTODO: Boolean;
    FSupportVEVENT: Boolean;
    FURL: String;
    FCTag: String;
  public
    property Name: String read FName;
    property URL: String read FURL;
    property CTag: String read FCTag;
    property SupportVEVENT: Boolean read FSupportVEVENT;
    property SupportVTODO: Boolean read FSupportVTODO;
  end;

  TCDCalendar = class
  private
    FHTTP: TIdWebDAV;
    FSSLIO: TIdSSLIOHandlerSocketOpenSSL;
    FBaseURL: String;
    FLogFile: TIdLogFile;
    FLogFileName: WideString;
    FEvents: TObjectList;
    FItems: TObjectList;
    FTasks: TObjectList;
    FMultigetThreads: TObjectList;
    FStoreThreads: TObjectList;
    FCalendars: TObjectList;
    FDefaultTZ: TBundledTimeZone;
    FUsedExtension: String;
    FOnBatchStoreProgress: TStoreProgressEvent;
    FOnStoreError: TStoreErrorEvent;
    FCancelMultiget: Boolean;
    FCancelStore: Boolean;
    FProxyPort: Word;
    FProxyType: TCalDavProxyType;
    FProxyPassword: String;
    FProxyUsername: String;
    FProxyServer: String;
    FLoadError: Boolean;
    FCriticalSection: TCriticalSection;
    FNewCalendarType: Integer; // Flag for CreateCalendar (0 - Both; 1 - VEVENT only; 2 - VTODO only)
    procedure ApplyProxySettings(AHTTP: TIdHTTP; ASSLIO: TIdSSLIOHandlerSocketOpenSSL);
    procedure SetUserName(const Value: String);
    function GetUserName: String;
    procedure SetPassword(const Value: WideString);
    function GetPassword: WideString;
    procedure SetProxyServer(const Value: String);
    procedure SetProxyPort(const Value: Word);
    procedure SetLogFileName(const Value: WideString);
    function GetEvent(Index: Integer): TCDEvent;
    function GetTask(Index: Integer): TCDTask;
    function GetUserPrincipal: String;
    function GetCalendarHomeSet: String;
    function GetiCalendarCodeForTZ(const TZ: TBundledTimeZone): String;
    procedure SetDefaultTZ(const Value: TBundledTimeZone);
    function GetCalendarDisplayName: string;
    procedure ChangeDisplayName(URL, NewDisplayName: string);
    function EventWithHRef(const HRef: string): TCDEvent;
    function TaskWithHRef(const HRef: string): TCDTask;
    function ItemWithHRef(const HRef: string): TCDItem;
    procedure ParseMultigetResponse(const Request: string; ResponseText: string; EventsElseTasks: Boolean; LastModified: TDateTime; var Multiget: String);
    procedure InternalLoad(Request, Multiget: String; EventsElseTasks: Boolean; const OnWorkBeginEvent: TWorkBeginEvent; const OnWorkEvent: TWorkEvent; LastModified: TDateTime = 0);
    function NewItem: TCDItem;
    function GetItem(Index: Integer): TCDItem;
    procedure SetBaseURL(const Value: String);
    procedure SetProxyPassword(const Value: String);
    procedure SetProxyType(const Value: TCalDavProxyType);
    procedure SetProxyUsername(const Value: String);
  public
    constructor Create;
    destructor Destroy; override;
    function GetCalendars: TObjectList;
    function IsiCloud: Boolean;
    procedure LoadEvents(const LastModified: TDateTime = 0; const OnWorkBeginEvent: TWorkBeginEvent = nil; const OnWorkEvent: TWorkEvent = nil); overload;
    procedure LoadEvents(const StartTime, EndTime: TDateTime; const OnWorkBeginEvent: TWorkBeginEvent = nil; const OnWorkEvent: TWorkEvent = nil); overload;
    procedure LoadTasks(const LastModified: TDateTime = 0; const OnWorkBeginEvent: TWorkBeginEvent = nil; const OnWorkEvent: TWorkEvent = nil);
    procedure LoadEventsETags(const OnWorkBeginEvent: TWorkBeginEvent = nil; const OnWorkEvent: TWorkEvent = nil); overload;
    procedure LoadEventsETags(const StartTime, EndTime: TDateTime; const OnWorkBeginEvent: TWorkBeginEvent = nil; const OnWorkEvent: TWorkEvent = nil); overload;
    procedure LoadAllItemsETags(const OnWorkBeginEvent: TWorkBeginEvent = nil; const OnWorkEvent: TWorkEvent = nil);
    procedure LoadTasksETags(const OnWorkBeginEvent: TWorkBeginEvent = nil; const OnWorkEvent: TWorkEvent = nil);
    procedure MultiGetEvents(const OnWorkBeginEvent: TWorkBeginEvent = nil; const OnWorkEvent: TWorkEvent = nil); overload;
    procedure MultiGetEvents(MaxThreads: Word = 10; ItemsInThread: Word = 50; const OnWorkBeginEvent: TWorkBeginEvent = nil; const OnWorkEvent: TWorkEvent = nil); overload;
    procedure MultiGetTasks(const OnWorkBeginEvent: TWorkBeginEvent = nil; const OnWorkEvent: TWorkEvent = nil); overload;
    procedure MultiGetTasks(MaxThreads: Word = 10; ItemsInThread: Word = 50; const OnWorkBeginEvent: TWorkBeginEvent = nil; const OnWorkEvent: TWorkEvent = nil); overload;
    procedure MultiGetFromAllItemsETags(MaxThreads: Word = 10; ItemsInThread: Word = 50; const OnWorkBeginEvent: TWorkBeginEvent = nil; const OnWorkEvent: TWorkEvent = nil);
    function NewEvent: TCDEvent;
    function NewTask: TCDTask;
    procedure ClearEvents;
    procedure ClearTasks;
    procedure ClearItems;
    procedure BatchStoreEvents(MaxThreads: Integer);
    procedure BatchStoreTasks(MaxThreads: Integer);
    procedure BatchDeleteItemsInAllItemsETags(MaxThreads: Integer);
    function EventCount: Integer;
    function TaskCount: Integer;
    function ItemsCount: Integer;
    function TimeZoneAvailable(const TZID: String): Boolean;
    function LocalTimeZone: TBundledTimeZone;
    function BaseURLIsCalendar: Boolean;
    procedure CreateCalendar(const NewCalendarName: string);
    procedure CreateVEVENTCalendar(const NewCalendarName: string);
    procedure CreateVTODOCalendar(const NewCalendarName: string);
    procedure RenameCalendar(const NewCalendarName: string);
    procedure DeleteCalendar;
    procedure ResetEventsStoring;
    procedure ResetTasksStoring;
    procedure ResetItemsStoring;
    function GetCalendarCTag: string;
    procedure StopAllThreads;
    property DefaultTimeZone: TBundledTimeZone read FDefaultTZ write SetDefaultTZ;
    property Events[Index: Integer]: TCDEvent read GetEvent;
    property Tasks[Index: Integer]: TCDTask read GetTask;
    property Items[Index: Integer]: TCDItem read GetItem;
    property BaseURL: String read FBaseURL write SetBaseURL;
    property UserPrincipalURL: String read GetUserPrincipal;
    property CalendarHomeSetURL: String read GetCalendarHomeSet;
    property CalendarDisplayName: String read GetCalendarDisplayName;
    property Calendars: TObjectList read FCalendars;
    property UserName: String read GetUserName write SetUserName;
    property Password: WideString read GetPassword write SetPassword;
    property ProxyServer: String read FProxyServer write SetProxyServer;
    property ProxyPort: Word read FProxyPort write SetProxyPort;
    property ProxyType: TCalDavProxyType read FProxyType write SetProxyType;
    property ProxyUsername: String read FProxyUsername write SetProxyUsername;
    property ProxyPassword: String read FProxyPassword write SetProxyPassword;
    property LogFileName: WideString read FLogFileName write SetLogFileName;
    property OnBatchStoreProgress: TStoreProgressEvent read FOnBatchStoreProgress write FOnBatchStoreProgress;
    property OnBatchStoreError: TStoreErrorEvent read FOnStoreError write FOnStoreError;
  end;

  TStoreThread = class(TThread)
  private
    FItem: TCDItem;
    FHTTP: TIdWebDAV;
    FSSLIO: TIdSSLIOHandlerSocketOpenSSL;
    FWaitEvent: THandle;
    FBaseURL: String;
  protected
    constructor Create(AItem: TCDItem; WaitEvent: THandle);
    procedure Execute; override;
  public
    destructor Destroy; override;
  end;

  TMultigetThread = class(TThread)
  private
    FResponse: string;
    FMultiget: string;
    FCalendar: TCDCalendar;
    FHTTP: TIdWebDAV;
    FSSLIO: TIdSSLIOHandlerSocketOpenSSL;
    FWaitEvent: THandle;
    FBaseURL: String;
    procedure DoProcessResponse;
  protected
    constructor Create(Calendar: TCDCalendar; Multiget: string; WaitEvent: THandle);
    procedure Execute; override;
  public
    destructor Destroy; override;
  end;

implementation

uses
  IdException,
  IdExceptionCore,
  IdResourceStringsProtocols,
  IdGlobal,
  IdURI,
  IdGlobalProtocols,
  SysUtils,
  Variants,
  Math,
  XMLIntf,
  ActiveX,
  DateUtils;

type
  TGetDynamicTimeZoneInformation = function(var pTimeZoneInformation: TDynamicTimeZoneInformation): DWORD; stdcall;

var
  GetDynamicTimeZoneInformation_: TGetDynamicTimeZoneInformation;

{$IFNDEF SUPPORTS_TTIMEZONE}
function GetDateTimeForBiasSystemTime(GivenDateTime: TSystemTime; GivenYear: Integer): TDateTime;
var
  Year, Month, Day: Word;
  Hour, Minute, Second, MilliSecond: Word;
begin
  GivenDateTime.wYear := GivenYear;
  while not TryEncodeDayOfWeekInMonth(GivenDateTime.wYear, GivenDateTime.wMonth, GivenDateTime.wDay,
    GivenDateTime.wDayOfWeek, Result) do
    Dec(GivenDateTime.wDay);
  DecodeDateTime(Result, Year, Month, Day, Hour, Minute, Second, MilliSecond);
  Result := EncodeDateTime(Year, Month, Day, GivenDateTime.wHour, GivenDateTime.wMinute,
    GivenDateTime.wSecond, GivenDateTime.wMilliseconds);
end;

function GetBiasForDate(GivenDateTime: TDateTime): Integer;
var
  tzi: TIME_ZONE_INFORMATION;
begin
  GetTimeZoneInformation(tzi);
  if tzi.StandardDate.wMonth = 0 then
    Result := -tzi.Bias
  else if tzi.StandardDate.wMonth > tzi.DaylightDate.wMonth then
    if (GivenDateTime < GetDateTimeForBiasSystemTime(tzi.StandardDate, YearOf(GivenDateTime))) and
      (GivenDateTime >= GetDateTimeForBiasSystemTime(tzi.DaylightDate, YearOf(GivenDateTime))) then
      Result := -tzi.Bias - tzi.DaylightBias
    else
      Result := -tzi.Bias - tzi.StandardBias
  else if (GivenDateTime >= GetDateTimeForBiasSystemTime(tzi.StandardDate, YearOf(GivenDateTime))) and
    (GivenDateTime < GetDateTimeForBiasSystemTime(tzi.DaylightDate, YearOf(GivenDateTime))) then
    Result := -tzi.Bias - tzi.StandardBias
  else
    Result := -tzi.Bias - tzi.DaylightBias;
end;
{$ENDIF}

// Converts local date-time to UTC
function LocalDateTimeToUTC(Local: TDateTime): TDateTime;
begin
{$IFNDEF SUPPORTS_TTIMEZONE}
  Result := IncMinute(Local, -GetBiasForDate(Local));
{$ELSE}
  Result := DateUtils.TTimeZone.Local.ToUniversalTime(Local);
{$ENDIF}
end;

// Converts UTC date-time to local
function UTCDateTimeToLocal(UTC: TDateTime): TDateTime;
begin
{$IFNDEF SUPPORTS_TTIMEZONE}
  Result := IncMinute(UTC, GetBiasForDate(UTC));
{$ELSE}
  Result := DateUtils.TTimeZone.Local.ToLocalTime(UTC);
{$ENDIF}
end;

function ExtractServerName(const URL: String): String;
begin
  Result := Copy(URL, Pos('://', URL) + 3, MaxInt);
  if Pos('/', Result) <> 0 then
    Result := Copy(Result, 1, Pos('/', Result) - 1);
end;

function ExtractServerWProtocolName(const URL: String): String;
begin
  Result := '';
  if Pos('://', URL) = 0 then
    Exit;
  Result := Copy(URL, 1, Pos('://', URL) + 2) + ExtractServerName(URL);
end;

function FileNameOnly(const URL: String): String;
begin
  Result := URL;
  while (Pos('/', Result) > 0) do
    if Pos('/', Result) < Length(Result) then
      Result := Copy(Result, Pos('/', Result) + 1, MaxInt)
    else
      Result := '';
end;

function FileNameNoExt(const FileName: String): String;
begin
  Result := FileName;
  with TStringList.Create do
  try
    Delimiter := '.';
    DelimitedText := FileName;
    if Count < 2 then
      Exit;
    Delete(Count - 1);
    Result := DelimitedText;
  finally
    Free;
  end;
end;

function iCalDateToDateTime(const S: String): TDateTime;

  function StrToDate(const Str: String): TDateTime;
  begin
    Result := 0;
    if Length(Str) >= 8 then
      if Pos('-', Str) = 5 then
        Result := EncodeDate(StrToInt(Copy(Str, 1, 4)), StrToInt(Copy(Str, 6, 2)), StrToInt(Copy(Str, 9, 2)))
      else
        Result := EncodeDate(StrToInt(Copy(Str, 1, 4)), StrToInt(Copy(Str, 5, 2)), StrToInt(Copy(Str, 7, 2)));
  end;

  function StrToTime(const Str: String): TDateTime;
  begin
    Result := 0;
    if Length(Str) >= 6 then
      if Pos(':', Str) = 3 then
        Result := EncodeTime(StrToInt(Copy(Str, 1, 2)), StrToInt(Copy(Str, 4, 2)), StrToInt(Copy(Str, 7, 2)), 0)
      else
        Result := EncodeTime(StrToInt(Copy(Str, 1, 2)), StrToInt(Copy(Str, 3, 2)), StrToInt(Copy(Str, 5, 2)), 0);
  end;

  function DecodeDuration(const Str: String): TDateTime;
  var
    P: PChar;
    S: String;
  begin
    Result := 0;
    if Str = '' then
      Exit;
    S := '';
    P := @Str[1];
    while P^ <> #0 do
    begin
      if P^ in ['0'..'9'] then
        S := S + P^
      else
      if S <> '' then
      begin
        case P^ of
          'W': Result := Result + StrToInt(S) * 7;
          'D': Result := Result + StrToInt(S);
          'H': Result := Result + StrToInt(S) / 24;
          'M': Result := Result + StrToInt(S) / 24 / 60;
          'S': Result := Result + StrToInt(S) / 24 / 60 / 60;
        end;
        S := '';
      end;
      Inc(P);
    end;
  end;

var
  P, T: Integer;
begin
  Result := 0;
  if S = '' then
    Exit;
  P := Pos('P', S);
  T := Pos('T', S);
  if P <> 0 then
  begin
    Result := DecodeDuration(Copy(S, P + 1, MaxInt));
    if S[1] = '-' then
      Result := -Result;
  end
  else
  begin
    if T = 0 then
      if (Length(S) = 8) or (Length(S) = 10) then
        Result := StrToDate(S)
      else
        Result := StrToTime(S)
    else
      Result := StrToDate(S) + StrToTime(Copy(S, T + 1, MaxInt));
  end;
end;

function DateTimeToiCalDate(DateTime: TDateTime; TimeOnly: Boolean = False): String;

  function EncodeDuration(DateTime: TDateTime): String;
  var
    I: Integer;
  begin
    Result := 'P';
    if DateTime < 0 then
    begin
      Result := '-' + Result;
      DateTime := -DateTime;
    end;
    DateTime := DateTime + OneMillisecond;
    I := Trunc(DateTime / 7);
    if I <> 0 then
      Result := Result + 'W' + IntToStr(I);
    DateTime := DateTime - I * 7;
    I := Trunc(DateTime);
    if I <> 0 then
      Result := Result + 'D' + IntToStr(I);
    DateTime := (DateTime - I) * 24;
    I := Trunc(DateTime);
    if I <> 0 then
      Result := Result + 'H' + IntToStr(I);
    DateTime := (DateTime - I) * 60;
    I := Trunc(DateTime);
    if I <> 0 then
      Result := Result + 'M' + IntToStr(I);
    I := Round((DateTime - I) * 60);
    if I <> 0 then
      Result := Result + 'S' + IntToStr(I);
  end;

begin
  if (Abs(DateTime) < 365) and not TimeOnly then
    Result := EncodeDuration(DateTime)
  else
  begin
    Result := FormatDateTime('yyyymmdd', DateTime);
    if (Frac(DateTime) <> 0) or TimeOnly then
      Result := Result + FormatDateTime('"T"hhnnss', DateTime);
  end;
end;

function EncodeDate(Value: TDateTime): String;
begin
  Result := FormatDateTime('yyyymmdd', Value);
end;

function GetPropertyName(const iCalStr: WideString): String;
var
  I: Integer;
begin
  I := Pos(';', iCalStr) - 1;
  if I < 0 then
    I := MaxInt;
  Result := UpperCase(Copy(iCalStr, 1, Min(I, Pos(':', iCalStr) - 1)));
end;

function GetValue(const iCalStr: WideString): WideString;

  function QPDecode(const QPString: String): String;
  begin
    Result := TIdDecoderQuotedPrintable.DecodeString(QPString);
  end;

var
  TempStr: String;
  SemiPos, I: Integer;
  Quoted: Boolean;
begin
  SemiPos := 0;
  Quoted := false;
  for I := 1 to Length(iCalStr) do
    if (iCalStr[I] = '"') or (iCalStr[I] = '''') then
      Quoted := not Quoted
    else
    if (not Quoted) and (iCalStr[I] = ':') then
    begin
      SemiPos := I;
      Break;
    end;
  if Pos(WideString('QUOTED-PRINTABLE'), iCalStr) = 0 then
    TempStr := Copy(iCalStr, SemiPos + 1, MaxInt)
  else
    TempStr := UTF8Decode(QPDecode(Copy(iCalStr, SemiPos + 1, MaxInt)));
  TempStr := StringReplace(TempStr, '\n', #13#10, [rfReplaceAll]);
  TempStr := StringReplace(TempStr, '\\', '<&bs>', [rfReplaceAll]);
  TempStr := StringReplace(TempStr, '\', '', [rfReplaceAll]);
  TempStr := StringReplace(TempStr, '<&bs>', '\', [rfReplaceAll]);
  Result := TempStr;
end;

function GetParams(const iCalStr: WideString): String;
var
  I: Integer;
begin
  Result := '';
  I := Pos(';', iCalStr);
  if I = 0 then
    Exit;
  Result := Copy(iCalStr, I + 1, Pos(':', iCalStr) - I - 1);
end;

function GetDateTime(const iCalStr: String): TDateTime;
var
  S: String;
begin
  Result := 0;
  S := GetValue(iCalStr);
  if S = '' then
    Exit;
  Result := iCalDateToDateTime(S);
end;

function SetTrigger(Period: TReminderPeriod; Count: Integer): String;
begin
  case Period of
    rpWeeks: Result := '-P' + IntToStr(Count * 7) + 'D';
    rpDays: Result := '-P' + IntToStr(Count) + 'D';
    rpHours: Result := '-PT' + IntToStr(Count) + 'H';
    rpMinutes: Result := '-PT' + IntToStr(Count) + 'M';
  end;
end;

procedure GetTrigger(const iCalStr: WideString; const Reminder: TCDReminder);
var
  DT: TDateTime;
begin
  DT := GetDateTime(iCalStr);
  Reminder.PeriodsCount := DaysBetween(DT, 0);
  if (Reminder.PeriodsCount > 0) and (Reminder.PeriodsCount mod 7 = 0) then
  begin
    Reminder.Period := rpWeeks;
    Reminder.PeriodsCount := Reminder.PeriodsCount div 7;
    Exit;
  end;
  if Reminder.PeriodsCount > 0 then
  begin
    Reminder.Period := rpDays;
    Exit;
  end;
  Reminder.PeriodsCount := HoursBetween(DT, 0);
  if Reminder.PeriodsCount > 0 then
  begin
    Reminder.Period := rpHours;
    Exit;
  end;
  Reminder.PeriodsCount := MinutesBetween(DT, 0);
  Reminder.Period := rpMinutes;
end;

procedure TCDCalendar.LoadEvents(const LastModified: TDateTime = 0; const OnWorkBeginEvent: TWorkBeginEvent = nil; const OnWorkEvent: TWorkEvent = nil);
var
  Request: String;
begin
  Request :=
    '<?xml version="1.0" encoding="UTF-8"?>' + #13#10 +
    '<C:calendar-query xmlns:D="DAV:" xmlns:C="urn:ietf:params:xml:ns:caldav">' + #13#10 +
    '  <D:prop>' + #13#10 +
    '    <D:getetag/>' + #13#10 +
    '    <D:getlastmodified/>' + #13#10 +
    '  </D:prop>' + #13#10 +
    '  <C:filter>' + #13#10 +
    '   <C:comp-filter name="VCALENDAR">' + #13#10 +
    '     <C:comp-filter name="VEVENT"/>' + #13#10 +
    '   </C:comp-filter>' + #13#10 +
    '  </C:filter>' + #13#10 +
    '</C:calendar-query>';
  FEvents.Clear;
  InternalLoad(Request, '', True, OnWorkBeginEvent, OnWorkEvent, LastModified);
end;

procedure TCDCalendar.LoadAllItemsETags(const OnWorkBeginEvent: TWorkBeginEvent;
  const OnWorkEvent: TWorkEvent);
var
  Request: String;
  Req, Resp: TStringStream;
  XMLDoc: TXMLDocument;
  Node: IXMLNode;
  I: Integer;
  lHRef, lETag: String;
  NewItem: TCDItem;
  lLastModified: TDateTime;
begin
  Request :=
    '<?xml version="1.0" encoding="UTF-8"?>' + #13#10 +
    '<D:propfind xmlns:D="DAV:" xmlns:C="urn:ietf:params:xml:ns:caldav">' + #13#10 +
    '  <D:prop>' + #13#10 +
    '    <D:getetag/>' + #13#10 +
    '    <D:getlastmodified/>' + #13#10 +
    '  </D:prop>' + #13#10 +
    '</D:propfind>';
  FItems.Clear;
  Req := TStringStream.Create(Request);
  Resp := TStringStream.Create('');
  XMLDoc := TXMLDocument.Create(FHTTP);
  if Trim(FBaseURL) = '' then
    raise Exception.Create('Base URL can not be empty');
  try
    try
      FHTTP.Disconnect;
      FHTTP.Request.ContentType := 'application/xml; charset=utf-8';
      Req.Position := 0;
      if Assigned(OnWorkBeginEvent) then
        FHTTP.OnWorkBegin := OnWorkBeginEvent;
      if Assigned(OnWorkEvent) then
        FHTTP.OnWork := OnWorkEvent;
      try
        FHTTP.DAVPropFind(FBaseURL, Req, Resp, '1');
      except
        on E: EIdConnClosedGracefully do
          Exit;
        else
          raise;
      end;
      if FHTTP.ResponseCode div 100 <> 2 then
        raise Exception.Create(FHTTP.ResponseText);
    finally
      FHTTP.OnWorkBegin := nil;
      FHTTP.OnWork := nil;
    end;
{$IFNDEF 2010ANDLATER}
    XMLDoc.XML.Text := Resp.DataString;
{$ELSE}
    XMLDoc.XML.Text := UTF8ToWideString(Resp.DataString);
{$ENDIF}
    XMLDoc.Active := True;
    if XMLDoc.DocumentElement <> nil then
      with XMLDoc.DocumentElement do
        for I := 0 to ChildNodes.Count - 1 do
          with ChildNodes[I] do
            if ChildNodes.FindNode('propstat', 'DAV:') <> nil then
            begin
              lHRef := ChildNodes['href'].Text;
              if FileNameOnly(lHRef) = '' then
                Continue;
              Node := ChildNodes['propstat'].ChildNodes['prop'].ChildNodes.FindNode('getlastmodified', 'DAV:');
              if Node <> nil then
                lLastModified := StrInternetToDateTime(Node.Text)
              else
                lLastModified := 0;
              Node := ChildNodes['propstat'].ChildNodes['prop'].ChildNodes.FindNode('getetag', 'DAV:');
              if Node <> nil then
                lETag := Node.Text
              else
                lETag := '';
              if Pos('.eml', LowerCase(lHRef)) <> 0 then
                FUsedExtension := '.eml'
              else
                FUsedExtension := '.ics';
              NewItem := Self.NewItem;
              if NewItem = nil then
                Continue;
              with NewItem do
              begin
                FHRef := lHRef;
                FLastModified := lLastModified;
                FETag := lETag;
              end;
            end;
  finally
    XMLDoc.Free;
    Resp.Free;
    Req.Free;
  end;
end;

procedure TCDCalendar.LoadEvents(const StartTime, EndTime: TDateTime;
  const OnWorkBeginEvent: TWorkBeginEvent; const OnWorkEvent: TWorkEvent);
var
  Request: String;
begin
  Request :=
    '<?xml version="1.0" encoding="UTF-8"?>' + #13#10 +
    '<C:calendar-query xmlns:D="DAV:" xmlns:C="urn:ietf:params:xml:ns:caldav">' + #13#10 +
    '  <D:prop>' + #13#10 +
    '    <D:getetag/>' + #13#10 +
    '    <D:getlastmodified/>' + #13#10 +
    '  </D:prop>' + #13#10 +
    '  <C:filter>' + #13#10 +
    '   <C:comp-filter name="VCALENDAR">' + #13#10 +
    '     <C:comp-filter name="VEVENT">' + #13#10 +
    '       <C:time-range start="' + DateTimeToiCalDate(StartTime, True) + '" end="' + DateTimeToiCalDate(EndTime, True) + '"/>' + #13#10 +
    '     </C:comp-filter>' + #13#10 +
    '   </C:comp-filter>' + #13#10 +
    '  </C:filter>' + #13#10 +
    '</C:calendar-query>';
  FEvents.Clear;
  InternalLoad(Request, '', True, OnWorkBeginEvent, OnWorkEvent);
end;

procedure TCDCalendar.LoadEventsETags(const StartTime, EndTime: TDateTime;
  const OnWorkBeginEvent: TWorkBeginEvent; const OnWorkEvent: TWorkEvent);
var
  Request: String;
begin
  Request :=
    '<?xml version="1.0" encoding="UTF-8"?>' + #13#10 +
    '<C:calendar-query xmlns:D="DAV:" xmlns:C="urn:ietf:params:xml:ns:caldav">' + #13#10 +
    '  <D:prop>' + #13#10 +
    '    <D:getetag/>' + #13#10 +
    '    <D:getlastmodified/>' + #13#10 +
    '  </D:prop>' + #13#10 +
    '  <C:filter>' + #13#10 +
    '   <C:comp-filter name="VCALENDAR">' + #13#10 +
    '     <C:comp-filter name="VEVENT">' + #13#10 +
    '       <C:time-range start="' + DateTimeToiCalDate(StartTime, True) + '" end="' + DateTimeToiCalDate(EndTime, True) + '"/>' + #13#10 +
    '     </C:comp-filter>' + #13#10 +
    '   </C:comp-filter>' + #13#10 +
    '  </C:filter>' + #13#10 +
    '</C:calendar-query>';
  FEvents.Clear;
  InternalLoad(Request, 'none', True, OnWorkBeginEvent, OnWorkEvent);
end;

procedure TCDCalendar.LoadEventsETags(const OnWorkBeginEvent: TWorkBeginEvent;
  const OnWorkEvent: TWorkEvent);
var
  Request: String;
begin
  Request :=
    '<?xml version="1.0" encoding="UTF-8"?>' + #13#10 +
    '<C:calendar-query xmlns:D="DAV:" xmlns:C="urn:ietf:params:xml:ns:caldav">' + #13#10 +
    '  <D:prop>' + #13#10 +
    '    <D:getetag/>' + #13#10 +
    '    <D:getlastmodified/>' + #13#10 +
    '  </D:prop>' + #13#10 +
    '  <C:filter>' + #13#10 +
    '   <C:comp-filter name="VCALENDAR">' + #13#10 +
    '     <C:comp-filter name="VEVENT"/>' + #13#10 +
    '   </C:comp-filter>' + #13#10 +
    '  </C:filter>' + #13#10 +
    '</C:calendar-query>';
  FEvents.Clear;
  InternalLoad(Request, 'none', True, OnWorkBeginEvent, OnWorkEvent);
end;

{ TCDCalendar }

procedure TCDCalendar.ApplyProxySettings(AHTTP: TIdHTTP;
  ASSLIO: TIdSSLIOHandlerSocketOpenSSL);
begin
  AHTTP.ProxyParams.ProxyServer := '';
  AHTTP.ProxyParams.ProxyPort := 0;
  AHTTP.ProxyParams.ProxyUsername := '';
  AHTTP.ProxyParams.ProxyPassword := '';
  AHTTP.ProxyParams.BasicAuthentication := False;
  ASSLIO.TransparentProxy := nil;
  if FProxyType = ptNone then
    Exit;
  if Trim(FProxyServer) = '' then
    Exit;
  if FProxyPort = 0 then
    Exit;
  if FProxyType = ptHTTP then
  begin
    AHTTP.ProxyParams.ProxyServer := FProxyServer;
    AHTTP.ProxyParams.ProxyPort := FProxyPort;
    if Trim(FProxyUsername) <> '' then
    begin
      AHTTP.ProxyParams.ProxyUsername := FProxyUsername;
      AHTTP.ProxyParams.ProxyPassword := FProxyPassword;
      AHTTP.ProxyParams.BasicAuthentication := True;
    end;
  end
  else
  begin
    ASSLIO.TransparentProxy := TIdSocksInfo.Create(nil);
    with TIdSocksInfo(ASSLIO.TransparentProxy) do
    begin
      if FProxyType = ptSocks4 then
        Version := svSocks4
      else
        Version := svSocks5;
      Host := FProxyServer;
      Port := FProxyPort;
      if Trim(FProxyUsername) <> '' then
      begin
        Username := FProxyUsername;
        Password := FProxyPassword;
        Authentication := saUsernamePassword;
      end;
    end;
  end;
end;

function TCDCalendar.BaseURLIsCalendar: Boolean;
var
  Req, Resp: TStringStream;
  XMLDoc: TXMLDocument;
begin
  Result := False;
  Req := TStringStream.Create(
    '<?xml version="1.0" encoding="utf-8" ?>' +
    '<D:propfind xmlns:D="DAV:">' +
    ' <D:prop>' +
    '  <D:resourcetype/>' +
    ' </D:prop>' +
    '</D:propfind>');
  Resp := TStringStream.Create('');
  XMLDoc := TXMLDocument.Create(FHTTP);
  try
    try
      FHTTP.Disconnect;
      FHTTP.Request.ContentType := 'application/xml; charset=utf-8';
      Req.Position := 0;
      try
        FHTTP.DAVPropFind(FBaseURL, Req, Resp, '0');
      except
        on E: EIdConnClosedGracefully do
          Exit;
        else
          raise;
      end;
      if FHTTP.ResponseCode div 100 <> 2 then
        raise Exception.Create(FHTTP.ResponseText);
      XMLDoc.XML.Text := Resp.DataString;
      XMLDoc.Active := True;
      if XMLDoc.DocumentElement <> nil then
        with XMLDoc.DocumentElement do
            with ChildNodes[0] do
            begin
              if ChildNodes.FindNode('propstat', 'DAV:') <> nil then
                if ChildNodes['propstat'].ChildNodes['prop'].ChildNodes.FindNode('resourcetype',
                  'DAV:') <> nil then
                    Result := ChildNodes['propstat'].ChildNodes['prop'].ChildNodes.FindNode('resourcetype',
                  'DAV:').ChildNodes.FindNode('calendar', 'urn:ietf:params:xml:ns:caldav') <> nil;
            end;
    except
      on E: EIdSocksError do
        raise;
      on E: EIdReadTimeout do
        raise;
      else
        exit;
    end;
  finally
    XMLDoc.Free;
    Resp.Free;
    Req.Free;
  end;
end;

procedure TCDCalendar.BatchDeleteItemsInAllItemsETags(MaxThreads: Integer);
var
  Queue, LastQueue, I: Integer;
  Total, Current: Cardinal;
  WaitEvent: THandle;
begin
  FCancelStore := False;
  WaitEvent := CreateEvent(nil, False, False, nil);
  try
    LastQueue := 0;
    repeat
      ResetEvent(WaitEvent);
      Queue := 0;
      Total := 0;
      Current := 0;
      for I := 0 to FItems.Count - 1 do
        if Items[I].FStoreThread = nil then
        begin
          if Items[I].FToDelete then
          begin
            Inc(Total);
            if Items[I].FStoreError = '' then
            begin
              if LastQueue < MaxThreads then
              begin
                Inc(Queue);
                Inc(LastQueue);
                Items[I].FStoreThread := TStoreThread.Create(Items[I], WaitEvent);
                FCriticalSection.Enter;
                try
                  FStoreThreads.Add(Items[I].FStoreThread);
                finally
                  FCriticalSection.Leave;
                end;
              end;
            end
            else
              Inc(Current);
          end;
        end
        else
        begin
          Inc(Queue);
          if Items[I].FToDelete then
          begin
            Inc(Total);
            if Items[I].FStoreError <> '' then
              Inc(Current);
          end;
        end;
      LastQueue := Queue;
      if Assigned(FOnBatchStoreProgress) then
        FOnBatchStoreProgress(Self, Current, Total, FCancelStore);
      if Queue > 0 then
        WaitForSingleObject(WaitEvent, INFINITE);
      for I := FItems.Count - 1 downto 0 do
        if (Items[I].FStoreError <> '') and (Items[I].FStoreError <> 'OK') then
        begin
          if Assigned(FOnStoreError) then
            FOnStoreError(Items[I], Items[I].FStoreError)
          else
            raise Exception.Create(Items[I].FStoreError);
        end;
    until (Queue = 0) or (FCancelStore);
  finally
    while Queue > 0 do
    begin
      WaitForSingleObject(WaitEvent, INFINITE);
      ResetEvent(WaitEvent);
      Queue := 0;
      for I := FItems.Count - 1 downto 0 do
        if Items[I].FStoreThread <> nil then
          Inc(Queue);
    end;
    CloseHandle(WaitEvent);
    for I := FItems.Count - 1 downto 0 do
      if Items[I].FStoreError = 'OK' then
      begin
        Items[I].FStoreError := '';
        Items[I].FToStore := False;
        if Items[I].FToDelete then
          FItems.Delete(I);
      end;
  end;
end;

procedure TCDCalendar.BatchStoreEvents(MaxThreads: Integer);
var
  Queue, LastQueue, I: Integer;
  Total, Current: Cardinal;
  WaitEvent: THandle;
begin
  FCancelStore := False;
  WaitEvent := CreateEvent(nil, False, False, nil);
  try
    LastQueue := 0;
    repeat
      ResetEvent(WaitEvent);
      Queue := 0;
      Total := 0;
      Current := 0;
      for I := 0 to FEvents.Count - 1 do
        if Events[I].FStoreThread = nil then
        begin
          if Events[I].FToStore or Events[I].FToDelete then
          begin
            Inc(Total);
            if Events[I].FStoreError = '' then
            begin
              if LastQueue < MaxThreads then
              begin
                Inc(Queue);
                Inc(LastQueue);
                Events[I].FStoreThread := TStoreThread.Create(Events[I], WaitEvent);
                FCriticalSection.Enter;
                try
                  FStoreThreads.Add(Events[I].FStoreThread);
                finally
                  FCriticalSection.Leave;
                end;
              end;
            end
            else
              Inc(Current);
          end;
        end
        else
        begin
          Inc(Queue);
          if Events[I].FToStore or Events[I].FToDelete then
          begin
            Inc(Total);
            if Events[I].FStoreError <> '' then
              Inc(Current);
          end;
        end;
      LastQueue := Queue;
      if Assigned(FOnBatchStoreProgress) then
        FOnBatchStoreProgress(Self, Current, Total, FCancelStore);
      if Queue > 0 then
        WaitForSingleObject(WaitEvent, INFINITE);
      for I := FEvents.Count - 1 downto 0 do
        if (Events[I].FStoreError <> '') and (Events[I].FStoreError <> 'OK') then
        begin
          if Assigned(FOnStoreError) then
            FOnStoreError(Events[I], Events[I].FStoreError)
          else
            raise Exception.Create(Events[I].FStoreError);
        end;
    until (Queue = 0) or (FCancelStore);
  finally
    while Queue > 0 do
    begin
      WaitForSingleObject(WaitEvent, INFINITE);
      ResetEvent(WaitEvent);
      Queue := 0;
      for I := FEvents.Count - 1 downto 0 do
        if Events[I].FStoreThread <> nil then
          Inc(Queue);
    end;
    CloseHandle(WaitEvent);
    for I := FEvents.Count - 1 downto 0 do
      if Events[I].FStoreError = 'OK' then
      begin
        Events[I].FStoreError := '';
        Events[I].FToStore := False;
        if Events[I].FToDelete then
          FEvents.Delete(I);
      end;
  end;
end;

procedure TCDCalendar.BatchStoreTasks(MaxThreads: Integer);
var
  Queue, LastQueue, I: Integer;
  Total, Current: Cardinal;
  WaitEvent: THandle;
begin
  FCancelStore := False;
  WaitEvent := CreateEvent(nil, False, False, nil);
  try
    LastQueue := 0;
    repeat
      ResetEvent(WaitEvent);
      Queue := 0;
      Total := 0;
      Current := 0;
      for I := 0 to FTasks.Count - 1 do
        if Tasks[I].FStoreThread = nil then
        begin
          if Tasks[I].FToStore or Tasks[I].FToDelete then
          begin
            Inc(Total);
            if Tasks[I].FStoreError = '' then
            begin
              if LastQueue < MaxThreads then
              begin
                Inc(Queue);
                Inc(LastQueue);
                Tasks[I].FStoreThread := TStoreThread.Create(Tasks[I], WaitEvent);
                FCriticalSection.Enter;
                try
                  FStoreThreads.Add(Tasks[I].FStoreThread);
                finally
                  FCriticalSection.Leave;
                end;
              end;
            end
            else
              Inc(Current);
          end;
        end
        else
        begin
          Inc(Queue);
          if Tasks[I].FToStore or Tasks[I].FToDelete then
          begin
            Inc(Total);
            if Tasks[I].FStoreError <> '' then
              Inc(Current);
          end;
        end;
      LastQueue := Queue;
      if Assigned(FOnBatchStoreProgress) then
        FOnBatchStoreProgress(Self, Current, Total, FCancelStore);
      if Queue > 0 then
        WaitForSingleObject(WaitEvent, INFINITE);
      for I := FTasks.Count - 1 downto 0 do
        if (Tasks[I].FStoreError <> '') and (Tasks[I].FStoreError <> 'OK') then
        begin
          if Assigned(FOnStoreError) then
            FOnStoreError(Tasks[I], Tasks[I].FStoreError)
          else
            raise Exception.Create(Tasks[I].FStoreError);
        end;
      Dec(LastQueue);
    until (Queue = 0) or (FCancelStore);
  finally
    while Queue > 0 do
    begin
      WaitForSingleObject(WaitEvent, INFINITE);
      ResetEvent(WaitEvent);
      Queue := 0;
      for I := FTasks.Count - 1 downto 0 do
        if Tasks[I].FStoreThread <> nil then
          Inc(Queue);
    end;
    CloseHandle(WaitEvent);
    for I := FTasks.Count - 1 downto 0 do
      if Tasks[I].FStoreError = 'OK' then
      begin
        Tasks[I].FStoreError := '';
        Tasks[I].FToStore := False;
        if Tasks[I].FToDelete then
          FTasks.Delete(I);
      end;
  end;
end;

procedure TCDCalendar.ChangeDisplayName(URL, NewDisplayName: string);
var
  Req: TStringStream;
  XMLDoc: TXMLDocument;
begin
  XMLDoc := TXMLDocument.Create(FHTTP);
  try
    XMLDoc.XML.Text :=
      '<?xml version="1.0" encoding="UTF-8"?>' + #13#10 +
      '<D:propertyupdate xmlns:D="DAV:">' + #13#10 +
      '  <D:set>' + #13#10 +
      '    <D:prop>' + #13#10 +
      '      <D:displayname/>' + #13#10 +
      '    </D:prop>' + #13#10 +
      '  </D:set>' + #13#10 +
      '</D:propertyupdate>';
    XMLDoc.Active := True;
    XMLDoc.DocumentElement.ChildNodes['set'].ChildNodes['prop'].ChildNodes['displayname'].Text := NewDisplayName;
{$IFDEF 2010ANDLATER}
    Req := TStringStream.Create(Utf8Encode(XMLDoc.XML.Text));
{$ELSE}
    Req := TStringStream.Create(XMLDoc.XML.Text);
{$ENDIF}
    try
      FHTTP.Disconnect;
      FHTTP.Request.ContentType := 'application/xml; charset=utf-8';
      Req.Position := 0;
      FHTTP.DoRequest('PROPPATCH', URL, Req, nil, []);
      if FHTTP.ResponseCode div 100 <> 2 then
        raise Exception.Create(FHTTP.ResponseText);
    finally
      Req.Free;
    end;
  finally
    XMLDoc.Free;
  end;
end;

procedure TCDCalendar.ClearEvents;
begin
  FEvents.Clear;
end;

procedure TCDCalendar.ClearItems;
begin
  FItems.Clear;
end;

procedure TCDCalendar.ClearTasks;
begin
  FTasks.Clear;
end;

constructor TCDCalendar.Create;
begin
  inherited Create;
  FCriticalSection := TCriticalSection.Create;
  FCalendars := TObjectList.Create(True);
  FEvents := TObjectList.Create;
  FTasks := TObjectList.Create;
  FItems := TObjectList.Create;
  FMultigetThreads := TObjectList.Create(False);
  FStoreThreads := TObjectList.Create(False);
  FHTTP := TIdWebDAV.Create(nil);
  FSSLIO := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  FHTTP.IOHandler := FSSLIO;
  FHTTP.AllowCookies := True;
  FHTTP.HandleRedirects := True;
  FHTTP.RedirectMaximum := 4;
  FHTTP.ConnectTimeout := 30000;
  FHTTP.ReadTimeout := 600000;
  FHTTP.Request.UserAgent := 'Mozilla/5.0';
  FHTTP.HTTPOptions := [hoForceEncodeParams, hoInProcessAuth];
  FHTTP.IOHandler.RecvBufferSize := 50 * 1024;
  FHTTP.IOHandler.SendBufferSize := 50 * 1024;
  FDefaultTZ := LocalTimeZone;
end;

destructor TCDCalendar.Destroy;
begin
  StopAllThreads;
  FSSLIO.Free;
  FHTTP.Free;
  FLogFile.Free;
  FStoreThreads.Free;
  FMultigetThreads.Free;
  FEvents.Free;
  FTasks.Free;
  FItems.Free;
  FCalendars.Free;
  FCriticalSection.Free;
  inherited;
end;

function TCDCalendar.GetUserName: String;
begin
  Result := FHTTP.Request.Username;
end;

function TCDCalendar.GetUserPrincipal: String;
var
  Req, Resp: TStringStream;
  XMLDoc: TXMLDocument;
  Attempt: Integer;
begin
  if Trim(FBaseURL) = '' then
    raise Exception.Create('Base URL can not be empty');
  Attempt := 0;
  repeat
    Inc(Attempt);
    Req := TStringStream.Create(
      '<?xml version="1.0" encoding="utf-8" ?>' +
      '<D:propfind xmlns:D="DAV:">' +
      '<D:prop>' +
      '   <D:current-user-principal/>' +
      '</D:prop>' +
      '</D:propfind>');
    Resp := TStringStream.Create('');
    XMLDoc := TXMLDocument.Create(FHTTP);
    try
      try
        FHTTP.Disconnect;
        FHTTP.Request.ContentType := 'application/xml; charset=utf-8';
        Req.Position := 0;
        try
          FHTTP.DAVPropFind(FBaseURL, Req, Resp);
        except
          on E: EIdConnClosedGracefully do
            Exit;
          else
            raise;
        end;
        if FHTTP.ResponseCode div 100 <> 2 then
          raise Exception.Create(FHTTP.ResponseText);
{$IFNDEF 2010ANDLATER}
        XMLDoc.XML.Text := Resp.DataString;
{$ELSE}
        XMLDoc.XML.Text := UTF8ToWideString(Resp.DataString);
{$ENDIF}
        XMLDoc.Active := True;
        with XMLDoc.DocumentElement do
          if ChildNodes['response'] <> nil then
            with ChildNodes['response'] do
              if ChildNodes['propstat'] <> nil then
                with ChildNodes['propstat'] do
                  if ChildNodes['prop'] <> nil then
                    with ChildNodes['prop'] do
                      if ChildNodes['current-user-principal'] <> nil then
                        with ChildNodes['current-user-principal'] do
                          if ChildNodes['href'] <> nil then
                            Result := ChildNodes['href'].Text;
        if Result = '' then
          raise Exception.Create('No user-principal');
        if Pos('://', Result) = 0 then
          Result := ExtractServerWProtocolName(FBaseURL) + Result;
        Result := StringReplace(Result, ' ', '%20', [rfReplaceAll]);
        break;
      except
        if (Attempt = 1) and not (FHTTP.ResponseCode - 400 in [1, 3]) then
            FBaseURL := ExtractServerWProtocolName(FBaseURL) + '/.well-known/caldav/'
        else
        begin
          Result := '';
          raise;
        end;
      end;
    finally
      XMLDoc.Free;
      Resp.Free;
      Req.Free;
    end;
  until false;
end;

procedure TCDCalendar.InternalLoad(Request, Multiget: String; EventsElseTasks: Boolean; const OnWorkBeginEvent: TWorkBeginEvent;
  const OnWorkEvent: TWorkEvent; LastModified: TDateTime);
var
  Req, Resp: TStringStream;
begin
  FCancelMultiget := False;
  Req := TStringStream.Create(Request);
  Resp := TStringStream.Create('');
  if Trim(FBaseURL) = '' then
    raise Exception.Create('Base URL can not be empty');
  try
    repeat
      FHTTP.Disconnect;
      FHTTP.Request.ContentType := 'application/xml; charset=utf-8';
      Req.Position := 0;
      if (MultiGet <> '') and (Multiget <> 'none') then
      begin
        Req.Free;
        Req := TStringStream.Create(
          '<?xml version="1.0" encoding="utf-8" ?>' + #13#10 +
          '<C:calendar-multiget xmlns:D="DAV:" xmlns:C="urn:ietf:params:xml:ns:caldav">' + #13#10 +
          '  <D:prop>' + #13#10 +
          '    <D:getetag/>' + #13#10 +
          '    <D:getlastmodified/>' + #13#10 +
          '    <C:calendar-data/>' + #13#10 +
          '  </D:prop>' + #13#10 +
          MultiGet +
          '</C:calendar-multiget>'
        );
        Resp.Size := 0;
        MultiGet := '';
      end;
      if Assigned(OnWorkBeginEvent) then
        FHTTP.OnWorkBegin := OnWorkBeginEvent;
      if Assigned(OnWorkEvent) then
        FHTTP.OnWork := OnWorkEvent;
      try
        try
          FHTTP.DAVReport(FBaseURL, Req, Resp);
        except
          on E: EIdConnClosedGracefully do
            Exit;
          else
            raise;
        end;
        if FHTTP.ResponseCode div 100 <> 2 then
          raise Exception.Create(FHTTP.ResponseText);
      finally
        FHTTP.OnWorkBegin := nil;
        FHTTP.OnWork := nil;
      end;
      ParseMultigetResponse(Request, Resp.DataString, EventsElseTasks, LastModified, Multiget);
    until (MultiGet = '') or (Multiget = 'none');
  finally
    Resp.Free;
    Req.Free;
  end;
end;

function TCDCalendar.IsiCloud: Boolean;
begin
  Result := Pos('icloud.com/', LowerCase(FBaseURL)) > 0;
end;

function TCDCalendar.ItemsCount: Integer;
begin
  Result := FItems.Count;
end;

function TCDCalendar.ItemWithHRef(const HRef: string): TCDItem;
var
  I: Integer;
begin
  Result := nil;
  I := -1;
  for I := FItems.Count - 1 downto 0 do
    if Items[I].FHRef = HRef then
      Break;
  if I > -1 then
    Result := Items[I];
end;

procedure TCDCalendar.SetUserName(const Value: String);
begin
  FHTTP.Request.Username := Value;
end;

procedure TCDCalendar.StopAllThreads;
var
  I: Integer;
begin
  FHTTP.IOHandler.InputBuffer.Clear;
  FHTTP.Disconnect;
  FCancelMultiget := True;
  FCancelStore := True;
  FCriticalSection.Enter;
  try
    for I := FMultigetThreads.Count - 1 downto 0 do
    with TMultigetThread(FMultigetThreads[I]) do
    try
      FHTTP.Disconnect;
      Terminate;
    except
    end;
    for I := FStoreThreads.Count - 1 downto 0 do
    with TStoreThread(FStoreThreads[I]) do
    try
      FHTTP.Disconnect;
      Terminate;
    except
    end;
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TCDCalendar.SetPassword(const Value: WideString);
begin
  FHTTP.Request.Password := Value;
end;

function TCDCalendar.GetPassword: WideString;
begin
  Result := FHTTP.Request.Password;
end;

procedure TCDCalendar.SetProxyServer(const Value: String);
begin
  FProxyServer := Value;
  ApplyProxySettings(FHTTP, FSSLIO);
end;

procedure TCDCalendar.SetProxyPassword(const Value: String);
begin
  FProxyPassword := Value;
  ApplyProxySettings(FHTTP, FSSLIO);
end;

procedure TCDCalendar.SetProxyType(const Value: TCalDavProxyType);
begin
  FProxyType := Value;
  ApplyProxySettings(FHTTP, FSSLIO);
end;

procedure TCDCalendar.SetProxyUsername(const Value: String);
begin
  FProxyUsername := Value;
  ApplyProxySettings(FHTTP, FSSLIO);
end;

procedure TCDCalendar.SetProxyPort(const Value: Word);
begin
  FProxyPort := Value;
  ApplyProxySettings(FHTTP, FSSLIO);
end;

procedure TCDCalendar.SetBaseURL(const Value: String);
begin
  FBaseURL := Value;
  if Pos('%', Value) = 0 then
    FBaseURL := TIdURI.URLEncode(Value);
  if FBaseURL[Length(FBaseURL)] <> '/' then
    FBaseURL := FBaseURL + '/';
  if IsiCloud then
  begin
    FHTTP.HTTPOptions := [hoForceEncodeParams];
    FHTTP.Request.BasicAuthentication := True;
  end
  else
  begin
    FHTTP.HTTPOptions := [hoForceEncodeParams, hoInProcessAuth];
    FHTTP.Request.BasicAuthentication := False;
  end;
end;

procedure TCDCalendar.SetDefaultTZ(const Value: TBundledTimeZone);
begin
  FDefaultTZ := Value;
  if FDefaultTZ = nil then
    FDefaultTZ := TBundledTimeZone.GetTimeZone('UTC');
end;

procedure TCDCalendar.SetLogFileName(const Value: WideString);
begin
  if FLogFileName = Value then
    Exit;
  FLogFileName := Value;
  if Trim(FLogFileName) <> '' then
  begin
    if FLogFile = nil then
    begin
      FLogFile := TIdLogFile.Create;
      FLogFile.ReplaceCRLF := False;
      FHTTP.Intercept := FLogFile;
    end;
    FLogFile.Filename := FLogFileName;
    FLogFile.Active := True;
  end
  else
  begin
    FHTTP.Intercept := nil;
    FreeAndNil(FLogFile);
  end;
end;

function TCDCalendar.NewEvent: TCDEvent;
begin
  Result := TCDEvent.Create(Self);
  FEvents.Add(Result);
end;

function TCDCalendar.NewItem: TCDItem;
begin
  Result := TCDItem.Create(Self);
  FItems.Add(Result);
end;

function TCDCalendar.EventCount: Integer;
begin
  Result := FEvents.Count;
end;

function TCDCalendar.EventWithHRef(const HRef: string): TCDEvent;
var
  I: Integer;
begin
  Result := nil;
  I := -1;
  for I := FEvents.Count - 1 downto 0 do
    if Events[I].FHRef = HRef then
      Break;
  if I > -1 then
    Result := Events[I];
end;

function TCDCalendar.GetCalendarCTag: string;
var
  Req, Resp: TStringStream;
  XMLDoc: TXMLDocument;
begin
  if not BaseURLIsCalendar then
    raise Exception.Create('URL is not calendar');
  Result := '';
  Req := TStringStream.Create(
    '<?xml version="1.0" encoding="UTF-8"?>' + #13#10 +
    '<D:propfind xmlns:D="DAV:" xmlns:cs="http://calendarserver.org/ns/">' + #13#10 +
    '  <D:prop>' + #13#10 +
    '    <cs:getctag/>' + #13#10 +
    '  </D:prop>' + #13#10 +
    '</D:propfind>');
  Resp := TStringStream.Create('');
  XMLDoc := TXMLDocument.Create(FHTTP);
  try
    FHTTP.Disconnect;
    FHTTP.Request.ContentType := 'application/xml; charset=utf-8';
    Req.Position := 0;
    try
      FHTTP.DAVPropFind(FBaseURL, Req, Resp, '0');
    except
      on E: EIdConnClosedGracefully do
        Exit;
      else
        raise;
    end;
    if FHTTP.ResponseCode div 100 <> 2 then
      raise Exception.Create(FHTTP.ResponseText);
{$IFNDEF 2010ANDLATER}
    XMLDoc.XML.Text := Resp.DataString;
{$ELSE}
    XMLDoc.XML.Text := UTF8ToWideString(Resp.DataString);
{$ENDIF}
    XMLDoc.Active := True;
    with XMLDoc.DocumentElement do
      if ChildNodes.Count > 0 then
        with ChildNodes[0] do
          if ChildNodes.FindNode('propstat') <> nil then
            with ChildNodes['propstat'] do
              if (Pos('200 OK', ChildNodes['status'].Text) > 0)
              and (ChildNodes.FindNode('prop') <> nil) then
                with ChildNodes['prop'] do
                  if ChildNodes.FindNode('getctag', 'http://calendarserver.org/ns/') <> nil then
                    Result := ChildNodes.FindNode('getctag', 'http://calendarserver.org/ns/').Text;
  finally
    XMLDoc.Free;
    Resp.Free;
    Req.Free;
  end;
end;

function TCDCalendar.GetCalendarDisplayName: String;
var
  Req, Resp: TStringStream;
  XMLDoc: TXMLDocument;
begin
  Result := '';
  Req := TStringStream.Create(
    '<?xml version="1.0" encoding="UTF-8"?>' + #13#10 +
    '<D:propfind xmlns:D="DAV:">' + #13#10 +
    '  <D:prop>' + #13#10 +
    '    <D:displayname/>' + #13#10 +
    '  </D:prop>' + #13#10 +
    '</D:propfind>');
  Resp := TStringStream.Create('');
  XMLDoc := TXMLDocument.Create(FHTTP);
  try
    FHTTP.Disconnect;
    FHTTP.Request.ContentType := 'application/xml; charset=utf-8';
    Req.Position := 0;
    try
      FHTTP.DAVPropFind(FBaseURL, Req, Resp, '0');
    except
      on E: EIdConnClosedGracefully do
        Exit;
      else
        raise;
    end;
    if FHTTP.ResponseCode div 100 <> 2 then
      raise Exception.Create(FHTTP.ResponseText);
{$IFNDEF 2010ANDLATER}
    XMLDoc.XML.Text := Resp.DataString;
{$ELSE}
    XMLDoc.XML.Text := UTF8ToWideString(Resp.DataString);
{$ENDIF}
    XMLDoc.Active := True;
    with XMLDoc.DocumentElement do
      if ChildNodes.Count > 0 then
        with ChildNodes[0] do
          if ChildNodes.FindNode('propstat') <> nil then
            with ChildNodes['propstat'] do
              if (Pos('200 OK', ChildNodes['status'].Text) > 0)
              and (ChildNodes.FindNode('prop') <> nil) then
                with ChildNodes['prop'] do
                  if ChildNodes.FindNode('displayname') <> nil then
                    Result := ChildNodes['displayname'].Text;
  finally
    XMLDoc.Free;
    Resp.Free;
    Req.Free;
  end;
end;

function TCDCalendar.GetCalendarHomeSet: String;
var
  Req, Resp: TStringStream;
  XMLDoc: TXMLDocument;
  FURL: String;
begin
  FURL := GetUserPrincipal;
  if FURL = '' then
    Exit;
  Result := '';
  Req := TStringStream.Create(
    '<?xml version="1.0" encoding="utf-8" ?>' +
    '<D:propfind xmlns:D="DAV:">' +
    '<D:prop>' +
    '   <C:calendar-home-set xmlns:C="urn:ietf:params:xml:ns:caldav"/>' +
    '</D:prop>' +
    '</D:propfind>');
  Resp := TStringStream.Create('');
  XMLDoc := TXMLDocument.Create(FHTTP);
  try
    try
      FHTTP.Disconnect;
      FHTTP.Request.ContentType := 'application/xml; charset=utf-8';
      Req.Position := 0;
      try
        FHTTP.DAVPropFind(FURL, Req, Resp);
      except
        on E: EIdConnClosedGracefully do
          Exit;
        else
          raise;
      end;
      if FHTTP.ResponseCode div 100 <> 2 then
        raise Exception.Create(FHTTP.ResponseText);
{$IFNDEF 2010ANDLATER}
    XMLDoc.XML.Text := Resp.DataString;
{$ELSE}
    XMLDoc.XML.Text := UTF8ToWideString(Resp.DataString);
{$ENDIF}
      XMLDoc.Active := True;
      with XMLDoc.DocumentElement do
        if ChildNodes.FindNode('response') <> nil then
          with ChildNodes['response'] do
            if ChildNodes.FindNode('propstat') <> nil then
              with ChildNodes['propstat'] do
                if ChildNodes.FindNode('prop') <> nil then
                  with ChildNodes['prop'] do
                    if ChildNodes.FindNode('calendar-home-set', 'urn:ietf:params:xml:ns:caldav') <> nil then
                      with ChildNodes.FindNode('calendar-home-set', 'urn:ietf:params:xml:ns:caldav') do
                        if ChildNodes.FindNode('href', 'DAV:') <> nil then
                          with ChildNodes.FindNode('href', 'DAV:') do
                            Result := Text;
      if Result = '' then
        raise Exception.Create('Calendar home set not found');
      if Pos('://', Result) = 0 then
        Result := ExtractServerWProtocolName(FURL) + Result;
      Result := StringReplace(Result, ' ', '%20', [rfReplaceAll]);
    except
      Result := '';
      raise;
    end;
  finally
    XMLDoc.Free;
    Resp.Free;
    Req.Free;
  end;
end;

function TCDCalendar.GetCalendars: TObjectList;
var
  Req, Resp: TStringStream;
  XMLDoc: TXMLDocument;
  I, J: Integer;
  FURL, CalURL, ACTag: String;
  DName: WideString;
begin
  Result := FCalendars;
  FURL := GetCalendarHomeSet;
  if FURL = '' then
    Exit;
  Req := TStringStream.Create(
    '<?xml version="1.0" encoding="utf-8"?>' +
    '<D:propfind xmlns:D="DAV:" xmlns:cs="http://calendarserver.org/ns/" xmlns:CD="urn:ietf:params:xml:ns:caldav">' +
    ' <D:prop>' +
    '  <D:displayname/>' +
    '  <cs:getctag/>' + #13#10 +
    '  <D:resourcetype/>' +
    '  <CD:supported-calendar-component-set/>' +
    ' </D:prop>' +
    '</D:propfind>');
  Resp := TStringStream.Create('');
  XMLDoc := TXMLDocument.Create(FHTTP);
  try
    FHTTP.Disconnect;
    FHTTP.Request.ContentType := 'application/xml; charset=utf-8';
    Req.Position := 0;
    try
      FHTTP.DAVPropFind(FURL, Req, Resp, '1');
    except
      on E: EIdConnClosedGracefully do
        Exit;
      else
        raise;
    end;
    if FHTTP.ResponseCode div 100 <> 2 then
      raise Exception.Create(FHTTP.ResponseText);
{$IFNDEF 2010ANDLATER}
    XMLDoc.XML.Text := Resp.DataString;
{$ELSE}
    XMLDoc.XML.Text := UTF8ToWideString(Resp.DataString);
{$ENDIF}
    XMLDoc.Active := True;
    FCalendars.Clear;
    if XMLDoc.DocumentElement <> nil then
      with XMLDoc.DocumentElement do
        for I := 0 to ChildNodes.Count - 1 do
          with ChildNodes[I] do
          begin
            ACTag := '';
            if ChildNodes.FindNode('href', 'DAV:') <> nil then
            begin
              CalURL := ChildNodes.FindNode('href', 'DAV:').Text;
              if Pos('://', CalURL) = 0 then
                CalURL := ExtractServerWProtocolName(FURL) + CalURL;
            end;
            if ChildNodes.FindNode('propstat', 'DAV:') <> nil then
              if ChildNodes['propstat'].ChildNodes['prop'].ChildNodes.FindNode('resourcetype',
                'DAV:') <> nil then
                  if ChildNodes['propstat'].ChildNodes['prop'].ChildNodes.FindNode('resourcetype',
                'DAV:').ChildNodes.FindNode('calendar', 'urn:ietf:params:xml:ns:caldav') <> nil then
                  if ChildNodes['propstat'].ChildNodes['prop'].ChildNodes.FindNode('getctag',
                    'http://calendarserver.org/ns/') <> nil then
                      ACTag := ChildNodes['propstat'].ChildNodes['prop'].ChildNodes.FindNode('getctag',
                        'http://calendarserver.org/ns/').Text;
            if ChildNodes.FindNode('propstat', 'DAV:') <> nil then
              if ChildNodes['propstat'].ChildNodes['prop'].ChildNodes.FindNode('resourcetype',
                'DAV:') <> nil then
                  if ChildNodes['propstat'].ChildNodes['prop'].ChildNodes.FindNode('resourcetype',
                'DAV:').ChildNodes.FindNode('calendar', 'urn:ietf:params:xml:ns:caldav') <> nil then
                  if ChildNodes['propstat'].ChildNodes['prop'].ChildNodes.FindNode('displayname',
                    'DAV:') <> nil then
                    begin
                      DName := ChildNodes['propstat'].ChildNodes['prop'].ChildNodes.FindNode('displayname',
                        'DAV:').Text;
                      with TCDCollection(FCalendars[FCalendars.Add(TCDCollection.Create)]) do
                      begin
                        FName := DName;
                        FURL := CalURL;
                        FCTag := ACTag;
                        if ChildNodes['propstat'].ChildNodes['prop'].ChildNodes.FindNode('supported-calendar-component-set',
                          'urn:ietf:params:xml:ns:caldav') <> nil then
                          with ChildNodes['propstat'].ChildNodes['prop'].ChildNodes.FindNode('supported-calendar-component-set',
                          'urn:ietf:params:xml:ns:caldav') do
                            for J := 0 to ChildNodes.Count - 1 do
                            begin
                              if UpperCase(ChildNodes[J].Attributes['name']) = 'VEVENT' then
                                FSupportVEVENT := True;
                              if UpperCase(ChildNodes[J].Attributes['name']) = 'VTODO' then
                                FSupportVTODO := True;
                            end;
                      end;
                    end;
          end;
  finally
    XMLDoc.Free;
    Resp.Free;
    Req.Free;
  end;
end;

function TCDCalendar.GetEvent(Index: Integer): TCDEvent;
begin
  Result := TCDEvent(FEvents[Index]);
end;

function TCDCalendar.GetiCalendarCodeForTZ(const TZ: TBundledTimeZone): String;
begin
  if not TimeZoneAvailable(TZ.ID) then
    Result := ''
  else
  with TStringList.Create do
  try
    LoadFromFile('TZ\' + StringReplace(TZ.ID, '/', '\', [rfReplaceAll]) + '.ics');
    Result := Copy(Text, Pos('BEGIN:VTIMEZONE', Text), MaxInt);
    Result := Trim(Copy(Result, 1, Pos('END:VTIMEZONE', Result) + 12)) + #13#10;
  finally
    Free;
  end;
end;

function TCDCalendar.GetItem(Index: Integer): TCDItem;
begin
  Result := TCDItem(FItems[Index]);
end;

procedure TCDCalendar.CreateCalendar(const NewCalendarName: string);
  function GUIDToString(const Guid: TGUID): string;
  begin
    SetLength(Result, 36);
    StrLFmt(PChar(Result), 36,'%.8x-%.4x-%.4x-%.2x%.2x-%.2x%.2x%.2x%.2x%.2x%.2x',
      [Guid.D1, Guid.D2, Guid.D3, Guid.D4[0], Guid.D4[1], Guid.D4[2], Guid.D4[3],
      Guid.D4[4], Guid.D4[5], Guid.D4[6], Guid.D4[7]]);
  end;
  function GUIDString: String;
  var
    Guid: TGUID;
  begin
    CreateGUID(Guid);
    Result := GUIDToString(Guid);
  end;
var
  Req: TStringStream;
  URL: string;
  ReqString: String;
begin
  if IsiCloud then
    ReqString :=
        '<?xml version="1.0" encoding="UTF-8"?>' + #13#10 +
        '<C:mkcalendar xmlns:D="DAV:" xmlns:C="urn:ietf:params:xml:ns:caldav">' + #13#10 +
        '  <D:set>' + #13#10 +
        '    <D:prop>' + #13#10 +
        '      <D:displayname><![CDATA[' + NewCalendarName + ']]></D:displayname>' + #13#10
  else
    ReqString :=
        '<?xml version="1.0" encoding="UTF-8"?>' + #13#10 +
        '<C:mkcalendar xmlns:D="DAV:" xmlns:C="urn:ietf:params:xml:ns:caldav">' + #13#10 +
        '  <D:set>' + #13#10 +
        '    <D:prop>' + #13#10 +
        '      <D:displayname><![CDATA[]]></D:displayname>' + #13#10
        ;
  if FNewCalendarType > 0 then
  begin
    ReqString := ReqString +
        '      <C:supported-calendar-component-set>' + #13#10
        ;
    if FNewCalendarType = 1 then
      ReqString := ReqString +
          '        <C:comp name="VEVENT"/>' + #13#10
          ;
    if FNewCalendarType = 2 then
      ReqString := ReqString +
          '        <C:comp name="VTODO"/>' + #13#10
          ;
    ReqString := ReqString +
        '      </C:supported-calendar-component-set>' + #13#10
        ;
  end;
  ReqString := ReqString +
        '    </D:prop>' + #13#10 +
        '  </D:set>' + #13#10 +
        '</C:mkcalendar>'
        ;
{$IFDEF 2010ANDLATER}
    Req := TStringStream.Create(Utf8Encode(ReqString));
{$ELSE}
    Req := TStringStream.Create(ReqString);
{$ENDIF}
  try
    FHTTP.Disconnect;
    FHTTP.Request.ContentType := 'application/xml; charset=utf-8';
    FHTTP.Request.Accept := 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8';
    Req.Position := 0;
    URL := TIdURI.URLEncode(TIdURI.URLDecode(CalendarHomeSetURL) + GUIDString) + '/';
    FHTTP.DoRequest('MKCALENDAR', URL, Req, nil, []);
    if FHTTP.ResponseCode div 100 <> 2 then
      raise Exception.Create(FHTTP.ResponseText);
    with TCDCollection(FCalendars[FCalendars.Add(TCDCollection.Create)]) do
    begin
      FName := NewCalendarName;
      FURL := URL;
      FSupportVEVENT := FNewCalendarType in [0, 1];
      FSupportVTODO := FNewCalendarType in [0, 2];
    end;
  finally
    Req.Free;
  end;
  if not IsiCloud then
    ChangeDisplayName(URL, NewCalendarName);
end;

procedure TCDCalendar.CreateVEVENTCalendar(const NewCalendarName: string);
begin
  FNewCalendarType := 1;
  try
    CreateCalendar(NewCalendarName);
  finally
    FNewCalendarType := 0;
  end;
end;

procedure TCDCalendar.CreateVTODOCalendar(const NewCalendarName: string);
begin
  FNewCalendarType := 2;
  try
    CreateCalendar(NewCalendarName);
  finally
    FNewCalendarType := 0;
  end;
end;

procedure TCDCalendar.DeleteCalendar;
var
  I: Integer;
begin
  FHTTP.Disconnect;
  try
    FHTTP.DoRequest('DELETE', FBaseURL, nil, nil, []);
  finally
    for I := FCalendars.Count - 1 downto 0 do
      if TCDCollection(FCalendars[I]).URL = FBaseURL then
        FCalendars.Delete(I);
  end;
end;

procedure TCDCalendar.LoadTasks(const LastModified: TDateTime = 0; const OnWorkBeginEvent: TWorkBeginEvent = nil; const OnWorkEvent: TWorkEvent = nil);
var
  Request: String;
begin
  Request :=
    '<?xml version="1.0" encoding="UTF-8"?>' + #13#10 +
    '<C:calendar-query xmlns:D="DAV:" xmlns:C="urn:ietf:params:xml:ns:caldav">' + #13#10 +
    '  <D:prop>' + #13#10 +
    '    <D:getetag/>' + #13#10 +
    '    <D:getlastmodified/>' + #13#10 +
    '  </D:prop>' + #13#10 +
    '  <C:filter>' + #13#10 +
    '   <C:comp-filter name="VCALENDAR">' + #13#10 +
    '     <C:comp-filter name="VTODO"/>' + #13#10 +
    '   </C:comp-filter>' + #13#10 +
    '  </C:filter>' + #13#10 +
    '</C:calendar-query>';
  FTasks.Clear;
  InternalLoad(Request, '', False, OnWorkBeginEvent, OnWorkEvent, LastModified);
end;

procedure TCDCalendar.LoadTasksETags(const OnWorkBeginEvent: TWorkBeginEvent;
  const OnWorkEvent: TWorkEvent);
var
  Request: String;
begin
  Request :=
    '<?xml version="1.0" encoding="UTF-8"?>' + #13#10 +
    '<C:calendar-query xmlns:D="DAV:" xmlns:C="urn:ietf:params:xml:ns:caldav">' + #13#10 +
    '  <D:prop>' + #13#10 +
    '    <D:getetag/>' + #13#10 +
    '    <D:getlastmodified/>' + #13#10 +
    '  </D:prop>' + #13#10 +
    '  <C:filter>' + #13#10 +
    '   <C:comp-filter name="VCALENDAR">' + #13#10 +
    '     <C:comp-filter name="VTODO"/>' + #13#10 +
    '   </C:comp-filter>' + #13#10 +
    '  </C:filter>' + #13#10 +
    '</C:calendar-query>';
  FTasks.Clear;
  InternalLoad(Request, 'none', False, OnWorkBeginEvent, OnWorkEvent);
end;

function TCDCalendar.LocalTimeZone: TBundledTimeZone;
var
  TDZI: _TIME_DYNAMIC_ZONE_INFORMATION;
  KeyName, Region, FoundZ, DefaultZ, TypeZ: String;
  pcLCA: array [0..20] of Char;
  I: Integer;
begin
  Result := nil;
  if Assigned(GetDynamicTimeZoneInformation_) then
  begin
    try
      GetDynamicTimeZoneInformation_(TDZI);
    except
      Exit;
    end;
    KeyName := TDZI.TimeZoneKeyName;
    Region := '  ';
    if GetLocaleInfo(LOCALE_USER_DEFAULT, LOCALE_SISO3166CTRYNAME, pcLCA, 19) <= 0 then
      pcLCA[0] := #0;
    Region := pcLCA;
    FoundZ := '';
    DefaultZ := '';
    with TXMLDocument.Create(FHTTP) do
    try
      XML.LoadFromFile('TZ\windowsZones.xml');
      Active := True;
      with DocumentElement do
        if ChildNodes.FindNode('windowsZones') <> nil then
          with ChildNodes['windowsZones'] do
            if ChildNodes.FindNode('mapTimezones') <> nil then
              with ChildNodes['mapTimezones'] do
                for I := 0 to ChildNodes.Count - 1 do
                  with ChildNodes[I] do
                    if Attributes['other'] = KeyName then
                    begin
                      TypeZ := Attributes['type'];
                      if Attributes['territory'] = '001' then
                        DefaultZ := TypeZ
                      else
                      if Attributes['territory'] = Region then
                        if Pos(' ', TypeZ) > 0 then
                          FoundZ := Copy(TypeZ, 1, Pos(' ', TypeZ) - 1)
                        else
                          FoundZ := TypeZ;
                    end;
    finally
      Free;
    end;
    if (FoundZ <> '') and (TimeZoneAvailable(FoundZ)) then
    begin
      try
        Result := TBundledTimeZone.GetTimeZone(FoundZ);
        Exit;
      except
        Result := nil;
      end;
    end;
    if (DefaultZ <> '') and (TimeZoneAvailable(DefaultZ)) then
    begin
      try
        Result := TBundledTimeZone.GetTimeZone(DefaultZ);
      except
        Result := nil;
      end;
    end;
  end;
end;

procedure TCDCalendar.MultiGetEvents(const OnWorkBeginEvent: TWorkBeginEvent = nil; const OnWorkEvent: TWorkEvent = nil);
var
  MultiGet: String;
  I: Integer;
begin
  Multiget := '';
  for I := 0 to FEvents.Count - 1 do
    if TCDEvent(FEvents[I]).FGetOnNextMultiget then
    begin
      MultiGet := MultiGet + '    <D:href xmlns:D="DAV:">' + TCDEvent(FEvents[I]).FHRef + '</D:href>' + #13#10;
      TCDEvent(FEvents[I]).FGetOnNextMultiget := False;
    end;
  if Multiget = '' then
    Exit;
  InternalLoad('', MultiGet, True, OnWorkBeginEvent, OnWorkEvent);
end;

procedure TCDCalendar.MultiGetEvents(MaxThreads, ItemsInThread: Word;
  const OnWorkBeginEvent: TWorkBeginEvent; const OnWorkEvent: TWorkEvent);
var
  MultiGet: String;
  I, Added: Integer;
  WaitEvent: THandle;
  Total, Current: Cardinal;
begin
  FCancelMultiget := False;
  Total := 0;
  for I := 0 to FEvents.Count - 1 do
  begin
    if TCDEvent(FEvents[I]).FGetOnNextMultiget then
      Inc(Total);
    TCDEvent(FEvents[I]).FLoaded := False;
  end;
  if Assigned(OnWorkBeginEvent) then
    OnWorkBeginEvent(Self, wmRead, Total);
  WaitEvent := CreateEvent(nil, False, False, nil);
  try
    repeat
      repeat
        Multiget := '';
        Added := 0;
        for I := 0 to FEvents.Count - 1 do
          if TCDEvent(FEvents[I]).FGetOnNextMultiget then
          begin
            MultiGet := MultiGet + '    <D:href xmlns:D="DAV:">' + TCDEvent(FEvents[I]).FHRef + '</D:href>' + #13#10;
            TCDEvent(FEvents[I]).FGetOnNextMultiget := False;
            Inc(Added);
            if Added >= ItemsInThread then
              break;
          end;
        FCriticalSection.Enter;
        try
          if MultiGet <> '' then
            FMultigetThreads.Add(TMultigetThread.Create(Self, MultiGet, WaitEvent));
        finally
          FCriticalSection.Leave;
        end;
      until (MultiGet = '') or (FMultigetThreads.Count >= MaxThreads);
      if FMultigetThreads.Count > 0 then
        WaitForSingleObject(WaitEvent, INFINITE)
      else
        Break;
      ResetEvent(WaitEvent);
      Current := 0;
      for I := 0 to FEvents.Count - 1 do
        if TCDEvent(FEvents[I]).FLoaded then
          Inc(Current);
      if Assigned(OnWorkEvent) then
        OnWorkEvent(Self, wmRead, Current);
    until FCancelMultiget;
  finally
    CloseHandle(WaitEvent);
  end;
end;

procedure TCDCalendar.MultiGetFromAllItemsETags(MaxThreads: Word = 10; ItemsInThread: Word = 50; const OnWorkBeginEvent: TWorkBeginEvent = nil; const OnWorkEvent: TWorkEvent = nil);
var
  MultiGet: String;
  I, Added: Integer;
  WaitEvent: THandle;
  Total, Current: Cardinal;
begin
  FLoadError := False;
  FCancelMultiget := False;
  Total := 0;
  for I := 0 to FItems.Count - 1 do
  begin
    if TCDItem(FItems[I]).FGetOnNextMultiget then
      Inc(Total);
    TCDItem(FItems[I]).FLoaded := False;
  end;
  if Total = 0 then
    Exit;
  if Assigned(OnWorkBeginEvent) then
    OnWorkBeginEvent(Self, wmRead, Total);
  WaitEvent := CreateEvent(nil, False, False, nil);
  try
    repeat
      repeat
        Multiget := '';
        Added := 0;
        for I := 0 to FItems.Count - 1 do
          if TCDItem(FItems[I]).FGetOnNextMultiget then
          begin
            MultiGet := MultiGet + '    <D:href xmlns:D="DAV:">' + TCDItem(FItems[I]).FHRef + '</D:href>' + #13#10;
            TCDItem(FItems[I]).FGetOnNextMultiget := False;
            Inc(Added);
            if Added >= ItemsInThread then
              break;
          end;
        FCriticalSection.Enter;
        try
          if MultiGet <> '' then
            FMultigetThreads.Add(TMultigetThread.Create(Self, MultiGet, WaitEvent));
        finally
          FCriticalSection.Leave;
        end;
      until (MultiGet = '') or (FMultigetThreads.Count >= MaxThreads);
      if FMultigetThreads.Count > 0 then
        WaitForSingleObject(WaitEvent, INFINITE)
      else
        Break;
      ResetEvent(WaitEvent);
      if FLoadError then
        raise Exception.Create('Error loading items');
      Current := 0;
      for I := 0 to FItems.Count - 1 do
        if TCDItem(FItems[I]).FLoaded then
          Inc(Current);
      if Assigned(OnWorkEvent) then
        OnWorkEvent(Self, wmRead, Current);
    until FCancelMultiget;
  finally
    CloseHandle(WaitEvent);
  end;
end;

procedure TCDCalendar.MultiGetTasks(MaxThreads, ItemsInThread: Word;
  const OnWorkBeginEvent: TWorkBeginEvent; const OnWorkEvent: TWorkEvent);
var
  MultiGet: String;
  I, Added: Integer;
  WaitEvent: THandle;
  Total, Current: Cardinal;
begin
  FCancelMultiget := False;
  Total := 0;
  for I := 0 to FTasks.Count - 1 do
  begin
    if TCDTask(FTasks[I]).FGetOnNextMultiget then
      Inc(Total);
    TCDTask(FTasks[I]).FLoaded := False;
  end;
  if Assigned(OnWorkBeginEvent) then
    OnWorkBeginEvent(Self, wmRead, Total);
  WaitEvent := CreateEvent(nil, False, False, nil);
  try
    repeat
      repeat
        Multiget := '';
        Added := 0;
        for I := 0 to FTasks.Count - 1 do
          if TCDTask(FTasks[I]).FGetOnNextMultiget then
          begin
            MultiGet := MultiGet + '    <D:href xmlns:D="DAV:">' + TCDTask(FTasks[I]).FHRef + '</D:href>' + #13#10;
            TCDTask(FTasks[I]).FGetOnNextMultiget := False;
            Inc(Added);
            if Added >= ItemsInThread then
              break;
          end;
        FCriticalSection.Enter;
        try
          if MultiGet <> '' then
            FMultigetThreads.Add(TMultigetThread.Create(Self, MultiGet, WaitEvent));
        finally
          FCriticalSection.Leave;
        end;
      until (MultiGet = '') or (FMultigetThreads.Count >= MaxThreads);
      if FMultigetThreads.Count > 0 then
        WaitForSingleObject(WaitEvent, INFINITE)
      else
        Break;
      ResetEvent(WaitEvent);
      Current := 0;
      for I := 0 to FTasks.Count - 1 do
        if TCDTask(FTasks[I]).FLoaded then
          Inc(Current);
      if Assigned(OnWorkEvent) then
        OnWorkEvent(Self, wmRead, Current);
    until FCancelMultiget;
  finally
    CloseHandle(WaitEvent);
  end;
end;

procedure TCDCalendar.MultiGetTasks(const OnWorkBeginEvent: TWorkBeginEvent;
  const OnWorkEvent: TWorkEvent);
var
  MultiGet: String;
  I: Integer;
begin
  Multiget := '';
  for I := 0 to FTasks.Count - 1 do
    if TCDTask(FTasks[I]).FGetOnNextMultiget then
    begin
      MultiGet := MultiGet + '    <D:href xmlns:D="DAV:">' + TCDTask(FTasks[I]).FHRef + '</D:href>' + #13#10;
      TCDTask(FTasks[I]).FGetOnNextMultiget := False;
    end;
  if Multiget = '' then
    Exit;
  InternalLoad('', MultiGet, False, OnWorkBeginEvent, OnWorkEvent);
end;

function TCDCalendar.NewTask: TCDTask;
begin
  Result := TCDTask.Create(Self);
  FTasks.Add(Result);
end;

procedure TCDCalendar.ParseMultigetResponse(const Request: string; ResponseText: string; EventsElseTasks: Boolean; LastModified: TDateTime; var Multiget: String);
var
  XMLDoc: TXMLDocument;
  Node: IXMLNode;
  I: Integer;
  lHRef, lETag: String;
  NewItem, ToMarkLoaded: TCDItem;
  lLastModified: TDateTime;
begin
  XMLDoc := TXMLDocument.Create(FHTTP);
  try
{$IFNDEF 2010ANDLATER}
    XMLDoc.XML.Text := ResponseText;
{$ELSE}
    XMLDoc.XML.Text := UTF8ToWideString(ResponseText);
{$ENDIF}
    XMLDoc.Active := True;
    if XMLDoc.DocumentElement <> nil then
      with XMLDoc.DocumentElement do
        for I := 0 to ChildNodes.Count - 1 do
        begin
          if FCancelMultiget then
            Exit;
          with ChildNodes[I] do
            if ChildNodes.FindNode('propstat', 'DAV:') <> nil then
            begin
              lHRef := ChildNodes['href'].Text;
              Node := ChildNodes['propstat'].ChildNodes['prop'].ChildNodes.FindNode('getlastmodified', 'DAV:');
              if Node <> nil then
                lLastModified := StrInternetToDateTime(Node.Text)
              else
                lLastModified := 0;
              Node := ChildNodes['propstat'].ChildNodes['prop'].ChildNodes.FindNode('getetag', 'DAV:');
              if Node <> nil then
                lETag := Node.Text
              else
                lETag := '';
              if Pos('.eml', LowerCase(lHRef)) <> 0 then
                FUsedExtension := '.eml'
              else
                FUsedExtension := '.ics';
              if (LastModified <> 0) and (lLastModified <> 0) and (lLastModified < LastModified) then
                Continue;
              Node := ChildNodes['propstat'].ChildNodes['prop'].ChildNodes.FindNode('calendar-data',
                'urn:ietf:params:xml:ns:caldav');
              if (Node <> nil) or (Multiget = 'none') then
              begin
                if (Node <> nil) then
                  EventsElseTasks := Pos('VEVENT', Node.Text) > 0;
                NewItem := nil;
                FCriticalSection.Enter;
                try
                  if Request = '' then
                  begin
                    if EventsElseTasks then
                      NewItem := EventWithHRef(lHRef)
                    else
                      NewItem := TaskWithHRef(lHRef);
                  end;
                  if NewItem = nil then
                  begin
                    if EventsElseTasks then
                      NewItem := NewEvent
                    else
                      NewItem := NewTask;
                  end;
                finally
                  FCriticalSection.Leave;
                end;
                if NewItem = nil then
                  Continue;
                with NewItem do
                begin
                  FHRef := lHRef;
                  FLastModified := lLastModified;
                  FETag := lETag;
                  if Node <> nil then
                    SetiCal(Node.Text);
                  ToMarkLoaded := ItemWithHRef(lHRef);
                  if ToMarkLoaded <> nil then
                    ToMarkLoaded.FLoaded := True;
                  Continue;
                end;
              end;
              if (Multiget <> 'none') and (Request <> '') then
                MultiGet := MultiGet + '    <D:href>' + lHRef + '</D:href>' + #13#10;
            end;
        end;
  finally
    XMLDoc.Free;
  end;
end;

procedure TCDCalendar.RenameCalendar(const NewCalendarName: string);
begin
  ChangeDisplayName(FBaseURL, NewCalendarName);
end;

procedure TCDCalendar.ResetEventsStoring;
var
  I: Integer;
begin
  for I := EventCount - 1 downto 0 do
    Events[I].ResetStoring;
end;

procedure TCDCalendar.ResetItemsStoring;
var
  I: Integer;
begin
  for I := ItemsCount - 1 downto 0 do
    Items[I].ResetStoring;
end;

procedure TCDCalendar.ResetTasksStoring;
var
  I: Integer;
begin
  for I := TaskCount - 1 downto 0 do
    Tasks[I].ResetStoring;
end;

function TCDCalendar.TaskCount: Integer;
begin
  Result := FTasks.Count;
end;

function TCDCalendar.TaskWithHRef(const HRef: string): TCDTask;
var
  I: Integer;
begin
  Result := nil;
  I := -1;
  for I := FTasks.Count - 1 downto 0 do
    if Tasks[I].FHRef = HRef then
      Break;
  if I > -1 then
    Result := Tasks[I];
end;

function TCDCalendar.TimeZoneAvailable(const TZID: String): Boolean;
begin
  Result := FileExists('TZ\' + StringReplace(TZID, '/', '\', [rfReplaceAll]) + '.ics');
end;

function TCDCalendar.GetTask(Index: Integer): TCDTask;
begin
  Result := TCDTask(FTasks[Index]);
end;

{ TIdWebDAV }

procedure TIdWebDAV.DoRequest(const AMethod: TIdHTTPMethod; AURL: String;
  ASource, AResponseContent: TStream; AIgnoreReplies: array of SmallInt);
var
  LResponseLocation: Integer;
  SavePos: Int64;
begin
  //reset any counters
  FRedirectCount := 0;
  FAuthRetries := 0;
  FAuthProxyRetries := 0;
  IOHandler.InputBuffer.Clear;

  if Assigned(AResponseContent) then
  begin
    LResponseLocation := AResponseContent.Position;
  end
  else
  begin
    LResponseLocation := 0; // Just to avoid the warning message
  end;

  Request.URL := AURL;
  Request.Method := AMethod;
  Request.Source := ASource;
  Response.ContentStream := AResponseContent;

  try
    repeat

      PrepareRequest(Request);

      if IOHandler is TIdSSLIOHandlerSocketBase then
      begin
        TIdSSLIOHandlerSocketBase(IOHandler).URIToCheck := FURI.URI;
      end;

      if Request.Source <> nil then
        SavePos := Request.Source.Position;

      ConnectToHost(Request, Response);

      // for WebDAV (some old Indy 10) by Dmitrij Osipov
      if (Request.Source <> nil) and (PosInStrArray(Request.Method, [Id_HTTPMethodPropFind, Id_HTTPMethodReport], False) > -1) then
        if Request.Source.Position = SavePos then
        begin
          IOHandler.Write(Request.Source, 0, False);
        end;

      // Workaround for servers wich respond with 100 Continue on GET and HEAD
      // This workaround is just for temporary use until we have final HTTP 1.1
      // realisation. HTTP 1.1 is ongoing because of all the buggy and conflicting servers.
      repeat
        Response.ResponseText := IOHandler.ReadLn;
        FHTTPProto.RetrieveHeaders(MaxHeaderLines);
        ProcessCookies(Request, Response);
      until Response.ResponseCode <> 100;

      case FHTTPProto.ProcessResponse(AIgnoreReplies) of
        wnAuthRequest:
          begin
            Request.URL := AURL;
          end;
        wnReadAndGo:
          begin
{$IF RTLVersion < 23}
            ReadResult(Response);
{$ELSE}
            ReadResult(Request, Response);
{$IFEND}
            if Assigned(AResponseContent) then
            begin
              AResponseContent.Position := LResponseLocation;
              AResponseContent.Size := LResponseLocation;
            end;
            FAuthRetries := 0;
            FAuthProxyRetries := 0;
          end;
        wnGoToURL:
          begin
            if Assigned(AResponseContent) then
            begin
              AResponseContent.Position := LResponseLocation;
              AResponseContent.Size := LResponseLocation;
            end;
            FAuthRetries := 0;
            FAuthProxyRetries := 0;
          end;
        wnJustExit:
          begin
            Break;
          end;
        wnDontKnow:
          begin
            raise EIdException.Create(RSHTTPNotAcceptable);
          end;
      end;
      if Request.Source <> nil then
        Request.Source.Position := SavePos;
    until False;
  finally
    if not Response.KeepAlive then
    begin
      Disconnect;
    end;
  end;
end;

constructor TCDEvent.Create(Calendar: TCDCalendar);
begin
  inherited Create(Calendar);
  FiCal.Text :=
    'BEGIN:VCALENDAR' + #13#10 +
    'VERSION:2.0' + #13#10 +
    'CALSCALE:GREGORIAN' + #13#10 +
    'BEGIN:VEVENT' + #13#10 +
    'DTSTAMP:' + DateTimeToiCalDate(Now) + #13#10 +
    'UID:' + FileNameNoExt(FileNameOnly(FHRef)) + #13#10 +
    'SEQUENCE:0' + #13#10 +
    'END:VEVENT' + #13#10 +
    'END:VCALENDAR';
  StartTimeTZ := Calendar.DefaultTimeZone;
  EndTimeTZ := Calendar.DefaultTimeZone;
  StartTime := Date + EncodeTime(HourOf(Now), 0, 0, 0);
  EndTime := IncHour(StartTime);
end;

procedure TCDEvent.SetiCal(const Value: WideString);
var
  I: Integer;
  Name, TZID: String;
  S: WideString;
  AllDayPossible: Boolean;
begin
  inherited SetiCal(Value);
  AllDayPossible := False;
  I := FItemBegin;
  while I < FiCal.Count do
  begin
    S := FiCal[I];
    Name := GetPropertyName(S);
    if Name = 'DTSTART' then
    begin
      FStartTime := GetDateTime(S);
      if Pos('Z', GetValue(S)) <> 0 then
        FStartTimeTZ := TBundledTimeZone.GetTimeZone('UTC')
      else
      begin
        TZID := GetParams(S);
        if TZID <> '' then
          if Pos('TZID=', TZID) <> 0 then
          begin
            TZID := Copy(TZID, Pos('TZID=', TZID) + 5, MaxInt);
            if Pos(';', TZID) <> 0 then
              TZID := Copy(TZID, 1, Pos(';', TZID) - 1);
            try
              FStartTimeTZ := TBundledTimeZone.GetTimeZone(TZID);
            except
              FStartTimeTZ := nil;
            end;
          end;
      end;
      FAllDay := AllDayPossible and ((Pos(WideString(';VALUE=DATE'), S) <> 0) and (Pos(WideString(';VALUE=DATE'), S) <> Pos(WideString(';VALUE=DATE-TIME'), S)));
      AllDayPossible := (Pos(WideString(';VALUE=DATE'), S) <> 0) and (Pos(WideString(';VALUE=DATE'), S) <> Pos(WideString(';VALUE=DATE-TIME'), S));
    end
    else if Name = 'DTEND' then
    begin
      FEndTime := GetDateTime(S);
      if Pos('Z', GetValue(S)) <> 0 then
        FEndTimeTZ := TBundledTimeZone.GetTimeZone('UTC')
      else
      begin
        TZID := GetParams(S);
        if TZID <> '' then
          if Pos('TZID=', TZID) <> 0 then
          begin
            TZID := Copy(TZID, Pos('TZID=', TZID) + 5, MaxInt);
            if Pos(';', TZID) <> 0 then
              TZID := Copy(TZID, 1, Pos(';', TZID) - 1);
            try
              FEndTimeTZ := TBundledTimeZone.GetTimeZone(TZID);
            except
              FEndTimeTZ := nil;
            end;
          end;
      end;
      FAllDay := AllDayPossible and ((Pos(WideString(';VALUE=DATE'), S) <> 0) and (Pos(WideString(';VALUE=DATE'), S) <> Pos(WideString(';VALUE=DATE-TIME'), S)));
      AllDayPossible := (Pos(WideString(';VALUE=DATE'), S) <> 0) and (Pos(WideString(';VALUE=DATE'), S) <> Pos(WideString(';VALUE=DATE-TIME'), S));
    end
    else if Name = 'DURATION' then
    begin
      FEndTime := FStartTime + GetDateTime(S);
      FAllDay := AllDayPossible;
    end
    else if Name = 'END' then
      if GetValue(S) = 'VEVENT' then
        Break;
    Inc(I);
  end;
  if FAllDay then
  begin
    FStartTimeTZ :=  nil;
    FEndTimeTZ := nil;
  end;
end;

procedure TCDEvent.SetAllDay(const Value: Boolean);
begin
  if FAllDay = Value then
    Exit;
  FAllDay := Value;
  SetStartTime(FStartTime);
  SetEndTime(FEndTime);
end;

procedure TCDEvent.SetEndTime(const Value: TDateTime);
begin
  DeleteProp('DTEND');
  if FAllDay then
  begin
    FEndTime := Trunc(Value);
    FEndTimeTZ := nil;
    if (FEndTime < FStartTime) or (DaysBetween(FStartTime, FEndTime) = 0) then
      FEndTime := IncDay(FStartTime);
    SetPropValue('DTEND;VALUE=DATE', [], EncodeDate(FEndTime));
  end
  else
  begin
    FEndTime := Value;
    if (FEndTime < FStartTime) then
      FEndTime := FStartTime;
    if FEndTimeTZ = nil then
      SetPropValue('DTEND', [], DateTimeToiCalDate(FEndTime))
    else
    if FEndTimeTZ = TBundledTimeZone.GetTimeZone('UTC') then
      SetPropValue('DTEND', [], DateTimeToiCalDate(FEndTime) + 'Z')
    else
      SetPropValue('DTEND;TZID=' + FEndTimeTZ.ID, [], DateTimeToiCalDate(FEndTime))
  end;
end;

procedure TCDEvent.SetEndTimeDef(const Value: TDateTime);
begin
  if FEndTimeTZ = nil then
    EndTime := Value
  else
  begin
    FEndTime := FCalendar.DefaultTimeZone.ToUniversalTime(Value);
    EndTime := FEndTimeTZ.ToLocalTime(FEndTime);
  end;
end;

procedure TCDEvent.SetEndTimeLoc(const Value: TDateTime);
begin
  if FEndTimeTZ = nil then
    EndTime := Value
  else
  begin
    FEndTime := LocalDateTimeToUTC(Value);
    EndTime := FEndTimeTZ.ToLocalTime(FEndTime);
  end;
end;

procedure TCDEvent.SetEndTimeTZ(const Value: TBundledTimeZone);
begin
  if FEndTimeTZ = Value then
    Exit;
  FEndTimeTZ := Value;
  SetEndTime(EndTime);
end;

procedure TCDEvent.SetStartTime(const Value: TDateTime);
begin
  DeleteProp('DTSTART');
  if FAllDay then
  begin
    FStartTime := Trunc(Value);
    FStartTimeTZ := nil;
    if (FEndTime < FStartTime) or (DaysBetween(FStartTime, FEndTime) = 0) then
      SetEndTime(IncDay(FStartTime));
    SetPropValue('DTSTART;VALUE=DATE', [], EncodeDate(FStartTime));
  end
  else
  begin
    FStartTime := Value;
    if (FEndTime < FStartTime) then
      SetEndTime(FStartTime);
    if FStartTimeTZ = nil then
      SetPropValue('DTSTART', [], DateTimeToiCalDate(FStartTime))
    else
    if FStartTimeTZ = TBundledTimeZone.GetTimeZone('UTC') then
      SetPropValue('DTSTART', [], DateTimeToiCalDate(FStartTime) + 'Z')
    else
      SetPropValue('DTSTART;TZID=' + FStartTimeTZ.ID, [], DateTimeToiCalDate(FStartTime));
  end;
end;

procedure TCDEvent.SetStartTimeTZ(const Value: TBundledTimeZone);
begin
  if FStartTimeTZ = Value then
    Exit;
  FStartTimeTZ := Value;
  SetStartTime(StartTime);
end;

function TCDEvent.GetEndTime: TDateTime;
begin
  Result := FEndTime;
end;

function TCDEvent.GetEndTimeDef: TDateTime;
begin
  if FEndTimeTZ = nil then
    Result := EndTime
  else
  begin
    Result := FEndTimeTZ.ToUniversalTime(EndTime);
    Result := FCalendar.FDefaultTZ.ToLocalTime(Result);
  end;
end;

function TCDEvent.GetEndTimeLoc: TDateTime;
begin
  if FEndTimeTZ = nil then
    Result := EndTime
  else
  begin
    Result := FEndTimeTZ.ToUniversalTime(EndTime);
    Result := UTCDateTimeToLocal(Result);
  end;
end;

{TCDTask}

constructor TCDTask.Create(Calendar: TCDCalendar);
begin
  inherited Create(Calendar);
  FiCal.Text :=
    'BEGIN:VCALENDAR' + #13#10 +
    'VERSION:2.0' + #13#10 +
    'CALSCALE:GREGORIAN' + #13#10 +
    'BEGIN:VTODO' + #13#10 +
    'DTSTAMP:' + DateTimeToiCalDate(Now) + #13#10 +
    'UID:' + FileNameNoExt(FileNameOnly(FHRef)) + #13#10 +
    'SEQUENCE:0' + #13#10 +
    'END:VTODO' + #13#10 +
    'END:VCALENDAR';
  StartTimeTZ := Calendar.DefaultTimeZone;
  DueTimeTZ := Calendar.DefaultTimeZone;
end;

procedure TCDTask.SetiCal(const Value: WideString);
var
  I: Integer;
  S, Name, TZID: WideString;
begin
  inherited SetiCal(Value);
  FPriority := 0;
  FCompleted := False;
  I := FItemBegin;
  while I < FiCal.Count do
  begin
    S := FiCal[I];
    Name := GetPropertyName(S);
    if Name = 'DTSTART' then
    begin
      FStartTime := GetDateTime(S);
      if Pos('Z', GetValue(S)) <> 0 then
        FStartTimeTZ := TBundledTimeZone.GetTimeZone('UTC')
      else
      begin
        TZID := GetParams(S);
        if TZID <> '' then
          if Pos(WideString('TZID='), TZID) <> 0 then
          begin
            TZID := Copy(TZID, Pos(WideString('TZID='), TZID) + 5, MaxInt);
            if Pos(';', TZID) <> 0 then
              TZID := Copy(TZID, 1, Pos(';', TZID) - 1);
            try
              FStartTimeTZ := TBundledTimeZone.GetTimeZone(TZID);
            except
              FStartTimeTZ := nil;
            end;
          end;
      end;
    end
    else if Name = 'DUE' then
    begin
      FEndTime := GetDateTime(S);
      if Pos('Z', GetValue(S)) <> 0 then
        FEndTimeTZ := TBundledTimeZone.GetTimeZone('UTC')
      else
      begin
        TZID := GetParams(S);
        if TZID <> '' then
          if Pos(WideString('TZID='), TZID) <> 0 then
          begin
            TZID := Copy(TZID, Pos(WideString('TZID='), TZID) + 5, MaxInt);
            if Pos(';', TZID) <> 0 then
              TZID := Copy(TZID, 1, Pos(';', TZID) - 1);
            try
              FEndTimeTZ := TBundledTimeZone.GetTimeZone(TZID);
            except
              FEndTimeTZ := nil;
            end;
          end;
      end;
    end
    else if Name = 'PRIORITY' then
    begin
      FPriority := StrToIntDef(GetValue(S), 0);
    end
    else if Name = 'STATUS' then
    begin
      FCompleted := FCompleted or (GetValue(S) = 'COMPLETED');
    end
    else if Name = 'COMPLETED' then
    begin
      FCompleted := True;
    end
    else if Name = 'PERCENT-COMPLETE' then
    begin
      FCompleted := FCompleted or (GetValue(S) = '100');
    end
    else if Name = 'END' then
      if GetValue(S) = 'VTODO' then
        Break;
    Inc(I);
  end;
end;

procedure TCDTask.SetPriority(const Value: Byte);
begin
  FPriority := Max(Min(Value, 9), 0);
  SetPropValue('PRIORITY', [], IntToStr(FPriority));
end;

procedure TCDTask.SetStartTime(const Value: TDateTime);
begin
  DeleteProp('DTSTART');
  if Value = 0 then
  begin
    FStartTimeTZ := nil;
    Exit;
  end;
  if Frac(Value) = 0 then
  begin
    FStartTime := Trunc(Value);
    FStartTimeTZ := nil;
    if (FEndTime < FStartTime) or (DaysBetween(FStartTime, FEndTime) = 0) then
      SetDueTime(IncDay(FStartTime));
    SetPropValue('DTSTART;VALUE=DATE', [], EncodeDate(FStartTime));
  end
  else
  begin
    FStartTime := Value;
    if (FEndTime < FStartTime) then
      SetDueTime(FStartTime);
    if FStartTimeTZ = nil then
      SetPropValue('DTSTART', [], DateTimeToiCalDate(FStartTime))
    else
    if FStartTimeTZ = TBundledTimeZone.GetTimeZone('UTC') then
      SetPropValue('DTSTART', [], DateTimeToiCalDate(FStartTime) + 'Z')
    else
      SetPropValue('DTSTART;TZID=' + FStartTimeTZ.ID, [], DateTimeToiCalDate(FStartTime));
  end;
end;

procedure TCDTask.SetStartTimeTZ(const Value: TBundledTimeZone);
begin
  if FStartTimeTZ = Value then
    Exit;
  FStartTimeTZ := Value;
  SetStartTime(StartTime);
end;

procedure TCDTask.SetDueTime(const Value: TDateTime);
begin
  DeleteProp('DUE');
  if Value = 0 then
  begin
    FEndTimeTZ := nil;
    Exit;
  end;
  if Frac(Value) = 0 then
  begin
    FEndTime := Trunc(Value);
    FEndTimeTZ := nil;
    if (FEndTime < FStartTime) or (DaysBetween(FStartTime, FEndTime) = 0) then
      FEndTime := IncDay(FStartTime);
    SetPropValue('DUE', [], EncodeDate(FEndTime), 'DUE;VALUE=DATE');
  end
  else
  begin
    FEndTime := Value;
    if (FEndTime < FStartTime) then
      FEndTime := FStartTime;
    if FEndTimeTZ = nil then
      SetPropValue('DUE', [], DateTimeToiCalDate(FEndTime))
    else
    if FEndTimeTZ = TBundledTimeZone.GetTimeZone('UTC') then
      SetPropValue('DUE', [], DateTimeToiCalDate(FEndTime) + 'Z')
    else
      SetPropValue('DUE;TZID=' + FEndTimeTZ.ID, [], DateTimeToiCalDate(FEndTime))
  end;
end;

procedure TCDTask.SetDueTimeDef(const Value: TDateTime);
begin
  if (FEndTimeTZ = nil) or (Value = 0) then
    DueTime := Value
  else
  begin
    FEndTime := FCalendar.DefaultTimeZone.ToUniversalTime(Value);
    DueTime := FEndTimeTZ.ToLocalTime(FEndTime);
  end;
end;

procedure TCDTask.SetDueTimeLoc(const Value: TDateTime);
begin
  if (FEndTimeTZ = nil) or (Value = 0) then
    DueTime := Value
  else
  begin
    FEndTime := LocalDateTimeToUTC(Value);
    DueTime := FEndTimeTZ.ToLocalTime(FEndTime);
  end;
end;

procedure TCDTask.SetDueTimeTZ(const Value: TBundledTimeZone);
begin
  if FEndTimeTZ = Value then
    Exit;
  FEndTimeTZ := Value;
  SetDueTime(DueTime);
end;

procedure TCDTask.SetCompleted(const Value: Boolean);
begin
  FCompleted := Value;
  if FCompleted then
  begin
    SetPropValue('STATUS', [], 'COMPLETED');
    SetPropValue('PERCENT-COMPLETE', [], '100');
    SetPropValue('COMPLETED', [], DateTimeToiCalDate(Now));
  end
  else
  begin
    SetPropValue('STATUS', [], 'NEEDS-ACTION');
    DeleteProp('COMPLETED');
    DeleteProp('PERCENT-COMPLETE');
  end;
end;

function TCDTask.GetDueTime: TDateTime;
begin
  Result := FEndTime;
end;

function TCDTask.GetDueTimeDef: TDateTime;
begin
  if (FEndTimeTZ = nil) or (DueTime = 0) then
    Result := DueTime
  else
  begin
    Result := FEndTimeTZ.ToUniversalTime(DueTime);
    Result := FCalendar.FDefaultTZ.ToLocalTime(Result);
  end;
end;

function TCDTask.GetDueTimeLoc: TDateTime;
begin
  if (FEndTimeTZ = nil) or (DueTime = 0) then
    Result := DueTime
  else
  begin
    Result := FEndTimeTZ.ToUniversalTime(DueTime);
    Result := UTCDateTimeToLocal(Result);
  end;
end;

{ TCDItem }

procedure TCDItem.AddReminder(Value: TCDReminder);
var
  I: Integer;
  RemID: String;
begin
  FReminders.Add(Value);
  I := FiCal.Count;
  repeat
    Dec(I);
  until (GetPropertyName(FiCal[I]) = 'END') and ((GetValue(FiCal[I]) = 'VEVENT') OR (GetValue(FiCal[I]) = 'VTODO'));
  Randomize;
  RemID := DateTimeToiCalDate(Now) + IntToStr(Random(1000000));
  FiCal.Insert(I, 'BEGIN:VALARM' + #13#10 +
    'X-WR-ALARMUID:' + RemID + #13#10 +
    'ACTION:' + #13#10 +
    'DESCRIPTION:' + #13#10 +
    'TRIGGER:' + #13#10 +
    'END:VALARM');
  FiCal.Text := FiCal.Text; // to parse CRLFs from inserted WideString
  SetReminder(FReminders.Count - 1, Value);
end;

constructor TCDItem.Create(Calendar: TCDCalendar);
begin
  FCalendar := Calendar;
  if Trim(FCalendar.FUsedExtension) = '' then
    FCalendar.FUsedExtension := '.ics';
  FReminders := TObjectList.Create(True);
  FiCal := TStringList.Create;
  FCustomFields := TStringList.Create;
  Randomize;
  FHRef := FCalendar.FBaseURL + DateTimeToiCalDate(Now) + IntToStr(Random(1000000)) + FCalendar.FUsedExtension;
  FItemBegin := 3;
  FStored := False;
end;

procedure TCDItem.Delete(ABatch: Boolean);
begin
  if ABatch then
  begin
    FToStore := False;
    FToDelete := True;
  end
  else
  begin
    if FHRef <> '' then
    begin
      FCalendar.FHTTP.Disconnect;
      FCalendar.FHTTP.DAVDelete(FCalendar.FBaseURL + FileNameOnly(FHRef), '');
    end;
    FCalendar.FEvents.Remove(Self);
    FCalendar.FTasks.Remove(Self);
  end;
end;

procedure TCDItem.DeleteProp(const Prop: String);
var
  I: Integer;
begin
  I := FindProp(Prop, []);
  if I <> -1 then
    FiCal.Delete(I);
end;

procedure TCDItem.DeleteReminder(Index: Integer);
var
  I, J: Integer;
  Name: String;
  Value: WideString;
begin
  I := FiCal.Count;
  J := FReminders.Count;
  repeat
    Dec(I);
    Name := GetPropertyName(FiCal[I]);
    Value := GetValue(FiCal[I]);
    if (Name = 'END') and (Value = 'VALARM') then
      Dec(J);
    if J = Index then
      FiCal.Delete(I);
    if (J = 0) and (Name = 'BEGIN') and (Value = 'VALARM') then
      Dec(J);
  until I = 0;
  FReminders.Delete(Index);
end;

destructor TCDItem.Destroy;
begin
  FReminders.Free;
  FiCal.Free;
  FCustomFields.Free;
  inherited;
end;

function TCDItem.FindProp(const Prop: String;
  const Params: array of String): Integer;
var
  I, J, Level: Integer;
  Found: Boolean;
begin
  I := FItemBegin;
  Level := 0;
  repeat
    Found := false;
    Inc(I);
    if GetPropertyName(FiCal[I]) = 'BEGIN' then
      Inc(Level)
    else if GetPropertyName(FiCal[I]) = 'END' then
      Dec(Level)
    else if (GetPropertyName(FiCal[I]) = Prop) and (Level = 0) then
    begin
      Found := True;
      if (Length(Params) > 0) and (Params[0] = '') and (GetParams(FiCal[I]) = '') then
        Break;
      for J := 0 to Length(Params) - 1 do
        if Pos(Params[J], GetParams(FiCal[I])) = 0 then
          Found := false;
    end;
  until Found or (I = FiCal.Count - 1);
  if I <> FiCal.Count - 1 then
    Result := I
  else
    Result := -1;
end;

function TCDItem.GetiCal: WideString;
var
  I, J: Integer;
  TZID: String;
  TZ: TBundledTimeZone;
  CustomAdded: Boolean;
begin
  CustomAdded := False;
  with TStringList.Create do
  try
    for J := 0 to FiCal.Count - 1 do
    begin
      TZID := GetParams(FiCal[J]);
      if Pos('TZID=', TZID) > 0 then
      begin
        TZID := Copy(TZID, Pos('TZID=', TZID) + 5, MaxInt);
        if Pos(';', TZID) <> 0 then
          TZID := Copy(TZID, 1, Pos(';', TZID) - 1);
        if IndexOf(TZID) < 0 then
          Add(TZID);
      end;
    end;
    Result := '';
    I := 0;
    repeat
      Result := Result + FiCal[I] + #13#10;
      Inc(I);
    until I = FItemBegin;
    for J := 0 to Count - 1 do
    begin
      TZ := TBundledTimeZone.GetTimeZone(Strings[J]);
      if TZ <> nil then
        if FCalendar.TimeZoneAvailable(TZ.ID) then
          Result := Result + FCalendar.GetiCalendarCodeForTZ(TZ);
    end;
    repeat
      Result := Result + FiCal[I] + #13#10;
      Inc(I);
      if not CustomAdded then
      begin
        for J := 0 to FCustomFields.Count - 1 do
          Result := Result + FCustomFields[J] + #13#10;
        CustomAdded := True;
      end;
    until I = FiCal.Count;
  finally
    Free;
  end;
end;

function TCDItem.GetID: String;
begin
  Result := FileNameOnly(FHRef);
end;

function TCDItem.GetLastModified: TDateTime;
begin
  Result := FLastModified;
  if Result = 0 then
    Result := FDTStamp;
end;

function TCDItem.GetLastModifiedLocal: TDateTime;
begin
  Result := UTCDateTimeToLocal(GetLastModified);
end;

function TCDItem.GetReminder(Index: Integer): TCDReminder;
begin
  Result := TCDReminder(FReminders[Index]);
end;

function TCDItem.GetReminderCount: Integer;
begin
  Result := FReminders.Count;
end;

function TCDItem.GetStartTimeDef: TDateTime;
begin
  if (FStartTimeTZ = nil) or (StartTime = 0) then
    Result := StartTime
  else
  begin
    Result := FStartTimeTZ.ToUniversalTime(StartTime);
    Result := FCalendar.FDefaultTZ.ToLocalTime(Result);
  end;
end;

function TCDItem.GetStartTimeLoc: TDateTime;
begin
  if (FStartTimeTZ = nil) or (StartTime = 0) then
    Result := StartTime
  else
  begin
    Result := FStartTimeTZ.ToUniversalTime(StartTime);
    Result := UTCDateTimeToLocal(Result);
  end;
end;

procedure TCDItem.ResetStoring;
begin
  FToDelete := False;
  FToStore := False;
end;

procedure TCDItem.SetCategories(const Value: WideString);
begin
  if FCategories = Value then
    Exit;
  FCategories := Value;
  SetPropValue('CATEGORIES', [], Value);
end;

procedure TCDItem.SetDescription(const Value: WideString);
begin
  if FDescription = Value then
    Exit;
  FDescription := Value;
  SetPropValue('DESCRIPTION', [], StringReplace(Value, #13#10, '\n', [rfReplaceAll]));
end;

procedure TCDItem.SetiCal(const Value: WideString);
var
  I: Integer;
  Catch: Integer;
  Name: String;
  S: WideString;
  TimeZone: Boolean;
  NewRem: TCDReminder;
begin
  FCustomFields.Clear;
  FiCal.Text := Value;
  for I := FiCal.Count - 1 downto 1 do
  begin
    S := FiCal[I];
    if (S <> '') and (S[1] = ' ') then
    begin
      FiCal[I - 1] := FiCal[I - 1] + Copy(S, 2, MaxInt);
      FiCal.Delete(I);
    end;
    S := FiCal[I - 1];
    if (Length(S) > 0) and (S[Length(S)] = '=') then
    begin
      FiCal[I - 1] := Copy(S, 1, Length(S) - 1) + FiCal[I];
      FiCal.Delete(I);
    end;
  end;
  Catch := 0;
  for I := FiCal.Count - 1 downto 0 do
    if (Pos('X-', FiCal[I]) = 1) and (Catch = 1) then
    begin
      FCustomFields.Insert(0, FiCal[I]);
      FiCal.Delete(I);
    end
    else
    if (Pos('END:VEVENT', FiCal[I]) = 1) or (Pos('END:VTODO', FiCal[I]) = 1) then
      Break
    else
    if (Pos('BEGIN:VEVENT', FiCal[I]) = 1) or (Pos('BEGIN:VTODO', FiCal[I]) = 1) then
      Catch := 1
    else
    if (Pos('END:', FiCal[I]) = 1) then
      Inc(Catch, 1)
    else
    if (Pos('BEGIN:', FiCal[I]) = 1) then
      Inc(Catch, -1);
  FPrivacy := epPublic;
  FTitle := '';
  FDescription := '';
  FCategories := '';
  FPrivacy := epPublic;
  FRepeatRule := '';
  FLocation := '';
  FItemBegin := 0;
  FSequence := 0;
  FStartTimeTZ := nil;
  FEndTimeTZ := nil;
  FReminders.Clear;
  FLastModified := 0;
  FDTStamp := 0;
  // Clearing timezone info
  I := 0;
  TimeZone := False;
  repeat
    if (Trim(FiCal[I]) = 'BEGIN:VTIMEZONE') or (TimeZone) then
    begin
      TimeZone := True;
      if Trim(FiCal[I]) = 'END:VTIMEZONE' then
        TimeZone := False;
      FiCal.Delete(I);
      Continue;
    end;
    Inc(I);
  until I >= FiCal.Count;
  I := 0;
  while I < FiCal.Count do
  begin
    if GetPropertyName(FiCal[I]) = 'BEGIN' then
      if (GetValue(FiCal[I]) = 'VEVENT') or (GetValue(FiCal[I]) = 'VTODO') then
        Break;
    Inc(I);
  end;
  if I < FiCal.Count then
    FItemBegin := I;
  while I < FiCal.Count do
  begin
    S := FiCal[I];
    Name := GetPropertyName(S);
    if Name = 'BEGIN' then
    begin
      if GetValue(S) = 'VALARM' then
      begin
        // Parse reminders
        NewRem := TCDReminder.Create(FCalendar);
        FReminders.Add(NewRem);
        with NewRem do
          repeat
            Inc(I);
            S := FiCal[I];
            Name := GetPropertyName(S);
            if Name = 'TRIGGER' then
            begin
              if Pos(WideString('VALUE=DATE-TIME'), S) = 0 then
                GetTrigger(S, NewRem)
              else
              begin
                Period := rpDateTime;
                DateTime := GetDateTime(S);
              end;
            end
            else if Name = 'ACTION' then
            begin
              if GetValue(S) = 'EMAIL' then
                Method := rmEmail
              else
                Method := rmPopUp;
            end;
          until S = 'END:VALARM';
      end;
    end
    else if Name = 'LAST-MODIFIED' then
    begin
      FLastModified := GetDateTime(S);
    end
    else if Name = 'DTSTAMP' then
    begin
      FDTStamp := GetDateTime(S);
    end
    else if (Name = 'LAST-MODIFIED') and (FLastModified = 0) then
    begin
      FLastModified := GetDateTime(S);
    end
    else if Name = 'SUMMARY' then
      FTitle := GetValue(S)
    else if Name = 'DESCRIPTION' then
      FDescription := StringReplace(GetValue(S), '\n', #13#10, [rfReplaceAll])
    else if Name = 'CATEGORIES' then
      FCategories := GetValue(S)
    else if Name = 'CLASS' then
    begin
      if GetValue(S) = 'PRIVATE' then
        FPrivacy := epPrivate
      else
        FPrivacy := epPublic;
    end
    else if Name = 'LOCATION' then
      FLocation := GetValue(S)
    else if Name = 'RRULE' then
      FRepeatRule := GetValue(S)
    else if Name = 'SEQUENCE' then
      FSequence := StrToIntDef(GetValue(S), 0)
    else if Name = 'END' then
      if (GetValue(S) = 'VEVENT') or (GetValue(S) = 'VTODO') then
        Break;
    Inc(I);
  end;
  FStored := True;
end;

procedure TCDItem.SetLocation(const Value: WideString);
begin
  if FLocation = Value then
    Exit;
  FLocation := Value;
  SetPropValue('LOCATION', [], Value);
end;

procedure TCDItem.SetPrivacy(const Value: TEventPrivacy);
begin
  if FPrivacy = Value then
    Exit;
  FPrivacy := Value;
  case Value of
    epPublic, epDefault: SetPropValue('CLASS', [], 'PUBLIC');
    epPrivate: SetPropValue('CLASS', [], 'PRIVATE');
  end;
end;

procedure TCDItem.SetPropValue(const Prop: String;
  const Params: array of String; const Value: WideString;
  const NewProp: String);
var
  I: Integer;
begin
  I := FindProp(Prop, Params);
  if NewProp = '' then
  begin
    if I <> -1 then
      FiCal[I] := Prop + ':' + Value
    else
      FiCal.Insert(FItemBegin + 1, Prop + ':' + Value);
  end
  else
  begin
    if I <> -1 then
      FiCal[I] := NewProp + ':' + Value
    else
      FiCal.Insert(FItemBegin + 1, NewProp + ':' + Value);
  end;
end;

procedure TCDItem.SetReminder(Index: Integer; Value: TCDReminder);
var
  I, J: Integer;
begin
  FReminders[Index] := Value;
  I := -1;
  J := -1;
  repeat
    Inc(I);
    if (GetPropertyName(FiCal[I]) = 'BEGIN') then
      if (GetValue(FiCal[I]) = 'VALARM') then
        Inc(J);
    if J = Index then
      Break;
  until I = FiCal.Count - 1;
  repeat
    Inc(I);
    if GetPropertyName(FiCal[I]) = 'DESCRIPTION' then
    begin
      if Self is TCDTask then
        FiCal[I] := 'DESCRIPTION:Task reminder'
      else
        FiCal[I] := 'DESCRIPTION:Event reminder';
    end;
    if GetPropertyName(FiCal[I]) = 'TRIGGER' then
    begin
      if Value.Period <> rpDateTime then
        FiCal[I] := 'TRIGGER;RELATED=START:' + SetTrigger(Value.Period, Value.PeriodsCount)
      else
        FiCal[I] := 'TRIGGER;VALUE=DATE-TIME:' + DateTimeToiCalDate(Value.DateTime) + 'Z';
    end;
    if GetPropertyName(FiCal[I]) = 'ACTION' then
      case Value.Method of
        rmPopUp: FiCal[I] := 'ACTION:DISPLAY';
        rmEmail: FiCal[I] := 'ACTION:EMAIL';
      end;
  until (GetPropertyName(FiCal[I]) = 'END') and (GetValue(FiCal[I]) = 'VALARM');
end;

procedure TCDItem.SetRepeatRule(const Value: String);
begin
  if FRepeatRule = Value then
    Exit;
  FRepeatRule := Value;
  SetPropValue('RRULE', [], Value);
end;

procedure TCDItem.SetStartTimeDef(const Value: TDateTime);
begin
  if (FStartTimeTZ = nil) or (Value = 0) then
    StartTime := Value
  else
  begin
    FStartTime := FCalendar.DefaultTimeZone.ToUniversalTime(Value);
    StartTime := FStartTimeTZ.ToLocalTime(FStartTime);
  end;
end;

procedure TCDItem.SetStartTimeLoc(const Value: TDateTime);
begin
  if (FStartTimeTZ = nil) or (Value = 0) then
    StartTime := Value
  else
  begin
    FStartTime := LocalDateTimeToUTC(Value);
    StartTime := FStartTimeTZ.ToLocalTime(FStartTime);
  end;
end;

procedure TCDItem.SetTitle(const Value: WideString);
begin
  if FTitle = Value then
    Exit;
  FTitle := Value;
  SetPropValue('SUMMARY', [], Value);
end;

procedure TCDItem.Store(ABatch: Boolean);
var
  S: TStringStream;
  URL: String;
begin
  if ABatch then
  begin
    FToStore := True;
    FToDelete := False;
  end
  else
  begin
    SetPropValue('DTSTAMP', [], DateTimeToiCalDate(Now));
    DeleteProp('LAST-MODIFIED');
    Inc(FSequence);
    SetPropValue('SEQUENCE', [], IntToStr(FSequence));
    FCalendar.FHTTP.Disconnect;
    URL := FCalendar.FBaseURL + FileNameOnly(FHRef);
    S := TStringStream.Create(UTF8Encode(iCal));
    try
      if not FStored then
        FCalendar.FHTTP.Request.CustomHeaders.Add('If-None-Match:*');
      FCalendar.FHTTP.Request.ContentType := 'text/calendar; charset=UTF-8';
      FCalendar.FHTTP.Put(URL, S);
      if FCalendar.FHTTP.ResponseCode div 100 <> 2 then
        raise Exception.Create(FCalendar.FHTTP.ResponseText);
      FHRef := URL;
    finally
      if FCalendar.FHTTP.Request.CustomHeaders.IndexOfName('If-None-Match') <> -1 then
        FCalendar.FHTTP.Request.CustomHeaders.Delete(FCalendar.FHTTP.Request.CustomHeaders.IndexOfName('If-None-Match'));
      S.Free;
    end;
  end;
end;

{ TCDReminder }

constructor TCDReminder.Create(Calendar: TCDCalendar);
begin
  inherited Create;
  FCalendar := Calendar;
end;

function TCDReminder.GetDateTimeDef: TDateTime;
begin
  if DateTime = 0 then
    Result := 0
  else
    Result := FCalendar.DefaultTimeZone.ToLocalTime(DateTime);
end;

function TCDReminder.GetDateTimeLoc: TDateTime;
begin
  if DateTime = 0 then
    Result := 0
  else
    Result := UTCDateTimeToLocal(DateTime);
end;

procedure TCDReminder.SetDateTimeDef(const Value: TDateTime);
begin
  if Value = 0 then
    DateTime := 0
  else
    DateTime := FCalendar.DefaultTimeZone.ToUniversalTime(Value);
end;

procedure TCDReminder.SetDateTimeLoc(const Value: TDateTime);
begin
  if Value = 0 then
    DateTime := 0
  else
    DateTime := LocalDateTimeToUTC(Value);
end;

{ TStoreThread }

constructor TStoreThread.Create(AItem: TCDItem; WaitEvent: THandle);
begin
  inherited Create(True);
  FItem := AItem;
  FWaitEvent := WaitEvent;
  FHTTP := TIdWebDAV.Create(nil);
  FSSLIO := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  FHTTP.IOHandler := FSSLIO;
  FHTTP.AllowCookies := True;
  FHTTP.HandleRedirects := True;
  FHTTP.RedirectMaximum := 4;
  FHTTP.ConnectTimeout := 30000;
  FHTTP.ReadTimeout := 30000;
  FHTTP.Request.UserAgent := 'Mozilla/5.0';
  FHTTP.HTTPOptions := AItem.FCalendar.FHTTP.HTTPOptions;
  FHTTP.Request.BasicAuthentication := AItem.FCalendar.FHTTP.Request.BasicAuthentication;
  FHTTP.IOHandler.RecvBufferSize := 50 * 1024;
  FHTTP.IOHandler.SendBufferSize := 50 * 1024;
  FHTTP.ProxyParams.Assign(AItem.FCalendar.FHTTP.ProxyParams);
  FHTTP.Request.Username := AItem.FCalendar.FHTTP.Request.Username;
  FHTTP.Request.Password := AItem.FCalendar.FHTTP.Request.Password;
  FHTTP.Intercept := AItem.FCalendar.FHTTP.Intercept;
  AItem.FCalendar.ApplyProxySettings(FHTTP, FSSLIO);
  FreeOnTerminate := True;
  FBaseURL := FItem.FCalendar.FBaseURL;
  if Trim(FBaseURL) = '' then
    raise Exception.Create('Base URL can not be empty');
  if FBaseURL[Length(FBaseURL)] <> '/' then
    FBaseURL := FBaseURL + '/';
  Resume;
end;

destructor TStoreThread.Destroy;
begin
  FSSLIO.Free;
  FHTTP.Free;
  SetEvent(FWaitEvent);
  inherited;
end;

procedure TStoreThread.Execute;
var
  URL: String;
  S: TStringStream;
begin
  with FItem do
  try
    try
      if FToDelete then
      begin
        if FHRef <> '' then
        begin
          FHTTP.Disconnect;
          FHTTP.DAVDelete(FBaseURL + FileNameOnly(FHRef), '');
        end;
      end
      else
      if FToStore then
      begin
        SetPropValue('DTSTAMP', [], DateTimeToiCalDate(Now));
        DeleteProp('LAST-MODIFIED');
        Inc(FSequence);
        SetPropValue('SEQUENCE', [], IntToStr(FSequence));
        FHTTP.Disconnect;
        URL := FBaseURL + FileNameOnly(FHRef);
        S := TStringStream.Create(UTF8Encode(iCal));
        try
          if not FStored then
            FHTTP.Request.CustomHeaders.Add('If-None-Match:*');
          FHTTP.Request.ContentType := 'text/calendar; charset=UTF-8';
          FHTTP.Put(URL, S);
          if FHTTP.ResponseCode div 100 <> 2 then
            raise Exception.Create(FHTTP.ResponseText);
          FHRef := URL;
        finally
          if FHTTP.Request.CustomHeaders.IndexOfName('If-None-Match') <> -1 then
            FHTTP.Request.CustomHeaders.Delete(FHTTP.Request.CustomHeaders.IndexOfName('If-None-Match'));
          S.Free;
        end;
      end;
      FStoreError := 'OK';
    except
      on E: Exception do
      begin
        FStoreError := E.Message;
        Exit;
      end
      else
        Exit;
    end;
  finally
    FCalendar.FCriticalSection.Enter;
    try
      FCalendar.FStoreThreads.Remove(Self);
      FStoreThread := nil;
    finally
      FCalendar.FCriticalSection.Leave;
    end;
  end;
end;

{ TMultigetThread }

constructor TMultigetThread.Create(Calendar: TCDCalendar; Multiget: string; WaitEvent: THandle);
begin
  inherited Create(True);
  FCalendar := Calendar;
  FMultiget := Multiget;
  FWaitEvent := WaitEvent;
  FHTTP := TIdWebDAV.Create(nil);
  FSSLIO := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  FHTTP.IOHandler := FSSLIO;
  FHTTP.AllowCookies := True;
  FHTTP.HandleRedirects := True;
  FHTTP.RedirectMaximum := 4;
  FHTTP.ConnectTimeout := 10000;
  FHTTP.ReadTimeout := 20000;
  FHTTP.Request.UserAgent := 'Mozilla/5.0';
  FHTTP.HTTPOptions := Calendar.FHTTP.HTTPOptions;
  FHTTP.Request.BasicAuthentication := Calendar.FHTTP.Request.BasicAuthentication;
  FHTTP.IOHandler.RecvBufferSize := 50 * 1024;
  FHTTP.IOHandler.SendBufferSize := 50 * 1024;
  FHTTP.ProxyParams.Assign(Calendar.FHTTP.ProxyParams);
  FHTTP.Request.Username := Calendar.FHTTP.Request.Username;
  FHTTP.Request.Password := Calendar.FHTTP.Request.Password;
  FHTTP.Intercept := Calendar.FHTTP.Intercept;
  Calendar.ApplyProxySettings(FHTTP, FSSLIO);
  FreeOnTerminate := True;
  FBaseURL := FCalendar.FBaseURL;
  if Trim(FBaseURL) = '' then
    raise Exception.Create('Base URL can not be empty');
  if FBaseURL[Length(FBaseURL)] <> '/' then
    FBaseURL := FBaseURL + '/';
  Resume;
end;

destructor TMultigetThread.Destroy;
begin
  FSSLIO.Free;
  FHTTP.Free;
  SetEvent(FWaitEvent);
  inherited;
end;

procedure TMultigetThread.DoProcessResponse;
var
  Multiget: string;
begin
  Multiget := 'none';
  FCalendar.ParseMultigetResponse('', FResponse, True, 0, Multiget);
end;

procedure TMultigetThread.Execute;
var
  Req, Resp: TStringStream;
begin
  Resp := TStringStream.Create('');
  CoInitialize(nil);
  try
    FHTTP.Disconnect;
    FHTTP.Request.ContentType := 'application/xml; charset=utf-8';
    if (FMultiGet <> '') and (FMultiget <> 'none') then
    begin
      Req := TStringStream.Create(
        '<?xml version="1.0" encoding="utf-8" ?>' + #13#10 +
        '<C:calendar-multiget xmlns:D="DAV:" xmlns:C="urn:ietf:params:xml:ns:caldav">' + #13#10 +
        '  <D:prop>' + #13#10 +
        '    <D:getetag/>' + #13#10 +
        '    <D:getlastmodified/>' + #13#10 +
        '    <C:calendar-data/>' + #13#10 +
        '  </D:prop>' + #13#10 +
        FMultiGet +
        '</C:calendar-multiget>'
      );
      Resp.Size := 0;
    end;
    try
      FHTTP.DAVReport(FBaseURL, Req, Resp);
      if FHTTP.ResponseCode div 100 <> 2 then
        raise Exception.Create(FHTTP.ResponseText);
    except
      FCalendar.FLoadError := True;
      Exit;
    end;
    FResponse := Resp.DataString;
    if not FCalendar.FCancelMultiget then
      DoProcessResponse;
  finally
    FCalendar.FCriticalSection.Enter;
    try
      FCalendar.FMultigetThreads.Remove(Self);
    finally
      FCalendar.FCriticalSection.Leave;
    end;
    SetEvent(FWaitEvent);
    CoUninitialize;
    Resp.Free;
    Req.Free;
  end;
end;

var
  kernel32: HModule;
initialization
  try
    kernel32 := GetModuleHandle('kernel32');
    if kernel32 <> 0 then
      @GetDynamicTimeZoneInformation_ := GetProcAddress(kernel32, 'GetDynamicTimeZoneInformation');
  except
  end;
{$IFDEF DEMO}
  if DebugHook = 0 then
  begin
    MessageBox(0, 'CalDAV trial version requires Delphi IDE!', 'Error', 0);
    Halt(1);
  end;
{$ENDIF}
end.

