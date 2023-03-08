unit dat.cadClassificacoes;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaClassificacao(XId: integer): TJSONObject;
function RetornaListaClassificacoes(const XQuery: TDictionary<string, string>; XEmpresa: integer): TJSONArray;
function RetornaTotalClassificacoes(const XQuery: TDictionary<string, string>): TJSONObject;
function IncluiClassificacao(XClassificacao: TJSONObject): TJSONObject;
function AlteraClassificacao(XIdClassificacao: integer; XClassificacao: TJSONObject): TJSONObject;
function ApagaClassificacao(XIdClassificacao: integer): TJSONObject;
function VerificaRequisicao(XClassificacao: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaClassificacao(XId: integer): TJSONObject;
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
         SQL.Add('select "CodigoInternoClassificacao" as id,');
         SQL.Add('       "DescricaoClassificacao"     as descricao,');
         SQL.Add('       "TipoClassficacao"           as tipo,');
         SQL.Add('       "CodigoDRENivelContaClassificacao" as iddrenivelconta,');
         SQL.Add('       "CodigoFluxoReceitaClassificacao"  as idfluxoreceita,');
         SQL.Add('       "CodigoFluxoDespesaClassificacao"  as idfluxodespesa ');
         SQL.Add('from "Classificacao" ');
         SQL.Add('where "CodigoInternoClassificacao"=:xid ');
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
        wret.AddPair('description','Nenhuma Classificação encontrada');
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

function RetornaTotalClassificacoes(const XQuery: TDictionary<string, string>): TJSONObject;
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
         SQL.Add('select count(*) as registros ');
         SQL.Add('from "Classificacao" where "CodigoEmpresaClassificacao"=:xempresa ');
         if XQuery.ContainsKey('descricao') then // filtro por nome
            begin
              SQL.Add('and lower("DescricaoClassificacao") like lower(:xdescricao) ');
              ParamByName('xdescricao').AsString := XQuery.Items['descricao']+'%';
            end;
         if XQuery.ContainsKey('tipo') then // filtro por nome
            begin
              SQL.Add('and lower("TipoClassificacao") like lower(:xtipo) ');
              ParamByName('xtipo').AsString := XQuery.Items['tipo']+'%';
            end;
         ParamByName('xempresa').AsInteger := wconexao.FIdEmpresaClassificacao;
         Open;
         EnableControls;
       end;

   if wquery.RecordCount>0 then
      wret := wquery.ToJSONObject()
   else
      begin
        wret := TJSONObject.Create;
        wret.AddPair('status','500');
        wret.AddPair('description','Nenhuma classificaçao encontrada');
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
//      messagedlg('Problema ao retornar localidade'+slinebreak+E.Message,mterror,[mbok],0);
    end;
  end;
  wconexao.EncerraConexaoDB;
  Result := wret;
end;


function RetornaListaClassificacoes(const XQuery: TDictionary<string, string>; XEmpresa: integer): TJSONArray;
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
         SQL.Add('select "CodigoInternoClassificacao" as id,');
         SQL.Add('       "DescricaoClassificacao"     as descricao,');
         SQL.Add('       "TipoClassficacao"           as tipo,');
         SQL.Add('       "CodigoDRENivelContaClassificacao" as iddrenivelconta,');
         SQL.Add('       "CodigoFluxoReceitaClassificacao"  as idfluxoreceita,');
         SQL.Add('       "CodigoFluxoDespesaClassificacao"  as idfluxodespesa ');
         SQL.Add('from "Classificacao" where "CodigoEmpresaClassificacao"=:xempresa ');
         ParamByName('xempresa').AsInteger := wconexao.FIdEmpresaClassificacao;
         if XQuery.ContainsKey('descricao') then // filtro por descricao
            begin
              SQL.Add('and lower("DescricaoClassificacao") like lower(:xdescricao) ');
              ParamByName('xdescricao').AsString := XQuery.Items['descricao']+'%';
              SQL.Add('order by "DescricaoClassificacao" ');
            end;
         if XQuery.ContainsKey('tipo') then // filtro por ativo
            begin
              SQL.Add('and "TipoClassificacao" =:xtipo ');
              ParamByName('xtipo').AsString := XQuery.Items['tipo'];
              SQL.Add('order by "TipoClassificacao","DescricaoClassificacao" ');
            end;
         Open;
         EnableControls;
       end;
    if wqueryLista.RecordCount>0 then
       wret := wqueryLista.ToJSONArray()
    else
       begin
         wobj := TJSONObject.Create;
         wobj.AddPair('status','500');
         wobj.AddPair('description','Nenhuma Classificação encontrada');
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

function IncluiClassificacao(XClassificacao: TJSONObject): TJSONObject;
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
           SQL.Add('Insert into "Classificacao" ("CodigoEmpresaClassificacao","DescricaoClassificacao","TipoClassficacao",');
           SQL.Add('"CodigoDRENivelContaClassificacao","CodigoFluxoReceitaClassificacao","CodigoFluxoDespesaClassificacao") ');
           SQL.Add('values (:xidempresa,:xdescricao,:xtipo,(case when :xiddrenivelconta>0 then :xiddrenivelconta else null end),');
           SQL.Add('(case when :xidfluxoreceita>0 then :xidfluxoreceita else null end),(case when :xidfluxodespesa>0 then :xidfluxodespesa else null end)) ');
           ParamByName('xidempresa').AsInteger   := wconexao.FIdEmpresaClassificacao;
           ParamByName('xdescricao').AsString    := XClassificacao.GetValue('descricao').Value;
           ParamByName('xtipo').AsString         := XClassificacao.GetValue('tipo').Value;
           if XClassificacao.TryGetValue('iddrenivelconta',wval) then
              ParamByName('xiddrenivelconta').AsInteger  := strtointdef(XClassificacao.GetValue('iddrenivelconta').Value,0)
           else
              ParamByName('xiddrenivelconta').AsInteger  := 0;
           if XClassificacao.TryGetValue('idfluxoreceita',wval) then
              ParamByName('xidfluxoreceita').AsInteger  := strtointdef(XClassificacao.GetValue('idfluxoreceita').Value,0)
           else
              ParamByName('xidfluxoreceita').AsInteger  := 0;
           if XClassificacao.TryGetValue('idfluxodespesa',wval) then
              ParamByName('xidfluxodespesa').AsInteger  := strtointdef(XClassificacao.GetValue('idfluxodespesa').Value,0)
           else
              ParamByName('xidfluxodespesa').AsInteger  := 0;
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
                SQL.Add('select "CodigoInternoClassificacao" as id,');
                SQL.Add('       "DescricaoClassificacao"     as descricao,');
                SQL.Add('       "TipoClassficacao"           as tipo,');
                SQL.Add('       "CodigoDRENivelContaClassificacao" as iddrenivelconta,');
                SQL.Add('       "CodigoFluxoReceitaClassificacao"  as idfluxoreceita,');
                SQL.Add('       "CodigoFluxoDespesaClassificacao"  as idfluxodespesa ');
                SQL.Add('from "Classificacao" where "CodigoEmpresaClassificacao"=:xempresa and "DescricaoClassificacao"=:xdescricao ');
                ParamByName('xempresa').AsInteger  := wconexao.FIdEmpresaClassificacao;
                ParamByName('xdescricao').AsString := XClassificacao.GetValue('descricao').Value;
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhuma Classificação incluída');
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


function AlteraClassificacao(XIdClassificacao: integer; XClassificacao: TJSONObject): TJSONObject;
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
    if XClassificacao.TryGetValue('descricao',wval) then
       begin
         if wcampos='' then
            wcampos := '"DescricaoClassificacao"=:xdescricao'
         else
            wcampos := wcampos+',"DescricaoClassificacao"=:xdescricao';
       end;
    if XClassificacao.TryGetValue('tipo',wval) then
       begin
         if wcampos='' then
            wcampos := '"TipoClassificacao"=:xtipo'
         else
            wcampos := wcampos+',"TipoClassificacao"=:xtipo';
       end;
    if XClassificacao.TryGetValue('iddrenivelconta',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoDRENivelContaClassificacao"=:xiddrenivelconta'
         else
            wcampos := wcampos+',"CodigoDRENivelContaClassificacao"=:xiddrenivelconta';
       end;
    if XClassificacao.TryGetValue('idfluxoreceita',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoFluxoReceitaClassificacao"=:xidfluxoreceita'
         else
            wcampos := wcampos+',"CodigoFluxoReceitaClassificacao"=:xidfluxoreceita';
       end;
    if XClassificacao.TryGetValue('idfluxodespesa',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoFluxoDespesaClassificacao"=:xidfluxodespesa'
         else
            wcampos := wcampos+',"CodigoFluxoDespesaClassificacao"=:xidfluxodespesa';
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
           SQL.Add('Update "Classificacao" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoClassificacao"=:xid ');
           ParamByName('xid').AsInteger       := XIdClassificacao;
           if XClassificacao.TryGetValue('descricao',wval) then
              ParamByName('xdescricao').AsString   := XClassificacao.GetValue('descricao').Value;
           if XClassificacao.TryGetValue('tipo',wval) then
              ParamByName('xtipo').AsString        := XClassificacao.GetValue('tipo').Value;
           if XClassificacao.TryGetValue('iddrenivelconta',wval) then
              ParamByName('xiddrenivelconta').AsInteger  := strtointdef(XClassificacao.GetValue('iddrenivelconta').Value,0);
           if XClassificacao.TryGetValue('idfluxoreceita',wval) then
              ParamByName('xidfluxoreceita').AsInteger   := strtointdef(XClassificacao.GetValue('idfluxoreceita').Value,0);
           if XClassificacao.TryGetValue('idfluxodespesa',wval) then
              ParamByName('xidfluxodespesa').AsInteger   := strtointdef(XClassificacao.GetValue('idfluxodespesa').Value,0);
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
              SQL.Add('select "CodigoInternoClassificacao" as id,');
              SQL.Add('       "DescricaoClassificacao"     as descricao,');
              SQL.Add('       "TipoClassficacao"           as tipo,');
              SQL.Add('       "CodigoDRENivelContaClassificacao" as iddrenivelconta,');
              SQL.Add('       "CodigoFluxoReceitaClassificacao"  as idfluxoreceita,');
              SQL.Add('       "CodigoFluxoDespesaClassificacao"  as idfluxodespesa ');
              SQL.Add('from "Classificacao" ');
              SQL.Add('where "CodigoInternoClassificacao" =:xid ');
              ParamByName('xid').AsInteger := XIdClassificacao;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhuma Classificação alterada');
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

function VerificaRequisicao(XClassificacao: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XClassificacao.TryGetValue('descricao',wval) then
       wret := false;
    if not XClassificacao.TryGetValue('tipo',wval) then
       wret := false;
  finally
  end;
  Result := wret;
end;

function ApagaClassificacao(XIdClassificacao: integer): TJSONObject;
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
         SQL.Add('delete from "Classificacao" where "CodigoInternoClassificacao"=:xid ');
         ParamByName('xid').AsInteger := XIdClassificacao;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Classificação excluída com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhuma Classificação excluída');
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
