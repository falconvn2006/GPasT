unit View.Principal;

interface

uses
  Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.AppEvnts, Vcl.StdCtrls, IdHTTPWebBrokerBridge, IdGlobal, Web.HTTPApp,
  Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Comp.Client,
  FireDAC.Phys.PGDef, FireDAC.Phys.PG, Vcl.WinXCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage;

type
  TfrmServidor = class(TForm)
    aeEventos: TApplicationEvents;
    pnlServer: TPanel;
    Image1: TImage;
    Switch: TToggleSwitch;
    GroupBox1: TGroupBox;
    EditPort: TEdit;
    ButtonOpenBrowser: TButton;
    StatusBar1: TStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure aeEventosIdle(Sender: TObject; var Done: Boolean);
    procedure ButtonOpenBrowserClick(Sender: TObject);
    procedure SwitchClick(Sender: TObject);
  private
    FServer: TIdHTTPWebBrokerBridge;
    procedure StartServer;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmServidor: TfrmServidor;

implementation

{$R *.dfm}

uses
{$IFDEF MSWINDOWS}
  WinApi.Windows, Winapi.ShellApi,
{$ENDIF}
  Datasnap.DSSession,
  System.Generics.Collections;

procedure TfrmServidor.aeEventosIdle(Sender: TObject; var Done: Boolean);
begin
  EditPort.Enabled := not FServer.Active;
end;

procedure TfrmServidor.ButtonOpenBrowserClick(Sender: TObject);
{$IFDEF MSWINDOWS}
var
  LURL: string;
{$ENDIF}
begin
  StartServer;
{$IFDEF MSWINDOWS}
  LURL := Format('http://localhost:%s', [EditPort.Text]);
  ShellExecute(0,
        nil,
        PChar(LURL), nil, nil, SW_SHOWNOACTIVATE);
{$ENDIF}
end;

procedure TerminateThreads;
begin
  if TDSSessionManager.Instance <> nil then
    TDSSessionManager.Instance.TerminateAllSessions;
end;

procedure TfrmServidor.FormCreate(Sender: TObject);
begin
  FServer := TIdHTTPWebBrokerBridge.Create(Self);
end;

procedure TfrmServidor.StartServer;
begin
  if not FServer.Active then
  begin
    FServer.Bindings.Clear;
    FServer.DefaultPort := StrToInt(EditPort.Text);
    FServer.Active := True;
  end;
end;

procedure TfrmServidor.SwitchClick(Sender: TObject);
begin
  if Switch.State = tssOn then
    StartServer
  else
  begin
    TerminateThreads;
    FServer.Active := False;
    FServer.Bindings.Clear;
  end;
end;

end.
