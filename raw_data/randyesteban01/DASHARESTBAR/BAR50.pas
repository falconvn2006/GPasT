unit BAR50;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, DB, ADODB, StdCtrls, Mask, DBCtrls,printers;

type
  TfrmActImpresoraRemota = class(TForm)
    Panel1: TPanel;
    btclose: TSpeedButton;
    btpost: TSpeedButton;
    Panel2: TPanel;
    Panel3: TPanel;
    QPrinter_Remoto: TADOQuery;
    dsPrinter: TDataSource;
    Label1: TLabel;
    DBEdit2: TDBEdit;
    Label3: TLabel;
    DBEdit3: TDBEdit;
    QPrinter_RemotoIDPrinter: TAutoIncField;
    QPrinter_RemotoDescripcion: TWideStringField;
    QPrinter_Remotopath_printer: TWideStringField;
    DBEdit1: TDBEdit;
    Label2: TLabel;
    Label4: TLabel;
    DBEdit4: TDBEdit;
    QPrinter_Remotonombre_printer: TWideStringField;
    procedure btcloseClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btpostClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Grabo : Integer;
  end;

var
  frmActImpresoraRemota: TfrmActImpresoraRemota;

implementation

uses BAR04;

{$R *.dfm}

procedure TfrmActImpresoraRemota.btcloseClick(Sender: TObject);
begin
  QPrinter_Remoto.Cancel;
  Grabo := 0;
  Close;
end;

procedure TfrmActImpresoraRemota.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = chr(vk_return) then
  begin
    perform(wm_nextdlgctl, 0, 0);
    key := #0;
  end;
end;

procedure TfrmActImpresoraRemota.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_f1 then btcloseClick(Self);
  if key = vk_f2 then btpostClick(Self);
end;

procedure TfrmActImpresoraRemota.btpostClick(Sender: TObject);
begin
  QPrinter_Remoto.Post;
  QPrinter_Remoto.UpdateBatch;
  Grabo := 1;
  Close;
end;

procedure TfrmActImpresoraRemota.FormCreate(Sender: TObject);

begin
  //asigna el listado de impresora al combox
  btclose.Caption := 'F1'+#13+'SALIR';
  btpost.Caption  := 'F2'+#13+'GRABAR';
end;

end.
