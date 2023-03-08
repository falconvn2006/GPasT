unit FrmParamHoraire;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FrmCustomGinkoiaBox, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinBlack, dxSkinBlue,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinFoggy,
  dxSkinGlassOceans, dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky,
  dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black,
  dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink,
  dxSkinOffice2007Silver, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven, dxSkinSharp, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinsDefaultPainters,
  dxSkinValentine, dxSkinXmas2008Blue, dxSkinscxPCPainter, cxCustomData,
  cxFilter, cxData, cxDataStorage, cxEdit, DB, cxDBData, ActnList, StdCtrls,
  Buttons, ExtCtrls, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, ComCtrls,
  ToolWin, cxPropertiesStore, dmdClients, FrameToolBar;

type
  TParamHoraireFrm = class(TCustomGinkoiaBoxFrm)
    cxGrid: TcxGrid;
    cxGridTWParamHoraire: TcxGridDBTableView;
    cxGridLevel1: TcxGridLevel;
    DsParamHoraire: TDataSource;
    cxGridTWParamHorairePRH_ID: TcxGridDBColumn;
    cxGridTWParamHorairePRH_HDEB: TcxGridDBColumn;
    cxGridTWParamHorairePRH_HFIN: TcxGridDBColumn;
    cxGridTWParamHorairePRH_NOMPLAGE: TcxGridDBColumn;
    cxGridTWParamHorairePRH_NBREPLIC: TcxGridDBColumn;
    cxGridTWParamHorairePRH_DEFAUT: TcxGridDBColumn;
    cxGridTWParamHorairePRH_SRVID: TcxGridDBColumn;
    ToolBarParamHoraire: TToolBarFrame;
    pnlTimeValues: TPanel;
    procedure DsParamHoraireDataChange(Sender: TObject; Field: TField);
    procedure FormShow(Sender: TObject);
    procedure cxGridTWParamHoraireDblClick(Sender: TObject);
    procedure ToolBarFrame1ActInsertExecute(Sender: TObject);
    procedure ToolBarFrame1ActUpdateExecute(Sender: TObject);
    procedure ToolBarFrame1ActDeleteExecute(Sender: TObject);
    procedure ToolBarFrame1ActRefreshExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FServeur: TGenerique;
    FModified: Boolean;
    procedure ShowDetailParamHoraire(const AAction: TUpdateKind);
  public
    property AServeur: TGenerique read FServeur write FServeur;
    property Modified: Boolean read FModified;
  end;

var
  ParamHoraireFrm: TParamHoraireFrm;

implementation

uses FrmDetailParamHoraire, uConst;

{$R *.dfm}

{ TParamHoraireFrm }

procedure TParamHoraireFrm.cxGridTWParamHoraireDblClick(Sender: TObject);
begin
  inherited;
  ToolBarParamHoraire.ActUpdate.Execute;
end;

procedure TParamHoraireFrm.DsParamHoraireDataChange(Sender: TObject;
  Field: TField);
begin
  inherited;
  ToolBarParamHoraire.ActUpdate.Enabled:= DsParamHoraire.DataSet.RecordCount <> 0;
  ToolBarParamHoraire.ActDelete.Enabled:= DsParamHoraire.DataSet.RecordCount <> 0;
end;

procedure TParamHoraireFrm.FormCreate(Sender: TObject);
begin
  cxPropertiesStore.Active:= True;
  inherited;

end;

procedure TParamHoraireFrm.FormShow(Sender: TObject);
begin
  inherited;
  FModified:= False;
  Caption:= Caption + ' (' + FServeur.Libelle + ')';
end;

procedure TParamHoraireFrm.ShowDetailParamHoraire(const AAction: TUpdateKind);
var
  vDetailParamHoraireFrm: TDetailParamHoraireFrm;
begin
  if (DsParamHoraire.DataSet.RecordCount = 0) and (AAction = ukModify) then
    Exit;
  vDetailParamHoraireFrm:= TDetailParamHoraireFrm.Create(nil);
  try
    vDetailParamHoraireFrm.AServeur:= FServeur;
    vDetailParamHoraireFrm.Caption:= 'Plage horaire (' + FServeur.Libelle + ')';
    vDetailParamHoraireFrm.AAction:= AAction;
    if vDetailParamHoraireFrm.ShowModal = mrOk then
      begin
        FModified:= True;
        ToolBarParamHoraire.ActRefresh.Execute;
      end
    else
      vDetailParamHoraireFrm.DsParamHoraire.DataSet.Cancel;
  finally
    FreeAndNil(vDetailParamHoraireFrm);
  end;
end;

procedure TParamHoraireFrm.ToolBarFrame1ActDeleteExecute(Sender: TObject);
begin
  inherited;
  if MessageDlg('Voulez-vous supprimer ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      dmClients.DeleteRecordByRessource('Horaire?SRV_ID=' + dmClients.CDS_PARAMHORAIRES.FieldByName('PRH_SRVID').AsString +
                                        '&PRH_ID=' + dmClients.CDS_PARAMHORAIRES.FieldByName('PRH_ID').AsString);
      dmClients.CDS_PARAMHORAIRES.Delete;
      FModified:= True;
    end;
end;

procedure TParamHoraireFrm.ToolBarFrame1ActInsertExecute(Sender: TObject);
begin
  inherited;
  ShowDetailParamHoraire(ukInsert);
end;

procedure TParamHoraireFrm.ToolBarFrame1ActRefreshExecute(Sender: TObject);
begin
  inherited;
  dmClients.XmlToDataSet('Horaire', dmClients.CDS_PARAMHORAIRES);
  pnlTimeValues.Caption:= dmClients.GetTimeValues;
end;

procedure TParamHoraireFrm.ToolBarFrame1ActUpdateExecute(Sender: TObject);
begin
  inherited;
  ShowDetailParamHoraire(ukModify);
end;

end.
