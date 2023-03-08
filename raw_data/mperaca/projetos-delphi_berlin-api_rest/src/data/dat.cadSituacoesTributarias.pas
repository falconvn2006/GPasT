unit dat.cadSituacoesTributarias;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaSituacao(XId: integer): TJSONObject;
function RetornaListaSituacoes(const XQuery: TDictionary<string, string>): TJSONArray;
function IncluiSituacao(XSituacao: TJSONObject): TJSONObject;
function AlteraSituacao(XIdSituacao: integer; XSituacao: TJSONObject): TJSONObject;
function ApagaSituacao(XIdSituacao: integer): TJSONObject;
function VerificaRequisicao(XSituacao: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaSituacao(XId: integer): TJSONObject;
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
         SQL.Add('select  "CodigoInternoTributaria" as id,');
         SQL.Add('        "CodigoTabelaATributaria" as codtabelaA,');
         SQL.Add('        "CodigoTabelaBTributaria" as codtabelaB,');
         SQL.Add('        "CodigoFiscalTributaria"  as idcodigofiscal,');
         SQL.Add('        "CodigoFiscalEntradaTributaria" as idcodigofiscalentrada,');
         SQL.Add('        "CSONSimplesNacionalTributaria" as csonsimples ');
         SQL.Add('from "SituacaoTributaria" ');
         SQL.Add('where "CodigoInternoTributaria"=:xid ');
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
        wret.AddPair('description','Nenhuma Situação Tributária encontrada');
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

function RetornaListaSituacoes(const XQuery: TDictionary<string, string>): TJSONArray;
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
         SQL.Add('select  "CodigoInternoTributaria" as id,');
         SQL.Add('        "CodigoTabelaATributaria" as codtabelaA,');
         SQL.Add('        "CodigoTabelaBTributaria" as codtabelaB,');
         SQL.Add('        "CodigoFiscalTributaria"  as idcodigofiscal,');
         SQL.Add('        "CodigoFiscalEntradaTributaria" as idcodigofiscalentrada,');
         SQL.Add('        "CSONSimplesNacionalTributaria" as csonsimples ');
         SQL.Add('from "SituacaoTributaria" where "CodigoEmpresaTributaria"=:xempresa ');
         ParamByName('xempresa').AsInteger := wconexao.FIdEmpresaSituacaoTributaria;
         if XQuery.ContainsKey('codtabelaA') then // filtro por codigo A
            begin
              SQL.Add('and "CodigoTabelaATributaria" =:xcodtabelaA ');
              ParamByName('xcodtabelaA').AsString := XQuery.Items['codtabelaA'];
              SQL.Add('order by "CodigoTabelaATributaria" ');
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
         wobj.AddPair('description','Nenhuma Situação Tributária encontrada');
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

function IncluiSituacao(XSituacao: TJSONObject): TJSONObject;
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
           SQL.Add('Insert into "SituacaoTributaria" ("CodigoEmpresaTributaria","CodigoTabelaATributaria","CodigoTabelaBTributaria",');
           SQL.Add('"CodigoFiscalTributaria","CodigoFiscalEntradaTributaria","CSONSimplesNacionalTributaria") ');
           SQL.Add('values (:xidempresa,:xcodtabelaA,:xcodtabelaB,(case when :xidcodigofiscal>0 then :xidcodigofiscal else null end),(case when :xidcodigofiscalentrada>0 then :xidcodigofiscalentrada else null end),:xcsonsimples) ');
           ParamByName('xidempresa').AsInteger     := wconexao.FIdEmpresaSituacaoTributaria;
           if XSituacao.TryGetValue('codtabelaA',wval) then
              ParamByName('xcodtabelaA').AsString  := XSituacao.GetValue('codtabelaA').Value
           else
              ParamByName('xcodtabelaA').AsString  := '';
           if XSituacao.TryGetValue('codtabelaB',wval) then
              ParamByName('xcodtabelaB').AsString  := XSituacao.GetValue('codtabelaB').Value
           else
              ParamByName('xcodtabelaB').AsString  := '';
           if XSituacao.TryGetValue('idcodigofiscal',wval) then
              ParamByName('xidcodigofiscal').AsInteger := strtointdef(XSituacao.GetValue('idcodigofiscal').Value,0)
           else
              ParamByName('xidcodigofiscal').AsInteger  := 0;
           if XSituacao.TryGetValue('idcodigofiscalentrada',wval) then
              ParamByName('xidcodigofiscalentrada').AsInteger := strtointdef(XSituacao.GetValue('idcodigofiscalentrada').Value,0)
           else
              ParamByName('xidcodigofiscalentrada').AsInteger  := 0;
           if XSituacao.TryGetValue('csonsimples',wval) then
              ParamByName('xcsonsimples').AsString  := XSituacao.GetValue('csonsimples').Value
           else
              ParamByName('xcsonsimples').AsString  := '';
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
                SQL.Add('select  "CodigoInternoTributaria" as id,');
                SQL.Add('        "CodigoTabelaATributaria" as codtabelaA,');
                SQL.Add('        "CodigoTabelaBTributaria" as codtabelaB,');
                SQL.Add('        "CodigoFiscalTributaria"  as idcodigofiscal,');
                SQL.Add('        "CodigoFiscalEntradaTributaria" as idcodigofiscalentrada,');
                SQL.Add('        "CSONSimplesNacionalTributaria" as csonsimples ');
                SQL.Add('from "SituacaoTributaria" where "CodigoEmpresaTributaria"=:xempresa and "CodigoTabelaATributaria"=:xcodtabelaA and "CodigoTabelaBTributaria"=:xcodtabelaB ');
                ParamByName('xempresa').AsInteger  := wconexao.FIdEmpresaSituacaoTributaria;
                if XSituacao.TryGetValue('codtabelaA',wval) then
                   ParamByName('xcodtabelaA').AsString  := XSituacao.GetValue('codtabelaA').Value
                else
                   ParamByName('xcodtabelaA').AsString  := '';
                if XSituacao.TryGetValue('codtabelaB',wval) then
                   ParamByName('xcodtabelaB').AsString  := XSituacao.GetValue('codtabelaB').Value
                else
                   ParamByName('xcodtabelaB').AsString  := '';
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Setor incluído');
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


function AlteraSituacao(XIdSituacao: integer; XSituacao: TJSONObject): TJSONObject;
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
    if XSituacao.TryGetValue('codtabelaA',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoTabelaATributaria"=:xcodtabelaA'
         else
            wcampos := wcampos+',"CodigoTabelaATributaria"=:xcodtabelaA';
       end;
    if XSituacao.TryGetValue('codtabelaB',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoTabelaBTributaria"=:xcodtabelaB'
         else
            wcampos := wcampos+',"CodigoTabelaBTributaria"=:xcodtabelaB';
       end;
    if XSituacao.TryGetValue('idcodigofiscal',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoFiscalTributaria"=:xidcodigofiscal'
         else
            wcampos := wcampos+',"CodigoFiscalTributaria"=:xidcodigofiscal';
       end;
    if XSituacao.TryGetValue('idcodigofiscalentrada',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoFiscalEntradaTributaria"=:xidcodigofiscalentrada'
         else
            wcampos := wcampos+',"CodigoFiscalEntradaTributaria"=:xidcodigofiscalentrada';
       end;
    if XSituacao.TryGetValue('csonsimples',wval) then
       begin
         if wcampos='' then
            wcampos := '"CSONSimplesNacionalTributaria"=:xcsonsimples'
         else
            wcampos := wcampos+',"CSONSimplesNacionalTributaria"=:xcsonsimples';
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
           SQL.Add('Update "SituacaoTributaria" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoTributaria"=:xid ');
           ParamByName('xid').AsInteger       := XIdSituacao;
           if XSituacao.TryGetValue('codtabelaA',wval) then
              ParamByName('xcodtabelaA').AsString   := XSituacao.GetValue('codtabelaA').Value;
           if XSituacao.TryGetValue('codtabelaB',wval) then
              ParamByName('xcodtabelaB').AsString   := XSituacao.GetValue('codtabelaB').Value;
           if XSituacao.TryGetValue('idcodigofiscal',wval) then
              ParamByName('xidcodigofiscal').AsInteger := strtointdef(XSituacao.GetValue('idcodigofiscal').Value,0);
           if XSituacao.TryGetValue('idcodigofiscalentrada',wval) then
              ParamByName('xidcodigofiscalentrada').AsInteger := strtointdef(XSituacao.GetValue('idcodigofiscalentrada').Value,0);
           if XSituacao.TryGetValue('csonsimples',wval) then
              ParamByName('xcsonsimples').AsString   := XSituacao.GetValue('csonsimples').Value;
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
              SQL.Add('select  "CodigoInternoTributaria" as id,');
              SQL.Add('        "CodigoTabelaATributaria" as codtabelaA,');
              SQL.Add('        "CodigoTabelaBTributaria" as codtabelaB,');
              SQL.Add('        "CodigoFiscalTributaria"  as idcodigofiscal,');
              SQL.Add('        "CodigoFiscalEntradaTributaria" as idcodigofiscalentrada,');
              SQL.Add('        "CSONSimplesNacionalTributaria" as csonsimples ');
              SQL.Add('from "SituacaoTributaria" ');
              SQL.Add('where "CodigoInternoTributaria" =:xid ');
              ParamByName('xid').AsInteger := XIdSituacao;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhuma Situação Tributária alterada');
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

function VerificaRequisicao(XSituacao: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XSituacao.TryGetValue('codtabelaA',wval) then
       wret := false;
    if not XSituacao.TryGetValue('codtabelaB',wval) then
       wret := false;
  finally
  end;
  Result := wret;
end;

function ApagaSituacao(XIdSituacao: integer): TJSONObject;
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
         SQL.Add('delete from "SituacaoTributaria" where "CodigoInternoTributaria"=:xid ');
         ParamByName('xid').AsInteger := XIdSituacao;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Situação Tributária excluída com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhuma Situação Tributária excluída');
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
