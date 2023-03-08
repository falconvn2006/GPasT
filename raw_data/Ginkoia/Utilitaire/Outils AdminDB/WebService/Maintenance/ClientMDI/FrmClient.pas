unit FrmClient;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FrmCustomGinkoiaForm, dxSkinsCore, dxSkinBlack, dxSkinBlue,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinFoggy,
  dxSkinGlassOceans, dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky,
  dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black,
  dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink,
  dxSkinOffice2007Silver, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven, dxSkinSharp, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinsDefaultPainters,
  dxSkinValentine, dxSkinXmas2008Blue, dxSkinscxPCPainter, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, ActnList, cxPC, Menus,
  ComCtrls, ToolWin, StdCtrls, DBCtrls, Buttons, DB, Mask, dmdClient, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxDBData, cxGridLevel,
  cxClasses, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, ExtCtrls, FrameDossierClt, cxPropertiesStore,
  FrameToolBar, cxDropDownEdit, cxCheckBox, cxGridCustomPopupMenu,
  cxGridPopupMenu;

type
  TClientFrm = class(TCustomGinkoiaFormFrm)
    PgCtrlClient: TcxPageControl;
    TbShtSites: TcxTabSheet;
    TbshtDossier: TcxTabSheet;
    DsSrv: TDataSource;
    DsGrp: TDataSource;
    cxGridSites: TcxGrid;
    cxGridTWSites: TcxGridDBTableView;
    cxGridLevel2: TcxGridLevel;
    DsSite: TDataSource;
    cxGridTWSitesEMET_ID: TcxGridDBColumn;
    cxGridTWSitesEMET_GUID: TcxGridDBColumn;
    cxGridTWSitesEMET_NOM: TcxGridDBColumn;
    cxGridTWSitesEMET_DONNEES: TcxGridDBColumn;
    cxGridTWSitesEMET_DOSSID: TcxGridDBColumn;
    cxGridTWSitesEMET_INSTALL: TcxGridDBColumn;
    cxGridTWSitesEMET_MAGID: TcxGridDBColumn;
    cxGridTWSitesEMET_VERSID: TcxGridDBColumn;
    cxGridTWSitesEMET_PATCH: TcxGridDBColumn;
    cxGridTWSitesEMET_VERSION_MAX: TcxGridDBColumn;
    cxGridTWSitesEMET_SPE_PATCH: TcxGridDBColumn;
    cxGridTWSitesEMET_SPE_FAIT: TcxGridDBColumn;
    cxGridTWSitesEMET_BCKOK: TcxGridDBColumn;
    cxGridTWSitesEMET_DERNBCK: TcxGridDBColumn;
    cxGridTWSitesEMET_RESBCK: TcxGridDBColumn;
    cxGridTWSitesEMET_TIERSCEGID: TcxGridDBColumn;
    cxGridTWSitesEMET_TYPEREPLICATION: TcxGridDBColumn;
    cxGridTWSitesEMET_NONREPLICATION: TcxGridDBColumn;
    cxGridTWSitesEMET_DEBUTNONREPLICATION: TcxGridDBColumn;
    cxGridTWSitesEMET_FINNONREPLICATION: TcxGridDBColumn;
    cxGridTWSitesEMET_SERVEURSECOURS: TcxGridDBColumn;
    cxGridTWSitesEMET_IDENT: TcxGridDBColumn;
    cxGridTWSitesEMET_JETON: TcxGridDBColumn;
    cxGridTWSitesEMET_PLAGE: TcxGridDBColumn;
    cxGridTWSitesEMET_H1: TcxGridDBColumn;
    cxGridTWSitesEMET_HEURE1: TcxGridDBColumn;
    cxGridTWSitesEMET_H2: TcxGridDBColumn;
    cxGridTWSitesEMET_HEURE2: TcxGridDBColumn;
    cxGridTWSitesBAS_SENDER: TcxGridDBColumn;
    cxGridTWSitesBAS_CENTRALE: TcxGridDBColumn;
    cxGridTWSitesBAS_NOMPOURNOUS: TcxGridDBColumn;
    PpMnInsertSteMagPst: TPopupMenu;
    itSteInsert: TMenuItem;
    itInsertMag: TMenuItem;
    itInsertPoste: TMenuItem;
    DsSteMagPoste: TDataSource;
    pnlDos: TPanel;
    DossierCltFram: TDossierCltFram;
    pnlTimeValues: TPanel;
    ToolBarClient: TToolBarFrame;
    pnlSplittage: TPanel;
    SpdBtnRecupBase: TSpeedButton;
    SpdBtnSplittage: TSpeedButton;
    cxGridTWSitesVERS_VERSION: TcxGridDBColumn;
    cxGridTWSitesLAU_AUTORUN: TcxGridDBColumn;
    cxGridTWSitesLAU_BACK: TcxGridDBColumn;
    cxGridTWSitesLAU_BACKTIME: TcxGridDBColumn;
    cxGridTWSitesPRM_POS: TcxGridDBColumn;
    cxGridTWSitesRTR_PRMID_NBESSAI: TcxGridDBColumn;
    cxGridTWSitesRTR_NBESSAI: TcxGridDBColumn;
    cxGridTWSitesRTR_PRMID_DELAI: TcxGridDBColumn;
    cxGridTWSitesRTR_DELAI: TcxGridDBColumn;
    cxGridTWSitesRTR_PRMID_HEUREDEB: TcxGridDBColumn;
    cxGridTWSitesRTR_HEUREDEB: TcxGridDBColumn;
    cxGridTWSitesRTR_PRMID_HEUREFIN: TcxGridDBColumn;
    cxGridTWSitesRTR_HEUREFIN: TcxGridDBColumn;
    cxGridTWSitesRTR_PRMID_URL: TcxGridDBColumn;
    cxGridTWSitesRTR_URL: TcxGridDBColumn;
    cxGridTWSitesRTR_PRMID_SENDER: TcxGridDBColumn;
    cxGridTWSitesRTR_SENDER: TcxGridDBColumn;
    cxGridTWSitesRTR_PRMID_DATABASE: TcxGridDBColumn;
    cxGridTWSitesRTR_DATABASE: TcxGridDBColumn;
    cxGridTWSitesRW_PRMID_HEUREDEB: TcxGridDBColumn;
    cxGridTWSitesRW_HEUREDEB: TcxGridDBColumn;
    cxGridTWSitesRW_PRMID_HEUREFIN: TcxGridDBColumn;
    cxGridTWSitesRW_HEUREFIN: TcxGridDBColumn;
    cxGridTWSitesRW_PRMID_INTERORDRE: TcxGridDBColumn;
    cxGridTWSitesRW_INTERVALLE: TcxGridDBColumn;
    cxGridTWSitesRW_ORDRE: TcxGridDBColumn;
    cxGridTWSitesBAS_GUID: TcxGridDBColumn;
    cxGridTWSitesLAU_ID: TcxGridDBColumn;
    cxStyleRepository: TcxStyleRepository;
    cxStyleGUIDMISMATCH: TcxStyle;
    TbShtSteMagPoste: TcxTabSheet;
    Ds_CltSOC: TDataSource;
    Ds_CltMAG: TDataSource;
    Ds_CltPOS: TDataSource;
    cxTabSheet1: TcxTabSheet;
    ToolBarFrameListSOCMAGPOS: TToolBarFrame;
    cxGridListSOCMAGPOS: TcxGrid;
    cxGridDBTableViewListSOCMAGPOS: TcxGridDBTableView;
    cxGridLevel1: TcxGridLevel;
    cxGridDBTableViewListSOCMAGPOSDOSS_ID: TcxGridDBColumn;
    cxGridDBTableViewListSOCMAGPOSSOC_ID: TcxGridDBColumn;
    cxGridDBTableViewListSOCMAGPOSSOC_NOM: TcxGridDBColumn;
    cxGridDBTableViewListSOCMAGPOSSOC_CLOTURE: TcxGridDBColumn;
    cxGridDBTableViewListSOCMAGPOSSOC_SSID: TcxGridDBColumn;
    cxGridDBTableViewListSOCMAGPOSMAGA_ID: TcxGridDBColumn;
    cxGridDBTableViewListSOCMAGPOSMAGA_NOM: TcxGridDBColumn;
    cxGridDBTableViewListSOCMAGPOSMAG_SOCID: TcxGridDBColumn;
    cxGridDBTableViewListSOCMAGPOSMAG_IDENT: TcxGridDBColumn;
    cxGridDBTableViewListSOCMAGPOSMAGA_ENSEIGNE: TcxGridDBColumn;
    cxGridDBTableViewListSOCMAGPOSMAG_IDENTCOURT: TcxGridDBColumn;
    cxGridDBTableViewListSOCMAGPOSMAGA_MAGID_GINKOIA: TcxGridDBColumn;
    cxGridDBTableViewListSOCMAGPOSMAG_NATURE: TcxGridDBColumn;
    cxGridDBTableViewListSOCMAGPOSMAG_SS: TcxGridDBColumn;
    cxGridDBTableViewListSOCMAGPOSPOST_POSID: TcxGridDBColumn;
    cxGridDBTableViewListSOCMAGPOSPOST_NOM: TcxGridDBColumn;
    cxGridDBTableViewListSOCMAGPOSPOST_MAGID: TcxGridDBColumn;
    ScrlBxSOCMAGPOS: TScrollBox;
    pnlPOS: TPanel;
    ToolBarFramePOS: TToolBarFrame;
    cxGridPOS: TcxGrid;
    cxGridTWPOS: TcxGridDBTableView;
    cxGridTWPOSDOSS_ID: TcxGridDBColumn;
    cxGridTWPOSPOST_POSID: TcxGridDBColumn;
    cxGridTWPOSPOST_NOM: TcxGridDBColumn;
    cxGridTWPOSPOST_MAGID: TcxGridDBColumn;
    cxGridLevel5: TcxGridLevel;
    pnlSOC: TPanel;
    ToolBarFrameSOC: TToolBarFrame;
    cxGridSOC: TcxGrid;
    cxGridTWSOC: TcxGridDBTableView;
    cxGridTWSOCDOSS_ID: TcxGridDBColumn;
    cxGridTWSOCSOC_ID: TcxGridDBColumn;
    cxGridTWSOCSOC_NOM: TcxGridDBColumn;
    cxGridTWSOCSOC_CLOTURE: TcxGridDBColumn;
    cxGridTWSOCSOC_SSID: TcxGridDBColumn;
    cxGridLevel3: TcxGridLevel;
    SplitterSOC: TSplitter;
    PnlMAG: TPanel;
    ToolBarFrameMAG: TToolBarFrame;
    cxGridMAG: TcxGrid;
    cxGridTWMAG: TcxGridDBTableView;
    cxGridTWMAGDOSS_ID: TcxGridDBColumn;
    cxGridTWMAGMAGA_ID: TcxGridDBColumn;
    cxGridTWMAGMAGA_NOM: TcxGridDBColumn;
    cxGridTWMAGMAG_SOCID: TcxGridDBColumn;
    cxGridTWMAGMAG_IDENT: TcxGridDBColumn;
    cxGridTWMAGMAGA_ENSEIGNE: TcxGridDBColumn;
    cxGridTWMAGMAG_IDENTCOURT: TcxGridDBColumn;
    cxGridTWMAGMAGA_MAGID_GINKOIA: TcxGridDBColumn;
    cxGridTWMAGMAG_NATURE: TcxGridDBColumn;
    cxGridTWMAGMAG_SS: TcxGridDBColumn;
    cxGridTWMAGMAGA_CODEADH: TcxGridDBColumn;
    cxGridLevel4: TcxGridLevel;
    SplitterMAG: TSplitter;
    cxGridDBTableViewListSOCMAGPOSMAGA_CODEADH: TcxGridDBColumn;
    cxGridPopupMenu1: TcxGridPopupMenu;

    procedure FormCreate(Sender: TObject);
    procedure cxGridTWSitesCellDblClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure PgCtrlClientChange(Sender: TObject);
    procedure cxGridDBTWSteMagPosteDblClick(Sender: TObject);
    procedure ToolBarFrame1ActInsertExecute(Sender: TObject);
    procedure ToolBarFrame1ActUpdateExecute(Sender: TObject);
    procedure ToolBarFrame1ActRefreshExecute(Sender: TObject);
    procedure ToolBarFrame1ActExcelExecute(Sender: TObject);
    procedure itSteInsertClick(Sender: TObject);
    procedure itInsertMagClick(Sender: TObject);
    procedure itInsertPosteClick(Sender: TObject);
    procedure cxGridTWSitesDataControllerGroupingChanged(Sender: TObject);
    procedure SpdBtnRecupBaseClick(Sender: TObject);
    procedure SpdBtnSplittageClick(Sender: TObject);
    procedure cxGridTWSitesStylesGetContentStyle(Sender: TcxCustomGridTableView;
      ARecord: TcxCustomGridRecord; AItem: TcxCustomGridTableItem;
      out AStyle: TcxStyle);
    procedure ToolBarFrameSOCActInsertExecute(Sender: TObject);
    procedure ToolBarFrameSOCActUpdateExecute(Sender: TObject);
    procedure ToolBarFrameMAGActInsertExecute(Sender: TObject);
    procedure ToolBarFrameMAGActUpdateExecute(Sender: TObject);
    procedure ToolBarFramePOSActInsertExecute(Sender: TObject);
    procedure ToolBarFramePOSActUpdateExecute(Sender: TObject);
    procedure ToolBarFrameMAGActInsert2Execute(Sender: TObject);
    procedure Ds_CltSOCDataChange(Sender: TObject; Field: TField);
    procedure Ds_CltMAGDataChange(Sender: TObject; Field: TField);
    procedure ToolBarFramePOSActInsert2Execute(Sender: TObject);
    procedure ToolBarFrameListSOCMAGPOSActExcelExecute(Sender: TObject);
    procedure DossierCltFramSB_GENERERCHEMINClick(Sender: TObject);
    procedure ToolBarClientToolButton1Click(Sender: TObject);
    procedure ToolBarFramePOSTlBrBtnUpdateClick(Sender: TObject);
    procedure ToolBarClientTlBrBtnTakeJetonClick(Sender: TObject);
    procedure ToolBarClientTlBrBtnLeaveJetonClick(Sender: TObject);
    procedure DossierCltFramSbtBtnSelectBaseClick(Sender: TObject);
  private
    FdmClient: TdmClient;
    FCurrentGrid: TcxGrid;
    FDOSS_ID: integer;
    FShowModule: Boolean;

    procedure RecupBase(Const ATYPESPLIT: String);

    procedure LoadDossier;
    procedure LoadEmetteur;
    procedure LoadSocMagPoste;

    procedure ShowDetailDossier(const AAction: TUpdateKind);
    procedure ShowDetailSite(const AAction: TUpdateKind);
    procedure ShowDetailSte(const AAction: TUpdateKind);
    procedure ShowDetailMag(AAction: TUpdateKind; Const IsSaisieParLot: Boolean = False);
    procedure ShowDetailPoste(AAction: TUpdateKind; Const IsSaisieParLot: Boolean = False);
  public
    procedure Initialize;

    procedure ShowDetailModule(Const AMAGA_ID: integer);
    procedure ShowDetailEmetteur(Const AEMET_ID: integer);

    property DOSS_ID: integer read FDOSS_ID write FDOSS_ID;
    property AdmClient: TdmClient read FdmClient;
  end;

var
  ClientFrm: TClientFrm;

implementation

uses dmdClients, FrmDlgSiteClt, uTool, FrmDlgSteClt, FrmDlgMagClt,
  FrmDlgPosteClt, FrmDlgDossierClt, FrmClients, uConst, u_Parser;

{$R *.dfm}

procedure TClientFrm.cxGridDBTWSteMagPosteDblClick(Sender: TObject);
begin
  inherited;
  ToolBarClient.ActUpdate.Execute;
end;

procedure TClientFrm.cxGridTWSitesCellDblClick(Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
  AShift: TShiftState; var AHandled: Boolean);
begin
  inherited;
  ShowDetailSite(ukModify);
end;

procedure TClientFrm.cxGridTWSitesDataControllerGroupingChanged(
  Sender: TObject);
begin
  inherited;
  cxGridTWSites.DataController.Groups.FullExpand;
  cxGridTWSites.DataController.FocusedRowIndex:= 0;
end;

procedure TClientFrm.cxGridTWSitesStylesGetContentStyle(
  Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
  AItem: TcxCustomGridTableItem; out AStyle: TcxStyle);
var
  vIdxEMET, vIdxBAS: integer;
begin
  inherited;
  if (DsSite.DataSet = nil) or (DsSite.DataSet.RecordCount = 0) or
     (DsSite.DataSet.State <> dsBrowse) then
    Exit;

  vIdxEMET:= cxGridTWSites.GetColumnByFieldName('EMET_GUID').Index;
  vIdxBAS:= cxGridTWSites.GetColumnByFieldName('BAS_GUID').Index;

  if ((VarIsNull(ARecord.Values[vIdxEMET])) or (VarIsNull(ARecord.Values[vIdxBAS]))) or
     ((ARecord.Values[vIdxEMET] <> ARecord.Values[vIdxBAS])) then
    AStyle:= cxStyleGUIDMISMATCH;
end;

procedure TClientFrm.DossierCltFramSbtBtnSelectBaseClick(Sender: TObject);
begin
  inherited;
  DossierCltFram.SbtBtnSelectBaseClick(Sender);

end;

procedure TClientFrm.DossierCltFramSB_GENERERCHEMINClick(Sender: TObject);
begin
  inherited;
  DossierCltFram.SB_GENERERCHEMINClick(Sender);

end;

procedure TClientFrm.Ds_CltMAGDataChange(Sender: TObject; Field: TField);
begin
  inherited;
  ToolBarFramePOS.ActInsert.Enabled:= Ds_CltMAG.DataSet.RecordCount <> 0;
//                                      not ((Ds_CltMAG.DataSet.RecordCount = 1) and
//                                           (Ds_CltMAG.DataSet.FieldByName('MAG_NOM').AsString = ''));
  ToolBarFramePOS.ActInsert2.Enabled:= Ds_CltMAG.DataSet.RecordCount <> 0;
  ToolBarFramePOS.ActUpdate.Enabled:= (Ds_CltMAG.DataSet.RecordCount <> 0) and
                                      (Ds_CltPOS.DataSet.Active) and
                                      (Ds_CltPOS.DataSet.RecordCount <> 0);
end;

procedure TClientFrm.Ds_CltSOCDataChange(Sender: TObject; Field: TField);
begin
  inherited;
  ToolBarFrameMAG.ActInsert.Enabled:= Ds_CltSOC.DataSet.RecordCount <> 0;
//                                      not ((Ds_CltSOC.DataSet.RecordCount = 1) and
//                                           (Ds_CltSOC.DataSet.FieldByName('SOC_NOM').AsString = ''));
  ToolBarFrameMAG.ActInsert2.Enabled:= Ds_CltSOC.DataSet.RecordCount <> 0;
  ToolBarFrameMAG.ActUpdate.Enabled:= (Ds_CltSOC.DataSet.RecordCount <> 0) and
                                      (Ds_CltMAG.DataSet.Active) and
                                      (Ds_CltMAG.DataSet.RecordCount <> 0);
end;

procedure TClientFrm.ShowDetailDossier(const AAction: TUpdateKind);
var
  vDlgDossierCltFrm: TDlgDossierCltFrm;
begin
  vDlgDossierCltFrm:= TDlgDossierCltFrm.Create(nil);
  try
    vDlgDossierCltFrm.AdmClient:= FdmClient;
    vDlgDossierCltFrm.Caption:= 'Dossier (' + Caption + ')';
    vDlgDossierCltFrm.AAction:= AAction;

    if AAction = ukInsert then
      vDlgDossierCltFrm.DossierCltFramDlg.DsDossier.DataSet.Insert;

    if vDlgDossierCltFrm.ShowModal = mrOk then
      begin
        if (vDlgDossierCltFrm.Modified) and
           (dmClients.CDS_DOS.Locate('DOSS_ID', FdmClient.CDSDossier.FieldByName('DOSS_ID').AsInteger, [])) then
          begin
            dmClients.CDS_DOS.Edit;
            BatchRecord(FdmClient.CDSDossier, dmClients.CDS_DOS, False);
            dmClients.CDS_DOS.FieldByName('SERV_NOM').AsString:= dmClients.CDS_SRV.FieldByName('SERV_NOM').AsString;
            dmClients.CDS_DOS.FieldByName('GROU_NOM').AsString:= dmClients.CDS_GRP.FieldByName('GROU_NOM').AsString;
            dmClients.CDS_DOS.Post;
            LoadEmetteur;
            LoadSocMagPoste;
          end;
      end
    else
      if vDlgDossierCltFrm.DossierCltFramDlg.DsDossier.DataSet.State <> dsBrowse then
        vDlgDossierCltFrm.DossierCltFramDlg.DsDossier.DataSet.Cancel;
  finally
    FreeAndNil(vDlgDossierCltFrm);
  end;
end;

procedure TClientFrm.ShowDetailEmetteur(const AEMET_ID: integer);
begin
  LoadEmetteur;
  if DsSite.DataSet.Locate('EMET_ID', AEMET_ID, []) then
    begin
      PgCtrlClient.ActivePageIndex:= 1;
      ToolBarClient.ActUpdate.Execute;
    end;
end;

procedure TClientFrm.FormCreate(Sender: TObject);
begin
  inherited;
  FShowModule:= False;
  FDOSS_ID:= -1;
  FdmClient:= TdmClient.Create(Self);
  DossierCltFram.DsDossier.DataSet:= FdmClient.CDSDossier;
  DsSite.DataSet:= FdmClient.CDS_EMETTEUR;
  DsSteMagPoste.DataSet:= FdmClient.CDS_SOCMAGPOS;
  Ds_CltSOC.DataSet:= FdmClient.CDS_SOC;
  Ds_CltMAG.DataSet:= FdmClient.CDS_MAG;
  Ds_CltPOS.DataSet:= FdmClient.CDS_POS;
  TcxComboBoxProperties(cxGridTWMAGMAG_NATURE.Properties).Items.Text:= FdmClient.GetListMAG_NATURE;
  TcxComboBoxProperties(cxGridDBTableViewListSOCMAGPOSMAG_NATURE.Properties).Items.Text:= FdmClient.GetListMAG_NATURE;
end;

procedure TClientFrm.Initialize;
begin
  try
    FdmClient.DOSS_ID:= FDOSS_ID;
    dmClients.InitializeIHM(Self);
    PgCtrlClient.ActivePageIndex:= 0;
    PgCtrlClientChange(nil);
    ToolBarClient.ActRefresh.Execute;
    If (FdmClient.CDSDossierDOSS_EASY.Value=0) then
      begin
        ToolBarClient.TlBrBtnTakeJeton.Enabled := not FdmClient.CDSDossierBJETON.Value;
        ToolBarClient.TlBrBtnLeaveJeton.Enabled := FdmClient.CDSDossierBJETON.Value;
      end
    else
      begin
          ToolBarClient.TlBrBtnTakeJeton.Enabled  := false;
          ToolBarClient.TlBrBtnLeaveJeton.Enabled := false;
          // Pas de recupBase et de Splittage pour le Moment avec EASY
          SpdBtnRecupBase.Enabled   := False;
          SpdBtnSplittage.Enabled   := False;
      end;
  except
    Raise;
  end;
end;

procedure TClientFrm.itInsertMagClick(Sender: TObject);
begin
  inherited;
  ShowDetailMag(ukInsert);
end;

procedure TClientFrm.itInsertPosteClick(Sender: TObject);
begin
  inherited;
  ShowDetailPoste(ukInsert);
end;

procedure TClientFrm.itSteInsertClick(Sender: TObject);
begin
  inherited;
  ShowDetailSte(ukInsert);
end;

procedure TClientFrm.LoadDossier;
begin
  if FDOSS_ID <> -1 then
    begin
      try
        { Chargement du dossier }
        dmClients.XmlToDataSet('Dossier?DOSS_ID=' + IntToStr(FDOSS_ID), FdmClient.CDSDossier);
      except
        Raise;
      end;
    end;
end;

procedure TClientFrm.LoadEmetteur;
begin
  if FDOSS_ID <> -1 then
    begin
      try
        { Chargement des emetteurs pour un dossier }
        dmClients.XmlToDataSet('Emetteur?DOSS_ID=' + IntToStr(FDOSS_ID), FdmClient.CDS_EMETTEUR);
        FdmClient.CDS_SRVSECOURS.EmptyDataSet;
        BatchMove(FdmClient.CDS_EMETTEUR, FdmClient.CDS_SRVSECOURS);
        cxGridTWSites.DataController.Groups.FullExpand;
        cxGridTWSites.DataController.FocusedRowIndex:= 0;
      except
        Raise;
      end;
    end;
end;

procedure TClientFrm.LoadSocMagPoste;
var
 vSOCID, vMAGAID: integer;
begin
  if FDOSS_ID <> -1 then
    begin
      FdmClient.CDS_SOCMAGPOS.DisableControls;
      FdmClient.CDS_SOC.DisableControls;
      FdmClient.CDS_MAG.DisableControls;
      FdmClient.CDS_POS.DisableControls;
      try
        FdmClient.CDS_SOC.EmptyDataSet;
        FdmClient.CDS_MAG.EmptyDataSet;
        FdmClient.CDS_POS.EmptyDataSet;
        try
          { Chargement des Sociétés - Magasins - Postes }
          dmClients.XmlToDataSet('SteMagPoste?DOSS_ID=' + IntToStr(FDOSS_ID), FdmClient.CDS_SOCMAGPOS);

          FdmClient.CDS_SOCMAGPOS.First;
          while not FdmClient.CDS_SOCMAGPOS.Eof do
            begin
              vSOCID:= FdmClient.CDS_SOCMAGPOS.FieldByName('SOC_ID').AsInteger;

              FdmClient.CDS_SOC.Append;
              FdmClient.CDS_SOC.FieldByName('DOSS_ID').AsInteger:= FdmClient.CDS_SOCMAGPOS.FieldByName('DOSS_ID').AsInteger;
              FdmClient.CDS_SOC.FieldByName('SOC_ID').AsInteger:= vSOCID;
              FdmClient.CDS_SOC.FieldByName('SOC_NOM').AsString:= FdmClient.CDS_SOCMAGPOS.FieldByName('SOC_NOM').AsString;
              FdmClient.CDS_SOC.FieldByName('SOC_CLOTURE').AsDateTime:= FdmClient.CDS_SOCMAGPOS.FieldByName('SOC_CLOTURE').AsDateTime;
              FdmClient.CDS_SOC.FieldByName('SOC_SSID').AsInteger:= FdmClient.CDS_SOCMAGPOS.FieldByName('SOC_SSID').AsInteger;
              FdmClient.CDS_SOC.Post;

              if FdmClient.CDS_SOCMAGPOS.FieldByName('MAGA_ID').AsInteger <> -1 then
                begin
                  while (not FdmClient.CDS_SOCMAGPOS.Eof) and
                       (vSOCID = FdmClient.CDS_SOCMAGPOS.FieldByName('SOC_ID').AsInteger) do
                    begin
                      vMAGAID:= FdmClient.CDS_SOCMAGPOS.FieldByName('MAGA_ID').AsInteger;

                      FdmClient.CDS_MAG.Append;
                      FdmClient.CDS_MAG.FieldByName('DOSS_ID').AsInteger:= FdmClient.CDS_SOCMAGPOS.FieldByName('DOSS_ID').AsInteger;
                      FdmClient.CDS_MAG.FieldByName('MAGA_ID').AsInteger:= vMAGAID;
                      FdmClient.CDS_MAG.FieldByName('MAGA_NOM').AsString:= FdmClient.CDS_SOCMAGPOS.FieldByName('MAGA_NOM').AsString;
                      FdmClient.CDS_MAG.FieldByName('MAG_SOCID').AsInteger:= vSOCID;
                      FdmClient.CDS_MAG.FieldByName('MAG_IDENT').AsString:= FdmClient.CDS_SOCMAGPOS.FieldByName('MAG_IDENT').AsString;
                      FdmClient.CDS_MAG.FieldByName('MAGA_ENSEIGNE').AsString:= FdmClient.CDS_SOCMAGPOS.FieldByName('MAGA_ENSEIGNE').AsString;
                      FdmClient.CDS_MAG.FieldByName('MAG_IDENTCOURT').AsString:= FdmClient.CDS_SOCMAGPOS.FieldByName('MAG_IDENTCOURT').AsString;
                      FdmClient.CDS_MAG.FieldByName('MAGA_MAGID_GINKOIA').AsInteger:= FdmClient.CDS_SOCMAGPOS.FieldByName('MAGA_MAGID_GINKOIA').AsInteger;
                      FdmClient.CDS_MAG.FieldByName('MAG_NATURE').AsInteger:= FdmClient.CDS_SOCMAGPOS.FieldByName('MAG_NATURE').AsInteger;
                      FdmClient.CDS_MAG.FieldByName('MAG_SS').AsInteger:= FdmClient.CDS_SOCMAGPOS.FieldByName('MAG_SS').AsInteger;
                      FdmClient.CDS_MAG.FieldByName('MPU_GCPID').AsInteger:= FdmClient.CDS_SOCMAGPOS.FieldByName('MPU_GCPID').AsInteger;
                      FdmClient.CDS_MAG.FieldByName('MAGA_CODEADH').AsString:= FdmClient.CDS_SOCMAGPOS.FieldByName('MAGA_CODEADH').AsString;
                      FdmClient.CDS_MAG.FieldByName('MAGA_BASID').AsInteger:= FdmClient.CDS_SOCMAGPOS.FieldByName('MAGA_BASID').AsInteger;
                      FdmClient.CDS_MAG.Post;

                      if FdmClient.CDS_SOCMAGPOS.FieldByName('POST_POSID').AsInteger <> -1 then
                        begin
                          while (not FdmClient.CDS_SOCMAGPOS.Eof) and
                                (vMAGAID = FdmClient.CDS_SOCMAGPOS.FieldByName('MAGA_ID').AsInteger) do
                            begin
                              FdmClient.CDS_POS.Append;
                              FdmClient.CDS_POS.FieldByName('DOSS_ID').AsInteger:= FdmClient.CDS_SOCMAGPOS.FieldByName('DOSS_ID').AsInteger;
                              FdmClient.CDS_POS.FieldByName('POST_POSID').AsInteger:= FdmClient.CDS_SOCMAGPOS.FieldByName('POST_POSID').AsInteger;
                              FdmClient.CDS_POS.FieldByName('POST_NOM').AsString:= FdmClient.CDS_SOCMAGPOS.FieldByName('POST_NOM').AsString;
                              FdmClient.CDS_POS.FieldByName('MAGA_ID').AsInteger:= vMAGAID;
                              FdmClient.CDS_POS.FieldByName('POST_MAGID').AsInteger:= FdmClient.CDS_SOCMAGPOS.FieldByName('MAGA_MAGID_GINKOIA').AsInteger;
                              FdmClient.CDS_POS.Post;

                              FdmClient.CDS_SOCMAGPOS.Next;
                            end;
                        end
                      else
                        FdmClient.CDS_SOCMAGPOS.Next;
                    end;
                end
              else
                FdmClient.CDS_SOCMAGPOS.Next;

            end;
        except
          Raise;
        end;
      finally
        FdmClient.CDS_SOCMAGPOS.EnableControls;
        FdmClient.CDS_POS.EnableControls;
        FdmClient.CDS_MAG.EnableControls;
        FdmClient.CDS_SOC.EnableControls;
        FdmClient.CDS_SOC.First;
        FdmClient.CDS_MAG.First;
        FdmClient.CDS_SOCMAGPOS.First;
      end;
    end;
end;

procedure TClientFrm.SpdBtnRecupBaseClick(Sender: TObject);
begin
  inherited;
  RecupBase('RECUP');
end;

procedure TClientFrm.SpdBtnSplittageClick(Sender: TObject);
begin
  inherited;
  RecupBase('SPLIT');
end;

procedure TClientFrm.PgCtrlClientChange(Sender: TObject);
begin
  inherited;
  ToolBarClient.ActInsert.Visible:= PgCtrlClient.ActivePageIndex = 1;
  ToolBarClient.ActExcel.Visible:= PgCtrlClient.ActivePageIndex = 1;
  ToolBarClient.ActUpdate.Visible:= PgCtrlClient.ActivePageIndex in [0,1];
  pnlSplittage.Visible:= PgCtrlClient.ActivePageIndex = 1;
  FCurrentGrid:= TcxGrid(PgCtrlClient.ActivePage.Tag);
  pnlSplittage.Enabled:= PgCtrlClient.ActivePage.Name = 'TbShtSites';
end;

procedure TClientFrm.RecupBase(const ATYPESPLIT: String);
var
  vSL: TStringList;
  vClear,
  vBase,
  vMail   : String;
begin
  inherited;
  vSL:= TStringList.Create;
  try
    case MessageDlg('Voulez-vous nettoyer après le traitement ?', mtConfirmation, [mbYes, mbNo, mbCancel], 0) of
      mrYes     : vClear:= '1';
      mrNo      : vClear:= '0';
      mrCancel  : Exit;
    end;

    case MessageDlg('Souhaitez-vous garder la base de données ?', mtCustom, [mbYes, mbNo], 0) of
      mrYes : vBase:= '1';
      mrNo  : vBase:= '0';
    end;

    case MessageDlg('Voulez-vous envoyer un mail après le traitement ?', mtCustom, [mbYes, mbNo], 0) of
      mrYes : vMail:= '1';
      mrNo  : vMail:= '0';
    end;

    dmClients.XmlToList('RecupBase?USERNAME=' + GetUserNameWindows +
                        '&TYPESPLIT=' + ATYPESPLIT +
                        '&EMET_ID=' + FdmClient.CDS_EMETTEUR.FieldByName('EMET_ID').AsString +
                        '&BASE=' + vBase +
                        '&MAIL=' + vMail +
                        '&CLEARFILES=' + vClear, cBlsResult, '', vSL, Self, False);

    if vSL.Count <> 0 then
      MessageDlg(vSL.Text, mtInformation, [mbOk], 0);
  finally
    FreeAndNil(vSL);
  end;
end;

procedure TClientFrm.ShowDetailSte(const AAction: TUpdateKind);
var
  vDlgSteCltFrm: TDlgSteCltFrm;
  vSL: TStringList;
begin
  vSL:= TStringList.Create;
  vDlgSteCltFrm:= TDlgSteCltFrm.Create(nil);
  try
    vDlgSteCltFrm.Caption:= 'Société (' + Caption + ')';
    vDlgSteCltFrm.AdmClient:= FdmClient;
    vDlgSteCltFrm.DOSS_ID:= FDOSS_ID;

    { Permet de passer en update car lors d'un nouveau
      dossier, il existe une ligne vide }
    if (Ds_CltSOC.DataSet.RecordCount = 1) and (AAction = ukInsert) and
       (Ds_CltSOC.DataSet.FieldByName('SOC_NOM').AsString = '') then
      vDlgSteCltFrm.AAction:= ukModify
    else
      vDlgSteCltFrm.AAction:= AAction;

    if vDlgSteCltFrm.ShowModal = mrOk then
      begin
        if AAction = ukInsert then
          LoadSocMagPoste;
      end
    else
      if vDlgSteCltFrm.DsSociete.DataSet.State <> dsBrowse then
        vDlgSteCltFrm.DsSociete.DataSet.Cancel;
  finally
    FreeAndNil(vDlgSteCltFrm);
    FreeAndNil(vSL);
  end;
end;

procedure TClientFrm.ToolBarClientTlBrBtnLeaveJetonClick(Sender: TObject);
var
  vSL: TStringList;
begin
  inherited;
  vSL:= TStringList.Create;
  try
    //
    if FDOSS_ID <> -1 then
    begin
      try
        dmClients.XmlToList('JetonLame?DOSS_ID=' + IntToStr(FDOSS_ID), cBlsResult, '', vSL, Self, False);
      except
        Raise;
      end;
    end;
    ToolBarFrame1ActRefreshExecute(Sender);
    if vSL.Count <> 0 then
      MessageDlg(vSL.Text, mtInformation, [mbOk], 0);

    If (FdmClient.CDSDossierDOSS_EASY.Value=0) then
      begin
        ToolBarClient.TlBrBtnTakeJeton.Enabled := not FdmClient.CDSDossierBJETON.Value;
        ToolBarClient.TlBrBtnLeaveJeton.Enabled := FdmClient.CDSDossierBJETON.Value;
      end
    else
      begin
          ToolBarClient.TlBrBtnTakeJeton.Enabled  := false;
          ToolBarClient.TlBrBtnLeaveJeton.Enabled := false;

          // Pas de recupBase et de Splittage pour le Moment avec EASY
          SpdBtnRecupBase.Enabled   := False;
          SpdBtnSplittage.Enabled   := False;
      end;

    // ToolBarClient.TlBrBtnTakeJeton.Enabled := not FdmClient.CDSDossierBJETON.Value;
    // ToolBarClient.TlBrBtnLeaveJeton.Enabled := FdmClient.CDSDossierBJETON.Value;

  finally
    FreeAndNil(vSL);
  end;
end;

procedure TClientFrm.ToolBarClientTlBrBtnTakeJetonClick(Sender: TObject);
var
  vSL: TStringList;
begin
  inherited;
  vSL:= TStringList.Create;
  try
    //
    if FDOSS_ID <> -1 then
    begin
      try
        dmClients.XmlToList('JetonLame?DOSS_ID=' + IntToStr(FDOSS_ID), cBlsResult, '', vSL, Self, False);
      except
        Raise;
      end;
    end;
    ToolBarFrame1ActRefreshExecute(Sender);
    if vSL.Count <> 0 then
      MessageDlg(vSL.Text, mtInformation, [mbOk], 0);

    If (FdmClient.CDSDossierDOSS_EASY.Value=0) then
      begin
        ToolBarClient.TlBrBtnTakeJeton.Enabled := not FdmClient.CDSDossierBJETON.Value;
        ToolBarClient.TlBrBtnLeaveJeton.Enabled := FdmClient.CDSDossierBJETON.Value;
      end
    else
      begin
          ToolBarClient.TlBrBtnTakeJeton.Enabled  := false;
          ToolBarClient.TlBrBtnLeaveJeton.Enabled := false;
          SpdBtnRecupBase.Enabled   := False;
          //SpdBtnSplittage.Enabled   := False;

      end;


    // ToolBarClient.TlBrBtnTakeJeton.Enabled := not FdmClient.CDSDossierBJETON.Value;
    // ToolBarClient.TlBrBtnLeaveJeton.Enabled := FdmClient.CDSDossierBJETON.Value;

  finally
    FreeAndNil(vSL);
  end;
end;

procedure TClientFrm.ToolBarClientToolButton1Click(Sender: TObject);
var
  vSL: TStringList;
begin
  inherited;
  vSL:= TStringList.Create;
  try
    //Pour resynchroniser une base
    if FDOSS_ID <> -1 then
    begin
      try
        dmClients.XmlToList('SyncBase?DOSS_ID=' + IntToStr(FDOSS_ID), cBlsResult, '', vSL, Self, False);
      except
        Raise;
      end;
    end;
    ToolBarFrame1ActRefreshExecute(Sender);
    if vSL.Count <> 0 then
      MessageDlg(vSL.Text, mtInformation, [mbOk], 0);
  finally
    FreeAndNil(vSL);
  end;
end;

procedure TClientFrm.ToolBarFrame1ActExcelExecute(Sender: TObject);
begin
  inherited;
  if FCurrentGrid <> nil then
    SaveGridToXLS(FCurrentGrid, True);
end;

procedure TClientFrm.ToolBarFrame1ActInsertExecute(Sender: TObject);
begin
  inherited;
  case PgCtrlClient.ActivePageIndex of
    0: ShowDetailDossier(ukInsert);
    1: ShowDetailSite(ukInsert);
    2: PpMnInsertSteMagPst.Popup(ToolBarClient.TlBrBtnNew.ClientOrigin.X, ToolBarClient.TlBrBtnNew.ClientOrigin.Y + ToolBarClient.TlBrBtnNew.Height);
  end;
end;

procedure TClientFrm.ToolBarFrame1ActRefreshExecute(Sender: TObject);
begin
  inherited;
  LoadDossier;
  LoadEmetteur;
  LoadSocMagPoste;
  if FDOSS_ID <> -1 then
    pnlTimeValues.Caption:= dmClients.GetTimeValues;
end;

procedure TClientFrm.ToolBarFrame1ActUpdateExecute(Sender: TObject);
begin
  inherited;
  case PgCtrlClient.ActivePageIndex of
    0: ShowDetailDossier(ukModify);
    1: ShowDetailSite(ukModify);
  end;
end;

procedure TClientFrm.ToolBarFrameListSOCMAGPOSActExcelExecute(Sender: TObject);
begin
  inherited;
  if DsSteMagPoste.DataSet.RecordCount <> 0 then
    SaveGridToXLS(cxGridListSOCMAGPOS, True);
end;

procedure TClientFrm.ToolBarFrameMAGActInsert2Execute(Sender: TObject);
begin
  inherited;
  ShowDetailMag(ukInsert, True);
end;

procedure TClientFrm.ToolBarFrameMAGActInsertExecute(Sender: TObject);
begin
  inherited;
  ShowDetailMag(ukInsert, False);
end;

procedure TClientFrm.ToolBarFrameMAGActUpdateExecute(Sender: TObject);
begin
  inherited;
  if ToolBarFrameMAG.ActUpdate.Enabled then
    ShowDetailMag(ukModify);
end;

procedure TClientFrm.ToolBarFramePOSActInsert2Execute(Sender: TObject);
begin
  inherited;
  ShowDetailPoste(ukInsert, True);
end;

procedure TClientFrm.ToolBarFramePOSActInsertExecute(Sender: TObject);
begin
  inherited;
  ShowDetailPoste(ukInsert);
end;

procedure TClientFrm.ToolBarFramePOSActUpdateExecute(Sender: TObject);
begin
  inherited;
  if ToolBarFramePOS.ActUpdate.Enabled then
    ShowDetailPoste(ukModify);
end;

procedure TClientFrm.ToolBarFramePOSTlBrBtnUpdateClick(Sender: TObject);
begin
  inherited;
  ShowDetailPoste(ukModify);
end;

procedure TClientFrm.ToolBarFrameSOCActInsertExecute(Sender: TObject);
begin
  inherited;
  ShowDetailSte(ukInsert);
end;

procedure TClientFrm.ToolBarFrameSOCActUpdateExecute(Sender: TObject);
begin
  inherited;
  ShowDetailSte(ukModify);
end;

procedure TClientFrm.ShowDetailMag(AAction: TUpdateKind;
  Const IsSaisieParLot: Boolean);
var
  vDlgMagCltFrm: TDlgMagCltFrm;
  vSL: TStringList;
  vSOC_ID: integer;
begin
  vSL:= TStringList.Create;
  vDlgMagCltFrm:= TDlgMagCltFrm.Create(nil);
  try
    FdmClient.CDSModuleActif.EmptyDataSet;
    vDlgMagCltFrm.AdmClient:= FdmClient;
    vDlgMagCltFrm.Caption:= 'Magasin (' + Caption + ')';
    vDlgMagCltFrm.IsSaisieParLot:= IsSaisieParLot;

    { Permet de passer en update car lors d'un nouveau
      dossier, il existe une ligne vide }
    if (Ds_CltMAG.DataSet.RecordCount = 1) and (AAction = ukInsert) and
       (Ds_CltMAG.DataSet.FieldByName('MAGA_NOM').AsString = '') and
       (not IsSaisieParLot) then
      vDlgMagCltFrm.AAction:= ukModify
    else
      vDlgMagCltFrm.AAction:= AAction;

    if FShowModule then
      vDlgMagCltFrm.PgCtrlMag.Pages[0].TabVisible:= False;

    vSOC_ID:= Ds_CltSOC.DataSet.FieldByName('SOC_ID').AsInteger;
    if vDlgMagCltFrm.ShowModal = mrOk then
      begin
        if (AAction = ukInsert) or (IsSaisieParLot) then
          LoadSocMagPoste;

        Ds_CltSOC.DataSet.Locate('SOC_ID', vSOC_ID, []);
      end
    else
      if vDlgMagCltFrm.DsMagasin.DataSet.State <> dsBrowse then
        vDlgMagCltFrm.DsMagasin.DataSet.Cancel;
  finally
    FreeAndNil(vDlgMagCltFrm);
    FreeAndNil(vSL);
    FShowModule:= False;
  end;
end;

procedure TClientFrm.ShowDetailModule(const AMAGA_ID: integer);
begin
  if DsSteMagPoste.DataSet.Locate('MAGA_ID', AMAGA_ID, []) then
    begin
      PgCtrlClient.ActivePageIndex:= 2;
      FShowModule:= True;
      ToolBarClient.ActUpdate.Execute;
    end;
end;

procedure TClientFrm.ShowDetailPoste(AAction: TUpdateKind;
  Const IsSaisieParLot: Boolean);
var
  vDlgPosteCltFrm: TDlgPosteCltFrm;
  vSL: TStringList;
  vSOC_ID, vMAGA_ID: integer;
begin
  vSL:= TStringList.Create;
  vDlgPosteCltFrm:= TDlgPosteCltFrm.Create(nil);
  try
    vDlgPosteCltFrm.Caption:= 'Poste (' + Caption + ')';
    vDlgPosteCltFrm.AdmClient:= FdmClient;
    vDlgPosteCltFrm.IsSaisieParLot:= IsSaisieParLot;

    { Permet de passer en update car lors d'un nouveau
      dossier, il existe une ligne vide }
    if (Ds_CltPOS.DataSet.RecordCount = 1) and (AAction = ukInsert) and
       (Ds_CltPOS.DataSet.FieldByName('POST_NOM').AsString = '') and
       (not IsSaisieParLot) then
      vDlgPosteCltFrm.AAction:= ukModify
    else
      vDlgPosteCltFrm.AAction:= AAction;

    vSOC_ID:= Ds_CltMAG.DataSet.FieldByName('MAG_SOCID').AsInteger;
    vMAGA_ID:= Ds_CltMAG.DataSet.FieldByName('MAGA_ID').AsInteger;
    if vDlgPosteCltFrm.ShowModal = mrOk then
      begin
        if (AAction = ukInsert) or (IsSaisieParLot) then
          LoadSocMagPoste;

        Ds_CltSOC.DataSet.Locate('SOC_ID', vSOC_ID, []);
        Ds_CltMAG.DataSet.Locate('MAGA_ID', vMAGA_ID, []);
      end
    else
      if vDlgPosteCltFrm.DsPoste.DataSet.State <> dsBrowse then
        vDlgPosteCltFrm.DsPoste.DataSet.Cancel;
  finally
    FreeAndNil(vDlgPosteCltFrm);
    FreeAndNil(vSL);
  end;
end;

procedure TClientFrm.ShowDetailSite(const AAction: TUpdateKind);
var
  vDlgSiteCltFrm: TDlgSiteCltFrm;
  vEMET_ID: integer;
begin
  if (FdmClient <> nil) and (FdmClient.CDS_EMETTEUR.RecordCount = 0) and
     (AAction = ukModify) then
    Exit;

  vDlgSiteCltFrm:= TDlgSiteCltFrm.Create(nil);
  try
    vDlgSiteCltFrm.Caption:= 'Site (' + Caption + ')';
    vDlgSiteCltFrm.AAction:= AAction;
    vDlgSiteCltFrm.AdmClient:= FdmClient;
    vEMET_ID:= FdmClient.CDS_EMETTEUR.FieldByName('EMET_ID').AsInteger;
    vDlgSiteCltFrm.CheckBaseZero;

    if vDlgSiteCltFrm.ShowModal = mrOk then
      begin
        ToolBarClient.ActRefresh.Execute;
        if vEMET_ID <> 0 then
          FdmClient.CDS_EMETTEUR.Locate('EMET_ID', vEMET_ID, []);
      end
    else
      if vDlgSiteCltFrm.DsEmetteur.DataSet.State <> dsBrowse then
        vDlgSiteCltFrm.DsEmetteur.DataSet.Cancel;
  finally
    FreeAndNil(vDlgSiteCltFrm);
  end;
end;

end.

