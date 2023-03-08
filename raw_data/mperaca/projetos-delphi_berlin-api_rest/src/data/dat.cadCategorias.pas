unit dat.cadCategorias;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaCategoria(XId: integer): TJSONObject;
function RetornaListaCategorias(const XQuery: TDictionary<string, string>; XEmpresa,XLimit,XOffset: integer): TJSONArray;
function RetornaTotalCategorias(const XQuery: TDictionary<string, string>): TJSONObject;
function IncluiCategoria(XCategoria: TJSONObject; XIdEmpresa: integer): TJSONObject;
function AlteraCategoria(XIdCategoria: integer; XCategoria: TJSONObject): TJSONObject;
function ApagaCategoria(XIdCategoria: integer): TJSONObject;
function VerificaRequisicao(XCategoria: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaCategoria(XId: integer): TJSONObject;
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
         SQL.Add('select "CodigoInternoCategoria" as id,');
         SQL.Add('       "NomeCategoria"          as nome,');
         SQL.Add('       "AtivoCategoria"         as ativo ');
         SQL.Add('from "Categoria" ');
         SQL.Add('where "CodigoInternoCategoria"=:xid ');
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
        wret.AddPair('description','Nenhuma Categoria encontrada');
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

function RetornaListaCategorias(const XQuery: TDictionary<string, string>; XEmpresa,XLimit,XOffset: integer): TJSONArray;
var wqueryLista: TFDQuery;
    wconexao: TProviderDataModuleConexao;
    wobj: TJSONObject;
    wret: TJSONArray;
    wordem: string;
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
         SQL.Add('select "CodigoInternoCategoria" as id,');
         SQL.Add('       "NomeCategoria"          as nome,');
         SQL.Add('       "AtivoCategoria"         as ativo ');
         SQL.Add('from "Categoria" where "CodigoEmpresaCategoria"=:xempresa ');
         ParamByName('xempresa').AsInteger := wconexao.FIdEmpresaCategoria;
         if XQuery.ContainsKey('nome') then // filtro por nome
            begin
              SQL.Add('and lower("NomeCategoria") like lower(:xnome) ');
              ParamByName('xnome').AsString := XQuery.Items['nome']+'%';
            end;
         if XQuery.ContainsKey('ativo') then // filtro por ativo
            begin
              SQL.Add('and "AtivoCategoria" =:xativo ');
              ParamByName('xativo').AsBoolean := strtobooldef(XQuery.Items['ativo'],false);
            end;
         if XQuery.ContainsKey('order') then // ordenação
            begin
              if XQuery.Items['order']='nome' then
                 wordem := 'order by "NomeCategoria" '
              else if XQuery.Items['order']='ativo' then
                 wordem := 'order by "AtivoCategoria" ';
              if XQuery.ContainsKey('dir') then // direção
                 wordem := wordem +XQuery.Items['dir'];
              SQL.Add(wordem);
            end
         else
            SQL.Add('order by "NomeCategoria" ');
         if XLimit>0 then
            SQL.Add('Limit '+inttostr(XLimit)+' offset '+inttostr(XOffset));
         Open;
         EnableControls;
       end;
    if wqueryLista.RecordCount>0 then
       wret := wqueryLista.ToJSONArray()
    else
       begin
         wobj := TJSONObject.Create;
         wobj.AddPair('status','500');
         wobj.AddPair('description','Nenhuma Categoria encontrada');
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

function RetornaTotalCategorias(const XQuery: TDictionary<string, string>): TJSONObject;
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
         SQL.Add('select count(*) as registros ');
         SQL.Add('from "Categoria" where "CodigoEmpresaCategoria"=:xempresa ');
         if XQuery.ContainsKey('nome') then // filtro por nome
            begin
              SQL.Add('and lower("NomeCategoria") like lower(:xnome) ');
              ParamByName('xnome').AsString := XQuery.Items['nome']+'%';
            end;
         if XQuery.ContainsKey('ativo') then // filtro por ativo
            begin
              SQL.Add('and "AtivoCategoria" =:xativo ');
              ParamByName('xativo').AsBoolean := strtobooldef(XQuery.Items['ativo'],false);
            end;
         ParamByName('xempresa').AsInteger := wconexao.FIdEmpresaCategoria;
         Open;
         EnableControls;
       end;

   if wquery.RecordCount>0 then
      wret := wquery.ToJSONObject()
   else
      begin
        wret := TJSONObject.Create;
        wret.AddPair('status','500');
        wret.AddPair('description','Nenhuma categoria encontrada');
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
//      messagedlg('Problema ao retornar localidade'+slinebreak+E.Message,mterror,[mbok],0);
    end;
  end;
  wconexao.EncerraConexaoDB;
  Result := wret;
end;

function IncluiCategoria(XCategoria: TJSONObject; XIdEmpresa: integer): TJSONObject;
var wquery: TFDMemTable;
    wqueryInsert,wquerySelect: TFDQuery;
    wret: TJSONObject;
    wnum: integer;
    wconexao: TProviderDataModuleConexao;
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
           SQL.Add('Insert into "Categoria" ("CodigoEmpresaCategoria","NomeCategoria","AtivoCategoria","UsuarioUltimaAlteracao") ');
           SQL.Add('values (:xidempresa,:xnome,:xativo,null) ');
           ParamByName('xidempresa').AsInteger   := wconexao.FIdEmpresaCategoria;
           ParamByName('xnome').AsString         := XCategoria.GetValue('nome').Value;
           ParamByName('xativo').AsBoolean       := true;
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
                SQL.Add('select "CodigoInternoCategoria" as id,');
                SQL.Add('       "NomeCategoria"          as nome,');
                SQL.Add('       "AtivoCategoria"         as ativo ');
                SQL.Add('from "Categoria" where "CodigoEmpresaCategoria"=:xempresa and "NomeCategoria"=:xnome ');
                ParamByName('xempresa').AsInteger := wconexao.FIdEmpresaCategoria;
                ParamByName('xnome').AsString     := XCategoria.GetValue('nome').Value;
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhuma Categoria incluída');
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


function AlteraCategoria(XIdCategoria: integer; XCategoria: TJSONObject): TJSONObject;
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
    if XCategoria.TryGetValue('nome',wval) then
       begin
         if wcampos='' then
            wcampos := '"NomeCategoria"=:xnome'
         else
            wcampos := wcampos+',"NomeCategoria"=:xnome';
       end;
    if XCategoria.TryGetValue('ativo',wval) then
       begin
         if wcampos='' then
            wcampos := '"AtivoCategoria"=:xativo'
         else
            wcampos := wcampos+',"AtivoCategoria"=:xativo';
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
           SQL.Add('Update "Categoria" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoCategoria"=:xid ');
           ParamByName('xid').AsInteger       := XIdCategoria;
           if XCategoria.TryGetValue('nome',wval) then
              ParamByName('xnome').AsString   := XCategoria.GetValue('nome').Value;
           if XCategoria.TryGetValue('ativo',wval) then
              ParamByName('xativo').AsBoolean := strtobooldef(XCategoria.GetValue('ativo').Value,false);
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
              SQL.Add('select "CodigoInternoCategoria" as id,');
              SQL.Add('       "NomeCategoria"          as nome,');
              SQL.Add('       "AtivoCategoria"         as ativo ');
              SQL.Add('from "Categoria" ');
              SQL.Add('where "CodigoInternoCategoria" =:xid ');
              ParamByName('xid').AsInteger := XIdCategoria;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhuma Alíquota alterada');
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

function VerificaRequisicao(XCategoria: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XCategoria.TryGetValue('nome',wval) then
       wret := false;
  finally
  end;
  Result := wret;
end;

function ApagaCategoria(XIdCategoria: integer): TJSONObject;
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
         SQL.Add('delete from "Categoria" where "CodigoInternoCategoria"=:xid ');
         ParamByName('xid').AsInteger := XIdCategoria;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Categoria excluída com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhuma Categoria excluída');
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
