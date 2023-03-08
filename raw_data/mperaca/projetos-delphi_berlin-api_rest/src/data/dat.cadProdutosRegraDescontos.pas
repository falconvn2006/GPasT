unit dat.cadProdutosRegraDescontos;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaRegra(XId: integer): TJSONObject;
function RetornaListaRegras(const XQuery: TDictionary<string, string>; XIdProduto: integer): TJSONArray;
function IncluiRegra(XRegra: TJSONObject; XIdProduto: integer): TJSONObject;
function AlteraRegra(XIdRegra: integer; XRegra: TJSONObject): TJSONObject;
function ApagaRegra(XIdRegra: integer): TJSONObject;
function VerificaRequisicao(XRegra: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaRegra(XId: integer): TJSONObject;
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
         SQL.Add('select  "CodigoInternoProdutoRegra" as id,');
         SQL.Add('        "CodigoProdutoRegra"        as idproduto,');
         SQL.Add('        "QuantidadeProdutoRegra"    as quantidade,');
         SQL.Add('        "PercentualDescontoRegra"   as percdesconto,');
         SQL.Add('        "DataValidadeRegra"         as datavalidade ');
         SQL.Add('from "ProdutoRegraDesconto" ');
         SQL.Add('where "CodigoInternoProdutoRegra"=:xid ');
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
        wret.AddPair('description','Nenhuma Regra Desconto encontrada');
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

function RetornaListaRegras(const XQuery: TDictionary<string, string>; XIdProduto: integer): TJSONArray;
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
         SQL.Add('select  "CodigoInternoProdutoRegra" as id,');
         SQL.Add('        "CodigoProdutoRegra"        as idproduto,');
         SQL.Add('        "QuantidadeProdutoRegra"    as quantidade,');
         SQL.Add('        "PercentualDescontoRegra"   as percdesconto,');
         SQL.Add('        "DataValidadeRegra"         as datavalidade ');
         SQL.Add('from "ProdutoRegraDesconto" where "CodigoProdutoRegra"=:xidproduto ');
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
         wobj.AddPair('description','Nenhuma Regra encontrada');
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

function IncluiRegra(XRegra: TJSONObject; XIdProduto: integer): TJSONObject;
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
           SQL.Add('Insert into "ProdutoRegraDesconto"("CodigoProdutoRegra","QuantidadeProdutoRegra","PercentualDescontoRegra","DataValidadeRegra") ');
           SQL.Add('values (:xidproduto,:xquantidade,:xpercdesconto,:xdatavalidade) ');
           ParamByName('xidproduto').AsInteger    := XIdProduto;
           if XRegra.TryGetValue('quantidade',wval) then
              ParamByName('xquantidade').AsFloat := strtofloatdef(XRegra.GetValue('quantidade').Value,0)
           else
              ParamByName('xquantidade').AsFloat := 0;
           if XRegra.TryGetValue('percdesconto',wval) then
              ParamByName('xpercdesconto').AsFloat := strtofloatdef(XRegra.GetValue('percdesconto').Value,0)
           else
              ParamByName('xpercdesconto').AsFloat := 0;
           if XRegra.TryGetValue('datavalidade',wval) then
              ParamByName('xdatavalidade').AsDate := strtodatedef(XRegra.GetValue('datavalidade').Value,0)
           else
              ParamByName('xdatavalidade').AsDate := 0;
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
                SQL.Add('select  "CodigoInternoProdutoRegra" as id,');
                SQL.Add('        "CodigoProdutoRegra"        as idproduto,');
                SQL.Add('        "QuantidadeProdutoRegra"    as quantidade,');
                SQL.Add('        "PercentualDescontoRegra"   as percdesconto,');
                SQL.Add('        "DataValidadeRegra"         as datavalidade ');
                SQL.Add('from "ProdutoRegraDesconto" where "CodigoProdutoRegra"=:xidproduto ');
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
              wret.AddPair('description','Nenhuma Regra incluída');
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

function AlteraRegra(XIdRegra: integer; XRegra: TJSONObject): TJSONObject;
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
    if XRegra.TryGetValue('quantidade',wval) then
       begin
         if wcampos='' then
            wcampos := '"QuantidadeProdutoRegra"=:xquantidade'
         else
            wcampos := wcampos+',"QuantidadeProdutoRegra"=:xquantidade';
       end;
    if XRegra.TryGetValue('percdesconto',wval) then
       begin
         if wcampos='' then
            wcampos := '"PercentualDescontoRegra"=:xpercdesconto'
         else
            wcampos := wcampos+',"PercentualDescontoRegra"=:xpercdesconto';
       end;
    if XRegra.TryGetValue('datavalidade',wval) then
       begin
         if wcampos='' then
            wcampos := '"DataValidadeRegra"=:xdatavalidade'
         else
            wcampos := wcampos+',"DataValidadeRegra"=:xdatavalidade';
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
           SQL.Add('Update "ProdutoRegraDesconto" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoProdutoRegra"=:xid ');
           ParamByName('xid').AsInteger       := XIdRegra;
           if XRegra.TryGetValue('quantidade',wval) then
              ParamByName('xquantidade').AsFloat   := strtofloatdef(XRegra.GetValue('quantidade').Value,0);
           if XRegra.TryGetValue('percdesconto',wval) then
              ParamByName('xpercdesconto').AsFloat := strtofloatdef(XRegra.GetValue('percdesconto').Value,0);
           if XRegra.TryGetValue('datavalidade',wval) then
              ParamByName('xdatavalidade').AsDate  := strtodatedef(XRegra.GetValue('datavalidade').Value,0);
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
              SQL.Add('select  "CodigoInternoProdutoRegra" as id,');
              SQL.Add('        "CodigoProdutoRegra"        as idproduto,');
              SQL.Add('        "QuantidadeProdutoRegra"    as quantidade,');
              SQL.Add('        "PercentualDescontoRegra"   as percdesconto,');
              SQL.Add('        "DataValidadeRegra"         as datavalidade ');
              SQL.Add('from "ProdutoRegraDesconto" ');
              SQL.Add('where "CodigoInternoProdutoRegra" =:xid ');
              ParamByName('xid').AsInteger := XIdRegra;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhuma Regra Desconto alterada');
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

function VerificaRequisicao(XRegra: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XRegra.TryGetValue('datavalidade',wval) then
       wret := false;
  finally
  end;
  Result := wret;
end;

function ApagaRegra(XIdRegra: integer): TJSONObject;
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
         SQL.Add('delete from "ProdutoRegraDesconto" where "CodigoInternoProdutoRegra"=:xid ');
         ParamByName('xid').AsInteger := XIdRegra;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Regra Desconto excluída com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhuma Regra Desconto excluída');
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
