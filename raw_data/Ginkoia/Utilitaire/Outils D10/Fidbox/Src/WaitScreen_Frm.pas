unit WaitScreen_Frm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.GIFImg;

type
  TFrm_WaitScreen = class(TForm)
    Img_Spinner: TImage;
    Lbl_PleaseWait: TLabel;
    Pnl_WaitScreen: TPanel;
    Lbl_Annuler: TLabel;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
    FCanClose: Boolean;
  public
    { Déclarations publiques }
    class function ShowWaitScreen(aParent: TObject): TFrm_WaitScreen;
    procedure AllowClose;
  end;

implementation

{$R *.dfm}
{ TFrm_WaitScreen }

procedure TFrm_WaitScreen.AllowClose;
begin
  FCanClose := True;
end;

procedure TFrm_WaitScreen.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := FCanClose;
end;

procedure TFrm_WaitScreen.FormCreate(Sender: TObject);
begin
  (Img_Spinner.Picture.Graphic as TGIFImage).Animate := True;
end;

class function TFrm_WaitScreen.ShowWaitScreen(aParent: TObject)
  : TFrm_WaitScreen;
begin
  Result := Self.Create(TWinControl(aParent));
  if Assigned(aParent) then
  begin
    Result.Parent := aParent as TWinControl;
  end;
  Result.Left := (TForm(aParent).Width - Result.Width) div 2;
  Result.Top := (TForm(aParent).Height - Result.Height) div 2;
  Result.Show;

  Result.Update;
  Result.BringToFront;
end;

end.
