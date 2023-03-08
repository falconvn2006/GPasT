unit models.cadAliquotasICM;

interface

type
  TAliquotas = class
    private
      Fid: integer;
      Fcodigo: string;
      Fdescricao: string;
      Fpercentual: double;
      Fpercentualsc: double;
      Fpercentualsp: double;
      Fbasecalculo: double;
      Fsomaisentos: boolean;
      Fsomaoutros: boolean;

    public
      property id: integer read Fid write Fid;
      property codigo: string read Fcodigo write Fcodigo;
      property descricao: string read Fdescricao write Fdescricao;
      property percentual: double read Fpercentual write Fpercentual;
      property basecalculo: double read Fbasecalculo write Fbasecalculo;
      property percentualsc: double read Fpercentualsc write Fpercentualsc;
      property percentualsp: double read Fpercentualsp write Fpercentualsp;
      property somaisentos: boolean read Fsomaisentos write Fsomaisentos;
      property somaoutros: boolean read Fsomaoutros write Fsomaoutros;
  end;

implementation

end.
