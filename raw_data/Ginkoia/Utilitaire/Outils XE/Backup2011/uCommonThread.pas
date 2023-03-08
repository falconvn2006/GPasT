unit uCommonThread;

interface

uses Classes,Contnrs,Controls, Forms, RzPanel, SysUtils, StdCtrls, ComCtrls, uSevenZip, uCommon, IdComponent,AdvProgr;

type
  TCreateBoxMode = (cmCopy,cmZip, cmDel);

  TCMNThread = class(TThread)
  private
    FIPSOURCE : String;
    FSourceDir       : String;
    FSourceFile      : String;
    FDestinationDir  : String;
    FDestinationFile : String;
    FParentScrollbox : TScrollBox;
    FActionMode      : TModeAct;

    FCXGroupBox : TRzGroupBox;
    FLabelDe : TLabel;
    FLabelVers : TLabel;
    FProgressBar : TAdvProgress;

    FLogs : TStringList;
    FIsTerminated : Boolean;
    FVersionning : Boolean;
    FSplitZip : Boolean;

    FHTTPMAXSIZE : Int64;
    FLogonNetWork: Boolean;
    FLogonPassword: String;
    FLogonUser: String;
 public
    constructor Create(CreateSuspended: Boolean);
    destructor Destroy;override;

    procedure CreateLogBox(ATitle : String; AMode : TCreateBoxMode = cmCopy);
    procedure DestroyLogBox;
    procedure ZipFile;
    procedure HttpOnWorkBegin(ASender : TObject;AWorkMode : TWorkMode;AWorkCountMax : Int64);
    procedure HttpOnWork(ASender : TObject;AWorkMode : TWorkMode;AWorkCount : Int64);

  published
    property IpSource : String read FIPSOURCE write FIPSOURCE;
    property SourceDir       : String read FSourceDir       write FSourceDir;
    property SourceFile      : String read FSourceFile      write FSourceFile;
    property DestinationDir  : String read FDestinationDir  write FDestinationDir;
    property DestinationFile : String read FDestinationFile write FDestinationFile;
    property Versionning     : Boolean read FVersionning write FVersionning;
    property SplitZip        : Boolean read FSplitZip    write FSplitZip;

    property IsTerminated : Boolean read FIsTerminated write FIsTerminated;

    property ParentScrollBox : TScrollBox read FParentScrollbox write FParentScrollbox;
    property ProgressBar : TAdvProgress read FProgressBar write FProgressBar;
    property Logs : TStringList read FLogs;
    property ActionMode : TModeAct read FActionMode write FActionMode;

    property LogNetWork : Boolean read FLogonNetWork write FLogonNetWork;
    property LogUser    : String  read FLogonUser write FLogonUser;
    property LogPassword : String read FLogonPassword write FLogonPassword;
  end;

  TOLThread = Class(TObjectList)
    private
      procedure SetItem (Index : integer; Value : TCMNThread);
      function  GetItem (Index : Integer) : TCMNThread;
    public
      property Items[Index : Integer] : TCMNThread read GetItem Write SetItem; default;
  End;

var
  OT_ThreadList : TOLThread;

implementation

{ TTCPThread }

constructor TCMNThread.Create(CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);
  FreeOnTerminate := False;
  FIsTerminated := False;
  FLogs := TStringList.Create;
end;

procedure TCMNThread.CreateLogBox(ATitle : String;AMode : TCreateBoxMode);
var
  UniqueName : String;
  i : Integer;
begin
  FDestinationFile := FDestinationDir + Copy(FSourceFile,Length(IncludeTrailingPathDelimiter(FSourceDir)),Length(FSourceFile));

  UniqueName := '';
  for i := 1 to Length(IpSource) do
    if IpSource[i] in ['a'..'z','A'..'Z','0'..'9'] then
      UniqueName := UniqueName + IpSource[i];

  while FParentScrollbox.FindComponent('GB_' + UniqueName + FormatDateTime('YYYYMMDDhhmmsszzz',Now)) <> nil do
    Application.ProcessMessages;

  FCXGroupBox := TRzGroupBox.Create(FParentScrollbox);
  With FCXGroupBox do
  begin
    Parent  := FParentScrollbox;
    Top     := FParentScrollbox.Height;
    Align   := alTop;
    Caption := ATitle + ExtractFileName(FSourceFile);
    Name    := 'GB_' + UniqueName + FormatDateTime('YYYYMMDDhhmmsszzz',Now);
    Visible := True;
    GroupStyle := gsBanner;
    Transparent := False;
  end;

  FLabelDe := TLabel.Create(FCXGroupBox);
  With FLabelDe do
  begin
    Parent  := FCXGroupBox;
    Left    := 16;
    Top     := 32;
    case AMode of
      cmCopy: Caption := 'De ' + ExtractFilePath(FSourceFile);
      cmZip:  Caption := 'De ' + FDestinationFile;
      cmDel:  Caption := '';
    end;

    Visible := True;
    Name    := 'LBL_DE' + UniqueName + FormatDateTime('YYYYMMDDhhmmsszzz',Now);

  end;

  FLabelVers := TLabel.Create(FCXGroupBox);
  With FLabelVers do
  begin
    Parent  := FCXGroupBox;
    Left    := 16;
    Top     := 54;
    case AMode of
      cmCopy: Caption := 'Vers ' + ExtractFilePath(FDestinationFile);
      cmZip:  Caption := 'En ' + ChangeFileExt(FDestinationFile,'.7z');
      cmDel:  Caption := '';
    end;

    Visible := True;
    Name    := 'LBL_VERS' + UniqueName + FormatDateTime('YYYYMMDDhhmmsszzz',Now);
  end;

  FProgressBar := TAdvProgress.Create(FCXGroupBox);
  With FProgressBar do
  begin
    Parent  := FCXGroupBox;
    AlignWithMargins := True;
    Name             := 'PGB_' + UniqueName + FormatDateTime('YYYYMMDDhhmmsszzz',Now);
    Margins.Left     := 16;
    Margins.Right    := 16;
    Align            := alBottom;
    Smooth           := True;
    Visible          := True;
  end
end;

destructor TCMNThread.Destroy;
begin
  FLogs.Free;
  inherited;
end;

procedure TCMNThread.DestroyLogBox;
begin
  FCXGroupBox.Free;
end;


procedure TCMNThread.HttpOnWork(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Int64);
begin
  FProgressBar.Position := AWorkCount * 100 Div FHTTPMAXSIZE;
end;

procedure TCMNThread.HttpOnWorkBegin(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCountMax: Int64);
begin
  FHTTPMAXSIZE := AWorkCountMax;
end;

function ProgressCallback(sender: Pointer; total: boolean; value: int64): HRESULT; stdcall;
begin
  if total then
    TProgressBar(sender).Max := (value Div 1024 Div 1024)
  else
    TProgressBar(sender).Position := (value Div 1024 Div 1024);
  Result := S_OK;
end;

procedure TCMNThread.ZipFile;
var
  Arch : I7zOutArchive;
begin
  try
    if FSplitZip then
    begin
      Arch := CreateOutArchive(CLSID_CFormat7z);
//      SevenZipSetSolidSettings(Arch, True);
//      SevenZipVolumeMode(Arch,True);
      Arch.AddFile(FDestinationFile,ExtractFileName(FDestinationFile));
//      SetCompressionLevel(Arch,5);
      Arch.SetProgressCallback(FProgressbar,ProgressCallback);
      if FVersionning then
        Arch.SaveToFile(ExtractFilePath(FDestinationFile) + FormatDateTime('YYYYMMDDhhmmsszzz-',Now) + ExtractFileName(ChangeFileExt(FDestinationFile,'.7z')))
      else
        Arch.SaveToFile(ChangeFileExt(FDestinationFile,'.7z'));
    end
    else begin
      Arch := CreateOutArchive(CLSID_CFormat7z);

    Arch.AddFile(FDestinationFile,ExtractFileName(FDestinationFile));
    SetCompressionLevel(Arch,5);
    Arch.SetProgressCallback(FProgressbar,ProgressCallback);
    if FVersionning then
      Arch.SaveToFile(ExtractFilePath(FDestinationFile) + FormatDateTime('YYYYMMDDhhmmsszzz-',Now) + ExtractFileName(ChangeFileExt(FDestinationFile,'.7z')))
    else
      Arch.SaveToFile(ChangeFileExt(FDestinationFile,'.7z'));
    end;

    // si il n'y a pas eu d'erreur on supprime la source du zip
    DeleteFile(FDestinationFile);
  Except on E:Exception do
    FLogs.Add('ZipFile -> ' + E.Message);
  end;
end;

{ TOLThread }

function TOLThread.GetItem(Index: Integer): TCMNThread;
begin
  Result := TCMNThread(inherited GetItem(Index));
end;

procedure TOLThread.SetItem(Index: integer; Value: TCMNThread);
begin
  inherited SetItem(Index,Value);
end;

end.
