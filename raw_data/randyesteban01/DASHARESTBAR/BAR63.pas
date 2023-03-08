unit BAR63;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, DB, ADODB, Grids, DBGrids;

type
  TfrmClientes = class(TForm)
    Panel1: TPanel;
    btclose: TSpeedButton;
    btedit: TSpeedButton;
    btadd: TSpeedButton;
    QClientes: TADOQuery;
    dsClientes: TDataSource;
    QClientesClienteID: TAutoIncField;
    QClientesNombre: TWideStringField;
    QClientesDireccion: TMemoField;
    QClientesTelefono1: TWideStringField;
    QClientesTelefono2: TWideStringField;
    QClientesEstatus: TWideStringField;
    QClientesBalance: TBCDField;
    QClientesLimite: TBCDField;
    QClientesRNC: TWideStringField;
    DBGrid1: TDBGrid;
    procedure btcloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure bteditClick(Sender: TObject);
    procedure btaddClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  end;

var
  frmClientes: TfrmClientes;

implementation
 uses BAR04, BAR06, BAR64, BAR57, BAR01;
{$R *.dfm}

procedure TfrmClientes.btcloseClick(Sender: TObject);
begin
close;
end;

procedure TfrmClientes.FormCreate(Sender: TObject);
begin
  btclose.Caption := 'F1'+#13+'SALIR';
  btedit.Caption  := 'F2'+#13+'CAMBIAR';
  btadd.Caption   := 'F3'+#13+'CREAR';
end;

procedure TfrmClientes.FormActivate(Sender: TObject);
begin
  if not QClientes.Active then QClientes.Open;
end;

procedure TfrmClientes.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssAlt in Shift) and (key = vk_f4) then abort;
  if key = vk_f1 then btcloseClick(Self);
  if key = vk_f2 then bteditClick(Self);
  if key = vk_f3 then btaddClick(self);
end;

procedure TfrmClientes.bteditClick(Sender: TObject);
var
  t : TBookmark;
begin
  Application.CreateForm(tfrmActClientes, frmActClientes);
  frmActClientes.QClientes.Parameters.ParamByName('id').Value := QClientesClienteID.Value;
  frmActClientes.QClientes.Open;
  frmActClientes.QClientes.Edit;
  frmActClientes.ShowModal;
  if frmActClientes.Grabo = 1 then
  begin
    t := frmActClientes.QClientes.GetBookmark;
    QClientes.Close;
    QClientes.Open;
    QClientes.GotoBookmark(t);
  end;
  frmActClientes.Release;
end;

procedure TfrmClientes.btaddClick(Sender: TObject);
var
  t : TBookmark;
begin
  Application.CreateForm(TfrmActClientes, frmActClientes);
  frmActClientes.QClientes.Parameters.ParamByName('id').Value := -1;
  frmActClientes.QClientes.Open;
  frmActClientes.QClientes.Insert;
  frmActClientes.ShowModal;
  if frmActClientes.Grabo = 1 then
  begin
    t := frmActClientes.QClientes.GetBookmark;
    QClientes.Close;
    QClientes.Open;
    QClientes.GotoBookmark(t);
  end;
  frmActClientes.Release;
end;

procedure TfrmClientes.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  frmMain.Panel1.Enabled := true;
  Action := cafree;
end;

end.
