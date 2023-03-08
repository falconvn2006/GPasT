unit uFormWebServer;

interface

uses
  Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.AppEvnts, Vcl.StdCtrls, IdHTTPWebBrokerBridge, Web.HTTPApp;

type
  TFrmServer = class(TForm)
    ButtonStart: TButton;
    ButtonStop: TButton;
    EditPort: TEdit;
    Label1: TLabel;
    ApplicationEvents1: TApplicationEvents;
    ButtonOpenBrowser: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure ButtonStartClick(Sender: TObject);
    procedure ButtonStopClick(Sender: TObject);
    procedure ButtonOpenBrowserClick(Sender: TObject);
  private
    FServer: TIdHTTPWebBrokerBridge;
    procedure StartServer;
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  FrmServer: TFrmServer;

implementation

{$R *.dfm}

uses
  WinApi.Windows, Winapi.ShellApi, uTestVisu;

procedure TFrmServer.ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
begin
  ButtonStart.Enabled := not FServer.Active;
  ButtonStop.Enabled := FServer.Active;
  EditPort.Enabled := not FServer.Active;
end;

procedure TFrmServer.ButtonOpenBrowserClick(Sender: TObject);
var
  LURL: string;
begin
  StartServer;
  LURL := Format('http://localhost:%s', [EditPort.Text]);
  ShellExecute(0,
        nil,
        PChar(LURL), nil, nil, SW_SHOWNOACTIVATE);
end;

procedure TFrmServer.ButtonStartClick(Sender: TObject);
begin
  StartServer;
end;

procedure TFrmServer.ButtonStopClick(Sender: TObject);
begin
  FrmVisu.Release;
  FrmVisu := nil;
  FServer.Active := False;
  FServer.Bindings.Clear;
end;

procedure TFrmServer.FormCreate(Sender: TObject);
begin
  FServer := TIdHTTPWebBrokerBridge.Create(Self);
end;

procedure TFrmServer.StartServer;
begin
  if not Assigned(FrmVisu) then
  begin
    Application.CreateForm(TFrmVisu, FrmVisu);
    FrmVisu.Left := Self.Left + Self.Width;
    FrmVisu.Top := Self.Top;
    FrmVisu.Visible := True;
  end;
  if not FServer.Active then
  begin
    FServer.Bindings.Clear;
    FServer.DefaultPort := StrToInt(EditPort.Text);
    FServer.Active := True;
  end;
end;

end.
