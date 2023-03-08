unit contrato.service;

{$mode Delphi}

interface

uses
  Classes, SysUtils,
  udm,
  fpjson,
  ZDataset,
  DataSet.Serialize;

type

    { TProdutoService }

    { TContratoService }

    TContratoService = class
    public
      function ListarContratos: TJSONArray;
      function GetChaveContrato(cnpj : string): TJSONArray;
      function GetBoletosContrato(cnpj : string): TJSONArray;
      function GetMensagensContrato(cnpj : string): TJSONArray;
      function BaixaBoletoContrato(sequencia: string): string;
      function RegistarLogs(CodCli, Funcao, Datapc, Versao: string) : string;

      function Inserir: Boolean;
      function Editar: Boolean;
      function Excluir: Boolean;
    end;


implementation

{ TProdutoService }

function TContratoService.ListarContratos: TJSONArray;
var
  qry: TZQuery;
  DM : TDM;
begin
  try
    DM := TDM.Create(nil);
    qry := TZQuery.Create(nil);
    qry.Connection := DM.Conexao;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('SELECT * FROM CONTRATO');
      SQL.Add('ORDER BY NUMERO');
      Active := true;
    end;

    Result := qry.ToJSONArray;

  finally
     FreeAndNil( qry );
     FreeAndNil( DM );
  end;
end;

function TContratoService.GetChaveContrato(cnpj : string): TJSONArray;
var
  qry: TZQuery;
  DM : TDM;
begin
  try
      DM := TDM.Create(nil);
      qry := TZQuery.Create(nil);
      qry.Connection := DM.Conexao;
      with qry do
      begin
        Active := false;
        SQL.Clear;
        SQL.Add('SELECT CT.CODCLI, CT.CHAVE FROM CONTRATO CT LEFT OUTER JOIN CLIENTE C ON C.CODIGO = CT.CODCLI');
        SQL.Add('WHERE (C.CNPJ_CPF = :CNPJ)');
        ParamByName('CNPJ').AsString := dm.FormataCNPJ(cnpj);
        Active := true;
      end;
      Result := qry.ToJSONArray;

    finally
       FreeAndNil( qry );
       FreeAndNil( DM );
    end;
end;

function TContratoService.GetBoletosContrato(cnpj : string): TJSONArray;
var
  qry: TZQuery;
  DM : TDM;
begin
  try
      DM := TDM.Create(nil);
      qry := TZQuery.Create(nil);
      qry.Connection := DM.Conexao;
      with qry do
      begin
        Active := false;
        SQL.Clear;
        SQL.Add('SELECT A.SEQUENCIA, A.ARQUIVO FROM ARQUIVO A');
        SQL.Add('LEFT OUTER JOIN CLIENTE C ON C.CODIGO = A.CODCLI');
        SQL.Add('WHERE (C.CNPJ_CPF = :CNPJ) AND (A.DATAIMPRESSAO IS NULL)');
        ParamByName('CNPJ').AsString := dm.FormataCNPJ(cnpj);
        Active := true;
      end;

      Result := qry.ToJSONArray;

    finally
       FreeAndNil( qry );
       FreeAndNil( DM );
    end;
end;

function TContratoService.GetMensagensContrato(cnpj: string): TJSONArray;
var
  qry: TZQuery;
  DM : TDM;
begin
  try
      DM := TDM.Create(nil);
      qry := TZQuery.Create(nil);
      qry.Connection := DM.Conexao;
      with qry do
      begin
        Active := false;
        SQL.Clear;
        SQL.Add('SELECT M.MENSAGEM FROM MENSAGEM M');
        SQL.Add('LEFT OUTER JOIN CLIENTE C ON C.CODIGO = M.CODCLI');
        SQL.Add('WHERE (C.CNPJ_CPF = :CNPJ) AND (M.INATIVA IS NULL)');
        ParamByName('CNPJ').AsString := dm.FormataCNPJ(cnpj);
        Active := true;
      end;
      Result :=  qry.ToJSONArray();
    finally
       FreeAndNil( qry );
       FreeAndNil( DM );
    end;
end;

function TContratoService.BaixaBoletoContrato(sequencia: string): string;
var
  qry: TZQuery;
  DM : TDM;
begin
  try
      DM := TDM.Create(nil);
      qry := TZQuery.Create(nil);
      qry.Connection := DM.Conexao;
      with qry do
      begin
        Active := false;
        SQL.Clear;
        SQL.Add('UPDATE ARQUIVO SET DATAIMPRESSAO = :DATA WHERE SEQUENCIA = :SEQ');
        ParamByName('SEQ').AsString := Trim(sequencia);
        ParamByName('DATA').AsString := FormatDateTime('dd/mm/yyyy hh:mm:ss', Now);
        ExecSQL;
      end;

      Result := 'Ok';

    finally
       FreeAndNil( qry );
       FreeAndNil( DM );
    end;

end;

function TContratoService.RegistarLogs(CodCli, Funcao, Datapc, Versao: string): string;
var
  qry: TZQuery;
  DM : TDM;
begin
  try
      DM := TDM.Create(nil);
      qry := TZQuery.Create(nil);
      qry.Connection := DM.Conexao;
      with qry do
      begin
        Active := false;
        SQL.Clear;
        SQL.Add('INSERT INTO LOGS(CODCLI, FUNCAO, DATAPC, VERSAO)');
        SQL.Add('VALUES (:CODCLI, :FUNCAO, :DATAPC, :VERSAO)');
        ParamByName('CODCLI').AsString := CodCli;
        ParamByName('FUNCAO').AsString := Funcao;
        ParamByName('DATAPC').AsString := DATAPC;
        ParamByName('VERSAO').AsString := Versao;
        ExecSQL();
      end;
      Result := 'Ok';
    finally
       FreeAndNil( qry );
       FreeAndNil( DM );
    end;
end;

function TContratoService.Inserir: Boolean;
begin

end;

function TContratoService.Editar: Boolean;
begin

end;

function TContratoService.Excluir: Boolean;
begin

end;

end.

