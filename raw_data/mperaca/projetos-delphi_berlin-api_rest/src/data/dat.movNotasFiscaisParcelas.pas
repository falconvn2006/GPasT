unit dat.movNotasFiscaisParcelas;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaNotaFiscalParcela(XNota,XId: integer): TJSONObject;
function RetornaNotaFiscalParcelas(const XQuery: TDictionary<string, string>; XNota,XLimit,XOffset: integer): TJSONArray;
function RetornaTotalParcelas(const XQuery: TDictionary<string, string>; XIdNota: integer): TJSONObject;

implementation

uses prv.dataModuleConexao;

var FNumItem,FIdItem,FCodProduto,FCodAliquota,FCodVendedor,FCodFiscal,FCodSitTrib: integer;
    FQtde,FUnitario,FTotal: double;
    FIncideST: boolean;
    FDatMov: tdatetime;


function RetornaNotaFiscalParcela(XNota,XId: integer): TJSONObject;
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
         SQL.Add('select  "CodigoInternoParcela"       as id,');
         SQL.Add('        "CodigoEmpresaParcela"       as idempresa,');
         SQL.Add('        "CodigoDocFiscalParcela"     as idnota,');
         SQL.Add('        "NumeroDocumentoParcela"     as numerodocumento,');
         SQL.Add('        "NumeroParcela"              as numero,');
         SQL.Add('        "DesdobramentoParcela"       as desdobramento,');
         SQL.Add('        "NumeroPagamentosParcela"    as numeropagamentos,');
         SQL.Add('        "DataEmissaoParcela"         as dataemissao,');
         SQL.Add('        "DataVencimentoParcela"      as datavencimento,');
         SQL.Add('        "CodigoCondicaoParcela"      as idcondicao,');
         SQL.Add('        ts_retornacondicaodescricao("CodigoCondicaoParcela") as xcondicao,');
         SQL.Add('        "CodigoFornecedorParcela"    as idfornecedor,');
         SQL.Add('        ts_retornapessoanome("CodigoFornecedorParcela") as xfornecedor,');
         SQL.Add('        "CodigoClienteParcela"       as idcliente,');
         SQL.Add('        ts_retornapessoanome("CodigoClienteParcela") as xcliente,');
         SQL.Add('        "CodigoRepresentanteParcela" as idvendedor,');
         SQL.Add('        ts_retornapessoanome("CodigoRepresentanteParcela") as xvendedor,');
         SQL.Add('        "CodigoPortadorParcela"      as idportador,');
         SQL.Add('        ts_retornapessoanome("CodigoPortadorParcela") as xportador,');
         SQL.Add('        "CodigoIndexadorParcela"     as idindexador,');
         SQL.Add('        "ValorOriginalParcela"       as valororiginal,');
         SQL.Add('        "ValorIndiceParcela"         as valorindice,');
         SQL.Add('        "PercentualCorrecaoParcela"  as percentualcorrecao,');
         SQL.Add('        "ValorCorrecaoParcela"       as valorcorrecao,');
         SQL.Add('        "PercentualJuroParcela"      as percentualjuro,');
         SQL.Add('        "ValorJuroParcela"           as valorjuro,');
         SQL.Add('        "PercentualMultaParcela"     as percentualmulta,');
         SQL.Add('        "ValorMultaParcela"          as valormulta,');
         SQL.Add('        "PercentualDescontoParcela"  as percentualdesconto,');
         SQL.Add('        "ValorDescontoParcela"       as valordesconto,');
         SQL.Add('        "ValorFinalParcela"          as valorfinal,');
         SQL.Add('        "FormaPagamentoParcela"      as idformapagamento,');
         SQL.Add('        "SituacaoParcela"            as situacao,');
         SQL.Add('        "TipoDocumentoParcela"       as idclassificacao,');
         SQL.Add('        ts_retornaclassificacaodescricao("TipoDocumentoParcela") as xclassificacao,');
         SQL.Add('        "TipoMovimentoParcela"       as tipomovimento,');
         SQL.Add('        "TipoOperacaoParcela"        as tipooperacao,');
         SQL.Add('        "DataOperacaoParcela"        as dataoperacao,');
         SQL.Add('        "CodigoBancoPagamentoParcela" as idbancopagamento,');
         SQL.Add('        ts_retornapessoanome("CodigoBancoPagamentoParcela") as xbancopagamento,');
         SQL.Add('        "ChequePagamentoParcela"     as chequepagamento,');
         SQL.Add('        "ObservacaoParcela"          as observacao,');
         SQL.Add('        "OrigemParcela"              as origem,');
         SQL.Add('        "CodigoDocumentoCobrancaParcela" as iddocumentocobranca,');
         SQL.Add('        ts_retornadocumentocobrancadescricao("CodigoDocumentoCobrancaParcela") as xcobranca,');
         SQL.Add('        "DataApresentacaoParcela"    as dataapresentacao,');
         SQL.Add('        "DataQuitacaoAutomaticaParcela"  as dataquitacaoautomatica,');
         SQL.Add('        "CodigoUsuarioOperacaoParcela"   as idusuarioperacao,');
         SQL.Add('        "NumeroCaixaParcela"         as numerocaixa,');
         SQL.Add('        "UsuarioParcela"             as idusuario,');
         SQL.Add('        "DocumentoAntigoParcela"     as documentoantigo,');
         SQL.Add('        "ImprimeFaturaParcela"       as ehimprimefatura,');
         SQL.Add('        "OrigemQuitacaoParcela"      as origemquitacao,');
         SQL.Add('        "PrefixoOrigemParcela"       as prefixoorigem,');
         SQL.Add('        "PrefixoPagamentoParcela"    as prefixopagamento,');
         SQL.Add('        "DataLancamentoParcela"      as datalancamento,');
         SQL.Add('        "NumeroCaixaQuitacaoParcela" as numerocaixaquitacao,');
         SQL.Add('        "UsuarioUltimaAlteracao"     as idusuarioultimaalteracao,');
         SQL.Add('        "DataUltimaAlteracao"        as dataultimaalteracao,');
         SQL.Add('        "OrigemUltimaAlteracao"      as origemultimaalteracao,');
         SQL.Add('        "OrdemServicoParcela"        as ordemservico,');
         SQL.Add('        "NumeroGeracaoRemessaParcela"    as numerogeracaoremessa,');
         SQL.Add('        "GeracaoRemessaConcluidaParcela" as ehgeracaoremessaconcluida,');
         SQL.Add('        "AnoExercicioParcela"            as anoexercicio,');
         SQL.Add('        "CodigoPortadorOriginalParcela"  as idportadororiginal,');
         SQL.Add('        "DataHoraGeracaoLotericaParcela" as datahorageracaoloterica,');
         SQL.Add('        "DataHoraRetornoLotericaParcela" as datahoraretornoloterica,');
         SQL.Add('        "UsuarioProcessouRetornoLotericaParcela"  as idusuarioprocessouretornoloterica,');
         SQL.Add('        "NomeArquivoRetornoLotericaParcela"       as nomearquivoretornoloterica,');
         SQL.Add('        "CodigoBarraLotericaParcela"              as codigobarraloterica,');
         SQL.Add('        "LinhaDigitavelLotericaParcela"           as linhadigitavelloterica,');
         SQL.Add('        "LinhaRetornoLotericaParcela"             as linharetornoloterica,');
         SQL.Add('        "DataHoraRetornoBloquetoSICOBParcela"     as datahoraretornobloquetosicob,');
         SQL.Add('        "DataHoraGeracaoBloquetoSICOBParcela"     as datahorageracaobloquetosicob,');
         SQL.Add('        "UsuarioProcessouRetornoBloquetoSICOBParcela" as idusuarioprocessouretornobloquetosicob,');
         SQL.Add('        "CodigoBarraBloquetoSICOBParcela"         as codigobarrabloquetosicob,');
         SQL.Add('        "LinhaDigitavelBloquetoSICOBParcela"      as linhadigitavelbloquetosicob,');
         SQL.Add('        "AgenciaCodCedenteDVBloquetoSICOBParcela" as agenciacodcedentedvbloquetosicob,');
         SQL.Add('        "NossoNumeroDVBloquetoSICOBParcela"       as nossonumerodvbloquetosicob,');
         SQL.Add('        "NumeroSequencialBloquetoSICOBParcela"    as numerosequencialbloquetosicob,');
         SQL.Add('        "DataHoraRetornoBloquetoBancoBrasilParcela"     as datahoraretornobloquetobancobrasil,');
         SQL.Add('        "DataHoraGeracaoBloquetoBancoBrasilParcela"     as datahorageracaobloquetobancobrasil,');
         SQL.Add('        "UsuarioProcessouRetornoBloquetoBancoBrasilParcela" as idusuarioprocessouretornobloquetobancobrasil,');
         SQL.Add('        "CodigoBarraBloquetoBancoBrasilParcela"         as codigobarrabloquetobancobrasil,');
         SQL.Add('        "LinhaDigitavelBloquetoBancoBrasilParcela"      as linhadigitavelbloquetobancobrasil,');
         SQL.Add('        "AgenciaCodCedenteDVBloquetoBancoBrasilParcela" as agenciacodcedentedvbloquetobancobrasil,');
         SQL.Add('        "NumeroSequencialBloquetoBancoBrasilParcela"    as numerosequencialbloquetobancobrasil,');
         SQL.Add('        "NossoNumeroBloquetoBancoBrasilParcela"         as nossonumerobloquetobancobrasil,');
         SQL.Add('        "NomeArquivoRetornoBancoBrasilParcela"          as nomearquivoretornobancobrasil,');
         SQL.Add('        "LinhaRetornoSegmentoTBancoBrasilParcela"       as linharetornosegmentotbancobrasil,');
         SQL.Add('        "LinhaRetornoSegmentoUBancoBrasilParcela"       as linharetornosegmentoubancobrasil,');
         SQL.Add('        "DataHoraGeracaoBloquetoBanrisulParcela"        as datahorageracaobloquetobanrisul,');
         SQL.Add('        "DataHoraRetornoBloquetoBanrisulParcela"        as datahoraretornobloquetobanrisul,');
         SQL.Add('        "UsuarioProcessouRetornoBloquetoBanrisulParcela" as idusuarioprocessouretornobloquetobanrisul,');
         SQL.Add('        "CodigoBarraBloquetoBanrisulParcela"            as codigobarrabloquetobanrisul,');
         SQL.Add('        "LinhaDigitavelBloquetoBanrisulParcela"         as linhadigitavelbloquetobanrisul,');
         SQL.Add('        "AgenciaCodCedenteDVBloquetoBanrisulParcela"    as agenciacodcedentedvbloquetobanrisul,');
         SQL.Add('        "NossoNumeroBloquetoBanrisulParcela"            as nossonumerobloquetobanrisul,');
         SQL.Add('        "NomeArquivoRetornoBanrisulParcela"             as nomearquivoretornobanrisul,');
         SQL.Add('        "NumeroSequencialBloquetoBanrisulParcela"       as numerosequencialbloquetobanrisul,');
         SQL.Add('        "LinhaRetornoSegmentoTBanrisulParcela"          as linharetornosegmentotbanrisul,');
         SQL.Add('        "LinhaRetornoSegmentoUBanrisulParcela"          as linharetornosegmentoubanrisul,');
         SQL.Add('        "DataHoraGeracaoBloquetoBancoItauParcela"       as datahorageracaobloquetobancoitau,');
         SQL.Add('        "DataHoraRetornoBloquetoBancoItauParcela"       as datahoraretornobloquetobancoitau,');
         SQL.Add('        "UsuarioProcessouRetornoBloquetoBancoItauParcela" as idusuarioprocessouretornobloquetobancoitau,');
         SQL.Add('        "CodigoBarraBloquetoBancoItauParcela"           as codigobarrabloquetobancoitau,');
         SQL.Add('        "LinhaDigitavelBloquetoBancoItauParcela"        as linhadigitavelbloquetobancoitau,');
         SQL.Add('        "AgenciaCodCedenteDVBloquetoBancoItauParcela"   as agenciacodcedentedvbloquetobancoitau,');
         SQL.Add('        "NomeArquivoRetornoBancoItauParcela"            as nomearquivoretornobancoitau,');
         SQL.Add('        "NumeroSequencialBloquetoBancoItauParcela"      as numerosequencialbloquetobancoitau,');
         SQL.Add('        "LinhaRetornoSegmentoTBancoItauParcela"         as linharetornosegmentotbancoitau,');
         SQL.Add('        "LinhaRetornoSegmentoUBancoItauParcela"         as linharetornosegmentoubancoitau,');
         SQL.Add('        "NossoNumeroBloquetoBancoItauParcela"           as nossonumerobloquetobancoitau,');
         SQL.Add('        "DataHoraGeracaoBloquetoBancoSicrediParcela"    as datahorageracaobloquetobancosicredi,');
         SQL.Add('        "DataHoraRetornoBloquetoBancoSicrediParcela"    as datahoraretornobloquetobancosicredi,');
         SQL.Add('        "UsuarioProcessouRetornoBloquetoBancoSicrediParcela" as idusuarioprocessouretornobloquetobancosicredi,');
         SQL.Add('        "CodigoBarraBloquetoBancoSicrediParcela"        as codigobarrabloquetobancosicredi,');
         SQL.Add('        "LinhaDigitavelBloquetoBancoSicrediParcela"     as linhadigitavelbloquetobancosicredi,');
         SQL.Add('        "AgenciaCodCedenteDVBloquetoBancoSicrediParcela" as agenciacodcedentedvbloquetobancosicredi,');
         SQL.Add('        "NomeArquivoRetornoBancoSicrediParcela"          as nomearquivoretornobancosicredi,');
         SQL.Add('        "NumeroSequencialBloquetoBancoSicrediParcela"    as numerosequencialbloquetobancosicredi,');
         SQL.Add('        "LinhaRetornoSegmentoTBancoSicrediParcela"       as linharetornosegmentotbancosicredi,');
         SQL.Add('        "LinhaRetornoSegmentoUBancoSicrediParcela"       as linharetornosegmentoubancosicredi,');
         SQL.Add('        "NossoNumeroBloquetoBancoSicrediParcela"         as nossonumerobloquetobancosicredi,');
         SQL.Add('        "NomeArquivoRetornoBloquetoSICOBParcela"         as nomearquivoretornobloquetosicob,');
         SQL.Add('        "LinhaRetornoSegmentoTBloquetoSICOBParcela"      as linharetornosegmentotbloquetosicob,');
         SQL.Add('        "LinhaRetornoSegmentoUBloquetoSICOBParcela"      as linharetornosegmentoubloquetosicob,');
         SQL.Add('        "LogMovimentacaoParcela"                         as logmovimentacao,');
         SQL.Add('        "ValorPISParcela"                                as valorpis,');
         SQL.Add('        "ValorCOFINSParcela"                             as valorcofins,');
         SQL.Add('        "ValorIRParcela"                                 as valorir,');
         SQL.Add('        "ValorCSParcela"                                 as valorcs,');
         SQL.Add('        "ValorINSSParcela"                               as valorinss,');
         SQL.Add('        "ValorISSQNParcela"                              as valorissqn,');
         SQL.Add('        "TotalRetencoesParcela"                          as totalretencoes,');
         SQL.Add('        "EhExcessaoContabilidadeParcela"                 as ehexcessaocontabilidade,');
         SQL.Add('        "LancamentoContabilEfetuadoParcela"              as ehlancamentocontabilefetuado,');
         SQL.Add('        "DataHoraRetornoBloquetoBancoSantanderParcela"   as datahoraretornobloquetobancosantander,');
         SQL.Add('        "DataHoraGeracaoBloquetoBancoSantanderParcela"   as datahorageracaobloquetobancosantander,');
         SQL.Add('        "UsuarioProcessouRetornoBloquetoBancoSantanderParcela" as idusuarioprocessouretornobloquetobancosantander,');
         SQL.Add('        "CodigoBarraBloquetoBancoSantanderParcela"       as codigbarrabloquetobancosantander,');
         SQL.Add('        "LinhaDigitavelBloquetoBancoSantanderParcela"    as linhadigitavelbloquetobancosantander,');
         SQL.Add('        "AgenciaCodCedenteDVBloquetoBancoSantanderParcela" as agenciacodcedentedvbloquetobancosantander,');
         SQL.Add('        "NumeroSequencialBloquetoBancoSantanderParcela"  as numerosequencialbloquetobancosantander,');
         SQL.Add('        "NossoNumeroBloquetoBancoSantanderParcela"       as nossonumerobloquetobancosantander,');
         SQL.Add('        "NomeArquivoRetornoBancoSantanderParcela"        as nomearquivoretornobancosantander,');
         SQL.Add('        "LinhaRetornoSegmentoTBancoSantanderParcela"     as linharetornosegmentotbancosantander,');
         SQL.Add('        "LinhaRetornoSegmentoUBancoSantanderParcela"     as linharetornosegmentoubancosantander,');
         SQL.Add('        "CodigoParcelaDesdobradaParcela"                 as idparceladesdobrada,');
         SQL.Add('        "ParcelaFaturadaParcela"                         as ehparcelafaturada,');
         SQL.Add('        "CodigoInternoFaturadaParcela"                   as idfaturada,');
         SQL.Add('        "LogAlteracaoParcela"                            as logalteracao,');
         SQL.Add('        "IdNFeParcela"                                   as chavenfe,');
         SQL.Add('        "DataUltimaOperacaoParcela"                      as dataultimaoperacao,');
         SQL.Add('        "ProcessamentoRetornoConcluidoParcela"           as ehprocessamentoretornoconcluido,');
         SQL.Add('        "CodigoPessoaDevolucaoParcela"                   as idpessoadevolucao,');
         SQL.Add('        "IDAssinaturaLanctoBancarioParcela"              as idassinaturalancamentobancario,');
         SQL.Add('        "DataHoraRetornoBloquetoBancoSicoobParcela"      as datahoraretornobloquetobancosicoob,');
         SQL.Add('        "UsuarioProcessouRetornoBloquetoBancoSicoobParcela" as idusuarioprocessouretornobloquetobancosicoob,');
         SQL.Add('        "CodigoBarraBloquetoBancoSicoobParcela"          as codigobarrabloquetobancosicoob,');
         SQL.Add('        "LinhaDigitavelBloquetoBancoSicoobParcela"       as linhadigitavelbloquetobancosicoob,');
         SQL.Add('        "AgenciaCodCedenteDVBloquetoBancoSicoobParcela"  as agenciacodcedentedvbloquetobancosicoob,');
         SQL.Add('        "NomeArquivoRetornoBancoSicoobParcela"           as nomearquivoretornobancosicoob,');
         SQL.Add('        "NumeroSequencialBloquetoBancoSicoobParcela"     as numerosequencialbloquetobancosicoob,');
         SQL.Add('        "LinhaRetornoSegmentoTBancoSicoobParcela"        as linharetornosegmentotbancosicoob,');
         SQL.Add('        "LinhaRetornoSegmentoUBancoSicoobParcela"        as linharetornosegmentoubancosicoob,');
         SQL.Add('        "NossoNumeroBloquetoBancoSicoobParcela"          as nossonumerobloquetobancosicoob,');
         SQL.Add('        "DataHoraGeracaoBloquetoBancoSicoobParcela"      as datahorageracaobloquetobancosicoob ');
         SQL.Add('from "Parcela" where "CodigoDocFiscalParcela"=:xnota and "CodigoInternoParcela"=:xid ');
         ParamByName('xnota').AsInteger := XNota;
         ParamByName('xid').AsInteger  := XId;
         Open;
         EnableControls;
       end;
   if wquery.RecordCount>0 then
      wret := wquery.ToJSONObject()
   else
      begin
        wret := TJSONObject.Create;
        wret.AddPair('status','404');
        wret.AddPair('description','Nenhuma parcela encontrada');
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

{function ApagaNFePendenteParcelaem(XNFe,XId: integer): TJSONObject;
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
         SQL.Add('delete from "NotaItem" where "CodigoNotaItem"=:xnfe and "CodigoInternoItem"=:xid ');
         ParamByName('xnfe').AsInteger := XNFe;
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
end;}

function RetornaNotaFiscalParcelas(const XQuery: TDictionary<string, string>; XNota,XLimit,XOffset: integer): TJSONArray;
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
         SQL.Add('select  "CodigoInternoParcela"       as id,');
         SQL.Add('        "CodigoEmpresaParcela"       as idempresa,');
         SQL.Add('        "CodigoDocFiscalParcela"     as idnota,');
         SQL.Add('        "NumeroDocumentoParcela"     as numerodocumento,');
         SQL.Add('        "NumeroParcela"              as numero,');
         SQL.Add('        "DesdobramentoParcela"       as desdobramento,');
         SQL.Add('        "NumeroPagamentosParcela"    as numeropagamentos,');
         SQL.Add('        "DataEmissaoParcela"         as dataemissao,');
         SQL.Add('        "DataVencimentoParcela"      as datavencimento,');
         SQL.Add('        "CodigoCondicaoParcela"      as idcondicao,');
         SQL.Add('        ts_retornacondicaodescricao("CodigoCondicaoParcela") as xcondicao,');
         SQL.Add('        "CodigoFornecedorParcela"    as idfornecedor,');
         SQL.Add('        ts_retornapessoanome("CodigoFornecedorParcela") as xfornecedor,');
         SQL.Add('        "CodigoClienteParcela"       as idcliente,');
         SQL.Add('        ts_retornapessoanome("CodigoClienteParcela") as xcliente,');
         SQL.Add('        "CodigoRepresentanteParcela" as idvendedor,');
         SQL.Add('        ts_retornapessoanome("CodigoRepresentanteParcela") as xvendedor,');
         SQL.Add('        "CodigoPortadorParcela"      as idportador,');
         SQL.Add('        ts_retornapessoanome("CodigoPortadorParcela") as xportador,');
         SQL.Add('        "CodigoIndexadorParcela"     as idindexador,');
         SQL.Add('        "ValorOriginalParcela"       as valororiginal,');
         SQL.Add('        "ValorIndiceParcela"         as valorindice,');
         SQL.Add('        "PercentualCorrecaoParcela"  as percentualcorrecao,');
         SQL.Add('        "ValorCorrecaoParcela"       as valorcorrecao,');
         SQL.Add('        "PercentualJuroParcela"      as percentualjuro,');
         SQL.Add('        "ValorJuroParcela"           as valorjuro,');
         SQL.Add('        "PercentualMultaParcela"     as percentualmulta,');
         SQL.Add('        "ValorMultaParcela"          as valormulta,');
         SQL.Add('        "PercentualDescontoParcela"  as percentualdesconto,');
         SQL.Add('        "ValorDescontoParcela"       as valordesconto,');
         SQL.Add('        "ValorFinalParcela"          as valorfinal,');
         SQL.Add('        "FormaPagamentoParcela"      as idformapagamento,');
         SQL.Add('        "SituacaoParcela"            as situacao,');
         SQL.Add('        "TipoDocumentoParcela"       as idclassificacao,');
         SQL.Add('        ts_retornaclassificacaodescricao("TipoDocumentoParcela") as xclassificacao,');
         SQL.Add('        "TipoMovimentoParcela"       as tipomovimento,');
         SQL.Add('        "TipoOperacaoParcela"        as tipooperacao,');
         SQL.Add('        "DataOperacaoParcela"        as dataoperacao,');
         SQL.Add('        "CodigoBancoPagamentoParcela" as idbancopagamento,');
         SQL.Add('        ts_retornapessoanome("CodigoBancoPagamentoParcela") as xbancopagamento,');
         SQL.Add('        "ChequePagamentoParcela"     as chequepagamento,');
         SQL.Add('        "ObservacaoParcela"          as observacao,');
         SQL.Add('        "OrigemParcela"              as origem,');
         SQL.Add('        "CodigoDocumentoCobrancaParcela" as iddocumentocobranca,');
         SQL.Add('        ts_retornadocumentocobrancadescricao("CodigoDocumentoCobrancaParcela") as xcobranca,');
         SQL.Add('        "DataApresentacaoParcela"    as dataapresentacao,');
         SQL.Add('        "DataQuitacaoAutomaticaParcela"  as dataquitacaoautomatica,');
         SQL.Add('        "CodigoUsuarioOperacaoParcela"   as idusuarioperacao,');
         SQL.Add('        "NumeroCaixaParcela"         as numerocaixa,');
         SQL.Add('        "UsuarioParcela"             as idusuario,');
         SQL.Add('        "DocumentoAntigoParcela"     as documentoantigo,');
         SQL.Add('        "ImprimeFaturaParcela"       as ehimprimefatura,');
         SQL.Add('        "OrigemQuitacaoParcela"      as origemquitacao,');
         SQL.Add('        "PrefixoOrigemParcela"       as prefixoorigem,');
         SQL.Add('        "PrefixoPagamentoParcela"    as prefixopagamento,');
         SQL.Add('        "DataLancamentoParcela"      as datalancamento,');
         SQL.Add('        "NumeroCaixaQuitacaoParcela" as numerocaixaquitacao,');
         SQL.Add('        "UsuarioUltimaAlteracao"     as idusuarioultimaalteracao,');
         SQL.Add('        "DataUltimaAlteracao"        as dataultimaalteracao,');
         SQL.Add('        "OrigemUltimaAlteracao"      as origemultimaalteracao,');
         SQL.Add('        "OrdemServicoParcela"        as ordemservico,');
         SQL.Add('        "NumeroGeracaoRemessaParcela"    as numerogeracaoremessa,');
         SQL.Add('        "GeracaoRemessaConcluidaParcela" as ehgeracaoremessaconcluida,');
         SQL.Add('        "AnoExercicioParcela"            as anoexercicio,');
         SQL.Add('        "CodigoPortadorOriginalParcela"  as idportadororiginal,');
         SQL.Add('        "DataHoraGeracaoLotericaParcela" as datahorageracaoloterica,');
         SQL.Add('        "DataHoraRetornoLotericaParcela" as datahoraretornoloterica,');
         SQL.Add('        "UsuarioProcessouRetornoLotericaParcela"  as idusuarioprocessouretornoloterica,');
         SQL.Add('        "NomeArquivoRetornoLotericaParcela"       as nomearquivoretornoloterica,');
         SQL.Add('        "CodigoBarraLotericaParcela"              as codigobarraloterica,');
         SQL.Add('        "LinhaDigitavelLotericaParcela"           as linhadigitavelloterica,');
         SQL.Add('        "LinhaRetornoLotericaParcela"             as linharetornoloterica,');
         SQL.Add('        "DataHoraRetornoBloquetoSICOBParcela"     as datahoraretornobloquetosicob,');
         SQL.Add('        "DataHoraGeracaoBloquetoSICOBParcela"     as datahorageracaobloquetosicob,');
         SQL.Add('        "UsuarioProcessouRetornoBloquetoSICOBParcela" as idusuarioprocessouretornobloquetosicob,');
         SQL.Add('        "CodigoBarraBloquetoSICOBParcela"         as codigobarrabloquetosicob,');
         SQL.Add('        "LinhaDigitavelBloquetoSICOBParcela"      as linhadigitavelbloquetosicob,');
         SQL.Add('        "AgenciaCodCedenteDVBloquetoSICOBParcela" as agenciacodcedentedvbloquetosicob,');
         SQL.Add('        "NossoNumeroDVBloquetoSICOBParcela"       as nossonumerodvbloquetosicob,');
         SQL.Add('        "NumeroSequencialBloquetoSICOBParcela"    as numerosequencialbloquetosicob,');
         SQL.Add('        "DataHoraRetornoBloquetoBancoBrasilParcela"     as datahoraretornobloquetobancobrasil,');
         SQL.Add('        "DataHoraGeracaoBloquetoBancoBrasilParcela"     as datahorageracaobloquetobancobrasil,');
         SQL.Add('        "UsuarioProcessouRetornoBloquetoBancoBrasilParcela" as idusuarioprocessouretornobloquetobancobrasil,');
         SQL.Add('        "CodigoBarraBloquetoBancoBrasilParcela"         as codigobarrabloquetobancobrasil,');
         SQL.Add('        "LinhaDigitavelBloquetoBancoBrasilParcela"      as linhadigitavelbloquetobancobrasil,');
         SQL.Add('        "AgenciaCodCedenteDVBloquetoBancoBrasilParcela" as agenciacodcedentedvbloquetobancobrasil,');
         SQL.Add('        "NumeroSequencialBloquetoBancoBrasilParcela"    as numerosequencialbloquetobancobrasil,');
         SQL.Add('        "NossoNumeroBloquetoBancoBrasilParcela"         as nossonumerobloquetobancobrasil,');
         SQL.Add('        "NomeArquivoRetornoBancoBrasilParcela"          as nomearquivoretornobancobrasil,');
         SQL.Add('        "LinhaRetornoSegmentoTBancoBrasilParcela"       as linharetornosegmentotbancobrasil,');
         SQL.Add('        "LinhaRetornoSegmentoUBancoBrasilParcela"       as linharetornosegmentoubancobrasil,');
         SQL.Add('        "DataHoraGeracaoBloquetoBanrisulParcela"        as datahorageracaobloquetobanrisul,');
         SQL.Add('        "DataHoraRetornoBloquetoBanrisulParcela"        as datahoraretornobloquetobanrisul,');
         SQL.Add('        "UsuarioProcessouRetornoBloquetoBanrisulParcela" as idusuarioprocessouretornobloquetobanrisul,');
         SQL.Add('        "CodigoBarraBloquetoBanrisulParcela"            as codigobarrabloquetobanrisul,');
         SQL.Add('        "LinhaDigitavelBloquetoBanrisulParcela"         as linhadigitavelbloquetobanrisul,');
         SQL.Add('        "AgenciaCodCedenteDVBloquetoBanrisulParcela"    as agenciacodcedentedvbloquetobanrisul,');
         SQL.Add('        "NossoNumeroBloquetoBanrisulParcela"            as nossonumerobloquetobanrisul,');
         SQL.Add('        "NomeArquivoRetornoBanrisulParcela"             as nomearquivoretornobanrisul,');
         SQL.Add('        "NumeroSequencialBloquetoBanrisulParcela"       as numerosequencialbloquetobanrisul,');
         SQL.Add('        "LinhaRetornoSegmentoTBanrisulParcela"          as linharetornosegmentotbanrisul,');
         SQL.Add('        "LinhaRetornoSegmentoUBanrisulParcela"          as linharetornosegmentoubanrisul,');
         SQL.Add('        "DataHoraGeracaoBloquetoBancoItauParcela"       as datahorageracaobloquetobancoitau,');
         SQL.Add('        "DataHoraRetornoBloquetoBancoItauParcela"       as datahoraretornobloquetobancoitau,');
         SQL.Add('        "UsuarioProcessouRetornoBloquetoBancoItauParcela" as idusuarioprocessouretornobloquetobancoitau,');
         SQL.Add('        "CodigoBarraBloquetoBancoItauParcela"           as codigobarrabloquetobancoitau,');
         SQL.Add('        "LinhaDigitavelBloquetoBancoItauParcela"        as linhadigitavelbloquetobancoitau,');
         SQL.Add('        "AgenciaCodCedenteDVBloquetoBancoItauParcela"   as agenciacodcedentedvbloquetobancoitau,');
         SQL.Add('        "NomeArquivoRetornoBancoItauParcela"            as nomearquivoretornobancoitau,');
         SQL.Add('        "NumeroSequencialBloquetoBancoItauParcela"      as numerosequencialbloquetobancoitau,');
         SQL.Add('        "LinhaRetornoSegmentoTBancoItauParcela"         as linharetornosegmentotbancoitau,');
         SQL.Add('        "LinhaRetornoSegmentoUBancoItauParcela"         as linharetornosegmentoubancoitau,');
         SQL.Add('        "NossoNumeroBloquetoBancoItauParcela"           as nossonumerobloquetobancoitau,');
         SQL.Add('        "DataHoraGeracaoBloquetoBancoSicrediParcela"    as datahorageracaobloquetobancosicredi,');
         SQL.Add('        "DataHoraRetornoBloquetoBancoSicrediParcela"    as datahoraretornobloquetobancosicredi,');
         SQL.Add('        "UsuarioProcessouRetornoBloquetoBancoSicrediParcela" as idusuarioprocessouretornobloquetobancosicredi,');
         SQL.Add('        "CodigoBarraBloquetoBancoSicrediParcela"        as codigobarrabloquetobancosicredi,');
         SQL.Add('        "LinhaDigitavelBloquetoBancoSicrediParcela"     as linhadigitavelbloquetobancosicredi,');
         SQL.Add('        "AgenciaCodCedenteDVBloquetoBancoSicrediParcela" as agenciacodcedentedvbloquetobancosicredi,');
         SQL.Add('        "NomeArquivoRetornoBancoSicrediParcela"          as nomearquivoretornobancosicredi,');
         SQL.Add('        "NumeroSequencialBloquetoBancoSicrediParcela"    as numerosequencialbloquetobancosicredi,');
         SQL.Add('        "LinhaRetornoSegmentoTBancoSicrediParcela"       as linharetornosegmentotbancosicredi,');
         SQL.Add('        "LinhaRetornoSegmentoUBancoSicrediParcela"       as linharetornosegmentoubancosicredi,');
         SQL.Add('        "NossoNumeroBloquetoBancoSicrediParcela"         as nossonumerobloquetobancosicredi,');
         SQL.Add('        "NomeArquivoRetornoBloquetoSICOBParcela"         as nomearquivoretornobloquetosicob,');
         SQL.Add('        "LinhaRetornoSegmentoTBloquetoSICOBParcela"      as linharetornosegmentotbloquetosicob,');
         SQL.Add('        "LinhaRetornoSegmentoUBloquetoSICOBParcela"      as linharetornosegmentoubloquetosicob,');
         SQL.Add('        "LogMovimentacaoParcela"                         as logmovimentacao,');
         SQL.Add('        "ValorPISParcela"                                as valorpis,');
         SQL.Add('        "ValorCOFINSParcela"                             as valorcofins,');
         SQL.Add('        "ValorIRParcela"                                 as valorir,');
         SQL.Add('        "ValorCSParcela"                                 as valorcs,');
         SQL.Add('        "ValorINSSParcela"                               as valorinss,');
         SQL.Add('        "ValorISSQNParcela"                              as valorissqn,');
         SQL.Add('        "TotalRetencoesParcela"                          as totalretencoes,');
         SQL.Add('        "EhExcessaoContabilidadeParcela"                 as ehexcessaocontabilidade,');
         SQL.Add('        "LancamentoContabilEfetuadoParcela"              as ehlancamentocontabilefetuado,');
         SQL.Add('        "DataHoraRetornoBloquetoBancoSantanderParcela"   as datahoraretornobloquetobancosantander,');
         SQL.Add('        "DataHoraGeracaoBloquetoBancoSantanderParcela"   as datahorageracaobloquetobancosantander,');
         SQL.Add('        "UsuarioProcessouRetornoBloquetoBancoSantanderParcela" as idusuarioprocessouretornobloquetobancosantander,');
         SQL.Add('        "CodigoBarraBloquetoBancoSantanderParcela"       as codigbarrabloquetobancosantander,');
         SQL.Add('        "LinhaDigitavelBloquetoBancoSantanderParcela"    as linhadigitavelbloquetobancosantander,');
         SQL.Add('        "AgenciaCodCedenteDVBloquetoBancoSantanderParcela" as agenciacodcedentedvbloquetobancosantander,');
         SQL.Add('        "NumeroSequencialBloquetoBancoSantanderParcela"  as numerosequencialbloquetobancosantander,');
         SQL.Add('        "NossoNumeroBloquetoBancoSantanderParcela"       as nossonumerobloquetobancosantander,');
         SQL.Add('        "NomeArquivoRetornoBancoSantanderParcela"        as nomearquivoretornobancosantander,');
         SQL.Add('        "LinhaRetornoSegmentoTBancoSantanderParcela"     as linharetornosegmentotbancosantander,');
         SQL.Add('        "LinhaRetornoSegmentoUBancoSantanderParcela"     as linharetornosegmentoubancosantander,');
         SQL.Add('        "CodigoParcelaDesdobradaParcela"                 as idparceladesdobrada,');
         SQL.Add('        "ParcelaFaturadaParcela"                         as ehparcelafaturada,');
         SQL.Add('        "CodigoInternoFaturadaParcela"                   as idfaturada,');
         SQL.Add('        "LogAlteracaoParcela"                            as logalteracao,');
         SQL.Add('        "IdNFeParcela"                                   as chavenfe,');
         SQL.Add('        "DataUltimaOperacaoParcela"                      as dataultimaoperacao,');
         SQL.Add('        "ProcessamentoRetornoConcluidoParcela"           as ehprocessamentoretornoconcluido,');
         SQL.Add('        "CodigoPessoaDevolucaoParcela"                   as idpessoadevolucao,');
         SQL.Add('        "IDAssinaturaLanctoBancarioParcela"              as idassinaturalancamentobancario,');
         SQL.Add('        "DataHoraRetornoBloquetoBancoSicoobParcela"      as datahoraretornobloquetobancosicoob,');
         SQL.Add('        "UsuarioProcessouRetornoBloquetoBancoSicoobParcela" as idusuarioprocessouretornobloquetobancosicoob,');
         SQL.Add('        "CodigoBarraBloquetoBancoSicoobParcela"          as codigobarrabloquetobancosicoob,');
         SQL.Add('        "LinhaDigitavelBloquetoBancoSicoobParcela"       as linhadigitavelbloquetobancosicoob,');
         SQL.Add('        "AgenciaCodCedenteDVBloquetoBancoSicoobParcela"  as agenciacodcedentedvbloquetobancosicoob,');
         SQL.Add('        "NomeArquivoRetornoBancoSicoobParcela"           as nomearquivoretornobancosicoob,');
         SQL.Add('        "NumeroSequencialBloquetoBancoSicoobParcela"     as numerosequencialbloquetobancosicoob,');
         SQL.Add('        "LinhaRetornoSegmentoTBancoSicoobParcela"        as linharetornosegmentotbancosicoob,');
         SQL.Add('        "LinhaRetornoSegmentoUBancoSicoobParcela"        as linharetornosegmentoubancosicoob,');
         SQL.Add('        "NossoNumeroBloquetoBancoSicoobParcela"          as nossonumerobloquetobancosicoob,');
         SQL.Add('        "DataHoraGeracaoBloquetoBancoSicoobParcela"      as datahorageracaobloquetobancosicoob ');
         SQL.Add('from "Parcela" where "CodigoDocFiscalParcela"=:xnota  ');
         if XQuery.ContainsKey('numero') then // filtro por texto
            begin
              SQL.Add('and "NumeroParcela" =:xnumero) ');
              ParamByName('xnumero').AsInteger := strtoint(XQuery.Items['xnumero']);
            end;
         if XQuery.ContainsKey('numero') then // filtro por texto
            begin
              SQL.Add('and "DataEmissaoParcela" =:xemissao) ');
              ParamByName('xemissao').AsDateTime := strtodate(XQuery.Items['xemissao']);
            end;
         if XQuery.ContainsKey('vencimento') then // filtro por texto
            begin
              SQL.Add('and "DataVencimentoParcela" =:xvencimento ');
              ParamByName('xvencimento').AsDateTime := strtodate(XQuery.Items['xvencimento']);
            end;
         if XQuery.ContainsKey('operacao') then // filtro por texto
            begin
              SQL.Add('and "DataOperacaoParcela" =:xoperacao ');
              ParamByName('xoperacao').AsDateTime := strtodate(XQuery.Items['xoperacao']);
            end;
         if XQuery.ContainsKey('order') then // ordenação
            begin
              wordem := 'order by '+XQuery.Items['order'];
              if XQuery.ContainsKey('dir') then // direção
                 wordem := wordem+' '+XQuery.Items['dir'];
              SQL.Add(wordem);
            end
         else
            SQL.Add('order by "CodigoInternoParcela" ');
         if XLimit>0 then
            SQL.Add('Limit '+inttostr(XLimit)+' offset '+inttostr(XOffset));
         ParamByName('xnota').AsInteger := XNota;
         Open;
         EnableControls;
       end;

   if wquery.RecordCount>0 then
      wret := wquery.ToJSONArray()
   else
      begin
        wobj := TJSONObject.Create;
        wobj.AddPair('status','404');
        wobj.AddPair('description','Nenhuma parcela encontrada');
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


function RetornaTotalParcelas(const XQuery: TDictionary<string, string>; XIdNota: integer): TJSONObject;
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
         SQL.Add('from "Parcela" where "CodigoDocFiscalParcela"=:xidnota ');
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
        wret.AddPair('description','Nenhuma Parcela encontrada');
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

{function IncluiNFePendenteItem(XNFeItem: TJSONObject; XIdNFe,XIdEmpresa: integer): TJSONObject;
var wquery: TFDMemTable;
    wqueryInsert,wquerySelect: TFDQuery;
    wret: TJSONObject;
    wnum: integer;
    wconexao: TProviderDataModuleConexao;
begin
  try
    wconexao     := TProviderDataModuleConexao.Create(nil);
    wqueryInsert := TFDQuery.Create(nil);
    if wconexao.EstabeleceConexaoDB then
       begin
         FIdItem     := RetornaIdItem(wconexao.FDConnectionApi);
         RetornaCamposProduto(wconexao.FDConnectionApi,XIdNFe,XNFeItem);
         with wqueryInsert do
         begin
           Connection := wconexao.FDConnectionApi;
           DisableControls;
           Close;
           SQL.Clear;
           Params.Clear;
           SQL.Add('Insert into "NotaItem" ("CodigoInternoItem","CodigoNotaItem","CodigoEmpresaItem","CodigoProdutoItem","QuantidadeItem","ValorUnitarioItem","ValorTotalItem","TipoOperacaoItem","DataMovimentoItem",');
           SQL.Add('"CodigoAliquotaICMSItem","CodigoVendedorItem","CodigoFiscalItem","CodigoSituacaoTributariaItem","NumeroItem") ');
           SQL.Add('values (:xiditem,:xidnota,:xidempresa,:xcodproduto,:xquantidade,:xunitario,:xtotalitem,:xtipo,:xdatamov,:xaliquota,:xvendedor,:xcodfiscal,:xsittrib,:xnumitem) ');
           ParamByName('xiditem').AsInteger     := FIdItem;
           ParamByName('xidnota').AsInteger     := XIdNFe;
           ParamByName('xidempresa').AsInteger  := XIdEmpresa;
           ParamByName('xcodproduto').AsInteger := FCodProduto;
           ParamByName('xquantidade').AsFloat   := FQtde;
           ParamByName('xunitario').AsFloat     := FUnitario;
           ParamByName('xtotalitem').AsFloat    := FTotal;
           ParamByName('xtipo').AsString        := 'S';
           ParamByName('xdatamov').AsDateTime   := FDatmov;
           ParamByName('xaliquota').AsInteger   := FCodAliquota;
           ParamByName('xvendedor').AsInteger   := FCodVendedor;
           ParamByName('xcodfiscal').AsInteger  := FCodFiscal;
           ParamByName('xsittrib').AsInteger    := FCodSitTrib;
           ParamByName('xnumitem').AsInteger    := FNumItem;
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
                SQL.Add('select "CodigoInternoItem" as id, "CodigoNotaItem" as idnfe, "NumeroItem" as numitem, "DataMovimentoItem" as datamovimento,');
                SQL.Add('"CodigoProdutoItem" as idproduto, ts_retornaprodutocodigo("CodigoProdutoItem") as codproduto, ts_retornaprodutodescricao("CodigoProdutoItem") as descproduto,');
                SQL.Add('"QuantidadeItem" as quantidade, "ValorUnitarioItem" as unitario, "ValorTotalItem" as total,');
                SQL.Add('ts_retornafiscalcodigo("CodigoFiscalItem") as cfop,');
                SQL.Add('ts_retornasituacaotributariacodigo("CodigoSituacaoTributariaItem") as csticm ');
                SQL.Add('from "NotaItem" ');
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

function VerificaRequisicao(XNFeItem: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XNFeItem.TryGetValue('numitem',wval) then
       wret := false;
    if not XNFeItem.TryGetValue('datamovimento',wval) then
       wret := false;
    if not XNFeItem.TryGetValue('codproduto',wval) then
       wret := false;
    if not XNFeItem.TryGetValue('quantidade',wval) then
       wret := false;
    if not XNFeItem.TryGetValue('unitario',wval) then
       wret := false;
    if not XNFeItem.TryGetValue('total',wval) then
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
  wsequence := '"NotaItem_CodigoInternoItem_seq"';
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

procedure RetornaCamposProduto(XFDConnection: TFDConnection; XIdNFe: integer; XNFeItem: TJSONObject);
var wret: integer;
    wqueryProduto,wqueryNota: TFDQuery;
    wcodproduto: string;
begin
  wcodproduto   := XNFeItem.GetValue('codproduto').Value;
  FQtde         := strtofloat(XNFeItem.GetValue('quantidade').Value);
  FUnitario     := strtofloat(XNFeItem.GetValue('unitario').Value);
  FTotal        := strtofloat(XNFeItem.GetValue('total').Value);
  FNumItem      := strtoint(XNFeItem.GetValue('numitem').Value);

  wqueryProduto := TFDQuery.Create(nil);
  wqueryNota    := TFDQuery.Create(nil);

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
    SQL.Add('from "Produto" where "CodigoProduto"=:xproduto and "AtivoProduto"=''true'' ');
    ParamByName('xproduto').AsString := wcodproduto;
    Open;
    EnableControls;
    if RecordCount > 0 then
       begin
         FCodProduto := FieldByName('id').AsInteger;
         FIncideST   := FieldByName('incidest').AsBoolean;
         FCodSitTrib := FieldByName('sittrib').AsInteger;
         FCodAliquota:= FieldByName('aliquota').AsInteger;
       end
    else
       begin
         FCodProduto := 0;
         FIncideST   := false;
         FCodSitTrib := 0;
         FCodAliquota:= 0;
       end;
  end;


  with wqueryNota do
  begin
    Connection := XFDConnection;
    DisableControls;
    Close;
    SQL.Clear;
    Params.Clear;
    SQL.Add('select "NotaFiscal"."CodigoRepresentanteNota" as vendedor,');
    if FIncideST then
       SQL.Add('"CondicaoPagamento"."CodigoFiscalSTCondicao" as codfiscal from "NotaFiscal" inner join "CondicaoPagamento" ')
    else
       SQL.Add('"CondicaoPagamento"."CodigoFiscalCondicao" as codfiscal from "NotaFiscal" inner join "CondicaoPagamento" ');
    SQL.Add('on "NotaFiscal"."CodigoCondicaoNota" = "CondicaoPagamento"."CodigoInternoCondicao" ');
    SQL.Add('where "CodigoInternoNota"=:xid ');
    ParamByName('xid').AsInteger := XIdNFe;
    Open;
    EnableControls;
    if RecordCount > 0 then
       begin
         FCodVendedor := wqueryNota.FieldByName('vendedor').asInteger;
         FCodFiscal   := wqueryNota.FieldByName('codfiscal').asInteger;
       end
    else
       begin
         FCodVendedor := 0;
         FCodFiscal   := 0;
       end;
  end;
end;}


end.
