unit models.cadCondicoes;

interface

type
  TCondicoes = class
    private
    Fdescricao: string;
    Fid: integer;
    Fnumpag: integer;
    Ftipo: string;
    public
      property id: integer read Fid write Fid;
      property descricao: string read Fdescricao write Fdescricao;
      property tipo: string read Ftipo write Ftipo;
      property numpag: integer read Fnumpag write Fnumpag;
  end;

implementation

end.
