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
    tbcPrincipal: TTabControl;
    TabLogin: TTabItem;
    TabNovaConta: TTabItem;
    Layout2: TLayout;
    Layout3: TLayout;
    Label1: TLabel;
    Rectangle2: TRectangle;
    edtUsuario: TEdit;
    Rectangle3: TRectangle;
    edtSenha: TEdit;
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
    lytLogo: TLayout;
    Image1: TImage;
    Layout4: TLayout;
    Image2: TImage;
    Rectangle1: TRectangle;
    Edit1: TEdit;
    SpeedButton1: TSpeedButton;
    sbCriarConta: TSpeedButton;
    Rectangle8: TRectangle;
    NotificationCenter: TNotificationCenter;
    TabPIN: TTabItem;
    Label3: TLabel;
    Rectangle9: TRectangle;
    sbVerificar: TSpeedButton;
    lytPIN01: TLayout;
    Layout7: TLayout;
    Rectangle12: TRectangle;
    Edit4: TEdit;
    Rectangle13: TRectangle;
    Edit5: TEdit;
    Rectangle14: TRectangle;
    Edit6: TEdit;
    Rectangle10: TRectangle;
    Edit2: TEdit;
    Rectangle11: TRectangle;
    Edit3: TEdit;
    Rectangle15: TRectangle;
    Edit7: TEdit;
    lytPIN: TLayout;
    rectPin01: TRectangle;
    edtPIN: TEdit;
    imgBackground: TImage;
    Arc1: TArc;
    tabHome: TTabItem;
    layout_fundo: TLayout;
    Layout1: TLayout;
    Image4: TImage;
    rectBtnJaTenho: TRectangle;
    sbJaTenho: TSpeedButton;
    rectNovaConta: TRectangle;
    SpeedButton2: TSpeedButton;
    layout_wizard: TLayout;
    layout_slide1: TLayout;
    Image3: TImage;
    Label2: TLabel;
    Image6: TImage;
    Layout8: TLayout;
    lbl_voltar: TLabel;
    lbl_proximo: TLabel;
    Layout9: TLayout;
    Layout10: TLayout;
    Circle1: TCircle;
    Circle2: TCircle;
    Circle3: TCircle;
    layout_slide2: TLayout;
    Image5: TImage;
    Label5: TLabel;
    Label6: TLabel;
    layout_slide3: TLayout;
    Image7: TImage;
    Label7: TLabel;
    Label8: TLabel;
    Image8: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure sbCriarContaClick(Sender: TObject);
    procedure sbVerificarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure sbJaTenhoClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private declarations }
     procedure Enviar_Notificacao(nome, titulo, texto : string);
     procedure Enviar_Notificacao_Agendada(nome, titulo, texto : string; segundos : integer);
     procedure Cancelar_Notificacao(nome : string);

  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.fmx}

uses UnitPrincipal, Globais;

procedure TFrmLogin.Enviar_Notificacao(nome, titulo, texto : string);
var
        MinhaNotificacao : TNotification;
begin
        MinhaNotificacao := NotificationCenter.CreateNotification;

        try
                MinhaNotificacao.Name := nome;
                MinhaNotificacao.Title := titulo;
                MinhaNotificacao.AlertBody := texto;

                NotificationCenter.PresentNotification(MinhaNotificacao);
        finally
                MinhaNotificacao.DisposeOf;
        end;
end;


procedure TFrmLogin.Enviar_Notificacao_Agendada(nome, titulo, texto : string; segundos : integer);
var
        MinhaNotificacao : TNotification;
begin
    MinhaNotificacao := NotificationCenter.CreateNotification;

    try
            MinhaNotificacao.Name := nome;
            MinhaNotificacao.Title := titulo;
            MinhaNotificacao.AlertBody := texto;
            MinhaNotificacao.FireDate := IncSecond(now, segundos);

            //NotificationCenter.PresentNotification(MinhaNotificacao);
            NotificationCenter.ScheduleNotification(MinhaNotificacao);
    finally
            MinhaNotificacao.DisposeOf;
    end;
end;

procedure TFrmLogin.Cancelar_Notificacao(nome : string);
begin
    if nome = '' then
            NotificationCenter.CancelAll
    else
            NotificationCenter.CancelNotification(nome);
end;


procedure TFrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := TCloseAction.caFree;
    FrmLogin := nil;

end;

procedure TFrmLogin.FormCreate(Sender: TObject);
begin
    // Configurar endereco no meu SERVIDOR...
    {$IFDEF DEBUG}
    //dm.RESTClient.BaseURL := 'http://192.168.0.50:8082';  // Para testar no Android, coloque p IP do seu PC
//    dm.RESTClient.BaseURL := 'http://localhost:8082';
    {$ELSE}
//    dm.RESTClient.BaseURL := 'https://seu-site-oficial:8082';
    {$ENDIF}

    lytPIN.Visible := false;
    lytLogo.Height := trunc( FrmLogin.Height / 2 );
end;

procedure TFrmLogin.FormShow(Sender: TObject);
begin
 //   TabControl.GotoVisibleTab(1, TTabTransition.Slide);

     tbcPrincipal.ActiveTab := TabHome;
end;

procedure TFrmLogin.Label1Click(Sender: TObject);
begin
    tbcPrincipal.ActiveTab := TabNovaConta;
end;

procedure TFrmLogin.Label4Click(Sender: TObject);
begin
    tbcPrincipal.ActiveTab := TabLogin;

end;

procedure TFrmLogin.sbCriarContaClick(Sender: TObject);
begin
    Enviar_Notificacao('Validacao', 'Número PIN', '653080');
    tbcPrincipal.ActiveTab := TabPIN;

end;

procedure TFrmLogin.sbJaTenhoClick(Sender: TObject);
begin
    tbcPrincipal.ActiveTab := TabLogin;
end;

procedure TFrmLogin.sbVerificarClick(Sender: TObject);
begin
    if edtPIN.Text = '653080' then begin
        tbcPrincipal.ActiveTab := TabLogin;
    end else begin
        ShowMessage('PIN inválido!');
        edtPIN.SetFocus;
        edtPIN.SelectAll;
        exit;
    end;

end;

procedure TFrmLogin.SpeedButton1Click(Sender: TObject);
begin
    V_USUARIO := edtUsuario.Text;
    V_SENHA   := edtSenha.Text;

    // Abrir o form principal...
    if NOT Assigned(FrmPrincipal) then
        Application.CreateForm(TFrmPrincipal, FrmPrincipal);

    Application.MainForm := FrmPrincipal;
    FrmPrincipal.Show;
    FrmLogin.close;

 


end;

procedure TFrmLogin.SpeedButton2Click(Sender: TObject);
begin
    tbcPrincipal.ActiveTab := TabNovaConta;

end;

end.
