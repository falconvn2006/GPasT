unit BAR10;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, DB, ADODB, StdCtrls, Mask, DBCtrls;

type
  TfrmIngredientes = class(TForm)
    btclose: TSpeedButton;
    btpost: TSpeedButton;
    QIngredientes: TADOQuery;
    QIngredientesProductoID: TIntegerField;
    QIngredientesIngredienteID: TIntegerField;
    QIngredientesProductoIngrediente: TIntegerField;
    QIngredientesPrecio: TBCDField;
    QIngredientesImprimir: TBooleanField;
    dsIngredientes: TDataSource;
    Label1: TLabel;
    edproducto: TEdit;
    Label2: TLabel;
    DBEdit1: TDBEdit;
    Label3: TLabel;
    DBEdit2: TDBEdit;
    DBCheckBox1: TDBCheckBox;
    btbuscaproducto: TSpeedButton;
    QIngredientesCantidad: TFloatField;
    QIngredientesVisualizar: TBooleanField;
    DBCheckBox2: TDBCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure btcloseClick(Sender: TObject);
    procedure btpostClick(Sender: TObject);
    procedure btbuscaproductoClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure QIngredientesNewRecord(DataSet: TDataSet);
    procedure QIngredientesBeforePost(DataSet: TDataSet);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    Prod : integer;
  end;

var
  frmIngredientes: TfrmIngredientes;

implementation

uses BAR04, BAR09;

{$R *.dfm}

procedure TfrmIngredientes.FormCreate(Sender: TObject);
begin
  btclose.Caption := 'F1'+#13+'SALIR';
  btpost.Caption  := 'F2'+#13+'GRABAR';
  btbuscaproducto.Caption := 'F3'+#13+'PRODUCTOS';
end;

procedure TfrmIngredientes.btcloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmIngredientes.btpostClick(Sender: TObject);
begin
  QIngredientes.Post;
  QIngredientes.UpdateBatch;
  Close;
end;

procedure TfrmIngredientes.btbuscaproductoClick(Sender: TObject);
begin
  Application.CreateForm(tfrmBuscarProducto, frmBuscarProducto);
  frmBuscarProducto.ShowModal;

  if frmBuscarProducto.Acepto = 1 then
  begin
    edproducto.Text := frmBuscarProducto.QProductosCodigo.AsString;
    QIngredientesProductoIngrediente.Value := frmBuscarProducto.QProductosProductoID.Value;
    QIngredientesPrecio.Value              := frmBuscarProducto.QProductosPrecio.Value;
  end;
  frmBuscarProducto.Release;
end;

procedure TfrmIngredientes.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_f1  then btcloseClick(Self);
  if key = vk_f2  then btpostClick(Self);
  if key = vk_f3  then btbuscaproductoClick(Self);
end;

procedure TfrmIngredientes.QIngredientesNewRecord(DataSet: TDataSet);
begin
  QIngredientesProductoID.Value := Prod;
  QIngredientesCantidad.Value   := 1;
  QIngredientesImprimir.Value   := False;
  QIngredientesVisualizar.Value   := False;
end;

procedure TfrmIngredientes.QIngredientesBeforePost(DataSet: TDataSet);
begin
  if QIngredientes.State = dsInsert then
  begin
    dm.Query1.Close;
    dm.Query1.SQL.Clear;
    dm.Query1.SQL.Add('select max(IngredienteID) as maximo');
    dm.Query1.SQL.Add('from Ingredientes');
    dm.Query1.SQL.Add('where ProductoID = :pro');
    dm.Query1.Parameters.ParamByName('pro').Value := Prod;
    dm.Query1.Open;
    QIngredientesIngredienteID.Value := dm.Query1.FieldByName('maximo').AsInteger + 1;
  end;
end;

procedure TfrmIngredientes.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = chr(vk_return) then
  begin
    perform(wm_nextdlgctl, 0, 0);
    key := #0;
  end;
end;

end.
