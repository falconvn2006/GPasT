unit Form_Signin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  Vcl.StdCtrls;

type
  TSigninForm = class(TForm)
    GPnl_Parametres: TGridPanel;
    Lab_ServerAddress: TLabel;
    BEdt_ServerAddress: TButtonedEdit;
    Lab_Login: TLabel;
    BEdt_Login: TButtonedEdit;
    BEdt_Password: TButtonedEdit;
    Lab_Actions: TLabel;
    GPnl_Actions: TGridPanel;
    CBox_RememberAccount: TCheckBox;
    Btn_Signin: TButton;
    Lab_Password: TLabel;
    Pan_Header: TPanel;
    Img_AppIcon: TImage;
    Lab_AppCaption: TLabel;
    Btn_Close: TImage;
    procedure FormCreate(Sender: TObject);
    procedure Btn_SigninClick(Sender: TObject);
    procedure Btn_CloseClick(Sender: TObject);
    { events }
    procedure OnKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure OnFieldChange(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    class function Prompt: Boolean; overload;
    class function Prompt(const ServerAddress, Login, Password: String;
      const RememberAccount: Boolean): Boolean; overload;
  end;

function SignIn: Boolean; overload;
function SignIn(const ServerAddress, Login, Password: String): Boolean; overload;

var
  SigninForm: TSigninForm;

implementation

{$R *.dfm}

uses
  uAuthentication, uHttp, Form_Main, uConfiguration, uTypes;


function SignIn: Boolean;
begin
  if TConfiguration.Load and Assigned( TConfiguration.Account ) and
    ( Trim( TConfiguration.Server ) <> '' ) then
    Exit(
      SignIn(
        TConfiguration.Server,
        TConfiguration.Account.Login,
        TConfiguration.Account.Password
      )
    )
  else
    Exit( TSigninForm.Prompt );
end;

function SignIn(const ServerAddress, Login, Password: String): Boolean;
var
  Authentication: TAuthentication;
begin
  try
    { TODO : THTTP.ServerAddress<- }
    THttp.ServerAddress := ServerAddress;

    Authentication := TAuthentication.Get( Login, Password );
    try
      if not Assigned( Authentication ) then
        Exit( False );
      if not Authentication.HasUid then
        Exit( False );
      { success }
      MainForm.Uid := Authentication.Uid;
      Exit( True );
    finally
      Authentication.Free
    end;
  except
    Exit( False );
  end;
end;

procedure TSigninForm.Btn_SigninClick(Sender: TObject);
begin
  if SignIn( BEdt_ServerAddress.Text, BEdt_Login.Text, BEdt_Password.Text ) then
    ModalResult := mrOk
  else
    ShowMessage('error');
end;

procedure TSigninForm.Btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TSigninForm.FormCreate(Sender: TObject);
begin
  if Assigned( Vcl.Forms.Application.MainForm ) then
    case Vcl.Forms.Application.MainForm.WindowState of
      TWindowState.wsNormal: BoundsRect := Vcl.Forms.Application.MainForm.BoundsRect;
      TWindowState.wsMinimized, Twindowstate.wsMaximized: WindowState := Vcl.Forms.Application.MainForm.WindowState;
    end;
  OnFieldChange( nil );
//  if not TConfiguration.Load then
//    Exit;
//  if TConfiguration.HasServerAddress then
//    BEdt_ServerAddress.Text := TConfiguration.ServerAddress;
//  if TConfiguration.HasAccount then begin
//    BEdt_Login.Text := TConfiguration.Account.Login;
//    BEdt_Password.Text := TConfiguration.Account.Password;
//  end;
end;

procedure TSigninForm.OnFieldChange(Sender: TObject);
begin
  // Required fields constraint
  Btn_Signin.Enabled := not(
    SameText( Trim( BEdt_ServerAddress.Text ), '' ) or
    SameText( Trim( BEdt_Login.Text ), '' )
  );
end;

procedure TSigninForm.OnKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_RETURN: if Sender <> Btn_Signin then
                 Btn_Signin.Click;
    VK_ESCAPE: Close;
  end;
end;

class function TSigninForm.Prompt: Boolean;
var
  ServerAddress: TServer;
  Login: TLogin;
  Password: TPassword;
begin
  { initializing }
  ServerAddress := '';
  Login := '';
  Password := '';

  if TConfiguration.Load then begin
    if Trim( TConfiguration.Server ) <> '' then
      ServerAddress := TConfiguration.Server;
    if Assigned( TConfiguration.Account ) then begin
      Login := TConfiguration.Account.Login;
      Password := TConfiguration.Account.Password;
    end;
  end;
  Exit( Prompt( ServerAddress, Login, Password, False ) );
end;

class function TSigninForm.Prompt(const ServerAddress, Login, Password: String;
  const RememberAccount: Boolean): Boolean;
begin
  SigninForm := TSigninForm.Create( nil );
  try
    {$REGION 'GUI update'}
    SigninForm.BEdt_ServerAddress.Text := ServerAddress;
    SigninForm.BEdt_Login.Text := Login;
    SigninForm.BEdt_Password.Text := Password;
    SigninForm.CBox_RememberAccount.Checked := RememberAccount;
    {$ENDREGION 'GUI Update'}
    SigninForm.ShowModal;
    if SigninForm.ModalResult <> mrOk then
      Exit( False );
    { success }
    if SigninForm.CBox_RememberAccount.Checked then begin
      TConfiguration.Server := SigninForm.BEdt_ServerAddress.Text;
      if Assigned( TConfiguration.Account ) then
        TConfiguration.Account.Free;
      TConfiguration.Account := TAuthenticationAccount.Create( SigninForm.BEdt_Login.Text, SigninForm.BEdt_Password.Text );
      TConfiguration.Save();
    end;
    Exit( True );
  finally
    SigninForm.Free;
  end;
end;

end.
