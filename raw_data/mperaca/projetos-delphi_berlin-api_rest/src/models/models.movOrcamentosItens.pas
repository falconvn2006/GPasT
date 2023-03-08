unit models.movOrcamentosItens;

interface

type
  TOrcamentosItens = class
    private
    Fidaliquota: integer;
    Fpercentualdesconto: double;
    Fcodigofiscal: string;
    Fvalordesconto: double;
    Fpercentualicms: double;
    Fidsituacaotributaria: integer;
    Fpercentualbasepis: double;
    Fpercentualbasecofins: double;
    Fbasest: double;
    Fvalorunitario: double;
    Fvaloricms: double;
    Fcodaliquota: string;
    Fvendedor: string;
    Fidproduto: integer;
    Fid: integer;
    Fcstpis: string;
    Fcstcofins: string;
    Fvalortotal: double;
    Fpercentualpis: double;
    Fidorcamento: integer;
    Fpercentualcofins: double;
    Fquantidade: double;
    Fidcodigofiscal: integer;
    Fvalorpis: double;
    Fvalorcofins: double;
    Fcodproduto: string;
    Fvalorst: double;
    Fsituacaotributaria: string;
    Fdescproduto: string;
    Fidvendedor: integer;
    Fbaseicms: double;
    public
      property id: integer read Fid write Fid;
      property idorcamento: integer read Fidorcamento write Fidorcamento;
      property idproduto: integer read Fidproduto write Fidproduto;
      property codproduto: string read Fcodproduto write Fcodproduto;
      property descproduto: string read Fdescproduto write Fdescproduto;
      property idaliquota: integer read Fidaliquota write Fidaliquota;
      property codaliquota: string read Fcodaliquota write Fcodaliquota;
      property idvendedor: integer read Fidvendedor write Fidvendedor;
      property vendedor: string read Fvendedor write Fvendedor;
      property idsituacaotributaria: integer read Fidsituacaotributaria write Fidsituacaotributaria;
      property situacaotributaria: string read Fsituacaotributaria write Fsituacaotributaria;
      property idcodigofiscal: integer read Fidcodigofiscal write Fidcodigofiscal;
      property codigofiscal: string read Fcodigofiscal write Fcodigofiscal;
      property valorunitario: double read Fvalorunitario write Fvalorunitario;
      property valortotal: double read Fvalortotal write Fvalortotal;
      property quantidade: double read Fquantidade write Fquantidade;
      property percentualicms: double read Fpercentualicms write Fpercentualicms;
      property baseicms: double read Fbaseicms write Fbaseicms;
      property valoricms: double read Fvaloricms write Fvaloricms;
      property basest: double read Fbasest write Fbasest;
      property valorst: double read Fvalorst write Fvalorst;
      property percentualpis: double read Fpercentualpis write Fpercentualpis;
      property percentualcofins: double read Fpercentualcofins write Fpercentualcofins;
      property percentualbasepis: double read Fpercentualbasepis write Fpercentualbasepis;
      property percentualbasecofins: double read Fpercentualbasecofins write Fpercentualbasecofins;
      property valorpis: double read Fvalorpis write Fvalorpis;
      property valorcofins: double read Fvalorcofins write Fvalorcofins;
      property cstpis: string read Fcstpis write Fcstpis;
      property cstcofins: string read Fcstcofins write Fcstcofins;
      property percentualdesconto: double read Fpercentualdesconto write Fpercentualdesconto;
      property valordesconto: double read Fvalordesconto write Fvalordesconto;
  end;

  TOrcamentosItensCria = class
    private
    Fvalorunitario: double;
    Fidcliente: integer;
    Fquantidade: double;
    public
      property idproduto: integer read Fidcliente write Fidcliente;
      property quantidade: double read Fquantidade write Fquantidade;
      property valorunitario: double read Fvalorunitario write Fvalorunitario;
  end;

  implementation

end.
