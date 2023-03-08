unit splash_form;

{$mode objfpc}
{$H+}

interface

uses
  Classes,
  SysUtils,
  Forms,
  Controls,
  Graphics,
  Dialogs,
  ExtCtrls,
  model_base_form;

type

  { TSplashForm }

  TSplashForm = class(TModelBaseForm)
    imLogo: TImage;
    tmTimer: TTimer;
    procedure FormClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure imLogoClick(Sender: TObject);
    procedure pnBackClick(Sender: TObject);
    procedure tmTimerTimer(Sender: TObject);
  public
    procedure fnClose;
  end;

var
  SplashForm: TSplashForm;

implementation

{$R *.lfm}

{ TSplashForm }

procedure TSplashForm.tmTimerTimer(Sender: TObject);
begin
  // # : - routine
  Self.fnClose;
end;

procedure TSplashForm.fnClose;
begin
  // # : - routine
  Self.Close;
end;

procedure TSplashForm.imLogoClick(Sender: TObject);
begin
  // # : - routine
  Self.fnClose;
end;

procedure TSplashForm.FormClick(Sender: TObject);
begin
  // # : - routine
  Self.fnClose;
end;

procedure TSplashForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // # : - routine
  Self.fnClose;
end;

procedure TSplashForm.pnBackClick(Sender: TObject);
begin
  // # : - routine
  Self.fnClose;
end;

end.

