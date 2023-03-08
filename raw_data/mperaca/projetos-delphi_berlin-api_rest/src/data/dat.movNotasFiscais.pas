unit dat.movNotasFiscais;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function ApagaNotaFiscal(XId: integer): TJSONObject;
function RetornaNota(XId: integer): TJSONObject;
function RetornaListaNotas(const XQuery: TDictionary<string, string>; XEmpresa,XLimit,XOffset: integer): TJSONArray;
function RetornaTotalNotas(const XQuery: TDictionary<string, string>): TJSONObject;
function AlteraNotaFiscal(XIdNota: integer; XNota: TJSONObject): TJSONObject;
function VerificaRequisicao(XNota: TJSONObject): boolean;
function IncluiNotaFiscal(const XQuery: TDictionary<string, string>; XNota: TJSONObject; XIdEmpresa: integer): TJSONObject;
function RetornaIdNota(XFDConnection: TFDConnection): integer;
function RetornaNumeroPedido(XFDConnection: TFDConnection; XIdEmpresa: integer): integer;

implementation

uses prv.dataModuleConexao;

function RetornaNota(XId: integer): TJSONObject;
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
         SQL.Add('select "CodigoInternoNota"  as id,');
         SQL.Add('"CodigoEmpresaNota"         as idempresa,');
         SQL.Add('"CodigoFaturaNota"          as idfatura,');
         SQL.Add('"DataEmissaoNota"           as dataemissao,');
         SQL.Add('"DataSaidaNota"             as datasaida,');
         SQL.Add('"DataMovimentoNota"         as datamovimento,');
         SQL.Add('"PedidoClienteNota"         as pedido,');
         SQL.Add('"OrdemServicoNota"          as ordemservico,');
         SQL.Add('"NumeroImpressoraNota"      as numeroimpressora,');
         SQL.Add('"IntervencaoTecnicaNota"    as intervencaotecnica,');
         SQL.Add('"NumeroCupomNota"           as numerocupom,');
         SQL.Add('"NumeroDocumentoNota"       as numerodocumento,');
         SQL.Add('"NumeroDocumentoProvisorio" as numerodocumentoprovisorio,');
         SQL.Add('"NumeroDocumentoFinalNota"  as numerodocumentofinal,');
         SQL.Add('"SituacaoNota"              as situacao,');
         SQL.Add('"CodigoCondicaoNota"        as idcondicao,');
         SQL.Add('ts_retornacondicaodescricao("CodigoCondicaoNota") as xcondicao,');
         SQL.Add('ts_retornacondicaopreco("CodigoCondicaoNota") as xprecocondicao, ');
         SQL.Add('ts_retornacondicaocodigofiscal("CodigoCondicaoNota") as xidcfopcondicao,');
         SQL.Add('ts_retornacondicaocodigofiscalst("CodigoCondicaoNota") as xidcfopstcondicao,');
         SQL.Add('ts_retornafiscalcodigo(ts_retornacondicaocodigofiscal("CodigoCondicaoNota")) as xcfopcondicao,');
         SQL.Add('ts_retornafiscalcodigo(ts_retornacondicaocodigofiscalst("CodigoCondicaoNota")) as xcfopstcondicao,');
         SQL.Add('(case when ts_retornacondicaotipper("CodigoCondicaoNota")=''D'' then ts_retornacondicaopercentual("CodigoCondicaoNota") else 0 end) as xdesccondicao,');
         SQL.Add('(case when ts_retornacondicaotipper("CodigoCondicaoNota")=''A'' then ts_retornacondicaopercentual("CodigoCondicaoNota") else 0 end) as xacrescccondicao,');
         SQL.Add('"CodigoOperacaoEstoqueNota" as idoperacaoestoque,');
         SQL.Add('"CodigoMovimentoNota"       as idmovimento,');
         SQL.Add('"CodigoNaturezaNota"        as idnatureza,');
         SQL.Add('"CodigoFornecedorNota"      as idfornecedor,');
         SQL.Add('ts_retornapessoanome("CodigoFornecedorNota") as xfornecedor,');
         SQL.Add('"CodigoClienteNota"         as idcliente,');
         SQL.Add('ts_retornapessoanome("CodigoClienteNota") as xcliente,');
         SQL.Add('"CodigoRepresentanteNota"   as idvendedor,');
         SQL.Add('ts_retornapessoanome("CodigoRepresentanteNota") as xvendedor,');
         SQL.Add('"CodigoTransporteNota"      as idtransportador,');
         SQL.Add('ts_retornapessoanome("CodigoTransporteNota") as xtransportador,');
         SQL.Add('"CodigoRedespachoNota"      as idredespacho,');
         SQL.Add('ts_retornapessoanome("CodigoRedespachoNota") as xredespacho,');
         SQL.Add('"CodigoAlvoNota"            as idalvo,');
         SQL.Add('ts_retornapessoanome("CodigoAlvoNota") as xalvo,');
         SQL.Add('"SituacaoFreteNota"         as situacaofrete,');
         SQL.Add('"PlacaVeiculoNota"          as placaveiculo,');
         SQL.Add('"UFVeiculoNota"             as ufveiculo,');
         SQL.Add('"ViaTransporteNota"         as viatransporte,');
         SQL.Add('"ObservacoesNota"           as observacao,');
         SQL.Add('"TotalCustoNota"            as totalcusto,');
         SQL.Add('"TotalMercadorias"          as totalmercadorias,');
         SQL.Add('"TotalNota"                 as totalnota,');
         SQL.Add('"TotalLiquidoNota"          as totalliquido,');
         SQL.Add('"TotalIPINota"              as totalipi,');
         SQL.Add('"TotalICMSSubstituicaoNota" as totalicmsst,');
         SQL.Add('"BaseICMSNota"              as baseicms,');
         SQL.Add('"TotalICMSNota"             as totalicms,');
         SQL.Add('"TotalDespesasNota"         as totaldespesa,');
         SQL.Add('"TotalFretePFNota"          as totalfretepf,');
         SQL.Add('"TotalFretePDNota"          as totalfretepd,');
         SQL.Add('"PercentualICMSFreteNota"   as percentualicmsfrete,');
         SQL.Add('"PercentualDescontoNota"    as percentualdesconto,');
         SQL.Add('"TotalDescontosNota"        as totaldesconto,');
         SQL.Add('"TotalEmbalagemNota"        as totalembalagem,');
         SQL.Add('"PercetualIPIEmbalagemNota" as percentualipiembalagem,');
         SQL.Add('"PercentualICMSEmbalagemNota" as percentualicmsembalagem,');
         SQL.Add('"ValorPagoNota"             as valorpago,');
         SQL.Add('"CodigoFormaPagamentoNota"  as idformapagamento,');
         SQL.Add('"ValorTrocoNota"            as valortroco,');
         SQL.Add('"ModuloOrigemNota"          as moduloorigem,');
         SQL.Add('"CodigoDocumentoCobrancaNota" as iddocumentocobranca,');
         SQL.Add('ts_retornadocumentocobrancadescricao("CodigoDocumentoCobrancaNota") as xcobranca,');
         SQL.Add('"CodigoPortadorDocumentoNota" as idportador,');
         SQL.Add('ts_retornapessoanome("CodigoPortadorDocumentoNota") as xportador,');
         SQL.Add('"SituacaoCobrancaNota"      as situacaocobranca,');
         SQL.Add('"DataEmissaoCobrancaNota"   as dataemissaocobranca,');
         SQL.Add('"EspecieMercadoriaNota"     as especiemercadoria,');
         SQL.Add('"MarcaMercadoriaNota"       as marcamercadoria,');
         SQL.Add('"CodigoDestinatarioNota"    as iddestinatario,');
         SQL.Add('ts_retornapessoanome("CodigoDestinatarioNota") as xdestinatario,');
         SQL.Add('"CodigoRemetenteNota"       as idremetente,');
         SQL.Add('ts_retornapessoanome("CodigoRemetenteNota") as xremetente,');
         SQL.Add('"CodigoConsignatarioNota"   as idconsignatario,');
         SQL.Add('ts_retornapessoanome("CodigoConsignatarioNota") as xconsignatario,');
         SQL.Add('"CodigoCidadeOrigemNota"    as idcidadeorigem,');
         SQL.Add('"CodigoCidadeDestinoNota"   as idcidadedestino,');
         SQL.Add('"ReembolsoNota"             as reembolso,');
         SQL.Add('"NaturezaCargaNota"         as naturezacarga,');
         SQL.Add('"QtdeMercadoriaNota"        as quantidademercadoria,');
         SQL.Add('"ValorMercadoriaNota"       as valormercadoria,');
         SQL.Add('"PesoMercadoriaNota"        as pesomercadoria,');
         SQL.Add('"NotaFiscalOrigemNota"      as notafiscalorigem,');
         SQL.Add('"FretePesoVolumeNota"       as fretepesovolume,');
         SQL.Add('"QtdeFretePesoVolumeNota"   as quantidadefretepesovolume,');
         SQL.Add('"UnitarioFretePesoVolumeNota" as unitariofretepesovolume,');
         SQL.Add('"TotalFretePesoVolumeNota"  as totalfretepesovolume,');
         SQL.Add('"FreteValorNota"            as fretevalor,');
         SQL.Add('"QtdeFreteValorNota"        as quantidadefretevalor,');
         SQL.Add('"UnitarioFreteValorNota"    as unitariofretevalor,');
         SQL.Add('"TotalFreteValorNota"       as totalfretevalor,');
         SQL.Add('"SecCatDespNota"            as seccatdesp,');
         SQL.Add('"QtdeSecCatDespNota"        as quantidadeseccatdesp,');
         SQL.Add('"UnitarioSecCatDespNota"    as unitarioseccatdesp,');
         SQL.Add('"TotalSecCatDespNota"       as totalseccatdesp,');
         SQL.Add('"OutrosNota"                as outros,');
         SQL.Add('"QtdeOutrosNota"            as quantidadeoutros,');
         SQL.Add('"UnitarioOutrosNota"        as unitariooutros,');
         SQL.Add('"TotalOutrosNota"           as totaloutros,');
         SQL.Add('"PercentualICMSNota"        as percentualicms,');
         SQL.Add('"TipoTributacaoNota"        as tipotributacao,');
         SQL.Add('"HoraSaidaNota"             as horasaida,');
         SQL.Add('"BaseIPINota"               as baseipi,');
         SQL.Add('"IsentosICMNota"            as isentosicms,');
         SQL.Add('"OutrosICMNota"             as outrosicms,');
         SQL.Add('"IsentosIPINota"            as isentosipi,');
         SQL.Add('"OutrosIPINota"             as outrosipi,');
         SQL.Add('"ValorTrocoTicket"          as valortroco,');
         SQL.Add('"NumeroOrcamentoNota"       as idorcamento,');
         SQL.Add('"DescricaoServico"          as descricaoservico,');
         SQL.Add('"ValorServico"              as valorservico,');
         SQL.Add('"BaseCalculoISSQN"          as basecalculoissqn,');
         SQL.Add('"PercentualCalculoISSQN"    as percentualcalculoissqn,');
         SQL.Add('"ValorISSQN"                as valorissqn,');
         SQL.Add('"ContraPartidaNota"         as idcontrapartida,');
         SQL.Add('"ModeloDocumentoFiscal"     as modelodocumentofiscal,');
         SQL.Add('"EspecieDocumentoNota"      as idespecie,');
         SQL.Add('ts_retornavalidacaoespecieserie("EspecieDocumentoNota") as xespecie,');
         SQL.Add('"SerieSubSerieNota"         as idseriesubserie,');
         SQL.Add('ts_retornavalidacaoespecieserie("SerieSubSerieNota") as xserie,');
         SQL.Add('"TurnoPostoNota"            as turnoposto,');
         SQL.Add('"NumeroCaixaNota"           as numerocaixa,');
         SQL.Add('"SituacaoPagtoNota"         as situacaopagamento,');
         SQL.Add('"UsuarioNota"               as idusuario,');
         SQL.Add('"NotaTransferencia"         as idnotatransferencia,');
         SQL.Add('"QtdeVolumeNota"            as quantidadevolume,');
         SQL.Add('"PesoLiquidoNota"           as pesoliquido,');
         SQL.Add('"PesoBrutoNota"             as pesobruto,');
         SQL.Add('"InformacaoComplementarNota" as informacaocomplementar,');
         SQL.Add('"NotaDevolvida"             as ehnotadevolvida,');
         SQL.Add('"EncargoFinanceiroNota"     as encargofinanceiro,');
         SQL.Add('"NumeroParcelasNota"        as numeroparcelas,');
         SQL.Add('"ValorEntradaNota"          as valorentrada,');
         SQL.Add('"BaseICMSSubstituicaoNota"  as baseicmsst,');
         SQL.Add('"DataLancamentoNota"        as datalancamento,');
         SQL.Add('"DataUltimaAlteracao"       as dataultimaalteracao,');
         SQL.Add('"OrigemUltimaAlteracao"     as origemultimaalteracao,');
         SQL.Add('"TotalDespesaAdicionalNota" as totaldespesaadicional,');
         SQL.Add('"CodigoFiscalServicoNota"   as idcodigofiscal,');
         SQL.Add('"TotalCreditoNota"          as totalcredito,');
         SQL.Add('"TotalCreditoDevolucaoNota" as totalcreditodevolucao,');
         SQL.Add('"TotalCreditoFidelidadeNota" as totalcreditofidelidade,');
         SQL.Add('"TotalMercadoriasSubstituicaoNota" as totalmercadoriasst,');
         SQL.Add('"CodigoNotaMatrizNota"      as idnotamatriz,');
         SQL.Add('"ImportadoSintegraNota"     as ehimportadosintegra,');
         SQL.Add('"ArquivoSintegraNota"       as arquivosintegra,');
         SQL.Add('"TotalImpostoRetidoNota"    as totalimpostoretido,');
         SQL.Add('"IdNFeNota"                 as chavenfe,');
         SQL.Add('"DataPrevisaoConsignadoNota" as dataprevisaoconsignado,');
         SQL.Add('"DataRetornoConsignadoNota" as dataretornoconsignado,');
         SQL.Add('"PercentualComissaoConsignadoNota" as percentualcomissaoconsignado,');
         SQL.Add('"ValorComissaoConsignadoNota" as valorcomissaoconsignado,');
         SQL.Add('"TotalPISNota"              as totalpis,');
         SQL.Add('"TotalCOFINSNota"           as totalcofins,');
         SQL.Add('"ChaveAcessoNFeNota"        as chaveacessonfe,');
         SQL.Add('"CodigoPessoaIndicadaNota"  as idpessoaindicada,');
         SQL.Add('"NotaFaturada"              as idnotafaturada,');
         SQL.Add('"ClassificacaoReceitaDespesaNota" as idclassificacaoreceitadespesa,');
         SQL.Add('ts_retornaclassificacaodescricao("ClassificacaoReceitaDespesaNota") as xclassificacao,');
         SQL.Add('"EhExcessaoContabilidadeNota" as ehexcessaocontabilidade,');
         SQL.Add('"NumeroRPSNotaServico"      as numerorpsservico,');
         SQL.Add('"StatusNotaServico"         as statusnotaservico,');
         SQL.Add('"ValorDeducoesNotaServico"  as valordeducoesservico,');
         SQL.Add('"ValorINSSNotaServico"      as valorinssservico,');
         SQL.Add('"ValorIRNotaServico"        as valorirservico,');
         SQL.Add('"ValorCSLLNotaServico"      as valorcsllservico,');
         SQL.Add('"ISSRetidoNotaServico"      as valorissretidoservico,');
         SQL.Add('"OutrasRetencoesNotaServico" as valoroutrasretencoesservico,');
         SQL.Add('"DescontoIncondicionadoNotaServico" as descontoincondicionadoservico,');
         SQL.Add('"DescontoCondicionadoNotaServico" as descontocondicionadoservico,');
         SQL.Add('"CodigoCNAENotaServico"     as codigocnaeservico,');
         SQL.Add('"CodigoTributacaoMunicipioNotaServico" as codigotributacaomunicipioservico,');
         SQL.Add('"ValorISSQNRetido"          as valorissqnretidoservico,');
         SQL.Add('"SerieNotaServico"          as serienotaservico,');
         SQL.Add('"TipoNotaServico"           as tiponotaservico,');
         SQL.Add('"CodigoItemListaNotaServico" as iditemlistaservico,');
         SQL.Add('"ProtocoloNFSeNota"         as protocolonfse,');
         SQL.Add('"CodigoVerificacaoNFSeNota" as codigoverificacaonfse,');
         SQL.Add('"NFeReferenciadaNota"       as nfereferenciada,');
         SQL.Add('"CodigoInternoNotaReferenciadaNota" as idnotareferenciada,');
         SQL.Add('"JustificativaEstornoNota"  as justificativaestorno,');
         SQL.Add('"LogMovimentacaoNota"       as logmovimentacao,');
         SQL.Add('"CpfCnpjAdquirenteNota"     as cpfcnpjadquirente,');
         SQL.Add('"TotalDescontoProdutoNota"  as totaldescontoproduto,');
         SQL.Add('"OrigemNotaEntradaNota"     as origemnotaentrada,');
         SQL.Add('"UtilizarSaldoDevolucaoNota" as ehutilizarsaldodevolucao,');
         SQL.Add('"UtilizarSaldoFidelidadeNota" as ehutilizarsaldofidelidade,');
         SQL.Add('"CupomReferenciadoNota"     as cupomreferenciado,');
         SQL.Add('"ECFReferenciadaNota"       as ecfreferenciada,');
         SQL.Add('"FormaEmissaoNota"          as formaemisao,');
         SQL.Add('"StatusAtualizacaoNota"     as statusatualizacao,');
         SQL.Add('"VendaPresencialNota"       as ehvendapresencial,');
         SQL.Add('"NotaImportadaNota"         as ehnotaimportada,');
         SQL.Add('"DistribuiNumerarioCaixaNota" as ehdistribuinumerariocaixa,');
         SQL.Add('"SituacaoContingenciaNota"  as situacaocontingencia,');
         SQL.Add('"OrdemCompraClienteNota"    as ordemcompracliente,');
         SQL.Add('"FinalidadeNota"            as finalidade,');
         SQL.Add('"BaseICMSSubstituicaoRetidaNota" as baseicmsstretida,');
         SQL.Add('"UtilizaBonusPromocionalNota" as ehutilizarbonuspromocional ');
         SQL.Add('from "NotaFiscal" where "CodigoInternoNota"=:xid  ');
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
        wret.AddPair('description','Nota Fiscal não encontrada');
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

function ApagaNotaFiscal(XId: integer): TJSONObject;
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
         SQL.Add('delete from "NotaFiscal" ');
         SQL.Add('where "CodigoInternoNota"=:xid ');
         ParamByName('xid').AsInteger := XId;
         ExecSQL;
         EnableControls;
       end;

   if wquery.RowsAffected > 0 then
      begin
        wret := TJSONObject.Create;
        wret.AddPair('status','200');
        wret.AddPair('description','Nota Fiscal excluída com sucesso');
        wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
      end
   else
      begin
        wret := TJSONObject.Create;
        wret.AddPair('status','500');
        wret.AddPair('description','Nenhuma nota fiscal excluída');
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
    end;
  end;
  wconexao.EncerraConexaoDB;
  Result := wret;
end;


function RetornaListaNotas(const XQuery: TDictionary<string, string>; XEmpresa,XLimit,XOffset: integer): TJSONArray;
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
         SQL.Add('select "CodigoInternoNota"  as id,');
         SQL.Add('"CodigoEmpresaNota"         as idempresa,');
         SQL.Add('"CodigoFaturaNota"          as idfatura,');
         SQL.Add('"DataEmissaoNota"           as dataemissao,');
         SQL.Add('"DataSaidaNota"             as datasaida,');
         SQL.Add('"DataMovimentoNota"         as datamovimento,');
         SQL.Add('"PedidoClienteNota"         as pedido,');
         SQL.Add('"OrdemServicoNota"          as ordemservico,');
         SQL.Add('"NumeroImpressoraNota"      as numeroimpressora,');
         SQL.Add('"IntervencaoTecnicaNota"    as intervencaotecnica,');
         SQL.Add('"NumeroCupomNota"           as numerocupom,');
         SQL.Add('"NumeroDocumentoNota"       as numerodocumento,');
         SQL.Add('"NumeroDocumentoProvisorio" as numerodocumentoprovisorio,');
         SQL.Add('"NumeroDocumentoFinalNota"  as numerodocumentofinal,');
         SQL.Add('"SituacaoNota"              as situacao,');
         SQL.Add('"CodigoCondicaoNota"        as idcondicao,');
         SQL.Add('ts_retornacondicaodescricao("CodigoCondicaoNota") as xcondicao,');
         SQL.Add('ts_retornacondicaopreco("CodigoCondicaoNota") as xprecocondicao, ');
         SQL.Add('ts_retornacondicaocodigofiscal("CodigoCondicaoNota") as xidcfopcondicao,');
         SQL.Add('ts_retornacondicaocodigofiscalst("CodigoCondicaoNota") as xidcfopstcondicao,');
         SQL.Add('ts_retornafiscalcodigo(ts_retornacondicaocodigofiscal("CodigoCondicaoNota")) as xcfopcondicao,');
         SQL.Add('ts_retornafiscalcodigo(ts_retornacondicaocodigofiscalst("CodigoCondicaoNota")) as xcfopstcondicao,');
         SQL.Add('(case when ts_retornacondicaotipper("CodigoCondicaoNota")=''D'' then ts_retornacondicaopercentual("CodigoCondicaoNota") else 0 end) as xdesccondicao,');
         SQL.Add('(case when ts_retornacondicaotipper("CodigoCondicaoNota")=''A'' then ts_retornacondicaopercentual("CodigoCondicaoNota") else 0 end) as xacrescccondicao,');
         SQL.Add('"CodigoOperacaoEstoqueNota" as idoperacaoestoque,');
         SQL.Add('"CodigoMovimentoNota"       as idmovimento,');
         SQL.Add('"CodigoNaturezaNota"        as idnatureza,');
         SQL.Add('"CodigoFornecedorNota"      as idfornecedor,');
         SQL.Add('ts_retornapessoanome("CodigoFornecedorNota") as xfornecedor,');
         SQL.Add('"CodigoClienteNota"         as idcliente,');
         SQL.Add('ts_retornapessoanome("CodigoClienteNota") as xcliente,');
         SQL.Add('"CodigoRepresentanteNota"   as idvendedor,');
         SQL.Add('ts_retornapessoanome("CodigoRepresentanteNota") as xvendedor,');
         SQL.Add('"CodigoTransporteNota"      as idtransportador,');
         SQL.Add('ts_retornapessoanome("CodigoTransporteNota") as xtransportador,');
         SQL.Add('"CodigoRedespachoNota"      as idredespacho,');
         SQL.Add('ts_retornapessoanome("CodigoRedespachoNota") as xredespacho,');
         SQL.Add('"CodigoAlvoNota"            as idalvo,');
         SQL.Add('ts_retornapessoanome("CodigoAlvoNota") as xalvo,');
         SQL.Add('"SituacaoFreteNota"         as situacaofrete,');
         SQL.Add('"PlacaVeiculoNota"          as placaveiculo,');
         SQL.Add('"UFVeiculoNota"             as ufveiculo,');
         SQL.Add('"ViaTransporteNota"         as viatransporte,');
         SQL.Add('"ObservacoesNota"           as observacao,');
         SQL.Add('"TotalCustoNota"            as totalcusto,');
         SQL.Add('"TotalMercadorias"          as totalmercadorias,');
         SQL.Add('"TotalNota"                 as totalnota,');
         SQL.Add('"TotalLiquidoNota"          as totalliquido,');
         SQL.Add('"TotalIPINota"              as totalipi,');
         SQL.Add('"TotalICMSSubstituicaoNota" as totalicmsst,');
         SQL.Add('"BaseICMSNota"              as baseicms,');
         SQL.Add('"TotalICMSNota"             as totalicms,');
         SQL.Add('"TotalDespesasNota"         as totaldespesa,');
         SQL.Add('"TotalFretePFNota"          as totalfretepf,');
         SQL.Add('"TotalFretePDNota"          as totalfretepd,');
         SQL.Add('"PercentualICMSFreteNota"   as percentualicmsfrete,');
         SQL.Add('"PercentualDescontoNota"    as percentualdesconto,');
         SQL.Add('"TotalDescontosNota"        as totaldesconto,');
         SQL.Add('"TotalEmbalagemNota"        as totalembalagem,');
         SQL.Add('"PercetualIPIEmbalagemNota" as percentualipiembalagem,');
         SQL.Add('"PercentualICMSEmbalagemNota" as percentualicmsembalagem,');
         SQL.Add('"ValorPagoNota"             as valorpago,');
         SQL.Add('"CodigoFormaPagamentoNota"  as idformapagamento,');
         SQL.Add('"ValorTrocoNota"            as valortroco,');
         SQL.Add('"ModuloOrigemNota"          as moduloorigem,');
         SQL.Add('"CodigoDocumentoCobrancaNota" as iddocumentocobranca,');
         SQL.Add('ts_retornadocumentocobrancadescricao("CodigoDocumentoCobrancaNota") as xcobranca,');
         SQL.Add('"CodigoPortadorDocumentoNota" as idportador,');
         SQL.Add('ts_retornapessoanome("CodigoPortadorDocumentoNota") as xportador,');
         SQL.Add('"SituacaoCobrancaNota"      as situacaocobranca,');
         SQL.Add('"DataEmissaoCobrancaNota"   as dataemissaocobranca,');
         SQL.Add('"EspecieMercadoriaNota"     as especiemercadoria,');
         SQL.Add('"MarcaMercadoriaNota"       as marcamercadoria,');
         SQL.Add('"CodigoDestinatarioNota"    as iddestinatario,');
         SQL.Add('ts_retornapessoanome("CodigoDestinatarioNota") as xdestinatario,');
         SQL.Add('"CodigoRemetenteNota"       as idremetente,');
         SQL.Add('ts_retornapessoanome("CodigoRemetenteNota") as xremetente,');
         SQL.Add('"CodigoConsignatarioNota"   as idconsignatario,');
         SQL.Add('ts_retornapessoanome("CodigoConsignatarioNota") as xconsignatario,');
         SQL.Add('"CodigoCidadeOrigemNota"    as idcidadeorigem,');
         SQL.Add('"CodigoCidadeDestinoNota"   as idcidadedestino,');
         SQL.Add('"ReembolsoNota"             as reembolso,');
         SQL.Add('"NaturezaCargaNota"         as naturezacarga,');
         SQL.Add('"QtdeMercadoriaNota"        as quantidademercadoria,');
         SQL.Add('"ValorMercadoriaNota"       as valormercadoria,');
         SQL.Add('"PesoMercadoriaNota"        as pesomercadoria,');
         SQL.Add('"NotaFiscalOrigemNota"      as notafiscalorigem,');
         SQL.Add('"FretePesoVolumeNota"       as fretepesovolume,');
         SQL.Add('"QtdeFretePesoVolumeNota"   as quantidadefretepesovolume,');
         SQL.Add('"UnitarioFretePesoVolumeNota" as unitariofretepesovolume,');
         SQL.Add('"TotalFretePesoVolumeNota"  as totalfretepesovolume,');
         SQL.Add('"FreteValorNota"            as fretevalor,');
         SQL.Add('"QtdeFreteValorNota"        as quantidadefretevalor,');
         SQL.Add('"UnitarioFreteValorNota"    as unitariofretevalor,');
         SQL.Add('"TotalFreteValorNota"       as totalfretevalor,');
         SQL.Add('"SecCatDespNota"            as seccatdesp,');
         SQL.Add('"QtdeSecCatDespNota"        as quantidadeseccatdesp,');
         SQL.Add('"UnitarioSecCatDespNota"    as unitarioseccatdesp,');
         SQL.Add('"TotalSecCatDespNota"       as totalseccatdesp,');
         SQL.Add('"OutrosNota"                as outros,');
         SQL.Add('"QtdeOutrosNota"            as quantidadeoutros,');
         SQL.Add('"UnitarioOutrosNota"        as unitariooutros,');
         SQL.Add('"TotalOutrosNota"           as totaloutros,');
         SQL.Add('"PercentualICMSNota"        as percentualicms,');
         SQL.Add('"TipoTributacaoNota"        as tipotributacao,');
         SQL.Add('"HoraSaidaNota"             as horasaida,');
         SQL.Add('"BaseIPINota"               as baseipi,');
         SQL.Add('"IsentosICMNota"            as isentosicms,');
         SQL.Add('"OutrosICMNota"             as outrosicms,');
         SQL.Add('"IsentosIPINota"            as isentosipi,');
         SQL.Add('"OutrosIPINota"             as outrosipi,');
         SQL.Add('"ValorTrocoTicket"          as valortroco,');
         SQL.Add('"NumeroOrcamentoNota"       as idorcamento,');
         SQL.Add('"DescricaoServico"          as descricaoservico,');
         SQL.Add('"ValorServico"              as valorservico,');
         SQL.Add('"BaseCalculoISSQN"          as basecalculoissqn,');
         SQL.Add('"PercentualCalculoISSQN"    as percentualcalculoissqn,');
         SQL.Add('"ValorISSQN"                as valorissqn,');
         SQL.Add('"ContraPartidaNota"         as idcontrapartida,');
         SQL.Add('"ModeloDocumentoFiscal"     as modelodocumentofiscal,');
         SQL.Add('"EspecieDocumentoNota"      as idespecie,');
         SQL.Add('"SerieSubSerieNota"         as idseriesubserie,');
         SQL.Add('"TurnoPostoNota"            as turnoposto,');
         SQL.Add('"NumeroCaixaNota"           as numerocaixa,');
         SQL.Add('"SituacaoPagtoNota"         as situacaopagamento,');
         SQL.Add('"UsuarioNota"               as idusuario,');
         SQL.Add('"NotaTransferencia"         as idnotatransferencia,');
         SQL.Add('"QtdeVolumeNota"            as quantidadevolume,');
         SQL.Add('"PesoLiquidoNota"           as pesoliquido,');
         SQL.Add('"PesoBrutoNota"             as pesobruto,');
         SQL.Add('"InformacaoComplementarNota" as informacaocomplementar,');
         SQL.Add('"NotaDevolvida"             as ehnotadevolvida,');
         SQL.Add('"EncargoFinanceiroNota"     as encargofinanceiro,');
         SQL.Add('"NumeroParcelasNota"        as numeroparcelas,');
         SQL.Add('"ValorEntradaNota"          as valorentrada,');
         SQL.Add('"BaseICMSSubstituicaoNota"  as baseicmsst,');
         SQL.Add('"DataLancamentoNota"        as datalancamento,');
         SQL.Add('"DataUltimaAlteracao"       as dataultimaalteracao,');
         SQL.Add('"OrigemUltimaAlteracao"     as origemultimaalteracao,');
         SQL.Add('"TotalDespesaAdicionalNota" as totaldespesaadicional,');
         SQL.Add('"CodigoFiscalServicoNota"   as idcodigofiscal,');
         SQL.Add('"TotalCreditoNota"          as totalcredito,');
         SQL.Add('"TotalCreditoDevolucaoNota" as totalcreditodevolucao,');
         SQL.Add('"TotalCreditoFidelidadeNota" as totalcreditofidelidade,');
         SQL.Add('"TotalMercadoriasSubstituicaoNota" as totalmercadoriasst,');
         SQL.Add('"CodigoNotaMatrizNota"      as idnotamatriz,');
         SQL.Add('"ImportadoSintegraNota"     as ehimportadosintegra,');
         SQL.Add('"ArquivoSintegraNota"       as arquivosintegra,');
         SQL.Add('"TotalImpostoRetidoNota"    as totalimpostoretido,');
         SQL.Add('"IdNFeNota"                 as chavenfe,');
         SQL.Add('"DataPrevisaoConsignadoNota" as dataprevisaoconsignado,');
         SQL.Add('"DataRetornoConsignadoNota" as dataretornoconsignado,');
         SQL.Add('"PercentualComissaoConsignadoNota" as percentualcomissaoconsignado,');
         SQL.Add('"ValorComissaoConsignadoNota" as valorcomissaoconsignado,');
         SQL.Add('"TotalPISNota"              as totalpis,');
         SQL.Add('"TotalCOFINSNota"           as totalcofins,');
         SQL.Add('"ChaveAcessoNFeNota"        as chaveacessonfe,');
         SQL.Add('"CodigoPessoaIndicadaNota"  as idpessoaindicada,');
         SQL.Add('"NotaFaturada"              as idnotafaturada,');
         SQL.Add('"ClassificacaoReceitaDespesaNota" as idclassificacaoreceitadespesa,');
         SQL.Add('ts_retornaclassificacaodescricao("ClassificacaoReceitaDespesaNota") as xclassificacao,');
         SQL.Add('"EhExcessaoContabilidadeNota" as ehexcessaocontabilidade,');
         SQL.Add('"NumeroRPSNotaServico"      as numerorpsservico,');
         SQL.Add('"StatusNotaServico"         as statusnotaservico,');
         SQL.Add('"ValorDeducoesNotaServico"  as valordeducoesservico,');
         SQL.Add('"ValorINSSNotaServico"      as valorinssservico,');
         SQL.Add('"ValorIRNotaServico"        as valorirservico,');
         SQL.Add('"ValorCSLLNotaServico"      as valorcsllservico,');
         SQL.Add('"ISSRetidoNotaServico"      as valorissretidoservico,');
         SQL.Add('"OutrasRetencoesNotaServico" as valoroutrasretencoesservico,');
         SQL.Add('"DescontoIncondicionadoNotaServico" as descontoincondicionadoservico,');
         SQL.Add('"DescontoCondicionadoNotaServico" as descontocondicionadoservico,');
         SQL.Add('"CodigoCNAENotaServico"     as codigocnaeservico,');
         SQL.Add('"CodigoTributacaoMunicipioNotaServico" as codigotributacaomunicipioservico,');
         SQL.Add('"ValorISSQNRetido"          as valorissqnretidoservico,');
         SQL.Add('"SerieNotaServico"          as serienotaservico,');
         SQL.Add('"TipoNotaServico"           as tiponotaservico,');
         SQL.Add('"CodigoItemListaNotaServico" as iditemlistaservico,');
         SQL.Add('"ProtocoloNFSeNota"         as protocolonfse,');
         SQL.Add('"CodigoVerificacaoNFSeNota" as codigoverificacaonfse,');
         SQL.Add('"NFeReferenciadaNota"       as nfereferenciada,');
         SQL.Add('"CodigoInternoNotaReferenciadaNota" as idnotareferenciada,');
         SQL.Add('"JustificativaEstornoNota"  as justificativaestorno,');
         SQL.Add('"LogMovimentacaoNota"       as logmovimentacao,');
         SQL.Add('"CpfCnpjAdquirenteNota"     as cpfcnpjadquirente,');
         SQL.Add('"TotalDescontoProdutoNota"  as totaldescontoproduto,');
         SQL.Add('"OrigemNotaEntradaNota"     as origemnotaentrada,');
         SQL.Add('"UtilizarSaldoDevolucaoNota" as ehutilizarsaldodevolucao,');
         SQL.Add('"UtilizarSaldoFidelidadeNota" as ehutilizarsaldofidelidade,');
         SQL.Add('"CupomReferenciadoNota"     as cupomreferenciado,');
         SQL.Add('"ECFReferenciadaNota"       as ecfreferenciada,');
         SQL.Add('"FormaEmissaoNota"          as formaemisao,');
         SQL.Add('"StatusAtualizacaoNota"     as statusatualizacao,');
         SQL.Add('"VendaPresencialNota"       as ehvendapresencial,');
         SQL.Add('"NotaImportadaNota"         as ehnotaimportada,');
         SQL.Add('"DistribuiNumerarioCaixaNota" as ehdistribuinumerariocaixa,');
         SQL.Add('"SituacaoContingenciaNota"  as situacaocontingencia,');
         SQL.Add('"OrdemCompraClienteNota"    as ordemcompracliente,');
         SQL.Add('"FinalidadeNota"            as finalidade,');
         SQL.Add('"BaseICMSSubstituicaoRetidaNota" as baseicmsstretida,');
         SQL.Add('"UtilizaBonusPromocionalNota" as ehutilizarbonuspromocional ');
         SQL.Add('from "NotaFiscal" where "CodigoEmpresaNota"=:xempresa ');
         ParamByName('xempresa').AsInteger := wconexao.FIdEmpresa;
         if XQuery.ContainsKey('dataemissao') then // filtro por data emissão
            begin
              SQL.Add('and "DataEmissaoNota"=:xemissao ');
              ParamByName('xemissao').AsDate := strtodate(XQuery.Items['dataemissao']);
            end;
         if XQuery.ContainsKey('pedido') then // filtro por número
            begin
              SQL.Add('and "PedidoClienteNota"=:xpedido ');
              ParamByName('xpedido').AsInteger := strtoint(XQuery.Items['pedido']);
            end;
         if XQuery.ContainsKey('numerodocumento') then // filtro por número
            begin
              SQL.Add('and "NumeroDocumentoNota" like :xnumerodocumento ');
              ParamByName('xnumerodocumento').AsString := XQuery.Items['numerodocumento']+'%';
            end;
         if XQuery.ContainsKey('cliente') then // filtro por cliente
            begin
              SQL.Add('and lower(ts_retornapessoanome("CodigoClienteNota")) like lower(:xcliente) ');
              ParamByName('xcliente').AsString := XQuery.Items['cliente']+'%';
            end;
         if XQuery.ContainsKey('vendedor') then // filtro por vendedor
            begin
              SQL.Add('and lower(ts_retornapessoanome("CodigoRepresentanteNota")) like lower(:xvendedor) ');
              ParamByName('xvendedor').AsString := XQuery.Items['vendedor']+'%';
            end;
         if XQuery.ContainsKey('condicao') then // filtro por condicao
            begin
              SQL.Add('and lower(ts_retornacondicaodescricao("CodigoCondicaoNota")) like lower(:xcondicao) ');
              ParamByName('xcondicao').AsString := XQuery.Items['condicao']+'%';
            end;
         if XQuery.ContainsKey('cobranca') then // filtro por cobrança
            begin
              SQL.Add('and lower(ts_retornadocumentocobrancadescricao("CodigoDocumentoCobrancaNota")) like lower(:xcobranca) ');
              ParamByName('xcobranca').AsString := XQuery.Items['cobranca']+'%';
            end;
         if XQuery.ContainsKey('order') then // ordenação
            begin
              wordem := 'order by '+XQuery.Items['order']+' ';
              if XQuery.ContainsKey('dir') then // direção
                 wordem := wordem +XQuery.Items['dir'];
              SQL.Add(wordem);
            end
         else
            SQL.Add('order by "PedidoClienteNota" ');
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
         wobj.AddPair('description','Nenhuma Nota Fiscal encontrada');
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

function AlteraNotaFiscal(XIdNota: integer; XNota: TJSONObject): TJSONObject;
var wquery: TFDMemTable;
    wqueryUpdate,wquerySelect: TFDQuery;
    wret: TJSONObject;
    wconexao: TProviderDataModuleConexao;
    wcampos,wval: string;
    wnum: integer;
    wbloqueado: boolean;
begin
  try
    wcampos      := '';
    wconexao     := TProviderDataModuleConexao.Create(nil);
    wqueryUpdate := TFDQuery.Create(nil);

    //define quais campos serão alterados
    if XNota.TryGetValue('idcliente',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoClienteNota"=:xidcliente'
         else
            wcampos := wcampos+',"CodigoClienteNota"=:xidcliente';
       end;
    if XNota.TryGetValue('idvendedor',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoRepresentanteNota"=:xidvendedor'
         else
            wcampos := wcampos+',"CodigoRepresentanteNota"=:xidvendedor';
       end;
    if XNota.TryGetValue('idalvo',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoAlvoNota"=:xidalvo'
         else
            wcampos := wcampos+',"CodigoAlvoNota"=:xidalvo';
       end;
    if XNota.TryGetValue('idcondicao',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoCondicaoNota"=:xidcondicao '
         else
            wcampos := wcampos+',"CodigoCondicaoNota"=:xidcondicao ';
       end;
    if XNota.TryGetValue('idcobranca',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoDocumentoCobrancaNota"=:xidcobranca'
         else
            wcampos := wcampos+',"CodigoDocumentoCobrancaNota"=:xidcobranca';
       end;
    if XNota.TryGetValue('dataemissao',wval) then
       begin
         if wcampos='' then
            wcampos := '"DataEmissaoNota"=:xdataemissao'
         else
            wcampos := wcampos+',"DataEmissaoNota"=:xdataemissao';
       end;
    if XNota.TryGetValue('observacao',wval) then
       begin
         if wcampos='' then
            wcampos := '"ObservacoesNota"=:xobservacao'
         else
            wcampos := wcampos+',"ObservacoesNota"=:xobservacao';
       end;
    if XNota.TryGetValue('modelodocumentofiscal',wval) then
       begin
         if wcampos='' then
            wcampos := '"ModeloDocumentoFiscal"=:xmodelo'
         else
            wcampos := wcampos+',"ModeloDocumentoFiscal"=:xmodelo';
       end;
    if XNota.TryGetValue('datasaida',wval) then
       begin
         if wcampos='' then
            wcampos := '"DataSaidaNota"=:xdatasaida'
         else
            wcampos := wcampos+',"DataSaidaNota"=:xdatasaida';
       end;
    if XNota.TryGetValue('horasaida',wval) then
       begin
         if wcampos='' then
            wcampos := '"HoraSaidaNota"=:xhorasaida'
         else
            wcampos := wcampos+',"HoraSaidaNota"=:xhorasaida';
       end;
    if XNota.TryGetValue('idespecie',wval) then
       begin
         if wcampos='' then
            wcampos := '"EspecieDocumentoNota"=(case when :xidespecie=0 then null else :xidespecie end)'
         else
            wcampos := wcampos+',"EspecieDocumentoNota"=(case when :xidespecie=0 then null else :xidespecie end)';
       end;
    if XNota.TryGetValue('idseriesubserie',wval) then
       begin
         if wcampos='' then
            wcampos := '"SerieSubSerieNota"=(case when :xidserie=0 then null else :xidserie end)'
         else
            wcampos := wcampos+',"SerieSubSerieNota"=(case when :xidserie=0 then null else :xidserie end)';
       end;
    if XNota.TryGetValue('idclassificacaoreceitadespesa',wval) then
       begin
         if wcampos='' then
            wcampos := '"ClassificacaoReceitaDespesaNota"=(case when :xidclassificacao=0 then null else :xidclassificacao end)'
         else
            wcampos := wcampos+',"ClassificacaoReceitaDespesaNota"=(case when :xidclassificacao=0 then null else :xidclassificacao end)';
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
           SQL.Add('Update "NotaFiscal" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoNota"=:xid ');
           ParamByName('xid').AsInteger      := XIdNota;
           if XNota.TryGetValue('idcliente',wval) then
              ParamByName('xidcliente').AsInteger  := strtoint(XNota.GetValue('idcliente').Value);
           if XNota.TryGetValue('idvendedor',wval) then
              ParamByName('xidvendedor').AsInteger  := strtoint(XNota.GetValue('idvendedor').Value);
           if XNota.TryGetValue('idalvo',wval) then
              ParamByName('xidalvo').AsInteger  := strtoint(XNota.GetValue('idalvo').Value);
           if XNota.TryGetValue('idcondicao',wval) then
              ParamByName('xidcondicao').AsInteger  := strtoint(XNota.GetValue('idcondicao').Value);
           if XNota.TryGetValue('idcobranca',wval) then
              ParamByName('xidcobranca').AsInteger  := strtoint(XNota.GetValue('idcobranca').Value);
           if XNota.TryGetValue('idclassificacaoreceitadespesa',wval) then
              ParamByName('xidclassificacao').AsInteger  := strtoint(XNota.GetValue('idclassificacaoreceitadespesa').Value);
           if XNota.TryGetValue('dataemissao',wval) then
              ParamByName('xdataemissao').AsDate     := strtodate(XNota.GetValue('dataemissao').Value);
           if XNota.TryGetValue('observacao',wval) then
              ParamByName('xobservacao').AsString    := XNota.GetValue('observacao').Value;
           if XNota.TryGetValue('modelodocumentofiscal',wval) then
              ParamByName('xmodelo').AsString     := XNota.GetValue('modelodocumentofiscal').Value;
           if XNota.TryGetValue('idespecie',wval) then
              ParamByName('xidespecie').AsInteger := strtoint(XNota.GetValue('idespecie').Value);
           if XNota.TryGetValue('idseriesubserie',wval) then
              ParamByName('xidserie').AsInteger   := strtoint(XNota.GetValue('idseriesubserie').Value);
           if XNota.TryGetValue('datasaida',wval) then
              ParamByName('xdatasaida').AsDate    := strtodate(XNota.GetValue('datasaida').Value);
           if XNota.TryGetValue('horasaida',wval) then
              ParamByName('xhorasaida').AsString     := XNota.GetValue('horasaida').Value;
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
              SQL.Add('select "CodigoInternoNota"  as id,');
              SQL.Add('"CodigoEmpresaNota"         as idempresa,');
              SQL.Add('"CodigoFaturaNota"          as idfatura,');
              SQL.Add('"DataEmissaoNota"           as dataemissao,');
              SQL.Add('"DataSaidaNota"             as datasaida,');
              SQL.Add('"DataMovimentoNota"         as datamovimento,');
              SQL.Add('"PedidoClienteNota"         as pedido,');
              SQL.Add('"OrdemServicoNota"          as ordemservico,');
              SQL.Add('"NumeroImpressoraNota"      as numeroimpressora,');
              SQL.Add('"IntervencaoTecnicaNota"    as intervencaotecnica,');
              SQL.Add('"NumeroCupomNota"           as numerocupom,');
              SQL.Add('"NumeroDocumentoNota"       as numerodocumento,');
              SQL.Add('"NumeroDocumentoProvisorio" as numerodocumentoprovisorio,');
              SQL.Add('"NumeroDocumentoFinalNota"  as numerodocumentofinal,');
              SQL.Add('"SituacaoNota"              as situacao,');
              SQL.Add('"CodigoCondicaoNota"        as idcondicao,');
              SQL.Add('ts_retornacondicaodescricao("CodigoCondicaoNota") as xcondicao,');
              SQL.Add('ts_retornacondicaopreco("CodigoCondicaoNota") as xprecocondicao, ');
              SQL.Add('ts_retornacondicaocodigofiscal("CodigoCondicaoNota") as xidcfopcondicao,');
              SQL.Add('ts_retornacondicaocodigofiscalst("CodigoCondicaoNota") as xidcfopstcondicao,');
              SQL.Add('ts_retornafiscalcodigo(ts_retornacondicaocodigofiscal("CodigoCondicaoNota")) as xcfopcondicao,');
              SQL.Add('ts_retornafiscalcodigo(ts_retornacondicaocodigofiscalst("CodigoCondicaoNota")) as xcfopstcondicao,');
              SQL.Add('(case when ts_retornacondicaotipper("CodigoCondicaoNota")=''D'' then ts_retornacondicaopercentual("CodigoCondicaoNota") else 0 end) as xdesccondicao,');
              SQL.Add('(case when ts_retornacondicaotipper("CodigoCondicaoNota")=''A'' then ts_retornacondicaopercentual("CodigoCondicaoNota") else 0 end) as xacrescccondicao,');
              SQL.Add('"CodigoOperacaoEstoqueNota" as idoperacaoestoque,');
              SQL.Add('"CodigoMovimentoNota"       as idmovimento,');
              SQL.Add('"CodigoNaturezaNota"        as idnatureza,');
              SQL.Add('"CodigoFornecedorNota"      as idfornecedor,');
              SQL.Add('ts_retornapessoanome("CodigoFornecedorNota") as xfornecedor,');
              SQL.Add('"CodigoClienteNota"         as idcliente,');
              SQL.Add('ts_retornapessoanome("CodigoClienteNota") as xcliente,');
              SQL.Add('"CodigoRepresentanteNota"   as idvendedor,');
              SQL.Add('ts_retornapessoanome("CodigoRepresentanteNota") as xvendedor,');
              SQL.Add('"CodigoTransporteNota"      as idtransportador,');
              SQL.Add('ts_retornapessoanome("CodigoTransporteNota") as xtransportador,');
              SQL.Add('"CodigoRedespachoNota"      as idredespacho,');
              SQL.Add('ts_retornapessoanome("CodigoRedespachoNota") as xredespacho,');
              SQL.Add('"CodigoAlvoNota"            as idalvo,');
              SQL.Add('ts_retornapessoanome("CodigoAlvoNota") as xalvo,');
              SQL.Add('"SituacaoFreteNota"         as situacaofrete,');
              SQL.Add('"PlacaVeiculoNota"          as placaveiculo,');
              SQL.Add('"UFVeiculoNota"             as ufveiculo,');
              SQL.Add('"ViaTransporteNota"         as viatransporte,');
              SQL.Add('"ObservacoesNota"           as observacao,');
              SQL.Add('"TotalCustoNota"            as totalcusto,');
              SQL.Add('"TotalMercadorias"          as totalmercadorias,');
              SQL.Add('"TotalNota"                 as totalnota,');
              SQL.Add('"TotalLiquidoNota"          as totalliquido,');
              SQL.Add('"TotalIPINota"              as totalipi,');
              SQL.Add('"TotalICMSSubstituicaoNota" as totalicmsst,');
              SQL.Add('"BaseICMSNota"              as baseicms,');
              SQL.Add('"TotalICMSNota"             as totalicms,');
              SQL.Add('"TotalDespesasNota"         as totaldespesa,');
              SQL.Add('"TotalFretePFNota"          as totalfretepf,');
              SQL.Add('"TotalFretePDNota"          as totalfretepd,');
              SQL.Add('"PercentualICMSFreteNota"   as percentualicmsfrete,');
              SQL.Add('"PercentualDescontoNota"    as percentualdesconto,');
              SQL.Add('"TotalDescontosNota"        as totaldesconto,');
              SQL.Add('"TotalEmbalagemNota"        as totalembalagem,');
              SQL.Add('"PercetualIPIEmbalagemNota" as percentualipiembalagem,');
              SQL.Add('"PercentualICMSEmbalagemNota" as percentualicmsembalagem,');
              SQL.Add('"ValorPagoNota"             as valorpago,');
              SQL.Add('"CodigoFormaPagamentoNota"  as idformapagamento,');
              SQL.Add('"ValorTrocoNota"            as valortroco,');
              SQL.Add('"ModuloOrigemNota"          as moduloorigem,');
              SQL.Add('"CodigoDocumentoCobrancaNota" as iddocumentocobranca,');
              SQL.Add('ts_retornadocumentocobrancadescricao("CodigoDocumentoCobrancaNota") as xcobranca,');
              SQL.Add('"CodigoPortadorDocumentoNota" as idportador,');
              SQL.Add('ts_retornapessoanome("CodigoPortadorDocumentoNota") as xportador,');
              SQL.Add('"SituacaoCobrancaNota"      as situacaocobranca,');
              SQL.Add('"DataEmissaoCobrancaNota"   as dataemissaocobranca,');
              SQL.Add('"EspecieMercadoriaNota"     as especiemercadoria,');
              SQL.Add('"MarcaMercadoriaNota"       as marcamercadoria,');
              SQL.Add('"CodigoDestinatarioNota"    as iddestinatario,');
              SQL.Add('ts_retornapessoanome("CodigoDestinatarioNota") as xdestinatario,');
              SQL.Add('"CodigoRemetenteNota"       as idremetente,');
              SQL.Add('ts_retornapessoanome("CodigoRemetenteNota") as xremetente,');
              SQL.Add('"CodigoConsignatarioNota"   as idconsignatario,');
              SQL.Add('ts_retornapessoanome("CodigoConsignatarioNota") as xconsignatario,');
              SQL.Add('"CodigoCidadeOrigemNota"    as idcidadeorigem,');
              SQL.Add('"CodigoCidadeDestinoNota"   as idcidadedestino,');
              SQL.Add('"ReembolsoNota"             as reembolso,');
              SQL.Add('"NaturezaCargaNota"         as naturezacarga,');
              SQL.Add('"QtdeMercadoriaNota"        as quantidademercadoria,');
              SQL.Add('"ValorMercadoriaNota"       as valormercadoria,');
              SQL.Add('"PesoMercadoriaNota"        as pesomercadoria,');
              SQL.Add('"NotaFiscalOrigemNota"      as notafiscalorigem,');
              SQL.Add('"FretePesoVolumeNota"       as fretepesovolume,');
              SQL.Add('"QtdeFretePesoVolumeNota"   as quantidadefretepesovolume,');
              SQL.Add('"UnitarioFretePesoVolumeNota" as unitariofretepesovolume,');
              SQL.Add('"TotalFretePesoVolumeNota"  as totalfretepesovolume,');
              SQL.Add('"FreteValorNota"            as fretevalor,');
              SQL.Add('"QtdeFreteValorNota"        as quantidadefretevalor,');
              SQL.Add('"UnitarioFreteValorNota"    as unitariofretevalor,');
              SQL.Add('"TotalFreteValorNota"       as totalfretevalor,');
              SQL.Add('"SecCatDespNota"            as seccatdesp,');
              SQL.Add('"QtdeSecCatDespNota"        as quantidadeseccatdesp,');
              SQL.Add('"UnitarioSecCatDespNota"    as unitarioseccatdesp,');
              SQL.Add('"TotalSecCatDespNota"       as totalseccatdesp,');
              SQL.Add('"OutrosNota"                as outros,');
              SQL.Add('"QtdeOutrosNota"            as quantidadeoutros,');
              SQL.Add('"UnitarioOutrosNota"        as unitariooutros,');
              SQL.Add('"TotalOutrosNota"           as totaloutros,');
              SQL.Add('"PercentualICMSNota"        as percentualicms,');
              SQL.Add('"TipoTributacaoNota"        as tipotributacao,');
              SQL.Add('"HoraSaidaNota"             as horasaida,');
              SQL.Add('"BaseIPINota"               as baseipi,');
              SQL.Add('"IsentosICMNota"            as isentosicms,');
              SQL.Add('"OutrosICMNota"             as outrosicms,');
              SQL.Add('"IsentosIPINota"            as isentosipi,');
              SQL.Add('"OutrosIPINota"             as outrosipi,');
              SQL.Add('"ValorTrocoTicket"          as valortroco,');
              SQL.Add('"NumeroOrcamentoNota"       as idorcamento,');
              SQL.Add('"DescricaoServico"          as descricaoservico,');
              SQL.Add('"ValorServico"              as valorservico,');
              SQL.Add('"BaseCalculoISSQN"          as basecalculoissqn,');
              SQL.Add('"PercentualCalculoISSQN"    as percentualcalculoissqn,');
              SQL.Add('"ValorISSQN"                as valorissqn,');
              SQL.Add('"ContraPartidaNota"         as idcontrapartida,');
              SQL.Add('"ModeloDocumentoFiscal"     as modelodocumentofiscal,');
              SQL.Add('"EspecieDocumentoNota"      as idespecie,');
              SQL.Add('"SerieSubSerieNota"         as idseriesubserie,');
              SQL.Add('"TurnoPostoNota"            as turnoposto,');
              SQL.Add('"NumeroCaixaNota"           as numerocaixa,');
              SQL.Add('"SituacaoPagtoNota"         as situacaopagamento,');
              SQL.Add('"UsuarioNota"               as idusuario,');
              SQL.Add('"NotaTransferencia"         as idnotatransferencia,');
              SQL.Add('"QtdeVolumeNota"            as quantidadevolume,');
              SQL.Add('"PesoLiquidoNota"           as pesoliquido,');
              SQL.Add('"PesoBrutoNota"             as pesobruto,');
              SQL.Add('"InformacaoComplementarNota" as informacaocomplementar,');
              SQL.Add('"NotaDevolvida"             as ehnotadevolvida,');
              SQL.Add('"EncargoFinanceiroNota"     as encargofinanceiro,');
              SQL.Add('"NumeroParcelasNota"        as numeroparcelas,');
              SQL.Add('"ValorEntradaNota"          as valorentrada,');
              SQL.Add('"BaseICMSSubstituicaoNota"  as baseicmsst,');
              SQL.Add('"DataLancamentoNota"        as datalancamento,');
              SQL.Add('"DataUltimaAlteracao"       as dataultimaalteracao,');
              SQL.Add('"OrigemUltimaAlteracao"     as origemultimaalteracao,');
              SQL.Add('"TotalDespesaAdicionalNota" as totaldespesaadicional,');
              SQL.Add('"CodigoFiscalServicoNota"   as idcodigofiscal,');
              SQL.Add('"TotalCreditoNota"          as totalcredito,');
              SQL.Add('"TotalCreditoDevolucaoNota" as totalcreditodevolucao,');
              SQL.Add('"TotalCreditoFidelidadeNota" as totalcreditofidelidade,');
              SQL.Add('"TotalMercadoriasSubstituicaoNota" as totalmercadoriasst,');
              SQL.Add('"CodigoNotaMatrizNota"      as idnotamatriz,');
              SQL.Add('"ImportadoSintegraNota"     as ehimportadosintegra,');
              SQL.Add('"ArquivoSintegraNota"       as arquivosintegra,');
              SQL.Add('"TotalImpostoRetidoNota"    as totalimpostoretido,');
              SQL.Add('"IdNFeNota"                 as chavenfe,');
              SQL.Add('"DataPrevisaoConsignadoNota" as dataprevisaoconsignado,');
              SQL.Add('"DataRetornoConsignadoNota" as dataretornoconsignado,');
              SQL.Add('"PercentualComissaoConsignadoNota" as percentualcomissaoconsignado,');
              SQL.Add('"ValorComissaoConsignadoNota" as valorcomissaoconsignado,');
              SQL.Add('"TotalPISNota"              as totalpis,');
              SQL.Add('"TotalCOFINSNota"           as totalcofins,');
              SQL.Add('"ChaveAcessoNFeNota"        as chaveacessonfe,');
              SQL.Add('"CodigoPessoaIndicadaNota"  as idpessoaindicada,');
              SQL.Add('"NotaFaturada"              as idnotafaturada,');
              SQL.Add('"ClassificacaoReceitaDespesaNota" as idclassificacaoreceitadespesa,');
              SQL.Add('ts_retornaclassificacaodescricao("ClassificacaoReceitaDespesaNota") as xclassificacao,');
              SQL.Add('"EhExcessaoContabilidadeNota" as ehexcessaocontabilidade,');
              SQL.Add('"NumeroRPSNotaServico"      as numerorpsservico,');
              SQL.Add('"StatusNotaServico"         as statusnotaservico,');
              SQL.Add('"ValorDeducoesNotaServico"  as valordeducoesservico,');
              SQL.Add('"ValorINSSNotaServico"      as valorinssservico,');
              SQL.Add('"ValorIRNotaServico"        as valorirservico,');
              SQL.Add('"ValorCSLLNotaServico"      as valorcsllservico,');
              SQL.Add('"ISSRetidoNotaServico"      as valorissretidoservico,');
              SQL.Add('"OutrasRetencoesNotaServico" as valoroutrasretencoesservico,');
              SQL.Add('"DescontoIncondicionadoNotaServico" as descontoincondicionadoservico,');
              SQL.Add('"DescontoCondicionadoNotaServico" as descontocondicionadoservico,');
              SQL.Add('"CodigoCNAENotaServico"     as codigocnaeservico,');
              SQL.Add('"CodigoTributacaoMunicipioNotaServico" as codigotributacaomunicipioservico,');
              SQL.Add('"ValorISSQNRetido"          as valorissqnretidoservico,');
              SQL.Add('"SerieNotaServico"          as serienotaservico,');
              SQL.Add('"TipoNotaServico"           as tiponotaservico,');
              SQL.Add('"CodigoItemListaNotaServico" as iditemlistaservico,');
              SQL.Add('"ProtocoloNFSeNota"         as protocolonfse,');
              SQL.Add('"CodigoVerificacaoNFSeNota" as codigoverificacaonfse,');
              SQL.Add('"NFeReferenciadaNota"       as nfereferenciada,');
              SQL.Add('"CodigoInternoNotaReferenciadaNota" as idnotareferenciada,');
              SQL.Add('"JustificativaEstornoNota"  as justificativaestorno,');
              SQL.Add('"LogMovimentacaoNota"       as logmovimentacao,');
              SQL.Add('"CpfCnpjAdquirenteNota"     as cpfcnpjadquirente,');
              SQL.Add('"TotalDescontoProdutoNota"  as totaldescontoproduto,');
              SQL.Add('"OrigemNotaEntradaNota"     as origemnotaentrada,');
              SQL.Add('"UtilizarSaldoDevolucaoNota" as ehutilizarsaldodevolucao,');
              SQL.Add('"UtilizarSaldoFidelidadeNota" as ehutilizarsaldofidelidade,');
              SQL.Add('"CupomReferenciadoNota"     as cupomreferenciado,');
              SQL.Add('"ECFReferenciadaNota"       as ecfreferenciada,');
              SQL.Add('"FormaEmissaoNota"          as formaemisao,');
              SQL.Add('"StatusAtualizacaoNota"     as statusatualizacao,');
              SQL.Add('"VendaPresencialNota"       as ehvendapresencial,');
              SQL.Add('"NotaImportadaNota"         as ehnotaimportada,');
              SQL.Add('"DistribuiNumerarioCaixaNota" as ehdistribuinumerariocaixa,');
              SQL.Add('"SituacaoContingenciaNota"  as situacaocontingencia,');
              SQL.Add('"OrdemCompraClienteNota"    as ordemcompracliente,');
              SQL.Add('"FinalidadeNota"            as finalidade,');
              SQL.Add('"BaseICMSSubstituicaoRetidaNota" as baseicmsstretida,');
              SQL.Add('"UtilizaBonusPromocionalNota" as ehutilizarbonuspromocional ');
              SQL.Add('from "NotaFiscal" ');
              SQL.Add('where "CodigoInternoNota" =:xid ');
              ParamByName('xid').AsInteger := XIdNota;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhuma nota fiscal alterada');
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

function VerificaRequisicao(XNota: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XNota.TryGetValue('dataemissao',wval) then
       wret := false;
    if not XNota.TryGetValue('idcliente',wval) then
       wret := false;
    if not XNota.TryGetValue('idvendedor',wval) then
       wret := false;
    if not XNota.TryGetValue('idcondicao',wval) then
       wret := false;
    if not XNota.TryGetValue('iddocumentocobranca',wval) then
       wret := false;
  except
    On E: Exception do
    begin
      wret := false;
    end;
  end;
  Result := wret;
end;

function RetornaTotalNotas(const XQuery: TDictionary<string, string>): TJSONObject;
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
         SQL.Add('from "NotaFiscal" ');
         SQL.Add('where "CodigoEmpresaNota"=:xempresa ');
         ParamByName('xempresa').AsInteger := wconexao.FIdEmpresa;
         if XQuery.ContainsKey('dataemissao') then // filtro por data emissão
            begin
              SQL.Add('and "DataEmissaoNota"=:xemissao ');
              ParamByName('xemissao').AsDate := strtodate(XQuery.Items['dataemissao']);
            end;
         if XQuery.ContainsKey('pedido') then // filtro por número
            begin
              SQL.Add('and "PedidoClienteNota"=:xpedido ');
              ParamByName('xpedido').AsInteger := strtoint(XQuery.Items['pedido']);
            end;
         if XQuery.ContainsKey('numerodocumento') then // filtro por número
            begin
              SQL.Add('and "NumeroDocumentoNota" like :xnumerodocumento ');
              ParamByName('xnumerodocumento').AsString := XQuery.Items['numerodocumento']+'%';
            end;
         if XQuery.ContainsKey('cliente') then // filtro por cliente
            begin
              SQL.Add('and lower(ts_retornapessoanome("CodigoClienteNota")) like lower(:xcliente) ');
              ParamByName('xcliente').AsString := XQuery.Items['cliente']+'%';
            end;
         if XQuery.ContainsKey('vendedor') then // filtro por vendedor
            begin
              SQL.Add('and lower(ts_retornapessoanome("CodigoRepresentanteNota")) like lower(:xvendedor) ');
              ParamByName('xvendedor').AsString := XQuery.Items['vendedor']+'%';
            end;
         if XQuery.ContainsKey('condicao') then // filtro por condicao
            begin
              SQL.Add('and lower(ts_retornacondicaodescricao("CodigoCondicaoNota")) like lower(:xcondicao) ');
              ParamByName('xcondicao').AsString := XQuery.Items['condicao']+'%';
            end;
         if XQuery.ContainsKey('cobranca') then // filtro por cobrança
            begin
              SQL.Add('and lower(ts_retornadocumentocobrancadescricao("CodigoDocumentoCobrancaNota")) like lower(:xcobranca) ');
              ParamByName('xcobranca').AsString := XQuery.Items['cobranca']+'%';
            end;
         Open;
         EnableControls;
       end;

   if wquery.RecordCount>0 then
      wret := wquery.ToJSONObject()
   else
      begin
        wret := TJSONObject.Create;
        wret.AddPair('status','500');
        wret.AddPair('description','Nenhuma Nota Fiscal encontrada');
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


function IncluiNotaFiscal(const XQuery: TDictionary<string, string>; XNota: TJSONObject; XIdEmpresa: integer): TJSONObject;
var wquery: TFDMemTable;
    wqueryInsert,wquerySelect: TFDQuery;
    wret: TJSONObject;
    wnum,wpedido,widnota: integer;
    wconexao: TProviderDataModuleConexao;
    wval:string;
begin
  try
    wconexao     := TProviderDataModuleConexao.Create(nil);
    wqueryInsert := TFDQuery.Create(nil);
    if wconexao.EstabeleceConexaoDB then
       begin
         widnota      := RetornaIdNota(wconexao.FDConnectionApi);
         wpedido      := RetornaNumeroPedido(wconexao.FDConnectionApi,XIdEmpresa);
         with wqueryInsert do
         begin
           Connection := wconexao.FDConnectionApi;
           DisableControls;
           Close;
           SQL.Clear;
           Params.Clear;
           SQL.Add('Insert into "NotaFiscal" ("CodigoInternoNota","CodigoEmpresaNota","CodigoFaturaNota",');
           SQL.Add('"DataEmissaoNota","DataSaidaNota","DataMovimentoNota","PedidoClienteNota","OrdemServicoNota",');
           SQL.Add('"NumeroDocumentoNota","NumeroDocumentoProvisorio","NumeroDocumentoFinalNota","SituacaoNota",');
           SQL.Add('"CodigoCondicaoNota","CodigoOperacaoEstoqueNota","CodigoMovimentoNota","CodigoNaturezaNota",');
           SQL.Add('"CodigoFornecedorNota","CodigoClienteNota","CodigoRepresentanteNota","CodigoTransporteNota",');
           SQL.Add('"CodigoRedespachoNota","CodigoAlvoNota","SituacaoFreteNota","ObservacoesNota","TotalMercadorias",');
           SQL.Add('"TotalNota","TotalLiquidoNota","TotalIPINota","TotalICMSSubstituicaoNota","BaseICMSNota",');
           SQL.Add('"TotalICMSNota","TotalDespesasNota","TotalFretePFNota","TotalFretePDNota","PercentualICMSFreteNota","ValorPagoNota","ValorTrocoNota",');
           SQL.Add('"PercentualDescontoNota","TotalDescontosNota","TotalEmbalagemNota","CodigoFormaPagamentoNota",');
           SQL.Add('"ModuloOrigemNota","CodigoDocumentoCobrancaNota","CodigoPortadorDocumentoNota","SituacaoCobrancaNota",');
           SQL.Add('"HoraSaidaNota","BaseIPINota","NumeroOrcamentoNota",');
           SQL.Add('"ContraPartidaNota","ModeloDocumentoFiscal","EspecieDocumentoNota","SerieSubSerieNota","UsuarioNota",');
           SQL.Add('"NotaTransferencia","NumeroParcelasNota","ValorEntradaNota","BaseICMSSubstituicaoNota","DataLancamentoNota",');
           SQL.Add('"NotaFaturada","ClassificacaoReceitaDespesaNota") ');
           SQL.Add('values (:xidnota,:xidempresa,null,');
           SQL.Add(':xdataemissao,:xdatasaida,:xdatamovimento,:xpedido,(case when :xordemservico=''null'' then null else :xordemservico end),');
           SQL.Add('(case when :xnumerodocumento=''null'' then null else :xnumerodocumento end),(case when :xnumeroprovisorio=''null'' then null else :xnumeroprovisorio end),');
           SQL.Add('(case when :xnumerofinal=''null'' then null else :xnumerofinal end),(case when :xsituacao=''null'' then null else :xsituacao end),');
           SQL.Add('(case when :xidcondicao>0 then :xidcondicao else null end),(case when :xidoperacao>0 then :xidoperacao else null end),(case when :xidmovimento>0 then :xidmovimento else null end),(case when :xidnatureza>0 then :xidnatureza else null end),');
           SQL.Add('(case when :xidfornecedor>0 then :xidfornecedor else null end),(case when :xidcliente>0 then :xidcliente else null end),(case when :xidvendedor>0 then :xidvendedor else null end),(case when :xidtransportador>0 then :xidtransportador else null end),');
           SQL.Add('(case when :xidredespacho>0 then :xidredespacho else null end),(case when :xidalvo>0 then :xidalvo else null end),(case when :xsituacaofrete=''null'' then null else :xsituacaofrete end),');
           SQL.Add('(case when :xobservacao=''null'' then null else :xobservacao end),:xtotalmercadorias,');
           SQL.Add(':xtotalnota,:xtotalliquido,:xtotalipi,:xtotalicmsst,:xbaseicms,');
           SQL.Add(':xtotalicms,:xtotaldespesa,:xtotalfretepf,:xtotalfretepd,:xpercentualicmsfrete,:xvalorpago,:xvalortroco,');
           SQL.Add(':xpercentualdesconto,:xtotaldesconto,:xtotalembalagem,(case when :xidformapagamento>0 then :xidformapagamento else null end),');
           SQL.Add(':xmoduloorigem,(case when :xidcobranca>0 then :xidcobranca else null end),(case when :xidportador>0 then :xidportador else null end),(case when :xsituacaocobranca=''null'' then null else :xsituacaocobranca end),');
           SQL.Add('(case when :xhorasaida=''null'' then null else :xhorasaida end),:xbaseipi,(case when :xidorcamento>0 then :xidorcamento else null end),');
           SQL.Add('(case when :xidcontrapartida>0 then :xidcontrapartida else null end),(case when :xmodelodocumento=''null'' then null else :xmodelodocumento end),(case when :xidespecie>0 then :xidespecie else null end),');
           SQL.Add('(case when :xidserie>0 then :xidserie else null end),(case when :xidusuario>0 then :xidusuario else null end),');
           SQL.Add('(case when :xidnotatransferencia>0 then :xidnotatransferencia else null end),:xnumeroparcelas,:xvalorentrada,:xbaseicmsst,:xdatalancamento,');
           SQL.Add('(case when :xidnotafaturada>0 then :xidnotafaturada else null end),(case when :xidclassificacao>0 then :xidclassificacao else null end)) ');
           ParamByName('xidnota').AsInteger       := widnota;
           ParamByName('xidempresa').AsInteger    := wconexao.FIdEmpresa;
           if XNota.TryGetValue('dataemissao',wval) then
              ParamByName('xdataemissao').AsDate  := strtodate(XNota.GetValue('dataemissao').Value)
           else
              ParamByName('xdataemissao').AsDate  := date;
           if XNota.TryGetValue('datasaida',wval) then
              ParamByName('xdatasaida').AsDate  := strtodate(XNota.GetValue('datasaida').Value)
           else
              ParamByName('xdatasaida').AsDate  := date;
           if XNota.TryGetValue('datamovimento',wval) then
              ParamByName('xdatamovimento').AsDate  := strtodate(XNota.GetValue('datamovimento').Value)
           else
              ParamByName('xdatamovimento').AsDate  := date;
           ParamByName('xpedido').AsInteger       := wpedido;
           if XNota.TryGetValue('ordemservico',wval) then
              ParamByName('xordemservico').AsString  := XNota.GetValue('ordemservico').Value
           else
              ParamByName('xordemservico').AsString  := 'null';
           if XNota.TryGetValue('numerodocumento',wval) then
              ParamByName('xnumerodocumento').AsString  := XNota.GetValue('numerodocumento').Value
           else
              ParamByName('xnumerodocumento').AsString  := 'null';
           if XNota.TryGetValue('numerodocumentoprovisorio',wval) then
              ParamByName('xnumeroprovisorio').AsString  := XNota.GetValue('numerodocumentoprovisorio').Value
           else
              ParamByName('xnumeroprovisorio').AsString  := 'null';
           if XNota.TryGetValue('numerodocumentofinal',wval) then
              ParamByName('xnumerofinal').AsString  := XNota.GetValue('numerodocumentofinal').Value
           else
              ParamByName('xnumerofinal').AsString  := 'null';
           if XNota.TryGetValue('situacao',wval) then
              ParamByName('xsituacao').AsString  := XNota.GetValue('situacao').Value
           else
              ParamByName('xsituacao').AsString  := 'null';
           if XNota.TryGetValue('idcondicao',wval) then
              ParamByName('xidcondicao').AsInteger  := strtoint(XNota.GetValue('idcondicao').Value)
           else
              ParamByName('xidcondicao').AsInteger  := 0;
           if XNota.TryGetValue('idoperacaoestoque',wval) then
              ParamByName('xidoperacao').AsInteger  := strtoint(XNota.GetValue('idoperacao').Value)
           else
              ParamByName('xidoperacao').AsInteger  := 0;
           if XNota.TryGetValue('idmovimento',wval) then
              ParamByName('xidmovimento').AsInteger  := strtoint(XNota.GetValue('idmovimento').Value)
           else
              ParamByName('xidmovimento').AsInteger  := 0;
           if XNota.TryGetValue('idnatureza',wval) then
              ParamByName('xidnatureza').AsInteger  := strtoint(XNota.GetValue('idnatureza').Value)
           else
              ParamByName('xidnatureza').AsInteger  := 0;
           if XNota.TryGetValue('idfornecedor',wval) then
              ParamByName('xidfornecedor').AsInteger  := strtoint(XNota.GetValue('idfornecedor').Value)
           else
              ParamByName('xidfornecedor').AsInteger  := 0;
           if XNota.TryGetValue('idcliente',wval) then
              ParamByName('xidcliente').AsInteger  := strtoint(XNota.GetValue('idcliente').Value)
           else
              ParamByName('xidcliente').AsInteger  := 0;
           if XNota.TryGetValue('idvendedor',wval) then
              ParamByName('xidvendedor').AsInteger  := strtoint(XNota.GetValue('idvendedor').Value)
           else
              ParamByName('xidvendedor').AsInteger  := 0;
           if XNota.TryGetValue('idtransportador',wval) then
              ParamByName('xidtransportador').AsInteger  := strtoint(XNota.GetValue('idtransportador').Value)
           else
              ParamByName('xidtransportador').AsInteger  := 0;
           if XNota.TryGetValue('idredespacho',wval) then
              ParamByName('xidredespacho').AsInteger  := strtoint(XNota.GetValue('idredespacho').Value)
           else
              ParamByName('xidredespacho').AsInteger  := 0;
           if XNota.TryGetValue('idalvo',wval) then
              ParamByName('xidalvo').AsInteger  := strtoint(XNota.GetValue('idalvo').Value)
           else
              ParamByName('xidalvo').AsInteger  := 0;
           if XNota.TryGetValue('situacaofrete',wval) then
              ParamByName('xsituacaofrete').AsString  := XNota.GetValue('situacaofrete').Value
           else
              ParamByName('xsituacaofrete').AsString  := 'null';
           if XNota.TryGetValue('observacao',wval) then
              ParamByName('xobservacao').AsString  := XNota.GetValue('observacao').Value
           else
              ParamByName('xobservacao').AsString  := 'null';
           if XNota.TryGetValue('totalmercadorias',wval) then
              ParamByName('xtotalmercadorias').AsFloat  := strtofloat(XNota.GetValue('totalmercadorias').Value)
           else
              ParamByName('xtotalmercadorias').AsFloat  := 0;
           if XNota.TryGetValue('totalnota',wval) then
              ParamByName('xtotalnota').AsFloat  := strtofloat(XNota.GetValue('totalnota').Value)
           else
              ParamByName('xtotalnota').AsFloat  := 0;
           if XNota.TryGetValue('totalliquido',wval) then
              ParamByName('xtotalliquido').AsFloat  := strtofloat(XNota.GetValue('totalliquido').Value)
           else
              ParamByName('xtotalliquido').AsFloat  := 0;
           if XNota.TryGetValue('totalipi',wval) then
              ParamByName('xtotalipi').AsFloat  := strtofloat(XNota.GetValue('totalipi').Value)
           else
              ParamByName('xtotalipi').AsFloat  := 0;
           if XNota.TryGetValue('totalicmsst',wval) then
              ParamByName('xtotalicmsst').AsFloat  := strtofloat(XNota.GetValue('totalicmsst').Value)
           else
              ParamByName('xtotalicmsst').AsFloat  := 0;
           if XNota.TryGetValue('baseicms',wval) then
              ParamByName('xbaseicms').AsFloat  := strtofloat(XNota.GetValue('baseicms').Value)
           else
              ParamByName('xbaseicms').AsFloat  := 0;
           if XNota.TryGetValue('totalicms',wval) then
              ParamByName('xtotalicms').AsFloat  := strtofloat(XNota.GetValue('totalicms').Value)
           else
              ParamByName('xtotalicms').AsFloat  := 0;
           if XNota.TryGetValue('totaldespesa',wval) then
              ParamByName('xtotaldespesa').AsFloat  := strtofloat(XNota.GetValue('totaldespesa').Value)
           else
              ParamByName('xtotaldespesa').AsFloat  := 0;
           if XNota.TryGetValue('totalfretepf',wval) then
              ParamByName('xtotalfretepf').AsFloat  := strtofloat(XNota.GetValue('totalfretepf').Value)
           else
              ParamByName('xtotalfretepf').AsFloat  := 0;
           if XNota.TryGetValue('totalfretepd',wval) then
              ParamByName('xtotalfretepd').AsFloat  := strtofloat(XNota.GetValue('totalfretepd').Value)
           else
              ParamByName('xtotalfretepd').AsFloat  := 0;
           if XNota.TryGetValue('percentualicmsfrete',wval) then
              ParamByName('xpercentualicmsfrete').AsFloat  := strtofloat(XNota.GetValue('percentualicmsfrete').Value)
           else
              ParamByName('xpercentualicmsfrete').AsFloat  := 0;
           if XNota.TryGetValue('percentualdesconto',wval) then
              ParamByName('xpercentualdesconto').AsFloat  := strtofloat(XNota.GetValue('percentualdesconto').Value)
           else
              ParamByName('xpercentualdesconto').AsFloat  := 0;
           if XNota.TryGetValue('totaldesconto',wval) then
              ParamByName('xtotaldesconto').AsFloat  := strtofloat(XNota.GetValue('totaldesconto').Value)
           else
              ParamByName('xtotaldesconto').AsFloat  := 0;
           if XNota.TryGetValue('totalembalagem',wval) then
              ParamByName('xtotalembalagem').AsFloat  := strtofloat(XNota.GetValue('totalembalagem').Value)
           else
              ParamByName('xtotalembalagem').AsFloat  := 0;
           if XNota.TryGetValue('idformapagamento',wval) then
              ParamByName('xidformapagamento').AsInteger  := strtoint(XNota.GetValue('idformapagamento').Value)
           else
              ParamByName('xidformapagamento').AsInteger  := 0;
           if XNota.TryGetValue('valorpago',wval) then
              ParamByName('xvalorpago').AsFloat  := strtofloat(XNota.GetValue('valorpago').Value)
           else
              ParamByName('xvalorpago').AsFloat  := 0;
           if XNota.TryGetValue('valortroco',wval) then
              ParamByName('xvalortroco').AsFloat  := strtofloat(XNota.GetValue('valortroco').Value)
           else
              ParamByName('xvalortroco').AsFloat  := 0;
           if XNota.TryGetValue('moduloorigem',wval) then
              ParamByName('xmoduloorigem').AsString  := XNota.GetValue('moduloorigem').Value
           else
              ParamByName('xmoduloorigem').AsString  := 'null';
           if XNota.TryGetValue('iddocumentocobranca',wval) then
              ParamByName('xidcobranca').AsInteger  := strtoint(XNota.GetValue('iddocumentocobranca').Value)
           else
              ParamByName('xidcobranca').AsInteger  := 0;
           if XNota.TryGetValue('idportador',wval) then
              ParamByName('xidportador').AsInteger  := strtoint(XNota.GetValue('idportador').Value)
           else
              ParamByName('xidportador').AsInteger  := 0;
           if XNota.TryGetValue('situacaocobranca',wval) then
              ParamByName('xsituacaocobranca').AsString  := XNota.GetValue('situacaocobranca').Value
           else
              ParamByName('xsituacaocobranca').AsString  := 'null';
           if XNota.TryGetValue('horasaida',wval) then
              ParamByName('xhorasaida').AsString  := XNota.GetValue('horasaida').Value
           else
              ParamByName('xhorasaida').AsString  := 'null';
           if XNota.TryGetValue('baseipi',wval) then
              ParamByName('xbaseipi').AsFloat  := strtofloat(XNota.GetValue('baseipi').Value)
           else
              ParamByName('xbaseipi').AsFloat  := 0;
           if XNota.TryGetValue('idorcamento',wval) then
              ParamByName('xidorcamento').AsInteger  := strtoint(XNota.GetValue('idorcamento').Value)
           else
              ParamByName('xidorcamento').AsInteger  := 0;
           if XNota.TryGetValue('idcontrapartida',wval) then
              ParamByName('xidcontrapartida').AsInteger  := strtoint(XNota.GetValue('idcontrapartida').Value)
           else
              ParamByName('xidcontrapartida').AsInteger  := 0;
           if XNota.TryGetValue('modelodocumentofiscal',wval) then
              ParamByName('xmodelodocumento').AsString  := XNota.GetValue('modelodocumentofiscal').Value
           else
              ParamByName('xmodelodocumento').AsString  := 'null';
           if XNota.TryGetValue('idespecie',wval) then
              ParamByName('xidespecie').AsInteger  := strtoint(XNota.GetValue('idespecie').Value)
           else
              ParamByName('xidespecie').AsInteger  := 0;
           if XNota.TryGetValue('idseriesubserie',wval) then
              ParamByName('xidserie').AsInteger  := strtoint(XNota.GetValue('idserie').Value)
           else
              ParamByName('xidserie').AsInteger  := 0;
           if XNota.TryGetValue('idusuario',wval) then
              ParamByName('xidusuario').AsInteger  := strtoint(XNota.GetValue('idusuario').Value)
           else
              ParamByName('xidusuario').AsInteger  := 0;
           if XNota.TryGetValue('idnotatransferencia',wval) then
              ParamByName('xidnotatransferencia').AsInteger  := strtoint(XNota.GetValue('idnotatransferencia').Value)
           else
              ParamByName('xidnotatransferencia').AsInteger  := 0;
           if XNota.TryGetValue('numeroparcelas',wval) then
              ParamByName('xnumeroparcelas').AsInteger  := strtoint(XNota.GetValue('numeroparcelas').Value)
           else
              ParamByName('xnumeroparcelas').AsInteger  := 1;
           if XNota.TryGetValue('valorentrada',wval) then
              ParamByName('xvalorentrada').AsFloat  := strtofloat(XNota.GetValue('valorentrada').Value)
           else
              ParamByName('xvalorentrada').AsFloat  := 0;
           if XNota.TryGetValue('baseicmsst',wval) then
              ParamByName('xbaseicmsst').AsFloat  := strtofloat(XNota.GetValue('baseicmsst').Value)
           else
              ParamByName('xbaseicmsst').AsFloat  := 0;
           if XNota.TryGetValue('datalancamento',wval) then
              ParamByName('xdatalancamento').AsDate  := strtodate(XNota.GetValue('datalancamento').Value)
           else
              ParamByName('xdatalancamento').AsDate  := date;
           if XNota.TryGetValue('idnotafaturada',wval) then
              ParamByName('xidnotafaturada').AsInteger  := strtoint(XNota.GetValue('idnotafaturada').Value)
           else
              ParamByName('xidnotafaturada').AsInteger  := 0;
           if XNota.TryGetValue('idclassificacaoreceitadespesa',wval) then
              ParamByName('xidclassificacao').AsInteger  := strtoint(XNota.GetValue('idclassificacaoreceitadespesa').Value)
           else
              ParamByName('xidclassificacao').AsInteger  := 0;
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
                SQL.Add('select "CodigoInternoNota"  as id,');
                SQL.Add('"CodigoEmpresaNota"         as idempresa,');
                SQL.Add('"CodigoFaturaNota"          as idfatura,');
                SQL.Add('"DataEmissaoNota"           as dataemissao,');
                SQL.Add('"DataSaidaNota"             as datasaida,');
                SQL.Add('"DataMovimentoNota"         as datamovimento,');
                SQL.Add('"PedidoClienteNota"         as pedido,');
                SQL.Add('"OrdemServicoNota"          as ordemservico,');
                SQL.Add('"NumeroImpressoraNota"      as numeroimpressora,');
                SQL.Add('"IntervencaoTecnicaNota"    as intervencaotecnica,');
                SQL.Add('"NumeroCupomNota"           as numerocupom,');
                SQL.Add('"NumeroDocumentoNota"       as numerodocumento,');
                SQL.Add('"NumeroDocumentoProvisorio" as numerodocumentoprovisorio,');
                SQL.Add('"NumeroDocumentoFinalNota"  as numerodocumentofinal,');
                SQL.Add('"SituacaoNota"              as situacao,');
                SQL.Add('"CodigoCondicaoNota"        as idcondicao,');
                SQL.Add('ts_retornacondicaodescricao("CodigoCondicaoNota") as xcondicao,');
                SQL.Add('ts_retornacondicaopreco("CodigoCondicaoNota") as xprecocondicao, ');
                SQL.Add('ts_retornacondicaocodigofiscal("CodigoCondicaoNota") as xidcfopcondicao,');
                SQL.Add('ts_retornacondicaocodigofiscalst("CodigoCondicaoNota") as xidcfopstcondicao,');
                SQL.Add('ts_retornafiscalcodigo(ts_retornacondicaocodigofiscal("CodigoCondicaoNota")) as xcfopcondicao,');
                SQL.Add('ts_retornafiscalcodigo(ts_retornacondicaocodigofiscalst("CodigoCondicaoNota")) as xcfopstcondicao,');
                SQL.Add('(case when ts_retornacondicaotipper("CodigoCondicaoNota")=''D'' then ts_retornacondicaopercentual("CodigoCondicaoNota") else 0 end) as xdesccondicao,');
                SQL.Add('(case when ts_retornacondicaotipper("CodigoCondicaoNota")=''A'' then ts_retornacondicaopercentual("CodigoCondicaoNota") else 0 end) as xacrescccondicao,');
                SQL.Add('"CodigoOperacaoEstoqueNota" as idoperacaoestoque,');
                SQL.Add('"CodigoMovimentoNota"       as idmovimento,');
                SQL.Add('"CodigoNaturezaNota"        as idnatureza,');
                SQL.Add('"CodigoFornecedorNota"      as idfornecedor,');
                SQL.Add('ts_retornapessoanome("CodigoFornecedorNota") as xfornecedor,');
                SQL.Add('"CodigoClienteNota"         as idcliente,');
                SQL.Add('ts_retornapessoanome("CodigoClienteNota") as xcliente,');
                SQL.Add('"CodigoRepresentanteNota"   as idvendedor,');
                SQL.Add('ts_retornapessoanome("CodigoRepresentanteNota") as xvendedor,');
                SQL.Add('"CodigoTransporteNota"      as idtransportador,');
                SQL.Add('ts_retornapessoanome("CodigoTransporteNota") as xtransportador,');
                SQL.Add('"CodigoRedespachoNota"      as idredespacho,');
                SQL.Add('ts_retornapessoanome("CodigoRedespachoNota") as xredespacho,');
                SQL.Add('"CodigoAlvoNota"            as idalvo,');
                SQL.Add('ts_retornapessoanome("CodigoAlvoNota") as xalvo,');
                SQL.Add('"SituacaoFreteNota"         as situacaofrete,');
                SQL.Add('"PlacaVeiculoNota"          as placaveiculo,');
                SQL.Add('"UFVeiculoNota"             as ufveiculo,');
                SQL.Add('"ViaTransporteNota"         as viatransporte,');
                SQL.Add('"ObservacoesNota"           as observacao,');
                SQL.Add('"TotalCustoNota"            as totalcusto,');
                SQL.Add('"TotalMercadorias"          as totalmercadorias,');
                SQL.Add('"TotalNota"                 as totalnota,');
                SQL.Add('"TotalLiquidoNota"          as totalliquido,');
                SQL.Add('"TotalIPINota"              as totalipi,');
                SQL.Add('"TotalICMSSubstituicaoNota" as totalicmsst,');
                SQL.Add('"BaseICMSNota"              as baseicms,');
                SQL.Add('"TotalICMSNota"             as totalicms,');
                SQL.Add('"TotalDespesasNota"         as totaldespesa,');
                SQL.Add('"TotalFretePFNota"          as totalfretepf,');
                SQL.Add('"TotalFretePDNota"          as totalfretepd,');
                SQL.Add('"PercentualICMSFreteNota"   as percentualicmsfrete,');
                SQL.Add('"PercentualDescontoNota"    as percentualdesconto,');
                SQL.Add('"TotalDescontosNota"        as totaldesconto,');
                SQL.Add('"TotalEmbalagemNota"        as totalembalagem,');
                SQL.Add('"PercetualIPIEmbalagemNota" as percentualipiembalagem,');
                SQL.Add('"PercentualICMSEmbalagemNota" as percentualicmsembalagem,');
                SQL.Add('"ValorPagoNota"             as valorpago,');
                SQL.Add('"CodigoFormaPagamentoNota"  as idformapagamento,');
                SQL.Add('"ValorTrocoNota"            as valortroco,');
                SQL.Add('"ModuloOrigemNota"          as moduloorigem,');
                SQL.Add('"CodigoDocumentoCobrancaNota" as iddocumentocobranca,');
                SQL.Add('ts_retornadocumentocobrancadescricao("CodigoDocumentoCobrancaNota") as xcobranca,');
                SQL.Add('"CodigoPortadorDocumentoNota" as idportador,');
                SQL.Add('ts_retornapessoanome("CodigoPortadorDocumentoNota") as xportador,');
                SQL.Add('"SituacaoCobrancaNota"      as situacaocobranca,');
                SQL.Add('"DataEmissaoCobrancaNota"   as dataemissaocobranca,');
                SQL.Add('"EspecieMercadoriaNota"     as especiemercadoria,');
                SQL.Add('"MarcaMercadoriaNota"       as marcamercadoria,');
                SQL.Add('"CodigoDestinatarioNota"    as iddestinatario,');
                SQL.Add('ts_retornapessoanome("CodigoDestinatarioNota") as xdestinatario,');
                SQL.Add('"CodigoRemetenteNota"       as idremetente,');
                SQL.Add('ts_retornapessoanome("CodigoRemetenteNota") as xremetente,');
                SQL.Add('"CodigoConsignatarioNota"   as idconsignatario,');
                SQL.Add('ts_retornapessoanome("CodigoConsignatarioNota") as xconsignatario,');
                SQL.Add('"CodigoCidadeOrigemNota"    as idcidadeorigem,');
                SQL.Add('"CodigoCidadeDestinoNota"   as idcidadedestino,');
                SQL.Add('"ReembolsoNota"             as reembolso,');
                SQL.Add('"NaturezaCargaNota"         as naturezacarga,');
                SQL.Add('"QtdeMercadoriaNota"        as quantidademercadoria,');
                SQL.Add('"ValorMercadoriaNota"       as valormercadoria,');
                SQL.Add('"PesoMercadoriaNota"        as pesomercadoria,');
                SQL.Add('"NotaFiscalOrigemNota"      as notafiscalorigem,');
                SQL.Add('"FretePesoVolumeNota"       as fretepesovolume,');
                SQL.Add('"QtdeFretePesoVolumeNota"   as quantidadefretepesovolume,');
                SQL.Add('"UnitarioFretePesoVolumeNota" as unitariofretepesovolume,');
                SQL.Add('"TotalFretePesoVolumeNota"  as totalfretepesovolume,');
                SQL.Add('"FreteValorNota"            as fretevalor,');
                SQL.Add('"QtdeFreteValorNota"        as quantidadefretevalor,');
                SQL.Add('"UnitarioFreteValorNota"    as unitariofretevalor,');
                SQL.Add('"TotalFreteValorNota"       as totalfretevalor,');
                SQL.Add('"SecCatDespNota"            as seccatdesp,');
                SQL.Add('"QtdeSecCatDespNota"        as quantidadeseccatdesp,');
                SQL.Add('"UnitarioSecCatDespNota"    as unitarioseccatdesp,');
                SQL.Add('"TotalSecCatDespNota"       as totalseccatdesp,');
                SQL.Add('"OutrosNota"                as outros,');
                SQL.Add('"QtdeOutrosNota"            as quantidadeoutros,');
                SQL.Add('"UnitarioOutrosNota"        as unitariooutros,');
                SQL.Add('"TotalOutrosNota"           as totaloutros,');
                SQL.Add('"PercentualICMSNota"        as percentualicms,');
                SQL.Add('"TipoTributacaoNota"        as tipotributacao,');
                SQL.Add('"HoraSaidaNota"             as horasaida,');
                SQL.Add('"BaseIPINota"               as baseipi,');
                SQL.Add('"IsentosICMNota"            as isentosicms,');
                SQL.Add('"OutrosICMNota"             as outrosicms,');
                SQL.Add('"IsentosIPINota"            as isentosipi,');
                SQL.Add('"OutrosIPINota"             as outrosipi,');
                SQL.Add('"ValorTrocoTicket"          as valortroco,');
                SQL.Add('"NumeroOrcamentoNota"       as idorcamento,');
                SQL.Add('"DescricaoServico"          as descricaoservico,');
                SQL.Add('"ValorServico"              as valorservico,');
                SQL.Add('"BaseCalculoISSQN"          as basecalculoissqn,');
                SQL.Add('"PercentualCalculoISSQN"    as percentualcalculoissqn,');
                SQL.Add('"ValorISSQN"                as valorissqn,');
                SQL.Add('"ContraPartidaNota"         as idcontrapartida,');
                SQL.Add('"ModeloDocumentoFiscal"     as modelodocumentofiscal,');
                SQL.Add('"EspecieDocumentoNota"      as idespecie,');
                SQL.Add('"SerieSubSerieNota"         as idseriesubserie,');
                SQL.Add('"TurnoPostoNota"            as turnoposto,');
                SQL.Add('"NumeroCaixaNota"           as numerocaixa,');
                SQL.Add('"SituacaoPagtoNota"         as situacaopagamento,');
                SQL.Add('"UsuarioNota"               as idusuario,');
                SQL.Add('"NotaTransferencia"         as idnotatransferencia,');
                SQL.Add('"QtdeVolumeNota"            as quantidadevolume,');
                SQL.Add('"PesoLiquidoNota"           as pesoliquido,');
                SQL.Add('"PesoBrutoNota"             as pesobruto,');
                SQL.Add('"InformacaoComplementarNota" as informacaocomplementar,');
                SQL.Add('"NotaDevolvida"             as ehnotadevolvida,');
                SQL.Add('"EncargoFinanceiroNota"     as encargofinanceiro,');
                SQL.Add('"NumeroParcelasNota"        as numeroparcelas,');
                SQL.Add('"ValorEntradaNota"          as valorentrada,');
                SQL.Add('"BaseICMSSubstituicaoNota"  as baseicmsst,');
                SQL.Add('"DataLancamentoNota"        as datalancamento,');
                SQL.Add('"DataUltimaAlteracao"       as dataultimaalteracao,');
                SQL.Add('"OrigemUltimaAlteracao"     as origemultimaalteracao,');
                SQL.Add('"TotalDespesaAdicionalNota" as totaldespesaadicional,');
                SQL.Add('"CodigoFiscalServicoNota"   as idcodigofiscal,');
                SQL.Add('"TotalCreditoNota"          as totalcredito,');
                SQL.Add('"TotalCreditoDevolucaoNota" as totalcreditodevolucao,');
                SQL.Add('"TotalCreditoFidelidadeNota" as totalcreditofidelidade,');
                SQL.Add('"TotalMercadoriasSubstituicaoNota" as totalmercadoriasst,');
                SQL.Add('"CodigoNotaMatrizNota"      as idnotamatriz,');
                SQL.Add('"ImportadoSintegraNota"     as ehimportadosintegra,');
                SQL.Add('"ArquivoSintegraNota"       as arquivosintegra,');
                SQL.Add('"TotalImpostoRetidoNota"    as totalimpostoretido,');
                SQL.Add('"IdNFeNota"                 as chavenfe,');
                SQL.Add('"DataPrevisaoConsignadoNota" as dataprevisaoconsignado,');
                SQL.Add('"DataRetornoConsignadoNota" as dataretornoconsignado,');
                SQL.Add('"PercentualComissaoConsignadoNota" as percentualcomissaoconsignado,');
                SQL.Add('"ValorComissaoConsignadoNota" as valorcomissaoconsignado,');
                SQL.Add('"TotalPISNota"              as totalpis,');
                SQL.Add('"TotalCOFINSNota"           as totalcofins,');
                SQL.Add('"ChaveAcessoNFeNota"        as chaveacessonfe,');
                SQL.Add('"CodigoPessoaIndicadaNota"  as idpessoaindicada,');
                SQL.Add('"NotaFaturada"              as idnotafaturada,');
                SQL.Add('"ClassificacaoReceitaDespesaNota" as idclassificacaoreceitadespesa,');
                SQL.Add('ts_retornaclassificacaodescricao("ClassificacaoReceitaDespesaNota") as xclassificacao,');
                SQL.Add('"EhExcessaoContabilidadeNota" as ehexcessaocontabilidade,');
                SQL.Add('"NumeroRPSNotaServico"      as numerorpsservico,');
                SQL.Add('"StatusNotaServico"         as statusnotaservico,');
                SQL.Add('"ValorDeducoesNotaServico"  as valordeducoesservico,');
                SQL.Add('"ValorINSSNotaServico"      as valorinssservico,');
                SQL.Add('"ValorIRNotaServico"        as valorirservico,');
                SQL.Add('"ValorCSLLNotaServico"      as valorcsllservico,');
                SQL.Add('"ISSRetidoNotaServico"      as valorissretidoservico,');
                SQL.Add('"OutrasRetencoesNotaServico" as valoroutrasretencoesservico,');
                SQL.Add('"DescontoIncondicionadoNotaServico" as descontoincondicionadoservico,');
                SQL.Add('"DescontoCondicionadoNotaServico" as descontocondicionadoservico,');
                SQL.Add('"CodigoCNAENotaServico"     as codigocnaeservico,');
                SQL.Add('"CodigoTributacaoMunicipioNotaServico" as codigotributacaomunicipioservico,');
                SQL.Add('"ValorISSQNRetido"          as valorissqnretidoservico,');
                SQL.Add('"SerieNotaServico"          as serienotaservico,');
                SQL.Add('"TipoNotaServico"           as tiponotaservico,');
                SQL.Add('"CodigoItemListaNotaServico" as iditemlistaservico,');
                SQL.Add('"ProtocoloNFSeNota"         as protocolonfse,');
                SQL.Add('"CodigoVerificacaoNFSeNota" as codigoverificacaonfse,');
                SQL.Add('"NFeReferenciadaNota"       as nfereferenciada,');
                SQL.Add('"CodigoInternoNotaReferenciadaNota" as idnotareferenciada,');
                SQL.Add('"JustificativaEstornoNota"  as justificativaestorno,');
                SQL.Add('"LogMovimentacaoNota"       as logmovimentacao,');
                SQL.Add('"CpfCnpjAdquirenteNota"     as cpfcnpjadquirente,');
                SQL.Add('"TotalDescontoProdutoNota"  as totaldescontoproduto,');
                SQL.Add('"OrigemNotaEntradaNota"     as origemnotaentrada,');
                SQL.Add('"UtilizarSaldoDevolucaoNota" as ehutilizarsaldodevolucao,');
                SQL.Add('"UtilizarSaldoFidelidadeNota" as ehutilizarsaldofidelidade,');
                SQL.Add('"CupomReferenciadoNota"     as cupomreferenciado,');
                SQL.Add('"ECFReferenciadaNota"       as ecfreferenciada,');
                SQL.Add('"FormaEmissaoNota"          as formaemisao,');
                SQL.Add('"StatusAtualizacaoNota"     as statusatualizacao,');
                SQL.Add('"VendaPresencialNota"       as ehvendapresencial,');
                SQL.Add('"NotaImportadaNota"         as ehnotaimportada,');
                SQL.Add('"DistribuiNumerarioCaixaNota" as ehdistribuinumerariocaixa,');
                SQL.Add('"SituacaoContingenciaNota"  as situacaocontingencia,');
                SQL.Add('"OrdemCompraClienteNota"    as ordemcompracliente,');
                SQL.Add('"FinalidadeNota"            as finalidade,');
                SQL.Add('"BaseICMSSubstituicaoRetidaNota" as baseicmsstretida,');
                SQL.Add('"UtilizaBonusPromocionalNota" as ehutilizarbonuspromocional ');
                SQL.Add('from "NotaFiscal" ');
                SQL.Add('where "CodigoInternoNota" =:xnota ');
                ParamByName('xnota').AsInteger := widnota;
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhuma nota fiscal incluída');
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

function RetornaIdNota(XFDConnection: TFDConnection): integer;
var wret: integer;
    wquery: TFDQuery;
    wsequence: string;
begin
  wsequence := '"NotaFiscal_CodigoInternoNota_seq"';
  wquery    := TFDQuery.Create(nil);
  with wquery do
  begin
    Connection := XFDConnection;
    DisableControls;
    Close;
    SQL.Clear;
    Params.Clear;
    SQL.Add('select nextval('+QuotedStr(wsequence)+') as ult ');
    Open;
    EnableControls;
    if RecordCount > 0 then
       wret := wquery.FieldByName('ult').asInteger
    else
       wret := 0;
  end;
  Result := wret;
end;


function RetornaNumeroPedido(XFDConnection: TFDConnection; XIdEmpresa: integer): integer;
var wret: integer;
    wquery: TFDQuery;
    wsequence: string;
begin
  wsequence := '"UltimoPedidoTSFature_'+inttostr(XIdEmpresa)+'_seq"';
  wquery    := TFDQuery.Create(nil);
  with wquery do
  begin
    Connection := XFDConnection;
    DisableControls;
    Close;
    SQL.Clear;
    Params.Clear;
//    SQL.Add('Select "TS_PedidoXE5_RenumeraPedido"(:XEmpresa) as ult ');
//    ParamByName('XEmpresa').AsInteger := XIdEmpresa;
    SQL.Add('select nextval('+QuotedStr(wsequence)+') as ult ');
    Open;
    EnableControls;
    if RecordCount > 0 then
       wret := wquery.FieldByName('ult').asInteger
    else
       wret := 0;
  end;
  Result := wret;
end;
end.
