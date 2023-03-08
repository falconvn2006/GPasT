unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.Platform,

  {$IFDEF ANDROID}
  System.PushNotification, System.Notification
  ,FMX.PushNotification.Android,
  {$ENDIF}

  {$IFDEF IOS}
  FMX.PushNotification.FCM.iOS,
  {$ENDIF}

  FMX.Edit, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts, uDWAbout, uRESTDWProcessThread, FMX.ListBox,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.Ani, FMX.TabControl, FMX.Effects, FMX.WebBrowser


  ;

type
  TFrmPrincipal = class(TForm)
    memLog: TMemo;
    NotificationCenter: TNotificationCenter;
    rectToolbar: TRectangle;
    btnDrawer: TButton;
    btnMenuOpcoes: TButton;
    lytBtnNotificacoes: TLayout;
    pthBtnNotificacoes: TPath;
    circNotificacoes: TCircle;
    lblNotificacoes: TLabel;
    sbBtnNotificacoes: TSpeedButton;
    lytHeader: TLayout;
    ePorta: TEdit;
    eHost: TEdit;
    eConnectionName: TEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    RESTDWClientNotification1: TRESTDWClientNotification;
    StyleBook1: TStyleBook;
    lytConexao: TLayout;
    Label1: TLabel;
    cbRA: TComboBox;
    circlePanico: TCircle;
    sbPanico: TSpeedButton;
    lytBotoes: TLayout;
    img_aba1: TImage;
    img_aba2: TImage;
    img_aba3: TImage;
    img_aba4: TImage;
    TabControl: TTabControl;
    tab01: TTabItem;
    tab02: TTabItem;
    VertAba01: TVertScrollBox;
    tab03: TTabItem;
    tab04: TTabItem;
    Card01: TRectangle;
    ShadowEffect1: TShadowEffect;
    ListBox1: TListBox;
    ListBoxItem5: TListBoxItem;
    Layout1: TLayout;
    Layout2: TLayout;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Image5: TImage;
    rectBackgroundAba01: TRectangle;
    tabCamera: TTabItem;
    VertTab02: TVertScrollBox;
    rectBackgroundTab02: TRectangle;
    rectCam04: TRectangle;
    ShadowEffect2: TShadowEffect;
    Layout3: TLayout;
    Image1: TImage;
    Layout4: TLayout;
    Label2: TLabel;
    rectCam01: TRectangle;
    Layout5: TLayout;
    Image2: TImage;
    Layout6: TLayout;
    Label3: TLabel;
    rectCam02: TRectangle;
    Layout7: TLayout;
    Image3: TImage;
    Layout8: TLayout;
    Label4: TLabel;
    rectCam03: TRectangle;
    Layout9: TLayout;
    Image4: TImage;
    Layout10: TLayout;
    Label8: TLabel;
    Circle1: TCircle;
    Label9: TLabel;
    VertScrollBox2: TVertScrollBox;
    Rectangle2: TRectangle;
    Rectangle4: TRectangle;
    Layout11: TLayout;
    Image7: TImage;
    Layout12: TLayout;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    VertScrollBox3: TVertScrollBox;
    Rectangle3: TRectangle;
    WebBrowser1: TWebBrowser;
    VertScrollBox1: TVertScrollBox;
    rectBackground04: TRectangle;
    lytPerfil: TLayout;
    Label13: TLabel;
    circlePerfil: TCircle;
    Image6: TImage;
    lytNotificacoes: TLayout;
    Label14: TLabel;
    Image8: TImage;
    lytPermissoes: TLayout;
    Label15: TLabel;
    Image9: TImage;
    lytConta: TLayout;
    Label16: TLabel;
    Image10: TImage;
    lytSair: TLayout;
    Label17: TLabel;
    Image11: TImage;
    Label18: TLabel;
    Image12: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure RESTDWClientNotification1Connect(Sender: TObject);
    procedure RESTDWClientNotification1Disconnect(Sender: TObject);
    procedure RESTDWClientNotification1ReceiveMessage(Username,
      aMessage: string; var Accept: Boolean; var ErrorMessage: string);
    procedure sbPanicoTap(Sender: TObject; const Point: TPointF);
    procedure img_aba1Click(Sender: TObject);
    procedure sbPanicoClick(Sender: TObject);
    procedure ListBoxItem1Click(Sender: TObject);
    procedure img_aba2Click(Sender: TObject);
    procedure img_aba3Click(Sender: TObject);
    procedure img_aba4Click(Sender: TObject);
    procedure btnMenuOpcoesClick(Sender: TObject);
    procedure rectCam01Tap(Sender: TObject; const Point: TPointF);
    procedure rectCam02Tap(Sender: TObject; const Point: TPointF);
    procedure rectCam03Tap(Sender: TObject; const Point: TPointF);
    procedure rectCam04Tap(Sender: TObject; const Point: TPointF);
    procedure FormShow(Sender: TObject);
  private
    strToken: string;
    FPushService: TPushService;
    FPushServiceConnection: TPushServiceConnection;
    procedure RegistrarDevice(token: string);
    procedure OnServiceConnectionChange(Sender: TObject;
      PushChanges: TPushService.TChanges);
    procedure OnServiceConnectionReceiveNotification(Sender: TObject;
      const ServiceNotification: TPushServiceNotification);
    procedure LimparNotificacoes;
    function AppEventProc(AAppEvent: TApplicationEvent;
      AContext: TObject): Boolean;
    procedure Conectar;
    procedure EventosNotificacoes;
//    procedure MudarAba(img: TImage);
    //procedure MudarAba(tag: integer);
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

uses Globais;

//procedure TFrmPrincipal.MudarAba(img: TImage);
//begin
//    img_aba1.Opacity := 0.4;
//    img_aba2.Opacity := 0.4;
//    img_aba3.Opacity := 0.4;
//    img_aba4.Opacity := 0.4;
//
//    img.Opacity := 1;
//    TabControl.GotoVisibleTab(img.Tag, TTabTransition.Slide);
//end;

procedure TFrmPrincipal.btnMenuOpcoesClick(Sender: TObject);
begin
    TabControl.ActiveTab := tab01;
end;

procedure TFrmPrincipal.Conectar;
begin
 memLog.Lines.Clear;
 RESTDWClientNotification1.Host := eHost.Text;
 RESTDWClientNotification1.Port := StrToInt(ePorta.Text);
 RESTDWClientNotification1.Connect;
end;

procedure TFrmPrincipal.LimparNotificacoes;
begin
  {$IFDEF ANDROID}
    //NotificationCenter.CancelAll;
  {$ENDIF}
end;

procedure TFrmPrincipal.ListBoxItem1Click(Sender: TObject);
begin

end;

// Recebe notificacoes com o app fechado...
procedure TFrmPrincipal.FormActivate(Sender: TObject);
var
    Notifications : TArray<TPushServiceNotification>;
    x : integer;
    msg : string;
begin
  {$IFDEF ANDROID}
//    Notifications := FPushService.StartupNotifications; // notificacoes que abriram meu app...
//
//    if Length(Notifications) > 0 then
//    begin
//        for x := 0 to Notifications[0].DataObject.Count - 1 do
//        begin
//            memLog.lines.Add(Notifications[0].DataObject.Pairs[x].JsonString.Value + ' = ' +
//                             Notifications[0].DataObject.Pairs[x].JsonValue.Value);
//
//            if Notifications[0].DataObject.Pairs[x].JsonString.Value = 'mensagem' then
//                msg := Notifications[0].DataObject.Pairs[x].JsonValue.Value;
//        end;
//    end;
  {$ENDIF}
end;

function TFrmPrincipal.AppEventProc(AAppEvent: TApplicationEvent; AContext: TObject): Boolean;
begin
    {$IFDEF ANDROID}
//    if (AAppEvent = TApplicationEvent.BecameActive) then
//        LimparNotificacoes;
    {$ENDIF}
end;

procedure TFrmPrincipal.EventosNotificacoes;
var
    AppEvent : IFMXApplicationEventService;
begin
    {$IFDEF ANDROID}

    // Eventos do app (para exclusao das notificacoes)...
    if TPlatformServices.Current.SupportsPlatformService(IFMXApplicationEventService, IInterface(AppEvent)) then
        AppEvent.SetApplicationEventHandler(AppEventProc);

    // Delphi 10.4.2
    FPushService := TPushServiceManager.Instance.GetServiceByName(TPushService.TServiceNames.FCM);

    // Delphi 10.3.3
//    FPushService := TPushServiceManager.Instance.GetServiceByName(TPushService.TServiceNames.GCM);
//    FPushServiceConnection := TPushServiceConnection.Create(FPushService);

    FPushServiceConnection.OnChange := OnServiceConnectionChange;
    FPushServiceConnection.OnReceiveNotification := OnServiceConnectionReceiveNotification;

    FPushServiceConnection.Active := True;

    {$ENDIF}

    Conectar;

end;


procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
    lytHeader.Visible := false;
    memLog.Visible := false;
    lytBtnNotificacoes.Visible := false;

//    EventosNotificacoes;

end;

procedure TFrmPrincipal.FormDestroy(Sender: TObject);
begin
    {$IFDEF ANDROID}
    FPushServiceConnection.Free;
    {$ENDIF}

end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
    img_aba1.Opacity := 0.4;
    img_aba2.Opacity := 0.4;
    img_aba3.Opacity := 0.4;
    img_aba4.Opacity := 0.4;

    img_aba1.Opacity := 1;
    TabControl.ActiveTab := tab01;

end;

procedure TFrmPrincipal.img_aba1Click(Sender: TObject);
begin
//    MudarAba(TImage(Sender));
    img_aba1.Opacity := 0.4;
    img_aba2.Opacity := 0.4;
    img_aba3.Opacity := 0.4;
    img_aba4.Opacity := 0.4;

    img_aba1.Opacity := 1;
    TabControl.ActiveTab := tab01;


end;

procedure TFrmPrincipal.img_aba2Click(Sender: TObject);
begin
    img_aba1.Opacity := 0.4;
    img_aba2.Opacity := 0.4;
    img_aba3.Opacity := 0.4;
    img_aba4.Opacity := 0.4;

    img_aba2.Opacity := 1;
    TabControl.ActiveTab := tab02;


end;

procedure TFrmPrincipal.img_aba3Click(Sender: TObject);
begin
    img_aba1.Opacity := 0.4;
    img_aba2.Opacity := 0.4;
    img_aba3.Opacity := 0.4;
    img_aba4.Opacity := 0.4;

    img_aba3.Opacity := 1;
    TabControl.ActiveTab := tab03;


end;

procedure TFrmPrincipal.img_aba4Click(Sender: TObject);
begin
    img_aba1.Opacity := 0.4;
    img_aba2.Opacity := 0.4;
    img_aba3.Opacity := 0.4;
    img_aba4.Opacity := 0.4;

    img_aba4.Opacity := 1;
    TabControl.ActiveTab := tab04;

end;

procedure TFrmPrincipal.OnServiceConnectionChange(Sender: TObject;
  PushChanges: TPushService.TChanges);
var
    token : string;
begin
    if TPushService.TChange.Status in PushChanges then
    begin
        if FPushService.Status = TPushService.TStatus.Started then
        begin
            memLog.Lines.Add('Serviço de push iniciado com sucesso');
            memLog.Lines.Add('----');
        end
        else
        if FPushService.Status = TPushService.TStatus.StartupError then
        begin
            FPushServiceConnection.Active := False;

            memLog.Lines.Add('Erro ao iniciar serviço de push');
            memLog.Lines.Add(FPushService.StartupError);
            memLog.Lines.Add('----');
        end;
    end;

    if TPushService.TChange.DeviceToken in PushChanges then
    begin
        token := FPushService.DeviceTokenValue[TPushService.TDeviceTokenNames.DeviceToken];
        strToken := token;

//
//        memLog.Lines.Add('Token do aparelho recebido');
//        memLog.Lines.Add('Token: ' + token);
//        memLog.Lines.Add('---');
//        memLog.Lines.EndUpdate;
//
//        RegistrarDevice(token);
    end;
end;

// Recebe notificacoes com o app aberto...
procedure TFrmPrincipal.OnServiceConnectionReceiveNotification(Sender: TObject;
  const ServiceNotification: TPushServiceNotification);
var
    x : integer;
    msg : string;
    MyNotification: TNotification;
begin
    memLog.Lines.Add('Push recebido');
    memLog.Lines.Add('DataKey: ' + ServiceNotification.DataKey);
    memLog.Lines.Add('Json: ' + ServiceNotification.Json.ToString);
    memLog.Lines.Add('DataObject: ' + ServiceNotification.DataObject.ToString);
    memLog.Lines.Add('---');


    for x := 0 to ServiceNotification.DataObject.Count - 1 do
    begin
        memLog.lines.Add(ServiceNotification.DataObject.Pairs[x].JsonString.Value + ' = ' +
                         ServiceNotification.DataObject.Pairs[x].JsonValue.Value);

        if ServiceNotification.DataObject.Pairs[x].JsonString.Value = 'Mensagem' then
                msg := ServiceNotification.DataObject.Pairs[x].JsonValue.Value;
    end;

//    if msg <> '' then
//        showmessage(msg);

    if msg <> '' then
    begin
        showmessage(msg);

        MyNotification := NotificationCenter.CreateNotification;
        Try
            MyNotification.Number :=1;
            MyNotification.AlertBody := msg;
            NotificationCenter.PresentNotification(MyNotification);
        finally
            MyNotification.DisposeOf;
        End;
        memLog.Lines.Add(msg);

    end;


end;

procedure TFrmPrincipal.rectCam01Tap(Sender: TObject; const Point: TPointF);
begin
    WebBrowser1.URL := 'http://localhost:8083/cameras/cam01.png';
    TabControl.ActiveTab := tabCamera;


end;

procedure TFrmPrincipal.rectCam02Tap(Sender: TObject; const Point: TPointF);
begin
    WebBrowser1.URL := 'http://localhost:8083/univesp/pi7/cameras/cam02.png';
    TabControl.ActiveTab := tabCamera;

end;

procedure TFrmPrincipal.rectCam03Tap(Sender: TObject; const Point: TPointF);
begin
    WebBrowser1.URL := 'http://localhost:8083/univesp/pi7/cameras/cam03.png';
    TabControl.ActiveTab := tabCamera;

end;

procedure TFrmPrincipal.rectCam04Tap(Sender: TObject; const Point: TPointF);
begin
    WebBrowser1.URL := 'http://localhost:8083/univesp/pi7/cameras/cam04.png';
    TabControl.ActiveTab := tabCamera;

end;

procedure TFrmPrincipal.RegistrarDevice(token: string);
begin
    // Salvar o token do aparelho na tabela de usuarios do servidor
    // TAB_USUARIO
    //------------------
    // Cod_usuario INT
    // Token_device varchar(100)
end;

procedure TFrmPrincipal.RESTDWClientNotification1Connect(Sender: TObject);
begin
  memLog.Lines.Add('Conectado...');
  eConnectionName.Text := RESTDWClientNotification1.ConnectionName;
end;

procedure TFrmPrincipal.RESTDWClientNotification1Disconnect(Sender: TObject);
begin
    memLog.Lines.Add('Disconectado...');
end;

procedure TFrmPrincipal.RESTDWClientNotification1ReceiveMessage(Username,
  aMessage: string; var Accept: Boolean; var ErrorMessage: string);
var
    MyNotification: TNotification;
Begin
    MyNotification := NotificationCenter.CreateNotification;
    Try
        MyNotification.Number :=1;
        MyNotification.AlertBody := aMessage;
        NotificationCenter.PresentNotification(MyNotification);
    finally
        MyNotification.DisposeOf;
    End;
    memLog.Lines.Add(aMessage);
end;

procedure TFrmPrincipal.sbPanicoClick(Sender: TObject);
begin
//    RESTDWClientNotification1.SendMessage( V_USUARIO  + ' token:' + strToken);
    RESTDWClientNotification1.SendMessage( V_USUARIO  + ' perímetro: ' + 'latitude: -21.027550886620798 longitude: -47.76900890045426');

end;

procedure TFrmPrincipal.sbPanicoTap(Sender: TObject; const Point: TPointF);
begin
  //  RESTDWClientNotification1.SendMessage(cbRA.Items.Strings[cbRA.ItemIndex] + ' token:' + strToken);
end;

end.
