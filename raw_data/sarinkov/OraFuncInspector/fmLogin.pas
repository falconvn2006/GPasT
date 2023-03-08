unit fmLogin;

{$INCLUDE XCompilerOptions.inc}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, fmBaseLogin, dxSkinsCore, dxSkinBasic, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
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
  cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, cxControls, cxContainer, cxEdit, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxButtonEdit,
  dxGDIPlusClasses, System.Actions, Vcl.ActnList,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, System.Win.Registry, System.ImageList, Vcl.ImgList, cxImageList,
  cxButtons, dxBevel;

type
  TLoginForm = class(TBaseLoginForm)
    cbxUserName: TcxComboBox;
    cbxDatabase: TcxComboBox;
    lblUserName: TLabel;
    lblPassword: TLabel;
    lblDatabase: TLabel;
    edtPassword: TcxButtonEdit;
    ils16x16: TcxImageList;
    ils14x14: TcxImageList;
    ActMgr: TActionManager;
    actShowHidePassword: TAction;
    btnClearUserNametList: TcxButton;
    btnClearDatabaseList: TcxButton;
    procedure FormCreate(Sender: TObject);
    procedure actShowHidePasswordExecute(Sender: TObject);
    procedure btnClearUserNametListClick(Sender: TObject);
    procedure btnClearDatabaseListClick(Sender: TObject);
  private
    function  GetDatabase: string;
    function  GetPassword: string;
    function  GetUserName: string;
    function  GetPasswordButtonImage: Integer;
    procedure SetPasswordButtonImage(const Value: Integer);
  public
    function  Connect: Boolean; override;

    procedure SaveToRegistry(R: TRegistry); override;
    procedure LoadFromRegistry(R: TRegistry); override;

    property  UserName: string read GetUserName;
    property  Password: string read GetPassword;
    property  Database: string read GetDatabase;

    property  PasswordButtonImage: Integer read GetPasswordButtonImage write SetPasswordButtonImage;
  end;

var
  LoginForm: TLoginForm;

implementation

{$R *.dfm}

uses
  XUtils, unGlobals, dmMain;

const
  IMG_EYE       = 0;
  IMG_EYE_SLASH = 1;

procedure TLoginForm.actShowHidePasswordExecute(Sender: TObject);
begin
  inherited;
  if PasswordButtonImage = IMG_EYE
    then PasswordButtonImage := IMG_EYE_SLASH
    else PasswordButtonImage := IMG_EYE;
end;

procedure TLoginForm.btnClearDatabaseListClick(Sender: TObject);
begin
  inherited;
  cbxDatabase.Properties.Items.Clear;
end;

procedure TLoginForm.btnClearUserNametListClick(Sender: TObject);
begin
  inherited;
  cbxUserName.Properties.Items.Clear;
end;

function TLoginForm.Connect: Boolean;
begin
  with DM.Connection do begin
    Params.UserName := UserName;
    Params.Database := Database;
    Params.Password := Password;
  end;

  try
    FLastError              := '';
    DM.Connection.Connected := True;
  except
    on E: Exception do
      FLastError := E.Message;
  end;

  Result := DM.Connection.Connected;
end;

procedure TLoginForm.FormCreate(Sender: TObject);
begin
  inherited;
  if cbxUserName.ItemIndex = -1 then
    cbxUserName.Text := '';
  if cbxDatabase.ItemIndex = -1 then
    cbxDatabase.Text := '';
  {$IFDEF DEBUG}
  edtPassword.Text    := '1982';
  {$ELSE}
  edtPassword.Text    := '';
  {$ENDIF}
  PasswordButtonImage := IMG_EYE;
end;

function TLoginForm.GetDatabase: string;
begin
  Result := cbxDatabase.Text;
end;

function TLoginForm.GetPassword: string;
begin
  Result := edtPassword.Text;
end;

function TLoginForm.GetUserName: string;
begin
  Result := cbxUserName.Text;
end;

procedure TLoginForm.SaveToRegistry(R: TRegistry);
begin
  inherited;
  SaveComboBox(R, cbxUserName);
  SaveComboBox(R, cbxDatabase);
end;

procedure TLoginForm.LoadFromRegistry(R: TRegistry);
begin
  inherited;
  LoadComboBox(R, cbxUserName);
  LoadComboBox(R, cbxDatabase);
end;

function TLoginForm.GetPasswordButtonImage: Integer;
begin
  Result := edtPassword.Properties.Buttons[0].ImageIndex;
end;

procedure TLoginForm.SetPasswordButtonImage(const Value: Integer);
const
  Hints      : array [IMG_EYE..IMG_EYE_SLASH] of string = ('Показать пароль', 'Скрыть пароль');
  EchoModes  : array [IMG_EYE..IMG_EYE_SLASH] of TcxEditEchoMode = (eemPassword, eemNormal);
begin
  if Value in [IMG_EYE, IMG_EYE_SLASH] then begin
    edtPassword.Properties.Buttons[0].ImageIndex := Value;
    edtPassword.Properties.Buttons[0].Hint       := Hints[Value];
    edtPassword.Properties.EchoMode              := EchoModes[Value];
  end;
end;

end.

