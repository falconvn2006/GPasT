unit DataModule.Global;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.FMXUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.FB, FireDAC.Phys.FBDef,
  FireDAC.Phys.IBBase, DataSet.Serialize.Config, System.JSON,
  DataSet.Serialize, FireDAC.DApt;

type
  TDmGlobal = class(TDataModule)
    Conn: TFDConnection;
    FDPhysFBDriverLink1: TFDPhysFBDriverLink;
    procedure DataModuleCreate(Sender: TObject);
    procedure ConnBeforeConnect(Sender: TObject);
  private
    procedure CarregarConfigDB(Connection: TFDConnection);
  public
    function Login(email, senha: string): TJSONObject;
    function CriarConta(nome, email, senha: string): TJSONObject;
    function EditarUsuario(idUsuario: Integer; nome, email: string):TJSONObject;
    function EditarSenha(idUsuario: Integer; senha: string):TJSONObject;
    function ListarTreinos(idUsuario: integer):TJSONArray;
  end;

var
  DmGlobal: TDmGlobal;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

{ TDmGlobal }

procedure TDmGlobal.CarregarConfigDB(Connection: TFDConnection);
begin
  Connection.DriverName := 'FB';

  with Connection.Params do
  begin
    Clear;
    Add('DriverID=FB');
    Add('Database=C:\Users\Diego\Documents\WorkSpace\Bodyfit\ServidorHorse\DB\BANCO.FDB');
    Add('User_Name=SYSDBA');
    Add('Password=masterkey');
    Add('Port=3050');
    Add('Server=localhost');
    Add('Protocol=TCPIP');
  end;
  FDPhysFBDriverLink1.VendorLib := 'C:\Program Files (x86)\Firebird\Firebird_4_0\fbclient.dll';
end;

procedure TDmGlobal.ConnBeforeConnect(Sender: TObject);
begin
  CarregarConfigDB(Conn);
end;

function TDmGlobal.CriarConta(nome, email, senha: string): TJSONObject;
var
  qry: TFDQuery;
begin
  if(nome.IsEmpty) or (email.IsEmpty) or (senha.IsEmpty)then
    raise Exception.Create('Informe o nome, e-mail e a senha');

  qry := TFDQuery.Create(nil);
  try
    qry.Connection := Conn;

    with qry do
    begin
      Close;
      SQL.Clear;
      SQL.Add('INSERT INTO tab_usuario(nome, email, senha)');
      SQL.Add('VALUES(:nome, :email, :senha)');
      SQL.Add('RETURNING id_usuario, nome, email');

      ParamByName('email').AsString := email;
      ParamByName('senha').AsString := senha;
      ParamByName('nome').AsString  := nome;

      Open;
    end;

    Result := qry.ToJSONObject;
  finally
    FreeAndNil(qry);
  end;
end;

procedure TDmGlobal.DataModuleCreate(Sender: TObject);
begin
  TDataSetSerializeConfig.GetInstance.CaseNameDefinition := cndLower;
  TDataSetSerializeConfig.GetInstance.Import.DecimalSeparator := '.';

  Conn.Connected := true;
end;

function TDmGlobal.EditarSenha(idUsuario: Integer; senha: string): TJSONObject;
var
  qry: TFDQuery;
begin
  if(idUsuario <= 0) or (senha.IsEmpty)then
    raise Exception.Create('Informe o id_usuario e a senha');
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := Conn;

    with qry do
    begin
      Close;
      SQL.Clear;
      SQL.Add('UPDATE tab_usuario SET');
      SQL.Add(' senha = :senha');
      SQL.Add('WHERE id_usuario = :id_usuario');
      SQL.Add('RETURNING id_usuario');

      ParamByName('senha').AsString := senha;
      ParamByName('id_usuario').AsInteger := idUsuario;

      Open;
    end;

    Result := qry.ToJSONObject;
  finally
    FreeAndNil(qry);
  end;
end;

function TDmGlobal.EditarUsuario(idUsuario: Integer; nome,
  email: string): TJSONObject;
var
  qry: TFDQuery;
begin
  if(idUsuario <= 0) or (nome.IsEmpty) or (email.IsEmpty)then
    raise Exception.Create('Informe o id_usuario, e-mail e a senha');
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := Conn;

    with qry do
    begin
      Close;
      SQL.Clear;
      SQL.Add('UPDATE tab_usuario SET');
      SQL.Add(' nome = :nome');
      SQL.Add(',email = :email');
      SQL.Add('WHERE id_usuario = :id_usuario');
      SQL.Add('RETURNING id_usuario');

      ParamByName('nome').AsString  := nome;
      ParamByName('email').AsString := email;
      ParamByName('id_usuario').AsInteger := idUsuario;

      Open;
    end;

    Result := qry.ToJSONObject;
  finally
    FreeAndNil(qry);
  end;
end;

function TDmGlobal.ListarTreinos(idUsuario: integer): TJSONArray;
var
  qry: TFDQuery;
begin
  if(idUsuario <= 0)then
    raise Exception.Create('Informe o id_usuario');
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := Conn;

    with qry do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT  t.id_treino, t.nome treino, t.descricao descr_treino, t.dia_semana,');
      SQL.Add('        e.id_exercicio,e.nome exercicio, e.descricao descr_exercicio, e.url_video, te.duracao');
      SQL.Add('FROM  tab_treino t');
      SQL.Add('JOIN  tab_treino_exercicio te on (te.id_treino = t.id_treino)');
      SQL.Add('JOIN  tab_exercicio e on (e.id_exercicio = te.id_exercicio)');
      SQL.Add('WHERE t.id_usuario = :id_usuario');
      SQL.Add('ORDER BY t.dia_semana, e.nome');

      ParamByName('id_usuario').AsInteger := idUsuario;

      Open;
    end;

    Result := qry.ToJSONArray;
  finally
    FreeAndNil(qry);
  end;
end;

function TDmGlobal.Login(email, senha: string): TJSONObject;
var
  qry: TFDQuery;
begin
  if(email.IsEmpty) or (senha.IsEmpty)then
    raise Exception.Create('Informe o e-mail e a senha');
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := Conn;

    with qry do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT id_usuario, nome, email');
      SQL.Add('FROM tab_usuario');
      SQL.Add('WHERE email = :email and senha = :senha');

      ParamByName('email').AsString := email;
      ParamByName('senha').AsString := senha;

      Open;
    end;

    Result := qry.ToJSONObject;
  finally
    FreeAndNil(qry);
  end;
end;

end.
