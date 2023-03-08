unit POS23;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, ToolWin, ComCtrls, DB, ADODB, Grids, DBGrids;

type
  TfrmDomicilio = class(TForm)
    ToolBar1: TToolBar;
    btsalir: TSpeedButton;
    Edit1: TEdit;
    QClientes: TADOQuery;
    QClientesemp_codigo: TIntegerField;
    QClientescli_codigo: TIntegerField;
    QClientescli_nombre: TStringField;
    QClientescli_rnc: TStringField;
    QClientescli_cedula: TStringField;
    QClientescli_limite: TBCDField;
    QClientescli_balance: TBCDField;
    QClientesemp_numero: TIntegerField;
    dsClientes: TDataSource;
    DBGrid1: TDBGrid;
    QClientescli_referencia: TStringField;
    QClientescli_direccion: TStringField;
    QClientescli_localidad: TStringField;
    procedure btsalirClick(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid1Enter(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    seleccion : integer;
  end;

var
  frmDomicilio: TfrmDomicilio;

implementation

uses POS01;

{$R *.dfm}

procedure TfrmDomicilio.btsalirClick(Sender: TObject);
begin
  seleccion := 0;
  Close;
end;

procedure TfrmDomicilio.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    QClientes.Close;
    QClientes.SQL.Clear;
    QClientes.SQL.Add('select');
    QClientes.SQL.Add('distinct emp_codigo, cli_codigo, cli_nombre, cli_rnc, cli_cedula,');
    QClientes.SQL.Add('isnull(cli_limite,0) as cli_limite, cli_balance, emp_numero, cli_referencia,');
    QClientes.SQL.Add('cli_direccion, cli_localidad');
    QClientes.SQL.Add('from clientes');
    QClientes.SQL.Add('where cli_nombre+isnull(cli_referencia,'+QuotedStr('')+')+isnull(cli_telefono,'+QuotedStr('')+') like '+QuotedStr('%'+Edit1.Text+'%'));
    QClientes.SQL.Add('and cli_status = '+QuotedStr('ACT'));
    QClientes.SQL.Add('order by cli_nombre');
    QClientes.Open;

    if QClientes.RecordCount = 0 then
    begin
      MessageDlg('ESTE CLIENTE NO EXISTE',mtError,[mbok],0);
      Edit1.SetFocus;
    end
    else
      DBGrid1.SetFocus;

    key := #0;
  end;
end;

procedure TfrmDomicilio.DBGrid1KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    if QClientes.RecordCount > 0 then
    begin
      seleccion := 1;
      Close;
    end;
  end;
end;

procedure TfrmDomicilio.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_escape then btsalirClick(Self);
end;

procedure TfrmDomicilio.DBGrid1Enter(Sender: TObject);
begin
  edit1.Text;
end;

end.
