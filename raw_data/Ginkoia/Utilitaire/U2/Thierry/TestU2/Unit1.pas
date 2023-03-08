unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinFoggy, dxSkinGlassOceans,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSharp, dxSkinSilver, dxSkinSpringTime,
  dxSkinStardust, dxSkinSummer2008, dxSkinsDefaultPainters, dxSkinValentine,
  dxSkinXmas2008Blue, dxSkinscxPCPainter, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, AdvPageControl, RzTabs, ElPgCtl,
  ElXPThemedControl, LMDCustomBevelPanel, LMDCustomParentPanel,
  LMDCustomPanelFill, LMDCustomSheetControl, LMDPageControl, LMDControl,
  LMDCustomControl, LMDCustomPanel, cxPC, ToolWin, ActnMan, ActnCtrls, Ribbon,
  RibbonLunaStyleActnCtrls, ComCtrls, ButtonGroup, StdCtrls, ExtCtrls, Buttons,
  ImgList, Menus, cxButtons, LMDBaseControl, LMDBaseGraphicControl,
  LMDBaseGraphicButton, LMDCustomSpeedButton, LMDSpeedButton, LMDButtonBar,
  RzButton, AdvSmoothButton, AdvGlassButton, AdvGlowButton, ActnList,
  cxContainer, cxEdit, cxGroupBox, AdvGroupBox, RzPanel, ElCLabel, ElLabel,
  ElPanel, ElGroupBox, LMDCustomGroupBox, LMDGroupBox;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Panel1: TPanel;
    cxPageControl1: TcxPageControl;
    cxTabSheet1: TcxTabSheet;
    cxTabSheet2: TcxTabSheet;
    ElPageControl1: TElPageControl;
    ElTabSheet1: TElTabSheet;
    ElTabSheet2: TElTabSheet;
    RzPageControl1: TRzPageControl;
    TabSheet3: TRzTabSheet;
    TabSheet4: TRzTabSheet;
    LMDPageControl1: TLMDPageControl;
    LMDTabSheet1: TLMDTabSheet;
    LMDTabSheet2: TLMDTabSheet;
    ImageList1: TImageList;
    GroupBox1: TGroupBox;
    Button1: TButton;
    Button2: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button3: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    GroupBox2: TGroupBox;
    BitBtn4: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn1: TBitBtn;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    ButtonedEdit1: TButtonedEdit;
    GroupBox5: TGroupBox;
    ButtonGroup1: TButtonGroup;
    ButtonGroup2: TButtonGroup;
    GroupBox6: TGroupBox;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    cxButton3: TcxButton;
    cxButton4: TcxButton;
    cxButton5: TcxButton;
    cxButton6: TcxButton;
    cxButton7: TcxButton;
    cxButton8: TcxButton;
    cxButton9: TcxButton;
    cxButton10: TcxButton;
    cxButton11: TcxButton;
    cxButton12: TcxButton;
    GroupBox7: TGroupBox;
    LMDSpeedButton1: TLMDSpeedButton;
    LMDSpeedButton2: TLMDSpeedButton;
    LMDSpeedButton3: TLMDSpeedButton;
    LMDSpeedButton4: TLMDSpeedButton;
    LMDSpeedButton5: TLMDSpeedButton;
    LMDSpeedButton6: TLMDSpeedButton;
    LMDSpeedButton7: TLMDSpeedButton;
    LMDSpeedButton8: TLMDSpeedButton;
    LMDSpeedButton9: TLMDSpeedButton;
    LMDSpeedButton10: TLMDSpeedButton;
    LMDSpeedButton11: TLMDSpeedButton;
    LMDSpeedButton12: TLMDSpeedButton;
    LMDSpeedButton13: TLMDSpeedButton;
    LMDSpeedButton14: TLMDSpeedButton;
    GroupBox8: TGroupBox;
    LMDButtonBar1: TLMDButtonBar;
    GroupBox9: TGroupBox;
    TabSheet5: TRzTabSheet;
    ActionList1: TActionList;
    Action1: TAction;
    RzBitBtn1: TRzBitBtn;
    RzBitBtn2: TRzBitBtn;
    RzBitBtn3: TRzBitBtn;
    RzBitBtn4: TRzBitBtn;
    RzBitBtn5: TRzBitBtn;
    RzBitBtn6: TRzBitBtn;
    RzBitBtn7: TRzBitBtn;
    GroupBox10: TGroupBox;
    GroupBox11: TGroupBox;
    RzMenuButton1: TRzMenuButton;
    RzMenuButton2: TRzMenuButton;
    AdvGlowButton1: TAdvGlowButton;
    GroupBox12: TGroupBox;
    AdvGlassButton1: TAdvGlassButton;
    AdvGlassButton2: TAdvGlassButton;
    AdvSmoothButton1: TAdvSmoothButton;
    AdvSmoothButton2: TAdvSmoothButton;
    AdvSmoothButton3: TAdvSmoothButton;
    TabSheet6: TTabSheet;
    Panel2: TPanel;
    cxGroupBox1: TcxGroupBox;
    cxGroupBox2: TcxGroupBox;
    GroupBox13: TGroupBox;
    GroupBox14: TGroupBox;
    LMDGroupBox1: TLMDGroupBox;
    LMDGroupBox2: TLMDGroupBox;
    ElGroupBox1: TElGroupBox;
    ElLabel1: TElLabel;
    RzGroupBox1: TRzGroupBox;
    RzGroupBox2: TRzGroupBox;
    RzGroupBox3: TRzGroupBox;
    RzGroupBox4: TRzGroupBox;
    RzGroupBox5: TRzGroupBox;
    RzGroupBox6: TRzGroupBox;
    RzGroupBox7: TRzGroupBox;
    cxGroupBox3: TcxGroupBox;
    AdvGroupBox1: TAdvGroupBox;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

end.
