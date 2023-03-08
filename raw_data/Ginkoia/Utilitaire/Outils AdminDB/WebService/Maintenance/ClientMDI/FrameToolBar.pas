unit FrameToolBar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ActnList, ComCtrls, ToolWin;

type
  TToolBarFrame = class(TFrame)
    ToolBar: TToolBar;
    TlBrBtnNew: TToolButton;
    TlBrBtnUpdate: TToolButton;
    ToolButton3: TToolButton;
    TlBrBtnRefresh: TToolButton;
    ToolButton5: TToolButton;
    TlBrBtnExcel: TToolButton;
    ActLstToolBar: TActionList;
    ActInsert: TAction;
    ActUpdate: TAction;
    ActRefresh: TAction;
    ActExcel: TAction;
    TlBrBtnDelete: TToolButton;
    TlBrBtnTool: TToolButton;
    ActDelete: TAction;
    ActTool: TAction;
    TlBrBtnEmail: TToolButton;
    ActEmail: TAction;
    TlBrBtnNew2: TToolButton;
    ActInsert2: TAction;
    ActSync: TAction;
    TlBrBtnSyncBase: TToolButton;
    ToolButton2: TToolButton;
    ToolButton1: TToolButton;
    TlBrBtnTakeJeton: TToolButton;
    TlBrBtnLeaveJeton: TToolButton;
    ToolButton7: TToolButton;
    procedure ActDeleteExecute(Sender: TObject);
  private
    FConfirmDelete: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    property ConfirmDelete: Boolean read FConfirmDelete write FConfirmDelete;
  end;

implementation

uses uConst;

{$R *.dfm}

procedure TToolBarFrame.ActDeleteExecute(Sender: TObject);
begin
  if (FConfirmDelete) and (MessageDlg(cConfirmDelete, mtConfirmation, [mbYes, mbNo], 0) = mrNo) then
    Abort;
end;

constructor TToolBarFrame.Create(AOwner: TComponent);
begin
  inherited;
  FConfirmDelete:= False;
end;

end.
