unit dat.cadProdutosDescontos;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaDesconto(XId: integer): TJSONObject;
function RetornaListaDescontos(const XQuery: TDictionary<string, string>; XIdProduto: integer): TJSONArray;
function IncluiDesconto(XDesconto: TJSONObject; XIdProduto: integer): TJSONObject;
function AlteraDesconto(XIdDesconto: integer; XDesconto: TJSONObject): TJSONObject;
function ApagaDesconto(XIdDesconto: integer): TJSONObject;
function VerificaRequisicao(XDesconto: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaDesconto(XId: integer): TJSONObject;
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
         SQL.Add('select  "CodigoInternoProdutoDesconto" as id,');
         SQL.Add('        "CodigoProdutoDesconto"        as idproduto,');
         SQL.Add('        "PrimeiroDescontoProduto"      as primeirodesconto,');
         SQL.Add('        "SegundoDescontoProduto"       as segundodesconto,');
         SQL.Add('        "TerceiroDescontoProduto"      as terceirodesconto,');
         SQL.Add('        "QuartoDescontoProduto"        as quartodesconto ');
         SQL.Add('from "ProdutoDesconto" ');
         SQL.Add('where "CodigoInternoProdutoDesconto"=:xid ');
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
        wret.AddPair('description','Nenhum Produto Desconto encontrado');
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

function RetornaListaDescontos(const XQuery: TDictionary<string, string>; XIdProduto: integer): TJSONArray;
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
         SQL.Add('select  "CodigoInternoProdutoDesconto" as id,');
         SQL.Add('        "CodigoProdutoDesconto"        as idproduto,');
         SQL.Add('        "PrimeiroDescontoProduto"      as primeirodesconto,');
         SQL.Add('        "SegundoDescontoProduto"       as segundodesconto,');
         SQL.Add('        "TerceiroDescontoProduto"      as terceirodesconto,');
         SQL.Add('        "QuartoDescontoProduto"        as quartodesconto ');
         SQL.Add('from "ProdutoDesconto" where "CodigoProdutoDesconto"=:xidproduto ');
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
         wobj.AddPair('description','Nenhum Produto Desconto encontrado');
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

function IncluiDesconto(XDesconto: TJSONObject; XIdProduto: integer): TJSONObject;
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
           SQL.Add('Insert into "ProdutoDesconto"("CodigoProdutoDesconto","PrimeiroDescontoProduto","SegundoDescontoProduto","TerceiroDescontoProduto","QuartoDescontoProduto") ');
           SQL.Add('values (:xidproduto,:xprimeirodesconto,:xsegundodesconto,:xterceirodesconto,:xquartodesconto) ');
           ParamByName('xidproduto').AsInteger    := XIdProduto;
           if XDesconto.TryGetValue('primeirodesconto',wval) then
              ParamByName('xprimeirodesconto').AsFloat     := strtofloatdef(XDesconto.GetValue('primeirodesconto').Value,0)
           else
              ParamByName('xprimeirodesconto').AsFloat     := 0;
           if XDesconto.TryGetValue('segundodesconto',wval) then
              ParamByName('xsegundodesconto').AsFloat     := strtofloatdef(XDesconto.GetValue('segundodesconto').Value,0)
           else
              ParamByName('xsegundodesconto').AsFloat     := 0;
           if XDesconto.TryGetValue('terceirodesconto',wval) then
              ParamByName('xterceirodesconto').AsFloat     := strtofloatdef(XDesconto.GetValue('terceirodesconto').Value,0)
           else
              ParamByName('xterceirodesconto').AsFloat     := 0;
           if XDesconto.TryGetValue('quartodesconto',wval) then
              ParamByName('xquartodesconto').AsFloat     := strtofloatdef(XDesconto.GetValue('quartodesconto').Value,0)
           else
              ParamByName('xquartodesconto').AsFloat     := 0;
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
                SQL.Add('select  "CodigoInternoProdutoDesconto" as id,');
                SQL.Add('        "CodigoProdutoDesconto"        as idproduto,');
                SQL.Add('        "PrimeiroDescontoProduto"      as primeirodesconto,');
                SQL.Add('        "SegundoDescontoProduto"       as segundodesconto,');
                SQL.Add('        "TerceiroDescontoProduto"      as terceirodesconto,');
                SQL.Add('        "QuartoDescontoProduto"        as quartodesconto ');
                SQL.Add('from "ProdutoDesconto" where "CodigoProdutoDesconto"=:xidproduto ');
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
              wret.AddPair('description','Nenhum Produto Desconto incluído');
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

function AlteraDesconto(XIdDesconto: integer; XDesconto: TJSONObject): TJSONObject;
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
    if XDesconto.TryGetValue('primeirodesconto',wval) then
       begin
         if wcampos='' then
            wcampos := '"PrimeiroDescontoProduto"=:xprimeirodesconto'
         else
            wcampos := wcampos+',"PrimeiroDescontoProduto"=:xprimeirodesconto';
       end;
    if XDesconto.TryGetValue('segundodesconto',wval) then
       begin
         if wcampos='' then
            wcampos := '"SegundoDescontoProduto"=:xsegundodesconto'
         else
            wcampos := wcampos+',"SegundoDescontoProduto"=:xsegundodesconto';
       end;
    if XDesconto.TryGetValue('terceirodesconto',wval) then
       begin
         if wcampos='' then
            wcampos := '"TerceiroDescontoProduto"=:xterceirodesconto'
         else
            wcampos := wcampos+',"TerceiroDescontoProduto"=:xterceirodesconto';
       end;
    if XDesconto.TryGetValue('quartodesconto',wval) then
       begin
         if wcampos='' then
            wcampos := '"QuartoDescontoProduto"=:xquartodesconto'
         else
            wcampos := wcampos+',"QuartoDescontoProduto"=:xquartodesconto';
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
           SQL.Add('Update "ProdutoDesconto" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoProdutoDesconto"=:xid ');
           ParamByName('xid').AsInteger       := XIdDesconto;
           if XDesconto.TryGetValue('primeirodesconto',wval) then
              ParamByName('xprimeirodesconto').AsFloat := strtofloatdef(XDesconto.GetValue('primeirodesconto').Value,0);
           if XDesconto.TryGetValue('segundodesconto',wval) then
              ParamByName('xsegundodesconto').AsFloat  := strtofloatdef(XDesconto.GetValue('segundodesconto').Value,0);
           if XDesconto.TryGetValue('terceirodesconto',wval) then
              ParamByName('xterceirodesconto').AsFloat := strtofloatdef(XDesconto.GetValue('terceirodesconto').Value,0);
           if XDesconto.TryGetValue('quartodesconto',wval) then
              ParamByName('xquartodesconto').AsFloat   := strtofloatdef(XDesconto.GetValue('quartodesconto').Value,0);
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
              SQL.Add('select  "CodigoInternoProdutoDesconto" as id,');
              SQL.Add('        "CodigoProdutoDesconto"        as idproduto,');
              SQL.Add('        "PrimeiroDescontoProduto"      as primeirodesconto,');
              SQL.Add('        "SegundoDescontoProduto"       as segundodesconto,');
              SQL.Add('        "TerceiroDescontoProduto"      as terceirodesconto,');
              SQL.Add('        "QuartoDescontoProduto"        as quartodesconto ');
              SQL.Add('from "ProdutoDesconto" ');
              SQL.Add('where "CodigoInternoProdutoDesconto" =:xid ');
              ParamByName('xid').AsInteger := XIdDesconto;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Produto Desconto alterado');
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

function VerificaRequisicao(XDesconto: TJSONObject): boolean;
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

function ApagaDesconto(XIdDesconto: integer): TJSONObject;
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
         SQL.Add('delete from "ProdutoDesconto" where "CodigoInternoProdutoDesconto"=:xid ');
         ParamByName('xid').AsInteger := XIdDesconto;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Produto Desconto excluído com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhum Produto Desconto excluído');
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
