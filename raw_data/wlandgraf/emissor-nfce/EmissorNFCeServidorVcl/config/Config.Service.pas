unit Config.Service;

interface

uses
  XData.Server.Module,
  XData.Service.Common,
  XData.Sys.Exceptions,

  Config.Service.Interfaces,
  Config.DTO,

  Server.Config;

type
  [ServiceImplementation]
  TConfigService = class(TInterfacedObject, IConfigService)
  public
    function Emitente: TConfigEmitenteDTO;
    function Ambiente: TConfigAmbienteDTO;
  end;

implementation

{ TConfigService }

function TConfigService.Ambiente: TConfigAmbienteDTO;
begin
  Result := TConfigAmbienteDTO.Create;
  try
    Result.Producao := ServerConfig.Producao;
  except
    Result.Free;
    raise;
  end;
end;

function TConfigService.Emitente: TConfigEmitenteDTO;
begin
  Result := TConfigEmitenteDTO.Create;
  try
    Result.CNPJ := ServerConfig.Emitente.CNPJ;
    Result.InscricaoMunicipal := ServerConfig.Emitente.InscricaoMunicipal;
    Result.InscricaoEstadual := ServerConfig.Emitente.InscricaoEstadual;
    Result.RazaoSocial := ServerConfig.Emitente.RazaoSocial;
    Result.Fantasia := ServerConfig.Emitente.Fantasia;
    Result.Fone := ServerConfig.Emitente.Fone;
    Result.CEP := ServerConfig.Emitente.CEP;
    Result.Logradouro := ServerConfig.Emitente.Logradouro;
    Result.Numero := ServerConfig.Emitente.Numero;
    Result.Complemento := ServerConfig.Emitente.Complemento;
    Result.Bairro := ServerConfig.Emitente.Bairro;
    Result.CodCidade := ServerConfig.Emitente.CodCidade;
    Result.Cidade := ServerConfig.Emitente.Cidade;
    Result.UF := ServerConfig.Emitente.UF;
  except
    Result.Free;
    raise;
  end;
end;

initialization
  RegisterServiceType(TConfigService);

end.
