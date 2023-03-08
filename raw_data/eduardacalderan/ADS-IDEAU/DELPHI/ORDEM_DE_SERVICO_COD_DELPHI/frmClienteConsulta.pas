unit frmClienteConsulta;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frmConsulta, Data.DB, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids;

type
  TformConsulta2 = class(TformConsulta)
    NomeCliente: TLabel;
    editNome: TEdit;
    CPFCliente: TLabel;
    EditCPF: TEdit;
    ButtonProcurar: TButton;
    procedure ButtonProcurarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  formConsulta2: TformConsulta2;

implementation

{$R *.dfm}

uses frmClienteCadastro, dmCliente;



procedure TformConsulta2.ButtonProcurarClick(Sender: TObject);
var
  sql: string;
  condicao: boolean;
begin
  inherited;
   sql := 'select * from cliente';
  condicao := false;
  if trim(editNome.Text) <> '' then
  begin
    sql := sql + ' where upper(nome) like ' + QuotedStr(UpperCase('%' + editNome.Text + '%'));
    condicao := true;
  end;
  if trim(editCPF.Text) <> '' then
  begin
    if not condicao then
      sql := sql + ' where '
    else
      sql := sql + ' and ';
    sql := sql + ' upper(cpf) like ' + QuotedStr(UpperCase('%' + editCPF.Text + '%'));
  end;
  sql := sql + ' order by nome';
  dtmClientes.sqlProcura(sql);
end;

end.
