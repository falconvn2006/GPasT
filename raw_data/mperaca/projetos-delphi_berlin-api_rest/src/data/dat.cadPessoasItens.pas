unit dat.cadPessoasItens;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaItem(XId: integer): TJSONObject;
function RetornaListaItens(const XQuery: TDictionary<string, string>; XIdPessoa: integer): TJSONArray;
function IncluiItem(XItem: TJSONObject; XIdPessoa: integer): TJSONObject;
function AlteraItem(XIdItem: integer; XItem: TJSONObject): TJSONObject;
function ApagaItem(XIdItem: integer): TJSONObject;
function VerificaRequisicao(XItem: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaItem(XId: integer): TJSONObject;
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
         SQL.Add('select "CodigoInternoItem"      as id,');
         SQL.Add('       "CodigoPessoaItem"       as idpessoa,');
         SQL.Add('       "CodigoProdutoItem"      as idproduto,');
         SQL.Add('       "DataInicialItem"        as datainicial,');
         SQL.Add('       "DataFinalItem"          as datafinal,');
         SQL.Add('       "QuantidadeItem"         as quantidade,');
         SQL.Add('       "PrecoAUtilizarItem"     as precoautilizar,');
         SQL.Add('       "ValorPrecoItem"         as valorpreco,');
         SQL.Add('       "PercentualDescontoItem" as percdesconto ');
         SQL.Add('from "PessoaItem" ');
         SQL.Add('where "CodigoInternoItem"=:xid ');
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
        wret.AddPair('description','Nenhum Ítem encontrado');
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

function RetornaListaItens(const XQuery: TDictionary<string, string>; XIdPessoa: integer): TJSONArray;
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
         SQL.Add('select "CodigoInternoItem"      as id,');
         SQL.Add('       "CodigoPessoaItem"       as idpessoa,');
         SQL.Add('       "CodigoProdutoItem"      as idproduto,');
         SQL.Add('       "DataInicialItem"        as datainicial,');
         SQL.Add('       "DataFinalItem"          as datafinal,');
         SQL.Add('       "QuantidadeItem"         as quantidade,');
         SQL.Add('       "PrecoAUtilizarItem"     as precoautilizar,');
         SQL.Add('       "ValorPrecoItem"         as valorpreco,');
         SQL.Add('       "PercentualDescontoItem" as percdesconto ');
         SQL.Add('from "PessoaItem" where "CodigoPessoaItem"=:xidpessoa ');
         ParamByName('xidpessoa').AsInteger := XIdPessoa;;
         Open;
         EnableControls;
       end;
    if wqueryLista.RecordCount>0 then
       wret := wqueryLista.ToJSONArray()
    else
       begin
         wobj := TJSONObject.Create;
         wobj.AddPair('status','500');
         wobj.AddPair('description','Nenhum Ítem encontrado');
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

function IncluiItem(XItem: TJSONObject; XIdPessoa: integer): TJSONObject;
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
           SQL.Add('Insert into "PessoaItem" ("CodigoPessoaItem","CodigoProdutoItem","DataInicialItem","DataFinalItem",');
           SQL.Add('"QuantidadeItem","PrecoAUtilizarItem","ValorPrecoItem","PercentualDescontoItem") ');
           SQL.Add('values (:xidpessoa,:xidproduto,:xdatainicial,:xdatafinal,');
           SQL.Add(':xquantidade,:xprecoautilizar,:xvalorpreco,:xpercdesconto) ');
           ParamByName('xidpessoa').AsInteger   := XIdPessoa;
           if XItem.TryGetValue('idproduto',wval) then
              ParamByName('xidproduto').AsInteger := strtointdef(XItem.GetValue('idproduto').Value,0)
           else
              ParamByName('xidproduto').AsInteger := 0;
           if XItem.TryGetValue('datainicial',wval) then
              ParamByName('xdatainicial').AsDate := strtodatedef(XItem.GetValue('datainicial').Value,0)
           else
              ParamByName('xdatainicial').AsDate := 0;
           if XItem.TryGetValue('datafinal',wval) then
              ParamByName('xdatafinal').AsDate := strtodatedef(XItem.GetValue('datafinal').Value,0)
           else
              ParamByName('xdatafinal').AsDate := 0;
           if XItem.TryGetValue('quantidade',wval) then
              ParamByName('xquantidade').AsInteger := strtointdef(XItem.GetValue('quantidade').Value,0)
           else
              ParamByName('xquantidade').AsInteger := 0;
           if XItem.TryGetValue('precoautilizar',wval) then
              ParamByName('xprecoautilizar').AsInteger := strtointdef(XItem.GetValue('precoautilizar').Value,0)
           else
              ParamByName('xprecoautilizar').AsInteger := 0;
           if XItem.TryGetValue('valorpreco',wval) then
              ParamByName('xvalorpreco').AsFloat := strtofloatdef(XItem.GetValue('valorpreco').Value,0)
           else
              ParamByName('xvalorpreco').AsFloat := 0;
           if XItem.TryGetValue('percdesconto',wval) then
              ParamByName('xpercdesconto').AsFloat := strtofloatdef(XItem.GetValue('percdesconto').Value,0)
           else
              ParamByName('xpercdesconto').AsFloat := 0;
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
                SQL.Add('select "CodigoInternoItem"      as id,');
                SQL.Add('       "CodigoPessoaItem"       as idpessoa,');
                SQL.Add('       "CodigoProdutoItem"      as idproduto,');
                SQL.Add('       "DataInicialItem"        as datainicial,');
                SQL.Add('       "DataFinalItem"          as datafinal,');
                SQL.Add('       "QuantidadeItem"         as quantidade,');
                SQL.Add('       "PrecoAUtilizarItem"     as precoautilizar,');
                SQL.Add('       "ValorPrecoItem"         as valorpreco,');
                SQL.Add('       "PercentualDescontoItem" as percdesconto ');
                SQL.Add('from "PessoaItem" where "CodigoPessoaItem"=:xidpessoa and "CodigoProdutoItem"=:xidproduto ');
                ParamByName('xidpessoa').AsInteger  := XIdPessoa;
                if XItem.TryGetValue('idproduto',wval) then
                   ParamByName('xidproduto').AsInteger := strtointdef(XItem.GetValue('idproduto').Value,0)
                else
                   ParamByName('xidproduto').AsInteger := 0;
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Ítem incluído');
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

function AlteraItem(XIdItem: integer; XItem: TJSONObject): TJSONObject;
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

    if XItem.TryGetValue('idproduto',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoProdutoItem"=:xidproduto'
         else
            wcampos := wcampos+',"CodigoProdutoItem"=:xidproduto';
       end;
    if XItem.TryGetValue('datainicial',wval) then
       begin
         if wcampos='' then
            wcampos := '"DataInicialItem"=:xdatainicial'
         else
            wcampos := wcampos+',"DataInicialItem"=:xdatainicial';
       end;
    if XItem.TryGetValue('datafinal',wval) then
       begin
         if wcampos='' then
            wcampos := '"DataFinalItem"=:xdatafinal'
         else
            wcampos := wcampos+',"DataFinalItem"=:xdatafinal';
       end;
    if XItem.TryGetValue('quantidade',wval) then
       begin
         if wcampos='' then
            wcampos := '"QuantidadeItem"=:xquantidade'
         else
            wcampos := wcampos+',"QuantidadeItem"=:xquantidade';
       end;
    if XItem.TryGetValue('precoautilizar',wval) then
       begin
         if wcampos='' then
            wcampos := '"PrecoAUtilizarItem"=:xprecoautilizar'
         else
            wcampos := wcampos+',"PrecoAUtilizarItem"=:xprecoautilizar';
       end;
    if XItem.TryGetValue('valorpreco',wval) then
       begin
         if wcampos='' then
            wcampos := '"ValorPrecoItem"=:xvalorpreco'
         else
            wcampos := wcampos+',"ValorPrecoItem"=:xvalorpreco';
       end;
    if XItem.TryGetValue('percdesconto',wval) then
       begin
         if wcampos='' then
            wcampos := '"PercentualDescontoItem"=:xpercdesconto'
         else
            wcampos := wcampos+',"PercentualDescontoItem"=:xpercdesconto';
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
           SQL.Add('Update "PessoaItem" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoItem"=:xid ');
           ParamByName('xid').AsInteger                := XIdItem;
           if XItem.TryGetValue('idproduto',wval) then
              ParamByName('xidproduto').AsInteger        := strtointdef(XItem.GetValue('idproduto').Value,0);
           if XItem.TryGetValue('datainicial',wval) then
              ParamByName('xdatainicial').AsDate         := strtodatedef(XItem.GetValue('datainicial').Value,0);
           if XItem.TryGetValue('datafinal',wval) then
              ParamByName('xdatafinal').AsDate           := strtodatedef(XItem.GetValue('datafinal').Value,0);
           if XItem.TryGetValue('quantidade',wval) then
              ParamByName('xquantidade').AsInteger        := strtointdef(XItem.GetValue('quantidade').Value,0);
           if XItem.TryGetValue('precoautilizar',wval) then
              ParamByName('xprecoautilizar').AsInteger    := strtointdef(XItem.GetValue('precoautilizar').Value,0);
           if XItem.TryGetValue('valorpreco',wval) then
              ParamByName('xvalorpreco').AsFloat          := strtofloatdef(XItem.GetValue('valorpreco').Value,0);
           if XItem.TryGetValue('percdesconto',wval) then
              ParamByName('xpercdesconto').AsFloat        := strtofloatdef(XItem.GetValue('percdesconto').Value,0);

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
              SQL.Add('select "CodigoInternoItem"      as id,');
              SQL.Add('       "CodigoPessoaItem"       as idpessoa,');
              SQL.Add('       "CodigoProdutoItem"      as idproduto,');
              SQL.Add('       "DataInicialItem"        as datainicial,');
              SQL.Add('       "DataFinalItem"          as datafinal,');
              SQL.Add('       "QuantidadeItem"         as quantidade,');
              SQL.Add('       "PrecoAUtilizarItem"     as precoautilizar,');
              SQL.Add('       "ValorPrecoItem"         as valorpreco,');
              SQL.Add('       "PercentualDescontoItem" as percdesconto ');
              SQL.Add('from "PessoaItem" ');
              SQL.Add('where "CodigoInternoItem" =:xid ');
              ParamByName('xid').AsInteger := XIdItem;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Ítem alterado');
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

function VerificaRequisicao(XItem: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XItem.TryGetValue('idproduto',wval) then
       wret := false;
    if not XItem.TryGetValue('quantidade',wval) then
       wret := false;
    if not XItem.TryGetValue('precoautilizar',wval) then
       wret := false;
    if not XItem.TryGetValue('valorpreco',wval) then
       wret := false;
  finally
  end;
  Result := wret;
end;

function ApagaItem(XIdItem: integer): TJSONObject;
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
         SQL.Add('delete from "PessoaItem" where "CodigoInternoItem"=:xid ');
         ParamByName('xid').AsInteger := XIdItem;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Ítem excluído com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhum Ítem excluído');
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
