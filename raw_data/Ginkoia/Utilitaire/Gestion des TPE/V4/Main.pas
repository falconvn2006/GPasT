unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, OoMisc, AdPort, AdSelCom,
  Vcl.ComCtrls, AdPacket, Data.DB, Datasnap.DBClient, Datasnap.Win.MConnect,
  Datasnap.Win.SConnect, IdContext, IdBaseComponent, IdComponent,
  IdCustomTCPServer, IdTCPServer, AdWnPort, System.Win.ScktComp, Vcl.ExtCtrls,
  Vcl.Menus, Vcl.AppEvnts,Winapi.ShellAPI, Vcl.Buttons,GestionLog, Generics.Collections,
  Vcl.Imaging.pngimage, System.ImageList, Vcl.ImgList, VaClasses, VaComm,
  IdTCPConnection, IdTCPClient,System.UITypes, VaConfigDialog, VaPrSt;

const
   InputBoxMessage   = WM_USER + 200;
   WM_AUTODETECTUSB  = WM_USER + 201;
   WM_CLOSEPORTCOM   = WM_USER + 202;

type
  TTimerThread = class(TThread)
  private
    FTickEvent: THandle;
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: Boolean);
    destructor Destroy; override;
    procedure FinishThreadExecution;
  end;

  TTypePaiement = (TpCB,TpCheque);
  TEtatMaitre  = (EMNone,EMInit,EMInitOk,EMSend,EMSendOk,EMClose);
  TEtatEsclave = (EENone,EEEcoute,EEAttenteLRC);
  TCollision   = (ColNone,ColCas1);
  TProtocoleVersion = (V2E,V2EPlus,V3);

  TCommunicationPortCom  = class
    private
      FPortComNumero : Integer;
      FVitesse       : integer;
      FStopBits      : string;
      FDataBits      : integer;
      FParity        : Word;
      FFlux          : Word;
      FAutoDetectUSB : boolean;
      FSearchTPEName : string;
    public
      property PortComNumero : integer read FPortComNumero write FPortComNumero;
      property Parity        : Word    read FParity        write FParity;
      property Vitesse       : Integer read FVitesse       write FVitesse;
      property StopBits      : string  read FStopBits      write FStopBits;
      property DataBits      : Integer read FDataBits      write FDataBits;
      property Flux          : Word    read FFlux          write FFlux;
      property AutoDetectUSB : Boolean read FAutoDetectUSB write FAutoDetectUSB;
      property SearchTPEName : string  read FSearchTPEName write FSearchTPEName;
  end;
  {
  TCaisse = class
    private
      FID       : integer;
      FRemoteIP : string;
    public
     property ID       : integer   read FID       write FID;
     property RemoteIP : string    read FremoteIP write FRemoteIP;
   end;
  }
  TTag = packed record
     ID     : string[2];  // 2 premiers caractères Position 1-2
     Lenght : integer;    // Position 3-4-5
     Data   : string;     //
  end;
  TTags = array of TTag;


  TTransaction  = class
    private
      FRemoteAddress    : string;
      FmontantCaisse    : Currency;
      FTrameRecuTPE     : string;
      FOrdreCaisse      : Boolean;
      FTypePaiement     : TTypePaiement;
      FProtocoleVersion : TProtocoleVersion;
      //----------------- Nouvelles variable v3
      FTags : TTags;
      function Fnc_ReponseCaisse():string;
      function Fnc_DecodeTrameTPE_V3(aTrame:string):string;
    published
       property ProtocoleVersion : TProtocoleVersion read FProtocoleVersion write FProtocoleVersion;
       property TypePaiement     : TTypePaiement read FTypePaiement     write FTypePaiement;
       property OrdreCaisse      : Boolean       read FOrdreCaisse      write FOrdreCaisse;
       property RemoteAddress    : string        read FRemoteAddress    write FRemoteAddress;
       property MontantCaisse    : Currency      read FmontantCaisse    write FmontantCaisse;
       property TrameRecuTPE     : string        read FTrameRecuTPE     write FTrameRecuTPE;
       property ReponseCaisse    : string        read Fnc_ReponseCaisse;
   end;
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
    label1: TLabel;
    edt1: TEdit;
    btnEnvoyer: TButton;
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
    grp2: TGroupBox;
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
    Button1: TButton;
    lbl_gIP: TLabel;
    lbl_gMnt: TLabel;
    lbl_gTypePaiement: TLabel;
    cb_autodetect: TCheckBox;
    edtSearchTPENAME: TEdit;
    BRaf: TButton;
    BalloonHint1: TBalloonHint;
    Label15: TLabel;
    GroupBox1: TGroupBox;
    VaComm1: TVaComm;
    pm_NoPopup: TPopupMenu;
    Label16: TLabel;
    cbFlux: TComboBox;
    lbl_Flux: TLabel;
    Label17: TLabel;
    rg_ProtocoleVersion: TRadioGroup;
    Label18: TLabel;
    lbl_gProtocoleVersion: TLabel;
    procedure btnEnvoyerClick(Sender: TObject);
    procedure ComPortOpen(Sender: TObject);
    procedure ComPortClose(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure ServerSocketClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocketClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure edt1Change(Sender: TObject);
    procedure TrayDblClick(Sender: TObject);
    procedure Quitter1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ApplicationEvents1Minimize(Sender: TObject);
    procedure TrayClick(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ParamDefClick(Sender: TObject);
    procedure cbParamsChange(Sender: TObject);
    procedure edt1KeyPress(Sender: TObject; var Key: Char);
    procedure btn5Click(Sender: TObject);
    procedure Logs1Click(Sender: TObject);
    procedure Paramtrage1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure BRafClick(Sender: TObject);
    procedure cb_autodetectClick(Sender: TObject);
    procedure VaComm1RxChar(Sender: TObject; Count: Integer);
    procedure Button2Click(Sender: TObject);
    procedure rg_ProtocoleVersionClick(Sender: TObject);
  private
     myFormatSettings: TFormatSettings;
     FLoading    : boolean;
     FSaving     : Boolean;
//     S:string;
     FBusy       : boolean;
     FLRC        : integer;
     FBuffer     : string;
     EtatMaitre  : TEtatMaitre;
     EtatEsclave : TEtatEsclave;
//     CRTrig      : word;
     FTransaction : TTransaction;
     Collision    : TCollision;

     FCommunicationPortCom : TCommunicationPortCom;
     FTimerThread : TTimerThread;
     FComOpenedStart : Cardinal;
     //     FCaisses : TObjectList<TCaisse>;
     Fcaisses  : TStringList;
     FAdmin      : Boolean;

     FErrorUSB   : Boolean;
     FErrorCOM   : Boolean;

     procedure RestartThisApp;
     procedure ParamEcran;

     procedure DoPauseMs(ms:integer);
     procedure ListPortCom();
     procedure LoadIni();
     procedure SaveIni();
     procedure PortOpenClose(CP : TObject; Opened : Boolean);
     function CalculLRC(aStr:string):integer;
     procedure Maitre_Init();
     procedure Maitre_SendMontant(aMnt:double);
     procedure Maitre_Close();
     procedure Maitre_EOT();  // Se passe lorsque on arrive pas a joudre le TPE

     procedure Repondre_Ack();
     procedure Repondre_NAck();
     procedure CalculFLRC();
     function PrintBufferLog(aString:string):string;
     function DoSendToTPE():Boolean;
     procedure SetBusy(aValue:Boolean);
     procedure SetAdmin(aValue:Boolean);

     function SetComParity():TVaParity;
     function SetComDataBits():TVaDataBits;
     function SetComBaudRate():TVaBaudrate;
     function SetComStopBits():TVaStopBits;
     procedure SetComFlowControl();

     procedure DoClosePortCom(var M:TMessage); message WM_CLOSEPORTCOM;
     procedure Action_Quitter();

     //  dialogs avec la caisse
     function DoSendToCaissePresence():Boolean;
     function DoSendToCaisseInsererCarte():Boolean;
     function DoSendToCaisseInCommunication(aNumero:integer):Boolean;
     function DoSendToCaisseBUSY():Boolean;
     function DoSendToCaisseTIMEOUT():Boolean;
     function DoSendToCaisseERRCOM(aNumero:integer):Boolean;
     function DoSendToCaisseCollision():Boolean;

     procedure  Auto_Detection();
     procedure  Com_ParamsChange();
      procedure DoAutoDetectUSB(var M:TMessage);  message WM_AUTODETECTUSB;
     function Repondre_Caisse():Boolean;
//     procedure Kill_Liaison_TPE;
     procedure TraceLog(aLog:string;aLevel:TErrorLevel);
     procedure InputBoxSetPasswordChar(var Msg: TMessage); message InputBoxMessage;
    { Déclarations privées }

      //  procedure DefaultHandler(var Msg); override;
      procedure WndProc(var Message: TMessage); override;

  protected
      procedure WMDeviceChange(var M:TMessage); message WM_DEVICECHANGE;


  public
    { Déclarations publiques }
    property ComOpenedStart : Cardinal     Read FComOpenedStart write FComOpenedStart;
    property Buffer         : string       read FBuffer         write FBuffer;
    property Busy           : boolean      read FBusy           write SetBusy;
    property Admin          : Boolean      read FAdmin          write SetAdmin;
    property Transaction    : TTransaction read FTransaction    write FTransaction;
    property CommunicationPortCom : TCommunicationPortCom read FCommunicationPortCom write FCommunicationPortCom;
    property ErrorUSB       : boolean      read FErrorUSB      write FErrorUSB;
    property ErrorCOM       : boolean      read FErrorCOM      write FErrorCOM;

  end;

var
  Frm_Main  : TFrm_Main;
  MsgQuit   : Cardinal;
  HandleAppliExt : THandle;
  HandleRecepteur: THandle;

implementation

Uses System.IniFiles, Uversion, UCommun;

{$R *.dfm}

{ TTimerThread }


constructor TTimerThread.Create(CreateSuspended: Boolean);
begin
  inherited;
  FreeOnTerminate := True;
  FTickEvent := CreateEvent(nil, True, False, nil);
end;

destructor TTimerThread.Destroy;
begin
  CloseHandle(FTickEvent);
  inherited;
end;

procedure TTimerThread.FinishThreadExecution;
begin
  SetEvent(FTickEvent);
  Terminate;
end;

procedure TTimerThread.Execute;
var vElapse:cardinal;
begin
  while not Terminated do
  begin
    if WaitForSingleObject(FTickEvent, 1000) = WAIT_TIMEOUT then
    begin
      Synchronize(procedure
        begin
          vElapse := GetTickCount - Frm_Main.ComOpenedStart;
          Frm_Main.StatusBar1.Panels[1].Text:=Format('%d',[vElapse div 1000]);
        end
      );
    end;
  end;
end;


function TTransaction.Fnc_ReponseCaisse():string;
var vREP        : string;
    vNUMCAISSE  : string;
    vSTAT       : string;
    vMnt        : string;
    vMode       : string;
    vDEV        : string;
    vPRIV       : string;
begin
   result := '';
   if TrameRecuTPE='' then exit;

   Case Self.ProtocoleVersion of
     V2E,V2EPlus:
      begin
      if Length(TrameRecuTPE)>50 then
          begin
              vNUMCAISSE  := Copy(TrameRecuTPE,2,2);
              vSTAT       := Copy(TrameRecuTPE,4,1);
              vMnt        := Copy(TrameRecuTPE,5,8);
              vMode       := Copy(TrameRecuTPE,13,1);
              vREP        := Trim(Copy(TrameRecuTPE,14,55));
              vDEV        := Copy(TrameRecuTPE,69,3);
              vPRIV       := Copy(TrameRecuTPE,72,10);
              If vStat='0' then
                 begin
                   If TypePaiement=TpCB     then result := Format('OK;B;%s',[vREP]);
                   If TypePaiement=TpCheque then result := Format('OK;C;%s',[vREP]);
                 end
              else result:='REFUS';
          end;
      end;
    V3:
       begin
          result := Self.Fnc_DecodeTrameTPE_V3(Copy(TrameRecuTPE,2,Length(TrameRecuTPE)-2));
       end;
   End;
end;

function TTransaction.Fnc_DecodeTrameTPE_V3(aTrame:string):string;
var vTemp : string;
    vTag : TTag;
    vEndOfString : boolean;
//    vLenght : integer;
//    vTagID : string;
//    vData  : string;
    i : integer;
    vIsOk : Boolean;
    vCF : string;
begin
   result:='REFUS';
   // il faut faire des splits...
   // les 5 premiers après aller jusqu'à la fin de la longueur
   // TTLLLDDDDDDDDD
   vTemp := aTrame;
   vEndOfString := false;
   SetLength(Self.FTags,0);
   while not(vEndOfString) do
    begin
      vTag.ID     := Copy(vTemp,1,2);
      vTag.Lenght := StrToIntDef(Copy(vTemp,3,3),0);
      vTag.Data   := Copy(vTemp,6,vTag.Lenght);
      vTemp        := Copy(vTemp,6+vTag.Lenght,Length(vTemp));
      //-------------------------------------
      i := Length(Self.FTags);
      SetLength(Self.FTags,i+1);
      Self.FTags[i] := vTag;
      vEndOfString := Length(vTemp)<5;
    end;
  // --------------------------------------------------------------------------
  vIsOk := false;
  vCF   := '';
  for i := Low(Self.FTags) to High(Self.FTags) do
    begin
        if (Self.FTags[i].ID='CF')
          then vCF := Self.FTags[i].Data;
        If (Self.FTags[i].ID='AE') and (Self.FTags[i].Data='10')
          then vIsOk := true;



    end;
  if vIsOk and (vCF<>'') then
    begin
        If TypePaiement=TpCB     then result := Format('OK;B;%s',[vCF]);
        If TypePaiement=TpCheque then result := Format('OK;C;%s',[vCF]);
    end;
end;

procedure TFrm_Main.DoPauseMs(ms:integer);
var vTimerNow,vTimerStart:Cardinal;
begin
    vTimerStart := GetTickCount;
    vTimerNow   := GetTickCount;
    while ((vTimerNow-vTimerStart)<ms) do
       begin
         vTimerNow:=GetTickCount;
         Application.ProcessMessages;
       end;
end;


procedure TFrm_Main.TraceLog(aLog:string;aLevel:TErrorLevel);
begin
     // Tracage uniquement du Debug... en Debug
     if aLevel=el_Debug then
       begin
        {$IFDEF DEBUG}
           Mmo1.Lines.Add(FormatDateTime('hh:nn:ss.zzz',Now()) + ' ' + aLog);
           Log_Write(aLog, aLevel);
        {$ENDIF}
       end
     else
      begin
         Mmo1.Lines.Add(FormatDateTime('hh:nn:ss.zzz',Now()) + ' ' + aLog);
         Log_Write(aLog, aLevel);
      end;
   StatusBar1.Panels[2].Text := Format('%d',[ServerSocket.Socket.ActiveConnections]);
end;

procedure TFrm_Main.InputBoxSetPasswordChar(var Msg: TMessage);
var
   hInputForm, hEdit, hButton: HWND;
begin
   hInputForm := Screen.Forms[0].Handle;
   if (hInputForm <> 0) then
   begin
     hEdit := FindWindowEx(hInputForm, 0, 'TEdit', nil);
     {
       // Change button text:
       hButton := FindWindowEx(hInputForm, 0, 'TButton', nil);
       SendMessage(hButton, WM_SETTEXT, 0, Integer(PChar('Cancel')));
     }
     SendMessage(hEdit, EM_SETPASSWORDCHAR, Ord('*'), 0);
   end;
end;

procedure TFrm_Main.SetAdmin(aValue:Boolean);
begin
    FAdmin:=aValue;
    Lbl_Admin.Visible:=aValue;

end;

procedure TFrm_Main.DoAUTODETECTUSB(var M:TMessage);
begin
    Auto_Detection;
end;

procedure TFrm_Main.WMDeviceChange(var M:TMessage);
const DBT_DEVNODES_CHANGED = $0007;      // Changement sur les USB
begin
  //  inherited;
  if (EtatMaitre<>EMNone) and (EtatEsclave<>EENone)
    then TraceLog('WMDeviceChange',el_Erreur)
    else TraceLog('WMDeviceChange',el_Warning);

  case M.wParam of
    DBT_DEVNODES_CHANGED:
        begin
            TraceLog('DBT_DEVNODES_CHANGED',el_Info);
            // Chaque auto detection peut provoquer une erreur USB...
            ErrorUSB:=true;
            PostMessage(handle, WM_AUTODETECTUSB, 0, 0);
            Sleep(1000);
        end;
  end;
end;

procedure  TFrm_Main.Auto_Detection();
var i:integer;
    TPE_port:string;
//    bfind:Boolean;
    sNumPort : string;
    iNumPort : integer;
    mText    : string;
begin
    if not(cb_autodetect.Checked) then exit;
    TraceLog('Auto_Detection',el_Debug);
    // On memorise sont ItempIndex
    mText  := cbPort.Text;
    Tray.Animate:=false;

    // uniquement en mode Autodétection !!
    if cb_autodetect.Checked then
      begin
          // Listage des port COM
          if not(FLoading) then ListPortCom;
          iNumPort := -1;
          // On cherche le Nom dans WMI
          try
            TPE_port:=Auto_Detect_TPE(edtSearchTPENAME.Text);
//            bfind:=false;
            for i := 0 to cbPort.Items.Count-1 do
              begin
                  if AnsiPos(Format('(%s)',[TPE_port]),cbPort.Items.Strings[i])>1 then
                    begin
                        // théoriquement c'est le bon n° de port
                        sNumPort := Copy(TPE_port,4,length(TPE_port));
                        iNumPort := StrToIntDef(sNumPort,0);
                        cbPort.ItemIndex  := i;
                        Tray.IconIndex    := 0;
                        // Si changement de Port Com on enregistre...
                        // -----------------------------------------------------
                        if (mText<>cbPort.Items[i]) then
                           Com_ParamsChange();
                        // -----------------------------------------------------
                    end;
              end;
            if iNumPort=-1 then
              begin
                 Tray.Animate     := true;
                 cbPort.ItemIndex  := -1; // Pas trouvé !
              end;
          finally

          end;
      end;
   FLoading:=false;
end;



procedure TFrm_Main.SetBusy(aValue:Boolean);
begin
    FBusy:=aValue;
    //
    edt1.enabled       := not(Avalue) and FAdmin;
    btnEnvoyer.enabled := not(Avalue) and FAdmin;

    cbPort.enabled     := not(Avalue);
    cbVitesse.Enabled  := not(Avalue);
    cbDataBits.Enabled := not(Avalue);
    cbParity.Enabled   := not(Avalue);
    cbstopBits.Enabled := not(Avalue);
    cbFlux.Enabled     := not(Avalue);

    cb_autodetect.Enabled    := not(AValue);
    edtSearchTPENAME.Enabled := not(Avalue);

    rg_ProtocoleVersion.Enabled := not(AValue);

    ParamDef.Enabled   := not(Avalue);

    lbl_gProtocoleVersion.Caption := rg_ProtocoleVersion.Items[rg_ProtocoleVersion.ItemIndex];

    lbl_gportcom.Caption   := IntToStr(CommunicationPortCom.PortComNumero);
    lbl_gvitesse.Caption   := cbVitesse.Text;
    lbl_gdatabits.Caption  := cbDataBits.text;
    lbl_gparity.Caption    := cbParity.Text;
    lbl_gStopBit.Caption   := cbstopBits.Text;
    lbl_Flux.Caption       := cbFlux.Text + #13+#10 +
                            Format('DTR : %d',[Integer(VaComm1.FlowControl.ControlDtr)]) + #13+#10 +
                            Format('RTS : %d',[Integer(VaComm1.FlowControl.ControlRts)]) + #13+#10 +

                            Format('DsrSensib : %d',[Integer(VaComm1.FlowControl.DsrSensitivity)]) + #13+#10 +
                            Format('OutCts : %d',[Integer(VaComm1.FlowControl.OutCtsFlow)]) + #13+#10 +
                            Format('OutDsr : %d',[Integer(VaComm1.FlowControl.OutDsrFlow)]) + #13+#10 +

                            Format('TxCOnXOff : %d',[Integer(VaComm1.FlowControl.TxContinueOnXoff)]) + #13+#10 +
                            Format('XOnXOffIn : %d',[Integer(VaComm1.FlowControl.XonXoffIn)]) + #13+#10 +
                            Format('XOnXOffOut : %d',[Integer(VaComm1.FlowControl.XonXoffOut)]) + #13+#10 ;
                            // TODO mettre tous les paramètres associés au Flux

end;

procedure TFrm_Main.RestartThisApp;
begin
//  ShellExecute(Handle, nil, PChar(Application.ExeName), nil, nil, SW_SHOWNORMAL);
//  Application.Terminate;
end;

procedure TFrm_Main.DoClosePortCom(var M: TMessage);
var iStart, iStop: DWORD;
begin
  iStart := GetTickCount;
  Application.processmessages;
  repeat
    iStop := GetTickCount;
    Application.ProcessMessages;
    Sleep(1);
  until (iStop - iStart) >= 100;
  VaComm1.Close;
end;

procedure TFrm_Main.CalculFLRC();
begin
  FLRC:=CalculLRC(Buffer);
end;

procedure TFrm_Main.LoadIni();
var sFic    : string;
    FicIni  : TIniFile;
//    sLigne  : string;
    // OSinfos  :TOSInfos;
begin
  TraceLog('LoadIni',el_Info);
  FCommunicationPortCom.PortComNumero := 1;               // N° de port COM
  FCommunicationPortCom.Vitesse       := 9600;
  FCommunicationPortCom.StopBits      := '1';             // 0=1 1=1.5 2=2
  FCommunicationPortCom.DataBits      := 7;
  FCommunicationPortCom.Parity        := 1;               // 0=Aucun  1=Pair etc...
  FCommunicationPortCom.FFlux         := 0;
  FCommunicationPortCom.AutoDetectUSB := false;
  FCommunicationPortCom.SearchTPEName := 'SAGEM';

  sFic := ChangeFileExt(Application.ExeName, '.ini');
  if FileExists(sFic) then begin
    FicIni:=TIniFile.Create(sFic);
    try
      CommunicationPortCom.PortComNumero := FicIni.ReadInteger('PortCOM', 'NumPort', CommunicationPortCom.PortComNumero);
      TraceLog(Format('Port N° : %d',[CommunicationPortCom.PortComNumero]),el_Info);
      CommunicationPortCom.Vitesse       := FicIni.ReadInteger('PortCOM', 'Vitesse', CommunicationPortCom.Vitesse);
      TraceLog(Format('Vitesse : %d',[CommunicationPortCom.Vitesse]),el_Info);
      CommunicationPortCom.DataBits      := FicIni.ReadInteger('PortCOM', 'Bits',  CommunicationPortCom.DataBits);
      TraceLog(Format('Bits : %d',[CommunicationPortCom.DataBits]),el_Info);
      CommunicationPortCom.StopBits      := FicIni.ReadString('PortCOM', 'Arret', CommunicationPortCom.StopBits);
      TraceLog(Format('Stop : %s',[CommunicationPortCom.StopBits]),el_Info);
      CommunicationPortCom.Parity        := FicIni.ReadInteger('PortCOM','Parite',CommunicationPortCom.Parity );
      TraceLog(Format('Parité : %d',[CommunicationPortCom.Parity]),el_Info);
      CommunicationPortCom.AutoDetectUSB := FicIni.ReadBool('PortCom', 'AutoDetect', CommunicationPortCom.AutoDetectUSB);
      TraceLog(Format('Flux : %d',[CommunicationPortCom.Flux]),el_Info);
      CommunicationPortCom.Flux := FicIni.Readinteger('PortCom', 'Flux', CommunicationPortCom.Flux);
      TraceLog(Format('AutoDetection : %s',[BoolToStr(CommunicationPortCom.AutoDetectUSB,true)]),el_Info);
      CommunicationPortCom.SearchTPEName := FicIni.ReadString('PortCom', 'SearchTPENAME', CommunicationPortCom.SearchTPEName);
      TraceLog(Format('SearchTPEName : %s',[CommunicationPortCom.SearchTPEName]),el_Info);
      ServerSocket.Port                  := FicIni.ReadInteger('Serveur', 'Port', 31324);
      TraceLog(Format('ServerSocketPort : %d',[ServerSocket.Port]),el_Info);


      If FicIni.ReadString('Protocole','Version','')='V2E'
         then Transaction.ProtocoleVersion := V2E;
      If FicIni.ReadString('Protocole','Version','')='V2E+'
         then Transaction.ProtocoleVersion := V2EPlus;

      If FicIni.ReadString('Protocole','Version','')='V3'
         then Transaction.ProtocoleVersion := V3;

      rg_ProtocoleVersion.ItemIndex := Ord(Transaction.ProtocoleVersion);

      TraceLog(Format('ProtocoleVersion : %s',[rg_ProtocoleVersion.Items[Ord(Transaction.ProtocoleVersion)]]),el_Info);

    finally
      FreeAndNil(FicIni);
    end;
  end;

end;

{
procedure TFrm_Main.VaComm1RxChar(Sender: TObject; Count: Integer);
var i:integer;
    C:AnsiChar;
    BufferRx : array[0..65535] of byte;
begin
    // Réponse du TPE
    if Count<=0 then exit;
    //  TraceLog('<-- #' + VaComm1.ReadText,el_Debug);
    VaComm1.ReadBuf(BufferRx,Count);
    for i:=0 to Count-1 do
        begin
        try
          C:=AnsiChar(BufferRx[i]);
          TraceLog('<-- #' + IntToStr(Ord(C)),el_Debug);
          TraceLog('Etat Maitre  : ' + IntTOStr(Ord(EtatMaitre)),el_Debug);
          TraceLog('Etat Esclave : ' + IntToStr(Ord(EtatEsclave)),el_Debug);
          // il considère qu'il est maitre... mais pas nous
          // Ici Normalement nous somme dans une trame NACK, ENQ EOT, ENQ EOT, ENQ EOT
          // il initie un dialogue....#5 (ENQ)
          // on va donc se basculer en esclave
          if (EtatMaitre<>EMNone) and (C=#5) then
              begin
                Repondre_ACK();
                EtatMaitre  := EMNone;
                EtatEsclave := EEEcoute;
              end;

          // Nous somme en Maitre
          if (EtatMaitre<>EMNone) and (EtatEsclave=EENone) then
              begin
                  // ACK
                  if (C = #6) then
                       begin
                          TraceLog('<-- #6 (ACK) ',el_Info);
                          if (EtatMaitre=EMInit)
                            then
                              begin
                                EtatMaitre:=EMInitOK;
                              end;
                          if (EtatMaitre=EMSend)
                            then
                              begin
                                EtatMaitre:=EMSendOK;
                              end
                       end
                    else
                      begin
                        TraceLog('<-- # + ' + Chr(Ord(C)),el_Info);
                      end;
              end;
          // Nous somme en Esclave
          if (EtatMaitre=EMNone) and (EtatEsclave<>EENone) then
              begin
                  Buffer:=Buffer+C;
                  if (EtatEsclave=EEEcoute) and (C = #2)
                    then
                      begin
                         TraceLog('<-- #2 (STX)',el_Debug);
                        DoSendToCaisseInCommunication(96);
                      end;

                  if (EtatEsclave=EEEcoute) and (C = #5)
                    then
                      begin
                        TraceLog('<-- #5 (ENQ)',el_Debug);
                        Repondre_ACK;
                        // Nettoyage du Buffer
                        FBuffer:='';
                        continue;
                      end;

                  if (EtatEsclave=EEEcoute) and (C = #4)
                    then
                      begin
                        TraceLog('<-- #4 (EOT)',el_Info);
                        FBuffer:='';
                        EtatEsclave:=EENone;
                        // Fermeture du Port...
                        FBusy:=true;
                        TraceLog('Ordre de Fermerture du Port Com donné à Windows',el_Info);
                        // VaComm1.Close;
                        Application.ProcessMessages;
                        PostMessage(Handle, WM_CLOSEPORTCOM, 0, 0);
                        // On passe
                        Repondre_Caisse;
                        continue;
                      end;

                  if (C=#3) and (EtatEsclave<>EEAttenteLRC) // Oui il ne faut pas être en attente du LRC ici
                    // Car ca arrive parfois que le LRC=#3 dans ce cas il ne faut pas passer ici
                    then
                    begin
                       TraceLog('<-- ' + PrintBufferLog(Buffer),el_Info);
                       // Désormais nous ne sommes plus en écoute mais en Attente du caractère de contrôle
                       EtatEsclave:=EEAttenteLRC;
                       CalculFLRC();
                       TraceLog('Calcul LRC #' + IntToStr(FLRC),el_Info);
                       // On continue parce que sinon on pourrait passer dans la suite..
                       continue;
                       // il manque encore le check c'est le prochain caractère
                    end;
                  // Si en attente du LRC
                  if EtatEsclave=EEAttenteLRC then
                    begin
                       if (Ord(C)=FLRC)
                         then
                            begin
                                TraceLog('<-- LRC ' + Format('#%d',[Ord(C)]),el_Info);
                                TraceLog('Check LRC OK',el_Info);
                                Transaction.TrameRecuTPE:=FBuffer;
                                TraceLog('Buffer = ' + Transaction.TrameRecuTPE,el_Debug);
                                FBuffer:='';
                                // on repasse en écoute.. jusqu'au EOT
                                EtatEsclave:=EEEcoute;
                                // Repondre_Caisse;
                                // Attention nous sommes en de communication...
                                // en fait on attends la fermeture du port com...
                                DoSendToCaisseInCommunication(94);
                                Repondre_ACK;
                            end
                         else
                            begin
                                TraceLog(Format('#%d',[Ord(C)]),el_Info);
                            end
                    end;

              end;
        except On E:Exception do
          begin
            // TraceLog(Format('#%d',[Ord(C)]),el_Info);
          end;
        end;
        end;
end;
}

procedure TFrm_Main.Logs1Click(Sender: TObject);
begin
  ParamEcran;
  pgc.ActivePage:=tsLogs;
  Application.Restore;
  Application.BringToFront;
  Self.Show;
end;

procedure TFrm_Main.ComPortClose(Sender: TObject);
begin

   StatusBar1.Panels[0].Text:='Fermé';
   TraceLog('Port Com Fermé',el_Info);
   FTimerThread.FinishThreadExecution;
   Busy:=false;

   lbl_gIP.Caption               := '';
   lbl_gMnt.Caption              := '';
   lbl_gTypePaiement.Caption     := '';

end;

procedure TFrm_Main.ComPortOpen(Sender: TObject);
var iStart, iStop: DWORD;
begin
  StatusBar1.Panels[0].Text:='Ouvert';
  TraceLog('Port Com Ouvert',el_Info);
  FComOpenedStart := GetTickCount;
  // Init de la Collision à tout va bien
  Collision       := ColNone;

  // 30ms pour continuer...
  iStart:= GetTickCount;
  Application.processmessages;
  repeat
    iStop := GetTickCount;
    Application.ProcessMessages;
    Sleep(1);
  until (iStop - iStart) >= 30;

  FTimerThread := TTimerThread.Create(False);
  Busy:=true;
end;

function TFrm_Main.PrintBufferLog(aString:string):string;
var i:integer;
begin
    result:='';
    for i:=1 to Length(AString) do
      begin
        case Astring[i] of
          #2  : result:=result + 'STX ';
          #3  : result:=result + 'ETX ';
          #4  : result:=result + 'EOT ';
          #5  : result:=result + 'ENQ ';
          #6  : result:=result + 'ACK ';
          #21 : result:=result + 'NAK ';
          else
            result:=result + aString[i];
        end;
      end;
end;

procedure TFrm_Main.Quitter1Click(Sender: TObject);
begin
   Action_Quitter();
end;


procedure TFrm_Main.Action_Quitter();
begin
    try
      TraceLog('Quitter>>Fin du Programme',el_Info);
      // ApdComPort1.Open:=false;
      VaComm1.Close;
      if assigned(Fcaisses)
        then FCaisses.DisposeOf;
      if Assigned(Transaction)
        then Transaction.DisposeOf;
      if Assigned(CommunicationPortCom)
        then CommunicationPortCom.DisposeOf;
    finally
      Application.Terminate;
    end;
end;

procedure TFrm_Main.Repondre_NACK;
begin
    // ApdComPort1.PutChar(#21);
    VaComm1.WriteChar(#21);
    TraceLog('--> #21 (NAK)',el_Info);
end;

function TFrm_Main.DoSendTOCaissePresence():Boolean;
var i:integer;
begin
    result:=false;
    try
      // Est-ce que le port com est valable ?
      if IsPortAvailable(CommunicationPortCom.PortComNumero)
        then
            begin
                for i := 0 to ServerSocket.Socket.ActiveConnections-1 do
                  begin
                    if ServerSocket.Socket.Connections[i].RemoteAddress= Transaction.RemoteAddress then
                       begin
                           ServerSocket.Socket.Connections[i].SendText('OK;PRESENCE');
                           TraceLog('Réponse à la caisse : OK;PRESENCE',El_Info);
                           Break;
                       end;
                  end;
            result:=true;
            end;
    except
      result:=false;
    end;
end;


// Nouvelle Erreur TPE .... Mauvais Dialogue entre le TPESevr et le TPE...

function TFrm_Main.DoSendToCaisseCollision():Boolean;
var i:integer;
begin
    try
      for i := 0 to ServerSocket.Socket.ActiveConnections-1 do
        begin
          if ServerSocket.Socket.Connections[i].RemoteAddress= Transaction.RemoteAddress then
             begin
                 ServerSocket.Socket.Connections[i].SendText('TIMEOUT');
                 TraceLog('Reponse à la caisse : TIMEOUT (Collision CAS1)',el_Info);
                 Break;
             end;
        end;
      // Busy:=False;
      // ApdComPort1.open:=false;
      result:=true;
    except
      result:=false;
    end;
end;


function TFrm_Main.DoSendToCaisseBUSY():Boolean;
var i:integer;
begin
    try
      for i := 0 to ServerSocket.Socket.ActiveConnections-1 do
        begin
          if ServerSocket.Socket.Connections[i].RemoteAddress= Transaction.RemoteAddress then
             begin
                 ServerSocket.Socket.Connections[i].SendText('OCCUPE');
                 TraceLog('Reponse à la caisse : OCCUPE',el_Info);
                 Break;
             end;
        end;
      // Busy:=False;
      // ApdComPort1.open:=false;
      result:=true;
    except
      result:=false;
    end;
end;

function TFrm_Main.DoSendToCaisseERRCOM(aNumero:integer):Boolean;
var i:integer;
begin
    try
      for i := 0 to ServerSocket.Socket.ActiveConnections-1 do
        begin
          if ServerSocket.Socket.Connections[i].RemoteAddress= Transaction.RemoteAddress then
             begin
                 ServerSocket.Socket.Connections[i].SendText(Format('ERR;COM;%d',[aNumero]));
                 TraceLog('Reponse à la caisse : Erreur Port COM',el_Info);
                 Break;
             end;
        end;
      // Busy:=False;
      // ApdComPort1.open:=false;
      result:=true;
    except
      result:=false;
    end;
end;


function TFrm_Main.DoSendToCaisseTIMEOUT():Boolean;
var i:integer;
begin
    try
      for i := 0 to ServerSocket.Socket.ActiveConnections-1 do
        begin
          if ServerSocket.Socket.Connections[i].RemoteAddress= Transaction.RemoteAddress then
             begin
                 ServerSocket.Socket.Connections[i].SendText('TIMEOUT');
                 TraceLog('Réponse à la caisse : TIMEOUT',el_Info);
                 Break
             end;
        end;
      Busy:=False;
      // On ferme le port com car c'est une erreur de COM....
      // ApdComPort1.open:=false;
      VaComm1.Close;
      // on ferme le port Com il faut mettre l'état de Maitre à None
      EtatMaitre := EMNone;
      result:=true;
    except
      result:=false;
    end;
end;

function TFrm_Main.DoSendToCaisseInsererCarte():Boolean;
var i:integer;
begin
    try
      for i := 0 to ServerSocket.Socket.ActiveConnections-1 do
        begin
          if ServerSocket.Socket.Connections[i].RemoteAddress= Transaction.RemoteAddress then
             begin
                 ServerSocket.Socket.Connections[i].SendText('ENCOURS;97');
                 TraceLog('Réponse à la caisse : ENCOURS;97',el_Info);
                 Break
             end;
        end;
      result:=true;
    except
         result:=false;
    end;
end;


function TFrm_Main.DoSendToCaisseInCommunication(aNumero:Integer):Boolean;
var i:integer;
begin
    try
      for i := 0 to ServerSocket.Socket.ActiveConnections-1 do
        begin
          if ServerSocket.Socket.Connections[i].RemoteAddress= Transaction.RemoteAddress then
             begin
                 ServerSocket.Socket.Connections[i].SendText(Format('ENCOURS;%d',[aNumero]));
                 TraceLog('Reponse à la caisse : ' + Format('ENCOURS;%d',[aNumero]),el_Info);
                 Break
             end;
        end;
      result:=true;
    except
         result:=false;
    end;
end;


procedure TFrm_Main.ServerSocketClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
var i:integer;
begin
    TraceLog('Dialog Caisse/ClientConect',el_Info);
end;

procedure TFrm_Main.ServerSocketClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var vRcv: string;
    vMnt: string;
begin
    vRcv := Copy(Socket.ReceiveText,0,15);
    TraceLog('Dialog Caisse <-- ' + vRcv, el_Info);
    If vRcv='' then Exit;
    Transaction.OrdreCaisse   := false;
    Transaction.RemoteAddress := Socket.RemoteAddress;
    lbl_gIP.Caption           := Transaction.RemoteAddress;
    lbl_gMnt.Caption          := '';
    lbl_gTypePaiement.Caption := '';
    lbl_gProtocoleVersion.Caption := '';

    // Si la transaction est déjà en cours... ca veux dire éventuellement plusieurs caisses ....

    if (Busy) then DoSendToCaisseBUSY;
    if (vRcv = '>TPE') then // demande présence TPE
      begin
        Transaction.MontantCaisse := 0.0;
        Transaction.TrameRecuTPE  := '';
        Transaction.TypePaiement  := TpCB;
        DoSendToCaissePresence;
        exit;
      end;
    if (Pos( '>MT;' , vRcv)=1) then  // demande débit CB
      begin
        vMnt := Copy(vRcv, Pos(';', vRcv)+1, Length(vRcv));
        if Pos(',', vMnt)>0 then
          vMnt[Pos(',', vMnt)] := FormatSettings.DecimalSeparator;
        if Pos('.', vMnt)>0 then
          vMnt[Pos('.', vMnt)] := FormatSettings.DecimalSeparator;
        Transaction.MontantCaisse := StrToFloatDef(vMnt, 0.0);

        // GR : 17/06/2016
        // Permet de ne pas répondre à la caisse l'ancienne trame en cas de problème !
        // DEBUT
        Transaction.TrameRecuTPE  := '';
        // FIN

        Edt1.Text          := FloatToStr(Transaction.MontantCaisse);
        lbl_gMnt.Caption   := Edt1.Text;

        Transaction.TypePaiement  := TpCB;
        lbl_gTypePaiement.Caption := 'Carte Bleue';
        Transaction.OrdreCaisse   := true;

        if Transaction.MontantCaisse<=0.01 then exit;
        btnEnvoyer.Click();
        exit;
      end;
    if (Pos('>CHQ;', vRcv)=1) then  // demande débit CB
      begin
        vMnt := Copy(vRcv, Pos(';', vRcv)+1, Length(vRcv));
        if Pos(',', vMnt)>0 then
          vMnt[Pos(',', vMnt)] := FormatSettings.DecimalSeparator;
        if Pos('.', vMnt)>0 then
          vMnt[Pos('.', vMnt)] := FormatSettings.DecimalSeparator;

        Transaction.TypePaiement  := TpCheque;
        lbl_gTypePaiement.Caption := 'Chèque';

        Transaction.MontantCaisse := StrToFloatDef(vMnt, 0.0);
        Edt1.Text:=FloatToStr(Transaction.MontantCaisse);
        lbl_gMnt.Caption   := Edt1.Text;

        Transaction.OrdreCaisse := true;

        if Transaction.MontantCaisse<=0.01 then exit;

        btnEnvoyer.Click();
        exit;
      end;
    // demande de Quitter l'application servira peut-etre un jour...
    if (Pos('>QUIT;',vRcv)=1) then
      begin
        TraceLog('>QUIT;',el_Info);
        Action_Quitter;
      end;

end;

procedure TFrm_Main.TrayClick(Sender: TObject);
begin
  ParamEcran;
  Application.Restore;
  Application.BringToFront;
  Self.Show;
end;

procedure TFrm_Main.TrayDblClick(Sender: TObject);
begin
  pgc.ActivePage:=tsGeneral;
  ParamEcran;
  Application.Restore;
  Application.BringToFront;
  Self.Show;
end;

procedure TFrm_Main.VaComm1RxChar(Sender: TObject; Count: Integer);
var i:integer;
    C:AnsiChar;
    BufferRx : array[0..1024] of byte;

    tmp_log: string;
begin
    if Count<=0 then exit;
    VaComm1.ReadBuf(BufferRx,Count);

    tmp_log := '';
    for i := 0 to Count - 1 do
    begin
      tmp_log := tmp_log + AnsiChar(BufferRx[i]);
    end;

    TraceLog(format('<<<< %s', [PrintBufferLog(tmp_log)]), el_Info);

    for i:=0 to Count-1 do
        begin
        try
          C:=AnsiChar(BufferRx[i]);
          TraceLog('<-- #' + IntToStr(Ord(C)),el_Debug);
          TraceLog('Etat Maitre  : ' + IntTOStr(Ord(EtatMaitre)),el_Debug);
          TraceLog('Etat Esclave : ' + IntToStr(Ord(EtatEsclave)),el_Debug);
          // il considère qu'il est maitre... mais pas nous
          // Ici Normalement nous somme dans une trame NACK, ENQ EOT, ENQ EOT, ENQ EOT
          // il initie un dialogue....#5 (ENQ)
          // on va donc se basculer en esclave
          if (EtatMaitre<>EMNone) and ( (C=#5) and (AnsiChar(BufferRx[i + 1]) <> #4) ) then
              begin
                // Nous sommes en Collision CAS1
                Collision   := ColCas1;

                TraceLog('Dialogue confus entre TPEServ et TPE :',el_Erreur);
                TraceLog('Etat Maitre  : ' + IntTOStr(Ord(EtatMaitre)),el_Erreur);
                TraceLog('Etat Esclave : ' + IntToStr(Ord(EtatEsclave)),el_Erreur);
                // Est-ce que cela sert à quelquechose de répondre ACK ?
                Repondre_ACK();
                // On passe en Esclave.... mais on met le flag COLLISION = Dialogue Confus
                EtatMaitre  := EMNone;
                EtatEsclave := EEEcoute;

              end;

          // Nous somme en Maitre
          if (EtatMaitre<>EMNone) and (EtatEsclave=EENone) then
              begin
                  // ACK
                  if (C = #6) then
                       begin
                          TraceLog('<-- #6 (ACK) ',el_Info);
                          if (EtatMaitre=EMInit)
                            then
                              begin
                                EtatMaitre:=EMInitOK;
                              end;
                          if (EtatMaitre=EMSend)
                            then
                              begin
                                EtatMaitre:=EMSendOK;
                              end
                       end
                    else
                      begin
                        TraceLog(Format('<-- #%d ',[Ord(C)]),el_Erreur);
                      end;
              end;
          // Nous somme en Esclave
          if (EtatMaitre=EMNone) and (EtatEsclave<>EENone) then
              begin
                  Buffer:=Buffer+C;
                  if (EtatEsclave=EEEcoute) and (C = #2)
                    then
                      begin
                         TraceLog('<-- #2 (STX)',el_Debug);
                         DoSendToCaisseInCommunication(96);
                      end;

                  if (EtatEsclave=EEEcoute) and (C = #5)
                    then
                      begin
                        TraceLog('<-- #5 (ENQ)',el_Info);
                        // GR:2016-06-23 : Ajout d'une pause d'un ms (au moins) avant de repondre ACK
                        // DoPauseMs(1);
                        // GR:2020-03-02 : Le temps de retournement au moins 10ms
                        DoPauseMs(10);
                        // ----------
                        Repondre_ACK;
                        // Nettoyage du Buffer
                        FBuffer:='';
                        continue;
                      end;

                  if (EtatEsclave=EEEcoute) and (C = #4)
                    then
                      begin
                        TraceLog('<-- #4 (EOT)',el_Info);
                        FBuffer:='';
                        EtatEsclave:=EENone;
                        // Fermeture du Port...
                        FBusy:=true;
                        TraceLog('Ordre de Fermerture du Port Com donné à Windows',el_Info);
                        // La transaction est passée entièrement (refus ou pas... peu importe)
                        // Mais ce qui compte c'est que le dialogue avec le TPE est a nouveau correcte
                        // les deux vaiables erreur USB et com repassent à False
                        FErrorUSB := false;
                        FErrorCOM := false;

                        // VaComm1.Close;
                        Application.ProcessMessages;
                        PostMessage(Handle, WM_CLOSEPORTCOM, 0, 0);

                        // Si Collision
                        Case Collision of
                          ColCas1 :
                                begin
                                    TraceLog('Collision Cas 1',el_Info);
                                    DoSendToCaisseCollision();
                                end;

                          // Sinon tout va bien...
                          else Repondre_Caisse;
                        End;

                        continue;
                      end;

                  if (C=#3) and (EtatEsclave<>EEAttenteLRC) // Oui il ne faut pas être en attente du LRC ici
                    // Car ca arrive parfois que le LRC=#3 dans ce cas il ne faut pas passer ici
                    then
                    begin
                       TraceLog('<-- ' + PrintBufferLog(Buffer),el_Info);
                       // Désormais nous ne sommes plus en écoute mais en Attente du caractère de contrôle
                       EtatEsclave:=EEAttenteLRC;
                       CalculFLRC();
                       TraceLog('Calcul LRC #' + IntToStr(FLRC),el_Info);
                       // On continue parce que sinon on pourrait passer dans la suite..
                       continue;
                       // il manque encore le check c'est le prochain caractère
                    end;
                  // Si en attente du LRC
                  if EtatEsclave=EEAttenteLRC then
                    begin
                       if (Ord(C)=FLRC)
                         then
                            begin
                                TraceLog('<-- LRC ' + Format('#%d',[Ord(C)]),el_Info);
                                TraceLog('Check LRC OK',el_Info);
                                Transaction.TrameRecuTPE:=FBuffer;
                                TraceLog('Buffer = ' + Transaction.TrameRecuTPE,el_Debug);
                                FBuffer:='';
                                // on repasse en écoute.. jusqu'au EOT
                                EtatEsclave:=EEEcoute;
                                // Repondre_Caisse;
                                // Attention nous sommes en de communication...
                                // en fait on attends la fermeture du port com...
                                DoSendToCaisseInCommunication(94);
                                // GR : 2016-06-23 : faire une pause d'une ms au moins avant de répondre ACK
                                //DoPauseMs(1);
                                // GR:2020-03-02 : Le temps de retournement au moins 10ms
                                DoPauseMs(10);
                                //
                                Repondre_ACK;
                            end
                         else
                            begin
                                TraceLog(Format('#%d',[Ord(C)]),el_Info);
                            end
                    end;

              end;
        except On E:Exception do
          begin
            // TraceLog(Format('#%d',[Ord(C)]),el_Info);
          end;
        end;
    end;

end;

function TFrm_Main.Repondre_Caisse():Boolean;
var vReponse : string;
    i        : integer;
begin
    try
      vReponse := Transaction.Fnc_ReponseCaisse();
      for i := 0 to ServerSocket.Socket.ActiveConnections-1 do
        begin
          if ServerSocket.Socket.Connections[i].RemoteAddress = Transaction.RemoteAddress then
             begin
                 ServerSocket.Socket.Connections[i].SendText(vReponse);
                 TraceLog('Reponse à la caisse : ' + vReponse, el_Info);
                 Break
             end;
        end;
     // Edt1.Enabled:=true;
     // btnEnvoyer.Enabled:=true;
     result:=true;
    except
      result:=false;
    end;
end;
{
procedure TForm4.Kill_Liaison_TPE;
var i:integer;
    FTimerNow,FTimerStart:Cardinal;
begin
    If not(ApdComPort1.Open)
      then
         begin
          ApdComPort1.ComNumber:=StrToIntDef(cbPort.Text,1);
          ApdComPort1.Open:=true;
         end;

    i:=0;
    While (i<3) do
       begin
         inc(i);
         FTimerStart:=GetTickCount;
         ApdComPort1.PutChar(#5);
         TraceLog('--> #5 (ENQ)',el_Info);
         FTimerNow:=GetTickCount;
         while ((FTimerNow-FTimerStart)<500) do
            begin
                 FTimerNow:=GetTickCount;
                 Application.ProcessMessages;
            end;
         ApdComPort1.PutChar(#4);
         TraceLog('--> #4 (EOT)',el_Info);
       end;

    ApdComPort1.Open:=false;
end;
}

procedure TFrm_Main.rg_ProtocoleVersionClick(Sender: TObject);
begin
   if FLoading then exit;
   // TraceLog('rg_ProtocoleVersionClick',el_Debug);
   ParamEcran;
   Com_ParamsChange;
end;


procedure TFrm_Main.Repondre_ACK;
begin
    //ApdComPort1.PutChar(#6);
    VaComm1.WriteChar(#6);
    TraceLog('--> #6 (ACK)', el_Info);
end;

procedure TFrm_Main.ApplicationEvents1Minimize(Sender: TObject);
begin
  { Hide the window and set its state variable to wsMinimized. }
  Hide();
  WindowState := wsMinimized;

  { Show the animated tray icon and also a hint balloon. }
  Tray.Visible := True;
  Tray.Animate := True;
  Tray.ShowBalloonHint;
end;

procedure TFrm_Main.btn1Click(Sender: TObject);
begin
    TraceLog('Clic Fermeture Port Com',el_Info);
    VaComm1.PurgeReadWrite;
    EtatEsclave:=EENone;
    // Fermeture du Port...
    // ApdComPort1.Open:=false;
    VaComm1.Close;
    Busy := False;
end;

procedure TFrm_Main.btn2Click(Sender: TObject);
begin
    ShellExecute(Handle,'Open','mmc',PChar(' devmgmt.msc'),Nil,SW_SHOWDEFAULT);
end;

procedure TFrm_Main.ParamDefClick(Sender: TObject);
begin
    FSaving:=true;
    cbVitesse.ItemIndex  := 6;
    cbDataBits.ItemIndex := 2;
    cbParity.ItemIndex   := 1;
    cbstopBits.ItemIndex := 0;
    cbFlux.ItemIndex     := 0;
    FSaving:=false;
    SaveIni;
end;

procedure TFrm_Main.btn5Click(Sender: TObject);
var InputString: string;
begin
   if VaComm1.Active then
    begin
       MessageDlg('Veuillez tout d''abord Fermer le Port COM.',  mtWarning,
          [mbOK], 0);
       exit;
    end;

   PostMessage(Handle, InputBoxMessage, 0, 0);
   InputString := InputBox('Mot de passe', 'Veuillez saisir le mot de passe', '');
   Admin              := (InputString='1082');
   edt1.Enabled        := not(Busy) and (Admin);
   btnEnvoyer.Enabled  := not(Busy) and (Admin);
end;

procedure TFrm_Main.btnEnvoyerClick(Sender: TObject);
begin
   // S'il y a une connexion à la caisse il faut avertir
   DoSendToTPE();
end;

procedure TFrm_Main.Button1Click(Sender: TObject);
var InputString: string;
begin
   if VaComm1.Active then
    begin
       MessageDlg('Veuillez tout d''abord Fermer le Port COM.',  mtWarning,
          [mbOK], 0);
       exit;
    end;

   PostMessage(Handle, InputBoxMessage, 0, 0);
   InputString := InputBox('Mot de passe', 'Veuillez saisir le mot de passe', '');
   Admin              := (InputString='1082');
   edt1.Enabled        := not(Busy) and (Admin);
   btnEnvoyer.Enabled  := not(Busy) and (Admin);
end;

procedure TFrm_Main.Button2Click(Sender: TObject);
begin

//    VaConfigDialog1.Execute;
end;

procedure TFrm_Main.BRafClick(Sender: TObject);
begin
    BRaf.Enabled:=false;
    // on reliste les ports Com
    ListPortCom;
    // Autodétection uniquement si c'est checked
    FLoading:=true;  // parce que sinon on va le refaire dedans
    Auto_Detection();
    FLoading:=false;
    BRaf.Enabled:=true;
end;

function TFrm_Main.DoSendToTPE():boolean;
var // vStr:string;
//    iLRC:integer;
    I: Integer;
    FTimerNow,FTimerStart:Cardinal;
//    vParity : TParity;
begin
    try
       try
         if (EtatEsclave=EEEcoute) or (VaComm1.Active)
            then
              begin
                // s'il s'agit d'un ordre le caisse... ne pas poser la question --> Fermer le Port directe...
                // Si on est déjà ouvert c'est louche
                If not(Transaction.OrdreCaisse)
                  then
                      begin
                        If MessageDlg('Attention transaction déjà sur le TPE... voulez-vous renvoyer le montant... Attention le TPE peut quand même refuser ce montant', mtConfirmation, mbOKCancel, 1)<>MrOK
                        then
                            begin
                                result:=false;
                                exit;
                            end;
                      end
                  else
                      begin
                          // ApdComPort1.open:=False;
                          VaComm1.Close;
                          result:=false;
                          TraceLog('Force Port Com Close',El_Info);
                          EtatEsclave:=EENone;
                          DoSendToCaisseBUSY();
                          exit;
                          //cela va prendre 3 secondes
                      end;
              end;
      If Busy
        then
            begin
                result:=false;
                TraceLog('Busy>>Exit', el_Info);
                DoSendToCaisseBUSY();
                exit;
            end;
      Busy := true;
      if not(VaComm1.Active)
         then
          begin
            VaComm1.PortNum     := CommunicationPortCom.PortComNumero;
            VaComm1.Parity      := SetComParity();
            VaComm1.DataBits    := SetComDataBits();
            VaComm1.Baudrate    := SetComBaudRate();
            VaComm1.Stopbits    := SetComStopBits();
            SetComFlowControl();
            try
              VaComm1.Open();
            except
              On E:Exception do
                begin
                  TraceLog('Ouverture Port Com ' + E.ClassName + ' COM'  +IntToStr(VaComm1.PortNum),el_Erreur);
                  ErrorCOM := E.ClassName='EVaCommError';
                  if (ErrorUSB) and (ErrorCOM) then
                    begin
                        If not(Transaction.OrdreCaisse)
                          then MessageDlg('Attention Le TPE n''est plus détecté correctement. Veuillez le débrancher et le rebrancher', mtError, [mbOK], 0)
                          else DoSendToCaisseERRCOM(8);
                    end
                  else DoSendToCaisseERRCOM(2);

                  Busy := False;
                  result:=False;
                  VaComm1.Close;

                 exit;
                end;
            end;
          end;
      // Busy := false;   <----- etrange ??? non ?? gilles 09/11/2015

      // Le Port COM est donc Ouvert...
      ErrorCOM := False;

      i:=0;
      try
        While (EtatMaitre<>EMInitOk) and (i<3) do
          begin
            inc(i);
            FTimerStart:=GetTickCount;
            Maitre_Init;
            FTimerNow:=GetTickCount;
            while Not(EtatMaitre = EMInitOk) and  ((FTimerNow-FTimerStart)<500) do
              begin
                  FTimerNow:=GetTickCount;
                  Application.ProcessMessages;
              end;
            if not(EtatMaitre=EMInitOk) then
              begin
                TraceLog('<<<< Pas de réponse',el_Warning);
                // Recommendation Datacod : mettre un EOT
                Maitre_EOT();
                // Pause de 1s avant la prochaine tentative...
                TraceLog('Pause de 1s',el_Warning);
                FTimerStart := GetTickCount;
                FTimerNow   := GetTickCount;
                while ((FTimerNow-FTimerStart)<1000) do
                  begin
                    FTimerNow:=GetTickCount;
                    Application.ProcessMessages;
                  end;
              end;
          end;
        Except On E:Exception
          do
           begin
              result:=false;
              TraceLog('Level-1 ' +E.ClassName + ' ' + E.Message, el_Erreur);
              exit;
           end;
        end;

    if (EtatMaitre<>EMInitOk)
      then
          begin
              // Repondre à la caisse TimeOut
              DoSendToCaisseTIMEOUT();
              result:=false;
              exit;
          end;

    FTimerStart:=GetTickCount;
    Maitre_SendMontant(Transaction.MontantCaisse);
    FTimerNow:=GetTickCount;
    while Not(EtatMaitre = EMSendOk) and  ((FTimerNow-FTimerStart)<500) do
      begin
          FTimerNow:=GetTickCount;
          Application.ProcessMessages;
      end;


    if (EtatMaitre<>EMSendOk) then
      begin
          // Repondre à la caisse TimeOut
          DoSendToCaisseTIMEOUT();
          Busy   := false;
          result := false;
          exit;
      end;

    // GR : 2016-06-23 ajout d'une micropause avant de fermer la connexion Maitre
    // DoPauseMs(1);
    DoPauseMs(10);
    Maitre_Close();

    if (EtatMaitre<>EMClose) then
      begin
          result:=False;
          exit;
      end;

      // On passe en Etat Esclave
      EtatMaitre:=EMNone;

      EtatEsclave:=EEEcoute;
      result:=true;

      Except On E:Exception
      do
         begin
            Busy := false;
            TraceLog('Level-2 ' +E.ClassName + ' ' + E.Message, el_Erreur);
            result:=False;
            exit;
         end;
      end;

    finally

    end;
end;

function TFrm_Main.SetComStopBits():TVaStopBits;
begin
  case cbStopBits.ItemIndex of
    0:result:=sb1;
    1:result:=sb15;
    2:result:=sb2;
    else result:=sb1;
  end;
end;

procedure TFrm_Main.SetComFlowControl();
begin
  // 0 : Aucun
  // 1 : RTS/CTS : Hardware
  // 2 : DTR/RTS
  // 3 : DTR/DSR
  // 4 : XOn/XOff : Software
  With VaComm1.FlowControl do
    begin
      case cbFlux.ItemIndex of
        0: // Aucun Contôle
          begin
              OutCtsFlow := false;
              OutDsrFlow := false;
              ControlDtr:= dtrDisabled;
              ControlRts:= rtsDisabled;
              XOnXOffOut:= false;
              XOnXOffIn:= false;
          end;
        1: // Matériel
          begin
            OutCtsFlow := True;
            OutDsrFlow := false;
            ControlDtr := dtrDisabled;
            ControlRts := rtsHandshake;
            XOnXOffOut := false;
            XOnXOffIn  := false;
          end;
        2: // DTR/RTS
          begin
            // ici j'ai pas d'info sur OutCtsFlow et OutDsrFlow dans les docs... je vais mettre à faux..
            OutCtsFlow := false;
            OutDsrFlow := false;
            ControlDtr := dtrEnabled;
            ControlRts := rtsEnabled;
            XonXoffOut := false;
            XonXoffIn  := false;
          end;
        3: // DTR/DSR
          begin
            OutCtsFlow := false;
            OutDsrFlow := True;
            ControlDtr := dtrHandshake;
            ControlRts := rtsDisabled;
            XonXoffOut := false;
            XonXoffIn  := false;
          end;
        4: // Logiciel
          begin
            OutCtsFlow := false;
            OutDsrFlow := false;
            ControlDtr := dtrDisabled;
            ControlRts := rtsDisabled;
            XonXoffOut := True;
            XonXoffIn  := True;
          end;
        else // si erreur on passe sur Aucun
          begin
              OutCtsFlow := false;
              OutDsrFlow := false;
              ControlDtr:= dtrDisabled;
              ControlRts:= rtsDisabled;
              XOnXOffOut:= false;
              XOnXOffIn:= false;
          end;
      end;
    end;
end;

function TFrm_Main.SetComBaudRate():TVaBaudrate;
begin
  case cbVitesse.ItemIndex of
    0:result:=br110;
    1:result:=br300;
    2:result:=br600;
    3:result:=br1200;
    4:result:=br2400;
    5:result:=br4800;
    6:result:=br9600;
    7:result:=br14400;
    8:result:=br19200;
    9:result:=br38400;
    10:result:=br56000;
    11:result:=br57600;
    12:result:=br115200;
    13:result:=br128000;
    14:result:=br256000;
    else result:=br9600;
  end;
end;

function TFrm_Main.SetComDataBits():TVaDataBits;
begin
  case cbDataBits.ItemIndex of
    0:result:=db5;
    1:result:=db6;
    2:result:=db7;
    3:result:=db8;
    else result:=db7;
  end;
end;

function TFrm_Main.SetComParity():TVaParity;
begin
  case cbParity.ItemIndex of
    0:result:=paNone;
    1:result:=paEven;
    2:result:=paOdd;
    3:result:=paMark;
    4:result:=paSpace;
    else result:=paNone;
  end;
end;


procedure TFrm_Main.edt1Change(Sender: TObject);
begin
    Transaction.MontantCaisse:=StrToFloatDef(Edt1.Text,0);
end;

procedure TFrm_Main.edt1KeyPress(Sender: TObject; var Key: Char);
begin
  if not (AnsiChar(Key) in [#8, '0'..'9', ',', '.', myFormatSettings.DecimalSeparator]) then begin
    Key := #0;
  end;
  if (AnsiChar(Key) in ['.',',']) then begin
    Key := myFormatSettings.DecimalSeparator;
  end
end;

procedure TFrm_Main.Maitre_SendMontant(aMnt:double);
var vStr  :string;
    sStr : string;
//    i:integer;
    iLRC:integer;
    vMnt:integer;
    vLng : integer;
begin
    // Pause de 1ms
    DoPauseMs(1);

    EtatMaitre:=EMSend;
    vMnt := Round(aMnt * 100);
//  sStr := Format('01%.8d110978          ',[vMnt]);

    // V2(E)
    if Transaction.ProtocoleVersion=V2E then
      begin
        if Transaction.TypePaiement=TpCheque
          then sStr := Format('01%.8d1C09780000000000',[vMnt])
          else sStr := Format('01%.8d1109780000000000',[vMnt]);
      end;

    if Transaction.ProtocoleVersion=V2EPlus then
      begin
        if Transaction.TypePaiement=TpCheque
          then sStr := Format('01%.8d1C09780000000000A010B010',[vMnt])
          else sStr := Format('01%.8d1109780000000000A010B010',[vMnt]);
      end;

    if Transaction.ProtocoleVersion=V3 then
      begin
        vLng := Length(IntToStr(vMnt));
        // test Chèque
        // sStr := Format('CZ0040300CJ012345351663588CA00201CB00'+IntToStr(vLng)+'%.'+IntToStr(vLng)+'dCC00300CCD0010CE003978',[vMnt])
        if Transaction.TypePaiement=TpCheque
          then sStr := Format('CZ0040300CJ012345351663588CA00201CB00'+IntToStr(vLng)+'%.'+IntToStr(vLng)+'dCC00300CCD0010CE003978',[vMnt])
          else sStr := Format('CZ0040300CJ012345351663588CA00201CB00'+IntToStr(vLng)+'%.'+IntToStr(vLng)+'dCC003001CD0010CE003978',[vMnt]);
      end;


    vStr := #2 + sStr + #3;
    iLRC := CalculLRC(vStr);
    // ApdComPort1.PutString(vstr + Chr(iLRC));
    VaComm1.WriteText(vstr + Chr(iLRC));
    TraceLog('--> STX '+ sStr + ' ETX #'+IntTOStr(iLRC), el_Info);
end;

procedure TFrm_Main.Maitre_EOT();  // Se passe lorsque on arrive pas a joindre le TPE
begin
    EtatMaitre:=EMClose;
    VaComm1.WriteChar(#4);
    TraceLog('--> #4 (EOT)', el_Info);
end;

procedure TFrm_Main.Maitre_Close();
begin
    EtatMaitre:=EMClose;
    // ApdComPort1.PutChar(#4);
    VaComm1.WriteChar(#4);
    TraceLog('--> #4 (EOT)', el_Info);
    // Fin de la transaction Maitre avec le TPE : on le signale à la caisse...
    DoSendToCaisseInsererCarte();
end;


procedure TFrm_Main.Maitre_Init();
begin
    EtatMaitre:=EMInit;
    // ApdComPort1.PutChar(#5);
    VaComm1.WriteChar(#5);
    TraceLog('--> #5 (ENQ)', el_Info);
end;


function TFrm_Main.CalculLRC(aStr:string):integer;
var i:integer;
begin
    result := 0;
    for i:=2 to Length(aStr) do
      begin
        result := result XOR Ord(Char(aStr[i]));
      end;
end;

procedure TFrm_Main.cbParamsChange(Sender: TObject);
begin
    if FLoading then exit;
    TraceLog('cbParamsChange',el_Debug);
    Com_ParamsChange();
end;

procedure TFrm_Main.Com_ParamsChange();
var iPos     : integer;
    sNumPort : string;

begin
    // Si on est en createFormFaut pas faire de sauvegarde....
    TraceLog('Com_ParamsChange()',el_Debug);

    iPos:=AnsiPos(' - ',cbPort.Text);
    sNumPort:=Copy(cbPort.Text,1,iPos-1);
    CommunicationPortCom.PortComNumero := StrToIntDef(sNumPort,1);

    SaveIni();

    lbl_gportcom.Caption   := IntToStr(CommunicationPortCom.PortComNumero);
    lbl_gvitesse.Caption   := cbVitesse.Text;
    lbl_gdatabits.Caption  := cbDataBits.text;
    lbl_gparity.Caption    := cbParity.Text;
    lbl_gStopBit.Caption   := cbstopBits.Text;
    lbl_Flux.Caption       := cbFlux.Text;

    case rg_ProtocoleVersion.ItemIndex of
      0 : Transaction.ProtocoleVersion := V2E;
      1 : Transaction.ProtocoleVersion := V2EPlus;
      2 : Transaction.ProtocoleVersion := V3;
      else
        Transaction.ProtocoleVersion := V2E;
    end;
    lbl_gProtocoleVersion.Caption := rg_ProtocoleVersion.Items[rg_ProtocoleVersion.ItemIndex];
end;


procedure TFrm_Main.cb_autodetectClick(Sender: TObject);
begin
   if FLoading then exit;
   TraceLog('cb_autodetectClick',el_Debug);
   ParamEcran;
   Com_ParamsChange;
end;

procedure TFrm_Main.ParamEcran;
begin
   edtSearchTPENAME.Visible := cb_autodetect.checked;
end;


procedure TFrm_Main.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    If Assigned(Transaction)
      then Transaction.DisposeOf;
    if Assigned(CommunicationPortCom)
      then CommunicationPortCom.DisposeOf;
    // ApdComPort1.Open:=false;
    VaComm1.Close;
end;

procedure TFrm_Main.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  // Minimize application instead of closing
  CanClose := False;
  Self.Hide;
  //   Application.Minimize;
  // Remove the main form from the Task bar
  //  Self.Hide;
end;

procedure TFrm_Main.Paramtrage1Click(Sender: TObject);
begin
  pgc.ActivePage:=tsParametrage;
  ParamEcran;
  Application.Restore;
  Application.BringToFront;
  Self.Show;
end;

procedure TFrm_Main.PortOpenClose(CP: TObject; Opened: Boolean);
begin
  if Opened then
    begin
        { the port is now open }
    end
  else
    begin
    end;
    { the port is now closed }
end;

procedure TFrm_Main.SaveIni();
var sFic    : string;
    FicIni  : TIniFile;
begin
  TraceLog('Save_Ini',el_Info);
  if FSaving then exit;
  sFic := ChangeFileExt(Application.ExeName, '.ini');
  // on sauvegarde meme s'il n'existe pas
  // if FileExists(sFic) then begin
    FicIni:=TIniFile.Create(sFic);
    try
      FicIni.WriteInteger('PortCOM', 'NumPort', CommunicationPortCom.PortComNumero);
      TraceLog(Format('Port N° : %d',[CommunicationPortCom.PortComNumero]),el_Info);
      FicIni.WriteString('PortCOM', 'Vitesse', cbVitesse.Text);
      TraceLog(Format('Vitesse : %s',[cbVitesse.Text]),el_Info);
      FicIni.writeString('PortCOM', 'Arret',   cbstopBits.Text);
      TraceLog(Format('Arret : %s',[cbStopBits.Text]),el_Info);
      FicIni.WriteInteger('PortCOM', 'Parite', cbParity.ItemIndex);
      TraceLog(Format('Parité : %s',[cbParity.Text]),el_Info);
      FicIni.WriteString('PortCOM', 'Bits',    cbDataBits.Text);
      TraceLog(Format('Bits : %s',[cbDataBits.Text]),el_Info);

      FicIni.WriteInteger('PortCOM', 'Flux', cbFlux.ItemIndex);
      TraceLog(Format('Contrôle Flux : %d',[cbFlux.ItemIndex]),el_Info);

      FicIni.WriteBool('PortCom', 'AutoDetect', cb_autodetect.Checked);
      TraceLog(Format('AutoDetect : %s',[BoolToStr(cb_autodetect.Checked,true)]),el_Info);
      FicIni.WriteString('PortCom', 'SearchTPEName',edtSearchTPENAME.Text);
      TraceLog(Format('SearchTPEName : %s',[edtSearchTPENAME.Text]),el_Info);

      TraceLog(Format('ProtocoleVersion : %s',[rg_ProtocoleVersion.Items[rg_ProtocoleVersion.ItemIndex]]),el_Info);

      case rg_ProtocoleVersion.ItemIndex of
        0  : FicIni.WriteString('Protocole','Version','V2E');
        1  : FicIni.WriteString('Protocole','Version','V2E+');
        2  : FicIni.WriteString('Protocole','Version','V3');
        //  3  : FicIni.WriteString('Protocole','Version','V3_10'); n'est pas pris en compte par ingénico
      end;

      // TraceLog(Format('ProtocoleVersion : %s',[rg_ProtocoleVersion.Items[Ord(Transaction.ProtocoleVersion)]]),el_Info);


    finally
     FicIni.Free;
    end;
//  end;
end;

procedure TFrm_Main.ListPortCom();
var i:integer;
    vList,vList2: TStringList;
    j: Integer;
    bFound:boolean;
    mIndex : Integer;
    mText  : string;
    vPos :integer;
    vLabel : string;
begin
    TraceLog('ListPortCom',el_Debug);
    FLoading := true;
    vList := Get_Serial_Ports;
    vList2 := SetupEnumAvailableComPorts;
    // mmo1.Lines.Add(vList2.Text);
    cbPort.Items.BeginUpdate;
    mIndex := cbPort.ItemIndex;
    mText  := cbPort.Items[cbPort.ItemIndex];
    try
      cbPort.Items.Clear;
      for i := 1 to 64 do
        begin
            if IsPortAvailable(i) then
              begin
                  bFound:=false;
                  for j := 0 to vList.Count-1 do
                     if AnsiPos(Format('(COM%d)',[i]),vList[j])>1
                       then
                        begin
                            cbPort.Items.Add(Format('%d - %s',[i,vList[j]]));
                            bFound:=true;
                        end;
                  if not(bFound) then
                    begin
                      for j := 0 to vList2.Count-1 do
                         if AnsiPos(Format('COM%d',[i]),vList2[j])=1
                           then
                            begin
                                vPos := AnsiPos(Format(' - ',[i]),vList2[j]);
                                if vPos>1 then
                                   begin
                                      vLabel := Copy(vList2[j],vPos+3,Length(vList2[j]));
                                      cbPort.Items.Add(Format('%d - %s',[i,vLabel]));
                                      bFound:=true;
                                   end;
                            end;
                    end;
                  if not(bFound) then
                      cbPort.Items.Add(Format('%d - ',[i]));
              end;
        end;
       //--------------------------------------
    finally
      // On essaye au mieux de se mettre sur le même port COM
      // Mettre ca dans un procédure
      if (mIndex<cbPort.Items.Count-1) and (mIndex>-1)
        then cbPort.ItemIndex:=mIndex;
      for I := 0 to cbPort.Items.Count-1 do
          begin
              If (cbPort.Items[i] = mText)
                then
                    begin
                        cbPort.ItemIndex:=i;
                        break;
                    end;
          end;
      cbPort.Items.EndUpdate;
      vList.DisposeOf;
    end;
end;

procedure TFrm_Main.WndProc(var Message: TMessage);
begin
  inherited;
  if (Message.Msg = MsgQuit) then
    begin
       TraceLog('MsgQuit',el_Info);
       HandleAppliExt:=(Message.WParam);
       Action_Quitter();
    end;
end;



{
procedure TFrm_Main.DefaultHandler;
begin
  inherited DefaultHandler(Msg);
  if (TMessage(Msg).Msg) = MsgQuit then
    begin
       TraceLog('MsgQuit',el_Info);
       HandleAppliExt:=(TMessage(Msg).WParam);
       Action_Quitter();
    end;
end;
}

procedure TFrm_Main.FormCreate(Sender: TObject);
var i:integer;
    ReperTrace,ReperBase:string;
    Version : string;
begin
    FLoading  := true;
    FAdmin    := false;
    FErrorUSB := false;
    FErrorCOM := false;


    // On encode tout les messages.
    HandleRecepteur := Frm_Main.Handle;
    MsgQuit         := RegisterWindowMessage('SX_MsgSysKillTPEServ01');

    GetLocaleFormatSettings(GetThreadLocale, myFormatSettings);

    ReperBase := ExtractFilePath(ParamStr(0));
    if ReperBase[Length(ReperBase)]<>'\' then
      ReperBase := ReperBase+'\';
    ReperTrace := ReperBase+'LOG_TPE\';
    Log_Init(el_Info, ExtractFilePath(ReperTrace));
    Log_Write('Démarrage', el_Info);

    FTransaction                  := TTransaction.Create;
    FCommunicationPortCom         := TCommunicationPortCom.Create;
    Transaction.OrdreCaisse       := false;
    Transaction.RemoteAddress     := '127.0.0.1';
    Transaction.MontantCaisse     := 1;

    Transaction.ProtocoleVersion  := V2E; // Le vieux protocol

    ListPortCom;

    LoadIni;

    ServerSocket.Active  := true;
    // Choix du Port COM... un peu plus complexe maintenant
    for I := 0 to cbPort.Items.Count-1 do
        begin
            if AnsiPos(Format('%d - ',[CommunicationPortCom.PortComNumero]),cbPort.Items[i])=1
               then cbPort.ItemIndex  := i;
        end;

    for I := 0 to cbVitesse.Items.Count-1 do
      begin
           If (IntToStr(CommunicationPortCom.Vitesse) = cbVitesse.Items[i])
            then cbVitesse.ItemIndex := i;
      end;

    for I := 0 to cbDataBits.Items.Count-1 do
      begin
           If (IntToStr(CommunicationPortCom.DataBits) = cbDataBits.Items[i])
              then cbDataBits.ItemIndex:=i;
      end;

    for I := 0 to cbFlux.Items.Count-1 do
      begin
            If (IntToStr(CommunicationPortCom.Flux) = cbFlux.Items[i])
             then cbDataBits.ItemIndex:=i;
      end;

    cb_autodetect.Checked := CommunicationPortCom.AutoDetectUSB;

    edtSearchTPENAME.Text := CommunicationPortCom.SearchTPEName;
    cbStopBits.Text       := CommunicationPortCom.StopBits;
    cbParity.ItemIndex    := CommunicationPortCom.Parity;
    cbFlux.ItemIndex      := CommunicationPortCom.FFlux;

    lbl_gportcom.Caption   := IntToStr(CommunicationPortCom.PortComNumero);
    lbl_gvitesse.Caption   := cbVitesse.Text;
    lbl_gdatabits.Caption  := cbDataBits.text;
    lbl_gparity.Caption    := cbParity.Text;
    lbl_gStopBit.Caption   := cbstopBits.Text;
    lbl_Flux.Caption       := cbFlux.Text;

    lbl_gProtocoleVersion.Caption := rg_ProtocoleVersion.Items[rg_ProtocoleVersion.ItemIndex];


    lbl_gIP.Caption           := '';
    lbl_gMnt.Caption          := '';
    lbl_gTypePaiement.Caption := '';

    FBusy       := false;
    EtatEsclave := EENone;
    ETatMaitre  := EMNone;
    FBuffer     := '';


    FCaisses := TStringList.Create;

    Auto_Detection();
    //
    Version:= GetNumVersionSoft;
    Caption := Caption+' - V '+ Version;
    Application.Title := Application.Title+' - V '+ Version;
    Tray.Hint := Application.Title;
    FLoading := false;

end;

procedure TFrm_Main.FormDestroy(Sender: TObject);
begin
 if Assigned(FTimerThread) and not(FTimerThread.ExternalThread)
  then FTimerThread.FinishThreadExecution;
end;

end.
