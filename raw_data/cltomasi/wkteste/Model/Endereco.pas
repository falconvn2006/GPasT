unit Endereco;

interface

uses SysUtils;

type
  TEndereco = class
  private
    FIdEndereco: LongInt;
    FIdPessoa : LongInt;
    FDsCep: string;
    procedure SetDsCep(const Value: string);
  public
    property IdEndereco: LongInt read FIdEndereco write FIdEndereco;
    property IdPessoa: LongInt read FIdPessoa write FIdPessoa;
    property DsCep: string read FDsCep write SetDsCep;
  end;

implementation


Procedure  TEndereco.SetDsCep(const Value: string);
begin
  if Value = EmptyStr then
    raise EArgumentException.Create('CEP tem que ser preenchido!')
  else
    FDsCep := Value;
end;


end.
