unit Main_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AdvPageControl, ComCtrls, ExtCtrls, AdvOfficePager,
  AdvOfficePagerStylers, ImgList, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore, dxSkinBlack,
  dxSkinBlue, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinFoggy, dxSkinGlassOceans, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSharp, dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinXmas2008Blue, AdvPanel,
  AdvSmoothExpanderGroup, cxGroupBox, AdvSmoothPanel, RzPanel,
  LMDCustomComponent, LMDContainerComponent, LMDBaseDialog, LMDCalendarDlg,
  AdvSmoothCalendar, RzButton, RzRadChk, LMDTextCheckBox, LMDControl,
  LMDCustomControl, LMDCustomPanel, LMDButtonControl, LMDCustomCheckBox,
  LMDCheckBox, cxCheckBox, StdCtrls, CheckLst, cxTextEdit, Mask, RzEdit,
  RzBtnEdt, cxDBEdit, RzDBEdit, DBCtrls, DB, dxmdaset, cxClasses, cxCustomData,
  cxStyles, AdvMemo, cxMemo, AdvSmoothLabel, RzLabel, Grids, DBGrids, RzDBGrid,
  cxCustomPivotGrid, cxPivotGridOLAPDataSource, cxPivotGrid, AdvEdit,
  GinCaracteristique, Buttons;

type
  TForm1 = class(TForm)
    Image1: TImage;
    AdvOfficePager1: TAdvOfficePager;
    AdvOfficePager11: TAdvOfficePage;
    AdvOfficePager12: TAdvOfficePage;
    AdvOfficePager13: TAdvOfficePage;
    AdvOfficePagerOfficeStyler1: TAdvOfficePagerOfficeStyler;
    ImageList1: TImageList;
    AdvOfficePage1: TAdvOfficePage;
    AdvOfficePage2: TAdvOfficePage;
    AdvOfficePage3: TAdvOfficePage;
    CheckBox1: TCheckBox;
    DBNavigator1: TDBNavigator;
    RzPanel1: TRzPanel;
    RzPanel2: TRzPanel;
    RzLabel1: TRzLabel;
    RzPanel3: TRzPanel;
    BitBtn1: TBitBtn;
    ButtonedEdit1: TButtonedEdit;
    RzButtonEdit1: TRzButtonEdit;
    BitBtn2: TBitBtn;
    RzPanel4: TRzPanel;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Déclarations privées }
    gencara: TRzGinCaracteristique;
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  gencara := TRzGinCaracteristique.Create(Self);
  gencara.Parent := AdvOfficePage1;
  gencara.Left:= 80;
  gencara.Top:= 350;
  gencara.Height := 350;
  gencara.Width := 250;
  gencara.Lab_Titre.Caption := 'Caractéristique';
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
var
  x,y,w,h: integer;
begin
  randomize;
  x := random(gencara.Pan_Client.Width)+15;
  y := random(gencara.Pan_Client.Height)+15;
  w := random(50);
  h := random(50);
  with TPanel.Create(Self) do
  try
    Parent := gencara.Pan_Client;
    ParentBackground := false;
    Color := clGreen;
    Align := alClient;
  finally

  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Width := 1280;
  Height :=1024;
end;

end.
