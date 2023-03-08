unit UnCadastro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.NumberBox, Vcl.Mask, Vcl.Buttons, Vcl.ExtCtrls, Pessoa, EnderecoIntegracao, Endereco;

type
  TFrmCadastro = class(TForm)
    Lbflnatureza: TLabel;
    Edflnatureza: TNumberBox;
    Lbdsdocumento: TLabel;
    Eddsdocumento: TEdit;
    Lbnmprimeiro: TLabel;
    Ednmprimeiro: TEdit;
    Lbnmsegundo: TLabel;
    Ednmsegundo: TEdit;
    Lbdtregistro: TLabel;
    Eddtregistro: TDateTimePicker;
    Panel1: TPanel;
    BtnGravar: TBitBtn;
    BtnSair: TBitBtn;
    LbCodigo: TLabel;
    EdCEP: TMaskEdit;
    LbNmLogradouro: TLabel;
    LbDsComplemento: TLabel;
    LbNmBairro: TLabel;
    LbNmCidade: TLabel;
    LbdsUF: TLabel;
    LbNmLogradouroDado: TLabel;
    LbDsComplementoDado: TLabel;
    LbNmBairroDado: TLabel;
    LbNmCidadeDado: TLabel;
    LbdsUFDado: TLabel;
    procedure FormShow(Sender: TObject);
    procedure EdCEPExit(Sender: TObject);
    procedure BtnGravarClick(Sender: TObject);
  private
    { Private declarations }
    oPessoa : TPessoa;
    oEndereco : TEndereco;
    oEnderecoIntegracao : TEnderecoIntegracao;
  public
    { Public declarations }
    idPessoa : LONGint;
  end;

var
  FrmCadastro: TFrmCadastro;

implementation

uses
  ControllerPessoa, ControllerEnderecoIntegracao, ControllerEndereco;

{$R *.dfm}

procedure TFrmCadastro.BtnGravarClick(Sender: TObject);
var
  cPessoa : TControlePessoa;
  cEndereco : TControleEndereco;
  cEnderecoIntegracao : TControleEnderecoIntegracao;
begin
  try
    oPessoa.FLNatureza := Edflnatureza.ValueInt;
    oPessoa.DsDocumento := Eddsdocumento.Text;
    oPessoa.NmPrimeiro := Ednmprimeiro.Text;
    oPessoa.NmSegundo := Ednmsegundo.Text;
    oPessoa.DtRegistro := Eddtregistro.DateTime;
    oEndereco.DsCep := EdCEP.Text;
  except
    on E: Exception do
    begin
       messagedlg(e.Message, mtError, [mbOK], 0);
       Self.ModalResult := mrNone;
       exit;
    end;
  end;
  cPessoa := TControlePessoa.Create;
  cEndereco := TControleEndereco.Create;
  cEnderecoIntegracao := TControleEnderecoIntegracao.Create;
  try
    if not cPessoa.RegistroExistente(oPessoa.IdPessoa) then
      cPessoa.InserirRegistro(oPessoa)
    else
      cPessoa.AlterarRegistro(oPessoa);

    if not cEndereco.RegistroExistente(oEndereco.IdPessoa) then
      cEndereco.InserirRegistro(oEndereco)
    else
      cEndereco.AlterarRegistro(oEndereco);

    if not cEnderecoIntegracao.RegistroExistente(oEnderecoIntegracao.IdEndereco) then
      cEnderecoIntegracao.InserirRegistro(oEnderecoIntegracao)
    else
      cEnderecoIntegracao.AlterarRegistro(oEnderecoIntegracao);

  finally
    cPessoa.Free;
    cEndereco.Free;
    cEnderecoIntegracao.Free;
  end;
end;

procedure TFrmCadastro.EdCEPExit(Sender: TObject);
var
  cEnderecoIntegracao :  TControleEnderecoIntegracao;
begin
  cEnderecoIntegracao := TControleEnderecoIntegracao.Create;

  try
    if not cEnderecoIntegracao.BuscaPorCEP(EdCEP.Text, oEnderecoIntegracao) then
    begin
      MessageDlg('CEP Inválido', mtWarning, [mbOK],0);
      EdCEP.SetFocus;
    end
    else begin
      LbNmLogradouro.Caption := 'Logradouro: '+oEnderecoIntegracao.NmLogradouro;
      LbNmBairro.Caption := 'Bairro: '+oEnderecoIntegracao.NmBairro;
      LbNmCidade.Caption := 'Cidade: '+oEnderecoIntegracao.NmCidade;
      lbdsuf.Caption := 'UF: '+oEnderecoIntegracao.DsUF;
      LbDsComplemento.Caption := 'Complemento: '+oEnderecointegracao.DsComplemento;

      oEndereco.IdPessoa := oPessoa.IdPessoa;
      oEndereco.IdEndereco := oEnderecoIntegracao.IdEndereco;
      oEndereco.DsCep := EdCEP.Text;
    end;
  finally
    cEnderecoIntegracao.Free;
  end;
end;

procedure TFrmCadastro.FormShow(Sender: TObject);
var
  cPessoa : TControlePessoa;
  cEndereco : TControleEndereco;
  cEnderecoIntegracao : TControleEnderecoIntegracao;
begin
    cPessoa := TControlePessoa.Create;
    cEndereco := TControleEndereco.Create;
    cEnderecoIntegracao := TControleEnderecoIntegracao.Create;

    oPessoa := TPessoa.Create;
    oEnderecoIntegracao := TEnderecoIntegracao.Create;
    oEndereco := TEndereco.Create;
    try
      if idPessoa <> 0 then
      begin
        oPessoa.IdPessoa := idPessoa;
        cPessoa.DadosPessoa(oPessoa);
        lbCodigo.Caption := 'Código: '+inttostr(oPessoa.IdPessoa);
        Edflnatureza.Value := oPessoa.FLNatureza;
        Eddsdocumento.Text := oPessoa.DsDocumento;
        Ednmprimeiro.Text := oPessoa.NmPrimeiro;
        Ednmsegundo.Text := oPessoa.NmSegundo;
        Eddtregistro.DateTime := oPessoa.DtRegistro;
        oEndereco.IdPessoa := oPessoa.IdPessoa;
        cEndereco.DadosEndereco(oEndereco);
        if oEndereco.IdEndereco <> 0 then
        begin
          oEnderecoIntegracao.IdEndereco := oEndereco.IdEndereco;
          cEnderecoIntegracao.DadosEnderecoIntegracao(oEnderecoIntegracao);

          EdCEP.Text := oEndereco.DsCep;
          LbNmLogradouroDado.Caption := oEnderecoIntegracao.NmLogradouro;
          LbNmBairroDado.Caption := oEnderecoIntegracao.NmBairro;
          LbNmCidadeDado.Caption := oEnderecoIntegracao.NmCidade;
          lbdsufDado.Caption := oEnderecoIntegracao.DsUF;
          LbDsComplementoDado.Caption := oEnderecointegracao.DsComplemento;
        end;
      end
      else begin
        cPessoa.BuscaIdPessoa(oPessoa);
        lbCodigo.Caption := 'Código: '+inttostr(oPessoa.IdPessoa);
      end;
    finally
      cPessoa.Free;
      cEndereco.Free;
      cEnderecoIntegracao.Free;
    end;
end;

end.
