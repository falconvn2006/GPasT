unit FrameDossierClt;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, DB, StdCtrls, DBCtrls, Mask, Buttons, ExtCtrls;

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
    DBLKP_GROU: TDBLookupComboBox;
    DBCB_PLATEFORME: TDBComboBox;
    DsDossier: TDataSource;
    DsSrv: TDataSource;
    DsGrp: TDataSource;
    DBEdtGROU_NOM: TDBEdit;
    pnlBaseVierge: TPanel;
    SbtBtnSelectBase: TSpeedButton;
    EdtSelectBase: TEdit;
    Lab_6: TLabel;
    DBChkBx_ACTIF: TDBCheckBox;
    DBChkBx_EASY: TDBCheckBox;
    procedure SB_GENERERCHEMINClick(Sender: TObject);
    procedure SbtBtnSelectBaseClick(Sender: TObject);
  private
    FAction: TUpdateKind;
    FIsExcludeLame: Boolean;
    procedure SetFAction(const Value: TUpdateKind);
  public
    property AAction: TUpdateKind read FAction write SetFAction;
    property IsExcludeLame: Boolean read FIsExcludeLame write FIsExcludeLame;
  end;

implementation

uses dmdClients, FrmListFolder;

{$R *.dfm}

procedure TDossierCltFram.SbtBtnSelectBaseClick(Sender: TObject);
var
  vListFolderFrm: TListFolderFrm;
begin
  if not EdtSelectBase.Focused then
    EdtSelectBase.SetFocus;

  vListFolderFrm:= TListFolderFrm.Create(nil);
  try
    vListFolderFrm.AITEMPATHBROWSER:= 'PATHLOCALTECH';
    vListFolderFrm.IsExcludeLame:= FIsExcludeLame;
    if vListFolderFrm.ShowModal = mrOk then
      begin
        EdtSelectBase.Text:= vListFolderFrm.FileNameSelected;
      end;

  finally
    FreeAndNil(vListFolderFrm);
  end;
end;

procedure TDossierCltFram.SB_GENERERCHEMINClick(Sender: TObject);
var
  Buffer: String;
Const
  cCheminBaseGinkoia = '%s:%s\%s\%s\DATA\GINKOIA.IB';
begin
  if not DBEDT_CHEMIN.Focused then
    DBEDT_CHEMIN.SetFocus;

  if (DBEDT_DATABASE.Text <> '') and (DBLKP_SRV.Text <> '') and
     (DBLKP_GROU.KeyValue <> 0) then
    begin
      if DsDossier.DataSet.State = dsBrowse then
        DsDossier.DataSet.Edit;

      Buffer:= Format(cCheminBaseGinkoia, [DBLKP_SRV.Text, DsSrv.DataSet.FieldByName('SERV_DOSBDD').AsString,
                                           DsGrp.DataSet.FieldByName('GROU_NOM').AsString, DBEDT_DATABASE.Text]);

      DsDossier.DataSet.FieldByName('DOSS_CHEMIN').AsString:= Buffer;
    end;
end;

procedure TDossierCltFram.SetFAction(const Value: TUpdateKind);
begin
  FAction := Value;

  if AAction = ukInsert then
    begin
//      DBEdtGROU_NOM.Left:= DBLKP_GROU.Left;
//      DBEdtGROU_NOM.Top:= DBLKP_GROU.Top;
//      DBEdtGROU_NOM.Visible:= True;
      pnlBaseVierge.Visible:= True;
//      DBLKP_GROU.Visible:= False;
    end;
end;

end.
