unit Model.Pessoa;

interface

uses FireDAC.Comp.Client, Data.DB, System.SysUtils, Model.Banco,
  System.Classes, RESTRequest4D;

type
  TEndereco = class
    idendereco    : Integer;
    dsuf          : string;
    nmcidade      : string;
    nmbairro      : string;
    nmlogradouro  : string;
    dscomplemento : string;
  end;

  TPessoa = class
  private
    Fidpessoa: Integer;
    Fflnatureza: Integer;
    Fnmprimeiro: string;
    Fdtregistro: TDate;
    Fnmsegundo: string;
    Fdscep: string;
    Fdsdocumento: string;

    procedure Setdscep(const Value: string);
    procedure Setdsdocumento(const Value: string);
    procedure Setdtregistro(const Value: TDate);
    procedure Setflnatureza(const Value: Integer);
    procedure Setidpessoa(const Value: Integer);
    procedure Setnmprimeiro(const Value: string);
    procedure Setnmsegundo(const Value: string);

    procedure InsereEndereco(objEndereco : TEndereco);
  public
    dmBanco : TdmBanco;
    constructor Create;
    destructor Destroy; override;

    property idpessoa:    Integer read Fidpessoa    write Setidpessoa;
    property flnatureza:  Integer read Fflnatureza  write Setflnatureza;
    property dsdocumento: string  read Fdsdocumento write Setdsdocumento;
    property nmprimeiro:  string  read Fnmprimeiro  write Setnmprimeiro;
    property nmsegundo:   string  read Fnmsegundo   write Setnmsegundo;
    property dtregistro:  TDate   read Fdtregistro  write Setdtregistro;
    property dscep:       string  read Fdscep       write Setdscep;

    function ListarPessoa(order_by: string; out erro: string): TFDQuery;
    function Inserir(out erro: string): Boolean;
    function Excluir(out erro: string): Boolean;
    function Alterar(out erro: string): Boolean;

    function InsertLote(Lista : TStringList; out erro: string): Boolean;
    function ListaEnderecoPendente(): TFDQuery;

    function AtualizaEndereco(out erro: string): boolean;

  end;

implementation

uses
  System.JSON;

{ TPessoa }

function TPessoa.AtualizaEndereco(out erro: string): boolean;
var
  Resp : IResponse;
  MemTable : TFDMemTable;
  objEndereco : TEndereco;
  qryEnd : TFDQuery;
  pessoa : TPessoa;
begin
  pessoa := TPessoa.Create;
  qryEnd := pessoa.ListaEnderecoPendente;

  try
    with qryEnd do
    begin
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
            finally
              objEndereco.Free;
            end;
          end;
        end;
      end;
    end;
  finally
    qryEnd.Free;
    pessoa.Free;
  end;
end;

constructor TPessoa.Create;
begin
  dmBanco := TdmBanco.Create(nil);
  dmBanco.Banco.Connected := True;
end;

destructor TPessoa.Destroy;
begin
  dmBanco.Banco.Connected := False;
end;

function TPessoa.Excluir(out erro: string): Boolean;
var
  qry : TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := dmBanco.Banco;

    with qry do
    begin
      Close;
      SQL.Clear;
      SQL.Add('DELETE FROM PESSOA WHERE IDPESSOA = '+IntToStr(Fidpessoa));
      ExecSQL;
    end;

    qry.Free;
    erro := '';
    result := true;
  except on ex:exception do
    begin
      erro := 'Erro ao excluir Pessoa: ' + ex.Message;
      Result := false;
    end;
  end;
end;

function TPessoa.Alterar(out erro: string): Boolean;
var
  qry : TFDQuery;
  idendereco : string;
begin
  if idpessoa <= 0 then
  begin
    Result := false;
    erro := 'Informe o id da pessoa';
    exit;
  end;

  try
    qry := TFDQuery.Create(nil);
    qry.Connection := dmBanco.Banco;

    with qry do
    begin
      Close;
      SQL.Clear;
      SQL.Add('UPDATE PESSOA SET ');
      SQL.Add('flnatureza     = '+IntToStr(flnatureza)+',');
      SQL.Add('nmprimeiro     = '+QuotedStr(nmprimeiro)+',');
      SQL.Add('nmsegundo      = '+QuotedStr(nmsegundo)+',');
      SQL.Add('dtregistro     = :dtregistro, ');
      SQL.Add('dsdocumento    = '+QuotedStr(dsdocumento));
      SQL.Add('WHERE idpessoa = '+IntToStr(idpessoa));

      ParamByName('dtregistro').AsDate := dtregistro;

      ExecSQL;

      Close;
      SQL.Clear;
      SQL.Add('UPDATE ENDERECO SET');
      SQL.Add(' DSCEP = '+QuotedStr(dscep));
      SQL.Add('WHERE idpessoa = '+IntToStr(idpessoa));
      SQL.Add('returning idendereco as idendereco');
      Open;

      idendereco := FieldByName('idendereco').AsString;

      Close;
      SQL.Clear;
      SQL.Add('DELETE FROM ENDERECO_INTEGRACAO WHERE IDENDERECO ='+idendereco);
      ExecSQL;
    end;

    qry.Free;
    erro := '';
    result := true;

  except on ex:exception do
    begin
      erro := 'Erro ao alterar cliente: ' + ex.Message;
      Result := false;
    end;
  end;
end;

procedure TPessoa.InsereEndereco(objEndereco: TEndereco);
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

function TPessoa.Inserir(out erro: string): Boolean;
var
  qry : TFDQuery;
begin
  // Validacoes...
  if Trim(dscep).Length < 8 then
  begin
    Result := false;
    erro := 'Informe o CEP';
    exit;
  end;

  try
    qry := TFDQuery.Create(nil);
    qry.Connection := dmBanco.Banco;

    with qry do
    begin
      Close;
      SQL.Clear;
      SQL.Add('insert into pessoa (flnatureza, dsdocumento, nmprimeiro, nmsegundo, dtregistro) values ('+IntToStr(flnatureza)+', '+QuotedStr(dsdocumento)+','+QuotedStr(nmprimeiro)+','+QuotedStr(nmsegundo)+','+QuotedStr(FormatDateTime('yyyy-mm-dd', dtregistro))+') returning idpessoa as idpessoa ');
      Open;

      idpessoa := FieldByName('idpessoa').AsInteger;

      Close;
      SQL.Clear;
      SQL.Add('insert into endereco (idpessoa, dscep) values ('+IntToStr(idpessoa)+', '+QuotedStr(dscep)+')');
      ExecSQL;
    end;

    qry.Free;
    erro := '';
    result := true;

  except on ex:exception do
    begin
      erro := 'Erro ao cadastrar pessoa: ' + ex.Message;
      Result := false;
    end;
  end;
end;

function TPessoa.InsertLote(Lista: TStringList; out erro: string): Boolean;
var
  qry : TFDQuery;
  I: Integer;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := dmBanco.Banco;

    for I := 0 to Lista.Count-1 do
    begin
      with qry do
      begin
        if (I mod 2) = 0 then
        begin
          Close;
          SQL.Clear;
          SQL.Text := Lista[I];
          Open;

          idpessoa := FieldByName('idpessoa').AsInteger;
        end
        else
        begin
          Close;
          SQL.Clear;
          SQL.Text := Lista[I];
          ParamByName('idpessoa').AsInteger := idpessoa;
          ExecSQL;
        end;
      end;
    end;

    qry.Free;
    erro := '';
    result := true;
  except on ex:exception do
    begin
      erro := 'Erro ao cadastrar pessoa: ' + ex.Message;
      Result := false;
    end;
  end;
end;

function TPessoa.ListaEnderecoPendente: TFDQuery;
var
  qry : TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := dmBanco.Banco;

    with qry do
    begin
      Close;
      SQL.Text := 'SELECT * ' +
                  ' FROM (SELECT ROW_NUMBER() OVER () ROWNUM, ' +
                  '              IDENDERECO, DSCEP FROM PESSOA P ' +
                  '         JOIN ENDERECO E ON E.IDPESSOA = P.IDPESSOA ' +
                  '        WHERE NOT EXISTS (SELECT 1 FROM ENDERECO_INTEGRACAO EI WHERE EI.IDENDERECO = E.IDENDERECO)' +
                  '      ) G WHERE ROWNUM <= 10 '; //Pegando apenas os primeiros dez que estão pendentes de ajustes de endereço
      Open;
    end;

    Result := qry;
  except on ex:exception do
    begin
       Result := nil;
    end;
  end;

end;

function TPessoa.ListarPessoa(order_by: string; out erro: string): TFDQuery;
var
  qry : TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := dmBanco.Banco;

    with qry do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM ( ');
      SQL.Add('               select row_number() OVER () ROWNUM, p.*, e.dscep');
      SQL.Add('                from pessoa p ');
      SQL.Add('                JOIN ENDERECO E ON E.IDPESSOA = P.IDPESSOA');
      SQL.Add('               WHERE 1 = 1 ');

      if idpessoa > 0 then
      begin
        SQL.Add('AND p.idpessoa = '+IntToStr(Fidpessoa));
      end;

      if nmprimeiro <> EmptyStr then
      begin
        SQL.Add('and UPPER(p.nmprimeiro) LIKE '+QuotedStr('%'+UpperCase(nmprimeiro)+'%'));
      end;

      SQL.Add('              ) G WHERE G.ROWNUM <= 100');


      if order_by = '' then
          SQL.Add('ORDER BY G.nmprimeiro')
      else
          SQL.Add('ORDER BY ' + order_by);

      Open;
    end;

    erro := '';
    Result := qry;
  except on ex:exception do
    begin
      erro := 'Erro ao consultar clientes: ' + ex.Message;
       Result := nil;
    end;
  end;
end;

procedure TPessoa.Setdscep(const Value: string);
begin
  Fdscep := Value;
end;

procedure TPessoa.Setdsdocumento(const Value: string);
begin
  Fdsdocumento := Value;
end;

procedure TPessoa.Setdtregistro(const Value: TDate);
begin
  Fdtregistro := Value;
end;

procedure TPessoa.Setflnatureza(const Value: Integer);
begin
  Fflnatureza := Value;
end;

procedure TPessoa.Setidpessoa(const Value: Integer);
begin
  Fidpessoa := Value;
end;

procedure TPessoa.Setnmprimeiro(const Value: string);
begin
  Fnmprimeiro := Value;
end;

procedure TPessoa.Setnmsegundo(const Value: string);
begin
  Fnmsegundo := Value;
end;

end.
