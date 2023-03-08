unit ClienteController;

interface

uses Firedac.Comp.Client, System.SysUtils, Firedac.DApt, FMX.Graphics, Classe.Conexao,
  ClienteModel;

type
  TClienteController = class

  private
    FConn : TConecta;


  public
    constructor Create();
    function NovoCliente(out erro : String; cliente : TPessoa): Boolean;
  end;

implementation

{ TEntrada }

uses uPrincipal, System.Classes, Data.DB, System.StrUtils;

constructor TClienteController.Create;
begin
  FConn := TConecta.Create;
end;

function TClienteController.NovoCliente(out erro : String; cliente : TPessoa): Boolean;
var
  qry : TFDQuery;
  SQL_, VALUES : String;
begin
  try
    qry            := TFDQuery.Create(nil);
    qry.Connection := FConn.Conectar;

    with qry do
    begin
      SQL_   := 'INSERT INTO PESSOA (flnatureza, dsdocumento, nmprimeiro, nmsegundo, dtregistro) ';
      VALUES := 'VALUES(:flnatureza, :dsdocumento, :nmprimeiro, :nmsegundo, :dtregistro)';

      SQL.Clear;
      SQL.Add(SQL_);
      SQL.Add(VALUES);
      ParamByName('flnatureza').Value  := cliente.FlNatureza;
      ParamByName('dsdocumento').Value := cliente.DsDocumento;
      ParamByName('nmprimeiro').Value  := cliente.NmPrimeiro;
      ParamByName('nmsegundo').Value   := cliente.NmSegundo;
      ParamByName('dtregistro').Value  := cliente.DtRegistro;
      ExecSQL();

      Result      := True;

      DisposeOf;
    end;
  except on ex : Exception do
   begin
     erro   := 'Erro ao inserir o cliente: ' + ex.Message;
     Result := False;
     frmPrincipal.Log(erro);
   end;
  end;
end;

end.
