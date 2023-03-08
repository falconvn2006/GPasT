unit MigrationReferentiel.Ressources;

interface

uses
  Winapi.Windows,
  System.Classes,
  System.SysUtils,
  System.Generics.Collections,
  System.Win.Registry,
  System.UITypes,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Phys.IB,
  FireDAC.Comp.Client,
  FireDAC.Stan.Param,
  FireDAC.DatS,
  FireDAC.DApt,
  FireDAC.Comp.DataSet,
  Data.DB,
  FMX.Controls,
  FMX.Dialogs;

{$R MigrationReferentiel.Ressources.res}

resourcestring
  RS_OUVERTURE_BDD = 'Ouvre une base de données locale'#133;
  RS_OUVERTURE_EXTRACT = 'Ouvre le fichier d’extraction'#133;
  RS_OUVERTURE_CORRESP = 'Ouvre le fichier de correspondances'#133;
  RS_OUVERTURE_ARTICLES = 'Ouvre le fichier d’articles'#133;

  RS_ENREGISTREMENT_EXTRACT = 'Enregistre le fichier d’extraction sous'#133;
  RS_ENREGISTREMENT_CORRESP = 'Enregistre le fichier de correspondances sous'#133;

  RS_TYPEFIC_INTERBASE = 'Base de données InterBase (*.ib;*.gb)|*.ib;*.gb';
  RS_EXT_INTERBASE = 'ib';
  RS_TYPEFIC_DSV = 'Fichier DSV (*.txt;*.csv;*.dsv)|*.txt;*.csv;*.dsv';
  RS_EXT_DSV = 'csv';
  RS_TYPEFIC_EXCEL = 'Fichier Excel (*.xlsx)|*.xlsx';
  RS_EXT_EXCEL = 'xlsx';

  RS_BTN_ARRETER = 'Arrêter';
  RS_BTN_EXTRAIRE = 'Extraire';
  RS_BTN_ENREGISTRER = 'Enregistrer';
  RS_BTN_MAJ = 'Mettre à jour';

  RS_MSG_WARNING = 'Avertissement';
  RS_MSG_QUESTION = 'Confirmation';
  RS_MSG_ERROR = 'Erreur';
  RS_MSG_ERRORS = 'Erreurs';
  RS_MSG_INFORMATION = 'Information';

  RS_LOG_TRACE = 'Détail';
  RS_LOG_NOTICE = 'Notice';
  RS_LOG_ERREUR = 'Erreur';
  RS_LOG_ARRET = 'Arrêt';

  RS_ARRET_EXTRACTION = 'Extraction du fichier en cours d’arrêt'#133;
  RS_ARRET_ENREGISTREMENT = 'Enregistrement du fichier en cours d’arrêt'#133;
  RS_ARRET_MAJ = 'Mise à jour de la base de données en cours d’arrêt'#133;
  RS_ARRET_MAJ_NKL = 'Mise à jour du fichier d’articles en cours d’arrêt'#133;

  RS_ERREUR_BASEDONNEES = 'Le serveur ou la base de données n’est pas renseigné';
  RS_ERREUR_PAS_FICHIER_XLSX = 'Il n’existe pas de fichier Excel pour le type sélectionné';
  RS_ERREUR_EXCEL = 'Excel n’est pas installé sur ce poste';
  RS_ERREUR_FICHIER_DSV = 'Erreur lors de la lecteur du fichier DSV.'#13#10 +
    'Veuillez vérifier que celui-ci est conforme.';
  RS_ERREUR_FICHIER_EXCEL = 'Erreur lors de la lecture du fichier Excel.'#13#10 +
    'Veuillez vérifier que celui-ci est conforme.';
  RS_ERREUR_EXTRACTION = 'Une erreur s’est produite lors de l’extraction.';
  RS_ERREURS_EXTRACTION = '%u erreurs se sont produites lors de l’extraction.';
  RS_ERREUR_ENREGISTREMENT = 'Une erreur s’est produite lors de l’enregistrement des correspondances.';
  RS_ERREURS_ENREGISTREMENT = '%u erreurs se sont produites lors de l’enregistrement des correspondances.';
  RS_ERREUR_MAJ = 'Une erreur s’est produite lors de la mise à jour de la base de données.';
  RS_ERREURS_MAJ = '%u erreurs se sont produites lors de la mise à jour de la base de données.';
  RS_ERREUR_MAJ_NKL = 'Une erreur s’est produite lors de la mise à jour du fichier d’articles.';
  RS_ERREURS_MAJ_NKL = '%u erreurs se sont produites lors de la mise à jour du fichier d’articles.';
  RS_ERREUR_MANQUE_DESTINATION = 'La colonne "Destination" est manquante dans le fichier Excel.';
  RS_ERREUR_MANQUE_CODE = 'La colonne "CODE" ou "CODE FEDAS" est manquante dans le fichier Article.';
  RS_ERREUR_LECT_FICHIER_EXCEL = 'Erreur lors de la lecture de la cellule %s du fichier Excel. Erreur "%s".';

  RS_ERREUR_AFFICHERLOG = 'Voulez-vous afficher le fichier de journalisation'#160'?';

  RS_ERR_FIC_EXTRACTION = 'Veuillez renseigner le fichier vers lequel effectuer l’extraction.';
  RS_ERR_FIC_ENREGISTREMENT = 'Veuillez renseigner les fichiers à utiliser pour l’enregistrement du fichier Excel.';
  RS_ERR_FIC_MAJ = 'Veuillez renseigner le fichier à utiliser pour effectuer la mise à jour de la base de données.';
  RS_ERR_FIC_MAJ_NKL =
    'Veuillez renseigner les fichiers à utiliser pour effectuer la mise à jour du fichier d’articles.';

  RS_FIN_EXTRACTION = 'Extraction du fichier terminée.';
  RS_FIN_ENREGISTREMENT = 'Enregistrement du fichier terminé.';
  RS_FIN_MAJ = 'Mise à jour de la base de données terminée.';
  RS_FIN_MAJ_NKL = 'Mise à jour du fichier d’articles terminée.';

  RS_INTEROMP_EXTRACTION = 'Extraction du fichier interrompue.';
  RS_INTEROMP_ENREGISTREMENT = 'Enregistrement du fichier interrompu.';
  RS_INTEROMP_MAJ = 'Mise à jour de la base de données interrompue.';
  RS_INTEROMP_MAJ_NKL = 'Mise à jour du fichier d’articles interrompue.';

  RS_DLG_ARRET_EXTRACTION = 'Voulez-vous interrompre l’extraction'#160'?';
  RS_DLG_ARRET_EXTRACTION_MSG = 'Le fichier extrait sera incomplet.';
  RS_DLG_ARRET_ENREGISTREMENT = 'Voulez-vous interrompre l’enregistrement du fichier Excel'#160'?';
  RS_DLG_ARRET_ENREGISTREMENT_MSG = 'Les données extraites ne seront pas enregistrées.';
  RS_DLG_ARRET_MAJ = 'Voulez-vous interrompre la mise à jour de la base de données'#160'?';
  RS_DLG_ARRET_MAJ_MSG = 'Les informations mises à jour ne seront pas conservées.';
  RS_DLG_ARRET_MAJ_NKL = 'Voulez-vous interrompre la mise à jour du fichier d’articles'#160'?';
  RS_DLG_ARRET_MAJ_NKL_MSG = 'Les informations mises à jour ne seront pas enregistrées.';

  RS_DLG_ERREUR_EXCEL = 'Excel n’est pas installé sur ce poste.'#13#10 +
    'Certaines fonctionnalitées ne pourront pas fonctionner.';
  RS_DLG_ERREUR_EXCEL_MSG = 'Voulez-vous poursuivre l’utilisation de ce programme'#160'?';

  RS_MSG_PARAM_CONNECT = 'Paramètrage de la connexion'#133;
  RS_MSG_PARAM_CONNECT_PARAMS = 'Paramètrage de la connexion'#160':'#13#10 + #9'Server     = %0:s'#13#10 +
    #9'Port       = %1:u'#13#10 + #9'Database   = %2:s'#13#10 + #9'User_Name  = %3:s'#13#10 + #9'Password   = %4:s';

  RS_MSG_EXTRACTION = 'Extraction du fichier'#133;
  RS_MSG_EXTRACTION_NB = 'Extraction du fichier (%u / %u)'#133;
  RS_MSG_EXTRACTION_NOM = 'Extraction du fichier "%s".';

  RS_MSG_LECTURE_FIC = 'Lecture du fichier'#133;
  RS_MSG_LECTURE_FIC_NB = 'Lecture du fichier (%u / %u)'#133;
  RS_MSG_LECTURE_FIC_NOM = 'Lecture du fichier "%s".';

  RS_MSG_LECTURE_BDD = 'Lecture de la base de données'#133;
  RS_MSG_LECTURE_BDD_NB = 'Lecture de la base de données (%u / %u)'#133;
  RS_MSG_LECTURE_BDD_NOM = 'Lecture de la base de données "%s".';

  RS_MSG_CALCUL_CORRESP = 'Calcul des correspondances'#133;
  RS_MSG_CALCUL_CORRESP_NB = 'Calcul des correspondances (%u / %u)'#133;

  RS_MSG_ENR_CORRESP = 'Enregistre les correspondances dans le fichier Excel'#133;
  RS_MSG_ENR_CORRESP_NB = 'Enregistre les correspondances dans le fichier Excel (%u / %u)'#133;
  RS_MSG_ENR_CORRESP_FEUIL = 'Enregistre les correspondances dans le fichier Excel [%s]'#133;
  RS_MSG_ENR_CORRESP_FEUIL_NB = 'Enregistre les correspondances dans le fichier Excel [%s] (%u / %u)'#133;

  RS_MSG_ENR_FICHIER = 'Enregistrement du fichier "%s".';

  RS_MSG_RECUP_CORRESP = 'Récupère les correspondances depuis le fichier Excel'#133;
  RS_MSG_RECUP_CORRESP_NB = 'Récupère les correspondances depuis le fichier Excel (%u / %u)'#133;
  RS_MSG_RECUP_CORRESP_NOM = 'Récupère les correspondances depuis le fichier Excel "%s".';

  RS_MSG_MAJ_BDD = 'Mise à jour de la base de données'#133;
  RS_MSG_MAJ_BDD_NB = 'Mise à jour de la base de données (%u / %u)'#133;

  RS_MSG_MAJ_FIC = 'Mise à jour des articles du fichier CSV'#133;
  RS_MSG_MAJ_FIC_NB = 'Mise à jour des articles du fichier CSV (%u / %u)'#133;
  RS_MSG_MAJ_FIC_NOM = 'Mise à jour des articles du fichier CSV "%s".';

type
  // Types pour les logs
  TNiveauLog       = (NivTrace, NivNotice, NivErreur, NivArret);
  TProcJournaliser = procedure(const AMessage: string; const ANiveau: TNiveauLog = NivNotice) of object;
  TProcProgression = procedure(const AStatut: string; const APosition: Integer = -1; const AMax: Integer = -1)
    of object;

  TTypeReferentiel = (trMarques = 0, trFournisseurs = 1, trNomenclature = 2);

  // Classe abstraite pour les Threads
  TCustomMigrationThread = class(TThread)
  protected
    { Déclarations protégées }
    FDConnection    : TFDConnection;
    FDTransaction   : TFDTransaction;
    FDQuery         : TFDQuery;
    FDProcStoc      : TFDStoredProc;
    FErreur         : Boolean;
    FNbErreurs      : Integer;
    FMsgErreur      : string;
    FProcJournaliser: TProcJournaliser;
    FProcProgression: TProcProgression;
    procedure Journaliser(const AMessage: string; const ANiveau: TNiveauLog = NivNotice);
    procedure Progression(const AStatut: string; const APosition: Integer = -1; const AMax: Integer = -1);
  public
    { Déclarations publiques }
    Serveur                 : string;
    Port                    : Integer;
    BaseDonnees             : TFileName;
    Utilisateur             : string;
    MotPasse                : string;
    property Erreur         : Boolean read FErreur;
    property NbErreurs      : Integer read FNbErreurs;
    property MsgErreur      : string read FMsgErreur;
    property ProcJournaliser: TProcJournaliser read FProcJournaliser write FProcJournaliser;
    property ProcProgression: TProcProgression read FProcProgression write FProcProgression;
    constructor Create(CreateSuspended: Boolean); virtual;
    destructor Destroy(); virtual;
  end;

  // Types pour les correspondances
  TFiabilite = (fiabExacte, fiabMemeCode, fiabNomApprochant, fiabAucune);

  TCodeValeur = class
    Code: string;
    Valeur: string;
  end;

  TCodesValeurs = TObjectList<TCodeValeur>;

  TCodeValeurNkl = class
    Univers: string;
    Secteur: string;
    Rayon: string;
    Famille: string;
    SousFamille: string;
    CodeFinal: string;
  end;

  TCodesValeursNkl = TObjectList<TCodeValeurNkl>;

  TCorrespondance = class
    BaseDonnees: TCodeValeur;
    Fichier: TCodeValeur;
    Fiabilite: TFiabilite;
  public
    { Déclarations publiques }
    constructor Create(); overload;
    constructor Create(const ABaseDonneesCode, ABaseDonneesValeur, AFichierCode, AFichierValeur: string;
      const AFiabilite: TFiabilite = fiabExacte); overload;
    constructor Create(const ABaseDonnees, AFichier: TCodeValeur; const AFiabilite: TFiabilite = fiabExacte); overload;
    destructor Destroy(); override;
  end;

  TCorrespondances = class(TObjectList<TCorrespondance>)
  public
    { Déclarations publiques }
    function FindBaseDonnees(const ACode, AValeur: string; out ACorrespondance: TCorrespondance): Boolean;
    function FindFichier(const ACode, AValeur: string; out ACorrespondance: TCorrespondance): Boolean;
  end;

  TCorrespondanceNkl = class
    BaseDonnees: TCodeValeurNkl;
    Fichier: TCodeValeurNkl;
    Fiabilite: TFiabilite;
  public
    { Déclarations publiques }
    constructor Create(); overload;
    constructor Create(const ABaseDonneesCodeFinal, ABaseDonneesUnivers, ABaseDonneesSecteur, ABaseDonneesRayon,
      ABaseDonneesFamille, ABaseDonneesSousFamille: string; const AFichierCodeFinal: string = '';
      const AFichierUnivers: string = ''; const AFichierSecteur: string = ''; const AFichierRayon: string = '';
      const AFichierFamille: string = ''; const AFichierSousFamille: string = '';
      const AFiabilite: TFiabilite = fiabExacte); overload;
    constructor Create(const ABaseDonnees, AFichier: TCodeValeurNkl;
      const AFiabilite: TFiabilite = fiabExacte); overload;
    destructor Destroy(); override;
  end;

  TCorrespondancesNkl = class(TObjectList<TCorrespondanceNkl>)
  public
    { Déclarations publiques }
    function FindBaseDonnees(const ACodeFinal, AUnivers, ASecteur, ARayon, AFamille, ASousFamille: string;
      out ACorrespondanceNkl: TCorrespondanceNkl): Boolean; overload;
    function FindBaseDonnees(const ACodeValeurNkl: TCodeValeurNkl; out ACorrespondanceNkl: TCorrespondanceNkl)
      : Boolean; overload;
    function FindFichier(const ACodeFinal, AUnivers, ASecteur, ARayon, AFamille, ASousFamille: string;
      out ACorrespondanceNkl: TCorrespondanceNkl): Boolean; overload;
    function FindFichier(const ACodeValeurNkl: TCodeValeurNkl; out ACorrespondanceNkl: TCorrespondanceNkl)
      : Boolean; overload;
  end;

  EBaseDonnees        = class(Exception);
  EExcelManquant      = class(Exception);
  EErreurFichierExcel = class(Exception);
  EErreurFichierDSV   = class(Exception);

  // Information sur un exécutable
  TInfoSurExe = record
    FileDescription: string;
    CompanyName: string;
    FileVersion: string;
    InternalName: string;
    LegalCopyright: string;
    OriginalFileName: string;
    ProductName: string;
    ProductVersion: string;
  end;

const
  TD_ICON_BLANK           = $00;
  TD_ICON_WARNING         = $54;
  TD_ICON_QUESTION        = $63;
  TD_ICON_ERROR           = $62;
  TD_ICON_INFORMATION     = $51;
  TD_ICON_SHIELD_QUESTION = $68;
  TD_ICON_SHIELD_ERROR    = $69;
  TD_ICON_SHIELD_OK       = $6A;
  TD_ICON_SHIELD_WARNING  = $6B;

  TD_BUTTON_OK       = $01;
  TD_BUTTON_YES      = $02;
  TD_BUTTON_NO       = $04;
  TD_BUTTON_CANCEL   = $08;
  TD_BUTTON_RETRY    = $10;
  TD_BUTTON_CLOSE    = $20;
  TD_BUTTON_YESNO    = TD_BUTTON_YES + TD_BUTTON_NO;
  TD_BUTTON_OKCANCEL = TD_BUTTON_OK + TD_BUTTON_CANCEL;

  TD_RESULT_OK     = $01;
  TD_RESULT_CANCEL = $02;
  TD_RESULT_RETRY  = $04;
  TD_RESULT_YES    = $06;
  TD_RESULT_NO     = $07;
  TD_RESULT_CLOSE  = $08;

  // Récupère des informations sur un exécutable
function InfoSurExe(AFichier: TFileName): TInfoSurExe;
// Vérifie qu'une application est installée
function ApplicationInstalled(const AApplication: string; const ACle: HKEY = HKEY_CLASSES_ROOT): Boolean;
function TaskDialog(const AHandle: THandle; const ATitle, AMainInstruction, AContent: string;
  const Icon, Buttons: Integer): Integer;

implementation

// Récupère des informations sur un exécutable
function InfoSurExe(AFichier: TFileName): TInfoSurExe;
const
  VersionInfo: array [1 .. 8] of string = ('FileDescription', 'CompanyName', 'FileVersion', 'InternalName',
    'LegalCopyRight', 'OriginalFileName', 'ProductName', 'ProductVersion');
var
  Handle  : DWord;
  Info    : Pointer;
  InfoData: Pointer;
  InfoSize: Longint;
  DataLen : UInt;
  LangPtr : Pointer;
  InfoType: string;
  i       : Integer;
begin
  // Récupère la taille nécessaire pour les infos
  InfoSize := GetFileVersionInfoSize(Pchar(AFichier), Handle);

  // Initialise la variable de retour
  with Result do
  begin
    FileDescription  := '';
    CompanyName      := '';
    FileVersion      := '';
    InternalName     := '';
    LegalCopyright   := '';
    OriginalFileName := '';
    ProductName      := '';
    ProductVersion   := '';
  end;
  i := 1;

  // Si il y a des informations de version
  if InfoSize > 0 then
  begin
    // Réserve la mémoire
    GetMem(Info, InfoSize);

    try
      // Si les infos peuvent être récupérées
      if GetFileVersionInfo(Pchar(AFichier), Handle, InfoSize, Info) then
        repeat
          // Spécifie le type d'information à récupérer
          InfoType := VersionInfo[i];

          if VerQueryValue(Info, '\VarFileInfo\Translation', LangPtr, DataLen) then
            InfoType := Format('\StringFileInfo\%0.4x%0.4x\%s'#0, [LoWord(Longint(LangPtr^)), HiWord(Longint(LangPtr^)),
                InfoType]);

          // Remplit la variable de retour
          if VerQueryValue(Info, @InfoType[1], InfoData, DataLen) then
            case i of
              1:
                Result.FileDescription := Pchar(InfoData);
              2:
                Result.CompanyName := Pchar(InfoData);
              3:
                Result.FileVersion := Pchar(InfoData);
              4:
                Result.InternalName := Pchar(InfoData);
              5:
                Result.LegalCopyright := Pchar(InfoData);
              6:
                Result.OriginalFileName := Pchar(InfoData);
              7:
                Result.ProductName := Pchar(InfoData);
              8:
                Result.ProductVersion := Pchar(InfoData);
            end;

          // Incrémente i
          Inc(i);
        until i >= 8;
    finally
      // Libère la mémoire
      FreeMem(Info, InfoSize);
    end;
  end;
end;

// Vérifie qu'une application est installée
function ApplicationInstalled(const AApplication: string; const ACle: HKEY = HKEY_CLASSES_ROOT): Boolean;
var
  Registre: TRegistry;
begin
  Result := False;
  // Création de l'objet registre
  Registre := TRegistry.Create();
  try
    // Sélection de la clé principale
    Registre.RootKey := ACle;
    if Registre.KeyExists(AApplication) then
      Result := True;
  finally
    Registre.Free();
  end;
end;

function TaskDialog(const AHandle: THandle; const ATitle, AMainInstruction, AContent: string;
  const Icon, Buttons: Integer): Integer;

  function IsWindowsVista(): Boolean;
  var
    VerInfo: TOSVersioninfo;
  begin
    VerInfo.dwOSVersionInfoSize := SizeOf(TOSVersioninfo);
    GetVersionEx(VerInfo);
    Result := VerInfo.dwMajorVersion >= 6;
  end;

const
  TaskDialogSig = 'TaskDialog';
var
  DLLHandle       : THandle;
  res             : Integer;
  S               : string;
  wTitle          : array [0 .. 1024] of widechar;
  wMainInstruction: array [0 .. 1024] of widechar;
  wContent        : array [0 .. 1024] of widechar;
  Btns            : TMsgDlgButtons;
  DlgType         : TMsgDlgType;
  TaskDialogProc  : function(HWND: THandle; hInstance: THandle; cTitle, cDescription, cContent: pwidechar;
    Buttons: Integer; Icon: Integer; ResButton: pinteger): Integer;
cdecl stdcall;

begin
  Result := 0;
  if IsWindowsVista() then
  begin
    DLLHandle := LoadLibrary(comctl32);
    if DLLHandle >= 32 then
    begin
      @TaskDialogProc := GetProcAddress(DLLHandle, TaskDialogSig);

      if Assigned(TaskDialogProc) then
      begin
        StringToWideChar(ATitle, wTitle, SizeOf(wTitle));
        StringToWideChar(AMainInstruction, wMainInstruction, SizeOf(wMainInstruction));
        StringToWideChar(AContent, wContent, SizeOf(wContent));

        TaskDialogProc(AHandle, 0, wTitle, wMainInstruction, wContent, Buttons, Icon, @res);

        Result := mrOK;

        case res of
          TD_RESULT_CANCEL:
            Result := mrCancel;
          TD_RESULT_RETRY:
            Result := mrRetry;
          TD_RESULT_YES:
            Result := mrYes;
          TD_RESULT_NO:
            Result := mrNo;
          TD_RESULT_CLOSE:
            Result := mrAbort;
        end;
      end;
      FreeLibrary(DLLHandle);
    end;
  end
  else
  begin
    Btns := [];
    if Buttons and TD_BUTTON_OK = TD_BUTTON_OK then
      Btns := Btns + [TMsgDlgBtn.mbOK];

    if Buttons and TD_BUTTON_YES = TD_BUTTON_YES then
      Btns := Btns + [TMsgDlgBtn.mbYes];

    if Buttons and TD_BUTTON_NO = TD_BUTTON_NO then
      Btns := Btns + [TMsgDlgBtn.mbNo];

    if Buttons and TD_BUTTON_CANCEL = TD_BUTTON_CANCEL then
      Btns := Btns + [TMsgDlgBtn.mbCancel];

    if Buttons and TD_BUTTON_RETRY = TD_BUTTON_RETRY then
      Btns := Btns + [TMsgDlgBtn.mbRetry];

    if Buttons and TD_BUTTON_CLOSE = TD_BUTTON_CLOSE then
      Btns := Btns + [TMsgDlgBtn.mbAbort];

    DlgType := TMsgDlgType.mtCustom;

    case Icon of
      TD_ICON_WARNING:
        DlgType := TMsgDlgType.mtWarning;
      TD_ICON_QUESTION:
        DlgType := TMsgDlgType.mtConfirmation;
      TD_ICON_ERROR:
        DlgType := TMsgDlgType.mtError;
      TD_ICON_INFORMATION:
        DlgType := TMsgDlgType.mtInformation;
    end;

    Result := MessageDlg(AContent, DlgType, Btns, 0);
  end;
end;

{ TCustomMigrationThread }

constructor TCustomMigrationThread.Create(CreateSuspended: Boolean);
begin
  inherited;

  FDConnection  := nil;
  FDTransaction := nil;
  FDQuery       := nil;
  FDProcStoc    := nil;
  Serveur       := '';
  Port          := 0;
  BaseDonnees   := '';
  Utilisateur   := '';
  MotPasse      := '';
  FErreur       := False;
  FNbErreurs    := 0;
  FMsgErreur    := '';
end;

destructor TCustomMigrationThread.Destroy();
begin
  // Détruit les composants pour les requêtes SQL
  FreeAndNil(FDProcStoc);
  FreeAndNil(FDQuery);
  FreeAndNil(FDTransaction);
  FreeAndNil(FDConnection);

  inherited;
end;

procedure TCustomMigrationThread.Journaliser(const AMessage: string; const ANiveau: TNiveauLog = NivNotice);
begin
  if Assigned(FProcJournaliser) then
  begin
    Synchronize(
        procedure
      begin
        FProcJournaliser(AMessage, ANiveau);
      end);
  end;
end;

procedure TCustomMigrationThread.Progression(const AStatut: string; const APosition: Integer = -1;
const AMax: Integer = -1);
begin
  if Assigned(FProcProgression) then
  begin
    Synchronize(
      procedure
      begin
        FProcProgression(AStatut, APosition, AMax);
      end);
  end;
end;

{ TCorrespondance }

constructor TCorrespondance.Create();
begin
  // Créer les variables
  BaseDonnees := TCodeValeur.Create();
  Fichier     := TCodeValeur.Create();
end;

constructor TCorrespondance.Create(const ABaseDonneesCode, ABaseDonneesValeur, AFichierCode, AFichierValeur: string;
const AFiabilite: TFiabilite = fiabExacte);
begin
  // Créer les variables
  Create();

  BaseDonnees.Code   := ABaseDonneesCode;
  BaseDonnees.Valeur := ABaseDonneesValeur;
  Fichier.Code       := AFichierCode;
  Fichier.Valeur     := AFichierValeur;

  Fiabilite := AFiabilite;
end;

constructor TCorrespondance.Create(const ABaseDonnees, AFichier: TCodeValeur;
const AFiabilite: TFiabilite = fiabExacte);
begin
  // Créer les variables
  Create(ABaseDonnees.Code, ABaseDonnees.Valeur, AFichier.Code, AFichier.Valeur, AFiabilite);
end;

destructor TCorrespondance.Destroy();
begin
  // Détruit les variables
  FreeAndNil(BaseDonnees);
  FreeAndNil(Fichier);

  inherited;
end;

{ TCorrespondanceNkl }

constructor TCorrespondanceNkl.Create();
begin
  // Créer les variables
  BaseDonnees := TCodeValeurNkl.Create();
  Fichier     := TCodeValeurNkl.Create();
end;

constructor TCorrespondanceNkl.Create(const ABaseDonneesCodeFinal, ABaseDonneesUnivers, ABaseDonneesSecteur,
  ABaseDonneesRayon, ABaseDonneesFamille, ABaseDonneesSousFamille: string; const AFichierCodeFinal: string = '';
const AFichierUnivers: string = ''; const AFichierSecteur: string = ''; const AFichierRayon: string = '';
const AFichierFamille: string = ''; const AFichierSousFamille: string = ''; const AFiabilite: TFiabilite = fiabExacte);
begin
  // Créer les variables
  Create();

  BaseDonnees.Univers     := ABaseDonneesUnivers;
  BaseDonnees.Secteur     := ABaseDonneesSecteur;
  BaseDonnees.Rayon       := ABaseDonneesRayon;
  BaseDonnees.Famille     := ABaseDonneesFamille;
  BaseDonnees.SousFamille := ABaseDonneesSousFamille;
  BaseDonnees.CodeFinal   := ABaseDonneesCodeFinal;
  Fichier.Univers         := AFichierUnivers;
  Fichier.Secteur         := AFichierSecteur;
  Fichier.Rayon           := AFichierRayon;
  Fichier.Famille         := AFichierFamille;
  Fichier.SousFamille     := AFichierSousFamille;
  Fichier.CodeFinal       := AFichierCodeFinal;

  Fiabilite := AFiabilite;
end;

constructor TCorrespondanceNkl.Create(const ABaseDonnees, AFichier: TCodeValeurNkl;
const AFiabilite: TFiabilite = fiabExacte);
begin
  // Créer les variables
  Create(ABaseDonnees.CodeFinal, ABaseDonnees.Univers, ABaseDonnees.Secteur, ABaseDonnees.Rayon, ABaseDonnees.Famille,
    ABaseDonnees.SousFamille, AFichier.CodeFinal, AFichier.Univers, AFichier.Secteur, AFichier.Rayon, AFichier.Famille,
    AFichier.SousFamille, AFiabilite);
end;

destructor TCorrespondanceNkl.Destroy();
begin
  // Détruit les variables
  FreeAndNil(BaseDonnees);
  FreeAndNil(Fichier);

  inherited;
end;

{ TCorrespondances }

function TCorrespondances.FindBaseDonnees(const ACode, AValeur: string; out ACorrespondance: TCorrespondance): Boolean;
var
  Correspondance: TCorrespondance;
begin
  Result := False;

  for Correspondance in Self do
  begin
    if AnsiSameText(Correspondance.BaseDonnees.Code, ACode) and AnsiSameText(Correspondance.BaseDonnees.Valeur, AValeur)
    then
    begin
      Result          := True;
      ACorrespondance := Correspondance;
      Break;
    end;
  end;
end;

function TCorrespondances.FindFichier(const ACode, AValeur: string; out ACorrespondance: TCorrespondance): Boolean;
var
  Correspondance: TCorrespondance;
begin
  Result := False;

  for Correspondance in Self do
  begin
    if AnsiSameText(Correspondance.Fichier.Code, ACode) and AnsiSameText(Correspondance.Fichier.Valeur, AValeur) then
    begin
      Result          := True;
      ACorrespondance := Correspondance;
      Break;
    end;
  end;
end;

{ TCorrespondancesNkl }

function TCorrespondancesNkl.FindBaseDonnees(const ACodeFinal, AUnivers, ASecteur, ARayon, AFamille,
  ASousFamille: string; out ACorrespondanceNkl: TCorrespondanceNkl): Boolean;
var
  CorrespondanceNkl: TCorrespondanceNkl;
begin
  Result := False;

  for CorrespondanceNkl in Self do
  begin
    if AnsiSameText(CorrespondanceNkl.BaseDonnees.CodeFinal, ACodeFinal) and
      AnsiSameText(CorrespondanceNkl.BaseDonnees.Univers, AUnivers) and
      AnsiSameText(CorrespondanceNkl.BaseDonnees.Secteur, ASecteur) and
      AnsiSameText(CorrespondanceNkl.BaseDonnees.Rayon, ARayon) and AnsiSameText(CorrespondanceNkl.BaseDonnees.Famille,
      AFamille) and AnsiSameText(CorrespondanceNkl.BaseDonnees.SousFamille, ASousFamille) then
    begin
      Result             := True;
      ACorrespondanceNkl := CorrespondanceNkl;
      Break;
    end;
  end;
end;

function TCorrespondancesNkl.FindBaseDonnees(const ACodeValeurNkl: TCodeValeurNkl;
out ACorrespondanceNkl: TCorrespondanceNkl): Boolean;
begin
  Result := FindBaseDonnees(ACodeValeurNkl.CodeFinal, ACodeValeurNkl.Univers, ACodeValeurNkl.Secteur,
    ACodeValeurNkl.Rayon, ACodeValeurNkl.Famille, ACodeValeurNkl.SousFamille, ACorrespondanceNkl);
end;

function TCorrespondancesNkl.FindFichier(const ACodeFinal, AUnivers, ASecteur, ARayon, AFamille, ASousFamille: string;
out ACorrespondanceNkl: TCorrespondanceNkl): Boolean;
var
  CorrespondanceNkl: TCorrespondanceNkl;
begin
  Result := False;

  for CorrespondanceNkl in Self do
  begin
    if AnsiSameText(CorrespondanceNkl.Fichier.CodeFinal, ACodeFinal) and AnsiSameText(CorrespondanceNkl.Fichier.Univers,
      AUnivers) and AnsiSameText(CorrespondanceNkl.Fichier.Secteur, ASecteur) and
      AnsiSameText(CorrespondanceNkl.Fichier.Rayon, ARayon) and AnsiSameText(CorrespondanceNkl.Fichier.Famille,
      AFamille) and AnsiSameText(CorrespondanceNkl.Fichier.SousFamille, ASousFamille) then
    begin
      Result             := True;
      ACorrespondanceNkl := CorrespondanceNkl;
      Break;
    end;
  end;
end;

function TCorrespondancesNkl.FindFichier(const ACodeValeurNkl: TCodeValeurNkl;
out ACorrespondanceNkl: TCorrespondanceNkl): Boolean;
begin
  Result := FindFichier(ACodeValeurNkl.CodeFinal, ACodeValeurNkl.Univers, ACodeValeurNkl.Secteur, ACodeValeurNkl.Rayon,
    ACodeValeurNkl.Famille, ACodeValeurNkl.SousFamille, ACorrespondanceNkl);
end;

end.
