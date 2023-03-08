unit models.cadClientes;

interface

type
  TClientes = class
    private
    Fcnpj: string;
    Fbairro: string;
    Finscest: string;
    Fuf: string;
    Fcodigo: integer;
    Fcpf: string;
    Fcep: string;
    Fid: integer;
    Fcomplemento: string;
    Fnome: string;
    Fcidade: string;
    Fendereco: string;
    Ftelefone: string;
    public
      property id: integer read Fid write Fid;
      property nome: string read Fnome write Fnome;
      property codigo: integer read Fcodigo write FCodigo;
      property cpf: string read Fcpf write Fcpf;
      property cnpj: string read Fcnpj write Fcnpj;
      property inscest: string read Finscest write Finscest;
      property cidade: string read Fcidade write Fcidade;
      property uf: string read Fuf write Fuf;
      property endereco: string read Fendereco write Fendereco;
      property complemento: string read Fcomplemento write Fcomplemento;
      property bairro: string read Fbairro write Fbairro;
      property cep: string read Fcep write Fcep;
      property telefone: string read Ftelefone write Ftelefone;
  end;

implementation

end.
