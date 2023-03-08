unit Model.Endereco;

interface

uses System.SysUtils;

type
  TEndereco = class(TObject)
  private
    FIdEndereco: Integer;
    FDsCEP: string;
    FIdPessoa: Integer;
    procedure SetDsCEP(const Value: string);
    procedure SetIdEndereco(const Value: Integer);
    procedure SetIdPessoa(const Value: Integer);

  public
    property IdEndereco: Integer read FIdEndereco write SetIdEndereco;
    property IdPessoa: Integer read FIdPessoa write SetIdPessoa;
    property DsCEP: string read FDsCEP write SetDsCEP;
    function ValidarCampos: Boolean;
  end;

implementation

{ TEndereco }

procedure TEndereco.SetDsCEP(const Value: string);
begin
  FDsCEP := Value;
end;

procedure TEndereco.SetIdEndereco(const Value: Integer);
begin
  FIdEndereco := Value;
end;

procedure TEndereco.SetIdPessoa(const Value: Integer);
begin
  FIdPessoa := Value;
end;

function TEndereco.ValidarCampos: Boolean;
var
  Teste: Boolean;
begin
  Teste := True;
  // Teste := Teste and (FIdEndereco > -1);
  // Teste := Teste and (FIdPessoa > -1);
  // Teste := (FDsCEP <> EmptyStr);
  Result := Teste;
end;

end.
