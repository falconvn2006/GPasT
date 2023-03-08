unit IMAPI2_TLB;
{$WARNINGS OFF}
// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// $Rev: 52393 $
// File generated on 13/06/2017 18:05:32 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Windows\system32\imapi2.dll (1)
// LIBID: {2735412F-7F64-5B0F-8F00-5D77AFBE261E}
// LCID: 0
// Helpfile: 
// HelpString: Microsoft IMAPI2 Base Functionality
// DepndLst: 
//   (1) v2.0 stdole, (C:\Windows\SysWOW64\stdole2.tlb)
// SYS_KIND: SYS_WIN32
// Errors:
//   Hint: Parameter 'object' of DDiscMaster2Events.NotifyDeviceAdded changed to 'object_'
//   Hint: Parameter 'object' of DDiscMaster2Events.NotifyDeviceRemoved changed to 'object_'
//   Hint: Parameter 'object' of DWriteEngine2Events.Update changed to 'object_'
//   Hint: Parameter 'object' of DDiscFormat2EraseEvents.Update changed to 'object_'
//   Hint: Parameter 'object' of DDiscFormat2DataEvents.Update changed to 'object_'
//   Hint: Parameter 'object' of DDiscFormat2TrackAtOnceEvents.Update changed to 'object_'
//   Hint: Parameter 'object' of DDiscFormat2RawCDEvents.Update changed to 'object_'
//   Hint: Symbol 'type' renamed to 'type_'
//   Error creating palette bitmap of (TMsftDiscMaster2) : Server C:\Windows\SysWOW64\imapi2.dll contains no icons
//   Error creating palette bitmap of (TMsftDiscRecorder2) : Server C:\Windows\SysWOW64\imapi2.dll contains no icons
//   Error creating palette bitmap of (TMsftWriteEngine2) : Server C:\Windows\SysWOW64\imapi2.dll contains no icons
//   Error creating palette bitmap of (TMsftDiscFormat2Erase) : Server C:\Windows\SysWOW64\imapi2.dll contains no icons
//   Error creating palette bitmap of (TMsftDiscFormat2Data) : Server C:\Windows\SysWOW64\imapi2.dll contains no icons
//   Error creating palette bitmap of (TMsftDiscFormat2TrackAtOnce) : Server C:\Windows\SysWOW64\imapi2.dll contains no icons
//   Error creating palette bitmap of (TMsftDiscFormat2RawCD) : Server C:\Windows\SysWOW64\imapi2.dll contains no icons
//   Error creating palette bitmap of (TMsftStreamZero) : Server C:\Windows\SysWOW64\imapi2.dll contains no icons
//   Error creating palette bitmap of (TMsftStreamPrng001) : Server C:\Windows\SysWOW64\imapi2.dll contains no icons
//   Error creating palette bitmap of (TMsftStreamConcatenate) : Server C:\Windows\SysWOW64\imapi2.dll contains no icons
//   Error creating palette bitmap of (TMsftStreamInterleave) : Server C:\Windows\SysWOW64\imapi2.dll contains no icons
//   Error creating palette bitmap of (TMsftWriteSpeedDescriptor) : Server C:\Windows\SysWOW64\imapi2.dll contains no icons
//   Error creating palette bitmap of (TMsftMultisessionSequential) : Server C:\Windows\SysWOW64\imapi2.dll contains no icons
//   Error creating palette bitmap of (TMsftMultisessionRandomWrite) : Server C:\Windows\SysWOW64\imapi2.dll contains no icons
//   Error creating palette bitmap of (TMsftRawCDImageCreator) : Server C:\Windows\SysWOW64\imapi2.dll contains no icons
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
{$ALIGN 4}

interface

uses Winapi.Windows, System.Classes, System.Variants, System.Win.StdVCL, Vcl.Graphics, Vcl.OleServer, Winapi.ActiveX;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  IMAPI2MajorVersion = 1;
  IMAPI2MinorVersion = 0;

  IMAPI_SECTORS_PER_SECOND_AT_1X_CD     = 75;
  IMAPI_SECTORS_PER_SECOND_AT_1X_DVD    = 680;
  IMAPI_SECTORS_PER_SECOND_AT_1X_BD     = 2195;
  IMAPI_SECTORS_PER_SECOND_AT_1X_HD_DVD = 4568;

  LIBID_IMAPI2: TGUID = '{2735412F-7F64-5B0F-8F00-5D77AFBE261E}';

  IID_IWriteEngine2EventArgs: TGUID = '{27354136-7F64-5B0F-8F00-5D77AFBE261E}';
  IID_IDiscFormat2DataEventArgs: TGUID = '{2735413D-7F64-5B0F-8F00-5D77AFBE261E}';
  IID_IDiscFormat2TrackAtOnceEventArgs: TGUID = '{27354140-7F64-5B0F-8F00-5D77AFBE261E}';
  IID_IDiscFormat2RawCDEventArgs: TGUID = '{27354143-7F64-5B0F-8F00-5D77AFBE261E}';
  IID_IWriteSpeedDescriptor: TGUID = '{27354144-7F64-5B0F-8F00-5D77AFBE261E}';
  IID_DDiscMaster2Events: TGUID = '{27354131-7F64-5B0F-8F00-5D77AFBE261E}';
  IID_DWriteEngine2Events: TGUID = '{27354137-7F64-5B0F-8F00-5D77AFBE261E}';
  IID_DDiscFormat2EraseEvents: TGUID = '{2735413A-7F64-5B0F-8F00-5D77AFBE261E}';
  IID_DDiscFormat2DataEvents: TGUID = '{2735413C-7F64-5B0F-8F00-5D77AFBE261E}';
  IID_DDiscFormat2TrackAtOnceEvents: TGUID = '{2735413F-7F64-5B0F-8F00-5D77AFBE261E}';
  IID_DDiscFormat2RawCDEvents: TGUID = '{27354142-7F64-5B0F-8F00-5D77AFBE261E}';
  IID_IRawCDImageCreator: TGUID = '{25983550-9D65-49CE-B335-40630D901227}';
  IID_ISequentialStream: TGUID = '{0C733A30-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IStream: TGUID = '{0000000C-0000-0000-C000-000000000046}';
  IID_IRawCDImageTrackInfo: TGUID = '{25983551-9D65-49CE-B335-40630D901227}';
  IID_IBurnVerification: TGUID = '{D2FFD834-958B-426D-8470-2A13879C6A91}';
  IID_IBlockRange: TGUID = '{B507CA25-2204-11DD-966A-001AA01BBC58}';
  IID_IBlockRangeList: TGUID = '{B507CA26-2204-11DD-966A-001AA01BBC58}';
  IID_IDiscMaster2: TGUID = '{27354130-7F64-5B0F-8F00-5D77AFBE261E}';
  IID_IConnectionPointContainer: TGUID = '{B196B284-BAB4-101A-B69C-00AA00341D07}';
  CLASS_MsftDiscMaster2: TGUID = '{2735412E-7F64-5B0F-8F00-5D77AFBE261E}';
  IID_IEnumConnectionPoints: TGUID = '{B196B285-BAB4-101A-B69C-00AA00341D07}';
  IID_IConnectionPoint: TGUID = '{B196B286-BAB4-101A-B69C-00AA00341D07}';
  IID_IEnumConnections: TGUID = '{B196B287-BAB4-101A-B69C-00AA00341D07}';
  IID_IDiscRecorder2: TGUID = '{27354133-7F64-5B0F-8F00-5D77AFBE261E}';
  IID_IDiscRecorder2Ex: TGUID = '{27354132-7F64-5B0F-8F00-5D77AFBE261E}';
  CLASS_MsftDiscRecorder2: TGUID = '{2735412D-7F64-5B0F-8F00-5D77AFBE261E}';
  IID_IWriteEngine2: TGUID = '{27354135-7F64-5B0F-8F00-5D77AFBE261E}';
  CLASS_MsftWriteEngine2: TGUID = '{2735412C-7F64-5B0F-8F00-5D77AFBE261E}';
  IID_IDiscFormat2: TGUID = '{27354152-8F64-5B0F-8F00-5D77AFBE261E}';
  IID_IDiscFormat2Erase: TGUID = '{27354156-8F64-5B0F-8F00-5D77AFBE261E}';
  CLASS_MsftDiscFormat2Erase: TGUID = '{2735412B-7F64-5B0F-8F00-5D77AFBE261E}';
  IID_IDiscFormat2Data: TGUID = '{27354153-9F64-5B0F-8F00-5D77AFBE261E}';
  CLASS_MsftDiscFormat2Data: TGUID = '{2735412A-7F64-5B0F-8F00-5D77AFBE261E}';
  IID_IDiscFormat2TrackAtOnce: TGUID = '{27354154-8F64-5B0F-8F00-5D77AFBE261E}';
  CLASS_MsftDiscFormat2TrackAtOnce: TGUID = '{27354129-7F64-5B0F-8F00-5D77AFBE261E}';
  IID_IDiscFormat2RawCD: TGUID = '{27354155-8F64-5B0F-8F00-5D77AFBE261E}';
  CLASS_MsftDiscFormat2RawCD: TGUID = '{27354128-7F64-5B0F-8F00-5D77AFBE261E}';
  CLASS_MsftStreamZero: TGUID = '{27354127-7F64-5B0F-8F00-5D77AFBE261E}';
  IID_IStreamPseudoRandomBased: TGUID = '{27354145-7F64-5B0F-8F00-5D77AFBE261E}';
  CLASS_MsftStreamPrng001: TGUID = '{27354126-7F64-5B0F-8F00-5D77AFBE261E}';
  IID_IStreamConcatenate: TGUID = '{27354146-7F64-5B0F-8F00-5D77AFBE261E}';
  CLASS_MsftStreamConcatenate: TGUID = '{27354125-7F64-5B0F-8F00-5D77AFBE261E}';
  IID_IStreamInterleave: TGUID = '{27354147-7F64-5B0F-8F00-5D77AFBE261E}';
  CLASS_MsftStreamInterleave: TGUID = '{27354124-7F64-5B0F-8F00-5D77AFBE261E}';
  CLASS_MsftWriteSpeedDescriptor: TGUID = '{27354123-7F64-5B0F-8F00-5D77AFBE261E}';
  IID_IMultisession: TGUID = '{27354150-7F64-5B0F-8F00-5D77AFBE261E}';
  IID_IMultisessionSequential: TGUID = '{27354151-7F64-5B0F-8F00-5D77AFBE261E}';
  IID_IMultisessionSequential2: TGUID = '{B507CA22-2204-11DD-966A-001AA01BBC58}';
  CLASS_MsftMultisessionSequential: TGUID = '{27354122-7F64-5B0F-8F00-5D77AFBE261E}';
  IID_IMultisessionRandomWrite: TGUID = '{B507CA23-2204-11DD-966A-001AA01BBC58}';
  CLASS_MsftMultisessionRandomWrite: TGUID = '{B507CA24-2204-11DD-966A-001AA01BBC58}';
  CLASS_MsftRawCDImageCreator: TGUID = '{25983561-9D65-49CE-B335-40630D901227}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum _IMAPI_FORMAT2_DATA_WRITE_ACTION
type
  _IMAPI_FORMAT2_DATA_WRITE_ACTION = TOleEnum;
const
  IMAPI_FORMAT2_DATA_WRITE_ACTION_VALIDATING_MEDIA = $00000000;
  IMAPI_FORMAT2_DATA_WRITE_ACTION_FORMATTING_MEDIA = $00000001;
  IMAPI_FORMAT2_DATA_WRITE_ACTION_INITIALIZING_HARDWARE = $00000002;
  IMAPI_FORMAT2_DATA_WRITE_ACTION_CALIBRATING_POWER = $00000003;
  IMAPI_FORMAT2_DATA_WRITE_ACTION_WRITING_DATA = $00000004;
  IMAPI_FORMAT2_DATA_WRITE_ACTION_FINALIZATION = $00000005;
  IMAPI_FORMAT2_DATA_WRITE_ACTION_COMPLETED = $00000006;
  IMAPI_FORMAT2_DATA_WRITE_ACTION_VERIFYING = $00000007;

// Constants for enum _IMAPI_FORMAT2_TAO_WRITE_ACTION
type
  _IMAPI_FORMAT2_TAO_WRITE_ACTION = TOleEnum;
const
  IMAPI_FORMAT2_TAO_WRITE_ACTION_UNKNOWN = $00000000;
  IMAPI_FORMAT2_TAO_WRITE_ACTION_PREPARING = $00000001;
  IMAPI_FORMAT2_TAO_WRITE_ACTION_WRITING = $00000002;
  IMAPI_FORMAT2_TAO_WRITE_ACTION_FINISHING = $00000003;
  IMAPI_FORMAT2_TAO_WRITE_ACTION_VERIFYING = $00000004;

// Constants for enum _IMAPI_FORMAT2_RAW_CD_WRITE_ACTION
type
  _IMAPI_FORMAT2_RAW_CD_WRITE_ACTION = TOleEnum;
const
  IMAPI_FORMAT2_RAW_CD_WRITE_ACTION_UNKNOWN = $00000000;
  IMAPI_FORMAT2_RAW_CD_WRITE_ACTION_PREPARING = $00000001;
  IMAPI_FORMAT2_RAW_CD_WRITE_ACTION_WRITING = $00000002;
  IMAPI_FORMAT2_RAW_CD_WRITE_ACTION_FINISHING = $00000003;

// Constants for enum _IMAPI_MEDIA_PHYSICAL_TYPE
type
  _IMAPI_MEDIA_PHYSICAL_TYPE = TOleEnum;
const
  IMAPI_MEDIA_TYPE_UNKNOWN = $00000000;
  IMAPI_MEDIA_TYPE_CDROM = $00000001;
  IMAPI_MEDIA_TYPE_CDR = $00000002;
  IMAPI_MEDIA_TYPE_CDRW = $00000003;
  IMAPI_MEDIA_TYPE_DVDROM = $00000004;
  IMAPI_MEDIA_TYPE_DVDRAM = $00000005;
  IMAPI_MEDIA_TYPE_DVDPLUSR = $00000006;
  IMAPI_MEDIA_TYPE_DVDPLUSRW = $00000007;
  IMAPI_MEDIA_TYPE_DVDPLUSR_DUALLAYER = $00000008;
  IMAPI_MEDIA_TYPE_DVDDASHR = $00000009;
  IMAPI_MEDIA_TYPE_DVDDASHRW = $0000000A;
  IMAPI_MEDIA_TYPE_DVDDASHR_DUALLAYER = $0000000B;
  IMAPI_MEDIA_TYPE_DISK = $0000000C;
  IMAPI_MEDIA_TYPE_DVDPLUSRW_DUALLAYER = $0000000D;
  IMAPI_MEDIA_TYPE_HDDVDROM = $0000000E;
  IMAPI_MEDIA_TYPE_HDDVDR = $0000000F;
  IMAPI_MEDIA_TYPE_HDDVDRAM = $00000010;
  IMAPI_MEDIA_TYPE_BDROM = $00000011;
  IMAPI_MEDIA_TYPE_BDR = $00000012;
  IMAPI_MEDIA_TYPE_BDRE = $00000013;
  IMAPI_MEDIA_TYPE_MAX = $00000013;

// Constants for enum _IMAPI_CD_SECTOR_TYPE
type
  _IMAPI_CD_SECTOR_TYPE = TOleEnum;
const
  IMAPI_CD_SECTOR_AUDIO = $00000000;
  IMAPI_CD_SECTOR_MODE_ZERO = $00000001;
  IMAPI_CD_SECTOR_MODE1 = $00000002;
  IMAPI_CD_SECTOR_MODE2FORM0 = $00000003;
  IMAPI_CD_SECTOR_MODE2FORM1 = $00000004;
  IMAPI_CD_SECTOR_MODE2FORM2 = $00000005;
  IMAPI_CD_SECTOR_MODE1RAW = $00000006;
  IMAPI_CD_SECTOR_MODE2FORM0RAW = $00000007;
  IMAPI_CD_SECTOR_MODE2FORM1RAW = $00000008;
  IMAPI_CD_SECTOR_MODE2FORM2RAW = $00000009;

// Constants for enum _IMAPI_FORMAT2_RAW_CD_DATA_SECTOR_TYPE
type
  _IMAPI_FORMAT2_RAW_CD_DATA_SECTOR_TYPE = TOleEnum;
const
  IMAPI_FORMAT2_RAW_CD_SUBCODE_PQ_ONLY = $00000001;
  IMAPI_FORMAT2_RAW_CD_SUBCODE_IS_COOKED = $00000002;
  IMAPI_FORMAT2_RAW_CD_SUBCODE_IS_RAW = $00000003;

// Constants for enum _IMAPI_CD_TRACK_DIGITAL_COPY_SETTING
type
  _IMAPI_CD_TRACK_DIGITAL_COPY_SETTING = TOleEnum;
const
  IMAPI_CD_TRACK_DIGITAL_COPY_PERMITTED = $00000000;
  IMAPI_CD_TRACK_DIGITAL_COPY_PROHIBITED = $00000001;
  IMAPI_CD_TRACK_DIGITAL_COPY_SCMS = $00000002;

// Constants for enum _IMAPI_BURN_VERIFICATION_LEVEL
type
  _IMAPI_BURN_VERIFICATION_LEVEL = TOleEnum;
const
  IMAPI_BURN_VERIFICATION_NONE = $00000000;
  IMAPI_BURN_VERIFICATION_QUICK = $00000001;
  IMAPI_BURN_VERIFICATION_FULL = $00000002;

// Constants for enum _IMAPI_READ_TRACK_ADDRESS_TYPE
type
  _IMAPI_READ_TRACK_ADDRESS_TYPE = TOleEnum;
const
  IMAPI_READ_TRACK_ADDRESS_TYPE_LBA = $00000000;
  IMAPI_READ_TRACK_ADDRESS_TYPE_TRACK = $00000001;
  IMAPI_READ_TRACK_ADDRESS_TYPE_SESSION = $00000002;

// Constants for enum _IMAPI_FEATURE_PAGE_TYPE
type
  _IMAPI_FEATURE_PAGE_TYPE = TOleEnum;
const
  IMAPI_FEATURE_PAGE_TYPE_PROFILE_LIST = $00000000;
  IMAPI_FEATURE_PAGE_TYPE_CORE = $00000001;
  IMAPI_FEATURE_PAGE_TYPE_MORPHING = $00000002;
  IMAPI_FEATURE_PAGE_TYPE_REMOVABLE_MEDIUM = $00000003;
  IMAPI_FEATURE_PAGE_TYPE_WRITE_PROTECT = $00000004;
  IMAPI_FEATURE_PAGE_TYPE_RANDOMLY_READABLE = $00000010;
  IMAPI_FEATURE_PAGE_TYPE_CD_MULTIREAD = $0000001D;
  IMAPI_FEATURE_PAGE_TYPE_CD_READ = $0000001E;
  IMAPI_FEATURE_PAGE_TYPE_DVD_READ = $0000001F;
  IMAPI_FEATURE_PAGE_TYPE_RANDOMLY_WRITABLE = $00000020;
  IMAPI_FEATURE_PAGE_TYPE_INCREMENTAL_STREAMING_WRITABLE = $00000021;
  IMAPI_FEATURE_PAGE_TYPE_SECTOR_ERASABLE = $00000022;
  IMAPI_FEATURE_PAGE_TYPE_FORMATTABLE = $00000023;
  IMAPI_FEATURE_PAGE_TYPE_HARDWARE_DEFECT_MANAGEMENT = $00000024;
  IMAPI_FEATURE_PAGE_TYPE_WRITE_ONCE = $00000025;
  IMAPI_FEATURE_PAGE_TYPE_RESTRICTED_OVERWRITE = $00000026;
  IMAPI_FEATURE_PAGE_TYPE_CDRW_CAV_WRITE = $00000027;
  IMAPI_FEATURE_PAGE_TYPE_MRW = $00000028;
  IMAPI_FEATURE_PAGE_TYPE_ENHANCED_DEFECT_REPORTING = $00000029;
  IMAPI_FEATURE_PAGE_TYPE_DVD_PLUS_RW = $0000002A;
  IMAPI_FEATURE_PAGE_TYPE_DVD_PLUS_R = $0000002B;
  IMAPI_FEATURE_PAGE_TYPE_RIGID_RESTRICTED_OVERWRITE = $0000002C;
  IMAPI_FEATURE_PAGE_TYPE_CD_TRACK_AT_ONCE = $0000002D;
  IMAPI_FEATURE_PAGE_TYPE_CD_MASTERING = $0000002E;
  IMAPI_FEATURE_PAGE_TYPE_DVD_DASH_WRITE = $0000002F;
  IMAPI_FEATURE_PAGE_TYPE_DOUBLE_DENSITY_CD_READ = $00000030;
  IMAPI_FEATURE_PAGE_TYPE_DOUBLE_DENSITY_CD_R_WRITE = $00000031;
  IMAPI_FEATURE_PAGE_TYPE_DOUBLE_DENSITY_CD_RW_WRITE = $00000032;
  IMAPI_FEATURE_PAGE_TYPE_LAYER_JUMP_RECORDING = $00000033;
  IMAPI_FEATURE_PAGE_TYPE_CD_RW_MEDIA_WRITE_SUPPORT = $00000037;
  IMAPI_FEATURE_PAGE_TYPE_BD_PSEUDO_OVERWRITE = $00000038;
  IMAPI_FEATURE_PAGE_TYPE_DVD_PLUS_R_DUAL_LAYER = $0000003B;
  IMAPI_FEATURE_PAGE_TYPE_BD_READ = $00000040;
  IMAPI_FEATURE_PAGE_TYPE_BD_WRITE = $00000041;
  IMAPI_FEATURE_PAGE_TYPE_HD_DVD_READ = $00000050;
  IMAPI_FEATURE_PAGE_TYPE_HD_DVD_WRITE = $00000051;
  IMAPI_FEATURE_PAGE_TYPE_POWER_MANAGEMENT = $00000100;
  IMAPI_FEATURE_PAGE_TYPE_SMART = $00000101;
  IMAPI_FEATURE_PAGE_TYPE_EMBEDDED_CHANGER = $00000102;
  IMAPI_FEATURE_PAGE_TYPE_CD_ANALOG_PLAY = $00000103;
  IMAPI_FEATURE_PAGE_TYPE_MICROCODE_UPDATE = $00000104;
  IMAPI_FEATURE_PAGE_TYPE_TIMEOUT = $00000105;
  IMAPI_FEATURE_PAGE_TYPE_DVD_CSS = $00000106;
  IMAPI_FEATURE_PAGE_TYPE_REAL_TIME_STREAMING = $00000107;
  IMAPI_FEATURE_PAGE_TYPE_LOGICAL_UNIT_SERIAL_NUMBER = $00000108;
  IMAPI_FEATURE_PAGE_TYPE_MEDIA_SERIAL_NUMBER = $00000109;
  IMAPI_FEATURE_PAGE_TYPE_DISC_CONTROL_BLOCKS = $0000010A;
  IMAPI_FEATURE_PAGE_TYPE_DVD_CPRM = $0000010B;
  IMAPI_FEATURE_PAGE_TYPE_FIRMWARE_INFORMATION = $0000010C;
  IMAPI_FEATURE_PAGE_TYPE_AACS = $0000010D;
  IMAPI_FEATURE_PAGE_TYPE_VCPS = $00000110;

// Constants for enum _IMAPI_MODE_PAGE_TYPE
type
  _IMAPI_MODE_PAGE_TYPE = TOleEnum;
const
  IMAPI_MODE_PAGE_TYPE_READ_WRITE_ERROR_RECOVERY = $00000001;
  IMAPI_MODE_PAGE_TYPE_MRW = $00000003;
  IMAPI_MODE_PAGE_TYPE_WRITE_PARAMETERS = $00000005;
  IMAPI_MODE_PAGE_TYPE_CACHING = $00000008;
  IMAPI_MODE_PAGE_TYPE_INFORMATIONAL_EXCEPTIONS = $0000001C;
  IMAPI_MODE_PAGE_TYPE_TIMEOUT_AND_PROTECT = $0000001D;
  IMAPI_MODE_PAGE_TYPE_POWER_CONDITION = $0000001A;
  IMAPI_MODE_PAGE_TYPE_LEGACY_CAPABILITIES = $0000002A;

// Constants for enum _IMAPI_MODE_PAGE_REQUEST_TYPE
type
  _IMAPI_MODE_PAGE_REQUEST_TYPE = TOleEnum;
const
  IMAPI_MODE_PAGE_REQUEST_TYPE_CURRENT_VALUES = $00000000;
  IMAPI_MODE_PAGE_REQUEST_TYPE_CHANGEABLE_VALUES = $00000001;
  IMAPI_MODE_PAGE_REQUEST_TYPE_DEFAULT_VALUES = $00000002;
  IMAPI_MODE_PAGE_REQUEST_TYPE_SAVED_VALUES = $00000003;

// Constants for enum _IMAPI_PROFILE_TYPE
type
  _IMAPI_PROFILE_TYPE = TOleEnum;
const
  IMAPI_PROFILE_TYPE_INVALID = $00000000;
  IMAPI_PROFILE_TYPE_NON_REMOVABLE_DISK = $00000001;
  IMAPI_PROFILE_TYPE_REMOVABLE_DISK = $00000002;
  IMAPI_PROFILE_TYPE_MO_ERASABLE = $00000003;
  IMAPI_PROFILE_TYPE_MO_WRITE_ONCE = $00000004;
  IMAPI_PROFILE_TYPE_AS_MO = $00000005;
  IMAPI_PROFILE_TYPE_CDROM = $00000008;
  IMAPI_PROFILE_TYPE_CD_RECORDABLE = $00000009;
  IMAPI_PROFILE_TYPE_CD_REWRITABLE = $0000000A;
  IMAPI_PROFILE_TYPE_DVDROM = $00000010;
  IMAPI_PROFILE_TYPE_DVD_DASH_RECORDABLE = $00000011;
  IMAPI_PROFILE_TYPE_DVD_RAM = $00000012;
  IMAPI_PROFILE_TYPE_DVD_DASH_REWRITABLE = $00000013;
  IMAPI_PROFILE_TYPE_DVD_DASH_RW_SEQUENTIAL = $00000014;
  IMAPI_PROFILE_TYPE_DVD_DASH_R_DUAL_SEQUENTIAL = $00000015;
  IMAPI_PROFILE_TYPE_DVD_DASH_R_DUAL_LAYER_JUMP = $00000016;
  IMAPI_PROFILE_TYPE_DVD_PLUS_RW = $0000001A;
  IMAPI_PROFILE_TYPE_DVD_PLUS_R = $0000001B;
  IMAPI_PROFILE_TYPE_DDCDROM = $00000020;
  IMAPI_PROFILE_TYPE_DDCD_RECORDABLE = $00000021;
  IMAPI_PROFILE_TYPE_DDCD_REWRITABLE = $00000022;
  IMAPI_PROFILE_TYPE_DVD_PLUS_RW_DUAL = $0000002A;
  IMAPI_PROFILE_TYPE_DVD_PLUS_R_DUAL = $0000002B;
  IMAPI_PROFILE_TYPE_BD_ROM = $00000040;
  IMAPI_PROFILE_TYPE_BD_R_SEQUENTIAL = $00000041;
  IMAPI_PROFILE_TYPE_BD_R_RANDOM_RECORDING = $00000042;
  IMAPI_PROFILE_TYPE_BD_REWRITABLE = $00000043;
  IMAPI_PROFILE_TYPE_HD_DVD_ROM = $00000050;
  IMAPI_PROFILE_TYPE_HD_DVD_RECORDABLE = $00000051;
  IMAPI_PROFILE_TYPE_HD_DVD_RAM = $00000052;
  IMAPI_PROFILE_TYPE_NON_STANDARD = $0000FFFF;

// Constants for enum _IMAPI_FORMAT2_DATA_MEDIA_STATE
type
  _IMAPI_FORMAT2_DATA_MEDIA_STATE = TOleEnum;
const
  IMAPI_FORMAT2_DATA_MEDIA_STATE_UNKNOWN = $00000000;
  IMAPI_FORMAT2_DATA_MEDIA_STATE_INFORMATIONAL_MASK = $0000000F;
  IMAPI_FORMAT2_DATA_MEDIA_STATE_UNSUPPORTED_MASK = $0000FC00;
  IMAPI_FORMAT2_DATA_MEDIA_STATE_OVERWRITE_ONLY = $00000001;
  IMAPI_FORMAT2_DATA_MEDIA_STATE_RANDOMLY_WRITABLE = $00000001;
  IMAPI_FORMAT2_DATA_MEDIA_STATE_BLANK = $00000002;
  IMAPI_FORMAT2_DATA_MEDIA_STATE_APPENDABLE = $00000004;
  IMAPI_FORMAT2_DATA_MEDIA_STATE_FINAL_SESSION = $00000008;
  IMAPI_FORMAT2_DATA_MEDIA_STATE_DAMAGED = $00000400;
  IMAPI_FORMAT2_DATA_MEDIA_STATE_ERASE_REQUIRED = $00000800;
  IMAPI_FORMAT2_DATA_MEDIA_STATE_NON_EMPTY_SESSION = $00001000;
  IMAPI_FORMAT2_DATA_MEDIA_STATE_WRITE_PROTECTED = $00002000;
  IMAPI_FORMAT2_DATA_MEDIA_STATE_FINALIZED = $00004000;
  IMAPI_FORMAT2_DATA_MEDIA_STATE_UNSUPPORTED_MEDIA = $00008000;

// Constants for enum _IMAPI_MEDIA_WRITE_PROTECT_STATE
type
  _IMAPI_MEDIA_WRITE_PROTECT_STATE = TOleEnum;
const
  IMAPI_WRITEPROTECTED_UNTIL_POWERDOWN = $00000001;
  IMAPI_WRITEPROTECTED_BY_CARTRIDGE = $00000002;
  IMAPI_WRITEPROTECTED_BY_MEDIA_SPECIFIC_REASON = $00000004;
  IMAPI_WRITEPROTECTED_BY_SOFTWARE_WRITE_PROTECT = $00000008;
  IMAPI_WRITEPROTECTED_BY_DISC_CONTROL_BLOCK = $00000010;
  IMAPI_WRITEPROTECTED_READ_ONLY_MEDIA = $00004000;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IWriteEngine2EventArgs = interface;
  IWriteEngine2EventArgsDisp = dispinterface;
  IDiscFormat2DataEventArgs = interface;
  IDiscFormat2DataEventArgsDisp = dispinterface;
  IDiscFormat2TrackAtOnceEventArgs = interface;
  IDiscFormat2TrackAtOnceEventArgsDisp = dispinterface;
  IDiscFormat2RawCDEventArgs = interface;
  IDiscFormat2RawCDEventArgsDisp = dispinterface;
  IWriteSpeedDescriptor = interface;
  IWriteSpeedDescriptorDisp = dispinterface;
  DDiscMaster2Events = interface;
  DWriteEngine2Events = interface;
  DDiscFormat2EraseEvents = interface;
  DDiscFormat2DataEvents = interface;
  DDiscFormat2TrackAtOnceEvents = interface;
  DDiscFormat2RawCDEvents = interface;
  IRawCDImageCreator = interface;
  IRawCDImageCreatorDisp = dispinterface;
  ISequentialStream = interface;
  IStream = interface;
  IRawCDImageTrackInfo = interface;
  IRawCDImageTrackInfoDisp = dispinterface;
  IBurnVerification = interface;
  IBlockRange = interface;
  IBlockRangeDisp = dispinterface;
  IBlockRangeList = interface;
  IBlockRangeListDisp = dispinterface;
  IDiscMaster2 = interface;
  IDiscMaster2Disp = dispinterface;
  IConnectionPointContainer = interface;
  IEnumConnectionPoints = interface;
  IConnectionPoint = interface;
  IEnumConnections = interface;
  IDiscRecorder2 = interface;
  IDiscRecorder2Disp = dispinterface;
  IDiscRecorder2Ex = interface;
  IWriteEngine2 = interface;
  IWriteEngine2Disp = dispinterface;
  IDiscFormat2 = interface;
  IDiscFormat2Disp = dispinterface;
  IDiscFormat2Erase = interface;
  IDiscFormat2EraseDisp = dispinterface;
  IDiscFormat2Data = interface;
  IDiscFormat2DataDisp = dispinterface;
  IDiscFormat2TrackAtOnce = interface;
  IDiscFormat2TrackAtOnceDisp = dispinterface;
  IDiscFormat2RawCD = interface;
  IDiscFormat2RawCDDisp = dispinterface;
  IStreamPseudoRandomBased = interface;
  IStreamConcatenate = interface;
  IStreamInterleave = interface;
  IMultisession = interface;
  IMultisessionDisp = dispinterface;
  IMultisessionSequential = interface;
  IMultisessionSequentialDisp = dispinterface;
  IMultisessionSequential2 = interface;
  IMultisessionSequential2Disp = dispinterface;
  IMultisessionRandomWrite = interface;
  IMultisessionRandomWriteDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  MsftDiscMaster2 = IDiscMaster2;
  MsftDiscRecorder2 = IDiscRecorder2;
  MsftWriteEngine2 = IWriteEngine2;
  MsftDiscFormat2Erase = IDiscFormat2Erase;
  MsftDiscFormat2Data = IDiscFormat2Data;
  MsftDiscFormat2TrackAtOnce = IDiscFormat2TrackAtOnce;
  MsftDiscFormat2RawCD = IDiscFormat2RawCD;
  MsftStreamZero = IStream;
  MsftStreamPrng001 = IStreamPseudoRandomBased;
  MsftStreamConcatenate = IStreamConcatenate;
  MsftStreamInterleave = IStreamInterleave;
  MsftWriteSpeedDescriptor = IWriteSpeedDescriptor;
  MsftMultisessionSequential = IMultisessionSequential2;
  MsftMultisessionRandomWrite = IMultisessionRandomWrite;
  MsftRawCDImageCreator = IRawCDImageCreator;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//
  PByte1 = ^Byte; {*}
  PUserType1 = ^TGUID; {*}
  PUserType2 = ^IMAPI_FEATURE_PAGE_TYPE; {*}
  PUserType3 = ^IMAPI_PROFILE_TYPE; {*}
  PUserType4 = ^IMAPI_MODE_PAGE_TYPE; {*}
  PUINT1 = ^LongWord; {*}
  PPUserType1 = ^IStream; {*}

  IMAPI_FORMAT2_DATA_WRITE_ACTION = _IMAPI_FORMAT2_DATA_WRITE_ACTION; 
  IMAPI_FORMAT2_TAO_WRITE_ACTION = _IMAPI_FORMAT2_TAO_WRITE_ACTION; 
  IMAPI_FORMAT2_RAW_CD_WRITE_ACTION = _IMAPI_FORMAT2_RAW_CD_WRITE_ACTION; 
  IMAPI_MEDIA_PHYSICAL_TYPE = _IMAPI_MEDIA_PHYSICAL_TYPE; 

{$ALIGN 8}
  _LARGE_INTEGER = record
    QuadPart: Int64;
  end;

  _ULARGE_INTEGER = record
    QuadPart: Largeuint;
  end;

{$ALIGN 4}
  _FILETIME = record
    dwLowDateTime: LongWord;
    dwHighDateTime: LongWord;
  end;

{$ALIGN 8}
  tagSTATSTG = record
    pwcsName: PWideChar;
    type_: LongWord;
    cbSize: _ULARGE_INTEGER;
    mtime: _FILETIME;
    ctime: _FILETIME;
    atime: _FILETIME;
    grfMode: LongWord;
    grfLocksSupported: LongWord;
    clsid: TGUID;
    grfStateBits: LongWord;
    reserved: LongWord;
  end;

  IMAPI_CD_SECTOR_TYPE = _IMAPI_CD_SECTOR_TYPE; 
  IMAPI_FORMAT2_RAW_CD_DATA_SECTOR_TYPE = _IMAPI_FORMAT2_RAW_CD_DATA_SECTOR_TYPE; 
  IMAPI_CD_TRACK_DIGITAL_COPY_SETTING = _IMAPI_CD_TRACK_DIGITAL_COPY_SETTING; 
  IMAPI_BURN_VERIFICATION_LEVEL = _IMAPI_BURN_VERIFICATION_LEVEL; 

{$ALIGN 4}
  tagCONNECTDATA = record
    pUnk: IUnknown;
    dwCookie: LongWord;
  end;

  IMAPI_READ_TRACK_ADDRESS_TYPE = _IMAPI_READ_TRACK_ADDRESS_TYPE; 
  IMAPI_FEATURE_PAGE_TYPE = _IMAPI_FEATURE_PAGE_TYPE; 
  IMAPI_MODE_PAGE_TYPE = _IMAPI_MODE_PAGE_TYPE; 
  IMAPI_MODE_PAGE_REQUEST_TYPE = _IMAPI_MODE_PAGE_REQUEST_TYPE; 
  IMAPI_PROFILE_TYPE = _IMAPI_PROFILE_TYPE; 
  IMAPI_FORMAT2_DATA_MEDIA_STATE = _IMAPI_FORMAT2_DATA_MEDIA_STATE; 
  IMAPI_MEDIA_WRITE_PROTECT_STATE = _IMAPI_MEDIA_WRITE_PROTECT_STATE; 
  PrivateAlias1 = array[0..17] of Byte; {*}

// *********************************************************************//
// Interface: IWriteEngine2EventArgs
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {27354136-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IWriteEngine2EventArgs = interface(IDispatch)
    ['{27354136-7F64-5B0F-8F00-5D77AFBE261E}']
    function Get_StartLba: Integer; safecall;
    function Get_SectorCount: Integer; safecall;
    function Get_LastReadLba: Integer; safecall;
    function Get_LastWrittenLba: Integer; safecall;
    function Get_TotalSystemBuffer: Integer; safecall;
    function Get_UsedSystemBuffer: Integer; safecall;
    function Get_FreeSystemBuffer: Integer; safecall;
    property StartLba: Integer read Get_StartLba;
    property SectorCount: Integer read Get_SectorCount;
    property LastReadLba: Integer read Get_LastReadLba;
    property LastWrittenLba: Integer read Get_LastWrittenLba;
    property TotalSystemBuffer: Integer read Get_TotalSystemBuffer;
    property UsedSystemBuffer: Integer read Get_UsedSystemBuffer;
    property FreeSystemBuffer: Integer read Get_FreeSystemBuffer;
  end;

// *********************************************************************//
// DispIntf:  IWriteEngine2EventArgsDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {27354136-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IWriteEngine2EventArgsDisp = dispinterface
    ['{27354136-7F64-5B0F-8F00-5D77AFBE261E}']
    property StartLba: Integer readonly dispid 256;
    property SectorCount: Integer readonly dispid 257;
    property LastReadLba: Integer readonly dispid 258;
    property LastWrittenLba: Integer readonly dispid 259;
    property TotalSystemBuffer: Integer readonly dispid 262;
    property UsedSystemBuffer: Integer readonly dispid 263;
    property FreeSystemBuffer: Integer readonly dispid 264;
  end;

// *********************************************************************//
// Interface: IDiscFormat2DataEventArgs
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {2735413D-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IDiscFormat2DataEventArgs = interface(IWriteEngine2EventArgs)
    ['{2735413D-7F64-5B0F-8F00-5D77AFBE261E}']
    function Get_ElapsedTime: Integer; safecall;
    function Get_RemainingTime: Integer; safecall;
    function Get_TotalTime: Integer; safecall;
    function Get_CurrentAction: IMAPI_FORMAT2_DATA_WRITE_ACTION; safecall;
    property ElapsedTime: Integer read Get_ElapsedTime;
    property RemainingTime: Integer read Get_RemainingTime;
    property TotalTime: Integer read Get_TotalTime;
    property CurrentAction: IMAPI_FORMAT2_DATA_WRITE_ACTION read Get_CurrentAction;
  end;

// *********************************************************************//
// DispIntf:  IDiscFormat2DataEventArgsDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {2735413D-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IDiscFormat2DataEventArgsDisp = dispinterface
    ['{2735413D-7F64-5B0F-8F00-5D77AFBE261E}']
    property ElapsedTime: Integer readonly dispid 768;
    property RemainingTime: Integer readonly dispid 769;
    property TotalTime: Integer readonly dispid 770;
    property CurrentAction: IMAPI_FORMAT2_DATA_WRITE_ACTION readonly dispid 771;
    property StartLba: Integer readonly dispid 256;
    property SectorCount: Integer readonly dispid 257;
    property LastReadLba: Integer readonly dispid 258;
    property LastWrittenLba: Integer readonly dispid 259;
    property TotalSystemBuffer: Integer readonly dispid 262;
    property UsedSystemBuffer: Integer readonly dispid 263;
    property FreeSystemBuffer: Integer readonly dispid 264;
  end;

// *********************************************************************//
// Interface: IDiscFormat2TrackAtOnceEventArgs
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {27354140-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IDiscFormat2TrackAtOnceEventArgs = interface(IWriteEngine2EventArgs)
    ['{27354140-7F64-5B0F-8F00-5D77AFBE261E}']
    function Get_CurrentTrackNumber: Integer; safecall;
    function Get_CurrentAction: IMAPI_FORMAT2_TAO_WRITE_ACTION; safecall;
    function Get_ElapsedTime: Integer; safecall;
    function Get_RemainingTime: Integer; safecall;
    property CurrentTrackNumber: Integer read Get_CurrentTrackNumber;
    property CurrentAction: IMAPI_FORMAT2_TAO_WRITE_ACTION read Get_CurrentAction;
    property ElapsedTime: Integer read Get_ElapsedTime;
    property RemainingTime: Integer read Get_RemainingTime;
  end;

// *********************************************************************//
// DispIntf:  IDiscFormat2TrackAtOnceEventArgsDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {27354140-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IDiscFormat2TrackAtOnceEventArgsDisp = dispinterface
    ['{27354140-7F64-5B0F-8F00-5D77AFBE261E}']
    property CurrentTrackNumber: Integer readonly dispid 768;
    property CurrentAction: IMAPI_FORMAT2_TAO_WRITE_ACTION readonly dispid 769;
    property ElapsedTime: Integer readonly dispid 770;
    property RemainingTime: Integer readonly dispid 771;
    property StartLba: Integer readonly dispid 256;
    property SectorCount: Integer readonly dispid 257;
    property LastReadLba: Integer readonly dispid 258;
    property LastWrittenLba: Integer readonly dispid 259;
    property TotalSystemBuffer: Integer readonly dispid 262;
    property UsedSystemBuffer: Integer readonly dispid 263;
    property FreeSystemBuffer: Integer readonly dispid 264;
  end;

// *********************************************************************//
// Interface: IDiscFormat2RawCDEventArgs
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {27354143-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IDiscFormat2RawCDEventArgs = interface(IWriteEngine2EventArgs)
    ['{27354143-7F64-5B0F-8F00-5D77AFBE261E}']
    function Get_CurrentAction: IMAPI_FORMAT2_RAW_CD_WRITE_ACTION; safecall;
    function Get_ElapsedTime: Integer; safecall;
    function Get_RemainingTime: Integer; safecall;
    property CurrentAction: IMAPI_FORMAT2_RAW_CD_WRITE_ACTION read Get_CurrentAction;
    property ElapsedTime: Integer read Get_ElapsedTime;
    property RemainingTime: Integer read Get_RemainingTime;
  end;

// *********************************************************************//
// DispIntf:  IDiscFormat2RawCDEventArgsDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {27354143-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IDiscFormat2RawCDEventArgsDisp = dispinterface
    ['{27354143-7F64-5B0F-8F00-5D77AFBE261E}']
    property CurrentAction: IMAPI_FORMAT2_RAW_CD_WRITE_ACTION readonly dispid 769;
    property ElapsedTime: Integer readonly dispid 770;
    property RemainingTime: Integer readonly dispid 771;
    property StartLba: Integer readonly dispid 256;
    property SectorCount: Integer readonly dispid 257;
    property LastReadLba: Integer readonly dispid 258;
    property LastWrittenLba: Integer readonly dispid 259;
    property TotalSystemBuffer: Integer readonly dispid 262;
    property UsedSystemBuffer: Integer readonly dispid 263;
    property FreeSystemBuffer: Integer readonly dispid 264;
  end;

// *********************************************************************//
// Interface: IWriteSpeedDescriptor
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {27354144-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IWriteSpeedDescriptor = interface(IDispatch)
    ['{27354144-7F64-5B0F-8F00-5D77AFBE261E}']
    function Get_MediaType: IMAPI_MEDIA_PHYSICAL_TYPE; safecall;
    function Get_RotationTypeIsPureCAV: WordBool; safecall;
    function Get_WriteSpeed: Integer; safecall;
    property MediaType: IMAPI_MEDIA_PHYSICAL_TYPE read Get_MediaType;
    property RotationTypeIsPureCAV: WordBool read Get_RotationTypeIsPureCAV;
    property WriteSpeed: Integer read Get_WriteSpeed;
  end;

// *********************************************************************//
// DispIntf:  IWriteSpeedDescriptorDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {27354144-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IWriteSpeedDescriptorDisp = dispinterface
    ['{27354144-7F64-5B0F-8F00-5D77AFBE261E}']
    property MediaType: IMAPI_MEDIA_PHYSICAL_TYPE readonly dispid 257;
    property RotationTypeIsPureCAV: WordBool readonly dispid 258;
    property WriteSpeed: Integer readonly dispid 259;
  end;

// *********************************************************************//
// Interface: DDiscMaster2Events
// Flags:     (4480) NonExtensible OleAutomation Dispatchable
// GUID:      {27354131-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  DDiscMaster2Events = interface(IDispatch)
    ['{27354131-7F64-5B0F-8F00-5D77AFBE261E}']
    function NotifyDeviceAdded(const object_: IDispatch; const uniqueId: WideString): HResult; stdcall;
    function NotifyDeviceRemoved(const object_: IDispatch; const uniqueId: WideString): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: DWriteEngine2Events
// Flags:     (4480) NonExtensible OleAutomation Dispatchable
// GUID:      {27354137-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  DWriteEngine2Events = interface(IDispatch)
    ['{27354137-7F64-5B0F-8F00-5D77AFBE261E}']
    function Update(const object_: IDispatch; const progress: IDispatch): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: DDiscFormat2EraseEvents
// Flags:     (4480) NonExtensible OleAutomation Dispatchable
// GUID:      {2735413A-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  DDiscFormat2EraseEvents = interface(IDispatch)
    ['{2735413A-7F64-5B0F-8F00-5D77AFBE261E}']
    function Update(const object_: IDispatch; elapsedSeconds: Integer; 
                    estimatedTotalSeconds: Integer): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: DDiscFormat2DataEvents
// Flags:     (4480) NonExtensible OleAutomation Dispatchable
// GUID:      {2735413C-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  DDiscFormat2DataEvents = interface(IDispatch)
    ['{2735413C-7F64-5B0F-8F00-5D77AFBE261E}']
    function Update(const object_: IDispatch; const progress: IDispatch): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: DDiscFormat2TrackAtOnceEvents
// Flags:     (4480) NonExtensible OleAutomation Dispatchable
// GUID:      {2735413F-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  DDiscFormat2TrackAtOnceEvents = interface(IDispatch)
    ['{2735413F-7F64-5B0F-8F00-5D77AFBE261E}']
    function Update(const object_: IDispatch; const progress: IDispatch): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: DDiscFormat2RawCDEvents
// Flags:     (4480) NonExtensible OleAutomation Dispatchable
// GUID:      {27354142-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  DDiscFormat2RawCDEvents = interface(IDispatch)
    ['{27354142-7F64-5B0F-8F00-5D77AFBE261E}']
    function Update(const object_: IDispatch; const progress: IDispatch): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IRawCDImageCreator
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {25983550-9D65-49CE-B335-40630D901227}
// *********************************************************************//
  IRawCDImageCreator = interface(IDispatch)
    ['{25983550-9D65-49CE-B335-40630D901227}']
    function CreateResultImage: IStream; safecall;
    function AddTrack(dataType: IMAPI_CD_SECTOR_TYPE; const data: IStream): Integer; safecall;
    procedure AddSpecialPregap(const data: IStream); safecall;
    procedure AddSubcodeRWGenerator(const subcode: IStream); safecall;
    procedure Set_ResultingImageType(value: IMAPI_FORMAT2_RAW_CD_DATA_SECTOR_TYPE); safecall;
    function Get_ResultingImageType: IMAPI_FORMAT2_RAW_CD_DATA_SECTOR_TYPE; safecall;
    function Get_StartOfLeadout: Integer; safecall;
    procedure Set_StartOfLeadoutLimit(value: Integer); safecall;
    function Get_StartOfLeadoutLimit: Integer; safecall;
    procedure Set_DisableGaplessAudio(value: WordBool); safecall;
    function Get_DisableGaplessAudio: WordBool; safecall;
    procedure Set_MediaCatalogNumber(const value: WideString); safecall;
    function Get_MediaCatalogNumber: WideString; safecall;
    procedure Set_StartingTrackNumber(value: Integer); safecall;
    function Get_StartingTrackNumber: Integer; safecall;
    function Get_TrackInfo(trackIndex: Integer): IRawCDImageTrackInfo; safecall;
    function Get_NumberOfExistingTracks: Integer; safecall;
    function Get_LastUsedUserSectorInImage: Integer; safecall;
    function Get_ExpectedTableOfContents: PSafeArray; safecall;
    property ResultingImageType: IMAPI_FORMAT2_RAW_CD_DATA_SECTOR_TYPE read Get_ResultingImageType write Set_ResultingImageType;
    property StartOfLeadout: Integer read Get_StartOfLeadout;
    property StartOfLeadoutLimit: Integer read Get_StartOfLeadoutLimit write Set_StartOfLeadoutLimit;
    property DisableGaplessAudio: WordBool read Get_DisableGaplessAudio write Set_DisableGaplessAudio;
    property MediaCatalogNumber: WideString read Get_MediaCatalogNumber write Set_MediaCatalogNumber;
    property StartingTrackNumber: Integer read Get_StartingTrackNumber write Set_StartingTrackNumber;
    property TrackInfo[trackIndex: Integer]: IRawCDImageTrackInfo read Get_TrackInfo;
    property NumberOfExistingTracks: Integer read Get_NumberOfExistingTracks;
    property LastUsedUserSectorInImage: Integer read Get_LastUsedUserSectorInImage;
    property ExpectedTableOfContents: PSafeArray read Get_ExpectedTableOfContents;
  end;

// *********************************************************************//
// DispIntf:  IRawCDImageCreatorDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {25983550-9D65-49CE-B335-40630D901227}
// *********************************************************************//
  IRawCDImageCreatorDisp = dispinterface
    ['{25983550-9D65-49CE-B335-40630D901227}']
    function CreateResultImage: IStream; dispid 512;
    function AddTrack(dataType: IMAPI_CD_SECTOR_TYPE; const data: IStream): Integer; dispid 513;
    procedure AddSpecialPregap(const data: IStream); dispid 514;
    procedure AddSubcodeRWGenerator(const subcode: IStream); dispid 515;
    property ResultingImageType: IMAPI_FORMAT2_RAW_CD_DATA_SECTOR_TYPE dispid 256;
    property StartOfLeadout: Integer readonly dispid 257;
    property StartOfLeadoutLimit: Integer dispid 258;
    property DisableGaplessAudio: WordBool dispid 259;
    property MediaCatalogNumber: WideString dispid 260;
    property StartingTrackNumber: Integer dispid 261;
    property TrackInfo[trackIndex: Integer]: IRawCDImageTrackInfo readonly dispid 262;
    property NumberOfExistingTracks: Integer readonly dispid 263;
    property LastUsedUserSectorInImage: Integer readonly dispid 264;
    property ExpectedTableOfContents: {NOT_OLEAUTO(PSafeArray)}OleVariant readonly dispid 265;
  end;

// *********************************************************************//
// Interface: ISequentialStream
// Flags:     (0)
// GUID:      {0C733A30-2A1C-11CE-ADE5-00AA0044773D}
// *********************************************************************//
  ISequentialStream = interface(IUnknown)
    ['{0C733A30-2A1C-11CE-ADE5-00AA0044773D}']
    function RemoteRead(out pv: Byte; cb: LongWord; out pcbRead: LongWord): HResult; stdcall;
    function RemoteWrite(var pv: Byte; cb: LongWord; out pcbWritten: LongWord): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IStream
// Flags:     (0)
// GUID:      {0000000C-0000-0000-C000-000000000046}
// *********************************************************************//
  IStream = interface(ISequentialStream)
    ['{0000000C-0000-0000-C000-000000000046}']
    function RemoteSeek(dlibMove: _LARGE_INTEGER; dwOrigin: LongWord; 
                        out plibNewPosition: _ULARGE_INTEGER): HResult; stdcall;
    function SetSize(libNewSize: _ULARGE_INTEGER): HResult; stdcall;
    function RemoteCopyTo(const pstm: IStream; cb: _ULARGE_INTEGER; out pcbRead: _ULARGE_INTEGER; 
                          out pcbWritten: _ULARGE_INTEGER): HResult; stdcall;
    function Commit(grfCommitFlags: LongWord): HResult; stdcall;
    function Revert: HResult; stdcall;
    function LockRegion(libOffset: _ULARGE_INTEGER; cb: _ULARGE_INTEGER; dwLockType: LongWord): HResult; stdcall;
    function UnlockRegion(libOffset: _ULARGE_INTEGER; cb: _ULARGE_INTEGER; dwLockType: LongWord): HResult; stdcall;
    function Stat(out pstatstg: tagSTATSTG; grfStatFlag: LongWord): HResult; stdcall;
    function Clone(out ppstm: IStream): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IRawCDImageTrackInfo
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {25983551-9D65-49CE-B335-40630D901227}
// *********************************************************************//
  IRawCDImageTrackInfo = interface(IDispatch)
    ['{25983551-9D65-49CE-B335-40630D901227}']
    function Get_StartingLba: Integer; safecall;
    function Get_SectorCount: Integer; safecall;
    function Get_TrackNumber: Integer; safecall;
    function Get_SectorType: IMAPI_CD_SECTOR_TYPE; safecall;
    function Get_ISRC: WideString; safecall;
    procedure Set_ISRC(const value: WideString); safecall;
    function Get_DigitalAudioCopySetting: IMAPI_CD_TRACK_DIGITAL_COPY_SETTING; safecall;
    procedure Set_DigitalAudioCopySetting(value: IMAPI_CD_TRACK_DIGITAL_COPY_SETTING); safecall;
    function Get_AudioHasPreemphasis: WordBool; safecall;
    procedure Set_AudioHasPreemphasis(value: WordBool); safecall;
    function Get_TrackIndexes: PSafeArray; safecall;
    procedure AddTrackIndex(lbaOffset: Integer); safecall;
    procedure ClearTrackIndex(lbaOffset: Integer); safecall;
    property StartingLba: Integer read Get_StartingLba;
    property SectorCount: Integer read Get_SectorCount;
    property TrackNumber: Integer read Get_TrackNumber;
    property SectorType: IMAPI_CD_SECTOR_TYPE read Get_SectorType;
    property ISRC: WideString read Get_ISRC write Set_ISRC;
    property DigitalAudioCopySetting: IMAPI_CD_TRACK_DIGITAL_COPY_SETTING read Get_DigitalAudioCopySetting write Set_DigitalAudioCopySetting;
    property AudioHasPreemphasis: WordBool read Get_AudioHasPreemphasis write Set_AudioHasPreemphasis;
    property TrackIndexes: PSafeArray read Get_TrackIndexes;
  end;

// *********************************************************************//
// DispIntf:  IRawCDImageTrackInfoDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {25983551-9D65-49CE-B335-40630D901227}
// *********************************************************************//
  IRawCDImageTrackInfoDisp = dispinterface
    ['{25983551-9D65-49CE-B335-40630D901227}']
    property StartingLba: Integer readonly dispid 256;
    property SectorCount: Integer readonly dispid 257;
    property TrackNumber: Integer readonly dispid 258;
    property SectorType: IMAPI_CD_SECTOR_TYPE readonly dispid 259;
    property ISRC: WideString dispid 260;
    property DigitalAudioCopySetting: IMAPI_CD_TRACK_DIGITAL_COPY_SETTING dispid 261;
    property AudioHasPreemphasis: WordBool dispid 262;
    property TrackIndexes: {NOT_OLEAUTO(PSafeArray)}OleVariant readonly dispid 263;
    procedure AddTrackIndex(lbaOffset: Integer); dispid 512;
    procedure ClearTrackIndex(lbaOffset: Integer); dispid 513;
  end;

// *********************************************************************//
// Interface: IBurnVerification
// Flags:     (0)
// GUID:      {D2FFD834-958B-426D-8470-2A13879C6A91}
// *********************************************************************//
  IBurnVerification = interface(IUnknown)
    ['{D2FFD834-958B-426D-8470-2A13879C6A91}']
    function Set_BurnVerificationLevel(value: IMAPI_BURN_VERIFICATION_LEVEL): HResult; stdcall;
    function Get_BurnVerificationLevel(out value: IMAPI_BURN_VERIFICATION_LEVEL): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IBlockRange
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B507CA25-2204-11DD-966A-001AA01BBC58}
// *********************************************************************//
  IBlockRange = interface(IDispatch)
    ['{B507CA25-2204-11DD-966A-001AA01BBC58}']
    function Get_StartLba: Integer; safecall;
    function Get_EndLba: Integer; safecall;
    property StartLba: Integer read Get_StartLba;
    property EndLba: Integer read Get_EndLba;
  end;

// *********************************************************************//
// DispIntf:  IBlockRangeDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B507CA25-2204-11DD-966A-001AA01BBC58}
// *********************************************************************//
  IBlockRangeDisp = dispinterface
    ['{B507CA25-2204-11DD-966A-001AA01BBC58}']
    property StartLba: Integer readonly dispid 256;
    property EndLba: Integer readonly dispid 257;
  end;

// *********************************************************************//
// Interface: IBlockRangeList
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B507CA26-2204-11DD-966A-001AA01BBC58}
// *********************************************************************//
  IBlockRangeList = interface(IDispatch)
    ['{B507CA26-2204-11DD-966A-001AA01BBC58}']
    function Get_BlockRanges: PSafeArray; safecall;
    property BlockRanges: PSafeArray read Get_BlockRanges;
  end;

// *********************************************************************//
// DispIntf:  IBlockRangeListDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B507CA26-2204-11DD-966A-001AA01BBC58}
// *********************************************************************//
  IBlockRangeListDisp = dispinterface
    ['{B507CA26-2204-11DD-966A-001AA01BBC58}']
    property BlockRanges: {NOT_OLEAUTO(PSafeArray)}OleVariant readonly dispid 256;
  end;

// *********************************************************************//
// Interface: IDiscMaster2
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {27354130-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IDiscMaster2 = interface(IDispatch)
    ['{27354130-7F64-5B0F-8F00-5D77AFBE261E}']
    function Get__NewEnum: IEnumVARIANT; safecall;
    function Get_Item(index: Integer): WideString; safecall;
    function Get_Count: Integer; safecall;
    function Get_IsSupportedEnvironment: WordBool; safecall;
    property _NewEnum: IEnumVARIANT read Get__NewEnum;
    property Item[index: Integer]: WideString read Get_Item; default;
    property Count: Integer read Get_Count;
    property IsSupportedEnvironment: WordBool read Get_IsSupportedEnvironment;
  end;

// *********************************************************************//
// DispIntf:  IDiscMaster2Disp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {27354130-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IDiscMaster2Disp = dispinterface
    ['{27354130-7F64-5B0F-8F00-5D77AFBE261E}']
    property _NewEnum: IEnumVARIANT readonly dispid -4;
    property Item[index: Integer]: WideString readonly dispid 0; default;
    property Count: Integer readonly dispid 1;
    property IsSupportedEnvironment: WordBool readonly dispid 2;
  end;

// *********************************************************************//
// Interface: IConnectionPointContainer
// Flags:     (0)
// GUID:      {B196B284-BAB4-101A-B69C-00AA00341D07}
// *********************************************************************//
  IConnectionPointContainer = interface(IUnknown)
    ['{B196B284-BAB4-101A-B69C-00AA00341D07}']
    function EnumConnectionPoints(out ppEnum: IEnumConnectionPoints): HResult; stdcall;
    function FindConnectionPoint(var riid: TGUID; out ppCP: IConnectionPoint): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IEnumConnectionPoints
// Flags:     (0)
// GUID:      {B196B285-BAB4-101A-B69C-00AA00341D07}
// *********************************************************************//
  IEnumConnectionPoints = interface(IUnknown)
    ['{B196B285-BAB4-101A-B69C-00AA00341D07}']
    function RemoteNext(cConnections: LongWord; out ppCP: IConnectionPoint; out pcFetched: LongWord): HResult; stdcall;
    function Skip(cConnections: LongWord): HResult; stdcall;
    function Reset: HResult; stdcall;
    function Clone(out ppEnum: IEnumConnectionPoints): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IConnectionPoint
// Flags:     (0)
// GUID:      {B196B286-BAB4-101A-B69C-00AA00341D07}
// *********************************************************************//
  IConnectionPoint = interface(IUnknown)
    ['{B196B286-BAB4-101A-B69C-00AA00341D07}']
    function GetConnectionInterface(out pIID: TGUID): HResult; stdcall;
    function GetConnectionPointContainer(out ppCPC: IConnectionPointContainer): HResult; stdcall;
    function Advise(const pUnkSink: IUnknown; out pdwCookie: LongWord): HResult; stdcall;
    function Unadvise(dwCookie: LongWord): HResult; stdcall;
    function EnumConnections(out ppEnum: IEnumConnections): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IEnumConnections
// Flags:     (0)
// GUID:      {B196B287-BAB4-101A-B69C-00AA00341D07}
// *********************************************************************//
  IEnumConnections = interface(IUnknown)
    ['{B196B287-BAB4-101A-B69C-00AA00341D07}']
    function RemoteNext(cConnections: LongWord; out rgcd: tagCONNECTDATA; out pcFetched: LongWord): HResult; stdcall;
    function Skip(cConnections: LongWord): HResult; stdcall;
    function Reset: HResult; stdcall;
    function Clone(out ppEnum: IEnumConnections): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDiscRecorder2
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {27354133-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IDiscRecorder2 = interface(IDispatch)
    ['{27354133-7F64-5B0F-8F00-5D77AFBE261E}']
    procedure EjectMedia; safecall;
    procedure CloseTray; safecall;
    procedure AcquireExclusiveAccess(force: WordBool; const __MIDL__IDiscRecorder20000: WideString); safecall;
    procedure ReleaseExclusiveAccess; safecall;
    procedure DisableMcn; safecall;
    procedure EnableMcn; safecall;
    procedure InitializeDiscRecorder(const recorderUniqueId: WideString); safecall;
    function Get_ActiveDiscRecorder: WideString; safecall;
    function Get_VendorId: WideString; safecall;
    function Get_ProductId: WideString; safecall;
    function Get_ProductRevision: WideString; safecall;
    function Get_VolumeName: WideString; safecall;
    function Get_VolumePathNames: PSafeArray; safecall;
    function Get_DeviceCanLoadMedia: WordBool; safecall;
    function Get_LegacyDeviceNumber: Integer; safecall;
    function Get_SupportedFeaturePages: PSafeArray; safecall;
    function Get_CurrentFeaturePages: PSafeArray; safecall;
    function Get_SupportedProfiles: PSafeArray; safecall;
    function Get_CurrentProfiles: PSafeArray; safecall;
    function Get_SupportedModePages: PSafeArray; safecall;
    function Get_ExclusiveAccessOwner: WideString; safecall;
    property ActiveDiscRecorder: WideString read Get_ActiveDiscRecorder;
    property VendorId: WideString read Get_VendorId;
    property ProductId: WideString read Get_ProductId;
    property ProductRevision: WideString read Get_ProductRevision;
    property VolumeName: WideString read Get_VolumeName;
    property VolumePathNames: PSafeArray read Get_VolumePathNames;
    property DeviceCanLoadMedia: WordBool read Get_DeviceCanLoadMedia;
    property LegacyDeviceNumber: Integer read Get_LegacyDeviceNumber;
    property SupportedFeaturePages: PSafeArray read Get_SupportedFeaturePages;
    property CurrentFeaturePages: PSafeArray read Get_CurrentFeaturePages;
    property SupportedProfiles: PSafeArray read Get_SupportedProfiles;
    property CurrentProfiles: PSafeArray read Get_CurrentProfiles;
    property SupportedModePages: PSafeArray read Get_SupportedModePages;
    property ExclusiveAccessOwner: WideString read Get_ExclusiveAccessOwner;
  end;

// *********************************************************************//
// DispIntf:  IDiscRecorder2Disp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {27354133-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IDiscRecorder2Disp = dispinterface
    ['{27354133-7F64-5B0F-8F00-5D77AFBE261E}']
    procedure EjectMedia; dispid 256;
    procedure CloseTray; dispid 257;
    procedure AcquireExclusiveAccess(force: WordBool; const __MIDL__IDiscRecorder20000: WideString); dispid 258;
    procedure ReleaseExclusiveAccess; dispid 259;
    procedure DisableMcn; dispid 260;
    procedure EnableMcn; dispid 261;
    procedure InitializeDiscRecorder(const recorderUniqueId: WideString); dispid 262;
    property ActiveDiscRecorder: WideString readonly dispid 0;
    property VendorId: WideString readonly dispid 513;
    property ProductId: WideString readonly dispid 514;
    property ProductRevision: WideString readonly dispid 515;
    property VolumeName: WideString readonly dispid 516;
    property VolumePathNames: {NOT_OLEAUTO(PSafeArray)}OleVariant readonly dispid 517;
    property DeviceCanLoadMedia: WordBool readonly dispid 518;
    property LegacyDeviceNumber: Integer readonly dispid 519;
    property SupportedFeaturePages: {NOT_OLEAUTO(PSafeArray)}OleVariant readonly dispid 520;
    property CurrentFeaturePages: {NOT_OLEAUTO(PSafeArray)}OleVariant readonly dispid 521;
    property SupportedProfiles: {NOT_OLEAUTO(PSafeArray)}OleVariant readonly dispid 522;
    property CurrentProfiles: {NOT_OLEAUTO(PSafeArray)}OleVariant readonly dispid 523;
    property SupportedModePages: {NOT_OLEAUTO(PSafeArray)}OleVariant readonly dispid 524;
    property ExclusiveAccessOwner: WideString readonly dispid 525;
  end;

// *********************************************************************//
// Interface: IDiscRecorder2Ex
// Flags:     (0)
// GUID:      {27354132-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IDiscRecorder2Ex = interface(IUnknown)
    ['{27354132-7F64-5B0F-8F00-5D77AFBE261E}']
    function SendCommandNoData(var Cdb: Byte; CdbSize: LongWord; SenseBuffer: PrivateAlias1; 
                               Timeout: LongWord): HResult; stdcall;
    function SendCommandSendDataToDevice(var Cdb: Byte; CdbSize: LongWord; 
                                         SenseBuffer: PrivateAlias1; Timeout: LongWord; 
                                         var Buffer: Byte; BufferSize: LongWord): HResult; stdcall;
    function SendCommandGetDataFromDevice(var Cdb: Byte; CdbSize: LongWord; 
                                          SenseBuffer: PrivateAlias1; Timeout: LongWord; 
                                          out Buffer: Byte; BufferSize: LongWord; 
                                          out BufferFetched: LongWord): HResult; stdcall;
    function ReadDvdStructure(format: LongWord; address: LongWord; layer: LongWord; agid: LongWord; 
                              out data: PByte1; out Count: LongWord): HResult; stdcall;
    function SendDvdStructure(format: LongWord; var data: Byte; Count: LongWord): HResult; stdcall;
    function GetAdapterDescriptor(out data: PByte1; out byteSize: LongWord): HResult; stdcall;
    function GetDeviceDescriptor(out data: PByte1; out byteSize: LongWord): HResult; stdcall;
    function GetDiscInformation(out discInformation: PByte1; out byteSize: LongWord): HResult; stdcall;
    function GetTrackInformation(address: LongWord; addressType: IMAPI_READ_TRACK_ADDRESS_TYPE; 
                                 out trackInformation: PByte1; out byteSize: LongWord): HResult; stdcall;
    function GetFeaturePage(requestedFeature: IMAPI_FEATURE_PAGE_TYPE; 
                            currentFeatureOnly: Shortint; out featureData: PByte1; 
                            out byteSize: LongWord): HResult; stdcall;
    function GetModePage(requestedModePage: IMAPI_MODE_PAGE_TYPE; 
                         requestType: IMAPI_MODE_PAGE_REQUEST_TYPE; out modePageData: PByte1; 
                         out byteSize: LongWord): HResult; stdcall;
    function SetModePage(requestType: IMAPI_MODE_PAGE_REQUEST_TYPE; var data: Byte; 
                         byteSize: LongWord): HResult; stdcall;
    function GetSupportedFeaturePages(currentFeatureOnly: Shortint; out featureData: PUserType2; 
                                      out byteSize: LongWord): HResult; stdcall;
    function GetSupportedProfiles(currentOnly: Shortint; out profileTypes: PUserType3; 
                                  out validProfiles: LongWord): HResult; stdcall;
    function GetSupportedModePages(requestType: IMAPI_MODE_PAGE_REQUEST_TYPE; 
                                   out modePageTypes: PUserType4; out validPages: LongWord): HResult; stdcall;
    function GetByteAlignmentMask(out value: LongWord): HResult; stdcall;
    function GetMaximumNonPageAlignedTransferSize(out value: LongWord): HResult; stdcall;
    function GetMaximumPageAlignedTransferSize(out value: LongWord): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IWriteEngine2
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {27354135-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IWriteEngine2 = interface(IDispatch)
    ['{27354135-7F64-5B0F-8F00-5D77AFBE261E}']
    procedure WriteSection(const data: IStream; startingBlockAddress: Integer; 
                           numberOfBlocks: Integer); safecall;
    procedure CancelWrite; safecall;
    procedure Set_Recorder(const value: IDiscRecorder2Ex); safecall;
    function Get_Recorder: IDiscRecorder2Ex; safecall;
    procedure Set_UseStreamingWrite12(value: WordBool); safecall;
    function Get_UseStreamingWrite12: WordBool; safecall;
    procedure Set_StartingSectorsPerSecond(value: Integer); safecall;
    function Get_StartingSectorsPerSecond: Integer; safecall;
    procedure Set_EndingSectorsPerSecond(value: Integer); safecall;
    function Get_EndingSectorsPerSecond: Integer; safecall;
    procedure Set_BytesPerSector(value: Integer); safecall;
    function Get_BytesPerSector: Integer; safecall;
    function Get_WriteInProgress: WordBool; safecall;
    property Recorder: IDiscRecorder2Ex read Get_Recorder write Set_Recorder;
    property UseStreamingWrite12: WordBool read Get_UseStreamingWrite12 write Set_UseStreamingWrite12;
    property StartingSectorsPerSecond: Integer read Get_StartingSectorsPerSecond write Set_StartingSectorsPerSecond;
    property EndingSectorsPerSecond: Integer read Get_EndingSectorsPerSecond write Set_EndingSectorsPerSecond;
    property BytesPerSector: Integer read Get_BytesPerSector write Set_BytesPerSector;
    property WriteInProgress: WordBool read Get_WriteInProgress;
  end;

// *********************************************************************//
// DispIntf:  IWriteEngine2Disp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {27354135-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IWriteEngine2Disp = dispinterface
    ['{27354135-7F64-5B0F-8F00-5D77AFBE261E}']
    procedure WriteSection(const data: IStream; startingBlockAddress: Integer; 
                           numberOfBlocks: Integer); dispid 512;
    procedure CancelWrite; dispid 513;
    property Recorder: IDiscRecorder2Ex dispid 256;
    property UseStreamingWrite12: WordBool dispid 257;
    property StartingSectorsPerSecond: Integer dispid 258;
    property EndingSectorsPerSecond: Integer dispid 259;
    property BytesPerSector: Integer dispid 260;
    property WriteInProgress: WordBool readonly dispid 261;
  end;

// *********************************************************************//
// Interface: IDiscFormat2
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {27354152-8F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IDiscFormat2 = interface(IDispatch)
    ['{27354152-8F64-5B0F-8F00-5D77AFBE261E}']
    function IsRecorderSupported(const Recorder: IDiscRecorder2): WordBool; safecall;
    function IsCurrentMediaSupported(const Recorder: IDiscRecorder2): WordBool; safecall;
    function Get_MediaPhysicallyBlank: WordBool; safecall;
    function Get_MediaHeuristicallyBlank: WordBool; safecall;
    function Get_SupportedMediaTypes: PSafeArray; safecall;
    property MediaPhysicallyBlank: WordBool read Get_MediaPhysicallyBlank;
    property MediaHeuristicallyBlank: WordBool read Get_MediaHeuristicallyBlank;
    property SupportedMediaTypes: PSafeArray read Get_SupportedMediaTypes;
  end;

// *********************************************************************//
// DispIntf:  IDiscFormat2Disp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {27354152-8F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IDiscFormat2Disp = dispinterface
    ['{27354152-8F64-5B0F-8F00-5D77AFBE261E}']
    function IsRecorderSupported(const Recorder: IDiscRecorder2): WordBool; dispid 2048;
    function IsCurrentMediaSupported(const Recorder: IDiscRecorder2): WordBool; dispid 2049;
    property MediaPhysicallyBlank: WordBool readonly dispid 1792;
    property MediaHeuristicallyBlank: WordBool readonly dispid 1793;
    property SupportedMediaTypes: {NOT_OLEAUTO(PSafeArray)}OleVariant readonly dispid 1794;
  end;

// *********************************************************************//
// Interface: IDiscFormat2Erase
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {27354156-8F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IDiscFormat2Erase = interface(IDiscFormat2)
    ['{27354156-8F64-5B0F-8F00-5D77AFBE261E}']
    procedure Set_Recorder(const value: IDiscRecorder2); safecall;
    function Get_Recorder: IDiscRecorder2; safecall;
    procedure Set_FullErase(value: WordBool); safecall;
    function Get_FullErase: WordBool; safecall;
    function Get_CurrentPhysicalMediaType: IMAPI_MEDIA_PHYSICAL_TYPE; safecall;
    procedure Set_ClientName(const value: WideString); safecall;
    function Get_ClientName: WideString; safecall;
    procedure EraseMedia; safecall;
    property Recorder: IDiscRecorder2 read Get_Recorder write Set_Recorder;
    property FullErase: WordBool read Get_FullErase write Set_FullErase;
    property CurrentPhysicalMediaType: IMAPI_MEDIA_PHYSICAL_TYPE read Get_CurrentPhysicalMediaType;
    property ClientName: WideString read Get_ClientName write Set_ClientName;
  end;

// *********************************************************************//
// DispIntf:  IDiscFormat2EraseDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {27354156-8F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IDiscFormat2EraseDisp = dispinterface
    ['{27354156-8F64-5B0F-8F00-5D77AFBE261E}']
    property Recorder: IDiscRecorder2 dispid 256;
    property FullErase: WordBool dispid 257;
    property CurrentPhysicalMediaType: IMAPI_MEDIA_PHYSICAL_TYPE readonly dispid 258;
    property ClientName: WideString dispid 259;
    procedure EraseMedia; dispid 513;
    function IsRecorderSupported(const Recorder: IDiscRecorder2): WordBool; dispid 2048;
    function IsCurrentMediaSupported(const Recorder: IDiscRecorder2): WordBool; dispid 2049;
    property MediaPhysicallyBlank: WordBool readonly dispid 1792;
    property MediaHeuristicallyBlank: WordBool readonly dispid 1793;
    property SupportedMediaTypes: {NOT_OLEAUTO(PSafeArray)}OleVariant readonly dispid 1794;
  end;

// *********************************************************************//
// Interface: IDiscFormat2Data
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {27354153-9F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IDiscFormat2Data = interface(IDiscFormat2)
    ['{27354153-9F64-5B0F-8F00-5D77AFBE261E}']
    procedure Set_Recorder(const value: IDiscRecorder2); safecall;
    function Get_Recorder: IDiscRecorder2; safecall;
    procedure Set_BufferUnderrunFreeDisabled(value: WordBool); safecall;
    function Get_BufferUnderrunFreeDisabled: WordBool; safecall;
    procedure Set_PostgapAlreadyInImage(value: WordBool); safecall;
    function Get_PostgapAlreadyInImage: WordBool; safecall;
    function Get_CurrentMediaStatus: IMAPI_FORMAT2_DATA_MEDIA_STATE; safecall;
    function Get_WriteProtectStatus: IMAPI_MEDIA_WRITE_PROTECT_STATE; safecall;
    function Get_TotalSectorsOnMedia: Integer; safecall;
    function Get_FreeSectorsOnMedia: Integer; safecall;
    function Get_NextWritableAddress: Integer; safecall;
    function Get_StartAddressOfPreviousSession: Integer; safecall;
    function Get_LastWrittenAddressOfPreviousSession: Integer; safecall;
    procedure Set_ForceMediaToBeClosed(value: WordBool); safecall;
    function Get_ForceMediaToBeClosed: WordBool; safecall;
    procedure Set_DisableConsumerDvdCompatibilityMode(value: WordBool); safecall;
    function Get_DisableConsumerDvdCompatibilityMode: WordBool; safecall;
    function Get_CurrentPhysicalMediaType: IMAPI_MEDIA_PHYSICAL_TYPE; safecall;
    procedure Set_ClientName(const value: WideString); safecall;
    function Get_ClientName: WideString; safecall;
    function Get_RequestedWriteSpeed: Integer; safecall;
    function Get_RequestedRotationTypeIsPureCAV: WordBool; safecall;
    function Get_CurrentWriteSpeed: Integer; safecall;
    function Get_CurrentRotationTypeIsPureCAV: WordBool; safecall;
    function Get_SupportedWriteSpeeds: PSafeArray; safecall;
    function Get_SupportedWriteSpeedDescriptors: PSafeArray; safecall;
    procedure Set_ForceOverwrite(value: WordBool); safecall;
    function Get_ForceOverwrite: WordBool; safecall;
    function Get_MultisessionInterfaces: PSafeArray; safecall;
    procedure Write(const data: IStream); safecall;
    procedure CancelWrite; safecall;
    procedure SetWriteSpeed(RequestedSectorsPerSecond: Integer; RotationTypeIsPureCAV: WordBool); safecall;
    property Recorder: IDiscRecorder2 read Get_Recorder write Set_Recorder;
    property BufferUnderrunFreeDisabled: WordBool read Get_BufferUnderrunFreeDisabled write Set_BufferUnderrunFreeDisabled;
    property PostgapAlreadyInImage: WordBool read Get_PostgapAlreadyInImage write Set_PostgapAlreadyInImage;
    property CurrentMediaStatus: IMAPI_FORMAT2_DATA_MEDIA_STATE read Get_CurrentMediaStatus;
    property WriteProtectStatus: IMAPI_MEDIA_WRITE_PROTECT_STATE read Get_WriteProtectStatus;
    property TotalSectorsOnMedia: Integer read Get_TotalSectorsOnMedia;
    property FreeSectorsOnMedia: Integer read Get_FreeSectorsOnMedia;
    property NextWritableAddress: Integer read Get_NextWritableAddress;
    property StartAddressOfPreviousSession: Integer read Get_StartAddressOfPreviousSession;
    property LastWrittenAddressOfPreviousSession: Integer read Get_LastWrittenAddressOfPreviousSession;
    property ForceMediaToBeClosed: WordBool read Get_ForceMediaToBeClosed write Set_ForceMediaToBeClosed;
    property DisableConsumerDvdCompatibilityMode: WordBool read Get_DisableConsumerDvdCompatibilityMode write Set_DisableConsumerDvdCompatibilityMode;
    property CurrentPhysicalMediaType: IMAPI_MEDIA_PHYSICAL_TYPE read Get_CurrentPhysicalMediaType;
    property ClientName: WideString read Get_ClientName write Set_ClientName;
    property RequestedWriteSpeed: Integer read Get_RequestedWriteSpeed;
    property RequestedRotationTypeIsPureCAV: WordBool read Get_RequestedRotationTypeIsPureCAV;
    property CurrentWriteSpeed: Integer read Get_CurrentWriteSpeed;
    property CurrentRotationTypeIsPureCAV: WordBool read Get_CurrentRotationTypeIsPureCAV;
    property SupportedWriteSpeeds: PSafeArray read Get_SupportedWriteSpeeds;
    property SupportedWriteSpeedDescriptors: PSafeArray read Get_SupportedWriteSpeedDescriptors;
    property ForceOverwrite: WordBool read Get_ForceOverwrite write Set_ForceOverwrite;
    property MultisessionInterfaces: PSafeArray read Get_MultisessionInterfaces;
  end;

// *********************************************************************//
// DispIntf:  IDiscFormat2DataDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {27354153-9F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IDiscFormat2DataDisp = dispinterface
    ['{27354153-9F64-5B0F-8F00-5D77AFBE261E}']
    property Recorder: IDiscRecorder2 dispid 256;
    property BufferUnderrunFreeDisabled: WordBool dispid 257;
    property PostgapAlreadyInImage: WordBool dispid 260;
    property CurrentMediaStatus: IMAPI_FORMAT2_DATA_MEDIA_STATE readonly dispid 262;
    property WriteProtectStatus: IMAPI_MEDIA_WRITE_PROTECT_STATE readonly dispid 263;
    property TotalSectorsOnMedia: Integer readonly dispid 264;
    property FreeSectorsOnMedia: Integer readonly dispid 265;
    property NextWritableAddress: Integer readonly dispid 266;
    property StartAddressOfPreviousSession: Integer readonly dispid 267;
    property LastWrittenAddressOfPreviousSession: Integer readonly dispid 268;
    property ForceMediaToBeClosed: WordBool dispid 269;
    property DisableConsumerDvdCompatibilityMode: WordBool dispid 270;
    property CurrentPhysicalMediaType: IMAPI_MEDIA_PHYSICAL_TYPE readonly dispid 271;
    property ClientName: WideString dispid 272;
    property RequestedWriteSpeed: Integer readonly dispid 273;
    property RequestedRotationTypeIsPureCAV: WordBool readonly dispid 274;
    property CurrentWriteSpeed: Integer readonly dispid 275;
    property CurrentRotationTypeIsPureCAV: WordBool readonly dispid 276;
    property SupportedWriteSpeeds: {NOT_OLEAUTO(PSafeArray)}OleVariant readonly dispid 277;
    property SupportedWriteSpeedDescriptors: {NOT_OLEAUTO(PSafeArray)}OleVariant readonly dispid 278;
    property ForceOverwrite: WordBool dispid 279;
    property MultisessionInterfaces: {NOT_OLEAUTO(PSafeArray)}OleVariant readonly dispid 280;
    procedure Write(const data: IStream); dispid 512;
    procedure CancelWrite; dispid 513;
    procedure SetWriteSpeed(RequestedSectorsPerSecond: Integer; RotationTypeIsPureCAV: WordBool); dispid 514;
    function IsRecorderSupported(const Recorder: IDiscRecorder2): WordBool; dispid 2048;
    function IsCurrentMediaSupported(const Recorder: IDiscRecorder2): WordBool; dispid 2049;
    property MediaPhysicallyBlank: WordBool readonly dispid 1792;
    property MediaHeuristicallyBlank: WordBool readonly dispid 1793;
    property SupportedMediaTypes: {NOT_OLEAUTO(PSafeArray)}OleVariant readonly dispid 1794;
  end;

// *********************************************************************//
// Interface: IDiscFormat2TrackAtOnce
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {27354154-8F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IDiscFormat2TrackAtOnce = interface(IDiscFormat2)
    ['{27354154-8F64-5B0F-8F00-5D77AFBE261E}']
    procedure PrepareMedia; safecall;
    procedure AddAudioTrack(const data: IStream); safecall;
    procedure CancelAddTrack; safecall;
    procedure ReleaseMedia; safecall;
    procedure SetWriteSpeed(RequestedSectorsPerSecond: Integer; RotationTypeIsPureCAV: WordBool); safecall;
    procedure Set_Recorder(const value: IDiscRecorder2); safecall;
    function Get_Recorder: IDiscRecorder2; safecall;
    procedure Set_BufferUnderrunFreeDisabled(value: WordBool); safecall;
    function Get_BufferUnderrunFreeDisabled: WordBool; safecall;
    function Get_NumberOfExistingTracks: Integer; safecall;
    function Get_TotalSectorsOnMedia: Integer; safecall;
    function Get_FreeSectorsOnMedia: Integer; safecall;
    function Get_UsedSectorsOnMedia: Integer; safecall;
    procedure Set_DoNotFinalizeMedia(value: WordBool); safecall;
    function Get_DoNotFinalizeMedia: WordBool; safecall;
    function Get_ExpectedTableOfContents: PSafeArray; safecall;
    function Get_CurrentPhysicalMediaType: IMAPI_MEDIA_PHYSICAL_TYPE; safecall;
    procedure Set_ClientName(const value: WideString); safecall;
    function Get_ClientName: WideString; safecall;
    function Get_RequestedWriteSpeed: Integer; safecall;
    function Get_RequestedRotationTypeIsPureCAV: WordBool; safecall;
    function Get_CurrentWriteSpeed: Integer; safecall;
    function Get_CurrentRotationTypeIsPureCAV: WordBool; safecall;
    function Get_SupportedWriteSpeeds: PSafeArray; safecall;
    function Get_SupportedWriteSpeedDescriptors: PSafeArray; safecall;
    property Recorder: IDiscRecorder2 read Get_Recorder write Set_Recorder;
    property BufferUnderrunFreeDisabled: WordBool read Get_BufferUnderrunFreeDisabled write Set_BufferUnderrunFreeDisabled;
    property NumberOfExistingTracks: Integer read Get_NumberOfExistingTracks;
    property TotalSectorsOnMedia: Integer read Get_TotalSectorsOnMedia;
    property FreeSectorsOnMedia: Integer read Get_FreeSectorsOnMedia;
    property UsedSectorsOnMedia: Integer read Get_UsedSectorsOnMedia;
    property DoNotFinalizeMedia: WordBool read Get_DoNotFinalizeMedia write Set_DoNotFinalizeMedia;
    property ExpectedTableOfContents: PSafeArray read Get_ExpectedTableOfContents;
    property CurrentPhysicalMediaType: IMAPI_MEDIA_PHYSICAL_TYPE read Get_CurrentPhysicalMediaType;
    property ClientName: WideString read Get_ClientName write Set_ClientName;
    property RequestedWriteSpeed: Integer read Get_RequestedWriteSpeed;
    property RequestedRotationTypeIsPureCAV: WordBool read Get_RequestedRotationTypeIsPureCAV;
    property CurrentWriteSpeed: Integer read Get_CurrentWriteSpeed;
    property CurrentRotationTypeIsPureCAV: WordBool read Get_CurrentRotationTypeIsPureCAV;
    property SupportedWriteSpeeds: PSafeArray read Get_SupportedWriteSpeeds;
    property SupportedWriteSpeedDescriptors: PSafeArray read Get_SupportedWriteSpeedDescriptors;
  end;

// *********************************************************************//
// DispIntf:  IDiscFormat2TrackAtOnceDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {27354154-8F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IDiscFormat2TrackAtOnceDisp = dispinterface
    ['{27354154-8F64-5B0F-8F00-5D77AFBE261E}']
    procedure PrepareMedia; dispid 512;
    procedure AddAudioTrack(const data: IStream); dispid 513;
    procedure CancelAddTrack; dispid 514;
    procedure ReleaseMedia; dispid 515;
    procedure SetWriteSpeed(RequestedSectorsPerSecond: Integer; RotationTypeIsPureCAV: WordBool); dispid 516;
    property Recorder: IDiscRecorder2 dispid 256;
    property BufferUnderrunFreeDisabled: WordBool dispid 258;
    property NumberOfExistingTracks: Integer readonly dispid 259;
    property TotalSectorsOnMedia: Integer readonly dispid 260;
    property FreeSectorsOnMedia: Integer readonly dispid 261;
    property UsedSectorsOnMedia: Integer readonly dispid 262;
    property DoNotFinalizeMedia: WordBool dispid 263;
    property ExpectedTableOfContents: {NOT_OLEAUTO(PSafeArray)}OleVariant readonly dispid 266;
    property CurrentPhysicalMediaType: IMAPI_MEDIA_PHYSICAL_TYPE readonly dispid 267;
    property ClientName: WideString dispid 270;
    property RequestedWriteSpeed: Integer readonly dispid 271;
    property RequestedRotationTypeIsPureCAV: WordBool readonly dispid 272;
    property CurrentWriteSpeed: Integer readonly dispid 273;
    property CurrentRotationTypeIsPureCAV: WordBool readonly dispid 274;
    property SupportedWriteSpeeds: {NOT_OLEAUTO(PSafeArray)}OleVariant readonly dispid 275;
    property SupportedWriteSpeedDescriptors: {NOT_OLEAUTO(PSafeArray)}OleVariant readonly dispid 276;
    function IsRecorderSupported(const Recorder: IDiscRecorder2): WordBool; dispid 2048;
    function IsCurrentMediaSupported(const Recorder: IDiscRecorder2): WordBool; dispid 2049;
    property MediaPhysicallyBlank: WordBool readonly dispid 1792;
    property MediaHeuristicallyBlank: WordBool readonly dispid 1793;
    property SupportedMediaTypes: {NOT_OLEAUTO(PSafeArray)}OleVariant readonly dispid 1794;
  end;

// *********************************************************************//
// Interface: IDiscFormat2RawCD
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {27354155-8F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IDiscFormat2RawCD = interface(IDiscFormat2)
    ['{27354155-8F64-5B0F-8F00-5D77AFBE261E}']
    procedure PrepareMedia; safecall;
    procedure WriteMedia(const data: IStream); safecall;
    procedure WriteMedia2(const data: IStream; streamLeadInSectors: Integer); safecall;
    procedure CancelWrite; safecall;
    procedure ReleaseMedia; safecall;
    procedure SetWriteSpeed(RequestedSectorsPerSecond: Integer; RotationTypeIsPureCAV: WordBool); safecall;
    procedure Set_Recorder(const value: IDiscRecorder2); safecall;
    function Get_Recorder: IDiscRecorder2; safecall;
    procedure Set_BufferUnderrunFreeDisabled(value: WordBool); safecall;
    function Get_BufferUnderrunFreeDisabled: WordBool; safecall;
    function Get_StartOfNextSession: Integer; safecall;
    function Get_LastPossibleStartOfLeadout: Integer; safecall;
    function Get_CurrentPhysicalMediaType: IMAPI_MEDIA_PHYSICAL_TYPE; safecall;
    function Get_SupportedSectorTypes: PSafeArray; safecall;
    procedure Set_RequestedSectorType(value: IMAPI_FORMAT2_RAW_CD_DATA_SECTOR_TYPE); safecall;
    function Get_RequestedSectorType: IMAPI_FORMAT2_RAW_CD_DATA_SECTOR_TYPE; safecall;
    procedure Set_ClientName(const value: WideString); safecall;
    function Get_ClientName: WideString; safecall;
    function Get_RequestedWriteSpeed: Integer; safecall;
    function Get_RequestedRotationTypeIsPureCAV: WordBool; safecall;
    function Get_CurrentWriteSpeed: Integer; safecall;
    function Get_CurrentRotationTypeIsPureCAV: WordBool; safecall;
    function Get_SupportedWriteSpeeds: PSafeArray; safecall;
    function Get_SupportedWriteSpeedDescriptors: PSafeArray; safecall;
    property Recorder: IDiscRecorder2 read Get_Recorder write Set_Recorder;
    property BufferUnderrunFreeDisabled: WordBool read Get_BufferUnderrunFreeDisabled write Set_BufferUnderrunFreeDisabled;
    property StartOfNextSession: Integer read Get_StartOfNextSession;
    property LastPossibleStartOfLeadout: Integer read Get_LastPossibleStartOfLeadout;
    property CurrentPhysicalMediaType: IMAPI_MEDIA_PHYSICAL_TYPE read Get_CurrentPhysicalMediaType;
    property SupportedSectorTypes: PSafeArray read Get_SupportedSectorTypes;
    property RequestedSectorType: IMAPI_FORMAT2_RAW_CD_DATA_SECTOR_TYPE read Get_RequestedSectorType write Set_RequestedSectorType;
    property ClientName: WideString read Get_ClientName write Set_ClientName;
    property RequestedWriteSpeed: Integer read Get_RequestedWriteSpeed;
    property RequestedRotationTypeIsPureCAV: WordBool read Get_RequestedRotationTypeIsPureCAV;
    property CurrentWriteSpeed: Integer read Get_CurrentWriteSpeed;
    property CurrentRotationTypeIsPureCAV: WordBool read Get_CurrentRotationTypeIsPureCAV;
    property SupportedWriteSpeeds: PSafeArray read Get_SupportedWriteSpeeds;
    property SupportedWriteSpeedDescriptors: PSafeArray read Get_SupportedWriteSpeedDescriptors;
  end;

// *********************************************************************//
// DispIntf:  IDiscFormat2RawCDDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {27354155-8F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IDiscFormat2RawCDDisp = dispinterface
    ['{27354155-8F64-5B0F-8F00-5D77AFBE261E}']
    procedure PrepareMedia; dispid 512;
    procedure WriteMedia(const data: IStream); dispid 513;
    procedure WriteMedia2(const data: IStream; streamLeadInSectors: Integer); dispid 514;
    procedure CancelWrite; dispid 515;
    procedure ReleaseMedia; dispid 516;
    procedure SetWriteSpeed(RequestedSectorsPerSecond: Integer; RotationTypeIsPureCAV: WordBool); dispid 517;
    property Recorder: IDiscRecorder2 dispid 256;
    property BufferUnderrunFreeDisabled: WordBool dispid 258;
    property StartOfNextSession: Integer readonly dispid 259;
    property LastPossibleStartOfLeadout: Integer readonly dispid 260;
    property CurrentPhysicalMediaType: IMAPI_MEDIA_PHYSICAL_TYPE readonly dispid 261;
    property SupportedSectorTypes: {NOT_OLEAUTO(PSafeArray)}OleVariant readonly dispid 264;
    property RequestedSectorType: IMAPI_FORMAT2_RAW_CD_DATA_SECTOR_TYPE dispid 265;
    property ClientName: WideString dispid 266;
    property RequestedWriteSpeed: Integer readonly dispid 267;
    property RequestedRotationTypeIsPureCAV: WordBool readonly dispid 268;
    property CurrentWriteSpeed: Integer readonly dispid 269;
    property CurrentRotationTypeIsPureCAV: WordBool readonly dispid 270;
    property SupportedWriteSpeeds: {NOT_OLEAUTO(PSafeArray)}OleVariant readonly dispid 271;
    property SupportedWriteSpeedDescriptors: {NOT_OLEAUTO(PSafeArray)}OleVariant readonly dispid 272;
    function IsRecorderSupported(const Recorder: IDiscRecorder2): WordBool; dispid 2048;
    function IsCurrentMediaSupported(const Recorder: IDiscRecorder2): WordBool; dispid 2049;
    property MediaPhysicallyBlank: WordBool readonly dispid 1792;
    property MediaHeuristicallyBlank: WordBool readonly dispid 1793;
    property SupportedMediaTypes: {NOT_OLEAUTO(PSafeArray)}OleVariant readonly dispid 1794;
  end;

// *********************************************************************//
// Interface: IStreamPseudoRandomBased
// Flags:     (0)
// GUID:      {27354145-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IStreamPseudoRandomBased = interface(IStream)
    ['{27354145-7F64-5B0F-8F00-5D77AFBE261E}']
    function put_Seed(value: LongWord): HResult; stdcall;
    function get_Seed(out value: LongWord): HResult; stdcall;
    function put_ExtendedSeed(var values: LongWord; eCount: LongWord): HResult; stdcall;
    function get_ExtendedSeed(out values: PUINT1; out eCount: LongWord): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IStreamConcatenate
// Flags:     (0)
// GUID:      {27354146-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IStreamConcatenate = interface(IStream)
    ['{27354146-7F64-5B0F-8F00-5D77AFBE261E}']
    function Initialize(const stream1: IStream; const stream2: IStream): HResult; stdcall;
    function Initialize2(var streams: IStream; streamCount: LongWord): HResult; stdcall;
    function Append(const stream: IStream): HResult; stdcall;
    function Append2(var streams: IStream; streamCount: LongWord): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IStreamInterleave
// Flags:     (0)
// GUID:      {27354147-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IStreamInterleave = interface(IStream)
    ['{27354147-7F64-5B0F-8F00-5D77AFBE261E}']
    function Initialize(var streams: IStream; var interleaveSizes: LongWord; streamCount: LongWord): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IMultisession
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {27354150-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IMultisession = interface(IDispatch)
    ['{27354150-7F64-5B0F-8F00-5D77AFBE261E}']
    function Get_IsSupportedOnCurrentMediaState: WordBool; safecall;
    procedure Set_InUse(value: WordBool); safecall;
    function Get_InUse: WordBool; safecall;
    function Get_ImportRecorder: IDiscRecorder2; safecall;
    property IsSupportedOnCurrentMediaState: WordBool read Get_IsSupportedOnCurrentMediaState;
    property InUse: WordBool read Get_InUse write Set_InUse;
    property ImportRecorder: IDiscRecorder2 read Get_ImportRecorder;
  end;

// *********************************************************************//
// DispIntf:  IMultisessionDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {27354150-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IMultisessionDisp = dispinterface
    ['{27354150-7F64-5B0F-8F00-5D77AFBE261E}']
    property IsSupportedOnCurrentMediaState: WordBool readonly dispid 256;
    property InUse: WordBool dispid 257;
    property ImportRecorder: IDiscRecorder2 readonly dispid 258;
  end;

// *********************************************************************//
// Interface: IMultisessionSequential
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {27354151-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IMultisessionSequential = interface(IMultisession)
    ['{27354151-7F64-5B0F-8F00-5D77AFBE261E}']
    function Get_IsFirstDataSession: WordBool; safecall;
    function Get_StartAddressOfPreviousSession: Integer; safecall;
    function Get_LastWrittenAddressOfPreviousSession: Integer; safecall;
    function Get_NextWritableAddress: Integer; safecall;
    function Get_FreeSectorsOnMedia: Integer; safecall;
    property IsFirstDataSession: WordBool read Get_IsFirstDataSession;
    property StartAddressOfPreviousSession: Integer read Get_StartAddressOfPreviousSession;
    property LastWrittenAddressOfPreviousSession: Integer read Get_LastWrittenAddressOfPreviousSession;
    property NextWritableAddress: Integer read Get_NextWritableAddress;
    property FreeSectorsOnMedia: Integer read Get_FreeSectorsOnMedia;
  end;

// *********************************************************************//
// DispIntf:  IMultisessionSequentialDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {27354151-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IMultisessionSequentialDisp = dispinterface
    ['{27354151-7F64-5B0F-8F00-5D77AFBE261E}']
    property IsFirstDataSession: WordBool readonly dispid 512;
    property StartAddressOfPreviousSession: Integer readonly dispid 513;
    property LastWrittenAddressOfPreviousSession: Integer readonly dispid 514;
    property NextWritableAddress: Integer readonly dispid 515;
    property FreeSectorsOnMedia: Integer readonly dispid 516;
    property IsSupportedOnCurrentMediaState: WordBool readonly dispid 256;
    property InUse: WordBool dispid 257;
    property ImportRecorder: IDiscRecorder2 readonly dispid 258;
  end;

// *********************************************************************//
// Interface: IMultisessionSequential2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B507CA22-2204-11DD-966A-001AA01BBC58}
// *********************************************************************//
  IMultisessionSequential2 = interface(IMultisessionSequential)
    ['{B507CA22-2204-11DD-966A-001AA01BBC58}']
    function Get_WriteUnitSize: Integer; safecall;
    property WriteUnitSize: Integer read Get_WriteUnitSize;
  end;

// *********************************************************************//
// DispIntf:  IMultisessionSequential2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B507CA22-2204-11DD-966A-001AA01BBC58}
// *********************************************************************//
  IMultisessionSequential2Disp = dispinterface
    ['{B507CA22-2204-11DD-966A-001AA01BBC58}']
    property WriteUnitSize: Integer readonly dispid 517;
    property IsFirstDataSession: WordBool readonly dispid 512;
    property StartAddressOfPreviousSession: Integer readonly dispid 513;
    property LastWrittenAddressOfPreviousSession: Integer readonly dispid 514;
    property NextWritableAddress: Integer readonly dispid 515;
    property FreeSectorsOnMedia: Integer readonly dispid 516;
    property IsSupportedOnCurrentMediaState: WordBool readonly dispid 256;
    property InUse: WordBool dispid 257;
    property ImportRecorder: IDiscRecorder2 readonly dispid 258;
  end;

// *********************************************************************//
// Interface: IMultisessionRandomWrite
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B507CA23-2204-11DD-966A-001AA01BBC58}
// *********************************************************************//
  IMultisessionRandomWrite = interface(IMultisession)
    ['{B507CA23-2204-11DD-966A-001AA01BBC58}']
    function Get_WriteUnitSize: Integer; safecall;
    function Get_LastWrittenAddress: Integer; safecall;
    function Get_TotalSectorsOnMedia: Integer; safecall;
    property WriteUnitSize: Integer read Get_WriteUnitSize;
    property LastWrittenAddress: Integer read Get_LastWrittenAddress;
    property TotalSectorsOnMedia: Integer read Get_TotalSectorsOnMedia;
  end;

// *********************************************************************//
// DispIntf:  IMultisessionRandomWriteDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B507CA23-2204-11DD-966A-001AA01BBC58}
// *********************************************************************//
  IMultisessionRandomWriteDisp = dispinterface
    ['{B507CA23-2204-11DD-966A-001AA01BBC58}']
    property WriteUnitSize: Integer readonly dispid 517;
    property LastWrittenAddress: Integer readonly dispid 518;
    property TotalSectorsOnMedia: Integer readonly dispid 519;
    property IsSupportedOnCurrentMediaState: WordBool readonly dispid 256;
    property InUse: WordBool dispid 257;
    property ImportRecorder: IDiscRecorder2 readonly dispid 258;
  end;

// *********************************************************************//
// The Class CoMsftDiscMaster2 provides a Create and CreateRemote method to          
// create instances of the default interface IDiscMaster2 exposed by              
// the CoClass MsftDiscMaster2. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoMsftDiscMaster2 = class
    class function Create: IDiscMaster2;
    class function CreateRemote(const MachineName: string): IDiscMaster2;
  end;

  TMsftDiscMaster2NotifyDeviceAdded = procedure(ASender: TObject; const object_: IDispatch; 
                                                                  const uniqueId: WideString) of object;
  TMsftDiscMaster2NotifyDeviceRemoved = procedure(ASender: TObject; const object_: IDispatch; 
                                                                    const uniqueId: WideString) of object;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TMsftDiscMaster2
// Help String      : Microsoft IMAPIv2 Disc Master
// Default Interface: IDiscMaster2
// Def. Intf. DISP? : No
// Event   Interface: DDiscMaster2Events
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TMsftDiscMaster2 = class(TOleServer)
  private
    FOnNotifyDeviceAdded: TMsftDiscMaster2NotifyDeviceAdded;
    FOnNotifyDeviceRemoved: TMsftDiscMaster2NotifyDeviceRemoved;
    FIntf: IDiscMaster2;
    function GetDefaultInterface: IDiscMaster2;
  protected
    procedure InitServerData; override;
    procedure InvokeEvent(DispID: TDispID; var Params: TVariantArray); override;
    function Get_Item(index: Integer): WideString;
    function Get_Count: Integer;
    function Get_IsSupportedEnvironment: WordBool;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IDiscMaster2);
    procedure Disconnect; override;
    property DefaultInterface: IDiscMaster2 read GetDefaultInterface;
    property Item[index: Integer]: WideString read Get_Item; default;
    property Count: Integer read Get_Count;
    property IsSupportedEnvironment: WordBool read Get_IsSupportedEnvironment;
  published
    property OnNotifyDeviceAdded: TMsftDiscMaster2NotifyDeviceAdded read FOnNotifyDeviceAdded write FOnNotifyDeviceAdded;
    property OnNotifyDeviceRemoved: TMsftDiscMaster2NotifyDeviceRemoved read FOnNotifyDeviceRemoved write FOnNotifyDeviceRemoved;
  end;

// *********************************************************************//
// The Class CoMsftDiscRecorder2 provides a Create and CreateRemote method to          
// create instances of the default interface IDiscRecorder2 exposed by              
// the CoClass MsftDiscRecorder2. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoMsftDiscRecorder2 = class
    class function Create: IDiscRecorder2;
    class function CreateRemote(const MachineName: string): IDiscRecorder2;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TMsftDiscRecorder2
// Help String      : Microsoft IMAPIv2 Disc Recorder
// Default Interface: IDiscRecorder2
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TMsftDiscRecorder2 = class(TOleServer)
  private
    FIntf: IDiscRecorder2;
    function GetDefaultInterface: IDiscRecorder2;
  protected
    procedure InitServerData; override;
    function Get_ActiveDiscRecorder: WideString;
    function Get_VendorId: WideString;
    function Get_ProductId: WideString;
    function Get_ProductRevision: WideString;
    function Get_VolumeName: WideString;
    function Get_VolumePathNames: PSafeArray;
    function Get_DeviceCanLoadMedia: WordBool;
    function Get_LegacyDeviceNumber: Integer;
    function Get_SupportedFeaturePages: PSafeArray;
    function Get_CurrentFeaturePages: PSafeArray;
    function Get_SupportedProfiles: PSafeArray;
    function Get_CurrentProfiles: PSafeArray;
    function Get_SupportedModePages: PSafeArray;
    function Get_ExclusiveAccessOwner: WideString;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IDiscRecorder2);
    procedure Disconnect; override;
    procedure EjectMedia;
    procedure CloseTray;
    procedure AcquireExclusiveAccess(force: WordBool; const __MIDL__IDiscRecorder20000: WideString);
    procedure ReleaseExclusiveAccess;
    procedure DisableMcn;
    procedure EnableMcn;
    procedure InitializeDiscRecorder(const recorderUniqueId: WideString);
    property DefaultInterface: IDiscRecorder2 read GetDefaultInterface;
    property ActiveDiscRecorder: WideString read Get_ActiveDiscRecorder;
    property VendorId: WideString read Get_VendorId;
    property ProductId: WideString read Get_ProductId;
    property ProductRevision: WideString read Get_ProductRevision;
    property VolumeName: WideString read Get_VolumeName;
    property VolumePathNames: PSafeArray read Get_VolumePathNames;
    property DeviceCanLoadMedia: WordBool read Get_DeviceCanLoadMedia;
    property LegacyDeviceNumber: Integer read Get_LegacyDeviceNumber;
    property SupportedFeaturePages: PSafeArray read Get_SupportedFeaturePages;
    property CurrentFeaturePages: PSafeArray read Get_CurrentFeaturePages;
    property SupportedProfiles: PSafeArray read Get_SupportedProfiles;
    property CurrentProfiles: PSafeArray read Get_CurrentProfiles;
    property SupportedModePages: PSafeArray read Get_SupportedModePages;
    property ExclusiveAccessOwner: WideString read Get_ExclusiveAccessOwner;
  published
  end;

// *********************************************************************//
// The Class CoMsftWriteEngine2 provides a Create and CreateRemote method to          
// create instances of the default interface IWriteEngine2 exposed by              
// the CoClass MsftWriteEngine2. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoMsftWriteEngine2 = class
    class function Create: IWriteEngine2;
    class function CreateRemote(const MachineName: string): IWriteEngine2;
  end;

  TMsftWriteEngine2Update = procedure(ASender: TObject; const object_: IDispatch; 
                                                        const progress: IDispatch) of object;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TMsftWriteEngine2
// Help String      : Microsoft IMAPIv2 CD Write Engine
// Default Interface: IWriteEngine2
// Def. Intf. DISP? : No
// Event   Interface: DWriteEngine2Events
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TMsftWriteEngine2 = class(TOleServer)
  private
    FOnUpdate: TMsftWriteEngine2Update;
    FIntf: IWriteEngine2;
    function GetDefaultInterface: IWriteEngine2;
  protected
    procedure InitServerData; override;
    procedure InvokeEvent(DispID: TDispID; var Params: TVariantArray); override;
    procedure Set_Recorder(const value: IDiscRecorder2Ex);
    function Get_Recorder: IDiscRecorder2Ex;
    procedure Set_UseStreamingWrite12(value: WordBool);
    function Get_UseStreamingWrite12: WordBool;
    procedure Set_StartingSectorsPerSecond(value: Integer);
    function Get_StartingSectorsPerSecond: Integer;
    procedure Set_EndingSectorsPerSecond(value: Integer);
    function Get_EndingSectorsPerSecond: Integer;
    procedure Set_BytesPerSector(value: Integer);
    function Get_BytesPerSector: Integer;
    function Get_WriteInProgress: WordBool;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IWriteEngine2);
    procedure Disconnect; override;
    procedure WriteSection(const data: IStream; startingBlockAddress: Integer; 
                           numberOfBlocks: Integer);
    procedure CancelWrite;
    property DefaultInterface: IWriteEngine2 read GetDefaultInterface;
    property WriteInProgress: WordBool read Get_WriteInProgress;
    property Recorder: IDiscRecorder2Ex read Get_Recorder write Set_Recorder;
    property UseStreamingWrite12: WordBool read Get_UseStreamingWrite12 write Set_UseStreamingWrite12;
    property StartingSectorsPerSecond: Integer read Get_StartingSectorsPerSecond write Set_StartingSectorsPerSecond;
    property EndingSectorsPerSecond: Integer read Get_EndingSectorsPerSecond write Set_EndingSectorsPerSecond;
    property BytesPerSector: Integer read Get_BytesPerSector write Set_BytesPerSector;
  published
    property OnUpdate: TMsftWriteEngine2Update read FOnUpdate write FOnUpdate;
  end;

// *********************************************************************//
// The Class CoMsftDiscFormat2Erase provides a Create and CreateRemote method to          
// create instances of the default interface IDiscFormat2Erase exposed by              
// the CoClass MsftDiscFormat2Erase. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoMsftDiscFormat2Erase = class
    class function Create: IDiscFormat2Erase;
    class function CreateRemote(const MachineName: string): IDiscFormat2Erase;
  end;

  TMsftDiscFormat2EraseUpdate = procedure(ASender: TObject; const object_: IDispatch; 
                                                            elapsedSeconds: Integer; 
                                                            estimatedTotalSeconds: Integer) of object;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TMsftDiscFormat2Erase
// Help String      : Microsoft IMAPIv2 Media Erase/Blank
// Default Interface: IDiscFormat2Erase
// Def. Intf. DISP? : No
// Event   Interface: DDiscFormat2EraseEvents
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TMsftDiscFormat2Erase = class(TOleServer)
  private
    FOnUpdate: TMsftDiscFormat2EraseUpdate;
    FIntf: IDiscFormat2Erase;
    function GetDefaultInterface: IDiscFormat2Erase;
  protected
    procedure InitServerData; override;
    procedure InvokeEvent(DispID: TDispID; var Params: TVariantArray); override;
    procedure Set_Recorder(const value: IDiscRecorder2);
    function Get_Recorder: IDiscRecorder2;
    procedure Set_FullErase(value: WordBool);
    function Get_FullErase: WordBool;
    function Get_CurrentPhysicalMediaType: IMAPI_MEDIA_PHYSICAL_TYPE;
    procedure Set_ClientName(const value: WideString);
    function Get_ClientName: WideString;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IDiscFormat2Erase);
    procedure Disconnect; override;
    procedure EraseMedia;
    property DefaultInterface: IDiscFormat2Erase read GetDefaultInterface;
    property CurrentPhysicalMediaType: IMAPI_MEDIA_PHYSICAL_TYPE read Get_CurrentPhysicalMediaType;
    property Recorder: IDiscRecorder2 read Get_Recorder write Set_Recorder;
    property FullErase: WordBool read Get_FullErase write Set_FullErase;
    property ClientName: WideString read Get_ClientName write Set_ClientName;
  published
    property OnUpdate: TMsftDiscFormat2EraseUpdate read FOnUpdate write FOnUpdate;
  end;

// *********************************************************************//
// The Class CoMsftDiscFormat2Data provides a Create and CreateRemote method to          
// create instances of the default interface IDiscFormat2Data exposed by              
// the CoClass MsftDiscFormat2Data. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoMsftDiscFormat2Data = class
    class function Create: IDiscFormat2Data;
    class function CreateRemote(const MachineName: string): IDiscFormat2Data;
  end;

  TMsftDiscFormat2DataUpdate = procedure(ASender: TObject; const object_: IDispatch; 
                                                           const progress: IDispatch) of object;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TMsftDiscFormat2Data
// Help String      : Microsoft IMAPIv2 Data Writer
// Default Interface: IDiscFormat2Data
// Def. Intf. DISP? : No
// Event   Interface: DDiscFormat2DataEvents
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TMsftDiscFormat2Data = class(TOleServer)
  private
    FOnUpdate: TMsftDiscFormat2DataUpdate;
    FIntf: IDiscFormat2Data;
    function GetDefaultInterface: IDiscFormat2Data;
  protected
    procedure InitServerData; override;
    procedure InvokeEvent(DispID: TDispID; var Params: TVariantArray); override;
    procedure Set_Recorder(const value: IDiscRecorder2);
    function Get_Recorder: IDiscRecorder2;
    procedure Set_BufferUnderrunFreeDisabled(value: WordBool);
    function Get_BufferUnderrunFreeDisabled: WordBool;
    procedure Set_PostgapAlreadyInImage(value: WordBool);
    function Get_PostgapAlreadyInImage: WordBool;
    function Get_CurrentMediaStatus: IMAPI_FORMAT2_DATA_MEDIA_STATE;
    function Get_WriteProtectStatus: IMAPI_MEDIA_WRITE_PROTECT_STATE;
    function Get_TotalSectorsOnMedia: Integer;
    function Get_FreeSectorsOnMedia: Integer;
    function Get_NextWritableAddress: Integer;
    function Get_StartAddressOfPreviousSession: Integer;
    function Get_LastWrittenAddressOfPreviousSession: Integer;
    procedure Set_ForceMediaToBeClosed(value: WordBool);
    function Get_ForceMediaToBeClosed: WordBool;
    procedure Set_DisableConsumerDvdCompatibilityMode(value: WordBool);
    function Get_DisableConsumerDvdCompatibilityMode: WordBool;
    function Get_CurrentPhysicalMediaType: IMAPI_MEDIA_PHYSICAL_TYPE;
    procedure Set_ClientName(const value: WideString);
    function Get_ClientName: WideString;
    function Get_RequestedWriteSpeed: Integer;
    function Get_RequestedRotationTypeIsPureCAV: WordBool;
    function Get_CurrentWriteSpeed: Integer;
    function Get_CurrentRotationTypeIsPureCAV: WordBool;
    function Get_SupportedWriteSpeeds: PSafeArray;
    function Get_SupportedWriteSpeedDescriptors: PSafeArray;
    procedure Set_ForceOverwrite(value: WordBool);
    function Get_ForceOverwrite: WordBool;
    function Get_MultisessionInterfaces: PSafeArray;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IDiscFormat2Data);
    procedure Disconnect; override;
    procedure Write(const data: IStream);
    procedure CancelWrite;
    procedure SetWriteSpeed(RequestedSectorsPerSecond: Integer; RotationTypeIsPureCAV: WordBool);
    property DefaultInterface: IDiscFormat2Data read GetDefaultInterface;
    property CurrentMediaStatus: IMAPI_FORMAT2_DATA_MEDIA_STATE read Get_CurrentMediaStatus;
    property WriteProtectStatus: IMAPI_MEDIA_WRITE_PROTECT_STATE read Get_WriteProtectStatus;
    property TotalSectorsOnMedia: Integer read Get_TotalSectorsOnMedia;
    property FreeSectorsOnMedia: Integer read Get_FreeSectorsOnMedia;
    property NextWritableAddress: Integer read Get_NextWritableAddress;
    property StartAddressOfPreviousSession: Integer read Get_StartAddressOfPreviousSession;
    property LastWrittenAddressOfPreviousSession: Integer read Get_LastWrittenAddressOfPreviousSession;
    property CurrentPhysicalMediaType: IMAPI_MEDIA_PHYSICAL_TYPE read Get_CurrentPhysicalMediaType;
    property RequestedWriteSpeed: Integer read Get_RequestedWriteSpeed;
    property RequestedRotationTypeIsPureCAV: WordBool read Get_RequestedRotationTypeIsPureCAV;
    property CurrentWriteSpeed: Integer read Get_CurrentWriteSpeed;
    property CurrentRotationTypeIsPureCAV: WordBool read Get_CurrentRotationTypeIsPureCAV;
    property SupportedWriteSpeeds: PSafeArray read Get_SupportedWriteSpeeds;
    property SupportedWriteSpeedDescriptors: PSafeArray read Get_SupportedWriteSpeedDescriptors;
    property MultisessionInterfaces: PSafeArray read Get_MultisessionInterfaces;
    property Recorder: IDiscRecorder2 read Get_Recorder write Set_Recorder;
    property BufferUnderrunFreeDisabled: WordBool read Get_BufferUnderrunFreeDisabled write Set_BufferUnderrunFreeDisabled;
    property PostgapAlreadyInImage: WordBool read Get_PostgapAlreadyInImage write Set_PostgapAlreadyInImage;
    property ForceMediaToBeClosed: WordBool read Get_ForceMediaToBeClosed write Set_ForceMediaToBeClosed;
    property DisableConsumerDvdCompatibilityMode: WordBool read Get_DisableConsumerDvdCompatibilityMode write Set_DisableConsumerDvdCompatibilityMode;
    property ClientName: WideString read Get_ClientName write Set_ClientName;
    property ForceOverwrite: WordBool read Get_ForceOverwrite write Set_ForceOverwrite;
  published
    property OnUpdate: TMsftDiscFormat2DataUpdate read FOnUpdate write FOnUpdate;
  end;

// *********************************************************************//
// The Class CoMsftDiscFormat2TrackAtOnce provides a Create and CreateRemote method to          
// create instances of the default interface IDiscFormat2TrackAtOnce exposed by              
// the CoClass MsftDiscFormat2TrackAtOnce. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoMsftDiscFormat2TrackAtOnce = class
    class function Create: IDiscFormat2TrackAtOnce;
    class function CreateRemote(const MachineName: string): IDiscFormat2TrackAtOnce;
  end;

  TMsftDiscFormat2TrackAtOnceUpdate = procedure(ASender: TObject; const object_: IDispatch; 
                                                                  const progress: IDispatch) of object;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TMsftDiscFormat2TrackAtOnce
// Help String      : Microsoft IMAPIv2 Track-at-Once Audio CD Writer
// Default Interface: IDiscFormat2TrackAtOnce
// Def. Intf. DISP? : No
// Event   Interface: DDiscFormat2TrackAtOnceEvents
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TMsftDiscFormat2TrackAtOnce = class(TOleServer)
  private
    FOnUpdate: TMsftDiscFormat2TrackAtOnceUpdate;
    FIntf: IDiscFormat2TrackAtOnce;
    function GetDefaultInterface: IDiscFormat2TrackAtOnce;
  protected
    procedure InitServerData; override;
    procedure InvokeEvent(DispID: TDispID; var Params: TVariantArray); override;
    procedure Set_Recorder(const value: IDiscRecorder2);
    function Get_Recorder: IDiscRecorder2;
    procedure Set_BufferUnderrunFreeDisabled(value: WordBool);
    function Get_BufferUnderrunFreeDisabled: WordBool;
    function Get_NumberOfExistingTracks: Integer;
    function Get_TotalSectorsOnMedia: Integer;
    function Get_FreeSectorsOnMedia: Integer;
    function Get_UsedSectorsOnMedia: Integer;
    procedure Set_DoNotFinalizeMedia(value: WordBool);
    function Get_DoNotFinalizeMedia: WordBool;
    function Get_ExpectedTableOfContents: PSafeArray;
    function Get_CurrentPhysicalMediaType: IMAPI_MEDIA_PHYSICAL_TYPE;
    procedure Set_ClientName(const value: WideString);
    function Get_ClientName: WideString;
    function Get_RequestedWriteSpeed: Integer;
    function Get_RequestedRotationTypeIsPureCAV: WordBool;
    function Get_CurrentWriteSpeed: Integer;
    function Get_CurrentRotationTypeIsPureCAV: WordBool;
    function Get_SupportedWriteSpeeds: PSafeArray;
    function Get_SupportedWriteSpeedDescriptors: PSafeArray;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IDiscFormat2TrackAtOnce);
    procedure Disconnect; override;
    procedure PrepareMedia;
    procedure AddAudioTrack(const data: IStream);
    procedure CancelAddTrack;
    procedure ReleaseMedia;
    procedure SetWriteSpeed(RequestedSectorsPerSecond: Integer; RotationTypeIsPureCAV: WordBool);
    property DefaultInterface: IDiscFormat2TrackAtOnce read GetDefaultInterface;
    property NumberOfExistingTracks: Integer read Get_NumberOfExistingTracks;
    property TotalSectorsOnMedia: Integer read Get_TotalSectorsOnMedia;
    property FreeSectorsOnMedia: Integer read Get_FreeSectorsOnMedia;
    property UsedSectorsOnMedia: Integer read Get_UsedSectorsOnMedia;
    property ExpectedTableOfContents: PSafeArray read Get_ExpectedTableOfContents;
    property CurrentPhysicalMediaType: IMAPI_MEDIA_PHYSICAL_TYPE read Get_CurrentPhysicalMediaType;
    property RequestedWriteSpeed: Integer read Get_RequestedWriteSpeed;
    property RequestedRotationTypeIsPureCAV: WordBool read Get_RequestedRotationTypeIsPureCAV;
    property CurrentWriteSpeed: Integer read Get_CurrentWriteSpeed;
    property CurrentRotationTypeIsPureCAV: WordBool read Get_CurrentRotationTypeIsPureCAV;
    property SupportedWriteSpeeds: PSafeArray read Get_SupportedWriteSpeeds;
    property SupportedWriteSpeedDescriptors: PSafeArray read Get_SupportedWriteSpeedDescriptors;
    property Recorder: IDiscRecorder2 read Get_Recorder write Set_Recorder;
    property BufferUnderrunFreeDisabled: WordBool read Get_BufferUnderrunFreeDisabled write Set_BufferUnderrunFreeDisabled;
    property DoNotFinalizeMedia: WordBool read Get_DoNotFinalizeMedia write Set_DoNotFinalizeMedia;
    property ClientName: WideString read Get_ClientName write Set_ClientName;
  published
    property OnUpdate: TMsftDiscFormat2TrackAtOnceUpdate read FOnUpdate write FOnUpdate;
  end;

// *********************************************************************//
// The Class CoMsftDiscFormat2RawCD provides a Create and CreateRemote method to          
// create instances of the default interface IDiscFormat2RawCD exposed by              
// the CoClass MsftDiscFormat2RawCD. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoMsftDiscFormat2RawCD = class
    class function Create: IDiscFormat2RawCD;
    class function CreateRemote(const MachineName: string): IDiscFormat2RawCD;
  end;

  TMsftDiscFormat2RawCDUpdate = procedure(ASender: TObject; const object_: IDispatch; 
                                                            const progress: IDispatch) of object;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TMsftDiscFormat2RawCD
// Help String      : Microsoft IMAPIv2 Disc-at-Once RAW CD Image Writer
// Default Interface: IDiscFormat2RawCD
// Def. Intf. DISP? : No
// Event   Interface: DDiscFormat2RawCDEvents
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TMsftDiscFormat2RawCD = class(TOleServer)
  private
    FOnUpdate: TMsftDiscFormat2RawCDUpdate;
    FIntf: IDiscFormat2RawCD;
    function GetDefaultInterface: IDiscFormat2RawCD;
  protected
    procedure InitServerData; override;
    procedure InvokeEvent(DispID: TDispID; var Params: TVariantArray); override;
    procedure Set_Recorder(const value: IDiscRecorder2);
    function Get_Recorder: IDiscRecorder2;
    procedure Set_BufferUnderrunFreeDisabled(value: WordBool);
    function Get_BufferUnderrunFreeDisabled: WordBool;
    function Get_StartOfNextSession: Integer;
    function Get_LastPossibleStartOfLeadout: Integer;
    function Get_CurrentPhysicalMediaType: IMAPI_MEDIA_PHYSICAL_TYPE;
    function Get_SupportedSectorTypes: PSafeArray;
    procedure Set_RequestedSectorType(value: IMAPI_FORMAT2_RAW_CD_DATA_SECTOR_TYPE);
    function Get_RequestedSectorType: IMAPI_FORMAT2_RAW_CD_DATA_SECTOR_TYPE;
    procedure Set_ClientName(const value: WideString);
    function Get_ClientName: WideString;
    function Get_RequestedWriteSpeed: Integer;
    function Get_RequestedRotationTypeIsPureCAV: WordBool;
    function Get_CurrentWriteSpeed: Integer;
    function Get_CurrentRotationTypeIsPureCAV: WordBool;
    function Get_SupportedWriteSpeeds: PSafeArray;
    function Get_SupportedWriteSpeedDescriptors: PSafeArray;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IDiscFormat2RawCD);
    procedure Disconnect; override;
    procedure PrepareMedia;
    procedure WriteMedia(const data: IStream);
    procedure WriteMedia2(const data: IStream; streamLeadInSectors: Integer);
    procedure CancelWrite;
    procedure ReleaseMedia;
    procedure SetWriteSpeed(RequestedSectorsPerSecond: Integer; RotationTypeIsPureCAV: WordBool);
    property DefaultInterface: IDiscFormat2RawCD read GetDefaultInterface;
    property StartOfNextSession: Integer read Get_StartOfNextSession;
    property LastPossibleStartOfLeadout: Integer read Get_LastPossibleStartOfLeadout;
    property CurrentPhysicalMediaType: IMAPI_MEDIA_PHYSICAL_TYPE read Get_CurrentPhysicalMediaType;
    property SupportedSectorTypes: PSafeArray read Get_SupportedSectorTypes;
    property RequestedWriteSpeed: Integer read Get_RequestedWriteSpeed;
    property RequestedRotationTypeIsPureCAV: WordBool read Get_RequestedRotationTypeIsPureCAV;
    property CurrentWriteSpeed: Integer read Get_CurrentWriteSpeed;
    property CurrentRotationTypeIsPureCAV: WordBool read Get_CurrentRotationTypeIsPureCAV;
    property SupportedWriteSpeeds: PSafeArray read Get_SupportedWriteSpeeds;
    property SupportedWriteSpeedDescriptors: PSafeArray read Get_SupportedWriteSpeedDescriptors;
    property Recorder: IDiscRecorder2 read Get_Recorder write Set_Recorder;
    property BufferUnderrunFreeDisabled: WordBool read Get_BufferUnderrunFreeDisabled write Set_BufferUnderrunFreeDisabled;
    property RequestedSectorType: IMAPI_FORMAT2_RAW_CD_DATA_SECTOR_TYPE read Get_RequestedSectorType write Set_RequestedSectorType;
    property ClientName: WideString read Get_ClientName write Set_ClientName;
  published
    property OnUpdate: TMsftDiscFormat2RawCDUpdate read FOnUpdate write FOnUpdate;
  end;

// *********************************************************************//
// The Class CoMsftStreamZero provides a Create and CreateRemote method to          
// create instances of the default interface IStream exposed by              
// the CoClass MsftStreamZero. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoMsftStreamZero = class
    class function Create: IStream;
    class function CreateRemote(const MachineName: string): IStream;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TMsftStreamZero
// Help String      : Microsoft IMAPIv2 /dev/zero Stream 
// Default Interface: IStream
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TMsftStreamZero = class(TOleServer)
  private
    FIntf: IStream;
    function GetDefaultInterface: IStream;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IStream);
    procedure Disconnect; override;
    function RemoteRead(out pv: Byte; cb: LongWord; out pcbRead: LongWord): HResult;
    function RemoteWrite(var pv: Byte; cb: LongWord; out pcbWritten: LongWord): HResult;
    function RemoteSeek(dlibMove: _LARGE_INTEGER; dwOrigin: LongWord; 
                        out plibNewPosition: _ULARGE_INTEGER): HResult;
    function SetSize(libNewSize: _ULARGE_INTEGER): HResult;
    function RemoteCopyTo(const pstm: IStream; cb: _ULARGE_INTEGER; out pcbRead: _ULARGE_INTEGER; 
                          out pcbWritten: _ULARGE_INTEGER): HResult;
    function Commit(grfCommitFlags: LongWord): HResult;
    function Revert: HResult;
    function LockRegion(libOffset: _ULARGE_INTEGER; cb: _ULARGE_INTEGER; dwLockType: LongWord): HResult;
    function UnlockRegion(libOffset: _ULARGE_INTEGER; cb: _ULARGE_INTEGER; dwLockType: LongWord): HResult;
    function Stat(out pstatstg: tagSTATSTG; grfStatFlag: LongWord): HResult;
    function Clone(out ppstm: IStream): HResult;
    property DefaultInterface: IStream read GetDefaultInterface;
  published
  end;

// *********************************************************************//
// The Class CoMsftStreamPrng001 provides a Create and CreateRemote method to          
// create instances of the default interface IStreamPseudoRandomBased exposed by              
// the CoClass MsftStreamPrng001. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoMsftStreamPrng001 = class
    class function Create: IStreamPseudoRandomBased;
    class function CreateRemote(const MachineName: string): IStreamPseudoRandomBased;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TMsftStreamPrng001
// Help String      : Microsoft IMAPIv2 PRNG based Stream (LCG: 0x19660D, 0x3C6EF35F)
// Default Interface: IStreamPseudoRandomBased
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TMsftStreamPrng001 = class(TOleServer)
  private
    FIntf: IStreamPseudoRandomBased;
    function GetDefaultInterface: IStreamPseudoRandomBased;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IStreamPseudoRandomBased);
    procedure Disconnect; override;
    function RemoteRead(out pv: Byte; cb: LongWord; out pcbRead: LongWord): HResult;
    function RemoteWrite(var pv: Byte; cb: LongWord; out pcbWritten: LongWord): HResult;
    function RemoteSeek(dlibMove: _LARGE_INTEGER; dwOrigin: LongWord; 
                        out plibNewPosition: _ULARGE_INTEGER): HResult;
    function SetSize(libNewSize: _ULARGE_INTEGER): HResult;
    function RemoteCopyTo(const pstm: IStream; cb: _ULARGE_INTEGER; out pcbRead: _ULARGE_INTEGER; 
                          out pcbWritten: _ULARGE_INTEGER): HResult;
    function Commit(grfCommitFlags: LongWord): HResult;
    function Revert: HResult;
    function LockRegion(libOffset: _ULARGE_INTEGER; cb: _ULARGE_INTEGER; dwLockType: LongWord): HResult;
    function UnlockRegion(libOffset: _ULARGE_INTEGER; cb: _ULARGE_INTEGER; dwLockType: LongWord): HResult;
    function Stat(out pstatstg: tagSTATSTG; grfStatFlag: LongWord): HResult;
    function Clone(out ppstm: IStream): HResult;
    function put_Seed(value: LongWord): HResult;
    function get_Seed(out value: LongWord): HResult;
    function put_ExtendedSeed(var values: LongWord; eCount: LongWord): HResult;
    function get_ExtendedSeed(out values: PUINT1; out eCount: LongWord): HResult;
    property DefaultInterface: IStreamPseudoRandomBased read GetDefaultInterface;
  published
  end;

// *********************************************************************//
// The Class CoMsftStreamConcatenate provides a Create and CreateRemote method to          
// create instances of the default interface IStreamConcatenate exposed by              
// the CoClass MsftStreamConcatenate. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoMsftStreamConcatenate = class
    class function Create: IStreamConcatenate;
    class function CreateRemote(const MachineName: string): IStreamConcatenate;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TMsftStreamConcatenate
// Help String      : Microsoft IMAPIv2 concatenation stream
// Default Interface: IStreamConcatenate
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TMsftStreamConcatenate = class(TOleServer)
  private
    FIntf: IStreamConcatenate;
    function GetDefaultInterface: IStreamConcatenate;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IStreamConcatenate);
    procedure Disconnect; override;
    function RemoteRead(out pv: Byte; cb: LongWord; out pcbRead: LongWord): HResult;
    function RemoteWrite(var pv: Byte; cb: LongWord; out pcbWritten: LongWord): HResult;
    function RemoteSeek(dlibMove: _LARGE_INTEGER; dwOrigin: LongWord; 
                        out plibNewPosition: _ULARGE_INTEGER): HResult;
    function SetSize(libNewSize: _ULARGE_INTEGER): HResult;
    function RemoteCopyTo(const pstm: IStream; cb: _ULARGE_INTEGER; out pcbRead: _ULARGE_INTEGER; 
                          out pcbWritten: _ULARGE_INTEGER): HResult;
    function Commit(grfCommitFlags: LongWord): HResult;
    function Revert: HResult;
    function LockRegion(libOffset: _ULARGE_INTEGER; cb: _ULARGE_INTEGER; dwLockType: LongWord): HResult;
    function UnlockRegion(libOffset: _ULARGE_INTEGER; cb: _ULARGE_INTEGER; dwLockType: LongWord): HResult;
    function Stat(out pstatstg: tagSTATSTG; grfStatFlag: LongWord): HResult;
    function Clone(out ppstm: IStream): HResult;
    function Initialize(const stream1: IStream; const stream2: IStream): HResult;
    function Initialize2(var streams: IStream; streamCount: LongWord): HResult;
    function Append(const stream: IStream): HResult;
    function Append2(var streams: IStream; streamCount: LongWord): HResult;
    property DefaultInterface: IStreamConcatenate read GetDefaultInterface;
  published
  end;

// *********************************************************************//
// The Class CoMsftStreamInterleave provides a Create and CreateRemote method to          
// create instances of the default interface IStreamInterleave exposed by              
// the CoClass MsftStreamInterleave. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoMsftStreamInterleave = class
    class function Create: IStreamInterleave;
    class function CreateRemote(const MachineName: string): IStreamInterleave;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TMsftStreamInterleave
// Help String      : Microsoft IMAPIv2 interleave stream
// Default Interface: IStreamInterleave
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TMsftStreamInterleave = class(TOleServer)
  private
    FIntf: IStreamInterleave;
    function GetDefaultInterface: IStreamInterleave;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IStreamInterleave);
    procedure Disconnect; override;
    function RemoteRead(out pv: Byte; cb: LongWord; out pcbRead: LongWord): HResult;
    function RemoteWrite(var pv: Byte; cb: LongWord; out pcbWritten: LongWord): HResult;
    function RemoteSeek(dlibMove: _LARGE_INTEGER; dwOrigin: LongWord; 
                        out plibNewPosition: _ULARGE_INTEGER): HResult;
    function SetSize(libNewSize: _ULARGE_INTEGER): HResult;
    function RemoteCopyTo(const pstm: IStream; cb: _ULARGE_INTEGER; out pcbRead: _ULARGE_INTEGER; 
                          out pcbWritten: _ULARGE_INTEGER): HResult;
    function Commit(grfCommitFlags: LongWord): HResult;
    function Revert: HResult;
    function LockRegion(libOffset: _ULARGE_INTEGER; cb: _ULARGE_INTEGER; dwLockType: LongWord): HResult;
    function UnlockRegion(libOffset: _ULARGE_INTEGER; cb: _ULARGE_INTEGER; dwLockType: LongWord): HResult;
    function Stat(out pstatstg: tagSTATSTG; grfStatFlag: LongWord): HResult;
    function Clone(out ppstm: IStream): HResult;
    function Initialize(var streams: IStream; var interleaveSizes: LongWord; streamCount: LongWord): HResult;
    property DefaultInterface: IStreamInterleave read GetDefaultInterface;
  published
  end;

// *********************************************************************//
// The Class CoMsftWriteSpeedDescriptor provides a Create and CreateRemote method to          
// create instances of the default interface IWriteSpeedDescriptor exposed by              
// the CoClass MsftWriteSpeedDescriptor. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoMsftWriteSpeedDescriptor = class
    class function Create: IWriteSpeedDescriptor;
    class function CreateRemote(const MachineName: string): IWriteSpeedDescriptor;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TMsftWriteSpeedDescriptor
// Help String      : Microsoft IMAPIv2 Write Speed Descriptor
// Default Interface: IWriteSpeedDescriptor
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (0)
// *********************************************************************//
  TMsftWriteSpeedDescriptor = class(TOleServer)
  private
    FIntf: IWriteSpeedDescriptor;
    function GetDefaultInterface: IWriteSpeedDescriptor;
  protected
    procedure InitServerData; override;
    function Get_MediaType: IMAPI_MEDIA_PHYSICAL_TYPE;
    function Get_RotationTypeIsPureCAV: WordBool;
    function Get_WriteSpeed: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IWriteSpeedDescriptor);
    procedure Disconnect; override;
    property DefaultInterface: IWriteSpeedDescriptor read GetDefaultInterface;
    property MediaType: IMAPI_MEDIA_PHYSICAL_TYPE read Get_MediaType;
    property RotationTypeIsPureCAV: WordBool read Get_RotationTypeIsPureCAV;
    property WriteSpeed: Integer read Get_WriteSpeed;
  published
  end;

// *********************************************************************//
// The Class CoMsftMultisessionSequential provides a Create and CreateRemote method to          
// create instances of the default interface IMultisessionSequential2 exposed by              
// the CoClass MsftMultisessionSequential. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoMsftMultisessionSequential = class
    class function Create: IMultisessionSequential2;
    class function CreateRemote(const MachineName: string): IMultisessionSequential2;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TMsftMultisessionSequential
// Help String      : Microsoft IMAPIv2 sequential Multi-session
// Default Interface: IMultisessionSequential2
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (0)
// *********************************************************************//
  TMsftMultisessionSequential = class(TOleServer)
  private
    FIntf: IMultisessionSequential2;
    function GetDefaultInterface: IMultisessionSequential2;
  protected
    procedure InitServerData; override;
    function Get_IsSupportedOnCurrentMediaState: WordBool;
    procedure Set_InUse(value: WordBool);
    function Get_InUse: WordBool;
    function Get_ImportRecorder: IDiscRecorder2;
    function Get_IsFirstDataSession: WordBool;
    function Get_StartAddressOfPreviousSession: Integer;
    function Get_LastWrittenAddressOfPreviousSession: Integer;
    function Get_NextWritableAddress: Integer;
    function Get_FreeSectorsOnMedia: Integer;
    function Get_WriteUnitSize: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IMultisessionSequential2);
    procedure Disconnect; override;
    property DefaultInterface: IMultisessionSequential2 read GetDefaultInterface;
    property IsSupportedOnCurrentMediaState: WordBool read Get_IsSupportedOnCurrentMediaState;
    property ImportRecorder: IDiscRecorder2 read Get_ImportRecorder;
    property IsFirstDataSession: WordBool read Get_IsFirstDataSession;
    property StartAddressOfPreviousSession: Integer read Get_StartAddressOfPreviousSession;
    property LastWrittenAddressOfPreviousSession: Integer read Get_LastWrittenAddressOfPreviousSession;
    property NextWritableAddress: Integer read Get_NextWritableAddress;
    property FreeSectorsOnMedia: Integer read Get_FreeSectorsOnMedia;
    property WriteUnitSize: Integer read Get_WriteUnitSize;
    property InUse: WordBool read Get_InUse write Set_InUse;
  published
  end;

// *********************************************************************//
// The Class CoMsftMultisessionRandomWrite provides a Create and CreateRemote method to          
// create instances of the default interface IMultisessionRandomWrite exposed by              
// the CoClass MsftMultisessionRandomWrite. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoMsftMultisessionRandomWrite = class
    class function Create: IMultisessionRandomWrite;
    class function CreateRemote(const MachineName: string): IMultisessionRandomWrite;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TMsftMultisessionRandomWrite
// Help String      : Microsoft IMAPIv2 random write Multi-session
// Default Interface: IMultisessionRandomWrite
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (0)
// *********************************************************************//
  TMsftMultisessionRandomWrite = class(TOleServer)
  private
    FIntf: IMultisessionRandomWrite;
    function GetDefaultInterface: IMultisessionRandomWrite;
  protected
    procedure InitServerData; override;
    function Get_IsSupportedOnCurrentMediaState: WordBool;
    procedure Set_InUse(value: WordBool);
    function Get_InUse: WordBool;
    function Get_ImportRecorder: IDiscRecorder2;
    function Get_WriteUnitSize: Integer;
    function Get_LastWrittenAddress: Integer;
    function Get_TotalSectorsOnMedia: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IMultisessionRandomWrite);
    procedure Disconnect; override;
    property DefaultInterface: IMultisessionRandomWrite read GetDefaultInterface;
    property IsSupportedOnCurrentMediaState: WordBool read Get_IsSupportedOnCurrentMediaState;
    property ImportRecorder: IDiscRecorder2 read Get_ImportRecorder;
    property WriteUnitSize: Integer read Get_WriteUnitSize;
    property LastWrittenAddress: Integer read Get_LastWrittenAddress;
    property TotalSectorsOnMedia: Integer read Get_TotalSectorsOnMedia;
    property InUse: WordBool read Get_InUse write Set_InUse;
  published
  end;

// *********************************************************************//
// The Class CoMsftRawCDImageCreator provides a Create and CreateRemote method to          
// create instances of the default interface IRawCDImageCreator exposed by              
// the CoClass MsftRawCDImageCreator. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoMsftRawCDImageCreator = class
    class function Create: IRawCDImageCreator;
    class function CreateRemote(const MachineName: string): IRawCDImageCreator;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TMsftRawCDImageCreator
// Help String      : Microsoft IMAPIv2 RAW CD Image Creator
// Default Interface: IRawCDImageCreator
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TMsftRawCDImageCreator = class(TOleServer)
  private
    FIntf: IRawCDImageCreator;
    function GetDefaultInterface: IRawCDImageCreator;
  protected
    procedure InitServerData; override;
    procedure Set_ResultingImageType(value: IMAPI_FORMAT2_RAW_CD_DATA_SECTOR_TYPE);
    function Get_ResultingImageType: IMAPI_FORMAT2_RAW_CD_DATA_SECTOR_TYPE;
    function Get_StartOfLeadout: Integer;
    procedure Set_StartOfLeadoutLimit(value: Integer);
    function Get_StartOfLeadoutLimit: Integer;
    procedure Set_DisableGaplessAudio(value: WordBool);
    function Get_DisableGaplessAudio: WordBool;
    procedure Set_MediaCatalogNumber(const value: WideString);
    function Get_MediaCatalogNumber: WideString;
    procedure Set_StartingTrackNumber(value: Integer);
    function Get_StartingTrackNumber: Integer;
    function Get_TrackInfo(trackIndex: Integer): IRawCDImageTrackInfo;
    function Get_NumberOfExistingTracks: Integer;
    function Get_LastUsedUserSectorInImage: Integer;
    function Get_ExpectedTableOfContents: PSafeArray;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IRawCDImageCreator);
    procedure Disconnect; override;
    function CreateResultImage: IStream;
    function AddTrack(dataType: IMAPI_CD_SECTOR_TYPE; const data: IStream): Integer;
    procedure AddSpecialPregap(const data: IStream);
    procedure AddSubcodeRWGenerator(const subcode: IStream);
    property DefaultInterface: IRawCDImageCreator read GetDefaultInterface;
    property StartOfLeadout: Integer read Get_StartOfLeadout;
    property TrackInfo[trackIndex: Integer]: IRawCDImageTrackInfo read Get_TrackInfo;
    property NumberOfExistingTracks: Integer read Get_NumberOfExistingTracks;
    property LastUsedUserSectorInImage: Integer read Get_LastUsedUserSectorInImage;
    property ExpectedTableOfContents: PSafeArray read Get_ExpectedTableOfContents;
    property ResultingImageType: IMAPI_FORMAT2_RAW_CD_DATA_SECTOR_TYPE read Get_ResultingImageType write Set_ResultingImageType;
    property StartOfLeadoutLimit: Integer read Get_StartOfLeadoutLimit write Set_StartOfLeadoutLimit;
    property DisableGaplessAudio: WordBool read Get_DisableGaplessAudio write Set_DisableGaplessAudio;
    property MediaCatalogNumber: WideString read Get_MediaCatalogNumber write Set_MediaCatalogNumber;
    property StartingTrackNumber: Integer read Get_StartingTrackNumber write Set_StartingTrackNumber;
  published
  end;

procedure Register;

resourcestring
  dtlServerPage = 'ActiveX';

  dtlOcxPage = 'ActiveX';

implementation

uses System.Win.ComObj;

class function CoMsftDiscMaster2.Create: IDiscMaster2;
begin
  Result := CreateComObject(CLASS_MsftDiscMaster2) as IDiscMaster2;
end;

class function CoMsftDiscMaster2.CreateRemote(const MachineName: string): IDiscMaster2;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_MsftDiscMaster2) as IDiscMaster2;
end;

procedure TMsftDiscMaster2.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{2735412E-7F64-5B0F-8F00-5D77AFBE261E}';
    IntfIID:   '{27354130-7F64-5B0F-8F00-5D77AFBE261E}';
    EventIID:  '{27354131-7F64-5B0F-8F00-5D77AFBE261E}';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TMsftDiscMaster2.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    ConnectEvents(punk);
    Fintf:= punk as IDiscMaster2;
  end;
end;

procedure TMsftDiscMaster2.ConnectTo(svrIntf: IDiscMaster2);
begin
  Disconnect;
  FIntf := svrIntf;
  ConnectEvents(FIntf);
end;

procedure TMsftDiscMaster2.DisConnect;
begin
  if Fintf <> nil then
  begin
    DisconnectEvents(FIntf);
    FIntf := nil;
  end;
end;

function TMsftDiscMaster2.GetDefaultInterface: IDiscMaster2;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TMsftDiscMaster2.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TMsftDiscMaster2.Destroy;
begin
  inherited Destroy;
end;

procedure TMsftDiscMaster2.InvokeEvent(DispID: TDispID; var Params: TVariantArray);
begin
  case DispID of
    -1: Exit;  // DISPID_UNKNOWN
    256: if Assigned(FOnNotifyDeviceAdded) then
         FOnNotifyDeviceAdded(Self,
                              Params[0] {const IDispatch},
                              Params[1] {const WideString});
    257: if Assigned(FOnNotifyDeviceRemoved) then
         FOnNotifyDeviceRemoved(Self,
                                Params[0] {const IDispatch},
                                Params[1] {const WideString});
  end; {case DispID}
end;

function TMsftDiscMaster2.Get_Item(index: Integer): WideString;
begin
  Result := DefaultInterface.Item[index];
end;

function TMsftDiscMaster2.Get_Count: Integer;
begin
  Result := DefaultInterface.Count;
end;

function TMsftDiscMaster2.Get_IsSupportedEnvironment: WordBool;
begin
  Result := DefaultInterface.IsSupportedEnvironment;
end;

class function CoMsftDiscRecorder2.Create: IDiscRecorder2;
begin
  Result := CreateComObject(CLASS_MsftDiscRecorder2) as IDiscRecorder2;
end;

class function CoMsftDiscRecorder2.CreateRemote(const MachineName: string): IDiscRecorder2;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_MsftDiscRecorder2) as IDiscRecorder2;
end;

procedure TMsftDiscRecorder2.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{2735412D-7F64-5B0F-8F00-5D77AFBE261E}';
    IntfIID:   '{27354133-7F64-5B0F-8F00-5D77AFBE261E}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TMsftDiscRecorder2.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IDiscRecorder2;
  end;
end;

procedure TMsftDiscRecorder2.ConnectTo(svrIntf: IDiscRecorder2);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TMsftDiscRecorder2.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TMsftDiscRecorder2.GetDefaultInterface: IDiscRecorder2;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TMsftDiscRecorder2.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TMsftDiscRecorder2.Destroy;
begin
  inherited Destroy;
end;

function TMsftDiscRecorder2.Get_ActiveDiscRecorder: WideString;
begin
  Result := DefaultInterface.ActiveDiscRecorder;
end;

function TMsftDiscRecorder2.Get_VendorId: WideString;
begin
  Result := DefaultInterface.VendorId;
end;

function TMsftDiscRecorder2.Get_ProductId: WideString;
begin
  Result := DefaultInterface.ProductId;
end;

function TMsftDiscRecorder2.Get_ProductRevision: WideString;
begin
  Result := DefaultInterface.ProductRevision;
end;

function TMsftDiscRecorder2.Get_VolumeName: WideString;
begin
  Result := DefaultInterface.VolumeName;
end;

function TMsftDiscRecorder2.Get_VolumePathNames: PSafeArray;
begin
  Result := DefaultInterface.VolumePathNames;
end;

function TMsftDiscRecorder2.Get_DeviceCanLoadMedia: WordBool;
begin
  Result := DefaultInterface.DeviceCanLoadMedia;
end;

function TMsftDiscRecorder2.Get_LegacyDeviceNumber: Integer;
begin
  Result := DefaultInterface.LegacyDeviceNumber;
end;

function TMsftDiscRecorder2.Get_SupportedFeaturePages: PSafeArray;
begin
  Result := DefaultInterface.SupportedFeaturePages;
end;

function TMsftDiscRecorder2.Get_CurrentFeaturePages: PSafeArray;
begin
  Result := DefaultInterface.CurrentFeaturePages;
end;

function TMsftDiscRecorder2.Get_SupportedProfiles: PSafeArray;
begin
  Result := DefaultInterface.SupportedProfiles;
end;

function TMsftDiscRecorder2.Get_CurrentProfiles: PSafeArray;
begin
  Result := DefaultInterface.CurrentProfiles;
end;

function TMsftDiscRecorder2.Get_SupportedModePages: PSafeArray;
begin
  Result := DefaultInterface.SupportedModePages;
end;

function TMsftDiscRecorder2.Get_ExclusiveAccessOwner: WideString;
begin
  Result := DefaultInterface.ExclusiveAccessOwner;
end;

procedure TMsftDiscRecorder2.EjectMedia;
begin
  DefaultInterface.EjectMedia;
end;

procedure TMsftDiscRecorder2.CloseTray;
begin
  DefaultInterface.CloseTray;
end;

procedure TMsftDiscRecorder2.AcquireExclusiveAccess(force: WordBool; 
                                                    const __MIDL__IDiscRecorder20000: WideString);
begin
  DefaultInterface.AcquireExclusiveAccess(force, __MIDL__IDiscRecorder20000);
end;

procedure TMsftDiscRecorder2.ReleaseExclusiveAccess;
begin
  DefaultInterface.ReleaseExclusiveAccess;
end;

procedure TMsftDiscRecorder2.DisableMcn;
begin
  DefaultInterface.DisableMcn;
end;

procedure TMsftDiscRecorder2.EnableMcn;
begin
  DefaultInterface.EnableMcn;
end;

procedure TMsftDiscRecorder2.InitializeDiscRecorder(const recorderUniqueId: WideString);
begin
  DefaultInterface.InitializeDiscRecorder(recorderUniqueId);
end;

class function CoMsftWriteEngine2.Create: IWriteEngine2;
begin
  Result := CreateComObject(CLASS_MsftWriteEngine2) as IWriteEngine2;
end;

class function CoMsftWriteEngine2.CreateRemote(const MachineName: string): IWriteEngine2;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_MsftWriteEngine2) as IWriteEngine2;
end;

procedure TMsftWriteEngine2.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{2735412C-7F64-5B0F-8F00-5D77AFBE261E}';
    IntfIID:   '{27354135-7F64-5B0F-8F00-5D77AFBE261E}';
    EventIID:  '{27354137-7F64-5B0F-8F00-5D77AFBE261E}';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TMsftWriteEngine2.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    ConnectEvents(punk);
    Fintf:= punk as IWriteEngine2;
  end;
end;

procedure TMsftWriteEngine2.ConnectTo(svrIntf: IWriteEngine2);
begin
  Disconnect;
  FIntf := svrIntf;
  ConnectEvents(FIntf);
end;

procedure TMsftWriteEngine2.DisConnect;
begin
  if Fintf <> nil then
  begin
    DisconnectEvents(FIntf);
    FIntf := nil;
  end;
end;

function TMsftWriteEngine2.GetDefaultInterface: IWriteEngine2;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TMsftWriteEngine2.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TMsftWriteEngine2.Destroy;
begin
  inherited Destroy;
end;

procedure TMsftWriteEngine2.InvokeEvent(DispID: TDispID; var Params: TVariantArray);
begin
  case DispID of
    -1: Exit;  // DISPID_UNKNOWN
    256: if Assigned(FOnUpdate) then
         FOnUpdate(Self,
                   Params[0] {const IDispatch},
                   Params[1] {const IDispatch});
  end; {case DispID}
end;

procedure TMsftWriteEngine2.Set_Recorder(const value: IDiscRecorder2Ex);
begin
  DefaultInterface.Recorder := value;
end;

function TMsftWriteEngine2.Get_Recorder: IDiscRecorder2Ex;
begin
  Result := DefaultInterface.Recorder;
end;

procedure TMsftWriteEngine2.Set_UseStreamingWrite12(value: WordBool);
begin
  DefaultInterface.UseStreamingWrite12 := value;
end;

function TMsftWriteEngine2.Get_UseStreamingWrite12: WordBool;
begin
  Result := DefaultInterface.UseStreamingWrite12;
end;

procedure TMsftWriteEngine2.Set_StartingSectorsPerSecond(value: Integer);
begin
  DefaultInterface.StartingSectorsPerSecond := value;
end;

function TMsftWriteEngine2.Get_StartingSectorsPerSecond: Integer;
begin
  Result := DefaultInterface.StartingSectorsPerSecond;
end;

procedure TMsftWriteEngine2.Set_EndingSectorsPerSecond(value: Integer);
begin
  DefaultInterface.EndingSectorsPerSecond := value;
end;

function TMsftWriteEngine2.Get_EndingSectorsPerSecond: Integer;
begin
  Result := DefaultInterface.EndingSectorsPerSecond;
end;

procedure TMsftWriteEngine2.Set_BytesPerSector(value: Integer);
begin
  DefaultInterface.BytesPerSector := value;
end;

function TMsftWriteEngine2.Get_BytesPerSector: Integer;
begin
  Result := DefaultInterface.BytesPerSector;
end;

function TMsftWriteEngine2.Get_WriteInProgress: WordBool;
begin
  Result := DefaultInterface.WriteInProgress;
end;

procedure TMsftWriteEngine2.WriteSection(const data: IStream; startingBlockAddress: Integer; 
                                         numberOfBlocks: Integer);
begin
  DefaultInterface.WriteSection(data, startingBlockAddress, numberOfBlocks);
end;

procedure TMsftWriteEngine2.CancelWrite;
begin
  DefaultInterface.CancelWrite;
end;

class function CoMsftDiscFormat2Erase.Create: IDiscFormat2Erase;
begin
  Result := CreateComObject(CLASS_MsftDiscFormat2Erase) as IDiscFormat2Erase;
end;

class function CoMsftDiscFormat2Erase.CreateRemote(const MachineName: string): IDiscFormat2Erase;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_MsftDiscFormat2Erase) as IDiscFormat2Erase;
end;

procedure TMsftDiscFormat2Erase.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{2735412B-7F64-5B0F-8F00-5D77AFBE261E}';
    IntfIID:   '{27354156-8F64-5B0F-8F00-5D77AFBE261E}';
    EventIID:  '{2735413A-7F64-5B0F-8F00-5D77AFBE261E}';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TMsftDiscFormat2Erase.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    ConnectEvents(punk);
    Fintf:= punk as IDiscFormat2Erase;
  end;
end;

procedure TMsftDiscFormat2Erase.ConnectTo(svrIntf: IDiscFormat2Erase);
begin
  Disconnect;
  FIntf := svrIntf;
  ConnectEvents(FIntf);
end;

procedure TMsftDiscFormat2Erase.DisConnect;
begin
  if Fintf <> nil then
  begin
    DisconnectEvents(FIntf);
    FIntf := nil;
  end;
end;

function TMsftDiscFormat2Erase.GetDefaultInterface: IDiscFormat2Erase;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TMsftDiscFormat2Erase.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TMsftDiscFormat2Erase.Destroy;
begin
  inherited Destroy;
end;

procedure TMsftDiscFormat2Erase.InvokeEvent(DispID: TDispID; var Params: TVariantArray);
begin
  case DispID of
    -1: Exit;  // DISPID_UNKNOWN
    512: if Assigned(FOnUpdate) then
         FOnUpdate(Self,
                   Params[0] {const IDispatch},
                   Params[1] {Integer},
                   Params[2] {Integer});
  end; {case DispID}
end;

procedure TMsftDiscFormat2Erase.Set_Recorder(const value: IDiscRecorder2);
begin
  DefaultInterface.Recorder := value;
end;

function TMsftDiscFormat2Erase.Get_Recorder: IDiscRecorder2;
begin
  Result := DefaultInterface.Recorder;
end;

procedure TMsftDiscFormat2Erase.Set_FullErase(value: WordBool);
begin
  DefaultInterface.FullErase := value;
end;

function TMsftDiscFormat2Erase.Get_FullErase: WordBool;
begin
  Result := DefaultInterface.FullErase;
end;

function TMsftDiscFormat2Erase.Get_CurrentPhysicalMediaType: IMAPI_MEDIA_PHYSICAL_TYPE;
begin
  Result := DefaultInterface.CurrentPhysicalMediaType;
end;

procedure TMsftDiscFormat2Erase.Set_ClientName(const value: WideString);
begin
  DefaultInterface.ClientName := value;
end;

function TMsftDiscFormat2Erase.Get_ClientName: WideString;
begin
  Result := DefaultInterface.ClientName;
end;

procedure TMsftDiscFormat2Erase.EraseMedia;
begin
  DefaultInterface.EraseMedia;
end;

class function CoMsftDiscFormat2Data.Create: IDiscFormat2Data;
begin
  Result := CreateComObject(CLASS_MsftDiscFormat2Data) as IDiscFormat2Data;
end;

class function CoMsftDiscFormat2Data.CreateRemote(const MachineName: string): IDiscFormat2Data;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_MsftDiscFormat2Data) as IDiscFormat2Data;
end;

procedure TMsftDiscFormat2Data.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{2735412A-7F64-5B0F-8F00-5D77AFBE261E}';
    IntfIID:   '{27354153-9F64-5B0F-8F00-5D77AFBE261E}';
    EventIID:  '{2735413C-7F64-5B0F-8F00-5D77AFBE261E}';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TMsftDiscFormat2Data.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    ConnectEvents(punk);
    Fintf:= punk as IDiscFormat2Data;
  end;
end;

procedure TMsftDiscFormat2Data.ConnectTo(svrIntf: IDiscFormat2Data);
begin
  Disconnect;
  FIntf := svrIntf;
  ConnectEvents(FIntf);
end;

procedure TMsftDiscFormat2Data.DisConnect;
begin
  if Fintf <> nil then
  begin
    DisconnectEvents(FIntf);
    FIntf := nil;
  end;
end;

function TMsftDiscFormat2Data.GetDefaultInterface: IDiscFormat2Data;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TMsftDiscFormat2Data.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TMsftDiscFormat2Data.Destroy;
begin
  inherited Destroy;
end;

procedure TMsftDiscFormat2Data.InvokeEvent(DispID: TDispID; var Params: TVariantArray);
begin
  case DispID of
    -1: Exit;  // DISPID_UNKNOWN
    512: if Assigned(FOnUpdate) then
         FOnUpdate(Self,
                   Params[0] {const IDispatch},
                   Params[1] {const IDispatch});
  end; {case DispID}
end;

procedure TMsftDiscFormat2Data.Set_Recorder(const value: IDiscRecorder2);
begin
  DefaultInterface.Recorder := value;
end;

function TMsftDiscFormat2Data.Get_Recorder: IDiscRecorder2;
begin
  Result := DefaultInterface.Recorder;
end;

procedure TMsftDiscFormat2Data.Set_BufferUnderrunFreeDisabled(value: WordBool);
begin
  DefaultInterface.BufferUnderrunFreeDisabled := value;
end;

function TMsftDiscFormat2Data.Get_BufferUnderrunFreeDisabled: WordBool;
begin
  Result := DefaultInterface.BufferUnderrunFreeDisabled;
end;

procedure TMsftDiscFormat2Data.Set_PostgapAlreadyInImage(value: WordBool);
begin
  DefaultInterface.PostgapAlreadyInImage := value;
end;

function TMsftDiscFormat2Data.Get_PostgapAlreadyInImage: WordBool;
begin
  Result := DefaultInterface.PostgapAlreadyInImage;
end;

function TMsftDiscFormat2Data.Get_CurrentMediaStatus: IMAPI_FORMAT2_DATA_MEDIA_STATE;
begin
  Result := DefaultInterface.CurrentMediaStatus;
end;

function TMsftDiscFormat2Data.Get_WriteProtectStatus: IMAPI_MEDIA_WRITE_PROTECT_STATE;
begin
  Result := DefaultInterface.WriteProtectStatus;
end;

function TMsftDiscFormat2Data.Get_TotalSectorsOnMedia: Integer;
begin
  Result := DefaultInterface.TotalSectorsOnMedia;
end;

function TMsftDiscFormat2Data.Get_FreeSectorsOnMedia: Integer;
begin
  Result := DefaultInterface.FreeSectorsOnMedia;
end;

function TMsftDiscFormat2Data.Get_NextWritableAddress: Integer;
begin
  Result := DefaultInterface.NextWritableAddress;
end;

function TMsftDiscFormat2Data.Get_StartAddressOfPreviousSession: Integer;
begin
  Result := DefaultInterface.StartAddressOfPreviousSession;
end;

function TMsftDiscFormat2Data.Get_LastWrittenAddressOfPreviousSession: Integer;
begin
  Result := DefaultInterface.LastWrittenAddressOfPreviousSession;
end;

procedure TMsftDiscFormat2Data.Set_ForceMediaToBeClosed(value: WordBool);
begin
  DefaultInterface.ForceMediaToBeClosed := value;
end;

function TMsftDiscFormat2Data.Get_ForceMediaToBeClosed: WordBool;
begin
  Result := DefaultInterface.ForceMediaToBeClosed;
end;

procedure TMsftDiscFormat2Data.Set_DisableConsumerDvdCompatibilityMode(value: WordBool);
begin
  DefaultInterface.DisableConsumerDvdCompatibilityMode := value;
end;

function TMsftDiscFormat2Data.Get_DisableConsumerDvdCompatibilityMode: WordBool;
begin
  Result := DefaultInterface.DisableConsumerDvdCompatibilityMode;
end;

function TMsftDiscFormat2Data.Get_CurrentPhysicalMediaType: IMAPI_MEDIA_PHYSICAL_TYPE;
begin
  Result := DefaultInterface.CurrentPhysicalMediaType;
end;

procedure TMsftDiscFormat2Data.Set_ClientName(const value: WideString);
begin
  DefaultInterface.ClientName := value;
end;

function TMsftDiscFormat2Data.Get_ClientName: WideString;
begin
  Result := DefaultInterface.ClientName;
end;

function TMsftDiscFormat2Data.Get_RequestedWriteSpeed: Integer;
begin
  Result := DefaultInterface.RequestedWriteSpeed;
end;

function TMsftDiscFormat2Data.Get_RequestedRotationTypeIsPureCAV: WordBool;
begin
  Result := DefaultInterface.RequestedRotationTypeIsPureCAV;
end;

function TMsftDiscFormat2Data.Get_CurrentWriteSpeed: Integer;
begin
  Result := DefaultInterface.CurrentWriteSpeed;
end;

function TMsftDiscFormat2Data.Get_CurrentRotationTypeIsPureCAV: WordBool;
begin
  Result := DefaultInterface.CurrentRotationTypeIsPureCAV;
end;

function TMsftDiscFormat2Data.Get_SupportedWriteSpeeds: PSafeArray;
begin
  Result := DefaultInterface.SupportedWriteSpeeds;
end;

function TMsftDiscFormat2Data.Get_SupportedWriteSpeedDescriptors: PSafeArray;
begin
  Result := DefaultInterface.SupportedWriteSpeedDescriptors;
end;

procedure TMsftDiscFormat2Data.Set_ForceOverwrite(value: WordBool);
begin
  DefaultInterface.ForceOverwrite := value;
end;

function TMsftDiscFormat2Data.Get_ForceOverwrite: WordBool;
begin
  Result := DefaultInterface.ForceOverwrite;
end;

function TMsftDiscFormat2Data.Get_MultisessionInterfaces: PSafeArray;
begin
  Result := DefaultInterface.MultisessionInterfaces;
end;

procedure TMsftDiscFormat2Data.Write(const data: IStream);
begin
  DefaultInterface.Write(data);
end;

procedure TMsftDiscFormat2Data.CancelWrite;
begin
  DefaultInterface.CancelWrite;
end;

procedure TMsftDiscFormat2Data.SetWriteSpeed(RequestedSectorsPerSecond: Integer; 
                                             RotationTypeIsPureCAV: WordBool);
begin
  DefaultInterface.SetWriteSpeed(RequestedSectorsPerSecond, RotationTypeIsPureCAV);
end;

class function CoMsftDiscFormat2TrackAtOnce.Create: IDiscFormat2TrackAtOnce;
begin
  Result := CreateComObject(CLASS_MsftDiscFormat2TrackAtOnce) as IDiscFormat2TrackAtOnce;
end;

class function CoMsftDiscFormat2TrackAtOnce.CreateRemote(const MachineName: string): IDiscFormat2TrackAtOnce;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_MsftDiscFormat2TrackAtOnce) as IDiscFormat2TrackAtOnce;
end;

procedure TMsftDiscFormat2TrackAtOnce.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{27354129-7F64-5B0F-8F00-5D77AFBE261E}';
    IntfIID:   '{27354154-8F64-5B0F-8F00-5D77AFBE261E}';
    EventIID:  '{2735413F-7F64-5B0F-8F00-5D77AFBE261E}';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TMsftDiscFormat2TrackAtOnce.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    ConnectEvents(punk);
    Fintf:= punk as IDiscFormat2TrackAtOnce;
  end;
end;

procedure TMsftDiscFormat2TrackAtOnce.ConnectTo(svrIntf: IDiscFormat2TrackAtOnce);
begin
  Disconnect;
  FIntf := svrIntf;
  ConnectEvents(FIntf);
end;

procedure TMsftDiscFormat2TrackAtOnce.DisConnect;
begin
  if Fintf <> nil then
  begin
    DisconnectEvents(FIntf);
    FIntf := nil;
  end;
end;

function TMsftDiscFormat2TrackAtOnce.GetDefaultInterface: IDiscFormat2TrackAtOnce;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TMsftDiscFormat2TrackAtOnce.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TMsftDiscFormat2TrackAtOnce.Destroy;
begin
  inherited Destroy;
end;

procedure TMsftDiscFormat2TrackAtOnce.InvokeEvent(DispID: TDispID; var Params: TVariantArray);
begin
  case DispID of
    -1: Exit;  // DISPID_UNKNOWN
    512: if Assigned(FOnUpdate) then
         FOnUpdate(Self,
                   Params[0] {const IDispatch},
                   Params[1] {const IDispatch});
  end; {case DispID}
end;

procedure TMsftDiscFormat2TrackAtOnce.Set_Recorder(const value: IDiscRecorder2);
begin
  DefaultInterface.Recorder := value;
end;

function TMsftDiscFormat2TrackAtOnce.Get_Recorder: IDiscRecorder2;
begin
  Result := DefaultInterface.Recorder;
end;

procedure TMsftDiscFormat2TrackAtOnce.Set_BufferUnderrunFreeDisabled(value: WordBool);
begin
  DefaultInterface.BufferUnderrunFreeDisabled := value;
end;

function TMsftDiscFormat2TrackAtOnce.Get_BufferUnderrunFreeDisabled: WordBool;
begin
  Result := DefaultInterface.BufferUnderrunFreeDisabled;
end;

function TMsftDiscFormat2TrackAtOnce.Get_NumberOfExistingTracks: Integer;
begin
  Result := DefaultInterface.NumberOfExistingTracks;
end;

function TMsftDiscFormat2TrackAtOnce.Get_TotalSectorsOnMedia: Integer;
begin
  Result := DefaultInterface.TotalSectorsOnMedia;
end;

function TMsftDiscFormat2TrackAtOnce.Get_FreeSectorsOnMedia: Integer;
begin
  Result := DefaultInterface.FreeSectorsOnMedia;
end;

function TMsftDiscFormat2TrackAtOnce.Get_UsedSectorsOnMedia: Integer;
begin
  Result := DefaultInterface.UsedSectorsOnMedia;
end;

procedure TMsftDiscFormat2TrackAtOnce.Set_DoNotFinalizeMedia(value: WordBool);
begin
  DefaultInterface.DoNotFinalizeMedia := value;
end;

function TMsftDiscFormat2TrackAtOnce.Get_DoNotFinalizeMedia: WordBool;
begin
  Result := DefaultInterface.DoNotFinalizeMedia;
end;

function TMsftDiscFormat2TrackAtOnce.Get_ExpectedTableOfContents: PSafeArray;
begin
  Result := DefaultInterface.ExpectedTableOfContents;
end;

function TMsftDiscFormat2TrackAtOnce.Get_CurrentPhysicalMediaType: IMAPI_MEDIA_PHYSICAL_TYPE;
begin
  Result := DefaultInterface.CurrentPhysicalMediaType;
end;

procedure TMsftDiscFormat2TrackAtOnce.Set_ClientName(const value: WideString);
begin
  DefaultInterface.ClientName := value;
end;

function TMsftDiscFormat2TrackAtOnce.Get_ClientName: WideString;
begin
  Result := DefaultInterface.ClientName;
end;

function TMsftDiscFormat2TrackAtOnce.Get_RequestedWriteSpeed: Integer;
begin
  Result := DefaultInterface.RequestedWriteSpeed;
end;

function TMsftDiscFormat2TrackAtOnce.Get_RequestedRotationTypeIsPureCAV: WordBool;
begin
  Result := DefaultInterface.RequestedRotationTypeIsPureCAV;
end;

function TMsftDiscFormat2TrackAtOnce.Get_CurrentWriteSpeed: Integer;
begin
  Result := DefaultInterface.CurrentWriteSpeed;
end;

function TMsftDiscFormat2TrackAtOnce.Get_CurrentRotationTypeIsPureCAV: WordBool;
begin
  Result := DefaultInterface.CurrentRotationTypeIsPureCAV;
end;

function TMsftDiscFormat2TrackAtOnce.Get_SupportedWriteSpeeds: PSafeArray;
begin
  Result := DefaultInterface.SupportedWriteSpeeds;
end;

function TMsftDiscFormat2TrackAtOnce.Get_SupportedWriteSpeedDescriptors: PSafeArray;
begin
  Result := DefaultInterface.SupportedWriteSpeedDescriptors;
end;

procedure TMsftDiscFormat2TrackAtOnce.PrepareMedia;
begin
  DefaultInterface.PrepareMedia;
end;

procedure TMsftDiscFormat2TrackAtOnce.AddAudioTrack(const data: IStream);
begin
  DefaultInterface.AddAudioTrack(data);
end;

procedure TMsftDiscFormat2TrackAtOnce.CancelAddTrack;
begin
  DefaultInterface.CancelAddTrack;
end;

procedure TMsftDiscFormat2TrackAtOnce.ReleaseMedia;
begin
  DefaultInterface.ReleaseMedia;
end;

procedure TMsftDiscFormat2TrackAtOnce.SetWriteSpeed(RequestedSectorsPerSecond: Integer; 
                                                    RotationTypeIsPureCAV: WordBool);
begin
  DefaultInterface.SetWriteSpeed(RequestedSectorsPerSecond, RotationTypeIsPureCAV);
end;

class function CoMsftDiscFormat2RawCD.Create: IDiscFormat2RawCD;
begin
  Result := CreateComObject(CLASS_MsftDiscFormat2RawCD) as IDiscFormat2RawCD;
end;

class function CoMsftDiscFormat2RawCD.CreateRemote(const MachineName: string): IDiscFormat2RawCD;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_MsftDiscFormat2RawCD) as IDiscFormat2RawCD;
end;

procedure TMsftDiscFormat2RawCD.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{27354128-7F64-5B0F-8F00-5D77AFBE261E}';
    IntfIID:   '{27354155-8F64-5B0F-8F00-5D77AFBE261E}';
    EventIID:  '{27354142-7F64-5B0F-8F00-5D77AFBE261E}';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TMsftDiscFormat2RawCD.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    ConnectEvents(punk);
    Fintf:= punk as IDiscFormat2RawCD;
  end;
end;

procedure TMsftDiscFormat2RawCD.ConnectTo(svrIntf: IDiscFormat2RawCD);
begin
  Disconnect;
  FIntf := svrIntf;
  ConnectEvents(FIntf);
end;

procedure TMsftDiscFormat2RawCD.DisConnect;
begin
  if Fintf <> nil then
  begin
    DisconnectEvents(FIntf);
    FIntf := nil;
  end;
end;

function TMsftDiscFormat2RawCD.GetDefaultInterface: IDiscFormat2RawCD;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TMsftDiscFormat2RawCD.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TMsftDiscFormat2RawCD.Destroy;
begin
  inherited Destroy;
end;

procedure TMsftDiscFormat2RawCD.InvokeEvent(DispID: TDispID; var Params: TVariantArray);
begin
  case DispID of
    -1: Exit;  // DISPID_UNKNOWN
    512: if Assigned(FOnUpdate) then
         FOnUpdate(Self,
                   Params[0] {const IDispatch},
                   Params[1] {const IDispatch});
  end; {case DispID}
end;

procedure TMsftDiscFormat2RawCD.Set_Recorder(const value: IDiscRecorder2);
begin
  DefaultInterface.Recorder := value;
end;

function TMsftDiscFormat2RawCD.Get_Recorder: IDiscRecorder2;
begin
  Result := DefaultInterface.Recorder;
end;

procedure TMsftDiscFormat2RawCD.Set_BufferUnderrunFreeDisabled(value: WordBool);
begin
  DefaultInterface.BufferUnderrunFreeDisabled := value;
end;

function TMsftDiscFormat2RawCD.Get_BufferUnderrunFreeDisabled: WordBool;
begin
  Result := DefaultInterface.BufferUnderrunFreeDisabled;
end;

function TMsftDiscFormat2RawCD.Get_StartOfNextSession: Integer;
begin
  Result := DefaultInterface.StartOfNextSession;
end;

function TMsftDiscFormat2RawCD.Get_LastPossibleStartOfLeadout: Integer;
begin
  Result := DefaultInterface.LastPossibleStartOfLeadout;
end;

function TMsftDiscFormat2RawCD.Get_CurrentPhysicalMediaType: IMAPI_MEDIA_PHYSICAL_TYPE;
begin
  Result := DefaultInterface.CurrentPhysicalMediaType;
end;

function TMsftDiscFormat2RawCD.Get_SupportedSectorTypes: PSafeArray;
begin
  Result := DefaultInterface.SupportedSectorTypes;
end;

procedure TMsftDiscFormat2RawCD.Set_RequestedSectorType(value: IMAPI_FORMAT2_RAW_CD_DATA_SECTOR_TYPE);
begin
  DefaultInterface.RequestedSectorType := value;
end;

function TMsftDiscFormat2RawCD.Get_RequestedSectorType: IMAPI_FORMAT2_RAW_CD_DATA_SECTOR_TYPE;
begin
  Result := DefaultInterface.RequestedSectorType;
end;

procedure TMsftDiscFormat2RawCD.Set_ClientName(const value: WideString);
begin
  DefaultInterface.ClientName := value;
end;

function TMsftDiscFormat2RawCD.Get_ClientName: WideString;
begin
  Result := DefaultInterface.ClientName;
end;

function TMsftDiscFormat2RawCD.Get_RequestedWriteSpeed: Integer;
begin
  Result := DefaultInterface.RequestedWriteSpeed;
end;

function TMsftDiscFormat2RawCD.Get_RequestedRotationTypeIsPureCAV: WordBool;
begin
  Result := DefaultInterface.RequestedRotationTypeIsPureCAV;
end;

function TMsftDiscFormat2RawCD.Get_CurrentWriteSpeed: Integer;
begin
  Result := DefaultInterface.CurrentWriteSpeed;
end;

function TMsftDiscFormat2RawCD.Get_CurrentRotationTypeIsPureCAV: WordBool;
begin
  Result := DefaultInterface.CurrentRotationTypeIsPureCAV;
end;

function TMsftDiscFormat2RawCD.Get_SupportedWriteSpeeds: PSafeArray;
begin
  Result := DefaultInterface.SupportedWriteSpeeds;
end;

function TMsftDiscFormat2RawCD.Get_SupportedWriteSpeedDescriptors: PSafeArray;
begin
  Result := DefaultInterface.SupportedWriteSpeedDescriptors;
end;

procedure TMsftDiscFormat2RawCD.PrepareMedia;
begin
  DefaultInterface.PrepareMedia;
end;

procedure TMsftDiscFormat2RawCD.WriteMedia(const data: IStream);
begin
  DefaultInterface.WriteMedia(data);
end;

procedure TMsftDiscFormat2RawCD.WriteMedia2(const data: IStream; streamLeadInSectors: Integer);
begin
  DefaultInterface.WriteMedia2(data, streamLeadInSectors);
end;

procedure TMsftDiscFormat2RawCD.CancelWrite;
begin
  DefaultInterface.CancelWrite;
end;

procedure TMsftDiscFormat2RawCD.ReleaseMedia;
begin
  DefaultInterface.ReleaseMedia;
end;

procedure TMsftDiscFormat2RawCD.SetWriteSpeed(RequestedSectorsPerSecond: Integer; 
                                              RotationTypeIsPureCAV: WordBool);
begin
  DefaultInterface.SetWriteSpeed(RequestedSectorsPerSecond, RotationTypeIsPureCAV);
end;

class function CoMsftStreamZero.Create: IStream;
begin
  Result := CreateComObject(CLASS_MsftStreamZero) as IStream;
end;

class function CoMsftStreamZero.CreateRemote(const MachineName: string): IStream;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_MsftStreamZero) as IStream;
end;

procedure TMsftStreamZero.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{27354127-7F64-5B0F-8F00-5D77AFBE261E}';
    IntfIID:   '{0000000C-0000-0000-C000-000000000046}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TMsftStreamZero.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IStream;
  end;
end;

procedure TMsftStreamZero.ConnectTo(svrIntf: IStream);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TMsftStreamZero.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TMsftStreamZero.GetDefaultInterface: IStream;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TMsftStreamZero.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TMsftStreamZero.Destroy;
begin
  inherited Destroy;
end;

function TMsftStreamZero.RemoteRead(out pv: Byte; cb: LongWord; out pcbRead: LongWord): HResult;
begin
  Result := DefaultInterface.RemoteRead(pv, cb, pcbRead);
end;

function TMsftStreamZero.RemoteWrite(var pv: Byte; cb: LongWord; out pcbWritten: LongWord): HResult;
begin
  Result := DefaultInterface.RemoteWrite(pv, cb, pcbWritten);
end;

function TMsftStreamZero.RemoteSeek(dlibMove: _LARGE_INTEGER; dwOrigin: LongWord; 
                                    out plibNewPosition: _ULARGE_INTEGER): HResult;
begin
  Result := DefaultInterface.RemoteSeek(dlibMove, dwOrigin, plibNewPosition);
end;

function TMsftStreamZero.SetSize(libNewSize: _ULARGE_INTEGER): HResult;
begin
  Result := DefaultInterface.SetSize(libNewSize);
end;

function TMsftStreamZero.RemoteCopyTo(const pstm: IStream; cb: _ULARGE_INTEGER; 
                                      out pcbRead: _ULARGE_INTEGER; out pcbWritten: _ULARGE_INTEGER): HResult;
begin
  Result := DefaultInterface.RemoteCopyTo(pstm, cb, pcbRead, pcbWritten);
end;

function TMsftStreamZero.Commit(grfCommitFlags: LongWord): HResult;
begin
  Result := DefaultInterface.Commit(grfCommitFlags);
end;

function TMsftStreamZero.Revert: HResult;
begin
  Result := DefaultInterface.Revert;
end;

function TMsftStreamZero.LockRegion(libOffset: _ULARGE_INTEGER; cb: _ULARGE_INTEGER; 
                                    dwLockType: LongWord): HResult;
begin
  Result := DefaultInterface.LockRegion(libOffset, cb, dwLockType);
end;

function TMsftStreamZero.UnlockRegion(libOffset: _ULARGE_INTEGER; cb: _ULARGE_INTEGER; 
                                      dwLockType: LongWord): HResult;
begin
  Result := DefaultInterface.UnlockRegion(libOffset, cb, dwLockType);
end;

function TMsftStreamZero.Stat(out pstatstg: tagSTATSTG; grfStatFlag: LongWord): HResult;
begin
  Result := DefaultInterface.Stat(pstatstg, grfStatFlag);
end;

function TMsftStreamZero.Clone(out ppstm: IStream): HResult;
begin
  Result := DefaultInterface.Clone(ppstm);
end;

class function CoMsftStreamPrng001.Create: IStreamPseudoRandomBased;
begin
  Result := CreateComObject(CLASS_MsftStreamPrng001) as IStreamPseudoRandomBased;
end;

class function CoMsftStreamPrng001.CreateRemote(const MachineName: string): IStreamPseudoRandomBased;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_MsftStreamPrng001) as IStreamPseudoRandomBased;
end;

procedure TMsftStreamPrng001.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{27354126-7F64-5B0F-8F00-5D77AFBE261E}';
    IntfIID:   '{27354145-7F64-5B0F-8F00-5D77AFBE261E}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TMsftStreamPrng001.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IStreamPseudoRandomBased;
  end;
end;

procedure TMsftStreamPrng001.ConnectTo(svrIntf: IStreamPseudoRandomBased);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TMsftStreamPrng001.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TMsftStreamPrng001.GetDefaultInterface: IStreamPseudoRandomBased;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TMsftStreamPrng001.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TMsftStreamPrng001.Destroy;
begin
  inherited Destroy;
end;

function TMsftStreamPrng001.RemoteRead(out pv: Byte; cb: LongWord; out pcbRead: LongWord): HResult;
begin
  Result := DefaultInterface.RemoteRead(pv, cb, pcbRead);
end;

function TMsftStreamPrng001.RemoteWrite(var pv: Byte; cb: LongWord; out pcbWritten: LongWord): HResult;
begin
  Result := DefaultInterface.RemoteWrite(pv, cb, pcbWritten);
end;

function TMsftStreamPrng001.RemoteSeek(dlibMove: _LARGE_INTEGER; dwOrigin: LongWord; 
                                       out plibNewPosition: _ULARGE_INTEGER): HResult;
begin
  Result := DefaultInterface.RemoteSeek(dlibMove, dwOrigin, plibNewPosition);
end;

function TMsftStreamPrng001.SetSize(libNewSize: _ULARGE_INTEGER): HResult;
begin
  Result := DefaultInterface.SetSize(libNewSize);
end;

function TMsftStreamPrng001.RemoteCopyTo(const pstm: IStream; cb: _ULARGE_INTEGER; 
                                         out pcbRead: _ULARGE_INTEGER; 
                                         out pcbWritten: _ULARGE_INTEGER): HResult;
begin
  Result := DefaultInterface.RemoteCopyTo(pstm, cb, pcbRead, pcbWritten);
end;

function TMsftStreamPrng001.Commit(grfCommitFlags: LongWord): HResult;
begin
  Result := DefaultInterface.Commit(grfCommitFlags);
end;

function TMsftStreamPrng001.Revert: HResult;
begin
  Result := DefaultInterface.Revert;
end;

function TMsftStreamPrng001.LockRegion(libOffset: _ULARGE_INTEGER; cb: _ULARGE_INTEGER; 
                                       dwLockType: LongWord): HResult;
begin
  Result := DefaultInterface.LockRegion(libOffset, cb, dwLockType);
end;

function TMsftStreamPrng001.UnlockRegion(libOffset: _ULARGE_INTEGER; cb: _ULARGE_INTEGER; 
                                         dwLockType: LongWord): HResult;
begin
  Result := DefaultInterface.UnlockRegion(libOffset, cb, dwLockType);
end;

function TMsftStreamPrng001.Stat(out pstatstg: tagSTATSTG; grfStatFlag: LongWord): HResult;
begin
  Result := DefaultInterface.Stat(pstatstg, grfStatFlag);
end;

function TMsftStreamPrng001.Clone(out ppstm: IStream): HResult;
begin
  Result := DefaultInterface.Clone(ppstm);
end;

function TMsftStreamPrng001.put_Seed(value: LongWord): HResult;
begin
  Result := DefaultInterface.put_Seed(value);
end;

function TMsftStreamPrng001.get_Seed(out value: LongWord): HResult;
begin
  Result := DefaultInterface.get_Seed(value);
end;

function TMsftStreamPrng001.put_ExtendedSeed(var values: LongWord; eCount: LongWord): HResult;
begin
  Result := DefaultInterface.put_ExtendedSeed(values, eCount);
end;

function TMsftStreamPrng001.get_ExtendedSeed(out values: PUINT1; out eCount: LongWord): HResult;
begin
  Result := DefaultInterface.get_ExtendedSeed(values, eCount);
end;

class function CoMsftStreamConcatenate.Create: IStreamConcatenate;
begin
  Result := CreateComObject(CLASS_MsftStreamConcatenate) as IStreamConcatenate;
end;

class function CoMsftStreamConcatenate.CreateRemote(const MachineName: string): IStreamConcatenate;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_MsftStreamConcatenate) as IStreamConcatenate;
end;

procedure TMsftStreamConcatenate.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{27354125-7F64-5B0F-8F00-5D77AFBE261E}';
    IntfIID:   '{27354146-7F64-5B0F-8F00-5D77AFBE261E}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TMsftStreamConcatenate.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IStreamConcatenate;
  end;
end;

procedure TMsftStreamConcatenate.ConnectTo(svrIntf: IStreamConcatenate);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TMsftStreamConcatenate.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TMsftStreamConcatenate.GetDefaultInterface: IStreamConcatenate;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TMsftStreamConcatenate.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TMsftStreamConcatenate.Destroy;
begin
  inherited Destroy;
end;

function TMsftStreamConcatenate.RemoteRead(out pv: Byte; cb: LongWord; out pcbRead: LongWord): HResult;
begin
  Result := DefaultInterface.RemoteRead(pv, cb, pcbRead);
end;

function TMsftStreamConcatenate.RemoteWrite(var pv: Byte; cb: LongWord; out pcbWritten: LongWord): HResult;
begin
  Result := DefaultInterface.RemoteWrite(pv, cb, pcbWritten);
end;

function TMsftStreamConcatenate.RemoteSeek(dlibMove: _LARGE_INTEGER; dwOrigin: LongWord; 
                                           out plibNewPosition: _ULARGE_INTEGER): HResult;
begin
  Result := DefaultInterface.RemoteSeek(dlibMove, dwOrigin, plibNewPosition);
end;

function TMsftStreamConcatenate.SetSize(libNewSize: _ULARGE_INTEGER): HResult;
begin
  Result := DefaultInterface.SetSize(libNewSize);
end;

function TMsftStreamConcatenate.RemoteCopyTo(const pstm: IStream; cb: _ULARGE_INTEGER; 
                                             out pcbRead: _ULARGE_INTEGER; 
                                             out pcbWritten: _ULARGE_INTEGER): HResult;
begin
  Result := DefaultInterface.RemoteCopyTo(pstm, cb, pcbRead, pcbWritten);
end;

function TMsftStreamConcatenate.Commit(grfCommitFlags: LongWord): HResult;
begin
  Result := DefaultInterface.Commit(grfCommitFlags);
end;

function TMsftStreamConcatenate.Revert: HResult;
begin
  Result := DefaultInterface.Revert;
end;

function TMsftStreamConcatenate.LockRegion(libOffset: _ULARGE_INTEGER; cb: _ULARGE_INTEGER; 
                                           dwLockType: LongWord): HResult;
begin
  Result := DefaultInterface.LockRegion(libOffset, cb, dwLockType);
end;

function TMsftStreamConcatenate.UnlockRegion(libOffset: _ULARGE_INTEGER; cb: _ULARGE_INTEGER; 
                                             dwLockType: LongWord): HResult;
begin
  Result := DefaultInterface.UnlockRegion(libOffset, cb, dwLockType);
end;

function TMsftStreamConcatenate.Stat(out pstatstg: tagSTATSTG; grfStatFlag: LongWord): HResult;
begin
  Result := DefaultInterface.Stat(pstatstg, grfStatFlag);
end;

function TMsftStreamConcatenate.Clone(out ppstm: IStream): HResult;
begin
  Result := DefaultInterface.Clone(ppstm);
end;

function TMsftStreamConcatenate.Initialize(const stream1: IStream; const stream2: IStream): HResult;
begin
  Result := DefaultInterface.Initialize(stream1, stream2);
end;

function TMsftStreamConcatenate.Initialize2(var streams: IStream; streamCount: LongWord): HResult;
begin
  Result := DefaultInterface.Initialize2(streams, streamCount);
end;

function TMsftStreamConcatenate.Append(const stream: IStream): HResult;
begin
  Result := DefaultInterface.Append(stream);
end;

function TMsftStreamConcatenate.Append2(var streams: IStream; streamCount: LongWord): HResult;
begin
  Result := DefaultInterface.Append2(streams, streamCount);
end;

class function CoMsftStreamInterleave.Create: IStreamInterleave;
begin
  Result := CreateComObject(CLASS_MsftStreamInterleave) as IStreamInterleave;
end;

class function CoMsftStreamInterleave.CreateRemote(const MachineName: string): IStreamInterleave;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_MsftStreamInterleave) as IStreamInterleave;
end;

procedure TMsftStreamInterleave.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{27354124-7F64-5B0F-8F00-5D77AFBE261E}';
    IntfIID:   '{27354147-7F64-5B0F-8F00-5D77AFBE261E}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TMsftStreamInterleave.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IStreamInterleave;
  end;
end;

procedure TMsftStreamInterleave.ConnectTo(svrIntf: IStreamInterleave);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TMsftStreamInterleave.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TMsftStreamInterleave.GetDefaultInterface: IStreamInterleave;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TMsftStreamInterleave.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TMsftStreamInterleave.Destroy;
begin
  inherited Destroy;
end;

function TMsftStreamInterleave.RemoteRead(out pv: Byte; cb: LongWord; out pcbRead: LongWord): HResult;
begin
  Result := DefaultInterface.RemoteRead(pv, cb, pcbRead);
end;

function TMsftStreamInterleave.RemoteWrite(var pv: Byte; cb: LongWord; out pcbWritten: LongWord): HResult;
begin
  Result := DefaultInterface.RemoteWrite(pv, cb, pcbWritten);
end;

function TMsftStreamInterleave.RemoteSeek(dlibMove: _LARGE_INTEGER; dwOrigin: LongWord; 
                                          out plibNewPosition: _ULARGE_INTEGER): HResult;
begin
  Result := DefaultInterface.RemoteSeek(dlibMove, dwOrigin, plibNewPosition);
end;

function TMsftStreamInterleave.SetSize(libNewSize: _ULARGE_INTEGER): HResult;
begin
  Result := DefaultInterface.SetSize(libNewSize);
end;

function TMsftStreamInterleave.RemoteCopyTo(const pstm: IStream; cb: _ULARGE_INTEGER; 
                                            out pcbRead: _ULARGE_INTEGER; 
                                            out pcbWritten: _ULARGE_INTEGER): HResult;
begin
  Result := DefaultInterface.RemoteCopyTo(pstm, cb, pcbRead, pcbWritten);
end;

function TMsftStreamInterleave.Commit(grfCommitFlags: LongWord): HResult;
begin
  Result := DefaultInterface.Commit(grfCommitFlags);
end;

function TMsftStreamInterleave.Revert: HResult;
begin
  Result := DefaultInterface.Revert;
end;

function TMsftStreamInterleave.LockRegion(libOffset: _ULARGE_INTEGER; cb: _ULARGE_INTEGER; 
                                          dwLockType: LongWord): HResult;
begin
  Result := DefaultInterface.LockRegion(libOffset, cb, dwLockType);
end;

function TMsftStreamInterleave.UnlockRegion(libOffset: _ULARGE_INTEGER; cb: _ULARGE_INTEGER; 
                                            dwLockType: LongWord): HResult;
begin
  Result := DefaultInterface.UnlockRegion(libOffset, cb, dwLockType);
end;

function TMsftStreamInterleave.Stat(out pstatstg: tagSTATSTG; grfStatFlag: LongWord): HResult;
begin
  Result := DefaultInterface.Stat(pstatstg, grfStatFlag);
end;

function TMsftStreamInterleave.Clone(out ppstm: IStream): HResult;
begin
  Result := DefaultInterface.Clone(ppstm);
end;

function TMsftStreamInterleave.Initialize(var streams: IStream; var interleaveSizes: LongWord; 
                                          streamCount: LongWord): HResult;
begin
  Result := DefaultInterface.Initialize(streams, interleaveSizes, streamCount);
end;

class function CoMsftWriteSpeedDescriptor.Create: IWriteSpeedDescriptor;
begin
  Result := CreateComObject(CLASS_MsftWriteSpeedDescriptor) as IWriteSpeedDescriptor;
end;

class function CoMsftWriteSpeedDescriptor.CreateRemote(const MachineName: string): IWriteSpeedDescriptor;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_MsftWriteSpeedDescriptor) as IWriteSpeedDescriptor;
end;

procedure TMsftWriteSpeedDescriptor.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{27354123-7F64-5B0F-8F00-5D77AFBE261E}';
    IntfIID:   '{27354144-7F64-5B0F-8F00-5D77AFBE261E}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TMsftWriteSpeedDescriptor.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IWriteSpeedDescriptor;
  end;
end;

procedure TMsftWriteSpeedDescriptor.ConnectTo(svrIntf: IWriteSpeedDescriptor);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TMsftWriteSpeedDescriptor.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TMsftWriteSpeedDescriptor.GetDefaultInterface: IWriteSpeedDescriptor;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TMsftWriteSpeedDescriptor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TMsftWriteSpeedDescriptor.Destroy;
begin
  inherited Destroy;
end;

function TMsftWriteSpeedDescriptor.Get_MediaType: IMAPI_MEDIA_PHYSICAL_TYPE;
begin
  Result := DefaultInterface.MediaType;
end;

function TMsftWriteSpeedDescriptor.Get_RotationTypeIsPureCAV: WordBool;
begin
  Result := DefaultInterface.RotationTypeIsPureCAV;
end;

function TMsftWriteSpeedDescriptor.Get_WriteSpeed: Integer;
begin
  Result := DefaultInterface.WriteSpeed;
end;

class function CoMsftMultisessionSequential.Create: IMultisessionSequential2;
begin
  Result := CreateComObject(CLASS_MsftMultisessionSequential) as IMultisessionSequential2;
end;

class function CoMsftMultisessionSequential.CreateRemote(const MachineName: string): IMultisessionSequential2;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_MsftMultisessionSequential) as IMultisessionSequential2;
end;

procedure TMsftMultisessionSequential.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{27354122-7F64-5B0F-8F00-5D77AFBE261E}';
    IntfIID:   '{B507CA22-2204-11DD-966A-001AA01BBC58}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TMsftMultisessionSequential.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IMultisessionSequential2;
  end;
end;

procedure TMsftMultisessionSequential.ConnectTo(svrIntf: IMultisessionSequential2);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TMsftMultisessionSequential.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TMsftMultisessionSequential.GetDefaultInterface: IMultisessionSequential2;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TMsftMultisessionSequential.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TMsftMultisessionSequential.Destroy;
begin
  inherited Destroy;
end;

function TMsftMultisessionSequential.Get_IsSupportedOnCurrentMediaState: WordBool;
begin
  Result := DefaultInterface.IsSupportedOnCurrentMediaState;
end;

procedure TMsftMultisessionSequential.Set_InUse(value: WordBool);
begin
  DefaultInterface.InUse := value;
end;

function TMsftMultisessionSequential.Get_InUse: WordBool;
begin
  Result := DefaultInterface.InUse;
end;

function TMsftMultisessionSequential.Get_ImportRecorder: IDiscRecorder2;
begin
  Result := DefaultInterface.ImportRecorder;
end;

function TMsftMultisessionSequential.Get_IsFirstDataSession: WordBool;
begin
  Result := DefaultInterface.IsFirstDataSession;
end;

function TMsftMultisessionSequential.Get_StartAddressOfPreviousSession: Integer;
begin
  Result := DefaultInterface.StartAddressOfPreviousSession;
end;

function TMsftMultisessionSequential.Get_LastWrittenAddressOfPreviousSession: Integer;
begin
  Result := DefaultInterface.LastWrittenAddressOfPreviousSession;
end;

function TMsftMultisessionSequential.Get_NextWritableAddress: Integer;
begin
  Result := DefaultInterface.NextWritableAddress;
end;

function TMsftMultisessionSequential.Get_FreeSectorsOnMedia: Integer;
begin
  Result := DefaultInterface.FreeSectorsOnMedia;
end;

function TMsftMultisessionSequential.Get_WriteUnitSize: Integer;
begin
  Result := DefaultInterface.WriteUnitSize;
end;

class function CoMsftMultisessionRandomWrite.Create: IMultisessionRandomWrite;
begin
  Result := CreateComObject(CLASS_MsftMultisessionRandomWrite) as IMultisessionRandomWrite;
end;

class function CoMsftMultisessionRandomWrite.CreateRemote(const MachineName: string): IMultisessionRandomWrite;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_MsftMultisessionRandomWrite) as IMultisessionRandomWrite;
end;

procedure TMsftMultisessionRandomWrite.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{B507CA24-2204-11DD-966A-001AA01BBC58}';
    IntfIID:   '{B507CA23-2204-11DD-966A-001AA01BBC58}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TMsftMultisessionRandomWrite.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IMultisessionRandomWrite;
  end;
end;

procedure TMsftMultisessionRandomWrite.ConnectTo(svrIntf: IMultisessionRandomWrite);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TMsftMultisessionRandomWrite.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TMsftMultisessionRandomWrite.GetDefaultInterface: IMultisessionRandomWrite;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TMsftMultisessionRandomWrite.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TMsftMultisessionRandomWrite.Destroy;
begin
  inherited Destroy;
end;

function TMsftMultisessionRandomWrite.Get_IsSupportedOnCurrentMediaState: WordBool;
begin
  Result := DefaultInterface.IsSupportedOnCurrentMediaState;
end;

procedure TMsftMultisessionRandomWrite.Set_InUse(value: WordBool);
begin
  DefaultInterface.InUse := value;
end;

function TMsftMultisessionRandomWrite.Get_InUse: WordBool;
begin
  Result := DefaultInterface.InUse;
end;

function TMsftMultisessionRandomWrite.Get_ImportRecorder: IDiscRecorder2;
begin
  Result := DefaultInterface.ImportRecorder;
end;

function TMsftMultisessionRandomWrite.Get_WriteUnitSize: Integer;
begin
  Result := DefaultInterface.WriteUnitSize;
end;

function TMsftMultisessionRandomWrite.Get_LastWrittenAddress: Integer;
begin
  Result := DefaultInterface.LastWrittenAddress;
end;

function TMsftMultisessionRandomWrite.Get_TotalSectorsOnMedia: Integer;
begin
  Result := DefaultInterface.TotalSectorsOnMedia;
end;

class function CoMsftRawCDImageCreator.Create: IRawCDImageCreator;
begin
  Result := CreateComObject(CLASS_MsftRawCDImageCreator) as IRawCDImageCreator;
end;

class function CoMsftRawCDImageCreator.CreateRemote(const MachineName: string): IRawCDImageCreator;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_MsftRawCDImageCreator) as IRawCDImageCreator;
end;

procedure TMsftRawCDImageCreator.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{25983561-9D65-49CE-B335-40630D901227}';
    IntfIID:   '{25983550-9D65-49CE-B335-40630D901227}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TMsftRawCDImageCreator.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IRawCDImageCreator;
  end;
end;

procedure TMsftRawCDImageCreator.ConnectTo(svrIntf: IRawCDImageCreator);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TMsftRawCDImageCreator.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TMsftRawCDImageCreator.GetDefaultInterface: IRawCDImageCreator;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TMsftRawCDImageCreator.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TMsftRawCDImageCreator.Destroy;
begin
  inherited Destroy;
end;

procedure TMsftRawCDImageCreator.Set_ResultingImageType(value: IMAPI_FORMAT2_RAW_CD_DATA_SECTOR_TYPE);
begin
  DefaultInterface.ResultingImageType := value;
end;

function TMsftRawCDImageCreator.Get_ResultingImageType: IMAPI_FORMAT2_RAW_CD_DATA_SECTOR_TYPE;
begin
  Result := DefaultInterface.ResultingImageType;
end;

function TMsftRawCDImageCreator.Get_StartOfLeadout: Integer;
begin
  Result := DefaultInterface.StartOfLeadout;
end;

procedure TMsftRawCDImageCreator.Set_StartOfLeadoutLimit(value: Integer);
begin
  DefaultInterface.StartOfLeadoutLimit := value;
end;

function TMsftRawCDImageCreator.Get_StartOfLeadoutLimit: Integer;
begin
  Result := DefaultInterface.StartOfLeadoutLimit;
end;

procedure TMsftRawCDImageCreator.Set_DisableGaplessAudio(value: WordBool);
begin
  DefaultInterface.DisableGaplessAudio := value;
end;

function TMsftRawCDImageCreator.Get_DisableGaplessAudio: WordBool;
begin
  Result := DefaultInterface.DisableGaplessAudio;
end;

procedure TMsftRawCDImageCreator.Set_MediaCatalogNumber(const value: WideString);
begin
  DefaultInterface.MediaCatalogNumber := value;
end;

function TMsftRawCDImageCreator.Get_MediaCatalogNumber: WideString;
begin
  Result := DefaultInterface.MediaCatalogNumber;
end;

procedure TMsftRawCDImageCreator.Set_StartingTrackNumber(value: Integer);
begin
  DefaultInterface.StartingTrackNumber := value;
end;

function TMsftRawCDImageCreator.Get_StartingTrackNumber: Integer;
begin
  Result := DefaultInterface.StartingTrackNumber;
end;

function TMsftRawCDImageCreator.Get_TrackInfo(trackIndex: Integer): IRawCDImageTrackInfo;
begin
  Result := DefaultInterface.TrackInfo[trackIndex];
end;

function TMsftRawCDImageCreator.Get_NumberOfExistingTracks: Integer;
begin
  Result := DefaultInterface.NumberOfExistingTracks;
end;

function TMsftRawCDImageCreator.Get_LastUsedUserSectorInImage: Integer;
begin
  Result := DefaultInterface.LastUsedUserSectorInImage;
end;

function TMsftRawCDImageCreator.Get_ExpectedTableOfContents: PSafeArray;
begin
  Result := DefaultInterface.ExpectedTableOfContents;
end;

function TMsftRawCDImageCreator.CreateResultImage: IStream;
begin
  Result := DefaultInterface.CreateResultImage;
end;

function TMsftRawCDImageCreator.AddTrack(dataType: IMAPI_CD_SECTOR_TYPE; const data: IStream): Integer;
begin
  Result := DefaultInterface.AddTrack(dataType, data);
end;

procedure TMsftRawCDImageCreator.AddSpecialPregap(const data: IStream);
begin
  DefaultInterface.AddSpecialPregap(data);
end;

procedure TMsftRawCDImageCreator.AddSubcodeRWGenerator(const subcode: IStream);
begin
  DefaultInterface.AddSubcodeRWGenerator(subcode);
end;

procedure Register;
begin
  RegisterComponents(dtlServerPage, [TMsftDiscMaster2, TMsftDiscRecorder2, TMsftWriteEngine2, TMsftDiscFormat2Erase, 
    TMsftDiscFormat2Data, TMsftDiscFormat2TrackAtOnce, TMsftDiscFormat2RawCD, TMsftStreamZero, TMsftStreamPrng001, 
    TMsftStreamConcatenate, TMsftStreamInterleave, TMsftWriteSpeedDescriptor, TMsftMultisessionSequential, TMsftMultisessionRandomWrite, 
    TMsftRawCDImageCreator]);
end;

{$WARNINGS ON}

end.
