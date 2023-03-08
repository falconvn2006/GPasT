unit dat.cadOperacoes;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaOperacao(XId: integer): TJSONObject;
function RetornaListaOperacoes(const XQuery: TDictionary<string, string>): TJSONArray;
function IncluiOperacao(XOperacao: TJSONObject): TJSONObject;
function AlteraOperacao(XIdOperacao: integer; XOperacao: TJSONObject): TJSONObject;
function ApagaOperacao(XIdOperacao: integer): TJSONObject;
function VerificaRequisicao(XOperacao: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaOperacao(XId: integer): TJSONObject;
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
         SQL.Add('select "CodigoInternoOperacoes"          as id,');
         SQL.Add('       "DescricaoOperacoes"              as descricao,');
         SQL.Add('       "TipoOperacoes"                   as tipo,');
         SQL.Add('       "QuantidadeEstoqueOperacoes"      as qtdestoque,');
         SQL.Add('       "QuantidadeEncomendaOperacoes"    as qtdencomenda,');
         SQL.Add('       "PrecoCustoOperacoes"             as precocusto,');
         SQL.Add('       "PrecoVendaOperacoes"             as precovenda,');
         SQL.Add('       "SubstituiUltimaEntradaOperacoes" as substituiultimaentrada,');
         SQL.Add('       "SubstituiUltimaSaidaOperacoes"   as substituiultimasaida,');
         SQL.Add('       "AcumulaEntradaOperacoes"         as acumulaentrada,');
         SQL.Add('       "AcumulaSaidaOperacoes"           as acumulasaida,');
         SQL.Add('       "CodigoFiscalOperacoes"           as idcodigofiscal,');
         SQL.Add('       "CodigoFiscalSTOperacoes"         as idcodigofiscalst ');
         SQL.Add('from "Operacao" ');
         SQL.Add('where "CodigoInternoOperacoes"=:xid ');
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
        wret.AddPair('description','Nenhuma Operação encontrada');
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

function RetornaListaOperacoes(const XQuery: TDictionary<string, string>): TJSONArray;
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
         SQL.Add('select "CodigoInternoOperacoes"          as id,');
         SQL.Add('       "DescricaoOperacoes"              as descricao,');
         SQL.Add('       "TipoOperacoes"                   as tipo,');
         SQL.Add('       "QuantidadeEstoqueOperacoes"      as qtdestoque,');
         SQL.Add('       "QuantidadeEncomendaOperacoes"    as qtdencomenda,');
         SQL.Add('       "PrecoCustoOperacoes"             as precocusto,');
         SQL.Add('       "PrecoVendaOperacoes"             as precovenda,');
         SQL.Add('       "SubstituiUltimaEntradaOperacoes" as substituiultimaentrada,');
         SQL.Add('       "SubstituiUltimaSaidaOperacoes"   as substituiultimasaida,');
         SQL.Add('       "AcumulaEntradaOperacoes"         as acumulaentrada,');
         SQL.Add('       "AcumulaSaidaOperacoes"           as acumulasaida,');
         SQL.Add('       "CodigoFiscalOperacoes"           as idcodigofiscal,');
         SQL.Add('       "CodigoFiscalSTOperacoes"         as idcodigofiscalst ');
         SQL.Add('from "Operacao" where "CodigoEmpresaOperacoes"=:xempresa ');
         ParamByName('xempresa').AsInteger := wconexao.FIdEmpresaOperacao;
         if XQuery.ContainsKey('descricao') then // filtro por descrição
            begin
              SQL.Add('and lower("DescricaoOperacoes") like lower(:xdescricao) ');
              ParamByName('xdescricao').AsString := XQuery.Items['descricao']+'%';
              SQL.Add('order by "DescricaoOperacoes" ');
            end;
         if XQuery.ContainsKey('tipo') then // filtro por tipo
            begin
              SQL.Add('and lower("TipoOperacoes") like lower(:xtipo) ');
              ParamByName('xtipo').AsString := XQuery.Items['tipo']+'%';
              SQL.Add('order by "TipoOperacoes" ');
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
         wobj.AddPair('description','Nenhuma Operação encontrada');
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

function IncluiOperacao(XOperacao: TJSONObject): TJSONObject;
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
           SQL.Add('Insert into "Operacao" ("CodigoEmpresaOperacoes","DescricaoOperacoes","TipoOperacoes","QuantidadeEstoqueOperacoes",');
           SQL.Add('"QuantidadeEncomendaOperacoes","PrecoCustoOperacoes","PrecoVendaOperacoes","SubstituiUltimaEntradaOperacoes",');
           SQL.Add('"SubstituiUltimaSaidaOperacoes","AcumulaEntradaOperacoes","AcumulaSaidaOperacoes","CodigoFiscalOperacoes","CodigoFiscalSTOperacoes") ');
           SQL.Add('values (:xidempresa,:xdescricao,:xtipo,:xqtdestoque,');
           SQL.Add(':xqtdencomenda,:xprecocusto,:xprecovenda,:xsubstituiultimaentrada,');
           SQL.Add(':xsubstituiultimasaida,:xacumulaentrada,:xacumulasaida,(case when :xidcodigofiscal>0 then :xidcodigofiscal else null end),(case when :xidcodigofiscalst>0 then :xidcodigofiscalst else null end)) ');
           ParamByName('xidempresa').AsInteger   := wconexao.FIdEmpresaOperacao;
           ParamByName('xdescricao').AsString    := XOperacao.GetValue('descricao').Value;
           if XOperacao.TryGetValue('tipo',wval) then
              ParamByName('xtipo').AsString      := XOperacao.GetValue('tipo').Value
           else
              ParamByName('xtipo').AsString      := '';
           if XOperacao.TryGetValue('qtdestoque',wval) then
              ParamByName('xqtdestoque').AsString := XOperacao.GetValue('qtdestoque').Value
           else
              ParamByName('xqtdestoque').AsString := '=';
           if XOperacao.TryGetValue('qtdencomenda',wval) then
              ParamByName('xqtdencomenda').AsString := XOperacao.GetValue('qtdencomenda').Value
           else
              ParamByName('xqtdencomenda').AsString := '=';
           if XOperacao.TryGetValue('precocusto',wval) then
              ParamByName('xprecocusto').AsString := XOperacao.GetValue('precocusto').Value
           else
              ParamByName('xprecocusto').AsString := 'M';
           if XOperacao.TryGetValue('precovenda',wval) then
              ParamByName('xprecovenda').AsString := XOperacao.GetValue('precovenda').Value
           else
              ParamByName('xprecovenda').AsString := 'M';
           if XOperacao.TryGetValue('substituiultimaentrada',wval) then
              ParamByName('xsubstituiultimaentrada').AsBoolean := strtobooldef(XOperacao.GetValue('substituiultimaentrada').Value,false)
           else
              ParamByName('xsubstituiultimaentrada').AsBoolean := false;
           if XOperacao.TryGetValue('substituiultimasaida',wval) then
              ParamByName('xsubstituiultimasaida').AsBoolean := strtobooldef(XOperacao.GetValue('substituiultimasaida').Value,false)
           else
              ParamByName('xsubstituiultimasaida').AsBoolean := false;
           if XOperacao.TryGetValue('acumulaentrada',wval) then
              ParamByName('xacumulaentrada').AsBoolean := strtobooldef(XOperacao.GetValue('acumulaentrada').Value,false)
           else
              ParamByName('xacumulaentrada').AsBoolean := false;
           if XOperacao.TryGetValue('acumulasaida',wval) then
              ParamByName('xacumulasaida').AsBoolean := strtobooldef(XOperacao.GetValue('acumulasaida').Value,false)
           else
              ParamByName('xacumulasaida').AsBoolean := false;
           if XOperacao.TryGetValue('idcodigofiscal',wval) then
              ParamByName('xidcodigofiscal').AsInteger := strtointdef(XOperacao.GetValue('idcodigofiscal').Value,0)
           else
              ParamByName('xidcodigofiscal').AsInteger := 0;
           if XOperacao.TryGetValue('idcodigofiscalst',wval) then
              ParamByName('xidcodigofiscalst').AsInteger := strtointdef(XOperacao.GetValue('idcodigofiscalst').Value,0)
           else
              ParamByName('xidcodigofiscalst').AsInteger := 0;
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
                SQL.Add('select "CodigoInternoOperacoes"          as id,');
                SQL.Add('       "DescricaoOperacoes"              as descricao,');
                SQL.Add('       "TipoOperacoes"                   as tipo,');
                SQL.Add('       "QuantidadeEstoqueOperacoes"      as qtdestoque,');
                SQL.Add('       "QuantidadeEncomendaOperacoes"    as qtdencomenda,');
                SQL.Add('       "PrecoCustoOperacoes"             as precocusto,');
                SQL.Add('       "PrecoVendaOperacoes"             as precovenda,');
                SQL.Add('       "SubstituiUltimaEntradaOperacoes" as substituiultimaentrada,');
                SQL.Add('       "SubstituiUltimaSaidaOperacoes"   as substituiultimasaida,');
                SQL.Add('       "AcumulaEntradaOperacoes"         as acumulaentrada,');
                SQL.Add('       "AcumulaSaidaOperacoes"           as acumulasaida,');
                SQL.Add('       "CodigoFiscalOperacoes"           as idcodigofiscal,');
                SQL.Add('       "CodigoFiscalSTOperacoes"         as idcodigofiscalst ');
                SQL.Add('from "Operacao" where "CodigoEmpresaOperacoes"=:xempresa and "DescricaoOperacoes"=:xdescricao ');
                ParamByName('xempresa').AsInteger  := wconexao.FIdEmpresaOperacao;
                ParamByName('xdescricao').AsString := XOperacao.GetValue('descricao').Value;
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhuma Operação incluída');
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


function AlteraOperacao(XIdOperacao: integer; XOperacao: TJSONObject): TJSONObject;
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
    if XOperacao.TryGetValue('descricao',wval) then
       begin
         if wcampos='' then
            wcampos := '"DescricaoOperacoes"=:xdescricao'
         else
            wcampos := wcampos+',"DescricaoOperacoes"=:xdescricao';
       end;
    if XOperacao.TryGetValue('tipo',wval) then
       begin
         if wcampos='' then
            wcampos := '"TipoOperacoes"=:xtipo'
         else
            wcampos := wcampos+',"TipoOperacoes"=:xtipo';
       end;
    if XOperacao.TryGetValue('qtdestoque',wval) then
       begin
         if wcampos='' then
            wcampos := '"QuantidadeEstoqueOperacoes"=:xqtdestoque'
         else
            wcampos := wcampos+',"QuantidadeEstoqueOperacoes"=:xqtdestoque';
       end;
    if XOperacao.TryGetValue('qtdencomenda',wval) then
       begin
         if wcampos='' then
            wcampos := '"QuantidadeEncomendaOperacoes"=:xqtdencomenda'
         else
            wcampos := wcampos+',"QuantidadeEncomendaOperacoes"=:xqtdencomenda';
       end;
    if XOperacao.TryGetValue('precocusto',wval) then
       begin
         if wcampos='' then
            wcampos := '"PrecoCustoOperacoes"=:xprecocusto'
         else
            wcampos := wcampos+',"PrecoCustoOperacoes"=:xprecocusto';
       end;
    if XOperacao.TryGetValue('precovenda',wval) then
       begin
         if wcampos='' then
            wcampos := '"PrecoVendaOperacoes"=:xprecovenda'
         else
            wcampos := wcampos+',"PrecoVendaOperacoes"=:xprecovenda';
       end;
    if XOperacao.TryGetValue('substituiultimaentrada',wval) then
       begin
         if wcampos='' then
            wcampos := '"SubstituiUltimaEntradaOperacoes"=:xsubstituiultimaentrada'
         else
            wcampos := wcampos+',"SubstituiUltimaEntradaOperacoes"=:xsubstituiultimaentrada';
       end;
    if XOperacao.TryGetValue('substituiultimasaida',wval) then
       begin
         if wcampos='' then
            wcampos := '"SubstituiUltimaSaidaOperacoes"=:xsubstituiultimasaida'
         else
            wcampos := wcampos+',"SubstituiUltimaSaidaOperacoes"=:xsubstituiultimasaida';
       end;
    if XOperacao.TryGetValue('acumulaentrada',wval) then
       begin
         if wcampos='' then
            wcampos := '"AcumulaEntradaOperacoes"=:xacumulaentrada'
         else
            wcampos := wcampos+',"AcumulaEntradaOperacoes"=:xacumulaentrada';
       end;
    if XOperacao.TryGetValue('acumulasaida',wval) then
       begin
         if wcampos='' then
            wcampos := '"AcumulaSaidaOperacoes"=:xacumulasaida'
         else
            wcampos := wcampos+',"AcumulaSaidaOperacoes"=:xacumulasaida';
       end;
    if XOperacao.TryGetValue('idcodigofiscal',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoFiscalOperacoes"=:xidcodigofiscal'
         else
            wcampos := wcampos+',"CodigoFiscalOperacoes"=:xidcodigofiscal';
       end;
    if XOperacao.TryGetValue('idcodigofiscalst',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoFiscalSTOperacoes"=:xidcodigofiscalst'
         else
            wcampos := wcampos+',"CodigoFiscalSTOperacoes"=:xidcodigofiscalst';
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
           SQL.Add('Update "Operacao" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoOperacoes"=:xid ');
           ParamByName('xid').AsInteger       := XIdOperacao;
           if XOperacao.TryGetValue('descricao',wval) then
              ParamByName('xdescricao').AsString   := XOperacao.GetValue('descricao').Value;
           if XOperacao.TryGetValue('tipo',wval) then
              ParamByName('xtipo').AsString        := XOperacao.GetValue('tipo').Value;
           if XOperacao.TryGetValue('qtdestoque',wval) then
              ParamByName('xqtdestoque').AsString  := XOperacao.GetValue('qtdestoque').Value;
           if XOperacao.TryGetValue('qtdencomenda',wval) then
              ParamByName('xqtdencomenda').AsString        := XOperacao.GetValue('qtdencomenda').Value;
           if XOperacao.TryGetValue('precocusto',wval) then
              ParamByName('xprecocusto').AsString        := XOperacao.GetValue('precocusto').Value;
           if XOperacao.TryGetValue('precovenda',wval) then
              ParamByName('xprecovenda').AsString        := XOperacao.GetValue('precovenda').Value;
           if XOperacao.TryGetValue('substituiultimaentrada',wval) then
              ParamByName('xsubstituiultimaentrada').AsBoolean  := strtobooldef(XOperacao.GetValue('substituiultimaentrada').Value,false);
           if XOperacao.TryGetValue('substituiultimasaida',wval) then
              ParamByName('xsubstituiultimasaida').AsBoolean  := strtobooldef(XOperacao.GetValue('substituiultimasaida').Value,false);
           if XOperacao.TryGetValue('acumulaentrada',wval) then
              ParamByName('xacumulaentrada').AsBoolean  := strtobooldef(XOperacao.GetValue('acumulaentrada').Value,false);
           if XOperacao.TryGetValue('acumulasaida',wval) then
              ParamByName('xacumulasaida').AsBoolean  := strtobooldef(XOperacao.GetValue('acumulasaida').Value,false);
           if XOperacao.TryGetValue('idcodigofiscal',wval) then
              ParamByName('xidcodigofiscal').AsInteger  := strtointdef(XOperacao.GetValue('idcodigofiscal').Value,0);
           if XOperacao.TryGetValue('idcodigofiscalst',wval) then
               ParamByName('xidcodigofiscalst').AsInteger  := strtointdef(XOperacao.GetValue('idcodigofiscalst').Value,0);
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
              SQL.Add('select "CodigoInternoOperacoes"          as id,');
              SQL.Add('       "DescricaoOperacoes"              as descricao,');
              SQL.Add('       "TipoOperacoes"                   as tipo,');
              SQL.Add('       "QuantidadeEstoqueOperacoes"      as qtdestoque,');
              SQL.Add('       "QuantidadeEncomendaOperacoes"    as qtdencomenda,');
              SQL.Add('       "PrecoCustoOperacoes"             as precocusto,');
              SQL.Add('       "PrecoVendaOperacoes"             as precovenda,');
              SQL.Add('       "SubstituiUltimaEntradaOperacoes" as substituiultimaentrada,');
              SQL.Add('       "SubstituiUltimaSaidaOperacoes"   as substituiultimasaida,');
              SQL.Add('       "AcumulaEntradaOperacoes"         as acumulaentrada,');
              SQL.Add('       "AcumulaSaidaOperacoes"           as acumulasaida,');
              SQL.Add('       "CodigoFiscalOperacoes"           as idcodigofiscal,');
              SQL.Add('       "CodigoFiscalSTOperacoes"         as idcodigofiscalst ');
              SQL.Add('from "Operacao" ');
              SQL.Add('where "CodigoInternoOperacoes" =:xid ');
              ParamByName('xid').AsInteger := XIdOperacao;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhuma Operação alterada');
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

function VerificaRequisicao(XOperacao: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XOperacao.TryGetValue('descricao',wval) then
       wret := false;
    if not XOperacao.TryGetValue('tipo',wval) then
       wret := false;
  finally
  end;
  Result := wret;
end;

function ApagaOperacao(XIdOperacao: integer): TJSONObject;
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
         SQL.Add('delete from "Operacao" where "CodigoInternoOperacoes"=:xid ');
         ParamByName('xid').AsInteger := XIdOperacao;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Operação excluída com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhuma Operação excluída');
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
