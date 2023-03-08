unit Frm_Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, CPort, ExtCtrls, RzPanel, LMDCustomComponent, LMDWndProcComponent, LMDTrayIcon, ScktComp,
  Buttons, LMDNativeHint, LMDCustomHint, LMDCustomShapeHint, LMDMessageHint,UCommun,
  ImgList,ShellApi;

const
  WM_DOTRANSACTION  = WM_USER + 100;
  WM_ARRETER        = WM_USER + 101;
  WM_DEMARRE        = WM_USER + 102;
  WM_AFTERTHREAD    = WM_USER + 103;
  WM_FINTRANSACTION = WM_USER + 104;
  WM_AUTODETECTUSB  = WM_USER + 105;

type

  TThreadDelai = Class(TThread)
  private
    FDebut: DWord;
    FDelai: DWord;
  public
    constructor Create(ADelai: DWord);
    procedure Execute; override;
  end;

  TDialogTPE = record
    Etat : string;
  end;

  TPortCom = record
    Etat : string;
  end;

  TMyTransaction = (ttNone, ttPresence, ttDebit, ttCheque, ttCredit, ttAnnulation,ttDuplicata);
  TTypeTrameTPE = (trNone,trEnvoi,trReception);

  // Une transaction est un echange entre la caisse et TPEServ
  TTransaction = record
    bAncienneVersion: boolean;   // <---- à ne plus utiliser
    Resultat : integer;
    State: integer;
    AdrIP: string;
    // TypeTransac: string;    // <-- à ne pas utilisert
    NoCaisse: integer;
    Mnt: Double;
    RetCarte: string;
    NumCB: string;
    NumChq: string;
    LastEnvoi: String;
    // bCheq: boolean;              // <---- à ne plus utiliser utiliser plutot TTransaction
    TypeTransaction : TMyTransaction;
  end;

  TMain_Frm = class(TForm)
    MainMenu1: TMainMenu;
    Menu1: TMenuItem;
    MN_Param: TMenuItem;
    MN_COMDeconnect: TMenuItem;
    RzPanel1: TRzPanel;
    RzPanel2: TRzPanel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Lab_NumPort: TLabel;
    Lab_Vitesse: TLabel;
    Lab_Bitdonnee: TLabel;
    Lab_Parite: TLabel;
    Lab_BitArret: TLabel;
    Lab_StatutCom: TLabel;
    Lab_Statut: TLabel;
    Lab_TitErreurCom: TLabel;
    Lab_ErreurCom: TLabel;
    MN_TestTPE: TMenuItem;
    RzPanel3: TRzPanel;
    RzPanel4: TRzPanel;
    Label1: TLabel;
    Lab_Communication: TLabel;
    Tray: TLMDTrayIcon;
    TrayMenu: TPopupMenu;
    Afficher1: TMenuItem;
    MN_Param2: TMenuItem;
    MN_COMDeconnect2: TMenuItem;
    MN_Quitter: TMenuItem;
    Label2: TLabel;
    Lab_Transac: TLabel;
    GroupBox1: TGroupBox;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Lab_LastComm: TLabel;
    Lab_LastTransac: TLabel;
    Lab_LastResult: TLabel;
    Serveur: TServerSocket;
    N2: TMenuItem;
    Quitter1: TMenuItem;
    Tps_TimeOut: TTimer;
    ComPort: TComPort;
    MN_ReInit2: TMenuItem;
    MN_ReInit: TMenuItem;
    Tim_RessaiPresTPE: TTimer;
    Lab_ModeTracing: TLabel;
    MsgHint: TLMDMessageHint;
    il1: TImageList;
    il2: TImageList;
    img1: TImage;
    tmrTps_idle_com_close: TTimer;
    N1: TMenuItem;
    TimerUSBDetect: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure TrayDblClick(Sender: TObject);
    procedure MN_COMDeconnectClick(Sender: TObject);
    procedure MN_ParamClick(Sender: TObject);
    procedure MN_QuitterClick(Sender: TObject);
    procedure ServeurClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure ServeurClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure MN_TestTPEClick(Sender: TObject);
    procedure Tps_TimeOutTimer(Sender: TObject);
    procedure ComPortRxChar(Sender: TObject; Count: Integer);
    procedure ComPortAfterOpen(Sender: TObject);
    procedure ComPortBeforeClose(Sender: TObject);
    procedure MN_ReInitClick(Sender: TObject);
    procedure Tim_RessaiPresTPETimer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ServeurClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ComPortError(Sender: TObject; Errors: TComErrors);
    procedure ComPortException(Sender: TObject; TComException: TComExceptions;
      ComportMessage: string; WinError: Int64; WinMessage: string);
    procedure ComPortAfterClose(Sender: TObject);
    procedure ComPortBeforeOpen(Sender: TObject);
    procedure tmrTps_idle_com_closeTimer(Sender: TObject);
  private
    { Déclarations privées }
    FDialogTPE  : TDialogTPE;   // Dialoge avec le TPE Maitre ou Esclave
    FPortCom    : TPortCom;

    Version : string;
    DelaiDecompte: DWord;
    ThreadLance: boolean;
    LstEnvoi: TStringList;
    bGopen   : Boolean;

//    bOkTrace     : boolean;  // à true = enregistre les traces de transaction mettre OKTRACE en paramètre
    LastComm     : string;   // transaction dernière communication
    LastTransac  : string;   // dernière transaction demandée
    LastResultat : string;   // resultat de la transaction terminée

    Transaction: TTransaction;

    bAncienneVersion: boolean;  // ancienne version de la caisse

    AttenteTransac:boolean;    // attente de la fin de la transaction

    ReEssai : boolean;   // relancer le test tpe, s'il a echoué une fois
    bOccupe: boolean;
//    bOkPresenceTPE: boolean;      // à true si c'est le test TPE
//    ResultPresenceTPE: boolean;   // result de test de présence
//    bTestTPE: boolean;              // Variable indiquant qu'on est en test de la connexion TPE
//    bStopTestTPE: boolean;
    bCOMOuvert: boolean; // Statut du Port COM
    ReperBase: string;   // repertoire de l'exe
    ReperTrace: string;

    bForceComClose: boolean;
//    bForceDefaultParamCom  : boolean;

    // variable interne au processus de la transaction
    TPE_Etat:integer;
    TPE_Envoi:array [0..50] of byte;
    TPE_Octet_Recu:integer;
    TPE_ResuCheck:integer;
    TPE_TrameRecep:Array [0..512] of byte;
    //TPE_OkMaitre:boolean;
    TPE_ResuTransac: integer;

    // Decode des montants Envoyé et Recu dans le dialogue avec le TPE
    EtatEcran: boolean;

    Montant_Envoye : Double;
    Montant_Recu   : Double;

    procedure DecodeTrame(ATypeTrame:TTypeTrameTPE;ATrame:Array of byte);

    procedure MonSleep(ADelai: integer);
    procedure InitTransaction(var ATransaction:TTransaction);

    procedure TerminateThread(Sender: TObject);
    procedure SupprimeTrace;
    procedure EnregistreTrace(AInfo: string);
    procedure SendToClient(AReponse: string; const Forced: boolean = false);
    procedure ArreterTransaction;
    procedure FinTransaction;
    function OuvrePortCOM: integer;
    procedure FermePortCOM;
    procedure LireParam;
    procedure SaveParam;
    function CheckTrame(const bRecu:array of byte;Count:integer):boolean;
    procedure TraiteEnvoi(const bEnvoi:array of byte;Count:integer);
    procedure TraiteRecu(const bRecu:array of byte;Count:integer);
    procedure DoLibDerniereErreurCOM(ANoErreur: integer);
    procedure DoLibStatutCOM(ACOMStatus: integer);
    procedure DoDemarre(var M:TMessage); message WM_DEMARRE;
    procedure DoTransaction(var M:TMessage); message WM_DOTRANSACTION;
    procedure DoArreter(var M:TMessage); message WM_ARRETER;
    procedure DoAfterThread(var M:TMessage); message WM_AFTERTHREAD;
    procedure DoFinTransaction(var M:TMessage); message WM_FINTRANSACTION;
    procedure DoAutoDetectUSB(var M:TMessage);  message WM_AUTODETECTUSB;

    procedure WMDeviceChange(var M:TMessage); message WM_DEVICECHANGE;
    procedure Auto_Detection;
    function GetDialogTPEEtat:string;
    procedure SetDialogTPEEtat(aValue:string);
    function GetPortComEtat:string;
    procedure SetPortComEtat(aValue:string);
    function PrintTrame(const bTrame: array of byte; Count: integer):string;
    function TestPresenceTPE:Boolean;
    procedure Ouvre_Fenetre_Parametrage;
    procedure SaveParamPortCom;
  public
    { Déclarations publiques }
  published
    property DialogTPEEtat:string read GetDialogTPEEtat write SetDialogTPEEtat;
    property ComEtat      :string read GetPortComEtat   write SetPortComEtat;
  end;
   procedure RemoveDeadIcons;
var
  Main_Frm: TMain_Frm;

implementation  


uses
  uVersion, IniFiles, uCsteTPE, uResTPE, Frm_Parametrage;

{$R *.dfm}

{ TDialogTPE }
function TMain_Frm.GetDialogTPEEtat:string;
begin
     result:=FDialogTPE.Etat;
end;

procedure TMain_Frm.SetDialogTPEEtat(AValue:string);
begin
     // Permet de voir les "vrais" changement d'etat (Maitre) ou (Esclave)
     // EnregistreTrace('**** Avalue = ****'+Avalue);
     // EnregistreTrace('**** FDialogTPE.Etat = ****'+FDialogTPE.Etat);
     if (FDialogTPE.Etat<>Avalue)
        then
        begin
             If Avalue='Maitre'
               then EnregistreTrace('**** --->  TPEServ Maitre ---> ****');
             If Avalue='Esclave'
               then EnregistreTrace('**** <---  TPEServ Esclave <--- ****');
             FDialogTPE.Etat := AValue;
        end;
end;

{ TPortCom }

function TMain_Frm.GetPortComEtat:string;
begin
     result:=FPortCom.Etat;
end;

procedure TMain_Frm.SetPortComEtat(AValue:string);
begin
     FPortCom.Etat:=AValue;
     EnregistreTrace('PortCom := '+ AValue);
     //-------------------------------------------------------------------------
     MN_COMDeconnect.Enabled  := (aValue<>TXT_ComFerme);
     MN_COMDeconnect2.Enabled := (aValue<>TXT_ComFerme);
     MN_ReInit.Enabled        := (aValue<>TXT_ComFerme);
     MN_ReInit2.Enabled       := (aValue<>TXT_ComFerme);
end;

{ TThreadDelai }

constructor TThreadDelai.Create(ADelai: DWord);
begin
  FDebut := GetTickCount;
  FDelai := ADelai;
  FreeOnTerminate := true;
  inherited Create(True);
end;

procedure TThreadDelai.Execute;
begin
  inherited;
  While GetTickCount-FDebut<FDelai do
  begin
    Sleep(1);
  end;
end;

procedure RemoveDeadIcons;
var
  wnd : cardinal;
  rec : TRect;
  w,h : integer;
  x,y : integer;
begin
    wnd := FindWindow('Shell_TrayWnd', nil);
    wnd := FindWindowEx(wnd, 0, 'TrayNotifyWnd', nil);
    wnd := FindWindowEx(wnd, 0, 'SysPager', nil);
    wnd := FindWindowEx(wnd, 0, 'ToolbarWindow32', nil);
    windows.GetClientRect(wnd, rec);
    w := GetSystemMetrics(sm_cxsmicon);
    h := GetSystemMetrics(sm_cysmicon);
    y := w shr 1;
    while y < rec.Bottom do begin // while y < height of tray
      x := h shr 1;                                        // initial x position of mouse - half of width of icon
      while x < rec.Right do begin // while x < width of tray
                   SendMessage(wnd, wm_mousemove, 0, y shl 16 or x); // simulate moving mouse over an icon
                   x := x + w; // add width of icon to x position
      end;
      y := y + h; // add height of icon to y position
    end;
end;

procedure  TMain_Frm.WMDeviceChange(var M:TMessage);
const
  DBT_DEVNODES_CHANGED = $0007;      // Changement sur les USB
begin
  inherited;
  case M.wParam of
    DBT_DEVNODES_CHANGED:
        begin
             EnregistreTrace('Event PnP : $0007 : Détection USB');
             PostMessage(handle, WM_AUTODETECTUSB, 0, 0);
             // permet d'executer la transaction immediatement après être sorti de cette procedure
             Sleep(1000);
        end;
  end;
end;

function TMain_Frm.TestPresenceTPE:Boolean;
begin
     result := (TestPresenceTPE_WMI_HKLM('COM'+intToStr(iNumPort),bautoDetect,sSearchTPENAME));
end;

procedure TMain_Frm.TerminateThread(Sender: TObject);
begin
  PostMessage(Handle, WM_AFTERTHREAD, 0, 0);
end;

procedure TMain_Frm.SupprimeTrace;
var
  sl: TStringList;
  i, resu: integer;
  Search: TSearchRec;
  sTemp: string;
begin
  if (ReperTrace='') or not(DirectoryExists(ReperTrace)) then
    exit;

  // supprime les log de plus de 20 jours
  sl := TStringList.Create;
  try
    resu := FindFirst(ReperTrace+'LOG_SrvTPE*.*', faAnyFile, Search);
    while (resu=0) do
    begin
      sTemp := ExtractFileName(Search.Name);
      if (sTemp<>'.') and (sTemp<>'..') and ((Search.Attr and faDirectory)<>faDirectory) then
      begin
        try
          if Trunc(FileDateToDateTime(FileAge(ReperTrace+sTemp)))<Trunc(Date)-20 then
            sl.Add(ReperTrace+sTemp);
        except
        end;
      end;
      resu := FindNext(Search);
    end;
    FindClose(Search);
    for i:=1 to sl.Count do
    begin
      try
        DeleteFile(sl[i-1]);
      except  // pas grave si ça ne fonctionne pas
      end;
    end;
  finally
    sl.Free;
    sl := nil;
  end;

end;

procedure TMain_Frm.EnregistreTrace(AInfo: string);
var
  AFilename: string;
  sLigne: Ansistring;
  Stream: TFileStream;
begin
  if not(bOkTrace) or (ReperTrace='') then
    exit;
  try
     AFilename := ReperTrace+'LOG_SrvTPE -'+FormatDateTime('yyyy-mm-dd',Date)+'.txt';
     sLigne :=  AnsiString('['+FormatDateTime('dd/mm/yyyy hh:nn:ss:zzz',now) + '] : ' + AInfo + #13#10);
     Stream := nil;
     try
       if not(DirectoryExists(ReperTrace)) then
         ForceDirectories(ReperTrace);

       if FileExists(AFileName) then
        begin
          Stream := TFileStream.Create(AFileName, fmOpenWrite);
          Stream.Seek(0, soFromEnd);
        end
        else
        Stream := TFileStream.Create(AFileName, fmCreate);
       try
           Stream.Write(Pointer(sLigne)^, Length(sLigne));
        Finally
            FreeAndNil(Stream);
       end;
       except
             on E:Exception
             do MessageDlg('GR:'+E.Message, mtError, [mbOK], 0);
       end;
     except
           on E:Exception
            do MessageDlg('GR:'+E.Message, mtError, [mbOK], 0);
     end;
end;

{ ---------------------------------- Auto Detection ---------------------------}

Procedure TMain_Frm.Auto_Detection;
var bfind:boolean;
    s1:TStringList;
    TPE_port:string;
    i:Integer;
begin
   Tray.Animated:=false;
   if (bAutodetect) then
    begin
         EnregistreTrace('<Auto_Detection>');
         s1:=Get_Serial_Ports;
         try
           TPE_port:=Auto_Detect_TPE(sSearchTPEName);
           bfind:=false;
           for i := 0 to s1.Count-1 do
               begin
                    if AnsiPos(Format('(%s)',[TPE_port]),s1.Strings[i])>1 then
                        begin
                             // théoriquement c'est le bon n° de port
                             iNumPort := StrToIntDef(Copy(TPE_port,4,length(TPE_port)),0);
                             bfind:=True;
                        end;
               end;
           Tray.Animated:=not(bfind);
           // Si la fenetre Parametrage est ouverte....
           if Parametrage_Frm<>nil then
            begin
                 TComboBox(Parametrage_Frm.CPort).Items.Assign(s1);
                 If (bfind) then
                    begin
                      for i := 0 to s1.Count-1 do
                        begin
                          If Pos(Format('(COM%d)',[iNumPort]),TComboBox(Parametrage_Frm.CPort).Items[i])>=1 then
                            begin
                               TComboBox(Parametrage_Frm.CPort).ItemIndex:=i;
                            end;
                        end;
                    end;
            end;
           Img1.Picture:=nil;
           Img1.Transparent:=true;
           if bfind
            then il2.GetBitmap(1, Img1.Picture.Bitmap)
            else il2.GetBitmap(0, Img1.Picture.Bitmap);
           if bFind then SaveParamPortCom;
           Application.ProcessMessages;
         finally
           s1.Free;
           EnregistreTrace(Format('Nouveau N° Port : %d',[iNumPort]));
           // il faut le mettre a jour dans le .ini
         end;
         if (iNumPort<=0) or (iNumPort>99) then
           iNumPort:=1;
    end
    else  Img1.Picture:=nil;

end;

procedure TMain_Frm.LireParam;
var
  sFic: string;
  FicIni:TIniFile;
  sLigne: string;
  OSinfos:TOSInfos;
begin
  iNumPort:=1;               // N° de port COM
  bautoDetect:=false;        // Autodection du Port Com "SAGEM MONETEL"
  sSearchTPEName:='SAGEM MONETEL'; // Chaine a rechercher lors de l'autodedection
  iVitesse:=vBaudRate1200;   // Vitesse port COM
  iBits:=vBits7;             // Bits de données COM
  iParite:=vParitePaire;     // Parité Port COM
  iArret:=vArretOneStop;     // Bit d'arret port COM
  DelaiTimeOut := 2500;      // delai au bout duquel un déclanchement TimeOut se produit
  NumTPE := 1;               // numero du TPE (de 1 à 99)
//  bForceDefaultParamCom := True; //
  bOkTrace:=false;

  PortEcouteSrv := 31324;    // Port d'écoute du TServerSocket
  sFic := ChangeFileExt(Application.ExeName, '.ini');
  if FileExists(sFic) then begin
    FicIni:=TIniFile.Create(sFic);
    try
      iNumPort := FicIni.ReadInteger('PortCOM', 'NumPort', 0);
      if iNumPort=0 then   // ancienne ini
         iNumPort := FicIni.ReadInteger('PORT', 'COM', iNumPort);

      bAutodetect     := FicIni.ReadBool('PortCom', 'AutoDetect', False);
      sSearchTPEName  := FicIni.ReadString('PortCom', 'SearchTPENAME', sSearchTPEName);
//      bForceDefaultParamCom := FicIni.ReadBool('PortCom', 'ForceDefaultParamCom', bForceDefaultParamCom);

      iVitesse  := FicIni.ReadInteger('PortCOM', 'Vitesse', iVitesse);
      iBits     := FicIni.ReadInteger('PortCOM', 'Bits', iBits);
      iParite   := FicIni.ReadInteger('PortCOM', 'Parite', iParite);
      iArret    := FicIni.ReadInteger('PortCOM', 'Arret', iArret);

      PortEcouteSrv := FicIni.ReadInteger('Serveur','Port', PortEcouteSrv);

      DelaiTimeOut := FicIni.ReadInteger('TPE','DelaiTimeOut',DelaiTimeOut);
      NumTPE := FicIni.ReadInteger('TPE','NumeroTPE',NumTPE);
      bOkTrace := FicIni.ReadBool('TPE', 'OkTrace', true);

    finally
      FreeAndNil(FicIni);
    end;
  end;

  Auto_Detection;

  // MessageDlg(sSearchTPENAME, mtWarning, [mbOK], 0);

  if (iNumPort<=0) or (iNumPort>99) then
    iNumPort:=1;

  // info sur l'écran
  Lab_NumPort.Caption:=inttostr(iNumPort);

  Lab_Vitesse.Caption := inttostr(iVitesse);

  Lab_Bitdonnee.Caption := inttostr(iBits);

  case iParite of
    vParitePaire  : Lab_Parite.Caption := ParitePaire;
    vPariteImpaire: Lab_Parite.Caption := PariteImpaire;
    vPariteAucune : Lab_Parite.Caption := PariteAucune;
    vPariteMarque : Lab_Parite.Caption := PariteMarque;
    vPariteEspace : Lab_Parite.Caption := PariteEspace;
  else
    Lab_Parite.Caption := TXT_Erreur;
  end;

  case iArret of
    vArretOneStop : Lab_BitArret.Caption := '1';
    vArretOne5Stop: Lab_BitArret.Caption := '1,5';
    vArretTwoStop : Lab_BitArret.Caption := '2';
  else    
    Lab_BitArret.Caption := TXT_Erreur;
  end;

  if (NumTPE<=0) or (NumTPE>99) then
    NumTPE := 1;

  // info de trace
   if not(EtatEcran) then
   begin
     SupprimeTrace;
   end;

  sLigne := 'Démarrage programme : Version ['+ Version +']'+#13#10;
  if bOkTrace
      then
          begin
               OSinfos := GetOsInfos;
               sLigne := sLigne+'OS.Version     : '+ OSinfos.WinVersion     + #13#10;
               sLigne := sLigne+'OS.Systeme     : '+ OSinfos.OSArchitecture + #13#10;
               sLigne := sLigne+'OS.ServicePack : '+ OSinfos.ServicePack + #13#10;
               sLigne := sLigne+'OS.BuildNumber : '+ OSinfos.BuildNumber + #13#10;
          end;

  sLigne := sLigne+'Lecture paramètre'+#13#10;
  sLigne := sLigne+'N° Port: '+inttostr(iNumPort)+#13#10;

  if bautoDetect
    then sLigne := sLigne+Format('Auto Dectect "%s": Oui',[sSearchTPEName])+#13#10
    else sLigne := sLigne+Format('Auto Dectect "%s": Non',[sSearchTPEName])+#13#10;

  sLigne := sLigne+'Vitesse: '+inttostr(iVitesse)+#13#10;
  sLigne := sLigne+'Bits de données: '+inttostr(iBits)+#13#10;
  sLigne := sLigne+'Parité: ';
  case iParite of
    vParitePaire  : sLigne := sLigne+ParitePaire+#13#10;
    vPariteImpaire: sLigne := sLigne+PariteImpaire+#13#10;
    vPariteAucune : sLigne := sLigne+PariteAucune+#13#10;
    vPariteMarque : sLigne := sLigne+PariteMarque+#13#10;
    vPariteEspace : sLigne := sLigne+PariteEspace+#13#10;
  else
    sLigne := sLigne+TXT_Erreur+#13#10;
  end;
  sLigne := sLigne+'Bit d''arrêt: ';
  case iArret of
    vArretOneStop : sLigne := sLigne+'1'+#13#10;
    vArretOne5Stop: sLigne := sLigne+'1,5'+#13#10;
    vArretTwoStop : sLigne := sLigne+'2'+#13#10;
  else
    sLigne := sLigne+TXT_Erreur+#13#10;
  end;
  EnregistreTrace(sLigne);
  Lab_ModeTracing.Visible := bOkTrace;

  // Si problème et pas déjà affiché le message alors on l'affiche
  If Not(TestPresence_Com_HKLM_DEVICEMAP('COM'+intToStr(iNumPort))) and not(bWarningStartMessage) then
    begin
         MessageDlg('Configuration TPE incomplète.'+#13+#10+'Veuillez ouvrir la fenêtre de paramétrage '+#13+#10+'ou contacter le Service Client de Ginkoia.', mtWarning, [mbOK], 0);
         bWarningStartMessage:=true;
         Ouvre_Fenetre_Parametrage;
    end;

end;

{ ----- Ne doit servir uniquement en mode autdection ---------------------------}
procedure TMain_Frm.SaveParamPortCom;
var sFic: string;
    FicIni:TIniFile;
begin
  if not(bautoDetect) then exit;
  sFic := ChangeFileExt(Application.ExeName, '.ini');
  FicIni:=TIniFile.Create(sFic);
  try
    FicIni.WriteInteger('PortCOM', 'NumPort', iNumPort);
  finally
    FreeAndNil(FicIni);
  end;
end;

procedure TMain_Frm.SaveParam;
var
  sFic: string;
  FicIni:TIniFile;
  sLigne: string;
begin   
  sFic := ChangeFileExt(Application.ExeName, '.ini');
  FicIni:=TIniFile.Create(sFic);
  try
    FicIni.WriteInteger('PortCOM', 'NumPort', iNumPort);
    FicIni.WriteBool('PortCom', 'AutoDetect', bautoDetect);
   // FicIni.WriteBool('PortCom','ForceDefaultParamCom',bForceDefaultParamCom);
    FicIni.WriteBool('TPE', 'OkTrace', bOkTrace);

    FicIni.WriteString('PortCom', 'SearchTPEName',sSearchTPENAME);
    FicIni.WriteInteger('PortCOM', 'Vitesse', iVitesse);
    FicIni.WriteInteger('PortCOM', 'Bits', iBits);
    FicIni.WriteInteger('PortCOM', 'Parite', iParite);
    FicIni.WriteInteger('PortCOM', 'Arret', iArret);

    FicIni.WriteInteger('Serveur','Port',PortEcouteSrv);

    FicIni.WriteInteger('TPE','DelaiTimeOut',DelaiTimeOut);
    FicIni.WriteInteger('TPE','NumeroTPE',NumTPE);

  finally
    FreeAndNil(FicIni);
  end;

  // info de trace
  sLigne := 'Sauvegarde paramètre'+#13#10;
  sLigne := sLigne+'N° Port: '+inttostr(iNumPort)+#13#10;

  if bautoDetect
    then sLigne := sLigne+Format('Auto Dectect "%s": Oui',[sSearchTPEName])+#13#10
    else sLigne := sLigne+Format('Auto Dectect "%s": Non',[sSearchTPEName])+#13#10;

  sLigne := sLigne+'Vitesse: '+inttostr(iVitesse)+#13#10;
  sLigne := sLigne+'Bits de données: '+inttostr(iBits)+#13#10;
  sLigne := sLigne+'Parité: ';
  case iParite of
    vParitePaire  : sLigne := sLigne+ParitePaire+#13#10;
    vPariteImpaire: sLigne := sLigne+PariteImpaire+#13#10;
    vPariteAucune : sLigne := sLigne+PariteAucune+#13#10;
    vPariteMarque : sLigne := sLigne+PariteMarque+#13#10;
    vPariteEspace : sLigne := sLigne+PariteEspace+#13#10;
  else
    sLigne := sLigne+TXT_Erreur+#13#10;
  end;
  sLigne := sLigne+'Bit d''arrêt: ';
  case iArret of
    vArretOneStop : sLigne := sLigne+'1'+#13#10;
    vArretOne5Stop: sLigne := sLigne+'1,5'+#13#10;
    vArretTwoStop : sLigne := sLigne+'2'+#13#10;
  else
    sLigne := sLigne+TXT_Erreur+#13#10;
  end;
  EnregistreTrace(sLigne);
end;

procedure TMain_Frm.SendToClient(AReponse: string; const Forced: boolean = false);
var
  i: integer;
  ThDelai : TThreadDelai;
begin
  EnregistreTrace('<SendToClient.Debut>');
  EnregistreTrace('Reponse :' + AReponse);
  if not(Serveur.Active) then
    begin
         EnregistreTrace('TSocketServeur inactif : break ');
         EnregistreTrace('<SendToClient.Fin>');
         exit;
    end;

  if (Transaction.AdrIP='LOCAL') then
    begin
         EnregistreTrace('Transaction.AdrIP=LOCAL : break ');
         EnregistreTrace('<SendToClient.Fin>');
         exit;
    end;
  // Sinon on met la réponse

  if ((DelaiDecompte-GetTickCount<150) or ThreadLance) and not(Forced) then
  begin
    LstEnvoi.Add(AReponse);
    DelaiDecompte := GetTickCount;
    if not(ThreadLance) then
    begin
      ThreadLance := true;
      ThDelai := TThreadDelai.Create(150);
      ThDelai.OnTerminate := TerminateThread;
      ThDelai.Start;
      EnregistreTrace('<SendToClient / ThreadLance>');
    end;
    exit;
  end;

  for i := 1 to Serveur.Socket.ActiveConnections do
  begin
    try
      if Serveur.Socket.Connections[i-1].RemoteAddress=Transaction.AdrIP then
         Serveur.Socket.Connections[i-1].SendText(AnsiString(AReponse));
    except
          On E:Exception
             do
             begin
                  EnregistreTrace('Exception : SendToClient / ActiveConnections');
                  EnregistreTrace(Format('ClassName : %s '+#13+#10+'Msg : %s',[E.ClassName,E.Message]));
             end;
    end;
  end;
  EnregistreTrace('<SendToClient.Fin>');
  DelaiDecompte := GetTickCount;
end;

procedure TMain_Frm.ServeurClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  Transaction.LastEnvoi := '';
  Transaction.AdrIP := '';
end;

procedure TMain_Frm.ServeurClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  ErrorCode := 0;
end;

procedure TMain_Frm.ServeurClientRead(Sender: TObject; Socket: TCustomWinSocket);
var
  sRcv: string;
  sAdrIP: string;
  sMnt: string;
  Mnt: double;
begin
  sRcv := String(Socket.ReceiveText);

  EnregistreTrace('Reçu de la caisse: '+sRcv);

  if Length(sRcv)=0 then exit;

  sAdrIP := Socket.RemoteAddress;

  // ancienne caisse ou nouvelle ?
  bAncienneVersion := ((sRcv[1]='?') or (sRcv[1]='!'));

  if (sRcv[1]='?') or (sRcv[1]='>') then
  begin
    // transaction déjà en cours
    if bOccupe then
    begin
      EnregistreTrace('OCCUPE>Exit');
      Socket.SendText('OCCUPE');
      exit;
    end;

    if (sRcv='?TPE') or (sRcv='>TPE') then // demande présence TPE
    begin
      ReEssai := false;
      Transaction.bAncienneVersion := (sRcv='?TPE');
      Transaction.AdrIP := sAdrIP;
      Transaction.TypeTransaction := ttPresence;
      Transaction.NoCaisse := NumTPE;
      Transaction.Resultat := 99;
      Transaction.State := 99;
      Transaction.Mnt := 0.0;
      Transaction.LastEnvoi := '';
      PostMessage(handle, WM_DOTRANSACTION, 0, 0);  // permet d'executer la transaction immediatement après être sorti de la procedure ServeurClientRead
      exit;
    end
    else if (Pos('?MT;', sRcv)=1) or (Pos('>MT;', sRcv)=1) then  // demande débit CB
    begin
      sMnt := Copy(sRcv, Pos(';', sRcv)+1, Length(sRcv));
      if Pos(',', sMnt)>0 then
        sMnt[Pos(',', sMnt)] := FormatSettings.DecimalSeparator;
      if Pos('.', sMnt)>0 then
        sMnt[Pos('.', sMnt)] := FormatSettings.DecimalSeparator;
      Mnt := StrToFloatDef(sMnt, 0.0);
      if Mnt<=0.01 then  // montant invalide  // 0.01
      begin
        SendToClient('NACK');
        Transaction.LastEnvoi := 'NACK';
        exit;
      end;

      ReEssai := false;
      Transaction.bAncienneVersion := (Pos('?MT;', sRcv)=1);
      Transaction.AdrIP := sAdrIP;
      Transaction.TypeTransaction := ttDebit;
      Transaction.NoCaisse := NumTPE;
      Transaction.Resultat := 99;
      Transaction.State := 99;
      Transaction.Mnt := Mnt;
      Transaction.LastEnvoi := '';
      PostMessage(handle, WM_DOTRANSACTION, 0, 0);  // permet d'executer la transaction immediatement après être sorti de la procedure ServeurClientRead
      exit;
    end
    else if (Pos('?CHQ;', sRcv)=1) or (Pos('>CHQ;', sRcv)=1) then  // demande débit chèque
    begin
      sMnt := Copy(sRcv, Pos(';', sRcv)+1, Length(sRcv));
      if Pos(',', sMnt)>0 then
        sMnt[Pos(',', sMnt)] := FormatSettings.DecimalSeparator;
      if Pos('.', sMnt)>0 then
        sMnt[Pos('.', sMnt)] := FormatSettings.DecimalSeparator;
      Mnt := StrToFloatDef(sMnt, 0.0);
      if Mnt<=0.01 then  // montant invalide // 0.01
      begin
        SendToClient('NACK');
        Transaction.LastEnvoi := 'NACK';
        exit;
      end;

      ReEssai := false;
      Transaction.bAncienneVersion := (Pos('?CHQ;', sRcv)=1);
      Transaction.AdrIP := sAdrIP;
      Transaction.TypeTransaction := ttCheque;
      Transaction.NoCaisse := NumTPE;
      Transaction.Resultat := 99;
      Transaction.State := 99;
      Transaction.Mnt := Mnt;
      Transaction.LastEnvoi := '';
      PostMessage(handle, WM_DOTRANSACTION, 0, 0);  // permet d'executer la transaction immediatement après être sorti de la procedure ServeurClientRead
      exit;
    end
    else
    begin
      Transaction.LastEnvoi := 'NACK';
      SendToClient('NACK');
      exit;
    end;
  end;  //if sRcv[1]='?' then

  if sRcv[1]='!' then
  begin
    Transaction.AdrIP := sAdrIP;
    if sRcv='!CANCEL' then
    begin
      ArreterTransaction;
    end
    else
    begin
      case Transaction.Resultat of
        -1:
        begin
          Transaction.LastEnvoi := 'TIMEOUT';
          SendToClient('TIMEOUT');          // Time Out
        end;
        1:        // transaction Ok
        begin
          case Transaction.TypeTransaction of
            ttCheque:
              begin
                SendToClient('OK;C;'+Transaction.NumChq);
                Transaction.LastEnvoi := 'OK;C;'+Transaction.NumChq;
              end;
            ttDebit:
              begin
                SendToClient('OK;B;'+Transaction.NumCB);
                Transaction.LastEnvoi := 'OK;B;'+Transaction.NumCB;
              end;
          end;
           {--------------  Tout est OK on passe à l'etat 4  -------------------}
           TPE_Etat:=4;
           EnregistreTrace('INFO_2 : TPE_Etat:=4');
           Tps_TimeOut.Enabled:=False;
           AttenteTransac:=false;
           tmrTps_idle_com_close.Enabled:=true;  { <--- Nouveau Pour fermer le port com dans 10 secondes si inactivité }
           {--------------------------------------------------------------------}
      end;
        6,7,99:
        begin
          if not(bOccupe) and (Transaction.LastEnvoi<>'') then
            SendToClient(Transaction.LastEnvoi)
          else
            SendToClient('ENCOURS;' + Inttostr(Transaction.State));  // transaction en cours
        end;
      else
        SendToClient('NACK');  // erreur
        Transaction.LastEnvoi := 'NACK';
      end;
    end;
  end;   // if sRcv[1]='!'


end;

procedure TMain_Frm.MN_COMDeconnectClick(Sender: TObject);
begin
  FermePortCOM;
end;

procedure TMain_Frm.MN_ParamClick(Sender: TObject);
begin
    Ouvre_Fenetre_Parametrage;
end;

procedure TMain_Frm.Ouvre_Fenetre_Parametrage;
begin
  FermePortCOM;
  Parametrage_Frm := TParametrage_Frm.Create(Self);
  try
    if Parametrage_Frm.ShowModal = mrOk then
    begin                          
      Screen.Cursor := crHourGlass;
      Application.ProcessMessages;
      try
        SaveParam;
        FermePortCOM;
        LireParam;
      finally
        Screen.Cursor := crDefault;
        Application.ProcessMessages;
      end;
    end;
  finally
    FreeAndNil(Parametrage_Frm);
  end;
end;

procedure TMain_Frm.MN_QuitterClick(Sender: TObject);
begin 
  Tray.NoClose := False;
  Close; 
end;

procedure TMain_Frm.MN_ReInitClick(Sender: TObject);
begin
  if bCOMOuvert then
  begin
    try
      ComPort.ClearBuffer(True, True);
    except
    end;
  end;
  FermePortCOM;
  Sleep(500);
  ReEssai := false;
  Transaction.bAncienneVersion := false;
  Transaction.AdrIP := 'LOCAL';
//  Transaction.TypeTransac := 'PRESENCE';
  Transaction.TypeTransaction := ttPresence;
  Transaction.NoCaisse := NumTPE;
  Transaction.State := 99;
  Transaction.Mnt := 0.0;
  PostMessage(handle, WM_DOTRANSACTION, 0, 0);  // permet d'executer la transaction immediatement après être sorti de la procedure ServeurClientRead
end;

procedure TMain_Frm.MN_TestTPEClick(Sender: TObject);
begin
{
  ReEssai := false;
  Transaction.bAncienneVersion := false;
  Transaction.AdrIP := 'LOCAL';
  Transaction.TypeTransac := 'PRESENCE';
  Transaction.NoCaisse := NumTPE;
  Transaction.State := 99;
  Transaction.Mnt := 0.0;
  PostMessage(handle, WM_DOTRANSACTION, 0, 0);
}
  //---------------------------------------

   // permet d'executer la transaction immediatement après être sorti de la procedure ServeurClientRead

    ReEssai := false;
    Transaction.bAncienneVersion := false;
    Transaction.AdrIP := 'LOCAL';
//    Transaction.TypeTransac := 'PRESENCE';
    Transaction.TypeTransaction := ttPresence;
    Transaction.NoCaisse := NumTPE;
    Transaction.State := 99;
    Transaction.Mnt := 0.0;
    PostMessage(handle, WM_DOTRANSACTION, 0, 0);
end;

function TMain_Frm.OuvrePortCOM: integer;
var
  vBaudRate:TBaudRate;
  sCOM:string;
  vBits:TDataBits;
  vParite:TParityBits;
  vArret:TStopBits;
begin
  try
     // FermePortCOM;
     bForceComClose := false;
     DoLibDerniereErreurCOM(0);
     Result := 0;
     Application.ProcessMessages;
     try
        // N° de port COM
        if (iNumPort<=0) or (iNumPort>99) then
        begin
          Result:=2;
          exit;
        end;
        sCOM:='COM'+inttostr(iNumPort);

        // Vitesse port COM
        case iVitesse of
          vBaudRate110    : vBaudRate := br110;
          vBaudRate300    : vBaudRate := br300;
          vBaudRate600    : vBaudRate := br600;
          vBaudRate1200   : vBaudRate := br1200;
          vBaudRate2400   : vBaudRate := br2400;
          vBaudRate4800   : vBaudRate := br4800;
          vBaudRate9600   : vBaudRate := br9600;
          vBaudRate14400  : vBaudRate := br14400;
          vBaudRate19200  : vBaudRate := br19200;
          vBaudRate38400  : vBaudRate := br38400;
          vBaudRate56000  : vBaudRate := br56000;
          vBaudRate57600  : vBaudRate := br57600;
          vBaudRate115200 : vBaudRate := br115200;
          vBaudRate128000 : vBaudRate := br128000;
          vBaudRate256000 : vBaudRate := br256000;
        else
          Result:=3;
          exit;
        end;

        //Bit de données du port Com
        case iBits of
          vBits5: vBits := dbFive;
          vBits6: vBits := dbSix;
          vBits7: vBits := dbSeven;
          vBits8: vBits := dbEight;
        else
          Result:=4;
          exit;
        end;

        //Parité du port Com
        case iParite of
          vParitePaire   : vParite := prEven;
          vPariteImpaire : vParite := prOdd;
          vPariteAucune  : vParite := prNone;
          vPariteMarque  : vParite := prMark;
          vPariteEspace  : vParite := prSpace;
        else
          Result:=5;
          exit;
        end;

        //bit d'arrêt du port Com
        case iArret of
          vArretOneStop  : vArret := sbOneStopBit;
          vArretOne5Stop : vArret := sbOne5StopBits;
          vArretTwoStop  : vArret := sbTwoStopBits;
        else
          Result:=6;
          exit;
        end;

        // affectation paramètre
        ComPort.Port:=sCOM;
        ComPort.BaudRate:=vBaudRate;
        ComPort.DataBits:=vBits;
        ComPort.Parity.Bits:=vParite;
        ComPort.StopBits:=vArret;

        // ouverture port COM
        try
          ComPort.Open;
          MN_COMDeconnect.Enabled := true;
          MN_COMDeconnect2.Enabled := true;
          MN_ReInit.Enabled := true;
          MN_ReInit2.Enabled := true;
          Application.ProcessMessages;
          if ComPort.Connected then
             result:=1   // Ok
             else
                begin
                      Result:=7;
                      EnregistreTrace('Erreur Ouverture COM');
                end;
          except
            on E: Exception do
            begin
              Result:=7;
              EnregistreTrace('Erreur Ouverture COM: '+E.Message);
            end;
        end;
       finally

      end;
  finally
        DoLibDerniereErreurCOM(Result);  // affiche la derniere erreur s'il y en a
  end;
end;

procedure TMain_Frm.DoAUTODETECTUSB(var M:TMessage);
begin
    Auto_Detection;
end;

procedure TMain_Frm.Tim_RessaiPresTPETimer(Sender: TObject);
begin
  Tim_RessaiPresTPE.Enabled := false;
  Application.ProcessMessages;
  FermePortCOM;
  Application.ProcessMessages;
  Sleep(1000);
  ReEssai := True;
  AttenteTransac := false;
  Application.ProcessMessages;
//  Transaction.TypeTransac := 'PRESENCE';
  Transaction.TypeTransaction := ttPresence;
  Transaction.Resultat := 99;
  Transaction.State := 99;
  Transaction.Mnt := 0.0;
  PostMessage(handle, WM_DOTRANSACTION, 0, 0);
end;

procedure TMain_Frm.tmrTps_idle_com_closeTimer(Sender: TObject);
begin
     tmrTps_idle_com_close.Enabled:=false;
     // Tracage de l'etat
     if ((SecondsIdle()>10) and (Transaction.TypeTransaction = ttNone) and (getPortComEtat='Ouvert'))
       then
           begin
                EnregistreTrace('<tmrTps_idle_com_close... va fermer le Port COm>');
                FermePortCOM;
           end
       else
           begin
                // On réactive pas : trop dangereux
                // tmrTps_idle_com_close.Enabled:=true;
           end;
end;

procedure TMain_Frm.Tps_TimeOutTimer(Sender: TObject);
begin
  try
     // Ca fait trop de log
     // EnregistreTrace('<Tps_TimeOutTimer>');
     if (DialogTPEEtat='Maitre') then
      begin
        Transaction.State := -99;
        Transaction.Resultat := -1;
        LastResultat := ERR_Trans_TPE_TimeOut;
        ArreterTransaction;
        if Transaction.bAncienneVersion then
        begin
          SendToClient('NACK');
          Transaction.LastEnvoi := 'NACK';
        end
        else
        begin
          SendToClient('ERR;TPE;1');
          Transaction.LastEnvoi := 'ERR;TPE;1';
        end;
        FermePortCOM;
        exit;
      end
      else
      begin
           if TPE_Etat=1 then
              exit;
           if TPE_Etat=2 then
            begin
             TPE_Etat := 1;
              if ComPort.Connected
                 then TraiteEnvoi(A_NAK,1);
            end;
           // Ajout du TPE Etat 3... parce que ca arrive... TRAVERS septembre 2015
           if TPE_Etat=3 then
            begin
              // dans quel etat mettre le dialogue...TPE ?
              EnregistreTrace('GR : MSG 333');
              if ComPort.Connected
                 then TraiteEnvoi(A_NAK,1);
            end;
            if TPE_Etat=4 then
              begin
                Tps_TimeOut.Enabled:=False;
                EnregistreTrace('GR : MSG 507');
                TPE_Etat := 1;
              end;
      end;
  except
      on E:EComPort
        do
          begin
              EnregistreTrace('Exception : Tps_TimeOutTimer');
              EnregistreTrace(Format('ClassName : EComPort'+#13+#10+'N° Erreur : %d'+#13+#10+'Msg : %s',[E.Code,E.Message]));
          end;
      on E:Exception
        do
          begin
               EnregistreTrace('Exception : Tps_TimeOutTimer');
               EnregistreTrace(Format('ClassName : %s '+#13+#10+'Msg : %s',[E.ClassName,E.Message]));
               // On arrete le Timer........? ou pas
               // Tps_TimeOut.Enabled:=False;
          end;
  end;
end;

procedure TMain_Frm.TraiteEnvoi(const bEnvoi: array of byte; Count: integer);
var sLigne:string;
begin
  try
    if not(ComPort.Connected) then exit;
    Sligne := ' --> ' + PrintTrame(bEnvoi,Count);
    EnregistreTrace(sLigne);
    ComPort.Write(bEnvoi,Count);
    Except
          on E:EComPort
             do
               begin
                   EnregistreTrace('Exception : TraiteEnvoi');
                   EnregistreTrace(Format('ClassName : EComPort'+#13+#10+'N° Erreur : %d'+#13+#10+'Msg : %s',[E.Code,E.Message]));
               end;
          On E:Exception
             do
             begin
                  EnregistreTrace('Exception : TraiteEnvoi');
                  EnregistreTrace(Format('ClassName : %s '+#13+#10+'Msg : %s',[E.ClassName,E.Message]));
             end;
  end;
end;

function TMain_Frm.PrintTrame(const bTrame: array of byte; Count: integer):string;
var
  byteTmp: byte;
  sTmp1, sTmp2, sTmp3: string;
  asTmp1, asTmp2, asTmp3: string;
  i: integer;
  sLigne: string;

begin
  sTmp1 := '';
  sTmp2 := '';
  sTmp3 := '';
  for i := 1 to Count do
    begin
      byteTmp := bTrame[i-1];
      asTmp1 := '';
      case byteTmp of
        $02: asTmp1 :='STX';    //A_STX
        $03: asTmp1 :='ETX';    //A_ETX
        $04: asTmp1 :='EOT';    //A_EOT
        $05: asTmp1 :='ENQ';    //A_ENQ
        $06: asTmp1 :='ACK';    //A_ACK
        $15: asTmp1 :='NAK';    //A_NAK
      else
        if byteTmp>32 then
          asTmp1 := chr(byteTmp);
      end;
      while Length(asTmp1)<4 do
        asTmp1 := asTmp1+' ';

      asTmp2 := inttohex(byteTmp,2);
      while Length(asTmp2)<4 do
        asTmp2 := asTmp2+' ';

      asTmp3 := inttostr(i);
      while Length(asTmp3)<4 do
        asTmp3 := asTmp3+' ';

      sTmp3 := sTmp3+asTmp3;
      sTmp1 := sTmp1+asTmp1;
      sTmp2 := sTmp2+asTmp2;
    end;
  sLigne := sLigne+sTmp1;
  result:=sLigne;
end;

procedure TMain_Frm.TraiteRecu(const bRecu: array of byte; Count: integer);
var sLigne:string;
begin
  Sligne := ' <-- ' + PrintTrame(bRecu,Count);
  EnregistreTrace(sLigne);
end;

procedure TMain_Frm.TrayDblClick(Sender: TObject);
begin
  Application.Minimize;
  Application.processmessages;
  Application.Restore;
  Show;
  FormStyle := FsStayOnTop;
  Application.processmessages;
  BringToFront;
  Application.processmessages;
  FormStyle := FsNormal;
end;

procedure TMain_Frm.DoAfterThread(var M: TMessage);
var
  sTmp: string;
  The : TThreadDelai;
begin
  if LstEnvoi.Count>0 then
  begin
    sTmp := LstEnvoi[0];
    LstEnvoi.Delete(0);
    SendToClient(sTmp, True);
    if (LstEnvoi.Count>0) and Serveur.Active then
    begin
      The := TThreadDelai.Create(150);
      The.OnTerminate := TerminateThread;
      The.Start;
    end
    else
      ThreadLance := false;
  end;
end;

procedure TMain_Frm.DoArreter(var M:TMessage);
var
  i: integer;
begin
   try
    EnregistreTrace('DoArreter');
    if (DialogTPEEtat='Maitre') then
    begin
      Application.processmessages;
      Sleep(200);
      TraiteEnvoi(A_EOT,1);
      AttenteTransac := false;
      Application.processmessages;
      Sleep(300);
      Application.processmessages;
    end;
   Except
      On E:Exception
         do
         begin
              EnregistreTrace('Exception : DoArreter');
              EnregistreTrace(Format('ClassName : %s '+#13+#10+'Msg : %s',[E.ClassName,E.Message]));
         end;
   end;
end;

procedure TMain_Frm.DoDemarre(var M: TMessage);
begin
  EnregistreTrace('<DoDemarre>');
  Tray.HideApplication;
  Application.processmessages;
end;

procedure TMain_Frm.MonSleep(ADelai: integer);
var
  Delai: DWord;
begin
  Delai := GetTickCount;
  while (GetTickCount-Delai<ADelai) do
  begin
    Sleep(1);
    Application.ProcessMessages;
  end;
end;

procedure TMain_Frm.DoFinTransaction(var M: TMessage);
var
  Delai: DWord;
begin
  Delai := GetTickCount;
  while (GetTickCount-Delai<200) and not(AttenteTransac) do
  begin
    Sleep(1);
    Application.ProcessMessages;
  end;

  AttenteTransac := false;
end;

procedure TMain_Frm.ArreterTransaction;
begin
  try
     if (DialogTPEEtat='Maitre') then
      begin
        Application.processmessages;
        Sleep(200);
        TraiteEnvoi(A_NAK,1);
        TraiteEnvoi(A_EOT,1);
        TraiteEnvoi(A_EOT,1);
        TraiteEnvoi(A_EOT,1);
        AttenteTransac := false;
        Application.processmessages;
        Sleep(300);
        Application.processmessages;
      end;
  except
      on E:EComPort
        do
          begin
              EnregistreTrace('Exception : ArreterTransaction');
              EnregistreTrace(Format('ClassName : EComPort'+#13+#10+'N° Erreur : %d'+#13+#10+'Msg : %s',[E.Code,E.Message]));
          end;
      On E:Exception
         do
         begin
              EnregistreTrace('Exception : ArreterTransaction');
              EnregistreTrace(Format('ClassName : %s '+#13+#10+'Msg : %s',[E.ClassName,E.Message]));
         end;
  end;
end;

procedure TMain_Frm.DecodeTrame(ATypeTrame: TTypeTrameTPE; ATrame: array of byte);
var i:integer;
    stmp:string;
begin
     if ATypeTrame=trReception then
        begin
             {    Exemple de Trame recu du TPE

                  N°  St            Montant  Mode  Devise        PRiv
                --------------------------------------------------------------------
                0 1 | 0 | 0 0 0 0 1 9 9 9  | 1 | 9 7 8  |   10 Caracètres espaces
             }
             stmp:='';
             for i:=4 to 11 do stmp := stmp + chr(ATrame[i]);
             Montant_Recu := StrToFloatDef(stmp,0) / 100;
             EnregistreTrace(Format('Montant Recu TPE :  %.2f',[Montant_Recu]));
        end;
end;

function TMain_Frm.CheckTrame(const bRecu: array of byte; Count: integer): boolean;
var
  byteTmp:Byte;
  i:integer;
  Posi: integer;
  sTmp1:string;
  sLigne: string;
begin
  result := true;
  TPE_ResuTransac := 6;  // Requête transaction échouée (Annule: il y a des chances)
  if TPE_Octet_Recu<NbARecevoir then
    exit;

  byteTmp := 0;
  for i := 2 to NbARecevoir-1 do
    byteTmp:=byteTmp XOR bRecu[i-1];

  result := (byteTmp=bRecu[NbARecevoir-1]);
  if Result then begin
    if chr(bRecu[3])='7' then
      TPE_ResuTransac := 7;    // transaction non aboutie  (REFUS: il y a de grande chance)

    if chr(bRecu[3])='0' then
      TPE_ResuTransac := 1;    // transaction reussi

    Transaction.RetCarte := chr(bRecu[12]);  // retour du type de carte
    if (Transaction.RetCarte='C') then
      begin
         Transaction.TypeTransaction := ttCheque;
      end;
    sTmp1 := '';
    Posi := 13;
    i := 0;
    while (i<=54) and (Posi+i<Count) do
    begin
      sTmp1 := sTmp1+chr(bRecu[i]);
      inc(i);
    end;
    sTmp1 := Trim(sTmp1);
    Case Transaction.TypeTransaction of
      ttCheque:
        Transaction.NumChq := sTmp1;
      ttDebit:
        Transaction.NumCB  := sTmp1;
    End;
  end;
  Transaction.Resultat := TPE_ResuTransac;
  sTmp1 := '';
  if Result then
    begin
       sTmp1 := 'CHECK=True : ('+inttohex(byteTmp,2)+'='+inttohex(bRecu[NbARecevoir-1],2)+')';
       // détail du check true?
    end
  else
    begin
        sTmp1 := 'CHECK=False : ('+inttohex(byteTmp,2)+'<>'+inttohex(bRecu[NbARecevoir-1],2)+')';
        // détail du check Faux ?
    end;
  EnregistreTrace(sTmp1);
end;

procedure TMain_Frm.ComPortAfterClose(Sender: TObject);
begin
     // EnregistreTrace('<ComPortAfterClose>');
     DoLibStatutCOM(0);
end;

procedure TMain_Frm.ComPortAfterOpen(Sender: TObject);
begin
  try
     EnregistreTrace('<ComPortAfterOpen>');
     DoLibStatutCOM(1);
     Sleep(100);
     ComPort.ClearBuffer(true, true);
  except
     on E:Exception
        do
          begin
              EnregistreTrace('Exception : <ComPortAfterOpen>');
              EnregistreTrace(Format('ClassName : %s '+#13+#10+'Msg : %s',[E.ClassName,E.Message]));
          end;
  end;
end;

procedure TMain_Frm.ComPortBeforeClose(Sender: TObject);
begin
  try
     // Tps_TimeOut.Enabled:=false;
     DoLibStatutCOM(-1); //---> On passe en etat Inconnu
  Except
     on E:Exception
        do
          begin
              EnregistreTrace('Exception : <ComPortBeforeClose>');
              EnregistreTrace(Format('ClassName : %s '+#13+#10+'Msg : %s',[E.ClassName,E.Message]));
          end;
  end;
end;

procedure TMain_Frm.ComPortBeforeOpen(Sender: TObject);
begin
     DoLibStatutCOM(-1);   //---> On passe en etat Inconnu
end;

procedure TMain_Frm.ComPortError(Sender: TObject; Errors: TComErrors);
begin
     EnregistreTrace('<ComPortError>');
end;

{ Pas Actif dans le composant }
procedure TMain_Frm.ComPortException(Sender: TObject;
  TComException: TComExceptions; ComportMessage: string; WinError: Int64;
  WinMessage: string);
begin
     EnregistreTrace('<ComPortException>');
     if (ComportMessage='Port Not Open')
        then
            begin
                 EnregistreTrace(Format('ComportMessage : %s',[ComportMessage]));
                 DoLibStatutCOM(-1);
                 DoLibDerniereErreurCOM(7);
                 AttenteTransac := false;
                 FermePortCOM;
                 Exit;
            end;
     if (ComportMessage='Unable to open com port')
        then
            begin
                 EnregistreTrace(Format('ComportMessage : %s',[ComportMessage]));
                 DoLibStatutCOM(-1);
                 DoLibDerniereErreurCOM(7);
                 AttenteTransac := false;
                 FermePortCOM;
                 Exit;
            end;
     EnregistreTrace(Format('Winerror : %d',[WinError]));
     EnregistreTrace(Format('WinMessage : %s',[WinMessage]));
end;

procedure TMain_Frm.ComPortRxChar(Sender: TObject; Count: Integer);
var
  BufferRx : array[0..65535] of byte;
  i,j:integer;
begin
  ComPort.Read(BufferRx,Count);
  TraiteRecu(BufferRx,Count);
  if Count<=0 then
    exit;

  if not(AttenteTransac) then
    exit;

  if (DialogTPEEtat='Maitre') then
  begin
       Tps_TimeOut.Enabled:=false;
    case TPE_Etat of
      1:
      begin
        if BufferRx[0]=A_ACK then
        begin            // Reception OK
          TPE_Etat := 2; // passage étape suivante
//          bOkPresenceTPE := true;
{          if bTestTPE then
          begin
            Sleep(100);
            TraiteEnvoi(A_EOT,1);
             bForceComClose := true;
             ReEssai := false;
             TPE_ResuTransac := 1;
             Transaction.State := 0;
             Transaction.Resultat := 1;
             LastResultat := 'Ok';
             Transaction.LastEnvoi := 'OK;PRESENCE';
             SendToClient('OK;PRESENCE');
             bGEcoute:=true;
             Exit;
          end;
}
          Transaction.State := 98;
          SendToClient('ENCOURS;'+inttostr(Transaction.State));
          Sleep(100);
          TraiteEnvoi(TPE_Envoi, 29);
          Tps_TimeOut.Interval := DelaiTimeOut;
          Tps_TimeOut.Enabled := True;
        end
        else
        begin
//          if bTestTPE then
//          begin
//            Sleep(100);
//            bForceComClose := true;
//            ReEssai := false;
//            TPE_ResuTransac := 1;
//            Transaction.State := 0;
//            Transaction.Resultat := 1;
//            LastResultat := 'Ok';
//            Transaction.LastEnvoi := 'OK;PRESENCE';
//            SendToClient('OK;PRESENCE');
//            bStopTestTPE := true;
//            bForceComClose := true;
//            PostMessage(Handle, WM_ARRETER, 0, 0);
//            exit;
//          end;
          ReEssai := false;
          LastResultat := 'Echoué';
          Transaction.Resultat := 0;
          Sleep(100);
          TraiteEnvoi(A_EOT,1);
          bForceComClose := true;
          EnregistreTrace('Fin de transaction PRESENCE');
          PostMessage(Handle, WM_FINTRANSACTION, 0, 0);
        end;
      end;
      2:
      begin
        TPE_Etat := 1;
        if BufferRx[0]=A_ACK then
        begin // Reception OK
          // TPE_OkMaitre := false;
          Transaction.Resultat := 6;
          Transaction.State := 97;
          SendToClient('ENCOURS;'+inttostr(Transaction.State));
          Sleep(120);
          // Fermeture session au TPE
          TraiteEnvoi(A_EOT,1);
          // On passe en esclave : Ecoute du TPE
          DialogTPEEtat := 'Esclave';
          // timer indisensesable ???...
          Tps_TimeOut.Interval := DelaiTimeOut;
          Tps_TimeOut.Enabled := True;
        end
        else
        begin
          Transaction.Resultat := 0;
          Sleep(100);
          TraiteEnvoi(A_EOT,1);
          AttenteTransac := false;
        end;
      end;
    end;
  end
  else
  begin
    case TPE_Etat of
      1:
      begin
        EnregistreTrace('TPE_Etat=1');
        if BufferRx[0]=A_EOT then
        begin
          EnregistreTrace('Passage Etat 1 EOT');
          TPE_Etat := 0;
          AttenteTransac := false;
          exit;
        end;
        Tps_TimeOut.Enabled:=false;
        if BufferRx[0]=A_ENQ then
        begin
          TPE_Etat := 2;
          Transaction.State := 96;
          SendToClient('ENCOURS;'+inttostr(Transaction.State));
          Tps_TimeOut.Interval := DelaiTimeOut;
          Tps_TimeOut.Enabled := true;
          Sleep(50);
          TraiteEnvoi(A_ACK,1);
        end;
      end;
      2:
      begin
        EnregistreTrace('TPE_Etat=2');
        Tps_TimeOut.Enabled:=False;
        if BufferRx[0]=A_EOT then
        begin
          EnregistreTrace('Passage Etat 2 EOT');
          TPE_Etat := 1;
          AttenteTransac := false;
          Exit;
        end;
        if BufferRx[0]=A_ENQ then
        begin
          Tps_TimeOut.Interval := DelaiTimeOut;
          Tps_TimeOut.Enabled := true;
          AttenteTransac := false;
          Sleep(100);
          TraiteEnvoi(A_EOT,1);
          exit;
        end;

        if BufferRX[0]=A_STX then
        begin
          EnregistreTrace('Transaction.State := 95');
          Transaction.State := 95;
          for i:=1 to Count do
            TPE_TrameRecep[i-1] := BufferRx[i-1];
          inc(TPE_Octet_Recu,Count);
          Sleep(50);
          if TPE_Octet_Recu>=NbARecevoir then
          begin
            EnregistreTrace('Transaction.State := 94');
            Transaction.State := 94;
            if not(CheckTrame(TPE_TrameRecep,TPE_Octet_Recu)) then
              TraiteEnvoi(A_NAK,1)
            else
            begin
              DecodeTrame(trReception,TPE_TrameRecep);
              TPE_Etat:=1;
              TraiteEnvoi(A_ACK,1);
              EnregistreTrace('Fin de transaction');
              PostMessage(Handle, WM_FINTRANSACTION, 0, 0);
            end;
          end
          else
          begin
            EnregistreTrace('TPE_Etat=3');
            TPE_Etat:=3;
            Tps_TimeOut.Interval := DelaiTimeOut;
            Tps_TimeOut.Enabled := true;
            // on est en attente ne pas envoyer ACK
            // TraiteEnvoi(A_ACK,1);
          end;
        end;
      end;
      3:
      begin
        EnregistreTrace('TPE_Etat=3');
        Tps_TimeOut.Enabled := false;
        Tps_TimeOut.Interval := DelaiTimeOut;
        Tps_TimeOut.Enabled := true;
        for i:=1 to Count do
          TPE_TrameRecep[i-1+TPE_Octet_Recu] := BufferRx[i-1];
        inc(TPE_Octet_Recu,Count);
        Sleep(50);
        if TPE_Octet_Recu>=NbARecevoir then
        begin
          if not(CheckTrame(TPE_TrameRecep,TPE_Octet_Recu)) then
          begin
            Transaction.State := 96;
            TPE_Etat:=2;
            TraiteEnvoi(A_NAK,1);
          end
          else
          begin
            DecodeTrame(trReception,TPE_TrameRecep);
            Transaction.State := 95;
            TPE_Etat := 1;
            TraiteEnvoi(A_ACK,1);
            bForceComClose := true;
            EnregistreTrace('Fin de transaction');
            PostMessage(Handle, WM_FINTRANSACTION, 0, 0);
          end;
        end
        else
        begin
          TPE_Etat:=3;
          Tps_TimeOut.Enabled := false;
          Tps_TimeOut.Interval := DelaiTimeOut;
          Tps_TimeOut.Enabled := true;
          TraiteEnvoi(A_ACK,1);
        end;
      end;
      4:
      begin
        EnregistreTrace('Passage Etat 4...');
        Tps_TimeOut.Enabled:=False;
        if BufferRx[0]=A_EOT then
          TPE_Etat := 1;
        AttenteTransac:=false;
      end;
    end;
  end;
end;

procedure TMain_Frm.DoLibDerniereErreurCOM(ANoErreur: integer);
begin
//Code de retour du PORT COM
//   1  :  Ok
//   2  :  Erreur de N° de port Com
//   3  :  Erreur de vitesse du Port Com
//   4  :  Erreur du bit de données du port Com
//   5  :  Erreur de la parité du port Com
//   6  :  Erreur du bit d'arrêt du port Com
//   7  :  Erreur ouverture du port Com

  case ANoErreur of
    2: Lab_ErreurCom.Caption := ERR_COM_ErreurNoCom;
    3: Lab_ErreurCom.Caption := ERR_COM_Vitesse;
    4: Lab_ErreurCom.Caption := ERR_COM_BitDonnee;
    5: Lab_ErreurCom.Caption := ERR_COM_Parite;
    6: Lab_ErreurCom.Caption := ERR_COM_BitArret;
    7: Lab_ErreurCom.Caption := ERR_COM_OuvertureCom;
  else
    Lab_ErreurCom.Caption := '';
  end;
  Lab_TitErreurCom.Visible := (ANoErreur in [2..7]);
  Lab_ErreurCom.Visible := Lab_TitErreurCom.Visible;
end;

procedure TMain_Frm.DoLibStatutCOM(ACOMStatus: Integer);
begin
  bCOMOuvert := ACOMStatus=1;
  if bCOMOuvert then Lab_Statut.Caption := TXT_ComOuvert
  else
    begin
      if (ACOMStatus=-1) then Lab_Statut.Caption := TXT_ComInconnu;
      if (ACOMStatus=0) then Lab_Statut.Caption  := TXT_ComFerme;
    end;
  EnregistreTrace('Com Status : '+Lab_Statut.Caption);
  ComEtat:= Lab_Statut.Caption;
end;

procedure TMain_Frm.DoTransaction(var M: TMessage);
var
  sTypeTrans: string;     // texte info transaction
  sTmp: string;
  TypTransac: integer;    // numero de type de transac
  ResuCOM: integer;       // retour de la fonction de l'ouverture COM
  i: integer;
begin
  EnregistreTrace('<DoTransaction>');
  bOccupe := true;
  Application.ProcessMessages;
  try
    Lab_Communication.Caption := Transaction.AdrIP;
    Lab_Transac.Caption := '';

    LastComm := Transaction.AdrIP;
    LastTransac := '';
    LastResultat := '';    
    Lab_LastComm.Caption := '';
    Lab_LastTransac.Caption := '';
    Lab_LastResult.Caption := '';
    Application.ProcessMessages;

    // texte info transaction
    TypTransac := -1;
    sTmp := FormatFloat('#,##0.00 €', Transaction.Mnt);
    sTypeTrans := '';


    case Transaction.TypeTransaction of
      ttPresence :
        begin
           sTypeTrans := TXT_Trans_TestPresence;
           TypTransac := 0;
           Lab_Transac.Caption := sTypeTrans;
           LastTransac := sTypeTrans;
           Application.ProcessMessages;
           if TestPresenceTPE then
              begin
                LastResultat := 'Ok';
                TPE_ResuTransac := 1;
                Transaction.State := 0;
                Transaction.Resultat := 1;
                LastResultat := 'Ok';
                Transaction.LastEnvoi := 'OK;PRESENCE';
                SendToClient('OK;PRESENCE');
                exit;
              end;
        end;
      ttDebit :
        begin
          sTypeTrans := Format(TXT_Trans_Debit, [sTmp]);
          TypTransac := 1;
        end;
      ttCredit :
        begin
           sTypeTrans := Format(TXT_Trans_Credit, [sTmp]);
           TypTransac := 2;
        end;
      ttAnnulation:
        begin
          sTypeTrans := Format(TXT_Trans_Annulation, [sTmp]);
          TypTransac := 3;
        end;
      ttDuplicata:
        begin
          sTypeTrans := Format(TXT_Trans_Duplicata, [sTmp]);
          TypTransac := 4;
        end;
      ttCheque:
        begin
          sTypeTrans := Format(TXT_Trans_Cheq, [sTmp]);
          TypTransac := 5;
        end;
    end;

    // demande transaction invalide
    if sTypeTrans='' then
    begin
      EnregistreTrace('1462 sTypeTrans=''''');
      LastResultat := ERR_Trans_Param_Invalide;
      if Transaction.bAncienneVersion then
      begin
        Transaction.LastEnvoi := 'NACK';
        SendToClient('NACK');

      end
      else
      begin
        Transaction.LastEnvoi := 'ERR;PARAM;1';
        SendToClient('ERR;PARAM;1');
      end;
      exit;
    end;
    Lab_Transac.Caption := sTypeTrans;
    LastTransac := sTypeTrans;
    Application.ProcessMessages;

    // montant invalide
    if (TypTransac in [1..5]) and (Transaction.Mnt<0.01) then
    begin
      EnregistreTrace('Montant invalide');
      LastResultat := ERR_Trans_Param_MntInvalide;
      if Transaction.bAncienneVersion then
      begin
        Transaction.LastEnvoi := 'NACK';
        SendToClient('NACK');
      end
      else
      begin
        Transaction.LastEnvoi := 'ERR;PARAM;2';
        SendToClient('ERR;PARAM;2');
      end;
      exit;
    end;
    //N° de caisse invalide
    if (Transaction.NoCaisse<1) or (Transaction.NoCaisse>99) then
    begin
      EnregistreTrace('N° de caisse invalide');
      LastResultat := ERR_Trans_Param_NoCaisseInvalide;
      if Transaction.bAncienneVersion then
      begin
        Transaction.LastEnvoi := 'NACK';
        SendToClient('NACK');
      end
      else
      begin
        Transaction.LastEnvoi := 'ERR;PARAM;3';
        SendToClient('ERR;PARAM;3');
      end;
      exit;
    end;

    // ouverture du Port COM si nécessaire
    if bForceComClose then
    begin
      EnregistreTrace('GR : MSG 505');
      {* ----------------------------------------------- *}
      // EnregistreTrace('Forçage Fermerture de Port COM');
      FermePortCOM;
      Sleep(200);
      {* ----------------------------------------------- *}
    end;

    if not(bCOMOuvert) then
    begin
      ResuCOM := OuvrePortCOM;
      if ResuCOM<>1 then  // erreur ouverture port
      begin
        LastResultat := ERR_Trans_PortCOM;
        if Transaction.bAncienneVersion then
        begin
          Transaction.LastEnvoi := 'NACK';
          SendToClient('NACK');
        end
        else
        begin
          Transaction.LastEnvoi := 'ERR;COM;'+inttostr(ResuCOM);
          SendToClient('ERR;COM;'+inttostr(ResuCOM));
        end;
        exit;
      end
    end;

    Tps_TimeOut.Enabled:=False;
    // Envoi de la transaction
    Transaction.Resultat := 99;
    Transaction.State    := 99;
    Transaction.RetCarte := '';
    Transaction.NumCB    := '';
    Transaction.NumChq   := '';
    if (TypTransac=5) then
      begin
        Transaction.TypeTransaction:=ttCheque;
      end;
//    bTestTPE := (TypTransac=0);
//    bStopTestTPE := false;
//    bOkPresenceTPE := false;
//    ResultPresenceTPE := false;

//    if not(bTestTPE) then
//    begin
      //début envoi
      TPE_Envoi[0] := A_STX;
      //N° caisse
      sTmp:=inttostr(Transaction.NoCaisse);
      While Length(sTmp)<2 do
        sTmp := '0'+sTmp;
      TPE_Envoi[1] := ord(sTmp[1]);
      TPE_Envoi[2] := ord(sTmp[2]);
      //montant
      sTmp := FormatFloat('0', Transaction.Mnt*100);
      while Length(sTmp)<8 do
        sTmp := '0'+sTmp;
      for i:=1 to 8 do
        TPE_Envoi[i+2] := ord(sTmp[i]);
      //reponse ?
      TPE_Envoi[11]:=Ord('0');
      //mode de réglement  0:indif   1: CB    C: Cheque
      if TypTransac<>5 then
        sTmp := '1'
      else
        sTmp := 'C';
      TPE_Envoi[12] := ord(sTmp[1]);
      //type transaction
      case TypTransac of
        1,5: TPE_Envoi[13] := Ord('0');
        2:   TPE_Envoi[13] := Ord('1');
        3:   TPE_Envoi[13] := Ord('2');
        4:   TPE_Envoi[13] := Ord('3');
      end;
      //devise
      TPE_Envoi[14] := Ord('9');
      TPE_Envoi[15] := Ord('7');
      TPE_Envoi[16] := Ord('8');
      //priv
      for i:=1 to 10 do
        TPE_Envoi[16+i] := ord(' ');
      TPE_Envoi[27] := A_ETX;
      // calcul du LRC
      TPE_Envoi[28] := 0;
      for i:=1 to 27 do
        TPE_Envoi[28] := TPE_Envoi[28] XOR TPE_Envoi[i];
//    end;

    // prepa de variable interne
    TPE_ResuTransac := 6;
    // TPE_OkMaitre:=true;
    DialogTPEEtat := 'Maitre';
    TPE_Etat:=1;
    TPE_Octet_Recu:=0;
    TPE_ResuCheck:=0;
    for i:=1 to High(TPE_TrameRecep) do
      TPE_TrameRecep[i]:=0;

    //  time out activé
    Tps_TimeOut.Interval := DelaiTimeOut;
    Tps_TimeOut.Enabled := true;

    // lancement de la transaction
    EnregistreTrace('Début transaction');
    AttenteTransac:=true;
    TraiteEnvoi(A_ENQ,1);

    while AttenteTransac do
      Application.ProcessMessages;

  finally
    if not(ReEssai) then
    begin
      case Transaction.Resultat of
        -1:
        begin
          Transaction.LastEnvoi := 'TIMEOUT';
          SendToClient('TIMEOUT');     // Time Out
        end;
        1:    // transaction Ok
        begin
          case Transaction.TypeTransaction of
            ttCheque:
              begin
                Transaction.LastEnvoi := 'OK;C;'+Transaction.NumChq;
                SendToClient('OK;C;'+Transaction.NumChq);
                LastResultat := 'Chèque Ok';
              end;
           ttDebit:
            begin
              Transaction.LastEnvoi := 'OK;B;'+Transaction.NumCB;
              SendToClient('OK;B;'+Transaction.NumCB);
              LastResultat := 'CB Ok';
            end;
          end;
          {--------------  Tout est OK on passe à l'etat 4  -------------------}
          TPE_Etat:=4;
          EnregistreTrace('INFO_1 : TPE_Etat:=4');
          Tps_TimeOut.Enabled:=False;
          AttenteTransac:=false;
          tmrTps_idle_com_close.Enabled:=true;
          {--------------------------------------------------------------------}
        end;
        6:  // Requête transaction échouée (plutôt annulé mais peut être carte muette)
        begin
          LastResultat := 'Requête échoué';
          if Transaction.bAncienneVersion then
            begin
              Transaction.LastEnvoi := 'NACK';
              SendToClient('NACK');
            end
          else
            begin
              Transaction.LastEnvoi := 'ECHOUE';
              SendToClient('ECHOUE');
            end;
        end;
        7:  // transaction échoué (plutôt refus ou carte muette, mais peut être annulé)
        begin
          LastResultat := 'Transaction échoué';
          if Transaction.bAncienneVersion then
            begin
              Transaction.LastEnvoi := 'NACK';
              SendToClient('NACK');
            end
          else
            begin
              Transaction.LastEnvoi := 'REFUS';
              SendToClient('REFUS');
            end;
        end;
      else
        begin
          Transaction.LastEnvoi := 'NACK';
          SendToClient('NACK');  // erreur
        end;
        LastResultat := 'Erreur';
      end;
      bOccupe := false;
      FinTransaction;
      Application.ProcessMessages;
    end;
  end;
end;

procedure TMain_Frm.FermePortCOM;
begin
  ComPort.Close;
  MN_COMDeconnect.Enabled := false;
  MN_COMDeconnect2.Enabled := false;
  MN_ReInit.Enabled := false;
  MN_ReInit2.Enabled := false;
  // statut du port COM = Fermé
  DoLibStatutCOM(0);
end;

procedure TMain_Frm.FormActivate(Sender: TObject);
begin
  if EtatEcran then
    exit;
  EtatEcran := true;
  Application.ProcessMessages;
  PostMessage(Handle, WM_DEMARRE, 0, 0);
end;

procedure TMain_Frm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     EnregistreTrace('Close');
end;

procedure TMain_Frm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
     EnregistreTrace('FormCloseQuery');
     CanClose:=true;
end;

procedure TMain_Frm.InitTransaction(var ATransaction:TTransaction);
begin
  ATransaction.bAncienneVersion := false;
  ATransaction.Resultat         := 99;
//  ATransaction.TypeTransac      := '';
  ATransaction.NoCaisse         := NumTPE;
  ATransaction.Mnt              := 0.0;
  ATransaction.NumCB            := '';
  ATransaction.NumChq           := '';
//  ATransaction.bCheq            := false;
  ATransaction.TypeTransaction    := ttNone;
end;


procedure TMain_Frm.FinTransaction;
begin
  InitTransaction(Transaction);
  bOccupe := false;


  // info dernière transaction
  Lab_Communication.Caption := '';
  Lab_Transac.Caption := '';
  Lab_LastComm.Caption := LastComm;
  Lab_LastTransac.Caption := LastTransac;
  Lab_LastResult.Caption := LastResultat;
  Application.ProcessMessages;
end;

procedure TMain_Frm.FormCreate(Sender: TObject);
var i: integer;
begin
  RemoveDeadIcons;
  bWarningStartMessage:=false;

  EtatEcran :=false;
  // repertoire de l'exe
  ReperBase := ExtractFilePath(ParamStr(0));
  if ReperBase[Length(ReperBase)]<>'\' then
    ReperBase := ReperBase+'\';
  ReperTrace := ReperBase+'LOG_TPE\';
  bOkTrace := false;
  for i := 1 to ParamCount do
  begin
    if ParamStr(i)='OKTRACE' then
      bOkTrace := true;
  end;
  if bOkTrace and not(DirectoryExists(ReperTrace)) then
    ForceDirectories(ReperTrace);

  bForceComClose := false;

  // tamppon envoi de message à l'appli client
  LstEnvoi := TStringList.Create;
  ThreadLance := false;
  DelaiDecompte := GetTickCount;

  // version de l'exe
  Version:= GetNumVersionSoft;
  Caption := Caption+' - V '+ Version;
  Application.Title := Application.Title+' - V '+ Version;
  Tray.Hint := Application.Title;
  // On ne charger cela qu'au demarrage
  FDialogTPE.Etat:='';
  DialogTPEEtat:='Maitre';

  // lire les paramètres
  LireParam;

  // statut du port COM = Fermé
  DoLibStatutCOM(0);

  // aucune erreur sur le port com au démarrage
  DoLibDerniereErreurCOM(0);

  // init info transaction   
  LastComm     := '';   // transaction dernière communication
  LastTransac  := '';   // dernière transaction demandée
  LastResultat := '';   // resultat de la transaction terminée

  InitTransaction(Transaction);
  // FinTransaction;
  Transaction.AdrIP := '';
  Transaction.LastEnvoi := '';

//  bTestTPE := false;
//  bStopTestTPE := false;
//  bOkPresenceTPE            := false;
  Lab_Communication.Caption := '';
  Lab_Transac.Caption       := '';
  Lab_LastComm.Caption      := '';
  Lab_LastTransac.Caption   := '';
  Lab_LastResult.Caption    := '';

  // demarrage du serveur
  Serveur.Close;
  Serveur.Port := PortEcouteSrv;
  try
    Serveur.Open;
  except
    on E:Exception do
    begin
      Halt;
    end;
  end;

  Tray.HideApplication;
end;

procedure TMain_Frm.FormDestroy(Sender: TObject);
begin
  EnregistreTrace('Tentative Fin de programme');
  ComPort.Close;
  Serveur.Close;
  FreeAndNil(LstEnvoi);
  EnregistreTrace('Fin de programme');
end;

end.
