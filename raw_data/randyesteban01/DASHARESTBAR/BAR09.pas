unit BAR09;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, ExtCtrls, Grids, DBGrids, DB, ADODB;

type
  TfrmBuscarProducto = class(TForm)
    btcodigo: TSpeedButton;
    btnombre: TSpeedButton;
    btcategoria: TSpeedButton;
    btclose: TSpeedButton;
    Panel2: TPanel;
    edbusca: TEdit;
    lbtipo: TStaticText;
    btaceptar: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    btteclado: TSpeedButton;
    QProductos: TADOQuery;
    QProductosCodigo: TWideStringField;
    QProductosNombre: TWideStringField;
    QProductosPrecio: TBCDField;
    QProductosCategoria: TWideStringField;
    QProductosProductoID: TAutoIncField;
    dsProductos: TDataSource;
    DBGrid1: TDBGrid;
    Memo1: TMemo;
    QProductosExistencia: TFloatField;
    QProductosmontoItbis: TBCDField;
    QProductoscosto: TBCDField;
    procedure btcloseClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure btaceptarClick(Sender: TObject);
    procedure btcodigoClick(Sender: TObject);
    procedure btnombreClick(Sender: TObject);
    procedure btcategoriaClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure edbuscaChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Acepto : integer;
    Busqueda : string;
  end;

var
  frmBuscarProducto: TfrmBuscarProducto;

implementation

uses BAR04;

{$R *.dfm}

procedure TfrmBuscarProducto.btcloseClick(Sender: TObject);
begin
  Acepto := 0;
  Close;
end;

procedure TfrmBuscarProducto.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_f1  then btcloseClick(Self);
  if key = vk_f2  then btcodigoClick(Self);
  if key = vk_f3  then btnombreClick(Self);
  if key = vk_f4  then btcategoriaClick(Self);
  if key = vk_f10 then btaceptarClick(Self);
end;

procedure TfrmBuscarProducto.FormCreate(Sender: TObject);
begin
  Busqueda := 'P.pro_NOMBRE';
  btclose.Caption := 'F1'+#13+'SALIR';
  btcodigo.Caption := 'F2'+#13+'CODIGO';
  btnombre.Caption := 'F3'+#13+'NOMBRE';
  btcategoria.Caption := 'F4'+#13+'CATEGORIA';
  btaceptar.Caption := 'F10'+#13+'ACEPTAR';
  btteclado.Caption := 'F6'+#13+'TECLADO';
  Memo1.Lines := QProductos.SQL;
  QProductos.SQL.Add('order by p.pro_nombre');
end;

procedure TfrmBuscarProducto.btaceptarClick(Sender: TObject);
begin
  Acepto := 1;
  Close;
end;

procedure TfrmBuscarProducto.btcodigoClick(Sender: TObject);
begin
  Busqueda := 'P.pro_roriginal';
  lbtipo.Caption := 'Buscar por: CODIGO';
  QProductos.Close;
  QProductos.SQL.Clear;
  QProductos.SQL := Memo1.Lines;
  QProductos.SQL.Add('where '+Busqueda+' like '+QuotedStr(edbusca.Text+'%'));
  QProductos.SQL.Add('order by '+Busqueda);
  QProductos.Open;
  edbusca.SetFocus;
end;

procedure TfrmBuscarProducto.btnombreClick(Sender: TObject);
begin
  Busqueda := 'P.pro_NOMBRE';
  lbtipo.Caption := 'Buscar por: NOMBRE';
  QProductos.Close;
  QProductos.SQL.Clear;
  QProductos.SQL := Memo1.Lines;
  QProductos.SQL.Add('where '+Busqueda+' like '+QuotedStr(edbusca.Text+'%'));
  QProductos.SQL.Add('order by '+Busqueda);
  QProductos.Open;
  edbusca.SetFocus;
end;

procedure TfrmBuscarProducto.btcategoriaClick(Sender: TObject);
begin
  Busqueda := 'C.NOMBRE';
  lbtipo.Caption := 'Buscar por: CATEGORIA';
  QProductos.Close;
  QProductos.SQL.Clear;
  QProductos.SQL := Memo1.Lines;
  QProductos.SQL.Add('where '+Busqueda+' like '+QuotedStr(edbusca.Text+'%'));
  QProductos.SQL.Add('order by '+Busqueda);
  QProductos.Open;
  edbusca.SetFocus;
end;

procedure TfrmBuscarProducto.FormActivate(Sender: TObject);
begin
  if not QProductos.Active then QProductos.Open;
end;

procedure TfrmBuscarProducto.SpeedButton1Click(Sender: TObject);
begin
  if not QProductos.Bof then QProductos.Prior;
end;

procedure TfrmBuscarProducto.SpeedButton2Click(Sender: TObject);
begin
  if not QProductos.Eof then QProductos.Next;
end;

procedure TfrmBuscarProducto.edbuscaChange(Sender: TObject);
begin
  QProductos.DisableControls;
  QProductos.Close;
  QProductos.SQL.Clear;
  QProductos.SQL := Memo1.Lines;
  QProductos.SQL.Add('where '+Busqueda+' like '+QuotedStr('%'+edbusca.Text+'%'));
  QProductos.SQL.Add('order by '+Busqueda);
  QProductos.Open;
  QProductos.EnableControls;
end;

end.
