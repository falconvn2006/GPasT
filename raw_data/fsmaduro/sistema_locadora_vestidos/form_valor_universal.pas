unit form_valor_universal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, DBCtrls, DB, IBCustomDataSet, IBQuery,
  RxLookup;

type
  TValor_Universal = class(TForm)
    btn_ok: TSpeedButton;
    lblPergunta: TLabel;
    edtValor: TEdit;
    procedure FormShow(Sender: TObject);
    procedure edtValorKeyPress(Sender: TObject; var Key: Char);
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    OK: Boolean;
    { Public declarations }
  end;

var
  Valor_Universal: TValor_Universal;

implementation


{$R *.dfm}

procedure TValor_Universal.FormShow(Sender: TObject);
begin
  TOP := 175;
  LEFT := 185;
end;

procedure TValor_Universal.edtValorKeyPress(Sender: TObject;
  var Key: Char);
begin
  if key = #13 then
    btn_ok.Click
  else if key = #27 then
    Close;
end;

procedure TValor_Universal.btn_okClick(Sender: TObject);
begin
  OK := True;
  Close;
end;

end.
