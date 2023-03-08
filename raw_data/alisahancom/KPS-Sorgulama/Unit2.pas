unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkroom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin,
  dxSkinMetropolis, dxSkinMetropolisDark, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinOffice2013DarkGray,
  dxSkinOffice2013LightGray, dxSkinOffice2013White, dxSkinOffice2016Colorful,
  dxSkinOffice2016Dark, dxSkinOffice2019Colorful, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringtime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinTheBezier, dxSkinsDefaultPainters, dxSkinValentine,
  dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, cxGroupBox, cxTextEdit, cxClasses, dxSkinsForm,
  System.ImageList, Vcl.ImgList, cxImageList, Vcl.Menus, cxButtons;

type
  TForm2 = class(TForm)
    cxGroupBox1: TcxGroupBox;
    cxTextEdit1: TcxTextEdit;
    cxTextEdit2: TcxTextEdit;
    cxTextEdit3: TcxTextEdit;
    cxTextEdit4: TcxTextEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    cxTextEdit5: TcxTextEdit;
    sonuc_text: TLabel;
    Label5: TLabel;
    dxSkinController1: TdxSkinController;
    cxImageList1: TcxImageList;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    procedure FormShow(Sender: TObject);
    procedure cxButton2Click(Sender: TObject);
    procedure cxButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

uses KPSPublic;

procedure TForm2.cxButton1Click(Sender: TObject);

var
  tc: KPSPublicSoap;
  sonuc: boolean;
  tc_no: Int64;
  ad: string;
  soyadi: string;
  dogum_yil: integer;

begin
  tc := KPSPublic.GetKPSPublicSoap(true);
  try
    tc_no := StrToInt64(cxTextEdit1.Text);
    // ShowMessage(tc_no.ToString);
  except
    on E: Exception do
      ShowMessage('Yazýlan Tc No Hatalý');
  end;

  try
    dogum_yil := strtoint(cxTextEdit5.Text);
  except
    on E: Exception do
      ShowMessage('Yazýlan Doðum Tarihi Hatalý');
  end;

  sonuc := tc.TCKimlikNoDogrula(tc_no, cxTextEdit2.Text, cxTextEdit3.Text,
    dogum_yil);

  if sonuc = true then
  begin
    // ShowMessage('Tc Doðrulama Hatalý');
    sonuc_text.Font.Color := clGreen;
    sonuc_text.Caption := 'TC Kimlik Baþarýlý';

  end
  else
  begin
    sonuc_text.Font.Color := clRed;
    sonuc_text.Caption := 'TC Kimlik Hatalý';
  end;

end;

procedure TForm2.cxButton2Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm2.FormShow(Sender: TObject);
begin
  // cxTextEdit1.Text := '';
  // cxTextEdit2.Text := '';
  // cxTextEdit3.Text := '';
  // cxTextEdit5.Text := '';
end;

end.
