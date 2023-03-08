unit dat.cadPessoasFrequencias;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaFrequencia(XId: integer): TJSONObject;
function RetornaListaFrequencias(const XQuery: TDictionary<string, string>; XIdPessoa: integer): TJSONArray;
function IncluiFrequencia(XFrequencia: TJSONObject; XIdPessoa: integer): TJSONObject;
function AlteraFrequencia(XIdFrequencia: integer; XFrequencia: TJSONObject): TJSONObject;
function ApagaFrequencia(XIdFrequencia: integer): TJSONObject;
function VerificaRequisicao(XFrequencia: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaFrequencia(XId: integer): TJSONObject;
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
         SQL.Add('select  "CodigoInternoPessoaFrequencia" as id,');
         SQL.Add('        "CodigoClientePessoaFrequencia" as idpessoa,');
         SQL.Add('        "DataPessoaFrequencia"          as data,');
         SQL.Add('        "ContratoPessoaFrequencia"      as idcontrato,');
         SQL.Add('        "ObservacaoPessoaFrequencia"    as observacao,');
         SQL.Add('        "HoraPessoaFrequencia"          as hora ');
         SQL.Add('from "PessoaFrequencia" ');
         SQL.Add('where "CodigoInternoPessoaFrequencia"=:xid ');
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
        wret.AddPair('description','Nenhuma Frequência encontrada');
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

function RetornaListaFrequencias(const XQuery: TDictionary<string, string>; XIdPessoa: integer): TJSONArray;
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
         SQL.Add('select  "CodigoInternoPessoaFrequencia" as id,');
         SQL.Add('        "CodigoClientePessoaFrequencia" as idpessoa,');
         SQL.Add('        "DataPessoaFrequencia"          as data,');
         SQL.Add('        "ContratoPessoaFrequencia"      as idcontrato,');
         SQL.Add('        "ObservacaoPessoaFrequencia"    as observacao,');
         SQL.Add('        "HoraPessoaFrequencia"          as hora ');
         SQL.Add('from "PessoaFrequencia" where "CodigoClientePessoaFrequencia"=:xidpessoa ');
         ParamByName('xidpessoa').AsInteger := XIdPessoa;;
         if XQuery.ContainsKey('data') then // filtro por data
            begin
              SQL.Add('and "DataPessoaFrequencia" =:xdata ');
              ParamByName('xdata').AsDate:= strtodatedef(XQuery.Items['data'],0);
              SQL.Add('order by "DataPessoaFrequencia" ');
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
         wobj.AddPair('description','Nenhuma Frequência encontrada');
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

function IncluiFrequencia(XFrequencia: TJSONObject; XIdPessoa: integer): TJSONObject;
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
           SQL.Add('Insert into "PessoaFrequencia" ("CodigoEmpresaPessoaFrequencia","CodigoClientePessoaFrequencia","DataPessoaFrequencia",');
           SQL.Add('"ContratoPessoaFrequencia","ObservacaoPessoaFrequencia","HoraPessoaFrequencia") ');
           SQL.Add('values (:xidempresa,:xidpessoa,:xdata,');
           SQL.Add('(case when :xidcontrato>0 then :xidcontrato else null end),:xobservacao,:xhora) ');
           ParamByName('xidempresa').AsInteger  := wconexao.FIdEmpresa;
           ParamByName('xidpessoa').AsInteger   := XIdPessoa;
           if XFrequencia.TryGetValue('data',wval) then
              ParamByName('xdata').AsDate := strtodatedef(XFrequencia.GetValue('data').Value,0)
           else
              ParamByName('xdata').AsDate := 0;
           if XFrequencia.TryGetValue('idcontrato',wval) then
              ParamByName('xidcontrato').AsInteger := strtointdef(XFrequencia.GetValue('idcontrato').Value,0)
           else
              ParamByName('xidcontrato').AsInteger := 0;
           if XFrequencia.TryGetValue('observacao',wval) then
              ParamByName('xobservacao').AsString := XFrequencia.GetValue('observacao').Value
           else
              ParamByName('xobservacao').AsString := '';
           if XFrequencia.TryGetValue('hora',wval) then
              ParamByName('xhora').AsString := XFrequencia.GetValue('hora').Value
           else
              ParamByName('xhora').AsString := '';
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
                SQL.Add('select  "CodigoInternoPessoaFrequencia" as id,');
                SQL.Add('        "CodigoClientePessoaFrequencia" as idpessoa,');
                SQL.Add('        "DataPessoaFrequencia"          as data,');
                SQL.Add('        "ContratoPessoaFrequencia"      as idcontrato,');
                SQL.Add('        "ObservacaoPessoaFrequencia"    as observacao,');
                SQL.Add('        "HoraPessoaFrequencia"          as hora ');
                SQL.Add('from "PessoaFrequencia" where "CodigoClientePessoaFrequencia"=:xidpessoa and "DataPessoaFrequencia"=:xdata ');
                ParamByName('xidpessoa').AsInteger  := XIdPessoa;
                if XFrequencia.TryGetValue('data',wval) then
                   ParamByName('xdata').AsDate := strtodatedef(XFrequencia.GetValue('data').Value,0)
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
              wret.AddPair('description','Nenhuma Frequência incluída');
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

function AlteraFrequencia(XIdFrequencia: integer; XFrequencia: TJSONObject): TJSONObject;
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
    if XFrequencia.TryGetValue('data',wval) then
       begin
         if wcampos='' then
            wcampos := '"DataPessoaFrequencia"=:xdata'
         else
            wcampos := wcampos+',"DataPessoaFrequencia"=:xdata';
       end;
    if XFrequencia.TryGetValue('idcontrato',wval) then
       begin
         if wcampos='' then
            wcampos := '"ContratoPessoaFrequencia"=:xidcontrato'
         else
            wcampos := wcampos+',"ContratoPessoaFrequencia"=:xidcontrato';
       end;
    if XFrequencia.TryGetValue('observacao',wval) then
       begin
         if wcampos='' then
            wcampos := '"ObservacaoPessoaFrequencia"=:xobservacao'
         else
            wcampos := wcampos+',"ObservacaoPessoaFrequencia"=:xobservacao';
       end;
    if XFrequencia.TryGetValue('hora',wval) then
       begin
         if wcampos='' then
            wcampos := '"HoraPessoaFrequencia"=:xhora'
         else
            wcampos := wcampos+',"HoraPessoaFrequencia"=:xhora';
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
           SQL.Add('Update "PessoaFrequencia" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoPessoaFrequencia"=:xid ');
           ParamByName('xid').AsInteger                := XIdFrequencia;
           if XFrequencia.TryGetValue('data',wval) then
              ParamByName('xdata').AsDate              := strtodatedef(XFrequencia.GetValue('data').Value,0);
           if XFrequencia.TryGetValue('idcontrato',wval) then
              ParamByName('xidcontrato').AsInteger     := strtointdef(XFrequencia.GetValue('idcontrato').Value,0);
           if XFrequencia.TryGetValue('observacao',wval) then
              ParamByName('xobservacao').AsString      := XFrequencia.GetValue('observacao').Value;
           if XFrequencia.TryGetValue('hora',wval) then
              ParamByName('xhora').AsString            := XFrequencia.GetValue('hora').Value;
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
              SQL.Add('select  "CodigoInternoPessoaFrequencia" as id,');
              SQL.Add('        "CodigoClientePessoaFrequencia" as idpessoa,');
              SQL.Add('        "DataPessoaFrequencia"          as data,');
              SQL.Add('        "ContratoPessoaFrequencia"      as idcontrato,');
              SQL.Add('        "ObservacaoPessoaFrequencia"    as observacao,');
              SQL.Add('        "HoraPessoaFrequencia"          as hora ');
              SQL.Add('from "PessoaFrequencia" ');
              SQL.Add('where "CodigoInternoPessoaFrequencia" =:xid ');
              ParamByName('xid').AsInteger := XIdFrequencia;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhuma Frequência alterada');
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

function VerificaRequisicao(XFrequencia: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XFrequencia.TryGetValue('data',wval) then
       wret := false;
  finally
  end;
  Result := wret;
end;

function ApagaFrequencia(XIdFrequencia: integer): TJSONObject;
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
         SQL.Add('delete from "PessoaFrequencia" where "CodigoInternoPessoaFrequencia"=:xid ');
         ParamByName('xid').AsInteger := XIdFrequencia;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Frequência excluída com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhuma Frequência excluída');
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
