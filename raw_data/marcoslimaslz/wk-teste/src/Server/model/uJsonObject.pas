unit uJsonObject;

interface

uses
  System.Generics.Collections, FireDAC.Comp.Client, SysUtils;

type
  TDTOJsonObject = class;
  TDTOJsonObject = class(TObject)
  private
    FLogradouro: System.String;
    FIbge: System.String;
    FBairro: System.String;
    FDdd: System.String;
    FUf: System.String;
    FCep: System.String;
    FSiafi: System.String;
    FLocalidade: System.String;
    FGia: System.String;
    FComplemento: System.String;
    procedure InternalClear();
    procedure SetBairro(const Value: System.String);
    procedure SetCep(const Value: System.String);
    procedure SetComplemento(const Value: System.String);
    procedure SetDdd(const Value: System.String);
    procedure SetGia(const Value: System.String);
    procedure SetIbge(const Value: System.String);
    procedure SetLocalidade(const Value: System.String);
    procedure SetLogradouro(const Value: System.String);
    procedure SetSiafi(const Value: System.String);
    procedure SetUf(const Value: System.String);
  public
    constructor Create();
    procedure Clear; inline;
    property cep: System.String read FCep write SetCep;
    property logradouro: System.String read FLogradouro write SetLogradouro;
    property complemento: System.String read FComplemento write SetComplemento;
    property bairro: System.String read FBairro write SetBairro;
    property localidade: System.String  read FLocalidade write SetLocalidade;
    property uf: System.String  read FUf write SetUf;
    property ibge: System.String  read FIbge write SetIbge;
    property gia: System.String  read FGia write SetGia;
    property ddd: System.String  read FDdd write SetDdd;
    property siafi: System.String  read FSiafi write SetSiafi;
  end;

implementation

{ TDtoJsonIntegracaoObject }

procedure TDTOJsonObject.Clear;
begin
  Self.InternalClear();
end;

constructor TDTOJsonObject.Create();
begin
  Self.InternalClear();
end;


procedure TDTOJsonObject.InternalClear;
begin
  FLogradouro := EmptyStr;
  FIbge := EmptyStr;
  FBairro := EmptyStr;
  FDdd := EmptyStr;
  FUf := EmptyStr;
  FCep := EmptyStr;
  FSiafi := EmptyStr;
  FLocalidade := EmptyStr;
  FComplemento := EmptyStr;
  FGia := EmptyStr;
end;

procedure TDTOJsonObject.SetBairro(const Value: System.String);
begin
  FBairro := Value;
end;

procedure TDTOJsonObject.SetCep(const Value: System.String);
begin
  FCep := Value;
end;

procedure TDTOJsonObject.SetComplemento(const Value: System.String);
begin
  FComplemento := Value;
end;

procedure TDTOJsonObject.SetDdd(const Value: System.String);
begin
  FDdd := Value;
end;

procedure TDTOJsonObject.SetGia(const Value: System.String);
begin
  FGia := Value;
end;

procedure TDTOJsonObject.SetIbge(const Value: System.String);
begin
  FIbge := Value;
end;

procedure TDTOJsonObject.SetLocalidade(const Value: System.String);
begin
  FLocalidade := Value;
end;

procedure TDTOJsonObject.SetLogradouro(const Value: System.String);
begin
  FLogradouro := Value;
end;

procedure TDTOJsonObject.SetSiafi(const Value: System.String);
begin
  FSiafi := Value;
end;

procedure TDTOJsonObject.SetUf(const Value: System.String);
begin
  FUf := Value;
end;

end.
