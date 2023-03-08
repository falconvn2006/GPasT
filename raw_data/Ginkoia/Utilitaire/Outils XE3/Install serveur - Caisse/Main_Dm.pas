unit Main_Dm;

interface

uses
  Winapi.Windows,
  System.SysUtils, System.Classes, Registry,
  // Début Uses Perso
  uRessourcestr,
  // Fin Uses Perso
  Vcl.ImgList, Vcl.Controls,
  FireDAC.Stan.Def,
  FireDAC.Stan.Async,
  FireDAC.Stan.Error,
  FireDAC.Phys.IB,
  FireDAC.DApt,
  FireDAC.VCLUI.Wait,
  FireDAC.Comp.Client, FireDAC.Phys.IBWrapper, System.ImageList;

type
  TDm_Main = class(TDataModule)
    img_List: TImageList;
    ImgListLng: TImageList;
  private
    { Déclarations privées }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetVersionIBServeur(sServeur: string): string;
    function GetVersionIBClient: string;
    function GetVersionIBLocal: string;
  end;

var
  Dm_Main: TDm_Main;
  //Log: TLogFile;

implementation

{ %CLASSGROUP 'Vcl.Controls.TControl' }

{$R *.dfm}
{ TDm_Main }

constructor TDm_Main.Create(AOwner: TComponent);
begin
  inherited;

  //Log := TLogFile.Create;
end;

destructor TDm_Main.Destroy;
begin
  //Log.Free;

  inherited;
end;

function TDm_Main.GetVersionIBClient: string;
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;
  try
    reg.Access := KEY_READ;
    reg.RootKey := HKEY_LOCAL_MACHINE;
    reg.OpenKey('\Software\Borland\Interbase\CurrentVersion', False);
    Result := reg.ReadString('Version');
  finally
    FreeAndNil(reg);
  end;
end;

function TDm_Main.GetVersionIBLocal: string;
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;
  try
    reg.Access := KEY_READ;
    reg.RootKey := HKEY_LOCAL_MACHINE;
    reg.OpenKey('\Software\Borland\Interbase\CurrentVersion', False);
    Result := reg.ReadString('Version');
    if Result = '' then
    begin
      reg.OpenKey('\Software\Borland\Interbase\Servers', False);
      Result := reg.ReadString('Version');
    end;
    if Result = '' then
    begin
      reg.OpenKey('\Software\Borland\Interbase\Servers\gds_db', False);
      Result := reg.ReadString('Version');
    end;
  finally
    FreeAndNil(reg);
  end;
end;

function TDm_Main.GetVersionIBServeur(sServeur: string): string;
var
  // tmp : TIBServerProperties;
  tmp: TFDConnection;
begin
  tmp := TFDConnection.Create(nil);
  try
    // tmp.Active := False;
    tmp.ConnectionName := sServeur;
    tmp.Params.Clear;
    tmp.Params.Add('user_name=' + IBAdminUser);
    tmp.Params.Add('password=' + IBAdminPwd);
    // tmp.Protocol := TCP;
    // tmp.ServerType := 'IBServer';

    tmp.Params.Add('Protocol=TCPIP');
    tmp.Params.Add('DriverID=IB');
    tmp.LoginPrompt := False;
    tmp.StartTransaction;
    // tmp.FetchVersionInfo;
    // Result := tmp.VersionInfo.ServerVersion;
    // Result := tmp.ResourceOptions.Version;
  finally
    FreeAndNil(tmp);
  end;
end;

end.
