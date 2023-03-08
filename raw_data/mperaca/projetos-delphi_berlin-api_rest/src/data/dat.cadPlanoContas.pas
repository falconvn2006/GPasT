unit dat.cadPlanoContas;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaPlano(XId: integer): TJSONObject;
function RetornaListaPlanos(const XQuery: TDictionary<string, string>): TJSONArray;
function IncluiPlano(XPlano: TJSONObject): TJSONObject;
function AlteraPlano(XIdPlano: integer; XPlano: TJSONObject): TJSONObject;
function ApagaPlano(XIdPlano: integer): TJSONObject;
function VerificaRequisicao(XPlano: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaPlano(XId: integer): TJSONObject;
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
         SQL.Add('select  "CodigoInternoPlano"     as id,');
         SQL.Add('        "EstruturalPlano"        as estrutural,');
         SQL.Add('        "NomeContaPlano"         as nomeconta,');
         SQL.Add('        "CodigoReduzidoPlano"    as codreduzido,');
         SQL.Add('        "AncestralConta1Plano"   as idancestral1,');
         SQL.Add('        "AncestralConta2Plano"   as idancestral2,');
         SQL.Add('        "AncestralConta3Plano"   as idancestral3,');
         SQL.Add('        "AncestralConta4Plano"   as idancestral4,');
         SQL.Add('        "AncestralConta5Plano"   as idancestral5,');
         SQL.Add('        "AncestralConta6Plano"   as idancestral6,');
         SQL.Add('        "AncestralConta7Plano"   as idancestral7,');
         SQL.Add('        "TipoContaPlano"         as tipoconta,');
         SQL.Add('        "CodigoPlanoReferencial" as idplanoreferencial,');
         SQL.Add('        "CodigoNaturezaPlano"    as codnatureza ');
         SQL.Add('from "PlanodeConta" ');
         SQL.Add('where "CodigoInternoPlano"=:xid ');
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
        wret.AddPair('description','Nenhum Plano de Contas encontrado');
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

function RetornaListaPlanos(const XQuery: TDictionary<string, string>): TJSONArray;
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
         SQL.Add('select  "CodigoInternoPlano"     as id,');
         SQL.Add('        "EstruturalPlano"        as estrutural,');
         SQL.Add('        "NomeContaPlano"         as nomeconta,');
         SQL.Add('        "CodigoReduzidoPlano"    as codreduzido,');
         SQL.Add('        "AncestralConta1Plano"   as idancestral1,');
         SQL.Add('        "AncestralConta2Plano"   as idancestral2,');
         SQL.Add('        "AncestralConta3Plano"   as idancestral3,');
         SQL.Add('        "AncestralConta4Plano"   as idancestral4,');
         SQL.Add('        "AncestralConta5Plano"   as idancestral5,');
         SQL.Add('        "AncestralConta6Plano"   as idancestral6,');
         SQL.Add('        "AncestralConta7Plano"   as idancestral7,');
         SQL.Add('        "TipoContaPlano"         as tipoconta,');
         SQL.Add('        "CodigoPlanoReferencial" as idplanoreferencial,');
         SQL.Add('        "CodigoNaturezaPlano"    as codnatureza ');
         SQL.Add('from "PlanodeConta" where "CodigoEmpresaPlano"=:xidempresa ');
         ParamByName('xidempresa').AsInteger := wconexao.FIdEmpresaPlanoContas;
         Open;
         EnableControls;
       end;
    if wqueryLista.RecordCount>0 then
       wret := wqueryLista.ToJSONArray()
    else
       begin
         wobj := TJSONObject.Create;
         wobj.AddPair('status','500');
         wobj.AddPair('description','Nenhum Plano de Contas encontrado');
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

function IncluiPlano(XPlano: TJSONObject): TJSONObject;
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
           SQL.Add('Insert into "PlanodeConta" ("CodigoEmpresaPlano","EstruturalPlano","NomeContaPlano","CodigoReduzidoPlano",');
           SQL.Add('"AncestralConta1Plano","AncestralConta2Plano","AncestralConta3Plano","AncestralConta4Plano","AncestralConta5Plano",');
           SQL.Add('"AncestralConta6Plano","AncestralConta7Plano","TipoContaPlano","CodigoPlanoReferencial","CodigoNaturezaPlano") ');
           SQL.Add('values (:xidempresa,:xestrutural,:xnomeconta,:xcodreduzido,');
           SQL.Add(':xidancestral1,:xidancestral2,:xidancestral3,:xidancestral4,:xidancestral5,');
           SQL.Add(':xidancestral6,:xidancestral7,:xtipoconta,(case when :xidplanoreferencial>0 then :xidplanoreferencial else null end),:xcodnatureza) ');
           ParamByName('xidempresa').AsInteger   := wconexao.FIdEmpresaPlanoContas;
           if XPlano.TryGetValue('estrutural',wval) then
              ParamByName('xestrutural').AsString := XPlano.GetValue('estrutural').Value
           else
              ParamByName('xestrutural').AsString := '';
           if XPlano.TryGetValue('nomeconta',wval) then
              ParamByName('xnomeconta').AsString := XPlano.GetValue('nomeconta').Value
           else
              ParamByName('xnomeconta').AsString := '';
           if XPlano.TryGetValue('codreduzido',wval) then
              ParamByName('xcodreduzido').AsInteger := strtointdef(XPlano.GetValue('codreduzido').Value,0)
           else
              ParamByName('xcodreduzido').AsInteger := 0;
           if XPlano.TryGetValue('idancestral1',wval) then
              ParamByName('xidancestral1').AsInteger := strtointdef(XPlano.GetValue('idancestral1').Value,0)
           else
              ParamByName('xidancestral1').AsInteger := 0;
           if XPlano.TryGetValue('idancestral2',wval) then
              ParamByName('xidancestral2').AsInteger := strtointdef(XPlano.GetValue('idancestral2').Value,0)
           else
              ParamByName('xidancestral2').AsInteger := 0;
           if XPlano.TryGetValue('idancestral3',wval) then
              ParamByName('xidancestral3').AsInteger := strtointdef(XPlano.GetValue('idancestral3').Value,0)
           else
              ParamByName('xidancestral3').AsInteger := 0;
           if XPlano.TryGetValue('idancestral4',wval) then
              ParamByName('xidancestral4').AsInteger := strtointdef(XPlano.GetValue('idancestral4').Value,0)
           else
              ParamByName('xidancestral4').AsInteger := 0;
           if XPlano.TryGetValue('idancestral5',wval) then
              ParamByName('xidancestral5').AsInteger := strtointdef(XPlano.GetValue('idancestral5').Value,0)
           else
              ParamByName('xidancestral5').AsInteger := 0;
           if XPlano.TryGetValue('idancestral6',wval) then
              ParamByName('xidancestral6').AsInteger := strtointdef(XPlano.GetValue('idancestral6').Value,0)
           else
              ParamByName('xidancestral6').AsInteger := 0;
           if XPlano.TryGetValue('idancestral7',wval) then
              ParamByName('xidancestral7').AsInteger := strtointdef(XPlano.GetValue('idancestral7').Value,0)
           else
              ParamByName('xidancestral7').AsInteger := 0;
           if XPlano.TryGetValue('tipoconta',wval) then
              ParamByName('xtipoconta').AsString := XPlano.GetValue('tipoconta').Value
           else
              ParamByName('xtipoconta').AsString := '';
           if XPlano.TryGetValue('idplanoreferencial',wval) then
              ParamByName('xidplanoreferencial').AsInteger := strtointdef(XPlano.GetValue('idplanoreferencial').Value,0)
           else
              ParamByName('xidplanoreferencial').AsInteger := 0;
           if XPlano.TryGetValue('codnatureza',wval) then
              ParamByName('xcodnatureza').AsString := XPlano.GetValue('codnatureza').Value
           else
              ParamByName('xcodnatureza').AsString := '';
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
                SQL.Add('select  "CodigoInternoPlano"     as id,');
                SQL.Add('        "EstruturalPlano"        as estrutural,');
                SQL.Add('        "NomeContaPlano"         as nomeconta,');
                SQL.Add('        "CodigoReduzidoPlano"    as codreduzido,');
                SQL.Add('        "AncestralConta1Plano"   as idancestral1,');
                SQL.Add('        "AncestralConta2Plano"   as idancestral2,');
                SQL.Add('        "AncestralConta3Plano"   as idancestral3,');
                SQL.Add('        "AncestralConta4Plano"   as idancestral4,');
                SQL.Add('        "AncestralConta5Plano"   as idancestral5,');
                SQL.Add('        "AncestralConta6Plano"   as idancestral6,');
                SQL.Add('        "AncestralConta7Plano"   as idancestral7,');
                SQL.Add('        "TipoContaPlano"         as tipoconta,');
                SQL.Add('        "CodigoPlanoReferencial" as idplanoreferencial,');
                SQL.Add('        "CodigoNaturezaPlano"    as codnatureza ');
                SQL.Add('from "PlanodeConta" where "CodigoEmpresaPlano"=:xidempresa and "EstruturalPlano"=:xestrutural ');
                ParamByName('xidempresa').AsInteger  := wconexao.FIdEmpresaPlanoContas;
                if XPlano.TryGetValue('estrutural',wval) then
                   ParamByName('xestrutural').AsString := XPlano.GetValue('estrutural').Value
                else
                   ParamByName('xestrutural').AsString := '';
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Plano de Contas incluído');
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


function AlteraPlano(XIdPlano: integer; XPlano: TJSONObject): TJSONObject;
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

    if XPlano.TryGetValue('estrutural',wval) then
       begin
         if wcampos='' then
            wcampos := '"EstruturalPlano"=:xestrutural'
         else
            wcampos := wcampos+',"EstruturalPlano"=:xestrutural';
       end;
    if XPlano.TryGetValue('nomeconta',wval) then
       begin
         if wcampos='' then
            wcampos := '"NomeContaPlano"=:xnomeconta'
         else
            wcampos := wcampos+',"NomeContaPlano"=:xnomeconta';
       end;
    if XPlano.TryGetValue('codreduzido',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoReduzidoPlano"=:xcodreduzido'
         else
            wcampos := wcampos+',"CodigoReduzidoPlano"=:xcodreduzido';
       end;
    if XPlano.TryGetValue('idancestral1',wval) then
       begin
         if wcampos='' then
            wcampos := '"AncestralConta1Plano"=:xidancestral1'
         else
            wcampos := wcampos+',"AncestralConta1Plano"=:xidancestral1';
       end;
    if XPlano.TryGetValue('idancestral2',wval) then
       begin
         if wcampos='' then
            wcampos := '"AncestralConta2Plano"=:xidancestral2'
         else
            wcampos := wcampos+',"AncestralConta2Plano"=:xidancestral2';
       end;
    if XPlano.TryGetValue('idancestral3',wval) then
       begin
         if wcampos='' then
            wcampos := '"AncestralConta3Plano"=:xidancestral3'
         else
            wcampos := wcampos+',"AncestralConta3Plano"=:xidancestral3';
       end;
    if XPlano.TryGetValue('idancestral4',wval) then
       begin
         if wcampos='' then
            wcampos := '"AncestralConta4Plano"=:xidancestral4'
         else
            wcampos := wcampos+',"AncestralConta4Plano"=:xidancestral4';
       end;
    if XPlano.TryGetValue('idancestral5',wval) then
       begin
         if wcampos='' then
            wcampos := '"AncestralConta5Plano"=:xidancestral5'
         else
            wcampos := wcampos+',"AncestralConta5Plano"=:xidancestral5';
       end;
    if XPlano.TryGetValue('idancestral6',wval) then
       begin
         if wcampos='' then
            wcampos := '"AncestralConta6Plano"=:xidancestral6'
         else
            wcampos := wcampos+',"AncestralConta6Plano"=:xidancestral6';
       end;
    if XPlano.TryGetValue('idancestral7',wval) then
       begin
         if wcampos='' then
            wcampos := '"AncestralConta7Plano"=:xidancestral7'
         else
            wcampos := wcampos+',"AncestralConta7Plano"=:xidancestral7';
       end;
    if XPlano.TryGetValue('tipoconta',wval) then
       begin
         if wcampos='' then
            wcampos := '"TipoContaPlano"=:xtipoconta'
         else
            wcampos := wcampos+',"TipoContaPlano"=:xtipoconta';
       end;
    if XPlano.TryGetValue('idplanoreferencial',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoPlanoReferencial"=:xidplanoreferencial'
         else
            wcampos := wcampos+',"CodigoPlanoReferencial"=:xidplanoreferencial';
       end;
    if XPlano.TryGetValue('codnatureza',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoNaturezaPlano"=:xcodnatureza'
         else
            wcampos := wcampos+',"CodigoNaturezaPlano"=:xcodnatureza';
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
           SQL.Add('Update "PlanodeConta" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoPlano"=:xid ');
           ParamByName('xid').AsInteger               := XIdPlano;
           if XPlano.TryGetValue('estrutural',wval) then
              ParamByName('xestrutural').AsString     := XPlano.GetValue('estrutural').Value;
           if XPlano.TryGetValue('nomeconta',wval) then
              ParamByName('xnomeconta').AsString      := XPlano.GetValue('nomeconta').Value;
           if XPlano.TryGetValue('codreduzido',wval) then
              ParamByName('xcodreduzido').AsInteger   := strtointdef(XPlano.GetValue('codreduzido').Value,0);
           if XPlano.TryGetValue('idancestral1',wval) then
              ParamByName('xidancestral1').AsInteger  := strtointdef(XPlano.GetValue('idancestral1').Value,0);
           if XPlano.TryGetValue('idancestral2',wval) then
              ParamByName('xidancestral2').AsInteger  := strtointdef(XPlano.GetValue('idancestral2').Value,0);
           if XPlano.TryGetValue('idancestral3',wval) then
              ParamByName('xidancestral3').AsInteger  := strtointdef(XPlano.GetValue('idancestral3').Value,0);
           if XPlano.TryGetValue('idancestral4',wval) then
              ParamByName('xidancestral4').AsInteger  := strtointdef(XPlano.GetValue('idancestral4').Value,0);
           if XPlano.TryGetValue('idancestral5',wval) then
              ParamByName('xidancestral5').AsInteger  := strtointdef(XPlano.GetValue('idancestral5').Value,0);
           if XPlano.TryGetValue('idancestral6',wval) then
              ParamByName('xidancestral6').AsInteger  := strtointdef(XPlano.GetValue('idancestral6').Value,0);
           if XPlano.TryGetValue('idancestral7',wval) then
              ParamByName('xidancestral7').AsInteger  := strtointdef(XPlano.GetValue('idancestral7').Value,0);
           if XPlano.TryGetValue('tipoconta',wval) then
              ParamByName('xtipoconta').AsString      := XPlano.GetValue('tipoconta').Value;
           if XPlano.TryGetValue('idplanoreferencial',wval) then
              ParamByName('xidplanoreferencial').AsInteger  := strtointdef(XPlano.GetValue('idplanoreferencial').Value,0);
           if XPlano.TryGetValue('codnatureza',wval) then
              ParamByName('xcodnatureza').AsString    := XPlano.GetValue('codnatureza').Value;
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
              SQL.Add('select  "CodigoInternoPlano"     as id,');
              SQL.Add('        "EstruturalPlano"        as estrutural,');
              SQL.Add('        "NomeContaPlano"         as nomeconta,');
              SQL.Add('        "CodigoReduzidoPlano"    as codreduzido,');
              SQL.Add('        "AncestralConta1Plano"   as idancestral1,');
              SQL.Add('        "AncestralConta2Plano"   as idancestral2,');
              SQL.Add('        "AncestralConta3Plano"   as idancestral3,');
              SQL.Add('        "AncestralConta4Plano"   as idancestral4,');
              SQL.Add('        "AncestralConta5Plano"   as idancestral5,');
              SQL.Add('        "AncestralConta6Plano"   as idancestral6,');
              SQL.Add('        "AncestralConta7Plano"   as idancestral7,');
              SQL.Add('        "TipoContaPlano"         as tipoconta,');
              SQL.Add('        "CodigoPlanoReferencial" as idplanoreferencial,');
              SQL.Add('        "CodigoNaturezaPlano"    as codnatureza ');
              SQL.Add('from "PlanodeConta" ');
              SQL.Add('where "CodigoInternoPlano" =:xid ');
              ParamByName('xid').AsInteger := XIdPlano;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Plano de Conta alterado');
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

function VerificaRequisicao(XPlano: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XPlano.TryGetValue('nomeconta',wval) then
       wret := false;
    if not XPlano.TryGetValue('estrutural',wval) then
       wret := false;
    if not XPlano.TryGetValue('codreduzido',wval) then
       wret := false;
  finally
  end;
  Result := wret;
end;

function ApagaPlano(XIdPlano: integer): TJSONObject;
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
         SQL.Add('delete from "PlanodeConta" where "CodigoInternoPlano"=:xid ');
         ParamByName('xid').AsInteger := XIdPlano;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Plano de Conta excluído com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhum Plano de Conta excluído');
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
