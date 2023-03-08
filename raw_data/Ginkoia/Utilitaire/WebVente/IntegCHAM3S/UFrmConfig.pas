unit UFrmConfig;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UGestDossiers, Vcl.StdCtrls,
  Vcl.CheckLst, System.UITypes;

type
  TFrmConfig = class(TForm)
    btnSave: TButton;
    btnFermer: TButton;
    edtNom: TEdit;
    edtURL: TEdit;
    edtPort: TEdit;
    edtUser: TEdit;
    edtPassword: TEdit;
    edtRepertoire: TEdit;
    lbDossiers: TListBox;
    btnAjouter: TButton;
    btnSuppr: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    lblPriorite: TLabel;
    edtPriorite: TEdit;
    procedure lbDossiersClick(Sender: TObject);
    procedure btnAjouterClick(Sender: TObject);
    procedure btnSupprClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure edtNomChange(Sender: TObject);
  private
    FItemIndex: integer ;
    FGestDossiers : TGestDossiers;
    procedure LoadDossiers;
  public
    constructor Create(AOwner: TComponent; pGestDossiers: TGestDossiers); reintroduce;
  end;

var
  FrmConfig: TFrmConfig;

implementation

{$R *.dfm}

{ TFrmConfig }

procedure TFrmConfig.btnAjouterClick(Sender: TObject);
begin
  FGestDossiers.CreerDossier(InputBox('Créer un dossier','Nom : ',''));
  LoadDossiers;
end;

procedure TFrmConfig.btnSaveClick(Sender: TObject);
begin
  with FGestDossiers.Dossiers[FItemIndex] do
  begin
    Nom := edtNom.Text;
    URL := edtURL.Text;
    Port := StrToIntDef(edtPort.Text, 21);
    User := edtUser.Text;
    Password := edtPassword.Text;
    Repertoire := edtRepertoire.Text;
    Priorite := StrToInt(edtPriorite.Text);
  end;
  LoadDossiers;
end;

procedure TFrmConfig.btnSupprClick(Sender: TObject);
begin
  if MessageDlg('Supprimer le dossier '+FGestDossiers.Dossiers[lbDossiers.ItemIndex].Nom+' ?',
                  mtWarning,[mbYes, mbCancel],0) = mrYes then
  begin
    FGestDossiers.SupprimerDossier(FGestDossiers.Dossiers[lbDossiers.ItemIndex].ID);
    LoadDossiers;
  end;
end;

constructor TFrmConfig.Create(AOwner: TComponent; pGestDossiers: TGestDossiers);
begin
  inherited Create(AOwner);
  FGestDossiers := pGestDossiers;
end;

procedure TFrmConfig.edtNomChange(Sender: TObject);
begin
  btnSave.Enabled := true;
end;

procedure TFrmConfig.FormShow(Sender: TObject);
begin
  LoadDossiers;
end;

procedure TFrmConfig.lbDossiersClick(Sender: TObject);
var
  lModal: integer;
begin
  if lbDossiers.ItemIndex <> FItemIndex then
  begin
    if FItemIndex > -1 then
    begin
      if btnSave.Enabled then
      begin
        lModal := MessageDlg('Sauvegarder les changements ?',mtWarning,[mbYes,mbCancel],0);
        if lModal = mrYes then
          btnSaveClick(nil);
      end;
    end;
    FItemIndex := lbDossiers.ItemIndex;
    if FItemIndex > -1 then
    begin
      with FGestDossiers.Dossiers[FItemIndex] do
      begin
        edtNom.Text := Nom;
        edtURL.Text := URL;
        edtPort.Text := IntToStr(Port);
        edtUser.Text := User;
        edtPassword.Text := Password;
        edtRepertoire.Text := Repertoire;
        edtPriorite.Text := IntToStr(Priorite);
        btnSave.Enabled := false;
        edtNom.Enabled := true;
        edtURL.Enabled := true;
        edtPort.Enabled := true;
        edtUser.Enabled := true;
        edtPassword.Enabled := true;
        edtRepertoire.Enabled := true;
        edtPriorite.Enabled := true;
        btnSuppr.Enabled := true;
      end;
    end
    else
    begin
      btnSave.Enabled := false;
      edtNom.Enabled := false;
      edtURL.Enabled := false;
      edtPort.Enabled := false;
      edtUser.Enabled := false;
      edtPassword.Enabled := false;
      edtRepertoire.Enabled := false;
      edtPriorite.Enabled := false;
      btnSuppr.Enabled := false;
    end;
  end;
end;

procedure TFrmConfig.LoadDossiers;
var
  lBcl: integer;
  lIndex: integer;
begin
  lIndex := lbDossiers.ItemIndex;
  FItemIndex := -1;
  edtNom.Clear;
  edtURL.Clear;
  edtPort.Clear;
  edtUser.Clear;
  edtPassword.Clear;
  edtRepertoire.Clear;
  edtPriorite.Clear;
  btnSuppr.Enabled:= false;
  btnSave.Enabled := false;
  lbDossiers.Clear;
  FGestDossiers.LoadDossiers;
  for lBcl := 0 to FGestDossiers.Dossiers.Count -1 do
  begin
    lbDossiers.Items.Add(FGestDossiers.Dossiers[lBcl].Nom);
  end;
  if lIndex < FGestDossiers.Dossiers.Count then
  begin
    lbDossiers.ItemIndex := lIndex;
    lbDossiersClick(nil);
  end;
end;

end.
