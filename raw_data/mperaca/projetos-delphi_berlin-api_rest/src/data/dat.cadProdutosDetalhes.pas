unit dat.cadProdutosDetalhes;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaDetalhe(XId: integer): TJSONObject;
function RetornaListaDetalhes(const XQuery: TDictionary<string, string>; XIdProduto: integer): TJSONArray;
function IncluiDetalhe(XDetalhe: TJSONObject; XIdProduto: integer): TJSONObject;
function AlteraDetalhe(XIdDetalhe: integer; XDetalhe: TJSONObject): TJSONObject;
function ApagaDetalhe(XIdDetalhe: integer): TJSONObject;
function VerificaRequisicao(XDetalhe: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaDetalhe(XId: integer): TJSONObject;
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
         SQL.Add('select  "CodigoInternoProdutoDetalhe" as id,');
         SQL.Add('        "CodigoProdutoDetalhe"        as idproduto,');
         SQL.Add('        "PontoPedidoDetalhe"          as pontopedido,');
         SQL.Add('        "PontoMinimoDetalhe"          as pontominimo,');
         SQL.Add('        "PontoMaximoDetalhe"          as pontomaximo,');
         SQL.Add('        "LocalDetalhe"                as local,');
         SQL.Add('        "CaminhoFotoDetalhe"          as caminhofoto,');
         SQL.Add('        "ProdutoVisivelDetalhe"       as ehvisivel,');
         SQL.Add('        "DetalheProdutoDetalhe"       as detalhe ');
         SQL.Add('from "ProdutoDetalhe" ');
         SQL.Add('where "CodigoInternoProdutoDetalhe"=:xid ');
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
        wret.AddPair('description','Nenhum Produto Detalhe encontrado');
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
//      messagedlg('Problema ao retornar Atividade'+slinebreak+E.Message,mterror,[mbok],0);
    end;
  end;
  wconexao.EncerraConexaoDB;
  Result := wret;
end;

function RetornaListaDetalhes(const XQuery: TDictionary<string, string>; XIdProduto: integer): TJSONArray;
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
         SQL.Add('select  "CodigoInternoProdutoDetalhe" as id,');
         SQL.Add('        "CodigoProdutoDetalhe"        as idproduto,');
         SQL.Add('        "PontoPedidoDetalhe"          as pontopedido,');
         SQL.Add('        "PontoMinimoDetalhe"          as pontominimo,');
         SQL.Add('        "PontoMaximoDetalhe"          as pontomaximo,');
         SQL.Add('        "LocalDetalhe"                as local,');
         SQL.Add('        "CaminhoFotoDetalhe"          as caminhofoto,');
         SQL.Add('        "ProdutoVisivelDetalhe"       as ehvisivel,');
         SQL.Add('        "DetalheProdutoDetalhe"       as detalhe ');
         SQL.Add('from "ProdutoDetalhe" where "CodigoEmpresaDetalhe"=:xidempresa and "CodigoProdutoDetalhe"=:xidproduto ');
         ParamByName('xidempresa').AsInteger := wconexao.FIdEmpresaProduto;
         ParamByName('xidproduto').AsInteger := XIdProduto;
         Open;
         EnableControls;
       end;
    if wqueryLista.RecordCount>0 then
       wret := wqueryLista.ToJSONArray()
    else
       begin
         wobj := TJSONObject.Create;
         wobj.AddPair('status','500');
         wobj.AddPair('description','Nenhum Produto Detalhe encontrado');
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
//      messagedlg('Problema ao retorna listas de Atividades'+slinebreak+E.Message,mterror,[mbok],0);
    end;
  end;
  wconexao.EncerraConexaoDB;
  Result := wret;
//  wquery.Free;
end;

function IncluiDetalhe(XDetalhe: TJSONObject; XIdProduto: integer): TJSONObject;
var wquery: TFDMemTable;
    wqueryInsert,wquerySelect: TFDQuery;
    wret: TJSONObject;
    wnum: integer;
    wconexao: TProviderDataModuleConexao;
    wval: string;
begin
  try
    wconexao     := TProviderDataModuleConexao.Create(nil);
    wqueryInsert := TFDQuery.Create(nil);
    if wconexao.EstabeleceConexaoDB then
       begin
         with wqueryInsert do
         begin
           Connection := wconexao.FDConnectionApi;
           DisableControls;
           Close;
           SQL.Clear;
           Params.Clear;
           SQL.Add('Insert into "ProdutoDetalhe"("CodigoProdutoDetalhe","CodigoEmpresaDetalhe","PontoPedidoDetalhe","PontoMinimoDetalhe","PontoMaximoDetalhe",');
           SQL.Add('"LocalDetalhe","CaminhoFotoDetalhe","ProdutoVisivelDetalhe","DetalheProdutoDetalhe") ');
           SQL.Add('values (:xidproduto,:xidempresa,:xpontopedido,:xpontominimo,:xpontomaximo,');
           SQL.Add(':xlocal,:xcaminhofoto,:xehvisivel,:xdetalhe) ');
           ParamByName('xidproduto').AsInteger    := XIdProduto;
           ParamByName('xidempresa').AsInteger    := wconexao.FIdEmpresaProduto;
           if XDetalhe.TryGetValue('pontopedido',wval) then
              ParamByName('xpontopedido').AsFloat := strtofloatdef(XDetalhe.GetValue('pontopedido').Value,0)
           else
              ParamByName('xpontopedido').AsFloat := 0;
           if XDetalhe.TryGetValue('pontominimo',wval) then
              ParamByName('xpontominimo').AsFloat := strtofloatdef(XDetalhe.GetValue('pontominimo').Value,0)
           else
              ParamByName('xpontominimo').AsFloat := 0;
           if XDetalhe.TryGetValue('pontomaximo',wval) then
              ParamByName('xpontomaximo').AsFloat := strtofloatdef(XDetalhe.GetValue('pontomaximo').Value,0)
           else
              ParamByName('xpontomaximo').AsFloat := 0;
           if XDetalhe.TryGetValue('local',wval) then
              ParamByName('xlocal').AsString := XDetalhe.GetValue('local').Value
           else
              ParamByName('xlocal').AsString := '';
           if XDetalhe.TryGetValue('caminhofoto',wval) then
              ParamByName('xcaminhofoto').AsString := XDetalhe.GetValue('caminhofoto').Value
           else
              ParamByName('xcaminhofoto').AsString := '';
           if XDetalhe.TryGetValue('ehvisivel',wval) then
              ParamByName('xehvisivel').AsBoolean := strtobooldef(XDetalhe.GetValue('ehvisivel').Value,true)
           else
              ParamByName('xehvisivel').AsBoolean := true;
           if XDetalhe.TryGetValue('detalhe',wval) then
              ParamByName('xdetalhe').AsString := XDetalhe.GetValue('detalhe').Value
           else
              ParamByName('xdetalhe').AsString := '';
           ExecSQL;
           EnableControls;
           wnum := RowsAffected;
         end;
         if wnum>0 then
            begin
              wquerySelect := TFDQuery.Create(nil);
              with wquerySelect do
              begin
                Connection := wconexao.FDConnectionApi;
                DisableControls;
                Close;
                SQL.Clear;
                Params.Clear;
                SQL.Add('select  "CodigoInternoProdutoDetalhe" as id,');
                SQL.Add('        "CodigoProdutoDetalhe"        as idproduto,');
                SQL.Add('        "PontoPedidoDetalhe"          as pontopedido,');
                SQL.Add('        "PontoMinimoDetalhe"          as pontominimo,');
                SQL.Add('        "PontoMaximoDetalhe"          as pontomaximo,');
                SQL.Add('        "LocalDetalhe"                as local,');
                SQL.Add('        "CaminhoFotoDetalhe"          as caminhofoto,');
                SQL.Add('        "ProdutoVisivelDetalhe"       as ehvisivel,');
                SQL.Add('        "DetalheProdutoDetalhe"       as detalhe ');
                SQL.Add('from "ProdutoDetalhe" where "CodigoEmpresaDetalhe"=:xidempresa and "CodigoProdutoDetalhe"=:xidproduto ');
                ParamByName('xidproduto').AsInteger     := XIdProduto;
                ParamByName('xidempresa').AsInteger     := wconexao.FIdEmpresaProduto;
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Produto Detalhe incluído');
              wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
            end;
        end;
  except
    On E: Exception do
    begin
      wconexao.EncerraConexaoDB;
      wret := TJSONObject.Create;
      wret.AddPair('status','500');
      wret.AddPair('description',E.Message);
      wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
//      messagedlg('Problema ao incluir nova Atividade'+slinebreak+E.Message,mterror,[mbok],0);
    end;
  end;
  wconexao.EncerraConexaoDB;
  Result := wret;
//  wquery.Free;
end;

function AlteraDetalhe(XIdDetalhe: integer; XDetalhe: TJSONObject): TJSONObject;
var wquery: TFDMemTable;
    wqueryUpdate,wquerySelect: TFDQuery;
    wret: TJSONObject;
    wconexao: TProviderDataModuleConexao;
    wcampos,wval: string;
    wnum: integer;
begin
  try
    wcampos      := '';
    wconexao     := TProviderDataModuleConexao.Create(nil);
    wqueryUpdate := TFDQuery.Create(nil);
    //define quais campos serão alterados
    if XDetalhe.TryGetValue('pontopedido',wval) then
       begin
         if wcampos='' then
            wcampos := '"PontoPedidoDetalhe"=:xpontopedido'
         else
            wcampos := wcampos+',"PontoPedidoDetalhe"=:xpontopedido';
       end;
    if XDetalhe.TryGetValue('pontominimo',wval) then
       begin
         if wcampos='' then
            wcampos := '"PontoMinimoDetalhe"=:xpontominimo'
         else
            wcampos := wcampos+',"PontoMinimoDetalhe"=:xpontominimo';
       end;
    if XDetalhe.TryGetValue('pontomaximo',wval) then
       begin
         if wcampos='' then
            wcampos := '"PontoMaximoDetalhe"=:xpontomaximo'
         else
            wcampos := wcampos+',"PontoMaximoDetalhe"=:xpontomaximo';
       end;
    if XDetalhe.TryGetValue('local',wval) then
       begin
         if wcampos='' then
            wcampos := '"LocalDetalhe"=:xlocal'
         else
            wcampos := wcampos+',"LocalDetalhe"=:xlocal';
       end;
    if XDetalhe.TryGetValue('caminhofoto',wval) then
       begin
         if wcampos='' then
            wcampos := '"CaminhoFotoDetalhe"=:xcaminhofoto'
         else
            wcampos := wcampos+',"CaminhoFotoDetalhe"=:xcaminhofoto';
       end;
    if XDetalhe.TryGetValue('ehvisivel',wval) then
       begin
         if wcampos='' then
            wcampos := '"ProdutoVisivelDetalhe"=:xehvisivel'
         else
            wcampos := wcampos+',"ProdutoVisivelDetalhe"=:xehvisivel';
       end;
    if XDetalhe.TryGetValue('detalhe',wval) then
       begin
         if wcampos='' then
            wcampos := '"DetalheProdutoDetalhe"=:xdetalhe'
         else
            wcampos := wcampos+',"DetalheProdutoDetalhe"=:xdetalhe';
       end;

    if wconexao.EstabeleceConexaoDB then
       begin
         with wqueryUpdate do
         begin
           Connection := wconexao.FDConnectionApi;
           DisableControls;
           Close;
           SQL.Clear;
           Params.Clear;
           SQL.Add('Update "ProdutoDetalhe" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoProdutoDetalhe"=:xid ');
           ParamByName('xid').AsInteger       := XIdDetalhe;
           if XDetalhe.TryGetValue('pontopedido',wval) then
              ParamByName('xpontopedido').AsFloat := strtofloatdef(XDetalhe.GetValue('pontopedido').Value,0);
           if XDetalhe.TryGetValue('pontominimo',wval) then
              ParamByName('xpontominimo').AsFloat := strtofloatdef(XDetalhe.GetValue('pontominimo').Value,0);
           if XDetalhe.TryGetValue('pontomaximo',wval) then
              ParamByName('xpontomaximo').AsFloat := strtofloatdef(XDetalhe.GetValue('pontomaximo').Value,0);
           if XDetalhe.TryGetValue('local',wval) then
              ParamByName('xlocal').AsString      := XDetalhe.GetValue('local').Value;
           if XDetalhe.TryGetValue('caminhofoto',wval) then
              ParamByName('xcaminhofoto').AsString  := XDetalhe.GetValue('caminhofoto').Value;
           if XDetalhe.TryGetValue('ehvisivel',wval) then
              ParamByName('xehvisivel').AsBoolean := strtobooldef(XDetalhe.GetValue('ehvisivel').Value,true);
           if XDetalhe.TryGetValue('detalhe',wval) then
              ParamByName('xdetalhe').AsString  := XDetalhe.GetValue('detalhe').Value;
           ExecSQL;
           EnableControls;
           wnum := RowsAffected;
         end;
         wquerySelect := TFDQuery.Create(nil);
         if wnum>0 then
            with wquerySelect do
            begin
              Connection := wconexao.FDConnectionApi;
              DisableControls;
              Close;
              SQL.Clear;
              Params.Clear;
              SQL.Add('select  "CodigoInternoProdutoDetalhe" as id,');
              SQL.Add('        "CodigoProdutoDetalhe"        as idproduto,');
              SQL.Add('        "PontoPedidoDetalhe"          as pontopedido,');
              SQL.Add('        "PontoMinimoDetalhe"          as pontominimo,');
              SQL.Add('        "PontoMaximoDetalhe"          as pontomaximo,');
              SQL.Add('        "LocalDetalhe"                as local,');
              SQL.Add('        "CaminhoFotoDetalhe"          as caminhofoto,');
              SQL.Add('        "ProdutoVisivelDetalhe"       as ehvisivel,');
              SQL.Add('        "DetalheProdutoDetalhe"       as detalhe ');
              SQL.Add('from "ProdutoDetalhe" ');
              SQL.Add('where "CodigoInternoProdutoDetalhe" =:xid ');
              ParamByName('xid').AsInteger := XIdDetalhe;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Produto Detalhe alterado');
              wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
            end;
       end;
    wret   := wquerySelect.ToJSONObject();
  except
    On E: Exception do
    begin
      wconexao.EncerraConexaoDB;
      wret := TJSONObject.Create;
      wret.AddPair('status','500');
      wret.AddPair('description',E.Message);
      wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
//      messagedlg('Problema ao alterar Atividade'+slinebreak+E.Message,mterror,[mbok],0);
    end;
  end;
  wconexao.EncerraConexaoDB;
  Result := wret;
//  wquery.Free;
end;

function VerificaRequisicao(XDetalhe: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
//    if not XCor.TryGetValue('idcor',wval) then
//       wret := false;
  finally
  end;
  Result := wret;
end;

function ApagaDetalhe(XIdDetalhe: integer): TJSONObject;
var wret: TJSONObject;
    wconexao: TProviderDataModuleConexao;
    wqueryDelete: TFDQuery;
    wnum: integer;
begin
  try
    wret         := TJSONObject.Create;
    wconexao     := TProviderDataModuleConexao.Create(nil);
    wqueryDelete := TFDQuery.Create(nil);

    if wconexao.EstabeleceConexaoDB then
       with wqueryDelete do
       begin
         Connection := wconexao.FDConnectionApi;
         DisableControls;
         Close;
         SQL.Clear;
         Params.Clear;
         SQL.Add('delete from "ProdutoDetalhe" where "CodigoInternoProdutoDetalhe"=:xid ');
         ParamByName('xid').AsInteger := XIdDetalhe;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Produto Detalhe excluído com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhum Produto Detalhe excluído');
       end;
    wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
  except
    On E: Exception do
    begin
      wconexao.EncerraConexaoDB;
      wret.AddPair('status','500');
      wret.AddPair('description',E.Message);
      wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
//      messagedlg('Problema ao excluir Atividade'+slinebreak+E.Message,mterror,[mbok],0);
    end;
  end;
  wconexao.EncerraConexaoDB;
  Result := wret;
end;
end.
