unit models.cadAtividades;

interface

type
  TAtividades = class
    private
      Fid: integer;
      Fnome: string;
    public
      property id: integer read Fid write Fid;
      property nome: string read Fnome write Fnome;
  end;

implementation

end.
