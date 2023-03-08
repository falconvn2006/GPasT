unit dat.cadProdutosElementosControles;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaElementoControle(XId: integer): TJSONObject;
function RetornaListaElementosControles(const XQuery: TDictionary<string, string>; XIdProduto: integer): TJSONArray;
function IncluiElementoControle(XElemento: TJSONObject; XIdProduto: integer): TJSONObject;
function AlteraElementoControle(XIdElemento: integer; XElemento: TJSONObject): TJSONObject;
function ApagaElemento(XIdElemento: integer): TJSONObject;
function VerificaRequisicao(XElemento: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaElementoControle(XId: integer): TJSONObject;
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
         SQL.Add('select  "CodigoInternoProdutoElementoControle"  as id,');
         SQL.Add('        "CodigoProdutoProdutoElementoControle"  as idproduto,');
         SQL.Add('        "CodigoElementoProdutoElementoControle" as idelemento,');
         SQL.Add('        "CodigoConteudoProdutoElementoControle" as idconteudo ');
         SQL.Add('from "ProdutoElementoControle" ');
         SQL.Add('where "CodigoInternoProdutoElementoControle"=:xid ');
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
        wret.AddPair('description','Nenhum Produto Elemento Controle encontrado');
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

function RetornaListaElementosControles(const XQuery: TDictionary<string, string>; XIdProduto: integer): TJSONArray;
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
         SQL.Add('select  "CodigoInternoProdutoElementoControle"  as id,');
         SQL.Add('        "CodigoProdutoProdutoElementoControle"  as idproduto,');
         SQL.Add('        "CodigoElementoProdutoElementoControle" as idelemento,');
         SQL.Add('        "CodigoConteudoProdutoElementoControle" as idconteudo ');
         SQL.Add('from "ProdutoElementoControle" where "CodigoProdutoProdutoElementoControle"=:xidproduto ');
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
         wobj.AddPair('description','Nenhum Produto Elemento Controle encontrado');
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

function IncluiElementoControle(XElemento: TJSONObject; XIdProduto: integer): TJSONObject;
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
           SQL.Add('Insert into "ProdutoElementoControle"("CodigoProdutoProdutoElementoControle","CodigoElementoProdutoElementoControle","CodigoConteudoProdutoElementoControle") ');
           SQL.Add('values (:xidproduto,(case when :xidelemento>0 then :xidelemento else null end),(case when :xidconteudo>0 then :xidconteudo else null end)) ');
           ParamByName('xidproduto').AsInteger    := XIdProduto;
           if XElemento.TryGetValue('idelemento',wval) then
              ParamByName('xidelemento').AsInteger := strtointdef(XElemento.GetValue('idelemento').Value,0)
           else
              ParamByName('xidelemento').AsInteger := 0;
           if XElemento.TryGetValue('idconteudo',wval) then
              ParamByName('xidconteudo').AsInteger := strtointdef(XElemento.GetValue('idconteudo').Value,0)
           else
              ParamByName('xidconteudo').AsInteger := 0;
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
                SQL.Add('select  "CodigoInternoProdutoElementoControle"  as id,');
                SQL.Add('        "CodigoProdutoProdutoElementoControle"  as idproduto,');
                SQL.Add('        "CodigoElementoProdutoElementoControle" as idelemento,');
                SQL.Add('        "CodigoConteudoProdutoElementoControle" as idconteudo ');
                SQL.Add('from "ProdutoElementoControle" where "CodigoProdutoProdutoElementoControle"=:xidproduto ');
                ParamByName('xidproduto').AsInteger     := XIdProduto;
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Produto Elemento Controle incluído');
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

function AlteraElementoControle(XIdElemento: integer; XElemento: TJSONObject): TJSONObject;
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
    if XElemento.TryGetValue('idelemento',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoElementoProdutoElementoControle"=:xidelemento'
         else
            wcampos := wcampos+',"CodigoElementoProdutoElementoControle"=:xidelemento';
       end;
    if XElemento.TryGetValue('idconteudo',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoConteudoProdutoElementoControle"=:xidconteudo'
         else
            wcampos := wcampos+',"CodigoConteudoProdutoElementoControle"=:xidconteudo';
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
           SQL.Add('Update "ProdutoElementoControle" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoProdutoElementoControle"=:xid ');
           ParamByName('xid').AsInteger            := XIdElemento;
           if XElemento.TryGetValue('idelemento',wval) then
              ParamByName('xidelemento').AsInteger := strtointdef(XElemento.GetValue('idelemento').Value,0);
           if XElemento.TryGetValue('idconteudo',wval) then
              ParamByName('xidconteudo').AsInteger := strtointdef(XElemento.GetValue('idconteudo').Value,0);
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
              SQL.Add('select  "CodigoInternoProdutoElementoControle"  as id,');
              SQL.Add('        "CodigoProdutoProdutoElementoControle"  as idproduto,');
              SQL.Add('        "CodigoElementoProdutoElementoControle" as idelemento,');
              SQL.Add('        "CodigoConteudoProdutoElementoControle" as idconteudo ');
              SQL.Add('from "ProdutoElementoControle" ');
              SQL.Add('where "CodigoInternoProdutoElementoControle" =:xid ');
              ParamByName('xid').AsInteger := XIdElemento;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Produto Elemento Controle alterado');
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

function VerificaRequisicao(XElemento: TJSONObject): boolean;
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

function ApagaElemento(XIdElemento: integer): TJSONObject;
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
         SQL.Add('delete from "ProdutoElementoControle" where "CodigoInternoProdutoElementoControle"=:xid ');
         ParamByName('xid').AsInteger := XIdElemento;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Produto Elemento Controle excluído com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhum Produto Elemento Controle excluído');
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
