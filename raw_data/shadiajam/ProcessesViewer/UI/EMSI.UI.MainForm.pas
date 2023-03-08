unit EMSI.UI.MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ComCtrls,EMSI.UI.TreeNode, Vcl.ExtCtrls,
  EMSI.SysInfo.Threads, Vcl.Menus, EMSI.UI.ProcessFrame,
  EMSI.SysInfo.Processes,
  EMSI.WMI.Sessions, EMSI.UI.SessionFrame
  ;

type


  TfrmMain = class(TForm)
    pnlMain: TPanel;
    pnlLeft: TPanel;
    tvMain: TTreeView;
    Splitter1: TSplitter;
    MainMenu: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    Options1: TMenuItem;
    Updatespeed1: TMenuItem;
    mnu05Sec: TMenuItem;
    mnu1Sec: TMenuItem;
    mnu2Sec: TMenuItem;
    mnu5Sec: TMenuItem;
    mnu10Sec: TMenuItem;
    heme1: TMenuItem;
    Update1: TMenuItem;
    PageControl: TPageControl;
    TabProcess: TTabSheet;
    TabBaseProcess: TTabSheet;
    FrameProcess: TFrameProcess;
    TabSession: TTabSheet;
    FrameSession: TfrmSessionInfo;
    Panel1: TPanel;
    Panel2: TPanel;
    memHashes: TMemo;
    btnHashStartStop: TButton;
    ProgressHash: TProgressBar;
    procedure tvMainCreateNodeClass(Sender: TCustomTreeView;
      var NodeClass: TTreeNodeClass);
    procedure mnu10SecClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure tvMainCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure tvMainHint(Sender: TObject; const Node: TTreeNode;
      var Hint: string);
    procedure tvMainChange(Sender: TObject; Node: TTreeNode);
    procedure btnHashStartStopClick(Sender: TObject);
  private
    { Private declarations }
    FProcessesThread : TEMSI_ProcessesListThread;
    FSessions : TEMSI_WMISessionList;
    FHashingStarted : boolean;
    FHashingThread : TEMSI_HashingFilesThread;
    procedure SetRefreshInterval(Interval:integer);

    procedure ShowProccessInformation(WinProc : TEMSI_WinProcess);
    procedure ShowSessionInformation(WMISession : TEMSI_WMISession);
    procedure ShowBaseProcessesInformation;
    procedure FillSessions;

    procedure OnStartHashThread(Sender:TObject);
    procedure OnStopHashThread(Sender:TObject);
    procedure OnHashingFileDone(FileNo,TotalCount:integer;
                                      FileName:string;
                                      HashResult:string);

    procedure StartHashingFiles;
    procedure StopHashingFiles;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;

  end;


var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.AfterConstruction;
begin
  inherited;
  TEMSI_TreeProcedures.FillBaseNodes(tvMain);
  FProcessesThread := TEMSI_ProcessesListThread.Create(tvMain,2000);
  FProcessesThread.Start;
  FSessions := TEMSI_WMISessionList.Create();

  FillSessions;
end;

procedure TfrmMain.BeforeDestruction;
begin
  inherited;
  FProcessesThread.Free;
  FSessions.Free;
end;

procedure TfrmMain.btnHashStartStopClick(Sender: TObject);
begin
  btnHashStartStop.Enabled := false;
  if FHashingStarted then
    StopHashingFiles else
    StartHashingFiles;
end;

procedure TfrmMain.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.FillSessions;
begin
  FSessions.FillList;
  TEMSI_TreeProcedures.FillSessionsNodes(tvMain,FSessions);
end;

procedure TfrmMain.mnu10SecClick(Sender: TObject);
begin
  SetRefreshInterval(TMenuItem(Sender).Tag);
end;


procedure TfrmMain.OnHashingFileDone(FileNo, TotalCount: integer; FileName,
  HashResult: string);
begin
  ProgressHash.Visible := True;
  ProgressHash.Min := 0;
  ProgressHash.Max := TotalCount;
  ProgressHash.Position := FileNo;

  memHashes.Lines.Add(format('%d. File: %s',[FileNo,FileName]));
  memHashes.Lines.Add(HashResult);
  memHashes.Lines.Add('');

  if FileNo = TotalCount then
    memHashes.Lines.Add('--- All Files Hashed');
end;

procedure TfrmMain.OnStartHashThread(Sender: TObject);
begin
  FHashingStarted := true;
  ProgressHash.Visible := True;
  ProgressHash.Min := 0;
  memHashes.Clear;
  memHashes.Lines.Add('--- Start Hashing');
  memHashes.Lines.Add('');
  memHashes.Lines.Add('');
  btnHashStartStop.Enabled := True;
  btnHashStartStop.Caption := 'Cancel Hashing';
end;

procedure TfrmMain.OnStopHashThread(Sender: TObject);
begin
  btnHashStartStop.Enabled := True;
  FHashingStarted := False;
  ProgressHash.Visible := False;
  ProgressHash.Min := 0;
  memHashes.Lines.Add('--- Hashing end');
  btnHashStartStop.Caption := 'Hash All Proccess';
  FHashingThread := nil;
end;

procedure TfrmMain.SetRefreshInterval(Interval: integer);
begin
  FProcessesThread.Interval := Interval;
end;

procedure TfrmMain.ShowBaseProcessesInformation;
begin
  TabProcess.TabVisible := False;
  TabBaseProcess.TabVisible := True;
  TabSession.TabVisible := False;
  PageControl.ActivePage := TabBaseProcess;
end;

procedure TfrmMain.ShowProccessInformation(WinProc: TEMSI_WinProcess);
begin
  TabProcess.TabVisible := True;
  TabBaseProcess.TabVisible := False;
  TabSession.TabVisible := False;
  TabProcess.Caption := WinProc.ExeFile+': '+WinProc.ProcessID.ToString;
  FrameProcess.FillFromWinProc(WinProc);
  PageControl.ActivePage := TabProcess;
end;

procedure TfrmMain.ShowSessionInformation(WMISession: TEMSI_WMISession);
begin
  TabProcess.TabVisible := False;
  TabBaseProcess.TabVisible := False;
  TabSession.TabVisible := True;
  TabSession.Caption := WMISession.User+': '+WMISession.LogonId;
  FrameSession.FillFromSession(WMISession);

  PageControl.ActivePage := TabSession;
end;

procedure TfrmMain.StartHashingFiles;
var
    i : integer;
    node : TEMSI_TreeNode;
begin
  FHashingThread := TEMSI_HashingFilesThread.Create;
  FHashingThread.OnStart := OnStartHashThread;
  FHashingThread.OnEnd := OnStopHashThread;
  FHashingThread.OnHashingFileDone := OnHashingFileDone;
  for I := 0 to tvMain.Items.Count-1 do
  begin
    node := TEMSI_TreeNode(tvMain.Items[I]);
    if (node.NodeType = ntProcess) and (node.ProcessObj.ProcessID > 0) and (node.ProcessObj.SessionID > 0) then
      FHashingThread.AddFile(node.ProcessObj.FullPath);
  end;
  FHashingThread.Start;
end;

procedure TfrmMain.StopHashingFiles;
begin
  if Assigned(FHashingThread) then
    FHashingThread.Terminate;
end;

procedure TfrmMain.tvMainChange(Sender: TObject; Node: TTreeNode);
var ANode : TEMSI_TreeNode;
begin
  if Node = nil then exit;
  ANode := TEMSI_TreeNode(Node);
  case ANode.NodeType of
    ntBaseSessions: ;
    ntBaseProcesses: ShowBaseProcessesInformation;
    ntSession: ShowSessionInformation(ANode.SessionObj);
    ntProcess: ShowProccessInformation(ANode.ProcessObj);
  end;
end;

procedure TfrmMain.tvMainCreateNodeClass(Sender: TCustomTreeView;
  var NodeClass: TTreeNodeClass);
begin
  NodeClass := TEMSI_TreeNode;
end;

procedure TfrmMain.tvMainCustomDrawItem(Sender: TCustomTreeView;
  Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if node = nil then exit;
  if TEMSI_TreeNode(Node).BackColor <> clDefault then
    tvMain.Canvas.Brush.Color := TEMSI_TreeNode(Node).BackColor;
end;

procedure TfrmMain.tvMainHint(Sender: TObject; const Node: TTreeNode;
  var Hint: string);
begin
  if node = nil then exit;
  Hint := TEMSI_TreeNode(Node).NodeHint;
end;

end.
