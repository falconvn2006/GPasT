unit UPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.StdCtrls,
  Data.DB, Vcl.Grids, Vcl.DBGrids, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, dxSkinsCore, dxSkinBasic, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkroom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMetropolis,
  dxSkinMetropolisDark, dxSkinMoneyTwins, dxSkinOffice2007Black,
  dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink,
  dxSkinOffice2007Silver, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2010Silver, dxSkinOffice2013DarkGray, dxSkinOffice2013LightGray,
  dxSkinOffice2013White, dxSkinOffice2016Colorful, dxSkinOffice2016Dark,
  dxSkinOffice2019Black, dxSkinOffice2019Colorful, dxSkinOffice2019DarkGray,
  dxSkinOffice2019White, dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic,
  dxSkinSharp, dxSkinSharpPlus, dxSkinSilver, dxSkinSpringtime, dxSkinStardust,
  dxSkinSummer2008, dxSkinTheAsphaltWorld, dxSkinTheBezier,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVisualStudio2013Blue,
  dxSkinVisualStudio2013Dark, dxSkinVisualStudio2013Light, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinXmas2008Blue, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxNavigator, dxDateRanges,
  dxScrollbarAnnotations, cxDBData, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  dxGDIPlusClasses, Data.Win.ADODB;

type
  TFormPrincipal = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    pnInfosDados: TPanel;
    Panel5: TPanel;
    tabOpcoes: TTabControl;
    Panel6: TPanel;
    pnData: TPanel;
    tituloData: TLabel;
    datPeriodo: TDateTimePicker;
    pnRendimentos: TPanel;
    pnReceitas: TPanel;
    pnDespesas: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    pnReceita_2: TPanel;
    pnInfo_2: TPanel;
    pnInfo_3: TPanel;
    pnReceita_1: TPanel;
    Panel3: TPanel;
    Image1: TImage;
    cxdbDespesasDBTableView1: TcxGridDBTableView;
    cxdbDespesasLevel1: TcxGridLevel;
    cxdbDespesas: TcxGrid;
    Image2: TImage;
    Image3: TImage;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Panel4: TPanel;
    Panel7: TPanel;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    dsDados: TDataSource;
    QueryDados: TADODataSet;
    ProgressBar1: TProgressBar;
    ProgressBar2: TProgressBar;
    ProgressBar3: TProgressBar;
    pnInfosReceitas_1: TPanel;
    pnInfosReceitas_2: TPanel;
    pnInfosReceitas_3: TPanel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Panel8: TPanel;
    Panel9: TPanel;
    Image8: TImage;
    Label11: TLabel;
    Panel10: TPanel;
    Image7: TImage;
    Panel11: TPanel;
    Image9: TImage;
    Label10: TLabel;
    Label12: TLabel;
    Panel12: TPanel;
    Image10: TImage;
    procedure TabControl1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.dfm}

uses UCadastro, UDados, ULogin;

procedure TFormPrincipal.TabControl1Change(Sender: TObject);
begin
  if tabOpcoes.TabIndex = 1 then
    //
end;

end.
