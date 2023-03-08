unit FrameDossierClt;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, DB, StdCtrls, DBCtrls, Mask, Buttons;

type
  TDossierCltFram = class(TFrame)
    Lab_1: TLabel;
    Lab_2: TLabel;
    Lab_3: TLabel;
    SB_GENERERCHEMIN: TSpeedButton;
    Lab_4: TLabel;
    Lab_5: TLabel;
    DBEDT_DATABASE: TDBEdit;
    DBLKP_SRV: TDBLookupComboBox;
    DBEDT_CHEMIN: TDBEdit;
    DBCK_VIP: TDBCheckBox;
    DBLKP_GRP: TDBLookupComboBox;
    DBCB_PLATEFORME: TDBComboBox;
    DsDossier: TDataSource;
    DsSrv: TDataSource;
    DsGrp: TDataSource;
    procedure SB_GENERERCHEMINClick(Sender: TObject);
  private
  public
  end;

implementation

uses dmdClients;

{$R *.dfm}

procedure TDossierCltFram.SB_GENERERCHEMINClick(Sender: TObject);
begin
  if (DBEDT_DATABASE.Text <> '') and (DBLKP_SRV.Text <> '') and (DBLKP_GRP.Text <> '') then
    begin
      if DsDossier.DataSet.State = dsBrowse then
        DsDossier.DataSet.Edit;
      DsDossier.DataSet.FieldByName('DOS_CHEMIN').AsString:= DBLKP_SRV.Text + ':D:\EAI\' + DBLKP_GRP.Text + '\' + DBEDT_DATABASE.Text + '\DATA\GINKOIA.IB';
    end;
end;

end.
