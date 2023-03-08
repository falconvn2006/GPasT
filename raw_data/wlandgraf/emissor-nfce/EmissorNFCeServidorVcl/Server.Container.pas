unit Server.Container;

interface

uses
  System.SysUtils, System.Classes, System.IOUtils,
  Generics.Collections,
  Bcl.Logging,
  Sparkle.HttpServer.Module, Sparkle.Security,
  Sparkle.HttpServer.Context, Sparkle.Comp.Server,
  Sparkle.Comp.HttpSysDispatcher,
  XData.Aurelius.Model,
  XData.Server.Module,
  XData.Comp.Server,

  Sparkle.Comp.BasicAuthMiddleware,
  Sparkle.Comp.CompressMiddleware, Sparkle.Comp.CorsMiddleware,
  Sparkle.Comp.JwtMiddleware, Sparkle.Comp.GenericMiddleware,

  Sparkle.Comp.LoggingMiddleware,

  Server.Config,
  NFCe.Emissor;

type
  TServerContainer = class(TDataModule)
    SparkleHttpSysDispatcher: TSparkleHttpSysDispatcher;
    XDataServer: TXDataServer;
    XDataServerLogging: TSparkleLoggingMiddleware;
    XDataServerCompress: TSparkleCompressMiddleware;
    XDataServerCors: TSparkleCorsMiddleware;
    XDataServerJWT: TSparkleJwtMiddleware;
    XDataServerGeneric: TSparkleGenericMiddleware;
    procedure XDataServerJWTGetSecret(Sender: TObject; var Secret: string);
    procedure XDataServerModuleException(Sender: TObject;
      Args: TModuleExceptionArgs);
    procedure XDataServerGenericRequest(Sender: TObject;
      Context: THttpServerContext; Next: THttpServerProc);
    procedure DataModuleCreate(Sender: TObject);
  private
    FJwtSecret: string;
  public
    procedure StartServer(ABaseUrl: string; AJwtSecret: string);
    procedure StopServer;
  end;

var
  ServerContainer: TServerContainer;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TServerContainer.DataModuleCreate(Sender: TObject);
begin
  TXDataAureliusModel.Default.Title := 'Emissor NFCe API';
end;

procedure TServerContainer.StartServer(ABaseUrl: string; AJwtSecret: string);
begin
  if SparkleHttpSysDispatcher.Active then
    Exit;
  FJwtSecret := AJwtSecret;
  XDataServer.BaseUrl := ABaseUrl;
  SparkleHttpSysDispatcher.Start;
  LogManager.GetLogger.Info(Format('Servidor EmissorNFCe rodando no endereço "%s"', [XDataServer.BaseUrl]));
end;

procedure TServerContainer.StopServer;
begin
  if not SparkleHttpSysDispatcher.Active then
    Exit;
  SparkleHttpSysDispatcher.Stop;
  LogManager.GetLogger.Info('Servidor EmissorNFCe parado');
end;

procedure TServerContainer.XDataServerGenericRequest(Sender: TObject;
  Context: THttpServerContext; Next: THttpServerProc);
var
  LastSegment: string;
begin
  LastSegment := '';
  if (Length(Context.Request.Uri.Segments) > 0) then
    LastSegment := Context.Request.Uri.Segments[Length(Context.Request.Uri.Segments) - 1];
  LastSegment := LowerCase(LastSegment);

  if (Context.Request.User = nil) and (LastSegment <> 'swaggerui') and (LastSegment <> 'swagger.json') then
  begin
    Context.Response.StatusCode := 401;
    Context.Response.ContentType := 'text/plain';
    Context.Response.Close(TEncoding.UTF8.GetBytes('Unauthorized'));
  end
  else
    Next(Context);
end;

procedure TServerContainer.XDataServerJWTGetSecret(Sender: TObject;
  var Secret: string);
begin
  Secret := FJwtSecret;
end;

procedure TServerContainer.XDataServerModuleException(Sender: TObject;
  Args: TModuleExceptionArgs);
begin
  if Args.Exception is EEmissorNFCeException then
    Args.StatusCode := (Args.Exception as EEmissorNFCeException).StatusCode;
end;

end.
