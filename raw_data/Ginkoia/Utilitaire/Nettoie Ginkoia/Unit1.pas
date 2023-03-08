unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, ExtCtrls, Buttons, StrUtils, INIFiles, ShellAPI, DateUtils, uSevenZip, Menus,
  Gin.Com.ThreadProc;

type
  TRepertoire = (rBatch, rExtract);
  TNiveau = (Annee, Mois, Jour);

  TMainForm = class(TForm)
    GroupBoxSousRepertoires: TGroupBox;
    PanelLogs: TPanel;
    Label4: TLabel;
    SpinEditNbJoursLogs: TSpinEdit;
    PanelLog: TPanel;
    Label6: TLabel;
    Label7: TLabel;
    SpinEditNbJoursNonZippeLog: TSpinEdit;
    SpinEditNbJoursTotalLog: TSpinEdit;
    PanelBatch: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    SpinEditNbJoursNonZippeBatch: TSpinEdit;
    SpinEditNbJoursTotalBatch: TSpinEdit;
    PanelExtract: TPanel;
    Label5: TLabel;
    Label8: TLabel;
    SpinEditNbJoursNonZippeExtract: TSpinEdit;
    SpinEditNbJoursTotalExtract: TSpinEdit;
    Label3: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    PanelTauxCompression: TPanel;
    Label12: TLabel;
    SpinEditTauxCompression: TSpinEdit;
    BtnTraitement: TBitBtn;
    LabelRepertoire: TLabel;
    LabelSousRepertoire: TLabel;
    LabelEtape: TLabel;
    SpinEditDureeMaxTraitement: TSpinEdit;
    Label13: TLabel;
    TrayIcon: TTrayIcon;
    PopupMenu: TPopupMenu;
    Afficher1: TMenuItem;
    TimerModeClassique: TTimer;
    TimerModeChangementDeParc: TTimer;
    BtnArreterTraitement: TBitBtn;
    Panel1: TPanel;
    Label14: TLabel;
    SpinEditNbJoursDatalog: TSpinEdit;
    Label15: TLabel;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerModeClassiqueTimer(Sender: TObject);
    procedure TimerModeChangementDeParcTimer(Sender: TObject);
    procedure BtnTraitementClick(Sender: TObject);
    procedure BtnArreterTraitementClick(Sender: TObject);
    procedure Afficher1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

  private
    _bDemarrageAutomatique, _bArreterTraitement: Boolean;
    _nNbJoursBatch, _nNbJoursExtract, _nNbJoursLog, _nNbJoursLogs: Integer;
    _sRepertoireDestinationZip: String;
    _DateDerniereExecution: TDate;
    _nDebutTraitement: Cardinal;

    procedure GestionParametreRepertoireDestination(const sParametre: String);
    function DureeMaxTraitementDepassee: Boolean;

    // Mode classique.
    procedure TraitementClassique;
    procedure RechercheSousRepertoire(const sRepertoire: String);
    function GetSousRepertoireEAI(const sRepertoire: String): String;
    function RepertoireVide(const sRepertoire: String): Boolean;
    procedure TraitementSousRepertoireDonnes(const sRepertoire: String; const Repertoire: TRepertoire; const Niveau: TNiveau = Annee; const nAnnee: Integer = 0; const nMois: Integer = 0);
    procedure TraitementSousRepertoireDatalog(const sRepertoire: String; const Niveau: TNiveau = Annee; const nAnnee: Integer = 0; const nMois: Integer = 0);
    procedure TraitementSousRepertoireLog(const sRepertoire: String);
    procedure TraitementSousRepertoireLogs(const sRepertoire: String);
    // Mode changement de parc.
    procedure TraitementChangementDeParc(const bBackup, bSynchro: Boolean);
    procedure RechercheSousRepertoireCdP(const sRepertoire: String);
    procedure TraitementSousRepertoireDonnesCdP(const sRepertoire: String; const Repertoire: TRepertoire; const Niveau: TNiveau = Annee; const nAnnee: Integer = 0; const nMois: Integer = 0);
    procedure TraitementSousRepertoireDatalogCdP(const sRepertoire: String; const Niveau: TNiveau = Annee; const nAnnee: Integer = 0; const nMois: Integer = 0);
    procedure TraitementSousRepertoireLogCdP(const sRepertoire: String);
    procedure TraitementSousRepertoireLogsCdP(const sRepertoire: String);
    procedure SupprimerContenuRepertoire(const sRepertoire: String);

    procedure GetListeFichiers(const sRepertoire: String; out sListeFichier: String);
    function Compresser(const sRepertoire: String): Boolean;
    function SupprimerRepertoire(const sRepertoire: String): Boolean;
    procedure AjoutLog(const sLigne: String; const bNouveau: Boolean = False);

  public

  end;

const
  DERNIERE_EXECUTION_MEME_JOUR = -2;
  ERREUR_REPERTOIRE_INEXISTANT = -3;
  ERREUR_COMPRESSION_REPERTOIRE = -4;
  ERREUR_SUPPRESSION_REPERTOIRE = -5;
  ERREUR_SUPPRESSION_FICHIER_COMPRESSE = -6;
  ERREUR_NOM_REPERTOIRE_JOUR = -7;
  ERREUR_SUPPRESSION_FICHIER_LOGS = -8;
  ERREUR_SUPPRESSION_FICHIER = -9;
  ERREUR_CREATION_SOUS_REPERTOIRES = -10;
  ERREUR_DEPLACEMENT_FICHIER_COMPRESSE = -11;
var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
{$REGION 'FormCreate'}
  function VersionApplication: String;
  var
    VerInfoSize, Dummy: DWord;
    VerInfo: Pointer;
    VerValueSize: DWord;
    VerValue: PVSFixedFileInfo;
  begin
    Result := '';
    VerInfoSize := GetFileVersionInfoSize(PChar(ParamStr(0)), Dummy);
    if VerInfoSize <> 0 then
    begin
      GetMem(VerInfo, VerInfoSize + 1);
      GetFileVersionInfo(PChar(ParamStr(0)), 0, VerInfoSize, VerInfo);
      VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
      with VerValue^ do
      begin
        Result := IntTostr(dwFileVersionMS shr 16);
        Result := Result + '.' + IntTostr(dwFileVersionMS and $FFFF);
        Result := Result + '.' + IntTostr(dwFileVersionLS shr 16);
        Result := Result + '.' + IntTostr(dwFileVersionLS and $FFFF);
      end;
      FreeMem(VerInfo, VerInfoSize);
    end;
  end;
{$ENDREGION}
var
  FichierINI: TIniFile;
begin
  Caption := Caption + '  -  ' + VersionApplication;
  _bDemarrageAutomatique := False;      _bArreterTraitement := False;
  LabelRepertoire.Caption := '';

  // Chargement des paramètres.
  FichierINI := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'NettoieGinkoia.ini');
  try
    SpinEditNbJoursNonZippeBatch.Value := FichierINI.ReadInteger('Mode classique', 'Nombre de jours non zippé BATCH', 15);
    SpinEditNbJoursTotalBatch.Value := FichierINI.ReadInteger('Mode classique', 'Nombre de jours total BATCH', 180);
    SpinEditNbJoursNonZippeExtract.Value := FichierINI.ReadInteger('Mode classique', 'Nombre de jours non zippé EXTRACT', 15);
    SpinEditNbJoursTotalExtract.Value := FichierINI.ReadInteger('Mode classique', 'Nombre de jours total EXTRACT', 180);
    SpinEditNbJoursNonZippeLog.Value := FichierINI.ReadInteger('Mode classique', 'Nombre de jours non zippé LOG', 15);
    SpinEditNbJoursTotalLog.Value := FichierINI.ReadInteger('Mode classique', 'Nombre de jours total LOG', 180);
    SpinEditNbJoursLogs.Value := FichierINI.ReadInteger('Mode classique', 'Nombre de jours LOGS', 30);
    _nNbJoursBatch := FichierINI.ReadInteger('Mode changement de parc', 'Nombre de jours BATCH', 180);
    _nNbJoursExtract := FichierINI.ReadInteger('Mode changement de parc', 'Nombre de jours EXTRACT', 180);
    _nNbJoursLog := FichierINI.ReadInteger('Mode changement de parc', 'Nombre de jours LOG', 180);
    _nNbJoursLogs := FichierINI.ReadInteger('Mode changement de parc', 'Nombre de jours LOGS', 30);
    SpinEditTauxCompression.Value := FichierINI.ReadInteger('Paramètres', 'Taux de compression', 1);
    SpinEditDureeMaxTraitement.Value := FichierINI.ReadInteger('Paramètres', 'Durée max traitement', 3000);
    _DateDerniereExecution := FichierINI.ReadDate('Paramètres', 'Dernière exécution', IncDay(Date, -1));
  finally
    FichierINI.Free;
  end;

  AjoutLog('', True);
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  // Si démarrage automatique en mode classique.
  if(ParamCount >= 1) and (UpperCase(ParamStr(1)) = '/AUTO') and (not _bDemarrageAutomatique) then
    TimerModeClassique.Enabled := True;

  // Si démarrage automatique en mode changement de parc.
  if(ParamCount >= 1) and (UpperCase(ParamStr(1)) = '/CHANGEPARC') and (not _bDemarrageAutomatique) then
    TimerModeChangementDeParc.Enabled := True;
end;

procedure TMainForm.TimerModeClassiqueTimer(Sender: TObject);
begin
  TimerModeClassique.Enabled := False;
  _bDemarrageAutomatique := True;
  Hide;

  _sRepertoireDestinationZip := '';
  if ParamCount >= 2 then
  begin
    if UpperCase(LeftStr(ParamStr(2), 3)) = '/MV' then
      GestionParametreRepertoireDestination(ParamStr(2));
  end;

  // Traitement automatique.
  Try
    Try
      TraitementClassique;
    except
      Application.Terminate;
    end;
  Finally
    Application.Terminate;
  End;
end;

procedure TMainForm.GestionParametreRepertoireDestination(const sParametre: String);
begin
  _sRepertoireDestinationZip := IncludeTrailingPathDelimiter(StringReplace(Copy(sParametre, 4, Length(sParametre)), '"', '', [rfReplaceAll]));

  if not DirectoryExists(_sRepertoireDestinationZip) then
  begin
    AjoutLog('>> Erreur :  le répertoire de destination [' + _sRepertoireDestinationZip + '] n''existe pas !');
    _sRepertoireDestinationZip := '';
  end;
end;

procedure TMainForm.TimerModeChangementDeParcTimer(Sender: TObject);
var
  bBackup, bSynchro: Boolean;
begin
  TimerModeChangementDeParc.Enabled := False;
  _bDemarrageAutomatique := True;
  Hide;

  bBackup := False;      bSynchro := False;      _sRepertoireDestinationZip := '';
  if ParamCount >= 2 then
  begin
    if UpperCase(ParamStr(2)) = '/SUPB' then
      bBackup := True
    else if UpperCase(ParamStr(2)) = '/SUPS' then
      bSynchro := True
    else if UpperCase(LeftStr(ParamStr(2), 3)) = '/MV' then
      GestionParametreRepertoireDestination(ParamStr(2));
  end;
  if ParamCount >= 3 then
  begin
    if UpperCase(ParamStr(3)) = '/SUPB' then
      bBackup := True
    else if UpperCase(ParamStr(3)) = '/SUPS' then
      bSynchro := True
    else if UpperCase(LeftStr(ParamStr(3), 3)) = '/MV' then
      GestionParametreRepertoireDestination(ParamStr(3));
  end;
  if ParamCount >= 4 then
  begin
    if UpperCase(LeftStr(ParamStr(4), 3)) = '/MV' then
      GestionParametreRepertoireDestination(ParamStr(4));
  end;

  // Traitement automatique.
  TraitementChangementDeParc(bBackup, bSynchro);
  Application.Terminate;
end;

function TMainForm.DureeMaxTraitementDepassee: Boolean;
var
  vDureeMax: Integer;
begin
  vDureeMax := SpinEditDureeMaxTraitement.Value;

  if (vDureeMax > 7200) and (_bDemarrageAutomatique) then // si le temps est supérieur à 2h, on laisse max 2h en mode automatique
    vDureeMax := 7200;

  Result := (((GetTickCount - _nDebutTraitement) div 1000) > Cardinal(vDureeMax - 1));
  if Result then
    AjoutLog('#>> Durée maximum de traitement dépassée [' + IntToStr(vDureeMax) + ']');
end;

procedure TMainForm.BtnTraitementClick(Sender: TObject);
begin
  // Mode classique.
  TraitementClassique;
end;

procedure TMainForm.BtnArreterTraitementClick(Sender: TObject);
begin
  _bArreterTraitement := True;
  AjoutLog('# Traitement interrompu.');
  LabelRepertoire.Caption := '# Le traitement va s''interrompre ...';
  BtnArreterTraitement.Enabled := False;
  Application.ProcessMessages;
end;

procedure TMainForm.TraitementClassique;
var
  FichierINI: TIniFile;
  vAppPath: String;
begin
  BtnTraitement.Hide;      BtnArreterTraitement.Show;      BtnArreterTraitement.Enabled := True;
  GroupBoxSousRepertoires.Enabled := False;
  LabelRepertoire.Caption := '';      LabelSousRepertoire.Show;      LabelEtape.Show;
  _bArreterTraitement := False;
  Screen.Cursor := crHourGlass;
  try
    AjoutLog('Début traitement (MODE CLASSIQUE).');
    ExitCode := 0;

    // Si même jour que dernière exécution.
    if CompareDate(_DateDerniereExecution, Now) = 0 then
    begin
      ExitCode := DERNIERE_EXECUTION_MEME_JOUR;
      AjoutLog('>> La dernière exécution date du même jour !');
    end
    else
    begin
      _nDebutTraitement := GetTickCount;
      LabelRepertoire.Caption := 'Traitement répertoire [ \GINKOIA\EAI\ ] ...';
      Application.ProcessMessages;

      // Si le répertoire existe.
      vAppPath := IncludeTrailingPathDelimiter(ExtractFileDir(Application.ExeName));
      if DirectoryExists(vAppPath + 'EAI\') then
      begin
        // Mode classique (\GINKOIA\EAI\).
        RechercheSousRepertoire(vAppPath + 'EAI\');
      end
      else
      begin
        ExitCode := ERREUR_REPERTOIRE_INEXISTANT;
        AjoutLog('>> Erreur :  le répertoire [\GINKOIA\EAI\] n''existe pas !');
      end;

      AjoutLog('Fin traitement.');
    end;

    FichierINI := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'NettoieGinkoia.ini');
    try
      FichierINI.WriteDate('Paramètres', 'Dernière exécution', Date);
    finally
      FichierINI.Free;
    end;
  finally
    Screen.Cursor := crDefault;
    LabelRepertoire.Caption := IfThen(ExitCode = DERNIERE_EXECUTION_MEME_JOUR, 'Dernier traitement le même jour !', 'Traitement terminé.');      LabelSousRepertoire.Hide;      LabelEtape.Hide;
    BtnTraitement.Show;      BtnArreterTraitement.Hide;      BtnArreterTraitement.Enabled := True;
    GroupBoxSousRepertoires.Enabled := True;
  end;
end;

procedure TMainForm.RechercheSousRepertoire(const sRepertoire: String);
var
  sr: TSearchRec;
  i: Integer;
begin
  i := 0;

  if FindFirst(IncludeTrailingPathDelimiter(sRepertoire) + '*.*', faAnyFile, sr) = 0 then
  begin
    repeat
      if(_bArreterTraitement) or (DureeMaxTraitementDepassee) then
        Exit;

      // Si répertoire.
      if((sr.Attr and faDirectory) = faDirectory) and (sr.Name <> '.') and (sr.Name <> '..') then
      begin
        if UpperCase(sr.Name) = 'BATCH' then
          TraitementSousRepertoireDonnes(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name, rBatch)
        else if UpperCase(sr.Name) = 'DATALOG' then
          TraitementSousRepertoireDatalog(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name)
        else if UpperCase(sr.Name) = 'EXTRACT' then
          TraitementSousRepertoireDonnes(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name, rExtract)
        else if UpperCase(sr.Name) = 'LOG' then
          TraitementSousRepertoireLog(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name)
        else if UpperCase(sr.Name) = 'LOGS' then
          TraitementSousRepertoireLogs(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name)
        else
          RechercheSousRepertoire(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name);
      end;
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;
end;

function TMainForm.GetSousRepertoireEAI(const sRepertoire: String): String;
var
  nIndex: Integer;
begin
  Result := sRepertoire;
  nIndex := Pos('EAI\', sRepertoire);
  if nIndex > 0 then
    Result := Copy(sRepertoire, nIndex, Length(sRepertoire));
end;

function TMainForm.RepertoireVide(const sRepertoire: String): Boolean;
var
  sr: TSearchRec;
begin
  Result := True;
  if FindFirst(IncludeTrailingPathDelimiter(sRepertoire) + '*.*', faAnyFile, sr) = 0 then
  begin
    repeat
      if(sr.Name <> '.') and (sr.Name <> '..') then
      begin
        Result := False;
        Break;
      end;
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;
end;

procedure TMainForm.TraitementSousRepertoireDonnes(const sRepertoire: String; const Repertoire: TRepertoire; const Niveau: TNiveau; const nAnnee, nMois: Integer);
var
  sr: TSearchRec;
  nTmp, nNbJours: Integer;
  DateRepertoire: TDateTime;
begin
  if Niveau = Annee then
    AjoutLog('Traitement sous-répertoire [' + sRepertoire + ']');
  LabelSousRepertoire.Caption := '[ ' + GetSousRepertoireEAI(sRepertoire) + ' ]';
  Application.ProcessMessages;
  nNbJours := 0;

  if FindFirst(IncludeTrailingPathDelimiter(sRepertoire) + '*.*', faAnyFile, sr) = 0 then
  begin
    repeat
      if(_bArreterTraitement) or (DureeMaxTraitementDepassee) then
        Exit;

      if(sr.Name <> '.') and (sr.Name <> '..') then
      begin
        // Si répertoire.
        if(sr.Attr and faDirectory) = faDirectory then
        begin
          case Niveau of
            Annee:
              begin
                if TryStrToInt(sr.Name, nTmp) then
                begin
                  TraitementSousRepertoireDonnes(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name, Repertoire, Mois, nTmp);

                  // Si répertoire 'année' vide.
                  if RepertoireVide(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name) then
                  begin
                    if RemoveDir(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name) then
                      AjoutLog('>> Répertoire année [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] supprimé.')
                    else
                    begin
                      ExitCode := ERREUR_SUPPRESSION_REPERTOIRE;
                      AjoutLog('>> Échec suppression répertoire année [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] !');
                    end;
                  end;
                end
                else
                  AjoutLog('>> Erreur nom répertoire année [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] !');
              end;

            Mois:
              begin
                if TryStrToInt(sr.Name, nTmp) then
                begin
                  TraitementSousRepertoireDonnes(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name, Repertoire, Jour, nAnnee, nTmp);

                  // Si répertoire 'mois' vide.
                  if RepertoireVide(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name) then
                  begin
                    if RemoveDir(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name) then
                      AjoutLog('>> Répertoire mois [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] supprimé.')
                    else
                    begin
                      ExitCode := ERREUR_SUPPRESSION_REPERTOIRE;
                      AjoutLog('>> Échec suppression répertoire mois [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] !');
                    end;
                  end;
                end
                else
                  AjoutLog('>> Erreur nom répertoire mois [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] !');
              end;

            Jour:
              begin
                if TryStrToInt(sr.Name, nTmp) then
                begin
                  DateRepertoire := EncodeDate(nAnnee, nMois, nTmp);
                  if Repertoire = rBatch then
                    nNbJours := SpinEditNbJoursTotalBatch.Value
                  else if Repertoire = rExtract then
                    nNbJours := SpinEditNbJoursTotalExtract.Value;

                  // Si date répertoire antérieure au nombre de jours total de conservation.
                  if CompareDateTime(IncDay(DateRepertoire, nNbJours), Now) = -1 then
                  begin
                    // Suppression du répertoire.
                    if SupprimerRepertoire(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name) then
                      AjoutLog('>> Répertoire [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] supprimé.')
                    else
                    begin
                      ExitCode := ERREUR_SUPPRESSION_REPERTOIRE;
                      AjoutLog('>> Échec suppression répertoire [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] !');
                    end;
                  end
                  else
                  begin
                    if Repertoire = rBatch then
                      nNbJours := SpinEditNbJoursNonZippeBatch.Value
                    else if Repertoire = rExtract then
                      nNbJours := SpinEditNbJoursNonZippeExtract.Value;

                    // Si date répertoire antérieure au nombre de jours non zippé.
                    if CompareDateTime(IncDay(DateRepertoire, nNbJours), Now) = -1 then
                    begin
                      // Si répertoire compressé.
                      if Compresser(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name) then
                      begin
                        if(_bArreterTraitement) or (DureeMaxTraitementDepassee) then
                          Exit;

                        // Suppression du répertoire.
                        if SupprimerRepertoire(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name) then
                          AjoutLog('>> Répertoire [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] supprimé.')
                        else
                        begin
                          ExitCode := ERREUR_SUPPRESSION_REPERTOIRE;
                          AjoutLog('>> Échec suppression répertoire [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] !');
                        end;

                        // Si déplacement des zip.
                        if _sRepertoireDestinationZip <> '' then
                        begin
                          // Création sous-répertoires destination (si besoin).
                          if ForceDirectories(_sRepertoireDestinationZip + GetSousRepertoireEAI(sRepertoire)) then
                          begin
                            if FileExists(_sRepertoireDestinationZip + GetSousRepertoireEAI(sRepertoire) + '\' + sr.Name + '.zip') then
                            begin
                              if not DeleteFile(_sRepertoireDestinationZip + GetSousRepertoireEAI(sRepertoire) + '\' + sr.Name + '.zip') then
                              begin
                                ExitCode := ERREUR_SUPPRESSION_FICHIER_COMPRESSE;
                                AjoutLog('>> Erreur :  la suppression du fichier [' + _sRepertoireDestinationZip + GetSousRepertoireEAI(sRepertoire) + '\' + sr.Name + '.zip] a échoué !' + #13#10 + SysErrorMessage(GetLastError));
                              end;
                            end;

                            // Déplacement du zip.
                            if MoveFile(PWideChar(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '.zip'), PWideChar(_sRepertoireDestinationZip + GetSousRepertoireEAI(sRepertoire) + '\' + sr.Name + '.zip')) then
                              AjoutLog('>> Fichier déplacé [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '.zip >> ' + _sRepertoireDestinationZip + GetSousRepertoireEAI(sRepertoire) + '\' + sr.Name + '.zip].')
                            else
                            begin
                              ExitCode := ERREUR_DEPLACEMENT_FICHIER_COMPRESSE;
                              AjoutLog('>> Erreur :  le déplacement du fichier [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '.zip >> ' + _sRepertoireDestinationZip + GetSousRepertoireEAI(sRepertoire) + '\' + sr.Name + '.zip] a échoué !' + #13#10 + SysErrorMessage(GetLastError));
                            end;
                          end
                          else
                          begin
                            ExitCode := ERREUR_CREATION_SOUS_REPERTOIRES;
                            AjoutLog('>> Erreur :  la création des sous-répertoires [' + _sRepertoireDestinationZip + GetSousRepertoireEAI(sRepertoire) + '] a échoué !' + #13#10 + SysErrorMessage(GetLastError));
                          end;
                        end;
                      end
                      else
                      begin
                        ExitCode := ERREUR_COMPRESSION_REPERTOIRE;
                        AjoutLog('>> Échec compression répertoire [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] !');
                      end;
                    end;
                  end;
                end
                else
                begin
                  ExitCode := ERREUR_NOM_REPERTOIRE_JOUR;
                  AjoutLog('>> Erreur nom répertoire jour [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] !');
                end;
              end;
          end;
        end
        else      // Fichier.
        begin
          // Si fichier zip au niveau jour.
          if(Niveau = Jour) and ((LowerCase(ExtractFileExt(sr.Name)) = '.7z') or (LowerCase(ExtractFileExt(sr.Name)) = '.zip')) then
          begin
            if TryStrToInt(LeftStr(sr.Name, Length(sr.Name) - Length(ExtractFileExt(sr.Name))), nTmp) then
            begin
              DateRepertoire := EncodeDate(nAnnee, nMois, nTmp);
              if Repertoire = rBatch then
                nNbJours := SpinEditNbJoursTotalBatch.Value
              else if Repertoire = rExtract then
                nNbJours := SpinEditNbJoursTotalExtract.Value;

              // Si date répertoire antérieure au nombre de jours total de conservation.
              if CompareDateTime(IncDay(DateRepertoire, nNbJours), Now) = -1 then
              begin
                // Suppression du fichier compressé.
                if DeleteFile(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name) then
                  AjoutLog('>> Fichier [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] supprimé.')
                else
                begin
                  ExitCode := ERREUR_SUPPRESSION_FICHIER_COMPRESSE;
                  AjoutLog('>> Erreur :  la suppression du fichier [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] a échoué !' + #13#10 + SysErrorMessage(GetLastError));
                end;
              end;
            end
            else
            begin
              ExitCode := ERREUR_NOM_REPERTOIRE_JOUR;
              AjoutLog('>> Erreur nom répertoire jour [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] !');
            end;
          end;
        end;
      end;
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;
end;

procedure TMainForm.TraitementSousRepertoireDatalog(const sRepertoire: String; const Niveau: TNiveau; const nAnnee, nMois: Integer);
var
  sr: TSearchRec;
  nTmp, nNbJours: Integer;
  DateRepertoire: TDateTime;
begin
  if Niveau = Annee then
    AjoutLog('Traitement sous-répertoire DATALOG [' + sRepertoire + ']');
  LabelSousRepertoire.Caption := '[ ' + GetSousRepertoireEAI(sRepertoire) + ' ]';
  Application.ProcessMessages;

  if FindFirst(IncludeTrailingPathDelimiter(sRepertoire) + '*.*', faAnyFile, sr) = 0 then
  begin
    repeat
      if(_bArreterTraitement) or (DureeMaxTraitementDepassee) then
        Exit;

      if(sr.Name <> '.') and (sr.Name <> '..') then
      begin
        // Si répertoire.
        if(sr.Attr and faDirectory) = faDirectory then
        begin
          case Niveau of
            Annee:
              begin
                if TryStrToInt(sr.Name, nTmp) then
                begin
                  TraitementSousRepertoireDatalog(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name, Mois, nTmp);

                  // Si répertoire 'année' vide.
                  if RepertoireVide(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name) then
                  begin
                    if RemoveDir(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name) then
                      AjoutLog('>> Répertoire année [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] supprimé.')
                    else
                    begin
                      ExitCode := ERREUR_SUPPRESSION_REPERTOIRE;
                      AjoutLog('>> Échec suppression répertoire année [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] !');
                    end;
                  end;
                end
                else
                  AjoutLog('>> Erreur nom répertoire année [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] !');
              end;

            Mois:
              begin
                if TryStrToInt(sr.Name, nTmp) then
                begin
                  TraitementSousRepertoireDatalog(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name, Jour, nAnnee, nTmp);

                  // Si répertoire 'mois' vide.
                  if RepertoireVide(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name) then
                  begin
                    if RemoveDir(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name) then
                      AjoutLog('>> Répertoire mois [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] supprimé.')
                    else
                    begin
                      ExitCode := ERREUR_SUPPRESSION_REPERTOIRE;
                      AjoutLog('>> Échec suppression répertoire mois [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] !');
                    end;
                  end;
                end
                else
                  AjoutLog('>> Erreur nom répertoire mois [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] !');
              end;

            Jour:
              begin
                if TryStrToInt(sr.Name, nTmp) then
                begin
                  DateRepertoire := EncodeDate(nAnnee, nMois, nTmp);
                  nNbJours := SpinEditNbJoursDatalog.Value;

                  // Si date répertoire antérieure au nombre de jours de conservation.
                  if CompareDateTime(IncDay(DateRepertoire, nNbJours), Now) = -1 then
                  begin
                    // Suppression du répertoire.
                    if SupprimerRepertoire(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name) then
                      AjoutLog('>> Répertoire [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] supprimé.')
                    else
                    begin
                      ExitCode := ERREUR_SUPPRESSION_REPERTOIRE;
                      AjoutLog('>> Échec suppression répertoire [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] !');
                    end;
                  end;
                end
                else
                begin
                  ExitCode := ERREUR_NOM_REPERTOIRE_JOUR;
                  AjoutLog('>> Erreur nom répertoire jour [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] !');
                end;
              end;
          end;
        end;
      end;
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;
end;

procedure TMainForm.TraitementSousRepertoireLog(const sRepertoire: String);
var
  sr: TSearchRec;
  nTmp: Integer;
  DateRepertoire: TDateTime;
  sNomFichier: String;
begin
  AjoutLog('Traitement sous-répertoire LOG [' + sRepertoire + ']');
  LabelSousRepertoire.Caption := '[ ' + GetSousRepertoireEAI(sRepertoire) + ' ]';
  Application.ProcessMessages;

  if FindFirst(IncludeTrailingPathDelimiter(sRepertoire) + '*.*', faAnyFile, sr) = 0 then
  begin
    repeat
      if(_bArreterTraitement) or (DureeMaxTraitementDepassee) then
        Exit;

      if(sr.Name <> '.') and (sr.Name <> '..') then
      begin
        // Si répertoire.
        if(sr.Attr and faDirectory) = faDirectory then
        begin
          if(Length(sr.Name) = 8) and (TryStrToInt(sr.Name, nTmp)) then
          begin
            DateRepertoire := EncodeDate(StrToInt(LeftStr(sr.Name, 4)), StrToInt(Copy(sr.Name, 5, 2)), StrToInt(RightStr(sr.Name, 2)));

            // Si date répertoire antérieure au nombre de jours total de conservation.
            if CompareDateTime(IncDay(DateRepertoire, SpinEditNbJoursTotalLog.Value), Now) = -1 then
            begin
              // Suppression directe du répertoire (inutile de compresser).
              if SupprimerRepertoire(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name) then
                AjoutLog('>> Répertoire [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] supprimé.')
              else
              begin
                ExitCode := ERREUR_SUPPRESSION_REPERTOIRE;
                AjoutLog('>> Échec suppression répertoire [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] !');
              end;
            end
            else
            begin
              // Si date répertoire antérieure au nombre de jours non zippé.
              if CompareDateTime(IncDay(DateRepertoire, SpinEditNbJoursNonZippeLog.Value), Now) = -1 then
              begin
                // Si répertoire compressé.
                if Compresser(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name) then
                begin
                  if(_bArreterTraitement) or (DureeMaxTraitementDepassee) then
                    Exit;

                  // Suppression du répertoire.
                  if SupprimerRepertoire(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name) then
                    AjoutLog('>> Répertoire [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] supprimé.')
                  else
                  begin
                    ExitCode := ERREUR_SUPPRESSION_REPERTOIRE;
                    AjoutLog('>> Échec suppression répertoire [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] !');
                  end;

                  // Si déplacement des zip.
                  if _sRepertoireDestinationZip <> '' then
                  begin
                    // Création sous-répertoires destination (si besoin).
                    if ForceDirectories(_sRepertoireDestinationZip + GetSousRepertoireEAI(sRepertoire)) then
                    begin
                      if FileExists(_sRepertoireDestinationZip + GetSousRepertoireEAI(sRepertoire) + '\' + sr.Name + '.zip') then
                      begin
                        if not DeleteFile(_sRepertoireDestinationZip + GetSousRepertoireEAI(sRepertoire) + '\' + sr.Name + '.zip') then
                        begin
                          ExitCode := ERREUR_SUPPRESSION_FICHIER_COMPRESSE;
                          AjoutLog('>> Erreur :  la suppression du fichier [' + _sRepertoireDestinationZip + GetSousRepertoireEAI(sRepertoire) + '\' + sr.Name + '.zip] a échoué !' + #13#10 + SysErrorMessage(GetLastError));
                        end;
                      end;

                      // Déplacement du zip.
                      if MoveFile(PWideChar(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '.zip'), PWideChar(_sRepertoireDestinationZip + GetSousRepertoireEAI(sRepertoire) + '\' + sr.Name + '.zip')) then
                        AjoutLog('>> Fichier déplacé [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '.zip >> ' + _sRepertoireDestinationZip + GetSousRepertoireEAI(sRepertoire) + '\' + sr.Name + '.zip].')
                      else
                      begin
                        ExitCode := ERREUR_DEPLACEMENT_FICHIER_COMPRESSE;
                        AjoutLog('>> Erreur :  le déplacement du fichier [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '.zip >> ' + _sRepertoireDestinationZip + GetSousRepertoireEAI(sRepertoire) + '\' + sr.Name + '.zip] a échoué !' + #13#10 + SysErrorMessage(GetLastError));
                      end;
                    end
                    else
                    begin
                      ExitCode := ERREUR_CREATION_SOUS_REPERTOIRES;
                      AjoutLog('>> Erreur :  la création des sous-répertoires [' + _sRepertoireDestinationZip + GetSousRepertoireEAI(sRepertoire) + '] a échoué !' + #13#10 + SysErrorMessage(GetLastError));
                    end;
                  end;
                end
                else
                begin
                  ExitCode := ERREUR_COMPRESSION_REPERTOIRE;
                  AjoutLog('>> Échec compression répertoire [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] !');
                end;
              end;
            end;
          end;
        end
        else      // Fichier.
        begin
          // Si fichier zip.
          if((LowerCase(ExtractFileExt(sr.Name)) = '.7z') or (LowerCase(ExtractFileExt(sr.Name)) = '.zip')) then
          begin
            sNomFichier := LeftStr(sr.Name, Length(sr.Name) - Length(ExtractFileExt(sr.Name)));
            if(Length(sNomFichier) = 8) and (TryStrToInt(sNomFichier, nTmp)) then
            begin
              DateRepertoire := EncodeDate(StrToInt(LeftStr(sNomFichier, 4)), StrToInt(Copy(sNomFichier, 5, 2)), StrToInt(RightStr(sNomFichier, 2)));

              // Si date répertoire antérieure au nombre de jours total de conservation.
              if CompareDateTime(IncDay(DateRepertoire, SpinEditNbJoursTotalLog.Value), Now) = -1 then
              begin
                // Suppression du fichier compressé.
                if DeleteFile(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name) then
                  AjoutLog('>> Fichier [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] supprimé.')
                else
                begin
                  ExitCode := ERREUR_SUPPRESSION_FICHIER_COMPRESSE;
                  AjoutLog('>> Erreur :  la suppression du fichier [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] a échoué !' + #13#10 + SysErrorMessage(GetLastError));
                end;
              end;
            end;
          end;
        end;
      end;
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;
end;

procedure TMainForm.TraitementSousRepertoireLogs(const sRepertoire: String);
var
  sr: TSearchRec;
begin
  AjoutLog('Traitement sous-répertoire LOGS [' + sRepertoire + ']');
  LabelSousRepertoire.Caption := '[ ' + GetSousRepertoireEAI(sRepertoire) + ' ]';
  Application.ProcessMessages;

  if FindFirst(IncludeTrailingPathDelimiter(sRepertoire) + '*.*', faAnyFile, sr) = 0 then
  begin
    repeat
      if(_bArreterTraitement) or (DureeMaxTraitementDepassee) then
        Exit;

      if(sr.Name <> '.') and (sr.Name <> '..') then
      begin
        // Si fichier.
        if(sr.Attr and faDirectory) <> faDirectory then
        begin
          // Si date fichier antérieure au nombre de jours de conservation.
          if CompareDateTime(IncDay(sr.TimeStamp, SpinEditNbJoursLogs.Value), Now) = -1 then
          begin
            // Suppression du fichier.
            if DeleteFile(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name) then
              AjoutLog('>> Fichier [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] supprimé.')
            else
            begin
              ExitCode := ERREUR_SUPPRESSION_FICHIER_LOGS;
              AjoutLog('>> Erreur :  la suppression du fichier [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] a échoué !' + #13#10 + SysErrorMessage(GetLastError));
            end;
          end;
        end;
      end;
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;
end;

procedure TMainForm.TraitementChangementDeParc(const bBackup, bSynchro: Boolean);
var
  FichierINI: TIniFile;
begin
  BtnTraitement.Hide;      BtnArreterTraitement.Show;      BtnArreterTraitement.Enabled := True;
  GroupBoxSousRepertoires.Enabled := False;
  LabelRepertoire.Caption := '';      LabelSousRepertoire.Show;      LabelEtape.Show;
  _bArreterTraitement := False;
  Screen.Cursor := crHourGlass;
  try
    AjoutLog('Début traitement (MODE CHANGEMENT DE PARC).');
    ExitCode := 0;

    // Si même jour que dernière exécution.
    if CompareDate(_DateDerniereExecution, Now) = 0 then
    begin
      ExitCode := DERNIERE_EXECUTION_MEME_JOUR;
      AjoutLog('>> La dernière exécution date du même jour !');
    end
    else
    begin
      _nDebutTraitement := GetTickCount;
      LabelRepertoire.Caption := 'Traitement répertoire [ \GINKOIA\EAI\ ] ...';
      Application.ProcessMessages;

      // Si le répertoire existe.
      if DirectoryExists('.\EAI\') then
      begin
        // Mode changement de parc (\GINKOIA\EAI\).
        RechercheSousRepertoireCdP('.\EAI\');
      end
      else
      begin
        ExitCode := ERREUR_REPERTOIRE_INEXISTANT;
        AjoutLog('>> Erreur :  le répertoire [\GINKOIA\EAI\] n''existe pas !');
      end;

      // Si répertoires optionnels.
      if(bBackup) or (bSynchro) then
      begin
        // Si le répertoire existe.
        if DirectoryExists('.\Data\') then
        begin
          if bBackup then
          begin
            // Si le répertoire existe.
            if DirectoryExists('.\Data\Backup\') then
            begin
              AjoutLog('Traitement répertoire [.\Data\Backup\].');
              SupprimerContenuRepertoire('.\Data\Backup\');
            end
            else
            begin
              ExitCode := ERREUR_REPERTOIRE_INEXISTANT;
              AjoutLog('>> Erreur :  le répertoire [\GINKOIA\Data\Backup\] n''existe pas !');
            end;
          end;

          if bSynchro then
          begin
            // Si le répertoire existe.
            if DirectoryExists('.\Data\Synchro\') then
            begin
              AjoutLog('Traitement répertoire [.\Data\Synchro\].');
              SupprimerContenuRepertoire('.\Data\Synchro\');
            end
            else
            begin
              ExitCode := ERREUR_REPERTOIRE_INEXISTANT;
              AjoutLog('>> Erreur :  le répertoire [\GINKOIA\Data\Synchro\] n''existe pas !');
            end;
          end;
        end
        else
        begin
          ExitCode := ERREUR_REPERTOIRE_INEXISTANT;
          AjoutLog('>> Erreur :  le répertoire [\GINKOIA\Data\] n''existe pas !');
        end;
      end;

      AjoutLog('Fin traitement.');

      FichierINI := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'NettoieGinkoia.ini');
      try
        FichierINI.WriteDate('Paramètres', 'Dernière exécution', Date);
      finally
        FichierINI.Free;
      end;
    end;
  finally
    Screen.Cursor := crDefault;
    LabelRepertoire.Caption := IfThen(ExitCode = DERNIERE_EXECUTION_MEME_JOUR, 'Dernier traitement le même jour !', 'Traitement terminé.');      LabelSousRepertoire.Hide;      LabelEtape.Hide;
    BtnArreterTraitement.Hide;      BtnArreterTraitement.Enabled := True;
  end;
end;

procedure TMainForm.RechercheSousRepertoireCdP(const sRepertoire: String);
var
  sr: TSearchRec;
begin
  if FindFirst(IncludeTrailingPathDelimiter(sRepertoire) + '*.*', faAnyFile, sr) = 0 then
  begin
    repeat
      if(_bArreterTraitement) or (DureeMaxTraitementDepassee) then
        Exit;

      // Si répertoire.
      if((sr.Attr and faDirectory) = faDirectory) and (sr.Name <> '.') and (sr.Name <> '..') then
      begin
        if UpperCase(sr.Name) = 'BATCH' then
          TraitementSousRepertoireDonnesCdP(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name, rBatch)
        else if UpperCase(sr.Name) = 'DATALOG' then
          TraitementSousRepertoireDatalogCdP(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name)
        else if UpperCase(sr.Name) = 'EXTRACT' then
          TraitementSousRepertoireDonnesCdP(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name, rExtract)
        else if UpperCase(sr.Name) = 'LOG' then
          TraitementSousRepertoireLogCdP(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name)
        else if UpperCase(sr.Name) = 'LOGS' then
          TraitementSousRepertoireLogsCdP(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name)
        else
          RechercheSousRepertoireCdP(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name);
      end;
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;
end;

procedure TMainForm.TraitementSousRepertoireDonnesCdP(const sRepertoire: String; const Repertoire: TRepertoire; const Niveau: TNiveau; const nAnnee, nMois: Integer);
var
  sr: TSearchRec;
  nTmp, nNbJours: Integer;
  DateRepertoire: TDateTime;
begin
  if Niveau = Annee then
    AjoutLog('Traitement sous-répertoire [' + sRepertoire + ']');
  LabelSousRepertoire.Caption := '[ ' + GetSousRepertoireEAI(sRepertoire) + ' ]';
  Application.ProcessMessages;
  nNbJours := 0;

  if FindFirst(IncludeTrailingPathDelimiter(sRepertoire) + '*.*', faAnyFile, sr) = 0 then
  begin
    repeat
      if(_bArreterTraitement) or (DureeMaxTraitementDepassee) then
        Exit;

      if(sr.Name <> '.') and (sr.Name <> '..') then
      begin
        // Si répertoire.
        if(sr.Attr and faDirectory) = faDirectory then
        begin
          case Niveau of
            Annee:
              begin
                if TryStrToInt(sr.Name, nTmp) then
                begin
                  TraitementSousRepertoireDonnesCdP(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name, Repertoire, Mois, nTmp);

                  // Si répertoire 'année' vide.
                  if RepertoireVide(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name) then
                  begin
                    if RemoveDir(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name) then
                      AjoutLog('>> Répertoire année [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] supprimé.')
                    else
                    begin
                      ExitCode := ERREUR_SUPPRESSION_REPERTOIRE;
                      AjoutLog('>> Échec suppression répertoire année [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] !');
                    end;
                  end;
                end
                else
                  AjoutLog('>> Erreur nom répertoire année [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] !');
              end;

            Mois:
              begin
                if TryStrToInt(sr.Name, nTmp) then
                begin
                  TraitementSousRepertoireDonnesCdP(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name, Repertoire, Jour, nAnnee, nTmp);

                  // Si répertoire 'mois' vide.
                  if RepertoireVide(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name) then
                  begin
                    if RemoveDir(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name) then
                      AjoutLog('>> Répertoire mois [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] supprimé.')
                    else
                    begin
                      ExitCode := ERREUR_SUPPRESSION_REPERTOIRE;
                      AjoutLog('>> Échec suppression répertoire mois [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] !');
                    end;
                  end;
                end
                else
                  AjoutLog('>> Erreur nom répertoire mois [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] !');
              end;

            Jour:
              begin
                if TryStrToInt(sr.Name, nTmp) then
                begin
                  DateRepertoire := EncodeDate(nAnnee, nMois, nTmp);
                  if Repertoire = rBatch then
                    nNbJours := _nNbJoursBatch
                  else if Repertoire = rExtract then
                    nNbJours := _nNbJoursExtract;

                  // Si date répertoire antérieure au nombre de jours de conservation.
                  if CompareDateTime(IncDay(DateRepertoire, nNbJours), Now) = -1 then
                  begin
                    // Suppression directe du répertoire (inutile de compresser).
                    if SupprimerRepertoire(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name) then
                      AjoutLog('>> Répertoire [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] supprimé.')
                    else
                    begin
                      ExitCode := ERREUR_SUPPRESSION_REPERTOIRE;
                      AjoutLog('>> Échec suppression répertoire [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] !');
                    end;
                  end
                  else
                  begin
                    // Si répertoire compressé.
                    if Compresser(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name) then
                    begin
                      if(_bArreterTraitement) or (DureeMaxTraitementDepassee) then
                        Exit;

                      // Suppression du répertoire.
                      if SupprimerRepertoire(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name) then
                        AjoutLog('>> Répertoire [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] supprimé.')
                      else
                      begin
                        ExitCode := ERREUR_SUPPRESSION_REPERTOIRE;
                        AjoutLog('>> Échec suppression répertoire [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] !');
                      end;

                      // Si déplacement des zip.
                      if _sRepertoireDestinationZip <> '' then
                      begin
                        // Création sous-répertoires destination (si besoin).
                        if ForceDirectories(_sRepertoireDestinationZip + GetSousRepertoireEAI(sRepertoire)) then
                        begin
                          if FileExists(_sRepertoireDestinationZip + GetSousRepertoireEAI(sRepertoire) + '\' + sr.Name + '.zip') then
                          begin
                            if not DeleteFile(_sRepertoireDestinationZip + GetSousRepertoireEAI(sRepertoire) + '\' + sr.Name + '.zip') then
                            begin
                              ExitCode := ERREUR_SUPPRESSION_FICHIER_COMPRESSE;
                              AjoutLog('>> Erreur :  la suppression du fichier [' + _sRepertoireDestinationZip + GetSousRepertoireEAI(sRepertoire) + '\' + sr.Name + '.zip] a échoué !' + #13#10 + SysErrorMessage(GetLastError));
                            end;
                          end;

                          // Déplacement du zip.
                          if MoveFile(PWideChar(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '.zip'), PWideChar(_sRepertoireDestinationZip + GetSousRepertoireEAI(sRepertoire) + '\' + sr.Name + '.zip')) then
                            AjoutLog('>> Fichier déplacé [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '.zip >> ' + _sRepertoireDestinationZip + GetSousRepertoireEAI(sRepertoire) + '\' + sr.Name + '.zip].')
                          else
                          begin
                            ExitCode := ERREUR_DEPLACEMENT_FICHIER_COMPRESSE;
                            AjoutLog('>> Erreur :  le déplacement du fichier [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '.zip >> ' + _sRepertoireDestinationZip + GetSousRepertoireEAI(sRepertoire) + '\' + sr.Name + '.zip] a échoué !' + #13#10 + SysErrorMessage(GetLastError));
                          end;
                        end
                        else
                        begin
                          ExitCode := ERREUR_CREATION_SOUS_REPERTOIRES;
                          AjoutLog('>> Erreur :  la création des sous-répertoires [' + _sRepertoireDestinationZip + GetSousRepertoireEAI(sRepertoire) + '] a échoué !' + #13#10 + SysErrorMessage(GetLastError));
                        end;
                      end;
                    end
                    else
                    begin
                      ExitCode := ERREUR_COMPRESSION_REPERTOIRE;
                      AjoutLog('>> Échec compression répertoire [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] !');
                    end;
                  end;
                end
                else
                begin
                  ExitCode := ERREUR_NOM_REPERTOIRE_JOUR;
                  AjoutLog('>> Erreur nom répertoire jour [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] !');
                end;
              end;
          end;
        end
        else      // Fichier.
        begin
          // Si fichier zip au niveau jour.
          if(Niveau = Jour) and ((LowerCase(ExtractFileExt(sr.Name)) = '.7z') or (LowerCase(ExtractFileExt(sr.Name)) = '.zip')) then
          begin
            if TryStrToInt(LeftStr(sr.Name, Length(sr.Name) - Length(ExtractFileExt(sr.Name))), nTmp) then
            begin
              DateRepertoire := EncodeDate(nAnnee, nMois, nTmp);
              if Repertoire = rBatch then
                nNbJours := _nNbJoursBatch
              else if Repertoire = rExtract then
                nNbJours := _nNbJoursExtract;

              // Si date fichier zip antérieure au nombre de jours de conservation.
              if CompareDateTime(IncDay(DateRepertoire, nNbJours), Now) = -1 then
              begin
                // Suppression du fichier compressé.
                if DeleteFile(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name) then
                  AjoutLog('>> Fichier [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] supprimé.')
                else
                begin
                  ExitCode := ERREUR_SUPPRESSION_FICHIER_COMPRESSE;
                  AjoutLog('>> Erreur :  la suppression du fichier [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] a échoué !' + #13#10 + SysErrorMessage(GetLastError));
                end;
              end;
            end
            else
            begin
              ExitCode := ERREUR_NOM_REPERTOIRE_JOUR;
              AjoutLog('>> Erreur nom répertoire jour [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] !');
            end;
          end;
        end;
      end;
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;
end;

procedure TMainForm.TraitementSousRepertoireDatalogCdP(const sRepertoire: String; const Niveau: TNiveau; const nAnnee, nMois: Integer);
var
  sr: TSearchRec;
  nTmp, nNbJours: Integer;
  DateRepertoire: TDateTime;
begin
  if Niveau = Annee then
    AjoutLog('Traitement sous-répertoire DATALOG [' + sRepertoire + ']');
  LabelSousRepertoire.Caption := '[ ' + GetSousRepertoireEAI(sRepertoire) + ' ]';
  Application.ProcessMessages;

  if FindFirst(IncludeTrailingPathDelimiter(sRepertoire) + '*.*', faAnyFile, sr) = 0 then
  begin
    repeat
      if(_bArreterTraitement) or (DureeMaxTraitementDepassee) then
        Exit;

      if(sr.Name <> '.') and (sr.Name <> '..') then
      begin
        // Si répertoire.
        if(sr.Attr and faDirectory) = faDirectory then
        begin
          case Niveau of
            Annee:
              begin
                if TryStrToInt(sr.Name, nTmp) then
                begin
                  TraitementSousRepertoireDatalogCdP(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name, Mois, nTmp);

                  // Si répertoire 'année' vide.
                  if RepertoireVide(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name) then
                  begin
                    if RemoveDir(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name) then
                      AjoutLog('>> Répertoire année [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] supprimé.')
                    else
                    begin
                      ExitCode := ERREUR_SUPPRESSION_REPERTOIRE;
                      AjoutLog('>> Échec suppression répertoire année [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] !');
                    end;
                  end;
                end
                else
                  AjoutLog('>> Erreur nom répertoire année [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] !');
              end;

            Mois:
              begin
                if TryStrToInt(sr.Name, nTmp) then
                begin
                  TraitementSousRepertoireDatalogCdP(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name, Jour, nAnnee, nTmp);

                  // Si répertoire 'mois' vide.
                  if RepertoireVide(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name) then
                  begin
                    if RemoveDir(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name) then
                      AjoutLog('>> Répertoire mois [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] supprimé.')
                    else
                    begin
                      ExitCode := ERREUR_SUPPRESSION_REPERTOIRE;
                      AjoutLog('>> Échec suppression répertoire mois [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] !');
                    end;
                  end;
                end
                else
                  AjoutLog('>> Erreur nom répertoire mois [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] !');
              end;

            Jour:
              begin
                if TryStrToInt(sr.Name, nTmp) then
                begin
                  DateRepertoire := EncodeDate(nAnnee, nMois, nTmp);
                  nNbJours := SpinEditNbJoursDatalog.Value;

                  // Si date répertoire antérieure au nombre de jours de conservation.
                  if CompareDateTime(IncDay(DateRepertoire, nNbJours), Now) = -1 then
                  begin
                    // Suppression du répertoire.
                    if SupprimerRepertoire(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name) then
                      AjoutLog('>> Répertoire [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] supprimé.')
                    else
                    begin
                      ExitCode := ERREUR_SUPPRESSION_REPERTOIRE;
                      AjoutLog('>> Échec suppression répertoire [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] !');
                    end;
                  end;
                end
                else
                begin
                  ExitCode := ERREUR_NOM_REPERTOIRE_JOUR;
                  AjoutLog('>> Erreur nom répertoire jour [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] !');
                end;
              end;
          end;
        end;
      end;
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;
end;

procedure TMainForm.TraitementSousRepertoireLogCdP(const sRepertoire: String);
var
  sr: TSearchRec;
  nTmp: Integer;
  DateRepertoire: TDateTime;
  sNomFichier: String;
begin
  AjoutLog('Traitement sous-répertoire LOG [' + sRepertoire + ']');
  LabelSousRepertoire.Caption := '[ ' + GetSousRepertoireEAI(sRepertoire) + ' ]';
  Application.ProcessMessages;

  if FindFirst(IncludeTrailingPathDelimiter(sRepertoire) + '*.*', faAnyFile, sr) = 0 then
  begin
    repeat
      if(_bArreterTraitement) or (DureeMaxTraitementDepassee) then
        Exit;

      if(sr.Name <> '.') and (sr.Name <> '..') then
      begin
        // Si répertoire.
        if(sr.Attr and faDirectory) = faDirectory then
        begin
          if(Length(sr.Name) = 8) and (TryStrToInt(sr.Name, nTmp)) then
          begin
            DateRepertoire := EncodeDate(StrToInt(LeftStr(sr.Name, 4)), StrToInt(Copy(sr.Name, 5, 2)), StrToInt(RightStr(sr.Name, 2)));

            // Si date répertoire antérieure au nombre de jours de conservation.
            if CompareDateTime(IncDay(DateRepertoire, _nNbJoursLog), Now) = -1 then
            begin
              // Suppression directe du répertoire (inutile de compresser).
              if SupprimerRepertoire(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name) then
                AjoutLog('>> Répertoire [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] supprimé.')
              else
              begin
                ExitCode := ERREUR_SUPPRESSION_REPERTOIRE;
                AjoutLog('>> Échec suppression répertoire [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] !');
              end;
            end
            else
            begin
              // Si répertoire compressé.
              if Compresser(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name) then
              begin
                if(_bArreterTraitement) or (DureeMaxTraitementDepassee) then
                  Exit;

                // Suppression du répertoire.
                if SupprimerRepertoire(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name) then
                  AjoutLog('>> Répertoire [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] supprimé.')
                else
                begin
                  ExitCode := ERREUR_SUPPRESSION_REPERTOIRE;
                  AjoutLog('>> Échec suppression répertoire [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] !');
                end;

                // Si déplacement des zip.
                if _sRepertoireDestinationZip <> '' then
                begin
                  // Création sous-répertoires destination (si besoin).
                  if ForceDirectories(_sRepertoireDestinationZip + GetSousRepertoireEAI(sRepertoire)) then
                  begin
                    if FileExists(_sRepertoireDestinationZip + GetSousRepertoireEAI(sRepertoire) + '\' + sr.Name + '.zip') then
                    begin
                      if not DeleteFile(_sRepertoireDestinationZip + GetSousRepertoireEAI(sRepertoire) + '\' + sr.Name + '.zip') then
                      begin
                        ExitCode := ERREUR_SUPPRESSION_FICHIER_COMPRESSE;
                        AjoutLog('>> Erreur :  la suppression du fichier [' + _sRepertoireDestinationZip + GetSousRepertoireEAI(sRepertoire) + '\' + sr.Name + '.zip] a échoué !' + #13#10 + SysErrorMessage(GetLastError));
                      end;
                    end;

                    // Déplacement du zip.
                    if MoveFile(PWideChar(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '.zip'), PWideChar(_sRepertoireDestinationZip + GetSousRepertoireEAI(sRepertoire) + '\' + sr.Name + '.zip')) then
                      AjoutLog('>> Fichier déplacé [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '.zip >> ' + _sRepertoireDestinationZip + GetSousRepertoireEAI(sRepertoire) + '\' + sr.Name + '.zip].')
                    else
                    begin
                      ExitCode := ERREUR_DEPLACEMENT_FICHIER_COMPRESSE;
                      AjoutLog('>> Erreur :  le déplacement du fichier [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '.zip >> ' + _sRepertoireDestinationZip + GetSousRepertoireEAI(sRepertoire) + '\' + sr.Name + '.zip] a échoué !' + #13#10 + SysErrorMessage(GetLastError));
                    end;
                  end
                  else
                  begin
                    ExitCode := ERREUR_CREATION_SOUS_REPERTOIRES;
                    AjoutLog('>> Erreur :  la création des sous-répertoires [' + _sRepertoireDestinationZip + GetSousRepertoireEAI(sRepertoire) + '] a échoué !' + #13#10 + SysErrorMessage(GetLastError));
                  end;
                end;
              end
              else
              begin
                ExitCode := ERREUR_COMPRESSION_REPERTOIRE;
                AjoutLog('>> Échec compression répertoire [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] !');
              end;
            end;
          end;
        end
        else      // Fichier.
        begin
          // Si fichier zip.
          if((LowerCase(ExtractFileExt(sr.Name)) = '.7z') or (LowerCase(ExtractFileExt(sr.Name)) = '.zip')) then
          begin
            sNomFichier := LeftStr(sr.Name, Length(sr.Name) - Length(ExtractFileExt(sr.Name)));
            if(Length(sNomFichier) = 8) and (TryStrToInt(sNomFichier, nTmp)) then
            begin
              DateRepertoire := EncodeDate(StrToInt(LeftStr(sNomFichier, 4)), StrToInt(Copy(sNomFichier, 5, 2)), StrToInt(RightStr(sNomFichier, 2)));

              // Si date répertoire antérieure au nombre de jours de conservation.
              if CompareDateTime(IncDay(DateRepertoire, _nNbJoursLog), Now) = -1 then
              begin
                // Suppression du fichier compressé.
                if DeleteFile(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name) then
                  AjoutLog('>> Fichier [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] supprimé.')
                else
                begin
                  ExitCode := ERREUR_SUPPRESSION_FICHIER_COMPRESSE;
                  AjoutLog('>> Erreur :  la suppression du fichier [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] a échoué !' + #13#10 + SysErrorMessage(GetLastError));
                end;
              end;
            end;
          end;
        end;
      end;
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;
end;

procedure TMainForm.TraitementSousRepertoireLogsCdP(const sRepertoire: String);
var
  sr: TSearchRec;
  sNomFichier: String;
  nTmp: Integer;
  DateRepertoire: TDateTime;
begin
  AjoutLog('Traitement sous-répertoire LOGS [' + sRepertoire + ']');
  LabelSousRepertoire.Caption := '[ ' + GetSousRepertoireEAI(sRepertoire) + ' ]';
  Application.ProcessMessages;

  if FindFirst(IncludeTrailingPathDelimiter(sRepertoire) + '*.*', faAnyFile, sr) = 0 then
  begin
    repeat
      if(_bArreterTraitement) or (DureeMaxTraitementDepassee) then
        Exit;

      if(sr.Name <> '.') and (sr.Name <> '..') then
      begin
        // Si fichier.
        if(sr.Attr and faDirectory) <> faDirectory then
        begin
          sNomFichier := LeftStr(sr.Name, Length(sr.Name) - Length(ExtractFileExt(sr.Name)));
          if(Length(sNomFichier) >= 8) and (TryStrToInt(LeftStr(sNomFichier, 8), nTmp)) then
          begin
            DateRepertoire := EncodeDate(StrToInt(LeftStr(sNomFichier, 4)), StrToInt(Copy(sNomFichier, 5, 2)), StrToInt(Copy(sNomFichier, 7, 2)));

            // Si date fichier antérieure au nombre de jours de conservation.
            if CompareDateTime(IncDay(DateRepertoire, _nNbJoursLogs), Now) = -1 then
            begin
              // Suppression du fichier.
              if DeleteFile(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name) then
                AjoutLog('>> Fichier [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] supprimé.')
              else
              begin
                ExitCode := ERREUR_SUPPRESSION_FICHIER_LOGS;
                AjoutLog('>> Erreur :  la suppression du fichier [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] a échoué !' + #13#10 + SysErrorMessage(GetLastError));
              end;
            end;
          end;
        end;
      end;
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;
end;

procedure TMainForm.SupprimerContenuRepertoire(const sRepertoire: String);
var
  sr: TSearchRec;
begin
  if FindFirst(IncludeTrailingPathDelimiter(sRepertoire) + '*.*', faAnyFile, sr) = 0 then
  begin
    repeat
      if(_bArreterTraitement) or (DureeMaxTraitementDepassee) then
        Exit;

      if(sr.Name <> '.') and (sr.Name <> '..') then
      begin
        // Si répertoire.
        if(sr.Attr and faDirectory) = faDirectory then
        begin
          // Suppression du répertoire.
          if SupprimerRepertoire(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name) then
            AjoutLog('>> Répertoire [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] supprimé.')
          else
          begin
            ExitCode := ERREUR_SUPPRESSION_REPERTOIRE;
            AjoutLog('>> Échec suppression répertoire [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] !');
          end;
        end
        else      // Fichier.
        begin
          // Suppression du fichier.
          if DeleteFile(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name) then
            AjoutLog('>> Fichier [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] supprimé.')
          else
          begin
            ExitCode := ERREUR_SUPPRESSION_FICHIER;
            AjoutLog('>> Erreur :  la suppression du fichier [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] a échoué !' + #13#10 + SysErrorMessage(GetLastError));
          end;
        end;
      end;
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;
end;

function ProgressionCompression(Sender: Pointer; bTotal: Boolean; Value: Int64): HRESULT;   stdcall;
begin
  Result := 1;
//  MainForm.LabelProgression.Caption := IntToStr(Value);
  Application.ProcessMessages;
end;

procedure TMainForm.GetListeFichiers(const sRepertoire: String; out sListeFichier: String);
var
  sr: TSearchrec;
begin
  sListeFichier := '';
  if FindFirst(IncludeTrailingPathDelimiter(sRepertoire) + '*.*', faAnyFile, sr) = 0 then
  begin
    repeat
      // Si fichier.
      if((sr.Attr and faDirectory) <> faDirectory) and (sr.Name <> '.') and (sr.Name <> '..') then
        sListeFichier := sListeFichier + sr.Name + ';';
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;
end;

function TMainForm.Compresser(const sRepertoire: String): Boolean;
{$REGION 'Compresser'}
  function RepertoireCourant: String;
  var
    nIndex: Integer;
  begin
    Result := ReverseString(sRepertoire);
    nIndex := Pos('\', Result);
    if nIndex > 0 then
      Result := Copy(Result, 1, nIndex - 1);
    Result := ReverseString(Result);
  end;

  function GetTailleFichier(const szFichier: String): Int64;
  var
     sr: TSearchRec;
  begin
     Result := 0;
     if FindFirst(szFichier, faAnyFile, sr) = 0 then
     begin
        Result := sr.Size;
        FindClose(sr);
     end;
  end;
{$ENDREGION}
var
  TypeArchive: TGUID;
  Archive: I7zOutArchive;
  sListeFichier: String;
  bCompressionEnCours: Boolean;
begin
  Result := False;

  // Si répertoire déjà compressé (anomalie).
  if FileExists(sRepertoire + '.zip') then
  begin
    AjoutLog('>> Attention :  répertoire [' + sRepertoire + '] déjà compressé !');
    if not RenameFile(sRepertoire + '.zip', sRepertoire + '_OLD_(' + FormatDateTime('dd-mm-yyyy-hh-nn-ss', Now) + ')' + '.zip') then
    begin
      AjoutLog('>> Échec renommage fichier [' + sRepertoire + '.zip]: ' + SysErrorMessage(GetLastError));
      Exit;
    end;
  end;

  LabelEtape.Caption := 'Compression [' + RepertoireCourant + '] en cours ...';
  Application.ProcessMessages;

  // Compression.
  bCompressionEnCours := True;
  TThreadProc.RunInThread(
    procedure
    begin
      TypeArchive := CLSID_CFormatZip;
      Archive := CreateOutArchive(TypeArchive);
      GetListeFichiers(sRepertoire, sListeFichier);
      Archive.AddFiles(sRepertoire, '', sListeFichier, True);
      SetCompressionLevel(Archive, SpinEditTauxCompression.Value);      // 0 1 3 5 7 9
//      Archive.SetProgressCallback(nil, ProgressionCompression);
      Archive.SaveToFile(sRepertoire + '.zip');
    end
  ).whenError(
    procedure(aException: Exception)
    begin
      AjoutLog('>> ' + aException.Message);
    end
  ).whenFinish(
    procedure
    begin
      bCompressionEnCours := False;
    end
  ).Run;

  // Attente de la fin de la compression.
  while bCompressionEnCours do
  begin
    Application.ProcessMessages;
    Sleep(100);
  end;

  if FileExists(sRepertoire + '.zip') then
  begin
    if GetTailleFichier(sRepertoire + '.zip') > 0 then
    begin
      AjoutLog('>> Répertoire [' + sRepertoire + '] compressé.');
      Result := True;
    end;
  end;

  LabelEtape.Caption := '';
  Application.ProcessMessages;
end;

function TMainForm.SupprimerRepertoire(const sRepertoire: String): Boolean;
var
  SHFileOpStruct: TSHFileOpStruct;
begin
  Result := False;
  if SysUtils.DirectoryExists(sRepertoire) then
  begin
    ZeroMemory(@SHFileOpStruct, SizeOf(SHFileOpStruct));
    SHFileOpStruct.wFunc := FO_DELETE;
    SHFileOpStruct.fFlags := FOF_SILENT or FOF_NOCONFIRMATION;
    SHFileOpStruct.pFrom := PChar(sRepertoire + #0);
    Result := (0 = ShFileOperation(SHFileOpStruct));
  end;
end;

procedure TMainForm.Afficher1Click(Sender: TObject);
begin
  // Afficher la fenêtre.
  Show;
  Application.Restore;
end;

procedure TMainForm.AjoutLog(const sLigne: String; const bNouveau: Boolean);
var
  F: TextFile;
begin
  AssignFile(F, ExtractFilePath(Application.ExeName) + 'NettoieGinkoia.log');
  try
    if bNouveau then
      Rewrite(F)
    else
      Append(F);
    Writeln(F, '[' + FormatDateTime('dd/mm/yyyy hh:nn:ss:zzz', Now) + ']  ' + sLigne);
  finally
    CloseFile(F);
  end;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  FichierINI: TIniFile;
begin
  FichierINI := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'NettoieGinkoia.ini');
  try
    FichierINI.WriteInteger('Mode classique', 'Nombre de jours non zippé BATCH', SpinEditNbJoursNonZippeBatch.Value);
    FichierINI.WriteInteger('Mode classique', 'Nombre de jours total BATCH', SpinEditNbJoursTotalBatch.Value);
    FichierINI.WriteInteger('Mode classique', 'Nombre de jours non zippé EXTRACT', SpinEditNbJoursNonZippeExtract.Value);
    FichierINI.WriteInteger('Mode classique', 'Nombre de jours total EXTRACT', SpinEditNbJoursTotalExtract.Value);
    FichierINI.WriteInteger('Mode classique', 'Nombre de jours non zippé LOG', SpinEditNbJoursNonZippeLog.Value);
    FichierINI.WriteInteger('Mode classique', 'Nombre de jours total LOG', SpinEditNbJoursTotalLog.Value);
    FichierINI.WriteInteger('Mode classique', 'Nombre de jours LOGS', SpinEditNbJoursLogs.Value);
    FichierINI.WriteInteger('Mode changement de parc', 'Nombre de jours BATCH', _nNbJoursBatch);
    FichierINI.WriteInteger('Mode changement de parc', 'Nombre de jours EXTRACT', _nNbJoursExtract);
    FichierINI.WriteInteger('Mode changement de parc', 'Nombre de jours LOG', _nNbJoursLog);
    FichierINI.WriteInteger('Mode changement de parc', 'Nombre de jours LOGS', _nNbJoursLogs);
    FichierINI.WriteInteger('Paramètres', 'Taux de compression', SpinEditTauxCompression.Value);
    FichierINI.WriteInteger('Paramètres', 'Durée max traitement', SpinEditDureeMaxTraitement.Value);
  finally
    FichierINI.Free;
  end;
end;

end.

