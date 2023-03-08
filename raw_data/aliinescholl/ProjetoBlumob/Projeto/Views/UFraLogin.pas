unit UFraLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit;

type
  TfrmLogin = class(TForm)
    lytPrincipal: TLayout;
    lytBluMopLogo: TLayout;
    imgBlumopLogo: TImage;
    RectPrincipal: TRectangle;
    lblSaldo: TLabel;
    btnAutenticar: TButton;
    rectAutenticar: TRectangle;
    lytBotoes: TLayout;
    lytLogoOnibus: TLayout;
    imgOnibus: TImage;
    RectConsulta: TRectangle;
    EdtNumero: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.fmx}

end.
