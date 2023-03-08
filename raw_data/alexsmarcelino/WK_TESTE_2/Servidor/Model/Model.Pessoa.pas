unit Model.Pessoa;

interface

uses
  Pkg.Json.DTO, System.Generics.Collections, REST.Json.Types;

{$M+}

type
  TPessoa = class
  private
    FIdpessoa: Integer;
    FPrimeironome: String;
    FSegundonome: String;
    FNatureza: Double;
    FDocumento: String;
    FCep: String;
    FLogradouro: String;
    FCidade: String;
    FUf: String;
    FBairro: String;
    FComplemento: String;
  published
    property Idpessoa: Integer read FIdpessoa write FIdpessoa;
    property Primeironome: String read FPrimeironome write FPrimeironome;
    property Segundonome: String read FSegundonome write FSegundonome;
    property Natureza: Double read FNatureza write FNatureza;
    property Documento: String read FDocumento write FDocumento;
    property Cep: String read FCep write FCep;
    property Logradouro: String read FLogradouro write FLogradouro;
    property Cidade: String read FCidade write FCidade;
    property Uf: String read FUf write FUf;
    property Bairro: String read FBairro write FBairro;
    property Complemento: String read FComplemento write FComplemento;
  end;

  TPessoas = class(TJsonDTO)
  private
    [JSONName('Items'), JSONMarshalled(False)]
    FItemsArray: TArray<TPessoa>;
    [GenericListReflect]
    FItems: TObjectList<TPessoa>;
    function GetItems: TObjectList<TPessoa>;
  protected
    function GetAsJson: string; override;
  published
    property Items: TObjectList<TPessoa> read GetItems;
  public
    destructor Destroy; override;
  end;

implementation

{ TRoot }

destructor TPessoas.Destroy;
begin
  GetItems.Free;
  inherited;
end;

function TPessoas.GetItems: TObjectList<TPessoa>;
begin
  Result := ObjectList<TPessoa>(FItems, FItemsArray);
end;

function TPessoas.GetAsJson: string;
begin
  RefreshArray<TPessoa>(FItems, FItemsArray);
  Result := inherited;
end;

end.
