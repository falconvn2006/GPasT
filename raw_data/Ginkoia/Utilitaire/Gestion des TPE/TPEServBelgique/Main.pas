unit Main;

interface

uses
  Windows, Vcl.Controls, System.ImageList, Vcl.ImgList, Vcl.Menus, Vcl.ExtCtrls,
  System.Win.ScktComp, Vcl.StdCtrls, Vcl.ComCtrls, System.Classes, Vcl.Forms,
  uZVTProtocolManager, uCommand, uTPEGinkoiaProtocolManager,
  SysUtils, System.Actions, Vcl.ActnList, ShellAPI, GestionLog;

type
  TTPEAction = (tpeactNone, tpeactRegister, tpeactPayment, tpeactTest,
    tpeactForceRegister);

  TFrm_Main = class(TForm)
    StatusBar1: TStatusBar;
    ServerSocket: TServerSocket;
    Tray: TTrayIcon;
    pm1: TPopupMenu;
    Ouvrir1: TMenuItem;
    N1: TMenuItem;
    Quitter1: TMenuItem;
    pgc: TPageControl;
    tsGeneral: TTabSheet;
    tsParametrage: TTabSheet;
    btn1: TButton;
    pnl1: TPanel;
    label3: TLabel;
    cbPort: TComboBox;
    btn2: TButton;
    label8: TLabel;
    label2: TLabel;
    label5: TLabel;
    label6: TLabel;
    cbVitesse: TComboBox;
    cbDataBits: TComboBox;
    cbParity: TComboBox;
    cbstopBits: TComboBox;
    ParamDef: TButton;
    tsLogs: TTabSheet;
    mmo1: TMemo;
    grp1: TGroupBox;
    grpTPCOMParamsInfo: TGroupBox;
    Paramtrage1: TMenuItem;
    Logs1: TMenuItem;
    il2: TImageList;
    il1: TImageList;
    Label4: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    lbl_gportcom: TLabel;
    lbl_gvitesse: TLabel;
    lbl_gdatabits: TLabel;
    lbl_gparity: TLabel;
    lbl_gstopbit: TLabel;
    lbl_admin: TLabel;
    lbl_gIP: TLabel;
    lbl_gMnt: TLabel;
    lbl_gTypePaiement: TLabel;
    cb_autodetect: TCheckBox;
    edtSearchTPENAME: TEdit;
    BRaf: TButton;
    BalloonHint1: TBalloonHint;
    Label15: TLabel;
    grpTPCOMParamsDef: TGroupBox;
    Label16: TLabel;
    cbFlux: TComboBox;
    lbl_Flux: TLabel;
    Label17: TLabel;
    tsAdmin: TTabSheet;
    GroupBox1: TGroupBox;
    btnOpenPort: TButton;
    btnClosePort: TButton;
    CheckStatusTimer: TTimer;
    ActionList1: TActionList;
    actSendAmount: TAction;
    actRegistration: TAction;
    actOpenPort: TAction;
    actClosePort: TAction;
    ClientSocket1: TClientSocket;
    actTestGinProtocol: TAction;
    actSocketOpen: TAction;
    actSocketClose: TAction;
    GroupBox2: TGroupBox;
    Button2: TButton;
    Button3: TButton;
    Button1: TButton;
    actTPVaCommDefaultParams: TAction;
    actTPVaCommTest: TAction;
    Button4: TButton;
    GroupBox3: TGroupBox;
    lblAmount: TLabel;
    edtAmount: TEdit;
    btnEnvoyer: TButton;
    btnRegistration: TButton;
    GroupBox4: TGroupBox;
    btnGinkoiaCmd: TButton;
    edtGinkoiaCmd: TEdit;
    cbGinkoiaCmd: TComboBox;
    Label1: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    ForceRegistrationTimer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure ServerSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure CheckStatusTimerTimer(Sender: TObject);
    procedure actSendAmountUpdate(Sender: TObject);
    procedure actSendAmountExecute(Sender: TObject);
    procedure actRegistrationUpdate(Sender: TObject);
    procedure actRegistrationExecute(Sender: TObject);
    procedure actOpenPortUpdate(Sender: TObject);
    procedure actOpenPortExecute(Sender: TObject);
    procedure actClosePortUpdate(Sender: TObject);
    procedure actClosePortExecute(Sender: TObject);
    procedure actTestGinProtocolUpdate(Sender: TObject);
    procedure actTestGinProtocolExecute(Sender: TObject);
    procedure actSocketOpenUpdate(Sender: TObject);
    procedure actSocketCloseUpdate(Sender: TObject);
    procedure actSocketOpenExecute(Sender: TObject);
    procedure actSocketCloseExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ClientSocket1Read(Sender: TObject; Socket: TCustomWinSocket);
    procedure ServerSocketClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure BRafClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure cbVitesseChange(Sender: TObject);
    procedure cbDataBitsChange(Sender: TObject);
    procedure cbParityChange(Sender: TObject);
    procedure cbstopBitsChange(Sender: TObject);
    procedure actTPVaCommDefaultParamsExecute(Sender: TObject);
    procedure actTPVaCommTestExecute(Sender: TObject);
    procedure actTPVaCommTestUpdate(Sender: TObject);
    procedure cbPortChange(Sender: TObject);
    procedure Logs1Click(Sender: TObject);
    procedure Ouvrir1Click(Sender: TObject);
    procedure Paramtrage1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Quitter1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure ForceRegistrationTimerTimer(Sender: TObject);
  private
    { Déclarations privées }
    FZVTProtocolManager: TVaCommZVTProtocolManager;
    FTPEGinkoiaProtocolManager: TTPEGinkoiaProtocolManager;

    FCurrentAction: TTPEAction;
    FTestResult: boolean;

    FLastAmount: Double;


    procedure TPEServBelgiqueException(Sender: TObject; E: Exception);

    procedure setAdminMode(AAdmin: boolean);

    procedure RegisterPT(AForce: boolean = False);
    procedure SendAmount(AAMount: Double);

    procedure LoadConfig;
    procedure LoadIni;
    procedure SaveIni;
    procedure RefreshgrpTPCOMParams;
    procedure RefreshgrpTPNUMPORTCOMParams;
    procedure InitPortList;

    procedure AddLog(ALog: string; ALevel: TErrorLevel = el_Info);

    procedure CloseApplication;

    procedure UpdateParametrageComponent;

    procedure ZVTManagerSendCommand(Sender: TObject; ASendCmd: TECRCommand);
    procedure ZVTManagerSendIntermediateCommand(Sender: TObject; ASendCmd: TECRCommand);
    procedure ZVTManagerReceivedCommand(Sender: TObject; ASendCmd: TPTCommand);
    procedure ZVTManagerReceivedIntermediateCommand(Sender: TObject; ASendCmd: TPTCommand);

    procedure ZVTManagerStatusChange(Sender: TObject; ALastStatus, ANewStatus: TZVTManagerStatus);
    procedure ZVTManagerPTSendResponse(Sender: TObject; AResponse: TZVTPTResponse;
      AResponseCode: string; AResponseDescription: string; AResultCmd: TPTCommand);

    procedure ZVTVaCommWriteLog(Sender: TObject; ALog: string);
    procedure ZVTVaCommReadLog(Sender: TObject; ALog: string);

    procedure TPEGinkoiaCheckConnection(Sender: TObject; ACmd: string; AValue: string);
    procedure TPEGinkoiaCBPayment(Sender: TObject; ACmd: string; AValue: string);
    procedure TPEGinkoiaCancel(Sender: TObject; ACmd: string; AValue: string);
    procedure TPEGinkoiaManagerSendCmd(Sender: TObject; ASocket: TCustomWinSocket;
      AText: string);
  public
    { Déclarations publiques }
  end;

var
  Frm_Main  : TFrm_Main;

implementation

Uses
  System.IniFiles, VaComm, Dialogs, uStatusInfoCmd, uCommun, adSelCom;

{$R *.dfm}

procedure TFrm_Main.actClosePortExecute(Sender: TObject);
begin
  try
    FZVTProtocolManager.ClosePort;
  finally
    UpdateParametrageComponent;
  end;
end;

procedure TFrm_Main.actClosePortUpdate(Sender: TObject);
begin
  actClosePort.Enabled := FZVTProtocolManager.PortActive;
end;

procedure TFrm_Main.actOpenPortExecute(Sender: TObject);
begin
  try
    try
      FZVTProtocolManager.OpenPort;
    except
      On E: Exception do
      begin
        Paramtrage1Click(nil);
        AddLog(E.Message, el_Erreur);
        Raise;
      end;
    end;
  finally
    UpdateParametrageComponent;
  end;
end;

procedure TFrm_Main.actOpenPortUpdate(Sender: TObject);
begin
  actOpenPort.Enabled := not FZVTProtocolManager.PortActive;
end;

procedure TFrm_Main.actRegistrationExecute(Sender: TObject);
begin
  RegisterPT;
end;

procedure TFrm_Main.actRegistrationUpdate(Sender: TObject);
begin
  actRegistration.Enabled := FZVTProtocolManager.PortActive;
end;

procedure TFrm_Main.actSendAmountExecute(Sender: TObject);
begin
  SendAmount(StrToFloat(edtAmount.Text));
end;

procedure TFrm_Main.actSendAmountUpdate(Sender: TObject);
begin
  lblAmount.Enabled := FZVTProtocolManager.PortActive;
  edtAmount.Enabled := FZVTProtocolManager.PortActive;
  actSendAmount.Enabled := FZVTProtocolManager.PortActive;
end;

procedure TFrm_Main.actSocketCloseExecute(Sender: TObject);
begin
  ClientSocket1.Close;
end;

procedure TFrm_Main.actSocketCloseUpdate(Sender: TObject);
begin
  actSocketClose.Enabled := ClientSocket1.Active;
end;

procedure TFrm_Main.actSocketOpenExecute(Sender: TObject);
begin
  ClientSocket1.Open;
end;

procedure TFrm_Main.actSocketOpenUpdate(Sender: TObject);
begin
  actSocketOpen.Enabled := not ClientSocket1.Active;
end;

procedure TFrm_Main.actTestGinProtocolExecute(Sender: TObject);
var
  cmd: string;
begin
  case cbGinkoiaCmd.ItemIndex of
    0: cmd := cbGinkoiaCmd.Text;
    1: cmd := cbGinkoiaCmd.Text + edtGinkoiaCmd.Text;
  end;
  ClientSocket1.Socket.SendText(cmd);
  pgc.TabIndex := 2;
end;

procedure TFrm_Main.actTestGinProtocolUpdate(Sender: TObject);
begin
  actTestGinProtocol.enabled := ClientSocket1.Active;
end;

procedure TFrm_Main.actTPVaCommDefaultParamsExecute(Sender: TObject);
begin
  FZVTProtocolManager.VaCommPortNum   := 1;
  FZVTProtocolManager.VaCommBaudrate  := br9600;
  FZVTProtocolManager.VaCommDatabits  := db8;
  FZVTProtocolManager.VaCommParity    := paNone;
  FZVTProtocolManager.VaCommStopbits  := sb2;

  RefreshgrpTPCOMParams;
end;

procedure TFrm_Main.actTPVaCommTestExecute(Sender: TObject);
begin
  try
    FTestResult := False;
    FZVTProtocolManager.OpenPort;
    FCurrentAction := tpeactTest;
    FZVTProtocolManager.Registration;

    while not FTestResult do
    begin
      Application.ProcessMessages;
    end;
  finally
    // On fait une petite pause avant de fermer le port pour laisser
    // le temps au ZVTProtocolManager d'envoyer le ACK qui doit suivre la réponse du PT
    Sleep(1000);
    FZVTProtocolManager.ClosePort;
  end;
end;

procedure TFrm_Main.actTPVaCommTestUpdate(Sender: TObject);
begin
  actTPVaCommTest.Enabled := not FZVTProtocolManager.PortActive;
end;

procedure TFrm_Main.AddLog(ALog: string; ALevel: TErrorLevel);
begin
  mmo1.Lines.Add(FormatDateTime('hh:nn:ss.zzz',Now()) + ' : ' + Alog);
  Log_Write(Alog, ALevel);
end;

procedure TFrm_Main.BRafClick(Sender: TObject);
begin
  try
    Screen.Cursor := crHourGlass;
    InitPortList;
    RefreshgrpTPNUMPORTCOMParams;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TFrm_Main.btn2Click(Sender: TObject);
begin
  ShellExecute(Handle, 'Open', 'mmc', PChar(' devmgmt.msc'), Nil, SW_SHOWDEFAULT);
end;

procedure TFrm_Main.Button1Click(Sender: TObject);
var
  inputstring: string;
begin
//  PostMessage(Handle, InputBoxMessage, 0, 0);
  InputString := InputBox('Mot de passe', 'Veuillez saisir le mot de passe', '');
  setAdminMode(InputString='1082');
end;

procedure TFrm_Main.cbDataBitsChange(Sender: TObject);
begin
  FZVTProtocolManager.VaCommDatabits := TVaDatabits(cbDataBits.ItemIndex);
end;

procedure TFrm_Main.cbParityChange(Sender: TObject);
begin
  FZVTProtocolManager.VaCommParity := TVaParity(cbParity.ItemIndex);
end;

procedure TFrm_Main.cbPortChange(Sender: TObject);
begin
  FZVTProtocolManager.VaCommPortNum := StrToInt(cbPort.Text[1]);
end;

procedure TFrm_Main.cbstopBitsChange(Sender: TObject);
begin
  FZVTProtocolManager.VaCommStopbits := TVaStopbits(cbstopBits.ItemIndex);
end;

procedure TFrm_Main.cbVitesseChange(Sender: TObject);
begin
  FZVTProtocolManager.VaCommBaudrate := TVaBaudrate(cbVitesse.ItemIndex);
end;

procedure TFrm_Main.ForceRegistrationTimerTimer(Sender: TObject);
begin
  ForceRegistrationTimer.Enabled := False;
  SendAmount(FLastAmount);
end;

procedure TFrm_Main.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  // Minimize application instead of closing
  CanClose := False;
  Self.Hide;
end;

procedure TFrm_Main.FormCreate(Sender: TObject);
var
  logpath: string;
begin
  FCurrentAction := tpeactNone;

  AddLog('Démarrage du TPEServ belgique');

  Application.OnException := TPEServBelgiqueException;

  logpath := ExtractFilePath(ParamStr(0));
  if logpath[Length(logpath)] <> '\' then
    logpath := logpath + '\';
  logpath := logpath + 'LOG_TPE\';
  Log_Init(el_Debug, logpath);

  InitPortList;

  FZVTProtocolManager := TVaCommZVTProtocolManager.Create;

  FZVTProtocolManager.onSendCmd := ZVTManagerSendCommand;
  FZVTProtocolManager.onSendIntermediateCmd := ZVTManagerSendIntermediateCommand;
  FZVTProtocolManager.onReceivedCmd := ZVTManagerReceivedCommand;
  FZVTProtocolManager.onReceivedIntermediateCmd := ZVTManagerReceivedIntermediateCommand;
  FZVTProtocolManager.OnStatusChange := ZVTManagerStatusChange;
  FZVTProtocolManager.onPTSendReponse := ZVTManagerPTSendResponse;

  FZVTProtocolManager.OnLogVaCommWriteEvent := ZVTVaCommWriteLog;
  FZVTProtocolManager.onLogRxCharEvent := ZVTVaCommReadLog;

  FTPEGinkoiaProtocolManager := TTPEGinkoiaProtocolManager.Create;
  FTPEGinkoiaProtocolManager.OnCheckConnection := TPEGinkoiaCheckConnection;
  FTPEGinkoiaProtocolManager.onSendCmdEvent := TPEGinkoiaManagerSendCmd;
  FTPEGinkoiaProtocolManager.OnCBPayment := TPEGinkoiaCBPayment;

  LoadConfig;

  ServerSocket.Open;
  actOpenPortExecute(self);
end;

procedure TFrm_Main.FormDestroy(Sender: TObject);
begin
  AddLog('Arret du TPEServ belgique');

  ServerSocket.Close;

  SaveIni;

  FZVTProtocolManager.ClosePort;
  FreeAndNil(FZVTProtocolManager);
  FreeAndNil(FTPEGinkoiaProtocolManager);
end;

procedure TFrm_Main.InitPortList;
var
  i, j: integer;
  portlist: TStringList;

  bFound: boolean;
begin
  portlist := Get_Serial_Ports;

  cbPort.Items.Clear;
  cbPort.Items.BeginUpdate;
  try
    cbPort.Items.Clear;
    for i := 1 to 64 do
    begin
      if IsPortAvailable(i) then
      begin
        bFound:=false;
        for j := 0 to portlist.Count - 1 do
        begin
          if AnsiPos(Format('(COM%d)', [i]), portlist[j]) > 1 then
          begin
            cbPort.Items.Add(Format('%d - %s',[i, portlist[j]]));
            bFound:=true;
          end;
        end;
        if not(bFound) then
          cbPort.Items.Add(Format('%d - ',[i]));
      end;
    end;
  finally
    cbPort.Items.EndUpdate;
    portlist.DisposeOf;
  end;
end;

procedure TFrm_Main.LoadConfig;
begin
  LoadIni;
  RefreshgrpTPCOMParams;
end;

procedure TFrm_Main.LoadIni;
var
  path: string;
  conf: TIniFile;
begin
  path := ChangeFileExt(Application.ExeName, '.ini');

  if FileExists(path) then
  begin
    conf := TIniFile.Create(path);
    try
      FZVTProtocolManager.VaCommPortNum   := conf.ReadInteger('PortCOM', 'PortNum',   1);
      FZVTProtocolManager.VaCommBaudrate  := TVaBaudrate(conf.ReadInteger('PortCOM', 'Baudrate',  6));
      FZVTProtocolManager.VaCommDatabits  := TVaDatabits(conf.ReadInteger('PortCOM', 'DataBites', 3));
      FZVTProtocolManager.VaCommParity    := TVaParity(conf.ReadInteger('PortCOM', 'Parity',    0));
      FZVTProtocolManager.VaCommStopbits  := TVaStopbits(conf.ReadInteger('PortCOM', 'StopBits',  2));

      ServerSocket.Port                   := conf.ReadInteger('Serveur', 'Port', 31324);

//      CommunicationPortCom.AutoDetectUSB := FicIni.ReadBool('PortCom', 'AutoDetect', CommunicationPortCom.AutoDetectUSB);
//      CommunicationPortCom.Flux := FicIni.Readinteger('PortCom', 'Flux', CommunicationPortCom.Flux);
//      CommunicationPortCom.SearchTPEName := FicIni.ReadString('PortCom', 'SearchTPENAME', CommunicationPortCom.SearchTPEName);

    finally
      FreeAndNil(conf);
    end;
  end;
end;

procedure TFrm_Main.Logs1Click(Sender: TObject);
begin
  pgc.ActivePage:=tsLogs;
  Application.Restore;
  Application.BringToFront;
  Self.Show;
end;

procedure TFrm_Main.Ouvrir1Click(Sender: TObject);
begin
  pgc.ActivePage := tsGeneral;
  Application.Restore;
  Application.BringToFront;
  Self.Show;
end;

procedure TFrm_Main.Paramtrage1Click(Sender: TObject);
begin
  pgc.ActivePage := tsParametrage;
  Application.Restore;
  Application.BringToFront;
  Self.Show;
end;

procedure TFrm_Main.Quitter1Click(Sender: TObject);
begin
  CloseApplication;
end;

procedure TFrm_Main.RefreshgrpTPCOMParams;
var
  i: integer;
begin
  if Assigned(FZVTProtocolManager) then
  begin
    case FZVTProtocolManager.VaCommBaudrate of
      brUser: ;
      br110:    cbVitesse.ItemIndex := 0;
      br300:    cbVitesse.ItemIndex := 1;
      br600:    cbVitesse.ItemIndex := 2;
      br1200:   cbVitesse.ItemIndex := 3;
      br2400:   cbVitesse.ItemIndex := 4;
      br4800:   cbVitesse.ItemIndex := 5;
      br9600:   cbVitesse.ItemIndex := 6;
      br14400:  cbVitesse.ItemIndex := 7;
      br19200:  cbVitesse.ItemIndex := 8;
      br38400:  cbVitesse.ItemIndex := 9;
      br56000:  cbVitesse.ItemIndex := 10;
      br57600:  cbVitesse.ItemIndex := 11;
      br115200: cbVitesse.ItemIndex := 12;
      br128000: cbVitesse.ItemIndex := 13;
      br256000: cbVitesse.ItemIndex := 14;
    end;
    lbl_gvitesse.Caption := cbVitesse.Text;

    case FZVTProtocolManager.VaCommDatabits of
      db4: ;
      db5: cbDataBits.ItemIndex := 0;
      db6: cbDataBits.ItemIndex := 1;
      db7: cbDataBits.ItemIndex := 2;
      db8: cbDataBits.ItemIndex := 3;
    end;
    lbl_gdatabits.Caption := cbDataBits.Text;

    case FZVTProtocolManager.VaCommParity of
      paNone:   cbParity.ItemIndex := 0;
      paOdd:    cbParity.ItemIndex := 1;
      paEven:   cbParity.ItemIndex := 2;
      paMark:   cbParity.ItemIndex := 3;
      paSpace:  cbParity.ItemIndex := 4;
    end;
    lbl_gparity.Caption := cbParity.Text;

    case FZVTProtocolManager.VaCommStopbits of
      sb1:  cbstopBits.ItemIndex := 0;
      sb15: cbstopBits.ItemIndex := 1;
      sb2:  cbstopBits.ItemIndex := 2;
    end;
    lbl_gstopbit.Caption := cbstopBits.Text;

    RefreshgrpTPNUMPORTCOMParams;
  end;
end;

procedure TFrm_Main.RefreshgrpTPNUMPORTCOMParams;
var
  i: integer;
begin
  lbl_gportcom.Caption := IntToStr(FZVTProtocolManager.VaCommPortNum);

  for i := 0 to cbPort.Items.Count - 1 do
  begin
    if AnsiPos(Format('%d - ', [FZVTProtocolManager.VaCommPortNum]), cbPort.Items[i]) = 1 then
      cbPort.ItemIndex  := i;
  end;
end;

procedure TFrm_Main.RegisterPT(AForce: boolean);
begin
  if not FZVTProtocolManager.PortActive then
  begin
    FTPEGinkoiaProtocolManager.SendCheckConnectionFailed;
  end
  else
  begin
    if AForce then
      FCurrentAction := tpeactForceRegister
    else
      FCurrentAction := tpeactRegister;
    FZVTProtocolManager.Registration;

    StatusBar1.Panels[1].Text := 'Registration';
    StatusBar1.Panels[2].Text := '';
  end;
end;

procedure TFrm_Main.SaveIni;
var
  path: string;
  conf: TIniFile;
begin
  path := ChangeFileExt(Application.ExeName, '.ini');

  conf := TIniFile.Create(path);
  try
    conf.WriteInteger('PortCOM', 'PortNum',   FZVTProtocolManager.VaCommPortNum);
    conf.WriteInteger('PortCOM', 'Baudrate',  Integer(FZVTProtocolManager.VaCommBaudrate));
    conf.WriteInteger('PortCOM', 'DataBites', Integer(FZVTProtocolManager.VaCommDatabits));
    conf.WriteInteger('PortCOM', 'Parity',    Integer(FZVTProtocolManager.VaCommParity));
    conf.WriteInteger('PortCOM', 'StopBits',  Integer(FZVTProtocolManager.VaCommStopbits));

    conf.ReadInteger('Serveur', 'Port', ServerSocket.Port);

//      CommunicationPortCom.AutoDetectUSB := FicIni.ReadBool('PortCom', 'AutoDetect', CommunicationPortCom.AutoDetectUSB);
//      CommunicationPortCom.Flux := FicIni.Readinteger('PortCom', 'Flux', CommunicationPortCom.Flux);
//      CommunicationPortCom.SearchTPEName := FicIni.ReadString('PortCom', 'SearchTPENAME', CommunicationPortCom.SearchTPEName);

  finally
    FreeAndNil(conf);
  end;
end;

procedure TFrm_Main.SendAmount(AAMount: Double);
begin
  if not FZVTProtocolManager.PortActive then
  begin
    FTPEGinkoiaProtocolManager.SendCheckConnectionFailed;
  end
  else
  begin
    FCurrentAction := tpeactPayment;
    FLastAmount := AAmount;

    try
      FZVTProtocolManager.Authorization(AAmount);
    except
      On E: Exception do
      begin
        AddLog(E.Message, el_Erreur);
        FTPEGinkoiaProtocolManager.SendPaymentFailed;
      end;
    end;

    StatusBar1.Panels[1].Text := 'Payment';
    StatusBar1.Panels[2].Text := '';
  end;
end;

procedure TFrm_Main.ServerSocketClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  lbl_gIP.Caption := Socket.RemoteAddress;
  lbl_gMnt.Caption := 'En attente de montant';
end;

procedure TFrm_Main.ServerSocketClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  command: string;
  log: string;
begin
  if FZVTProtocolManager.Status <> zvtmsECRMaster then
    FTPEGinkoiaProtocolManager.SendBusy(Socket);

  command := Socket.ReceiveText;
  AddLog('GIN > ' + command);
  FTPEGinkoiaProtocolManager.ParseTPEGinkoiaCommand(Socket, command);
end;

procedure TFrm_Main.setAdminMode(AAdmin: boolean);
begin
  tsAdmin.TabVisible := AAdmin;
  lbl_admin.Visible := AAdmin;
end;

procedure TFrm_Main.TPEGinkoiaCancel(Sender: TObject; ACmd, AValue: string);
begin
  //TODO voir ce qu'on fait
end;

procedure TFrm_Main.TPEGinkoiaCBPayment(Sender: TObject; ACmd: string; AValue: string);
begin
  lbl_gMnt.Caption := AValue;
  AValue := AValue.Replace('.', ',');
  SendAmount(StrToFloat(AValue));
end;

procedure TFrm_Main.TPEGinkoiaCheckConnection(Sender: TObject; ACmd,
  AValue: string);
begin
  RegisterPT;
end;

procedure TFrm_Main.TPEGinkoiaManagerSendCmd(Sender: TObject;
  ASocket: TCustomWinSocket; AText: string);
var
  i: integer;

  function HideCardNumber(ACardNumber: string): string;
  var
    j: integer;
  begin
    Result := '';
    for j := 0 to Length(ACardNumber) do
    begin
      if ACardNumber[i] <> ' ' then
        Result := Result + 'x'
      else
        Result := Result + ' ';
    end;
  end;

begin
  if Assigned(ASocket) then
  begin
    if pos('OK;B;', AText) <> 0 then
      AddLog('GIN < ' + Copy(AText, 0, 5) + HideCardNumber(Copy(AText, 6, length(AText))))
    else
      AddLog('GIN < ' + AText);
    try
      ASocket.SendText(AText);
    except
      //TODO a changer mais pour le moment quand on force une commande au PT qui
      //n'a pas été demandé par Ginkoia on a une acces violation.
      //donc la on l'ignore
    end;
  end;
end;

procedure TFrm_Main.TPEServBelgiqueException(Sender: TObject; E: Exception);
begin
  AddLog(E.Message);
  if (E is TECRNotMasterException) or (E is TUnknownCmdException) then
  begin
    //TODO pour le moment on affoche pas ces deux types d'exception voir a mieux gérer
    // c'est cas la.
  end
  else
  begin
    Application.ShowException(E);
  end;
end;

procedure TFrm_Main.UpdateParametrageComponent;
begin
  // On peut modifier le parametrage que si la connection au TP au fermé

  label3.Enabled :=     not FZVTProtocolManager.PortActive;
  cbPort.Enabled :=     not FZVTProtocolManager.PortActive;
  BRaf.Enabled :=       not FZVTProtocolManager.PortActive;

  label8.Enabled :=     not FZVTProtocolManager.PortActive;
  cbVitesse.Enabled :=  not FZVTProtocolManager.PortActive;
  label2.Enabled :=     not FZVTProtocolManager.PortActive;
  cbDataBits.Enabled := not FZVTProtocolManager.PortActive;
  label5.Enabled :=     not FZVTProtocolManager.PortActive;
  cbParity.Enabled :=   not FZVTProtocolManager.PortActive;
  label6.Enabled :=     not FZVTProtocolManager.PortActive;
  cbstopBits.Enabled := not FZVTProtocolManager.PortActive;
  label16.Enabled :=    not FZVTProtocolManager.PortActive;
  cbFlux.Enabled :=     not FZVTProtocolManager.PortActive;
end;

procedure TFrm_Main.CheckStatusTimerTimer(Sender: TObject);
begin
  if FZVTProtocolManager.PortActive then
    StatusBar1.Panels[0].Text := 'Connecté'
  else
    StatusBar1.Panels[0].Text := 'Non connecté';
end;

procedure TFrm_Main.ClientSocket1Read(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  AddLog(Format('TEST : GIN < %s', [Socket.ReceiveText]));
end;

procedure TFrm_Main.CloseApplication;
var
  quit: boolean;
begin
  quit := True;
  if FZVTProtocolManager.Status <> zvtmsECRMaster then
    quit := MessageDlg('Une opéation sur le TP est en cours.' + #10#13 +
        'Est-vous sur de vouloir quitter ?', mtConfirmation, mbYesNo, 0) =  IDYES;

  if quit then
    Application.Terminate;
end;

procedure TFrm_Main.ZVTManagerPTSendResponse(Sender: TObject;
  AResponse: TZVTPTResponse; AResponseCode, AResponseDescription: string;
  AResultCmd: TPTCommand);
begin
  case AResponse of
    zvtptrSuccess:
    begin
      case FCurrentAction of
        tpeactNone: ;
        tpeactRegister: FTPEGinkoiaProtocolManager.SendCheckConnectionSucced;
        tpeactPayment:
        begin
          if (AResultCmd is TStatusInfoCmd) then
            FTPEGinkoiaProtocolManager.SendPaymentSucced((AResultCmd as TStatusInfoCmd).getCardNumber);
        end;
        tpeactTest:
        begin
          FTestResult := True;
          ShowMessage(Format('Test Success : (%s) %s', [AResponseCode, AResponseDescription]));
        end;
        tpeactForceRegister:
        begin
          ForceRegistrationTimer.Enabled := True;
        end;
      end;

      StatusBar1.Panels[2].Text := 'Succès';
    end;
    zvtptrError:
    begin
      case FCurrentAction of
        tpeactNone: ;
        tpeactRegister: FTPEGinkoiaProtocolManager.SendCheckConnectionFailed;
        tpeactPayment:
        begin
          if AResponseCode = '83' then
          begin
            RegisterPT(True);
          end
          else
            FTPEGinkoiaProtocolManager.SendPaymentFailed;
        end;
        tpeactTest:
        begin
          FTestResult := True;
          ShowMessage(Format('Test Error : (%s) %s', [AResponseCode, AResponseDescription]));
        end;
        tpeactForceRegister:
        begin
          FTPEGinkoiaProtocolManager.SendCheckConnectionFailed;
        end;
      end;

      StatusBar1.Panels[2].Text := 'Erreur';
    end;
    zvtptrTimeOut:
    begin
      case FCurrentAction of
        tpeactNone: ;
        tpeactRegister: FTPEGinkoiaProtocolManager.SendTimeOut;
        tpeactPayment: FTPEGinkoiaProtocolManager.SendTimeOut;
        tpeactTest:
        begin
          FTestResult := True;
          ShowMessage('Test Error : TimeOut');
        end;
      end;
    end;
  end;
  StatusBar1.Panels[1].Text := Format('(%s) %s', [AResponseCode, AResponseDescription]);

  if FCurrentAction <> tpeactForceRegister then
    FCurrentAction := tpeactNone;
end;

procedure TFrm_Main.ZVTManagerReceivedCommand(Sender: TObject;
  ASendCmd: TPTCommand);
begin
  AddLog('PT < ' + ASendCmd.asString);
  StatusBar1.Panels[3].Text := ASendCmd.asString;
end;

procedure TFrm_Main.ZVTManagerReceivedIntermediateCommand(Sender: TObject;
  ASendCmd: TPTCommand);
begin
  AddLog('PT << ' + ASendCmd.asString);
  FTPEGinkoiaProtocolManager.SendIntermediateStatus(ASendCmd.CmdResultCode,
    ASendCmd.CmdResultDescr);
end;

procedure TFrm_Main.ZVTManagerSendCommand(Sender: TObject;
  ASendCmd: TECRCommand);
begin
  AddLog('ECR > ' + ASendCmd.asString);
  StatusBar1.Panels[3].Text := ASendCmd.asString;
end;

procedure TFrm_Main.ZVTManagerSendIntermediateCommand(Sender: TObject;
  ASendCmd: TECRCommand);
begin
  AddLog('ECR >> ' + ASendCmd.asString);
end;

procedure TFrm_Main.ZVTManagerStatusChange(Sender: TObject; ALastStatus,
  ANewStatus: TZVTManagerStatus);
begin
end;

procedure TFrm_Main.ZVTVaCommReadLog(Sender: TObject; ALog: string);
begin
  AddLog('<- ' + ALog, el_Debug);
end;

procedure TFrm_Main.ZVTVaCommWriteLog(Sender: TObject; ALog: string);
begin
  AddLog('-> ' + ALog, el_Debug);
end;

end.
