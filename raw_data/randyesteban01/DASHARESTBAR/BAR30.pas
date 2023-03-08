unit BAR30;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, ComCtrls, ImgList, DB, ADODB, DBCtrls;

type
  TfrmTarjeta = class(TForm)
    btclose: TSpeedButton;
    btok: TSpeedButton;
    ComboBox1: TComboBox;
    QBancos: TADOQuery;
    QBancosBancoID: TAutoIncField;
    QBancosNombre: TWideStringField;
    dsBancos: TDataSource;
    DBLookupComboBox1: TDBLookupComboBox;
    edtarjeta: TEdit;
    StaticText2: TStaticText;
    StaticText1: TStaticText;
    edautorizacion: TEdit;
    btteclado: TSpeedButton;
    edmonto: TEdit;
    lbtotal: TStaticText;
    StaticText3: TStaticText;
    procedure btcloseClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btokClick(Sender: TObject);
    procedure bttecladoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Acepto : integer;
    total : double;
  end;

var
  frmTarjeta: TfrmTarjeta;

implementation

uses BAR04, BAR33;

{$R *.dfm}

procedure TfrmTarjeta.btcloseClick(Sender: TObject);
begin
  Acepto := 0;
  Close;
end;

procedure TfrmTarjeta.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_f1  then btcloseClick(Self);
  if key = vk_f1  then bttecladoClick(Self);
  if key = vk_f10 then btokClick(Self);
end;

procedure TfrmTarjeta.FormCreate(Sender: TObject);
begin
  btok.Caption := 'OK' + #13 + 'F10';
  btteclado.Caption := 'F3' + #13 + 'TECLADO';
end;

procedure TfrmTarjeta.FormActivate(Sender: TObject);
begin
  if not QBancos.Active then
  begin
    QBancos.Open;
    DBLookupComboBox1.KeyValue := QBancosBancoID.Value;
  end;
end;

procedure TfrmTarjeta.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    perform(wm_nextdlgctl, 0, 0);
    key := #0;
  end;
end;

procedure TfrmTarjeta.btokClick(Sender: TObject);
begin
  if length(Trim(edtarjeta.Text)) < 4 then
  begin
    MessageDlg('DEBE DEGITAR POR LO MENOS 4 NUMEROS DE LA TARJETA',mtError,[mbok],0);
    edtarjeta.SetFocus;
  end
  else if trim(edautorizacion.Text) = '' then
  begin
    MessageDlg('DEBE DEGITAR EL NUMERO DE AUTORIZACION',mtError,[mbok],0);
    edautorizacion.SetFocus;
  end
  else
  begin
    Acepto := 1;
    Close;
  end;
end;

procedure TfrmTarjeta.bttecladoClick(Sender: TObject);
begin
  Application.CreateForm(tfrmTeclado, frmTeclado);
  frmTeclado.ShowModal;
  if frmTeclado.Acepto = 1 then
    if edtarjeta.Focused then
      edtarjeta.Text := frmTeclado.edteclado.Text
    else if edautorizacion.Focused then
      edautorizacion.Text := frmTeclado.edteclado.Text;

  frmTeclado.Release;
end;

end.
