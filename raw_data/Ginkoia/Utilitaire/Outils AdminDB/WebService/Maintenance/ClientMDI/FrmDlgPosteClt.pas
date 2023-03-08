unit FrmDlgPosteClt;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FrmCustomGinkoiaDlg, StdCtrls, Mask, DBCtrls, Buttons, ExtCtrls, DB,
  dmdClient, dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinFoggy, dxSkinGlassOceans, DBClient,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSharp, dxSkinSilver, dxSkinSpringTime,
  dxSkinStardust, dxSkinSummer2008, dxSkinsDefaultPainters, dxSkinValentine,
  dxSkinXmas2008Blue, dxSkinscxPCPainter, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxDBData, cxTextEdit, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGridLevel, cxClasses, cxGridCustomView,
  cxGrid, cxPC;

type
  TDlgPosteCltFrm = class(TCustomGinkoiaDlgFrm)
    DsPoste: TDataSource;
    Lab_2: TLabel;
    Lab_3: TLabel;
    DBText1: TDBText;
    DBText2: TDBText;
    DsSociete: TDataSource;
    DsMagasin: TDataSource;
    PgCtrlPoste: TcxPageControl;
    TbShtPos: TcxTabSheet;
    TbShtSaisieParLot: TcxTabSheet;
    cxGrid2: TcxGrid;
    cxGrid2DBTableView1: TcxGridDBTableView;
    cxGrid2Level1: TcxGridLevel;
    Lab_1: TLabel;
    DBEDT_POSTE: TDBEdit;
    cxGrid2DBTableView1DOSS_ID: TcxGridDBColumn;
    cxGrid2DBTableView1POST_ID: TcxGridDBColumn;
    cxGrid2DBTableView1POST_NOM: TcxGridDBColumn;
    cxGrid2DBTableView1POST_MAGID: TcxGridDBColumn;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpdBtnOkClick(Sender: TObject);
  private
    FdmClient: TdmClient;
    FCDS_ListPOS: TClientDataSet;
    FIsSaisieParLot: Boolean;
  protected
    function PostValues: Boolean; override;
  public
    property AdmClient: TdmClient read FdmClient write FdmClient;
    property IsSaisieParLot: Boolean read FIsSaisieParLot write FIsSaisieParLot;
  end;

var
  DlgPosteCltFrm: TDlgPosteCltFrm;

implementation

uses dmdClients, uConst, uTool;

{$R *.dfm}

procedure TDlgPosteCltFrm.FormCreate(Sender: TObject);
begin
  inherited;
  UseUpdateKind:= True;
  FIsSaisieParLot:= False;
end;

procedure TDlgPosteCltFrm.FormShow(Sender: TObject);
begin
  inherited;
  PgCtrlPoste.HideTabs:= True;
  DsSociete.DataSet:= FdmClient.CDS_SOC;
  DsMagasin.DataSet:= FdmClient.CDS_MAG;
  DsPoste.DataSet:= FdmClient.CDS_POS;

  case AAction of
    ukModify:
      begin
        DsPoste.DataSet.Edit;
        PgCtrlPoste.ActivePageIndex:= 0;
      end;
    ukInsert:
      begin
        if FIsSaisieParLot then
          begin
            FCDS_ListPOS:= TClientDataSet.Create(Self);
            CloneClientDataSet(FdmClient.CDS_POS, FCDS_ListPOS, False);
            FCDS_ListPOS.OnNewRecord:= FdmClient.CDS_POSNewRecord;
            FCDS_ListPOS.Append;
            FCDS_ListPOS.Post;

            DsPoste.DataSet:= FCDS_ListPOS;

            PgCtrlPoste.ActivePageIndex:= 1;
          end
        else
          DsPoste.DataSet.Append;
      end;
    ukDelete: ;
  end;
end;

function TDlgPosteCltFrm.PostValues: Boolean;
var
  vSL: TStringList;
begin
  Result:= inherited PostValues;
  vSL:= TStringList.Create;
  try
    try
      if Trim(DBEDT_POSTE.Text) = '' then
        Raise Exception.Create('Le nom du poste est obligatoire.');

      vSL.Append('DOSS_ID');
      vSL.Append('MAGA_ID');
      vSL.Append('POST_POSID');
      vSL.Append('POST_NOM');
      vSL.Append('POST_MAGID');
      vSL.Append('ACTION');

      if AAction = ukInsert then
      begin
        if DsPoste.DataSet.State = dsBrowse then
          DsPoste.DataSet.Edit;

        DsPoste.DataSet.FieldByName('DOSS_ID').AsInteger:= DsMagasin.DataSet.FieldByName('DOSS_ID').AsInteger;
        DsPoste.DataSet.FieldByName('MAGA_ID').AsInteger:= DsMagasin.DataSet.FieldByName('MAGA_ID').AsInteger;
        DsPoste.DataSet.FieldByName('POST_MAGID').AsInteger:= DsMagasin.DataSet.FieldByName('MAGA_MAGID_GINKOIA').AsInteger;
      end;

      case AAction of     //SR :
        ukModify : DsPoste.DataSet.FieldByName('ACTION').AsInteger:= cActionModify;
        ukInsert : DsPoste.DataSet.FieldByName('ACTION').AsInteger:= cActionInsert;
        ukDelete : DsPoste.DataSet.FieldByName('ACTION').AsInteger:= cActionDelete;
      end;

      dmClients.PostRecordToXml('Poste', 'TPoste', TClientDataSet(DsPoste.DataSet), vSL);
      DsPoste.DataSet.Post;
      Result:= True;

      if (AAction = ukInsert) and (FIsSaisieParLot) then
        begin
          DsPoste.DataSet.Next;
          if DsPoste.DataSet.Eof then
            begin
              Result:= True;
              Exit;
            end;
          Result:= PostValues;
        end
      else
        Result:= True;

    except
      Raise;
    end;
  finally
    FreeAndNil(vSL);
  end;
end;

procedure TDlgPosteCltFrm.SpdBtnOkClick(Sender: TObject);
begin
  inherited;
  if (AAction = ukInsert) and (FIsSaisieParLot) then
    begin
      if DsPoste.DataSet.State <> dsBrowse then
        DsPoste.DataSet.Post;

      DsPoste.DataSet.First;
    end;
end;

end.

