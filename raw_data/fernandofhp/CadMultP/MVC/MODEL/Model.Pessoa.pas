unit Model.Pessoa;

interface

type
  TPessoa = class(TObject)
  private
    FNmPrimeiro: string;
    FDtRegistro: TDate;
    FNmSegundo: string;
    FDsDocumento: string;
    FIdPessoa: Integer;
    FFlNatureza: Integer;
    procedure SetDsDocumento(const Value: string);
    procedure SetDtRegistro(const Value: TDate);
    procedure SetFlNatureza(const Value: Integer);
    procedure SetIdPessoa(const Value: Integer);
    procedure SetNmPrimeiro(const Value: string);
    procedure SetNmSegundo(const Value: string);
  public
    property IdPessoa: Integer read FIdPessoa write SetIdPessoa;
    property FlNatureza: Integer read FFlNatureza write SetFlNatureza;
    property DsDocumento: string read FDsDocumento write SetDsDocumento;
    property NmPrimeiro: string read FNmPrimeiro write SetNmPrimeiro;
    property NmSegundo: string read FNmSegundo write SetNmSegundo;
    property DtRegistro: TDate read FDtRegistro write SetDtRegistro;

    function ValidarCampos: Boolean;
  end;

implementation

{ TPessoa }

uses System.SysUtils;

procedure TPessoa.SetDsDocumento(const Value: string);
begin
  FDsDocumento := Value;
end;

procedure TPessoa.SetDtRegistro(const Value: TDate);
begin
  FDtRegistro := Value;
end;

procedure TPessoa.SetFlNatureza(const Value: Integer);
begin
  FFlNatureza := Value;
end;

procedure TPessoa.SetIdPessoa(const Value: Integer);
begin
  FIdPessoa := Value;
end;

procedure TPessoa.SetNmPrimeiro(const Value: string);
begin
  FNmPrimeiro := Value;
end;

procedure TPessoa.SetNmSegundo(const Value: string);
begin
  FNmSegundo := Value;
end;

function TPessoa.ValidarCampos: Boolean;
var
  Teste: Boolean;
begin
  // Teste := IdPessoa > 0;
  Teste := (Trim(FDsDocumento) <> EmptyStr);
  Teste := Teste and (Trim(FNmPrimeiro) <> EmptyStr);
  Teste := Teste and (Trim(FNmSegundo) <> EmptyStr);
  Teste := Teste and (FDtRegistro >= StrToDate('01/01/1900'));
  Teste := Teste and (FDtRegistro <= Now + 30);
  Result := Teste;
end;

end.
