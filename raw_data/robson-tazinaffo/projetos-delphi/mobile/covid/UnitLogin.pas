unit UnitLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Objects, FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit,
  FMX.ListBox
  ,System.Notification,
  DateUtils
  ;



type
  TFrmLogin = class(TForm)
    TabControl: TTabControl;
    TabLogin: TTabItem;
    TabNovaConta: TTabItem;
    Layout2: TLayout;
    Layout3: TLayout;
    Label1: TLabel;
    Rectangle2: TRectangle;
    edt_login_email: TEdit;
    Rectangle3: TRectangle;
    edt_login_senha: TEdit;
    rect_btn_login: TRectangle;
    Layout5: TLayout;
    Rectangle4: TRectangle;
    edt_conta_nome: TEdit;
    Rectangle5: TRectangle;
    edt_conta_senha: TEdit;
    Rectangle6: TRectangle;
    Layout6: TLayout;
    Label4: TLabel;
    Rectangle7: TRectangle;
    edt_conta_email: TEdit;
    lytBase: TLayout;
    Layout1: TLayout;
    Image1: TImage;
    Layout4: TLayout;
    Image2: TImage;
    Rectangle1: TRectangle;
    Edit1: TEdit;
    SpeedButton1: TSpeedButton;
    rectIdade: TRectangle;
    ComboBox1: TComboBox;
    sbCriarConta: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.fmx}

uses UnitPrincipal;






procedure TFrmLogin.FormCreate(Sender: TObject);
begin
    // Configurar endereco no meu SERVIDOR...
    {$IFDEF DEBUG}
    //dm.RESTClient.BaseURL := 'http://192.168.0.50:8082';  // Para testar no Android, coloque p IP do seu PC
//    dm.RESTClient.BaseURL := 'http://localhost:8082';
    {$ELSE}
//    dm.RESTClient.BaseURL := 'https://seu-site-oficial:8082';
    {$ENDIF}
end;

procedure TFrmLogin.FormShow(Sender: TObject);
begin
    TabControl.GotoVisibleTab(1, TTabTransition.Slide);
end;

procedure TFrmLogin.Label1Click(Sender: TObject);
begin
    TabControl.ActiveTab := TabNovaConta;
end;

procedure TFrmLogin.Label4Click(Sender: TObject);
begin
    TabControl.ActiveTab := TabLogin;

end;

procedure TFrmLogin.SpeedButton1Click(Sender: TObject);
begin
    // Abrir o form principal...
    if NOT Assigned(FrmPrincipal) then
        Application.CreateForm(TFrmPrincipal, FrmPrincipal);

 //   FrmPrincipal.id_usuario_global := id_usuario;
    FrmPrincipal.Show;
    Application.MainForm := FrmPrincipal;
    FrmLogin.DisposeOf;
//    FrmLogin.Close;

end;

end.
