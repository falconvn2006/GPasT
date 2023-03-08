unit DTO.Caixa;

interface

uses
  DTO.Usuario;

type
  TCaixa = class
  private
    FID: Integer;
    FTITULO: String;
    FVALOR: Currency;
    FDESCRICAO: String;
    FDTENTRADA: TDateTime;
    FDTATUALIZACAO: TDateTime;
    FENTRADA: Boolean;
    FUSUARIO: TUsuario;
  public
    function ID: Integer; overload;
    function ID(aValue: Integer): TCaixa; overload;
    function TITULO: String; overload;
    function TITULO(aValue: String): TCaixa; overload;
    function VALOR: Currency; overload;
    function VALOR(aValue: Currency): TCaixa; overload;
    function DESCRICAO: String; overload;
    function DESCRICAO(aValue: String): TCaixa; overload;
    function DTENTRADA: TDateTime; overload;
    function DTENTRADA(aValue: TDateTime): TCaixa; overload;
    function DTATUALIZACAO: TDateTime; overload;
    function DTATUALIZACAO(aValue: TDateTime): TCaixa; overload;
    function ENTRADA: Boolean; overload;
    function ENTRADA(aValue: Boolean): TCaixa; overload;
    function Usuario: TUsuario; overload;
    function Usuario(aValue: TUsuario): TCaixa; overload;
  end;

implementation

{ TCaixa }

function TCaixa.DESCRICAO(aValue: String): TCaixa;
begin
  Result := Self;
  FDESCRICAO := aValue;
end;

function TCaixa.DESCRICAO: String;
begin
  Result := FDESCRICAO;
end;

function TCaixa.DTATUALIZACAO: TDateTime;
begin
  Result := FDTATUALIZACAO;
end;

function TCaixa.DTATUALIZACAO(aValue: TDateTime): TCaixa;
begin
  Result := Self;
  FDTATUALIZACAO := aValue;
end;

function TCaixa.DTENTRADA: TDateTime;
begin
  Result := FDTENTRADA;
end;

function TCaixa.DTENTRADA(aValue: TDateTime): TCaixa;
begin
  Result := Self;
  FDTENTRADA := aValue;
end;

function TCaixa.ENTRADA(aValue: Boolean): TCaixa;
begin
  Result := Self;
  FENTRADA := aValue;
end;

function TCaixa.ENTRADA: Boolean;
begin
  Result := FENTRADA;
end;

function TCaixa.ID: Integer;
begin
  Result := FID;
end;

function TCaixa.ID(aValue: Integer): TCaixa;
begin
  Result := Self;
  FID := aValue;
end;

function TCaixa.Usuario(aValue: TUsuario): TCaixa;
begin
  Result := Self;
  FUSUARIO := aValue;
end;

function TCaixa.Usuario: TUsuario;
begin
  Result := FUSUARIO;
end;

function TCaixa.TITULO: String;
begin
  Result := FTITULO;
end;

function TCaixa.TITULO(aValue: String): TCaixa;
begin
  Result := Self;
  // TVarType(aValue);
  // TVarData(aValue);
  FTITULO := aValue;
end;

function TCaixa.VALOR(aValue: Currency): TCaixa;
begin
  Result := Self;
  FVALOR := aValue;
end;

function TCaixa.VALOR: Currency;
begin
  Result := FVALOR;
end;

end.
