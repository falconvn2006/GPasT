unit MainModule;

interface

uses
  uniGUIMainModule, SysUtils, Classes, Data.DB, Data.Win.ADODB,
  Datasnap.Provider, Datasnap.DBClient, MidasLib;

type
  TUniMainModule = class(TUniGUIMainModule)
    ADOConnectionUsuario: TADOConnection;
    QryUsuario: TADOQuery;
    CdsUsuario: TClientDataSet;
    DspUsuario: TDataSetProvider;
    ADOConnectionControle: TADOConnection;
    QryUsuarioPermissao: TADOQuery;
    DspUsuarioPermissao: TDataSetProvider;
    CdsUsuarioPermissao: TClientDataSet;
    QryTschema: TADOQuery;
    DspTschema: TDataSetProvider;
    CdsTschema: TClientDataSet;
    QryMenuSchema: TADOQuery;
    DspMenuSchema: TDataSetProvider;
    CdsMenuSchema: TClientDataSet;
    QryAx1: TADOQuery;
    DspAx1: TDataSetProvider;
    CdsAx1: TClientDataSet;
    QryAx2: TADOQuery;
    DspAx2: TDataSetProvider;
    CdsAx2: TClientDataSet;
    CdsAx3: TClientDataSet;
    DspAx3: TDataSetProvider;
    QryAx3: TADOQuery;
    CdsAx4: TClientDataSet;
    DspAx4: TDataSetProvider;
    QryAx4: TADOQuery;
  private
    function GeraId(Tabela: String): Integer;


    { Private declarations }
  public
     CadastroIdUsuario : integer;
    { Public declarations }
    function md5(S: String): String;
    function SchemaCriado: boolean;
    function UsuarioExiste(login: String): boolean;
    function TabelaExiste: boolean;
    function NovoUsuario(login,
                         Senha : String): Boolean;
    function ConectarNovoSchema(Banco, Usuario, Senha: string): Boolean;
{    function EmpresaExiste(razao_social, celular,
      email: String): TClientDataSet;}
  end;

function UniMainModule: TUniMainModule;

implementation

{$R *.dfm}


uses
  UniGUIVars, ServerModule, uniGUIApplication, IdHashMessageDigest;

function UniMainModule: TUniMainModule;
begin
  Result := TUniMainModule(UniApplication.UniMainModule)
end;

function TUniMainModule.GeraId(Tabela: String): Integer;
var
  Query: TADOQuery;
  Sequencia: String;
begin
  Result := -1;

  // Define o nome da sequência.
  // NOTE: O nome da sequência deve ter no máximo 30 caracteres (conforme o
  //       padrão de nomeclatura do Oracle).
  Sequencia := Copy('se_' + Tabela, 1, 30);

  Query := TADOQuery.Create(Self);
  Query.Connection := ADOConnectionUsuario;

  // Carrega o id gerado pela sequência
  Query.SQL.Text := 'SELECT ' + Sequencia + '.NEXTVAL FROM dual';
  Query.Open;

  Result := Query.Fields[0].AsInteger;

  // Fecha e descarta a query
  Query.Close;
  Query.Destroy;
end;


function TUniMainModule.NovoUsuario(login,
                                    Senha : String): Boolean;
var
  CadastroIdUsuarioPermissao,
  CadastroIdTschema,
  CadastroIdMenuSchema: integer;
  Erro: String;
begin
  Result := False;
// Inicia a transação
  ADOConnectionUsuario.BeginTrans;

  // Passo Unico - Salva os dados da cidade
  QryUsuario.Parameters.Clear;
  QryUsuario.SQL.Clear;
// Gera um novo id para a tabela usuario
  CadastroIdUsuario := GeraId('usuario');

  // Insert
  QryUsuario.SQL.Add('INSERT INTO usuario (');
  QryUsuario.SQL.Add('       id,');
  QryUsuario.SQL.Add('       login,');
  QryUsuario.SQL.Add('       senha,');
  QryUsuario.SQL.Add('       data_inativa,');
  QryUsuario.SQL.Add('       schema)');
  QryUsuario.SQL.Add('VALUES (');
  QryUsuario.SQL.Add('       :id,');
  QryUsuario.SQL.Add('       :login,');
  QryUsuario.SQL.Add('       :senha,');
  QryUsuario.SQL.Add('       SYSDATE +30,');
  QryUsuario.SQL.Add('       :schema)');

  QryUsuario.Parameters.ParamByName('id').Value     := CadastroIdUsuario;
  QryUsuario.Parameters.ParamByName('login').Value  := login;
//  QryUsuario.Parameters.ParamByName('senha').Value  := senha;
  QryUsuario.Parameters.ParamByName('senha').Value  := md5(senha);
  QryUsuario.Parameters.ParamByName('schema').Value := 'CONTROLE_'+ IntToStr(CadastroIdUsuario);


  try
    // Tenta salvar os dados
    QryUsuario.ExecSQL;
  except
    on E: Exception do
    begin
      // Descarta a transação
      ADOConnectionUsuario.RollbackTrans;
      Exit;
    end;
  end;


  // Inserir para colocar os menus que o usuario poderá acessar no caso aqui total
  QryUsuarioPermissao.Parameters.Clear;
  QryUsuarioPermissao.SQL.Clear;

  // Gera um novo id para a tabela usuario permissao controle
  CadastroIdUsuarioPermissao := GeraId('usuario_permissao_controle');

  // Gera um novo id para a tabela usuario permissao controle
  QryUsuarioPermissao.SQL.Add('INSERT INTO usuario_permissao_controle (');
  QryUsuarioPermissao.SQL.Add('       id,');
  QryUsuarioPermissao.SQL.Add('       usuario_id)');
  QryUsuarioPermissao.SQL.Add('VALUES (');
  QryUsuarioPermissao.SQL.Add('       :id,');
  QryUsuarioPermissao.SQL.Add('       :usuario_id)');

  QryUsuarioPermissao.Parameters.ParamByName('id').Value     := CadastroIdUsuarioPermissao;
  QryUsuarioPermissao.Parameters.ParamByName('usuario_id').Value     := CadastroIdUsuario;

  try
    // Tenta salvar os dados
    QryUsuarioPermissao.ExecSQL;
  except
    on E: Exception do
    begin
      // Descarta a transação
      ADOConnectionUsuario.RollbackTrans;
      Exit;
    end;
  end;

  // Inserir para colocar os menus que o usuario poderá acessar no caso aqui total
  QryTschema.Parameters.Clear;
  QryTschema.SQL.Clear;

  // Gera um novo id para a tabela TSCHEMA
  CadastroIdTschema := GeraId('tschema');

  // Gera um novo id para a tabela usuario permissao controle
  QryTschema.SQL.Add('INSERT INTO tschema (');
  QryTschema.SQL.Add('       id,');
  QryTschema.SQL.Add('       descricao)');
  QryTschema.SQL.Add('VALUES (');
  QryTschema.SQL.Add('       :id,');
  QryTschema.SQL.Add('       :descricao)');

  QryTschema.Parameters.ParamByName('id').Value     := CadastroIdTschema;
  QryTschema.Parameters.ParamByName('descricao').Value     := 'CONTROLE_'+ IntToStr(CadastroIdUsuario);

    try
    // Tenta salvar os dados
    QryTschema.ExecSQL;
  except
    on E: Exception do
    begin
      // Descarta a transação
      ADOConnectionUsuario.RollbackTrans;
      Exit;
    end;
  end;

  CdsAx1.Close;
  QryAx1.Sql.Clear;
  QryAx1.Sql.Add('SELECT menu_id');
  QryAx1.Sql.Add('  FROM menu_schema');
  QryAx1.Sql.Add(' WHERE schema_id = 6');
  CdsAx1.Open;

  CdsAx1.First;
  While not CdsAx1.eof do
  begin
    // Inserir para colocar os menus que o usuario poderá acessar no caso aqui total
    QryMenuSchema.Parameters.Clear;
    QryMenuSchema.SQL.Clear;

    // Gera um novo id para a tabela usuario permissao controle
    CadastroIdMenuSchema := GeraId('menu_schema');

    // Gera um novo id para a tabela usuario permissao controle
    QryMenuSchema.SQL.Add('INSERT INTO menu_schema (');
    QryMenuSchema.SQL.Add('       id,');
    QryMenuSchema.SQL.Add('       menu_id,');
    QryMenuSchema.SQL.Add('       schema_id)');
    QryMenuSchema.SQL.Add('VALUES (');
    QryMenuSchema.SQL.Add('       :id,');
    QryMenuSchema.SQL.Add('       :menu_id,');
    QryMenuSchema.SQL.Add('       :schema_id)');

    QryMenuSchema.Parameters.ParamByName('id').Value          := CadastroIdMenuSchema;
    QryMenuSchema.Parameters.ParamByName('menu_id').Value     := CdsAx1.FieldByName('menu_id').asString;
    QryMenuSchema.Parameters.ParamByName('schema_id').Value   := CadastroIdTschema;

    try
      // Tenta salvar os dados
      QryMenuSchema.ExecSQL;
    except
      on E: Exception do
      begin
        // Descarta a transação
        ADOConnectionUsuario.RollbackTrans;
        Exit;
      end;
    end;
    CdsAx1.Next;
  end;

  Result := True;
end;


function TUniMainModule.UsuarioExiste(login: String): boolean;

begin

  Result := False;

  cdsUsuario.close;
  QryUsuario.Parameters.Clear;
  QryUsuario.SQL.Clear;
  QryUsuario.SQL.Add('SELECT login');
  QryUsuario.SQL.Add('  FROM usuario');
  QryUsuario.SQL.Add(' WHERE login like '''+ login  + '''');
  cdsUsuario.Open;

  if CdsUsuario.RecordCount >0 then
    Result := true;
end;

function TUniMainModule.SchemaCriado : boolean;
begin
  Result := False;

  cdsAx2.close;
  QryAx2.Parameters.Clear;
  QryAx2.SQL.Clear;
  QryAx2.SQL.Add('SELECT schema_criado');
  QryAx2.SQL.Add('  FROM usuario');
  QryAx2.SQL.Add(' WHERE schema_criado =''S''');
  QryAx2.SQL.Add('   AND schema = ' + 'CONTROLE_'+ IntToStr(CadastroIdUsuario));
  cdsAx2.Open;

  if CdsAx2.RecordCount >0 then
   Result := true;
end;


function TUniMainModule.TabelaExiste : boolean;
begin
  Result := False;

  cdsAx3.close;
  QryAx3.Parameters.Clear;
  QryAx3.SQL.Clear;
  QryAx3.SQL.Add('SELECT column_name');
  QryAx3.SQL.Add('  FROM user_tab_cols');
  QryAx3.SQL.Add(' WHERE table_name =''FILIAL''');
  cdsAx3.Open;

  if CdsAx3.RecordCount >0 then
   Result := true;
end;



function TUniMainModule.md5(S: String): String;
var
  md5: TIdHashMessageDigest5;
begin
  md5    := TIdHashMessageDigest5.Create;
  result := md5.HashStringAsHex(S);
  md5.Free;
end;

function TUniMainModule.ConectarNovoSchema(Banco, Usuario, Senha: string): Boolean;
begin
  // Tenta conectar-se ao banco de dados
  try
    ADOConnectionControle.Close;

    ADOConnectionControle.ConnectionString :=
        'Provider=OraOLEDB.Oracle.1;'
      + 'Data Source=' + Banco + ';'
      + 'Persist Security Info=True';

    ADOConnectionControle.Open(Usuario, Senha);

    Result := ADOConnectionControle.Connected;
  except
    on e:exception do
      Result := False;
  end;
end;


initialization
  RegisterMainModuleClass(TUniMainModule);
end.
