unit server.model.entity.endereco;

interface
type
  TModelEndereco = class
  private
    FIDEndereco : int64;
    FIDPessoa : int64;
    FCEP : string;

    function GetCEP: string;
    function GetIDEndereco: int64;
    function GetIdPessoa: int64;
    procedure SetCEP(const Value: string);
    procedure SetIDEndereco(const Value: int64);
    procedure SetIDPessoa(const Value: int64);
  public
    property IDEndereco : int64 read GetIDEndereco write SetIDEndereco;
    property IDPessoa : int64 read GetIdPessoa write SetIDPessoa;
    property CEP : string read GetCEP write SetCEP;
  end;
implementation
uses
  System.SysUtils, server.model.exceptions, server.utils;

{ TModelEndereco }

function TModelEndereco.GetCEP: string;
begin
  if FCEP.isEmpty then
    raise ECampoInvalido.Create('CEP não informado');
  Result := TServerUtils.ApenasNumeros(FCEP);
end;

function TModelEndereco.GetIDEndereco: int64;
begin
  Result := FIDEndereco;
end;

function TModelEndereco.GetIdPessoa: int64;
begin
  Result := FIDPessoa;
end;

procedure TModelEndereco.SetCEP(const Value: string);
begin
  FCEP := Value;
end;

procedure TModelEndereco.SetIDEndereco(const Value: int64);
begin
  FIDEndereco := Value;
end;

procedure TModelEndereco.SetIDPessoa(const Value: int64);
begin
  FIDPessoa := Value;
end;

end.
