unit GSCFGMain_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ActnList, CategoryButtons, cxCheckBox, DBClient, GSCFGMain_DM, ExtCtrls,
  StdCtrls, LMDCustomButton, LMDButton, Grids, DBGrids, uVersion;

type
  TFMain = class(TForm)
    Pan_GroupeBouton: TPanel;
    CategoryButtons1: TCategoryButtons;
    acl_Bouton: TActionList;
    acb_AjouterDossier: TAction;
    acb_ModifierDossier: TAction;
    acb_SupprimerDossier: TAction;
    acb_ActiverDesactiver: TAction;
    acb_Paramétrage: TAction;
    Pan_Centre: TPanel;
    dbg_Dossier: TDBGrid;
    Pan_Entete: TPanel;
    Pan_EnPied: TPanel;
    Ds_Dossier: TDataSource;
    Nbt_Quitter: TButton;
    Ds_: TDataSource;
    acb_Horaires: TAction;
    Lab_Recherche: TLabel;
    edt_Recherche: TEdit;
    procedure Nbt_QuitterClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure acb_AjouterDossierExecute(Sender: TObject);
    procedure acb_ModifierDossierExecute(Sender: TObject);
    procedure acb_SupprimerDossierExecute(Sender: TObject);
    procedure acb_ActiverDesactiverExecute(Sender: TObject);
    procedure acb_ParamétrageExecute(Sender: TObject);
    procedure dbg_DossierDblClick(Sender: TObject);
    procedure CategoryButtons1CategoryCollapase(Sender: TObject;
      const Category: TButtonCategory);
    procedure acb_HorairesExecute(Sender: TObject);
    procedure edt_RechercheChange(Sender: TObject);
  private
    procedure RendreBoutonActif(vpBool : Boolean);

    function  DB_UPDATE_SupprimerDossier     : Boolean;
    function  DB_UPDATE_RendreDossierInactif : Boolean;
  public
    { Déclarations publiques }
  end;

var
  FMain: TFMain;

implementation

uses
  GSCFGSMDossier_Frm,
  GSCFGSMParametre_Frm,
  GSCFG_Types,
  GSCFGSMListeHoraire_Frm;

{$R *.dfm}

procedure TFMain.FormCreate(Sender: TObject);
begin
  if FMain_DM.InitiliaserConnexion then
  begin
    FMain_DM.UpdateFieldDatabase; //Partie création mise à jours des champs si besoin
    FMain_DM.OuvrirTable;
    RendreBoutonActif(True);
  end
  else
  begin
    RendreBoutonActif(False);
    showMessage('Impossible de se connecter à la base');
  end;

  Caption := 'GsConfig Version ' + GetNumVersionSoft;

end;

procedure TFMain.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(key) = VK_Escape then
    Close;
end;

procedure TFMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;

  Action := CaFree;
end;

//------------------------------------------------------------------------------
//                                                               +-------------+
//                                                               |    OBJET    |
//                                                               +-------------+
//------------------------------------------------------------------------------

//-----------------------------------------------------------------> Boutton

procedure TFMain.Nbt_QuitterClick(Sender: TObject);
begin
  Close;
end;

//---------------------------------------------------------> CategorieBouton

procedure TFMain.CategoryButtons1CategoryCollapase(Sender: TObject;
  const Category: TButtonCategory);
begin
  Category.Collapsed := False;
end;

//-----------------------------------------------------------------> Grille

procedure TFMain.dbg_DossierDblClick(Sender: TObject);
begin
  acb_ModifierDossierExecute(acb_ModifierDossier);
end;

//------------------------------------------------------------------------------
//                                                               +-------------+
//                                                               |    ACTION   |
//                                                               +-------------+
//------------------------------------------------------------------------------

procedure TFMain.RendreBoutonActif(vpBool : Boolean);
begin
  acb_AjouterDossier.Enabled    := vpBool;
  acb_ModifierDossier.Enabled   := vpBool;
  acb_SupprimerDossier.Enabled  := vpBool;
  acb_ActiverDesactiver.Enabled := vpBool;
end;

procedure TFMain.acb_AjouterDossierExecute(Sender: TObject);
begin
  if not FMain_DM.idb_GoSport.Connected then
    Exit;

  GTypeSaisie := tsAjout;

  FSMDossier := TFSMDossier.Create(self);
  FSMDossier.ShowModal;

  GTypeSaisie := tsNull;
end;

procedure TFMain.acb_HorairesExecute(Sender: TObject);
begin
  with TFrmListeHoraire.Create(Self) do
  begin
    ShowModal();
    Free();
  end;
end;

procedure TFMain.acb_ModifierDossierExecute(Sender: TObject);
begin
  if FMain_DM.cds_Dossier.RecordCount = 0 then
    Exit;

  GTypeSaisie := tsModif;

  FSMDossier := TFSMDossier.Create(self);
  FSMDossier.ShowModal;

  GTypeSaisie := tsNull;
end;

procedure TFMain.acb_SupprimerDossierExecute(Sender: TObject);
begin
  if FMain_DM.cds_Dossier.RecordCount = 0 then
    Exit;

  if application.MessageBox('Etes-vous sûr de vouloir supprimer cet enregistrement?',
                            'Suppresion dossier', MB_IconExclamation
                            + MB_OKCANCEL) = IDOK then
    if DB_UPDATE_SupprimerDossier then
      FMain_DM.OuvrirTable;
end;

procedure TFMain.acb_ActiverDesactiverExecute(Sender: TObject);
begin
  if FMain_DM.cds_Dossier.RecordCount = 0 then
    Exit;

  if DB_UPDATE_RendreDossierInactif then
    FMain_DM.OuvrirTable;
end;

procedure TFMain.acb_ParamétrageExecute(Sender: TObject);
begin
  FParametre := TFParametre.create(self);
  FParametre.ShowModal;
end;

//------------------------------------------------------------------------------
//                                                          +------------------+
//                                                          |   ACTION TABLE   |
//                                                          +------------------+
//------------------------------------------------------------------------------

//----------------------------------------------> DB_UPDATE_SupprimerDossier

function TFMain.DB_UPDATE_SupprimerDossier : Boolean;
var
  vIdDossier : Integer;
begin
  with FMain_DM.Ibc_Maj_GoSport do
  begin
    SQL.Clear;

    vIdDossier := FMain_DM.cds_DossierDOS_ID.AsInteger;

    try
//JB
      IB_Transaction.StartTransaction();
//
      SQL.Add(' UPDATE DOSSIERS SET');
      SQL.Add('  DOS_ENABLED = 0');
      SQL.Add(' ,DOS_ACTIVE = 0');
      SQL.Add(' ,DOS_DTDELETE = :PDTDELETE');
      SQL.Add(' WHERE DOS_ID = :PDOSID');

      ParamCheck := True;
      ParamByName('PDTDELETE').AsDate := now;
      ParamByName('PDOSID').AsInteger := vIdDossier;

      ExecSQL;

      IB_Transaction.Commit;

      Result := True;
    except
      Result := False;
      IB_Transaction.Rollback();
      ShowMessage('Erreur durant la suppression');
    end;
  end;
end;


procedure TFMain.edt_RechercheChange(Sender: TObject);
begin
  Ds_Dossier.DataSet.Filtered := False;
  if Trim(edt_Recherche.Text) <> '' then
  begin
    Ds_Dossier.DataSet.Filter := 'Upper(DOS_NOM) like ' + QuotedStr('%' + edt_Recherche.Text + '%');
    Ds_Dossier.DataSet.Filtered := True;
  end;

end;

//------------------------------------------> DB_UPDATE_RendreDossierInactif

function TFMain.DB_UPDATE_RendreDossierInactif : Boolean;
var
  vIdDossier, vActive : Integer;
begin
  with FMain_DM.Ibc_Maj_GoSport do
  begin
    SQL.Clear;

    vIdDossier := FMain_DM.cds_DossierDOS_ID.AsInteger;

                                  // Change l'etat Actif du dossier
    if FMain_DM.cds_DossierDOS_ACTIVE.AsInteger = 0 then
      vActive := 1
    else
      vActive := 0;

    try
//JB
      IB_Transaction.StartTransaction();
//
      SQL.Add(' UPDATE DOSSIERS SET');
      SQL.Add('  DOS_ACTIVE = :PDOSACTIVE');
      SQL.Add(' WHERE DOS_ID = :PDOSID');

      ParamByName('PDOSACTIVE').AsInteger := vActive;
      ParamByName('PDOSID').AsInteger := vIdDossier;

      ExecSQL;

      IB_Transaction.Commit;

      Result := True;
    except
      Result := False;
      IB_Transaction.Rollback();
      ShowMessage('Erreur durant l''Accès à la table Dossier');
    end;
  end;
end;

end.
