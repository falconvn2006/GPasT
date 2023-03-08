unit uLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons;

type
  TFrmLogin = class(TForm)
    LblTitle: TLabel;
    EdtUser: TLabeledEdit;
    PnlMain: TPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    EdtSenha: TLabeledEdit;
    BtnLogin: TSpeedButton;
    ContainerButton: TPanel;
    BtnFechar: TSpeedButton;
    procedure BtnLoginClick(Sender: TObject);
    procedure EdtUserKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EdtSenhaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BtnFecharClick(Sender: TObject);
  private
    procedure Login;
  public
    ResLogin: Boolean;
  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.dfm}

uses DM.Main;

procedure TFrmLogin.BtnFecharClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFrmLogin.BtnLoginClick(Sender: TObject);
begin
  Login;
end;

procedure TFrmLogin.EdtSenhaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    Login;
end;

procedure TFrmLogin.Login;
begin
  ResLogin := DM.Main.DMMain.UserLogin(EdtUser.Text, EdtSenha.Text);
  if ResLogin then
    Close
  else
    ShowMessage('Usuário ou Senha incorretos!');
end;

procedure TFrmLogin.EdtUserKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    EdtSenha.SetFocus;
end;

end.
