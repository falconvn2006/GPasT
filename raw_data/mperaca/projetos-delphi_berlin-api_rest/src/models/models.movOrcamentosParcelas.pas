unit models.movOrcamentosParcelas;

interface

type
  TOrcamentosParcelas = class
    private
    Fvalordespesa: double;
    Foperacao: tdate;
    Fvalororiginal: double;
    Fportador: string;
    Fidcondicao: integer;
    Fidfornecedor: integer;
    Fvalorfinal: double;
    Fvalordesconto: double;
    Fcobranca: string;
    Fcliente: string;
    Fidclassificacao: integer;
    Fvencimento: tdate;
    Fvendedor: string;
    Fid: integer;
    Fnumero: integer;
    Fidportador: integer;
    Fcondicao: string;
    Femissao: tdate;
    Fidorcamento: integer;
    Ffornecedor: string;
    Fsituacao: string;
    Fidcobranca: integer;
    Fnumeropagamentos: integer;
    Fidcliente: integer;
    Fclassificacao: string;
    Fidvendedor: integer;
    public
      property id: integer read Fid write Fid;
      property idorcamento: integer read Fidorcamento write Fidorcamento;
      property numero: integer read Fnumero write Fnumero;
      property numeropagamentos: integer read Fnumeropagamentos write Fnumeropagamentos;
      property valororiginal: double read Fvalororiginal write Fvalororiginal;
      property valordespesa: double read Fvalordespesa write Fvalordespesa;
      property valordesconto: double read Fvalordesconto write Fvalordesconto;
      property valorfinal: double read Fvalorfinal write Fvalorfinal;
      property emissao: tdate read Femissao write Femissao;
      property vencimento: tdate read Fvencimento write Fvencimento;
      property operacao: tdate read Foperacao write Foperacao;
      property situacao: string read Fsituacao write Fsituacao;
      property idcondicao: integer read Fidcondicao write Fidcondicao;
      property condicao: string read Fcondicao write Fcondicao;
      property idcliente: integer read Fidcliente write Fidcliente;
      property cliente: string read Fcliente write Fcliente;
      property idfornecedor: integer read Fidfornecedor write Fidfornecedor;
      property fornecedor: string read Ffornecedor write Ffornecedor;
      property idvendedor: integer read Fidvendedor write Fidvendedor;
      property vendedor: string read Fvendedor write Fvendedor;
      property idportador: integer read Fidportador write Fidportador;
      property portador: string read Fportador write Fportador;
      property idclassificacao: integer read Fidclassificacao write Fidclassificacao;
      property classificacao: string read Fclassificacao write Fclassificacao;
      property idcobranca: integer read Fidcobranca write Fidcobranca;
      property cobranca: string read Fcobranca write Fcobranca;
  end;

implementation

end.
