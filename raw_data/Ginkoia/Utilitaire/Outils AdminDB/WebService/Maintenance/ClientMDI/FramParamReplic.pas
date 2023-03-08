unit FramParamReplic;

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
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, Buttons,
  StdCtrls, FrameToolBar, ExtCtrls, FramUpDown;

type
  TParamReplicFram = class(TFrame)
    pnlDisponible: TPanel;
    ToolBarFrameDispo: TToolBarFrame;
    pnlGrdDispo: TPanel;
    pnlTraite: TPanel;
    pnlBottomTraite: TPanel;
    pnlGrdTraite: TPanel;
    Lab_1: TLabel;
    EdtStepLoop: TEdit;
    SpdBtnTraiteLoopEnabled: TSpeedButton;
    SpdBtnTraiteLoopDisabled: TSpeedButton;
    Pan_1: TPanel;
    cxGridListDispo: TcxGrid;
    cxGridDBTableViewListDispo: TcxGridDBTableView;
    cxGridLevel4: TcxGridLevel;
    cxGridListTraite: TcxGrid;
    cxGridDBTableViewListTraite: TcxGridDBTableView;
    cxGridLevel1: TcxGridLevel;
    Pan_2: TPanel;
    DsListDispo: TDataSource;
    DsListTraite: TDataSource;
    UpDownFramDispo: TUpDownFram;
    pnlMiddleBtn: TPanel;
    SpdBtnAllDisable: TSpeedButton;
    SpdBtnDisable: TSpeedButton;
    SpdBtnEnable: TSpeedButton;
    SpdBtnAllEnable: TSpeedButton;
  private
  public
  end;

implementation

{$R *.dfm}

end.
