unit dat.cadProdutosFornecedores;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaFornecedor(XId: integer): TJSONObject;
function RetornaListaFornecedores(const XQuery: TDictionary<string, string>; XIdProduto: integer): TJSONArray;
function IncluiFornecedor(XFornecedor: TJSONObject; XIdProduto: integer): TJSONObject;
function AlteraFornecedor(XIdFornecedor: integer; XFornecedor: TJSONObject): TJSONObject;
function ApagaFornecedor(XIdFornecedor: integer): TJSONObject;
function VerificaRequisicao(XFornecedor: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaFornecedor(XId: integer): TJSONObject;
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
         SQL.Add('select  "CodigoInternoProdutoFornecedor"    as id,');
         SQL.Add('        "CodigoProdutoProdutoFornecedor"    as idproduto,');
         SQL.Add('        "CodigoFornecedorProdutoFornecedor" as idfornecedor,');
         SQL.Add('        "CodigoFabricaProdutoFornecedor"    as codfabrica,');
         SQL.Add('        "UnidadeFabricaProdutoFornecedor"   as undfabrica,');
         SQL.Add('        "FatorFabricaProdutoFornecedor"     as fatorfabrica ');
         SQL.Add('from "ProdutoFornecedor" ');
         SQL.Add('where "CodigoInternoProdutoFornecedor"=:xid ');
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
        wret.AddPair('description','Nenhum Produto Fornecedor encontrado');
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

function RetornaListaFornecedores(const XQuery: TDictionary<string, string>; XIdProduto: integer): TJSONArray;
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
         SQL.Add('select  "CodigoInternoProdutoFornecedor"    as id,');
         SQL.Add('        "CodigoProdutoProdutoFornecedor"    as idproduto,');
         SQL.Add('        "CodigoFornecedorProdutoFornecedor" as idfornecedor,');
         SQL.Add('        "CodigoFabricaProdutoFornecedor"    as codfabrica,');
         SQL.Add('        "UnidadeFabricaProdutoFornecedor"   as undfabrica,');
         SQL.Add('        "FatorFabricaProdutoFornecedor"     as fatorfabrica ');
         SQL.Add('from "ProdutoFornecedor" where "CodigoProdutoProdutoFornecedor"=:xidproduto ');
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
         wobj.AddPair('description','Nenhum Produto Fornecedor encontrado');
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

function IncluiFornecedor(XFornecedor: TJSONObject; XIdProduto: integer): TJSONObject;
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
           SQL.Add('Insert into "ProdutoFornecedor"("CodigoProdutoProdutoFornecedor","CodigoFornecedorProdutoFornecedor",');
           SQL.Add('"CodigoFabricaProdutoFornecedor","UnidadeFabricaProdutoFornecedor","FatorFabricaProdutoFornecedor") ');
           SQL.Add('values (:xidproduto,:xidfornecedor,:xcodfabrica,:xundfabrica,:xfatorfabrica) ');
           ParamByName('xidproduto').AsInteger    := XIdProduto;
           if XFornecedor.TryGetValue('idfornecedor',wval) then
              ParamByName('xidfornecedor').AsInteger := strtointdef(XFornecedor.GetValue('idfornecedor').Value,0)
           else
              ParamByName('xidfornecedor').AsInteger := 0;
           if XFornecedor.TryGetValue('codfabrica',wval) then
              ParamByName('xcodfabrica').AsString    := XFornecedor.GetValue('codfabrica').Value
           else
              ParamByName('xcodfabrica').AsString    := '';
           if XFornecedor.TryGetValue('undfabrica',wval) then
              ParamByName('xundfabrica').AsString    := XFornecedor.GetValue('undfabrica').Value
           else
              ParamByName('xundfabrica').AsString    := '';
           if XFornecedor.TryGetValue('fatorfabrica',wval) then
              ParamByName('xfatorfabrica').AsFloat   := strtofloatdef(XFornecedor.GetValue('fatorfabrica').Value,0)
           else
              ParamByName('xfatorfabrica').AsFloat   := 0;
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
                SQL.Add('select  "CodigoInternoProdutoFornecedor"    as id,');
                SQL.Add('        "CodigoProdutoProdutoFornecedor"    as idproduto,');
                SQL.Add('        "CodigoFornecedorProdutoFornecedor" as idfornecedor,');
                SQL.Add('        "CodigoFabricaProdutoFornecedor"    as codfabrica,');
                SQL.Add('        "UnidadeFabricaProdutoFornecedor"   as undfabrica,');
                SQL.Add('        "FatorFabricaProdutoFornecedor"     as fatorfabrica ');
                SQL.Add('from "ProdutoFornecedor" where "CodigoProdutoProdutoFornecedor"=:xidproduto and "CodigoFornecedorProdutoFornecedor"=:xidfornecedor ');
                ParamByName('xidproduto').AsInteger     := XIdProduto;
                if XFornecedor.TryGetValue('idfornecedor',wval) then
                   ParamByName('xidfornecedor').AsInteger := strtointdef(XFornecedor.GetValue('idfornecedor').Value,0)
                else
                   ParamByName('xidfornecedor').AsInteger := 0;
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Produto Fornecedor incluído');
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

function AlteraFornecedor(XIdFornecedor: integer; XFornecedor: TJSONObject): TJSONObject;
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
    if XFornecedor.TryGetValue('idfornecedor',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoFornecedorProdutoFornecedor"=:xidfornecedor'
         else
            wcampos := wcampos+',"CodigoFornecedorProdutoFornecedor"=:xidfornecedor';
       end;
    if XFornecedor.TryGetValue('codfabrica',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoFabricaProdutoFornecedor"=:xcodfabrica'
         else
            wcampos := wcampos+',"CodigoFabricaProdutoFornecedor"=:xcodfabrica';
       end;
    if XFornecedor.TryGetValue('undfabrica',wval) then
       begin
         if wcampos='' then
            wcampos := '"UnidadeFabricaProdutoFornecedor"=:xundfabrica'
         else
            wcampos := wcampos+',"UnidadeFabricaProdutoFornecedor"=:xundfabrica';
       end;
    if XFornecedor.TryGetValue('fatorfabrica',wval) then
       begin
         if wcampos='' then
            wcampos := '"FatorFabricaProdutoFornecedor"=:xfatorfabrica'
         else
            wcampos := wcampos+',"FatorFabricaProdutoFornecedor"=:xfatorfabrica';
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
           SQL.Add('Update "ProdutoFornecedor" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoProdutoFornecedor"=:xid ');
           ParamByName('xid').AsInteger              := XIdFornecedor;
           if XFornecedor.TryGetValue('idfornecedor',wval) then
              ParamByName('xidfornecedor').AsInteger := strtointdef(XFornecedor.GetValue('idfornecedor').Value,0);
           if XFornecedor.TryGetValue('codfabrica',wval) then
              ParamByName('xcodfabrica').AsString    := XFornecedor.GetValue('codfabrica').Value;
           if XFornecedor.TryGetValue('undfabrica',wval) then
              ParamByName('xundfabrica').AsString    := XFornecedor.GetValue('undfabrica').Value;
           if XFornecedor.TryGetValue('fatorfabrica',wval) then
              ParamByName('xfatorfabrica').AsFloat   := strtofloatdef(XFornecedor.GetValue('fatorfabrica').Value,0);
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
              SQL.Add('select  "CodigoInternoProdutoFornecedor"    as id,');
              SQL.Add('        "CodigoProdutoProdutoFornecedor"    as idproduto,');
              SQL.Add('        "CodigoFornecedorProdutoFornecedor" as idfornecedor,');
              SQL.Add('        "CodigoFabricaProdutoFornecedor"    as codfabrica,');
              SQL.Add('        "UnidadeFabricaProdutoFornecedor"   as undfabrica,');
              SQL.Add('        "FatorFabricaProdutoFornecedor"     as fatorfabrica ');
              SQL.Add('from "ProdutoFornecedor" ');
              SQL.Add('where "CodigoInternoProdutoFornecedor" =:xid ');
              ParamByName('xid').AsInteger := XIdFornecedor;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Produto Fornecedor alterado');
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

function VerificaRequisicao(XFornecedor: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XFornecedor.TryGetValue('idfornecedor',wval) then
       wret := false;
  finally
  end;
  Result := wret;
end;

function ApagaFornecedor(XIdFornecedor: integer): TJSONObject;
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
         SQL.Add('delete from "ProdutoFornecedor" where "CodigoInternoProdutoFornecedor"=:xid ');
         ParamByName('xid').AsInteger := XIdFornecedor;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Produto Fornecedor excluído com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhum Produto Fornecedor excluído');
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
