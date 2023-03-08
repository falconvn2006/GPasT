unit IMAPI2FS_TLB;

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
// File generated on 13/06/2017 17:59:59 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Windows\system32\imapi2fs.dll (1)
// LIBID: {2C941FD0-975B-59BE-A960-9A2A262853A5}
// LCID: 0
// Helpfile: 
// HelpString: Microsoft IMAPI2 File System Image Creator
// DepndLst: 
//   (1) v2.0 stdole, (C:\Windows\SysWOW64\stdole2.tlb)
// SYS_KIND: SYS_WIN32
// Errors:
//   Hint: Parameter 'object' of DFileSystemImageEvents.Update changed to 'object_'
//   Hint: Parameter 'object' of DFileSystemImageImportEvents.UpdateImport changed to 'object_'
//   Hint: Symbol 'type' renamed to 'type_'
//   Error creating palette bitmap of (TBootOptions) : Server C:\Windows\SysWOW64\imapi2fs.dll contains no icons
//   Error creating palette bitmap of (TFsiStream) : Server C:\Windows\SysWOW64\imapi2fs.dll contains no icons
//   Error creating palette bitmap of (TFileSystemImageResult) : Server C:\Windows\SysWOW64\imapi2fs.dll contains no icons
//   Error creating palette bitmap of (TProgressItem) : Server C:\Windows\SysWOW64\imapi2fs.dll contains no icons
//   Error creating palette bitmap of (TEnumProgressItems) : Server C:\Windows\SysWOW64\imapi2fs.dll contains no icons
//   Error creating palette bitmap of (TProgressItems) : Server C:\Windows\SysWOW64\imapi2fs.dll contains no icons
//   Error creating palette bitmap of (TFsiDirectoryItem) : Server C:\Windows\SysWOW64\imapi2fs.dll contains no icons
//   Error creating palette bitmap of (TFsiFileItem) : Server C:\Windows\SysWOW64\imapi2fs.dll contains no icons
//   Error creating palette bitmap of (TEnumFsiItems) : Server C:\Windows\SysWOW64\imapi2fs.dll contains no icons
//   Error creating palette bitmap of (TFsiNamedStreams) : Server C:\Windows\SysWOW64\imapi2fs.dll contains no icons
//   Error creating palette bitmap of (TMsftFileSystemImage) : Server C:\Windows\SysWOW64\imapi2fs.dll contains no icons
//   Error creating palette bitmap of (TMsftIsoImageManager) : Server C:\Windows\SysWOW64\imapi2fs.dll contains no icons
//   Error creating palette bitmap of (TBlockRange) : Server C:\Windows\SysWOW64\imapi2fs.dll contains no icons
//   Error creating palette bitmap of (TBlockRangeList) : Server C:\Windows\SysWOW64\imapi2fs.dll contains no icons
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
  IMAPI2FSMajorVersion = 1;
  IMAPI2FSMinorVersion = 0;

  LIBID_IMAPI2FS: TGUID = '{2C941FD0-975B-59BE-A960-9A2A262853A5}';

  IID_DFileSystemImageEvents: TGUID = '{2C941FDF-975B-59BE-A960-9A2A262853A5}';
  IID_DFileSystemImageImportEvents: TGUID = '{D25C30F9-4087-4366-9E24-E55BE286424B}';
  IID_IBootOptions: TGUID = '{2C941FD4-975B-59BE-A960-9A2A262853A5}';
  CLASS_BootOptions: TGUID = '{2C941FCE-975B-59BE-A960-9A2A262853A5}';
  IID_ISequentialStream: TGUID = '{0C733A30-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IStream: TGUID = '{0000000C-0000-0000-C000-000000000046}';
  CLASS_FsiStream: TGUID = '{2C941FCD-975B-59BE-A960-9A2A262853A5}';
  IID_IFileSystemImageResult: TGUID = '{2C941FD8-975B-59BE-A960-9A2A262853A5}';
  IID_IFileSystemImageResult2: TGUID = '{B507CA29-2204-11DD-966A-001AA01BBC58}';
  CLASS_FileSystemImageResult: TGUID = '{2C941FCC-975B-59BE-A960-9A2A262853A5}';
  IID_IProgressItems: TGUID = '{2C941FD7-975B-59BE-A960-9A2A262853A5}';
  IID_IProgressItem: TGUID = '{2C941FD5-975B-59BE-A960-9A2A262853A5}';
  IID_IEnumProgressItems: TGUID = '{2C941FD6-975B-59BE-A960-9A2A262853A5}';
  IID_IBlockRangeList: TGUID = '{B507CA26-2204-11DD-966A-001AA01BBC58}';
  CLASS_ProgressItem: TGUID = '{2C941FCB-975B-59BE-A960-9A2A262853A5}';
  CLASS_EnumProgressItems: TGUID = '{2C941FCA-975B-59BE-A960-9A2A262853A5}';
  CLASS_ProgressItems: TGUID = '{2C941FC9-975B-59BE-A960-9A2A262853A5}';
  IID_IFsiItem: TGUID = '{2C941FD9-975B-59BE-A960-9A2A262853A5}';
  IID_IFsiDirectoryItem: TGUID = '{2C941FDC-975B-59BE-A960-9A2A262853A5}';
  IID_IFsiDirectoryItem2: TGUID = '{F7FB4B9B-6D96-4D7B-9115-201B144811EF}';
  CLASS_FsiDirectoryItem: TGUID = '{2C941FC8-975B-59BE-A960-9A2A262853A5}';
  IID_IEnumFsiItems: TGUID = '{2C941FDA-975B-59BE-A960-9A2A262853A5}';
  IID_IFsiFileItem: TGUID = '{2C941FDB-975B-59BE-A960-9A2A262853A5}';
  IID_IFsiFileItem2: TGUID = '{199D0C19-11E1-40EB-8EC2-C8C822A07792}';
  CLASS_FsiFileItem: TGUID = '{2C941FC7-975B-59BE-A960-9A2A262853A5}';
  IID_IFsiNamedStreams: TGUID = '{ED79BA56-5294-4250-8D46-F9AECEE23459}';
  CLASS_EnumFsiItems: TGUID = '{2C941FC6-975B-59BE-A960-9A2A262853A5}';
  CLASS_FsiNamedStreams: TGUID = '{C6B6F8ED-6D19-44B4-B539-B159B793A32D}';
  IID_IFileSystemImage: TGUID = '{2C941FE1-975B-59BE-A960-9A2A262853A5}';
  IID_IFileSystemImage2: TGUID = '{D7644B2C-1537-4767-B62F-F1387B02DDFD}';
  IID_IFileSystemImage3: TGUID = '{7CFF842C-7E97-4807-8304-910DD8F7C051}';
  IID_IConnectionPointContainer: TGUID = '{B196B284-BAB4-101A-B69C-00AA00341D07}';
  IID_IDiscRecorder2: TGUID = '{27354133-7F64-5B0F-8F00-5D77AFBE261E}';
  CLASS_MsftFileSystemImage: TGUID = '{2C941FC5-975B-59BE-A960-9A2A262853A5}';
  IID_IEnumConnectionPoints: TGUID = '{B196B285-BAB4-101A-B69C-00AA00341D07}';
  IID_IConnectionPoint: TGUID = '{B196B286-BAB4-101A-B69C-00AA00341D07}';
  IID_IEnumConnections: TGUID = '{B196B287-BAB4-101A-B69C-00AA00341D07}';
  IID_IIsoImageManager: TGUID = '{6CA38BE5-FBBB-4800-95A1-A438865EB0D4}';
  CLASS_MsftIsoImageManager: TGUID = '{CEEE3B62-8F56-4056-869B-EF16917E3EFC}';
  IID_IBlockRange: TGUID = '{B507CA25-2204-11DD-966A-001AA01BBC58}';
  CLASS_BlockRange: TGUID = '{B507CA27-2204-11DD-966A-001AA01BBC58}';
  CLASS_BlockRangeList: TGUID = '{B507CA28-2204-11DD-966A-001AA01BBC58}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum FsiFileSystems
type
  FsiFileSystems = TOleEnum;
const
  FsiFileSystemNone = $00000000;
  FsiFileSystemISO9660 = $00000001;
  FsiFileSystemJoliet = $00000002;
  FsiFileSystemUDF = $00000004;
  FsiFileSystemUnknown = $40000000;

// Constants for enum PlatformId
type
  PlatformId = TOleEnum;
const
  PlatformX86 = $00000000;
  PlatformPowerPC = $00000001;
  PlatformMac = $00000002;
  PlatformEFI = $000000EF;

// Constants for enum EmulationType
type
  EmulationType = TOleEnum;
const
  EmulationNone = $00000000;
  Emulation12MFloppy = $00000001;
  Emulation144MFloppy = $00000002;
  Emulation288MFloppy = $00000003;
  EmulationHardDisk = $00000004;

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

// Constants for enum FsiItemType
type
  FsiItemType = TOleEnum;
const
  FsiItemNotFound = $00000000;
  FsiItemDirectory = $00000001;
  FsiItemFile = $00000002;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  DFileSystemImageEvents = interface;
  DFileSystemImageImportEvents = interface;
  IBootOptions = interface;
  IBootOptionsDisp = dispinterface;
  ISequentialStream = interface;
  IStream = interface;
  IFileSystemImageResult = interface;
  IFileSystemImageResultDisp = dispinterface;
  IFileSystemImageResult2 = interface;
  IFileSystemImageResult2Disp = dispinterface;
  IProgressItems = interface;
  IProgressItemsDisp = dispinterface;
  IProgressItem = interface;
  IProgressItemDisp = dispinterface;
  IEnumProgressItems = interface;
  IBlockRangeList = interface;
  IBlockRangeListDisp = dispinterface;
  IFsiItem = interface;
  IFsiItemDisp = dispinterface;
  IFsiDirectoryItem = interface;
  IFsiDirectoryItemDisp = dispinterface;
  IFsiDirectoryItem2 = interface;
  IFsiDirectoryItem2Disp = dispinterface;
  IEnumFsiItems = interface;
  IFsiFileItem = interface;
  IFsiFileItemDisp = dispinterface;
  IFsiFileItem2 = interface;
  IFsiFileItem2Disp = dispinterface;
  IFsiNamedStreams = interface;
  IFsiNamedStreamsDisp = dispinterface;
  IFileSystemImage = interface;
  IFileSystemImageDisp = dispinterface;
  IFileSystemImage2 = interface;
  IFileSystemImage2Disp = dispinterface;
  IFileSystemImage3 = interface;
  IFileSystemImage3Disp = dispinterface;
  IConnectionPointContainer = interface;
  IDiscRecorder2 = interface;
  IDiscRecorder2Disp = dispinterface;
  IEnumConnectionPoints = interface;
  IConnectionPoint = interface;
  IEnumConnections = interface;
  IIsoImageManager = interface;
  IBlockRange = interface;
  IBlockRangeDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  BootOptions = IBootOptions;
  FsiStream = IStream;
  FileSystemImageResult = IFileSystemImageResult2;
  ProgressItem = IProgressItem;
  EnumProgressItems = IEnumProgressItems;
  ProgressItems = IProgressItems;
  FsiDirectoryItem = IFsiDirectoryItem2;
  FsiFileItem = IFsiFileItem2;
  EnumFsiItems = IEnumFsiItems;
  FsiNamedStreams = IFsiNamedStreams;
  MsftFileSystemImage = IFileSystemImage3;
  MsftIsoImageManager = IIsoImageManager;
  BlockRange = IBlockRange;
  BlockRangeList = IBlockRangeList;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//
  PByte1 = ^Byte; {*}
  PUserType1 = ^TGUID; {*}

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

  IMAPI_MEDIA_PHYSICAL_TYPE = _IMAPI_MEDIA_PHYSICAL_TYPE; 

{$ALIGN 4}
  tagCONNECTDATA = record
    pUnk: IUnknown;
    dwCookie: LongWord;
  end;


// *********************************************************************//
// Interface: DFileSystemImageEvents
// Flags:     (4480) NonExtensible OleAutomation Dispatchable
// GUID:      {2C941FDF-975B-59BE-A960-9A2A262853A5}
// *********************************************************************//
  DFileSystemImageEvents = interface(IDispatch)
    ['{2C941FDF-975B-59BE-A960-9A2A262853A5}']
    function Update(const object_: IDispatch; const currentFile: WideString; 
                    copiedSectors: Integer; totalSectors: Integer): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: DFileSystemImageImportEvents
// Flags:     (4480) NonExtensible OleAutomation Dispatchable
// GUID:      {D25C30F9-4087-4366-9E24-E55BE286424B}
// *********************************************************************//
  DFileSystemImageImportEvents = interface(IDispatch)
    ['{D25C30F9-4087-4366-9E24-E55BE286424B}']
    function UpdateImport(const object_: IDispatch; fileSystem: FsiFileSystems; 
                          const currentItem: WideString; importedDirectoryItems: Integer; 
                          totalDirectoryItems: Integer; importedFileItems: Integer; 
                          totalFileItems: Integer): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IBootOptions
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {2C941FD4-975B-59BE-A960-9A2A262853A5}
// *********************************************************************//
  IBootOptions = interface(IDispatch)
    ['{2C941FD4-975B-59BE-A960-9A2A262853A5}']
    function Get_BootImage: IStream; safecall;
    function Get_Manufacturer: WideString; safecall;
    procedure Set_Manufacturer(const pVal: WideString); safecall;
    function Get_PlatformId: PlatformId; safecall;
    procedure Set_PlatformId(pVal: PlatformId); safecall;
    function Get_Emulation: EmulationType; safecall;
    procedure Set_Emulation(pVal: EmulationType); safecall;
    function Get_ImageSize: LongWord; safecall;
    procedure AssignBootImage(const newVal: IStream); safecall;
    property BootImage: IStream read Get_BootImage;
    property Manufacturer: WideString read Get_Manufacturer write Set_Manufacturer;
    property PlatformId: PlatformId read Get_PlatformId write Set_PlatformId;
    property Emulation: EmulationType read Get_Emulation write Set_Emulation;
    property ImageSize: LongWord read Get_ImageSize;
  end;

// *********************************************************************//
// DispIntf:  IBootOptionsDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {2C941FD4-975B-59BE-A960-9A2A262853A5}
// *********************************************************************//
  IBootOptionsDisp = dispinterface
    ['{2C941FD4-975B-59BE-A960-9A2A262853A5}']
    property BootImage: IStream readonly dispid 1;
    property Manufacturer: WideString dispid 2;
    property PlatformId: PlatformId dispid 3;
    property Emulation: EmulationType dispid 4;
    property ImageSize: LongWord readonly dispid 5;
    procedure AssignBootImage(const newVal: IStream); dispid 20;
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
// Interface: IFileSystemImageResult
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2C941FD8-975B-59BE-A960-9A2A262853A5}
// *********************************************************************//
  IFileSystemImageResult = interface(IDispatch)
    ['{2C941FD8-975B-59BE-A960-9A2A262853A5}']
    function Get_ImageStream: IStream; safecall;
    function Get_ProgressItems: IProgressItems; safecall;
    function Get_TotalBlocks: Integer; safecall;
    function Get_BlockSize: Integer; safecall;
    function Get_DiscId: WideString; safecall;
    property ImageStream: IStream read Get_ImageStream;
    property ProgressItems: IProgressItems read Get_ProgressItems;
    property TotalBlocks: Integer read Get_TotalBlocks;
    property BlockSize: Integer read Get_BlockSize;
    property DiscId: WideString read Get_DiscId;
  end;

// *********************************************************************//
// DispIntf:  IFileSystemImageResultDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2C941FD8-975B-59BE-A960-9A2A262853A5}
// *********************************************************************//
  IFileSystemImageResultDisp = dispinterface
    ['{2C941FD8-975B-59BE-A960-9A2A262853A5}']
    property ImageStream: IStream readonly dispid 1;
    property ProgressItems: IProgressItems readonly dispid 2;
    property TotalBlocks: Integer readonly dispid 3;
    property BlockSize: Integer readonly dispid 4;
    property DiscId: WideString readonly dispid 5;
  end;

// *********************************************************************//
// Interface: IFileSystemImageResult2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B507CA29-2204-11DD-966A-001AA01BBC58}
// *********************************************************************//
  IFileSystemImageResult2 = interface(IFileSystemImageResult)
    ['{B507CA29-2204-11DD-966A-001AA01BBC58}']
    function Get_ModifiedBlocks: IBlockRangeList; safecall;
    property ModifiedBlocks: IBlockRangeList read Get_ModifiedBlocks;
  end;

// *********************************************************************//
// DispIntf:  IFileSystemImageResult2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B507CA29-2204-11DD-966A-001AA01BBC58}
// *********************************************************************//
  IFileSystemImageResult2Disp = dispinterface
    ['{B507CA29-2204-11DD-966A-001AA01BBC58}']
    property ModifiedBlocks: IBlockRangeList readonly dispid 6;
    property ImageStream: IStream readonly dispid 1;
    property ProgressItems: IProgressItems readonly dispid 2;
    property TotalBlocks: Integer readonly dispid 3;
    property BlockSize: Integer readonly dispid 4;
    property DiscId: WideString readonly dispid 5;
  end;

// *********************************************************************//
// Interface: IProgressItems
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {2C941FD7-975B-59BE-A960-9A2A262853A5}
// *********************************************************************//
  IProgressItems = interface(IDispatch)
    ['{2C941FD7-975B-59BE-A960-9A2A262853A5}']
    function Get__NewEnum: IEnumVARIANT; safecall;
    function Get_Item(Index: Integer): IProgressItem; safecall;
    function Get_Count: Integer; safecall;
    function ProgressItemFromBlock(block: LongWord): IProgressItem; safecall;
    function ProgressItemFromDescription(const Description: WideString): IProgressItem; safecall;
    function Get_EnumProgressItems: IEnumProgressItems; safecall;
    property _NewEnum: IEnumVARIANT read Get__NewEnum;
    property Item[Index: Integer]: IProgressItem read Get_Item; default;
    property Count: Integer read Get_Count;
    property EnumProgressItems: IEnumProgressItems read Get_EnumProgressItems;
  end;

// *********************************************************************//
// DispIntf:  IProgressItemsDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {2C941FD7-975B-59BE-A960-9A2A262853A5}
// *********************************************************************//
  IProgressItemsDisp = dispinterface
    ['{2C941FD7-975B-59BE-A960-9A2A262853A5}']
    property _NewEnum: IEnumVARIANT readonly dispid -4;
    property Item[Index: Integer]: IProgressItem readonly dispid 0; default;
    property Count: Integer readonly dispid 1;
    function ProgressItemFromBlock(block: LongWord): IProgressItem; dispid 2;
    function ProgressItemFromDescription(const Description: WideString): IProgressItem; dispid 3;
    property EnumProgressItems: IEnumProgressItems readonly dispid 4;
  end;

// *********************************************************************//
// Interface: IProgressItem
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {2C941FD5-975B-59BE-A960-9A2A262853A5}
// *********************************************************************//
  IProgressItem = interface(IDispatch)
    ['{2C941FD5-975B-59BE-A960-9A2A262853A5}']
    function Get_Description: WideString; safecall;
    function Get_FirstBlock: LongWord; safecall;
    function Get_LastBlock: LongWord; safecall;
    function Get_BlockCount: LongWord; safecall;
    property Description: WideString read Get_Description;
    property FirstBlock: LongWord read Get_FirstBlock;
    property LastBlock: LongWord read Get_LastBlock;
    property BlockCount: LongWord read Get_BlockCount;
  end;

// *********************************************************************//
// DispIntf:  IProgressItemDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {2C941FD5-975B-59BE-A960-9A2A262853A5}
// *********************************************************************//
  IProgressItemDisp = dispinterface
    ['{2C941FD5-975B-59BE-A960-9A2A262853A5}']
    property Description: WideString readonly dispid 1;
    property FirstBlock: LongWord readonly dispid 2;
    property LastBlock: LongWord readonly dispid 3;
    property BlockCount: LongWord readonly dispid 4;
  end;

// *********************************************************************//
// Interface: IEnumProgressItems
// Flags:     (0)
// GUID:      {2C941FD6-975B-59BE-A960-9A2A262853A5}
// *********************************************************************//
  IEnumProgressItems = interface(IUnknown)
    ['{2C941FD6-975B-59BE-A960-9A2A262853A5}']
    function RemoteNext(celt: LongWord; out rgelt: IProgressItem; out pceltFetched: LongWord): HResult; stdcall;
    function Skip(celt: LongWord): HResult; stdcall;
    function Reset: HResult; stdcall;
    function Clone(out ppEnum: IEnumProgressItems): HResult; stdcall;
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
// Interface: IFsiItem
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2C941FD9-975B-59BE-A960-9A2A262853A5}
// *********************************************************************//
  IFsiItem = interface(IDispatch)
    ['{2C941FD9-975B-59BE-A960-9A2A262853A5}']
    function Get_Name: WideString; safecall;
    function Get_FullPath: WideString; safecall;
    function Get_CreationTime: TDateTime; safecall;
    procedure Set_CreationTime(pVal: TDateTime); safecall;
    function Get_LastAccessedTime: TDateTime; safecall;
    procedure Set_LastAccessedTime(pVal: TDateTime); safecall;
    function Get_LastModifiedTime: TDateTime; safecall;
    procedure Set_LastModifiedTime(pVal: TDateTime); safecall;
    function Get_IsHidden: WordBool; safecall;
    procedure Set_IsHidden(pVal: WordBool); safecall;
    function FileSystemName(fileSystem: FsiFileSystems): WideString; safecall;
    function FileSystemPath(fileSystem: FsiFileSystems): WideString; safecall;
    property Name: WideString read Get_Name;
    property FullPath: WideString read Get_FullPath;
    property CreationTime: TDateTime read Get_CreationTime write Set_CreationTime;
    property LastAccessedTime: TDateTime read Get_LastAccessedTime write Set_LastAccessedTime;
    property LastModifiedTime: TDateTime read Get_LastModifiedTime write Set_LastModifiedTime;
    property IsHidden: WordBool read Get_IsHidden write Set_IsHidden;
  end;

// *********************************************************************//
// DispIntf:  IFsiItemDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2C941FD9-975B-59BE-A960-9A2A262853A5}
// *********************************************************************//
  IFsiItemDisp = dispinterface
    ['{2C941FD9-975B-59BE-A960-9A2A262853A5}']
    property Name: WideString readonly dispid 11;
    property FullPath: WideString readonly dispid 12;
    property CreationTime: TDateTime dispid 13;
    property LastAccessedTime: TDateTime dispid 14;
    property LastModifiedTime: TDateTime dispid 15;
    property IsHidden: WordBool dispid 16;
    function FileSystemName(fileSystem: FsiFileSystems): WideString; dispid 17;
    function FileSystemPath(fileSystem: FsiFileSystems): WideString; dispid 18;
  end;

// *********************************************************************//
// Interface: IFsiDirectoryItem
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2C941FDC-975B-59BE-A960-9A2A262853A5}
// *********************************************************************//
  IFsiDirectoryItem = interface(IFsiItem)
    ['{2C941FDC-975B-59BE-A960-9A2A262853A5}']
    function Get__NewEnum: IEnumVARIANT; safecall;
    function Get_Item(const path: WideString): IFsiItem; safecall;
    function Get_Count: Integer; safecall;
    function Get_EnumFsiItems: IEnumFsiItems; safecall;
    procedure AddDirectory(const path: WideString); safecall;
    procedure AddFile(const path: WideString; const fileData: IStream); safecall;
    procedure AddTree(const sourceDirectory: WideString; includeBaseDirectory: WordBool); safecall;
    procedure Add(const Item: IFsiItem); safecall;
    procedure Remove(const path: WideString); safecall;
    procedure RemoveTree(const path: WideString); safecall;
    property _NewEnum: IEnumVARIANT read Get__NewEnum;
    property Item[const path: WideString]: IFsiItem read Get_Item; default;
    property Count: Integer read Get_Count;
    property EnumFsiItems: IEnumFsiItems read Get_EnumFsiItems;
  end;

// *********************************************************************//
// DispIntf:  IFsiDirectoryItemDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2C941FDC-975B-59BE-A960-9A2A262853A5}
// *********************************************************************//
  IFsiDirectoryItemDisp = dispinterface
    ['{2C941FDC-975B-59BE-A960-9A2A262853A5}']
    property _NewEnum: IEnumVARIANT readonly dispid -4;
    property Item[const path: WideString]: IFsiItem readonly dispid 0; default;
    property Count: Integer readonly dispid 1;
    property EnumFsiItems: IEnumFsiItems readonly dispid 2;
    procedure AddDirectory(const path: WideString); dispid 30;
    procedure AddFile(const path: WideString; const fileData: IStream); dispid 31;
    procedure AddTree(const sourceDirectory: WideString; includeBaseDirectory: WordBool); dispid 32;
    procedure Add(const Item: IFsiItem); dispid 33;
    procedure Remove(const path: WideString); dispid 34;
    procedure RemoveTree(const path: WideString); dispid 35;
    property Name: WideString readonly dispid 11;
    property FullPath: WideString readonly dispid 12;
    property CreationTime: TDateTime dispid 13;
    property LastAccessedTime: TDateTime dispid 14;
    property LastModifiedTime: TDateTime dispid 15;
    property IsHidden: WordBool dispid 16;
    function FileSystemName(fileSystem: FsiFileSystems): WideString; dispid 17;
    function FileSystemPath(fileSystem: FsiFileSystems): WideString; dispid 18;
  end;

// *********************************************************************//
// Interface: IFsiDirectoryItem2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F7FB4B9B-6D96-4D7B-9115-201B144811EF}
// *********************************************************************//
  IFsiDirectoryItem2 = interface(IFsiDirectoryItem)
    ['{F7FB4B9B-6D96-4D7B-9115-201B144811EF}']
    procedure AddTreeWithNamedStreams(const sourceDirectory: WideString; 
                                      includeBaseDirectory: WordBool); safecall;
  end;

// *********************************************************************//
// DispIntf:  IFsiDirectoryItem2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F7FB4B9B-6D96-4D7B-9115-201B144811EF}
// *********************************************************************//
  IFsiDirectoryItem2Disp = dispinterface
    ['{F7FB4B9B-6D96-4D7B-9115-201B144811EF}']
    procedure AddTreeWithNamedStreams(const sourceDirectory: WideString; 
                                      includeBaseDirectory: WordBool); dispid 36;
    property _NewEnum: IEnumVARIANT readonly dispid -4;
    property Item[const path: WideString]: IFsiItem readonly dispid 0; default;
    property Count: Integer readonly dispid 1;
    property EnumFsiItems: IEnumFsiItems readonly dispid 2;
    procedure AddDirectory(const path: WideString); dispid 30;
    procedure AddFile(const path: WideString; const fileData: IStream); dispid 31;
    procedure AddTree(const sourceDirectory: WideString; includeBaseDirectory: WordBool); dispid 32;
    procedure Add(const Item: IFsiItem); dispid 33;
    procedure Remove(const path: WideString); dispid 34;
    procedure RemoveTree(const path: WideString); dispid 35;
    property Name: WideString readonly dispid 11;
    property FullPath: WideString readonly dispid 12;
    property CreationTime: TDateTime dispid 13;
    property LastAccessedTime: TDateTime dispid 14;
    property LastModifiedTime: TDateTime dispid 15;
    property IsHidden: WordBool dispid 16;
    function FileSystemName(fileSystem: FsiFileSystems): WideString; dispid 17;
    function FileSystemPath(fileSystem: FsiFileSystems): WideString; dispid 18;
  end;

// *********************************************************************//
// Interface: IEnumFsiItems
// Flags:     (0)
// GUID:      {2C941FDA-975B-59BE-A960-9A2A262853A5}
// *********************************************************************//
  IEnumFsiItems = interface(IUnknown)
    ['{2C941FDA-975B-59BE-A960-9A2A262853A5}']
    function RemoteNext(celt: LongWord; out rgelt: IFsiItem; out pceltFetched: LongWord): HResult; stdcall;
    function Skip(celt: LongWord): HResult; stdcall;
    function Reset: HResult; stdcall;
    function Clone(out ppEnum: IEnumFsiItems): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IFsiFileItem
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2C941FDB-975B-59BE-A960-9A2A262853A5}
// *********************************************************************//
  IFsiFileItem = interface(IFsiItem)
    ['{2C941FDB-975B-59BE-A960-9A2A262853A5}']
    function Get_DataSize: Int64; safecall;
    function Get_DataSize32BitLow: Integer; safecall;
    function Get_DataSize32BitHigh: Integer; safecall;
    function Get_Data: IStream; safecall;
    procedure Set_Data(const pVal: IStream); safecall;
    property DataSize: Int64 read Get_DataSize;
    property DataSize32BitLow: Integer read Get_DataSize32BitLow;
    property DataSize32BitHigh: Integer read Get_DataSize32BitHigh;
    property Data: IStream read Get_Data write Set_Data;
  end;

// *********************************************************************//
// DispIntf:  IFsiFileItemDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2C941FDB-975B-59BE-A960-9A2A262853A5}
// *********************************************************************//
  IFsiFileItemDisp = dispinterface
    ['{2C941FDB-975B-59BE-A960-9A2A262853A5}']
    property DataSize: Int64 readonly dispid 41;
    property DataSize32BitLow: Integer readonly dispid 42;
    property DataSize32BitHigh: Integer readonly dispid 43;
    property Data: IStream dispid 44;
    property Name: WideString readonly dispid 11;
    property FullPath: WideString readonly dispid 12;
    property CreationTime: TDateTime dispid 13;
    property LastAccessedTime: TDateTime dispid 14;
    property LastModifiedTime: TDateTime dispid 15;
    property IsHidden: WordBool dispid 16;
    function FileSystemName(fileSystem: FsiFileSystems): WideString; dispid 17;
    function FileSystemPath(fileSystem: FsiFileSystems): WideString; dispid 18;
  end;

// *********************************************************************//
// Interface: IFsiFileItem2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {199D0C19-11E1-40EB-8EC2-C8C822A07792}
// *********************************************************************//
  IFsiFileItem2 = interface(IFsiFileItem)
    ['{199D0C19-11E1-40EB-8EC2-C8C822A07792}']
    function Get_FsiNamedStreams: IFsiNamedStreams; safecall;
    function Get_IsNamedStream: WordBool; safecall;
    procedure AddStream(const Name: WideString; const streamData: IStream); safecall;
    procedure RemoveStream(const Name: WideString); safecall;
    function Get_IsRealTime: WordBool; safecall;
    procedure Set_IsRealTime(pVal: WordBool); safecall;
    property FsiNamedStreams: IFsiNamedStreams read Get_FsiNamedStreams;
    property IsNamedStream: WordBool read Get_IsNamedStream;
    property IsRealTime: WordBool read Get_IsRealTime write Set_IsRealTime;
  end;

// *********************************************************************//
// DispIntf:  IFsiFileItem2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {199D0C19-11E1-40EB-8EC2-C8C822A07792}
// *********************************************************************//
  IFsiFileItem2Disp = dispinterface
    ['{199D0C19-11E1-40EB-8EC2-C8C822A07792}']
    property FsiNamedStreams: IFsiNamedStreams readonly dispid 45;
    property IsNamedStream: WordBool readonly dispid 46;
    procedure AddStream(const Name: WideString; const streamData: IStream); dispid 47;
    procedure RemoveStream(const Name: WideString); dispid 48;
    property IsRealTime: WordBool dispid 49;
    property DataSize: Int64 readonly dispid 41;
    property DataSize32BitLow: Integer readonly dispid 42;
    property DataSize32BitHigh: Integer readonly dispid 43;
    property Data: IStream dispid 44;
    property Name: WideString readonly dispid 11;
    property FullPath: WideString readonly dispid 12;
    property CreationTime: TDateTime dispid 13;
    property LastAccessedTime: TDateTime dispid 14;
    property LastModifiedTime: TDateTime dispid 15;
    property IsHidden: WordBool dispid 16;
    function FileSystemName(fileSystem: FsiFileSystems): WideString; dispid 17;
    function FileSystemPath(fileSystem: FsiFileSystems): WideString; dispid 18;
  end;

// *********************************************************************//
// Interface: IFsiNamedStreams
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {ED79BA56-5294-4250-8D46-F9AECEE23459}
// *********************************************************************//
  IFsiNamedStreams = interface(IDispatch)
    ['{ED79BA56-5294-4250-8D46-F9AECEE23459}']
    function Get__NewEnum: IEnumVARIANT; safecall;
    function Get_Item(Index: Integer): IFsiFileItem2; safecall;
    function Get_Count: Integer; safecall;
    function Get_EnumNamedStreams: IEnumFsiItems; safecall;
    property _NewEnum: IEnumVARIANT read Get__NewEnum;
    property Item[Index: Integer]: IFsiFileItem2 read Get_Item; default;
    property Count: Integer read Get_Count;
    property EnumNamedStreams: IEnumFsiItems read Get_EnumNamedStreams;
  end;

// *********************************************************************//
// DispIntf:  IFsiNamedStreamsDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {ED79BA56-5294-4250-8D46-F9AECEE23459}
// *********************************************************************//
  IFsiNamedStreamsDisp = dispinterface
    ['{ED79BA56-5294-4250-8D46-F9AECEE23459}']
    property _NewEnum: IEnumVARIANT readonly dispid -4;
    property Item[Index: Integer]: IFsiFileItem2 readonly dispid 0; default;
    property Count: Integer readonly dispid 81;
    property EnumNamedStreams: IEnumFsiItems readonly dispid 82;
  end;

// *********************************************************************//
// Interface: IFileSystemImage
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2C941FE1-975B-59BE-A960-9A2A262853A5}
// *********************************************************************//
  IFileSystemImage = interface(IDispatch)
    ['{2C941FE1-975B-59BE-A960-9A2A262853A5}']
    function Get_Root: IFsiDirectoryItem; safecall;
    function Get_SessionStartBlock: Integer; safecall;
    procedure Set_SessionStartBlock(pVal: Integer); safecall;
    function Get_FreeMediaBlocks: Integer; safecall;
    procedure Set_FreeMediaBlocks(pVal: Integer); safecall;
    procedure SetMaxMediaBlocksFromDevice(const discRecorder: IDiscRecorder2); safecall;
    function Get_UsedBlocks: Integer; safecall;
    function Get_VolumeName: WideString; safecall;
    procedure Set_VolumeName(const pVal: WideString); safecall;
    function Get_ImportedVolumeName: WideString; safecall;
    function Get_BootImageOptions: IBootOptions; safecall;
    procedure Set_BootImageOptions(const pVal: IBootOptions); safecall;
    function Get_FileCount: Integer; safecall;
    function Get_DirectoryCount: Integer; safecall;
    function Get_WorkingDirectory: WideString; safecall;
    procedure Set_WorkingDirectory(const pVal: WideString); safecall;
    function Get_ChangePoint: Integer; safecall;
    function Get_StrictFileSystemCompliance: WordBool; safecall;
    procedure Set_StrictFileSystemCompliance(pVal: WordBool); safecall;
    function Get_UseRestrictedCharacterSet: WordBool; safecall;
    procedure Set_UseRestrictedCharacterSet(pVal: WordBool); safecall;
    function Get_FileSystemsToCreate: FsiFileSystems; safecall;
    procedure Set_FileSystemsToCreate(pVal: FsiFileSystems); safecall;
    function Get_FileSystemsSupported: FsiFileSystems; safecall;
    procedure Set_UDFRevision(pVal: Integer); safecall;
    function Get_UDFRevision: Integer; safecall;
    function Get_UDFRevisionsSupported: PSafeArray; safecall;
    procedure ChooseImageDefaults(const discRecorder: IDiscRecorder2); safecall;
    procedure ChooseImageDefaultsForMediaType(value: IMAPI_MEDIA_PHYSICAL_TYPE); safecall;
    procedure Set_ISO9660InterchangeLevel(pVal: Integer); safecall;
    function Get_ISO9660InterchangeLevel: Integer; safecall;
    function Get_ISO9660InterchangeLevelsSupported: PSafeArray; safecall;
    function CreateResultImage: IFileSystemImageResult; safecall;
    function Exists(const FullPath: WideString): FsiItemType; safecall;
    function CalculateDiscIdentifier: WideString; safecall;
    function IdentifyFileSystemsOnDisc(const discRecorder: IDiscRecorder2): FsiFileSystems; safecall;
    function GetDefaultFileSystemForImport(fileSystems: FsiFileSystems): FsiFileSystems; safecall;
    function ImportFileSystem: FsiFileSystems; safecall;
    procedure ImportSpecificFileSystem(fileSystemToUse: FsiFileSystems); safecall;
    procedure RollbackToChangePoint(ChangePoint: Integer); safecall;
    procedure LockInChangePoint; safecall;
    function CreateDirectoryItem(const Name: WideString): IFsiDirectoryItem; safecall;
    function CreateFileItem(const Name: WideString): IFsiFileItem; safecall;
    function Get_VolumeNameUDF: WideString; safecall;
    function Get_VolumeNameJoliet: WideString; safecall;
    function Get_VolumeNameISO9660: WideString; safecall;
    function Get_StageFiles: WordBool; safecall;
    procedure Set_StageFiles(pVal: WordBool); safecall;
    function Get_MultisessionInterfaces: PSafeArray; safecall;
    procedure Set_MultisessionInterfaces(pVal: PSafeArray); safecall;
    property Root: IFsiDirectoryItem read Get_Root;
    property SessionStartBlock: Integer read Get_SessionStartBlock write Set_SessionStartBlock;
    property FreeMediaBlocks: Integer read Get_FreeMediaBlocks write Set_FreeMediaBlocks;
    property UsedBlocks: Integer read Get_UsedBlocks;
    property VolumeName: WideString read Get_VolumeName write Set_VolumeName;
    property ImportedVolumeName: WideString read Get_ImportedVolumeName;
    property BootImageOptions: IBootOptions read Get_BootImageOptions write Set_BootImageOptions;
    property FileCount: Integer read Get_FileCount;
    property DirectoryCount: Integer read Get_DirectoryCount;
    property WorkingDirectory: WideString read Get_WorkingDirectory write Set_WorkingDirectory;
    property ChangePoint: Integer read Get_ChangePoint;
    property StrictFileSystemCompliance: WordBool read Get_StrictFileSystemCompliance write Set_StrictFileSystemCompliance;
    property UseRestrictedCharacterSet: WordBool read Get_UseRestrictedCharacterSet write Set_UseRestrictedCharacterSet;
    property FileSystemsToCreate: FsiFileSystems read Get_FileSystemsToCreate write Set_FileSystemsToCreate;
    property FileSystemsSupported: FsiFileSystems read Get_FileSystemsSupported;
    property UDFRevision: Integer read Get_UDFRevision write Set_UDFRevision;
    property UDFRevisionsSupported: PSafeArray read Get_UDFRevisionsSupported;
    property ISO9660InterchangeLevel: Integer read Get_ISO9660InterchangeLevel write Set_ISO9660InterchangeLevel;
    property ISO9660InterchangeLevelsSupported: PSafeArray read Get_ISO9660InterchangeLevelsSupported;
    property VolumeNameUDF: WideString read Get_VolumeNameUDF;
    property VolumeNameJoliet: WideString read Get_VolumeNameJoliet;
    property VolumeNameISO9660: WideString read Get_VolumeNameISO9660;
    property StageFiles: WordBool read Get_StageFiles write Set_StageFiles;
    property MultisessionInterfaces: PSafeArray read Get_MultisessionInterfaces write Set_MultisessionInterfaces;
  end;

// *********************************************************************//
// DispIntf:  IFileSystemImageDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2C941FE1-975B-59BE-A960-9A2A262853A5}
// *********************************************************************//
  IFileSystemImageDisp = dispinterface
    ['{2C941FE1-975B-59BE-A960-9A2A262853A5}']
    property Root: IFsiDirectoryItem readonly dispid 0;
    property SessionStartBlock: Integer dispid 1;
    property FreeMediaBlocks: Integer dispid 2;
    procedure SetMaxMediaBlocksFromDevice(const discRecorder: IDiscRecorder2); dispid 36;
    property UsedBlocks: Integer readonly dispid 3;
    property VolumeName: WideString dispid 4;
    property ImportedVolumeName: WideString readonly dispid 5;
    property BootImageOptions: IBootOptions dispid 6;
    property FileCount: Integer readonly dispid 7;
    property DirectoryCount: Integer readonly dispid 8;
    property WorkingDirectory: WideString dispid 9;
    property ChangePoint: Integer readonly dispid 10;
    property StrictFileSystemCompliance: WordBool dispid 11;
    property UseRestrictedCharacterSet: WordBool dispid 12;
    property FileSystemsToCreate: FsiFileSystems dispid 13;
    property FileSystemsSupported: FsiFileSystems readonly dispid 14;
    property UDFRevision: Integer dispid 37;
    property UDFRevisionsSupported: {NOT_OLEAUTO(PSafeArray)}OleVariant readonly dispid 31;
    procedure ChooseImageDefaults(const discRecorder: IDiscRecorder2); dispid 32;
    procedure ChooseImageDefaultsForMediaType(value: IMAPI_MEDIA_PHYSICAL_TYPE); dispid 33;
    property ISO9660InterchangeLevel: Integer dispid 34;
    property ISO9660InterchangeLevelsSupported: {NOT_OLEAUTO(PSafeArray)}OleVariant readonly dispid 38;
    function CreateResultImage: IFileSystemImageResult; dispid 15;
    function Exists(const FullPath: WideString): FsiItemType; dispid 16;
    function CalculateDiscIdentifier: WideString; dispid 18;
    function IdentifyFileSystemsOnDisc(const discRecorder: IDiscRecorder2): FsiFileSystems; dispid 19;
    function GetDefaultFileSystemForImport(fileSystems: FsiFileSystems): FsiFileSystems; dispid 20;
    function ImportFileSystem: FsiFileSystems; dispid 21;
    procedure ImportSpecificFileSystem(fileSystemToUse: FsiFileSystems); dispid 22;
    procedure RollbackToChangePoint(ChangePoint: Integer); dispid 23;
    procedure LockInChangePoint; dispid 24;
    function CreateDirectoryItem(const Name: WideString): IFsiDirectoryItem; dispid 25;
    function CreateFileItem(const Name: WideString): IFsiFileItem; dispid 26;
    property VolumeNameUDF: WideString readonly dispid 27;
    property VolumeNameJoliet: WideString readonly dispid 28;
    property VolumeNameISO9660: WideString readonly dispid 29;
    property StageFiles: WordBool dispid 30;
    property MultisessionInterfaces: {NOT_OLEAUTO(PSafeArray)}OleVariant dispid 40;
  end;

// *********************************************************************//
// Interface: IFileSystemImage2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D7644B2C-1537-4767-B62F-F1387B02DDFD}
// *********************************************************************//
  IFileSystemImage2 = interface(IFileSystemImage)
    ['{D7644B2C-1537-4767-B62F-F1387B02DDFD}']
    function Get_BootImageOptionsArray: PSafeArray; safecall;
    procedure Set_BootImageOptionsArray(pVal: PSafeArray); safecall;
    property BootImageOptionsArray: PSafeArray read Get_BootImageOptionsArray write Set_BootImageOptionsArray;
  end;

// *********************************************************************//
// DispIntf:  IFileSystemImage2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D7644B2C-1537-4767-B62F-F1387B02DDFD}
// *********************************************************************//
  IFileSystemImage2Disp = dispinterface
    ['{D7644B2C-1537-4767-B62F-F1387B02DDFD}']
    property BootImageOptionsArray: {NOT_OLEAUTO(PSafeArray)}OleVariant dispid 60;
    property Root: IFsiDirectoryItem readonly dispid 0;
    property SessionStartBlock: Integer dispid 1;
    property FreeMediaBlocks: Integer dispid 2;
    procedure SetMaxMediaBlocksFromDevice(const discRecorder: IDiscRecorder2); dispid 36;
    property UsedBlocks: Integer readonly dispid 3;
    property VolumeName: WideString dispid 4;
    property ImportedVolumeName: WideString readonly dispid 5;
    property BootImageOptions: IBootOptions dispid 6;
    property FileCount: Integer readonly dispid 7;
    property DirectoryCount: Integer readonly dispid 8;
    property WorkingDirectory: WideString dispid 9;
    property ChangePoint: Integer readonly dispid 10;
    property StrictFileSystemCompliance: WordBool dispid 11;
    property UseRestrictedCharacterSet: WordBool dispid 12;
    property FileSystemsToCreate: FsiFileSystems dispid 13;
    property FileSystemsSupported: FsiFileSystems readonly dispid 14;
    property UDFRevision: Integer dispid 37;
    property UDFRevisionsSupported: {NOT_OLEAUTO(PSafeArray)}OleVariant readonly dispid 31;
    procedure ChooseImageDefaults(const discRecorder: IDiscRecorder2); dispid 32;
    procedure ChooseImageDefaultsForMediaType(value: IMAPI_MEDIA_PHYSICAL_TYPE); dispid 33;
    property ISO9660InterchangeLevel: Integer dispid 34;
    property ISO9660InterchangeLevelsSupported: {NOT_OLEAUTO(PSafeArray)}OleVariant readonly dispid 38;
    function CreateResultImage: IFileSystemImageResult; dispid 15;
    function Exists(const FullPath: WideString): FsiItemType; dispid 16;
    function CalculateDiscIdentifier: WideString; dispid 18;
    function IdentifyFileSystemsOnDisc(const discRecorder: IDiscRecorder2): FsiFileSystems; dispid 19;
    function GetDefaultFileSystemForImport(fileSystems: FsiFileSystems): FsiFileSystems; dispid 20;
    function ImportFileSystem: FsiFileSystems; dispid 21;
    procedure ImportSpecificFileSystem(fileSystemToUse: FsiFileSystems); dispid 22;
    procedure RollbackToChangePoint(ChangePoint: Integer); dispid 23;
    procedure LockInChangePoint; dispid 24;
    function CreateDirectoryItem(const Name: WideString): IFsiDirectoryItem; dispid 25;
    function CreateFileItem(const Name: WideString): IFsiFileItem; dispid 26;
    property VolumeNameUDF: WideString readonly dispid 27;
    property VolumeNameJoliet: WideString readonly dispid 28;
    property VolumeNameISO9660: WideString readonly dispid 29;
    property StageFiles: WordBool dispid 30;
    property MultisessionInterfaces: {NOT_OLEAUTO(PSafeArray)}OleVariant dispid 40;
  end;

// *********************************************************************//
// Interface: IFileSystemImage3
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7CFF842C-7E97-4807-8304-910DD8F7C051}
// *********************************************************************//
  IFileSystemImage3 = interface(IFileSystemImage2)
    ['{7CFF842C-7E97-4807-8304-910DD8F7C051}']
    function Get_CreateRedundantUdfMetadataFiles: WordBool; safecall;
    procedure Set_CreateRedundantUdfMetadataFiles(pVal: WordBool); safecall;
    function ProbeSpecificFileSystem(fileSystemToProbe: FsiFileSystems): WordBool; safecall;
    property CreateRedundantUdfMetadataFiles: WordBool read Get_CreateRedundantUdfMetadataFiles write Set_CreateRedundantUdfMetadataFiles;
  end;

// *********************************************************************//
// DispIntf:  IFileSystemImage3Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7CFF842C-7E97-4807-8304-910DD8F7C051}
// *********************************************************************//
  IFileSystemImage3Disp = dispinterface
    ['{7CFF842C-7E97-4807-8304-910DD8F7C051}']
    property CreateRedundantUdfMetadataFiles: WordBool dispid 61;
    function ProbeSpecificFileSystem(fileSystemToProbe: FsiFileSystems): WordBool; dispid 70;
    property BootImageOptionsArray: {NOT_OLEAUTO(PSafeArray)}OleVariant dispid 60;
    property Root: IFsiDirectoryItem readonly dispid 0;
    property SessionStartBlock: Integer dispid 1;
    property FreeMediaBlocks: Integer dispid 2;
    procedure SetMaxMediaBlocksFromDevice(const discRecorder: IDiscRecorder2); dispid 36;
    property UsedBlocks: Integer readonly dispid 3;
    property VolumeName: WideString dispid 4;
    property ImportedVolumeName: WideString readonly dispid 5;
    property BootImageOptions: IBootOptions dispid 6;
    property FileCount: Integer readonly dispid 7;
    property DirectoryCount: Integer readonly dispid 8;
    property WorkingDirectory: WideString dispid 9;
    property ChangePoint: Integer readonly dispid 10;
    property StrictFileSystemCompliance: WordBool dispid 11;
    property UseRestrictedCharacterSet: WordBool dispid 12;
    property FileSystemsToCreate: FsiFileSystems dispid 13;
    property FileSystemsSupported: FsiFileSystems readonly dispid 14;
    property UDFRevision: Integer dispid 37;
    property UDFRevisionsSupported: {NOT_OLEAUTO(PSafeArray)}OleVariant readonly dispid 31;
    procedure ChooseImageDefaults(const discRecorder: IDiscRecorder2); dispid 32;
    procedure ChooseImageDefaultsForMediaType(value: IMAPI_MEDIA_PHYSICAL_TYPE); dispid 33;
    property ISO9660InterchangeLevel: Integer dispid 34;
    property ISO9660InterchangeLevelsSupported: {NOT_OLEAUTO(PSafeArray)}OleVariant readonly dispid 38;
    function CreateResultImage: IFileSystemImageResult; dispid 15;
    function Exists(const FullPath: WideString): FsiItemType; dispid 16;
    function CalculateDiscIdentifier: WideString; dispid 18;
    function IdentifyFileSystemsOnDisc(const discRecorder: IDiscRecorder2): FsiFileSystems; dispid 19;
    function GetDefaultFileSystemForImport(fileSystems: FsiFileSystems): FsiFileSystems; dispid 20;
    function ImportFileSystem: FsiFileSystems; dispid 21;
    procedure ImportSpecificFileSystem(fileSystemToUse: FsiFileSystems); dispid 22;
    procedure RollbackToChangePoint(ChangePoint: Integer); dispid 23;
    procedure LockInChangePoint; dispid 24;
    function CreateDirectoryItem(const Name: WideString): IFsiDirectoryItem; dispid 25;
    function CreateFileItem(const Name: WideString): IFsiFileItem; dispid 26;
    property VolumeNameUDF: WideString readonly dispid 27;
    property VolumeNameJoliet: WideString readonly dispid 28;
    property VolumeNameISO9660: WideString readonly dispid 29;
    property StageFiles: WordBool dispid 30;
    property MultisessionInterfaces: {NOT_OLEAUTO(PSafeArray)}OleVariant dispid 40;
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
// Interface: IIsoImageManager
// Flags:     (4096) Dispatchable
// GUID:      {6CA38BE5-FBBB-4800-95A1-A438865EB0D4}
// *********************************************************************//
  IIsoImageManager = interface(IDispatch)
    ['{6CA38BE5-FBBB-4800-95A1-A438865EB0D4}']
    function Get_path(out pVal: WideString): HResult; stdcall;
    function Get_Stream(out Data: IStream): HResult; stdcall;
    function SetPath(const Val: WideString): HResult; stdcall;
    function SetStream(const Data: IStream): HResult; stdcall;
    function Validate: HResult; stdcall;
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
// The Class CoBootOptions provides a Create and CreateRemote method to          
// create instances of the default interface IBootOptions exposed by              
// the CoClass BootOptions. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoBootOptions = class
    class function Create: IBootOptions;
    class function CreateRemote(const MachineName: string): IBootOptions;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TBootOptions
// Help String      : Boot options
// Default Interface: IBootOptions
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TBootOptions = class(TOleServer)
  private
    FIntf: IBootOptions;
    function GetDefaultInterface: IBootOptions;
  protected
    procedure InitServerData; override;
    function Get_BootImage: IStream;
    function Get_Manufacturer: WideString;
    procedure Set_Manufacturer(const pVal: WideString);
    function Get_PlatformId: PlatformId;
    procedure Set_PlatformId(pVal: PlatformId);
    function Get_Emulation: EmulationType;
    procedure Set_Emulation(pVal: EmulationType);
    function Get_ImageSize: LongWord;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IBootOptions);
    procedure Disconnect; override;
    procedure AssignBootImage(const newVal: IStream);
    property DefaultInterface: IBootOptions read GetDefaultInterface;
    property BootImage: IStream read Get_BootImage;
    property ImageSize: LongWord read Get_ImageSize;
    property Manufacturer: WideString read Get_Manufacturer write Set_Manufacturer;
    property PlatformId: PlatformId read Get_PlatformId write Set_PlatformId;
    property Emulation: EmulationType read Get_Emulation write Set_Emulation;
  published
  end;

// *********************************************************************//
// The Class CoFsiStream provides a Create and CreateRemote method to          
// create instances of the default interface IStream exposed by              
// the CoClass FsiStream. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoFsiStream = class
    class function Create: IStream;
    class function CreateRemote(const MachineName: string): IStream;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TFsiStream
// Help String      : Stream
// Default Interface: IStream
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (0)
// *********************************************************************//
  TFsiStream = class(TOleServer)
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
// The Class CoFileSystemImageResult provides a Create and CreateRemote method to          
// create instances of the default interface IFileSystemImageResult2 exposed by              
// the CoClass FileSystemImageResult. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoFileSystemImageResult = class
    class function Create: IFileSystemImageResult2;
    class function CreateRemote(const MachineName: string): IFileSystemImageResult2;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TFileSystemImageResult
// Help String      : FileSystemImage result stream
// Default Interface: IFileSystemImageResult2
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (0)
// *********************************************************************//
  TFileSystemImageResult = class(TOleServer)
  private
    FIntf: IFileSystemImageResult2;
    function GetDefaultInterface: IFileSystemImageResult2;
  protected
    procedure InitServerData; override;
    function Get_ImageStream: IStream;
    function Get_ProgressItems: IProgressItems;
    function Get_TotalBlocks: Integer;
    function Get_BlockSize: Integer;
    function Get_DiscId: WideString;
    function Get_ModifiedBlocks: IBlockRangeList;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IFileSystemImageResult2);
    procedure Disconnect; override;
    property DefaultInterface: IFileSystemImageResult2 read GetDefaultInterface;
    property ImageStream: IStream read Get_ImageStream;
    property ProgressItems: IProgressItems read Get_ProgressItems;
    property TotalBlocks: Integer read Get_TotalBlocks;
    property BlockSize: Integer read Get_BlockSize;
    property DiscId: WideString read Get_DiscId;
    property ModifiedBlocks: IBlockRangeList read Get_ModifiedBlocks;
  published
  end;

// *********************************************************************//
// The Class CoProgressItem provides a Create and CreateRemote method to          
// create instances of the default interface IProgressItem exposed by              
// the CoClass ProgressItem. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoProgressItem = class
    class function Create: IProgressItem;
    class function CreateRemote(const MachineName: string): IProgressItem;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TProgressItem
// Help String      : Progress item block mapping
// Default Interface: IProgressItem
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (0)
// *********************************************************************//
  TProgressItem = class(TOleServer)
  private
    FIntf: IProgressItem;
    function GetDefaultInterface: IProgressItem;
  protected
    procedure InitServerData; override;
    function Get_Description: WideString;
    function Get_FirstBlock: LongWord;
    function Get_LastBlock: LongWord;
    function Get_BlockCount: LongWord;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IProgressItem);
    procedure Disconnect; override;
    property DefaultInterface: IProgressItem read GetDefaultInterface;
    property Description: WideString read Get_Description;
    property FirstBlock: LongWord read Get_FirstBlock;
    property LastBlock: LongWord read Get_LastBlock;
    property BlockCount: LongWord read Get_BlockCount;
  published
  end;

// *********************************************************************//
// The Class CoEnumProgressItems provides a Create and CreateRemote method to          
// create instances of the default interface IEnumProgressItems exposed by              
// the CoClass EnumProgressItems. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoEnumProgressItems = class
    class function Create: IEnumProgressItems;
    class function CreateRemote(const MachineName: string): IEnumProgressItems;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TEnumProgressItems
// Help String      : Progress item block mapping enumerator
// Default Interface: IEnumProgressItems
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (0)
// *********************************************************************//
  TEnumProgressItems = class(TOleServer)
  private
    FIntf: IEnumProgressItems;
    function GetDefaultInterface: IEnumProgressItems;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IEnumProgressItems);
    procedure Disconnect; override;
    function RemoteNext(celt: LongWord; out rgelt: IProgressItem; out pceltFetched: LongWord): HResult;
    function Skip(celt: LongWord): HResult;
    function Reset: HResult;
    function Clone(out ppEnum: IEnumProgressItems): HResult;
    property DefaultInterface: IEnumProgressItems read GetDefaultInterface;
  published
  end;

// *********************************************************************//
// The Class CoProgressItems provides a Create and CreateRemote method to          
// create instances of the default interface IProgressItems exposed by              
// the CoClass ProgressItems. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoProgressItems = class
    class function Create: IProgressItems;
    class function CreateRemote(const MachineName: string): IProgressItems;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TProgressItems
// Help String      : Progress item block mapping collection
// Default Interface: IProgressItems
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (0)
// *********************************************************************//
  TProgressItems = class(TOleServer)
  private
    FIntf: IProgressItems;
    function GetDefaultInterface: IProgressItems;
  protected
    procedure InitServerData; override;
    function Get_Item(Index: Integer): IProgressItem;
    function Get_Count: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IProgressItems);
    procedure Disconnect; override;
    function ProgressItemFromBlock(block: LongWord): IProgressItem;
    function ProgressItemFromDescription(const Description: WideString): IProgressItem;
    property DefaultInterface: IProgressItems read GetDefaultInterface;
    property Item[Index: Integer]: IProgressItem read Get_Item; default;
    property Count: Integer read Get_Count;
  published
  end;

// *********************************************************************//
// The Class CoFsiDirectoryItem provides a Create and CreateRemote method to          
// create instances of the default interface IFsiDirectoryItem2 exposed by              
// the CoClass FsiDirectoryItem. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoFsiDirectoryItem = class
    class function Create: IFsiDirectoryItem2;
    class function CreateRemote(const MachineName: string): IFsiDirectoryItem2;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TFsiDirectoryItem
// Help String      : Directory item
// Default Interface: IFsiDirectoryItem2
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (0)
// *********************************************************************//
  TFsiDirectoryItem = class(TOleServer)
  private
    FIntf: IFsiDirectoryItem2;
    function GetDefaultInterface: IFsiDirectoryItem2;
  protected
    procedure InitServerData; override;
    function Get_Name: WideString;
    function Get_FullPath: WideString;
    function Get_CreationTime: TDateTime;
    procedure Set_CreationTime(pVal: TDateTime);
    function Get_LastAccessedTime: TDateTime;
    procedure Set_LastAccessedTime(pVal: TDateTime);
    function Get_LastModifiedTime: TDateTime;
    procedure Set_LastModifiedTime(pVal: TDateTime);
    function Get_IsHidden: WordBool;
    procedure Set_IsHidden(pVal: WordBool);
    function Get_Item(const path: WideString): IFsiItem;
    function Get_Count: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IFsiDirectoryItem2);
    procedure Disconnect; override;
    function FileSystemName(fileSystem: FsiFileSystems): WideString;
    function FileSystemPath(fileSystem: FsiFileSystems): WideString;
    procedure AddDirectory(const path: WideString);
    procedure AddFile(const path: WideString; const fileData: IStream);
    procedure AddTree(const sourceDirectory: WideString; includeBaseDirectory: WordBool);
    procedure Add(const Item: IFsiItem);
    procedure Remove(const path: WideString);
    procedure RemoveTree(const path: WideString);
    procedure AddTreeWithNamedStreams(const sourceDirectory: WideString; 
                                      includeBaseDirectory: WordBool);
    property DefaultInterface: IFsiDirectoryItem2 read GetDefaultInterface;
    property Name: WideString read Get_Name;
    property FullPath: WideString read Get_FullPath;
    property Item[const path: WideString]: IFsiItem read Get_Item; default;
    property Count: Integer read Get_Count;
    property CreationTime: TDateTime read Get_CreationTime write Set_CreationTime;
    property LastAccessedTime: TDateTime read Get_LastAccessedTime write Set_LastAccessedTime;
    property LastModifiedTime: TDateTime read Get_LastModifiedTime write Set_LastModifiedTime;
    property IsHidden: WordBool read Get_IsHidden write Set_IsHidden;
  published
  end;

// *********************************************************************//
// The Class CoFsiFileItem provides a Create and CreateRemote method to          
// create instances of the default interface IFsiFileItem2 exposed by              
// the CoClass FsiFileItem. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoFsiFileItem = class
    class function Create: IFsiFileItem2;
    class function CreateRemote(const MachineName: string): IFsiFileItem2;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TFsiFileItem
// Help String      : File item
// Default Interface: IFsiFileItem2
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (0)
// *********************************************************************//
  TFsiFileItem = class(TOleServer)
  private
    FIntf: IFsiFileItem2;
    function GetDefaultInterface: IFsiFileItem2;
  protected
    procedure InitServerData; override;
    function Get_Name: WideString;
    function Get_FullPath: WideString;
    function Get_CreationTime: TDateTime;
    procedure Set_CreationTime(pVal: TDateTime);
    function Get_LastAccessedTime: TDateTime;
    procedure Set_LastAccessedTime(pVal: TDateTime);
    function Get_LastModifiedTime: TDateTime;
    procedure Set_LastModifiedTime(pVal: TDateTime);
    function Get_IsHidden: WordBool;
    procedure Set_IsHidden(pVal: WordBool);
    function Get_DataSize: Int64;
    function Get_DataSize32BitLow: Integer;
    function Get_DataSize32BitHigh: Integer;
    function Get_Data: IStream;
    procedure Set_Data(const pVal: IStream);
    function Get_IsNamedStream: WordBool;
    function Get_IsRealTime: WordBool;
    procedure Set_IsRealTime(pVal: WordBool);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IFsiFileItem2);
    procedure Disconnect; override;
    function FileSystemName(fileSystem: FsiFileSystems): WideString;
    function FileSystemPath(fileSystem: FsiFileSystems): WideString;
    procedure AddStream(const Name: WideString; const streamData: IStream);
    procedure RemoveStream(const Name: WideString);
    property DefaultInterface: IFsiFileItem2 read GetDefaultInterface;
    property Name: WideString read Get_Name;
    property FullPath: WideString read Get_FullPath;
    property DataSize: Int64 read Get_DataSize;
    property DataSize32BitLow: Integer read Get_DataSize32BitLow;
    property DataSize32BitHigh: Integer read Get_DataSize32BitHigh;
    property IsNamedStream: WordBool read Get_IsNamedStream;
    property CreationTime: TDateTime read Get_CreationTime write Set_CreationTime;
    property LastAccessedTime: TDateTime read Get_LastAccessedTime write Set_LastAccessedTime;
    property LastModifiedTime: TDateTime read Get_LastModifiedTime write Set_LastModifiedTime;
    property IsHidden: WordBool read Get_IsHidden write Set_IsHidden;
    property Data: IStream read Get_Data write Set_Data;
    property IsRealTime: WordBool read Get_IsRealTime write Set_IsRealTime;
  published
  end;

// *********************************************************************//
// The Class CoEnumFsiItems provides a Create and CreateRemote method to          
// create instances of the default interface IEnumFsiItems exposed by              
// the CoClass EnumFsiItems. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoEnumFsiItems = class
    class function Create: IEnumFsiItems;
    class function CreateRemote(const MachineName: string): IEnumFsiItems;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TEnumFsiItems
// Help String      : FileSystemImage item enumerator
// Default Interface: IEnumFsiItems
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (0)
// *********************************************************************//
  TEnumFsiItems = class(TOleServer)
  private
    FIntf: IEnumFsiItems;
    function GetDefaultInterface: IEnumFsiItems;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IEnumFsiItems);
    procedure Disconnect; override;
    function RemoteNext(celt: LongWord; out rgelt: IFsiItem; out pceltFetched: LongWord): HResult;
    function Skip(celt: LongWord): HResult;
    function Reset: HResult;
    function Clone(out ppEnum: IEnumFsiItems): HResult;
    property DefaultInterface: IEnumFsiItems read GetDefaultInterface;
  published
  end;

// *********************************************************************//
// The Class CoFsiNamedStreams provides a Create and CreateRemote method to          
// create instances of the default interface IFsiNamedStreams exposed by              
// the CoClass FsiNamedStreams. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoFsiNamedStreams = class
    class function Create: IFsiNamedStreams;
    class function CreateRemote(const MachineName: string): IFsiNamedStreams;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TFsiNamedStreams
// Help String      : Named stream collection
// Default Interface: IFsiNamedStreams
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (0)
// *********************************************************************//
  TFsiNamedStreams = class(TOleServer)
  private
    FIntf: IFsiNamedStreams;
    function GetDefaultInterface: IFsiNamedStreams;
  protected
    procedure InitServerData; override;
    function Get_Item(Index: Integer): IFsiFileItem2;
    function Get_Count: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IFsiNamedStreams);
    procedure Disconnect; override;
    property DefaultInterface: IFsiNamedStreams read GetDefaultInterface;
    property Item[Index: Integer]: IFsiFileItem2 read Get_Item; default;
    property Count: Integer read Get_Count;
  published
  end;

// *********************************************************************//
// The Class CoMsftFileSystemImage provides a Create and CreateRemote method to          
// create instances of the default interface IFileSystemImage3 exposed by              
// the CoClass MsftFileSystemImage. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoMsftFileSystemImage = class
    class function Create: IFileSystemImage3;
    class function CreateRemote(const MachineName: string): IFileSystemImage3;
  end;

  TMsftFileSystemImageUpdate = procedure(ASender: TObject; const object_: IDispatch; 
                                                           const currentFile: WideString; 
                                                           copiedSectors: Integer; 
                                                           totalSectors: Integer) of object;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TMsftFileSystemImage
// Help String      : File system image
// Default Interface: IFileSystemImage3
// Def. Intf. DISP? : No
// Event   Interface: DFileSystemImageEvents
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TMsftFileSystemImage = class(TOleServer)
  private
    FOnUpdate: TMsftFileSystemImageUpdate;
    FIntf: IFileSystemImage3;
    function GetDefaultInterface: IFileSystemImage3;
  protected
    procedure InitServerData; override;
    procedure InvokeEvent(DispID: TDispID; var Params: TVariantArray); override;
    function Get_Root: IFsiDirectoryItem;
    function Get_SessionStartBlock: Integer;
    procedure Set_SessionStartBlock(pVal: Integer);
    function Get_FreeMediaBlocks: Integer;
    procedure Set_FreeMediaBlocks(pVal: Integer);
    function Get_UsedBlocks: Integer;
    function Get_VolumeName: WideString;
    procedure Set_VolumeName(const pVal: WideString);
    function Get_ImportedVolumeName: WideString;
    function Get_BootImageOptions: IBootOptions;
    procedure Set_BootImageOptions(const pVal: IBootOptions);
    function Get_FileCount: Integer;
    function Get_DirectoryCount: Integer;
    function Get_WorkingDirectory: WideString;
    procedure Set_WorkingDirectory(const pVal: WideString);
    function Get_ChangePoint: Integer;
    function Get_StrictFileSystemCompliance: WordBool;
    procedure Set_StrictFileSystemCompliance(pVal: WordBool);
    function Get_UseRestrictedCharacterSet: WordBool;
    procedure Set_UseRestrictedCharacterSet(pVal: WordBool);
    function Get_FileSystemsToCreate: FsiFileSystems;
    procedure Set_FileSystemsToCreate(pVal: FsiFileSystems);
    function Get_FileSystemsSupported: FsiFileSystems;
    procedure Set_UDFRevision(pVal: Integer);
    function Get_UDFRevision: Integer;
    function Get_UDFRevisionsSupported: PSafeArray;
    procedure Set_ISO9660InterchangeLevel(pVal: Integer);
    function Get_ISO9660InterchangeLevel: Integer;
    function Get_ISO9660InterchangeLevelsSupported: PSafeArray;
    function Get_VolumeNameUDF: WideString;
    function Get_VolumeNameJoliet: WideString;
    function Get_VolumeNameISO9660: WideString;
    function Get_StageFiles: WordBool;
    procedure Set_StageFiles(pVal: WordBool);
    function Get_MultisessionInterfaces: PSafeArray;
    procedure Set_MultisessionInterfaces(pVal: PSafeArray);
    function Get_BootImageOptionsArray: PSafeArray;
    procedure Set_BootImageOptionsArray(pVal: PSafeArray);
    function Get_CreateRedundantUdfMetadataFiles: WordBool;
    procedure Set_CreateRedundantUdfMetadataFiles(pVal: WordBool);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IFileSystemImage3);
    procedure Disconnect; override;
    procedure SetMaxMediaBlocksFromDevice(const discRecorder: IDiscRecorder2);
    procedure ChooseImageDefaults(const discRecorder: IDiscRecorder2);
    procedure ChooseImageDefaultsForMediaType(value: IMAPI_MEDIA_PHYSICAL_TYPE);
    function CreateResultImage: IFileSystemImageResult;
    function Exists(const FullPath: WideString): FsiItemType;
    function CalculateDiscIdentifier: WideString;
    function IdentifyFileSystemsOnDisc(const discRecorder: IDiscRecorder2): FsiFileSystems;
    function GetDefaultFileSystemForImport(fileSystems: FsiFileSystems): FsiFileSystems;
    function ImportFileSystem: FsiFileSystems;
    procedure ImportSpecificFileSystem(fileSystemToUse: FsiFileSystems);
    procedure RollbackToChangePoint(ChangePoint: Integer);
    procedure LockInChangePoint;
    function CreateDirectoryItem(const Name: WideString): IFsiDirectoryItem;
    function CreateFileItem(const Name: WideString): IFsiFileItem;
    function ProbeSpecificFileSystem(fileSystemToProbe: FsiFileSystems): WordBool;
    property DefaultInterface: IFileSystemImage3 read GetDefaultInterface;
    property Root: IFsiDirectoryItem read Get_Root;
    property UsedBlocks: Integer read Get_UsedBlocks;
    property ImportedVolumeName: WideString read Get_ImportedVolumeName;
    property FileCount: Integer read Get_FileCount;
    property DirectoryCount: Integer read Get_DirectoryCount;
    property ChangePoint: Integer read Get_ChangePoint;
    property FileSystemsSupported: FsiFileSystems read Get_FileSystemsSupported;
    property UDFRevisionsSupported: PSafeArray read Get_UDFRevisionsSupported;
    property ISO9660InterchangeLevelsSupported: PSafeArray read Get_ISO9660InterchangeLevelsSupported;
    property VolumeNameUDF: WideString read Get_VolumeNameUDF;
    property VolumeNameJoliet: WideString read Get_VolumeNameJoliet;
    property VolumeNameISO9660: WideString read Get_VolumeNameISO9660;
    property SessionStartBlock: Integer read Get_SessionStartBlock write Set_SessionStartBlock;
    property FreeMediaBlocks: Integer read Get_FreeMediaBlocks write Set_FreeMediaBlocks;
    property VolumeName: WideString read Get_VolumeName write Set_VolumeName;
    property BootImageOptions: IBootOptions read Get_BootImageOptions write Set_BootImageOptions;
    property WorkingDirectory: WideString read Get_WorkingDirectory write Set_WorkingDirectory;
    property StrictFileSystemCompliance: WordBool read Get_StrictFileSystemCompliance write Set_StrictFileSystemCompliance;
    property UseRestrictedCharacterSet: WordBool read Get_UseRestrictedCharacterSet write Set_UseRestrictedCharacterSet;
    property FileSystemsToCreate: FsiFileSystems read Get_FileSystemsToCreate write Set_FileSystemsToCreate;
    property UDFRevision: Integer read Get_UDFRevision write Set_UDFRevision;
    property ISO9660InterchangeLevel: Integer read Get_ISO9660InterchangeLevel write Set_ISO9660InterchangeLevel;
    property StageFiles: WordBool read Get_StageFiles write Set_StageFiles;
    property MultisessionInterfaces: PSafeArray read Get_MultisessionInterfaces write Set_MultisessionInterfaces;
    property BootImageOptionsArray: PSafeArray read Get_BootImageOptionsArray write Set_BootImageOptionsArray;
    property CreateRedundantUdfMetadataFiles: WordBool read Get_CreateRedundantUdfMetadataFiles write Set_CreateRedundantUdfMetadataFiles;
  published
    property OnUpdate: TMsftFileSystemImageUpdate read FOnUpdate write FOnUpdate;
  end;

// *********************************************************************//
// The Class CoMsftIsoImageManager provides a Create and CreateRemote method to          
// create instances of the default interface IIsoImageManager exposed by              
// the CoClass MsftIsoImageManager. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoMsftIsoImageManager = class
    class function Create: IIsoImageManager;
    class function CreateRemote(const MachineName: string): IIsoImageManager;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TMsftIsoImageManager
// Help String      : Microsoft IMAPIv2 Iso Image Manager
// Default Interface: IIsoImageManager
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TMsftIsoImageManager = class(TOleServer)
  private
    FIntf: IIsoImageManager;
    function GetDefaultInterface: IIsoImageManager;
  protected
    procedure InitServerData; override;
    function Get_path(out pVal: WideString): HResult;
    function Get_Stream(out Data: IStream): HResult;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IIsoImageManager);
    procedure Disconnect; override;
    function SetPath(const Val: WideString): HResult;
    function SetStream(const Data: IStream): HResult;
    function Validate: HResult;
    property DefaultInterface: IIsoImageManager read GetDefaultInterface;
  published
  end;

// *********************************************************************//
// The Class CoBlockRange provides a Create and CreateRemote method to          
// create instances of the default interface IBlockRange exposed by              
// the CoClass BlockRange. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoBlockRange = class
    class function Create: IBlockRange;
    class function CreateRemote(const MachineName: string): IBlockRange;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TBlockRange
// Help String      : A range of LBAs
// Default Interface: IBlockRange
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (0)
// *********************************************************************//
  TBlockRange = class(TOleServer)
  private
    FIntf: IBlockRange;
    function GetDefaultInterface: IBlockRange;
  protected
    procedure InitServerData; override;
    function Get_StartLba: Integer;
    function Get_EndLba: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IBlockRange);
    procedure Disconnect; override;
    property DefaultInterface: IBlockRange read GetDefaultInterface;
    property StartLba: Integer read Get_StartLba;
    property EndLba: Integer read Get_EndLba;
  published
  end;

// *********************************************************************//
// The Class CoBlockRangeList provides a Create and CreateRemote method to          
// create instances of the default interface IBlockRangeList exposed by              
// the CoClass BlockRangeList. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoBlockRangeList = class
    class function Create: IBlockRangeList;
    class function CreateRemote(const MachineName: string): IBlockRangeList;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TBlockRangeList
// Help String      : A list of LBA ranges
// Default Interface: IBlockRangeList
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (0)
// *********************************************************************//
  TBlockRangeList = class(TOleServer)
  private
    FIntf: IBlockRangeList;
    function GetDefaultInterface: IBlockRangeList;
  protected
    procedure InitServerData; override;
    function Get_BlockRanges: PSafeArray;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IBlockRangeList);
    procedure Disconnect; override;
    property DefaultInterface: IBlockRangeList read GetDefaultInterface;
    property BlockRanges: PSafeArray read Get_BlockRanges;
  published
  end;

procedure Register;

resourcestring
  dtlServerPage = 'ActiveX';

  dtlOcxPage = 'ActiveX';

implementation

uses System.Win.ComObj;

class function CoBootOptions.Create: IBootOptions;
begin
  Result := CreateComObject(CLASS_BootOptions) as IBootOptions;
end;

class function CoBootOptions.CreateRemote(const MachineName: string): IBootOptions;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_BootOptions) as IBootOptions;
end;

procedure TBootOptions.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{2C941FCE-975B-59BE-A960-9A2A262853A5}';
    IntfIID:   '{2C941FD4-975B-59BE-A960-9A2A262853A5}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TBootOptions.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IBootOptions;
  end;
end;

procedure TBootOptions.ConnectTo(svrIntf: IBootOptions);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TBootOptions.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TBootOptions.GetDefaultInterface: IBootOptions;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TBootOptions.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TBootOptions.Destroy;
begin
  inherited Destroy;
end;

function TBootOptions.Get_BootImage: IStream;
begin
  Result := DefaultInterface.BootImage;
end;

function TBootOptions.Get_Manufacturer: WideString;
begin
  Result := DefaultInterface.Manufacturer;
end;

procedure TBootOptions.Set_Manufacturer(const pVal: WideString);
begin
  DefaultInterface.Manufacturer := pVal;
end;

function TBootOptions.Get_PlatformId: PlatformId;
begin
  Result := DefaultInterface.PlatformId;
end;

procedure TBootOptions.Set_PlatformId(pVal: PlatformId);
begin
  DefaultInterface.PlatformId := pVal;
end;

function TBootOptions.Get_Emulation: EmulationType;
begin
  Result := DefaultInterface.Emulation;
end;

procedure TBootOptions.Set_Emulation(pVal: EmulationType);
begin
  DefaultInterface.Emulation := pVal;
end;

function TBootOptions.Get_ImageSize: LongWord;
begin
  Result := DefaultInterface.ImageSize;
end;

procedure TBootOptions.AssignBootImage(const newVal: IStream);
begin
  DefaultInterface.AssignBootImage(newVal);
end;

class function CoFsiStream.Create: IStream;
begin
  Result := CreateComObject(CLASS_FsiStream) as IStream;
end;

class function CoFsiStream.CreateRemote(const MachineName: string): IStream;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_FsiStream) as IStream;
end;

procedure TFsiStream.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{2C941FCD-975B-59BE-A960-9A2A262853A5}';
    IntfIID:   '{0000000C-0000-0000-C000-000000000046}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TFsiStream.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IStream;
  end;
end;

procedure TFsiStream.ConnectTo(svrIntf: IStream);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TFsiStream.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TFsiStream.GetDefaultInterface: IStream;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TFsiStream.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TFsiStream.Destroy;
begin
  inherited Destroy;
end;

function TFsiStream.RemoteRead(out pv: Byte; cb: LongWord; out pcbRead: LongWord): HResult;
begin
  Result := DefaultInterface.RemoteRead(pv, cb, pcbRead);
end;

function TFsiStream.RemoteWrite(var pv: Byte; cb: LongWord; out pcbWritten: LongWord): HResult;
begin
  Result := DefaultInterface.RemoteWrite(pv, cb, pcbWritten);
end;

function TFsiStream.RemoteSeek(dlibMove: _LARGE_INTEGER; dwOrigin: LongWord; 
                               out plibNewPosition: _ULARGE_INTEGER): HResult;
begin
  Result := DefaultInterface.RemoteSeek(dlibMove, dwOrigin, plibNewPosition);
end;

function TFsiStream.SetSize(libNewSize: _ULARGE_INTEGER): HResult;
begin
  Result := DefaultInterface.SetSize(libNewSize);
end;

function TFsiStream.RemoteCopyTo(const pstm: IStream; cb: _ULARGE_INTEGER; 
                                 out pcbRead: _ULARGE_INTEGER; out pcbWritten: _ULARGE_INTEGER): HResult;
begin
  Result := DefaultInterface.RemoteCopyTo(pstm, cb, pcbRead, pcbWritten);
end;

function TFsiStream.Commit(grfCommitFlags: LongWord): HResult;
begin
  Result := DefaultInterface.Commit(grfCommitFlags);
end;

function TFsiStream.Revert: HResult;
begin
  Result := DefaultInterface.Revert;
end;

function TFsiStream.LockRegion(libOffset: _ULARGE_INTEGER; cb: _ULARGE_INTEGER; dwLockType: LongWord): HResult;
begin
  Result := DefaultInterface.LockRegion(libOffset, cb, dwLockType);
end;

function TFsiStream.UnlockRegion(libOffset: _ULARGE_INTEGER; cb: _ULARGE_INTEGER; 
                                 dwLockType: LongWord): HResult;
begin
  Result := DefaultInterface.UnlockRegion(libOffset, cb, dwLockType);
end;

function TFsiStream.Stat(out pstatstg: tagSTATSTG; grfStatFlag: LongWord): HResult;
begin
  Result := DefaultInterface.Stat(pstatstg, grfStatFlag);
end;

function TFsiStream.Clone(out ppstm: IStream): HResult;
begin
  Result := DefaultInterface.Clone(ppstm);
end;

class function CoFileSystemImageResult.Create: IFileSystemImageResult2;
begin
  Result := CreateComObject(CLASS_FileSystemImageResult) as IFileSystemImageResult2;
end;

class function CoFileSystemImageResult.CreateRemote(const MachineName: string): IFileSystemImageResult2;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_FileSystemImageResult) as IFileSystemImageResult2;
end;

procedure TFileSystemImageResult.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{2C941FCC-975B-59BE-A960-9A2A262853A5}';
    IntfIID:   '{B507CA29-2204-11DD-966A-001AA01BBC58}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TFileSystemImageResult.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IFileSystemImageResult2;
  end;
end;

procedure TFileSystemImageResult.ConnectTo(svrIntf: IFileSystemImageResult2);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TFileSystemImageResult.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TFileSystemImageResult.GetDefaultInterface: IFileSystemImageResult2;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TFileSystemImageResult.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TFileSystemImageResult.Destroy;
begin
  inherited Destroy;
end;

function TFileSystemImageResult.Get_ImageStream: IStream;
begin
  Result := DefaultInterface.ImageStream;
end;

function TFileSystemImageResult.Get_ProgressItems: IProgressItems;
begin
  Result := DefaultInterface.ProgressItems;
end;

function TFileSystemImageResult.Get_TotalBlocks: Integer;
begin
  Result := DefaultInterface.TotalBlocks;
end;

function TFileSystemImageResult.Get_BlockSize: Integer;
begin
  Result := DefaultInterface.BlockSize;
end;

function TFileSystemImageResult.Get_DiscId: WideString;
begin
  Result := DefaultInterface.DiscId;
end;

function TFileSystemImageResult.Get_ModifiedBlocks: IBlockRangeList;
begin
  Result := DefaultInterface.ModifiedBlocks;
end;

class function CoProgressItem.Create: IProgressItem;
begin
  Result := CreateComObject(CLASS_ProgressItem) as IProgressItem;
end;

class function CoProgressItem.CreateRemote(const MachineName: string): IProgressItem;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ProgressItem) as IProgressItem;
end;

procedure TProgressItem.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{2C941FCB-975B-59BE-A960-9A2A262853A5}';
    IntfIID:   '{2C941FD5-975B-59BE-A960-9A2A262853A5}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TProgressItem.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IProgressItem;
  end;
end;

procedure TProgressItem.ConnectTo(svrIntf: IProgressItem);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TProgressItem.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TProgressItem.GetDefaultInterface: IProgressItem;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TProgressItem.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TProgressItem.Destroy;
begin
  inherited Destroy;
end;

function TProgressItem.Get_Description: WideString;
begin
  Result := DefaultInterface.Description;
end;

function TProgressItem.Get_FirstBlock: LongWord;
begin
  Result := DefaultInterface.FirstBlock;
end;

function TProgressItem.Get_LastBlock: LongWord;
begin
  Result := DefaultInterface.LastBlock;
end;

function TProgressItem.Get_BlockCount: LongWord;
begin
  Result := DefaultInterface.BlockCount;
end;

class function CoEnumProgressItems.Create: IEnumProgressItems;
begin
  Result := CreateComObject(CLASS_EnumProgressItems) as IEnumProgressItems;
end;

class function CoEnumProgressItems.CreateRemote(const MachineName: string): IEnumProgressItems;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_EnumProgressItems) as IEnumProgressItems;
end;

procedure TEnumProgressItems.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{2C941FCA-975B-59BE-A960-9A2A262853A5}';
    IntfIID:   '{2C941FD6-975B-59BE-A960-9A2A262853A5}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TEnumProgressItems.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IEnumProgressItems;
  end;
end;

procedure TEnumProgressItems.ConnectTo(svrIntf: IEnumProgressItems);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TEnumProgressItems.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TEnumProgressItems.GetDefaultInterface: IEnumProgressItems;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TEnumProgressItems.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TEnumProgressItems.Destroy;
begin
  inherited Destroy;
end;

function TEnumProgressItems.RemoteNext(celt: LongWord; out rgelt: IProgressItem; 
                                       out pceltFetched: LongWord): HResult;
begin
  Result := DefaultInterface.RemoteNext(celt, rgelt, pceltFetched);
end;

function TEnumProgressItems.Skip(celt: LongWord): HResult;
begin
  Result := DefaultInterface.Skip(celt);
end;

function TEnumProgressItems.Reset: HResult;
begin
  Result := DefaultInterface.Reset;
end;

function TEnumProgressItems.Clone(out ppEnum: IEnumProgressItems): HResult;
begin
  Result := DefaultInterface.Clone(ppEnum);
end;

class function CoProgressItems.Create: IProgressItems;
begin
  Result := CreateComObject(CLASS_ProgressItems) as IProgressItems;
end;

class function CoProgressItems.CreateRemote(const MachineName: string): IProgressItems;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ProgressItems) as IProgressItems;
end;

procedure TProgressItems.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{2C941FC9-975B-59BE-A960-9A2A262853A5}';
    IntfIID:   '{2C941FD7-975B-59BE-A960-9A2A262853A5}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TProgressItems.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IProgressItems;
  end;
end;

procedure TProgressItems.ConnectTo(svrIntf: IProgressItems);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TProgressItems.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TProgressItems.GetDefaultInterface: IProgressItems;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TProgressItems.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TProgressItems.Destroy;
begin
  inherited Destroy;
end;

function TProgressItems.Get_Item(Index: Integer): IProgressItem;
begin
  Result := DefaultInterface.Item[Index];
end;

function TProgressItems.Get_Count: Integer;
begin
  Result := DefaultInterface.Count;
end;

function TProgressItems.ProgressItemFromBlock(block: LongWord): IProgressItem;
begin
  Result := DefaultInterface.ProgressItemFromBlock(block);
end;

function TProgressItems.ProgressItemFromDescription(const Description: WideString): IProgressItem;
begin
  Result := DefaultInterface.ProgressItemFromDescription(Description);
end;

class function CoFsiDirectoryItem.Create: IFsiDirectoryItem2;
begin
  Result := CreateComObject(CLASS_FsiDirectoryItem) as IFsiDirectoryItem2;
end;

class function CoFsiDirectoryItem.CreateRemote(const MachineName: string): IFsiDirectoryItem2;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_FsiDirectoryItem) as IFsiDirectoryItem2;
end;

procedure TFsiDirectoryItem.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{2C941FC8-975B-59BE-A960-9A2A262853A5}';
    IntfIID:   '{F7FB4B9B-6D96-4D7B-9115-201B144811EF}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TFsiDirectoryItem.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IFsiDirectoryItem2;
  end;
end;

procedure TFsiDirectoryItem.ConnectTo(svrIntf: IFsiDirectoryItem2);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TFsiDirectoryItem.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TFsiDirectoryItem.GetDefaultInterface: IFsiDirectoryItem2;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TFsiDirectoryItem.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TFsiDirectoryItem.Destroy;
begin
  inherited Destroy;
end;

function TFsiDirectoryItem.Get_Name: WideString;
begin
  Result := DefaultInterface.Name;
end;

function TFsiDirectoryItem.Get_FullPath: WideString;
begin
  Result := DefaultInterface.FullPath;
end;

function TFsiDirectoryItem.Get_CreationTime: TDateTime;
begin
  Result := DefaultInterface.CreationTime;
end;

procedure TFsiDirectoryItem.Set_CreationTime(pVal: TDateTime);
begin
  DefaultInterface.CreationTime := pVal;
end;

function TFsiDirectoryItem.Get_LastAccessedTime: TDateTime;
begin
  Result := DefaultInterface.LastAccessedTime;
end;

procedure TFsiDirectoryItem.Set_LastAccessedTime(pVal: TDateTime);
begin
  DefaultInterface.LastAccessedTime := pVal;
end;

function TFsiDirectoryItem.Get_LastModifiedTime: TDateTime;
begin
  Result := DefaultInterface.LastModifiedTime;
end;

procedure TFsiDirectoryItem.Set_LastModifiedTime(pVal: TDateTime);
begin
  DefaultInterface.LastModifiedTime := pVal;
end;

function TFsiDirectoryItem.Get_IsHidden: WordBool;
begin
  Result := DefaultInterface.IsHidden;
end;

procedure TFsiDirectoryItem.Set_IsHidden(pVal: WordBool);
begin
  DefaultInterface.IsHidden := pVal;
end;

function TFsiDirectoryItem.Get_Item(const path: WideString): IFsiItem;
begin
  Result := DefaultInterface.Item[path];
end;

function TFsiDirectoryItem.Get_Count: Integer;
begin
  Result := DefaultInterface.Count;
end;

function TFsiDirectoryItem.FileSystemName(fileSystem: FsiFileSystems): WideString;
begin
  Result := DefaultInterface.FileSystemName(fileSystem);
end;

function TFsiDirectoryItem.FileSystemPath(fileSystem: FsiFileSystems): WideString;
begin
  Result := DefaultInterface.FileSystemPath(fileSystem);
end;

procedure TFsiDirectoryItem.AddDirectory(const path: WideString);
begin
  DefaultInterface.AddDirectory(path);
end;

procedure TFsiDirectoryItem.AddFile(const path: WideString; const fileData: IStream);
begin
  DefaultInterface.AddFile(path, fileData);
end;

procedure TFsiDirectoryItem.AddTree(const sourceDirectory: WideString; 
                                    includeBaseDirectory: WordBool);
begin
  DefaultInterface.AddTree(sourceDirectory, includeBaseDirectory);
end;

procedure TFsiDirectoryItem.Add(const Item: IFsiItem);
begin
  DefaultInterface.Add(Item);
end;

procedure TFsiDirectoryItem.Remove(const path: WideString);
begin
  DefaultInterface.Remove(path);
end;

procedure TFsiDirectoryItem.RemoveTree(const path: WideString);
begin
  DefaultInterface.RemoveTree(path);
end;

procedure TFsiDirectoryItem.AddTreeWithNamedStreams(const sourceDirectory: WideString; 
                                                    includeBaseDirectory: WordBool);
begin
  DefaultInterface.AddTreeWithNamedStreams(sourceDirectory, includeBaseDirectory);
end;

class function CoFsiFileItem.Create: IFsiFileItem2;
begin
  Result := CreateComObject(CLASS_FsiFileItem) as IFsiFileItem2;
end;

class function CoFsiFileItem.CreateRemote(const MachineName: string): IFsiFileItem2;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_FsiFileItem) as IFsiFileItem2;
end;

procedure TFsiFileItem.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{2C941FC7-975B-59BE-A960-9A2A262853A5}';
    IntfIID:   '{199D0C19-11E1-40EB-8EC2-C8C822A07792}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TFsiFileItem.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IFsiFileItem2;
  end;
end;

procedure TFsiFileItem.ConnectTo(svrIntf: IFsiFileItem2);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TFsiFileItem.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TFsiFileItem.GetDefaultInterface: IFsiFileItem2;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TFsiFileItem.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TFsiFileItem.Destroy;
begin
  inherited Destroy;
end;

function TFsiFileItem.Get_Name: WideString;
begin
  Result := DefaultInterface.Name;
end;

function TFsiFileItem.Get_FullPath: WideString;
begin
  Result := DefaultInterface.FullPath;
end;

function TFsiFileItem.Get_CreationTime: TDateTime;
begin
  Result := DefaultInterface.CreationTime;
end;

procedure TFsiFileItem.Set_CreationTime(pVal: TDateTime);
begin
  DefaultInterface.CreationTime := pVal;
end;

function TFsiFileItem.Get_LastAccessedTime: TDateTime;
begin
  Result := DefaultInterface.LastAccessedTime;
end;

procedure TFsiFileItem.Set_LastAccessedTime(pVal: TDateTime);
begin
  DefaultInterface.LastAccessedTime := pVal;
end;

function TFsiFileItem.Get_LastModifiedTime: TDateTime;
begin
  Result := DefaultInterface.LastModifiedTime;
end;

procedure TFsiFileItem.Set_LastModifiedTime(pVal: TDateTime);
begin
  DefaultInterface.LastModifiedTime := pVal;
end;

function TFsiFileItem.Get_IsHidden: WordBool;
begin
  Result := DefaultInterface.IsHidden;
end;

procedure TFsiFileItem.Set_IsHidden(pVal: WordBool);
begin
  DefaultInterface.IsHidden := pVal;
end;

function TFsiFileItem.Get_DataSize: Int64;
begin
  Result := DefaultInterface.DataSize;
end;

function TFsiFileItem.Get_DataSize32BitLow: Integer;
begin
  Result := DefaultInterface.DataSize32BitLow;
end;

function TFsiFileItem.Get_DataSize32BitHigh: Integer;
begin
  Result := DefaultInterface.DataSize32BitHigh;
end;

function TFsiFileItem.Get_Data: IStream;
begin
  Result := DefaultInterface.Data;
end;

procedure TFsiFileItem.Set_Data(const pVal: IStream);
begin
  DefaultInterface.Data := pVal;
end;

function TFsiFileItem.Get_IsNamedStream: WordBool;
begin
  Result := DefaultInterface.IsNamedStream;
end;

function TFsiFileItem.Get_IsRealTime: WordBool;
begin
  Result := DefaultInterface.IsRealTime;
end;

procedure TFsiFileItem.Set_IsRealTime(pVal: WordBool);
begin
  DefaultInterface.IsRealTime := pVal;
end;

function TFsiFileItem.FileSystemName(fileSystem: FsiFileSystems): WideString;
begin
  Result := DefaultInterface.FileSystemName(fileSystem);
end;

function TFsiFileItem.FileSystemPath(fileSystem: FsiFileSystems): WideString;
begin
  Result := DefaultInterface.FileSystemPath(fileSystem);
end;

procedure TFsiFileItem.AddStream(const Name: WideString; const streamData: IStream);
begin
  DefaultInterface.AddStream(Name, streamData);
end;

procedure TFsiFileItem.RemoveStream(const Name: WideString);
begin
  DefaultInterface.RemoveStream(Name);
end;

class function CoEnumFsiItems.Create: IEnumFsiItems;
begin
  Result := CreateComObject(CLASS_EnumFsiItems) as IEnumFsiItems;
end;

class function CoEnumFsiItems.CreateRemote(const MachineName: string): IEnumFsiItems;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_EnumFsiItems) as IEnumFsiItems;
end;

procedure TEnumFsiItems.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{2C941FC6-975B-59BE-A960-9A2A262853A5}';
    IntfIID:   '{2C941FDA-975B-59BE-A960-9A2A262853A5}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TEnumFsiItems.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IEnumFsiItems;
  end;
end;

procedure TEnumFsiItems.ConnectTo(svrIntf: IEnumFsiItems);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TEnumFsiItems.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TEnumFsiItems.GetDefaultInterface: IEnumFsiItems;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TEnumFsiItems.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TEnumFsiItems.Destroy;
begin
  inherited Destroy;
end;

function TEnumFsiItems.RemoteNext(celt: LongWord; out rgelt: IFsiItem; out pceltFetched: LongWord): HResult;
begin
  Result := DefaultInterface.RemoteNext(celt, rgelt, pceltFetched);
end;

function TEnumFsiItems.Skip(celt: LongWord): HResult;
begin
  Result := DefaultInterface.Skip(celt);
end;

function TEnumFsiItems.Reset: HResult;
begin
  Result := DefaultInterface.Reset;
end;

function TEnumFsiItems.Clone(out ppEnum: IEnumFsiItems): HResult;
begin
  Result := DefaultInterface.Clone(ppEnum);
end;

class function CoFsiNamedStreams.Create: IFsiNamedStreams;
begin
  Result := CreateComObject(CLASS_FsiNamedStreams) as IFsiNamedStreams;
end;

class function CoFsiNamedStreams.CreateRemote(const MachineName: string): IFsiNamedStreams;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_FsiNamedStreams) as IFsiNamedStreams;
end;

procedure TFsiNamedStreams.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{C6B6F8ED-6D19-44B4-B539-B159B793A32D}';
    IntfIID:   '{ED79BA56-5294-4250-8D46-F9AECEE23459}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TFsiNamedStreams.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IFsiNamedStreams;
  end;
end;

procedure TFsiNamedStreams.ConnectTo(svrIntf: IFsiNamedStreams);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TFsiNamedStreams.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TFsiNamedStreams.GetDefaultInterface: IFsiNamedStreams;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TFsiNamedStreams.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TFsiNamedStreams.Destroy;
begin
  inherited Destroy;
end;

function TFsiNamedStreams.Get_Item(Index: Integer): IFsiFileItem2;
begin
  Result := DefaultInterface.Item[Index];
end;

function TFsiNamedStreams.Get_Count: Integer;
begin
  Result := DefaultInterface.Count;
end;

class function CoMsftFileSystemImage.Create: IFileSystemImage3;
begin
  Result := CreateComObject(CLASS_MsftFileSystemImage) as IFileSystemImage3;
end;

class function CoMsftFileSystemImage.CreateRemote(const MachineName: string): IFileSystemImage3;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_MsftFileSystemImage) as IFileSystemImage3;
end;

procedure TMsftFileSystemImage.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{2C941FC5-975B-59BE-A960-9A2A262853A5}';
    IntfIID:   '{7CFF842C-7E97-4807-8304-910DD8F7C051}';
    EventIID:  '{2C941FDF-975B-59BE-A960-9A2A262853A5}';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TMsftFileSystemImage.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    ConnectEvents(punk);
    Fintf:= punk as IFileSystemImage3;
  end;
end;

procedure TMsftFileSystemImage.ConnectTo(svrIntf: IFileSystemImage3);
begin
  Disconnect;
  FIntf := svrIntf;
  ConnectEvents(FIntf);
end;

procedure TMsftFileSystemImage.DisConnect;
begin
  if Fintf <> nil then
  begin
    DisconnectEvents(FIntf);
    FIntf := nil;
  end;
end;

function TMsftFileSystemImage.GetDefaultInterface: IFileSystemImage3;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TMsftFileSystemImage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TMsftFileSystemImage.Destroy;
begin
  inherited Destroy;
end;

procedure TMsftFileSystemImage.InvokeEvent(DispID: TDispID; var Params: TVariantArray);
begin
  case DispID of
    -1: Exit;  // DISPID_UNKNOWN
    256: if Assigned(FOnUpdate) then
         FOnUpdate(Self,
                   Params[0] {const IDispatch},
                   Params[1] {const WideString},
                   Params[2] {Integer},
                   Params[3] {Integer});
  end; {case DispID}
end;

function TMsftFileSystemImage.Get_Root: IFsiDirectoryItem;
begin
  Result := DefaultInterface.Root;
end;

function TMsftFileSystemImage.Get_SessionStartBlock: Integer;
begin
  Result := DefaultInterface.SessionStartBlock;
end;

procedure TMsftFileSystemImage.Set_SessionStartBlock(pVal: Integer);
begin
  DefaultInterface.SessionStartBlock := pVal;
end;

function TMsftFileSystemImage.Get_FreeMediaBlocks: Integer;
begin
  Result := DefaultInterface.FreeMediaBlocks;
end;

procedure TMsftFileSystemImage.Set_FreeMediaBlocks(pVal: Integer);
begin
  DefaultInterface.FreeMediaBlocks := pVal;
end;

function TMsftFileSystemImage.Get_UsedBlocks: Integer;
begin
  Result := DefaultInterface.UsedBlocks;
end;

function TMsftFileSystemImage.Get_VolumeName: WideString;
begin
  Result := DefaultInterface.VolumeName;
end;

procedure TMsftFileSystemImage.Set_VolumeName(const pVal: WideString);
begin
  DefaultInterface.VolumeName := pVal;
end;

function TMsftFileSystemImage.Get_ImportedVolumeName: WideString;
begin
  Result := DefaultInterface.ImportedVolumeName;
end;

function TMsftFileSystemImage.Get_BootImageOptions: IBootOptions;
begin
  Result := DefaultInterface.BootImageOptions;
end;

procedure TMsftFileSystemImage.Set_BootImageOptions(const pVal: IBootOptions);
begin
  DefaultInterface.BootImageOptions := pVal;
end;

function TMsftFileSystemImage.Get_FileCount: Integer;
begin
  Result := DefaultInterface.FileCount;
end;

function TMsftFileSystemImage.Get_DirectoryCount: Integer;
begin
  Result := DefaultInterface.DirectoryCount;
end;

function TMsftFileSystemImage.Get_WorkingDirectory: WideString;
begin
  Result := DefaultInterface.WorkingDirectory;
end;

procedure TMsftFileSystemImage.Set_WorkingDirectory(const pVal: WideString);
begin
  DefaultInterface.WorkingDirectory := pVal;
end;

function TMsftFileSystemImage.Get_ChangePoint: Integer;
begin
  Result := DefaultInterface.ChangePoint;
end;

function TMsftFileSystemImage.Get_StrictFileSystemCompliance: WordBool;
begin
  Result := DefaultInterface.StrictFileSystemCompliance;
end;

procedure TMsftFileSystemImage.Set_StrictFileSystemCompliance(pVal: WordBool);
begin
  DefaultInterface.StrictFileSystemCompliance := pVal;
end;

function TMsftFileSystemImage.Get_UseRestrictedCharacterSet: WordBool;
begin
  Result := DefaultInterface.UseRestrictedCharacterSet;
end;

procedure TMsftFileSystemImage.Set_UseRestrictedCharacterSet(pVal: WordBool);
begin
  DefaultInterface.UseRestrictedCharacterSet := pVal;
end;

function TMsftFileSystemImage.Get_FileSystemsToCreate: FsiFileSystems;
begin
  Result := DefaultInterface.FileSystemsToCreate;
end;

procedure TMsftFileSystemImage.Set_FileSystemsToCreate(pVal: FsiFileSystems);
begin
  DefaultInterface.FileSystemsToCreate := pVal;
end;

function TMsftFileSystemImage.Get_FileSystemsSupported: FsiFileSystems;
begin
  Result := DefaultInterface.FileSystemsSupported;
end;

procedure TMsftFileSystemImage.Set_UDFRevision(pVal: Integer);
begin
  DefaultInterface.UDFRevision := pVal;
end;

function TMsftFileSystemImage.Get_UDFRevision: Integer;
begin
  Result := DefaultInterface.UDFRevision;
end;

function TMsftFileSystemImage.Get_UDFRevisionsSupported: PSafeArray;
begin
  Result := DefaultInterface.UDFRevisionsSupported;
end;

procedure TMsftFileSystemImage.Set_ISO9660InterchangeLevel(pVal: Integer);
begin
  DefaultInterface.ISO9660InterchangeLevel := pVal;
end;

function TMsftFileSystemImage.Get_ISO9660InterchangeLevel: Integer;
begin
  Result := DefaultInterface.ISO9660InterchangeLevel;
end;

function TMsftFileSystemImage.Get_ISO9660InterchangeLevelsSupported: PSafeArray;
begin
  Result := DefaultInterface.ISO9660InterchangeLevelsSupported;
end;

function TMsftFileSystemImage.Get_VolumeNameUDF: WideString;
begin
  Result := DefaultInterface.VolumeNameUDF;
end;

function TMsftFileSystemImage.Get_VolumeNameJoliet: WideString;
begin
  Result := DefaultInterface.VolumeNameJoliet;
end;

function TMsftFileSystemImage.Get_VolumeNameISO9660: WideString;
begin
  Result := DefaultInterface.VolumeNameISO9660;
end;

function TMsftFileSystemImage.Get_StageFiles: WordBool;
begin
  Result := DefaultInterface.StageFiles;
end;

procedure TMsftFileSystemImage.Set_StageFiles(pVal: WordBool);
begin
  DefaultInterface.StageFiles := pVal;
end;

function TMsftFileSystemImage.Get_MultisessionInterfaces: PSafeArray;
begin
  Result := DefaultInterface.MultisessionInterfaces;
end;

procedure TMsftFileSystemImage.Set_MultisessionInterfaces(pVal: PSafeArray);
begin
  DefaultInterface.MultisessionInterfaces := pVal;
end;

function TMsftFileSystemImage.Get_BootImageOptionsArray: PSafeArray;
begin
  Result := DefaultInterface.BootImageOptionsArray;
end;

procedure TMsftFileSystemImage.Set_BootImageOptionsArray(pVal: PSafeArray);
begin
  DefaultInterface.BootImageOptionsArray := pVal;
end;

function TMsftFileSystemImage.Get_CreateRedundantUdfMetadataFiles: WordBool;
begin
  Result := DefaultInterface.CreateRedundantUdfMetadataFiles;
end;

procedure TMsftFileSystemImage.Set_CreateRedundantUdfMetadataFiles(pVal: WordBool);
begin
  DefaultInterface.CreateRedundantUdfMetadataFiles := pVal;
end;

procedure TMsftFileSystemImage.SetMaxMediaBlocksFromDevice(const discRecorder: IDiscRecorder2);
begin
  DefaultInterface.SetMaxMediaBlocksFromDevice(discRecorder);
end;

procedure TMsftFileSystemImage.ChooseImageDefaults(const discRecorder: IDiscRecorder2);
begin
  DefaultInterface.ChooseImageDefaults(discRecorder);
end;

procedure TMsftFileSystemImage.ChooseImageDefaultsForMediaType(value: IMAPI_MEDIA_PHYSICAL_TYPE);
begin
  DefaultInterface.ChooseImageDefaultsForMediaType(value);
end;

function TMsftFileSystemImage.CreateResultImage: IFileSystemImageResult;
begin
  Result := DefaultInterface.CreateResultImage;
end;

function TMsftFileSystemImage.Exists(const FullPath: WideString): FsiItemType;
begin
  Result := DefaultInterface.Exists(FullPath);
end;

function TMsftFileSystemImage.CalculateDiscIdentifier: WideString;
begin
  Result := DefaultInterface.CalculateDiscIdentifier;
end;

function TMsftFileSystemImage.IdentifyFileSystemsOnDisc(const discRecorder: IDiscRecorder2): FsiFileSystems;
begin
  Result := DefaultInterface.IdentifyFileSystemsOnDisc(discRecorder);
end;

function TMsftFileSystemImage.GetDefaultFileSystemForImport(fileSystems: FsiFileSystems): FsiFileSystems;
begin
  Result := DefaultInterface.GetDefaultFileSystemForImport(fileSystems);
end;

function TMsftFileSystemImage.ImportFileSystem: FsiFileSystems;
begin
  Result := DefaultInterface.ImportFileSystem;
end;

procedure TMsftFileSystemImage.ImportSpecificFileSystem(fileSystemToUse: FsiFileSystems);
begin
  DefaultInterface.ImportSpecificFileSystem(fileSystemToUse);
end;

procedure TMsftFileSystemImage.RollbackToChangePoint(ChangePoint: Integer);
begin
  DefaultInterface.RollbackToChangePoint(ChangePoint);
end;

procedure TMsftFileSystemImage.LockInChangePoint;
begin
  DefaultInterface.LockInChangePoint;
end;

function TMsftFileSystemImage.CreateDirectoryItem(const Name: WideString): IFsiDirectoryItem;
begin
  Result := DefaultInterface.CreateDirectoryItem(Name);
end;

function TMsftFileSystemImage.CreateFileItem(const Name: WideString): IFsiFileItem;
begin
  Result := DefaultInterface.CreateFileItem(Name);
end;

function TMsftFileSystemImage.ProbeSpecificFileSystem(fileSystemToProbe: FsiFileSystems): WordBool;
begin
  Result := DefaultInterface.ProbeSpecificFileSystem(fileSystemToProbe);
end;

class function CoMsftIsoImageManager.Create: IIsoImageManager;
begin
  Result := CreateComObject(CLASS_MsftIsoImageManager) as IIsoImageManager;
end;

class function CoMsftIsoImageManager.CreateRemote(const MachineName: string): IIsoImageManager;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_MsftIsoImageManager) as IIsoImageManager;
end;

procedure TMsftIsoImageManager.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{CEEE3B62-8F56-4056-869B-EF16917E3EFC}';
    IntfIID:   '{6CA38BE5-FBBB-4800-95A1-A438865EB0D4}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TMsftIsoImageManager.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IIsoImageManager;
  end;
end;

procedure TMsftIsoImageManager.ConnectTo(svrIntf: IIsoImageManager);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TMsftIsoImageManager.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TMsftIsoImageManager.GetDefaultInterface: IIsoImageManager;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TMsftIsoImageManager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TMsftIsoImageManager.Destroy;
begin
  inherited Destroy;
end;

function TMsftIsoImageManager.Get_path(out pVal: WideString): HResult;
begin
  Result := DefaultInterface.Get_path(pVal);
end;

function TMsftIsoImageManager.Get_Stream(out Data: IStream): HResult;
begin
  Result := DefaultInterface.Get_Stream(Data);
end;

function TMsftIsoImageManager.SetPath(const Val: WideString): HResult;
begin
  Result := DefaultInterface.SetPath(Val);
end;

function TMsftIsoImageManager.SetStream(const Data: IStream): HResult;
begin
  Result := DefaultInterface.SetStream(Data);
end;

function TMsftIsoImageManager.Validate: HResult;
begin
  Result := DefaultInterface.Validate;
end;

class function CoBlockRange.Create: IBlockRange;
begin
  Result := CreateComObject(CLASS_BlockRange) as IBlockRange;
end;

class function CoBlockRange.CreateRemote(const MachineName: string): IBlockRange;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_BlockRange) as IBlockRange;
end;

procedure TBlockRange.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{B507CA27-2204-11DD-966A-001AA01BBC58}';
    IntfIID:   '{B507CA25-2204-11DD-966A-001AA01BBC58}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TBlockRange.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IBlockRange;
  end;
end;

procedure TBlockRange.ConnectTo(svrIntf: IBlockRange);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TBlockRange.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TBlockRange.GetDefaultInterface: IBlockRange;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TBlockRange.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TBlockRange.Destroy;
begin
  inherited Destroy;
end;

function TBlockRange.Get_StartLba: Integer;
begin
  Result := DefaultInterface.StartLba;
end;

function TBlockRange.Get_EndLba: Integer;
begin
  Result := DefaultInterface.EndLba;
end;

class function CoBlockRangeList.Create: IBlockRangeList;
begin
  Result := CreateComObject(CLASS_BlockRangeList) as IBlockRangeList;
end;

class function CoBlockRangeList.CreateRemote(const MachineName: string): IBlockRangeList;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_BlockRangeList) as IBlockRangeList;
end;

procedure TBlockRangeList.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{B507CA28-2204-11DD-966A-001AA01BBC58}';
    IntfIID:   '{B507CA26-2204-11DD-966A-001AA01BBC58}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TBlockRangeList.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IBlockRangeList;
  end;
end;

procedure TBlockRangeList.ConnectTo(svrIntf: IBlockRangeList);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TBlockRangeList.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TBlockRangeList.GetDefaultInterface: IBlockRangeList;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TBlockRangeList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TBlockRangeList.Destroy;
begin
  inherited Destroy;
end;

function TBlockRangeList.Get_BlockRanges: PSafeArray;
begin
  Result := DefaultInterface.BlockRanges;
end;

procedure Register;
begin
  RegisterComponents(dtlServerPage, [TBootOptions, TFsiStream, TFileSystemImageResult, TProgressItem, 
    TEnumProgressItems, TProgressItems, TFsiDirectoryItem, TFsiFileItem, TEnumFsiItems, 
    TFsiNamedStreams, TMsftFileSystemImage, TMsftIsoImageManager, TBlockRange, TBlockRangeList]);
end;

end.
