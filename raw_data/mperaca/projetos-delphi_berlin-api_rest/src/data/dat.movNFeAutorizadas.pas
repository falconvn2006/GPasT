unit dat.movNFeAutorizadas;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaNFeAutorizada(XId: integer): TJSONObject;
function RetornaListaNFeAutorizadas(const XQuery: TDictionary<string, string>): TJSONArray;

implementation

uses prv.dataModuleConexao;

function RetornaNFeAutorizada(XId: integer): TJSONObject;
var wquery: TFDQuery;
    wconexao: TProviderDataModuleConexao;
    wret: TJSONObject;
begin
  try
// cria provider de conexão com BD
    wconexao := TProviderDataModuleConexao.Create(nil);

    wquery   := TFDQuery.Create(nil);
    if wconexao.EstabeleceConexaoDB then
       with wquery do
       begin
         Connection := wconexao.FDConnectionApi;
         DisableControls;
         Close;
         SQL.Clear;
         Params.Clear;
         SQL.Add('select "CodigoInternoNota" as id,');
         SQL.Add('       "PedidoClienteNota"       as pedido,');
         SQL.Add('       "DataEmissaoNota"         as dataemissao, ');
         SQL.Add('       "TotalNota"               as total, ');
         SQL.Add('       ts_retornapessoanome("CodigoClienteNota") as cliente, ');
         SQL.Add('       "NumeroDocumentoNota"     as numdoc, ');
         SQL.Add('       "IdNFeNota"               as chave,');
         SQL.Add('       "SituacaoNota"            as situacao ');
         SQL.Add('from "NotaFiscal" where "CodigoInternoNota"=:xid and  ');
         SQL.Add('"ModuloOrigemNota"=''TS-Fature'' and "ModeloDocumentoFiscal"=''55'' and not("IdNFeNota" is null) ');
         ParamByName('xid').AsInteger := XId;
         Open;
         EnableControls;
       end;

   if wquery.RecordCount>0 then
      wret := wquery.ToJSONObject()
   else
      begin
        wret := TJSONObject.Create;
        wret.AddPair('status','500');
        wret.AddPair('description','Nenhuma nfe autorizada encontrada');
        wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
      end;

  except
    On E: Exception do
    begin
      wconexao.EncerraConexaoDB;
      wret := TJSONObject.Create;
      wret.AddPair('status','500');
      wret.AddPair('description',E.Message);
      wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
//      messagedlg('Problema ao retornar localidade'+slinebreak+E.Message,mterror,[mbok],0);
    end;
  end;
  wconexao.EncerraConexaoDB;
  Result := wret;
end;

function RetornaListaNFeAutorizadas(const XQuery: TDictionary<string, string>): TJSONArray;
var wqueryLista: TFDQuery;
    wconexao: TProviderDataModuleConexao;
    wobj: TJSONObject;
    wret: TJSONArray;
begin
  try
// cria provider de conexão com BD
    wconexao    := TProviderDataModuleConexao.Create(nil);
    wqueryLista := TFDQuery.Create(nil);

    if wconexao.EstabeleceConexaoDB then
       with wqueryLista do
       begin
         Connection := wconexao.FDConnectionApi;
         DisableControls;
         Close;
         SQL.Clear;
         Params.Clear;
         SQL.Add('select "CodigoInternoNota" as id,');
         SQL.Add('       "PedidoClienteNota"       as pedido,');
         SQL.Add('       "DataEmissaoNota"         as dataemissao, ');
         SQL.Add('       "TotalNota"               as total, ');
         SQL.Add('       ts_retornapessoanome("CodigoClienteNota") as cliente, ');
         SQL.Add('       "NumeroDocumentoNota"     as numdoc, ');
         SQL.Add('       "IdNFeNota"               as chave, ');
         SQL.Add('       "SituacaoNota"            as situacao ');
         SQL.Add('from "NotaFiscal" where "DataEmissaoNota"=current_date and ');
         SQL.Add('"ModuloOrigemNota"=''TS-Fature'' and "ModeloDocumentoFiscal"=''55'' and not("IdNFeNota" is null) ');

{         if XQuery.ContainsKey('nome') then // filtro por nome
            begin
              SQL.Add('and lower("NomeLocalidade")=lower(:xnome) ');
              ParamByName('xnome').AsString := XQuery.Items['nome'];
            end;
         if XQuery.ContainsKey('uf') then // filtro por uf
            begin
              SQL.Add('and lower("EstadoLocalidade")=lower(:xuf) ');
              ParamByName('xuf').AsString := XQuery.Items['uf'];
            end;
         if XQuery.ContainsKey('regiao') then // filtro por região
            begin
              SQL.Add('and lower("RegiaoLocalidade")=lower(:xregiao) ');
              ParamByName('xregiao').AsString := XQuery.Items['regiao'];
            end;
         if XQuery.ContainsKey('codibge') then // filtro por código ibge
            begin
              SQL.Add('and "CodigoLocalidade"=:xcodibge ');
              ParamByName('xcodibge').AsString := XQuery.Items['codibge'];
            end;}
         Open;
         EnableControls;
       end;
    if wqueryLista.RecordCount>0 then
       wret := wqueryLista.ToJSONArray()
    else
       begin
         wobj := TJSONObject.Create;
         wobj.AddPair('status','500');
         wobj.AddPair('description','Nenhuma nfe autorizada encontrada');
         wobj.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         wret := TJSONArray.Create;
         wret.AddElement(wobj);
       end;
  except
    On E: Exception do
    begin
      wconexao.EncerraConexaoDB;
      wobj := TJSONObject.Create;
      wobj.AddPair('status','500');
      wobj.AddPair('description',E.Message);
      wobj.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
      wret := TJSONArray.Create;
      wret.AddElement(wobj);
//      messagedlg('Problema ao retorna listas de localidades'+slinebreak+E.Message,mterror,[mbok],0);
    end;
  end;
  wconexao.EncerraConexaoDB;
  Result := wret;
//  wquery.Free;
end;

end.
