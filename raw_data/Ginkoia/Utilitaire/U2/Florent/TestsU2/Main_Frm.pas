unit Main_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzGroupBar, cxGraphics, RzTray, Menus, ActnPopup, ImgList, Series,
  TeEngine, TeeProcs, Chart, dxGDIPlusClasses, RzButton, ExtCtrls, RzPanel,
  RzTabs, RzBckgnd, StdCtrls, RzLabel, PlatformDefaultStyleActnCtrls,
  LMDPNGImage, ActnList, AdvEdit, AdvSmoothPopup, AdvMenus, AdvSmoothPanel,
  AdvPanel, AdvGlowButton, AdvSmoothButton, RzRadChk, Mask, RzEdit, RzDBEdit,
  AdvSmoothLabel, RzBorder, cxLookAndFeels, cxLookAndFeelPainters, cxButtons,
  cxControls, cxContainer, cxEdit, AdvSpin, DBAdvSp, RzDBSpin, cxTextEdit,
  cxMaskEdit, cxSpinEdit, cxDBEdit, dxTL, dxDBCtrl, dxDBGrid, dxCntner, RzRadGrp,
  dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinFoggy, dxSkinGlassOceans,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSharp, dxSkinSilver, dxSkinSpringTime,
  dxSkinStardust, dxSkinSummer2008, dxSkinsDefaultPainters, dxSkinValentine,
  dxSkinXmas2008Blue, AdvEdBtn, DBAdvEdBtn, RzDBBnEd, RzDBButtonEditRv;

type
  TForm21 = class(TForm)
    Lim_: TImageList;
    PopupActionBar1: TPopupActionBar;
    RzTrayIcon1: TRzTrayIcon;
    test1: TMenuItem;
    pipo1: TMenuItem;
    RzPageControl1: TRzPageControl;
    TabSheet1: TRzTabSheet;
    Pan_Bottom: TRzPanel;
    RzBackground2: TRzBackground;
    RzGroupBar1: TRzGroupBar;
    RzGroup1: TRzGroup;
    RzGroup2: TRzGroup;
    Img_DA: TImage;
    RzGroup3: TRzGroup;
    RzGroup4: TRzGroup;
    Pan_: TRzPanel;
    Img_: TImage;
    TabSheet2: TRzTabSheet;
    Listedestickets1: TMenuItem;
    Listedestickets2: TMenuItem;
    Lim_Icons: TImageList;
    PopupActionBar2: TPopupActionBar;
    Ajouterauxfavoris1: TMenuItem;
    Supprimerdesfavoris1: TMenuItem;
    N1: TMenuItem;
    cxImageList1: TcxImageList;
    Lab_Acces: TRzLabel;
    Lab_Aide: TRzLabel;
    Lab_: TRzLabel;
    RzMenuButton5: TRzMenuButton;
    BBtn_: TRzBitBtn;
    Pan_LeftUp: TRzPanel;
    Pan_CA: TRzPanel;
    Chart_: TChart;
    Series1: TBarSeries;
    Img_Up: TImage;
    Lab_Up: TRzLabel;
    Lab_CA: TRzLabel;
    RzBackground1: TRzBackground;
    Img_Ginko: TImage;
    RzGroupController1: TRzGroupController;
    Img_test: TImage;
    RzGroupBar3: TRzGroupBar;
    RzGroup9: TRzGroup;
    RzGroup10: TRzGroup;
    RzGroup11: TRzGroup;
    RzGroup12: TRzGroup;
    Img_zetsdf: TImage;
    RzGroupController2: TRzGroupController;
    RzGroupController3: TRzGroupController;
    RzGroupController4: TRzGroupController;
    Pan_2: TRzPanel;
    Lab_45: TRzLabel;
    Chart1: TChart;
    Series2: TPieSeries;
    RzPanel1: TRzPanel;
    RzLabel1: TRzLabel;
    RzLabel2: TRzLabel;
    Image1: TImage;
    RzPanel2: TRzPanel;
    RzLabel3: TRzLabel;
    RzLabel4: TRzLabel;
    Image2: TImage;
    ActionList1: TActionList;
    Action1: TAction;
    AdvEdit1: TAdvEdit;
    AdvPopupMenu1: TAdvPopupMenu;
    AdvSmoothPopup1: TAdvSmoothPopup;
    Panel1: TPanel;
    AdvSmoothPanel1: TAdvSmoothPanel;
    AdvPanel1: TAdvPanel;
    AdvGlowButton1: TAdvGlowButton;
    AdvPanelGroup1: TAdvPanelGroup;
    Label2: TLabel;
    Label3: TLabel;
    RadioButton1: TRadioButton;
    AdvSmoothButton1: TAdvSmoothButton;
    TabSheet5: TRzTabSheet;
    TabSheet6: TRzTabSheet;
    TabSheet7: TRzTabSheet;
    TabSheet8: TRzTabSheet;
    RzPageControl2: TRzPageControl;
    TabSheet4: TRzTabSheet;
    RzPanel3: TRzPanel;
    TabSheet3: TRzTabSheet;
    TabSheet9: TRzTabSheet;
    RzTabSheet1: TRzTabSheet;
    RzPageControl3: TRzPageControl;
    RzTabSheet2: TRzTabSheet;
    RzPanel4: TRzPanel;
    RzTabSheet3: TRzTabSheet;
    RzTabSheet4: TRzTabSheet;
    AdvSmoothPanel2: TAdvSmoothPanel;
    RzLabel5: TRzLabel;
    RzDBEdit1: TRzDBEdit;
    RzCheckBox2: TRzCheckBox;
    RzCheckBox1: TRzCheckBox;
    RzCheckBox3: TRzCheckBox;
    AdvSmoothLabel1: TAdvSmoothLabel;
    AdvSmoothLabel2: TAdvSmoothLabel;
    AdvPanelGroup2: TAdvPanelGroup;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    RzBorder1: TRzBorder;
    Pan_Group: TRzPanel;
    RzMenuButton2: TRzMenuButton;
    RzMenuButton1: TRzMenuButton;
    RzMenuButton3: TRzMenuButton;
    RzMenuButton4: TRzMenuButton;
    AdvSmoothPopup2: TAdvSmoothPopup;
    cxButton1: TcxButton;
    RzLabel6: TRzLabel;
    RzDBEdit2: TRzDBEdit;
    RzLabel7: TRzLabel;
    RzDBEdit3: TRzDBEdit;
    RzLabel8: TRzLabel;
    RzDBEdit4: TRzDBEdit;
    RzBorder2: TRzBorder;
    RzBitBtn1: TRzBitBtn;
    cxDBSpinEdit1: TcxDBSpinEdit;
    RzDBSpinEdit1: TRzDBSpinEdit;
    AdvSpinEdit1: TAdvSpinEdit;
    RzButton1: TRzButton;
    RzPanel5: TRzPanel;
    RzPanel6: TRzPanel;
    AdvSmoothLabel3: TAdvSmoothLabel;
    RzBitBtn2: TRzBitBtn;
    RzBitBtn3: TRzBitBtn;
    dxDBGrid1: TdxDBGrid;
    dxDBGrid1Column1: TdxDBGridColumn;
    dxDBGrid1Column2: TdxDBGridColumn;
    dxDBGrid1Column3: TdxDBGridColumn;
    RzRadioGroup1: TRzRadioGroup;
    RzLabel9: TRzLabel;
    RzDBEdit5: TRzDBEdit;
    RzBitBtn4: TRzBitBtn;
    RzPanel7: TRzPanel;
    RzRadioGroup2: TRzRadioGroup;
    RzBitBtn5: TRzBitBtn;
    RzDBEdit6: TRzDBEdit;
    RzLabel10: TRzLabel;
    RzDBButtonEditRv1: TRzDBButtonEditRv;
    RzDBButtonEditRv4: TRzDBButtonEditRv;
    RzDBButtonEditRv6: TRzDBButtonEditRv;
    RzDBButtonEditRv2: TRzDBButtonEditRv;
    DBAdvEditBtn1: TDBAdvEditBtn;
    procedure BBtn_Click(Sender: TObject);
    procedure AdvGlowButton1Click(Sender: TObject);
    procedure cxButton1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form21: TForm21;

implementation

{$R *.dfm}

procedure TForm21.AdvGlowButton1Click(Sender: TObject);
begin
  AdvSmoothPopup1.PopupAtControl(TWinControl(Sender),pdBottomCenter);

end;

procedure TForm21.BBtn_Click(Sender: TObject);
begin
  AdvSmoothPopup1.PopupAtControl(TWinControl(Sender),pdBottomCenter);
end;

procedure TForm21.cxButton1Click(Sender: TObject);
begin
  AdvSmoothPopup2.PopupAtControl(TWinControl(Sender), pdRightCenter);
end;

end.
