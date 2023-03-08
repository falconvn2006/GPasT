unit BAR06;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons;

type
  TfrmFormaBuscaProducto = class(TForm)
    btcodigo: TSpeedButton;
    btnombre: TSpeedButton;
    btcat: TSpeedButton;
    procedure btcodigoClick(Sender: TObject);
    procedure btnombreClick(Sender: TObject);
    procedure btcatClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    Tipo : string;
  end;

var
  frmFormaBuscaProducto: TfrmFormaBuscaProducto;

implementation

{$R *.dfm}

procedure TfrmFormaBuscaProducto.btcodigoClick(Sender: TObject);
begin
  Tipo := 'COD';
  Close;
end;

procedure TfrmFormaBuscaProducto.btnombreClick(Sender: TObject);
begin
  Tipo := 'NOM';
  Close;
end;

procedure TfrmFormaBuscaProducto.btcatClick(Sender: TObject);
begin
  Tipo := 'CAT';
  Close;
end;

procedure TfrmFormaBuscaProducto.FormKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if key = vk_f1 then btcodigoClick(Self);
  if key = vk_f2 then btnombreClick(Self);
  if key = vk_f3 then btcatClick(Self);
end;

end.
