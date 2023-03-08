unit dat.cadClassificacoesFiscais;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaClassificacaoFiscal(XId: integer): TJSONObject;
function RetornaListaClassificacoesFiscais(const XQuery: TDictionary<string, string>; XEmpresa: integer): TJSONArray;
function IncluiClassificacaoFiscal(XClassificacaoFiscal: TJSONObject): TJSONObject;
function AlteraClassificacaoFiscal(XIdClassificacaoFiscal: integer; XClassificacaoFiscal: TJSONObject): TJSONObject;
function ApagaClassificacaoFiscal(XIdClassificacaoFiscal: integer): TJSONObject;
function VerificaRequisicao(XClassificacaoFiscal: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaClassificacaoFiscal(XId: integer): TJSONObject;
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
         SQL.Add('select "CodigoInternoClassificacao"       as id,');
         SQL.Add('       "CodigoClassificacao"              as codigo,');
         SQL.Add('       "DescricaoClassificacao"           as descricao,');
         SQL.Add('       "CodigoGrupoSTDEClassificacao"     as grupostde,');
         SQL.Add('       "PercentualMVAClassificacao"       as mva,');
         SQL.Add('       "TipoTabelaIBPTImpClassificacao"   as tipotabelaibpt,');
         SQL.Add('       "PercentualIBPTNacClassificacao"   as percibptnac,');
         SQL.Add('       "PercentualIBPTImpClassificacao"   as percibptimp,');
         SQL.Add('       "VersaoTabelaIBPTClassificacao"    as versaotabelaibpt,');
         SQL.Add('       "ExcessaoFiscalIBPTClassificacao"  as excessaofiscalibpt,');
         SQL.Add('       "PercentualIBPTEstClassificacao"   as percibptest,');
         SQL.Add('       "PercentualIBPTMunClassificacao"   as percibptmun,');
         SQL.Add('       "ChaveIBPTClassificacao"           as chaveibpt,');
         SQL.Add('       "VigenciaInicialIBPTClassificacao" as vigenciainicialibpt,');
         SQL.Add('       "VigenciaFinalIBPTClassificacao"   as vigenciafinalibpt,');
         SQL.Add('       "CodigoCESTClassificacao"          as codigocest,');
         SQL.Add('       "PercentualFCPClassificacao"       as percfcp ');
         SQL.Add('from "ClassificacaoFiscal" ');
         SQL.Add('where "CodigoInternoClassificacao"=:xid ');
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
        wret.AddPair('description','Nenhuma Classificação Fiscal encontrada');
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

function RetornaListaClassificacoesFiscais(const XQuery: TDictionary<string, string>; XEmpresa: integer): TJSONArray;
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
         SQL.Add('select "CodigoInternoClassificacao"       as id,');
         SQL.Add('       "CodigoClassificacao"              as codigo,');
         SQL.Add('       "DescricaoClassificacao"           as descricao,');
         SQL.Add('       "CodigoGrupoSTDEClassificacao"     as grupostde,');
         SQL.Add('       "PercentualMVAClassificacao"       as mva,');
         SQL.Add('       "TipoTabelaIBPTImpClassificacao"   as tipotabelaibpt,');
         SQL.Add('       "PercentualIBPTNacClassificacao"   as percibptnac,');
         SQL.Add('       "PercentualIBPTImpClassificacao"   as percibptimp,');
         SQL.Add('       "VersaoTabelaIBPTClassificacao"    as versaotabelaibpt,');
         SQL.Add('       "ExcessaoFiscalIBPTClassificacao"  as excessaofiscalibpt,');
         SQL.Add('       "PercentualIBPTEstClassificacao"   as percibptest,');
         SQL.Add('       "PercentualIBPTMunClassificacao"   as percibptmun,');
         SQL.Add('       "ChaveIBPTClassificacao"           as chaveibpt,');
         SQL.Add('       "VigenciaInicialIBPTClassificacao" as vigenciainicialibpt,');
         SQL.Add('       "VigenciaFinalIBPTClassificacao"   as vigenciafinalibpt,');
         SQL.Add('       "CodigoCESTClassificacao"          as codigocest,');
         SQL.Add('       "PercentualFCPClassificacao"       as percfcp ');
         SQL.Add('from "ClassificacaoFiscal" where "CodigoEmpresaClassificacao"=:xempresa ');
         ParamByName('xempresa').AsInteger := wconexao.FIdEmpresaClassificacao;
         if XQuery.ContainsKey('descricao') then // filtro por descricao
            begin
              SQL.Add('and lower("DescricaoClassificacao") like lower(:xdescricao) ');
              ParamByName('xdescricao').AsString := XQuery.Items['descricao']+'%';
              SQL.Add('order by "DescricaoClassificacao" ');
            end;
         if XQuery.ContainsKey('codigo') then // filtro por código
            begin
              SQL.Add('and "CodigoClassificacao" =:xcodigo ');
              ParamByName('xcodigo').AsString := XQuery.Items['codigo'];
              SQL.Add('order by "CodigoClassificacao" ');
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
         wobj.AddPair('description','Nenhuma Classificação Fiscal encontrada');
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

function IncluiClassificacaoFiscal(XClassificacaoFiscal: TJSONObject): TJSONObject;
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
           SQL.Add('Insert into "ClassificacaoFiscal" ("CodigoEmpresaClassificacao","CodigoClassificacao","DescricaoClassificacao","CodigoGrupoSTDEClassificacao",');
           SQL.Add('"PercentualMVAClassificacao","TipoTabelaIBPTImpClassificacao","PercentualIBPTNacClassificacao","PercentualIBPTImpClassificacao","VersaoTabelaIBPTClassificacao",');
           SQL.Add('"ExcessaoFiscalIBPTClassificacao","PercentualIBPTEstClassificacao","PercentualIBPTMunClassificacao","ChaveIBPTClassificacao",');
           SQL.Add('"VigenciaInicialIBPTClassificacao","VigenciaFinalIBPTClassificacao","CodigoCESTClassificacao","PercentualFCPClassificacao") ');
           SQL.Add('values (:xidempresa,:xcodigo,:xdescricao,:xgrupostde,');
           SQL.Add(':xmva,:xtipotabelaibpt,:xpercibptnac,:xpercibptimp,:xversaotabelaibpt,');
           SQL.Add(':xexcessaofiscalibpt,:xpercibptest,:xpercibptmun,:xchaveibpt,');
           SQL.Add(':xvigenciainicialibpt,:xvigenciafinalibpt,:xcodigocest,:xpercfcp) ');
           ParamByName('xidempresa').AsInteger   := wconexao.FIdEmpresaClassificacao;
           ParamByName('xcodigo').AsString       := XClassificacaoFiscal.GetValue('codigo').Value;
           ParamByName('xdescricao').AsString    := XClassificacaoFiscal.GetValue('descricao').Value;
           if XClassificacaoFiscal.TryGetValue('grupostde',wval) then
              ParamByName('xgrupostde').AsString  := XClassificacaoFiscal.GetValue('grupostde').Value
           else
              ParamByName('xgrupostde').AsString  := '';
           if XClassificacaoFiscal.TryGetValue('mva',wval) then
              ParamByName('xmva').AsFloat  := strtofloatdef(XClassificacaoFiscal.GetValue('mva').Value,0)
           else
              ParamByName('xmva').AsFloat  := 0;
           if XClassificacaoFiscal.TryGetValue('tipotabelaibpt',wval) then
              ParamByName('xtipotabelaibpt').AsInteger  := strtointdef(XClassificacaoFiscal.GetValue('tipotabelaibpt').Value,0)
           else
              ParamByName('xtipotabelaibpt').AsInteger  := 0;
           if XClassificacaoFiscal.TryGetValue('percibptnac',wval) then
              ParamByName('xpercibptnac').AsFloat  := strtofloatdef(XClassificacaoFiscal.GetValue('percibptnac').Value,0)
           else
              ParamByName('xpercibptnac').AsFloat  := 0;
           if XClassificacaoFiscal.TryGetValue('percibptimp',wval) then
              ParamByName('xpercibptimp').AsFloat  := strtofloatdef(XClassificacaoFiscal.GetValue('percibptimp').Value,0)
           else
              ParamByName('xpercibptimp').AsFloat  := 0;
           if XClassificacaoFiscal.TryGetValue('versaotabelaibpt',wval) then
              ParamByName('xversaotabelaibpt').AsString  := XClassificacaoFiscal.GetValue('versaotabelaibpt').Value
           else
              ParamByName('xversaotabelaibpt').AsString  := '';
           if XClassificacaoFiscal.TryGetValue('excessaofiscalibpt',wval) then
              ParamByName('xexcessaofiscalibpt').AsInteger  := strtointdef(XClassificacaoFiscal.GetValue('excessaofiscalibpt').Value,0)
           else
              ParamByName('xexcessaofiscalibpt').AsInteger  := 0;
           if XClassificacaoFiscal.TryGetValue('percibptest',wval) then
              ParamByName('xpercibptest').AsFloat  := strtofloatdef(XClassificacaoFiscal.GetValue('percibptest').Value,0)
           else
              ParamByName('xpercibptest').AsFloat  := 0;
           if XClassificacaoFiscal.TryGetValue('percibptmun',wval) then
              ParamByName('xpercibptmun').AsFloat  := strtofloatdef(XClassificacaoFiscal.GetValue('percibptmun').Value,0)
           else
              ParamByName('xpercibptmun').AsFloat  := 0;
           if XClassificacaoFiscal.TryGetValue('chaveibpt',wval) then
              ParamByName('xchaveibpt').AsString  := XClassificacaoFiscal.GetValue('chaveibpt').Value
           else
              ParamByName('xchaveibpt').AsString  := '';
           if XClassificacaoFiscal.TryGetValue('vigenciainicialibpt',wval) then
              ParamByName('xvigenciainicialibpt').AsDate  := strtodatedef(XClassificacaoFiscal.GetValue('vigenciainicialibpt').Value,0)
           else
              ParamByName('xvigenciainicialibpt').AsDate  := 0;
           if XClassificacaoFiscal.TryGetValue('vigenciafinalibpt',wval) then
              ParamByName('xvigenciafinalibpt').AsDate  := strtodatedef(XClassificacaoFiscal.GetValue('vigenciafinalibpt').Value,0)
           else
              ParamByName('xvigenciafinalibpt').AsDate  := 0;
           if XClassificacaoFiscal.TryGetValue('codigocest',wval) then
              ParamByName('xcodigocest').AsString  := XClassificacaoFiscal.GetValue('codigocest').Value
           else
              ParamByName('xcodigocest').AsString  := '';
           if XClassificacaoFiscal.TryGetValue('percfcp',wval) then
              ParamByName('xpercfcp').AsFloat  := strtofloatdef(XClassificacaoFiscal.GetValue('percfcp').Value,0)
           else
              ParamByName('xpercfcp').AsFloat  := 0;
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
                SQL.Add('select "CodigoInternoClassificacao"       as id,');
                SQL.Add('       "CodigoClassificacao"              as codigo,');
                SQL.Add('       "DescricaoClassificacao"           as descricao,');
                SQL.Add('       "CodigoGrupoSTDEClassificacao"     as grupostde,');
                SQL.Add('       "PercentualMVAClassificacao"       as mva,');
                SQL.Add('       "TipoTabelaIBPTImpClassificacao"   as tipotabelaibpt,');
                SQL.Add('       "PercentualIBPTNacClassificacao"   as percibptnac,');
                SQL.Add('       "PercentualIBPTImpClassificacao"   as percibptimp,');
                SQL.Add('       "VersaoTabelaIBPTClassificacao"    as versaotabelaibpt,');
                SQL.Add('       "ExcessaoFiscalIBPTClassificacao"  as excessaofiscalibpt,');
                SQL.Add('       "PercentualIBPTEstClassificacao"   as percibptest,');
                SQL.Add('       "PercentualIBPTMunClassificacao"   as percibptmun,');
                SQL.Add('       "ChaveIBPTClassificacao"           as chaveibpt,');
                SQL.Add('       "VigenciaInicialIBPTClassificacao" as vigenciainicialibpt,');
                SQL.Add('       "VigenciaFinalIBPTClassificacao"   as vigenciafinalibpt,');
                SQL.Add('       "CodigoCESTClassificacao"          as codigocest,');
                SQL.Add('       "PercentualFCPClassificacao"       as percfcp ');
                SQL.Add('from "ClassificacaoFiscal" where "CodigoEmpresaClassificacao"=:xempresa and "DescricaoClassificacao"=:xdescricao ');
                ParamByName('xempresa').AsInteger  := wconexao.FIdEmpresaClassificacao;
                ParamByName('xdescricao').AsString := XClassificacaoFiscal.GetValue('descricao').Value;
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhuma Classificação Fiscal incluída');
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


function AlteraClassificacaoFiscal(XIdClassificacaoFiscal: integer; XClassificacaoFiscal: TJSONObject): TJSONObject;
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
    if XClassificacaoFiscal.TryGetValue('codigo',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoClassificacao"=:xcodigo'
         else
            wcampos := wcampos+',"CodigoClassificacao"=:xcodigo';
       end;
    if XClassificacaoFiscal.TryGetValue('descricao',wval) then
       begin
         if wcampos='' then
            wcampos := '"DescricaoClassificacao"=:xdescricao'
         else
            wcampos := wcampos+',"DescricaoClassificacao"=:xdescricao';
       end;
    if XClassificacaoFiscal.TryGetValue('grupostde',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoGrupoSTDEClassificacao"=:xgrupostde'
         else
            wcampos := wcampos+',"CodigoGrupoSTDEClassificacao"=:xgrupostde';
       end;
    if XClassificacaoFiscal.TryGetValue('mva',wval) then
       begin
         if wcampos='' then
            wcampos := '"PercentualMVAClassificacao"=:xmva'
         else
            wcampos := wcampos+',"PercentualMVAClassificacao"=:xmva';
       end;
    if XClassificacaoFiscal.TryGetValue('tipotabelaibpt',wval) then
       begin
         if wcampos='' then
            wcampos := '"TipoTabelaIBPTImpClassificacao"=:xtipotabelaibpt'
         else
            wcampos := wcampos+',"TipoTabelaIBPTImpClassificacao"=:xtipotabelaibpt';
       end;
    if XClassificacaoFiscal.TryGetValue('percibptnac',wval) then
       begin
         if wcampos='' then
            wcampos := '"PercentualIBPTNacClassificacao"=:xpercibptnac'
         else
            wcampos := wcampos+',"PercentualIBPTNacClassificacao"=:xpercibptnac';
       end;
    if XClassificacaoFiscal.TryGetValue('percibptimp',wval) then
       begin
         if wcampos='' then
            wcampos := '"PercentualIBPTImpClassificacao"=:xpercibptimp'
         else
            wcampos := wcampos+',"PercentualIBPTImpClassificacao"=:xpercibptimp';
       end;
    if XClassificacaoFiscal.TryGetValue('versaotabelaibpt',wval) then
       begin
         if wcampos='' then
            wcampos := '"VersaoTabelaIBPTClassificacao"=:xversaotabelaibpt'
         else
            wcampos := wcampos+',"VersaoTabelaIBPTClassificacao"=:xversaotabelaibpt';
       end;
    if XClassificacaoFiscal.TryGetValue('excessaofiscalibpt',wval) then
       begin
         if wcampos='' then
            wcampos := '"ExcessaoFiscalIBPTClassificacao"=:xexcessaofiscalibpt'
         else
            wcampos := wcampos+',"ExcessaoFiscalIBPTClassificacao"=:xexcessaofiscalibpt';
       end;
    if XClassificacaoFiscal.TryGetValue('percibptest',wval) then
       begin
         if wcampos='' then
            wcampos := '"PercentualIBPTEstClassificacao"=:xpercibptest'
         else
            wcampos := wcampos+',"PercentualIBPTEstClassificacao"=:xpercibptest';
       end;
    if XClassificacaoFiscal.TryGetValue('percibptmun',wval) then
       begin
         if wcampos='' then
            wcampos := '"PercentualIBPTMunClassificacao"=:xpercibptmun'
         else
            wcampos := wcampos+',"PercentualIBPTMunClassificacao"=:xpercibptmun';
       end;
    if XClassificacaoFiscal.TryGetValue('chaveibpt',wval) then
       begin
         if wcampos='' then
            wcampos := '"ChaveIBPTClassificacao"=:xchaveibpt'
         else
            wcampos := wcampos+',"ChaveIBPTClassificacao"=:xchaveibpt';
       end;
    if XClassificacaoFiscal.TryGetValue('vigenciainicialibpt',wval) then
       begin
         if wcampos='' then
            wcampos := '"VigenciaInicialIBPTClassificacao"=:xvigenciainicialibpt'
         else
            wcampos := wcampos+',"VigenciaInicialIBPTClassificacao"=:xvigenciainicialibpt';
       end;
    if XClassificacaoFiscal.TryGetValue('vigenciafinalibpt',wval) then
       begin
         if wcampos='' then
            wcampos := '"VigenciaFinalIBPTClassificacao"=:xvigenciafinalibpt'
         else
            wcampos := wcampos+',"VigenciaFinalIBPTClassificacao"=:xvigenciafinalibpt';
       end;
    if XClassificacaoFiscal.TryGetValue('codigocest',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoCESTClassificacao"=:xcodigocest'
         else
            wcampos := wcampos+',"CodigoCESTClassificacao"=:xcodigocest';
       end;
    if XClassificacaoFiscal.TryGetValue('percfcp',wval) then
       begin
         if wcampos='' then
            wcampos := '"PercentualFCPClassificacao"=:xpercfcp'
         else
            wcampos := wcampos+',"PercentualFCPClassificacao"=:xpercfcp';
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
           SQL.Add('Update "ClassificacaoFiscal" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoClassificacao"=:xid ');
           ParamByName('xid').AsInteger                 := XIdClassificacaoFiscal;
           if XClassificacaoFiscal.TryGetValue('codigo',wval) then
              ParamByName('xcodigo').AsString           := XClassificacaoFiscal.GetValue('codigo').Value;
           if XClassificacaoFiscal.TryGetValue('descricao',wval) then
              ParamByName('xdescricao').AsString        := XClassificacaoFiscal.GetValue('descricao').Value;
           if XClassificacaoFiscal.TryGetValue('grupostde',wval) then
              ParamByName('xgrupostde').AsString        := XClassificacaoFiscal.GetValue('grupostde').Value;
           if XClassificacaoFiscal.TryGetValue('mva',wval) then
              ParamByName('xmva').AsFloat               := strtofloatdef(XClassificacaoFiscal.GetValue('mva').Value,0);
           if XClassificacaoFiscal.TryGetValue('tipotabelaibpt',wval) then
              ParamByName('xtipotabelaibpt').AsInteger  := strtointdef(XClassificacaoFiscal.GetValue('tipotabelaibpt').Value,0);
           if XClassificacaoFiscal.TryGetValue('percibptnac',wval) then
              ParamByName('xpercibptnac').AsFloat       := strtofloatdef(XClassificacaoFiscal.GetValue('percibptnac').Value,0);
           if XClassificacaoFiscal.TryGetValue('percibptimp',wval) then
              ParamByName('xpercibptimp').AsFloat       := strtofloatdef(XClassificacaoFiscal.GetValue('percibptimp').Value,0);
           if XClassificacaoFiscal.TryGetValue('versaotabelaibpt',wval) then
              ParamByName('xversaotabelaibpt').AsString := XClassificacaoFiscal.GetValue('versaotabelaibpt').Value;
           if XClassificacaoFiscal.TryGetValue('excessaofiscalibpt',wval) then
              ParamByName('xexcessaofiscalibpt').AsInteger  := strtointdef(XClassificacaoFiscal.GetValue('excessaofiscalibpt').Value,0);
           if XClassificacaoFiscal.TryGetValue('percibptest',wval) then
              ParamByName('xpercibptest').AsFloat           := strtofloatdef(XClassificacaoFiscal.GetValue('percibptest').Value,0);
           if XClassificacaoFiscal.TryGetValue('percibptmun',wval) then
              ParamByName('xpercibptmun').AsFloat           := strtofloatdef(XClassificacaoFiscal.GetValue('percibptmun').Value,0);
           if XClassificacaoFiscal.TryGetValue('chaveibpt',wval) then
              ParamByName('xchaveibpt').AsString            := XClassificacaoFiscal.GetValue('chaveibpt').Value;
           if XClassificacaoFiscal.TryGetValue('vigenciainicialibpt',wval) then
              ParamByName('xvigenciainicialibpt').AsDate    := strtodatedef(XClassificacaoFiscal.GetValue('vigenciainicialibpt').Value,0);
           if XClassificacaoFiscal.TryGetValue('vigenciafinalibpt',wval) then
              ParamByName('xvigenciafinalibpt').AsDate      := strtodatedef(XClassificacaoFiscal.GetValue('vigenciafinalibpt').Value,0);
           if XClassificacaoFiscal.TryGetValue('codigocest',wval) then
              ParamByName('xcodigocest').AsString           := XClassificacaoFiscal.GetValue('codigocest').Value;
           if XClassificacaoFiscal.TryGetValue('percfcp',wval) then
              ParamByName('xpercfcp').AsFloat               := strtofloatdef(XClassificacaoFiscal.GetValue('percfcp').Value,0);
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
              SQL.Add('select "CodigoInternoClassificacao"       as id,');
              SQL.Add('       "CodigoClassificacao"              as codigo,');
              SQL.Add('       "DescricaoClassificacao"           as descricao,');
              SQL.Add('       "CodigoGrupoSTDEClassificacao"     as grupostde,');
              SQL.Add('       "PercentualMVAClassificacao"       as mva,');
              SQL.Add('       "TipoTabelaIBPTImpClassificacao"   as tipotabelaibpt,');
              SQL.Add('       "PercentualIBPTNacClassificacao"   as percibptnac,');
              SQL.Add('       "PercentualIBPTImpClassificacao"   as percibptimp,');
              SQL.Add('       "VersaoTabelaIBPTClassificacao"    as versaotabelaibpt,');
              SQL.Add('       "ExcessaoFiscalIBPTClassificacao"  as excessaofiscalibpt,');
              SQL.Add('       "PercentualIBPTEstClassificacao"   as percibptest,');
              SQL.Add('       "PercentualIBPTMunClassificacao"   as percibptmun,');
              SQL.Add('       "ChaveIBPTClassificacao"           as chaveibpt,');
              SQL.Add('       "VigenciaInicialIBPTClassificacao" as vigenciainicialibpt,');
              SQL.Add('       "VigenciaFinalIBPTClassificacao"   as vigenciafinalibpt,');
              SQL.Add('       "CodigoCESTClassificacao"          as codigocest,');
              SQL.Add('       "PercentualFCPClassificacao"       as percfcp ');
              SQL.Add('from "ClassificacaoFiscal" ');
              SQL.Add('where "CodigoInternoClassificacao" =:xid ');
              ParamByName('xid').AsInteger := XIdClassificacaoFiscal;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhuma Classificação Fiscal alterada');
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

function VerificaRequisicao(XClassificacaoFiscal: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XClassificacaoFiscal.TryGetValue('codigo',wval) then
       wret := false;
    if not XClassificacaoFiscal.TryGetValue('descricao',wval) then
       wret := false;
  finally
  end;
  Result := wret;
end;

function ApagaClassificacaoFiscal(XIdClassificacaoFiscal: integer): TJSONObject;
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
         SQL.Add('delete from "ClassificacaoFiscal" where "CodigoInternoClassificacao"=:xid ');
         ParamByName('xid').AsInteger := XIdClassificacaoFiscal;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Classificação Fiscal excluída com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhuma Classificação Fiscal excluída');
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
