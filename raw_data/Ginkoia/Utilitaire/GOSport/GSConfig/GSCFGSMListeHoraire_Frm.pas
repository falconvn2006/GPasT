unit GSCFGSMListeHoraire_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, CategoryButtons, StdCtrls, Buttons, ExtCtrls,
  ActnList, GSCFGMain_DM, DB;

type
  TFrmListeHoraire = class(TForm)
    Pan_Left: TPanel;
    Pan_Right: TPanel;
    CategoryButtons: TCategoryButtons;
    dbg_Magasin: TDBGrid;
    acl_Bouton: TActionList;
    acb_AjouterHoraire: TAction;
    acb_ModifierHoraire: TAction;
    acb_SupprimerHoraire: TAction;
    Ds_Horaire: TDataSource;
    acb_ModifFichier: TAction;
    Nbt_Quitter: TButton;
    procedure acb_AjouterHoraireExecute(Sender: TObject);
    procedure acb_ModifierHoraireExecute(Sender: TObject);
    procedure acb_SupprimerHoraireExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure acb_ModifFichierExecute(Sender: TObject);
    procedure Ds_HoraireDataChange(Sender: TObject; Field: TField);
    procedure Nbt_QuitterClick(Sender: TObject);
    procedure dbg_MagasinDblClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

implementation

uses
  GSCFGSMHoraire_Frm, GSCFGSMListeFichier_Frm;

{$R *.dfm}

procedure TFrmListeHoraire.acb_AjouterHoraireExecute(Sender: TObject);
var
  HDeb, HFin : TTime;
  HType : Integer;
begin
  if AddHoraire(Self, HDeb, HFin, HType) then
  begin
    try
      FMain_DM.Ibc_Maj_GoSport.IB_Transaction.StartTransaction();
      FMain_DM.Ibc_Maj_GoSport.SQL.Text := 'insert into horaire (hor_hdeb, hor_hfin, hor_type) values (:hdeb, :hfin, :type);';
      FMain_DM.Ibc_Maj_GoSport.ParamCheck := True;
      FMain_DM.Ibc_Maj_GoSport.ParamByName('hdeb').AsDateTime := HDeb;
      FMain_DM.Ibc_Maj_GoSport.ParamByName('hfin').AsDateTime := HFin;
      FMain_DM.Ibc_Maj_GoSport.ParamByName('type').AsInteger := HType;
      FMain_DM.Ibc_Maj_GoSport.ExecSQL();
      FMain_DM.Ibc_Maj_GoSport.IB_Transaction.Commit();
    except
      FMain_DM.Ibc_Maj_GoSport.IB_Transaction.Rollback();
      ShowMessage('Erreur durant l''insertion');
    end;

    // gestyion des fichier
    if HType = 2 then
    begin
      FMain_DM.Que_GoSport_ReUsable.SQL.Text := 'select hor_id from horaire where hor_hdeb = :hdeb and hor_hfin = :hfin and hor_type = :type;';
      FMain_DM.Que_GoSport_ReUsable.ParamCheck := True;
      FMain_DM.Que_GoSport_ReUsable.ParamByName('hdeb').AsDateTime := HDeb;
      FMain_DM.Que_GoSport_ReUsable.ParamByName('hfin').AsDateTime := HFin;
      FMain_DM.Que_GoSport_ReUsable.ParamByName('type').AsInteger := HType;
      try
        FMain_DM.Que_GoSport_ReUsable.Open();
        if not FMain_DM.Que_GoSport_ReUsable.Eof then
          AskForGestionFichier(Self, FMain_DM.Que_GoSport_ReUsable.FieldByName('hor_id').AsInteger);
      finally
        FMain_DM.Que_GoSport_ReUsable.Close();
      end;
    end;

    FMain_DM.Que_Horaire.Refresh();
  end;
end;

procedure TFrmListeHoraire.acb_ModifFichierExecute(Sender: TObject);
begin
  if FMain_DM.Que_Horaire.FieldByName('hor_type').AsInteger = 2 then
    EditAssignationFichier(Self, FMain_DM.Que_Horaire.FieldByName('hor_id').AsInteger);
end;

procedure TFrmListeHoraire.acb_ModifierHoraireExecute(Sender: TObject);
var
  HDeb, HFin : TTime;
  idHor, HType : Integer;
begin
  if FMain_DM.Que_Horaire.RecordCount = 0 then
    Exit;

  idHor := FMain_DM.Que_Horaire.FieldByName('hor_id').AsInteger;
  HDeb := FMain_DM.Que_Horaire.FieldByName('hor_hdeb').AsDateTime;
  HFin := FMain_DM.Que_Horaire.FieldByName('hor_hfin').AsDateTime;
  HType := FMain_DM.Que_Horaire.FieldByName('hor_type').AsInteger;
  if EditHoraire(Self, idHor, HDeb, HFin, HType) then
  begin
    try
      FMain_DM.Ibc_Maj_GoSport.IB_Transaction.StartTransaction();
      FMain_DM.Ibc_Maj_GoSport.SQL.Text := 'update horaire set hor_hdeb = :hdeb, hor_hfin = :hfin, hor_type = :type where hor_id = :id;';
      FMain_DM.Ibc_Maj_GoSport.ParamCheck := True;
      FMain_DM.Ibc_Maj_GoSport.ParamByName('id').AsInteger := idHor;
      FMain_DM.Ibc_Maj_GoSport.ParamByName('hdeb').AsDateTime := HDeb;
      FMain_DM.Ibc_Maj_GoSport.ParamByName('hfin').AsDateTime := HFin;
      FMain_DM.Ibc_Maj_GoSport.ParamByName('type').AsInteger := HType;
      FMain_DM.Ibc_Maj_GoSport.ExecSQL;
      FMain_DM.Ibc_Maj_GoSport.IB_Transaction.Commit();
    except
      FMain_DM.Ibc_Maj_GoSport.IB_Transaction.Rollback();
      ShowMessage('Erreur durant la mise-à-jour');
    end;
    FMain_DM.Que_Horaire.Refresh();
  end;
end;

procedure TFrmListeHoraire.acb_SupprimerHoraireExecute(Sender: TObject);
begin
  if FMain_DM.Que_Horaire.RecordCount = 0 then
    Exit;

  if application.MessageBox('Etes-vous sûr de vouloir supprimer cet enregistrement?',
                            'Suppresion horaire', MB_IconExclamation
                            + MB_OKCANCEL) = IDOK then
  begin
    try
      FMain_DM.Ibc_Maj_GoSport.IB_Transaction.StartTransaction();
      FMain_DM.Ibc_Maj_GoSport.SQL.Text := 'delete from horaire where hor_id = :idhor;';
      FMain_DM.Ibc_Maj_GoSport.ParamCheck := True;
      FMain_DM.Ibc_Maj_GoSport.ParamByName('idhor').AsInteger := FMain_DM.que_Horaire.FieldByName('hor_id').AsInteger;
      FMain_DM.Ibc_Maj_GoSport.ExecSQL;
      FMain_DM.Ibc_Maj_GoSport.IB_Transaction.Commit();
    except
      FMain_DM.Ibc_Maj_GoSport.IB_Transaction.Rollback();
      ShowMessage('Erreur durant la suppression');
    end;
    FMain_DM.Que_Horaire.Refresh();
  end;
end;

procedure TFrmListeHoraire.dbg_MagasinDblClick(Sender: TObject);
begin
  acb_ModifierHoraireExecute(Sender);
end;

procedure TFrmListeHoraire.Ds_HoraireDataChange(Sender: TObject; Field: TField);
begin
  acb_ModifFichier.Enabled := (FMain_DM.Que_Horaire.FieldByName('hor_type').AsInteger = 2);
end;

procedure TFrmListeHoraire.FormCreate(Sender: TObject);
begin
  FMain_DM.Que_Horaire.Open();
end;

procedure TFrmListeHoraire.Nbt_QuitterClick(Sender: TObject);
begin
  Close();
end;

end.
