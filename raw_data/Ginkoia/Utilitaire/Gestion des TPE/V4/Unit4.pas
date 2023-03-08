unit Unit4;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, OoMisc, AdPort, AdSelCom,
  Vcl.ComCtrls, AdPacket, Data.DB, Datasnap.DBClient, Datasnap.Win.MConnect,
  Datasnap.Win.SConnect, IdContext, IdBaseComponent, IdComponent,
  IdCustomTCPServer, IdTCPServer, AdWnPort, System.Win.ScktComp, Vcl.ExtCtrls,
  Vcl.Menus, Vcl.AppEvnts,Winapi.ShellAPI, Vcl.Buttons,GestionLog, Generics.Collections,
  Vcl.Imaging.pngimage, System.ImageList, Vcl.ImgList, VaClasses, VaComm;

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
  TCommunicationPortCom  = class
    private
      FPortComNumero : Integer;
      FVitesse       : integer;
      FStopBits      : string;
      FDataBits      : integer;
      FParity        : Word;
      FAutoDetectUSB : boolean;
      FSearchTPEName : string;
    published
      property PortComNumero : integer read FPortComNumero write FPortComNumero;
      property Parity        : Word    read FParity        write FParity;
      property Vitesse       : Integer read FVitesse       write FVitesse;
      property StopBits      : string  read FStopBits      write FStopBits;
      property DataBits      : Integer read FDataBits      write FDataBits;
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
  TTransaction  = class
    private
      FRemoteAddress    : string;
      FmontantCaisse    : Currency;
      FTrameRecuTPE     : string;
      FOrdreCaisse      : Boolean;
      FTypePaiement     : TTypePaiement;
      function Fnc_ReponseCaisse():string;
    published
     property TypePaiement     : TTypePaiement read FTypePaiement     write FTypePaiement;
     property OrdreCaisse      : Boolean       read FOrdreCaisse      write FOrdreCaisse;
     property RemoteAddress    : string        read FRemoteAddress    write FRemoteAddress;
     property MontantCaisse    : Currency      read FmontantCaisse    write FmontantCaisse;
     property TrameRecuTPE     : string        read FTrameRecuTPE     write FTrameRecuTPE;
     property ReponseCaisse    : string        read Fnc_ReponseCaisse;
   end;
  TForm4 = class(TForm)
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
    procedure btnEnvoyerClick(Sender: TObject);
    procedure ApdComPort1PortOpen(Sender: TObject);
    procedure ApdComPort1PortClose(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ApdComPort1TriggerAvail(CP: TObject; Count: Word);
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
    procedure edtSearchTPENAMEExit(Sender: TObject);
    procedure VaComm1RxBuf(Sender: TObject; Data: PVaData; Count: Integer);
    procedure VaComm1RxChar(Sender: TObject; Count: Integer);
  private
     myFormatSettings: TFormatSettings;
     FLoading    : boolean;
     FSaving     : Boolean;
     S:string;
     FBusy       : boolean;
     FLRC        : integer;
     FBuffer     : string;
     EtatMaitre  : TEtatMaitre;
     EtatEsclave : TEtatEsclave;
     CRTrig      : word;
     FTransaction : TTransaction;
     FCommunicationPortCom : TCommunicationPortCom;
     FTimerThread : TTimerThread;
     FComOpenedStart : Cardinal;
     //     FCaisses : TObjectList<TCaisse>;
     Fcaisses  : TStringList;
     FAdmin    : Boolean;

     procedure RestartThisApp;
     procedure ParamEcran;

     procedure ListPortCom();
     procedure LoadIni();
     procedure SaveIni();
     procedure PortOpenClose(CP : TObject; Opened : Boolean);
     function CalculLRC(aStr:string):integer;
     procedure Maitre_Init();
     procedure Maitre_SendMontant(aMnt:double);
     procedure Maitre_Close();
     procedure Repondre_Ack();
     procedure Repondre_NAck();
     procedure CalculFLRC();
     function PrintBufferLog(aString:string):string;
     function DoSendToTPE():Boolean;
     procedure SetBusy(aValue:Boolean);
     procedure SetAdmin(aValue:Boolean);

     //
     procedure Action_Quitter();

     //  dialogs avec la caisse
     function DoSendToCaissePresence():Boolean;
     function DoSendToCaisseInsererCarte():Boolean;
     function DoSendToCaisseInCommunication(aNumero:integer):Boolean;
     function DoSendToCaisseBUSY():Boolean;
     function DoSendToCaisseTIMEOUT():Boolean;
     function DoSendToCaisseERRCOM(aNumero:integer):Boolean;
     procedure DoClosePortCom(var M:TMessage); message WM_CLOSEPORTCOM;

     procedure  Auto_Detection();
     procedure  Com_ParamsChange();
      procedure DoAutoDetectUSB(var M:TMessage);  message WM_AUTODETECTUSB;
     function Repondre_Caisse():Boolean;
//     procedure Kill_Liaison_TPE;
     procedure TraceLog(aLog:string;aLevel:TErrorLevel);
     procedure InputBoxSetPasswordChar(var Msg: TMessage); message InputBoxMessage;
    { Déclarations privées }

      procedure DefaultHandler(var Msg); override;
      procedure WMDeviceChange(var M:TMessage); message WM_DEVICECHANGE;

  public
    { Déclarations publiques }
    property ComOpenedStart : Cardinal Read FComOpenedStart write FComOpenedStart;
    property Buffer  : string   read FBuffer   write FBuffer;
    property Busy    : boolean  read FBusy     write SetBusy;
    property Admin   : Boolean  read FAdmin    write SetAdmin;
    property Transaction : TTransaction read FTransaction Write FTransaction;
    property CommunicationPortCom : TCommunicationPortCom read FCommunicationPortCom write FCommunicationPortCom;
  end;

var
  Form4   : TForm4;
  MsgQuit : UINT;
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
          vElapse := GetTickCount - Form4.ComOpenedStart;
          Form4.StatusBar1.Panels[1].Text:=Format('%d',[vElapse div 1000]);
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


procedure TForm4.TraceLog(aLog:string;aLevel:TErrorLevel);
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


procedure TForm4.DoClosePortCom(var M: TMessage);
begin
  Application.processmessages;
  VaComm1.Close;
end;

procedure TForm4.InputBoxSetPasswordChar(var Msg: TMessage);
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

procedure TForm4.SetAdmin(aValue:Boolean);
begin
    FAdmin:=aValue;
    Lbl_Admin.Visible:=aValue;

end;

procedure TForm4.DoAUTODETECTUSB(var M:TMessage);
begin
    Auto_Detection;
end;

procedure TForm4.WMDeviceChange(var M:TMessage);
const
  DBT_DEVNODES_CHANGED = $0007;      // Changement sur les USB
begin
  inherited;
  case M.wParam of
    DBT_DEVNODES_CHANGED:
        begin
            TraceLog('Détection USB',el_Info);
            PostMessage(handle, WM_AUTODETECTUSB, 0, 0);
            // Sleep(1000);
        end;
  end;
end;

procedure  TForm4.Auto_Detection();
var i:integer;
    TPE_port:string;
    bfind:Boolean;
    sNumPort : string;
    iNumPort : integer;
    mText    : string;
    mIndex   : integer;
begin
    if not(cb_autodetect.Checked) then exit;
    TraceLog('Auto_Detection',el_Debug);
    // On memorise sont ItempIndex
    mIndex := cbPort.ItemIndex;
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
            bfind:=false;
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



procedure TForm4.SetBusy(aValue:Boolean);
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

    cb_autodetect.Enabled    := not(AValue);
    edtSearchTPENAME.Enabled := not(Avalue);

    ParamDef.Enabled   := not(Avalue);

    lbl_gportcom.Caption   := IntToStr(CommunicationPortCom.PortComNumero);
    lbl_gvitesse.Caption   := cbVitesse.Text;
    lbl_gdatabits.Caption  := cbDataBits.text;
    lbl_gparity.Caption    := cbParity.Text;
    lbl_gStopBit.Caption   := cbstopBits.Text;

end;

procedure TForm4.RestartThisApp;
begin
//  ShellExecute(Handle, nil, PChar(Application.ExeName), nil, nil, SW_SHOWNORMAL);
//  Application.Terminate;
end;

procedure TForm4.CalculFLRC();
begin
  FLRC:=CalculLRC(Buffer);
end;

procedure TForm4.LoadIni();
var sFic    : string;
    FicIni  : TIniFile;
    sLigne  : string;
    // OSinfos  :TOSInfos;
begin
  TraceLog('LoadIni',el_Info);
  FCommunicationPortCom.PortComNumero := 1;               // N° de port COM
  FCommunicationPortCom.Vitesse       := 9600;
  FCommunicationPortCom.StopBits      := '1';             // 0=1 1=1.5 2=2
  FCommunicationPortCom.DataBits      := 7;
  FCommunicationPortCom.Parity        := 1;    // 0=Aucun  1=Pair etc...
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
      TraceLog(Format('AutoDetection : %s',[BoolToStr(CommunicationPortCom.AutoDetectUSB,true)]),el_Info);
      CommunicationPortCom.SearchTPEName := FicIni.ReadString('PortCom', 'SearchTPENAME', CommunicationPortCom.SearchTPEName);
      TraceLog(Format('SearchTPEName : %s',[CommunicationPortCom.SearchTPEName]),el_Info);
      ServerSocket.Port                  := FicIni.ReadInteger('Serveur', 'Port', 31324);
      TraceLog(Format('ServerSocketPort : %d',[ServerSocket.Port]),el_Info);
    finally
      FreeAndNil(FicIni);
    end;
  end;

end;

procedure TForm4.Logs1Click(Sender: TObject);
begin
  ParamEcran;
  pgc.ActivePage:=tsLogs;
  Application.Restore;
  Application.BringToFront;
  Self.Show;
end;

procedure TForm4.ApdComPort1PortClose(Sender: TObject);
begin
   StatusBar1.Panels[0].Text:='Fermé';
   TraceLog('Port Com Fermé',el_Info);
   FTimerThread.FinishThreadExecution;
   Busy:=false;

   lbl_gIP.Caption           := '';
   lbl_gMnt.Caption          := '';
   lbl_gTypePaiement.Caption := '';

end;

procedure TForm4.ApdComPort1PortOpen(Sender: TObject);
begin
  StatusBar1.Panels[0].Text:='Ouvert';
  TraceLog('Port Com Ouvert',el_Info);
  FComOpenedStart := GetTickCount;
  FTimerThread := TTimerThread.Create(False);
  Busy:=true;
end;

procedure TForm4.ApdComPort1TriggerAvail(CP: TObject; Count: Word);
var i:integer;
    C:AnsiChar;
begin
    // Réponse du TPE
    for i:=1 to Count do
        begin
//          C:=VaComm1.Read
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
                        TraceLog('Orde de Fermerture du Port Com donné à Windows',el_Info);
                        VaComm1.Close;
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
        end;
end;


function TForm4.PrintBufferLog(aString:string):string;
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

procedure TForm4.Quitter1Click(Sender: TObject);
begin
   Action_Quitter();
end;


procedure TForm4.Action_Quitter();
begin
    try
      TraceLog('Quitter>>Fin du Programme',el_Info);
      VAComm1.CLose;
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

procedure TForm4.Repondre_NACK;
begin
    VaComm1.WriteChar(#21);
    TraceLog('--> #21 (NAK)',el_Info);
end;

function TForm4.DoSendTOCaissePresence():Boolean;
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

function TForm4.DoSendToCaisseBUSY():Boolean;
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

function TForm4.DoSendToCaisseERRCOM(aNumero:integer):Boolean;
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


function TForm4.DoSendToCaisseTIMEOUT():Boolean;
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
      VaComm1.CLose;
      result:=true;
    except
      result:=false;
    end;
end;

function TForm4.DoSendToCaisseInsererCarte():Boolean;
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


function TForm4.DoSendToCaisseInCommunication(aNumero:Integer):Boolean;
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


procedure TForm4.ServerSocketClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
var i:integer;
begin
    TraceLog('Dialog Caisse/ClientConect',el_Info);
end;

procedure TForm4.ServerSocketClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var vRcv: string;
    vMnt: string;
begin
    vRcv := Copy(Socket.ReceiveText,0,10);
    TraceLog('Dialog Caisse <-- ' + vRcv, el_Info);
    If vRcv='' then Exit;
    Transaction.OrdreCaisse   := false;
    Transaction.RemoteAddress := Socket.RemoteAddress;
    lbl_gIP.Caption           := Transaction.RemoteAddress;
    lbl_gMnt.Caption          := '';
    lbl_gTypePaiement.Caption := '';
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

procedure TForm4.TrayClick(Sender: TObject);
begin
  ParamEcran;
  Application.Restore;
  Application.BringToFront;
  Self.Show;
end;

procedure TForm4.TrayDblClick(Sender: TObject);
begin
  pgc.ActivePage:=tsGeneral;
  ParamEcran;
  Application.Restore;
  Application.BringToFront;
  Self.Show;
end;

procedure TForm4.VaComm1RxBuf(Sender: TObject; Data: PVaData; Count: Integer);
var i:integer;
    C:AnsiChar;
begin
{    // Réponse du TPE
    for i:=1 to Count do
        begin
          C:=Read(BufferRx,Count);
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
                        TraceLog('Orde de Fermerture du Port Com donné à Windows',el_Info);
                        VaComm1.Close;
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
        end;
    }
end;

procedure TForm4.VaComm1RxChar(Sender: TObject; Count: Integer);
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
                        TraceLog('Orde de Fermerture du Port Com donné à Windows',el_Info);
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

function TForm4.Repondre_Caisse():Boolean;
var vReponse : string;
    i        : integer;
begin
    result:=false;
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

procedure TForm4.Repondre_ACK;
begin
    VaComm1.WriteChar(#6);
    TraceLog('--> #6 (ACK)', el_Info);
end;

procedure TForm4.ApplicationEvents1Minimize(Sender: TObject);
begin
  { Hide the window and set its state variable to wsMinimized. }
  Hide();
  WindowState := wsMinimized;

  { Show the animated tray icon and also a hint balloon. }
  Tray.Visible := True;
  Tray.Animate := True;
  Tray.ShowBalloonHint;
end;

procedure TForm4.btn1Click(Sender: TObject);
begin
    EtatEsclave:=EENone;
    // Fermeture du Port...
    VaComm1.Close;
    Busy := False;
end;

procedure TForm4.btn2Click(Sender: TObject);
begin
    ShellExecute(Handle,'Open','mmc',PChar(' devmgmt.msc'),Nil,SW_SHOWDEFAULT);
end;

procedure TForm4.ParamDefClick(Sender: TObject);
begin
    FSaving:=true;
    cbVitesse.ItemIndex  := 6;
    cbDataBits.ItemIndex := 2;
    cbParity.ItemIndex   := 1;
    cbstopBits.ItemIndex := 0;
    FSaving:=false;
    SaveIni;
end;

procedure TForm4.btn5Click(Sender: TObject);
var InputString: string;
begin
{   if VaComm1.open then
    begin
       MessageDlg('Veuillez tout d''abord Fermer le Port COM.',  mtWarning,
          [mbOK], 0);
       exit;
    end;
}
   PostMessage(Handle, InputBoxMessage, 0, 0);
   InputString := InputBox('Mot de passe', 'Veuillez saisir le mot de passe', '');
   Admin              := (InputString='1082');
   edt1.Enabled        := not(Busy) and (Admin);
   btnEnvoyer.Enabled  := not(Busy) and (Admin);
end;

procedure TForm4.btnEnvoyerClick(Sender: TObject);
begin
   DoSendToTPE();
end;

procedure TForm4.Button1Click(Sender: TObject);
var InputString: string;
begin
{   if ApdComPort1.Open then
    begin
       MessageDlg('Veuillez tout d''abord Fermer le Port COM.',  mtWarning,
          [mbOK], 0);
       exit;
    end;
}
   PostMessage(Handle, InputBoxMessage, 0, 0);
   InputString := InputBox('Mot de passe', 'Veuillez saisir le mot de passe', '');
   Admin              := (InputString='1082');
   edt1.Enabled        := not(Busy) and (Admin);
   btnEnvoyer.Enabled  := not(Busy) and (Admin);
end;

procedure TForm4.BRafClick(Sender: TObject);
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

function TForm4.DoSendToTPE():boolean;
var vStr:string;
    iLRC:integer;
    I: Integer;
    FTimerNow,FTimerStart:Cardinal;
    vParity : TParity;
begin
    try
       try
         if (EtatEsclave=EEEcoute) or VaComm1.Active
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
                          VaComm1.CLose;
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
            {ApdComPort1.ComNumber := CommunicationPortCom.PortComNumero;
            ApdComPort1.Parity    := TParity(cbParity.ItemIndex);
//          TParity = (pNone, pOdd, pEven, pMark, pSpace);
            ApdComPort1.DataBits  := StrToIntDef(cbDataBits.Text,7);
            ApdComPort1.Baud      := StrToIntDef(cbVitesse.Text,9600);
            // stop bits, 0=1, 1=1.5, 2=2
            ApdComPort1.StopBits  := cbStopBits.ItemIndex;
            }
//          ApdComPort1.InitPort;
            try
              VaComm1.Open;
            except
              On E:Exception do
                begin
                  DoSendToCaisseERRCOM(2);
                  TraceLog('Ouverture Port Com ' + E.ClassName + ' COM'  +IntToStr(VaComm1.PortNum),el_Info);
                  Busy := False;
                  result:=False;
                  exit;
                end;
            end;
          end;
      // Busy := false;   <----- etrange ??? non ?? gilles 09/11/2015

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
                TraceLog('<<<< Pas de réponse',el_Info);
              end;
          end;
        Except On E:Exception
          do
           begin
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

    Maitre_Close();

    if (EtatMaitre<>EMClose) then
      begin
          result:=False;
          exit;
      end;

      EtatMaitre:=EMNone;

      EtatEsclave:=EEEcoute;
      result:=true;

      Except On E:Exception
      do
         begin
            TraceLog('Level-2 ' +E.ClassName + ' ' + E.Message, el_Erreur);
            result:=False;
            exit;
         end;
      end;

    finally

    end;
end;

procedure TForm4.edt1Change(Sender: TObject);
begin
    Transaction.MontantCaisse:=StrToFloatDef(Edt1.Text,0);
end;

procedure TForm4.edt1KeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in [#8, '0'..'9', ',', '.', myFormatSettings.DecimalSeparator]) then begin
    Key := #0;
  end;
  if (Key in ['.',',']) then begin
    Key := myFormatSettings.DecimalSeparator;
  end
end;

procedure TForm4.edtSearchTPENAMEExit(Sender: TObject);
begin
    BRaf.Click;
end;

procedure TForm4.Maitre_SendMontant(aMnt:double);
var vStr  :string;
    sStr : string;
    i:integer;
    iLRC:integer;
    vMnt:integer;
begin
    EtatMaitre:=EMSend;
    vMnt := Round(aMnt * 100);
//    sStr := Format('01%.8d110978          ',[vMnt]);
    if Transaction.TypePaiement=TpCheque
      then sStr := Format('01%.8d1C09780000000000',[vMnt])
      else sStr := Format('01%.8d1109780000000000',[vMnt]);
    vStr := #2 + sStr + #3;
    iLRC := CalculLRC(vStr);
    VaComm1.WriteText(vstr + Chr(iLRC));
    TraceLog('--> STX '+ sStr + ' ETX #'+IntTOStr(iLRC), el_Info);
end;

procedure TForm4.Maitre_Close();
begin
    EtatMaitre:=EMClose;
    VaComm1.WriteChar(#4);
    TraceLog('--> #4 (EOT)', el_Info);
    // Fin de la transaction Maitre avec le TPE : on le signale à la caisse...
    DoSendToCaisseInsererCarte();
end;


procedure TForm4.Maitre_Init();
begin
    EtatMaitre:=EMInit;
    VaComm1.WriteChar(#5);
    TraceLog('--> #5 (ENQ)', el_Info);
end;


function TForm4.CalculLRC(aStr:string):integer;
var i:integer;
begin
    result := 0;
    for i:=2 to Length(aStr) do
      begin
        result := result XOR Ord(Char(aStr[i]));
      end;
end;

procedure TForm4.cbParamsChange(Sender: TObject);
begin
    if FLoading then exit;
    TraceLog('cbParamsChange',el_Debug);
    Com_ParamsChange();
end;

procedure TForm4.Com_ParamsChange();
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
end;


procedure TForm4.cb_autodetectClick(Sender: TObject);
begin
   if FLoading then exit;
   TraceLog('cb_autodetectClick',el_Debug);
   ParamEcran;
   Com_ParamsChange;
end;

procedure TForm4.ParamEcran;
begin
   edtSearchTPENAME.Visible := cb_autodetect.checked;
end;


procedure TForm4.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    If Assigned(Transaction)
      then Transaction.DisposeOf;
    if Assigned(CommunicationPortCom)
      then CommunicationPortCom.DisposeOf;
    VAComm1.Close;
end;

procedure TForm4.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  // Minimize application instead of closing
  CanClose := False;
  Self.Hide;
  //   Application.Minimize;
  // Remove the main form from the Task bar
  //  Self.Hide;
end;

procedure TForm4.Paramtrage1Click(Sender: TObject);
begin
  pgc.ActivePage:=tsParametrage;
  ParamEcran;
  Application.Restore;
  Application.BringToFront;
  Self.Show;
end;

procedure TForm4.PortOpenClose(CP: TObject; Opened: Boolean);
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

procedure TForm4.SaveIni();
var sFic    : string;
    FicIni  : TIniFile;
begin
  TraceLog('Save_Ini',el_Info);
  if FSaving then exit;
  sFic := ChangeFileExt(Application.ExeName, '.ini');
  if FileExists(sFic) then begin
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
      FicIni.WriteBool('PortCom', 'AutoDetect', cb_autodetect.Checked);
      TraceLog(Format('AutoDetect : %s',[BoolToStr(cb_autodetect.Checked,true)]),el_Info);
      FicIni.WriteString('PortCom', 'SearchTPEName',edtSearchTPENAME.Text);
      TraceLog(Format('SearchTPEName : %s',[edtSearchTPENAME.Text]),el_Info);
    finally
     FicIni.Free;
    end;
  end;
end;

procedure TForm4.ListPortCom();
var i:integer;
    vList: TStringList;
    j: Integer;
    bFound:boolean;
    mIndex : Integer;
    mText  : string;
begin
    TraceLog('ListPortCom',el_Debug);
    FLoading := true;
    vList := Get_Serial_Ports;
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
                      cbPort.Items.Add(Format('%d - ',[i]));
              end;
        end;
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


procedure TForm4.DefaultHandler;
begin
  inherited DefaultHandler(Msg);
  if (TMessage(Msg).Msg) = MsgQuit then
    begin
       TraceLog('MsgQuit',el_Info);
       HandleAppliExt:=(TMessage(Msg).WParam);
       Action_Quitter();
    end;
end;


procedure TForm4.FormCreate(Sender: TObject);
var i:integer;
    ReperTrace,ReperBase:string;
    Version : string;
begin
    FLoading := true;
    FAdmin   := false;

    // On encode tout les messages.
    HandleRecepteur := Form4.Handle;
    MsgQuit         := RegisterWindowMessage('SX_MsgSysKillTPEServ01');

    GetLocaleFormatSettings(GetThreadLocale, myFormatSettings);

    ReperBase := ExtractFilePath(ParamStr(0));
    if ReperBase[Length(ReperBase)]<>'\' then
      ReperBase := ReperBase+'\';
    ReperTrace := ReperBase+'LOG_TPE\';
    Log_Init(el_Info, ExtractFilePath(ReperTrace));
    Log_Write('Démarrage', el_Info);

    FTransaction                 := TTransaction.Create;
    FCommunicationPortCom        := TCommunicationPortCom.Create;
    Transaction.OrdreCaisse      := false;
    Transaction.RemoteAddress    := '127.0.0.1';
    Transaction.MontantCaisse    := 1;

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

    cb_autodetect.Checked := CommunicationPortCom.AutoDetectUSB;

    edtSearchTPENAME.Text := CommunicationPortCom.SearchTPEName;
    cbStopBits.Text       := CommunicationPortCom.StopBits;
    cbParity.ItemIndex    := CommunicationPortCom.Parity;

    lbl_gportcom.Caption   := IntToStr(CommunicationPortCom.PortComNumero);
    lbl_gvitesse.Caption   := cbVitesse.Text;
    lbl_gdatabits.Caption  := cbDataBits.text;
    lbl_gparity.Caption    := cbParity.Text;
    lbl_gStopBit.Caption   := cbstopBits.Text;

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

procedure TForm4.FormDestroy(Sender: TObject);
begin
 if Assigned(FTimerThread) and not(FTimerThread.ExternalThread)
  then FTimerThread.FinishThreadExecution;
end;

end.
