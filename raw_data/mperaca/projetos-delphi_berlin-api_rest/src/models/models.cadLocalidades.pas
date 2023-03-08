unit models.cadLocalidades;

interface

type
  TLocalidades = class
    private
      Fid: integer;
      Fnome: string;
      Fuf: string;
      Fregiao: string;
      Fcodibge: integer;
    public
      property id: integer read Fid write Fid;
      property nome: string read Fnome write Fnome;
      property uf: string read Fuf write Fuf;
      property regiao: string read Fregiao write Fregiao;
      property codibge: integer read Fcodibge write Fcodibge;
  end;

implementation

end.
