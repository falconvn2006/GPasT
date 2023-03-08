unit Server.MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls;

type
  TServerMainForm = class(TForm)
    mmInfo: TMemo;
    btStart: TButton;
    btStop: TButton;
    procedure btStartClick(ASender: TObject);
    procedure btStopClick(ASender: TObject);
    procedure FormCreate(ASender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  end;

var
  ServerMainForm: TServerMainForm;

implementation

uses
  Bcl.Logging,
  Bcl.TMSLogging,
  TMSLoggingCore,
  VCL.TMSLoggingMemoOutputHandler,

  Server.Config, Server.Container;

{$R *.dfm}

{ TServerMainForm }

procedure TServerMainForm.btStartClick(ASender: TObject);
begin
  ServerContainer.StartServer(ServerConfig.BaseUrl, ServerConfig.JwtSecret);
end;

procedure TServerMainForm.btStopClick(ASender: TObject);
begin
  ServerContainer.StopServer;
end;

procedure TServerMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  btStop.Click;
end;

procedure TServerMainForm.FormCreate(ASender: TObject);
begin
  ReportMemoryLeaksOnShutdown := True;
  try
    LoadConfig;
    RegisterTMSLogger;
    TMSDefaultLogger.RegisterOutputHandlerClass(
      TTMSLoggerMemoOutputHandler, [mmInfo]);
    btStart.Click;
  except
    btStart.Enabled := False;
    raise;
  end;
end;

end.
