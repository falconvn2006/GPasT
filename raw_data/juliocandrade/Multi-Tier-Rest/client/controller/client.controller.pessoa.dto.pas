unit client.controller.pessoa.dto;

interface

uses
  client.model.entity.pessoa,
  client.controller.interfaces;
type
  TPessoaDTO<T: IInterface> = class(TInterfacedObject, iPessoaDTO<T>)
  private
    [weak]
    FParent : T;
    FEntity : TModelPessoa;
  public
    constructor Create(aParent : T; aEntity : TModelPessoa);
    class function New(aParent : T; aEntity : TModelPessoa) : iPessoaDTO<T>;
    function ID(aValue: int64) : iPessoaDTO<T>; overload;
    function ID(aValue: String) : iPessoaDTO<T>; overload;
    function ID : int64; overload;
    function Natureza(aValue: integer) : iPessoaDTO<T>; overload;
    function Natureza(aValue: String) : iPessoaDTO<T>; overload;
    function Natureza : integer; overload;
    function DataRegistro(aValue: TDate) : iPessoaDTO<T>; overload;
    function DataRegistro : TDate; overload;
    function Documento(aValue: string) : iPessoaDTO<T>; overload;
    function Documento : string; overload;
    function PrimeiroNome(aValue: string) : iPessoaDTO<T>; overload;
    function PrimeiroNome : string; overload;
    function SegundoNome(aValue: string) : iPessoaDTO<T>; overload;
    function SegundoNome : string; overload;
    function CEP(aValue: string) : iPessoaDTO<T>; overload;
    function CEP : string; overload;
    function Bairro(aValue: String) : iPessoaDTO<T>; overload;
    function Bairro : String; overload;
    function Cidade(aValue: string) : iPessoaDTO<T>; overload;
    function Cidade : string; overload;
    function Complemento(aValue: String) : iPessoaDTO<T>; overload;
    function Complemento : String; overload;
    function Logradouro(aValue: String) : iPessoaDTO<T>; overload;
    function Logradouro : String; overload;
    function UF(aValue: String) : iPessoaDTO<T>; overload;
    function UF : String; overload;
    function &End : T;

  end;
implementation

uses
  System.SysUtils;

{ TPessoaDTO<T> }

function TPessoaDTO<T>.&End: T;
begin
  Result := FParent;
end;

function TPessoaDTO<T>.Bairro: String;
begin
  Result := FEntity.EnderecoIntegracao.Bairro;
end;

function TPessoaDTO<T>.Bairro(aValue: String): iPessoaDTO<T>;
begin
  Result := Self;
  FEntity.EnderecoIntegracao.Bairro := aValue;
end;

function TPessoaDTO<T>.CEP: string;
begin
  Result := FEntity.Endereco.CEP;
end;

function TPessoaDTO<T>.CEP(aValue: string): iPessoaDTO<T>;
begin
  Result := Self;
  FEntity.Endereco.CEP := aValue;
end;

function TPessoaDTO<T>.Cidade: string;
begin
  Result := FEntity.EnderecoIntegracao.Cidade;
end;

function TPessoaDTO<T>.Cidade(aValue: string): iPessoaDTO<T>;
begin
  Result := Self;
  FEntity.EnderecoIntegracao.Cidade := aValue;
end;

function TPessoaDTO<T>.Complemento: String;
begin
  Result := FEntity.EnderecoIntegracao.Complemento;
end;

function TPessoaDTO<T>.Complemento(aValue: String): iPessoaDTO<T>;
begin
  Result := Self;
  FEntity.EnderecoIntegracao.Complemento := aValue;
end;

constructor TPessoaDTO<T>.Create(aParent : T; aEntity : TModelPessoa);
begin
  FEntity := aEntity;
  FParent := aParent;
end;

function TPessoaDTO<T>.DataRegistro: TDate;
begin
  Result := FEntity.DataRegistro;
end;

function TPessoaDTO<T>.DataRegistro(aValue: TDate): iPessoaDTO<T>;
begin
  Result := Self;
  FEntity.DataRegistro := aValue;
end;

function TPessoaDTO<T>.Documento: string;
begin
  Result := FEntity.Documento;
end;

function TPessoaDTO<T>.ID(aValue: String): iPessoaDTO<T>;
begin
  Result := Self;
  try
    FEntity.ID := StrToInt64(aValue);
  except
    raise Exception.Create('ID Inválido');
  end;
end;

function TPessoaDTO<T>.Documento(aValue: string): iPessoaDTO<T>;
begin
  Result := Self;
  FEntity.Documento := aValue;
end;

function TPessoaDTO<T>.ID(aValue: int64): iPessoaDTO<T>;
begin
  Result := Self;
  FEntity.ID := aValue;
end;

function TPessoaDTO<T>.ID: int64;
begin
  Result := FEntity.ID;
end;

function TPessoaDTO<T>.Logradouro: String;
begin
  Result := FEntity.EnderecoIntegracao.Logradouro;
end;

function TPessoaDTO<T>.Logradouro(aValue: String): iPessoaDTO<T>;
begin
  Result := Self;
  FEntity.EnderecoIntegracao.Logradouro := aValue;
end;

function TPessoaDTO<T>.Natureza(aValue: integer): iPessoaDTO<T>;
begin
  Result := Self;
  FEntity.Natureza := aValue;
end;

function TPessoaDTO<T>.Natureza: integer;
begin
  Result := FEntity.Natureza
end;

function TPessoaDTO<T>.Natureza(aValue: String): iPessoaDTO<T>;
begin
  Result := Self;
  try
    FEntity.Natureza := StrToInt64(aValue);
  except
    raise Exception.Create('Natureza Inválida');
  end;
end;

class function TPessoaDTO<T>.New(aParent : T; aEntity : TModelPessoa): iPessoaDTO<T>;
begin
  Result := Self.Create(aParent, aEntity);
end;

function TPessoaDTO<T>.PrimeiroNome: string;
begin
  Result := FEntity.PrimeiroNome;
end;

function TPessoaDTO<T>.PrimeiroNome(aValue: string): iPessoaDTO<T>;
begin
  Result := Self;
  FEntity.PrimeiroNome := aValue;
end;

function TPessoaDTO<T>.SegundoNome: string;
begin
  Result := FEntity.SegundoNome;
end;

function TPessoaDTO<T>.SegundoNome(aValue: string): iPessoaDTO<T>;
begin
  Result := Self;
  FEntity.SegundoNome := aValue;
end;

function TPessoaDTO<T>.UF: String;
begin
  Result := FEntity.EnderecoIntegracao.UF;
end;

function TPessoaDTO<T>.UF(aValue: String): iPessoaDTO<T>;
begin
  Result := Self;
  FEntity.EnderecoIntegracao.UF := aValue;
end;
end.
