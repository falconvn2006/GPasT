unit models.movNFePendentesParcelas;

interface

type
  TParcelas = class
    private
    Foperacao: tdate;
    Fvalor: double;
    Fvencimento: tdate;
    Fid: integer;
    Fnumero: integer;
    Femissao: tdate;
    Fsituacao: string;
    public
      property id: integer read Fid write Fid;
      property numero: integer read Fnumero write Fnumero;
      property valor: double read Fvalor write Fvalor;
      property emissao: tdate read Femissao write Femissao;
      property vencimento: tdate read Fvencimento write Fvencimento;
      property operacao: tdate read Foperacao write Foperacao;
      property situacao: string read Fsituacao write Fsituacao;
  end;

implementation

end.
