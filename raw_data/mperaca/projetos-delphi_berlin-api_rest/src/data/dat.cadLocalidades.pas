unit dat.cadLocalidades;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaLocalidade(XId: integer): TJSONObject;
function RetornaTotalLocalidades(const XQuery: TDictionary<string, string>): TJSONObject;
function RetornaListaLocalidades(const XQuery: TDictionary<string, string>; XLimit,XOffset: integer): TJSONArray;
function IncluiLocalidade(XLocalidade: TJSONObject; XIdEmpresa: integer): TJSONObject;
function AlteraLocalidade(XIdLocalidade: integer; XLocalidade: TJSONObject): TJSONObject;
function ApagaLocalidade(XIdLocalidade: integer): TJSONObject;
function VerificaRequisicao(XLocalidade: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaLocalidade(XId: integer): TJSONObject;
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
         SQL.Add('select "CodigoInternoLocalidade" as id,');
         SQL.Add('       "NomeLocalidade"          as nome,');
         SQL.Add('       "EstadoLocalidade"        as uf, ');
         SQL.Add('       "RegiaoLocalidade"        as regiao, ');
         SQL.Add('       "CodigoLocalidade"        as codibge ');
         SQL.Add('from "Localidade" ');
         SQL.Add('where "CodigoInternoLocalidade"=:xid ');
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
        wret.AddPair('description','Nenhuma localidade encontrada');
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

function RetornaTotalLocalidades(const XQuery: TDictionary<string, string>): TJSONObject;
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
         SQL.Add('from "Localidade" where "CodigoEmpresaLocalidade"=:xempresa ');
         if XQuery.ContainsKey('nome') then // filtro por nome
            begin
              SQL.Add('and lower("NomeLocalidade") like lower(:xnome) ');
              ParamByName('xnome').AsString := XQuery.Items['nome']+'%';
            end
         else if XQuery.ContainsKey('uf') then // filtro por uf
            begin
              SQL.Add('and lower("EstadoLocalidade") like lower(:xuf) ');
              ParamByName('xuf').AsString := XQuery.Items['uf']+'%';
            end
         else if XQuery.ContainsKey('regiao') then // filtro por regiao
            begin
              SQL.Add('and lower("RegiaoLocalidade") like lower(:xregiao) ');
              ParamByName('xregiao').AsString := XQuery.Items['regiao']+'%';
            end
         else if XQuery.ContainsKey('codibge') then // filtro por codibge
            begin
              SQL.Add('and lower("CodigoLocalidade") like lower(:xcodibge) ');
              ParamByName('xcodibge').AsString := XQuery.Items['codibge']+'%';
            end;
         ParamByName('xempresa').AsInteger := wconexao.FIdEmpresaLocalidade;
         Open;
         EnableControls;
       end;

   if wquery.RecordCount>0 then
      wret := wquery.ToJSONObject()
   else
      begin
        wret := TJSONObject.Create;
        wret.AddPair('status','500');
        wret.AddPair('description','Nenhuma localidade encontrada');
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


function RetornaListaLocalidades(const XQuery: TDictionary<string, string>; XLimit,XOffset: integer): TJSONArray;
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
         SQL.Add('select "CodigoInternoLocalidade" as id,');
         SQL.Add('       "NomeLocalidade"          as nome,');
         SQL.Add('       "EstadoLocalidade"        as uf, ');
         SQL.Add('       "RegiaoLocalidade"        as regiao, ');
         SQL.Add('       "CodigoLocalidade"        as codibge ');
         SQL.Add('from "Localidade" where "CodigoEmpresaLocalidade"=:xempresa ');
         ParamByName('xempresa').AsInteger := wconexao.FIdEmpresaLocalidade;
         if XQuery.ContainsKey('nome') then // filtro por nome
            begin
              SQL.Add('and lower("NomeLocalidade") like lower(:xnome) ');
              ParamByName('xnome').AsString := XQuery.Items['nome']+'%';
            end;
         if XQuery.ContainsKey('uf') then // filtro por uf
            begin
              SQL.Add('and lower("EstadoLocalidade") like lower(:xuf) ');
              ParamByName('xuf').AsString := XQuery.Items['uf']+'%';
            end;
         if XQuery.ContainsKey('regiao') then // filtro por região
            begin
              SQL.Add('and lower("RegiaoLocalidade") like lower(:xregiao) ');
              ParamByName('xregiao').AsString := XQuery.Items['regiao']+'%';
            end;
         if XQuery.ContainsKey('codibge') then // filtro por código ibge
            begin
              SQL.Add('and "CodigoLocalidade" like :xcodibge ');
              ParamByName('xcodibge').AsString := XQuery.Items['codibge']+'%';
            end;
         if XQuery.ContainsKey('order') then // ordenação
            begin
              if XQuery.Items['order']='nome' then
                 wordem := 'order by upper("NomeLocalidade") '
              else if XQuery.Items['order']='uf' then
                 wordem := 'order by upper("EstadoLocalidade") '
              else if XQuery.Items['order']='regiao' then
                 wordem := 'order by upper("RegiaoLocalidade") '
              else if XQuery.Items['order']='codibge' then
                 wordem := 'order by upper("CodigoLocalidade") ';
              if XQuery.ContainsKey('dir') then // direção
                 wordem := wordem +XQuery.Items['dir'];
              SQL.Add(wordem);
            end
         else
            SQL.Add('order by upper("NomeLocalidade") ');
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
         wobj.AddPair('description','Nenhuma localidade encontrada');
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
//      messagedlg('Problema ao retorna listas de localidades'+slinebreak+E.Message,mterror,[mbok],0);
    end;
  end;
  wconexao.EncerraConexaoDB;
  Result := wret;
//  wquery.Free;
end;

function IncluiLocalidade(XLocalidade: TJSONObject; XIdEmpresa: integer): TJSONObject;
var wquery: TFDMemTable;
    wqueryInsert,wquerySelect: TFDQuery;
    wret: TJSONObject;
    wnum: integer;
    wconexao: TProviderDataModuleConexao;
begin
  try
    wconexao := TProviderDataModuleConexao.Create(nil);
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
           SQL.Add('Insert into "Localidade" ("CodigoEmpresaLocalidade","NomeLocalidade","EstadoLocalidade","RegiaoLocalidade","CodigoLocalidade") ');
           SQL.Add('values (:xidempresa,:xnome,:xuf,:xregiao,:xcodigo) ');
           ParamByName('xidempresa').AsInteger := wconexao.FIdEmpresaLocalidade;
           ParamByName('xnome').AsString       := XLocalidade.GetValue('nome').Value;
           ParamByName('xuf').AsString         := XLocalidade.GetValue('uf').Value;
           ParamByName('xregiao').AsString     := XLocalidade.GetValue('regiao').Value;
           ParamByName('xcodigo').AsInteger    := strtoint(XLocalidade.GetValue('codibge').Value);
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
                SQL.Add('select "CodigoInternoLocalidade" as id,');
                SQL.Add('       "NomeLocalidade"          as nome,');
                SQL.Add('       "EstadoLocalidade"        as uf, ');
                SQL.Add('       "RegiaoLocalidade"        as regiao, ');
                SQL.Add('       "CodigoLocalidade"        as codibge ');
                SQL.Add('from "Localidade" ');
                SQL.Add('where "CodigoEmpresaLocalidade"=:xempresa and "NomeLocalidade" =:xnome ');
                ParamByName('xempresa').AsInteger := wconexao.FIdEmpresaLocalidade;
                ParamByName('xnome').AsString := XLocalidade.GetValue('nome').Value;
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
           end
        else
           begin
             wret := TJSONObject.Create;
             wret.AddPair('status','500');
             wret.AddPair('description','Nenhuma localidade incluída');
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
//      messagedlg('Problema ao incluir nova localidade'+slinebreak+E.Message,mterror,[mbok],0);
    end;
  end;
  wconexao.EncerraConexaoDB;
  Result := wret;
//  wquery.Free;
end;


function AlteraLocalidade(XIdLocalidade: integer; XLocalidade: TJSONObject): TJSONObject;
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
    if XLocalidade.TryGetValue('nome',wval) then
       begin
         if wcampos='' then
            wcampos := '"NomeLocalidade"=:xnome'
         else
            wcampos := wcampos+',"NomeLocalidade"=:xnome';
       end;
    if XLocalidade.TryGetValue('uf',wval) then
       begin
         if wcampos='' then
            wcampos := '"EstadoLocalidade"=:xuf'
         else
            wcampos := wcampos+',"EstadoLocalidade"=:xuf';
       end;
    if XLocalidade.TryGetValue('regiao',wval) then
       begin
         if wcampos='' then
            wcampos := '"RegiaoLocalidade"=:xregiao'
         else
            wcampos := wcampos+',"RegiaoLocalidade"=:xregiao';
       end;
    if XLocalidade.TryGetValue('codibge',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoLocalidade"=:xcodibge'
         else
            wcampos := wcampos+',"CodigoLocalidade"=:xcodibge';
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
           SQL.Add('Update "Localidade" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoLocalidade"=:xid ');
           ParamByName('xid').AsInteger      := XIdLocalidade;
           if XLocalidade.TryGetValue('nome',wval) then
              ParamByName('xnome').AsString  := XLocalidade.GetValue('nome').Value;
           if XLocalidade.TryGetValue('uf',wval) then
              ParamByName('xuf').AsString       := XLocalidade.GetValue('uf').Value;
           if XLocalidade.TryGetValue('regiao',wval) then
              ParamByName('xregiao').AsString   := XLocalidade.GetValue('regiao').Value;
           if XLocalidade.TryGetValue('codibge',wval) then
              ParamByName('xcodibge').AsInteger := strtoint(XLocalidade.GetValue('codibge').Value);
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
              SQL.Add('select "CodigoInternoLocalidade" as id,');
              SQL.Add('       "NomeLocalidade"          as nome,');
              SQL.Add('       "EstadoLocalidade"        as uf, ');
              SQL.Add('       "RegiaoLocalidade"        as regiao, ');
              SQL.Add('       "CodigoLocalidade"        as codibge ');
              SQL.Add('from "Localidade" ');
              SQL.Add('where "CodigoInternoLocalidade" =:xid ');
              ParamByName('xid').AsInteger := XIdLocalidade;
              Open;
              EnableControls;
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhuma localidade alterada');
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
//      messagedlg('Problema ao alterar localidade'+slinebreak+E.Message,mterror,[mbok],0);
    end;
  end;
  wconexao.EncerraConexaoDB;
  Result := wret;
//  wquery.Free;
end;


function VerificaRequisicao(XLocalidade: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XLocalidade.TryGetValue('nome',wval) then
       wret := false
    else if not XLocalidade.TryGetValue('uf',wval) then
       wret := false
    else if not XLocalidade.TryGetValue('regiao',wval) then
       wret := false
    else if not XLocalidade.TryGetValue('codibge',wval) then
       wret := false;
  finally
  end;
  Result := wret;
end;

function ApagaLocalidade(XIdLocalidade: integer): TJSONObject;
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
         SQL.Add('delete from "Localidade" where "CodigoInternoLocalidade"=:xid ');
         ParamByName('xid').AsInteger := XIdLocalidade;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Localidade excluída com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhuma localidade excluída');
       end;
    wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
  except
    On E: Exception do
    begin
      wconexao.EncerraConexaoDB;
      wret.AddPair('status','500');
      wret.AddPair('description',E.Message);
      wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
//      messagedlg('Problema ao excluir localidade'+slinebreak+E.Message,mterror,[mbok],0);
    end;
  end;
  wconexao.EncerraConexaoDB;
  Result := wret;
end;


end.
