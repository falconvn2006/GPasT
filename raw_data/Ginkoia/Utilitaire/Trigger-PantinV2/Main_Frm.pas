unit Main_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, IniFiles, ExtCtrls, StrUtils, DateUtils, Types, SqlTimSt,
  UThreadCalculStock;

type
  TEtatThread = (etMarche, etPause, etArret, etAttente, etErreur);

  // Information sur un exécutable
  TInfoSurExe = record
    FileDescription,
    CompanyName,
    FileVersion,
    InternalName,
    LegalCopyright,
    OriginalFileName,
    ProductName,
    ProductVersion    : string;
  end;

  TFrm_Main = class(TForm)
    Nbt_Parametrer: TBitBtn;
    Pan_Banniere: TPanel;
    Lab_Titre: TLabel;
    Pan_Boutons: TPanel;
    Nbt_Quitter: TBitBtn;
    Gp_Grille: TGridPanel;
    Pan_ListeBases: TPanel;
    Pan_EtatTraitement: TPanel;
    Pan_Horaires: TPanel;
    Pan_TraitementToutes: TPanel;
    Txt_Logs: TMemo;
    Lab_HeureDebut: TLabel;
    Lab_HeureFin: TLabel;
    Nbt_TraiterToutes: TBitBtn;
    SBx_ListeBases: TScrollBox;
    Tim_VerifTriggers: TTimer;
    Tim_Traitement: TTimer;
    Img_Etat: TImage;
    Img_Icone: TImage;
    procedure Nbt_ParametrerClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    // Affiche la liste des bases
    procedure AfficherBases();
    // Lance le calcul d'une base
    procedure Nbt_Demarrer(Sender: TObject);
    // Met en pause un calcul
    procedure Nbt_Pause(Sender: TObject);
    // Arrête le calcul d'un base
    procedure Nbt_Arret(Sender: TObject);
    // Démarre un thread
    function DemarrerThread(ADossId: Integer): Boolean;
    // Met en pause un thread
    function PauseThread(ADossId: Integer): Boolean;
    // Arrêt un thread
    function ArretThread(ADossId: Integer; ARollback: Boolean = False): Boolean;
    // Activer boutons thread
    procedure GererBoutons(ADossId: Integer; AActiver: TEtatThread = etMarche);
    // Changer le texte d'une base
    procedure ChangerLabelBase(ADossId: Integer; ATexte: String);
    // Procédure appellée à la fin d'un thread
    procedure FinCalcul(Sender: TObject);
    // Ajout un message au log
    procedure MessLog(AMessage: String);
    // Vérifie si des threads sont actifs
    function ThreadActif(): Integer;
    // Vérifie si un thread est actif sur une Lame
    function ThreadLame(ANomLame: String): Boolean;
    procedure Tim_VerifTriggersTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Nbt_TraiterToutesClick(Sender: TObject);
    procedure Tim_TraitementTimer(Sender: TObject);
  strict private
    { Déclarations privées }
  public
    { Déclarations publiques }
    // Récupère des informations sur un exécutable
    function InfoSurExe(AFichier: TFileName): TInfoSurExe;
  end;

const
  MOT_PASSE = '1082';

var
  Frm_Main: TFrm_Main;
  bTraitementsManuel: Boolean = False;
  bEnvoyerCourriel: Boolean = True;

implementation

uses ResStr, Parametres_Frm, MotPasse_Frm, Main_Dm;

{$R *.dfm}

// Affiche la liste des bases
procedure TFrm_Main.AfficherBases();
var
  BaseClient: TBaseClient;
  i: Integer;
  Pan_Base: TPanel;
  Lbl_NomBase, Lbl_Traites: TLabel;
  Btn_Demarre, Btn_Pause, Btn_Arret: TBitBtn;
begin
  Windows.LockWindowUpdate(SBx_ListeBases.Handle);
  try
    for i := Pred(SBx_ListeBases.ControlCount) downto 0 do
    begin
      SBx_ListeBases.Controls[i].Free();
    end;

    {$REGION 'Ajout des bases à la liste'}
    for BaseClient in BasesClient do
    begin
      if BaseClient.Utilisable then
      begin
        Pan_Base                      := TPanel.Create(Self);
        Pan_Base.Parent               := SBx_ListeBases;
        Pan_Base.Align                := alTop;
        Pan_Base.Height               := 41;
        Pan_Base.ShowCaption          := False;
        Pan_Base.Tag                  := BaseClient.Id;
        Pan_Base.Name                 := Format('Pan_Base%d', [BaseClient.Id]);
        Pan_Base.Caption              := '';

        Lbl_NomBase                   := TLabel.Create(Pan_Base);
        Lbl_NomBase.Parent            := Pan_Base;
        Lbl_NomBase.Align             := alLeft;
        Lbl_NomBase.AlignWithMargins  := True;
        Lbl_NomBase.Caption           := Format(RS_LABEL_BASE,
          [BaseClient.Nom, DateTimeToStr(BaseClient.DerniereDate), BaseClient.TempsMoyen]);
        Lbl_NomBase.Hint              := BaseClient.Chemin;
        Lbl_NomBase.Tag               := BaseClient.Id;
        Lbl_NomBase.ShowHint          := True;
        Lbl_NomBase.Name              := Format('Lbl_NomBase%d', [BaseClient.Id]);

        Lbl_Traites                   := TLabel.Create(Pan_Base);
        Lbl_Traites.Parent            := Pan_Base;
        Lbl_Traites.Align             := alRight;
        Lbl_Traites.AlignWithMargins  := True;
        Lbl_Traites.Caption           := RS_INFO_ETAT;
        Lbl_Traites.Font.Size         := 7;
        Lbl_Traites.Hint              := RS_INFO_LBL_TRAITES;
        Lbl_Traites.Tag               := BaseClient.Id;
        Lbl_Traites.ShowHint          := True;
        Lbl_Traites.Name              := Format('Lbl_Traites%d', [BaseClient.Id]);

        Btn_Demarre                   := TBitBtn.Create(Pan_Base);
        Btn_Demarre.Parent            := Pan_Base;
        Btn_Demarre.Width             := 22;
        Btn_Demarre.Height            := 22;
        Btn_Demarre.Glyph.LoadFromResourceName(HInstance, 'play');
        Btn_Demarre.NumGlyphs         := 2;
        Btn_Demarre.Anchors           := [akRight, akBottom];
        Btn_Demarre.Top               := Pan_Base.ClientHeight - 25;
        Btn_Demarre.Left              := Pan_Base.ClientWidth - 75;
        Btn_Demarre.Tag               := BaseClient.Id;
        Btn_Demarre.OnClick           := Nbt_Demarrer;
        Btn_Demarre.Name              := Format('Btn_Demarre%d', [BaseClient.Id]);
        Btn_Demarre.Caption           := '';
        Btn_Demarre.ShowHint          := True;
        Btn_Demarre.Hint              := RS_INFO_BTN_DEMARRAGE;

        Btn_Pause                     := TBitBtn.Create(Pan_Base);
        Btn_Pause.Parent              := Pan_Base;
        Btn_Pause.Width               := 22;
        Btn_Pause.Height              := 22;
        Btn_Pause.Glyph.LoadFromResourceName(HInstance, 'pause');
        Btn_Pause.NumGlyphs           := 2;
        Btn_Pause.Anchors             := [akRight, akBottom];
        Btn_Pause.Top                 := Pan_Base.ClientHeight - 25;
        Btn_Pause.Left                := Pan_Base.ClientWidth - 50;
        Btn_Pause.Tag                 := BaseClient.Id;
        Btn_Pause.OnClick             := Nbt_Pause;
        Btn_Pause.Enabled             := False;
        Btn_Pause.Name                := Format('Btn_Pause%d', [BaseClient.Id]);
        Btn_Pause.Caption             := '';
        Btn_Pause.ShowHint            := True;
        Btn_Pause.Hint                := RS_INFO_BTN_PAUSE;

        Btn_Arret                     := TBitBtn.Create(Pan_Base);
        Btn_Arret.Parent              := Pan_Base;
        Btn_Arret.Width               := 22;
        Btn_Arret.Height              := 22;
        Btn_Arret.Glyph.LoadFromResourceName(HInstance, 'stop');
        Btn_Arret.NumGlyphs           := 2;
        Btn_Arret.Anchors             := [akRight, akBottom];
        Btn_Arret.Top                 := Pan_Base.ClientHeight - 25;
        Btn_Arret.Left                := Pan_Base.ClientWidth - 25;
        Btn_Arret.Tag                 := BaseClient.Id;
        Btn_Arret.OnClick             := Nbt_Arret;
        Btn_Arret.Enabled             := False;
        Btn_Arret.Name                := Format('Btn_Arret%d', [BaseClient.Id]);
        Btn_Arret.Caption             := '';
        Btn_Arret.ShowHint            := True;
        Btn_Arret.Hint                := RS_INFO_BTN_ARRET;
      end;
    end;
    {$ENDREGION 'Ajout des bases à la liste'}
  finally
    Windows.LockWindowUpdate(0);
  end;
end;

procedure TFrm_Main.FormClose(Sender: TObject; var Action: TCloseAction);
var
  iNbThreads: Integer;
begin
  // Vérifie si des threads sont en route avant d'arrêter
  iNbThreads := ThreadActif();
  if iNbThreads = 1 then
  begin
    MessageDlg(RS_ERR_THREAD_EN_COURS, mtWarning, [mbOk], 0);
    Action := caNone;
  end
  else if iNbThreads > 1 then
  begin
    MessageDlg(Format(RS_ERR_THREADS_EN_COURS, [iNbThreads]), mtWarning, [mbOk], 0);
    Action := caNone;
  end
  else begin
    MessLog(RS_INFO_ARRET_LOG);
    Action := caFree;
  end;
end;

procedure TFrm_Main.FormCreate(Sender: TObject);
var
  InfoExe: TInfoSurExe;
begin
  // Charge les icones des boutons
  Nbt_TraiterToutes.Glyph.LoadFromResourceName(HInstance, 'drapeau');
  Nbt_TraiterToutes.Enabled := not(FindCmdLineSwitch('AUTO'));
  Nbt_Parametrer.Glyph.LoadFromResourceName(HInstance, 'horloge');
  Img_Icone.Picture.Icon.Handle := LoadImage(HInstance, 'MAINICON', IMAGE_ICON, 48, 48, LR_DEFAULTCOLOR);
  InfoExe           := InfoSurExe(Application.ExeName);
  Self.Caption      := Format('%s - version %s', [InfoExe.ProductName, InfoExe.FileVersion]);
  Lab_Titre.Caption := Self.Caption;

  if Dm_Main.Connexion() then
  begin
    Dm_Main.ChargerListeBases();
    AfficherBases();
  end;

  Lab_HeureDebut.Caption  := Format(RS_LABEL_DEBUT, [TimeToStr(tHeureDebut)]);
  Lab_HeureFin.Caption    := Format(RS_LABEL_FIN, [TimeToStr(tHeureFin)]);
end;

procedure TFrm_Main.FormShow(Sender: TObject);
begin
  MessLog(RS_INFO_DEMARRAGE_LOG);
end;

// Lance le calcul d'une base
procedure TFrm_Main.Nbt_Demarrer(Sender: TObject);
begin
  DemarrerThread(TWinControl(Sender).Tag);
end;

// Met en pause un calcul
procedure TFrm_Main.Nbt_Pause(Sender: TObject);
begin
  PauseThread(TWinControl(Sender).Tag);
end;

procedure TFrm_Main.Nbt_TraiterToutesClick(Sender: TObject);
begin
  // Lancement du calcul de toutes les bases
  bTraitementsManuel        := True;
  bEnvoyerCourriel          := True;
  Tim_Traitement.Enabled    := True;
  Nbt_TraiterToutes.Enabled := False;
end;

// Arrête le calcul d'un base
procedure TFrm_Main.Nbt_Arret(Sender: TObject);
begin
  if GetAsyncKeyState(VK_SHIFT) <> 0 then
    ArretThread(TWinControl(Sender).Tag, True)
  else
    ArretThread(TWinControl(Sender).Tag);
end;

// Démarre un thread
function TFrm_Main.DemarrerThread(ADossId: Integer): Boolean;

  function LblTraitesDossier(ADossId: Integer): TLabel;
  var
    i, j: Integer;
  begin
    Result := nil;

    // Parcours tout les composants pour récupérer le bon TLabel
    for i := 0 to SBx_ListeBases.ControlCount - 1 do
    begin
      if SameText(SBx_ListeBases.Controls[i].Name, Format('Pan_Base%d', [ADossId])) then
      begin
        for j := 0 to TPanel(SBx_ListeBases.Controls[i]).ControlCount - 1 do
        begin
          if TPanel(SBx_ListeBases.Controls[i]).Components[j].Name = Format('Lbl_Traites%d', [ADossId]) then
          begin
            Result := TLabel(TPanel(SBx_ListeBases.Controls[i]).Components[j]);
            Break;
          end;
        end;
      end;
    end;
  end;

var
  i, j: Integer;
  iThreadId: Integer;
  LblTraites: TLabel;
begin
  Result := False;

  // Parcours toutes les bases clients
  for i := 0 to Length(BasesClient) do
  begin
    // S'il s'agit de la bonne base : lancement du thread
    if BasesClient[i].Id = ADossId then
    begin
      // Si le thread n'est pas actif : on le créer
      if BasesClient[i].ThreadId = -1 then
      begin
        // Vérifie s'il y a déjà des threads sur cette Lame
        if not(ThreadLame(LeftStr(BasesClient[i].Chemin, Pos(':', BasesClient[i].Chemin) - 1))) then
        begin
          for j := 0 to inbThread - 1 do
          begin
            if not(Assigned(ThsCalculStock[j]))
              or (ThsCalculStock[j].Finished) then
            begin
              MessLog(Format(RS_INFO_DEMARRAGE, [BasesClient[i].Nom, BasesClient[i].Chemin]));
              BasesClient[i].ThreadId           := j;
              ThsCalculStock[j]                 := TThreadCalculStock.Create(True);
              ThsCalculStock[j].Id              := BasesClient[i].Id;
              ThsCalculStock[j].Nom             := BasesClient[i].Nom;
              ThsCalculStock[j].Chemin          := BasesClient[i].Chemin;
              ThsCalculStock[j].TempsMoyen      := BasesClient[i].TempsMoyen;
              ThsCalculStock[j].DerniereDate    := BasesClient[i].DerniereDate;
              ThsCalculStock[j].Annuler         := False;
              ThsCalculStock[j].LblTraites      := LblTraitesDossier(BasesClient[i].Id);
              ThsCalculStock[j].OnTerminate     := FinCalcul;
              ThsCalculStock[j].Start();
              Result := True;
              GererBoutons(BasesClient[i].Id);
              Break;
            end;
          end;
          if not(Result) then
          begin
            MessLog(RS_ERR_NB_RECALC_MAX);
            Exit;
          end;
        end
        else begin
          // S'il y a déjà un calcul sur la Lame
          MessLog(Format(RS_ERR_CALCUL_LAME, [LeftStr(BasesClient[i].Chemin, Pos(':', BasesClient[i].Chemin) - 1)]));
          Break;
        end;
      end
      // Si le thread existe déjà, on le relance
      else begin
        // Récupération du numéro de thread
        iThreadId := BasesClient[i].ThreadId;

        if ThsCalculStock[iThreadId].Suspended then
        begin
          MessLog(Format(RS_INFO_REPRISE, [BasesClient[i].Nom, BasesClient[i].Chemin]));
          ThsCalculStock[iThreadId].Resume();
          Result := True;
          GererBoutons(BasesClient[i].Id);
        end
        else begin
          MessLog(RS_ERR_CALCUL_EN_COURS);
        end;
      end;
      Break;
    end;
  end;
end;

// Met en pause un thread
function TFrm_Main.PauseThread(ADossId: Integer): Boolean;
var
  i: Integer;
  iThreadId: Integer;
begin
  Result := False;
  // Parcours toutes les bases clients
  for i := 0 to Length(BasesClient) - 1 do
  begin
    // S'il s'agit de la bonne base : arrêt du thread
    if BasesClient[i].Id = ADossId then
    begin
      // Récupération du numéro de thread
      iThreadId := BasesClient[i].ThreadId;
      if Assigned(ThsCalculStock[iThreadId])
        and not(ThsCalculStock[iThreadId].Finished) then
      begin
        MessLog(Format(RS_INFO_PAUSE, [ThsCalculStock[iThreadId].Nom, ThsCalculStock[iThreadId].Chemin]));
        ThsCalculStock[iThreadId].Suspend();
        GererBoutons(BasesClient[i].Id, etPause);
      end;
    end;
  end;
end;

// Arrêt un thread
function TFrm_Main.ArretThread(ADossId: Integer; ARollback: Boolean = False): Boolean;
var
  i: Integer;
  iThreadId: Integer;
begin
  Result := False;
  // Parcours toutes les bases clients
  for i := 0 to Length(BasesClient) - 1 do
  begin
    // S'il s'agit de la bonne base : arrêt du thread
    if BasesClient[i].Id = ADossId then
    begin
      // Récupération du numéro de thread
      iThreadId := BasesClient[i].ThreadId;
      if Assigned(ThsCalculStock[iThreadId])
        and not(ThsCalculStock[iThreadId].Finished) then
      begin
        if not(ARollback) then
          MessLog(Format(RS_INFO_ARRET, [ThsCalculStock[iThreadId].Nom, ThsCalculStock[iThreadId].Chemin]))
        else
          MessLog(Format(RS_INFO_ANNULATION, [ThsCalculStock[iThreadId].Nom, ThsCalculStock[iThreadId].Chemin]));

        ThsCalculStock[iThreadId].Annuler := ARollback;
        ThsCalculStock[iThreadId].Terminate();

        // Si le thread est en pause : on le relance
        if ThsCalculStock[iThreadId].Suspended then
          ThsCalculStock[iThreadId].Resume();

        BasesClient[i].ThreadId := -1;
        GererBoutons(BasesClient[i].Id, etAttente);
      end;
    end;
  end;
end;

// Activer boutons thread
procedure TFrm_Main.GererBoutons(ADossId: Integer; AActiver: TEtatThread = etMarche);
var
  i, j: Integer;
begin
  // Parcours tout les composants pour les activer/désactiver
  for i := 0 to SBx_ListeBases.ControlCount - 1 do
  begin
    if SameText(SBx_ListeBases.Controls[i].Name, Format('Pan_Base%d', [ADossId])) then
    begin
      for j := 0 to TPanel(SBx_ListeBases.Controls[i]).ControlCount - 1 do
      begin
        if SameText(TPanel(SBx_ListeBases.Controls[i]).Components[j].Name, Format('Btn_Demarre%d', [ADossId])) then
          TBitBtn(TPanel(SBx_ListeBases.Controls[i]).Components[j]).Enabled := AActiver in [etPause, etArret, etErreur];

        if SameText(TPanel(SBx_ListeBases.Controls[i]).Components[j].Name, Format('Btn_Pause%d', [ADossId])) then
          TBitBtn(TPanel(SBx_ListeBases.Controls[i]).Components[j]).Enabled := AActiver in [etMarche];

        if SameText(TPanel(SBx_ListeBases.Controls[i]).Components[j].Name, Format('Btn_Arret%d', [ADossId])) then
          TBitBtn(TPanel(SBx_ListeBases.Controls[i]).Components[j]).Enabled := AActiver in [etMarche, etPause];

        if SameText(TPanel(SBx_ListeBases.Controls[i]).Components[j].Name, Format('Lbl_NomBase%d', [ADossId])) then
        begin
          if AActiver = etErreur then
          begin
            TLabel(TPanel(SBx_ListeBases.Controls[i]).Components[j]).Font.Color  := clRed;
            TLabel(TPanel(SBx_ListeBases.Controls[i]).Components[j]).Font.Style  := [fsBold];
          end
          else
          begin
            TLabel(TPanel(SBx_ListeBases.Controls[i]).Components[j]).Font.Color  := clWindowText;
            TLabel(TPanel(SBx_ListeBases.Controls[i]).Components[j]).Font.Style  := [];
          end;
        end;
      end;
    end;
  end;
end;

// Changer le texte d'une base
procedure TFrm_Main.ChangerLabelBase(ADossId: Integer; ATexte: String);
var
  i, j: Integer;
begin
  // Parcours tout les composants pour les activer/désactiver
  for i := 0 to SBx_ListeBases.ControlCount - 1 do
  begin
    if SameText(SBx_ListeBases.Controls[i].Name, Format('Pan_Base%d', [ADossId])) then
    begin
      for j := 0 to TPanel(SBx_ListeBases.Controls[i]).ControlCount - 1 do
      begin
        if TPanel(SBx_ListeBases.Controls[i]).Components[j].Name = Format('Lbl_NomBase%d', [ADossId]) then
          TLabel(TPanel(SBx_ListeBases.Controls[i]).Components[j]).Caption := ATexte;
      end;
    end;
  end;
end;

// Procédure appellée à la fin d'un thread
procedure TFrm_Main.FinCalcul(Sender: TObject);
var
  i: Integer;
begin
  // Indique que le thread est terminé
  for i := 0 to Length(BasesClient) - 1 do
  begin
    if BasesClient[i].Id = TThreadCalculStock(Sender).Id then
    begin
      BasesClient[i].ThreadId     := -1;
      BasesClient[i].TempsMoyen   := TThreadCalculStock(Sender).TempsMoyen;
      BasesClient[i].DerniereDate := TThreadCalculStock(Sender).DerniereDate;
      // Si on est en train de traiter toutes les bases en manuel : on bloque le retraitement
      if bTraitementsManuel then
        BasesClient[i].Utilisable := False
      else
        // Si on est en traitement automatique, on rebloque le retraitement s'il y a eu une erreur
        BasesClient[i].Utilisable := not(TThreadCalculStock(Sender).Erreur);
    end;
  end;

  if not(TThreadCalculStock(Sender).Erreur) then
    GererBoutons(TThreadCalculStock(Sender).Id, etArret)
  else
    GererBoutons(TThreadCalculStock(Sender).Id, etErreur);

  if not(TThreadCalculStock(Sender).Erreur or TThreadCalculStock(Sender).Annuler) then
  begin
    MessLog(Format(RS_INFO_FIN_CALCUL, [TThreadCalculStock(Sender).Nom, TThreadCalculStock(Sender).Chemin]));
    MessLog(Format(RS_INFO_TEMPS_TRAITEMENT, [TThreadCalculStock(Sender).TempsTraitement]));

    // Enregistre les temps
    try
      if Dm_Main.CDS_Dossier.Locate('DOSS_ID', TThreadCalculStock(Sender).Id, []) then
      begin
        Dm_Main.CDS_Dossier.Edit();
        Dm_Main.CDS_Dossier.FieldByName('DOSS_RECALTEMPS').AsInteger      := TThreadCalculStock(Sender).TempsMoyen;
        Dm_Main.CDS_Dossier.FieldByName('DOSS_RECALLASTDATE').AsDateTime  := TThreadCalculStock(Sender).DerniereDate;
        Dm_Main.CDS_Dossier.Post();
      end;
    except
      on E: Exception do
      begin
        MessLog(Format(RS_ERR_ENR_DATE_TRAIT, [E.ClassName, E.Message]));
      end;
    end;

    // Enregistrement dans la maintenance

//    if not(Dm_Main.EnregistrerDossier(TThreadCalculStock(Sender).Id)) then
//      MessLog(RS_ERR_ENR_BASE_MAINT)
//    else if not(FindCmdLineSwitch('BASE') or FindCmdLineSwitch('LISTE')) then
//      MessLog(RS_INFO_ENR_BASE_MAINT);

    ChangerLabelBase(TThreadCalculStock(Sender).Id, Format(RS_LABEL_BASE,
      [TThreadCalculStock(Sender).Nom, DateTimeToStr(TThreadCalculStock(Sender).DerniereDate),
        TThreadCalculStock(Sender).TempsMoyen]));
  end
  else begin
    if TThreadCalculStock(Sender).Erreur then
      MessLog(Format(RS_ERR_CALCUL_STOCK,
        [TThreadCalculStock(Sender).Nom, TThreadCalculStock(Sender).ErreurMessage]))
    else
      MessLog(Format(RS_INFO_ANNULE_CALCUL, [TThreadCalculStock(Sender).Nom, TThreadCalculStock(Sender).Chemin]));
  end;
end;

// Ajout un message au log
procedure TFrm_Main.MessLog(AMessage: String);
var
  sRepertoire, sNomFichier: String;
  slFichierLog: TStringList;
begin
  // Ajout le message au Log
  Txt_Logs.Lines.Add(Format('%s - %s', [FormatDateTime('hh:nn:ss.zzz', Now()), AMessage]));

  {$REGION 'Enregistrement dans le fichier de Log'}
  slFichierLog := TStringList.Create();
  try
    sRepertoire := ExtractFilePath(Application.ExeName) + 'Logs\';
    if not(DirectoryExists(sRepertoire)) then
      ForceDirectories(sRepertoire);

    sNomFichier := Format('%sLog_%s-%s.log', [sRepertoire,
      ChangeFileExt(ExtractFileName(Application.ExeName), ''),
      FormatDateTime('yyyy-mm-dd', Now())]);

    if FileExists(sNomFichier) then
      slFichierLog.LoadFromFile(sNomFichier);

    slFichierLog.Add(Format('%s - %s', [FormatDateTime('hh:nn:ss.zzz', Now()), AMessage]));

    slFichierLog.SaveToFile(sNomFichier);
  finally
    slFichierLog.Free();
  end;
  {$ENDREGION 'Enregistrement dans le fichier de Log'}
end;

// Vérifie si des threads sont actifs
function TFrm_Main.ThreadActif(): Integer;
var
  ThCalculStock: TThreadCalculStock;
begin
  Result := 0;
  for ThCalculStock in ThsCalculStock do
  begin
    if Assigned(ThCalculStock) and not(ThCalculStock.Finished) then
    begin
      Inc(Result);
    end;
  end;
end;

// Vérifie si un thread est actif sur une Lame
function TFrm_Main.ThreadLame(ANomLame: String): Boolean;
var
  ThCalculStock: TThreadCalculStock;
begin
  Result := False;

  for ThCalculStock in ThsCalculStock do
  begin
    if Assigned(ThCalculStock) and not(ThCalculStock.Finished) then
    begin
      // Vérifie si le chemin contient le même nom de Lame
      if StartsText(Format('%s:', [ANomLame]), ThCalculStock.Chemin) then
      begin
        Result := True;
        Break;
      end;
    end;
  end;
end;

procedure TFrm_Main.Nbt_ParametrerClick(Sender: TObject);
var
  IniParametres: TIniFile;
  i: Integer;
begin
  {$REGION 'Vérifie le mot de passe'}
  if ThreadActif() > 0 then
    Exit;

  Application.CreateForm(TFrm_MotPasse, Frm_MotPasse);
  try
    if Frm_MotPasse.ShowModal() = mrOk then
    begin
      if not(AnsiSameStr(Frm_MotPasse.Txt_MotPasse.Text, MOT_PASSE)) then
      begin
        MessageDlg(RS_ERR_MOT_PASSE, mtError, [mbOk], 0);
        Exit;
      end;
    end
    else
      Exit;
  finally
    Frm_MotPasse.Free();
  end;
  {$ENDREGION 'Vérifie le mot de passe'}

  {$REGION 'Ouvre la fenêtre de paramétrage'}
  Application.CreateForm(TFrm_Parametres, Frm_Parametres);
  IniParametres := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  try
    // Charge les valeurs du fichier Ini
    Frm_Parametres.Txt_Chemin.Text                  := IniParametres.ReadString('Parametres', 'Chemin', 'D:\Eai\Maintenance.ib');
    Frm_Parametres.Txt_Utilisateur.Text             := IniParametres.ReadString('Parametres', 'Utilisateur', 'ginkoia');
    Frm_Parametres.Txt_MotPasse.Text                := IniParametres.ReadString('Parametres', 'MotPasse', 'ginkoia');
    Frm_Parametres.Chp_NbThreads.Value              := IniParametres.ReadInteger('Parametres', 'NbThreads', 1);
    Frm_Parametres.Dtp_HeureDebut.Time              := IniParametres.ReadTime('Parametres', 'HeureDebut', StrToTime('14:00'));
    Frm_Parametres.Dtp_HeureFin.Time                := IniParametres.ReadTime('Parametres', 'HeureFin', StrToTime('16:00'));

    Frm_Parametres.Txt_ServeurSMTP.Text             := IniParametres.ReadString('SMTP', 'Serveur', CONST_SMTP_SERVEUR);
    Frm_Parametres.Txt_UtilisateurSMTP.Text         := IniParametres.ReadString('SMTP', 'Utilisateur', CONST_SMTP_UTILISATEUR);
    Frm_Parametres.Txt_MotPasseSMTP.Text            := IniParametres.ReadString('SMTP', 'MotPasse', CONST_SMTP_MOTPASSE);
    Frm_Parametres.Chp_PortSMTP.Value               := IniParametres.ReadInteger('SMTP', 'Port', CONST_SMTP_PORT);
    Frm_Parametres.Chk_TLSSMTP.Checked              := IniParametres.ReadBool('SMTP', 'TLS', CONST_SMTP_TLS);
    Frm_Parametres.Txt_AdresseExpediteurSMTP.Text   := IniParametres.ReadString('SMTP', 'Expediteur', CONST_SMTP_EXPEDITEUR);
    Frm_Parametres.Txt_AdresseDestinataireSMTP.Text := IniParametres.ReadString('SMTP', 'Destinataire', CONST_SMTP_DESTINATAIRE);
    Frm_Parametres.Chk_EnvoiSMTP.Checked            := IniParametres.ReadBool('SMTP', 'Envoyer', CONST_SMTP_ENVOYER);

    IniParametres.ReadSectionValues('DossiersExclus', slListeExclus);

    for i := 0 to slListeExclus.Count - 1 do
      Frm_Parametres.Txt_DossiersExclus.Lines.Add(slListeExclus.ValueFromIndex[i]);

    if Frm_Parametres.ShowModal() = mrOk then
    begin
      IniParametres.WriteString('Parametres', 'Chemin', Frm_Parametres.Txt_Chemin.Text);
      IniParametres.WriteString('Parametres', 'Utilisateur', Frm_Parametres.Txt_Utilisateur.Text);
      IniParametres.WriteString('Parametres', 'MotPasse', Frm_Parametres.Txt_MotPasse.Text);
      IniParametres.WriteInteger('Parametres', 'NbThreads', Frm_Parametres.Chp_NbThreads.Value);
      IniParametres.WriteTime('Parametres', 'HeureDebut', Frm_Parametres.Dtp_HeureDebut.Time);
      IniParametres.WriteTime('Parametres', 'HeureFin', Frm_Parametres.Dtp_HeureFin.Time);

      IniParametres.WriteString('SMTP', 'Serveur', Frm_Parametres.Txt_ServeurSMTP.Text);
      IniParametres.WriteString('SMTP', 'Utilisateur', Frm_Parametres.Txt_UtilisateurSMTP.Text);
      IniParametres.WriteString('SMTP', 'MotPasse', Frm_Parametres.Txt_MotPasseSMTP.Text);
      IniParametres.WriteInteger('SMTP', 'Port', Frm_Parametres.Chp_PortSMTP.Value);
      IniParametres.WriteBool('SMTP', 'TLS', Frm_Parametres.Chk_TLSSMTP.Checked);
      IniParametres.WriteString('SMTP', 'Expediteur', Frm_Parametres.Txt_AdresseExpediteurSMTP.Text);
      IniParametres.WriteString('SMTP', 'Destinataire', Frm_Parametres.Txt_AdresseDestinataireSMTP.Text);
      IniParametres.WriteBool('SMTP', 'Envoyer', Frm_Parametres.Chk_EnvoiSMTP.Checked);

      IniParametres.EraseSection('DossiersExclus');
      for i := 0 to Frm_Parametres.Txt_DossiersExclus.Lines.Count - 1 do
        IniParametres.WriteString('DossiersExclus', Format('Dossier%d', [i]), Frm_Parametres.Txt_DossiersExclus.Lines[i]);

      if Dm_Main.Connexion() then
      begin
        Dm_Main.ChargerListeBases();
        AfficherBases();
      end;

      Lab_HeureDebut.Caption  := Format('Début : %s', [TimeToStr(tHeureDebut)]);
      Lab_HeureFin.Caption    := Format('Fin : %s', [TimeToStr(tHeureFin)]);
    end;
  finally
    IniParametres.Free();
    Frm_Parametres.Free();
  end;
  {$ENDREGION 'Ouvre la fenêtre de paramétrage'}
end;

procedure TFrm_Main.Tim_TraitementTimer(Sender: TObject);
var
  i, iDossId: Integer;
  dtDateAncienne: TDateTime;
begin
  iDossId := -1;

  if not(bTraitementsManuel) then
    dtDateAncienne := Today()
  else
    dtDateAncienne := Tomorrow();

  // Vérifie que tous les threads ne sont pas pris
  if inbThread > ThreadActif() then
  begin
    // Parcours toutes les bases
    for i := 0 to Length(BasesClient) - 1 do
    begin
      // Si la base est utilisable, que le calcul n'est pas déjà actif
      if (BasesClient[i].Utilisable) and (BasesClient[i].ThreadId = -1) then
      begin
        // S'il n'y a pas de calcul sur cette Lame
        if not(ThreadLame(LeftStr(BasesClient[i].Chemin, Pos(':', BasesClient[i].Chemin) - 1))) then
        begin
          // Si le temps de calcul moyen ne dépasse pas l'heure de fin
          if (CompareTime(IncSecond(Now(), BasesClient[i].TempsMoyen) , tHeureFin) = LessThanValue)
            or bTraitementsManuel then
          begin
            // Si la date du dernier traitement est la plus ancienne actuellement trouvée
            if (CompareDateTime(BasesClient[i].DerniereDate, dtDateAncienne) = LessThanValue) then
            begin
              // Enregistrement comme possible base à traiter
              iDossId         := BasesClient[i].Id;
              dtDateAncienne  := BasesClient[i].DerniereDate;
            end;
          end;
        end;
      end;
    end;
  end;

  // Si une base a été trouvée : on lance le calcul
  if iDossId > -1 then
  begin
    Img_Etat.Picture.Bitmap.LoadFromResourceName(HInstance, 'vert');
    Img_Etat.Hint := RS_INFO_ACTIF;

    DemarrerThread(iDossId);
  end
  else begin
    // S'il n'y a aucune base à traiter
    if ThreadActif() = 0 then
    begin
      Img_Etat.Picture.Bitmap.LoadFromResourceName(HInstance, 'orange');
      Img_Etat.Hint     := RS_INFO_AUCUNE_BASE;

      Dm_Main.EnregistrerTousLesDossier;

      // Envoye le courriel de rapport
      if DM_Main.EnvoyerSMTP and bEnvoyerCourriel then
      begin
        Dm_Main.ObjetSMTP   := Format(RS_COURRIEL_TITRE, [GetEnvironmentVariable('COMPUTERNAME')]);
        Dm_Main.ContenuSMTP := Format(RS_COURRIEL_MESSAGE, [GetEnvironmentVariable('COMPUTERNAME'), Txt_Logs.Text]);

        Dm_Main.EnvoiCourriel();

        bEnvoyerCourriel  := False;
      end;
    end;
  end;
end;

procedure TFrm_Main.Tim_VerifTriggersTimer(Sender: TObject);
begin
  Nbt_Parametrer.Enabled := (ThreadActif() = 0);

  Tim_Traitement.Enabled := (TimeInRange(Now(), tHeureDebut, tHeureFin) and FindCmdLineSwitch('AUTO')) or bTraitementsManuel;

  if not(Tim_Traitement.Enabled) and FindCmdLineSwitch('AUTO') then
  begin
    Img_Etat.Picture.Bitmap.LoadFromResourceName(HInstance, 'rouge');
    Img_Etat.Hint := RS_INFO_INACTIF;
  end;

  // Si l'heure de fin est dépassée : on ferme si tout les calculs sont fini
  if FindCmdLineSwitch('AUTO') and (CompareTime(Now(), tHeureFin) = GreaterThanValue) then
    if ThreadActif() = 0 then
      Self.Close();
end;

function TFrm_Main.InfoSurExe(AFichier: TFileName): TInfoSurExe;
const
  VersionInfo: array [1..8] of String =
    ('FileDescription', 'CompanyName', 'FileVersion',
    'InternalName', 'LegalCopyRight', 'OriginalFileName',
    'ProductName', 'ProductVersion');
var
  Handle    : DWord;
  Info      : Pointer;
  InfoData  : Pointer;
  InfoSize  : Longint;
  DataLen   : UInt;
  LangPtr   : Pointer;
  InfoType  : String;
  i         : Integer;
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
      begin
        repeat
          // Spécifie le type d'information à récupérer
          InfoType := VersionInfo[i];

          if VerQueryValue(Info, '\VarFileInfo\Translation',
            LangPtr, DataLen) then
          begin
            InfoType := Format('\StringFileInfo\%0.4x%0.4x\%s'#0,
              [LoWord(Longint(LangPtr^)), HiWord(Longint(LangPtr^)),
              InfoType]);
          end;

            // Remplit la variable de retour
          if VerQueryValue(Info, @InfoType[1], InfoData, DataLen) then
          begin
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
          end;

          // Incrémente i
          Inc(i);
        until i >= 8;
      end;
    finally
      // Libère la mémoire
      FreeMem(Info, InfoSize);
    end;
  end;
end;

end.
