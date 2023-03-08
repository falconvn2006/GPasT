unit CadastroBomba;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, FMTBcd, DB, SqlExpr;

type
  TfCadastroBomba = class(TForm)
    gbxRegistro: TGroupBox;
    Label1: TLabel;
    edtID: TEdit;
    Label2: TLabel;
    edtDescricao: TEdit;
    Label3: TLabel;
    cbxTanque: TComboBox;
    GroupBox2: TGroupBox;
    btnInserir: TButton;
    btnGravar: TButton;
    btnCancelar: TButton;
    btnConsultar: TButton;
    btnAlterar: TButton;
    btnExcluir: TButton;
    Query: TSQLQuery;
    cbxTanqueId: TComboBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure btnInserirClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
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
    procedure CarregaTanques;
  public

  end;

var
  fCadastroBomba: TfCadastroBomba;

implementation

uses uPrincipal, ConsultaBomba;

{$R *.dfm}

procedure TfCadastroBomba.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfCadastroBomba.FormDestroy(Sender: TObject);
begin
  fCadastroBomba := nil;
end;

procedure TfCadastroBomba.btnInserirClick(Sender: TObject);
begin
  LimpaFormulario();
  HabilitaEdicao();
end;

procedure TfCadastroBomba.HabilitaEdicao;
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

procedure TfCadastroBomba.LimpaFormulario;
begin
  edtID.Text := '';
  edtDescricao.Text := '';
  cbxTanque.ItemIndex := -1; 
end;

procedure TfCadastroBomba.btnGravarClick(Sender: TObject);
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

function TfCadastroBomba.ValidaGravacao: Boolean;
begin
  Result := False;

  if Trim(edtDescricao.Text) = '' then
  begin
    ShowMessage('Informe a descrição');
    edtDescricao.SetFocus();
    Exit;
  end;

  if cbxTanque.ItemIndex = -1 then
  begin
    ShowMessage('Informe o tanque de combustível');
    cbxTanque.SetFocus();
    Exit;
  end;

  Result := True;
end;

procedure TfCadastroBomba.GravaRegistro;
begin
  Query.Close();
  Query.SQL.Clear();

  Query.SQL.Add('INSERT INTO BOMBA(');
  Query.SQL.Add('  DESCRICAO,      ');
  Query.SQL.Add('  TANQUE_ID)      ');
  Query.SQL.Add('VALUES(           ');
  Query.SQL.Add('  :DESCRICAO,     ');
  Query.SQL.Add('  :TANQUE_ID)     ');

  Query.ParamByName('DESCRICAO').Value := edtDescricao.Text;
  Query.ParamByName('TANQUE_ID').Value := cbxTanqueId.Items[cbxTanque.ItemIndex];

  Query.ExecSQL();
end;

procedure TfCadastroBomba.DesabilitaEdicao;
begin
  gbxRegistro.Enabled := False;

  btnInserir.Enabled := True;
  btnGravar.Enabled := False;
  btnCancelar.Enabled := False;
  btnConsultar.Enabled := True;
  btnAlterar.Enabled := edtId.Text <> '';
  btnExcluir.Enabled := edtId.Text <> '';
end;

procedure TfCadastroBomba.CarregaId;
begin
  Query.Close();
  Query.SQL.Clear();

  Query.SQL.Add('SELECT MAX(ID)');
  Query.SQL.Add('FROM BOMBA    ');

  Query.Open();
  edtID.Text := Query.Fields[0].AsString;
  Query.Close();
end;

procedure TfCadastroBomba.btnCancelarClick(Sender: TObject);
begin
  if edtID.Text = '' then
    LimpaFormulario()
  else
    CarregaRegistro(edtID.Text);

  DesabilitaEdicao();
end;

procedure TfCadastroBomba.CarregaRegistro(Id: string);
begin
  Query.Close();
  Query.SQL.Clear();

  Query.SQL.Add('SELECT ID,       ');
  Query.SQL.Add('       DESCRICAO,');
  Query.SQL.Add('       TANQUE_ID ');
  Query.SQL.Add('  FROM BOMBA     ');
  Query.SQL.Add(' WHERE ID = :ID  ');

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
    cbxTanque.ItemIndex := cbxTanqueId.Items.IndexOf(Query.FieldByName('TANQUE_ID').AsString);
  end;

  Query.Close();
end;

procedure TfCadastroBomba.btnAlterarClick(Sender: TObject);
begin
  HabilitaEdicao();
end;

procedure TfCadastroBomba.btnConsultarClick(Sender: TObject);
begin
  fConsultaBomba.Id := '0';
  fConsultaBomba.ShowModal();

  if fConsultaBomba.Id <> '0' then
  begin
    CarregaRegistro(fConsultaBomba.Id);
    DesabilitaEdicao();
  end;
end;

procedure TfCadastroBomba.btnExcluirClick(Sender: TObject);
begin
  if Application.MessageBox('Confirma exclusão do registro?', 'Posto ABC', MB_YESNO + MB_ICONQUESTION) = ID_YES then
  begin
    ExcluiRegistro();
    LimpaFormulario();
    ShowMessage('Registro excluído com sucesso!');
  end;
end;

procedure TfCadastroBomba.ExcluiRegistro;
begin
  Query.Close();
  Query.SQL.Clear();

  Query.SQL.Add('DELETE FROM BOMBA');
  Query.SQL.Add(' WHERE ID = :ID  ');

  Query.ParamByName('ID').Value := edtId.Text;

  Query.ExecSQL();
end;

procedure TfCadastroBomba.AlteraRegistro;
begin
  Query.Close();
  Query.SQL.Clear();

  Query.SQL.Add('UPDATE BOMBA                 ');
  Query.SQL.Add('  SET DESCRICAO = :DESCRICAO,');
  Query.SQL.Add('      TANQUE_ID = :TANQUE_ID ');
  Query.SQL.Add('WHERE ID = :ID               ');

  Query.ParamByName('DESCRICAO').Value := edtDescricao.Text;
  Query.ParamByName('TANQUE_ID').Value := cbxTanqueId.Items[cbxTanque.ItemIndex];
  Query.ParamByName('ID').Value := edtId.Text;

  Query.ExecSQL();
end;

procedure TfCadastroBomba.FormShow(Sender: TObject);
begin
  CarregaTanques();
end;

procedure TfCadastroBomba.CarregaTanques;
begin
  cbxTanque.Items.Clear();
  cbxTanqueId.Items.Clear();

  Query.Close();
  Query.SQL.Clear();

  Query.SQL.Add('SELECT ID,         ');
  Query.SQL.Add('       DESCRICAO   ');
  Query.SQL.Add('  FROM TANQUE      ');
  Query.SQL.Add(' ORDER BY DESCRICAO');

  Query.Open();

  while not Query.Eof do
  begin
    cbxTanque.Items.Add(Query.FieldByName('DESCRICAO').AsString);
    cbxTanqueId.Items.Add(Query.FieldByName('ID').AsString);

    Query.Next();
  end;

  Query.Close();
end;

end.
