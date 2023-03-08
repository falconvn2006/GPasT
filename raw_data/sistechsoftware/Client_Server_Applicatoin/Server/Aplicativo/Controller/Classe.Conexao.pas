unit Classe.Conexao;

interface

uses FireDAC.Stan.Intf, System.SysUtils, IniFiles,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG;

type
 TConecta = class
   private
     FUserName   :String;
     FPassword   :String;
     FDatabase   :String;
     FDriverID   :String;
     FVendorLib  :String;
     FConectar   :TFDConnection;
    function LoadConfig: String;
   public
     property UserName  : String        read FUserName  write FUserName;
     property Password  : String        read FPassword  write FPassword;
     property Database  : String        read FDatabase  write FDatabase;
     property DriverID  : String        read FDriverID  write FDriverID;
     property VendorLib : String        read FVendorLib write FVendorLib;
     property Conectar  : TFDConnection read FConectar  write FConectar;

     procedure GerarArquivoConexao(Banco, Localizacao, Comando: String);
     function LerArqConfig(Banco, Localizacao, Comando: String): String;
     function ContarRegistros(SetTabela : String):Integer;

     constructor Create; overload;
 end;

implementation

uses
  Vcl.Dialogs;

{ TConecta }
function TConecta.ContarRegistros(SetTabela: String): Integer;
var conn : TConecta;
    Qry  : TFDQuery;
begin
  conn := TConecta.Create;
  Qry  := TFDQuery.Create(nil);
  try
    with Qry do
    begin
      Connection := conn.Conectar;
      SQL.Clear;
      SQL.Add('select * from '+SetTabela);
      Open;
      Result     := RecordCount;
    end;
  finally
    conn.Free;
    Qry.Free;
  end;
end;

constructor TConecta.Create;
var
 pg : TFDPhysPGDriverLink;
begin
  conectar := TFDConnection.Create(nil);
  pg       := TFDPhysPGDriverLink.Create(nil);
  LoadConfig();

//  try
//    conectar.Connected := True;
//  except on e: Exception do
//    begin
//        ShowMessage('Falha ao conectar na base de dados!' + #13 + e.Message + 'ERRO NA CONEXÃO');
//        conectar.Free;
//        pg.Free;
//        exit
//    end;
//  end;
end;

procedure TConecta.GerarArquivoConexao(Banco, Localizacao, Comando: String);
var 
	Arq : Tinifile; caminho: string;
begin
  caminho := ParamStr(0);
  caminho := ExtractFilePath(caminho);
  Arq     := TIniFile.Create(caminho+'Config\Conexao.dat');
  
  try
    if not Arq.ValueExists(Banco,Localizacao) then
     Arq.WriteString(Banco, Localizacao, Comando);
  finally
    Arq.Free;
  end;
end;

function TConecta.LerArqConfig(Banco, Localizacao, Comando: String): String;
var 
	Arq : Tinifile; caminho: string;
begin
  caminho := ParamStr(0);
  caminho := ExtractFilePath(caminho);

  Arq := TIniFile.Create(caminho + 'Config\Conexao.dat');
  try
    if Arq.ValueExists(Banco,Localizacao) then
     Result := Arq.ReadString(Banco, Localizacao, Comando)
    else
    begin
      if not FileExists(caminho + 'Config/Conexao.dat') then
      begin
        if not DirectoryExists(caminho + 'Config/')then
        begin
          ForceDirectories(caminho + 'Config/');
        end;
      end;
      GerarArquivoConexao(Banco, Localizacao, Comando);
    end;
  finally
    Arq.Free;
  end;
end;

function TConecta.LoadConfig() : String;
var
 arq_ini, base, usuario, senha, driver : String;
 ini : TIniFile;
begin
  try
    arq_ini := System.SysUtils.GetCurrentDir + '..\..\Config\Config.ini';

    if not FileExists(arq_ini) then
    begin
      Result := 'Arquivo INI não encontrado: ' + arq_ini;

      Exit;
    end;

    ini := TIniFile.Create(arq_ini);

    base    := ini.ReadString('Banco de Dados', 'Database', 'db_wk_teste');
    usuario := ini.ReadString('Banco de Dados', 'User_Name','posgres');
    senha   := ini.ReadString('Banco de Dados', 'Password', 'sistech');
    driver  := ini.ReadString('Banco de Dados', 'DriverID', 'PG');

    conectar.Params.Clear;
    conectar.Params.Values['DriverID']  := driver;
    conectar.Params.Values['Database']  := base;
    conectar.Params.Values['User_Name'] := usuario;
    conectar.Params.Values['Password']  := senha;

    try
      conectar.Connected := True;

      Result := 'OK';
    except on Ex : Exception do
      Result := 'Erro ao conectar com o banco de dados: ' + Ex.Message;
    end;
  finally
    ini.DisposeOf;
  end;
end;

end.
