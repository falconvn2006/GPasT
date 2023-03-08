unit dat.cadFabricantes;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaFabricante(XId: integer): TJSONObject;
function RetornaListaFabricantes(const XQuery: TDictionary<string, string>): TJSONArray;
function IncluiFabricante(XFabricante: TJSONObject): TJSONObject;
function AlteraFabricante(XIdFabricante: integer; XFabricante: TJSONObject): TJSONObject;
function ApagaFabricante(XIdFabricante: integer): TJSONObject;
function VerificaRequisicao(XFabricante: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaFabricante(XId: integer): TJSONObject;
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
         SQL.Add('select "CodigoInternoFabricante"   as id,');
         SQL.Add('       "DescricaoFabricante"       as descricao,');
         SQL.Add('       "ContatoFabricante"         as contato,');
         SQL.Add('       "FoneFabricante"            as fone,');
         SQL.Add('       "AtivoFabricante"           as ativo,');
         SQL.Add('       "CodigoCategoriaFabricante" as idcategoria ');
         SQL.Add('from "Fabricante" ');
         SQL.Add('where "CodigoInternoFabricante"=:xid ');
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
        wret.AddPair('description','Nenhum Fabricante encontrado');
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

function RetornaListaFabricantes(const XQuery: TDictionary<string, string>): TJSONArray;
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
         SQL.Add('select "CodigoInternoFabricante"   as id,');
         SQL.Add('       "DescricaoFabricante"       as descricao,');
         SQL.Add('       "ContatoFabricante"         as contato,');
         SQL.Add('       "FoneFabricante"            as fone,');
         SQL.Add('       "AtivoFabricante"           as ativo,');
         SQL.Add('       "CodigoCategoriaFabricante" as idcategoria ');
         SQL.Add('from "Fabricante" where "CodigoEmpresaFabricante"=:xempresa ');
         ParamByName('xempresa').AsInteger := wconexao.FIdEmpresaFabricante;
         if XQuery.ContainsKey('descricao') then // filtro por descrição
            begin
              SQL.Add('and lower("DescricaoFabricante") like lower(:xdescricao) ');
              ParamByName('xdescricao').AsString := XQuery.Items['descricao']+'%';
              SQL.Add('order by "DescricaoFabricante" ');
            end;
         if XQuery.ContainsKey('contato') then // filtro por contato
            begin
              SQL.Add('and lower("ContatoFabricante") like lower(:xcontato) ');
              ParamByName('xcontato').AsString := XQuery.Items['contato']+'%';
              SQL.Add('order by "ContatoFabricante" ');
            end;
         if XQuery.ContainsKey('fone') then // filtro por fone
            begin
              SQL.Add('and "FoneFabricante" like :xfone ');
              ParamByName('xfone').AsString := XQuery.Items['fone']+'%';
              SQL.Add('order by "FoneFabricante" ');
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
         wobj.AddPair('description','Nenhum Fabricante encontrado');
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

function IncluiFabricante(XFabricante: TJSONObject): TJSONObject;
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
           SQL.Add('Insert into "Fabricante" ("CodigoEmpresaFabricante","DescricaoFabricante","ContatoFabricante",');
           SQL.Add('"FoneFabricante","AtivoFabricante","CodigoCategoriaFabricante") ');
           SQL.Add('values (:xidempresa,:xdescricao,:xcontato,:xfone,:xativo,(case when :xidcategoria>0 then :xidcategoria else null end)) ');
           ParamByName('xidempresa').AsInteger   := wconexao.FIdEmpresaFabricante;
           ParamByName('xdescricao').AsString    := XFabricante.GetValue('descricao').Value;
           if XFabricante.TryGetValue('contato',wval) then
              ParamByName('xcontato').AsString    := XFabricante.GetValue('contato').Value
           else
              ParamByName('xcontato').AsString    := '';
           if XFabricante.TryGetValue('fone',wval) then
              ParamByName('xfone').AsString    := XFabricante.GetValue('fone').Value
           else
              ParamByName('xfone').AsString    := '';
           if XFabricante.TryGetValue('ativo',wval) then
              ParamByName('xativo').AsBoolean  := strtobooldef(XFabricante.GetValue('ativo').Value,true)
           else
              ParamByName('xativo').AsBoolean  := true;
           if XFabricante.TryGetValue('idcategoria',wval) then
              ParamByName('xidcategoria').AsInteger  := strtointdef(XFabricante.GetValue('idcategoria').Value,0)
           else
              ParamByName('xidcategoria').AsInteger  := 0;
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
                SQL.Add('select "CodigoInternoFabricante"   as id,');
                SQL.Add('       "DescricaoFabricante"       as descricao,');
                SQL.Add('       "ContatoFabricante"         as contato,');
                SQL.Add('       "FoneFabricante"            as fone,');
                SQL.Add('       "AtivoFabricante"           as ativo,');
                SQL.Add('       "CodigoCategoriaFabricante" as idcategoria ');
                SQL.Add('from "Fabricante" where "CodigoEmpresaFabricante"=:xempresa and "DescricaoFabricante"=:xdescricao ');
                ParamByName('xempresa').AsInteger  := wconexao.FIdEmpresaFabricante;
                ParamByName('xdescricao').AsString := XFabricante.GetValue('descricao').Value;
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Fabricante incluído');
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


function AlteraFabricante(XIdFabricante: integer; XFabricante: TJSONObject): TJSONObject;
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
    if XFabricante.TryGetValue('descricao',wval) then
       begin
         if wcampos='' then
            wcampos := '"DescricaoFabricante"=:xdescricao'
         else
            wcampos := wcampos+',"DescricaoFabricante"=:xdescricao';
       end;
    if XFabricante.TryGetValue('contato',wval) then
       begin
         if wcampos='' then
            wcampos := '"ContatoFabricante"=:xcontato'
         else
            wcampos := wcampos+',"ContatoFabricante"=:xcontato';
       end;
    if XFabricante.TryGetValue('fone',wval) then
       begin
         if wcampos='' then
            wcampos := '"FoneFabricante"=:xfone'
         else
            wcampos := wcampos+',"FoneFabricante"=:xfone';
       end;
    if XFabricante.TryGetValue('ativo',wval) then
       begin
         if wcampos='' then
            wcampos := '"AtivoFabricante"=:xativo'
         else
            wcampos := wcampos+',"AtivoFabricante"=:xativo';
       end;
    if XFabricante.TryGetValue('idcategoria',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoCategoriaFabricante"=:xidcategoria'
         else
            wcampos := wcampos+',"CodigoCategoriaFabricante"=:xidcategoria';
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
           SQL.Add('Update "Fabricante" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoFabricante"=:xid ');
           ParamByName('xid').AsInteger       := XIdFabricante;
           if XFabricante.TryGetValue('descricao',wval) then
              ParamByName('xdescricao').AsString   := XFabricante.GetValue('descricao').Value;
           if XFabricante.TryGetValue('contato',wval) then
              ParamByName('xcontato').AsString     := XFabricante.GetValue('contato').Value;
           if XFabricante.TryGetValue('fone',wval) then
              ParamByName('xfone').AsString        := XFabricante.GetValue('fone').Value;
           if XFabricante.TryGetValue('ativo',wval) then
              ParamByName('xativo').AsBoolean      := strtobooldef(XFabricante.GetValue('ativo').Value,true);
           if XFabricante.TryGetValue('idcategoria',wval) then
              ParamByName('xidcategoria').AsInteger:= strtointdef(XFabricante.GetValue('idcategoria').Value,0);
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
              SQL.Add('select "CodigoInternoFabricante"   as id,');
              SQL.Add('       "DescricaoFabricante"       as descricao,');
              SQL.Add('       "ContatoFabricante"         as contato,');
              SQL.Add('       "FoneFabricante"            as fone,');
              SQL.Add('       "AtivoFabricante"           as ativo,');
              SQL.Add('       "CodigoCategoriaFabricante" as idcategoria ');
              SQL.Add('from "Fabricante" ');
              SQL.Add('where "CodigoInternoFabricante" =:xid ');
              ParamByName('xid').AsInteger := XIdFabricante;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Fabricante alterado');
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

function VerificaRequisicao(XFabricante: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XFabricante.TryGetValue('descricao',wval) then
       wret := false;
  finally
  end;
  Result := wret;
end;

function ApagaFabricante(XIdFabricante: integer): TJSONObject;
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
         SQL.Add('delete from "Fabricante" where "CodigoInternoFabricante"=:xid ');
         ParamByName('xid').AsInteger := XIdFabricante;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Fabricante excluído com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhum Fabricante excluído');
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
