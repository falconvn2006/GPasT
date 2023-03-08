unit EMSI.SysInfo.Threads;

interface

uses
  System.SysUtils,
  System.Classes,
  Winapi.Windows,
  System.Hash,
  EMSI.SysInfo.Base,
  EMSI.SysInfo.Consts,
  EMSI.UI.TreeNode,
  EMSI.SysInfo.Processes
  ;

type
  TEMSI_RecurringThread = class(TThread)
  private
    FInterval: Integer;
  protected
    procedure DoWork; virtual; abstract;
    procedure UpdateInterface; virtual; abstract;
    procedure Execute; override;
  public
    constructor Create(AInterval: Integer);
    property Interval : integer read FInterval write FInterval;
  end;

  TEMSI_ProcessesListThread = class(TEMSI_RecurringThread)
  private
    FInterfaceObject : TObject;
    FProcessList: TEMSI_WinProcessList;
  protected
    procedure DoWork; override;
    procedure UpdateInterface; override;

  public
    constructor Create(InterfaceObject:TObject;AInterval: Integer);
    procedure BeforeDestruction; override;
  end;

  TEMSI_HashingFileDoneEvent = procedure(FileNo,TotalCount:integer;
                                    FileName:string;
                                    HashResult:string) of object;

  TEMSI_HashingFilesThread = class(TThread)
  private
    FFilesList : TStringList;
    FOnStart,
    FOnEnd : TNotifyEvent;
    FOnHashingFileDone : TEMSI_HashingFileDoneEvent;
    function CalculateFileHash(const FileName: string): string;
  protected
    procedure Execute; override;

    // Syncroinze Procedures
    procedure DoStart; virtual;
    procedure DoHashingFileDone(FileNo,TotalCount:integer;
                                      FileName:string;
                                      HashResult:string); virtual;
    procedure DoEnd; virtual;


  public
    constructor Create;
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    procedure AddFile(FileName:string);

    property OnStart : TNotifyEvent read FOnStart Write FOnStart;
    property OnEnd : TNotifyEvent read FOnEnd Write FOnEnd;
    property OnHashingFileDone : TEMSI_HashingFileDoneEvent read FOnHashingFileDone Write FOnHashingFileDone;
  end;

implementation

uses Vcl.ComCtrls;

{ TEMSI_RecurringThread }

constructor TEMSI_RecurringThread.Create(AInterval: Integer);
begin
  inherited Create(True);
  FInterval := AInterval;
end;


procedure TEMSI_RecurringThread.Execute;
begin
  while not Terminated do
  begin
    DoWork;
    Synchronize(UpdateInterface);
    Sleep(FInterval);
  end;
end;



{ TEMSI_ProcessesListThread }

procedure TEMSI_ProcessesListThread.BeforeDestruction;
begin
  inherited;
  FProcessList.Free;
end;

constructor TEMSI_ProcessesListThread.Create(InterfaceObject: TObject;
  AInterval: Integer);
begin
  inherited Create(AInterval);
  FInterfaceObject := InterfaceObject;
  FProcessList:= TEMSI_WinProcessList.Create;

end;

procedure TEMSI_ProcessesListThread.DoWork;
begin
  FProcessList.FillList;
end;

procedure TEMSI_ProcessesListThread.UpdateInterface;
begin
    if FInterfaceObject is TTreeView then
      TEMSI_TreeProcedures.FillProcessesNodes(TTreeView(FInterfaceObject),FProcessList)


end;

{ TEMSI_HashingThread }

procedure TEMSI_HashingFilesThread.AddFile(FileName: string);
begin
  FFilesList.Add(FileName);
end;

procedure TEMSI_HashingFilesThread.AfterConstruction;
begin
  inherited;
  FFilesList := TStringList.Create;
  FFilesList.Duplicates := dupIgnore;
  FFilesList.Sorted := true;
end;

procedure TEMSI_HashingFilesThread.BeforeDestruction;
begin
  inherited;
  FFilesList.Free;
end;

function TEMSI_HashingFilesThread.CalculateFileHash(
  const FileName: string): string;
var
  FileStream: TFileStream;
begin
  Result := '';
  if not FileExists(FileName) then
    Exit;

  FileStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
  try
    try
      FileStream.Position := 0;
      Result := THashSHA2.GetHashString(FileStream);
    finally
    end;
  finally
    FileStream.Free;
  end;
end;

constructor TEMSI_HashingFilesThread.Create;
begin
  inherited Create(True);
end;

procedure TEMSI_HashingFilesThread.DoEnd;
begin
  if Assigned(FOnEnd) then
    FOnEnd(Self);
end;

procedure TEMSI_HashingFilesThread.DoHashingFileDone(FileNo,
  TotalCount: integer; FileName, HashResult: string);
begin
  if Assigned(FOnHashingFileDone) then
    FOnHashingFileDone(FileNo,TotalCount,FileName,HashResult);
end;

procedure TEMSI_HashingFilesThread.DoStart;
begin
  if Assigned(FOnStart) then
    FOnStart(Self);
end;

procedure TEMSI_HashingFilesThread.Execute;
var I : integer;
    Hash : string;
begin
  Synchronize(DoStart);
  for I := 0 to FFilesList.Count-1 do
  begin
    Hash := CalculateFileHash(FFilesList[I]);

    Synchronize(
      procedure
      begin
        DoHashingFileDone(I+1,FFilesList.Count,FFilesList[I],Hash)
      end);
    Sleep(100);// Add Some delay :)

    if Terminated then break;
  end;
  Synchronize(DoEnd);
end;


end.
