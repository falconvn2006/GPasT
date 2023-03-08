unit dat.cadPessoasObservacoes;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaObservacao(XId: integer): TJSONObject;
function RetornaListaObservacoes(const XQuery: TDictionary<string, string>; XIdPessoa,XLimit,XOffset: integer): TJSONArray;
function RetornaTotalObservacoes(const XQuery: TDictionary<string, string>; XIdPessoa: integer): TJSONObject;
function IncluiObservacao(XObservacao: TJSONObject; XIdPessoa: integer): TJSONObject;
function AlteraObservacao(XIdObservacao: integer; XObservacao: TJSONObject): TJSONObject;
function ApagaObservacao(XIdObservacao: integer): TJSONObject;
function VerificaRequisicao(XObservacao: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaObservacao(XId: integer): TJSONObject;
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
         SQL.Add('select  "CodigoInternoObservacao"   as id,');
         SQL.Add('        "CodigoPessoaObservacao"    as idpessoa,');
         SQL.Add('        "DataObservacao"            as data,');
         SQL.Add('        "TextoObservacao"           as texto,');
         SQL.Add('        "OcorrenciaObservacao"      as idocorrencia,');
         SQL.Add('        cast("Ocorrencia"."DescricaoOcorrencia" as varchar) as xocorrencia,');
         SQL.Add('        "AtivoObservacao"           as ativo,');
         SQL.Add('        "UsuarioObservacao"         as idusuario,');
         SQL.Add('        "LogMovimentacaoObservacao" as logmovimentacao ');
         SQL.Add('from "PessoaObservacao" left join "Ocorrencia" on "OcorrenciaObservacao" = "CodigoInternoOcorrencia" ');
         SQL.Add('where "CodigoInternoObservacao"=:xid ');
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
        wret.AddPair('description','Nenhuma Observação encontrada');
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

function RetornaListaObservacoes(const XQuery: TDictionary<string, string>; XIdPessoa,XLimit,XOffset: integer): TJSONArray;
var wqueryLista: TFDQuery;
    wconexao: TProviderDataModuleConexao;
    wobj: TJSONObject;
    wret: TJSONArray;
    wordem: string;
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
         SQL.Add('select  "CodigoInternoObservacao"   as id,');
         SQL.Add('        "CodigoPessoaObservacao"    as idpessoa,');
         SQL.Add('        "DataObservacao"            as data,');
         SQL.Add('        "TextoObservacao"           as texto,');
         SQL.Add('        "OcorrenciaObservacao"      as idocorrencia,');
         SQL.Add('        cast("Ocorrencia"."DescricaoOcorrencia" as varchar) as xocorrencia,');
         SQL.Add('        "AtivoObservacao"           as ativo,');
         SQL.Add('        "UsuarioObservacao"         as idusuario,');
         SQL.Add('        "LogMovimentacaoObservacao" as logmovimentacao ');
         SQL.Add('from "PessoaObservacao" left join "Ocorrencia" on "OcorrenciaObservacao" = "CodigoInternoOcorrencia" ');
         SQL.Add('where "CodigoPessoaObservacao"=:xidpessoa ');
         ParamByName('xidpessoa').AsInteger := XIdPessoa;;
         if XQuery.ContainsKey('data') then // filtro por data
            begin
              SQL.Add('and "DataObservacao" =:xdata ');
              ParamByName('xdata').AsDate := strtodatedef(XQuery.Items['data'],0);
            end;
         if XQuery.ContainsKey('texto') then // filtro por texto
            begin
              SQL.Add('and lower("TextoObservacao") like lower(:xtexto) ');
              ParamByName('xtexto').AsString := XQuery.Items['texto']+'%';
            end;
         if XQuery.ContainsKey('order') then // ordenação
            begin
              wordem := 'order by '+XQuery.Items['order'];
              if XQuery.ContainsKey('dir') then // direção
                 wordem := wordem+' '+XQuery.Items['dir'];
              SQL.Add(wordem);
            end
         else
            SQL.Add('order by data ');
         if XLimit>0 then
            SQL.Add('Limit '+inttostr(XLimit)+' offset '+inttostr(XOffset));
         Open;
         EnableControls;
       end;
    if wqueryLista.RecordCount>0 then
       wret := wqueryLista.ToJSONArray()
    else
       begin
         wobj := TJSONObject.Create;
         wobj.AddPair('status','500');
         wobj.AddPair('description','Nenhuma Observacao encontrada');
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

function RetornaTotalObservacoes(const XQuery: TDictionary<string, string>; XIdPessoa: integer): TJSONObject;
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
         SQL.Add('from "PessoaObservacao" where "CodigoPessoaObservacao"=:xidpessoa ');
         ParamByName('xidpessoa').AsInteger := XIdPessoa;;
         Open;
         EnableControls;
       end;

   if wquery.RecordCount>0 then
      wret := wquery.ToJSONObject()
   else
      begin
        wret := TJSONObject.Create;
        wret.AddPair('status','500');
        wret.AddPair('description','Nenhuma Observação encontrada');
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


function IncluiObservacao(XObservacao: TJSONObject; XIdPessoa: integer): TJSONObject;
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
           SQL.Add('Insert into "PessoaObservacao" ("CodigoPessoaObservacao","DataObservacao","TextoObservacao","OcorrenciaObservacao",');
           SQL.Add('"AtivoObservacao","UsuarioObservacao","LogMovimentacaoObservacao") ');
           SQL.Add('values (:xidpessoa,:xdata,:xtexto,(case when :xidocorrencia>0 then :xidocorrencia else null end),');
           SQL.Add(':xativo,:xidusuario,:xlogmovimentacao) ');
           ParamByName('xidpessoa').AsInteger   := XIdPessoa;
           if XObservacao.TryGetValue('data',wval) then
              ParamByName('xdata').AsDate := strtodatedef(XObservacao.GetValue('data').Value,0)
           else
              ParamByName('xdata').AsDate := 0;
           if XObservacao.TryGetValue('texto',wval) then
              ParamByName('xtexto').AsString := XObservacao.GetValue('texto').Value
           else
              ParamByName('xtexto').AsString := '';
           if XObservacao.TryGetValue('idocorrencia',wval) then
              ParamByName('xidocorrencia').AsInteger := strtointdef(XObservacao.GetValue('idocorrencia').Value,0)
           else
              ParamByName('xidocorrencia').AsInteger := 0;
           if XObservacao.TryGetValue('ativo',wval) then
              ParamByName('xativo').AsBoolean := strtobooldef(XObservacao.GetValue('ativo').Value,false)
           else
              ParamByName('xativo').AsBoolean := true;
           if XObservacao.TryGetValue('idusuario',wval) then
              ParamByName('xidusuario').AsInteger := strtointdef(XObservacao.GetValue('idusuario').Value,0)
           else
              ParamByName('xidusuario').AsInteger := 0;
           if XObservacao.TryGetValue('logmovimentacao',wval) then
              ParamByName('xlogmovimentacao').AsString := XObservacao.GetValue('logmovimentacao').Value
           else
              ParamByName('xlogmovimentacao').AsString := '';
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
                SQL.Add('select  "CodigoInternoObservacao"   as id,');
                SQL.Add('        "CodigoPessoaObservacao"    as idpessoa,');
                SQL.Add('        "DataObservacao"            as data,');
                SQL.Add('        "TextoObservacao"           as texto,');
                SQL.Add('        "OcorrenciaObservacao"      as idocorrencia,');
                SQL.Add('        "AtivoObservacao"           as ativo,');
                SQL.Add('        "UsuarioObservacao"         as idusuario,');
                SQL.Add('        "LogMovimentacaoObservacao" as logmovimentacao ');
                SQL.Add('from "PessoaObservacao" where "CodigoPessoaObservacao"=:xidpessoa and "TextoObservacao"=:xtexto ');
                ParamByName('xidpessoa').AsInteger  := XIdPessoa;
                if XObservacao.TryGetValue('texto',wval) then
                   ParamByName('xtexto').AsString := XObservacao.GetValue('texto').Value
                else
                   ParamByName('xtexto').AsString := '';
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhuma Observação incluída');
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


function AlteraObservacao(XIdObservacao: integer; XObservacao: TJSONObject): TJSONObject;
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
    if XObservacao.TryGetValue('data',wval) then
       begin
         if wcampos='' then
            wcampos := '"DataObservacao"=:xdata'
         else
            wcampos := wcampos+',"DataObservacao"=:xdata';
       end;
    if XObservacao.TryGetValue('texto',wval) then
       begin
         if wcampos='' then
            wcampos := '"TextoObservacao"=:xtexto'
         else
            wcampos := wcampos+',"TextoObservacao"=:xtexto';
       end;
    if XObservacao.TryGetValue('idocorrencia',wval) then
       begin
         if wcampos='' then
            wcampos := '"OcorrenciaObservacao"=:xidocorrencia'
         else
            wcampos := wcampos+',"OcorrenciaObservacao"=:xidocorrencia';
       end;
    if XObservacao.TryGetValue('ativo',wval) then
       begin
         if wcampos='' then
            wcampos := '"AtivoObservacao"=:xativo'
         else
            wcampos := wcampos+',"AtivoObservacao"=:xativo';
       end;
    if XObservacao.TryGetValue('idusuario',wval) then
       begin
         if wcampos='' then
            wcampos := '"UsuarioObservacao"=:xidusuario'
         else
            wcampos := wcampos+',"UsuarioObservacao"=:xidusuario';
       end;
    if XObservacao.TryGetValue('logmovimentacao',wval) then
       begin
         if wcampos='' then
            wcampos := '"LogMovimentacaoObservacao"=:xlogmovimentacao'
         else
            wcampos := wcampos+',"LogMovimentacaoObservacao"=:xlogmovimentacao';
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
           SQL.Add('Update "PessoaObservacao" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoObservacao"=:xid ');
           ParamByName('xid').AsInteger                := XIdObservacao;
           if XObservacao.TryGetValue('data',wval) then
              ParamByName('xdata').AsDate              := strtodatedef(XObservacao.GetValue('data').Value,0);
           if XObservacao.TryGetValue('texto',wval) then
              ParamByName('xtexto').AsString           := XObservacao.GetValue('texto').Value;
           if XObservacao.TryGetValue('idocorrencia',wval) then
              ParamByName('xidocorrencia').AsInteger   := strtointdef(XObservacao.GetValue('idocorrencia').Value,0);
           if XObservacao.TryGetValue('ativo',wval) then
              ParamByName('xativo').AsBoolean          := strtobooldef(XObservacao.GetValue('ativo').Value,true);
           if XObservacao.TryGetValue('idusuario',wval) then
              ParamByName('xidusuario').AsInteger      := strtointdef(XObservacao.GetValue('idusuario').Value,0);
           if XObservacao.TryGetValue('logmovimentacao',wval) then
              ParamByName('xlogmovimentacao').AsString := XObservacao.GetValue('logmovimentacao').Value;
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
              SQL.Add('select  "CodigoInternoObservacao"   as id,');
              SQL.Add('        "CodigoPessoaObservacao"    as idpessoa,');
              SQL.Add('        "DataObservacao"            as data,');
              SQL.Add('        "TextoObservacao"           as texto,');
              SQL.Add('        "OcorrenciaObservacao"      as idocorrencia,');
              SQL.Add('        "AtivoObservacao"           as ativo,');
              SQL.Add('        "UsuarioObservacao"         as idusuario,');
              SQL.Add('        "LogMovimentacaoObservacao" as logmovimentacao ');
              SQL.Add('from "PessoaObservacao" ');
              SQL.Add('where "CodigoInternoObservacao" =:xid ');
              ParamByName('xid').AsInteger := XIdObservacao;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhuma Observação alterada');
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

function VerificaRequisicao(XObservacao: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XObservacao.TryGetValue('texto',wval) then
       wret := false;
    if not XObservacao.TryGetValue('data',wval) then
       wret := false;
  finally
  end;
  Result := wret;
end;

function ApagaObservacao(XIdObservacao: integer): TJSONObject;
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
         SQL.Add('delete from "PessoaObservacao" where "CodigoInternoObservacao"=:xid ');
         ParamByName('xid').AsInteger := XIdObservacao;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Observação excluída com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhuma Observação excluída');
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
