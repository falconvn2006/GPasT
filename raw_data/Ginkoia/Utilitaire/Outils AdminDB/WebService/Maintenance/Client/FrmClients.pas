unit FrmClients;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FrmCustomGinkoiaForm, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinBlack, dxSkinBlue,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinFoggy,
  dxSkinGlassOceans, dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky,
  dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black,
  dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink,
  dxSkinOffice2007Silver, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven, dxSkinSharp, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinsDefaultPainters,
  dxSkinValentine, dxSkinXmas2008Blue, dxSkinscxPCPainter, cxCustomData,
  cxFilter, cxData, cxDataStorage, cxEdit, DB, cxDBData, cxGridLevel, FrmClient,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxClasses, Contnrs,
  cxGridCustomView, cxGrid, ComCtrls, Buttons, ExtCtrls, cxPC, cxPropertiesStore,
  ActnList, FrameToolBar;

type
  TClientsFrm = class(TCustomGinkoiaFormFrm)
    PgCtrlClients: TcxPageControl;
    TbShtRecherche: TcxTabSheet;
    cxGridDossier: TcxGrid;
    cxGridTWDossier: TcxGridDBTableView;
    cxGridLevel2: TcxGridLevel;
    DSDossier: TDataSource;
    cxGridTWDossierDOS_DATABASE: TcxGridDBColumn;
    cxGridTWDossierDOS_CHEMIN: TcxGridDBColumn;
    cxGridTWDossierSRV_ID: TcxGridDBColumn;
    cxGridTWDossierGRP_ID: TcxGridDBColumn;
    cxGridTWDossierDOS_INSTALL: TcxGridDBColumn;
    cxGridTWDossierDOS_VIP: TcxGridDBColumn;
    cxGridTWDossierDOS_PLATEFORME: TcxGridDBColumn;
    cxGridTWDossierDOS_ID: TcxGridDBColumn;
    cxGridTWDossierSRV_NOM: TcxGridDBColumn;
    cxGridTWDossierGRP_NOM: TcxGridDBColumn;
    cxGridTWDossierVER_VERSION: TcxGridDBColumn;
    ToolBarRecherche: TToolBarFrame;
    pnlTimeDossier: TPanel;
    TmrDossier: TTimer;
    procedure PgCtrlClientsCanClose(Sender: TObject; var ACanClose: Boolean);
    procedure cxGridTWDossierDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ToolBarRechercheActExcelExecute(Sender: TObject);
    procedure ToolBarRechercheActRefreshExecute(Sender: TObject);
    procedure ToolBarRechercheActInsertExecute(Sender: TObject);
    procedure cxGridTWDossierDataControllerGroupingChanged(Sender: TObject);
    procedure cxGridTWDossierDataControllerDataChanged(Sender: TObject);
    procedure TmrDossierTimer(Sender: TObject);
  private
    FListClient: TObjectList;
    function ClientIsOpen(Const ADOS_ID: integer): integer;
    function OpenTabSheetClient: TClientFrm;
    function GetClient(index: integer): TClientFrm;
    function GetClientByDOS_ID(ADOS_ID: integer): TClientFrm;
    function GetCountClient: integer;
    procedure DeleteItemByClient(Const ADOS_ID: integer);
  public
    property CountClient: integer read GetCountClient;
    property Client[index: integer]: TClientFrm read GetClient;
    property ClientByDOS_ID[ADOS_ID: integer]: TClientFrm read GetClientByDOS_ID;
  end;

var
  ClientsFrm: TClientsFrm;

implementation

uses dmdClients, uTool, FrmDlgDossierClt, uConst;

{$R *.dfm}

function TClientsFrm.OpenTabSheetClient: TClientFrm;
var
  idx: integer;
  vTbsht: TcxTabSheet;
begin
  Result:= nil;
  if (DSDossier.DataSet = nil) or (DSDossier.DataSet.RecordCount = 0) then
    begin
      MessageDlg('Aucune donnée.', mtInformation, [mbOk], 0);
      Exit;
    end;

  { On affiche l'onglet si il existe deja }  
  idx:=  ClientIsOpen(DSDossier.DataSet.FieldByName('DOS_ID').AsInteger);
  if idx <> 0 then
    begin
      PgCtrlClients.ActivePageIndex:= idx;
      Result:= ClientByDOS_ID[DSDossier.DataSet.FieldByName('DOS_ID').AsInteger];
      Exit;
    end;

  { Creation du TabSheet }
  vTbsht:= TcxTabSheet.Create(PgCtrlClients);
  vTbsht.Name:= Format('Tbsht%d', [DSDossier.DataSet.FieldByName('DOS_ID').AsInteger]);
  vTbsht.Parent:= PgCtrlClients;
  vTbsht.Caption:= DSDossier.DataSet.FieldByName('DOS_DATABASE').AsString;
  vTbsht.Tag:= DSDossier.DataSet.FieldByName('DOS_ID').AsInteger;

  { Creation de l'interface client }
  Result:= TClientFrm.Create(vTbsht);
  Result.Caption:= vTbsht.Caption;
  Result.Parent:= vTbsht;
  Result.Align:= alClient;
  Result.Visible:= True;
  Result.DOS_ID:= DSDossier.DataSet.FieldByName('DOS_ID').AsInteger;
  FListClient.Add(Result);
  vTbsht.Visible := True;

  PgCtrlClients.ActivePageIndex:= PgCtrlClients.PageCount -1;
end;

function TClientsFrm.ClientIsOpen(Const ADOS_ID: integer): integer;
var
  i: integer;
begin
  Result:= 0;
  for i:= 0 to PgCtrlClients.PageCount - 1 do
    begin
      if PgCtrlClients.Pages[i].Tag = ADOS_ID then
        begin
          Result:= i;
          Break;
        end;
    end;
end;

procedure TClientsFrm.cxGridTWDossierDataControllerDataChanged(Sender: TObject);
begin
  inherited;
  Caption:= cNameGestClient + ' - ' + dmClients.CountRecCxGrid(cxGridDossier);
end;

procedure TClientsFrm.cxGridTWDossierDataControllerGroupingChanged(
  Sender: TObject);
begin
  inherited;
  cxGridTWDossier.DataController.Groups.FullExpand;
  cxGridTWDossier.DataController.FocusedRowIndex:= 0;
  Caption:= cNameGestClient + ' - ' + dmClients.CountRecCxGrid(cxGridDossier);
end;

procedure TClientsFrm.cxGridTWDossierDblClick(Sender: TObject);
begin
  inherited;
  OpenTabSheetClient;
end;

procedure TClientsFrm.DeleteItemByClient(const ADOS_ID: integer);
var
  i: integer;
begin
  for i:= 0 to FListClient.Count - 1 do
    begin
      if Client[i].DOS_ID = ADOS_ID then
        begin
          FListClient.Extract(Client[i]);
          Break;
        end;
    end;
end;

procedure TClientsFrm.FormCreate(Sender: TObject);
begin
  cxPropertiesStore.Active:= True;
  inherited;
  Caption:= cNameGestClient;
  TmrDossier.Interval:= GParams.DelayRefreshValues;
  if not dmClients.Initialized then
    dmClients.LoadLists;
  FListClient:= TObjectList.Create(False);
  cxGridTWDossier.RestoreFromRegistry(cxPropertiesStore.StorageName, FALSE, FALSE, [gsoUseFilter], cxGridTWDossier.Name);
  pnlTimeDossier.Caption:= dmClients.GetTimeValues;
end;

procedure TClientsFrm.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(FListClient);
  cxGridTWDossier.StoreToRegistry(cxPropertiesStore.StorageName, FALSE, [gsoUseFilter], cxGridTWDossier.Name);
end;

function TClientsFrm.GetClient(index: integer): TClientFrm;
begin
  Result:= TClientFrm(FListClient.Items[index]);
end;

function TClientsFrm.GetClientByDOS_ID(ADOS_ID: integer): TClientFrm;
var
  i: integer;
begin
  Result:= nil;
  for i:= 0 to FListClient.Count - 1 do
    begin
      if Client[i].DOS_ID = ADOS_ID then
        begin
          Result:= Client[i];
          Break;
        end;
    end;
  if Result = nil then
    begin
      if DSDossier.DataSet.Locate('DOS_ID', ADOS_ID, []) then
        Result:= OpenTabSheetClient
      else
        MessageDlg('Client introuvable', mtInformation, [mbOk], 0);
    end
  else
    if DSDossier.DataSet.Locate('DOS_ID', ADOS_ID, []) then
      PgCtrlClients.ActivePageIndex:= ClientIsOpen(DSDossier.DataSet.FieldByName('DOS_ID').AsInteger);
end;

function TClientsFrm.GetCountClient: integer;
begin
  Result:= FListClient.Count;
end;

procedure TClientsFrm.PgCtrlClientsCanClose(Sender: TObject;
  var ACanClose: Boolean);
begin
  inherited;
  ACanClose:= PgCtrlClients.ActivePageIndex <> 0;
  if ACanClose then
    DeleteItemByClient(PgCtrlClients.ActivePage.Tag);
end;

procedure TClientsFrm.TmrDossierTimer(Sender: TObject);
begin
  inherited;
  pnlTimeDossier.Font.Color:= clRed;
  TTimer(Sender).Enabled:= False;
end;

procedure TClientsFrm.ToolBarRechercheActExcelExecute(Sender: TObject);
begin
  inherited;
  if DSDossier.DataSet.RecordCount <> 0 then
    SaveGridToXLS(cxGridDossier, True);
end;

procedure TClientsFrm.ToolBarRechercheActInsertExecute(Sender: TObject);
var
  vDlgDossierCltFrm: TDlgDossierCltFrm;
begin
  vDlgDossierCltFrm:= TDlgDossierCltFrm.Create(nil);
  try
    vDlgDossierCltFrm.AAction:= ukInsert;
    vDlgDossierCltFrm.DossierCltFramDlg.DsDossier.DataSet:= dmClients.CDS_DOS;
    vDlgDossierCltFrm.DossierCltFramDlg.DsDossier.DataSet.Insert;

    if vDlgDossierCltFrm.ShowModal = mrOk then
      begin
        //-->
      end
    else
      vDlgDossierCltFrm.DossierCltFramDlg.DsDossier.DataSet.Cancel;
  finally
    FreeAndNil(vDlgDossierCltFrm);
  end;
end;

procedure TClientsFrm.ToolBarRechercheActRefreshExecute(Sender: TObject);
begin
  inherited;
  dmClients.XmlToDataSet('Dossier', dmClients.CDS_DOS);
  pnlTimeDossier.Font.Color:= clWindowText;
  pnlTimeDossier.Caption:= dmClients.GetTimeValues;
  TmrDossier.Interval:= GParams.DelayRefreshValues;
  TmrDossier.Enabled:= True;
end;

end.
