unit dat.cadProdutosRevendas;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaRevenda(XId: integer): TJSONObject;
function RetornaListaRevendas(const XQuery: TDictionary<string, string>; XIdProduto: integer): TJSONArray;
function IncluiRevenda(XRevenda: TJSONObject; XIdProduto: integer): TJSONObject;
function AlteraRevenda(XIdRevenda: integer; XRevenda: TJSONObject): TJSONObject;
function ApagaRevenda(XIdRevenda: integer): TJSONObject;
function VerificaRequisicao(XRevenda: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaRevenda(XId: integer): TJSONObject;
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
         SQL.Add('select  "CodigoInternoProdutoRevenda"  as id,');
         SQL.Add('        "CodigoProdutoRevenda"         as idproduto,');
         SQL.Add('        "EhDescontinuadoProduto"       as ehdescontinuado,');
         SQL.Add('        "EhPromocaoProduto"            as ehpromocao,');
         SQL.Add('        "ControlaPrecoSugeridoProduto" as controlaprecosugerido,');
         SQL.Add('        "PermiteVendaBNDESProduto"     as permitevendabndes,');
         SQL.Add('        "MesesGarantiaProduto"         as mesesgarantia,');
         SQL.Add('        "PrecoPredatorioProduto"       as precopredatorio,');
         SQL.Add('        "PrecoDistribuidorProduto"     as precodistribuidor,');
         SQL.Add('        "PrecoConsumidorFinalProduto"  as precoconsumidor,');
         SQL.Add('        "PercentualFabricanteProduto"  as percfabricante,');
         SQL.Add('        "PrecoCompraProduto"           as precocompra,');
         SQL.Add('        "PrecoVendaProduto"            as precovenda,');
         SQL.Add('        "DataTabelaProduto"            as datatabela ');
         SQL.Add('from "ProdutoRevenda" ');
         SQL.Add('where "CodigoInternoProdutoRevenda"=:xid ');
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
        wret.AddPair('description','Nenhuma Revenda encontrada');
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

function RetornaListaRevendas(const XQuery: TDictionary<string, string>; XIdProduto: integer): TJSONArray;
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
         SQL.Add('select  "CodigoInternoProdutoRevenda"  as id,');
         SQL.Add('        "CodigoProdutoRevenda"         as idproduto,');
         SQL.Add('        "EhDescontinuadoProduto"       as ehdescontinuado,');
         SQL.Add('        "EhPromocaoProduto"            as ehpromocao,');
         SQL.Add('        "ControlaPrecoSugeridoProduto" as controlaprecosugerido,');
         SQL.Add('        "PermiteVendaBNDESProduto"     as permitevendabndes,');
         SQL.Add('        "MesesGarantiaProduto"         as mesesgarantia,');
         SQL.Add('        "PrecoPredatorioProduto"       as precopredatorio,');
         SQL.Add('        "PrecoDistribuidorProduto"     as precodistribuidor,');
         SQL.Add('        "PrecoConsumidorFinalProduto"  as precoconsumidor,');
         SQL.Add('        "PercentualFabricanteProduto"  as percfabricante,');
         SQL.Add('        "PrecoCompraProduto"           as precocompra,');
         SQL.Add('        "PrecoVendaProduto"            as precovenda,');
         SQL.Add('        "DataTabelaProduto"            as datatabela ');
         SQL.Add('from "ProdutoRevenda" where "CodigoProdutoRevenda"=:xidproduto ');
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
         wobj.AddPair('description','Nenhuma Revenda encontrada');
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

function IncluiRevenda(XRevenda: TJSONObject; XIdProduto: integer): TJSONObject;
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
           SQL.Add('Insert into "ProdutoRevenda"("CodigoProdutoRevenda","EhDescontinuadoProduto","EhPromocaoProduto","ControlaPrecoSugeridoProduto",');
           SQL.Add('"PermiteVendaBNDESProduto","MesesGarantiaProduto","PrecoPredatorioProduto","PrecoDistribuidorProduto","PrecoConsumidorFinalProduto",');
           SQL.Add('"PercentualFabricanteProduto","PrecoCompraProduto","PrecoVendaProduto","DataTabelaProduto") ');
           SQL.Add('values (:xidproduto,:xehdescontinuado,:xehpromocao,:xcontrolaprecosugerido,');
           SQL.Add(':xpermitevendabndes,:xmesesgarantia,:xprecopredatorio,:xprecodistribuidor,:xprecoconsumidor,');
           SQL.Add(':xpercfabricante,:xprecocompra,:xprecovenda,:xdatatabela) ');
           ParamByName('xidproduto').AsInteger    := XIdProduto;
           if XRevenda.TryGetValue('ehdescontinuado',wval) then
              ParamByName('xehdescontinuado').AsBoolean := strtobooldef(XRevenda.GetValue('ehdescontinuado').Value,false)
           else
              ParamByName('xehdescontinuado').AsBoolean := false;
           if XRevenda.TryGetValue('ehpromocao',wval) then
              ParamByName('xehpromocao').AsBoolean := strtobooldef(XRevenda.GetValue('ehpromocao').Value,false)
           else
              ParamByName('xehpromocao').AsBoolean := false;
           if XRevenda.TryGetValue('controlaprecosugerido',wval) then
              ParamByName('xcontrolaprecosugerido').AsBoolean := strtobooldef(XRevenda.GetValue('controlaprecosugerido').Value,false)
           else
              ParamByName('xcontrolaprecosugerido').AsBoolean := false;
           if XRevenda.TryGetValue('permitevendabndes',wval) then
              ParamByName('xpermitevendabndes').AsBoolean := strtobooldef(XRevenda.GetValue('permitevendabndes').Value,false)
           else
              ParamByName('xpermitevendabndes').AsBoolean := false;
           if XRevenda.TryGetValue('mesesgarantia',wval) then
              ParamByName('xmesesgarantia').AsInteger := strtointdef(XRevenda.GetValue('mesesgarantia').Value,0)
           else
              ParamByName('xmesesgarantia').AsInteger := 0;
           if XRevenda.TryGetValue('precopredatorio',wval) then
              ParamByName('xprecopredatorio').AsFloat := strtofloatdef(XRevenda.GetValue('precopredatorio').Value,0)
           else
              ParamByName('xprecopredatorio').AsFloat := 0;
           if XRevenda.TryGetValue('precodistribuidor',wval) then
              ParamByName('xprecodistribuidor').AsFloat := strtofloatdef(XRevenda.GetValue('precodistribuidor').Value,0)
           else
              ParamByName('xprecodistribuidor').AsFloat := 0;
           if XRevenda.TryGetValue('precoconsumidor',wval) then
              ParamByName('xprecoconsumidor').AsFloat := strtofloatdef(XRevenda.GetValue('precoconsumidor').Value,0)
           else
              ParamByName('xprecoconsumidor').AsFloat := 0;
           if XRevenda.TryGetValue('percfabricante',wval) then
              ParamByName('xpercfabricante').AsFloat := strtofloatdef(XRevenda.GetValue('percfabricante').Value,0)
           else
              ParamByName('xpercfabricante').AsFloat := 0;
           if XRevenda.TryGetValue('precocompra',wval) then
              ParamByName('xprecocompra').AsFloat := strtofloatdef(XRevenda.GetValue('precocompra').Value,0)
           else
              ParamByName('xprecocompra').AsFloat := 0;
           if XRevenda.TryGetValue('precovenda',wval) then
              ParamByName('xprecovenda').AsFloat := strtofloatdef(XRevenda.GetValue('precovenda').Value,0)
           else
              ParamByName('xprecovenda').AsFloat := 0;
           if XRevenda.TryGetValue('datatabela',wval) then
              ParamByName('xdatatabela').AsDate := strtodatedef(XRevenda.GetValue('datatabela').Value,0)
           else
              ParamByName('xdatatabela').AsDate := 0;
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
                SQL.Add('select  "CodigoInternoProdutoRevenda"  as id,');
                SQL.Add('        "CodigoProdutoRevenda"         as idproduto,');
                SQL.Add('        "EhDescontinuadoProduto"       as ehdescontinuado,');
                SQL.Add('        "EhPromocaoProduto"            as ehpromocao,');
                SQL.Add('        "ControlaPrecoSugeridoProduto" as controlaprecosugerido,');
                SQL.Add('        "PermiteVendaBNDESProduto"     as permitevendabndes,');
                SQL.Add('        "MesesGarantiaProduto"         as mesesgarantia,');
                SQL.Add('        "PrecoPredatorioProduto"       as precopredatorio,');
                SQL.Add('        "PrecoDistribuidorProduto"     as precodistribuidor,');
                SQL.Add('        "PrecoConsumidorFinalProduto"  as precoconsumidor,');
                SQL.Add('        "PercentualFabricanteProduto"  as percfabricante,');
                SQL.Add('        "PrecoCompraProduto"           as precocompra,');
                SQL.Add('        "PrecoVendaProduto"            as precovenda,');
                SQL.Add('        "DataTabelaProduto"            as datatabela ');
                SQL.Add('from "ProdutoRevenda" where "CodigoProdutoRevenda"=:xidproduto ');
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
              wret.AddPair('description','Nenhuma Revenda incluída');
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

function AlteraRevenda(XIdRevenda: integer; XRevenda: TJSONObject): TJSONObject;
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
    if XRevenda.TryGetValue('ehdescontinuado',wval) then
       begin
         if wcampos='' then
            wcampos := '"EhDescontinuadoProduto"=:xehdescontinuado'
         else
            wcampos := wcampos+',"EhDescontinuadoProduto"=:xehdescontinuado';
       end;
    if XRevenda.TryGetValue('ehpromocao',wval) then
       begin
         if wcampos='' then
            wcampos := '"EhPromocaoProduto"=:xehpromocao'
         else
            wcampos := wcampos+',"EhPromocaoProduto"=:xehpromocao';
       end;
    if XRevenda.TryGetValue('controlaprecosugerido',wval) then
       begin
         if wcampos='' then
            wcampos := '"ControlaPrecoSugeridoProduto"=:xcontrolaprecosugerido'
         else
            wcampos := wcampos+',"ControlaPrecoSugeridoProduto"=:xcontrolaprecosugerido';
       end;
    if XRevenda.TryGetValue('permitevendabndes',wval) then
       begin
         if wcampos='' then
            wcampos := '"PermiteVendaBNDESProduto"=:xpermitevendabndes'
         else
            wcampos := wcampos+',"PermiteVendaBNDESProduto"=:xpermitevendabndes';
       end;
    if XRevenda.TryGetValue('mesesgarantia',wval) then
       begin
         if wcampos='' then
            wcampos := '"MesesGarantiaProduto"=:xmesesgarantia'
         else
            wcampos := wcampos+',"MesesGarantiaProduto"=:xmesesgarantia';
       end;
    if XRevenda.TryGetValue('precopredatorio',wval) then
       begin
         if wcampos='' then
            wcampos := '"PrecoPredatorioProduto"=:xprecopredatorio'
         else
            wcampos := wcampos+',"PrecoPredatorioProduto"=:xprecopredatorio';
       end;
    if XRevenda.TryGetValue('precodistribuidor',wval) then
       begin
         if wcampos='' then
            wcampos := '"PrecoDistribuidorProduto"=:xprecodistribuidor'
         else
            wcampos := wcampos+',"PrecoDistribuidorProduto"=:xprecodistribuidor';
       end;
    if XRevenda.TryGetValue('precoconsumidor',wval) then
       begin
         if wcampos='' then
            wcampos := '"PrecoConsumidorProduto"=:xprecoconsumidor'
         else
            wcampos := wcampos+',"PrecoConsumidorProduto"=:xprecoconsumidor';
       end;
    if XRevenda.TryGetValue('percfabricante',wval) then
       begin
         if wcampos='' then
            wcampos := '"PercentualFabricanteProduto"=:xpercfabricante'
         else
            wcampos := wcampos+',"PercentualFabricanteProduto"=:xpercfabricante';
       end;
    if XRevenda.TryGetValue('precocompra',wval) then
       begin
         if wcampos='' then
            wcampos := '"PrecoCompraProduto"=:xprecocompra'
         else
            wcampos := wcampos+',"PrecoCompraProduto"=:xprecocompra';
       end;
    if XRevenda.TryGetValue('precovenda',wval) then
       begin
         if wcampos='' then
            wcampos := '"PrecoVendaProduto"=:xprecovenda'
         else
            wcampos := wcampos+',"PrecoVendaProduto"=:xprecovenda';
       end;
    if XRevenda.TryGetValue('datatabela',wval) then
       begin
         if wcampos='' then
            wcampos := '"DataTabelaProduto"=:xdatatabela'
         else
            wcampos := wcampos+',"DataTabelaProduto"=:xdatatabela';
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
           SQL.Add('Update "ProdutoRevenda" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoProdutoRevenda"=:xid ');
           ParamByName('xid').AsInteger       := XIdRevenda;
           if XRevenda.TryGetValue('ehdescontinuado',wval) then
              ParamByName('xehdescontinuado').AsBoolean         := strtobooldef(XRevenda.GetValue('ehdescontinuado').Value,false);
           if XRevenda.TryGetValue('ehpromocao',wval) then
              ParamByName('xehpromocao').AsBoolean              := strtobooldef(XRevenda.GetValue('ehpromocao').Value,false);
           if XRevenda.TryGetValue('controlaprecosugerido',wval) then
              ParamByName('xcontrolaprecosugerido').AsBoolean   := strtobooldef(XRevenda.GetValue('controlaprecosugerido').Value,false);
           if XRevenda.TryGetValue('permitevendabndes',wval) then
              ParamByName('xpermitevendabndes').AsBoolean       := strtobooldef(XRevenda.GetValue('permitevendabndes').Value,false);
           if XRevenda.TryGetValue('mesesgarantia',wval) then
              ParamByName('xmesesgarantia').AsInteger           := strtointdef(XRevenda.GetValue('mesesgarantia').Value,0);
           if XRevenda.TryGetValue('precopredatorio',wval) then
              ParamByName('xprecopredatorio').AsFloat           := strtofloatdef(XRevenda.GetValue('precopredatorio').Value,0);
           if XRevenda.TryGetValue('precodistribuidor',wval) then
              ParamByName('xprecodistribuidor').AsFloat         := strtofloatdef(XRevenda.GetValue('precodistribuidor').Value,0);
           if XRevenda.TryGetValue('precoconsumidor',wval) then
              ParamByName('xprecoconsumidor').AsFloat           := strtofloatdef(XRevenda.GetValue('precoconsumidor').Value,0);
           if XRevenda.TryGetValue('percfabricante',wval) then
              ParamByName('xpercfabricante').AsFloat            := strtofloatdef(XRevenda.GetValue('percfabricante').Value,0);
           if XRevenda.TryGetValue('precocompra',wval) then
              ParamByName('xprecocompra').AsFloat               := strtofloatdef(XRevenda.GetValue('precocompra').Value,0);
           if XRevenda.TryGetValue('precovenda',wval) then
              ParamByName('xprecovenda').AsFloat                := strtofloatdef(XRevenda.GetValue('precovenda').Value,0);
           if XRevenda.TryGetValue('datatabela',wval) then
              ParamByName('xdatatabela').AsDate                 := strtodatedef(XRevenda.GetValue('datatabela').Value,0);
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
              SQL.Add('select  "CodigoInternoProdutoRevenda"  as id,');
              SQL.Add('        "CodigoProdutoRevenda"         as idproduto,');
              SQL.Add('        "EhDescontinuadoProduto"       as ehdescontinuado,');
              SQL.Add('        "EhPromocaoProduto"            as ehpromocao,');
              SQL.Add('        "ControlaPrecoSugeridoProduto" as controlaprecosugerido,');
              SQL.Add('        "PermiteVendaBNDESProduto"     as permitevendabndes,');
              SQL.Add('        "MesesGarantiaProduto"         as mesesgarantia,');
              SQL.Add('        "PrecoPredatorioProduto"       as precopredatorio,');
              SQL.Add('        "PrecoDistribuidorProduto"     as precodistribuidor,');
              SQL.Add('        "PrecoConsumidorFinalProduto"  as precoconsumidor,');
              SQL.Add('        "PercentualFabricanteProduto"  as percfabricante,');
              SQL.Add('        "PrecoCompraProduto"           as precocompra,');
              SQL.Add('        "PrecoVendaProduto"            as precovenda,');
              SQL.Add('        "DataTabelaProduto"            as datatabela ');
              SQL.Add('from "ProdutoRevenda" ');
              SQL.Add('where "CodigoInternoProdutoRevenda" =:xid ');
              ParamByName('xid').AsInteger := XIdRevenda;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhuma Revenda alterada');
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

function VerificaRequisicao(XRevenda: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XRevenda.TryGetValue('datatabela',wval) then
       wret := false;
  finally
  end;
  Result := wret;
end;

function ApagaRevenda(XIdRevenda: integer): TJSONObject;
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
         SQL.Add('delete from "ProdutoRevenda" where "CodigoInternoProdutoRevenda"=:xid ');
         ParamByName('xid').AsInteger := XIdRevenda;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Revenda excluída com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhuma Revenda excluída');
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
