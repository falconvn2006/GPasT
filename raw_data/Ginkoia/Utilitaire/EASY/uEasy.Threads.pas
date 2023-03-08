unit uEasy.Threads;

interface

uses
  Winapi.Windows,
  Winapi.ShellAPI,
//  Dialogs,
  System.SysUtils,
  System.Classes,
  System.RegularExpressionsCore,
  System.Win.Registry,
  System.StrUtils,
  System.IOUtils,
  System.Variants,
  Data.DB,
  VCL.Forms,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Phys.IB,
  FireDAC.Phys.IBDef,
  FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param,
  FireDAC.DatS,
  FireDAC.DApt.Intf,
  FireDAC.DApt,
  FireDAC.Phys.IBBase,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  FireDAC.Comp.UI,
  FireDAC.Comp.ScriptCommands,
  FireDAC.Stan.Util,
  FireDAC.Comp.Script,
  FireDAC.Phys.IBWrapper,
  SymmetricDS.Commun,
  cHash,
  UWMI,
  ServiceControler,
  UCommun,
  System.IniFiles,
  uEasy.Types,
  System.Math;

const CST_HOST          = 'localhost'; // '127.0.0.1';
      CST_PORT          = 3050;
      CST_BASE_USER     = 'SYSDBA';
      CST_BASE_PASSWORD = 'masterkey';


type
  TQueryThread = class(TThread)
  private
    FEvent         : TNotifyEvent;
    FCnx           : TFDConnection;
    FQuery         : TFDQuery;
    FResultat      : integer;
  protected
    procedure Execute; override;
  public
    constructor Create(ACnx:TFDConnection; aQuery:TFDQuery; aEvent:TNotifyEvent=nil);
    property Resultat:integer read FResultat write FResultat;
  end;

  //----------------------------------------------------------------------------
  // Recherche Dichotonique du K_VERSION autour de la prériode [DATEDEB,DATEFIN]
  TQueryDichotomicKVersionThread = class(TThread)
  private
    FEvent         : TNotifyEvent;
    FCnx           : TFDConnection;
//    FTrans         : TFDTransaction;
//    FQuery         : TFDQuery;
    FGENID         : Integer;    // Niveau du GENERALID
    FPLAGEDEB      : integer;    // Debut de plage pour pas aller en dessous !
    FForceUPDATED  : Boolean;    //

    // FMINKVERSION   : integer;    // Niveau du plus vieux du K_VERSION
    // FMAXKVERSION   : integer;    // Niveau du plus récent du K_VERSION
    FCOUNT         : integer;
    FDateDeb       : TDateTime;
    FDateFin       : TDateTime;
    FMinK          : TKVersion;
    FMaxK          : TKVersion;

    function TrouveBorne(aDate:TDateTime;aLower:boolean):TKVersion;
                                      // alower = 0 borneInf
                                      // aLower = 1 BorneSup
    function CalculCount():integer;
    function Analyse_Depuis(aStart:Integer;aTranche:integer):TKVersion;
//    function Get_DateTime(aKVERSION:Integer):TDateTime;
  protected
    procedure Execute; override;
  public
    constructor Create(ACnx:TFDConnection; aPlage:string;aGENID:Integer;
        aForceUpdated:Boolean;
        aDateDeb,aDateFin:TDateTime;
        aEvent:TNotifyEvent=nil);
    // property MinKVERSION:integer read FMINKVERSION;
    // property MaxKVERSION:integer read FMaxKVERSION;

    property MinK:TKVersion  read FMINK;
    property MaxK:TKVersion  read FMaxK;


    property COUNT:Integer       read FCOUNT;
  end;
  //----------------------------------------------------------------------------

  TQueryDeltaThread = class(TThread)
  private
    FEvent         : TNotifyEvent;
    FCnx           : TFDConnection;
    FTrans         : TFDTransaction;
    FQuery         : TFDQuery;
    FGENID         : Integer;    // Niveau du GENERALID
    FMINKVERSION   : integer;    // Niveau du plus vieux du K_VERSION
    FMAXKVERSION   : integer;    // Niveau du plus récent du K_VERSION
    FCOUNT         : integer;
  protected
    procedure Execute; override;
  public
    constructor Create(ACnx:TFDConnection; aQuery:TFDQuery; aGENID:Integer; aEvent:TNotifyEvent=nil);
    property MinKVERSION:integer read FMINKVERSION;
    property MaxKVERSION:integer read FMaxKVERSION;
    property COUNT:Integer       read FCOUNT;
  end;

  TQueryMVTThread = class(TThread)
  private
    FStatusProc     : TStatusMessageCall;
    FProgressProc   : TProgressMessageCall;
    FTpsRestantProc : TInfosMessageCall;
    FLinesDoneProc  : TInfosMessageCall;

    FForceUPDATED  : Boolean;    //

    FStatus        : string;
    FTpsRestantStr : string;
    FTpsRestantInt : integer;
    FLinesDone     : integer;

    FEvent         : TNotifyEvent;
    FProgress      : integer;

    FCnx           : TFDConnection;
    FTrans         : TFDTransaction;

    FSens          : string;       // Sens LAME2MAG ou MAG2LAME

    FDebut         : TDateTime;
    FFin           : TDateTime;

    FNODEID        : string;       // Node
    FGENID         : Integer;      // Niveau du GENERALID
    FMINKVERSION   : integer;      // Niveau du plus vieux du K_VERSION
    FMAXKVERSION   : integer;      // Niveau du plus récent du K_VERSION
    FCount         : integer;
    FStopped       : Boolean;

    Procedure ProgressCallBack;
    Procedure StatusCallBack;
    Procedure TpsRestantCallBack;
    Procedure LinesDoneCallBack;
  protected
    procedure Execute; override;
  public
    constructor Create(ACnx:TFDConnection; aSens:string; aNodeID:string; aGENID:Integer;
    aMinKVERSION,aMaxKVERSION:integer;
    aDebut,aFin:TDateTime;
    aCount     : integer;
    aForceUpdated : boolean;
    aProgressCallBack : TProgressMessageCall;
    aStatusCallBack   : TStatusMessageCall;
    aTpsRestantCallback  : TInfosMessageCall;
    aLinesDoneCallback   : TInfosMessageCall;
    aEvent:TNotifyEvent=nil);
    destructor Destroy();
  property Stopped : boolean  read FStopped;
  end;


  TScriptCleanSYMDS = class(TThread)
  private
    FStatusProc    : TStatusMessageCall;
    FStatus        : string;
    FBASE0         : TFileName;
    FMODE          : string;
    FServeurTOTOFile  : TFileName;
    FTOTOFile      : TFileName;

//    FDELOS2EASY    : TFileName;
    FNEWNAME       : TFileName;  //DELOS2EASY.IB ou GINKOIA.IB
    FNBError       : integer;
    FDATADir       : string;
    FGENERATEUR_EXE : string;
    FSAV            : TFileName;
    FGENID          : integer;
    procedure Etape_Copie_From_Serveur();
    procedure Etape_Clean_EASY_TmpDir();
    procedure Etape_ShutDown();
    procedure Etape_Restart();
    procedure StatusCallBack();
    procedure Etape_RenameBase0;
    procedure Etape_RenameBaseTOTO;
    procedure Etape_GetGenerateurs;
    procedure Etape_SetGenerateurs;
    procedure Etape_Controles;    
  protected
    procedure Execute; override;
  public
    constructor Create(
      aMode : string;
      aServerTOTOFile:TFileName;
      aLocalTOTOFile:TFileName;       // .TOTO
      aGENID            : integer;
      aStatusCallBack   : TStatusMessageCall;
      aEvent:TNotifyEvent=nil);
    destructor Destroy();
  property NBError:integer read FNBError;
  end;

{
  TOptimzeDataBase = class(TThread)
  private
    FStatusProc    : TStatusMessageCall;
    FLogProc       : TLogMessageCall;
    FStatus        : string;
    FLog           : string;
    FIBFile        : TFileName;
    FServiceName   : string;             // EASY_XXXX
    FEasyDir       : string;             // ca sert à trouver symadmin pour la purge
    Foptions       : String;
    FnbError       : integer;
//     procedure Etape_Sweep();             // position 1
    function DoSweep(): boolean;
    procedure Etape_Recalcul_Index();    // position 2
    procedure Etape_PurgeSYMDS();        // position 3
  protected
    procedure StatusCallBack();
    procedure LogCallBack();
    procedure Execute; override;
  public
    constructor Create(aBRRecord:TBRRecord;
      aOptions        : string;
      aStatusCallBack : TStatusMessageCall;
      aLogCallBack : TLogMessageCall;
      aEvent:TNotifyEvent=nil);
    destructor Destroy();
  end;
}

  TOptimizeDB = class(TThread)
  private
    FStatusProc    : TStatusMessageCall;
    FLogProc       : TLogMessageCall;
    FStatus        : string;
    FLog           : string;
    FIBFile        : TFileName;
//    FServiceName   : string;
//    FDossier       : string;
    FEtatServiceAuDebut : Word;
    Foptions            : string;
    FnbErrors       : integer;
    FStart          : Cardinal;
    FTime           : integer;
//    function  DoStopService():Boolean;
//    function  DoStartService():Boolean;
    function  DoSweep(): boolean;
    procedure Etape_Recalcul_Index_Ginkoia();
    procedure Etape_Recalcul_Index_SYMDS();
    procedure Etape_Pre_Prurge();
  protected
    procedure StatusCallBack();
    procedure LogCallBack();
    procedure Execute; override;
  public
    constructor Create(aIBFile:TFileName;
//    aDossier        : string;
//    aServiceName    : string;
      aOptions        : string;
      aStatusCallBack : TStatusMessageCall;
      aLogCallBack    : TLogMessageCall;
      aEvent:TNotifyEvent=nil);
    destructor Destroy();
  property NBErrors : integer read FNbErrors;
  property Time     : integer read FTime;
//  property Dossier  : string  read FDossier;
  end;

  TBackupRestore   = class(TThread)
  private
    FStatusProc    : TStatusMessageCall;
    FLogProc       : TLogMessageCall;
    FStatus        : string;
    FLog           : string;
    FBRRecord      : TBRRecord;
    FnbError       : integer;
    FReturnValue   : integer;
    FBackup_Dir    : string;
    FOLD_Dir       : string;
    FBACKUP_MAX    : integer;
    FOLD_MAX       : integer;
    FPAGEBUFFERS   : integer;
    F7zFiles       : TMyFiles;
    FOldFiles      : TMyFiles;
    function DoShutDown(aFileBase:string) : boolean;
    function DoRestart(aFileBase:string) : boolean;
    function DoValidate(aFileBase : string) : boolean;
    function DoBackup(aFileBase, aFileSave : string; Options : TIBBackupOptions) : boolean;
    function DoRestore(aFileBase, aFileSave : string; aOptions : TIBRestoreOptions; PageSize : cardinal) : boolean;
    procedure SetReturnValue(aValue:integer);
    function Compress7z(aFiles:TstringList;a7zFile:string):integer;
    procedure GetFileList(var MyList:TMyFiles;inDir, Extension : String );
    Procedure CleanDir(aDir:string;aExt:string;aMax:integer);
  protected
    procedure StatusCallBack();
    procedure LogCallBack();
    procedure Execute; override;
  public
    constructor Create(aBRRecord:TBRRecord;
        aBackup_Max:Integer; aBackup_Dir:string;
        aOld_Max:Integer; aOld_Dir:string;
        aStatusCallBack : TStatusMessageCall;
        aLogCallBack   : TLogMessageCall;
        aEvent:TNotifyEvent=nil);
    destructor Destroy();
    property ReturnValue : integer read FReturnValue write SetReturnValue;
  end;


implementation

uses uDataMod, LaunchProcess,uSevenZip;

constructor TBackupRestore.Create(aBRRecord:TBRRecord;
    aBackup_Max:Integer; aBackup_Dir:string;
    aOld_Max:Integer; aOld_Dir:string;
    aStatusCallBack : TStatusMessageCall;
    aLogCallBack   : TLogMessageCall;
    aEvent:TNotifyEvent=nil);
begin
    inherited Create(True);
    OnTerminate     := AEvent;
    FreeOnTerminate := True;
    FStatus         := '';
    FLog            := '';
    FBRRecord       := aBRRecord;
    FStatusProc     := aStatusCallBack;
    FLogProc        := aLogCallBack;
    FBackup_Dir     := aBackup_Dir;
    FBACKUP_MAX     := Max(Min(5,aBackup_Max),1);  // au moins 1, au plus 5
    FOLD_Dir        := aOld_Dir;
    FOLD_MAX        := Max(Min(5,aOld_Max),0);     // de 0 à 5 max
    FPAGEBUFFERS    := aBRRecord.PAGEBUFFERS;
    FReturnValue    := 0;
    FnbError        := 0;
end;

destructor TBackupRestore.Destroy();
begin
  Inherited;
end;


procedure TBackupRestore.StatusCallBack();
begin
   if Assigned(FStatusProc) then  FStatusProc(FStatus);
end;


procedure TBackupRestore.LogCallBack();
begin
   if Assigned(FLogProc) then  FLogProc(FLog);
end;

procedure TBackupRestore.SetReturnValue(aValue:integer);
begin
  FReturnValue := aValue;
end;


function TBackupRestore.DoShutDown(aFileBase:string) : boolean;
var Config : TFDIBConfig;
begin
  FLog   := 'Shutdown...';
  Synchronize(LogCallBack);
  Result := false;
  Config := TFDIBConfig.Create(nil);
  try
    try
      Config.DriverLink := DataMod.FDPhysIBDriverLink;
      Config.Protocol   := ipTCPIP;
      Config.Host       := CST_HOST;;
      Config.Database   := aFileBase;
      Config.UserName   := CST_BASE_USER;
      Config.Password   := CST_BASE_PASSWORD;
      Config.Port       := CST_PORT;
      Config.ShutdownDB(smForce, 10); // 10 secondes !
      Result := true;
      FLog   := 'Shutdown : OK';
      Synchronize(LogCallBack);
  except
    on e : Exception do
      begin
          FLog   := 'Shutdown : ERREUR';
          Synchronize(LogCallBack);
          Raise;
      end;
  end;
  finally
      FreeAndNil(Config);
  end;
end;


function TBackupRestore.DoRestart(aFileBase:string) : boolean;
var Config : TFDIBConfig;
begin
  FLog   := 'Restart...';
  Synchronize(LogCallBack);
  Result := false;
  Config := TFDIBConfig.Create(nil);
  try
    try
      Config.DriverLink := DataMod.FDPhysIBDriverLink;;
      Config.Protocol   := ipTCPIP;
      Config.Host       := CST_HOST;;
      Config.Database   := aFileBase;
      Config.UserName   := CST_BASE_USER;
      Config.Password   := CST_BASE_PASSWORD;
      Config.Port       := CST_PORT;
      Config.OnlineDB;
      Result := true;
      FLog   := 'Restart : OK';
      Synchronize(LogCallBack);
  except
    on e : Exception do
      begin
          FLog   := 'Restart : ERREUR';
          Synchronize(LogCallBack);
          Raise;
      end;
  end;
  finally
      FreeAndNil(Config);
  end;
end;



function TBackupRestore.DoBackup(aFileBase, aFileSave : string; Options : TIBBackupOptions) : boolean;
var Backup : TFDIBBackup;
    v:string;
begin
  FStatus   := 'Backup...';
  Synchronize(StatusCallBack);

  Result := false;

  // Options :
  // boIgnoreChecksum   : Ignores checksums during backup; Note: InterBase supports true checksums only for ODS 8 and earlier.
  // boIgnoreLimbo      : Ignores limbo transactions during backup.
  // boMetadataOnly     : Backs up metadata only, no data.
  // boNoGarbageCollect : This option instructs the server not to perform garbage collection on every record it visits. This enables the server to retrieve records faster, and to send them to the gbak client for archiving.
  // boOldDescriptions  : Backs up metadata in old-style format.
  // boNonTransportable : Creates the backup in nontransportable format.
  // boConvert          : Converts external files as internal tables.
  // boExpand           : Creates a noncompressed back up.
  Backup := TFDIBBackup.Create(nil);
  try
    try
      Backup.DriverLink := DataMod.FDPhysIBDriverLink;
      Backup.Protocol := ipTCPIP;
      Backup.Host     := CST_HOST;
      Backup.Port     := CST_PORT;
// Pb sur mon poste
//    Backup.InstanceName := 'service_mgr';
//    Backup.InstanceName := 'localhost:gds_db';
      if FBRRecord.InstanceName<>''
        then Backup.InstanceName := FBRRecord.InstanceName;
      Backup.UserName := CST_BASE_USER;
      Backup.Password := CST_BASE_PASSWORD;
      Backup.Database := aFileBase;

      Backup.Verbose := true;

      Backup.Options := Options;

      Backup.BackupFiles.Add(aFileSave);

      FLog      := Format('Backup : %s => %s',[aFileBase,aFileSave]);
      Synchronize(LogCallBack);

      Backup.Backup();
      Result := true;
    except
      on e : Exception do
        // DoLog('!! Exception : ' + e.ClassName + ' - ' + e.Message);
        begin
            FLog  := 'Backup - Erreur';
            Synchronize(LogCallBack);
             v:= E.message;
        end;
    end;
    finally
      FreeAndNil(Backup);
    end;
end;


function TBackupRestore.DoValidate(aFileBase : string) : boolean;
var Validate : TFDIBValidate;
begin
  FStatus   := 'Validate';
  Synchronize(StatusCallBack);
  Result := false;
  Validate := TFDIBValidate.Create(nil);
  try
    try

      Validate.DriverLink := DataMod.FDPhysIBDriverLink;
      Validate.Options := [roValidateFull];
      Validate.Protocol := ipTCPIP;

      Validate.Host     := CST_HOST;
      Validate.Port     := CST_PORT;
      Validate.UserName := CST_BASE_USER;
      Validate.Password := CST_BASE_PASSWORD;

      Validate.Database := aFileBase;
      // on fait pas de Sweep.... je n'en vois pas l'utilité....

      Validate.Repair();
      FLog      := 'Validate : OK';
      Synchronize(LogCallBack);
      Result    := true;
  except
    on e : Exception do
      begin
          FLog   := 'Validate : ERREUR';
          Synchronize(LogCallBack);
          Raise;
      end;
  end;
  finally
    FreeAndNil(Validate);
  end;
end;


function TBackupRestore.DoRestore(aFileBase, aFileSave : string; aOptions : TIBRestoreOptions; PageSize : cardinal) : boolean;
var Restore : TFDIBRestore;
begin
  FStatus   := 'Restore';
  Synchronize(StatusCallBack);
  Result := false;

  // Options :
  // roDeactivateIdx  : Makes indexes inactive upon restore.
  // roNoShadow       : Does not create any shadows that were previously defined.
  // roNoValidity     : Deletes validity constraints from restored metadata; allows restoration of data that would otherwise not meet validity constraints.
  // roOneAtATime     : Restores one table at a time; useful for partial recovery if database contains corrupt data.
  // roReplace        : Restores database to new file or replaces existing file.
  // roUseAllSpace    : Restores database with 100% fill ratio on every data page. By default, space is reserved for each row on a data page to accommodate a back version of an UPDATE or DELETE. Depending on the size of the compressed rows, that could translate e to any percentage.
  // roValidate       : Use to validate the database when restoring it.
  // roFixFSSData     :
  // roFixFSSMetaData :
  // roMetaDataOnly   : Restore metadata only, no data.
  Restore := TFDIBRestore.Create(nil);
  try
    try

      Restore.DriverLink := DataMod.FDPhysIBDriverLink;
      Restore.Protocol := ipTCPIP;
      Restore.Host     := CST_HOST;
      Restore.Port     := CST_PORT;
      Restore.UserName := CST_BASE_USER;
      Restore.Password := CST_BASE_PASSWORD;
      Restore.Database := aFileBase;
      if FBRRecord.InstanceName<>''
        then Restore.InstanceName := FBRRecord.InstanceName;

      Restore.Verbose  := true;

      Restore.Options := aOptions;
      // Restore.PageBuffers := PageBuffers;  // n'améliore pas la vitesse du restore
      Restore.PageBuffers := FPAGEBUFFERS;
      Restore.PageSize := PageSize;

      Restore.BackupFiles.Add(aFileSave);
      FLog   := Format('Restore : %s => %s',[aFileSave,aFileBase]);
      Synchronize(LogCallBack);

      Restore.Restore();
      Result := true;
    except
      on e : Exception do
        begin
          Raise;
        end;
    end;
  finally
      FreeAndNil(Restore);
  end;
end;


function TBackupRestore.Compress7z(aFiles:TstringList;a7zFile:string):integer;
var Arch : I7zOutArchive;
    i:integer;
begin
  FStatus   := 'Compression';
  Synchronize(StatusCallBack);

  Arch := CreateOutArchive(CLSID_CFormat7z);
  try
    try
      for i:=0 to aFiles.Count-1 do
        begin
            Arch.AddFile(aFiles.Strings[i],ExtractFileName(aFiles.Strings[i]));
        end;

      //-----------------------------------
      // SetMultiThreading(Arch,4);
      SetCompressionLevel(Arch,FBRRecord.COMPRESS7Z); // 0=Store 1=faster ? 3=

      Arch.SaveToFile(a7zFile);
      for i:=0 to aFiles.Count-1 do
        begin
           TFile.Delete(aFiles.Strings[i]);
        end;
      result:=0;
      Except on E:Exception do
        begin
          result := 1;
        end;
    end;
  finally
    // FreeAndNil(Arch);
    // Arch._Release;
  end;
end;

procedure TBackupRestore.GetFileList(var MyList:TMyFiles;inDir, Extension : String );
var CurDir : String;
    aSearchRec : TSearchRec;
    i,j:integer;
    st: TSystemTime;
begin
  SetLength(MyList,0);
  CurDir := ExcludeTrailingBackslash(inDir) + '\*.' + Extension;

  i := FindFirst( CurDir, faAnyFile, aSearchRec );
  while i = 0
    do
      begin
        j:= Length(MyList);
        SetLength(MyList,j+1);
        FileTimeToSystemTime(aSearchRec.FindData.ftCreationTime,st);
        MyList[j].FileName       := aSearchRec.Name;
        MyList[j].CreateDateTime := SystemTimeToDateTime(st);
        i := FindNext( aSearchRec );
      end;
  FindClose(aSearchRec);
end;


Procedure TBackupRestore.CleanDir(aDir:string;aExt:string;aMax:integer);
Procedure Order(var Tab:TMyFiles);
Var i,j:Integer;
    t:TMyFile;
Begin
  For i:=Low(Tab) To High(Tab)-1 Do
    For j:=i+1 To High(Tab) Do
      If Tab[i].CreateDateTime>Tab[j].CreateDateTime
        then
            Begin
              t:=Tab[i];
              Tab[i]:=Tab[j];
              Tab[j]:=t;
            End;
End;

var i:Integer;
    vMyFiles:TMyFiles;
begin
    SetLength(vMyFiles,0);
    try
       GetFileList(vMyFiles,aDir,aExt);
       Order(vMyFiles);
       for i:=High(vMyFiles)-aMAX downto Low(vMyFiles) do
        begin
          TFile.Delete(aDir+vMyFiles[i].FileName);
        end;
      SetLength(vMyFiles,0);
    finally
      //
    end;
end;


procedure TBackupRestore.Execute;
// code de retour :
//  0 - reussite
// ...
//  2 - Pas assez d'espace
//  3 - Shutdown base
//  4 - Erreur deplacement fichier
//  5 - Erreur de validation
//  6 - Erreur de backup
//  7 - Erreur de restauration
//  8 - GFix
//  9 - Verification nok
// 10 - Restart base
// 11 - Exception
// 12 - Autre erreur
// 13 - Erreur à l'arret du Service EASY_XXX
// 14 - Erreur au Restart du Service EASY_XXX
// 15 - Fichier IB Absent !!
// 16 - Fichier TMP, NEW Ou OLD déjà présent au debut !!
// 17 - Erreur à la compression..
// 18 - Impossible de déplacer le fichier 7z.

var
  TMPName, OldName, NewName,GBKName, ZipName : string;
  vDestPropertiesFile : String;
  vFileSize : int64;
  vRunOnBegin : boolean;
  vRes7Z   : integer;
  vboucle  : Integer;
  vFiles   : TStringList;
  vCheminFinal7z  : string;
  vCheminFinalOld : string;
  vDossier        : string;
  vSource      :string;
  vDestination :string;
  regExp : TPerlRegEx;
  vIsFTP : Boolean;
  vHost     :string;
  vUserName :string;
  vPassword :string;
  vPort     :integer;
  vLame     :string;
  vSAV_OLD  :string;


begin
  ReturnValue := 12;
  vDossier    := ExtractFileName(ExcludeTrailingPathDelimiter(ExtractFilePath(FBRRecord.IBFILE)));

  vHost     := '';
  vUserName := '';
  vPassword := '';
  vPort     := 21;
  vLame     := '';

  vIsFTP    := false;
  // Si nous sommes en mode "FTP"
  if Pos('ftp://',FBackup_Dir)=1
    then
       begin
          vIsFTP := true;
          regExp := TPerlRegEx.Create;
          try
            regExp.RegEx := 'ftp:\/\/(.*)?:([0-9]*)\/(.*)\/(.*)\/';
            regExp.Subject  := FBackup_Dir;
            // regExp.Options  := [preCaseLess];
            If (regExp.Match())
              then
                begin
                   vHost     :=  regExp.Groups[1];
                   vUserName := 'backup';
                   vPassword := 'ch@mon1x';
                   vPort     := StrToIntDef(regExp.Groups[2],21);
                   vLame     := regExp.Groups[3];
                end;
          finally
            regExp.Free;
          end;
       end
    else
      begin
         vCheminFinal7z  := ExcludeTrailingPathDelimiter(StringReplace(FBackup_Dir,'<DOSSIER>',vDossier,[rfIgnoreCase]));
         ForceDirectories(vCheminFinal7z);
         vCheminFinal7z  := IncludeTrailingPathDelimiter(vCheminFinal7z);
      end;

  // le OLD n'est jamais sur un FTP Pour l'instant....
  vCheminFinalOld := ExcludeTrailingPathDelimiter(StringReplace(FOLD_Dir,'<DOSSIER>',vDossier,[rfIgnoreCase]));
  ForceDirectories(vCheminFinalOld);
  vCheminFinalOld  := IncludeTrailingPathDelimiter(vCheminFinalOld);
  vSAV_OLD         := vCheminFinalOld + 'GINKOIA_'+FormatDateTime('yyyymmdd_hhnnsszzz',Now())+'.old';


  TMPName := ChangeFileExt(FBRRecord.IBFILE, '.TMP');
  GBKName := IncludeTrailingPathDelimiter(ExtractFilePath(FBRRecord.IBFILE)+ 'backup') + 'SAV.GBK';

      //              + 'SAV_'+FormatDateTime('yyyymmdd_hhnnsszzz',Now())+'.GBK';
  ForceDirectories(ExtractFileDir(GBKName));
  OldName := ChangeFileExt(FBRRecord.IBFILE, '.OLD');
  NewName := ChangeFileExt(FBRRecord.IBFILE, '.NEW');

  vFiles := TStringList.Create;
  ZipName := IncludeTrailingPathDelimiter(ExtractFilePath(FBRRecord.IBFILE)+ 'backup')
             + 'SAV_'+FormatDateTime('yyyymmdd_hhnnsszzz',Now())+'.7z';


  vDestPropertiesFile := IncludeTrailingPathDelimiter(ExtractFilePath(FBRRecord.IBFILE)+ 'backup') +
        extractfilename(FBRRecord.PropertiesFile);

  try

    // Si le fichier .ib n'existe pas : On ne fait RIEN !!!!
    // il ne faut surtout pas virer le moindre fichier....
    //
    if Not(FileExists(FBRRecord.IBFILE))
      then
        begin
          ReturnValue := 15;
          Exit;
        end;

    if (FileExists(TMPName) or FileExists(GBKName) or FileExists(OldName) or FileExists(NewName))
      then
        begin
            ReturnValue := 16;
            exit;
        end;


    try
      vRunOnBegin := False;
      if FBRRecord.EASYSERVICE<>''
        then
          begin
            // ProgressStepLbl('Arrêt Service ' + FEASYService);
            FLog := Format('Arrêt Service %s',[FBRRecord.EASYSERVICE]);
            Synchronize(LogCallBack);
            if ServiceGetStatus(PChar(''),Pchar(FBRRecord.EASYSERVICE))=4 then
              begin
                 ServiceStop('',FBRRecord.EASYSERVICE);
                 vRunOnBegin := True;
              end;
            vBoucle:=0;
            while (ServiceGetStatus(Pchar(''),Pchar(FBRRecord.EASYSERVICE))<>1) and (vboucle<50) do
              begin
                 Inc(vBoucle);
                 Sleep(200);
              end;
            // Pause de 3s
            Sleep(3000);
            // s'il n'est pas arrêter ==> Erreur
            if (ServiceGetStatus(PChar(''),Pchar(FBRRecord.EASYSERVICE))<>1) then
              begin
                ReturnValue := 13;
                Exit;
              end;
            FLog := Format('Service %s Arrêté',[FBRRecord.EASYSERVICE]);
            Synchronize(LogCallBack);
          end;
      // recherche de la taille...
      // vFileSize := GetFileSize(FBRRecord.IBFile);

      // verification de taille !

      {
      if CharInSet(ExtractFileDrive(FBRRecord.IBFile)[1], ['A'..'Z', 'a'..'z']) then
      begin
        // DOTOGIL //
        if not (GetDiskFreeSpace(ExtractFileDrive(FBRRecord.IBFile)[1]) > (vFileSize * 2)) then // que deux fois car la base est déjà dessus en fait ... donc 3 avec le déjà present
        begin
          // DoLog('Disque : ' + ExtractFileDrive(FBRRecord.IBFile)[1]);
          // DoLog('  -> espace dispo : ' + IntToStr(GetDiskFreeSpace(ExtractFileDrive(FBRRecord.IBFile)[1])));
          // DoLog('  -> espace voulu : ' + IntToStr(Trunc(FileSize * 2.0)));
          ReturnValue := 2;
          Exit;
        end;
      end;
      }


      // DoLog('  -> sur le réseau, on ne vérifie pas...');
      // ProgressStepIt();

      try
        // shutdown
        if not DoShutDown(FBRRecord.IBFILE) then
        begin
          ReturnValue := 3;
          Exit;
        end;

        try
          // renommage du fichier
          try
            FLog := Format('Renommage %s => %s',[FBRRecord.IBFILE,OldName]);
            Synchronize(LogCallBack);
            MoveFile(PWideChar(FBRRecord.IBFILE), PWideChar(OldName));
          Except
            ReturnValue := 4;
            exit;
          end;

          // validation de la base
          if not DoValidate(OldName) then
            begin
              ReturnValue := 5;
              Exit;
            end;

          try
            try
              // backup
              if not DoBackup(OldName, TMPName, [boNoGarbageCollect]) then
              begin
                ReturnValue := 6;
                Exit;
              end;

              if not DoRestore(NewName, TMPName, [roReplace ,roOneAtATime], 4096) then
              begin
                ReturnValue := 7;
                Exit;
              end;

              // GFIX pourquoi ???
              {
              if not DoGFix(NewName) then
              begin
                ReturnValue := 8;
                Exit;
              end;
              }

              ReturnValue := 0;

            finally
              // On le Delete pas on le deplace vers /backup
              TFile.Move(TMPName,GBKName);
              vFiles.Add(GBKName);

              // on copie le .properties dans backup
              TFile.Copy(FBRRecord.PropertiesFile,vDestPropertiesFile);
              vFiles.Add(vDestPropertiesFile);
            end;
          finally
            // FreeAndNil(Verif);
          end;
        finally
          if ReturnValue = 0 then
          begin
            //  le .NEW devient le .IB
            MoveFile(PWideChar(NewName), PWideChar(FBRRecord.IBFILE));

            // Le OLD a désormais son propore répertoire de sauvegarde
            if FOLD_MAX>0 then
              begin
                  // On le déplace de .OLD en le renommant
                  // TFile.Move(OldName,vSAV_OLD);
                  If not(MoveFileEx(PChar(OldName), PChar(vSAV_OLD), MOVEFILE_COPY_ALLOWED or MOVEFILE_WRITE_THROUGH))
                    then
                      begin
                        ReturnValue:=18;
                      end;
                  CleanDir(vCheminFinalOld,'old',FOLD_MAX);
              end
            else DeleteFile(OldName);
            // -----------------------------------------------------------------

            // Compression de .GBK et de properties
            FLog  := Format('Compression %s',[ZipName]);
            Synchronize(LogCallBack);
            vRes7z := Compress7z(vFiles,ZipName);

            if vRes7Z<>0
              then ReturnValue:=17
              else
               begin
                  FLog  := Format('Compression %s OK ',[ZipName]);
                  Synchronize(LogCallBack);

                  Sleep(100);
                  vSource      := ZipName;
                  vDestination := vCheminFinal7z + ExtractFileName(ZipName);

                  if not(vIsFTP)
                    then
                      begin
                         If not(MoveFileEx(PChar(vSource), PChar(vDestination), MOVEFILE_COPY_ALLOWED or MOVEFILE_WRITE_THROUGH))
                          then
                            begin
                                FLog  := Format('Déplacement de %s vers %s : ERREUR',[vSource,vDestination]);
                                Synchronize(LogCallBack);
                                ReturnValue:=18;
                            end
                          else
                            begin
                                FLog  := Format('Déplacement de %s vers %s : OK',[vSource,vDestination]);
                                Synchronize(LogCallBack);
                            end;

                        // Nettoyage des fichiers .7z finalement on redescend à x fichiers
                        // DOTOGIL
                        CleanDir(vCheminFinal7z,'7z',FBACKUP_MAX);
                      end
                    else
                     begin
                        FStatus  := 'Dépôt FTP';
                        Synchronize(StatusCallBack);
                        if Not(FTPPut(vSource,vPort,vHost,vUserName,vPassword,vLame,vDossier))
                          then
                            begin
                              FLog  := 'Dépôt FTP : ERREUR';
                              Synchronize(LogCallBack);
                              ReturnValue:=18;
                            end
                          else
                        DeleteFile(vSource);
                     end;
               end;
          end
          else
          begin
            FLog  := 'Suppression de '+NewName;
            Synchronize(LogCallBack);
            DeleteFile(NewName);

            // On remet le .OLD
            FLog  := Format('Renommage %s => %s',[OldName,FBRRecord.IBFILE]);
            Synchronize(LogCallBack);
            MoveFile(PWideChar(OldName), PWideChar(FBRRecord.IBFILE));
          end;
        end;
      finally
        // Restart
        if not DoRestart(FBRRecord.IBFILE) then
          if ReturnValue = 0 then
            ReturnValue := 10;

        // On restart uniquement s'il etait démarrer au debut !
        if (ReturnValue=0) and (FBRRecord.EASYSERVICE<>'') and (vRunOnBegin)
          then
            begin
              FStatus  := 'Démarrage Service';
              Synchronize(StatusCallBack);

              FLog  := 'Démarrage Service '+FBRRecord.EASYSERVICE;
              Synchronize(LogCallBack);

              ServiceStart('',FBRRecord.EASYSERVICE);
              vBoucle:=0;
              while (ServiceGetStatus(PChar(''),Pchar(FBRRecord.EASYSERVICE))<>4) and (vboucle<50) do
                begin
                   Inc(vBoucle);
                   Sleep(200);
                end;
              // s'il n'est pas démarré ==> Erreur
              if (ServiceGetStatus(PChar(''),Pchar(FBRRecord.EASYSERVICE))<>4) then
                begin
                  ReturnValue := 14;
                end;
            end;
        // ---------------------------------------------------------------------
      end;
    except
      on e : Exception do
      begin
        // DoLog('!! Exception : ' + e.ClassName + ' - ' + e.Message);
        ReturnValue := 11;
      end;
    end;
  finally
    vFiles.DisposeOf;
  end;
end;



constructor TOptimizeDB.Create(aIBFile:TFileName;
//    aDossier        : string;
//    aServiceName    : string;
    aOptions        : string;
    aStatusCallBack : TStatusMessageCall;
    aLogCallBack    : TLogMessageCall;
    aEvent:TNotifyEvent=nil);
begin
    inherited Create(True);
    FStart          := GetTickCount();
    OnTerminate     := AEvent;
    FreeOnTerminate := True;
    FIBFile         := aIBFILE;
//    FDossier        := aDossier;
//    FServiceName    := aServiceName;
    FStatusProc     := aStatusCallBack;
    FLogProc        := aLogCallBack;
    Foptions        := aOptions;
    FnbErrors       := 0;
end;



destructor TOptimizeDB.Destroy();
begin
  Inherited;
end;

procedure TOptimizeDB.StatusCallBack();
begin
   if Assigned(FStatusProc) then  FStatusProc(FStatus);
end;

procedure TOptimizeDB.LogCallBack();
begin
   if Assigned(FLogProc) then  FLogProc(FLog);
end;

(*
function TOptimizeDB.DoStopService():Boolean;
begin
   Result := false;
   try
      FLog      := 'Arrêt Service '+FServiceName ;
      Synchronize(LogCallBack);
      ServiceStop('',FServiceName);
      // 10 secondes...
      Sleep(10000);
      if (ServiceGetStatus(PChar(''),Pchar(FServiceName))<>1) then
        begin
           Result := false;
           raise Exception.Create('Erreur à l''arrêt du service');
        end
      else
         begin
           Result    := true;
           FLog      := 'Arrêt Service '+FServiceName + ' : OK';
           Synchronize(LogCallBack);
         end;
   except
       on e : Exception do
         begin
           Inc(FNBErrors);
           FLog      := 'Arrêt Service '+FServiceName + ' : ERREUR';
           Synchronize(LogCallBack);
           Result    := False;
           Raise;
         end;
   end;
end;
*)
(*
function TOptimizeDB.DoStartService():Boolean;
var vBoucle:integer;
begin
   Result := false;
   try
      try
        FLog      := 'Démarrage Service '+FServiceName + '...';
        Synchronize(LogCallBack);
        ServiceStart('',FServiceName);
        Sleep(10000);
        // s'il n'est pas démarré ==> Erreur
        if (ServiceGetStatus(PChar(''),Pchar(FServiceName))<>4) then
           begin
              Result := false;
              raise Exception.Create('Erreur au redémarrage du service');
            end
        else
          begin
            Result    := true;
            FLog      := 'Démarrage Service '+FServiceName + ' : OK';
            Synchronize(LogCallBack);
          end;
      except
        on e : Exception do
          begin
            Inc(FNBErrors);
            FLog      := 'Démarrage Service '+FServiceName + ' : ERREUR';
            Synchronize(LogCallBack);
            Result    := False;
            Raise;
          end;
      end;
   finally

   end;
end;
*)

function TOptimizeDB.DoSweep() : boolean;
var Validate : TFDIBValidate;
begin
  FStatus   := 'Sweep';
  Synchronize(StatusCallBack);
  Result := false;
  Validate := TFDIBValidate.Create(nil);
  try
    try

      Validate.DriverLink := DataMod.FDPhysIBDriverLink;
      Validate.Options := [roValidateFull];
      Validate.Protocol := ipTCPIP;

      Validate.Host     := CST_HOST;
      Validate.Port     := CST_PORT;
      Validate.UserName := CST_BASE_USER;
      Validate.Password := CST_BASE_PASSWORD;

      Validate.Database := FIBFile;

      // Validate.OnProgress := LogDriverMessage;

      Validate.Sweep();
      Sleep(1000);

      FStatus      := 'Sweep : OK';
      Synchronize(StatusCallBack);
      Result    := true;
  except
    on e : Exception do
      begin
          Inc(FNBErrors);
          FStatus := 'Sweep : Error';
          Synchronize(StatusCallBack);
          Raise;
      end;
  end;
  finally
    FreeAndNil(Validate);
  end;
end;


procedure TOptimizeDB.Etape_Pre_Prurge();
var vCnx:TFDConnection;
    vQuerySelect,vQueryDelete:TFDQuery;
    i:integer;
    vBefore : TDateTime;
begin
    FStatus := 'Pré-Purge';
    if Assigned(FStatusProc) then Synchronize(StatusCallBack);
    FLog    := 'Pré-Purge';
    if Assigned(FLogProc) then Synchronize(LogCallBack);
    //-----------------------------------------------------
    vCnx   := DataMod.getNewConnexion('GINKOIA@'+FIBFile);
    vQuerySelect := DataMod.getNewQuery(vCnx,nil);
    vQueryDelete := DataMod.getNewQuery(vCnx,nil);
    try
      try
         // vCnx.Transaction.Options.AutoCommit := true;
         vCnx.open;
         If vCnx.Connected then
            begin
              // On en profite pour trouver le parametre de Purge ??? Non on purge tout ce qui est purgeable avant J-1
              vBefore :=  Now()-1;
              FStatus:=Format('Pré-Purge sur tous les parquets OK avant %s',[FormatDateTime('dd/mm/yyyy hh:nn:ss',vBefore)]);
              if Assigned(FStatusProc) then Synchronize(StatusCallBack);

              FLog:=Format('Pré-Purge sur tous les parquets OK avant %s',[FormatDateTime('dd/mm/yyyy hh:nn:ss',vBefore)]);
              if Assigned(FLogProc) then Synchronize(LogCallBack);

              vQuerySelect.Close;
              vQuerySelect.SQL.Clear;
              vQuerySelect.SQL.Add('SELECT BATCH_ID FROM SYM_OUTGOING_BATCH          ');
              vQuerySelect.SQL.Add(' WHERE status = ''OK'' AND CREATE_TIME<:ABEFORE  ');
              vQuerySelect.ParamByName('ABEFORE').AsDateTime := vBefore;
              vQuerySelect.OptionsIntf.UpdateOptions.ReadOnly := true;
              i:=0;
              vQuerySelect.Open();
              while not(vQuerySelect.eof) do
                begin
                   Inc(i);
                   if ((i mod 1000)=0)
                    then
                      begin
                         FStatus:=Format('Pré-Purge de SYM_DATA_EVENT : Boucle N° %d',[i]);
                         if Assigned(FStatusProc) then Synchronize(StatusCallBack);

                         FLog:=Format('Pré-Purge de SYM_DATA_EVENT : Boucle N° %d',[i]);
                         if Assigned(FLogProc) then Synchronize(LogCallBack);

                      end;
                   vQueryDelete.Close;
                   vQueryDelete.SQL.Clear;
                   vQueryDelete.SQL.Add('DELETE FROM SYM_DATA_EVENT WHERE BATCH_ID=:BATCHID');
                   vQueryDelete.ParamByName('BATCHID').AsLargeInt := vQuerySelect.FieldByName('BATCH_ID').AsLargeInt;
                   vQueryDelete.ExecSQL;
                   //
                   vQuerySelect.Next;
                END;
              vQuerySelect.Close;

              // ----- DELETE DES BATCHID --------------------------------------
              FStatus:=Format('Pré-Purge de SYM_DATA_EVENT terminée : %d Boucles',[i]);
              if Assigned(FStatusProc) then Synchronize(StatusCallBack);

              FLog:=Format('Pré-Purge de SYM_DATA_EVENT terminée : %d Boucles',[i]);
              if Assigned(FLogProc) then Synchronize(LogCallBack);

              // ----- DELETE DES BATCHID --------------------------------------
              FStatus:=Format('Purge de SYM_OUTGOING_BATCH : %d enregistrements à supprimer',[i]);
              if Assigned(FStatusProc) then Synchronize(StatusCallBack);

              FLog:=Format('Purge de SYM_OUTGOING_BATCH : %d enregistrements à supprimer',[i]);
              if Assigned(FLogProc) then Synchronize(LogCallBack);


              vQueryDelete.Close;
              vQueryDelete.SQL.Clear;
              vQueryDelete.SQL.Add('DELETE FROM SYM_OUTGOING_BATCH          ');
              vQueryDelete.SQL.Add(' WHERE status = ''OK'' AND CREATE_TIME<:ABEFORE  ');
              vQueryDelete.ParamByName('ABEFORE').AsDateTime := vBefore;
              vQueryDelete.ExecSQL;

              FStatus:='Pré-Purge Terminée';
              if Assigned(FStatusProc) then Synchronize(StatusCallBack);

              FLog:='Pré-Purge Terminée';
              if Assigned(FLogProc) then Synchronize(LogCallBack);


            end;
      Except On Ez : Exception do
          begin
             inc(FnbErrors);
             raise;
          end;
      end;
    finally
      vQueryDelete.DisposeOf;
      vQuerySelect.DisposeOf;
      vCnx.DisposeOf;
    end;
end;




procedure TOptimizeDB.Etape_Recalcul_Index_GINKOIA();
var vCnx:TFDConnection;
    vQuery:TFDQuery;
    i:integer;
    vIndexs : TIndexs;
begin
    FStatus:='Recalcul des Index GINKOIA';
    if Assigned(FStatusProc) then Synchronize(StatusCallBack);
    vCnx   := DataMod.getNewConnexion('SYSDBA@'+FIBFile);
    vQuery := DataMod.getNewQuery(vCnx,nil);
    try
      try
         // vCnx.Transaction.Options.AutoCommit := true;
         vCnx.open;
         If vCnx.Connected then
            begin
              // On en profite pour trouver le parametre de Purge
              {
              vQuery.Close;
              vQuery.SQL.Clear;
              vQuery.SQL.Add('SELECT RDB$INDEX_NAME, RDB$RELATION_NAME  ');
              vQuery.SQL.Add(' FROM RDB$INDICES                         ');
              vQuery.SQL.Add(' WHERE RDB$RELATION_NAME IN (''SYM_DATA'', ''SYM_DATA_EVENT'',''SYM_OUTGOING_BATCH'', ''AGRMOUVEMENT'', ''AGRHISTOSTOCK'') ');
              vQuery.OptionsIntf.UpdateOptions.ReadOnly := true;
              vQuery.Open();
              }

              vQuery.Close;
              vQuery.SQL.Clear;
              vQuery.SQL.Add('SELECT RDB$INDEX_NAME, RDB$RELATION_NAME  ');
              vQuery.SQL.Add(' FROM RDB$INDICES                         ');
              vQuery.SQL.Add(' WHERE RDB$RELATION_NAME NOT LIKE ''%$%''  ');
              vQuery.SQL.Add(' AND RDB$RELATION_NAME NOT LIKE ''SYM_%''  ');
              vQuery.SQL.Add(' ORDER BY RDB$RELATION_NAME               ');
              vQuery.OptionsIntf.UpdateOptions.ReadOnly := true;
              vQuery.Open();
              // Comme j'ai pas "locker cette transaction.. le temps du traitement"
              // je vais poser dans un array
              SetLength(vIndexs,0);
              while not(vQuery.eof) do
                begin
                   i:=Length(vIndexs);
                   SetLength(vIndexs,i+1);
                   vindexs[i].Index := vQuery.Fields[0].AsString;
                   vindexs[i].TABLE := vQuery.Fields[1].AsString;
                   vQuery.Next;
                end;
              vQuery.Close;


              for i := Low(vIndexs) to High(vIndexs) do
                begin
                  FStatus:=Format('Recalcul Index %s TABLE %s',[vIndexs[i].Index, vIndexs[i].Table]);
                  if Assigned(FStatusProc) then Synchronize(StatusCallBack);

                  FLog:=Format('Recalcul Index %s TABLE %s',[vIndexs[i].Index, vIndexs[i].Table]);
                  if Assigned(FLogProc) then Synchronize(LogCallBack);


                  vQuery.Close;
                  vQuery.SQL.Clear;
                  vQuery.SQL.Add(Format('SET STATISTICS INDEX %s;',[vIndexs[i].Index]));
                  vQuery.OptionsIntf.UpdateOptions.ReadOnly := False;
                  vQuery.ExecSQL;
                end;

               vQuery.Close;
            end;
      Except On Ez : Exception do
          begin
             inc(FnbErrors);
             raise;
          end;
      end;
    finally
      vQuery.DisposeOf;
      vCnx.DisposeOf;
    end;
end;


procedure TOptimizeDB.Etape_Recalcul_Index_SYMDS();
var vCnx:TFDConnection;
    vQuery:TFDQuery;
    i:integer;
    vIndexs : TIndexs;
begin
    FStatus:='Recalcul des Index SYMDS';
    if Assigned(FStatusProc) then Synchronize(StatusCallBack);

    FLog:='Recalcul des Index SYMDS';
    if Assigned(FLogProc) then Synchronize(LogCallBack);

    vCnx   := DataMod.getNewConnexion('SYSDBA@'+FIBFile);
    vQuery := DataMod.getNewQuery(vCnx,nil);
    try
      try
         // vCnx.Transaction.Options.AutoCommit := true;
         vCnx.open;
         If vCnx.Connected then
            begin
              // On en profite pour trouver le parametre de Purge
              {
              vQuery.Close;
              vQuery.SQL.Clear;
              vQuery.SQL.Add('SELECT RDB$INDEX_NAME, RDB$RELATION_NAME  ');
              vQuery.SQL.Add(' FROM RDB$INDICES                         ');
              vQuery.SQL.Add(' WHERE RDB$RELATION_NAME IN (''SYM_DATA'', ''SYM_DATA_EVENT'',''SYM_OUTGOING_BATCH'', ''AGRMOUVEMENT'', ''AGRHISTOSTOCK'') ');
              vQuery.OptionsIntf.UpdateOptions.ReadOnly := true;
              vQuery.Open();
              }

              vQuery.Close;
              vQuery.SQL.Clear;
              vQuery.SQL.Add('SELECT RDB$INDEX_NAME, RDB$RELATION_NAME  ');
              vQuery.SQL.Add(' FROM RDB$INDICES                         ');
              vQuery.SQL.Add(' WHERE RDB$RELATION_NAME NOT LIKE ''%$%''  ');
              vQuery.SQL.Add(' AND RDB$RELATION_NAME LIKE ''SYM_%''  ');
              vQuery.SQL.Add(' ORDER BY RDB$RELATION_NAME               ');
              vQuery.OptionsIntf.UpdateOptions.ReadOnly := true;
              vQuery.Open();
              // Comme j'ai pas "locker cette transaction.. le temps du traitement"
              // je vais poser dans un array
              SetLength(vIndexs,0);
              while not(vQuery.eof) do
                begin
                   i:=Length(vIndexs);
                   SetLength(vIndexs,i+1);
                   vindexs[i].Index := vQuery.Fields[0].AsString;
                   vindexs[i].TABLE := vQuery.Fields[1].AsString;
                   vQuery.Next;
                end;
              vQuery.Close;


              for i := Low(vIndexs) to High(vIndexs) do
                begin
                  FStatus:=Format('Recalcul Index %s TABLE %s',[vIndexs[i].Index, vIndexs[i].Table]);
                  if Assigned(FStatusProc) then Synchronize(StatusCallBack);

                  FLog:=Format('Recalcul Index %s TABLE %s',[vIndexs[i].Index, vIndexs[i].Table]);
                  if Assigned(FLogProc) then Synchronize(LogCallBack);

                  vQuery.Close;
                  vQuery.SQL.Clear;
                  vQuery.SQL.Add(Format('SET STATISTICS INDEX %s;',[vIndexs[i].Index]));
                  vQuery.OptionsIntf.UpdateOptions.ReadOnly := False;
                  vQuery.ExecSQL;
                end;

               vQuery.Close;
            end;
      Except On Ez : Exception do
          begin
             inc(FnbErrors);
             raise;
          end;
      end;
    finally
      vQuery.DisposeOf;
      vCnx.DisposeOf;
    end;
end;


procedure TOptimizeDB.Execute;
begin
   try
     FStatus:=Format('Base %s',[FIBFile]);
     if Assigned(FStatusProc) then Synchronize(StatusCallBack);

     FLog:=Format('Base %s',[FIBFile]);
     if Assigned(FLogProc) then Synchronize(LogCallBack);

     FLog:=Format('Options %s',[FOPTIONS]);
     if Assigned(FLogProc) then Synchronize(LogCallBack);

     (*
     FEtatServiceAuDebut := ServiceGetStatus(PChar(''),Pchar(FServiceName));

     if (Foptions[1]='1') and (FEtatServiceAuDebut=4) then
      begin
        DoStopService;
      end;
     *)

     if (Foptions[1]='1') then
      begin
        DoSweep;
      end;

    if (Foptions[2]='1') then
      begin
        Etape_Recalcul_Index_GINKOIA();
      end;

    if (Foptions[3]='1') then
      begin
        Etape_Pre_Prurge
      end;

    if (Foptions[4]='1') then
      begin
        Etape_Recalcul_Index_SYMDS();
      end;

    {
    if (Foptions[6]='1') and (FEtatServiceAuDebut=4) then
      begin
        DoStartService;
      end;
    }

    FTime := Ceil((GetTickCount()-FStart)/1000);

   Except
      //
   end;
end;



(*

constructor TOptimzeDataBase.Create(aBRRecord:TBRRecord;
    aOptions        : string;
    aStatusCallBack : TStatusMessageCall;
    aLogCallBack : TLogMessageCall;
    aEvent:TNotifyEvent=nil);
begin
    inherited Create(True);
    OnTerminate     := AEvent;
    FreeOnTerminate := True;
    FIBFile         := aBRRecord.IBFILE;
    FStatusProc     := aStatusCallBack;
    FLogProc        := aLogCallBack;
    Foptions        := aOptions;
    FEasyDir        := aBRRecord.EASYDIR;
    FnbError        := 0;
end;


destructor TOptimzeDataBase.Destroy();
begin
  Inherited;
end;

procedure TOptimzeDataBase.StatusCallBack();
begin
   if Assigned(FStatusProc) then  FStatusProc(FStatus);
end;

procedure TOptimzeDataBase.LogCallBack();
begin
   if Assigned(FLogProc) then  FLogProc(FLog);
end;

{ /// NON plus par gfix directement
procedure TOptimzeDataBase.Etape_Sweep();
var chaine:string;
    a:cardinal;
    merror:string;

begin
    try
      FStatus:='SWEEP';
      if Assigned(FStatusProc) then Synchronize(StatusCallBack);

      chaine := Format('-sweep -user SYSDBA -password masterkey %s',[FIBFile]);
      a:=ExecAndWaitProcess(merror, 'C:\Embarcadero\InterBase\bin\gfix', chaine);

      FLog:='SWEEP de la base : [OK]';
      if Assigned(FLogProc) then Synchronize(LogCallBack);
      Except On E:Exception do
        begin
          FLog:='SWEEP de la base : [ERREUR] ' + E.Message;
          Synchronize(LogCallBack);

          inc(FnbError);
          raise Exception.Create('Erreur au Sweep !');
        end;
      end;
end;
}

function TOptimzeDataBase.DoSweep() : boolean;
var Validate : TFDIBValidate;
begin
  FStatus   := 'Sweep';
  Synchronize(StatusCallBack);
  Result := false;
  Validate := TFDIBValidate.Create(nil);
  try
    try

      Validate.DriverLink := DataMod.FDPhysIBDriverLink;
      Validate.Options := [roValidateFull];
      Validate.Protocol := ipTCPIP;

      Validate.Host     := CST_HOST;
      Validate.Port     := CST_PORT;
      Validate.UserName := CST_BASE_USER;
      Validate.Password := CST_BASE_PASSWORD;

      Validate.Database := FIBFile;

      // Validate.OnProgress := LogDriverMessage;

      Validate.Sweep();
      Sleep(1000);

      FLog      := 'Sweep : OK';
      Synchronize(LogCallBack);
      Result    := true;
  except
    on e : Exception do
      begin
          FLog   := 'Sweep : Error';
          Synchronize(LogCallBack);
          Raise;
      end;
  end;
  finally
    FreeAndNil(Validate);
  end;
end;



procedure TOptimzeDataBase.Etape_Recalcul_Index();
var vCnx:TFDConnection;
    vQuery:TFDQuery;
    i:integer;
    vIndexs : TIndexs;
begin
    vCnx   := DataMod.getNewConnexion('SYSDBA@'+FIBFile);
    vQuery := DataMod.getNewQuery(vCnx,nil);
    try
      try
         vCnx.open;
         If vCnx.Connected then
            begin
              // On en profite pour trouver le parametre de Purge
              {
              vQuery.Close;
              vQuery.SQL.Clear;
              vQuery.SQL.Add('SELECT RDB$INDEX_NAME, RDB$RELATION_NAME  ');
              vQuery.SQL.Add(' FROM RDB$INDICES                         ');
              vQuery.SQL.Add(' WHERE RDB$RELATION_NAME IN (''SYM_DATA'', ''SYM_DATA_EVENT'',''SYM_OUTGOING_BATCH'', ''AGRMOUVEMENT'', ''AGRHISTOSTOCK'') ');
              vQuery.OptionsIntf.UpdateOptions.ReadOnly := true;
              vQuery.Open();
              }

              vQuery.Close;
              vQuery.SQL.Clear;
              vQuery.SQL.Add('SELECT RDB$INDEX_NAME, RDB$RELATION_NAME  ');
              vQuery.SQL.Add(' FROM RDB$INDICES                         ');
              vQuery.SQL.Add(' WHERE RDB$RELATION_NAME IN (''SYM_DATA'', ''SYM_DATA_EVENT'',''SYM_OUTGOING_BATCH'', ''AGRMOUVEMENT'', ''AGRHISTOSTOCK'') ');
              vQuery.OptionsIntf.UpdateOptions.ReadOnly := true;
              vQuery.Open();
              // Comme j'ai pas "locker cette transaction.. le temps du traitement"
              // je vais poser dans un array
              SetLength(vIndexs,0);
              while not(vQuery.eof) do
                begin
                   i:=Length(vIndexs);
                   SetLength(vIndexs,i+1);
                   vindexs[i].Index := vQuery.Fields[0].AsString;
                   vindexs[i].TABLE := vQuery.Fields[1].AsString;
                   vQuery.Next;
                end;
              vQuery.Close;


              for i := Low(vIndexs) to High(vIndexs) do
                begin
                  FLog:=Format('Recalcul Index %s TABLE %s',[vIndexs[i].Index, vIndexs[i].Table]);
                  if Assigned(FLogProc) then Synchronize(LogCallBack);

                  vQuery.Close;
                  vQuery.SQL.Clear;
                  vQuery.SQL.Add(Format('SET STATISTICS INDEX %s;',[vIndexs[i].Index]));
                  vQuery.OptionsIntf.UpdateOptions.ReadOnly := False;
                  vQuery.ExecSQL;
                end;

               vQuery.Close;
            end;
      Except On Ez : Exception do
          begin
             inc(FnbError);
             raise;
          end;
      end;
    finally
      vQuery.DisposeOf;
      vCnx.DisposeOf;
    end;
end;

procedure TOptimzeDataBase.Etape_PurgeSYMDS();
var vParam:string;
    a:cardinal;
    merror:string;
    vCmd : string;
begin
    try
      FStatus:='PURGE';
      if Assigned(FStatusProc) then Synchronize(StatusCallBack);

      vCmd   :=  FEasyDir+'\bin\symadmin';
      vParam := 'run-purge';

      FLog:=vCmd+' '+vParam;
      if Assigned(FStatusProc) then Synchronize(LogCallBack);

      a:=ExecAndWaitProcess(merror,vCmd, vParam);

      FLog:='Resultat : '+intToStr(a);
      if Assigned(FStatusProc) then Synchronize(LogCallBack);

      FLog:='Error : '+mError;
      if Assigned(FStatusProc) then Synchronize(LogCallBack);

      FLog:='PURGE de la base : [FIN]';
      if Assigned(FStatusProc) then Synchronize(LogCallBack);

      Except On E:Exception do
        begin
          FLog:='PURGE de la base : [ERREUR] ' + E.Message;
          Synchronize(LogCallBack);

          inc(FnbError);
          raise Exception.Create('Erreur à la Purge !');
        end;
      end;
end;


procedure TOptimzeDataBase.Execute;
begin
   try
    if (Foptions[1] = '1') then
      begin
        // Etape_Sweep();
        DoSweep;
      end;

    if (Foptions[2]) = '1' then
      begin
        Etape_Recalcul_Index();
      end;

    if (Foptions[3] = '1') then
      begin
        Etape_PurgeSYMDS();
      end;
   Except
      //
   end;
end;
*)

constructor TScriptCleanSYMDS.Create(aMode : string;aServerTOTOFile,aLocalTOTOFile:TFileName;aGENID: integer;aStatusCallBack   : TStatusMessageCall; aEvent:TNotifyEvent=nil);
begin
    inherited Create(True);
    OnTerminate     := AEvent;
    FreeOnTerminate := True;
    FMODE       := aMode;
    FGENID      := aGENID;
    FStatusProc := aStatusCallBack;
    FServeurTOTOFile := aServerTOTOFile;
    FTOTOFile   := aLocalTOTOFile;
    FBASE0      := Readbase0;
    FDATADir    := ExtractFilePath(FBASE0);

    if (FMODE=CST_DEJAEASY)
      then
          begin
              FSAV     := ChangeFileExt(FBASE0,FormatDateTime('_yyyymmdd_hhnnss',Now())+'.sav');
              FNEWNAME := FDATADir + 'GINKOIA.IB';
          end;

    if (FMODE=CST_DELOS2EASY)
      then
        begin
            FSAV := ChangeFileExt(FBASE0,'.sav_delos');
            FNEWNAME := FDATADir + 'DELOS2EASY.IB';
        end;



 //   FDELOS2EASy := FDATADir + 'DELOS2EASY.IB';


    FGENERATEUR_EXE := FDATADir + 'generateur.exe';
end;

destructor TScriptCleanSYMDS.Destroy();
begin
  Inherited;
end;

procedure TScriptCleanSYMDS.StatusCallBack();
begin
   if Assigned(FStatusProc) then  FStatusProc(FStatus);
end;

procedure TScriptCleanSYMDS.Etape_Controles;
var vCnx:TFDConnection;
    vQuery:TFDQuery;
    i:integer;
begin
    vCnx   := DataMod.getNewConnexion('SYSDBA@'+FNEWNAME);
    vQuery := DataMod.getNewQuery(vCnx,nil);
    try
      try
         vCnx.open;
         If vCnx.Connected then
            begin
              // Est-ce bien tout clean de EASY ?
              //
              vQuery.Close;
              vQuery.SQL.Clear;
              vQuery.SQL.Add('SELECT DISTINCT RDB$RELATION_NAME     ');
              vQuery.SQL.Add(' FROM RDB$RELATION_FIELDS             ');
              vQuery.SQL.Add(' WHERE RDB$SYSTEM_FLAG=0              ');
              vQuery.SQL.Add(' AND RDB$RELATION_NAME LIKE ''SYM_%'' ');
              vQuery.Open();
              If not(vQuery.IsEmpty) 
                then raise Exception.Create('Erreur au contrôle : il reste des TABLES de SYM*');
              
              vQuery.Close;
              vQuery.SQL.Clear;
              vQuery.SQL.Add('SELECT RDB$GENERATOR_NAME  ');
              vQuery.SQL.Add(' FROM RDB$GENERATORS       ');
              vQuery.SQL.Add(' WHERE RDB$SYSTEM_FLAG=0   ');
              vQuery.SQL.Add(' AND RDB$GENERATOR_NAME=''GEN_SYM_DATA_DATA_ID'' ');
              vQuery.Open();
              
              If not(vQuery.IsEmpty) 
                then raise Exception.Create('Erreur au contrôle : le générateur GEN_SYM_DATA_DATA_ID existe déjà');

              // PRM_TYPE=80 PRM_CODE=1 vide si en Mode DELOS2EASY (Minisplit)
              if FMODE=CST_DELOS2EASY then
                begin
                    vQuery.Close;
                    vQuery.SQL.Clear;
                    vQuery.SQL.Add('SELECT * FROM GENPARAM ');
                    vQuery.SQL.Add(' WHERE PRM_TYPE=80 AND PRM_CODE=1 ');
                    vQuery.Open();

                    If not(vQuery.IsEmpty)
                      then raise Exception.Create('Erreur au contrôle : URL d''EASY déjà présente !');
                end;

              // les générateurs sont-t-ils bien justes ?
              vQuery.Close;
              vQuery.SQL.Clear;                                                            
              vQuery.SQL.Add('SELECT GEN_ID(GENERAL_ID,0) FROM RDB$DATABASE;');
              vQuery.Open();

              If (vQuery.Fields[0].asinteger<>FGENID) 
                then raise Exception.Create('Erreur au contrôle : Problème dans les générateurs !');
              
              FStatus:=Format('Contrôles dans %s : [OK]',[ExtractFileName(FNEWNAME)]);
              Synchronize(StatusCallBack);
            end;
      Except On Ez : Exception do
          begin
             inc(FnbError);
             raise;
          end;
      end;
    finally
      vQuery.DisposeOf;
      vCnx.DisposeOf;
    end;
end;

procedure TScriptCleanSYMDS.Etape_RenameBaseTOTO;
var chaine:string;
    merror:string;
    a:cardinal;
begin
     try
        try
          If not(RenameFile(FTOTOFile, FNEWNAME))
            then
              begin
                raise Exception.Create('Erreur au renommage');
              end;

          FSTATUS:=Format('Renommage de la base %s en %s : [OK]',[ExtractFileName(FTOTOFile),ExtractFileName(FNEWNAME)]);
          Synchronize(StatusCallBack);

        Except On E:Exception do
          begin
            inc(FnbError);
            Raise;
          end;
        end;
     finally
        // Synchronize(StatusCallBack);
     end;
end;


procedure TScriptCleanSYMDS.Etape_RenameBase0;
var chaine:string;
    merror:string;
    a:cardinal;
begin
     try
        try
          If not(RenameFile(FBASE0, FSAV))
            then
              begin
                raise Exception.Create('Erreur au renommage');
              end;
          FStatus:=Format('Renommage de la base %s en %s : [OK]',[ExtractFileName(FBASE0),ExtractFileName(FSAV)]);
          Synchronize(StatusCallBack);
        Except On E:Exception do
          begin
            inc(FnbError);
            raise;
          end;
        end;
     finally
        // Synchronize(StatusCallBack);
     end;
end;


procedure TScriptCleanSYMDS.Etape_SetGenerateurs;
var vCnx:TFDConnection;
    vQuery:TFDQuery;
    vScript : TStringList;
    i:integer;
    vFile:string;
begin
    vCnx   := DataMod.getNewConnexion('SYSDBA@'+FTOTOFile);
    vQuery := DataMod.getNewQuery(vCnx,nil);
    vScript := TStringList.Create;
    try
      try
         vCnx.open;
         If vCnx.Connected then
            begin
                vFile := FDATADir + 'generateur.sql';
                vScript.LoadFromFile(vFile);
                for I:=0 to vScript.Count-1 do
                  begin
                      vQuery.Close;
                      vQuery.SQL.Clear;
                      vQuery.SQL.Add(vScript.Strings[i]);
                      vQuery.ExecSQL;
                  end;
              vQuery.Close;
            end;
         FStatus:='Affectation des générateurs : [OK]';
         Synchronize(StatusCallBack);
      Except On Ez : Exception do
          begin
            inc(FnbError);
            raise;
          end;
      end;
    finally
      vScript.DisposeOf;
      vQuery.DisposeOf;
      vCnx.DisposeOf;
    end;
end;

procedure TScriptCleanSYMDS.Etape_Copie_From_Serveur();
begin
     try
        try
          FSTATUS:= Format('Copie depuis le serveur %s > %s',[FServeurTOTOFile,FTOTOFile]);
          Synchronize(StatusCallBack);

          try
            TFile.Copy(FServeurTOTOFile, FTOTOFile)
          except
              raise Exception.Create('Erreur lors de la copie depuis le serveur');
          end;

          FSTATUS:='Copie depuis le serveur : [OK]';
          Synchronize(StatusCallBack);

        Except On E:Exception do
          begin
            inc(FnbError);
            Raise;
          end;
        end;
     finally
        // Synchronize(StatusCallBack);
     end;
end;


procedure TScriptCleanSYMDS.Etape_GetGenerateurs;
var chaine:string;
    merror:string;
    a:cardinal;
    vSQLFile : string;
begin
     try
        try
          // Suppression de l'ancien fichier 
          vSQLFile := FDATADir + 'generateur.sql';
          
          FStatus:='Suppression de '+ ExtractFileName(vSQLFile); 
          Synchronize(StatusCallBack);
          DeleteFile(FDATADir + 'generateur.sql');
        
          chaine:='';
          a:=ExecAndWaitProcess(merror, FGENERATEUR_EXE, chaine);
          if (FileExists(vSQLFile))
            then
              begin
                FSTATUS:='Récupération des générateurs : [OK]';
                Synchronize(StatusCallBack);
              end
            else raise Exception.Create('Erreur générateurs');
        Except On E:Exception do
          begin
            inc(FnbError);
            raise;
          end;
        end;
     finally
        // Synchronize(StatusCallBack);
     end;
end;




procedure TScriptCleanSYMDS.Etape_ShutDown;
var chaine:string;
    merror:string;
    a:cardinal;
begin
     try
        try

          chaine := Format('-shut -force 5 -user SYSDBA -password masterkey %s',[FTOTOFile]);
          a:=ExecAndWaitProcess(merror, 'C:\Embarcadero\InterBase\bin\gfix', chaine);

          FSTATUS:=Format('Arrêt de la base %s : [OK]',[ExtractFileName(FTOTOFile)]);
          Synchronize(StatusCallBack);
        Except On E:Exception do
          begin
            inc(FnbError);
            Raise Exception.Create('Erreur Arrêt de la base');
          end;
        end;
     finally
        // Synchronize(StatusCallBack);
     end;
end;


procedure TScriptCleanSYMDS.Etape_Restart;
var chaine:string;
    merror:string;
    a:cardinal;
begin
     try
        try
          chaine := Format('-online -user SYSDBA -password masterkey %s',[FTOTOFile]);
          a:=ExecAndWaitProcess(merror, 'C:\Embarcadero\InterBase\bin\gfix', chaine);

          FSTATUS:=Format('Restart de la base %s : [OK]',[ExtractFileName(FTOTOFile)]);
          Synchronize(StatusCallBack);
        Except On E:Exception do
          begin
            inc(FnbError);
            Raise Exception.Create('Erreur au Restart de la base');
          end;
        end;
     finally
        // Synchronize(StatusCallBack);
     end;
end;


procedure TScriptCleanSYMDS.Etape_Clean_EASY_TmpDir();
var ShOp: TSHFileOpStruct;

begin
  ShOp.Wnd := 0;
  ShOp.wFunc := FO_DELETE;
  ShOp.pFrom := PChar(FDATADir + '..\EASY\tmp\*.*'#0);
  ShOp.pTo := nil;
  ShOp.fFlags := 0 or FOF_ALLOWUNDO;
  SHFileOperation(ShOp);
end;


procedure TScriptCleanSYMDS.Execute;
var vQuery  : TFDQuery;
begin
    try
      try
        if FMode=CST_DEJAEASY
          then
            begin

              // Stop de EASY
              ServiceStop('','EASY');
              FStatus:= 'Arrêt du Service EASY';
              Synchronize(StatusCallBack);
              Sleep(5000);


              // Kill LauncherEASY
              FStatus:= 'Kill du LauncherEASY';
              Synchronize(StatusCallBack);
              KillProcess('LauncherEASY.exe');
              Sleep(2000);

              // Nettoyage de /EASY/tmp/
              Etape_Clean_EASY_TmpDir();

              If not(FileExists(FTOTOFile)) and (FServeurTOTOFile<>'')
                  then
                    begin
                        Etape_Copie_From_Serveur();
                    end;

              Etape_GetGenerateurs();

              Etape_RenameBase0();

              Etape_ShutDown();

              Etape_SetGenerateurs();

              FStatus:= Format('Nettoyage SymmetricDS dans %s',[ExtractFileName(FTOTOFile)]);
              Synchronize(StatusCallBack);
              DataMod.DROP_SYMDS(FTOTOFile);

              // NON on ne nettoye pas le GENPARAM !
              // on nettoie uniquement pour un minisplit
              // FStatus:=Format('Nettoyage GENPARAM dans %s',[ExtractFileName(FTOTOFile)]);
              // Synchronize(StatusCallBack);
              //DataMod.DeleteGenParamURL(FTOTOFile);

              Etape_Restart();

              Etape_RenameBaseTOTO;

              // ---------------------------------------------------------------------
              // Controles ?
              Etape_Controles;

              // Start EASy
              ServiceStart('','EASY');
              FStatus:= 'Démarrage Service EASY';
              Synchronize(StatusCallBack);
              Sleep(5000);

            end;

        if FMode=CST_DELOS2EASY then
          begin
            If not(FileExists(FTOTOFile)) and (FServeurTOTOFile<>'')
                then
                  begin
                      Etape_Copie_From_Serveur();
                  end;

            Etape_GetGenerateurs();

            Etape_RenameBase0;

            Etape_ShutDown();

            Etape_SetGenerateurs();

            FStatus:= Format('Nettoyage SymmetricDS dans %s',[ExtractFileName(FTOTOFile)]);
            Synchronize(StatusCallBack);
            DataMod.DROP_SYMDS(FTOTOFile);

            FStatus:=Format('Nettoyage GENPARAM dans %s',[ExtractFileName(FTOTOFile)]);
            Synchronize(StatusCallBack);
            DataMod.DeleteGenParamURL(FTOTOFile);

            Etape_Restart();

            Etape_RenameBaseTOTO;

            // ---------------------------------------------------------------------
            // Controles ?
            Etape_Controles;
          end;
      Except
        On E:Exception do
          begin
            FSTATUS := E.Message;
            Synchronize(StatusCallBack);
          end;
      end;

    finally
      //
    end;
end;


destructor TQueryMVTThread.Destroy();
begin
  FTrans.DisposeOf;
  Inherited;
end;

constructor TQueryMVTThread.Create(ACnx:TFDConnection; aSens:string; aNodeID:string; aGENID:Integer;
      aMinKVERSION,aMaxKVERSION:integer;
      aDebut,aFin: TDateTime;
      aCount     : integer;
      aForceUpdated : Boolean;
      aProgressCallBack : TProgressMessageCall;
      aStatusCallBack      : TStatusMessageCall;
      aTpsRestantCallback  : TInfosMessageCall;
      aLinesDoneCallback   : TInfosMessageCall;
      aEvent:TNotifyEvent=nil);
begin
    inherited Create(True);
    OnTerminate     := AEvent;
    FreeOnTerminate := True;

    FStatusProc         := aStatusCallBack;
    FProgressProc       := aProgressCallBack;
    FTpsRestantProc     := aTpsRestantCallBack;
    FLinesDoneProc      := aLinesDoneCallback;
    FForceUpdated    := aForceUpdated;
    FSens           := aSens;  // LAME2MAG ou MAG2LAME
    FStatus         := '';
    FLinesDone      := 0;
    FStopped        := false;
    FCnx            := ACnx;
    FTrans          := DataMod.getNewTransaction(Fcnx);
    FNODEID         := aNodeID;
    FGENID          := aGENID;
    FMinKVERSION    := aMinKVERSION;
    FMaxKVERSION    := aMaxKVERSION;
    FDebut          := aDebut;
    FFin            := aFin;
    FCount          := aCount;

end;

procedure TQueryMVTThread.ProgressCallBack();
begin
   if Assigned(FProgressProc) then  FProgressProc(FProgress);
end;

procedure TQueryMVTThread.StatusCallBack();
begin
   if Assigned(FStatusProc) then  FStatusProc(FStatus);
end;

procedure TQueryMVTThread.TpsRestantCallBack();
begin
   if Assigned(FTpsRestantProc) then  FTpsRestantProc(FTpsRestantInt);
end;

procedure TQueryMVTThread.LinesDoneCallBack();
begin
   if Assigned(FLinesDoneProc) then  FLinesDoneProc(FLinesDone);
end;

procedure TQueryMVTThread.Execute;
var vQuery  : TFDQuery;
    i       : integer;
    vQMVT   : TFDQuery;
    // vCount  : integer;
    vStart  : Cardinal;
    vNow    : Cardinal;
    vDejaPasse : Double;
    vEstimationEnd : Double;
    vEtimmationRestant : double;
begin
    vQuery := DataMod.GetNewQuery(FCnx,nil);
    vStart := GetTickCount;
    try
      vQMVT := DataMod.GetNewQuery(FCnx,FTrans);
      vQMVT.Close;
      vQMVT.SQL.Clear;
      if FSens=CST_LAME2MAG
        then vQMVT.SQL.Add('EXECUTE PROCEDURE EASY_MVT_LAME2MAG(:KID,:TONODE);');

      if FSens=CST_MAG2LAME
        then vQMVT.SQL.Add('EXECUTE PROCEDURE EASY_MVT_MAG2LAME(:KID,:TONODE);');

      vQuery.Close;
      vQuery.SQL.Add('SELECT K_ID, K_VERSION FROM K WHERE K_VERSION>=:ADEB AND K_VERSION<=:AFIN');

      vQuery.ParamByName('ADEB').Asinteger := FMINKVERSION;
      vQuery.ParamByName('AFIN').Asinteger := FMAXKVERSION;

      if FForceUpdated then
          begin
              vQuery.SQL.Add('AND K_UPDATED>=:DATEDEB AND K_UPDATED<=:DATEFIN');
              vQuery.ParamByName('DATEDEB').AsDateTime := FDEBUT;
              vQuery.ParamByName('DATEFIN').AsDateTime := FFIN;
          end;
      vQuery.SQL.Add(' ORDER BY K_VERSION');

      vQuery.OptionsIntf.FetchOptions.Unidirectional:=true;
      vQuery.UpdateOptions.ReadOnly := true;

      // vCount := FMAXKVERSION - FMINKVERSION;
      vQuery.Open();
      i:=0;
      while not(vQuery.Eof) do
        begin
            if (i mod 500=0) then
              begin
                 If (FTrans.Active)
                  then
                    begin
                      // Commit de Transaction
                      FTrans.Commit;

                      // -----------------------------------
                      // MAJ VCL
                      FProgress := i;
                      Synchronize(ProgressCallBack);

                      FStatus   := Format('%d/%d',[FProgress,FCount]);
                      Synchronize(StatusCallBack);

                      vNow := GetTickCount;
                      vDejaPasse := (vNow-vStart)/1000;
                      vEstimationEnd := (FCount*(vNow-vStart)/FProgress) / 1000;
                      vEtimmationRestant :=  vEstimationEnd-vDejaPasse;
                      FTpsRestantInt := Round(vEtimmationRestant);
                      Synchronize(TpsRestantCallBack);

                      FLinesDone := i;
                      Synchronize(LinesDoneCallBack);
                      // MAJ VCL
                      // -----------------------------------

                      if Terminated
                        then
                          begin
                            FStopped    := true;
                            FCount      := i;
                            exit;
                          end;

                      // Debut Nouvelle Transaction
                      GetTickCount;
                      FTrans.StartTransaction;
                    end
                 else FTrans.StartTransaction;
              end;
            if (FTrans.Active)
             then
                begin
                  vQMVT.Close;
                  vQMVT.ParamByName('KID').AsInteger:=vQuery.FieldByName('K_ID').AsInteger;
                  vQMVT.ParamByName('TONODE').Asstring:=FNODEID;
                  vQMVT.ExecSQL;
                end;
             Inc(i);
             vQuery.Next;
        end;

      FCount := i;

      If (FTrans.Active)
        then FTrans.Commit;

      // -----------------------------------
      // MAJ VCL
      FProgress := FMAXKVERSION - FMINKVERSION;
      Synchronize(ProgressCallBack);

      FStatus   := Format('%d/%d',[FCount,FCount]);
      Synchronize(StatusCallBack);

      FTpsRestantInt := 0;
      Synchronize(TpsRestantCallBack);

      FLinesDone := i;
      Synchronize(LinesDoneCallBack);
      // MAJ VCL
      // -----------------------------------

      vQMVT.Close;
      vQuery.Close;
    finally
      vQuery.DisposeOf;
      vQMVT.DisposeOf;
    end;
end;



constructor TQueryDeltaThread.Create(ACnx:TFDConnection; aQuery:TFDQuery; aGENID:Integer; aEvent:TNotifyEvent=nil);
begin
  inherited Create(True);
  FCnx   := aCnx;
  FQuery := aQuery;
  FGENID     := aGENID;
  FMinKVERSION  := 0;
  FMaxKVERSION  := Int32.MaxValue;
  OnTerminate := AEvent;
  FreeOnTerminate := True;
end;

procedure TQueryDeltaThread.Execute;
var v:string;
begin
  try
    if Pos('SELECT',FQuery.SQL.Text)=1
      then FQuery.Open;

    if not(FQuery.IsEmpty) then
      begin
        FMinKVERSION := FQuery.Fields[0].AsInteger;
        FMaxKVERSION := FQuery.Fields[1].AsInteger;
        FCOUNT       := FQuery.Fields[2].AsInteger; // FMaxKVERSION - FMinKVERSION + 1; // à cause de l'effet de bord...
      end;
  except
    On E:Exception do
      begin
        v:=E.MEssage;
        FMinKVERSION := 0;
        FMaxKVERSION := 0;
      end;
  end;
end;




constructor TQueryThread.Create(ACnx:TFDConnection; aQuery:TFDQuery; aEvent:TNotifyEvent=nil);
begin
  inherited Create(True);
  FCnx   := aCnx;
  FQuery := aQuery;
  OnTerminate := AEvent;
  FreeOnTerminate := True;
end;

procedure TQueryThread.Execute;
begin
  try
    Resultat := 0;
    // Suivant le FQuery.

    if Pos('EXECUTE',FQuery.SQL.Text)=1
      then FQuery.ExecSQL;

    if Pos('SELECT',FQuery.SQL.Text)=1
      then FQuery.Open;

    if not(FQuery.IsEmpty) then
      begin
        Resultat := FQuery.Fields[0].AsInteger;
      end;
  except
    Resultat := -1;
  end;
end;


constructor TQueryDichotomicKVersionThread.Create(ACnx:TFDConnection; aPlage:string;aGENID:Integer;
        aForceUPDATED:boolean;
        aDateDeb,aDateFin:TDateTime;
        aEvent:TNotifyEvent=nil);
var vDeb,vFin:integer;
begin
  inherited Create(True);
  FCnx   := aCnx;
//  vQuery := TFDQuery.Create(nil); // ou dans le Execute..

  DecodePlage(aPlage,vDeb,vFin);
  FPLAGEDEB := vDeb * 1000000;

  FForceUPDATED := aForceUPDATED;

  FGENID     := aGENID;

  FMinK.K_VERSION  := 0;
  FMaxK.K_VERSION  := Int32.MaxValue;

  FDateDeb       := aDateDeb;
  FDateFin       := aDateFin;

  OnTerminate := AEvent;
  FreeOnTerminate := True;

end;

{
function  TQueryDichotomicKVersionThread.Get_DateTime(aKVERSION:Integer):TDateTime;
var FQuery :TFDQuery;
begin;
  FQuery := DataMod.getNewQuery(FCnx,nil);
  Result := 0;
  try
    FQuery.SQL.Clear();
    FQuery.SQL.Add('SELECT K_UPDATED ');
    FQuery.SQL.Add(' FROM K WHERE K_VERSION=:VERSION');
    FQuery.ParamByName('VERSION').AsInteger := aKVERSION;
    FQuery.Open();
    if not(FQuery.IsEmpty) then
      begin
          Result  := FQuery.Fields[0].asDateTime;
      end;
    FQuery.Close;
  finally
    FQuery.DisposeOf;
  end;
end;
}

function  TQueryDichotomicKVersionThread.Analyse_Depuis(aStart:Integer;aTranche:integer):TKVersion;
var  FQuery :TFDQuery;
     i:integer;
     vDone:boolean;
     vCur:Integer;
begin;
  FQuery := DataMod.getNewQuery(FCnx,nil);
  Result.K_VERSION := 0;
  Result.DATETIME  := 0;
  try
    i:=0;
    vDone:=false;
    vCur := aStart;
    while not(vDone) and (i<5) do  // initialement 5 ==> on passe à 10
      begin
          Inc(i);
          FQuery.SQL.Clear();
          FQuery.SQL.Add('SELECT MIN(K_VERSION), MAX(K_VERSION), MAX(K_UPDATED) AS MAX_KUPDATED, ');
          FQuery.SQL.Add(' MAX(K_INSERTED) FROM K WHERE K_VERSION>=:DEB AND K_VERSION<:FIN       ');
          FQuery.ParamByName('DEB').AsInteger := vCur;
          FQuery.ParamByName('FIN').AsInteger := vCur+aTranche;
          FQuery.Open();
          if not(FQuery.IsEmpty) then
            begin
                Result.K_VERSION := FQuery.Fields[1].asinteger;
                Result.DATETIME  := FQuery.Fields[2].asDateTime;
                vDone:=true;
            end;
      end;
    FQuery.Close;
  finally
    FQuery.DisposeOf;
  end;


end;

function TQueryDichotomicKVersionThread.CalculCount():integer;
var vQuery :TFDQuery;
     i:integer;
     vDone:boolean;
     vCur:Integer;
begin;
  vQuery := DataMod.getNewQuery(FCnx,nil);
  Result:= 0;
  try
    vQuery.Close();
    vQuery.SQL.Clear;
    vQuery.SQL.Add('SELECT COUNT(*) FROM K WHERE K_VERSION>=:DEBVERSION AND K_VERSION<=:FINVERSION ');

    vQuery.ParamByName('DEBVERSION').AsInteger := FMINK.K_VERSION;
    vQuery.ParamByName('FINVERSION').AsInteger := FMAXK.K_VERSION;
    if FForceUPDATED then
      begin
        vQuery.SQL.Add(' AND K_UPDATED>=:DEB ');
        vQuery.SQL.Add(' AND K_UPDATED<=:FIN ');
        vQuery.ParamByName('DEB').AsDateTime        := FDateDeb;
        vQuery.ParamByName('FIN').AsDateTime        := FDateFin;
      end;

    vQuery.Open();
    If not(vQuery.IsEmpty)
      then result := vQuery.Fields[0].asinteger;
  finally
    vQuery.DisposeOf;
  end;
end;

function TQueryDichotomicKVersionThread.TrouveBorne(aDate:TDateTime;aLower:boolean):TKVersion;
                                                                    // alower = true borneInf
                                                                    // aLower = false BorneSup
var vA,vB:int64; // intervalle à analyse...
    vPas:integer;
    vK_A,vK_B,VK_I,VK_J,VK_K:TKVersion;
    vI,vJ,vK:Int64;
    vPass : boolean;
    vBoucle : integer;
    vResult : TKVersion;
begin
   // Max(FGENID-10000000,
  vA := FPLAGEDEB;  // !!  10 millions de K_VERSION ca commence à faire !
  vB := FGENID;
  // On a analyse à partir de vA
  vPas := 1000; // tranches de 1000
  vK_A := Analyse_Depuis(vA,vPas);
  vK_B := Analyse_Depuis(vB,vPas);

  vI   := vA;
  vJ   := (vB+vA) div 2;
  vK   := vB;

  vResult.K_VERSION := FGENID;
  vResult.DATETIME  := Now();
  try
  if aLower=true
    then vResult := vK_A  // vA
    else vResult := vK_B;  // VB

  vBoucle :=0;
  while (Abs(vK-vI)>1000) and (vBoucle<20) do
    begin
      inc(vBoucle);
      vPass := false;
      VK_I  := Analyse_Depuis(vI,vPas);
      VK_J  := Analyse_Depuis(vJ,vPas);
      VK_K  := Analyse_Depuis(vK,vPas);

      // Si le K_VERSION autour du milieu n'existe pas
      if VK_J.K_VERSION=0 then exit;

      if (vK_I.DATETIME<aDate) and (aDate<vK_J.DATETIME) then
         begin
           // le bon c'est entre I et J
           // vI reste le même
           if aLower
             then vResult := vK_I
             else vResult := vK_J;
           vK:=vJ;
           vPass:=true;
         end;
      if (vK_J.DATETIME<aDate) and (aDate<vK_K.DATETIME) then
         begin
           // le bon c'est entre J et K
           // vK reste le même c'est le I qui monte
           if aLower
             then vResult := vK_J
             else vResult := vK_K;
           vI:=vJ;
           vPass:=true;
         end;
       // si le Delta est iné
       if (vPass)
         then vJ:=(vK+vI) div 2
         else exit;
    end;

  finally
    Result := vResult;
  end;
end;

procedure TQueryDichotomicKVersionThread.Execute();
begin
  inherited;
  try
    FMinK := TrouveBorne(FDateDeb,true);
    FMaxK := TrouveBorne(FDateFin,false);
    if Abs(FMAXK.K_VERSION-FMinK.K_VERSION)>1000000
      then FCOUNT := FMaxK.K_VERSION - FMinK.K_VERSION + 1
      else FCOUNT := CalculCount();
  finally

  end;
end;




end.
