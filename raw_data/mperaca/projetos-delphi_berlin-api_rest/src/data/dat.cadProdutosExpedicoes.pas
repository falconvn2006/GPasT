unit dat.cadProdutosExpedicoes;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaExpedicao(XId: integer): TJSONObject;
function RetornaListaExpedicoes(const XQuery: TDictionary<string, string>; XIdProduto: integer): TJSONArray;
function IncluiExpedicao(XExpedicao: TJSONObject; XIdProduto: integer): TJSONObject;
function AlteraExpedicao(XIdExpedicao: integer; XExpedicao: TJSONObject): TJSONObject;
function ApagaExpedicao(XIdExpedicao: integer): TJSONObject;
function VerificaRequisicao(XExpedicao: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaExpedicao(XId: integer): TJSONObject;
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
         SQL.Add('select  "CodigoInternoProdutoExpedicao"      as id,');
         SQL.Add('        "CodigoProdutoExpedicao"             as idproduto,');
         SQL.Add('        "CodigoNotaItemProdutoExpedicao"     as idnota,');
         SQL.Add('        "SituacaoNotaItemProdutoExpedicao"   as situacao,');
         SQL.Add('        "QuantidadeVendidaProdutoExpedicao"  as qtdvendida,');
         SQL.Add('        "QuantidadeExpedidaProdutoExpedicao" as qtdexpedida ');
         SQL.Add('from "ProdutoExpedicao" ');
         SQL.Add('where "CodigoInternoProdutoExpedicao"=:xid ');
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
        wret.AddPair('description','Nenhum Produto Expedição encontrado');
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

function RetornaListaExpedicoes(const XQuery: TDictionary<string, string>; XIdProduto: integer): TJSONArray;
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
         SQL.Add('select  "CodigoInternoProdutoExpedicao"      as id,');
         SQL.Add('        "CodigoProdutoExpedicao"             as idproduto,');
         SQL.Add('        "CodigoNotaItemProdutoExpedicao"     as idnota,');
         SQL.Add('        "SituacaoNotaItemProdutoExpedicao"   as situacao,');
         SQL.Add('        "QuantidadeVendidaProdutoExpedicao"  as qtdvendida,');
         SQL.Add('        "QuantidadeExpedidaProdutoExpedicao" as qtdexpedida ');
         SQL.Add('from "ProdutoExpedicao" where "CodigoProdutoExpedicao"=:xidproduto ');
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
         wobj.AddPair('description','Nenhum Produto Expedição encontrado');
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

function IncluiExpedicao(XExpedicao: TJSONObject; XIdProduto: integer): TJSONObject;
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
           SQL.Add('Insert into "ProdutoExpedicao"("CodigoEmpresaProdutoExpedicao","CodigoProdutoExpedicao","CodigoNotaItemProdutoExpedicao",');
           SQL.Add('"SituacaoNotaItemProdutoExpedicao","QuantidadeVendidaProdutoExpedicao","QuantidadeExpedidaProdutoExpedicao") ');
           SQL.Add('values (:xidempresa,:xidproduto,(case when :xidnota>0 then :xidnota else null end),');
           SQL.Add(':xsituacao,:xqtdvendida,:xqtdexpedida) ');
           ParamByName('xidempresa').AsInteger    := wconexao.FIdEmpresa;
           ParamByName('xidproduto').AsInteger    := XIdProduto;
           if XExpedicao.TryGetValue('idnota',wval) then
              ParamByName('xidnota').AsInteger    := strtointdef(XExpedicao.GetValue('idnota').Value,0)
           else
              ParamByName('xidnota').AsInteger    := 0;
           if XExpedicao.TryGetValue('situacao',wval) then
              ParamByName('xsituacao').AsString   := XExpedicao.GetValue('situacao').Value
           else
              ParamByName('xsituacao').AsString   := '';
           if XExpedicao.TryGetValue('qtdvendida',wval) then
              ParamByName('xqtdvendida').AsFloat  := strtofloatdef(XExpedicao.GetValue('qtdvendida').Value,0)
           else
              ParamByName('xqtdvendida').AsFloat := 0;
           if XExpedicao.TryGetValue('qtdexpedida',wval) then
              ParamByName('xqtdexpedida').AsFloat  := strtofloatdef(XExpedicao.GetValue('qtdexpedida').Value,0)
           else
              ParamByName('xqtdexpedida').AsFloat := 0;
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
                SQL.Add('select  "CodigoInternoProdutoExpedicao"      as id,');
                SQL.Add('        "CodigoProdutoExpedicao"             as idproduto,');
                SQL.Add('        "CodigoNotaItemProdutoExpedicao"     as idnota,');
                SQL.Add('        "SituacaoNotaItemProdutoExpedicao"   as situacao,');
                SQL.Add('        "QuantidadeVendidaProdutoExpedicao"  as qtdvendida,');
                SQL.Add('        "QuantidadeExpedidaProdutoExpedicao" as qtdexpedida ');
                SQL.Add('from "ProdutoExpedicao" where "CodigoProdutoExpedicao"=:xidproduto ');
                ParamByName('xidproduto').AsInteger     := XIdProduto;
//                if XExpedicao.TryGetValue('idnota',wval) then
//                   ParamByName('xidnota').AsInteger    := strtointdef(XExpedicao.GetValue('idnota').Value,0)
//                else
//                   ParamByName('xidnota').AsInteger    := 0;
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Produto Expedição incluído');
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

function AlteraExpedicao(XIdExpedicao: integer; XExpedicao: TJSONObject): TJSONObject;
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
    if XExpedicao.TryGetValue('idnota',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoNotaItemProdutoExpedicao"=:xidnota'
         else
            wcampos := wcampos+',"CodigoNotaItemProdutoExpedicao"=:xidnota';
       end;
    if XExpedicao.TryGetValue('situacao',wval) then
       begin
         if wcampos='' then
            wcampos := '"SituacaoNotaItemProdutoExpedicao"=:xsituacao'
         else
            wcampos := wcampos+',"SituacaoNotaItemProdutoExpedicao"=:xsituacao';
       end;
    if XExpedicao.TryGetValue('qtdvendida',wval) then
       begin
         if wcampos='' then
            wcampos := '"QuantidadeVendidaProdutoExpedicao"=:xqtdvendida'
         else
            wcampos := wcampos+',"QuantidadeVendidaProdutoExpedicao"=:xqtdvendida';
       end;
    if XExpedicao.TryGetValue('qtdexpedida',wval) then
       begin
         if wcampos='' then
            wcampos := '"QuantidadeExpedidaProdutoExpedicao"=:xqtdexpedida'
         else
            wcampos := wcampos+',"QuantidadeExpedidaProdutoExpedicao"=:xqtdexpedida';
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
           SQL.Add('Update "ProdutoExpedicao" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoProdutoExpedicao"=:xid ');
           ParamByName('xid').AsInteger           := XIdExpedicao;
           if XExpedicao.TryGetValue('idnota',wval) then
              ParamByName('xidnota').AsInteger    := strtointdef(XExpedicao.GetValue('idnota').Value,0);
           if XExpedicao.TryGetValue('situacao',wval) then
              ParamByName('xsituacao').AsString   := XExpedicao.GetValue('situacao').Value;
           if XExpedicao.TryGetValue('qtdvendida',wval) then
              ParamByName('xqtdvendida').AsFloat  := strtofloatdef(XExpedicao.GetValue('qtdvendida').Value,0);
           if XExpedicao.TryGetValue('qtdexpedida',wval) then
              ParamByName('xqtdexpedida').AsFloat := strtofloatdef(XExpedicao.GetValue('qtdexpedida').Value,0);
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
              SQL.Add('select  "CodigoInternoProdutoExpedicao"      as id,');
              SQL.Add('        "CodigoProdutoExpedicao"             as idproduto,');
              SQL.Add('        "CodigoNotaItemProdutoExpedicao"     as idnota,');
              SQL.Add('        "SituacaoNotaItemProdutoExpedicao"   as situacao,');
              SQL.Add('        "QuantidadeVendidaProdutoExpedicao"  as qtdvendida,');
              SQL.Add('        "QuantidadeExpedidaProdutoExpedicao" as qtdexpedida ');
              SQL.Add('from "ProdutoExpedicao" ');
              SQL.Add('where "CodigoInternoProdutoExpedicao" =:xid ');
              ParamByName('xid').AsInteger := XIdExpedicao;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Produto Expedição alterado');
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

function VerificaRequisicao(XExpedicao: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
//    if not XExpedicao.TryGetValue('quantidade',wval) then
//       wret := false;
  finally
  end;
  Result := wret;
end;

function ApagaExpedicao(XIdExpedicao: integer): TJSONObject;
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
         SQL.Add('delete from "ProdutoExpedicao" where "CodigoInternoProdutoExpedicao"=:xid ');
         ParamByName('xid').AsInteger := XIdExpedicao;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Produto Expedição excluído com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhum Produto Expedição excluído');
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
