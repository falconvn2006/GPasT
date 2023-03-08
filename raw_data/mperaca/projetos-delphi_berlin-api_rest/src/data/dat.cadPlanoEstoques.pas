unit dat.cadPlanoEstoques;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaPlano(XIdPlano: integer): TJSONObject;
function RetornaListaPlanos(const XQuery: TDictionary<string, string>;XLimit,XOffset: integer): TJSONArray;
function RetornaTotalPlanos(const XQuery: TDictionary<string, string>): TJSONObject;
function IncluiPlano(XPlano: TJSONObject): TJSONObject;
function AlteraPlano(XIdPlano: integer; XPlano: TJSONObject): TJSONObject;
function ApagaPlano(XIdPlano: integer): TJSONObject;
function VerificaRequisicao(XPlano: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaPlano(XIdPlano: integer): TJSONObject;
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
         SQL.Add('select "CodigoInternoPlanoEstoque"   as id,');
         SQL.Add('       "EstruturalPlanoEstoque"      as estrutural,');
         SQL.Add('       "NomeContaPlanoEstoque"       as nomeconta,');
         SQL.Add('       "FormulaPlanoEstoque"         as idformula,');
         SQL.Add('       "AncestralConta1PlanoEstoque" as idancestral1,');
         SQL.Add('       "AncestralConta2PlanoEstoque" as idancestral2,');
         SQL.Add('       "AncestralConta3PlanoEstoque" as idancestral3,');
         SQL.Add('       "AncestralConta4PlanoEstoque" as idancestral4,');
         SQL.Add('       "AncestralConta5PlanoEstoque" as idancestral5,');
         SQL.Add('       "AncestralConta6PlanoEstoque" as idancestral6,');
         SQL.Add('       "AncestralConta7PlanoEstoque" as idancestral7,');
         SQL.Add('       "CodigoFormulaPlanoEstoque"   as codformula,');
         SQL.Add('       "MargemLucroPlanoEstoque"     as margemlucro,');
         SQL.Add('       "ImagemPlanoEstoque"          as imagem,');
         SQL.Add('       "AtivoPlanoEstoque"           as ativo,');
         SQL.Add('       "CodigoCategoriaPlanoEstoque" as idcategoria,');
         SQL.Add('       "CodigoFamiliaPlanoEstoque"   as idfamilia,');
         SQL.Add('       (select cast(coalesce(count("CodigoInternoProduto"),0) as integer) from "Produto" where "CodigoEstruturalProduto" = "PlanodeEstoque"."CodigoInternoPlanoEstoque" and "Produto"."AtivoProduto"=true) as xqtdeproduto,');
         SQL.Add('       (select cast(coalesce("NomeCategoria",'''') as varchar(100)) from "Categoria" where "CodigoInternoCategoria"="PlanodeEstoque"."CodigoCategoriaPlanoEstoque") as xcategoria ');
         SQL.Add('from "PlanodeEstoque" ');
         SQL.Add('where "CodigoInternoPlanoEstoque"=:xid ');
         ParamByName('xid').AsInteger := XIdPlano;
         Open;
         EnableControls;
       end;

   if wquery.RecordCount>0 then
      wret := wquery.ToJSONObject()
   else
      begin
        wret := TJSONObject.Create;
        wret.AddPair('status','500');
        wret.AddPair('description','Nenhum Plano de Estoque encontrado');
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

function RetornaTotalPlanos(const XQuery: TDictionary<string, string>): TJSONObject;
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
         SQL.Add('from "PlanodeEstoque" where "CodigoEmpresaPlanoEstoque"=:xempresa ');
         if XQuery.ContainsKey('estrutural') then // filtro por estrutural
            begin
              SQL.Add('and "EstruturalPlanoEstoque" like :xestrutural ');
              ParamByName('xestrutural').AsString := XQuery.Items['estrutural']+'%';
            end;
         if XQuery.ContainsKey('nomeconta') then // filtro por nomeconta
            begin
              SQL.Add('and lower("nomeconta") like lower(:xnomeconta) ');
              ParamByName('xnomeconta').AsString := XQuery.Items['nomeconta']+'%';
            end;
         if XQuery.ContainsKey('ativo') then // filtro por nomeconta
            begin
              SQL.Add('and "ativo" =:xativo ');
              ParamByName('xativo').AsBoolean := strtobooldef(XQuery.Items['ativo'],false);
            end;
         ParamByName('xempresa').AsInteger := wconexao.FIdEmpresaPlanoEstoque;
         Open;
         EnableControls;
       end;

   if wquery.RecordCount>0 then
      wret := wquery.ToJSONObject()
   else
      begin
        wret := TJSONObject.Create;
        wret.AddPair('status','500');
        wret.AddPair('description','Nenhuma plano de estoque encontrado');
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


function RetornaListaPlanos(const XQuery: TDictionary<string, string>; XLimit,XOffset: integer): TJSONArray;
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
         SQL.Add('select "CodigoInternoPlanoEstoque"   as id,');
         SQL.Add('       "EstruturalPlanoEstoque"      as estrutural,');
         SQL.Add('       "NomeContaPlanoEstoque"       as nomeconta,');
         SQL.Add('       "FormulaPlanoEstoque"         as idformula,');
         SQL.Add('       "AncestralConta1PlanoEstoque" as idancestral1,');
         SQL.Add('       "AncestralConta2PlanoEstoque" as idancestral2,');
         SQL.Add('       "AncestralConta3PlanoEstoque" as idancestral3,');
         SQL.Add('       "AncestralConta4PlanoEstoque" as idancestral4,');
         SQL.Add('       "AncestralConta5PlanoEstoque" as idancestral5,');
         SQL.Add('       "AncestralConta6PlanoEstoque" as idancestral6,');
         SQL.Add('       "AncestralConta7PlanoEstoque" as idancestral7,');
         SQL.Add('       "CodigoFormulaPlanoEstoque"   as codformula,');
         SQL.Add('       "MargemLucroPlanoEstoque"     as margemlucro,');
         SQL.Add('       "ImagemPlanoEstoque"          as imagem,');
         SQL.Add('       "AtivoPlanoEstoque"           as ativo,');
         SQL.Add('       "CodigoCategoriaPlanoEstoque" as idcategoria,');
         SQL.Add('       "CodigoFamiliaPlanoEstoque"   as idfamilia,');
         SQL.Add('       (select cast(coalesce(count("CodigoInternoProduto"),0) as integer) from "Produto"   where "CodigoEstruturalProduto" = "PlanodeEstoque"."CodigoInternoPlanoEstoque" and "Produto"."AtivoProduto"=true) as xqtdeproduto,');
         SQL.Add('       (select cast(coalesce("NomeCategoria",'''') as varchar(100))         from "Categoria" where "CodigoInternoCategoria"  = "PlanodeEstoque"."CodigoCategoriaPlanoEstoque") as xcategoria ');
         SQL.Add('from "PlanodeEstoque" ');
         SQL.Add('where "CodigoEmpresaPlanoEstoque"=:xempresa ');
         if XQuery.ContainsKey('nomeconta') then // filtro por nome
            begin
              SQL.Add('and lower("NomeContaPlanoEstoque") like lower(:xnomeconta) ');
              ParamByName('xnomeconta').AsString := XQuery.Items['nomeconta']+'%';
            end;
         if XQuery.ContainsKey('estrutural') then // filtro por codigo
            begin
              SQL.Add('and "EstruturalPlanoEstoque" like :xestrutural ');
              ParamByName('xestrutural').AsString := XQuery.Items['estrutural']+'%';
            end;
         if XQuery.ContainsKey('order') then // ordenação
            begin
              if XQuery.Items['order']='estrutural' then
                 wordem := 'order by "EstruturalPlanoEstoque" '
              else if XQuery.Items['order']='nomeconta' then
                 wordem := 'order by upper("NomeContaPlanoEstoque") '
              else if XQuery.Items['order']='ativo' then
                 wordem := 'order by "AtivoPlanoEstoque" '
              else if XQuery.Items['order']='xqtdeproduto' then
                 wordem := 'order by "xqtdeproduto","EstruturalPlanoEstoque" '
              else if XQuery.Items['order']='xcategoria' then
                 wordem := 'order by "xcategoria","EstruturalPlanoEstoque" ';
              if XQuery.ContainsKey('dir') then // direção
                 wordem := wordem +XQuery.Items['dir'];
              SQL.Add(wordem);
            end
         else
            SQL.Add('order by "EstruturalPlanoEstoque" ');
         if XLimit>0 then
            SQL.Add('Limit '+inttostr(XLimit)+' offset '+inttostr(XOffset));
         ParambyName('xempresa').asInteger := wconexao.FIdEmpresaPlanoEstoque;
         Open;
         EnableControls;
       end;
    if wqueryLista.RecordCount>0 then
       wret := wqueryLista.ToJSONArray()
    else
       begin
         wobj := TJSONObject.Create;
         wobj.AddPair('status','500');
         wobj.AddPair('description','Nenhum Plano de Estoque encontrado');
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
           SQL.Add('Insert into "PlanodeEstoque" ("CodigoEmpresaPlanoEstoque","EstruturalPlanoEstoque","NomeContaPlanoEstoque","FormulaPlanoEstoque",');
           SQL.Add('"AncestralConta1PlanoEstoque","AncestralConta2PlanoEstoque","AncestralConta3PlanoEstoque","AncestralConta4PlanoEstoque","AncestralConta5PlanoEstoque",');
           SQL.Add('"AncestralConta6PlanoEstoque","AncestralConta7PlanoEstoque","CodigoFormulaPlanoEstoque","MargemLucroPlanoEstoque","ImagemPlanoEstoque",');
           SQL.Add('"AtivoPlanoEstoque","CodigoCategoriaPlanoEstoque","CodigoFamiliaPlanoEstoque") ');
           SQL.Add('values (:xidempresa,:xestrutural,:xnomeconta,(case when :xidformula>0 then :xidformula else null end),');
           SQL.Add(':xidancestral1,:xidancestral2,:xidancestral3,:xidancestral4,:xidancestral5,');
           SQL.Add(':xidancestral6,:xidancestral7,:xcodformula,:xmargemlucro,:ximagem,');
           SQL.Add(':xativo,(case when :xidcategoria>0 then :xidcategoria else null end),(case when :xidfamilia>0 then :xidfamilia else null end)) ');
           ParamByName('xidempresa').AsInteger   := wconexao.FIdEmpresaPlanoEstoque;
           if XPlano.TryGetValue('estrutural',wval) then
              ParamByName('xestrutural').AsString := XPlano.GetValue('estrutural').Value
           else
              ParamByName('xestrutural').AsString := '';
           if XPlano.TryGetValue('nomeconta',wval) then
              ParamByName('xnomeconta').AsString := XPlano.GetValue('nomeconta').Value
           else
              ParamByName('xnomeconta').AsString := '';
           if XPlano.TryGetValue('idformula',wval) then
              ParamByName('xidformula').AsInteger := strtointdef(XPlano.GetValue('idformula').Value,0)
           else
              ParamByName('xidformula').AsInteger := 0;
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
           if XPlano.TryGetValue('codformula',wval) then
              ParamByName('xcodformula').AsInteger := strtointdef(XPlano.GetValue('codformula').Value,0)
           else
              ParamByName('xcodformula').AsInteger := 0;
           if XPlano.TryGetValue('margemlucro',wval) then
              ParamByName('xmargemlucro').AsFloat  := strtointdef(XPlano.GetValue('margemlucro').Value,0)
           else
              ParamByName('xmargemlucro').AsFloat  := 0;
           if XPlano.TryGetValue('imagem',wval) then
              ParamByName('ximagem').AsString := XPlano.GetValue('imagem').Value
           else
              ParamByName('ximagem').AsString := '';
           if XPlano.TryGetValue('ativo',wval) then
              ParamByName('xativo').AsBoolean  := strtobooldef(XPlano.GetValue('ativo').Value,true)
           else
              ParamByName('xativo').AsBoolean  := true;
           if XPlano.TryGetValue('idcategoria',wval) then
              ParamByName('xidcategoria').AsInteger := strtointdef(XPlano.GetValue('idcategoria').Value,0)
           else
              ParamByName('xidcategoria').AsInteger := 0;
           if XPlano.TryGetValue('idfamilia',wval) then
              ParamByName('xidfamilia').AsInteger := strtointdef(XPlano.GetValue('idfamilia').Value,0)
           else
              ParamByName('xidfamilia').AsInteger := 0;
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
                SQL.Add('select "CodigoInternoPlanoEstoque"   as id,');
                SQL.Add('       "EstruturalPlanoEstoque"      as estrutural,');
                SQL.Add('       "NomeContaPlanoEstoque"       as nomeconta,');
                SQL.Add('       "FormulaPlanoEstoque"         as idformula,');
                SQL.Add('       "AncestralConta1PlanoEstoque" as idancestral1,');
                SQL.Add('       "AncestralConta2PlanoEstoque" as idancestral2,');
                SQL.Add('       "AncestralConta3PlanoEstoque" as idancestral3,');
                SQL.Add('       "AncestralConta4PlanoEstoque" as idancestral4,');
                SQL.Add('       "AncestralConta5PlanoEstoque" as idancestral5,');
                SQL.Add('       "AncestralConta6PlanoEstoque" as idancestral6,');
                SQL.Add('       "AncestralConta7PlanoEstoque" as idancestral7,');
                SQL.Add('       "CodigoFormulaPlanoEstoque"   as codformula,');
                SQL.Add('       "MargemLucroPlanoEstoque"     as margemlucro,');
                SQL.Add('       "ImagemPlanoEstoque"          as imagem,');
                SQL.Add('       "AtivoPlanoEstoque"           as ativo,');
                SQL.Add('       "CodigoCategoriaPlanoEstoque" as idcategoria,');
                SQL.Add('       "CodigoFamiliaPlanoEstoque"   as idfamilia ');
                SQL.Add('from "PlanodeEstoque" where "CodigoEmpresaPlanoEstoque"=:xidempresa and "EstruturalPlanoEstoque"=:xestrutural ');
                ParamByName('xidempresa').AsInteger  := wconexao.FIdEmpresaPlanoEstoque;
                ParamByName('xestrutural').AsString  := XPlano.GetValue('estrutural').Value;
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Plano de Estoque incluído');
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
            wcampos := '"EstruturalPlanoEstoque"=:xestrutural'
         else
            wcampos := wcampos+',"EstruturalPlanoEstoque"=:xestrutural';
       end;
    if XPlano.TryGetValue('nomeconta',wval) then
       begin
         if wcampos='' then
            wcampos := '"NomeContaPlanoEstoque"=:xnomeconta'
         else
            wcampos := wcampos+',"NomeContaPlanoEstoque"=:xnomeconta';
       end;
    if XPlano.TryGetValue('idformula',wval) then
       begin
         if wcampos='' then
            wcampos := '"FormulaPlanoEstoque"=:xidformula'
         else
            wcampos := wcampos+',"FormulaPlanoEstoque"=:xidformula';
       end;
    if XPlano.TryGetValue('idancestral1',wval) then
       begin
         if wcampos='' then
            wcampos := '"AncestralConta1PlanoEstoque"=:xidancestral1'
         else
            wcampos := wcampos+',"AncestralConta1PlanoEstoque"=:xidancestral1';
       end;
    if XPlano.TryGetValue('idancestral2',wval) then
       begin
         if wcampos='' then
            wcampos := '"AncestralConta2PlanoEstoque"=:xidancestral2'
         else
            wcampos := wcampos+',"AncestralConta2PlanoEstoque"=:xidancestral2';
       end;
    if XPlano.TryGetValue('idancestral3',wval) then
       begin
         if wcampos='' then
            wcampos := '"AncestralConta3PlanoEstoque"=:xidancestral3'
         else
            wcampos := wcampos+',"AncestralConta3PlanoEstoque"=:xidancestral3';
       end;
    if XPlano.TryGetValue('idancestral4',wval) then
       begin
         if wcampos='' then
            wcampos := '"AncestralConta4PlanoEstoque"=:xidancestral4'
         else
            wcampos := wcampos+',"AncestralConta4PlanoEstoque"=:xidancestral4';
       end;
    if XPlano.TryGetValue('idancestral5',wval) then
       begin
         if wcampos='' then
            wcampos := '"AncestralConta5PlanoEstoque"=:xidancestral5'
         else
            wcampos := wcampos+',"AncestralConta5PlanoEstoque"=:xidancestral5';
       end;
    if XPlano.TryGetValue('idancestral6',wval) then
       begin
         if wcampos='' then
            wcampos := '"AncestralConta6PlanoEstoque"=:xidancestral6'
         else
            wcampos := wcampos+',"AncestralConta6PlanoEstoque"=:xidancestral6';
       end;
    if XPlano.TryGetValue('idancestral7',wval) then
       begin
         if wcampos='' then
            wcampos := '"AncestralConta7PlanoEstoque"=:xidancestral7'
         else
            wcampos := wcampos+',"AncestralConta7PlanoEstoque"=:xidancestral7';
       end;
    if XPlano.TryGetValue('codformula',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoFormulaPlanoEstoque"=:xcodformula'
         else
            wcampos := wcampos+',"CodigoFormulaPlanoEstoque"=:xcodformula';
       end;
    if XPlano.TryGetValue('margemlucro',wval) then
       begin
         if wcampos='' then
            wcampos := '"MargemLucroPlanoEstoque"=:xmargemlucro'
         else
            wcampos := wcampos+',"MargemLucroPlanoEstoque"=:xmargemlucro';
       end;
    if XPlano.TryGetValue('imagem',wval) then
       begin
         if wcampos='' then
            wcampos := '"ImagemPlanoEstoque"=:ximagem'
         else
            wcampos := wcampos+',"ImagemPlanoEstoque"=:ximagem';
       end;
    if XPlano.TryGetValue('ativo',wval) then
       begin
         if wcampos='' then
            wcampos := '"AtivoPlanoEstoque"=:xativo'
         else
            wcampos := wcampos+',"AtivoPlanoEstoque"=:xativo';
       end;
    if XPlano.TryGetValue('idcategoria',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoCategoriaPlanoEstoque"=:xidcategoria'
         else
            wcampos := wcampos+',"CodigoCategoriaPlanoEstoque"=:xidcategoria';
       end;
    if XPlano.TryGetValue('idfamilia',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoFamiliaPlanoEstoque"=:xidfamilia'
         else
            wcampos := wcampos+',"CodigoFamiliaPlanoEstoque"=:xidfamilia';
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
           SQL.Add('Update "PlanodeEstoque" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoPlanoEstoque"=:xid ');
           ParamByName('xid').AsInteger                := XIdPlano;
           if XPlano.TryGetValue('estrutural',wval) then
              ParamByName('xestrutural').AsString      := XPlano.GetValue('estrutural').Value;
           if XPlano.TryGetValue('nomeconta',wval) then
              ParamByName('xnomeconta').AsString       := XPlano.GetValue('nomeconta').Value;
           if XPlano.TryGetValue('idformula',wval) then
              ParamByName('xidformula').AsInteger      := strtointdef(XPlano.GetValue('idformula').Value,0);
           if XPlano.TryGetValue('idancestral1',wval) then
              ParamByName('xidancestral1').AsInteger   := strtointdef(XPlano.GetValue('idancestral1').Value,0);
           if XPlano.TryGetValue('idancestral2',wval) then
              ParamByName('xidancestral2').AsInteger   := strtointdef(XPlano.GetValue('idancestral2').Value,0);
           if XPlano.TryGetValue('idancestral3',wval) then
              ParamByName('xidancestral3').AsInteger   := strtointdef(XPlano.GetValue('idancestral3').Value,0);
           if XPlano.TryGetValue('idancestral4',wval) then
              ParamByName('xidancestral4').AsInteger   := strtointdef(XPlano.GetValue('idancestral4').Value,0);
           if XPlano.TryGetValue('idancestral5',wval) then
              ParamByName('xidancestral5').AsInteger   := strtointdef(XPlano.GetValue('idancestral5').Value,0);
           if XPlano.TryGetValue('idancestral6',wval) then
              ParamByName('xidancestral6').AsInteger   := strtointdef(XPlano.GetValue('idancestral6').Value,0);
           if XPlano.TryGetValue('idancestral7',wval) then
              ParamByName('xidancestral7').AsInteger   := strtointdef(XPlano.GetValue('idancestral7').Value,0);
           if XPlano.TryGetValue('codformula',wval) then
              ParamByName('xcodformula').AsInteger     := strtointdef(XPlano.GetValue('codformula').Value,0);
           if XPlano.TryGetValue('margemlucro',wval) then
              ParamByName('xmargemlucro').AsInteger    := strtointdef(XPlano.GetValue('margemlucro').Value,0);
           if XPlano.TryGetValue('imagem',wval) then
              ParamByName('ximagem').AsString          := XPlano.GetValue('imagem').Value;
           if XPlano.TryGetValue('ativo',wval) then
              ParamByName('xativo').AsBoolean          := strtobooldef(XPlano.GetValue('ativo').Value,false);
           if XPlano.TryGetValue('idcategoria',wval) then
              ParamByName('xidcategoria').AsInteger    := strtointdef(XPlano.GetValue('idcategoria').Value,0);
           if XPlano.TryGetValue('idfamilia',wval) then
              ParamByName('xidfamilia').AsInteger      := strtointdef(XPlano.GetValue('idfamilia').Value,0);
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
              SQL.Add('select "CodigoInternoPlanoEstoque"   as id,');
              SQL.Add('       "EstruturalPlanoEstoque"      as estrutural,');
              SQL.Add('       "NomeContaPlanoEstoque"       as nomeconta,');
              SQL.Add('       "FormulaPlanoEstoque"         as idformula,');
              SQL.Add('       "AncestralConta1PlanoEstoque" as idancestral1,');
              SQL.Add('       "AncestralConta2PlanoEstoque" as idancestral2,');
              SQL.Add('       "AncestralConta3PlanoEstoque" as idancestral3,');
              SQL.Add('       "AncestralConta4PlanoEstoque" as idancestral4,');
              SQL.Add('       "AncestralConta5PlanoEstoque" as idancestral5,');
              SQL.Add('       "AncestralConta6PlanoEstoque" as idancestral6,');
              SQL.Add('       "AncestralConta7PlanoEstoque" as idancestral7,');
              SQL.Add('       "CodigoFormulaPlanoEstoque"   as codformula,');
              SQL.Add('       "MargemLucroPlanoEstoque"     as margemlucro,');
              SQL.Add('       "ImagemPlanoEstoque"          as imagem,');
              SQL.Add('       "AtivoPlanoEstoque"           as ativo,');
              SQL.Add('       "CodigoCategoriaPlanoEstoque" as idcategoria,');
              SQL.Add('       "CodigoFamiliaPlanoEstoque"   as idfamilia ');
              SQL.Add('from "PlanodeEstoque" ');
              SQL.Add('where "CodigoInternoPlanoEstoque" =:xid ');
              ParamByName('xid').AsInteger := XIdPlano;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Plano de Estoque alterado');
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
    if not XPlano.TryGetValue('estrutural',wval) then
       wret := false;
    if not XPlano.TryGetValue('nomeconta',wval) then
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
         SQL.Add('delete from "PlanodeEstoque" where "CodigoInternoPlanoEstoque"=:xid ');
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
         wret.AddPair('description','Plano de Estoque excluído com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhum Plano de Estoque excluído');
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
