unit dat.cadTabelasGrupos;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaGrupo(XId: integer): TJSONObject;
function RetornaListaGrupos(const XQuery: TDictionary<string, string>): TJSONArray;
function IncluiGrupo(XGrupo: TJSONObject): TJSONObject;
function AlteraGrupo(XIdGrupo: integer; XGrupo: TJSONObject): TJSONObject;
function ApagaGrupo(XIdGrupo: integer): TJSONObject;
function VerificaRequisicao(XGrupo: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaGrupo(XId: integer): TJSONObject;
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
         SQL.Add('select  "CodigoInternoTabelaGrupo" as id,');
         SQL.Add('        "CodigoTabelaGrupo"        as codigo,');
         SQL.Add('        "NomeTabelaGrupo"          as nome,');
         SQL.Add('        "GeraArquivoTabelaGrupo"   as geraarquivo ');
         SQL.Add('from "TabelaGrupo" ');
         SQL.Add('where "CodigoInternoTabelaGrupo"=:xid ');
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
        wret.AddPair('description','Nenhuma Tabela Grupo encontrada');
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

function RetornaListaGrupos(const XQuery: TDictionary<string, string>): TJSONArray;
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
         SQL.Add('select  "CodigoInternoTabelaGrupo" as id,');
         SQL.Add('        "CodigoTabelaGrupo"        as codigo,');
         SQL.Add('        "NomeTabelaGrupo"          as nome,');
         SQL.Add('        "GeraArquivoTabelaGrupo"   as geraarquivo ');
         SQL.Add('from "TabelaGrupo" where "CodigoEmpresaTabelaGrupo"=:xempresa ');
         ParamByName('xempresa').AsInteger := wconexao.FIdEmpresa;
         Open;
         EnableControls;
       end;
    if wqueryLista.RecordCount>0 then
       wret := wqueryLista.ToJSONArray()
    else
       begin
         wobj := TJSONObject.Create;
         wobj.AddPair('status','500');
         wobj.AddPair('description','Nenhuma Tabela Grupo encontrada');
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

function IncluiGrupo(XGrupo: TJSONObject): TJSONObject;
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
           SQL.Add('Insert into "TabelaGrupo" ("CodigoEmpresaTabelaGrupo","CodigoTabelaGrupo","NomeTabelaGrupo","GeraArquivoTabelaGrupo") ');
           SQL.Add('values (:xidempresa,:xcodigo,:xnome,:xgeraarquivo) ');
           ParamByName('xidempresa').AsInteger       := wconexao.FIdEmpresa;
           if XGrupo.TryGetValue('codigo',wval) then
              ParamByName('xcodigo').AsInteger  := strtointdef(XGrupo.GetValue('codigo').Value,0)
           else
              ParamByName('xcodigo').AsInteger  := 0;
           if XGrupo.TryGetValue('nome',wval) then
              ParamByName('xnome').AsString  := XGrupo.GetValue('nome').Value
           else
              ParamByName('xnome').AsString  := '';
           if XGrupo.TryGetValue('geraarquivo',wval) then
              ParamByName('xgeraarquivo').AsBoolean  := strtobooldef(XGrupo.GetValue('geraarquivo').Value,false)
           else
              ParamByName('xgeraarquivo').AsBoolean  := false;
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
                SQL.Add('select  "CodigoInternoTabelaGrupo" as id,');
                SQL.Add('        "CodigoTabelaGrupo"        as codigo,');
                SQL.Add('        "NomeTabelaGrupo"          as nome,');
                SQL.Add('        "GeraArquivoTabelaGrupo"   as geraarquivo ');
                SQL.Add('from "TabelaGrupo" where "CodigoEmpresaTabelaGrupo"=:xempresa ');
                ParamByName('xempresa').AsInteger  := wconexao.FIdEmpresa;
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhuma Tabela Grupo incluída');
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

function AlteraGrupo(XIdGrupo: integer; XGrupo: TJSONObject): TJSONObject;
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
    if XGrupo.TryGetValue('codigo',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoTabelaGrupo"=:xcodigo'
         else
            wcampos := wcampos+',"CodigoTabelaGrupo"=:xcodigo';
       end;
    if XGrupo.TryGetValue('nome',wval) then
       begin
         if wcampos='' then
            wcampos := '"NomeTabelaGrupo"=:xnome'
         else
            wcampos := wcampos+',"NomeTabelaGrupo"=:xnome';
       end;
    if XGrupo.TryGetValue('geraarquivo',wval) then
       begin
         if wcampos='' then
            wcampos := '"GeraArquivoTabelaGrupo"=:xgeraarquivo'
         else
            wcampos := wcampos+',"GeraArquivoTabelaGrupo"=:xgeraarquivo';
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
           SQL.Add('Update "TabelaGrupo" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoTabelaGrupo"=:xid ');
           ParamByName('xid').AsInteger            := XIdGrupo;
           if XGrupo.TryGetValue('codigo',wval) then
              ParamByName('xcodigo').AsInteger  := strtointdef(XGrupo.GetValue('codigo').Value,0);
           if XGrupo.TryGetValue('nome',wval) then
              ParamByName('xnome').AsString     := XGrupo.GetValue('nome').Value;
           if XGrupo.TryGetValue('geraarquivo',wval) then
              ParamByName('xgeraarquivo').AsBoolean := strtobooldef(XGrupo.GetValue('geraarquivo').Value,false);
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
              SQL.Add('select  "CodigoInternoTabelaGrupo" as id,');
              SQL.Add('        "CodigoTabelaGrupo"        as codigo,');
              SQL.Add('        "NomeTabelaGrupo"          as nome,');
              SQL.Add('        "GeraArquivoTabelaGrupo"   as geraarquivo ');
              SQL.Add('from "TabelaGrupo" ');
              SQL.Add('where "CodigoInternoTabelaGrupo" =:xid ');
              ParamByName('xid').AsInteger := XIdGrupo;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhuma Tabela Grupo alterada');
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

function VerificaRequisicao(XGrupo: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XGrupo.TryGetValue('codigo',wval) then
       wret := false;
    if not XGrupo.TryGetValue('nome',wval) then
       wret := false;
  finally
  end;
  Result := wret;
end;

function ApagaGrupo(XIdGrupo: integer): TJSONObject;
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
         SQL.Add('delete from "TabelaGrupo" where "CodigoInternoTabelaGrupo"=:xid ');
         ParamByName('xid').AsInteger := XIdGrupo;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Tabela Grupo excluída com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhuma Tabela Grupo excluída');
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
