{ ******************************************************************************
  Title: InitialPascal
  Description: Controller relacionado à [Main]

  @author Fabiano Morais (fcpm_mike@hotmail.com)
  @add Initial
  **************************************************************************** }
unit initialPascal.Controller.Main;

{$mode objfpc}{$H+}

interface

uses
  Forms, SysUtils, Controls,
  initialPascal.Controller.Interfaces,
  initialPascal.Model.Interfaces,
  initialPascal.View.Splash;

type

  { TControllerMain }

  TControllerMain = class(TInterfacedObject, iFactoryController, iControllerMain, iControllerForms)
  private
    class var FInstance: iFactoryController;
    FSplash: TFViewSplash;
    FModelMain: iModelMain;
    FFormResult: TModalResult;
    procedure MapActions;
    procedure OnClose( aSender: TObject );
    procedure UpdateProgressbar(aValue: Integer);
  public
    constructor Create;
    destructor Destroy; override;
    class function New: iFactoryController;
    function Main: iControllerMain;

    function Run: iControllerMain;
    function SplashView: iControllerForms;
    function FormResult: TModalResult;
    function &End: iControllerForms;
    function ShowView: iControllerForms;
  end;

implementation

uses
  initialPascal.Types,
  initialPascal.Util,
  initialPascal.Controller.Message,
  initialPascal.View.Main,
  initialPascal.Model.Main;

{ TControllerMain }

procedure TControllerMain.MapActions;
begin
  FViewMain.acClose.OnExecute := @OnClose;
end;

procedure TControllerMain.OnClose(aSender: TObject);
begin
  FViewMain.Close;
end;

procedure TControllerMain.UpdateProgressbar(aValue: Integer);
begin
  FSplash.pbStartup.Position:=aValue;
end;

constructor TControllerMain.Create;
begin
  Application.Initialize;
  if not Assigned(FViewMain) then
    Application.CreateForm(TFViewMain, FViewMain);
  FModelMain:=TModelMain.New;
  Self.SplashView;
  Self.MapActions;
end;

destructor TControllerMain.Destroy;
begin
  inherited Destroy;
end;

class function TControllerMain.New: iFactoryController;
begin
  if not Assigned(FInstance) then
    FInstance := Self.Create;
  Result := FInstance;
end;

function TControllerMain.Main: iControllerMain;
begin
  Result := Self;
end;

function TControllerMain.Run: iControllerMain;
begin
  Result := Self;
  try
    FSplash.labMessage.Caption:='Inicializando...';
    FSplash.Refresh;
    FModelMain.Initialize;
    FSplash.timClose.Enabled:=True;
  except
    on e: Exception do
    begin
      TControllerMessage.New
                            .TypeMessage(fmAlert)
                            .Message(EmptyStr)
                            .Message(PChar(e.Message))
                            .&End.ShowView;
      Application.Terminate;
    end;
  end;
end;

function TControllerMain.SplashView: iControllerForms;
begin
  Result := Self;
  FSplash := TFViewSplash.Create(Application, Self);
  try
    FSplash.labMessage.Caption:='Inicializando...';
    FSplash.labVersion.Caption:='v' + TUtil.VersionExe;
    FModelMain
              .SplashAddForm(FSplash)
              .SplashUpdateProgressbar(FSplash.pbStartup.Max, @UpdateProgressbar);
    FSplash.ShowModal;
    FFormResult:=FSplash.ModalResult;
  finally
    FreeAndNil(FSplash);
  end;
end;

function TControllerMain.FormResult: TModalResult;
begin
  Result := FFormResult;
end;

function TControllerMain.&End: iControllerForms;
begin
  Result := Self;
end;

function TControllerMain.ShowView: iControllerForms;
begin
  Result := Self;
  case FFormResult of
    mrOK: Application.Run;
  end;
end;

end.
