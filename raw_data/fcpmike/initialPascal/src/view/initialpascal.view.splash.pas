{ ******************************************************************************
  Title: Initial Pascal
  Description: Tela relacionado à [Splash]

  @author Fabiano Morais (fcpm_mike@hotmail.com)
  @add initial
  **************************************************************************** }
unit InitialPascal.View.Splash;

{$mode objfpc}{$H+}

interface

uses
  Classes, Forms, Controls, ExtCtrls, ComCtrls, StdCtrls, Types,
  initialPascal.Controller.Interfaces;

type

  { TFViewSplash }

  TFViewSplash = class(TForm)
    img: TImage;
    labVersion: TLabel;
    labMessage: TLabel;
    panMain: TPanel;
    pbStartup: TProgressBar;
    timClose: TTimer;
    timStartup: TTimer;
    procedure FormShow(Sender: TObject);
    procedure timCloseTimer(Sender: TObject);
    procedure timStartupTimer(Sender: TObject);
  private
    FController: iControllerMain;
  public
    constructor Create(aOwner: TComponent; aController: iControllerMain); reintroduce;
  end;

var
  FViewSplash: TFViewSplash;

implementation

uses
  LCLType, sysutils;

{$R *.lfm}

{ TFViewSplash }

procedure TFViewSplash.timStartupTimer(Sender: TObject);
begin
  timStartup.Enabled:=False;
  FController.Run;
end;

procedure TFViewSplash.FormShow(Sender: TObject);
begin
  timStartup.Enabled:=True;
end;

procedure TFViewSplash.timCloseTimer(Sender: TObject);
begin
  timClose.Enabled:=False;
  ModalResult := mrOK;
end;

constructor TFViewSplash.Create(aOwner: TComponent; aController: iControllerMain);
begin
  inherited Create(aOwner);
  FController := aController;
end;

end.
