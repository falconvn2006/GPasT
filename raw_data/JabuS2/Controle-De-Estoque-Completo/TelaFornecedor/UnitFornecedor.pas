unit UnitFornecedor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls,
  Data.DB, Vcl.Grids, Vcl.DBGrids, Data.Win.ADODB, Vcl.ExtCtrls;

type
  TFmrfornecedor = class(TForm)
    lbl1: TLabel;
    lbl2: TLabel;
    dbedt1: TDBEdit;
    lbl3: TLabel;
    dbedt2: TDBEdit;
    lbl4: TLabel;
    dbedt3: TDBEdit;
    lbl5: TLabel;
    dbedt4: TDBEdit;
    lbl6: TLabel;
    dbedt5: TDBEdit;
    lbl7: TLabel;
    dbedt6: TDBEdit;
    lbl8: TLabel;
    dbedt7: TDBEdit;
    lbl9: TLabel;
    dbedt8: TDBEdit;
    lbl10: TLabel;
    dbedt9: TDBEdit;
    lbl11: TLabel;
    dbedt10: TDBEdit;
    lbl12: TLabel;
    dbedt11: TDBEdit;
    lbl13: TLabel;
    dbedt12: TDBEdit;
    lbl14: TLabel;
    dbedt13: TDBEdit;
    lbl15: TLabel;
    dbedt14: TDBEdit;
    gr1: TDBGrid;
    btnCadastrar: TButton;
    btnCancelar: TButton;
    btnSalvar: TButton;
    btnAlterar: TButton;
    ADOConnection1: TADOConnection;
    ADOQuery1: TADOQuery;
    DataSource1: TDataSource;
    ADOQuery1id_fornecedor: TAutoIncField;
    ADOQuery1nome_fantasia: TStringField;
    ADOQuery1razao_social: TStringField;
    ADOQuery1endereco: TStringField;
    ADOQuery1numero: TIntegerField;
    ADOQuery1complemento: TStringField;
    ADOQuery1bairro: TStringField;
    ADOQuery1cep: TIntegerField;
    ADOQuery1cidade: TStringField;
    ADOQuery1uf_estado: TStringField;
    ADOQuery1pessoa: TStringField;
    ADOQuery1cnpj_fornecedor: TIntegerField;
    ADOQuery1insc_estadual: TIntegerField;
    ADOQuery1email: TStringField;
    ADOQuery1telefone: TIntegerField;
    Shape1: TShape;
    DBComboBox1: TDBComboBox;
    btnExcluir: TButton;
    GroupBox1: TGroupBox;
    btnSair: TButton;
    procedure btnCadastrarClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
  private
    procedure Botoes;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fmrfornecedor: TFmrfornecedor;

implementation

{$R *.dfm}

procedure tFmrfornecedor.Botoes;
begin
if  (btnAlterar.Focused) or (btncadastrar.Focused) then
  begin
  //botoes
  btnSalvar.Enabled:=true;
  btnCadastrar.Enabled:=false;
  btnAlterar.Enabled:=false;
  btnExcluir.Enabled:=false;
  btnCancelar.Enabled:=true;
  btnSair.Enabled:=false;
  //grid
  DBComboBox1.Enabled:=true;
  dbedt1.Enabled:=true;
  dbedt2.Enabled:=true;
  dbedt3.Enabled:=true;
  dbedt4.Enabled:=true;
  dbedt5.Enabled:=true;
  dbedt6.Enabled:=true;
  dbedt7.Enabled:=true;
  dbedt8.Enabled:=true;
  dbedt9.Enabled:=true;
  dbedt10.Enabled:=true;
  dbedt11.Enabled:=true;
  dbedt12.Enabled:=true;
  dbedt13.Enabled:=true;
  dbedt14.Enabled:=true;
  gr1.Enabled:=false;
  dbedt1.SetFocus;
  end
else if (btnSalvar.Focused) or (btnCancelar.Focused) or (btnSair.Focused) then
  begin
  //botoes
  btnSalvar.Enabled:=false;
  btnCadastrar.Enabled:=true;
  btnAlterar.Enabled:=true;
  btnExcluir.Enabled:=true;
  btnCancelar.Enabled:=false;
  btnSair.Enabled:=true;
  //grid
  DBComboBox1.Enabled:=false;
  dbedt1.Enabled:=false;
  dbedt2.Enabled:=false;
  dbedt3.Enabled:=false;
  dbedt4.Enabled:=false;
  dbedt5.Enabled:=false;
  dbedt6.Enabled:=false;
  dbedt7.Enabled:=false;
  dbedt8.Enabled:=false;
  dbedt9.Enabled:=false;
  dbedt10.Enabled:=false;
  dbedt11.Enabled:=false;
  dbedt12.Enabled:=false;
  dbedt13.Enabled:=false;
  dbedt14.Enabled:=false;
  gr1.Enabled:=true;
  end;

end;

//BOTAO CADASTRAR//
procedure TFmrfornecedor.btnCadastrarClick(Sender: TObject);
  begin
  adoquery1.Append;
  botoes;
  end;


//BOTAO CANCELAR
procedure TFmrfornecedor.btnCancelarClick(Sender: TObject);
begin
  botoes;
  ADOQuery1.sql.clear;
  ADOQuery1.SQL.Add('select * from fornecedores for update');
  ADOQuery1.Open;
end;

procedure TFmrfornecedor.btnExcluirClick(Sender: TObject);
begin
if messagedlg('Excluir? ',mtConfirmation,[mbYes,mbNo],0)=mrYes then
  begin
  ADOQuery1.Delete;
  showmessage('Excluido!');
  end
  else
  abort;
end;

//BOTAO SALVAR//
procedure TFmrfornecedor.btnSairClick(Sender: TObject);
begin
botoes;
fmrfornecedor.close;
end;

procedure TFmrfornecedor.btnSalvarClick(Sender: TObject);
begin
  adoquery1.Post;
  showmessage('Salvo com sucesso!');
  ADOQuery1.sql.clear;
  ADOQuery1.SQL.Add('select * from fornecedores for update');
  ADOQuery1.Open;
  botoes;
end;




//BOTAO ALTERAR//
procedure TFmrfornecedor.btnAlterarClick(Sender: TObject);
  begin
  adoquery1.Edit;
  botoes;
  end;
end.
