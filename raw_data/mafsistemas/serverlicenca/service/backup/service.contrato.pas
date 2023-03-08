unit service.contrato;

{$mode Delphi}

interface

uses
  Classes, SysUtils,
  fpjson,
  ZDataset,
  DataSet.Serialize;


function ListarContratos: TJSONArray;
function BuscarContrato: TJSONArray;
function Inserir: Boolean;
function Editar: Boolean;
function Excluir: Boolean;


implementation

function ListarContratos: TJSONArray;
var
    qry: TZQuery;
begin
    try
        qry := TZQuery.Create(nil);
        qry.Connection := FConn;

        with qry do
        begin
            Active := false;
            SQL.Clear;
            SQL.Add('SELECT * FROM CONTRATO');

            if NUMERO > 0 then
            begin
                SQL.Add('WHERE NUMERO = :NUMERO');
                ParamByName('NUMERO').Value := NUMERO;
            end;

            SQL.Add('ORDER BY NUMERO');
            Active := true;
        end;

        Result := qry.ToJSONArray;

    finally
        FreeAndNil( qry );
    end;
end;


function BuscarContrato: TJSONArray;
begin

end;

function Inserir: Boolean;
begin

end;

function Editar: Boolean;
begin

end;

function Excluir: Boolean;
begin

end;

end.

