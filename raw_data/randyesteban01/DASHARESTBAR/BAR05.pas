unit BAR05;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, Grids, DBGrids, DB, ADODB, StdCtrls;

type
  TfrmProductos = class(TForm)
    btclose: TSpeedButton;
    btedit: TSpeedButton;
    btadd: TSpeedButton;
    btclon: TSpeedButton;
    Panel1: TPanel;
    DBGrid1: TDBGrid;
    QProductos: TADOQuery;
    QProductosCodigo: TWideStringField;
    QProductosNombre: TWideStringField;
    QProductosPrecio: TBCDField;
    QProductosCategoria: TWideStringField;
    dsProductos: TDataSource;
    Panel2: TPanel;
    btbuscar: TSpeedButton;
    edbusca: TEdit;
    Memo1: TMemo;
    QProductosProductoID: TAutoIncField;
    QProductosExistencia: TFloatField;
    btimprimir: TSpeedButton;
    btresta: TSpeedButton;
    QProductosImpresoraRemota2: TBooleanField;
    procedure FormCreate(Sender: TObject);
    procedure btcloseClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure btbuscarClick(Sender: TObject);
    procedure btaddClick(Sender: TObject);
    procedure bteditClick(Sender: TObject);
    procedure btimprimirClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btrestaClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmProductos: TfrmProductos;

implementation

uses BAR04, BAR06, BAR07, BAR54, BAR01, Math, StrUtils;

{$R *.dfm}

procedure TfrmProductos.FormCreate(Sender: TObject);
begin
  btclose.Caption := 'F1'+#13+'SALIR';
  btedit.Caption  := 'F2'+#13+'MODIFICAR';
  btadd.Caption   := 'F3'+#13+'CREAR';
  btclon.Caption  := 'F4'+#13+'CLONAR';
  btimprimir.Caption := 'F5'+#13+'IMPRIMIR';
  Memo1.Lines := QProductos.SQL;
end;

procedure TfrmProductos.btcloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmProductos.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssAlt in Shift) and (key = vk_f4) then abort;
  if key = vk_f1 then btcloseClick(Self);
  if key = vk_f2 then bteditClick(Self);
  if key = vk_f3 then btaddClick(Self);
  if key = vk_f5 then btimprimirClick(self);
  if key = vk_f8 then btbuscarClick(Self);
end;

procedure TfrmProductos.FormActivate(Sender: TObject);
begin
  if not QProductos.Active then QProductos.Open;
  CurrencyString := '';
end;

procedure TfrmProductos.btbuscarClick(Sender: TObject);
begin
  Application.CreateForm(tfrmFormaBuscaProducto, frmFormaBuscaProducto);
  frmFormaBuscaProducto.ShowModal;
  QProductos.Close;
  QProductos.SQL.Clear;
  QProductos.SQL := Memo1.Lines;
  if frmFormaBuscaProducto.Tipo = 'COD' then
  begin
    QProductos.SQL.Add('where p.pro_roriginal like '+QuotedStr(edbusca.Text+'%'));
    QProductos.SQL.Add('order by c.Nombre ,p.pro_roriginal');
  end
  else if frmFormaBuscaProducto.Tipo = 'NOM' then
  begin
    QProductos.SQL.Add('where p.pro_nombre like '+QuotedStr(edbusca.Text+'%'));
    QProductos.SQL.Add('order by c.Nombre ,p.pro_Nombre');
  end
  else if frmFormaBuscaProducto.Tipo = 'CAT' then
  begin
    QProductos.SQL.Add('where c.Nombre like '+QuotedStr(edbusca.Text+'%'));
    QProductos.SQL.Add('order by c.Nombre');
  end;
  QProductos.Open;
  frmFormaBuscaProducto.Release;
end;

procedure TfrmProductos.btaddClick(Sender: TObject);
var
  t : TBookmark;
begin
  Application.CreateForm(tfrmActProducto, frmActProducto);
  frmActProducto.QProducto.Parameters.ParamByName('pro').Value := -1;
  frmActProducto.QProducto.Open;
  frmActProducto.QProducto.Insert;
  frmActProducto.ShowModal;
  if frmActProducto.Grabo = 1 then
  begin
    t := QProductos.GetBookmark;
    QProductos.Close;
    QProductos.Open;
    QProductos.GotoBookmark(t);
  end;
  frmActProducto.Release;
end;

procedure TfrmProductos.bteditClick(Sender: TObject);
var
  t : TBookmark;
begin
  Application.CreateForm(tfrmActProducto, frmActProducto);
  frmActProducto.QProducto.Close;
  frmActProducto.QProducto.Parameters.ParamByName('pro').Value := QProductosProductoID.Value;
  frmActProducto.QProducto.Open;
  frmActProducto.DBEdit2.ReadOnly := True;
  frmActProducto.QProducto.Edit;
  frmActProducto.ShowModal;
  if frmActProducto.Grabo = 1 then
  begin
    t := QProductos.GetBookmark;
    QProductos.Close;
    QProductos.Open;
    QProductos.GotoBookmark(t);
  end;
  frmActProducto.Release;
end;

procedure TfrmProductos.btimprimirClick(Sender: TObject);
begin
  if not QProductos.IsEmpty then
  begin
    Application.CreateForm(TRProductos, RProductos);
    RProductos.QProductos.Close;
    RProductos.QProductos.sql.Clear;
    RProductos.QProductos.sql.Add(QProductos.sql.Text);
    RProductos.QProductos.Open;
    RProductos.PrinterSetup;
    RProductos.Preview;
    RProductos.Destroy;
  end;

end;

procedure TfrmProductos.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  frmMain.Panel1.Enabled := true;
  Action := cafree;
end;

procedure TfrmProductos.btrestaClick(Sender: TObject);
begin
  if messagedlg('Desea eliminar este producto?',mtconfirmation,[mbyes,mbno],0) = mryes then
  begin
    QProductos.delete;
    QProductos.close;
    QProductos.open;
  end;
end;

end.
