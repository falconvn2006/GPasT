unit fmBaseLogin;

{$INCLUDE XCompilerOptions.inc}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, fmBaseDialog, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus,
  Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls, dxBevel, dxSkinsCore, dxSkinBasic, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkroom, dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle,
  dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky,
  dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMetropolis, dxSkinMetropolisDark, dxSkinMoneyTwins, dxSkinOffice2007Black,
  dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinOffice2013DarkGray, dxSkinOffice2013LightGray,
  dxSkinOffice2013White, dxSkinOffice2016Colorful, dxSkinOffice2016Dark, dxSkinOffice2019Black,
  dxSkinOffice2019Colorful, dxSkinOffice2019DarkGray, dxSkinOffice2019White, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver, dxSkinSpringtime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinTheBezier, dxSkinsDefaultPainters, dxSkinValentine, dxSkinVisualStudio2013Blue,
  dxSkinVisualStudio2013Dark, dxSkinVisualStudio2013Light, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  Vcl.Imaging.pngimage;

type
  TBaseLoginForm = class(TBaseDialogForm)
    imgLogo: TImage;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    FAttemptsNumber    : Integer;
    FMaxAttemptsNumber : Integer;

    procedure SetMaxAttemptsNumber(const Value: Integer);
  protected
    FLastError         : string;
  public
    constructor Create(AOwner: TComponent); override;
    function  Connect: Boolean; virtual;
    procedure AfterConnectOk; virtual;
    procedure AfterConnectError(E: Exception); virtual;

    property  LastError: string read FLastError;
    property  AttemptsNumber: Integer read FAttemptsNumber write FAttemptsNumber;
    property  MaxAttemptsNumber: Integer read FMaxAttemptsNumber write SetMaxAttemptsNumber;
  end;

implementation

{$R *.dfm}

uses
  System.Math, XUtils;

constructor TBaseLoginForm.Create(AOwner: TComponent);
begin
  inherited;

  FLastError         := '';
  FAttemptsNumber    := 0;
  FMaxAttemptsNumber := 3;
end;

procedure TBaseLoginForm.AfterConnectError(E: Exception);
var
  Msg: string;
begin
  if Assigned(E)
    then Msg := E.Message
    else Msg := LastError;
  if FAttemptsNumber >= FMaxAttemptsNumber then
    Msg := Msg + #13#13'Превышено число попыток соединения с базой данных.';

  if Msg <> '' then
    MsgBox('Ошибка подключения к базе данных', Msg, MB_OK + MB_ICONERROR);
end;

procedure TBaseLoginForm.AfterConnectOk;
begin
end;

function TBaseLoginForm.Connect: Boolean;
begin
  Result := False;
end;

procedure TBaseLoginForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  inherited;
  if ModalResult = mrOk then begin
    if Connect then begin
      FAttemptsNumber := 0;
      AfterConnectOk
    end else begin
      FAttemptsNumber := FAttemptsNumber + 1;
      CanClose        := False;
      AfterConnectError(nil);
      if FAttemptsNumber >= FMaxAttemptsNumber then begin
        ModalResult := mrCancel;
        CanClose    := True;
      end;
    end;
  end else begin
    FAttemptsNumber := 0;
    CanClose        := True;
  end;
end;

procedure TBaseLoginForm.SetMaxAttemptsNumber(const Value: Integer);
begin
  FMaxAttemptsNumber := ifthen(Value < 0, 0, Value);
end;

end.
