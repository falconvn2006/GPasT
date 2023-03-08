unit UnitCadUsuario;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB, Vcl.Grids,
  Vcl.DBGrids, Data.Win.ADODB, Vcl.Mask, Vcl.DBCtrls, Vcl.ExtCtrls;

type
  TfmrCadUsuario = class(TForm)
    Label1: TLabel;
    ADOConnection1: TADOConnection;
    ADOQuery1: TADOQuery;
    DataSource1: TDataSource;
    Label2: TLabel;
    Label3: TLabel;
    DBGrid1: TDBGrid;
    dbedtUsuario: TDBEdit;
    dbedtSenha: TDBEdit;
    btnCadastrar: TButton;
    btnSalvar: TButton;
    DBComboBox1: TDBComboBox;
    btnDelete: TButton;
    btnAlterar: TButton;
    btnCancelar: TButton;
    Shape1: TShape;
    ADOQuery1id_usuario: TAutoIncField;
    ADOQuery1nome: TStringField;
    ADOQuery1senha: TIntegerField;
    ADOQuery1nivel: TStringField;
    Label4: TLabel;
    DBCBoxnivel: TDBComboBox;
    lbl1: TLabel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    procedure btnCadastrarClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
//    procedure DBComboBox1DropDown(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);



  private
      procedure Botoes;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmrCadUsuario: TfmrCadUsuario;

implementation

{$R *.dfm}



procedure TfmrCadUsuario.Botoes;
begin
if  (btnAlterar.Focused) or (btncadastrar.Focused) then
  begin
  //botoes
    btnSalvar.Enabled:=true;
    btnCadastrar.Enabled:=false;
    btnAlterar.Enabled:=false;
    btnDelete.Enabled:=false;
    btnCancelar.Enabled:=true;
  //Grid e dbedit
    DBGrid1.Enabled:=false;
    dbedtUsuario.Enabled:=true;
    dbedtSenha.Enabled:=true;
    DBCBoxNivel.Enabled:=true;
    dbedtUsuario.SetFocus;
  end
else if (btnSalvar.Focused) or (btnCancelar.Focused) then
  begin
  //botoes
    btnSalvar.Enabled:=false;
    btnCadastrar.Enabled:=true;
    btnAlterar.Enabled:=true;
    btnDelete.Enabled:=true;
    btnCancelar.Enabled:=false;
  //grid e dbedit
    dbedtUsuario.Enabled:=false;
    dbedtSenha.Enabled:=false;
    DBCBoxNivel.Enabled:=false;
    DBGrid1.Enabled:=true;
  end
else if (btnDelete.Focused) then
  begin
    dbedtUsuario.Enabled:=false;
    dbedtSenha.Enabled:=false;
    DBCBoxNivel.Enabled:=false;
  end;
end;

//Botao Alterar//
procedure TfmrCadUsuario.btnAlterarClick(Sender: TObject);
  begin
    adoquery1.Edit;
    Botoes;
  end;

//Botao Novo//
procedure TfmrCadUsuario.btnCadastrarClick(Sender: TObject);
  begin
    adoquery1.Append;
    Botoes;
  end;

//Botao Cancelar//
procedure TfmrCadUsuario.btnCancelarClick(Sender: TObject);
  begin
  botoes;

  ADOQuery1.sql.clear;
  ADOQuery1.SQL.Add('select * from usuario for update');
  ADOQuery1.Open;

//  DBCBoxNivel.Items.Add('ADMINISTRADOR');
//  DBCBoxNivel.Items.Add('USUARIO');
  end;

//Botao Gravar//
procedure TfmrCadUsuario.btnSalvarClick(Sender: TObject);
begin
//if para verificar se o que tem no DBCBox e diferente de vazio
if (DBCBoxnivel.text) <> '' then
  begin
  adoquery1.Post;
  showmessage('Salvo com sucesso!');
  ADOQuery1.sql.clear;
  ADOQuery1.SQL.Add('select * from usuario for update');
  ADOQuery1.Open;
  botoes;
  end
else
  begin
  showmessage('Selecione o nivel');
  abort;
  end;

end;

///////////// Nao estou mais utilizando/////////////////////

{procedure TfmrCadUsuario.DBComboBox1DropDown(Sender: TObject);
begin
dbcombobox1.Clear;
var
contador:integer;
contador:=0;
adoquery2.First;
ADOQuery2.sql.clear;
ADOQuery2.SQL.Add('select * from usuario');
ADOQuery2.Open;
while contador<adoquery2.RecordCount do
 begin
    c;
    adoquery2.Next;
    contador:=contador+1;
 end;
end;}
/////////////////////////////////////////////////////////////////



procedure TfmrCadUsuario.btnDeleteClick(Sender: TObject);
begin
//if para mostras a mensagem pro usuario se ele desejar excluir
if messagedlg('Excluir Usuario? ',mtConfirmation,[mbYes,mbNo],0)=mrYes then
  begin
  ADOQuery1.Delete;
  showmessage('Excluido!');
  end
  else
  abort;
  end;

end.
