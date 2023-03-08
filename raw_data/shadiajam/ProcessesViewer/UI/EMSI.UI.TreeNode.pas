unit EMSI.UI.TreeNode;

interface

uses
  Winapi.Windows,  System.SysUtils, System.Classes, Vcl.ComCtrls,
  Vcl.Graphics,
  EMSI.SysInfo.Processes,
  EMSI.SysInfo.Consts,
  EMSI.SysInfo.Base,
  EMSI.WMI.Sessions
  ;

type
  TNodeType = (ntBaseSessions,ntBaseProcesses,ntSession,ntProcess);

  TEMSI_TreeNode = class(TTreeNode)
  private
    FNodeType: TNodeType;
    FProcessObj:TEMSI_WinProcess;
    FSessionObj:TEMSI_WMISession;

  public
    BackColor : TColor;
    NodeHint : String;
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;

    property NodeType : TNodeType read FNodeType;
    property ProcessObj:TEMSI_WinProcess read FProcessObj;
    property SessionObj:TEMSI_WMISession read FSessionObj;
  end;

  TEMSI_TreeProcedures = class
  private
    class function FindNodeByProcessObj(ParentNode:TTreeNode;ProcessObj:TEMSI_WinProcess) :TEMSI_TreeNode;
  public
    class procedure FillProcessesNodes(TreeView:TTreeView;WPList: TEMSI_WinProcessList);
    class procedure FillSessionsNodes(TreeView:TTreeView;SessionsList: TEMSI_WMISessionList);
    class procedure FillBaseNodes(TreeView:TTreeView);
  end;

implementation

{ TEMSI_TreeNode }

procedure TEMSI_TreeNode.AfterConstruction;
begin
  inherited;
  FProcessObj := nil;
  BackColor := clDefault;

end;

procedure TEMSI_TreeNode.BeforeDestruction;
begin
  inherited;
end;


{ TEMSI_TreeProcedures }

class procedure TEMSI_TreeProcedures.FillBaseNodes(TreeView: TTreeView);
var I : integer; 
    TreeNode : TEMSI_TreeNode;
begin
  for I := 0 to TreeView.Items.Count-1 do
    if TEMSI_TreeNode( TreeView.Items[I]).FNodeType = ntBaseSessions then exit;

  TreeNode := TEMSI_TreeNode(TreeView.Items.AddChild(nil,'Processes'));
  TreeNode.FNodeType := ntBaseProcesses;
  TreeNode := TEMSI_TreeNode(TreeView.Items.AddChild(nil,'Sessions'));
  TreeNode.FNodeType := ntBaseSessions;
end;

class procedure TEMSI_TreeProcedures.FillProcessesNodes(TreeView: TTreeView;
   WPList: TEMSI_WinProcessList);
var IsFirstFill: boolean;
  procedure FillItems(SubParentNode:TTreeNode;InnerProcessList:TEMSI_WinProcessList;IsRootNode:boolean);
  var I : integer;
      ANode:TTreeNode;
      NodeText,NodeHint : string;
      NodeColor : TColor;
      WinProc : TEMSI_WinProcess;
  begin
    for I := 0 to InnerProcessList.Count-1 do
    begin
      WinProc := InnerProcessList[I];
      if (WinProc.RootNode xor IsRootNode) then continue;
      ANode := nil;
      NodeHint := '';
      NodeColor := clDefault;
      NodeText := format('PID: %d, %s',[WinProc.ProcessID,WinProc.ExeFile]);

      if WinProc.FullPath<>'' then
        NodeHint := format('PID: %d, %s',[WinProc.ProcessID,WinProc.FullPath]);

      if (WinProc.ChangeStatus = ocsNewObject)and(not IsFirstFill) then
      begin
        NodeText := NodeText + ' (NEW)' ;
        NodeColor := $006ABB66;
      end else
      if (WinProc.ChangeStatus = ocsDeleting) then
      begin
        NodeText := NodeText + ' (CLOSED)';
        NodeColor := $003643F4;

      end;

      if (WinProc.ChangeStatus = ocsNewObject) then
      begin
        ANode := TreeView.Items.AddChild(SubParentNode,NodeText);
        TEMSI_TreeNode(ANode).FNodeType := ntProcess;
        TEMSI_TreeNode(ANode).FProcessObj := WinProc;
        WinProc.RelatedObject := ANode;
        if not IsFirstFill then
          SubParentNode.Expand(false);
      end else
        ANode := TTreeNode(WinProc.RelatedObject);

      if Assigned(ANode) then
      begin
        ANode.Text := NodeText;
        TEMSI_TreeNode(ANode).BackColor := NodeColor;
        TEMSI_TreeNode(ANode).NodeHint := NodeHint.Trim;
        FillItems(ANode, WinProc.SubProcesses,false);
      end;
    end;
  end;

  procedure DeleteKilledProcesses;
  var
      I: Integer;
      ANode : TEMSI_TreeNode;
  begin
    for I := TreeView.Items.Count-1 downto 0 do
    begin
      ANode := TEMSI_TreeNode(TreeView.Items[I]);
      if (ANode.NodeType = ntProcess)and(ANode.FProcessObj.ChangeStatus = ocsDeleted) then
      begin
        ANode.FProcessObj.RelatedObject := nil;
        TreeView.Items.Delete(ANode);

      end;

    end;
  end;
var BaseProcessesNode : TEMSI_TreeNode;
    i : integer;
begin
  BaseProcessesNode := nil;
  for I := 0 to TreeView.Items.Count-1 do
    if TEMSI_TreeNode(TreeView.Items.Item[I]).FNodeType = ntBaseProcesses then
    begin
      BaseProcessesNode := TEMSI_TreeNode(TreeView.Items.Item[I]);
      break;
    end;
  if BaseProcessesNode = nil then exit;
  IsFirstFill := BaseProcessesNode.Count = 0;
  try
    TreeView.Items.BeginUpdate;
    FillItems(BaseProcessesNode,WPList,True);
    if IsFirstFill then
      BaseProcessesNode.Expand(false);
    DeleteKilledProcesses;
  finally
    TreeView.Items.EndUpdate;
  end;
end;

class procedure TEMSI_TreeProcedures.FillSessionsNodes(TreeView: TTreeView;
  SessionsList: TEMSI_WMISessionList);
var IsFirstFill: boolean;
var BaseSessionsNode : TEMSI_TreeNode;

  procedure FillItems;
  var I : integer;
      ANode:TTreeNode;
      NodeText,NodeHint : string;
      NodeColor : TColor;
      WMISession : TEMSI_WMISession;
  begin
    for I := 0 to SessionsList.Count-1 do
    begin
      WMISession := SessionsList[I];
      ANode := nil;
      NodeHint := '';
      NodeColor := clDefault;
      NodeText := format('LogonId: %s, User: %s.%s',[WMISession.LogonId,WMISession.Domain,WMISession.User]);
      NodeHint := NodeText  + ' / LogonType: '+WMISession.LogonTypeStr;


      ANode := TreeView.Items.AddChild(BaseSessionsNode,NodeText);
      TEMSI_TreeNode(ANode).FNodeType := ntSession;
      TEMSI_TreeNode(ANode).FSessionObj := WMISession;
      TEMSI_TreeNode(ANode).NodeHint := NodeHint;
      TEMSI_TreeNode(ANode).BackColor := NodeColor;
    end;
  end;

var    i : integer;
begin
  BaseSessionsNode := nil;
  for I := 0 to TreeView.Items.Count-1 do
    if TEMSI_TreeNode(TreeView.Items.Item[I]).FNodeType = ntBaseSessions then
    begin
      BaseSessionsNode := TEMSI_TreeNode(TreeView.Items.Item[I]);
      break;
    end;
  if BaseSessionsNode = nil then exit;
  IsFirstFill := BaseSessionsNode.Count = 0;
  try
    TreeView.Items.BeginUpdate;
    FillItems;
    if IsFirstFill then
      BaseSessionsNode.Expand(false);
  finally
    TreeView.Items.EndUpdate;
  end;
end;

class function TEMSI_TreeProcedures.FindNodeByProcessObj(
  ParentNode: TTreeNode; ProcessObj: TEMSI_WinProcess): TEMSI_TreeNode;
var i : integer;
begin
  Result := nil;
  if ParentNode =nil then exit;

  for I := 0 to ParentNode.Count-1 do
  begin
    if (TEMSI_TreeNode(ParentNode.Item[I]).FProcessObj = ProcessObj) then
      exit(TEMSI_TreeNode(ParentNode.Item[I]));
  end;
end;

end.
