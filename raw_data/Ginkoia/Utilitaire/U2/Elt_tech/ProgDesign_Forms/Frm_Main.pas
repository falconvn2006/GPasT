unit Frm_Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, RzPanel, GinPanel, AdvGlowButton, StdCtrls, RzLabel;

type
  TForm3 = class(TForm)
    GinPanel1: TGinPanel;
    Pan_Btn: TRzPanel;
    Nbt_Cancel: TRzLabel;
    Lab_OuAnnuler: TRzLabel;
    Nbt_Post: TAdvGlowButton;
    Pan_Modif: TRzPanel;
    AdvGlowButton1: TAdvGlowButton;
    procedure GinPanel1BtnCloseOnClick(Sender: TObject);
    procedure Nbt_PostClick(Sender: TObject);
    procedure Nbt_CancelClick(Sender: TObject);
    procedure GinPanel1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GinPanel1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GinPanel1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure AdvGlowButton1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    bClicked : boolean;
    iX, iY : integer;
    iTop, iLeft : integer;
    { Déclarations publiques }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

procedure TForm3.AdvGlowButton1Click(Sender: TObject);
begin
  Form3.BorderStyle := bsSizeable;
  Pan_Btn.Visible := True;
  Pan_Modif.Visible := Not Pan_Btn.Visible;
end;

procedure TForm3.GinPanel1BtnCloseOnClick(Sender: TObject);
begin
  Close;
end;

procedure TForm3.GinPanel1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
  var
  PosSouris : Tpoint;
begin
  bClicked := true;

  GetCursorPos(PosSouris);
  iX := PosSouris.X;
  iY := PosSouris.Y;
  iTop := Form3.Top;
  iLeft := Form3.Left;
end;

procedure TForm3.GinPanel1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  PosSouris : Tpoint;
begin
  if bClicked then
  begin
    GetCursorPos(PosSouris);
    Form3.Top := iTop + PosSouris.Y - iY;
    Form3.Left := iLeft + PosSouris.X - iX;
//      GetCursorPos(PosSouris);
//  iX := PosSouris.X;
//  iY := PosSouris.Y;
//  iTop := Form3.Top;
//  iLeft := Form3.Left;
  end;

end;

procedure TForm3.GinPanel1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  bClicked := False;
end;

procedure TForm3.Nbt_CancelClick(Sender: TObject);
begin
  Pan_Btn.Visible := false;
  Pan_Modif.Visible := Not Pan_Btn.Visible;
end;

procedure TForm3.Nbt_PostClick(Sender: TObject);
begin
  Form3.BorderStyle := bsNone;
end;

end.
