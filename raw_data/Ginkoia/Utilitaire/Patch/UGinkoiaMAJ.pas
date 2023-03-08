//$Log:
// 18   Utilitaires1.17        03/08/2012 14:06:23    Thierry Fleisch
//      Supression de l'anticheck version
// 17   Utilitaires1.16        02/08/2012 12:44:15    Thierry Fleisch Sauvegarde
// 16   Utilitaires1.15        05/04/2012 17:02:06    Florent CHEVILLON Ajout
//      logs et tests modifs zip
// 15   Utilitaires1.14        13/12/2011 14:39:28    Thierry Fleisch
//      Correction du probl?me de patch de 7.1 vers 11.2
// 14   Utilitaires1.13        29/11/2011 15:21:07    Thierry Fleisch
//      Correction du probl?me de message d'erreur lors du lancement du
//      guardian
// 13   Utilitaires1.12        08/11/2011 10:35:27    Thierry Fleisch
//      Correction probl?me Pallanque + mise ? jour du syst?me de CRC32 + Zip
//      avec 7z
// 12   Utilitaires1.11        12/09/2011 15:58:53    Thierry Fleisch
//      Correction probl?me d'activation et d?sativation de Syncweb dans
//      v?rification et patch.exe
// 11   Utilitaires1.10        20/10/2010 10:43:59    Sandrine MEDEIROS maj
//      sandrine pour la lame6 et lame7
// 10   Utilitaires1.9         08/07/2010 16:21:05    Loic G          Migration
//      RAD 2007
// 9    Utilitaires1.8         17/09/2007 12:42:07    pascal          modifs
//      divers
// 8    Utilitaires1.7         02/04/2007 12:27:06    Sandrine MEDEIROS
//      GinkoiaMAP.Verification et MajAuto pour que le backup ne se lance pas
//      pendant la MAJ
// 7    Utilitaires1.6         21/07/2006 10:37:50    pascal          divers
//      correction
// 6    Utilitaires1.5         25/01/2006 14:59:02    pascal         
//      corrections divers sur les probl?mes relev?s
// 5    Utilitaires1.4         08/08/2005 09:03:35    pascal          Divers
//      modifications suite aux demandes de st?phanes
// 4    Utilitaires1.3         13/06/2005 11:50:43    pascal         
//      Modification suites au demande d'am?nagement de st?phanes
// 3    Utilitaires1.2         30/05/2005 08:57:03    pascal          Divers
//      modification de "Look" suite aux demandes de Herv?.A
// 2    Utilitaires1.1         20/05/2005 11:21:26    pascal          Ajout de
//      la v?rification que la version de d?part est ok et que la version
//      d'arriv? aussi
// 1    Utilitaires1.0         27/04/2005 10:41:28    pascal          
//$
//$NoKeywords$
//

unit UGinkoiaMAJ;

interface

uses
   RASAPI,
   UVerification,
   XMLCursor,
   StdXML_TLB,
   MSXML2_TLB,
   registry,
   UMapping,
   WinSvc,
   CstLaunch,
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   StdCtrls, ComCtrls, DFClasses, Buttons,
   RzLabel, ArtLabel, Db, IBDatabase, IBCustomDataSet, IBQuery, ExtCtrls,
   ZipMstr, Variants, TlHelp32, uSevenZip, IdHashCrc, IdObjs, ShellApi;

type
   TWVersion = (wvUnknown, wvWOld, wvW2k, wvWXP, wvWXPP64, wvW2k3, wvWVista, wvW7, wvNewVersion);

   TMonXML = class(TXMLCursor)
   end;
   TFrm_Patch = class(TForm)
      pc: TPageControl;
      INST: TTabSheet;
      Pb2: TProgressBar;
      Lab_Fichier: TLabel;
      Pb1: TProgressBar;
      Lab_Etat: TLabel;
      PRES: TTabSheet;
      ArtLabel1: TLabel;
      RzLabel1: TRzLabel;
      Bout2: TBitBtn;
      VERIF1: TTabSheet;
      RzLabel2: TRzLabel;
      ArtLabel2: TLabel;
      Bout3: TBitBtn;
      Que_Version: TIBQuery;
      Que_VersionVER_VERSION: TIBStringField;
      IBQue_EAI: TIBQuery;
      IBQue_EAIREP_PLACEEAI: TIBStringField;
      tran: TIBTransaction;
      data: TIBDatabase;
      ERRVER: TTabSheet;
      ArtLabel3: TLabel;
      RzLabel3: TRzLabel;
      Bout4: TBitBtn;
      ERRCONN: TTabSheet;
      Bout5: TBitBtn;
      RzLabel4: TRzLabel;
      ArtLabel4: TLabel;
      RzLabel5: TRzLabel;
      Pb_1: TProgressBar;
      Fic: TLabel;
      pb_2: TProgressBar;
      ERRVALID: TTabSheet;
      ArtLabel5: TLabel;
      RzLabel6: TRzLabel;
      Bout6: TBitBtn;
      RzLabel7: TRzLabel;
      Bout1: TBitBtn;
      ArtLabel6: TLabel;
      RzLabel8: TRzLabel;
      RzLabel9: TRzLabel;
      RETSTABLE: TTabSheet;
      ArtLabel7: TLabel;
      RzLabel10: TRzLabel;
      Bout7: TBitBtn;
      Bout8: TBitBtn;
      RzLabel11: TRzLabel;
      Label1: TLabel;
      FINOK: TTabSheet;
      FINNOK: TTabSheet;
      ArtLabel8: TLabel;
      RzLabel12: TRzLabel;
      Bout9: TBitBtn;
      ArtLabel9: TLabel;
      RzLabel13: TRzLabel;
      Bout10: TBitBtn;
      PROBBCK: TTabSheet;
      ArtLabel10: TLabel;
      RzLabel14: TRzLabel;
      Bout11: TBitBtn;
      Que_Sql: TIBQuery;
      PROBAUTONO: TTabSheet;
      ArtLabel11: TLabel;
      RzLabel15: TRzLabel;
      Bout12: TBitBtn;
      FINCAISSE: TTabSheet;
      RzLabel16: TRzLabel;
      ArtLabel12: TLabel;
      Bout13: TBitBtn;
      RzLabel17: TRzLabel;
      RzLabel18: TRzLabel;
      Tim_Auto: TTimer;
      IB_Connexion: TIBQuery;
      IB_ConnexionCON_ID: TIntegerField;
      IB_ConnexionCON_LAUID: TIntegerField;
      IB_ConnexionCON_NOM: TIBStringField;
      IB_ConnexionCON_TEL: TIBStringField;
      IB_ConnexionCON_TYPE: TIntegerField;
      IB_ConnexionCON_ORDRE: TIntegerField;
      ZipM: TZipMaster;
      procedure FormCreate(Sender: TObject);
      procedure FormPaint(Sender: TObject);

      procedure Bout2Click(Sender: TObject);
      procedure Bout3Click(Sender: TObject);
      procedure Bout5Click(Sender: TObject);
      procedure Bout1Click(Sender: TObject);
      procedure Bout8Click(Sender: TObject);
      procedure fermerClick(Sender: TObject);
      procedure Tim_AutoTimer(Sender: TObject);
      procedure ZipMTotalProgress(Sender: TObject; TotalSize: Int64;
         PerCent: Integer);
   private
    { Déclarations privées }
      automatique: boolean;
      Labase: string;
      Ginkoia: string;
      FichierEnCours: string;
      CRCSauve: string;
      AncVersion: string;
      AncNumero: string;
      NvlVersion: string;
      NvlNumero: string;
      VersionEnCours: string;
      LesEai: TstringList;
      LeNomLog: string;

      First: Boolean;
      doclose: Boolean;
      CaisseAutonome: Boolean;
      ListeConnexion: Tlist;
      Connectionencours: TLesConnexion;
      procedure arreterApplie;
      procedure JeStartService;
      procedure JeStopService;
      function VersionEnInt(SS, Sd: string): Integer;
      function RecupFichier(FichierS, FichierD: string): Boolean;
      function Traitement_BATCH(LeFichier: string; Log: TstringList; LogName: string): Boolean;
      procedure AjouteNoeud(Xml: TMonXML; Noeud: string; Place: Integer;
         Valeur: string);
      function ChercheMaxVal(Noeuds: IXMLDOMNodeList; NoeudFils,
         TAG: string): string;
      function ChercheMinVal(Noeuds: IXMLDOMNodeList; NoeudFils,
         TAG: string): string;
      function ChercheVal(Noeuds: IXMLDOMNodeList; TAG: string): string;
      function Existes(Noeuds: IXMLDOMNodeList; NoeudFils, TAG,
         Valeur: string): Integer;
      function Existe(Noeuds: IXMLDOMNodeList; TAG, Valeur: string): Boolean;
      procedure RemplaceVal(Noeuds: IXMLDOMNodeList; TAG, Valeur: string);
      function traiteversion(S: string): string;
      procedure suite1;
      function StopServiceRepl: boolean;
      function Connexion: Boolean;
      function ConnexionModem(Nom, Tel: string): Boolean;
      procedure Deconnexion;
      procedure DeconnexionModem;

      PROCEDURE Attente_IB;
      Function GetWindowsVersion : TWVersion;

   public
    { Déclarations publiques }
      procedure PatchNotify(T_Actu, T_Tot: Integer);
      procedure FileNotify(Fichier: string);
      procedure effacerfichier(Rep: string);
      function testLog(Fichier: string): Boolean;
      function CopierFichier(FichierS, FichierD: string): Boolean;
      procedure retourStable(log: string);

      function DoNewCalcCRC32 (AFileName : String) : cardinal;
   end;

var
   Frm_Patch: TFrm_Patch;

implementation
{$R *.DFM}
{$R 7z.RES}

uses
   FileCtrl,
   UDecodePatch;
var
   Lapplication: string;
   AppliTourne: boolean;
const
   _launcher = 'LE LAUNCHER';
   _ginkoia = 'GINKOIA';
   _Caisse = 'CAISSEGINKOIA';
   _TPE = 'SERVEUR DE TPE';
   _PICCO = 'PICCOLINK';
   _SCRIPT = 'SCRIPT';
   _PICCOBATCH = 'PICCOBATCH';
   // FTH 12/09/2011 Utilise Killprocess au lieu de Enumwindows
   _SYNCWEB = 'syncweb.exe';


function ProgressCallback(sender: Pointer; total: boolean; value: int64): HRESULT; stdcall;
begin
  if total then
    TProgressBar(sender).Max := (value Div 1024)// Div 1024)
  else
    TProgressBar(sender).Position := (value Div 1024);// Div 1024);
  Application.ProcessMessages;
  Result := S_OK;
end;

function Enumerate(hwnd: HWND; Param: LPARAM): Boolean; stdcall; far;
var
   lpClassName: array[0..999] of Char;
   lpClassName2: array[0..999] of Char;
   Handle: DWORD;
begin
   result := true;
   Windows.GetClassName(hWnd, lpClassName, 500);
   if Uppercase(StrPas(lpClassName)) = 'TAPPLICATION' then
   begin
      Windows.GetWindowText(hWnd, lpClassName2, 500);
      if Uppercase(StrPas(lpClassName2)) = Lapplication then
      begin
         GetWindowThreadProcessId(hWnd, @Handle);
         TerminateProcess(OpenProcess(PROCESS_ALL_ACCESS, False, Handle), 0);
         result := False;
      end;
   end;
end;

function Enumerate2(hwnd: HWND; Param: LPARAM): Boolean; stdcall; far;
var
   lpClassName: array[0..999] of Char;
   lpClassName2: array[0..999] of Char;
begin
   result := true;
   Windows.GetClassName(hWnd, lpClassName, 500);
   if Uppercase(StrPas(lpClassName)) = 'TAPPLICATION' then
   begin
      Windows.GetWindowText(hWnd, lpClassName2, 500);
      if Uppercase(StrPas(lpClassName2)) = Lapplication then
      begin
         AppliTourne := True;
         result := False;
      end;
   end;
end;

function KillProcess(const ProcessName : string) : boolean;
var ProcessEntry32 : TProcessEntry32;
    HSnapShot : THandle;
    HProcess : THandle;
begin
  Result := False;

  HSnapShot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if HSnapShot = 0 then exit;

  ProcessEntry32.dwSize := sizeof(ProcessEntry32);
  if Process32First(HSnapShot, ProcessEntry32) then
  repeat
    if CompareText(ProcessEntry32.szExeFile, ProcessName) = 0 then
    begin
      HProcess := OpenProcess(PROCESS_TERMINATE, False, ProcessEntry32.th32ProcessID);
      if HProcess <> 0 then
      begin
        Result := TerminateProcess(HProcess, 0);
        CloseHandle(HProcess);
      end;
      Break;
    end;
  until not Process32Next(HSnapShot, ProcessEntry32);

  CloseHandle(HSnapshot);
end;

function ProcessExists(const ProcessName :string) : Boolean;
var ProcessEntry32 : TProcessEntry32;
    HSnapShot : THandle;
    HProcess : THandle;
begin
  Result := False;

  HSnapShot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if HSnapShot = 0 then exit;

  ProcessEntry32.dwSize := sizeof(ProcessEntry32);
  if Process32First(HSnapShot, ProcessEntry32) then
  repeat
    if CompareText(ProcessEntry32.szExeFile, ProcessName) = 0 then
      Result := True;
  until not Process32Next(HSnapShot, ProcessEntry32);

  CloseHandle(HSnapshot);
end;

procedure TFrm_Patch.DeconnexionModem;
var
   RasCom: array[1..100] of TRasConn;
   i, Connections: DWord;
   ok: Boolean;
   RasConStatus: TRasConnStatus;
begin
   repeat
      i := Sizeof(RasCom);
      RasCom[1].Size := sizeof(TRasConn);
      RasEnumConnections(@RasCom, i, Connections);
      for i := 1 to Connections do RasHangUp(RasCom[i].RasConn);
        // Test si c'est bien deconnecté
      i := Sizeof(RasCom);
      RasCom[1].Size := sizeof(TRasConn);
      RasEnumConnections(@RasCom, i, Connections);
      ok := True;
      for i := 1 to Connections do
      begin
         Application.ProcessMessages;
         RasConStatus.Size := sizeof(RasConStatus);
         RasGetConnectStatus(RasCom[i].RasConn, @RasConStatus);
         case RasConStatus.RasConnState of
            RASCS_Connected: ok := False;
         end;
      end;
      if not ok then
         LeDelay(5000);
   until OK;
end;

function TFrm_Patch.DoNewCalcCRC32 (AFileName : String) : cardinal;
var
  IndyStream : TFileStream;
  Hash32 : TIdHashCRC32;
begin
  IndyStream := TIdFileStream.Create(AFileName,fmOpenRead);
  Hash32 := TIdHashCRC32.Create;
  Result := Hash32.HashValue(IndyStream);
  Hash32.Free;
  IndyStream.Free;
end;

procedure TFrm_Patch.Deconnexion;
begin
   if (Connectionencours <> nil) and
      (Connectionencours.LeType = 0) then
      DeconnexionModem;
   Connectionencours := nil;
end;

function TFrm_Patch.ConnexionModem(Nom, Tel: string): Boolean;
var
   RasConn: HRasConn;
   TP: TRasDialParams;
   Pass: Bool;
   err: DWORD;
   Last: DWord;
   RasConStatus: TRasConnStatus;
   nb: DWORD;
   ok: Boolean;
begin
   fillchar(tp, Sizeof(tp), #00);
   tp.Size := Sizeof(Tp);
   StrPCopy(tp.pEntryName, NOM);
   err := RasGetEntryDialParams(nil, TP, Pass);
   Ok := false;
   if err = 0 then
   begin
      StrPCopy(tp.pPhoneNumber, TEL);
      RasConn := 0;

      err := rasdial(nil, nil, @tp, $FFFFFFFF, Handle, RasConn);
      if err <> 0 then
      begin
         result := false;
         EXIT;
      end;
      Application.ProcessMessages;
      Last := $FFFFFFFF;
      nb := gettickcount + 600000; // 10 min
      repeat
         Application.ProcessMessages;
         RasConStatus.Size := sizeof(RasConStatus);
         RasGetConnectStatus(RasConn, @RasConStatus);
         if Last <> RasConStatus.RasConnState then
         begin
            case RasConStatus.RasConnState of
               RASCS_Connected: ok := true;
               RASCS_Disconnected: ok := true;
            end;
            Last := RasConStatus.RasConnState;
         end;
         LeDelay(1000);
      until OK or (gettickcount > nb); // max 10 min
   end;
   result := Ok;
end;


function TFrm_Patch.Connexion: Boolean;
var
   i: Integer;
   reg: tregistry;
begin
   reg := tregistry.create(KEY_WRITE);
   try
      reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\', False);
      reg.WriteInteger('GlobalUserOffline', 0);
   finally
      reg.closekey;
      reg.free;
   end;
   result := false;
   i := 0;
   Connectionencours := nil;
   while i < ListeConnexion.Count do
   begin
      Connectionencours := TLesConnexion(ListeConnexion[i]);
      if Connectionencours.LeType = 1 then // Routeur : Juste un Ping
      begin
         if Frm_Verification.Connexion then
         begin
            result := true;
            BREAK;
         end;
      end
      else
      begin // Connexion sur modem
         if ConnexionModem(Connectionencours.Nom, Connectionencours.TEL) then
         begin
            result := true;
            BREAK;
         end;
      end;
      Inc(i);
   end;
   if not result then
      Connectionencours := nil;
end;

procedure TFrm_Patch.JeStartService;
var
   hSCManager: SC_HANDLE;
   hService: SC_HANDLE;
   Statut: TServiceStatus;
   tempMini: DWORD;
   CheckPoint: DWORD;
   PC: PChar;
   NbEssai: Integer;
   MaxEssai: Integer;

   Reg : TRegistry;
   sPathIbGuard : String;
begin
  if GetWindowsVersion in [wvW7,wvNewVersion] then
  begin
    // On exécute le process interbase
    Reg := TRegistry.Create;
    try
      Reg.RootKey := HKEY_LOCAL_MACHINE;
      if Reg.OpenKey('SYSTEM\ControlSet001\Services\Interbaseguardian\',False) then
      begin
        sPathIbGuard := Reg.ReadString('ImagePath');
        if FileExists(sPathIbGuard) then
          if not ProcessExists('ibguard.exe') then
            ShellExecute(0,'OPEN',PCHAR(sPathIbGuard),PCHAR(' -a'),PCHAR('c:\borland\interbase\bin\'),HIDE_WINDOW);
      end;
    finally
      Reg.free;
    end;
  end;

   hSCManager := OpenSCManager(nil, nil, SC_MANAGER_CONNECT);
   hService := OpenService(hSCManager, 'InterBaseGuardian', SERVICE_QUERY_STATUS or SERVICE_START or SERVICE_STOP or SERVICE_PAUSE_CONTINUE);
   if hService <> 0 then
   begin // Service non installé
      QueryServiceStatus(hService, Statut);
      tempMini := Statut.dwWaitHint + 25;
      MaxEssai := trunc((10 * 60000) / tempMini);
      PC := nil;
      StartService(hService, 0, PC);
      NbEssai := 0;
      repeat
         CheckPoint := Statut.dwCheckPoint;
         Sleep(tempMini);
         application.processmessages;
         QueryServiceStatus(hService, Statut);
         tempMini := Statut.dwWaitHint + 25;
         inc(NbEssai);
      until ((CheckPoint = Statut.dwCheckPoint) and (NbEssai > MaxEssai)) or
         (statut.dwCurrentState = SERVICE_RUNNING);
            // si CheckPoint = Statut.dwCheckPoint Alors le service est dans les choux
   end;
   CloseServiceHandle(hService);
   CloseServiceHandle(hSCManager);
end;

procedure TFrm_Patch.JeStopService;
var
   hSCManager: SC_HANDLE;
   hService: SC_HANDLE;
   Statut: TServiceStatus;
   tempMini: DWORD;
   CheckPoint: DWORD;

   Reg : TRegistry;
   sPathIbGuard : String;

begin
   hSCManager := OpenSCManager(nil, nil, SC_MANAGER_CONNECT);
   hService := OpenService(hSCManager, 'InterBaseGuardian', SERVICE_QUERY_STATUS or SERVICE_START or SERVICE_STOP or SERVICE_PAUSE_CONTINUE);
   if hService = 0 then
   begin // Service non installé
   end
   else
   begin
      QueryServiceStatus(hService, Statut);
      if statut.dwCurrentState = SERVICE_RUNNING then
      begin
         tempMini := Statut.dwWaitHint + 10;
         ControlService(hService, SERVICE_CONTROL_STOP, Statut);
         repeat
            CheckPoint := Statut.dwCheckPoint;
            Sleep(tempMini);
            QueryServiceStatus(hService, Statut);
         until (CheckPoint = Statut.dwCheckPoint) or
            (statut.dwCurrentState = SERVICE_PAUSED);
            // si CheckPoint = Statut.dwCheckPoint Alors le service est dans les choux
      end
      else
      begin
      end;
   end;
   CloseServiceHandle(hService);
   CloseServiceHandle(hSCManager);

   if GetWindowsVersion in [wvW7,wvNewVersion] then
   begin
    Reg := TRegistry.Create;
    try
      Reg.RootKey := HKEY_LOCAL_MACHINE;
      if Reg.OpenKey('SYSTEM\ControlSet001\Services\Interbaseguardian\',False) then
      begin
        sPathIbGuard := Reg.ReadString('ImagePath');
        if FileExists(sPathIbGuard) then
        begin
          KillProcess('ibserver.exe');
          KillProcess('ibguard.exe');
        end;
      end;
    finally
      Reg.free;
    end;

   end;
end;

procedure TFrm_Patch.effacerfichier(Rep: string);
var
   F: TSearchRec;
begin
   if FindFirst(rep + '*.*', FaAnyFile, F) = 0 then
   begin
      repeat
         if (f.name <> '.') and (f.name <> '..') then
         begin
            if f.Attr and Fadirectory = Fadirectory then
               effacerfichier(Rep + f.name + '\')
            else
               deletefile(Rep + f.name);
         end;
      until FindNext(f) <> 0;
   end;
   FindClose(f);
end;

procedure TFrm_Patch.FileNotify(Fichier: string);
begin
   FichierEnCours := Fichier;
   Lab_Fichier.Caption := FichierEnCours; Lab_Fichier.Update;
   application.ProcessMessages;
end;

procedure TFrm_Patch.arreterApplie;
begin
   Lapplication := _SCRIPT;
   EnumWindows(@Enumerate, 0);
   Lapplication := _ginkoia;
   EnumWindows(@Enumerate, 0);
   sleep(100);
   Lapplication := _Caisse;
   EnumWindows(@Enumerate, 0);
   sleep(100);
   Lapplication := _PICCO;
   EnumWindows(@Enumerate, 0);
   sleep(100);
   Lapplication := _PICCOBATCH;
   EnumWindows(@Enumerate, 0);
   sleep(100);
   Lapplication := _TPE;
   EnumWindows(@Enumerate, 0);

   sleep(100);
//   Lapplication := _SYNCWEB;
//   EnumWindows(@Enumerate, 0);
   KillProcess(_SYNCWEB);

   sleep(100);
   Lapplication := _launcher;
   EnumWindows(@Enumerate, 0);
   sleep(5000);
end;

procedure TFrm_Patch.Attente_IB;
VAR
  hSCManager: SC_HANDLE;
  hService: SC_HANDLE;
  Statut: TServiceStatus;
  tempMini: DWORD;
  CheckPoint: DWORD;
  NbBcl: Integer;
BEGIN
  hSCManager := OpenSCManager(NIL, NIL, SC_MANAGER_CONNECT);
  hService := OpenService(hSCManager, 'InterBaseGuardian', SERVICE_QUERY_STATUS);
  IF hService <> 0 THEN
  BEGIN // Service non installé
    QueryServiceStatus(hService, Statut);
    CheckPoint := 0;
    NbBcl := 0;
    WHILE (statut.dwCurrentState <> SERVICE_RUNNING) OR
      (CheckPoint <> Statut.dwCheckPoint) DO
    BEGIN
      CheckPoint := Statut.dwCheckPoint;
      tempMini := Statut.dwWaitHint + 1000;
      Sleep(tempMini);
      QueryServiceStatus(hService, Statut);
      Inc(nbBcl);
      IF NbBcl > 900 THEN BREAK;
    END;
    IF NbBcl < 900 THEN
    BEGIN
      CloseServiceHandle(hService);
      hService := OpenService(hSCManager, 'InterBaseServer', SERVICE_QUERY_STATUS);
      IF hService <> 0 THEN
      BEGIN // Service non installé
        QueryServiceStatus(hService, Statut);
        CheckPoint := 0;
        NbBcl := 0;
        WHILE (statut.dwCurrentState <> SERVICE_RUNNING) OR
          (CheckPoint <> Statut.dwCheckPoint) DO
        BEGIN
          CheckPoint := Statut.dwCheckPoint;
          tempMini := Statut.dwWaitHint + 1000;
          Sleep(tempMini);
          QueryServiceStatus(hService, Statut);
          Inc(nbBcl);
          IF NbBcl > 900 THEN BREAK;
        END;
      END;
    END;
  END;
  CloseServiceHandle(hService);
  CloseServiceHandle(hSCManager);
END;


function TFrm_Patch.VersionEnInt(SS, Sd: string): Integer;
var
   V1, V1d: Integer;
   V2, V3: Integer;
   V2d, V3d, V4d: Integer;
begin
   V1 := Strtoint(Copy(Ss, 1, pos('.', Ss) - 1)); delete(ss, 1, pos('.', Ss));
   V2 := Strtoint(Copy(Ss, 1, pos('.', Ss) - 1)); delete(ss, 1, pos('.', Ss));
   V3 := Strtoint(Copy(Ss, 1, pos('.', Ss) - 1)); delete(ss, 1, pos('.', Ss));

   V1d := Strtoint(Copy(Sd, 1, pos('.', Sd) - 1)); delete(sd, 1, pos('.', Sd));
   V2d := Strtoint(Copy(Sd, 1, pos('.', Sd) - 1)); delete(sd, 1, pos('.', Sd));
   V3d := Strtoint(Copy(Sd, 1, pos('.', Sd) - 1)); delete(sd, 1, pos('.', Sd));
   V4d := Strtoint(trim(Sd));
   if (V3d - V3) < 0 then V3 := V3d;
   if (V2d - V2) < 0 then V2 := V2d;
   Result := trunc(V4d / 10) + (V3d - V3) * 1000 + (V2d - V2) * 1000 * 12 + (V1d - V1) * 1000 * 12 * 10;
end;

procedure TFrm_Patch.FormCreate(Sender: TObject);
var
   S: string;
   reg: TRegistry;
   TmLesFic: TmemoryStream;
   AncVersion: string;
   AncNumero: string;
   NvlVersion: string;
   NvlNumero: string;

   APPPATH : String;
   Res : TResourceStream;
begin
   APPPATH := ExtractFilePath(Application.ExeName);

   if FileExists(APPPATH + '7z.dll') then
     DeleteFile(APPPATH + '7z.dll');
   Res := TResourceStream.Create(0,'SEVENZIP','DLL');
   Res.SaveToFile(ExtractFilePath(Application.ExeName) + '7z.dll');
   Res.Free;

   MapGinkoia.MajAuto := True;
   automatique := false;
   if (paramcount > 0) and (uppercase(paramstr(1)) = 'AUTO') then
      automatique := true;
   First := true;
   doclose := False;
   CaisseAutonome := false;
   RzLabel5.Caption := '';
   pc.ActivePage := PRES;
   tim_auto.tag := 2;
   if automatique then tim_auto.enabled := true;
   reg := TRegistry.Create;
   try
      reg.access := Key_Read;
      Reg.RootKey := HKEY_LOCAL_MACHINE;
      s := '';
      reg.OpenKey('SOFTWARE\Algol\Ginkoia', False);
      S := reg.ReadString('Base0');
   finally
      reg.free;
   end;
   Labase := S;
   S := ExcludetrailingBackSlash(ExtractFilePath(S));
   while s[length(S)] <> '\' do
      delete(S, length(S), 1);
   Ginkoia := S;

   TmLesFic := TmemoryStream.Create;
   try
      try
         TmLesFic.LoadFromFile(Ginkoia + 'LiveUpdate\Patch.GIN');
         TmLesFic.seek(0, soFromBeginning);
         AncVersion := ReadString(TmLesFic);
         AncNumero := ReadString(TmLesFic);
         NvlVersion := ReadString(TmLesFic);
         NvlNumero := ReadString(TmLesFic);
      finally
         TmLesFic.free;
      end;
      ArtLabel1.caption := Format(ArtLabel1.Caption, [NvlVersion]);
      ArtLabel2.caption := Format(ArtLabel2.Caption, [NvlVersion]);
      ArtLabel3.caption := Format(ArtLabel3.Caption, [NvlVersion]);
      ArtLabel4.caption := Format(ArtLabel4.Caption, [NvlVersion]);
      ArtLabel5.caption := Format(ArtLabel5.Caption, [NvlVersion]);
      ArtLabel6.caption := Format(ArtLabel6.Caption, [NvlVersion]);
      ArtLabel7.caption := Format(ArtLabel7.Caption, [NvlVersion]);
      ArtLabel8.caption := Format(ArtLabel8.Caption, [NvlVersion]);
      ArtLabel9.caption := Format(ArtLabel9.Caption, [NvlVersion]);
      ArtLabel10.caption := Format(ArtLabel10.Caption, [NvlVersion]);
      rzlabel1.caption := Format(rzlabel1.Caption, [NvlVersion]);
      pc.ActivePage := PRES;
      tim_auto.tag := 2;
      if automatique then tim_auto.enabled := true;

      LeNomLog := Ginkoia + 'LiveUpdate\LOG' + AncVersion + '-' + NvlVersion + '.Log';
      if FileExists(LeNomLog) and testLog(LeNomLog) then
      begin
         pc.ActivePage := RETSTABLE;
         tim_auto.tag := 7;
         if automatique then tim_auto.enabled := true;
      end;
   except
      doclose := true;
      if not automatique then
         Application.messagebox('Problème important sur le logiciel, il va se fermer', ' Fermer', Mb_OK);
   end;
   JeStartService;
end;

procedure TFrm_Patch.PatchNotify(T_Actu, T_Tot: Integer);
begin
   try
      Pb2.Max := T_Tot;
      Pb2.Position := T_Actu;
   except
   end;
end;

function TFrm_Patch.testLog(Fichier: string): boolean;
var
   TSL: TstringList;
   i: integer;
begin
   result := False;
   Tsl := TstringList.Create;
   tsl.loadfromfile(fichier);
   for i := 0 to tsl.count - 1 do
      if Copy(tsl[i], 1, 1) = '*' then
      begin
         result := true;
         BREAK;
      end;
   tsl.free;
end;

function TFrm_Patch.CopierFichier(FichierS, FichierD: string): Boolean;
var
  Arch : I7zOutArchive;
begin
   result := True;
   Lab_Fichier.Caption := 'Sauvegarde de ' + FichierS; Lab_Fichier.Update;
   application.ProcessMessages;

   ForceDirectories(extractfilepath(FichierD));
   if Uppercase(ExtractFileExt(FichierS)) = '.ZIP' then
   begin
      Result := CopyFile(Pchar(FichierS), Pchar(FichierD), False);
   end
   else
   begin
//      Pb2.position := 0; Pb2.Max := 100;
//      ZipM.ZipFileName := FichierD + '.ZIP';
//      ZipM.FSpecArgs.Clear;
//      ZipM.FSpecArgs.Add(FichierS);
      if FileEXists(FichierS) then
      try
//         ZipM.add;
        // Calcul du CRC32
        CRCSauve := IntToStr(DoNewCalcCRC32(FichierS));
        // Zip du fichier
        Arch := CreateOutArchive(CLSID_CFormatZip);
        Arch.AddFile(FichierS,ExtractFileName(FichierS));
        SetCompressionLevel(Arch,4);
        Arch.SetProgressCallback(Pb2,ProgressCallback);
        Arch.SaveToFile(FichierD + '.ZIP');

//        CRCSauve := Inttostr(FileCRC32(FichierD + '.ZIP'));
      except
         result := false;
      end;
   end;
end;

function TFrm_Patch.RecupFichier(FichierS, FichierD: string): Boolean;
var
   Arch : I7zInArchive;
begin
  try
   result := True;
   Lab_Fichier.Caption := 'Récupération de ' + FichierD; Lab_Fichier.Update;
   application.ProcessMessages;

   Pb2.position := 0; Pb2.Max := 100;
   if uppercase(ExtractFileExt(FichierS)) = '.ZIP' then
   begin
      Result := CopyFile(Pchar(FichierS), Pchar(FichierD), False);
   end
   else if fileexists(FichierS) then
   begin
      Result := CopyFile(Pchar(FichierS), Pchar(FichierD), False);
   end
   else
   begin
      if fileexists(FichierS + '.ZIP') then
      begin
//         ZipM.ZipFileName := FichierS + '.ZIP';
//         ZipM.ExtrBaseDir := extractfilepath(FichierD);
         try
//            ZipM.Extract;
           Arch := CreateInArchive(CLSID_CFormatZip);
           Arch.OpenFile(FichierS + '.ZIP');
           Arch.SetProgressCallback(Pb2,ProgressCallback);
           Arch.ExtractTo(extractfilepath(FichierD));
//           Arch.Close;
         except
            result := false;
         end;
      end;
   end;
  Except on E:Exception do
    Showmessage('RecupFichier : ' + E.Message);
  end;
end;

procedure TFrm_Patch.retourStable(log: string);
var
   TSL, tslLog : TstringList;
   i: integer;
   S1: string;
   S: string;
   NewCRC, iLogCount : Cardinal;
   IndyStream : TFileStream;
   Hash32 : TIdHashCRC32;
begin
  try
   arreterApplie;
   Tsl := TstringList.Create;
   tsl.loadfromfile(Log);
   tsl.add('- Retour à un état stable ' + DateToStr(Date));
   tsl.Savetofile(log);
   tslLog := TStringList.Create;
   tslLog.Text := tsl.Text;
   iLogCount := tslLog.Count; // Permet de vérifier à la fin s'il y a eu des soucis
    // vérification de la cohérence de la sauvegarde
   try
//     for i := 0 to tsl.count - 1 do
//        if Copy(tsl[i], 1, 1) = '*' then
//        begin
//           if Copy(tsl[i], 1, 2) = '**' then
//           begin // recup d'un fichier sauvegardé
//              S := Copy(Tsl[i], 3, 255);
//              S1 := Copy(S, pos(';', S) + 1, 255);
//              delete(S, Pos(';', S), 255);
//              if uppercase(extractfileext(S)) <> '.ZIP' then
//              begin
//                 Lab_Etat.Caption := 'Verification ' + S; Lab_Etat.Update;
//                 application.ProcessMessages;
//
//                 NewCRC := FileCRC32(Ginkoia + 'Sauve\' + S + '.ZIP') ;
//
////                 if Trim(S1) <> Inttostr(NewCRC) then
////                 begin
////                    tslLog.Add('Recup Erreur : ' + S);
//                    tslLog.Add(Trim(S1) + ' / ' + Inttostr(NewCRC));
////                    if not automatique then
////                       Application.messageBox('La sauvegarde est altérée, impossible de revenir à un état stable', ' PROBLEME', Mb_Ok);
////                    EXIT;
////                 end;
//                 tslLog.Add('Recup Ok : ' + S);
//              end;
//           end
//           else
//           begin
//              S := Copy(Tsl[i], 3, 255);
//              S1 := Copy(Tsl[i], pos(';', Tsl[i]) + 1, 255);
//              Lab_Etat.Caption := 'Verification de la base'; Lab_Etat.Update;
//              application.ProcessMessages;
//
//  //            IndyStream := TIdFileStream.Create(Ginkoia + 'Sauve\' + trim(S) + '.ZIP',fmOpenRead);
//  //            Hash32 := TIdHashCRC32.Create;
//  //            NewCRC := Hash32.HashValue(IndyStream);
//  //            Hash32.Free;
//  //            IndyStream.Free;
//  //
//  //            if S1 <> Inttostr(NewCRC) then
//  //            begin
//  //               if not automatique then
//  //                  Application.messageBox('La sauvegarde est altérée, impossible de revenir à un état stable', ' PROBLEME', Mb_Ok);
//  //               EXIT;
//  //            end;
//           end;
//        end;

     for i := 0 to tsl.count - 1 do
        if Copy(tsl[i], 1, 1) = '*' then
        begin
           if Copy(tsl[i], 1, 2) = '**' then
           begin // recup d'un fichier sauvegardé
              S := Copy(Tsl[i], 3, 255);
              S1 := Copy(S, pos(';', S) + 1, 255);
              delete(S, Pos(';', S), 255);
              Lab_Etat.Caption := 'Récupération de ' + S; Lab_Etat.Update;
              application.ProcessMessages;

              RecupFichier(Ginkoia + 'Sauve\' + S, Ginkoia + S);
              // Calcul du CRC
              NewCRC := DoNewCalcCRC32(Ginkoia + S);
              // Vérification avec l'ancien CRC
              if Trim(S1) <> IntToStr(NewCRC) then
              begin
                 tslLog.Add('CRC Incorrect : ' + Ginkoia + S );
                 tslLog.Add('Old : ' + S1 + ' / New : ' +  IntToStr(NewCRC));
              end;
           end
           else if Copy(tsl[i], 1, 2) = '*?' then
           begin // recup de la base sauvegardée
              S := Copy(Tsl[i], 3, 255);
              S1 := Copy(S, pos(';', S) + 1, 255);
              Lab_Etat.Caption := 'Récupération de la base '; Lab_Etat.Update;
              application.ProcessMessages;

              if FileExists(Ginkoia + 'Sauve\BASES.IB') then
              begin
                DeleteFile(LaBase);
                If not CopyFile(PAnsiChar(Ginkoia + 'Sauve\BASES.IB'),PAnsiChar(LaBase),false) then
                  tslLog.Add('Retour KO - Echec de la copie de la base');
              end;

//              RecupFichier(Ginkoia + 'Sauve\BASES', LaBase);

              // Calcul du CRC
              NewCRC := DoNewCalcCRC32(LaBase);
              // Vérification avec l'ancien CRC
              if Trim(S1) <> IntToStr(NewCRC) then
              begin
                 tslLog.Add('CRC Incorrect : ' + LaBase);
                 tslLog.Add('Old : ' + S1 + ' / New : ' +  IntToStr(NewCRC));
              end;
           end
        end;

        // Si les logs ont bougés c'est qu'il y a eu un soucis lors du retour à un état stable
        if iLogCount <> tslLog.Count then
        begin
          if not automatique then
             Application.messageBox('La sauvegarde est altérée, impossible de revenir à un état stable', ' PROBLEME', Mb_Ok);
        end
        else
          tslLog.add('- OK Retour à un état stable ' + DateToStr(Date));

   Except on E:Exception do
      Showmessage('retourStable : ' + E.Message);
   end;
  finally
   tslLog.Savetofile(log);
   tsl.free;
   tslLog.Free;
   forcedirectories(Ginkoia + 'LiveUpdate\LOG\');
   CopyFile(Pchar(Log), Pchar(Ginkoia + 'LiveUpdate\LOG\' + ExtractFileName(Log)), False);
   deletefile(Log);
  end;
end;

procedure TFrm_Patch.RemplaceVal(Noeuds: IXMLDOMNodeList; TAG: string; Valeur: string);
var
   i: integer;
begin
   for i := 0 to Noeuds.Get_length - 1 do
   begin
      if Noeuds.item[i].Get_nodeName = Tag then
      begin
         if Noeuds.item[i].childNodes.Get_length = 0 then
            Noeuds.item[i].Set_text(Valeur)
         else
            Noeuds.item[i].childNodes.item[0].Set_nodeValue(Valeur);
         BREAK;
      end;
   end;
end;

procedure TFrm_Patch.AjouteNoeud(Xml: TMonXML; Noeud: string; Place: Integer;
   Valeur: string);
var
   Actu: string;
   S: string;
   Node: IXMLDOMNode;
   ok: Boolean;
   NodeAjout: TMonXml;
   i: Integer;
begin
   NodeAjout := TMonXml.Create;
   try
      NodeAjout.LoadXML(Valeur);
      NodeAjout.First;
      S := Noeud;
      if Pos('/', S) > 0 then
      begin
         Actu := Copy(S, 1, Pos('/', S) - 1);
         delete(S, 1, Pos('/', S));
      end
      else
      begin
         Actu := S;
         S := '';
      end;
      Xml.First;
      while not Xml.EOF do
      begin
         if Xml.Get_CurrentNode.Get_nodeName = Actu then
         begin
            Node := xml.Get_CurrentNode;
            ok := true;
            while (S <> '') and ok do
            begin
               if Pos('/', S) > 0 then
               begin
                  Actu := Copy(S, 1, Pos('/', S) - 1);
                  delete(S, 1, Pos('/', S));
               end
               else
               begin
                  Actu := S;
                  S := '';
               end;
               ok := false;
               for i := 0 to Node.childNodes.length - 1 do
               begin
                  if Node.childNodes.Item[i].Get_nodeName = Actu then
                  begin
                     Ok := true;
                     Node := Node.childNodes.Item[i];
                     BREAK;
                  end;
               end;
            end;
            if ok then
            begin
              // Mon Node contient le Noeud en question
               if Place <= 0 then
               begin
                  Node.insertBefore(NodeAjout.Get_CurrentNode, Node.childNodes.Item[0]);
               end
               else if Place >= Node.childNodes.Get_length then
               begin
                  Node.appendChild(NodeAjout.Get_CurrentNode);
               end
               else
               begin
                  Node.insertBefore(NodeAjout.Get_CurrentNode, Node.childNodes.Item[Place - 1]);
               end;
            end;
            BREAK;
         end;
         Xml.Next;
      end;
   finally
      NodeAjout.free;
   end;
end;

function TFrm_Patch.ChercheVal(Noeuds: IXMLDOMNodeList;
   TAG: string): string;
var
   i: integer;
begin
   result := '';
   for i := 0 to Noeuds.Get_length - 1 do
   begin
      if Noeuds.item[i].Get_nodeName = Tag then
      begin
         if Noeuds.item[i].childNodes.Get_length < 1 then
            result := ''
         else if Noeuds.item[i].childNodes.item[0].Get_nodeValue <> Null then
            result := Noeuds.item[i].childNodes.item[0].Get_nodeValue;
         BREAK;
      end;
   end;
end;

function TFrm_Patch.ChercheMinVal(Noeuds: IXMLDOMNodeList; NoeudFils: string; TAG: string): string;
var
   i: integer;
   S: string;
   code: Integer;
   D, d1: Double;
begin
   result := '';
   for i := 0 to Noeuds.Get_length - 1 do
   begin
      if Noeuds.item[i].Get_nodeName = NoeudFils then
      begin
         S := ChercheVal(Noeuds.item[i].childNodes, Tag);
         if result = '' then
            result := S
         else if (S <> '') then
         begin
            Val(S, D, Code);
            d1 := 0;
            if code = 0 then
               Val(result, D1, Code);
            if code = 0 then
            begin
               if d1 > d then
                  result := S;
            end
            else
            begin
               if (result > S) then
                  result := S;
            end;
         end;
      end;
   end;
end;

function TFrm_Patch.ChercheMaxVal(Noeuds: IXMLDOMNodeList; NoeudFils: string;
   TAG: string): string;
var
   i: integer;
   S: string;
   d, d1: double;
   code: Integer;
begin
   result := '';
   for i := 0 to Noeuds.Get_length - 1 do
   begin
      if Noeuds.item[i].Get_nodeName = NoeudFils then
      begin
         S := ChercheVal(Noeuds.item[i].childNodes, Tag);
         if result = '' then
            result := S
         else if (S <> '') then
         begin
            Val(S, D, Code);
            d1 := 0;
            if code = 0 then
               Val(result, D1, Code);
            if code = 0 then
            begin
               if d1 < d then
                  result := S;
            end
            else
            begin
               if (result < S) then
                  result := S;
            end;
         end;
      end;
   end;
end;

function TFrm_Patch.Existe(Noeuds: IXMLDOMNodeList; TAG,
   Valeur: string): Boolean;
var
   i: integer;
begin
   result := false;
   for i := 0 to Noeuds.Get_length - 1 do
   begin
      if Noeuds.item[i].Get_nodeName = Tag then
      begin
         if Noeuds.item[i].childNodes.item[0].Get_nodeValue = Valeur then
            result := true;
         BREAK;
      end;
   end;
end;

function TFrm_Patch.Existes(Noeuds: IXMLDOMNodeList; NoeudFils: string; TAG, Valeur: string): Integer;
var
   i: integer;
begin
   result := -1;
   for i := 0 to Noeuds.Get_length - 1 do
   begin
      if Noeuds.item[i].Get_nodeName = NoeudFils then
      begin
         if Existe(Noeuds.item[i].childNodes, Tag, Valeur) then
         begin
            result := I + 1;
            BREAK;
         end;
      end;
   end;
end;

procedure Detruit(src: string);
var
   f: tsearchrec;
begin
   if src[length(src)] <> '\' then
      src := src + '\';
   if findfirst(src + '*.*', faanyfile, f) = 0 then
   begin
      repeat
         if (f.name <> '.') and (f.name <> '..') then
         begin
            if f.Attr and faDirectory = 0 then
            begin
               fileSetAttr(src + f.Name, 0);
               deletefile(src + f.Name);
            end
            else
               Detruit(Src + f.name);
         end;
      until findnext(f) <> 0;
   end;
   findclose(f);
   RemoveDir(Src);
end;

function TFrm_Patch.Traitement_BATCH(LeFichier: string; Log: TstringList; LogName: string): Boolean;
var
   PassTsl: TstringList;
   Tsl: TstringList;
   LesVar: TstringList;
   LesVal: TstringList;
   LaPille: TstringList;
   Ordre: string;
   MarqueurEai: Integer;
   EaiEnCours: Integer;
   XML: TMonXML;
   PathOrdre: string;
   PathEAI: string;
   i: Integer;
   S: string;
   LeTemps: Dword;
   Temps: Dword;
   timeout: Boolean;

   NoeudsEnCours: IXMLDOMNodeList;
   NoeudConcerne: string;
   ValeurEnCours: Integer;
   MarqueurNoeuds: Integer;

   function LeTimeOut: boolean;
   begin
      result := false;
      if timeout then
      begin
         if GetTickCount > LeTemps then
         begin
            result := true;
         end;
      end;
   end;

   function remplacer(S: string; Cherche: string; Valeur: string): string;
   var
      j: Integer;
   begin
      while Pos(Cherche, S) > 0 do
      begin
         j := Pos(Cherche, S);
         if j > 0 then
         begin
            delete(S, j, length(cherche));
            Insert(valeur, S, J);
         end;
      end;
      result := S;
   end;

   function Traite(S: string): string;
   var
      i: integer;
   begin
      S := remplacer(S, '[GINKOIA]', Ginkoia);
      S := remplacer(S, '[ACTUEL]', PathOrdre);
      S := remplacer(S, '[EAI]', PathEAI);
      for i := 0 to lesVar.count - 1 do
      begin
         S := remplacer(S, lesVar[i], LesVal[i]);
      end;
      result := s;
   end;

   function PositionsurNoeuds(Placedunoeud: string): IXMLDOMNodeList;
   var
      i: Integer;
      ok: Boolean;
      SousNoeud: string;
   begin
      Xml.First;
      result := Xml.Get_CurrentNodeList;
      while (Placedunoeud <> '') do
      begin
         if Pos('/', Placedunoeud) > 0 then
         begin
            SousNoeud := Copy(Placedunoeud, 1, Pos('/', Placedunoeud) - 1);
            delete(Placedunoeud, 1, Pos('/', Placedunoeud));
         end
         else
         begin
            SousNoeud := Placedunoeud;
            Placedunoeud := '';
         end;
         i := 0;
         Ok := false;
         while i < result.Get_length do
         begin
            if result.Item[i].Get_nodeName = SousNoeud then
            begin
               result := result.Item[i].Get_childNodes;
               ok := true;
               BREAK;
            end;
            Inc(i);
         end;
         if not ok then
         begin
            Result := nil;
            BREAK;
         end;
      end;
   end;

   function TraiteVal(S: string): string;

   var
      Ordre: string;
      SSOrdre: string;
      PlaceduNoeud: string;
      Noeuds: IXMLDOMNodeList;
      NoeudFils: string;
      TAG: string;
      Place: string;
      reg: tregistry;
      Var1: string;
   begin
      result := '';
      if pos('=', S) > 0 then
      begin
         Ordre := Copy(S, 1, pos('=', S) - 1);
         delete(S, 1, pos('=', S));
         if Ordre = 'REGLIT' then
         begin
            SSOrdre := Traite(Copy(S, 1, Pos(';', S) - 1));
            delete(S, 1, pos(';', S));
            reg := tregistry.Create(Key_READ);
            try
               Var1 := Copy(SSOrdre, 1, pos('\', SSOrdre));
               delete(SSOrdre, 1, pos('\', SSOrdre));
               if Var1 = 'HKEY_LOCAL_MACHINE\' then
                  reg.RootKey := HKEY_LOCAL_MACHINE
               else if Var1 = 'HKEY_CLASSES_ROOT\' then
                  reg.RootKey := HKEY_CLASSES_ROOT
               else if Var1 = 'HKEY_CURRENT_USER\' then
                  reg.RootKey := HKEY_CURRENT_USER
               else if Var1 = 'HKEY_USERS\' then
                  reg.RootKey := HKEY_USERS
               else if Var1 = 'HKEY_CURRENT_CONFIG\' then
                  reg.RootKey := HKEY_CURRENT_CONFIG;
               if reg.OpenKey(SSOrdre, True) then
               begin
                  S := traite(S);
                  result := reg.ReadString(S);
                  reg.closeKey;
               end;
            finally
               reg.free;
            end;
         end
         else if Ordre = 'POS' then
         begin
            SSOrdre := Copy(S, 1, Pos(';', S) - 1);
            delete(S, 1, Pos(';', S));
            S := traite(S);
            SSOrdre := traite(SSOrdre);
            result := Inttostr(Pos(SSOrdre, S));
         end
         else if Ordre = 'ADD' then
         begin
            SSOrdre := Copy(S, 1, Pos(';', S) - 1);
            delete(S, 1, Pos(';', S));
            S := traite(S);
            SSOrdre := traite(SSOrdre);
            result := Inttostr(StrToInt(S) + StrToInt(SSOrdre));
         end
         else if Ordre = 'COPY' then
         begin
            SSOrdre := Copy(S, 1, Pos(';', S) - 1);
            delete(S, 1, Pos(';', S));
            Place := Copy(S, 1, Pos(';', S) - 1);
            delete(S, 1, Pos(';', S));
            SSOrdre := traite(SSOrdre);
            S := Traite(S);
            Place := traite(Place);
            result := Copy(SSOrdre, StrToInt(Place), StrToInt(s));
         end
         else if Ordre = 'DELETE' then
         begin
            SSOrdre := Copy(S, 1, Pos(';', S) - 1);
            delete(S, 1, Pos(';', S));
            Place := Copy(S, 1, Pos(';', S) - 1);
            delete(S, 1, Pos(';', S));
            SSOrdre := traite(SSOrdre);
            Place := traite(Place);
            S := Traite(S);
            Delete(SSOrdre, StrToInt(Place), StrToInt(s));
            result := SSOrdre;
         end
         else if Ordre = 'CONCAT' then
         begin
            SSOrdre := Copy(S, 1, Pos(';', S) - 1);
            delete(S, 1, Pos(';', S));
            SSOrdre := traite(SSOrdre);
            S := Traite(S);
            result := SSOrdre + S;
         end
         else if Ordre = 'XML' then
         begin
            Xml.First;
            SSOrdre := Copy(S, 1, Pos(';', S) - 1);
            delete(S, 1, Pos(';', S));
            if SSOrdre = 'GETVALEUR' then
            begin
               result := ChercheVal(NoeudsEnCours.item[ValeurEnCours].Get_childNodes, S);
            end
            else if SSOrdre = 'EXISTES' then
            begin
               Placedunoeud := Copy(S, 1, Pos(';', S) - 1); delete(S, 1, Pos(';', S));
               Noeuds := PositionsurNoeuds(Placedunoeud);
               if Noeuds <> nil then
               begin
                  NoeudFils := Copy(S, 1, Pos(';', S) - 1); delete(S, 1, Pos(';', S));
                  TAG := Copy(S, 1, Pos(';', S) - 1); delete(S, 1, Pos(';', S));
                  result := Inttostr(Existes(Noeuds, NoeudFils, Tag, Traite(S)));
               end;
            end
            else if SSOrdre = 'MINVALUE' then
            begin
               Placedunoeud := Copy(S, 1, Pos(';', S) - 1); delete(S, 1, Pos(';', S));
               Noeuds := PositionsurNoeuds(Placedunoeud);
               if Noeuds <> nil then
               begin
                  NoeudFils := Copy(S, 1, Pos(';', S) - 1); delete(S, 1, Pos(';', S));
                  result := ChercheMinVal(Noeuds, NoeudFils, S);
               end;
            end
            else if SSOrdre = 'MAXVALUE' then
            begin
               Placedunoeud := Copy(S, 1, Pos(';', S) - 1); delete(S, 1, Pos(';', S));
               Noeuds := PositionsurNoeuds(Placedunoeud);
               if Noeuds <> nil then
               begin
                  NoeudFils := Copy(S, 1, Pos(';', S) - 1); delete(S, 1, Pos(';', S));
                  result := ChercheMaxVal(Noeuds, NoeudFils, S);
               end;
            end;
         end;
      end
      else
         result := S;
   end;

   function TraiteOrdre(Ordre: string; Valeur: string; I: Integer): Integer;
   var
      s: string;
      SSOrdre: string;
      j: Integer;
      Noeud: string;
      Place: Integer;
      Var1: string;
      Var2: string;

      MonPathExtract: string;

      reg: tregistry;
      Arch : I7zInArchive;
   begin
      if (ordre <> '') and (Ordre[1] <> ';') then
      begin
         S := Valeur;
         if ORDRE = 'REGADD' then
         begin
            SSOrdre := Traite(Copy(S, 1, Pos(';', S) - 1));
            delete(S, 1, pos(';', S));
            reg := tregistry.Create(Key_ALL_ACCESS);
            try
               Var1 := Copy(SSOrdre, 1, pos('\', SSOrdre));
               delete(SSOrdre, 1, pos('\', SSOrdre));
               if Var1 = 'HKEY_LOCAL_MACHINE\' then
                  reg.RootKey := HKEY_LOCAL_MACHINE
               else if Var1 = 'HKEY_CLASSES_ROOT\' then
                  reg.RootKey := HKEY_CLASSES_ROOT
               else if Var1 = 'HKEY_CURRENT_USER\' then
                  reg.RootKey := HKEY_CURRENT_USER
               else if Var1 = 'HKEY_USERS\' then
                  reg.RootKey := HKEY_USERS
               else if Var1 = 'HKEY_CURRENT_CONFIG\' then
                  reg.RootKey := HKEY_CURRENT_CONFIG;
               if reg.OpenKey(SSOrdre, True) then
               begin
                  SSOrdre := traite(Copy(S, 1, Pos(';', S) - 1));
                  delete(S, 1, pos(';', S));
                  S := traite(S);
                  reg.WriteString(SSOrdre, S);
                  reg.closeKey;
               end;
            finally
               reg.free;
            end;
            inc(i);
         end
         else if ORDRE = 'REGSUP' then
         begin
            SSOrdre := Traite(Copy(S, 1, Pos(';', S) - 1));
            delete(S, 1, pos(';', S));
            reg := tregistry.Create(Key_ALL_ACCESS);
            try
               Var1 := Copy(SSOrdre, 1, pos('\', SSOrdre));
               delete(SSOrdre, 1, pos('\', SSOrdre));
               if Var1 = 'HKEY_LOCAL_MACHINE\' then
                  reg.RootKey := HKEY_LOCAL_MACHINE
               else if Var1 = 'HKEY_CLASSES_ROOT\' then
                  reg.RootKey := HKEY_CLASSES_ROOT
               else if Var1 = 'HKEY_CURRENT_USER\' then
                  reg.RootKey := HKEY_CURRENT_USER
               else if Var1 = 'HKEY_USERS\' then
                  reg.RootKey := HKEY_USERS
               else if Var1 = 'HKEY_CURRENT_CONFIG\' then
                  reg.RootKey := HKEY_CURRENT_CONFIG;
               if reg.OpenKey(SSOrdre, True) then
               begin
                  S := traite(S);
                  reg.DeleteValue(S);
                  reg.closeKey;
               end;
            finally
               reg.free;
            end;
            inc(i);
         end
         else if ORDRE = 'REGSUPCLEF' then
         begin
            SSOrdre := Traite(Copy(S, 1, Pos(';', S) - 1));
            delete(S, 1, pos(';', S));
            reg := tregistry.Create(Key_ALL_ACCESS);
            try
               Var1 := Copy(SSOrdre, 1, pos('\', SSOrdre));
               delete(SSOrdre, 1, pos('\', SSOrdre));
               if Var1 = 'HKEY_LOCAL_MACHINE\' then
                  reg.RootKey := HKEY_LOCAL_MACHINE
               else if Var1 = 'HKEY_CLASSES_ROOT\' then
                  reg.RootKey := HKEY_CLASSES_ROOT
               else if Var1 = 'HKEY_CURRENT_USER\' then
                  reg.RootKey := HKEY_CURRENT_USER
               else if Var1 = 'HKEY_USERS\' then
                  reg.RootKey := HKEY_USERS
               else if Var1 = 'HKEY_CURRENT_CONFIG\' then
                  reg.RootKey := HKEY_CURRENT_CONFIG;
               S := traite(S);
               reg.DeleteKey(S);
            finally
               reg.free;
            end;
            inc(i);
         end
         else if ORDRE = 'SUPDIR' then
         begin
            S := traite(S);
            Detruit(S);
            inc(i);
         end
         else if ORDRE = 'UNZIP' then
         begin
            S := traite(S);

//            ZipM.ZipFileName := S;
            MonPathExtract := S;
            while pos('\', MonPathExtract) > 0 do
               delete(MonPathExtract, 1, pos('\', MonPathExtract));
            MonPathExtract := Ginkoia + 'LiveUpdate\' + ChangeFileExt(MonPathExtract, '') + '\';
//            ZipM.ExtrBaseDir := MonPathExtract;
//            zipM.Extract;
            Arch := CreateInArchive(CLSID_CFormatZip);
            Arch.OpenFile(S);
            Arch.ExtractTo(MonPathExtract);

            inc(i);
         end
         else if ORDRE = 'COMMANDE' then
         begin
            S := traite(S);
            if Fileexists(S) then
            begin
               if not Traitement_BATCH(S, Log, LogName) then
               begin
                  result := 99999;
                  EXIT;
               end;
            end;
            inc(i);
         end
         else if Ordre = 'CALL' then
         begin
            J := 0;
            while (j < tsl.count) and (tsl[j] <> 'BCL=' + S) do
               Inc(j);
            if j < tsl.count then
            begin
               LaPille.Add(Inttostr(i));
               i := J;
            end;
         end
         else if Ordre = 'RETURN' then
         begin
            if LaPille.count > 0 then
            begin
               S := LaPille[LaPille.Count - 1];
               LaPille.Delete(LaPille.Count - 1);
               I := StrToInt(S);
            end;
            inc(i);
         end
         else if ordre = 'TOUT_NOEUD' then
         begin
            if S = 'END' then
            begin
               if NoeudsEnCours <> nil then
               begin
                  inc(ValeurEnCours);
                  while (ValeurEnCours < NoeudsEnCours.Get_length) and
                     (NoeudsEnCours.item[ValeurEnCours].Get_nodeName <> NoeudConcerne) do
                     inc(ValeurEnCours);
                  if ValeurEnCours >= NoeudsEnCours.Get_length then
                     NoeudsEnCours := nil;
                  if NoeudsEnCours <> nil then
                  begin
                     i := MarqueurNoeuds;
                  end;
               end;
               Inc(i);
            end
            else
            begin
               SSOrdre := Copy(S, 1, Pos(';', S) - 1);
               delete(S, 1, pos(';', S));
               NoeudsEnCours := PositionsurNoeuds(SSOrdre);
               NoeudConcerne := S;
               MarqueurNoeuds := i;
               if NoeudsEnCours <> nil then
               begin
                  ValeurEnCours := 0;
                  while (ValeurEnCours < NoeudsEnCours.Get_length) and
                     (NoeudsEnCours.item[ValeurEnCours].Get_nodeName <> NoeudConcerne) do
                     inc(ValeurEnCours);
                  if ValeurEnCours >= NoeudsEnCours.Get_length then
                     NoeudsEnCours := nil;
               end;
               if NoeudsEnCours = nil then
               begin
                  while tsl[i] <> 'TOUT_NOEUD=END' do
                     Inc(i);
               end;
               inc(i);
            end;
         end
         else if ordre = 'RENAME' then
         begin
            SSOrdre := Copy(S, 1, Pos(';', S) - 1);
            delete(S, 1, pos(';', S));
            S := traite(S);
            SSOrdre := traite(SSOrdre);
            RenameFile(SSOrdre, S);
            Inc(i);
         end
            {
            ELSE IF ORDRE = 'SCRIPT' THEN
            BEGIN
                S := Traite(S);
                IbScript.Sql.Loadfromfile(S);
                IF NOT tran.InTransaction THEN
                    tran.StartTransaction;
                IbScript.Execute;
                IF tran.InTransaction THEN
                    tran.commit;
                Inc(i);
            END
            }
         else if ORDRE = 'EXECUTE' then
         begin
            S := Traite(S);
            Winexec(PChar(S), 0);
            inc(i);
         end
         else if ORDRE = 'STOP' then
         begin
            Lapplication := S;
            EnumWindows(@Enumerate, 0);
            Lapplication := S;
            EnumWindows(@Enumerate, 0);
            inc(i);
         end
         else if ORDRE = 'TIMEOUT' then
         begin
            timeout := true;
            temps := StrToInt(S);
            inc(i);
         end
         else if ORDRE = 'STOPTIMEOUT' then
         begin
            timeout := False;
            inc(i);
         end
         else if ORDRE = 'DELAY' then
         begin
            LeTemps := StrToInt(S);
            LeTemps := GetTickCount + LeTemps;
            while GetTickCount < LeTemps do
            begin
               Sleep(1000);
               Application.processMessages;
            end;
            inc(i);
         end
         else if ORDRE = 'SUPPRIME' then
         begin
            S := traite(S);
            if FileExists(S) then
            begin
              FileSetAttr(Pchar(S), 0);
              DeleteFile(S);
            end;
            Inc(i);
         end
         else if ORDRE = 'ATTENTE' then
         begin
            SSOrdre := Copy(S, 1, Pos('=', S) - 1);
            delete(S, 1, pos('=', S));
            if SSOrdre = 'FIN' then
            begin
               LeTemps := GetTickCount + Temps;
               repeat
                  AppliTourne := False;
                  Lapplication := uppercase(S);
                  EnumWindows(@Enumerate2, 0);
                  if LeTimeOut then
                  begin
                     result := 99999;
                     EXIT;
                  end;
                  Sleep(250);
               until not (AppliTourne);
            end
            else if SSOrdre = 'DEBUT' then
            begin
               LeTemps := GetTickCount + Temps;
               repeat
                  AppliTourne := False;
                  Lapplication := uppercase(S);
                  EnumWindows(@Enumerate2, 0);
                  if LeTimeOut then
                  begin
                     result := 99999;
                     EXIT;
                  end;
                  sleep(250);
               until AppliTourne;
            end
            else if SSOrdre = 'FILEEXISTS' then
            begin
               S := traite(S);
               LeTemps := GetTickCount + Temps;
               while not Fileexists(S) do
               begin
                  sleep(1000);
                  if LeTimeOut then
                  begin
                     result := 99999;
                     EXIT;
                  end;
               end;
            end
            else if SSOrdre = 'MAPSTART' then
            begin
               S := uppercase(s);
               if S = 'GINKOIA' then
               begin
                  LeTemps := GetTickCount + Temps;
                  while not MapGinkoia.Ginkoia do
                  begin
                     sleep(1000);
                     if LeTimeOut then
                     begin
                        result := 99999;
                        EXIT;
                     end;
                  end;
               end
               else if S = 'CAISSE' then
               begin
                  LeTemps := GetTickCount + Temps;
                  while not MapGinkoia.Caisse do
                  begin
                     sleep(1000);
                     if LeTimeOut then
                     begin
                        result := 99999;
                        EXIT;
                     end;
                  end;
               end
               else if S = 'LAUNCHER' then
               begin
                  LeTemps := GetTickCount + Temps;
                  while not MapGinkoia.Launcher do
                  begin
                     sleep(1000);
                     if LeTimeOut then
                     begin
                        result := 99999;
                        EXIT;
                     end;
                  end;
               end
               else if S = 'BACKUP' then
               begin
                  LeTemps := GetTickCount + Temps;
                  while not MapGinkoia.Backup do
                  begin
                     sleep(1000);
                     if LeTimeOut then
                     begin
                        result := 99999;
                        EXIT;
                     end;
                  end;
               end
               else if S = 'LIVEUPDATE' then
               begin
                  LeTemps := GetTickCount + Temps;
                  while not MapGinkoia.LiveUpdate do
                  begin
                     sleep(1000);
                     if LeTimeOut then
                     begin
                        result := 99999;
                        EXIT;
                     end;
                  end;
               end
               else if S = 'MAJAUTO' then
               begin
                  LeTemps := GetTickCount + Temps;
                  while not MapGinkoia.MajAuto do
                  begin
                     sleep(1000);
                     if LeTimeOut then
                     begin
                        result := 99999;
                        EXIT;
                     end;
                  end;
               end
               else if S = 'PARAMGINKOIA' then
               begin
                  LeTemps := GetTickCount + Temps;
                  while not MapGinkoia.ParamGinkoia do
                  begin
                     sleep(1000);
                     if LeTimeOut then
                     begin
                        result := 99999;
                        EXIT;
                     end;
                  end;
               end
               else if S = 'PING' then
               begin
                  LeTemps := GetTickCount + Temps;
                  while not MapGinkoia.Ping do
                  begin
                     sleep(1000);
                     if LeTimeOut then
                     begin
                        result := 99999;
                        EXIT;
                     end;
                  end;
               end
               else if S = 'PINGSTOP' then
               begin
                  LeTemps := GetTickCount + Temps;
                  while not MapGinkoia.PingStop do
                  begin
                     sleep(1000);
                     if LeTimeOut then
                     begin
                        result := 99999;
                        EXIT;
                     end;
                  end;
               end
               else if S = 'SCRIPT' then
               begin
                  LeTemps := GetTickCount + Temps;
                  while not MapGinkoia.Script do
                  begin
                     sleep(1000);
                     if LeTimeOut then
                     begin
                        result := 99999;
                        EXIT;
                     end;
                  end;
               end
               else if S = 'SCRIPTOK' then
               begin
                  LeTemps := GetTickCount + Temps;
                  while not MapGinkoia.ScriptOK do
                  begin
                     sleep(1000);
                     if LeTimeOut then
                     begin
                        result := 99999;
                        EXIT;
                     end;
                  end;
               end;
            end
            else if SSOrdre = 'MAPSTOP' then
            begin
               S := uppercase(s);
               if S = 'GINKOIA' then
               begin
                  LeTemps := GetTickCount + Temps;
                  while MapGinkoia.Ginkoia do
                  begin
                     sleep(1000);
                     if LeTimeOut then
                     begin
                        result := 99999;
                        EXIT;
                     end;
                  end;
               end
               else if S = 'CAISSE' then
               begin
                  LeTemps := GetTickCount + Temps;
                  while MapGinkoia.Caisse do
                  begin
                     sleep(1000);
                     if LeTimeOut then
                     begin
                        result := 99999;
                        EXIT;
                     end;
                  end;
               end
               else if S = 'LAUNCHER' then
               begin
                  LeTemps := GetTickCount + Temps;
                  while MapGinkoia.Launcher do
                  begin
                     sleep(1000);
                     if LeTimeOut then
                     begin
                        result := 99999;
                        EXIT;
                     end;
                  end;
               end
               else if S = 'BACKUP' then
               begin
                  LeTemps := GetTickCount + Temps;
                  while MapGinkoia.Backup do
                  begin
                     sleep(1000);
                     if LeTimeOut then
                     begin
                        result := 99999;
                        EXIT;
                     end;
                  end;
               end
               else if S = 'LIVEUPDATE' then
               begin
                  LeTemps := GetTickCount + Temps;
                  while MapGinkoia.LiveUpdate do
                  begin
                     sleep(1000);
                     if LeTimeOut then
                     begin
                        result := 99999;
                        EXIT;
                     end;
                  end;
               end
               else if S = 'MAJAUTO' then
               begin
                  LeTemps := GetTickCount + Temps;
                  while MapGinkoia.MajAuto do
                  begin
                     sleep(1000);
                     if LeTimeOut then
                     begin
                        result := 99999;
                        EXIT;
                     end;
                  end;
               end
               else if S = 'PARAMGINKOIA' then
               begin
                  LeTemps := GetTickCount + Temps;
                  while MapGinkoia.ParamGinkoia do
                  begin
                     sleep(1000);
                     if LeTimeOut then
                     begin
                        result := 99999;
                        EXIT;
                     end;
                  end;
               end
               else if S = 'PING' then
               begin
                  LeTemps := GetTickCount + Temps;
                  while MapGinkoia.Ping do
                  begin
                     sleep(1000);
                     if LeTimeOut then
                     begin
                        result := 99999;
                        EXIT;
                     end;
                  end;
               end
               else if S = 'PINGSTOP' then
               begin
                  LeTemps := GetTickCount + Temps;
                  while MapGinkoia.PingStop do
                  begin
                     sleep(1000);
                     if LeTimeOut then
                     begin
                        result := 99999;
                        EXIT;
                     end;
                  end;
               end
               else if S = 'SCRIPT' then
               begin
                  LeTemps := GetTickCount + Temps;
                  while MapGinkoia.Script do
                  begin
                     sleep(1000);
                     if LeTimeOut then
                     begin
                        result := 99999;
                        EXIT;
                     end;
                  end;
               end
               else if S = 'SCRIPTOK' then
               begin
                  LeTemps := GetTickCount + Temps;
                  while MapGinkoia.ScriptOK do
                  begin
                     sleep(1000);
                     if LeTimeOut then
                     begin
                        result := 99999;
                        EXIT;
                     end;
                  end;
               end;
            end;
            Inc(i);
         end
         else if Ordre = 'TOUT_EAI' then
         begin
            ssOrdre := S;
            if ssOrdre = 'BEGIN' then
            begin
               MarqueurEai := i;
               EaiEnCours := 0;
               PathEAI := LesEai[EaiEnCours];
            end
            else if ssOrdre = 'END' then
            begin
               inc(EaiEnCours);
               if EaiEnCours < LesEai.Count then
               begin
                  PathEAI := LesEai[EaiEnCours];
                  i := MarqueurEai;
               end;
            end;
            inc(i);
         end
         else if ordre = 'XML' then
         begin
            ssOrdre := Copy(S, 1, Pos(';', S) - 1);
            delete(S, 1, Pos(';', S));
            if ssOrdre = 'SETVALEUR' then
            begin
               Noeud := Copy(S, 1, Pos(';', S) - 1);
               delete(S, 1, Pos(';', S));
               Noeud := traite(Noeud);
               S := traite(S);
               RemplaceVal(NoeudsEnCours.item[ValeurEnCours].Get_childNodes, Noeud, S);
            end
            else if ssOrdre = 'LOAD' then
            begin
               PassTsl := TstringList.Create;
               Log.Add('Load XML ' + Traite(S)); Log.SaveToFile(LogName);
               PassTsl.loadFromFile(Traite(S));
               Log.Add('Parsing de ' + Traite(S)); Log.SaveToFile(LogName);
               Xml.LoadXML(PassTsl.Text);
               Log.Add('Parsing OK '); Log.SaveToFile(LogName);
               NoeudsEnCours := XML.Get_CurrentNodeList;
            end
            else if ssOrdre = 'SAVE' then
            begin
               xml.Save(traite(s));
            end
            else if ssOrdre = 'ADD' then
            begin
               Xml.First;
               Noeud := Copy(S, 1, Pos(';', S) - 1);
               delete(S, 1, Pos(';', S));
               Place := StrtoInt(Copy(S, 1, Pos(';', S) - 1));
               delete(S, 1, Pos(';', S));
               S := Traite(S);
               AjouteNoeud(Xml, Noeud, Place, S);
            end;
            inc(i)
         end
         else if ordre = 'GOTO' then
         begin
            j := 0;
            while j < tsl.count do
            begin
               if Uppercase(tsl.Names[j]) = 'BCL' then
               begin
                  SSOrdre := Copy(tsl[j], Pos('=', tsl[j]) + 1, Length(tsl[j]));
                  if SSOrdre = S then
                  begin
                     I := J;
                     BREAK;
                  end;
               end;
               Inc(j);
            end;
            Inc(i);
         end
         else if Copy(Ordre, 1, 2) = '$$' then
         begin
              // Variable ;
            j := LesVar.IndexOf(Ordre);
            if j = -1 then
            begin
               J := LesVar.Add(Ordre);
               LesVal.Add('');
            end;
            LesVal[j] := TraiteVal(S);
            Inc(i);
         end
         else if Ordre = 'SI' then
         begin
            SSOrdre := Copy(S, 1, Pos(')', S));
            Delete(S, 1, Pos(')', S));
            Delete(S, 1, Pos(';', S));
            if Copy(SSOrdre, 1, Pos('(', SSOrdre)) = 'DIFF(' then
            begin
               delete(SSOrdre, 1, Pos('(', SSOrdre));
               Var1 := Copy(SSOrdre, 1, Pos(';', SSOrdre) - 1);
               delete(SSOrdre, 1, Pos(';', SSOrdre));
               Var2 := Copy(SSOrdre, 1, Pos(')', SSOrdre) - 1);
               if Copy(var1, 1, 2) = '$$' then
                  Var1 := Traite(Var1);
               if Copy(var2, 1, 2) = '$$' then
                  Var2 := Traite(Var2);
               if Var1 <> var2 then
               begin
                  Ordre := Copy(S, 1, pos('=', S) - 1);
                  delete(S, 1, Pos('=', S));
                  I := TraiteOrdre(Ordre, S, i);
               end
               else
                  Inc(i);
            end
            else if Copy(SSOrdre, 1, Pos('(', SSOrdre)) = 'EGAL(' then
            begin
               delete(SSOrdre, 1, Pos('(', SSOrdre));
               Var1 := Copy(SSOrdre, 1, Pos(';', SSOrdre) - 1);
               delete(SSOrdre, 1, Pos(';', SSOrdre));
               Var2 := Copy(SSOrdre, 1, Pos(')', SSOrdre) - 1);
               if Copy(var1, 1, 2) = '$$' then
                  Var1 := Traite(Var1);
               if Copy(var2, 1, 2) = '$$' then
                  Var2 := Traite(Var2);
               if Var1 = var2 then
               begin
                  Ordre := Copy(S, 1, pos('=', S) - 1);
                  delete(S, 1, Pos('=', S));
                  I := TraiteOrdre(Ordre, S, i);
               end
               else
                  Inc(i);
            end;
         end
         else
         begin
            inc(i);
         end;
      end
      else
         inc(i);
      result := i;
   end;

begin
   Tsl := TstringList.Create;
   LesVar := TstringList.Create;
   LesVal := TstringList.Create;
   LaPille := TstringList.Create;
   XML := TMonXML.Create;

   Log.Add('Ouverture de ' + LeFichier); Log.SaveToFile(LogName);
   tsl.LoadFromFile(LeFichier);
   i := 0;
   TimeOut := false;
   PathOrdre := IncludeTrailingBackslash(ExtractFilePath(LeFichier));
   Temps := 0;

   MarqueurEai := -1;
   MarqueurNoeuds := -1;
   Lab_Fichier.Caption := 'Execution de ' + LeFichier; Lab_Fichier.Update;
   application.ProcessMessages;

   try
      Pb2.Max := tsl.count;
      Pb2.position := i + 1;
   except
   end;
   while i < tsl.count do
   begin
      Ordre := Uppercase(trim(tsl.Names[i]));
      Log.Add('Execute ' + tsl[i]); Log.SaveToFile(LogName);
      Lab_Fichier.Caption := 'Execution de ' + LeFichier; Lab_Fichier.Update;
      application.ProcessMessages;

      try
         Pb2.Max := tsl.count;
         Pb2.position := i + 1;
      except
      end;
      S := trim(Copy(tsl[i], Pos('=', tsl[i]) + 1, Length(tsl[i])));
      i := TraiteOrdre(Ordre, S, i);
   end;
   Log.Add('Fin du fichier '); Log.SaveToFile(LogName);
   result := i <> 99999;
   XML.free;
   LesVar.free;
   LesVal.free;
   Tsl.free;
   LaPille.free;
end;

procedure TFrm_Patch.Bout2Click(Sender: TObject);
begin
   pc.ActivePage := VERIF1;
   tim_auto.tag := 3;
   if automatique then tim_auto.enabled := true;
end;

function TFrm_Patch.traiteversion(S: string): string;
var
   S1: string;
begin
   result := '';
   while pos('.', S) > 0 do
   begin
      S1 := Copy(S, 1, pos('.', S));
      delete(S, 1, pos('.', S));
      while (Length(S1) > 2) and (S1[1] = '0') do delete(S1, 1, 1);
      result := result + S1;
   end;
   S1 := S;
   while (Length(S1) > 1) and (S1[1] = '0') do delete(S1, 1, 1);
   result := result + S1;
end;

procedure TFrm_Patch.Bout3Click(Sender: TObject);
var
   TmLesFic: TmemoryStream;
   Frm_Verification: TFrm_Verification;
   connex: TLesConnexion;
begin
   Screen.Cursor := crhourglass;
   enabled := false;
   try
      RzLabel7.visible := true; Update;
      application.ProcessMessages;

      TmLesFic := TmemoryStream.Create;
      try
         TmLesFic.LoadFromFile(Ginkoia + 'LiveUpdate\Patch.GIN');
         TmLesFic.seek(0, soFromBeginning);
         AncVersion := ReadString(TmLesFic);
         AncNumero := ReadString(TmLesFic);
         NvlVersion := ReadString(TmLesFic);
         NvlNumero := ReadString(TmLesFic);
      finally
         TmLesFic.free;
      end;
      data.dataBaseName := LaBase;
      Que_Version.Open;
      VersionEnCours := Que_VersionVER_VERSION.AsString;
      Que_Version.Close;

      LesEai := tstringlist.Create;
      IBQue_EAI.Open;
      IBQue_EAI.first;
      while not IBQue_EAI.eof do
      begin
         Update;
         application.ProcessMessages;
         LesEai.Add(IBQue_EAIREP_PLACEEAI.AsString);
         IBQue_EAI.next;
      end;
      IBQue_EAI.close;

      ListeConnexion := Tlist.create;
      IB_Connexion.Open;
      IB_Connexion.First;
      while not IB_Connexion.Eof do
      begin
         connex := TLesConnexion.Create;
         connex.Id := IB_ConnexionCON_ID.AsInteger;
         connex.Nom := IB_ConnexionCON_NOM.AsString;
         connex.TEL := IB_ConnexionCON_TEL.AsString;
         connex.LeType := IB_ConnexionCON_TYPE.AsInteger;
         ListeConnexion.Add(connex);
         IB_Connexion.Next;
      end;
      IB_Connexion.Close;

      data.Close;
      VersionEnCours := traiteversion(VersionEnCours);
      if trim(VersionEnCours) <> trim(AncNumero) then
      begin
         RzLabel3.caption := Format(RzLabel3.caption, [AncVersion]);
         Deletefile(Ginkoia + 'LiveUpdate\Patch.GIN');
         Deletefile(Ginkoia + 'LiveUpdate\Patch.ZIP');
         pc.activepage := ERRVER;
         tim_auto.tag := 4;
         if automatique then tim_auto.enabled := true;

      end
      else
      begin
         Connexion;
         try
            Application.CreateForm(TFrm_Verification, Frm_Verification);
            try
               if not Frm_Verification.Connexion then
               begin
                  pc.activepage := ERRCONN;
                  tim_auto.tag := 5;
                  if automatique then tim_auto.enabled := true;
               end
               else suite1;
            finally
               Frm_Verification.release;
            end;
         except
         end;
         Deconnexion;
      end;
   finally
      Screen.Cursor := CrDefault;
      enabled := true;
   end;
end;

function TFrm_Patch.StopServiceRepl: boolean;
var
   hSCManager: SC_HANDLE;
   hService: SC_HANDLE;
   Statut: TServiceStatus;
   tempMini: DWORD;
   CheckPoint: DWORD;
   Interbase7: Boolean;
   reg: Tregistry;
   S: string;
begin
   result := false;
   reg := Tregistry.Create;
   try
      reg.Access := KEY_READ;
      Reg.RootKey := HKEY_LOCAL_MACHINE;
      Reg.OpenKey('\Software\Borland\Interbase\CurrentVersion', False);
      S := Reg.ReadString('Version');
   finally
      reg.free;
   end;
   Interbase7 := Copy(S, 1, 5) = 'WI-V7';
   if not Interbase7 then EXIT;
   hSCManager := OpenSCManager(nil, nil, SC_MANAGER_CONNECT);
   hService := OpenService(hSCManager, 'IBRepl', SERVICE_QUERY_STATUS or SERVICE_START or SERVICE_STOP or SERVICE_PAUSE_CONTINUE);
   if hService <> 0 then
   begin
      QueryServiceStatus(hService, Statut);
      if statut.dwCurrentState = SERVICE_RUNNING then
      begin
         tempMini := Statut.dwWaitHint + 10;
         ControlService(hService, SERVICE_CONTROL_PAUSE, Statut);
         repeat
            CheckPoint := Statut.dwCheckPoint;
            Sleep(tempMini);
            QueryServiceStatus(hService, Statut);
         until (CheckPoint = Statut.dwCheckPoint) or
            (statut.dwCurrentState = SERVICE_PAUSED);
            // si CheckPoint = Statut.dwCheckPoint Alors le service est dans les choux
         result := true;
      end;
   end;
   CloseServiceHandle(hService);
   CloseServiceHandle(hSCManager);
end;


procedure TFrm_Patch.suite1;
var
   Frm_Verification: TFrm_Verification;
   _Dep: string;
   _Arr: string;
   reg: Tregistry;
   refrepli: string;
begin
   Screen.Cursor := crhourglass;
   enabled := false;
   try
      Update;
      application.ProcessMessages;

      Application.CreateForm(TFrm_Verification, Frm_Verification);
      try
         Frm_Verification.de_a_version(_Dep, _Arr);
         if (_dep <> uppercase(AncVersion)) or
            (_arr <> uppercase(NvlVersion)) then
         begin
            pc.activepage := ERRVALID;
            tim_auto.tag := 6;
            if automatique then tim_auto.enabled := true;

         end
         else
         begin
            Frm_Verification.pb := pb_1;
            Frm_Verification.pb2 := pb_2;
            Frm_Verification.Fic := fic; fic.Caption := '';
            RzLabel7.visible := true;
            pb1.Visible := true; pb2.Visible := true; fic.Visible := true;
            Frm_Verification.Automatique := false;
            Frm_Verification.Verifielaversion;
            Frm_Verification.MetAJourlaversion;

            // Test pour les caisse autonome
            reg := Tregistry.Create;
            try
               reg.Access := KEY_READ;
               Reg.RootKey := HKEY_LOCAL_MACHINE;
               reg.OpenKey('Software\Algol\Ginkoia', False);
               refrepli := reg.ReadString('REPL_REFERENCE');
            finally
               reg.free;
            end;
            if trim(refrepli) <> '' then
            begin
               Que_Sql.Sql.Clear;
               Que_Sql.Sql.Add('Select rdb$GENERATOR_NAME NAME');
               Que_Sql.Sql.Add('From rdb$GENERATORS');
               Que_Sql.Sql.Add('Where rdb$GENERATOR_NAME= ''REPL_GENERATOR''');
               Que_Sql.Open;
               if not Que_Sql.isempty then
               begin
                  Que_Sql.Close;
                  Que_Sql.Sql.Clear;
                  Que_Sql.Sql.Add('Select Count(*) from REPL_LOG');
                  Que_Sql.Open;
                  if Que_Sql.Fields[0].AsInteger > 0 then
                  begin
                     Que_Sql.Close;
                     pc.activepage := PROBAUTONO;
                     tim_auto.tag := 12;
                     if automatique then tim_auto.enabled := true;

                     EXIT;
                  end;
                  CaisseAutonome := true;
                  Que_Sql.Close;
                  StopServiceRepl;
               end;
               Que_Sql.Close;
            end;
            //

            if not Frm_Verification.BackupOk then
            begin
               pc.activepage := PROBBCK;
               tim_auto.tag := 11;
               if automatique then tim_auto.enabled := true;
            end
            else
            begin
               pc.activepage := INST;
               tim_auto.tag := 1;
               if automatique then tim_auto.enabled := true;
            end;
         end;
      finally
         Frm_Verification.release;
      end;
   finally
      Screen.Cursor := CrDefault;
      enabled := true;
   end;
end;

procedure TFrm_Patch.Bout5Click(Sender: TObject);
var
   Frm_Verification: TFrm_Verification;
   delay: Dword;
begin
   Screen.Cursor := crhourglass;
   enabled := false;
   try
      RzLabel5.Caption := 'tentative de connexion'; RzLabel1.Update;
      delay := GetTickCount;
      Application.CreateForm(TFrm_Verification, Frm_Verification);
      try
         if not Frm_Verification.Connexion then
         begin
            while (GetTickCount - delay < 1000) do
               application.processmessages;
            RzLabel5.Caption := 'Impossible de se connecter, réessayez';
         end
         else
         begin
            RzLabel5.caption := '';
            pc.activepage := VERIF1;
            tim_auto.tag := 3;
            if automatique then tim_auto.enabled := true;

            suite1;
         end;
      finally
         Frm_Verification.release;
      end;
   finally
      enabled := true;
      Screen.Cursor := CrDefault;
   end;
end;

procedure TFrm_Patch.Bout1Click(Sender: TObject);
var
   Pourquoi: string;
   Log: TstringList;
   ok: Boolean;
   reg: TRegistry;
   S: string;
   TmLesFic: TmemoryStream;
   TMPass: TmemoryStream;
   I, J: Integer;
   tps, LastTps: DWord;
   LastVer: string;
   LastOk: Boolean;
   refrepli: string;

    Arch : I7zOutArchive;
    IndyStream : TFileStream;
    Hash32 : TIdHashCRC32;

    QuelleLigne : string;
begin
   Screen.Cursor := crhourglass;
   enabled := false;
   try
      bout1.hide;
      application.ProcessMessages;
      Pourquoi := '';
      Log := TstringList.Create;
      OK := true;
      try
         Lab_Etat.Caption := 'ARRETS DES APPLICATION EN COURS'; Update;
         arreterApplie;
         JeStopService;
         Lab_Etat.Caption := 'MAJ en cours'; Lab_Etat.Update;
         application.ProcessMessages;

            // Traitement
         reg := TRegistry.Create;
         try
            reg.access := Key_Read;
            Reg.RootKey := HKEY_LOCAL_MACHINE;
            s := '';
            reg.OpenKey('SOFTWARE\Algol\Ginkoia', False);
            S := reg.ReadString('Base0');
         finally
            reg.free;
         end;
         Labase := S;
         S := ExcludetrailingBackSlash(ExtractFilePath(S));
         while s[length(S)] <> '\' do
            delete(S, length(S), 1);
         Ginkoia := S;
         TmLesFic := TmemoryStream.Create;
         TMPass := TmemoryStream.Create;
         try
            try
               TmLesFic.LoadFromFile(Ginkoia + 'LiveUpdate\Patch.GIN');
               TmLesFic.seek(0, soFromBeginning);
               Pb1.Max := TmLesFic.Size * 2;
               AncVersion := ReadString(TmLesFic);
               AncNumero := ReadString(TmLesFic);
               NvlVersion := ReadString(TmLesFic);
               NvlNumero := ReadString(TmLesFic);
               if FileExists(LeNomLog) and testLog(LeNomLog) then
               begin
                    // retour à un état stable
                  Pourquoi := 'retour état stable suite plantage';
                  Ok := false;
               end
               else
               begin
                  Lab_Etat.Caption := 'Vérification du patch '; Lab_Etat.Update;
                  application.ProcessMessages;

                  Caption := ' MAJ De la version ' + AncVersion + ' à la version ' + NvlVersion;
                  Log.add('- MAJ Du ' + DateTimeToStr(Now));
                  Log.add('- De la version ' + AncVersion + ' à la version ' + NvlVersion);
                  Log.add('- Du Numéro ' + AncNumero + ' Au numéro ' + NvlNumero);
                  Log.add('- Vérification du patch ');
                  Log.SaveToFile(LeNomLog);
                    // Vérification des Check Sum
                  while TmLesFic.Position < TmLesFic.Size do
                  begin
                     TmPass.Size := 0;
                     try
                        Pb1.Position := TmLesFic.Position;
                     except
                     end;
                     TmLesFic.Read(I, Sizeof(i));
                     j := TmPass.CopyFrom(TmLesFic, i);
                     if j <> i then
                     begin
                        Log.add('- Problème sur le patch '); Log.SaveToFile(LeNomLog);
                        Pourquoi := 'Patch faux';
                        ok := false;
                        BREAK;
                     end;
                     I := VerifieLeCrc(TmPass, Ginkoia, FileNotify);
                     if I = CstTypeInconnue then
                        S := '- Problème sur le patch ' + FichierEnCours
                     else if I and CstTypeCopy = CstTypeCopy then
                        S := '- Copie de ' + FichierEnCours
                     else if I and CstTypePareil = CstTypePareil then
                        S := '- Fichier identique ' + FichierEnCours
                     else if I and CstTypeMAJ = CstTypeMAJ then
                        S := '- Maj de ' + FichierEnCours
                     else if I and CstTypeSUP = CstTypeSUP then
                        S := '- Suppression de ' + FichierEnCours;
                     if I and CstErrCRCDest = CstErrCRCDest then
                        S := S + ' CRC pas OK'
                     else if I and $00FF > 0 then
                        S := S + ' Problème sur le patch'
                     else
                        S := S + ' Vérifié';
                     Log.add(S); Log.SaveToFile(LeNomLog);
                     if I and $00FF > 0 then
                     begin
                            // Problème
                        Lab_Etat.Caption := 'Problème impossible de faire la MAJ '; Lab_Etat.Update;
                        application.ProcessMessages;

                        ok := false;
                        Pourquoi := S;
                        BREAK;
                     end;
                  end;
                  if ok then
                  begin
                        // Maj
                     Lab_Etat.Caption := 'Maj en cours '; Lab_Etat.Update;
                     application.ProcessMessages;

                     Log.add('- Lancement de la MAJ ' + DateTimeToStr(Now)); Log.SaveToFile(LeNomLog);
                        // Vider le sauve precedent
                     effacerfichier(Ginkoia + 'Sauve\');
                     TmLesFic.seek(0, soFromBeginning);
                     AncVersion := ReadString(TmLesFic);
                     AncNumero := ReadString(TmLesFic);
                     NvlVersion := ReadString(TmLesFic);
                     NvlNumero := ReadString(TmLesFic);

                     while TmLesFic.Position < TmLesFic.Size do
                     begin
                        TmPass.Size := 0;
                        try
                           Pb1.Position := TmLesFic.Size + TmLesFic.Position;
                        except
                        end;
                        TmLesFic.Read(I, Sizeof(i));
                        j := TmPass.CopyFrom(TmLesFic, i);
                        if j <> i then
                        begin
                           Log.add('- Problème sur le patch '); Log.SaveToFile(LeNomLog);
                           Pourquoi := 'Patch faux';
                           ok := false;
                           BREAK;
                        end;
                        I := Depatch(TmPass, Ginkoia + 'Sauve\', Ginkoia, PatchNotify, FileNotify, CopierFichier, lesEAI);
                        if I = CstTypeInconnue then
                           S := '- Problème sur le patch ' + FichierEnCours
                        else if I and CstTypeCopy = CstTypeCopy then
                           S := '- Copie de ' + FichierEnCours
                        else if I and CstTypePareil = CstTypePareil then
                        begin
                           S := '- ' + FichierEnCours + ' identique ';
                        end
                        else if I and CstTypeMAJ = CstTypeMAJ then
                        begin
                           S := '- Maj ';
                           if i and CstErrSauve = 0 then
                           begin
                              Log.add('**' + FichierEnCours + ';' + CRCSauve); Log.SaveToFile(LeNomLog);
                           end;
                        end
                        else if I and CstTypeSUP = CstTypeSUP then
                        begin
                           S := '- Suppression ';
                           if i and CstErrSauve = 0 then
                           begin
                              Log.add('**' + FichierEnCours + ';' + CRCSauve); Log.SaveToFile(LeNomLog);
                           end
                           else
                              S := S + FichierEnCours + ' '
                        end;
                        if I and CstErrCRCDest = CstErrCRCDest then
                           S := S + ' CRC pas OK'
                        else if I and CstErrMAJDate = CstErrMAJDate then
                           S := S + ' Problème de MAJ de la date'
                        else if I and CstErrSauve = CstErrSauve then
                           S := S + ' Problème de sauvegarde'
                        else if I and CstErrPatch = CstErrPatch then
                           S := S + ' Erreur sur le patch'
                        else if I and CstErrTaille = CstErrTaille then
                           S := S + ' Erreur sur la taille finale '
                        else if I and $00FF > 0 then
                           S := S + ' Problème sur le patch'
                        else
                           S := S + ' Vérifié';
                        Log.add(S); Log.SaveToFile(LeNomLog);
                        if (I and $00FF > 0) and (I and $00FF <> CstErrMAJDate) then
                        begin
                            // Problème
                           ok := false;
                           Pourquoi := S;
                           BREAK;
                        end;
                     end;
                  end;
               end;
            finally
               TmLesFic.Free;
               TMPass.Free;
            end;
         except
            ok := false;
            raise;
         end;

         if Ok then
         begin
              // sauvegarde de la base
            Lab_Fichier.Caption := 'Sauvegarde de la base';
            Lab_Fichier.Update;
            Application.ProcessMessages;
            Log.add('Sauvegarde de la base'); Log.SaveToFile(LeNomLog);

            try
              if FileExists(Ginkoia + 'Sauve\BASES.IB') then
                RenameFile(Ginkoia + 'Sauve\BASES.IB',Ginkoia + 'Sauve\o_BASES.IB');

              If CopyFile(PAnsiChar(LaBase),PAnsiChar(Ginkoia + 'Sauve\BASES.IB'),false) then
                DeleteFile(Ginkoia + 'Sauve\o_BASES.IB')
              else begin
                // La copie n'a pas réussi retour en arrière
                DeleteFile(Ginkoia + 'Sauve\BASES.IB');
                RenameFile(Ginkoia + 'Sauve\o_BASES.IB',Ginkoia + 'Sauve\BASES.IB');
                Ok := False;
                Pourquoi := Format('Echec de la copie (%d)',[GetLastError]);
              end;

//              QuelleLigne := 'Début';
//              CRCSauve := IntToStr(DoNewCalcCRC32(LaBase));
//              QuelleLigne := 'CRCSauve := IntToStr(DoNewCalcCRC32(LaBase))';
//              Arch := CreateOutArchive(CLSID_CFormatZip);
//              QuelleLigne := 'Arch := CreateOutArchive(CLSID_CFormatZip)';
//              Arch.AddFile(LaBase,ExtractFileName(LaBase));
//              QuelleLigne := 'Arch.AddFile(LaBase,ExtractFileName(LaBase))';
//              SetCompressionLevel(Arch,4);
//              QuelleLigne := 'SetCompressionLevel(Arch,4)';
////              Arch.SetProgressCallback(Pb2,ProgressCallback);
////              QuelleLigne := 'Arch.SetProgressCallback(Pb2,ProgressCallback)';
//              Arch.SaveToFile(Ginkoia + 'Sauve\BASES.ZIP');
//              QuelleLigne := 'Arch.SaveToFile(Ginkoia + ''Sauve\BASES.ZIP'')';
            except
              on e: exception do
              begin
                Ok := false;
                Pourquoi := 'Pas de sauve de base';
                Log.add(Pourquoi + ' : ' + E.message); Log.SaveToFile(LeNomLog);
                Log.add('Dernière instruction : ' + QuelleLigne); Log.SaveToFile(LeNomLog);
              end;
            end;
         end;
         JeStartService;
         Attente_IB;
//         Sleep(10000);
         if ok then
         begin
            // scripting
            Lab_Etat.Caption := 'Scripting des base'; Lab_Etat.Update;
            application.ProcessMessages;

            WinExec(Pchar(Ginkoia + 'Script.exe BASE'), 0);
            tps := GetTickCount + 60000;
            Update;
            application.ProcessMessages;

                  // attente du démarage du script ;
            while (not MapGinkoia.Script) and (tps > GetTickCount) do
            begin
               Sleep(100);
            end;
            if MapGinkoia.Script then
            begin
               Update;
               application.ProcessMessages;

               Log.add('*? BASES;' + CRCSauve); Log.SaveToFile(LeNomLog);
               LastTps := GetTickCount;
               LastVer := '';
               Lastok := false;
               try
                  Pb2.Position := 0;
                  Pb2.Max := VersionEnInt(AncNumero, NvlNumero);
               except
               end;
               while (MapGinkoia.Script) do
               begin
                  if (LastVer = MapGinkoia.ScriptEnCours) and
                     (GetTickCount - LastTps > 60000) then
                     Lastok := true;
                  if lastOk and (LastVer <> MapGinkoia.ScriptEnCours) then
                  begin
                     LastOk := false;
                     Log.add('- Script ' + LastVer + ' prend ' + Inttostr(trunc((GetTickCount - LastTps) / 1000)) + ' Secondes');
                     Log.SaveToFile(LeNomLog);
                  end;
                  if LastVer <> MapGinkoia.ScriptEnCours then
                  begin
                     lastVer := MapGinkoia.ScriptEnCours;
                     LastTps := GetTickCount;
                     S := Uppercase(lastVer);
                     if Pos('.GDB ', S) > 0 then
                        delete(S, 1, Pos('.GDB ', S) + 4);
                     if Pos('.IB ', S) > 0 then
                        delete(S, 1, Pos('.IB ', S) + 3);
                     if trim(S) <> 'ERREUR' then
                     begin
                        try
                           Pb2.Position := VersionEnInt(AncNumero, S);
                        except
                        end;
                     end;
                  end;
                  Lab_Fichier.Caption := MapGinkoia.ScriptEnCours; Lab_Fichier.Update;
                  application.ProcessMessages;

                  Sleep(250);
               end;
               if MapGinkoia.ScriptOK then
               begin
                  Log.add('- Script OK'); Log.SaveToFile(LeNomLog);
                  ok := true;
               end
               else
               begin
                  Log.Add('- Problème sur le scripting');
                  Log.add('- ' + MapGinkoia.ScriptEnCours);
                  Log.add('- ' + MapGinkoia.ScriptErreur); Log.SaveToFile(LeNomLog);
                  ok := false;
                  Pourquoi := 'Scripting pas ok';
                  Lapplication := _SCRIPT;
                  EnumWindows(@Enumerate, 0);
                  MapGinkoia.Script := false;
               end
            end
            else
            begin
               Log.add('- Script.exe ne ce lance pas !?!'); Log.SaveToFile(LeNomLog);
               Ok := false;
               Pourquoi := 'Script.exe non lancé';
               Lapplication := _SCRIPT;
               EnumWindows(@Enumerate, 0);
               MapGinkoia.Script := false;
            end;
         end;
      finally
         if (not ok) and testLog(LeNomLog) then
         begin
                // retour à un état stable ;
            Lab_Etat.Caption := 'Retour à un état stable'; Lab_Etat.Update;
            application.ProcessMessages;

            Log.add(Pourquoi); Log.SaveToFile(LeNomLog);
            retourStable(LeNomLog);
            Application.CreateForm(TFrm_Verification, Frm_Verification);
            try
               Frm_Verification.MAJplante(Pourquoi);
            finally
               Frm_Verification.release;
            end;
         end
         else if OK then
         begin
            try
               if FileExists(Ginkoia + 'LiveUpdate\Algol.Alg') then
               begin
                  if Traitement_BATCH(Ginkoia + 'LiveUpdate\Algol.Alg', Log, LeNomLog) then
                  begin
                     Log.add('- Execution de algol.alg réussie'); Log.SaveToFile(LeNomLog);
                  end
                  else
                  begin
                     Log.add('- Execution de algol.alg raté'); Log.SaveToFile(LeNomLog);
                  end
               end;
            except
               Log.add('- Problème grave sur algol.alg'); Log.SaveToFile(LeNomLog);
            end;
            forcedirectories(Ginkoia + 'LiveUpdate\LOG\');
            CopyFile(Pchar(LeNomLog), Pchar(Ginkoia + 'LiveUpdate\LOG\LOG' + AncVersion + '-' + NvlVersion + '.Log'), False);
            deletefile(LeNomLog);

            Lab_Etat.Caption := 'VERIFICATION QUE VOTRE VERSION EST A JOUR'; Update;
            application.ProcessMessages;

            Application.CreateForm(TFrm_Verification, Frm_Verification);
            try
               Frm_Verification.Automatique := false;
               Frm_Verification.Verifielaversion;
               Frm_Verification.MetAJourlaversion;
            finally
               Frm_Verification.release;
            end;
         end;
         Log.free;
      end;
      S := '';
      try
         reg := TRegistry.Create(KEY_READ);
         try
            // relancer le launcher si besoin
            reg.RootKey := HKEY_LOCAL_MACHINE;
            reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', False);
            S := reg.ReadString('Launch_Replication');

            if S <> '' then
               Winexec(PChar(S), 0);

            // Relancer syncweb si besoin
            S := reg.ReadString('GinkoSyncWeb');
            if S <> '' then
              WinExec(PCHAR(S),0);
         finally
            reg.free;
         end;
      except
      end;

      if ok then
      begin
         if CaisseAutonome then
         begin
            Lab_Etat.Caption := 'Mise à jour de la caisse autonome'; Lab_Etat.Update;
            application.ProcessMessages;

            reg := Tregistry.Create;
            try
               reg.Access := KEY_READ;
               Reg.RootKey := HKEY_LOCAL_MACHINE;
               reg.OpenKey('Software\Algol\Ginkoia', False);
               refrepli := reg.ReadString('REPL_REFERENCE');
               CopyFile(Pchar(Ginkoia + 'BaseAuto\GinkoiaRepl.IB'), Pchar(refrepli), False);
               Winexec(Pchar(Ginkoia + 'ParamRepli.exe AUTO'), 0);
               tps := GetTickCount + 60000;
               while not (MapGinkoia.PingStop) and (tps > GetTickCount) do
               begin
                  Sleep(100);
               end;
               while (MapGinkoia.PingStop) do
               begin
                  Sleep(5000);
               end;
            finally
               reg.free;
            end;
            pc.activepage := FINCAISSE;
            tim_auto.tag := 13;
            if automatique then tim_auto.enabled := true;

         end
         else
         begin
            pc.activepage := FINOK;
            tim_auto.tag := 9;
            if automatique then tim_auto.enabled := true;
         end;
      end
      else
      begin
         pc.activepage := FINNOK;
         tim_auto.tag := 10;
         if automatique then tim_auto.enabled := true;

      end;
   finally
      Screen.Cursor := CrDefault;
      enabled := true;
   end;
end;

procedure TFrm_Patch.Bout8Click(Sender: TObject);
begin
   Screen.Cursor := crhourglass;
   enabled := false;
   try
      RzLabel11.visible := true;
      bout8.visible := false;
      Lab_Etat := Label1;
      Lab_Etat.Caption := 'Retour à un état stable'; Lab_Etat.visible := true; Lab_Etat.Update;
      application.ProcessMessages;

      retourStable(LeNomLog);
      Application.CreateForm(TFrm_Verification, Frm_Verification);
      try
         Frm_Verification.MAJplante('retour état stable suite plantage');
      finally
         Frm_Verification.release;
      end;
      RzLabel11.visible := false;
      Lab_Etat.visible := false;
   finally
      enabled := true;
      Screen.Cursor := CrDefault;
   end;
   if not automatique then
      Application.messagebox('Traitement terminé, vous devez quitter l''aplication', ' Terminé', Mb_OK)
   else
      close;
end;

procedure TFrm_Patch.fermerClick(Sender: TObject);
begin
   close;
end;

procedure TFrm_Patch.FormPaint(Sender: TObject);
begin
   if first then
   begin
      first := false;
      if doclose then close;
   end;
end;

function TFrm_Patch.GetWindowsVersion: TWVersion;
var
  sWin32Platform: string;
begin
  sWin32Platform := 'Win32Platform : ' + inttostr(Win32Platform) +
    ' -Maj. version : ' + inttostr(Win32MajorVersion) + ' -Min. version : ' +
    inttostr(Win32Platform);
  case Win32MajorVersion of
    3: Result := wvWOld; // 'Windows NT 3.51';
    4:
      case Win32MinorVersion of
        0:
          case Win32Platform of
            1:
              case Win32CSDVersion[1] of
                'A': Result := wvWOld; // 'Windows 95 SP 1';
                'B': Result := wvWOld; // 'Windows 95 SP 2';
              else
                Result := wvUnknown; //sWin32Platform;
              end;
            2: Result := wvWOld; // 'Windows NT 4.0'
          else
            Result := wvUnknown; // sWin32Platform;
          end;
        10:
          case Win32CSDVersion[1] of
            'A': Result := wvWOld; // 'Windows 98 SP 1';
            'B': Result := wvWOld; // 'Windows 98 SP 2';
          else
            // Result := 'Inconnue';
            Result := wvWOld; // sWin32Platform;
          end;
        90: Result := wvWOld; // 'Windows ME';
      else
        Result := wvUnknown; // sWin32Platform;
      end;
    5:
      case Win32MinorVersion of
        0: Result := wvW2k; //  'Windows 2000';
        1: Result := wvWXP; //  'Windows XP';
        2: Result := wvW2k3; //  'Windows 2003';
      else
        Result := wvUnknown; // sWin32Platform;
      end;
    6:
      case Win32MinorVersion of
        0: Result := wvWVista; // 'Vista';
        1: Result := wvW7; // 'Seven';
      else
        Result := wvUnknown; // sWin32Platform;
      end;
    7: Result := wvNewVersion; // 'Version ulterieure a Seven';
    8: Result := wvNewVersion; // 'Version ulterieure a Seven';
  else
    Result := wvUnknown; // sWin32Platform;
  end;
end;
procedure TFrm_Patch.Tim_AutoTimer(Sender: TObject);
begin
 //
   tim_auto.enabled := false;
   if not (doclose) then
   begin
      case tim_auto.tag of
         1: Bout1.OnClick(nil);
         2: Bout2.OnClick(nil);
         3: Bout3.OnClick(nil);
         4: Bout4.OnClick(nil);
         5: Bout5.OnClick(nil);
         6: Bout6.OnClick(nil);
         7: Bout8.OnClick(nil);
         9: Bout9.OnClick(nil);
         10: Bout10.OnClick(nil);
         11: Bout11.OnClick(nil);
         12: Bout12.OnClick(nil);
         13: Bout13.OnClick(nil);
      end;
   end;
end;

procedure TFrm_Patch.ZipMTotalProgress(Sender: TObject; TotalSize: Int64;
   PerCent: Integer);
begin
   Pb2.max := 100;
   Pb2.position := PerCent;
end;

end.

