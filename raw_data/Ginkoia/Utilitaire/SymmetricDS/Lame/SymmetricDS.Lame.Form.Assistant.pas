unit SymmetricDS.Lame.Form.Assistant;

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
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  Vcl.Buttons,
  Vcl.CheckLst,
  Vcl.ComCtrls,
  Vcl.FileCtrl,
  SymmetricDS.Commun;

type
  TFormAssistant = class(TForm)
    PnlTitre: TPanel;
    ImgLogo: TImage;
    LblTitre: TLabel;
    GrPActions: TGridPanel;
    PnlBoutons: TPanel;
    BtnFermer: TBitBtn;
    BtnExecuter: TBitBtn;
    GrPAdresseURL: TGridPanel;
    LblAdresseURL: TLabel;
    TxtAdresseURL: TEdit;
    ImgSymmetricDS: TImage;
    ChkSymmetricDS: TCheckBox;
    TxtSymmetricDS: TEdit;
    PnlSymmetricDS: TPanel;
    BtnSymmetricDS: TButton;
    ImgDossier: TImage;
    ChkDossier: TCheckBox;
    PnlDossier: TPanel;
    TxtDossier: TEdit;
    BtnDossier: TButton;
    ChklbListeBases: TCheckListBox;
    PnlJournal: TPanel;
    TxtJournal: TRichEdit;
    PnlListeBases: TPanel;
    LblListeBases: TLabel;
    dlgOpenDossier: TOpenDialog;
    PnlNomClient: TPanel;
    LblNomClient: TLabel;
    TxtNomClient: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnSymmetricDSClick(Sender: TObject);
    procedure TxtDossierChange(Sender: TObject);
    procedure BtnDossierClick(Sender: TObject);
    procedure BtnExecuterClick(Sender: TObject);
    procedure ChkSymmetricDSClick(Sender: TObject);
    procedure ChkDossierClick(Sender: TObject);
    procedure Journaliser(const AMessage: String;
      const ANiveau: TNiveau = NivDetail);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  FormAssistant: TFormAssistant;

implementation

{$R *.dfm}

uses
  SymmetricDS.Commun.DataModule.Traitements;

procedure TFormAssistant.BtnDossierClick(Sender: TObject);
begin
  // Ouvre un fichier de base de données
  dlgOpenDossier.FileName    := ExtractFileName(TxtDossier.Text);
  dlgOpenDossier.InitialDir  := ExtractFileDir(TxtDossier.Text);
  if dlgOpenDossier.Execute() then
    TxtDossier.Text := dlgOpenDossier.FileName;
end;

procedure TFormAssistant.BtnExecuterClick(Sender: TObject);
var
  slListeBases: TStringList;
  i: Integer;
begin
  // Installation de SymmetricDS
  if ChkSymmetricDS.Checked then
  begin
    Journaliser('Installation de SymmetricDS.');
    ImgSymmetricDS.Picture.Bitmap.LoadFromResourceName(HInstance, 'ENCOURS');
    if DataModuleTraitements.InstallationSymmetricDS(TxtSymmetricDS.Text, TxtAdresseURL.Text) then
    begin
      ImgSymmetricDS.Picture.Bitmap.LoadFromResourceName(HInstance, 'OK');
      Journaliser('Installation de SymmetricDS réussie.');
    end
    else begin
      ImgSymmetricDS.Picture.Bitmap.LoadFromResourceName(HInstance, 'ERREUR');
      Journaliser('Installation de SymmetricDS en erreur.', NivArret);
      Exit;
    end;
  end;

  // Installation des dossiers
  if ChkDossier.Checked then
  begin
    Journaliser('Installation des dossiers.');
    ImgDossier.Picture.Bitmap.LoadFromResourceName(HInstance, 'ENCOURS');

    slListeBases := TStringList.Create();
    try

      for i := 0 to ChklbListeBases.Count - 1 do
      begin
        if ChklbListeBases.Checked[i] then
          slListeBases.Add(ChklbListeBases.Items[i]);
      end;

      if DataModuleTraitements.InstallationDossier(TxtDossier.Text, TxtSymmetricDS.Text,
        TxtNomClient.Text, TxtAdresseURL.Text, slListeBases) then
      begin
        ImgDossier.Picture.Bitmap.LoadFromResourceName(HInstance, 'OK');
        Journaliser('Installation des dossiers réussie.');
      end
      else begin
        ImgDossier.Picture.Bitmap.LoadFromResourceName(HInstance, 'ERREUR');
        Journaliser('Installation des dossiers en erreur.', NivArret);
        Exit;
      end;
    finally
      slListeBases.Free();
    end;
  end;
end;

procedure TFormAssistant.BtnSymmetricDSClick(Sender: TObject);
var
  sDossier: string;
begin
  sDossier := TxtSymmetricDS.Text;
  if SelectDirectory('Dossier d’installation de SymmetricDS'#160':', '', sDossier,
    [sdNewFolder, sdShowEdit, sdNewUI, sdValidateDir], Self) then
    TxtSymmetricDS.Text  := sDossier;
end;

procedure TFormAssistant.ChkDossierClick(Sender: TObject);
begin
  PnlDossier.Enabled  := ChkDossier.Checked;
  TxtDossier.Enabled  := ChkDossier.Checked;
  BtnDossier.Enabled  := ChkDossier.Checked;
end;

procedure TFormAssistant.ChkSymmetricDSClick(Sender: TObject);
begin
  PnlSymmetricDS.Enabled  := ChkSymmetricDS.Checked;
  TxtSymmetricDS.Enabled  := ChkSymmetricDS.Checked;
  BtnSymmetricDS.Enabled  := ChkSymmetricDS.Checked;
end;

procedure TFormAssistant.FormCreate(Sender: TObject);
begin
  // Charge les icônes
  ImgLogo.Picture.Icon.Handle := LoadImage(HInstance, 'MAINICON', IMAGE_ICON, 64, 64, LR_DEFAULTCOLOR);
  ImgSymmetricDS.Picture.Bitmap.LoadFromResourceName(HInstance, 'EXTRACTION');
  ImgDossier.Picture.Bitmap.LoadFromResourceName(HInstance, 'EXTRACTION');

  // Lier l'événement journaliser
  DataModuleTraitements.Journaliser := Journaliser;
end;

procedure TFormAssistant.FormShow(Sender: TObject);
begin
  TxtAdresseURL.Text := Format('https://%s:31417/', [RecupererIP()]);
end;

procedure TFormAssistant.TxtDossierChange(Sender: TObject);
var
  slBases: TStringList;
  i: Integer;
begin
  // Liste des bases
  if (Length(TxtDossier.Text) > 0)
    and FileExists(TxtDossier.Text) then
  begin
    slBases := TStringList.Create();
    try
      ChklbListeBases.Clear();
      if DataModuleTraitements.ListeBases(TxtDossier.Text, slBases) then
      begin
        for i := 0 to slBases.Count - 1 do
        begin
          ChklbListeBases.Items.Add(slBases[i]);
        end;
        ChklbListeBases.Enabled := True;
        LblListeBases.Enabled   := True;
        TxtNomClient.Enabled    := True;
        LblNomClient.Enabled    := True;

        TxtNomClient.Text       := DataModuleTraitements.NomClient(TxtDossier.Text);
      end
      else begin
        ChklbListeBases.Enabled := False;
        LblListeBases.Enabled   := False;
        TxtNomClient.Enabled    := False;
        LblNomClient.Enabled    := False;
      end;
    finally
      slBases.Free();
    end;
  end
  else begin
    ChklbListeBases.Enabled := False;
    LblListeBases.Enabled   := False;
    TxtNomClient.Enabled    := False;
    LblNomClient.Enabled    := False;
  end;
end;

procedure TFormAssistant.Journaliser(const AMessage: String;
  const ANiveau: TNiveau);
var
  sRepertoire, sNomFichier, sNiveau: String;
  slFichierLog: TStringList;
begin
  // Récupération du niveau
  case ANiveau of
    NivDetail: sNiveau := 'Détail';
    NivErreur: begin
      TxtJournal.SelAttributes.Color := $0080FF;
      sNiveau := 'Erreur';
    end;
    NivArret: begin
      TxtJournal.SelAttributes.Color := $0000FF;
      sNiveau := 'Arrêt';
    end;
  end;

  // Ajout le message au Log
  TxtJournal.Lines.Add(Format('%s - [%s] %s', [FormatDateTime('hh:nn:ss.zzz', Now()), sNiveau, AMessage]));
  TxtJournal.SelAttributes.Color := clWindowText;
  TxtJournal.Perform(WM_VSCROLL, SB_BOTTOM, 0);

  {$REGION 'Enregistrement dans le fichier de Log'}
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
  {$ENDREGION 'Enregistrement dans le fichier de Log'}
end;

end.
