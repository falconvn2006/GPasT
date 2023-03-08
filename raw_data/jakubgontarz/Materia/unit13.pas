unit Unit13;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, maskedit, Spin;

type

  { TForm13 }

  TForm13 = class(TForm)
    Button10: TButton;
    Button12: TButton;
    Button2: TButton;
    Edit3: TEdit;
    FloatSpinEdit1: TFloatSpinEdit;
    Label2: TLabel;
    Label3: TLabel;
    ToggleBox1: TToggleBox;
    TrackBar1: TTrackBar;
    procedure Button10Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure floatspinedit1Change(Sender: TObject);
    procedure edit3Change(Sender: TObject);
    procedure ToggleBox1Change(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure TrackBar1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
      );
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form13: TForm13;
  v:real;

implementation

{$R *.lfm}

{ TForm13 }

uses
  Unit1;

procedure TForm13.Button12Click(Sender: TObject);
begin
  close;
end;

procedure TForm13.Button2Click(Sender: TObject);
begin
   button2.setfocus;
  if (pretlw=trunc(pretlw)) and (pretlw>=1) and (pretlw<=Le) then
  begin tryb:=45;close end else MessageDlg('Ostrzeżenie', 'Sprawdź numer pręta!', mtError, [mbOK], 0);
end;

procedure TForm13.Button10Click(Sender: TObject);
begin
  floatspinedit1.value:=1-floatspinedit1.value;
  floatspinedit1.SetFocus;
end;

procedure TForm13.FormActivate(Sender: TObject);
begin
  togglebox1.Checked:=false; edit3.Text:=inttostr(pretlw);
end;

procedure TForm13.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  button12.setfocus;okienko:=2; form13open:=false; form1.Show;
end;

procedure TForm13.FormShow(Sender: TObject);
begin
  form13.Left:=form1.left+form1.Width-form13.width-10;
  form13.top:=form1.top+form1.ToolBar1.Height+70;
end;

procedure TForm13.floatspinedit1Change(Sender: TObject);
begin
  form13x:=floatspinedit1.value;
  trackbar1.position:=trunc(form13x*100);
  if trackbar1.focused=false then floatspinedit1.setfocus;
end;

procedure TForm13.edit3Change(Sender: TObject);
begin
  trystrtoint(edit3.text,pretlw);
  edit3.setfocus;
end;

procedure TForm13.ToggleBox1Change(Sender: TObject);
begin
  if togglebox1.Checked=true then tryb:=44 else tryb:=0;
end;

procedure TForm13.TrackBar1Change(Sender: TObject);
begin
  if trackbar1.focused=true then floatspinedit1.value:=trackbar1.Position/100;
end;

procedure TForm13.TrackBar1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  floatspinedit1.setfocus;
end;

end.

