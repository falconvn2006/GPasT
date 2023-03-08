unit FrmSplittage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FrmCustomGinkoiaForm, cxPropertiesStore, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinBlack,
  dxSkinBlue, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinFoggy, dxSkinGlassOceans, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSharp, dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinXmas2008Blue,
  dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, DB,
  cxDBData, cxGridLevel, cxClasses, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, ExtCtrls, FrameToolBar, StdCtrls,
  DBCtrls, Buttons, FramUpDown;

type
  TSplittageFrm = class(TCustomGinkoiaFormFrm)
    ToolBarFrame: TToolBarFrame;
    pnlGrid: TPanel;
    pnlDetail: TPanel;
    cxGridSuiviSplittage: TcxGrid;
    cxGridDBTWSuiviSplittage: TcxGridDBTableView;
    cxGridLevel4: TcxGridLevel;
    DsSuiviSplittage: TDataSource;
    Lab_1: TLabel;
    DBMemoEVENTLOG: TDBMemo;
    cxGridDBTWSuiviSplittageEMET_NOM: TcxGridDBColumn;
    cxGridDBTWSuiviSplittageDATEHEURESTART: TcxGridDBColumn;
    cxGridDBTWSuiviSplittageDATEHEUREEND: TcxGridDBColumn;
    cxGridDBTWSuiviSplittageSTARTED: TcxGridDBColumn;
    cxGridDBTWSuiviSplittageTERMINATE: TcxGridDBColumn;
    cxGridDBTWSuiviSplittageERROR: TcxGridDBColumn;
    cxGridDBTWSuiviSplittageUSERNAME: TcxGridDBColumn;
    cxGridDBTWSuiviSplittageTYPESPLIT: TcxGridDBColumn;
    pnlTmrSuiviSplittage: TPanel;
    pnlUpDown: TPanel;
    SpdBtnStart: TSpeedButton;
    SpdBtnStop: TSpeedButton;
    Bevel1: TBevel;
    cxStyleRepository: TcxStyleRepository;
    cxStyleErreur: TcxStyle;
    cxStyleTerminate: TcxStyle;
    Splitter: TSplitter;
    cxGridDBTWSuiviSplittageCLEARFILES: TcxGridDBColumn;
    UpDownFramSplittage: TUpDownFram;
    cxGridDBTWSuiviSplittageNOSPLIT: TcxGridDBColumn;
    procedure SpdBtnStartClick(Sender: TObject);
    procedure SpdBtnStopClick(Sender: TObject);
    procedure SpdBtnUpClick(Sender: TObject);
    procedure SpdBtnDownClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ToolBarFrameActRefreshExecute(Sender: TObject);
    procedure ToolBarFrameActDeleteExecute(Sender: TObject);
    procedure cxGridDBTWSuiviSplittageStylesGetContentStyle(
      Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
      AItem: TcxCustomGridTableItem; out AStyle: TcxStyle);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure CheckSplitStarted;
    procedure MoveSplittage(Const ADown: Boolean);
    procedure LoadSplittageLog;
  public
    procedure Initialize;
  end;

var
  SplittageFrm: TSplittageFrm;

implementation

uses dmdClients, u_Parser;

{$R *.dfm}

{ TSplittageFrm }

procedure TSplittageFrm.CheckSplitStarted;
var
  vSL: TStringList;
  vGen: TGenerique;
begin
  inherited;
  vSL:= TStringList.Create;
  try
    dmClients.XmlToList('StatutSplittageProcess', cBlsResult, '', vSL, Self, False);
    if vSL.Count <> 0 then
      begin
        vGen:= TGenerique(vSL.Objects[0]);
        if vGen <> nil then
          SpdBtnStart.Enabled:= vGen.Libelle = '1';
        SpdBtnStop.Enabled:= not SpdBtnStart.Enabled;
      end;
  finally
    FreeAndNil(vSL);
  end;
end;

procedure TSplittageFrm.cxGridDBTWSuiviSplittageStylesGetContentStyle(
  Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
  AItem: TcxCustomGridTableItem; out AStyle: TcxStyle);
var
  vCxGridDBCol: TcxGridDBColumn;
begin
  inherited;
  vCxGridDBCol:= cxGridDBTWSuiviSplittage.Columns[AItem.Index];
  if (vCxGridDBCol.DataBinding.FieldName = 'SPL_TERMINATE') and (not VarIsNull(ARecord.Values[vCxGridDBCol.Index])) and
     (ARecord.Values[vCxGridDBCol.Index] = 1) then
    AStyle:= cxStyleTerminate
  else
    if (vCxGridDBCol.DataBinding.FieldName = 'SPL_ERROR') and (not VarIsNull(ARecord.Values[vCxGridDBCol.Index])) and
     (ARecord.Values[vCxGridDBCol.Index] = 1) then
    AStyle:= cxStyleErreur;
end;

procedure TSplittageFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  Action:= caFree;
end;

procedure TSplittageFrm.FormCreate(Sender: TObject);
begin
  cxPropertiesStore.Active:= True;
  inherited;
  ToolBarFrame.ConfirmDelete:= True;
  LoadSplittageLog;
end;

procedure TSplittageFrm.Initialize;
begin
  LoadSplittageLog;
end;

procedure TSplittageFrm.LoadSplittageLog;
var
  vNOSPLIT: integer;
begin
  inherited;
  vNOSPLIT:= -1;
  CheckSplitStarted;

  if dmClients.CDSSPLITTAGE_LOG.RecordCount <> 0 then
    vNOSPLIT:= dmClients.CDSSPLITTAGE_LOG.FieldByName('SPLI_NOSPLIT').AsInteger;

  { Chargement des splittages }
  dmClients.CDSSPLITTAGE_LOG.EmptyDataSet;
  dmClients.XmlToDataSet('SplittageLog', dmClients.CDSSPLITTAGE_LOG, True, True, True, 'UTF-8', 10000);   //SR : Correction 4000 -> 10000
  dmClients.ResetTimePanel(pnlTmrSuiviSplittage);

  if (dmClients.CDSSPLITTAGE_LOG.RecordCount <> 0) and (vNOSPLIT <> -1) then
    dmClients.CDSSPLITTAGE_LOG.Locate('SPLI_NOSPLIT', vNOSPLIT, []);
end;

procedure TSplittageFrm.MoveSplittage(const ADown: Boolean);
var
  vSL: TStringList;
  vNOSPLIT: integer;
begin
  inherited;
  vSL:= TStringList.Create;
  try
    vNOSPLIT:= DsSuiviSplittage.DataSet.FieldByName('SPLI_NOSPLIT').AsInteger;
    dmClients.XmlToList('PriorityOrdreSplittage?NOSPLIT=' + IntTostr(vNOSPLIT) +
                        '&PRIORITYORDRE=' + IntToStr(Integer(ADown)), cBlsResult, '', vSL, Self);
    LoadSplittageLog;
    DsSuiviSplittage.DataSet.Locate('SPLI_NOSPLIT', vNOSPLIT, []);
  finally
    FreeAndNil(vSL);
  end;
end;

procedure TSplittageFrm.SpdBtnDownClick(Sender: TObject);
begin
  inherited;
  MoveSplittage(True);
end;

procedure TSplittageFrm.SpdBtnStartClick(Sender: TObject);
var
  vSL: TStringList;
  vGen: TGenerique;
begin
  inherited;
  vSL:= TStringList.Create;
  try
    dmClients.XmlToList('StatutSplittageProcess?STATUT=0', cBlsResult, '', vSL, Self, False);
    if vSL.Count <> 0 then
      begin
        vGen:= TGenerique(vSL.Objects[0]);
        if vGen <> nil then
          SpdBtnStart.Enabled:= vGen.Libelle = '1';
        SpdBtnStop.Enabled:= not SpdBtnStart.Enabled;

        if not SpdBtnStart.Enabled then
          LoadSplittageLog;
      end;
  finally
    FreeAndNil(vSL);
  end;
end;

procedure TSplittageFrm.SpdBtnStopClick(Sender: TObject);
var
  vSL: TStringList;
  vGen: TGenerique;
begin
  inherited;
  vSL:= TStringList.Create;
  try
    dmClients.XmlToList('StatutSplittageProcess?STATUT=1', cBlsResult, '', vSL, Self, False);
    if vSL.Count <> 0 then
      begin
        vGen:= TGenerique(vSL.Objects[0]);
        if vGen <> nil then
          SpdBtnStop.Enabled:= vGen.Libelle = '0';
        SpdBtnStart.Enabled:= not SpdBtnStop.Enabled;
      end;
  finally
    FreeAndNil(vSL);
  end;
end;

procedure TSplittageFrm.SpdBtnUpClick(Sender: TObject);
begin
  inherited;
  MoveSplittage(False);
end;

procedure TSplittageFrm.ToolBarFrameActDeleteExecute(Sender: TObject);
var
  vAllow: Boolean;
  i, NOSPLIT : Integer;


begin
  inherited;
  if MessageDlg('Voulez-vous supprimer le(s) log(s) de Split(s) sélectionné(s) dans la base maintenance ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    if DsSuiviSplittage.DataSet.RecordCount <> 0 then
    begin
      for i:=0 to cxGridDBTWSuiviSplittage.Controller.SelectedRowCount - 1 do
      begin
        NOSPLIT :=  cxGridDBTWSuiviSplittage.Controller.SelectedRows[i].Values[cxGridDBTWSuiviSplittage.FindItemByName('cxGridDBTWSuiviSplittageNOSPLIT').Index];

        { suppression des splits}
        dmClients.XmlToDataSet('SplittageLog?NOSPLIT='+IntToStr(NOSPLIT)+'&DELETE=1', dmClients.CDSSPLITTAGE_LOG, False, False, False, 'UTF-8', 10000);
      end;

      LoadSplittageLog;
    end;
  end;


end;

procedure TSplittageFrm.ToolBarFrameActRefreshExecute(Sender: TObject);
begin
  inherited;
  LoadSplittageLog;
end;

end.
