unit dao.contrato;

{$mode Delphi}

interface

uses
  Classes, SysUtils,
  DataSet.Serialize,
  StrUtils,
  DateUtils,
  fpjson,
  ZConnection,
  ZDataset;

type

   { TContrato }

   TContrato = class
   private
      FConn: TZConnection;
      FNumero: Integer;
      FCodCli: Integer;
      FDataInicio: TDateTime;
      FDiaPgto: SmallInt;
      FSituacao: String;
      FEncerramento: TDateTime;
      FValor: Currency;
      FBoleto: String;
      FData_Validade: TDateTime;
      FUlt_Atualizacao: TDateTime;
      FSerial: String;
      FChave: String;


   public
      constructor Create(conn: TZConnection);

      property NUMERO: integer read FNUMERO write FNUMERO;
      property CODCLI: integer read FCODCLI write FCODCLI;
      property DATAINICIO: TDateTime read FDATAINICIO write FDATAINICIO;
      property DIAPGTO: smallint read FDIAPGTO write FDIAPGTO;
      property SITUACAO: string read FSITUACAO write FSITUACAO;
      property ENCERRAMENTO: TDateTime read FENCERRAMENTO write FENCERRAMENTO;
      property VALOR: currency read FVALOR write FVALOR;
      property BOLETO: string read FBOLETO write FBOLETO;
      property DATA_VALIDADE: TDateTime read FDATA_VALIDADE write FDATA_VALIDADE;
      property ULT_ATUALIZACAO: TDateTime read FULT_ATUALIZACAO write FULT_ATUALIZACAO;
      property SERIAL: string read FSERIAL write FSERIAL;
      property CHAVE: string read FCHAVE write FCHAVE;


      function ListarContratos: TJSONArray;
      function BuscarContrato: TJSONArray;
      procedure Inserir;
      procedure Editar;
      procedure Excluir;

   end;

implementation

constructor TContrato.Create(conn: TZConnection);
begin
  FConn := conn;
end;

function TContrato.ListarContratos: TJSONArray;
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

function TContrato.BuscarContrato: TJSONArray;
begin

end;

procedure TContrato.Inserir;
begin

end;

procedure TContrato.Editar;
begin

end;

procedure TContrato.Excluir;
begin

end;

end.

