unit dat.cadPessoasEmpresas;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaEmpresa(XId: integer): TJSONObject;
function RetornaListaEmpresas(const XQuery: TDictionary<string, string>; XIdPessoa: integer): TJSONArray;
function IncluiEmpresa(XEmpresa: TJSONObject; XIdPessoa: integer): TJSONObject;
function AlteraEmpresa(XIdEmpresa: integer; XEmpresa: TJSONObject): TJSONObject;
function ApagaEmpresa(XIdEmpresa: integer): TJSONObject;
function VerificaRequisicao(XEmpresa: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaEmpresa(XId: integer): TJSONObject;
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
         SQL.Add('select  "CodigoInternoPessoaEmpresa" as id,');
         SQL.Add('        "CodigoPessoaPessoaEmpresa"  as idpessoa,');
         SQL.Add('        "TipoEmpresaPessoaEmpresa"   as tipo,');
         SQL.Add('        "EnquadramentoPessoaEmpresa" as enquadramento,');
         SQL.Add('        "TributacaoPessoaEmpresa"    as tributacao,');
         SQL.Add('        "FretePessoaEmpresa"         as temfrete,');
         SQL.Add('        "ValorFretePessoaEmpresa"    as valorfrete,');
         SQL.Add('from "PessoaEmpresa" ');
         SQL.Add('where "CodigoInternoPessoaEmpresa"=:xid ');
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
        wret.AddPair('description','Nenhuma Empresa encontrada');
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

function RetornaListaEmpresas(const XQuery: TDictionary<string, string>; XIdPessoa: integer): TJSONArray;
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
         SQL.Add('select  "CodigoInternoPessoaEmpresa" as id,');
         SQL.Add('        "CodigoPessoaPessoaEmpresa"  as idpessoa,');
         SQL.Add('        "TipoEmpresaPessoaEmpresa"   as tipo,');
         SQL.Add('        "EnquadramentoPessoaEmpresa" as enquadramento,');
         SQL.Add('        "TributacaoPessoaEmpresa"    as tributacao,');
         SQL.Add('        "FretePessoaEmpresa"         as temfrete,');
         SQL.Add('        "ValorFretePessoaEmpresa"    as valorfrete ');
         SQL.Add('from "PessoaEmpresa" where "CodigoPessoaPessoaEmpresa"=:xidpessoa ');
         ParamByName('xidpessoa').AsInteger := XIdPessoa;;
         if XQuery.ContainsKey('tipo') then // filtro por tipo
            begin
              SQL.Add('and "TipoEmpresaPessoaEmpresa" =:xtipo ');
              ParamByName('xtipo').AsString := XQuery.Items['tipo'];
              SQL.Add('order by "TipoEmpresaPessoaEmpresa" ');
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
         wobj.AddPair('description','Nenhuma Empresa encontrada');
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

function IncluiEmpresa(XEmpresa: TJSONObject; XIdPessoa: integer): TJSONObject;
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
           SQL.Add('Insert into "PessoaEmpresa" ("CodigoPessoaPessoaEmpresa","TipoEmpresaPessoaEmpresa","EnquadramentoPessoaEmpresa",');
           SQL.Add('"TributacaoPessoaEmpresa","FretePessoaEmpresa","ValorFretePessoaEmpresa") ');
           SQL.Add('values (:xidpessoa,:xtipo,:xenquadramento,');
           SQL.Add(':xtributacao,:xtemfrete,:xvalorfrete) ');
           ParamByName('xidpessoa').AsInteger   := XIdPessoa;
           if XEmpresa.TryGetValue('tipo',wval) then
              ParamByName('xtipo').AsInteger := strtointdef(XEmpresa.GetValue('tipo').Value,0)
           else
              ParamByName('xtipo').AsInteger := 0;
           if XEmpresa.TryGetValue('enquadramento',wval) then
              ParamByName('xenquadramento').AsInteger := strtointdef(XEmpresa.GetValue('enquadramento').Value,0)
           else
              ParamByName('xenquadramento').AsInteger := 0;
           if XEmpresa.TryGetValue('tributacao',wval) then
              ParamByName('xtributacao').AsInteger := strtointdef(XEmpresa.GetValue('tributacao').Value,0)
           else
              ParamByName('xtributacao').AsInteger := 0;
           if XEmpresa.TryGetValue('temfrete',wval) then
              ParamByName('xtemfrete').AsBoolean := strtobooldef(XEmpresa.GetValue('temfrete').Value,false)
           else
              ParamByName('xtemfrete').AsBoolean := false;
           if XEmpresa.TryGetValue('valorfrete',wval) then
              ParamByName('xvalorfrete').AsFloat := strtofloatdef(XEmpresa.GetValue('valorfrete').Value,0)
           else
              ParamByName('xvalorfrete').AsFloat := 0;
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
                SQL.Add('select  "CodigoInternoPessoaEmpresa" as id,');
                SQL.Add('        "CodigoPessoaPessoaEmpresa"  as idpessoa,');
                SQL.Add('        "TipoEmpresaPessoaEmpresa"   as tipo,');
                SQL.Add('        "EnquadramentoPessoaEmpresa" as enquadramento,');
                SQL.Add('        "TributacaoPessoaEmpresa"    as tributacao,');
                SQL.Add('        "FretePessoaEmpresa"         as temfrete,');
                SQL.Add('        "ValorFretePessoaEmpresa"    as valorfrete ');
                SQL.Add('from "PessoaEmpresa" where "CodigoPessoaPessoaEmpresa"=:xidpessoa and "TipoEmpresaPessoaEmpresa"=:xtipo ');
                ParamByName('xidpessoa').AsInteger  := XIdPessoa;
                if XEmpresa.TryGetValue('tipo',wval) then
                   ParamByName('xtipo').AsInteger := strtointdef(XEmpresa.GetValue('tipo').Value,0)
                else
                   ParamByName('xtipo').AsInteger := 0;
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhuma Empresa incluída');
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


function AlteraEmpresa(XIdEmpresa: integer; XEmpresa: TJSONObject): TJSONObject;
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
    if XEmpresa.TryGetValue('tipo',wval) then
       begin
         if wcampos='' then
            wcampos := '"TipoEmpresaPessoaEmpresa"=:xtipo'
         else
            wcampos := wcampos+',"TipoEmpresaPessoaEmpresa"=:xtipo';
       end;
    if XEmpresa.TryGetValue('enquadramento',wval) then
       begin
         if wcampos='' then
            wcampos := '"EnquadramentoPessoaEmpresa"=:xenquadramento'
         else
            wcampos := wcampos+',"EnquadramentoPessoaEmpresa"=:xenquadramento';
       end;
    if XEmpresa.TryGetValue('tributacao',wval) then
       begin
         if wcampos='' then
            wcampos := '"TributacaoPessoaEmpresa"=:xtributacao'
         else
            wcampos := wcampos+',"TributacaoPessoaEmpresa"=:xtributacao';
       end;
    if XEmpresa.TryGetValue('temfrete',wval) then
       begin
         if wcampos='' then
            wcampos := '"FretePessoaEmpresa"=:xtemfrete'
         else
            wcampos := wcampos+',"FretePessoaEmpresa"=:xtemfrete';
       end;
    if XEmpresa.TryGetValue('valorfrete',wval) then
       begin
         if wcampos='' then
            wcampos := '"ValorFretePessoaEmpresa"=:xvalorfrete'
         else
            wcampos := wcampos+',"ValorFretePessoaEmpresa"=:xvalorfrete';
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
           SQL.Add('Update "PessoaEmpresa" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoPessoaEmpresa"=:xid ');
           ParamByName('xid').AsInteger               := XIdEmpresa;
           if XEmpresa.TryGetValue('tipo',wval) then
              ParamByName('xtipo').AsInteger          := strtointdef(XEmpresa.GetValue('tipo').Value,0);
           if XEmpresa.TryGetValue('enquadramento',wval) then
              ParamByName('xenquadramento').AsInteger := strtointdef(XEmpresa.GetValue('enquadramento').Value,0);
           if XEmpresa.TryGetValue('tributacao',wval) then
              ParamByName('xtributacao').AsInteger    := strtointdef(XEmpresa.GetValue('tributacao').Value,0);
           if XEmpresa.TryGetValue('temfrete',wval) then
              ParamByName('xtemfrete').AsBoolean      := strtobooldef(XEmpresa.GetValue('temfrete').Value,false);
           if XEmpresa.TryGetValue('valorfrete',wval) then
              ParamByName('xvalorfrete').AsFloat      := strtofloatdef(XEmpresa.GetValue('valorfrete').Value,0);
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
              SQL.Add('select  "CodigoInternoPessoaEmpresa" as id,');
              SQL.Add('        "CodigoPessoaPessoaEmpresa"  as idpessoa,');
              SQL.Add('        "TipoEmpresaPessoaEmpresa"   as tipo,');
              SQL.Add('        "EnquadramentoPessoaEmpresa" as enquadramento,');
              SQL.Add('        "TributacaoPessoaEmpresa"    as tributacao,');
              SQL.Add('        "FretePessoaEmpresa"         as temfrete,');
              SQL.Add('        "ValorFretePessoaEmpresa"    as valorfrete ');
              SQL.Add('from "PessoaEmpresa" ');
              SQL.Add('where "CodigoInternoPessoaEmpresa" =:xid ');
              ParamByName('xid').AsInteger := XIdEmpresa;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhuma Empresa alterada');
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

function VerificaRequisicao(XEmpresa: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XEmpresa.TryGetValue('tipo',wval) then
       wret := false;
  finally
  end;
  Result := wret;
end;

function ApagaEmpresa(XIdEmpresa: integer): TJSONObject;
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
         SQL.Add('delete from "PessoaEmpresa" where "CodigoInternoPessoaEmpresa"=:xid ');
         ParamByName('xid').AsInteger := XIdEmpresa;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Empresa excluída com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhuma Empresa excluída');
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
