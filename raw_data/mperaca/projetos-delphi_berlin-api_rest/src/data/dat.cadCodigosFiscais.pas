unit dat.cadCodigosFiscais;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaCodigoFiscal(XId: integer): TJSONObject;
function RetornaTotalCodigosFiscais(const XQuery: TDictionary<string, string>): TJSONObject;
function RetornaListaCodigosFiscais(const XQuery: TDictionary<string, string>; XLimit,XOffset: integer): TJSONArray;
function IncluiCodigoFiscal(XCodigoFiscal: TJSONObject): TJSONObject;
function VerificaRequisicao(XCodigoFiscal: TJSONObject): boolean;
function AlteraCodigoFiscal(XIdCodigoFiscal: integer; XCodigoFiscal: TJSONObject): TJSONObject;
function ApagaCodigoFiscal(XIdCodigoFiscal: integer): TJSONObject;

implementation

uses prv.dataModuleConexao;

function RetornaCodigoFiscal(XId: integer): TJSONObject;
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
         SQL.Add('select "CodigoInternoFiscal"     as id,');
         SQL.Add('        "CodigoFiscal"           as codigo,');
         SQL.Add('        "DigitoFiscal"           as digito,');
         SQL.Add('        "NaturezaOperacaoFiscal" as natureza,');
         SQL.Add('        "AbreviaNaturezaFiscal"  as abrevia,');
         SQL.Add('        "ICMSFiscal"             as incideicms,');
         SQL.Add('        "IPIFiscal"              as incideipi,');
         SQL.Add('        "IRTFiscal"              as incideirt,');
         SQL.Add('        "CompoeVendasFiscal"     as compoevenda,');
         SQL.Add('        "IPIBaseICMSFiscal"      as ipibaseicm,');
         SQL.Add('        "PISFiscal"              as incidepis,');
         SQL.Add('        "COFINSFiscal"           as incidecofins ');
         SQL.Add('from "CodigoFiscal" ');
         SQL.Add('where "CodigoInternoFiscal"=:xid ');
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
        wret.AddPair('description','Nenhum Código Fiscal encontrada');
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

function RetornaTotalCodigosFiscais(const XQuery: TDictionary<string, string>): TJSONObject;
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
         SQL.Add('from "CodigoFiscal" where "CodigoEmpresaFiscal"=:xempresa ');
         if XQuery.ContainsKey('codigo') then // filtro por codigo
            begin
              SQL.Add('and "CodigoFiscal" like :xcodigo ');
              ParamByName('xcodigo').AsString := XQuery.Items['codigo']+'%';
            end;
         if XQuery.ContainsKey('digito') then // filtro por digito
            begin
              SQL.Add('and "DigitoFiscal" like :xdigito ');
              ParamByName('xdigito').AsString := XQuery.Items['digito']+'%';
            end;
         if XQuery.ContainsKey('natureza') then // filtro por digito
            begin
              SQL.Add('and lower("NaturezaOperacaoFiscal") like lower(:xnatureza) ');
              ParamByName('xnatureza').AsString := XQuery.Items['natureza']+'%';
            end;
         if XQuery.ContainsKey('abrevia') then // filtro por digito
            begin
              SQL.Add('and lower("AbreviaNaturezaFiscal") like lower(:xabrevia) ');
              ParamByName('xabrevia').AsString := XQuery.Items['abrevia']+'%';
            end;
         if XQuery.ContainsKey('incideicms') then // filtro por digito
            begin
              SQL.Add('and "ICMSFiscal" =:xincideicms ');
              ParamByName('xincideicms').AsBoolean := StrToBool(XQuery.Items['incideicms']);
            end;
         if XQuery.ContainsKey('incideipi') then // filtro por digito
            begin
              SQL.Add('and "IPIFiscal" =:xincideipi ');
              ParamByName('xincideipi').AsBoolean := StrToBool(XQuery.Items['incideipi']);
            end;
         if XQuery.ContainsKey('incideirt') then // filtro por digito
            begin
              SQL.Add('and "IRTFiscal" =:xincideirt ');
              ParamByName('xincideirt').AsBoolean := StrToBool(XQuery.Items['incideirt']);
            end;
         if XQuery.ContainsKey('compoevenda') then // filtro por digito
            begin
              SQL.Add('and "CompoeVendasFiscal" =:xcompoevenda ');
              ParamByName('xcompoevenda').AsBoolean := StrToBool(XQuery.Items['compoevenda']);
            end;
         if XQuery.ContainsKey('ipibaseicm') then // filtro por digito
            begin
              SQL.Add('and "IPIBaseICMSFiscal" =:xipibaseicm ');
              ParamByName('xipibaseicm').AsBoolean := StrToBool(XQuery.Items['ipibaseicm']);
            end;
         if XQuery.ContainsKey('incidepis') then // filtro por digito
            begin
              SQL.Add('and "PISFiscal" =:xincidepis ');
              ParamByName('xincidepis').AsBoolean := StrToBool(XQuery.Items['incidepis']);
            end;
         if XQuery.ContainsKey('incidecofins') then // filtro por digito
            begin
              SQL.Add('and "COFINSFiscal" =:xincidecofins ');
              ParamByName('xincidecofins').AsBoolean := StrToBool(XQuery.Items['incidecofins']);
            end;
         ParamByName('xempresa').AsInteger := wconexao.FIdEmpresaCodigoFiscal;
         Open;
         EnableControls;
       end;

   if wquery.RecordCount>0 then
      wret := wquery.ToJSONObject()
   else
      begin
        wret := TJSONObject.Create;
        wret.AddPair('status','500');
        wret.AddPair('description','Nenhum código fiscal encontrado');
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


function RetornaListaCodigosFiscais(const XQuery: TDictionary<string, string>; XLimit,XOffset: integer): TJSONArray;
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
         SQL.Add('select "CodigoInternoFiscal"     as id,');
         SQL.Add('        "CodigoFiscal"           as codigo,');
         SQL.Add('        "DigitoFiscal"           as digito,');
         SQL.Add('        "NaturezaOperacaoFiscal" as natureza,');
         SQL.Add('        "AbreviaNaturezaFiscal"  as abrevia,');
         SQL.Add('        "ICMSFiscal"             as incideicms,');
         SQL.Add('        "IPIFiscal"              as incideipi,');
         SQL.Add('        "IRTFiscal"              as incideirt,');
         SQL.Add('        "CompoeVendasFiscal"     as compoevenda,');
         SQL.Add('        "IPIBaseICMSFiscal"      as ipibaseicm,');
         SQL.Add('        "PISFiscal"              as incidepis,');
         SQL.Add('        "COFINSFiscal"           as incidecofins ');

         SQL.Add('from "CodigoFiscal" where "CodigoEmpresaFiscal"=:xempresa ');
         ParamByName('xempresa').AsInteger := wconexao.FIdEmpresaCodigoFiscal;
         if XQuery.ContainsKey('codigo') then // filtro por codigo
            begin
              SQL.Add('and "CodigoFiscal" like :xcodigo ');
              ParamByName('xcodigo').AsString := XQuery.Items['codigo']+'%';
            end;
         if XQuery.ContainsKey('digito') then // filtro por digito
            begin
              SQL.Add('and "DigitoFiscal" like :xdigito ');
              ParamByName('xdigito').AsString := XQuery.Items['digito']+'%';
            end;
         if XQuery.ContainsKey('natureza') then // filtro por natureza
            begin
              SQL.Add('and lower("NaturezaOperacaoFiscal") like lower(:xnatureza) ');
              ParamByName('xnatureza').AsString := XQuery.Items['natureza']+'%';
            end;
         if XQuery.ContainsKey('abrevia') then // filtro por abrevia
            begin
              SQL.Add('and lower("AbreviaNaturezaFiscal") like lower(:xabrevia) ');
              ParamByName('xabrevia').AsString := XQuery.Items['abrevia']+'%';
            end;
         if XQuery.ContainsKey('incideicms') then // filtro por digito
            begin
              SQL.Add('and "ICMSFiscal" =:xincideicms ');
              ParamByName('xincideicms').AsBoolean := StrToBool(XQuery.Items['incideicms']);
            end;
         if XQuery.ContainsKey('incideipi') then // filtro por digito
            begin
              SQL.Add('and "IPIFiscal" =:xincideipi ');
              ParamByName('xincideipi').AsBoolean := StrToBool(XQuery.Items['incideipi']);
            end;
         if XQuery.ContainsKey('incideirt') then // filtro por digito
            begin
              SQL.Add('and "IRTFiscal" =:xincideirt ');
              ParamByName('xincideirt').AsBoolean := StrToBool(XQuery.Items['incideirt']);
            end;
         if XQuery.ContainsKey('compoevenda') then // filtro por digito
            begin
              SQL.Add('and "CompoeVendasFiscal" =:xcompoevenda ');
              ParamByName('xcompoevenda').AsBoolean := StrToBool(XQuery.Items['compoevenda']);
            end;
         if XQuery.ContainsKey('ipibaseicm') then // filtro por digito
            begin
              SQL.Add('and "IPIBaseICMSFiscal" =:xipibaseicm ');
              ParamByName('xipibaseicm').AsBoolean := StrToBool(XQuery.Items['ipibaseicm']);
            end;
         if XQuery.ContainsKey('incidepis') then // filtro por digito
            begin
              SQL.Add('and "PISFiscal" =:xincidepis ');
              ParamByName('xincidepis').AsBoolean := StrToBool(XQuery.Items['incidepis']);
            end;
         if XQuery.ContainsKey('incidecofins') then // filtro por digito
            begin
              SQL.Add('and "COFINSFiscal" =:xincidecofins ');
              ParamByName('xincidecofins').AsBoolean := StrToBool(XQuery.Items['incidecofins']);
            end;
         if XQuery.ContainsKey('order') then // ordenação
            begin
              if XQuery.Items['order']='codigo' then
                 wordem := 'order by "CodigoFiscal","DigitoFiscal" '
              else if XQuery.Items['order']='digito' then
                 wordem := 'order by "DigitoFiscal","CodigoFiscal" '
              else if XQuery.Items['order']='natureza' then
                 wordem := 'order by upper("NaturezaOperacaoFiscal") '
              else if XQuery.Items['order']='abrevia' then
                 wordem := 'order by upper("AbreviaNaturezaFiscal") '
              else if XQuery.Items['order']='incideicms' then
                 wordem := 'order by "ICMSFiscal" '
              else if XQuery.Items['order']='incideipi' then
                 wordem := 'order by "IPIFiscal" '
              else if XQuery.Items['order']='incideirt' then
                 wordem := 'order by "IRTFiscal" '
              else if XQuery.Items['order']='compoevenda' then
                 wordem := 'order by "CompoeVendasFiscal" '
              else if XQuery.Items['order']='ipibaseicm' then
                 wordem := 'order by "IPIBaseICMSFiscal" '
              else if XQuery.Items['order']='incidepis' then
                 wordem := 'order by "PISFiscal" '
              else if XQuery.Items['order']='incidecofins' then
                 wordem := 'order by "COFINSFiscal" ';
              if XQuery.ContainsKey('dir') then // direção
                 wordem := wordem +XQuery.Items['dir'];
              SQL.Add(wordem);
            end
         else
            SQL.Add('order by "CodigoFiscal" ');
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
         wobj.AddPair('description','Nenhum Código Fiscal encontrado');
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

function IncluiCodigoFiscal(XCodigoFiscal: TJSONObject): TJSONObject;
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
           SQL.Add('Insert into "CodigoFiscal" ("CodigoEmpresaFiscal","CodigoFiscal","DigitoFiscal","NaturezaOperacaoFiscal",');
           SQL.Add('"AbreviaNaturezaFiscal","ICMSFiscal","IPIFiscal","IRTFiscal","CompoeVendasFiscal","IPIBaseICMSFiscal","PISFiscal","COFINSFiscal") ');

           SQL.Add('values (:xidempresa,:xcodigo,:xdigito,:xnatureza,');
           SQL.Add(':xabrevia,:xincideicms,:xincideipi,:xincideirt,:xcompoevenda,:xipibaseicm,:xincidepis,:xincidecofins) ');

           ParamByName('xidempresa').AsInteger   := wconexao.FIdEmpresaCodigoFiscal;
           ParamByName('xcodigo').AsString       := XCodigoFiscal.GetValue('codigo').Value;
           ParamByName('xdigito').AsString       := XCodigoFiscal.GetValue('digito').Value;
           ParamByName('xnatureza').AsString     := XCodigoFiscal.GetValue('natureza').Value;
           ParamByName('xabrevia').AsString      := XCodigoFiscal.GetValue('abrevia').Value;
           if XCodigoFiscal.TryGetValue('incideicms',wval) then
              ParamByName('xincideicms').AsBoolean  := strtobooldef(XCodigoFiscal.GetValue('incideicms').Value,false)
           else
              ParamByName('xincideicms').AsBoolean  := false;
           if XCodigoFiscal.TryGetValue('incideipi',wval) then
              ParamByName('xincideipi').AsBoolean  := strtobooldef(XCodigoFiscal.GetValue('incideipi').Value,false)
           else
              ParamByName('xincideipi').AsBoolean  := false;
           if XCodigoFiscal.TryGetValue('incideirt',wval) then
              ParamByName('xincideirt').AsBoolean  := strtobooldef(XCodigoFiscal.GetValue('incideirt').Value,false)
           else
              ParamByName('xincideirt').AsBoolean  := false;
           if XCodigoFiscal.TryGetValue('compoevenda',wval) then
              ParamByName('xcompoevenda').AsBoolean  := strtobooldef(XCodigoFiscal.GetValue('compoevenda').Value,false)
           else
              ParamByName('xcompoevenda').AsBoolean  := false;
           if XCodigoFiscal.TryGetValue('ipibaseicm',wval) then
              ParamByName('xipibaseicm').AsBoolean  := strtobooldef(XCodigoFiscal.GetValue('ipibaseicm').Value,false)
           else
              ParamByName('xipibaseicm').AsBoolean  := false;
           if XCodigoFiscal.TryGetValue('incidepis',wval) then
              ParamByName('xincidepis').AsBoolean  := strtobooldef(XCodigoFiscal.GetValue('incidepis').Value,false)
           else
              ParamByName('xincidepis').AsBoolean  := false;
           if XCodigoFiscal.TryGetValue('incidecofins',wval) then
              ParamByName('xincidecofins').AsBoolean  := strtobooldef(XCodigoFiscal.GetValue('incidecofins').Value,false)
           else
              ParamByName('xincidecofins').AsBoolean  := false;
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
                SQL.Add('select "CodigoInternoFiscal"     as id,');
                SQL.Add('        "CodigoFiscal"           as codigo,');
                SQL.Add('        "DigitoFiscal"           as digito,');
                SQL.Add('        "NaturezaOperacaoFiscal" as natureza,');
                SQL.Add('        "AbreviaNaturezaFiscal"  as abrevia,');
                SQL.Add('        "ICMSFiscal"             as incideicms,');
                SQL.Add('        "IPIFiscal"              as incideipi,');
                SQL.Add('        "IRTFiscal"              as incideirt,');
                SQL.Add('        "CompoeVendasFiscal"     as compoevenda,');
                SQL.Add('        "IPIBaseICMSFiscal"      as ipibaseicm,');
                SQL.Add('        "PISFiscal"              as incidepis,');
                SQL.Add('        "COFINSFiscal"           as incidecofins ');
                SQL.Add('from "CodigoFiscal" where "CodigoEmpresaFiscal"=:xempresa and "CodigoFiscal"=:xcodigo and "DigitoFiscal"=:xdigito ');
                ParamByName('xempresa').AsInteger := wconexao.FIdEmpresaCobranca;
                ParamByName('xcodigo').AsString   := XCodigoFiscal.GetValue('codigo').Value;
                ParamByName('xdigito').AsString   := XCodigoFiscal.GetValue('digito').Value;
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Código Fiscal incluído');
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

function VerificaRequisicao(XCodigoFiscal: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XCodigoFiscal.TryGetValue('codigo',wval) then
       wret := false;
    if not XCodigoFiscal.TryGetValue('digito',wval) then
       wret := false;
    if not XCodigoFiscal.TryGetValue('natureza',wval) then
       wret := false;
    if not XCodigoFiscal.TryGetValue('abrevia',wval) then
       wret := false;
  finally
  end;
  Result := wret;
end;

function AlteraCodigoFiscal(XIdCodigoFiscal: integer; XCodigoFiscal: TJSONObject): TJSONObject;
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
    if XCodigoFiscal.TryGetValue('codigo',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoFiscal"=:xcodigo'
         else
            wcampos := wcampos+',"CodigoFiscal"=:xcodigo';
       end;
    if XCodigoFiscal.TryGetValue('digito',wval) then
       begin
         if wcampos='' then
            wcampos := '"DigitoFiscal"=:xdigito'
         else
            wcampos := wcampos+',"DigitoFiscal"=:xdigito';
       end;
    if XCodigoFiscal.TryGetValue('natureza',wval) then
       begin
         if wcampos='' then
            wcampos := '"NaturezaOperacaoFiscal"=:xnatureza'
         else
            wcampos := wcampos+',"NaturezaOperacaoFiscal"=:xnatureza';
       end;
    if XCodigoFiscal.TryGetValue('abrevia',wval) then
       begin
         if wcampos='' then
            wcampos := '"AbreviaNaturezaFiscal"=:xabrevia'
         else
            wcampos := wcampos+',"AbreviaNaturezaFiscal"=:xabrevia';
       end;
    if XCodigoFiscal.TryGetValue('incideicms',wval) then
       begin
         if wcampos='' then
            wcampos := '"ICMSFiscal"=:xincideicms'
         else
            wcampos := wcampos+',"ICMSFiscal"=:xincideicms';
       end;
    if XCodigoFiscal.TryGetValue('incideipi',wval) then
       begin
         if wcampos='' then
            wcampos := '"IPIFiscal"=:xincideipi'
         else
            wcampos := wcampos+',"IPIFiscal"=:xincideipi';
       end;
    if XCodigoFiscal.TryGetValue('incideirt',wval) then
       begin
         if wcampos='' then
            wcampos := '"IRTFiscal"=:xincideirt'
         else
            wcampos := wcampos+',"IRTFiscal"=:xincideirt';
       end;
    if XCodigoFiscal.TryGetValue('compoevenda',wval) then
       begin
         if wcampos='' then
            wcampos := '"CompoeVendasFiscal"=:xcompoevenda'
         else
            wcampos := wcampos+',"CompoeVendasFiscal"=:xcompoevenda';
       end;
    if XCodigoFiscal.TryGetValue('ipibaseicm',wval) then
       begin
         if wcampos='' then
            wcampos := '"IPIBaseICMSFiscal"=:xipibaseicm'
         else
            wcampos := wcampos+',"IPIBaseICMSFiscal"=:xipibaseicm';
       end;
    if XCodigoFiscal.TryGetValue('incidepis',wval) then
       begin
         if wcampos='' then
            wcampos := '"PISFiscal"=:xincidepis'
         else
            wcampos := wcampos+',"PISFiscal"=:xincidepis';
       end;
    if XCodigoFiscal.TryGetValue('incidecofins',wval) then
       begin
         if wcampos='' then
            wcampos := '"COFINSFiscal"=:xincidecofins'
         else
            wcampos := wcampos+',"COFINSFiscal"=:xincidecofins';
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
           SQL.Add('Update "CodigoFiscal" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoFiscal"=:xid ');
           ParamByName('xid').AsInteger          := XIdCodigoFiscal;
           if XCodigoFiscal.TryGetValue('codigo',wval) then
              ParamByName('xcodigo').AsString    := XCodigoFiscal.GetValue('codigo').Value;
           if XCodigoFiscal.TryGetValue('digito',wval) then
              ParamByName('xdigito').AsString    := XCodigoFiscal.GetValue('digito').Value;
           if XCodigoFiscal.TryGetValue('natureza',wval) then
              ParamByName('xnatureza').AsString  := XCodigoFiscal.GetValue('natureza').Value;
           if XCodigoFiscal.TryGetValue('abrevia',wval) then
              ParamByName('xabrevia').AsString   := XCodigoFiscal.GetValue('abrevia').Value;
           if XCodigoFiscal.TryGetValue('incideicms',wval) then
              ParamByName('xincideicms').AsBoolean := strtobooldef(XCodigoFiscal.GetValue('incideicms').Value,false);
           if XCodigoFiscal.TryGetValue('incideipi',wval) then
              ParamByName('xincideipi').AsBoolean  := strtobooldef(XCodigoFiscal.GetValue('incideipi').Value,false);
           if XCodigoFiscal.TryGetValue('incideirt',wval) then
              ParamByName('xincideirt').AsBoolean  := strtobooldef(XCodigoFiscal.GetValue('incideirt').Value,false);
           if XCodigoFiscal.TryGetValue('compoevenda',wval) then
              ParamByName('xcompoevenda').AsBoolean := strtobooldef(XCodigoFiscal.GetValue('compoevenda').Value,false);
           if XCodigoFiscal.TryGetValue('ipibaseicm',wval) then
              ParamByName('xipibaseicm').AsBoolean := strtobooldef(XCodigoFiscal.GetValue('ipibaseicm').Value,false);
           if XCodigoFiscal.TryGetValue('incidepis',wval) then
              ParamByName('xincidepis').AsBoolean := strtobooldef(XCodigoFiscal.GetValue('incidepis').Value,false);
           if XCodigoFiscal.TryGetValue('incidecofins',wval) then
              ParamByName('xincidecofins').AsBoolean := strtobooldef(XCodigoFiscal.GetValue('incidecofins').Value,false);
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
              SQL.Add('select "CodigoInternoFiscal"     as id,');
              SQL.Add('        "CodigoFiscal"           as codigo,');
              SQL.Add('        "DigitoFiscal"           as digito,');
              SQL.Add('        "NaturezaOperacaoFiscal" as natureza,');
              SQL.Add('        "AbreviaNaturezaFiscal"  as abrevia,');
              SQL.Add('        "ICMSFiscal"             as incideicms,');
              SQL.Add('        "IPIFiscal"              as incideipi,');
              SQL.Add('        "IRTFiscal"              as incideirt,');
              SQL.Add('        "CompoeVendasFiscal"     as compoevenda,');
              SQL.Add('        "IPIBaseICMSFiscal"      as ipibaseicm,');
              SQL.Add('        "PISFiscal"              as incidepis,');
              SQL.Add('        "COFINSFiscal"           as incidecofins ');
              SQL.Add('from "CodigoFiscal" ');
              SQL.Add('where "CodigoInternoFiscal" =:xid ');
              ParamByName('xid').AsInteger := XIdCodigoFiscal;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Código Fiscal alterado');
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

function ApagaCodigoFiscal(XIdCodigoFiscal: integer): TJSONObject;
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
         SQL.Add('delete from "CodigoFiscal" where "CodigoInternoFiscal"=:xid ');
         ParamByName('xid').AsInteger := XIdCodigoFiscal;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Código Fiscal excluído com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhum Código Fiscal excluído');
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
