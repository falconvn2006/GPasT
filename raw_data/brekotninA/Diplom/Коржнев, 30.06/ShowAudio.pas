unit ShowAudio;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sButton, sLabel, MPlayer, ExtCtrls, sPanel;

type
  TShowAudioForm = class(TForm)
    sPanel2: TsPanel;
    sButton1: TsButton;
    sButton2: TsButton;
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
  ShowAudioForm: TShowAudioForm;

implementation

{$R *.dfm}

procedure TShowAudioForm.FormShow(Sender: TObject);
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
