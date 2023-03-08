unit Start;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sLabel, ExtCtrls, shellapi, jpeg, acPNG;

type
  TStartForm = class(TForm)
    sLabel1: TsLabel;
    Timer1: TTimer;
    sLabel2: TsLabel;
    sLabel3: TsLabel;
    sLabel4: TsLabel;
    Image1: TImage;
    sLabel5: TsLabel;
    sLabel7: TsLabel;
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure sLabel4MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  StartForm: TStartForm;
  time:integer;

implementation


uses Entry, Misc;

{$R *.dfm}

procedure TStartForm.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  Cursor:=crDefault;
end;

procedure TStartForm.FormShow(Sender: TObject);
var             
  ResStream:TResourceStream;
begin
  time:=3;
  Timer1.Enabled:=true;
end;

procedure TStartForm.sLabel4MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  Cursor:=crHandPoint;
end;

procedure TStartForm.Timer1Timer(Sender: TObject);
begin
  time:=time-1;
  if time=0 then
    begin
      Timer1.Enabled:=false;
      StartForm.Visible:=false;
      fEntry.show;
    end;
end;

procedure TStartForm.FormClick(Sender: TObject);
begin
  Timer1.Enabled:=false;
  StartForm.Visible:=false;
  fEntry.show;
end;

procedure TStartForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key=#13) or (Key=#32) then
    FormClick(Sender);
end;

end.
