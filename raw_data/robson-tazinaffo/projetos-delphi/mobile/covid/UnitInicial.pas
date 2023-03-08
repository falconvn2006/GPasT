unit UnitInicial;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts,
  FMX.TabControl, System.Actions, FMX.ActnList, FMX.ListBox, FMX.Edit,
  System.Notification, DateUtils

{$IF Defined(ANDROID)}
    , FMX.Helpers.Android,
  Androidapi.Helpers
{$ENDIF};


type
  TFrmInicial = class(TForm)
    layout_wizard: TLayout;
    layout_slide1: TLayout;
    Image1: TImage;
    Label1: TLabel;
    Layout2: TLayout;
    lbl_voltar: TLabel;
    lbl_proximo: TLabel;
    Layout3: TLayout;
    Layout4: TLayout;
    Circle1: TCircle;
    Circle2: TCircle;
    Circle3: TCircle;
    layout_slide2: TLayout;
    Image2: TImage;
    Label5: TLabel;
    Label6: TLabel;
    layout_slide3: TLayout;
    Image3: TImage;
    Label7: TLabel;
    Label8: TLabel;
    layout_fundo: TLayout;
    Layout5: TLayout;
    StyleBook1: TStyleBook;
    tbcPrincipal: TTabControl;
    tabHome: TTabItem;
    tabForms: TTabItem;
    lytPrincipal: TLayout;
    ActionList1: TActionList;
    actMudarAba: TChangeTabAction;
    Image5: TImage;
    Image6: TImage;
    sbJaTenho: TSpeedButton;
    tabSplash: TTabItem;
    Arc1: TArc;
    Label2: TLabel;
    lytImagem: TLayout;
    Image7: TImage;
    Timer1: TTimer;
    rectFundo: TRectangle;
    rectBtnJaTenho: TRectangle;
    rectNovaConta: TRectangle;
    Image4: TImage;
    SpeedButton1: TSpeedButton;
    TabNovaConta: TTabItem;
    Layout1: TLayout;
    Rectangle4: TRectangle;
    edt_conta_nome: TEdit;
    Rectangle5: TRectangle;
    edt_conta_senha: TEdit;
    Rectangle6: TRectangle;
    Rectangle7: TRectangle;
    edt_conta_email: TEdit;
    Rectangle1: TRectangle;
    Edit1: TEdit;
    rectIdade: TRectangle;
    ComboBox1: TComboBox;
    Layout6: TLayout;
    Label4: TLabel;
    Layout7: TLayout;
    Image8: TImage;
    cbCriarConta: TSpeedButton;
    NotificationCenter: TNotificationCenter;
    TabPIN: TTabItem;
    Label3: TLabel;
    Rectangle8: TRectangle;
    sbVerificar: TSpeedButton;
    lytPIN: TLayout;
    rectPin01: TRectangle;
    edtPIN: TEdit;
    procedure sbJaTenhoClick(Sender: TObject);
    procedure FormSaveState(Sender: TObject);
    procedure lbl_proximoClick(Sender: TObject);
    procedure lbl_voltarClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure cbCriarContaClick(Sender: TObject);
    procedure NotificationCenterReceiveLocalNotification(Sender: TObject;
      ANotification: TNotification);
    procedure sbVerificarClick(Sender: TObject);
  private
    { Private declarations }
     FActiveForm : TForm;
     procedure AbrirForm(AFormClass: TComponentClass);
     procedure Trata_Slides(slide : integer);
     procedure CorBarraTarefas;
     procedure Enviar_Notificacao(nome, titulo, texto : string);
     procedure Enviar_Notificacao_Agendada(nome, titulo, texto : string; segundos : integer);
     procedure Cancelar_Notificacao(nome : string);
  public
    { Public declarations }
    procedure MudarAba(ATabItem: TTabItem; Sender: TObject);
  end;

var
  FrmInicial: TFrmInicial;

implementation

{$R *.fmx}

uses UnitLogin;

procedure TFrmInicial.Enviar_Notificacao(nome, titulo, texto : string);
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


procedure TFrmInicial.Enviar_Notificacao_Agendada(nome, titulo, texto : string; segundos : integer);
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

procedure TFrmInicial.Cancelar_Notificacao(nome : string);
begin
    if nome = '' then
            NotificationCenter.CancelAll
    else
            NotificationCenter.CancelNotification(nome);
end;


procedure TFrmInicial.CorBarraTarefas;
begin
//  Rectangle1.Fill.Color := ColorPanel1.Color;
{$IF Defined(IOS)}
//  Form1.SystemStatusBar.BackgroundColor := ColorPanel1.Color;
  Form1.SystemStatusBar.BackgroundColor := $FF5CC6BA;

  Form1.SystemStatusBar.Visibility :=
    TFormSystemStatusBar.TVisibilityMode.Visible;
{$ENDIF}
{$IF Defined(ANDROID)}
  CallInUIThreadAndWaitFinishing(
    procedure
    begin
      TAndroidHelper.Activity.getWindow.setStatusBarColor($FF5CC6BA);
    end);
{$ENDIF}
end;

procedure TFrmInicial.Timer1Timer(Sender: TObject);
begin
    Arc1.EndAngle := Arc1.EndAngle + 50;
    if Arc1.EndAngle >= 400 then begin

        tbcPrincipal.ActiveTab := TabHome;
        Timer1.Enabled := false;
    end;

end;

procedure TFrmInicial.FormCreate(Sender: TObject);
begin
    CorBarraTarefas;
    tbcPrincipal.ActiveTab := tabSplash;
    Arc1.StartAngle := 300;
    Arc1.EndAngle   := 0;
    Timer1.Enabled := true;

end;

procedure TFrmInicial.FormSaveState(Sender: TObject);
begin
        Trata_Slides(1);

end;

procedure TFrmInicial.Label4Click(Sender: TObject);
begin
    tbcPrincipal.ActiveTab := tabHome;
end;

procedure TFrmInicial.lbl_proximoClick(Sender: TObject);
var
        slide_atual : integer;
begin

        if Circle1.Fill.Color = $FF5CC6BA then
                slide_atual := 1;
        if Circle2.Fill.Color = $FF5CC6BA then
                slide_atual := 2;
        if Circle3.Fill.Color = $FF5CC6BA then
                slide_atual := 3;

        if slide_atual > 2 then
        begin
                layout_wizard.Visible := false;
                layout_fundo.Visible := true;
        end
        else
                slide_atual := slide_atual + 1;

        Trata_Slides(slide_atual);
end;

procedure TFrmInicial.lbl_voltarClick(Sender: TObject);
var
        slide_atual : integer;
begin
        if Circle1.Fill.Color = $FF5CC6BA then
                slide_atual := 1;
        if Circle2.Fill.Color = $FF5CC6BA then
                slide_atual := 2;
        if Circle3.Fill.Color = $FF5CC6BA then
                slide_atual := 3;

        if slide_atual > 1 then
                slide_atual := slide_atual - 1;


        Trata_Slides(slide_atual);

end;

procedure TFrmInicial.MudarAba(ATabItem: TTabItem; Sender: TObject);
begin
  actMudarAba.Tab := ATabItem;
  actMudarAba.ExecuteTarget(Sender);
end;



procedure TFrmInicial.NotificationCenterReceiveLocalNotification(
  Sender: TObject; ANotification: TNotification);
begin
    if ANotification.Name = 'Validacao' then
        ShowMessage('Insira este código PIN para validar o aplicativo');

end;

procedure TFrmInicial.sbJaTenhoClick(Sender: TObject);
begin
    AbrirForm(TFrmLogin);       //Carrego o próximo form
    MudarAba(tabForms, Sender);  // MUda de Aba

end;

procedure TFrmInicial.sbVerificarClick(Sender: TObject);
begin
    if edtPIN.Text = '653080' then begin
        AbrirForm(TFrmLogin);       //Carrego o próximo form
        MudarAba(tabForms, Sender);  // MUda de Aba
    end else begin
        ShowMessage('PIN inválido!');
        edtPIN.SetFocus;
        edtPIN.SelectAll;
        exit;
    end;




end;

procedure TFrmInicial.SpeedButton1Click(Sender: TObject);
begin
    tbcPrincipal.ActiveTab := TabNovaConta;

end;

procedure TFrmInicial.cbCriarContaClick(Sender: TObject);
begin
    Enviar_Notificacao('Validacao', 'Número PIN', '653080');
    tbcPrincipal.ActiveTab := TabPIN;

end;

procedure TFrmInicial.AbrirForm(AFormClass: TComponentClass);
var
  LayoutBase: TComponent;
begin
  if Assigned(FActiveForm) then
  begin
    if FActiveForm.ClassType = AFormClass then
      exit
    else
    begin
      FActiveForm.DisposeOf; //Não usar FREE
      FActiveForm := nil;
    end;
  end;

  Application.CreateForm(AFormClass, FActiveForm);

  //encontra o Layoutbase no form a ser exibido para adicionar ao frmPrincipal
  LayoutBase := FActiveForm.FindComponent('lytBase');
  if Assigned(LayoutBase) then
    lytPrincipal.AddObject(TLayout(LayoutBase));
end;


procedure TFrmInicial.Trata_Slides(slide : integer);
begin
        with FrmInicial do
        begin
                layout_slide1.Visible := false;
                layout_slide2.Visible := false;
                layout_slide3.Visible := false;
                Circle1.Fill.Color := $FFBDBDBD;
                Circle2.Fill.Color := $FFBDBDBD;
                Circle3.Fill.Color := $FFBDBDBD;
                lbl_voltar.Visible := false;

                if slide = 1 then
                begin
                        layout_slide1.Visible := true;
                        Circle1.Fill.Color := $FF5CC6BA;
                end;
                if slide = 2 then
                begin
                        layout_slide2.Visible := true;
                        Circle2.Fill.Color := $FF5CC6BA;
                        lbl_voltar.Visible := true;
                end;
                if slide = 3 then
                begin
                        layout_slide3.Visible := true;
                        Circle3.Fill.Color := $FF5CC6BA;
                        lbl_voltar.Visible := true;
                end;
        end;
end;




end.
