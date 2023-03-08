unit dat.cadProdutosExcedentes;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaExcedente(XId: integer): TJSONObject;
function RetornaListaExcedentes(const XQuery: TDictionary<string, string>; XIdProduto: integer): TJSONArray;
function IncluiExcedente(XExcedente: TJSONObject; XIdProduto: integer): TJSONObject;
function AlteraExcedente(XIdExcedente: integer; XExcedente: TJSONObject): TJSONObject;
function ApagaExcedente(XIdExcedente: integer): TJSONObject;
function VerificaRequisicao(XExcedente: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaExcedente(XId: integer): TJSONObject;
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
         SQL.Add('select  "CodigoInternoExcedente"     as id,');
         SQL.Add('        "CodigoProdutoExcedente"     as idproduto,');
         SQL.Add('        "QuantidadeExcedente"        as quantidade,');
         SQL.Add('        "CodigoOrcamentoExcedente"   as idorcamento,');
         SQL.Add('        "CodigoProdutoItemExcedente" as iditem,');
         SQL.Add('        "DataUtilizacaoExcedente"    as datautilizacao ');
         SQL.Add('from "ProdutoExcedente" ');
         SQL.Add('where "CodigoInternoExcedente"=:xid ');
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
        wret.AddPair('description','Nenhum Produto Excedente encontrado');
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

function RetornaListaExcedentes(const XQuery: TDictionary<string, string>; XIdProduto: integer): TJSONArray;
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
         SQL.Add('select  "CodigoInternoExcedente"     as id,');
         SQL.Add('        "CodigoProdutoExcedente"     as idproduto,');
         SQL.Add('        "QuantidadeExcedente"        as quantidade,');
         SQL.Add('        "CodigoOrcamentoExcedente"   as idorcamento,');
         SQL.Add('        "CodigoProdutoItemExcedente" as iditem,');
         SQL.Add('        "DataUtilizacaoExcedente"    as datautilizacao ');
         SQL.Add('from "ProdutoExcedente" where "CodigoProdutoExcedente"=:xidproduto ');
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
         wobj.AddPair('description','Nenhum Produto Excedente encontrado');
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

function IncluiExcedente(XExcedente: TJSONObject; XIdProduto: integer): TJSONObject;
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
           SQL.Add('Insert into "ProdutoExcedente"("CodigoProdutoExcedente","QuantidadeExcedente","CodigoOrcamentoExcedente","CodigoProdutoItemExcedente","DataUtilizacaoExcedente") ');
           SQL.Add('values (:xidproduto,:xquantidade,:xidorcamento,:xiditem,:xdatautilizacao) ');
           ParamByName('xidproduto').AsInteger    := XIdProduto;
           if XExcedente.TryGetValue('quantidade',wval) then
              ParamByName('xquantidade').AsFloat := strtofloatdef(XExcedente.GetValue('quantidade').Value,0)
           else
              ParamByName('xquantidade').AsFloat := 0;
           if XExcedente.TryGetValue('idorcamento',wval) then
              ParamByName('xidorcamento').AsInteger := strtointdef(XExcedente.GetValue('idorcamento').Value,0)
           else
              ParamByName('xidorcamento').AsInteger := 0;
           if XExcedente.TryGetValue('iditem',wval) then
              ParamByName('xiditem').AsInteger := strtointdef(XExcedente.GetValue('iditem').Value,0)
           else
              ParamByName('xiditem').AsInteger := 0;
           if XExcedente.TryGetValue('datautilizacao',wval) then
              ParamByName('xdatautilizacao').AsDate := strtointdef(XExcedente.GetValue('datautilizacao').Value,0)
           else
              ParamByName('xdatautilizacao').AsDate := 0;
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
                SQL.Add('select  "CodigoInternoExcedente"     as id,');
                SQL.Add('        "CodigoProdutoExcedente"     as idproduto,');
                SQL.Add('        "QuantidadeExcedente"        as quantidade,');
                SQL.Add('        "CodigoOrcamentoExcedente"   as idorcamento,');
                SQL.Add('        "CodigoProdutoItemExcedente" as iditem,');
                SQL.Add('        "DataUtilizacaoExcedente"    as datautilizacao ');
                SQL.Add('from "ProdutoExcedente" where "CodigoProdutoExcedente"=:xidproduto and "CodigoProdutoItemExcedente"=:xiditem ');
                ParamByName('xidproduto').AsInteger     := XIdProduto;
                if XExcedente.TryGetValue('iditem',wval) then
                   ParamByName('xiditem').AsInteger := strtointdef(XExcedente.GetValue('iditem').Value,0)
                else
                   ParamByName('xiditem').AsInteger := 0;
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Produto Excedente incluído');
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

function AlteraExcedente(XIdExcedente: integer; XExcedente: TJSONObject): TJSONObject;
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
    if XExcedente.TryGetValue('quantidade',wval) then
       begin
         if wcampos='' then
            wcampos := '"QuantidadeExcedente"=:xquantidade'
         else
            wcampos := wcampos+',"QuantidadeExcedente"=:xquantidade';
       end;
    if XExcedente.TryGetValue('idorcamento',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoOrcamentoExcedente"=:xidorcamento'
         else
            wcampos := wcampos+',"CodigoOrcamentoExcedente"=:xidorcamento';
       end;
    if XExcedente.TryGetValue('iditem',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoProdutoItemExcedente"=:xiditem'
         else
            wcampos := wcampos+',"CodigoProdutoItemExcedente"=:xiditem';
       end;
    if XExcedente.TryGetValue('datautilizacao',wval) then
       begin
         if wcampos='' then
            wcampos := '"DataUtilizacaoExcedente"=:xdatautilizacao'
         else
            wcampos := wcampos+',"DataUtilizacaoExcedente"=:xdatautilizacao';
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
           SQL.Add('Update "ProdutoExcedente" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoExcedente"=:xid ');
           ParamByName('xid').AsInteger              := XIdExcedente;
           if XExcedente.TryGetValue('quantidade',wval) then
              ParamByName('xquantidade').AsFloat     := strtofloatdef(XExcedente.GetValue('quantidade').Value,0);
           if XExcedente.TryGetValue('idorcamento',wval) then
              ParamByName('xidorcamento').AsInteger  := strtointdef(XExcedente.GetValue('idorcamento').Value,0);
           if XExcedente.TryGetValue('iditem',wval) then
              ParamByName('xiditem').AsInteger       := strtointdef(XExcedente.GetValue('iditem').Value,0);
           if XExcedente.TryGetValue('datautilizacao',wval) then
              ParamByName('xdatautilizacao').AsDate  := strtodatedef(XExcedente.GetValue('datautilizacao').Value,0);
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
              SQL.Add('select  "CodigoInternoExcedente"     as id,');
              SQL.Add('        "CodigoProdutoExcedente"     as idproduto,');
              SQL.Add('        "QuantidadeExcedente"        as quantidade,');
              SQL.Add('        "CodigoOrcamentoExcedente"   as idorcamento,');
              SQL.Add('        "CodigoProdutoItemExcedente" as iditem,');
              SQL.Add('        "DataUtilizacaoExcedente"    as datautilizacao ');
              SQL.Add('from "ProdutoExcedente" ');
              SQL.Add('where "CodigoInternoExcedente" =:xid ');
              ParamByName('xid').AsInteger := XIdExcedente;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Produto Excedente alterado');
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

function VerificaRequisicao(XExcedente: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XExcedente.TryGetValue('quantidade',wval) then
       wret := false;
  finally
  end;
  Result := wret;
end;

function ApagaExcedente(XIdExcedente: integer): TJSONObject;
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
         SQL.Add('delete from "ProdutoExcedente" where "CodigoInternoExcedente"=:xid ');
         ParamByName('xid').AsInteger := XIdExcedente;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Produto Excedente excluído com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhum Produto Excedente excluído');
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
