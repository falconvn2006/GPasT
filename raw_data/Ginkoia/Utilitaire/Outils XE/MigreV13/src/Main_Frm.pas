unit Main_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, IB_Components, IBODataset, ComCtrls, DB;

const
  CODE_RETOUR_OK                    =   0;
  CODE_RETOUR_ERREUR_IB             =  11;
  CODE_RETOUR_ERREUR_PARAM          =  12;

  CODE_RETOUR_ERREUR_TRT_LAUNCHED   =  21;

  CODE_RETOUR_ERREUR_BASE_LAME      =  31;
  CODE_RETOUR_ERREUR_BASE_PLATFORM  =  32;
  CODE_RETOUR_ERREUR_BASE_SITE      =  33;
  CODE_RETOUR_ERREUR_BASE_VERSION   =  34;
  CODE_RETOUR_ERREUR_ALREADY_DONE   =  35;

  CODE_RETOUR_ERREUR_VERIF_SP2k     =  41;
  CODE_RETOUR_ERREUR_VERIF_GRPPUMP  =  42;

  CODE_RETOUR_ERREUR_TUNNING_BEGIN  =  51;
  CODE_RETOUR_ERREUR_TUNNING_END    =  52;

  CODE_RETOUR_ERREUR_SAUVEGARDE     =  61;
  CODE_RETOUR_ERREUR_BACKUP_NOFILE  =  64;
  CODE_RETOUR_ERREUR_BACKUP_FAIL    =  65;
  CODE_RETOUR_ERREUR_RESTORE_FAIL   =  66;

  CODE_RETOUR_ERREUR_REPLIC_NOFILE  =  71;
  CODE_RETOUR_ERREUR_REPLIC_FAIL    =  72;

  CODE_RETOUR_ERREUR_NO_GUID        =  81;

  CODE_RETOUR_ERREUR_NETTOYAGE      =  91;

  CODE_RETOUR_ERREUR_RECACUL        = 101;
  CODE_RETOUR_ERREUR_SCRIPT         = 102;
  CODE_RETOUR_ERREUR_DOWNLOAD       = 103;
  CODE_RETOUR_ERREUR_CTE            = 104;
  CODE_RETOUR_ERREUR_PRECORRECTION  = 105;
  CODE_RETOUR_ERREUR_NMK            = 106;
  CODE_RETOUR_ERREUR_TAILLE         = 107;
  CODE_RETOUR_ERREUR_STOCK_HIS      = 108;
  CODE_RETOUR_ERREUR_STOCK_COUR     = 109;
  CODE_RETOUR_ERREUR_MVT            = 110;
  CODE_RETOUR_ERREUR_STAT_FOU       = 111;
  CODE_RETOUR_ERREUR_ART_AXE        = 112;
  CODE_RETOUR_ERREUR_GENCENTRALE    = 113;
  CODE_RETOUR_ERREUR_FEDASSP2K      = 114;
  CODE_RETOUR_ERREUR_JETON          = 115;
  CODE_RETOUR_ERREUR_POSTCORRECTION = 116;
  CODE_RETOUR_ERREUR_INITDB         = 117;
  CODE_RETOUR_ERREUR_DTE            = 118;
  CODE_RETOUR_ERREUR_UPLOAD         = 119;
  CODE_RETOUR_ERREUR_RENAME         = 120;
  CODE_RETOUR_ERREUR_SUPPR          = 121;

  CODE_RETOUR_UNKNOWN_ERROR         = MaxInt;

const
  VERSION_BASE_UNDEF = '0.0.0.0';
  VERSION_BASE_SRC = '11.3.0.9999';
  VERSION_BASE_DEST = '13.3.0.9999';

const
  NB_ETAPE_TRAITEMENT = 33;

type
  TFrm_Main = class(TForm)
    Pan_Control: TPanel;
    Btn_Quitter: TButton;
    Btn_Lancer: TButton;
    Chk_ShowDebug: TCheckBox;
    Pan_Saisie: TPanel;
    Lab_CheminBase: TLabel;
    Nbt_CheminBase: TSpeedButton;
    Lab_CheminScript: TLabel;
    Nbt_CheminScript: TSpeedButton;
    Lab_AccesLame: TLabel;
    Nbt_AccesLame: TSpeedButton;
    Ed_CheminBase: TEdit;
    Ed_CheminScript: TEdit;
    Ed_AccesLameLame: TEdit;
    Pan_Status: TPanel;
    Lab_Status: TLabel;
    Pgb_Status: TProgressBar;
    Ed_AccesLameSite: TEdit;
    Tim_TrtAuto: TTimer;
    Pan_Debug: TPanel;
    SBx_Debug: TScrollBox;
    Pan_Debug2: TPanel;
    Pan_BtnControl: TGridPanel;
    Pan_GfixBegin: TPanel;
    Btn_GfixBegin: TButton;
    Pan_SepLameSite: TGridPanel;
    Gbx_Lame: TGroupBox;
    Btn_Lame_DoScript: TButton;
    Btn_Lame_DoInitNomenclature: TButton;
    Btn_Lame_DoInitTailleGrille: TButton;
    Btn_Lame_DoInitAgrHistoStock: TButton;
    Btn_Lame_DoInitAgrStockCour: TButton;
    Btn_Lame_DoInitAgrMouvement: TButton;
    Btn_Lame_DoInitAgrFouStat: TButton;
    Btn_Lame_CreateTE: TButton;
    Btn_Lame_DoInitArtRelationAxe: TButton;
    Btn_Lame_Upload: TButton;
    Btn_Lame_SupprTE: TButton;
    Btn_Lame_DoSupprOldTables: TButton;
    Btn_Lame_CreateArtRelationAxe: TButton;
    Btn_Lame_ExportArtRelationAxe: TButton;
    Chk_Lame_Mvt_DesIndex: TCheckBox;
    Btn_Lame_PreCorrection: TButton;
    Btn_Lame_PostCorrection: TButton;
    Pan_Lame_Trans: TPanel;
    Btn_Lame_Recalcul: TButton;
    Btn_Lame_InitParamJeton: TButton;
    Btn_Lame_SupprFileTable: TButton;
    Btn_Platform_ImportArtRelationAxe: TButton;
    Btn_Platform_Copy: TButton;
    Btn_Platform_DownLoad: TButton;
    Gbx_Site: TGroupBox;
    Btn_Site_DownLoad: TButton;
    Btn_Site_DoInitNomenclature: TButton;
    Btn_Site_DoInitTailleGrille: TButton;
    Btn_Site_DoInitAgrHistoStock: TButton;
    Btn_Site_DoInitAgrStockCour: TButton;
    Btn_Site_DoInitAgrMouvement: TButton;
    Btn_Site_DoInitAgrFouStat: TButton;
    Btn_Site_CreateTE: TButton;
    Btn_Site_DoInitArtRelationAxe: TButton;
    Btn_Site_ImportArtRelationAxe: TButton;
    Btn_Site_SupprTE: TButton;
    Btn_Site_DoSupprOldTables: TButton;
    Chk_Site_Mvt_DesIndex: TCheckBox;
    Btn_Site_PreCorrection: TButton;
    Btn_Site_PostCorrection: TButton;
    Pan_Site_Trans: TPanel;
    Btn_Site_InitParamJeton: TButton;
    Btn_Site_SupprFileTable: TButton;
    Rgr_WhereBase: TRadioGroup;
    Btn_Lame_DoInitFedasSP2K: TButton;
    Btn_Site_DoInitFedasSP2K: TButton;
    Pan_Sauvegarde: TPanel;
    Btn_Sauvegarde: TButton;
    Btn_SvgIni: TButton;
    Btn_Lame_Nettoyage: TButton;
    Btn_Site_Nettoyage: TButton;
    Btn_Site_ComplArtRelationAxe: TButton;
    Chk_Lame_Hst_DesIndex: TCheckBox;
    Chk_Site_Hst_DesIndex: TCheckBox;
    Btn_Lame_InitGencentrale: TButton;
    Btn_Site_InitGenCentrale: TButton;
    Pan_BackupRest: TPanel;
    Pan_GfixFin: TPanel;
    Btn_GfixEnd: TButton;
    Btn_Backup: TButton;
    Pan_Reboot: TPanel;
    Btn_Reboot: TButton;
    Tim_Backup: TTimer;
    Tim_Replic: TTimer;
    Pan_Replic: TPanel;
    Btn_Replic: TButton;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);

    procedure SBx_DebugResize(Sender: TObject);

    procedure Chk_ShowDebugClick(Sender: TObject);
    procedure Rgr_WhereBaseClick(Sender: TObject);
    procedure Ed_CheminBaseChange(Sender: TObject);
    procedure Nbt_CheminBaseClick(Sender: TObject);
    procedure Ed_CheminScriptChange(Sender: TObject);
    procedure Nbt_CheminScriptClick(Sender: TObject);
    procedure Ed_AccesLameLameChange(Sender: TObject);
    procedure Nbt_AccesLameClick(Sender: TObject);
    procedure Tim_TrtAutoTimer(Sender: TObject);
    procedure Tim_BackupTimer(Sender: TObject);
    procedure Tim_ReplicTimer(Sender: TObject);
    procedure Btn_LancerClick(Sender: TObject);
    procedure Btn_QuitterClick(Sender: TObject);

    procedure Btn_NettoyageClick(Sender: TObject);
    procedure Btn_RecalculClick(Sender: TObject);
    procedure Btn_DoScriptClick(Sender: TObject);
    procedure Btn_GetFromLame2Click(Sender: TObject);
    procedure Btn_DoCreateTEClick(Sender: TObject);
    procedure Btn_DoPreCorrectionClick(Sender: TObject);
    procedure Btn_DoInitNomenclatureClick(Sender: TObject);
    procedure Btn_DoInitTailleGrilleClick(Sender: TObject);
    procedure Btn_DoInitAgrHistoStockClick(Sender: TObject);
    procedure Btn_DoInitAgrStockCourClick(Sender: TObject);
    procedure Btn_DoInitAgrMouvementClick(Sender: TObject);
    procedure Btn_DoInitAgrFouStatClick(Sender: TObject);
    procedure Btn_DoInitArtRelationAxeClick(Sender: TObject);
      procedure Btn_DoCreateArtRelationAxeClick(Sender: TObject);
      procedure Btn_DoExportArtRelationAxeClick(Sender: TObject);
      procedure Btn_DoImportArtRelationAxeClick(Sender: TObject);
      procedure Btn_DoComplArtRelationAxeClick(Sender: TObject);
    procedure Btn_DoInitGencentraleClick(Sender: TObject);
    procedure Btn_DoInitParamJetonClick(Sender: TObject);
    procedure Btn_DoPostCorrectionClick(Sender: TObject);
    procedure Btn_DoSupprOldTablesClick(Sender: TObject);
    procedure Btn_DoSupprTEClick(Sender: TObject);
    procedure Btn_DoPutOnLame2Click(Sender: TObject);
    procedure Btn_DoSupprFileTableClick(Sender: TObject);
    procedure Btn_DoInitFedasSP2KClick(Sender: TObject);

    procedure Btn_GfixBeginClick(Sender: TObject);
    procedure Btn_GfixEndClick(Sender: TObject);
    procedure Btn_SauvegardeClick(Sender: TObject);
    procedure Btn_BackupClick(Sender: TObject);
    procedure Btn_RebootClick(Sender: TObject);
    procedure Btn_ReplicClick(Sender: TObject);

    procedure Btn_SvgIniClick(Sender: TObject);
  private
    { Déclarations privées }
    FAuto : Boolean;
    FInterbaseExt : string;
    FBaseHeight : Integer;
    FDebugHeight : Integer;
    FCaptionBase : string;

    F7ZipOwner : boolean;

    FCreating, FSelecting : boolean;

    FForce, FDebug : boolean;

    // gestion du drag and drop
    procedure MessageDropFiles(var msg : TWMDropFiles); message WM_DROPFILES;

    // reboot et restart
    function DoRebootMachine(Time : Cardinal) : boolean;
    // inscription dnas le runonce !
    function SetRunOnce(cmdline : string) : boolean;
    // Gestion de l'ecran
    procedure GestionInterface(Enabled : Boolean; ShowMessage : boolean = False);
  public
    { Déclarations publiques }
  end;

var
  Frm_Main: TFrm_Main;

implementation

uses
  ShellAPI,
  Registry,
  IniFiles,
  IdHTTP,
  uSevenZip,
  Math,
  StrUtils,
  Types,
  LaunchProcess,
  stdActns,
  Generics.Collections,
  DateUtils,
  IBServices;

const
  CHEMIN_SCRIPT = '\Ginkoia\Script.exe';
  // transfert vers les lames OCEALISE parce ce que !
  ACCES_LAME_LAME = '\\10.255.206.1\Transferts\';
  ACCES_LAME_SITE = 'http://oce1.no-ip.org/Algol/';
  REPERTOIRE_LAME = 'MigreV13';
  // nom de fichier de tables externe
  INTERBASE_EXT_ARTRELATIONAXE = 'export_artrelationaxe.ext';
  INTERBASE_EXT_GENCENTRALE = 'export_gencentrale.ext';
  // gestion du paramètrage de la base !
  INTERBASE_GFIX_EXE = 'C:\Embarcadero\InterBase\bin\gfix.exe';
  // param de base de gfix
  INTERBASE_GFIX_PARAM_BASE = '-user SYSDBA -password masterkey';
  // Definitif
  INTERBASE_GFIX_PARAM_ASYNC = '-w async';
  INTERBASE_GFIX_PARAM_SWEEP_VALUE = '-h 0';
  // pour le temps du traitement
  INTERBASE_GFIX_PARAM_BUFFER_BIG = '-buffers 131072';
  // a remettre (lame uniquement)
  INTERBASE_GFIX_PARAM_BUFFER_SMALL = '-buffers 4096';
  // execution
  INTERBASE_GFIX_PARAM_SWEEP = '-sweep';

  // Executable du backup restore
  BACKUP_EXE_PATH = '\Ginkoia\';
  BACKUP_EXE_FILE = 'BackRest.exe';
  BACKUP_EXE_PARAM = 'AUTO';
  // executable de replication
  REPLIC_EXE_PATH = '\Ginkoia\';
  REPLIC_EXE_FILE = 'LaunchV7.exe';
  REPLIC_EXE_PARAM = 'FORCEREPLIC';

type
  TWhereBase = (wb_Lame, wb_Platform, wb_Site);

type
  TBackupVerif = TDictionary<string, integer>;

type
  TMonThread = class(TThread)
  private
    { Déclarations privées }
    FLogFile : String;
    FInterbaseExt : string;
    FBaseGuid : string;

    // initialisation
    FCheminBase : string;
    FCheminScript : string;
    FAccesLame : string;
    FWhereBase : TWhereBase;
    FDesIndex : Boolean;
    FAuto : boolean;

    // gestion de la base de données
    FInitialized : Boolean;
    FConnexion : TIB_Connection;
    FTransaction : TIB_Transaction;

    // Suivit interface
    FEtape : string;

    function GetStrDuree(Deb : TDateTime) : string;
  protected
    { Déclarations protégées }
    procedure Execute(); override;
  public
    { Déclarations publiques }
    constructor Create(CheminBase, CheminScript, AccesLame, InterbaseExt : string; WhereBase : TWhereBase; DesIndex, Auto, CreateSuspended : boolean); reintroduce;
    destructor Destroy(); override;

    // Suivit interface
    procedure DoEtape();

    // gestion de la base de données
    function InitDB() : Boolean;
    function GetNewQuery() : TIBOQuery;
    procedure CommitTrans();
    procedure RollBackTrans();
    procedure FinaliseDB();

    // Gestion du log
    procedure InitLog(Prefix : string = '');
    function DoLog(txt : string) : TDateTime;

    // recup du GUID de la base 0
    function GetGUIDBase() : string;

    //Execution d'un script
    procedure LoadScriptSQL(Nom : string; Query : TIBOQuery);
    function ExecuteScriptSQL(Nom : string) : Boolean;

    // Gestion du GFIX de la base
    function DoGFixBegin() : boolean;
    function DoGFixEnd() : boolean;

    // backup
    function DoSauvegardeBase() : boolean;
    function DoDropSauvegarde() : boolean;

    // nettoyage de la base
    function DoNettoyageBase() : boolean;

    //Etapes du programme
    function DoRecalculTrigger() : Boolean;
    function DoScript() : Boolean;
    function DoGetFromLame2() : Boolean;
    function DoCreateTableExterne() : Boolean;
    function DoPreCorrection() : Boolean;
    function DoInitNomenclature() : Boolean;
    function DoInitTailleGrille() : Boolean;
    function DoInitAgrHistoStock() : Boolean;
    function DoInitAgrStockCour() : Boolean;
    function DoInitAgrMouvement() : Boolean;
    function DoInitAgrFouStat() : Boolean;
    function DoInitArtRelationAxe() : Boolean;
      function DoCreateArtRelationAxe() : Boolean;
      function DoExportArtRelationAxe() : Boolean;
      function DoImportArtRelationAxe() : Boolean;
      function DoComplementArtRelationAxe() : Boolean;
    function DoInitGenCentrale() : Boolean;
      function DoExportGenCentrale() : Boolean;
      function DoImportGenCentrale() : Boolean;
    function DoInitFedasSP2K() : Boolean;
    function DoInitParamJeton() : boolean;
    function DoPostCorrection() : Boolean;
    function DoDropTableExterne() : boolean;
    function DoPutOnLame2() : Boolean;
    function DoCopyOnLame2() : Boolean;
    function DoSupprTableExterne() : Boolean;
    function DoSupprOldTables() : Boolean;
    function DoBackup(var Verif : TBackupVerif) : boolean;
    function DoRestore(Verif : TBackupVerif) : boolean;
    procedure ExportDataSetToDSV(ADataSet: TDataSet;
      const AFichier: TFileName; const AChampsExclus: array of string);
  end;

{$R *.dfm}

function CompareVersion(const A, B : string) : TValueRelationship;
var
  ListValA, ListValB : TStringList;
  ValA, ValB, i, nb : integer;
begin
  Result := EqualsValue;
  try
    ListValA := TStringList.Create();
    ListValA.Delimiter := '.';
    ListValA.DelimitedText := Trim(A);
    ListValB := TStringList.Create();
    ListValB.Delimiter := '.';
    ListValB.DelimitedText := Trim(B);

    nb := Max(ListValA.Count, ListValB.Count);
    while ListValA.Count < nb do
      ListValA.Add('0');
    while ListValB.Count < nb do
      ListValB.Add('0');

    for i := 0 to nb -1 do
    begin
      if TryStrToInt(ListValA[i], ValA) and TryStrToInt(ListValB[i], ValB) then
        Result := CompareValue(ValA, ValB)
      else
        Result := CompareStr(ListValA[i], ListValB[i]);
      if not (Result = EqualsValue) then
        Exit;
    end;
  finally
    FreeAndNil(ListValA);
    FreeAndNil(ListValB);
  end;
end;

function GetVersion(FileName : string) : string;
var
  Connexion : TIB_Connection;
  Transaction : TIB_Transaction;
  Query : TIBOQuery;
begin
  Result := VERSION_BASE_UNDEF;
  try
    try
      Connexion := TIB_Connection.Create(nil);
      Connexion.DatabaseName := AnsiString(FileName);
      Connexion.Username := 'sysdba';
      Connexion.Password := 'masterkey';

      Transaction := TIB_Transaction.Create(nil);
      Transaction.IB_Connection := Connexion;

      Query := TIBOQuery.Create(nil);
      Query.IB_Connection := Connexion;
      Query.IB_Transaction := Transaction;
      Query.ParamCheck := False;

      Transaction.StartTransaction();

      Query.SQL.Text := 'select ver_version from genversion order by ver_date desc rows 1;';
      Query.Open();
      if not Query.Eof then
        Result := Query.FieldByName('ver_version').AsString;
      Query.Close();

      Transaction.Rollback();
    finally
      FreeAndNil(Query);
      FreeAndNil(Transaction);
      FreeAndNil(Connexion);
    end;
  except
    on e : Exception do
    begin
{$IFDEF DEBUG}
      MessageDlg('Exception : ' + e.Message, mtError, [mbOK], 0);
{$ENDIF}
      Result := VERSION_BASE_UNDEF;
    end;
  end;
end;

function GetTempDirectory() : String;
var
  tempFolder: array[0..MAX_PATH] of Char;
begin
  GetTempPath(MAX_PATH, @tempFolder);
  result := StrPas(tempFolder);
end;

{ TFrm_Main }

// Interface

procedure TFrm_Main.FormCreate(Sender: TObject);
var
  Reg : TRegistry;
  IniFile, tmpDest : string;
  Ini : TInifile;
  i : Integer;
  DoTrtTimer, DoBackup, DoReplic : Boolean;
  Res : TResourceStream;
begin
  // init
  FCreating := true;
  FSelecting := false;
  F7ZipOwner := false;
  DoTrtTimer := false;
  DoBackup := false;
  DoReplic := false;
  FCaptionBase := Caption;
  Ed_CheminBase.Text := '';
  FBaseHeight := Self.Height - Pan_Debug.Height;
  FDebugHeight := Pan_Debug.Height;

  FForce := false;
  FDebug := false;

  // Valeur par default
  Ed_CheminScript.Text := ExtractFileDrive(ParamStr(0)) + CHEMIN_SCRIPT;
  Ed_AccesLameLame.Text := ACCES_LAME_LAME;
  Ed_AccesLameSite.Text := ACCES_LAME_SITE;

  // Gestion du drag ans drop
  DragAcceptFiles(Handle, True);

  // Extraction de la DLL 7z
  if not FileExists(ExtractFilePath(ParamStr(0)) + '7z.dll') then
  begin
    Res := TResourceStream.Create(HInstance, '7zDLL', RT_RCDATA);
    try
      Res.SaveToFile(ExtractFilePath(ParamStr(0)) + '7z.dll');
      F7ZipOwner := true;
    finally
      FreeAndNil(Res);
    end;
  end;

  // verification de la version d'interbase
  try
    Reg := TRegistry.Create(KEY_READ);
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKeyReadOnly('\Software\Borland\Interbase\Servers\gds_db') then
    begin
      // creation du repertoir des tables externe
      FInterbaseExt := IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(Reg.ReadString('RootDirectory')) + 'ext');
      ForceDirectories(FInterbaseExt)
    end
    else
    begin
      // pas de Interbase XE... Oups !
      PostQuitMessage(CODE_RETOUR_ERREUR_IB);
    end;
  finally
    FreeAndNil(Reg);
  end;

  // recherche de la base en base de registre
  try
    Reg := TRegistry.Create(KEY_READ);
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKeyReadOnly('\Software\Algol\Ginkoia\') then
    begin
      if (Trim(Ed_CheminBase.Text) = '') and not (Trim(Reg.ReadString('Base0')) = '') then
        Ed_CheminBase.Text := Reg.ReadString('Base0');
    end;
  finally
    FreeAndNil(Reg);
  end;

  // lecture des paramètres
  IniFile := ChangeFileExt(ParamStr(0), '.ini');
  if FileExists(IniFile) then
  begin
    try
      Ini := TIniFile.Create(IniFile);
      Ed_CheminScript.Text := Ini.ReadString('Conf', 'CheminScript', Ed_CheminScript.Text);
      Ed_AccesLameLame.Text := Ini.ReadString('Conf', 'AccesLame', Ed_AccesLameLame.Text);
      Ed_AccesLameSite.Text := Ini.ReadString('Conf', 'AccesSite', Ed_AccesLameSite.Text);
    finally
      FreeAndNil(Ini);
    end;
  end;

  // gestion des paramètre ligne de commande
  tmpDest := '';
  if ParamCount > 0 then
  begin
    for i := 1 to ParamCount do
    begin
      case IndexStr(UpperCase(ParamStr(i)), ['LAME', 'PFRM', 'PLATFORM', 'SITE', 'AUTO', 'FORCE', 'DEBUG', 'BACKUP', 'REPLICATION']) of
        0 : Rgr_WhereBase.ItemIndex := 0;
        1, 2 : Rgr_WhereBase.ItemIndex := 1;
        3 : Rgr_WhereBase.ItemIndex := 2;
        4 : DoTrtTimer := true;
        5 : FForce := true;
        6 : FDebug := true;
        7 : DoBackup := true;
        8 : DoReplic := true;
        else
          case IndexStr(UpperCase(Copy(ParamStr(i), 1, 4)), ['BASE', 'CHSC', 'DEST']) of
            0 : Ed_CheminBase.Text := Copy(ParamStr(i), 6, Length(ParamStr(i)));
            1 : Ed_CheminScript.Text := Copy(ParamStr(i), 6, Length(ParamStr(i)));
            2 : TmpDest := Copy(ParamStr(i), 6, Length(ParamStr(i)));
          end;
      end;
    end;
  end;

  if not (TmpDest = '') then
  begin
    if Rgr_WhereBase.ItemIndex < 2 then
      Ed_AccesLameLame.Text := tmpDest
    else
      Ed_AccesLameSite.Text := tmpDest;
  end;

  // traitement a faire ?
  if DoReplic then
    Tim_Replic.Enabled := true
  else if DoBackup then
    Tim_Backup.Enabled := true
  else
    Tim_TrtAuto.Enabled := DoTrtTimer;

  // dehinibition des evenement
  GestionInterface(Btn_Quitter.Enabled);
  FCreating := false;
end;

procedure TFrm_Main.FormShow(Sender: TObject);
begin
  GestionInterface(True);
  Chk_ShowDebug.Checked := False;
  Chk_ShowDebug.Visible := FDebug;
end;

procedure TFrm_Main.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := Btn_Quitter.Enabled;
end;

procedure TFrm_Main.FormDestroy(Sender: TObject);
begin
  if F7ZipOwner then
    DeleteFile(ExtractFilePath(ParamStr(0)) + '7z.dll');
//  if FInitialized then
//    FinaliseDB();
end;

procedure TFrm_Main.SBx_DebugResize(Sender: TObject);
begin
  if SBx_Debug.ClientWidth > Pan_Debug2.Constraints.MinWidth then
    Pan_Debug2.Width := SBx_Debug.ClientWidth
  else
    Pan_Debug2.Width := Pan_Debug2.Constraints.MinWidth;

  if SBx_Debug.ClientHeight > Pan_Debug2.Constraints.MinHeight then
    Pan_Debug2.Height := SBx_Debug.ClientHeight
  else
    Pan_Debug2.Height := Pan_Debug2.Constraints.MinHeight;
end;

procedure TFrm_Main.Chk_ShowDebugClick(Sender: TObject);
var
  MaxHeigth : integer;
begin
  if Chk_ShowDebug.Checked then
  begin
    MaxHeigth := Screen.WorkAreaRect.Bottom - Screen.WorkAreaRect.top;
    Pan_Debug.Visible := True;
    Self.Height := Min(Self.Height + FDebugHeight, MaxHeigth);
    Self.Top := Max(0, Self.Top - Trunc(FDebugHeight /2));
  end
  else
  begin
    Pan_Debug.Visible := False;
    Self.Height := FBaseHeight;
    Self.Top := Self.Top + Trunc(FDebugHeight /2);
  end;
end;

procedure TFrm_Main.Rgr_WhereBaseClick(Sender: TObject);
begin
  if not (FCreating or FSelecting) then
    GestionInterface(Btn_Quitter.Enabled, Visible and not FAuto);
end;

procedure TFrm_Main.Ed_CheminBaseChange(Sender: TObject);
begin
  // affichage des message que si :
  // - la form est visible (pas dans le FormCreate)
  // - on est pas en traitement auto (FAuto) (ne devrais normalement pas se produire ... les paramètre de l'auto doivent etre renseigné lors du create)
  if not (FCreating or FSelecting) then
    GestionInterface(Btn_Quitter.Enabled, Visible and not FAuto);
end;

procedure TFrm_Main.Nbt_CheminBaseClick(Sender: TObject);
var
  Open : TOpenDialog;
begin
  try
    Open := TOpenDialog.Create(Self);
    Open.FileName := ExtractFileName(Ed_CheminBase.Text);
    Open.InitialDir := ExtractFilePath(Ed_CheminBase.Text);
    Open.Filter := 'IB Database|*.IB';
    Open.FilterIndex := 0;
    Open.DefaultExt := 'IB';
    try
      FSelecting := true;
      Ed_CheminBase.Text := '';
    finally
      FSelecting := false;
    end;
    if Open.Execute() then
      Ed_CheminBase.Text := Open.FileName;
  finally
    FreeAndNil(Open);
  end;
end;

procedure TFrm_Main.Ed_CheminScriptChange(Sender: TObject);
begin
  // affichage des message que si :
  // - la form est visible (pas dans le FormCreate)
  // - on est pas en traitement auto (FAuto) (ne devrais normalement pas se produire ... les paramètre de l'auto doivent etre renseigné lors du create)
  if not (FCreating or FSelecting) then
    GestionInterface(Btn_Quitter.Enabled, Visible and not FAuto);
end;

procedure TFrm_Main.Nbt_CheminScriptClick(Sender: TObject);
var
  Open : TOpenDialog;
begin
  try
    Open := TOpenDialog.Create(Self);
    Open.FileName := ExtractFileName(Ed_CheminScript.Text);
    Open.InitialDir := ExtractFilePath(Ed_CheminScript.Text);
    Open.Filter := 'Application|Script*.exe';
    Open.FilterIndex := 0;
    Open.DefaultExt := 'exe';
    try
      FSelecting := true;
      Ed_CheminScript.Text := '';
    finally
      FSelecting := false;
    end;
    if Open.Execute() then
      Ed_CheminScript.Text := Open.FileName;
  finally
    FreeAndNil(Open);
  end;
end;

procedure TFrm_Main.Ed_AccesLameLameChange(Sender: TObject);
begin
  // affichage des message que si :
  // - la form est visible (pas dans le FormCreate)
  // - on est pas en traitement auto (FAuto) (ne devrais normalement pas se produire ... les paramètre de l'auto doivent etre renseigné lors du create)
  if not (FCreating or FSelecting) then
    GestionInterface(Btn_Quitter.Enabled, Visible and not FAuto);
end;

procedure TFrm_Main.Nbt_AccesLameClick(Sender: TObject);
var
  Browse : TBrowseForFolder;
  Open : TOpenDialog;
begin
  case TWhereBase(Rgr_WhereBase.ItemIndex) of
    wb_Lame :
      begin
        try
          Browse := TBrowseForFolder.Create(Self);
          Browse.Folder := Ed_AccesLameLame.Text;
          try
            FSelecting := true;
            Ed_AccesLameLame.Text := '';
          finally
            FSelecting := false;
          end;
          if Browse.Execute() then
            Ed_AccesLameLame.Text := Browse.Folder;
        finally
          FreeAndNil(Browse);
        end;
      end;
    wb_Platform :
      begin
        try
          Open := TOpenDialog.Create(Self);
          Open.FileName := ExtractFileName(Ed_AccesLameLame.Text);
          Open.InitialDir := ExtractFilePath(Ed_AccesLameLame.Text);
          Open.Filter := 'Zipped GUID|{*}.7z';
          Open.FilterIndex := 0;
          Open.DefaultExt := '7z';
          try
            FSelecting := true;
            Ed_AccesLameLame.Text := '';
          finally
            FSelecting := false;
          end;
          if Open.Execute() then
            Ed_AccesLameLame.Text := Open.FileName;
        finally
          FreeAndNil(Open);
        end;
      end;
    else
      Raise Exception.Create('Pas le bon mode pour la selection de chemin lame.');
  end;
end;

procedure TFrm_Main.Tim_TrtAutoTimer(Sender: TObject);
begin
  Tim_TrtAuto.Enabled := false;
  FAuto := True;
  if Btn_Lancer.Enabled then
    Btn_LancerClick(Sender)
  else if ExitCode = 0 then
    PostQuitMessage(CODE_RETOUR_ERREUR_PARAM)
  else
    PostQuitMessage(ExitCode);
end;

procedure TFrm_Main.Tim_BackupTimer(Sender: TObject);
begin
  Tim_Backup.Enabled := false;
  FAuto := True;
  if Btn_Backup.Enabled then
    Btn_BackupClick(Sender)
  else if ExitCode = 0 then
    PostQuitMessage(CODE_RETOUR_ERREUR_PARAM)
  else
    PostQuitMessage(ExitCode);
end;

procedure TFrm_Main.Tim_ReplicTimer(Sender: TObject);
begin
  Tim_Replic.Enabled := false;
  FAuto := True;
  if Btn_Replic.Enabled then
    Btn_ReplicClick(Sender)
  else if ExitCode = 0 then
    PostQuitMessage(CODE_RETOUR_ERREUR_PARAM)
  else
    PostQuitMessage(ExitCode);
end;

procedure TFrm_Main.Btn_LancerClick(Sender: TObject);
var
  thread : TMonThread;
  MutexHandle : integer;
begin
  try
    GestionInterface(False);

    case TWhereBase(Rgr_WhereBase.ItemIndex) of
      wb_Lame, wb_Platform :
        if FForce and not (CompareVersion(GetVersion(Ed_CheminBase.Text), VERSION_BASE_SRC) = EqualsValue) then
          if FAuto or (MessageDlg('ATTENTION :'#13'La base n''est pas dans la bonne version.'#13'le fonctionnement n''est pas garantie !'#13'Voullez-vous continuer ?', mtWarning, [mbYes, mbNo], 0) = mrNo) then
            Exit;
    end;

    MutexHandle := OpenMutex(MUTEX_ALL_ACCESS, true, PChar(LowerCase(ExtractFileName(ParamStr(0)))));
    if MutexHandle = 0 then
    begin
      MutexHandle := CreateMutex(nil, False, PChar(LowerCase(ExtractFileName(ParamStr(0)))));

      Pgb_Status.Position := 0;
      Pgb_Status.Max := NB_ETAPE_TRAITEMENT;
      Pgb_Status.Step := 1;
      try
        if Rgr_WhereBase.ItemIndex < 2 then
          thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameLame.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), Chk_Lame_Hst_DesIndex.Checked or Chk_Lame_Mvt_DesIndex.Checked, FAuto, false)
        else
          thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameSite.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), Chk_Site_Hst_DesIndex.Checked or Chk_Site_Mvt_DesIndex.Checked, FAuto, false);
        while WaitForSingleObject(thread.Handle, 100) = WAIT_TIMEOUT do
          Application.ProcessMessages();
        ExitCode := thread.ReturnValue;
      finally
        FreeAndNil(thread);
      end;

      // suite du traitement ? forcé la replication ?
      if TWhereBase(Rgr_WhereBase.ItemIndex) = wb_Site then
        SetRunOnce(ParamStr(0) + ' SITE REPLICATION');

      // passage de la prograssbar
      Application.ProcessMessages();

      // fin !
      if FAuto then
        PostQuitMessage(ExitCode)
      else if ExitCode > 0 then
        MessageDlg('Erreur lors du traitement', mtError, [mbOK], 0)
      else
        MessageDlg('Traitement terminé correctement.', mtInformation, [mbOK], 0);
      Pgb_Status.Position := 0;
    end
    else
    begin
      if FAuto then
        PostQuitMessage(CODE_RETOUR_ERREUR_TRT_LAUNCHED)
      else
        MessageDlg('Traitement déjà lancer avec une autre instance.', mtError, [mbOK], 0);
    end;
    CloseHandle(MutexHandle);
  finally
    // seulement si non automatique
    // sinon Gestion Interfce reset le code de retour !
    if not FAuto then
      GestionInterface(True);
  end;
end;

procedure TFrm_Main.Btn_QuitterClick(Sender: TObject);
begin
  Close();
end;

// Debug

procedure TFrm_Main.Btn_NettoyageClick(Sender: TObject);
var
  thread : TMonThread;
begin
  try
    GestionInterface(False);
    if Rgr_WhereBase.ItemIndex < 2 then
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameLame.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True)
    else
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameSite.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True);
    if thread.DoNettoyageBase() then
      MessageDlg('Ok', mtInformation, [mbOK], 0)
    else
      MessageDlg('KO !', mtError, [mbOK], 0)
  finally
    FreeAndNil(thread);
    GestionInterface(True);
  end;
end;

procedure TFrm_Main.Btn_RecalculClick(Sender: TObject);
var
  thread : TMonThread;
begin
  try
    GestionInterface(False);
    if Rgr_WhereBase.ItemIndex < 2 then
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameLame.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True)
    else
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameSite.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True);
    if thread.DoRecalculTrigger() then
      MessageDlg('Ok', mtInformation, [mbOK], 0)
    else
      MessageDlg('KO !', mtError, [mbOK], 0)
  finally
    FreeAndNil(thread);
    GestionInterface(True);
  end;
end;

procedure TFrm_Main.Btn_DoScriptClick(Sender: TObject);
var
  thread : TMonThread;
begin
  try
    GestionInterface(False);
    if Rgr_WhereBase.ItemIndex < 2 then
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameLame.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True)
    else
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameSite.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True);
    if thread.DoScript() then
      MessageDlg('Ok', mtInformation, [mbOK], 0)
    else
      MessageDlg('KO !', mtError, [mbOK], 0)
  finally
    FreeAndNil(thread);
    GestionInterface(True);
  end;
end;

procedure TFrm_Main.Btn_GetFromLame2Click(Sender: TObject);
var
  thread : TMonThread;
begin
  try
    GestionInterface(False);
    if Rgr_WhereBase.ItemIndex < 2 then
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameLame.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True)
    else
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameSite.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True);
    thread.FBaseGuid := thread.GetGUIDBase();
    if thread.DoGetFromLame2() then
      MessageDlg('Ok', mtInformation, [mbOK], 0)
    else
      MessageDlg('KO !', mtError, [mbOK], 0)
  finally
    FreeAndNil(thread);
    GestionInterface(True);
  end;
end;

procedure TFrm_Main.Btn_DoCreateTEClick(Sender: TObject);
var
  thread : TMonThread;
begin
  try
    GestionInterface(False);
    if Rgr_WhereBase.ItemIndex < 2 then
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameLame.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True)
    else
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameSite.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True);
    if thread.DoCreateTableExterne() then
      MessageDlg('Ok', mtInformation, [mbOK], 0)
    else
      MessageDlg('KO !', mtError, [mbOK], 0)
  finally
    FreeAndNil(thread);
    GestionInterface(True);
  end;
end;

procedure TFrm_Main.Btn_DoPreCorrectionClick(Sender: TObject);
var
  thread : TMonThread;
begin
  try
    GestionInterface(False);
    if Rgr_WhereBase.ItemIndex < 2 then
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameLame.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True)
    else
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameSite.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True);
    if thread.DoPreCorrection() then
    begin
      if thread.FInitialized and thread.FTransaction.InTransaction then
        thread.FTransaction.Commit();
      MessageDlg('Ok', mtInformation, [mbOK], 0);
    end
    else
      MessageDlg('KO !', mtError, [mbOK], 0)
  finally
    FreeAndNil(thread);
    GestionInterface(True);
  end;
end;

procedure TFrm_Main.Btn_DoInitNomenclatureClick(Sender: TObject);
var
  thread : TMonThread;
begin
  try
    GestionInterface(False);
    if Rgr_WhereBase.ItemIndex < 2 then
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameLame.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True)
    else
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameSite.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True);
    if thread.DoInitNomenclature() then
    begin
      thread.FTransaction.Commit();
      MessageDlg('Ok', mtInformation, [mbOK], 0);
    end
    else
      MessageDlg('KO !', mtError, [mbOK], 0)
  finally
    FreeAndNil(thread);
    GestionInterface(True);
  end;
end;

procedure TFrm_Main.Btn_DoInitTailleGrilleClick(Sender: TObject);
var
  thread : TMonThread;
begin
  try
    GestionInterface(False);
    if Rgr_WhereBase.ItemIndex < 2 then
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameLame.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True)
    else
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameSite.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True);
    if thread.DoInitTailleGrille() then
    begin
      thread.FTransaction.Commit();
      MessageDlg('Ok', mtInformation, [mbOK], 0);
    end
    else
      MessageDlg('KO !', mtError, [mbOK], 0)
  finally
    FreeAndNil(thread);
    GestionInterface(True);
  end;
end;

procedure TFrm_Main.Btn_DoInitAgrHistoStockClick(Sender: TObject);
var
  thread : TMonThread;
begin
  try
    GestionInterface(False);
    if Rgr_WhereBase.ItemIndex < 2 then
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameLame.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), Chk_Lame_Hst_DesIndex.Checked, false, True)
    else
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameSite.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), Chk_Site_Hst_DesIndex.Checked, false, True);
    if thread.DoInitAgrHistoStock() then
    begin
      thread.FTransaction.Commit();
      MessageDlg('Ok', mtInformation, [mbOK], 0);
    end
    else
      MessageDlg('KO !', mtError, [mbOK], 0)
  finally
    FreeAndNil(thread);
    GestionInterface(True);
  end;
end;

procedure TFrm_Main.Btn_DoInitAgrStockCourClick(Sender: TObject);
var
  thread : TMonThread;
begin
  try
    GestionInterface(False);
    if Rgr_WhereBase.ItemIndex < 2 then
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameLame.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True)
    else
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameSite.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True);
    if thread.DoInitAgrStockCour() then
    begin
      thread.FTransaction.Commit();
      MessageDlg('Ok', mtInformation, [mbOK], 0);
    end
    else
      MessageDlg('KO !', mtError, [mbOK], 0)
  finally
    FreeAndNil(thread);
    GestionInterface(True);
  end;
end;

procedure TFrm_Main.Btn_DoInitAgrMouvementClick(Sender: TObject);
var
  thread : TMonThread;
begin
  try
    GestionInterface(False);
    if Rgr_WhereBase.ItemIndex < 2 then
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameLame.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), Chk_Lame_Mvt_DesIndex.Checked, false, True)
    else
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameSite.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), Chk_Site_Mvt_DesIndex.Checked, false, True);
    if thread.DoInitAgrMouvement() then
    begin
      thread.FTransaction.Commit();
      MessageDlg('Ok', mtInformation, [mbOK], 0);
    end
    else
      MessageDlg('KO !', mtError, [mbOK], 0)
  finally
    FreeAndNil(thread);
    GestionInterface(True);
  end;
end;

procedure TFrm_Main.Btn_DoInitAgrFouStatClick(Sender: TObject);
var
  thread : TMonThread;
begin
  try
    GestionInterface(False);
    if Rgr_WhereBase.ItemIndex < 2 then
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameLame.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True)
    else
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameSite.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True);
    if thread.DoInitAgrFouStat() then
    begin
      thread.FTransaction.Commit();
      MessageDlg('Ok', mtInformation, [mbOK], 0);
    end
    else
      MessageDlg('KO !', mtError, [mbOK], 0)
  finally
    FreeAndNil(thread);
    GestionInterface(True);
  end;
end;

procedure TFrm_Main.Btn_DoInitArtRelationAxeClick(Sender: TObject);
var
  thread : TMonThread;
begin
  try
    GestionInterface(False);
    if Rgr_WhereBase.ItemIndex < 2 then
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameLame.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True)
    else
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameSite.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True);
    thread.FBaseGuid := thread.GetGUIDBase();
    if thread.DoInitArtRelationAxe() then
    begin
      thread.FTransaction.Commit();
      MessageDlg('Ok', mtInformation, [mbOK], 0);
    end
    else
      MessageDlg('KO !', mtError, [mbOK], 0)
  finally
    FreeAndNil(thread);
    GestionInterface(True);
  end;
end;

procedure TFrm_Main.Btn_DoCreateArtRelationAxeClick(Sender: TObject);
var
  thread : TMonThread;
begin
  try
    GestionInterface(False);
    if Rgr_WhereBase.ItemIndex < 2 then
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameLame.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True)
    else
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameSite.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True);
    if thread.DoCreateArtRelationAxe() then
    begin
      thread.FTransaction.Commit();
      MessageDlg('Ok', mtInformation, [mbOK], 0);
    end
    else
      MessageDlg('KO !', mtError, [mbOK], 0)
  finally
    FreeAndNil(thread);
    GestionInterface(True);
  end;
end;

procedure TFrm_Main.Btn_DoExportArtRelationAxeClick(Sender: TObject);
var
  thread : TMonThread;
begin
  try
    GestionInterface(False);
    if Rgr_WhereBase.ItemIndex < 2 then
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameLame.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True)
    else
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameSite.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True);
    if thread.DoExportArtRelationAxe() then
    begin
      thread.FTransaction.Commit();
      MessageDlg('Ok', mtInformation, [mbOK], 0);
    end
    else
      MessageDlg('KO !', mtError, [mbOK], 0)
  finally
    FreeAndNil(thread);
    GestionInterface(True);
  end;
end;

procedure TFrm_Main.Btn_DoImportArtRelationAxeClick(Sender: TObject);
var
  thread : TMonThread;
begin
  try
    GestionInterface(False);
    if Rgr_WhereBase.ItemIndex < 2 then
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameLame.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True)
    else
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameSite.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True);
    if thread.DoImportArtRelationAxe() then
    begin
      thread.FTransaction.Commit();
      MessageDlg('Ok', mtInformation, [mbOK], 0);
    end
    else
      MessageDlg('KO !', mtError, [mbOK], 0)
  finally
    FreeAndNil(thread);
    GestionInterface(True);
  end;
end;

procedure TFrm_Main.Btn_DoComplArtRelationAxeClick(Sender: TObject);
var
  thread : TMonThread;
begin
  try
    GestionInterface(False);
    if Rgr_WhereBase.ItemIndex < 2 then
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameLame.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True)
    else
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameSite.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True);
    if thread.DoComplementArtRelationAxe() then
    begin
      thread.FTransaction.Commit();
      MessageDlg('Ok', mtInformation, [mbOK], 0);
    end
    else
      MessageDlg('KO !', mtError, [mbOK], 0)
  finally
    FreeAndNil(thread);
    GestionInterface(True);
  end;
end;

procedure TFrm_Main.Btn_DoInitGencentraleClick(Sender: TObject);
var
  thread : TMonThread;
begin
  try
    GestionInterface(False);
    if Rgr_WhereBase.ItemIndex < 2 then
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameLame.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True)
    else
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameSite.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True);
    if thread.DoInitGenCentrale() then
    begin
      thread.FTransaction.Commit();
      MessageDlg('Ok', mtInformation, [mbOK], 0);
    end
    else
      MessageDlg('KO !', mtError, [mbOK], 0)
  finally
    FreeAndNil(thread);
    GestionInterface(True);
  end;
end;

procedure TFrm_Main.Btn_DoInitFedasSP2KClick(Sender: TObject);
var
  thread : TMonThread;
begin
  try
    GestionInterface(False);
    if Rgr_WhereBase.ItemIndex < 2 then
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameLame.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True)
    else
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameSite.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True);
    if thread.DoInitFedasSP2K() then
    begin
      thread.FTransaction.Commit();
      MessageDlg('Ok', mtInformation, [mbOK], 0);
    end
    else
      MessageDlg('KO !', mtError, [mbOK], 0)
  finally
    FreeAndNil(thread);
    GestionInterface(True);
  end;
end;

procedure TFrm_Main.Btn_DoInitParamJetonClick(Sender: TObject);
var
  thread : TMonThread;
begin
  try
    GestionInterface(False);
    if Rgr_WhereBase.ItemIndex < 2 then
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameLame.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True)
    else
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameSite.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True);
    if thread.DoInitParamJeton() then
    begin
      thread.FTransaction.Commit();
      MessageDlg('Ok', mtInformation, [mbOK], 0);
    end
    else
      MessageDlg('KO !', mtError, [mbOK], 0)
  finally
    FreeAndNil(thread);
    GestionInterface(True);
  end;
end;

procedure TFrm_Main.Btn_DoPostCorrectionClick(Sender: TObject);
var
  thread : TMonThread;
begin
  try
    GestionInterface(False);
    if Rgr_WhereBase.ItemIndex < 2 then
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameLame.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True)
    else
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameSite.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True);
    if thread.DoPostCorrection() then
    begin
      if thread.FInitialized and thread.FTransaction.InTransaction then
        thread.FTransaction.Commit();
      MessageDlg('Ok', mtInformation, [mbOK], 0);
    end
    else
      MessageDlg('KO !', mtError, [mbOK], 0)
  finally
    FreeAndNil(thread);
    GestionInterface(True);
  end;
end;

procedure TFrm_Main.Btn_DoSupprOldTablesClick(Sender: TObject);
var
  thread : TMonThread;
begin
  try
    GestionInterface(False);
    if Rgr_WhereBase.ItemIndex < 2 then
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameLame.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True)
    else
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameSite.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True);
    if thread.DoSupprOldTables() then
      MessageDlg('Ok', mtInformation, [mbOK], 0)
    else
      MessageDlg('KO !', mtError, [mbOK], 0)
  finally
    FreeAndNil(thread);
    GestionInterface(True);
  end;
end;

procedure TFrm_Main.Btn_DoSupprTEClick(Sender: TObject);
var
  thread : TMonThread;
begin
  try
    GestionInterface(False);
    if Rgr_WhereBase.ItemIndex < 2 then
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameLame.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True)
    else
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameSite.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True);
    if thread.DoDropTableExterne() then
      MessageDlg('Ok', mtInformation, [mbOK], 0)
    else
      MessageDlg('KO !', mtError, [mbOK], 0)
  finally
    FreeAndNil(thread);
    GestionInterface(True);
  end;
end;

procedure TFrm_Main.Btn_DoPutOnLame2Click(Sender: TObject);
var
  thread : TMonThread;
begin
  try
    GestionInterface(False);
    if Rgr_WhereBase.ItemIndex < 2 then
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameLame.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True)
    else
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameSite.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True);
    thread.FBaseGuid := thread.GetGUIDBase();
    if thread.DoPutOnLame2() then
      MessageDlg('Ok', mtInformation, [mbOK], 0)
    else
      MessageDlg('KO !', mtError, [mbOK], 0)
  finally
    FreeAndNil(thread);
    GestionInterface(True);
  end;
end;

procedure TFrm_Main.Btn_DoSupprFileTableClick(Sender: TObject);
var
  thread : TMonThread;
begin
  try
    GestionInterface(False);
    if Rgr_WhereBase.ItemIndex < 2 then
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameLame.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True)
    else
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameSite.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True);
    thread.FBaseGuid := thread.GetGUIDBase();
    if thread.DoSupprTableExterne() then
      MessageDlg('Ok', mtInformation, [mbOK], 0)
    else
      MessageDlg('KO !', mtError, [mbOK], 0)
  finally
    FreeAndNil(thread);
    GestionInterface(True);
  end;
end;

// Gestion des GFIX

procedure TFrm_Main.Btn_GfixBeginClick(Sender: TObject);
var
  thread : TMonThread;
begin
  try
    GestionInterface(False);
    if Rgr_WhereBase.ItemIndex < 2 then
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameLame.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True)
    else
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameSite.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True);
    if thread.DoGFixBegin() then
      MessageDlg('Ok', mtInformation, [mbOK], 0)
    else
      MessageDlg('KO !', mtError, [mbOK], 0)
  finally
    FreeAndNil(thread);
    GestionInterface(True);
  end;
end;

procedure TFrm_Main.Btn_GfixEndClick(Sender: TObject);
var
  thread : TMonThread;
begin
  try
    GestionInterface(False);
    if Rgr_WhereBase.ItemIndex < 2 then
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameLame.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True)
    else
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameSite.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True);
    if thread.DoGFixEnd() then
      MessageDlg('Ok', mtInformation, [mbOK], 0)
    else
      MessageDlg('KO !', mtError, [mbOK], 0)
  finally
    FreeAndNil(thread);
    GestionInterface(True);
  end;
end;

// Gestion de la sauvegarde

procedure TFrm_Main.Btn_SauvegardeClick(Sender: TObject);
var
  thread : TMonThread;
begin
  try
    GestionInterface(False);
    if Rgr_WhereBase.ItemIndex < 2 then
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameLame.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True)
    else
      thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameSite.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True);
    if thread.DoSauvegardeBase() then
      MessageDlg('Ok', mtInformation, [mbOK], 0)
    else
      MessageDlg('KO !', mtError, [mbOK], 0)
  finally
    FreeAndNil(thread);
    GestionInterface(True);
  end;
end;

// Gestion du bakup/resore

procedure TFrm_Main.Btn_BackupClick(Sender: TObject);

  procedure IntegratedBackup();
  var
    thread : TMonThread;
    Verif : TBackupVerif;
  begin
    try
      GestionInterface(False);
      if Rgr_WhereBase.ItemIndex < 2 then
        thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameLame.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True)
      else
        thread := TMonThread.Create(Ed_CheminBase.Text, Ed_CheminScript.Text, Ed_AccesLameSite.Text, FInterbaseExt, TWhereBase(Rgr_WhereBase.ItemIndex), false, false, True);
      try
        Verif := TBackupVerif.Create();
        if thread.DoBackup(Verif) then
        begin
          if thread.DoRestore(Verif) then
            MessageDlg('Ok', mtInformation, [mbOK], 0)
          else
            MessageDlg('Restore KO !', mtError, [mbOK], 0)
        end
        else
          MessageDlg('Bakup KO !', mtError, [mbOK], 0)
      finally
        FreeAndNil(Verif);
      end;

//      ExitCode := thread.ReturnValue;
//      if FAuto then
//        PostQuitMessage(ExitCode)
//      else if ExitCode > 0 then
//        MessageDlg('Erreur lors du traitement', mtError, [mbOK], 0)
//      else
//        MessageDlg('Traitement terminé correctement.', mtInformation, [mbOK], 0);
    finally
      FreeAndNil(thread);
      GestionInterface(True);
    end;
  end;

  procedure ExternalBackup();
  var
    Result : integer;
    ExeFile, ErrorMsg : string;
  begin
    try
      GestionInterface(False);

      Lab_Status.Caption := 'Backup / Restore';
      Application.ProcessMessages();

      ExeFile := ExtractFileDrive(Ed_CheminBase.Text) + BACKUP_EXE_PATH + BACKUP_EXE_FILE;
      if FileExists(ExeFile) then
      begin
        Result := ExecAndWaitProcess(ErrorMsg, '"' + ExeFile + '"', BACKUP_EXE_PARAM, false);
        if Result = 0 then
          ExitCode := CODE_RETOUR_OK
        else
          ExitCode := CODE_RETOUR_ERREUR_BACKUP_FAIL;
      end
      else
        ExitCode := CODE_RETOUR_ERREUR_BACKUP_NOFILE;

      Lab_Status.Caption := '';
      Application.ProcessMessages();

      if FAuto then
        PostQuitMessage(ExitCode)
      else if ExitCode > 0 then
        MessageDlg('Erreur lors du traitement', mtError, [mbOK], 0)
      else
        MessageDlg('Traitement terminé correctement.', mtInformation, [mbOK], 0);
    finally
      GestionInterface(True);
    end;
  end;

begin
  if Fauto or (MessageDlg('Voullez vous lancer l''utilitaire de backup ?'#13'(sinon traitement interne)', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
    ExternalBackup()
  else
    IntegratedBackup();
end;

// reboot !

procedure TFrm_Main.Btn_RebootClick(Sender: TObject);
begin
  DoRebootMachine(30);
end;

// replication !

procedure TFrm_Main.Btn_ReplicClick(Sender: TObject);
var
  Result : integer;
  ExeFile, ErrorMsg : string;
begin
  try
    GestionInterface(False);

    Lab_Status.Caption := 'Replication';
    Application.ProcessMessages();

    ExeFile := ExtractFileDrive(Ed_CheminBase.Text) + REPLIC_EXE_PATH + REPLIC_EXE_FILE;
    if FileExists(ExeFile) then
    begin
      // Ici "shellexecute" car nous ne pouvons attendre la fin du process :
      // - soit deja lancer et fin du process de uite
      // - soit pas encore lancer et jamais de fin du process ...
      // donc juste lancement et vaille que vaille
      if ShellExecute(0, 'open', PWideChar('"' + ExeFile + '"'), PWideChar('"' + ExeFile + '" ' + REPLIC_EXE_PARAM), PWideChar(ExtractFilePath(ExeFile)), SW_SHOWNORMAL) > 32 then
        ExitCode := CODE_RETOUR_OK
      else
        ExitCode := CODE_RETOUR_ERREUR_REPLIC_FAIL;
    end
    else
      ExitCode := CODE_RETOUR_ERREUR_REPLIC_NOFILE;

    Lab_Status.Caption := '';
    Application.ProcessMessages();

    if FAuto then
      PostQuitMessage(ExitCode)
    else if ExitCode > 0 then
      MessageDlg('Erreur lors du traitement', mtError, [mbOK], 0)
    else
      MessageDlg('Traitement terminé correctement.', mtInformation, [mbOK], 0);
  finally
    GestionInterface(True);
  end;
end;

// Gestion du fichier Ini

procedure TFrm_Main.Btn_SvgIniClick(Sender: TObject);
var
  IniFile : string;
  Ini : TInifile;
begin
  // lecture des paramètres
  IniFile := ChangeFileExt(ParamStr(0), '.ini');
  try
    Ini := TIniFile.Create(IniFile);
    Ini.WriteString('Conf', 'CheminScript', Ed_CheminScript.Text);
    Ini.WriteString('Conf', 'AccesLame', Ed_AccesLameLame.Text);
    Ini.WriteString('Conf', 'AccesSite', Ed_AccesLameSite.Text);
  finally
    FreeAndNil(Ini);
  end;
end;

// Gestion du Drag and Drop

procedure TFrm_Main.MessageDropFiles(var msg : TWMDropFiles);
const
  MAXFILENAME = 255;
var
  i, Count, Attr : integer;
  FileName : array [0..MAXFILENAME] of char;
  FileExt : string;
begin
  try
    // le nb de fichier
    Count := DragQueryFile(msg.Drop, $FFFFFFFF, FileName, MAXFILENAME);
    // Recuperation des fichier (nom)
    for i := 0 to Count -1 do
    begin
      DragQueryFile(msg.Drop, i, FileName, MAXFILENAME);

      Attr := FileGetAttr(FileName, false);
      if (Attr and faDirectory) > 0 then
        Ed_AccesLameLame.Text := FileName
      else
      begin
        FileExt := UpperCase(ExtractFileExt(FileName));
        if FileExt = '.IB' then
          Ed_CheminBase.Text := FileName
        else if FileExt = '.EXE' then
          Ed_CheminScript.Text := FileName
        else if (FileExt = '.SCR') and FileExists(ChangeFileExt(FileName, '.exe')) then
          Ed_CheminScript.Text := ChangeFileExt(FileName, '.exe');
      end;
    end;
  finally
    DragFinish(msg.Drop);
  end;
end;

// utilitaire

function TFrm_Main.DoRebootMachine(Time : Cardinal) : boolean;
var
  hToken : THandle;
  tp, prev_tp : TTokenPrivileges;
  Len : DWORD;
begin
  if OpenProcessToken(GetCurrentProcess(), TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, hToken) then
  begin
    try
      if LookupPrivilegeValue('', 'SeShutdownPrivilege', tp.Privileges[0].Luid) then
      begin
        tp.PrivilegeCount := 1;
        tp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
        if AdjustTokenPrivileges(hToken, False, tp, SizeOf(prev_tp), prev_tp, Len) then
        else
          ; // Cannot change privileges -> GetLastError
      end
      else
        ; // Cannot get the LUID -> GetLastError
    finally
      CloseHandle(hToken);
    end;
  end
  else
    ; // Cannot open process token -> GetLastError

  Result := InitiateSystemShutdown('', 'Reboot suite a MigreV13', 30, true, true);
end;

function TFrm_Main.SetRunOnce(cmdline : string) : boolean;
var
  Reg : TRegistry;
begin
  Result := true;
  try
    try
      Reg := TRegistry.Create(KEY_ALL_ACCESS);
      Reg.RootKey := HKEY_LOCAL_MACHINE;
      Reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce', true);
      Reg.WriteString('RESTARTAPP', cmdline);
    finally
      FreeAndNil(Reg);
    end;
  except
    Result := false;
  end;
end;

procedure TFrm_Main.GestionInterface(Enabled : Boolean; ShowMessage : boolean);

  function IsBaseLame() : boolean;
  var
    Connexion : TIB_Connection;
    Transaction : TIB_Transaction;
    Query : TIBOQuery;
  begin
    Result := false;
    try
      try
        Connexion := TIB_Connection.Create(nil);
        Connexion.DatabaseName := AnsiString(Ed_CheminBase.Text);
        Connexion.Username := 'sysdba';
        Connexion.Password := 'masterkey';

        Transaction := TIB_Transaction.Create(nil);
        Transaction.IB_Connection := Connexion;

        Query := TIBOQuery.Create(nil);
        Query.IB_Connection := Connexion;
        Query.IB_Transaction := Transaction;
        Query.ParamCheck := False;

        Transaction.StartTransaction();

        Query.SQL.Text := 'select retour from bn_only_pantin;';
        Query.Open();
        if not Query.Eof then
          Result := (Query.FieldByName('retour').AsInteger > 0);
        Query.Close();

        Transaction.Rollback();
      finally
        FreeAndNil(Query);
        FreeAndNil(Transaction);
        FreeAndNil(Connexion);
      end;
    except
      on e : Exception do
      begin
{$IFDEF DEBUG}
        MessageDlg('Exception : ' + e.Message, mtError, [mbOK], 0);
{$ENDIF}
        Result := false;
      end;
    end;
  end;

  function IsBasePlatform() : boolean;
  var
    Connexion : TIB_Connection;
    Transaction : TIB_Transaction;
    Query : TIBOQuery;
  begin
    Result := false;
    try
      try
        Connexion := TIB_Connection.Create(nil);
        Connexion.DatabaseName := AnsiString(Ed_CheminBase.Text);
        Connexion.Username := 'sysdba';
        Connexion.Password := 'masterkey';

        Transaction := TIB_Transaction.Create(nil);
        Transaction.IB_Connection := Connexion;

        Query := TIBOQuery.Create(nil);
        Query.IB_Connection := Connexion;
        Query.IB_Transaction := Transaction;
        Query.ParamCheck := False;

        Transaction.StartTransaction();

        Query.SQL.Text := 'select retour from bn_only_pantin;';
        Query.Open();
        if not Query.Eof and (Query.FieldByName('retour').AsInteger = 0) then
        begin
          Query.Close();
          Query.SQL.Text := 'select par_string from genparambase where par_nom = ''IDGENERATEUR'';';
          Query.Open();
          if not Query.Eof then
            Result := (Query.FieldByName('par_string').AsString = '0');
        end;
        Query.Close();

        Transaction.Rollback();
      finally
        FreeAndNil(Query);
        FreeAndNil(Transaction);
        FreeAndNil(Connexion);
      end;
    except
      on e : Exception do
      begin
{$IFDEF DEBUG}
        MessageDlg('Exception : ' + e.Message, mtError, [mbOK], 0);
{$ENDIF}
        Result := false;
      end;
    end;
  end;

  function VerifInfoBase() : boolean;
  var
    Connexion : TIB_Connection;
    Transaction : TIB_Transaction;
    Query : TIBOQuery;
  begin
    Result := false;
    try
      try
        Connexion := TIB_Connection.Create(nil);
        Connexion.DatabaseName := AnsiString(Ed_CheminBase.Text);
        Connexion.Username := 'sysdba';
        Connexion.Password := 'masterkey';

        Transaction := TIB_Transaction.Create(nil);
        Transaction.IB_Connection := Connexion;

        Query := TIBOQuery.Create(nil);
        Query.IB_Connection := Connexion;
        Query.IB_Transaction := Transaction;
        Query.ParamCheck := False;

        Transaction.StartTransaction();

        Query.SQL.Text := 'select count(*) as res from rdb$relations where upper(rdb$relation_name) in (''AGRHISTOPUMP'', ''AGRPUMPCOUR'', ''ARTRELATIONAXE'')';
        Query.Open();
        if not Query.Eof and (Query.FieldByName('res').AsInteger = 3) then
        begin
          Query.Close();
          Query.SQL.Text := 'select count(*) as res from artrelationaxe where arx_id > 0;';
          Query.Open();
          if not Query.Eof then
            result := Query.FieldByName('res').AsInteger = 0;
        end;
        Query.Close();

        Transaction.Rollback();
      finally
        FreeAndNil(Query);
        FreeAndNil(Transaction);
        FreeAndNil(Connexion);
      end;
    except
      on e : Exception do
      begin
{$IFDEF DEBUG}
        MessageDlg('Exception : ' + e.Message, mtError, [mbOK], 0);
{$ENDIF}
        Result := false;
      end;
    end;
  end;

  function VerifRecalculDone() : Boolean;
  var
    Connexion : TIB_Connection;
    Transaction : TIB_Transaction;
    Query : TIBOQuery;
  begin
    Result := false;
    try
      try
        Connexion := TIB_Connection.Create(nil);
        Connexion.DatabaseName := AnsiString(Ed_CheminBase.Text);
        Connexion.Username := 'sysdba';
        Connexion.Password := 'masterkey';

        Transaction := TIB_Transaction.Create(nil);
        Transaction.IB_Connection := Connexion;

        Query := TIBOQuery.Create(nil);
        Query.IB_Connection := Connexion;
        Query.IB_Transaction := Transaction;
        Query.ParamCheck := False;

        Transaction.StartTransaction();

        Query.SQL.Text := 'select count(*) as nb from gentrigger;';
        Query.Open();
        if not Query.Eof then
          Result := (Query.FieldByName('nb').AsInteger = 0);
        Query.Close();

        Transaction.Rollback();
      finally
        FreeAndNil(Query);
        FreeAndNil(Transaction);
        FreeAndNil(Connexion);
      end;
    except
      on e : Exception do
      begin
{$IFDEF DEBUG}
        MessageDlg('Exception : ' + e.Message, mtError, [mbOK], 0);
{$ENDIF}
        Result := false;
      end;
    end;
  end;

  function VerifVersionAlreadyDone() : boolean;

    function GetVersionsList() : TStringList;
    var
      Connexion : TIB_Connection;
      Transaction : TIB_Transaction;
      Query : TIBOQuery;
    begin
      Result := TStringList.Create();
      try
        try
          Connexion := TIB_Connection.Create(nil);
          Connexion.DatabaseName := AnsiString(Ed_CheminBase.Text);
          Connexion.Username := 'sysdba';
          Connexion.Password := 'masterkey';

          Transaction := TIB_Transaction.Create(nil);
          Transaction.IB_Connection := Connexion;

          Query := TIBOQuery.Create(nil);
          Query.IB_Connection := Connexion;
          Query.IB_Transaction := Transaction;
          Query.ParamCheck := False;

          Transaction.StartTransaction();

          Query.SQL.Text := 'select distinct(ver_version) as version from genversion order by ver_date desc;';
          Query.Open();
          while not Query.Eof do
          begin
            Result.Add(Query.FieldByName('version').AsString);
            Query.Next();
          end;
          Query.Close();

          Transaction.Rollback();
        finally
          FreeAndNil(Query);
          FreeAndNil(Transaction);
          FreeAndNil(Connexion);
        end;
      except
        on e : Exception do
        begin
{$IFDEF DEBUG}
          MessageDlg('Exception : ' + e.Message, mtError, [mbOK], 0);
{$ENDIF}
          Result.clear();
        end;
      end;
    end;

  var
    Versions : TStringList;
  begin
    Result := true;
    try
      Versions := GetVersionsList();
      if Versions.Count > 1 then
      begin
        if (CompareVersion(Versions[1], VERSION_BASE_SRC) <= EqualsValue) and
           (CompareVersion(Versions[0], VERSION_BASE_DEST) >= EqualsValue) then
          Result := false;
      end;
    finally
      FreeAndNil(Versions);
    end;
  end;

  function VerifIsSp2k() : boolean;
  var
    Connexion : TIB_Connection;
    Transaction : TIB_Transaction;
    Query : TIBOQuery;
  begin
    Result := false;
    try
      try
        Connexion := TIB_Connection.Create(nil);
        Connexion.DatabaseName := AnsiString(Ed_CheminBase.Text);
        Connexion.Username := 'sysdba';
        Connexion.Password := 'masterkey';

        Transaction := TIB_Transaction.Create(nil);
        Transaction.IB_Connection := Connexion;

        Query := TIBOQuery.Create(nil);
        Query.IB_Connection := Connexion;
        Query.IB_Transaction := Transaction;
        Query.ParamCheck := False;

        Transaction.StartTransaction();

        Query.SQL.Text := 'select Upper(f_stripstring(bas_centrale, '' '')) as bas_centrale from genbases where bas_ident = ''0''';
        Query.Open();
        if not Query.Eof then
          Result := (Query.FieldByName('bas_centrale').AsString = 'SPORT2000');
        Query.Close();

        Transaction.Rollback();
      finally
        FreeAndNil(Query);
        FreeAndNil(Transaction);
        FreeAndNil(Connexion);
      end;
    except
      on e : Exception do
      begin
{$IFDEF DEBUG}
        MessageDlg('Exception : ' + e.Message, mtError, [mbOK], 0);
{$ENDIF}
        Result := false;
      end;
    end;
  end;

  function VerifFedasIsDone() : boolean;
  var
    Connexion : TIB_Connection;
    Transaction : TIB_Transaction;
    Query : TIBOQuery;
  begin
    Result := false;
    try
      try
        Connexion := TIB_Connection.Create(nil);
        Connexion.DatabaseName := AnsiString(Ed_CheminBase.Text);
        Connexion.Username := 'sysdba';
        Connexion.Password := 'masterkey';

        Transaction := TIB_Transaction.Create(nil);
        Transaction.IB_Connection := Connexion;

        Query := TIBOQuery.Create(nil);
        Query.IB_Connection := Connexion;
        Query.IB_Transaction := Transaction;
        Query.ParamCheck := False;

        Transaction.StartTransaction();

        Query.SQL.Text := 'select prm_float from genparam where prm_type = 3 and prm_code = 71;';
        Query.Open();
        if not Query.Eof then
          Result := (Query.FieldByName('prm_float').AsFloat = 1);
        Query.Close();

        Transaction.Rollback();
      finally
        FreeAndNil(Query);
        FreeAndNil(Transaction);
        FreeAndNil(Connexion);
      end;
    except
      on e : Exception do
      begin
{$IFDEF DEBUG}
        MessageDlg('Exception : ' + e.Message, mtError, [mbOK], 0);
{$ENDIF}
        Result := false;
      end;
    end;
  end;

  function VerifGroupePUMP() : boolean;
  var
    Connexion : TIB_Connection;
    Transaction : TIB_Transaction;
    Query : TIBOQuery;
  begin
    Result := false;
    try
      try
        Connexion := TIB_Connection.Create(nil);
        Connexion.DatabaseName := AnsiString(Ed_CheminBase.Text);
        Connexion.Username := 'sysdba';
        Connexion.Password := 'masterkey';

        Transaction := TIB_Transaction.Create(nil);
        Transaction.IB_Connection := Connexion;

        Query := TIBOQuery.Create(nil);
        Query.IB_Connection := Connexion;
        Query.IB_Transaction := Transaction;
        Query.ParamCheck := False;

        Transaction.StartTransaction();

        Query.SQL.add('select mag_id,');
        Query.SQL.add('  (');
        Query.SQL.add('    select count(*)');
        Query.SQL.add('    from genmaggestionpump join k on k_id = mpu_id');
        Query.SQL.add('    where mpu_magid = genmagasin.mag_id and k_enabled = 1');
        Query.SQL.add('  ) as nblien');
        Query.SQL.add('from genmagasin join k on k_id = mag_id');
        Query.SQL.add('where mag_id != 0 and k_enabled = 1;');
        Query.Open();
        if not Query.Eof then
        begin
          Result := true;
          while not Query.Eof do
          begin
            if Query.FieldByName('nblien').AsFloat <> 1 then
            begin
              Result := false;
              Break;
            end;
            Query.Next();
          end;
        end;
        Query.Close();

        Transaction.Rollback();
      finally
        FreeAndNil(Query);
        FreeAndNil(Transaction);
        FreeAndNil(Connexion);
      end;
    except
      on e : Exception do
      begin
{$IFDEF DEBUG}
        MessageDlg('Exception : ' + e.Message, mtError, [mbOK], 0);
{$ENDIF}
        Result := false;
      end;
    end;
  end;

var
  ExistsBase, ExistsScript, AcessLameOK, CanDo : Boolean;
  VerStr : string;
begin
  if not Enabled then
    Screen.Cursor := crHourGlass;

  try
    // blocage temporaire
    Self.Enabled := False;

    // reinit du code de sortie
    ExitCode := CODE_RETOUR_OK;

    // gestion du type de traitement (lame ou site)
    Lab_CheminScript.Visible := Rgr_WhereBase.ItemIndex < 2;
    Ed_CheminScript.Visible := Rgr_WhereBase.ItemIndex < 2;
    Nbt_CheminScript.Visible := Rgr_WhereBase.ItemIndex < 2;
    Ed_AccesLameLame.Visible := Rgr_WhereBase.ItemIndex < 2;
    Nbt_AccesLame.Visible := Rgr_WhereBase.ItemIndex < 2;
    Ed_AccesLameSite.Visible := Rgr_WhereBase.ItemIndex > 1;
    case TWhereBAse(Rgr_WhereBase.ItemIndex) of
      wb_Lame :
        begin
          Caption := FCaptionBase + ' - version Lame';
          Lab_AccesLame.Caption := 'Accès a la lame OCEALIS';
        end;
      wb_Platform :
        begin
          Caption := FCaptionBase + ' - version Platform';
          Lab_AccesLame.Caption := 'Fichier GUID de la platform'
        end;
      else
        begin
          Caption := FCaptionBase + ' - version Site';
          Lab_AccesLame.Caption := 'Accès a la lame OCEALIS';
        end;
    end;

    // Gestion du possible a faire
    ExistsBase := FileExists(Ed_CheminBase.Text);
    ExistsScript := FileExists(Ed_CheminScript.Text);
    case TWhereBase(Rgr_WhereBase.ItemIndex) of
      wb_Lame :
        AcessLameOK := DirectoryExists(Ed_AccesLameLame.Text);
      wb_Platform :
        AcessLameOK := FileExists(Ed_AccesLameLame.Text);
      else
        AcessLameOK := not (Trim(Ed_AccesLameSite.Text) = '');
    end;

    // selon
    CanDo := false;
    if ExistsBase and ExistsScript then
    begin
      case TWhereBase(Rgr_WhereBase.ItemIndex) of
        wb_Lame :
          begin
            if IsBaseLame() then
            begin
              VerStr := GetVersion(Ed_CheminBase.Text);
              if CompareVersion(VerStr, VERSION_BASE_SRC) = EqualsValue then
              begin
                if VerifInfoBase() then
                begin
                  if ShowMessage and not VerifRecalculDone() then
                    MessageDlg('Attention'#13'Il y a du recalcul de trigger a faire sur cette base.'#13'Le traitement sera surement (encore plus) long.', mtWarning, [mbOK], 0);
                  CanDo := true;
                end
                else
                begin
                  if ShowMessage then
                    MessageDlg('La version a déjà été passé.', mtError, [mbOK], 0);
                  ExitCode := CODE_RETOUR_ERREUR_ALREADY_DONE;
                end;
              end
              else
              begin
                if ShowMessage then
                  MessageDlg('La base n''est pas dans la bonne version'#13'(' + VerStr + ' pour ' + VERSION_BASE_SRC + ').', mtError, [mbOK], 0);
                ExitCode := CODE_RETOUR_ERREUR_BASE_VERSION;
              end;
            end
            else
            begin
              if ShowMessage then
              begin
                if IsBasePlatform() and (MessageDlg('La base semble être une base de platform.'#13'Voullez-vous passé en mode platform ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
                begin
                  Rgr_WhereBase.ItemIndex := Ord(wb_Platform);
                  Exit;
                end;

                MessageDlg('La base n''est pas une base de la lame.', mtError, [mbOK], 0);
              end;
              ExitCode := CODE_RETOUR_ERREUR_BASE_SITE;
            end;
          end;
        wb_Platform :
          begin
            if not IsBaseLame() and IsBasePlatform() then
            begin
              VerStr := GetVersion(Ed_CheminBase.Text);
              if CompareVersion(VerStr, VERSION_BASE_SRC) = EqualsValue then
              begin
                if VerifInfoBase() then
                begin
                  if ShowMessage and not VerifRecalculDone() then
                    MessageDlg('Attention'#13'Il y a du recalcul de trigger a faire sur cette base.'#13'Le traitement sera surement (encore plus) long.', mtWarning, [mbOK], 0);
                  CanDo := true;
                end
                else
                begin
                  if ShowMessage then
                    MessageDlg('La version a déjà été passé.', mtError, [mbOK], 0);
                  ExitCode := CODE_RETOUR_ERREUR_ALREADY_DONE;
                end;
              end
              else
              begin
                if ShowMessage then
                  MessageDlg('La base n''est pas dans la bonne version'#13'(' + VerStr + ' pour ' + VERSION_BASE_SRC + ').', mtError, [mbOK], 0);
                ExitCode := CODE_RETOUR_ERREUR_BASE_VERSION;
              end;
            end
            else
            begin
              if ShowMessage then
                MessageDlg('La base n''est pas une base de platform.', mtError, [mbOK], 0);
              ExitCode := CODE_RETOUR_ERREUR_BASE_SITE;
            end;
          end;
        else
          begin
            if not IsBaseLame() then
            begin
              VerStr := GetVersion(Ed_CheminBase.Text);
              if CompareVersion(VerStr, VERSION_BASE_DEST) in [EqualsValue, GreaterThanValue] then
              begin
                if not VerifVersionAlreadyDone() and VerifInfoBase() then
                  CanDo := true
                else
                begin
                  if ShowMessage then
                    MessageDlg('La version a déjà été passé.', mtError, [mbOK], 0);
                  ExitCode := CODE_RETOUR_ERREUR_ALREADY_DONE;
                end;
              end
              else
              begin
                if ShowMessage then
                  MessageDlg('La base n''est pas dans la bonne version'#13'(' + VerStr + ' pour ' + VERSION_BASE_DEST + ').', mtError, [mbOK], 0);
                ExitCode := CODE_RETOUR_ERREUR_BASE_VERSION;
              end;
            end
            else
            begin
              if ShowMessage then
                MessageDlg('La base n''est pas une base magasin.', mtError, [mbOK], 0);
              ExitCode := CODE_RETOUR_ERREUR_BASE_LAME;
            end;
          end;
      end;

      // test de la fedas sp2k
      if VerifIsSp2k() then
      begin
        if not VerifFedasIsDone() then
        begin
          if ShowMessage then
            MessageDlg('La fedas Sport 2000 n''as pas été integré...', mtError, [mbOK], 0);
          CanDo := false;
          ExitCode := CODE_RETOUR_ERREUR_VERIF_SP2k;
        end;
      end;

      // Test des group de pump
      if not VerifGroupePUMP() then
      begin
        if ShowMessage then
          MessageDlg('L''un des magasin n''as pas ou as plusieur groupe de PUMP.', mtError, [mbOK], 0);
        CanDo := false;
        ExitCode := CODE_RETOUR_ERREUR_VERIF_GRPPUMP;
      end;
    end;


    // activation de l'interface general
    Lab_CheminBase.Enabled := Enabled;
    Ed_CheminBase.Enabled := Enabled;
    Nbt_CheminBase.Enabled := Enabled;
    Lab_CheminScript.Enabled := Enabled;
    Ed_CheminScript.Enabled := Enabled;
    Nbt_CheminScript.Enabled := Enabled;
    Lab_AccesLame.Enabled := Enabled;
    Ed_AccesLameLame.Enabled := Enabled;
    Nbt_AccesLame.Enabled := Enabled;
    Ed_AccesLameSite.Enabled := Enabled;

    Btn_SvgIni.Enabled := Enabled;
    Btn_Lancer.Enabled := Enabled and ((AcessLameOK and CanDo) or ((CompareVersion(VerStr, VERSION_BASE_UNDEF) in [EqualsValue, GreaterThanValue]) and FForce));
    Btn_Quitter.Enabled := Enabled;

    Rgr_WhereBase.Enabled := Enabled;

    // Version lame
    Pan_Lame_Trans.Enabled := Enabled and (Rgr_WhereBase.ItemIndex < 2);
    Btn_Lame_Nettoyage.Enabled := Enabled and (Rgr_WhereBase.ItemIndex < 2) and ExistsBase;
    Btn_Lame_Recalcul.Enabled := Enabled and (Rgr_WhereBase.ItemIndex < 2) and ExistsBase;
    Btn_Lame_DoScript.Enabled := Enabled and (Rgr_WhereBase.ItemIndex < 2) and ExistsBase and ExistsScript;
    Btn_Platform_DownLoad.Enabled := Enabled and AcessLameOK and (Rgr_WhereBase.ItemIndex = 1);
    Btn_Lame_CreateTE.Enabled := Enabled and (Rgr_WhereBase.ItemIndex < 2) and ExistsBase;
    Btn_Lame_PreCorrection.Enabled := Enabled and (Rgr_WhereBase.ItemIndex < 2) and ExistsBase;
    Btn_Lame_DoInitNomenclature.Enabled := Enabled and (Rgr_WhereBase.ItemIndex < 2) and ExistsBase;
    Btn_Lame_DoInitTailleGrille.Enabled := Enabled and (Rgr_WhereBase.ItemIndex < 2) and ExistsBase;
    Btn_Lame_DoInitAgrHistoStock.Enabled := Enabled and (Rgr_WhereBase.ItemIndex < 2) and ExistsBase;
    Chk_Lame_Hst_DesIndex.Enabled := Enabled and (Rgr_WhereBase.ItemIndex < 2) and ExistsBase;
    Btn_Lame_DoInitAgrStockCour.Enabled := Enabled and (Rgr_WhereBase.ItemIndex < 2) and ExistsBase;
    Btn_Lame_DoInitAgrMouvement.Enabled := Enabled and (Rgr_WhereBase.ItemIndex < 2) and ExistsBase;
    Chk_Lame_Mvt_DesIndex.Enabled := Enabled and (Rgr_WhereBase.ItemIndex < 2) and ExistsBase;
    Btn_Lame_DoInitAgrFouStat.Enabled := Enabled and (Rgr_WhereBase.ItemIndex < 2) and ExistsBase;
    Btn_Lame_DoInitArtRelationAxe.Enabled := Enabled and (Rgr_WhereBase.ItemIndex < 2) and ExistsBase;
    Btn_Lame_CreateArtRelationAxe.Enabled := Enabled and (Rgr_WhereBase.ItemIndex = 0) and ExistsBase;
    Btn_Lame_ExportArtRelationAxe.Enabled := Enabled and (Rgr_WhereBase.ItemIndex = 0) and ExistsBase and AcessLameOK;
    Btn_Platform_ImportArtRelationAxe.Enabled := Enabled and (Rgr_WhereBase.ItemIndex = 1) and ExistsBase and AcessLameOK;
    Btn_Lame_InitGencentrale.Enabled := Enabled and (Rgr_WhereBase.ItemIndex < 2) and ExistsBase;
    Btn_Lame_InitParamJeton.Enabled := Enabled and (Rgr_WhereBase.ItemIndex < 2) and ExistsBase;
    Btn_Lame_PostCorrection.Enabled := Enabled and (Rgr_WhereBase.ItemIndex < 2) and ExistsBase;
    Btn_Lame_DoSupprOldTables.Enabled := Enabled and (Rgr_WhereBase.ItemIndex < 2) and ExistsBase;
    Btn_Lame_SupprTE.Enabled := Enabled and (Rgr_WhereBase.ItemIndex < 2) and ExistsBase;
    Btn_Lame_Upload.Enabled := Enabled and (Rgr_WhereBase.ItemIndex = 0) and FileExists(FInterbaseExt + INTERBASE_EXT_ARTRELATIONAXE) and FileExists(FInterbaseExt + INTERBASE_EXT_GENCENTRALE) and AcessLameOK;
    Btn_Platform_Copy.Enabled := Enabled and (Rgr_WhereBase.ItemIndex = 1) and AcessLameOK;
    Btn_Lame_SupprFileTable.Enabled := Enabled and (Rgr_WhereBase.ItemIndex < 2) and FileExists(FInterbaseExt + INTERBASE_EXT_ARTRELATIONAXE) and FileExists(FInterbaseExt + INTERBASE_EXT_GENCENTRALE);
    Btn_Lame_DoInitFedasSP2K.Enabled := Enabled and (Rgr_WhereBase.ItemIndex < 2) and ExistsBase;

    // Version Site
    Pan_Site_Trans.Enabled := Enabled and (Rgr_WhereBase.ItemIndex > 1);
    Btn_Site_Nettoyage.Enabled := Enabled and (Rgr_WhereBase.ItemIndex > 1) and ExistsBase;
    Btn_Site_DownLoad.Enabled := Enabled and (Rgr_WhereBase.ItemIndex > 1) and AcessLameOK;
    Btn_Site_CreateTE.Enabled := Enabled and (Rgr_WhereBase.ItemIndex > 1) and ExistsBase;
    Btn_Site_PreCorrection.Enabled := Enabled and (Rgr_WhereBase.ItemIndex > 1) and ExistsBase;
    Btn_Site_DoInitNomenclature.Enabled := Enabled and (Rgr_WhereBase.ItemIndex > 1) and ExistsBase;
    Btn_Site_DoInitTailleGrille.Enabled := Enabled and (Rgr_WhereBase.ItemIndex > 1) and ExistsBase;
    Btn_Site_DoInitAgrHistoStock.Enabled := Enabled and (Rgr_WhereBase.ItemIndex > 1) and ExistsBase;
    Chk_Site_Hst_DesIndex.Enabled := Enabled and (Rgr_WhereBase.ItemIndex > 1) and ExistsBase;
    Btn_Site_DoInitAgrStockCour.Enabled := Enabled and (Rgr_WhereBase.ItemIndex > 1) and ExistsBase;
    Btn_Site_DoInitAgrMouvement.Enabled := Enabled and (Rgr_WhereBase.ItemIndex > 1) and ExistsBase;
    Chk_Site_Mvt_DesIndex.Enabled := Enabled and (Rgr_WhereBase.ItemIndex > 1) and ExistsBase;
    Btn_Site_DoInitAgrFouStat.Enabled := Enabled and (Rgr_WhereBase.ItemIndex > 1) and ExistsBase;
    Btn_Site_DoInitArtRelationAxe.Enabled := Enabled and (Rgr_WhereBase.ItemIndex > 1) and ExistsBase;
    Btn_Site_ImportArtRelationAxe.Enabled := Enabled and (Rgr_WhereBase.ItemIndex > 1) and ExistsBase;
    Btn_Site_ComplArtRelationAxe.Enabled := Enabled and (Rgr_WhereBase.ItemIndex > 1) and ExistsBase;
    Btn_Site_InitGenCentrale.Enabled := Enabled and (Rgr_WhereBase.ItemIndex > 1) and ExistsBase;
    Btn_Site_PostCorrection.Enabled := Enabled and (Rgr_WhereBase.ItemIndex > 1) and ExistsBase;
    Btn_Site_InitParamJeton.Enabled := Enabled and (Rgr_WhereBase.ItemIndex > 1) and ExistsBase;
    Btn_Site_DoSupprOldTables.Enabled := Enabled and (Rgr_WhereBase.ItemIndex > 1) and ExistsBase;
    Btn_Site_SupprTE.Enabled := Enabled and (Rgr_WhereBase.ItemIndex > 1) and ExistsBase;
    Btn_Site_SupprFileTable.Enabled := Enabled and (Rgr_WhereBase.ItemIndex > 1) and FileExists(FInterbaseExt + INTERBASE_EXT_ARTRELATIONAXE) and FileExists(FInterbaseExt + INTERBASE_EXT_GENCENTRALE);
    Btn_Site_DoInitFedasSP2K.Enabled := Enabled and (Rgr_WhereBase.ItemIndex > 1) and ExistsBase;

    // Gestion du GFIX
    Btn_GfixBegin.Enabled := Enabled and ExistsBase;
    Btn_GfixEnd.Enabled := Enabled and ExistsBase;
    // Gestion de la sauvegarde
    Btn_Sauvegarde.Enabled := Enabled and ExistsBase;
    // Gestion du backup/retore
    Btn_Backup.Enabled := Enabled and ExistsBase;
    // Gestion du reboot !
    Btn_Reboot.Enabled := Enabled;
  finally
    // deblocage
    Self.Enabled := True;
  end;

  if Enabled then
    Screen.Cursor := crDefault;
end;

{ TMonThread }

function TMonThread.GetStrDuree(Deb : TDateTime) : string;

  function GetStrDuree(var Duree : Cardinal; Diviseur : cardinal) : string;
  var
    Reste : Cardinal;
  begin
    Result := '';
    try
      Reste := Duree mod Diviseur;
      Result := Format('%.' + IntToStr(Length(IntToStr(Diviseur -1))) + 'd', [Reste]);
      Duree := Duree div Diviseur;
    except

    end;
  end;

var
  Duree : Cardinal;
begin
  Result := '';
  Duree := MilliSecondsBetween(Now(), Deb);

  // les milliseconde
  Result := GetStrDuree(Duree, 1000) + 'ms';
  if Duree = 0 then
    Exit;

  // les secondes
  Result := GetStrDuree(Duree, 60) + 's ' + Result;
  if Duree = 0 then
    Exit;

  // les Minutes
  Result := GetStrDuree(Duree, 60) + 'm ' + Result;
  if Duree = 0 then
    Exit;

  // les Heures
  Result := GetStrDuree(Duree, 24) + 'h ' + Result;
  if Duree = 0 then
    Exit;

  Result := IntToStr(Duree) + 'j ' + Result;
end;

// methode principal

procedure TMonThread.Execute();
var
  Deb : TDateTime;
  Res : Boolean;
  Error : string;
  Verif : TBackupVerif;
begin
  ReturnValue := CODE_RETOUR_UNKNOWN_ERROR;
  Deb := DoLog('Base de données : ' + FCheminBase);
  DoLog('Scripts.exe     : ' + FCheminScript);
  DoLog('Accès Lame2     : ' + FAccesLame);
  DoLog('');
  DoLog('Debut du traitement');
  DoLog('');

  try
    FEtape := '1 - Tunning de la base';
    Synchronize(DoEtape);
    if not DoGFixBegin() then
    begin
      ReturnValue := CODE_RETOUR_ERREUR_TUNNING_BEGIN;
      Error := 'Erreur lors du tunning de la base';
      Exit;
    end;

    FEtape := '2 - Sauvegarde de la base';
    Synchronize(DoEtape);
    if not DoSauvegardeBase() then
    begin
      ReturnValue := CODE_RETOUR_ERREUR_SAUVEGARDE;
      Error := 'Erreur lors de la Sauvegarde de la base';
      Exit;
    end;

    FEtape := '3 - Récupération du GUID';
    Synchronize(DoEtape);
    FBaseGuid := GetGUIDBase();
    if Trim(FBaseGuid) = '' then
    begin
      ReturnValue := CODE_RETOUR_ERREUR_NO_GUID;
      Error := 'Base sans GUID';
      Exit;
    end;
    DoLog('GUID base       : ' + FBaseGuid);

    FEtape := '4 - Nettoyage';
    Synchronize(DoEtape);
    if not DoNettoyageBase() then
    begin
      ReturnValue := CODE_RETOUR_ERREUR_NETTOYAGE;
      Error := 'Erreur lors du nettoyage';
      Exit;
    end;

    case FWhereBase of
      wb_Lame :
        begin
          FEtape := '5 - Procedure de calcul des trigger différé';
          Synchronize(DoEtape);
          if not DoRecalculTrigger() then
          begin
            ReturnValue := CODE_RETOUR_ERREUR_RECACUL;
            Error := 'Erreur lors de la procedure de calcul des trigger différé';
            Exit;
          end;

          FEtape := '6 - Exécution du script pour passage en v13++';
          Synchronize(DoEtape);
          if not DoScript() then
          begin
            ReturnValue := CODE_RETOUR_ERREUR_SCRIPT;
            Error := 'Erreur lors de l''éxécution du script pour passage en v13++';
            Exit;
          end;

          FEtape := '7 - Téléchargement des tables externes';
          Synchronize(DoEtape);
        end;
      wb_Platform :
        begin
          FEtape := '5 - Procedure de calcul des trigger différé';
          Synchronize(DoEtape);
          if not DoRecalculTrigger() then
          begin
            ReturnValue := CODE_RETOUR_ERREUR_RECACUL;
            raise Exception.Create('Erreur lors de la procedure de calcul des trigger différé');
          end;

          FEtape := '6 - Exécution du script pour passage en v13++';
          Synchronize(DoEtape);
          if not DoScript() then
          begin
            ReturnValue := CODE_RETOUR_ERREUR_SCRIPT;
            Error := 'Erreur lors de l''éxécution du script pour passage en v13++';
            Exit;
          end;

          FEtape := '7 - Téléchargement des tables externes';
          Synchronize(DoEtape);
          if not DoGetFromLame2() then
          begin
            ReturnValue := CODE_RETOUR_ERREUR_DOWNLOAD;
            Error := 'Erreur lors du téléchargement des tables externes';
            Exit;
          end;
        end;
      wb_Site :
        begin
          FEtape := '5 - Procedure de calcul des trigger différé';
          Synchronize(DoEtape);

          FEtape := '6 - Exécution du script pour passage en v13++';
          Synchronize(DoEtape);

          FEtape := '7 - Téléchargement des tables externes';
          Synchronize(DoEtape);
          if not DoGetFromLame2() then
          begin
            ReturnValue := CODE_RETOUR_ERREUR_DOWNLOAD;
            Error := 'Erreur lors du téléchargement des tables externes';
            Exit;
          end;
        end;
    end;

    FEtape := '8 - Création des tables externes';
    Synchronize(DoEtape);
    if not DoCreateTableExterne() then
    begin
      ReturnValue := CODE_RETOUR_ERREUR_CTE;
      Error := 'Erreur lors de la création des tables externes';
      Exit;
    end;

    // si on a créer la table externe
    try
      // -> il faut droppé la table
      try
        // -> et supprimer le fichier

        FEtape := '9 - Initialisation de la base de données';
        Synchronize(DoEtape);
        if InitDB() then
        begin
          try
            try
              FEtape := '10 - Procedure de correction pré-traitement';
              Synchronize(DoEtape);
              if not DoPreCorrection() then
              begin
                ReturnValue := CODE_RETOUR_ERREUR_PRECORRECTION;
                raise Exception.Create('Erreur lors de la procedure de correction pré-traitement');
              end;

              FEtape := '11 - Création de la nomenclature';
              Synchronize(DoEtape);
              if not DoInitNomenclature() then
              begin
                ReturnValue := CODE_RETOUR_ERREUR_NMK;
                raise Exception.Create('Erreur a la création de la nomenclature');
              end;

              FEtape := '12 - Initialisation des grilles de taille';
              Synchronize(DoEtape);
              if not DoInitTailleGrille() then
              begin
                ReturnValue := CODE_RETOUR_ERREUR_TAILLE;
                raise Exception.Create('Erreur a l''initialisation des grilles de taille');
              end;

              FEtape := '13 - Récupération du PUMP dans AgrHistoStock';
              Synchronize(DoEtape);
              if not DoInitAgrHistoStock() then
              begin
                ReturnValue := CODE_RETOUR_ERREUR_STOCK_HIS;
                raise Exception.Create('Erreur a la récupération du PUMP dans AgrHistoStock');
              end;

              FEtape := '14 - Récupération du PUMP dans AgrStockCour';
              Synchronize(DoEtape);
              if not DoInitAgrStockCour() then
              begin
                ReturnValue := CODE_RETOUR_ERREUR_STOCK_COUR;
                raise Exception.Create('Erreur a la récupération du PUMP dans AgrStockCour');
              end;

              FEtape := '15 - Remplissage de la table AgrMouvement';
              Synchronize(DoEtape);
              if not DoInitAgrMouvement() then
              begin
                ReturnValue := CODE_RETOUR_ERREUR_MVT;
                raise Exception.Create('Erreur au remplissage de la table AgrMouvement');
              end;

              FEtape := '16 - Création des statistiques fournisseur';
              Synchronize(DoEtape);
              if not DoInitAgrFouStat() then
              begin
                ReturnValue := CODE_RETOUR_ERREUR_STAT_FOU;
                raise Exception.Create('Erreur a la création des statistiques fournisseur');
              end;

              FEtape := '17 - Création de la ventilation articles / axes';
              Synchronize(DoEtape);
              if not DoInitArtRelationAxe() then
              begin
                ReturnValue := CODE_RETOUR_ERREUR_ART_AXE;
                raise Exception.Create('Erreur a la création de la ventilation articles / axes');
              end;

              FEtape := '18 - Gestion de GenCentrale';
              Synchronize(DoEtape);
              if not DoInitGenCentrale() then
              begin
                ReturnValue := CODE_RETOUR_ERREUR_GENCENTRALE;
                raise Exception.Create('Erreur dans la gestion de GenCentrale');
              end;

              FEtape := '19 - Gestion Fedas Sport 2000';
              Synchronize(DoEtape);
              if not DoInitFedasSP2K() then
              begin
                ReturnValue := CODE_RETOUR_ERREUR_FEDASSP2K;
                raise Exception.Create('Erreur lors de la gestion Fedas Sport 2000');
              end;

              FEtape := '20 - Initialisation des paramètres du jeton';
              Synchronize(DoEtape);
              if not DoInitParamJeton() then
              begin
                ReturnValue := CODE_RETOUR_ERREUR_JETON;
                raise Exception.Create('Erreur a l''initialisation des paramètres du jeton');
              end;

              FEtape := '21 - Procedure de correction post-traitement';
              Synchronize(DoEtape);
              if not DoPostCorrection() then
              begin
                ReturnValue := CODE_RETOUR_ERREUR_POSTCORRECTION;
                raise Exception.Create('Erreur lors de la procedure de correction post-traitement');
              end;

              FEtape := '22 - Commit des modification';
              Synchronize(DoEtape);
              CommitTrans();
            except
              on e : Exception do
              begin
                RollBackTrans();
                Error := E.Message;
                Exit;
              end;
            end;
          finally
            FEtape := '23 - Finalisation de la base de données';
            Synchronize(DoEtape);
            FinaliseDB();
          end;
        end
        else
        begin
          ReturnValue := CODE_RETOUR_ERREUR_INITDB;
          Error := 'Erreur lors de l''initialisation de la base de données';
          Exit;
        end;
      finally
        FEtape := '24 - Suppression de la table externe';
        Synchronize(DoEtape);
        res := DoDropTableExterne();
      end;
      // Res est ici le retour de DoDropTableExterne();
      if not res then
      begin
        ReturnValue := CODE_RETOUR_ERREUR_DTE;
        Error := 'Erreur lors de la suppression de la table externe';
        Exit;
      end;

      case FWhereBase of
        wb_Lame :
          begin
            FEtape := '25 - Téléversement de la table de relation articles / axes';
            Synchronize(DoEtape);
            if not DoPutOnLame2() then
            begin
              ReturnValue := CODE_RETOUR_ERREUR_UPLOAD;
              Error := 'Erreur lors du téléversement de la table de relation articles / axes';
              Exit;
            end;

            FEtape := '26 - Renomage de la table de relation articles / axes';
            Synchronize(DoEtape);
          end;
        wb_Platform :
          begin
            FEtape := '25 - Téléversement de la table de relation articles / axes';
            Synchronize(DoEtape);

            FEtape := '26 - Renomage de la table de relation articles / axes';
            Synchronize(DoEtape);
            if not DoCopyOnLame2() then
            begin
              ReturnValue := CODE_RETOUR_ERREUR_RENAME;
              Error := 'Erreur lors du renomage de la table de relation articles / axes';
              Exit;
            end;
          end;
        wb_Site :
          begin
            FEtape := '25 - Téléversement de la table de relation articles / axes';
            Synchronize(DoEtape);

            FEtape := '26 - Renomage de la table de relation articles / axes';
            Synchronize(DoEtape);
          end;
      end;
    finally
      FEtape := '27 - Suppression du fichier de la table externe';
      Synchronize(DoEtape);
      Res := DoSupprTableExterne();
    end;
    // Res est ici le retour de DoSupprTableExterne();
    if not Res then
    begin
      ReturnValue := CODE_RETOUR_ERREUR_DTE;
      Error := 'Erreur lors de la suppression du fichier de la table externe';
      Exit;
    end;

    FEtape := '28 - Suppression des ancienne tables';
    Synchronize(DoEtape);
    if not DoSupprOldTables() then
    begin
      ReturnValue := CODE_RETOUR_ERREUR_SUPPR;
      Error := 'Erreur a la suppression des ancienne tables';
      Exit;
    end;

    case FWhereBase of
      wb_Lame,
      wb_Platform :
        begin
          FEtape := '29 - Tunning de la base';
          Synchronize(DoEtape);
          if not DoGFixEnd() then
          begin
            ReturnValue := CODE_RETOUR_ERREUR_TUNNING_END;
            Error := 'Erreur lors du tunning de la base';
            Exit;
          end;
        end;
      wb_Site :
        begin
          FEtape := '29 - Tunning de la base';
          Synchronize(DoEtape);
        end;
    end;

    try
      Verif := TBackupVerif.Create();

      FEtape := '30 - Backup de la base';
      Synchronize(DoEtape);
      if not DoBackup(Verif) then
      begin
        ReturnValue := CODE_RETOUR_ERREUR_BACKUP_FAIL;
        Error := 'Erreur au backup de la base';
        Exit;
      end;

      FEtape := '31 - Restore de la base';
      Synchronize(DoEtape);
      if not DoRestore(Verif) then
      begin
        ReturnValue := CODE_RETOUR_ERREUR_RESTORE_FAIL;
        Error := 'Erreur au restore de la base';
        Exit;
      end;

    finally
      FreeAndNil(Verif);
    end;

    ReturnValue := CODE_RETOUR_OK;
    FEtape := '30 - Suppression de la sauvegarde';
    Synchronize(DoEtape);
    if FAuto then
      DoDropSauvegarde();

    FEtape := '';
    Synchronize(DoEtape);

    DoLog('');
    DoLog('Fin du traitement (Duree : ' + GetStrDuree(Deb) + ')');
  finally
    if not (Error = '') then
    begin
      DoLog('');
      DoLog('ERREUR : ' + Error + ' (Duree : ' + GetStrDuree(Deb) + ')');
    end;
  end;
end;

// creation / destruction

constructor TMonThread.Create(CheminBase, CheminScript, AccesLame, InterbaseExt : string; WhereBase : TWhereBase; DesIndex, Auto, CreateSuspended : boolean);
begin
  inherited Create(CreateSuspended);
  FCheminBase := CheminBase;
  FCheminScript := CheminScript;
  FAccesLame := AccesLame;
  FInterbaseExt := InterbaseExt;
  FWhereBase := WhereBase;
  FDesIndex := DesIndex;
  FAuto := Auto;

  FreeOnTerminate := False;

  InitLog();
end;

destructor TMonThread.Destroy();
begin
  inherited Destroy();
end;

// Synchropnization

procedure TMonThread.DoEtape();
begin
  if not (FEtape = '') then
    DoLog(FEtape);
  Frm_Main.Pgb_Status.StepIt();
  Frm_Main.Lab_Status.Caption := FEtape;
  Application.ProcessMessages();
end;

// gestion de la Base

function TMonThread.InitDB() : Boolean;
var
  Deb : TDateTime;
begin
  Deb := DoLog('  Début InitDB');
  result := False;
  try
    FConnexion := TIB_Connection.Create(nil);
    FConnexion.DatabaseName := AnsiString(FCheminBase);
    FConnexion.Username := 'sysdba';
    FConnexion.Password := 'masterkey';
    FTransaction := TIB_Transaction.Create(nil);
    FTransaction.IB_Connection := FConnexion;
    FTransaction.StartTransaction();
    FInitialized := True;
    Result := True;
  except
    on e : Exception do
      DoLog('  Exception dans "InitDB" : ' + e.Message);
  end;
  DoLog('  Fin InitDB (Result = ' + BoolToStr(Result, true) + ') (Duree : ' + GetStrDuree(Deb) + ')');
end;

function TMonThread.GetNewQuery() : TIBOQuery;
begin
  Result := nil;

  if not FInitialized then
    if not InitDB() then
      Exit;

  Result := TIBOQuery.Create(nil);
  Result.IB_Connection := FConnexion;
  Result.IB_Transaction := FTransaction;
  Result.ParamCheck := False;
end;

procedure TMonThread.CommitTrans();
var
  Deb : TDateTime;
begin
  Deb := DoLog('  Début du commit de transaction');
  try
    if FTransaction.InTransaction then
      FTransaction.Commit();
  except
    on e : exception do
    begin
      DoLog('    Exception dans "CommitTrans" : ' + e.Message);
      Raise;
    end;
  end;
  DoLog('  Fin du commit de transaction (Duree : ' + GetStrDuree(Deb) + ')');
end;

procedure TMonThread.RollBackTrans();
var
  Deb : TDateTime;
begin
  Deb := DoLog('  Début du rollback de transaction');
  try
    if FTransaction.InTransaction then
      FTransaction.Rollback();
  except
    on e : exception do
    begin
      DoLog('    Exception dans "RollBackTrans" : ' + e.Message);
      Raise;
    end;
  end;
  DoLog('  Fin du rollback de transaction (Duree : ' + GetStrDuree(Deb) + ')');
end;

procedure TMonThread.FinaliseDB();
var
  Deb : TDateTime;
begin
  Deb := DoLog(  'Début FinaliseDB');
  try
    if FTransaction.InTransaction then
      FTransaction.Rollback();
    FreeAndNil(FTransaction);
    FreeAndNil(FConnexion);
    FInitialized := False;
  except
    on e : Exception do
      DoLog('    Exception dans "FinaliseDB" : ' + e.Message);
  end;
  DoLog('  Fin FinaliseDB (Duree : ' + GetStrDuree(Deb) + ')');
end;

// gestion de log

procedure TMonThread.InitLog(Prefix : string);
var
  Fichier : TextFile;
begin
  FLogFile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)) + 'Log') + Prefix + FormatDateTime('yyyymmdd-hhnnss-zzz', Now()) + '.log';
  ForceDirectories(ExtractFilePath(FLogFile));
  try
    try
      AssignFile(Fichier, FLogFile);
      Rewrite(Fichier);
      Writeln(Fichier, 'Initialisation du log');
    finally
      CloseFile(Fichier);
    end;
  except
    // que faire...
  end;
end;

function TMonThread.DoLog(txt : string) : TDateTime;
var
  Fichier : TextFile;
begin
  Result := Now();
  try
    try
      AssignFile(Fichier, FLogFile);
      Append(Fichier);
      Writeln(Fichier, FormatDateTime('hh:nn:ss.zzz', Result) + ' - ' + txt);
    finally
      CloseFile(Fichier);
    end;
  except
    // que faire...
  end;
end;

// fonction utilitaire

function TMonThread.GetGUIDBase() : string;
var
  Deb : TDateTime;
  Connexion : TIB_Connection;
  Transaction : TIB_Transaction;
  Query : TIBOQuery;
begin
  Deb := DoLog('  Début GetGUIDBase');
  Result := '';
  try
    try
      Connexion := TIB_Connection.Create(nil);
      Connexion.DatabaseName := AnsiString(FCheminBase);
      Connexion.Username := 'sysdba';
      Connexion.Password := 'masterkey';

      Transaction := TIB_Transaction.Create(nil);
      Transaction.IB_Connection := Connexion;

      Query := TIBOQuery.Create(nil);
      Query.IB_Connection := Connexion;
      Query.IB_Transaction := Transaction;
      Query.ParamCheck := False;

      try
        Transaction.StartTransaction();

        Query.SQL.Text := 'select BAS_GUID from GENBASES where BAS_IDENT = ''0'';';
        Query.Open();
        if not (Query.Eof or Query.FieldByName('BAS_GUID').IsNull) then
        begin
          Result := Query.FieldByName('BAS_GUID').AsString
        end;
        Query.Close();

        Transaction.Commit();
      except
        Transaction.Rollback();
        raise;
      end;
    finally
      FreeAndNil(Query);
      FreeAndNil(Transaction);
      FreeAndNil(Connexion);
    end;
  except
    on e : Exception do
    begin
      DoLog(e.Message);
      Result := ''
    end;
  end;
  DoLog('  Fin GetGUIDBase (Result = ' + Result + ') (Duree : ' + GetStrDuree(Deb) + ')');
end;

procedure TMonThread.LoadScriptSQL(Nom : string; Query : TIBOQuery);
var
  ScriptStream : TResourceStream;
begin
{$IFDEF DEBUG}
  if FileExists('..\..\scripts\' + Nom + '.sql') then
    Query.SQL.LoadFromFile('..\..\scripts\' + Nom + '.sql')
  else
{$ENDIF}
  begin
    try
      ScriptStream := TResourceStream.Create(HInstance, Nom, RT_RCDATA);
      Query.SQL.LoadFromStream(ScriptStream);
    finally
      FreeAndNil(ScriptStream);
    end;
  end;
end;

function TMonThread.ExecuteScriptSQL(Nom : string) : Boolean;
var
  Deb : TDateTime;
  Query : TIBOQuery;
begin
  Deb := DoLog('    Début ExecuteScriptSQL (script : ' + Nom + ')');
  Result := False;
  try
    try
      Query := GetNewQuery();

      DoLog('      Chargement de la procedure');
      Query.SQL.Clear();
      LoadScriptSQL(Nom, Query);
      Query.ExecSQL();

      DoLog('      Execution de la procedure');
      Query.SQL.Text := 'execute procedure ' + UpperCase(Nom) + ';';
      Query.ExecSQL();

      DoLog('      Drop de la procedure');
      Query.SQL.Text := 'drop procedure ' + UpperCase(Nom) + ';';
      Query.ExecSQL();

      Result := True;
    finally
      FreeAndNil(Query);
    end;
  except
    on e : Exception do
    begin
      DoLog(e.Message);
    end;
  end;
  DoLog('    Fin ExecuteScriptSQL (Result = ' + BoolToStr(Result, true) + ') (Duree : ' + GetStrDuree(Deb) + ')');
end;

// Gestion du GFIX de la base

function TMonThread.DoGFixBegin() : boolean;
var
  Deb : TDateTime;
  Error : string;
begin
  Deb := DoLog('  Début DoGFixBegin');
  Result := false;
  try
    if FileExists(INTERBASE_GFIX_EXE) then
    begin
      DoLog('  -> Passage en asynchrone');
      if (ExecAndWaitProcess(Error, '"' + INTERBASE_GFIX_EXE + '"',
                             INTERBASE_GFIX_PARAM_BASE + ' ' + INTERBASE_GFIX_PARAM_ASYNC + ' ' + '"' + FCheminBase + '"',
                             false, '', true) = 0) then
      begin
        DoLog('  -> Paramètre de sweep et buffer');
        if (ExecAndWaitProcess(Error, '"' + INTERBASE_GFIX_EXE + '"',
                              INTERBASE_GFIX_PARAM_BASE + ' ' + INTERBASE_GFIX_PARAM_SWEEP_VALUE + ' ' + INTERBASE_GFIX_PARAM_BUFFER_BIG + ' ' + '"' + FCheminBase + '"',
                              false, '', true) = 0) then
        begin
          DoLog('  -> Lancement d''un sweep');
          if (ExecAndWaitProcess(Error, '"' + INTERBASE_GFIX_EXE + '"',
                                INTERBASE_GFIX_PARAM_BASE + ' ' + INTERBASE_GFIX_PARAM_SWEEP + ' ' + '"' + FCheminBase + '"',
                                false, '', true) = 0) then
          begin
            Result := true;
          end;
        end;
      end;
      if not (Trim(Error) = '') then
        DoLog('    ' + Error);
    end
    else
    begin
      DoLog('');
      DoLog('  ATTENTION : gfix non trouvé !!!');
      DoLog('');
      Result := true;
    end;
  except
    on e : Exception do
    begin
      DoLog(e.Message);
      Result := False;
    end;
  end;
  DoLog('  Fin DoGFixBegin (Result = ' + BoolToStr(Result, true) + ') (Duree : ' + GetStrDuree(Deb) + ')');
end;

function TMonThread.DoGFixEnd() : boolean;
var
  Deb : TDateTime;
  Error : string;
begin
  Deb := DoLog('  Début DoGFixEnd');
  Result := False;
  try
    if FileExists(INTERBASE_GFIX_EXE) then
    begin
      DoLog('  -> Paramètre de sweep et buffer');
      if(ExecAndWaitProcess(Error, '"' + INTERBASE_GFIX_EXE + '"',
                            INTERBASE_GFIX_PARAM_BASE + ' ' + INTERBASE_GFIX_PARAM_BUFFER_SMALL + ' ' + '"' + FCheminBase + '"',
                            false, '', true) = 0) then
      begin
        Result := true;
      end;
      if not (Trim(Error) = '') then
        DoLog('    ' + Error);
    end
    else
    begin
      DoLog('');
      DoLog('  ATTENTION : gfix non trouvé !!!');
      DoLog('');
      Result := true;
    end;
  except
    on e : Exception do
    begin
      DoLog(e.Message);
      Result := False;
    end;
  end;
  DoLog('  Fin DoGFixEnd (Result = ' + BoolToStr(Result, true) + ') (Duree : ' + GetStrDuree(Deb) + ')');
end;

// backup de la base

function TMonThread.DoSauvegardeBase() : boolean;
var
  Deb : TDateTime;
  BackUpName : string;
begin
  Deb := DoLog('  Début DoSauvegardeBase');
  try
    BackUpName := ChangeFileExt(FCheminBase, '.migre');
    DoLog('  -> lancement du backup');
    if FileExists(BackUpName) then
      DeleteFile(BackUpName);
    Result := CopyFile(PWideChar(FCheminBase), PWideChar(BackUpName), true);
  except
    on e : Exception do
    begin
      DoLog(e.Message);
      Result := False;
    end;
  end;
  DoLog('  Fin DoSauvegardeBase (Result = ' + BoolToStr(Result, true) + ') (Duree : ' + GetStrDuree(Deb) + ')');
end;

function TMonThread.DoDropSauvegarde() : boolean;
var
  Deb : TDateTime;
  BackUpName : string;
begin
  Deb := DoLog('  Début DoDropSauvegarde');
  Result := false;
  try
    DoLog('  -> Suppression du fichier');
    BackUpName := ChangeFileExt(FCheminBase, '.migre');
    if FileExists(BackUpName) then
      DeleteFile(BackUpName);
  except
    on e : Exception do
    begin
      DoLog(e.Message);
      Result := False;
    end;
  end;
  DoLog('  Fin DoDropSauvegarde (Result = ' + BoolToStr(Result, true) + ') (Duree : ' + GetStrDuree(Deb) + ')');
end;

// nettoyage !

function TMonThread.DoNettoyageBase() : boolean;
var
  Deb : TDateTime;
  Connexion : TIB_Connection;
  Transaction : TIB_Transaction;
  Query : TIBOQuery;
  i, nbtry : integer;
begin
  Deb := DoLog('  Début DoNettoyageBase');
  result := false;
  nbtry := 5;

  try
    // suppression du fichier !
    if FileExists(FInterbaseExt + INTERBASE_EXT_ARTRELATIONAXE) then
    begin
      DoLog('    Suppression du fichier ' + INTERBASE_EXT_ARTRELATIONAXE);
      for i := 1 to nbtry do
      begin
        if DeleteFile(FInterbaseExt + INTERBASE_EXT_ARTRELATIONAXE) then
          Break
        else
          DoLog('    Raté... essai suivant (' + IntToStr(i) + ')');
      end;
      if FileExists(FInterbaseExt + INTERBASE_EXT_ARTRELATIONAXE) then
        Exit;
    end;

    if FileExists(FInterbaseExt + INTERBASE_EXT_GENCENTRALE) then
    begin
      DoLog('    Suppression du fichier ' + INTERBASE_EXT_GENCENTRALE);
      for i := 1 to nbtry do
      begin
        if DeleteFile(FInterbaseExt + INTERBASE_EXT_GENCENTRALE) then
          Break
        else
          DoLog('    Raté... essai suivant (' + IntToStr(i) + ')');
      end;
      if FileExists(FInterbaseExt + INTERBASE_EXT_GENCENTRALE) then
        Exit;
    end;

    // Nettoyage SQL
    try
      Connexion := TIB_Connection.Create(nil);
      Connexion.DatabaseName := AnsiString(FCheminBase);
      Connexion.Username := 'sysdba';
      Connexion.Password := 'masterkey';

      Transaction := TIB_Transaction.Create(nil);
      Transaction.IB_Connection := Connexion;

      Query := TIBOQuery.Create(nil);
      Query.IB_Connection := Connexion;
      Query.IB_Transaction := Transaction;
      Query.ParamCheck := False;

      for i := 1 to nbTry do
      begin
        try
          DoLog('    Start de transaction');
          Transaction.StartTransaction();

          DoLog('      Nettoyage de la base');
          DoLog('        Chargement de la procedure');
          Query.SQL.Clear();
          LoadScriptSQL('tmp_nettoyage_base', Query);
          Query.ExecSQL();

          DoLog('        Execution de la procedure');
          Query.SQL.Text := 'execute procedure tmp_nettoyage_base;';
          Query.ExecSQL();

          DoLog('        Drop de la procedure');
          Query.SQL.Text := 'drop procedure tmp_nettoyage_base;';
          Query.ExecSQL();

          DoLog('    Commit de transaction');
          Transaction.Commit();
          Break;
        except
          DoLog('    Raté... essai suivant (' + IntToStr(i) + ')');
          Transaction.Rollback();
          if i >= nbtry then
            raise
          else
            Sleep(500);
        end;
      end;

      Result := True;
    finally
      FreeAndNil(Query);
      FreeAndNil(Transaction);
      FreeAndNil(Connexion);
    end;
  except
    on e : Exception do
    begin
      DoLog(e.Message);
      Result := False;
    end;
  end;

  DoLog('  Fin DoNettoyageBase (Result = ' + BoolToStr(Result, true) + ') (Duree : ' + GetStrDuree(Deb) + ')');
end;

// Traitement

function TMonThread.DoRecalculTrigger() : Boolean;
var
  Deb : TDateTime;
  Connexion : TIB_Connection;
  Transaction : TIB_Transaction;
  Query : TIBOQuery;
  res, count : integer;
begin
  Deb := DoLog('  Début DoRecalculTrigger');
  Result := False;
  try
    try
      Connexion := TIB_Connection.Create(nil);
      Connexion.DatabaseName := AnsiString(FCheminBase);
      Connexion.Username := 'sysdba';
      Connexion.Password := 'masterkey';

      Transaction := TIB_Transaction.Create(nil);
      Transaction.IB_Connection := Connexion;

      Query := TIBOQuery.Create(nil);
      Query.IB_Connection := Connexion;
      Query.IB_Transaction := Transaction;
      Query.ParamCheck := False;

      try
        DoLog('    Start de transaction');
        Transaction.StartTransaction();

        if CompareVersion(GetVersion(FCheminBase), VERSION_BASE_SRC) = EqualsValue then
        begin
          // =====> Recalcul 11.3

          // boucle de traitement
          res := 1;
          count := 1;
          while res > 0 do
          begin
            DoLog('      Recalcul passe ' + IntToStr(count));
            Query.SQL.Text := 'select retour from bn_triggerdiffere;';
            try
              Query.Open();
              if Query.Eof then
                Raise Exception.Create('Pas de retour de "bn_triggerdiffere"')
              else
                res := Query.FieldByName('retour').AsInteger;
            finally
              Query.Close();
            end;
            Inc(count);
          end;
        end
        else
        begin
          // =====> Recalcul 13.XX

          // pre-traitement
          DoLog('      Prétraitement');
          QUery.SQL.Text := 'execute procedure eai_trigger_pretraite;';
          Query.ExecSQL();

          // boucle de traitement
          res := 1;
          count := 1;
          while res > 0 do
          begin
            DoLog('      Recalcul passe ' + IntToStr(count));
            Query.SQL.Text := 'select retour from eai_trigger_differe(1000);';
            try
              Query.Open();
              if Query.Eof then
                Raise Exception.Create('Pas de retour de "eai_trigger_differe"')
              else
                res := Query.FieldByName('retour').AsInteger;
            finally
              Query.Close();
            end;
            Inc(count);
          end;
        end;

        DoLog('    Commit de transaction');
        Transaction.Commit();
      except
        Transaction.Rollback();
        raise;
      end;

      Result := True;
    finally
      FreeAndNil(Query);
      FreeAndNil(Transaction);
      FreeAndNil(Connexion);
    end;
  except
    on e : Exception do
    begin
      DoLog(e.Message);
      Result := False;
    end;
  end;
  DoLog('  Fin DoRecalculTrigger (Result = ' + BoolToStr(Result, true) + ') (Duree : ' + GetStrDuree(Deb) + ')');
end;

function TMonThread.DoScript() : Boolean;
var
  Deb : TDateTime;
  Error, Version : string;
begin
  Deb := DoLog('  Début DoScript');
  try
    Result := (ExecAndWaitProcess(Error, '"' + FCheminScript + '"', 'UNEBASE "' + FCheminBase + '"', true, '', true) = 0);
    if not (Trim(Error) = '') then
      DoLog('    ' + Error);
    if Result then
    begin
      Version := GetVersion(FCheminBase);
      Result := CompareVersion(Version, VERSION_BASE_DEST) in [EqualsValue, GreaterThanValue];
      if not Result then
        DoLog('  -> ERREUR version obtenue : ' + Version);
    end;
  except
    on e : Exception do
    begin
      DoLog(e.Message);
      Result := False;
    end;
  end;
  DoLog('  Fin DoScript (Result = ' + BoolToStr(Result, true) + ') (Duree : ' + GetStrDuree(Deb) + ')');
end;

function TMonThread.DoGetFromLame2() : Boolean;
var
  Deb : TDateTime;
  IdHttp : TIDHttp;
  Fichier : TFileStream;
  ZipName : string;
  Zip : I7zInArchive;
begin
  Deb := DoLog('  Début GetFromLame2');
  Result := False;
  try
    DoLog('    Téléchargement du fichier');
    // fichiers
    ZipName := IncludeTrailingPathDelimiter(GetTempDirectory()) + FBaseGuid + '.7z';
    if FileExists(ZipName) then
      DeleteFile(ZipName);
    // recup
    if (Copy(FAccesLame, 1, 7) = 'http://') then
    begin
      try
        Fichier := TFileStream.Create(ZipName, fmCreate or fmOpenWrite);
        try
          IdHttp := TIDHttp.Create(nil);
          case FWhereBase of
            wb_Site :
              IdHttp.Get(FAccesLame + REPERTOIRE_LAME + '/' + FBaseGuid + '.7z', Fichier);
            wb_Platform :
              IdHttp.Get(FAccesLame, Fichier);
            else
              Raise Exception.Create('Base de lame ?????');
          end;
        finally
          FreeAndNil(IdHttp);
        end;
      finally
        FreeAndNIl(Fichier);
      end;
    end
    else
    begin
      case FWhereBase of
        wb_Site :
          if not CopyFile(Pchar(IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(FAccesLame) + REPERTOIRE_LAME) + FBaseGuid + '.7z'), PChar(ZipName), true) then
            Raise Exception.Create('Erreur de copie de fichier (de : "' + IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(FAccesLame) + REPERTOIRE_LAME) + FBaseGuid + '.7z"  vers "' + ZipName + '".');
        wb_Platform :
          if not CopyFile(Pchar(FAccesLame), PChar(ZipName), true) then
            Raise Exception.Create('Erreur de copie de fichier (de : "' + IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(FAccesLame) + REPERTOIRE_LAME) + FBaseGuid + '.7z"  vers "' + ZipName + '".');
        else
          Raise Exception.Create('Base de lame ?????');
      end;
    end;

    DoLog('    Traitement du fichier');
    if FileExists(ZipName) then
    begin
      if FileExists(FInterbaseExt + INTERBASE_EXT_ARTRELATIONAXE) then
        DeleteFile(FInterbaseExt + INTERBASE_EXT_ARTRELATIONAXE);
      if FileExists(FInterbaseExt + INTERBASE_EXT_GENCENTRALE) then
        DeleteFile(FInterbaseExt + INTERBASE_EXT_GENCENTRALE);
      try
        DoLog('    Décompression du fichier');
        Zip := CreateInArchive(CLSID_CFormat7z);
        Zip.OpenFile(ZipName);
        Zip.ExtractTo(FInterbaseExt);
      finally
        Zip := nil;
      end;
      DoLog('    Suppression du fichier');
      DeleteFile(ZipName);
      Result := True;
    end
    else
      DoLog('    Fichier introuvable : ' + ZipName);
  except
    on e : Exception do
    begin
      DoLog(e.Message);
      Result := False;
    end;
  end;
  DoLog('  Fin GetFromLame2 (Result = ' + BoolToStr(Result, True) + ') (Duree : ' + GetStrDuree(Deb) + ')');
end;

function TMonThread.DoCreateTableExterne() : Boolean;
var
  Deb : TDateTime;
  Connexion : TIB_Connection;
  Transaction : TIB_Transaction;
  Query : TIBOQuery;
begin
  Deb := DoLog('  Début CreateTableExterne');
  Result := False;
  try
    try
      Connexion := TIB_Connection.Create(nil);
      Connexion.DatabaseName := AnsiString(FCheminBase);
      Connexion.Username := 'sysdba';
      Connexion.Password := 'masterkey';

      Transaction := TIB_Transaction.Create(nil);
      Transaction.IB_Connection := Connexion;

      Query := TIBOQuery.Create(nil);
      Query.IB_Connection := Connexion;
      Query.IB_Transaction := Transaction;
      Query.ParamCheck := False;

      try
        DoLog('    Start de transaction');
        Transaction.StartTransaction();

        DoLog('      Creation de la table externe de relation article/axe');
        Query.SQL.Clear();
        LoadScriptSQL('tmp_export_artrelationaxe', Query);
        Query.ExecSQL();

        DoLog('      Creation de la table externe des centrales');
        Query.SQL.Clear();
        LoadScriptSQL('tmp_export_gencentrale', Query);
        Query.ExecSQL();

        DoLog('    Commit de transaction');
        Transaction.Commit();
      except
        Transaction.Rollback();
        raise;
      end;

      Result := True;
    finally
      FreeAndNil(Query);
      FreeAndNil(Transaction);
      FreeAndNil(Connexion);
    end;
  except
    on e : Exception do
    begin
      DoLog(e.Message);
      Result := False;
    end;
  end;
  DoLog('  Fin CreateTableExterne (Result = ' + BoolToStr(Result, true) + ') (Duree : ' + GetStrDuree(Deb) + ')');
end;

function TMonThread.DoPreCorrection() : Boolean;
var
  Deb : TDateTime;
begin
  Deb := DoLog('  Début DoPreCorrection');
  Result := ExecuteScriptSQL('tmp_pre_correction');
  DoLog('  Fin DoPreCorrection (Result = ' + BoolToStr(Result, true) + ') (Duree : ' + GetStrDuree(Deb) + ')');
end;

function TMonThread.DoInitNomenclature() : Boolean;
var
  Deb : TDateTime;
begin
  Deb := DoLog('  Début DoInitNomenclature');
  Result := ExecuteScriptSQL('tmp_init_nomenclature');
  DoLog('  Fin DoInitNomenclature (Result = ' + BoolToStr(Result, true) + ') (Duree : ' + GetStrDuree(Deb) + ')');
end;

function TMonThread.DoInitTailleGrille() : Boolean;
var
  Deb : TDateTime;
  Query : TIBOQuery;
begin
  Deb := DoLog('  Début DoInitTailleGrille');
  Result := False;
  try
    try
      Query := GetNewQuery();

      DoLog('    Mise-à-jour de PLXGTF');
      Query.SQL.Text := 'update PLXGTF set GTF_ACTIVE = 1 where GTF_ID != 0;';
      Query.ExecSQL();

      DoLog('    Mise-à-jour de PLXTAILLESGF');
      Query.SQL.Text := 'update PLXTAILLESGF set TGF_ACTIVE = 1 where TGF_ID != 0;';
      Query.ExecSQL();

      Result := True;
    finally
      FreeAndNil(Query);
    end;
  except
    on e : Exception do
    begin
      DoLog(e.Message);
    end;
  end;
  DoLog('  Fin DoInitTailleGrille (Result = ' + BoolToStr(Result, true) + ') (Duree : ' + GetStrDuree(Deb) + ')');
end;

function TMonThread.DoInitAgrHistoStock() : Boolean;
var
  Deb : TDateTime;
  Query : TIBOQuery;
  nomProcPump, nomProcRecal : string;
  FicEtatStock: TFileName;
begin
  Deb := DoLog('  Début DoInitAgrHistoStock');
  Result := False;

  nomProcPump := 'tmp_pumpadate_113';
  nomProcRecal := 'tmp_init_agrhistostock';

  try
    try
      Query := GetNewQuery();

      {$REGION 'Sauvegarde de l’état des stocks'}
      if FWhereBase = wb_Site then
      begin
        try
          DoLog('    Sauvegarde de l''état des stocks');
          Query.SQL.Clear();
          Query.SQL.Add('SELECT MAG_ID, MAG_ENSEIGNE, ART_ID, ARF_CHRONO, ART_REFMRK, ART_NOM, COU_ID,');
          Query.SQL.Add('       COU_NOM, TGF_ID, TGF_NOM, SUM(STC_QTE) STC_QTE,');
          Query.SQL.Add('       SUM(STC_QTE * PPC_PUMP) STC_VALEUR');
          Query.SQL.Add('FROM AGRSTOCKCOUR');
          Query.SQL.Add('  JOIN AGRPUMPCOUR   ON (PPC_ARTID = STC_ARTID AND PPC_TGFID = STC_TGFID)');
          Query.SQL.Add('  JOIN GENMAGASIN    ON (MAG_ID = STC_MAGID)');
          Query.SQL.Add('  JOIN K KMAG        ON (KMAG.K_ID = MAG_ID AND KMAG.K_ENABLED = 1 AND MAG_ID != 0)');
          Query.SQL.Add('  JOIN ARTARTICLE    ON (ART_ID = STC_ARTID)');
          Query.SQL.Add('  JOIN K KART        ON (KART.K_ID = ART_ID AND KART.K_ENABLED = 1 AND ART_ID != 0)');
          Query.SQL.Add('  JOIN ARTREFERENCE  ON (ARF_ARTID = ART_ID)');
          Query.SQL.Add('  JOIN PLXTAILLESGF  ON (TGF_ID = STC_TGFID)');
          Query.SQL.Add('  JOIN K KTGF        ON (KTGF.K_ID = TGF_ID AND KTGF.K_ENABLED = 1)');
          Query.SQL.Add('  JOIN PLXCOULEUR    ON (COU_ID = STC_COUID)');
          Query.SQL.Add('  JOIN K KCOU        ON (KCOU.K_ID = COU_ID AND KCOU.K_ENABLED = 1)');
          Query.SQL.Add('GROUP BY MAG_ID, MAG_ENSEIGNE, ART_ID, ARF_CHRONO, ART_REFMRK, ART_NOM, COU_ID, COU_NOM, TGF_ID, TGF_NOM');
          Query.SQL.Add('ORDER BY MAG_ID, ART_ID, TGF_ID, COU_ID;');

          FicEtatStock := Format('%s\Exports\Etat_stock_migration_%s.csv',
            [ExcludeTrailingPathDelimiter(ExtractFilePath(FCheminScript)),
              FormatDateTime('yyyymmdd', Today())]);
          Query.Open();
          ExportDataSetToDSV(Query, FicEtatStock, ['MAG_ID', 'ART_ID', 'TGF_ID', 'COU_ID']);
        except
          DoLog('    -> Erreur lors de la sauvegarde des stocks');
          raise;
        end;
      end;
      {$ENDREGION 'Sauvegarde de l’état des stocks'}

      if FDesIndex then
      begin
        DoLog('    Désactivation des indexes');
        try
          Query.SQL.Text := 'alter index INX_HSTSTAT inactive;';
          Query.ExecSQL();
        except
          DoLog('    -> INX_HSTSTAT non desactivé');
        end;
        try
          Query.SQL.Text := 'alter index INX_AGRSTAT2 inactive;';
          Query.ExecSQL();
        except
          DoLog('    -> INX_AGRSTAT2 non desactivé');
        end;
        try
          Query.SQL.Text := 'alter index AGRHISTOSTOCK_IDX1 inactive;';
          Query.ExecSQL();
        except
          DoLog('    -> AGRHISTOSTOCK_IDX1 non desactivé');
        end;
      end;

      DoLog('    Création de la procedure de pump');
      Query.SQL.Clear();
      LoadScriptSQL(nomProcPump, Query);
      Query.ExecSQL();

      DoLog('    Creation de la procedure de recupération');
      Query.SQL.Clear();
      LoadScriptSQL(nomProcRecal, Query);
      Query.ExecSQL();

      DoLog('    Execution de la procedure de recupération');
      Query.SQL.Text := 'execute procedure ' + UpperCase(nomProcRecal) + ';';
      Query.ExecSQL();

      DoLog('    Drop de la procedure de recupération');
      Query.SQL.Text := 'drop procedure ' + UpperCase(nomProcRecal) + ';';
      Query.ExecSQL();

      DoLog('    Drop de la procedure de pump');
      Query.SQL.Text := 'drop procedure ' + UpperCase(nomProcPump) + ';';
      Query.ExecSQL();
      Result := True;

      if FDesIndex then
      begin
        DoLog('    Ré-activation des indexes');
        Query.SQL.Text := 'alter index INX_HSTSTAT active;';
        Query.ExecSQL();
        Query.SQL.Text := 'alter index INX_AGRSTAT2 active;';
        Query.ExecSQL();
        Query.SQL.Text := 'alter index AGRHISTOSTOCK_IDX1 active;';
        Query.ExecSQL();
      end;
    finally
      FreeAndNil(Query);
    end;
  except
    on e : Exception do
    begin
      DoLog(e.Message);
    end;
  end;
  DoLog('  Fin DoInitAgrHistoStock (Result = ' + BoolToStr(Result, true) + ') (Duree : ' + GetStrDuree(Deb) + ')');
end;

function TMonThread.DoInitAgrStockCour() : Boolean;
var
  Deb : TDateTime;
begin
  Deb := DoLog('  Début DoInitAgrStockCour');
  Result := ExecuteScriptSQL('tmp_init_agrstockcour');
  DoLog('  Fin DoInitAgrStockCour (Result = ' + BoolToStr(Result, true) + ') (Duree : ' + GetStrDuree(Deb) + ')');
end;

function TMonThread.DoInitAgrMouvement() : Boolean;
var
  Deb : TDateTime;
  Query : TIBOQuery;
begin
  Deb := DoLog('  Début DoInitAgrMouvement');
  try
    try
      Query := GetNewQuery();

      if FDesIndex then
      begin
        DoLog('    Désactivation des indexes');
        try
          Query.SQL.Text := 'alter index IDX_AGRMVT_ARTICLE inactive;';
          Query.ExecSQL();
        except
          DoLog('    -> IDX_AGRMVT_ARTICLE non desactivé');
        end;
        try
          Query.SQL.Text := 'alter index IDX_AGRMVT_MVTID inactive;';
          Query.ExecSQL();
        except
          DoLog('    -> IDX_AGRMVT_MVTID non desactivé');
        end;
        try
          Query.SQL.Text := 'alter index IDX_AGRMVT_MVTLIG inactive;';
          Query.ExecSQL();
        except
          DoLog('    -> IDX_AGRMVT_MVTLIG non desactivé');
        end;
        try
          Query.SQL.Text := 'alter index AGRMOUVEMENT_IDX1 inactive;';
          Query.ExecSQL();
        except
          DoLog('    -> AGRMOUVEMENT_IDX1 non desactivé');
        end;
        try
          Query.SQL.Text := 'alter index AGRMOUVEMENT_IDX3 inactive;';
          Query.ExecSQL();
        except
          DoLog('    -> AGRMOUVEMENT_IDX3 non desactivé');
        end;
      end;

      Result := ExecuteScriptSQL('tmp_init_agrmouvement');

      if FDesIndex then
      begin
        DoLog('    Ré-activation des indexes');
        Query.SQL.Text := 'alter index IDX_AGRMVT_ARTICLE active;';
        Query.ExecSQL();
        Query.SQL.Text := 'alter index IDX_AGRMVT_MVTID active;';
        Query.ExecSQL();
        Query.SQL.Text := 'alter index IDX_AGRMVT_MVTLIG active;';
        Query.ExecSQL();
        Query.SQL.Text := 'alter index AGRMOUVEMENT_IDX1 active;';
        Query.ExecSQL();
        Query.SQL.Text := 'alter index AGRMOUVEMENT_IDX3 active;';
        Query.ExecSQL();
      end;
    finally
      FreeAndNil(Query);
    end;
  except
    on e : Exception do
    begin
      DoLog(e.Message);
      Result := False;
    end;
  end;
  DoLog('  Fin DoInitAgrMouvement (Result = ' + BoolToStr(Result, true) + ') (Duree : ' + GetStrDuree(Deb) + ')');
end;

function TMonThread.DoInitAgrFouStat() : Boolean;
var
  Deb : TDateTime;
begin
  Deb := DoLog('  Début DoInitAgrFouStat');
  Result := ExecuteScriptSQL('tmp_init_agrfoustat');
  DoLog('  Fin DoInitAgrFouStat (Result = ' + BoolToStr(Result, true) + ') (Duree : ' + GetStrDuree(Deb) + ')');
end;

function TMonThread.DoInitArtRelationAxe() : Boolean;
var
  Deb : TDateTime;
begin
  Deb := DoLog('  Début DoInitArtRelationAxe');
  if FWhereBase = wb_Lame then
  begin
    Result := DoCreateArtRelationAxe() and
              DoExportArtRelationAxe();
  end
  else
  begin
    Result := DoImportArtRelationAxe() and
              DoComplementArtRelationAxe();
  end;
  DoLog('  Fin DoInitArtRelationAxe (Result = ' + BoolToStr(Result, true) + ') (Duree : ' + GetStrDuree(Deb) + ')');
end;

function TMonThread.DoCreateArtRelationAxe() : Boolean;
var
  Deb : TDateTime;
begin
  Deb := DoLog('    Début CreateArtRelationAxe');
  Result := ExecuteScriptSQL('tmp_artrelationaxe_creation');
  DoLog('    Fin CreateArtRelationAxe (Result = ' + BoolToStr(Result, true) + ') (Duree : ' + GetStrDuree(Deb) + ')');
end;

function TMonThread.DoExportArtRelationAxe() : Boolean;
var
  Deb : TDateTime;
begin
  Deb := DoLog('    Début ExportArtRelationAxe');
  Result := ExecuteScriptSQL('tmp_artrelationaxe_export');
  DoLog('    Fin ExportArtRelationAxe (Result = ' + BoolToStr(Result, true) + ') (Duree : ' + GetStrDuree(Deb) + ')');
end;

function TMonThread.DoImportArtRelationAxe() : Boolean;
var
  Deb : TDateTime;
begin
  Deb := DoLog('    Début ImportArtRelationAxe');
  Result := ExecuteScriptSQL('tmp_artrelationaxe_import');
  DoLog('    Fin ImportArtRelationAxe (Result = ' + BoolToStr(Result, True) + ') (Duree : ' + GetStrDuree(Deb) + ')');
end;

function TMonThread.DoComplementArtRelationAxe() : Boolean;
var
  Deb : TDateTime;
begin
  Deb := DoLog('    Début ComplementArtRelationAxe');
  Result := ExecuteScriptSQL('tmp_artrelationaxe_complement');
  DoLog('    Fin ComplementArtRelationAxe (Result = ' + BoolToStr(Result, True) + ') (Duree : ' + GetStrDuree(Deb) + ')');
end;

function TMonThread.DoInitGenCentrale() : Boolean;
var
  Deb : TDateTime;
begin
  Deb := DoLog('  Début DoInitGenCentrale');
  if FWhereBase = wb_Lame then
  begin
    Result := DoExportGenCentrale();
  end
  else
  begin
    Result := DoImportGenCentrale();
  end;
  DoLog('  Fin DoInitGenCentrale (Result = ' + BoolToStr(Result, true) + ') (Duree : ' + GetStrDuree(Deb) + ')');
end;

function TMonThread.DoExportGenCentrale() : Boolean;
var
  Deb : TDateTime;
begin
  Deb := DoLog('    Début DoExportGenCentrale');
  Result := ExecuteScriptSQL('tmp_gencentrale_export');
  DoLog('    Fin DoExportGenCentrale (Result = ' + BoolToStr(Result, true) + ') (Duree : ' + GetStrDuree(Deb) + ')');
end;

function TMonThread.DoImportGenCentrale() : Boolean;
var
  Deb : TDateTime;
begin
  Deb := DoLog('    Début DoImportGenCentrale');
  Result := ExecuteScriptSQL('tmp_gencentrale_import');
  DoLog('    Fin DoImportGenCentrale (Result = ' + BoolToStr(Result, true) + ') (Duree : ' + GetStrDuree(Deb) + ')');
end;

function TMonThread.DoInitFedasSP2K() : Boolean;
var
  Deb : TDateTime;
begin
  Deb := DoLog('  Début InitFedasSP2K');
  Result := ExecuteScriptSQL('tmp_fedassp2k_migration');
  DoLog('  Fin InitFedasSP2K (Result = ' + BoolToStr(Result, true) + ') (Duree : ' + GetStrDuree(Deb) + ')');
end;

function TMonThread.DoInitParamJeton() : boolean;
var
  Deb : TDateTime;
begin
  Deb := DoLog('  Début DoInitParamJeton');
  Result := ExecuteScriptSQL('tmp_init_paramjeton');
  DoLog('  Fin DoInitParamJeton (Result = ' + BoolToStr(Result, true) + ') (Duree : ' + GetStrDuree(Deb) + ')');
end;

function TMonThread.DoPostCorrection() : Boolean;
var
  Deb : TDateTime;
begin
  Deb := DoLog('  Début DoPostCorrection');
  Result := ExecuteScriptSQL('tmp_post_correction');
  DoLog('  Fin DoPostCorrection (Result = ' + BoolToStr(Result, true) + ') (Duree : ' + GetStrDuree(Deb) + ')');
end;

function TMonThread.DoDropTableExterne() : boolean;
var
  Deb : TDateTime;
  Connexion : TIB_Connection;
  Transaction : TIB_Transaction;
  Query : TIBOQuery;
  i, nbtry : integer;
begin
  Deb := DoLog('  Début DropTableExterne');
  Result := False;
  nbtry := 5;
  try
    try
      Connexion := TIB_Connection.Create(nil);
      Connexion.DatabaseName := AnsiString(FCheminBase);
      Connexion.Username := 'sysdba';
      Connexion.Password := 'masterkey';

      Transaction := TIB_Transaction.Create(nil);
      Transaction.IB_Connection := Connexion;

      Query := TIBOQuery.Create(nil);
      Query.IB_Connection := Connexion;
      Query.IB_Transaction := Transaction;
      Query.ParamCheck := False;

      for i := 1 to nbTry do
      begin
        try
          DoLog('    Start de transaction');
          Transaction.StartTransaction();

          DoLog('      Drop de la table EXPORT_ARTRELATIONAXE');
          Query.SQL.Text := 'drop table EXPORT_ARTRELATIONAXE;';
          Query.ExecSQL();

          DoLog('      Drop de la table EXPORT_GENCENTRALE');
          Query.SQL.Text := 'drop table EXPORT_GENCENTRALE;';
          Query.ExecSQL();

          DoLog('    Commit de transaction');
          Transaction.Commit();
          Break;
        except
          DoLog('    Raté... essai suivant (' + IntToStr(i) + ')');
          Transaction.Rollback();
          if i >= nbtry then
            raise
          else
            Sleep(500);
        end;
      end;

      Result := True;
    finally
      FreeAndNil(Query);
      FreeAndNil(Transaction);
      FreeAndNil(Connexion);
    end;
  except
    on e : Exception do
    begin
      DoLog(e.Message);
      Result := False;
    end;
  end;
  DoLog('  Fin DropTableExterne (Result = ' + BoolToStr(Result, true) + ') (Duree : ' + GetStrDuree(Deb) + ')');
end;

function TMonThread.DoPutOnLame2() : Boolean;
var
  Deb : TDateTime;
  ZipName, ZipPath, DistPath : string;
  Zip : I7zOutArchive;
begin
  Deb := DoLog('  Début DoPutOnLame2');
  Result := False;
  try
    if FileExists(FInterbaseExt + INTERBASE_EXT_ARTRELATIONAXE) and
       FileExists(FInterbaseExt + INTERBASE_EXT_GENCENTRALE) then
    begin
      // init
      ZipName := FBaseGuid + '.7z';
      ZipPath := IncludeTrailingPathDelimiter(ExtractFilePath(FCheminBase));
      DistPath := IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(FAccesLame) + REPERTOIRE_LAME);
      ForceDirectories(DistPath);

      // creation du zip
      DoLog('    Compression du fichier');
      if FileExists(ZipPath + ZipName) then
        DeleteFile(ZipPath + ZipName);
      try
        Zip := CreateOutArchive(CLSID_CFormat7z);
        Zip.AddFiles(FInterbaseExt, '', INTERBASE_EXT_ARTRELATIONAXE, false);
        Zip.AddFiles(FInterbaseExt, '', INTERBASE_EXT_GENCENTRALE, false);
        Zip.SaveToFile(ZipPath + ZipName);
      finally
        Zip := nil;
      end;

      // copie sur la lame 2 !
      DoLog('    Copy du zip');
      if FileExists(DistPath + ZipName) then
        DeleteFile(DistPath + ZipName);
      if CopyFile(PWideChar(ZipPath + ZipName), PWideChar(DistPath + ZipName), true) then
      begin
        DeleteFile(ZipPath + ZipName);
        Result := True;
      end;
    end;
  except
    on e : Exception do
    begin
      DoLog(e.Message);
      Result := False;
    end;
  end;
  DoLog('  Fin DoPutOnLame2 (Result = ' + BoolToStr(Result, True) + ') (Duree : ' + GetStrDuree(Deb) + ')');
end;

function TMonThread.DoCopyOnLame2() : Boolean;
var
  Deb : TDateTime;
  NewName : string;
begin
  Deb := DoLog('  Début DoCopyOnLame2');
  Result := False;
  try
    if FileExists(FAccesLame) then
    begin
      DoLog('    Copie du fichier (directement sur le partage)');
      NewName := ExtractFilePath(FAccesLame) + FBaseGuid + '.7z';
      if FileExists(NewName) then
        DeleteFile(NewName);
      if not CopyFile(PChar(FAccesLame), PChar(NewName), true) then
        Raise Exception.Create(SysErrorMessage(GetLastError()));
      Result := True;
    end;
  except
    on e : Exception do
    begin
      DoLog(e.Message);
      Result := False;
    end;
  end;
  DoLog('  Fin DoCopyOnLame2 (Result = ' + BoolToStr(Result, True) + ') (Duree : ' + GetStrDuree(Deb) + ')');
end;

function TMonThread.DoSupprTableExterne() : Boolean;
var
  Deb : TDateTime;
  i, nbtry : integer;
begin
  Deb := DoLog('  Début DoSupprTableExterne');
  Result := False;
  nbtry := 5;
  try
    DoLog('    Suppression du fichier ' + INTERBASE_EXT_ARTRELATIONAXE);
    for i := 1 to nbtry do
    begin
      Result := DeleteFile(FInterbaseExt + INTERBASE_EXT_ARTRELATIONAXE);
      if Result then
        Break
      else
        DoLog('    Raté... essai suivant (' + IntToStr(i) + ')');
    end;
    if not Result then
      raise Exception.Create('Suppression du fichier "' + FInterbaseExt + INTERBASE_EXT_ARTRELATIONAXE + '" impossible');

    DoLog('    Suppression du fichier ' + INTERBASE_EXT_GENCENTRALE);
    for i := 1 to nbtry do
    begin
      Result := DeleteFile(FInterbaseExt + INTERBASE_EXT_GENCENTRALE);
      if Result then
        Break
      else
        DoLog('    Raté... essai suivant (' + IntToStr(i) + ')');
    end;
    if not Result then
      raise Exception.Create('Suppression du fichier "' + FInterbaseExt + INTERBASE_EXT_GENCENTRALE + '" impossible');
  except
    on e : Exception do
      DoLog(e.Message);
  end;
  DoLog('  Fin DoSupprTableExterne (Result = ' + BoolToStr(Result, True) + ') (Duree : ' + GetStrDuree(Deb) + ')');
end;

function TMonThread.DoSupprOldTables() : Boolean;
var
  Deb : TDateTime;
  Connexion : TIB_Connection;
  Transaction : TIB_Transaction;
  Query : TIBOQuery;
begin
  Deb := DoLog('  Début DoSupprOldTables');
  Result := False;
  try
    try
      Connexion := TIB_Connection.Create(nil);
      Connexion.DatabaseName := AnsiString(FCheminBase);
      Connexion.Username := 'sysdba';
      Connexion.Password := 'masterkey';

      Transaction := TIB_Transaction.Create(nil);
      Transaction.IB_Connection := Connexion;

      Query := TIBOQuery.Create(nil);
      Query.IB_Connection := Connexion;
      Query.IB_Transaction := Transaction;
      Query.ParamCheck := False;

      try
        DoLog('    Start de transaction');
        Transaction.StartTransaction();

        DoLog('      Suppression de AGRPUMPCOUR');
        Query.SQL.Text := 'drop table AGRPUMPCOUR;';
        Query.ExecSQL();

        DoLog('      Suppression de AGRHISTOPUMP');
        Query.SQL.Text := 'drop table AGRHISTOPUMP;';
        Query.ExecSQL();

        DoLog('    Commit de transaction');
        Transaction.Commit();
      except
        Transaction.Rollback();
        raise;
      end;

      Result := True;
    finally
      FreeAndNil(Query);
      FreeAndNil(Transaction);
      FreeAndNil(Connexion);
    end;
  except
    on e : Exception do
    begin
      DoLog(e.Message);
      Result := False;
    end;
  end;
  DoLog('  Fin DoSupprOldTables (Result = ' + BoolToStr(Result, true) + ') (Duree : ' + GetStrDuree(Deb) + ')');
end;

function TMonThread.DoBackup(var Verif : TBackupVerif) : boolean;

  function GetVerifBackup(Verif : TBackupVerif) : boolean;
  var
    Connexion : TIB_Connection;
    Transaction : TIB_Transaction;
    QueryList, QueryCount : TIBOQuery;
  begin
    Result := False;
    try
      try
        Connexion := TIB_Connection.Create(nil);
        Connexion.DatabaseName := AnsiString(FCheminBase);
        Connexion.Username := 'sysdba';
        Connexion.Password := 'masterkey';

        Transaction := TIB_Transaction.Create(nil);
        Transaction.IB_Connection := Connexion;

        QueryList := TIBOQuery.Create(nil);
        QueryList.IB_Connection := Connexion;
        QueryList.IB_Transaction := Transaction;
        QueryList.ParamCheck := False;

        QueryCount := TIBOQuery.Create(nil);
        QueryCount.IB_Connection := Connexion;
        QueryCount.IB_Transaction := Transaction;
        QueryCount.ParamCheck := False;

        try
          DoLog('    Start de transaction');
          Transaction.StartTransaction();

          DoLog('    Comptages...');
          QueryList.SQL.Text := 'select rdb$relation_name as name '
                              + 'from rdb$relations '
                              + 'where (rdb$system_flag = 0) or (rdb$relation_name in (''RDB$INDICES'', ''RDB$GENERATORS'', ''RDB$TRIGGERS'', ''RDB$PROCEDURES'')) '
                              + 'order by rdb$relation_name;';
          try
            QueryList.Open();
            while not QueryList.Eof do
            begin
              QueryCount.SQL.Text := 'select count(*) as nombre from ' + QueryList.FieldByName('name').AsString + ';';
              try
                QueryCount.Open();
                if not QueryCount.Eof then
                  Verif.Add(QueryList.FieldByName('name').AsString, QueryCount.FieldByName('nombre').AsInteger)
                else
                  Verif.Add(QueryList.FieldByName('name').AsString, 0);
              finally
                QueryCount.Close();
              end;
              QueryList.Next();
            end;
          finally
            QueryList.Close();
          end;

          Result := true;

          DoLog('    Commit de transaction');
          Transaction.Commit();
        except
          Transaction.Rollback();
          raise;
        end;

        Result := True;
      finally
        FreeAndNil(QueryList);
        FreeAndNil(QueryCount);
        FreeAndNil(Transaction);
        FreeAndNil(Connexion);
      end;
    except
      on e : Exception do
      begin
        DoLog(e.Message);
        Result := False;
      end;
    end;
  end;

var
  Deb : TDateTime;
  ibBackup: TIBBackupService;
  sLigne: string;
begin
  Deb := DoLog('  Début DoBackup');
  Result := false;

  if not Assigned(Verif) then
    Verif := TBackupVerif.Create()
  else
    Verif.Clear();
  if not GetVerifBackup(Verif) then
    Exit;

  try
    try
      ibBackup := TIBBackupService.Create(nil);
      ibBackup.Params.Add('user_name=sysdba');
      ibBackup.Params.Add('password=masterkey');
      ibBackup.BackupFile.Add(ChangeFileExt(FCheminBase, '.gbk'));
      ibBackup.DatabaseName := FCheminBase;
      ibBackup.LoginPrompt := False;
      ibBackup.Verbose := True;
      ibBackup.Active := True;

      DoLog('    lancement du backup');

      ibBackup.ServiceStart();
      Result := true;

      while not ibBackup.Eof do
      begin
        sLigne := ibBackup.GetNextLine();
        if Pos('GBAK: ERROR', sLigne) > 0 then
        begin
          DoLog('      Erreur du backup : "' + sLigne + '"');
          Result := false;
        end;
      end;

      DoLog('    Suppression du fichier');
      if result then
        MoveFile(PWideChar(FCheminBase), PWideChar(ChangeFileExt(FCheminBase, '.old')));
    finally
      ibBackup.Active := False;
      FreeAndNil(ibBackup);
    end;
  except
    on E: exception do
    begin
      DoLog(e.Message);
      Result := False;
    end;
  end;
  DoLog('  Fin DoBackup (Result = ' + BoolToStr(Result, true) + ') (Duree : ' + GetStrDuree(Deb) + ')');
end;

function TMonThread.DoRestore(Verif : TBackupVerif) : boolean;

  function GetVerifBackup(Verif : TBackupVerif) : boolean;
  var
    Connexion : TIB_Connection;
    Transaction : TIB_Transaction;
    QueryList, QueryCount : TIBOQuery;
  begin
    Result := False;
    try
      try
        Connexion := TIB_Connection.Create(nil);
        Connexion.DatabaseName := AnsiString(FCheminBase);
        Connexion.Username := 'sysdba';
        Connexion.Password := 'masterkey';

        Transaction := TIB_Transaction.Create(nil);
        Transaction.IB_Connection := Connexion;

        QueryList := TIBOQuery.Create(nil);
        QueryList.IB_Connection := Connexion;
        QueryList.IB_Transaction := Transaction;
        QueryList.ParamCheck := False;

        QueryCount := TIBOQuery.Create(nil);
        QueryCount.IB_Connection := Connexion;
        QueryCount.IB_Transaction := Transaction;
        QueryCount.ParamCheck := False;

        try
          DoLog('    Start de transaction');
          Transaction.StartTransaction();

          DoLog('    Comptages...');
          QueryList.SQL.Text := 'select rdb$relation_name as name '
                              + 'from rdb$relations '
                              + 'where (rdb$system_flag = 0) or (rdb$relation_name in (''RDB$INDICES'', ''RDB$GENERATORS'', ''RDB$TRIGGERS'', ''RDB$PROCEDURES'')) '
                              + 'order by rdb$relation_name;';
          try
            QueryList.Open();
            if not QueryList.Eof then
            begin
              if not (QueryList.RecordCount = Verif.Count) then
              begin
                DoLog('      Manque des tables (avant : ' + IntToStr(Verif.Count) + ' après : ' + IntToStr(QueryList.RecordCount) + ')');
                Exit;
              end;

              while not QueryList.Eof do
              begin
                QueryCount.SQL.Text := 'select count(*) as nombre from ' + QueryList.FieldByName('name').AsString + ';';
                try
                  QueryCount.Open();
                  if not QueryCount.Eof then
                  begin
                    if not (Verif[QueryList.FieldByName('name').AsString] = QueryCount.FieldByName('nombre').AsInteger) then
                    begin
                      DoLog('      Manque des enregistrement dans la table "' + QueryList.FieldByName('name').AsString + '" (avant : ' + IntToStr(Verif[QueryList.FieldByName('name').AsString]) + ' après : ' + IntToStr(QueryCount.FieldByName('nombre').AsInteger) + ')');
                      Exit;
                    end;
                  end
                  else
                  begin
                    if not (Verif[QueryList.FieldByName('name').AsString] = 0) then
                    begin
                      DoLog('      Manque des enregistrement dans la table "' + QueryList.FieldByName('name').AsString + '" (avant : ' + IntToStr(Verif[QueryList.FieldByName('name').AsString]) + ' après : 0)');
                      Exit;
                    end;
                  end;
                finally
                  QueryCount.Close();
                end;
                QueryList.Next();
              end;
            end;
          finally
            QueryList.Close();
          end;

          DoLog('    Commit de transaction');
          Transaction.Commit();
        except
          Transaction.Rollback();
          raise;
        end;

        Result := True;
      finally
        FreeAndNil(QueryList);
        FreeAndNil(QueryCount);
        FreeAndNil(Transaction);
        FreeAndNil(Connexion);
      end;
    except
      on e : Exception do
      begin
        DoLog(e.Message);
        Result := False;
      end;
    end;
  end;

var
  Deb : TDateTime;
  IbRestore: TIBRestoreService;
  sLigne: string;
begin
  Deb := DoLog('  Début DoRestore');
  Result := false;
  try
    try
      IbRestore := TIBRestoreService.Create(nil);
      IbRestore.Params.Add('user_name=sysdba');
      IbRestore.Params.Add('password=masterkey');
      IbRestore.BackupFile.Add(ChangeFileExt(FCheminBase, '.gbk'));
      ibRestore.DatabaseName.Add(FCheminBase);
      ibRestore.LoginPrompt := False;
      ibRestore.Verbose := True;
      ibRestore.Active := True;

      DoLog('    lancement du restore');

      ibRestore.ServiceStart();
      Result := true;

      while not ibRestore.Eof do
      begin
        sLigne := ibRestore.GetNextLine;
        if Pos('GBAK: ERROR', sLigne)>0 then
        begin
          DoLog('      Erreur du restore : "' + sLigne + '"');
          Result := false;
        end;
      end;

      if not GetVerifBackup(Verif) then
      begin
        DoLog('    Erreur de verification');
        REsult := false;
        Exit;
      end;

      DoLog('    Suppression du fichier');
      if result then
      begin
        DeleteFile(ChangeFileExt(FCheminBase, '.gbk'));
        DeleteFile(ChangeFileExt(FCheminBase, '.old'));
      end
      else
      begin
        DeleteFile(ChangeFileExt(FCheminBase, '.gbk'));
        DeleteFile(FCheminBase);
        MoveFile(PWideChar(ChangeFileExt(FCheminBase, '.old')), PWideChar(FCheminBase));
      end;
    finally
      ibRestore.Active := False;
      FreeAndNil(ibRestore);
    end;
  except
    on E: exception do
    begin
      DoLog(e.Message);
      Result := False;
    end;
  end;
  DoLog('  Fin DoRestore (Result = ' + BoolToStr(Result, true) + ') (Duree : ' + GetStrDuree(Deb) + ')');
end;

procedure TMonThread.ExportDataSetToDSV(ADataSet: TDataSet;
  const AFichier: TFileName; const AChampsExclus: array of string);
var
  fChamp    : TField;
  slLigne   : TStringList;
  bActive   : Boolean;
  twFichier : TTextWriter;
  i: Integer;
begin
  // Vérifie que le répertoire existe
  if ForceDirectories(ExtractFileDir(AFichier)) then
  begin
    twFichier := TStreamWriter.Create(AFichier);
    try
      slLigne := TStringList.Create();
      try
        bActive := ADataSet.Active;
        try
          ADataSet.Active             := True;
          slLigne.Delimiter           := ';';
          slLigne.StrictDelimiter     := True;

          ADataSet.GetFieldNames(slLigne);

          for i := (slLigne.Count - 1) downto 0 do
            if AnsiMatchText(slLigne[i], AChampsExclus) then
              slLigne.Delete(i);

          twFichier.WriteLine(slLigne.DelimitedText);
          ADataSet.First();
          while not ADataSet.Eof do
          begin
            slLigne.Clear();
            for fChamp in ADataSet.Fields do
              if not(AnsiMatchText(fChamp.FieldName, AChampsExclus)) then
                slLigne.Add(StringReplace(fChamp.Text, sLineBreak, ' ', [rfReplaceAll]));

            twFichier.WriteLine(slLigne.DelimitedText);
            ADataSet.Next();

            // Si l'arrêt du thread est demandée : on arrête
            if Terminated then
              Exit;
          end;
        finally
          ADataSet.Active := bActive;
        end;
      finally
        slLigne.Free();
      end;
    finally
      twFichier.Free();
    end;
  end;
end;

//function TDm_Main.ArretBase(AFileBase: string): boolean;
//var
//  IBConfig: TIBConfigService;
//begin
//  IBConfig := TIBConfigService.Create(Self);
//  try
//    try
//      IBConfig.DatabaseName := AFileBase;
//      IBConfig.LoginPrompt := false;
//      IBConfig.Params.Clear;
//      IBConfig.Params.Add('user_name=sysdba');
//      IBConfig.Params.Add('password=masterkey');
//      IBConfig.Active := true;
//      IBConfig.ShutdownDatabase(Forced, 5);
//      IBConfig.Active := false;
//      Result := true;
//    finally
//      IBConfig.Active := false;
//      FreeAndNil(IBConfig);
//    end;
//  except
//    Result := false;
//  end;
//end;

end.
