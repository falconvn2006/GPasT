unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, RzBorder, Buttons, ExtCtrls, ComCtrls,
  Registry, StrUtils, INIFiles, uBackup, IBServices, uThreadProc, uLog, uZipVersion, Spin;

type
  TProgression = record
    nPosition: Integer;
    sEtape: String;
  end;

  TMainForm = class(TForm)
    panBaseLocale: TPanel;
    labSelectBase: TLabel;
    Label1: TLabel;
    btSelectLocalBase: TSpeedButton;
    Bevel: TRzBorder;
    LabelBase: TLabel;
    lbBasIdent: TLabel;
    lbBasNom: TLabel;
    lbVersion: TLabel;
    lbVersionVal: TLabel;
    edBaseLocale: TEdit;
    RichEditLog: TRichEdit;
    panSynchro: TPanel;
    lbTitleSynchro: TLabel;
    lbSyncProgress: TLabel;
    BtnTraitement: TButton;
    pbSynchro: TProgressBar;
    odBaseLocale: TOpenDialog;
    Timer: TTimer;
    PanelDestinationSynchro: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    BtnDestinationSynchro: TSpeedButton;
    EditDestinationSynchro: TEdit;
    SaveDialogSynchro: TSaveDialog;
    SpinEditTolerance: TSpinEdit;
    LabelTolerance: TLabel;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure btSelectLocalBaseClick(Sender: TObject);
    procedure BtnTraitementClick(Sender: TObject);
    procedure BtnDestinationSynchroClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

  private
    _bExecutionAutomatique: Boolean;
    _sCheminRepData, _sCheminGBAK, _sCheminExe: String;
    _nBAS_ID, _nPageSize, _nBufferSize, _nSweep: Integer;
    _Progression: TProgression;

    procedure InitParametres;
    function Traitement: Boolean;
    function MarqueLesTables(const sDataBase: String): Boolean;
    function GetBasID: Integer;
    function GetGenParamInt(const nType, nCode, nPosId: Integer): Integer;
    function VerificationBase(const sDataBase: String): Boolean;
    function GetVersion: String;
//    procedure AjoutLog(const sLigne: String; const bNouveau: Boolean = False);
    procedure MajProgression(const nPosition: Integer; const sEtape: String);
    procedure AffProgression;
    procedure LogOnLog(Sender: TObject; aLogItem: TLogItem);

  public

  end;

const
  GBK = 'SV.gbk';
  GINKCOPY = 'GINKCOPY.IB';

var
  MainForm: TMainForm;

implementation

uses HotSyncDM;

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
var
  Reg: TRegistry;
  sCheminBDD: String;
  FichierINI: TIniFile;
  i: Integer;
  ibServerProperties: TIBServerProperties;
begin
  FichierINI := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'HotSync.ini');
  try
    SpinEditTolerance.Value := FichierINI.ReadInteger('Paramètres', 'Tolérance', 1);
  finally
    FichierINI.Free;
  end;

  _bExecutionAutomatique := False;
  _sCheminRepData := '';
  sCheminBDD := '';

  // Si paramètre base.
  if ParamCount >= 1 then
  begin
    if FileExists(ParamStr(1)) then
    begin
      sCheminBDD := ParamStr(1);
      _bExecutionAutomatique := True;
    end;
  end;

  // Si paramètre répertoire destination.
  if ParamCount >= 2 then
  begin
    if DirectoryExists(ParamStr(2)) then
      _sCheminRepData := IncludeTrailingPathDelimiter(ParamStr(2));
  end;

  // Initialisation des chemins.
  if sCheminBDD = '' then
  begin
    Reg := TRegistry.Create;
    try
      Reg.Access := KEY_READ;
      Reg.RootKey := HKEY_LOCAL_MACHINE;
      if Reg.OpenKey('Software\Algol\Ginkoia', False) then
      begin
        if Reg.ValueExists('Base0') then
        begin
          if DirectoryExists(Reg.ReadString('Base0')) then
            sCheminBDD := Reg.ReadString('Base0');
        end;

        Reg.CloseKey;
      end;
    finally
      Reg.Free;
    end;

    if sCheminBDD <> '' then
    begin
      _sCheminExe := ExtractFileDrive(sCheminBDD);
      if FileExists(_sCheminExe + '\Ginkoia\Ginkoia.exe') then
        _sCheminExe := _sCheminExe + '\Ginkoia\';
    end;
  end;

  if _sCheminExe = '' then
  begin
    if FileExists('C:\Ginkoia\Ginkoia.exe') then
      _sCheminExe := 'C:\Ginkoia\'
    else
    begin
      if FileExists('D:\Ginkoia\Ginkoia.exe') then
        _sCheminExe := 'D:\Ginkoia\';
    end;
  end;

  if sCheminBDD = '' then
  begin
    FichierINI := TIniFile.Create(_sCheminExe + 'Ginkoia.Ini');
    try
      sCheminBDD := FichierINI.ReadString('DATABASE', 'PATH0', '');
      i := 1;
      while(Copy(sCheminBDD, 2, 1) <> ':') and (i < 10) do
      begin
        sCheminBDD := FichierINI.ReadString('DATABASE', 'PATH' + IntToStr(i), '');
        Inc(i);
      end;
    finally
      FichierINI.Free;
    end;
  end;

  edBaseLocale.Text := sCheminBDD;

  ibServerProperties := TIBServerProperties.Create(Self);
  try
    ibServerProperties.ServerName := 'LocalHost';
    ibServerProperties.Options := [Version];
    ibServerProperties.Params.Add('user_name=sysdba');
    ibServerProperties.Params.Add('password=masterkey');
    ibServerProperties.LoginPrompt := False;
    ibServerProperties.Active := True;
    ibServerProperties.FetchVersionInfo;
    ibServerProperties.FetchConfigParams;
    _sCheminGBAK := IncludeTrailingPathDelimiter(ibServerProperties.ConfigParams.BaseLocation) + 'bin\';
  finally
    ibServerProperties.Free;
  end;

  // Initialisation du log.
  Log.App := 'HotSync';
  Log.Inst := '';
  Log.Srv := '';
  Log.Doss := '';
  Log.FileLogFormat := [elDate, elMdl, elRef, elKey, elLevel, elNb, elValue];
  Log.OnLog := LogOnLog;
  Log.Open;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  InitParametres;

  // Si paramètre.
  Timer.Enabled := _bExecutionAutomatique;
end;

procedure TMainForm.InitParametres;
begin
  if edBaseLocale.Text = '' then
    Exit;

  DMHotSync.DataBase.DataBaseName := edBaseLocale.Text;
  try
    DMHotSync.DataBase.Open;
  except
    on E: Exception do
    begin
      Application.MessageBox(PChar('Erreur :  la connexion a échoué !' + #13#10 + E.Message), PChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
      Exit;
    end;
  end;

  // Recherche de BAS_IDENT et BAS_NOM.
  DMHotSync.Query.Close;
  DMHotSync.Query.SQL.Clear;
  DMHotSync.Query.SQL.Add('select BAS_IDENT, BAS_NOM');
  DMHotSync.Query.SQL.Add('from GENBASES');
  DMHotSync.Query.SQL.Add('join K on (K_ID = BAS_ID AND K_ENABLED = 1)');
  DMHotSync.Query.SQL.Add('join GENPARAMBASE on (BAS_IDENT = PAR_STRING)');
  DMHotSync.Query.SQL.Add('where PAR_NOM = ''IDGENERATEUR''');
  try
    DMHotSync.Query.Open;
  except
    on E: Exception do
    begin
      Application.MessageBox(PChar('Erreur :  la recherche de BAS_IDENT et BAS_NOM a échoué !' + #13#10 + E.Message), PChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
      Exit;
    end;
  end;
  if not DMHotSync.Query.IsEmpty then
  begin
    lbBasIdent.Caption := DMHotSync.Query.FieldByName('BAS_IDENT').AsString;
    lbBasNom.Caption := DMHotSync.Query.FieldByName('BAS_NOM').AsString;
  end;

  // Recherche de la version.
  DMHotSync.Query.Close;
  DMHotSync.Query.SQL.Clear;
  DMHotSync.Query.SQL.Add('select VER_VERSION from GENVERSION');
  DMHotSync.Query.SQL.Add('where VER_DATE in (select max(VER_DATE) from GENVERSION)');
  try
    DMHotSync.Query.Open;
  except
    on E: Exception do
    begin
      Application.MessageBox(PChar('Erreur :  la recherche de la version a échoué !' + #13#10 + E.Message), PChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
      Exit;
    end;
  end;
  if not DMHotSync.Query.IsEmpty then
    lbVersionVal.Caption := DMHotSync.Query.FieldByName('VER_VERSION').AsString;

  DMHotSync.DataBase.Close;

  EditDestinationSynchro.Text := ExtractFilePath(edBaseLocale.Text) + 'Synchro\' + GINKCOPY;
end;

procedure TMainForm.TimerTimer(Sender: TObject);
begin
  Timer.Enabled := False;

  // Exécution automatique.
  BtnTraitementClick(Sender);
end;

procedure TMainForm.btSelectLocalBaseClick(Sender: TObject);
begin
  // Sélection d'une nouvelle base.
  if odBaseLocale.Execute then
  begin
    edBaseLocale.Text := odBaseLocale.FileName;
    InitParametres;
  end;
end;

procedure TMainForm.BtnDestinationSynchroClick(Sender: TObject);
var
  bOk: Boolean;
begin
  SaveDialogSynchro.InitialDir := ExtractFilePath(EditDestinationSynchro.Text);
  SaveDialogSynchro.FileName := GINKCOPY;

  bOk := False;
  repeat
    // Sélection d'une base de synchro.
    if SaveDialogSynchro.Execute then
    begin
      // Si fichier source.
      if LowerCase(SaveDialogSynchro.FileName) = LowerCase(edBaseLocale.Text) then
        Application.MessageBox('Attention :  il n''est pas possible d''écraser la base source !', PChar(Caption + ' - message'), MB_ICONEXCLAMATION + MB_OK)
      else if FileExists(SaveDialogSynchro.FileName) then      // Fichier de destination existe déjà.
      begin
        if Application.MessageBox(PChar('Attention :  le fichier de destination existe déjà !' + #13#10 + SaveDialogSynchro.FileName + #13#10 + 'Voulez-vous l''écraser ?'), PChar(Caption + ' - message'), MB_ICONQUESTION + MB_YESNO + MB_DEFBUTTON2) = ID_YES then
        begin
          EditDestinationSynchro.Text := SaveDialogSynchro.FileName;
          bOk := True;
        end;
      end
      else
      begin
        EditDestinationSynchro.Text := SaveDialogSynchro.FileName;
        bOk := True;
      end;
    end
    else      // Annuler.
      bOk := True;
  until(bOk);
end;

procedure TMainForm.BtnTraitementClick(Sender: TObject);
begin
  panBaseLocale.Enabled := False;
  PanelDestinationSynchro.Enabled := False;
  BtnTraitement.Enabled := False;
  try
    RichEditLog.Clear;

    // Traitement.
    TThreadProc.RunInThread(
      procedure
      begin
        Traitement;
      end
    ).whenError(
      procedure(aException: Exception)
      begin
        Log.Log('', 'Traitement', 'Log', aException.Message, logError, True, 0, ltLocal);
      end
    ).RunAndWait;
  finally
    pbSynchro.Position := 0;
    lbSyncProgress.Caption := '';
    panBaseLocale.Enabled := True;
    PanelDestinationSynchro.Enabled := True;
    BtnTraitement.Enabled := True;
  end;
end;

function TMainForm.Traitement: Boolean;
{$REGION 'BtnTraitementClick'}
  procedure Pause(const nDuree: DWORD = 5000);
  var
    nDebut: DWORD;
  begin
    nDebut := GetTickCount;
    while(GetTickCount - nDebut) < nDuree do
    begin
      Application.ProcessMessages;
      Sleep(100);
    end;
  end;

  function GetTailleFichier(const sFichier: String): Int64;
  var
    sr: TSearchrec;
  begin
    Result := 0;
    if FindFirst(sFichier, faAnyFile, sr) = 0 then
      Result := sr.Size;
    FindClose(sr);
  end;
{$ENDREGION}
var
  nTailleBDD, nTailleRestante: Int64;
  sVersionBase: String;
  ZipVersion: TZipVersion;
begin
  Result := True;
  Log.Log('', '', 'Log', 'Début traitement.', logInfo, True, 0, ltLocal);
  MajProgression(5, 'Marquage des tables ...');

  if _sCheminRepData = '' then
    _sCheminRepData := ExtractFilePath(edBaseLocale.Text);

  // Marquage des tables.
  if MarqueLesTables(edBaseLocale.Text) then
  begin
    MajProgression(20, 'Vérifications ...');

    // Vérification de la taille restante.
    nTailleBDD := GetTailleFichier(edBaseLocale.Text);
    nTailleRestante := DiskFree(Ord(edBaseLocale.Text[1]) - Ord('A') + 1);
    if nTailleRestante < (nTailleBDD * 1.5) then
    begin
      Log.Log('', 'Vérifications', 'Log', 'Erreur :  pas suffisament de place pour le Backup (Taille ' + IntToStr(nTailleBDD) + ' - Taille restante ' + IntToStr(nTailleRestante) + ').', logError, True, 0, ltLocal);
      Result := False;
    end
    else
    begin
      Log.Log('', 'Vérifications', 'Log', 'Espace disque suffisant (' + FormatFloat(',##0', nTailleRestante) + ' octets).', logInfo, True, 0, ltLocal);
      MajProgression(25, 'Sauvegarde ...');

      // Sauvegarde.
      if Backup(edBaseLocale.Text, _sCheminRepData + GBK, nil, True) then
      begin
        Log.Log('', 'Sauvegarde', 'Log', 'Fin sauvegarde (ok).', logInfo, True, 0, ltLocal);
        MajProgression(50, 'Restauration ...');

        // Restauration.
        if RestoreGBak(_sCheminGBAK, _sCheminRepData + GINKCOPY, _sCheminRepData + GBK, _nPageSize, _nBufferSize, _nSweep) then
        begin
          Log.Log('', 'Restauration', 'Log', 'Fin restauration (ok).', logInfo, True, 0, ltLocal);
          MajProgression(75, 'Validation nouvelle base ...');

          // Vérification nouvelle base.
          if VerificationBase(_sCheminRepData + GINKCOPY) then
          begin
            // Suppression fichiers inutiles.
            if not DeleteFile(_sCheminRepData + GBK) then
              Log.Log('', 'Validation', 'Log', 'Échec suppression fichier [' + _sCheminRepData + GBK + ']: ' + SysErrorMessage(GetLastError), logError, True, 0, ltLocal);
            if not DeleteFile(_sCheminRepData + 'RestoreLogs.txt') then
              Log.Log('', 'Validation', 'Log', 'Échec suppression fichier [' + _sCheminRepData + 'RestoreLogs.txt]: ' + SysErrorMessage(GetLastError), logError, True, 0, ltLocal);

            sVersionBase := GetVersion;
            if sVersionBase <> '' then
            begin
              Log.Log('', 'Version', 'Log', 'Base v.' + sVersionBase, logInfo, True, 0, ltLocal);
              MajProgression(85, 'Remplacement base de synchro ...');

              if FileExists(EditDestinationSynchro.Text) then
              begin
                if not DeleteFile(EditDestinationSynchro.Text) then
                  Log.Log('', 'Remplacement', 'Log', 'Échec suppression fichier [' + EditDestinationSynchro.Text + ']: ' + SysErrorMessage(GetLastError), logError, True, 0, ltLocal);
              end;

              if not ForceDirectories(ExtractFilePath(EditDestinationSynchro.Text)) then
                Log.Log('', 'Remplacement', 'Log', 'Échec création répertoire [' + ExtractFilePath(EditDestinationSynchro.Text) + ']: ' + SysErrorMessage(GetLastError), logError, True, 0, ltLocal);

              // Remplacement de la base de synchro.
              if MoveFile(PWideChar(_sCheminRepData + GINKCOPY), PWideChar(EditDestinationSynchro.Text)) then
                Log.Log('', 'Remplacement', 'Log', 'Base de synchro remplacée.', logInfo, True, 0, ltLocal)
              else
                Log.Log('', 'Remplacement', 'Log', 'Échec remplacement base de synchro :  ' + SysErrorMessage(GetLastError), logError, True, 0, ltLocal);

              MajProgression(90, 'Archive de version ...');

              // Génération d'une archive de version.
              ZipVersion := TZipVersion.Create;
              try
                ZipVersion.BasePath := _sCheminExe;
                ZipVersion.Version := sVersionBase;
                if ZipVersion.BuildVersion(_sCheminRepData + 'Synchro\Version.zip') then
                begin
                  // Boucle d'attente (thread).
                  while ZipVersion.Status < vsFinished do
                  begin
                    MajProgression(90, 'Archive de version   [ ' + ZipVersion.ExplainStatus(zipVersion.Status) + ' ]');
                    Sleep(20);
                  end;
                end;

                if ZipVersion.Status = vsFinished then
                  Log.Log('', 'Archive de version', 'Log', 'Fin génération archive de version (ok).', logInfo, True, 0, ltLocal)
                else
                  Log.Log('', 'Archive de version', 'Log', 'Échec génération archive de version :  ' + ZipVersion.Error, logError, True, 0, ltLocal);
              finally
                ZipVersion.Free;
              end;
            end
            else
              Log.Log('', 'Version', 'Log', 'Échec recherche version base !', logError, True, 0, ltLocal);

            MajProgression(100, '');
            Log.Log('', '', 'Log', 'Fin traitement.', logInfo, True, 0, ltLocal);
          end
          else      // Erreur validation base.
          begin
            Log.Log('', 'Validation', 'Log', 'Erreur validation :  base mal sauvegardée / restaurée !', logError, True, 0, ltLocal);

            if FileExists(edBaseLocale.Text) then
              DeleteFile(_sCheminRepData + GBK);
          end;
        end
        else      // Échec restauration.
        begin
          Log.Log('', 'Restauration', 'Log', 'Échec de la restauration !', logError, True, 0, ltLocal);

          if FileExists(edBaseLocale.Text) then
          begin
            if FileExists(_sCheminRepData + GBK) then
            begin
              if ForceDirectories(_sCheminRepData + 'Débug') then
              begin
                if FileExists(_sCheminRepData + 'Débug\' + GBK) then
                begin
                  if not DeleteFile(_sCheminRepData + 'Débug\' + GBK) then
                    Log.Log('', 'Restauration', 'Log', 'Échec de suppression du fichier [' + _sCheminRepData + 'Débug\' + GBK + ']: ' + SysErrorMessage(GetLastError), logError, True, 0, ltLocal);
                end;

                // Déplacement du GBK.
                if MoveFile(PWideChar(_sCheminRepData + GBK), PWideChar(_sCheminRepData + 'Débug\' + GBK)) then
                  Log.Log('', 'Restauration', 'Log', 'Fichier [\Débug\' + GBK + '] sauvegardé.', logNotice, True, 0, ltLocal)
                else
                  Log.Log('', 'Restauration', 'Log', 'Échec de déplacement du fichier [' + _sCheminRepData + GBK + ' >> ' + _sCheminRepData + 'Débug\' + GBK + ']: ' + SysErrorMessage(GetLastError), logError, True, 0, ltLocal);
              end
              else
                Log.Log('', 'Restauration', 'Log', 'Échec de création du sous-répertoire [' + _sCheminRepData + 'Débug]: ' + SysErrorMessage(GetLastError), logError, True, 0, ltLocal);
            end;
          end;
        end;
      end
      else      // Échec sauvegarde.
      begin
        Log.Log('', 'Sauvegarde', 'Log', 'Échec du backup !', logError, True, 0, ltLocal);

        if FileExists(edBaseLocale.Text) then
          DeleteFile(_sCheminRepData + GBK);
      end;
    end;
  end;
end;

function TMainForm.MarqueLesTables(const sDataBase: String): Boolean;
var
  nVersionMajeure: Word;
  sNbLignes: String;
  nID: Integer;
begin
  Result := True;
  Log.Log('', 'MarqueLesTables', 'Log', 'Début du marquage des tables ...', logInfo, True, 0, ltLocal);
  try
    DMHotSync.DataBase.Close;

    GetDBVersionMajor(sDatabase, nVersionMajeure);

    DMHotSync.DataBase.DataBaseName := sDataBase;
    try
      DMHotSync.DataBase.Open;
    except
      on E: Exception do
      begin
        Log.Log('', 'MarqueLesTables', 'Log', '   Échec connexion :  ' + E.Message, logError, True, 0, ltLocal);
        Result := False;
      end;
    end;

    // Récupération du paramétrage des bases.
    _nBAS_ID := GetBasID;
    _nPageSize := GetGenParamInt(22, 2, _nBAS_ID);
    _nBufferSize := GetGenParamInt(22, 1, _nBAS_ID);
    _nSweep := GetGenParamInt(22, 3, _nBAS_ID);

    DMHotSync.Transaction.Active := True;

    // Rollback des transactions au cas où un poste distant accède à TMPBACKUPRESTORE.
//    Rollback(_sCheminRepData, sDataBase);

    // Vide table de travail.
    DMHotSync.Query.Close;
    DMHotSync.Query.SQL.Clear;
    if nVersionMajeure > 13 then
      DMHotSync.Query.SQL.Add('delete from TMPBACKUPRESTORE')
    else
      DMHotSync.Query.SQL.Add('delete from TMPSTAT');
    try
      DMHotSync.Query.ExecSQL;
    except
      on E: Exception do
      begin
        Log.Log('', 'MarqueLesTables', 'Log', '   Échec suppression contenu table ' + IfThen(nVersionMajeure > 13, 'TMPBACKUPRESTORE', 'TMPSTAT') + ' :  ' + E.Message, logError, True, 0, ltLocal);
        Result := False;
      end;
    end;
    Log.Log('', 'MarqueLesTables', 'Log', '   Suppression contenu table ' + IfThen(nVersionMajeure > 13, 'TMPBACKUPRESTORE', 'TMPSTAT') + '.', logInfo, True, 0, ltLocal);

    // Marquage des tables.
    nID := 0;
    DMHotSync.QueryTables.Open;
    DMHotSync.QueryTables.First;
    while not DMHotSync.QueryTables.Eof do
    begin
      DMHotSync.Query.Close;
      DMHotSync.Query.SQL.Clear;
      DMHotSync.Query.SQL.Add('select count(*) from ' + DMHotSync.QueryTables.Fields[0].AsString);
      try
        DMHotSync.Query.Open;
      except
        on E: Exception do
        begin
          Log.Log('', 'MarqueLesTables', 'Log', '   Échec recherche table ' + DMHotSync.QueryTables.Fields[0].AsString + ' :  ' + E.Message, logError, True, 0, ltLocal);
          Result := False;
        end;
      end;
      sNbLignes := DMHotSync.Query.Fields[0].AsString;

      DMHotSync.Query.Close;
      DMHotSync.Query.SQL.Clear;
      if nVersionMajeure > 13 then
        DMHotSync.Query.SQL.Add(Format('insert into TMPBACKUPRESTORE (TBR_ID, TBR_FIELDSCOUNT) values(%d, %s)', [nID, sNbLignes]))
      else
        DMHotSync.Query.SQL.Add('insert into TMPSTAT (TMP_ID, TMP_ARTID, TMP_MAGID) values(0, ' + sNbLignes + ', ' + IntToStr(nID) + ')');
      try
        DMHotSync.Query.ExecSQL;
      except
        on E: Exception do
        begin
          Log.Log('', 'MarqueLesTables', 'Log', '   Échec ajout dans table ' + IfThen(nVersionMajeure > 13, 'TMPBACKUPRESTORE', 'TMPSTAT') + ' :  ' + E.Message, logError, True, 0, ltLocal);
          Result := False;
        end;
      end;
      Inc(nID);

      DMHotSync.QueryTables.Next;
    end;

    // Déconnexion.
    try
      DMHotSync.Database.Close;
    except
      on E: Exception do
      begin
        Log.Log('', 'MarqueLesTables', 'Log', '   Erreur déconnexion base :  ' + E.message, logError, True, 0, ltLocal);
        Result := False;
      end;
    end;

    if Result then
      Log.Log('', 'MarqueLesTables', 'Log', 'Fin marquage des tables.', logInfo, True, 0, ltLocal)
    else
      Log.Log('', 'MarqueLesTables', 'Log', 'Échec du marquage des tables !', logError, True, 0, ltLocal);
  except
    on E: Exception do
    begin
      Log.Log('', 'MarqueLesTables', 'Log', E.Message, logError, True, 0, ltLocal);
      Result := False;
    end;
  end;
end;

function TMainForm.GetBasID: Integer;
begin
  Result := 0;

  DMHotSync.Query.Close;
  DMHotSync.Query.SQL.Clear;
  DMHotSync.Query.SQL.Add('select BAS_ID');
  DMHotSync.Query.SQL.Add('from GENBASES join K on K_ID = BAS_ID and K_Enabled = 1');
  DMHotSync.Query.SQL.Add('join GENPARAMBASE on BAS_IDENT = PAR_STRING');
  DMHotSync.Query.SQL.Add('where PAR_NOM = ''IDGENERATEUR''');
  try
    DMHotSync.Query.Open;
  except
    on E: Exception do
    begin
      Log.Log('', 'GetBasID', 'Log', 'Erreur recherche BAS_ID :  ' + E.Message, logError, True, 0, ltLocal);
      Exit;
    end;
  end;
  if not DMHotSync.Query.IsEmpty then
    Result := DMHotSync.Query.FieldByName('BAS_ID').AsInteger;
end;

function TMainForm.GetGenParamInt(const nType, nCode, nPosId: Integer): Integer;
begin
  Result := 0;

  DMHotSync.Query.Close;
  DMHotSync.Query.SQL.Clear;
  DMHotSync.Query.SQL.Add('select PRM_INTEGER');
  DMHotSync.Query.SQL.Add('from GENPARAM join K on K_ID = PRM_ID and K_enabled = 1');
  DMHotSync.Query.SQL.Add('where PRM_TYPE = :PPRMTYPE');
  DMHotSync.Query.SQL.Add('and PRM_CODE = :PPRMCODE');
  DMHotSync.Query.SQL.Add('and PRM_POS = :PPRMPOS');
  try
    DMHotSync.Query.ParamCheck := True;
    DMHotSync.Query.ParamByName('PPRMTYPE').AsInteger := nType;
    DMHotSync.Query.ParamByName('PPRMCODE').AsInteger := nCode;
    DMHotSync.Query.ParamByName('PPRMPOS').AsInteger := nPosId;
    DMHotSync.Query.Open;
  except
    on E: Exception do
    begin
      Log.Log('', 'GetGenParamInt', 'Log', 'Erreur recherche paramètre [' + IntToStr(nType) + ' - ' + IntToStr(nCode) + ' - ' + IntToStr(nPosId) + ']: ' + E.Message, logError, True, 0, ltLocal);
      Exit;
    end;
  end;
  if not DMHotSync.Query.IsEmpty then
    Result := DMHotSync.Query.FieldByName('PRM_INTEGER').AsInteger;
end;

function TMainForm.VerificationBase(const sDataBase: String): Boolean;
var
  nVersionMajeure: Word;
  nID, nNbLignes: Integer;
begin
  Result := True;
  Log.Log('', 'VerificationBase', 'Log', 'Début validation nouvelle base ...', logInfo, True, 0, ltLocal);
  try
    DMHotSync.DataBase.Close;

    GetDBVersionMajor(sDatabase, nVersionMajeure);

    DMHotSync.DataBase.DataBaseName := sDataBase;
    try
      DMHotSync.DataBase.Open;
    except
      on E: Exception do
      begin
        Log.Log('', 'VerificationBase', 'Log', '   Échec connexion :  ' + E.Message, logError, True, 0, ltLocal);
        Result := False;
      end;
    end;

    nID := 0;
    DMHotSync.QueryTables.Open;
    DMHotSync.QueryTables.First;
    while not DMHotSync.QueryTables.Eof do
    begin
      DMHotSync.Query.Close;
      DMHotSync.Query.SQL.Clear;
      DMHotSync.Query.SQL.Add('select count(*) from ' + DMHotSync.QueryTables.Fields[0].AsString);
      try
        DMHotSync.Query.Open;
      except
        on E: Exception do
        begin
          Log.Log('', 'VerificationBase', 'Log', '   Échec recherche table ' + DMHotSync.QueryTables.Fields[0].AsString + ' :  ' + E.Message, logError, True, 0, ltLocal);
          Result := False;
        end;
      end;
      nNbLignes := DMHotSync.Query.Fields[0].AsInteger;

      DMHotSync.Query.Close;
      DMHotSync.Query.SQL.Clear;
      if nVersionMajeure > 13 then
        DMHotSync.Query.SQL.Add(Format('select TBR_FIELDSCOUNT from TMPBACKUPRESTORE where TBR_ID = %d', [nID]))
      else
        DMHotSync.Query.SQL.Add('select TMP_ARTID from TMPSTAT where TMP_ID = 0 and TMP_MAGID = ' + IntToStr(nID));
      try
        DMHotSync.Query.Open;
      except
        on E: Exception do
        begin
          Log.Log('', 'VerificationBase', 'Log', '   Échec recherche paramètre dans ' + IfThen(nVersionMajeure > 13, 'TMPBACKUPRESTORE', 'TMPSTAT') + ' :  ' + E.Message, logError, True, 0, ltLocal);
          Result := False;
        end;
      end;

      // Si moins de lignes.
      if nNbLignes < DMHotSync.Query.Fields[0].AsInteger then
      begin
        Log.Log('', 'VerificationBase', 'Log', '   Table [' + DMHotSync.QueryTables.Fields[0].AsString + '] différence ' + IntToStr(nNbLignes) + ' < ' + DMHotSync.Query.Fields[0].AsString + ' !', logError, True, 0, ltLocal);
        Result := false;
        Break;
      end
      else if(nNbLignes > 0) and (((nNbLignes - DMHotSync.Query.Fields[0].AsInteger) * 100 / nNbLignes) > SpinEditTolerance.Value) then      // Si plus de lignes, au-delà de la tolérance.
      begin
        Log.Log('', 'VerificationBase', 'Log', '   Table [' + DMHotSync.QueryTables.Fields[0].AsString + '] différence ' + IntToStr(nNbLignes) + ' > ' + DMHotSync.Query.Fields[0].AsString + ' !', logError, True, 0, ltLocal);
        Result := false;
        Break;
      end;

      Inc(nID);
      DMHotSync.QueryTables.Next;
    end;

    // Déconnexion.
    try
      DMHotSync.Database.Close;
      Log.Log('', 'VerificationBase', 'Log', 'Nouvelle base validée.', logInfo, True, 0, ltLocal);
    except
      on E: Exception do
      begin
        Log.Log('', 'VerificationBase', 'Log', '   Erreur déconnexion base :  ' + E.message, logError, True, 0, ltLocal);
        Result := False;
      end;
    end;
  except
    on E: Exception do
    begin
      Log.Log('', 'VerificationBase', 'Log', E.message, logError, True, 0, ltLocal);
      Result := False;
    end;
  end;
end;

function TMainForm.GetVersion: String;
begin
  Result := '';

  try
    DMHotSync.DataBase.Open;
  except
    on E: Exception do
    begin
      Log.Log('', 'GetVersion', 'Log', '   Échec connexion :  ' + E.Message, logError, True, 0, ltLocal);
      Exit;
    end;
  end;

  DMHotSync.Query.Close;
  DMHotSync.Query.SQL.Clear;
  DMHotSync.Query.SQL.Add('select VER_VERSION');
  DMHotSync.Query.SQL.Add('from GENVERSION');
  DMHotSync.Query.SQL.Add('order by VER_DATE desc');
  DMHotSync.Query.SQL.Add('rows 1');
  try
    DMHotSync.Query.Open;
  except
    on E: Exception do
    begin
      Log.Log('', 'GetVersion', 'Log', 'Erreur recherche version :  ' + E.Message, logError, True, 0, ltLocal);
      Exit;
    end;
  end;
  if not DMHotSync.Query.IsEmpty then
    Result := DMHotSync.Query.FieldByName('VER_VERSION').AsString;

  DMHotSync.DataBase.Close;
end;

{procedure TMainForm.AjoutLog(const sLigne: String; const bNouveau: Boolean);
var
  F: TextFile;
begin
  AssignFile(F, ExtractFilePath(Application.ExeName) + 'HotSync.log');
  try
    if bNouveau then
      Rewrite(F)
    else
      Append(F);
    Writeln(F, '[' + FormatDateTime('hh:nn:ss:zzz', Now) + ']  ' + sLigne);
  finally
    CloseFile(F);
  end;

  RichEditLog.Lines.Add('[' + FormatDateTime('hh:nn:ss:zzz', Now) + ']  ' + sLigne);
  Application.ProcessMessages;
end; }

procedure TMainForm.MajProgression(const nPosition: Integer; const sEtape: String);
begin
  _Progression.nPosition := nPosition;
  _Progression.sEtape := sEtape;
  TThread.Synchronize(nil, AffProgression);
end;

procedure TMainForm.AffProgression;
begin
  pbSynchro.Position := _Progression.nPosition;
  lbSyncProgress.Caption := _Progression.sEtape;
  Application.ProcessMessages;
end;

procedure TMainForm.LogOnLog(Sender: TObject; aLogItem: TLogItem);
var
  sLigne: String;
begin
  if aLogItem.key = 'Log' then
  begin
    RichEditLog.Lines.BeginUpdate;
    try
      sLigne := Log.FormatLogItem(aLogItem, [elDate, elValue, elLevel]);

      RichEditLog.SelAttributes.Color := LogLevelColor[Ord(aLogItem.lvl)];
      RichEditLog.Lines.Add(sLigne);
    finally
      RichEditLog.Lines.EndUpdate;
    end;

    RichEditLog.SelStart := Length(RichEditLog.Text);
    Application.ProcessMessages;
  end;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
var
  FichierINI: TIniFile;
begin
  FichierINI := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'HotSync.ini');
  try
    FichierINI.WriteInteger('Paramètres', 'Tolérance', SpinEditTolerance.Value);
  finally
    FichierINI.Free;
  end;
end;

end.

