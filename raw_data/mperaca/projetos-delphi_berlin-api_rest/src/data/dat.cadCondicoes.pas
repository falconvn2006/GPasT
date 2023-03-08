unit dat.cadCondicoes;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaCondicao(XId: integer): TJSONObject;
function RetornaListaCondicoes(const XQuery: TDictionary<string, string>; XLimit,XOffset: integer): TJSONArray;
function RetornaTotalCondicoes(const XQuery: TDictionary<string, string>): TJSONObject;
function IncluiCondicao(XCondicao: TJSONObject): TJSONObject;
function VerificaRequisicao(XCondicao: TJSONObject): boolean;
function AlteraCondicao(XIdCondicao: integer; XCondicao: TJSONObject): TJSONObject;
function ApagaCondicao(XIdCondicao: integer): TJSONObject;

implementation

uses prv.dataModuleConexao;

function RetornaCondicao(XId: integer): TJSONObject;
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
         SQL.Add('select "CodigoInternoCondicao"    as id,');
         SQL.Add('       "DescricaoCondicao"        as descricao,');
         SQL.Add('       "TipoCondicao"             as tipo, ');
         SQL.Add('       "NumeroPagamentosCondicao" as numpag,');
         SQL.Add('       "CodigoCobrancaCondicao"   as idcobranca,');
         SQL.Add('       "MetodoCondicao"           as metodo,');
         SQL.Add('       "EmiteCobrancaCondicao"    as emitecobranca,');
         SQL.Add('       "PrecoPadraoCondicao"      as preco,');
         SQL.Add('       "DescAcrescCondicao"       as descacresc,');
         SQL.Add('       "PercDescAcrescPadraoCondicao" as percdescacresc,');
         SQL.Add('       "CodigoOperacaoCondicao"   as idoperacao,');
         SQL.Add('       "CodigoPlanoCondicao"      as idplano,');
         SQL.Add('       "CodigoFiscalCondicao"     as idfiscal,');
         SQL.Add('       "PrazoMedioCondicao"       as prazomedio,');
         SQL.Add('       "DescricaoCodigoFiscal"    as descfiscal,');
         SQL.Add('       "FormaPagamentoCondicao"   as idformapagamento,');
         SQL.Add('       "CodigoOpercaoEntradaCondicao"    as idoperacaoentrada,');
         SQL.Add('       "CodigoFiscalEntradaCondicao"     as idfiscalentrada,');
         SQL.Add('       "EhEntradaCondicao"               as ehentrada,');
         SQL.Add('       "EhSaidaCondicao"                 as ehsaida,');
         SQL.Add('       "EhAtivoCondicao"                 as ehativo,');
         SQL.Add('       "PrimeiraParcelaQuitadaCondicao"  as primeiraparcelaquitada,');
         SQL.Add('       "TaxaPorParcelaCondicao"          as taxaparcela,');
         SQL.Add('       "TaxaCondicao"                    as taxa,');
         SQL.Add('       "PercentualJuroMesCondicao"       as percjuromes,');
         SQL.Add('       "MaximoParcelasCondicao"          as nummaximoparcelas,');
         SQL.Add('       "DiasIntervaloParcelasCondicao"   as diasintervalo,');
         SQL.Add('       "DefinirPedidoBloqueadoCondicao"  as pedidobloqueado,');
         SQL.Add('       "CondicaoComEntradaCondicao"      as condicaocomentrada,');
         SQL.Add('       "TestaLimiteDisponivelCondicao"   as testalimitedisponivel,');
         SQL.Add('       "UsarNumeroMaximoParcelaCondicao" as usanumeromaximoparcela,');
         SQL.Add('       "CodigoFiscalEntradaSTCondicao"   as idfiscalentradast,');
         SQL.Add('       "CodigoFiscalSTCondicao"          as idfiscalst,');
         SQL.Add('       "TaxaRetencaoCondicao"            as taxaretencao,');
         SQL.Add('       "ObservacaoCondicao"              as observacao,');
         SQL.Add('       "TodasParcelasQuitadasCondicao"   as parcelasquitadas,');
         SQL.Add('       "TipoPrecoTabelaCondicao"         as tipoprecotabela,');
         SQL.Add('       "TipoCreditoDevolucaoCondicao"    as tipocreditodevolucao,');
         SQL.Add('       "ExigeIdentificacaoClienteCondicao" as exigeidentificacao,');
         SQL.Add('       "ClassificacaoFiscalCondicao"       as idclassificacaofiscal,');
         SQL.Add('       "PortadorPadraoCondicao"            as idportador,');
         SQL.Add('       "NaoContabilizarCondicao"           as naocontabilizar,');
         SQL.Add('       "UtilizarClienteEspecialCondicao"   as utilizarclienteespecial,');
         SQL.Add('       "LiberaAjusteParcelamentoCondicao"  as liberaajusteparcelamento,');
         SQL.Add('       "LiberaAlterarDescontoCondicao"     as liberaalterardesconto,');
         SQL.Add('       "BloqueiaDocumentoCobrancaCondicao" as bloqueiadocumentocobranca,');
         SQL.Add('       "ValorParcelaMinimaCondicao"        as valorparcelaminima,');
         SQL.Add('       "ValorCompraMinimaCondicao"         as valorcompraminima ');
         SQL.Add('from "CondicaoPagamento" ');
         SQL.Add('where "CodigoInternoCondicao"=:xid and "EhAtivoCondicao"=''true'' and "EhSaidaCondicao"=''true'' ');
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
        wret.AddPair('description','Nenhuma condição de pagamento encontrada');
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

function RetornaListaCondicoes(const XQuery: TDictionary<string, string>; XLimit,XOffset: integer): TJSONArray;
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
         SQL.Add('select "CodigoInternoCondicao"    as id,');
         SQL.Add('       "DescricaoCondicao"        as descricao,');
         SQL.Add('       "TipoCondicao"             as tipo, ');
         SQL.Add('       "NumeroPagamentosCondicao" as numpag,');
         SQL.Add('       "CodigoCobrancaCondicao"   as idcobranca,');
         SQL.Add('       "MetodoCondicao"           as metodo,');
         SQL.Add('       "EmiteCobrancaCondicao"    as emitecobranca,');
         SQL.Add('       "PrecoPadraoCondicao"      as preco,');
         SQL.Add('       "DescAcrescCondicao"       as descacresc,');
         SQL.Add('       "PercDescAcrescPadraoCondicao" as percdescacresc,');
         SQL.Add('       "CodigoOperacaoCondicao"   as idoperacao,');
         SQL.Add('       "CodigoPlanoCondicao"      as idplano,');
         SQL.Add('       "CodigoFiscalCondicao"     as idfiscal,');
         SQL.Add('       "PrazoMedioCondicao"       as prazomedio,');
         SQL.Add('       "DescricaoCodigoFiscal"    as descfiscal,');
         SQL.Add('       "FormaPagamentoCondicao"   as idformapagamento,');
         SQL.Add('       "CodigoOpercaoEntradaCondicao"    as idoperacaoentrada,');
         SQL.Add('       "CodigoFiscalEntradaCondicao"     as idfiscalentrada,');
         SQL.Add('       "EhEntradaCondicao"               as ehentrada,');
         SQL.Add('       "EhSaidaCondicao"                 as ehsaida,');
         SQL.Add('       "EhAtivoCondicao"                 as ehativo,');
         SQL.Add('       "PrimeiraParcelaQuitadaCondicao"  as primeiraparcelaquitada,');
         SQL.Add('       "TaxaPorParcelaCondicao"          as taxaparcela,');
         SQL.Add('       "TaxaCondicao"                    as taxa,');
         SQL.Add('       "PercentualJuroMesCondicao"       as percjuromes,');
         SQL.Add('       "MaximoParcelasCondicao"          as nummaximoparcelas,');
         SQL.Add('       "DiasIntervaloParcelasCondicao"   as diasintervalo,');
         SQL.Add('       "DefinirPedidoBloqueadoCondicao"  as pedidobloqueado,');
         SQL.Add('       "CondicaoComEntradaCondicao"      as condicaocomentrada,');
         SQL.Add('       "TestaLimiteDisponivelCondicao"   as testalimitedisponivel,');
         SQL.Add('       "UsarNumeroMaximoParcelaCondicao" as usanumeromaximoparcela,');
         SQL.Add('       "CodigoFiscalEntradaSTCondicao"   as idfiscalentradast,');
         SQL.Add('       "CodigoFiscalSTCondicao"          as idfiscalst,');
         SQL.Add('       "TaxaRetencaoCondicao"            as taxaretencao,');
         SQL.Add('       "ObservacaoCondicao"              as observacao,');
         SQL.Add('       "TodasParcelasQuitadasCondicao"   as parcelasquitadas,');
         SQL.Add('       "TipoPrecoTabelaCondicao"         as tipoprecotabela,');
         SQL.Add('       "TipoCreditoDevolucaoCondicao"    as tipocreditodevolucao,');
         SQL.Add('       "ExigeIdentificacaoClienteCondicao" as exigeidentificacao,');
         SQL.Add('       "ClassificacaoFiscalCondicao"       as idclassificacaofiscal,');
         SQL.Add('       "PortadorPadraoCondicao"            as idportador,');
         SQL.Add('       "NaoContabilizarCondicao"           as naocontabilizar,');
         SQL.Add('       "UtilizarClienteEspecialCondicao"   as utilizarclienteespecial,');
         SQL.Add('       "LiberaAjusteParcelamentoCondicao"  as liberaajusteparcelamento,');
         SQL.Add('       "LiberaAlterarDescontoCondicao"     as liberaalterardesconto,');
         SQL.Add('       "BloqueiaDocumentoCobrancaCondicao" as bloqueiadocumentocobranca,');
         SQL.Add('       "ValorParcelaMinimaCondicao"        as valorparcelaminima,');
         SQL.Add('       "ValorCompraMinimaCondicao"         as valorcompraminima ');
         SQL.Add('from "CondicaoPagamento" ');
         SQL.Add('where "CodigoEmpresaCondicao"=:xempresa and "EhAtivoCondicao"=''true'' and "EhSaidaCondicao"=''true'' ');
         ParamByName('xempresa').AsInteger := wconexao.FIdEmpresaCondicao;

         if XQuery.ContainsKey('descricao') then // filtro por nome
            begin
              SQL.Add('and lower("DescricaoCondicao") like lower(:xdescricao) ');
              ParamByName('xdescricao').AsString := XQuery.Items['descricao']+'%';
            end;
         if XQuery.ContainsKey('tipo') then // filtro por nome
            begin
              SQL.Add('and lower("TipoCondicao") like lower(:xtipo) ');
              ParamByName('xtipo').AsString := XQuery.Items['tipo']+'%';
            end;
         if XQuery.ContainsKey('numpag') then // filtro por nome
            begin
              SQL.Add('and "NumeroPagamentosCondicao" =:xnumpag ');
              ParamByName('xnumpag').AsInteger := strtointdef(XQuery.Items['numpag'],0);
            end;
         if XQuery.ContainsKey('prazomedio') then // filtro por nome
            begin
              SQL.Add('and "PrazoMedioCondicao" =:xprazomedio ');
              ParamByName('xprazomedio').AsInteger := strtointdef(XQuery.Items['prazomedio'],0);
            end;
         if XQuery.ContainsKey('order') then // ordenação
            begin
              if XQuery.Items['order']='descricao' then
                 wordem := 'order by upper("DescricaoCondicao") '
              else if XQuery.Items['order']='tipo' then
                 wordem := 'order by upper("TipoCondicao") '
              else if XQuery.Items['order']='numpag' then
                 wordem := 'order by "NumeroPagamentosCondicao" '
              else if XQuery.Items['order']='prazomedio' then
                 wordem := 'order by "PrazoMedioCondicao" ';
              if XQuery.ContainsKey('dir') then // direção
                 wordem := wordem +XQuery.Items['dir'];
              SQL.Add(wordem);
            end
         else
            SQL.Add('order by "DescricaoCondicao" ');
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
         wobj.AddPair('description','Nenhuma condicao de pagamento encontrada');
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


function RetornaTotalCondicoes(const XQuery: TDictionary<string, string>): TJSONObject;
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
         SQL.Add('from "CondicaoPagamento" where "CodigoEmpresaCondicao"=:xempresa ');
         if XQuery.ContainsKey('descricao') then // filtro por nome
            begin
              SQL.Add('and lower("DescricaoCondicao") like lower(:xdescricao) ');
              ParamByName('xdescricao').AsString := XQuery.Items['descricao']+'%';
            end;
         if XQuery.ContainsKey('tipo') then // filtro por nome
            begin
              SQL.Add('and lower("TipoCondicao") like lower(:xtipo) ');
              ParamByName('xtipo').AsString := XQuery.Items['tipo']+'%';
            end;
         if XQuery.ContainsKey('numpag') then // filtro por nome
            begin
              SQL.Add('and "NumeroPagamentosCondicao" =:xnumpag ');
              ParamByName('xnumpag').AsInteger := strtointdef(XQuery.Items['numpag'],0);
            end;
         if XQuery.ContainsKey('prazomedio') then // filtro por nome
            begin
              SQL.Add('and "PrazoMedioCondicao" =:xprazomedio ');
              ParamByName('xprazomedio').AsInteger := strtointdef(XQuery.Items['prazomedio'],0);
            end;
         ParamByName('xempresa').AsInteger := wconexao.FIdEmpresaCondicao;
         Open;
         EnableControls;
       end;

   if wquery.RecordCount>0 then
      wret := wquery.ToJSONObject()
   else
      begin
        wret := TJSONObject.Create;
        wret.AddPair('status','500');
        wret.AddPair('description','Nenhuma condição encontrada');
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


function IncluiCondicao(XCondicao: TJSONObject): TJSONObject;
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
           SQL.Add('Insert into "CondicaoPagamento" ("CodigoEmpresaCondicao","DescricaoCondicao","TipoCondicao","MetodoCondicao","EmiteCobrancaCondicao","PrecoPadraoCondicao",');
           SQL.Add('"DescAcrescCondicao","PercDescAcrescPadraoCondicao","CodigoOperacaoCondicao","CodigoPlanoCondicao","CodigoFiscalCondicao","NumeroPagamentosCondicao",');
           SQL.Add('"PrazoMedioCondicao","DescricaoCodigoFiscal","FormaPagamentoCondicao","CodigoCobrancaCondicao","CodigoOpercaoEntradaCondicao","CodigoFiscalEntradaCondicao",');
           SQL.Add('"EhEntradaCondicao","EhSaidaCondicao","EhAtivoCondicao","PrimeiraParcelaQuitadaCondicao","TaxaPorParcelaCondicao","TaxaCondicao","PercentualJuroMesCondicao",');
           SQL.Add('"MaximoParcelasCondicao","DiasIntervaloParcelasCondicao","DefinirPedidoBloqueadoCondicao","CondicaoComEntradaCondicao","TestaLimiteDisponivelCondicao","UsarNumeroMaximoParcelaCondicao",');
           SQL.Add('"CodigoFiscalEntradaSTCondicao","CodigoFiscalSTCondicao","TaxaRetencaoCondicao","ObservacaoCondicao","TodasParcelasQuitadasCondicao","TipoPrecoTabelaCondicao",');
           SQL.Add('"TipoCreditoDevolucaoCondicao","ExigeIdentificacaoClienteCondicao","ClassificacaoFiscalCondicao","PortadorPadraoCondicao","NaoContabilizarCondicao","UtilizarClienteEspecialCondicao",');
           SQL.Add('"LiberaAjusteParcelamentoCondicao","LiberaAlterarDescontoCondicao","BloqueiaDocumentoCobrancaCondicao","ValorParcelaMinimaCondicao","ValorCompraMinimaCondicao") ');

           SQL.Add('values (:xidempresa,:xdescricao,:xtipo,:xmetodo,:xemitecobranca,:xpreco,');
           SQL.Add(':xdescacresc,:xpercdescacresc,:xidoperacao,:xidplano,(case when :xidfiscal>0 then :xidfiscal else null end),:xnumpag,');
           SQL.Add(':xprazomedio,:xdescfiscal,(case when :xidformapagamento>0 then :xidformapagamento else null end),:xidcobranca,(case when :xidoperacaoentrada>0 then :xidoperacaoentrada else null end),(case when :xidfiscalentrada>0 then :xidfiscalentrada else null end),');
           SQL.Add(':xehentrada,:xehsaida,:xehativo,:xprimeiraparcelaquitada,:xtaxaparcela,:xtaxa,:xpercjuromes,');
           SQL.Add(':xnummaximoparcelas,:xdiasintervalo,:xpedidobloqueado,:xcondicaocomentrada,:xtestalimitedisponivel,:xusanumeromaximoparcela,');
           SQL.Add(':xidfiscalentradast,:xidfiscalst,:xtaxaretencao,:xobservacao,:xparcelasquitadas,:xtipoprecotabela,');
           SQL.Add(':xtipocreditodevolucao,:xexigeidentificacao,:xidclassificacaofiscal,:xidportador,:xnaocontabilizar,:xutilizarclienteespecial,');
           SQL.Add(':xliberaajusteparcelamento,:xliberaalterardesconto,:xbloqueiadocumentocobranca,:xvalorparcelaminima,:xvalorcompraminima) ');

           ParamByName('xidempresa').AsInteger   := wconexao.FIdEmpresaCondicao;
           ParamByName('xdescricao').AsString    := XCondicao.GetValue('descricao').Value;
           ParamByName('xtipo').AsString         := XCondicao.GetValue('tipo').Value;
           ParamByName('xpreco').AsInteger       := strtointdef(XCondicao.GetValue('preco').Value,0);
           if XCondicao.TryGetValue('metodo',wval) then
              ParamByName('xmetodo').AsString  := XCondicao.GetValue('metodo').Value
           else
              ParamByName('xmetodo').AsString  := 'P';
           if XCondicao.TryGetValue('emitecobranca',wval) then
              ParamByName('xemitecobranca').AsBoolean  := strtobooldef(XCondicao.GetValue('emitecobranca').Value,false)
           else
              ParamByName('xemitecobranca').AsBoolean  := false;
           if XCondicao.TryGetValue('descacresc',wval) then
              ParamByName('xdescacresc').AsString  := XCondicao.GetValue('descacresc').Value
           else
              ParamByName('xdescacresc').AsString  := 'Desconto';
           if XCondicao.TryGetValue('percdescacresc',wval) then
              ParamByName('xpercdescacresc').AsFloat  := strtofloatdef(XCondicao.GetValue('percdescacresc').Value,0)
           else
              ParamByName('xpercdescacresc').AsFloat  := 0;
           if XCondicao.TryGetValue('idoperacao',wval) then
              ParamByName('xidoperacao').AsInteger  := strtointdef(XCondicao.GetValue('idoperacao').Value,0)
           else
              ParamByName('xidoperacao').AsInteger  := 0;
           if XCondicao.TryGetValue('idplano',wval) then
              ParamByName('xidplano').AsInteger  := strtointdef(XCondicao.GetValue('idplano').Value,0)
           else
              ParamByName('xidplano').AsInteger  := 0;
           if XCondicao.TryGetValue('idfiscal',wval) then
              ParamByName('xidfiscal').AsInteger  := strtointdef(XCondicao.GetValue('idfiscal').Value,0)
           else
              ParamByName('xidfiscal').AsInteger  := 0;
           if XCondicao.TryGetValue('numpag',wval) then
              ParamByName('xnumpag').AsInteger  := strtointdef(XCondicao.GetValue('numpag').Value,0)
           else
              ParamByName('xnumpag').AsInteger  := 0;
           if XCondicao.TryGetValue('prazomedio',wval) then
              ParamByName('xprazomedio').AsInteger  := strtointdef(XCondicao.GetValue('prazomedio').Value,0)
           else
              ParamByName('xprazomedio').AsInteger  := 0;
           if XCondicao.TryGetValue('descfiscal',wval) then
              ParamByName('xdescfiscal').AsString  := XCondicao.GetValue('descfiscal').Value
           else
              ParamByName('xdescfiscal').AsString  := '';
           if XCondicao.TryGetValue('idformapagamento',wval) then
              ParamByName('xidformapagamento').AsInteger  := strtointdef(XCondicao.GetValue('idformapagamento').Value,0)
           else
              ParamByName('xidformapagamento').AsInteger  := 0;
           if XCondicao.TryGetValue('idcobranca',wval) then
              ParamByName('xidcobranca').AsInteger  := strtointdef(XCondicao.GetValue('idcobranca').Value,0)
           else
              ParamByName('xidcobranca').AsInteger  := 0;
           if XCondicao.TryGetValue('idoperacaoentrada',wval) then
              ParamByName('xidoperacaoentrada').AsInteger  := strtointdef(XCondicao.GetValue('idoperacaoentrada').Value,0)
           else
              ParamByName('xidoperacaoentrada').AsInteger  := 0;
           if XCondicao.TryGetValue('idfiscalentrada',wval) then
              ParamByName('xidfiscalentrada').AsInteger  := strtointdef(XCondicao.GetValue('idfiscalentrada').Value,0)
           else
              ParamByName('xidfiscalentrada').AsInteger  := 0;
           if XCondicao.TryGetValue('ehentrada',wval) then
              ParamByName('xehentrada').AsBoolean  := strtobooldef(XCondicao.GetValue('ehentrada').Value,false)
           else
              ParamByName('xehentrada').AsBoolean  := false;
           if XCondicao.TryGetValue('ehsaida',wval) then
              ParamByName('xehsaida').AsBoolean  := strtobooldef(XCondicao.GetValue('ehsaida').Value,false)
           else
              ParamByName('xehsaida').AsBoolean  := false;
           if XCondicao.TryGetValue('ehativo',wval) then
              ParamByName('xehativo').AsBoolean  := strtobooldef(XCondicao.GetValue('ehativo').Value,false)
           else
              ParamByName('xehativo').AsBoolean  := true;
           if XCondicao.TryGetValue('primeiraparcelaquitada',wval) then
              ParamByName('xprimeiraparcelaquitada').AsBoolean  := strtobooldef(XCondicao.GetValue('primeiraparcelaquitada').Value,false)
           else
              ParamByName('xprimeiraparcelaquitada').AsBoolean  := false;
           if XCondicao.TryGetValue('taxaparcela',wval) then
              ParamByName('xtaxaparcela').AsFloat  := strtofloatdef(XCondicao.GetValue('taxaparcela').Value,0)
           else
              ParamByName('xtaxaparcela').AsFloat  := 0;
           if XCondicao.TryGetValue('taxa',wval) then
              ParamByName('xtaxa').AsFloat  := strtofloatdef(XCondicao.GetValue('taxa').Value,0)
           else
              ParamByName('xtaxa').AsFloat  := 0;
           if XCondicao.TryGetValue('percjuromes',wval) then
              ParamByName('xpercjuromes').AsFloat  := strtofloatdef(XCondicao.GetValue('percjuromes').Value,0)
           else
              ParamByName('xpercjuromes').AsFloat  := 0;
           if XCondicao.TryGetValue('nummaximoparcelas',wval) then
              ParamByName('xnummaximoparcelas').AsInteger  := strtointdef(XCondicao.GetValue('nummaximoparcelas').Value,0)
           else
              ParamByName('xnummaximoparcelas').AsInteger  := 0;
           if XCondicao.TryGetValue('diasintervalo',wval) then
              ParamByName('xdiasintervalo').AsInteger  := strtointdef(XCondicao.GetValue('diasintervalo').Value,0)
           else
              ParamByName('xdiasintervalo').AsInteger  := 0;
           if XCondicao.TryGetValue('pedidobloqueado',wval) then
              ParamByName('xpedidobloqueado').AsBoolean  := strtobooldef(XCondicao.GetValue('pedidobloqueado').Value,false)
           else
              ParamByName('xpedidobloqueado').AsBoolean  := false;
           if XCondicao.TryGetValue('condicaocomentrada',wval) then
              ParamByName('xcondicaocomentrada').AsBoolean  := strtobooldef(XCondicao.GetValue('condicaocomentrada').Value,false)
           else
              ParamByName('xcondicaocomentrada').AsBoolean  := false;
           if XCondicao.TryGetValue('testalimitedisponivel',wval) then
              ParamByName('xtestalimitedisponivel').AsBoolean  := strtobooldef(XCondicao.GetValue('testalimitedisponivel').Value,false)
           else
              ParamByName('xtestalimitedisponivel').AsBoolean  := false;
           if XCondicao.TryGetValue('usanumeromaximoparcela',wval) then
              ParamByName('xusanumeromaximoparcela').AsBoolean  := strtobooldef(XCondicao.GetValue('usanumeromaximoparcela').Value,false)
           else
              ParamByName('xusanumeromaximoparcela').AsBoolean  := false;
           if XCondicao.TryGetValue('idfiscalentradast',wval) then
              ParamByName('xidfiscalentradast').AsInteger  := strtointdef(XCondicao.GetValue('idfiscalentradast').Value,0)
           else
              ParamByName('xidfiscalentradast').AsInteger  := 0;
           if XCondicao.TryGetValue('idfiscalst',wval) then
              ParamByName('xidfiscalst').AsInteger  := strtointdef(XCondicao.GetValue('idfiscalst').Value,0)
           else
              ParamByName('xidfiscalst').AsInteger  := 0;
           if XCondicao.TryGetValue('taxaretencao',wval) then
              ParamByName('xtaxaretencao').AsFloat  := strtofloatdef(XCondicao.GetValue('taxaretencao').Value,0)
           else
              ParamByName('xtaxaretencao').AsFloat  := 0;
           if XCondicao.TryGetValue('observacao',wval) then
              ParamByName('xobservacao').AsString  := XCondicao.GetValue('observacao').Value
           else
              ParamByName('xobservacao').AsString  := '';
           if XCondicao.TryGetValue('parcelasquitadas',wval) then
              ParamByName('xparcelasquitadas').AsBoolean  := strtobooldef(XCondicao.GetValue('parcelasquitadas').Value,false)
           else
              ParamByName('xparcelasquitadas').AsBoolean  := false;
           if XCondicao.TryGetValue('tipoprecotabela',wval) then
              ParamByName('xtipoprecotabela').AsString  := XCondicao.GetValue('tipoprecotabela').Value
           else
              ParamByName('xtipoprecotabela').AsString  := '';
           if XCondicao.TryGetValue('tipocreditodevolucao',wval) then
              ParamByName('xtipocreditodevolucao').AsString  := XCondicao.GetValue('tipocreditodevolucao').Value
           else
              ParamByName('xtipocreditodevolucao').AsString  := '';
           if XCondicao.TryGetValue('exigeidentificacao',wval) then
              ParamByName('xexigeidentificacao').AsBoolean  := strtobooldef(XCondicao.GetValue('exigeidentificacao').Value,false)
           else
              ParamByName('xexigeidentificacao').AsBoolean  := false;
           if XCondicao.TryGetValue('idclassificacaofiscal',wval) then
              ParamByName('xidclassificacaofiscal').AsInteger  := strtointdef(XCondicao.GetValue('idclassificacaofiscal').Value,0)
           else
              ParamByName('xidclassificacaofiscal').AsInteger  := 0;
           if XCondicao.TryGetValue('idportador',wval) then
              ParamByName('xidportador').AsInteger  := strtointdef(XCondicao.GetValue('idportador').Value,0)
           else
              ParamByName('xidportador').AsInteger  := 0;
           if XCondicao.TryGetValue('naocontabilizar',wval) then
              ParamByName('xnaocontabilizar').AsBoolean  := strtobooldef(XCondicao.GetValue('naocontabilizar').Value,false)
           else
              ParamByName('xnaocontabilizar').AsBoolean  := false;
           if XCondicao.TryGetValue('utilizarclienteespecial',wval) then
              ParamByName('xutilizarclienteespecial').AsBoolean  := strtobooldef(XCondicao.GetValue('utilizarclienteespecial').Value,false)
           else
              ParamByName('xutilizarclienteespecial').AsBoolean  := false;
           if XCondicao.TryGetValue('liberaajusteparcelamento',wval) then
              ParamByName('xliberaajusteparcelamento').AsBoolean  := strtobooldef(XCondicao.GetValue('liberaajusteparcelamento').Value,false)
           else
              ParamByName('xliberaajusteparcelamento').AsBoolean  := false;
           if XCondicao.TryGetValue('liberaalterardesconto',wval) then
              ParamByName('xliberaalterardesconto').AsBoolean  := strtobooldef(XCondicao.GetValue('liberaalterardesconto').Value,false)
           else
              ParamByName('xliberaalterardesconto').AsBoolean  := false;
           if XCondicao.TryGetValue('bloqueiadocumentocobranca',wval) then
              ParamByName('xbloqueiadocumentocobranca').AsBoolean  := strtobooldef(XCondicao.GetValue('bloqueiadocumentocobranca').Value,false)
           else
              ParamByName('xbloqueiadocumentocobranca').AsBoolean  := false;
           if XCondicao.TryGetValue('valorparcelaminima',wval) then
              ParamByName('xvalorparcelaminima').AsFloat  := strtofloatdef(XCondicao.GetValue('valorparcelaminima').Value,0)
           else
              ParamByName('xvalorparcelaminima').AsFloat  := 0;
           if XCondicao.TryGetValue('valorcompraminima',wval) then
              ParamByName('xvalorcompraminima').AsFloat  := strtofloatdef(XCondicao.GetValue('valorcompraminima').Value,0)
           else
              ParamByName('xvalorcompraminima').AsFloat  := 0;
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
                SQL.Add('select "CodigoInternoCondicao"    as id,');
                SQL.Add('       "DescricaoCondicao"        as descricao,');
                SQL.Add('       "TipoCondicao"             as tipo, ');
                SQL.Add('       "NumeroPagamentosCondicao" as numpag,');
                SQL.Add('       "CodigoCobrancaCondicao"   as idcobranca,');
                SQL.Add('       "MetodoCondicao"           as metodo,');
                SQL.Add('       "EmiteCobrancaCondicao"    as emitecobranca,');
                SQL.Add('       "PrecoPadraoCondicao"      as preco,');
                SQL.Add('       "DescAcrescCondicao"       as descacresc,');
                SQL.Add('       "PercDescAcrescPadraoCondicao" as percdescacresc,');
                SQL.Add('       "CodigoOperacaoCondicao"   as idoperacao,');
                SQL.Add('       "CodigoPlanoCondicao"      as idplano,');
                SQL.Add('       "CodigoFiscalCondicao"     as idfiscal,');
                SQL.Add('       "PrazoMedioCondicao"       as prazomedio,');
                SQL.Add('       "DescricaoCodigoFiscal"    as descfiscal,');
                SQL.Add('       "FormaPagamentoCondicao"   as idformapagamento,');
                SQL.Add('       "CodigoOpercaoEntradaCondicao"    as idoperacaoentrada,');
                SQL.Add('       "CodigoFiscalEntradaCondicao"     as idfiscalentrada,');
                SQL.Add('       "EhEntradaCondicao"               as ehentrada,');
                SQL.Add('       "EhSaidaCondicao"                 as ehsaida,');
                SQL.Add('       "EhAtivoCondicao"                 as ehativo,');
                SQL.Add('       "PrimeiraParcelaQuitadaCondicao"  as primeiraparcelaquitada,');
                SQL.Add('       "TaxaPorParcelaCondicao"          as taxaparcela,');
                SQL.Add('       "TaxaCondicao"                    as taxa,');
                SQL.Add('       "PercentualJuroMesCondicao"       as percjuromes,');
                SQL.Add('       "MaximoParcelasCondicao"          as nummaximoparcelas,');
                SQL.Add('       "DiasIntervaloParcelasCondicao"   as diasintervalo,');
                SQL.Add('       "DefinirPedidoBloqueadoCondicao"  as pedidobloqueado,');
                SQL.Add('       "CondicaoComEntradaCondicao"      as condicaocomentrada,');
                SQL.Add('       "TestaLimiteDisponivelCondicao"   as testalimitedisponivel,');
                SQL.Add('       "UsarNumeroMaximoParcelaCondicao" as usanumeromaximoparcela,');
                SQL.Add('       "CodigoFiscalEntradaSTCondicao"   as idfiscalentradast,');
                SQL.Add('       "CodigoFiscalSTCondicao"          as idfiscalst,');
                SQL.Add('       "TaxaRetencaoCondicao"            as taxaretencao,');
                SQL.Add('       "ObservacaoCondicao"              as observacao,');
                SQL.Add('       "TodasParcelasQuitadasCondicao"   as parcelasquitadas,');
                SQL.Add('       "TipoPrecoTabelaCondicao"         as tipoprecotabela,');
                SQL.Add('       "TipoCreditoDevolucaoCondicao"    as tipocreditodevolucao,');
                SQL.Add('       "ExigeIdentificacaoClienteCondicao" as exigeidentificacao,');
                SQL.Add('       "ClassificacaoFiscalCondicao"       as idclassificacaofiscal,');
                SQL.Add('       "PortadorPadraoCondicao"            as idportador,');
                SQL.Add('       "NaoContabilizarCondicao"           as naocontabilizar,');
                SQL.Add('       "UtilizarClienteEspecialCondicao"   as utilizarclienteespecial,');
                SQL.Add('       "LiberaAjusteParcelamentoCondicao"  as liberaajusteparcelamento,');
                SQL.Add('       "LiberaAlterarDescontoCondicao"     as liberaalterardesconto,');
                SQL.Add('       "BloqueiaDocumentoCobrancaCondicao" as bloqueiadocumentocobranca,');
                SQL.Add('       "ValorParcelaMinimaCondicao"        as valorparcelaminima,');
                SQL.Add('       "ValorCompraMinimaCondicao"         as valorcompraminima ');
                SQL.Add('from "CondicaoPagamento" where "CodigoEmpresaCondicao"=:xempresa and "DescricaoCondicao"=:xdescricao ');
                ParamByName('xempresa').AsInteger  := wconexao.FIdEmpresaCobranca;
                ParamByName('xdescricao').AsString := XCondicao.GetValue('descricao').Value;
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhuma Condição incluída');
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

function VerificaRequisicao(XCondicao: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XCondicao.TryGetValue('descricao',wval) then
       wret := false;
    if not XCondicao.TryGetValue('tipo',wval) then
       wret := false;
    if not XCondicao.TryGetValue('preco',wval) then
       wret := false;
    if not XCondicao.TryGetValue('ehentrada',wval) then
       wret := false;
    if not XCondicao.TryGetValue('ehsaida',wval) then
       wret := false;
    if not XCondicao.TryGetValue('metodo',wval) then
       wret := false;
    if not XCondicao.TryGetValue('idclassificacaofiscal',wval) then
       wret := false;
    if not XCondicao.TryGetValue('idcobranca',wval) then
       wret := false;
    if not XCondicao.TryGetValue('idoperacao',wval) then
       wret := false;
    if not XCondicao.TryGetValue('idformapagamento',wval) then
       wret := false;
    if not XCondicao.TryGetValue('idportador',wval) then
       wret := false;
  finally
  end;
  Result := wret;
end;

function AlteraCondicao(XIdCondicao: integer; XCondicao: TJSONObject): TJSONObject;
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
    if XCondicao.TryGetValue('descricao',wval) then
       begin
         if wcampos='' then
            wcampos := '"DescricaoCondicao"=:xdescricao'
         else
            wcampos := wcampos+',"DescricaoCondicao"=:xdescricao';
       end;
    if XCondicao.TryGetValue('tipo',wval) then
       begin
         if wcampos='' then
            wcampos := '"TipoCondicao"=:xtipo'
         else
            wcampos := wcampos+',"TipoCondicao"=:xtipo';
       end;
    if XCondicao.TryGetValue('preco',wval) then
       begin
         if wcampos='' then
            wcampos := '"PrecoPadraoCondicao"=:xpreco'
         else
            wcampos := wcampos+',"PrecoPadraoCondicao"=:xpreco';
       end;
    if XCondicao.TryGetValue('metodo',wval) then
       begin
         if wcampos='' then
            wcampos := '"MetodoCondicao"=:xmetodo'
         else
            wcampos := wcampos+',"MetodoCondicao"=:xmetodo';
       end;
    if XCondicao.TryGetValue('emitecobranca',wval) then
       begin
         if wcampos='' then
            wcampos := '"EmiteCobrancaCondicao"=:xemitecobranca'
         else
            wcampos := wcampos+',"EmiteCobrancaCondicao"=:xemitecobranca';
       end;
    if XCondicao.TryGetValue('descacresc',wval) then
       begin
         if wcampos='' then
            wcampos := '"DescAcrescCondicao"=:xdescacresc'
         else
            wcampos := wcampos+',"DescAcrescCondicao"=:xdescacresc';
       end;
    if XCondicao.TryGetValue('percdescacresc',wval) then
       begin
         if wcampos='' then
            wcampos := '"PercDescAcrescPadraoCondicao"=:xpercdescacresc'
         else
            wcampos := wcampos+',"PercDescAcrescPadraoCondicao"=:xpercdescacresc';
       end;
    if XCondicao.TryGetValue('idoperacao',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoOperacaoCondicao"=:xidoperacao'
         else
            wcampos := wcampos+',"CodigoOperacaoCondicao"=:xidoperacao';
       end;
    if XCondicao.TryGetValue('idplano',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoPlanoCondicao"=:xidplano'
         else
            wcampos := wcampos+',"CodigoPlanoCondicao"=:xidplano';
       end;
    if XCondicao.TryGetValue('idfiscal',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoFiscalCondicao"=:xidfiscal'
         else
            wcampos := wcampos+',"CodigoFiscalCondicao"=:xidfiscal';
       end;
    if XCondicao.TryGetValue('numpag',wval) then
       begin
         if wcampos='' then
            wcampos := '"NumeroPagamentosCondicao"=:xnumpag'
         else
            wcampos := wcampos+',"NumeroPagamentosCondicao"=:xnumpag';
       end;
    if XCondicao.TryGetValue('prazomedio',wval) then
       begin
         if wcampos='' then
            wcampos := '"PrazoMedioCondicao"=:xprazomedio'
         else
            wcampos := wcampos+',"PrazoMedioCondicao"=:xprazomedio';
       end;
    if XCondicao.TryGetValue('descfiscal',wval) then
       begin
         if wcampos='' then
            wcampos := '"DescricaoCodigoFiscal"=:xdescfiscal'
         else
            wcampos := wcampos+',"DescricaoCodigoFiscal"=:xdescfiscal';
       end;
    if XCondicao.TryGetValue('idformapagamento',wval) then
       begin
         if wcampos='' then
            wcampos := '"FormaPagamentoCondicao"=:xidformapagamento'
         else
            wcampos := wcampos+',"FormaPagamentoCondicao"=:xidformapagamento';
       end;
    if XCondicao.TryGetValue('idcobranca',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoCobrancaCondicao"=:xidcobranca'
         else
            wcampos := wcampos+',"CodigoCobrancaCondicao"=:xidcobranca';
       end;
    if XCondicao.TryGetValue('idoperacaoentrada',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoOpercaoEntradaCondicao"=:xidoperacaoentrada'
         else
            wcampos := wcampos+',"CodigoOpercaoEntradaCondicao"=:xidoperacaoentrada';
       end;
    if XCondicao.TryGetValue('idfiscalentrada',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoFiscalEntradaCondicao"=:xidfiscalentrada'
         else
            wcampos := wcampos+',"CodigoFiscalEntradaCondicao"=:xidfiscalentrada';
       end;
    if XCondicao.TryGetValue('ehentrada',wval) then
       begin
         if wcampos='' then
            wcampos := '"EhEntradaCondicao"=:xehentrada'
         else
            wcampos := wcampos+',"EhEntradaCondicao"=:xehentrada';
       end;
    if XCondicao.TryGetValue('ehsaida',wval) then
       begin
         if wcampos='' then
            wcampos := '"EhSaidaCondicao"=:xehsaida'
         else
            wcampos := wcampos+',"EhSaidaCondicao"=:xehsaida';
       end;
    if XCondicao.TryGetValue('ehativo',wval) then
       begin
         if wcampos='' then
            wcampos := '"EhAtivoCondicao"=:xehativo'
         else
            wcampos := wcampos+',"EhAtivoCondicao"=:xehativo';
       end;
    if XCondicao.TryGetValue('primeiraparcelaquitada',wval) then
       begin
         if wcampos='' then
            wcampos := '"PrimeiraParcelaQuitadaCondicao"=:xprimeiraparcelaquitada'
         else
            wcampos := wcampos+',"PrimeiraParcelaQuitadaCondicao"=:xprimeiraparcelaquitada';
       end;
    if XCondicao.TryGetValue('taxaparcela',wval) then
       begin
         if wcampos='' then
            wcampos := '"TaxaPorParcelaCondicao"=:xtaxaparcela'
         else
            wcampos := wcampos+',"TaxaPorParcelaCondicao"=:xtaxaparcela';
       end;
    if XCondicao.TryGetValue('taxa',wval) then
       begin
         if wcampos='' then
            wcampos := '"TaxaCondicao"=:xtaxa'
         else
            wcampos := wcampos+',"TaxaCondicao"=:xtaxa';
       end;
    if XCondicao.TryGetValue('percjuromes',wval) then
       begin
         if wcampos='' then
            wcampos := '"PercentualJuroMesCondicao"=:xpercjuromes'
         else
            wcampos := wcampos+',"PercentualJuroMesCondicao"=:xpercjuromes';
       end;
    if XCondicao.TryGetValue('nummaximoparcelas',wval) then
       begin
         if wcampos='' then
            wcampos := '"MaximoParcelasCondicao"=:xnummaximoparcelas'
         else
            wcampos := wcampos+',"MaximoParcelasCondicao"=:xnummaximoparcelas';
       end;
    if XCondicao.TryGetValue('diasintervalo',wval) then
       begin
         if wcampos='' then
            wcampos := '"DiasIntervaloParcelasCondicao"=:xdiasintervalo'
         else
            wcampos := wcampos+',"DiasIntervaloParcelasCondicao"=:xdiasintervalo';
       end;
    if XCondicao.TryGetValue('pedidobloqueado',wval) then
       begin
         if wcampos='' then
            wcampos := '"DefinirPedidoBloqueadoCondicao"=:xpedidobloqueado'
         else
            wcampos := wcampos+',"DefinirPedidoBloqueadoCondicao"=:xpedidobloqueado';
       end;
    if XCondicao.TryGetValue('condicaocomentrada',wval) then
       begin
         if wcampos='' then
            wcampos := '"CondicaoComEntradaCondicao"=:xcondicaocomentrada'
         else
            wcampos := wcampos+',"CondicaoComEntradaCondicao"=:xcondicaocomentrada';
       end;
    if XCondicao.TryGetValue('testalimitedisponivel',wval) then
       begin
         if wcampos='' then
            wcampos := '"TestaLimiteDisponivelCondicao"=:xtestalimitedisponivel'
         else
            wcampos := wcampos+',"TestaLimiteDisponivelCondicao"=:xtestalimitedisponivel';
       end;
    if XCondicao.TryGetValue('usanumeromaximoparcela',wval) then
       begin
         if wcampos='' then
            wcampos := '"UsaNumeroMaximoCondicao"=:xusanumeromaximoparcela'
         else
            wcampos := wcampos+',"UsaNumeroMaximoCondicao"=:xusanumeromaximoparcela';
       end;
    if XCondicao.TryGetValue('idfiscalentradast',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoFiscalEntradaSTCondicao"=:xidfiscalentradast'
         else
            wcampos := wcampos+',"CodigoFiscalEntradaSTCondicao"=:xidfiscalentradast';
       end;
    if XCondicao.TryGetValue('idfiscalst',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoFiscalSTCondicao"=:xidfiscalst'
         else
            wcampos := wcampos+',"CodigoFiscalSTCondicao"=:xidfiscalst';
       end;
    if XCondicao.TryGetValue('taxaretencao',wval) then
       begin
         if wcampos='' then
            wcampos := '"TaxaRetencaoCondicao"=:xtaxaretencao'
         else
            wcampos := wcampos+',"TaxaRetencaoCondicao"=:xtaxaretencao';
       end;
    if XCondicao.TryGetValue('observacao',wval) then
       begin
         if wcampos='' then
            wcampos := '"ObservacaoCondicao"=:xobservacao'
         else
            wcampos := wcampos+',"ObservacaoCondicao"=:xobservacao';
       end;
    if XCondicao.TryGetValue('parcelasquitadas',wval) then
       begin
         if wcampos='' then
            wcampos := '"TodasParcelasQuitadasCondicao"=:xparcelasquitadas'
         else
            wcampos := wcampos+',"TodasParcelasQuitadasCondicao"=:xparcelasquitadas';
       end;
    if XCondicao.TryGetValue('tipoprecotabela',wval) then
       begin
         if wcampos='' then
            wcampos := '"TipoPrecoTabelaCondicao"=:xtipoprecotabela'
         else
            wcampos := wcampos+',"TipoPrecoTabelaCondicao"=:xtipoprecotabela';
       end;
    if XCondicao.TryGetValue('tipocreditodevolucao',wval) then
       begin
         if wcampos='' then
            wcampos := '"TipoCreditoDevolucaoCondicao"=:xtipocreditodevolucao'
         else
            wcampos := wcampos+',"TipoCreditoDevolucaoCondicao"=:xtipocreditodevolucao';
       end;
    if XCondicao.TryGetValue('exigeidentificacao',wval) then
       begin
         if wcampos='' then
            wcampos := '"ExigeIdentificacaoClienteCondicao"=:xexigeidentificacao'
         else
            wcampos := wcampos+',"ExigeIdentificacaoClienteCondicao"=:xexigeidentificacao';
       end;
    if XCondicao.TryGetValue('idclassificacaofiscal',wval) then
       begin
         if wcampos='' then
            wcampos := '"ClassificacaoFiscalCondicao"=:xidclassificacaofiscal'
         else
            wcampos := wcampos+',"ClassificacaoFiscalCondicao"=:xidclassificacaofiscal';
       end;
    if XCondicao.TryGetValue('idportador',wval) then
       begin
         if wcampos='' then
            wcampos := '"PortadorPadraoCondicao"=:xidportador'
         else
            wcampos := wcampos+',"PortadorPadraoCondicao"=:xidportador';
       end;
    if XCondicao.TryGetValue('naocontabilizar',wval) then
       begin
         if wcampos='' then
            wcampos := '"NaoContabilizarCondicao"=:xnaocontabilizar'
         else
            wcampos := wcampos+',"NaoContabilizarCondicao"=:xnaocontabilizar';
       end;
    if XCondicao.TryGetValue('utilizarclienteespecial',wval) then
       begin
         if wcampos='' then
            wcampos := '"UtilizarClienteEspecialCondicao"=:xutilizarclienteespecial'
         else
            wcampos := wcampos+',"UtilizarClienteEspecialCondicao"=:xutilizarclienteespecial';
       end;
    if XCondicao.TryGetValue('liberaajusteparcelamento',wval) then
       begin
         if wcampos='' then
            wcampos := '"LiberaAjusteParcelamentoCondicao"=:xliberaajusteparcelamento'
         else
            wcampos := wcampos+',"LiberaAjusteParcelamentoCondicao"=:xliberaajusteparcelamento';
       end;
    if XCondicao.TryGetValue('liberaalterardesconto',wval) then
       begin
         if wcampos='' then
            wcampos := '"LiberaAlterarDescontoCondicao"=:xliberaalterardesconto'
         else
            wcampos := wcampos+',"LiberaAlterarDescontoCondicao"=:xliberaalterardesconto';
       end;
    if XCondicao.TryGetValue('bloqueiadocumentocobranca',wval) then
       begin
         if wcampos='' then
            wcampos := '"BloqueiaDocumentoCobrancaCondicao"=:xbloqueiadocumentocobranca'
         else
            wcampos := wcampos+',"BloqueiaDocumentoCobrancaCondicao"=:xbloqueiadocumentocobranca';
       end;
    if XCondicao.TryGetValue('valorparcelaminima',wval) then
       begin
         if wcampos='' then
            wcampos := '"ValorParcelaMinimaCondicao"=:xvalorparcelaminima'
         else
            wcampos := wcampos+',"ValorParcelaMinimaCondicao"=:xvalorparcelaminima';
       end;
    if XCondicao.TryGetValue('valorcompraminima',wval) then
       begin
         if wcampos='' then
            wcampos := '"ValorCompraMinimaCondicao"=:xvalorcompraminima'
         else
            wcampos := wcampos+',"ValorCompraMinimaCondicao"=:xvalorcompraminima';
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
           SQL.Add('Update "CondicaoPagamento" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoCondicao"=:xid ');
           ParamByName('xid').AsInteger      := XIdCondicao;
           if XCondicao.TryGetValue('descricao',wval) then
              ParamByName('xdescricao').AsString       := XCondicao.GetValue('descricao').Value;
           if XCondicao.TryGetValue('tipo',wval) then
              ParamByName('xtipo').AsString            := XCondicao.GetValue('tipo').Value;
           if XCondicao.TryGetValue('preco',wval) then
              ParamByName('xpreco').AsInteger          := strtointdef(XCondicao.GetValue('preco').Value,0);
           if XCondicao.TryGetValue('metodo',wval) then
              ParamByName('xmetodo').AsString          := XCondicao.GetValue('metodo').Value;
           if XCondicao.TryGetValue('emitecobranca',wval) then
              ParamByName('xemitecobranca').AsBoolean  := strtobooldef(XCondicao.GetValue('emitecobranca').Value,false);
           if XCondicao.TryGetValue('descacresc',wval) then
              ParamByName('xdescacresc').AsString      := XCondicao.GetValue('descacresc').Value;
           if XCondicao.TryGetValue('percdescacresc',wval) then
              ParamByName('xpercdescacresc').AsFloat   := strtofloatdef(XCondicao.GetValue('percdescacresc').Value,0);
           if XCondicao.TryGetValue('idoperacao',wval) then
              ParamByName('xidoperacao').AsInteger     := strtointdef(XCondicao.GetValue('idoperacao').Value,0);
           if XCondicao.TryGetValue('idplano',wval) then
              ParamByName('xdplano').AsInteger         := strtointdef(XCondicao.GetValue('idplano').Value,0);
           if XCondicao.TryGetValue('idfiscal',wval) then
              ParamByName('xidfiscal').AsInteger       := strtointdef(XCondicao.GetValue('idfiscal').Value,0);
           if XCondicao.TryGetValue('numpag',wval) then
              ParamByName('xnumpag').AsInteger         := strtointdef(XCondicao.GetValue('numpag').Value,0);
           if XCondicao.TryGetValue('prazomedio',wval) then
              ParamByName('xprazomedio').AsFloat       := strtofloatdef(XCondicao.GetValue('prazomedio').Value,0);
           if XCondicao.TryGetValue('descfiscal',wval) then
              ParamByName('xdescfiscal').AsString      := XCondicao.GetValue('descfiscal').Value;
           if XCondicao.TryGetValue('idformapagamento',wval) then
              ParamByName('xidformapagamento').AsInteger := strtointdef(XCondicao.GetValue('idformapagamento').Value,0);
           if XCondicao.TryGetValue('idcobranca',wval) then
              ParamByName('xidcobranca').AsInteger       := strtointdef(XCondicao.GetValue('idcobranca').Value,0);
           if XCondicao.TryGetValue('idoperacaoentrada',wval) then
              ParamByName('xidoperacaoentrada').AsInteger         := strtointdef(XCondicao.GetValue('idoperacaoentrada').Value,0);
           if XCondicao.TryGetValue('idfiscalentrada',wval) then
              ParamByName('xidfiscalentrada').AsInteger           := strtointdef(XCondicao.GetValue('idfiscalentrada').Value,0);
           if XCondicao.TryGetValue('ehentrada',wval) then
              ParamByName('xehentrada').AsBoolean                 := strtobooldef(XCondicao.GetValue('ehentrada').Value,false);
           if XCondicao.TryGetValue('ehsaida',wval) then
              ParamByName('xehsaida').AsBoolean                   := strtobooldef(XCondicao.GetValue('ehsaidas').Value,false);
           if XCondicao.TryGetValue('ehativo',wval) then
              ParamByName('xehativo').AsBoolean                   := strtobooldef(XCondicao.GetValue('ehativo').Value,false);
           if XCondicao.TryGetValue('primeiraparcelaquitada',wval) then
              ParamByName('xprimeiraparcelaquitada').AsBoolean    := strtobooldef(XCondicao.GetValue('primeiraparcelaquitada').Value,false);
           if XCondicao.TryGetValue('taxaparcela',wval) then
              ParamByName('xtaxaparcela').AsFloat                 := strtofloatdef(XCondicao.GetValue('taxaparcela').Value,0);
           if XCondicao.TryGetValue('taxa',wval) then
              ParamByName('xtaxa').AsFloat                        := strtofloatdef(XCondicao.GetValue('taxa').Value,0);
           if XCondicao.TryGetValue('percjuromes',wval) then
              ParamByName('xpercjuromes').AsFloat                 := strtofloatdef(XCondicao.GetValue('percjuromes').Value,0);
           if XCondicao.TryGetValue('nummaximoparcelas',wval) then
              ParamByName('xnummaximoparcelas').AsInteger         := strtointdef(XCondicao.GetValue('nummaximoparcelas').Value,0);
           if XCondicao.TryGetValue('diasintervalo',wval) then
              ParamByName('xdiasintervalo').AsInteger             := strtointdef(XCondicao.GetValue('diasintervalo').Value,0);
           if XCondicao.TryGetValue('pedidobloqueado',wval) then
              ParamByName('xpedidobloqueado').AsBoolean           := strtobooldef(XCondicao.GetValue('pedidobloqueado').Value,false);
           if XCondicao.TryGetValue('condicaocomentrada',wval) then
              ParamByName('xcondicaocomentrada').AsBoolean        := strtobooldef(XCondicao.GetValue('condicaocomentrada').Value,false);
           if XCondicao.TryGetValue('testalimitedisponivel',wval) then
              ParamByName('xtestalimitedisponivel').AsBoolean      := strtobooldef(XCondicao.GetValue('testalimitedisponivel').Value,false);
           if XCondicao.TryGetValue('usanumeromaximoparcela',wval) then
              ParamByName('xusanumeromaximoparcela').AsBoolean     := strtobooldef(XCondicao.GetValue('usanumeromaximoparcela').Value,false);
           if XCondicao.TryGetValue('idfiscalentradast',wval) then
              ParamByName('xidfiscalentradast').AsInteger          := strtointdef(XCondicao.GetValue('idfiscalentradast').Value,0);
           if XCondicao.TryGetValue('idfiscalst',wval) then
              ParamByName('xidfiscalst').AsInteger                 := strtointdef(XCondicao.GetValue('idfiscalst').Value,0);
           if XCondicao.TryGetValue('taxaretencao',wval) then
              ParamByName('xtaxaretencao').AsFloat                 := strtofloatdef(XCondicao.GetValue('taxaretencao').Value,0);
           if XCondicao.TryGetValue('observacao',wval) then
              ParamByName('xobservacao').AsString                  := XCondicao.GetValue('observacao').Value;
           if XCondicao.TryGetValue('parcelasquitadas',wval) then
              ParamByName('xparcelasquitadas').AsBoolean           := strtobooldef(XCondicao.GetValue('parcelasquitadas').Value,false);
           if XCondicao.TryGetValue('tipoprecotabela',wval) then
              ParamByName('xtipoprecotabela').AsString             := XCondicao.GetValue('tipoprecotabela').Value;
           if XCondicao.TryGetValue('tipocreditodevolucao',wval) then
              ParamByName('xtipocreditodevolucao').AsString        := XCondicao.GetValue('tipocreditodevolucao').Value;
           if XCondicao.TryGetValue('exigeidentificacao',wval) then
              ParamByName('xexigeidentificacao').AsBoolean         := strtobooldef(XCondicao.GetValue('exigeidentificacao').Value,false);
           if XCondicao.TryGetValue('idclassificacaofiscal',wval) then
              ParamByName('xidclassificacaofiscal').AsInteger      := strtointdef(XCondicao.GetValue('idclassificacaofiscal').Value,0);
           if XCondicao.TryGetValue('idportador',wval) then
              ParamByName('xidportador').AsInteger                 := strtointdef(XCondicao.GetValue('idportador').Value,0);
           if XCondicao.TryGetValue('naocontabilizar',wval) then
              ParamByName('xnaocontabilizar').AsBoolean            := strtobooldef(XCondicao.GetValue('naocontabilizar').Value,false);
           if XCondicao.TryGetValue('utilizarclienteespecial',wval) then
              ParamByName('xutilizarclienteespecial').AsBoolean    := strtobooldef(XCondicao.GetValue('utilizarclienteespecial').Value,false);
           if XCondicao.TryGetValue('liberaajusteparcelamento',wval) then
              ParamByName('xliberaajusteparcelamento').AsBoolean   := strtobooldef(XCondicao.GetValue('liberaajusteparcelamento').Value,false);
           if XCondicao.TryGetValue('liberaalterardesconto',wval) then
              ParamByName('xliberaalterardesconto').AsBoolean      := strtobooldef(XCondicao.GetValue('liberaalterardesconto').Value,false);
           if XCondicao.TryGetValue('bloqueiadocumentocobranca',wval) then
              ParamByName('xbloqueiadocumentocobranca').AsBoolean  := strtobooldef(XCondicao.GetValue('bloqueiadocumentocobranca').Value,false);
           if XCondicao.TryGetValue('valorparcelaminima',wval) then
              ParamByName('xvalorparcelaminima').AsFloat           := strtofloatdef(XCondicao.GetValue('valorparcelaminima').Value,0);
           if XCondicao.TryGetValue('valorcompraminima',wval) then
              ParamByName('xvalorcompraminima').AsFloat            := strtofloatdef(XCondicao.GetValue('valorcompraminima').Value,0);
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
              SQL.Add('select "CodigoInternoCondicao"    as id,');
              SQL.Add('       "DescricaoCondicao"        as descricao,');
              SQL.Add('       "TipoCondicao"             as tipo, ');
              SQL.Add('       "NumeroPagamentosCondicao" as numpag,');
              SQL.Add('       "CodigoCobrancaCondicao"   as idcobranca,');
              SQL.Add('       "MetodoCondicao"           as metodo,');
              SQL.Add('       "EmiteCobrancaCondicao"    as emitecobranca,');
              SQL.Add('       "PrecoPadraoCondicao"      as preco,');
              SQL.Add('       "DescAcrescCondicao"       as descacresc,');
              SQL.Add('       "PercDescAcrescPadraoCondicao" as percdescacresc,');
              SQL.Add('       "CodigoOperacaoCondicao"   as idoperacao,');
              SQL.Add('       "CodigoPlanoCondicao"      as idplano,');
              SQL.Add('       "CodigoFiscalCondicao"     as idfiscal,');
              SQL.Add('       "PrazoMedioCondicao"       as prazomedio,');
              SQL.Add('       "DescricaoCodigoFiscal"    as descfiscal,');
              SQL.Add('       "FormaPagamentoCondicao"   as idformapagamento,');
              SQL.Add('       "CodigoOpercaoEntradaCondicao"    as idoperacaoentrada,');
              SQL.Add('       "CodigoFiscalEntradaCondicao"     as idfiscalentrada,');
              SQL.Add('       "EhEntradaCondicao"               as ehentrada,');
              SQL.Add('       "EhSaidaCondicao"                 as ehsaida,');
              SQL.Add('       "EhAtivoCondicao"                 as ehativo,');
              SQL.Add('       "PrimeiraParcelaQuitadaCondicao"  as primeiraparcelaquitada,');
              SQL.Add('       "TaxaPorParcelaCondicao"          as taxaparcela,');
              SQL.Add('       "TaxaCondicao"                    as taxa,');
              SQL.Add('       "PercentualJuroMesCondicao"       as percjuromes,');
              SQL.Add('       "MaximoParcelasCondicao"          as nummaximoparcelas,');
              SQL.Add('       "DiasIntervaloParcelasCondicao"   as diasintervalo,');
              SQL.Add('       "DefinirPedidoBloqueadoCondicao"  as pedidobloqueado,');
              SQL.Add('       "CondicaoComEntradaCondicao"      as condicaocomentrada,');
              SQL.Add('       "TestaLimiteDisponivelCondicao"   as testalimitedisponivel,');
              SQL.Add('       "UsarNumeroMaximoParcelaCondicao" as usanumeromaximoparcela,');
              SQL.Add('       "CodigoFiscalEntradaSTCondicao"   as idfiscalentradast,');
              SQL.Add('       "CodigoFiscalSTCondicao"          as idfiscalst,');
              SQL.Add('       "TaxaRetencaoCondicao"            as taxaretencao,');
              SQL.Add('       "ObservacaoCondicao"              as observacao,');
              SQL.Add('       "TodasParcelasQuitadasCondicao"   as parcelasquitadas,');
              SQL.Add('       "TipoPrecoTabelaCondicao"         as tipoprecotabela,');
              SQL.Add('       "TipoCreditoDevolucaoCondicao"    as tipocreditodevolucao,');
              SQL.Add('       "ExigeIdentificacaoClienteCondicao" as exigeidentificacao,');
              SQL.Add('       "ClassificacaoFiscalCondicao"       as idclassificacaofiscal,');
              SQL.Add('       "PortadorPadraoCondicao"            as idportador,');
              SQL.Add('       "NaoContabilizarCondicao"           as naocontabilizar,');
              SQL.Add('       "UtilizarClienteEspecialCondicao"   as utilizarclienteespecial,');
              SQL.Add('       "LiberaAjusteParcelamentoCondicao"  as liberaajusteparcelamento,');
              SQL.Add('       "LiberaAlterarDescontoCondicao"     as liberaalterardesconto,');
              SQL.Add('       "BloqueiaDocumentoCobrancaCondicao" as bloqueiadocumentocobranca,');
              SQL.Add('       "ValorParcelaMinimaCondicao"        as valorparcelaminima,');
              SQL.Add('       "ValorCompraMinimaCondicao"         as valorcompraminima ');
              SQL.Add('from "CondicaoPagamento" ');
              SQL.Add('where "CodigoInternoCondicao" =:xid ');
              ParamByName('xid').AsInteger := XIdCondicao;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhuma Condição alterada');
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

function ApagaCondicao(XIdCondicao: integer): TJSONObject;
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
         SQL.Add('delete from "CondicaoPagamento" where "CodigoInternoCondicao"=:xid ');
         ParamByName('xid').AsInteger := XIdCondicao;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Condição excluída com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhuma Condição excluída');
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
