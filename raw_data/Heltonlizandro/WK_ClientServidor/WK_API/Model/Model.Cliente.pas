unit Model.Cliente;

interface

uses FireDAC.Comp.Client, Data.DB, System.SysUtils, Model.Connection;

type
    TCliente = class
    private
        FID_CLIENTE: Integer;
        FNOME: string;
        FEMAIL: string;
        FFONE: string;
    public
        constructor Create;
        destructor Destroy; override;
        property ID_CLIENTE : Integer read FID_CLIENTE write FID_CLIENTE;
        property NOME : string read FNOME write FNOME;
        property EMAIL : string read FEMAIL write FEMAIL;
        property FONE : string read FFONE write FFONE;

        function ListarCliente(order_by: string; out erro: string): TFDQuery;
        function Inserir(out erro: string): Boolean;
        function Excluir(out erro: string): Boolean;
        function Editar(out erro: string): Boolean;
end;

implementation

{ TCliente }

constructor TCliente.Create;
begin
    Model.Connection.Connect;
end;

destructor TCliente.Destroy;
begin
    Model.Connection.Disconect;
end;

function TCliente.Excluir(out erro: string): Boolean;
var
    qry : TFDQuery;
begin
    try
        qry := TFDQuery.Create(nil);
        qry.Connection := Model.Connection.FConnection;

        with qry do
        begin
            Active := false;
            sql.Clear;
            SQL.Add('DELETE FROM TAB_CLIENTE WHERE ID_CLIENTE=:ID_CLIENTE');
            ParamByName('ID_CLIENTE').Value := ID_CLIENTE;
            ExecSQL;
        end;

        qry.Free;
        erro := '';
        result := true;

    except on ex:exception do
        begin
            erro := 'Erro ao excluir cliente: ' + ex.Message;
            Result := false;
        end;
    end;
end;

function TCliente.Editar(out erro: string): Boolean;
var
    qry : TFDQuery;
begin
    // Validacoes...
    if ID_CLIENTE <= 0 then
    begin
        Result := false;
        erro := 'Informe o id. cliente';
        exit;
    end;

    try
        qry := TFDQuery.Create(nil);
        qry.Connection := Model.Connection.FConnection;

        with qry do
        begin
            Active := false;
            sql.Clear;
            SQL.Add('UPDATE TAB_CLIENTE SET NOME=:NOME, EMAIL=:EMAIL, FONE=:FONE');
            SQL.Add('WHERE ID_CLIENTE=:ID_CLIENTE');
            ParamByName('NOME').Value := NOME;
            ParamByName('EMAIL').Value := EMAIL;
            ParamByName('FONE').Value := FONE;
            ParamByName('ID_CLIENTE').Value := ID_CLIENTE;
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

function TCliente.Inserir(out erro: string): Boolean;
var
    qry : TFDQuery;
begin
    // Validacoes...
    if NOME.IsEmpty then
    begin
        Result := false;
        erro := 'Informe o nome do cliente';
        exit;
    end;

    try
        qry := TFDQuery.Create(nil);
        qry.Connection := Model.Connection.FConnection;

        with qry do
        begin
            Active := false;
            sql.Clear;
            SQL.Add('INSERT INTO TAB_CLIENTE(NOME, EMAIL, FONE)');
            SQL.Add('VALUES(:NOME, :EMAIL, :FONE)');

            ParamByName('NOME').Value := NOME;
            ParamByName('EMAIL').Value := EMAIL;
            ParamByName('FONE').Value := FONE;

            ExecSQL;

            // Busca ID inserido...
            Params.Clear;
            SQL.Clear;
            SQL.Add('SELECT MAX(ID_CLIENTE) AS ID_CLIENTE FROM TAB_CLIENTE');
            SQL.Add('WHERE EMAIL=:EMAIL');
            ParamByName('EMAIL').Value := EMAIL;
            active := true;

            ID_CLIENTE := FieldByName('ID_CLIENTE').AsInteger;
        end;

        qry.Free;
        erro := '';
        result := true;

    except on ex:exception do
        begin
            erro := 'Erro ao cadastrar cliente: ' + ex.Message;
            Result := false;
        end;
    end;
end;

function TCliente.ListarCliente(order_by: string;
                                out erro: string): TFDQuery;
var
    qry : TFDQuery;
begin
    try
        qry := TFDQuery.Create(nil);
        qry.Connection := Model.Connection.FConnection;

        with qry do
        begin
            Active := false;
            SQL.Clear;
            SQL.Add('SELECT * FROM TAB_CLIENTE WHERE 1 = 1');

            if ID_CLIENTE > 0 then
            begin
                SQL.Add('AND ID_CLIENTE = :ID_CLIENTE');
                ParamByName('ID_CLIENTE').Value := ID_CLIENTE;
            end;

            if order_by = '' then
                SQL.Add('ORDER BY NOME')
            else
                SQL.Add('ORDER BY ' + order_by);

            Active := true;
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

end.
