unit Modelo.Endereco;

interface

uses FireDAC.Comp.Client, Data.DB, System.SysUtils, Model.Banco, Model.Pessoa,
  System.Classes, uTThreadEndereco, RESTRequest4D, System.JSON;

type
  TEnderecoIntegracao = class
  private
    function  getCamposJsonString(json, value: String): String;
    procedure InsereEndereco(objEndereco : TEndereco);
  public
    dmBanco : TdmBanco;
    constructor Create;
    destructor Destroy; override;

    function  AtualizaEndereco(): boolean;
  end;
implementation

{ TEnderecoIntegracao }

constructor TEnderecoIntegracao.Create;
begin
  dmBanco := TdmBanco.Create(nil);
  dmBanco.Banco.Connected := True;
end;

destructor TEnderecoIntegracao.Destroy;
begin
  dmBanco.Banco.Connected := False;
end;

function TEnderecoIntegracao.getCamposJsonString(json, value: String): String;
var
  LJSONObject: TJSONObject;
  function TrataObjeto(jObj:TJSONObject):string;
  var i:integer;
      jPar: TJSONPair;
  begin
    result := '';
    for i := 0 to jObj.Size - 1 do
    begin
      jPar := jObj.Get(i);
      if jPar.JsonValue Is TJSONObject then
        result := TrataObjeto((jPar.JsonValue As TJSONObject))
      else
      if sametext(trim(jPar.JsonString.Value),value) then
      begin
        Result := jPar.JsonValue.Value;
        break;
      end;

      if result <> '' then
        break;
    end;
  end;
begin
  try
    LJSONObject := nil;
    LJSONObject := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(json),0) as TJSONObject;
    result := TrataObjeto(LJSONObject);
  finally
    LJSONObject.Free;
  end;
end;

procedure TEnderecoIntegracao.InsereEndereco(objEndereco: TEndereco);
var
  qry : TFDQuery;
begin
  if not Assigned(objEndereco) then
    Exit;

  try
    qry := TFDQuery.Create(nil);
    qry.Connection := dmBanco.Banco;

    with qry do
    begin
      Close;
      SQL.Text := 'INSERT INTO ENDERECO_INTEGRACAO (IDENDERECO, DSUF, NMCIDADE, NMBAIRRO, NMLOGRADOURO, DSCOMPLEMENTO) VALUES ('+
                   IntToStr(objEndereco.idendereco)+','+
                   QuotedStr(objEndereco.dsuf)+','+
                   QuotedStr(objEndereco.nmcidade)+','+
                   QuotedStr(objEndereco.nmbairro)+','+
                   QuotedStr(objEndereco.nmlogradouro)+','+
                   QuotedStr(objEndereco.dscomplemento)+')';
      ExecSQL;
    end;
  finally
    qry.Free;
  end;
end;

function TEnderecoIntegracao.AtualizaEndereco(): boolean;
var
  Resp : IResponse;
  MemTable : TFDMemTable;
  objEndereco : TEndereco;
  qryEnd : TFDQuery;
begin
  try
    qryEnd := dmBanco.SqlAux;
    qryEnd.Connection := dmBanco.Banco;
    MemTable := TFDMemTable.Create(nil);

    with qryEnd do
    begin
      Close;
      SQL.Text := 'SELECT * ' +
                  ' FROM (SELECT ROW_NUMBER() OVER () ROWNUM, ' +
                  '              IDENDERECO, DSCEP FROM PESSOA P ' +
                  '         JOIN ENDERECO E ON E.IDPESSOA = P.IDPESSOA ' +
                  '        WHERE NOT EXISTS (SELECT 1 FROM ENDERECO_INTEGRACAO EI WHERE EI.IDENDERECO = E.IDENDERECO)' +
                  '      ) G WHERE ROWNUM <= 10 '; //Pegando apenas os primeiros dez que estão pendentes de ajustes de endereço
      Open;

      if not IsEmpty then
      begin
        while not Eof do
        begin
          Resp := TRequest.New.BaseURL('viacep.com.br/ws/'+FieldByName('dscep').AsString)
                  .Resource('/json/')
                  .Accept('application/json')
                  .DataSetAdapter(MemTable)
                  .Get;

          if Resp.StatusCode = 200 then
          begin
            try
              objEndereco := TEndereco.Create;
              objEndereco.idendereco    := FieldByName('idendereco').AsInteger;
              objEndereco.dsuf          := MemTable.FieldByName('uf').AsString;
              objEndereco.nmcidade      := MemTable.FieldByName('localidade').AsString;
              objEndereco.nmbairro      := MemTable.FieldByName('bairro').AsString;
              objEndereco.nmlogradouro  := MemTable.FieldByName('logradouro').AsString;
              objEndereco.dscomplemento := MemTable.FieldByName('complemento').AsString;
              InsereEndereco(objEndereco);
              objEndereco.Free;
            except
              objEndereco.Free;
            end;
          end;

          Next;
        end;
      end;
    end;
  finally
    qryEnd.Free;
  end;
end;

end.
