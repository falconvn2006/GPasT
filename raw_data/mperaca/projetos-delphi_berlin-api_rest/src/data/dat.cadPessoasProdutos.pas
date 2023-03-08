unit dat.cadPessoasProdutos;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaProduto(XId: integer): TJSONObject;
function RetornaListaProdutos(const XQuery: TDictionary<string, string>; XIdPessoa: integer): TJSONArray;
function IncluiProduto(XProduto: TJSONObject; XIdPessoa: integer): TJSONObject;
function AlteraProduto(XIdProduto: integer; XProduto: TJSONObject): TJSONObject;
function ApagaProduto(XIdProduto: integer): TJSONObject;
function VerificaRequisicao(XProduto: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaProduto(XId: integer): TJSONObject;
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
         SQL.Add('select  "CodigoInternoProduto" as id,');
         SQL.Add('        "CodigoPessoa"         as idpessoa,');
         SQL.Add('        "CodigoProduto"        as idproduto,');
         SQL.Add('        "UltimaCompra"         as ultimacompra,');
         SQL.Add('        "QtdeUltimaCompra"     as qtdultimacompra ');
         SQL.Add('from "PessoaProduto" ');
         SQL.Add('where "CodigoInternoProduto"=:xid ');
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
        wret.AddPair('description','Nenhum Produto encontrado');
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

function RetornaListaProdutos(const XQuery: TDictionary<string, string>; XIdPessoa: integer): TJSONArray;
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
         SQL.Add('select  "CodigoInternoProduto" as id,');
         SQL.Add('        "CodigoPessoa"         as idpessoa,');
         SQL.Add('        "CodigoProduto"        as idproduto,');
         SQL.Add('        "UltimaCompra"         as ultimacompra,');
         SQL.Add('        "QtdeUltimaCompra"     as qtdultimacompra ');
         SQL.Add('from "PessoaProduto" where "CodigoPessoa"=:xidpessoa ');
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
         wobj.AddPair('description','Nenhum Produto encontrado');
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

function IncluiProduto(XProduto: TJSONObject; XIdPessoa: integer): TJSONObject;
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
           SQL.Add('Insert into "PessoaProduto" ("CodigoPessoa","CodigoProduto","UltimaCompra","QtdeUltimaCompra") ');
           SQL.Add('values (:xidpessoa,:xidproduto,:xultimacompra,:xqtdultimacompra) ');
           ParamByName('xidpessoa').AsInteger   := XIdPessoa;
           if XProduto.TryGetValue('idproduto',wval) then
              ParamByName('xidproduto').AsInteger := strtointdef(XProduto.GetValue('idproduto').Value,0)
           else
              ParamByName('xidproduto').AsInteger := 0;
           if XProduto.TryGetValue('ultimacompra',wval) then
              ParamByName('xultimacompra').AsDate := strtodatedef(XProduto.GetValue('ultimacompra').Value,0)
           else
              ParamByName('xultimacompra').AsDate := 0;
           if XProduto.TryGetValue('qtdultimacompra',wval) then
              ParamByName('xqtdultimacompra').AsFloat := strtofloatdef(XProduto.GetValue('qtdultimacompra').Value,0)
           else
              ParamByName('xqtdultimacompra').AsFloat := 0;
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
                SQL.Add('select  "CodigoInternoProduto" as id,');
                SQL.Add('        "CodigoPessoa"         as idpessoa,');
                SQL.Add('        "CodigoProduto"        as idproduto,');
                SQL.Add('        "UltimaCompra"         as ultimacompra,');
                SQL.Add('        "QtdeUltimaCompra"     as qtdultimacompra ');
                SQL.Add('from "PessoaProduto" where "CodigoPessoa"=:xidpessoa and "CodigoProduto"=:xidproduto ');
                ParamByName('xidpessoa').AsInteger  := XIdPessoa;
                if XProduto.TryGetValue('idproduto',wval) then
                   ParamByName('xidproduto').AsInteger := strtointdef(XProduto.GetValue('idproduto').Value,0)
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
              wret.AddPair('description','Nenhum Produto incluído');
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


function AlteraProduto(XIdProduto: integer; XProduto: TJSONObject): TJSONObject;
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

    if XProduto.TryGetValue('idproduto',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoProduto"=:xidproduto'
         else
            wcampos := wcampos+',"CodigoProduto"=:xidproduto';
       end;
    if XProduto.TryGetValue('ultimacompra',wval) then
       begin
         if wcampos='' then
            wcampos := '"UltimaCompra"=:xultimacompra'
         else
            wcampos := wcampos+',"UltimaCompra"=:xultimacompra';
       end;
    if XProduto.TryGetValue('qtdultimacompra',wval) then
       begin
         if wcampos='' then
            wcampos := '"QtdeUltimaCompra"=:xqtdultimacompra'
         else
            wcampos := wcampos+',"QtdeUltimaCompra"=:xqtdultimacompra';
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
           SQL.Add('Update "PessoaProduto" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoProduto"=:xid ');
           ParamByName('xid').AsInteger               := XIdProduto;
           if XProduto.TryGetValue('idproduto',wval) then
              ParamByName('xidproduto').AsInteger     := strtointdef(XProduto.GetValue('idproduto').Value,0);
           if XProduto.TryGetValue('ultimacompra',wval) then
              ParamByName('xultimacompra').AsDate     := strtodatedef(XProduto.GetValue('ultimacompra').Value,0);
           if XProduto.TryGetValue('qtdultimacompra',wval) then
              ParamByName('xqtdultimacompra').AsFloat := strtofloatdef(XProduto.GetValue('qtdultimacompra').Value,0);
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
              SQL.Add('select  "CodigoInternoProduto" as id,');
              SQL.Add('        "CodigoPessoa"         as idpessoa,');
              SQL.Add('        "CodigoProduto"        as idproduto,');
              SQL.Add('        "UltimaCompra"         as ultimacompra,');
              SQL.Add('        "QtdeUltimaCompra"     as qtdultimacompra ');
              SQL.Add('from "PessoaProduto" ');
              SQL.Add('where "CodigoInternoProduto" =:xid ');
              ParamByName('xid').AsInteger := XIdProduto;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Produto alterado');
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

function VerificaRequisicao(XProduto: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XProduto.TryGetValue('idproduto',wval) then
       wret := false;
  finally
  end;
  Result := wret;
end;

function ApagaProduto(XIdProduto: integer): TJSONObject;
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
         SQL.Add('delete from "PessoaProduto" where "CodigoInternoProduto"=:xid ');
         ParamByName('xid').AsInteger := XIdProduto;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Produto excluído com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhum Produto excluído');
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
