unit Main_DM;

interface

uses
  SysUtils, Classes, DB, DBClient, uCommon, ImgList, Controls, cxGraphics, MidasLib;

type
  TDM_BckMain = class(TDataModule)
    cds_ListDirectory: TClientDataSet;
    cds_ListExtensionFile: TClientDataSet;
    cds_ListDirectoryMainDirectory: TStringField;
    cds_ListDirectoryDestDirectory: TStringField;
    cds_ListExtensionFileIdx: TIntegerField;
    cds_ListExtensionFileExtName: TStringField;
    cds_ListExtensionFileSourceDelete: TBooleanField;
    cds_ListExtensionFileDestZip: TBooleanField;
    Ds_ListDirectory: TDataSource;
    Ds_ListExtensionFile: TDataSource;
    cxImg_Cmn: TcxImageList;
    cds_ListExtensionFileSplitZip: TBooleanField;
    cds_ListExtensionFileVersionning: TBooleanField;
    cds_ListDirectoryTypeTransfert: TIntegerField;
    cds_ListDirectoryTypeNom: TStringField;
    cds_ListExtensionFileID_LEF: TIntegerField;
    cds_ListDirectoryIdx: TAutoIncField;
    cds_FileList: TClientDataSet;
    cds_FileListSourceIP: TStringField;
    cds_FileListSourceDirectory: TStringField;
    cds_FileListSourceFile: TStringField;
    cds_FileListDestinationPath: TStringField;
    cds_FileListSourceDelete: TBooleanField;
    cds_FileListDestinationZip: TBooleanField;
    cds_FileListDestinationSplit: TBooleanField;
    cds_FileListDestinationVersionning: TBooleanField;
    cds_FileListCopyDone: TBooleanField;
    cds_FileListZipDone: TBooleanField;
    cds_FileListSourceFileDate: TDateTimeField;
    Ds_FileList: TDataSource;
    cds_FileListTypeTransfert: TIntegerField;
    cds_FileListDelDone: TBooleanField;
    cds_ListDirectoryLogonUser: TStringField;
    cds_ListDirectoryLogonPassword: TStringField;
    cds_ListDirectoryLogonActive: TBooleanField;
    cds_FileListLogonActive: TBooleanField;
    cds_FileListLogonUser: TStringField;
    cds_FileListLogonPassword: TStringField;
    cds_ExcludeList: TClientDataSet;
    cds_ExcludeListFileName: TStringField;
    Ds_ExcludeList: TDataSource;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    Procedure LoadConfig;
    Procedure SaveConfig;

    procedure AddToFileList(ASourceIP, ASourceDirectory, ASourceFile, ADestinationPath : String;
                            ASourceDelete, ADestinationZip, ADestinationSplit, ADestinationVersionning : Boolean;
                            ATypeTransfert : Integer;ALogActive : Boolean = False;AlogUser : String = '';ALogPassword : String = '');

  end;

var
  DM_BckMain: TDM_BckMain;

implementation

{$R *.dfm}

{ TDM_BckMain }

procedure TDM_BckMain.AddToFileList(ASourceIP, ASourceDirectory, ASourceFile,
  ADestinationPath: String; ASourceDelete, ADestinationZip, ADestinationSplit,
  ADestinationVersionning: Boolean; ATypeTransfert: Integer;ALogActive : Boolean;AlogUser, ALogPassword : String);
begin
  Try
    With cds_FileList do
    begin
      Append;
      FieldByName('SourceIP').AsString := ASourceIP;
      FieldByName('SourceDirectory').AsString := ASourceDirectory;
      FieldByName('SourceFile').AsString := ASourceFile;
      FieldByName('DestinationPath').AsString := ADestinationPath;
      FieldByName('SourceDelete').AsBoolean := ASourceDelete;
      FieldByName('DestinationZip').AsBoolean := ADestinationZip;
      FieldByName('DestinationSplit').AsBoolean := ADestinationSplit;
      FieldByName('DestinationVersionning').AsBoolean := ADestinationVersionning;
      FieldByName('CopyDone').AsBoolean := False;
      FieldByName('Zipdone').AsBoolean := False;
      FieldByName('TypeTransfert').AsInteger := ATypeTransfert;
      FieldByName('LogonActive').AsBoolean := ALogActive;
      FieldByName('LogonUser').AsString := AlogUser;
      FieldByName('LogonPassword').AsString := ALogPassword;
      Post;
    end;

  Except on E:Exception do
    raise Exception.Create('AddToFileList -> ' + E.Message);
  End;
end;

procedure TDM_BckMain.LoadConfig;
begin
  if FileExists(GAPPCFGPATH + 'CFGDir.cfg') then
    cds_ListDirectory.LoadFromFile(GAPPCFGPATH + 'CFGDir.cfg');

  if FileExists(GAPPCFGPATH + 'CfgExt.Cfg') then
    cds_ListExtensionFile.LoadFromFile(GAPPCFGPATH + 'CfgExt.Cfg');

  if FileExists(GAPPCFGPATH + 'CfgExc.Cfg') then
    cds_ExcludeList.LoadFromFile(GAPPCFGPATH + 'CfgExc.Cfg');

end;

procedure TDM_BckMain.SaveConfig;
begin
  cds_ListDirectory.SaveToFile(GAPPCFGPATH + 'CFGDir.cfg',dfXML);
  cds_ListExtensionFile.SaveToFile(GAPPCFGPATH + 'CfgExt.Cfg',dfXML);
  cds_ExcludeList.SaveToFile(GAPPCFGPATH + 'CfgExc.Cfg',dfXML);
end;

end.
