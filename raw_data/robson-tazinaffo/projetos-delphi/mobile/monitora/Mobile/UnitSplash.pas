unit UnitSplash;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls;

type
  TfrmSplash = class(TForm)
    Timer1: TTimer;
    lytBase: TLayout;
    imgBackground: TImage;
    Arc1: TArc;
    Image1: TImage;
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSplash: TfrmSplash;

implementation

{$R *.fmx}

uses UnitLogin, UnitPrincipal;

procedure TfrmSplash.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := TCloseAction.caFree;
    frmSplash := nil;
end;

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
         if NOT Assigned(FrmLogin) then
                Application.CreateForm(TFrmLogin, FrmLogin);

            Timer1.Enabled := false;
            FrmLogin.Show;
            Application.MainForm := FrmLogin;
            frmSplash.Close;
    end;


end;

end.
