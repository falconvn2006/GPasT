unit models.cadProdutos;

interface

type
  TProdutos = class
    private
    Fcean: string;
    Fpreco: string;
    Fdescricao: string;
    Fcodigo: integer;
    Fid: integer;
    Ffabricante: string;
    Funidade: string;
    Fmarca: string;
    Fcidade: string;
    public
      property id: integer read Fid write Fid;
      property codigo: integer read Fcodigo write FCodigo;
      property descricao: string read Fdescricao write Fdescricao;
      property unidade: string read Funidade write Funidade;
      property cean: string read Fcean write Fcean;
      property marca: string read Fmarca write Fmarca;
      property fabricante: string read Ffabricante write Ffabricante;
      property preco: string read Fpreco write Fpreco;
  end;

implementation

end.
