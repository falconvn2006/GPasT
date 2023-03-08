unit UFrmInfo;

interface

uses
  System.Classes, Vcl.Forms, Vcl.ExtCtrls;

type
  TFrmInfo = class(TForm)
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  FrmInfo: TFrmInfo;

implementation

uses
  Winapi.Windows, System.SysUtils;

{$R *.dfm}

procedure TFrmInfo.FormCreate(Sender: TObject);
begin
  Self.ClientHeight := 0;
  Self.ClientWidth := 370;
end;

procedure TFrmInfo.Timer1Timer(Sender: TObject);
var
  Position: TPoint;
begin
  GetCursorPos(Position);
  Self.Caption := 'Coordonnées de la souris : X=' + IntToStr(Position.X) +
                  ', Y=' + IntToStr(Position.Y);
end;

end.
