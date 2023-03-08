unit UnitLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.TabControl, FMX.Objects, FMX.Controls.Presentation, FMX.Edit, FMX.StdCtrls,
  uLoading, uSession;

type
  TFrmLogin = class(TForm)
    Layout1: TLayout;
    Image1: TImage;
    TabControl1: TTabControl;
    TabLogin: TTabItem;
    TabConta: TTabItem;
    rectLogin: TRectangle;
    Rectangle1: TRectangle;
    edtEmail: TEdit;
    edtSenha: TEdit;
    recBtnLogin: TRectangle;
    BtnLogin: TSpeedButton;
    Label1: TLabel;
    Rectangle2: TRectangle;
    Rectangle3: TRectangle;
    edtContaNome: TEdit;
    edtContaSenha: TEdit;
    Rectangle4: TRectangle;
    BtnConta: TSpeedButton;
    lblConta: TLabel;
    edtContaEmail: TEdit;
    procedure BtnLoginClick(Sender: TObject);
    procedure BtnContaClick(Sender: TObject);
    procedure lblContaClick(Sender: TObject);
    procedure Label1Click(Sender: TObject);
  private
    procedure AbrirFormPrincipal;
    procedure ThreadLoginTerminate(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.fmx}

uses UnitPrincipal, DataModule.Global;

procedure TFrmLogin.AbrirFormPrincipal;
begin
  if not(Assigned(FrmPrincipal))then
    Application.CreateForm(TFrmPrincipal, FrmPrincipal);

  Application.MainForm := FrmPrincipal;
  FrmPrincipal.Show;
  FrmLogin.Close;
end;

procedure TFrmLogin.ThreadLoginTerminate(Sender: TObject);
begin
  TLoading.Hide;
  if(Sender is TThread)then
  begin
    if(Assigned(TThread(Sender).FatalException))then
    begin
      ShowMessage(Exception(TThread(Sender).FatalException).Message);
      exit;
    end;
  end;
  AbrirFormPrincipal;
end;

procedure TFrmLogin.BtnContaClick(Sender: TObject);
var
  T: TThread;
begin
  TLoading.Show(FrmLogin, '');

  T := TThread.CreateAnonymousThread(procedure
  begin
    dmGlobal.CriarContaOnline(edtContaNome.Text, edtContaEmail.Text, edtContaSenha.Text);

    with dmGlobal.TabUsuario do
    begin
      dmGlobal.InserirUsuario(FieldByName('id_usuario').AsInteger,
                              FieldByName('nome').AsString,
                              FieldByName('email').AsString);
      TSession.ID_USUARIO := FieldByName('id_usuario').AsInteger;
      TSession.Nome := FieldByName('nome').AsString;
      TSession.EMAIL := FieldByName('email').AsString;
    end;

  end);
  T.OnTerminate := ThreadLoginTerminate;
  T.Start;
end;

procedure TFrmLogin.BtnLoginClick(Sender: TObject);
var
  T: TThread;
begin
  TLoading.Show(FrmLogin, '');

  T := TThread.CreateAnonymousThread(procedure
  begin
    dmGlobal.LoginOnline(edtEmail.Text, edtSenha.Text);

    with dmGlobal.TabUsuario do
    begin
      dmGlobal.InserirUsuario(FieldByName('id_usuario').AsInteger,
                              FieldByName('nome').AsString,
                              FieldByName('email').AsString);
      TSession.ID_USUARIO := FieldByName('id_usuario').AsInteger;
      TSession.Nome := FieldByName('nome').AsString;
      TSession.EMAIL := FieldByName('email').AsString;
    end;

  end);
  T.OnTerminate := ThreadLoginTerminate;
  T.Start;
end;

procedure TFrmLogin.Label1Click(Sender: TObject);
begin
  TabControl1.GotoVisibleTab(1);
end;

procedure TFrmLogin.lblContaClick(Sender: TObject);
begin
  TabControl1.GotoVisibleTab(0);
end;

end.
