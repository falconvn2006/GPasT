unit client.controller.interfaces;

interface

uses
  client.model.service.interfaces;
type
  iPessoaLista = interface;
  iPessoaDTO<T> = interface
    ['{49148AA6-4ED9-4B0F-95EB-E7EA5071BDD8}']
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

  iPessoa = interface
    ['{C0BC0A6C-FA9F-44EA-B331-A35E63237C98}']
    function Services : iServicePessoa;
    function Entity : iPessoaDTO<iPessoa>;
    function Lista : iPessoaLista;
  end;

  iPessoaLista = interface
    ['{8382F831-8086-4F63-8977-E0046F251E79}']
    function AdicionarPessoa : integer;
    function RemoverPessoa(aIndex : Integer) : iPessoaLista;
    function AtualizarPessoa(aIndex : Integer) : iPessoaLista;
    function LimparLista : iPessoaLista;
    function &End : iPessoa;
 end;

  iController = interface
    ['{71C74016-9CB6-4A51-80D0-65EC4520B076}']
    function Pessoa : iPessoa;
  end;
implementation

end.
