unit NFCe.Service;

interface

uses
  System.Classes, System.SysUtils, System.Generics.Collections,

  XData.Server.Module,
  XData.Service.Common,
  XData.Sys.Exceptions,

  NFCe.Service.Interfaces,
  NFCe.DTO,
  NFCe.Emissor;

type
  [ServiceImplementation]
  TNFCeService = class(TInterfacedObject, INFCeService)
  public
    function StatusServico: TRetornoStatusServicoDTO;
    function Enviar(Nota: TNFCeDTO): TRetornoEnvioNFCeDTO;
    function Consultar(chNFe: string): TRetornoConsultaNFCeDTO;
    function Cancelar(chNFe: string; idLote: integer;
      nProt: string; xJust: string): TRetornoEnvioEventoNFeDTO;
    function DownloadXml(chNFe: string): TStream;
    function DownloadPdf(chNFe: string): TStream;
    function InutilizarNumeracao(ano: Integer; serie: Integer;
      nIni, nFin: integer; xJust: string): TRetornoInutilizacaoNFCeDTO;
  end;

implementation

uses
  Server.Config;

{ TNFCeService }

function TNFCeService.Cancelar(chNFe: string; idLote: Integer; nProt,
  xJust: string): TRetornoEnvioEventoNFeDTO;
var
  Emissor: TEmissorNFCe;
begin
  Emissor := TEmissorNFCe.Create(ServerConfig);
  try
    Result := Emissor.Cancelar(chNFe, idLote, nProt, xJust);
  finally
    Emissor.Free;
  end;
end;

function TNFCeService.Consultar(chNFe: string): TRetornoConsultaNFCeDTO;
var
  Emissor: TEmissorNFCe;
begin
  Emissor := TEmissorNFCe.Create(ServerConfig);
  try
    Result := Emissor.Consultar(chNFe);
  finally
    Emissor.Free;
  end;
end;

function TNFCeService.DownloadPdf(chNFe: string): TStream;
var
  Emissor: TEmissorNFCe;
  Pdf: TBytes;
begin
  TXDataOperationContext.Current.Response.Headers
    .SetValue('content-type', 'application/pdf');
  Emissor := TEmissorNFCe.Create(ServerConfig);
  try
    Result := TMemoryStream.Create;
    try
      Pdf := Emissor.DownloadPdf(chNFe);
      Result.Write(Pdf, Length(Pdf));
    except
      Result.Free;
      raise;
    end;
  finally
    Emissor.Free;
  end;
end;

function TNFCeService.DownloadXml(chNFe: string): TStream;
var
  Emissor: TEmissorNFCe;
begin
  TXDataOperationContext.Current.Response.Headers
    .SetValue('content-type', 'application/xml');
  Emissor := TEmissorNFCe.Create(ServerConfig);
  try
    Result := TStringStream.Create(TEncoding.UTF8.GetString(
      Emissor.DownloadXml(chNFe)
    ));
  finally
    Emissor.Free;
  end;
end;

function TNFCeService.Enviar(Nota: TNFCeDTO): TRetornoEnvioNFCeDTO;
var
  Emissor: TEmissorNFCe;
begin
  Emissor := TEmissorNFCe.Create(ServerConfig);
  try
    Result := Emissor.Enviar(Nota);
  finally
    Emissor.Free;
  end;
end;

function TNFCeService.InutilizarNumeracao(ano, serie, nIni, nFin: integer;
  xJust: string): TRetornoInutilizacaoNFCeDTO;
var
  Emissor: TEmissorNFCe;
begin
  Emissor := TEmissorNFCe.Create(ServerConfig);
  try
    Result := Emissor.InutilizarNumeracao(ano, serie, nIni, nFin, xJust);
  finally
    Emissor.Free;
  end;
end;

function TNFCeService.StatusServico: TRetornoStatusServicoDTO;
var
  Emissor: TEmissorNFCe;
begin
  Emissor := TEmissorNFCe.Create(ServerConfig);
  try
    Result := Emissor.StatusServico;
  finally
    Emissor.Free;
  end;
end;

initialization
  RegisterServiceType(TNFCeService);

end.
