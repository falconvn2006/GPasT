unit FrmDlgMagClt;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FrmCustomGinkoiaDlg, Grids, DBGrids, StdCtrls, Mask, DBCtrls,
  Buttons, ExtCtrls, DB, dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinFoggy, dxSkinGlassOceans,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSharp, dxSkinSilver, dxSkinSpringTime,
  dxSkinStardust, dxSkinSummer2008, dxSkinsDefaultPainters, dxSkinValentine,
  dxSkinXmas2008Blue, dxSkinscxPCPainter, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, dmdClient, FrameToolBar;

type
  TDlgMagCltFrm = class(TCustomGinkoiaDlgFrm)
    DsMagasin: TDataSource;
    pnlTop: TPanel;
    DBText1: TDBText;
    Lab_5: TLabel;
    PgCtrlMag: TcxPageControl;
    TbShtMag: TcxTabSheet;
    TbShtModuleActif: TcxTabSheet;
    Lab_1: TLabel;
    Lab_2: TLabel;
    Lab_3: TLabel;
    DBEDT_MAGIDENTCOURT: TDBEdit;
    DBEDT_MAGNOM: TDBEdit;
    DBEDT_MAGENSEIGNE: TDBEdit;
    DsModuleActif: TDataSource;
    cxGrid1: TcxGrid;
    cxGridTWModuleActif: TcxGridDBTableView;
    cxGridLevel2: TcxGridLevel;
    cxGridTWModuleActifMOD_ID: TcxGridDBColumn;
    cxGridTWModuleActifMOD_NOM: TcxGridDBColumn;
    cxGridTWModuleActifMODMAG_DATE: TcxGridDBColumn;
    DBRdGrpNature: TDBRadioGroup;
    DBChkBxSiegeSociale: TDBCheckBox;
    TlBrFrameModules: TToolBarFrame;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TbShtModuleActifShow(Sender: TObject);
    procedure cxGridTWModuleActifDblClick(Sender: TObject);
    procedure TlBrFrameModulesActInsertExecute(Sender: TObject);
    procedure TlBrFrameModulesActUpdateExecute(Sender: TObject);
    procedure TlBrFrameModulesActDeleteExecute(Sender: TObject);
  private
    FdmClient: TdmClient;
    procedure ShowDetailModuleActif(const AAction: TUpdateKind);
  protected
    function PostValues: Boolean; override;
  public
    property AdmClient: TdmClient read FdmClient write FdmClient;
  end;

var
  DlgMagCltFrm: TDlgMagCltFrm;

implementation

uses FrmDlgModClt, dmdClients, FrmClients, uConst;

{$R *.dfm}

procedure TDlgMagCltFrm.cxGridTWModuleActifDblClick(Sender: TObject);
begin
  inherited;
  TlBrFrameModules.ActUpdate.Execute;
end;

procedure TDlgMagCltFrm.FormCreate(Sender: TObject);
begin
  inherited;
  UseUpdateKind:= True;
  TlBrFrameModules.ConfirmDelete:= True;
end;

procedure TDlgMagCltFrm.FormShow(Sender: TObject);
begin
  inherited;
  DsMagasin.DataSet:= FdmClient.CDS_SOCMAGPOS;
  DsModuleActif.DataSet:= FdmClient.CDSModuleActif;
  if AAction = ukInsert then
    PgCtrlMag.HideTabs:= True;
  if not PgCtrlMag.Pages[0].TabVisible then
    BtnExit:= True;
end;

function TDlgMagCltFrm.PostValues: Boolean;
var
  vSL: TStringList;
begin
  Result:= inherited PostValues;
  vSL:= TStringList.Create;
  try
    try
      vSL.Append('DOS_ID');
      vSL.Append('MAG_ID');
      vSL.Append('MAG_NOM');
      vSL.Append('MAG_SOCID');
      vSL.Append('MAG_IDENT');
      vSL.Append('MAG_ENSEIGNE');
      vSL.Append('MAG_ID_GINKOIA');
      vSL.Append('MAG_NATURE');
      vSL.Append('MAG_SS');

      if Trim(FdmClient.CDS_SOCMAGPOS.FieldByName('MAG_NOM').AsString) = '' then
        Raise Exception.Create('Le nom du magasin est obligatoire.');

      dmClients.PostRecordToXml('Magasin', 'TMagasin', FdmClient.CDS_SOCMAGPOS, vSL);
      DsMagasin.DataSet.Post;
      dmClients.XmlToDataSet('SteMagPoste?DOS_ID=' + IntToStr(FdmClient.DOS_ID), FdmClient.CDS_SOCMAGPOS);
      Result:= True;
    except
      Raise;
    end;
  finally
    FreeAndNil(vSL);
  end;
end;

procedure TDlgMagCltFrm.ShowDetailModuleActif(const AAction: TUpdateKind);
var
  vDlgModCltFrm: TDlgModCltFrm;
begin
  vDlgModCltFrm:= TDlgModCltFrm.Create(nil);
  try
    vDlgModCltFrm.AAction:= AAction;
    vDlgModCltFrm.AdmClient:= FdmClient;

    if AAction = ukDelete then
      begin
        dmClients.XmlToDataSet('ModuleGinkoia?DOS_ID=' + FdmClient.CDS_SOCMAGPOS.FieldByName('DOS_ID').AsString +
                               '&MAG_ID=' + FdmClient.CDS_SOCMAGPOS.FieldByName('MAG_ID_GINKOIA').AsString +
                               '&ALL=1', FdmClient.CDSModuleDisponible);
        if FdmClient.CDSModuleDisponible.Locate('MOD_ID', FdmClient.CDSModuleActif.FieldByName('MOD_ID').AsInteger, []) then
          begin
            dmClients.DeleteRecordByRessource('ModuleGinkoia?DOS_ID=' + FdmClient.CDSModuleDisponible.FieldByName('DOS_ID').AsString +
                                              '&UGM_MAGID=' + FdmClient.CDSModuleDisponible.FieldByName('UGM_MAGID').AsString +
                                              '&UGG_ID=' +  FdmClient.CDSModuleDisponible.FieldByName('UGG_ID').AsString);
            FdmClient.CDSModuleActif.Delete;
          end;
      end
    else
      begin
        if vDlgModCltFrm.ShowModal = mrOk then
          begin
            //-->
          end
        else
          if FdmClient.CDSModuleActif.State <> dsBrowse then
            FdmClient.CDSModuleActif.Cancel;
      end;
  finally
    FreeAndNil(vDlgModCltFrm);
    GIsBrowse:= False;
  end;
end;

procedure TDlgMagCltFrm.TbShtModuleActifShow(Sender: TObject);
begin
  inherited;
  if (FdmClient.CDSModuleActif.RecordCount = 0) and (AAction <> ukInsert) and
     (FdmClient.CDS_SOCMAGPOS.FieldByName('MAG_ID').AsInteger <> -1) then
    dmClients.XmlToDataSet('Module?MAG_ID=' + FdmClient.CDS_SOCMAGPOS.FieldByName('MAG_ID').AsString +
                           '&DOS_ID=' + FdmClient.CDS_SOCMAGPOS.FieldByName('DOS_ID').AsString, FdmClient.CDSModuleActif);
end;

procedure TDlgMagCltFrm.TlBrFrameModulesActDeleteExecute(Sender: TObject);
begin
  inherited;
  TlBrFrameModules.ActDeleteExecute(Sender);
  ShowDetailModuleActif(ukDelete);
end;

procedure TDlgMagCltFrm.TlBrFrameModulesActInsertExecute(Sender: TObject);
begin
  inherited;
  ShowDetailModuleActif(ukInsert);
end;

procedure TDlgMagCltFrm.TlBrFrameModulesActUpdateExecute(Sender: TObject);
begin
  inherited;
  ShowDetailModuleActif(ukModify);
end;

end.
