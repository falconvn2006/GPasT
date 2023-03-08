unit login;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkroom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMetropolis, dxSkinMetropolisDark, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinOffice2013DarkGray, dxSkinOffice2013LightGray, dxSkinOffice2013White, dxSkinOffice2016Colorful, dxSkinOffice2016Dark,
  dxSkinOffice2019Colorful, dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver, dxSkinSpringtime,
  dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld, dxSkinTheBezier, dxSkinsDefaultPainters, dxSkinValentine,
  dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark, dxSkinVisualStudio2013Light, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  cxGroupBox, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxTextEdit, cxLabel, cxClasses, dxSkinsForm, dxGDIPlusClasses, cxImage, Vcl.ExtCtrls;

type
  Tf_login = class(TForm)
    cxGroupBox1: TcxGroupBox;
    cxLabel1: TcxLabel;
    cxTextEdit1: TcxTextEdit;
    cxButton1: TcxButton;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    cxTextEdit3: TcxTextEdit;
    cxButton2: TcxButton;
    Edit1: TEdit;
    dxSkinController1: TdxSkinController;
    Image1: TImage;
    Image2: TImage;
    procedure cxButton2Click(Sender: TObject);
    procedure cxButton1Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure cxTextEdit3KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  f_login: Tf_login;

implementation

{$R *.dfm}

uses datamodul, main;

procedure Tf_login.cxButton1Click(Sender: TObject);
var
  f_main: Tf_main;
begin
  try
    dm.OraSession1.Username := cxTextEdit1.Text;
    dm.OraSession1.Password := Edit1.Text;
    dm.OraSession1.Server := cxTextEdit3.Text;
    dm.OraSession1.Connect;

    try
      f_main := Tf_main.Create(self);
      f_main.Show;
      f_login.hide;
    finally

    end;
  except
    on E: Exception do
      ShowMessage('Giriþ Red Edildi, olasý hata' + sLineBreak + E.Message);
  end;
end;

procedure Tf_login.cxButton2Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure Tf_login.cxTextEdit3KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    cxButton1.Click
end;

procedure Tf_login.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    cxButton1.Click
end;

end.
