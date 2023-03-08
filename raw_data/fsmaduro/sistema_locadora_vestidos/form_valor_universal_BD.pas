unit form_valor_universal_BD;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, DBCtrls, DB, IBCustomDataSet, IBQuery,
  RxLookup;

type
  TValor_Universal_BD = class(TForm)
    btn_ok: TSpeedButton;
    lblPergunta: TLabel;
    qryConsulta: TIBQuery;
    qryConsultaCODIGO: TIntegerField;
    qryConsultaNOME: TIBStringField;
    dtsConsulta: TDataSource;
    edtValor: TRxDBLookupCombo;
    procedure FormShow(Sender: TObject);
    procedure edtValorKeyPress(Sender: TObject; var Key: Char);
    procedure btn_okClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    OK: Boolean;
    { Public declarations }
  end;

var
  Valor_Universal_BD: TValor_Universal_BD;

implementation


{$R *.dfm}

procedure TValor_Universal_BD.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  OK := True;
end;

procedure TValor_Universal_BD.FormShow(Sender: TObject);
begin
  TOP := 175;
  LEFT := 185;
end;

procedure TValor_Universal_BD.edtValorKeyPress(Sender: TObject;
  var Key: Char);
begin
  if key = #13 then
    btn_ok.Click;
end;

procedure TValor_Universal_BD.btn_okClick(Sender: TObject);
begin
  Close;
end;

end.
