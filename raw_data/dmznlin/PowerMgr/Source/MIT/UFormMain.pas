unit UFormMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, Vcl.Forms, Vcl.Menus,
  System.Classes, UDataModule, dxBarBuiltInMenu, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, cxContainer, cxEdit,
  Vcl.ComCtrls, dxBarExtItems, dxBar, cxClasses, dxStatusBar, cxListView,
  cxTreeView, cxGroupBox, cxSplitter, cxPC, Vcl.Controls;

type
  TfFormMain = class(TForm)
    wPage1: TcxPageControl;
    SheetSrv: TcxTabSheet;
    SheetPoint: TcxTabSheet;
    SBar1: TdxStatusBar;
    cxSplitter1: TcxSplitter;
    BarMgr1: TdxBarManager;
    BarMgr1Bar1: TdxBar;
    dxBarSubItem1: TdxBarSubItem;
    BtnOpen: TdxBarButton;
    BtnSave: TdxBarButton;
    BarS1: TdxBarSeparator;
    BtnConn: TdxBarButton;
    dxBarButton4: TdxBarButton;
    BtnExit: TdxBarButton;
    BarMgr1Bar2: TdxBar;
    BStatic1: TdxBarStatic;
    dxBarSubItem2: TdxBarSubItem;
    BtnAboutMe: TdxBarButton;
    BtnAboutPwd: TdxBarButton;
    BtnAddGroup: TdxBarButton;
    BtnDelGroup: TdxBarButton;
    BtnDelPoint: TdxBarButton;
    GroupPath: TcxGroupBox;
    TreePath: TcxTreeView;
    GroupPoint: TcxGroupBox;
    ListItems: TcxListView;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnExitClick(Sender: TObject);
    procedure BtnDelPointClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fFormMain: TfFormMain;

implementation

{$R *.dfm}
uses ULibFun, UStyleModule;

procedure TfFormMain.FormCreate(Sender: TObject);
begin
  TApplicationHelper.LoadFormConfig(Self);
end;

procedure TfFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not FSM.QueryDlg('确定要退出吗?', '询问') then
  begin
    Action := caNone;
    Exit;
  end;

  Action := caFree;
  TApplicationHelper.SaveFormConfig(Self);
end;

procedure TfFormMain.BtnDelPointClick(Sender: TObject);
begin
  FSM.ShowMsg('Hello,word', 'shint');
end;

procedure TfFormMain.BtnExitClick(Sender: TObject);
begin
  Close();
end;

end.
