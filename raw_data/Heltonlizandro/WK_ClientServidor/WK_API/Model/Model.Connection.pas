unit Model.Connection;

interface

uses
  FireDAC.DApt, FireDAC.Stan.Option, FireDAC.Stan.Intf, FireDAC.UI.Intf,
  FireDAC.Stan.Error, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client,

  FireDAC.Phys.FB, FireDAC.Phys.FBDef, System.Classes,

  System.IniFiles, System.SysUtils;

var
    FConnection : TFDConnection;

function SetupConnection(FConn: TFDConnection): String;
function Connect : TFDConnection;
procedure Disconect;

implementation

function SetupConnection(FConn: TFDConnection): string;
var
    arq_ini : string;
    ini : TIniFile;
begin
    try
        try
            arq_ini := GetCurrentDir + '\Server.ini';

            // Verifica se INI existe...
            if NOT FileExists(arq_ini) then
            begin
                Result := 'Arquivo INI não encontrado: ' + arq_ini;
                exit;
            end;

            // Instanciar arquivo INI...
            ini := TIniFile.Create(arq_ini);

            // Buscar dados do arquivo fisico...
            FConn.Params.Values['DriverID'] := ini.ReadString('Banco de Dados', 'DriverID', '');
            FConn.Params.Values['Database'] := ini.ReadString('Banco de Dados', 'Database', '');
            FConn.Params.Values['User_name'] := ini.ReadString('Banco de Dados', 'User_name', '');
            FConn.Params.Values['Password'] := ini.ReadString('Banco de Dados', 'Password', '');
            FConn.Params.Add('Port=' + ini.ReadString('Banco de Dados', 'Port', '3050'));
            FConn.Params.Add('Server=' + ini.ReadString('Banco de Dados', 'Server', 'localhost'));

            Result := 'OK';
        except on ex:exception do
            Result := 'Erro ao configurar banco: ' + ex.Message;
        end;

    finally
        if Assigned(ini) then
            ini.DisposeOf;
    end;
end;

function Connect : TFDConnection;
begin
    FConnection := TFDConnection.Create(nil);
    SetupConnection(FConnection);
    FConnection.Connected := true;

    Result := FConnection;
end;

procedure Disconect;
begin
    if Assigned(FConnection) then
    begin
        if FConnection.Connected then
            FConnection.Connected := false;

        FConnection.Free;
    end;

end;


end.
