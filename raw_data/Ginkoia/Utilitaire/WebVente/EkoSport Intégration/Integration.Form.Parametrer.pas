unit Integration.Form.Parametrer;

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
  Vcl.Samples.Spin,
  Integration.Methodes;

type
  TFormParametrer = class(TForm)
    BtnValider: TBitBtn;
    PnlBoutons: TPanel;
    BtnAnnuler: TBitBtn;
    GrbGeneral: TGroupBox;
    GrpLot1: TGroupBox;
    LblNiveau: TLabel;
    CmbNiveau: TComboBox;
    LblDuree: TLabel;
    SpnDuree: TSpinEdit;
    LblJours: TLabel;
    LblDomaine: TLabel;
    CmbDomaine: TComboBox;
    GpBaseDonnees: TGridPanel;
    PnlBaseDonneesTitre: TPanel;
    ImgBaseDonnees: TImage;
    LblBaseDonnees: TLabel;
    PnlBaseDonneesChemin: TPanel;
    TxtBaseDonnees: TEdit;
    BtnBaseDonnees: TButton;
    OdBaseDonnees: TOpenDialog;
    GpLot1: TGridPanel;
    GpParametres: TGridPanel;
    PnlJournaux: TPanel;
    LblSauvegarde: TLabel;
    PnlSauvegarde: TPanel;
    ChkSauvegarde: TCheckBox;
    ChkSauvFichier: TCheckBox;
    LblOeuf: TLabel;
    GrpCourriel: TGroupBox;
    GpCourriel: TGridPanel;
    LblCourrielDestinataires: TLabel;
    TxtCourrielDestinataires: TEdit;
    procedure SpnDureeChange(Sender: TObject);
    procedure BtnBaseDonneesClick(Sender: TObject);
    procedure TxtBaseDonneesChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    ListeActId: array of Integer;
    iDomaine: Integer;
  end;

var
  FormParametrer: TFormParametrer;

implementation

{$R *.dfm}

procedure TFormParametrer.BtnBaseDonneesClick(Sender: TObject);
begin
  // Ouvre un fichier de base de données
  OdBaseDonnees.FileName    := ExtractFileName(TxtBaseDonnees.Text);
  OdBaseDonnees.InitialDir  := ExtractFileDir(TxtBaseDonnees.Text);
  if OdBaseDonnees.Execute() then
    TxtBaseDonnees.Text := OdBaseDonnees.FileName;
end;

procedure TFormParametrer.CreateParams(var Params: TCreateParams);
begin
  inherited;

  Params.WindowClass.Style := Params.WindowClass.Style or CS_DROPSHADOW;
end;

procedure TFormParametrer.FormCreate(Sender: TObject);
begin
  // Charge les icônes
  ImgBaseDonnees.Picture.Bitmap.LoadFromResourceName(HInstance, 'DATABASE');
end;

procedure TFormParametrer.SpnDureeChange(Sender: TObject);
begin
  if SpnDuree.Value > 1 then
    LblJours.Caption := 'jours'
  else begin

    LblJours.Caption := 'jour';
  end;
end;

procedure TFormParametrer.TxtBaseDonneesChange(Sender: TObject);
var
  i, iIndexDomaine: Integer;
  slDomaines: TStringList;
begin
  // Domaine d'activité
  if (Length(TxtBaseDonnees.Text) > 0) and FileExists(TxtBaseDonnees.Text) then
  begin
    CmbDomaine.Enabled := True;
    LblDomaine.Enabled := True;

    CmbDomaine.Items.Clear();

    slDomaines := TStringList.Create();
    try
      if ListeDomainesActivitees(TxtBaseDonnees.Text, slDomaines) then
      begin
        SetLength(ListeActId, slDomaines.Count);

        iIndexDomaine := 0;

        for i := 0 to slDomaines.Count - 1 do
        begin
          CmbDomaine.Items.Add(slDomaines.ValueFromIndex[i]);
          ListeActId[i] := StrToInt(slDomaines.Names[i]);

          if StrToInt(slDomaines.Names[i]) = iDomaine then
            iIndexDomaine := i;
        end;

        CmbDomaine.Enabled   := True;
        CmbDomaine.ItemIndex := iIndexDomaine;
      end;
    finally
      slDomaines.Free();
    end;
  end
  else begin
    CmbDomaine.Enabled    := False;
    LblDomaine.Enabled    := False;
    CmbDomaine.Items.Clear();
  end;
end;

end.
