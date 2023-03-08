unit GKEasyComptage.Methodes;

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
  System.UITypes,
  Winapi.ShellAPI,
  Winapi.Windows,
  Winapi.TlHelp32,
  Winapi.Messages,
  VCL.Forms,
  VCL.Dialogs,
  Data.DB,
  GKEasyComptage.Ressources,
  MapFiles,
  UMapping, uLog;

Const CstUtilisateur  = 'Bureau';
      CstMotdePasse   = '';

type

  TNiveau             = (NivDetail, NivErreur, NivArret);
  EErreurIBTraitement = class(Exception);

  TConfig = record
    MagId           : Integer;
    CodeAdh         : string;
    DestPath        : String;
    Jours           : Integer;
    dNextAction     : TDateTime;
    tHeureDemarrage : TTime;
    tHeureArret     : TTime;
    Periodicite     : integer; // en minutes
    iType           : integer;  // Normal ou avec le nb articles

    GUID            : string;
    MagCode         : string;
    FtpActif        : Integer;
    FtpUrl          : string;
    FtpLogin        : string;
    FtpMdp          : string;
    FtpDossier      : string;
  end;

  TIntArray = array of Integer;

  TBoCaisse = class
  public
    sCodePDV    : String;
    sDateJour   : String[8];
    iNTranche   : Integer;
    iNbTickets  : Integer;
    fCA         : Currency;
    iNbArticles : Integer;
    iNbVendeurs : Integer;
    aVendeurs   : TIntArray;  // les ID de vendeur
  private
    // procedure Init;
  end;

  TObjList = TObjectList<TBoCaisse>;

  TOblBoCaisse = class
   private
      function TrouveLigne(Astring:string):integer;
   public
      List : TObjList;
      procedure MAJLigne(ADataSet:TDataSet);
   end;

  TParamsConnexion = record
    BaseDonnees : TFileName;
    NomPoste    : string;
    NomBase     : string;
    NomMag      : string;
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
  GCONNEXION      : TParamsConnexion;
  GCONFIGAPP      : TConfig;
  GTESTMODE       : Boolean = False;
  GINIT           : Boolean = False;

function CreerTachePlanifiee(AHeureDebut: TTime): Boolean;
function SupprimeTachePlanifiee(): Boolean;
function CreerDemarrageAuto(): Boolean;
function CheckParams():boolean;

procedure CloseMessageBox(AWnd: HWND; AMsg: UINT; AIDEvent: UINT_PTR;       ATicks: DWORD); stdcall;
procedure Fermeture_Differe(AMessage:string);

// Enregistre des informations dans un fichier
procedure Journaliser(const AMessage: String; const ANiveau: TNiveau = NivDetail);

// Charge chemin base
function ParamsBase(): TParamsConnexion;

// Charge les paramètres
procedure ChargerParametres();

// Enregistre les paramètres
procedure EnregistreParametres();

// Enregistre les paramètres dans l'INI
// procedure EnregistreFichierIni();

// Récupère des informations sur un exécutable
function InfoSurExe(const AFichier: TFileName): TInfoSurExe;

// Tue un processus via son nom
function KillProcess(const AProcessName: String): Boolean;

// Vérifie si l'OS est Windows Vista ou supérieur
function IsWindowsVista(): Boolean;

// Vérifie si l'OS est Windows 2003
function IsWindows2003(): Boolean;

// Export le contenu d'un DataSet dans un fichier DSV
procedure ExportDataSetToDVS(ADataSet: TDataSet; const AFichier: TFileName;
  const ATxtMsg: string; const ADelimiter: Char = ';');

// Vérifie si une date est bien encodée au format AAAAMMJJ
function TryIso8601BasicToDate(const AStr: String; out ODate: TDateTime): Boolean;

function CalculTranche(const ADate: TDateTime): Integer;
function CalculNextAction(): TDateTime;

function IntInArray(Aint:integer;AIntArray:TIntArray):boolean;
Procedure AddIntArray(Var A:TIntArray;Const B:integer);
function Mapping():byte;
procedure RemoveDeadIcons;
function isByteOn(N: byte; bit_position: integer):boolean;
function ErrorMapping(amap:byte):string;


implementation

uses
  GKEasyComptage.DataModule.Main;

function isByteOn(N: byte; bit_position: integer):boolean;
begin
  result := N and (1 shl bit_position) = 1 shl bit_position;
end;


function ErrorMapping(amap:byte):string;
begin
    result:=Format('Mapping en cours (%d) :',[amap]);
    if isByteOn(amap,0) then result:=result + ' Backup ';
    if isByteOn(amap,1) then result:=result + ' LiveUpdate ';
    if isByteOn(amap,2) then result:=result + ' MajAuto ';
    if isByteOn(amap,3) then result:=result + ' Script ';
end;

function Mapping():byte;
begin
    result:=0;
    if (MapGinkoia.Backup) then
    begin
      result:=result+1;
    end;
    if (MapGinkoia.LiveUpdate) then
    begin
      result:=result+2;
    end;
    if (MapGinkoia.MajAuto) then
    begin
      result:=result+4;
    end;
    if (MapGinkoia.Script) then
    begin
      result:=result+8;
    end;
end;

procedure CloseMessageBox(AWnd: HWND; AMsg: UINT; AIDEvent: UINT_PTR; ATicks: DWORD); stdcall;
//var
//  Wnd: HWND;
begin
  KillTimer(AWnd, AIDEvent);
  // active window of the calling thread should be the message box
  {Wnd :=} GetActiveWindow;
  //  Application.Terminate;
  PostQuitMessage(0);
  // if IsWindow(Wnd) then
  //  PostMessage(Wnd, WM_CLOSE, 0, 0);
end;

procedure Fermeture_Differe(AMessage:string);
var
  TimerId: UINT_PTR;
begin
  TimerId := SetTimer(0, 0, 5 * 1000, @CloseMessageBox);
  Application.MessageBox(PChar(AMessage), nil);
  KillTimer(0, TimerId);
end;


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
    Registre.Access := KEY_ALL_ACCESS or KEY_WOW64_64KEY;
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

function IntInArray(Aint:integer;AIntArray:TIntArray):boolean;
var i, nA: integer;
begin
  nA := length(AIntArray);
  result:=false;
  for i := 0 to nA-1 do
    begin
        if (AIntArray[i] = Aint) then
          begin
              result:=true;
              Break;
          end;
    end;
end;


function TOblBoCaisse.TrouveLigne(Astring:string):integer;
var
   i:integer;
   found:boolean;
begin
    result:=-1;
    found:=false;
    i:=0;
    While not(found) and (i<List.Count) do
    begin
      if AString = String(List.Items[i].sDateJour) + '-' + String(IntToStr(List.Items[i].iNTranche)) then
      begin
        result:=i;
        found:=true;
      end;

      inc(i);
    end;
end;

procedure TOblBoCaisse.MAJLigne(ADataSet:TDataSet);
var
//   dDateTime:TDateTime;
    aTranche:integer;
    sDate:string;
    num:integer;
begin
    sDate:=FormatDateTime('yyyymmdd',ADataSet.FieldByName('TKE_DATE').AsDateTime);
    aTranche:=CalculTranche(ADataSet.FieldByName('TKE_DATE').AsDateTime);
    // Il faut trouver le bon N° et faire le modif du record concerné
    //
    num:= TrouveLigne(sDate+'-'+IntTOStr(aTranche));
    if (num>-1) then
      begin
          inc(List.items[num].iNbTickets);
          List.items[num].fCA:=List.items[num].fCA + ADataSet.FieldByName('CA').AsCurrency;
          List.items[num].iNbArticles:=List.items[num].iNbArticles + ADataSet.FieldByName('NBARTICLES').Asinteger;
          If Not(IntInArray(ADataSet.FieldByName('TKE_USRID').Asinteger,List.items[num].aVendeurs))
            then
              begin
                  AddIntArray(List.items[num].aVendeurs,ADataSet.FieldByName('TKE_USRID').Asinteger);
              end;
          List.items[num].iNbVendeurs:= Length(List.items[num].aVendeurs);
      end;
end;

Procedure AddIntArray(Var A:TIntArray;Const B:integer);
var i, nA: integer;
    DejaPresent:Boolean;
begin
  DejaPresent:=False;
  nA := length(A);
  for i := 0 to nA-1 do
    begin
        if (A[i] = B) then
          begin
              DejaPresent:=true;
              Break;
          end;
    end;
  if Not(DejaPresent) then
      begin
          SetLength(A,nA+1);
          A[nA] := B;
      end;
end;


// Enregistre des informations dans un fichier
procedure Journaliser(const AMessage: String; const ANiveau: TNiveau = NivDetail);
var
  sRepertoire, sNomFichier, sNiveau: String;
  slFichierLog: TStringList;
begin
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
      Result.NomMag       := IniParams.ReadString('NOMMAGS',  'MAG0', '');
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
      Result.BaseDonnees  := '';
    finally
      IniParams.Free();
    end;
  end;
end;



// Charge les paramètres
procedure ChargerParametres();
//var
//   Periode   : TPeriodeTranche;
//    iResult   : Integer;
//    sHeure    : string;
//    hHeure    : TDateTime;
begin
  try
    // Charge les données de la table GENPARAM
    GCONFIGAPP.MagId            := DataModuleMain.RecupereMagId(GCONNEXION.NomPoste, GCONNEXION.NomMag);

    if not(DataModuleMain.AModule(GCONFIGAPP.MagId, 'EASYCOMPTAGE')) then
       begin
          Journaliser(RS_ERR_PARAM_MODULE, NivArret);
          Fermeture_Differe(RS_ERR_PARAM_MODULE);
          Application.Terminate();
          Exit;
        end;

    // Vérifie si le magasin a les paramètres
    if not( DataModuleMain.ParametreExiste(GCONFIGAPP.MagId, 3, 10200)
          and DataModuleMain.ParametreExiste(GCONFIGAPP.MagId, 3, 10201)
          and DataModuleMain.ParametreExiste(GCONFIGAPP.MagId, 3, 10202)
          and DataModuleMain.ParametreExiste(GCONFIGAPP.MagId, 3, 10203)
          and DataModuleMain.ParametreExiste(GCONFIGAPP.MagId, 3, 10204)
          and DataModuleMain.ParametreExiste(GCONFIGAPP.MagId, 3, 10205)
          and DataModuleMain.ParametreExiste(GCONFIGAPP.MagId, 3, 10206)
          and DataModuleMain.ParametreExiste(GCONFIGAPP.MagId, 3, 10207)) then
       begin
          Journaliser(Format(RS_ERR_PARAM_BASE, [RS_ERR_PARAM_GENPARAM]), NivArret);
          Fermeture_Differe(RS_ERR_PARAM_BASE);
          Application.Terminate();
          Exit;
       end;

    GCONFIGAPP.CodeAdh := DataModuleMain.CodeAdh(GCONFIGAPP.MagId);
    if GCONFIGAPP.CodeAdh = '' then
    begin
       Journaliser(Format(RS_ERR_REQUETE_CODEADH, [GCONNEXION.NomBase + ' - ' + GCONNEXION.NomMag]), NivArret);
       Application.MessageBox(PChar(Format(RS_ERR_REQUETE_CODEADH, [GCONNEXION.NomBase + ' - ' + GCONNEXION.NomMag])), PChar(Application.Title + ' - erreur'), MB_ICONERROR + MB_OK);
       Fermeture_Differe(RS_ERR_PARAM_BASE);
       Application.Terminate;
       Exit;
    end;

    GCONFIGAPP.DestPath         := DataModuleMain.GetParamString(GCONFIGAPP.MagId, 3, 10200);
    GCONFIGAPP.Jours            := Round(DataModuleMain.GetParamInteger(GCONFIGAPP.MagId, 3, 10200));
    GCONFIGAPP.Periodicite      := Round(DataModuleMain.GetParamFloat(GCONFIGAPP.MagId, 3, 10201));
    GCONFIGAPP.iType            := DataModuleMain.GetParaminteger(GCONFIGAPP.MagId, 3, 10201);
    GCONFIGAPP.tHeureDemarrage  := Frac(DataModuleMain.GetParamFloat(GCONFIGAPP.MagId, 3, 10202));
    GCONFIGAPP.tHeureArret      := Frac(DataModuleMain.GetParamFloat(GCONFIGAPP.MagId, 3, 10203));
    GCONFIGAPP.dNextAction      := CalculNextAction;
    GCONFIGAPP.GUID             := DataModuleMain.RecupereGUID;
    GCONFIGAPP.MagCode          := DataModuleMain.RecupereMagCode(GCONFIGAPP.MagId);
    GCONFIGAPP.FtpActif         := DataModuleMain.GetParaminteger(GCONFIGAPP.MagId, 3, 10204);
    GCONFIGAPP.FtpUrl           := DataModuleMain.GetParamString(GCONFIGAPP.MagId, 3, 10204);
    GCONFIGAPP.FtpLogin         := DataModuleMain.GetParamString(GCONFIGAPP.MagId, 3, 10205);
    GCONFIGAPP.FtpMdp           := DataModuleMain.GetParamString(GCONFIGAPP.MagId, 3, 10206);
    GCONFIGAPP.FtpDossier       := DataModuleMain.GetParamString(GCONFIGAPP.MagId, 3, 10207);
    Journaliser('ChargerParametres : [OK]');
    //--------------------------------------------------------------------------
   except
      on E: Exception do
      begin
         Journaliser('ChargerParametres : [ERREUR]');
      end;
   end;
end;

// Enregistre les paramètres
procedure EnregistreParametres();
begin
  // Enregistre les paramètres dans la table GENPARAM
  DataModuleMain.TransMiseAJour.StartTransaction();
  try
     DataModuleMain.SetGenParam(GCONFIGAPP.MagId, 3, 10200, GCONFIGAPP.DestPath);
     DataModuleMain.SetGenParam(GCONFIGAPP.MagId, 3, 10200, GCONFIGAPP.Jours);
     DataModuleMain.SetGenParam(GCONFIGAPP.MagId, 3, 10201, GCONFIGAPP.Periodicite + 0.0);
     DataModuleMain.SetGenParam(GCONFIGAPP.MagId, 3, 10201, GCONFIGAPP.iType);
     DataModuleMain.SetGenParam(GCONFIGAPP.MagId, 3, 10202, Frac(TimeOf(GCONFIGAPP.tHeureDemarrage)));
     DataModuleMain.SetGenParam(GCONFIGAPP.MagId, 3, 10203, Frac(TimeOf(GCONFIGAPP.tHeureArret)));
     DataModuleMain.SetGenParam(GCONFIGAPP.MagId, 3, 10204, GCONFIGAPP.FtpActif);
     DataModuleMain.SetGenParam(GCONFIGAPP.MagId, 3, 10204, GCONFIGAPP.FtpUrl);
     DataModuleMain.SetGenParam(GCONFIGAPP.MagId, 3, 10205, GCONFIGAPP.FtpLogin);
     DataModuleMain.SetGenParam(GCONFIGAPP.MagId, 3, 10206, GCONFIGAPP.FtpMdp);
     DataModuleMain.SetGenParam(GCONFIGAPP.MagId, 3, 10207, GCONFIGAPP.FtpDossier);
     // Valide toutes les modifications
     DataModuleMain.TransMiseAJour.Commit();
     Journaliser('Enregistrement des parametres dans la base : [OK]');
  except
    on E: Exception do
    begin
      // MessageDlg(E.Message, mtError, [mbOk], 0);
      Journaliser('Enregistrement des parametres dans la base : [ERREUR]');
      DataModuleMain.TransMiseAJour.Rollback();
    end;
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

function CreerTachePlanifiee(AHeureDebut: TTime): Boolean;
const
  CS_TACHE_CREER      = '/CREATE /TN %s /TR %s /SC DAILY /ST %s';
  CS_TACHE_CREER_XP   = '/CREATE /TN %s /TR %s /SC "Toutes les semaines" /D LUN,MAR,MER,JEU,VEN,SAM,DIM /ST %s /RU "%s" /RP "%s"';
  CS_TACHE_CREER_2003 = '/CREATE /TN %s /TR %s /SC DAILY /ST %s /RU "%s" /RP "%s"';
var
  // Information pour l'exécution du programme
  InfoExecution : TShellExecuteInfo;
//  StartupInfo   : TStartupInfo;
  ProcessInfo   : TProcessInformation;
  // Drapeau pour la fin du programme
  bFini         : Boolean;
  // Code de retour du programme
  iCodeRetour   : LongWord;
  // Paramètres du programme
  sParametres   : String;
  // Informations pour l'utilisateur courant
//  tUtilisateur  : Array[0..255] Of Char;
//  sUtilisateur  : String;
//  sMotPasse     : String;
//  Taille        : Cardinal;
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
        CstUtilisateur,
        CstMotdePasse]);
  end
  else begin
    sParametres               := Format(CS_TACHE_CREER_XP,
      [AnsiQuotedStr(InfoSurExe(Application.ExeName).ProductName, '"'),
        AnsiQuotedStr(Application.ExeName + ' /AUTO', '"'),
        FormatDateTime('hh:nn:ss', AHeureDebut),
        CstUtilisateur,
        CstMotdePasse]);
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
//  StartupInfo: TStartupInfo;
//  ProcessInfo: TProcessInformation;
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


function CheckParams():boolean;
begin
    result:=true;
    // Journaliser('CheckParams');
    if ((GCONFIGAPP.Periodicite=0) or (GCONFIGAPP.DestPath='') or (GCONFIGAPP.Jours=0) or
       not(GCONFIGAPP.iType in [0,1])) or (GCONFIGAPP.tHeureDemarrage=0) or (GCONFIGAPP.tHeureArret=0)
       or ((GCONFIGAPP.FtpActif=1) and ((GCONFIGAPP.FtpUrl='') or (GCONFIGAPP.FtpLogin='')
       or (GCONFIGAPP.FtpMdp=''))) then
        begin
           // Journaliser('Mauvais Paramétrages !');
           {
           If (GCONFIGAPP.Periodicite=0) then
            Journaliser(' !! Periodicité = 0');

           If (GCONFIGAPP.DestPath='') then
            Journaliser(' !! DestPath = <vide>');

           If (GCONFIGAPP.Jours=0) then
            Journaliser(' !! Jours = 0');

           if not(GCONFIGAPP.iType in[0,1]) then
             Journaliser(' !! Type = ' + intToStr(GCONFIGAPP.iType));

           If (GCONFIGAPP.tHeureDemarrage=0) then
              Journaliser(' !! Demarrage = ' + TimeToStr(GCONFIGAPP.tHeureDemarrage));

           If (GCONFIGAPP.tHeureArret=0) then
              Journaliser(' !! Arrêt = ' + TimeToStr(GCONFIGAPP.tHeureArret));
           }
           result:=false;
        end;
    if result
      then Journaliser('CheckParams : [OK]')
//      else Journaliser('CheckParams : [Erreur]');
end;

procedure RemoveDeadIcons;
var
  wnd : cardinal;
  rec : TRect;
  w,h : integer;
  x,y : integer;
begin
// find a handle of a tray
wnd := FindWindow('Shell_TrayWnd', nil);
wnd := FindWindowEx(wnd, 0, 'TrayNotifyWnd', nil);
wnd := FindWindowEx(wnd, 0, 'SysPager', nil);
wnd := FindWindowEx(wnd, 0, 'ToolbarWindow32', nil);
// get client rectangle (needed for width and height of tray)
GetClientRect(wnd, rec);
// get size of small icons
w := GetSystemMetrics(sm_cxsmicon);
h := GetSystemMetrics(sm_cysmicon);
// initial y position of mouse - half of height of icon
y := w shr 1;
while y < rec.Bottom do
  begin
  // while y < height of tray
  x := h shr 1; // initial x position of mouse - half of width of icon
  while x < rec.Right do begin // while x < width of tray
    SendMessage(wnd, wm_mousemove, 0, y shl 16 or x); // simulate moving mouse over an icon
    x := x + w; // add width of icon to x position
  end;
  y := y + h; // add height of icon to y position
end;
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

function CalculNextAction: TDateTime;
var toDay:TDate;
    Periode:integer;
begin
  toDay   :=  Floor(Now());
  Result  :=  toDay + Frac(GCONFIGAPP.tHeureDemarrage);   // sécurité renforcée la partie décimale uniquement

  Periode :=  Max(GCONFIGAPP.Periodicite,1);
  // Au moins 1 minute  car si c'est zero ==> Une jolie Boucle infini
  Repeat
    Result := IncMinute(Result, periode);
  until (Result > Now());

  //petit soucis si on dépasse l'heure de fin : il faut repartir avec le lendemain
  if (Result> toDay + frac(GCONFIGAPP.tHeureArret))
    then
      begin
          Result :=  toDay + Frac(GCONFIGAPP.tHeureDemarrage) + 1;
      end;
  // Pour les tests ca déclenche tout de suite
  // Result :=  Now();

end;

end.

