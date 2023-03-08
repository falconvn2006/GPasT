UNIT loc_frm;

INTERFACE

USES
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  //Début include Perso
  loc_dm,
  //Fin include Perso
  ComCtrls, RzLabel, DBCtrls, ExtCtrls, IBDatabase;

TYPE
  TFrm_Loc = CLASS(TForm)
    Btn_base: TButton;
    Button1: TButton;
    Button2: TButton;
    tdate: TDateTimePicker;
    Pan_Base: TPanel;
    Pan_Histo: TPanel;
    Pan_Articles: TPanel;
    Lab_Proprio: TLabel;
    Lab_Locali: TLabel;
    Btn_csv: TButton;
    Btn_OK: TButton;
    Cbx_GrilleTaille: TCheckBox;
    Cbx_LstMagProprio: TDBLookupComboBox;
    Cbx_LstMagLocali: TDBLookupComboBox;
    edBase: TEdit;
    edArticle: TEdit;
    edHistorique: TEdit;
    Pb_histo: TProgressBar;
    PrgB_Iec: TProgressBar;
    edMarque: TEdit;
    Btn_Marque: TButton;
    Lab_: TLabel;
    edNomenclature: TEdit;
    Btn_ChoixNomenclature: TButton;
    Btn_DelNomenclature: TButton;
    PrgB_Nomenclature: TProgressBar;
    Btn_AddNomenclature: TButton;
    Chk_Delete_Nkl: TCheckBox;
    Chk_SSFiche: TCheckBox;
    PROCEDURE Btn_OKClick(Sender: TObject);
    PROCEDURE Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Btn_baseClick(Sender: TObject);
    procedure Btn_csvClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Btn_MarqueClick(Sender: TObject);
    procedure Btn_CorrectionClick(Sender: TObject);
    procedure Btn_DelNomenclatureClick(Sender: TObject);
    procedure Btn_ChoixNomenclatureClick(Sender: TObject);
    procedure Btn_AddNomenclatureClick(Sender: TObject);
  PRIVATE
    { Déclarations privées }
  PUBLIC
    { Déclarations publiques }
  END;

VAR
  Frm_Loc: TFrm_Loc;

IMPLEMENTATION

uses UVersion;

{$R *.dfm}

procedure TFrm_Loc.Btn_AddNomenclatureClick(Sender: TObject);
begin
  try
    if not FileExists(edNomenclature.Text+'NOMENCLATURE_LOC.csv') then
      ShowMessage('Le fichier NOMENCLATURE_LOC n''''éxiste pas.')
    else
      if not FileExists(edNomenclature.Text+'TYPES_ARTICLES.csv') then
        ShowMessage('Le fichier TYPES_ARTICLES n''''éxiste pas.')
      else
        if not FileExists(edNomenclature.Text+'CATEGORIE.csv') then
          ShowMessage('Le fichier CATEGORIE n''''éxiste pas.')
        else
          Dm_Loc.TraitementNomenclature(edNomenclature.Text);
  finally

  end;
end;

procedure TFrm_Loc.Btn_baseClick(Sender: TObject);
begin
  edBase.Text := Dm_Loc.ConnectionBase;
end;

procedure TFrm_Loc.Btn_ChoixNomenclatureClick(Sender: TObject);
var
  odTemp : TFileOpenDialog;
begin
  odTemp := TFileOpenDialog.Create(Self);
  try
    odTemp.Title := 'Choix du répertoire des fichiers nomenclature';
    odTemp.Options := [fdoPickFolders, fdoPathMustExist, fdoForceFileSystem];
    odTemp.OkButtonLabel := 'Selectionner';
    if odTemp.Execute then
      edNomenclature.Text := odTemp.FileName + '\';
  finally
    odTemp.Free;
  end;
end;

procedure TFrm_Loc.Btn_CorrectionClick(Sender: TObject);
begin
  Dm_Loc.CorrectionArticle;
end;

procedure TFrm_Loc.Btn_csvClick(Sender: TObject);
begin
  edArticle.Text := Dm_Loc.ChargementArticle;
end;

procedure TFrm_Loc.Btn_DelNomenclatureClick(Sender: TObject);
begin
  try
    Dm_Loc.ViderNomenclature(Chk_Delete_Nkl.Checked);
  finally

  end;
end;

procedure TFrm_Loc.Btn_MarqueClick(Sender: TObject);
begin
  edMarque.Text := Dm_Loc.ChargementMarque;
end;

PROCEDURE TFrm_Loc.Btn_OKClick(Sender: TObject);
begin
  try
    Dm_Loc.TraitementArticle;
  finally

  end;
end;

procedure TFrm_Loc.Button1Click(Sender: TObject);
begin
  edHistorique.Text := Dm_Loc.ChargementHistorique;
end;

PROCEDURE TFrm_Loc.Button2Click(Sender: TObject);
begin
  try
    Dm_Loc.TraitementHistorique;
  finally
    screen.Cursor := crdefault;
    ShowMessage('Traitement (Historique) terminé');
  end;
END;

procedure TFrm_Loc.FormCreate(Sender: TObject);
begin
  //Affichage de la version
  Frm_Loc.Caption := Frm_Loc.Caption + ' - Version: ' + version;
end;

END.

