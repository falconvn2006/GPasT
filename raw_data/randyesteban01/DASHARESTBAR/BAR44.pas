unit BAR44;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, StdCtrls, Mask, DBCtrls, DB, ADODB;

type
  TfrmActRNC = class(TForm)
    Panel1: TPanel;
    btclose: TSpeedButton;
    btpost: TSpeedButton;
    Panel2: TPanel;
    Label6: TLabel;
    DBEdit1: TDBEdit;
    Label1: TLabel;
    DBEdit2: TDBEdit;
    Label7: TLabel;
    DBEdit3: TDBEdit;
    QRNC: TADOQuery;
    QRNCrnc_cedula: TWideStringField;
    QRNCrazon_social: TWideStringField;
    QRNCnombre_comercial: TWideStringField;
    dsRNC: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btpostClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btcloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmActRNC: TfrmActRNC;

implementation

uses BAR04;

{$R *.dfm}

procedure TfrmActRNC.FormCreate(Sender: TObject);
begin
  btclose.Caption := 'F1'+#13+'SALIR';
  btpost.Caption  := 'F2'+#13+'GRABAR';
end;

procedure TfrmActRNC.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = chr(vk_return) then
  begin
    perform(wm_nextdlgctl, 0, 0);
    key := #0;
  end;
end;

procedure TfrmActRNC.btpostClick(Sender: TObject);
begin
  QRNC.Post;
  QRNC.UpdateBatch;
  Close;
end;

procedure TfrmActRNC.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_f1 then btcloseClick(Self);
  if key = vk_f2 then btpostClick(Self);
end;

procedure TfrmActRNC.btcloseClick(Sender: TObject);
begin
  Close;
end;

end.
