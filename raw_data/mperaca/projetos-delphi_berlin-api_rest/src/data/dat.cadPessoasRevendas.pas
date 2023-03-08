unit dat.cadPessoasRevendas;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaRevenda(XId: integer): TJSONObject;
function RetornaListaRevendas(const XQuery: TDictionary<string, string>; XIdPessoa: integer): TJSONArray;
function IncluiRevenda(XRevenda: TJSONObject; XIdPessoa: integer): TJSONObject;
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
         SQL.Add('select  "CodigoInternoPessoaRevenda" as id,');
         SQL.Add('        "CodigoPessoaRevenda"        as idpessoa,');
         SQL.Add('        "RevendaPessoaRevenda"       as idrevendapessoa,');
         SQL.Add('        "DataPessoaRevenda"          as data,');
         SQL.Add('        "OrcamentoPessoaRevenda"     as idorcamento ');
         SQL.Add('from "PessoaRevenda" ');
         SQL.Add('where "CodigoInternoPessoaRevenda"=:xid ');
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

function RetornaListaRevendas(const XQuery: TDictionary<string, string>; XIdPessoa: integer): TJSONArray;
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
         SQL.Add('select  "CodigoInternoPessoaRevenda" as id,');
         SQL.Add('        "CodigoPessoaRevenda"        as idpessoa,');
         SQL.Add('        "RevendaPessoaRevenda"       as idrevendapessoa,');
         SQL.Add('        "DataPessoaRevenda"          as data,');
         SQL.Add('        "OrcamentoPessoaRevenda"     as idorcamento ');
         SQL.Add('from "PessoaRevenda" where "CodigoPessoaRevenda"=:xidpessoa ');
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

function IncluiRevenda(XRevenda: TJSONObject; XIdPessoa: integer): TJSONObject;
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
           SQL.Add('Insert into "PessoaRevenda" ("CodigoPessoaRevenda","RevendaPessoaRevenda","DataPessoaRevenda","OrcamentoPessoaRevenda") ');
           SQL.Add('values (:xidpessoa,(case when :xidrevendapessoa>0 then :xidrevendapessoa else null end),:xdata,:xidorcamento) ');
           ParamByName('xidpessoa').AsInteger   := XIdPessoa;
           if XRevenda.TryGetValue('idrevendapessoa',wval) then
              ParamByName('xidrevendapessoa').AsInteger := strtointdef(XRevenda.GetValue('idrevendapessoa').Value,0)
           else
              ParamByName('xidrevendapessoa').AsInteger := 0;
           if XRevenda.TryGetValue('data',wval) then
              ParamByName('xdata').AsDate := strtodatedef(XRevenda.GetValue('data').Value,0)
           else
              ParamByName('xdata').AsDate := 0;
           if XRevenda.TryGetValue('idorcamento',wval) then
              ParamByName('xidorcamento').AsInteger := strtointdef(XRevenda.GetValue('idorcamento').Value,0)
           else
              ParamByName('xidorcamento').AsInteger := 0;
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
                SQL.Add('select  "CodigoInternoPessoaRevenda" as id,');
                SQL.Add('        "CodigoPessoaRevenda"        as idpessoa,');
                SQL.Add('        "RevendaPessoaRevenda"       as idrevendapessoa,');
                SQL.Add('        "DataPessoaRevenda"          as data,');
                SQL.Add('        "OrcamentoPessoaRevenda"     as idorcamento ');
                SQL.Add('from "PessoaRevenda" where "CodigoPessoaRevenda"=:xidpessoa and "DataPessoaRevenda"=:xdata ');
                ParamByName('xidpessoa').AsInteger  := XIdPessoa;
                if XRevenda.TryGetValue('data',wval) then
                   ParamByName('xdata').AsDate := strtodatedef(XRevenda.GetValue('data').Value,0)
                else
                   ParamByName('xdata').AsDate := 0;
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
    if XRevenda.TryGetValue('idrevendapessoa',wval) then
       begin
         if wcampos='' then
            wcampos := '"RevendaPessoaRevenda"=:xidrevendapessoa'
         else
            wcampos := wcampos+',"RevendaPessoaRevenda"=:xidrevendapessoa';
       end;
    if XRevenda.TryGetValue('data',wval) then
       begin
         if wcampos='' then
            wcampos := '"DataPessoaRevenda"=:xdata'
         else
            wcampos := wcampos+',"DataPessoaRevenda"=:xdata';
       end;
    if XRevenda.TryGetValue('idorcamento',wval) then
       begin
         if wcampos='' then
            wcampos := '"OrcamentoPessoaRevenda"=:xidorcamento'
         else
            wcampos := wcampos+',"OrcamentoPessoaRevenda"=:xidorcamento';
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
           SQL.Add('Update "PessoaRevenda" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoPessoaRevenda"=:xid ');
           ParamByName('xid').AsInteger               := XIdRevenda;
           if XRevenda.TryGetValue('idrevendapessoa',wval) then
              ParamByName('xidrevendapessoa').AsInteger     := strtointdef(XRevenda.GetValue('idrevendapessoa').Value,0);
           if XRevenda.TryGetValue('data',wval) then
              ParamByName('xdata').AsDate                   := strtodatedef(XRevenda.GetValue('data').Value,0);
           if XRevenda.TryGetValue('idorcamento',wval) then
              ParamByName('xidorcamento').AsInteger         := strtointdef(XRevenda.GetValue('idorcamento').Value,0);
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
              SQL.Add('select  "CodigoInternoPessoaRevenda" as id,');
              SQL.Add('        "CodigoPessoaRevenda"        as idpessoa,');
              SQL.Add('        "RevendaPessoaRevenda"       as idrevendapessoa,');
              SQL.Add('        "DataPessoaRevenda"          as data,');
              SQL.Add('        "OrcamentoPessoaRevenda"     as idorcamento ');
              SQL.Add('from "PessoaRevenda" ');
              SQL.Add('where "CodigoInternoPessoaRevenda" =:xid ');
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
    if not XRevenda.TryGetValue('data',wval) then
       wret := false;
    if not XRevenda.TryGetValue('idrevendapessoa',wval) then
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
         SQL.Add('delete from "PessoaRevenda" where "CodigoInternoPessoaRevenda"=:xid ');
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
