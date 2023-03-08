unit MigrationReferentiel.Form.Principale;

interface

uses
  Winapi.Windows,
  Winapi.ShellApi,
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.Win.Registry,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.TabControl,
  FMX.Edit,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.ListBox,
  FMX.Layouts,
  FMX.EditBox,
  FMX.NumberBox,
  FMX.Objects,
  MigrationReferentiel.Ressources,
  MigrationReferentiel.Thread.Extraction,
  MigrationReferentiel.Thread.Correspondances,
  MigrationReferentiel.Thread.MiseAJour;

type
  TFormPrincipale = class(TForm)
    Tc_Etapes: TTabControl;
    Tab_Extraction: TTabItem;
    Tab_Correspondances: TTabItem;
    Tab_MiseAJour: TTabItem;
    Lbl_TypeReferentiel: TLabel;
    Cmb_TypeReferentiel: TComboBox;
    Lbl_FichierExtraction: TLabel;
    Txt_FichierExtraction: TEdit;
    Lbl_ExtractionInfo: TLabel;
    Btn_Extraire: TButton;
    Grid_Haut: TGridPanelLayout;
    Lbl_BaseDonnees: TLabel;
    Grid_Extraction: TGridPanelLayout;
    Btn_FichierExtraction: TEllipsesEditButton;
    GridBase: TGridPanelLayout;
    Cmb_TypeConnexion: TComboBox;
    Txt_BaseDonnees: TEdit;
    Btn_BaseDonnees: TEllipsesEditButton;
    Txt_Serveur: TEdit;
    Txt_Port: TNumberBox;
    Grid_Correspondances: TGridPanelLayout;
    Txt_FichierReferentiel: TEdit;
    Btn_FichierReferentiel: TEllipsesEditButton;
    Lbl_FichierReferentiel: TLabel;
    Btn_Enregistrer: TButton;
    Lbl_FichierExcel: TLabel;
    Txt_FichierExcel: TEdit;
    Btn_FichierExcel: TEllipsesEditButton;
    Rec_Referentiel: TRectangle;
    Chk_OuvrirReferentiel: TCheckBox;
    Lbl_CorrespondancesInfo: TLabel;
    Grid_Statut: TGridPanelLayout;
    Lbl_Statut: TLabel;
    Pb_Statut: TProgressBar;
    Lbl_MiseAJourInfo: TLabel;
    Grid_MiseAJour: TGridPanelLayout;
    Lbl_MAJExcel: TLabel;
    Txt_MAJExcel: TEdit;
    Btn_MAJExcel: TEllipsesEditButton;
    Lbl_MAJArticle: TLabel;
    Txt_MAJArticle: TEdit;
    Btn_MAJArticle: TEllipsesEditButton;
    Btn_MiseAJour: TButton;
    Rect_MiseAJour: TRectangle;
    Chk_MAJMajuscule: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Journaliser(const AMessage: string; const ANiveau: TNiveauLog = NivNotice);
    procedure OuvrirJournal();
    procedure Progression(const AStatut: string; const APosition: Integer = -1; const AMax: Integer = -1);
    procedure Cmb_TypeConnexionChange(Sender: TObject);
    procedure Btn_BaseDonneesClick(Sender: TObject);
    procedure Cmb_TypeReferentielChange(Sender: TObject);
    procedure Btn_FichierExtractionClick(Sender: TObject);
    procedure Btn_ExtraireClick(Sender: TObject);
    procedure Btn_FichierReferentielClick(Sender: TObject);
    procedure Btn_FichierExcelClick(Sender: TObject);
    procedure Btn_EnregistrerClick(Sender: TObject);
    procedure Btn_MAJExcelClick(Sender: TObject);
    procedure Btn_MAJArticleClick(Sender: TObject);
    procedure Btn_MiseAJourClick(Sender: TObject);
    procedure ActiverComposant(const AEtat: Boolean = True);
  strict private
    { Déclarations strictement privées }
    bThreadEnCours, bInterruption: Boolean;
    ThreadExtraction             : TThreadExtraction;
    ThreadCorrespondances        : TThreadCorrespondances;
    ThreadMiseAJour              : TThreadMiseAJour;
  public
    { Déclarations publiques }
    // 1 - Extraction référentiels de référence
    procedure DemarrerThreadExtraction();
    procedure ArreterThreadExtraction();
    procedure FinThreadExtraction(Sender: TObject);
    // 2 - Correspondances référentiels
    procedure DemarrerThreadCorrespondances();
    procedure ArreterThreadCorrespondances();
    procedure FinThreadCorrespondances(Sender: TObject);
    // 3 - Mise à jour référentiels avant migration
    procedure DemarrerThreadMiseAJour();
    procedure ArreterThreadMiseAJour();
    procedure FinThreadMiseAJour(Sender: TObject);
  end;

var
  FormPrincipale: TFormPrincipale;

implementation

{$R *.fmx}

procedure TFormPrincipale.FormCreate(Sender: TObject);
const
  REG_GINKOIA_ROOT: DWORD = HKEY_LOCAL_MACHINE;
  RES_REG_GINKOIA_PATH    = '\SOFTWARE\Algol\Ginkoia';
  RES_REG_GINKOIA_KEY     = 'Base0';
var
  Registre: TRegistry;
begin
  // Modifie le titre
  Self.Caption := Format('%s - version %s', [InfoSurExe(ParamStr(0)).FileDescription,
      InfoSurExe(ParamStr(0)).FileVersion]);

  // Désactive le clavier virtuel
  VKAutoShowMode := TVKAutoShowMode.Never;

  // Vérifie que Excel est bien installé
  if not ApplicationInstalled('Excel.Application') then
    // if MessageDlg(RS_DLG_ERREUR_EXCEL, TMsgDlgType.mtWarning, mbYesNo, 0) <> mrYes then
    if TaskDialog(0, RS_MSG_WARNING, RS_DLG_ERREUR_EXCEL, RS_DLG_ERREUR_EXCEL_MSG, TD_ICON_QUESTION, TD_BUTTON_YESNO) = TD_RESULT_NO
    then
      Application.Terminate();

  // Charge le chemin de la base de données par défaut
  Registre := TRegistry.Create(KEY_READ);
  try
    Registre.RootKey := REG_GINKOIA_ROOT;
    if Registre.OpenKey(RES_REG_GINKOIA_PATH, False) then
    begin
      Txt_BaseDonnees.Text := Registre.ReadString(RES_REG_GINKOIA_KEY);

      // Charge des noms de fichiers par défaut
      Cmb_TypeReferentielChange(Cmb_TypeReferentiel);
    end;
  finally
    Registre.Free();
  end;
end;

procedure TFormPrincipale.FormDestroy(Sender: TObject);
begin
  // Libère les threads
  FreeAndNil(ThreadExtraction);
  FreeAndNil(ThreadCorrespondances);
end;

procedure TFormPrincipale.Journaliser(const AMessage: string; const ANiveau: TNiveauLog = NivNotice);
var
  sRepertoire : TFileName;
  sNomFichier : TFileName;
  sNiveau     : string;
  slFichierLog: TStringList;
begin
  // Récupération du niveau
  case ANiveau of
    NivTrace:
      sNiveau := RS_LOG_TRACE;
    NivNotice:
      sNiveau := RS_LOG_NOTICE;
    NivErreur:
      sNiveau := RS_LOG_ERREUR;
    NivArret:
      sNiveau := RS_LOG_ARRET;
  end;

  slFichierLog := TStringList.Create();
  try
    sRepertoire := ExtractFilePath(ParamStr(0)) + 'Logs\';
    if not(DirectoryExists(sRepertoire)) then
      ForceDirectories(sRepertoire);

    sNomFichier := Format('%sLog_%s-%s.log', [sRepertoire, ChangeFileExt(ExtractFileName(ParamStr(0)), ''),
        FormatDateTime('yyyy-mm-dd', Now())]);

    if FileExists(sNomFichier) then
      slFichierLog.LoadFromFile(sNomFichier);

    slFichierLog.Add(Format('%s - [%s] %s', [FormatDateTime('hh:nn:ss.zzz', Now()), sNiveau, AMessage]));

    slFichierLog.SaveToFile(sNomFichier);

    {$IFDEF DEBUG}
    OutputDebugString(PChar(AMessage));
    {$ENDIF}
  finally
    slFichierLog.Free();
  end;
end;

procedure TFormPrincipale.OuvrirJournal();
var
  sRepertoire: TFileName;
  sNomFichier: TFileName;
begin
  // Ouvre le fichier de journal du jour
  sRepertoire := ExtractFilePath(ParamStr(0)) + 'Logs\';

  sNomFichier := Format('%sLog_%s-%s.log', [sRepertoire, ChangeFileExt(ExtractFileName(ParamStr(0)), ''),
      FormatDateTime('yyyy-mm-dd', Now())]);

  ShellExecute(0, 'OPEN', PChar(sNomFichier), nil, nil, SW_SHOW);
end;

procedure TFormPrincipale.Progression(const AStatut: string; const APosition: Integer = -1; const AMax: Integer = -1);
begin
  Lbl_Statut.Text := AStatut;
  if APosition > -1 then
    Pb_Statut.Value := APosition;
  if AMax > -1 then
    Pb_Statut.Max := AMax;
end;

procedure TFormPrincipale.Cmb_TypeConnexionChange(Sender: TObject);
begin
  case Cmb_TypeConnexion.ItemIndex of
    0:
      begin
        // Locale
        Txt_Serveur.Text        := 'localhost';
        Txt_Serveur.Enabled     := False;
        Txt_Port.Value          := 3050;
        Txt_Port.Enabled        := False;
        Btn_BaseDonnees.Enabled := True;
      end;
    1:
      begin
        // Distante
        Txt_Serveur.Enabled     := True;
        Txt_Port.Enabled        := True;
        Btn_BaseDonnees.Enabled := False;
      end;
  end;
end;

procedure TFormPrincipale.Btn_BaseDonneesClick(Sender: TObject);
var
  OdBaseDonnees: TOpenDialog;
begin
  // Choisi une base de données locale
  try
    OdBaseDonnees            := TOpenDialog.Create(Btn_BaseDonnees);
    OdBaseDonnees.Title      := RS_OUVERTURE_BDD;
    OdBaseDonnees.DefaultExt := RS_EXT_INTERBASE;
    OdBaseDonnees.Filter     := RS_TYPEFIC_INTERBASE;
    OdBaseDonnees.Options    := [TOpenOption.ofHideReadOnly, TOpenOption.ofPathMustExist, TOpenOption.ofFileMustExist,
      TOpenOption.ofEnableSizing];
    OdBaseDonnees.FileName   := ExtractFileName(Txt_BaseDonnees.Text);
    OdBaseDonnees.InitialDir := ExtractFileDir(Txt_BaseDonnees.Text);

    if OdBaseDonnees.Execute() then
    begin
      Txt_BaseDonnees.Text := OdBaseDonnees.FileName;
      Cmb_TypeReferentielChange(Cmb_TypeReferentiel);
    end;
  finally
    FreeAndNil(OdBaseDonnees);
  end;
end;

procedure TFormPrincipale.Cmb_TypeReferentielChange(Sender: TObject);
var
  CheminCourant: TFileName;
begin
  // Si la base de données est locale : on prévoit par défaut d'enregistrer dans
  // le répertoire de la base de données
  if Cmb_TypeConnexion.ItemIndex = 0 then
  begin
    CheminCourant := Format('%s%s.csv', [ExtractFilePath(Txt_BaseDonnees.Text), Cmb_TypeReferentiel.Selected.Text]);
    Txt_FichierExtraction.Text := CheminCourant;
    Txt_FichierReferentiel.Text := CheminCourant;
    Txt_FichierExcel.Text       := ChangeFileExt(CheminCourant, '.xlsx');
  end;

  Lbl_MAJArticle.Enabled   := TTypeReferentiel(Cmb_TypeReferentiel.ItemIndex) = trNomenclature;
  Txt_MAJArticle.Enabled   := TTypeReferentiel(Cmb_TypeReferentiel.ItemIndex) = trNomenclature;
  Chk_MAJMajuscule.Enabled := TTypeReferentiel(Cmb_TypeReferentiel.ItemIndex) = trNomenclature;
end;

procedure TFormPrincipale.Btn_FichierExtractionClick(Sender: TObject);
var
  SdFichier: TSaveDialog;
begin
  // Choisi le fichier d'extraction
  try
    SdFichier            := TSaveDialog.Create(TButton(Sender));
    SdFichier.Title      := RS_ENREGISTREMENT_EXTRACT;
    SdFichier.DefaultExt := RS_EXT_DSV;
    SdFichier.Filter     := RS_TYPEFIC_DSV;
    SdFichier.FileName   := ExtractFileName(Txt_FichierExtraction.Text);
    SdFichier.InitialDir := ExtractFileDir(Txt_FichierExtraction.Text);

    if SdFichier.Execute() then
      Txt_FichierExtraction.Text := SdFichier.FileName;
  finally
    FreeAndNil(SdFichier);
  end;
end;

procedure TFormPrincipale.Btn_ExtraireClick(Sender: TObject);
begin
  if not(bThreadEnCours) then
  begin
    // Lance le thread
    DemarrerThreadExtraction();
  end
  else
  begin
    // Arrêter le thread
    ArreterThreadExtraction();
  end;
end;

procedure TFormPrincipale.Btn_FichierReferentielClick(Sender: TObject);
var
  OdFichierRef: TOpenDialog;
begin
  // Choisi le fichier de référentiel
  try
    OdFichierRef            := TOpenDialog.Create(Btn_FichierReferentiel);
    OdFichierRef.Title      := RS_OUVERTURE_EXTRACT;
    OdFichierRef.DefaultExt := RS_EXT_DSV;
    OdFichierRef.Filter     := RS_TYPEFIC_DSV;
    OdFichierRef.Options    := [TOpenOption.ofHideReadOnly, TOpenOption.ofPathMustExist, TOpenOption.ofFileMustExist,
      TOpenOption.ofEnableSizing];
    OdFichierRef.FileName   := ExtractFileName(Txt_FichierReferentiel.Text);
    OdFichierRef.InitialDir := ExtractFileDir(Txt_FichierReferentiel.Text);

    if OdFichierRef.Execute() then
      Txt_FichierReferentiel.Text := OdFichierRef.FileName;
  finally
    FreeAndNil(OdFichierRef);
  end;
end;

procedure TFormPrincipale.Btn_FichierExcelClick(Sender: TObject);
var
  SdFichier: TSaveDialog;
begin
  // Choisi le fichier d'extraction
  try
    SdFichier            := TSaveDialog.Create(TButton(Sender));
    SdFichier.Title      := RS_ENREGISTREMENT_CORRESP;
    SdFichier.DefaultExt := RS_EXT_EXCEL;
    SdFichier.Filter     := RS_TYPEFIC_EXCEL;
    SdFichier.FileName   := ExtractFileName(Txt_FichierExcel.Text);
    SdFichier.InitialDir := ExtractFileDir(Txt_FichierExcel.Text);

    if SdFichier.Execute() then
      Txt_FichierExcel.Text := SdFichier.FileName;
  finally
    FreeAndNil(SdFichier);
  end;
end;

procedure TFormPrincipale.Btn_EnregistrerClick(Sender: TObject);
begin
  if not(bThreadEnCours) then
  begin
    // Lance le thread
    DemarrerThreadCorrespondances();
  end
  else
  begin
    // Arrêter le thread
    ArreterThreadCorrespondances();
  end;
end;

procedure TFormPrincipale.Btn_MAJExcelClick(Sender: TObject);
var
  OdFichier: TOpenDialog;
begin
  try
    OdFichier            := TOpenDialog.Create(Btn_MAJExcel);
    OdFichier.Title      := RS_OUVERTURE_CORRESP;
    OdFichier.DefaultExt := RS_EXT_EXCEL;
    OdFichier.Filter     := RS_TYPEFIC_EXCEL;
    OdFichier.Options    := [TOpenOption.ofHideReadOnly, TOpenOption.ofPathMustExist, TOpenOption.ofFileMustExist,
      TOpenOption.ofEnableSizing];
    OdFichier.FileName   := ExtractFileName(Txt_MAJExcel.Text);
    OdFichier.InitialDir := ExtractFileDir(Txt_MAJExcel.Text);

    if OdFichier.Execute() then
      Txt_MAJExcel.Text := OdFichier.FileName;
  finally
    FreeAndNil(OdFichier);
  end;
end;

procedure TFormPrincipale.Btn_MAJArticleClick(Sender: TObject);
var
  OdFichierRef: TOpenDialog;
begin
  try
    OdFichierRef            := TOpenDialog.Create(Btn_MAJArticle);
    OdFichierRef.Title      := RS_OUVERTURE_ARTICLES;
    OdFichierRef.DefaultExt := RS_EXT_DSV;
    OdFichierRef.Filter     := RS_TYPEFIC_DSV;
    OdFichierRef.Options    := [TOpenOption.ofHideReadOnly, TOpenOption.ofPathMustExist, TOpenOption.ofFileMustExist,
      TOpenOption.ofEnableSizing];
    OdFichierRef.FileName   := ExtractFileName(Txt_MAJArticle.Text);
    OdFichierRef.InitialDir := ExtractFileDir(Txt_MAJArticle.Text);

    if OdFichierRef.Execute() then
      Txt_MAJArticle.Text := OdFichierRef.FileName;
  finally
    FreeAndNil(OdFichierRef);
  end;
end;

procedure TFormPrincipale.Btn_MiseAJourClick(Sender: TObject);
begin
  if not(bThreadEnCours) then
  begin
    // Lance le thread
    DemarrerThreadMiseAJour();
  end
  else
  begin
    // Arrêter le thread
    ArreterThreadMiseAJour();
  end;
end;

procedure TFormPrincipale.ActiverComposant(const AEtat: Boolean = True);
begin
  // Active ou pas les composants
  Lbl_BaseDonnees.Enabled   := AEtat;
  Cmb_TypeConnexion.Enabled := AEtat;

  if Cmb_TypeConnexion.ItemIndex = 1 then
  begin
    Txt_Serveur.Enabled := AEtat;
    Txt_Port.Enabled    := AEtat;
  end;

  Txt_BaseDonnees.Enabled     := AEtat;
  Lbl_TypeReferentiel.Enabled := AEtat;
  Cmb_TypeReferentiel.Enabled := AEtat;

  // 1 - Extraction référentiels de référence
  Lbl_FichierExtraction.Enabled := AEtat;
  Txt_FichierExtraction.Enabled := AEtat;

  // 2 - Correspondances référentiels
  Lbl_FichierReferentiel.Enabled := AEtat;
  Txt_FichierReferentiel.Enabled := AEtat;
  Lbl_FichierExcel.Enabled       := AEtat;
  Txt_FichierExcel.Enabled       := AEtat;

  // 3 - Mise à jour référentiels avant migration
  Lbl_MAJExcel.Enabled := AEtat;
  Txt_MAJExcel.Enabled := AEtat;

  if TTypeReferentiel(Cmb_TypeReferentiel.ItemIndex) = trNomenclature then
  begin
    Lbl_MAJArticle.Enabled   := AEtat;
    Txt_MAJArticle.Enabled   := AEtat;
    Chk_MAJMajuscule.Enabled := AEtat;
  end;
end;

// 1 - Extraction référentiels de référence
procedure TFormPrincipale.DemarrerThreadExtraction();
begin
  if Txt_FichierExtraction.Text = '' then
  begin
    TaskDialog(0, RS_MSG_WARNING, RS_ERR_FIC_EXTRACTION, '', TD_ICON_WARNING, TD_BUTTON_OK);
  end
  else if not(Assigned(ThreadExtraction)) or not(bThreadEnCours) then
  begin
    // Paramètre le thread
    bThreadEnCours := True;
    bInterruption  := False;
    FreeAndNil(ThreadExtraction);

    ThreadExtraction                 := TThreadExtraction.Create(True);
    ThreadExtraction.Serveur         := Txt_Serveur.Text;
    ThreadExtraction.Port            := Round(Txt_Port.Value);
    ThreadExtraction.BaseDonnees     := Txt_BaseDonnees.Text;
    ThreadExtraction.Utilisateur     := 'ginkoia';
    ThreadExtraction.MotPasse        := 'ginkoia';
    ThreadExtraction.Fichier         := Txt_FichierExtraction.Text;
    ThreadExtraction.TypeReferentiel := TTypeReferentiel(Cmb_TypeReferentiel.ItemIndex);
    ThreadExtraction.ProcJournaliser := Journaliser;
    ThreadExtraction.ProcProgression := Progression;
    ThreadExtraction.OnTerminate     := FinThreadExtraction;

    Btn_Extraire.Text := RS_BTN_ARRETER;

    // Désactive les composants
    ActiverComposant(False);

    // Lancement du thread
    ThreadExtraction.Start();
  end;
end;

procedure TFormPrincipale.ArreterThreadExtraction();
begin
  if Assigned(ThreadExtraction) and bThreadEnCours then
  begin
    // Demande confirmation
    if TaskDialog(0, RS_MSG_QUESTION, RS_DLG_ARRET_EXTRACTION, RS_DLG_ARRET_EXTRACTION_MSG, TD_ICON_QUESTION,
      TD_BUTTON_YESNO) = TD_RESULT_YES then
    begin
      // Lance l'arrêt du thread
      bInterruption := True;
      ThreadExtraction.Terminate();
      Journaliser(RS_ARRET_EXTRACTION);
      Lbl_Statut.Text := RS_ARRET_EXTRACTION;
    end;
  end;
end;

procedure TFormPrincipale.FinThreadExtraction(Sender: TObject);
begin
  // Fin du thread
  bThreadEnCours    := False;
  Btn_Extraire.Text := RS_BTN_EXTRAIRE;

  // Active les composants
  ActiverComposant();

  if ThreadExtraction.Erreur then
  begin
    Journaliser(RS_INTEROMP_EXTRACTION);
    Lbl_Statut.Text := RS_INTEROMP_EXTRACTION;
    TaskDialog(0, RS_INTEROMP_EXTRACTION, RS_ERREUR_EXTRACTION, ThreadExtraction.MsgErreur, TD_ICON_ERROR,
      TD_BUTTON_OK);
  end
  else
  begin
    if not(bInterruption) then
    begin
      Journaliser(RS_FIN_EXTRACTION);
      Lbl_Statut.Text := RS_FIN_EXTRACTION;

      if ThreadExtraction.NbErreurs = 1 then
      begin
        if TaskDialog(0, RS_MSG_ERROR, RS_ERREUR_EXTRACTION, RS_ERREUR_AFFICHERLOG, TD_ICON_WARNING, TD_BUTTON_YESNO) = TD_RESULT_YES
        then
          OuvrirJournal();
      end
      else if ThreadExtraction.NbErreurs > 1 then
      begin
        if TaskDialog(0, RS_MSG_ERRORS, Format(RS_ERREURS_EXTRACTION, [ThreadExtraction.NbErreurs]),
          RS_ERREUR_AFFICHERLOG, TD_ICON_WARNING, TD_BUTTON_YESNO) = TD_RESULT_YES then
          OuvrirJournal();
      end;
    end
    else
    begin
      Journaliser(RS_INTEROMP_EXTRACTION);
      Lbl_Statut.Text := RS_INTEROMP_EXTRACTION;
    end;
  end;
end;

// 2 - Correspondances référentiels
procedure TFormPrincipale.DemarrerThreadCorrespondances();
var
  Chemin, Nom : array [0 .. MAX_PATH] of Char;
  NomFichier  : TFileName;
  FichierExcel: TResourceStream;
begin
  if (Txt_FichierReferentiel.Text = '') or (Txt_FichierExcel.Text = '') then
  begin
    TaskDialog(0, RS_MSG_WARNING, RS_ERR_FIC_ENREGISTREMENT, '', TD_ICON_WARNING, TD_BUTTON_OK);
  end
  else if not(Assigned(ThreadCorrespondances)) or not(bThreadEnCours) then
  begin
    // Choisi un nom pour le fichier temporaire
    if GetTempPath(MAX_PATH, @Chemin) = 0 then
      StrCopy(@Chemin, PChar(ExtractFileDir(ParamStr(0))));

    if GetTempFileName(@Chemin, 'GINKOIA_', 0, @Nom) = 0 then
      StrCopy(@Nom, PChar(ExtractFilePath(ParamStr(0)) + 'Correspondances.xlsx'));

    NomFichier := Nom;
    NomFichier := ChangeFileExt(NomFichier, '.xlsx');

    // Paramètre le thread
    bThreadEnCours := True;
    bInterruption  := False;
    FreeAndNil(ThreadCorrespondances);

    ThreadCorrespondances                    := TThreadCorrespondances.Create(True);
    ThreadCorrespondances.Serveur            := Txt_Serveur.Text;
    ThreadCorrespondances.Port               := Round(Txt_Port.Value);
    ThreadCorrespondances.BaseDonnees        := Txt_BaseDonnees.Text;
    ThreadCorrespondances.Utilisateur        := 'ginkoia';
    ThreadCorrespondances.MotPasse           := 'ginkoia';
    ThreadCorrespondances.FichierReferentiel := Txt_FichierReferentiel.Text;
    ThreadCorrespondances.FichierExcelModele := NomFichier;
    ThreadCorrespondances.FichierExcel       := Txt_FichierExcel.Text;
    ThreadCorrespondances.TypeReferentiel    := TTypeReferentiel(Cmb_TypeReferentiel.ItemIndex);
    ThreadCorrespondances.ProcJournaliser    := Journaliser;
    ThreadCorrespondances.ProcProgression    := Progression;
    ThreadCorrespondances.OnTerminate        := FinThreadCorrespondances;

    Btn_Enregistrer.Text := RS_BTN_ARRETER;

    // Extrait le fichier Excel modèle en ressource
    try
      try
        case ThreadCorrespondances.TypeReferentiel of
          trMarques, trFournisseurs:
            FichierExcel := TResourceStream.Create(0, 'Correspondances', RT_RCDATA);
          trNomenclature:
            FichierExcel := TResourceStream.Create(0, 'Nomenclature', RT_RCDATA);
          else
            raise EErreurFichierExcel.Create(RS_ERREUR_PAS_FICHIER_XLSX);
        end;
        FichierExcel.SaveToFile(ThreadCorrespondances.FichierExcelModele);
      finally
        FichierExcel.Free();
      end;
    except
      on E: Exception do
      begin
        TaskDialog(0, RS_MSG_ERROR, RS_ERREUR_ENREGISTREMENT, E.ClassName + #160': ' + E.Message + '.', TD_ICON_ERROR,
          TD_BUTTON_OK);
        bInterruption := True;
        Exit;
      end;
    end;

    // Désactive les composants
    ActiverComposant(False);

    // Lancement du thread
    ThreadCorrespondances.Start();
  end;
end;

procedure TFormPrincipale.ArreterThreadCorrespondances();
begin
  if Assigned(ThreadCorrespondances) and bThreadEnCours then
  begin
    // Demande confirmation
    if TaskDialog(0, RS_MSG_QUESTION, RS_DLG_ARRET_ENREGISTREMENT, RS_DLG_ARRET_ENREGISTREMENT_MSG, TD_ICON_QUESTION,
      TD_BUTTON_YESNO) = TD_RESULT_YES then
    begin
      // Lance l'arrêt du thread
      bInterruption := True;
      ThreadCorrespondances.Terminate();
      Journaliser(RS_ARRET_ENREGISTREMENT);
      Lbl_Statut.Text := RS_ARRET_ENREGISTREMENT;
    end;
  end;
end;

procedure TFormPrincipale.FinThreadCorrespondances(Sender: TObject);
begin
  // Fin du thread
  bThreadEnCours       := False;
  Btn_Enregistrer.Text := RS_BTN_ENREGISTRER;

  // Active les composants
  ActiverComposant();

  // Supprime le fichier Excel de modèle
  DeleteFile(ThreadCorrespondances.FichierExcelModele);

  if ThreadCorrespondances.Erreur then
  begin
    Journaliser(RS_INTEROMP_ENREGISTREMENT);
    Lbl_Statut.Text := RS_INTEROMP_ENREGISTREMENT;
    TaskDialog(0, RS_INTEROMP_ENREGISTREMENT, RS_ERREUR_ENREGISTREMENT, ThreadCorrespondances.MsgErreur, TD_ICON_ERROR,
      TD_BUTTON_OK);
  end
  else
  begin
    if not(bInterruption) then
    begin
      Journaliser(RS_FIN_ENREGISTREMENT);
      Lbl_Statut.Text := RS_FIN_ENREGISTREMENT;

      if ThreadCorrespondances.NbErreurs = 1 then
      begin
        if TaskDialog(0, RS_MSG_ERROR, RS_ERREUR_ENREGISTREMENT, RS_ERREUR_AFFICHERLOG, TD_ICON_WARNING,
          TD_BUTTON_YESNO) = TD_RESULT_YES then
          OuvrirJournal();
      end
      else if ThreadCorrespondances.NbErreurs > 1 then
      begin
        if TaskDialog(0, RS_MSG_ERRORS, Format(RS_ERREURS_ENREGISTREMENT, [ThreadCorrespondances.NbErreurs]),
          RS_ERREUR_AFFICHERLOG, TD_ICON_WARNING, TD_BUTTON_YESNO) = TD_RESULT_YES then
          OuvrirJournal();
      end;

      if Chk_OuvrirReferentiel.IsChecked then
        ShellExecute(0, 'OPEN', PChar(ThreadCorrespondances.FichierExcel), nil, nil, SW_SHOW);
    end
    else
    begin
      Journaliser(RS_INTEROMP_ENREGISTREMENT);
      Lbl_Statut.Text := RS_INTEROMP_ENREGISTREMENT;
    end;
  end;
end;

// 3 - Mise à jour référentiels avant migration
procedure TFormPrincipale.DemarrerThreadMiseAJour();
begin
  if (Txt_MAJExcel.Text = '') or ((Txt_MAJArticle.Text = '') and (TTypeReferentiel(Cmb_TypeReferentiel.ItemIndex)
        = trNomenclature)) then
  begin
    case TTypeReferentiel(Cmb_TypeReferentiel.ItemIndex) of
      trMarques, trFournisseurs:
        TaskDialog(0, RS_MSG_WARNING, RS_ERR_FIC_MAJ, '', TD_ICON_WARNING, TD_BUTTON_OK);
      trNomenclature:
        TaskDialog(0, RS_MSG_WARNING, RS_ERR_FIC_MAJ_NKL, '', TD_ICON_WARNING, TD_BUTTON_OK);
    end;
  end
  else if not(Assigned(ThreadMiseAJour)) or not(bThreadEnCours) then
  begin

    // Paramètre le thread
    bThreadEnCours := True;
    bInterruption  := False;
    FreeAndNil(ThreadMiseAJour);

    ThreadMiseAJour                 := TThreadMiseAJour.Create(True);
    ThreadMiseAJour.Serveur         := Txt_Serveur.Text;
    ThreadMiseAJour.Port            := Round(Txt_Port.Value);
    ThreadMiseAJour.BaseDonnees     := Txt_BaseDonnees.Text;
    ThreadMiseAJour.Utilisateur     := 'ginkoia';
    ThreadMiseAJour.MotPasse        := 'ginkoia';
    ThreadMiseAJour.TypeReferentiel := TTypeReferentiel(Cmb_TypeReferentiel.ItemIndex);
    ThreadMiseAJour.FichierExcel    := Txt_MAJExcel.Text;
    ThreadMiseAJour.FichierArticle  := Txt_MAJArticle.Text;
    ThreadMiseAJour.CodesFinauxMaj  := Chk_MAJMajuscule.IsChecked;
    ThreadMiseAJour.ProcJournaliser := Journaliser;
    ThreadMiseAJour.ProcProgression := Progression;
    ThreadMiseAJour.OnTerminate     := FinThreadMiseAJour;

    Btn_MiseAJour.Text := RS_BTN_ARRETER;

    // Désactive les composants
    ActiverComposant(False);

    // Lancement du thread
    ThreadMiseAJour.Start();
  end;
end;

procedure TFormPrincipale.ArreterThreadMiseAJour();
begin
  if Assigned(ThreadMiseAJour) and bThreadEnCours then
  begin
    case ThreadMiseAJour.TypeReferentiel of
      trMarques, trFournisseurs:
        begin
          // Demande confirmation
          if TaskDialog(0, RS_MSG_QUESTION, RS_DLG_ARRET_MAJ, RS_DLG_ARRET_MAJ_MSG, TD_ICON_QUESTION, TD_BUTTON_YESNO) = TD_RESULT_YES
          then
          begin
            // Lance l'arrêt du thread
            bInterruption := True;
            ThreadMiseAJour.Terminate();
            Journaliser(RS_ARRET_MAJ);
            Lbl_Statut.Text := RS_ARRET_MAJ;
          end;
        end;
      trNomenclature:
        begin
          // Demande confirmation
          if TaskDialog(0, RS_MSG_QUESTION, RS_DLG_ARRET_MAJ_NKL, RS_DLG_ARRET_MAJ_NKL_MSG, TD_ICON_QUESTION,
            TD_BUTTON_YESNO) = TD_RESULT_YES then
          begin
            // Lance l'arrêt du thread
            bInterruption := True;
            ThreadMiseAJour.Terminate();
            Journaliser(RS_ARRET_MAJ_NKL);
            Lbl_Statut.Text := RS_ARRET_MAJ_NKL;
          end;
        end;
    end;
  end;
end;

procedure TFormPrincipale.FinThreadMiseAJour(Sender: TObject);
begin
  // Fin du thread
  bThreadEnCours     := False;
  Btn_MiseAJour.Text := RS_BTN_MAJ;

  // Active les composants
  ActiverComposant();

  if ThreadMiseAJour.Erreur then
  begin
    case ThreadMiseAJour.TypeReferentiel of
      trMarques, trFournisseurs:
        begin
          Journaliser(RS_INTEROMP_MAJ);
          Lbl_Statut.Text := RS_INTEROMP_MAJ;
          TaskDialog(0, RS_INTEROMP_MAJ, RS_ERREUR_MAJ, ThreadMiseAJour.MsgErreur, TD_ICON_ERROR, TD_BUTTON_OK);
        end;
      trNomenclature:
        begin
          Journaliser(RS_INTEROMP_MAJ_NKL);
          Lbl_Statut.Text := RS_INTEROMP_MAJ_NKL;
          TaskDialog(0, RS_INTEROMP_MAJ_NKL, RS_ERREUR_MAJ_NKL, ThreadMiseAJour.MsgErreur, TD_ICON_ERROR, TD_BUTTON_OK);
        end;
    end;
  end
  else
  begin
    case ThreadMiseAJour.TypeReferentiel of
      trMarques, trFournisseurs:
        begin
          if not(bInterruption) then
          begin
            Journaliser(RS_FIN_MAJ);
            Lbl_Statut.Text := RS_FIN_MAJ;

            if ThreadMiseAJour.NbErreurs = 1 then
            begin
              if TaskDialog(0, RS_MSG_ERROR, RS_ERREUR_MAJ, RS_ERREUR_AFFICHERLOG, TD_ICON_WARNING, TD_BUTTON_YESNO) = TD_RESULT_YES
              then
                OuvrirJournal();
            end
            else if ThreadMiseAJour.NbErreurs > 1 then
            begin
              if TaskDialog(0, RS_MSG_ERRORS, Format(RS_ERREURS_MAJ, [ThreadMiseAJour.NbErreurs]),
                RS_ERREUR_AFFICHERLOG, TD_ICON_QUESTION, TD_BUTTON_YESNO) = TD_RESULT_YES then
                OuvrirJournal();
            end;
          end
          else
          begin
            Journaliser(RS_INTEROMP_MAJ);
            Lbl_Statut.Text := RS_INTEROMP_MAJ;
          end;
        end;
      trNomenclature:
        begin
          if not(bInterruption) then
          begin
            Journaliser(RS_FIN_MAJ_NKL);
            Lbl_Statut.Text := RS_FIN_MAJ_NKL;

            if ThreadMiseAJour.NbErreurs = 1 then
            begin
              if TaskDialog(0, RS_MSG_ERROR, RS_ERREUR_MAJ_NKL, RS_ERREUR_AFFICHERLOG, TD_ICON_WARNING, TD_BUTTON_YESNO)
                = TD_RESULT_YES then
                OuvrirJournal();
            end
            else if ThreadMiseAJour.NbErreurs > 1 then
            begin
              if TaskDialog(0, RS_MSG_ERRORS, Format(RS_ERREURS_MAJ_NKL, [ThreadMiseAJour.NbErreurs]),
                RS_ERREUR_AFFICHERLOG, TD_ICON_QUESTION, TD_BUTTON_YESNO) = TD_RESULT_YES then
                OuvrirJournal();
            end;
          end
          else
          begin
            Journaliser(RS_INTEROMP_MAJ_NKL);
            Lbl_Statut.Text := RS_INTEROMP_MAJ_NKL;
          end;
        end;
    end;
  end;
end;

end.
