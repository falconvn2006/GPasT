unit BAR57;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, StdCtrls, Mask, DBCtrls, DB, ADODB;

type
  TfrmActProveedores = class(TForm)
    Panel1: TPanel;
    btclose: TSpeedButton;
    btpost: TSpeedButton;
    Panel2: TPanel;
    QProveedores: TADOQuery;
    QProveedoresProveedorID: TAutoIncField;
    QProveedoresNombre: TWideStringField;
    QProveedoresrnc: TWideStringField;
    QProveedorestelefono: TWideStringField;
    QProveedoresdireccion: TWideStringField;
    QProveedorescontacto: TWideStringField;
    QProveedoresemail: TWideStringField;
    dsProveedores: TDataSource;
    Label2: TLabel;
    DBEdit2: TDBEdit;
    Label3: TLabel;
    DBEdit3: TDBEdit;
    Label4: TLabel;
    DBEdit4: TDBEdit;
    Label5: TLabel;
    DBEdit5: TDBEdit;
    Label6: TLabel;
    DBEdit6: TDBEdit;
    Label7: TLabel;
    DBEdit7: TDBEdit;
    procedure btpostClick(Sender: TObject);
    procedure btcloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    Grabo : Integer;
  end;

var
  frmActProveedores: TfrmActProveedores;

implementation

{$R *.dfm}

procedure TfrmActProveedores.btpostClick(Sender: TObject);
begin
  QProveedores.Post;
  QProveedores.UpdateBatch;
  Grabo := 1;
  Close;
end;

procedure TfrmActProveedores.btcloseClick(Sender: TObject);
begin
  QProveedores.Cancel;
  Grabo := 0;
  Close;
end;

procedure TfrmActProveedores.FormCreate(Sender: TObject);
begin
  btclose.Caption := 'F1'+#13+'SALIR';
  btpost.Caption  := 'F2'+#13+'GRABAR';
end;

procedure TfrmActProveedores.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_f1 then btcloseClick(Self);
  if key = vk_f2 then btpostClick(Self);
end;

procedure TfrmActProveedores.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = chr(vk_return) then
  begin
    perform(wm_nextdlgctl, 0, 0);
    key := #0;
  end;
end;

end.
