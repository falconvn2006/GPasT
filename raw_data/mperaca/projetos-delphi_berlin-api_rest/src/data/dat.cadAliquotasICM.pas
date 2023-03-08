unit dat.cadAliquotasICM;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaAliquota(XId: integer): TJSONObject;
function RetornaListaAliquotas(const XQuery: TDictionary<string, string>; XEmpresa: integer): TJSONArray;
function IncluiAliquota(XAliquota: TJSONObject; XIdEmpresa: integer): TJSONObject;
function AlteraAliquota(XIdAliquota: integer; XAliquota: TJSONObject): TJSONObject;
function ApagaAliquota(XIdAliquota: integer): TJSONObject;
function VerificaRequisicao(XAliquota: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaAliquota(XId: integer): TJSONObject;
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
         SQL.Add('select "CodigoInternoAliquota" as id,');
         SQL.Add('       "CodigoAliquota"        as codigo,');
         SQL.Add('       "PercentualAliquota"    as percentual,');
         SQL.Add('       "PercentualAliquotaSC"  as percentualSC,');
         SQL.Add('       "PercentualAliquotaSP"  as percentualSP,');
         SQL.Add('       "DescricaoAliquota"     as descricao,');
         SQL.Add('       "BaseCalculoAliquota"   as basecalculo,');
         SQL.Add('       "SomaIsentosAliquota"   as isentos,');
         SQL.Add('       "SomaOutrosAliquota"    as outros ');
         SQL.Add('from "AliquotaICMS" ');
         SQL.Add('where "CodigoInternoAliquota"=:xid ');
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
        wret.AddPair('description','Nenhuma Alíquota encontrada');
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

function RetornaListaAliquotas(const XQuery: TDictionary<string, string>; XEmpresa: integer): TJSONArray;
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
         SQL.Add('select "CodigoInternoAliquota" as id,');
         SQL.Add('       "CodigoAliquota"        as codigo,');
         SQL.Add('       "PercentualAliquota"    as percentual,');
         SQL.Add('       "PercentualAliquotaSC"  as percentualSC,');
         SQL.Add('       "PercentualAliquotaSP"  as percentualSP,');
         SQL.Add('       "DescricaoAliquota"     as descricao,');
         SQL.Add('       "BaseCalculoAliquota"   as basecalculo,');
         SQL.Add('       "SomaIsentosAliquota"   as isentos,');
         SQL.Add('       "SomaOutrosAliquota"    as outros ');
         SQL.Add('from "AliquotaICMS" where "CodigoEmpresaAliquota"=:xempresa ');
         ParamByName('xempresa').AsInteger := wconexao.FIdEmpresaAliquota;
         if XQuery.ContainsKey('codigo') then // filtro por codigo
            begin
              SQL.Add('and lower("CodigoAliquota") like lower(:xcodigo) ');
              ParamByName('xcodigo').AsString := XQuery.Items['codigo']+'%';
              SQL.Add('order by "CodigoAliquota" ');
            end;
         if XQuery.ContainsKey('descricao') then // filtro por descricao
            begin
              SQL.Add('and lower("DescricaoAliquota") like lower(:xdescricao) ');
              ParamByName('xdescricao').AsString := XQuery.Items['descricao']+'%';
              SQL.Add('order by "DescricaoAliquota" ');
            end;
         if XQuery.ContainsKey('percentual') then // filtro por percentual
            begin
              SQL.Add('and "PercentualAliquota" =:xpercentual ');
              ParamByName('xpercentual').AsFloat := strtofloatdef(XQuery.Items['percentual'],0);
              SQL.Add('order by "PercentualAliquota" ');
            end;
         if XQuery.ContainsKey('basecalculo') then // filtro por basecalculo
            begin
              SQL.Add('and "BaseCalculoAliquota" =:xbasecalculo ');
              ParamByName('xbasecalculo').AsFloat := strtofloatdef(XQuery.Items['basecalculo'],0);
              SQL.Add('order by "BaseCalculoAliquota" ');
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
         wobj.AddPair('description','Nenhuma Alíquota encontrada');
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

function IncluiAliquota(XAliquota: TJSONObject; XIdEmpresa: integer): TJSONObject;
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
           SQL.Add('Insert into "AliquotaICMS" ("CodigoEmpresaAliquota","CodigoAliquota","PercentualAliquota","BaseCalculoAliquota","DescricaoAliquota",');
           SQL.Add('                            "SomaIsentosAliquota","SomaOutrosAliquota","PercentualAliquotaSC","PercentualAliquotaSP") ');
           SQL.Add('values (:xidempresa,:xcodigo,:xpercentual,:xbasecalculo,:xdescricao,:xsomaisentos,:xsomaoutros,:xpercentualsc,:xpercentualsp) ');
           ParamByName('xidempresa').AsInteger   := wconexao.FIdEmpresaAliquota;
           ParamByName('xcodigo').AsString       := XAliquota.GetValue('codigo').Value;
           ParamByName('xpercentual').AsFloat    := strtofloatdef(XAliquota.GetValue('percentual').Value,0);
           ParamByName('xbasecalculo').AsFloat   := strtofloatdef(XAliquota.GetValue('basecalculo').Value,0);
           ParamByName('xdescricao').AsString    := XAliquota.GetValue('descricao').Value;
           if XAliquota.TryGetValue('somaisentos',wval) then
              ParamByName('xsomaisentos').AsBoolean := StrToBoolDef(XAliquota.GetValue('somaisentos').Value,false)
           else
              ParamByName('xsomaisentos').AsBoolean := false;
           if XAliquota.TryGetValue('somaoutros',wval) then
              ParamByName('xsomaoutros').AsBoolean  := StrToBoolDef(XAliquota.GetValue('somaoutros').Value,false)
           else
              ParamByName('xsomaoutros').AsBoolean  := false;
           if XAliquota.TryGetValue('percentualsc',wval) then
              ParamByName('xpercentualsc').AsFloat  := strtofloatdef(XAliquota.GetValue('percentualsc').Value,0)
           else
              ParamByName('xpercentualsc').AsFloat  := 0;
           if XAliquota.TryGetValue('percentualsp',wval) then
              ParamByName('xpercentualsp').AsFloat  := strtofloatdef(XAliquota.GetValue('percentualsp').Value,0)
           else
              ParamByName('xpercentualsp').AsFloat  := 0;
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
                SQL.Add('select "CodigoInternoAliquota" as id,');
                SQL.Add('       "CodigoAliquota"        as codigo,');
                SQL.Add('       "PercentualAliquota"    as percentual,');
                SQL.Add('       "PercentualAliquotaSC"  as percentualSC,');
                SQL.Add('       "PercentualAliquotaSP"  as percentualSP,');
                SQL.Add('       "DescricaoAliquota"     as descricao,');
                SQL.Add('       "BaseCalculoAliquota"   as basecalculo,');
                SQL.Add('       "SomaIsentosAliquota"   as isentos,');
                SQL.Add('       "SomaOutrosAliquota"    as outros ');
                SQL.Add('from "AliquotaICMS" where "CodigoEmpresaAliquota"=:xempresa and "CodigoAliquota"=:xcodigo ');
                ParamByName('xempresa').AsInteger := wconexao.FIdEmpresaAliquota;
                ParamByName('xcodigo').AsString   := XAliquota.GetValue('codigo').Value;
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhuma Alíquota incluída');
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


function AlteraAliquota(XIdAliquota: integer; XAliquota: TJSONObject): TJSONObject;
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
    if XAliquota.TryGetValue('codigo',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoAliquota"=:xcodigo'
         else
            wcampos := wcampos+',"CodigoAliquota"=:xcodigo';
       end;
    if XAliquota.TryGetValue('descricao',wval) then
       begin
         if wcampos='' then
            wcampos := '"DescricaoAliquota"=:xdescricao'
         else
            wcampos := wcampos+',"DescricaoAliquota"=:xdescricao';
       end;
    if XAliquota.TryGetValue('percentual',wval) then
       begin
         if wcampos='' then
            wcampos := '"PercentualAliquota"=:xpercentual'
         else
            wcampos := wcampos+',"PercentualAliquota"=:xpercentual';
       end;
    if XAliquota.TryGetValue('basecalculo',wval) then
       begin
         if wcampos='' then
            wcampos := '"BaseCalculoAliquota"=:xbasecalculo'
         else
            wcampos := wcampos+',"BaseCalculoAliquota"=:xbasecalculo';
       end;
    if XAliquota.TryGetValue('somaisentos',wval) then
       begin
         if wcampos='' then
            wcampos := '"SomaIsentosAliquota"=:xsomaisentos'
         else
            wcampos := wcampos+',"SomaIsentosAliquota"=:xsomaisentos';
       end;
    if XAliquota.TryGetValue('somaoutros',wval) then
       begin
         if wcampos='' then
            wcampos := '"SomaOutrosAliquota"=:xsomaoutros'
         else
            wcampos := wcampos+',"SomaOutrosAliquota"=:xsomaoutros';
       end;
    if XAliquota.TryGetValue('percentualsc',wval) then
       begin
         if wcampos='' then
            wcampos := '"PercentualAliquotaSC"=:xpercentualsc'
         else
            wcampos := wcampos+',"PercentualAliquotaSC"=:xpercentualsc';
       end;
    if XAliquota.TryGetValue('percentualsp',wval) then
       begin
         if wcampos='' then
            wcampos := '"PercentualAliquotaSP"=:xpercentualsp'
         else
            wcampos := wcampos+',"PercentualAliquotaSP"=:xpercentualsp';
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
           SQL.Add('Update "AliquotaICMS" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoAliquota"=:xid ');
           ParamByName('xid').AsInteger      := XIdAliquota;
           if XAliquota.TryGetValue('codigo',wval) then
              ParamByName('xcodigo').AsString  := XAliquota.GetValue('codigo').Value;
           if XAliquota.TryGetValue('descricao',wval) then
              ParamByName('xdescricao').AsString  := XAliquota.GetValue('descricao').Value;
           if XAliquota.TryGetValue('percentual',wval) then
              ParamByName('xpercentual').AsFloat  := strtofloatdef(XAliquota.GetValue('percentual').Value,0);
           if XAliquota.TryGetValue('basecalculo',wval) then
              ParamByName('xbasecalculo').AsFloat  := strtofloatdef(XAliquota.GetValue('basecalculo').Value,0);
           if XAliquota.TryGetValue('percentualsc',wval) then
              ParamByName('xpercentualsc').AsFloat  := strtofloatdef(XAliquota.GetValue('percentualsc').Value,0);
           if XAliquota.TryGetValue('percentualsp',wval) then
              ParamByName('xpercentualsp').AsFloat  := strtofloatdef(XAliquota.GetValue('percentualsp').Value,0);
           if XAliquota.TryGetValue('somaisentos',wval) then
              ParamByName('xsomaisentos').AsBoolean  := strtobooldef(XAliquota.GetValue('somaisentos').Value,false);
           if XAliquota.TryGetValue('somaoutros',wval) then
              ParamByName('xsomaoutros').AsBoolean  := strtobooldef(XAliquota.GetValue('somaoutros').Value,false);
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
              SQL.Add('select "CodigoInternoAliquota" as id,');
              SQL.Add('       "CodigoAliquota"        as codigo,');
              SQL.Add('       "PercentualAliquota"    as percentual,');
              SQL.Add('       "PercentualAliquotaSC"  as percentualSC,');
              SQL.Add('       "PercentualAliquotaSP"  as percentualSP,');
              SQL.Add('       "DescricaoAliquota"     as descricao,');
              SQL.Add('       "BaseCalculoAliquota"   as basecalculo,');
              SQL.Add('       "SomaIsentosAliquota"   as isentos,');
              SQL.Add('       "SomaOutrosAliquota"    as outros ');
              SQL.Add('from "AliquotaICMS" ');
              SQL.Add('where "CodigoInternoAliquota" =:xid ');
              ParamByName('xid').AsInteger := XIdAliquota;
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

function VerificaRequisicao(XAliquota: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XAliquota.TryGetValue('codigo',wval) then
       wret := false;
    if not XAliquota.TryGetValue('descricao',wval) then
       wret := false;
    if not XAliquota.TryGetValue('percentual',wval) then
       wret := false;
    if not XAliquota.TryGetValue('basecalculo',wval) then
       wret := false;
  finally
  end;
  Result := wret;
end;

function ApagaAliquota(XIdAliquota: integer): TJSONObject;
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
         SQL.Add('delete from "AliquotaICMS" where "CodigoInternoAliquota"=:xid ');
         ParamByName('xid').AsInteger := XIdAliquota;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Alíquota excluída com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhuma Alíquota excluída');
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
