unit FrmDlgDossierClt;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FrmCustomGinkoiaDlg, StdCtrls, Buttons, ExtCtrls, Mask, DBCtrls,
  DB, DBClient, FrameDossierClt, dmdClient;

type
  TDlgDossierCltFrm = class(TCustomGinkoiaDlgFrm)
    DossierCltFramDlg: TDossierCltFram;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure DossierCltFramDlgDBLKP_SRVCloseUp(Sender: TObject);
    procedure DossierCltFramDlgDBEDT_DATABASEChange(Sender: TObject);
    procedure DossierCltFramDlgDBEDT_DATABASEKeyPress(Sender: TObject;
      var Key: Char);
  private
    FdmClient: TdmClient;
  protected
    function PostValues: Boolean; override;
  public
    property AdmClient: TdmClient read FdmClient write FdmClient;
  end;

var
  DlgDossierCltFrm: TDlgDossierCltFrm;

implementation

uses dmdClients, uConst;

{$R *.dfm}

procedure TDlgDossierCltFrm.DossierCltFramDlgDBEDT_DATABASEChange(
  Sender: TObject);
begin
  inherited;
  if DossierCltFramDlg.DBEDT_CHEMIN.DataSource.DataSet.State <> dsBrowse then
    DossierCltFramDlg.DBEDT_CHEMIN.Field.AsString:= '';
end;

procedure TDlgDossierCltFrm.DossierCltFramDlgDBEDT_DATABASEKeyPress(
  Sender: TObject; var Key: Char);
var
  vSysCharSet: TSysCharSet;
begin
  inherited;
  vSysCharSet:= [' '];
  if (Key in vSysCharSet) then
    Key:= #0;
end;

procedure TDlgDossierCltFrm.DossierCltFramDlgDBLKP_SRVCloseUp(Sender: TObject);
begin
  inherited;
  if DossierCltFramDlg.DBEDT_CHEMIN.DataSource.DataSet.State = dsEdit then
    DossierCltFramDlg.DBEDT_CHEMIN.Field.AsString:= '';
end;

procedure TDlgDossierCltFrm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  FModified:= DossierCltFramDlg.DsDossier.DataSet.State <> dsBrowse;
  inherited;
  //-->
end;

procedure TDlgDossierCltFrm.FormCreate(Sender: TObject);
begin
  inherited;
  FdmClient:= nil;
  UseUpdateKind:= True;
end;

procedure TDlgDossierCltFrm.FormShow(Sender: TObject);
begin
  inherited;
  if FdmClient <> nil then
    DossierCltFramDlg.DsDossier.DataSet:= FdmClient.CDSDossier;
  DossierCltFramDlg.AAction:= AAction;
  DossierCltFramDlg.IsExcludeLame:= True;
end;

function TDlgDossierCltFrm.PostValues: Boolean;
begin
  Result:= inherited PostValues;
  try
    if DossierCltFramDlg.DsDossier.DataSet.FindField('SERV_NOM') <> nil then
      DossierCltFramDlg.DsDossier.DataSet.FieldByName('SERV_NOM').AsString:= dmClients.CDS_SRV.FieldByName('SERV_NOM').AsString;
    if (DossierCltFramDlg.DsDossier.DataSet.FindField('GROU_NOM') <> nil) and
       (DossierCltFramDlg.DsDossier.DataSet.FieldByName('DOSS_GROUID').AsInteger <> 0) then
      DossierCltFramDlg.DsDossier.DataSet.FieldByName('GROU_NOM').AsString:= dmClients.CDS_GRP.FieldByName('GROU_NOM').AsString;

    if Trim(DossierCltFramDlg.DBEDT_CHEMIN.Text) = '' then
      Raise Exception.Create('Chemin de la base Ginkoia est obligatoire.');

    if AAction = ukInsert then
      begin
        if (Trim(DossierCltFramDlg.EdtSelectBase.Text) <> '') or (DossierCltFramDlg.DBChkBx_EASY.Checked) then
          begin
            if MessageDlg('Confirmez-vous la création d''une nouvelle base de données' + cRC + cRC +
                          'de ' + DossierCltFramDlg.EdtSelectBase.Text + cRC +
                          'vers ' + DossierCltFramDlg.DBEDT_CHEMIN.Text, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
              DossierCltFramDlg.DsDossier.DataSet.FieldByName('CHEMIN_BV').AsString:= DossierCltFramDlg.EdtSelectBase.Text
            else
              begin
                Result:= False;
                Exit;
              end;
          end
        else
          Raise Exception.Create('Le choix de la base vierge est obligatoire en création.');
      end;

    dmClients.PostRecordToXml('Dossier?CHANGEDOS=1', 'TDossier', TClientDataSet(DossierCltFramDlg.DsDossier.DataSet));

    DossierCltFramDlg.DsDossier.DataSet.Post;
    Result:= True;
  except
    Raise;
  end;
end;

end.
