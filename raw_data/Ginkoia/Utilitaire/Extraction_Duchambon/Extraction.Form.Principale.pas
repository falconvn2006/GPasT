unit Extraction.Form.Principale;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.StdCtrls, System.Win.Registry, System.StrUtils,
  Extraction.Ressourses, Extraction.Thread.Extraction, Extraction.Magasins,
  FireDAC.UI.Intf, FireDAC.VCLUI.Wait, FireDAC.Stan.Intf, FireDAC.Comp.UI;

type
  TFormPrincipale = class(TForm)
    PnlTitre: TPanel;
    LblTitre: TLabel;
    LblBaseDonnees: TLabel;
    TxtBaseDonnees: TEdit;
    BtnBaseDonnees: TButton;
    ChkArticles: TCheckBox;
    TxtArticles: TEdit;
    BtnArticles: TButton;
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
    ImgArticles: TImage;
    LblMagasin: TLabel;
    ImgMagasin: TImage;
    CmbMagasin: TComboBox;
    Bevel1: TBevel;
    BtnChargerMagasins: TBitBtn;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    ChkDescriptions: TCheckBox;
    ImgDescriptions: TImage;
    TxtDescriptions: TEdit;
    BtnDescriptions: TButton;
    procedure FormCreate(Sender: TObject);
    procedure BtnBaseDonneesClick(Sender: TObject);
    procedure BtnFichiersClick(Sender: TObject);
    procedure ChkFichierClick(Sender: TObject);
    procedure BtnExtraireClick(Sender: TObject);
    procedure DemarrerThread();
    procedure FinThread(Sender: TObject);
    procedure BtnAnnulerClick(Sender: TObject);
    procedure BtnChargerMagasinsClick(Sender: TObject);
    procedure CmbMagasinChange(Sender: TObject);
  private
    { Déclarations privées }
    ListeMagId: array of Integer;
    iMagasin: Integer;
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
  if MessageDlg(RS_ARRETER, mtConfirmation, mbYesNo, 0) = mrYes then
  begin
    if Assigned(ThreadExtraction) then
    begin
      bInterruption := True;
      ThreadExtraction.Terminate();
    end;
  end;
end;

procedure TFormPrincipale.BtnBaseDonneesClick(Sender: TObject);
begin
  // Ouvre un fichier de base de données
  OdBaseDonnees.FileName    := TxtBaseDonnees.Text;
  OdBaseDonnees.InitialDir  := ExtractFileDir(OdBaseDonnees.FileName);
  if OdBaseDonnees.Execute() then
    TxtBaseDonnees.Text := OdBaseDonnees.FileName;
end;

procedure TFormPrincipale.BtnChargerMagasinsClick(Sender: TObject);
var
  i, iIndexMagasins: Integer;
  slMagasins: TStringList;
begin
  // Liste des magasins
  if (Length(TxtBaseDonnees.Text) > 0) and FileExists(TxtBaseDonnees.Text) then
  begin
    CmbMagasin.Enabled := True;
    LblMagasin.Enabled := True;
    ImgMagasin.Picture.Bitmap.LoadFromResourceName(HInstance, 'MAGASIN');

    CmbMagasin.Items.Clear();
    slMagasins := TStringList.Create();
    try
      if ListeMagasins(TxtBaseDonnees.Text, slMagasins) then
      begin
        SetLength(ListeMagId, slMagasins.Count);

        iIndexMagasins := 0;

        for i := 0 to slMagasins.Count - 1 do
        begin
          CmbMagasin.Items.Add(slMagasins.ValueFromIndex[i]);
          ListeMagId[i] := StrToInt(slMagasins.Names[i]);

          if StrToInt(slMagasins.Names[i]) = iMagasin then
            iIndexMagasins := i;
        end;

        CmbMagasin.Enabled   := True;
        CmbMagasin.ItemIndex := iIndexMagasins;
      end;

      CmbMagasinChange(nil);
    finally
      slMagasins.Free();
    end;
  end
  else begin
    CmbMagasin.Enabled    := False;
    LblMagasin.Enabled    := False;
    ImgMagasin.Picture.Bitmap.LoadFromResourceName(HInstance, 'MAGASIN_OFF');
    CmbMagasin.Items.Clear();
  end;
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
  case AnsiIndexText(TWinControl(Sender).Name, ['BtnArticles', 'BtnDescriptions']) of
    // Articles
    0: begin
      SdFichier.FileName    := TxtArticles.Text;
      SdFichier.InitialDir  := ExtractFileDir(SdFichier.FileName);
      if SdFichier.Execute() then
        TxtArticles.Text := SdFichier.FileName;
    end;
    // Descriptions
    1: begin
      SdFichier.FileName    := TxtDescriptions.Text;
      SdFichier.InitialDir  := ExtractFileDir(SdFichier.FileName);
      if SdFichier.Execute() then
        TxtDescriptions.Text := SdFichier.FileName;
    end;
  end;
end;

procedure TFormPrincipale.ChkFichierClick(Sender: TObject);
begin
  case AnsiIndexText(TWinControl(Sender).Name, ['ChkArticles', 'ChkDescriptions']) of
    // Articles
    0: begin
      TxtArticles.Enabled             := TCheckBox(Sender).Checked;
      BtnArticles.Enabled             := TCheckBox(Sender).Checked;
    end;
    // Descriptions
    1: begin
      TxtDescriptions.Enabled         := TCheckBox(Sender).Checked;
      BtnDescriptions.Enabled         := TCheckBox(Sender).Checked;
    end;
  end;
end;

procedure TFormPrincipale.CmbMagasinChange(Sender: TObject);
begin
  if CmbMagasin.ItemIndex > -1 then
    iMagasin    := ListeMagId[CmbMagasin.ItemIndex]
  else
    iMagasin    := 0;
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
  ImgIcone.Picture.Icon.Handle := LoadImage(HInstance, 'MAINICON', IMAGE_ICON, 48, 48, LR_DEFAULTCOLOR);
  ImgBaseDonnees.Picture.Bitmap.LoadFromResourceName(HInstance, 'DATABASE');
  ImgArticles.Picture.Bitmap.LoadFromResourceName(HInstance, 'PACKAGE_EDITORS');
  ImgDescriptions.Picture.Bitmap.LoadFromResourceName(HInstance, 'PACKAGE_EDITORS');
  BtnChargerMagasins.Glyph.LoadFromResourceName(HInstance, 'RECUPERER');
  ImgMagasin.Picture.Bitmap.LoadFromResourceName(HInstance, 'MAGASIN_OFF');

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
  TxtArticles.Text            := Format('%sArticles.txt', [CheminCourant]);
  TxtDescriptions.Text        := Format('%sDescriptions.txt', [CheminCourant]);

  LblProgression.Caption      := RS_PROGRESSION;
end;

procedure TFormPrincipale.DemarrerThread();
begin
  if Assigned(ThreadExtraction) then
    Exit;

  // Paramètre le thread
  bInterruption                               := False;
  ThreadExtraction                            := TThreadExtraction.Create(True);
  ThreadExtraction.BaseDonnees                := TxtBaseDonnees.Text;
  ThreadExtraction.FichierArticles            := TxtArticles.Text;
  ThreadExtraction.FichierDescriptions        := TxtDescriptions.Text;
  ThreadExtraction.ExtraireArticles           := ChkArticles.Checked;
  ThreadExtraction.ExtraireDescriptions       := ChkDescriptions.Checked;
  ThreadExtraction.LblProgression             := @LblProgression;
  ThreadExtraction.PbProgression              := @PbProgression;
  ThreadExtraction.ImgArticles                := @ImgArticles;
  ThreadExtraction.ImgDescriptions            := @ImgDescriptions;
  ThreadExtraction.iMagId                     := iMagasin;
  ThreadExtraction.OnTerminate                := FinThread;
  ThreadExtraction.Start();
end;

end.
