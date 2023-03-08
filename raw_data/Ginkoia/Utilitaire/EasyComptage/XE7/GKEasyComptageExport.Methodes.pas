unit GKEasyComptageExport.Methodes;

interface

uses
  System.Classes,
  System.SysUtils,
  System.IniFiles,
  System.DateUtils,
  System.StrUtils,
  System.Math,
  System.Types,
  System.Win.Registry,
  System.Generics.Collections,
  System.Generics.Defaults,
  Winapi.ShellAPI,
  Winapi.Windows,
  Winapi.TlHelp32,
  VCL.Forms,
  VCL.Dialogs,
  Data.DB,
  GKEasyComptageExport.Ressources;

type
  TNiveau             = (NivDetail, NivErreur, NivArret);
  EErreurIBTraitement = class(Exception);

  TConfig = record
    DestPath        : String;
    Periodicite     : Integer;
    Heure           : TTime;
    Minutes         : Integer;
    Jours           : Integer;
    dPrevAction     : TDateTime;
    dNextAction     : TDateTime;
    bDemarrageAuto  : Boolean;
    tHeureDemarrage : TTime;
    bArretAuto      : Boolean;
    tHeureArret     : TTime;
    sUtilisateur    : String;
    sMotPasse       : String;
    bLogVerbeux     : Boolean;
  end;

  TBoCaisse = class
  public
    sCodePDV   : String;
    sDateJour  : String[8];
    iNTranche  : Integer;
    iNbTickets : Integer;
    fCA        : Currency;
    iNbVendeur : Integer;
  end;

  TOblBoCaisse = TObjectList<TBoCaisse>;

  TParamsConnexion = record
    BaseDonnees : TFileName;
    NomPoste    : string;
    NomBase     : string;
    NomMag      : string;
    MagId       : Integer;
    NbEssais    : Integer;
    Delais      : Integer;
  end;


  TPeriodeTranche = record
    dDateDebut : TDateTime;
    dDateFin   : TDateTime;
  end;

  // Information sur un exécutable
  TInfoSurExe = record
    FileDescription   : String;
    CompanyName       : String;
    FileVersion       : String;
    InternalName      : String;
    LegalCopyright    : String;
    OriginalFileName  : String;
    ProductName       : String;
    ProductVersion    : String;
  end;

var
  GAPPPATH        : string;
  GINIFILE        : string;
  GCONFIGAPP      : TConfig;
  ParamsConnexion : TParamsConnexion;
  GTESTMODE       : Boolean = False;
  HeureLancement  : TDateTime;

// Enregistre des informations dans un fichier
procedure Journaliser(const AMessage: String; const ANiveau: TNiveau = NivDetail);

// Charge chemin base
function ParamsBase(): TParamsConnexion;

// Charge les paramètres
procedure ChargerParametres();

// Enregistre les paramètres
procedure EnregistreParametres();

// Enregistre les paramètres dans l'INI
procedure EnregistreFichierIni();

// Récupère des informations sur un exécutable
function InfoSurExe(const AFichier: TFileName): TInfoSurExe;

// Créer la tâche journalière
function CreerTachePlanifiee(AHeureDebut: TTime): Boolean;

// Supprimer la tâche journalière
function SupprimeTachePlanifiee(): Boolean;

// Créer le démarrage auto
function CreerDemarrageAuto(): Boolean;

// Tue un processus via son nom
function KillProcess(const AProcessName: String): Boolean;

// Vérifie si l'OS est Windows Vista ou supérieur
function IsWindowsVista(): Boolean;

// Vérifie si l'OS est Windows 2003
function IsWindows2003(): Boolean;

// Export le contenu d'un DataSet dans un fichier DSV
procedure ExportDataSetToDVS(ADataSet: TDataSet; const AFichier: TFileName;
  const ATxtMsg: string; const ADelimiter: Char = ';');

// Import le contenu d'un fichier DSV dans un objet TOblBoCaisse
function ImportBoCaisse(const AFichier: TFileName; var AOblBoCaisse: TOblBoCaisse): Boolean;

// Exporte un TOblBoCaisse dans un fichier DSV
function ExportBoCaisse(const AFichier: TFileName; const AOblBoCaisse: TOblBoCaisse): Boolean;

// Vérifie si une date est bien encodée au format AAAAMMJJ
function TryIso8601BasicToDate(const AStr: String; out ODate: TDateTime): Boolean;

function CalculTranche(const ADate: TDateTime): Integer;
function CalculPeriode(ADate: TDateTime; const ATranche: Integer): TPeriodeTranche;
function CalculProchDate(const ADate: TDateTime): TDateTime;

implementation

uses
  GKEasyComptageExport.DataModule.Main;


// Enregistre des informations dans un fichier
procedure Journaliser(const AMessage: String; const ANiveau: TNiveau = NivDetail);
var
  sRepertoire, sNomFichier, sNiveau: String;
  slFichierLog: TStringList;
begin
  // Si le mode verbeux n'est pas activé : ne pas logguer les détails
  if not(GCONFIGAPP.bLogVerbeux)
    and (ANiveau = NivDetail) then
    Exit;

  // Récupération du niveau
  case ANiveau of
    NivDetail : sNiveau := 'Détail';
    NivErreur : sNiveau := 'Erreur';
    NivArret  : sNiveau := 'Arrêt';
  end;

  // Enregistrement dans le fichier
  slFichierLog := TStringList.Create();
  try
    sRepertoire := ExtractFilePath(Application.ExeName) + 'Logs\';
    if not(System.SysUtils.DirectoryExists(sRepertoire)) then
      System.SysUtils.ForceDirectories(sRepertoire);

    sNomFichier := Format('%sLog_%s-%s.log', [sRepertoire,
      ChangeFileExt(ExtractFileName(Application.ExeName), ''),
      FormatDateTime('yyyy-mm-dd', Now())]);

    if FileExists(sNomFichier) then
      slFichierLog.LoadFromFile(sNomFichier);

    slFichierLog.Add(Format('%s - [%s] %s', [FormatDateTime('hh:nn:ss.zzz', Now()), sNiveau, AMessage]));

    slFichierLog.SaveToFile(sNomFichier);
  finally
    slFichierLog.Free();
  end;
end;

// Charge chemin base
function ParamsBase(): TParamsConnexion;
var
  IniParams: TIniFile;
begin
  // Vérifie si le fichier existe
  if FileExists(GINIFILE) then
  begin
    // Charge le fichier INI
    IniParams := TIniFile.Create(GINIFILE);
    try
      Result.BaseDonnees  := IniParams.ReadString('DATABASE', 'PATH0', '');
      Result.NomPoste     := IniParams.ReadString('NOMPOSTE', 'POSTE0', '');
      Result.NomBase      := IniParams.ReadString('NOMBASES', 'ITEM0', '');
      Result.NomMag       := IniParams.ReadString('NOMMAGS', 'MAG0', '');
      Result.NbEssais     := IniParams.ReadInteger('PARAM', 'NBESSAIS', NBESSAIS_DEFAUT);
      Result.Delais       := IniParams.ReadInteger('PARAM', 'DELAIS', DELAIS_DEFAUT);
    finally
      IniParams.Free();
    end;
  end
  else begin
    // Créer le fichier INI
    IniParams := TIniFile.Create(GINIFILE);
    try
      IniParams.WriteString('DATABASE', 'PATH0', '');
      IniParams.WriteString('NOMPOSTE', 'POSTE0', '');
      IniParams.WriteString('NOMBASES', 'ITEM0', '');
      IniParams.WriteString('NOMMAGS', 'MAG0', '');
      IniParams.WriteInteger('PARAM', 'NBESSAIS', NBESSAIS_DEFAUT);
      IniParams.WriteInteger('PARAM', 'DELAIS', DELAIS_DEFAUT);

      Result.BaseDonnees  := '';
    finally
      IniParams.Free();
    end;
  end;
end;

// Charge les paramètres
procedure ChargerParametres();
var
  IniParams : TIniFile;
  Periode   : TPeriodeTranche;
  iResult   : Integer;
  sHeure    : string;
  hHeure    : TDateTime;
begin
  // Charge le fichier INI
  IniParams := TIniFile.Create(GINIFILE);
  try
    // Charge les données de la table GENPARAM
    GCONFIGAPP.DestPath         := DataModuleMain.GetParamString(ParamsConnexion.MagId, 3, 10200);
    GCONFIGAPP.Jours            := Round(DataModuleMain.GetParamFloat(ParamsConnexion.MagId, 3, 10200));
    GCONFIGAPP.Periodicite      := Pred(DataModuleMain.GetParamInteger(ParamsConnexion.MagId, 3, 10201));
    GCONFIGAPP.Heure            := 0;
    GCONFIGAPP.Minutes          := 0;

    case GCONFIGAPP.Periodicite of
      // Si périodicité 1 fois par jour
      0: begin
        sHeure := DataModuleMain.GetParamString(ParamsConnexion.MagId, 3, 10201);
        if TryStrToTime(sHeure, hHeure) then
          GCONFIGAPP.Heure  := hHeure;
      end;
      // Si périodicité x fois par jour
      1: begin
        GCONFIGAPP.Minutes      := Round(DataModuleMain.GetParamFloat(ParamsConnexion.MagId, 3, 10201));
      end;
    end;

    GCONFIGAPP.bDemarrageAuto   := (DataModuleMain.GetParamInteger(ParamsConnexion.MagId, 3, 10202) = 1);
    GCONFIGAPP.tHeureDemarrage  := DataModuleMain.GetParamFloat(ParamsConnexion.MagId, 3, 10202);

    GCONFIGAPP.bArretAuto       := (DataModuleMain.GetParamInteger(ParamsConnexion.MagId, 3, 10203) = 1);
    GCONFIGAPP.tHeureArret      := DataModuleMain.GetParamFloat(ParamsConnexion.MagId, 3, 10203);

    // Charge les paramètres du fichier INI
    GCONFIGAPP.dPrevAction      := IniParams.ReadDateTime('PARAM', 'DATEDEBUT', StrToDateTime(FormatDateTime('DD/MM/YYYY 00:00:00', Now())));
    GCONFIGAPP.dNextAction      := IniParams.ReadDateTime('PARAM', 'DATEFIN', Now());
    GCONFIGAPP.sUtilisateur     := IniParams.ReadString('PARAM', 'Utilisateur', 'Bureau');
    GCONFIGAPP.sMotPasse        := IniParams.ReadString('PARAM', 'MotPasse', '');
    GCONFIGAPP.bLogVerbeux      := IniParams.ReadBool('PARAM', 'LogVerbeux', False);

    // Calcul la périodicité
    case GCONFIGAPP.Periodicite of
      // Si périodicité 1 fois par jour
      0: begin
        GCONFIGAPP.dNextAction                  := RecodeTime(Now(), HourOf(GCONFIGAPP.Heure), MinuteOf(GCONFIGAPP.Heure), 0, 0);
        Periode.dDateDebut                      := GCONFIGAPP.dPrevAction;
        Periode.dDateFin                        := GCONFIGAPP.dNextAction;
//        DataModuleMain.TimTraitement.Interval   := 15 * 60 * 1000;

        // Enregistre les dates de début et fin dans le fichier INI
        IniParams.WriteDateTime('PARAM', 'DATEDEBUT', GCONFIGAPP.dNextAction);
        IniParams.WriteDateTime('PARAM', 'DATEFIN', GCONFIGAPP.dNextAction);
      end;
      // Si périodicité x fois par jour
      1: begin
        iResult                                 := CalculTranche(Now());
        Periode                                 := CalculPeriode(Now(), iResult);
        Periode.dDateFin                        := IncMinute(Periode.dDateFin, GCONFIGAPP.Minutes - 15);
        GCONFIGAPP.dNextAction                  := Periode.dDateFin;
//        DataModuleMain.TimTraitement.Interval   := (SecondsBetween(Now(), GCONFIGAPP.dNextAction) + 1) * 1000;

        // Enregistre les dates de début et fin dans le fichier INI
        IniParams.WriteDateTime('PARAM', 'DATEFIN', IncSecond(GCONFIGAPP.dNextAction));
      end;
    end;
  finally
    IniParams.Free();
  end;
end;

// Enregistre les paramètres
procedure EnregistreParametres();
begin
  // Enregistre les paramètres dans la table GENPARAM
  DataModuleMain.TransMiseAJour.StartTransaction();
  try
    if not(DataModuleMain.SetGenParam(ParamsConnexion.MagId, 3, 10200, GCONFIGAPP.DestPath)
      and DataModuleMain.SetGenParam(ParamsConnexion.MagId, 3, 10200, (GCONFIGAPP.Jours + 0.0))) then
    begin
      Journaliser(Format(RS_ERR_PARAM_ENREG, [10200]), NivErreur);
      MessageDlg(Format(RS_ERR_PARAM_ENREG, [10200]), mtError, [mbOk], 0);
      DataModuleMain.TransMiseAJour.Rollback();
      Exit;
    end;
  except
    on E: Exception do
    begin
      Journaliser(Format(RS_ERR_PARAM_ENREG_EXC, [10200, E.ClassName, E.Message]), NivErreur);
      MessageDlg(Format(RS_ERR_PARAM_ENREG_EXC, [10200, E.ClassName, E.Message]), mtError, [mbOk], 0);
      DataModuleMain.TransMiseAJour.Rollback();
      Exit;
    end;
  end;

  try
    if not(DataModuleMain.SetGenParam(ParamsConnexion.MagId, 3, 10201, Succ(GCONFIGAPP.Periodicite))) then
    begin
      Journaliser(Format(RS_ERR_PARAM_ENREG, [10201]), NivErreur);
      MessageDlg(Format(RS_ERR_PARAM_ENREG, [10201]), mtError, [mbOk], 0);
      DataModuleMain.TransMiseAJour.Rollback();
      Exit;
    end
    else begin
      case GCONFIGAPP.Periodicite of
        // Si périodicité 1 fois par jour
        0: begin
          if not(DataModuleMain.SetGenParam(ParamsConnexion.MagId, 3, 10201, FormatDateTime('hh:mm', GCONFIGAPP.Heure))
            and DataModuleMain.SetGenParam(ParamsConnexion.MagId, 3, 10201, 0.0)) then
          begin
            Journaliser(Format(RS_ERR_PARAM_ENREG, [10201]), NivErreur);
            MessageDlg(Format(RS_ERR_PARAM_ENREG, [10201]), mtError, [mbOk], 0);
            DataModuleMain.TransMiseAJour.Rollback();
            Exit;
          end;
        end;
        // Si périodicité x fois par jour
        1: begin
          if not(DataModuleMain.SetGenParam(ParamsConnexion.MagId, 3, 10201, '00:00')
            and DataModuleMain.SetGenParam(ParamsConnexion.MagId, 3, 10201, (GCONFIGAPP.Minutes + 0.0))) then
          begin
            Journaliser(Format(RS_ERR_PARAM_ENREG, [10201]), NivErreur);
            MessageDlg(Format(RS_ERR_PARAM_ENREG, [10201]), mtError, [mbOk], 0);
            DataModuleMain.TransMiseAJour.Rollback();
            Exit;
          end;
        end;
      end;
    end;
  except
    on E: Exception do
    begin
      Journaliser(Format(RS_ERR_PARAM_ENREG_EXC, [10201, E.ClassName, E.Message]), NivErreur);
      MessageDlg(Format(RS_ERR_PARAM_ENREG_EXC, [10201, E.ClassName, E.Message]), mtError, [mbOk], 0);
      DataModuleMain.TransMiseAJour.Rollback();
      Exit;
    end;
  end;

  // Enregistrement des paramètres de démarrage auto
  try
    if not(DataModuleMain.SetGenParam(ParamsConnexion.MagId, 3, 10202, Double(TimeOf(GCONFIGAPP.tHeureDemarrage)))
      and DataModuleMain.SetGenParam(ParamsConnexion.MagId, 3, 10202, IfThen(GCONFIGAPP.bDemarrageAuto, 1, 0))) then
    begin
      Journaliser(Format(RS_ERR_PARAM_ENREG, [10202]), NivErreur);
      MessageDlg(Format(RS_ERR_PARAM_ENREG, [10202]), mtError, [mbOk], 0);
      DataModuleMain.TransMiseAJour.Rollback();
      Exit;
    end;
  except
    on E: Exception do
    begin
      Journaliser(Format(RS_ERR_PARAM_ENREG_EXC, [10202, E.ClassName, E.Message]), NivErreur);
      MessageDlg(Format(RS_ERR_PARAM_ENREG_EXC, [10202, E.ClassName, E.Message]), mtError, [mbOk], 0);
      DataModuleMain.TransMiseAJour.Rollback();
      Exit;
    end;
  end;

  // Enregistrement des paramètres d'arrêt auto
  try
    if not(DataModuleMain.SetGenParam(ParamsConnexion.MagId, 3, 10203, Double(TimeOf(GCONFIGAPP.tHeureArret)))
      and DataModuleMain.SetGenParam(ParamsConnexion.MagId, 3, 10203, IfThen(GCONFIGAPP.bArretAuto, 1, 0))) then
    begin
      Journaliser(Format(RS_ERR_PARAM_ENREG, [10203]), NivErreur);
      MessageDlg(Format(RS_ERR_PARAM_ENREG, [10203]), mtError, [mbOk], 0);
      DataModuleMain.TransMiseAJour.Rollback();
      Exit;
    end;
  except
    on E: Exception do
    begin
      Journaliser(Format(RS_ERR_PARAM_ENREG_EXC, [10203, E.ClassName, E.Message]), NivErreur);
      MessageDlg(Format(RS_ERR_PARAM_ENREG_EXC, [10203, E.ClassName, E.Message]), mtError, [mbOk], 0);
      DataModuleMain.TransMiseAJour.Rollback();
      Exit;
    end;
  end;

  // Valide toutes les modifications
  DataModuleMain.TransMiseAJour.Commit();

  // Enregistre le fichier INI
  EnregistreFichierIni();
end;

// Enregistre les paramètres dans l'INI
procedure EnregistreFichierIni();
var
  IniParams: TIniFile;
begin
  // Charge le fichier INI
  IniParams := TIniFile.Create(GINIFILE);
  try
    // Enregistre les paramètres dans le fichier INI
    IniParams.WriteDateTime('PARAM', 'DATEDEBUT', GCONFIGAPP.dPrevAction);
    IniParams.WriteDateTime('PARAM', 'DATEFIN', GCONFIGAPP.dNextAction);
    IniParams.WriteBool('PARAM', 'LogVerbeux', GCONFIGAPP.bLogVerbeux);
  finally
    IniParams.Free();
  end;
end;

// Récupère des informations sur un exécutable
function InfoSurExe(const AFichier: TFileName): TInfoSurExe;
const
  VersionInfo: array [1..8] of String =
    ('FileDescription', 'CompanyName', 'FileVersion',
    'InternalName', 'LegalCopyRight', 'OriginalFileName',
    'ProductName', 'ProductVersion');
var
  Handle:   DWord;
  Info:     Pointer;
  InfoData: Pointer;
  InfoSize: Longint;
  DataLen:  UInt;
  LangPtr:  Pointer;
  InfoType: String;
  i:        Integer;
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

          if VerQueryValue(Info, '\VarFileInfo\Translation',
            LangPtr, DataLen) then
            InfoType := Format('\StringFileInfo\%0.4x%0.4x\%s'#0,
              [LoWord(Longint(LangPtr^)), HiWord(Longint(LangPtr^)),
              InfoType]);

            // Remplit la variable de retour
          if VerQueryValue(Info, @InfoType[1], InfoData, DataLen) then
            case i of
              1: Result.FileDescription  := PChar(InfoData);
              2: Result.CompanyName      := PChar(InfoData);
              3: Result.FileVersion      := PChar(InfoData);
              4: Result.InternalName     := PChar(InfoData);
              5: Result.LegalCopyright   := PChar(InfoData);
              6: Result.OriginalFileName := PChar(InfoData);
              7: Result.ProductName      := PChar(InfoData);
              8: Result.ProductVersion   := PChar(InfoData);
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

function CreerTachePlanifiee(AHeureDebut: TTime): Boolean;
const
  CS_TACHE_CREER      = '/CREATE /TN %s /TR %s /SC DAILY /ST %s';
  CS_TACHE_CREER_XP   = '/CREATE /TN %s /TR %s /SC "Toutes les semaines" /D LUN,MAR,MER,JEU,VEN,SAM,DIM /ST %s /RU "%s" /RP "%s"';
  CS_TACHE_CREER_2003 = '/CREATE /TN %s /TR %s /SC DAILY /ST %s /RU "%s" /RP "%s"';
var
  // Information pour l'exécution du programme
  InfoExecution : TShellExecuteInfo;
  StartupInfo   : TStartupInfo;
  ProcessInfo   : TProcessInformation;
  // Drapeau pour la fin du programme
  bFini         : Boolean;
  // Code de retour du programme
  iCodeRetour   : LongWord;
  // Paramètres du programme
  sParametres   : String;
  // Informations pour l'utilisateur courant
  tUtilisateur  : Array[0..255] Of Char;
  sUtilisateur  : String;
  sMotPasse     : String;
  Taille        : Cardinal;
begin
  Result := False;
  Journaliser(RS_INFO_TACHE_CREER_D);

  // Préparation du lancement du programme
  // -> http://msdn.microsoft.com/library/bb762154
  FillChar(InfoExecution, SizeOf(InfoExecution), #0);
  InfoExecution.cbSize        := SizeOf(InfoExecution);
  InfoExecution.Wnd           := Application.Handle;
  InfoExecution.fMask         := SEE_MASK_NOCLOSEPROCESS;
  InfoExecution.lpVerb        := 'OPEN';
  InfoExecution.lpFile        := 'SCHTASKS.EXE';

  if IsWindowsVista() then
  begin
    sParametres               := Format(CS_TACHE_CREER,
      [AnsiQuotedStr(InfoSurExe(Application.ExeName).ProductName, '"'),
        AnsiQuotedStr(Application.ExeName + ' /AUTO', '"'),
        FormatDateTime('hh:nn:ss', AHeureDebut)]);
  end
  else if IsWindows2003() then
  begin
    sParametres               := Format(CS_TACHE_CREER_2003,
      [AnsiQuotedStr(InfoSurExe(Application.ExeName).ProductName, '"'),
        AnsiQuotedStr(Application.ExeName + ' /AUTO', '"'),
        FormatDateTime('hh:nn:ss', AHeureDebut),
        GCONFIGAPP.sUtilisateur,
        GCONFIGAPP.sMotPasse]);
  end
  else begin
    sParametres               := Format(CS_TACHE_CREER_XP,
      [AnsiQuotedStr(InfoSurExe(Application.ExeName).ProductName, '"'),
        AnsiQuotedStr(Application.ExeName + ' /AUTO', '"'),
        FormatDateTime('hh:nn:ss', AHeureDebut),
        GCONFIGAPP.sUtilisateur,
        GCONFIGAPP.sMotPasse]);
  end;

  if FindCmdLineSwitch('VERBEUX') then
    MessageDlg(sParametres, mtInformation, [mbOk], 0);

  InfoExecution.lpParameters  := PChar(sParametres);
  InfoExecution.nShow         := SW_HIDE;

  // Lancement du programme
  if ShellExecuteEx(@InfoExecution) then
  begin
    bFini := False;
    Application.ProcessMessages();

    // Attente de la fin du programme
    // -> http://msdn.microsoft.com/library/ms687032
    repeat
      Application.ProcessMessages();
    until WaitForSingleObject(ProcessInfo.hThread, 200) <> WAIT_TIMEOUT;

    // Récupère le code de retour
    // -> http://msdn.microsoft.com/library/ms683189
    GetExitCodeProcess(ProcessInfo.hProcess, iCodeRetour);

    Result := iCodeRetour = 0;
  end;

  Journaliser(RS_INFO_TACHE_CREER_F);
end;

// Supprimer la tâche journalière
function SupprimeTachePlanifiee(): Boolean;
const
  CS_TACHE_SUPPRIMER  = '/DELETE /TN %s /F';
var
  // Information pour l'exécution du programme
  InfoExecution: TShellExecuteInfo;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  // Drapeau pour la fin du programme
  bFini: Boolean;
  // Code de retour du programme
  iCodeRetour: LongWord;
  // Paramètres du programme
  sParametres: String;
begin
  Result := False;
  Journaliser(RS_INFO_TACHE_SUPPR_D);

  // Préparation du lancement du programme
  // -> http://msdn.microsoft.com/library/bb762154
  FillChar(InfoExecution, SizeOf(InfoExecution), #0);
  InfoExecution.cbSize        := SizeOf(InfoExecution);
  InfoExecution.Wnd           := Application.Handle;
  InfoExecution.fMask         := SEE_MASK_NOCLOSEPROCESS;
  InfoExecution.lpVerb        := 'OPEN';
  InfoExecution.lpFile        := 'SCHTASKS.EXE';
  sParametres                 := Format(CS_TACHE_SUPPRIMER,
    [AnsiQuotedStr(InfoSurExe(Application.ExeName).ProductName, '"')]);
  InfoExecution.lpParameters  := PChar(sParametres);
  InfoExecution.nShow         := SW_HIDE;

  if FindCmdLineSwitch('VERBEUX') then
    MessageDlg(sParametres, mtInformation, [mbOk], 0);

  // Lancement du programme
  if ShellExecuteEx(@InfoExecution) then
  begin
    bFini := False;
    Application.ProcessMessages();

    // Attente de la fin du programme
    // -> http://msdn.microsoft.com/library/ms687032
    repeat
      Application.ProcessMessages();
    until WaitForSingleObject(InfoExecution.hProcess, 200) <> WAIT_TIMEOUT;

    // Récupère le code de retour
    // -> http://msdn.microsoft.com/library/ms683189
    GetExitCodeProcess(InfoExecution.hProcess, iCodeRetour);

    Result := iCodeRetour = 0;
  end;

  Journaliser(RS_INFO_TACHE_SUPPR_F);
end;

// Créer le démarrage auto
function CreerDemarrageAuto(): Boolean;
var
  // Base de registre
  Registre: TRegistry;
begin
  Journaliser(RS_INFO_DEMAR_CREER_D);

  Result := False;
  Registre := TRegistry.Create();
  try
    Registre.RootKey := HKEY_LOCAL_MACHINE;
    if Registre.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Run', False) then
    begin
      Registre.WriteString(InfoSurExe(Application.ExeName).ProductName, Application.ExeName);
      Result := True;
    end;
  finally
    Registre.Free();
  end;

  Journaliser(RS_INFO_DEMAR_CREER_F);
end;

// Tue un processus via son nom
function KillProcess(const AProcessName: String): Boolean;
var
  ProcessEntry32: TProcessEntry32;
  HSnapShot:      THandle;
  HProcess:       THandle;
begin
  Result := False;

  HSnapShot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if HSnapShot = 0 then
    Exit;

  ProcessEntry32.dwSize := SizeOf(ProcessEntry32);
  if Process32First(HSnapShot, ProcessEntry32) then
  repeat
    if CompareText(ProcessEntry32.szExeFile, AProcessName) = 0 then
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

// Vérifie si l'OS est Windows Vista ou supérieur
function IsWindowsVista(): Boolean;
var
  VerInfo: TOSVersioninfo;
begin
  VerInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
  GetVersionEx(VerInfo);
  Result := VerInfo.dwMajorVersion >= 6;
end;

// Vérifie si l'OS est Windows 2003
function IsWindows2003(): Boolean;
var
  VerInfo: TOSVersioninfo;
begin
  VerInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
  GetVersionEx(VerInfo);
  Result := (VerInfo.dwMajorVersion = 5) and (Win32MinorVersion >= 2);
end;

// Export le contenu d'un DataSet dans un fichier DSV
procedure ExportDataSetToDVS(ADataSet: TDataSet; const AFichier: TFileName;
  const ATxtMsg: string; const ADelimiter: Char = ';');
var
  fChamp    : TField;
  slLigne   : TStringList;
  bActive   : Boolean;
  twFichier : TTextWriter;
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
          ADataSet.GetFieldNames(slLigne);
          slLigne.Delimiter           := ADelimiter;
          slLigne.StrictDelimiter     := True;
          twFichier.WriteLine(slLigne.DelimitedText);
          ADataSet.First();
          while not ADataSet.Eof do
          begin
            slLigne.Clear();
            for fChamp in ADataSet.Fields do
              slLigne.Add(StringReplace(fChamp.Text, sLineBreak, ' ', [rfReplaceAll]));
            twFichier.WriteLine(slLigne.DelimitedText);
            ADataSet.Next();
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

// Import le contenu d'un fichier DSV dans un objet TOblBoCaisse
function ImportBoCaisse(const AFichier: TFileName; var AOblBoCaisse: TOblBoCaisse): Boolean;
var
  slFichier       : TStringList;
  sdaLigne        : TStringDynArray;
  i               : Integer;
  LnBoCaisse      : TBoCaisse;
  AFormatSettings : TFormatSettings;
begin
  Result := False;

  AFormatSettings := TFormatSettings.Create($409);

  // Vide la mémoire
  AOblBoCaisse.Clear();
  
  if FileExists(AFichier) then
  begin
    // Charge le fichier en mémoire 
    slFichier   := TStringList.Create();
    try
      slFichier.LoadFromFile(AFichier);
      AOblBoCaisse.Clear();

      // Récupère toutes les lignes du fichier
      for i := 0 to slFichier.Count - 1 do
      begin
        LnBoCaisse  := TBoCaisse.Create();
        sdaLigne := SplitString(slFichier[i], DELIMITER);

        LnBoCaisse.sCodePDV   := sdaLigne[0];
        LnBoCaisse.sDateJour  := sdaLigne[1];
        LnBoCaisse.iNTranche  := StrToInt(sdaLigne[2]);
        LnBoCaisse.iNbTickets := StrToInt(sdaLigne[3]);
        LnBoCaisse.fCA        := StrToCurr(sdaLigne[4], AFormatSettings);
        LnBoCaisse.iNbVendeur := StrToInt(sdaLigne[5]);

        AOblBoCaisse.Add(LnBoCaisse);
      end;

      Result := True;
    finally
      slFichier.Free();
    end;
  end
  else begin
    // Créer le répertoire s'il n'existe pas
    if not(DirectoryExists(ExtractFileDir(AFichier))) then
      ForceDirectories(ExtractFileDir(AFichier));

    Result := True;
  end;
end;

// Exporte un TOblBoCaisse dans un fichier DSV
function ExportBoCaisse(const AFichier: TFileName; const AOblBoCaisse: TOblBoCaisse): Boolean;
var                    
  twFichier       : TTextWriter;
  slLigne         : TStringList;
  LnBoCaisse      : TBoCaisse;
  AFormatSettings : TFormatSettings;
begin
  Result := False;

  AFormatSettings := TFormatSettings.Create($409);

  // Trie la liste par date/tranche
  AOblBoCaisse.Sort(
    TComparer<TBoCaisse>.Construct(
      function (const Ligne1, Ligne2: TBoCaisse): Integer
      begin
        if Ligne1.sDateJour < Ligne2.sDateJour then
        begin
          Result := -1;
        end
        else if Ligne1.sDateJour = Ligne2.sDateJour then
        begin
          if Ligne1.iNTranche < Ligne2.iNTranche then
            Result := -1
          else if Ligne1.iNTranche > Ligne2.iNTranche then
            Result := 1
          else
            Result := 0;
        end
        else if Ligne1.sDateJour > Ligne2.sDateJour then
        begin
          Result := 1;
        end;
      end
    )
  );

  // Créer le répertoire s'il n'existe pas
  if not(DirectoryExists(ExtractFileDir(AFichier))) then
    ForceDirectories(ExtractFileDir(AFichier));

  // Enregistre le fichier sur le disque 
  twFichier := TStreamWriter.Create(AFichier);
  try
    slLigne := TStringList.Create();
    try
      slLigne.Delimiter       := DELIMITER;
      slLigne.StrictDelimiter := True;
    
      for LnBoCaisse in AOblBoCaisse do
      begin
        // Récupère la ligne
        slLigne.Clear();
        slLigne.Add(LnBoCaisse.sCodePDV);
        slLigne.Add(LnBoCaisse.sDateJour);
        slLigne.Add(IntToStr(LnBoCaisse.iNTranche));
        slLigne.Add(IntToStr(LnBoCaisse.iNbTickets));
        slLigne.Add(FormatFloat('0.00', LnBoCaisse.fCA, AFormatSettings));
        slLigne.Add(IntToStr(LnBoCaisse.iNbVendeur));

        twFichier.WriteLine(slLigne.DelimitedText);
      end;

      Result := True;
    finally
      slLigne.Free();
    end;
  finally
    twFichier.Free();
  end;
end;

// Vérifie si une date est bien encodée au format AAAAMMJJ
function TryIso8601BasicToDate(const AStr: String; out ODate: TDateTime): Boolean;
var
  Annee, Mois, Jour: Integer;
begin
  Result := (Length(AStr) = 8);
  if not Result then
    Exit;
  Result := TryStrToInt(Copy(AStr, 1, 4), Annee);
  if Annee < 100 then
  begin
    Result := False;
    Exit;
  end;
  if not Result then
    Exit;
  Result := TryStrToInt(Copy(AStr, 5, 2), Mois);
  if not Result then
    Exit;
  Result := TryStrToInt(Copy(AStr, 7, 2), Jour);
  if not Result then
    Exit;
  Result := TryEncodeDate(Annee, Mois, Jour, ODate);
end;

function CalculTranche(const ADate: TDateTime): Integer;
var
  wHr, wMn, wSec, wMls : Word;
begin
  DecodeTime(ADate, wHr, wMn, wSec, wMls);
  Result := ((wHr * 3600 + wMn * 60 + wSec) div (15 * 60)) + 1;
end;

function CalculPeriode(ADate: TDateTime; const ATranche: Integer): TPeriodeTranche;
var
  iCalcul, iReste : Integer;
  wHr, wMn, wSec  : Word;
  dDateTemp       : TDateTime;
begin
  iCalcul := ATranche * 15 * 60;
  wHr     := iCalcul div 3600;
  iReste  := iCalcul mod 3600;
  wMn     := iReste div 60;
  wSec    := iReste mod 60;
  if wHr = 24 then
  begin
    ADate := IncDay(ADate);
    wHr   := 0;
  end;
  dDateTemp         := EncodeDateTime(YearOf(ADate), MonthOf(ADate), DayOf(ADate), wHr, wMn, wSec, 0);
  Result.dDateFin   := IncSecond(dDateTemp, -1);
  Result.dDateDebut := IncMinute(dDateTemp, -15);
end;

function CalculProchDate(const ADate: TDateTime): TDateTime;
begin
  Result := ADate;

  repeat
    Result := IncMinute(Result, GCONFIGAPP.Minutes);
  until (Result > Now());
end;

end.

