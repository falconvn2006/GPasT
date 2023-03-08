unit BAR03;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls;

type
  TfrmConfirm = class(TForm)
    btsi: TSpeedButton;
    lbtitulo: TLabel;
    btno: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure btsiClick(Sender: TObject);
    procedure btnoClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    accion : string;
  end;

var
  frmConfirm: TfrmConfirm;

implementation

{$R *.dfm}

procedure TfrmConfirm.FormCreate(Sender: TObject);
begin
  btsi.Caption := 'F10'+#13+'SI';
  btno.Caption := 'F1'+#13+'NO';
end;

procedure TfrmConfirm.btsiClick(Sender: TObject);
begin
  accion := 'S';
  Close;
end;

procedure TfrmConfirm.btnoClick(Sender: TObject);
begin
  accion := 'N';
  Close;
end;

procedure TfrmConfirm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssAlt in Shift) and (key = vk_f4) then abort;
  if key = vk_f10 then btsiClick(Self);
  if key = vk_f1 then
  begin
    accion := 'N';
    Close;
  end;
end;

end.
