unit GSCFGSMListeFichier_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons;

type
  TFrmListeFichier = class(TForm)
    Pan_Listes: TGridPanel;
    Pan_Ctrl: TPanel;
    Nbt_AddAll: TSpeedButton;
    Nbt_Add: TSpeedButton;
    Nbt_Dell: TSpeedButton;
    Nbt_DellAll: TSpeedButton;
    Pan_FichiersDispo: TPanel;
    Lab_FichiersDispo: TLabel;
    Lbx_FichiersDispo: TListBox;
    Pan_Bottom: TPanel;
    Nbt_Cancel: TBitBtn;
    Nbt_Post: TBitBtn;
    Pan_FichiersLier: TPanel;
    Lab_FichiersLier: TLabel;
    Lbx_FichiersLier: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure Nbt_PostClick(Sender: TObject);
    procedure Nbt_AddAllClick(Sender: TObject);
    procedure Nbt_AddClick(Sender: TObject);
    procedure Nbt_DellClick(Sender: TObject);
    procedure Nbt_DellAllClick(Sender: TObject);
    procedure Lbx_FichiersLierDblClick(Sender: TObject);
    procedure Lbx_FichiersDispoDblClick(Sender: TObject);
  private
    { Déclarations privées }
    FHoraireID : integer;

    procedure SetHoraireID(Value : integer);
  public
    { Déclarations publiques }
    property HoraireID : integer read FHoraireID write SetHoraireID;
  end;

function AskForGestionFichier(AOwner : TComponent; idhor : integer) : boolean;
function EditAssignationFichier(AOwner : TComponent; idhor : integer) : boolean;

implementation

uses
  GSCFGMain_DM;

{$R *.dfm}

function AskForGestionFichier(AOwner : TComponent; idhor : integer) : boolean;
var
  Res : integer;
begin
  Res := MessageDlg('Voulez-vous paramétrer des fichiers pour cet horaire ?'#13
                  + '"Oui" pour faire l''assignation manuelle'#13
                  + '"Non pour tout" pour n''assigner aucun fichier'#13
                  + '"Oui pout tout" pour assigner tous les fichiers',
                    mtConfirmation, [mbYes, mbYesToAll, mbNoToAll], 0);
  case Res of
    mrYes : result := EditAssignationFichier(AOwner, idhor);
    mrYesToAll :
      begin
        try
          FMain_DM.Ibc_Maj_GoSport.IB_Transaction.StartTransaction();
          FMain_DM.Ibc_Maj_GoSport.SQL.Text := 'insert into horfic (hof_horid, hof_ficid) select :idhor, fic_id from fichier;';
          FMain_DM.Ibc_Maj_GoSport.ParamCheck := True;
          FMain_DM.Ibc_Maj_GoSport.ParamByName('idhor').AsInteger := idhor;
          FMain_DM.Ibc_Maj_GoSport.ExecSQL();
          FMain_DM.Ibc_Maj_GoSport.IB_Transaction.Commit();
        except
          FMain_DM.Ibc_Maj_GoSport.IB_Transaction.Rollback();
          ShowMessage('Erreur durant l''insertion');
          Exit;
        end;
      end;
    else result := false;
  end;
end;

function EditAssignationFichier(AOwner : TComponent; idhor : integer) : boolean;
begin
  with TFrmListeFichier.Create(AOwner) do
  begin
    HoraireId := idhor;
    Result := ShowModal() = mrOK;
    Free();
  end;
end;

{ TFrmListeFichier }

procedure TFrmListeFichier.SetHoraireID(Value : integer);
begin
  if not (Value = FHoraireID) then
  begin
    FHoraireID := Value;

    Lbx_FichiersDispo.Items.Clear();
    Lbx_FichiersLier.Items.Clear();
    try
      FMain_DM.Que_GoSport_ReUsable.Close();
      FMain_DM.Que_GoSport_ReUsable.SQL.Text := 'select * from fichier left join horfic on hof_ficid = fic_id and hof_horid = :horid;';
      FMain_DM.Que_GoSport_ReUsable.ParamCheck := True;
      FMain_DM.Que_GoSport_ReUsable.ParamByName('horid').AsInteger := FHoraireID;
      FMain_DM.Que_GoSport_ReUsable.Open();
      while not FMain_DM.Que_GoSport_ReUsable.Eof do
      begin
        if FMain_DM.Que_GoSport_ReUsable.FieldByName('hof_id').IsNull then
        begin
          // non assigné
          Lbx_FichiersDispo.AddItem(FMain_DM.Que_GoSport_ReUsable.FieldByName('fic_libelle').AsString, nil);
        end
        else
        begin
          // assigne
          Lbx_FichiersLier.AddItem(FMain_DM.Que_GoSport_ReUsable.FieldByName('fic_libelle').AsString, Pointer(FMain_DM.Que_GoSport_ReUsable.FieldByName('hof_id').AsInteger));
        end;

        FMain_DM.Que_GoSport_ReUsable.Next();
      end;
    finally
      FMain_DM.Que_GoSport_ReUsable.Close();
    end;
  end;
end;

procedure TFrmListeFichier.FormCreate(Sender: TObject);
begin
  FHoraireID := 0;
end;

procedure TFrmListeFichier.Lbx_FichiersDispoDblClick(Sender: TObject);
begin
  Nbt_AddClick(Sender);
end;

procedure TFrmListeFichier.Lbx_FichiersLierDblClick(Sender: TObject);
begin
  Nbt_DellClick(sender);
end;

procedure TFrmListeFichier.Nbt_AddAllClick(Sender: TObject);
var
  i : integer;
begin
  for i := Lbx_FichiersDispo.Items.Count -1 downto 0 do
  begin
    Lbx_FichiersLier.AddItem(Lbx_FichiersDispo.Items[i], Lbx_FichiersDispo.Items.Objects[i]);
    Lbx_FichiersDispo.Items.Delete(i);
  end;
end;

procedure TFrmListeFichier.Nbt_AddClick(Sender: TObject);
var
  i : integer;
begin
  for i := Lbx_FichiersDispo.Items.Count -1 downto 0 do
  begin
    if Lbx_FichiersDispo.Selected[i] then
    begin
      Lbx_FichiersLier.AddItem(Lbx_FichiersDispo.Items[i], Lbx_FichiersDispo.Items.Objects[i]);
      Lbx_FichiersDispo.Items.Delete(i);
    end;
  end;
end;

procedure TFrmListeFichier.Nbt_DellAllClick(Sender: TObject);
var
  i : integer;
begin
  for i := Lbx_FichiersLier.Items.Count -1 downto 0 do
  begin
    Lbx_FichiersDispo.AddItem(Lbx_FichiersLier.Items[i], Lbx_FichiersLier.Items.Objects[i]);
    Lbx_FichiersLier.Items.Delete(i);
  end;
end;

procedure TFrmListeFichier.Nbt_DellClick(Sender: TObject);
var
  i : integer;
begin
  for i := Lbx_FichiersLier.Items.Count -1 downto 0 do
  begin
    if Lbx_FichiersLier.Selected[i] then
    begin
      Lbx_FichiersDispo.AddItem(Lbx_FichiersLier.Items[i], Lbx_FichiersLier.Items.Objects[i]);
      Lbx_FichiersLier.Items.Delete(i);
    end;
  end;
end;

procedure TFrmListeFichier.Nbt_PostClick(Sender: TObject);
var
  i : integer;
begin
  // ajout des nouvelle assignation
  for i := 0 to Lbx_FichiersLier.Items.Count -1 do
  begin
    if Lbx_FichiersLier.Items.Objects[i] = nil then
    begin
      try
        FMain_DM.Ibc_Maj_GoSport.IB_Transaction.StartTransaction();
        FMain_DM.Ibc_Maj_GoSport.SQL.Text := 'insert into horfic (hof_horid, hof_ficid) select :idhor, fic_id from fichier where fic_libelle = :libfic;';
        FMain_DM.Ibc_Maj_GoSport.ParamCheck := True;
//        FMain_DM.Ibc_Maj_GoSport.ParamByName('idhor').AsInteger := FMain_DM.que_Horaire.FieldByName('hor_id').AsInteger;
        FMain_DM.Ibc_Maj_GoSport.ParamByName('idhor').AsInteger := HoraireId ;
        FMain_DM.Ibc_Maj_GoSport.ParamByName('libfic').AsString := Lbx_FichiersLier.Items[i];
        FMain_DM.Ibc_Maj_GoSport.ExecSQL();
        FMain_DM.Ibc_Maj_GoSport.IB_Transaction.Commit();
      except
        FMain_DM.Ibc_Maj_GoSport.IB_Transaction.Rollback();
        ShowMessage('Erreur durant l''insertion');
        Exit;
      end;
    end;
  end;

  // suppression des anciennes assignation
  for i := 0 to Lbx_FichiersDispo.Items.Count -1 do
  begin
    if not (Lbx_FichiersDispo.Items.Objects[i] = nil) then
    begin
      try
        FMain_DM.Ibc_Maj_GoSport.IB_Transaction.StartTransaction();
        FMain_DM.Ibc_Maj_GoSport.SQL.Text := 'delete from horfic where hof_id = :idhof;';
        FMain_DM.Ibc_Maj_GoSport.ParamCheck := True;
        FMain_DM.Ibc_Maj_GoSport.ParamByName('idhof').AsInteger := Integer(Pointer(Lbx_FichiersDispo.Items.Objects[i]));
        FMain_DM.Ibc_Maj_GoSport.ExecSQL;
        FMain_DM.Ibc_Maj_GoSport.IB_Transaction.Commit();
      except
        FMain_DM.Ibc_Maj_GoSport.IB_Transaction.Rollback();
        ShowMessage('Erreur durant l''insertion');
        Exit;
      end;
    end;
  end;

  ModalResult := mrOK;
end;

end.
