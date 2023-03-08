unit EMSI.UI.SessionFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,EMSI.WMI.Sessions;

type
  TfrmSessionInfo = class(TFrame)
    GroupBox1: TGroupBox;
    Panel4: TPanel;
    Label6: TLabel;
    lblPackage: TLabel;
    Panel1: TPanel;
    Label1: TLabel;
    lblStartTime: TLabel;
    Panel2: TPanel;
    Label3: TLabel;
    lblUser: TLabel;
    Panel3: TPanel;
    Label5: TLabel;
    lblLoginType: TLabel;
    Panel5: TPanel;
    Label9: TLabel;
    lblLoginID: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure FillFromSession(ASession:  TEMSI_WMISession);
  end;

implementation

{$R *.dfm}

{ TFrame1 }

procedure TfrmSessionInfo.FillFromSession(ASession: TEMSI_WMISession);
begin
  lblPackage.Caption := ASession.AuthenticationPackage;
  lblStartTime.Caption := DateToStr(ASession.StartTime);
  lblUser.Caption := ASession.Domain + ' / '+ASession.User;
  lblLoginType.Caption := ASession.LogonTypeStr + ' / '+ASession.LogonType.ToString;
  lblLoginID.Caption := ASession.LogonId;
end;

end.
