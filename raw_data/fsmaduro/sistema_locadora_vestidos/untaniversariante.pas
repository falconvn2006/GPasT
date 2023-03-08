unit untaniversariante;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RxGIF, ExtCtrls, rxAnimate, rxGIFCtrl;

type
  TfrmAniversariante = class(TForm)
    RxGIFAnimator1: TRxGIFAnimator;
    procedure RxGIFAnimator1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAniversariante: TfrmAniversariante;

implementation

{$R *.dfm}

procedure TfrmAniversariante.FormActivate(Sender: TObject);
begin
  top := 105;
  left := 218;
end;

procedure TfrmAniversariante.RxGIFAnimator1Click(Sender: TObject);
begin
  frmAniversariante.Close;
end;

end.
