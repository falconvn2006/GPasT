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
  DBCtrls, Buttons;

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
    SpdBtnUp: TSpeedButton;
    SpdBtnDown: TSpeedButton;
    SpdBtnStart: TSpeedButton;
    SpdBtnStop: TSpeedButton;
    Bevel1: TBevel;
    cxStyleRepository: TcxStyleRepository;
    cxStyleErreur: TcxStyle;
    cxStyleTerminate: TcxStyle;
    Splitter: TSplitter;
    cxGridDBTWSuiviSplittageCLEARFILES: TcxGridDBColumn;
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
  private
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

procedure TSplittageFrm.cxGridDBTWSuiviSplittageStylesGetContentStyle(
  Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
  AItem: TcxCustomGridTableItem; out AStyle: TcxStyle);
var
  vCxGridDBCol: TcxGridDBColumn;
begin
  inherited;
  vCxGridDBCol:= cxGridDBTWSuiviSplittage.Columns[AItem.Index];
  if (vCxGridDBCol.DataBinding.FieldName = 'TERMINATE') and (not VarIsNull(ARecord.Values[vCxGridDBCol.Index])) and
     (ARecord.Values[vCxGridDBCol.Index] = 1) then
    AStyle:= cxStyleTerminate
  else
    if (vCxGridDBCol.DataBinding.FieldName = 'ERROR') and (not VarIsNull(ARecord.Values[vCxGridDBCol.Index])) and
     (ARecord.Values[vCxGridDBCol.Index] = 1) then
    AStyle:= cxStyleErreur;
end;

procedure TSplittageFrm.FormCreate(Sender: TObject);
begin
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
  vSL: TStringList;
  vGen: TGenerique;
  vNOSPLIT: integer;
begin
  inherited;
  vNOSPLIT:= -1;
  vSL:= TStringList.Create;
  try
    dmClients.XmlToList('StatutSplittageProcess', cBlsResult, '', vSL, Self, False);
    if vSL.Count <> 0 then
      begin
        vGen:= TGenerique(vSL.Objects[0]);
        if vGen <> nil then
          SpdBtnStart.Enabled:= vGen.Libelle = '0';
        SpdBtnStop.Enabled:= not SpdBtnStart.Enabled;
      end;

    if dmClients.CDSSPLITTAGE_LOG.RecordCount <> 0 then
      vNOSPLIT:= dmClients.CDSSPLITTAGE_LOG.FieldByName('NOSPLIT').AsInteger;

    { Chargement des splittages }
    dmClients.CDSSPLITTAGE_LOG.EmptyDataSet;
    dmClients.XmlToDataSet('SplittageLog', dmClients.CDSSPLITTAGE_LOG, True, True, True, 'UTF-8', 3000);
    dmClients.ResetTimePanel(pnlTmrSuiviSplittage);

    if (dmClients.CDSSPLITTAGE_LOG.RecordCount <> 0) and (vNOSPLIT <> -1) then
      dmClients.CDSSPLITTAGE_LOG.Locate('NOSPLIT', vNOSPLIT, []);
  finally
    FreeAndNil(vSL);
  end;
end;

procedure TSplittageFrm.MoveSplittage(const ADown: Boolean);
var
  vSL: TStringList;
  vNOSPLIT: integer;
begin
  inherited;
  vSL:= TStringList.Create;
  try
    vNOSPLIT:= DsSuiviSplittage.DataSet.FieldByName('NOSPLIT').AsInteger;
    dmClients.XmlToList('PriorityOrdreSplittage?NOSPLIT=' + IntTostr(vNOSPLIT) +
                        '&PRIORITYORDRE=' + IntToStr(Integer(ADown)), cBlsResult, '', vSL, Self);
    LoadSplittageLog;
    DsSuiviSplittage.DataSet.Locate('NOSPLIT', vNOSPLIT, []);
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
    dmClients.XmlToList('StatutSplittageProcess?STATUT=1', cBlsResult, '', vSL, Self, False);
    if vSL.Count <> 0 then
      begin
        vGen:= TGenerique(vSL.Objects[0]);
        if vGen <> nil then
          SpdBtnStart.Enabled:= vGen.Libelle = '0';
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
    dmClients.XmlToList('StatutSplittageProcess?STATUT=0', cBlsResult, '', vSL, Self, False);
    if vSL.Count <> 0 then
      begin
        vGen:= TGenerique(vSL.Objects[0]);
        if vGen <> nil then
          SpdBtnStop.Enabled:= vGen.Libelle = '1';
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
begin
  inherited;
  if DsSuiviSplittage.DataSet.RecordCount <> 0 then
    begin
      if (DsSuiviSplittage.DataSet.FieldByName('STARTED').AsInteger = 1) and
         (DsSuiviSplittage.DataSet.FieldByName('TERMINATE').AsInteger = 0) and
         (DsSuiviSplittage.DataSet.FieldByName('ERROR').AsInteger = 0) then
        Exit;

      ToolBarFrame.ActDeleteExecute(Sender);

      dmClients.DeleteRecordByRessource('RecupBase?NOSPLIT=' + DsSuiviSplittage.DataSet.FieldByName('NOSPLIT').AsString);
      LoadSplittageLog;
    end;
end;

procedure TSplittageFrm.ToolBarFrameActRefreshExecute(Sender: TObject);
begin
  inherited;
  LoadSplittageLog;
end;

end.
