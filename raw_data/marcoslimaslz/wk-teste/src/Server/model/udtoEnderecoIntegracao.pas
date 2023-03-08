unit udtoEnderecoIntegracao;

interface

uses
  System.Generics.Collections, FireDAC.Comp.Client, SysUtils;

type
  TDtoEnderecoIntegracao = class;
  TDtoEnderecoIntegracoes = class;
  TDtoEnderecoIntegracao = class(TObject)
  private
    Fnmcidade: System.String;
    Fnmlogradouro: System.String;
    Fidendereco: System.Integer;
    Fnmbairro: System.String;
    Fdsuf: System.String;
    Fdscomplemento: System.String;
    procedure InternalClear();
    procedure Setdscomplemento(const Value: String);
    procedure Setdsuf(const Value: String);
    procedure Setidendereco(const Value: System.Integer);
    procedure Setnmbairro(const Value: System.String);
    procedure Setnmcidade(const Value: System.String);
    procedure Setnmlogradouro(const Value: System.String);
  public
    constructor Create();
    procedure Clear; inline;
    property idendereco: System.Integer read Fidendereco write Setidendereco;
    property dsuf: System.String read Fdsuf write Setdsuf;
    property nmcidade: System.String read Fnmcidade write Setnmcidade;
    property nmbairro: System.String read Fnmbairro write Setnmbairro;
    property nmlogradouro: System.String  read Fnmlogradouro write Setnmlogradouro;
    property dscomplemento: System.String  read Fdscomplemento write Setdscomplemento;
  end;
  TDtoEnderecoIntegracoes = class(TObjectList<TDtoEnderecoIntegracao>)
  end;

implementation

{ TDtoEnderecoIntegracao }

procedure TDtoEnderecoIntegracao.Clear;
begin
  Self.InternalClear();
end;

constructor TDtoEnderecoIntegracao.Create();
begin
  Self.InternalClear();
end;

procedure TDtoEnderecoIntegracao.InternalClear;
begin
  Fnmcidade := EmptyStr;
  Fnmlogradouro := EmptyStr;
  Fidendereco := 0;
  Fnmbairro := EmptyStr;
  Fdsuf := EmptyStr;
  Fdscomplemento :=  EmptyStr;
end;

procedure TDtoEnderecoIntegracao.Setdscomplemento(const Value: System.String);
begin
  Fdscomplemento := Value;
end;

procedure TDtoEnderecoIntegracao.Setdsuf(const Value: System.String);
begin
  Fdsuf := Value;
end;

procedure TDtoEnderecoIntegracao.Setidendereco(const Value: System.Integer);
begin
  Fidendereco := Value;
end;

procedure TDtoEnderecoIntegracao.Setnmbairro(const Value: System.String);
begin
  Fnmbairro := Value;
end;

procedure TDtoEnderecoIntegracao.Setnmcidade(const Value: System.String);
begin
  Fnmcidade := Value;
end;

procedure TDtoEnderecoIntegracao.Setnmlogradouro(const Value: System.String);
begin
  Fnmlogradouro := Value;
end;

end.
