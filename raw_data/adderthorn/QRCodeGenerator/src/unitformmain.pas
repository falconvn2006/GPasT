unit UnitFormMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  QlpIQrCode, QlpQrCode, QlpQrSegment, QlpQRCodeGenLibTypes;

type

  { TFormMain }

  TFormMain = class(TForm)
    ImageQRCode: TImage;
    MemoInput: TMemo;
    PanelTop: TPanel;
    PanelBottom: TPanel;
    Splitter: TSplitter;
    procedure MemoInputChange(Sender: TObject);
  private
    procedure GenerateQR();
  public

  end;

const
  ECC_LEVEL=TQrCode.TEcc.eccLow;

var
  FormMain: TFormMain;

implementation

procedure TFormMain.MemoInputChange(Sender: TObject);
begin
  GenerateQR();
end;

procedure TFormMain.GenerateQR;
var
  InputText: String;
  AQrCode: IQrCode;
  ABitmap: TQRCodeGenLibBitmap;
  AnEncoding: TEncoding;
begin
  InputText:=MemoInput.Lines.Text;
  AnEncoding:=TEncoding.UTF8;
  AQrCode:=TQrCode.EncodeText(InputText, ECC_LEVEL, AnEncoding);
  ABitmap:=AQrCode.ToBitmapImage(1, 1);
  ImageQRCode.Picture.Assign(ABitmap);
end;

{$R *.lfm}

end.

