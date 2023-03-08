unit Server.Config;

interface

uses
  Generics.Collections;

type
  TEmitente = class;
  TCertificado = class;
  TNFCeConfig = class;
  TResponsavelTecnicoEmissaoDFe = class;

  TServerConfig = class
  strict private
    FProducao: Boolean;
    FBaseUrl: string;
    FJwtSecret: string;
    FEmitente: TEmitente;
    FCertificado: TCertificado;
    FNFCe: TNFCeConfig;
  public
    destructor Destroy; override;
    property Producao: Boolean read FProducao write FProducao;
    property BaseUrl: string read FBaseUrl write FBaseUrl;
    property JwtSecret: string read FJwtSecret write FJwtSecret;
    property Emitente: TEmitente read FEmitente write FEmitente;
    property Certificado: TCertificado read FCertificado write FCertificado;
    property NFCe: TNFCeConfig read FNFCe write FNFCe;
  end;

  TEmitente = class
  strict private
    FCNPJ: string;
    FInscricaoMunicipal: string;
    FInscricaoEstadual: string;
    FRazaoSocial: string;
    FFantasia: string;
    FFone: string;
    FCEP: string;
    FLogradouro: string;
    FNumero: string;
    FComplemento: string;
    FBairro: string;
    FCodCidade: integer;
    FCidade: string;
    FUF: string;
  public
    property CNPJ: string read FCNPJ write FCNPJ;
    property InscricaoMunicipal: string read FInscricaoMunicipal write FInscricaoMunicipal;
    property InscricaoEstadual: string read FInscricaoEstadual write FInscricaoEstadual;
    property RazaoSocial: string read FRazaoSocial write FRazaoSocial;
    property Fantasia: string read FFantasia write FFantasia;
    property Fone: string read FFone write FFone;
    property CEP: string read FCEP write FCEP;
    property Logradouro: string read FLogradouro write FLogradouro;
    property Numero: string read FNumero write FNumero;
    property Complemento: string read FComplemento write FComplemento;
    property Bairro: string read FBairro write FBairro;
    property CodCidade: integer read FCodCidade write FCodCidade;
    property Cidade: string read FCidade write FCidade;
    property UF: string read FUF write FUF;
  end;

  TCertificado = class
  strict private
    FArquivoPFX: string;
    FSenha: string;
    FNumeroSerie: string;
  public
    property ArquivoPFX: string read FArquivoPFX write FArquivoPFX;
    property Senha: string read FSenha write FSenha;
    property NumeroSerie: string read FNumeroSerie write FNumeroSerie;
  end;

  TNFCeConfig = class
  strict private
    FPathSchemas: string;
    FPathArquivos: string;
    FDANFEFastFile: string;
    FIdCSC: string;
    FCSC: string;
    FResponsavelTecnicoEmissao: TResponsavelTecnicoEmissaoDFe;
  public
    constructor Create;
    destructor Destroy; override;
    property PathSchemas: string read FPathSchemas write FPathSchemas;
    property PathArquivos: string read FPathArquivos write FPathArquivos;
    property DANFEFastFile: string read FDANFEFastFile write FDANFEFastFile;
    property IdCSC: string read FIdCSC write FIdCSC;
    property CSC: string read FCSC write FCSC;
    property ResponsavelTecnicoEmissao: TResponsavelTecnicoEmissaoDFe read FResponsavelTecnicoEmissao write FResponsavelTecnicoEmissao;
  end;

  TResponsavelTecnicoEmissaoDFe = class
  strict private
    FCNPJ: string;
    FContato: string;
    FEmail: string;
    FFone: string;
  public
    property CNPJ: string read FCNPJ write FCNPJ;
    property Contato: string read FContato write FContato;
    property Email: string read FEmail write FEmail;
    property Fone: string read FFone write FFone;
  end;

var
  ServerConfig: TServerConfig;

procedure LoadConfig;
procedure SaveConfig;

implementation

uses
  System.Classes, System.SysUtils, System.IOUtils,

  Bcl.Json, Bcl.Json.Attributes, Bcl.Json.Writer, Bcl.Json.Serializer;

function ConfigFileName: string;
begin
  Result := TPath.GetFileName(TPath.ChangeExtension(ParamStr(0), '.json'));
  if not TFile.Exists(Result) then
  begin
    if TFile.Exists(TPath.Combine('..\..\', Result)) then
      Result := TPath.Combine('..\..\', Result);
  end;
end;

procedure SaveConfig;
var
  FS: TFileStream;
  Writer: TJsonWriter;
  Serializer: TJsonSerializer;
begin
  TMonitor.Enter(ServerConfig);
  try
    FS := TFileStream.Create(ConfigFileName, fmCreate);
    try
      Writer := TJsonWriter.Create(FS);
      try
        Writer.IndentLength := 2;
        Serializer := TJsonSerializer.Create;
        try
          Serializer.Write(ServerConfig, Writer);
        finally
          Serializer.Free;
        end;
      finally
        Writer.Free;
      end;
    finally
      FS.Free;
    end;
  finally
    TMonitor.Exit(ServerConfig);
  end;
end;

procedure LoadConfig;
var
  FS: TFileStream;
begin
  FreeAndNil(ServerConfig);
  if TFile.Exists(ConfigFileName) then
  begin
    FS := TFileStream.Create(ConfigFileName, fmOpenRead + fmShareDenyNone);
    try
      ServerConfig := TJson.Deserialize<TServerConfig>(FS);
    finally
      FS.Free;
    end;
  end
  else
    ServerConfig := TServerConfig.Create;
end;

{ TConfig }

destructor TServerConfig.Destroy;
begin
  if Assigned(FEmitente) then
    FEmitente.Free;
  if Assigned(FCertificado) then
    FCertificado.Free;
  if Assigned(FNFCe) then
    FNFCe.Free;
  inherited;
end;

{ TNFCeConfig }

constructor TNFCeConfig.Create;
begin
  FIdCSC := '1';
end;

destructor TNFCeConfig.Destroy;
begin
  if Assigned(FResponsavelTecnicoEmissao) then
    FResponsavelTecnicoEmissao.Free;
  inherited;
end;

initialization

finalization
  ServerConfig.Free;

end.
