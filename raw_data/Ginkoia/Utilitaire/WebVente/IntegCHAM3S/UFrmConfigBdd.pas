unit UFrmConfigBdd;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UGestDossiers, Vcl.StdCtrls, System.UITypes,
  Vcl.Mask;

type
  TFrmConfigBdd = class(TForm)
    btnCheminBaseDossier: TButton;
    edtCheminBaseDossier: TEdit;
    btnFermer: TButton;
    lblTitreWeb: TLabel;
    btnCheminBaseMaitre: TButton;
    edtCheminBaseMaitre: TEdit;
    lblTitreMaitre: TLabel;
    cbDomaine: TComboBox;
    lblDomaine: TLabel;
    btnConnectDossier: TButton;
    btnConnectMaitre: TButton;
    lblHisto: TLabel;
    edtHistorique: TEdit;
    cbSiteWeb: TComboBox;
    lblSiteWeb: TLabel;
    cbAuto: TCheckBox;
    lblFrequence: TLabel;
    edtFrequence: TEdit;
    procedure btnCheminBaseDossierClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtCheminBaseDossierChange(Sender: TObject);
    procedure btnCheminBaseMaitreClick(Sender: TObject);
    procedure btnConnectDossierClick(Sender: TObject);
    procedure btnConnectMaitreClick(Sender: TObject);
    procedure edtCheminBaseMaitreChange(Sender: TObject);
    procedure cbDomaineChange(Sender: TObject);
    procedure edtHistoriqueExit(Sender: TObject);
    procedure cbSiteWebChange(Sender: TObject);
    procedure edtFrequenceExit(Sender: TObject);
    procedure cbAutoClick(Sender: TObject);
    procedure btnFermerClick(Sender: TObject);
  private
    FGestDossiers : TGestDossiers;
    procedure LoadDomaine;
    procedure LoadSiteWeb;
  public
    constructor Create(AOwner: TComponent; pGestDossiers: TGestDossiers); reintroduce;
  end;

var
  FrmConfigBdd: TFrmConfigBdd;

implementation

{$R *.dfm}

procedure TFrmConfigBdd.btnCheminBaseDossierClick(Sender: TObject);
var
  lOpen : TOpenDialog;
begin
  lOpen := TOpenDialog.Create(Application.MainForm);
  lOpen.Filter := 'Interbase File (*.IB)|*.IB';
  lOpen.Options := [ofFileMustExist];
  lOpen.InitialDir := ExtractFilePath(edtCheminBaseDossier.Text);
  lOpen.Title := 'Sélectionnez la base Dossiers';
  if lOpen.Execute then
  begin
    edtCheminBaseDossier.Text := lOpen.FileName;
    btnConnectDossier.Click;
  end;
  lOpen.Free;
end;

procedure TFrmConfigBdd.btnCheminBaseMaitreClick(Sender: TObject);
var
  lOpen : TOpenDialog;
begin
  lOpen := TOpenDialog.Create(Application.MainForm);
  lOpen.Filter := 'Interbase File (*.IB)|*.IB';
  lOpen.Options := [ofFileMustExist];
  lOpen.InitialDir := ExtractFilePath(edtCheminBaseMaitre.Text);
  lOpen.Title := 'Sélectionnez la base Maitre';
  if lOpen.Execute then
  begin
    edtCheminBaseMaitre.Text := lOpen.FileName;
    btnConnectMaitre.Click;
  end;
  lOpen.Free;
end;

procedure TFrmConfigBdd.btnConnectDossierClick(Sender: TObject);
begin
  FGestDossiers.BddDossier.Base := edtCheminBaseDossier.Text;
  if FGestDossiers.BaseDossierOk then
  begin
    FGestDossiers.GestIni.BaseDossiers := edtCheminBaseDossier.Text;
    btnConnectDossier.Enabled := false;
  end
  else
  begin
    MessageDlg('Fichier Base de Données Dossiers incorrect ou inexistant',mtError,[mbOK],0);
  end;
end;

procedure TFrmConfigBdd.btnConnectMaitreClick(Sender: TObject);
begin
  FGestDossiers.BddMaitre.Base := edtCheminBaseMaitre.Text;
  if FGestDossiers.BaseMaitreOk then
  begin
    FGestDossiers.GestIni.BaseMaitre := edtCheminBaseMaitre.Text;
    LoadDomaine;
    LoadSiteWeb;
    btnConnectMaitre.Enabled := false;
  end
  else
  begin
    cbDomaine.Enabled := false;
    cbDomaine.Clear;
    cbSiteWeb.Enabled := false;
    cbSiteWeb.Clear;
    MessageDlg('Fichier Base de Données Maitre incorrect ou inexistant',mtError,[mbOK],0);
  end;
end;

procedure TFrmConfigBdd.btnFermerClick(Sender: TObject);
begin
  FGestDossiers.GestIni.Auto := cbAuto.Checked;
  FGestDossiers.GestIni.Domaine := integer(cbDomaine.Items.Objects[cbDomaine.ItemIndex]);
  FGestDossiers.GestIni.ASSCODE := integer(cbSiteWeb.Items.Objects[cbSiteWeb.ItemIndex]);
end;

procedure TFrmConfigBdd.cbAutoClick(Sender: TObject);
begin
  edtFrequence.Enabled := cbAuto.Checked;
  //FGestDossiers.GestIni.Auto := cbAuto.Checked;
end;

procedure TFrmConfigBdd.cbDomaineChange(Sender: TObject);
begin
  //FGestDossiers.GestIni.Domaine := integer(cbDomaine.Items.Objects[cbDomaine.ItemIndex]);
end;

procedure TFrmConfigBdd.cbSiteWebChange(Sender: TObject);
begin
  //FGestDossiers.GestIni.ASSCODE := integer(cbSiteWeb.Items.Objects[cbSiteWeb.ItemIndex]);
end;

constructor TFrmConfigBdd.Create(AOwner: TComponent; pGestDossiers: TGestDossiers);
begin
  inherited Create(AOwner);
  FGestDossiers := pGestDossiers;
end;

procedure TFrmConfigBdd.edtCheminBaseDossierChange(Sender: TObject);
begin
  btnConnectDossier.Enabled := true;
end;

procedure TFrmConfigBdd.edtCheminBaseMaitreChange(Sender: TObject);
begin
  btnConnectMaitre.Enabled := true;
end;

procedure TFrmConfigBdd.edtFrequenceExit(Sender: TObject);
begin
  FGestDossiers.GestIni.Frequence := StrToInt(edtFrequence.Text);
end;

procedure TFrmConfigBdd.edtHistoriqueExit(Sender: TObject);
begin
  FGestDossiers.GestIni.DelaiSupprDate := StrToInt(edtHistorique.Text);
end;

procedure TFrmConfigBdd.FormShow(Sender: TObject);
begin
  edtCheminBaseDossier.Text := FGestDossiers.GestIni.BaseDossiers;
  edtCheminBaseMaitre.Text := FGestDossiers.GestIni.BaseMaitre;
  btnConnectDossier.Enabled := not(FGestDossiers.BaseDossierOK);
  btnConnectMaitre.Enabled := not(FGestDossiers.BaseMaitreOk);
  if not(btnConnectMaitre.Enabled) then
  begin
    LoadDomaine;
    LoadSiteWeb;
  end;
  edtHistorique.Text := IntToStr(FGestDossiers.GestIni.DelaiSupprDate);
  edtFrequence.Text := IntToStr(FGestDossiers.GestIni.Frequence);
  cbAuto.Checked := FGestDossiers.GestIni.Auto;
  edtFrequence.Enabled := cbAuto.Checked;
end;

procedure TFrmConfigBdd.LoadDomaine;
var
  lListe: TStringList;
  lBcl: integer;
begin
  lListe := TStringList.Create;
  cbDomaine.Enabled := true;
  cbDomaine.Clear;
  try
    FGestDossiers.BddMaitre.GetListeDomaine(lListe);
    for lBcl := 0 to lListe.Count -1 do
    begin
      cbDomaine.AddItem(lListe.Names[lBcl],TObject(StrToInt(lListe.Values[lListe.Names[lBcl]])));
    end;
    cbDomaine.ItemIndex := cbDomaine.Items.IndexOfObject(TObject(FGestDossiers.GestIni.Domaine));
  except
    cbDomaine.ItemIndex := -1;
  end;
  lListe.Free;
end;

procedure TFrmConfigBdd.LoadSiteWeb;
var
  lListe: TStringList;
  lBcl: integer;
begin
  lListe := TStringList.Create;
  cbSiteWeb.Enabled := true;
  cbSiteWeb.Clear;
  try
    FGestDossiers.BddMaitre.GetListeSiteWeb(lListe);
    for lBcl := 0 to lListe.Count -1 do
    begin
      cbSiteWeb.AddItem(lListe.Names[lBcl],TObject(StrToInt(lListe.Values[lListe.Names[lBcl]])));
    end;
    cbSiteWeb.ItemIndex := cbSiteWeb.Items.IndexOfObject(TObject(FGestDossiers.GestIni.ASSCODE));
  except
    cbSiteWeb.ItemIndex := -1;
  end;
  lListe.Free;

end;

end.
