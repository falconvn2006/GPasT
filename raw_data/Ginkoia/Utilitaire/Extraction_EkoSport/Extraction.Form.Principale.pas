unit Extraction.Form.Principale;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.StdCtrls, System.Win.Registry, System.StrUtils,
  Extraction.Ressourses, Extraction.Thread.Extraction;

type
  TFormPrincipale = class(TForm)
    PnlTitre: TPanel;
    LblTitre: TLabel;
    LblBaseDonnees: TLabel;
    TxtBaseDonnees: TEdit;
    BtnBaseDonnees: TButton;
    TxtMarques: TEdit;
    BtnMarques: TButton;
    TxtFournisseurs: TEdit;
    BtnFournisseurs: TButton;
    TxtMarquesFournisseurs: TEdit;
    BtnMarquesFournisseurs: TButton;
    TxtModeles: TEdit;
    BtnModeles: TButton;
    BvlSeparation: TBevel;
    PnlBoutons: TPanel;
    BtnFermer: TBitBtn;
    BtnExtraire: TBitBtn;
    PbProgression: TProgressBar;
    ImgIcone: TImage;
    OdBaseDonnees: TOpenDialog;
    SdFichier: TSaveDialog;
    GPnlProgression: TGridPanel;
    LblProgression: TLabel;
    BtnAnnuler: TBitBtn;
    ImgBaseDonnees: TImage;
    ImgMarques: TImage;
    ImgFournisseurs: TImage;
    ImgMarquesFournisseurs: TImage;
    ImgModeles: TImage;
    ImgRAL: TImage;
    TxtRAL: TEdit;
    BtnRAL: TButton;
    ChkMarques: TCheckBox;
    ChkFournisseurs: TCheckBox;
    ChkMarquesFournisseurs: TCheckBox;
    ChkModeles: TCheckBox;
    ChkRAL: TCheckBox;
    ImgStocks: TImage;
    TxtStocks: TEdit;
    BtnStocks: TButton;
    ChkStocks: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure BtnBaseDonneesClick(Sender: TObject);
    procedure BtnFichiersClick(Sender: TObject);
    procedure ChkFichierClick(Sender: TObject);
    procedure BtnExtraireClick(Sender: TObject);
    procedure DemarrerThread();
    procedure FinThread(Sender: TObject);
    procedure BtnAnnulerClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  FormPrincipale: TFormPrincipale;
  ThreadExtraction: TThreadExtraction;
  bInterruption: Boolean = False;

implementation

{$R *.dfm}

procedure TFormPrincipale.BtnAnnulerClick(Sender: TObject);
begin
  // Arrête le thread
  if Assigned(ThreadExtraction) then
  begin
    bInterruption := True;
    ThreadExtraction.Terminate();
  end;
end;

procedure TFormPrincipale.BtnBaseDonneesClick(Sender: TObject);
begin
  // Ouvre un fichier de base de données
  OdBaseDonnees.FileName := TxtBaseDonnees.Text;
  if OdBaseDonnees.Execute() then
    TxtBaseDonnees.Text := OdBaseDonnees.FileName;
end;

procedure TFormPrincipale.BtnExtraireClick(Sender: TObject);
begin
  BtnFermer.Hide();
  BtnAnnuler.Show();
  BtnExtraire.Enabled := False;

  BtnExtraire.Left := 0;

  // Lance le thread
  DemarrerThread();
end;

procedure TFormPrincipale.BtnFichiersClick(Sender: TObject);
begin
  case AnsiIndexText(TWinControl(Sender).Name, ['BtnMarques', 'BtnFournisseurs',
    'BtnMarquesFournisseurs', 'BtnModeles', 'BtnRAL', 'BtnStocks']) of
    // Marques
    0: begin
      SdFichier.FileName    := ExtractFileName(TxtMarques.Text);
      SdFichier.InitialDir  := ExtractFileDir(TxtMarques.Text);
      if SdFichier.Execute() then
        TxtMarques.Text := SdFichier.FileName;
    end;
    // Fournisseurs
    1: begin
      SdFichier.FileName    := ExtractFileName(TxtFournisseurs.Text);
      SdFichier.InitialDir  := ExtractFileDir(TxtFournisseurs.Text);
      if SdFichier.Execute() then
        TxtFournisseurs.Text := SdFichier.FileName;
    end;
    // Marques/Fournisseurs
    2: begin
      SdFichier.FileName    := ExtractFileName(TxtMarquesFournisseurs.Text);
      SdFichier.InitialDir  := ExtractFileDir(TxtMarquesFournisseurs.Text);
      if SdFichier.Execute() then
        TxtMarquesFournisseurs.Text := SdFichier.FileName;
    end;
    // Modèles
    3: begin
      SdFichier.FileName    := ExtractFileName(TxtModeles.Text);
      SdFichier.InitialDir  := ExtractFileDir(TxtModeles.Text);
      if SdFichier.Execute() then
        TxtModeles.Text := SdFichier.FileName;
    end;
    // Restes à livrer
    4: begin
      SdFichier.FileName    := ExtractFileName(TxtRAL.Text);
      SdFichier.InitialDir  := ExtractFileDir(TxtRAL.Text);
      if SdFichier.Execute() then
        TxtRAL.Text := SdFichier.FileName;
    end;
    // Stocks
    5: begin
      SdFichier.FileName    := ExtractFileName(TxtStocks.Text);
      SdFichier.InitialDir  := ExtractFileDir(TxtStocks.Text);
      if SdFichier.Execute() then
        TxtStocks.Text := SdFichier.FileName;
    end;
  end;
end;

procedure TFormPrincipale.ChkFichierClick(Sender: TObject);
begin
  case AnsiIndexText(TWinControl(Sender).Name, ['ChkMarques', 'ChkFournisseurs',
    'ChkMarquesFournisseurs', 'ChkModeles', 'ChkRAL', 'ChkStocks']) of
    // Marques
    0: begin
      TxtMarques.Enabled              := TCheckBox(Sender).Checked;
      BtnMarques.Enabled              := TCheckBox(Sender).Checked;
    end;
    // Fournisseurs
    1: begin
      TxtFournisseurs.Enabled         := TCheckBox(Sender).Checked;
      BtnFournisseurs.Enabled         := TCheckBox(Sender).Checked;
    end;
    // Marques/Fournisseurs
    2: begin
      TxtMarquesFournisseurs.Enabled  := TCheckBox(Sender).Checked;
      BtnMarquesFournisseurs.Enabled  := TCheckBox(Sender).Checked;
    end;
    // Modèles
    3: begin
      TxtModeles.Enabled              := TCheckBox(Sender).Checked;
      BtnModeles.Enabled              := TCheckBox(Sender).Checked;
    end;
    // Restes à livrer
    4: begin
      TxtRAL.Enabled                  := TCheckBox(Sender).Checked;
      BtnRAL.Enabled                  := TCheckBox(Sender).Checked;
    end;
    // Stocks
    5: begin
      TxtStocks.Enabled               := TCheckBox(Sender).Checked;
      BtnStocks.Enabled               := TCheckBox(Sender).Checked;
    end;
  end;
end;

procedure TFormPrincipale.FinThread(Sender: TObject);
begin
  // Fin du thread
  BtnFermer.Show();
  BtnAnnuler.Hide();
  BtnExtraire.Enabled := True;

  BtnExtraire.Left := 0;

  if bInterruption then
    LblProgression.Caption := RS_ABANDONNEE;
end;

procedure TFormPrincipale.FormCreate(Sender: TObject);
const
  REGGINKOIA = '\SOFTWARE\Algol\Ginkoia';
var
  Registre: TRegistry;
  CheminCourant: string;
begin
  // Charge les icônes
  BtnExtraire.Glyph.LoadFromResourceName(HInstance, 'OK');
  BtnExtraire.NumGlyphs := 2;
  BtnAnnuler.Glyph.LoadFromResourceName(HInstance, 'CANCEL');
  BtnAnnuler.NumGlyphs  := 2;
  BtnFermer.Glyph.LoadFromResourceName(HInstance, 'EXIT');
  BtnFermer.NumGlyphs   := 2;

  ImgIcone.Picture.Icon.Handle := LoadImage(HInstance, 'MAINICON', IMAGE_ICON, 48, 48, LR_DEFAULTCOLOR);
  ImgBaseDonnees.Picture.Bitmap.LoadFromResourceName(HInstance, 'DATABASE');
  ImgMarques.Picture.Bitmap.LoadFromResourceName(HInstance, 'EXTRACTION');
  ImgFournisseurs.Picture.Bitmap.LoadFromResourceName(HInstance, 'EXTRACTION');
  ImgMarquesFournisseurs.Picture.Bitmap.LoadFromResourceName(HInstance, 'EXTRACTION');
  ImgModeles.Picture.Bitmap.LoadFromResourceName(HInstance, 'EXTRACTION');
  ImgRAL.Picture.Bitmap.LoadFromResourceName(HInstance, 'EXTRACTION');
  ImgStocks.Picture.Bitmap.LoadFromResourceName(HInstance, 'EXTRACTION');

  // Charge le chemin de la base de données par défaut
  Registre := TRegistry.Create(KEY_READ);
  try
    Registre.RootKey  := HKEY_LOCAL_MACHINE;
    if Registre.OpenKey(REGGINKOIA, False) then
    begin
      TxtBaseDonnees.Text := Registre.ReadString('Base0');
    end;
  finally
    Registre.Free();
  end;

  // Charge des noms de fichiers par défaut
  CheminCourant               := ExtractFilePath(Application.ExeName);
  TxtMarques.Text             := Format('%sMarques.txt', [CheminCourant]);
  TxtFournisseurs.Text        := Format('%sFournisseurs.txt', [CheminCourant]);
  TxtMarquesFournisseurs.Text := Format('%sMarques-Fournisseurs.txt', [CheminCourant]);
  TxtModeles.Text             := Format('%sModèles.txt', [CheminCourant]);
  TxtRAL.Text                 := Format('%sRÀL.txt', [CheminCourant]);
  TxtStocks.Text              := Format('%sStocks.txt', [CheminCourant]);

  LblProgression.Caption      := RS_PROGRESSION;
end;

procedure TFormPrincipale.DemarrerThread();
begin
  if Assigned(ThreadExtraction) then
    Exit;

  // Paramètre le thread
  bInterruption                                 := False;
  ThreadExtraction                              := TThreadExtraction.Create(True);
  ThreadExtraction.BaseDonnees                  := TxtBaseDonnees.Text;
  ThreadExtraction.FichierMarques               := TxtMarques.Text;
  ThreadExtraction.FichierFournisseurs          := TxtFournisseurs.Text;
  ThreadExtraction.FichierMarquesFournisseurs   := TxtMarquesFournisseurs.Text;
  ThreadExtraction.FichierModeles               := TxtModeles.Text;
  ThreadExtraction.FichierRAL                   := TxtRAL.Text;
  ThreadExtraction.FichierStocks                := TxtStocks.Text;
  ThreadExtraction.ExtraireMarques              := ChkMarques.Checked;
  ThreadExtraction.ExtraireFournisseurs         := ChkFournisseurs.Checked;
  ThreadExtraction.ExtraireMarquesFournisseurs  := ChkMarquesFournisseurs.Checked;
  ThreadExtraction.ExtraireModeles              := ChkModeles.Checked;
  ThreadExtraction.ExtraireRAL                  := ChkRAL.Checked;
  ThreadExtraction.ExtraireStocks               := ChkStocks.Checked;
  ThreadExtraction.LblProgression               := LblProgression;
  ThreadExtraction.PbProgression                := PbProgression;
  ThreadExtraction.ImgMarques                   := ImgMarques;
  ThreadExtraction.ImgFournisseurs              := ImgFournisseurs;
  ThreadExtraction.ImgMarquesFournisseurs       := ImgMarquesFournisseurs;
  ThreadExtraction.ImgModeles                   := ImgModeles;
  ThreadExtraction.ImgRAL                       := ImgRAL;
  ThreadExtraction.ImgStocks                    := ImgStocks;
  ThreadExtraction.OnTerminate                  := FinThread;
  ThreadExtraction.Start();
end;

end.
