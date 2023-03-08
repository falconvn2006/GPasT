unit EMSI.UI.ProcessFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  EMSI.SysInfo.Processes;

type
  TFrameProcess = class(TFrame)
    GroupBox1: TGroupBox;
    Panel1: TPanel;
    imgProccess: TImage;
    lblProcessName: TLabel;
    lblCompany: TLabel;
    lblVersion: TLabel;
    Panel2: TPanel;
    Label1: TLabel;
    edtFullPath: TEdit;
    Panel3: TPanel;
    Label2: TLabel;
    lblParent: TLabel;
    Label4: TLabel;
    lblUser: TLabel;
    Label6: TLabel;
    lblSession: TLabel;
  private
    { Private declarations }
    procedure Clear;
  public
    procedure FillFromWinProc(WinProc: TEMSI_WinProcess);
    { Public declarations }
  end;

implementation

{$R *.dfm}

{ TFrameProcess }

procedure TFrameProcess.Clear;
begin
  imgProccess.Picture := nil;
  lblProcessName.Caption := 'Process Name';
  lblCompany.Caption := 'Company Name';
  lblVersion.Caption := 'Version';
  edtFullPath.Clear;
  lblUser.Caption := '--';
  lblParent.Caption := '--';
  lblSession.Caption := '--';
end;

procedure TFrameProcess.FillFromWinProc(WinProc: TEMSI_WinProcess);
begin
  Clear;
  imgProccess.Picture := nil;
  lblProcessName.Caption := WinProc.ExeFile;
  lblCompany.Caption := 'Company Name';
  lblVersion.Caption := 'Version';
  edtFullPath.Text := WinProc.FullPath;
  lblUser.Caption := WinProc.UserName;
  lblParent.Caption := WinProc.ParentPID.ToString;
  lblSession.Caption := WinProc.SessionID.ToString;
end;

end.
