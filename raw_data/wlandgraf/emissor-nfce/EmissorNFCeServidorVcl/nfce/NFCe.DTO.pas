unit NFCe.DTO;

interface

uses
  Generics.Collections,

  Bcl.Json.Attributes;

type
  TDestinatarioDTO = class;
  TDadosDetalheDTO = class;
  TDadosPagamentoDTO = class;
  TDetalhamentoPagamentoDTO = class;
  TGrupoCartaoDTO = class;
  TProtocoloNFCeDTO = class;
  TEventoNFeDTO = class;
  TDetEventoDTO = class;
  TRetornoEventoNFeDTO = class;
  TProtocoloEventoNFeDTO = class;

  TRetornoStatusServicoDTO = class
  public
    cStat: integer;
    xMotivo: string;
    versao: string;
    tpAmb: string;
    verAplic: string;
    cUF: integer;
    dhRecbto: TDateTime;
    xObs: string;
  end;

  TRetornoEnvioNFCeDTO = class
  public
    cStat: integer;
    xMotivo: string;
    versao: string;
    tpAmb: string;
    verAplic: string;
    cUF: integer;
    protNFe: TProtocoloNFCeDTO;
  end;

  TProtocoloNFCeDTO = class
  public
    chNFe: string;
    dhRecbto: TDateTime;
    nProt: string;
    digVal: string;
    cStat: integer;
    xMotivo: string;
  end;

  TRetornoConsultaNFCeDTO = class
  public
    constructor Create;
    destructor Destroy; override;
  public
    cStat: integer;
    xMotivo: string;
    versao: string;
    tpAmb: string;
    verAplic: string;
    cUF: integer;
    dhRecbto: TDateTime;
    chNFe: string;
    protNFe: TProtocoloNFCeDTO;
    procEventoNFe: TList<TProtocoloEventoNFeDTO>;
  end;

  TRetornoInutilizacaoNFCeDTO = class
  public
    cStat: integer;
    xMotivo: string;
    versao: string;
    tpAmb: string;
    verAplic: string;
    cUF: integer;
    dhRecbto: TDateTime;
    nProt: string;
  end;

  TProtocoloEventoNFeDTO = class
  public
    evento: TEventoNFeDTO;
    retEvento: TRetornoEventoNFeDTO;
  end;

  TDetEventoDTO = class
  end;

  TDetEventoCancelamentoDTO = class(TDetEventoDTO)
  public
    nProt: string;
    xJust: string;
  end;

  TEventoNFeDTO = class
  public
    id: string;
    cOrgao: integer;
    tpAmb: string;
    CNPJ: string;
    chNFe: string;
    dhEvento: TDateTime;
    tpEvento: string;
    nSeqEvento: integer;
    versaoEvento: string;
    detEvento: TDetEventoDTO;
    DescEvento: string;
    TipoEvento: string;
  end;

  TRetornoEnvioEventoNFeDTO = class
  public
    cStat: integer;
    xMotivo: string;
    idLote: integer;
    tpAmb: string;
    verAplic: string;
    cOrgao: integer;
    retEvento: TRetornoEventoNFeDTO;
  end;

  TRetornoEventoNFeDTO = class
  public
    Id: string;
    tpAmb: string;
    verAplic: string;
    cOrgao: integer;
    cStat: integer;
    xMotivo: string;
    chNFe: string;
    tpEvento: string;
    xEvento: string;
    nSeqEvento: integer;
    CNPJDest: string;
    emailDest: string;
    cOrgaoAutor: integer;
    dhRegEvento: TDateTime;
    nProt: string;
  end;

  TNFCeDTO = class
  public
    constructor Create;
    destructor Destroy; override;
    procedure Release;
  public
    natOp: string;
    serie: integer;
    nNF: integer;
    dhEmi: TDateTime;
    idDest: integer;
    indPres: integer;
    dest: TDestinatarioDTO;
    det: TList<TDadosDetalheDTO>;
    pag: TDadosPagamentoDTO;
  end;

  TDestinatarioDTO = class
  public
    CpfCnpj: string;
    xNome: string;
    Email: string;
  end;

  TDadosDetalheDTO = class
  public
    nItem: integer;
    cProd: string;
    cEAN: string;
    xProd: string;
    NCM: string;
    CFOP: string;
    uCom: string;
    qCom: double;
    vUnCom: double;
    vProd: double;
    cEANTrib: string;
    uTrib: string;
    qTrib: double;
    vUnTrib: double;
    vDesc: Double;
    vOutro: Double;
    vTotTrib: Double;
  end;

  TDadosPagamentoDTO = class
  public
    constructor Create;
    destructor Destroy; override;
    procedure Release;
  public
    detPag: TList<TDetalhamentoPagamentoDTO>;
    vTroco: double;
  end;

  TDetalhamentoPagamentoDTO = class
  public
    procedure Release;
  public
    tPag: integer;
    vPag: Double;
    card: TGrupoCartaoDTO;
  end;

  TGrupoCartaoDTO = class
  public
    tpIntegra: integer;
    CNPJ: string;
    tBand: integer;
    cAut: string;
  end;

implementation

{ TNotaFiscalDTO }

constructor TNFCeDTO.Create;
begin
  det := TList<TDadosDetalheDTO>.Create;
end;

destructor TNFCeDTO.Destroy;
begin
  det.Free;
  inherited;
end;

procedure TNFCeDTO.Release;
var
  DetItem: TDadosDetalheDTO;
begin
  if Self = nil then Exit;
  dest.Free;
  if Assigned(det) then
    for DetItem in det do
      DetItem.Free;
  if Assigned(pag) then
    pag.Release;
  Self.Free;
end;

{ TDadosPagamentoDTO }

constructor TDadosPagamentoDTO.Create;
begin
  detPag := TList<TDetalhamentoPagamentoDTO>.Create;
end;

destructor TDadosPagamentoDTO.Destroy;
begin
  detPag.Free;
  inherited;
end;

procedure TDadosPagamentoDTO.Release;
var
  PagItem: TDetalhamentoPagamentoDTO;
begin
  if Self = nil then Exit;
  
  for PagItem in detPag do
    PagItem.Release;
  Self.Free;
end;

{ TRetornoConsultaNFCeDTO }

constructor TRetornoConsultaNFCeDTO.Create;
begin
  procEventoNFe := TList<TProtocoloEventoNFeDTO>.Create;
end;

destructor TRetornoConsultaNFCeDTO.Destroy;
begin
  procEventoNFe.Free;
  inherited;
end;

{ TDetalhamentoPagamentoDTO }

procedure TDetalhamentoPagamentoDTO.Release;
begin
  if Self = nil then Exit;

  card.Free;
  Self.Free;
end;

end.
