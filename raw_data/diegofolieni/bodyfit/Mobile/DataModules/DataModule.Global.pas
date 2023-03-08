unit DataModule.Global;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, Data.DB,
  FireDAC.Comp.Client, DataSet.Serialize.Config, System.IOUtils,
  System.DateUtils, RestRequest4D, System.JSON, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.DApt;

type
  TdmGlobal = class(TDataModule)
    Conn: TFDConnection;
    TabUsuario: TFDMemTable;
    qryUsuario: TFDQuery;
    TabTreino: TFDMemTable;
    qryTreinoExercicio: TFDQuery;
    qryConsEstatistica: TFDQuery;
    qryConsTreino: TFDQuery;
    qryConsExercicio: TFDQuery;
    qryAtividade: TFDQuery;
    qryGeral: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure ConnBeforeConnect(Sender: TObject);
    procedure ConnAfterConnect(Sender: TObject);
  private
    { Private declarations }
  public
    procedure LoginOnline(email, senha: String);
    procedure CriarContaOnline(nome, email, senha: string);
    procedure InserirUsuario(id_usuario: Integer; nome, email: string);
    procedure ListarUsuario;
    procedure EditarUsuario(Nome, Email: String);
    procedure EditarUsuarioOnline(id_usuario: Integer; nome, email: String);
    procedure EditarSenhaOnline(id_usuario: Integer; senha: string);
    procedure ListarTreinoExercicioOnline(id_usuario: integer);
    procedure ExcluirTreinoExercicio;
    procedure InserirTreinoExercicio(id_treino: integer;
                                     treino, descr_treino: string;
                                     dia_semana, id_exercicio: integer;
                                     exercicio, descr_exercicio, duracao, url_video: string);
    function TreinosMes(dt: TDateTime): integer;
    function Pontuacao: integer;
    procedure TreinoSugerido(dt: TDateTime);
    procedure ListarTreinos;
    procedure ListarExercicios(IdTreino: Integer);
    procedure DetalheExercicio(IdExercicio: Integer);
    procedure IniciarTreino(IdTreino: Integer);
    procedure ListarExerciciosAtividade;
    procedure FinalizarTreino(IdTreino: integer);
    procedure MarcarExercicioConcluido(IdExercicio: Integer; IndConcluido: Boolean);
    procedure Logout;
  end;

var
  dmGlobal: TdmGlobal;

const
  BASE_URL = 'http://192.168.0.172:3000';

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TdmGlobal.ConnAfterConnect(Sender: TObject);
begin
  Conn.ExecSQL('CREATE TABLE IF NOT EXISTS tab_usuario('+
                           'id_usuario INTEGER NOT NULL PRIMARY KEY, '+
                           'nome VARCHAR(100),'+
                           'email VARCHAR(100),'+
                           'pontos INTEGER);'
              );
  Conn.ExecSQL('CREATE TABLE IF NOT EXISTS tab_treino_exercicio('+
                           'id_treino_exercicio INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,'+
                           'id_treino INTEGER,'+
                           'treino VARCHAR(100),'+
                           'descr_treino VARCHAR(100),'+
                           'dia_semana INTEGER,'+
                           'id_exercicio INTEGER,'+
                           'exercicio VARCHAR(100),'+
                           'descr_exercicio VARCHAR(1000),'+
                           'duracao VARCHAR(100),'+
                           'url_video VARCHAR(1000));'
              );
  Conn.ExecSQL('CREATE TABLE IF NOT EXISTS tab_atividade_historico('+
                           'id_historico INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,'+
                           'id_treino INTEGER,'+
                           'dt_atividade DATETIME)'
              );
  Conn.ExecSQL('CREATE TABLE IF NOT EXISTS tab_atividade('+
                           'id_atividade INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,'+
                           'id_treino INTEGER,'+
                           'id_exercicio INTEGER,'+
                           'exercicio VARCHAR(100),'+
                           'duracao VARCHAR(100),'+
                           'ind_concluido CHAR(1));'
              );
end;

procedure TdmGlobal.ConnBeforeConnect(Sender: TObject);
begin
  Conn.DriverName := 'SQLite';

  {$IFDEF MSWINDOWS}
    Conn.Params.Values['Database'] := System.SysUtils.GetCurrentDir + '\banco.db';
  {$ELSE}
    Conn.Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath, 'banco.db');
  {$ENDIF}
end;

procedure TdmGlobal.CriarContaOnline(nome, email, senha: string);
var
  resp: IResponse;
  json: TJSONObject;
begin
  TabUsuario.FieldDefs.Clear;
  json := TJSONObject.Create;
  try
    json.AddPair('nome', nome);
    json.AddPair('email', email);
    json.AddPair('senha', senha);

    resp := TRequest.New.BaseURL(BASE_URL)
            .Resource('usuarios/registro')
            .AddBody(json.ToJSON)
            .BasicAuthentication('diegofolieni','06051998')
            .Accept('application/json')
            .DataSetAdapter(TabUsuario)
            .Post;

    if(resp.StatusCode <> 201)then
      raise Exception.Create(resp.Content);


  finally
    json.DisposeOf;
  end;
end;

procedure TdmGlobal.DataModuleCreate(Sender: TObject);
begin
  TDataSetSerializeConfig.GetInstance.CaseNameDefinition := cndLower;
  TDataSetSerializeConfig.GetInstance.Import.DecimalSeparator := '.';

  Conn.Connected := true;
end;

procedure TdmGlobal.DetalheExercicio(IdExercicio: Integer);
begin
  with qryConsExercicio do
  begin
    Active := False;
    SQL.Clear;
    SQL.Add('SELECT * FROM tab_treino_exercicio');
    SQL.Add('WHERE id_exercicio = :id_exercicio');

    ParamByName('id_exercicio').AsInteger := IdExercicio;

    Open;
  end;
end;

procedure TdmGlobal.ExcluirTreinoExercicio;
begin
  Conn.ExecSQL('DELETE FROM tab_treino_exercicio');
end;

procedure TdmGlobal.FinalizarTreino(IdTreino: integer);
begin
  with qryGeral do
  begin
    Active := False;
    SQL.Clear;
    SQL.Add('INSERT INTO tab_atividade_historico(id_treino, dt_atividade)');
    SQL.Add('VALUES(:id_treino, :dt_atividade)');
    ParamByName('id_treino'   ).AsInteger := IdTreino;
    ParamByName('dt_atividade').AsString    := FormatDateTime('yyyy-mm-dd', Now);
    ExecSQL;

    Active := False;
    SQL.Clear;
    SQL.Add('DELETE FROM tab_atividade');
    ExecSQL;

    Active := False;
    SQL.Clear;
    SQL.Add('UPDATE tab_usuario SET pontos = IFNULL(pontos, 0) + 10');
    ExecSQL;

  end;
end;

procedure TdmGlobal.IniciarTreino(IdTreino: Integer);
begin
  with qryAtividade do
  begin
    Active := False;
    SQL.Clear;
    SQL.Add('DELETE FROM tab_atividade');
    ExecSQL;

    Active := False;
    SQL.Clear;
    SQL.Add('INSERT INTO tab_atividade(id_treino, id_exercicio, exercicio, duracao, ind_concluido)');
    SQL.Add('SELECT id_treino, id_exercicio, exercicio, duracao, ''N'' ');
    SQL.Add('FROM tab_treino_exercicio');
    SQL.Add('WHERE id_treino = :id_treino');

    ParamByName('id_treino').AsInteger := IdTreino;

    ExecSQL;
  end;
end;

procedure TdmGlobal.InserirTreinoExercicio(id_treino: integer; treino,
  descr_treino: string; dia_semana, id_exercicio: integer; exercicio,
  descr_exercicio, duracao, url_video: string);
begin
  with qryTreinoExercicio do
  begin
    Active := False;
    SQL.Clear;
    SQL.Add('INSERT INTO tab_treino_exercicio(id_treino, treino, descr_treino,');
    SQL.Add('dia_semana, id_exercicio, exercicio, descr_exercicio, duracao, url_video)');
    SQL.Add('VALUES(:id_treino, :treino, :descr_treino,');
    SQL.Add(':dia_semana, :id_exercicio, :exercicio, :descr_exercicio, :duracao, :url_video)');

    ParamByName('id_treino').AsInteger := id_treino;
    ParamByName('treino').AsString := treino;
    ParamByName('descr_treino').AsString := descr_treino;
    ParamByName('dia_semana').AsInteger := dia_semana;
    ParamByName('id_exercicio').AsInteger := id_exercicio;
    ParamByName('exercicio').AsString := exercicio;
    ParamByName('descr_exercicio').AsString := descr_exercicio;
    ParamByName('duracao').AsString := duracao;
    ParamByName('url_video').AsString := url_video;

    ExecSQL;
  end;
end;

procedure TdmGlobal.InserirUsuario(id_usuario: Integer; nome, email: string);
begin
  with qryUsuario do
  begin
    Active := False;
    SQL.Clear;
    SQL.Add('DELETE FROM tab_usuario WHERE id_usuario <> :id_usuario');
    ParamByName('id_usuario').AsInteger := id_usuario;
    ExecSQL;

    SQL.Clear;
    SQL.Add('SELECT * FROM tab_usuario');
    Open;
    if(RecordCount = 0)then
    begin
      SQL.Clear;
      SQL.Add('INSERT INTO tab_usuario(id_usuario, nome, email, pontos)');
      SQL.Add('VALUES(:id_usuario, :nome, :email, 0)');
      ParamByName('id_usuario').AsInteger := id_usuario;
      ParamByName('nome').AsString := nome;
      ParamByName('email').AsString := email;

      ExecSQL;
    end else
    begin
      SQL.Clear;
      SQL.Add('UPDATE tab_usuario SET nome=:nome, email=:email');
      ParamByName('nome').AsString := nome;
      ParamByName('email').AsString := email;

      ExecSQL;
    end;
  end;
end;

procedure TdmGlobal.ListarUsuario;
begin
  with qryUsuario do
  begin
    Active := False;
    SQL.Clear;
    SQL.Add('SELECT * FROM tab_usuario');
    Open;
  end;
end;

procedure TdmGlobal.EditarSenhaOnline(id_usuario: Integer; senha: string);
var
  resp: IResponse;
  json: TJSONObject;
begin
  json := TJSONObject.Create;
  try
    json.AddPair('id_usuario', TJSONNumber.Create(id_usuario));
    json.AddPair('senha', senha);

    resp := TRequest.New.BaseURL(BASE_URL)
            .Resource('usuarios/senha')
            .AddBody(json.ToJSON)
            .BasicAuthentication('diegofolieni','06051998')
            .Accept('application/json')
            .Put;

    if(resp.StatusCode <> 200)then
      raise Exception.Create(resp.Content);


  finally
    json.DisposeOf;
  end;
end;

procedure TdmGlobal.EditarUsuario(Nome, Email: String);
begin
  with qryUsuario do
  begin
    Active := False;
    SQL.Clear;
    SQL.Add('UPDATE tab_usuario SET nome=:nome, email=:email');
    ParamByName('nome' ).AsString := Nome;
    ParamByName('email').AsString := Email;

    ExecSQL;
  end;
end;

procedure TdmGlobal.EditarUsuarioOnline(id_usuario: Integer; nome, email: String);
var
  resp: IResponse;
  json: TJSONObject;
begin
  json := TJSONObject.Create;
  try
    json.AddPair('id_usuario', TJSONNumber.Create(id_usuario));
    json.AddPair('nome', nome);
    json.AddPair('email', email);

    resp := TRequest.New.BaseURL(BASE_URL)
            .Resource('usuarios')
            .AddBody(json.ToJSON)
            .BasicAuthentication('diegofolieni','06051998')
            .Accept('application/json')
            .Put;

    if(resp.StatusCode <> 200)then
      raise Exception.Create(resp.Content);


  finally
    json.DisposeOf;
  end;
end;

procedure TdmGlobal.ListarExercicios(IdTreino: Integer);
begin
  with qryConsExercicio do
  begin
    Active := False;
    SQL.Clear;
    SQL.Add('SELECT * FROM tab_treino_exercicio');
    SQL.Add('WHERE id_treino = :id_treino');
    SQL.Add('ORDER BY exercicio');

    ParamByName('id_treino').AsInteger := IdTreino;

    Open;
  end;
end;

procedure TdmGlobal.ListarExerciciosAtividade;
begin
  with qryConsExercicio do
  begin
    Active := False;
    SQL.Clear;
    SQL.Add('SELECT * FROM tab_atividade');
    SQL.Add('ORDER BY exercicio');
    Open;
  end;
end;

procedure TdmGlobal.ListarTreinoExercicioOnline(id_usuario: integer);
var
  resp: IResponse;
begin
  TabTreino.FieldDefs.Clear;

  resp := TRequest.New.BaseURL(BASE_URL)
          .Resource('treinos')
          .AddParam('id_usuario', id_usuario.ToString)
          .BasicAuthentication('diegofolieni','06051998')
          .Accept('application/json')
          .DataSetAdapter(TabTreino)
          .Get;

  if(resp.StatusCode <> 200)then
    raise Exception.Create(resp.Content);
end;

procedure TdmGlobal.ListarTreinos;
begin
  with qryConsTreino do
  begin
    Active := False;
    SQL.Clear;
    SQL.Add('SELECT DISTINCT id_treino, treino, descr_treino');
    SQL.Add('FROM tab_treino_exercicio');
    SQL.Add('ORDER BY dia_semana');
    Open;
  end;
end;

procedure TdmGlobal.LoginOnline(email, senha: String);
var
  resp: IResponse;
  json: TJSONObject;
begin
  TabUsuario.FieldDefs.Clear;
  json := TJSONObject.Create;
  try
    json.AddPair('email', email);
    json.AddPair('senha', senha);

    resp := TRequest.New.BaseURL(BASE_URL)
            .Resource('usuarios/login')
            .AddBody(json.ToJSON)
            .BasicAuthentication('diegofolieni','06051998')
            .Accept('application/json')
            .DataSetAdapter(TabUsuario)
            .Post;

    if(resp.StatusCode <> 200)then
      raise Exception.Create(resp.Content);


  finally
    json.DisposeOf;
  end;
end;

procedure TdmGlobal.Logout;
begin
  Conn.ExecSQL('DELETE FROM tab_atividade_historico');
  Conn.ExecSQL('DELETE FROM tab_atividade');
  Conn.ExecSQL('DELETE FROM tab_usuario');
  Conn.ExecSQL('DELETE FROM tab_treino_exercicio');
end;

procedure TdmGlobal.MarcarExercicioConcluido(IdExercicio: Integer; IndConcluido: Boolean);
begin
  with qryGeral do
  begin
    Active := False;
    SQL.Clear;
    SQL.Add('UPDATE tab_atividade SET ind_concluido = :ind_concluido');
    SQL.Add('WHERE id_exercicio = :id_exercicio');
    ParamByName('id_exercicio' ).AsInteger := IdExercicio;
    if(IndConcluido)then
      ParamByName('ind_concluido').AsString := 'S'
    else
      ParamByName('ind_concluido').AsString := 'N';

    ExecSQL;
  end;
end;

function TdmGlobal.TreinosMes(dt: TDateTime): integer;
begin
  with qryConsEstatistica do
  begin
    Active := False;
    SQL.Clear;
    SQL.Add('SELECT id_historico FROM tab_atividade_historico');
    SQL.Add('WHERE dt_atividade >= :dt1');
    SQL.Add('AND dt_atividade <= :dt2');

    ParamByName('dt1').AsString := FormatDateTime('yyyy-mm-dd', StartOfTheMonth(dt));
    ParamByName('dt2').AsString := FormatDateTime('yyyy-mm-dd', EndOfTheMonth(dt));

    Open;

    Result := RecordCount;
  end
end;

procedure TdmGlobal.TreinoSugerido(dt: TDateTime);
begin
  with qryConsEstatistica do
  begin
    Active := False;
    SQL.Clear;
    SQL.Add('SELECT * FROM tab_treino_exercicio');
    SQL.Add('WHERE dia_semana = :dia_semana');

    ParamByName('dia_semana').AsInteger := DayOfWeek(dt);

    Open;
  end;
end;

function TdmGlobal.Pontuacao: integer;
begin
  with qryConsEstatistica do
  begin
    Active := False;
    SQL.Clear;
    SQL.Add('SELECT IFNULL(pontos, 0) AS pontos FROM tab_usuario');

    Open;

    Result := FieldByName('pontos').AsInteger;
  end;
end;

end.
