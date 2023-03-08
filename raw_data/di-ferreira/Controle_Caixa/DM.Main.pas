unit DM.Main;

interface

uses
{(*}
  System.SysUtils,
  System.Classes,
  Vcl.Forms,
  Vcl.Controls,
  Data.DB,
  Bcrypt,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Stan.Async,
  FireDAC.DApt,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  DTO.Usuario,
  Manager.Types,
  Controle.Caixa.Controller.Manager,
  Controle.Caixa.Controller.Manager.Interfaces;
{*)}

type
  TtpCaixa = (TODOS, ENTRADA, SAIDA);

  TDMMain = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
  private
    FUsuario: TUsuario;
    FControllerManager: iControllerManager;
  public
    currentUser: TUsuario;
    function UserLogin(User, Password: string): Boolean;
    function EnumToText(const pEnum: TtpCaixa): string;
  end;

var
  DMMain: TDMMain;
  FormLogin, FormMain: TForm;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses
  uMain, uLogin;
{$R *.dfm}
{ TDMMain }

procedure TDMMain.DataModuleCreate(Sender: TObject);
begin
  FControllerManager := TControllerManager.New;
end;

function TDMMain.EnumToText(const pEnum: TtpCaixa): string;
const
  cResults: array[TtpCaixa] of string =( { TODOS } 'Todos',
    { ENTRADA } 'Entrada', { SAIDA } 'Saída');
begin
  Result := cResults[pEnum];
end;

function TDMMain.UserLogin(User, Password: string): Boolean;
var
  CheckPass: Boolean;
begin
  Result := false;

  FUsuario := FControllerManager.Usuario.FindAll.Where('NOME', tpFilterOperator.Eq, User).UniqueResult;

  CheckPass := TBCrypt.CheckPassword(Password, FUsuario.SENHA, CheckPass);

  if FUsuario.ID <= 0 then
  begin
    exit;
  end;

  if CheckPass then
  begin
    currentUser := FUsuario;
    Result := True;
  end;
end;

end.

