unit Pessoa;

interface

uses SysUtils;

type
  TPessoa = class
  private
    FIdPessoa: LongInt;
    FFLNatureza: Int64;
    FDsDocumento : string;
    FNmPrimeiro : string;
    FNmSegundo : string;
    FDtRegistro : TDate;
    procedure SetFLNatureza(const Value: Int64);
    procedure SetDsDocumento(const Value: string);
    procedure SetNmPrimeiro(const Value: string);
    procedure SetNmSegundo(const Value: string);
  public
    constructor Create;
    procedure Salvar(const objetoPessoa: TPessoa);
    property IdPessoa: LongInt read FIdPessoa write FIdPessoa;
    property FLNatureza: Int64 read FFLNatureza write SetFLNatureza;
    property DsDocumento: string read FDsDocumento write SetDsDocumento;
    property NmPrimeiro: string read FNmPrimeiro write SetNmPrimeiro;
    property NmSegundo: string read FNmSegundo write SetNmSegundo;
    property DtRegistro: TDate read FDtRegistro write FDtRegistro;
  end;

implementation


constructor TPessoa.Create;
begin
  FIdPessoa    := 0;
  FFLNatureza  := 0;
  FDsDocumento := '';
  FNmPrimeiro  := '';
  FNmSegundo   :='';
  FDtRegistro  := 0;
end;

procedure TPessoa.Salvar(const objetoPessoa: TPessoa);
begin
  // a rotina para salvar o cliente no banco de dados deve ser escrita aqui
end;

Procedure  TPessoa.SetFLNatureza(const Value: Int64);
begin
  if Value < 1 then
    raise EArgumentException.Create('Natureza tem que ser maior que zero!')
  else
    FFLNatureza := Value;
end;

Procedure  TPessoa.SetDsDocumento(const Value: string);
begin
  if Value = EmptyStr then
    raise EArgumentException.Create('Documento tem que ser preenchido!')
  else
    FDsDocumento := Value;
end;

Procedure  TPessoa.SetNmPrimeiro(const Value: string);
begin
  if Value = EmptyStr then
    raise EArgumentException.Create('Primeiro Nome tem que ser preenchido!')
  else
    FNmPrimeiro := Value;
end;

Procedure  TPessoa.SetNmSegundo(const Value: string);
begin
  if Value = EmptyStr then
    raise EArgumentException.Create('Segundo Nome tem que ser preenchido!')
  else
    FNmSegundo := Value;
end;

end.
