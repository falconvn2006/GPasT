unit FrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,ShellApi, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, dxSkinsCore, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMetropolis,
  dxSkinMetropolisDark, dxSkinMoneyTwins, dxSkinOffice2007Black,
  dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink,
  dxSkinOffice2007Silver, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2010Silver, dxSkinOffice2013DarkGray, dxSkinOffice2013LightGray,
  dxSkinOffice2013White, dxSkinOffice2016Colorful, dxSkinOffice2016Dark,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinTheBezier, dxSkinsDefaultPainters,
  dxSkinValentine, dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls,NetEncoding,IdURI;

type
  TFrmPrincial = class(TForm)
    PnlCliente: TPanel;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    EdtNumero: TEdit;
    GroupBox1: TGroupBox;
    MemoMsg: TMemo;
    Panel1: TPanel;
    BtnEnviar: TcxButton;
    procedure BtnEnviarClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincial: TFrmPrincial;
  Link_1    : String;
  Link_2    : String;
  Resultado : String;
implementation

uses
  dxGDIPlusAPI;

{$R *.dfm}

procedure TFrmPrincial.BtnEnviarClick(Sender: TObject);
begin
   Link_1    := 'https://web.whatsapp.com/send?phone=';
   Link_2    := '&text= ';
   Resultado := Link_1 + '55' + EdtNumero.Text + Link_2 + '%20' + MemoMsg.Lines.Text;

   if ((EdtNumero.Text = '')or (MemoMsg.Lines.Text = '')) then
   begin
     Showmessage('Preencha todos os campos!');
     exit;
   end
   else
   begin
     ShellExecute(Handle,'open', Pchar(Resultado),nil,nil,SW_SHOWMAXIMIZED);
   end;
end;

procedure TFrmPrincial.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if KEY = VK_ESCAPE then
 begin
    Close;
 end;
end;

end.
