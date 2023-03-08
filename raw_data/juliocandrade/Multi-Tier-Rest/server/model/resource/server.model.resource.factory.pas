unit server.model.resource.factory;
interface
uses
  server.model.resource.interfaces;
type
  TResourceFactory = class(TInterfacedObject, iResourceFactory)
  public
    class function New : iResourceFactory;
    function Query(aConexao : iConexao) : iQuery;
    function Conexao : iConexao;
    function Rest : iRest;
  end;
implementation
uses
  server.model.resource.Config,
  server.model.resource.conexao.conexaofiredac,
  server.model.resource.conexao.queryfiredac,
  server.model.resource.rest.delphirestclient;
{ TResourceFactory }
function TResourceFactory.Conexao: iConexao;
begin
  Result := TConexaoFiredac.New(TResourceConfig.Database);
end;
class function TResourceFactory.New: iResourceFactory;
begin
  Result := Self.Create;
end;

function TResourceFactory.Query(aConexao : iConexao): iQuery;
begin
  Result := TQueryFiredac.New(aConexao);
end;
function TResourceFactory.Rest: iRest;
begin
  Result := TDelphiRestClient.New;
end;

end.
