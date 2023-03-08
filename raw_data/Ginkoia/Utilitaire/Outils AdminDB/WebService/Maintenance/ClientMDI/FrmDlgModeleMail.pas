unit FrmDlgModeleMail;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FrmCustomGinkoiaDlg, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinBlack, dxSkinBlue,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinFoggy,
  dxSkinGlassOceans, dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky,
  dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black,
  dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink,
  dxSkinOffice2007Silver, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven, dxSkinSharp, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinsDefaultPainters,
  dxSkinValentine, dxSkinXmas2008Blue, dxSkinscxPCPainter, cxCustomData,
  cxFilter, cxData, cxDataStorage, cxEdit, DB, cxDBData, StdCtrls, cxGridLevel,
  cxClasses, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, Buttons, ExtCtrls;

type
  TDlgModeleMailFrm = class(TCustomGinkoiaDlgFrm)
    cxGridModeleMail: TcxGrid;
    cxGridTWModeleMail: TcxGridDBTableView;
    cxGridLevel2: TcxGridLevel;
    GrpBxMessage: TGroupBox;
    MemoMess: TMemo;
    DsModeleMail: TDataSource;
    cxGridTWModeleMailMAIL_FILENAME: TcxGridDBColumn;
    cxGridTWModeleMailMAIL_NAME: TcxGridDBColumn;
    cxGridTWModeleMailMAIL_OBJET: TcxGridDBColumn;
    cxGridTWModeleMailMAIL_MESSAGE: TcxGridDBColumn;
    procedure DsModeleMailDataChange(Sender: TObject; Field: TField);
  private
  public
  end;

var
  DlgModeleMailFrm: TDlgModeleMailFrm;

implementation

uses dmdClients;

{$R *.dfm}

procedure TDlgModeleMailFrm.DsModeleMailDataChange(Sender: TObject; Field: TField);
begin
  inherited;
  if DsModeleMail.DataSet.RecordCount <> 0 then
    MemoMess.Lines.Text:= DsModeleMail.DataSet.FieldByName('MAIL_MESSAGE').AsString;
end;

end.
