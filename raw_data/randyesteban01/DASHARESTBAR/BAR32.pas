unit BAR32;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, ExtCtrls;

type
  TfrmNombreCliente = class(TForm)
    btclose: TSpeedButton;
    btteclado: TSpeedButton;
    btaceptar: TSpeedButton;
    Panel2: TPanel;
    edcliente: TEdit;
    lbtipo: TStaticText;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btcloseClick(Sender: TObject);
    procedure btaceptarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Acepto : integer;
  end;

var
  frmNombreCliente: TfrmNombreCliente;

implementation

{$R *.dfm}

procedure TfrmNombreCliente.FormCreate(Sender: TObject);
begin
  btclose.Caption := 'F1'+#13+'SALIR';
  btteclado.Caption := 'F6'+#13+'TECLADO';
  btaceptar.Caption := 'F10'+#13+'ACEPTAR';
end;

procedure TfrmNombreCliente.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_f1  then btcloseClick(Self);
  if key = vk_f10 then btaceptarClick(Self);
end;

procedure TfrmNombreCliente.btcloseClick(Sender: TObject);
begin
  Acepto := 0;
  Close;
end;

procedure TfrmNombreCliente.btaceptarClick(Sender: TObject);
begin
  if trim(edcliente.Text) = '' then
  begin
    MessageDlg('DEBE ESPECIFICAR EL NOMBRE DEL CLIENTE',mtError,[mbok],0);
    edcliente.SetFocus
  end
  else if length(trim(edcliente.Text)) < 10 then
  begin
    MessageDlg('EL NOMBRE DEL CLIENTE DEBE TENER MAS DE 10 LETRAS',mtError,[mbok],0);
    edcliente.SetFocus
  end
  else
  begin
    Acepto := 1;
    Close;
  end;
end;

end.
