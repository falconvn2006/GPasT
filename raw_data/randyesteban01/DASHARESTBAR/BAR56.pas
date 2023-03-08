unit BAR56;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, Buttons, ExtCtrls, DB, ADODB;

type
  TfrmProveedores = class(TForm)
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    Panel3: TPanel;
    QProveedores: TADOQuery;
    dsProveedores: TDataSource;
    QProveedoresProveedorID: TAutoIncField;
    QProveedoresNombre: TWideStringField;
    QProveedoresrnc: TWideStringField;
    QProveedorestelefono: TWideStringField;
    QProveedoresdireccion: TWideStringField;
    QProveedorescontacto: TWideStringField;
    QProveedoresemail: TWideStringField;
    btclose: TSpeedButton;
    btedit: TSpeedButton;
    btadd: TSpeedButton;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btcloseClick(Sender: TObject);
    procedure bteditClick(Sender: TObject);
    procedure btaddClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmProveedores: TfrmProveedores;

implementation
uses BAR04, BAR06, BAR57, BAR01;

{$R *.dfm}

procedure TfrmProveedores.FormActivate(Sender: TObject);
begin
  if not QProveedores.Active then QProveedores.Open;
end;

procedure TfrmProveedores.FormCreate(Sender: TObject);
begin
  btclose.Caption := 'F1'+#13+'SALIR';
  btedit.Caption  := 'F2'+#13+'CAMBIAR';
  btadd.Caption   := 'F3'+#13+'CREAR';
end;

procedure TfrmProveedores.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssAlt in Shift) and (key = vk_f4) then abort;
  if key = vk_f1 then btcloseClick(Self);
  if key = vk_f2 then bteditClick(Self);
  if key = vk_f3 then btaddClick(self);
end;

procedure TfrmProveedores.btcloseClick(Sender: TObject);
begin
 Close;
end;

procedure TfrmProveedores.bteditClick(Sender: TObject);
var
  t : TBookmark;
begin
  Application.CreateForm(tfrmActProveedores, frmActProveedores);
  frmActProveedores.QProveedores.Parameters.ParamByName('id').Value := QProveedoresProveedorID.Value;
  frmActProveedores.QProveedores.Open;
  frmActProveedores.QProveedores.Edit;
  frmActProveedores.ShowModal;
  if frmActProveedores.Grabo = 1 then
  begin
    t := QProveedores.GetBookmark;
    QProveedores.Close;
    QProveedores.Open;
    QProveedores.GotoBookmark(t);
  end;
  frmActProveedores.Release;
end;

procedure TfrmProveedores.btaddClick(Sender: TObject);
var
  t : TBookmark;
begin
  Application.CreateForm(TfrmActProveedores, frmActProveedores);
  frmActProveedores.QProveedores.Parameters.ParamByName('id').Value := -1;
  frmActProveedores.QProveedores.Open;
  frmActProveedores.QProveedores.Insert;
  frmActProveedores.ShowModal;
  if frmActProveedores.Grabo = 1 then
  begin
    t := QProveedores.GetBookmark;
    QProveedores.Close;
    QProveedores.Open;
    QProveedores.GotoBookmark(t);
  end;
  frmActProveedores.Release;
end;

procedure TfrmProveedores.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  frmMain.Panel1.Enabled := true;
  Action := cafree;
end;

end.
