unit CadastroTanque;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, FMTBcd, DB, SqlExpr;

type
  TfCadastroTanque = class(TForm)
    gbxRegistro: TGroupBox;
    Label1: TLabel;
    edtID: TEdit;
    Label2: TLabel;
    edtDescricao: TEdit;
    Label3: TLabel;
    cbxTipoCombustivel: TComboBox;
    GroupBox2: TGroupBox;
    btnInserir: TButton;
    btnGravar: TButton;
    btnCancelar: TButton;
    btnConsultar: TButton;
    btnAlterar: TButton;
    btnExcluir: TButton;
    Query: TSQLQuery;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure btnInserirClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
  private
    procedure LimpaFormulario;
    procedure HabilitaEdicao;
    function ValidaGravacao:Boolean;
    procedure GravaRegistro;
    procedure AlteraRegistro;
    procedure DesabilitaEdicao;
    procedure CarregaId;
    procedure CarregaRegistro(Id : string);
    procedure ExcluiRegistro;
  public

  end;

var
  fCadastroTanque: TfCadastroTanque;

implementation

uses uPrincipal, ConsultaTanque;

{$R *.dfm}

procedure TfCadastroTanque.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfCadastroTanque.FormDestroy(Sender: TObject);
begin
  fCadastroTanque := nil;
end;

procedure TfCadastroTanque.btnInserirClick(Sender: TObject);
begin
  LimpaFormulario();
  HabilitaEdicao();
end;

procedure TfCadastroTanque.HabilitaEdicao;
begin
  gbxRegistro.Enabled := True;

  btnInserir.Enabled := False;
  btnGravar.Enabled := True;
  btnCancelar.Enabled := True;
  btnConsultar.Enabled := False;
  btnAlterar.Enabled := False;
  btnExcluir.Enabled := False;

  edtDescricao.SetFocus();
end;

procedure TfCadastroTanque.LimpaFormulario;
begin
  edtID.Text := '';
  edtDescricao.Text := '';
  cbxTipoCombustivel.ItemIndex := -1; 
end;

procedure TfCadastroTanque.btnGravarClick(Sender: TObject);
begin
  if not ValidaGravacao() then
    Exit;

  if edtID.Text = '' then
    GravaRegistro()
  else
    AlteraRegistro();
    
  CarregaId();
  DesabilitaEdicao();
  ShowMessage('Registro gravado com sucesso!');
end;

function TfCadastroTanque.ValidaGravacao: Boolean;
begin
  Result := False;

  if Trim(edtDescricao.Text) = '' then
  begin
    ShowMessage('Informe a descrição');
    edtDescricao.SetFocus();
    Exit;
  end;

  if cbxTipoCombustivel.ItemIndex = -1 then
  begin
    ShowMessage('Informe o tipo de combustível');
    cbxTipoCombustivel.SetFocus();
    Exit;
  end;

  Result := True;
end;

procedure TfCadastroTanque.GravaRegistro;
begin
  Query.Close();
  Query.SQL.Clear();

  Query.SQL.Add('INSERT INTO TANQUE( ');
  Query.SQL.Add('  DESCRICAO,        ');
  Query.SQL.Add('  TIPO_COMBUSTIVEL) ');
  Query.SQL.Add('VALUES(             ');
  Query.SQL.Add('  :DESCRICAO,       ');
  Query.SQL.Add('  :TIPO_COMBUSTIVEL)');

  Query.ParamByName('DESCRICAO').Value := edtDescricao.Text;
  Query.ParamByName('TIPO_COMBUSTIVEL').Value := cbxTipoCombustivel.ItemIndex;

  Query.ExecSQL();
end;

procedure TfCadastroTanque.DesabilitaEdicao;
begin
  gbxRegistro.Enabled := False;

  btnInserir.Enabled := True;
  btnGravar.Enabled := False;
  btnCancelar.Enabled := False;
  btnConsultar.Enabled := True;
  btnAlterar.Enabled := edtId.Text <> '';
  btnExcluir.Enabled := edtId.Text <> '';
end;

procedure TfCadastroTanque.CarregaId;
begin
  Query.Close();
  Query.SQL.Clear();

  Query.SQL.Add('SELECT MAX(ID)');
  Query.SQL.Add('FROM TANQUE   ');

  Query.Open();
  edtID.Text := Query.Fields[0].AsString;
  Query.Close();
end;

procedure TfCadastroTanque.btnCancelarClick(Sender: TObject);
begin
  if edtID.Text = '' then
    LimpaFormulario()
  else
    CarregaRegistro(edtID.Text);

  DesabilitaEdicao();
end;

procedure TfCadastroTanque.CarregaRegistro(Id: string);
begin
  Query.Close();
  Query.SQL.Clear();

  Query.SQL.Add('SELECT ID,             ');
  Query.SQL.Add('       DESCRICAO,      ');
  Query.SQL.Add('       TIPO_COMBUSTIVEL');
  Query.SQL.Add('  FROM TANQUE          ');
  Query.SQL.Add(' WHERE ID = :ID        ');

  Query.ParamByName('ID').Value := ID;

  Query.Open();

  if Query.IsEmpty then
  begin
    LimpaFormulario();
  end
  else
  begin
    edtId.Text := Query.FieldByName('ID').AsString;
    edtDescricao.Text := Query.FieldByName('DESCRICAO').AsString;
    cbxTipoCombustivel.ItemIndex := Query.FieldByName('TIPO_COMBUSTIVEL').AsInteger;
  end;

  Query.Close();
end;

procedure TfCadastroTanque.btnAlterarClick(Sender: TObject);
begin
  HabilitaEdicao();
end;

procedure TfCadastroTanque.btnConsultarClick(Sender: TObject);
begin
  fConsultaTanque.Id := '0';
  fConsultaTanque.ShowModal();

  if fConsultaTanque.Id <> '0' then
  begin
    CarregaRegistro(fConsultaTanque.Id);
    DesabilitaEdicao();
  end;
end;

procedure TfCadastroTanque.btnExcluirClick(Sender: TObject);
begin
  if Application.MessageBox('Confirma exclusão do registro?', 'Posto ABC', MB_YESNO + MB_ICONQUESTION) = ID_YES then
  begin
    ExcluiRegistro();
    LimpaFormulario();
    ShowMessage('Registro excluído com sucesso!');
  end;
end;

procedure TfCadastroTanque.ExcluiRegistro;
begin
  Query.Close();
  Query.SQL.Clear();

  Query.SQL.Add('DELETE FROM TANQUE');
  Query.SQL.Add(' WHERE ID = :ID   ');

  Query.ParamByName('ID').Value := edtId.Text;

  Query.ExecSQL();
end;

procedure TfCadastroTanque.AlteraRegistro;
begin
  Query.Close();
  Query.SQL.Clear();

  Query.SQL.Add('UPDATE TANQUE                             ');
  Query.SQL.Add('  SET DESCRICAO = :DESCRICAO,             ');
  Query.SQL.Add('      TIPO_COMBUSTIVEL = :TIPO_COMBUSTIVEL');
  Query.SQL.Add('WHERE ID = :ID                            ');

  Query.ParamByName('DESCRICAO').Value := edtDescricao.Text;
  Query.ParamByName('TIPO_COMBUSTIVEL').Value := cbxTipoCombustivel.ItemIndex;
  Query.ParamByName('ID').Value := edtId.Text;

  Query.ExecSQL();
end;

end.
