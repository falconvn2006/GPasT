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
  FrameToolBar;

type
  TClientFrm = class(TCustomGinkoiaFormFrm)
    PgCtrlClient: TcxPageControl;
    TbShtSites: TcxTabSheet;
    TbShtSteMagPoste: TcxTabSheet;
    TbshtDossier: TcxTabSheet;
    DsSrv: TDataSource;
    DsGrp: TDataSource;
    cxGridSites: TcxGrid;
    cxGridTWSites: TcxGridDBTableView;
    cxGridLevel2: TcxGridLevel;
    cxGridSteMagPoste: TcxGrid;
    cxGridDBTWSteMagPoste: TcxGridDBTableView;
    cxGridLevel1: TcxGridLevel;
    DsSite: TDataSource;
    cxGridTWSitesEMET_ID: TcxGridDBColumn;
    cxGridTWSitesEMET_GUID: TcxGridDBColumn;
    cxGridTWSitesEMET_NOM: TcxGridDBColumn;
    cxGridTWSitesEMET_DONNEES: TcxGridDBColumn;
    cxGridTWSitesDOS_ID: TcxGridDBColumn;
    cxGridTWSitesEMET_INSTALL: TcxGridDBColumn;
    cxGridTWSitesEMET_MAGID: TcxGridDBColumn;
    cxGridTWSitesVER_ID: TcxGridDBColumn;
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
    cxGridDBTWSteMagPosteSOC_ID: TcxGridDBColumn;
    cxGridDBTWSteMagPosteSOC_NOM: TcxGridDBColumn;
    cxGridDBTWSteMagPosteSOC_CLOTURE: TcxGridDBColumn;
    cxGridDBTWSteMagPosteSOC_SSID: TcxGridDBColumn;
    cxGridDBTWSteMagPosteSOC_K: TcxGridDBColumn;
    cxGridDBTWSteMagPosteMAG_ID: TcxGridDBColumn;
    cxGridDBTWSteMagPosteMAG_NOM: TcxGridDBColumn;
    cxGridDBTWSteMagPosteMAG_SOCID: TcxGridDBColumn;
    cxGridDBTWSteMagPosteMAG_MTAID: TcxGridDBColumn;
    cxGridDBTWSteMagPosteMAG_TVTID: TcxGridDBColumn;
    cxGridDBTWSteMagPosteMAG_ADRID: TcxGridDBColumn;
    cxGridDBTWSteMagPosteMAG_IDENT: TcxGridDBColumn;
    cxGridDBTWSteMagPosteMAG_K: TcxGridDBColumn;
    cxGridDBTWSteMagPosteMAG_ENSEIGNE: TcxGridDBColumn;
    cxGridDBTWSteMagPosteMAG_IDENTCOURT: TcxGridDBColumn;
    cxGridDBTWSteMagPostePOS_ID: TcxGridDBColumn;
    cxGridDBTWSteMagPostePOS_NOM: TcxGridDBColumn;
    cxGridDBTWSteMagPostePOS_MAGID: TcxGridDBColumn;
    cxGridDBTWSteMagPostePOS_K: TcxGridDBColumn;
    pnlDos: TPanel;
    DossierCltFram: TDossierCltFram;
    pnlTimeValues: TPanel;
    ToolBarClient: TToolBarFrame;
    pnlSplittage: TPanel;
    SpdBtnRecupBase: TSpeedButton;
    SpdBtnSplittage: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cxGridTWSitesCellDblClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure PgCtrlClientChange(Sender: TObject);
    procedure cxGridDBTWSteMagPosteCanFocusRecord(
      Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
      var AAllow: Boolean);
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
    procedure DossierCltFramSB_GENERERCHEMINClick(Sender: TObject);
  private
    FdmClient: TdmClient;
    FCurrentGrid: TcxGrid;
    FDOS_ID: integer;
    FShowModule: Boolean;
    FLevel: integer;
    FFieldNameSelectedStrMagPoste: String;
    procedure CloneRecBeforeInsert(Const ADataSet: TDataSet; Const AListField: TStringList;
                                   Const AAction: TUpdateKind = ukInsert);
    procedure Initialize;

    procedure RecupBase(Const ATYPESPLIT: String);

    procedure LoadDossier;
    procedure LoadEmetteur;
    procedure LoadSocMagPoste;

    procedure ShowDetailDossier(const AAction: TUpdateKind);
    procedure ShowDetailSite(const AAction: TUpdateKind);
    procedure ShowDetailSte(const AAction: TUpdateKind);
    procedure ShowDetailMag(AAction: TUpdateKind);
    procedure ShowDetailPoste(AAction: TUpdateKind);
    procedure ShowDetailSteMagPoste(const AAction: TUpdateKind);
  public
    procedure ShowDetailModule(Const AMAG_ID: integer);
    procedure ShowDetailEmetteur(Const AEMET_ID: integer);

    property DOS_ID: integer read FDOS_ID write FDOS_ID;
    property AdmClient: TdmClient read FdmClient;
  end;

var
  ClientFrm: TClientFrm;

implementation

uses dmdClients, FrmDlgSiteClt, uTool, FrmDlgSteClt, FrmDlgMagClt,
  FrmDlgPosteClt, FrmDlgDossierClt, FrmClients, uConst, u_Parser;

{$R *.dfm}

procedure TClientFrm.CloneRecBeforeInsert(const ADataSet: TDataSet;
  const AListField: TStringList; Const AAction: TUpdateKind);
var
  i: integer;
  Buffer: String;
  vSL: TStringList;
begin
  vSL:= TStringList.Create;
  try
    for i:= 0 to ADataSet.FieldCount - 1 do
      begin
        if ADataSet.Fields.Fields[i].IsNull then
          vSL.Append('')
        else
          vSL.Append(ADataSet.Fields.Fields[i].Value);
      end;

    case AAction of
      ukModify: ADataSet.Edit;
      ukInsert: ADataSet.Insert;
    end;

    for i:= 0 to ADataSet.FieldCount - 1 do
      begin
        Buffer:= Copy(ADataSet.Fields.Fields[i].FieldName, 1, 3);
        if (AListField.IndexOf(Buffer) <> -1) and (vSL.Strings[i] <> '') then
          ADataSet.Fields.Fields[i].Value:= vSL.Strings[i];
      end;
  finally
    FreeAndNil(vSL);
  end;
end;

procedure TClientFrm.cxGridDBTWSteMagPosteCanFocusRecord(
  Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
  var AAllow: Boolean);
begin
  inherited;
  FLevel:= ARecord.Level;
  FFieldNameSelectedStrMagPoste:= cxGridDBTWSteMagPoste.Columns[FLevel].DataBinding.FieldName;
end;

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

procedure TClientFrm.DossierCltFramSB_GENERERCHEMINClick(Sender: TObject);
begin
  inherited;
  DossierCltFram.SB_GENERERCHEMINClick(Sender);

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
           (dmClients.CDS_DOS.Locate('DOS_ID', FdmClient.CDSDossier.FieldByName('DOS_ID').AsInteger, [])) then
          begin
            dmClients.CDS_DOS.Edit;
            BatchRecord(FdmClient.CDSDossier, dmClients.CDS_DOS, False);
            dmClients.CDS_DOS.FieldByName('SRV_NOM').AsString:= dmClients.CDS_SRV.FieldByName('SRV_NOM').AsString;
            dmClients.CDS_DOS.FieldByName('GRP_NOM').AsString:= dmClients.CDS_GRP.FieldByName('GRP_NOM').AsString;
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
  FDOS_ID:= -1;
  FdmClient:= TdmClient.Create(Self);
  DossierCltFram.DsDossier.DataSet:= FdmClient.CDSDossier;
  DsSite.DataSet:= FdmClient.CDS_EMETTEUR;
  DsSteMagPoste.DataSet:= FdmClient.CDS_SOCMAGPOS;
end;

procedure TClientFrm.FormShow(Sender: TObject);
begin
  inherited;
  FdmClient.DOS_ID:= FDOS_ID;
  Initialize;
  ToolBarClient.ActRefresh.Execute;
end;

procedure TClientFrm.Initialize;
begin
  dmClients.InitializeIHM(Self);
  PgCtrlClient.ActivePageIndex:= 0;
  PgCtrlClientChange(nil);
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
  if FDOS_ID <> -1 then
    begin
      { Chargement du dossier }
      dmClients.XmlToDataSet('Dossier?DOS_ID=' + IntToStr(FDOS_ID), FdmClient.CDSDossier);
    end;
end;

procedure TClientFrm.LoadEmetteur;
begin
  if FDOS_ID <> -1 then
    begin
      { Chargement des emetteurs pour un dossier }
      dmClients.XmlToDataSet('Emetteur?DOS_ID=' + IntToStr(FDOS_ID), FdmClient.CDS_EMETTEUR);
      FdmClient.CDS_SRVSECOURS.EmptyDataSet;
      BatchMove(FdmClient.CDS_EMETTEUR, FdmClient.CDS_SRVSECOURS);
      cxGridTWSites.DataController.Groups.FullExpand;
      cxGridTWSites.DataController.FocusedRowIndex:= 0;
    end;
end;

procedure TClientFrm.LoadSocMagPoste;
begin
  if FDOS_ID <> -1 then
    begin
      { Chargement des Sociétés - Magasins - Postes }
      dmClients.XmlToDataSet('SteMagPoste?DOS_ID=' + IntToStr(FDOS_ID), FdmClient.CDS_SOCMAGPOS);
      cxGridDBTWSteMagPoste.DataController.Groups.FullExpand;
      cxGridDBTWSteMagPoste.DataController.FocusedRowIndex:= 0;
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
  ToolBarClient.ActInsert.Enabled:= PgCtrlClient.ActivePageIndex <> 0;
  FCurrentGrid:= TcxGrid(PgCtrlClient.ActivePage.Tag);
end;

procedure TClientFrm.RecupBase(const ATYPESPLIT: String);
var
  vSL: TStringList;
  vClear: String;
begin
  inherited;
  vSL:= TStringList.Create;
  try
    vClear:= '0';
    if MessageDlg('Voulez-vous néttoyer après le traitement ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      vClear:= '1';

    dmClients.XmlToList('RecupBase?USERNAME=' + GetUserNameWindows +
                        '&TYPESPLIT=' + ATYPESPLIT +
                        '&EMET_ID=' + FdmClient.CDS_EMETTEUR.FieldByName('EMET_ID').AsString +
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
    vDlgSteCltFrm.AAction:= AAction;
    vDlgSteCltFrm.AdmClient:= FdmClient;

    if AAction = ukInsert then
      begin
        vSL.Append('DOS');
        CloneRecBeforeInsert(FdmClient.CDS_SOCMAGPOS, vSL);
      end;

    if vDlgSteCltFrm.ShowModal = mrOk then
      begin
        //-->
      end
    else
      if vDlgSteCltFrm.DsSociete.DataSet.State <> dsBrowse then
        vDlgSteCltFrm.DsSociete.DataSet.Cancel;
  finally
    FreeAndNil(vDlgSteCltFrm);
    FreeAndNil(vSL);
  end;
end;

procedure TClientFrm.ShowDetailSteMagPoste(const AAction: TUpdateKind);
begin
  if FFieldNameSelectedStrMagPoste = 'SOC_NOM' then
    ShowDetailSte(AAction)
  else
    if FFieldNameSelectedStrMagPoste = 'MAG_NOM' then
      ShowDetailMag(AAction)
    else
      ShowDetailPoste(AAction);
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
  if FDOS_ID <> -1 then
    pnlTimeValues.Caption:= dmClients.GetTimeValues;
end;

procedure TClientFrm.ToolBarFrame1ActUpdateExecute(Sender: TObject);
begin
  inherited;
  case PgCtrlClient.ActivePageIndex of
    0: ShowDetailDossier(ukModify);
    1: ShowDetailSite(ukModify);
    2: ShowDetailSteMagPoste(ukModify);
  end;
end;

procedure TClientFrm.ShowDetailMag(AAction: TUpdateKind);
var
  vDlgMagCltFrm: TDlgMagCltFrm;
  vSL: TStringList;
begin
  vSL:= TStringList.Create;
  vDlgMagCltFrm:= TDlgMagCltFrm.Create(nil);
  try
    FdmClient.CDSModuleActif.EmptyDataSet;
    vDlgMagCltFrm.AdmClient:= FdmClient;
    vDlgMagCltFrm.Caption:= 'Magasin (' + Caption + ')';

    if FdmClient.CDS_SOCMAGPOS.FieldByName('MAG_ID').AsInteger < 1 then
      AAction:= ukModify;

    vDlgMagCltFrm.AAction:= AAction;

    vSL.Append('DOS');
    vSL.Append('SOC');
    CloneRecBeforeInsert(FdmClient.CDS_SOCMAGPOS, vSL, AAction);
    FdmClient.CDS_SOCMAGPOS.FieldByName('MAG_SOCID').AsInteger:= FdmClient.CDS_SOCMAGPOS.FieldByName('SOC_ID').AsInteger;

    if FdmClient.CDS_SOCMAGPOS.FieldByName('MAG_ID').AsInteger < 1 then
      begin
        vDlgMagCltFrm.Caption:= 'Magasin (' + Caption + ')';
        vDlgMagCltFrm.AAction:= ukInsert;
      end;

    if FShowModule then
      vDlgMagCltFrm.PgCtrlMag.Pages[0].TabVisible:= False;

    if vDlgMagCltFrm.ShowModal = mrOk then
      begin
        //-->
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

procedure TClientFrm.ShowDetailModule(const AMAG_ID: integer);
begin
  if DsSteMagPoste.DataSet.Locate('MAG_ID', AMAG_ID, []) then
    begin
      PgCtrlClient.ActivePageIndex:= 2;
      FFieldNameSelectedStrMagPoste:= 'MAG_NOM';
      FShowModule:= True;
      ToolBarClient.ActUpdate.Execute;
    end;
end;

procedure TClientFrm.ShowDetailPoste(AAction: TUpdateKind);
var
  vDlgPosteCltFrm: TDlgPosteCltFrm;
  vSL: TStringList;
begin
  if FdmClient.CDS_SOCMAGPOS.FieldByName('MAG_ID').AsInteger < 1 then
    Exit;

  vSL:= TStringList.Create;
  vDlgPosteCltFrm:= TDlgPosteCltFrm.Create(nil);
  try
    vDlgPosteCltFrm.Caption:= 'Poste (' + Caption + ')';
    vDlgPosteCltFrm.AdmClient:= FdmClient;

    if FdmClient.CDS_SOCMAGPOS.FieldByName('POS_ID').AsInteger < 1 then
      AAction:= ukModify;

    vDlgPosteCltFrm.AAction:= AAction;

    vSL.Append('DOS');
    vSL.Append('SOC');
    vSL.Append('MAG');
    CloneRecBeforeInsert(FdmClient.CDS_SOCMAGPOS, vSL, AAction);
    FdmClient.CDS_SOCMAGPOS.FieldByName('POS_MAGID').AsInteger:= FdmClient.CDS_SOCMAGPOS.FieldByName('MAG_ID_GINKOIA').AsInteger;

    if vDlgPosteCltFrm.ShowModal = mrOk then
      begin
        //-->
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
  if (FdmClient <> nil) and (FdmClient.CDS_EMETTEUR.RecordCount = 0) then
    Exit;
  vDlgSiteCltFrm:= TDlgSiteCltFrm.Create(nil);
  try
    vDlgSiteCltFrm.Caption:= 'Site (' + Caption + ')';
    vDlgSiteCltFrm.AAction:= AAction;
    vDlgSiteCltFrm.AdmClient:= FdmClient;
    vEMET_ID:= FdmClient.CDS_EMETTEUR.FieldByName('EMET_ID').AsInteger;

    if vDlgSiteCltFrm.ShowModal = mrOk then
      begin
        ToolBarClient.ActRefresh.Execute;
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
