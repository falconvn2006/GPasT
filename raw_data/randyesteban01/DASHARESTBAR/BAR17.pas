unit BAR17;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmDevuelta = class(TForm)
    lbdevuelta: TStaticText;
    Timer1: TTimer;
    Label1: TLabel;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    vSegundos : integer;
  end;

var
  frmDevuelta: TfrmDevuelta;

implementation

{$R *.dfm}

procedure TfrmDevuelta.FormCreate(Sender: TObject);
begin
  vSegundos := 20;
end;

procedure TfrmDevuelta.Timer1Timer(Sender: TObject);
begin
  if vSegundos <= 0 then frmDevuelta.Close;
  vSegundos := vSegundos - 1;
  Label1.Caption := IntTostr(vSegundos)+' Segs. para SALIR';
end;

procedure TfrmDevuelta.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssAlt in Shift) and (key = vk_f4) then abort;
end;

procedure TfrmDevuelta.Button1Click(Sender: TObject);
begin
close;
end;

end.
