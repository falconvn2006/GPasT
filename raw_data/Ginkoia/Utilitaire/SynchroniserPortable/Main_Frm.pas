unit Main_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  StrUtils, Dialogs, IB_Components, StdCtrls, ComCtrls, AppEvnts, DB, IBODataset,
  GestionJetonLaunch, InvokeRegistry, Rio, SOAPHTTPClient, Generics.Collections,
  Generics.Defaults, DateUtils, IB_Access, uToolsXE, ShlObj, IBCustomDataSet,
  IBQuery, IBDatabase, uKillApp, uSevenZip, IniFiles, RzBorder, Buttons,
  ExtCtrls, uLog, uThreadProc, ActiveX, uTimeRemain, ServiceControler, uVersion, uLaunchAsAdmin,
  uPostXe, Math;

const
  WM_DEMARRE = WM_USER + 100;
  CREPLICATIONOK = 2998;
  CLASTREPLIC = 2999;
  CSYNCHROOK = 3000;
  CLASTSYNC = 3001;

type
  // Sert pour le calcul de l'espace disque disponible avant transfert
  TEspaceDisque = (tedTotal, tedLibre, tedUtilise);

  TUniteOctet = (tuoOctet, tuoKoctet, tuoMoctet, tuoGoctet, tuoToctet);

  TProgressProc = reference to procedure(aProgress: Integer; aText: string);

  TFile = record
    AName: string;
    ADate: TDateTime;
  end;

  TCompareFile = class(TComparer<TFile>)
    function Compare(const Left, Right: TFile): Integer; override;
  end;

  THistoEvent = record
    Module: string;
    Date: TDateTime;
    Time: TTime;
    Ok: boolean;
  end;

  TCaisseSynchro = record
    Enable: boolean;
    Time: TTime;
    Server: string;
  end;

  TNotebookSynchro = record
    Enable: boolean;
    Nom: string;
    ServerId: Integer;
    Server: string;
  end;

  TNotebookSynchros = array of TNotebookSynchro;

  TSynchroServer = class
  private
    Id: Int64;
    Nom: string;
    Server: string;
    Default: boolean;
  end;

  TSynchroItem = class
  private
    Id: Int64;
    Table: string;
    ktb_id: Int64;
    krh_id: Int64;
    k_dte: TDateTime;
    ok: boolean;
    found: boolean;
  end;

  TSynchroItems = TObjectList<TSynchroItem>;

  TTypeSynchro = (tsNone, tsCaisse, tsNotebook);

  TGenerateurLDF = record
    Id: Int32;
    TypeLDF: Int32;
    BasId: Int32;
    MagId: Int32;
    PosId: Int32;
    SesId: Int32;
    Compteur: Int32;
    K_ID: Int32;
    KRH_ID: Int64;
    KTB_ID: Int32;
    K_VERSION: Int64;
    K_INSERTED: TDateTime;
    K_UPDATED: TDateTime;
    K_LID: Int64;
  end;

  TGenerateursLDF = array of TGenerateurLDF;

  FGenerateursLDF = file of TGenerateurLDF;

  TFrm_Main = class(TForm)
    Database: TIB_Connection;
    ApplicationEvents1: TApplicationEvents;
    Que_CheminServeur: TIBOQuery;
    Que_CheminServeurPRM_STRING: TStringField;
    Que_CheminServeurPRM_INTEGER: TIntegerField;
    Que_CheminServeurPRM_FLOAT: TIBOFloatField;
    Que_BaseIdent: TIBOQuery;
    Que_NomGenerateur: TIBOQuery;
    Que_NomGenerateurRDBGENERATOR_NAME: TStringField;
    Que_NomGenerateurRDBGENERATOR_ID: TSmallintField;
    Que_NomGenerateurRDBSYSTEM_FLAG: TSmallintField;
    Que_ExportGenerator: TIBOQuery;
    Set_Generators: TIB_DSQL;
    Que_BaseID: TIBOQuery;
    Que_LastReplic: TIBOQuery;
    Que_SPNewID: TIBOQuery;
    Que_Event: TIBOQuery;
    Que_GenVersion: TIBOQuery;
    Que_Temp: TIBOQuery;
    RioJetonLaunch: THTTPRIO;
    queTmp: TIBOQuery;
    labSelectBase: TLabel;
    Label1: TLabel;
    edBaseLocale: TEdit;
    btSelectLocalBase: TSpeedButton;
    panSyncBase: TPanel;
    lbBaseSyncTitle: TLabel;
    cbBaseSync: TComboBox;
    lbBaseSync: TLabel;
    panSynchro: TPanel;
    lbTitleSynchro: TLabel;
    btnSynchroniser: TButton;
    pbSynchro: TProgressBar;
    barStatus: TStatusBar;
    panVersion: TPanel;
    lbTitleVersion: TLabel;
    pbVersion: TProgressBar;
    RzBorder1: TRzBorder;
    Label4: TLabel;
    lbBasIdent: TLabel;
    lbBasNom: TLabel;
    lbSyncProgress: TLabel;
    lbVersion: TLabel;
    lbVersionVal: TLabel;
    lbVersionProgress: TLabel;
    memoLogs: TRichEdit;
    panBaseLocale: TPanel;
    lbTypeSync: TLabel;
    lbTypeSyncVal: TLabel;
    odBaseLocale: TOpenDialog;
    lbVersionLame: TLabel;
    lbVersionLameVal: TLabel;
    Que_GenerateursLDF: TIBOQuery;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ApplicationEvents1Exception(Sender: TObject; E: Exception);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btSelectLocalBaseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edBaseLocaleChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSynchroniserClick(Sender: TObject);
    procedure cbBaseSyncSelect(Sender: TObject);
  private
    FRunning: Boolean;
    FInterbasePath: string;
    FLocalBase: string;
    FSyncBase: string;
    FLocalBasePath: string;
    FSyncBasePath: string;
    FGinkoiaPath: string;
    FAutoStart: boolean;
    FInit: boolean;
    FUserRequest: boolean;

    // paramètres de la base locale
    FLocalBasId: Int64;
    FLocalBasIdent: Integer;
    FLocalBasNom: string;
    FLocalBasGuid: string;
    FNbSave: Integer;

    // paramètres de la base de synchro
    FSynchroBasGuid: string;
    FTypeSynchro: TTypeSynchro;
    FCaisseSynchro: TCaisseSynchro;
    FNotebookSynchro: TNotebookSynchro;
    FAllowMultiMag: boolean;
    FLocalVersion: string;
    FLameVersion: string;
    FLocalBaseStatus: TLogLevel;
    FSyncBaseStatus: TLogLevel;
    FSynchroStatus: TLogLevel;
    FVersionStatus: TLogLevel;
    FSynchroServers: TObjectList<TSynchroServer>;
    FSelectedServer: string;
    FProgressVal: integer;
    FProgressText: string;
    FSynchroItems: TSynchroItems;
    FSupprFicRequete: Boolean;
    procedure RelancerLauncher;
    function LancerVerification(sParam: string = 'AUTO'; bWaitFor: boolean = false): boolean;
    function ArreterBase(ABase: string): boolean;
    function DemarrerBase(ABase: string): boolean;
    function reconfigureBase(AExportSQL: TStrings): boolean;
    function CopierFichier(SrcFile, NewFile: string; aProgress: TProgressProc): boolean;
    function RecupererGenerateurs(AExportSQL: TStrings): Boolean;
    function RecupererGenerateursLDF(var AGenerateursLDF: TGenerateursLDF; const ABasID: Integer): Boolean;
    procedure SauvegardeGenerateursLDF(var AGenerateursLDF: TGenerateursLDF; const AFileName: TFileName);
    function ReconfigGenerateursLDF(AGenerateursLDF: TGenerateursLDF; const ABasID: Integer; const AFicSauv: TFileName): Boolean;
    function AddASlash(APath: string): string;
    function getUrlReplic(ABasId: Int64): string;
    function GetParam(var IOInteger: integer; var IOFloat: double; var IOString: string; AType, ACode, ABasID: integer): Boolean;
    function GetParamString(AType, ACode, ABasID: integer): string;
    function BackupBase(ASource, ADest: string; var aDestFile: string): Boolean;

    // Gestion des evénements
    function ExtractVersionArchive(aArchive, aVersion, aDest: string; var aMajVersion: boolean): boolean;
    function getCaisseSynchro(aBaseId: Int64): TCaisseSynchro;
    function getLastKrhId(aGeneralId: Int64): Int64;
    function getGeneralId: Int64;
    procedure processParameters;
    function doSynchro: boolean;
    procedure doProcess(aStart: boolean);
    function doVersion: boolean;
    function checkLocalBase: boolean;
    function connectDatabase(aBase: string): boolean;
    procedure Log_onLog(Sender: TObject; aLogItem: TLogItem);
    function getInterbasePath: string;
    procedure doInit;
    function getBasId(var aBasId: Int64; var aBasIdent: Integer; var aBasNom: string; var aBasGUID: string): boolean;
    procedure closeDatabase;
    function getNotebookSynchro(aBaseId: Int64): TNotebookSynchro;
    function getNotebookSynchros: TNotebookSynchros;
    function getVersion(var aVersion: string): boolean;
    procedure updateLocalBaseStatus;
    function getVersionLame(aBasId: int64; var aVersion: string): boolean;
    procedure addSynchroServer(aId: Int64; aNom, aServer: string; aDefault: boolean);
    procedure fillSynchroServerList;
    function checkSyncBase: boolean;
    function getSynchroServer(aNom: string): TSynchroServer;
    function setHistoEvent(aType: Integer; aDate: TDateTime; aResult: boolean; aTime: TTime; aBasId: Int64): boolean;
    function BoolToInt(aBool: Boolean): Integer; inline;
    function getHistoEvent(aType: Integer; aBasId: Int64): THistoEvent;
    procedure updateProgressSynchro;
    procedure updateProgressVersion;
    function doRestartApp: boolean;
    procedure checkKrhDifferences(aFrom, aTo: Int64);
    function compareKrhDifferences: boolean;
    procedure logKrhDifferences;
    procedure transfertFidBox(aSourcePath, aDestPath: string);
    function getNbSave(var aNbSave: integer): boolean;
    procedure readIni;
    procedure updateYellis;
    function getSynchroGUID(): boolean;
    function FileSize(fileName: wideString): Int64;
    function EspaceDisque(disque: string; espace: TEspaceDisque; unite: TUniteOctet): extended;
  public
    { Déclarations publiques }
  end;

var
  Frm_Main: TFrm_Main;

resourcestring
  // Message d'erreurs
  ParamManquant = 'Paramètre de l''exécutable manquant !';
  ParamBaseInvalide = 'Erreur de paramètre: la base en paramètre n''existe pas !';
  BaseNonInitPourSynchro = 'Base non initialisée pour la synchronisation';
  BaseNonPortable = 'La base n''est pas une base synchronisée.';
  ErreurConn = 'Erreur à la connexion de la base: %s';
  NoRecupGenerateur = 'Impossible de récupèrer les générateurs';
  ParamBaseSrvInvalide = 'Impossible de trouver la base du serveur: %s';
  ErreurCopierFichier = 'Erreur lors de la copie: %s';
  ErreurReconfigureBase = 'Erreur lors de la reconfiguration de la base: %s';
  ErreurArretBase = 'imposible d''arrêter la base du portable';
  ErreurRenomage = 'Impossible de renomer la nouvelle base';
  ErreurDemarrerBase = 'Impossible de redémarrer la base';

  // Message d'info
  Info_Initialisation = 'Initialisation';
  Info_Connexion = 'Connexion à la base';
  Info_RecupParam = 'Récupération des paramètres';
  Info_Copier = 'Copie de: %s';
  Info_ReconfigBase = 'Configuration nouvelle base';
  Info_MiseEnplace = 'Mise en place nouvelle base';
  Info2_Estimation = 'Estimation temps restant: %s';
  Info2_jour = '%s jour ';
  Info2_jours = '%s jours ';
  Info2_Heure = '%s heure ';
  Info2_Heures = '%s heures ';
  Info2_Minute = '%s minute ';
  Info2_Minutes = '%s minutes ';
  Info2_Seconde = '%s seconde ';
  Info2_Secondes = '%s secondes ';
  Info2_MoinsDe1S = 'moins de 1 seconde';

function MessageBoxTimeOutA(hWnd: HWND; lpText: PChar; lpCaption: PChar; uType: UINT; wLanguageId: WORD; dwMilliseconds: DWORD): Integer; stdcall;

procedure splitVersionString(aVersion: string; var aMajor, aMinor, aRelease, aBuild: Word);

function compareVersionString(aVersion, bVersion: string): integer;

implementation

uses
  TlHelp32, Registry, Information_Frm;

{$R *.dfm}

var
  NomExecutable: string;
  VersionProg: string;
  RepertoireDesLog: string;

function MessageBoxTimeOutA; external user32 name 'MessageBoxTimeoutA';

procedure splitVersionString(aVersion: string; var aMajor, aMinor, aRelease, aBuild: Word);
var
  ia, ib, ic, id: integer;
  sa, sb, sc, sd: string;
begin
  ia := PosEx('.', aVersion, 1);
  ib := PosEx('.', aVersion, ia + 1);
  ic := PosEx('.', aVersion, ib + 1);
  id := Length(aVersion);

  sa := '';
  sb := '';
  sc := '';
  sd := '';

  if ia = 0 then
  begin
    sa := aVersion;
  end
  else
  begin
    sa := copy(aVersion, 1, ia - 1);
    if ib = 0 then
    begin
      sb := copy(aVersion, ia + 1, id - ia);
    end
    else
    begin
      sb := copy(aVersion, ia + 1, ib - ia - 1);
      if ic = 0 then
      begin
        sc := copy(aVersion, ib + 1, id - ib);
      end
      else
      begin
        sc := copy(aVersion, ib + 1, ic - ib - 1);
        sd := copy(aVersion, ic + 1, id - ic);
      end;
    end;
  end;

  aMajor := StrToIntDef(sa, 0);
  aMinor := StrToIntDef(sb, 0);
  aRelease := StrToIntDef(sc, 0);
  aBuild := StrToIntDef(sd, 0);
end;

function compareVersionString(aVersion, bVersion: string): integer;
var
  vAMaj, vAMin, vARel, vABui: Word;
  vBMaj, vBMin, vBRel, vBBui: Word;
begin
  splitVersionString(aVersion, vAMaj, vAMin, vARel, vABui);
  splitVersionString(bVersion, vBMaj, vBMin, vBRel, vBBui);

  Result := 0;

  if vAMaj > vBMaj then
  begin
    Result := 1;
    Exit;
  end;
  if vAMaj < vBMaj then
  begin
    Result := -1;
    Exit;
  end;

  if vAMin > vBMin then
  begin
    Result := 1;
    Exit;
  end;
  if vAMin < vBMin then
  begin
    Result := -1;
    Exit;
  end;

  if vARel > vBRel then
  begin
    Result := 1;
    Exit;
  end;
  if vARel < vBRel then
  begin
    Result := -1;
    Exit;
  end;

  if vABui > vBBui then
  begin
    Result := 1;
    Exit;
  end;
  if vABui < vBBui then
  begin
    Result := -1;
    Exit;
  end;
end;

function ApplicationVersion: string;
var
  VerInfoSize, VerValueSize, Dummy: DWord;
  VerInfo: Pointer;
  VerValue: PVSFixedFileInfo;
  Version: string;
  d: TDateTime;
  AgeExe: string;
begin
  VerInfoSize := GetFileVersionInfoSize(PChar(ParamStr(0)), Dummy);
  if VerInfoSize <> 0 then   // Les info de version sont inclues
  begin
    // On alloue de la mémoire pour un pointeur sur les info de version
    GetMem(VerInfo, VerInfoSize);
    // On récupère ces informations :
    GetFileVersionInfo(PChar(ParamStr(0)), 0, VerInfoSize, VerInfo);
    VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
    // On traite les informations ainsi récupérées
    with VerValue^ do
    begin
      Version := IntTostr(dwFileVersionMS shr 16);
      Version := Version + '.' + IntTostr(dwFileVersionMS and $FFFF);
      Version := Version + '.' + IntTostr(dwFileVersionLS shr 16);
      Version := Version + '.' + IntTostr(dwFileVersionLS and $FFFF);
    end;
    // On libère la place précédemment allouée
    FreeMem(VerInfo, VerInfoSize);
  end
  else
    Version := '0.0.0.0 ';

  d := FileDateToDateTime(FileAge(ParamStr(0)));
  AgeExe := ' du ' + FormatDateTime('dd/mm/yyyy', d);
  result := Version + AgeExe;
end;

function ExecuterProcess(cmdLine: string; timeout: integer; const OkMontrer: boolean = true): boolean;
var
  StartInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
begin
  Result := false;
  //fonction qui crée un process cmdline et attends sa fin ou celle du timeout pour rend la main et signaler le résultat
  //renvoi true si fini ok ou false si fini car timeout
  //timeout -1 signifie que l'on n'attends pas la fin de l'execution du process, mais seulement la fin de sa création
      { Mise à zéro de la structure StartInfo }
  FillChar(StartInfo, SizeOf(StartInfo), #0);
  { Seule la taille est renseignée, toutes les autres options }
  { laissées à zéro prendront les valeurs par défaut }
  StartInfo.cb := SizeOf(StartInfo);
  if not (OkMontrer) then
    StartInfo.wShowWindow := SW_HIDE;
  Screen.Cursor := crHourGlass;
  { Lancement de la ligne de commande }
  if CreateProcess(NIL, Pchar(cmdLine), NIL, NIL, False, 0, NIL, NIL, StartInfo, ProcessInfo) then
  begin
    Result := true;
    { L'application est bien lancée, on va en attendre la fin }
    { ProcessInfo.hProcess contient le handle du process principal de l'application }
    if timeout <> 0 then
    begin
      Result := false;
      //Application.ProcessMessages;
      case WaitForSingleObject(ProcessInfo.hProcess, timeout) of
        WAIT_OBJECT_0:
          Result := True;
        WAIT_TIMEOUT:
          ;
      end;
    end;
  end;
end;

procedure KillProcessus(ExeAKill: string);
var
  ProcessEntry32: TProcessEntry32;
  HSnapShot: THandle;
  HProcess: THandle;
  bOk: boolean;
  s: string;
begin
  HSnapShot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if HSnapShot = 0 then
    exit;
  ProcessEntry32.dwSize := sizeof(ProcessEntry32);
  bOk := Process32First(HSnapShot, ProcessEntry32);
  while bOk do
  begin
    s := string(ProcessEntry32.szExeFile);
    if UpperCase(s) = UpperCase(ExeAKill) then
    begin
      HProcess := OpenProcess(PROCESS_TERMINATE, False, ProcessEntry32.th32ProcessID);
      if HProcess <> 0 then
      begin
        TerminateProcess(HProcess, 0);
        CloseHandle(HProcess);
      end;
      Break;
    end;
    bOk := Process32Next(HSnapShot, ProcessEntry32);
  end;
  CloseHandle(HSnapShot);
end;

procedure TFrm_Main.RelancerLauncher;
begin
  ExecuterProcess('"' + FGinkoiaPath + 'LaunchV7.exe"', 0);
end;

function TFrm_Main.LancerVerification(sParam: string = 'AUTO'; bWaitFor: boolean = false): boolean;
var
  timeout: Integer;
begin
  if bWaitFor then
    timeout := INFINITE
  else
    timeout := 0;

  // rajout du deuxième paramètre
  Result := ExecuterProcess('"' + FGinkoiaPath + 'Verification.exe" ' + sParam + ' SYNCHROPORTABLE ' + FSynchroBasGuid, timeout);
end;

function TFrm_Main.CopierFichier(SrcFile, NewFile: string; aProgress: TProgressProc): boolean;
const
  bufSize = 262144;
var
  StreamSrc: TFileStream;
  StreamDst: TFileStream;
  pBuf: Pointer;
  Cnt: integer;
  TotCopie: Int64;
  Taille: Int64;
  vTimeRemain: TTimeRemain;
begin
  Result := false;

  StreamSrc := nil;
  StreamDst := nil;
  TotCopie := 0;

  try
    try
      vTimeRemain := TTimeRemain.Create;

      // ouvre le fichier Source
      StreamSrc := TFileStream.Create(SrcFile, fmOpenRead or fmShareDenyWrite);
      Taille := StreamSrc.Size;
      vTimeRemain.Max := Taille;
      vTimeRemain.Smooth := 10;

      // efface le nouveau fichier s'il existe déjà
      if FileExists(NewFile) then
        DeleteFile(NewFile);

      StreamDst := TFileStream.Create(NewFile, fmCreate or fmShareExclusive);
      GetMem(pBuf, bufSize);
      try
        repeat
          Cnt := StreamSrc.Read(pBuf^, bufSize);
          if Cnt > 0 then
          begin
            Cnt := StreamDst.Write(pBuf^, Cnt);
            TotCopie := TotCopie + Cnt;
            vTimeRemain.Progress := TotCopie;

            aProgress(vTimeRemain.Pourcent, vTimeRemain.RemainStr);
          end;
        until (Cnt = 0);
        Result := true;

      finally
        FreeMem(pBuf, bufSize);
      end;
    finally
      if Assigned(StreamSrc) then
        FreeAndNil(StreamSrc);

      if Assigned(StreamDst) then
        FreeAndNil(StreamDst);

      vTimeRemain.Free;

      aProgress(100, 'Transfert terminé');
    end;

  except
    on E: Exception do
    begin
      Log.Log('', 'CopierFichier', 'Log', E.Message, logError, true, 0, ltLocal);
    end;
  end;

end;

function TFrm_Main.AddASlash(APath: string): string;
begin
  Result := APath;
  if (Result <> '') and (Result[Length(Result)] <> '\') then
    Result := Result + '\';
end;

function TFrm_Main.RecupererGenerateurs(AExportSQL: TStrings): Boolean;
var
  BaseID: integer;
  vGenName: string;
  vGenSys: INteger;
begin
  try
    Result := false;
    try
      //commencer par le numéro de la base
      AExportSQL.Add('UPDATE genparambase SET par_string=''' + IntToStr(FLocalBasIdent) + ''' WHERE par_nom=''IDGENERATEUR'';');

      //récupèrer le nom de chaque générateur
      Que_NomGenerateur.open;
      Que_NomGenerateur.first;

      //pour chaque générateur non system récupérer sa valeur sous la forme d'une ligne d'exportation set generator to 'val'
      while not Que_NomGenerateur.eof do
      begin
        // Exclusion de quelques générateurs locaux :
        vGenSys := Que_NomGenerateur.FieldByName('RDB$SYSTEM_FLAG').asInteger;
        vGenName := UpperCase(Que_NomGenerateur.FieldByName('RDB$GENERATOR_NAME').asString);

        Que_NomGenerateur.next;

        if vGenSys = 1 then
          Continue;

        if vGenName = 'AGR_ID' then
          Continue;
        if vGenName = 'NUM_VERSION' then
          Continue;
        if vGenName = 'MSE_ID' then
          Continue;

        // Export du générateur
        Que_ExportGenerator.sql.text := 'select ''set generator ''|| F_RTRIM(RDB$GENERATOR_NAME) ||'' to ''||GEN_ID(' + vGenName + ',0)  from rdb$Generators where RDB$GENERATOR_NAME=UPPER(''' + vGenName + ''')';
        Que_ExportGenerator.Open;
        AExportSQL.Add(Que_ExportGenerator.fields[0].asString + ';');
      end;

      Result := true;
    finally
      Que_NomGenerateur.close;
      Que_ExportGenerator.close;
    end;
  except
    on E: Exception do
    begin
      Log.Log('', 'recupererGenerateurs', 'Log', E.Message, logError, true, 0, ltLocal);
    end;
  end;
end;
//------------------------------------------------------------------------------

function TFrm_Main.RecupererGenerateursLDF(var AGenerateursLDF: TGenerateursLDF; const ABasID: Integer): Boolean;
var
  i: Integer;
begin
  Result := False;
  try
    try
      Que_GenerateursLDF.ParamByName('BASID').AsInteger := ABasID;
      Que_GenerateursLDF.Open();

      SetLength(AGenerateursLDF, Que_GenerateursLDF.RecordCount);
      i := 0;

      while not (Que_GenerateursLDF.Eof) do
      begin
        AGenerateursLDF[i].id := Que_GenerateursLDF.FieldByName('GRT_ID').AsInteger;
        AGenerateursLDF[i].TypeLDF := Que_GenerateursLDF.FieldByName('GRT_TYPE').AsInteger;
        AGenerateursLDF[i].BasId := Que_GenerateursLDF.FieldByName('GRT_BASID').AsInteger;
        AGenerateursLDF[i].MagId := Que_GenerateursLDF.FieldByName('GRT_MAGID').AsInteger;
        AGenerateursLDF[i].PosId := Que_GenerateursLDF.FieldByName('GRT_POSID').AsInteger;
        AGenerateursLDF[i].SesId := Que_GenerateursLDF.FieldByName('GRT_SESID').AsInteger;
        AGenerateursLDF[i].Compteur := Que_GenerateursLDF.FieldByName('GRT_COMPTEUR').AsInteger;
        AGenerateursLDF[i].K_ID := Que_GenerateursLDF.FieldByName('K_ID').AsInteger;
        AGenerateursLDF[i].KRH_ID := Que_GenerateursLDF.FieldByName('KRH_ID').AsLargeInt;
        AGenerateursLDF[i].KTB_ID := Que_GenerateursLDF.FieldByName('KTB_ID').AsInteger;
        AGenerateursLDF[i].K_VERSION := Que_GenerateursLDF.FieldByName('K_VERSION').AsLargeInt;
        AGenerateursLDF[i].K_INSERTED := Que_GenerateursLDF.FieldByName('K_INSERTED').AsDateTime;
        AGenerateursLDF[i].K_UPDATED := Que_GenerateursLDF.FieldByName('K_UPDATED').AsDateTime;
        AGenerateursLDF[i].K_LID := Que_GenerateursLDF.FieldByName('K_LID').AsLargeInt;

        Inc(i);

        Que_GenerateursLDF.Next();
      end;
    finally
      Que_GenerateursLDF.Close();
    end;
    Result := True;
  except
    on E: Exception do
      Log.Log('', 'RecupererGenerateursLDF', 'Log', E.Message, logError, True, 0, ltLocal);
  end;
end;
//------------------------------------------------------------------------------

procedure TFrm_Main.SauvegardeGenerateursLDF(var AGenerateursLDF: TGenerateursLDF; const AFileName: TFileName);
var
  FicGenerateursLDF: FGenerateursLDF;
  i: Integer;
begin
  AssignFile(FicGenerateursLDF, AFileName);
  try
    // Ouvre le fichier
    Rewrite(FicGenerateursLDF);

    // Enregistre chaque ligne
    for i := 0 to Length(AGenerateursLDF) - 1 do
      Write(FicGenerateursLDF, AGenerateursLDF[i]);
  finally
    // Ferme le fichier
    CloseFile(FicGenerateursLDF);
  end;
end;
//------------------------------------------------------------------------------

function TFrm_Main.ReconfigGenerateursLDF(AGenerateursLDF: TGenerateursLDF; const ABasID: Integer; const AFicSauv: TFileName): Boolean;
const
  DATETIMESQL = 'yyyy-mm-dd hh:nn:ss';
var
  i: Integer;
begin
  Result := False;
  try
    try
      Que_GenerateursLDF.ParamByName('BASID').AsInteger := ABasID;
      Que_GenerateursLDF.Open();
      Set_Generators.SQL.Clear();

      for i := 0 to Length(AGenerateursLDF) - 1 do
      begin
        if Que_GenerateursLDF.Locate('GRT_ID', AGenerateursLDF[i].id, []) then
        begin
          if Que_GenerateursLDF.FieldByName('GRT_COMPTEUR').AsInteger <> AGenerateursLDF[i].Compteur then
          begin
            Set_Generators.SQL.Clear();
            Set_Generators.SQL.Add('UPDATE GENGENERATEUR');
            Set_Generators.SQL.Add('   SET GRT_COMPTEUR = ' + IntToStr(AGenerateursLDF[i].Compteur));
            Set_Generators.SQL.Add('WHERE  GRT_ID = ' + IntToStr(Que_GenerateursLDF.FieldByName('GRT_ID').AsInteger) + ';');
            Set_Generators.ExecSQL();
          end;
        end
        else
        begin
          Set_Generators.SQL.Clear();
          Set_Generators.SQL.Add('INSERT INTO GENGENERATEUR (GRT_ID, GRT_TYPE, GRT_BASID, GRT_MAGID, GRT_POSID, GRT_SESID, GRT_COMPTEUR)');
          Set_Generators.SQL.Add(Format('VALUES (%0:d, %1:d, %2:d, %3:d, %4:d, %5:d, %6:d);', [AGenerateursLDF[i].id, AGenerateursLDF[i].TypeLDF, AGenerateursLDF[i].BasId, AGenerateursLDF[i].MagId, AGenerateursLDF[i].PosId, AGenerateursLDF[i].SesId, AGenerateursLDF[i].Compteur]));
          Set_Generators.ExecSQL();

          Set_Generators.SQL.Clear();
          Set_Generators.SQL.Add('INSERT INTO K (K_ID, KRH_ID, KTB_ID, K_VERSION, K_ENABLED, KSE_OWNER_ID,');
          Set_Generators.SQL.Add('               KSE_INSERT_ID, K_INSERTED, KSE_UPDATE_ID, K_UPDATED,');
          Set_Generators.SQL.Add('               KSE_LOCK_ID, KMA_LOCK_ID, K_LID)');
          Set_Generators.SQL.Add(Format('VALUES (%0:d, %1:d, %2:d, %3:d, 1, -1, -1, ''%4:s'', -1, ''%5:s'', %0:d, %0:d, %6:d);', [AGenerateursLDF[i].K_ID, AGenerateursLDF[i].KRH_ID, AGenerateursLDF[i].KTB_ID, AGenerateursLDF[i].K_VERSION, FormatDateTime(DATETIMESQL, AGenerateursLDF[i].K_INSERTED), FormatDateTime(DATETIMESQL, AGenerateursLDF[i].K_UPDATED), AGenerateursLDF[i].K_LID]));
          Set_Generators.ExecSQL();
        end;
      end;
    finally
      Que_GenerateursLDF.Close();
    end;

    Result := True;
  except
    on E: Exception do
      Log.Log('', 'ReconfigGenerateursLDF', 'Log', E.Message, logError, True, 0, ltLocal);
  end;
end;
//------------------------------------------------------------------------------

function TFrm_Main.reconfigureBase(AExportSQL: TStrings): boolean;
var
  i: integer;
begin
  result := false;

  try
    for i := 1 to AExportSQL.Count do
    begin
      if AExportSQL[i - 1] <> '' then
      begin
        Set_Generators.sql.clear;
        Set_Generators.SQL.Text := AExportSQL[i - 1];
        Set_Generators.ExecSQL;
      end;
    end;

    Result := true;
  except
    on E: Exception do
      Log.Log('', 'reconfigureBase', 'Log', E.Message, logError, true, 0, ltLocal);
  end;
end;

function TFrm_Main.ArreterBase(ABase: string): boolean;
var
  cmdline: string;
  i: integer;
begin
  Result := false;

  try
//    Log.Log('Synchro', 'ArreterBase', 'Log', 'Arrêt du service Interbase...', logInfo, true, 0, ltLocal);
//    // on redémarre le service interbase avant d'arrêter la base locale pour éviter les problèmes de renommage
//    if ServiceWaitStop('', 'IBG_gds_db', 30000) then
//    begin
//      Log.Log('Synchro', 'ArreterBase', 'Log', 'Arrêt du service Interbase réussi', logInfo, true, 0, ltLocal);
//
//      Sleep(10000);
//      // une fois le service arrêté, si l'exe d'interbase est toujours présent, on le tue
////      if IsProcessInMemory('ibserver.exe') then
////      begin
////        KillProcessus('ibserver.exe');
////        Sleep(5000);
////      end;
//
//      // on fait plusieurs tentatives pour redémarrer le service car il faut impérativement qu'interbase soit redémarré
//      for i := 0 to 5 do
//      begin
//        if ServiceWaitStart('', 'IBG_gds_db', 20000) then
//        begin
//          Log.Log('Synchro', 'ArreterBase', 'Log', 'Redémarrage du service Interbase réussi', logInfo, true, 0, ltLocal);
//          // on vérifie que le process Interbase tourne, si oui on continue le processus
//          if IsProcessInMemory('ibserver.exe') then
//            break;
//        end;
//      end;
//    end
//    else
//      Log.Log('Synchro', 'ArreterBase', 'Log', 'Arrêt du service Interbase impossible', logWarning, true, 0, ltLocal);
//
//    Sleep(10000);
//    // on vérifie que le process Interbase tourne, si NON on essai de redémarrer et sort en erreur le cas échéant
//    if not IsProcessInMemory('ibserver.exe') then
//    begin
//      Log.Log('Synchro', 'ArreterBase', 'Log', 'Impossible de redémarrer interbase', logError, true, 0, ltLocal);
//      Exit;
//    end;

    cmdline := '"' + FInterbasePath + 'gfix.exe" -rollback all "' + ABase + '" -user SYSDBA -password masterkey';

    if ExecuterProcess(cmdline, 60000, false) then
    begin
      cmdline := '"' + FInterbasePath + 'gfix.exe" -shut -force 0 -user SYSDBA -password masterkey "' + ABase + '"';

      if ExecuterProcess(cmdline, 60000, false) then
      begin
        Result := true;
      end;
    end;

    Sleep(10000);

  except
    on E: Exception do
      Log.Log('', 'arreterBase', 'Log', E.Message, logError, true, 0, ltLocal);
  end;
end;
//------------------------------------------------------------------------------

function TFrm_Main.BackupBase(ASource, ADest: string; var aDestFile: string): Boolean;
var
  sFileName, sDirDest, sFileExt: string;
  Search: TSearchRec;
  i: Integer;
  Lst: TList<TFile>;
  SearchFile: TFile;
begin
  Result := False;
  sFileName := ExtractFileName(ASource);
  sFileName := ChangeFileExt(sFileName, '');
  sDirDest := ExtractFilePath(ADest);
  sFileExt := ExtractFileExt(ASource);
  // Récupération des fichiers sFilename*.* dans le répertoire backup
  Lst := TList<TFile>.Create(TCompareFile.Create);
  i := FindFirst(sDirDest + sFileName + '*.*', faAnyFile, Search);
  try
    while i = 0 do
    begin
      if (Search.Name <> '.') and (Search.Name <> '..') and ((Search.Attr and faDirectory) = 0) then
      begin
        SearchFile.AName := Search.Name;
        SearchFile.ADate := Search.TimeStamp;
        Lst.Add(SearchFile);
      end;
      i := FindNext(Search);
    end;

    // Tri de la liste
    Lst.Sort;

    // Suppression des fichiers les plus vieux
    while Lst.Count >= FNbSave do
    begin
      DeleteFile(sDirDest + Lst[0].AName);
      Lst.Delete(0);
    end;

    // Recherche du 1er nom disponible
    i := 1;
    while FileExists(sDirDest + sFileName + IntToStr(i) + sFileExt) do
      Inc(i);

    // renommage du fichier
    aDestFile := sDirDest + sFileName + IntToStr(i) + sFileExt;
    Result := RenameFile(ASource, aDestFile);

    // si le fichier est toujours vérouillé, on tue interbase et on ressai une fois
    if not Result then
    begin
      KillProcessus('ibserver.exe');
      Sleep(10000);
      Result := RenameFile(ASource, aDestFile);
    end;
  finally
    Lst.Free;
    FindClose(Search);
  end;
end;

procedure TFrm_Main.btnSynchroniserClick(Sender: TObject);
begin
  doProcess(true);
end;

procedure TFrm_Main.btSelectLocalBaseClick(Sender: TObject);
begin

  if DirectoryExists('C:\Ginkoia\Data') then
    odBaseLocale.InitialDir := 'C:\Ginkoia\Data';
  if DirectoryExists('D:\Ginkoia\Data') then
    odBaseLocale.InitialDir := 'D:\Ginkoia\Data';

  if odBaseLocale.Execute then
  begin
    edBaseLocale.Text := odBaseLocale.FileName;
    doProcess(false);
  end;
end;

function TFrm_Main.DemarrerBase(ABase: string): boolean;
begin
  Result := false;
  try
    if ExecuterProcess('"' + FInterbasePath + 'gfix.exe" -online -user sysdba -password masterkey "' + ABase + '"', 10000, false) then
      Result := true;
  except
    on E: Exception do
      Log.Log('', 'demarrerBase', 'Log', E.Message, logError);
  end;
end;
//------------------------------------------------------------------------------

function TFrm_Main.getCaisseSynchro(aBaseId: Int64): TCaisseSynchro;
begin
  result.Enable := false;
  result.Time := 0;
  result.Server := '';

  try
    queTmp.Close;
    queTmp.SQL.Text := 'SELECT PRM_INTEGER, PRM_FLOAT, PRM_STRING FROM GENPARAM ' + 'JOIN K ON K_ID = PRM_ID AND K_ENABLED=1 ' + 'JOIN GENBASES ON BAS_ID = PRM_POS ' + 'WHERE PRM_TYPE=11 AND PRM_CODE=50 AND BAS_ID = :BASID';
    queTmp.ParamByName('BASID').AsLargeInt := aBaseId;
    queTmp.Open;

    if queTmp.IsEmpty then
      Exit;

    result.Enable := (queTmp.FieldByName('PRM_INTEGER').AsInteger = 1);
    result.Time := TTime(queTmp.FieldByName('PRM_FLOAT').AsFloat);
    result.Server := queTmp.FieldByName('PRM_STRING').asString;
  finally
    queTmp.Close;
  end;
end;
//------------------------------------------------------------------------------

function TFrm_Main.getNotebookSynchro(aBaseId: Int64): TNotebookSynchro;
begin
  result.Enable := false;
  result.ServerId := 0;
  result.Server := '';

  try
    queTmp.Close;
    queTmp.SQL.Text := 'SELECT BAS_NOM, PRM_INTEGER, PRM_FLOAT, PRM_STRING FROM GENPARAM ' + 'JOIN K ON K_ID = PRM_ID AND K_ENABLED=1 ' + 'JOIN GENBASES ON BAS_IDENT = PRM_POS ' + 'WHERE PRM_TYPE=3 AND PRM_CODE=33 AND BAS_ID = :BASID';
    queTmp.ParamByName('BASID').AsLargeInt := aBaseId;
    queTmp.Open;

    if queTmp.IsEmpty then
      Exit;

    result.Enable := (queTmp.FieldByName('PRM_INTEGER').AsInteger = 1);
    result.Nom := queTmp.FieldByName('BAS_NOM').AsString;
    result.ServerId := Trunc(queTmp.FieldByName('PRM_FLOAT').AsFloat);
    result.Server := queTmp.FieldByName('PRM_STRING').asString;
  finally
    queTmp.Close;
  end;
end;
//------------------------------------------------------------------------------

function TFrm_Main.getNotebookSynchros: TNotebookSynchros;
var
  ia: integer;
begin
  setLength(Result, 0);

  try
    queTmp.Close;
    queTmp.SQL.Text := 'SELECT BAS_NOM, PRM_INTEGER, PRM_FLOAT, PRM_STRING, PRM_POS FROM GENPARAM ' + 'JOIN K ON K_ID = PRM_ID AND K_ENABLED=1 ' + 'JOIN GENBASES ON BAS_IDENT = CAST(PRM_POS AS VARCHAR(32)) ' + 'WHERE PRM_TYPE=3 AND PRM_CODE=33 AND PRM_FLOAT=0 AND PRM_STRING <> '''' ';
    queTmp.Open;

    ia := 0;
    while not queTmp.Eof do
    begin
      setLength(Result, ia + 1);

      Result[ia].Enable := (queTmp.FieldByName('PRM_INTEGER').AsInteger = 1);
      Result[ia].Nom := queTmp.FieldByName('BAS_NOM').AsString;
      Result[ia].ServerId := Trunc(queTmp.FieldByName('PRM_POS').AsInteger);
      Result[ia].Server := queTmp.FieldByName('PRM_STRING').asString;

      Inc(ia);
      queTmp.Next;
    end;
  finally
    queTmp.Close;
  end;
end;
//------------------------------------------------------------------------------

function TFrm_Main.getVersionLame(aBasId: int64; var aVersion: string): boolean;
var
  vUrlWS: string;
  vAdresseWS: string;
  vDatabaseWS: string;
  vAdresse: string;
begin
  Result := false;

  try
    CoInitialize(nil);
    vUrlWS := GetUrlReplic(aBasId);
    vAdresseWS := GetParamString(11, 34, aBasId);
    vDatabaseWS := GetParamString(11, 36, aBasId);

    vAdresse := StringReplace(vUrlWS, '/DelosQPMAgent.dll', vAdresseWS, [rfReplaceAll, rfIgnoreCase]);

    aVersion := GetIJetonLaunch(vAdresse).GetVersionBdd(vDatabaseWS);
    Result := true;
  except
    on E: Exception do
    begin
      Log.Log('', 'getVersionLame', 'Log', 'Impossible de récupérer la version lame : ' + E.Message, logError);
    end;
  end;
end;
//------------------------------------------------------------------------------

function TFrm_Main.getBasId(var aBasId: Int64; var aBasIdent: Integer; var aBasNom: string; var aBasGUID: string): boolean;
begin
  Result := false;

  try
    queTmp.Close;
    queTmp.SQL.Text := 'SELECT BAS_ID, BAS_IDENT, BAS_NOM, BAS_GUID ' + 'FROM genbases ' + 'JOIN k on (K_ID = BAS_ID AND K_ENABLED=1) ' + 'JOIN genparambase ON (BAS_IDENT = PAR_STRING) ' + 'WHERE PAR_NOM = ''IDGENERATEUR''';
    queTmp.Open;

    if queTmp.IsEmpty then
    begin
      raise Exception.Create('Aucun résultat');
    end;

    aBasId := queTmp.FieldByName('BAS_ID').AsLargeInt;
    aBasIdent := queTmp.FieldByName('BAS_IDENT').AsInteger;
    aBasNom := queTmp.FieldByName('BAS_NOM').AsString;
    aBasGUID := queTmp.FieldByName('BAS_GUID').AsString;

    queTmp.Close;
    Result := true;
  except
    on E: Exception do
      Log.Log('', 'getBasId', 'Log', E.Message, logError);
  end;
end;
//------------------------------------------------------------------------------

function TFrm_Main.getNbSave(var aNbSave: integer): boolean;
begin
  Result := false;

  try
    queTmp.Close;
    queTmp.SQL.Text := 'SELECT PRM_INTEGER FROM GENPARAM ' + 'JOIN k on (K_ID = PRM_ID AND K_ENABLED=1) ' + 'JOIN GENBASES ON (BAS_ID = PRM_POS) ' + 'JOIN k on (K_ID = BAS_ID AND K_ENABLED=1) ' + 'JOIN genparambase ON (BAS_IDENT = PAR_STRING) ' + 'WHERE PAR_NOM = ''IDGENERATEUR''' + 'AND PRM_TYPE = 22 ' + 'AND PRM_CODE = 4 ';
    queTmp.Open;

    if queTmp.IsEmpty then
    begin
      raise Exception.Create('Pas de paramètre du nombre de sauvegardes trouvé');
    end;

    aNbSave := queTmp.FieldByName('PRM_INTEGER').AsLargeInt;

    queTmp.Close;
    Result := true;
  except
    on E: Exception do
      Log.Log('', 'getNbSave', 'Log', E.Message, logWarning);
  end;

end;
//------------------------------------------------------------------------------

function TFrm_Main.getVersion(var aVersion: string): boolean;
begin
  Result := false;

  try
    queTmp.Close;
    queTmp.SQL.Text := 'Select VER_VERSION FROM GENVERSION ' + 'WHERE VER_DATE IN (SELECT Max(VER_DATE) FROM GENVERSION)';
    queTmp.Open;

    if queTmp.IsEmpty then
    begin
      raise Exception.Create('Aucun résultat');
    end;

    aVersion := queTmp.FieldByName('VER_VERSION').AsString;

    queTmp.Close;
    Result := true;
  except
    on E: Exception do
      Log.Log('', 'getVersion', 'Log', E.Message, logError);
  end;
end;
//------------------------------------------------------------------------------

function TFrm_Main.getSynchroGUID(): Boolean;
begin
  Result := false;
  try
    queTmp.Close;
    queTmp.SQL.Text := 'SELECT BAS_GUID ' + 'FROM genbases ' + 'JOIN k on (K_ID = BAS_ID AND K_ENABLED=1) ' + 'JOIN genparambase ON (BAS_IDENT = PAR_STRING) ' + 'WHERE PAR_NOM = ''IDGENERATEUR''';
    queTmp.Open;

    if queTmp.IsEmpty then
    begin
      raise Exception.Create('Aucun résultat');
    end
    else
    begin
      Result := true;
      FSynchroBasGuid := queTmp.FieldByName('BAS_GUID').AsString;
    end;

    queTmp.Close;
  except
    on E: Exception do
      Log.Log('', 'getSynchroGUID', 'Log', E.Message, logError);
  end;
end;
//------------------------------------------------------------------------------

function TFrm_Main.getGeneralId: Int64;
begin
  Result := 0;

  queTmp.SQL.Text := 'SELECT GEN_ID(GENERAL_ID, 0) FROM RDB$DATABASE';
  queTmp.open;

  if queTmp.IsEmpty then
    Exit;
  Result := queTmp.FieldByName('GEN_ID').AsLargeInt;
  queTmp.Close;
end;
//------------------------------------------------------------------------------

function TFrm_Main.getLastKrhId(aGeneralId: Int64): Int64;
begin
  Result := 0;
  queTmp.Close;

  // Get MAX KRH_ID
  queTmp.SQL.Text := 'SELECT MAX(KRH_ID) FROM K ' + 'WHERE KRH_ID <= :KID ' + 'AND KTB_ID NOT IN (-11111321, -11111492, -11111338, -11111468, -11111646)';
  queTmp.ParamByName('KID').AsLargeInt := aGeneralId;
  queTmp.Open;
  if queTmp.IsEmpty then
    Exit;

  Result := queTmp.FieldByName('MAX').AsLargeInt;
  queTmp.Close;
end;
//------------------------------------------------------------------------------

function TFrm_Main.getInterbasePath: string;
var
  vReg: TRegistry;
  vPath: string;
begin
  vPath := '';
  try
    vReg := Tregistry.Create;
    try
      vReg.Access := KEY_READ;
      vReg.RootKey := HKEY_LOCAL_MACHINE;
      vReg.OpenKey('\Software\Borland\Interbase\CurrentVersion', False);
      vPath := Trim(AddASlash(vReg.ReadString('ServerDirectory')));

      if vPath = '' then
      begin
        vReg.OpenKey('\Software\Borland\Interbase\Servers\gds_db', False);
        vPath := AddASlash(vReg.ReadString('ServerDirectory'));
      end;
    finally
      FreeAndNil(vReg);
    end;
  except
    on E: Exception do
      Log.Log('', 'Log', 'getInterbasePath', E.Message, logError);
  end;

  Result := vPath;
end;
//------------------------------------------------------------------------------

function TFrm_Main.ExtractVersionArchive(aArchive, aVersion, aDest: string; var aMajVersion: boolean): boolean;
var
  Zip: I7zInArchive;
  ia: integer;
  vStream: TStringStream;
  vVersion: string;
  vVerComp: integer;
begin
  Result := False;
  aMajVersion := false;
  try
    if not FileExists(aArchive) then
    begin
      Log.Log('Synchro', 'ExtractVersionArchive', 'Log', 'Archive non trouvée' + aArchive, logWarning, true, 0, ltLocal);
      Exit;
    end;

    Zip := CreateInArchive(CLSID_CFormatZip);
    Zip.OpenFile(aArchive);

    // Check Version
    for ia := 0 to Zip.NumberOfItems - 1 do
    begin
      if Zip.ItemPath[ia] = 'version.txt' then
      begin
        vStream := TStringStream.Create;
        Zip.ExtractItem(ia, vStream, false);
        vVersion := Trim(vStream.DataString);
        vStream.Free;
        break;
      end;
    end;

    vVerComp := compareVersionString(vVersion, aVersion);

    if (vVerComp = -1) then         // Version de l'archive inférieure
    begin
      Log.Log('Synchro', 'ExtractVersionArchive', 'Log', 'Le version de l''archive est inférieure. Archive :' + vVersion + ' / Local : ' + aVersion, logWarning, true, 0, ltLocal);
      Exit;
    end;

    if (vVerComp = 1) then         // Version de l'archive inférieure
    begin
      aMajVersion := true;
      Log.Log('Synchro', 'ExtractVersionArchive', 'Log', 'Le version de l''archive est supérieure. Archive :' + vVersion + ' / Local : ' + aVersion, logNotice, true, 0, ltLocal);
    end;

    // Extract All
    Zip.ExtractTo(aDest);
    Zip.Close;

    Result := true;
  except
    on E: Exception do
      Log.Log('Synchro', 'ExtractVersionArchive', 'Log', 'Erreur lors de l''extraction de l''archive : ' + e.message, logWarning, true, 0, ltLocal);
  end;
end;
//------------------------------------------------------------------------------

procedure TFrm_Main.ApplicationEvents1Exception(Sender: TObject; E: Exception);
begin
  Log.Log('Synchro', 'Application', 'Log', 'Exception : ' + E.message, logError, true, 0, ltLocal);
  MessageDlg(E.Message, mterror, [mbok], 0);
end;
//------------------------------------------------------------------------------

procedure TFrm_Main.FormActivate(Sender: TObject);
begin
end;
//------------------------------------------------------------------------------

procedure TFrm_Main.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if FRunning then
  begin
    CanClose := false;
    Exit;
  end;
end;
//------------------------------------------------------------------------------

procedure TFrm_Main.FormCreate(Sender: TObject);
var
  ia: integer;
begin
  Log.App := 'SynchroPortable';
  Log.Inst := '';
  Log.Srv := '';
  Log.Doss := '';
  Log.FileLogFormat := [elDate, elMdl, elRef, elKey, elLevel, elNb, elValue];
  Log.OnLog := Log_onLog;

  if Log.LogKeepDays = 1 then
    Log.LogKeepDays := 7;

  Log.Open;
  Log.saveIni;

  FUserRequest := false;

  FSynchroServers := TObjectList<TSynchroServer>.Create;
  FSynchroItems := TSynchroItems.Create;
end;
//------------------------------------------------------------------------------

procedure TFrm_Main.FormDestroy(Sender: TObject);
begin
  FSynchroItems.Free;
  FSynchroServers.Free;
end;
//------------------------------------------------------------------------------

procedure TFrm_Main.FormShow(Sender: TObject);
begin
  doInit();
  doProcess(false);
end;
//------------------------------------------------------------------------------

procedure TFrm_Main.Log_onLog(Sender: TObject; aLogItem: TLogItem);
var
  sa: string;
begin
  if aLogItem.key = 'Log' then
  begin
    memoLogs.Lines.BeginUpdate;
    try
      sa := Log.FormatLogItem(aLogItem, [elDate, elValue, elLevel]);

      memoLogs.SelAttributes.Color := LogLevelColor[Ord(aLogItem.lvl)];
      memoLogs.Lines.Add(sa);

      while memoLogs.Lines.Count > 1000 do
      begin
        memoLogs.Lines.Delete(0);
      end;
    finally
      memoLogs.Lines.EndUpdate;
    end;

    memoLogs.SelStart := Length(memoLogs.Text);
  end;

end;
//------------------------------------------------------------------------------

procedure TFrm_Main.processParameters;
var
  ia: integer;
  sa: string;
begin
  FGinkoiaPath := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));

  for ia := 1 to ParamCount do
  begin
    sa := ParamStr(ia);

    if sa = 'AUTO' then
      FAutoStart := true;

    if pos(':\', sa) > 0 then
    begin
      FAutoStart := true;
      edBaseLocale.Text := sa;
    end;
  end;
end;
//------------------------------------------------------------------------------

procedure TFrm_Main.doInit;
begin
  FInit := false;
  FRunning := false;

  try
    Log.Log('', 'doInit', 'Log', 'Initialisation', logNotice);

    readIni;
    processParameters;

    // on force le lancement en mode administrateur pour avoir les droits de lancer les exes / arrêter les services
    LaunchAsAdministrator();

    FInterbasePath := getInterbasePath;
    if FInterbasePath = '' then
      Exit;

    FLocalBaseStatus := logDebug;
    FSyncBaseStatus := logDebug;
    FSelectedServer := '';

    FInit := true;
    Log.Log('', 'doInit', 'Log', 'Initialisation terminée', logInfo, true, 0, ltLocal);
  except
    on E: Exception do
      Log.Log('', 'doInit', 'Log', 'Initialisation impossible : ' + E.Message, logError, true, 0, ltLocal);
  end;
end;
//------------------------------------------------------------------------------

procedure TFrm_Main.readIni;
var
  iniFile: TIniFile;
begin
  iniFile := TIniFile.Create(changeFileExt(paramStr(0), '.ini'));
  try
    // read
    FAllowMultiMag := iniFile.ReadBool('MultiMag', 'Enable', false);
    FSupprFicRequete := iniFile.ReadBool('SupprFicRequete', 'Enable', True);

    // write
    iniFile.WriteBool('MultiMag', 'Enable', FAllowMultiMag);
    iniFile.WriteBool('SupprFicRequete', 'Enable', FSupprFicRequete);
  finally
    iniFile.Free;
  end;
end;
//------------------------------------------------------------------------------

procedure TFrm_Main.doProcess(aStart: boolean);
var
  vFinished: boolean;
  testauto, testuserrequest, testfinished: Boolean;
  testtypesynchro: TTypeSynchro;
begin
  if not FInit then
    Exit;
  FRunning := true;
  vFinished := false;

  FSyncBaseStatus := logDebug;
  FSynchroStatus := logDebug;
  FVersionStatus := logDebug;

  updateLocalBaseStatus;

  TThreadProc.RunInThread(
    procedure
    begin
      // Check Local Base
      try
        if not checkLocalBase then
          Exit;
        if not checkSyncBase then
          Exit;

        if aStart or (FAutoStart and not FUserRequest) then
        begin
          try
            if not doSynchro then
              Exit;
            if not doVersion then
              Exit;

          finally
            doRestartApp;
          end;

          Log.Log('Restart', 'doRestartApp', 'Log', 'Synchronisation terminée avec Succès', logInfo, true, 0, ltLocal);
          updateLocalBaseStatus;

          vFinished := true;
        end
        else
        begin
          FSynchroStatus := logWarning;
        end;
      finally
        if FAutoStart then
          sleep(1000);
      end;
    end).whenFinish(
    procedure
    begin
      FRunning := false;
      updateLocalBaseStatus;

//      testauto := FAutoStart;
//      testuserrequest := FUserRequest;
//      testfinished := vFinished;
//      testtypesynchro := FTypeSynchro;

      if FAutoStart and ((not FUserRequest) or vFinished) then
      begin
        Log.Log('Synchro', 'FinTraitement', 'Log', 'Fin du traitement', logInfo, true, 0, ltLocal);

        // si on est sur un portable est que la synchro n'est pas terminée, on ne ferme pas l'interface pour voir l'erreur
        if (vFinished) or (FTypeSynchro <> tsNotebook) then
          Close;
      end;
    end).whenError(
    procedure(aException: Exception)
    begin
      Log.Log('', 'doProcess', 'Log', aException.Message, logError, true, 0, ltLocal);
    end).Run;
end;
//------------------------------------------------------------------------------

function TFrm_Main.doRestartApp: boolean;
begin
  Result := false;
  updateLocalBaseStatus;

  if FAutoStart then
  begin
    Log.Log('Restart', 'doRestartApp', 'Log', 'Relancement du Launcher', logInfo, true, 0, ltLocal);
    RelancerLauncher;
    sleep(5000);
  end;

  // on relance le service du Sabo
  if ServiceWaitStart('', 'GinSaboSvc', 10000) then
    Log.Log('Synchro', 'doSynchro', 'Log', 'Le service du sabo a été démarré.', logInfo, True, 0, ltLocal)
  else
    Log.Log('Synchro', 'doSynchro', 'Log', 'Le service du sabo n''a pas pu être démarré.', logError, True, 0, ltLocal);

  // Debug
//  FVersionStatus := logInfo;
  if FVersionStatus = logInfo then
  begin
    Log.Log('Restart', 'doRestartApp', 'Log', 'Lancement de vérification SPECIFIQUE', logInfo, true, 0, ltLocal);
    if not LancerVerification('SPECIFIQUE', True) then
      Log.Log('Restart', 'doRestartApp', 'Log', 'Lancement de vérification SPECIFIQUE impossible', logError, true, 0, ltLocal);

    Log.Log('Restart', 'doRestartApp', 'Log', 'Lancement de vérification MAJ', logInfo, true, 0, ltLocal);
    if not LancerVerification('MAJ', False) then
      Log.Log('Restart', 'doRestartApp', 'Log', 'Lancement de vérification MAJ impossible', logError, true, 0, ltLocal);

    sleep(1000);
  end;
end;
//------------------------------------------------------------------------------

function TFrm_Main.doSynchro: boolean;
var
  vLocalGenId: Int64;
  vLocalKrhId: Int64;
  vSyncKrhId: Int64;
  vGenerateurs: TStringList;
  vGenerateursLDF: TGenerateursLDF;
  vGenFile: string;
  vGenFileLDF: TFileName;
  vLastReplic: THistoEvent;
  vReplicOk: THistoEvent;
  vTempBase: string;
  vSyncVersion: string;
  ia: Integer;
  vBackupBase: string;
  vBackupPath: string;
  vTcStart: TDateTime;
  vSyncSize: Int64;
  vDiskFree: Int64;
  vDiskDrive: char;
begin
  vGenerateurs := TStringList.Create();
  try
    Log.Log('Synchro', 'doSynchro', 'Log', 'Démarrage de la synchronisation', logNotice, true, 0, ltLocal);
    FSynchroStatus := logNotice;
    vTcStart := Now;
    updateLocalBaseStatus;

    // Init
    vLocalGenId := 0;
    vLocalKrhId := 0;
    vSyncKrhId := 0;

    FSynchroItems.Clear;

    // on vérifie la taille de la base à récupérer par rapport à l'espace disque disponible, avec une marge de 5Go, si pas assez de place on avertit
    Log.Log('Synchro', 'doSynchro', 'Log', 'Verification de l''espace disponible', logInfo, true, 0, ltLocal);
    vSyncSize := Ceil(FileSize(FSyncBase) / (power(1024, 2)));
    vDiskFree := Floor(EspaceDisque(ExtractFileDrive(FLocalBase), tedLibre, tuoMoctet));
    if (vDiskFree - vSyncSize) < 5000 then
    begin
      Log.Log('Synchro', 'doSynchro', 'Log', 'Espace disponible insuffisant pour synchroniser.', logError, true, 0, ltLocal);
      FSyncBaseStatus := logError;
      Exit;
    end;

    // Connexion à la base locale
    Log.Log('Synchro', 'doSynchro', 'Log', 'Connexion à la base locale', logInfo, true, 0, ltLocal);
    if not connectDatabase(FLocalBase) then
    begin
      Log.Log('Synchro', 'doSynchro', 'Log', 'Connexion à la base locale impossible', logError, true, 0, ltLocal);
      FSynchroStatus := logError;
      Exit;
    end;

    setHistoEvent(CSYNCHROOK, now, False, 0, FLocalBasId);

    // General ID
    Log.Log('Synchro', 'doSynchro', 'Log', 'Récuperation des valeurs de la base', logInfo, true, 0, ltLocal);
    vLocalGenId := getGeneralId;

    // KrhId ;
    if (FTypeSynchro = tsCaisse) then
    begin
      vLocalKrhId := getLastKrhId(vLocalGenId);
    end;

    Log.Log('Synchro', 'doSynchro', 'Log', 'Récupération des générateurs de la base', logInfo, true, 0, ltLocal);
    // Recuperation des générateurs
    if not RecupererGenerateurs(vGenerateurs) then
    begin
      Log.Log('Synchro', 'doSynchro', 'Log', 'Impossible de récupérer les générateurs', logError, true, 0, ltLocal);
      FSynchroStatus := logError;
      Exit;
    end;
    vGenFile := FGinkoiaPath + 'Synchro_Generateurs_' + FormatDateTime('yyyy-mm-dd_hhnnss', Now) + '.sql';

    try
      vGenerateurs.SaveToFile(vGenFile);
    except
      Log.Log('Synchro', 'doSynchro', 'Log', 'Impossible d''enregistrer les générateurs', logWarning, true, 0, ltLocal);
    end;

    {DONE 1 -oLP -cCode:Récupérer les générateurs LDF}
    // Récupération des générateurs LDF
    if not (RecupererGenerateursLDF(vGenerateursLDF, FLocalBasId)) then
    begin
      Log.Log('Synchro', 'doSynchro', 'Log', 'Impossible de récupérer les générateurs LDF', logError, true, 0, ltLocal);
      FSynchroStatus := logError;
      Exit;
    end;
    vGenFileLDF := FGinkoiaPath + 'Synchro_GenerateursLDF_' + FormatDateTime('yyyy-mm-dd_hhnnss', Now) + '.dat';

    try
      SauvegardeGenerateursLDF(vGenerateursLDF, vGenFileLDF);
    except
      on E: Exception do
      begin
        Log.Log('Synchro', 'doSynchro', 'Log', 'Impossible d''enregistrer les générateurs LDF', logError, True, 0, ltLocal);
        FSynchroStatus := logError;
        Exit;
      end;
    end;

    // Recuperation de la dernière replication
    vLastReplic := getHistoEvent(CLASTREPLIC, FLocalBasId);
    vReplicOk := getHistoEvent(CREPLICATIONOK, FLocalBasId);

    Log.Log('Synchro', 'doSynchro', 'Log', 'Récupération de la base de synchro', logInfo, true, 0, ltLocal);
    vTempBase := FLocalBasePath + 'Synchro_' + FormatDateTime('yyyy-mm-dd', Date) + ExtractFileExt(FSyncBase);
    if not CopierFichier(FSyncBase, vTempBase,
  procedure(aPourcent: integer; aText: string)
  begin
    FProgressVal := aPourcent;
    FProgressText := aText;
    TThread.Synchronize(nil, updateProgressSynchro);
  end) then
    begin
      Log.Log('Synchro', 'doSynchro', 'Log', 'Impossible de récupérer la base de synchro', logError, true, 0, ltLocal);
      FSynchroStatus := logError;
      Exit;
    end;

    try
      closeDatabase;

      // Connexion à la base de synchro
      if not connectDatabase(vTempBase) then
      begin
        Log.Log('Synchro', 'doSynchro', 'Log', 'Connexion à la base de syncro impossible', logError, true, 0, ltLocal);
        FSynchroStatus := logError;
        Exit;
      end;

      // Verification de la base de synchro
      Log.Log('Synchro', 'doSynchro', 'Log', 'Vérification de la base de synchro', logInfo, true, 0, ltLocal);
      if FTypeSynchro = tsCaisse then
      begin
        vSyncKrhId := getLastKrhId(vLocalGenId);

        if (vLocalKrhId > vSyncKrhId) then                                        // Tout n'a pas été remonté en replication
        begin
          if not connectDatabase(FLocalBase) then
          begin
            Log.Log('Synchro', 'doSynchro', 'Log', 'Connexion à la base locale impossible', logError, true, 0, ltLocal);
            FSynchroStatus := logError;
            Exit;
          end;
          try
            checkKrhDifferences(vSyncKrhId, vLocalKrhId);
          finally
            closeDatabase;
          end;

          if not connectDatabase(vTempBase) then
          begin
            Log.Log('Synchro', 'doSynchro', 'Log', 'Connexion à la base de synchro impossible', logError, true, 0, ltLocal);
            FSynchroStatus := logError;
            Exit;
          end;

          try
            if not compareKrhDifferences then
            begin
              Log.Log('Synchro', 'doSynchro', 'Log', 'Les données de la base locale ne sont pas redescendues dans la base de synchro.', logError, true, 0, ltLocal);
              FSynchroStatus := logError;
              Exit;
            end;
          finally
            logKrhDifferences;
            closeDatabase;
          end;
        end;
      end;

      // Version de la base de synchro
      if not getVersion(vSyncVersion) then
      begin
        Log.Log('Synchro', 'doSynchro', 'Log', 'Impossible de récupérer la version de la base de synchro', logError, true, 0, ltLocal);
        FSynchroStatus := logError;
        Exit;
      end;

      // récupération du GUID du serveur avant mise à jour de la base de synchro
      if not getSynchroGUID() then
      begin
        Log.Log('Synchro', 'checkSynchroBase', 'Log', 'Récupération des information de GUID dans la base de synchro impossible', logError, true, 0, ltLocal);
        FLocalBaseStatus := logError;
        Exit;
      end;

      Log.Log('Synchro', 'doSynchro', 'Log', 'Reconfiguration de la base de synchro', logInfo, true, 0, ltLocal);
      // Reconfiguration de la base
      if not reconfigureBase(vGenerateurs) then
      begin
        Log.Log('Synchro', 'doSynchro', 'Log', 'Impossible de reconfigurer la base de synchro', logError, true, 0, ltLocal);
        FSynchroStatus := logError;
        Exit;
      end;

      if FSupprFicRequete then
      begin
        try
          DeleteFile(vGenFile);
        except
          on E: Exception do
            Log.Log('Synchro', 'doSyncro', 'Log', 'Suppression du fichier de générateurs impossible', logWarning, true, 0, ltLocal);
        end;
      end;

      {DONE 1 -oLP -cCode:Traiter les générateurs LDF}
      // Remise en place des générateurs LDF
      if not (ReconfigGenerateursLDF(vGenerateursLDF, FLocalBasId, ChangeFileExt(vGenFileLDF, '.sql'))) then
      begin
        Log.Log('Synchro', 'doSynchro', 'Log', 'Impossible de remettre en place des générateurs LDF', logError, true, 0, ltLocal);
        FSynchroStatus := logError;
        Exit;
      end;

      if FSupprFicRequete then
      begin
        try
          DeleteFile(vGenFileLDF);
          DeleteFile(ChangeFileExt(vGenFileLDF, '.sql'));
        except
          on E: Exception do
            Log.Log('Synchro', 'doSyncro', 'Log', 'Suppression du fichier de générateurs LDF impossible', logWarning, true, 0, ltLocal);
        end;
      end;

      // Ajout des Events
      setHistoEvent(CREPLICATIONOK, vReplicOk.Date, vReplicOk.Ok, vReplicOk.Time, FLocalBasId);
      setHistoEvent(CLASTREPLIC, vLastReplic.Date, vLastReplic.Ok, vLastReplic.Time, FLocalBasId);

      closeDatabase;

      Log.Log('Synchro', 'doSynchro', 'Log', 'Arrêt des applications', logInfo, true, 0, ltLocal);

      KillProcessus('CaisseGinkoia.exe');
      Sleep(500);

      KillProcessus('Ginkoia.exe');
      Sleep(500);

      KillProcessus('LaunchV7.exe');
      Sleep(500);

      KillProcessus('Caisse.exe');  // caisse Cash
      Sleep(500);

      KillApp.Load;
      for ia := 0 to KillApp.Count - 1 do
      begin
        KillProcessus(KillApp.List[ia]);
        Sleep(500);
      end;

      // arret du service du Sabo
      if ServiceWaitStop('', 'GinSaboSvc', 10000) then
      begin
        Log.Log('Synchro', 'doSynchro', 'Log', 'Le service du sabo a été arrêté.', logInfo, True, 0, ltLocal)
      end
      else
        Log.Log('Synchro', 'doSynchro', 'Log', 'Le service du sabo n''a pas pus être arrêté.', logError, True, 0, ltLocal);


      Sleep(10000);

      Log.Log('Synchro', 'doSynchro', 'Log', 'Arrêt de la base locale', logInfo, true, 0, ltLocal);
      if not ArreterBase(FLocalBase) then
      begin
        Log.Log('Synchro', 'doSynchro', 'Log', 'Arrêt de la base locale impossible', logWarning, true, 0, ltLocal);
        FSynchroStatus := logError;
        Exit;
      end;

      FSynchroStatus := logNotice;

      try
        Log.Log('Synchro', 'doSynchro', 'Log', 'Sauvegarde de la base locale', logInfo, true, 0, ltLocal);
        vBackupPath := FLocalBasePath + 'Backup\';
        vBackupBase := vBackupPath + ChangeFileExt(ExtractFileName(FLocalBase), '.toto');
        ForceDirectories(vBackupPath);

        if FileExists(vBackupBase) then
          DeleteFile(vBackupBase);

        if not BackupBase(FLocalBase, vBackupPath, vBackupBase) then
        begin
          Log.Log('Synchro', 'doSynchro', 'Log', 'Sauvegarde de la base locale impossible', logError, true, 0, ltLocal);
          FSynchroStatus := logError;
          Exit;
        end;

        Log.Log('Synchro', 'doSynchro', 'Log', 'Mise en place de la base de synchro', logInfo, true, 0, ltLocal);
        if not RenameFile(vTempBase, FLocalBase) then
        begin
          Log.Log('Synchro', 'doSynchro', 'Log', 'Echec de la mise en place de la base', logError, true, 0, ltLocal);
          FSynchroStatus := logError;

          Log.Log('Synchro', 'doSynchro', 'Log', 'Récupération de l''ancienne base', logInfo, true, 0, ltLocal);
          if not RenameFile(vBackupBase, FLocalBase) then
          begin
            Log.Log('Synchro', 'doSynchro', 'Log', 'Echec de récupération de l''ancienne base. Contactez Ginkoia.', logError, true, 0, ltLocal);
          end;

          Exit;
        end;

        if not FileExists(FLocalBase) then
        begin
          Log.Log('Synchro', 'doSynchro', 'Log', 'Echec de la mise en place de la base. Contactez Ginkoia', logError, true, 0, ltLocal);
          FSynchroStatus := logError;
          Exit;
        end;

      finally
        Log.Log('Synchro', 'doSynchro', 'Log', 'Démarrage de la base', logNotice, true, 0, ltLocal);
        if not DemarrerBase(FLocalBase) then
        begin
          Log.Log('Synchro', 'doSynchro', 'Log', 'Erreur lors du démarrage de la base. Contactez Ginkoia', logError, true, 0, ltLocal);
          FSynchroStatus := logError;
        end
        else
        begin
          Log.Log('Synchro', 'doSynchro', 'Log', 'Base démarrée', logInfo, true, 0, ltLocal);
        end;
      end;

      Log.Log('Synchro', 'doSynchro', 'Log', 'Base de synchro mise en place avec succès', logInfo, true, 0, ltLocal);
    finally
      closeDatabase;
      DeleteFile(vTempBase);
    end;

    Log.Log('Synchro', 'doSynchro', 'Log', 'Attente d''Interbase ...', logInfo, true, 0, ltLocal);
    sleep(10000);

    Log.Log('Synchro', 'doSynchro', 'Log', 'Finalisation', logNotice, true, 0, ltLocal);
    // Enregistrement des évènements de synchro
    if not connectDatabase(FLocalBase) then
    begin
      Log.Log('Synchro', 'doSynchro', 'Log', 'Impossible de se connecter à la base.', logError, true, 0, ltLocal);
      FSynchroStatus := logError;
      Exit;
    end;

    // Mise a jour de Yellis
    updateYellis;

    setHistoEvent(CLASTSYNC, Now, True, 0, FLocalBasId);
    setHistoEvent(CSYNCHROOK, Now, True, 0, FLocalBasId);

    closeDatabase;

    if FTypeSynchro = tsCaisse then
    begin
      Log.Log('Synchro', 'doSynchro', 'Log', 'Transfert de la FidBox', logNotice, true, 0, ltLocal);
      transfertFidBox(FLocalBasePath, FSyncBasePath);
    end;

    FSynchroStatus := logInfo;
    Result := true;
  finally
    vGenerateurs.Free();
  end;
end;
//------------------------------------------------------------------------------

procedure TFrm_Main.updateYellis;
var
  vSyncVersion: string;
  vYellis: TConnexion;
  vYRes: TStringList;
  vIdVersion: Integer;
  vNomVersion: string;
  vBasId: Int64;
  vBasIdent: Integer;
  vBasNom: string;
  vBasGuid: string;
  vIdClient: Int64;
  vVersionClient: Integer;
begin
  try
    if not Database.Connected then
    begin
      Log.Log('Synchro', 'updateYellis', 'Log', 'Base de données non connectée', logWarning, true, 0, ltLocal);
      Exit;
    end;

    if not getVersion(vSyncVersion) then
    begin
      Log.Log('Synchro', 'updateYellis', 'Log', 'Récupération de la version impossible', logWarning, true, 0, ltLocal);
      Exit;
    end;

    vSyncVersion := trim(vSyncVersion);
    if vSyncVersion = '' then
    begin
      Log.Log('Synchro', 'updateYellis', 'Log', 'Version non trouvée', logWarning, true, 0, ltLocal);
      Exit;
    end;

    if not getBasId(vBasId, vBasIdent, vBasNom, vBasGuid) then
    begin
      Log.Log('Synchro', 'updateYellis', 'Log', 'Information de base inaccessible', logWarning, true, 0, ltLocal);
      Exit;
    end;

    vBasGuid := trim(vBasGuid);
    if vBasGuid = '' then
    begin
      Log.Log('Synchro', 'updateYellis', 'Log', 'Information de base invalide', logWarning, true, 0, ltLocal);
      Exit;
    end;

    CoInitialize(nil);
    vIdVersion := 0;
    vYellis := Tconnexion.create;
    try
      // recuperation de la version Yellis
      vIdVersion := 0;
      vNomVersion := '';
      vYRes := vYellis.Select('select * FROM version WHERE version="' + vSyncVersion + '"');
      try
        if vYellis.recordCount(vYRes) > 0 then
        begin
          vIdVersion := vYellis.UneValeurEntiere(vYRes, 'id', 0);
          vNomVersion := vYellis.UneValeur(vYRes, 'nomversion');
        end;
      finally
        vYRes.Free;
      end;

      if vIdVersion = 0 then
      begin
        Log.Log('Synchro', 'updateYellis', 'Log', 'Version Yellis non trouvée', logWarning, true, 0, ltLocal);
        Exit;
      end;

      Log.Log('Synchro', 'updateYellis', 'Log', 'Version Yellis : ' + vNomVersion, logInfo, true, 0, ltLocal);

      // Récupération des infos client
      vIdClient := 0;
      vVersionClient := 0;
      vYRes := vYellis.Select('select * FROM clients WHERE clt_GUID="' + vBasGuid + '"');
      try
        if vYellis.recordCount(vYRes) > 0 then
        begin
          vIdClient := vYellis.UneValeurEntiere(vYRes, 'id', 0);
          vVersionClient := vYellis.UneValeurEntiere(vYRes, 'version', 0);
        end;
      finally
        vYRes.Free;
      end;

      if vIdClient = 0 then
      begin
        Log.Log('Synchro', 'updateYellis', 'Log', 'Client Yellis non trouvé' + vNomVersion, logWarning, true, 0, ltLocal);
        Exit;
      end;

      // Mise a jour de Yellis
      if not vYellis.ordre('update clients set version=' + IntToStr(vIdVersion) + ', version_max=0, patch=-1, spe_fait=-1 WHERE id=' + IntToStr(vIdClient)) then
      begin
        Log.Log('Synchro', 'updateYellis', 'Log', 'Yellis n''a pas pu être mis à jour', logWarning, true, 0, ltLocal);
        Exit;
      end;

      Log.Log('Synchro', 'updateYellis', 'Log', 'Yellis a été mis à jour', logInfo, true, 0, ltLocal);

    finally
      vYellis.free;
    end;
  except
    on E: Exception do
      Log.Log('Synchro', 'updateYellis', 'Log', E.Message, logError, true, 0, ltLocal);
  end;
end;
//------------------------------------------------------------------------------

procedure TFrm_Main.transfertFidBox(aSourcePath, aDestPath: string);
var
  vSourcePath: string;
  vDestPath: string;
  vPos: Integer;
  vSearchRec: TSearchRec;
  vFileList: TStringList;
  ia: integer;
  vLocalFile: string;
  vRemoteFile: string;
  vHasError: boolean;
begin
  vSourcePath := '';
  vDestPath := '';

  vPos := Pos('\data\', lowercase(aSourcePath));
  if vPos > 0 then
    vSourcePath := IncludeTrailingPathDelimiter(copy(aSourcePath, 1, vPos + 5));

  vPos := Pos('\data\', lowercase(aDestPath));
  if vPos > 0 then
    vDestPath := IncludeTrailingPathDelimiter(copy(aDestPath, 1, vPos + 5));

  Log.Log('Synchro', 'doSynchro', 'Log', 'Répertoire local   : ' + vSourcePath, logDebug);
  Log.Log('Synchro', 'doSynchro', 'Log', 'Répertoire serveur : ' + vDestPath, logDebug);

  if (vSourcePath = '') or (vDestPath = '') then
  begin
    Log.Log('Synchro', 'doSynchro', 'Log', 'Impossible de trouver les répertoire de la FidBox', logWarning, true, 0, ltLocal);
    Exit;
  end;

  vSourcePath := vSourcePath + 'FidBox\';
  vDestPath := vDestPath + 'FidBox\';

  if not DirectoryExists(vSourcePath) then
  begin
    Log.Log('Synchro', 'doSynchro', 'Log', 'Impossible de trouver les répertoire local de la FidBox', logWarning, true, 0, ltLocal);
    Exit;
  end;

  if not DirectoryExists(vDestPath) then
  begin
    Log.Log('Synchro', 'doSynchro', 'Log', 'Impossible de trouver les répertoire serveur de la FidBox', logWarning, true, 0, ltLocal);
    Exit;
  end;

  vFileList := TStringList.Create;

  if FindFirst(vSourcePath + '*.txt', faAnyFile, vSearchRec) = 0 then
  begin
    repeat
      vFileList.Add(vSearchRec.Name);
    until FindNext(vSearchRec) <> 0;

    FindClose(vSearchRec);
  end;

  if vFileList.Count < 1 then
  begin
    Log.Log('Synchro', 'doSynchro', 'Log', 'Aucun fichier FidBox à synchroniser', logNotice, true, 0, ltLocal);
    Exit;
  end;

  Log.Log('Synchro', 'doSynchro', 'Log', 'Synchronisation de ' + IntToStr(vFileList.Count) + ' fichier(s)', logDebug, true, 0, ltLocal);
  vHasError := false;

  for ia := 0 to vFileList.Count - 1 do
  begin
    vLocalFile := vSourcePath + vFileList.Strings[ia];
    vRemoteFile := vDestPath + ExtractFileName(vLocalFile);

    if FileExists(vRemoteFile) then
    begin
      Log.Log('Synchro', 'doSynchro', 'Log', 'Le fichier FidBox ' + ExtractFileName(vLocalFile) + ' existe déja', logWarning, true, 0, ltLocal);
      vHasError := true;
      Continue;
    end;

    if not CopyFile(PWideChar(vLocalFile), pWideChar(vRemoteFile), true) then
    begin
      Log.Log('Synchro', 'doSynchro', 'Log', 'Le fichier FidBox ' + ExtractFileName(vLocalFile) + ' n''a ps pu être copié', logWarning, true, 0, ltLocal);
      vHasError := true;
      Continue;
    end;

    DeleteFile(vLocalFile);
  end;

  vFileList.Free;

  if not vHasError then
    Log.Log('Synchro', 'doSynchro', 'Log', 'Synchronisation FidBox terminée.', logInfo, true, 0, ltLocal)
  else
    Log.Log('Synchro', 'doSynchro', 'Log', 'Synchronisation FidBox terminée avec des erreurs.', logWarning, true, 0, ltLocal)
end;
//------------------------------------------------------------------------------

procedure TFrm_Main.checkKrhDifferences(aFrom, aTo: Int64);
var
  vSynchroItem: TSynchroItem;
begin
  queTmp.Close;
  queTmp.SQL.Text := 'SELECT K.KRH_ID, K.K_ID, K.KTB_ID, KTB.KTB_NAME, K.K_ENABLED, K.K_UPDATED, K.K_DELETED FROM K ' + 'JOIN KTB ON KTB.KTB_ID = K.KTB_ID ' + 'WHERE KRH_ID > :FROM AND KRH_ID <= :TO ' + 'AND K.KTB_ID NOT IN (-11111321, -11111492, -11111338, -11111468, -11111535, -11111709) ' + 'ORDER BY KRH_ID DESC ' + 'ROWS 50';
  queTmp.ParamByName('FROM').AsLargeInt := aFrom;
  queTmp.ParamByName('TO').AsLargeInt := aTo;
  queTmp.Open;

  Log.Log('', 'logKrhDifferences', 'Log', 'KRH Local   : ' + IntToStr(aTo), logTrace);
  Log.Log('', 'logKrhDifferences', 'Log', 'KRH Synchro : ' + IntToStr(aFrom), logTrace);

  while not queTmp.Eof do
  begin
    vSynchroItem := TSynchroItem.Create;
    vSynchroItem.Id := queTmp.FieldByName('K_ID').AsLargeInt;
    vSynchroItem.krh_id := queTmp.FieldByName('KRH_ID').AsLargeInt;
    vSynchroItem.ktb_id := queTmp.FieldByName('KTB_ID').AsLargeInt;
    vSynchroItem.Table := queTmp.FieldByName('KTB_NAME').AsString;

    if queTmp.FieldByName('K_ENABLED').AsInteger = 1 then
      vSynchroItem.k_dte := queTmp.FieldByName('K_UPDATED').AsDateTime
    else
      vSynchroItem.k_dte := queTmp.FieldByName('K_DELETED').AsDateTime;

    vSynchroItem.ok := false;
    vSynchroItem.found := false;
    FSynchroItems.Add(vSynchroItem);
    queTmp.Next;
  end;

  queTmp.Close;
end;
//------------------------------------------------------------------------------

function TFrm_Main.compareKrhDifferences: boolean;
var
  vSynchroItem: TSynchroItem;
  vDte: TDateTime;
  vKtbId: Int64;
begin
  queTmp.Close;

  for vSynchroItem in FSynchroItems do
  begin
    queTmp.SQL.Text := 'SELECT K_ID, KRH_ID, KTB_ID, K_ENABLED, K_UPDATED, K_DELETED FROM K ' + 'WHERE K_ID = :K_ID';
    queTmp.ParamByName('K_ID').AsLargeInt := vSynchroItem.Id;
    queTmp.Open;

    if not queTmp.IsEmpty then
    begin
      vSynchroItem.found := true;

      if queTmp.FieldByName('K_ENABLED').AsInteger = 1 then
        vDte := queTmp.FieldByName('K_UPDATED').AsDateTime
      else
        vDte := queTmp.FieldByName('K_DELETED').AsDateTime;

      vKtbId := queTmp.FieldByName('KTB_ID').AsLargeInt;

      if (vKtbId = vSynchroItem.ktb_id) and (vDte >= vSynchroItem.k_dte) then
      begin
        vSynchroItem.ok := true;
      end;
    end;
  end;

  Result := true;
  for vSynchroItem in FSynchroItems do
  begin
    if vSynchroItem.ok = false then
      Result := False;
  end;
end;
//------------------------------------------------------------------------------

procedure TFrm_Main.logKrhDifferences;
var
  vSynchroItem: TSynchroItem;
begin
  for vSynchroItem in FSynchroItems do
  begin
    if vSynchroItem.found then
    begin
      if vSynchroItem.ok then
        Log.Log('', 'logKrhDifferences', 'Log', 'Mis à jour  : ' + vSynchroItem.Table + ' / ' + IntToStr(vSynchroItem.Id), logWarning, true, 0, ltLocal)
      else
        Log.Log('', 'logKrhDifferences', 'Log', 'Périmé      : ' + vSynchroItem.Table + ' / ' + IntToStr(vSynchroItem.Id), logError, true, 0, ltLocal)
    end
    else
    begin
      Log.Log('', 'logKrhDifferences', 'Log', 'Absent      : ' + vSynchroItem.Table + ' / ' + IntToStr(vSynchroItem.Id), logError, true, 0, ltLocal)
    end;
  end;
end;
//------------------------------------------------------------------------------

function TFrm_Main.doVersion: boolean;
var
  vMajVersion: Boolean;
begin
  Result := false;

  FVersionStatus := logNotice;
  updateLocalBaseStatus;

  Log.Log('Version', 'doVersion', 'Log', 'Mise à jour de la version', logNotice, true, 0, ltLocal);

  if FileExists(FSyncBasePath + 'Version.zip') then
  begin
    Log.Log('Version', 'doVersion', 'Log', 'Transfert de l''archive ' + FSyncBasePath + 'Version.zip', logInfo, true, 0, ltLocal);

    if CopierFichier(FSyncBasePath + 'Version.zip', FLocalBasePath + 'Version.zip',
      procedure(aPourcent: Integer; aText: string)
      begin
        FProgressVal := aPourcent;
        FProgressText := aText;
        TThread.Synchronize(nil, updateProgressVersion);
      end) then
    begin
      Log.Log('Version', 'doVersion', 'Log', 'Extraction de l''archive', logInfo, true, 0, ltLocal);

      if ExtractVersionArchive(FLocalBasePath + 'Version.zip', FLocalVersion, FGinkoiaPath + 'A_MAJ\', vMajVersion) then
      begin
        if vMajVersion then
          Log.Log('Version', 'doVersion', 'Log', 'Version MAJEURE extraite', logNotice)
        else
          Log.Log('Version', 'doVersion', 'Log', 'Version extraite', logInfo);
      end
      else
      begin
        Log.Log('Version', 'doVersion', 'Log', 'Erreur lors de l''extraction de la version', logError, true, 0, ltLocal);
        FVersionStatus := logError;
        Result := false;
      end;
    end
    else
    begin
      Log.Log('Version', 'doVersion', 'Log', 'Erreur lors de la copie de l''archive', logError, true, 0, ltLocal);
      FVersionStatus := logError;
      Exit;
    end;
  end
  else
  begin
    Log.Log('Version', 'doVersion', 'Log', 'Archive de version inexistante', logWarning, true, 0, ltLocal);
    FVersionStatus := logWarning;
    Exit;
  end;

  if vMajVersion then
  begin
    if FileExists(FGinkoiaPath + 'A_MAJ\Liveupdate\SYNCHRO.ALG') then
    begin
      Log.Log('Version', 'doVersion', 'Log', 'Execution des ALG', logNotice, true, 0, ltLocal);
      if not LancerVerification('ALG ' + FGinkoiaPath + 'A_MAJ\Liveupdate\SYNCHRO.ALG', true) then
        Log.Log('Version', 'doVersion', 'Log', 'Execution des ALG impossible', logWarning, true, 0, ltLocal);
    end
    else
    begin
      Log.Log('Version', 'doVersion', 'Log', 'Aucun ALG à executer', logNotice, true, 0, ltLocal);
    end;
  end;

  Log.Log('Version', 'doVersion', 'Log', 'Finalisation', logNotice, true, 0, ltLocal);
  if FileExists(FLocalBasePath + 'Version.zip') then
    DeleteFile(FLocalBasePath + 'Version.zip');

  Result := true;
  FVersionStatus := logInfo;
end;
//------------------------------------------------------------------------------

function TFrm_Main.getHistoEvent(aType: Integer; aBasId: Int64): THistoEvent;
begin
  try
    Result.Date := 0;
    Result.Module := '';
    Result.Ok := False;
    Result.Time := 0;

    queTmp.Close;
    queTmp.SQL.Text := 'SELECT HEV_DATE, HEV_MODULE, HEV_RESULT, HEV_TEMPS, HEV_TEMPS ' + 'FROM genhistoevt ' + 'JOIN k ON (k_id=hev_id and k_enabled=1) ' + 'JOIN genbases ON (bas_id=hev_basid) ' + 'WHERE HEV_TYPE = :TYPE AND HEV_BASID = :BASID ' + 'ORDER by HEV_DATE DESC ' + 'ROWS 1';
    queTmp.ParamByName('TYPE').asInteger := aType;
    queTmp.ParamByName('BASID').AsLargeInt := aBasId;
    queTmp.Open;

    if not queTmp.IsEmpty then
    begin
      Result.Date := queTmp.FieldByName('HEV_DATE').AsDateTime;
      Result.Module := queTmp.FieldByName('HEV_MODULE').AsString;
      Result.Ok := (queTmp.FieldByName('HEV_RESULT').AsInteger = 1);
      Result.Time := queTmp.FieldByName('HEV_TEMPS').AsDateTime;
    end;
  except
    on E: Exception do
      Log.Log('', 'getHistoEvent', 'Log', E.Message, logError, true, 0, ltLocal);
  end;
end;
//------------------------------------------------------------------------------

function TFrm_Main.setHistoEvent(aType: Integer; aDate: TDateTime; aResult: boolean; aTime: TTime; aBasId: Int64): boolean;
var
  vTrans: TIB_Transaction;
begin
  Result := false;
  try
    vTrans := TIB_Transaction.Create(self);
    try
      queTmp.Close;
      queTmp.IB_Transaction := vTrans;
      queTmp.SQL.Text := 'EXECUTE PROCEDURE EVT_SETHISTO(:DATE, :MODULE, :BASE, :TYPE, :RESULT, :TIME, :BASID)';
      queTmp.ParamByName('DATE').AsDateTime := aDate;
      queTmp.ParamByName('MODULE').AsString := '';
      queTmp.ParamByName('BASE').AsString := Database.DatabaseName;
      queTmp.ParamByName('TYPE').AsInteger := aType;
      queTmp.ParamByName('RESULT').AsInteger := BoolToInt(aResult);
      queTmp.ParamByName('TIME').AsTime := aTime;
      queTmp.ParamByName('BASID').AsLargeInt := aBasId;
      vTrans.StartTransaction;

      try
        queTmp.ExecSQL;
        vTrans.Commit;
        Result := true;
      except
        on E: Exception do
        begin
          Log.Log('', 'setHistoEvent', 'Log', E.Message, logError, true, 0, ltLocal);
          vTrans.Rollback;
        end;
      end;
    finally
      queTmp.IB_Transaction := nil;
      queTMp.Close;
    end;
  except
    on E: Exception do
      Log.Log('', 'setHistoEvent', 'Log', E.Message, logError, true, 0, ltLocal);
  end;
end;
//------------------------------------------------------------------------------

function TFrm_Main.BoolToInt(aBool: Boolean): Integer;
begin
  if aBool then
    Result := 1
  else
    Result := 0;
end;
//------------------------------------------------------------------------------

procedure TFrm_Main.edBaseLocaleChange(Sender: TObject);
begin
  doProcess(false);
end;
//------------------------------------------------------------------------------

procedure TFrm_Main.updateLocalBaseStatus;
begin
  if GetCurrentThreadId <> System.MainThreadID then
  begin
    TThread.Synchronize(nil, updateLocalBaseStatus);
    Exit;
  end;

  edBaseLocale.Enabled := not FRunning;
  btSelectLocalBase.Enabled := not FRunning;
  cbBaseSync.Enabled := not FRunning;
  btnSynchroniser.Enabled := not FRunning;

  labSelectBase.Color := LogLevelColor[Ord(FLocalBaseStatus)];

  lbBasIdent.Caption := IntToStr(FLocalBasIdent);
  lbBasNom.Caption := FLocalBasNom;

  lbVersionVal.Caption := FLocalVersion;
  lbVersionLameVal.Caption := FLameVersion;

  case FTypeSynchro of
    tsNone:
      lbTypeSyncVal.Caption := 'Aucune';
    tsCaisse:
      lbTypeSyncVal.Caption := 'Caisse';
    tsNotebook:
      lbTypeSyncVal.Caption := 'Portable';
  end;

  fillSynchroServerList;

  lbBaseSyncTitle.Color := LogLevelColor[Ord(FSyncBaseStatus)];
  cbBaseSync.ItemIndex := cbBaseSync.Items.IndexOf(FSelectedServer);

  lbTitleSynchro.Color := LogLevelColor[Ord(FSynchroStatus)];
  lbTitleVersion.Color := LogLevelColor[Ord(FVersionStatus)];

end;
//------------------------------------------------------------------------------

procedure TFrm_Main.updateProgressSynchro;
begin
  lbSyncProgress.Caption := FProgressText;
  pbSynchro.Position := FProgressVal;
end;
//------------------------------------------------------------------------------

procedure TFrm_Main.updateProgressVersion;
begin
  lbVersionProgress.Caption := FProgressText;
  pbVersion.Position := FProgressVal;
end;
//------------------------------------------------------------------------------

procedure TFrm_Main.fillSynchroServerList;
var
  aSynchroServer: TSynchroServer;
  vDefaultIdx: integer;
begin
  vDefaultIdx := -1;

  cbBaseSync.Items.BeginUpdate;
  try
    cbBaseSync.Clear;

    for aSynchroServer in FSynchroServers do
    begin
      cbBaseSync.Items.Add(aSynchroServer.Nom);

      if (aSynchroServer.Default) then
      begin
        vDefaultIdx := cbBaseSync.Items.IndexOf(aSynchroServer.Nom);
      end;
    end;

    if vDefaultIdx >= 0 then
    begin
      cbBaseSync.ItemIndex := vDefaultIdx;
    end;
  finally
    cbBaseSync.Items.EndUpdate;
  end;
end;
//------------------------------------------------------------------------------

procedure TFrm_Main.cbBaseSyncSelect(Sender: TObject);
begin
  FSelectedServer := cbBaseSync.Text;
  doProcess(false);
end;
//------------------------------------------------------------------------------

function TFrm_Main.checkLocalBase: boolean;
var
  aSynchroServer: TSynchroServer;
  vNotebookSynchros: TNotebookSynchros;
  vNotebookSynchro: TNotebookSynchro;
  vDefaultServerId: Integer;
begin
  try
    Result := false;

    if (FLocalBase = edBaseLocale.Text) and (FLocalBaseStatus = logInfo) then
    begin
      Result := true;
      Exit;
    end;

    FLocalBaseStatus := logNotice;
    FLocalBase := edBaseLocale.Text;

    updateLocalBaseStatus;
    FSynchroServers.Clear;

    if (FLocalBase = '') then
    begin
      FLocalBaseStatus := logWarning;
      FUserRequest := true;
      Exit;
    end;

    Log.Log('Synchro', 'checkLocalBase', 'Log', 'Vérification de la base locale', logNotice, true, 0, ltLocal);

    if not connectDatabase(FLocalBase) then
    begin
      Log.Log('Synchro', 'checkLocalBase', 'Log', 'Connexion impossible à la base ' + FLocalBase, logError, true, 0, ltLocal);
      FLocalBaseStatus := logError;
      Exit;
    end;
    FLocalBasePath := IncludeTrailingBackslash(ExtractFilePath(FLocalBase));

    Log.Log('Synchro', 'checkLocalBase', 'Log', 'Récupération des paramètres', logInfo, true, 0, ltLocal);
    if not getBasId(FLocalBasId, FLocalBasIdent, FLocalBasNom, FLocalBasGuid) then
    begin
      Log.Log('Synchro', 'checkLocalBase', 'Log', 'Récupération des information impossible', logError, true, 0, ltLocal);
      FLocalBaseStatus := logError;
      Exit;
    end;

    if not getNbSave(FNbSave) then
      FNbSave := 4;
    Log.Log('Synchro', 'checkLocalBase', 'Log', IntToStr(FNbSave) + ' base(s) de données seront conservée(s) en sauvegarde', logInfo, true, 0, ltLocal);

    Log.Log('Synchro', 'checkLocalBase', 'Log', 'Récupération de la version de la base', logInfo, true, 0, ltLocal);
    if not getVersion(FLocalVersion) then
    begin
      Log.Log('Synchro', 'checkLocalBase', 'Log', 'Récupération de la version impossible', logError, true, 0, ltLocal);
      FLocalBaseStatus := logError;
      Exit;
    end;

    Log.Log('Synchro', 'checkLocalBase', 'Log', 'Récupération des paramètres de synchronisation', logInfo, true, 0, ltLocal);
    FTypeSynchro := tsNone;
    FSynchroServers.Clear;

    vDefaultServerId := 0;
    FCaisseSynchro := getCaisseSynchro(FLocalBasId);
    if FCaisseSynchro.Enable and (FCaisseSynchro.Server <> '') then
    begin
      FTypeSynchro := tsCaisse;
      addSynchroServer(0, 'Serveur Magasin', FCaisseSynchro.Server, true);
    end
    else
    begin
      // ancien mode
      FNotebookSynchro := getNotebookSynchro(FLocalBasId);
      if FNotebookSynchro.Enable and (FNotebookSynchro.Server <> '') then
      begin
        FTypeSynchro := tsNotebook;
        addSynchroServer(0, 'Serveur Magasin', FNotebookSynchro.Server, true);
        vDefaultServerId := FNotebookSynchro.ServerId;
      end;

      // nouveau mode
      if FAllowMultiMag then
      begin
        vNotebookSynchros := getNotebookSynchros;
        for vNotebookSynchro in vNotebookSynchros do
        begin
          if vNotebookSynchro.Enable then
          begin
            FTypeSynchro := tsNotebook;
            addSynchroServer(vNotebookSynchro.ServerId, vNotebookSynchro.Nom, vNotebookSynchro.Server, (vNotebookSynchro.ServerId = vDefaultServerId));
          end;
        end;
      end;

    end;

    if FTypeSynchro = tsNone then
    begin
      Log.Log('Synchro', 'checkLocalBase', 'Log', 'Base de donnée non paramétrée pour la synchro', logError, true, 0, ltLocal);
      FLocalBaseStatus := logError;
      Exit;
    end;

    Log.Log('Synchro', 'checkLocalBase', 'Log', 'Récupération de la version de la lame', logInfo, true, 0, ltLocal);
    if not getVersionLame(FLocalBasId, FLameVersion) then
    begin
      Log.Log('Synchro', 'checkLocalBase', 'Log', 'Impossible de récupérer la version Lame', logError, true, 0, ltLocal);
      FLocalBaseStatus := logError;
      Exit;
    end;

    FLocalBaseStatus := logInfo;
    Result := true;
    Log.Log('Synchro', 'checkLocalBase', 'Log', 'Vérification de la base locale terminée', logInfo, true, 0, ltLocal);
  finally
    closeDatabase;
    updateLocalBaseStatus;
  end;
end;
//------------------------------------------------------------------------------

function TFrm_Main.checkSyncBase: boolean;
var
  aSynchroServer: TSynchroServer;
  aIndex, baseSize, freeLocalSpace: Integer;
begin
  Result := false;
  FSyncBaseStatus := logNotice;
  updateLocalBaseStatus;

  FSelectedServer := cbBaseSync.Text;

  if FSelectedServer = '' then
  begin
    if FSynchroServers.Count = 1 then
    begin
      FSelectedServer := FSynchroServers[0].Nom;
    end
    else
    begin
      Log.Log('', 'checkSyncBase', 'Log', 'Selectionnez un serveur de synchro', logWarning, true, 0, ltLocal);
      FSyncBaseStatus := logWarning;
      FUserRequest := true;
      Exit;
    end;
  end;

  aSynchroServer := getSynchroServer(FSelectedServer);
  if not Assigned(aSynchroServer) then
  begin
    FSelectedServer := '';
    Log.Log('', 'checkSyncBase', 'Log', 'Selectionnez un serveur de synchro', logWarning, true, 0, ltLocal);
    FSyncBaseStatus := logWarning;
    Exit;
  end;

  Log.Log('', 'checkSyncBase', 'Log', 'Verification de la base de synchro', logNotice, true, 0, ltLocal);
  if not FileExists(aSynchroServer.Server) then
  begin
    Log.Log('', 'checkSyncBase', 'Log', 'Base de synchro inaccessible', logError, true, 0, ltLocal);
    FSyncBaseStatus := logError;
    Exit;
  end;

  Log.Log('', 'checkSyncBase', 'Log', 'Base de synchro trouvée', logNotice, true, 0, ltLocal);
  FSyncBaseStatus := logInfo;
  Result := true;

  FSyncBase := aSynchroServer.Server;
  FSyncBasePath := IncludeTrailingPathDelimiter(ExtractFilePath(FSyncBase));

  updateLocalBaseStatus;
end;
//------------------------------------------------------------------------------

// fonction pour connaître la taille d'un fichier

function TFrm_Main.FileSize(fileName: wideString): Int64;
var
  sr: TSearchRec;
begin
  if FindFirst(fileName, faAnyFile, sr) = 0 then
    Result := Int64(sr.FindData.nFileSizeHigh) shl Int64(32) + Int64(sr.FindData.nFileSizeLow)
  else
    Result := -1;
  FindClose(sr);
end;

// fonction pour connaître l'espace disque disponible
function TFrm_Main.EspaceDisque(disque: string; espace: TEspaceDisque; unite: TUniteOctet): extended;
var
  lpFreeBytesAvailableToCaller: TLargeInteger;
  lpTotalNumberOfBytes: TLargeInteger;
  lpTotalNumberOfFreeBytes: TLargeInteger;
  taille: extended;
begin

  if GetDiskFreeSpaceEx(pchar(disque), lpFreeBytesAvailableToCaller, lpTotalNumberOfBytes, @lpTotalNumberOfFreeBytes) then
  begin
    case espace of
      tedTotal:
        taille := lpTotalNumberOfBytes;
      tedLibre:
        taille := lpTotalNumberOfFreeBytes;
      tedUtilise:
        taille := lpTotalNumberOfBytes - lpTotalNumberOfFreeBytes;
    else
      taille := lpTotalNumberOfBytes;
    end;

    case unite of
      tuoOctet:
        taille := taille;
      tuoKoctet:
        taille := taille / (power(1024, 1));
      tuoMoctet:
        taille := taille / (power(1024, 2));
      tuoGoctet:
        taille := taille / (power(1024, 3));
      tuoToctet:
        taille := taille / (power(1024, 4));
    else
      taille := taille / (power(1024, 2));
    end;
  end;

  Result := RoundTo(taille, -2);
end;

//------------------------------------------------------------------------------

function TFrm_Main.getSynchroServer(aNom: string): TSynchroServer;
var
  aSynchroServer: TSynchroServer;
begin
  Result := nil;

  for aSynchroServer in FSynchroServers do
  begin
    if aSynchroServer.Nom = aNom then
    begin
      Result := aSynchroServer;
      Exit;
    end;
  end;
end;

procedure TFrm_Main.addSynchroServer(aId: Int64; aNom, aServer: string; aDefault: boolean);
var
  aSynchroServer: TSynchroServer;
begin
  aSynchroServer := TSynchroServer.Create;
  aSynchroServer.Id := aId;
  aSynchroServer.Nom := aNom;
  aSynchroServer.Server := aServer;
  aSynchroServer.Default := aDefault;

  FSynchroServers.Add(aSynchroServer);
end;
//------------------------------------------------------------------------------

procedure TFrm_Main.closeDatabase;
begin
  if Database.Connected then
  begin
    Log.Log('', 'closeDatabase', 'Log', 'Déconnexion de la base de donnée ' + Database.DatabaseName, logInfo, true, 0, ltLocal);
    Database.Close;
  end;
end;
//------------------------------------------------------------------------------

function TFrm_Main.connectDatabase(aBase: string): boolean;
begin
  Result := false;

  if Database.Connected then
    Database.Close;

  Log.Log('', 'connectDatabase', 'Log', 'Connexion à la base de donnée ' + aBase, logInfo, true, 0, ltLocal);

  if not FileExists(aBase) then
  begin
    Log.Log('', 'connectDatabase', 'Log', 'Base de donnée ' + aBase + ' inexistante', logError, true, 0, ltLocal);
    Exit;
  end;

  Database.DatabaseName := aBase;
  Database.Username := 'SYSDBA';
  Database.Password := 'masterkey';

  try
    Database.Open;
    Result := true;
  except
    on E: Exception do
    begin
      Log.Log('', 'connectDatabase', 'Log', E.Message, logError);
    end;
  end;
end;
//------------------------------------------------------------------------------

function TFrm_Main.GetParam(var IOInteger: integer; var IOFloat: double; var IOString: string; AType, ACode, ABasID: integer): Boolean;
begin
  Result := False;

  with queTmp do
  begin
    try
      Close;
      SQL.Clear;
      SQL.Add('SELECT PRM_INTEGER, PRM_FLOAT, PRM_STRING');
      SQL.Add('  FROM GENPARAM JOIN K ON (K_ID = PRM_ID AND K_ENABLED = 1)');
      SQL.Add('WHERE PRM_TYPE = :TYPE');
      SQL.Add('  AND PRM_POS = :BASID');
      SQL.Add('  AND PRM_CODE = :CODE');
      ParamCheck := True;
      ParamByName('TYPE').AsInteger := AType;
      ParamByName('CODE').AsInteger := ACode;
      ParamByName('BASID').AsInteger := ABasID;
      Open;

      IOInteger := FieldByName('PRM_INTEGER').AsInteger;
      IOFloat := FieldByName('PRM_FLOAT').AsFloat;
      IOString := FieldByName('PRM_STRING').AsString;

      Close;
      Result := True;
    except
      on E: Exception do
      begin
        Log.Log('', 'getParam', 'Log', 'Impossible de récupérer un peramètre ' + E.Message, logError, true, 0, ltLocal);
      end;
    end;
  end;
end;
//------------------------------------------------------------------------------

function TFrm_Main.GetParamString(AType, ACode, ABasID: integer): string;
var
  AStr: string;
  AInt: integer;
  AFloat: double;
begin
  Result := '';
  if GetParam(AInt, AFloat, AStr, AType, ACode, ABasID) then
  begin
    Result := AStr;
  end;
end;
//------------------------------------------------------------------------------

function TFrm_Main.getUrlReplic(ABasId: Int64): string;
var
  BasId: Integer;
begin
  try
    Result := '';

    with queTmp do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Select REP_URLDISTANT');
      SQL.Add('  from GenReplication Join k On (K_id = REP_ID and K_ENABLED=1)');
      SQL.Add('  Join GenLaunch on REP_LAUID = LAU_ID');
      SQL.Add('  Join k on (K_ID = LAU_ID and K_Enabled=1)');
      SQL.Add('Where REP_ID>0');
      SQL.Add('  And LAU_BASID = :PBASID');
      SQL.Add('  And REP_ORDRE >= 0');
      SQL.Add('Order By REP_ORDRE');
      ParamCheck := true;
      ParamByName('PBASID').AsInteger := ABasId;
      Open;

      Result := FieldbyName('REP_URLDISTANT').AsString;
    end;
  except
    on E: Exception do
    begin
      Log.Log('', 'getUrlReplic', 'Log', 'Impossible de récupérer l''adrese de réplication : ' + E.Message, logError, true, 0, ltLocal);
    end;
  end;
end;
//------------------------------------------------------------------------------
{ TCompareFile }
//------------------------------------------------------------------------------

function TCompareFile.Compare(const Left, Right: TFile): Integer;
begin
  Result := CompareDateTime(Left.ADate, Right.ADate);
  if Result = 0 then
    Result := CompareText(Left.AName, Right.AName);
end;
//------------------------------------------------------------------------------

end.

