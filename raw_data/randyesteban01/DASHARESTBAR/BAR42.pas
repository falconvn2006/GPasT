unit BAR42;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, DBCtrls, DB, ADODB, StdCtrls;

type
  TfrmCheque = class(TForm)
    btclose: TSpeedButton;
    btteclado: TSpeedButton;
    btok: TSpeedButton;
    QBancos: TADOQuery;
    QBancosBancoID: TAutoIncField;
    QBancosNombre: TWideStringField;
    dsBancos: TDataSource;
    DBLookupComboBox1: TDBLookupComboBox;
    StaticText2: TStaticText;
    edcheque: TEdit;
    StaticText3: TStaticText;
    edmonto: TEdit;
    lbtotal: TStaticText;
    procedure FormCreate(Sender: TObject);
    procedure bttecladoClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btcloseClick(Sender: TObject);
    procedure btokClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    total : double;
    acepto : integer;
  end;

var
  frmCheque: TfrmCheque;

implementation

uses BAR00, BAR01, BAR04, BAR33;

{$R *.dfm}

procedure TfrmCheque.FormCreate(Sender: TObject);
begin
  btok.Caption := 'OK' + #13 + 'F10';
  btteclado.Caption := 'F3' + #13 + 'TECLADO';
end;

procedure TfrmCheque.bttecladoClick(Sender: TObject);
begin
  Application.CreateForm(tfrmTeclado, frmTeclado);
  frmTeclado.ShowModal;
  if frmTeclado.Acepto = 1 then
    if edcheque.Focused then
      edcheque.Text := frmTeclado.edteclado.Text
    else if edmonto.Focused then
      edmonto.Text := frmTeclado.edteclado.Text;

  frmTeclado.Release;
end;

procedure TfrmCheque.FormActivate(Sender: TObject);
begin
  if not QBancos.Active then
  begin
    QBancos.Open;
    DBLookupComboBox1.KeyValue := QBancosBancoID.Value;
  end;
end;

procedure TfrmCheque.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_f1  then btcloseClick(Self);
  if key = vk_f3  then bttecladoClick(Self);
  if key = vk_f10 then btokClick(Self);
end;

procedure TfrmCheque.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    perform(wm_nextdlgctl, 0, 0);
    key := #0;
  end;
end;

procedure TfrmCheque.btcloseClick(Sender: TObject);
begin
  Acepto := 0;
  Close;
end;

procedure TfrmCheque.btokClick(Sender: TObject);
begin
  if length(Trim(edcheque.Text)) < 1 then
  begin
    MessageDlg('DEBE DEGITAR EL NUMERO DEL CHEQUE',mtError,[mbok],0);
    edcheque.SetFocus;
  end
  else if strtofloat(trim(edmonto.Text)) <= 0 then
  begin
    MessageDlg('EL MONTO NO PUEDE SER CERO (0)',mtError,[mbok],0);
    edmonto.SetFocus;
  end
  else
  begin
    Acepto := 1;
    Close;
  end;
end;

end.
