unit udtoEndereco;

interface

uses
  System.Generics.Collections, FireDAC.Comp.Client, SysUtils;

type
  TDTOEndereco = class;
  TDTOListaEnderecos = class;
  TDTOEndereco = class(TObject)
  private
    Fidendereco: System.Integer;
    Fidpessoa: System.Integer;
    Fdscep: System.String;
    { private declarations }
    procedure InternalClear();
    procedure Setdscep(const Value: System.String);
    procedure Setidendereco(const Value: System.Integer);
    procedure Setidpessoa(const Value: System.Integer);
  public
    constructor Create();
    procedure Clear; inline;
    property idendereco: System.Integer read Fidendereco write Setidendereco;
    property idpessoa: System.Integer read Fidpessoa write Setidpessoa;
    property dscep: System.String read Fdscep write Setdscep;
  end;
  TDTOListaEnderecos = class(TObjectList<TDTOEndereco>)
  end;

implementation

{ TDtoEndereco }

procedure TDtoEndereco.Clear;
begin
  Self.InternalClear();
end;

constructor TDtoEndereco.Create();
begin
  Self.InternalClear();
end;

procedure TDtoEndereco.InternalClear;
begin
  Fidendereco := 0;
  Fidpessoa := 0;
  Fdscep := EmptyStr;
end;

procedure TDtoEndereco.Setdscep(const Value: System.String);
begin
  Fdscep := Value;
end;

procedure TDtoEndereco.Setidendereco(const Value: System.Integer);
begin
  Fidendereco := Value;
end;

procedure TDtoEndereco.Setidpessoa(const Value: System.Integer);
begin
  Fidpessoa := Value;
end;

end.
