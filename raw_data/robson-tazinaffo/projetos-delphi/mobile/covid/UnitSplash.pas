unit UnitSplash;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls;

type
  TfrmSplash = class(TForm)
    Arc1: TArc;
    Layout1: TLayout;
    Image1: TImage;
    Circle1: TCircle;
    Label1: TLabel;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSplash: TfrmSplash;

implementation

{$R *.fmx}

uses UnitLogin, UnitPrincipal, UnitInicial;

procedure TfrmSplash.FormShow(Sender: TObject);
begin
    Arc1.StartAngle := 300;
    Arc1.EndAngle   := 0;
    Timer1.Enabled := true;
end;

procedure TfrmSplash.Timer1Timer(Sender: TObject);
begin
    Arc1.EndAngle := Arc1.EndAngle + 50;
    if Arc1.EndAngle >= 400 then begin
//         if NOT Assigned(FrmPrincipal) then
//                Application.CreateForm(TFrmPrincipal, FrmPrincipal);
//            FrmPrincipal.id_usuario_global := id_usuario;
//            Timer1.Enabled := false;
//            FrmPrincipal.Show;
//            Application.MainForm := FrmPrincipal;
//            frmSplash.Close;

         if NOT Assigned(FrmPrincipal) then
                Application.CreateForm(TFrmInicial, FrmInicial);

            Timer1.Enabled := false;
            FrmInicial.Show;
            Application.MainForm := FrmInicial;
            frmSplash.Close;


    end;


end;

end.
