unit UpdateurFrm;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ComCtrls;

const
  WM_LAUNCH_UPDATE = WM_APP + 1;

type
  TUpdateThread = class(TThread)
  type
    EnumTypeTraitement = (ett_DoVerifDownload, ett_DoCopyNewFile, ett_DoDeleteTemporary);
  protected
    FEtapeLibelle : string;
    FDoChangeEtape : TThreadMethod;
    FProgress : TProgressbar;
    FForceMaj : boolean ;
    // fonction utilitaire
    function WhatTraitementToDo(out ValueParam : string) : EnumTypeTraitement;
    procedure RunApplicationWithParam(FileExe, ParamToAdd, Path : string);
    function WaitApplicationTerminate(AppName : string) : boolean;
    // overload de l'execute !
    procedure Execute(); override;
  public
    constructor Create(DoChangeEtape : TThreadMethod; Progress : TProgressbar = nil; aForceMaj : boolean = false ; CreateSuspended : Boolean = false); reintroduce;
    // Etapes ?
    property EtapeLibelle : string read FEtapeLibelle;
    // retour ?
    property ReturnValue;
    property ForceMaj : boolean  read FForceMaj write FForceMaj ;
  end;

type
  Tfrm_Updateur = class(TForm)
    lbl_Etape: TLabel;
    btn_Annuler: TButton;
    pb_Progress: TProgressBar;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);

    procedure btn_AnnulerClick(Sender: TObject);
  private
    { Déclarations privées }
    // thread de maj
    FThread : TUpdateThread;
    // Gestion du message de maj !
    procedure MessageUpdate(var msg : TMessage); message WM_LAUNCH_UPDATE;
  public
    ForceMaj : boolean ;
    { Déclarations publiques }
    // procedure de maj pour le thread
    procedure UpdateEtape();
    // boite de dialogue
    function MessageDlg(const Msg : string; DlgType : TMsgDlgType; Buttons : TMsgDlgButtons) : Integer;
  end;

procedure VerificationMAJ(CanContinue : boolean = false; ShowMessage : boolean = false ; aForceMaj : boolean = false);

implementation

uses
  Winapi.ShellAPI,
  System.Types,
  System.StrUtils,
  System.UITypes,
  System.Generics.Collections,
  // les miens !
  // fichier a ajouter au projet
  // trouvable dans "http://svn.ginkoia.eu/SVN/ginkoia/Librairies/Routines/"
  uVersionInfo,
  uDownloadHTML,
  uFileUtils,
  uGetWindowsList,
  uLaunchProcess;

{$R *.dfm}

const
  // URLs
  URL_PATH_OUTILS = 'http://tools.ginkoia.net/outils/';
{$IFDEF WIN64}
  URL_PATH_PLATFORM = 'Win64/';
{$ELSE IFDEF WIN32}
  URL_PATH_PLATFORM = 'Win32/';
{$ELSE}
  URL_PATH_PLATFORM = '';
{$ENDIF}
  URL_FILE_VERSION = 'versions.txt';
  // Code de retour
  RETURN_VALUE_NOTHING_TODO = 0;
  RETURN_VALUE_SUCCESS_PROCEED = 1;
  RETURN_VALUE_SUCCESS_ENDED = 2;
  RETURN_VALUE_CANCELED = 3;
  RETURN_VALUE_ERROR_DOWNLOAD_VERSIONFILE = 4;
  RETURN_VALUE_ERROR_NO_VERSION_IN_FILE = 5;
  RETURN_VALUE_ERROR_DOWNLOAD_APPLICATION = 6;
  RETURN_VALUE_ERROR_COPY_APPLICATION = 7;
  RETURN_VALUE_ERROR_WAIT_PROCESS = 8;
  RETURN_VALUE_ERROR_DELTREE = 9;
  // code de terminasion du programme
  HALT_VALUE_PROCEED = 9990;
  HALT_VALUE_SUCEED = 9991;
  HALT_VALUE_CANCELED = 9998;
  HALT_VALUE_FAILED = 9999;
  // paramètre a la ligen de commande
  PARAM_LAUNCH_AUTOUPDATE = '__AUTOUPDATE__';
  PARAM_DELETE_AUTOUPDATE = '__DELETEUPDATE__';

ResourceString
  RS_UPDATEUR_MESSAGE_ANNULATION = 'Vous avez annulé la mise-à-jour.';
  RS_UPDATEUR_MESSAGE_ERREUR = 'Erreur lors de la mise-à-jour.';
  RS_UPDATEUR_MESSAGE_CONTINUER = 'Voulez-vous continuer avec la version non à jour ?';
  RS_UPDATEUR_ETAPE_RECUP_INFO = 'Récupération des informations de l''application.';
  RS_UPDATEUR_ETAPE_TELECHARGE_VERSION = 'Téléchargement du fichier de version.';
  RS_UPDATEUR_ETAPE_VERIFICATION_VERSION = 'Vérification des numéros de version.';
  RS_UPDATEUR_ETAPE_CREATION_REPERTOIRE = 'Création du fichier temporaire.';
  RS_UPDATEUR_ETAPE_TELECHARGE_FICHIER = 'Téléchargement du nouveau fichier.';
  RS_UPDATEUR_ETAPE_LANCEMENT_MAJ = 'Lancement de la mise a jour.';
  RS_UPDATEUR_ETAPE_ATTENTE_APPLI = 'Attente de la fermeture de l''application.';
  RS_UPDATEUR_ETAPE_COPIE_FICHIER = 'Copie du nouveau fichier.';
  RS_UPDATEUR_ETAPE_NETTOYAGE = 'Nettoyage des fichiers temporaires.';

procedure VerificationMAJ(CanContinue : boolean; ShowMessage : boolean ; aForceMaj: boolean);
var
  Fiche : Tfrm_Updateur;
  Ret : integer;
begin
  try
    Fiche := Tfrm_Updateur.Create(nil);
    Fiche.ForceMaj := aForceMaj ;

    Ret := Fiche.ShowModal();
    case Ret of
      mrOk :
        begin
          // ok !!
          // pas de relancement tout est a jour !
        end;
      mrYes :
        begin
          // en cours de traitement !
          Halt(HALT_VALUE_PROCEED);
        end;
      mrAbort :
        begin
          // annulation ?
          if CanContinue then
          begin
            if ShowMessage then
            begin
              if Fiche.MessageDlg(RS_UPDATEUR_MESSAGE_ANNULATION + #13#10 + RS_UPDATEUR_MESSAGE_CONTINUER, mtError, [mbYes, mbNo]) = mrNo
                then Halt(HALT_VALUE_CANCELED);
            end ;
          end else begin
            if ShowMessage then
              Fiche.MessageDlg(RS_UPDATEUR_MESSAGE_ANNULATION, mtError, [mbOK]);

            Halt(HALT_VALUE_CANCELED);
          end;
        end;
      else
        begin
          // erreur !!
          if CanContinue then
          begin
            if (ShowMessage) then
            begin
              if Fiche.MessageDlg(RS_UPDATEUR_MESSAGE_ERREUR + #13#10 + RS_UPDATEUR_MESSAGE_CONTINUER, mtError, [mbYes, mbNo]) = mrNo then
                Halt(HALT_VALUE_FAILED);
            end;
          end
          else
          begin
            if ShowMessage then
              Fiche.MessageDlg(RS_UPDATEUR_MESSAGE_ERREUR, mtError, [mbOK]);
            Halt(HALT_VALUE_FAILED);
          end;
        end;
    end;
  finally
    FreeAndNil(Fiche);
  end;
end;

{ Tfrm_Updateur }

procedure Tfrm_Updateur.FormCreate(Sender: TObject);
begin
  FThread := nil;
end;

procedure Tfrm_Updateur.FormShow(Sender: TObject);
begin
  PostMessage(Handle, WM_LAUNCH_UPDATE, 0, 0);
end;

procedure Tfrm_Updateur.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := not Assigned(FThread);
end;

procedure Tfrm_Updateur.FormDestroy(Sender: TObject);
begin
  // eurf
end;

// click du bouton

procedure Tfrm_Updateur.btn_AnnulerClick(Sender: TObject);
begin
  if Assigned(FThread) then
  begin
    FThread.ReturnValue := RETURN_VALUE_CANCELED;
    TerminateThread(FThread.Handle, RETURN_VALUE_CANCELED);
  end
  else
    ModalResult := mrAbort;
end;

// Traitement du message !

procedure Tfrm_Updateur.MessageUpdate(var msg : TMessage);
begin
  try
    FThread := TUpdateThread.Create(UpdateEtape, pb_Progress, ForceMaj);

    while WaitForSingleObject(FThread.Handle, 100) = WAIT_TIMEOUT do
      Application.ProcessMessages();
    case FThread.ReturnValue of
      RETURN_VALUE_CANCELED : ModalResult := mrAbort;
      RETURN_VALUE_NOTHING_TODO : ModalResult := mrOK;
      RETURN_VALUE_SUCCESS_ENDED : ModalResult := mrOK;
      RETURN_VALUE_SUCCESS_PROCEED : ModalResult := mrYes;
      // les erreurs ...
      RETURN_VALUE_ERROR_DOWNLOAD_VERSIONFILE : ModalResult := mrNo;
      RETURN_VALUE_ERROR_NO_VERSION_IN_FILE : ModalResult := mrNo;
      RETURN_VALUE_ERROR_DOWNLOAD_APPLICATION : ModalResult := mrNo;
      RETURN_VALUE_ERROR_COPY_APPLICATION : ModalResult := mrNo;
      RETURN_VALUE_ERROR_WAIT_PROCESS : ModalResult := mrNo;
      RETURN_VALUE_ERROR_DELTREE : ModalResult := mrNo;
      // sinon ...
      else ModalResult := mrNo;
    end;
  finally
    FreeAndNil(FThread);
  end;
end;

// procedure de maj pour le thread

procedure Tfrm_Updateur.UpdateEtape();
begin
  if Assigned(FThread) then
    lbl_Etape.Caption := FThread.EtapeLibelle
  else
    lbl_Etape.Caption := '';
end;

// dialogue

function Tfrm_Updateur.MessageDlg(const Msg : string; DlgType : TMsgDlgType; Buttons : TMsgDlgButtons): Integer;
begin
  with CreateMessageDialog(Msg, DlgType, Buttons) do
    try
      Position := poOwnerFormCenter;
      Result := ShowModal();
    finally
      Free;
    end;
end;

{ TUpdateThread }

function TUpdateThread.WhatTraitementToDo(out ValueParam : string) : EnumTypeTraitement;
var
  i : integer;
  Param, Value : string;
begin
  Result := ett_DoVerifDownload;
  ValueParam := '';

  for i := 1 to ParamCount do
  begin
    if Pos('=', ParamStr(i)) > 0 then
    begin
      Param := Copy(ParamStr(i), 1, Pos('=', ParamStr(i)) -1);
      Value := Copy(ParamStr(i), Pos('=', ParamStr(i)) +1, Length(ParamStr(i)));
    end
    else
    begin
      Param := ParamStr(i);
      Value := '';
    end;

    case IndexText(Param, [PARAM_LAUNCH_AUTOUPDATE, PARAM_DELETE_AUTOUPDATE]) of
      0 :
        begin
          Result := ett_DoCopyNewFile;
          ValueParam := Value;
        end;
      1 :
        begin
          Result := ett_DoDeleteTemporary;
          ValueParam := Value;
        end;
    end;
  end;
end;

procedure TUpdateThread.RunApplicationWithParam(FileExe, ParamToAdd, Path : string);
var
  i : integer;
  Param, Value : string;
  strFileName, strParametres : string;
begin
  // Init
  strFileName := FileExe;
  strParametres := '';
  // construction de la ligne de commande
  for i := 1 to ParamCount do
  begin
    if Pos('=', ParamStr(i)) > 0 then
    begin
      Param := Copy(ParamStr(i), 1, Pos('=', ParamStr(i)) -1);
      Value := Copy(ParamStr(i), Pos('=', ParamStr(i)) +1, Length(ParamStr(i)));
    end
    else
    begin
      Param := ParamStr(i);
      Value := '';
    end;
    // re-écriture du paramètre
    if IndexText(Param, [PARAM_LAUNCH_AUTOUPDATE, PARAM_DELETE_AUTOUPDATE]) < 0 then
    begin
      if Value = '' then
        strParametres := strParametres + ' ' + Param
      else
        strParametres := strParametres + ' ' + Param + '=' + Value;
    end;
  end;
  // ajout du paramètre
  strParametres := strParametres + ' ' + ParamToAdd;
  // lancement
  ShellExecute(0, 'open', PWideChar(strFileName), PwideChar(Trim(strParametres)), PWideChar(Path), SW_SHOW);
end;

function TUpdateThread.WaitApplicationTerminate(AppName : string) : boolean;
var
  i : integer;
  tmpListProcess : TList<TProcessInfo>;
  tmpItemProcess : TProcessInfo;
  tmpProcessID, tmpNextID : DWORD;
begin
  // init
  tmpListProcess := nil;
  // attendre la fin des process
  tmpProcessID := 0;
  repeat
    tmpNextID := 0;
    try
      if GetProcessList(tmpListProcess) = 0 then
      begin
        // retrouve t'on le process envoyer ?
        // déjà fermé j'espere !!
        for i := 0 to tmpListProcess.Count -1 do
        begin
          tmpItemProcess := tmpListProcess[i];
          if Pos(AppName, tmpListProcess[i].cmd) = 1 then
          begin
            if (tmpListProcess[i].PID = tmpProcessID) then
              WaitProcess(tmpListProcess[i].PID)
            else
              tmpNextID := tmpListProcess[i].PID
          end;
        end;
        tmpProcessID := tmpNextID;
      end
      else
      begin
        Result := false;
        Exit;
      end;
    finally
      FreeAndNil(tmpListProcess);
    end;
    Result := (tmpProcessID = 0);
  until tmpProcessID = 0;
end;

procedure TUpdateThread.Execute();
var
  InfoExe : TInfoSurExe;
  ListVersions : TStringList;
  Idx : integer;
  tmpFilePath, tmpFileName, tmpValueParam : string;
  vTraitement : EnumTypeTraitement ;
begin
  // initialisation
  ListVersions := nil;
  tmpFilePath := '';
  tmpFileName := '';

  vTraitement := WhatTraitementToDo(tmpValueParam) ;

{$REGION '    ett_DoDeleteTemporary '}
  if vTraitement = ett_DoDeleteTemporary then
  begin
    // attendre la fin des application
    FEtapeLibelle := RS_UPDATEUR_ETAPE_ATTENTE_APPLI;
    if Assigned(FDoChangeEtape) then
      Synchronize(FDoChangeEtape);
    if WaitApplicationTerminate(tmpValueParam) then
    begin
      Sleep(1000);
      // nettoyage de la maj
      FEtapeLibelle := RS_UPDATEUR_ETAPE_NETTOYAGE;
      if Assigned(FDoChangeEtape) then
        Synchronize(FDoChangeEtape);
      if DelTree(ExtractFilePath(tmpValueParam), 3) then
        ReturnValue := RETURN_VALUE_SUCCESS_ENDED
      else
        ReturnValue := RETURN_VALUE_ERROR_DELTREE;
    end
    else
      ReturnValue := RETURN_VALUE_ERROR_WAIT_PROCESS;

    if FForceMaj
      then vTraitement := ett_DoVerifDownload ;    // Important pour permettre les MAJ suivantes !
  end;
{$ENDREGION}

{$REGION '    ett_DoVerifDownload '}
  if vTraitement = ett_DoVerifDownload then
  begin
    // recup des infos de l'exe
    FEtapeLibelle := RS_UPDATEUR_ETAPE_RECUP_INFO;
    if Assigned(FDoChangeEtape) then
      Synchronize(FDoChangeEtape);
    InfoExe := ReadFileInfosStruct();

    try
      // recup de la liste des version
      FEtapeLibelle := RS_UPDATEUR_ETAPE_TELECHARGE_VERSION;
      if Assigned(FDoChangeEtape) then
        Synchronize(FDoChangeEtape);
      if DownloadHTTP(URL_PATH_OUTILS + URL_FILE_VERSION, ListVersions) then
      begin
        // est ce que le logiciel est present ?
        Idx := ListVersions.IndexOfName(InfoExe.OriginalFileName);
        if Idx >= 0 then
        begin
          // verification de la version ?
          FEtapeLibelle := RS_UPDATEUR_ETAPE_VERIFICATION_VERSION;
          if Assigned(FDoChangeEtape) then
            Synchronize(FDoChangeEtape);
          if CompareVersion(InfoExe.FileVersion, ListVersions.Values[InfoExe.OriginalFileName]) = LessThanValue then
          begin
            // Fichier temporaire
            FEtapeLibelle := RS_UPDATEUR_ETAPE_CREATION_REPERTOIRE;
            if Assigned(FDoChangeEtape) then
              Synchronize(FDoChangeEtape);
            tmpFilePath := GetTempDirectory();
            ForceDirectories(tmpFilePath);
            tmpFileName := tmpFilePath + ExtractFileName(InfoExe.OriginalFileName);
            // téléchargement
            FEtapeLibelle := RS_UPDATEUR_ETAPE_TELECHARGE_FICHIER;
            if Assigned(FDoChangeEtape) then
              Synchronize(FDoChangeEtape);
            if DownloadHTTP(URL_PATH_OUTILS + URL_PATH_PLATFORM + InfoExe.OriginalFileName, tmpFileName, FProgress) then
            begin
              // téléchargement
              FEtapeLibelle := RS_UPDATEUR_ETAPE_LANCEMENT_MAJ;
              if Assigned(FDoChangeEtape) then
                Synchronize(FDoChangeEtape);
              RunApplicationWithParam(tmpFileName, PARAM_LAUNCH_AUTOUPDATE + '="' + ParamStr(0) + '"', ExtractFilePath(ParamStr(0)));
              ReturnValue := RETURN_VALUE_SUCCESS_PROCEED;
            end
            else
              ReturnValue := RETURN_VALUE_ERROR_DOWNLOAD_APPLICATION;
          end
          else
            ReturnValue := RETURN_VALUE_NOTHING_TODO;
        end
        else
          ReturnValue := RETURN_VALUE_ERROR_NO_VERSION_IN_FILE;
      end
      else
        ReturnValue := RETURN_VALUE_ERROR_DOWNLOAD_VERSIONFILE;
    finally
      FreeAndNil(ListVersions);
    end;
  end;
{$ENDREGION}

{$REGION '    ett_DoCopyNewFile '}
  if vTraitement = ett_DoCopyNewFile then
  begin
    // attendre la fin des application
    FEtapeLibelle := RS_UPDATEUR_ETAPE_ATTENTE_APPLI;
    if Assigned(FDoChangeEtape) then
      Synchronize(FDoChangeEtape);
    if WaitApplicationTerminate(tmpValueParam) then
    begin
      // faire la maj
      FEtapeLibelle := RS_UPDATEUR_ETAPE_COPIE_FICHIER;
      if Assigned(FDoChangeEtape) then
        Synchronize(FDoChangeEtape);
      if CopyFile(PWideChar(ParamStr(0)), PWideChar(tmpValueParam), false) then
      begin
        RunApplicationWithParam(tmpValueParam, PARAM_DELETE_AUTOUPDATE + '="' + ParamStr(0) + '"', ExtractFilePath(tmpValueParam));
        ReturnValue := RETURN_VALUE_SUCCESS_PROCEED;
      end
      else
        ReturnValue := RETURN_VALUE_ERROR_COPY_APPLICATION;
    end
    else
      ReturnValue := RETURN_VALUE_ERROR_WAIT_PROCESS;
  end;
{$ENDREGION}
end;

constructor TUpdateThread.Create(DoChangeEtape : TThreadMethod; Progress : TProgressbar; aForceMaj : boolean ; CreateSuspended : Boolean);
begin
  Inherited Create(CreateSuspended);
  FDoChangeEtape := DoChangeEtape;
  FProgress := Progress;
  FForceMaj := aForceMaj ;
end;

end.
