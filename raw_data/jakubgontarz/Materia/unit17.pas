unit Unit17;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls;

type

  { TForm17 }

  TForm17 = class(TForm)
    Button1: TButton;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Panel1: TPanel;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private

  public

  end;

var
  Form17: TForm17;

implementation

uses
  unit1;

{$R *.lfm}

{ TForm17 }

procedure TForm17.Button1Click(Sender: TObject);
begin
  button1.setfocus;
  close;
end;

procedure TForm17.FormShow(Sender: TObject);
begin
  label7.caption:='Wersja: '+wersja;
  if k=1 then begin panel1.Visible:=true; button1.visible:=true; timer1.Destroy; end;
  if k=2 then begin button1.visible:=true; panel1.visible:=true; label2.visible:=true; label1.visible:=false; end;
end;

procedure TForm17.Timer1Timer(Sender: TObject);
begin
  timer1.destroy;
  close;
end;

end.

