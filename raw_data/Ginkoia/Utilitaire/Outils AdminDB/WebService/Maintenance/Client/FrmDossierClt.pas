unit FrmDossierClt;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FrmCustomGinkoiaForm, dmdClient, DB, StdCtrls, DBCtrls, Buttons, Mask;

type
  TDossierCltFrm = class(TCustomGinkoiaFormFrm)
    Label4: TLabel;
    DBEDT_DATABASE: TDBEdit;
    DsDossier: TDataSource;
    Label1: TLabel;
    DBLKP_SRV: TDBLookupComboBox;
    Label3: TLabel;
    SB_CHEMIN: TSpeedButton;
    SB_GENERERCHEMIN: TSpeedButton;
    DBEDT_CHEMIN: TDBEdit;
    DBCK_VIP: TDBCheckBox;
    Label2: TLabel;
    DBLKP_GRP: TDBLookupComboBox;
    Label5: TLabel;
    DBCB_PLATEFORME: TDBComboBox;
    DsSrv: TDataSource;
    DsGrp: TDataSource;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FdmClient: TdmClient;
    FDOS_ID: integer;
    procedure Initialize;
  public
    property DOS_ID: integer read FDOS_ID write FDOS_ID;
  end;

var
  DossierCltFrm: TDossierCltFrm;

implementation

uses dmdClients;

{$R *.dfm}

{ TDossierCltFrm }

procedure TDossierCltFrm.FormCreate(Sender: TObject);
begin
  inherited;
  FDOS_ID:= -1;
end;

procedure TDossierCltFrm.FormShow(Sender: TObject);
begin
  inherited;
  Initialize;
end;

procedure TDossierCltFrm.Initialize;
begin
  FdmClient:= TdmClient.Create(Self);
  DsDossier.DataSet:= FdmClient.CDSDossier;
  if FDOS_ID <> -1 then
    dmClients.XmlToDataSet('GetDossier?DOS_ID=' + IntToStr(FDOS_ID), FdmClient.CDSDossier, False);
end;

end.
