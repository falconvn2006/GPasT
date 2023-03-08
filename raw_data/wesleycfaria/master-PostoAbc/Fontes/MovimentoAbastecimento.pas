unit MovimentoAbastecimento;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, FMTBcd, DB, SqlExpr, ComCtrls;

type
  TfMovimentoAbastecimento = class(TForm)
    gbxRegistro: TGroupBox;
    Label1: TLabel;
    edtID: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    cbxBomba: TComboBox;
    GroupBox2: TGroupBox;
    btnInserir: TButton;
    btnGravar: TButton;
    btnCancelar: TButton;
    btnConsultar: TButton;
    btnAlterar: TButton;
    btnExcluir: TButton;
    Query: TSQLQuery;
    dtpData: TDateTimePicker;
    cbxBombaId: TComboBox;
    Label4: TLabel;
    edtQuantidadeLitro: TEdit;
    Label5: TLabel;
    edtValor: TEdit;
    Label6: TLabel;
    edtImposto: TEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure btnInserirClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtQuantidadeLitroKeyPress(Sender: TObject; var Key: Char);
    procedure edtValorKeyPress(Sender: TObject; var Key: Char);
    procedure edtValorChange(Sender: TObject);
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
    procedure CarregaBombas;
  public

  end;

var
  fMovimentoAbastecimento: TfMovimentoAbastecimento;

implementation

uses uPrincipal, ConsultaAbastecimento;

{$R *.dfm}

procedure TfMovimentoAbastecimento.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfMovimentoAbastecimento.FormDestroy(Sender: TObject);
begin
  fMovimentoAbastecimento := nil;
end;

procedure TfMovimentoAbastecimento.btnInserirClick(Sender: TObject);
begin
  LimpaFormulario();
  HabilitaEdicao();
end;

procedure TfMovimentoAbastecimento.HabilitaEdicao;
begin
  gbxRegistro.Enabled := True;

  btnInserir.Enabled := False;
  btnGravar.Enabled := True;
  btnCancelar.Enabled := True;
  btnConsultar.Enabled := False;
  btnAlterar.Enabled := False;
  btnExcluir.Enabled := False;

  dtpData.SetFocus();
end;

procedure TfMovimentoAbastecimento.LimpaFormulario;
begin
  edtID.Text := '';
  dtpData.Date := Date();
  cbxBomba.ItemIndex := -1;
  edtQuantidadeLitro.Text := '0';
  edtValor.Text := '0';
  edtImposto.Text := '0,00'; 
end;

procedure TfMovimentoAbastecimento.btnGravarClick(Sender: TObject);
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

function TfMovimentoAbastecimento.ValidaGravacao: Boolean;
begin
  Result := False;

  if dtpData.Date = 0 then
  begin
    ShowMessage('Informe a data');
    dtpData.SetFocus();
    Exit;
  end;

  if cbxBomba.ItemIndex = -1 then
  begin
    ShowMessage('Informe a bomba de combustível');
    cbxBomba.SetFocus();
    Exit;
  end;

  if StrToIntDef(Trim(edtQuantidadeLitro.Text), 0) = 0 then
  begin
    ShowMessage('Informe a quantidade de litros');
    edtQuantidadeLitro.SetFocus();
    Exit;
  end;

  if StrToIntDef(Trim(edtValor.Text), 0) = 0 then
  begin
    ShowMessage('Informe o valor');
    edtValor.SetFocus();
    Exit;
  end;

  Result := True;
end;

procedure TfMovimentoAbastecimento.GravaRegistro;
begin
  Query.Close();
  Query.SQL.Clear();

  Query.SQL.Add('INSERT INTO ABASTECIMENTO(');
  Query.SQL.Add('  DATA,                   ');
  Query.SQL.Add('  BOMBA_ID,               ');
  Query.SQL.Add('  QUANTIDADE_LITRO,       ');
  Query.SQL.Add('  VALOR_ABASTECIMENTO,    ');
  Query.SQL.Add('  VALOR_IMPOSTO)          ');
  Query.SQL.Add('VALUES(                   ');
  Query.SQL.Add('  :DATA,                  ');
  Query.SQL.Add('  :BOMBA_ID,              ');
  Query.SQL.Add('  :QUANTIDADE_LITRO,      ');
  Query.SQL.Add('  :VALOR_ABASTECIMENTO,   ');
  Query.SQL.Add('  :VALOR_IMPOSTO)         ');

  Query.ParamByName('DATA').Value := FormatDateTime('YYYY-MM-DD', dtpData.Date);
  Query.ParamByName('BOMBA_ID').Value := cbxBombaId.Items[cbxBomba.ItemIndex];
  Query.ParamByName('QUANTIDADE_LITRO').Value := StrToIntDef(edtQuantidadeLitro.Text, 0);
  Query.ParamByName('VALOR_ABASTECIMENTO').Value := StrToIntDef(edtValor.Text, 0);
  Query.ParamByName('VALOR_IMPOSTO').Value := StrToFloatDef(edtImposto.Text, 0);

  Query.ExecSQL();
end;

procedure TfMovimentoAbastecimento.DesabilitaEdicao;
begin
  gbxRegistro.Enabled := False;

  btnInserir.Enabled := True;
  btnGravar.Enabled := False;
  btnCancelar.Enabled := False;
  btnConsultar.Enabled := True;
  btnAlterar.Enabled := edtId.Text <> '';
  btnExcluir.Enabled := edtId.Text <> '';
end;

procedure TfMovimentoAbastecimento.CarregaId;
begin
  Query.Close();
  Query.SQL.Clear();

  Query.SQL.Add('SELECT MAX(ID)    ');
  Query.SQL.Add('FROM ABASTECIMENTO');

  Query.Open();
  edtID.Text := Query.Fields[0].AsString;
  Query.Close();
end;

procedure TfMovimentoAbastecimento.btnCancelarClick(Sender: TObject);
begin
  if edtID.Text = '' then
    LimpaFormulario()
  else
    CarregaRegistro(edtID.Text);

  DesabilitaEdicao();
end;

procedure TfMovimentoAbastecimento.CarregaRegistro(Id: string);
begin
  Query.Close();
  Query.SQL.Clear();

  Query.SQL.Add('SELECT ID,                 ');
  Query.SQL.Add('       DATA,               ');
  Query.SQL.Add('       BOMBA_ID,           ');
  Query.SQL.Add('       QUANTIDADE_LITRO,   ');
  Query.SQL.Add('       VALOR_ABASTECIMENTO,');
  Query.SQL.Add('       VALOR_IMPOSTO       ');
  Query.SQL.Add('  FROM ABASTECIMENTO       ');
  Query.SQL.Add(' WHERE ID = :ID            ');

  Query.ParamByName('ID').Value := ID;

  Query.Open();

  if Query.IsEmpty then
  begin
    LimpaFormulario();
  end
  else
  begin
    edtId.Text := Query.FieldByName('ID').AsString;
    dtpData.Date := Query.FieldByName('DATA').AsDateTime;
    cbxBomba.ItemIndex := cbxBombaId.Items.IndexOf(Query.FieldByName('BOMBA_ID').AsString);
    edtQuantidadeLitro.Text := Query.FieldByName('QUANTIDADE_LITRO').AsString;
    edtValor.Text := Query.FieldByName('VALOR_ABASTECIMENTO').AsString;
    edtImposto.Text := FormatFloat('0.00', Query.FieldByName('VALOR_IMPOSTO').AsCurrency);
  end;

  Query.Close();
end;

procedure TfMovimentoAbastecimento.btnAlterarClick(Sender: TObject);
begin
  HabilitaEdicao();
end;

procedure TfMovimentoAbastecimento.btnConsultarClick(Sender: TObject);
begin
  fConsultaAbastecimento.Id := '0';
  fConsultaAbastecimento.ShowModal();

  if fConsultaAbastecimento.Id <> '0' then
  begin
    CarregaRegistro(fConsultaAbastecimento.Id);
    DesabilitaEdicao();
  end;
end;

procedure TfMovimentoAbastecimento.btnExcluirClick(Sender: TObject);
begin
  if Application.MessageBox('Confirma exclusão do registro?', 'Posto ABC', MB_YESNO + MB_ICONQUESTION) = ID_YES then
  begin
    ExcluiRegistro();
    LimpaFormulario();
    ShowMessage('Registro excluído com sucesso!');
  end;
end;

procedure TfMovimentoAbastecimento.ExcluiRegistro;
begin
  Query.Close();
  Query.SQL.Clear();

  Query.SQL.Add('DELETE FROM ABASTECIMENTO');
  Query.SQL.Add(' WHERE ID = :ID          ');

  Query.ParamByName('ID').Value := edtId.Text;

  Query.ExecSQL();
end;

procedure TfMovimentoAbastecimento.AlteraRegistro;
begin
  Query.Close();
  Query.SQL.Clear();

  Query.SQL.Add('UPDATE ABASTECIMENTO                             ');
  Query.SQL.Add('  SET DATA = :DATA,                              ');
  Query.SQL.Add('      BOMBA_ID = :BOMBA_ID,                      ');
  Query.SQL.Add('      QUANTIDADE_LITRO = :QUANTIDADE_LITRO,      ');
  Query.SQL.Add('      VALOR_ABASTECIMENTO = :VALOR_ABASTECIMENTO,');
  Query.SQL.Add('      VALOR_IMPOSTO = :VALOR_IMPOSTO             ');
  Query.SQL.Add('WHERE ID = :ID                                   ');

  Query.ParamByName('DATA').Value := FormatDateTime('YYYY-MM-DD', dtpData.Date);
  Query.ParamByName('BOMBA_ID').Value := cbxBombaId.Items[cbxBomba.ItemIndex];
  Query.ParamByName('QUANTIDADE_LITRO').Value := StrToIntDef(edtQuantidadeLitro.Text, 0);
  Query.ParamByName('VALOR_ABASTECIMENTO').Value := StrToIntDef(edtValor.Text, 0);
  Query.ParamByName('VALOR_IMPOSTO').Value := StrToFloatDef(edtImposto.Text, 0);
  Query.ParamByName('ID').Value := edtId.Text;

  Query.ExecSQL();
end;

procedure TfMovimentoAbastecimento.FormShow(Sender: TObject);
begin
  CarregaBombas();
  btnCancelar.Click;
end;

procedure TfMovimentoAbastecimento.CarregaBombas;
begin
  cbxBomba.Items.Clear();
  cbxBombaId.Items.Clear();

  Query.Close();
  Query.SQL.Clear();

  Query.SQL.Add('SELECT ID,         ');
  Query.SQL.Add('       DESCRICAO   ');
  Query.SQL.Add('  FROM BOMBA       ');
  Query.SQL.Add(' ORDER BY DESCRICAO');

  Query.Open();

  while not Query.Eof do
  begin
    cbxBomba.Items.Add(Query.FieldByName('DESCRICAO').AsString);
    cbxBombaId.Items.Add(Query.FieldByName('ID').AsString);

    Query.Next();
  end;

  Query.Close();
end;

procedure TfMovimentoAbastecimento.edtQuantidadeLitroKeyPress(
  Sender: TObject; var Key: Char);
begin
  if not(Key in ['0'..'9', #8]) then
  begin
    Key := #0;
  end;
end;

procedure TfMovimentoAbastecimento.edtValorKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not(Key in ['0'..'9', #8]) then
  begin
    Key := #0;
  end;
end;

procedure TfMovimentoAbastecimento.edtValorChange(Sender: TObject);
var
  Valor : Currency;
  Imposto : Currency;
begin
  Valor := StrToIntDef(edtValor.Text, 0);
  Imposto := Valor * 0.13;
  edtImposto.Text := FormatFloat('0.00', Imposto);
end;

end.
