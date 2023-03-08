unit dat.cadValidacoes;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaValidacao(XId: integer): TJSONObject;
function RetornaListaValidacoes(const XQuery: TDictionary<string, string>; XLimit,XOffset: integer): TJSONArray;
function RetornaTotalValidacoes(const XQuery: TDictionary<string, string>): TJSONObject;

implementation

uses prv.dataModuleConexao;

function RetornaValidacao(XId: integer): TJSONObject;
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
         SQL.Add('select "CodigoInternoValidacao" as id,');
         SQL.Add('       "CodigoEmpresaValidacao" as idempresa,');
         SQL.Add('       "TipoValidacao"          as tipo,');
         SQL.Add('       "AbreviaValidacao"       as abrevia,');
         SQL.Add('       "DescricaoValidacao"     as descricao ');
         SQL.Add('from "Validacao" ');
         SQL.Add('where "CodigoInternoValidacao"=:xid ');
         ParamByName('xid').AsInteger := XId;
         Open;
         EnableControls;
       end;

   if wquery.RecordCount>0 then
      wret := wquery.ToJSONObject()
   else
      begin
        wret := TJSONObject.Create;
        wret.AddPair('status','404');
        wret.AddPair('description','Nenhuma validação encontrada');
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

function RetornaTotalValidacoes(const XQuery: TDictionary<string, string>): TJSONObject;
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
         SQL.Add('from "Validacao" where "CodigoEmpresaValidacao"=:xempresa ');
         if XQuery.ContainsKey('tipo') then // filtro por nome
            begin
              SQL.Add('and lower("TipoValidacao") like lower(:xtipo) ');
              ParamByName('xtipo').AsString := XQuery.Items['tipo']+'%';
            end;
         if XQuery.ContainsKey('abrevia') then // filtro por nome
            begin
              SQL.Add('and lower("AbreviaValidacao") like lower(:xabrevia) ');
              ParamByName('xabrevia').AsString := XQuery.Items['abrevia']+'%';
            end;
         if XQuery.ContainsKey('descricao') then // filtro por nome
            begin
              SQL.Add('and lower("DescricaoValidacao") like lower(:xdescricao) ');
              ParamByName('xdescricao').AsString := XQuery.Items['descricao']+'%';
            end;
         ParamByName('xempresa').AsInteger := wconexao.FIdEmpresaValidacao;
         Open;
         EnableControls;
       end;

   if wquery.RecordCount>0 then
      wret := wquery.ToJSONObject()
   else
      begin
        wret := TJSONObject.Create;
        wret.AddPair('status','500');
        wret.AddPair('description','Nenhum documento cobrança encontrado');
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


function RetornaListaValidacoes(const XQuery: TDictionary<string, string>; XLimit,XOffset: integer): TJSONArray;
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
         SQL.Add('select "CodigoInternoValidacao" as id,');
         SQL.Add('       "CodigoEmpresaValidacao" as idempresa,');
         SQL.Add('       "TipoValidacao"          as tipo,');
         SQL.Add('       "AbreviaValidacao"       as abrevia,');
         SQL.Add('       "DescricaoValidacao"     as descricao ');
         SQL.Add('from "Validacao" where "CodigoEmpresaValidacao"=:xempresa ');
         ParamByName('xempresa').AsInteger := wconexao.FIdEmpresaValidacao;
         if XQuery.ContainsKey('tipo') then // filtro por nome
            begin
              SQL.Add('and lower("TipoValidacao") like lower(:xtipo) ');
              ParamByName('xtipo').AsString := XQuery.Items['tipo']+'%';
            end;
         if XQuery.ContainsKey('abrevia') then // filtro por nome
            begin
              SQL.Add('and lower("AbreviaValidacao") like lower(:xabrevia) ');
              ParamByName('xabrevia').AsString := XQuery.Items['abrevia']+'%';
            end;
         if XQuery.ContainsKey('descricao') then // filtro por nome
            begin
              SQL.Add('and lower("DescricaoValidacao") like lower(:xdescricao) ');
              ParamByName('xdescricao').AsString := XQuery.Items['descricao']+'%';
            end;
         if XQuery.ContainsKey('order') then // ordenação
            begin
              if XQuery.Items['order']='tipo' then
                 wordem := 'order by "TipoValidacao" '
              else if XQuery.Items['order']='abrevia' then
                 wordem := 'order by "AbreviaValidacao" '
              else if XQuery.Items['order']='descricao' then
                 wordem := 'order by "DescricaoValidacao" ';
              if XQuery.ContainsKey('dir') then // direção
                 wordem := wordem +XQuery.Items['dir'];
              SQL.Add(wordem);
            end
         else
            SQL.Add('order by "AbreviaValidacao" ');
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
         wobj.AddPair('status','404');
         wobj.AddPair('description','Nenhuma validação encontrada');
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

end.
