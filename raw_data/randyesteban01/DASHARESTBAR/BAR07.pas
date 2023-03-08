unit BAR07;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, StdCtrls, DBCtrls, Mask, DB, ADODB, ComCtrls,
  Grids, DBGrids, ExtDlgs, QuerySearchDlgADO, cxControls, cxContainer,
  cxEdit, cxTextEdit, cxMaskEdit, cxButtonEdit;

type
  TfrmActProducto = class(TForm)
    Panel1: TPanel;
    btclose: TSpeedButton;
    btpost: TSpeedButton;
    Panel2: TPanel;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    DBCheckBox1: TDBCheckBox;
    DBRadioGroup1: TDBRadioGroup;
    Label10: TLabel;
    DBCheckBox2: TDBCheckBox;
    Label13: TLabel;
    Label14: TLabel;
    Panel3: TPanel;
    Image1: TImage;
    btinsertaimg: TSpeedButton;
    bteliminaimg: TSpeedButton;
    DBCheckBox3: TDBCheckBox;
    DBCheckBox4: TDBCheckBox;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBLookupComboBox1: TDBLookupComboBox;
    DBLookupComboBox2: TDBLookupComboBox;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    DBEdit7: TDBEdit;
    DBEdit8: TDBEdit;
    DBEdit9: TDBEdit;
    DBLookupComboBox3: TDBLookupComboBox;
    DBLookupComboBox4: TDBLookupComboBox;
    Label12: TLabel;
    DBEdit10: TDBEdit;
    Label15: TLabel;
    DBEdit11: TDBEdit;
    QCategoria: TADOQuery;
    QCategoriaCategoriaID: TIntegerField;
    QCategoriaNombre: TWideStringField;
    dsCategorias: TDataSource;
    QColor: TADOQuery;
    QColorColor: TWideStringField;
    QColorNombre: TWideStringField;
    dsColores: TDataSource;
    QProducto: TADOQuery;
    dsProducto: TDataSource;
    QProveedor: TADOQuery;
    QProveedorProveedorID: TAutoIncField;
    QProveedorNombre: TWideStringField;
    dsProveedores: TDataSource;
    Panel17: TPanel;
    lbprod1: TStaticText;
    pageing: TPageControl;
    TabSheet1: TTabSheet;
    DBGrid1: TDBGrid;
    QIngredientes: TADOQuery;
    QIngredientesProductoID: TIntegerField;
    QIngredientesIngredienteID: TIntegerField;
    QIngredientesProductoIngrediente: TIntegerField;
    QIngredientesPrecio: TBCDField;
    QIngredientesImprimir: TBooleanField;
    dsIngredientes: TDataSource;
    QIngredientesNombre: TWideStringField;
    QIngredientesCodigo: TWideStringField;
    btinsert: TSpeedButton;
    btedit: TSpeedButton;
    btdelete: TSpeedButton;
    QIngredientesCantidad: TFloatField;
    QIngredientesImprime: TStringField;
    OpenPictureDialog1: TOpenPictureDialog;
    DBCheckBox5: TDBCheckBox;
    TabSheet2: TTabSheet;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    DBEdit12: TDBEdit;
    DBEdit13: TDBEdit;
    DBEdit14: TDBEdit;
    DBEdit15: TDBEdit;
    DBGrid2: TDBGrid;
    QOferta: TADOQuery;
    QOfertaProductoID: TIntegerField;
    QOfertaCantidadVendida: TFloatField;
    QOfertaCantidadOferta: TFloatField;
    QOfertaPrecioOferta: TBCDField;
    dsOferta: TDataSource;
    btinsertaoferta: TSpeedButton;
    btmodificaoferta: TSpeedButton;
    bteliminaoferta: TSpeedButton;
    QOfertaOfertaID: TIntegerField;
    QIngredientesVisualizar: TBooleanField;
    GroupBox2: TGroupBox;
    Label21: TLabel;
    DBCheckBox6: TDBCheckBox;
    QPrinter_Remoto: TADOQuery;
    dsPrinter: TDataSource;
    Label20: TLabel;
    DBEdit16: TDBEdit;
    QProductoProductoID: TAutoIncField;
    QProductoNombre: TWideStringField;
    QProductoLinea1: TWideStringField;
    QProductoLinea2: TWideStringField;
    QProductoLinea3: TWideStringField;
    QProductoCategoriaID: TIntegerField;
    QProductoImagen: TWideStringField;
    QProductoBgColor: TWideStringField;
    QProductoFgColor: TWideStringField;
    QProductoCodigo: TWideStringField;
    QProductoCosto: TBCDField;
    QProductoPrecio: TFloatField;
    QProductoItbis: TBooleanField;
    QProductoBeneficio: TBCDField;
    QProductoImpresoraRemota: TBooleanField;
    QProductoOcultarEnFactura: TBooleanField;
    QProductoEstatus: TWideStringField;
    QProductoProveedorID: TIntegerField;
    QProductoOfertaDesde: TDateTimeField;
    QProductoOfertaHasta: TDateTimeField;
    QProductoOfertaPrecio: TFloatField;
    QProductoOfertaDescuento: TBCDField;
    QProductoInactivaItbiEnLlevar: TBooleanField;
    QProductoUnidad: TWideStringField;
    QProductoImpresora: TWideStringField;
    QProductoExistencia: TFloatField;
    QProductoActualizarExistencia: TBooleanField;
    QProductoIDPrinter: TIntegerField;
    QProductoMontoItbis: TFloatField;
    Label11: TLabel;
    QCategoriaNombre1: TWideStringField;
    QCategoriatotal: TIntegerField;
    QProductoOrdenCategoria: TIntegerField;
    Label22: TLabel;
    DBEdit6: TDBEdit;
    search: TQrySearchDlgADO;
    dblkcbImpresoraRemota: TDBLookupComboBox;
    dbchkImpresoraRemota2: TDBCheckBox;
    QProductoImpresoraRemota2: TBooleanField;
    procedure FormCreate(Sender: TObject);
    procedure btcloseClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btpostClick(Sender: TObject);
    procedure QProductoNewRecord(DataSet: TDataSet);
    procedure dsProductoDataChange(Sender: TObject; Field: TField);
    procedure QProductoBeforePost(DataSet: TDataSet);
    procedure FormActivate(Sender: TObject);
    procedure btinsertClick(Sender: TObject);
    procedure bteditClick(Sender: TObject);
    procedure btdeleteClick(Sender: TObject);
    procedure dsProductoStateChange(Sender: TObject);
    procedure QIngredientesCalcFields(DataSet: TDataSet);
    procedure btinsertaimgClick(Sender: TObject);
    procedure bteliminaimgClick(Sender: TObject);
    procedure bteliminaofertaClick(Sender: TObject);
    procedure btinsertaofertaClick(Sender: TObject);
    procedure btmodificaofertaClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBCheckBox6Click(Sender: TObject);
    procedure dbchkImpresoraRemota2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Grabo : Integer;
  end;

var
  frmActProducto: TfrmActProducto;

implementation

uses BAR04, BAR09, BAR10, BAR13, Math;

{$R *.dfm}

procedure TfrmActProducto.FormCreate(Sender: TObject);
begin
  btclose.Caption := 'F1'+#13+'SALIR';
  btpost.Caption  := 'F2'+#13+'GRABAR';

  QCategoria.Open;
  QColor.Open;
  QProveedor.Open;
  QIngredientes.Open;
  QOferta.Open;
  QPrinter_Remoto.open;
end;

procedure TfrmActProducto.btcloseClick(Sender: TObject);
begin
  QProducto.Cancel;
  Grabo := 0;
  Close;
end;

procedure TfrmActProducto.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_f1 then btcloseClick(Self);
  if key = vk_f2 then btpostClick(Self);
  if (key = vk_f3) and (pageing.Visible) then btinsertClick(Self);
  if (key = vk_f4) and (pageing.Visible) then bteditClick(Self);
  if (key = vk_f5) and (pageing.Visible) then btdeleteClick(Self);
  if (key = vk_f6) and (pageing.Visible) then btinsertaofertaClick(Self);
  if (key = vk_f7) and (pageing.Visible) then btmodificaofertaClick(Self);
  if (key = vk_f8) and (pageing.Visible) then bteliminaofertaClick(Self);
end;

procedure TfrmActProducto.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = chr(vk_return) then
  begin
    if ActiveControl.classtype <> tdbgrid then
    begin
      perform(wm_nextdlgctl, 0, 0);
      key := #0;
    end;
  end;
end;

procedure TfrmActProducto.btpostClick(Sender: TObject);
begin
if QCategoriatotal.Value < 56 then
  begin
    QProducto.Post;
    QProducto.UpdateBatch;
    Grabo := 1;
    Close;
  end
  else
    MessageDlg('A EXCEDIDO LA CANTIDAD MAXIMA DE PRODUCTO PARA ESTA CATEGORIA',mtError,[mbok],0);

end;

procedure TfrmActProducto.QProductoNewRecord(DataSet: TDataSet);
begin
  QProductoItbis.Value      := True;
  QProductoExistencia.Value := 0;
  QProductoEstatus.Value    := 'ACT';
  QProductoUnidad.Value     := 'UND';
  QProductoInactivaItbiEnLlevar.Value := False;
  QProductoImpresoraRemota.Value      := False;
  QProductoOcultarEnFactura.Value     := False;
  QProductoActualizarExistencia.Value := True;
end;

procedure TfrmActProducto.dsProductoDataChange(Sender: TObject;
  Field: TField);
var
  BgColor, FgColor : Integer;
begin
  lbprod1.Caption := QProductoLinea1.AsString+#13+
                     QProductoLinea2.AsString+#13+
                     QProductoLinea3.AsString; 
  
  lbprod1.Font.Color := clBlack;
  lbprod1.Color := clWhite;

  if not QProductoFgColor.IsNull then
  begin
    FgColor := StringToColor(QProductoFgColor.AsString);
    lbprod1.Font.Color := FgColor;
  end;
  if not QProductoBgColor.IsNull then
  begin
    BgColor := StringToColor(QProductoBgColor.AsString);
    lbprod1.Color := BgColor;
  end;
  if not QProductoImagen.IsNull then
    if FileExists(QProductoImagen.Value) then
      Image1.Picture.LoadFromFile(QProductoImagen.Value);
end;

procedure TfrmActProducto.QProductoBeforePost(DataSet: TDataSet);
begin
  if QProductoNombre.IsNull then
  begin
    MessageDlg('DEBE ESPECIFICAR EL NOMBRE',mtError,[mbok],0);
    DBEdit2.SetFocus;
    Abort;
  end;
end;

procedure TfrmActProducto.FormActivate(Sender: TObject);
begin
  CurrencyString := '';
end;

procedure TfrmActProducto.btinsertClick(Sender: TObject);
begin
  Application.CreateForm(tfrmIngredientes, frmIngredientes);
  frmIngredientes.Prod := QProductoProductoID.Value;
  frmIngredientes.QIngredientes.Open;
  frmIngredientes.QIngredientes.Insert;
  frmIngredientes.ShowModal;
  QIngredientes.Close;
  QIngredientes.Open;
  frmIngredientes.Release;
end;

procedure TfrmActProducto.bteditClick(Sender: TObject);
begin
  Application.CreateForm(tfrmIngredientes, frmIngredientes);
  frmIngredientes.Prod := QProductoProductoID.Value;
  frmIngredientes.QIngredientes.Parameters.ParamByName('pro').Value := QProductoProductoID.Value;
  frmIngredientes.QIngredientes.Parameters.ParamByName('ing').Value := QIngredientesIngredienteID.Value;
  frmIngredientes.QIngredientes.Open;
  frmIngredientes.QIngredientes.Edit;
  frmIngredientes.ShowModal;
  QIngredientes.Close;
  QIngredientes.Open;
  frmIngredientes.Release;
end;

procedure TfrmActProducto.btdeleteClick(Sender: TObject);
begin
  dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('delete from Ingredientes where ProductoID = :pro');
  dm.Query1.SQL.Add('and IngredienteID = :ing');
  dm.Query1.Parameters.ParamByName('pro').Value := QProductoProductoID.Value;
  dm.Query1.Parameters.ParamByName('ing').Value := QIngredientesIngredienteID.Value;
  dm.Query1.ExecSQL;
  QIngredientes.Close;
  QIngredientes.Open;
end;

procedure TfrmActProducto.dsProductoStateChange(Sender: TObject);
begin
  pageing.Visible := dsProducto.State = dsEdit;
end;

procedure TfrmActProducto.QIngredientesCalcFields(DataSet: TDataSet);
begin
  if QIngredientesImprimir.Value = True then
    QIngredientesImprime.Value := 'Si'
  else
    QIngredientesImprime.Value := 'No';
end;

procedure TfrmActProducto.btinsertaimgClick(Sender: TObject);
begin
  if OpenPictureDialog1.Execute then
    QProductoImagen.Value := OpenPictureDialog1.FileName;
end;

procedure TfrmActProducto.bteliminaimgClick(Sender: TObject);
begin
  QProductoImagen.Clear;
  Image1.Picture := nil;
end;

procedure TfrmActProducto.bteliminaofertaClick(Sender: TObject);
begin
  dm.Query1.Close;
  dm.Query1.SQL.Clear;
  dm.Query1.SQL.Add('delete from Ofertas where ProductoID = :pro');
  dm.Query1.SQL.Add('and OfertaID = :ofe');
  dm.Query1.Parameters.ParamByName('pro').Value := QProductoProductoID.Value;
  dm.Query1.Parameters.ParamByName('ofe').Value := QOfertaOfertaID.Value;
  dm.Query1.ExecSQL;
  QOferta.Close;
  QOferta.Open;
end;

procedure TfrmActProducto.btinsertaofertaClick(Sender: TObject);
begin
  Application.CreateForm(tfrmOferta, frmOferta);
  frmOferta.Prod := QProductoProductoID.Value;
  frmOferta.QOferta.Open;
  frmOferta.QOferta.Insert;
  frmOferta.ShowModal;
  QOferta.Close;
  QOferta.Open;
  frmOferta.Release;
end;

procedure TfrmActProducto.btmodificaofertaClick(Sender: TObject);
begin
  Application.CreateForm(tfrmOferta, frmOferta);
  frmOferta.Prod := QProductoProductoID.Value;
  frmOferta.QOferta.Parameters.ParamByName('pro').Value := QProductoProductoID.Value;
  frmOferta.QOferta.Parameters.ParamByName('ofe').Value := QOfertaOfertaID.Value;
  frmOferta.QOferta.Open;
  frmOferta.QOferta.Edit;
  frmOferta.ShowModal;
  QOferta.Close;
  QOferta.Open;
  frmOferta.Release;
end;

procedure TfrmActProducto.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
QPrinter_Remoto.Close;
end;

procedure TfrmActProducto.DBCheckBox6Click(Sender: TObject);
begin
if dsProducto.State in [dsedit] then begin
if DBCheckBox6.Checked = True then begin
if dbchkImpresoraRemota2.Checked = True then begin
QProductoImpresoraRemota.Value := True;
QProductoImpresoraRemota2.Value := False;
end;
end;
end;
end;

procedure TfrmActProducto.dbchkImpresoraRemota2Click(Sender: TObject);
begin
if dsProducto.State in [dsedit] then begin
if dbchkImpresoraRemota2.Checked = True then begin
if DBCheckBox6.Checked = True then begin
QProductoImpresoraRemota.Value := False;
QProductoImpresoraRemota2.Value := True;
end;
end;
end;
end;

end.
