unit UFraCatraca;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.StdCtrls, FMX.Controls.Presentation;

type
  TUfraSaldo = class(TForm)
    lytPrincipal: TLayout;
    lytBluMopLogo: TLayout;
    imgBlumopLogo: TImage;
    RectPrincipal: TRectangle;
    lblSaldo: TLabel;
    btnCatraca: TButton;
    rectCatraca: TRectangle;
    lytBotoes: TLayout;
    lblOutroCartao: TLabel;
    lytLogoOnibus: TLayout;
    imgOnibus: TImage;
    Label1: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  UfraSaldo: TUfraSaldo;

implementation

{$R *.fmx}

end.
