unit DataMod;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.MySQLDef, Vcl.Menus, IniFiles,
  FireDAC.VCLUI.Wait, FireDAC.Comp.UI;

type
  TUDataMod = class(TDataModule)
    FDPhysMySQLDriverLink: TFDPhysMySQLDriverLink;
    FDManager: TFDManager;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    procedure DataModuleCreate(Sender: TObject);
  private
    FHTTPport  : integer;    // port de ghttp
    FMaxSize   : integer;    // taille maxi des fichiers en reception
    FMaxConnections : Integer;
    FServer    : string;
    FUser_Name : string;
    FDatabase  : string;
    FPassword  : string;
    FDriverID  : string;
    FHeartBeat : Integer;  // en minutes
    procedure LoadIni;
    { Déclarations privées }
  public
    { Déclarations publiques }
    function getNewConnexion: TFDConnection;
    property Server      : string  read FServer    write Fserver;
    property User_name   : string  read FUser_Name write FUser_name;
    property Database    : string  read FDatabase  write FDatabase;
    property Password    : string  read FPassword  write FPassword;
    property DriverID    : string  read FDriverID  write FDriverID;
    property HTTPPort    : Integer read FHTTPPort  write FHTTPPort;
    property MaxSize     : Integer read FMaxSize   write FMaxSize;
    property MaxConnections : Integer read FMaxConnections   write FMaxConnections;
    property HeartBeat      : Integer read FHeartBeat        write FHeartBeat;
  end;

var
  UDataMod: TUDataMod;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

function TUDataMod.getNewConnexion: TFDConnection;
var
  tc : Cardinal ;
begin
  try
    Result := TFDConnection.Create(nil);
    Result.ConnectionDefName := 'MONITOR' ;
    Result.Connected := true ;
  except
    on E:Exception do
    begin
      if Assigned(result) then
      begin
        result.DisposeOf ;
        result := nil ;
      end;
      raise ;
    end;
  end;
end;



procedure TUDataMod.LoadIni;
var Ini:TIniFile;
begin
//  Log_Write('LoadIni', el_Info);
//  Log_Write(VAR_GLOB.Exe_Directory + , el_Info);
    Ini := TIniFile.Create(ChangeFileExt(paramstr(0), '.ini'));
    try
       HeartBeat  := Ini.ReadInteger('HTTP','HeartBeat',5);;
       HTTPPort   := Ini.ReadInteger('HTTP','Port',8080);;
       MaxSize    := Ini.ReadInteger('HTTP','MaxSize',50000);;
       MaxConnections := Ini.ReadInteger('HTTP','MaxConnections',50);;
       Server     := Ini.ReadString('DATABASE','Server','');
       User_name  := Ini.ReadString('DATABASE','user_name','');
       password   := Ini.ReadString('DATABASE','password','');
       Database   := Ini.ReadString('DATABASE','database','');
       DriverID   := Ini.ReadString('DATABASE','DriverID','');
    finally
       Ini.Free;
    end;
end;

procedure TUDataMod.DataModuleCreate(Sender: TObject);
var vParams : TStringList ;
begin
    LoadIni;
    vParams:= TStringList.Create;
    try
      FDPhysMySQLDriverLink.VendorLib := ExtractFilePath(ParamStr(0)) + 'libmysql.dll';
      vParams.Clear;
      vParams.Add('Server='    + Server) ;
      vParams.Add('Database='  + Database) ;
      vParams.Add('User_Name=' + User_name) ;
      vParams.Add('Password='  + password) ;
      vParams.Add('DriverID='  + DriverID) ;
      vParams.Add('Pooled=true');
      vParams.Add('POOL_MaximumItems=' + IntToStr(MaxConnections));
      FDManager.AddConnectionDef('MONITOR', 'MYSQL', vParams) ;
    finally
      vParams.DisposeOf;
    end;
end;

end.
