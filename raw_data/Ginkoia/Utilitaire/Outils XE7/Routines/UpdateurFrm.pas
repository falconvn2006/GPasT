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
    // fonction utilitaire
    function WhatTraitementToDo(out ValueParam : string) : EnumTypeTraitement;
    procedure RunApplicationWithParam(FileExe, ParamToAdd : string);
    function WaitApplicationTerminate(AppName : string) : boolean;
    // overload de l'execute !
    procedure Execute(); override;
  public
    constructor Create(DoChangeEtape : TThreadMethod; Progress : TProgressbar = nil; CreateSuspended: Boolean = false); reintroduce;
    // Etapes ?
    property EtapeLibelle : string read FEtapeLibelle;
    // retour ?
    property ReturnValue;
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
    { Déclarations publiques }
    // procedure de maj pour le thread
    procedure UpdateEtape();
    // boite de dialogue
    function MessageDlg(const Msg : string; DlgType : TMsgDlgType; Buttons : TMsgDlgButtons) : Integer;
  end;

procedure VerificationMAJ(CanContinue : boolean = false);

implementation

uses
  Winapi.ShellAPI,
  System.Types,
  System.StrUtils,
  System.UITypes,
  System.Generics.Collections,
  // les miens !
  // fichier a ajouter au projet
  // trouvable dans "C:\Developpement\Ginkoia\UTILITAIRE\Outils XE7\Routines"
  VersionInfo,
  UVersionUtils,
  UDownloadHTML,
  UFileUtils,
  uGetWindowsList,
  ULaunchProcess;

{$R *.dfm}

const
  // URLs
  URL_PATH_OUTILS = 'http://lame2.no-ip.com/MAJ/Outils/';
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

procedure VerificationMAJ(CanContinue : boolean);
var
  Fiche : Tfrm_Updateur;
  Ret : integer;
begin
  try
    Fiche := Tfrm_Updateur.Create(nil);
    Ret := Fiche.ShowModal();
    case Ret of
      mrOk :
        begin
          // ok !!
          // pas de relancement tout est a jour !
        end;
      mrAbort :
        begin
          // annulation ?
          if CanContinue then
          begin
            if Fiche.MessageDlg('Vous avez annuler la mise-à-jour.'#13#10'Voulez-vous continué avec la version non à jour ?', mtError, [mbYes, mbNo]) = mrNo then
              Halt(HALT_VALUE_CANCELED);
          end
          else
            Halt(HALT_VALUE_CANCELED);
        end;
      mrYes :
        begin
          // en cours de traitement !
          Halt(HALT_VALUE_PROCEED);
        end;
      else
        begin
          // erreur !!
          if CanContinue then
          begin
            if Fiche.MessageDlg('Erreur lors de la mise-à-jour.'#13#10'Voulez-vous continué avec la version non à jour ?', mtError, [mbYes, mbNo]) = mrNo then
              Halt(HALT_VALUE_FAILED);
          end
          else
            Halt(HALT_VALUE_FAILED);
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
    FThread := TUpdateThread.Create(UpdateEtape, pb_Progress);
    while WaitForSingleObject(FThread.Handle, 100) = WAIT_TIMEOUT do
      Application.ProcessMessages();
    case FThread.ReturnValue of
      RETURN_VALUE_CANCELED : ModalResult := mrAbort;
      RETURN_VALUE_NOTHING_TODO : ModalResult := mrOK;
      RETURN_VALUE_SUCCESS_ENDED : ModalResult := mrOK;
      RETURN_VALUE_SUCCESS_PROCEED : ModalResult := mrYes;
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

procedure TUpdateThread.RunApplicationWithParam(FileExe, ParamToAdd : string);
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
      strParametres := strParametres + ' ' + Param + '=' + Value;
  end;
  // ajout du paramètre
  strParametres := strParametres + ' ' + ParamToAdd;
  // lancement
  ShellExecute(0, 'open', PWideChar(strFileName), PwideChar(Trim(strParametres)), nil, SW_SHOW);
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
        MessageDlg('Erreur lors de l''attente de la fermeture des process.', mtError, [mbOK], 0);
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
begin
  // initialisation
  ListVersions := nil;
  tmpFilePath := '';
  tmpFileName := '';

  case WhatTraitementToDo(tmpValueParam) of
{$REGION '    ett_DoVerifDownload '}
    ett_DoVerifDownload :
      begin
        // recup des infos de l'exe
        FEtapeLibelle := 'Récupération des iformations de l''application.';
        if Assigned(FDoChangeEtape) then
          Synchronize(FDoChangeEtape);
        InfoExe := ReadFileInfosStruct();

        try
          // recup de la liste des version
          FEtapeLibelle := 'Téléchargement du fichier de version.';
          if Assigned(FDoChangeEtape) then
            Synchronize(FDoChangeEtape);
          if DownloadHTTP(URL_PATH_OUTILS + URL_FILE_VERSION, ListVersions) then
          begin
            // est ce que le logiciel est present ?
            Idx := ListVersions.IndexOfName(InfoExe.OriginalFileName);
            if Idx >= 0 then
            begin
              // verification de la version ?
              FEtapeLibelle := 'Vérification des numéros de version.';
              if Assigned(FDoChangeEtape) then
                Synchronize(FDoChangeEtape);
              if CompareVersion(InfoExe.FileVersion, ListVersions.Values[InfoExe.OriginalFileName]) = LessThanValue then
              begin
                // Fichier temporaire
                FEtapeLibelle := 'Création du fichier temporaire.';
                if Assigned(FDoChangeEtape) then
                  Synchronize(FDoChangeEtape);
                tmpFilePath := GetTempDirectory();
                ForceDirectories(tmpFilePath);
                tmpFileName := tmpFilePath + ExtractFileName(InfoExe.OriginalFileName);
                // téléchargement
                FEtapeLibelle := 'Téléchargement du nouveau fichier.';
                if Assigned(FDoChangeEtape) then
                  Synchronize(FDoChangeEtape);
                if DownloadHTTP(URL_PATH_OUTILS + URL_PATH_PLATFORM + InfoExe.OriginalFileName, tmpFileName, FProgress) then
                begin
                  // téléchargement
                  FEtapeLibelle := 'Lancement de la mise a jour.';
                  if Assigned(FDoChangeEtape) then
                    Synchronize(FDoChangeEtape);
                  RunApplicationWithParam(tmpFileName, PARAM_LAUNCH_AUTOUPDATE + '="' + ParamStr(0) + '"');
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
    ett_DoCopyNewFile :
      begin
        // attendre la fin des application
        FEtapeLibelle := 'Attente de la fermeture de l''application.';
        if Assigned(FDoChangeEtape) then
          Synchronize(FDoChangeEtape);
        if WaitApplicationTerminate(tmpValueParam) then
        begin
          // faire la maj
          FEtapeLibelle := 'Copie du nouveau fichier.';
          if Assigned(FDoChangeEtape) then
            Synchronize(FDoChangeEtape);
          if CopyFile(PWideChar(ParamStr(0)), PWideChar(tmpValueParam), false) then
          begin
            RunApplicationWithParam(tmpValueParam, PARAM_DELETE_AUTOUPDATE + '="' + ParamStr(0) + '"');
            ReturnValue := RETURN_VALUE_SUCCESS_PROCEED;
          end
          else
            ReturnValue := RETURN_VALUE_ERROR_COPY_APPLICATION;
        end
        else
          ReturnValue := RETURN_VALUE_ERROR_WAIT_PROCESS;
      end;
{$ENDREGION}
{$REGION '    ett_DoDeleteTemporary '}
    ett_DoDeleteTemporary :
      begin
        // attendre la fin des application
        FEtapeLibelle := 'Attente de la fermeture de l''application.';
        if Assigned(FDoChangeEtape) then
          Synchronize(FDoChangeEtape);
        if WaitApplicationTerminate(tmpValueParam) then
        begin
          // nettoyage de la maj
          FEtapeLibelle := 'Nettoyage des fichiers temporaires.';
          if Assigned(FDoChangeEtape) then
            Synchronize(FDoChangeEtape);
          if DelTree(ExtractFilePath(tmpValueParam)) then
            ReturnValue := RETURN_VALUE_SUCCESS_ENDED
          else
            ReturnValue := RETURN_VALUE_ERROR_DELTREE;
        end
        else
          ReturnValue := RETURN_VALUE_ERROR_WAIT_PROCESS;
      end;
{$ENDREGION}
  end;
end;

constructor TUpdateThread.Create(DoChangeEtape : TThreadMethod; Progress : TProgressbar; CreateSuspended : Boolean);
begin
  Inherited Create(CreateSuspended);
  FDoChangeEtape := DoChangeEtape;
  FProgress := Progress;
end;

end.
