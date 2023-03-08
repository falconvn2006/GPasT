unit dat.movNotasFiscaisItens;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,IdCoderMIME,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections, IniFiles;


function RetornaNotaFiscalItem(XNota,XId: integer): TJSONObject;
function RetornaNotaFiscalItens(const XQuery: TDictionary<string, string>; XNota,XLimit,XOffset: integer): TJSONArray;
function RetornaTotalItens(const XQuery: TDictionary<string, string>; XIdNota: integer): TJSONObject;
function ApagaNotaItem(XNota,XId: integer): TJSONObject;
{function RetornaIdOrcamentoItem(XOrcamento,XIdProduto: integer): TJSONObject;
function RetornaIdOrcamentoItemGrade(XOrcamento,XIdProduto,XTamanho,XCor: integer): TJSONObject;
function IncluiOrcamentoItem(XOrcamentoItem: TJSONObject; XIdOrcamento,XIdEmpresa: integer): TJSONObject;}
function AlteraNotaItem(XIdItem: integer; XItem: TJSONObject): TJSONObject;
{function RetornaIdItem(XFDConnection: TFDConnection): integer;
function VerificaRequisicao(XOrcamentoItem: TJSONObject): boolean;
procedure RetornaCamposProduto(XFDConnection: TFDConnection; XIdOrcamento: integer; XOrcamentoItem: TJSONObject);
procedure AtribuiFotoProduto(XCodigo: string; XQuery: TFDQuery);
function RetornaBase64(XArquivo: string; XMaximo: integer): widestring;}

implementation

uses prv.dataModuleConexao;

var FNumItem,FIdItem,FCodProduto,FCodAliquota,FCodVendedor,FCodFiscal,FCodSitTrib,FTamanho,FCor: integer;
    FQtde,FUnitario,FTotal: double;
    FIncideST: boolean;
    FDatMov: tdatetime;


function RetornaNotaFiscalItem(XNota,XId: integer): TJSONObject;
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
         SQL.Add('select "CodigoNotaItem"          as idnota,');
         SQL.Add('       "CodigoInternoItem"       as id,');
         SQL.Add('       "NumeroItem"              as numero,');
         SQL.Add('       "CodigoProdutoItem"       as idproduto,');
         SQL.Add('       ts_retornaprodutocodigo("CodigoProdutoItem") as xcodproduto,');
         SQL.Add('       ts_retornaprodutodescricao("CodigoProdutoItem") as xdescproduto,');
         SQL.Add('       ts_retornaprodutounidade("CodigoProdutoItem") as xunidadeproduto,');
         SQL.Add('       ts_retornaprodutocodigobarra("CodigoProdutoItem") as xceanproduto,');
         SQL.Add('       "QuantidadeItem"          as quantidade,');
         SQL.Add('       "ValorUnitarioItem"       as valorunitario,');
         SQL.Add('       "ValorDescontoItem"       as valordesconto,');
         SQL.Add('       "PercentualDescontoItem"  as percentualdesconto,');
         SQL.Add('       "ValorAcrescimoItem"      as valoracrescimo,');
         SQL.Add('       "PercentualAcrescimoItem" as percentualacrescimo,');
         SQL.Add('       "ValorTotalItem"          as valortotal,');
         SQL.Add('       "PercentualIPI"           as percentualipi,');
         SQL.Add('       "ValorIPI"                as valoripi,');
         SQL.Add('       "PercentualICMS"          as percentualicms,');
         SQL.Add('       "ValorICMS"               as valoricms,');
         SQL.Add('       "PercentualBaseICMSItem"  as percentualbaseicms,');
         SQL.Add('       "ValorBaseICMSItem"       as valorbaseicms,');
         SQL.Add('       "ValorDespesaItem"        as valordespesa,');
         SQL.Add('       "ValorFreteItem"          as valorfrete,');
         SQL.Add('       "ValorCustoItem"          as valorcusto,');
         SQL.Add('       "ValorCustoParcialItem"   as valorcustoparcial,');
         SQL.Add('       "ValorCustoContabilItem"  as valorcustocontabil,');
         SQL.Add('       "TipoOperacaoItem"        as tipooperacao,');
         SQL.Add('       "DataMovimentoItem"       as datamovimento,');
         SQL.Add('       "SituacaoNotaItem"        as situacaonota,');
         SQL.Add('       "QuantidadeEmbalagem"     as quantidadeembalagem,');
         SQL.Add('       "QuantidadeEntrada"       as quantidadeentrada,');
         SQL.Add('       "ValorUnitarioEmbalagem"  as valorunitarioembalagem,');
         SQL.Add('       "PercentualICMSSubstituicao" as percentualicmsst,');
         SQL.Add('       "ValorICMSSubstituicao"   as valoricmsst,');
         SQL.Add('       "CodigoAliquotaICMSItem"  as idaliquotaicms,');
         SQL.Add('       ts_retornaaliquotacodigo("CodigoAliquotaICMSItem") as xcodaliquota,');
         SQL.Add('       "CodigoVendedorItem"      as idvendedor,');
         SQL.Add('       ts_retornapessoanome("CodigoVendedorItem") as xvendedor,');
         SQL.Add('       "PercentualComissaoItem"  as percentualcomissao,');
         SQL.Add('       "ValorComissaoItem"       as valorcomissao,');
         SQL.Add('       "ValorEncargoFinanceiroItem" as valorencargofinanceiro,');
         SQL.Add('       "ValorFreteTerceirosItem" as valorfreteterceiros,');
         SQL.Add('       "ValorBonificacaoItem"    as valorbonificacao,');
         SQL.Add('       "ValorAcrescimosItem"     as valoracrescimos,');
         SQL.Add('       "ValorPISCofinsItem"      as valorpiscofins,');
         SQL.Add('       "ValorOutrasDespesasItem" as valoroutrasdespesas,');
         SQL.Add('       "ValorPISCreditadoItem"   as valorpiscreditado,');
         SQL.Add('       "ValorPISDebitadoItem"    as valorpisdebitado,');
         SQL.Add('       "ValorCofinsCreditadoItem" as valorcofinscreditado,');
         SQL.Add('       "ValorCofinsDebitadoItem" as valorcofinsdebitado,');
         SQL.Add('       "ValorPropagandaItem"     as valorpropaganda,');
         SQL.Add('       "ValorResPropagandaItem"  as valorrespropaganda,');
         SQL.Add('       "ValorICMSDebitadoItem"   as valoricmsdebitado,');
         SQL.Add('       "ValorOutrosItem"         as valoroutros,');
         SQL.Add('       "PrecoVendaItem"          as precovenda,');
         SQL.Add('       "PrecoMinimoItem"         as precominimo,');
         SQL.Add('       "ValorBaseICMSSubstituicaoItem" as valorbaseicmsst,');
         SQL.Add('       "TamanhoCalcadoItem"      as tamanho,');
         SQL.Add('       "CodigoCorCalcadoItem"    as idcor,');
         SQL.Add('       ts_retornacornome("CodigoCorCalcadoItem") as xcor,');
         SQL.Add('       "CodigoEmpresaItem"       as idempresa,');
         SQL.Add('       "PercentualPromocionalItem" as percentualpromocional,');
         SQL.Add('       "ValorPromocionalItem"    as valorpromocional,');
         SQL.Add('       "PrecoSugestaoItem"       as precosugestao,');
         SQL.Add('       "DataUltimaAlteracao"     as dataultimaalteracao,');
         SQL.Add('       "OrigemUltimaAlteracao"   as origemultimaalteracao,');
         SQL.Add('       "MargemLucroItem"         as margemlucro,');
         SQL.Add('       "MargemVendaItem"         as margemvenda,');
         SQL.Add('       "ValorDespesaAdicionalItem" as valordespesaadicional,');
         SQL.Add('       "ValorSimplesItem"        as valorsimples,');
         SQL.Add('       "ObservacaoItem"          as observacao,');
         SQL.Add('       "QuantidadeQuebraItem"    as quantidadequebra,');
         SQL.Add('       "CodigoCalculoAreaItem"   as idcalculoarea,');
         SQL.Add('       "EhCompostoProdutoItem"   as ehcompostoproduto,');
         SQL.Add('       "CodigoSituacaoTributariaItem" as idsituacaotributaria,');
         SQL.Add('       ts_retornasituacaotributariacodigo("CodigoSituacaoTributariaItem") as xsituacaotributaria,');
         SQL.Add('       "CodigoFiscalItem"        as idcodigofiscal,');
         SQL.Add('       ts_retornafiscalcodigo("CodigoFiscalItem") as xcodigofiscal,');
         SQL.Add('       "PercentualDiferencaAliquotaItem" as percentualdiferencialaliquota,');
         SQL.Add('       "ValorDiferencaAliquotaItem" as valordiferencialaliquota,');
         SQL.Add('       "DescricaoExtendidaItem"  as descricaoextendida,');
         SQL.Add('       "PercentualBasePISCofinsItem" as percentualbasepiscofins,');
         SQL.Add('       "ValorBasePISCofinsItem"  as valorbasepiscofins,');
         SQL.Add('       "ImpostoRetidoItem"       as impostoretido,');
         SQL.Add('       "PercentualMVAItem"       as percentualmva,');
         SQL.Add('       "PercentualBaseICMSProprioItem" as percentualbaseicmsproprio,');
         SQL.Add('       "ValorBaseICMSProprioItem" as valorbaseicmsproprio,');
         SQL.Add('       "PercentualICMSProprioItem" as percentualicmsproprio,');
         SQL.Add('       "ValorICMSProprioItem"    as valoricmsproprio,');
         SQL.Add('       "QuantidadeDevolvidaItem" as quantidadedevolvida,');
         SQL.Add('       "UtilizaSerigrafiaItem"   as ehutilizaserigrafia,');
         SQL.Add('       "NumeroCoresSerigrafiaItem" as numerocoresserigrafia,');
         SQL.Add('       "ValorSerigrafiaItem"     as valorserigrafia,');
         SQL.Add('       "QuantidadeSerigrafiaItem" as quantidadeserigrafia,');
         SQL.Add('       "ReferenciaItem"          as referencia,');
         SQL.Add('       "PercentualPISItem"       as percentualpis,');
         SQL.Add('       "PercentualCOFINSItem"    as percentualcofins,');
         SQL.Add('       "PercentualBasePISItem"   as percentualbasepis,');
         SQL.Add('       "PercentualBaseCOFINSItem" as percentualbasecofins,');
         SQL.Add('       "CodigoCSTPISItem"        as codigocstpis,');
         SQL.Add('       "CodigoCSTCOFINSItem"     as codigocstcofins,');
         SQL.Add('       "QuantidadeConciliadaItem" as quantidadeconciliada,');
         SQL.Add('       "ValorPrecoOriginalItem"  as valorprecooriginal,');
         SQL.Add('       "TipoPrecoOriginalItem"   as tipoprecooriginal,');
         SQL.Add('       "PrecoVendaCalculadoItem" as precovendacalculado,');
         SQL.Add('       "CustoFinalAnteriorItem"  as custofinalanterior,');
         SQL.Add('       "CustoUnitarioAnteriorItem" as custounitarioanterior,');
         SQL.Add('       "CodigoSituacaoTributariaOriginalItem" as idsituacaotributariaoriginal,');
         SQL.Add('       "CodigoFiscalOriginalItem" as idcodigofiscaloriginal,');
         SQL.Add('       "CodigoAliquotaICMSOriginalItem" as idaliquotaicmsoriginal,');
         SQL.Add('       "PercentualBaseICMSOriginalItem" as percentualbaseicmsoriginal,');
         SQL.Add('       "PercentualICMSOriginal"   as percentualicmsoriginal,');
         SQL.Add('       "ValorICMSOriginal"        as valoricmsoriginal,');
         SQL.Add('       "ValorBaseICMSOriginalItem" as valorbaseicmsoriginal,');
         SQL.Add('       "ValorDescontoProdutoItem"  as valordescontoproduto,');
         SQL.Add('       "PercentualDescontoProdutoItem" as percentualdescontoproduto,');
         SQL.Add('       "PercentualBaseICMSSubstituicaoItem" as percentualbaseicmsst,');
         SQL.Add('       "NumeroFCIProdutoItem"      as numerofciproduto,');
         SQL.Add('       "PercICMSInterPartItem"     as percentualicmsinterno,');
         SQL.Add('       "PercICMSUFDestItem"        as percentualicmsufdestino,');
         SQL.Add('       "PercICMSInterItem"         as percentualicmsinterno,');
         SQL.Add('       "ValorICMSUFDestItem"       as valoricmsufdestino,');
         SQL.Add('       "ValorICMSUFRemetItem"      as valoricmsufremetente,');
         SQL.Add('       "PercentualDiferimentoItem" as percentualdiferimento,');
         SQL.Add('       "ValorICMSDiferimento"      as valoricmsdiferimento,');
         SQL.Add('       "ValorICMSOperacao"         as valoricmsoperacao,');
         SQL.Add('       "NumeroItemOrdemCompraItem" as numeroitemordemcompra,');
         SQL.Add('       "ValorIOFItem"              as valoriof,');
         SQL.Add('       "ValorImpostoImportacaoItem" as valorimpostoimportacao,');
         SQL.Add('       "ValorBaseImpostoImportacaoItem" as valorbaseimpostoimportacao,');
         SQL.Add('       "ValorDespesaAduaneiraItem" as valordespesaaduaneira,');
         SQL.Add('       "TipoOperacaoMovimentoItem" as tipooperacaomovimento,');
         SQL.Add('       "ValorBaseCalculoFCPItem"   as valorbasecalculofcp,');
         SQL.Add('       "PercentualFCPItem"         as percentualfcp,');
         SQL.Add('       "ValorFCPItem"              as valorfcp,');
         SQL.Add('       "ValorBaseCalculoFCPSTItem" as valorbasecalculofcpst,');
         SQL.Add('       "PercentualFCPSTItem"       as percentualfcpst,');
         SQL.Add('       "ValorFCPSTItem"            as valorfcp,');
         SQL.Add('       "ValorBaseCalculoFCPSTRetItem" as valorbasecalculofcpstretido,');
         SQL.Add('       "PercentualFCPSTRetItem"    as percentualfcpstretido,');
         SQL.Add('       "ValorFCPSTRetItem"         as valorfcpstretido,');
         SQL.Add('       "ValorBaseCalculoSTRetItem" as valorbasecalculostretido,');
         SQL.Add('       "ValorICMSSubstituicaoRetItem" as valoricmsstretido,');
         SQL.Add('       "ValorICMSSubstitutoItem"   as valoricmssubstituto,');
         SQL.Add('       "PercentualSubstituicaoItem" as percentualst,');
         SQL.Add('       "ValorSTDebitadoItem"       as valorstdebitado,');
         SQL.Add('       "ValorSTCreditadoItem"      as valorstcreditado,');
         SQL.Add('       "EstruturalProdutoItem"     as estruturalproduto,');
         SQL.Add('       cast((select "PercentualPISConfigura" from "ConfiguracaoTSCompras" where "CodigoEmpresaConfigura"=:xidempresa) as numeric) as xpercpis,');
         SQL.Add('       cast((select "PercentualCofinsConfigura" from "ConfiguracaoTSCompras" where "CodigoEmpresaConfigura"=:xidempresa) as numeric) as xperccofins ');
         SQL.Add('from "NotaItem" where "CodigoNotaItem"=:xnota and "CodigoInternoItem"=:xid ');
         ParamByName('xnota').AsInteger := XNota;
         ParamByName('xidempresa').AsInteger := wconexao.FIdEmpresa;
         ParamByName('xid').AsInteger  := XId;
         Open;
         EnableControls;
       end;
   if wquery.RecordCount>0 then
      begin
         wquery.DisableControls;
         wquery.First;
         while not wquery.Eof do
         begin
//           AtribuiFotoProduto(wquery.FieldByName('xcodproduto').AsString,wquery);
           wquery.Next;
         end;
         wquery.EnableControls;
        wret := wquery.ToJSONObject();
      end
   else
      begin
        wret := TJSONObject.Create;
        wret.AddPair('status','500');
        wret.AddPair('description','Nenhum ítem encontrado');
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

{function RetornaIdOrcamentoItem(XOrcamento,XIdProduto: integer): TJSONObject;
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
         SQL.Add('select "CodigoProdutoItem" as idproduto, min("CodigoInternoItem") as item, sum(coalesce("QuantidadeProdutoItem",0)) as qtde from "OrcamentoItem" where "CodigoOrcamentoItem"=:xorcamento and "CodigoProdutoItem"=:xidproduto ');
         SQL.Add('group by "CodigoProdutoItem" ');
         ParamByName('xorcamento').AsInteger := XOrcamento;
         ParamByName('xidproduto').AsInteger  := XIdProduto;
         Open;
         EnableControls;
         if RecordCount>0 then
            wret := wquery.ToJSONObject()
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('idproduto','0');
              wret.AddPair('item','0');
              wret.AddPair('qtde','0');
              wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
            end;
       end;
    wconexao.EncerraConexaoDB;
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
  Result := wret;
end;

function RetornaIdOrcamentoItemGrade(XOrcamento,XIdProduto,XTamanho,XCor: integer): TJSONObject;
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
         SQL.Add('select "CodigoProdutoItem" as idproduto, "TamanhoCalcadoItem" as tam, "CodigoCorCalcadoItem" as cor, min("CodigoInternoItem") as item, sum(coalesce("QuantidadeProdutoItem",0)) as qtde from "OrcamentoItem" where "CodigoOrcamentoItem"=:xorcamento ');
         SQL.Add('and "CodigoProdutoItem"=:xidproduto and "TamanhoCalcadoItem"=:xtamanho and "CodigoCorCalcadoItem"=:xcor ');
         SQL.Add('group by "CodigoProdutoItem","TamanhoCalcadoItem","CodigoCorCalcadoItem" ');
         ParamByName('xorcamento').AsInteger := XOrcamento;
         ParamByName('xidproduto').AsInteger := XIdProduto;
         ParamByName('xtamanho').AsInteger   := XTamanho;
         ParamByName('xcor').AsInteger       := XCor;
         Open;
         EnableControls;
//         showmessage(inttostr(RecordCount));
         if RecordCount>0 then
            wret := wquery.ToJSONObject()
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('idproduto','0');
              wret.AddPair('tamanho','0');
              wret.AddPair('cor','0');
              wret.AddPair('item','0');
              wret.AddPair('qtde','0');
              wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
            end;
       end;
    wconexao.EncerraConexaoDB;
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
  Result := wret;
end;}


function ApagaNotaItem(XNota,XId: integer): TJSONObject;
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
         SQL.Add('delete from "NotaItem" where "CodigoNotaItem"=:xnota and "CodigoInternoItem"=:xid ');
         ParamByName('xnota').AsInteger := XNota;
         ParamByName('xid').AsInteger  := XId;
         ExecSQL;
         EnableControls;
       end;

    if wquery.RowsAffected > 0 then
       begin
         wret := TJSONObject.Create;
         wret.AddPair('status','200');
         wret.AddPair('description','Ítem excluído com sucesso');
         wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
       end
    else
       begin
         wret := TJSONObject.Create;
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhum ítem excluído');
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

function RetornaNotaFiscalItens(const XQuery: TDictionary<string, string>; XNota,XLimit,XOffset: integer): TJSONArray;
var wquery: TFDQuery;
    wconexao: TProviderDataModuleConexao;
    wobj: TJSONObject;
    wret: TJSONArray;
    wordem: string;
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
         SQL.Add('select "CodigoNotaItem"          as idnota,');
         SQL.Add('       "CodigoInternoItem"       as id,');
         SQL.Add('       "NumeroItem"              as numero,');
         SQL.Add('       "CodigoProdutoItem"       as idproduto,');
         SQL.Add('       ts_retornaprodutocodigo("CodigoProdutoItem") as xcodproduto,');
         SQL.Add('       ts_retornaprodutodescricao("CodigoProdutoItem") as xdescproduto,');
         SQL.Add('       ts_retornaprodutounidade("CodigoProdutoItem") as xunidadeproduto,');
         SQL.Add('       ts_retornaprodutocodigobarra("CodigoProdutoItem") as xceanproduto,');
         SQL.Add('       "QuantidadeItem"          as quantidade,');
         SQL.Add('       "ValorUnitarioItem"       as valorunitario,');
         SQL.Add('       "ValorDescontoItem"       as valordesconto,');
         SQL.Add('       "PercentualDescontoItem"  as percentualdesconto,');
         SQL.Add('       "ValorAcrescimoItem"      as valoracrescimo,');
         SQL.Add('       "PercentualAcrescimoItem" as percentualacrescimo,');
         SQL.Add('       "ValorTotalItem"          as valortotal,');
         SQL.Add('       "PercentualIPI"           as percentualipi,');
         SQL.Add('       "ValorIPI"                as valoripi,');
         SQL.Add('       "PercentualICMS"          as percentualicms,');
         SQL.Add('       "ValorICMS"               as valoricms,');
         SQL.Add('       "PercentualBaseICMSItem"  as percentualbaseicms,');
         SQL.Add('       "ValorBaseICMSItem"       as valorbaseicms,');
         SQL.Add('       "ValorDespesaItem"        as valordespesa,');
         SQL.Add('       "ValorFreteItem"          as valorfrete,');
         SQL.Add('       "ValorCustoItem"          as valorcusto,');
         SQL.Add('       "ValorCustoParcialItem"   as valorcustoparcial,');
         SQL.Add('       "ValorCustoContabilItem"  as valorcustocontabil,');
         SQL.Add('       "TipoOperacaoItem"        as tipooperacao,');
         SQL.Add('       "DataMovimentoItem"       as datamovimento,');
         SQL.Add('       "SituacaoNotaItem"        as situacaonota,');
         SQL.Add('       "QuantidadeEmbalagem"     as quantidadeembalagem,');
         SQL.Add('       "QuantidadeEntrada"       as quantidadeentrada,');
         SQL.Add('       "ValorUnitarioEmbalagem"  as valorunitarioembalagem,');
         SQL.Add('       "PercentualICMSSubstituicao" as percentualicmsst,');
         SQL.Add('       "ValorICMSSubstituicao"   as valoricmsst,');
         SQL.Add('       "CodigoAliquotaICMSItem"  as idaliquotaicms,');
         SQL.Add('       ts_retornaaliquotacodigo("CodigoAliquotaICMSItem") as xcodaliquota,');
         SQL.Add('       "CodigoVendedorItem"      as idvendedor,');
         SQL.Add('       ts_retornapessoanome("CodigoVendedorItem") as xvendedor,');
         SQL.Add('       "PercentualComissaoItem"  as percentualcomissao,');
         SQL.Add('       "ValorComissaoItem"       as valorcomissao,');
         SQL.Add('       "ValorEncargoFinanceiroItem" as valorencargofinanceiro,');
         SQL.Add('       "ValorFreteTerceirosItem" as valorfreteterceiros,');
         SQL.Add('       "ValorBonificacaoItem"    as valorbonificacao,');
         SQL.Add('       "ValorAcrescimosItem"     as valoracrescimos,');
         SQL.Add('       "ValorPISCofinsItem"      as valorpiscofins,');
         SQL.Add('       "ValorOutrasDespesasItem" as valoroutrasdespesas,');
         SQL.Add('       "ValorPISCreditadoItem"   as valorpiscreditado,');
         SQL.Add('       "ValorPISDebitadoItem"    as valorpisdebitado,');
         SQL.Add('       "ValorCofinsCreditadoItem" as valorcofinscreditado,');
         SQL.Add('       "ValorCofinsDebitadoItem" as valorcofinsdebitado,');
         SQL.Add('       "ValorPropagandaItem"     as valorpropaganda,');
         SQL.Add('       "ValorResPropagandaItem"  as valorrespropaganda,');
         SQL.Add('       "ValorICMSDebitadoItem"   as valoricmsdebitado,');
         SQL.Add('       "ValorOutrosItem"         as valoroutros,');
         SQL.Add('       "PrecoVendaItem"          as precovenda,');
         SQL.Add('       "PrecoMinimoItem"         as precominimo,');
         SQL.Add('       "ValorBaseICMSSubstituicaoItem" as valorbaseicmsst,');
         SQL.Add('       "TamanhoCalcadoItem"      as tamanho,');
         SQL.Add('       "CodigoCorCalcadoItem"    as idcor,');
         SQL.Add('       ts_retornacornome("CodigoCorCalcadoItem") as xcor,');
         SQL.Add('       "CodigoEmpresaItem"       as idempresa,');
         SQL.Add('       "PercentualPromocionalItem" as percentualpromocional,');
         SQL.Add('       "ValorPromocionalItem"    as valorpromocional,');
         SQL.Add('       "PrecoSugestaoItem"       as precosugestao,');
         SQL.Add('       "DataUltimaAlteracao"     as dataultimaalteracao,');
         SQL.Add('       "OrigemUltimaAlteracao"   as origemultimaalteracao,');
         SQL.Add('       "MargemLucroItem"         as margemlucro,');
         SQL.Add('       "MargemVendaItem"         as margemvenda,');
         SQL.Add('       "ValorDespesaAdicionalItem" as valordespesaadicional,');
         SQL.Add('       "ValorSimplesItem"        as valorsimples,');
         SQL.Add('       "ObservacaoItem"          as observacao,');
         SQL.Add('       "QuantidadeQuebraItem"    as quantidadequebra,');
         SQL.Add('       "CodigoCalculoAreaItem"   as idcalculoarea,');
         SQL.Add('       "EhCompostoProdutoItem"   as ehcompostoproduto,');
         SQL.Add('       "CodigoSituacaoTributariaItem" as idsituacaotributaria,');
         SQL.Add('       ts_retornasituacaotributariacodigo("CodigoSituacaoTributariaItem") as xsituacaotributaria,');
         SQL.Add('       "CodigoFiscalItem"        as idcodigofiscal,');
         SQL.Add('       ts_retornafiscalcodigo("CodigoFiscalItem") as xcodigofiscal,');
         SQL.Add('       "PercentualDiferencaAliquotaItem" as percentualdiferencialaliquota,');
         SQL.Add('       "ValorDiferencaAliquotaItem" as valordiferencialaliquota,');
         SQL.Add('       "DescricaoExtendidaItem"  as descricaoextendida,');
         SQL.Add('       "PercentualBasePISCofinsItem" as percentualbasepiscofins,');
         SQL.Add('       "ValorBasePISCofinsItem"  as valorbasepiscofins,');
         SQL.Add('       "ImpostoRetidoItem"       as impostoretido,');
         SQL.Add('       "PercentualMVAItem"       as percentualmva,');
         SQL.Add('       "PercentualBaseICMSProprioItem" as percentualbaseicmsproprio,');
         SQL.Add('       "ValorBaseICMSProprioItem" as valorbaseicmsproprio,');
         SQL.Add('       "PercentualICMSProprioItem" as percentualicmsproprio,');
         SQL.Add('       "ValorICMSProprioItem"    as valoricmsproprio,');
         SQL.Add('       "QuantidadeDevolvidaItem" as quantidadedevolvida,');
         SQL.Add('       "UtilizaSerigrafiaItem"   as ehutilizaserigrafia,');
         SQL.Add('       "NumeroCoresSerigrafiaItem" as numerocoresserigrafia,');
         SQL.Add('       "ValorSerigrafiaItem"     as valorserigrafia,');
         SQL.Add('       "QuantidadeSerigrafiaItem" as quantidadeserigrafia,');
         SQL.Add('       "ReferenciaItem"          as referencia,');
         SQL.Add('       "PercentualPISItem"       as percentualpis,');
         SQL.Add('       "PercentualCOFINSItem"    as percentualcofins,');
         SQL.Add('       "PercentualBasePISItem"   as percentualbasepis,');
         SQL.Add('       "PercentualBaseCOFINSItem" as percentualbasecofins,');
         SQL.Add('       "CodigoCSTPISItem"        as codigocstpis,');
         SQL.Add('       "CodigoCSTCOFINSItem"     as codigocstcofins,');
         SQL.Add('       "QuantidadeConciliadaItem" as quantidadeconciliada,');
         SQL.Add('       "ValorPrecoOriginalItem"  as valorprecooriginal,');
         SQL.Add('       "TipoPrecoOriginalItem"   as tipoprecooriginal,');
         SQL.Add('       "PrecoVendaCalculadoItem" as precovendacalculado,');
         SQL.Add('       "CustoFinalAnteriorItem"  as custofinalanterior,');
         SQL.Add('       "CustoUnitarioAnteriorItem" as custounitarioanterior,');
         SQL.Add('       "CodigoSituacaoTributariaOriginalItem" as idsituacaotributariaoriginal,');
         SQL.Add('       "CodigoFiscalOriginalItem" as idcodigofiscaloriginal,');
         SQL.Add('       "CodigoAliquotaICMSOriginalItem" as idaliquotaicmsoriginal,');
         SQL.Add('       "PercentualBaseICMSOriginalItem" as percentualbaseicmsoriginal,');
         SQL.Add('       "PercentualICMSOriginal"   as percentualicmsoriginal,');
         SQL.Add('       "ValorICMSOriginal"        as valoricmsoriginal,');
         SQL.Add('       "ValorBaseICMSOriginalItem" as valorbaseicmsoriginal,');
         SQL.Add('       "ValorDescontoProdutoItem"  as valordescontoproduto,');
         SQL.Add('       "PercentualDescontoProdutoItem" as percentualdescontoproduto,');
         SQL.Add('       "PercentualBaseICMSSubstituicaoItem" as percentualbaseicmsst,');
         SQL.Add('       "NumeroFCIProdutoItem"      as numerofciproduto,');
         SQL.Add('       "PercICMSInterPartItem"     as percentualicmsinterno,');
         SQL.Add('       "PercICMSUFDestItem"        as percentualicmsufdestino,');
         SQL.Add('       "PercICMSInterItem"         as percentualicmsinterno,');
         SQL.Add('       "ValorICMSUFDestItem"       as valoricmsufdestino,');
         SQL.Add('       "ValorICMSUFRemetItem"      as valoricmsufremetente,');
         SQL.Add('       "PercentualDiferimentoItem" as percentualdiferimento,');
         SQL.Add('       "ValorICMSDiferimento"      as valoricmsdiferimento,');
         SQL.Add('       "ValorICMSOperacao"         as valoricmsoperacao,');
         SQL.Add('       "NumeroItemOrdemCompraItem" as numeroitemordemcompra,');
         SQL.Add('       "ValorIOFItem"              as valoriof,');
         SQL.Add('       "ValorImpostoImportacaoItem" as valorimpostoimportacao,');
         SQL.Add('       "ValorBaseImpostoImportacaoItem" as valorbaseimpostoimportacao,');
         SQL.Add('       "ValorDespesaAduaneiraItem" as valordespesaaduaneira,');
         SQL.Add('       "TipoOperacaoMovimentoItem" as tipooperacaomovimento,');
         SQL.Add('       "ValorBaseCalculoFCPItem"   as valorbasecalculofcp,');
         SQL.Add('       "PercentualFCPItem"         as percentualfcp,');
         SQL.Add('       "ValorFCPItem"              as valorfcp,');
         SQL.Add('       "ValorBaseCalculoFCPSTItem" as valorbasecalculofcpst,');
         SQL.Add('       "PercentualFCPSTItem"       as percentualfcpst,');
         SQL.Add('       "ValorFCPSTItem"            as valorfcp,');
         SQL.Add('       "ValorBaseCalculoFCPSTRetItem" as valorbasecalculofcpstretido,');
         SQL.Add('       "PercentualFCPSTRetItem"    as percentualfcpstretido,');
         SQL.Add('       "ValorFCPSTRetItem"         as valorfcpstretido,');
         SQL.Add('       "ValorBaseCalculoSTRetItem" as valorbasecalculostretido,');
         SQL.Add('       "ValorICMSSubstituicaoRetItem" as valoricmsstretido,');
         SQL.Add('       "ValorICMSSubstitutoItem"   as valoricmssubstituto,');
         SQL.Add('       "PercentualSubstituicaoItem" as percentualst,');
         SQL.Add('       "ValorSTDebitadoItem"       as valorstdebitado,');
         SQL.Add('       "ValorSTCreditadoItem"      as valorstcreditado,');
         SQL.Add('       "EstruturalProdutoItem"     as estruturalproduto,');
         SQL.Add('       cast((select "PercentualPISConfigura" from "ConfiguracaoTSCompras" where "CodigoEmpresaConfigura"=:xidempresa) as numeric) as xpercpis,');
         SQL.Add('       cast((select "PercentualCofinsConfigura" from "ConfiguracaoTSCompras" where "CodigoEmpresaConfigura"=:xidempresa) as numeric) as xperccofins ');
         SQL.Add('from "NotaItem" where "CodigoNotaItem"=:xnota ');
         if XQuery.ContainsKey('xcodproduto') then // filtro por texto
            begin
              SQL.Add('and lower("xcodproduto") like lower(:xcodigo) ');
              ParamByName('xcodigo').AsString := XQuery.Items['xcodproduto']+'%';
            end;
         if XQuery.ContainsKey('order') then // ordenação
            begin
              wordem := 'order by '+XQuery.Items['order'];
              if XQuery.ContainsKey('dir') then // direção
                 wordem := wordem+' '+XQuery.Items['dir'];
              SQL.Add(wordem);
            end
         else
            SQL.Add('order by "CodigoInternoItem" ');
         if XLimit>0 then
            SQL.Add('Limit '+inttostr(XLimit)+' offset '+inttostr(XOffset));
         ParamByName('xnota').AsInteger := XNota;
         ParamByName('xidempresa').AsInteger := wconexao.FIdEmpresa;
         Open;
         EnableControls;
       end;

   if wquery.RecordCount>0 then
      begin
         wquery.DisableControls;
         wquery.First;
         while not wquery.Eof do
         begin
//           AtribuiFotoProduto(wquery.FieldByName('xcodproduto').AsString,wquery);
           wquery.Next;
         end;
         wquery.EnableControls;
        wret := wquery.ToJSONArray()
      end
   else
      begin
        wobj := TJSONObject.Create;
        wobj.AddPair('status','404');
        wobj.AddPair('description','Nenhum ítem encontrado');
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
    end;
  end;
  wconexao.EncerraConexaoDB;
  Result := wret;
end;

function RetornaTotalItens(const XQuery: TDictionary<string, string>; XIdNota: integer): TJSONObject;
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
         SQL.Add('from "NotaItem" where "CodigoNotaItem"=:xidnota ');
         ParamByName('xidnota').AsInteger := XIdNota;
         Open;
         EnableControls;
       end;

   if wquery.RecordCount>0 then
      wret := wquery.ToJSONObject()
   else
      begin
        wret := TJSONObject.Create;
        wret.AddPair('status','500');
        wret.AddPair('description','Nenhum Ítem encontrado');
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



{function IncluiOrcamentoItem(XOrcamentoItem: TJSONObject; XIdOrcamento,XIdEmpresa: integer): TJSONObject;
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
         FIdItem     := RetornaIdItem(wconexao.FDConnectionApi);
         RetornaCamposProduto(wconexao.FDConnectionApi,XIdOrcamento,XOrcamentoItem);
         with wqueryInsert do
         begin
           Connection := wconexao.FDConnectionApi;
           DisableControls;
           Close;
           SQL.Clear;
           Params.Clear;
           SQL.Add('Insert into "OrcamentoItem" ("CodigoInternoItem","CodigoOrcamentoItem","CodigoProdutoItem","QuantidadeProdutoItem",');
           SQL.Add('"PercentualDescontoItem","ValorDescontoItem","PercentualICMS","ValorBaseICMSItem","ValorICMS","PercentualPISItem","PercentualCOFINSItem",');
           SQL.Add('"ValorPISItem","ValorCOFINSItem","PercentualBasePISItem","PercentualBaseCOFINSItem","CodigoCSTPISItem","CodigoCSTCOFINSItem",');
           SQL.Add('"ValorUnitarioItem","ValorTotalItem","DataMovimentoItem",');
           SQL.Add('"CodigoAliquotaICMItem","CodigoVendedorItem","CodigoFiscalItem","CodigoSituacaoTributariaItem","TamanhoCalcadoItem","CodigoCorCalcadoItem") ');

           SQL.Add('values (:xiditem,:xidorcamento,:xidproduto,:xquantidade,');
           SQL.Add(':xpercdesconto,:xvaldesconto,:xpercicms,:xbaseicms,:xvaloricms,:xpercpis,:xperccofins,');
           SQL.Add(':xvalorpis,:xvalorcofins,:xpercbasepis,:xpercbasecofins,:xcstpis,:xcstcofins,');
           SQL.Add(':xunitario,:xtotalitem,:xdatamov,:xaliquota,:xvendedor,:xcodfiscal,:xsittrib,(case when :xtamanho>0 then :xtamanho else null end),(case when :xcor>0 then :xcor else null end)) ');
           ParamByName('xiditem').AsInteger      := FIdItem;
           ParamByName('xidorcamento').AsInteger := XIdOrcamento;
           ParamByName('xidproduto').AsInteger  := strtointdef(XOrcamentoItem.GetValue('idproduto').Value,0);
           if XOrcamentoItem.TryGetValue('quantidade',wval) then
              ParamByName('xquantidade').AsFloat := strtofloatdef(XOrcamentoItem.GetValue('quantidade').Value,0)
           else
              ParamByName('xquantidade').AsFloat := FQtde;
           if XOrcamentoItem.TryGetValue('percentualdesconto',wval) then
              ParamByName('xpercdesconto').AsFloat := strtofloatdef(XOrcamentoItem.GetValue('percentualdesconto').Value,0)
           else
              ParamByName('xpercdesconto').AsFloat := 0;
           if XOrcamentoItem.TryGetValue('valordesconto',wval) then
              ParamByName('xvaldesconto').AsFloat := strtofloatdef(XOrcamentoItem.GetValue('valordesconto').Value,0)
           else
              ParamByName('xvaldesconto').AsFloat := 0;
           if XOrcamentoItem.TryGetValue('percentualicms',wval) then
              ParamByName('xpercicms').AsFloat := strtofloatdef(XOrcamentoItem.GetValue('percentualicms').Value,0)
           else
              ParamByName('xpercicms').AsFloat := 0;
           if XOrcamentoItem.TryGetValue('baseicms',wval) then
              ParamByName('xbaseicms').AsFloat := strtofloatdef(XOrcamentoItem.GetValue('baseicms').Value,0)
           else
              ParamByName('xbaseicms').AsFloat := 0;
           if XOrcamentoItem.TryGetValue('valoricms',wval) then
              ParamByName('xvaloricms').AsFloat := strtofloatdef(XOrcamentoItem.GetValue('valoricms').Value,0)
           else
              ParamByName('xvaloricms').AsFloat := 0;
           if XOrcamentoItem.TryGetValue('percentualpis',wval) then
              ParamByName('xpercpis').AsFloat := strtofloatdef(XOrcamentoItem.GetValue('percentualpis').Value,0)
           else
              ParamByName('xpercpis').AsFloat := 0;
           if XOrcamentoItem.TryGetValue('percentualcofins',wval) then
              ParamByName('xperccofins').AsFloat := strtofloatdef(XOrcamentoItem.GetValue('percentualcofins').Value,0)
           else
              ParamByName('xperccofins').AsFloat := 0;
           if XOrcamentoItem.TryGetValue('valorpis',wval) then
              ParamByName('xvalorpis').AsFloat := strtofloatdef(XOrcamentoItem.GetValue('valorpis').Value,0)
           else
              ParamByName('xvalorpis').AsFloat := 0;
           if XOrcamentoItem.TryGetValue('valorcofins',wval) then
              ParamByName('xvalorcofins').AsFloat := strtofloatdef(XOrcamentoItem.GetValue('valorcofins').Value,0)
           else
              ParamByName('xvalorcofins').AsFloat := 0;
           if XOrcamentoItem.TryGetValue('percentualbasepis',wval) then
              ParamByName('xpercbasepis').AsFloat := strtofloatdef(XOrcamentoItem.GetValue('percentualbasepis').Value,0)
           else
              ParamByName('xpercbasepis').AsFloat := 0;
           if XOrcamentoItem.TryGetValue('percentualbasecofins',wval) then
              ParamByName('xpercbasecofins').AsFloat := strtofloatdef(XOrcamentoItem.GetValue('percentualbasecofins').Value,0)
           else
              ParamByName('xpercbasecofins').AsFloat := 0;
           if XOrcamentoItem.TryGetValue('cstpis',wval) then
              ParamByName('xcstpis').AsString := XOrcamentoItem.GetValue('cstpis').Value
           else
              ParamByName('xcstpis').AsString := '';
           if XOrcamentoItem.TryGetValue('cstcofins',wval) then
              ParamByName('xcstcofins').AsString := XOrcamentoItem.GetValue('cstcofins').Value
           else
              ParamByName('xcstcofins').AsString := '';
           if XOrcamentoItem.TryGetValue('valorunitario',wval) then
              ParamByName('xunitario').AsFloat := strtofloatdef(XOrcamentoItem.GetValue('valorunitario').Value,0)
           else
              ParamByName('xunitario').AsFloat := FUnitario;
           if XOrcamentoItem.TryGetValue('valortotal',wval) then
              ParamByName('xtotalitem').AsFloat := strtofloatdef(XOrcamentoItem.GetValue('valortotal').Value,0)
           else
              ParamByName('xtotalitem').AsFloat := FTotal;
           if XOrcamentoItem.TryGetValue('datamovimento',wval) then
              ParamByName('xdatamov').AsDateTime := strtodatetimedef(XOrcamentoItem.GetValue('datamovimento').Value,now)
           else
              ParamByName('xdatamov').AsDateTime := FDatMov;
           if XOrcamentoItem.TryGetValue('idaliquota',wval) then
              ParamByName('xaliquota').AsInteger := strtointdef(XOrcamentoItem.GetValue('idaliquota').Value,0)
           else
              ParamByName('xaliquota').AsInteger := FCodAliquota;
           if XOrcamentoItem.TryGetValue('idvendedor',wval) then
              ParamByName('xvendedor').AsInteger := strtointdef(XOrcamentoItem.GetValue('idvendedor').Value,0)
           else
              ParamByName('xvendedor').AsInteger := FCodVendedor;
           if XOrcamentoItem.TryGetValue('idcodigofiscal',wval) then
              ParamByName('xcodfiscal').AsInteger := strtointdef(XOrcamentoItem.GetValue('idcodigofiscal').Value,0)
           else
              ParamByName('xcodfiscal').AsInteger := FCodFiscal;
           if XOrcamentoItem.TryGetValue('idsituacaotributaria',wval) then
              ParamByName('xsittrib').AsInteger := strtointdef(XOrcamentoItem.GetValue('idsituacaotributaria').Value,0)
           else
              ParamByName('xsittrib').AsInteger := FCodSitTrib;
           if XOrcamentoItem.TryGetValue('numerocalcado',wval) then
              ParamByName('xtamanho').AsInteger := strtointdef(XOrcamentoItem.GetValue('numerocalcado').Value,0)
           else
              ParamByName('xtamanho').AsInteger := 0;
           if XOrcamentoItem.TryGetValue('idcorcalcado',wval) then
              ParamByName('xcor').AsInteger := strtointdef(XOrcamentoItem.GetValue('idcorcalcado').Value,0)
           else
              ParamByName('xcor').AsInteger := 0;
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
                SQL.Add('select "CodigoInternoItem"       as id,');
                SQL.Add('       "CodigoOrcamentoItem"     as idorcamento,');
                SQL.Add('       "CodigoProdutoItem"       as idproduto,');
                SQL.Add('       ts_retornaprodutocodigo("CodigoProdutoItem") as xcodproduto,');
                SQL.Add('       ts_retornaprodutodescricao("CodigoProdutoItem") as xdescproduto,');
                SQL.Add('       "CodigoAliquotaICMItem"   as idaliquota,');
                SQL.Add('       ts_retornaaliquotacodigo("CodigoAliquotaICMItem") as xcodaliquota,');
                SQL.Add('       "CodigoVendedorItem"      as idvendedor,');
                SQL.Add('       ts_retornapessoanome("CodigoVendedorItem") as xvendedor,');
                SQL.Add('       "CodigoSituacaoTributariaItem" as idsituacaotributaria,');
                SQL.Add('       ts_retornasituacaotributariacodigo("CodigoSituacaoTributariaItem") as xsituacaotributaria,');
                SQL.Add('       "CodigoFiscalItem" as idcodigofiscal,');
                SQL.Add('       ts_retornafiscalcodigo("CodigoFiscalItem") as xcodigofiscal,');
                SQL.Add('       "TamanhoCalcadoItem"      as numerocalcado,');
                SQL.Add('       "CodigoCorCalcadoItem"    as idcorcalcado,');
                SQL.Add('       ts_retornagradetitulo(ts_retornaprodutograde("CodigoProdutoItem"),"TamanhoCalcadoItem") as xtamanho,');
                SQL.Add('       ts_retornacornome("CodigoCorCalcadoItem") as xcor,');
                SQL.Add('       "ValorUnitarioItem"       as valorunitario,');
                SQL.Add('       "ValorTotalItem"          as valortotal,');
                SQL.Add('       "QuantidadeProdutoItem"   as quantidade,');
                SQL.Add('       "PercentualICMS"          as percentualicms,');
                SQL.Add('       "ValorBaseICMSItem"       as baseicms,');
                SQL.Add('       "ValorICMS"               as valoricms,');
                SQL.Add('       "ValorBaseICMSSubstituicao" as basest,');
                SQL.Add('       "ValorICMSSubstituicao"     as valorst,');
                SQL.Add('       "PercentualPISItem"         as percentualpis,');
                SQL.Add('       "PercentualCOFINSItem"      as percentualcofins,');
                SQL.Add('       "PercentualBasePISItem"     as percentualbasepis,');
                SQL.Add('       "PercentualBaseCOFINSItem"  as percentualbasecofins,');
                SQL.Add('       "ValorPISItem"              as valorpis,');
                SQL.Add('       "ValorCOFINSItem"           as valorcofins,');
                SQL.Add('       "CodigoCSTPISItem"          as cstpis,');
                SQL.Add('       "CodigoCSTCOFINSItem"       as cstcofins,');
                SQL.Add('       "PercentualDescontoItem"    as percentualdesconto,');
                SQL.Add('       "ValorDescontoItem"         as valordesconto ');
                SQL.Add('from "OrcamentoItem" ');
                SQL.Add('where "CodigoInternoItem" =:xiditem ');
                ParamByName('xiditem').AsInteger := FIdItem;
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum ítem incluído');
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

function VerificaRequisicao(XOrcamentoItem: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XOrcamentoItem.TryGetValue('idproduto',wval) then
       wret := false;
    if not XOrcamentoItem.TryGetValue('valorunitario',wval) then
       wret := false;
    if not XOrcamentoItem.TryGetValue('quantidade',wval) then
       wret := false;
  except
    On E: Exception do
    begin
      wret := false;
    end;
  end;
  Result := wret;
end;

function RetornaIdItem(XFDConnection: TFDConnection): integer;
var wret: integer;
    wsequence: string;
    wquery: TFDQuery;
begin
  wsequence := '"OrcamentoItem_CodigoInternoItem_seq"';
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

procedure RetornaCamposProduto(XFDConnection: TFDConnection; XIdOrcamento: integer; XOrcamentoItem: TJSONObject);
var wret: integer;
    wqueryProduto,wqueryOrcamento,wqueryCor: TFDQuery;
    wval: string;
begin
  FCodProduto   := strtoint(XOrcamentoItem.GetValue('idproduto').Value);
  FQtde         := strtofloat(XOrcamentoItem.GetValue('quantidade').Value);
  FUnitario     := strtofloat(XOrcamentoItem.GetValue('valorunitario').Value);
  if XOrcamentoItem.TryGetValue('tamanho',wval) then
     FTamanho := StrToIntDef(wval,0)
  else
     FTamanho := 0;
  FTotal        := strtofloat(XOrcamentoItem.GetValue('quantidade').Value)*strtofloat(XOrcamentoItem.GetValue('valorunitario').Value);

  wqueryProduto   := TFDQuery.Create(nil);
  wqueryOrcamento := TFDQuery.Create(nil);
  wqueryCor       := TFDQuery.Create(nil);

  with wqueryProduto do
  begin
    Connection := XFDConnection;
    DisableControls;
    Close;
    SQL.Clear;
    Params.Clear;
    SQL.Add('select "CodigoInternoProduto" as id, ');
    SQL.Add('       "IncideSubstituicaoProduto" as incidest,');
    SQL.Add('       "SituacaoTributariaProduto" as sittrib,');
    SQL.Add('       "CodigoAliquotaProduto"     as aliquota ');
    SQL.Add('from "Produto" where "CodigoInternoProduto"=:xproduto and "AtivoProduto"=''true'' ');
    ParamByName('xproduto').AsInteger := FCodProduto;
    Open;
    EnableControls;
    if RecordCount > 0 then
       begin
         FCodSitTrib := FieldByName('sittrib').AsInteger;
         FCodAliquota:= FieldByName('aliquota').AsInteger;
         FIncideST   := FieldByName('incidest').AsBoolean;
       end
    else
       begin
         FIncideST   := false;
         FCodSitTrib := 0;
         FCodAliquota:= 0;
       end;
  end;

  if not XOrcamentoItem.TryGetValue('cor',wval) then
     FCor := 0
  else if Length(wval)>0 then
      with wqueryCor do
      begin
        Connection := XFDConnection;
        DisableControls;
        Close;
        SQL.Clear;
        Params.Clear;
        SQL.Add('select "CodigoInternoCor" as id ');
        SQL.Add('from "TabelaCor" where "NomeCor"=:xcor ');
        ParamByName('xcor').AsString := wval;
        Open;
        EnableControls;
        if RecordCount > 0 then
           FCor := FieldByName('id').AsInteger
        else
           FCor := 0;
      end
  else
      FCor := 0;

  with wqueryOrcamento do
  begin
    Connection := XFDConnection;
    DisableControls;
    Close;
    SQL.Clear;
    Params.Clear;
    SQL.Add('select "Orcamento"."CodigoRepresentanteOrcamento" as vendedor,');
    if FIncideST then
       SQL.Add('"CondicaoPagamento"."CodigoFiscalSTCondicao" as codfiscal from "Orcamento" inner join "CondicaoPagamento" ')
    else
       SQL.Add('"CondicaoPagamento"."CodigoFiscalCondicao" as codfiscal from "Orcamento" inner join "CondicaoPagamento" ');
    SQL.Add('on "Orcamento"."CodigoCondicaoOrcamento" = "CondicaoPagamento"."CodigoInternoCondicao" ');
    SQL.Add('where "CodigoInternoOrcamento"=:xid ');
    ParamByName('xid').AsInteger := XIdOrcamento;
    Open;
    EnableControls;
    if RecordCount > 0 then
       begin
         FCodVendedor := wqueryOrcamento.FieldByName('vendedor').asInteger;
         FCodFiscal   := wqueryOrcamento.FieldByName('codfiscal').asInteger;
       end
    else
       begin
         FCodVendedor := 0;
         FCodFiscal   := 0;
       end;
  end;
end;}

function AlteraNotaItem(XIdItem: integer; XItem: TJSONObject): TJSONObject;
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
    if XItem.TryGetValue('idproduto',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoProdutoItem"=:xidproduto'
         else
            wcampos := wcampos+',"CodigoProdutoItem"=:xidproduto';
       end;
    if XItem.TryGetValue('idaliquotaicms',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoAliquotaICMSItem"=:xidaliquota'
         else
            wcampos := wcampos+',"CodigoAliquotaICMSItem"=:xidaliquota';
       end;
    if XItem.TryGetValue('idvendedor',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoVendedorItem"=:xidvendedor'
         else
            wcampos := wcampos+',"CodigoVendedorItem"=:xidvendedor';
       end;
    if XItem.TryGetValue('idcodigofiscal',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoFiscalItem"=:xidcodigofiscal'
         else
            wcampos := wcampos+',"CodigoFiscalItem"=:xidcodigofiscal';
       end;
    if XItem.TryGetValue('idsituacaotributaria',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoSituacaoTributariaItem"=:xidsituacaotributaria'
         else
            wcampos := wcampos+',"CodigoSituacaoTributariaItem"=:xidsituacaotributaria';
       end;
    if XItem.TryGetValue('valorunitario',wval) then
       begin
         if wcampos='' then
            wcampos := '"ValorUnitarioItem"=:xvalorunitario '
         else
            wcampos := wcampos+',"ValorUnitarioItem"=:xvalorunitario ';
       end;
    if XItem.TryGetValue('quantidade',wval) then
       begin
         if wcampos='' then
            wcampos := '"QuantidadeItem"=:xquantidade '
         else
            wcampos := wcampos+',"QuantidadeItem"=:xquantidade ';
       end;
    if XItem.TryGetValue('valortotal',wval) then
       begin
         if wcampos='' then
            wcampos := '"ValorTotalItem"=:xvalortotal '
         else
            wcampos := wcampos+',"ValorTotalItem"=:xvalortotal ';
       end;
    if XItem.TryGetValue('percentualdesconto',wval) then
       begin
         if wcampos='' then
            wcampos := '"PercentualDescontoItem"=:xpercentualdesconto '
         else
            wcampos := wcampos+',"PercentualDescontoItem"=:xpercentualdesconto ';
       end;
    if XItem.TryGetValue('valordesconto',wval) then
       begin
         if wcampos='' then
            wcampos := '"ValorDescontoItem"=:xvalordesconto '
         else
            wcampos := wcampos+',"ValorDescontoItem"=:xvalordesconto ';
       end;
    if XItem.TryGetValue('percentualicms',wval) then
       begin
         if wcampos='' then
            wcampos := '"PercentualICMS"=:xpercentualicms '
         else
            wcampos := wcampos+',"PercentualICMS"=:xpercentualicms ';
       end;
    if XItem.TryGetValue('valoricms',wval) then
       begin
         if wcampos='' then
            wcampos := '"ValorICMS"=:xvaloricms '
         else
            wcampos := wcampos+',"ValorICMS"=:xvaloricms ';
       end;
    if XItem.TryGetValue('valorbaseicms',wval) then
       begin
         if wcampos='' then
            wcampos := '"ValorBaseICMSItem"=:xbaseicms '
         else
            wcampos := wcampos+',"ValorBaseICMSItem"=:xbaseicms ';
       end;
    if XItem.TryGetValue('valorbaseicmsst',wval) then
       begin
         if wcampos='' then
            wcampos := '"ValorBaseICMSSubstituicao"=:xbasest '
         else
            wcampos := wcampos+',"ValorBaseICMSSubstituicao"=:xbasest ';
       end;
    if XItem.TryGetValue('valoricmsst',wval) then
       begin
         if wcampos='' then
            wcampos := '"ValorICMSSubstituicao"=:xvalorst '
         else
            wcampos := wcampos+',"ValorICMSSubstituicao"=:xvalorst ';
       end;
    if XItem.TryGetValue('percentualpis',wval) then
       begin
         if wcampos='' then
            wcampos := '"PercentualPISItem"=:xpercentualpis '
         else
            wcampos := wcampos+',"PercentualPISItem"=:xpercentualpis ';
       end;
    if XItem.TryGetValue('percentualcofins',wval) then
       begin
         if wcampos='' then
            wcampos := '"PercentualCOFINSItem"=:xpercentualcofins '
         else
            wcampos := wcampos+',"PercentualCOFINSItem"=:xpercentualcofins ';
       end;
    if XItem.TryGetValue('percentualbasepis',wval) then
       begin
         if wcampos='' then
            wcampos := '"PercentualBasePISItem"=:xpercentualbasepis '
         else
            wcampos := wcampos+',"PercentualBasePISItem"=:xpercentualbasepis ';
       end;
    if XItem.TryGetValue('percentualbasecofins',wval) then
       begin
         if wcampos='' then
            wcampos := '"PercentualBaseCOFINSItem"=:xpercentualbasecofins '
         else
            wcampos := wcampos+',"PercentualBaseCOFINSItem"=:xpercentualbasecofins ';
       end;
    if XItem.TryGetValue('valorpis',wval) then
       begin
         if wcampos='' then
            wcampos := '"ValorPISCreditadoItem"=:xvalorpis '
         else
            wcampos := wcampos+',"ValorPISCreditadoItem"=:xvalorpis ';
       end;
    if XItem.TryGetValue('valorcofins',wval) then
       begin
         if wcampos='' then
            wcampos := '"ValorCofinsCreditadoItem"=:xvalorcofins '
         else
            wcampos := wcampos+',"ValorCofinsCreditadoItem"=:xvalorcofins ';
       end;
    if XItem.TryGetValue('codigocstpis',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoCSTPISItem"=:xcstpis '
         else
            wcampos := wcampos+',"CodigoCSTPISItem"=:xcstpis ';
       end;
    if XItem.TryGetValue('codigocstcofins',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoCSTCOFINSItem"=:xcstcofins '
         else
            wcampos := wcampos+',"CodigoCSTCOFINSItem"=:xcstcofins ';
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
           SQL.Add('Update "NotaItem" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoItem"=:xid ');
           ParamByName('xid').AsInteger      := XIdItem;
           if XItem.TryGetValue('idproduto',wval) then
              ParamByName('xidproduto').AsInteger  := strtoint(XItem.GetValue('idproduto').Value);
           if XItem.TryGetValue('idaliquotaicms',wval) then
              ParamByName('xidaliquota').AsInteger  := strtoint(XItem.GetValue('idaliquotaicms').Value);
           if XItem.TryGetValue('idvendedor',wval) then
              ParamByName('xidvendedor').AsInteger  := strtoint(XItem.GetValue('idvendedor').Value);
           if XItem.TryGetValue('idcodigofiscal',wval) then
              ParamByName('xidcodigofiscal').AsInteger  := strtoint(XItem.GetValue('idcodigofiscal').Value);
           if XItem.TryGetValue('idsituacaotributaria',wval) then
              ParamByName('xidsituacaotributaria').AsInteger  := strtoint(XItem.GetValue('idsituacaotributaria').Value);
           if XItem.TryGetValue('valorunitario',wval) then
              ParamByName('xvalorunitario').AsFloat := strtofloat(XItem.GetValue('valorunitario').Value);
           if XItem.TryGetValue('quantidade',wval) then
              ParamByName('xquantidade').AsFloat := strtofloat(XItem.GetValue('quantidade').Value);
           if XItem.TryGetValue('valortotal',wval) then
              ParamByName('xvalortotal').AsFloat := strtofloat(XItem.GetValue('valortotal').Value);
           if XItem.TryGetValue('percentualdesconto',wval) then
              ParamByName('xpercentualdesconto').AsFloat := strtofloat(XItem.GetValue('percentualdesconto').Value);
           if XItem.TryGetValue('valordesconto',wval) then
              ParamByName('xvalordesconto').AsFloat := strtofloat(XItem.GetValue('valordesconto').Value);
           if XItem.TryGetValue('percentualicms',wval) then
              ParamByName('xpercentualicms').AsFloat := strtofloat(XItem.GetValue('percentualicms').Value);
           if XItem.TryGetValue('valorbaseicms',wval) then
              ParamByName('xbaseicms').AsFloat := strtofloat(XItem.GetValue('valorbaseicms').Value);
           if XItem.TryGetValue('valoricms',wval) then
              ParamByName('xvaloricms').AsFloat := strtofloat(XItem.GetValue('valoricms').Value);
           if XItem.TryGetValue('valorbaseicmsst',wval) then
              ParamByName('xbasest').AsFloat := strtofloat(XItem.GetValue('valorbaseicmsst').Value);
           if XItem.TryGetValue('valoricmsst',wval) then
              ParamByName('xvalorst').AsFloat := strtofloat(XItem.GetValue('valoricmsst').Value);
           if XItem.TryGetValue('percentualpis',wval) then
              ParamByName('xpercentualpis').AsFloat := strtofloat(XItem.GetValue('percentualpis').Value);
           if XItem.TryGetValue('percentualcofins',wval) then
              ParamByName('xpercentualcofins').AsFloat := strtofloat(XItem.GetValue('percentualcofins').Value);
           if XItem.TryGetValue('percentualbasepis',wval) then
              ParamByName('xpercentualbasepis').AsFloat := strtofloat(XItem.GetValue('percentualbasepis').Value);
           if XItem.TryGetValue('percentualbasecofins',wval) then
              ParamByName('xpercentualbasecofins').AsFloat := strtofloat(XItem.GetValue('percentualbasecofins').Value);
           if XItem.TryGetValue('valorpis',wval) then
              ParamByName('xvalorpis').AsFloat := strtofloat(XItem.GetValue('valorpis').Value);
           if XItem.TryGetValue('valorcofins',wval) then
              ParamByName('xvalorcofins').AsFloat := strtofloat(XItem.GetValue('valorcofins').Value);
           if XItem.TryGetValue('codigocstpis',wval) then
              ParamByName('xcstpis').AsString := XItem.GetValue('codigocstpis').Value;
           if XItem.TryGetValue('codigocstcofins',wval) then
              ParamByName('xcstcofins').AsString := XItem.GetValue('codigocstcofins').Value;
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
              SQL.Add('select "CodigoNotaItem"          as idnota,');
              SQL.Add('       "CodigoInternoItem"       as id,');
              SQL.Add('       "NumeroItem"              as numero,');
              SQL.Add('       "CodigoProdutoItem"       as idproduto,');
              SQL.Add('       ts_retornaprodutocodigo("CodigoProdutoItem") as xcodproduto,');
              SQL.Add('       ts_retornaprodutodescricao("CodigoProdutoItem") as xdescproduto,');
              SQL.Add('       ts_retornaprodutounidade("CodigoProdutoItem") as xunidadeproduto,');
              SQL.Add('       ts_retornaprodutocodigobarra("CodigoProdutoItem") as xceanproduto,');
              SQL.Add('       "QuantidadeItem"          as quantidade,');
              SQL.Add('       "ValorUnitarioItem"       as valorunitario,');
              SQL.Add('       "ValorDescontoItem"       as valordesconto,');
              SQL.Add('       "PercentualDescontoItem"  as percentualdesconto,');
              SQL.Add('       "ValorAcrescimoItem"      as valoracrescimo,');
              SQL.Add('       "PercentualAcrescimoItem" as percentualacrescimo,');
              SQL.Add('       "ValorTotalItem"          as valortotal,');
              SQL.Add('       "PercentualIPI"           as percentualipi,');
              SQL.Add('       "ValorIPI"                as valoripi,');
              SQL.Add('       "PercentualICMS"          as percentualicms,');
              SQL.Add('       "ValorICMS"               as valoricms,');
              SQL.Add('       "PercentualBaseICMSItem"  as percentualbaseicms,');
              SQL.Add('       "ValorBaseICMSItem"       as valorbaseicms,');
              SQL.Add('       "ValorDespesaItem"        as valordespesa,');
              SQL.Add('       "ValorFreteItem"          as valorfrete,');
              SQL.Add('       "ValorCustoItem"          as valorcusto,');
              SQL.Add('       "ValorCustoParcialItem"   as valorcustoparcial,');
              SQL.Add('       "ValorCustoContabilItem"  as valorcustocontabil,');
              SQL.Add('       "TipoOperacaoItem"        as tipooperacao,');
              SQL.Add('       "DataMovimentoItem"       as datamovimento,');
              SQL.Add('       "SituacaoNotaItem"        as situacaonota,');
              SQL.Add('       "QuantidadeEmbalagem"     as quantidadeembalagem,');
              SQL.Add('       "QuantidadeEntrada"       as quantidadeentrada,');
              SQL.Add('       "ValorUnitarioEmbalagem"  as valorunitarioembalagem,');
              SQL.Add('       "PercentualICMSSubstituicao" as percentualicmsst,');
              SQL.Add('       "ValorICMSSubstituicao"   as valoricmsst,');
              SQL.Add('       "CodigoAliquotaICMSItem"  as idaliquotaicms,');
              SQL.Add('       ts_retornaaliquotacodigo("CodigoAliquotaICMSItem") as xcodaliquota,');
              SQL.Add('       "CodigoVendedorItem"      as idvendedor,');
              SQL.Add('       ts_retornapessoanome("CodigoVendedorItem") as xvendedor,');
              SQL.Add('       "PercentualComissaoItem"  as percentualcomissao,');
              SQL.Add('       "ValorComissaoItem"       as valorcomissao,');
              SQL.Add('       "ValorEncargoFinanceiroItem" as valorencargofinanceiro,');
              SQL.Add('       "ValorFreteTerceirosItem" as valorfreteterceiros,');
              SQL.Add('       "ValorBonificacaoItem"    as valorbonificacao,');
              SQL.Add('       "ValorAcrescimosItem"     as valoracrescimos,');
              SQL.Add('       "ValorPISCofinsItem"      as valorpiscofins,');
              SQL.Add('       "ValorOutrasDespesasItem" as valoroutrasdespesas,');
              SQL.Add('       "ValorPISCreditadoItem"   as valorpiscreditado,');
              SQL.Add('       "ValorPISDebitadoItem"    as valorpisdebitado,');
              SQL.Add('       "ValorCofinsCreditadoItem" as valorcofinscreditado,');
              SQL.Add('       "ValorCofinsDebitadoItem" as valorcofinsdebitado,');
              SQL.Add('       "ValorPropagandaItem"     as valorpropaganda,');
              SQL.Add('       "ValorResPropagandaItem"  as valorrespropaganda,');
              SQL.Add('       "ValorICMSDebitadoItem"   as valoricmsdebitado,');
              SQL.Add('       "ValorOutrosItem"         as valoroutros,');
              SQL.Add('       "PrecoVendaItem"          as precovenda,');
              SQL.Add('       "PrecoMinimoItem"         as precominimo,');
              SQL.Add('       "ValorBaseICMSSubstituicaoItem" as valorbaseicmsst,');
              SQL.Add('       "TamanhoCalcadoItem"      as tamanho,');
              SQL.Add('       "CodigoCorCalcadoItem"    as idcor,');
              SQL.Add('       ts_retornacornome("CodigoCorCalcadoItem") as xcor,');
              SQL.Add('       "CodigoEmpresaItem"       as idempresa,');
              SQL.Add('       "PercentualPromocionalItem" as percentualpromocional,');
              SQL.Add('       "ValorPromocionalItem"    as valorpromocional,');
              SQL.Add('       "PrecoSugestaoItem"       as precosugestao,');
              SQL.Add('       "DataUltimaAlteracao"     as dataultimaalteracao,');
              SQL.Add('       "OrigemUltimaAlteracao"   as origemultimaalteracao,');
              SQL.Add('       "MargemLucroItem"         as margemlucro,');
              SQL.Add('       "MargemVendaItem"         as margemvenda,');
              SQL.Add('       "ValorDespesaAdicionalItem" as valordespesaadicional,');
              SQL.Add('       "ValorSimplesItem"        as valorsimples,');
              SQL.Add('       "ObservacaoItem"          as observacao,');
              SQL.Add('       "QuantidadeQuebraItem"    as quantidadequebra,');
              SQL.Add('       "CodigoCalculoAreaItem"   as idcalculoarea,');
              SQL.Add('       "EhCompostoProdutoItem"   as ehcompostoproduto,');
              SQL.Add('       "CodigoSituacaoTributariaItem" as idsituacaotributaria,');
              SQL.Add('       ts_retornasituacaotributariacodigo("CodigoSituacaoTributariaItem") as xsituacaotributaria,');
              SQL.Add('       "CodigoFiscalItem"        as idcodigofiscal,');
              SQL.Add('       ts_retornafiscalcodigo("CodigoFiscalItem") as xcodigofiscal,');
              SQL.Add('       "PercentualDiferencaAliquotaItem" as percentualdiferencialaliquota,');
              SQL.Add('       "ValorDiferencaAliquotaItem" as valordiferencialaliquota,');
              SQL.Add('       "DescricaoExtendidaItem"  as descricaoextendida,');
              SQL.Add('       "PercentualBasePISCofinsItem" as percentualbasepiscofins,');
              SQL.Add('       "ValorBasePISCofinsItem"  as valorbasepiscofins,');
              SQL.Add('       "ImpostoRetidoItem"       as impostoretido,');
              SQL.Add('       "PercentualMVAItem"       as percentualmva,');
              SQL.Add('       "PercentualBaseICMSProprioItem" as percentualbaseicmsproprio,');
              SQL.Add('       "ValorBaseICMSProprioItem" as valorbaseicmsproprio,');
              SQL.Add('       "PercentualICMSProprioItem" as percentualicmsproprio,');
              SQL.Add('       "ValorICMSProprioItem"    as valoricmsproprio,');
              SQL.Add('       "QuantidadeDevolvidaItem" as quantidadedevolvida,');
              SQL.Add('       "UtilizaSerigrafiaItem"   as ehutilizaserigrafia,');
              SQL.Add('       "NumeroCoresSerigrafiaItem" as numerocoresserigrafia,');
              SQL.Add('       "ValorSerigrafiaItem"     as valorserigrafia,');
              SQL.Add('       "QuantidadeSerigrafiaItem" as quantidadeserigrafia,');
              SQL.Add('       "ReferenciaItem"          as referencia,');
              SQL.Add('       "PercentualPISItem"       as percentualpis,');
              SQL.Add('       "PercentualCOFINSItem"    as percentualcofins,');
              SQL.Add('       "PercentualBasePISItem"   as percentualbasepis,');
              SQL.Add('       "PercentualBaseCOFINSItem" as percentualbasecofins,');
              SQL.Add('       "CodigoCSTPISItem"        as codigocstpis,');
              SQL.Add('       "CodigoCSTCOFINSItem"     as codigocstcofins,');
              SQL.Add('       "QuantidadeConciliadaItem" as quantidadeconciliada,');
              SQL.Add('       "ValorPrecoOriginalItem"  as valorprecooriginal,');
              SQL.Add('       "TipoPrecoOriginalItem"   as tipoprecooriginal,');
              SQL.Add('       "PrecoVendaCalculadoItem" as precovendacalculado,');
              SQL.Add('       "CustoFinalAnteriorItem"  as custofinalanterior,');
              SQL.Add('       "CustoUnitarioAnteriorItem" as custounitarioanterior,');
              SQL.Add('       "CodigoSituacaoTributariaOriginalItem" as idsituacaotributariaoriginal,');
              SQL.Add('       "CodigoFiscalOriginalItem" as idcodigofiscaloriginal,');
              SQL.Add('       "CodigoAliquotaICMSOriginalItem" as idaliquotaicmsoriginal,');
              SQL.Add('       "PercentualBaseICMSOriginalItem" as percentualbaseicmsoriginal,');
              SQL.Add('       "PercentualICMSOriginal"   as percentualicmsoriginal,');
              SQL.Add('       "ValorICMSOriginal"        as valoricmsoriginal,');
              SQL.Add('       "ValorBaseICMSOriginalItem" as valorbaseicmsoriginal,');
              SQL.Add('       "ValorDescontoProdutoItem"  as valordescontoproduto,');
              SQL.Add('       "PercentualDescontoProdutoItem" as percentualdescontoproduto,');
              SQL.Add('       "PercentualBaseICMSSubstituicaoItem" as percentualbaseicmsst,');
              SQL.Add('       "NumeroFCIProdutoItem"      as numerofciproduto,');
              SQL.Add('       "PercICMSInterPartItem"     as percentualicmsinterno,');
              SQL.Add('       "PercICMSUFDestItem"        as percentualicmsufdestino,');
              SQL.Add('       "PercICMSInterItem"         as percentualicmsinterno,');
              SQL.Add('       "ValorICMSUFDestItem"       as valoricmsufdestino,');
              SQL.Add('       "ValorICMSUFRemetItem"      as valoricmsufremetente,');
              SQL.Add('       "PercentualDiferimentoItem" as percentualdiferimento,');
              SQL.Add('       "ValorICMSDiferimento"      as valoricmsdiferimento,');
              SQL.Add('       "ValorICMSOperacao"         as valoricmsoperacao,');
              SQL.Add('       "NumeroItemOrdemCompraItem" as numeroitemordemcompra,');
              SQL.Add('       "ValorIOFItem"              as valoriof,');
              SQL.Add('       "ValorImpostoImportacaoItem" as valorimpostoimportacao,');
              SQL.Add('       "ValorBaseImpostoImportacaoItem" as valorbaseimpostoimportacao,');
              SQL.Add('       "ValorDespesaAduaneiraItem" as valordespesaaduaneira,');
              SQL.Add('       "TipoOperacaoMovimentoItem" as tipooperacaomovimento,');
              SQL.Add('       "ValorBaseCalculoFCPItem"   as valorbasecalculofcp,');
              SQL.Add('       "PercentualFCPItem"         as percentualfcp,');
              SQL.Add('       "ValorFCPItem"              as valorfcp,');
              SQL.Add('       "ValorBaseCalculoFCPSTItem" as valorbasecalculofcpst,');
              SQL.Add('       "PercentualFCPSTItem"       as percentualfcpst,');
              SQL.Add('       "ValorFCPSTItem"            as valorfcp,');
              SQL.Add('       "ValorBaseCalculoFCPSTRetItem" as valorbasecalculofcpstretido,');
              SQL.Add('       "PercentualFCPSTRetItem"    as percentualfcpstretido,');
              SQL.Add('       "ValorFCPSTRetItem"         as valorfcpstretido,');
              SQL.Add('       "ValorBaseCalculoSTRetItem" as valorbasecalculostretido,');
              SQL.Add('       "ValorICMSSubstituicaoRetItem" as valoricmsstretido,');
              SQL.Add('       "ValorICMSSubstitutoItem"   as valoricmssubstituto,');
              SQL.Add('       "PercentualSubstituicaoItem" as percentualst,');
              SQL.Add('       "ValorSTDebitadoItem"       as valorstdebitado,');
              SQL.Add('       "ValorSTCreditadoItem"      as valorstcreditado,');
              SQL.Add('       "EstruturalProdutoItem"     as estruturalproduto,');
              SQL.Add('       cast((select "PercentualPISConfigura" from "ConfiguracaoTSCompras" where "CodigoEmpresaConfigura"=:xidempresa) as numeric) as xpercpis,');
              SQL.Add('       cast((select "PercentualCofinsConfigura" from "ConfiguracaoTSCompras" where "CodigoEmpresaConfigura"=:xidempresa) as numeric) as xperccofins ');
              SQL.Add('from "NotaItem" ');
              SQL.Add('where "CodigoInternoItem" =:xid ');
              ParamByName('xid').AsInteger := XIdItem;
              ParamByName('xidempresa').AsInteger := wconexao.FIdEmpresa;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum ítem alterado');
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
end;

{procedure AtribuiFotoProduto(XCodigo: string; XQuery: TFDQuery);
var warquivo,wcaminho: string;
    wbase64: widestring;
    warqini: TIniFile;
    wmaximo: integer;
    wexibe: boolean;
begin
  if FileExists(GetCurrentDir+'\TrabinApi.ini') then
     begin
       warqini  := TIniFile.Create(GetCurrentDir+'\TrabinApi.ini');
       wcaminho := warqini.ReadString('Fotos','Caminho','');
       wmaximo  := warqini.ReadInteger('Fotos','TamanhoMaximo(Kb)',300);
       wexibe   := UpperCase(warqini.ReadString('Fotos','Exibir','Não'))='SIM';
     end
  else
     begin
       wcaminho   := GetCurrentDir+'\fotos';
       wmaximo    := 300;
       wexibe     := false;
     end;

  if wexibe then
     begin
       if fileexists(wcaminho+'\'+XCodigo+'_1.jpg') then
          warquivo := wcaminho+'\'+XCodigo+'_1.jpg'
       else
          warquivo := wcaminho+'\'+XCodigo+'.jpg';
       if FileExists(warquivo) then
          begin
            wbase64 := RetornaBase64(warquivo,wmaximo);
            XQuery.Edit;
            XQuery.FieldByName('foto').ReadOnly := false;
            XQuery.FieldByName('foto').AsWideString := wbase64;
            XQuery.Post;
          end;
     end;
end;

function RetornaBase64(XArquivo: string; XMaximo: integer): widestring;
var wstream: TFileStream;
    wvalor: widestring;
begin
  try
    wstream := TFileStream.Create(XArquivo,fmOpenRead);
    if wstream.Size<=(XMaximo*1024) then // tamanho em bytes
       wvalor  := TIdEncoderMIME.EncodeStream(wstream)
    else
       wvalor  := '';
  except
    On E: Exception do
    begin
      FreeAndNil(wstream);
      wvalor := '';
    end;
  end;
  FreeAndNil(wstream);
  Result := wvalor;
end;}
end.
