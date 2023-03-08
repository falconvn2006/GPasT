unit MSS_CFGBases;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxStyles, dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinFoggy, dxSkinGlassOceans,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSharp, dxSkinSilver, dxSkinSpringTime,
  dxSkinStardust, dxSkinSummer2008, dxSkinsDefaultPainters, dxSkinValentine,
  dxSkinXmas2008Blue, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, StdCtrls,
  ExtCtrls, MSS_DMDbMag, CategoryButtons, ComCtrls, DBCtrls,
  MSS_Type,
  cxCheckBox
  ;

type
  Tfrm_CFGBases = class(TForm)
    Pan_Left: TPanel;
    Pan_Client: TPanel;
    Pan_ClientTop: TPanel;
    Pan_ClientBottom: TPanel;
    Gbx_InfoComp: TGroupBox;
    Gbx_ListeBase: TGroupBox;
    Pan_lstBases: TPanel;
    cxgBases: TcxGrid;
    cxgBasesDBTableView1: TcxGridDBTableView;
    cxgBasesLevel1: TcxGridLevel;
    Ds_DOSSIERS: TDataSource;
    cxgBasesDBTableView1DOS_ID: TcxGridDBColumn;
    cxgBasesDBTableView1DOS_NOM: TcxGridDBColumn;
    cxgBasesDBTableView1DOS_GROUPE: TcxGridDBColumn;
    cxgBasesDBTableView1DOS_NUM: TcxGridDBColumn;
    cxgBasesDBTableView1DOS_MAGID: TcxGridDBColumn;
    cxgBasesDBTableView1DOS_MAGENSEIGNE: TcxGridDBColumn;
    cxgBasesDBTableView1DOS_BASEPATH: TcxGridDBColumn;
    cxgBasesDBTableView1DOS_VILLE: TcxGridDBColumn;
    cxgBasesDBTableView1DOS_ACTIF: TcxGridDBColumn;
    cxgBasesDBTableView1DOS_DTCREATION: TcxGridDBColumn;
    cxgBasesDBTableView1DOS_DTMODIFICATION: TcxGridDBColumn;
    CategoryButtons1: TCategoryButtons;
    pb_progress: TProgressBar;
    Pan_ICLeft: TPanel;
    Lab_DTCReation: TLabel;
    Lab_DTModification: TLabel;
    DBText1: TDBText;
    DBText2: TDBText;
    Pan_ICCLient: TPanel;
    DBMemo1: TDBMemo;
    Splitter1: TSplitter;
    procedure DoCloseOnClick(Sender: TObject);
    procedure DoAddBaseOnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DoEditBaseOnclick(Sender: TObject);
    procedure cxgBasesDBTableView1CellDblClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure DoCompleteBaseOnClick(Sender: TObject);
    procedure DoActiveBaseOnclick(Sender: TObject);
    procedure CategoryButtons1CategoryCollapase(Sender: TObject;
      const Category: TButtonCategory);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frm_CFGBases: Tfrm_CFGBases;

implementation

uses MSS_CFGBasesLignes;

{$R *.dfm}

procedure Tfrm_CFGBases.DoAddBaseOnClick(Sender: TObject);
var
  DOS_ID : Integer;
begin
  DOS_ID := ShowForm(mAdd);
  if DOS_ID > -1  then
  begin
    Ds_DOSSIERS.DataSet.Refresh;
    Ds_DOSSIERS.DataSet.Locate('DOS_ID',DOS_ID,[]);
  end;
end;

procedure Tfrm_CFGBases.DoEditBaseOnclick(Sender: TObject);
var
  DOS_ID : Integer;
begin
  DOS_ID := ShowForm(mEdit,Ds_DOSSIERS.DataSet.FieldByName('DOS_ID').AsInteger);
  if DOS_ID > -1  then
  begin
    Ds_DOSSIERS.DataSet.Refresh;
    Ds_DOSSIERS.DataSet.Locate('DOS_ID',DOS_ID,[]);
  end;
end;

procedure Tfrm_CFGBases.DoActiveBaseOnclick(Sender: TObject);
var
  ID : Integer;
begin
  With DM_DbMAG do
  begin
//    With Que_DOSSIERS do
//    begin
//      if FieldByName('DOS_ACTIF').AsInteger = 0 then
//        if (Trim(FieldByName('DOS_GROUPE').AsString) = '') Or (Trim(FieldByName('DOS_NUM').AsString) = '') then
//        begin
//          ShowMessage('Le groupe et le numéro sont obligatoire pour pouvoir activer une base');
//          Exit;
//        end; // if
//    end; // with

    With Que_DbMTmp do
    begin
      IboDbMag.StartTransaction;
      try
        ID := Que_DOSSIERS.FieldByName('DOS_ID').AsInteger;
        Close;
        SQL.Clear;
        SQL.Add('Update DOSSIERS Set');
        SQL.Add(' DOS_ACTIF = :PDOSACTIF');
        SQL.Add('Where DOS_ID = :PDOSID');
        ParamCheck := True;
        if Que_DOSSIERS.FieldByName('DOS_ACTIF').AsInteger = 0 then
          ParamByName('PDOSACTIF').AsInteger := 1
        else
          ParamByName('PDOSACTIF').AsInteger := 0;
        ParamByName('PDOSID').AsInteger := ID;
        ExecSQL;

        IboDbMag.Commit;

        // Rechargement + Repositionnement
        Que_DOSSIERS.Refresh;
        Que_DOSSIERS.Locate('DOS_ID',ID,[]);
      Except on E:Exception do
        begin
          IboDbMag.Rollback;
          ShowMessage(E.Message);
        end;
      end;
    end; // with
  end; // with
end;

procedure Tfrm_CFGBases.DoCompleteBaseOnClick(Sender: TObject);
begin
  Try
    pb_progress.Visible := True;
    DM_DbMAG.DoCheckMag(pb_progress);
  Finally
    pb_progress.Visible := False;
  End;
end;

procedure Tfrm_CFGBases.DoCloseOnClick(Sender: TObject);
begin
  TTabSheet(Parent).tabVisible := False;
  bEnTraitement := False;
end;

procedure Tfrm_CFGBases.CategoryButtons1CategoryCollapase(Sender: TObject;
  const Category: TButtonCategory);
begin
  Category.Collapsed := False;
end;

procedure Tfrm_CFGBases.cxgBasesDBTableView1CellDblClick(
  Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
  AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  DoEditBaseOnclick(Self);
end;

procedure Tfrm_CFGBases.FormCreate(Sender: TObject);
begin
  DM_DbMAG.Que_DOSSIERS.Close;
  DM_DbMAG.Que_DOSSIERS.Open;
end;

end.
