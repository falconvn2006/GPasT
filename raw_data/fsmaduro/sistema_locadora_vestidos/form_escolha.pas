unit form_escolha;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, DBCtrls, DB, IBCustomDataSet, IBQuery,
  RxLookup;

type
  TEscolhaUniversal = class(TForm)
    btn_ok: TSpeedButton;
    lblPergunta: TLabel;
    lbItens: TListBox;
    procedure FormShow(Sender: TObject);
    procedure edtValorKeyPress(Sender: TObject; var Key: Char);
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    OK: Boolean;
    Valor: Integer;
    { Public declarations }
  end;

var
  EscolhaUniversal: TEscolhaUniversal;

implementation


{$R *.dfm}

procedure TEscolhaUniversal.FormShow(Sender: TObject);
begin
  TOP := 175;
  LEFT := 185;
  
end;

procedure TEscolhaUniversal.edtValorKeyPress(Sender: TObject;
  var Key: Char);
begin
  if key = #13 then
    btn_ok.Click
  else if key = #27 then
    Close;
end;

procedure TEscolhaUniversal.btn_okClick(Sender: TObject);
begin
  OK := True;
  Valor := lbItens.ItemIndex;
  Close;
end;

end.
