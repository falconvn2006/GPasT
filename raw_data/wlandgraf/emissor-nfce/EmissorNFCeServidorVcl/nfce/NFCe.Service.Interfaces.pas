unit NFCe.Service.Interfaces;

interface

uses
  System.Classes, System.SysUtils,

  XData.Service.Common,

  NFCe.DTO;

type
  [ServiceContract]
  [URIPath('nfce')]
  INFCeService = interface(IInvokable)
    ['{FE2B9A47-C1C5-4BF5-83C4-39F6F2EA7ABA}']
    [HttpGet, URIPath('status')]
    function StatusServico: TRetornoStatusServicoDTO;
    [HttpPost, URIPath('')]
    function Enviar(Nota: TNFCeDTO): TRetornoEnvioNFCeDTO;
    [HttpGet, URIPath('')]
    function Consultar([FromPathAttribute] chNFe: string): TRetornoConsultaNFCeDTO;
    [HttpDelete, URIPath('')]
    function Cancelar([FromPathAttribute] chNFe: string;
      idLote: integer; nProt: string; xJust: string): TRetornoEnvioEventoNFeDTO;
    [HttpGet, URIPath('xml')]
    function DownloadXml([FromPathAttribute] chNFe: string): TStream;
    [HttpGet, URIPath('pdf')]
    function DownloadPdf([FromPathAttribute] chNFe: string): TStream;
    [HttpPost, URIPath('inutilizacao')]
    function InutilizarNumeracao(ano: Integer; serie: Integer;
      nIni, nFin: integer; xJust: string): TRetornoInutilizacaoNFCeDTO;
  end;

implementation

initialization
  RegisterServiceType(TypeInfo(INFCeService));

end.
