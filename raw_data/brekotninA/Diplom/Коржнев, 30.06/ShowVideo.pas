unit ShowVideo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MPlayer, StdCtrls, sButton, ExtCtrls, sPanel, sLabel;

type
  TShowVideoForm = class(TForm)
    sPanel2: TsPanel;
    sButton1: TsButton;
    sButton2: TsButton;
    sPanel3: TsPanel;
    MediaPlayer1: TMediaPlayer;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FileName:string;
    Mode:integer;
  end;


var
  ShowVideoForm: TShowVideoForm;

implementation

{$R *.dfm}

procedure TShowVideoForm.FormShow(Sender: TObject);
begin
  if Mode=0 then
    begin
      sButton1.Caption:='OK';
      sButton2.Enabled:=true;
      sButton2.Visible:=true;
    end;
  if Mode=1 then
    begin
      sButton1.Caption:='Закрыть';
      sButton2.Enabled:=False;
      sButton2.Visible:=False;
    end;
end;

end.
