unit dat.cadTabelasDescontosFaixas;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaFaixa(XId: integer): TJSONObject;
function RetornaListaFaixas(const XQuery: TDictionary<string, string>; XIdTabela: integer): TJSONArray;
function IncluiFaixa(XFaixa: TJSONObject; XIdTabela: integer): TJSONObject;
function AlteraFaixa(XIdFaixa: integer; XFaixa: TJSONObject): TJSONObject;
function ApagaFaixa(XIdFaixa: integer): TJSONObject;
function VerificaRequisicao(XFaixa: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaFaixa(XId: integer): TJSONObject;
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
         SQL.Add('select  "CodigoInternoFaixa"        as id,');
         SQL.Add('        "CodigoTabelaDescontoFaixa" as idtabela,');
         SQL.Add('        "NumeroFaixa"               as numero,');
         SQL.Add('        "LimiteInferiorFaixa"       as limiteinferior,');
         SQL.Add('        "LimiteSuperiorFaixa"       as limitesuperior,');
         SQL.Add('        "PercentualDescontoFaixa"   as percdesconto,');
         SQL.Add('        "NumeroEmpregadosFaixa"     as numeroempregados ');
         SQL.Add('from "TabelaDescontoFaixa" ');
         SQL.Add('where "CodigoInternoFaixa"=:xid ');
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
        wret.AddPair('description','Nenhuma Faixa Desconto encontrada');
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

function RetornaListaFaixas(const XQuery: TDictionary<string, string>; XIdTabela: integer): TJSONArray;
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
         SQL.Add('select  "CodigoInternoFaixa"        as id,');
         SQL.Add('        "CodigoTabelaDescontoFaixa" as idtabela,');
         SQL.Add('        "NumeroFaixa"               as numero,');
         SQL.Add('        "LimiteInferiorFaixa"       as limiteinferior,');
         SQL.Add('        "LimiteSuperiorFaixa"       as limitesuperior,');
         SQL.Add('        "PercentualDescontoFaixa"   as percdesconto,');
         SQL.Add('        "NumeroEmpregadosFaixa"     as numeroempregados ');
         SQL.Add('from "TabelaDescontoFaixa" where "CodigoTabelaDescontoFaixa"=:xidtabela ');
         ParamByName('xidtabela').AsInteger := XIdTabela;
         Open;
         EnableControls;
       end;
    if wqueryLista.RecordCount>0 then
       wret := wqueryLista.ToJSONArray()
    else
       begin
         wobj := TJSONObject.Create;
         wobj.AddPair('status','500');
         wobj.AddPair('description','Nenhuma Faixa Desconto encontrada');
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

function IncluiFaixa(XFaixa: TJSONObject; XIdTabela: integer): TJSONObject;
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
           SQL.Add('Insert into "TabelaDescontoFaixa" ("CodigoTabelaDescontoFaixa","NumeroFaixa","LimiteInferiorFaixa",');
           SQL.Add('"LimiteSuperiorFaixa","PercentualDescontoFaixa","NumeroEmpregadosFaixa") ');
           SQL.Add('values (:xidtabela,:xnumero,:xlimiteinferior,:xlimitesuperior,:xpercdesconto,:xnumeroempregados) ');
           ParamByName('xidtabela').AsInteger        := XIdTabela;
           if XFaixa.TryGetValue('numero',wval) then
              ParamByName('xnumero').AsInteger  := strtointdef(XFaixa.GetValue('numero').Value,0)
           else
              ParamByName('xnumero').AsInteger  := 0;
           if XFaixa.TryGetValue('limiteinferior',wval) then
              ParamByName('xlimiteinferior').AsInteger  := strtointdef(XFaixa.GetValue('limiteinferior').Value,0)
           else
              ParamByName('xlimiteinferior').AsInteger  := 0;
           if XFaixa.TryGetValue('limitesuperior',wval) then
              ParamByName('xlimitesuperior').AsInteger  := strtointdef(XFaixa.GetValue('limitesuperior').Value,0)
           else
              ParamByName('xlimitesuperior').AsInteger  := 0;
           if XFaixa.TryGetValue('percdesconto',wval) then
              ParamByName('xpercdesconto').AsFloat  := strtofloatdef(XFaixa.GetValue('percdesconto').Value,0)
           else
              ParamByName('xpercdesconto').AsFloat  := 0;
           if XFaixa.TryGetValue('numeroempregados',wval) then
              ParamByName('xnumeroempregados').AsInteger  := strtointdef(XFaixa.GetValue('numeroempregados').Value,0)
           else
              ParamByName('xnumeroempregados').AsInteger  := 0;
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
                SQL.Add('select  "CodigoInternoFaixa"        as id,');
                SQL.Add('        "CodigoTabelaDescontoFaixa" as idtabela,');
                SQL.Add('        "NumeroFaixa"               as numero,');
                SQL.Add('        "LimiteInferiorFaixa"       as limiteinferior,');
                SQL.Add('        "LimiteSuperiorFaixa"       as limitesuperior,');
                SQL.Add('        "PercentualDescontoFaixa"   as percdesconto,');
                SQL.Add('        "NumeroEmpregadosFaixa"     as numeroempregados ');
                SQL.Add('from "TabelaDescontoFaixa" where "CodigoTabelaDescontoFaixa"=:xidtabela and "NumeroFaixa"=:xnumero ');
                ParamByName('xidtabela').AsInteger        := XIdTabela;
                if XFaixa.TryGetValue('numero',wval) then
                   ParamByName('xnumero').AsInteger  := strtointdef(XFaixa.GetValue('numero').Value,0)
                else
                   ParamByName('xnumero').AsInteger  := 0;
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhuma Faixa Desconto incluída');
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

function AlteraFaixa(XIdFaixa: integer; XFaixa: TJSONObject): TJSONObject;
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
    if XFaixa.TryGetValue('numero',wval) then
       begin
         if wcampos='' then
            wcampos := '"NumeroFaixa"=:xnumero'
         else
            wcampos := wcampos+',"NumeroFaixa"=:xnumero';
       end;
    if XFaixa.TryGetValue('limiteinferior',wval) then
       begin
         if wcampos='' then
            wcampos := '"LimiteInferiorFaixa"=:xlimiteinferior'
         else
            wcampos := wcampos+',"LimiteInferiorFaixa"=:xlimiteinferior';
       end;
    if XFaixa.TryGetValue('limitesuperior',wval) then
       begin
         if wcampos='' then
            wcampos := '"LimiteSuperiorFaixa"=:xlimitesuperior'
         else
            wcampos := wcampos+',"LimiteSuperiorFaixa"=:xlimitesuperior';
       end;
    if XFaixa.TryGetValue('percdesconto',wval) then
       begin
         if wcampos='' then
            wcampos := '"PercentualDescontoFaixa"=:xpercdesconto'
         else
            wcampos := wcampos+',"PercentualDescontoFaixa"=:xpercdesconto';
       end;
    if XFaixa.TryGetValue('numeroempregados',wval) then
       begin
         if wcampos='' then
            wcampos := '"NumeroEmpregadosFaixa"=:xnumeroempregados'
         else
            wcampos := wcampos+',"NumeroEmpregadosFaixa"=:xnumeroempregados';
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
           SQL.Add('Update "TabelaDescontoFaixa" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoFaixa"=:xid ');
           ParamByName('xid').AsInteger            := XIdFaixa;
           if XFaixa.TryGetValue('numero',wval) then
              ParamByName('xnumero').AsInteger  := strtointdef(XFaixa.GetValue('numero').Value,0);
           if XFaixa.TryGetValue('limiteinferior',wval) then
              ParamByName('xlimiteinferior').AsInteger   := strtointdef(XFaixa.GetValue('limiteinferior').Value,0);
           if XFaixa.TryGetValue('limitesuperior',wval) then
              ParamByName('xlimitesuperior').AsInteger   := strtointdef(XFaixa.GetValue('limitesuperior').Value,0);
           if XFaixa.TryGetValue('percdesconto',wval) then
              ParamByName('xpercdesconto').AsFloat       := strtofloatdef(XFaixa.GetValue('percdesconto').Value,0);
           if XFaixa.TryGetValue('numeroempregados',wval) then
              ParamByName('xnumeroempregados').AsInteger := strtointdef(XFaixa.GetValue('numeroempregados').Value,0);
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
              SQL.Add('select  "CodigoInternoFaixa"        as id,');
              SQL.Add('        "CodigoTabelaDescontoFaixa" as idtabela,');
              SQL.Add('        "NumeroFaixa"               as numero,');
              SQL.Add('        "LimiteInferiorFaixa"       as limiteinferior,');
              SQL.Add('        "LimiteSuperiorFaixa"       as limitesuperior,');
              SQL.Add('        "PercentualDescontoFaixa"   as percdesconto,');
              SQL.Add('        "NumeroEmpregadosFaixa"     as numeroempregados ');
              SQL.Add('from "TabelaDescontoFaixa" ');
              SQL.Add('where "CodigoInternoFaixa" =:xid ');
              ParamByName('xid').AsInteger := XIdFaixa;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhuma Faixa Desconto alterada');
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

function VerificaRequisicao(XFaixa: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XFaixa.TryGetValue('numero',wval) then
       wret := false;
  finally
  end;
  Result := wret;
end;

function ApagaFaixa(XIdFaixa: integer): TJSONObject;
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
         SQL.Add('delete from "TabelaDescontoFaixa" where "CodigoInternoFaixa"=:xid ');
         ParamByName('xid').AsInteger := XIdFaixa;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Faixa Desconto excluída com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhuma Faixa Desconto excluída');
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
