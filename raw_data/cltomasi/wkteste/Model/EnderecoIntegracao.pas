unit EnderecoIntegracao;

interface

type
  TEnderecoIntegracao = class
  private
    FIdEndereco: LongInt;
    FDsUF : string;
    FNmCidade: string;
    FNmBairro : string;
    FNmLogradouro : string;
    FDsComplemento: string;
  public
    constructor Create;
    procedure Salvar(const objetoEnderecoIntegracao: TEnderecoIntegracao);
    property IdEndereco: LongInt read FIdEndereco write FIdEndereco;
    property DsUF: string read FDsUF write FDsUF;
    property NmCidade: string read FNmCidade write FNmCidade;
    property NmBairro: string read FNmBairro write FNmBairro;
    property NmLogradouro: string read FNmLogradouro write FNmLogradouro;
    property DsComplemento: string read FDsComplemento write FDsComplemento;
  end;

implementation

constructor TEnderecoIntegracao.Create;
begin
  FIdEndereco    := 0;
  FDsUF          := '';
  FNmCidade      := '';
  FNmBairro      := '';
  FNmLogradouro  :='';
  FDsComplemento := '';
end;

procedure TEnderecoIntegracao.Salvar(const objetoEnderecoIntegracao: TEnderecoIntegracao);
begin
  // a rotina para salvar o cliente no banco de dados deve ser escrita aqui
end;

end.
