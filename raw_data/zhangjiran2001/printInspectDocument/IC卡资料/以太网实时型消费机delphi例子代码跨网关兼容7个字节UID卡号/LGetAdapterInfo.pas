unit LGetAdapterInfo;

interface

uses
   Windows, SysUtils, Classes;

const

MAX_HOSTNAME_LEN = 128; { from IPTYPES.H }
MAX_DOMAIN_NAME_LEN = 128;
MAX_SCOPE_ID_LEN = 256;
MAX_ADAPTER_NAME_LENGTH = 256;
MAX_ADAPTER_DESCRIPTION_LENGTH = 128;
MAX_ADAPTER_ADDRESS_LENGTH = 8;

type

TIPAddressString = array[0..4 * 4 - 1] of AnsiChar;
PIPAddrString = ^TIPAddrString;
TIPAddrString = record
  Next: PIPAddrString;
  IPAddress: TIPAddressString;
  IPMask: TIPAddressString;
  Context: Integer;
end;



PFixedInfo = ^TFixedInfo;

TFixedInfo = record { FIXED_INFO }

  HostName: array[0..MAX_HOSTNAME_LEN + 3] of AnsiChar;

  DomainName: array[0..MAX_DOMAIN_NAME_LEN + 3] of AnsiChar;

  CurrentDNSServer: PIPAddrString;

  DNSServerList: TIPAddrString;

  NodeType: Integer;

  ScopeId: array[0..MAX_SCOPE_ID_LEN + 3] of AnsiChar;

  EnableRouting: Integer;

  EnableProxy: Integer;

  EnableDNS: Integer;

end;

 

PIPAdapterInfo = ^TIPAdapterInfo;

TIPAdapterInfo = record { IP_ADAPTER_INFO }

Next: PIPAdapterInfo;

ComboIndex: Integer;

AdapterName: array[0..MAX_ADAPTER_NAME_LENGTH + 3] of AnsiChar;

Description: array[0..MAX_ADAPTER_DESCRIPTION_LENGTH + 3] of AnsiChar;

AddressLength: Integer;

Address: array[1..MAX_ADAPTER_ADDRESS_LENGTH] of Byte;

Index: Integer;

_Type: Integer;

DHCPEnabled: Integer;

CurrentIPAddress: PIPAddrString;

IPAddressList: TIPAddrString;

GatewayList: TIPAddrString;

DHCPServer: TIPAddrString;

HaveWINS: Bool;

PrimaryWINSServer: TIPAddrString;

SecondaryWINSServer: TIPAddrString;

LeaseObtained: Integer;

LeaseExpires: Integer;

end;

 

TAdapterInfo = class(TObject)

Index: Integer; //序号

AdapterName: string; //网卡名

IPAddress: string; //IP地址

Subnetmask: string; //子网掩码

Gateway: string; //网关

MacAddress: string; //MAC地址

DHCP: Boolean; //是否是自动分配

DHCPServer: string; //DHCP服务器地址

end;

 

function SendARP(ipaddr: ulong; temp: dword; ulmacaddr: pointer;

ulmacaddrleng: pointer): DWord; StdCall;

 

function GetAdapterInfo: TList;

 

var

AI, Work: PIPAdapterInfo;

Size: Integer;

Res: Integer;

I: Integer;

 

implementation

 

function SendARP; external 'Iphlpapi.dll' Name 'SendARP';

 

function GetAdaptersInfo(AI: PIPAdapterInfo; var BufLen: Integer): Integer;

stdcall; external 'iphlpapi.dll' Name 'GetAdaptersInfo';

 

function MACToStr(ByteArr: PByte; Len: Integer): string;

begin

  Result := '';

  while (Len > 0) do

  begin

    Result := Result + IntToHex(ByteArr^, 2) + '-';

    ByteArr := Pointer(Integer(ByteArr) + SizeOf(Byte));

    Dec(Len);

  end;

  SetLength(Result, Length(Result) - 1); { remove last dash }

end;

 

function GetAddrString(Addr: PIPAddrString): string;

begin
  Result := '';
  while (Addr <> nil) do
  begin
    Result := Result + 'A: ' + Addr^.IPAddress + ' M: ' + Addr^.IPMask + #13;
    Addr := Addr^.Next;
  end;
end;



function TimeTToDateTimeStr(TimeT: Integer): string;

const

UnixDateDelta = 25569; { days between12/31/1899and 1/1/1970 }

var

DT: TDateTime;

TZ: TTimeZoneInformation;

Res: DWord;



begin

if (TimeT = 0) then

  Result := ''

else
begin

  { Unix TIME_T is secs since1/1/1970}

  DT := UnixDateDelta + (TimeT / (24 * 60 * 60)); { in UTC }

  { calculate bias }

  Res := GetTimeZoneInformation(TZ);

  if (Res = TIME_ZONE_ID_INVALID) then

  RaiseLastWin32Error;

  if (Res = TIME_ZONE_ID_STANDARD) then

  begin
    DT := DT - ((TZ.Bias + TZ.StandardBias) / (24 * 60));
    Result := DateTimeToStr(DT) + ' ' + WideCharToString(TZ.StandardName);
  end

  else

  begin { daylight saving time }

    DT := DT - ((TZ.Bias + TZ.DaylightBias) / (24 * 60));

    Result := DateTimeToStr(DT) + ' ' + WideCharToString(TZ.DaylightName);

  end;

end;

end;

 

function GetAdapterInfo: TList;

var

AAdapterInfo: TAdapterInfo;

AAdapterInfos: TList;

begin

    Size := 5120;

    GetMem(AI, Size);

    Res := GetAdaptersInfo(AI, Size);

    if (Res <> ERROR_SUCCESS) then

    begin

      SetLastError(Res);

      RaiseLastWin32Error;

    end;

    Work := AI;

    I := 1;

    AAdapterInfos := TList.Create;

    repeat

        AAdapterInfo := TAdapterInfo.Create;

        AAdapterInfo.Index := I;

        AAdapterInfo.AdapterName := Work^.Description;

        AAdapterInfo.IPAddress := Copy(GetAddrString(@Work^.IPAddressList),

        Pos('A: ', GetAddrString(@Work^.IPAddressList)) + 3, Pos(' M: ',

        GetAddrString(@Work^.IPAddressList)) - Pos('A: ',

        GetAddrString(@Work^.IPAddressList)) - 3);

        AAdapterInfo.Subnetmask := Copy(GetAddrString(@Work^.IPAddressList),

        Pos(' M: ', GetAddrString(@Work^.IPAddressList)) + 4,

        length(GetAddrString(@Work^.IPAddressList)));

        AAdapterInfo.Gateway := Copy(GetAddrString(@Work^.GatewayList), Pos('A: ',

        GetAddrString(@Work^.GatewayList)) + 3, Pos(' M: ',

        GetAddrString(@Work^.GatewayList)) - Pos('A: ',

        GetAddrString(@Work^.GatewayList)) - 3);

        AAdapterInfo.MacAddress := MACToStr(@Work^.Address, Work^.AddressLength);

        AAdapterInfo.DHCP := Work^.DHCPEnabled > 0;

        AAdapterInfo.DHCPServer := Copy(GetAddrString(@Work^.DHCPServer), Pos('A: ',

        GetAddrString(@Work^.DHCPServer)) + 3, Pos(' M: ',

        GetAddrString(@Work^.DHCPServer)) - Pos('A: ',

        GetAddrString(@Work^.DHCPServer)) - 3);

        AAdapterInfos.Add(AAdapterInfo);

        Inc(I);

        Work := Work^.Next;

      until (Work = nil);

    Result :=AAdapterInfos;

    FreeMem(AI);
end;



end.
