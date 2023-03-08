unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, dxBarBuiltInMenu, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, dxSkinBasic,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkroom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMetropolis, dxSkinMetropolisDark, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinOffice2013DarkGray,
  dxSkinOffice2013LightGray, dxSkinOffice2013White, dxSkinOffice2016Colorful,
  dxSkinOffice2016Dark, dxSkinOffice2019Black, dxSkinOffice2019Colorful,
  dxSkinOffice2019DarkGray, dxSkinOffice2019White, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringtime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinTheBezier, dxSkinsDefaultPainters, dxSkinValentine,
  dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, cxContainer, cxEdit, dxGDIPlusClasses, cxImage, cxLabel,
  cxPC, Vcl.ExtCtrls, Vcl.Menus, Vcl.ComCtrls, dxCore, cxDateUtils, cxTextEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.StdCtrls, cxButtons, cxClasses,
  dxSkinsForm, cxGroupBox, Winapi.ShellAPI, Data.DB, MemDS, DBAccess, Ora,
  OraCall, cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxNavigator,
  dxDateRanges, dxScrollbarAnnotations, cxDBData, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGridLevel, cxGridCustomView, cxGrid,
  Vcl.Clipbrd, System.Win.Registry, cxCurrencyEdit, dxNavBarCollns,
  dxNavBarBase, dxNavBar, Vcl.OleCtrls, SHDocVw, cxGridExportLink;

type
  TForm1 = class(TForm)
    cxPageControl1: TcxPageControl;
    Panel1: TPanel;
    tab_gss: TcxTabSheet;
    tab_fatura: TcxTabSheet;
    Panel2: TPanel;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    cxImage1: TcxImage;
    cxImage2: TcxImage;
    cxDateEdit1: TcxDateEdit;
    cxDateEdit2: TcxDateEdit;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    dxSkinController1: TdxSkinController;
    cxLabel5: TcxLabel;
    cxLabel6: TcxLabel;
    btn_ara: TcxButton;
    qr_gss: TOraQuery;
    ds_gss: TDataSource;
    qr_gssADI: TStringField;
    qr_gssSOYADI: TStringField;
    qr_gssDOSYA_NO: TFloatField;
    qr_gssPROTOKOL_NO: TFloatField;
    qr_gssBOLUM_ADI: TStringField;
    qr_gssADI_SOYADI: TStringField;
    qr_gssKURUM_ADI: TStringField;
    qr_gssGSS_TAKIP_NO: TStringField;
    qr_gssGSS_BASVURU_NO: TStringField;
    qr_gssKULLANICI_ACAN: TStringField;
    qr_gssKULLANICI_DEGISTIREN: TStringField;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    cxGrid1DBTableView1ADI: TcxGridDBColumn;
    cxGrid1DBTableView1SOYADI: TcxGridDBColumn;
    cxGrid1DBTableView1DOSYA_NO: TcxGridDBColumn;
    cxGrid1DBTableView1PROTOKOL_NO: TcxGridDBColumn;
    cxGrid1DBTableView1BOLUM_ADI: TcxGridDBColumn;
    cxGrid1DBTableView1ADI_SOYADI: TcxGridDBColumn;
    cxGrid1DBTableView1KURUM_ADI: TcxGridDBColumn;
    cxGrid1DBTableView1GSS_TAKIP_NO: TcxGridDBColumn;
    cxGrid1DBTableView1GSS_BASVURU_NO: TcxGridDBColumn;
    cxGrid1DBTableView1KULLANICI_ACAN: TcxGridDBColumn;
    cxGrid1DBTableView1KULLANICI_DEGISTIREN: TcxGridDBColumn;
    PopupMenu1: TPopupMenu;
    DosyaKopyala1: TMenuItem;
    KopyalaProtokol1: TMenuItem;
    cxLabel7: TcxLabel;
    cxLabel8: TcxLabel;
    qr_fatura: TOraQuery;
    ds_fatura: TDataSource;
    cxGrid2: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    cxGridLevel1: TcxGridLevel;
    cxGridDBTableView1ADI: TcxGridDBColumn;
    cxGridDBTableView1SOYADI: TcxGridDBColumn;
    cxGridDBTableView1DOSYA_NO: TcxGridDBColumn;
    cxGridDBTableView1PROTOKOL_NO: TcxGridDBColumn;
    cxGridDBTableView1BOLUM_ADI: TcxGridDBColumn;
    cxGridDBTableView1ADI_SOYADI: TcxGridDBColumn;
    cxGridDBTableView1KURUM_ADI: TcxGridDBColumn;
    cxGridDBTableView1FATURATIPI: TcxGridDBColumn;
    cxGroupBox1: TcxGroupBox;
    Image1: TImage;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    edt_server: TEdit;
    edt_pass: TEdit;
    edt_username: TcxComboBox;
    btnloginbuton: TcxButton;
    btn1: TcxButton;
    tab_rehber: TcxTabSheet;
    ds_rehber: TDataSource;
    qr_rehber: TOraQuery;
    qr_rehberAD: TStringField;
    qr_rehberGOREV: TStringField;
    qr_rehberKAT: TStringField;
    qr_rehberDAHILI: TStringField;
    qr_rehberCEP: TStringField;
    qr_rehberMAIL: TStringField;
    qr_rehberTUR: TStringField;
    cxGrid3DBTableView1: TcxGridDBTableView;
    cxGrid3Level1: TcxGridLevel;
    cxGrid3: TcxGrid;
    cxGrid3DBTableView1AD: TcxGridDBColumn;
    cxGrid3DBTableView1GOREV: TcxGridDBColumn;
    cxGrid3DBTableView1KAT: TcxGridDBColumn;
    cxGrid3DBTableView1DAHILI: TcxGridDBColumn;
    cxGrid3DBTableView1CEP: TcxGridDBColumn;
    cxGrid3DBTableView1MAIL: TcxGridDBColumn;
    cxGrid3DBTableView1TUR: TcxGridDBColumn;
    qr_faturaADI: TStringField;
    qr_faturaSOYADI: TStringField;
    qr_faturaDOSYA_NO: TFloatField;
    qr_faturaPROTOKOL_NO: TFloatField;
    qr_faturaBOLUM_ADI: TStringField;
    qr_faturaADI_SOYADI: TStringField;
    qr_faturaKURUM_ADI: TStringField;
    qr_faturaFATURATIPI: TStringField;
    qr_faturaCIRO: TFloatField;
    cxGridDBTableView1CIRO: TcxGridDBColumn;
    qr_faturaODETMEALAN: TStringField;
    qr_faturaEKLEYEN: TStringField;
    cxGridDBTableView1ODETMEALAN: TcxGridDBColumn;
    cxGridDBTableView1EKLEYEN: TcxGridDBColumn;
    tab_afet: TcxTabSheet;
    ds_afet: TDataSource;
    qr_afet: TOraQuery;
    cxGrid4: TcxGrid;
    cxGridDBTableView2: TcxGridDBTableView;
    cxGridLevel2: TcxGridLevel;
    cxGridDBTableView2TARIH: TcxGridDBColumn;
    cxGridDBTableView2DOSYA_NO: TcxGridDBColumn;
    cxGridDBTableView2ADI_SOYADI: TcxGridDBColumn;
    cxGridDBTableView2PROTOKOL_NO: TcxGridDBColumn;
    cxGridDBTableView2BOLUM: TcxGridDBColumn;
    cxGridDBTableView2BOLUM_ADI: TcxGridDBColumn;
    cxGridDBTableView2DR_KODU: TcxGridDBColumn;
    cxGridDBTableView2DOKTOR: TcxGridDBColumn;
    cxGridDBTableView2PROVIZYON: TcxGridDBColumn;
    cxGridDBTableView2TEDAVI: TcxGridDBColumn;
    qr_afetTARIH: TStringField;
    qr_afetDOSYA_NO: TFloatField;
    qr_afetADI_SOYADI: TStringField;
    qr_afetPROTOKOL_NO: TFloatField;
    qr_afetBOLUM: TFloatField;
    qr_afetBOLUM_ADI: TStringField;
    qr_afetDR_KODU: TFloatField;
    qr_afetDOKTOR: TStringField;
    qr_afetPROVIZYON: TStringField;
    qr_afetTEDAVI: TStringField;
    dxNavBar1: TdxNavBar;
    bar_hk: TdxNavBarGroup;
    bar_faturalama: TdxNavBarGroup;
    bar_duyuru: TdxNavBarGroup;
    dxNavBar1Item1: TdxNavBarItem;
    dxNavBar1Item2: TdxNavBarItem;
    dxNavBar1Item3: TdxNavBarItem;
    dxNavBar1Item4: TdxNavBarItem;
    tab_duyuru: TcxTabSheet;
    WebBrowser1: TWebBrowser;
    ExportExcelaktar1: TMenuItem;
    GSSListesi1: TMenuItem;
    FaturaListesi1: TMenuItem;
    Rehber1: TMenuItem;
    DoalAfet1: TMenuItem;
    N1: TMenuItem;
    SaveDialog1: TSaveDialog;
    GSSAlnmyan1: TMenuItem;
    FaturaKesilmiyen1: TMenuItem;
    KopyalaDosya1: TMenuItem;
    KopyalaProtokol2: TMenuItem;
    procedure cxLabel1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure cxImage1Click(Sender: TObject);
    procedure cxLabel2Click(Sender: TObject);
    procedure cxImage2Click(Sender: TObject);
    procedure btn_araClick(Sender: TObject);
    procedure DosyaKopyala1Click(Sender: TObject);
    procedure KopyalaProtokol1Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnloginbutonClick(Sender: TObject);
    procedure dxNavBar1Item4Click(Sender: TObject);
    procedure dxNavBar1Item3Click(Sender: TObject);
    procedure dxNavBar1Item2Click(Sender: TObject);
    procedure dxNavBar1Item1Click(Sender: TObject);
    procedure bar_duyuruClick(Sender: TObject);
    procedure edt_passKeyPress(Sender: TObject; var Key: Char);
    procedure GSSListesi1Click(Sender: TObject);
    procedure FaturaListesi1Click(Sender: TObject);
    procedure DoalAfet1Click(Sender: TObject);
    procedure KopyalaDosya1Click(Sender: TObject);
    procedure KopyalaProtokol2Click(Sender: TObject);
  private
    procedure v_fatura_sorgula;
    procedure v_afet_sorgula;
    procedure v_gss_sorgula;
    procedure v_rehber_sorgula;
    procedure m_login;
    { Private declarations }
  public
    { Public declarations }
    secim: string;
  end;

var
  Form1: TForm1;

implementation

uses
  datamodul;

{$R *.dfm}

procedure TForm1.bar_duyuruClick(Sender: TObject);
begin
  WebBrowser1.Navigate('alisahan.com');
  WebBrowser1.Silent := true;
end;

procedure TForm1.btn1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm1.btnloginbutonClick(Sender: TObject);
begin
  m_login;
end;

procedure TForm1.btn_araClick(Sender: TObject);

begin
  if cxPageControl1.ActivePageIndex = 0 then
    v_gss_sorgula;
  if cxPageControl1.ActivePageIndex = 1 then
    v_fatura_sorgula;
  if cxPageControl1.ActivePageIndex = 2 then
    v_rehber_sorgula;
  if cxPageControl1.ActivePageIndex = 3 then
    v_afet_sorgula;

end;

procedure TForm1.cxImage1Click(Sender: TObject);
begin
  ShellExecute(self.WindowHandle, 'open',
    PChar('https://www.instagram.com/alisahancom/'), nil, nil, SW_SHOWNORMAL);
end;

procedure TForm1.cxImage2Click(Sender: TObject);
begin
  ShellExecute(self.WindowHandle, 'open', PChar('https://www.alisahan.com'),
    nil, nil, SW_SHOWNORMAL);
end;

procedure TForm1.cxLabel1Click(Sender: TObject);
begin
  ShellExecute(self.WindowHandle, 'open',
    PChar('https://www.instagram.com/alisahancom/'), nil, nil, SW_SHOWNORMAL);
end;

procedure TForm1.cxLabel2Click(Sender: TObject);
begin
  ShellExecute(self.WindowHandle, 'open', PChar('https://www.alisahan.com'),
    nil, nil, SW_SHOWNORMAL);
end;

procedure TForm1.v_fatura_sorgula;
begin
  // fatura Sorgusu
  qr_fatura.ParamByName('tar1').Value := cxDateEdit1.Text + ' 00:00:00';
  qr_fatura.ParamByName('tar2').Value := cxDateEdit2.Text + ' 23:59:59';
  qr_fatura.Execute;
  cxGridDBTableView1.ApplyBestFit;
end;

procedure TForm1.v_afet_sorgula;
begin
  // Afet Sorgusu
  qr_afet.ParamByName('tar1').Value := cxDateEdit1.Text + ' 00:00:00';
  qr_afet.ParamByName('tar2').Value := cxDateEdit2.Text + ' 23:59:59';
  qr_afet.Execute;
  cxGridDBTableView2.ApplyBestFit;
end;

procedure TForm1.v_gss_sorgula;
begin
  // GSS Sorgusu
  qr_gss.ParamByName('tar1').Value := cxDateEdit1.Text + ' 00:00:00';
  qr_gss.ParamByName('tar2').Value := cxDateEdit2.Text + ' 23:59:59';
  qr_gss.Execute;
  cxGrid1DBTableView1.ApplyBestFit;
end;

procedure TForm1.v_rehber_sorgula;
begin
  qr_rehber.Open;
  cxGrid3DBTableView1.ApplyBestFit;
end;

procedure TForm1.m_login;
begin
  try
    dm.OraSession1.Server := edt_server.Text;
    dm.OraSession1.Username := edt_username.Text;
    dm.OraSession1.Password := edt_pass.Text;
    dm.OraSession1.Open;
    Panel1.Enabled := true;
    cxPageControl1.Enabled := true;
    cxGroupBox1.Visible := false;
    dxNavBar1.Enabled := true;
  except
    on E: Exception do
      ShowMessage('Hatalý Giriþ Problemi, Olasý Neden ' + ''#13'' + E.Message);
  end;

end;

procedure TForm1.DoalAfet1Click(Sender: TObject);
begin
  try

    SaveDialog1.InitialDir := ExtractFilePath(SaveDialog1.FileName);
    SaveDialog1.Filter := 'Excel files (*.xls)|*.xlsx';
    SaveDialog1.FileName := 'Doðal Afet Listesi (' + cxDateEdit1.Text + ' vs' +
      cxDateEdit2.Text + ')';
    SaveDialog1.Execute();

    ExportGridToXLSX(SaveDialog1.FileName, cxGrid4, true, true, true, 'xlsx')
  except
    on E: Exception do
      ShowMessage('Excele Aktarým Baþarýsýz,olasý hata' + sLineBreak +
        E.Message);
  end;
end;

procedure TForm1.DosyaKopyala1Click(Sender: TObject);
begin
  Clipboard.AsText := cxGrid1DBTableView1DOSYA_NO.EditValue;
end;

procedure TForm1.dxNavBar1Item1Click(Sender: TObject);
begin
  cxPageControl1.ActivePageIndex := 2;
  v_rehber_sorgula;
end;

procedure TForm1.dxNavBar1Item2Click(Sender: TObject);
begin
  cxPageControl1.ActivePageIndex := 3;
  v_afet_sorgula;
end;

procedure TForm1.dxNavBar1Item3Click(Sender: TObject);
begin
  cxPageControl1.ActivePageIndex := 1;
  v_fatura_sorgula;
end;

procedure TForm1.dxNavBar1Item4Click(Sender: TObject);
begin
  cxPageControl1.ActivePageIndex := 0;
  v_gss_sorgula;
end;

procedure TForm1.edt_passKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    m_login;
end;

procedure TForm1.FaturaListesi1Click(Sender: TObject);
begin
  try

    SaveDialog1.InitialDir := ExtractFilePath(SaveDialog1.FileName);
    SaveDialog1.Filter := 'Excel files (*.xls)|*.xlsx';
    SaveDialog1.FileName := 'Fatura Kesilmiyen Listesi (' + cxDateEdit1.Text +
      ' vs' + cxDateEdit2.Text + ')';
    SaveDialog1.Execute();

    ExportGridToXLSX(SaveDialog1.FileName, cxGrid2, true, true, true, 'xlsx')
  except
    on E: Exception do
      ShowMessage('Excele Aktarým Baþarýsýz,olasý hata' + sLineBreak +
        E.Message);
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  cxLabel5.Left := Form1.Width - 70;
  cxLabel5.Top := Panel2.Top - 200 - 28;
  cxLabel6.Left := Form1.Width - 40;
  cxLabel6.Top := Panel2.Top - 200;

  cxLabel7.Left := Form1.Width - 70;
  cxLabel7.Top := Panel2.Top - 200 - 28;
  cxLabel8.Left := Form1.Width - 50;
  cxLabel8.Top := Panel2.Top - 200;

  cxGroupBox1.Top := round(Form1.Height / 2 - 100);
  cxGroupBox1.Left := round(Form1.Width / 2 - 200);
end;

procedure TForm1.FormShow(Sender: TObject);
var
  rex: Tregistry;
begin
  rex := Tregistry.Create;
  rex.RootKey := HKEY_CURRENT_USER;
  rex.OpenKeyReadOnly('SOFTWARE\diginet\MedData\');
  // ShowMessage(rex.ReadString('server'));
  edt_server.Text := rex.ReadString('server');
  edt_username.Text := rex.ReadString('username');

end;

procedure TForm1.GSSListesi1Click(Sender: TObject);
begin
  try

    SaveDialog1.InitialDir := ExtractFilePath(SaveDialog1.FileName);
    SaveDialog1.Filter := 'Excel files (*.xls)|*.xlsx';
    SaveDialog1.FileName := 'GSS Alýnmayan Listesi (' + cxDateEdit1.Text + ' vs'
      + cxDateEdit2.Text + ')';
    SaveDialog1.Execute();

    ExportGridToXLSX(SaveDialog1.FileName, cxGrid1, true, true, true, 'xlsx')
  except
    on E: Exception do
      ShowMessage('Excele Aktarým Baþarýsýz,olasý hata' + sLineBreak +
        E.Message);
  end;
end;

procedure TForm1.KopyalaDosya1Click(Sender: TObject);
begin
  Clipboard.AsText := cxGridDBTableView1DOSYA_NO.EditValue;
end;

procedure TForm1.KopyalaProtokol1Click(Sender: TObject);
begin
  Clipboard.AsText := cxGrid1DBTableView1PROTOKOL_NO.EditValue;
end;

procedure TForm1.KopyalaProtokol2Click(Sender: TObject);
begin
  Clipboard.AsText := cxGridDBTableView1PROTOKOL_NO.EditValue;
end;

procedure TForm1.MenuItem1Click(Sender: TObject);
begin
  Clipboard.AsText := cxGridDBTableView1DOSYA_NO.EditValue;
end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin
  Clipboard.AsText := cxGridDBTableView1PROTOKOL_NO.EditValue;
end;

end.
