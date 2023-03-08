unit frmCadPessoa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  EnderecoIntegracaoModel;

type
  TfCadPessoa = class(TForm)
    edtNome: TEdit;
    cbPJ: TCheckBox;
    edtSobrenome: TEdit;
    edtDocumento: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edtDtCadastro: TDateTimePicker;
    Label4: TLabel;
    btnSalvar: TButton;
    edtCep: TEdit;
    Label5: TLabel;
    edtRua: TEdit;
    Label6: TLabel;
    edtBairro: TEdit;
    Label7: TLabel;
    edtUF: TEdit;
    Label8: TLabel;
    edtCidade: TEdit;
    Label9: TLabel;
    procedure btnSalvarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtCepExit(Sender: TObject);
    procedure edtNomeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FEnderecoIntegracao: TEnderecoIntegracao;
    procedure setEnderecoIntegracao(const Value: TEnderecoIntegracao);

    { Private declarations }
  public
    { Public declarations }
    property EnderecoIntegracao : TEnderecoIntegracao read FEnderecoIntegracao write setEnderecoIntegracao;
    procedure LimparCampos;
  end;

var
  fCadPessoa: TfCadPessoa;

implementation

uses
  ClienteModel, PessoaController, CepConsulta, EnderecoModel;

{$R *.dfm}

procedure TfCadPessoa.btnSalvarClick(Sender: TObject);
var
  pessoa : TPessoa;
  pessoaController : TPessoaController;
begin
  pessoa                                 := TPessoa.Create;
  pessoa.FlNatureza                      := cbPJ.Checked.ToInteger;
  pessoa.DsDocumento                     := edtDocumento.Text;
  pessoa.NmPrimeiro                      := edtNome.Text;
  pessoa.NmSegundo                       := edtSobrenome.Text;
  pessoa.DtRegistro                      := edtDtCadastro.Date;
  pessoa.Endereco.DsCep                  := edtCep.Text;
  pessoa.EnderecoIntegracao.DsUf         := edtUF.Text;
  pessoa.EnderecoIntegracao.NmCidade     := edtCidade.Text;
  pessoa.EnderecoIntegracao.NmBairro     := edtBairro.Text;
  pessoa.EnderecoIntegracao.NmLogradouro := edtRua.Text;

  pessoaController := TPessoaController.Create;
  pessoaController.Insert(pessoa, pessoaController);
end;

procedure TfCadPessoa.edtCepExit(Sender: TObject);
var
  consultaCep : TCepConsulta;
begin
  try
    consultaCep := TCepConsulta.Create;
    consultaCep.ConsultarCEP(edtCep.Text);
  finally
    FreeAndNil(consultaCep);
  end;
end;

procedure TfCadPessoa.edtNomeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    Perform(WM_NEXTDLGCTL, 0, 0);
end;

procedure TfCadPessoa.FormShow(Sender: TObject);
begin
  LimparCampos();
end;

procedure TfCadPessoa.LimparCampos();
begin
  cbPJ.Checked := False;
  edtNome.Clear;
  edtSobrenome.Clear;
  edtDocumento.Clear;
  edtCep.Clear;
  edtRua.Clear;
  edtBairro.Clear;
  edtCidade.Clear;
  edtUF.Clear;
  edtDtCadastro.Date := Now;
end;

procedure TfCadPessoa.setEnderecoIntegracao(const Value: TEnderecoIntegracao);
begin
  FEnderecoIntegracao := Value;

  edtRua.Text    := FEnderecoIntegracao.NmLogradouro;
  edtBairro.Text := FEnderecoIntegracao.NmBairro;
  edtCidade.Text := FEnderecoIntegracao.NmCidade;
  edtUF.Text     := FEnderecoIntegracao.DsUf;
end;

end.
