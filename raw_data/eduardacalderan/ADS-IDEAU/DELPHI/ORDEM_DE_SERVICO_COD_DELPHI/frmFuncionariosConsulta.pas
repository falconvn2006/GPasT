unit frmFuncionariosConsulta;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frmConsulta, Data.DB, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids;

type
  TformFuncionariosConsulta = class(TformConsulta)
    NomeFuncionario: TLabel;
    editNomeFuncionario: TEdit;
    ButtonProcurar: TButton;
    procedure ButtonProcurarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  formFuncionariosConsulta: TformFuncionariosConsulta;

implementation

{$R *.dfm}

uses frmFuncionariosCadastro, dmFuncionarios;



procedure TformFuncionariosConsulta.ButtonProcurarClick(Sender: TObject);
var
  sql: string;
  condicao: boolean;
begin
  inherited;
   sql := 'select * from funcionario';
  condicao := false;
  if trim(editNomeFuncionario.Text) <> '' then
  begin
    sql := sql + ' where upper(nome) like ' + QuotedStr(UpperCase('%' + editNomeFuncionario.Text + '%'));
    condicao := true;
  end;

  sql := sql + ' order by nome';
  dtmFuncionarios.sqlProcura(sql);
end;

end.
