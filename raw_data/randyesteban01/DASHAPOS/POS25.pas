unit POS25;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, ToolWin, ComCtrls, Grids, DBGrids, DB, ADODB;

type
  TfrmSeleccionCliente = class(TForm)
    Label1: TLabel;
    ToolBar1: TToolBar;
    btsalir: TSpeedButton;
    edcliente: TEdit;
    DBGrid1: TDBGrid;
    QClientes: TADOQuery;
    QClientesemp_codigo: TIntegerField;
    QClientescli_codigo: TIntegerField;
    QClientescli_nombre: TStringField;
    QClientescli_rnc: TStringField;
    QClientescli_cedula: TStringField;
    QClientescli_limite: TBCDField;
    QClientescli_balance: TBCDField;
    QClientesemp_numero: TIntegerField;
    QClientescli_direccion: TStringField;
    QClientescli_localidad: TStringField;
    QClientestfa_codigo: TIntegerField;
    QClientescli_facturarbce: TStringField;
    QClientescli_facturarvencida: TStringField;
    dsClientes: TDataSource;
    btcontado: TSpeedButton;
    btcredito: TSpeedButton;
    QClientesAumento: TBCDField;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btsalirClick(Sender: TObject);
    procedure btcreditoClick(Sender: TObject);
    procedure btcontadoClick(Sender: TObject);
    procedure dsClientesDataChange(Sender: TObject; Field: TField);
    procedure edclienteKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    Seleccion : integer;
    Tipo : string;
  end;

var
  frmSeleccionCliente: TfrmSeleccionCliente;

implementation

uses POS00, POS01;

{$R *.dfm}

procedure TfrmSeleccionCliente.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_escape then btsalirClick(Self);
  if key = vk_f1 then edcliente.SetFocus;
  if key = vk_f3 then btcreditoClick(Self);
  if key = vk_f4 then btcontadoClick(Self);
end;

procedure TfrmSeleccionCliente.btsalirClick(Sender: TObject);
begin
  Seleccion := 0;
  Close;
end;

procedure TfrmSeleccionCliente.btcreditoClick(Sender: TObject);
begin
  if btcredito.Enabled then
  begin
    Tipo := 'CRE';
    Seleccion := 1;
    Close;
  end;
end;

procedure TfrmSeleccionCliente.btcontadoClick(Sender: TObject);
begin
  Tipo := 'CON';
  Seleccion := 1;
  Close;
end;

procedure TfrmSeleccionCliente.dsClientesDataChange(Sender: TObject;
  Field: TField);
begin
  btcredito.Enabled := QClientes.RecordCount > 0;
  if QClientes.RecordCount > 0 then edcliente.Text := QClientescli_nombre.AsString;
end;

procedure TfrmSeleccionCliente.edclienteKeyPress(Sender: TObject;
  var Key: Char);
begin
  if key = #13 then
  begin
    QClientes.Close;
    QClientes.SQL.Clear;
    QClientes.SQL.Add('select');
    QClientes.SQL.Add('distinct emp_codigo, cli_codigo, cli_nombre, cli_rnc, cli_cedula, cli_direccion,cli_localidad,');
    QClientes.SQL.Add('isnull(cli_limite,0) as cli_limite, cli_balance, emp_numero, cli_telefono, tfa_codigo,');
    QClientes.SQL.Add('cli_facturarbce, cli_facturarvencida, Aumento');
    QClientes.SQL.Add('from clientes');
    QClientes.SQL.Add('where cli_nombre+isnull(cli_referencia,'+QuotedStr('')+')+isnull(cli_telefono,'+QuotedStr('')+') like '+QuotedStr('%'+edcliente.Text+'%'));
    QClientes.SQL.Add('and cli_status = '+QuotedStr('ACT'));
    QClientes.SQL.Add('order by cli_nombre');
    QClientes.Open;
    DBGrid1.SetFocus;

    key := #0;
  end;
end;

end.
