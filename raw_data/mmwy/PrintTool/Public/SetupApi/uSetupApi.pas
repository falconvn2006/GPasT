unit uSetupApi;

{$mode objfpc}
{$H+}

interface


const
  DIF_PROPERTYCHANGE = $00000012;

const
  DICS_ENABLE = $00000001;
  DICS_DISABLE = $00000002;
  DICS_FLAG_GLOBAL = $00000001;  // make change in all hardware profiles

const
  DIGCF_DEFAULT = $00000001;  // only valid with DIGCF_DEVICEINTERFACE
  DIGCF_PRESENT = $00000002;
  DIGCF_ALLCLASSES = $00000004;
  DIGCF_PROFILE = $00000008;
  DIGCF_DEVICEINTERFACE = $00000010;
  DIGCF_INTERFACEDEVICE = DIGCF_DEVICEINTERFACE;


const
  SPDRP_DEVICEDESC = $00000000; // DeviceDesc (R/W)
  SPDRP_CLASS = $00000007; // Class (R--tied to ClassGUID)
  SPDRP_CLASSGUID = $00000008; // ClassGUID (R/W)
  SPDRP_FRIENDLYNAME = $0000000C; // FriendlyName (R/W)

type

  HDEVINFO = Pointer;

implementation

end.
