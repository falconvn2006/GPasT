unit dat.cadProdutosEnviaSites;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaEnvio(XId: integer): TJSONObject;
function RetornaListaEnvios(const XQuery: TDictionary<string, string>; XIdProduto: integer): TJSONArray;
function IncluiEnvio(XEnvio: TJSONObject; XIdProduto: integer): TJSONObject;
function AlteraEnvio(XIdEnvio: integer; XEnvio: TJSONObject): TJSONObject;
function ApagaEnvio(XIdEnvio: integer): TJSONObject;
function VerificaRequisicao(XEnvio: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaEnvio(XId: integer): TJSONObject;
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
         SQL.Add('select  "CodigoInternoProdutoEnviaSite" as id,');
         SQL.Add('        "CodigoProdutoEnviaSite"        as idproduto,');
         SQL.Add('        "DataHoraEnvioSite"             as datahora,');
         SQL.Add('        "EnvioChecado"                  as enviochecado,');
         SQL.Add('        "DiferencaSaldo"                as diferenca ');
         SQL.Add('from "ProdutoEnviaSite" ');
         SQL.Add('where "CodigoInternoProdutoEnviaSite"=:xid ');
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
        wret.AddPair('description','Nenhum Produto Envia Site encontrado');
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

function RetornaListaEnvios(const XQuery: TDictionary<string, string>; XIdProduto: integer): TJSONArray;
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
         SQL.Add('select  "CodigoInternoProdutoEnviaSite" as id,');
         SQL.Add('        "CodigoProdutoEnviaSite"        as idproduto,');
         SQL.Add('        "DataHoraEnvioSite"             as datahora,');
         SQL.Add('        "EnvioChecado"                  as enviochecado,');
         SQL.Add('        "DiferencaSaldo"                as diferenca ');
         SQL.Add('from "ProdutoEnviaSite" where "CodigoProdutoEnviaSite"=:xidproduto ');
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
         wobj.AddPair('description','Nenhum Produto Envia Site encontrado');
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

function IncluiEnvio(XEnvio: TJSONObject; XIdProduto: integer): TJSONObject;
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
           SQL.Add('Insert into "ProdutoEnviaSite"("CodigoEmpresaProdutoEnviaSite","CodigoProdutoEnviaSite",');
           SQL.Add('"DataHoraEnvioSite","EnvioChecado","DiferencaSaldo") ');
           SQL.Add('values (:xidempresa,:xidproduto,:xdatahora,:xenviochecado,:xdiferenca) ');
           ParamByName('xidempresa').AsInteger    := wconexao.FIdEmpresaProduto;
           ParamByName('xidproduto').AsInteger    := XIdProduto;
           if XEnvio.TryGetValue('datahora',wval) then
              ParamByName('xdatahora').AsDateTime := strtodatedef(XEnvio.GetValue('datahora').Value,now)
           else
              ParamByName('xdatahora').AsDateTime := now;
           if XEnvio.TryGetValue('enviochecado',wval) then
              ParamByName('xenviochecado').AsBoolean := strtobooldef(XEnvio.GetValue('enviochecado').Value,false)
           else
              ParamByName('xenviochecado').AsBoolean := false;
           if XEnvio.TryGetValue('diferenca',wval) then
              ParamByName('xdiferenca').AsInteger := strtointdef(XEnvio.GetValue('diferenca').Value,0)
           else
              ParamByName('xdiferenca').AsInteger := 0;
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
                SQL.Add('select  "CodigoInternoProdutoEnviaSite" as id,');
                SQL.Add('        "CodigoProdutoEnviaSite"        as idproduto,');
                SQL.Add('        "DataHoraEnvioSite"             as datahora,');
                SQL.Add('        "EnvioChecado"                  as enviochecado,');
                SQL.Add('        "DiferencaSaldo"                as diferenca ');
                SQL.Add('from "ProdutoEnviaSite" where "CodigoProdutoEnviaSite"=:xidproduto ');
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
              wret.AddPair('description','Nenhum Produto Envia Site incluído');
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

function AlteraEnvio(XIdEnvio: integer; XEnvio: TJSONObject): TJSONObject;
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
    if XEnvio.TryGetValue('datahora',wval) then
       begin
         if wcampos='' then
            wcampos := '"DataHoraEnvioSite"=:xdatahora'
         else
            wcampos := wcampos+',"DataHoraEnvioSite"=:xdatahora';
       end;
    if XEnvio.TryGetValue('enviochecado',wval) then
       begin
         if wcampos='' then
            wcampos := '"EnvioChecado"=:xenviochecado'
         else
            wcampos := wcampos+',"EnvioChecado"=:xenviochecado';
       end;
    if XEnvio.TryGetValue('diferenca',wval) then
       begin
         if wcampos='' then
            wcampos := '"DiferencaSaldo"=:xdiferenca'
         else
            wcampos := wcampos+',"DiferencaSaldo"=:xdiferenca';
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
           SQL.Add('Update "ProdutoEnviaSite" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoProdutoEnviaSite"=:xid ');
           ParamByName('xid').AsInteger              := XIdEnvio;
           if XEnvio.TryGetValue('datahora',wval) then
              ParamByName('xdatahora').AsDateTime    := strtodatedef(XEnvio.GetValue('datahora').Value,now);
           if XEnvio.TryGetValue('enviochecado',wval) then
              ParamByName('xenviochecado').AsBoolean := strtobooldef(XEnvio.GetValue('enviochecado').Value,false);
           if XEnvio.TryGetValue('diferenca',wval) then
              ParamByName('xdiferenca').AsInteger    := strtointdef(XEnvio.GetValue('diferenca').Value,0);
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
              SQL.Add('select  "CodigoInternoProdutoEnviaSite" as id,');
              SQL.Add('        "CodigoProdutoEnviaSite"        as idproduto,');
              SQL.Add('        "DataHoraEnvioSite"             as datahora,');
              SQL.Add('        "EnvioChecado"                  as enviochecado,');
              SQL.Add('        "DiferencaSaldo"                as diferenca ');
              SQL.Add('from "ProdutoEnviaSite" ');
              SQL.Add('where "CodigoInternoProdutoEnviaSite" =:xid ');
              ParamByName('xid').AsInteger := XIdEnvio;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Produto Envia Site alterado');
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

function VerificaRequisicao(XEnvio: TJSONObject): boolean;
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

function ApagaEnvio(XIdEnvio: integer): TJSONObject;
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
         SQL.Add('delete from "ProdutoEnviaSite" where "CodigoInternoProdutoEnviaSite"=:xid ');
         ParamByName('xid').AsInteger := XIdEnvio;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Produto Envia Site excluído com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhum Produto Envia Site excluído');
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
