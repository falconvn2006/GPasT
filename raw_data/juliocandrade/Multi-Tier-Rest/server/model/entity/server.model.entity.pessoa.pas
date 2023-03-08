unit server.model.entity.pessoa;

interface
uses
  server.model.entity.endereco.integracao, server.model.entity.endereco;

type
  TModelPessoa = class
  private
    FID : int64;
    FNatureza : integer;
    FDataRegistro : TDate;
    FDocumento : String;
    FPrimeiroNome : String;
    FSegundoNome : String;
    FEndereco : TModelEndereco;
    FEnderecoIntegracao : TModelEnderecoIntegracao;
    function GetID: int64;
    procedure SetID(const Value: int64);
    function GetNatureza: integer;
    procedure SetNatureza(const Value: integer);
    function GetDataRegistro: TDate;
    function GetDocumento: string;
    function GetPrimeiroNome: string;
    function GetSegundoNome: string;
    procedure SetDataRegistro(const Value: TDate);
    procedure SetDocumento(const Value: string);
    procedure SetPrimeiroNome(const Value: string);
    procedure SetSegundoNome(const Value: string);
  public
    constructor Create;
    destructor Destroy; override;
    property ID : int64 read GetID write SetID;
    property Natureza : integer read GetNatureza write SetNatureza;
    property Documento : string read GetDocumento write SetDocumento;
    property PrimeiroNome : string read GetPrimeiroNome write SetPrimeiroNome;
    property SegundoNome : string read GetSegundoNome write SetSegundoNome;
    property DataRegistro : TDate read GetDataRegistro write SetDataRegistro;
    function EnderecoIntegracao : TModelEnderecoIntegracao;
    function Endereco : TModelEndereco;
  end;
implementation
uses
  System.SysUtils, server.model.exceptions;

{ TModelPessoa }

constructor TModelPessoa.Create;
begin
  FEnderecoIntegracao := TModelEnderecoIntegracao.Create;
  FEndereco := TModelEndereco.Create;
end;

destructor TModelPessoa.Destroy;
begin
  FEndereco.Free;
  FEnderecoIntegracao.Free;
  inherited;
end;

function TModelPessoa.Endereco: TModelEndereco;
begin
  Result := FEndereco;
end;

function TModelPessoa.EnderecoIntegracao: TModelEnderecoIntegracao;
begin
  Result := FEnderecoIntegracao;
end;

function TModelPessoa.GetDataRegistro: TDate;
begin
  Result := FDataRegistro;
end;

function TModelPessoa.GetDocumento: string;
begin
  if FDocumento.isEmpty then
    raise ECampoInvalido.Create('Documento não informado');
  Result := FDocumento;
end;

function TModelPessoa.GetID: int64;
begin
  Result := FID;
end;

function TModelPessoa.GetNatureza: integer;
begin
  if FNatureza = 0 then
    raise ECampoInvalido.Create('Natureza não informada');
  Result := FNatureza;
end;

function TModelPessoa.GetPrimeiroNome: string;
begin
  if FPrimeiroNome.isEmpty then
    raise ECampoInvalido.Create('Primeiro nome não informado');
  Result := FPrimeiroNome;
end;

function TModelPessoa.GetSegundoNome: string;
begin
  if FSegundoNome.isEmpty then
    raise ECampoInvalido.Create('Segundo nome não informado');
  Result := FSegundoNome;
end;

procedure TModelPessoa.SetDataRegistro(const Value: TDate);
begin
  FDataRegistro := Value;
end;

procedure TModelPessoa.SetDocumento(const Value: string);
begin
  FDocumento := Value;
end;

procedure TModelPessoa.SetID(const Value: int64);
begin
  FID := Value;
end;

procedure TModelPessoa.SetNatureza(const Value: integer);
begin
  FNatureza := Value;
end;

procedure TModelPessoa.SetPrimeiroNome(const Value: string);
begin
  FPrimeiroNome := Value;
end;

procedure TModelPessoa.SetSegundoNome(const Value: string);
begin
  FSegundoNome := Value;
end;

end.

