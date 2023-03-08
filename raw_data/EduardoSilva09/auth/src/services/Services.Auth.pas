unit Services.Auth;

interface

uses
  System.SysUtils, System.Classes, Providers.Connection, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.ConsoleUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet;

type
  TServiceAuth = class(TProvidersConnection)
    vQryLogin: TFDQuery;
    vQryLoginid: TLargeintField;
    vQryLoginsenha: TWideStringField;
  private
    { Private declarations }
  public
    function PermitirAcesso(const AUsuario, ASenha: string): Boolean;
  end;

var
  ServiceAuth: TServiceAuth;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}
{$R *.dfm}
{ TServiceAuth }

uses BCrypt;

function TServiceAuth.PermitirAcesso(const AUsuario, ASenha: string): Boolean;
begin
  vQryLogin.ParamByName('login').AsString := AUsuario;
  vQryLogin.Open();

  if vQryLogin.IsEmpty then
    Exit(False);

 Result := TBCrypt.CompareHash(ASenha, vQryLoginsenha.AsString);
end;

end.
