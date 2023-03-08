unit EnderecoController;

interface

uses Firedac.Comp.Client, System.SysUtils, Firedac.DApt, FMX.Graphics, Classe.Conexao,
  ClienteModel, EnderecoModel;

type
  TEnderecoController = class

  private
    FConn : TConecta;

  public
    constructor Create();
    function NovoEndereco(out erro : String; endereco : TEndereco): Boolean;
  end;

implementation

{ TEntrada }

uses uPrincipal, System.Classes, Data.DB, System.StrUtils;

constructor TEnderecoController.Create;
begin
  FConn := TConecta.Create;
end;

function TEnderecoController.NovoEndereco(out erro : String; endereco : TEndereco): Boolean;
var
  qry : TFDQuery;
  SQL_, VALUES : String;
begin
  try
    qry            := TFDQuery.Create(nil);
    qry.Connection := FConn.Conectar;

    with qry do
    begin
      SQL_   := 'INSERT INTO endereco (dscep, idpessoa) ';
      VALUES := 'VALUES(:dscep, :idpessoa)';

      SQL.Clear;
      SQL.Add(SQL_);
      SQL.Add(VALUES);
      ParamByName('dscep').Value    := endereco.DsCep;
      ParamByName('idpessoa').Value := 1;
      ExecSQL();

      Result      := True;

      DisposeOf;
    end;
  except on ex : Exception do
   begin
     erro   := 'Erro ao inserir o endereço: ' + ex.Message;
     Result := False;
     frmPrincipal.Log(erro);
   end;
  end;
end;

end.
