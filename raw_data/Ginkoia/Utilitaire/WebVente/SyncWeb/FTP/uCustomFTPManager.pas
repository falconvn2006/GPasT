unit uCustomFTPManager;

interface

uses
  SysUtils, uFTPFiles, uGestionBDD, uFTPUtils, uMonitoring, uFTPCtrl;

type
  TFileType = (ftSend, ftGet);

  TKnowFile = record
    fileName: string;
    fileType: TFileType;
    fileUniqueField: string;
    fileExcludeExportFields: string;
    fileClass: TCustomFTPFileClass;
  end;

  TCustomFTPManager = class
  private
    class var FKnowFiles: array of TKnowFile;

    function getKnowFile(AFileName: string): TKnowFile;
  protected
    FConnection: TMyConnection;
    FTransaction: TMyTransaction;
    FMonitoringAppType: TMonitoringAppType;
    FModuleName: String;
    FPRM_TYPE: String;
    FOnMonitoringEvent: TAddMonitoringEvent;
    FBypassGestionK: Boolean;
    FWriteHeaderToCSV: Boolean;
    FExtension: String;
    FIsOneShotCycleTime: Boolean;
  public
    class function RegisterKnownFile(AFileName: string; AFileType: TFileType;
      AFileUniqueField: string; AFileExcludeExportFields: string;
      AFileClass: TCustomFTPFileClass): boolean;

    class function KnownFile(AFileName: string): integer;

    ///<summary> ATransaction : Utilisé pour les opérations sur K </summary>
    constructor Create(Const AConnection: TMyConnection;
                       Const ATransaction: TMyTransaction;
                       Const AMonitoringAppType: TMonitoringAppType;
                       Const AModuleName: String; Const APRM_TYPE: String;
                       Const AOnMonitoring: TAddMonitoringEvent;
                       Const ABypassGestionK: Boolean;
                       Const AWriteHeaderToCSV: Boolean;
                       Const AExtension: String;
                       Const AIsOneShotCycleTime: Boolean); overload; virtual;

    function getSendFile(AFileName: string): TCustomFTPSendFile;
    function getGetFile(AFileName: string): TCustomFTPGetFile;

    function FTPIsBusy(Const ANameSite: String): Boolean;
    procedure FTPFinish(Const ANameSite: String);

    property OnMonitoring: TAddMonitoringEvent read FOnMonitoringEvent write FOnMonitoringEvent;
    property BypassGestionK : Boolean read FBypassGestionK write FBypassGestionK;
    property Transaction: TMyTransaction read FTransaction;
  end;

var
  GFTPCtrl: TFTPCtrl;

implementation

{ TCustomFTPManager }

function TCustomFTPManager.getSendFile(
  AFileName: string): TCustomFTPSendFile;
var
  vftpfile: TKnowFile;
begin
  Result := Nil;
  if KnownFile(AFileName) <> -1 then
  begin
    vftpfile := getKnowFile(AFileName);
    Result := TCustomFTPSendFileClass(vftpfile.fileClass).Create(FConnection,
      vftpfile.fileName, FMonitoringAppType, vftpfile.fileUniqueField,
      vftpfile.fileExcludeExportFields, FBypassGestionK, FWriteHeaderToCSV, FExtension);
  end;
end;

constructor TCustomFTPManager.Create(Const AConnection: TMyConnection;
  Const ATransaction: TMyTransaction;
  Const AMonitoringAppType: TMonitoringAppType;
  Const AModuleName: String; Const APRM_TYPE: String;
  Const AOnMonitoring: TAddMonitoringEvent;
  Const ABypassGestionK: Boolean;
  Const AWriteHeaderToCSV: Boolean;
  Const AExtension: String;
  Const AIsOneShotCycleTime: Boolean);
begin
  FConnection := AConnection;
  FTransaction := ATransaction;
  FMonitoringAppType:= AMonitoringAppType;
  FModuleName:= UpperCase(AModuleName);
  FPRM_TYPE:= APRM_TYPE;
  FOnMonitoringEvent:= AOnMonitoring;
  FBypassGestionK:= ABypassGestionK;
  FWriteHeaderToCSV:= AWriteHeaderToCSV;
  FExtension:= AExtension;
  FIsOneShotCycleTime:= AIsOneShotCycleTime;
end;

procedure TCustomFTPManager.FTPFinish(const ANameSite: String);
begin
  if GFTPCtrl <> nil then
    GFTPCtrl.Finish(ANameSite);
end;

function TCustomFTPManager.FTPIsBusy(const ANameSite: String): Boolean;
begin
  Result:= False;

  if GFTPCtrl <> nil then
    begin
      Result:= GFTPCtrl.IsBusy;

      if not Result then
        GFTPCtrl.Start(ANameSite);
    end;
end;

function TCustomFTPManager.getGetFile(AFileName: string): TCustomFTPGetFile;
var
  vftpfile: TKnowFile;
begin
  Result := Nil;
  if KnownFile(AFileName) <> -1 then
  begin
    vftpfile := getKnowFile(AFileName);
    Result := TCustomFTPGetFileClass(vftpfile.fileClass).Create(FConnection, AFileName, FMonitoringAppType);
  end;
end;

function TCustomFTPManager.getKnowFile(AFileName: string): TKnowFile;
var
  index: integer;
begin
  index := KnownFile(AFileName);
  if index <> -1 then
    Result := FKnowFiles[index];
end;

class function TCustomFTPManager.KnownFile(AFileName: string): integer;
var
  i: integer;
begin
  Result := -1;
  for i := 0 to length(FKnowFiles) - 1 do
  begin
    if (FKnowFiles[i].fileName = AFileName)
      or (Pos(FKnowFiles[i].fileName, AFileName) <> 0) then
    begin
      Result := i;
      Break;
    end;
  end;
end;

class function TCustomFTPManager.RegisterKnownFile(AFileName: string;
  AFileType: TFileType; AFileUniqueField, AFileExcludeExportFields: string;
  AFileClass: TCustomFTPFileClass): boolean;
var
  index: integer;
  vftpfile: TKnowFile;
begin
  if KnownFile(AFileName) = -1 then
  begin
    vftpfile.fileName := AFileName;
    vftpfile.fileType := AFileType;
    vftpfile.fileUniqueField := AFileUniqueField;
    vftpfile.fileExcludeExportFields := AFileExcludeExportFields;
    vftpfile.fileClass := AFileClass;

    index := Length(FKnowFiles);
    SetLength(FKnowFiles, index + 1);
    FKnowFiles[index] := vftpfile;
  end;
end;

end.


