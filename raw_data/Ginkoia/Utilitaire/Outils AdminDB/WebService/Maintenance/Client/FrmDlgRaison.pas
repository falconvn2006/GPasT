unit FrmDlgRaison;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FrmCustomGinkoiaDlg, Buttons, ExtCtrls, cxGraphics, cxControls,
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
  cxDBData, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridLevel, cxClasses, cxGridCustomView, cxGrid;

type
  TDlgRaisonFrm = class(TCustomGinkoiaDlgFrm)
    cxGridRaison: TcxGrid;
    cxGridTWRaison: TcxGridDBTableView;
    cxGridLevel2: TcxGridLevel;
    DsRaison: TDataSource;
    cxGridTWRaisonRAISON_ID: TcxGridDBColumn;
    cxGridTWRaisonRAISON_NOM: TcxGridDBColumn;
    procedure FormShow(Sender: TObject);
  private
    FDataSet: TDataSet;
  protected
    function PostValues: Boolean; override;
  public
    property ADataSet: TDataSet read FDataSet write FDataSet;
  end;

var
  DlgRaisonFrm: TDlgRaisonFrm;

implementation

uses dmdClients;

{$R *.dfm}

procedure TDlgRaisonFrm.FormShow(Sender: TObject);
begin
  inherited;
  dmClients.XmlToDataSet('Raison', dmClients.CDSRAISONS);
end;

function TDlgRaisonFrm.PostValues: Boolean;
begin
  Result:= inherited PostValues;
  try
    dmClients.CDSRAISONS.Edit;
    dmClients.CDSRAISONS.FieldByName('HDB_ID').AsInteger:= FDataSet.FieldByName('HDB_ID').AsInteger;
    dmClients.CDSRAISONS.FieldByName('EMET_ID').AsInteger:= FDataSet.FieldByName('EMET_ID').AsInteger;
    dmClients.CDSRAISONS.FieldByName('DOS_ID').AsInteger:= FDataSet.FieldByName('DOS_ID').AsInteger;
    dmClients.CDSRAISONS.Post;
    dmClients.PostRecordToXml('Emetteur', 'TEmetteur', dmClients.CDSRAISONS);
    Result:= True;
  except
    Raise;
  end;
end;

end.
