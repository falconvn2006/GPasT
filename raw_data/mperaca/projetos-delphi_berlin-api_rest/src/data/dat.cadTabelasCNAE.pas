unit dat.cadTabelasCNAE;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaTabela(XId: integer): TJSONObject;
function RetornaListaTabelas(const XQuery: TDictionary<string, string>): TJSONArray;
function IncluiTabela(XTabela: TJSONObject): TJSONObject;
function AlteraTabela(XIdTabela: integer; XTabela: TJSONObject): TJSONObject;
function ApagaTabela(XIdTabela: integer): TJSONObject;
function VerificaRequisicao(XTabela: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaTabela(XId: integer): TJSONObject;
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
         SQL.Add('select  "CodigoInternoTabelaCNAE" as id,');
         SQL.Add('        "CodigoTabelaCNAE"        as codigo,');
         SQL.Add('        "DenominacaoTabelaCNAE"   as denominacao ');
         SQL.Add('from "TabelaCNAE" ');
         SQL.Add('where "CodigoInternoTabelaCNAE"=:xid ');
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
        wret.AddPair('description','Nenhuma Tabela CNAE encontrada');
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

function RetornaListaTabelas(const XQuery: TDictionary<string, string>): TJSONArray;
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
         SQL.Add('select  "CodigoInternoTabelaCNAE" as id,');
         SQL.Add('        "CodigoTabelaCNAE"        as codigo,');
         SQL.Add('        "DenominacaoTabelaCNAE"   as denominacao ');
         SQL.Add('from "TabelaCNAE" where "CodigoEmpresaTabelaCNAE"=:xempresa ');
         ParamByName('xempresa').AsInteger := wconexao.FIdEmpresaSituacaoTributaria;
         if XQuery.ContainsKey('codigo') then // filtro por codigo
            begin
              SQL.Add('and "CodigoTabelaCNAE" =:xcodigo ');
              ParamByName('xcodigo').AsString := XQuery.Items['codigo'];
              SQL.Add('order by "CodigoTabelaCNAE" ');
            end;
         if XQuery.ContainsKey('denominacao') then // filtro por denominação
            begin
              SQL.Add('and lower("DenominacaoTabelaCNAE") like lower(:xdenominacao) ');
              ParamByName('xdenominacao').AsString := XQuery.Items['denominacao']+'%';
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
         wobj.AddPair('description','Nenhuma Tabela CNAE encontrada');
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

function IncluiTabela(XTabela: TJSONObject): TJSONObject;
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
           SQL.Add('Insert into "TabelaCNAE" ("CodigoEmpresaTabelaCNAE","CodigoTabelaCNAE","DenominacaoTabelaCNAE") ');
           SQL.Add('values (:xidempresa,:xcodigo,:xdenominacao) ');
           ParamByName('xidempresa').AsInteger     := wconexao.FIdEmpresa;
           if XTabela.TryGetValue('codigo',wval) then
              ParamByName('xcodigo').AsString  := XTabela.GetValue('codigo').Value
           else
              ParamByName('xcodigo').AsString  := '';
           if XTabela.TryGetValue('denominacao',wval) then
              ParamByName('xdenominacao').AsString  := XTabela.GetValue('denominacao').Value
           else
              ParamByName('xdenominacao').AsString  := '';
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
                SQL.Add('select  "CodigoInternoTabelaCNAE" as id,');
                SQL.Add('        "CodigoTabelaCNAE"        as codigo,');
                SQL.Add('        "DenominacaoTabelaCNAE"   as denominacao ');
                SQL.Add('from "TabelaCNAE" where "CodigoEmpresaTabelaCNAE"=:xempresa and "CodigoTabelaCNAE"=:xcodigo ');
                ParamByName('xempresa').AsInteger  := wconexao.FIdEmpresaSituacaoTributaria;
                if XTabela.TryGetValue('codigo',wval) then
                   ParamByName('xcodigo').AsString  := XTabela.GetValue('codigo').Value
                else
                   ParamByName('xcodigo').AsString  := '';
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhuma Tabela CNAE incluída');
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


function AlteraTabela(XIdTabela: integer; XTabela: TJSONObject): TJSONObject;
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
    if XTabela.TryGetValue('codigo',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoTabelaCNAE"=:xcodigo'
         else
            wcampos := wcampos+',"CodigoTabelaCNAE"=:xcodigo';
       end;
    if XTabela.TryGetValue('denominacao',wval) then
       begin
         if wcampos='' then
            wcampos := '"DenominacaoTabelaCNAE"=:xdenominacao'
         else
            wcampos := wcampos+',"DenominacaoTabelaCNAE"=:xdenominacao';
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
           SQL.Add('Update "TabelaCNAE" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoTabelaCNAE"=:xid ');
           ParamByName('xid').AsInteger            := XIdTabela;
           if XTabela.TryGetValue('codigo',wval) then
              ParamByName('xcodigo').AsString      := XTabela.GetValue('codigo').Value;
           if XTabela.TryGetValue('denominacao',wval) then
              ParamByName('xdenominacao').AsString := XTabela.GetValue('denominacao').Value;
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
              SQL.Add('select  "CodigoInternoTabelaCNAE" as id,');
              SQL.Add('        "CodigoTabelaCNAE"        as codigo,');
              SQL.Add('        "DenominacaoTabelaCNAE"   as denominacao ');
              SQL.Add('from "TabelaCNAE" ');
              SQL.Add('where "CodigoInternoTabelaCNAE" =:xid ');
              ParamByName('xid').AsInteger := XIdTabela;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhuma Tabela CNAE alterada');
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

function VerificaRequisicao(XTabela: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XTabela.TryGetValue('codigo',wval) then
       wret := false;
    if not XTabela.TryGetValue('denominacao',wval) then
       wret := false;
  finally
  end;
  Result := wret;
end;

function ApagaTabela(XIdTabela: integer): TJSONObject;
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
         SQL.Add('delete from "TabelaCNAE" where "CodigoInternoTabelaCNAE"=:xid ');
         ParamByName('xid').AsInteger := XIdTabela;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Tabela CNAE excluída com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhuma Tabela CNAE excluída');
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
