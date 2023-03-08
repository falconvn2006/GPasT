unit FrmPlagesDisponibles;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FrmCustomGinkoiaBox, StdCtrls, Buttons, ExtCtrls, cxPropertiesStore,
  DB, Grids, DBGrids, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinBlack, dxSkinBlue,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinFoggy,
  dxSkinGlassOceans, dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky,
  dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black,
  dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink,
  dxSkinOffice2007Silver, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven, dxSkinSharp, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinsDefaultPainters,
  dxSkinValentine, dxSkinXmas2008Blue, dxSkinscxPCPainter, cxCustomData,
  cxFilter, cxData, cxDataStorage, cxEdit, cxDBData, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGridLevel, cxClasses, cxGridCustomView,
  cxGrid;

type
  TPlagesDisponiblesFrm = class(TCustomGinkoiaBoxFrm)
    Lab_1: TLabel;
    lblSrvName: TLabel;
    DsHoraireDispo: TDataSource;
    cxGridPlageDispo: TcxGrid;
    cxGridTWPlageDispo: TcxGridDBTableView;
    cxGridLevel2: TcxGridLevel;
    cxGridTWPlageDispoHoraireDispo: TcxGridDBColumn;
    cxGridTWPlageDispoPlageDispo: TcxGridDBColumn;
    cxGridTWPlageDispoIndexCol: TcxGridDBColumn;
    procedure cxGridTWPlageDispoDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
  public
  end;

var
  PlagesDisponiblesFrm: TPlagesDisponiblesFrm;

implementation

uses dmdClients;

{$R *.dfm}

procedure TPlagesDisponiblesFrm.cxGridTWPlageDispoDblClick(Sender: TObject);
begin
  inherited;
  ModalResult:= mrOk;
end;

procedure TPlagesDisponiblesFrm.FormCreate(Sender: TObject);
begin
  cxPropertiesStore.Active:= True;
  inherited;

end;

end.
