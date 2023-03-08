unit untEditar;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask;

type
  TfrmEditar = class(TForm)
    lblCep: TLabel;
    edtNmSegundo: TEdit;
    lblNmSegundo: TLabel;
    edtNmPrimeiro: TEdit;
    lblNmPrimeiro: TLabel;
    edtDsDocumento: TEdit;
    lblDsDocumento: TLabel;
    edtFlNatureza: TEdit;
    lblFlNatureza: TLabel;
    btnEditar: TButton;
    btnFechar: TButton;
    edtCep: TMaskEdit;
    procedure btnEditarClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    function ValidaObrigatorios: boolean;
    procedure LimpaCampos;
  public
    { Public declarations }
  end;

var
  frmEditar: TfrmEditar;

implementation

{$R *.dfm}

uses ClientClassesUnit1, ClientModuleUnit1, untCliente;

procedure TfrmEditar.btnEditarClick(Sender: TObject);
var
  idPessoa, flnatureza: integer;
  dsdocumento, nmprimeiro, nmsegundo, dscep: string;
  dtregistro: TDateTime;
begin
  if not frmCliente.ChecarConexao then
    exit;

  if not ValidaObrigatorios then
  begin
    exit;
  end
  else
  begin
    idPessoa := ClientModule1.cdsPessoaidpessoa.AsInteger;
    flnatureza := StrToInt(edtFlNatureza.Text);
    dsdocumento := edtDsDocumento.Text;
    nmprimeiro := edtNmPrimeiro.Text;
    nmsegundo := edtNmSegundo.Text;
    dscep := edtCep.Text;
    dtregistro := now;
    ClientModule1.ServerMethods1Client.Update(idPessoa, flnatureza,
      dsdocumento, nmprimeiro, nmsegundo, dscep, dtregistro);
    frmCliente.AtualizaGrid;
    LimpaCampos;
  end;
end;

procedure TfrmEditar.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmEditar.FormShow(Sender: TObject);
begin
  edtFlNatureza.Text := ClientModule1.cdsPessoaflnatureza.AsString;
  edtDsDocumento.Text := ClientModule1.cdsPessoadsdocumento.AsString;
  edtNmPrimeiro.Text := ClientModule1.cdsPessoanmprimeiro.AsString;
  edtNmSegundo.Text := ClientModule1.cdsPessoanmsegundo.AsString;
  edtCep.Text := ClientModule1.cdsPessoadscep.AsString;
end;

procedure TfrmEditar.LimpaCampos;
begin
  edtFlNatureza.Clear;
  edtDsDocumento.Clear;
  edtNmPrimeiro.Clear;
  edtNmSegundo.Clear;
  edtCep.Clear;
  edtFlNatureza.SetFocus;
end;

function TfrmEditar.ValidaObrigatorios: boolean;
begin
  Result := true;
  if edtFlNatureza.Text = EmptyStr then
  begin
    Application.MessageBox('O campo Natureza é de preenchimento obrigatório','Aviso',mb_Ok+mb_IconExclamation);
    edtFlNatureza.SetFocus;
    Result := false;
  end;
  if edtDsDocumento.Text = EmptyStr then
  begin
    Application.MessageBox('O campo Descrição documento é de preenchimento obrigatório','Aviso',mb_Ok+mb_IconExclamation);
    edtDsDocumento.SetFocus;
    Result := false;
  end;
  if edtNmPrimeiro.Text = EmptyStr then
  begin
    Application.MessageBox('O campo Primeiro nome é de preenchimento obrigatório','Aviso',mb_Ok+mb_IconExclamation);
    edtNmPrimeiro.SetFocus;
    Result := false;
  end;
  if edtNmSegundo.Text = EmptyStr then
  begin
    Application.MessageBox('O campo Segundo nome é de preenchimento obrigatório','Aviso',mb_Ok+mb_IconExclamation);
    edtNmSegundo.SetFocus;
    Result := false;
  end;
  if edtCep.Text = EmptyStr then
  begin
    Application.MessageBox('O campo Cep é de preenchimento obrigatório','Aviso',mb_Ok+mb_IconExclamation);
    edtCep.SetFocus;
    Result := false;
  end;
  if Length(Trim(edtCep.Text)) < 8 then
  begin
    Application.MessageBox('O campo Cep deve ter 8 números','Aviso',mb_Ok+mb_IconExclamation);
    edtCep.SetFocus;
    Result := false;
  end;
end;

end.
