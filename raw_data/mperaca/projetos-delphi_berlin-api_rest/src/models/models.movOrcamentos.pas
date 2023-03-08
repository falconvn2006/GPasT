unit models.movOrcamentos;

interface

type
  TOrcamentos = class
    private
    Fvalorfrete: double;
    Ftotalpis: double;
    Ftotalcofins: double;
    Ftotalst: double;
    Fobservacao: text;
    Fidcondicao: integer;
    Fidempresa: integer;
    Fpercentualdesconto: double;
    Fhora: string;
    Fnumeroparcelas: integer;
    Fcobranca: string;
    Fsubtotal: double;
    Ffinalizado: boolean;
    Fvalorentrada: double;
    Fidtransportador: integer;
    Fcliente: string;
    Fbasest: double;
    Ftotal: double;
    Fvendedor: string;
    Fid: integer;
    Fsituacaofrete: string;
    Ftotaldesconto: double;
    Fnumero: integer;
    Fdataemissao: tdatetime;
    Fmaquinaorigem: string;
    Fcondicao: string;
    Ftotalicms: double;
    Fprecoutilizado: string;
    Fidcobranca: integer;
    Fidcliente: integer;
    Fdatavalidade: tdatetime;
    Ftransportador: string;
    Forigem: string;
    Fidvendedor: integer;
    Fbaseicms: double;
    Fidnotagerada: integer;
    Ftotaldespesa: double;
    Fbloqueado: boolean;
    public
      property id: integer read Fid write Fid;
      property idempresa: integer read Fidempresa write Fidempresa;
      property numero: integer read Fnumero write Fnumero;
      property idcliente: integer read Fidcliente write Fidcliente;
      property cliente: string read Fcliente write Fcliente;
      property idvendedor: integer read Fidvendedor write Fidvendedor;
      property vendedor: string read Fvendedor write Fvendedor;
      property idtransportador: integer read Fidtransportador write Fidtransportador;
      property transportador: string read Ftransportador write Ftransportador;
      property idcondicao: integer read Fidcondicao write Fidcondicao;
      property condicao: string read Fcondicao write Fcondicao;
      property idcobranca: integer read Fidcobranca write Fidcobranca;
      property cobranca: string read Fcobranca write Fcobranca;
      property dataemissao: tdatetime read Fdataemissao write Fdataemissao;
      property datavalidade: tdatetime read Fdatavalidade write Fdatavalidade;
      property total: double read Ftotal write Ftotal;
      property subtotal: double read Fsubtotal write Fsubtotal;
      property baseicms: double read Fbaseicms write Fbaseicms;
      property totalicms: double read Ftotalicms write Ftotalicms;
      property basest: double read Fbasest write Fbasest;
      property totalst: double read Ftotalst write Ftotalst;
      property hora: string read Fhora write Fhora;
      property totalpis: double read Ftotalpis write Ftotalpis;
      property totalcofins: double read Ftotalcofins write Ftotalcofins;
      property percentualdesconto: double read Fpercentualdesconto write Fpercentualdesconto;
      property totaldesconto: double read Ftotaldesconto write Ftotaldesconto;
      property totaldespesa: double read Ftotaldespesa write Ftotaldespesa;
      property observacao: text read Fobservacao write Fobservacao;
      property precoutilizado: string read Fprecoutilizado write Fprecoutilizado;
      property numeroparcelas: integer read Fnumeroparcelas write Fnumeroparcelas;
      property valorentrada: double read Fvalorentrada write Fvalorentrada;
      property origem: string read Forigem write Forigem;
      property valorfrete: double read Fvalorfrete write Fvalorfrete;
      property situacaofrete: string read Fsituacaofrete write Fsituacaofrete;
      property finalizado: boolean read Ffinalizado write Ffinalizado;
      property bloqueado: boolean read Fbloqueado write Fbloqueado;
      property idnotagerada: integer read Fidnotagerada write Fidnotagerada;
      property maquinaorigem: string read Fmaquinaorigem write Fmaquinaorigem;
  end;

  TOrcamentosAltera = class
    private
    Fidcondicao: integer;
    Fidempresa: integer;
    Fidtransportador: integer;
    Fdataemissao: tdatetime;
    Fidcobranca: integer;
    Fidcliente: integer;
    Fdatavalidade: tdatetime;
    Fidvendedor: integer;
    public
      property idcliente: integer read Fidcliente write Fidcliente;
      property idvendedor: integer read Fidvendedor write Fidvendedor;
      property idtransportador: integer read Fidtransportador write Fidtransportador;
      property idcondicao: integer read Fidcondicao write Fidcondicao;
      property idcobranca: integer read Fidcobranca write Fidcobranca;
      property dataemissao: tdatetime read Fdataemissao write Fdataemissao;
      property datavalidade: tdatetime read Fdatavalidade write Fdatavalidade;
  end;

  implementation

end.
