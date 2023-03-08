unit ShowPicture;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, sButton, sPanel;

type
  TShowPictureForm = class(TForm)
    sPanel2: TsPanel;
    sButton1: TsButton;
    sButton2: TsButton;
    Image1: TImage;
    sPanel1: TsPanel;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FileName:string;
    Mode:integer;
  end;

var
  ShowPictureForm: TShowPictureForm;

implementation

{$R *.dfm}

procedure TShowPictureForm.FormShow(Sender: TObject);
begin
  if (Image1.Width<Image1.Picture.Width) or (Image1.Height<Image1.Picture.Height) then
    Image1.Stretch:=true
  else
    Image1.Stretch:=false;
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
