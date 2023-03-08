unit MapGinkoiaView_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UMapping, ExtCtrls, StdCtrls ;

type
  TForm1 = class(TForm)
    chkGinkoia: TCheckBox;
    chkCaisse: TCheckBox;
    chkLauncher: TCheckBox;
    chkBackup: TCheckBox;
    chkVerification: TCheckBox;
    Timer1: TTimer;
    chkMajAuto: TCheckBox;
    chkLiveUpdate: TCheckBox;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure chkGinkoiaClick(Sender: TObject);
  private
    MapGinkoia : TMapGinkoia ;
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.chkGinkoiaClick(Sender: TObject);
var
  aCheckbox : TCheckBox ;
begin
  if Sender is TCheckbox then
  begin
    aCheckbox := Sender as TCheckBox ;
  end;
    if aCheckbox = chkGinkoia
      then MapGinkoia.Ginkoia := aCheckBox.Checked ;

    if aCheckbox = chkCaisse
      then MapGinkoia.Caisse := aCheckBox.Checked ;

    if aCheckbox = chkLauncher
      then MapGinkoia.Launcher := aCheckBox.Checked ;

    if aCheckbox = chkBackup
      then MapGinkoia.Backup := aCheckBox.Checked ;

    if aCheckbox = chkVerification
      then MapGinkoia.Verifencours := aCheckBox.Checked ;

    if aCheckbox = chkMajAuto
      then MapGinkoia.MajAuto := aCheckBox.Checked ;

    if aCheckBox = chkLiveUpdate
      then MapGinkoia.LiveUpdate := aCheckbox.Checked ;


end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  MapGinkoia := TMapGinkoia.Create ;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  MapGinkoia.Free ;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  chkGinkoia.Checked      := MapGinkoia.Ginkoia ;
  chkCaisse.Checked       := MapGinkoia.Caisse ;
  chkLauncher.Checked     := MapGinkoia.Launcher ;
  chkBackup.Checked       := MapGinkoia.Backup ;
  chkVerification.Checked := MapGinkoia.Verifencours ;
  chkMajAuto.Checked      := MapGinkoia.MajAuto ;
  chkLiveUpdate.Checked   := MapGinkoia.LiveUpdate ;
end;

end.
