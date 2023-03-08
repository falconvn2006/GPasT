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
  ActnList, FrameToolBar, Menus, DBClient, StdCtrls, cxCheckBox;

type
  TClientsFrm = class(TCustomGinkoiaFormFrm)
    PgCtrlClients: TcxPageControl;
    TbShtRecherche: TcxTabSheet;
    cxGridDossier: TcxGrid;
    cxGridTWDossier: TcxGridDBTableView;
    cxGridLevel2: TcxGridLevel;
    DSDossier: TDataSource;
    cxGridTWDossierDOSS_DATABASE: TcxGridDBColumn;
    cxGridTWDossierDOSS_CHEMIN: TcxGridDBColumn;
    cxGridTWDossierDOSS_SERVID: TcxGridDBColumn;
    cxGridTWDossierGROU_ID: TcxGridDBColumn;
    cxGridTWDossierDOSS_INSTALL: TcxGridDBColumn;
    cxGridTWDossierDOSS_VIP: TcxGridDBColumn;
    cxGridTWDossierDOSS_PLATEFORME: TcxGridDBColumn;
    cxGridTWDossierDOSS_ID: TcxGridDBColumn;
    cxGridTWDossierSERV_NOM: TcxGridDBColumn;
    cxGridTWDossierGROU_NOM: TcxGridDBColumn;
    cxGridTWDossierVERS_VERSION: TcxGridDBColumn;
    ToolBarRecherche: TToolBarFrame;
    pnlTimeDossier: TPanel;
    TmrDossier: TTimer;
    cxGridTWDossierDOSS_ACTIF: TcxGridDBColumn;
    PopupMenu: TPopupMenu;
    itmActiver: TMenuItem;
    itmDesactiver: TMenuItem;
    Label1: TLabel;
    cxGridTWDossierColumn1: TcxGridDBColumn;
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
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cxGridTWDossierColumnHeaderClick(Sender: TcxGridTableView;
      AColumn: TcxGridColumn);
    procedure itmActiverClick(Sender: TObject);
    procedure itmDesactiverClick(Sender: TObject);
    procedure ToolBarRechercheActDeleteExecute(Sender: TObject);
    procedure ToolBarRechercheActUpdateExecute(Sender: TObject);
  private
    FListClient: TObjectList;
    function ClientIsOpen(Const ADOSS_ID: integer): integer;
    function OpenTabSheetClient: TClientFrm;
    function GetClient(index: integer): TClientFrm;
    function GetClientByDOSS_ID(ADOSS_ID: integer): TClientFrm;
    function GetCountClient: integer;
    procedure DeleteItemByClient(Const ADOSS_ID: integer);
    procedure ClientActived(Const AActive: integer);
  public
    property CountClient: integer read GetCountClient;
    property Client[index: integer]: TClientFrm read GetClient;
    property ClientByDOSS_ID[ADOSS_ID: integer]: TClientFrm read GetClientByDOSS_ID;
  end;

var
  ClientsFrm: TClientsFrm;

implementation

uses dmdClients, uTool, FrmDlgDossierClt, uConst, dmdClient, FrmListFolder;

{$R *.dfm}

function TClientsFrm.OpenTabSheetClient: TClientFrm;
var
  vIdx: integer;
  vTbsht: TcxTabSheet;
begin
  Result:= nil;
  if (DSDossier.DataSet = nil) or (DSDossier.DataSet.RecordCount = 0) then
    begin
      MessageDlg('Aucune donnée.', mtInformation, [mbOk], 0);
      Exit;
    end;

  if DSDossier.DataSet.FieldByName('DOSS_ACTIF').AsInteger = 0 then
    begin
      MessageDlg('Dossier désactivé.', mtInformation, [mbOk], 0);
      Exit;
    end;

  if DSDossier.DataSet.FieldByName('DOSS_CHEMIN').AsString = '' then
    begin
      MessageDlg('Chemin inéxistant.', mtInformation, [mbOk], 0);
      Exit;
    end;

  { On affiche l'onglet si il existe deja }
  vIdx:=  ClientIsOpen(DSDossier.DataSet.FieldByName('DOSS_ID').AsInteger);
  if vIdx <> 0 then
    begin
      PgCtrlClients.ActivePageIndex:= vIdx;
      Result:= ClientByDOSS_ID[DSDossier.DataSet.FieldByName('DOSS_ID').AsInteger];
      Exit;
    end;

  try
    { Creation du TabSheet }
    vTbsht:= TcxTabSheet.Create(PgCtrlClients);
    vTbsht.Name:= Format('Tbsht%d', [DSDossier.DataSet.FieldByName('DOSS_ID').AsInteger]);
    vTbsht.Parent:= PgCtrlClients;
    vTbsht.Caption:= DSDossier.DataSet.FieldByName('DOSS_DATABASE').AsString;
    vTbsht.Tag:= DSDossier.DataSet.FieldByName('DOSS_ID').AsInteger;

    { Creation de l'interface client }
    Result:= TClientFrm.Create(vTbsht);
    Result.Name:= 'ClientFrm' + IntToStr(vTbsht.Tag);
    Result.Caption:= vTbsht.Caption;
    Result.Parent:= vTbsht;
    Result.Align:= alClient;
    Result.Visible:= True;
    Result.DOSS_ID:= DSDossier.DataSet.FieldByName('DOSS_ID').AsInteger;
    FListClient.Add(Result);
    Result.Initialize;
    vTbsht.Visible := True;

    PgCtrlClients.ActivePageIndex:= PgCtrlClients.PageCount -1;
  except
    on E: Exception do
      begin
        DeleteItemByClient(DSDossier.DataSet.FieldByName('DOSS_ID').AsInteger);
        if vTbsht <> nil then
          FreeAndNil(vTbsht);
        PgCtrlClients.ActivePageIndex:= 0;
        Raise;
      end;
  end;
end;

procedure TClientsFrm.ClientActived(const AActive: integer);
begin
  if DsDossier.DataSet.FieldByName('DOSS_ACTIF').AsInteger <> AActive then
    begin
      DsDossier.DataSet.Edit;
      DsDossier.DataSet.FieldByName('DOSS_ACTIF').AsInteger:= AActive;
      dmClients.PostRecordToXml('Dossier', 'TDossier', TClientDataSet(DsDossier.DataSet));
      DsDossier.DataSet.Post;
    end;
end;

function TClientsFrm.ClientIsOpen(Const ADOSS_ID: integer): integer;
var
  i: integer;
begin
  Result:= 0;
  for i:= 0 to PgCtrlClients.PageCount - 1 do
    begin
      if PgCtrlClients.Pages[i].Tag = ADOSS_ID then
        begin
          Result:= i;
          Break;
        end;
    end;
end;

procedure TClientsFrm.cxGridTWDossierColumnHeaderClick(Sender: TcxGridTableView;
  AColumn: TcxGridColumn);
begin
  inherited;
  OnClickColumnHeaderForSearch(Sender, AColumn, dmClients.cxStyleHeaderSearch);
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

procedure TClientsFrm.DeleteItemByClient(const ADOSS_ID: integer);
var
  i: integer;
begin
  for i:= 0 to FListClient.Count -1 do
    begin
      if Client[i].DOSS_ID = ADOSS_ID then
        begin
          FListClient.Remove(Client[i]);
          Break;
        end;
    end;
end;

procedure TClientsFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  Action:= caFree;
end;

procedure TClientsFrm.FormCreate(Sender: TObject);
begin
  inherited;
  Caption:= cNameGestClient;
  TmrDossier.Interval:= GParams.DelayRefreshValues;
  if not dmClients.Initialized then
    dmClients.LoadLists;
  FListClient:= TObjectList.Create(True);
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

function TClientsFrm.GetClientByDOSS_ID(ADOSS_ID: integer): TClientFrm;
var
  i: integer;
begin
  Result:= nil;
  for i:= 0 to FListClient.Count - 1 do
    begin
      if Client[i].DOSS_ID = ADOSS_ID then
        begin
          Result:= Client[i];
          Break;
        end;
    end;

  if Result = nil then
    begin
      if DSDossier.DataSet.Locate('DOSS_ID', ADOSS_ID, []) then
        Result:= OpenTabSheetClient
      else
        MessageDlg('Client introuvable', mtInformation, [mbOk], 0);
    end
  else
    if DSDossier.DataSet.Locate('DOSS_ID', ADOSS_ID, []) then
      PgCtrlClients.ActivePageIndex:= ClientIsOpen(DSDossier.DataSet.FieldByName('DOSS_ID').AsInteger);
end;

function TClientsFrm.GetCountClient: integer;
begin
  Result:= FListClient.Count;
end;

procedure TClientsFrm.itmActiverClick(Sender: TObject);
begin
  inherited;
  ClientActived(1);
end;

procedure TClientsFrm.itmDesactiverClick(Sender: TObject);
begin
  inherited;
  ClientActived(0);
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

procedure TClientsFrm.ToolBarRechercheActDeleteExecute(Sender: TObject);
var
  i, vIdxCol: integer;
  vDOSS_ID: String;
begin
  inherited;
  ToolBarRecherche.ActDeleteExecute(Sender);
  if MessageDlg('Voulez-vous supprimer le(s) dossier(s) dans la base maintenance ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      vIdxCol:= cxGridTWDossier.GetColumnByFieldName('DOSS_ID').Index;
      for i:= 0 to cxGridTWDossier.ViewData.RowCount - 1 do
        begin
          if (cxGridTWDossier.ViewData.Rows[i].Selected) and
           (not VarIsNull(cxGridTWDossier.ViewData.Rows[i].Values[vIdxCol])) then
            begin
              vDOSS_ID:= cxGridTWDossier.ViewData.Rows[i].Values[vIdxCol];
              dmClients.DeleteRecordByRessource('Dossier?DOSS_ID=' + vDOSS_ID);
            end;
        end;
      ToolBarRecherche.ActRefresh.Execute;
    end;
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
    vDlgDossierCltFrm.DossierCltFramDlg.DBChkBx_ACTIF.Field.AsInteger:= 1;
    vDlgDossierCltFrm.DossierCltFramDlg.DBChkBx_ACTIF.Checked:= True;

    vDlgDossierCltFrm.DossierCltFramDlg.DBChkBx_EASY.Field.AsInteger:= 0;
    vDlgDossierCltFrm.DossierCltFramDlg.DBChkBx_EASY.Checked:= False;


    if vDlgDossierCltFrm.ShowModal = mrOk then
      begin
        dmClients.LoadLists;
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

procedure TClientsFrm.ToolBarRechercheActUpdateExecute(Sender: TObject);
var
  vListFolderFrm: TListFolderFrm;
begin
  vListFolderFrm:= TListFolderFrm.Create(nil);
  try
    vListFolderFrm.AITEMPATHBROWSER:= 'PATHBROWSER';
    if vListFolderFrm.ShowModal = mrOk then
      begin
        if MessageDlg('Confirmer la modification du chemin du dossier "' +
                      dmClients.CDS_DOS.FieldByName('DOSS_DATABASE').AsString + '" ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
          begin
            dmClients.CDS_DOS.Edit;
            dmClients.CDS_DOS.FieldByName('DOSS_SERVID').AsInteger:= vListFolderFrm.DBLkupCmBxSRV.ListSource.DataSet.FieldByName('DOSS_SERVID').AsInteger;
            dmClients.CDS_DOS.FieldByName('SERV_NOM').AsString:= vListFolderFrm.DBLkupCmBxSRV.Text;
            dmClients.CDS_DOS.FieldByName('DOSS_CHEMIN').AsString:= vListFolderFrm.FileNameSelected;
            dmClients.PostRecordToXml('Dossier', 'TDossier', dmClients.CDS_DOS);
            dmClients.CDS_DOS.Post;
          end;
      end;
  finally
    FreeAndNil(vListFolderFrm);
  end;
end;

end.
