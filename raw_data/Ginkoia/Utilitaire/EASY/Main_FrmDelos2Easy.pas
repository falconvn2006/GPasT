/// <summary>
/// Unité de la fenêtre principale pour le déployement de EASY en MAGASIN.
/// </summary>
unit Main_FrmDelos2Easy;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,UWMI,SymmetricDS.Commun,UCommun,IdURI, IdHTTP,System.Json, uDownloadHTTP,
  Vcl.ComCtrls, Vcl.StdCtrls,uInstallDossierMag, Vcl.ExtCtrls, Vcl.Buttons,
  Vcl.Menus, System.Win.Registry, System.IniFiles,
  Winapi.ShellAPI,Winapi.ShlObj,Winapi.SHFolder,ComObj, ActiveX, ULog, XMLDoc, XMLIntf;

const
  CST_OK           = 'Ok';
  CST_DEJAINSTALL  = 'Déjà installé';
  CST_ERREUR       = 'Erreur';
  CST_LAUNCHEREASY = 'LauncherEASY.exe';
  CST_MD5_JAVA     = 'CB814E318F840EAE77CCBFD7FF88C402';
  CST_MD5_SYMDSJAR = 'DE51C2C5C7F326A433CE6478D99DE73F';

type
  /// <summary>
  /// Fenêtre fenêtre principale pour le déployement de EASY en MAGASIN.
  /// </summary>
  TFrm_MainDelos2Easy = class(TForm)
    pbEtape: TProgressBar;
    BInstallation: TButton;
    StatusBar1: TStatusBar;
    BEtape2: TButton;
    BEtape3: TButton;
    BEtape4: TButton;
    BEtape5: TButton;
    lbl_Result1: TLabel;
    lbl_Result2: TLabel;
    lbl_Result3: TLabel;
    lbl_Status: TLabel;
    Lbl_Infos: TLabel;
    lbl_Result4: TLabel;
    lbl_Result5: TLabel;
    mLog: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    BEtape6: TButton;
    lbl_Result6: TLabel;
    BEtape1: TButton;
    tmCheck: TTimer;
    tmRecupMiniSplit: TTimer;
    timAutoClose: TTimer;
    tmInstall: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure BInstallationClick(Sender: TObject);
    procedure BEtape1Click(Sender: TObject);
    procedure BEtape2Click(Sender: TObject);
    procedure BEtape3Click(Sender: TObject);
    procedure BEtape5Click(Sender: TObject);
    procedure InstallCallBack(Sender: TObject);
    procedure PostControlesCallBack(Sender: TObject);
    procedure BEtape6Click(Sender: TObject);
    procedure BEtape4Click(Sender: TObject);
    procedure tmCheckTimer(Sender: TObject);
    procedure tmRecupMiniSplitTimer(Sender: TObject);
    procedure timAutoCloseTimer(Sender: TObject);
    procedure tmInstallTimer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Ouvrir1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Déclarations privées }
    FFileJavaOk      : Boolean;
    FFileSymDSJarOk  : Boolean;

    FInfosPassageDelos2EAsy : TInfosDelosEASY;
    FApplication_Hidden : boolean;

    FCanClose    : Boolean;
    FCanInstall  : boolean;
    FNode        : string;
    FBase0       : string;
    FBaseDelos2Easy : string;
    FGinkoiaPath : String;
    FJava7z      : TFileName;
    FSymDSjar    : TFileName;
    F7zdll       : TFileName;
    // -------------------
    FIBPath      : String;
    FIBService   : Boolean;
    FIBStarted   : Boolean;
    FIBVersion   : string;
    // --------------------
    FDB      : TDossierInfos;
    FEASY    : TSymmetricDS;
    FThread  : TDownloadThread;

    FLancementAuto       : Boolean;
    FStopInstall         : Boolean;
    FLnkFiles            : TStringList;
    FInstallThread       : TInstallDossierMagThread;
    FPostControlesThread : TPostControlesThread;

    FSplitLocalDir : string;
    FSplitFile     : string;
    FFullPathSplitFile  : string;
    FLAST_VERSION       : integer;

    FTentativesRecupMiniSplit : Integer;
    function DoPostLast_Version():Boolean;
    procedure DoDownloadJava();
    procedure DoDownloadSymDSJar();
    function DelosRename():Boolean;
    function DelosGetLastVersion():integer;
    function GetSplittagesDistants:boolean;
    procedure Creation7zdll;
    function ControleDB:boolean;
    procedure Parse_Json_Datas(astr:string);
    procedure DoDownloadSplitFile();
    procedure Un7zSplitFile(zipFullFname:string);
    function PreControls():Boolean;
    function DoMiniSplit():Boolean;
    Procedure StatusCallBack(Const s:String);
    Procedure ProgressInstallCallBack(Const value:integer);
    Procedure LogCallBack(Const value:string);
    function DoEtapeCtrlFiles():Boolean;
    function DoEtape0:Boolean;
    procedure DoEtape1();
    procedure DoEtape2();
    procedure DoEtape3();
    procedure DoEtape4();
    function  ResultEtape4():Boolean;
    procedure DoEtape5();
    procedure DoEtape6();
    procedure DoLog(aValue:string);
    procedure LancementAuto();
    function CleanLancherV7():Boolean;  // Nettoyage de la clé dans le registre..
    function DeleteShortCutLauncherV7():Boolean;
    function GetTargetFromLnk (const LinkFileName:String):String;
    procedure AjouteLnkDir(const Dir: string);
    procedure CheckFiles(Const isInstall:boolean=false);
    procedure Continue_A_Partir_Etape3();
  public
    { Déclarations publiques }
    property CanInstall:boolean Read FCanInstall Write FCanInstall;
    property Node : string      Read FNode       write FNode;
  end;

var
  Frm_MainDelos2Easy: TFrm_MainDelos2Easy;

implementation

{$R *.dfm}

USes ServiceControler, UDataMod, uSevenZip;

function TFrm_MainDelos2Easy.DoPostLast_Version():Boolean;
var IdHTTP : TIdHTTP;
    vUrl   : Widestring;
    vCode  : Integer;
begin
  Result := false;
  IdHTTP        := TIdHTTP.Create(nil);
  try
    try
      FLast_Version:=DelosGetLastVersion();
      vUrl := TIdURI.UrlENcode('http://easy-ftp.ginkoia.net/last_version/create_file.php?dossier='+UpperCase(FDB.Nom)
                                                  +'&sender='+UpperCase(FDB.BAS_SENDER)
                                                  +'&guid='+FDB.BAS_GUID
                                                  +'&node='+lowerCase(Sender_To_Node(FDB.BAS_SENDER))
                                                  +'&last_version='+IntToStr(FLast_Version)
                                                  );
      DoLog(vUrl);
      IdHTTP.Head(vUrl);
      vcode := idhttp.ResponseCode;
      if vCode=200
        then Result := true;
    except on E: EIdHTTPProtocolException do
      begin
        DoLog('Réponse : '+ IntToStr(E.ErrorCode));
        result:=false;
      end;
    end;
  finally
    IdHTTP.Free;
  end;
end;


procedure TFrm_MainDelos2Easy.DoDownloadSplitFile();
var vUrl :string;
begin
  try
   pbEtape.Position:=0;
   FFullPathSplitFile :=  FSplitLocalDir + FSplitFile;
    vUrl :=
{      Format('http://easy-ftp.ginkoia.net/download_split.php?dossier=%s&filename=%s',[
      FDB.Nom,
      FSplitFile
      ]);
}

    Format('http://easy-ftp.ginkoia.net/%s/%s',[
      FDB.Nom,
      FSplitFile]);

     if FileExists(FFullPathSplitFile)
       then DeleteFile(FFullPathSplitFile);
    if Application_Install
      then FThread := TDownloadThread.Create(vURL, FFullPathSplitFile, '', '', '', nil)
      else FThread := TDownloadThread.Create(vURL, FFullPathSplitFile, '', '', '', pbEtape);
    while WaitForSingleObject(FThread.Handle, 100) = WAIT_TIMEOUT do
      Application.ProcessMessages();
//    Bdownload.Enabled := (TDownloadThread(FThread).ReturnValue=mrOK);
    pbEtape.Position:=pbEtape.Max;
  finally
    FreeAndNil(FThread);
  end;
end;


procedure TFrm_MainDelos2Easy.Creation7zdll;
var ResScripts:TResourceStream;
begin
    F7zdll := IncludeTrailingPathDelimiter(VGSE.ExePath)+'7z.dll';
    if not(FileExists(F7zdll))
      then
       begin
          ResScripts := TResourceStream.Create(HInstance, '7zipdll', RT_RCDATA);
          try
            if not(FileExists(F7zdll)) then
              ResScripts.SaveToFile(F7zdll);
            finally
            ResScripts.Free();
          end;
       end;
end;

function TFrm_MainDelos2Easy.DelosRename():Boolean;
var vDelos:TFileName;
    vSavDelos:TFileName;
begin
  result := true;
  vDelos    := IncludeTrailingPathDelimiter(FGinkoiaPath)+'EAI\DelosQPMAgent.DataSources.xml';
  vSavDelos := ChangeFileExt(vDelos,'.replication_easy');
  if FileExists(vDelos) then
    begin
       If not(FileExists(vSavDelos))
         then
            begin
                If not(RenameFile(vDelos,vSavDelos))
                  then result:=false
            end
          else
            begin
                DeleteFile(vSavDelos);
                If not(RenameFile(vDelos,vSavDelos))
                  then result:=false
            end;
    end;
end;


function TFrm_MainDelos2Easy.DelosGetLastVersion():integer;
var XmlFile : TXMLDocument;
    MainNode, SubscriptionNode : IXMLNode;
    i : Integer;
    XMLPath : string;
begin
  result := 0;
  XMLPath  := IncludeTrailingPathDelimiter(FGinkoiaPath)+'EAI\DelosQPMAgent.Subscriptions.xml';
  if FileExists(XMLPath) then
    begin
      XmlFile :=  TXMLDocument.Create(Application);
      try
        XmlFile.LoadFromFile(XMLPath);
        XmlFile.Active := True;
        MainNode := XmlFile.DocumentElement;
        i := MainNode.ChildNodes.Count - 1;
        If (MainNode.ChildNodes[i].ChildNodes['Provider'].text='UIL_')
          then
            begin
                Result := StrTointDef(MainNode.ChildNodes[i].ChildNodes['LAST_VERSION'].text,0);
            end;
      finally
        FreeAndNil(XmlFile);
      end;
    end;
end;



{===========================================}
function TFrm_MainDelos2Easy.GetTargetFromLnk (const LinkFileName:String):String;
{===========================================}
var
  ShellLink: IShellLink;
  PersistFile: IPersistFile;
  Info: array[0..MAX_PATH] of Char;
  FindData: TWin32FindData;
begin
  Result := '';
  CoCreateInstance(CLSID_ShellLink, nil, CLSCTX_INPROC_SERVER, IShellLink, ShellLink);
  if ShellLink.QueryInterface(IPersistFile, PersistFile) = 0 then
  begin
    PersistFile.Load(PChar(LinkFileName), STGM_READ);
    ShellLink.GetPath(@Info, MAX_PATH, FindData, SLGP_UNCPRIORITY);
    Result := UpperCase(Info);
  end;
end;

procedure TFrm_MainDelos2Easy.AjouteLnkDir(const Dir: string);
var SR: TSearchRec;
    vLaunchV7 : TFileName;
    vTargetFile : TFileName;
begin
  vLaunchV7 := upperCase(FGinkoiaPath+'LaunchV7.exe');
  if FindFirst(IncludeTrailingBackslash(Dir) + '*.*', faAnyFile or faDirectory, SR) = 0 then
    try
      repeat
        if (SR.Attr and faDirectory) = 0 then
          begin
            // Seulement si c'est un .lnk
            if ExtractFileExt(SR.Name)='.lnk' then
              begin
                  vTargetFile := GetTargetFromLnk(Dir+SR.Name);
                  if (vTargetFile=vLaunchV7) then
                     FLnkFiles.Add(Dir+SR.Name)
              end;
          end
        else if (SR.Name <> '.') and (SR.Name <> '..') then
          AjouteLnkDir(IncludeTrailingBackslash(IncludeTrailingBackslash(Dir)+SR.Name));  // recursive call!
      until FindNext(Sr) <> 0;
    finally
      FindClose(SR);
    end;
end;

function TFrm_MainDelos2Easy.DeleteShortCutLauncherV7():Boolean;
var vDir:string;
    i:integer;
begin
    // Liste les Raccourcis du Bureau et du lancement Rapide
    // Si ca pointe vers le LaunchV7 ... on supprime le raccourci
    FLnkFiles:=TStringList.Create;
    try

      // Répertoire "Ginkoia"
      vDir := IncludeTrailingPathDelimiter(FGinkoiaPath);
      AjouteLnkDir(vDir);
      //------------------------

      // Répertoire du "Bureau"
      vDir := IncludeTrailingPathDelimiter(GetSpecialFolder(CSIDL_DESKTOP));
      AjouteLnkDir(vDir);

      // Menu Demarrer
      vDir := IncludeTrailingPathDelimiter(GetSpecialFolder(CSIDL_STARTMENU));
      AjouteLnkDir(vDir);

      // Menu Demarrer Commun
      vDir := IncludeTrailingPathDelimiter(GetSpecialFolder(CSIDL_COMMON_STARTMENU));
      AjouteLnkDir(vDir);

      // Barre de Lancement Rapide
      vDir := IncludeTrailingPathDelimiter(GetSpecialFolder(CSIDL_APPDATA)) + 'Microsoft\Internet Explorer\Quick Launch\';
      AjouteLnkDir(vDir);

      // Maintenant on a la liste.....
      result:=true;
      for i := 0 to FLnkFiles.Count-1 do
        begin
           Result := Result and DeleteFile(FLnkFiles.Strings[i]);
        end;
    finally
      FLnkFiles.DisposeOf;
    end;
end;

// Modifie la valeur de la cle de lancement auto
// ca ne sera plus le launchV7 !
function TFrm_MainDelos2Easy.CleanLancherV7():Boolean;
var reg  : TRegistry;
    vLancher : string;
begin
   // On essaye d'ecrire la valeur
   try
      reg := TRegistry.Create(KEY_WRITE);
      try
        reg.RootKey := HKEY_LOCAL_MACHINE;
        reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', False);
        reg.WriteString('Launch_Replication', FGinkoiaPath + CST_LAUNCHEREASY)
      finally
        reg.CloseKey;
        reg.free;
      end;
    except on E: Exception do
      begin
        // result:=false;
      end;
   end;

   // On regarde si c'est bon
   result:=false;
   try
      reg := TRegistry.Create(KEY_READ);
      try
        reg.RootKey := HKEY_LOCAL_MACHINE;
        reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', False);
        vLancher := reg.ReadString('Launch_Replication');
        If UpperCase(FGinkoiaPath+CST_LAUNCHEREASY)<>UpperCase(vLancher)
          then result := false
          else result := true;
      finally
        reg.CloseKey;
        reg.free;
      end;
    except on E: Exception do
      begin
        result:=false;
      end;
   end;
end;

function TFrm_MainDelos2Easy.PreControls():Boolean;
begin
    if FileExists(F7zdll) and FileExists(FJava7z) and FileExists(FSymDSjar)
       and FileExists(FBase0)
       and FIBService and FIBStarted  and (FIBVersion='WI-V10.0.5.595')
       and (Length(VGSYMDS)=0) and PoseUDF(FIBPATH) and KillProcess('LaunchV7.exe')
       and DelosRename() and CleanLancherV7()
     then
        begin
          result := true;
        end
    else
        begin
           if Not(FileExists(F7zdll))
             then DoLog('Le fichier '+F7zdll+' est absent : ERREUR');
           if Not(FileExists(FBase0))
             then DoLog('Le fichier '+FBase0+' est absent : ERREUR');
           if Not(FileExists(FJava7z))
             then DoLog('Le fichier '+FJava7z+' est absent : ERREUR');
           if Not(FileExists(FSymDSjar))
             then DoLog('Le fichier '+FSymDSjar+' est absent : ERREUR');
           if Not(FIBService)
             then DoLog('Le Service FIBService est absent : ERREUR');
           if Not(FIBStarted)
             then DoLog('Le Service FIBService est arrêté : ERREUR');
           if Not(FIBVersion='WI-V10.0.5.595')
             then DoLog('Interbase n''est pas en dernière version : ERREUR');
           if Not((Length(VGSYMDS)=0))
             then DoLog('EASY est déjà installé : Attention');
           if Not(PoseUDF(FIBPATH))
             then DoLog('L''UDF de SymmetricDS est absent : ERREUR');
           if Not(KillProcess('LaunchV7.exe'))
             then DoLog('Le LaunchV7 tourne : ERREUR');
           // Renommage du fichier .xml pour que le DELOS ne puisse plus du tout fonctionner
           If Not(DelosRename())
            then DoLog('Impossible de renommer le fichier .xml (DELOS) : ERREUR');
           if not(CleanLancherV7())
             then DoLog('Le LauncherEasy n''a pas pu être ajouter en lancement automatique : ERREUR');
           Result := false;
        end;
end;

procedure TFrm_MainDelos2Easy.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    Log.Close;
end;

procedure TFrm_MainDelos2Easy.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  // Self.Hide; ???
  CanClose := FCanClose;
end;

procedure TFrm_MainDelos2Easy.FormCreate(Sender: TObject);
var i:Integer;
    vTempStr : string;
begin
    FCanClose := true;

    if Application_Download then
      begin
        DoLog('Mode Download...');
      end;
   if Application_Install then
      begin
         DoLog('Mode Install...');
      end;
    Caption := Caption + ' - ' + FileVersion(ParamStr(0));
    FTentativesRecupMiniSplit := 0;

    BInstallation.Enabled:=false;
    FLancementAuto:=false;

    FCanInstall := false;
    Creation7zdll;
    FBase0          := Readbase0;
    FBaseDelos2Easy := IncludeTrailingPathDelimiter(ExtractFilePath(FBase0)) + 'DELOS2EASY.IB';

    FGinkoiaPath := ExtractFilePath(ExcludeTrailingPathDelimiter(ExtractFilePath(FBase0)));
    // Récupération du Paramètre 80,2 pour savoir quand on passe en EASY.......
    // if FileExists(FGinkoiaPath)
    //   then
    if FileExists(FBaseDelos2Easy) and FileExists(FBase0)
      then
        begin
            DoLog('Les 2 fichiers existes');
        end;
    if not(FileExists(FBaseDelos2Easy)) and not(FileExists(FBase0))
      then
        begin
            DoLog('Aucun fichier de Base');
        end;

    if FileExists(FBaseDelos2Easy) and not(FileExists(FBase0)) and (Application_Install) then
      begin
          // On Restart la base
          // DataMod.RestartDataBase(FBaseDelos2Easy);
          //--------------------------------------
          FInfosPassageDelos2EAsy := DataMod.Get_Infos_Passage_DELOS2EASY(FBaseDelos2Easy);
          {
          if FInfosPassageDelos2EAsy.BAS_ID<>0
            then
              begin
                  DoLog('Info de passage de Delos vers EASY');
                  DoLog(' * Sender : ' + FInfosPassageDelos2EAsy.SENDER);
                  DoLog(' * GUID : ' + FInfosPassageDelos2EAsy.GUID);
                  DoLog(' * Dossier : ' + FInfosPassageDelos2EAsy.Dossier);
                  DoLog(' * Date programmée :' + FormatDateTime('dd/mm/yyyy hh:nn:ss',FInfosPassageDelos2EAsy.DatePassage));
                  DoLog(' * Etat : ' + IntToStr(FInfosPassageDelos2EAsy.Etat));
              end;
          }
      end;

    if FileExists(FBase0) and not(FileExists(FBaseDelos2Easy)) and not(Application_Install) then
      begin
          //
          FInfosPassageDelos2EAsy := DataMod.Get_Infos_Passage_DELOS2EASY(FBase0);
          {
          if FInfosPassageDelos2EAsy.BAS_ID<>0
            then
              begin
                  DoLog('Info de passage de Delos vers EASY');
                  DoLog(' * Sender : ' + FInfosPassageDelos2EAsy.SENDER);
                  DoLog(' * GUID : ' + FInfosPassageDelos2EAsy.GUID);
                  DoLog(' * Dossier : ' + FInfosPassageDelos2EAsy.Dossier);
                  DoLog(' * Date programmée :' + FormatDateTime('dd/mm/yyyy hh:nn:ss',FInfosPassageDelos2EAsy.DatePassage));
                  DoLog(' * Etat : ' + IntToStr(FInfosPassageDelos2EAsy.Etat));
              end;
          }
      end;

    Log.App   := 'Delos2Easy';
    Log.Inst  := '' ;
    Log.FileLogFormat := [elDate, elMdl, elKey, elLevel, elNb, elValue] ;
    Log.SendOnClose := true ;
    Log.Open ;
    Log.SendLogLevel := logTrace;
    Log.Mag   := IntToStr(FInfosPassageDelos2EAsy.BAS_MAGID);
    Log.Ref   := FInfosPassageDelos2EAsy.GUID;

    // Install plus petite : besoin du fichier "JAVA.7z" + fichier "symmetric-pro-3.7.36-setup.jar"
    FJava7z := ExtractFilePath(ExcludeTrailingPathDelimiter(ParamStr(0)))+'JAVA.7Z';
    FSymDSjar := ExtractFilePath(ExcludeTrailingPathDelimiter(ParamStr(0)))+'symmetric-pro-3.7.36-setup.jar';

    FIBService   := ServiceExist('','IBS_gds_db') and ServiceExist('','IBG_gds_db');
    FIBStarted   := (ServiceGetStatus('','IBS_gds_db')=4) and (ServiceGetStatus('','IBG_gds_db')=4);
    vTempStr:=InfoService('IBS_gds_db');
    i:=Pos('\bin\ibserver.exe',vTempStr,1);
    if i>0 then
      begin
        vTempStr:=Copy(vTempStr,0,i+16);
      end;
    FIBVersion := GetFileVersion(vTempStr);
    FIBPath    := ExtractFilePath(ExcludeTrailingPathDelimiter(ExtractFilePath(vTempStr)));
    // Savoir s'il y a déja du EASY ou SymmetricDS
    WMI_GetServicesSYMDS;

    FSplitLocalDir := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))+ 'split\';

    ForceDirectories(FSplitLocalDir);

    BInstallation.Enabled:=true;
    BEtape1.Enabled := true;

    if Application_Download then
      begin
        FCanClose := false;
        DoLog('Lancement dans 2 secondes...');
        tmCheck.Enabled := true;
        BInstallation.Enabled := false;
        BEtape1.Enabled := False;
        Log.Log('InstallEasyMag', Log.Ref, Log.Mag, 'Download', 'Lancement', logNotice, True, 0, ltServer);
        Application.ProcessMessages;
      end;

   FLAST_VERSION := DelosGetLastVersion;

   if Application_Install
     then
       begin
          // Log.Log('InstallEasyMag', Log.Ref, Log.Mag, 'Install', 'test', logNotice, True, 0, ltServer);
       end;

    if FInfosPassageDelos2EAsy.BAS_ID<>0
        then
          begin
            DoLog('Info de passage de Delos vers EASY');
            DoLog(' * Sender : ' + FInfosPassageDelos2EAsy.SENDER);
            DoLog(' * GUID : ' + FInfosPassageDelos2EAsy.GUID);
            DoLog(' * Dossier : ' + FInfosPassageDelos2EAsy.Dossier);
            DoLog(' * Date programmée :' + FormatDateTime('dd/mm/yyyy hh:nn:ss',FInfosPassageDelos2EAsy.DatePassage));
            DoLog(' * Etat : ' + IntToStr(FInfosPassageDelos2EAsy.Etat));
            DoLog(' * LAST_VERSION : ' + IntToStr(DelosGetLastVersion));
          end;


   if Application_Install
     then
       begin
          FCanClose := false;
          Log.Log('InstallEasyMag', Log.Ref, Log.Mag, 'Install', 'Lancement...', logNotice, True, 0, ltServer);
          DoLog('Lancement Install dans 2 secondes...');
          tmInstall.Enabled:=true;
          // LancementAuto();
       end;

    FApplication_Hidden := Application_Hidden;

end;

procedure TFrm_MainDelos2Easy.CheckFiles(Const isInstall:boolean=false);
var  vDoDLJava : boolean;
     vDoDLSymDS : boolean;
begin
     // JAVA
     FFileJavaOk  := false;
     vDoDLJava := true;
     if FileExists(FJava7z) then
        begin
          Log.Log('InstallEasyMag', Log.Ref, Log.Mag, 'Download', 'Java MD5 Contrôle', logNotice, True, 0, ltServer);
          DoLog(Format('Contrôle du fichier %s ...',[ExtractFileName(FJava7z)]));
          if MD5File(FJava7z)=CST_MD5_JAVA
            then
                begin
                   FFileJavaOk := true;
                   Log.Log('InstallEasyMag', Log.Ref, Log.Mag, 'Download', 'Java MD5 OK', logInfo, True, 0, ltServer);
                   DoLog(Format('Fichier %s OK',[ExtractFileName(FJava7z)]));
                   vDoDLJAVa :=false;
                end
            else DoLog(Format('Fichier %s corrompu',[ExtractFileName(FJava7z)]));
        end
     else DoLog(Format('Fichier %s absent...',[ExtractFileName(FJava7z)]));

     if vDODLJAVA
       then DoDownloadJava();

     // SymDS
     FFileSymDSJarOk := False;
     vDoDLSymDS := true;
     if FileExists(FSymDSjar) then
        begin
           DoLog(Format('Contrôle du fichier %s',[ExtractFileName(FSymDSJAR)]));
           Log.Log('InstallEasyMag', Log.Ref, Log.Mag, 'Download', 'SymDS MD5 Contrôle', logNotice, True, 0, ltServer);
           if MD5File(FSymDSjar)=CST_MD5_SYMDSJAR
             then
                begin
                   FFileSymDSJarOk := true;
                   Log.Log('InstallEasyMag', Log.Ref, Log.Mag, 'Download', 'SymDS MD5 OK', logInfo, True, 0, ltServer);
                   DoLog(Format('Fichier %s OK',[ExtractFileName(FSymDSJAR)]));
                   vDoDLSymDS :=false
                end
              else DoLog(Format('Fichier %s corrompu',[ExtractFileName(FSymDSJar)]));
        end
     else DoLog(Format('Fichier %s absent...',[ExtractFileName(FSymDSJar)]));

    if vDoDLSymDS
      then DoDownloadSymDSJar();

    if (FFileJavaOk and FFileSymDSJarOk) then
      begin
         // ==> envoyer un log pour dire que ce noeud est pret a recevoir EASY
         Log.Log('InstallEasyMag', Log.Ref, Log.Mag, 'Download', 'Fichiers MD5 OK', logInfo, True, 0, ltServer);

         FCanClose := true;
         Self.Show;
         Application.BringToFront;

         if not(isInstall)
          then Close; // Immédiatement

         {
         if Application_Hidden
          then
             begin
               // On Lance le TimerAutoClose qui ferme dans 10 secondes...
               FCanClose := true;
               Close; // Immédiatement
               // timAutoClose.Enabled:=true;
             end
          else
           begin
             DoLog('Vous pouvez commencer l''installation...');
             BInstallation.Enabled := true;
             BEtape1.Enabled :=true;
           end;
          }
      end;
    // On peut fermer dans tous les cas
    FCanClose := true;
end;

procedure TFrm_MainDelos2Easy.DoDownloadSymDSJar();
var vUrl :string;
begin
  try
   DoLog('Téléchargement de symmetric-pro-3.7.36-setup.jar...');
   Log.Log('InstallEasyMag', Log.Ref, Log.Mag, 'Download', 'SymDS Téléchargement', logNotice, True, 0, ltServer);
   pbEtape.Visible := true;
   pbEtape.Position:=0;
   vUrl :='http://lame2.no-ip.com/algol/Installation_EASY/LAME/symmetric-pro-3.7.36-setup.jar';
   if FileExists(FSymDSJar)
     then DeleteFile(FSymDSJar);
   if FApplication_Hidden
    then FThread := TDownloadThread.Create(vURL, FSymDSJar, '', '', '', nil)
    else FThread := TDownloadThread.Create(vURL, FSymDSJar, '', '', '', pbEtape);

   while WaitForSingleObject(FThread.Handle, 100) = WAIT_TIMEOUT do
      Application.ProcessMessages();

   pbEtape.Position:=pbEtape.Max;
   Application.ProcessMessages();
   DoLog('Téléchargement symmetric-pro-3.7.36-setup.jar terminé');
   Log.Log('InstallEasyMag', Log.Ref, Log.Mag, 'Download', 'SymDS Téléchargement Terminé', logInfo, True, 0, ltServer);
   DoLog(Format('Contrôle du fichier %s ...',[ExtractFileName(FSymDSJAR)]));
   Log.Log('InstallEasyMag', Log.Ref, Log.Mag, 'Download', 'SymDS MD5 Contrôle', logNotice, True, 0, ltServer);
    if MD5File(FSymDSJAR)=CST_MD5_SYMDSJAR
      then
          begin
             FFileSymDSJarOk  := true;
             Log.Log('InstallEasyMag', Log.Ref, Log.Mag, 'Download', 'SymDS MD5 OK', logInfo, True, 0, ltServer);
             DoLog(Format('Fichier %s OK',[ExtractFileName(FSymDSJAR)]))
          end
      else
        begin
            Log.Log('InstallEasyMag', Log.Ref, Log.Mag, 'Download', 'SymDS MD5 Corrompu', logError, True, 0, ltServer);
            DoLog(Format('Fichier %s corrompu : ERREUR',[ExtractFileName(FSymDSJAR)]));
        end;
  finally
    FreeAndNil(FThread);
  end;
end;



procedure TFrm_MainDelos2Easy.DoDownloadJava();
var vUrl :string;
begin
  try
   DoLog('Téléchargement de JAVA.7z....');
   Log.Log('InstallEasyMag', Log.Ref, Log.Mag, 'Download', 'Java Téléchargement', logNotice, True, 0, ltServer);
   pbEtape.Visible := true;
   pbEtape.Position:=0;
   vUrl :='http://lame2.no-ip.com/algol/Installation_EASY/LAME/Java.7z';
   if FileExists(FJAVA7z)
     then DeleteFile(FJAVA7z);

   if FApplication_Hidden
     then FThread := TDownloadThread.Create(vURL, FJAVA7z, '', '', '', nil)
     else FThread := TDownloadThread.Create(vURL, FJAVA7z, '', '', '', pbEtape);

   while WaitForSingleObject(FThread.Handle, 100) = WAIT_TIMEOUT do
      Application.ProcessMessages();

    pbEtape.Position:=pbEtape.Max;
    Application.ProcessMessages();
    DoLog('Téléchargement terminé');
    Log.Log('InstallEasyMag', Log.Ref, Log.Mag, 'Download', 'Java Téléchargement Terminé', logInfo, True, 0, ltServer);
    DoLog(Format('Contrôle du fichier %s ...',[ExtractFileName(FJava7z)]));
    Log.Log('InstallEasyMag', Log.Ref, Log.Mag, 'Download', 'Java MD5 Contrôle', logNotice, True, 0, ltServer);
    if MD5File(FJava7z)=CST_MD5_JAVA
      then
          begin
             FFileJavaOk := true;
             Log.Log('InstallEasyMag', Log.Ref, Log.Mag, 'Download', 'Java MD5 OK', logInfo, True, 0, ltServer);
             DoLog(Format('Fichier %s OK',[ExtractFileName(FJava7z)]))
          end
      else
         begin
            Log.Log('InstallEasyMag', Log.Ref, Log.Mag, 'Download', 'Java MD5 Corrompu', logError, True, 0, ltServer);
            DoLog(Format('Fichier %s corrompu : ERREUR',[ExtractFileName(FJava7z)]));
         end;
  finally
    FreeAndNil(FThread);
  end;
end;


procedure TFrm_MainDelos2Easy.BEtape2Click(Sender: TObject);
begin
    DoEtape2();
end;

procedure TFrm_MainDelos2Easy.DoEtape2();
begin
    tmRecupMiniSplit.Enabled := false;
    BEtape2.Enabled:=false;
    If GetSplittagesDistants
      then
        begin
          Log.Log('InstallEasyMag', Log.Ref, Log.Mag, 'Install', 'Recup Splittage OK', logNotice, True, 0, ltServer);
          lbl_Result2.Font.Color:=clGreen;
          lbl_Result2.Caption:=CST_OK;
          lbl_Result2.Visible:=true;
          BEtape3.Enabled := true;
        end
    else
        begin
          // avec le paramètre /install on boucle
          if Application_Install then
             begin
                DoLog('Pas de splittage distant disponible pour le moment.');
                DoLog('Nouvelle tentative dans 1 minute.');
                tmRecupMiniSplit.Enabled:=true;
                Log.Log('InstallEasyMag', Log.Ref, Log.Mag, 'Install', 'Recup Splittage en attente', logNotice, True, 0, ltServer);
                // Au bout de 12 heures il arrête ?
             end
          else DoLog('Pas de splittage distant disponible : ERREUR');
          Inc(FTentativesRecupMiniSplit);
          BEtape2.Enabled:=true;
          // MessageDlg('Pas de splittage distant disponible',  mtError, [mbOK],0);
        end;

   // Si Finalement il réussi à recup le minisplit
   // ca veut dire qu'on est passé plusieurs fois dans cette boucle....
   // il faut continuer tout droit
   if (FTentativesRecupMiniSplit>0) and (Application_Install) then
      begin
        Continue_A_Partir_Etape3();
      end;
end;

procedure TFrm_MainDelos2Easy.BEtape3Click(Sender: TObject);
begin
  DoEtape3;
end;

procedure TFrm_MainDelos2Easy.DoEtape3();
begin
   BEtape3.Enabled:=false;
   If (DoMiniSplit())
    then
      begin
          Log.Log('InstallEasyMag', Log.Ref, Log.Mag, 'Install', 'Do Splittage OK', logNotice, True, 0, ltServer);
          lbl_Result3.Font.Color:=clGreen;
          lbl_Result3.Caption:=CST_OK;
          lbl_Result3.Visible:=true;
          BEtape4.Enabled    :=true;
      end
    else
      begin
          Log.Log('InstallEasyMag', Log.Ref, Log.Mag, 'Install', 'Do Splittage KO', logError, True, 0, ltServer);
          lbl_Result3.Font.Color:=clRed;
          lbl_Result3.Caption:=CST_ERREUR;
          lbl_Result3.Visible:=true;
      end;
end;

procedure TFrm_MainDelos2Easy.BEtape4Click(Sender: TObject);
begin
  DoEtape4();
end;

procedure TFrm_MainDelos2Easy.DoEtape4();
begin
   BEtape4.Enabled := False;
   If ResultEtape4()
     then
       begin
         lbl_Result4.Font.Color:=clGreen;
         lbl_Result4.Caption:=CST_OK;
         lbl_Result4.Visible:=true;
         BEtape5.Enabled    :=true;
       end
    else
      begin
         lbl_Result4.Font.Color:=clRed;
         lbl_Result4.Caption:=CST_ERREUR;
         lbl_Result4.Visible:=true;
      end;
end;

function TFrm_MainDelos2Easy.DoMiniSplit():boolean;
var searchResult : TSearchRec;
    i:Integer;
    vInfFile : TFileName;
    vIniFile : TIniFile;
    vDLC : TDateTime;
begin
  try
    // Controle de la validité du MiniSplit
    // DLC, BON Noeud, BON SENDER, NOMPOURNOUS....
    i:=0;
    if findfirst(IncludeTrailingPathDelimiter(FSplitLocalDir)+'*.inf', faAnyFile, searchResult) = 0 then
      begin
        repeat
           vInfFile := IncludeTrailingPathDelimiter(FSplitLocalDir) + searchResult.Name;
           Inc(i);
        until FindNext(searchResult) <> 0;
      end;
    if (i=0) then
      begin
        Log.Log('InstallEasyMag', Log.Ref, Log.Mag, 'Install', 'Pas de fichier .inf' , logError, True, 0, ltServer);
        DoLog('Pas de fichier .inf dans le minisplit : ERREUR');
        result:=false;
        exit;
      end;
    if (i<>1) then
      begin
        Log.Log('InstallEasyMag', Log.Ref, Log.Mag, 'Install', 'Plusieurs fichiers .inf' , logError, True, 0, ltServer);
        DoLog('plusieurs fichiers .inf dans le minisplit : ERREUR');
        result:=false;
        exit;
      end;
    If FileExists(vInfFile)
      then
        begin
          vIniFile:=TIniFile.Create(vInfFile);
          try
          vDLC := vIniFile.ReadDateTime('SPLIT','DLC',0);
          if (vDLC<Now()) then
            begin
                Log.Log('InstallEasyMag', Log.Ref, Log.Mag, 'Install', 'Split trop vieux' , logError, True, 0, ltServer);
                DoLog('Ce split a dépassé sa DLC : ERREUR');
                result:=false;
                exit;
            end;
          finally
            vIniFile.DisposeOf;
          end;
        end;
    // --------------------
    If FileExists(IncludeTrailingPathDelimiter(FSplitLocalDir)+'K.csv')
      then result := DataMod.Joue_MiniSplit(IncludeTrailingPathDelimiter(FSplitLocalDir)+'K.csv',FBase0)
      else Result :=false;
    If FileExists(IncludeTrailingPathDelimiter(FSplitLocalDir)+'GENPARAM.csv')
      then result := result and DataMod.Joue_MiniSplit(IncludeTrailingPathDelimiter(FSplitLocalDir)+'GENPARAM.csv',FBase0)
      else Result := false;
    // Après un MiniSplit il faudra controler 'URL'...
    ControleDB;
    Lbl_Infos.Caption := 'Base0 : '      + FBase0  + #13+#10+
                         'Dossier : '    + FDB.Nom + #13+#10+
                         'Générateur : ' + IntToStr(FDB.BAS_IDENT)   + #13+#10+
                         'LAST_VERSION : ' + IntToStr(FLAST_VERSION) + #13+#10+
                         'Sender : '     + FDB.BAS_SENDER + #13+#10+
                         'GUID   : '     + FDB.BAS_GUID   + #13+#10+
                         'Plage  : '     + FDB.BAS_PLAGE  + #13+#10+
                         'GeneralID  : ' + FDB.GENERAL_ID + #13+#10+
                         'ExternalID : ' + FDB.ExternalID + #13+#10+
                         'PropertiesFile : ' + ExtractFileName(FDB.PropertiesFile) + #13+#10+
                         'Url : '        + FDB.RegistrationUrl;

  except
    result:=false;
  end;
end;


procedure TFrm_MainDelos2Easy.BInstallationClick(Sender: TObject);
begin
   LancementAuto;
end;

procedure TFrm_MainDelos2Easy.DoLog(aValue:string);
begin
     if not(FApplication_Hidden)
       then mLog.Lines.Add(FormatDateTime('[yyyy-mm-dd hh:nn:ss.zzz] : ',Now())+aValue);
end;

function TFrm_MainDelos2Easy.ResultEtape4():Boolean;
begin
    DataMod.Ouverture_IBFile(FDB);
    result:=true;

    if FDB.RegistrationUrl=''
      then
        begin
          Log.Log('InstallEasyMag', Log.Ref, Log.Mag, 'Install', 'Pas d''URL de LAME', logError, True, 0, ltServer);
          DoLog('Pas d''URL de LAME : ERREUR');
          result:=false;
        end;

    if FDB.BAS_IDENT=0
      then
        begin
          Log.Log('InstallEasyMag', Log.Ref, Log.Mag, 'Install', 'C''est une base 0', logError, True, 0, ltServer);
          DoLog('Impossible d''Installer c''est une base 0 : ERREUR');
          result:=false;
        end;

    if (FDB.SymDir='')
      then
        begin
          Log.Log('InstallEasyMag', Log.Ref, Log.Mag, 'Install', 'Impossible d''installer SymDir', logError, True, 0, ltServer);
          DoLog('Impossible d''Installer SymDir : ERREUR');
          result:=false;
        end;


    FEASY.Nom         := 'EASY';
    FEASY.Repertoire  := FGinkoiaPath + 'EASY';
    FEASY.http        := 32415;
    FEASY.https       := 32417;
    FEASY.jmx         := 32416;
    FEASY.agent       := 32418;
    FEASY.server_java := False; //
    FEASY.memory      := 1024;
    FEASY.IsLame      := false;

    FDB.ServiceName  := FEASY.Nom;
    FDB.DatabaseFile := FBase0;
    FDB.httpport     := FEASY.http;

end;

Procedure TFrm_MainDelos2Easy.StatusCallBack(Const s:String);
begin
  Lbl_Status.Caption  := s;
  DoLog(s);
end;

procedure TFrm_MainDelos2Easy.timAutoCloseTimer(Sender: TObject);
begin
  // Pour passer qu'une seule fois
  FCanClose := true;
  timAutoClose.Enabled:=false;
  Close;
end;

procedure TFrm_MainDelos2Easy.tmCheckTimer(Sender: TObject);
begin
    tmCheck.Enabled:=false;
    CheckFiles();
end;

procedure TFrm_MainDelos2Easy.tmInstallTimer(Sender: TObject);
begin
   tmInstall.Enabled:=false;
   LancementAuto;
end;

procedure TFrm_MainDelos2Easy.tmRecupMiniSplitTimer(Sender: TObject);
begin
   DoEtape2();
end;

Procedure TFrm_MainDelos2Easy.ProgressInstallCallBack(Const value:integer);
begin
    pbEtape.Visible  := true;
    pbEtape.Position := value;
end;

Procedure TFrm_MainDelos2Easy.LogCallBack(Const value:string);
begin
  DoLog(Value);
end;


procedure TFrm_MainDelos2Easy.Ouvrir1Click(Sender: TObject);
begin
  Self.Show;
  Application.BringToFront;
end;

procedure TFrm_MainDelos2Easy.PostControlesCallBack(Sender: TObject);
var vTmpThread:TPostControlesThread;
    vStart,vTc : Cardinal ;
    vIniFile : TIniFile;
    vPost_LastVersion : boolean;
begin
  pbEtape.Visible := false;
  StatusBar1.Panels[1].Text := 'Post-Contrôles Terminés';
  lbl_Status.Caption:='';
  lbl_Status.Visible:=False;
  if Assigned(FPostControlesThread) then
  begin
    vTmpThread := FPostControlesThread;
    FPostControlesThread := nil;
    if vTmpThread.ReturnValue<>0 then
      begin
        lbl_Result6.Font.Color:=clRed;
        lbl_Result6.Caption:=CST_ERREUR;
        DoLog(vTmpThread.GetErrorLibelle(vTmpThread.ReturnValue));
        Log.Log('InstallEasyMag', Log.Ref, Log.Mag, 'Install', 'Post-Contrôles KO' + vTmpThread.GetErrorLibelle(vTmpThread.ReturnValue) , logError, True, 0, ltServer);
      end
    else
      begin
        Log.Log('InstallEasyMag', Log.Ref, Log.Mag, 'Install', 'Post-Contrôles OK', logNotice, True, 0, ltServer);
        lbl_Result6.Font.Color:=clGreen;
        lbl_Result6.Caption:=CST_OK;

        // si tout est ok, on créer le fichier pour le mouvement automatique
        vPost_LastVersion := DoPostLast_Version();
        if Not(vPost_LastVersion) then
        begin
          DoLog(' * Creation fichier Last Version : [ECHEC]');
        end
        else
        begin
          DoLog(' * Creation fichier Last Version : [OK]');
        end;

      end;
    vTmpThread := nil;

    lbl_Result6.Visible := true;
    BEtape6.Enabled     := true;

    DeleteShortCutLauncherV7(); // Non Bloquant

    // Ecriture dans LaunchV7
    // [EASY]
    // mode=EASY
    vIniFile := TIniFile.Create(FGinkoiaPath+'LAUNCHV7.ini');
    try
      vIniFile.WriteString('EASY','mode','EASY');
    finally
      vIniFile.DisposeOf;
    end;

    // Restart de la base si on etait en /install
    if Application_Install
      then DataMod.RestartDataBase(FBase0);

    // Lancement du LauncherEASY

    if FileExists(FGinkoiaPath + CST_LAUNCHEREASY) then
      begin
         DoLog('Lancement du Launcher EASY...');
         Log.Log('InstallEasyMag', Log.Ref, Log.Mag, 'Install', 'Lancement Launcher EASY...', logNotice, True, 0, ltServer);
         ShellExecute(0, 'open', PWideChar(FGinkoiaPath + CST_LAUNCHEREASY), nil, nil, SW_SHOW);
         vStart := getTickCount;
         vTc    := 0;
         while not(WMI_ProcessIsRunning(FGinkoiaPath+CST_LAUNCHEREASY)) and (vTc<3000)
           do
            begin
               // getTickCount;
               vtc := getTickCount - vStart ;
               Application.ProcessMessages;
            end;
         If WMI_ProcessIsRunning(FGinkoiaPath+CST_LAUNCHEREASY)
           then
              begin
                  DoLog('Launcher EASY en cours d''exécution : OK');
                  Log.Log('InstallEasyMag', Log.Ref, Log.Mag, 'Install', 'Launcher EASY OK', logInfo, True, 0, ltServer);
              end
           else DoLog('Launcher EASY ne tourne pas : ERREUR');

         // Fermeture dans 10 s
         if Application_Install
           then timAutoClose.Enabled:=true;

      end
    else
      begin
         DoLog('Launcher EASY absent : ERREUR');
         Log.Log('InstallEasyMag', Log.Ref, Log.Mag, 'Install', 'Launcher EASY Absent' , logError, True, 0, ltServer);
      end;
    // Test s'il tourne....
    // vTmpThread.GetErrorLib(vTmpThread.ReturnValue);
  end;
  // Ddans tous les cas on peut fermer
  FCanClose := true;
end;

procedure TFrm_MainDelos2Easy.InstallCallBack(Sender: TObject);
var vTmpThread:TInstallDossierMagThread;
begin
  // Retour du Thread
  pbEtape.Visible := false;
  StatusBar1.Panels[1].Text := 'Installation Terminée';
  lbl_Status.Caption:='';
  lbl_Status.Visible:=False;
  BEtape6.Enabled := true;
  if Assigned(FInstallTHread) then
    begin
      vTmpThread := FInstallThread;
      FInstallThread := nil;
      if vTmpThread.ReturnValue<>0 then
        begin
          lbl_Result5.Font.Color:=clRed;
          lbl_Result5.Caption:=CST_ERREUR;
          DoLog(vTmpThread.GetErrorLibelle(vTmpThread.ReturnValue));
          Log.Log('InstallEasyMag', Log.Ref, Log.Mag, 'Install', 'Install SymDS KO ' + vTmpThread.GetErrorLibelle(vTmpThread.ReturnValue) , logError, True, 0, ltServer);
        end
      else
        begin
          Log.Log('InstallEasyMag', Log.Ref, Log.Mag, 'Install', 'Install SymDS OK ' , logNotice, True, 0, ltServer);
          lbl_Result5.Font.Color:=clGreen;
          lbl_Result5.Caption:=CST_OK
        end;
      lbl_Result5.Visible:=true;
    end;

  Application.ProcessMessages;

  if FLancementAuto
    then DoEtape6();

  //  CompleteInfos;
  //  FCanClose :=true;
end;

procedure TFrm_MainDelos2Easy.BEtape6Click(Sender: TObject);
begin
  DoEtape6();
end;

procedure TFrm_MainDelos2Easy.DoEtape6();
begin
// Si on lance pas le Post control..... est-ce que ca plante ?? Oui Pareil ///
    Log.Log('InstallEasyMag', Log.Ref, Log.Mag, 'Install', 'Post-Contrôles...', logNotice, True, 0, ltServer);
    BEtape6.Enabled := False;
    pbEtape.Visible := true;
    pbEtape.Max := 100;
    pbEtape.Position := 0;
    pbEtape.Refresh;
    StatusBar1.Panels[1].Text := 'Post-Contrôles...';
    lbl_Status.Caption:='Post-Contrôles...';
    lbl_Status.Visible:=true;
    Application.ProcessMessages;
    FPostControlesThread   := nil;
    if not(Application_Install) then
      begin
          FPostControlesThread   :=  TPostControlesThread.Create(true,
            StatusCallBack,ProgressInstallCallBack,
            PostControlesCallBack);
      end
    else
      begin
          FPostControlesThread   :=  TPostControlesThread.Create(true,
            StatusCallBack, nil,
            PostControlesCallBack);
      end;
    FPostControlesThread.DB     := FDB;
    FPostControlesThread.EASY   := FEASY;
    FPostControlesThread.Start;
end;

procedure TFrm_MainDelos2Easy.BEtape5Click(Sender: TObject);
begin
  BEtape5.Enabled := False;
  Application.ProcessMessages;
  DoEtape5();
end;

procedure TFrm_MainDelos2Easy.DoEtape5();
begin
    BEtape5.Enabled := False;
    Application.ProcessMessages;
    // Lancement d l'installation...
    pbEtape.Visible := true;
    pbEtape.Max := 100;
    pbEtape.Position := 0;
    pbEtape.Refresh;
    lbl_Status.Visible := true;
    lbl_Status.Refresh;
    Application.ProcessMessages;
    FInstallTHread   := nil;
    if Application_Install
      then
          FInstallTHread   := TInstallDossierMagThread.Create(true,StatusCallBack,nil,InstallCallBack)
      else
          FInstallTHread   := TInstallDossierMagThread.Create(true,StatusCallBack,ProgressInstallCallBack,InstallCallBack);
    FInstallTHread.DB   := FDB;
    FInstallTHread.EASY := FEASY;
    FInstallTHread.Start;
end;

procedure TFrm_MainDelos2Easy.BEtape1Click(Sender: TObject);
begin
  BEtape1.Enabled:=false;
  Application.ProcessMessages;
  DeleteShortCutLauncherV7(); // Non Bloquant
  if DoEtape0 then
    DoEtape1;
end;

procedure TFrm_MainDelos2Easy.LancementAuto();
begin
  BInstallation.Enabled:=false;
  FLancementAuto:=true;
  // les premières Etapes ne sont pas dans des threads
  if DoEtape0 then
    DoEtape1;
  Application.ProcessMessages;
  if (BEtape2.Enabled)
    then DoEtape2();
  // ===> Le soucis c'est qu'on va passer tout droit donc rien ne va se faire tant qu'on a pas recup le minisplit
  Application.ProcessMessages;
  Continue_A_Partir_Etape3();
end;

procedure TFrm_MainDelos2Easy.Continue_A_Partir_Etape3();
begin
  if (BEtape3.Enabled)
    then DoEtape3();
  Application.ProcessMessages;
  if (BEtape4.Enabled)
    then DoEtape4();
  Application.ProcessMessages;
  // Etape dans un thread
  if (BEtape5.Enabled)
    then DoEtape5();
  Application.ProcessMessages;
  // Etape 5 Lancera automatiquement "Etape6" en retour du Thread
end;

function TFrm_MainDelos2Easy.DoEtapeCtrlFiles():Boolean;
begin
    //Présence des fichiers ????
    try
      CheckFiles(true);
      Result := true;
    Except
      Result := false;
    end;
end;

// le renommage de la base
function TFrm_MainDelos2Easy.DoEtape0:Boolean;
begin
    result:=false;
    if not(DoEtapeCtrlFiles()) then
      begin
          result:=false;
          DoLog('Fichiers d''installation JAVA/SYMDS : Erreur');
          result:=false;
          exit;
      end;
    if FileExists(FBaseDelos2Easy) and not(FileExists(FBase0)) then
      begin
        If not(RenameFile(FBaseDelos2Easy,FBase0))
          then
              begin
                DoLog(Format('Renommage de %s en %s : Erreur',[ExtractFileName(FBaseDelos2Easy),ExtractFileName(FBase0)]));
                Log.Log('InstallEasyMag', Log.Ref, Log.Mag, 'Install', 'Renommage KO', logError, True, 0, ltServer);
                result:=false
              end
          else
            begin
                result:=true;
                DoLog(Format('Renommage de %s en %s : OK',[ExtractFileName(FBaseDelos2Easy),ExtractFileName(FBase0)]));
                Log.Log('InstallEasyMag', Log.Ref, Log.Mag, 'Install', 'Renommage OK', logInfo, True, 0, ltServer);
            end;
      end
    else
      begin
        if not(FileExists(FBaseDelos2Easy))
          then
            begin
              DoLog(Format('Aucun fichier %s : Erreur',[ExtractFileName(FBaseDelos2Easy)]));
              result:=false
            end;
        If (FileExists(FBase0))
          then
            begin
              DoLog(Format('Le fichier %s existe déjà : Erreur',[ExtractFileName(FBase0)]));
              result:=false
            end;
      end;

end;


procedure TFrm_MainDelos2Easy.DoEtape1;
var vPreControls:Boolean;
    vControleDB:Boolean;
begin
    BEtape1.Enabled:=false;
    Application.ProcessMessages;
    lbl_Result1.Caption:='';
    vPreControls := Precontrols;
    vControleDB  := ControleDB;
    Lbl_Infos.Caption := 'BaseDelos2EASY : ' + FBaseDelos2Easy + #13+#10+
                         'Base0 : '      + FBase0  + #13+#10+
                         'Dossier : '    + FDB.Nom + #13+#10+
                         'Générateur : ' + IntToStr(FDB.BAS_IDENT)  + #13+#10+
                         'Sender : '     + FDB.BAS_SENDER + #13+#10+
                         'GUID   : '     + FDB.BAS_GUID   + #13+#10+
                         'Plage  : '     + FDB.BAS_PLAGE  + #13+#10+
                         'GeneralID  : ' + FDB.GENERAL_ID + #13+#10+
                         'ExternalID : ' + FDB.ExternalID + #13+#10+
                         'PropertiesFile : ' + ExtractFileName(FDB.PropertiesFile) + #13+#10+
                         'Url : '        + FDB.RegistrationUrl;
    If (vPrecontrols and vControleDB)
      then
        begin
          lbl_Result1.Font.Color:=clGreen;
          lbl_Result1.Caption:=CST_OK;
          lbl_Result1.Visible:=true;
          // Signifie que le Minisplit est nécessaire ou pas..
          if FDB.RegistrationUrl=''
            then BEtape2.Enabled := true
            else BEtape4.Enabled := true
        end
      else
        begin
          if (Length(VGSYMDS)=0)
            then
              begin
                  lbl_Result1.Font.Color:=clRed;
                  lbl_Result1.Caption:=CST_ERREUR;
                  lbl_Result1.Visible:=true;
                  Application.ProcessMessages;
                  BEtape1.Enabled := true;
              end
            else
              begin
                  lbl_Result1.Font.Color:=clBlue;
                  lbl_Result1.Caption:=CST_DEJAINSTALL;
                  lbl_Result1.Visible:=true;
                  Application.ProcessMessages;
                  BEtape1.Enabled := true
              end;
        end;
   // BEtape1.Enabled:=true;
end;


function TFrm_MainDelos2Easy.ControleDB:boolean;
var vEngine, vGrp:string;
begin
    FDB.init;
    FDB.DatabaseFile := FBAse0;
    DataMod.Ouverture_IBFile(FDB);

    // Si FDB.RegistrationUrl=0 il nous faut au moins le minisplittage
    // teURLMaster.Text := FDB.RegistrationUrl;
    // -------------------------------------------------------------------------
    // le fichier .properties est-il déjà présent : théoriquement non !
    //   mais c'est possible, si on a mal nettoyer l'ancienne installation ?
    FDB.ServiceName    := 'EASY';
    FDB.HTTPPort       :=  32415; // Forcement en Magasin
    FDB.SymDir         := FGinkoiaPath + 'EASY';
    FDB.ExternalID     := Sender_To_Node(FDB.BAS_SENDER);
    vGrp               := 'mags';
    vEngine            := Format('%s-%s',[vGrp,FDB.ExternalID]);
    FDB.PropertiesFile := Format('%s\engines\%s.properties',[FDB.SymDir,vEngine]);
    // Si le Fichier Existe cela veut dire que c'est déja installé ou que ca va merder à l'installation
    // plusieurs fichier properties !!! PAS BON !!!
    if (FileExists(FDB.PropertiesFile)) then
      begin
        Log.Log('InstallEasyMag', Log.Ref, Log.Mag, 'Install', 'Easy déjà installer', logError, True, 0, ltServer);
        DoLog('EASY a déjà été installé, il y a déja un fichier .properties : Attention');
        // Mais on peut controler le PostControle
        BEtape6.Enabled := true;
        result:=False;
      end;
    if (FDB.BAS_IDENT=0) then
      begin
        DoLog('Le BAS_IDENT est sur "0" (BASE LAME) : ERREUR');
        Log.Log('InstallEasyMag', Log.Ref, Log.Mag, 'Install', 'Le BAS_IDENT est sur "0" (BASE LAME)', logError, True, 0, ltServer);
        result:=False;
      end;
    if not((FileExists(FDB.PropertiesFile))) and (FDB.BAS_IDENT<>0)
     then
      begin
         result:=True;
      end;
end;

function TFrm_MainDelos2Easy.GetSplittagesDistants:boolean;
var json : string;
    IdHTTP: TIdHTTP;
    vUrl : Widestring;
begin
  result:=false;
  // Pour ISF il faudra peut-etre faire autrement... par un partage ?
  IdHTTP        := TIdHTTP.Create;
  try
    json          := '';
    try
      vUrl := TIdURI.UrlENcode('http://easy-ftp.ginkoia.net/list_splits.php?dossier='+LowerCase(FDB.Nom)+'&sender='+UpperCase(FDB.BAS_SENDER));
      json := IdHTTP.Get(vUrl);
    finally
      IdHTTP.Free;
    end;
    // On parse maintenant
    Parse_Json_Datas(json);
    DoDownloadSplitFile();
    Un7zSplitFile(FFullPathSplitFile);
    result:=true;
  except
    result := False;
  end;
end;


procedure TFrm_MainDelos2Easy.Parse_Json_Datas(astr:string);
var  LJsonArr   : TJSONArray;
  LJsonValue : TJSONValue;
  LItem     : TJSONValue;
  vItem     : string;
  IsMiniSplit : Boolean;
begin
   try
    LJsonArr    := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(aStr),0) as TJSONArray;
    try
       FSplitFile:='';
       for LJsonValue in LJsonArr do
       begin
          for LItem in TJSONArray(LJsonValue) do
            begin
                if (TJSONPair(LItem).JsonString.Value='filename')
                  then
                     begin
                        FSplitFile := TJSONPair(LItem).JsonValue.Value;
                        // break;
                     end;
                if (TJSONPair(LItem).JsonString.Value='splittype') and (FSplitFile<>'')
                    and (TJSONPair(LItem).JsonValue.Value='mini')
                  then
                    begin
                       break;
                    end;

            end;
       end;
     finally
      LJsonArr.DisposeOf;
     end;
   Except
    //

   end;
end;

procedure TFrm_MainDelos2Easy.Un7zSplitFile(zipFullFname:string);
var outDir:string;
begin
    with CreateInArchive(CLSID_CFormat7z) do
    begin
      SetPassword('ch@mon1x');
      OpenFile(zipFullFname);

      // pbSplit.Visible:=true;
      SetProgressCallback(pbEtape, nil); // ProgressCallback
      outDir := FSplitLocalDir;
      // IncludeTrailingPathDelimiter(GetTempDirectory) + 'InstallationEASY_'+FormatDateTime('yyyymmdd_hhnnss',Now());
      ExtractTo(outDir);
      // FSplitDIR := outDir;
      // pbSplit.Visible:=false;
    end;
end;




end.
