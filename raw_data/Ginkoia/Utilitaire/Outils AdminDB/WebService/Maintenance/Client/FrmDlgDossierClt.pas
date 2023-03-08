unit FrmDlgDossierClt;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FrmCustomGinkoiaDlg, StdCtrls, Buttons, ExtCtrls, Mask, DBCtrls,
  DB, FrameDossierClt, dmdClient;

type
  TDlgDossierCltFrm = class(TCustomGinkoiaDlgFrm)
    DossierCltFramDlg: TDossierCltFram;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
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

uses dmdClients;

{$R *.dfm}

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
  UseUpdateKind:= True;
end;

procedure TDlgDossierCltFrm.FormShow(Sender: TObject);
begin
  inherited;
  if FdmClient <> nil then
    DossierCltFramDlg.DsDossier.DataSet:= FdmClient.CDSDossier;
end;

function TDlgDossierCltFrm.PostValues: Boolean;
begin
  Result:= inherited PostValues;
  try
    if DossierCltFramDlg.DsDossier.DataSet.FindField('SRV_NOM') <> nil then
      DossierCltFramDlg.DsDossier.DataSet.FieldByName('SRV_NOM').AsString:= dmClients.CDS_SRV.FieldByName('SRV_NOM').AsString;
    if DossierCltFramDlg.DsDossier.DataSet.FindField('GRP_NOM') <> nil then
      DossierCltFramDlg.DsDossier.DataSet.FieldByName('GRP_NOM').AsString:= dmClients.CDS_GRP.FieldByName('GRP_NOM').AsString;

    dmClients.PostRecordToXml('Dossier', 'TDossier', FdmClient.CDSDossier);
    DossierCltFramDlg.DsDossier.DataSet.Post;
    Result:= True;
  except
    Raise;
  end;
end;

end.
