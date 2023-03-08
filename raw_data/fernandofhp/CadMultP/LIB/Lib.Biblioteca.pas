unit Lib.Biblioteca;

interface

uses System.SysUtils;

type
  TOperacao = (opVer, opIncluir, opAlterar);
function SimplificarCEP(CEP: string): string;
function ValidarCEP(CEP: string): Boolean;

implementation

function SimplificarCEP(CEP: string): string;
var
  Aux: string;
begin
  Aux := StringReplace(CEP, '.', '', [rfReplaceAll]);
  Aux := StringReplace(Aux, '-', '', [rfReplaceAll]);
  Result := Aux;
end;

function ValidarCEP(CEP: string): Boolean;
var
  Valido: Boolean;
  NovoCEP: Integer;
begin
  Valido := True;
  try
    NovoCEP := StrToInt(CEP);
  except
    on Exception do
      Valido := False;
  end;
  Result := Valido;
end;

end.
