unit dat.cadGrades;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaGrade(XId: integer): TJSONObject;
function RetornaListaGrades(const XQuery: TDictionary<string, string>): TJSONArray;
function IncluiGrade(XGrade: TJSONObject): TJSONObject;
function AlteraGrade(XIdGrade: integer; XGrade: TJSONObject): TJSONObject;
function ApagaGrade(XIdGrade: integer): TJSONObject;
function VerificaRequisicao(XGrade: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaGrade(XId: integer): TJSONObject;
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
         SQL.Add('select  "CodigoInternoGrade" as id,');
         SQL.Add('        "CodigoGrade"        as codigo,');
         SQL.Add('        "NomeGrade"          as nome,');
         SQL.Add('        "NumeroMinimoGrade"  as minimo,');
         SQL.Add('        "NumeroMaximoGrade"  as maximo,');
         SQL.Add('        "VariacaoGrade"      as variacao ');
         SQL.Add('from "Grade" ');
         SQL.Add('where "CodigoInternoGrade"=:xid ');
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
        wret.AddPair('description','Nenhuma Grade encontrada');
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

function RetornaListaGrades(const XQuery: TDictionary<string, string>): TJSONArray;
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
         SQL.Add('select  "CodigoInternoGrade" as id,');
         SQL.Add('        "CodigoGrade"        as codigo,');
         SQL.Add('        "NomeGrade"          as nome,');
         SQL.Add('        "NumeroMinimoGrade"  as minimo,');
         SQL.Add('        "NumeroMaximoGrade"  as maximo,');
         SQL.Add('        "VariacaoGrade"      as variacao ');
         SQL.Add('from "Grade" where "CodigoEmpresaGrade"=:xempresa ');
         ParamByName('xempresa').AsInteger := wconexao.FIdEmpresaGrade;
         if XQuery.ContainsKey('nome') then // filtro por nome
            begin
              SQL.Add('and lower("NomeGrade") like lower(:xnome) ');
              ParamByName('xnome').AsString := XQuery.Items['nome']+'%';
              SQL.Add('order by "NomeGrade" ');
            end;
         if XQuery.ContainsKey('codigo') then // filtro por nome
            begin
              SQL.Add('and "NomeGrade" =:xcodigo ');
              ParamByName('xcodigo').AsInteger := strtointdef(XQuery.Items['codigo'],0);
              SQL.Add('order by "CodigoGrade" ');
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
         wobj.AddPair('description','Nenhuma Grade encontrada');
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

function IncluiGrade(XGrade: TJSONObject): TJSONObject;
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
           SQL.Add('Insert into "Grade" ("CodigoEmpresaGrade","CodigoGrade","NomeGrade","NumeroMinimoGrade","NumeroMaximoGrade","VariacaoGrade") ');
           SQL.Add('values (:xidempresa,:xcodigo,:xnome,:xminimo,:xmaximo,:xvariacao) ');
           ParamByName('xidempresa').AsInteger   := wconexao.FIdEmpresaGrade;
           ParamByName('xcodigo').AsInteger      := strtointdef(XGrade.GetValue('codigo').Value,0);
           ParamByName('xnome').AsString         := XGrade.GetValue('nome').Value;
           if XGrade.TryGetValue('minimo',wval) then
              ParamByName('xminimo').AsInteger   := strtointdef(XGrade.GetValue('minimo').Value,0)
           else
              ParamByName('xminimo').AsInteger   := 0;
           if XGrade.TryGetValue('maximo',wval) then
              ParamByName('xmaximo').AsInteger   := strtointdef(XGrade.GetValue('maximo').Value,0)
           else
              ParamByName('xmaximo').AsInteger   := 0;
           if XGrade.TryGetValue('variacao',wval) then
              ParamByName('xvariacao').AsInteger   := strtointdef(XGrade.GetValue('variacao').Value,0)
           else
              ParamByName('xvariacao').AsInteger   := 0;
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
                SQL.Add('select  "CodigoInternoGrade" as id,');
                SQL.Add('        "CodigoGrade"        as codigo,');
                SQL.Add('        "NomeGrade"          as nome,');
                SQL.Add('        "NumeroMinimoGrade"  as minimo,');
                SQL.Add('        "NumeroMaximoGrade"  as maximo,');
                SQL.Add('        "VariacaoGrade"      as variacao ');
                SQL.Add('from "Grade" where "CodigoEmpresaGrade"=:xempresa and "CodigoGrade"=:xcodigo ');
                ParamByName('xempresa').AsInteger  := wconexao.FIdEmpresaGrade;
                ParamByName('xcodigo').AsInteger   := strtointdef(XGrade.GetValue('codigo').Value,0);
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhuma Grade incluída');
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


function AlteraGrade(XIdGrade: integer; XGrade: TJSONObject): TJSONObject;
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
    if XGrade.TryGetValue('codigo',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoGrade"=:xcodigo'
         else
            wcampos := wcampos+',"CodigoGrade"=:xcodigo';
       end;
    if XGrade.TryGetValue('nome',wval) then
       begin
         if wcampos='' then
            wcampos := '"NomeGrade"=:xnome'
         else
            wcampos := wcampos+',"NomeGrade"=:xnome';
       end;
    if XGrade.TryGetValue('minimo',wval) then
       begin
         if wcampos='' then
            wcampos := '"NumeroMinimoGrade"=:xminimo'
         else
            wcampos := wcampos+',"NumeroMinimoGrade"=:xminimo';
       end;
    if XGrade.TryGetValue('maximo',wval) then
       begin
         if wcampos='' then
            wcampos := '"NumeroMaximoGrade"=:xmaximo'
         else
            wcampos := wcampos+',"NumeroMaximoGrade"=:xmaximo';
       end;
    if XGrade.TryGetValue('variacao',wval) then
       begin
         if wcampos='' then
            wcampos := '"VariacaoGrade"=:xvariacao'
         else
            wcampos := wcampos+',"VariacaoGrade"=:xvariacao';
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
           SQL.Add('Update "Grade" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoGrade"=:xid ');
           ParamByName('xid').AsInteger       := XIdGrade;
           if XGrade.TryGetValue('codigo',wval) then
              ParamByName('xcodigo').AsInteger   := strtointdef(XGrade.GetValue('codigo').Value,0);
           if XGrade.TryGetValue('nome',wval) then
              ParamByName('xnome').AsString      := XGrade.GetValue('nome').Value;
           if XGrade.TryGetValue('minimo',wval) then
              ParamByName('xminimo').AsInteger   := strtointdef(XGrade.GetValue('minimo').Value,0);
           if XGrade.TryGetValue('maximo',wval) then
              ParamByName('xmaximo').AsInteger   := strtointdef(XGrade.GetValue('maximo').Value,0);
           if XGrade.TryGetValue('variacao',wval) then
              ParamByName('xvariacao').AsInteger := strtointdef(XGrade.GetValue('variacao').Value,0);
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
              SQL.Add('select  "CodigoInternoGrade" as id,');
              SQL.Add('        "CodigoGrade"        as codigo,');
              SQL.Add('        "NomeGrade"          as nome,');
              SQL.Add('        "NumeroMinimoGrade"  as minimo,');
              SQL.Add('        "NumeroMaximoGrade"  as maximo,');
              SQL.Add('        "VariacaoGrade"      as variacao ');
              SQL.Add('from "Grade" ');
              SQL.Add('where "CodigoInternoGrade" =:xid ');
              ParamByName('xid').AsInteger := XIdGrade;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhuma Grade alterada');
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

function VerificaRequisicao(XGrade: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XGrade.TryGetValue('codigo',wval) then
       wret := false;
    if not XGrade.TryGetValue('nome',wval) then
       wret := false;
  finally
  end;
  Result := wret;
end;

function ApagaGrade(XIdGrade: integer): TJSONObject;
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
         SQL.Add('delete from "Grade" where "CodigoInternoGrade"=:xid ');
         ParamByName('xid').AsInteger := XIdGrade;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Grade excluída com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhuma Grade excluída');
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
