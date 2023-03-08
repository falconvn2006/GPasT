unit DTO.Usuario;

interface

type
  TUsuario = class
  private
    FID: Integer;
    FNOME: String;
    FSENHA: String;
    FADMIN: Boolean;
  public
    function ID: Integer; overload;
    function ID(aValue: Integer): TUsuario; overload;
    function NOME: String; overload;
    function NOME(aValue: String): TUsuario; overload;
    function SENHA: String; overload;
    function SENHA(aValue: String): TUsuario; overload;
    function ADMIN: Boolean; overload;
    function ADMIN(aValue: Integer): TUsuario; overload;
  end;

implementation

{ TUsuario }

function TUsuario.ADMIN: Boolean;
begin
  Result := FADMIN;
end;

function TUsuario.ADMIN(aValue: Integer): TUsuario;
begin
  Result := Self;
  FADMIN := False;
  if aValue > 0 then
    FADMIN := True;
end;

function TUsuario.ID: Integer;
begin
  Result := FID;
end;

function TUsuario.ID(aValue: Integer): TUsuario;
begin
  Result := Self;
  FID := aValue;
end;

function TUsuario.NOME(aValue: String): TUsuario;
begin
  Result := Self;
  FNOME := aValue;
end;

function TUsuario.NOME: String;
begin
  Result := FNOME;
end;

function TUsuario.SENHA: String;
begin
  Result := FSENHA;
end;

function TUsuario.SENHA(aValue: String): TUsuario;
begin
  Result := Self;
  FSENHA := aValue;
end;

end.
