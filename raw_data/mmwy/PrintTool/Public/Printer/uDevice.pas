unit uDevice;

{$mode objfpc}
{$H+}

interface

uses
  Classes, Windows, SysUtils, fpjson, uTooanClass;

const
  SUCCESS_CODE: integer = 10000;
  UNKNOW_ERROR_CODE: integer = 99999;
  UNSUPPORT_PORTTYPE_ERROR_CODE: integer = 99998;
  INVALID_HANDLE_ERROR_CODE: integer = 99997;
  OPEN_PRINTER_ERROR_CODE: integer = 80000;
  START_DOC_PRINTER_ERROR_CODE: integer = 80001;
  START_PAGE_PRINTER_ERROR_CODE: integer = 80002;
  WRITE_PRINTER_ERROR_CODE: integer = 80003;

type
  { IPrinterException }
  IPrinterException = interface(ITooanIface)
    function GetErrorCode: integer;
    procedure SetErrorCode(const AErrorCode: integer);
    property ErrorCode: integer read GetErrorCode write SetErrorCode;
  end;

  { TPrinterException }
  TPrinterException = class(TTooanException, IPrinterException)
    {
  private
    FErrorCode: integer;
  public
    constructor Create(AErrorCode: integer); overload;
    constructor Create(AErrorCode: integer; aErrorMessage: string); overload;
    destructor Destroy; override;

    function GetErrorCode: integer;
    procedure SetErrorCode(const AErrorCode: integer);

    property ErrorCode: integer read GetErrorCode write SetErrorCode;
    }
  end;

  { IResult }
  IResult = interface(ITooanIface)
    function GetSuccess: boolean;
    function GetRetCode: integer;
    procedure SetRetCode(const ARetCode: integer);
    function GetRetMessage: string;
    procedure SetRetMessage(const ARetMessage: string);
    function AsJSON: string;

    property Success: boolean read GetSuccess;
    property RetCode: integer read GetRetCode write SetRetCode;
    property RetMessage: string read GetRetMessage write SetRetMessage;
  end;

  { TResult }
  TResult = class(TTooanAbstractClass, IResult)
  private
    FRetCode: integer;
    FRetMessage: string;
  public
    constructor Create; overload;
    constructor Create(E: Exception); overload;
    constructor Create(aRetCode: integer; aRetMessage: string); overload;
    destructor Destroy; override;

    function GetSuccess: boolean;
    function GetRetCode: integer;
    procedure SetRetCode(const ARetCode: integer);
    function GetRetMessage: string;
    procedure SetRetMessage(const ARetMessage: string);
    function AsJSON: string;

    property Success: boolean read GetSuccess;
    property RetCode: integer read GetRetCode write SetRetCode;
    property RetMessage: string read GetRetMessage write SetRetMessage;
  end;

  { IDevice }
  IDevice = interface(ITooanIface)
    function GetDeviceName: string;
    procedure SetDeviceName(const ADeviceName: string);
    function GetDevicePath: string;
    procedure SetDevicePath(const ADevicePath: string);
    function GetDeviceId: string;
    procedure SetDeviceId(const ADeviceId: string);
    function GetDisplayName: string;
    function AsJSON: string;

    property DeviceName: string read GetDeviceName write SetDeviceName;
    property DevicePath: string read GetDevicePath write SetDevicePath;
    property DeviceId: string read GetDeviceId write SetDeviceId;
    property DisplayName: string read GetDisplayName;
  end;

  IDeviceArray = array of IDevice;
  { TDevice }
  TDevice = class(TTooanAbstractClass, IDevice)
  private
    FDeviceName: string;
    FDevicePath: string;
    FDeviceId: string;
  public
    constructor Create(const ADevicePath: string); overload;
    constructor Create(const ADevicePath, ADeviceId: string); overload;
    destructor Destroy; override;

    function GetDeviceName: string;
    procedure SetDeviceName(const ADeviceName: string);
    function GetDevicePath: string;
    procedure SetDevicePath(const ADevicePath: string);
    function GetDeviceId: string;
    procedure SetDeviceId(const ADeviceId: string);
    function GetDisplayName: string;
    function AsJSON: string;

    property DeviceName: string read GetDeviceName write SetDeviceName;
    property DevicePath: string read GetDevicePath write SetDevicePath;
    property DeviceId: string read GetDeviceId write SetDeviceId;
    property DisplayName: string read GetDisplayName;
  end;

  TDeviceArray = array of TDevice;
  { ILoadDevicesResult }
  ILoadDevicesResult = interface
    function GetDeviceArray: IDeviceArray;
    procedure SetDeviceArray(const ADeviceArray: IDeviceArray);
    function AsJSON: string;

    property DeviceArray: IDeviceArray read GetDeviceArray write SetDeviceArray;
  end;

  { TLoadDevicesResult }
  TLoadDevicesResult = class(TResult, ILoadDevicesResult)
  private
    FDeviceArray: IDeviceArray;
  public
    constructor Create(ADeviceArray: IDeviceArray); overload;

    function GetDeviceArray: IDeviceArray;
    procedure SetDeviceArray(const ADeviceArray: IDeviceArray);
    function AsJSON: string;

    property DeviceArray: IDeviceArray read GetDeviceArray write SetDeviceArray;
  end;

function LoadDevices(GUID_DevClass: TGUID): IDeviceArray;
procedure WriteTo(Content: PAnsiChar; gm_DeviceHandle: THandle);

implementation

uses
  uDevGUID, uSetupApi, uSetupDiGetClassDevs, uSetupDiDestroyDeviceInfoList, uSetupDiEnumDeviceInfo,
  uSetupDiEnumDeviceInterfaces, uSetupDiGetDeviceRegistryProperty, uSetupDiGetInterfaceDeviceDetail;

function GetDeviceId(const lpFileName: string): string;
var
  m_hPortHandle: THandle;
  lpOutBuffer: array [0 .. 512] of char;
  nOutBufferSize: DWORD;
  lpBytesReturned: DWORD;
begin
  Result := EmptyStr;
  m_hPortHandle := CreateFile(PChar(lpFileName), GENERIC_READ or GENERIC_WRITE, FILE_SHARE_READ or FILE_SHARE_WRITE,
    nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  try
    if m_hPortHandle <> INVALID_HANDLE_VALUE then
    begin
      nOutBufferSize := SizeOf(lpOutBuffer);
      FillChar(lpOutBuffer, nOutBufferSize, #0);
      lpBytesReturned := DWORD(integer(0));
      if DeviceIoControl(m_hPortHandle, IOCTL_USBPRINT_GET_1284_ID, nil, 0, @lpOutBuffer, nOutBufferSize, lpBytesReturned, nil) then
      begin
        Result := lpOutBuffer;
      end;
    end;
  finally
    if INVALID_HANDLE_VALUE <> m_hPortHandle then
    begin
      CloseHandle(m_hPortHandle);
    end;
  end;
end;

function GetDeviceName(hardwareDeviceInfo: HDEVINFO; i: DWORD): string;
var
  pszText: PChar;
  DeviceInfoData: TSPDevInfoData;
begin
  Result := EmptyStr;
  DeviceInfoData.cbSize := SizeOf(TSPDevInfoData);
  if SetupDiEnumDeviceInfo(hardwareDeviceInfo, i, DeviceInfoData) then
  begin
    GetMem(pszText, 256);
    try
      ConstructDeviceName(hardwareDeviceInfo, DeviceInfoData, pszText, DWORD(nil));
      Result := StrPas(pszText);
    finally
      FreeMem(pszText);
    end;
  end;
end;

function GetDevicePath(hardwareDeviceInfo: HDEVINFO; var DeviceInterfaceData: TSPDeviceInterfaceData): string;
var
  DevInfoData: TSPDevInfoData;
  DeviceInterfaceDetailData: PSPDeviceInterfaceDetailData;
  RequiredSize, DeviceInterfaceDetailDataSize: DWORD;
begin
  Result := EmptyStr;
  DevInfoData.cbSize := SizeOf(DevInfoData);
  DeviceInterfaceData.cbSize := SizeOf(TSPDeviceInterfaceData);
  RequiredSize := DWORD(integer(0));
  SetupDiGetInterfaceDeviceDetail(hardwareDeviceInfo, @DeviceInterfaceData, nil, 0, @RequiredSize, nil);
  // @RequiredSize, @DevInfoData);
  if (RequiredSize <> 0) and (GetLastError = ERROR_INSUFFICIENT_BUFFER) then
  begin
    DeviceInterfaceDetailDataSize := RequiredSize;
    DeviceInterfaceDetailData := AllocMem(DeviceInterfaceDetailDataSize);
    {$IFDEF WIN32}
    DeviceInterfaceDetailData^.cbSize := 5;
    {$ELSE}
    DeviceInterfaceDetailData^.cbSize := SizeOf(DeviceInterfaceDetailData);
    {$ENDIF WIN32}
    if SetupDiGetInterfaceDeviceDetail(hardwareDeviceInfo, @DeviceInterfaceData, DeviceInterfaceDetailData,
      DeviceInterfaceDetailDataSize, @RequiredSize, @DevInfoData) then

    begin
      Result := StrPas(DeviceInterfaceDetailData^.DevicePath);
    end;
    FreeMem(DeviceInterfaceDetailData);
  end;
end;

function LoadDevices(GUID_DevClass: TGUID): IDeviceArray;
var
  hardwareDeviceInfo: HDEVINFO;
  DeviceInterfaceData: TSPDeviceInterfaceData;
  i: DWORD;
  Device: IDevice;
begin
  SetLength(Result, 0);
  try
    // Get a handle to all devices in all classes present on system
    hardwareDeviceInfo := SetupDiGetClassDevs(@GUID_DevClass, nil, 0, (DIGCF_PRESENT or DIGCF_DEVICEINTERFACE));
    // hardwareDeviceInfo := SetupDiGetClassDevs(@GUID_DevClass, nil, 0, (DIGCF_PRESENT));
    if (hardwareDeviceInfo = Pointer(INVALID_HANDLE_VALUE)) then
    begin
      raise Exception.Create('INVALID_HANDLE_VALUE');
    end;
    DeviceInterfaceData.cbSize := SizeOf(TSPDeviceInterfaceData);
    i := DWORD(integer(0));
    while SetupDIEnumDeviceInterfaces(hardwareDeviceInfo, nil, GUID_DevClass, i, DeviceInterfaceData) do
    begin
      Device := TDevice.Create;
      Device.DeviceName := GetDeviceName(hardwareDeviceInfo, i);
      Device.DevicePath := GetDevicePath(hardwareDeviceInfo, DeviceInterfaceData);
      Device.DeviceId := GetDeviceId(Device.DevicePath);
      Inc(i);
      SetLength(Result, i);
      Result[i - 1] := Device;
    end;
  finally
    SetupDiDestroyDeviceInfoList(hardwareDeviceInfo);
  end;
end;

procedure WriteTo(Content: PAnsiChar; gm_DeviceHandle: THandle);
var
  ByteToWrite, BytesWritten: DWORD;
  overlap: TOVERLAPPED;
begin
  ByteToWrite := Length(content);
  if ByteToWrite > 0 then
  begin
    FillChar(overlap, SizeOf(overlap), #0);
    overlap.hEvent := CreateEvent(nil, True, False, nil);
    if overlap.hEvent <> INVALID_HANDLE_VALUE then
    begin
      if not WriteFile(gm_DeviceHandle, Content[0], ByteToWrite, BytesWritten, @overlap) then
      begin
        if GetLastError = ERROR_IO_PENDING then  // 函数返回但I/O操作仍未完成
        begin
          WaitForSingleObject(overlap.hEvent, INFINITE);
          GetOverlappedResult(gm_DeviceHandle, overlap, BytesWritten, False);
          CancelIo(gm_DeviceHandle);
        end;
      end;
    end;
  end;
end;

{ TResult }

function TResult.GetRetCode: integer;
begin
  Result := FRetCode;
end;

function TResult.GetRetMessage: string;
begin
  Result := FRetMessage;
end;

function TResult.GetSuccess: boolean;
begin
  Result := (FRetCode = SUCCESS_CODE);
end;

procedure TResult.SetRetCode(const ARetCode: integer);
begin
  FRetCode := ARetCode;
end;

procedure TResult.SetRetMessage(const ARetMessage: string);
begin
  FRetMessage := ARetMessage;
end;

constructor TResult.Create(ARetCode: integer; ARetMessage: string);
begin
  inherited Create;
  FRetCode := ARetCode;
  FRetMessage := ARetMessage;
end;

constructor TResult.Create;
begin
  self.Create(SUCCESS_CODE, 'SUCCESS_CODE');
end;

constructor TResult.Create(E: Exception);
begin
  if E.InheritsFrom(TPrinterException) then
    self.Create(TPrinterException(E).ErrorCode, E.Message)
  else
    self.Create(UNKNOW_ERROR_CODE, E.Message);
end;

destructor TResult.Destroy;
begin
  inherited;
end;

function TResult.AsJSON: string;
var
  JSONResult: TJSONObject;
begin
  JSONResult := TJSONObject.Create;
  try
    JSONResult.Add('success', TJSONBoolean.Create(Success));
    JSONResult.Add('retMessage', RetMessage);
    JSONResult.Add('retCode', TJSONIntegerNumber.Create(RetCode));
    Result := string(AnsiToUtf8(JSONResult.FormatJSON));
  finally
    JSONResult.Free;
  end;
end;

{ TPrinterException }
{
constructor TPrinterException.Create(AErrorCode: integer);
begin
  Create(AErrorCode, 'UNKNOWN ERROR');
end;

constructor TPrinterException.Create(AErrorCode: integer; aErrorMessage: string);
begin
  inherited Create(aErrorMessage);
  FErrorCode := AErrorCode;
end;

destructor TPrinterException.Destroy;
begin
  inherited;
end;

procedure TPrinterException.SetErrorCode(const AErrorCode: integer);
begin
  FErrorCode := AErrorCode;
end;

function TPrinterException.GetErrorCode: integer;
begin
  Result := FErrorCode;
end;
}

{ TDevice }
procedure TDevice.SetDeviceId(const ADeviceId: string);
begin
  FDeviceId := ADeviceId;
end;

procedure TDevice.SetDevicePath(const ADevicePath: string);
begin
  FDevicePath := ADevicePath;
end;

function TDevice.GetDeviceId: string;
begin
  Result := FDeviceId;
end;

function TDevice.GetDevicePath: string;
begin
  Result := FDevicePath;
end;


function TDevice.GetDeviceName: string;
begin
  Result := FDeviceName;
end;

procedure TDevice.SetDeviceName(const ADeviceName: string);
begin
  FDeviceName := ADeviceName;
end;

function TDevice.GetDisplayName: string;
begin
  if Length(FDeviceId) > 0 then
  begin
    with TStringList.Create do
      try
        Delimiter := ';';
        StrictDelimiter := True;
        NameValueSeparator := ':';
        DelimitedText := Trim(FDeviceId);
        if Length(Values['DES']) > 0 then
        begin
          Result := Trim(Values['DES']);
          Exit;
        end;
        if Length(Values['MDL']) > 0 then
        begin
          Result := Trim(Values['MDL']);
          Exit;
        end;
        if Length(Values['MODEL']) > 0 then
        begin
          Result := Trim(Values['MODEL']);
          Exit;
        end;
      finally
        Free;
      end;
  end;
  if Length(FDevicePath) > 0 then
  begin
    Result := Trim(FDevicePath);
    Exit;
  end;
  Result := EmptyStr;
end;

constructor TDevice.Create(const ADevicePath: string);
begin
  Create(ADevicePath, EmptyStr);
end;

constructor TDevice.Create(const ADevicePath, ADeviceId: string);
begin
  inherited Create;
  FDevicePath := ADevicePath;
  FDeviceId := ADeviceId;
end;

destructor TDevice.Destroy;
begin
  inherited;
end;

function TDevice.AsJSON: string;
begin
  with TJSONObject.Create do
    try
      Add('DeviceName', Trim(self.DeviceName));
      Add('DisplayName', Trim(self.DisplayName));
      Add('DeviceId', self.DeviceId);
      Add('DevicePath', self.DevicePath);
      Result := string(AnsiToUtf8(FormatJSON));
    finally
      Free;
    end;
end;

{ TLoadDevicesResult }

constructor TLoadDevicesResult.Create(ADeviceArray: IDeviceArray);
begin
  inherited Create;
  FDeviceArray := ADeviceArray;
end;

function TLoadDevicesResult.GetDeviceArray: IDeviceArray;
begin
  Result := FDeviceArray;
end;

procedure TLoadDevicesResult.SetDeviceArray(const ADeviceArray: IDeviceArray);
begin
  FDeviceArray := ADeviceArray;
end;

function TLoadDevicesResult.AsJSON: string;
var
  i: integer;
  JSONArray: TJSONArray;
  JSONResult, JSONObject: TJSONObject;
begin
  JSONResult := TJSONObject.Create;
  try
    JSONResult.Add('success', TJSONBoolean.Create(Success));
    JSONResult.Add('retMessage', RetMessage);
    JSONResult.Add('retCode', TJSONIntegerNumber.Create(RetCode));
    if Length(DeviceArray) > 0 then
    begin
      JSONArray := TJSONArray.Create;
      for i := 0 to Length(DeviceArray) - 1 do
      begin
        JSONObject := TJSONObject.Create;
        JSONObject.Add('DeviceName', Trim(DeviceArray[i].DeviceName));
        JSONObject.Add('DisplayName', Trim(DeviceArray[i].DisplayName));
        JSONObject.Add('DeviceId', DeviceArray[i].DeviceId);
        JSONObject.Add('DevicePath', DeviceArray[i].DevicePath);
        JSONArray.Add(JSONObject);
      end;
      JSONResult.Add('result', JSONArray);
    end;
    Result := string(AnsiToUtf8(JSONResult.FormatJSON));
  finally
    JSONResult.Free;
  end;
end;

end.
