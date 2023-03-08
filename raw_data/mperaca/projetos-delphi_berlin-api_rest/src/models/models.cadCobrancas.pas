unit models.cadCobrancas;

interface

type
  TCobrancas = class
    private
    Fid: integer;
    Fnome: string;
    Ftipo: string;
    public
      property id: integer read Fid write Fid;
      property nome: string read Fnome write Fnome;
      property tipo: string read Ftipo write Ftipo;
  end;

implementation

end.
