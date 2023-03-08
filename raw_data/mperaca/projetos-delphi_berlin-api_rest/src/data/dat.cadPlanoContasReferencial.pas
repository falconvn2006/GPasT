unit dat.cadPlanoContasReferencial;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaPlanoReferencial(XId: integer): TJSONObject;
function RetornaListaPlanosReferenciais(const XQuery: TDictionary<string, string>): TJSONArray;
function IncluiPlanoReferencial(XPlanoReferencial: TJSONObject): TJSONObject;
function AlteraPlanoReferencial(XIdPlanoReferencial: integer; XPlanoReferencial: TJSONObject): TJSONObject;
function ApagaPlanoReferencial(XIdPlanoReferencial: integer): TJSONObject;
function VerificaRequisicao(XPlanoReferencial: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaPlanoReferencial(XId: integer): TJSONObject;
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
         SQL.Add('select  "CodigoInternoPlano"      as id,');
         SQL.Add('        "EstruturalPlano"         as estrutural,');
         SQL.Add('        "DescricaoPlano"          as descricao,');
         SQL.Add('        "DataInicioValidadePlano" as validadeincial,');
         SQL.Add('        "DataFinalValidadePlano"  as validadefinal,');
         SQL.Add('        "TipoContaPlano"          as tipoconta ');
         SQL.Add('from "PlanodeContasReferencial" ');
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
        wret.AddPair('description','Nenhum Plano de Contas Referencial encontrado');
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

function RetornaListaPlanosReferenciais(const XQuery: TDictionary<string, string>): TJSONArray;
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
         SQL.Add('select  "CodigoInternoPlano"      as id,');
         SQL.Add('        "EstruturalPlano"         as estrutural,');
         SQL.Add('        "DescricaoPlano"          as descricao,');
         SQL.Add('        "DataInicioValidadePlano" as validadeincial,');
         SQL.Add('        "DataFinalValidadePlano"  as validadefinal,');
         SQL.Add('        "TipoContaPlano"          as tipoconta ');
         SQL.Add('from "PlanodeContasReferencial" ');
         Open;
         EnableControls;
       end;
    if wqueryLista.RecordCount>0 then
       wret := wqueryLista.ToJSONArray()
    else
       begin
         wobj := TJSONObject.Create;
         wobj.AddPair('status','500');
         wobj.AddPair('description','Nenhum Plano de Contas Referencial encontrado');
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

function IncluiPlanoReferencial(XPlanoReferencial: TJSONObject): TJSONObject;
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
           SQL.Add('Insert into "PlanodeContasReferencial" ("EstruturalPlano","DescricaoPlano","DataInicioValidadePlano","DataFinalValidadePlano","TipoContaPlano") ');
           SQL.Add('values (:xestrutural,:xdescricao,:xvalidadeinicial,:xvalidadefinal,:xtipoconta)' );
           if XPlanoReferencial.TryGetValue('estrutural',wval) then
              ParamByName('xestrutural').AsString := XPlanoReferencial.GetValue('estrutural').Value
           else
              ParamByName('xestrutural').AsString := '';
           if XPlanoReferencial.TryGetValue('descricao',wval) then
              ParamByName('xdescricao').AsString := XPlanoReferencial.GetValue('descricao').Value
           else
              ParamByName('xdescricao').AsString := '';
           if XPlanoReferencial.TryGetValue('validadeinicial',wval) then
              ParamByName('xvalidadeinicial').AsDate := strtodatedef(XPlanoReferencial.GetValue('validadeinicial').Value,0)
           else
              ParamByName('xvalidadeinicial').AsDate := 0;
           if XPlanoReferencial.TryGetValue('validadefinal',wval) then
              ParamByName('xvalidadefinal').AsDate := strtodatedef(XPlanoReferencial.GetValue('validadefinal').Value,0)
           else
              ParamByName('xvalidadefinal').AsDate := 0;
           if XPlanoReferencial.TryGetValue('tipoconta',wval) then
              ParamByName('xtipoconta').AsString := XPlanoReferencial.GetValue('tipoconta').Value
           else
              ParamByName('xtipoconta').AsString := '';
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
                SQL.Add('select  "CodigoInternoPlano"      as id,');
                SQL.Add('        "EstruturalPlano"         as estrutural,');
                SQL.Add('        "DescricaoPlano"          as descricao,');
                SQL.Add('        "DataInicioValidadePlano" as validadeincial,');
                SQL.Add('        "DataFinalValidadePlano"  as validadefinal,');
                SQL.Add('        "TipoContaPlano"          as tipoconta ');
                SQL.Add('from "PlanodeContasReferencial" where "EstruturalPlano"=:xestrutural ');
                if XPlanoReferencial.TryGetValue('estrutural',wval) then
                   ParamByName('xestrutural').AsString := XPlanoReferencial.GetValue('estrutural').Value
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
              wret.AddPair('description','Nenhum Plano de Contas Referencial incluído');
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


function AlteraPlanoReferencial(XIdPlanoReferencial: integer; XPlanoReferencial: TJSONObject): TJSONObject;
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
    if XPlanoReferencial.TryGetValue('estrutural',wval) then
       begin
         if wcampos='' then
            wcampos := '"EstruturalPlano"=:xestrutural'
         else
            wcampos := wcampos+',"EstruturalPlano"=:xestrutural';
       end;
    if XPlanoReferencial.TryGetValue('descricao',wval) then
       begin
         if wcampos='' then
            wcampos := '"DescricaoPlano"=:xdescricao'
         else
            wcampos := wcampos+',"DescricaoPlano"=:xdescricao';
       end;
    if XPlanoReferencial.TryGetValue('validadeinicial',wval) then
       begin
         if wcampos='' then
            wcampos := '"DataInicioValidadePlano"=:xvalidadeinicial'
         else
            wcampos := wcampos+',"DataInicioValidadePlano"=:xvalidadeinicial';
       end;
    if XPlanoReferencial.TryGetValue('validadefinal',wval) then
       begin
         if wcampos='' then
            wcampos := '"DataFinalValidadePlano"=:xvalidadefinal'
         else
            wcampos := wcampos+',"DataFinalValidadePlano"=:xvalidadefinal';
       end;
    if XPlanoReferencial.TryGetValue('tipoconta',wval) then
       begin
         if wcampos='' then
            wcampos := '"TipoContaPlano"=:xtipoconta'
         else
            wcampos := wcampos+',"TipoContaPlano"=:xtipoconta';
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
           SQL.Add('Update "PlanodeContasReferencial" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoPlano"=:xid ');
           ParamByName('xid').AsInteger               := XIdPlanoReferencial;
           if XPlanoReferencial.TryGetValue('estrutural',wval) then
              ParamByName('xestrutural').AsString     := XPlanoReferencial.GetValue('estrutural').Value;
           if XPlanoReferencial.TryGetValue('descricao',wval) then
              ParamByName('xdescricao').AsString      := XPlanoReferencial.GetValue('descricao').Value;
           if XPlanoReferencial.TryGetValue('validadeinicial',wval) then
              ParamByName('xvalidadeinicial').AsDate  := strtodatedef(XPlanoReferencial.GetValue('validadeinicial').Value,0);
           if XPlanoReferencial.TryGetValue('validadefinal',wval) then
              ParamByName('xvalidadefinal').AsDate    := strtodatedef(XPlanoReferencial.GetValue('validadefinal').Value,0);
           if XPlanoReferencial.TryGetValue('tipoconta',wval) then
              ParamByName('xtipoconta').AsString      := XPlanoReferencial.GetValue('tipoconta').Value;
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
              SQL.Add('select  "CodigoInternoPlano"      as id,');
              SQL.Add('        "EstruturalPlano"         as estrutural,');
              SQL.Add('        "DescricaoPlano"          as descricao,');
              SQL.Add('        "DataInicioValidadePlano" as validadeincial,');
              SQL.Add('        "DataFinalValidadePlano"  as validadefinal,');
              SQL.Add('        "TipoContaPlano"          as tipoconta ');
              SQL.Add('from "PlanodeContasReferencial" ');
              SQL.Add('where "CodigoInternoPlano" =:xid ');
              ParamByName('xid').AsInteger := XIdPlanoReferencial;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Plano de Conta Referencial alterado');
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

function VerificaRequisicao(XPlanoReferencial: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XPlanoReferencial.TryGetValue('descricao',wval) then
       wret := false;
    if not XPlanoReferencial.TryGetValue('estrutural',wval) then
       wret := false;
    if not XPlanoReferencial.TryGetValue('validadeinicial',wval) then
       wret := false;
    if not XPlanoReferencial.TryGetValue('validadefinal',wval) then
       wret := false;
  finally
  end;
  Result := wret;
end;

function ApagaPlanoReferencial(XIdPlanoReferencial: integer): TJSONObject;
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
         SQL.Add('delete from "PlanodeContasReferencial" where "CodigoInternoPlano"=:xid ');
         ParamByName('xid').AsInteger := XIdPlanoReferencial;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Plano de Conta Referencial excluído com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhum Plano de Conta Referencial excluído');
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
