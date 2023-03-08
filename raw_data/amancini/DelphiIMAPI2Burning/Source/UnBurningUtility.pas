unit UnBurningUtility;

interface

uses IMAPI2_TLB,IMAPI2FS_TLB,Winapi.Windows,UnBurningUtility.Types,UnBurningUtility.resource,
     Vcl.ImgList,Vcl.graphics,System.SysUtils,System.Classes,cxImageComboBox,
     Winapi.ActiveX,Vcl.OleServer,WinApi.Messages,AxCtrls,
     vcl.controls,Winapi.ShellApi,vcl.Forms,System.Variants,System.Win.ComObj;

const
  Win32ImportSuffix = {$IFDEF Unicode}'W'{$ELSE}'A'{$ENDIF};
  DEFAULT_MAX_RETRY = 6;

  TIPO_SUPPORT_UNKNOWN            = 0;
  TIPO_SUPPORT_CD                 = 1;
  TIPO_SUPPORT_DVD                = 2;
  TIPO_SUPPORT_BDR                = 4;
  TIPO_SUPPORT_ISO                = 5;
  TIPO_SUPPORT_DVD_DL             = 10;

  function GetVolumeNameForVolumeMountPointA(lpszVolumeMountPoint: PAnsiChar;lpszVolumeName: PAnsiChar; cchBufferLength: DWORD): BOOL; stdcall; external 'kernel32.dll';
  function GetVolumeNameForVolumeMountPointW(lpszVolumeMountPoint: PWideChar;lpszVolumeName: PWideChar; cchBufferLength: DWORD): BOOL; stdcall; external 'kernel32.dll';
  function GetVolumeNameForVolumeMountPoint(lpszVolumeMountPoint: PChar;lpszVolumeName: PChar; cchBufferLength: DWORD): BOOL; stdcall; external 'kernel32.dll' name 'GetVolumeNameForVolumeMountPoint' + Win32ImportSuffix;
  Function SHCreateStreamOnFileEx( pszFile: PWChar; grfMode:DWORD; dwAttributes:DWORD;fCreate:BOOL; pstmTemplate:IStream; var ppstm:IStream):DWORD;stdcall; external 'shlwapi.dll' name 'SHCreateStreamOnFileEx';

type

  TOnProgressBurn  = procedure(Sender:Tobject;Const SInfo:String;SPosition :Int64;RefreshPosition,aAbort:Boolean;iType:integer;AllowAbort:Boolean) of OBject;
  TOnLog           = procedure(Const aFunctionName,aDescritionName:String;Level:TpLivLog;IsDebug:Boolean=False)of OBject;
  TBurningTool = class(TObject)
    procedure MsftDiscFormat2DataUpdate(ASender: TObject; const object_,
    progress: IDispatch);
    procedure MsftEraseDataUpdate(ASender: TObject; const object_: IDispatch;
      elapsedSeconds, estimatedTotalSeconds: Integer);
  private
    FListaDriveCD           : TStringList;
    FCancelWriting          : Boolean;
    FListaDriveDVD          : TStringList;
    FListaDriveDVD_DL       : TStringList;
    FListaDriveBDR          : TStringList;
    FListaDriveCD_DL        : TStringList;
    FDiriverList            : TStringList;
    FimgListSysSmall        : TImageList;
    FWriting                : Boolean;
    FLastuniqueId           : WideString;
    FDiscMaster             : TMsftDiscMaster2;
    FDiscRecord             : TMsftDiscRecorder2;
    FOnProgressBurn         : TOnProgressBurn;
    FAbort                  : Boolean;
    FCurrentWriter          : TMsftDiscFormat2Data;
    FOnLog                  : TOnLog;
    FEraseCDAuto            : Boolean;
    FCanErase               : Boolean;
    procedure BuildListDrivesOfType;
    function GetCanBurnCD: Boolean;
    function GetCanBurnCD_DL: Boolean;
    function GetCanBurnDVD: Boolean;
    function GetCanBurnDVD_DL: Boolean;
    function GetCanBurnDBR: Boolean;
    function GetSystemCanBurn: Boolean;
    function ActiveDiskRecorder(IdexDriver: Integer): Boolean;
    function IntFRecordAssigned: Boolean;
    function IntFDiskMasterAssigned: Boolean;
    function IntFWriterAssigned(var aDataWriter:TMsftDiscFormat2Data): Boolean;
    function FoundLetterDrive(aIndex: Integer;var aLetterDrive: String): Boolean;
    function IsDriverRW(aDriveIndex: Integer;aSupportType:Integer): Boolean;
    function CheckMedia(var DataWriter:TMsftDiscFormat2Data;IdexDriver: integer;ChecStatus : Array of Word;var ErrorDisc:boolean;Var CurrentStatatus:Word): Boolean;
    function isDiskEmpty(var DataWriter:TMsftDiscFormat2Data;IdexDriver:integer;var ErrorMedia : Boolean) : Boolean;
    function isDiskWritable(var DataWriter:TMsftDiscFormat2Data;IdexDriver: integer;var ErrorMedia: Boolean): Boolean;
    function CheckMediaBySupport(aIdexDriver, aSupportType: integer;var aIsRW:Boolean;var aDataWriter:TMsftDiscFormat2Data): Boolean;
    function DiskIsPresentOnDrive(IdexDriver:Integer;var DataWriter:TMsftDiscFormat2Data): Boolean;
    procedure DoOnProgressBurnCustom(Const SInfo: String;AllowAbort:Boolean=True);
    function GetDriveTypeLabel(Const DriveChar: String): string;
    procedure IsWrittableDriver(SupportedProfiles: PSafeArray; var WCd, WDVD,WBDR,WDvd_DL,wCD_DL: Boolean);
    procedure IsRecordableDriver(SupportedFeaturePages: PSafeArray; var WCd,WDVD, WBDR,WDvd_DL,wCD_DL: Boolean);
    procedure BuildListDriverType(VolumeName: WideString; Wcd, Wdvd, Wbdr,WdvdDL,wCD_DL: Boolean; idx: Integer);
    function SetBurnVerification(var DataWriter: TMsftDiscFormat2Data; VerificationLevel: IMAPI_BURN_VERIFICATION_LEVEL): Boolean;
    function CheckAssignedAndActivationDrive(IndexDriver: Integer): Boolean;
    function MngInsertDisk(aIdexDriver, aSupportType: Integer;var aDataWriter: TMsftDiscFormat2Data; const aLetterDrive: String;var aIRetry:Integer): Boolean;
    procedure CreateImageListIconSystem;
    procedure CreateInterListDriveByType;
    procedure SearchRecordableDriver;
    procedure WriteIso(var aDataWriter: TMsftDiscFormat2Data;aIndexDriver,aSupportType:Integer; const aCaptionDisk,aPathIso: string;var aStatusWrite : TStatusBurn);
    procedure BuilcxComboBox(ItemsCxComboBox: TcximageComboBoxItems;
      DriverList: TStringList);
    function GetMaxWriteSectorsPerSecondSupported(const aDataWriter: TMsftDiscFormat2Data; aIndexDriver,aSupportType: Integer): IntegeR;
    procedure CancelWriting;
    function GetHumanSpeedWrite(aSectorForSecond: Integer;aSupportType:Integer): string;
    procedure WriteLog(const aFunctionName,aDescritionName: String; Level: TpLivLog;IsDebug: Boolean=False);
    function SecondToTime(const Seconds: Cardinal): Double;
  public
    constructor Create;
    destructor Destroy; override;
    {IMAPI funzioni}
    Function BurningDiskImage(aIdexDriver,aSupportType:Integer;Const aSPathIso,aCaptionDisk:String;aCheckDisk:Boolean): TStatusBurn;
    Function DriveEject(IdexDriver:Integer) : Boolean;
    function EraseDisk(IdexDriver,aSupportType: Integer;Eject:Boolean):Boolean;
    function CloseTray(IdexDriver: Integer): Boolean;
    Function GetIndexCDROM(const aLetter:String):Integer;
    procedure CancelBurning;
    function CreateIsoImage(const FolderToAdd: String; VolumeName: String;const ResultFile: String; IMAPIDisc: IMAPI_MEDIA_PHYSICAL_TYPE): Boolean;
    {build combo driver}
    Function GetBitmapDriver(const Drive: String):Integer;
    procedure BuildItemCD(ItemsCxComboBox:TcximageComboBoxItems);
    procedure BuildItemCD_DL(ItemsCxComboBox: TcximageComboBoxItems);
    procedure BuildItemDVD(ItemsCxComboBox:TcximageComboBoxItems);
    procedure BuildItemBDR(ItemsCxComboBox:TcximageComboBoxItems);
    procedure BuildItemDVD_DL(ItemsCxComboBox: TcximageComboBoxItems);
    procedure BuilcxComboBoxAll(ItemsCxComboBox: TcximageComboBoxItems);
    {Property}
    Property CanBurnCD      : Boolean         read GetCanBurnCD;
    Property CanBurnCD_DL   : Boolean         read GetCanBurnCD_DL;
    Property CanBurnDVD     : Boolean         read GetCanBurnDVD;
    Property CanBurnDVD_DL  : Boolean         read GetCanBurnDVD_DL;
    Property CanBurnBDR     : Boolean         read GetCanBurnDBR;
    property SystemCanBurn  : Boolean         read GetSystemCanBurn;
    property ImageListDriver: TImageList      read FimgListSysSmall;
    property EraseCDAuto    : Boolean         read FEraseCDAuto write FEraseCDAuto;
    property CanErase       : Boolean         read FCanErase write FCanErase;    
    {Eventi}
    property OnProgressBurn : TOnProgressBurn read FOnProgressBurn    Write FOnProgressBurn;
    property OnLog          : TonLog          read FOnLog             write FOnLog;
  end;

implementation


{ BurningTool }

Procedure TBurningTool.WriteLog(Const aFunctionName,aDescritionName:String;Level:TpLivLog;IsDebug:Boolean=False);
begin
  if Assigned(FOnLog) then  
    FOnLog(aFunctionName,aDescritionName,Level,IsDebug);
end;

function TBurningTool.CreateIsoImage(const FolderToAdd: String;VolumeName:String;Const ResultFile:String;IMAPIDisc:IMAPI_MEDIA_PHYSICAL_TYPE): Boolean;
var FSI           : TMsftFileSystemImage;
    Dir           : IFsiDirectoryItem;
    isoFileInt    : IFileSystemImageResult;
    IStreamValue  : IStream;
    OleStream     : TOleStream;
    FileStream    : TFileStream;
begin
  Result := False;
  Try
    FSI    := TMsftFileSystemImage.Create(nil);
    Try
      Dir := FSI.Root;
      FSI.ChooseImageDefaultsForMediaType(IMAPIDisc);
      FSI.FileSystemsToCreate := FsiFileSystemUDF;
      FSI.VolumeName          := VolumeName;

      {Add the directory and its contents to the file system}
      Dir.AddTree(FolderToAdd,False);

      {Create an image from the file system}
      isoFileInt   := FSI.CreateResultImage();
      IStreamValue := IStream(isoFileInt.ImageStream);
      OleStream    := TOleStream.Create(IStreamValue);
      try
        FileStream := TFileStream.Create(ResultFile, fmCreate);
        try
          OleStream.Position:= 0;
          FileStream.CopyFrom(OleStream, OleStream.Size);
          Result := True;
        finally
          FileStream.Free;
        end;
      finally
        OleStream.Free;
      end;

    Finally
      FSI.Free;
    End;
  Except on E : Exception do
    {$REGION 'Log'}
    {TSI:IGNORE ON}
       WriteLog('TBurningTool.CreateIsoImage',E.Message,tplivException);
    {TSI:IGNORE OFF}
    {$ENDREGION}
  End;
end;

Procedure TBurningTool.CancelBurning;
begin
  FAbort := True;
  DoOnProgressBurnCustom(Burning_Aboring);
  if FWriting and Assigned(FCurrentWriter) then
    CancelWriting
  else
  begin
    if not FCancelWriting then
    begin
      if Assigned(FOnProgressBurn) then
        FOnProgressBurn(self,'',0,True,True,0,True);
    end
    else
      {$REGION 'Log'}
      {TSI:IGNORE ON}
        WriteLog('BurningTool.CancelBurning','Not call cancel writing wait end',tpLivWarning);
      {TSI:IGNORE OFF}
      {$ENDREGION}
  end;
end;

procedure TBurningTool.BuildItemCD_DL(ItemsCxComboBox: TcximageComboBoxItems);
begin
  BuilcxComboBox(ItemsCxComboBox,FListaDriveCD_DL);
end;

procedure TBurningTool.BuildItemBDR(ItemsCxComboBox: TcximageComboBoxItems);
begin
  BuilcxComboBox(ItemsCxComboBox,FListaDriveBDR);
end;

procedure TBurningTool.BuildItemCD(ItemsCxComboBox: TcximageComboBoxItems);
begin
  BuilcxComboBox(ItemsCxComboBox,FListaDriveCD)
end;

procedure TBurningTool.BuildItemDVD(ItemsCxComboBox: TcximageComboBoxItems);
begin
  BuilcxComboBox(ItemsCxComboBox,FListaDriveDVD)
end;

procedure TBurningTool.BuildItemDVD_DL(ItemsCxComboBox: TcximageComboBoxItems);
begin
  BuilcxComboBox(ItemsCxComboBox,FListaDriveDVD_DL)
end;

Procedure TBurningTool.BuilcxComboBox(ItemsCxComboBox: TcximageComboBoxItems;DriverList:TStringList);
var I                     : Integer;
    CurrentItemCxComboBox : TcxImageComboBoxItem;
begin
  ItemsCxComboBox.BeginUpdate;
  Try
    ItemsCxComboBox.Clear;

    for I := 0 to DriverList.Count -1 do
    begin
      CurrentItemCxComboBox             := ItemsCxComboBox.Add;
      CurrentItemCxComboBox.ImageIndex  := GetBitmapDriver(DriverList.Strings[I]);
      CurrentItemCxComboBox.Description := DriverList.Strings[I];
      CurrentItemCxComboBox.Value       := Integer(DriverList.Objects[I])
    end;
  Finally
    ItemsCxComboBox.EndUpdate;
  End;
end;


Procedure TBurningTool.BuilcxComboBoxAll(ItemsCxComboBox: TcximageComboBoxItems);
var I                     : Integer;
    CurrentItemCxComboBox : TcxImageComboBoxItem;
begin
  ItemsCxComboBox.BeginUpdate;
  Try
    ItemsCxComboBox.Clear;

    for I := 0 to FListaDriveCD.Count -1 do
    begin
      if FListaDriveDVD.IndexOf(FListaDriveCD.Strings[I]) <> -1 then continue;
      if FListaDriveBDR.IndexOf(FListaDriveCD.Strings[I]) <> -1 then continue;
      CurrentItemCxComboBox             := ItemsCxComboBox.Add;
      CurrentItemCxComboBox.ImageIndex  := GetBitmapDriver(FListaDriveCD.Strings[I]);
      CurrentItemCxComboBox.Description := FListaDriveCD.Strings[I];
      CurrentItemCxComboBox.Tag         := TIPO_SUPPORT_CD;
      CurrentItemCxComboBox.Value       := Integer(FListaDriveCD.Objects[I])
    end;

    for I := 0 to FListaDriveDVD.Count -1 do
    begin
      if FListaDriveBDR.IndexOf(FListaDriveDVD.Strings[I]) <> -1 then continue;    
      CurrentItemCxComboBox             := ItemsCxComboBox.Add;
      CurrentItemCxComboBox.ImageIndex  := GetBitmapDriver(FListaDriveDVD.Strings[I]);
      CurrentItemCxComboBox.Description := FListaDriveDVD.Strings[I];
      CurrentItemCxComboBox.Tag         := TIPO_SUPPORT_DVD;
      CurrentItemCxComboBox.Value       := Integer(FListaDriveDVD.Objects[I])
    end;

    for I := 0 to FListaDriveBDR.Count -1 do
    begin
      CurrentItemCxComboBox             := ItemsCxComboBox.Add;
      CurrentItemCxComboBox.ImageIndex  := GetBitmapDriver(FListaDriveBDR.Strings[I]);
      CurrentItemCxComboBox.Description := FListaDriveBDR.Strings[I];
      CurrentItemCxComboBox.Tag         := TIPO_SUPPORT_BDR;
      CurrentItemCxComboBox.Value       := Integer(FListaDriveBDR.Objects[I])
    end;    
    
    
  Finally
    ItemsCxComboBox.EndUpdate;
  End;
end;

Function TBurningTool.IsDriverRW(aDriveIndex : Integer;aSupportType:Integer):Boolean;
var I         : LongInt;
    vTmp      : Variant;
    LBound,
    HBound    : LongInt;
begin
  Result := False;
  if not CheckAssignedAndActivationDrive(aDriveIndex) then Exit;

  {$REGION 'Log'}
  {TSI:IGNORE ON}
    WriteLog('BurningTool.IsDriverRW','Start function',tpLivInfo,True);
  {TSI:IGNORE OFF}
  {$ENDREGION}

  Try
    SafeArrayGetLBound(FDiscRecord.SupportedProfiles, 1, LBound);
    SafeArrayGetUBound(FDiscRecord.SupportedProfiles, 1, HBound);

    for I := LBound to HBound do
    begin
      SafeArrayGetElement(FDiscRecord.SupportedProfiles, I, vTmp);

      if VarIsNull(vTmp) then Continue;

      case vtmp of
        IMAPI_PROFILE_TYPE_CD_REWRITABLE               :  begin
                                                            {$REGION 'Log'}
                                                            {TSI:IGNORE ON}
                                                              WriteLog('BurningTool.IsDriverRW',' Supported Profiles IMAPI_PROFILE_TYPE_CD_REWRITABLE '+ VarToStr(vTmp),tpLivInfo,True);
                                                            {TSI:IGNORE OFF}
                                                            {$ENDREGION}
                                                            Result := aSupportType = TIPO_SUPPORT_CD;
                                                          end;
        IMAPI_PROFILE_TYPE_DVD_DASH_REWRITABLE        :   begin
                                                            {$REGION 'Log'}
                                                            {TSI:IGNORE ON}
                                                              WriteLog('TBurningTool.IsDriverRW',' Supported Profiles IMAPI_PROFILE_TYPE_DVD_DASH_REWRITABLE '+ VarToStr(vTmp),tpLivInfo,True);
                                                            {TSI:IGNORE OFF}
                                                            {$ENDREGION}
                                                            Result := aSupportType = TIPO_SUPPORT_DVD;
                                                          end;

        IMAPI_PROFILE_TYPE_DVD_PLUS_RW_DUAL           :   begin
                                                            {$REGION 'Log'}
                                                            {TSI:IGNORE ON}
                                                              WriteLog('TBurningTool.IsDriverRW',' Supported Profiles IMAPI_PROFILE_TYPE_DVD_PLUS_RW_DUAL '+ VarToStr(vTmp),tpLivInfo,True);
                                                            {TSI:IGNORE OFF}
                                                            {$ENDREGION}
                                                            Result := aSupportType = TIPO_SUPPORT_DVD_DL;
                                                          end;
        IMAPI_PROFILE_TYPE_BD_REWRITABLE              :   begin
                                                            {$REGION 'Log'}
                                                            {TSI:IGNORE ON}
                                                              WriteLog('TBurningTool.IsDriverRW',' Supported Profiles IMAPI_PROFILE_TYPE_BD_REWRITABLE '+ VarToStr(vTmp),tpLivInfo,True);
                                                            {TSI:IGNORE OFF}
                                                            {$ENDREGION}
                                                            Result := aSupportType = TIPO_SUPPORT_BDR;
                                                          end;
      end;

      if Result then Break;
    end;
  Except on E : Exception do
    begin
      {$REGION 'Log'}
      {TSI:IGNORE ON}
         WriteLog('TBurningTool.IsDriverRW',Format('Exception [%s] last error [ %s ]',[e.Message,SysErrorMessage(GetLastError)]),tplivException);
      {TSI:IGNORE OFF}
      {$ENDREGION}
    end;
  End;
end;

{Buildo la lista dei driver}
procedure TBurningTool.BuildListDrivesOfType;
var DriveMap,
    dMask     : DWORD;
    dRoot     : String;
    I         : Integer;
begin
  if Not Assigned(FDiriverList) then Exit;

  dRoot     := 'A:\';
  DriveMap  := GetLogicalDrives;
  dMask     := 1;

  for I := 0 to 32 do
  begin
    if (dMask and DriveMap) <> 0 then
    begin
      if GetDriveType(PChar(dRoot)) = DRIVE_CDROM then
      begin
        FDiriverList.Add(dRoot[1] + ':');
      end;
    end;
    dMask := dMask shl 1;
    Inc(dRoot[1]);
  end;
end;

procedure TBurningTool.IsWrittableDriver(SupportedProfiles: PSafeArray;Var WCd,WDVD,WBDR,WDvd_DL,wCD_DL:Boolean);
var LBound,
    HBound  : LongInt;
    I       : Integer;
    vTmp    : Variant;
begin
    SafeArrayGetLBound(SupportedProfiles, 1, LBound);
    SafeArrayGetUBound(SupportedProfiles, 1, HBound);
    {Rescrivibili}
    for I := LBound to HBound do
    begin
      SafeArrayGetElement(SupportedProfiles, I, vTmp);

      if VarIsNull(vTmp) then Continue;

      case vtmp of
        {$REGION 'Log'}
        {TSI:IGNORE ON}
        IMAPI_PROFILE_TYPE_NON_REMOVABLE_DISK          : WriteLog('TBurningTool.IsWrittableDriver',' Supported Profiles IMAPI_PROFILE_TYPE_NON_REMOVABLE_DISK '+ VarToStr(vTmp),tpLivInfo,True);
        IMAPI_PROFILE_TYPE_INVALID                     : WriteLog('TBurningTool.IsWrittableDriver',' Supported Profiles IMAPI_PROFILE_TYPE_INVALID '+ VarToStr(vTmp),tpLivInfo,True);
        IMAPI_PROFILE_TYPE_REMOVABLE_DISK              : WriteLog('TBurningTool.IsWrittableDriver',' Supported Profiles IMAPI_PROFILE_TYPE_REMOVABLE_DISK '+ VarToStr(vTmp),tpLivInfo,True);
        IMAPI_PROFILE_TYPE_MO_ERASABLE                 : WriteLog('TBurningTool.IsWrittableDriver',' Supported Profiles IMAPI_PROFILE_TYPE_MO_ERASABLE '+ VarToStr(vTmp),tpLivInfo,True);
        IMAPI_PROFILE_TYPE_MO_WRITE_ONCE               : WriteLog('TBurningTool.IsWrittableDriver',' Supported Profiles IMAPI_PROFILE_TYPE_MO_WRITE_ONCE '+ VarToStr(vTmp),tpLivInfo,True);
        IMAPI_PROFILE_TYPE_AS_MO                       : WriteLog('TBurningTool.IsWrittableDriver',' Supported Profiles IMAPI_PROFILE_TYPE_AS_MO '+ VarToStr(vTmp),tpLivInfo,True);
        IMAPI_PROFILE_TYPE_CDROM                       : WriteLog('TBurningTool.IsWrittableDriver',' Supported Profiles IMAPI_PROFILE_TYPE_CDROM '+ VarToStr(vTmp),tpLivInfo,True);
        IMAPI_PROFILE_TYPE_BD_ROM                      : WriteLog('TBurningTool.IsWrittableDriver',' Supported Profiles IMAPI_PROFILE_TYPE_BD_ROM '+ VarToStr(vTmp),tpLivInfo,True);
        IMAPI_PROFILE_TYPE_HD_DVD_ROM                  : WriteLog('TBurningTool.IsWrittableDriver',' Supported Profiles IMAPI_PROFILE_TYPE_HD_DVD_ROM '+ VarToStr(vTmp),tpLivInfo,True);
        IMAPI_PROFILE_TYPE_HD_DVD_RECORDABLE           : WriteLog('TBurningTool.IsWrittableDriver',' Supported Profiles IMAPI_PROFILE_TYPE_HD_DVD_RECORDABLE '+ VarToStr(vTmp),tpLivInfo,True);
        IMAPI_PROFILE_TYPE_HD_DVD_RAM                  : WriteLog('TBurningTool.IsWrittableDriver',' Supported Profiles IMAPI_PROFILE_TYPE_HD_DVD_RAM '+ VarToStr(vTmp),tpLivInfo,True);
        IMAPI_PROFILE_TYPE_DDCDROM                     : WriteLog('TBurningTool.IsWrittableDriver',' Supported Profiles IMAPI_PROFILE_TYPE_DDCDROM '+ VarToStr(vTmp),tpLivInfo,True);
        IMAPI_PROFILE_TYPE_NON_STANDARD                : WriteLog('TBurningTool.IsWrittableDriver',' Supported Profiles IMAPI_PROFILE_TYPE_NON_STANDARD '+ VarToStr(vTmp),tpLivInfo,True);
        IMAPI_PROFILE_TYPE_DVDROM                      : WriteLog('TBurningTool.IsWrittableDriver',' Supported Profiles IMAPI_PROFILE_TYPE_DVDROM '+ VarToStr(vTmp),tpLivInfo,True);
        IMAPI_PROFILE_TYPE_DVD_PLUS_R                  : WriteLog('TBurningTool.IsWrittableDriver',' Supported Profiles IMAPI_PROFILE_TYPE_DVD_PLUS_R '+ VarToStr(vTmp),tpLivInfo,True);
        IMAPI_PROFILE_TYPE_DVD_RAM                     : WriteLog('TBurningTool.IsWrittableDriver',' Supported Profiles IMAPI_PROFILE_TYPE_DVD_RAM '+ VarToStr(vTmp),tpLivInfo,True);
        {TSI:IGNORE OFF}
        {$ENDREGION}
        IMAPI_PROFILE_TYPE_CD_RECORDABLE               :  begin
                                                            {$REGION 'Log'}
                                                            {TSI:IGNORE ON}
                                                              WriteLog('TBurningTool.IsWrittableDriver',' Supported Profiles IMAPI_PROFILE_TYPE_CD_RECORDABLE '+ VarToStr(vTmp),tpLivInfo);
                                                            {TSI:IGNORE OFF}
                                                            {$ENDREGION}
                                                            WCd := True;
                                                          end;
        IMAPI_PROFILE_TYPE_CD_REWRITABLE               :  begin
                                                            {$REGION 'Log'}
                                                            {TSI:IGNORE ON}
                                                              WriteLog('TBurningTool.IsWrittableDriver',' Supported Profiles IMAPI_PROFILE_TYPE_CD_REWRITABLE '+ VarToStr(vTmp),tpLivInfo);
                                                            {TSI:IGNORE OFF}
                                                            {$ENDREGION}
                                                            WCd := True;
                                                          end;
        IMAPI_PROFILE_TYPE_DDCD_REWRITABLE               :begin
                                                            {$REGION 'Log'}
                                                            {TSI:IGNORE ON}
                                                              WriteLog('TBurningTool.IsWrittableDriver',' Supported Profiles IMAPI_PROFILE_TYPE_DDCD_REWRITABLE '+ VarToStr(vTmp),tpLivInfo);
                                                            {TSI:IGNORE OFF}
                                                            {$ENDREGION}
                                                            wCD_DL := True;
                                                          end;
        IMAPI_PROFILE_TYPE_DDCD_RECORDABLE               :begin
                                                            {$REGION 'Log'}
                                                            {TSI:IGNORE ON}
                                                              WriteLog('TBurningTool.IsWrittableDriver',' Supported Profiles IMAPI_PROFILE_TYPE_DDCD_RECORDABLE '+ VarToStr(vTmp),tpLivInfo);
                                                            {TSI:IGNORE OFF}
                                                            {$ENDREGION}
                                                            wCD_DL := True;
                                                          end;

        IMAPI_PROFILE_TYPE_DVD_DASH_RECORDABLE         :  begin
                                                            {$REGION 'Log'}
                                                            {TSI:IGNORE ON}
                                                              WriteLog('TBurningTool.IsWrittableDriver',' Supported Profiles IMAPI_PROFILE_TYPE_DVD_DASH_RECORDABLE '+ VarToStr(vTmp),tpLivInfo);
                                                            {TSI:IGNORE OFF}
                                                            {$ENDREGION}
                                                            Wdvd := True;
                                                          end;
        IMAPI_PROFILE_TYPE_DVD_DASH_REWRITABLE         :  begin
                                                            {$REGION 'Log'}
                                                            {TSI:IGNORE ON}
                                                              WriteLog('TBurningTool.IsWrittableDriver',' Supported Profiles IMAPI_PROFILE_TYPE_DVD_DASH_REWRITABLE '+ VarToStr(vTmp),tpLivInfo);
                                                            {TSI:IGNORE OFF}
                                                            {$ENDREGION}
                                                            Wdvd := True;
                                                          end;
        IMAPI_PROFILE_TYPE_DVD_DASH_RW_SEQUENTIAL      :  begin
                                                            {$REGION 'Log'}
                                                            {TSI:IGNORE ON}
                                                              WriteLog('TBurningTool.IsWrittableDriver',' Supported Profiles IMAPI_PROFILE_TYPE_DVD_DASH_RW_SEQUENTIAL '+ VarToStr(vTmp),tpLivInfo);
                                                            {TSI:IGNORE OFF}
                                                            {$ENDREGION}
                                                            Wdvd := True;
                                                          end;
        IMAPI_PROFILE_TYPE_DVD_PLUS_RW                 :  begin
                                                            {$REGION 'Log'}
                                                            {TSI:IGNORE ON}
                                                              WriteLog('TBurningTool.IsWrittableDriver',' Supported Profiles IMAPI_PROFILE_TYPE_DVD_PLUS_RW '+ VarToStr(vTmp),tpLivInfo);
                                                            {TSI:IGNORE OFF}
                                                            {$ENDREGION}
                                                            Wdvd := True;
                                                          end;

        IMAPI_PROFILE_TYPE_BD_R_SEQUENTIAL             :  begin
                                                            {$REGION 'Log'}
                                                            {TSI:IGNORE ON}
                                                              WriteLog('TBurningTool.IsWrittableDriver',' Supported Profiles IMAPI_PROFILE_TYPE_BD_R_SEQUENTIAL '+ VarToStr(vTmp),tpLivInfo);
                                                            {TSI:IGNORE OFF}
                                                            {$ENDREGION}
                                                            WBDr := True;
                                                          end;
        IMAPI_PROFILE_TYPE_BD_R_RANDOM_RECORDING        : begin
                                                            {$REGION 'Log'}
                                                            {TSI:IGNORE ON}
                                                              WriteLog('TBurningTool.IsWrittableDriver',' Supported Profiles IMAPI_PROFILE_TYPE_BD_R_RANDOM_RECORDING '+ VarToStr(vTmp),tpLivInfo);
                                                            {TSI:IGNORE OFF}
                                                            {$ENDREGION}
                                                            WBDr := True;
                                                          end;

        IMAPI_PROFILE_TYPE_BD_REWRITABLE               :  begin
                                                            {$REGION 'Log'}
                                                            {TSI:IGNORE ON}
                                                              WriteLog('TBurningTool.IsWrittableDriver',' Supported Profiles IMAPI_PROFILE_TYPE_BD_REWRITABLE '+ VarToStr(vTmp),tpLivInfo);
                                                            {TSI:IGNORE OFF}
                                                            {$ENDREGION}
                                                            WBDr := True;
                                                          end;
        IMAPI_PROFILE_TYPE_DVD_PLUS_R_DUAL            :   begin
                                                            {$REGION 'Log'}
                                                            {TSI:IGNORE ON}
                                                              WriteLog('TBurningTool.IsWrittableDriver',' Supported Profiles IMAPI_PROFILE_TYPE_DVD_PLUS_R_DUAL '+ VarToStr(vTmp),tpLivInfo);
                                                            {TSI:IGNORE OFF}
                                                            {$ENDREGION}
                                                            WDvd_DL := True;
                                                          end;
        IMAPI_PROFILE_TYPE_DVD_PLUS_RW_DUAL            :  begin
                                                            {$REGION 'Log'}
                                                            {TSI:IGNORE ON}
                                                              WriteLog('TBurningTool.IsWrittableDriver',' Supported Profiles IMAPI_PROFILE_TYPE_DVD_PLUS_RW_DUAL '+ VarToStr(vTmp),tpLivInfo);
                                                            {TSI:IGNORE OFF}
                                                            {$ENDREGION}
                                                            WDvd_DL := True;
                                                          end;
      else
        {$REGION 'Log'}
        {TSI:IGNORE ON}
          WriteLog('TBurningTool.IsWrittableDriver',' Supported Profiles unknown '+ VarToStr(vTmp),tpLivWarning);
        {TSI:IGNORE OFF}
        {$ENDREGION}
      end;
    end;
end;

procedure TBurningTool.IsRecordableDriver(SupportedFeaturePages: PSafeArray;Var WCd,WDVD,WBDR,WDvd_DL,wCD_DL:Boolean);
var LBound,
    HBound  : LongInt;
    I       : Integer;
    vTmp    : Variant;
begin
    SafeArrayGetLBound(SupportedFeaturePages, 1, LBound);
    SafeArrayGetUBound(SupportedFeaturePages, 1, HBound);

    for I := LBound to HBound do
    begin
      SafeArrayGetElement(SupportedFeaturePages, I, vTmp);

      if VarIsNull(vTmp) then Continue;

      case vtmp of
        {$REGION 'Log'}
        {TSI:IGNORE ON}
        IMAPI_FEATURE_PAGE_TYPE_PROFILE_LIST                   : WriteLog('TBurningTool.IsRecordableDriver',' Feature pages IMAPI_FEATURE_PAGE_TYPE_PROFILE_LIST '+ VarToStr(vTmp),tpLivInfo,True);
        IMAPI_FEATURE_PAGE_TYPE_CORE                           : WriteLog('TBurningTool.IsRecordableDriver',' Feature pages IMAPI_FEATURE_PAGE_TYPE_CORE '+ VarToStr(vTmp),tpLivInfo,True);
        IMAPI_FEATURE_PAGE_TYPE_MORPHING                       : WriteLog('TBurningTool.IsRecordableDriver',' Feature pages IMAPI_FEATURE_PAGE_TYPE_MORPHING '+ VarToStr(vTmp),tpLivInfo,True);
        IMAPI_FEATURE_PAGE_TYPE_REMOVABLE_MEDIUM               : WriteLog('TBurningTool.IsRecordableDriver',' Feature pages IMAPI_FEATURE_PAGE_TYPE_REMOVABLE_MEDIUM '+ VarToStr(vTmp),tpLivInfo,True);
        IMAPI_FEATURE_PAGE_TYPE_WRITE_PROTECT                  : WriteLog('TBurningTool.IsRecordableDriver',' Feature pages IMAPI_FEATURE_PAGE_TYPE_WRITE_PROTECT '+ VarToStr(vTmp),tpLivInfo,True);
        IMAPI_FEATURE_PAGE_TYPE_RANDOMLY_READABLE              : WriteLog('TBurningTool.IsRecordableDriver',' Feature pages IMAPI_FEATURE_PAGE_TYPE_RANDOMLY_READABLE '+ VarToStr(vTmp),tpLivInfo,True);
        IMAPI_FEATURE_PAGE_TYPE_CD_MULTIREAD                   : WriteLog('TBurningTool.IsRecordableDriver',' Feature pages IMAPI_FEATURE_PAGE_TYPE_CD_MULTIREAD '+ VarToStr(vTmp),tpLivInfo,True);
        IMAPI_FEATURE_PAGE_TYPE_CD_READ                        : WriteLog('TBurningTool.IsRecordableDriver',' Feature pages IMAPI_FEATURE_PAGE_TYPE_CD_READ '+ VarToStr(vTmp),tpLivInfo,True);
        IMAPI_FEATURE_PAGE_TYPE_DVD_READ                       : WriteLog('TBurningTool.IsRecordableDriver',' Feature pages IMAPI_FEATURE_PAGE_TYPE_DVD_READ '+ VarToStr(vTmp),tpLivInfo,True);
        IMAPI_FEATURE_PAGE_TYPE_RANDOMLY_WRITABLE              : WriteLog('TBurningTool.IsRecordableDriver',' Feature pages IMAPI_FEATURE_PAGE_TYPE_RANDOMLY_WRITABLE '+ VarToStr(vTmp),tpLivInfo,True);
        IMAPI_FEATURE_PAGE_TYPE_INCREMENTAL_STREAMING_WRITABLE : WriteLog('TBurningTool.IsRecordableDriver',' Feature pages IMAPI_FEATURE_PAGE_TYPE_INCREMENTAL_STREAMING_WRITABLE '+ VarToStr(vTmp),tpLivInfo,True);
        IMAPI_FEATURE_PAGE_TYPE_SECTOR_ERASABLE                : WriteLog('TBurningTool.IsRecordableDriver',' Feature pages IMAPI_FEATURE_PAGE_TYPE_SECTOR_ERASABLE '+ VarToStr(vTmp),tpLivInfo,True);
        IMAPI_FEATURE_PAGE_TYPE_FORMATTABLE                    : WriteLog('TBurningTool.IsRecordableDriver',' Feature pages IMAPI_FEATURE_PAGE_TYPE_FORMATTABLE '+ VarToStr(vTmp),tpLivInfo,True);
        IMAPI_FEATURE_PAGE_TYPE_HARDWARE_DEFECT_MANAGEMENT     : WriteLog('TBurningTool.IsRecordableDriver',' Feature pages IMAPI_FEATURE_PAGE_TYPE_HARDWARE_DEFECT_MANAGEMENT '+ VarToStr(vTmp),tpLivInfo,True);
        IMAPI_FEATURE_PAGE_TYPE_WRITE_ONCE                     : WriteLog('TBurningTool.IsRecordableDriver',' Feature pages IMAPI_FEATURE_PAGE_TYPE_WRITE_ONCE '+ VarToStr(vTmp),tpLivInfo,True);
        IMAPI_FEATURE_PAGE_TYPE_RESTRICTED_OVERWRITE           : WriteLog('TBurningTool.IsRecordableDriver',' Feature pages IMAPI_FEATURE_PAGE_TYPE_RESTRICTED_OVERWRITE '+ VarToStr(vTmp),tpLivInfo,True);
        {This value has been deprecated}
        IMAPI_FEATURE_PAGE_TYPE_DOUBLE_DENSITY_CD_READ         : WriteLog('TBurningTool.IsRecordableDriver',' Feature pages IMAPI_FEATURE_PAGE_TYPE_DOUBLE_DENSITY_CD_READ '+ VarToStr(vTmp),tpLivInfo,True);
        IMAPI_FEATURE_PAGE_TYPE_MRW                            : WriteLog('TBurningTool.IsRecordableDriver',' Feature pages IMAPI_FEATURE_PAGE_TYPE_MRW '+ VarToStr(vTmp),tpLivInfo,True);
        IMAPI_FEATURE_PAGE_TYPE_ENHANCED_DEFECT_REPORTING      : WriteLog('TBurningTool.IsRecordableDriver',' Feature pages IMAPI_FEATURE_PAGE_TYPE_ENHANCED_DEFECT_REPORTING '+ VarToStr(vTmp),tpLivInfo,True);
        IMAPI_FEATURE_PAGE_TYPE_DVD_PLUS_R                     : WriteLog('TBurningTool.IsRecordableDriver',' Feature pages IMAPI_FEATURE_PAGE_TYPE_DVD_PLUS_R '+ VarToStr(vTmp),tpLivInfo,True);
        IMAPI_FEATURE_PAGE_TYPE_RIGID_RESTRICTED_OVERWRITE     : WriteLog('TBurningTool.IsRecordableDriver',' Feature pages IMAPI_FEATURE_PAGE_TYPE_RIGID_RESTRICTED_OVERWRITE '+ VarToStr(vTmp),tpLivInfo,True);
        IMAPI_FEATURE_PAGE_TYPE_HD_DVD_READ                    : WriteLog('TBurningTool.IsRecordableDriver',' Feature pages IMAPI_FEATURE_PAGE_TYPE_HD_DVD_READ '+ VarToStr(vTmp),tpLivInfo,True);
        IMAPI_FEATURE_PAGE_TYPE_HD_DVD_WRITE                   : WriteLog('TBurningTool.IsRecordableDriver',' Feature pages IMAPI_FEATURE_PAGE_TYPE_HD_DVD_WRITE '+ VarToStr(vTmp),tpLivInfo,True);
        IMAPI_FEATURE_PAGE_TYPE_POWER_MANAGEMENT               : WriteLog('TBurningTool.IsRecordableDriver',' Feature pages IMAPI_FEATURE_PAGE_TYPE_POWER_MANAGEMENT '+ VarToStr(vTmp),tpLivInfo,True);
        IMAPI_FEATURE_PAGE_TYPE_SMART                          : WriteLog('TBurningTool.IsRecordableDriver',' Feature pages IMAPI_FEATURE_PAGE_TYPE_SMART '+ VarToStr(vTmp),tpLivInfo,True);
        IMAPI_FEATURE_PAGE_TYPE_EMBEDDED_CHANGER               : WriteLog('TBurningTool.IsRecordableDriver',' Feature pages IMAPI_FEATURE_PAGE_TYPE_EMBEDDED_CHANGER '+ VarToStr(vTmp),tpLivInfo,True);
        IMAPI_FEATURE_PAGE_TYPE_CD_ANALOG_PLAY                 : WriteLog('TBurningTool.IsRecordableDriver',' Feature pages IMAPI_FEATURE_PAGE_TYPE_CD_ANALOG_PLAY '+ VarToStr(vTmp),tpLivInfo,True);
        IMAPI_FEATURE_PAGE_TYPE_MICROCODE_UPDATE               : WriteLog('TBurningTool.IsRecordableDriver',' Feature pages IMAPI_FEATURE_PAGE_TYPE_MICROCODE_UPDATE '+ VarToStr(vTmp),tpLivInfo,True);
        IMAPI_FEATURE_PAGE_TYPE_TIMEOUT                        : WriteLog('TBurningTool.IsRecordableDriver',' Feature pages IMAPI_FEATURE_PAGE_TYPE_TIMEOUT '+ VarToStr(vTmp),tpLivInfo,True);
        IMAPI_FEATURE_PAGE_TYPE_DVD_CSS                        : WriteLog('TBurningTool.IsRecordableDriver',' Feature pages IMAPI_FEATURE_PAGE_TYPE_DVD_CSS '+ VarToStr(vTmp),tpLivInfo);
        IMAPI_FEATURE_PAGE_TYPE_REAL_TIME_STREAMING            : WriteLog('TBurningTool.IsRecordableDriver',' Feature pages IMAPI_FEATURE_PAGE_TYPE_REAL_TIME_STREAMING '+ VarToStr(vTmp),tpLivInfo);
        IMAPI_FEATURE_PAGE_TYPE_LOGICAL_UNIT_SERIAL_NUMBER     : WriteLog('TBurningTool.IsRecordableDriver',' Feature pages IMAPI_FEATURE_PAGE_TYPE_LOGICAL_UNIT_SERIAL_NUMBER '+ VarToStr(vTmp),tpLivInfo);
        IMAPI_FEATURE_PAGE_TYPE_MEDIA_SERIAL_NUMBER            : WriteLog('TBurningTool.IsRecordableDriver',' Feature pages IMAPI_FEATURE_PAGE_TYPE_MEDIA_SERIAL_NUMBER '+ VarToStr(vTmp),tpLivInfo);
        IMAPI_FEATURE_PAGE_TYPE_DISC_CONTROL_BLOCKS            : WriteLog('TBurningTool.IsRecordableDriver',' Feature pages IMAPI_FEATURE_PAGE_TYPE_DISC_CONTROL_BLOCKS '+ VarToStr(vTmp),tpLivInfo);
        IMAPI_FEATURE_PAGE_TYPE_DVD_CPRM                       : WriteLog('TBurningTool.IsRecordableDriver',' Feature pages IMAPI_FEATURE_PAGE_TYPE_DVD_CPRM '+ VarToStr(vTmp),tpLivInfo);
        IMAPI_FEATURE_PAGE_TYPE_FIRMWARE_INFORMATION           : WriteLog('TBurningTool.IsRecordableDriver',' Feature pages IMAPI_FEATURE_PAGE_TYPE_FIRMWARE_INFORMATION '+ VarToStr(vTmp),tpLivInfo);
        IMAPI_FEATURE_PAGE_TYPE_AACS                           : WriteLog('TBurningTool.IsRecordableDriver',' Feature pages IMAPI_FEATURE_PAGE_TYPE_AACS '+ VarToStr(vTmp),tpLivInfo);
        IMAPI_FEATURE_PAGE_TYPE_VCPS                           : WriteLog('TBurningTool.IsRecordableDriver',' Feature pages IMAPI_FEATURE_PAGE_TYPE_VCPS '+ VarToStr(vTmp),tpLivInfo);
        IMAPI_FEATURE_PAGE_TYPE_BD_PSEUDO_OVERWRITE            : WriteLog('TBurningTool.IsRecordableDriver',' Feature pages IMAPI_FEATURE_PAGE_TYPE_BD_PSEUDO_OVERWRITE '+ VarToStr(vTmp),tpLivInfo);
        IMAPI_FEATURE_PAGE_TYPE_BD_READ                        : WriteLog('TBurningTool.IsRecordableDriver',' Feature pages IMAPI_FEATURE_PAGE_TYPE_BD_READ '+ VarToStr(vTmp),tpLivInfo);
        IMAPI_FEATURE_PAGE_TYPE_LAYER_JUMP_RECORDING           : WriteLog('TBurningTool.IsRecordableDriver',' Feature pages IMAPI_FEATURE_PAGE_TYPE_LAYER_JUMP_RECORDING '+ VarToStr(vTmp),tpLivInfo);
        {TSI:IGNORE OFF}
        {$ENDREGION}
        IMAPI_FEATURE_PAGE_TYPE_CDRW_CAV_WRITE                 : begin
                                                                    {$REGION 'Log'}
                                                                    {TSI:IGNORE ON}
                                                                      WriteLog('TBurningTool.IsRecordableDriver',' Feature pages IMAPI_FEATURE_PAGE_TYPE_CDRW_CAV_WRITE '+ VarToStr(vTmp),tpLivInfo);
                                                                    {TSI:IGNORE OFF}
                                                                    {$ENDREGION}
                                                                    WCd := True;
                                                                 end;
        IMAPI_FEATURE_PAGE_TYPE_CD_TRACK_AT_ONCE               : begin
                                                                    {$REGION 'Log'}
                                                                    {TSI:IGNORE ON}
                                                                      WriteLog('TBurningTool.IsRecordableDriver',' Feature pages IMAPI_FEATURE_PAGE_TYPE_CD_TRACK_AT_ONCE '+ VarToStr(vTmp),tpLivInfo);
                                                                    {TSI:IGNORE OFF}
                                                                    {$ENDREGION}
                                                                    WCd := True;
                                                                 end;
        IMAPI_FEATURE_PAGE_TYPE_CD_MASTERING                   : begin
                                                                    {$REGION 'Log'}
                                                                    {TSI:IGNORE ON}
                                                                      WriteLog('TBurningTool.IsRecordableDriver',' Feature pages IMAPI_FEATURE_PAGE_TYPE_CD_MASTERING '+ VarToStr(vTmp),tpLivInfo);
                                                                    {TSI:IGNORE OFF}
                                                                    {$ENDREGION}
                                                                    WCd := True;
                                                                 end;
        IMAPI_FEATURE_PAGE_TYPE_CD_RW_MEDIA_WRITE_SUPPORT      : begin
                                                                    {$REGION 'Log'}
                                                                    {TSI:IGNORE ON}
                                                                      WriteLog('TBurningTool.IsRecordableDriver',' Feature pages IMAPI_FEATURE_PAGE_TYPE_CD_RW_MEDIA_WRITE_SUPPORT '+ VarToStr(vTmp),tpLivInfo);
                                                                    {TSI:IGNORE OFF}
                                                                    {$ENDREGION}
                                                                    WCd := True;
                                                                 end;
        IMAPI_FEATURE_PAGE_TYPE_DOUBLE_DENSITY_CD_R_WRITE :      begin
                                                                    {$REGION 'Log'}
                                                                    {TSI:IGNORE ON}
                                                                      WriteLog('TBurningTool.IsRecordableDriver',' Feature pages IMAPI_FEATURE_PAGE_TYPE_DOUBLE_DENSITY_CD_R_WRITE '+ VarToStr(vTmp),tpLivInfo);
                                                                    {TSI:IGNORE OFF}
                                                                    {$ENDREGION}
                                                                    Wcd_DL := True;
                                                                 end;
        IMAPI_FEATURE_PAGE_TYPE_DOUBLE_DENSITY_CD_RW_WRITE :     begin
                                                                    {$REGION 'Log'}
                                                                    {TSI:IGNORE ON}
                                                                      WriteLog('TBurningTool.IsRecordableDriver',' Feature pages IMAPI_FEATURE_PAGE_TYPE_DOUBLE_DENSITY_CD_RW_WRITE '+ VarToStr(vTmp),tpLivInfo);
                                                                    {TSI:IGNORE OFF}
                                                                    {$ENDREGION}
                                                                    Wcd_DL := True;
                                                                 end;

        IMAPI_FEATURE_PAGE_TYPE_DVD_DASH_WRITE                 : begin
                                                                    {$REGION 'Log'}
                                                                    {TSI:IGNORE ON}
                                                                      WriteLog('TBurningTool.IsRecordableDriver',' Feature pages IMAPI_FEATURE_PAGE_TYPE_DVD_DASH_WRITE '+ VarToStr(vTmp),tpLivInfo);
                                                                    {TSI:IGNORE OFF}
                                                                    {$ENDREGION}
                                                                    WDvd := True;
                                                                 end;
        IMAPI_FEATURE_PAGE_TYPE_DVD_PLUS_RW                    : begin
                                                                    {$REGION 'Log'}
                                                                    {TSI:IGNORE ON}
                                                                      WriteLog('TBurningTool.IsRecordableDriver',' Feature pages IMAPI_FEATURE_PAGE_TYPE_DVD_PLUS_RW '+ VarToStr(vTmp),tpLivInfo);
                                                                    {TSI:IGNORE OFF}
                                                                    {$ENDREGION}
                                                                    WDvd := True;
                                                                 end;
        IMAPI_FEATURE_PAGE_TYPE_DVD_PLUS_R_DUAL_LAYER :          begin
                                                                    {$REGION 'Log'}
                                                                    {TSI:IGNORE ON}
                                                                      WriteLog('TBurningTool.IsRecordableDriver',' Feature pages IMAPI_FEATURE_PAGE_TYPE_DVD_PLUS_R_DUAL_LAYER '+ VarToStr(vTmp),tpLivInfo);
                                                                    {TSI:IGNORE OFF}
                                                                    {$ENDREGION}
                                                                    WDvd_DL := True;
                                                                 end;

        IMAPI_FEATURE_PAGE_TYPE_BD_WRITE                       : begin
                                                                   {$REGION 'Log'}
                                                                   {TSI:IGNORE ON}
                                                                      WriteLog('TBurningTool.IsRecordableDriver',' Feature pages IMAPI_FEATURE_PAGE_TYPE_BD_WRITE '+ VarToStr(vTmp),tpLivInfo);
                                                                   {TSI:IGNORE OFF}
                                                                   {$ENDREGION}
                                                                   WBDR := True;
                                                                 end;
      else
        {$REGION 'Log'}
        {TSI:IGNORE ON}
          WriteLog('TBurningTool.IsRecordableDriver',' Feature pages unknown '+ VarToStr(vTmp),tpLivWarning);
        {TSI:IGNORE OFF}
        {$ENDREGION}
      end;
    end;
end;

{Recupero immagini di sistema}
procedure TBurningTool.CreateImageListIconSystem;
var Info : TSHFileInfo;
begin
  FimgListSysSmall              := TImageList.Create(nil);
  FimgListSysSmall.DrawingStyle := dsTransparent;
  FimgListSysSmall.Handle       := SHGetFileInfo('', 0, Info, SizeOf(TSHFileInfo),  SHGFI_SMALLICON or SHGFI_SYSICONINDEX or SHGFI_PIDL );
  FimgListSysSmall.ShareImages  := True;
end;

{Creazione liste drive per tipo masterizzatore}
procedure TBurningTool.CreateInterListDriveByType;
begin
  FListaDriveCD           := TStringList.Create;
  FListaDriveCD_DL        := TStringList.Create;
  FListaDriveDVD          := TStringList.Create;
  FListaDriveDVD_DL       := TStringList.Create;
  FListaDriveBDR          := TStringList.Create;
  FDiriverList            := TStringList.Create;
end;

constructor TBurningTool.Create;
begin
  { Create a DiscMaster2 object to connect to CD/DVD drives.}
  FDiscMaster             := TMsftDiscMaster2.Create(nil);
  FDiscMaster.AutoConnect := False;
  FDiscMaster.ConnectKind := ckRunningOrNew;
  {Create a DiscRecorder object for the specified burning device}
  FDiscRecord             := TMsftDiscRecorder2.Create(nil);
  FDiscRecord.AutoConnect := False;
  FDiscRecord.ConnectKind := ckRunningOrNew;
  CreateInterListDriveByType;
  BuildListDrivesOfType;
  CreateImageListIconSystem;
  {Indica se sul sistama ci sono Masterizzatori}
  if Not FDiscMaster.IsSupportedEnvironment then
  begin
    {$REGION 'Log'}
    {TSI:IGNORE ON}
       WriteLog('TBurningTool.Create',Format('IsSupportedEnvironment [ False ] PC without a writing drive',[]),tpLivWarning);
    {TSI:IGNORE OFF}
    {$ENDREGION}
    Exit;
  end;
  SearchRecordableDriver;
end;

Procedure TBurningTool.SearchRecordableDriver;
var IdxDriver    : Integer;
    WDvd         : Boolean;
    WDvd_DL      : Boolean;
    WCd          : Boolean;
    WBDR         : Boolean;
    wCD_DL       : Boolean;
begin
  {Controllo tutti i masterizzatori per sapere quali supporti sono abilitato a masterizzare}
  For IdxDriver := 0 to FDiscMaster.Count - 1 do
  begin
    if not CheckAssignedAndActivationDrive(IdxDriver) then Continue;
    Try
      Try
        {$REGION 'Log'}
        {TSI:IGNORE ON}
          { *** - Formatting to display recorder info}
          WriteLog('TBurningTool.SearchRecordableDriver',' "--------------------------------------------------------------------------------"',tpLivInfo);
          WriteLog('TBurningTool.SearchRecordableDriver','" ActiveRecorderId: " '+ FDiscRecord.ActiveDiscRecorder,tpLivInfo);
          WriteLog('TBurningTool.SearchRecordableDriver','"        Vendor Id: " '+ FDiscRecord.VendorId,tpLivInfo);
          WriteLog('TBurningTool.SearchRecordableDriver','"       Product Id: " '+ FDiscRecord.ProductId,tpLivInfo);
          WriteLog('TBurningTool.SearchRecordableDriver','" Product Revision: " '+ FDiscRecord.ProductRevision,tpLivInfo);
          WriteLog('TBurningTool.SearchRecordableDriver','"       VolumeName: " '+ FDiscRecord.VolumeName,tpLivInfo);
          Try
            WriteLog('TBurningTool.SearchRecordableDriver','"   Can Load Media: " '+ BoolToStr(FDiscRecord.DeviceCanLoadMedia,True),tpLivInfo);
          Except on E : Exception do
            begin
              {$REGION 'Log'}
              {TSI:IGNORE ON}
                 WriteLog('TBurningTool.SearchRecordableDriver',Format('Can not print load media value last error [ %s ]',[e.Message,SysErrorMessage(GetLastError)]),tpLivWarning);
              {TSI:IGNORE OFF}
              {$ENDREGION}
            end;
          End;
          WriteLog('TBurningTool.SearchRecordableDriver','"    Device Number: " '+ IntToStr(FDiscRecord.LegacyDeviceNumber),tpLivInfo);
          WriteLog('TBurningTool.SearchRecordableDriver',' "--------------------------------------------------------------------------------"',tpLivInfo);
        {TSI:IGNORE OFF}
        {$ENDREGION}
        WDvd    := False;
        WCD     := False;
        WBDR    := False;
        WDvd_DL := False;
        wCD_DL  := False;
        {Verifico se il disco � recordable}
        isRecordableDriver(FDiscRecord.SupportedFeaturePages,Wcd,WDvd,Wbdr,WDvd_DL,wCD_DL);
        {Verifico se il disco � un masterizzatore rescrivibile}
        IsWrittableDriver(FDiscRecord.SupportedProfiles,Wcd,WDvd,Wbdr,WDvd_DL,wCD_DL);
        {Aggiungo il disco alla corretta lista interna di driver}
        BuildListDriverType(FDiscRecord.VolumeName,Wcd,WDvd,Wbdr,WDvd_DL,wCD_DL,IdxDriver);
      Finally
        FDiscRecord.Disconnect;
      End;
    Except on E : Exception do
      {$REGION 'Log'}
      {TSI:IGNORE ON}
         WriteLog('TBurningTool.SearchRecordableDriver',Format('Exception [%s] last error [ %s ]',[e.Message,SysErrorMessage(GetLastError)]),tplivException);
      {TSI:IGNORE OFF}
      {$ENDREGION}
    End;
  end;
end;

Procedure TBurningTool.BuildListDriverType(VolumeName:WideString;Wcd,Wdvd,Wbdr,WdvdDl,wCD_DL:Boolean;idx:Integer);
var I            : integer;
    Buffer       : array [0 .. 49] of Char;
    sLabelDriver : String;
begin
  {Per tutti i driver che ho trovato}
  for I := 0 to FDiriverList.Count -1 do
  begin
    if GetVolumeNameForVolumeMountPoint(PWideChar(FDiriverList.Strings[I]+'\'), Buffer, Length(Buffer)) then
    begin
      if Buffer = VolumeName then
      begin
        sLabelDriver := GetDriveTypeLabel(FDiriverList.Strings[I]);

        if sLabelDriver = '' then
          sLabelDriver := FDiriverList.Strings[I];

        {$REGION 'Log'}
        {TSI:IGNORE ON}
           WriteLog('TBurningTool.BuildListDriverType',Format('Mount point for drive [ %s\ ] with label [ %s ] is [%s]',[FDiriverList.Strings[I],sLabelDriver,VolumeName]),tpLivInfo);
        {TSI:IGNORE OFF}
        {$ENDREGION}
        if WCd  then
          FListaDriveCD.AddObject(sLabelDriver,TObject(idx));

        if WDvd then
          FListaDriveDVD.AddObject(sLabelDriver,TObject(idx));

        if WBDR  then
          FListaDriveBDR.AddObject(sLabelDriver,TObject(idx));

        if WDVDDl then
          FListaDriveDVD_DL.AddObject(sLabelDriver,TObject(idx));

        if wCD_DL then
          FListaDriveDVD_DL.AddObject(sLabelDriver,TObject(idx));
        Break;
      end;
    end
    else
      {$REGION 'Log'}
      {TSI:IGNORE ON}
         WriteLog('TBurningTool.BuildListDriverType',Format('Unable find Mount point for drive with letter [ %s\ ] - Error [%s]',[FDiriverList.Strings[I],SysErrorMessage(GetLastError)]),tplivError);
      {TSI:IGNORE OFF}
      {$ENDREGION}
  end;
end;

function TBurningTool.GetDriveTypeLabel(Const DriveChar: String): string;
var Info              : TSHFileInfo;
    NotUsed           : DWORD;
    VolumeFlags       : DWORD;
    VolumeInfo        : Array[0..MAX_PATH] of char;
    VolumeSerialNumber: Integer;
    iPos              : integer;
    sTmp              : String;
begin
  SHGetFileInfo(PChar(DriveChar+'\'), 0, Info, SizeOf(Info), SHGFI_DISPLAYNAME);
  GetVolumeInformation(pChar(DriveChar + '\'),VolumeInfo, SizeOf(VolumeInfo),@VolumeSerialNumber, NotUsed, VolumeFlags, NIL, 0);
  Result := Trim(StringReplace(Info.szDisplayName,VolumeInfo,'',[rfReplaceAll,rfIgnoreCase]));

  iPos := Pos(':)', Result);
  if iPos > 0 then
  begin
    sTmp := Copy(Result, iPos-2, 4);
    Delete(Result, iPos-2, MaxInt);
    Result := Format('[%s] %s',[Copy(sTmp, 2, 2),Result])
  end;
end;

function TBurningTool.GetIndexCDROM(const aLetter: String): Integer;
var sLetter : String;
begin
  Result  := -1;
  sLetter := Copy(aLetter,1,2);
  if Pos(':',aLetter) = 0 then
    sLetter := Format('%s:',[aLetter]);

  Result := FDiriverList.IndexOf(sLetter);
end;

destructor TBurningTool.Destroy;
begin
  try
    if assigned(FCurrentWriter) then
    begin
      {$REGION 'Log'}
      {TSI:IGNORE ON}
         WriteLog('TBurningTool.Destroy',Format('Current writer is assigned',[]),tplivError);
      {TSI:IGNORE OFF}
      {$ENDREGION}
      FCurrentWriter.Disconnect;
      FCurrentWriter.Free;
    end;
  Except on E : Exception do
    begin
      FCurrentWriter := nil;
      {$REGION 'Log'}
      {TSI:IGNORE ON}
         WriteLog('TBurningTool.Destroy',Format('Exception destroy currentWriters [ %s ] last error [ %s ]',[e.Message,SysErrorMessage(GetLastError)]),tplivException);
      {TSI:IGNORE OFF}
      {$ENDREGION}
    end;
  End;
  if Assigned(FListaDriveCD) then
    FreeAndNil(FListaDriveCD);
  if Assigned(FListaDriveCD_DL) then
    FreeAndNil(FListaDriveCD_DL);
  if Assigned(FListaDriveBDR) then
    FreeAndNil(FListaDriveBDR);
  if Assigned(FListaDriveDVD) then
    FreeAndNil(FListaDriveDVD);
  if Assigned(FListaDriveDVD_DL) then
    FreeAndNil(FListaDriveDVD_DL);
  if Assigned(FDiscMaster) then
    FreeAndNil(FDiscMaster);
  if Assigned(FDiscRecord) then
    FreeAndNil(FDiscRecord);
  if Assigned(FimgListSysSmall) then
    FreeAndNil(FimgListSysSmall);

  inherited;
end;

Function TBurningTool.ActiveDiskRecorder(IdexDriver: Integer):Boolean;
var uniqueId : Widestring;
begin
  Result   := false;
  if IdexDriver > FDiscMaster.Count then Exit;

  uniqueId := FDiscMaster.Item[IdexDriver];
  {$REGION 'Log'}
  {TSI:IGNORE ON}
  WriteLog('TBurningTool.ActiveDiskRecorder',Format('UniqueId [ %s ]',[uniqueId]),tpLivInfo,True);
  {TSI:IGNORE OFF}
  {$ENDREGION}

  FDiscRecord.Disconnect;
  FDiscRecord.ConnectKind := ckRunningOrNew;
  Try
    FDiscRecord.InitializeDiscRecorder(uniqueId);
    FLastuniqueId := UniqueID;
    Result := True;
  Except on E : Exception do
    begin
      {$REGION 'Log'}
      {TSI:IGNORE ON}
         WriteLog('TBurningTool.ActiveDiskRecorder',Format('UniqueId [ %s ] - Exception [ %s ] last error [ %s ]',[uniqueId,e.Message,SysErrorMessage(GetLastError)]),tplivException);
      {TSI:IGNORE OFF}
      {$ENDREGION}
      FLastuniqueId := '';
      Exit;
    end;
  End;
end;

{Chiude il cassetto del drive }
Function TBurningTool.CloseTray(IdexDriver: Integer):Boolean;
begin
  Result := False;
  if not CheckAssignedAndActivationDrive(IdexDriver) then Exit;

  Try
    if Not FDiscRecord.DeviceCanLoadMedia then
    begin
      Result := ( MessageBox(0, Pchar(Media_eject_Not_Supported), PChar(Application.Title),
                       MB_ICONINFORMATION or MB_OK or MB_YESNO or MB_TOPMOST ) in [IDYES] );
      FAbort := not Result;
      Exit;
    end;
    {$REGION 'Log'}
    {TSI:IGNORE ON}
       WriteLog('TBurningTool.CloseTray',Format('Close tray ',[]),tpLivInfo);
    {TSI:IGNORE OFF}
    {$ENDREGION}
    FDiscRecord.CloseTray;
  Except On E:Exception do
    begin
      if Not ( MessageBox(0, Pchar(Unknow_status_eject), PChar(Application.Title),
                       MB_ICONINFORMATION or MB_OK or MB_YESNO or MB_TOPMOST ) in [IDYES] )
      then
      begin
        FAbort := True;
        Exit;
      end;
      {$REGION 'Log'}
      {TSI:IGNORE ON}
         WriteLog('TBurningTool.CloseTray',Format('Exception %s last error [ %s ]',[e.Message,SysErrorMessage(GetLastError)]),tplivException);
      {TSI:IGNORE OFF}
      {$ENDREGION}
    end;
  End;
  Result := True;
end;

{ Apre il cassetto del drive }
Function TBurningTool.DriveEject(IdexDriver: Integer):Boolean;
begin
  Result := False;
  if not CheckAssignedAndActivationDrive(IdexDriver) then Exit;

  {$REGION 'Log'}
  {TSI:IGNORE ON}
     WriteLog('TBurningTool.DriverEject',Format('Eject Media ',[]),tpLivInfo);
  {TSI:IGNORE OFF}
  {$ENDREGION}
  Try
    if Not FDiscRecord.DeviceCanLoadMedia then
    begin
      Result := ( MessageBox(0, Pchar(Media_eject_Not_Supported_2), PChar(Application.Title),
                       MB_ICONINFORMATION or MB_OK or MB_YESNO or MB_TOPMOST ) in [IDYES] );
      FAbort := not Result;
      Exit;
    end;

    FDiscRecord.EjectMedia;
    Result := True;
  Except On E:Exception do
    begin
      {$REGION 'Log'}
      {TSI:IGNORE ON}
         WriteLog('TBurningTool.DriverEject',Format('Exception %s last error [ %s ]',[e.Message,SysErrorMessage(GetLastError)]),tplivException);
      {TSI:IGNORE OFF}
      {$ENDREGION}
    end;
  End;
end;

function TBurningTool.SetBurnVerification(var DataWriter : TMsftDiscFormat2Data;VerificationLevel:IMAPI_BURN_VERIFICATION_LEVEL):Boolean;
var BurnVerification : IBurnVerification;
    ResultQI         : Integer;
    aHresult         : HRESULT;
begin
  {
    IMAPI_BURN_VERIFICATION_LEVEL  Verifica del disco
      MsftDiscFormat2Data
      None                --> No burn verification.
      Quick Verification  --> READ_DISC_INFO command works and data appears correct READ_TRACK_INFO command works on all tracks
                              Checksum comparison of a small set of disc sectors to stream bits
      Full Verification --> Performs the same heuristic checks as the 'Quick' method, but will also read the entire last session and compare a checksum to the burned stream.
  }

  Result := False;
  if Not Assigned(DataWriter) then Exit;

  Try
    BurnVerification := nil;
    ResultQI         := DataWriter.DefaultInterface.QueryInterface(IBurnVerification,BurnVerification);

    if ResultQI = S_OK then
    begin
      aHresult := BurnVerification.Set_BurnVerificationLevel(VerificationLevel);
      Result   := aHresult = S_OK;
      if Not Result then
        {$REGION 'Log'}
        {TSI:IGNORE ON}
           WriteLog('TBurningTool.SetBurnVerification',Format('Error %d last error [ %s ]',[ResultQI,SysErrorMessage(GetLastError)]),tplivError);
        {TSI:IGNORE OFF}
        {$ENDREGION}
    end
    else
      {$REGION 'Log'}
      {TSI:IGNORE ON}
         WriteLog('TBurningTool.SetBurnVerification',Format('Error %d last error [ %s ]',[ResultQI,SysErrorMessage(GetLastError)]),tplivError);
      {TSI:IGNORE OFF}
      {$ENDREGION}
  except on E:Exception do
    begin
      {$REGION 'Log'}
      {TSI:IGNORE ON}
         WriteLog('TBurningTool.SetBurnVerification',Format('Exception %s last error [ %s ]',[e.Message,SysErrorMessage(GetLastError)]),tplivException);
      {TSI:IGNORE OFF}
      {$ENDREGION}
    end;
  End;
End;

{Elimina il contenuto del disco riscrivibile}
Function TBurningTool.EraseDisk(IdexDriver,aSupportType:Integer;Eject:Boolean):Boolean;
Var DiskFormat : TMsftDiscFormat2Erase;
    ErrorMedia : Boolean;
    isSupportRW: Boolean;
    DataWriter : TMsftDiscFormat2Data;
begin
  Result := False;

  if not CheckAssignedAndActivationDrive(IdexDriver) then Exit;

  {$REGION 'Log'}
  {TSI:IGNORE ON}
     WriteLog('TBurningTool.EraseDisk',Format('Start Erase disk ',[]),tpLivInfo);
  {TSI:IGNORE OFF}
  {$ENDREGION}
  Try
    DataWriter            := TMsftDiscFormat2Data.Create(nil);
    DataWriter.AutoConnect:= False;
    DataWriter.ConnectKind:= ckRunningOrNew;
    DataWriter.Recorder   := FDiscRecord.DefaultInterface;
    DataWriter.ClientName := ExtractFileName(Application.ExeName);
    if not SetBurnVerification(DataWriter,IMAPI_BURN_VERIFICATION_QUICK) then
    begin
      {$REGION 'Log'}
      {TSI:IGNORE ON}
         WriteLog('TBurningTool.EraseDisk',Format('Unable set check disk erase',[]),tpLivWarning);
      {TSI:IGNORE OFF}
      {$ENDREGION}
    end;

    Try
      {Verifico se nell'unit� � presente almeno un disco altrimenti lo richiedo}
      if DiskIsPresentOnDrive(IdexDriver,DataWriter) then
      begin
        {Verifico se nell'unita c'� un disco idoneo al supporto}
        if CheckMediaBySupport(IdexDriver,aSupportType,isSupportRW,DataWriter) then
        begin
          {Verifico se nell'unitca c'� un disco vuoto}
          if Not isDiskEmpty(DataWriter,IdexDriver,ErrorMedia) then
          begin
            {verifico se nell'unit� c'� un dico rescrivibile}
            if isSupportRW then
            begin
              if Not isDiskWritable(DataWriter,IdexDriver,ErrorMedia) then
              begin
                {$REGION 'Log'}
                {TSI:IGNORE ON}
                   WriteLog('TBurningTool.EraseDisk',Format('Disk on drive is not rewritable',[]),tplivError);
                {TSI:IGNORE OFF}
                {$ENDREGION}
                Exit;
              end;
            end
            else
            begin
              {$REGION 'Log'}
              {TSI:IGNORE ON}
                 WriteLog('TBurningTool.EraseDisk',Format('Disk type on drive is not supported for erase ',[]),tplivError);
              {TSI:IGNORE OFF}
              {$ENDREGION}
              Exit;
            end;
          end
          else
          begin
            {il disco � vuoto non ha senzo fare una formattazione}
            Result := True;
            Exit;
          end;
        end
        else
          {$REGION 'Log'}
          {TSI:IGNORE ON}
             WriteLog('TBurningTool.EraseDisk',Format('Disk type on drive is not supported for erase [Different type] ',[]),tplivError);
          {TSI:IGNORE OFF}
          {$ENDREGION}
      end
      else
      begin
        {$REGION 'Log'}
        {TSI:IGNORE ON}
           WriteLog('TBurningTool.EraseDisk',Format('No Disk on drive',[]),tplivError);
        {TSI:IGNORE OFF}
        {$ENDREGION}
        Exit;
      end;
    Finally
      DataWriter.Disconnect;
      DataWriter.Free;
    End;

    DiskFormat := TMsftDiscFormat2Erase.Create(nil);
    Try
      DiskFormat.AutoConnect:= False;
      DiskFormat.ConnectKind:= ckRunningOrNew;

      DiskFormat.Recorder   := FDiscRecord.DefaultInterface;
      DiskFormat.ClientName := ExtractFileName(Application.ExeName);
      Try
        DiskFormat.FullErase  := True;
        DiskFormat.OnUpdate   := MsftEraseDataUpdate;
        DoOnProgressBurnCustom(Disk_Erase);
        DiskFormat.EraseMedia;
        DoOnProgressBurnCustom(Disk_Erase_compleate);
        Result := True;
        {$REGION 'Log'}
        {TSI:IGNORE ON}
           WriteLog('TBurningTool.EraseDisk','Erase disk compleate',tpLivInfo);
        {TSI:IGNORE OFF}
        {$ENDREGION}
        if Eject then
          FDiscRecord.EjectMedia;
      Except on E : Exception do
        begin
          {$REGION 'Log'}
          {TSI:IGNORE ON}
             WriteLog('TBurningTool.EraseDisk',Format('Exception erase [%s] last error [ %s ]',[e.Message,SysErrorMessage(GetLastError)]),tplivException);
          {TSI:IGNORE OFF}
          {$ENDREGION}
        end;
      End;
    Finally
      DiskFormat.Disconnect;
      DiskFormat.Free;
    End;
  Except on E : Exception do
    begin
      {$REGION 'Log'}
      {TSI:IGNORE ON}
         WriteLog('TBurningTool.EraseDisk',Format('Generic [%s] last error [ %s ]',[e.Message,SysErrorMessage(GetLastError)]),tplivException);
      {TSI:IGNORE OFF}
      {$ENDREGION}
    end;
  End;
end;

Function TBurningTool.IntFRecordAssigned:Boolean;
begin
  Result := Assigned(FDiscRecord);
  if Not Result  then
    {$REGION 'Log'}
    {TSI:IGNORE ON}
       WriteLog('TBurningTool.IntFRecordAssigned',Format('Interface of disk recorder not assigned ',[]),tplivError);
    {TSI:IGNORE OFF}
    {$ENDREGION}
end;

Function TBurningTool.IntFDiskMasterAssigned:Boolean;
begin
  Result := Assigned(FDiscMaster);
  if Not Result  then
    {$REGION 'Log'}
    {TSI:IGNORE ON}
       WriteLog('TBurningTool.IntFDiskMasterAssigned',Format('Interface of disk master not assigned ',[]),tplivError);
    {TSI:IGNORE OFF}
    {$ENDREGION}
end;

Function TBurningTool.IntFWriterAssigned(var aDataWriter:TMsftDiscFormat2Data):Boolean;
begin
  Result := Assigned(aDataWriter);
  if Not Result  then
    {$REGION 'Log'}
    {TSI:IGNORE ON}
       WriteLog('TBurningTool.IntFWriterAssigned',Format('Interface of disk writer not assigned ',[]),tplivError);
    {TSI:IGNORE OFF}
    {$ENDREGION}
end;

Function TBurningTool.FoundLetterDrive(aIndex:Integer;Var aLetterDrive : String):Boolean;

  procedure SearchOnList(aListaDrive:TStringList);
  var I : Integer;
  begin
    for I := 0 to aListaDrive.Count -1 do
    begin
      if Integer(aListaDrive.Objects[I]) = aIndex then
      begin
        Result       := True;
        aLetterDrive := aListaDrive.Strings[I];
        Break;
      end;
    end;
  end;

begin
  Result       := False;
  aLetterDrive := '';

  SearchOnList(FListaDriveCD);

  if not Result then
    SearchOnList(FListaDriveCD_DL);

  if not Result then
    SearchOnList(FListaDriveDVD);

  if not Result then
    SearchOnList(FListaDriveDVD_DL);

  if not Result then
    SearchOnList(FListaDriveBDR);

  if Not Result then
    {$REGION 'Log'}
    {TSI:IGNORE ON}
       WriteLog('TBurningTool.FoundLetterDrive',Format('Not found letter drive for idex [ %d ]',[aIndex]),tplivError)
    {TSI:IGNORE OFF}
    {$ENDREGION}
  else
    {$REGION 'Log'}
    {TSI:IGNORE ON}
       WriteLog('TBurningTool.FoundLetterDrive',Format('Drive letter [ %s ]',[aLetterDrive]),tpLivInfo);
    {TSI:IGNORE OFF}
    {$ENDREGION}
end;

Function TBurningTool.DiskIsPresentOnDrive(IdexDriver:Integer;var DataWriter:TMsftDiscFormat2Data):Boolean;
begin
  Result := False;
  if Not IntFWriterAssigned(DataWriter) then exit;
  if Not CheckAssignedAndActivationDrive(IdexDriver) then Exit;
  Try
    {$REGION 'Log'}
    {TSI:IGNORE ON}
       WriteLog('TBurningTool.DiskIsPresentOnDrive',Format('Check if disk is present on drive',[]),tpLivInfo);
    {TSI:IGNORE OFF}
    {$ENDREGION}
    Result := DataWriter.CurrentPhysicalMediaType <> IMAPI_MEDIA_TYPE_UNKNOWN;
    {$REGION 'Log'}
    {TSI:IGNORE ON}
       WriteLog('TBurningTool.DiskIsPresentOnDrive',Format('disk is present [ %s ]',[BoolToStr(Result,True)]),tpLivInfo);
    {TSI:IGNORE OFF}
    {$ENDREGION}
  Except on E: Exception do
    begin
      {$REGION 'Log'}
      {TSI:IGNORE ON}
         WriteLog('TBurningTool.DiskIsPresentOnDrive',Format('Error [ %s ]',[E.Message]),tpLivWarning);
      {TSI:IGNORE OFF}
      {$ENDREGION}
    end;
  End;
end;

function TBurningTool.CheckAssignedAndActivationDrive(IndexDriver:Integer):Boolean;
begin
  Result := False;

  if Not IntFRecordAssigned or
     Not IntFDiskMasterAssigned or
     Not ActiveDiskRecorder(IndexDriver) then Exit;

  Result := True;
end;

Function TBurningTool.CheckMediaBySupport(aIdexDriver:integer;aSupportType:integer;var aIsRW:Boolean;var aDataWriter:TMsftDiscFormat2Data) : Boolean;
begin
  Result := False;
  if Not IntFWriterAssigned(aDataWriter) then exit;
  if Not CheckAssignedAndActivationDrive(aIdexDriver) then Exit;

  {$REGION 'Log'}
  {TSI:IGNORE ON}
     WriteLog('TBurningTool.CheckMediaBySupport',Format('Check disk type ',[]),tpLivInfo);
  {TSI:IGNORE OFF}
  {$ENDREGION}
  aIsRW := False;

  Try
    case aDataWriter.CurrentPhysicalMediaType of
      IMAPI_MEDIA_TYPE_UNKNOWN              : {$REGION 'Log'}
                                              {TSI:IGNORE ON}
                                                 WriteLog('TBurningTool.CheckMediaBySupport',' Support type not present or unknown',tpLivInfo,True);
                                              {TSI:IGNORE OFF}
                                              {$ENDREGION}
      IMAPI_MEDIA_TYPE_CDROM                : {$REGION 'Log'}
                                              {TSI:IGNORE ON}
                                                 WriteLog('TBurningTool.CheckMediaBySupport',' Support type IMAPI_MEDIA_TYPE_CDROM',tpLivInfo,True);
                                              {TSI:IGNORE OFF}
                                              {$ENDREGION}
      IMAPI_MEDIA_TYPE_DISK                 : {$REGION 'Log'}
                                              {TSI:IGNORE ON}
                                                 WriteLog('TBurningTool.CheckMediaBySupport',' Support type IMAPI_MEDIA_TYPE_DISK',tpLivInfo,True);
                                              {TSI:IGNORE OFF}
                                              {$ENDREGION}
      IMAPI_MEDIA_TYPE_HDDVDROM             : {$REGION 'Log'}
                                              {TSI:IGNORE ON}
                                                 WriteLog('TBurningTool.CheckMediaBySupport',' Support type IMAPI_MEDIA_TYPE_HDDVDROM',tpLivInfo,True);
                                              {TSI:IGNORE OFF}
                                              {$ENDREGION}
      IMAPI_MEDIA_TYPE_HDDVDR               : {$REGION 'Log'}
                                              {TSI:IGNORE ON}
                                                 WriteLog('TBurningTool.CheckMediaBySupport',' Support type IMAPI_MEDIA_TYPE_HDDVDR',tpLivInfo,True);
                                              {TSI:IGNORE OFF}
                                              {$ENDREGION}
      IMAPI_MEDIA_TYPE_HDDVDRAM             : {$REGION 'Log'}
                                              {TSI:IGNORE ON}
                                                 WriteLog('TBurningTool.CheckMediaBySupport',' Support type IMAPI_MEDIA_TYPE_HDDVDRAM',tpLivInfo,True);
                                              {TSI:IGNORE OFF}
                                              {$ENDREGION}
      IMAPI_MEDIA_TYPE_BDROM                : {$REGION 'Log'}
                                              {TSI:IGNORE ON}
                                                WriteLog('TBurningTool.CheckMediaBySupport',' Support type IMAPI_MEDIA_TYPE_BDROM',tpLivInfo,True);
                                              {TSI:IGNORE OFF}
                                              {$ENDREGION}
      IMAPI_MEDIA_TYPE_CDR                  : begin
                                                {$REGION 'Log'}
                                                {TSI:IGNORE ON}
                                                  WriteLog('TBurningTool.CheckMediaBySupport',' Support type IMAPI_MEDIA_TYPE_CDR',tpLivInfo);
                                                {TSI:IGNORE OFF}
                                                {$ENDREGION}
                                                Result := aSupportType = TIPO_SUPPORT_CD;
                                              end;
      IMAPI_MEDIA_TYPE_CDRW                 : begin
                                                {$REGION 'Log'}
                                                {TSI:IGNORE ON}
                                                  WriteLog('TBurningTool.CheckMediaBySupport',' Support type IMAPI_MEDIA_TYPE_CDRW',tpLivInfo);
                                                {TSI:IGNORE OFF}
                                                {$ENDREGION}
                                                Result := aSupportType = TIPO_SUPPORT_CD;
                                                aIsRW   := True;
                                              end;
      IMAPI_MEDIA_TYPE_DVDROM               : {$REGION 'Log'}
                                              {TSI:IGNORE ON}
                                                WriteLog('TBurningTool.CheckMediaBySupport',' Support type IMAPI_MEDIA_TYPE_DVDROM',tpLivInfo,True);
                                              {TSI:IGNORE OFF}
                                              {$ENDREGION}
      IMAPI_MEDIA_TYPE_DVDRAM               : {$REGION 'Log'}
                                              {TSI:IGNORE ON}
                                                WriteLog('TBurningTool.CheckMediaBySupport',' Support type IMAPI_MEDIA_TYPE_DVDRAM',tpLivInfo,True);
                                              {TSI:IGNORE OFF}
                                              {$ENDREGION}
      IMAPI_MEDIA_TYPE_DVDPLUSR             : begin
                                                {$REGION 'Log'}
                                                {TSI:IGNORE ON}
                                                  WriteLog('TBurningTool.CheckMediaBySupport',' Support type IMAPI_MEDIA_TYPE_DVDPLUSR',tpLivInfo);
                                                {TSI:IGNORE OFF}
                                                {$ENDREGION}
                                                Result := aSupportType in [ TIPO_SUPPORT_DVD,TIPO_SUPPORT_CD];
                                              end;
      IMAPI_MEDIA_TYPE_DVDPLUSRW            : begin
                                                {$REGION 'Log'}
                                                {TSI:IGNORE ON}
                                                  WriteLog('TBurningTool.CheckMediaBySupport',' Support type IMAPI_MEDIA_TYPE_DVDPLUSRW',tpLivInfo);
                                                {TSI:IGNORE OFF}
                                                {$ENDREGION}
                                                Result := aSupportType in [ TIPO_SUPPORT_DVD,TIPO_SUPPORT_CD];
                                                aIsRW   := True;
                                              end;
      IMAPI_MEDIA_TYPE_DVDPLUSR_DUALLAYER   : begin
                                                {$REGION 'Log'}
                                                {TSI:IGNORE ON}
                                                  WriteLog('TBurningTool.CheckMediaBySupport',' Support type IMAPI_MEDIA_TYPE_DVDPLUSR_DUALLAYER',tpLivInfo);
                                                {TSI:IGNORE OFF}
                                                {$ENDREGION}
                                                Result := aSupportType in [ TIPO_SUPPORT_DVD_DL,TIPO_SUPPORT_DVD,TIPO_SUPPORT_CD];
                                              end;
      IMAPI_MEDIA_TYPE_DVDDASHR_DUALLAYER	  : begin
                                                {$REGION 'Log'}
                                                {TSI:IGNORE ON}
                                                  WriteLog('TBurningTool.CheckMediaBySupport',' Support type IMAPI_MEDIA_TYPE_DVDDASHR_DUALLAYER',tpLivInfo);
                                                {TSI:IGNORE OFF}
                                                {$ENDREGION}
                                                Result := aSupportType in [ TIPO_SUPPORT_DVD_DL,TIPO_SUPPORT_DVD,TIPO_SUPPORT_CD];
                                              end;
      IMAPI_MEDIA_TYPE_DVDDASHR             : begin
                                                {$REGION 'Log'}
                                                {TSI:IGNORE ON}
                                                  WriteLog('TBurningTool.CheckMediaBySupport',' Support type IMAPI_MEDIA_TYPE_DVDDASHR',tpLivInfo);
                                                {TSI:IGNORE OFF}
                                                {$ENDREGION}
                                                Result := aSupportType in [ TIPO_SUPPORT_DVD,TIPO_SUPPORT_CD];
                                              end;
      IMAPI_MEDIA_TYPE_DVDDASHRW 			      : begin
                                                {$REGION 'Log'}
                                                {TSI:IGNORE ON}
                                                  WriteLog('TBurningTool.CheckMediaBySupport',' Support type IMAPI_MEDIA_TYPE_DVDDASHRW',tpLivInfo);
                                                {TSI:IGNORE OFF}
                                                {$ENDREGION}
                                                Result := aSupportType in [ TIPO_SUPPORT_DVD,TIPO_SUPPORT_CD];
                                                aIsRW   := True;
                                              end;
      IMAPI_MEDIA_TYPE_DVDPLUSRW_DUALLAYER  : begin
                                                {$REGION 'Log'}
                                                {TSI:IGNORE ON}
                                                  WriteLog('TBurningTool.CheckMediaBySupport',' Support type IMAPI_MEDIA_TYPE_DVDPLUSRW_DUALLAYER',tpLivInfo);
                                                {TSI:IGNORE OFF}
                                                {$ENDREGION}
                                                Result := aSupportType in [ TIPO_SUPPORT_DVD_DL,TIPO_SUPPORT_DVD,TIPO_SUPPORT_CD];
                                                aIsRW   := True;
                                              end;
      IMAPI_MEDIA_TYPE_BDR                  : begin
                                                {$REGION 'Log'}
                                                {TSI:IGNORE ON}
                                                  WriteLog('TBurningTool.CheckMediaBySupport',' Support type IMAPI_MEDIA_TYPE_BDR',tpLivInfo);
                                                {TSI:IGNORE OFF}
                                                {$ENDREGION}
                                                Result := aSupportType in [ TIPO_SUPPORT_BDR,TIPO_SUPPORT_DVD,TIPO_SUPPORT_CD];
                                              end;
      IMAPI_MEDIA_TYPE_BDRE                 : begin
                                                {$REGION 'Log'}
                                                {TSI:IGNORE ON}
                                                  WriteLog('TBurningTool.CheckMediaBySupport',' Support type IMAPI_MEDIA_TYPE_BDRE',tpLivInfo);
                                                {TSI:IGNORE OFF}
                                                {$ENDREGION}
                                                Result := aSupportType in [ TIPO_SUPPORT_BDR,TIPO_SUPPORT_DVD,TIPO_SUPPORT_CD];
                                                aIsRW   := True;
                                              end
    else
      {$REGION 'Log'}
      {TSI:IGNORE ON}
        WriteLog('TBurningTool.CheckMediaBySupport',Format( 'Unknown media status [ %d ]',[aDataWriter.CurrentPhysicalMediaType]),tpLivWarning);
      {TSI:IGNORE OFF}
      {$ENDREGION}
    end;

    if Result then
    begin
      Result := aDataWriter.DefaultInterface.IsRecorderSupported(FDiscRecord.DefaultInterface);
      if Not Result then
        {$REGION 'Log'}
        {TSI:IGNORE ON}
          WriteLog('TBurningTool.CheckMediaBySupport',Format( 'IsRecorderSupported is false disk not supported for recording',[]),tplivError);
        {TSI:IGNORE OFF}
        {$ENDREGION}
    end;
  Except on E : Exception do
    {$REGION 'Log'}
    {TSI:IGNORE ON}
       WriteLog('TBurningTool.CheckMediaBySupport',Format('Exception [%s] last error [ %s ]',[e.Message,SysErrorMessage(GetLastError)]),tplivException);
    {TSI:IGNORE OFF}
    {$ENDREGION}
  End;
end;

Function TBurningTool.CheckMedia(var DataWriter:TMsftDiscFormat2Data;IdexDriver:integer;ChecStatus : Array of Word;var ErrorDisc:boolean;Var CurrentStatatus:Word) : Boolean;
var I         : LongInt;
    sFlag     : Word;

    Procedure SetResult(iCurrenStatus:Word);
    var X: integer;
    begin
      Result := False;
      for X := 0 to Length(ChecStatus) do
      begin
        if ChecStatus[X] = iCurrenStatus then
        begin
          Result := True;
          Break;
        end;
      end;
    end;

begin
  Result := False;

  if Not IntFWriterAssigned(DataWriter) then exit;
  if Not CheckAssignedAndActivationDrive(IdexDriver) then Exit;
  {$REGION 'Log'}
  {TSI:IGNORE ON}
     WriteLog('TBurningTool.CheckMedia',Format('CheckMedia ',[]),tpLivInfo);
  {TSI:IGNORE OFF}
  {$ENDREGION}

  { IMAPI_FORMAT2_DATA_MEDIA_STATE_UNKNOWN
    Indicates that the interface does not know the media state.
    IMAPI_FORMAT2_DATA_MEDIA_STATE_INFORMATIONAL_MASK
    Reports information (but not errors) about the media state.
    IMAPI_FORMAT2_DATA_MEDIA_STATE_UNSUPPORTED_MASK
    Reports an unsupported media state.
    IMAPI_FORMAT2_DATA_MEDIA_STATE_OVERWRITE_ONLY
    Write operations can occur on used portions of the disc.
    IMAPI_FORMAT2_DATA_MEDIA_STATE_RANDOMLY_WRITABLE
    Media is randomly writable. This indicates that a single session can be written to this disc.
    Note  This value is deprecated and superseded by IMAPI_FORMAT2_DATA_MEDIA_STATE_OVERWRITE_ONLY.

    IMAPI_FORMAT2_DATA_MEDIA_STATE_BLANK
    Media has never been used, or has been erased.
    IMAPI_FORMAT2_DATA_MEDIA_STATE_APPENDABLE
    Media is appendable (supports multiple sessions).
    IMAPI_FORMAT2_DATA_MEDIA_STATE_FINAL_SESSION
    Media can have only one additional session added to it, or the media does not support multiple sessions.
    IMAPI_FORMAT2_DATA_MEDIA_STATE_DAMAGED
    Media is not usable by this interface. The media might require an erase or other recovery.
    IMAPI_FORMAT2_DATA_MEDIA_STATE_ERASE_REQUIRED
    Media must be erased prior to use by this interface.
    IMAPI_FORMAT2_DATA_MEDIA_STATE_NON_EMPTY_SESSION
    Media has a partially written last session, which is not supported by this interface.
    IMAPI_FORMAT2_DATA_MEDIA_STATE_WRITE_PROTECTED
    Media or drive is write-protected.
    IMAPI_FORMAT2_DATA_MEDIA_STATE_FINALIZED
    Media cannot be written to (finalized).
    IMAPI_FORMAT2_DATA_MEDIA_STATE_UNSUPPORTED_MEDIA
    Media is not supported by this interface.}

  ErrorDisc := False;
  case DataWriter.CurrentMediaStatus of
    IMAPI_FORMAT2_DATA_MEDIA_STATE_UNKNOWN 			      : begin
                                                          {$REGION 'Log'}
                                                          {TSI:IGNORE ON}
                                                            WriteLog('TBurningTool.CheckMedia','Media state IMAPI_FORMAT2_DATA_MEDIA_STATE_UNKNOWN',tpLivInfo);
                                                            WriteLog('TBurningTool.CheckMedia','The interface does not know the media state',tpLivWarning);
                                                          {TSI:IGNORE OFF}
                                                          {$ENDREGION}
                                                          CurrentStatatus := IMAPI_FORMAT2_DATA_MEDIA_STATE_UNKNOWN;
                                                          SetResult(IMAPI_FORMAT2_DATA_MEDIA_STATE_UNKNOWN);
                                                        end;
    IMAPI_FORMAT2_DATA_MEDIA_STATE_INFORMATIONAL_MASK : begin
                                                          {$REGION 'Log'}
                                                          {TSI:IGNORE ON}
                                                            WriteLog('TBurningTool.CheckMedia','Media state IMAPI_FORMAT2_DATA_MEDIA_STATE_INFORMATIONAL_MASK',tpLivInfo);
                                                            WriteLog('TBurningTool.CheckMedia','Reports information (but not errors) about the media state.',tpLivWarning);
                                                          {TSI:IGNORE OFF}
                                                          {$ENDREGION}
                                                          CurrentStatatus := IMAPI_FORMAT2_DATA_MEDIA_STATE_INFORMATIONAL_MASK;
                                                          SetResult(IMAPI_FORMAT2_DATA_MEDIA_STATE_INFORMATIONAL_MASK);
                                                        end;
    IMAPI_FORMAT2_DATA_MEDIA_STATE_UNSUPPORTED_MASK   : begin
                                                          {$REGION 'Log'}
                                                          {TSI:IGNORE ON}
                                                            WriteLog('TBurningTool.CheckMedia','Media state IMAPI_FORMAT2_DATA_MEDIA_STATE_UNSUPPORTED_MASK',tpLivInfo);
                                                            WriteLog('TBurningTool.CheckMedia','Reports an unsupported media state.',tplivError);
                                                          {TSI:IGNORE OFF}
                                                          {$ENDREGION}
                                                          CurrentStatatus := IMAPI_FORMAT2_DATA_MEDIA_STATE_UNSUPPORTED_MASK;
                                                          SetResult(IMAPI_FORMAT2_DATA_MEDIA_STATE_UNSUPPORTED_MASK);
                                                          ErrorDisc       := True;
                                                        end;
    IMAPI_FORMAT2_DATA_MEDIA_STATE_OVERWRITE_ONLY     : begin
                                                          {$REGION 'Log'}
                                                          {TSI:IGNORE ON}
                                                            WriteLog('TBurningTool.CheckMedia','Media state IMAPI_FORMAT2_DATA_MEDIA_STATE_OVERWRITE_ONLY',tpLivInfo);
                                                          {TSI:IGNORE OFF}
                                                          {$ENDREGION}
                                                          CurrentStatatus := IMAPI_FORMAT2_DATA_MEDIA_STATE_OVERWRITE_ONLY;
                                                          SetResult(IMAPI_FORMAT2_DATA_MEDIA_STATE_OVERWRITE_ONLY);
                                                        end;
    IMAPI_FORMAT2_DATA_MEDIA_STATE_BLANK              : begin
                                                          {$REGION 'Log'}
                                                          {TSI:IGNORE ON}
                                                            WriteLog('TBurningTool.CheckMedia','Media state IMAPI_FORMAT2_DATA_MEDIA_STATE_BLANK',tpLivInfo);
                                                          {TSI:IGNORE OFF}
                                                          {$ENDREGION}
                                                          CurrentStatatus := IMAPI_FORMAT2_DATA_MEDIA_STATE_BLANK;
                                                          SetResult(IMAPI_FORMAT2_DATA_MEDIA_STATE_BLANK);
                                                        end;
    IMAPI_FORMAT2_DATA_MEDIA_STATE_APPENDABLE         : begin
                                                          {$REGION 'Log'}
                                                          {TSI:IGNORE ON}
                                                            WriteLog('TBurningTool.CheckMedia','Media state IMAPI_FORMAT2_DATA_MEDIA_STATE_APPENDABLE',tpLivInfo);
                                                          {TSI:IGNORE OFF}
                                                          {$ENDREGION}
                                                          CurrentStatatus := IMAPI_FORMAT2_DATA_MEDIA_STATE_APPENDABLE;
                                                          SetResult(IMAPI_FORMAT2_DATA_MEDIA_STATE_APPENDABLE);
                                                        end;
    IMAPI_FORMAT2_DATA_MEDIA_STATE_FINAL_SESSION      : begin
                                                          {$REGION 'Log'}
                                                          {TSI:IGNORE ON}
                                                            WriteLog('TBurningTool.CheckMedia','Media state IMAPI_FORMAT2_DATA_MEDIA_STATE_FINAL_SESSION',tpLivInfo);
                                                          {TSI:IGNORE OFF}
                                                          {$ENDREGION}
                                                          CurrentStatatus := IMAPI_FORMAT2_DATA_MEDIA_STATE_FINAL_SESSION;
                                                          SetResult(IMAPI_FORMAT2_DATA_MEDIA_STATE_FINAL_SESSION);
                                                        end;
    IMAPI_FORMAT2_DATA_MEDIA_STATE_DAMAGED            : begin
                                                          {$REGION 'Log'}
                                                          {TSI:IGNORE ON}
                                                            WriteLog('TBurningTool.CheckMedia','Media state IMAPI_FORMAT2_DATA_MEDIA_STATE_DAMAGED',tpLivInfo);
                                                            WriteLog('TBurningTool.CheckMedia','Media is not usable by this interface. The media might require an erase or other recovery.',tplivError);
                                                          {TSI:IGNORE OFF}
                                                          {$ENDREGION}
                                                          CurrentStatatus := IMAPI_FORMAT2_DATA_MEDIA_STATE_FINAL_SESSION;
                                                          SetResult(IMAPI_FORMAT2_DATA_MEDIA_STATE_FINAL_SESSION);
                                                          ErrorDisc := True;
                                                        end;
    IMAPI_FORMAT2_DATA_MEDIA_STATE_ERASE_REQUIRED     : begin
                                                          {$REGION 'Log'}
                                                          {TSI:IGNORE ON}
                                                            WriteLog('TBurningTool.CheckMedia','Media state IMAPI_FORMAT2_DATA_MEDIA_STATE_ERASE_REQUIRED',tpLivInfo);
                                                          {TSI:IGNORE OFF}
                                                          {$ENDREGION}
                                                          CurrentStatatus := IMAPI_FORMAT2_DATA_MEDIA_STATE_ERASE_REQUIRED;
                                                          SetResult(IMAPI_FORMAT2_DATA_MEDIA_STATE_ERASE_REQUIRED);
                                                        end;
    IMAPI_FORMAT2_DATA_MEDIA_STATE_NON_EMPTY_SESSION  : begin
                                                          {$REGION 'Log'}
                                                          {TSI:IGNORE ON}
                                                            WriteLog('TBurningTool.CheckMedia','Media state IMAPI_FORMAT2_DATA_MEDIA_STATE_NON_EMPTY_SESSION',tpLivInfo);
                                                          {TSI:IGNORE OFF}
                                                          {$ENDREGION}
                                                          CurrentStatatus := IMAPI_FORMAT2_DATA_MEDIA_STATE_NON_EMPTY_SESSION;
                                                          SetResult(IMAPI_FORMAT2_DATA_MEDIA_STATE_NON_EMPTY_SESSION);
                                                        end;
    IMAPI_FORMAT2_DATA_MEDIA_STATE_WRITE_PROTECTED    : begin
                                                          {$REGION 'Log'}
                                                          {TSI:IGNORE ON}
                                                            WriteLog('TBurningTool.CheckMedia','Media state IMAPI_FORMAT2_DATA_MEDIA_STATE_WRITE_PROTECTED',tpLivInfo);
                                                          {TSI:IGNORE OFF}
                                                          {$ENDREGION}
                                                          CurrentStatatus := IMAPI_FORMAT2_DATA_MEDIA_STATE_WRITE_PROTECTED;
                                                          SetResult(IMAPI_FORMAT2_DATA_MEDIA_STATE_WRITE_PROTECTED);
                                                        end;
    IMAPI_FORMAT2_DATA_MEDIA_STATE_UNSUPPORTED_MEDIA  : begin
                                                          {$REGION 'Log'}
                                                          {TSI:IGNORE ON}
                                                            WriteLog('TBurningTool.CheckMedia','Media state IMAPI_FORMAT2_DATA_MEDIA_STATE_UNSUPPORTED_MEDIA',tpLivInfo);
                                                            WriteLog('TBurningTool.CheckMedia','Media state IMAPI_FORMAT2_DATA_MEDIA_STATE_UNSUPPORTED_MEDIA',tpLivInfo);
                                                          {TSI:IGNORE OFF}
                                                          {$ENDREGION}
                                                          CurrentStatatus := IMAPI_FORMAT2_DATA_MEDIA_STATE_UNSUPPORTED_MEDIA;
                                                          SetResult(IMAPI_FORMAT2_DATA_MEDIA_STATE_UNSUPPORTED_MEDIA);
                                                          ErrorDisc := True;
                                                        end;
    IMAPI_FORMAT2_DATA_MEDIA_STATE_FINALIZED			    : begin
                                                          {$REGION 'Log'}
                                                          {TSI:IGNORE ON}
                                                            WriteLog('TBurningTool.CheckMedia','Media state IMAPI_FORMAT2_DATA_MEDIA_STATE_FINALIZED',tpLivInfo);
                                                          {TSI:IGNORE OFF}
                                                          {$ENDREGION}
                                                          CurrentStatatus := IMAPI_FORMAT2_DATA_MEDIA_STATE_FINALIZED;
                                                          SetResult(IMAPI_FORMAT2_DATA_MEDIA_STATE_FINALIZED);
                                                        end;

    (IMAPI_FORMAT2_DATA_MEDIA_STATE_APPENDABLE+
    IMAPI_FORMAT2_DATA_MEDIA_STATE_BLANK )            : begin
                                                          {$REGION 'Log'}
                                                          {TSI:IGNORE ON}
                                                             WriteLog('TBurningTool.CheckMedia','Media state IMAPI_FORMAT2_DATA_MEDIA_STATE_APPENDABLE + IMAPI_FORMAT2_DATA_MEDIA_STATE_BLANK',tpLivInfo);
                                                          {TSI:IGNORE OFF}
                                                          {$ENDREGION}
                                                          CurrentStatatus := IMAPI_FORMAT2_DATA_MEDIA_STATE_BLANK+IMAPI_FORMAT2_DATA_MEDIA_STATE_APPENDABLE;
                                                          SetResult(IMAPI_FORMAT2_DATA_MEDIA_STATE_BLANK);
                                                          if Not Result then
                                                            SetResult(IMAPI_FORMAT2_DATA_MEDIA_STATE_APPENDABLE);
                                                        end
  else
    {$REGION 'Log'}
    {TSI:IGNORE ON}
       WriteLog('TBurningTool.CheckMedia',Format( 'Media state [ %d ]',[DataWriter.CurrentMediaStatus]),tpLivWarning);
    {TSI:IGNORE OFF}
    {$ENDREGION}
  end;

  if Not Result then
  begin
    sFlag := 0;
    {Non stampo i log pero effettuo una verifica con operatori BTIWASE}
    for I := 0 to Length(ChecStatus) do
    begin
      if I = 0 then
        sFlag := ChecStatus [I]
      else
        sFlag := sFlag or ChecStatus [I];
    end;

    Result := DataWriter.CurrentMediaStatus and sFlag <> 0;
  end;

end;

Function TBurningTool.isDiskEmpty(var DataWriter:TMsftDiscFormat2Data;IdexDriver:integer;var ErrorMedia : Boolean) : Boolean;
var MediaStatus  : Word;
    ChecStatus   : Array of Word;
    iRetry       : Integer;
    Max_Retry    : integer;
begin
  {$REGION 'Log'}
  {TSI:IGNORE ON}
     WriteLog('TBurningTool.isDiskEmpty',Format('Check if disk is blank',[]),tpLivInfo);
  {TSI:IGNORE OFF}
  {$ENDREGION}
  Max_Retry  := DEFAULT_MAX_RETRY;
  ErrorMedia := False;
  iRetry     := 0;

  SetLength(ChecStatus,1);
  ChecStatus[0] := IMAPI_FORMAT2_DATA_MEDIA_STATE_BLANK;
  repeat
    Result := CheckMedia(DataWriter,IdexDriver,ChecStatus,ErrorMedia,MediaStatus);
    if Not result then
      ErrorMedia := MediaStatus <> IMAPI_FORMAT2_DATA_MEDIA_STATE_UNKNOWN;

    {Faccio al massimo 3 tentatvi poi do errore}
    if not ErrorMedia then
    begin
      {$REGION 'Log'}
      {TSI:IGNORE ON}
         WriteLog('TBurningTool.isDiskEmpty',Format('Retry check media',[]),tpLivWarning);
      {TSI:IGNORE OFF}
      {$ENDREGION}
      Sleep(2000);
      Inc(iRetry);
      ErrorMedia := iRetry >= MAX_RETRY;
    end

  until result or ErrorMedia or FAbort;

  if FAbort then Exit;

  if not Result then
    Result := DataWriter.DefaultInterface.MediaHeuristicallyBlank;

  if Result then
   ErrorMedia := False;

  if ErrorMedia then
    {$REGION 'Log'}
    {TSI:IGNORE ON}
       WriteLog('TBurningTool.isDiskEmpty',Format('Check media timeout abort',[]),tplivError);
    {TSI:IGNORE OFF}
    {$ENDREGION}

  {$REGION 'Log'}
  {TSI:IGNORE ON}
     WriteLog('TBurningTool.isDiskEmpty',Format('Is blank [ %s ]',[BoolToStr(Result,True)]),tpLivInfo);
  {TSI:IGNORE OFF}
  {$ENDREGION}
  SetLength(ChecStatus,0);
end;


Function TBurningTool.isDiskWritable(var DataWriter:TMsftDiscFormat2Data;IdexDriver:integer;var ErrorMedia : Boolean) : Boolean;
var MediaStatus  : Word;
    ChecStatus   : Array of Word;
    iRetry       : Integer;
    Max_Retry    : integer;
label RetryChecMedia;
begin
  {$REGION 'Log'}
  {TSI:IGNORE ON}
     WriteLog('TBurningTool.isDicWritable',Format('Check if disk is Re-writable',[]),tpLivInfo);
  {TSI:IGNORE OFF}
  {$ENDREGION}
  Result  := False;
  iRetry  := 0;
  SetLength(ChecStatus,4);
  ChecStatus[0] := IMAPI_FORMAT2_DATA_MEDIA_STATE_ERASE_REQUIRED;
  ChecStatus[1] := IMAPI_FORMAT2_DATA_MEDIA_STATE_APPENDABLE;
  ChecStatus[2] := IMAPI_FORMAT2_DATA_MEDIA_STATE_BLANK;
  ChecStatus[3] := IMAPI_FORMAT2_DATA_MEDIA_STATE_FINALIZED;
  Max_Retry     := DEFAULT_MAX_RETRY;
  RetryChecMedia:
  if Not CheckMedia(DataWriter,IdexDriver,ChecStatus,ErrorMedia,MediaStatus) then
  begin
    if FAbort then Exit;
    {Faccio al massimo 3 tentatvi poi do errore}
    if MediaStatus = IMAPI_FORMAT2_DATA_MEDIA_STATE_UNKNOWN then
    begin
      {$REGION 'Log'}
      {TSI:IGNORE ON}
         WriteLog('TBurningTool.isDicWritable',Format('Retry check media',[]),tpLivWarning);
      {TSI:IGNORE OFF}
      {$ENDREGION}
      Sleep(2000);
      Inc(iRetry);

      if iRetry < Max_Retry then
        Goto RetryChecMedia
      else
      begin
        {$REGION 'Log'}
        {TSI:IGNORE ON}
           WriteLog('TBurningTool.isDicWritable',Format('Check media timeout abort',[]),tplivError);
        {TSI:IGNORE OFF}
        {$ENDREGION}
        ErrorMedia := True;
      end;
    end;
  end
  else
    Result := True;

  {$REGION 'Log'}
  {TSI:IGNORE ON}
     WriteLog('TBurningTool.isDicWritable',Format('Is rewritable [ %s ]',[BoolToStr(Result,True)]),tpLivInfo);
  {TSI:IGNORE OFF}
  {$ENDREGION}
  SetLength(ChecStatus,0);
end;

Procedure TBurningTool.DoOnProgressBurnCustom(Const SInfo:String;AllowAbort:Boolean=True);
begin
  if Assigned(FOnProgressBurn) then
  begin
    {$REGION 'Log'}
    {TSI:IGNORE ON}
       WriteLog('TBurningTool.DoOnProgressBurnCustom',Format('%s',[SInfo]),tpLivInfo);
    {TSI:IGNORE OFF}
    {$ENDREGION}
    FOnProgressBurn(self,SInfo,0,False,False,0,AllowAbort)
  end;
end;

Function TBurningTool.BurningDiskImage(aIdexDriver,aSupportType:Integer;Const aSPathIso,aCaptionDisk:String;aCheckDisk:Boolean):TStatusBurn;
var aLetterDrive : String;
    DriveisRead  : Boolean;
    iRetry       : Integer;
    DataWriter   : TMsftDiscFormat2Data;
    Max_Retry    : Integer;

    Function CheckABort(var OwnerResult : TStatusBurn ) : Boolean;
    begin
      Result := Not FAbort;
      if FAbort then
        OwnerResult := SbAbort;
    end;

    function SetCheckDisk:Boolean;
    begin
      Result := True;
      {Imposto la verifica del disco}
      if aCheckDisk then
      begin
        if Not SetBurnVerification(DataWriter,IMAPI_BURN_VERIFICATION_FULL) then
        begin
          {$REGION 'Log'}
          {TSI:IGNORE ON}
             WriteLog('TBurningTool.SetCheckDisk',Format('[ SetCheckDisk ] Unable set burn verification last error [ %s ]',[SysErrorMessage(GetLastError)]),tplivError);
          {TSI:IGNORE OFF}
          {$ENDREGION}
          Result := False;
        end;
      end
      else
      begin
        if Not SetBurnVerification(DataWriter,IMAPI_BURN_VERIFICATION_QUICK) then
          {$REGION 'Log'}
          {TSI:IGNORE ON}
             WriteLog('TBurningTool.SetCheckDisk',Format('[ SetCheckDisk ] Unable set burn verification last error [ %s ]',[SysErrorMessage(GetLastError)]),tpLivWarning);
          {TSI:IGNORE OFF}
          {$ENDREGION}
      end;
    end;
begin
  {$REGION 'Log'}
  {TSI:IGNORE ON}
     WriteLog('TBurningTool.BurningDiskImage',Format('Start function',[]),tpLivInfo);
  {TSI:IGNORE OFF}
  {$ENDREGION}

  Result      := SbError;
  FWriting    := False;
  FAbort      := False;
  iRetry      := 0;

  if Not FileExists(aSPathIso) then
  begin
    {$REGION 'Log'}
    {TSI:IGNORE ON}
       WriteLog('TBurningTool.BurningDiskImage',Format('ISO file not exist [ %s ]',[aSPathIso ]),tpLivInfo);
    {TSI:IGNORE OFF}
    {$ENDREGION}
    Exit;
  end;

  DoOnProgressBurnCustom(Sync_Driver);

  if not CheckAssignedAndActivationDrive(aIdexDriver) then Exit;
  if Not FoundLetterDrive(aIdexDriver,aLetterDrive) then Exit;

  DataWriter := TMsftDiscFormat2Data.Create(nil);
  Try
    if Not CheckABort(Result) then Exit;

    Try
      DataWriter.AutoConnect := False;
      DataWriter.ConnectKind := ckRunningOrNew;
      DataWriter.ClientName  := ExtractFileName(Application.ExeName);
      DataWriter.Recorder    := FDiscRecord.DefaultInterface;
      DataWriter.OnUpdate    := MsftDiscFormat2DataUpdate;

      {Prendo il controllo esclusivo del driver}
      DoOnProgressBurnCustom(Acq_driver);

      {Chiudo il cassetto eventualmente aperto}
      If not CloseTray(aIdexDriver) then exit;
      Sleep(5000);

      {$REGION 'Log'}
      {TSI:IGNORE ON}
         WriteLog('TBurningTool.BurningDiskImage',Format('Check disk status',[]),tpLivInfo);
      {TSI:IGNORE OFF}
      {$ENDREGION}
      DoOnProgressBurnCustom(Verifying_disk);
      {$REGION 'Log'}
      {TSI:IGNORE ON}
         WriteLog('TBurningTool.BurningDiskImage',Format('Associating disk record interface',[]),tpLivInfo);
      {TSI:IGNORE OFF}
      {$ENDREGION}

      {Imposto eventuale verifica del disco}
      if Not SetCheckDisk then Exit;

      Max_Retry := DEFAULT_MAX_RETRY;
      {Verifica disco inserito con eventuale ERASE se abilitato}
      repeat
         if Not CheckABort(Result) then Exit;
         Inc(iRetry);
         DriveisRead := MngInsertDisk(aIdexDriver,aSupportType,DataWriter,aLetterDrive,iRetry);
         Sleep(5000);
      until ( DriveisRead ) or ( iRetry >= Max_Retry) or ( Result = SbAbort );

      if Not CheckABort(Result) or not DriveisRead then Exit;

      WriteIso(DataWriter,aIdexDriver,aSupportType,aCaptionDisk,aSPathIso,Result);
    Except on E : Exception do
      begin
        {$REGION 'Log'}
        {TSI:IGNORE ON}
           WriteLog('TBurningTool.BurningDiskImage',Format('Exception [ %s ] last error [ %s ]',[e.Message,SysErrorMessage(GetLastError)]),tplivException);
        {TSI:IGNORE OFF}
        {$ENDREGION}
        Result := SbError;
      end;
    End;
  Finally
    {$REGION 'Log'}
    {TSI:IGNORE ON}
       WriteLog('TBurningTool.BurningDiskImage',Format('End function disconneting driver',[]),tpLivInfo);
    {TSI:IGNORE OFF}
    {$ENDREGION}
    FCurrentWriter  := nil;
    DataWriter.Disconnect;
    DataWriter.Free;
    if FCancelWriting then
      FOnProgressBurn(self,Cancellation,0,False,True,0,False);
  End;
end;

Function TBurningTool.GetMaxWriteSectorsPerSecondSupported(Const aDataWriter:TMsftDiscFormat2Data;aIndexDriver,aSupportType:Integer) : Integer;

var SupportWriteSpeedDescriptors : PSafeArray;
    I                            : LongInt;
    vTmp                         : Variant;
    LBound,
    HBound                       : LongInt;
    HumanSpeed                   : Integer;

    Function RemoveXHumanSpeed(const humanSpeed:string):Integer;
    begin
      Result := StrToIntDef(StringReplace(humanSpeed,'X','',[rfIgnoreCase,rfReplaceAll]).Trim,0);
    end;
begin
  Result := -1;
  if Not CheckAssignedAndActivationDrive(aIndexDriver) then Exit;

  Try
    //SupportWriteSpeedDescriptors := DataWriter.SupportedWriteSpeedDescriptors;
    SupportWriteSpeedDescriptors := aDataWriter.SupportedWriteSpeeds;
    Try
      SafeArrayGetLBound(SupportWriteSpeedDescriptors, 1, LBound);
      SafeArrayGetUBound(SupportWriteSpeedDescriptors, 1, HBound);
      {Rescrivibili}
      for I := HBound downto LBound do
      begin
        SafeArrayGetElement(SupportWriteSpeedDescriptors, I, vTmp);

        if VarIsNull(vTmp) then Continue;
        //if not Supports(vTmp, IWriteSpeedDescriptor, WriteSpeedDescriptor) then Continue;

     //   if ( Result < WriteSpeedDescriptor.WriteSpeed )   then
     //     Result := WriteSpeedDescriptor.WriteSpeed;
        HumanSpeed := RemoveXHumanSpeed(GetHumanSpeedWrite(vTmp,aSupportType));
        if Result <= Integer(vTmp)  then
        begin
            Result := vTmp;
        end;

        {$REGION 'Log'}
        {TSI:IGNORE ON}
           WriteLog('TBurningTool.GetMaxWriteSectorsPerSecondSupported',Format('Supported write speed [%dX]',[HumanSpeed]),tpLivInfo);
        {TSI:IGNORE OFF}
        {$ENDREGION}
      end;
    Finally
      SafeArrayDestroy(SupportWriteSpeedDescriptors); // cleanup PSafeArray
    End;
  Except on E: Exception do
    {$REGION 'Log'}
    {TSI:IGNORE ON}
       WriteLog('TBurningTool.GetMaxWriteSectorsPerSecondSupported',Format('Exception message [ %s ]',[E.Message]),tplivException);
    {TSI:IGNORE OFF}
    {$ENDREGION}
  End;
end;

Function TBurningTool.GetHumanSpeedWrite(aSectorForSecond:Integer;aSupportType:Integer):string;
var Factor : Integer;
begin
  Factor := IMAPI_SECTORS_PER_SECOND_AT_1X_CD;
  case aSupportType of
    TIPO_SUPPORT_CD     : Factor := IMAPI_SECTORS_PER_SECOND_AT_1X_CD;
//    TIPO_SUPPORTO_CD_DL  : Factor := IMAPI_SECTORS_PER_SECOND_AT_1X_CD;
    TIPO_SUPPORT_DVD    : Factor := IMAPI_SECTORS_PER_SECOND_AT_1X_DVD;
    TIPO_SUPPORT_DVD_DL : Factor := IMAPI_SECTORS_PER_SECOND_AT_1X_DVD;
    TIPO_SUPPORT_BDR    : Factor := IMAPI_SECTORS_PER_SECOND_AT_1X_BD;
  end;

  result := Format('%dX',[aSectorForSecond div Factor]);
end;

procedure TBurningTool.CancelWriting;
begin
  Try
    if assigned(FCurrentWriter) then
    begin
      {$REGION 'Log'}
      {TSI:IGNORE ON}
         WriteLog('TBurningTool.CancelWriting',Format('Request cancel burning',[]),tpLivInfo);
      {TSI:IGNORE OFF}
      {$ENDREGION}
      if FWriting and not FCancelWriting then
      begin
        {$REGION 'Log'}
        {TSI:IGNORE ON}
           WriteLog('TBurningTool.CancelWriting',Format('Call IMAPI2 cancel burning',[]),tpLivInfo);
        {TSI:IGNORE OFF}
        {$ENDREGION}
        FCurrentWriter.CancelWrite;
      end;
      FCancelWriting := True;
    end;
  Except On E: Exception do
    {$REGION 'Log'}
    {TSI:IGNORE ON}
       WriteLog('TBurningTool.CancelWriting',Format('Exception message [ %s ]',[E.Message]),tplivException);
    {TSI:IGNORE OFF}
    {$ENDREGION}
  End;
end;

Procedure TBurningTool.WriteIso(Var  aDataWriter:TMsftDiscFormat2Data;aIndexDriver,aSupportType:Integer;const aCaptionDisk,aPathIso:string;var aStatusWrite : TStatusBurn);
const IMAPI_MEDIA_BUSY = -1062600185;
var DiscStream : IMAPI2FS_TLB.IStream;
    IsoLoader  : TMsftIsoImageManager;

    Procedure SetError;
    begin
      Try
        CancelBurning;
      Finally
        aStatusWrite := SbError;
        FWriting    := False;
      End;
    end;

    Procedure InternalWrite;
    begin
      Try

        Try
          (*  Try
              DataWriter.SetWriteSpeed(GetMaxWriteSectorsPerSecondSupported(DataWriter,IndexDriver,TipoSupporto),WordBool(0));
            Except
              on E : EOleException do
                {$REGION 'Log'}
                {TSI:IGNORE ON}
                   WriteLog('TBurningTool.InternalWrite[SetWriteSpeed]',Format('Exception Ole [ %d ] message [ %s ] ',[E.ErrorCode,E.Message]),tplivException);
                {TSI:IGNORE OFF}
                {$ENDREGION}
              On E: Exception do
              {$REGION 'Log'}
              {TSI:IGNORE ON}
                 WriteLog('TBurningTool.InternalWrite[SetWriteSpeed]',Format('Exception message [ %s ] ',[E.Message]),tplivException);
              {TSI:IGNORE OFF}
              {$ENDREGION}
            End;
            *)
          {$REGION 'Log'}
          {TSI:IGNORE ON}
             WriteLog('TBurningTool.InternalWrite',Format('Start writing disk,speed of %s has been set',[GetHumanSpeedWrite(aDataWriter.CurrentWriteSpeed,aSupportType)]),tpLivInfo);
          {TSI:IGNORE OFF}
          {$ENDREGION}
          FWriting       := True;
          FCurrentWriter := aDataWriter;
          aStatusWrite    := SbBurning;
          aDataWriter.Write(IMAPI2_TLB.IStream(DiscStream));

          if FAbort then Exit;

          if Assigned(FOnProgressBurn) then
            FOnProgressBurn(self,Burn_completed,0,True,False,0,True);
          DriveEject(aIndexDriver);
          aStatusWrite := SbBurned;

        Except

          on E : EOleException do
          begin
            SetError;
            if IMAPI_MEDIA_BUSY = E.ErrorCode then
              {$REGION 'Log'}
              {TSI:IGNORE ON}
                 WriteLog('TBurningTool.InternalWrite',Format('E_IMAPI_RECORDER_MEDIA_BUSY Ole [ %d ] message [ %s ]',[E.ErrorCode,E.Message]),tpLivWarning)
              {TSI:IGNORE OFF}
              {$ENDREGION}
            else
              {$REGION 'Log'}
              {TSI:IGNORE ON}
                 WriteLog('TBurningTool.InternalWrite',Format('Exception Ole [ %d ] message [ %s ] ',[E.ErrorCode,E.Message]),tplivException);
              {TSI:IGNORE OFF}
              {$ENDREGION}
          end;

          On E: Exception do
          begin
            {$REGION 'Log'}
            {TSI:IGNORE ON}
               WriteLog('TBurningTool.InternalWrite',Format('Exception message [ %s ]',[E.Message]),tplivException);
            {TSI:IGNORE OFF}
            {$ENDREGION}
            SetError;
          end;

        End;
      Finally
       // FDiscRecord.ReleaseExclusiveAccess;
      End;

    end;
begin
  if Not CheckAssignedAndActivationDrive(aIndexDriver) then Exit;

  {$REGION 'Log'}
  {TSI:IGNORE ON}
     WriteLog('TBurningTool.WriteIso',Format('Create ISO file loader',[]),tpLivInfo);
  {TSI:IGNORE OFF}
  {$ENDREGION}
  DiscStream     := nil;
  FCancelWriting := False;
  IsoLoader      := TMsftIsoImageManager.Create(nil);
  Try
    Try
      {$REGION 'Log'}
      {TSI:IGNORE ON}
         WriteLog('TBurningTool.WriteIso',Format('Load ISO file on stream [%s]',[aPathIso]),tpLivInfo);
      {TSI:IGNORE OFF}
      {$ENDREGION}
      if IsoLoader.SetPath(aPathIso) <> S_OK then
      begin
        {$REGION 'Log'}
        {TSI:IGNORE ON}
           WriteLog('TBurningTool.WriteIso',Format('Unable load ISO file [ %s ]',[aPathIso]),tpLivInfo);
        {TSI:IGNORE OFF}
        {$ENDREGION}
        Exit;
      end;

      if IsoLoader.DefaultInterface.Get_Stream(DiscStream) <> S_OK then
      begin
        {$REGION 'Log'}
        {TSI:IGNORE ON}
           WriteLog('TBurningTool.WriteIso',Format('Unable load stream of ISO file [ %s ]',[aPathIso]),tpLivInfo);
        {TSI:IGNORE OFF}
        {$ENDREGION}
        Exit;
      end;

      InternalWrite;
    Except
      On E: Exception do
      begin
        {$REGION 'Log'}
        {TSI:IGNORE ON}
           WriteLog('TBurningTool.WriteIso',Format('Exception message [ %s ]',[E.Message]),tplivException);
        {TSI:IGNORE OFF}
        {$ENDREGION}
        SetError;
      end;
    End;
  Finally
    DiscStream := nil;
    IsoLoader.Free;
    FWriting := False;
  End;
end;

Function TBurningTool.MngInsertDisk(aIdexDriver,aSupportType:Integer;var aDataWriter:TMsftDiscFormat2Data;const aLetterDrive:String;var aIRetry:Integer):Boolean;
var isSupportRW : Boolean;
    isEmpy      : Boolean;
    isDiskRW    : Boolean;
    ErrorMedia  : Boolean;
    DiskPresent : Boolean;
    sMsg        : String;
begin
  Result      := False;
  isSupportRW := False;
  ErrorMedia  := False;
  isEmpy      := False;
  isDiskRW    := False;
  DiskPresent := False;
  sMsg        := Format(Insert_disk,[aLetterDrive]);

  {Verifico se nell'unit� � presente almeno un disco altrimenti lo richiedo}
  if DiskIsPresentOnDrive(aIdexDriver,aDataWriter) then
  begin
    DiskPresent := True;
    {$REGION 'Log'}
    {TSI:IGNORE ON}
       WriteLog('TBurningTool.MngInsertDisk',Format('Found disk on drive',[]),tpLivInfo);
    {TSI:IGNORE OFF}
    {$ENDREGION}

    DoOnProgressBurnCustom(Disk_detected);

    {Verifico se nell'unita c'� un disco idoneo al supporto}
    if CheckMediaBySupport(aIdexDriver,aSupportType,isSupportRW,aDataWriter) then
    begin
      {$REGION 'Log'}
      {TSI:IGNORE ON}
         WriteLog('TBurningTool.MngInsertDisk',Format('Disk type is valid',[]),tpLivInfo);
      {TSI:IGNORE OFF}
      {$ENDREGION}
      DoOnProgressBurnCustom(Invalid_Disk);


      {Verifico se nell'unitca c'� un disco vuoto}
      
      isEmpy := isDiskEmpty(aDataWriter,aIdexDriver,ErrorMedia);

      if FAbort then Exit;

      if Not isEmpy then
      begin
        DoOnProgressBurnCustom(Disk_not_empty);
        sMsg := Format(Insert_empty_disk,[aLetterDrive]);

        {$REGION 'Log'}
        {TSI:IGNORE ON}
           WriteLog('TBurningTool.MngInsertDisk',Format('disk on drive letter [ %s ] is not empty ',[aLetterDrive]),tpLivInfo);
        {TSI:IGNORE OFF}
        {$ENDREGION}
        {verifico se nell'unit� c'� un dico rescrivibile}
        if isSupportRW then
          isDiskRW := isDiskWritable(aDataWriter,aIdexDriver,ErrorMedia);
      end
      else
        DoOnProgressBurnCustom(Disk_is_empty);
    end
    else
    begin
      sMsg := Format(Invalid_disk_for_driver,[aLetterDrive]);
      {$REGION 'Log'}
      {TSI:IGNORE ON}
         WriteLog('TBurningTool.MngInsertDisk',Format('support on drive is not usable with this type of ISO idTypeSypport [ %d ]',[aSupportType]),tpLivWarning);
      {TSI:IGNORE OFF}
      {$ENDREGION}
    end;
  end
  else
  begin
    DoOnProgressBurnCustom(Disk_request);
    {$REGION 'Log'}
    {TSI:IGNORE ON}
       WriteLog('TBurningTool.MngInsertDisk',Format('No disk on drive [ %s ]',[aLetterDrive]),tpLivInfo);
    {TSI:IGNORE OFF}
    {$ENDREGION}
  end;

  if FAbort then Exit;
  if Not DiskPresent and ( aIRetry < DEFAULT_MAX_RETRY )  then Exit;

  {Sono sicuro che ci sia un disco nell'unit� ora verifico se � vuoto}
  if ( Not isEmpy ) then
  begin
    {Disco riscrivibile AUTO ERASE o ERASE su richiesta configurabile da Regedit quindi per singolo OW }
    if ( not CanErase and not EraseCDAuto ) or
       ( not IsDriverRW(aIdexDriver,aSupportType) or ( not isDiskRW ) )
    then
    begin
      DriveEject(aIdexDriver);
      if MessageBox(0, Pchar(sMsg), PChar(Application.Title),
                       MB_ICONINFORMATION or MB_OK or MB_OKCANCEL or MB_TOPMOST ) in [idOk]
      then
      begin
        if not CloseTray(aIdexDriver) then Exit;
        aIRetry := 0;
      end
      else
        FAbort := True;
    end
    else
    begin
      if CanErase and not EraseCDAuto then
      begin
        {Cancellazione del disco con richiesta utente}
        if MessageBox(0, Pchar(Format(Erase_request,[aLetterDrive])),
                         PChar(Application.Title),
                         MB_ICONINFORMATION or MB_OK or MB_OKCANCEL or MB_TOPMOST ) in [idOk]
        then
          Result := EraseDisk(aIdexDriver,aSupportType,False)
        else
          FAbort := True;
      end
      else
        {AUTO Erase del disco in automatico senza richiesta}
        Result := EraseDisk(aIdexDriver,aSupportType,False);
    end;
  end
  else
  begin
    {$REGION 'Log'}
    {TSI:IGNORE ON}
       WriteLog('TBurningTool.MngInsertDisk',Format('disk on drive letter [ %s ] is empty ',[aLetterDrive]),tpLivInfo);
    {TSI:IGNORE OFF}
    {$ENDREGION}

    if isSupportRW then
    begin
      if CanErase then
        Result := True
      else
      begin
        DriveEject(aIdexDriver);
        {Dischi riscrivibili non ammessi}
        if MessageBox(0, Pchar(Format(Burn_Not_possible_rw,[aLetterDrive])),
                         PChar(Application.Title),
                       MB_ICONINFORMATION or MB_OK or MB_OKCANCEL or MB_TOPMOST ) in [idOk]
        then
        begin
          if not CloseTray(aIdexDriver) then Exit;
          aIRetry := 0;
        end
        else
          FAbort := True;
      end;
    end;
      Result := True;
  end;
end;

function TBurningTool.GetBitmapDriver( Const Drive: String): Integer;
var Info : TSHFileInfo;
    sDrive : string;
begin
  Result := -1;
  if not Assigned(FimgListSysSmall) then Exit;
  sDrive := Drive;
  if Pos(']',Drive) > 0 then
  begin
    sDrive := Trim( Copy( Drive,2,Pos(']',Drive) -1 ) );
    sDrive := StringReplace(sDrive,']','',[rfReplaceAll]);
  end;

  SHGetFileInfo(PChar(sDrive+'\'), 0, Info, SizeOf(TSHFileInfo), SHGFI_SYSICONINDEX or SHGFI_DISPLAYNAME);
  Result := Info.iIcon;
end;

function TBurningTool.GetCanBurnCD: Boolean;
begin
  Result := FListaDriveCD.Count > 0;
end;

function TBurningTool.GetCanBurnCD_DL: Boolean;
begin
  Result := FListaDriveCD_DL.Count > 0;
end;

function TBurningTool.GetCanBurnDBR: Boolean;
begin
  Result := FListaDriveBDR.Count > 0;
end;

function TBurningTool.GetCanBurnDVD_DL: Boolean;
begin
  Result := FListaDriveDVD_DL.Count > 0;
end;

function TBurningTool.GetCanBurnDVD: Boolean;
begin
  Result := FListaDriveDVD.Count > 0;
end;

function TBurningTool.GetSystemCanBurn: Boolean;
begin
  Result := CanBurnCD or CanBurnCD_DL or CanBurnDVD or CanBurnBDR or CanBurnDVD_DL;
end;

function TBurningTool.SecondToTime(const Seconds: Cardinal): Double;
var ms, ss, mm, hh, dd: Cardinal;
begin
  dd     := Seconds div SecsPerDay;
  hh     := (Seconds mod SecsPerDay) div SecsPerHour;
  mm     := ((Seconds mod SecsPerDay) mod SecsPerHour) div SecsPerMin;
  ss     := ((Seconds mod SecsPerDay) mod SecsPerHour) mod SecsPerMin;
  ms     := 0;
  Result := dd + EncodeTime(hh, mm, ss, ms);
end;

procedure TBurningTool.MsftEraseDataUpdate(ASender: TObject; const object_: IDispatch; elapsedSeconds: Integer; estimatedTotalSeconds: Integer);
var SInfo      : String;
    CurDiscF2D : IDiscFormat2Erase;
begin
  SInfo         := SInfo;
  CurDiscF2D    := object_ as  IDiscFormat2Erase;
  SInfo         := Format(Time_progress_Format,
                         [sLineBreak,TimeToStr(SecondToTime(elapsedSeconds)),sLineBreak,TimeToStr(SecondToTime(estimatedTotalSeconds))]);
  if Assigned(FOnProgressBurn) then
    FOnProgressBurn(self,SInfo,0,False,False,0,False);
  Application.ProcessMessages;
end;

procedure TBurningTool.MsftDiscFormat2DataUpdate(ASender: TObject;
  const object_, progress: IDispatch);
var CurProgress     : IDiscFormat2DataEventArgs;
    CurDiscF2D      : IDiscFormat2Data;
    Writtensectors  : int64;
    SInfo           : String;
    pPosition       : Int64;
    SetPosition     : Boolean;
    sTime           : String;
    AllowAbort      : Boolean;
begin
  CurProgress   := progress as IDiscFormat2DataEventArgs;
  CurDiscF2D    := object_ as IDiscFormat2Data;
  SetPosition   := False;
  pPosition     := 0;
  AllowAbort    := False;
  {$REGION 'Log'}
  {TSI:IGNORE ON}
     WriteLog('TBurningTool.MsftDiscFormat2DataUpdate',Format('CurProgress.CurrentAction [ %d ]',[CurProgress.CurrentAction]),tpLivInfo,True);
  {TSI:IGNORE OFF}
  {$ENDREGION}

  case CurProgress.CurrentAction of
    IMAPI_FORMAT2_DATA_WRITE_ACTION_VALIDATING_MEDIA      :
          SInfo := Disk_validation;

    IMAPI_FORMAT2_DATA_WRITE_ACTION_FORMATTING_MEDIA      :
          SInfo := Disk_formatting;

    IMAPI_FORMAT2_DATA_WRITE_ACTION_INITIALIZING_HARDWARE :
          SInfo := init_hw;

    IMAPI_FORMAT2_DATA_WRITE_ACTION_CALIBRATING_POWER     :
          SInfo := Laser_calibration;

    IMAPI_FORMAT2_DATA_WRITE_ACTION_WRITING_DATA          :
          begin
            SInfo            := Disk_writing;
            Writtensectors   := CurProgress.LastWrittenLba - CurProgress.StartLba;
            pPosition        := Round( (Writtensectors/CurProgress.SectorCount) *100 );
            SetPosition      := True;
            AllowAbort       := True;
          end;

    IMAPI_FORMAT2_DATA_WRITE_ACTION_FINALIZATION          :
          SInfo := Finalization_str;

    IMAPI_FORMAT2_DATA_WRITE_ACTION_COMPLETED             :
          begin
            SInfo    := Burn_completed;
            FWriting := False;
          end;

    IMAPI_FORMAT2_DATA_WRITE_ACTION_VERIFYING             :
          begin
            SInfo        := Verifying_disk;
            pPosition    :=  ( CurProgress.ElapsedTime * 100 ) div CurProgress.TotalTime ;
            SetPosition  := True;
          end;
  else
    {$REGION 'Log'}
    {TSI:IGNORE ON}
       WriteLog('TBurningTool.MsftDiscFormat2DataUpdate',Format('Unknow status[ %d ]',[CurProgress.CurrentAction]),tplivError);
    {TSI:IGNORE OFF}
    {$ENDREGION}
  end;

  if Assigned(FOnProgressBurn) then
  begin
    sTime           := Format(Time_progress,
                      [TimeToStr(SecondToTime(CurProgress.ElapsedTime)),sLineBreak,
                       TimeToStr(SecondToTime(CurProgress.TotalTime))]);

    sinfo := Format('%s%s%s',[sinfo,sLineBreak,stime]);
    FOnProgressBurn(self,SInfo,pPosition,SetPosition,False,CurProgress.CurrentAction,AllowAbort);
  end;

  if FAbort then
  begin
    CancelWriting;
    Application.ProcessMessages;
    if CurProgress.CurrentAction = IMAPI_FORMAT2_DATA_WRITE_ACTION_FINALIZATION then
      FWriting := False;
    SInfo := Burning_Aboring;
    if Assigned(FOnProgressBurn) then
      FOnProgressBurn(self,SInfo,pPosition,SetPosition,False,0,False);
  end;

  Application.ProcessMessages;
end;

end.
