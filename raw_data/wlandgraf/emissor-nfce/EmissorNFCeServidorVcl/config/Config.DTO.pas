unit Config.DTO;

interface

type
  TConfigEmitenteDTO = class
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

  TConfigAmbienteDTO = class
  public
    Producao: Boolean;
  end;

implementation

end.
