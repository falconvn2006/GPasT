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
  AdvSmoothExpanderGroup, cxGroupBox, AdvSmoothPanel, RzPanel, StdCtrls, RzLabel,
  AdvEdit, DBAdvEd, RzButton, RzRadChk, RzDBChk, AdvGlowButton, cxCustomData,
  cxStyles, cxTL, cxTLdxBarBuiltInMenu, Mask, RzEdit, RzDBEdit, RzDBBnEd,
  RzDBButtonEditRv, cxInplaceContainer, cxTLData, cxDBTL, AdvProgressBar,
  AdvProgr, AdvCircularProgress, AdvSmoothProgressBar, cxProgressBar, RzTabs,
  IdBaseComponent, IdZLibCompressorBase, IdCompressorZLib, Menus, cxButtons,
  AdvMenus, AdvAppStyler, AdvSplitter, AdvToolBar, Buttons, AdvSmoothPopup,
  AdvStickyPopupMenu, PlatformDefaultStyleActnCtrls, ActnPopup,
  RibbonSilverStyleActnCtrls, XPStyleActnCtrls, RibbonObsidianStyleActnCtrls,
  AdvScrollBox, propscrl, AdvSmoothStepControl, dxCntner, dxTL, dxDBCtrl,
  dxDBGrid, dxDBGridHP, DB, IBODataset, IB_Components, Boxes, PanBtnDbgHP,
  wwdbedit, Wwdotdot, Wwdbcomb, wwDBComboBoxRv, wwDialog, wwidlg,
  wwLookupDialogRv, Grids, Wwdbigrd, Wwdbgrid, DBGrids, RzPopups, PlannerCal,
  Calendar, AdvSmoothCalendar, AdvSmoothEdit, AdvSmoothEditButton,
  AdvSmoothDatePicker, DateUtils, dxDBTLCl, dxGrClms, TeeDBEdit, TeeDBCrossTab,
  TeEngine, TeeFunci, TeeData, TeeURL, Series, TeeProcs, Chart, DBChart,
  IB_Access, dxDBGridRv, TeeXML, ODCalend, ODDBCal, GinPanel, ArrowCha,
  TeeOpenGL, TeeAnimations, TeePieTool, TeeGDIPlus, TeeAntiAlias, CurvFitt,
  TeeEdit, TeeSeriesStats, LMDPNGImage, AdvOfficeHint, cxHint;

type
  TForm1 = class(TForm)
    AdvOfficePagerOfficeStyler_Principale: TAdvOfficePagerOfficeStyler;
    ImageList1: TImageList;
    ImageList2: TImageList;
    AOP_Generale: TAdvOfficePager;
    AOPageAccueil: TAdvOfficePage;
    AOPageArticle: TAdvOfficePage;
    AOPageStat: TAdvOfficePage;
    AOPageRecherche: TAdvOfficePage;
    AOPageClient: TAdvOfficePage;
    AOPageParam: TAdvOfficePage;
    AdvOfficePagerOfficeStyler_Secondaire: TAdvOfficePagerOfficeStyler;
    RzPanel4: TRzPanel;
    AdvGlowButton4: TAdvGlowButton;
    AdvGlowButton5: TAdvGlowButton;
    ImageList3: TImageList;
    Button1: TButton;
    Button2: TButton;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    RzPanel5: TRzPanel;
    Button3: TButton;
    Button4: TButton;
    cxButton3: TcxButton;
    cxButton4: TcxButton;
    Pan_haut2: TRzPanel;
    RzPanel6: TRzPanel;
    AdvGlowButton13: TAdvGlowButton;
    AdvGlowButton14: TAdvGlowButton;
    AdvGlowButton15: TAdvGlowButton;
    AdvGlowButton16: TAdvGlowButton;
    AdvGlowButton7: TAdvGlowButton;
    AdvGlowButton6: TAdvGlowButton;
    Pan_1: TRzPanel;
    RzPageControl3: TRzPageControl;
    RzTabSheet10: TRzTabSheet;
    RzTabSheet11: TRzTabSheet;
    RzTabSheet12: TRzTabSheet;
    RzTabSheet13: TRzTabSheet;
    RzTabSheet14: TRzTabSheet;
    RzTabSheet15: TRzTabSheet;
    RzTabSheet16: TRzTabSheet;
    RzTabSheet17: TRzTabSheet;
    RzTabSheet18: TRzTabSheet;
    RzPageControl4: TRzPageControl;
    RzTabSheet19: TRzTabSheet;
    RzTabSheet20: TRzTabSheet;
    RzTabSheet21: TRzTabSheet;
    RzTabSheet22: TRzTabSheet;
    RzTabSheet23: TRzTabSheet;
    RzTabSheet24: TRzTabSheet;
    RzTabSheet25: TRzTabSheet;
    RzTabSheet26: TRzTabSheet;
    RzTabSheet27: TRzTabSheet;
    AdvOfficePager5: TAdvOfficePager;
    AdvOfficePage33: TAdvOfficePage;
    Lab_18: TLabel;
    AdvOfficePage34: TAdvOfficePage;
    AdvOfficePage35: TAdvOfficePage;
    AdvOfficePage36: TAdvOfficePage;
    AdvOfficePage37: TAdvOfficePage;
    AdvOfficePage38: TAdvOfficePage;
    AdvOfficePage39: TAdvOfficePage;
    AdvOfficePage40: TAdvOfficePage;
    AdvOfficePage41: TAdvOfficePage;
    Shape7: TShape;
    Shape8: TShape;
    Img_1: TImage;
    Pan_principale: TRzPanel;
    AdvScrollBox1: TAdvScrollBox;
    Pan_Caract: TRzPanel;
    Lab_1: TRzLabel;
    Lab_2: TRzLabel;
    Lab_3: TRzLabel;
    Shape1: TShape;
    Shape2: TShape;
    Lab_4: TRzLabel;
    Lab_5: TRzLabel;
    Lab_6: TRzLabel;
    Lab_7: TRzLabel;
    Lab_8: TRzLabel;
    Lab_9: TRzLabel;
    Lab_10: TRzLabel;
    Lab_11: TRzLabel;
    Lab_12: TRzLabel;
    Lab_13: TRzLabel;
    Lab_14: TRzLabel;
    Pan_haut: TRzPanel;
    Lab_15: TRzLabel;
    Lab_16: TRzLabel;
    DBAdvEdit1: TDBAdvEdit;
    DBAdvEdit2: TDBAdvEdit;
    DBAdvEdit3: TDBAdvEdit;
    DBAdvEdit7: TDBAdvEdit;
    DBAdvEdit8: TDBAdvEdit;
    DBAdvEdit9: TDBAdvEdit;
    RzDBCheckBox1: TRzDBCheckBox;
    RzDBCheckBox2: TRzDBCheckBox;
    RzDBCheckBox3: TRzDBCheckBox;
    DBAdvEdit10: TDBAdvEdit;
    DBAdvEdit6: TDBAdvEdit;
    DBAdvEdit4: TDBAdvEdit;
    AdvGlowButton3: TAdvGlowButton;
    AdvGlowButton1: TAdvGlowButton;
    AdvGlowButton2: TAdvGlowButton;
    AdvOfficePager3: TAdvOfficePager;
    AdvOfficePage10: TAdvOfficePage;
    AdvOfficePage11: TAdvOfficePage;
    RzPageControl1: TRzPageControl;
    RzTabSheet1: TRzTabSheet;
    RzTabSheet2: TRzTabSheet;
    Pan_a1: TRzPanel;
    RzLabel1: TRzLabel;
    DBAdvEdit20: TDBAdvEdit;
    AdvGlowButton10: TAdvGlowButton;
    RzPanel1: TRzPanel;
    Shape9: TShape;
    Shape10: TShape;
    AdvGlowButton25: TAdvGlowButton;
    AdvGlowButton26: TAdvGlowButton;
    AdvGlowButton27: TAdvGlowButton;
    AdvGlowButton28: TAdvGlowButton;
    AdvGlowButton29: TAdvGlowButton;
    AdvGlowButton30: TAdvGlowButton;
    AdvOfficePager4: TAdvOfficePager;
    AdvOfficePage24: TAdvOfficePage;
    Lab_17: TLabel;
    AdvOfficePage25: TAdvOfficePage;
    AdvOfficePage26: TAdvOfficePage;
    AdvOfficePage27: TAdvOfficePage;
    AdvOfficePage28: TAdvOfficePage;
    AdvOfficePage29: TAdvOfficePage;
    AdvOfficePage30: TAdvOfficePage;
    AdvOfficePage31: TAdvOfficePage;
    AdvOfficePage32: TAdvOfficePage;
    AdvOfficePager41: TAdvOfficePage;
    AdvOfficePager42: TAdvOfficePage;
    AdvOfficePager43: TAdvOfficePage;
    AdvOfficePager31: TAdvOfficePage;
    AdvOfficePager32: TAdvOfficePage;
    AdvOfficePager33: TAdvOfficePage;
    AOP_Ariane: TAdvOfficePager;
    Tab_LstArticle: TAdvOfficePage;
    Tab_Article: TAdvOfficePage;
    AdvOfficePagerOfficeStyler_Ariane: TAdvOfficePagerOfficeStyler;
    AdvScrollBox2: TAdvScrollBox;
    RzPanel2: TRzPanel;
    RzLabel2: TRzLabel;
    RzLabel3: TRzLabel;
    RzLabel4: TRzLabel;
    Shape11: TShape;
    Shape12: TShape;
    RzLabel5: TRzLabel;
    RzLabel6: TRzLabel;
    RzLabel7: TRzLabel;
    RzLabel8: TRzLabel;
    RzLabel9: TRzLabel;
    RzLabel10: TRzLabel;
    RzLabel11: TRzLabel;
    RzLabel12: TRzLabel;
    RzLabel13: TRzLabel;
    RzLabel14: TRzLabel;
    RzLabel15: TRzLabel;
    RzPanel3: TRzPanel;
    RzLabel16: TRzLabel;
    RzLabel17: TRzLabel;
    DBAdvEdit21: TDBAdvEdit;
    DBAdvEdit22: TDBAdvEdit;
    DBAdvEdit23: TDBAdvEdit;
    DBAdvEdit24: TDBAdvEdit;
    DBAdvEdit25: TDBAdvEdit;
    DBAdvEdit26: TDBAdvEdit;
    RzDBCheckBox7: TRzDBCheckBox;
    RzDBCheckBox8: TRzDBCheckBox;
    RzDBCheckBox9: TRzDBCheckBox;
    DBAdvEdit27: TDBAdvEdit;
    DBAdvEdit28: TDBAdvEdit;
    DBAdvEdit29: TDBAdvEdit;
    AdvGlowButton31: TAdvGlowButton;
    AdvGlowButton32: TAdvGlowButton;
    AdvGlowButton33: TAdvGlowButton;
    AdvOfficePager6: TAdvOfficePager;
    Tab_Stock: TAdvOfficePage;
    Tab_TableauBord: TAdvOfficePage;
    AdvScrollBox3: TAdvScrollBox;
    Pan_fondListe: TRzPanel;
    DBG_LstArticle: TdxDBGridHP;
    Que_Article: TIBOQuery;
    Que_ArticleARF_CHRONO: TStringField;
    Que_ArticleART_NOM: TStringField;
    Que_ArticleMRK_NOM: TStringField;
    Que_ArticleRAY_NOM: TStringField;
    Que_ArticleFAM_NOM: TStringField;
    Que_ArticleSSF_NOM: TStringField;
    Ds_Article: TDataSource;
    Que_ArticleART_ID: TIntegerField;
    DBG_LstArticleART_ID: TdxDBGridMaskColumn;
    DBG_LstArticleARF_CHRONO: TdxDBGridMaskColumn;
    DBG_LstArticleART_NOM: TdxDBGridMaskColumn;
    DBG_LstArticleMRK_NOM: TdxDBGridMaskColumn;
    DBG_LstArticleRAY_NOM: TdxDBGridMaskColumn;
    DBG_LstArticleFAM_NOM: TdxDBGridMaskColumn;
    DBG_LstArticleSSF_NOM: TdxDBGridMaskColumn;
    Pan_cmz: TPanelDbg;
    DBG_test5: TdxDBGridHP;
    DBG_test5ART_ID: TdxDBGridMaskColumn;
    DBG_test5ARF_CHRONO: TdxDBGridMaskColumn;
    DBG_test5ART_NOM: TdxDBGridMaskColumn;
    DBG_test5MRK_NOM: TdxDBGridMaskColumn;
    DBG_test5RAY_NOM: TdxDBGridMaskColumn;
    DBG_test5FAM_NOM: TdxDBGridMaskColumn;
    DBG_test5SSF_NOM: TdxDBGridMaskColumn;
    DBG_test9: TdxDBGridHP;
    dxDBGridMaskColumn8: TdxDBGridMaskColumn;
    dxDBGridMaskColumn9: TdxDBGridMaskColumn;
    dxDBGridMaskColumn10: TdxDBGridMaskColumn;
    dxDBGridMaskColumn11: TdxDBGridMaskColumn;
    dxDBGridMaskColumn12: TdxDBGridMaskColumn;
    dxDBGridMaskColumn13: TdxDBGridMaskColumn;
    dxDBGridMaskColumn14: TdxDBGridMaskColumn;
    LK_Magasin: TwwLookupDialogRV;
    Chp_test2: TRzDBButtonEditRv;
    Tim_progress: TTimer;
    AOPageCalendrier: TAdvOfficePage;
    Pan_4: TRzPanel;
    Lab_search: TRzLabel;
    AdvGlowButton22: TAdvGlowButton;
    DBAdvEdit19: TDBAdvEdit;
    AdvGlowButton23: TAdvGlowButton;
    Pan_5: TRzPanel;
    Lab_suivi: TRzLabel;
    AdvProgress1: TAdvProgress;
    ProgressBar1: TProgressBar;
    AdvSmoothProgressBar1: TAdvSmoothProgressBar;
    AdvSmoothProgressBar2: TAdvSmoothProgressBar;
    Pan_3: TRzPanel;
    Shape5: TShape;
    Shape6: TShape;
    AdvGlowButton12: TAdvGlowButton;
    AdvGlowButton17: TAdvGlowButton;
    AdvGlowButton18: TAdvGlowButton;
    AdvGlowButton19: TAdvGlowButton;
    AdvGlowButton20: TAdvGlowButton;
    AdvGlowButton21: TAdvGlowButton;
    RzPanel7: TRzPanel;
    Shape3: TShape;
    Shape4: TShape;
    AdvGlowButton8: TAdvGlowButton;
    AdvGlowButton9: TAdvGlowButton;
    AdvGlowButton11: TAdvGlowButton;
    AdvGlowButton24: TAdvGlowButton;
    AdvGlowButton34: TAdvGlowButton;
    AdvGlowButton35: TAdvGlowButton;
    RzPanel8: TRzPanel;
    RzLabel18: TRzLabel;
    AdvGlowButton36: TAdvGlowButton;
    DBAdvEdit5: TDBAdvEdit;
    AdvGlowButton37: TAdvGlowButton;
    RzPanel9: TRzPanel;
    RzPanel10: TRzPanel;
    AdvScrollBox4: TAdvScrollBox;
    RzPanel11: TRzPanel;
    RzPanel12: TRzPanel;
    RzLabel34: TRzLabel;
    RzLabel35: TRzLabel;
    AdvSmoothCalendar1: TAdvSmoothCalendar;
    MonthCalendar1: TMonthCalendar;
    AdvSmoothDatePicker1: TAdvSmoothDatePicker;
    Lab_test: TLabel;
    AOPageGraphique: TAdvOfficePage;
    Que_graph: TIBOQuery;
    RzPanel13: TRzPanel;
    Shape13: TShape;
    Shape14: TShape;
    AdvGlowButton38: TAdvGlowButton;
    AdvGlowButton39: TAdvGlowButton;
    AdvGlowButton40: TAdvGlowButton;
    AdvGlowButton41: TAdvGlowButton;
    AdvGlowButton42: TAdvGlowButton;
    AdvGlowButton43: TAdvGlowButton;
    RzPanel14: TRzPanel;
    RzLabel19: TRzLabel;
    AdvGlowButton44: TAdvGlowButton;
    DBAdvEdit11: TDBAdvEdit;
    AdvGlowButton45: TAdvGlowButton;
    RzPanel15: TRzPanel;
    RzPanel16: TRzPanel;
    AdvScrollBox5: TAdvScrollBox;
    RzPanel17: TRzPanel;
    RzPanel18: TRzPanel;
    RzLabel37: TRzLabel;
    AdvOfficePager2: TAdvOfficePager;
    AdvOfficePage4: TAdvOfficePage;
    AdvOfficePage5: TAdvOfficePage;
    ASCAL_Periode: TAdvSmoothCalendar;
    Que_Magasin: TIBOQuery;
    Que_MagasinMAG_ID: TIntegerField;
    Que_MagasinMAG_ENSEIGNE: TStringField;
    Ds_Magasin: TDataSource;
    AdvGlowButton46: TAdvGlowButton;
    Ds_Graph: TDataSource;
    DBG_Graph: TdxDBGridHP;
    Que_graphTKE_SESID: TIntegerField;
    TeeXMLSource1: TTeeXMLSource;
    Que_graphTOTAL: TIBOFloatField;
    DBG_GraphTKE_SESID: TdxDBGridMaskColumn;
    DBG_GraphTOTAL: TdxDBGridMaskColumn;
    DBChart_Graph: TDBChart;
    Series1: TLineSeries;
    Series2: TAreaSeries;
    IBODatabase1: TIBODatabase;
    Chp_Magasin: TRzDBButtonEditRv;
    RzLabel20: TRzLabel;
    Dbg_GridRV: TdxDBGridRv;
    Dbg_GridRVART_ID: TdxDBGridMaskColumn;
    Dbg_GridRVARF_CHRONO: TdxDBGridMaskColumn;
    Dbg_GridRVART_NOM: TdxDBGridMaskColumn;
    Dbg_GridRVMRK_NOM: TdxDBGridMaskColumn;
    Dbg_GridRVRAY_NOM: TdxDBGridMaskColumn;
    Dbg_GridRVFAM_NOM: TdxDBGridMaskColumn;
    Dbg_GridRVSSF_NOM: TdxDBGridMaskColumn;
    dxDBGridRv1: TdxDBGridRv;
    dxDBGridMaskColumn15: TdxDBGridMaskColumn;
    dxDBGridMaskColumn16: TdxDBGridMaskColumn;
    dxDBGridMaskColumn17: TdxDBGridMaskColumn;
    dxDBGridMaskColumn18: TdxDBGridMaskColumn;
    dxDBGridMaskColumn19: TdxDBGridMaskColumn;
    dxDBGridMaskColumn20: TdxDBGridMaskColumn;
    dxDBGridMaskColumn21: TdxDBGridMaskColumn;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Pan_cnt: TPanel;
    DBG_test3: TdxDBGridHP;
    dxDBGridMaskColumn1: TdxDBGridMaskColumn;
    dxDBGridMaskColumn2: TdxDBGridMaskColumn;
    dxDBGridMaskColumn3: TdxDBGridMaskColumn;
    dxDBGridMaskColumn4: TdxDBGridMaskColumn;
    dxDBGridMaskColumn5: TdxDBGridMaskColumn;
    dxDBGridMaskColumn6: TdxDBGridMaskColumn;
    dxDBGridMaskColumn7: TdxDBGridMaskColumn;
    Pan_tst10: TPanelDbg;
    OD_tst: TODDBCalendar;
    AdvGlowButton47: TAdvGlowButton;
    AdvGlowButton48: TAdvGlowButton;
    AdvGlowButton49: TAdvGlowButton;
    LK_test: TwwLookupDialogRV;
    DBAdvEdit12: TDBAdvEdit;
    DBAdvEdit13: TDBAdvEdit;
    DBAdvEdit14: TDBAdvEdit;
    RzPanel19: TRzPanel;
    DBAdvEdit15: TDBAdvEdit;
    GinPanel1: TGinPanel;
    DBAdvEdit16: TDBAdvEdit;
    Edit1: TEdit;
    Edit2: TEdit;
    AOPage_Vignette: TAdvOfficePage;
    Pan_Vignette1: TRzPanel;
    Chart_Fleche: TChart;
    Series4: TArrowSeries;
    AdvGlowButton50: TAdvGlowButton;
    AdvGlowButton51: TAdvGlowButton;
    AdvGlowButton52: TAdvGlowButton;
    TeeGDIPlus1: TTeeGDIPlus;
    TeeGDIPlus2: TTeeGDIPlus;
    TeeGDIPlus3: TTeeGDIPlus;
    Pan_fond1: TRzPanel;
    Chart_Vignette1: TChart;
    Series3: TPieSeries;
    Pan_fond2: TRzPanel;
    Pan_fond3: TRzPanel;
    Chart_Pieligtning: TChart;
    Series6: TPieSeries;
    Chart_Ligth2: TChart;
    PieSeries1: TPieSeries;
    Pan_fond4: TRzPanel;
    AOPageGraphique2: TAdvOfficePage;
    Pan_fond: TRzPanel;
    Chart_test: TChart;
    PieSeries3: TPieSeries;
    TeeGDIPlusTest: TTeeGDIPlus;
    Pan_fond5: TRzPanel;
    Chart_Plat: TChart;
    Series5: TPieSeries;
    Chart_plat2: TChart;
    PieSeries2: TPieSeries;
    Pan_fond6: TRzPanel;
    ChartEditor1: TChartEditor;
    Chart_Bar1: TChart;
    Series7: TBarSeries;
    TeeGDIPlusBar1: TTeeGDIPlus;
    AdvGlowButton53: TAdvGlowButton;
    Img_test: TImage;
    Img_test2: TImage;
    cxHintStyleController1: TcxHintStyleController;
    procedure FormCreate(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure AdvGlowButton4Click(Sender: TObject);
    procedure Dbg_testDrawDataCell(Sender: TObject; const Rect: TRect;
      Field: TField; State: TGridDrawState);
    procedure Dbg_testDrawGroupHeaderCell(Sender: TObject; Canvas: TCanvas;
      GroupHeaderName: string; Rect: TRect; var DefaultDrawing: Boolean);
    procedure AdvGlowButton23Click(Sender: TObject);
    procedure Tim_progressTimer(Sender: TObject);
    procedure AdvSmoothCalendar1SelectDate(Sender: TObject;
      Mode: TAdvSmoothCalendarDateMode; Date: TDateTime);
    procedure ASCAL_PeriodeSelectDate(Sender: TObject;
      Mode: TAdvSmoothCalendarDateMode; Date: TDateTime);
    procedure AdvGlowButton46Click(Sender: TObject);
    procedure DBG_GraphChangeNode(Sender: TObject; OldNode,
      Node: TdxTreeListNode);
    procedure AdvGlowButton15Click(Sender: TObject);
    procedure AdvGlowButton13Click(Sender: TObject);
    procedure Ds_GraphDataChange(Sender: TObject; Field: TField);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure AdvGlowButton34Click(Sender: TObject);
    procedure AdvGlowButton41Click(Sender: TObject);
    procedure AdvGlowButton42Click(Sender: TObject);
  private
    { Déclarations privées }
    dtSelectDateDeb : TDateTime;
    dtSelectDateFin : TDateTime;
    dtPeriodeDateDeb : TDateTime;
    dtPeriodeDateFin : TDateTime;


    procedure DrawButton(Sender: TObject; Canvas: TCanvas; Rect: TRect; State: TGlowButtonState);
    procedure AdvOfficePager_OnChange(Sender: TObject);
    procedure ScrollBox1VScroll(Sender: TObject);
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

uses Unit2, Unit3, generics.Collections, UCGODisableForm;

{$R *.dfm}

procedure TForm1.ScrollBox1VScroll(Sender: TObject);
var
  i   : integer;
begin
  //Procedure de raffraichissement des composant lors de scroll
  for I := 0 to TAdvScrollBox(sender).ControlCount-1 do
  begin
    if TAdvScrollBox(sender).Controls[I].InheritsFrom(TadvOfficePager) then
    begin
      TadvOfficePager(TAdvScrollBox(sender).Controls[I]).Repaint;
    end;
  end;
end;

procedure TForm1.Tim_progressTimer(Sender: TObject);
begin
 if AdvProgress1.Position>=100 then
 begin
   AdvProgress1.Position  := 0;
 end;
 AdvProgress1.Position  := AdvProgress1.Position+1;

 if ProgressBar1.Position>=100 then
 begin
   ProgressBar1.Position  := 0;
 end;
 ProgressBar1.Position  := ProgressBar1.Position+1;

 if AdvSmoothProgressBar1.Position>=100 then
 begin
   AdvSmoothProgressBar1.Position  := 0;
 end;
 AdvSmoothProgressBar1.Position  := AdvSmoothProgressBar1.Position+1;

 if AdvSmoothProgressBar2.Position>=100 then
 begin
   AdvSmoothProgressBar2.Position  := 0;
 end;
 AdvSmoothProgressBar2.Position  := AdvSmoothProgressBar2.Position+1;

  If (GetAsyncKeyState(VK_RBUTTON)And $8000)<>0 Then
    Lab_test.Caption := 'Enfoncé'
  Else
    Lab_test.Caption := 'Relâché';

end;

procedure TForm1.DBG_GraphChangeNode(Sender: TObject; OldNode,
  Node: TdxTreeListNode);
begin
  DBG_Graph.Repaint;
end;

procedure TForm1.Dbg_testDrawDataCell(Sender: TObject; const Rect: TRect;
  Field: TField; State: TGridDrawState);
begin
  Canvas.Brush.Style  := bsSolid;
  Canvas.Brush.Color  := clRed;
  Canvas.Pen.Style    := psSolid;
  Canvas.Pen.Color    := clRed;
  Canvas.Rectangle(Rect.Left,Rect.Top,Rect.Right,Rect.Bottom);
end;

procedure TForm1.Dbg_testDrawGroupHeaderCell(Sender: TObject; Canvas: TCanvas;
  GroupHeaderName: string; Rect: TRect; var DefaultDrawing: Boolean);
begin
  Canvas.Brush.Style  := bsSolid;
  Canvas.Brush.Color  := clRed;
  Canvas.Pen.Style    := psSolid;
  Canvas.Pen.Color    := clRed;
  Canvas.Rectangle(Rect.Left,Rect.Top,Rect.Right,Rect.Bottom);
end;

procedure TForm1.DrawButton(Sender: TObject; Canvas: TCanvas;
  Rect: TRect; State: TGlowButtonState);
begin
  //Procedure de gestion de la couleur de Font des AdvGlowButton qui reste enfoncé
  if TAdvGlowButton(Sender).Down then
    TAdvGlowButton(Sender).Font.Color := ClWhite
  else
    TAdvGlowButton(Sender).Font.Color := $004E4134;
end;

procedure TForm1.Ds_GraphDataChange(Sender: TObject; Field: TField);
begin

end;

//procedure TForm1.AdvOfficePager4Change(Sender: TObject);
procedure TForm1.AdvGlowButton13Click(Sender: TObject);
var
  oo: TList;
begin
end;

procedure TForm1.AdvGlowButton15Click(Sender: TObject);
begin
  CustomShowModal(Form2,FdCurrentWindow,DmDarkForm,35);
end;

procedure TForm1.AdvGlowButton23Click(Sender: TObject);
begin
  //Form1.Enabled := False;
  Form3.Show;
end;

procedure TForm1.AdvGlowButton34Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.AdvGlowButton41Click(Sender: TObject);
begin
  {Chart_OpenGL.View3DOptions.Elevation   := 40;
  Chart_OpenGL.View3DOptions.FontZoom    := 80;
  Chart_OpenGL.View3DOptions.HorizOffset := -14;
  Chart_OpenGL.View3DOptions.OrthoAngle  := 45;
  Chart_OpenGL.View3DOptions.Orthogonal  := True;
  Chart_OpenGL.View3DOptions.Perspective := 0;
  Chart_OpenGL.View3DOptions.Rotation    := 0;
  Chart_OpenGL.View3DOptions.Tilt        := 0;
  Chart_OpenGL.View3DOptions.VertOffset  := 0;
  Chart_OpenGL.View3DOptions.Zoom        := 120;}

  Chart_Pieligtning.View3DOptions.Elevation := 300;
  Chart_Pieligtning.View3DOptions.Zoom      :=166;
  Chart_Pieligtning.Refresh;

  Chart_Ligth2.View3DOptions.Elevation := 300;
  Chart_Ligth2.View3DOptions.Zoom      :=166;
  Chart_Ligth2.Refresh;

end;

procedure TForm1.AdvGlowButton42Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.AdvGlowButton46Click(Sender: TObject);
begin
  Que_Graph.Close;
  //Que_Graph.ParamByName('LISTEMAG').AsString  := '|'+Que_Magasin.FieldByName('MAG_ID').AsString+'|';
  Que_Graph.ParamByName('DDEB').AsDateTime    := dtPeriodeDateDeb;
  Que_Graph.ParamByName('DFIN').AsDateTime    := dtPeriodeDateFin;
  Que_Graph.Open;
end;

procedure TForm1.AdvGlowButton4Click(Sender: TObject);
begin
  CustomShowModal(Form2,FdCurrentWindow,DmDarkForm,35);
end;

procedure TForm1.AdvOfficePager_OnChange(Sender: TObject);
Var
  I : Integer;
begin
  //Trucage graphique pour supprimer le trait blanc en haut des Tab des AdvOfficePager
  for I := 0 to TAdvOfficePager(sender).AdvPageCount-1 do
  begin
    if TAdvOfficePager(sender).ActivePage = TAdvOfficePager(sender).AdvPages[I] then
    begin
      TAdvOfficePager(sender).AdvPages[I].Progress.Visible  := False;
    end
    else begin
      TAdvOfficePager(sender).AdvPages[I].Progress.Visible         := True;
    end;
  end;
end;

procedure TForm1.AdvSmoothCalendar1SelectDate(Sender: TObject;
  Mode: TAdvSmoothCalendarDateMode; Date: TDateTime);
begin
  if (GetAsyncKeyState(VK_LBUTTON)And $8000)<>0 then
  begin
    if (dtSelectDateFin<=0) or ((dtSelectDateFin>=0) and (Date>=dtSelectDateFin)) then
    begin
      AdvSmoothCalendar1.StartDate  := Date;
      AdvSmoothCalendar1.EndDate    := Date;
    end
    else begin
      AdvSmoothCalendar1.StartDate  := Date;
      AdvSmoothCalendar1.EndDate    := dtSelectDateFin;
    end;
    dtSelectDateDeb               := Date;
  end;

  if (GetAsyncKeyState(VK_RBUTTON)And $8000)<>0 then
  begin
    if (dtSelectDateDeb<=0) or ((dtSelectDateDeb>=0) and (Date<=dtSelectDateDeb)) then
    begin
      AdvSmoothCalendar1.StartDate  := Date;
      AdvSmoothCalendar1.EndDate    := Date;
    end
    else begin
      AdvSmoothCalendar1.StartDate  := dtSelectDateDeb;
      AdvSmoothCalendar1.EndDate    := Date;
    end;
    dtSelectDateFin               := Date;
  end;

end;

procedure TForm1.ASCAL_PeriodeSelectDate(Sender: TObject;
  Mode: TAdvSmoothCalendarDateMode; Date: TDateTime);
begin
  if (GetAsyncKeyState(VK_LBUTTON)And $8000)<>0 then
  begin
    if (dtPeriodeDateFin<=0) or ((dtPeriodeDateFin>=0) and (Date>=dtPeriodeDateFin)) then
    begin
      ASCAL_Periode.StartDate  := Date;
      ASCAL_Periode.EndDate    := Date;
    end
    else begin
      ASCAL_Periode.StartDate  := Date;
      ASCAL_Periode.EndDate    := dtPeriodeDateFin;
    end;
    dtPeriodeDateDeb               := Date;
  end;

  if (GetAsyncKeyState(VK_RBUTTON)And $8000)<>0 then
  begin
    if (dtPeriodeDateDeb<=0) or ((dtPeriodeDateDeb>=0) and (Date<=dtPeriodeDateDeb)) then
    begin
      ASCAL_Periode.StartDate  := Date;
      ASCAL_Periode.EndDate    := Date;
    end
    else begin
      ASCAL_Periode.StartDate  := dtPeriodeDateDeb;
      ASCAL_Periode.EndDate    := Date;
    end;
    dtPeriodeDateFin               := Date;
  end;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  if egoRowSelect in DBG_Test3.Options then
    DBG_Test3.Options := DBG_Test3.Options - [egoRowSelect]
  else
    DBG_Test3.Options := DBG_Test3.Options + [egoRowSelect];
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
  if egoRowSelect in Dbg_GridRV.Options then
    Dbg_GridRV.Options := Dbg_GridRV.Options - [egoRowSelect]
  else
    Dbg_GridRV.Options := Dbg_GridRV.Options + [egoRowSelect];
end;

procedure TForm1.FormCreate(Sender: TObject);
Var
  I,J   : Integer;
begin
  //Initialise la taille de l'écran
  Width := 1280;
  Height :=800;

  //Initialisation des variables de sélection de plage de date
  dtSelectDateDeb := 0;
  dtSelectDateFin := 0;
  dtPeriodeDateDeb := 0;
  dtPeriodeDateFin := 0;

  //Ouverture de la query
  Que_Article.Open;
  Que_Article.First;
  Que_Magasin.Open;

  //Déploie l'ensemble de la grille
  DBG_LstArticle.ExpandLevel;

  //Replace le curseur en haut de la grille

  //Gestion de composant
  for I := 0 to Form1.ComponentCount-1 do
  begin
    // Gestion du TadvOfficePager
    if TForm(sender).Components[I].InheritsFrom(TAdvOfficePager) then
    begin
      TAdvOfficePager(Form1.Components[I]).ActivePageIndex  := 0;
      for J := 0 to TAdvOfficePager(Form1.Components[I]).AdvPageCount-1 do
      begin
        TAdvOfficePager(Form1.Components[I]).AdvPages[J].Progress.Color           := TAdvOfficePagerOfficeStyler(TAdvOfficePager(Form1.Components[I]).AdvOfficePagerStyler).TabAppearance.Color;
        TAdvOfficePager(Form1.Components[I]).AdvPages[J].Progress.ColorTo         := TAdvOfficePagerOfficeStyler(TAdvOfficePager(Form1.Components[I]).AdvOfficePagerStyler).TabAppearance.Color;
        TAdvOfficePager(Form1.Components[I]).AdvPages[J].Progress.CompleteColor   := TAdvOfficePagerOfficeStyler(TAdvOfficePager(Form1.Components[I]).AdvOfficePagerStyler).TabAppearance.Color;
        TAdvOfficePager(Form1.Components[I]).AdvPages[J].Progress.CompleteColorTo := TAdvOfficePagerOfficeStyler(TAdvOfficePager(Form1.Components[I]).AdvOfficePagerStyler).TabAppearance.Color;
        if TAdvOfficePager(Form1.Components[I]).ActivePage = TAdvOfficePager(Form1.Components[I]).AdvPages[J] then
        begin
          TAdvOfficePager(Form1.Components[I]).AdvPages[J].Progress.Visible  := False;
        end
        else begin
          TAdvOfficePager(Form1.Components[I]).AdvPages[J].Progress.Visible         := True;
        end;
      end;
      TAdvOfficePager(Form1.Components[I]).OnChange := AdvOfficePager_OnChange;
    end;

    // Gestion du TadvGlowButton
    if TForm(sender).Components[I].InheritsFrom(TadvGlowButton) then
    begin
      //Normal
      TadvGlowButton(Form1.Components[I]).Appearance.BorderColor           := $00BAACA4;
      TadvGlowButton(Form1.Components[I]).Appearance.Color                 := $00F8F6F5;
      TadvGlowButton(Form1.Components[I]).Appearance.ColorTo               := $00E4DEDB;
      TadvGlowButton(Form1.Components[I]).Appearance.ColorMirror           := $00BAACA4;
      TadvGlowButton(Form1.Components[I]).Appearance.ColorMirrorTo         := $00E4DEDB;
      TadvGlowButton(Form1.Components[I]).Appearance.Gradient              := ggVertical;
      TadvGlowButton(Form1.Components[I]).Appearance.GradientMirror        := ggVertical;

      //Reste enfoncé
      TadvGlowButton(Form1.Components[I]).Appearance.BorderColorChecked    := $00BAACA4;
      TadvGlowButton(Form1.Components[I]).Appearance.ColorChecked          := $005C4F47;
      TadvGlowButton(Form1.Components[I]).Appearance.ColorCheckedTo        := $00908279;
      TadvGlowButton(Form1.Components[I]).Appearance.ColorMirrorChecked    := $00D5C6BB;
      TadvGlowButton(Form1.Components[I]).Appearance.ColorMirrorCheckedTo  := $00908279;
      TadvGlowButton(Form1.Components[I]).Appearance.GradientChecked       := ggVertical;
      TadvGlowButton(Form1.Components[I]).Appearance.GradientMirrorChecked := ggVertical;

      //Désactivé
      TadvGlowButton(Form1.Components[I]).Appearance.BorderColorDisabled   := $00DED6D2;
      TadvGlowButton(Form1.Components[I]).Appearance.ColorDisabled         := $00F8F6F5;
      TadvGlowButton(Form1.Components[I]).Appearance.ColorDisabledTo       := $00F2EFED;
      TadvGlowButton(Form1.Components[I]).Appearance.ColorMirrorDisabled   := $00C9BDB7;
      TadvGlowButton(Form1.Components[I]).Appearance.ColorMirrorDisabledTo := $00F2EFED;
      TadvGlowButton(Form1.Components[I]).Appearance.GradientDisabled      := ggVertical;
      TadvGlowButton(Form1.Components[I]).Appearance.GradientMirrorDisabled:= ggVertical;

      //Enfoncé
      TadvGlowButton(Form1.Components[I]).Appearance.BorderColorDown       := $00BAACA4;
      TadvGlowButton(Form1.Components[I]).Appearance.ColorDown             := $00BAACA4;
      TadvGlowButton(Form1.Components[I]).Appearance.ColorDownTo           := $00E4DEDB;
      TadvGlowButton(Form1.Components[I]).Appearance.ColorMirrorDown       := $00F8F6F5;
      TadvGlowButton(Form1.Components[I]).Appearance.ColorMirrorDownTo     := $00E4DEDB;
      TadvGlowButton(Form1.Components[I]).Appearance.GradientDown          := ggVertical;
      TadvGlowButton(Form1.Components[I]).Appearance.GradientMirrorDown    := ggVertical;

      //Survol
      TadvGlowButton(Form1.Components[I]).Appearance.BorderColorHot        := $00BAACA4;
      TadvGlowButton(Form1.Components[I]).Appearance.ColorHot              := $00F8F6F5;
      TadvGlowButton(Form1.Components[I]).Appearance.ColorHotTo            := $00EBE6E3;
      TadvGlowButton(Form1.Components[I]).Appearance.ColorMirrorHot        := $00E4DEDB;
      TadvGlowButton(Form1.Components[I]).Appearance.ColorMirrorHotTo      := $00EBE6E3;
      TadvGlowButton(Form1.Components[I]).Appearance.GradientHot           := ggVertical;
      TadvGlowButton(Form1.Components[I]).Appearance.GradientMirrorHot     := ggVertical;

      //Font
      TadvGlowButton(Form1.Components[I]).Appearance.SystemFont            := False;
      TadvGlowButton(Form1.Components[I]).Font.Color                       := $004E4134;
      TadvGlowButton(Form1.Components[I]).Font.Name                        := 'Arial';
      TadvGlowButton(Form1.Components[I]).Font.Size                        := 10;
      TadvGlowButton(Form1.Components[I]).Font.Style                       := [fsBold];
      TadvGlowButton(Form1.Components[I]).OnDrawButton                     := DrawButton;
    end;

    //Gestion du raffraichissement de composant sur les ScrollBox
    if TForm(Sender).Components[i].InheritsFrom(TScrollBox) then
    begin
      TAdvScrollBox(TForm(Sender).Components[i]).OnVScroll := ScrollBox1VScroll;
    end;
  end;
end;

procedure TForm1.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
var
  i: integer;
  PosHautGauche: TPoint;
  PosBasDroite: TPoint;

begin
  for i := 0 to TForm(Sender).ComponentCount - 1 do
    begin
      try
        //Gestion de la molette sur les ScrollBox
        if TForm(Sender).Components[i].InheritsFrom(TScrollBox) then
          begin
            if (TForm(Sender).Components[i] as Tscrollbox).CanFocus then
              begin
                PosHautGauche.X := (TForm(Sender).Components[i] as TScrollBox).Left;
                PosHautGauche.Y := (TForm(Sender).Components[i] as TScrollBox).Top;
                PosBasDroite.X := (TForm(Sender).Components[i] as TScrollBox).Left
                  + (TForm(Sender).Components[i] as TScrollBox).Width;
                PosBasDroite.Y := (TForm(Sender).Components[i] as TScrollBox).Top
                  + (TForm(Sender).Components[i] as TScrollBox).Height;

                PosHautGauche := TForm(Sender).ScreenToClient((TForm(Sender).Components[i] as TScrollBox).ClientToScreen(PosHautGauche));
                PosHautGauche.X := PosHautGauche.X + TForm(Sender).Left;
                PosHautGauche.Y := PosHautGauche.Y + TForm(Sender).Top + TForm(Sender).Height - TForm(Sender).ClientHeight;

                PosBasDroite := TForm(Sender).ScreenToClient((TForm(Sender).Components[i] as TScrollBox).ClientToScreen(PosBasDroite));
                PosBasDroite.X := PosBasDroite.X + TForm(Sender).Left;
                PosBasDroite.Y := PosBasDroite.Y + TForm(Sender).Top + TForm(Sender).Height - TForm(Sender).ClientHeight;

                if (MousePos.X > PosHautGauche.X) and (MousePos.Y > PosHautGauche.Y)
                  and (MousePos.X < PosBasDroite.X) and (MousePos.Y < PosBasDroite.Y)
                  then
                  (TForm(Sender).Components[i] as TScrollBox).VertScrollBar.Position := (TForm(Sender).Components[i] as TScrollBox).VertScrollBar.Position - WheelDelta;
                (TForm(Sender).Components[i] as TScrollBox).Repaint;
              end;
          end;

        //Raffraichi les AdvOfficePager pour éviter un problème graphique lors des scroll
        if TForm(Sender).Components[i].InheritsFrom(TAdvOfficepager) then
        begin
          TAdvOfficepager(TForm(Sender).Components[i]).Repaint;
        end;
      except
      end;
    end;
end;

end.
