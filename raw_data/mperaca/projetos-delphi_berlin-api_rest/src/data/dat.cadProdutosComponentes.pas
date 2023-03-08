unit dat.cadProdutosComponentes;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaComponente(XId: integer): TJSONObject;
function RetornaListaComponentes(const XQuery: TDictionary<string, string>; XIdProduto: integer): TJSONArray;
function IncluiComponente(XComponente: TJSONObject; XIdProduto: integer): TJSONObject;
function AlteraComponente(XIdComponente: integer; XComponente: TJSONObject): TJSONObject;
function ApagaComponente(XIdComponente: integer): TJSONObject;
function VerificaRequisicao(XComponente: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaComponente(XId: integer): TJSONObject;
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
         SQL.Add('select "CodigoInternoProdutoComponente" as id,');
         SQL.Add('       "CodigoProdutoComponente"        as idproduto,');
         SQL.Add('       "CodigoProdutoMestre"            as idprodutomestre,');
         SQL.Add('       "QuantidadeProdutoComponente"    as quantidade ');
         SQL.Add('from "ProdutoComponente" ');
         SQL.Add('where "CodigoInternoProdutoComponente"=:xid ');
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
        wret.AddPair('description','Nenhum Produto Componente encontrado');
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

function RetornaListaComponentes(const XQuery: TDictionary<string, string>; XIdProduto: integer): TJSONArray;
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
         SQL.Add('select "CodigoInternoProdutoComponente" as id,');
         SQL.Add('       "CodigoProdutoComponente"        as idproduto,');
         SQL.Add('       "CodigoProdutoMestre"            as idprodutomestre,');
         SQL.Add('       "QuantidadeProdutoComponente"    as quantidade ');
         SQL.Add('from "ProdutoComponente" where "CodigoProdutoComponente"=:xidproduto ');
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
         wobj.AddPair('description','Nenhum Produto Componente encontrado');
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

function IncluiComponente(XComponente: TJSONObject; XIdProduto: integer): TJSONObject;
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
           SQL.Add('Insert into "ProdutoComponente"("CodigoProdutoComponente","CodigoProdutoMestre","QuantidadeProdutoComponente") ');
           SQL.Add('values (:xidproduto,:xidprodutomestre,:xquantidade) ');
           ParamByName('xidproduto').AsInteger         := XIdProduto;
           if XComponente.TryGetValue('idprodutomestre',wval) then
              ParamByName('xidprodutomestre').AsInteger     := strtointdef(XComponente.GetValue('idprodutomestre').Value,0)
           else
              ParamByName('xidprodutomestre').AsInteger     := 0;
           if XComponente.TryGetValue('quantidade',wval) then
              ParamByName('xquantidade').AsFloat            := strtofloatdef(XComponente.GetValue('quantidade').Value,0)
           else
              ParamByName('xquantidade').AsFloat            := 0;
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
                SQL.Add('select "CodigoInternoProdutoComponente" as id,');
                SQL.Add('       "CodigoProdutoComponente"        as idproduto,');
                SQL.Add('       "CodigoProdutoMestre"            as idprodutomestre,');
                SQL.Add('       "QuantidadeProdutoComponente"    as quantidade ');
                SQL.Add('from "ProdutoComponente" where "CodigoProdutoComponente"=:xidproduto and "CodigoProdutoMestre"=:xidprodutomestre ');
                ParamByName('xidproduto').AsInteger     := XIdProduto;
                if XComponente.TryGetValue('idprodutomestre',wval) then
                   ParamByName('xidprodutomestre').AsInteger     := strtointdef(XComponente.GetValue('idprodutomestre').Value,0)
                else
                   ParamByName('xidprodutomestre').AsInteger     := 0;
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Produto Componente incluído');
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

function AlteraComponente(XIdComponente: integer; XComponente: TJSONObject): TJSONObject;
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
    if XComponente.TryGetValue('idprodutomestre',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoProdutoMestre"=:xidprodutomestre'
         else
            wcampos := wcampos+',"CodigoProdutoMestre"=:xidprodutomestre';
       end;
    if XComponente.TryGetValue('quantidade',wval) then
       begin
         if wcampos='' then
            wcampos := '"QuantidadeProdutoComponente"=:xquantidade'
         else
            wcampos := wcampos+',"QuantidadeProdutoComponente"=:xquantidade';
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
           SQL.Add('Update "ProdutoComponente" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoProdutoComponente"=:xid ');
           ParamByName('xid').AsInteger                 := XIdComponente;
           if XComponente.TryGetValue('idprodutomestre',wval) then
              ParamByName('xidprodutomestre').AsInteger := strtointdef(XComponente.GetValue('idprodutomestre').Value,0);
           if XComponente.TryGetValue('quantidade',wval) then
              ParamByName('xquantidade').AsFloat        := strtofloatdef(XComponente.GetValue('quantidade').Value,0);
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
              SQL.Add('select "CodigoInternoProdutoComponente" as id,');
              SQL.Add('       "CodigoProdutoComponente"        as idproduto,');
              SQL.Add('       "CodigoProdutoMestre"            as idprodutomestre,');
              SQL.Add('       "QuantidadeProdutoComponente"    as quantidade ');
              SQL.Add('from "ProdutoComponente" ');
              SQL.Add('where "CodigoInternoProdutoComponente" =:xid ');
              ParamByName('xid').AsInteger := XIdComponente;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Produto Componente alterado');
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

function VerificaRequisicao(XComponente: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XComponente.TryGetValue('idprodutomestre',wval) then
       wret := false;
    if not XComponente.TryGetValue('quantidade',wval) then
       wret := false;
  finally
  end;
  Result := wret;
end;

function ApagaComponente(XIdComponente: integer): TJSONObject;
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
         SQL.Add('delete from "ProdutoComponente" where "CodigoInternoProdutoComponente"=:xid ');
         ParamByName('xid').AsInteger := XIdComponente;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Produto Componente excluído com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhum Produto Componente excluído');
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
