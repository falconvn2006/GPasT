unit FrmDetailParamHoraire;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FrmCustomGinkoiaDlg, StdCtrls, Buttons, ExtCtrls, DB, DBCtrls, Mask,
  dmdClients, FrameHeureMinute;

type
  TDetailParamHoraireFrm = class(TCustomGinkoiaDlgFrm)
    Lab_1: TLabel;
    Lab_2: TLabel;
    Lab_3: TLabel;
    Lab_4: TLabel;
    DsParamHoraire: TDataSource;
    EDT_NOM: TEdit;
    EDT_MAX: TEdit;
    CHK_DEFAUT: TCheckBox;
    FrameDebutPlage: THeureMinuteFrame;
    FrameFinPlage: THeureMinuteFrame;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CHK_DEFAUTClick(Sender: TObject);
    procedure EDT_MAXKeyPress(Sender: TObject; var Key: Char);
  private
    FServeur: TGenerique;
    FPRH_ID: integer;
  protected
    function PostValues: Boolean; override;
  public
    property AServeur: TGenerique read FServeur write FServeur;
  end;

var
  DetailParamHoraireFrm: TDetailParamHoraireFrm;

implementation

uses uTool;

{$R *.dfm}

{ TDetailParamHoraireFrm }

procedure TDetailParamHoraireFrm.CHK_DEFAUTClick(Sender: TObject);
begin
  inherited;
  if CHK_DEFAUT.Checked then
    begin
      EDT_NOM.Text:= CHK_DEFAUT.Caption;
      FrameDebutPlage.Reset:= True;
      FrameFinPlage.Reset:= True;
    end
  else
    EDT_NOM.Text:= '';
  FrameDebutPlage.AEnabled:= not CHK_DEFAUT.Checked;
  FrameFinPlage.AEnabled:= not CHK_DEFAUT.Checked;
end;

procedure TDetailParamHoraireFrm.EDT_MAXKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  NumberEditKeyPress(Key);
end;

procedure TDetailParamHoraireFrm.FormCreate(Sender: TObject);
begin
  inherited;
  UseUpdateKind:= True;
  FrameDebutPlage.Initialize(10);
  FrameFinPlage.Initialize(10);
end;

procedure TDetailParamHoraireFrm.FormShow(Sender: TObject);
begin
  inherited;
  if AAction = ukModify then
    begin
      FPRH_ID:= DsParamHoraire.DataSet.FieldByName('PRH_ID').AsInteger;
      EDT_NOM.Text:= DsParamHoraire.DataSet.FieldByName('PRH_NOMPLAGE').AsString;
      EDT_MAX.Text:= DsParamHoraire.DataSet.FieldByName('PRH_NBREPLIC').AsString;
      CHK_DEFAUT.Checked:= Boolean(DsParamHoraire.DataSet.FieldByName('PRH_DEFAUT').AsInteger);
      if (not DsParamHoraire.DataSet.FieldByName('PRH_HDEB').IsNull) and (FrameDebutPlage.AEnabled) then
        FrameDebutPlage.ATime:= DsParamHoraire.DataSet.FieldByName('PRH_HDEB').AsDateTime;
      if (not DsParamHoraire.DataSet.FieldByName('PRH_HFIN').IsNull) and (FrameFinPlage.AEnabled) then
        FrameFinPlage.ATime:= DsParamHoraire.DataSet.FieldByName('PRH_HFIN').AsDateTime;
    end
  else
    begin
      FrameDebutPlage.ATime:= EncodeTime(0, 0, 0, 0); //--> A la demande de Stan
      FrameFinPlage.ATime:= EncodeTime(0, 0, 0, 0); //--> A la demande de Stan
    end;
end;

function TDetailParamHoraireFrm.PostValues: Boolean;
var
  vPRM_ID: integer;
  vDTDeb, vDTFin, vDTDebDB, vDTFinDB: TTime;
begin
  Result:= inherited PostValues;
  try
    vPRM_ID:= dmClients.CDS_PARAMHORAIRES.FieldByName('PRH_ID').AsInteger;

    if (AAction = ukInsert) and (dmClients.CDS_PARAMHORAIRES.Locate('PRH_DEFAUT', 1, [])) and
       (CHK_DEFAUT.Checked) then
      Raise Exception.Create('Une plage horaire par défaut existe déjà.');

    vDTDeb:= FrameDebutPlage.ATime;
    vDTFin:= FrameFinPlage.ATime;

    dmClients.CDS_PARAMHORAIRES.First;
    while not dmClients.CDS_PARAMHORAIRES.Eof do
      begin
        if dmClients.CDS_PARAMHORAIRES.FieldByName('PRH_DEFAUT').AsInteger = 0 then
          begin
            vDTDebDB:= dmClients.CDS_PARAMHORAIRES.FieldByName('PRH_HDEB').AsDateTime;
            vDTFinDB:= dmClients.CDS_PARAMHORAIRES.FieldByName('PRH_HFIN').AsDateTime;
            if (((vDTDeb >= vDTDebDB) and (vDTDeb <= vDTFinDB)) or
               ((vDTFin >= vDTDebDB) and (vDTFin <= vDTFinDB))) and
               (vPRM_ID <> dmClients.CDS_PARAMHORAIRES.FieldByName('PRH_ID').AsInteger) then
              Raise Exception.Create('Votre plage horaire en chevauche une autre.');
          end;
        dmClients.CDS_PARAMHORAIRES.Next;
      end;

    case AAction of
      ukModify:
        begin
          dmClients.CDS_PARAMHORAIRES.Locate('PRH_ID', FPRH_ID, []);
          dmClients.CDS_PARAMHORAIRES.Edit;
        end;
      ukInsert: dmClients.CDS_PARAMHORAIRES.Insert;
    end;

    dmClients.CDS_PARAMHORAIRES.FieldByName('PRH_SRVID').AsInteger:= FServeur.ID;
    dmClients.CDS_PARAMHORAIRES.FieldByName('PRH_NOMPLAGE').AsString:= EDT_NOM.Text;
    dmClients.CDS_PARAMHORAIRES.FieldByName('PRH_NBREPLIC').AsInteger:= StrToInt(EDT_MAX.Text);
    dmClients.CDS_PARAMHORAIRES.FieldByName('PRH_DEFAUT').AsInteger:= Integer(CHK_DEFAUT.Checked);
    dmClients.CDS_PARAMHORAIRES.FieldByName('PRH_HDEB').AsDateTime:= vDTDeb;
    dmClients.CDS_PARAMHORAIRES.FieldByName('PRH_HFIN').AsDateTime:= vDTFin;

    dmClients.PostRecordToXml('Horaire', 'THoraire', dmClients.CDS_PARAMHORAIRES);
    dmClients.CDS_PARAMHORAIRES.Post;
    Result:= True;
  except
    if dmClients.CDS_PARAMHORAIRES.State <> dsBrowse then
      dmClients.CDS_PARAMHORAIRES.Cancel;
    Raise;
  end;
end;

end.
