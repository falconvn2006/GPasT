unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit,
  dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkroom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast, dxSkinLilian, dxSkinLiquidSky,
  dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMetropolis, dxSkinMetropolisDark, dxSkinMoneyTwins, dxSkinOffice2007Black,
  dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2010Silver, dxSkinOffice2013DarkGray, dxSkinOffice2013LightGray, dxSkinOffice2013White, dxSkinOffice2016Colorful,
  dxSkinOffice2016Dark, dxSkinOffice2019Colorful, dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringtime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld, dxSkinTheBezier, dxSkinsDefaultPainters,
  dxSkinValentine, dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark, dxSkinVisualStudio2013Light, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, cxTextEdit, cxLabel, cxGroupBox, cxDBLabel, Data.DB, DBAccess, Ora, MemDS, OraCall, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxNavigator, dxDateRanges, cxDBData, cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridLevel,
  cxClasses, cxGridCustomView, cxGrid, Vcl.Menus, Vcl.StdCtrls, cxButtons, dxSkinsForm, dxBarBuiltInMenu, RzTabs, cxPC,
  cxgridexportlink, cxMemo, Vcl.DBCtrls, cxDBEdit, dxGDIPlusClasses;

type
  Tf_main = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    cxLabel2: TcxLabel;
    cxTextEdit2: TcxTextEdit;
    cxGroupBox1: TcxGroupBox;
    cxGroupBox2: TcxGroupBox;
    lb_adisoyadi: TcxLabel;
    lb_anneadi: TcxLabel;
    lb_babaadi: TcxLabel;
    lb_dogum: TcxLabel;
    lb_cinsiyet: TcxLabel;
    lb_dogumyeri: TcxLabel;
    lb_sonkurum: TcxLabel;
    lb_ulke: TcxLabel;
    ln_kayitacan: TcxLabel;
    qr_kimlik: TOraQuery;
    qr_kimlikHASTA_KODU: TFloatField;
    qr_kimlikREFERANS_TABLO_ADI: TStringField;
    qr_kimlikTC_KIMLIK_NUMARASI: TStringField;
    qr_kimlikUYRUK: TFloatField;
    qr_kimlikHASTA_TIPI: TFloatField;
    qr_kimlikAD: TStringField;
    qr_kimlikDOGUM_TARIHI: TDateTimeField;
    qr_kimlikDOGUM_YERI: TStringField;
    qr_kimlikCINSIYET: TStringField;
    qr_kimlikANNE_KIMLIK_NUMARASI: TStringField;
    qr_kimlikDOGUM_SIRASI: TFloatField;
    qr_kimlikANNE_ADI: TStringField;
    qr_kimlikBABA_ADI: TStringField;
    qr_kimlikMEDENI_HALI: TFloatField;
    qr_kimlikMESLEK: TFloatField;
    qr_kimlikOGRENIM_DURUMU: TFloatField;
    qr_kimlikKAN_GRUBU: TFloatField;
    qr_kimlikENGELLILIK_DURUMU: TFloatField;
    qr_kimlikOLUM_TARIHI: TDateTimeField;
    qr_kimlikOLUM_YERI: TFloatField;
    qr_kimlikPASAPORT_NUMARASI: TStringField;
    qr_kimlikYABANCI_HASTA_TURU: TFloatField;
    qr_kimlikYUPASS_NUMARASI: TStringField;
    qr_kimlikSON_KURUM_KODU: TStringField;
    qr_kimlikKAYIT_ZAMANI: TStringField;
    qr_kimlikEKLEYEN_KULLANICI_KODU: TStringField;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    qr_protokol: TOraQuery;
    ds_protokol: TOraDataSource;
    qr_protokolBASVURU_NO: TFloatField;
    qr_protokolDOSYA_NO: TFloatField;
    qr_protokolGTARIH: TStringField;
    qr_protokolKURUM_ADI: TStringField;
    qr_protokolDOKTOR: TStringField;
    qr_protokolBIRIM_ADI: TStringField;
    qr_protokolTEDAVI: TStringField;
    cxGrid1DBTableView1BASVURU_NO: TcxGridDBColumn;
    cxGrid1DBTableView1DOSYA_NO: TcxGridDBColumn;
    cxGrid1DBTableView1GTARIH: TcxGridDBColumn;
    cxGrid1DBTableView1KURUM_ADI: TcxGridDBColumn;
    cxGrid1DBTableView1DOKTOR: TcxGridDBColumn;
    cxGrid1DBTableView1BIRIM_ADI: TcxGridDBColumn;
    cxGrid1DBTableView1TEDAVI: TcxGridDBColumn;
    qr_islem: TOraQuery;
    ds_islem: TOraDataSource;
    qr_islemHASTA_HIZMET_KODU: TFloatField;
    qr_islemISLEM_ZAMANI: TStringField;
    qr_islemHIZMET_ADI: TStringField;
    qr_islemADET: TFloatField;
    qr_islemHASTA_TUTARI: TFloatField;
    qr_islemKURUM_TUTARI: TFloatField;
    qr_islemMEDULA_TUTARI: TFloatField;
    qr_islemIPTAL: TStringField;
    qr_islemFATURA: TStringField;
    qr_islemKULLANICI_ADI: TStringField;
    qr_islemDOKTOR: TStringField;
    dxSkinController1: TdxSkinController;
    cxButton2: TcxButton;
    cxButton3: TcxButton;
    cxButton4: TcxButton;
    cxButton5: TcxButton;
    cxButton6: TcxButton;
    cxButton7: TcxButton;
    cxButton8: TcxButton;
    cxButton10: TcxButton;
    SaveDialog1: TSaveDialog;
    qr_fatura: TOraQuery;
    ds_fatura: TOraDataSource;
    qr_faturaFATURA_KODU: TStringField;
    qr_faturaREFERANS_TABLO_ADI: TStringField;
    qr_faturaFATURA_DONEMI: TStringField;
    qr_faturaICMAL_KODU: TFloatField;
    qr_faturaHASTA_BASVURU_KODU: TFloatField;
    qr_faturaFATURA_ADI: TStringField;
    qr_faturaFATURA_ZAMANI: TDateTimeField;
    qr_faturaFATURA_TUTARI: TFloatField;
    qr_faturaFATURA_NUMARASI: TFloatField;
    qr_faturaMEDULA_TESLIM_NUMARASI: TStringField;
    qr_faturaFATURA_KURUM_KODU: TFloatField;
    qr_faturaEKLEYEN_KULLANICI_KODU: TFloatField;
    cxButton11: TcxButton;
    qr_vezne: TOraQuery;
    ds_vezne: TOraDataSource;
    qr_vezneHASTA_BASVURU_KODU: TFloatField;
    qr_vezneMAKBUZ_NUMARASI: TFloatField;
    qr_vezneHIZMET_ADI: TStringField;
    qr_vezneTUTARI: TFloatField;
    qr_vezneKULLANICI_ADI: TStringField;
    qr_vezneIPTAL_MI: TStringField;
    qr_vezneIPTAL_ACIKLAMA: TStringField;
    qr_vezneTAHSIL_TURU: TFloatField;
    qr_epikriz: TOraQuery;
    qr_epikrizHASTA_EPIKRIZ_KODU: TFloatField;
    qr_epikrizREFERANS_TABLO_ADI: TStringField;
    qr_epikrizHASTA_BASVURU_KODU: TFloatField;
    qr_epikrizEPIKRIZ_ZAMANI: TStringField;
    qr_epikrizEPIKRIZ_BILGISI_BASLIK: TFloatField;
    qr_epikrizEPIKRIZ_BILGISI_ACIKLAMA: TStringField;
    qr_epikrizHEKIM_KODU: TFloatField;
    qr_epikrizEKLEYEN_KULLANICI_KODU: TFloatField;
    qr_epikrizDOKTOR: TStringField;
    qr_recete: TOraQuery;
    ds_recete: TOraDataSource;
    qr_receteHASTA_BASVURU_KODU: TFloatField;
    qr_receteRECETE_ZAMANI: TStringField;
    qr_receteILAC_BARKODU: TStringField;
    qr_receteILAC_ADI: TStringField;
    qr_receteDOZ_BIRIMI: TStringField;
    qr_receteKUTU_ADETI: TFloatField;
    qr_receteDOZ: TStringField;
    qr_receteRECETE_TURU: TFloatField;
    qr_receteRECETE_ALT_TURU: TFloatField;
    qr_receteDOKTOR: TStringField;
    qr_receteE_RECETE_NUMARASI: TStringField;
    qr_receteSERI_NUMARASI: TStringField;
    qr_receteE_IMZA_DURUMU: TFloatField;
    qr_receteTAKIP_NUMARASI: TStringField;
    qr_konsul: TOraQuery;
    ds_konsul: TOraDataSource;
    qr_konsulKONSULTASYON_NO: TFloatField;
    qr_konsulHIZMET_ADI: TStringField;
    qr_konsulPROTOKOL_NO: TFloatField;
    qr_konsulISTEK_NOTU: TStringField;
    qr_konsulCEVAP_NOTU: TStringField;
    qr_konsulISTEKTARIHI: TStringField;
    qr_konsulCEVABTARIHI: TStringField;
    qr_konsulKULLANICI_ADI: TStringField;
    qr_tani: TOraQuery;
    ds_tani: TOraDataSource;
    qr_taniTANI_KODU: TStringField;
    qr_taniTANI_ZAMANI: TStringField;
    qr_taniRECETE_KODU: TFloatField;
    qr_taniDOKTOR: TStringField;
    qr_taniKULLANICI_ADI: TStringField;
    Panel3: TPanel;
    cxPageControl1: TcxPageControl;
    cxTabSheet1: TcxTabSheet;
    cxGrid2: TcxGrid;
    cxGrid2DBTableView1: TcxGridDBTableView;
    cxGrid2DBTableView1HASTA_HIZMET_KODU: TcxGridDBColumn;
    cxGrid2DBTableView1ISLEM_ZAMANI: TcxGridDBColumn;
    cxGrid2DBTableView1HIZMET_ADI: TcxGridDBColumn;
    cxGrid2DBTableView1ADET: TcxGridDBColumn;
    cxGrid2DBTableView1HASTA_TUTARI: TcxGridDBColumn;
    cxGrid2DBTableView1KURUM_TUTARI: TcxGridDBColumn;
    cxGrid2DBTableView1MEDULA_TUTARI: TcxGridDBColumn;
    cxGrid2DBTableView1IPTAL: TcxGridDBColumn;
    cxGrid2DBTableView1FATURA: TcxGridDBColumn;
    cxGrid2DBTableView1KULLANICI_ADI: TcxGridDBColumn;
    cxGrid2DBTableView1DOKTOR: TcxGridDBColumn;
    cxGrid2Level1: TcxGridLevel;
    cxTabSheet2: TcxTabSheet;
    cxGrid3: TcxGrid;
    cxGrid3DBTableView1: TcxGridDBTableView;
    cxGrid3DBTableView1FATURA_KODU: TcxGridDBColumn;
    cxGrid3DBTableView1REFERANS_TABLO_ADI: TcxGridDBColumn;
    cxGrid3DBTableView1FATURA_DONEMI: TcxGridDBColumn;
    cxGrid3DBTableView1ICMAL_KODU: TcxGridDBColumn;
    cxGrid3DBTableView1HASTA_BASVURU_KODU: TcxGridDBColumn;
    cxGrid3DBTableView1FATURA_ADI: TcxGridDBColumn;
    cxGrid3DBTableView1FATURA_ZAMANI: TcxGridDBColumn;
    cxGrid3DBTableView1FATURA_TUTARI: TcxGridDBColumn;
    cxGrid3DBTableView1FATURA_NUMARASI: TcxGridDBColumn;
    cxGrid3DBTableView1MEDULA_TESLIM_NUMARASI: TcxGridDBColumn;
    cxGrid3DBTableView1FATURA_KURUM_KODU: TcxGridDBColumn;
    cxGrid3DBTableView1EKLEYEN_KULLANICI_KODU: TcxGridDBColumn;
    cxGrid3Level1: TcxGridLevel;
    cxTabSheet3: TcxTabSheet;
    cxGrid4: TcxGrid;
    cxGrid4DBTableView1: TcxGridDBTableView;
    cxGrid4DBTableView1HASTA_BASVURU_KODU: TcxGridDBColumn;
    cxGrid4DBTableView1MAKBUZ_NUMARASI: TcxGridDBColumn;
    cxGrid4DBTableView1HIZMET_ADI: TcxGridDBColumn;
    cxGrid4DBTableView1TUTARI: TcxGridDBColumn;
    cxGrid4DBTableView1KULLANICI_ADI: TcxGridDBColumn;
    cxGrid4DBTableView1IPTAL_MI: TcxGridDBColumn;
    cxGrid4DBTableView1IPTAL_ACIKLAMA: TcxGridDBColumn;
    cxGrid4DBTableView1TAHSIL_TURU: TcxGridDBColumn;
    cxGrid4Level1: TcxGridLevel;
    cxTabSheet4: TcxTabSheet;
    cxMemo1: TcxMemo;
    cxTabSheet5: TcxTabSheet;
    cxGrid5: TcxGrid;
    cxGrid5DBTableView1: TcxGridDBTableView;
    cxGrid5DBTableView1HASTA_BASVURU_KODU: TcxGridDBColumn;
    cxGrid5DBTableView1RECETE_ZAMANI: TcxGridDBColumn;
    cxGrid5DBTableView1ILAC_BARKODU: TcxGridDBColumn;
    cxGrid5DBTableView1ILAC_ADI: TcxGridDBColumn;
    cxGrid5DBTableView1DOZ_BIRIMI: TcxGridDBColumn;
    cxGrid5DBTableView1KUTU_ADETI: TcxGridDBColumn;
    cxGrid5DBTableView1DOZ: TcxGridDBColumn;
    cxGrid5DBTableView1RECETE_TURU: TcxGridDBColumn;
    cxGrid5DBTableView1RECETE_ALT_TURU: TcxGridDBColumn;
    cxGrid5DBTableView1DOKTOR: TcxGridDBColumn;
    cxGrid5DBTableView1E_RECETE_NUMARASI: TcxGridDBColumn;
    cxGrid5DBTableView1SERI_NUMARASI: TcxGridDBColumn;
    cxGrid5DBTableView1E_IMZA_DURUMU: TcxGridDBColumn;
    cxGrid5DBTableView1TAKIP_NUMARASI: TcxGridDBColumn;
    cxGrid5Level1: TcxGridLevel;
    cxTabSheet6: TcxTabSheet;
    cxDBMemo1: TcxDBMemo;
    cxDBMemo2: TcxDBMemo;
    cxGroupBox3: TcxGroupBox;
    DBNavigator1: TDBNavigator;
    cxDBTextEdit1: TcxDBTextEdit;
    cxDBTextEdit2: TcxDBTextEdit;
    cxDBTextEdit3: TcxDBTextEdit;
    cxDBTextEdit4: TcxDBTextEdit;
    cxDBTextEdit5: TcxDBTextEdit;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    cxLabel6: TcxLabel;
    cxLabel7: TcxLabel;
    cxTabSheet7: TcxTabSheet;
    cxGrid6: TcxGrid;
    cxGrid6DBTableView1: TcxGridDBTableView;
    cxGrid6DBTableView1TANI_KODU: TcxGridDBColumn;
    cxGrid6DBTableView1TANI_ZAMANI: TcxGridDBColumn;
    cxGrid6DBTableView1RECETE_KODU: TcxGridDBColumn;
    cxGrid6DBTableView1DOKTOR: TcxGridDBColumn;
    cxGrid6DBTableView1KULLANICI_ADI: TcxGridDBColumn;
    cxGrid6Level1: TcxGridLevel;
    cxTabSheet8: TcxTabSheet;
    cxGrid7: TcxGrid;
    cxGrid7DBTableView1: TcxGridDBTableView;
    cxGrid7Level1: TcxGridLevel;
    cxLabel1: TcxLabel;
    cxTextEdit1: TcxTextEdit;
    Image1: TImage;
    Image2: TImage;
    pm1: TPopupMenu;
    Protokol1: TMenuItem;
    lemler1: TMenuItem;
    FAturaDkm1: TMenuItem;
    Vezne1: TMenuItem;
    Epikriz1: TMenuItem;
    Reete1: TMenuItem;
    Konsltasyon1: TMenuItem;
    AnBilgileri1: TMenuItem;
    procedure cxButton1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure lemleriAktar1Click(Sender: TObject);
    procedure cxButton11Click(Sender: TObject);
    procedure cxButton3Click(Sender: TObject);
    procedure cxButton5Click(Sender: TObject);
    procedure cxMemo1Click(Sender: TObject);
    procedure cxButton6Click(Sender: TObject);
    procedure cxButton10Click(Sender: TObject);
    procedure cxButton7Click(Sender: TObject);
    procedure cxTextEdit1KeyPress(Sender: TObject; var Key: Char);
    procedure cxGrid1DBTableView1DblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cxGrid1DBTableView1CellDblClick(Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
      AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
    procedure cxGrid1DBTableView1CellClick(Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
      AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cxTextEdit2KeyPress(Sender: TObject; var Key: Char);
    procedure Protokol1Click(Sender: TObject);
    procedure lemler1Click(Sender: TObject);
    procedure FAturaDkm1Click(Sender: TObject);
    procedure Vezne1Click(Sender: TObject);
    procedure Reete1Click(Sender: TObject);
    procedure AnBilgileri1Click(Sender: TObject);
  private
    procedure m_kimlik_ara;
    procedure m_detay_ara;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  f_main: Tf_main;

implementation

{$R *.dfm}

uses datamodul;

procedure Tf_main.AnBilgileri1Click(Sender: TObject);
begin
  try

    SaveDialog1.InitialDir := ExtractFilePath(SaveDialog1.FileName);
    SaveDialog1.Filter := 'Excel files (*.xls)|*.xlsx';
    SaveDialog1.FileName := 'Taný Listesi ';
    SaveDialog1.Execute();

    ExportGridToXLSX(SaveDialog1.FileName, cxGrid6, true, true, true, 'xlsx')
  except
    on E: Exception do
      ShowMessage('Excele Aktarým Baþarýsýz,olasý hata' + sLineBreak + E.Message);
  end;
end;

procedure Tf_main.cxButton10Click(Sender: TObject);
begin
  qr_konsul.ParamByName('PROTOKOL_NO').Value := qr_protokolBASVURU_NO.Value;
  qr_konsul.Execute;
  cxPageControl1.ActivePage := cxTabSheet6;
  cxGroupBox3.Height := round(cxTabSheet6.Height / 3);
  cxDBMemo1.Height := round(cxTabSheet6.Height / 3);
  cxDBMemo2.Height := round(cxTabSheet6.Height / 3);

end;

procedure Tf_main.cxButton11Click(Sender: TObject);
begin
  qr_fatura.ParamByName('PROTOKOL_NO').Value := qr_protokolBASVURU_NO.Value;
  qr_fatura.Execute;
  cxPageControl1.ActivePage := cxTabSheet2;
  cxGrid1DBTableView1.ApplyBestFit();
end;

procedure Tf_main.cxButton1Click(Sender: TObject);
begin
  qr_islem.ParamByName('PROTOKOL_NO').Value := qr_protokolBASVURU_NO.Value;
  qr_islem.Execute;
  cxPageControl1.ActivePage := cxTabSheet1;
  cxGrid2DBTableView1.ApplyBestFit();

end;

procedure Tf_main.cxButton3Click(Sender: TObject);
begin
  qr_vezne.ParamByName('PROTOKOL_NO').Value := qr_protokolBASVURU_NO.Value;
  qr_vezne.Execute;
  cxPageControl1.ActivePage := cxTabSheet3;
  cxGrid4DBTableView1.ApplyBestFit();
end;

procedure Tf_main.cxButton5Click(Sender: TObject);
begin
  qr_epikriz.ParamByName('PROTOKOL_NO').Value := qr_protokolBASVURU_NO.Value;
  qr_epikriz.Execute;
  qr_epikriz.First;
  cxMemo1.Lines.Clear;

  while not qr_epikriz.Eof do
  begin
    cxMemo1.Lines.Add(qr_epikrizEPIKRIZ_BILGISI_ACIKLAMA.Value);

    qr_epikriz.Next;
  end;
  cxPageControl1.ActivePage := cxTabSheet4;

  cxMemo1.Text := cxMemo1.Text + ' ';
end;

procedure Tf_main.cxButton6Click(Sender: TObject);
begin
  qr_recete.ParamByName('PROTOKOL_NO').Value := qr_protokolBASVURU_NO.Value;
  qr_recete.Execute;
  cxPageControl1.ActivePage := cxTabSheet5;

end;

procedure Tf_main.cxButton7Click(Sender: TObject);
begin
  qr_tani.ParamByName('PROTOKOL_NO').Value := qr_protokolBASVURU_NO.Value;
  qr_tani.Execute;
  cxPageControl1.ActivePage := cxTabSheet7;
  cxGrid6DBTableView1.ApplyBestFit();
end;

procedure Tf_main.cxGrid1DBTableView1CellClick(Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
  AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  m_detay_ara;
end;

procedure Tf_main.cxGrid1DBTableView1CellDblClick(Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
  AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  m_detay_ara;
end;

procedure Tf_main.cxGrid1DBTableView1DblClick(Sender: TObject);
begin
  m_detay_ara;

end;

procedure Tf_main.m_kimlik_ara;

begin
  if (cxTextEdit2.Text = '') then
  begin
    ShowMessage('Lütfen dosya Yada TC Giriniz');
    exit;
  end;

  qr_kimlik.SQL[14] := '((a.tc_kimlik_numarasi=''' + cxTextEdit2.Text + '''))';

  qr_kimlik.Execute;

  while not qr_kimlik.Eof do
  begin
    lb_adisoyadi.Caption := qr_kimlikAD.Text;
    lb_anneadi.Caption := qr_kimlikANNE_ADI.Text;
    lb_babaadi.Caption := qr_kimlikBABA_ADI.Text;
    lb_dogum.Caption := qr_kimlikDOGUM_TARIHI.Text;
    lb_dogumyeri.Caption := qr_kimlikDOGUM_YERI.Text;
    lb_cinsiyet.Caption := qr_kimlikCINSIYET.Text;
    lb_ulke.Caption := qr_kimlikUYRUK.Text;
    lb_sonkurum.Caption := qr_kimlikSON_KURUM_KODU.Text;
    ln_kayitacan.Caption := qr_kimlikEKLEYEN_KULLANICI_KODU.Text;
    qr_kimlik.Next;
  end;
  if qr_kimlik.RecNo < 1 then
  begin
    ShowMessage('Aranan Kayýt Bulunamadý');
    exit;
  end;

  qr_protokol.ParamByName('DOSYA_NO').Value := qr_kimlikHASTA_KODU.Text;
  qr_protokol.Execute;

end;

procedure Tf_main.Protokol1Click(Sender: TObject);
begin
  try

    SaveDialog1.InitialDir := ExtractFilePath(SaveDialog1.FileName);
    SaveDialog1.Filter := 'Excel files (*.xls)|*.xlsx';
    SaveDialog1.FileName := 'Protokol Listesi ';
    SaveDialog1.Execute();

    ExportGridToXLSX(SaveDialog1.FileName, cxGrid1, true, true, true, 'xlsx')
  except
    on E: Exception do
      ShowMessage('Excele Aktarým Baþarýsýz,olasý hata' + sLineBreak + E.Message);
  end;
end;

procedure Tf_main.Reete1Click(Sender: TObject);
begin
  try

    SaveDialog1.InitialDir := ExtractFilePath(SaveDialog1.FileName);
    SaveDialog1.Filter := 'Excel files (*.xls)|*.xlsx';
    SaveDialog1.FileName := 'Reçete Listesi ';
    SaveDialog1.Execute();

    ExportGridToXLSX(SaveDialog1.FileName, cxGrid5, true, true, true, 'xlsx')
  except
    on E: Exception do
      ShowMessage('Excele Aktarým Baþarýsýz,olasý hata' + sLineBreak + E.Message);
  end;
end;

procedure Tf_main.Vezne1Click(Sender: TObject);
begin
  try

    SaveDialog1.InitialDir := ExtractFilePath(SaveDialog1.FileName);
    SaveDialog1.Filter := 'Excel files (*.xls)|*.xlsx';
    SaveDialog1.FileName := 'Vezne Listesi ';
    SaveDialog1.Execute();

    ExportGridToXLSX(SaveDialog1.FileName, cxGrid4, true, true, true, 'xlsx')
  except
    on E: Exception do
      ShowMessage('Excele Aktarým Baþarýsýz,olasý hata' + sLineBreak + E.Message);
  end;
end;

procedure Tf_main.m_detay_ara;
begin
  cxButton2.Enabled := false;
  cxButton11.Enabled := false;
  cxButton3.Enabled := false;
  cxButton5.Enabled := false;
  cxButton6.Enabled := false;
  cxButton7.Enabled := false;
  cxButton10.Enabled := false;
  qr_islem.ParamByName('protokol_no').Value := qr_protokolBASVURU_NO.Value;
  qr_islem.Execute;

  qr_fatura.ParamByName('protokol_no').Value := qr_protokolBASVURU_NO.Value;
  qr_fatura.Execute;

  qr_vezne.ParamByName('protokol_no').Value := qr_protokolBASVURU_NO.Value;
  qr_vezne.Execute;

  qr_recete.ParamByName('protokol_no').Value := qr_protokolBASVURU_NO.Value;
  qr_recete.Execute;

  qr_epikriz.ParamByName('protokol_no').Value := qr_protokolBASVURU_NO.Value;
  qr_epikriz.Execute;

  qr_konsul.ParamByName('protokol_no').Value := qr_protokolBASVURU_NO.Value;
  qr_konsul.Execute;

  qr_tani.ParamByName('protokol_no').Value := qr_protokolBASVURU_NO.Value;
  qr_tani.Execute;

  if qr_islem.RecNo > 0 then
    cxButton2.Enabled := true;
  if qr_fatura.RecNo > 0 then
    cxButton11.Enabled := true;
  if qr_vezne.RecNo > 0 then
    cxButton3.Enabled := true;
  if qr_epikriz.RecNo > 0 then
    cxButton5.Enabled := true;
  if qr_recete.RecNo > 0 then
    cxButton6.Enabled := true;
  if qr_vezne.RecNo > 0 then
    cxButton3.Enabled := true;
  if qr_konsul.RecNo > 0 then
    cxButton10.Enabled := true;
  if qr_tani.RecNo > 0 then
    cxButton7.Enabled := true;
end;

procedure Tf_main.cxMemo1Click(Sender: TObject);
begin
  // show
end;

procedure Tf_main.cxTextEdit1KeyPress(Sender: TObject; var Key: Char);
begin

  if Key = #13 then
  begin
    if (cxTextEdit1.Text = '') then
    begin
      ShowMessage('Lütfen dosya Yada TC Giriniz');
      exit;
    end;

    qr_kimlik.SQL[13] := '((a.hasta_kodu=' + cxTextEdit1.Text + '))';

    qr_kimlik.Execute;

    while not qr_kimlik.Eof do
    begin
      lb_adisoyadi.Caption := qr_kimlikAD.Text;
      lb_anneadi.Caption := qr_kimlikANNE_ADI.Text;
      lb_babaadi.Caption := qr_kimlikBABA_ADI.Text;
      lb_dogum.Caption := qr_kimlikDOGUM_TARIHI.Text;
      lb_dogumyeri.Caption := qr_kimlikDOGUM_YERI.Text;
      lb_cinsiyet.Caption := qr_kimlikCINSIYET.Text;
      lb_ulke.Caption := qr_kimlikUYRUK.Text;
      lb_sonkurum.Caption := qr_kimlikSON_KURUM_KODU.Text;
      ln_kayitacan.Caption := qr_kimlikEKLEYEN_KULLANICI_KODU.Text;
      qr_kimlik.Next;
    end;
    if qr_kimlik.RecNo < 1 then
    begin
      ShowMessage('Aranan Kayýt Bulunamadý');
      qr_protokol.ParamByName('DOSYA_NO').Value := 0;
      qr_protokol.Execute;
      exit;
    end
    else
    begin
      qr_protokol.ParamByName('DOSYA_NO').Value := qr_kimlikHASTA_KODU.Text;
      qr_protokol.Execute;

    end;
  end;
end;

procedure Tf_main.cxTextEdit2KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    if (cxTextEdit2.Text = '') then
    begin
      ShowMessage('Lütfen dosya Yada TC Giriniz');
      exit;
    end;

    qr_kimlik.SQL[13] := '((a.tc_kimlik_numarasi=''' + cxTextEdit2.Text + '''))';

    qr_kimlik.Execute;

    while not qr_kimlik.Eof do
    begin
      lb_adisoyadi.Caption := qr_kimlikAD.Text;
      lb_anneadi.Caption := qr_kimlikANNE_ADI.Text;
      lb_babaadi.Caption := qr_kimlikBABA_ADI.Text;
      lb_dogum.Caption := qr_kimlikDOGUM_TARIHI.Text;
      lb_dogumyeri.Caption := qr_kimlikDOGUM_YERI.Text;
      lb_cinsiyet.Caption := qr_kimlikCINSIYET.Text;
      lb_ulke.Caption := qr_kimlikUYRUK.Text;
      lb_sonkurum.Caption := qr_kimlikSON_KURUM_KODU.Text;
      ln_kayitacan.Caption := qr_kimlikEKLEYEN_KULLANICI_KODU.Text;
      qr_kimlik.Next;
    end;
    if qr_kimlik.RecNo < 1 then
    begin
      ShowMessage('Aranan Kayýt Bulunamadý');
      qr_protokol.ParamByName('DOSYA_NO').Value := 0;
      qr_protokol.Execute;
      exit;
    end
    else
    begin
      qr_protokol.ParamByName('DOSYA_NO').Value := qr_kimlikHASTA_KODU.Text;
      qr_protokol.Execute;

    end;

  end;

end;

procedure Tf_main.FAturaDkm1Click(Sender: TObject);
begin
  try

    SaveDialog1.InitialDir := ExtractFilePath(SaveDialog1.FileName);
    SaveDialog1.Filter := 'Excel files (*.xls)|*.xlsx';
    SaveDialog1.FileName := 'Fatura Listesi ';
    SaveDialog1.Execute();

    ExportGridToXLSX(SaveDialog1.FileName, cxGrid3, true, true, true, 'xlsx')
  except
    on E: Exception do
      ShowMessage('Excele Aktarým Baþarýsýz,olasý hata' + sLineBreak + E.Message);
  end;
end;

procedure Tf_main.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

procedure Tf_main.FormResize(Sender: TObject);
begin
  // cxGrid2.Align := alClient;
end;

procedure Tf_main.FormShow(Sender: TObject);
begin
  cxButton2.Enabled := false;
  cxButton11.Enabled := false;
  cxButton3.Enabled := false;
  cxButton5.Enabled := false;
  cxButton6.Enabled := false;
  cxButton7.Enabled := false;
  cxButton10.Enabled := false;
  qr_kimlik.Active := true;
  qr_protokol.Active := true;
  qr_islem.Active := true;
  qr_fatura.Active := true;
  qr_epikriz.Active := true;
  qr_konsul.Active := true;
  qr_tani.Active := true;
  qr_vezne.Active := true;
  qr_recete.Active := true;
end;

procedure Tf_main.lemler1Click(Sender: TObject);
begin
  try

    SaveDialog1.InitialDir := ExtractFilePath(SaveDialog1.FileName);
    SaveDialog1.Filter := 'Excel files (*.xls)|*.xlsx';
    SaveDialog1.FileName := 'Ýþlemler Listesi ';
    SaveDialog1.Execute();

    ExportGridToXLSX(SaveDialog1.FileName, cxGrid2, true, true, true, 'xlsx')
  except
    on E: Exception do
      ShowMessage('Excele Aktarým Baþarýsýz,olasý hata' + sLineBreak + E.Message);
  end;
end;

procedure Tf_main.lemleriAktar1Click(Sender: TObject);
begin
  try

    SaveDialog1.InitialDir := ExtractFilePath(SaveDialog1.FileName);
    SaveDialog1.Filter := 'Excel files (*.xls)|*.xlsx';
    SaveDialog1.FileName := 'Ýþlem Listesi ';
    SaveDialog1.Execute();

    ExportGridToXLSX(SaveDialog1.FileName, cxGrid1, true, true, true, 'xlsx')
  except
    on E: Exception do
      ShowMessage('Excele Aktarým Baþarýsýz,olasý hata' + sLineBreak + E.Message);
  end;
end;

end.
