unit dat.srvCalculaParcelaNFe;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function  CalculaParcela(XIdNFe: integer): TJSONArray;
procedure CarregaDadosNota(XIdNFe: integer);
function  CalculaParcelasModoNormal: TFDQuery;
function  CalculaParcelasModoPrazoMedio: TFDQuery;
procedure ApagaParcelas;
procedure CarregaPrazosCondicao;
procedure GravaParcelas(XNumParcela: integer; XTaxa: double);
procedure GravaParcelasPrazoMedio(XNumParcela: Integer;  XTaxa: double; XValEntrada: currency; XFlag: boolean);
function  CalculaValorParcelaPorPercentual(XPercentual: Double; XValor: Currency; XTipo: integer): Currency;
function  CalculaValorParcelaPorFracao(XNumPagto: Integer; XValor,XEntrada: Currency; XTipo: integer): Currency;
function  Textotofloat(XTexto: string): currency;
function  ArredondaValorNew(XValor: double; XDecimal: integer): double;
function  RetornaInteiro(XValor: Extended): integer;
function  RetornaDataVencimento(XTipo: string; XDias: integer; XData: tdatetime): tdatetime;

implementation

uses prv.dataModuleConexao;

var FTipoCondicao,FMetodoCondicao,FTipPer,FPrefixoLoja,FNumDocumento,FOperacao,FSituacaoCobranca: string;
    FTotal,FJuroMes,FPrazoMedio,FTaxaMedia,FTaxaCondicao,FTaxaParcela,FTaxaRetencao,FPrazoMedio2,FTaxaMedia2: double;
    FTotalLiquido,FTotalFretePD,FTotalFretePF,FTotalIPI,FTotalDescontoProduto,FSobra1,FSobra2,FSobra3,FValorEntrada: double;
    FTotalCreditoDevolucao,FTotalCreditoFidelidade,FTotalDescontos,FValorServico,FTotalICMSSubstituicao,FEncargoFinanceiro: double;
    FConexao: TProviderDataModuleConexao;
    FEmissao: TDate;
    FDQueryParcela: TFDQuery;
    FComEntrada,FTodasQuitadas,FPrimeiraQuitada: boolean;
    FNota,FCondicao,FDias,FNumParcelas,FEmpresa,FCodigoAlvo,FRepresentante,FPortador,FClassificacao,FDocumentoCobranca,FMaximoParcelas: integer;
    FDiasIntervalo: integer;
    FDatven: array[1..100] of TDateTime;
    FPerpra: array[1..100] of Double;

function CalculaParcela(XIdNFe: integer): TJSONArray;
var wquery: TFDQuery;
    wret: TJSONArray;
    wobj: TJSONObject;
begin
  try
// cria provider de conexão com BD
    FConexao := TProviderDataModuleConexao.Create(nil);
    if FConexao.EstabeleceConexaoDB then
       begin
         CarregaDadosNota(XIdNFe);
         if FTipoCondicao='N' then
            wquery := CalculaParcelasModoNormal
         else if (FTipoCondicao='Z') or (FTipoCondicao='Z') then
            wquery := CalculaParcelasModoPrazoMedio;
       end;

    if wquery.RecordCount>0 then
       wret := wquery.ToJSONArray()
    else
       begin
         wobj := TJSONObject.Create;
         wobj.AddPair('status','500');
         wobj.AddPair('description','Nenhuma Parcela criada');
         wobj.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         wret := TJSONArray.Create;
         wret.AddElement(wobj);
       end;
  except
    On E: Exception do
    begin
      FConexao.EncerraConexaoDB;
      wobj := TJSONObject.Create;
      wobj.AddPair('status','500');
      wobj.AddPair('description',E.Message);
      wobj.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
      wret := TJSONArray.Create;
      wret.AddElement(wobj);
    end;
  end;
  FConexao.EncerraConexaoDB;
  Result := wret;
end;

// Carrega os dados da NFe
procedure CarregaDadosNota(XIdNFe: integer);
var wquery: TFDQuery;
begin
  wquery := TFDQuery.Create(nil);
  with wquery do
  begin
    Connection := FConexao.FDConnectionApi;
    DisableControls;
    Close;
    SQL.Clear;
    Params.Clear;
    SQL.Add('select "NotaFiscal"."CodigoInternoNota"                  as idnfe,');
    SQL.Add('       "NotaFiscal"."CodigoEmpresaNota"                  as empresa,');
    SQL.Add('       "NotaFiscal"."NumeroDocumentoNota"                as numdocumento,');
    SQL.Add('       "NotaFiscal"."DataEmissaoNota"                    as emissao,');
    SQL.Add('       "NotaFiscal"."CodigoAlvoNota"                     as codigoalvo,');
    SQL.Add('       "NotaFiscal"."CodigoRepresentanteNota"            as codigorepresentante,');
    SQL.Add('       "NotaFiscal"."CodigoPortadorDocumentoNota"        as codigoportador,');
    SQL.Add('       "NotaFiscal"."SituacaoCobrancaNota"               as situacaocobranca,');
    SQL.Add('       "NotaFiscal"."TotalNota"                          as total,');
    SQL.Add('       "NotaFiscal"."ValorEntradaNota"                   as valorentrada,');
    SQL.Add('       "NotaFiscal"."TotalLiquidoNota"                   as totalliquido,');
    SQL.Add('       "NotaFiscal"."TotalFretePDNota"                   as totalfretepd,');
    SQL.Add('       "NotaFiscal"."TotalFretePFNota"                   as totalfretepf,');
    SQL.Add('       "NotaFiscal"."TotalDescontoProdutoNota"           as totaldescontoproduto,');
    SQL.Add('       "NotaFiscal"."TotalCreditoDevolucaoNota"          as totalcreditodevolucao,');
    SQL.Add('       "NotaFiscal"."TotalCreditoFidelidadeNota"         as totalcreditofidelidade,');
    SQL.Add('       "NotaFiscal"."TotalIPINota"                       as totalipi,');
    SQL.Add('       "NotaFiscal"."TotalICMSSubstituicaoNota"          as totalicmssubstituicao,');
    SQL.Add('       "NotaFiscal"."TotalDescontosNota"                 as totaldescontos,');
    SQL.Add('       "NotaFiscal"."ValorServico"                       as valorservico,');
    SQL.Add('       "NotaFiscal"."EncargoFinanceiroNota"              as encargofinanceiro,');
    SQL.Add('       "NotaFiscal"."CodigoCondicaoNota"                 as condicao,');
    SQL.Add('       "NotaFiscal"."CodigoDocumentoCobrancaNota"        as documentocobranca,');
    SQL.Add(' ts_RetornaDocumentoCobrancaOperacao("CodigoDocumentoCobrancaNota") as operacao,');
    SQL.Add('       "CondicaoPagamento"."CondicaoComEntradaCondicao"  as comentrada,');
    SQL.Add('       "CondicaoPagamento"."PercentualJuroMesCondicao"   as juromes,');
    SQL.Add('       "CondicaoPagamento"."ClassificacaoFiscalCondicao" as classificacaofiscal,');
    SQL.Add('       "CondicaoPagamento"."DescAcrescCondicao"          as tipper,');
    SQL.Add('       "CondicaoPagamento"."MetodoCondicao"              as metodocondicao,');
    SQL.Add('       "CondicaoPagamento"."MaximoParcelasCondicao"      as maximoparcelas,');
    SQL.Add('       "CondicaoPagamento"."TaxaCondicao"                as taxacondicao,');
    SQL.Add('       "CondicaoPagamento"."DiasIntervaloParcelasCondicao" as diasintervalo,');
    SQL.Add('       "CondicaoPagamento"."TaxaPorParcelaCondicao"      as taxaparcela,');
    SQL.Add('       "CondicaoPagamento"."TaxaRetencaoCondicao"        as taxaretencao,');
    SQL.Add('       "CondicaoPagamento"."TodasParcelasQuitadasCondicao"  as todasquitadas,');
    SQL.Add('       "CondicaoPagamento"."PrimeiraParcelaQuitadaCondicao" as primeiraquitada,');
    SQL.Add('       "CondicaoPagamento"."TipoCondicao"                   as tipocondicao ');
    SQL.Add('from "NotaFiscal" inner join "CondicaoPagamento" on "NotaFiscal"."CodigoCondicaoNota" = "CondicaoPagamento"."CodigoInternoCondicao" ');
    SQL.Add('where "NotaFiscal"."CodigoInternoNota" =:xid ');
    ParamByName('xid').AsInteger := XIdNFe;
    Open;
    EnableControls;
    if RecordCount > 0 then
       begin
         FPrefixoLoja    := '';
         FNota           := FieldByName('idnfe').AsInteger;
         FEmpresa        := FieldByName('empresa').AsInteger;
         FCodigoAlvo     := FieldByName('codigoalvo').AsInteger;
         FRepresentante  := FieldByName('codigorepresentante').AsInteger;
         FPortador       := FieldByName('codigoportador').AsInteger;
         FDocumentoCobranca := FieldByName('documentocobranca').AsInteger;
         FNumDocumento   := FieldByName('numdocumento').AsString;
         FTipoCondicao   := FieldByName('tipocondicao').AsString;
         FValorEntrada   := FieldByName('valorentrada').AsFloat;
         FMetodoCondicao := FieldByName('metodocondicao').AsString;
         FMaximoParcelas := FieldByName('maximoparcelas').AsInteger;
         FTotal          := FieldByName('total').AsFloat;
         FEmissao        := FieldByName('emissao').AsDateTime;
         FSituacaoCobranca := FieldByName('situacaocobranca').AsString;
         FTodasQuitadas  := FieldByName('todasquitadas').AsBoolean;
         FCondicao       := FieldByName('condicao').AsInteger;
         FComEntrada     := FieldByName('comentrada').AsBoolean;
         FJuroMes        := FieldByName('juromes').AsFloat;
         FTipPer         := FieldByName('tipper').AsString;
         FDiasIntervalo  := FieldByName('diasintervalo').AsInteger;
         FPrimeiraQuitada:= FieldByName('primeiraquitada').AsBoolean;
         FClassificacao  := FieldByName('classificacaofiscal').AsInteger;
         FTaxaCondicao   := FieldByName('taxacondicao').AsFloat;
         FTaxaRetencao   := FieldByName('taxaretencao').AsFloat;
         FTaxaParcela    := FieldByName('taxaparcela').AsFloat;
         FTotalLiquido   := FieldByName('totalliquido').AsFloat;
         FTotalFretePD   := FieldByName('totalfretepd').AsFloat;
         FTotalFretePF   := FieldByName('totalfretepf').AsFloat;
         FTotalIPI       := FieldByName('totalipi').AsFloat;
         FTotalDescontoProduto  := FieldByName('totaldescontoproduto').AsFloat;
         FTotalCreditoDevolucao := FieldByName('totalcreditodevolucao').AsFloat;
         FTotalCreditoFidelidade:= FieldByName('totalcreditofidelidade').AsFloat;
         FTotalDescontos        := FieldByName('totaldescontos').AsFloat;
         FValorServico          := FieldByName('valorservico').AsFloat;
         FTotalICMSSubstituicao := FieldByName('totalicmssubstituicao').AsFloat;
         FEncargoFinanceiro     := FieldByName('encargofinanceiro').AsFloat;
       end;
  end;
end;

// Calcula as parcelas quando a condição for do tipo Normal
function CalculaParcelasModoNormal: TFDQuery;
begin
  ApagaParcelas;
  CarregaPrazosCondicao;
  GravaParcelas(FNumParcelas,FTaxaMedia);
  Result := FDQueryParcela;
end;


// Apaga parcelas antigas
procedure ApagaParcelas;
var wqueryApaga: TFDQuery;
begin
  wqueryApaga := TFDQuery.Create(nil);
  with wqueryApaga do
  begin
    Connection := FConexao.FDConnectionApi;
    DisableControls;
    Close;
    SQL.Clear;
    Params.Clear;
    SQL.Add('delete from "Parcela" where "CodigoDocFiscalParcela"=:xnfe ');
    ParamByName('xnfe').AsInteger := FNota;
    ExecSQL;
    EnableControls;
  end;
end;

// Carrega os prazos de vencimento conforme condição
procedure CarregaPrazosCondicao;
var wqueryPrazo: TFDQuery;
    wconta: integer;
begin
  wconta      := 0;
  wqueryPrazo := TFDQuery.Create(nil);
  with wqueryPrazo do
  begin
    Connection := FConexao.FDConnectionApi;
    DisableControls;
    Close;
    SQL.Clear;
    Params.Clear;
    SQL.Add('Select * from "CondicaoPrazo" where "CodigoCondicaoPrazo"=:xcondicao order by "DiasVencimentoPrazo" ');
    ParamByName('xcondicao').AsInteger := FCondicao;
    Open;
    while not EOF do
    begin
      inc(wconta);
      FDatven[wconta] := FEmissao + FieldByName('DiasVencimentoPrazo').Value;
      FPerpra[wconta] := FieldByName('PercentualPrazo').Value;
      FDias           := FDias + FieldByName('DiasVencimentoPrazo').Value;
      Next;
    end;
    EnableControls;
  end;
  FNumParcelas   := wconta;
  if (wconta > 1) and (FComEntrada) then
     FPrazoMedio := FDias / (wconta - 1)
  else
     FPrazomedio := FDias / wconta;
  FTaxaMedia     := (FPrazoMedio*FJuroMes)/30;
end;

// Grava parcelas
procedure GravaParcelas(XNumParcela: integer; XTaxa: double);
var ix: integer;
    vvalpar,vvalori,vvaldes,vvalret: array[1..50] of currency;
    wtaxa1,wtaxa2,wvaltot: currency;
begin
  try
    FDQueryParcela := TFDQuery.Create(nil);
    with FDQueryParcela do
    begin
      Connection := FConexao.FDConnectionApi;
      DisableControls;
      Close;
      SQL.Clear;
      Params.Clear;
      SQL.Add('select * from "Parcela" where "CodigoInternoParcela"=0 ');
      Open;
      EnableControls;
    end;
    for ix := 1 to 50 do
    begin
      vvalpar[ix] := 0;
      vvalori[ix] := 0;
      vvaldes[ix] := 0;
    end;
    wtaxa1 := FTaxaCondicao;
    wtaxa2 := ArredondaValorNew(FTaxaParcela*XNumParcela,2);
    if FTipPer = 'Desconto' then
       wvaltot := ArredondaValorNew((((FTotalLiquido + FTotalFretePD - FTotalDescontoProduto + FTotalFretePF + FTotalIPI -
                                       FTotalCreditoDevolucao - FTotalCreditoFidelidade - FTotalDescontos + FValorServico + FTotalICMSSubstituicao +
                                       FEncargoFinanceiro)*XTaxa)/100)+wtaxa1+wtaxa2,2)
    else
       wvaltot := ArredondaValorNew((((FTotalLiquido + FTotalFretePD - FTotalDescontoProduto + FTotalFretePF + FTotalIPI -
                                       FTotalCreditoDevolucao - FTotalCreditoFidelidade + FTotalDescontos + FValorServico + FTotalICMSSubstituicao +
                                       FEncargoFinanceiro)*XTaxa)/100)+wtaxa1+wtaxa2,2);
    for ix:=1 to XNumParcela do
    begin
      if FMetodoCondicao = 'P' then
         begin
           vvalpar[ix] := CalculaValorParcelaPorPercentual(FPerPra[ix],FTotalLiquido - FTotalDescontoProduto + FTotalFretePD + FTotalFretePF + FTotalIPI - FTotalCreditoDevolucao -
                                                           FTotalCreditoFidelidade - FTotalDescontos + FValorServico + FTotalICMSSubstituicao + FEncargoFinanceiro + wtaxa1+wtaxa2,1);
           vvalori[ix] := CalculaValorParcelaPorPercentual(FPerPra[ix],FTotalLiquido - FTotalDescontoProduto + FTotalFretePD + FTotalFretePF + FTotalIPI - FTotalCreditoDevolucao -
                                                           FTotalCreditoFidelidade - FTotalDescontos +  FValorServico +  FTotalICMSSubstituicao + FEncargoFinanceiro,2);
           if (ix=1) and (FComEntrada) then
              vvaldes[ix] := 0
           else
              vvaldes[ix] := CalculaValorParcelaPorPercentual(FPerPra[ix],wvaltot,3);
         end
      else
         begin
           vvalpar[ix] := CalculaValorParcelaPorFracao(XNumParcela,FTotalLiquido - FTotalDescontoProduto + FTotalFretePD + FTotalFretePF + FTotalIPI - FTotalCreditoDevolucao - FTotalCreditoFidelidade -
                                                       FTotalDescontos + FValorServico + FTotalICMSSubstituicao + FEncargoFinanceiro + wtaxa1+wtaxa2,0,1);
           vvalori[ix] := CalculaValorParcelaPorFracao(FNumParcelas,FTotalLiquido - FTotalDescontoProduto + FTotalFretePD + FTotalFretePF + FTotalIPI - FTotalCreditoDevolucao -
                                                       FTotalCreditoFidelidade - FTotalDescontos + FValorServico + FTotalICMSSubstituicao + FEncargoFinanceiro,0,2);
           if (ix=1) and (FComEntrada) then
              vvaldes[ix] := 0
           else
              vvaldes[ix] := CalculaValorParcelaPorFracao(XNumParcela,wvaltot,0,3);
         end;
      vvalret[ix] := ArredondaValorNew(((FTaxaRetencao * vvalpar[ix])/100),2);
    end;
    if FSobra1 > 0.000 then
       begin
         vvalpar[1] := vvalpar[1] + ArredondaValorNew(FSobra1,2);
         FSobra1 := 0.000;
       end;
    if FSobra2 > 0.000 then
       begin
         vvalori[1] := vvalori[1] + ArredondaValorNew(FSobra2,2);
         FSobra2 := 0.000;
       end;
    if FSobra3 > 0.000 then
       begin
         if (FComEntrada) and (XNumParcela > 1) then
            vvaldes[2] := vvaldes[2] + ArredondaValorNew(FSobra3,2)
         else
            vvaldes[1] := vvaldes[1] + ArredondaValorNew(FSobra3,2);
         FSobra3 := 0.000;
       end;
    for ix:=1 to XNumParcela do
    begin
      if FDatVen[ix] = 0 then
         Break;
      FDQueryParcela.Insert;
      FDQueryParcela.FieldByName('NumeroDocumentoParcela').asString      := FPrefixoLoja+FNumDocumento;
      FDQueryParcela.FieldByName('CodigoDocFiscalParcela').asInteger     := FNota;
      FDQueryParcela.FieldByName('CodigoEmpresaParcela').asInteger       := FEmpresa;
      FDQueryParcela.FieldByName('NumeroParcela').asInteger              := ix;
      FDQueryParcela.FieldByName('NumeroPagamentosParcela').asInteger    := XNumParcela;
      FDQueryParcela.FieldByName('DataEmissaoParcela').asDateTime        := FEmissao;
      FDQueryParcela.FieldByName('DataVencimentoParcela').asDateTime     := StrToDate(FormatDateTime('dd/mm/yyyy',FDatVen[ix]));
      FDQueryParcela.FieldByName('TipoMovimentoParcela').Value           := 'R';
      FDQueryParcela.FieldByName('ValorFinalParcela').Value              := vvalpar[ix] + vvaldes[ix];
      FDQueryParcela.FieldByName('ValorOriginalParcela').Value           := vvalori[ix];
      FDQueryParcela.FieldByName('ValorIndiceParcela').Value             := vvaldes[ix];
      FDQueryParcela.FieldByName('CodigoCondicaoParcela').Value          := FCondicao;
      FDQueryParcela.FieldByName('CodigoBancoPagamentoParcela').Clear;
      FDQueryParcela.FieldByName('CodigoClienteParcela').asInteger       := FCodigoAlvo;
      FDQueryParcela.FieldByName('CodigoPortadorParcela').asInteger      := FPortador;
      FDQueryParcela.FieldByName('CodigoFornecedorParcela').Clear;
      FDQueryParcela.FieldByName('CodigoRepresentanteParcela').asInteger := FRepresentante;
      FDQueryParcela.FieldByName('TipoDocumentoParcela').asInteger       := FClassificacao;
      FDQueryParcela.FieldByName('CodigoUsuarioOperacaoParcela').Clear;
      if FDocumentoCobranca > 0 then
         FDQueryParcela.FieldByName('CodigoDocumentoCobrancaParcela').asInteger := FDocumentoCobranca
      else
         FDQueryParcela.FieldByName('CodigoDocumentoCobrancaParcela').Clear;
      FDQueryParcela.FieldByName('SituacaoParcela').Value            := FSituacaoCobranca;
      if (FOperacao = 'Q') or (FTodasQuitadas) or ((FPrimeiraQuitada) and (ix=1)) then
         begin
           FDQueryParcela.FieldByName('TipoOperacaoParcela').asString     := 'Q';
           FDQueryParcela.FieldByName('PrefixoPagamentoParcela').asString := FPrefixoLoja;
           FDQueryParcela.FieldByName('DataOperacaoParcela').asDateTime   := FDQueryParcela.FieldByName('DataVencimentoParcela').asDateTime;
         end
      else
         begin
           FDQueryParcela.FieldByName('TipoOperacaoParcela').Value := 'E';
           FDQueryParcela.FieldByName('DataOperacaoParcela').Clear;
         end;
      FDQueryParcela.FieldByName('OrigemParcela').Value        := 'TSCaixa_R';
      FDQueryParcela.Post;
    end;

    with FDQueryParcela do
    begin
      Connection := FConexao.FDConnectionApi;
      DisableControls;
      Close;
      SQL.Clear;
      Params.Clear;
      SQL.Add('select "CodigoInternoParcela" as id,');
      SQL.Add('       "CodigoDocFiscalParcela" as idnfe,');
      SQL.Add('       "NumeroParcela" as numero,');
      SQL.Add('       "ValorFinalParcela" as valor,');
      SQL.Add('       "DataEmissaoParcela" as emissao,');
      SQL.Add('       "DataVencimentoParcela" as vencimento,');
      SQL.Add('       "DataOperacaoParcela" as operacao,');
      SQL.Add('       "TipoOperacaoParcela" as situacao ');
      SQL.Add('from "Parcela" where "CodigoDocFiscalParcela"=:xidnfe ');
      ParamByName('xidnfe').AsInteger := FNota;
      Open;
      EnableControls;
    end;

  except
  end;
end;

// Calcula o valor da parcela por percentual
function CalculaValorParcelaPorPercentual(XPercentual: Double; XValor: Currency; XTipo: integer): Currency;
var wvalor,wvalor2: currency;
    zvalor: string;
    wpos: integer;
begin
  wvalor  := ArredondaValorNew((XValor * XPercentual)/100,2);
  wvalor2 := wvalor;
  zvalor  := floattostr(wvalor);
  wpos := pos(',',zvalor);
  if wpos <> 0 then
     begin
       zvalor  := copy(zvalor,1,wpos)+copy(zvalor,wpos+1,2);
       wvalor2 := textotofloat(zvalor);
       case XTipo of
         1: FSobra1  := FSobra1 + (wvalor - wvalor2);
         2: FSobra2  := FSobra2 + (wvalor - wvalor2);
         3: FSobra3  := FSobra3 + (wvalor - wvalor2);
       end;
     end;
  Result := wvalor2;
end;

function Textotofloat(XTexto: string): currency;
var wpos: integer;
    wvalor: string;
begin
  wvalor := XTexto;
  wpos   := pos('.',wvalor);
  while wpos > 0 do
  begin
    delete(wvalor,wpos,1);
    wpos  := pos('.',wvalor);
  end;
  Textotofloat := strtocurr(wvalor);
end;

// Calcula o valor da parcela por fração
function CalculaValorParcelaPorFracao(XNumPagto: Integer; XValor,XEntrada: Currency; XTipo: integer): Currency;
var wvalor,wvalor2: currency;
    zvalor: string;
    wpos: integer;
begin
  if XEntrada > 0 then
     wvalor  := XValor / (XNumPagto - 1)
  else
     wvalor  := XValor / XNumPagto;
  wvalor2 := wvalor;
  zvalor  := floattostr(wvalor);
  wpos    := pos(',',zvalor);
  if wpos <> 0 then
     begin
       zvalor  := copy(zvalor,1,wpos)+copy(zvalor,wpos+1,2);
       wvalor2 := textotofloat(zvalor);
       case XTipo of
         1: FSobra1  := FSobra1 + (wvalor - wvalor2);
         2: FSobra2  := FSobra2 + (wvalor - wvalor2);
         3: FSobra3  := FSobra3 + (wvalor - wvalor2);
       end;
     end;
  Result := wvalor2;
end;

function ArredondaValorNew(XValor: double; XDecimal: integer): double;
var wint,wfrac,wvalor,wvalor2,wret: variant;
    wnegativo: boolean;
begin
  wnegativo := XValor < 0;
  wint    := abs(int(XValor));
  wfrac   := abs(frac(XValor));
  case XDecimal of
    2: begin
         wvalor  := int(wfrac*100);
         wvalor2 := frac(wfrac*100)*10;
       end;
    3: begin
         wvalor  := int(wfrac*1000);
         wvalor2 := frac(wfrac*1000)*10;
       end;
  end;
  if wvalor2 >= 4.99999 then
     case XDecimal of
       2: begin
            if wvalor = 99 then
               begin
                 inc(wint);
                 wvalor := 0;
               end
            else
               inc(wvalor);
          end;
       3: begin
            if wvalor = 999 then
               begin
                 inc(wint);
                 wvalor := 0;
               end
            else
               inc(wvalor);
          end;
     end;
  case XDecimal of
    2: wvalor  := wvalor/100;
    3: wvalor  := wvalor/1000;
  end;
  wret    := wint+wvalor;
  if wnegativo then
     wret := wret * -1;
  ArredondaValorNew := wret;
end;


// Calcula parcelas do tipo prazo medio normal / fixo
function CalculaParcelasModoPrazoMedio: TFDQuery;
var ix,wdias,wcta,wcta2: integer;
    wdata,wdatax: tdatetime;
    wprazomedio,wtaxamedia,wprazomedio2,wtaxamedia2,wvalentrada,wvalentradabonus,wcredito: double;
begin
  try
    ApagaParcelas;

    FSobra1 := 0;
    FSobra2 := 0;
    FSobra3 := 0;
    wvalentrada := 0;
    wvalentradabonus := 0;

    wdias  := 0;
    wcta   := 0;
    wcta2  := 0;
    wdata  := FEmissao;
    wdatax := FEmissao;

    for ix:=1 to FMaximoParcelas do
    begin
      inc(wcta);
      if (ix=1) and (FComEntrada) then
         FDatVen[ix] := wdata
      else
         begin
           inc(wcta2);
           if (FTipoCondicao='Z') and (FComEntrada) then
              FDatVen[ix] := FEmissao+(FDiasIntervalo*(ix-1))
           else if (FTipoCondicao='Z') and not(FComEntrada) then
              FDatVen[ix] := FEmissao+(FDiasIntervalo*ix)
           else
              FDatVen[ix] := RetornaDataVencimento(FTipoCondicao,FDiasIntervalo,wdata);
           wdias       := wdias + RetornaInteiro(FDatVen[ix]-wdatax);
         end;
      wdata      := FDatVen[ix];
    end;

//    if (wcta>1) and (FComEntrada) and (FDQueryConfiguraRecebaTipoCalculoPrazoMedioConfigura.Value='C') then
//       FPrazoMedio := wdias / (wcta - 1)
//    else
    FPrazoMedio := wdias / wcta;
    FTaxaMedia  := (FPrazoMedio * FJuroMes)/30;
    if wcta2 > 0 then
       begin
         FPrazoMedio2 := wdias / wcta2;
         FTaxaMedia2  := (FPrazoMedio2*FJuroMes)/30;
       end
    else
       FTaxaMedia2  := 0;
    if FComEntrada then
       GravaParcelasPrazoMedio(FMaximoParcelas,FTaxaMedia2,FValorEntrada,true)
    else
       GravaParcelasPrazoMedio(FMaximoParcelas,FTaxaMedia,FValorEntrada,false);
  except
    begin
      messagedlg('Problema no cálculo das parcelas(2)',mterror,[mbok],0);
    end;
  end;
  Result := FDQueryParcela;
end;

function RetornaInteiro(XValor: Extended): integer;
var wvalor: string;
    wret,wpos: integer;
begin
  wvalor := floattostr(XValor);
  wpos   := pos(',',wvalor);
  if wpos > 0 then
     delete(wvalor,wpos,50);
  wret := strtoint(wvalor);
  RetornaInteiro := wret;
end;

function RetornaDataVencimento(XTipo: string; XDias: integer; XData: tdatetime): tdatetime;
var wano,wmes,wdia,wano2,wdia2,wdiaaux,wmesaux: word;
    wdataux,wdataux2: tdatetime;
    wvenc: integer;
begin
  DecodeDate(XData,wano,wmes,wdia);
  wdiaaux := wdia;
  wdataux := EncodeDate(wano,wmes,28);
  if XTipo = 'X' then
     wvenc := 30
  else
     wvenc := XDias;
  wdataux := wdataux + wvenc;
  DecodeDate(wdataux,wano,wmes,wdia);
  if wdiaaux > 28 then
     begin
       wdataux := EncodeDate(wano,wmes,28);
       DecodeDate(wdataux,wano,wmes,wdia);
       try
         wdataux2 := EncodeDate(wano,wmes,wdia+1);
         DecodeDate(wdataux2,wano2,wmesaux,wdia2);
       except
         wdiaaux := 28;
       end;
       while (wdia < wdiaaux) and (wmes = wmesaux) do
         begin
           wdataux := wdataux + 1;
           DecodeDate(wdataux,wano,wmes,wdia);
           if wdia < 31 then
              begin
                try
                  wdataux2 := EncodeDate(wano,wmes,wdia+1);
                  DecodeDate(wdataux2,wano2,wmesaux,wdia2);
                except
                  wdia := 99;
                end;
              end;
         end;
       DecodeDate(wdataux,wano,wmes,wdiaaux);
     end;
  Result := EncodeDate(wano,wmes,wdiaaux);
end;


procedure GravaParcelasPrazoMedio(XNumParcela: Integer;  XTaxa: double; XValEntrada: currency; XFlag: boolean);
var ix,wsobra,wsobrax: integer;
    vvalori,vvaldes,vvalret: array [1..50] of currency;
    wtaxa1,wtaxa2,wvaltot: currency;
    vinterno: array [1..50] of integer;
begin
  try
    wsobra  := 0;
    wsobrax := 0;
    FDQueryParcela := TFDQuery.Create(nil);
    with FDQueryParcela do
    begin
      Connection := FConexao.FDConnectionApi;
      DisableControls;
      Close;
      SQL.Clear;
      Params.Clear;
      SQL.Add('select * from "Parcela" where "CodigoInternoParcela"=0 ');
      Open;
      EnableControls;
    end;
    for ix:=1 to 50 do
    begin
      vvalori[ix] := 0;
      vvaldes[ix] := 0;
    end;
    wtaxa1 := FTaxaCondicao;
    wtaxa2 := ArredondaValorNew((FTaxaParcela * XNumParcela),2);
    if FTipper = 'Desconto' then
       wvaltot := ArredondaValorNew((((FTotalLiquido + FTotalFretePD + FTotalFretePF + FTotalIPI -
                                       FTotalDescontos - FTotalDescontoProduto + FValorServico +
                                       FTotalICMSSubstituicao - XValEntrada)*XTaxa)/100)+wtaxa1+wtaxa2,2)
    else
       wvaltot := ArredondaValorNew((((FTotalLiquido + FTotalFretePD + FTotalFretePF + FTotalIPI +
                                       FTotalDescontos - FTotalDescontoProduto + FValorServico + FTotalICMSSubstituicao - XValEntrada)*XTaxa)/100)+wtaxa1+wtaxa2,2);
    for ix:=1 to XNumParcela do
    begin
      if (ix=1) and (XValEntrada > 0) then
         begin
           vvalori[ix] := XValEntrada;
           vvaldes[ix] := 0;
         end
      else if (ix=1) and (XFlag) then
         begin                                                                                                                                                                                                                                                                                                                                                   // + FDQueryNotaFiscalTotalDespesasNota.AsCurrency
           if FTipper = 'Desconto' then
              vvalori[ix] := CalculaValorParcelaPorFracao(XNumParcela,FTotalLiquido - FTotalCreditoDevolucao - FTotalCreditoFidelidade +
                                                          FTotalFretePD + FTotalFretePF + FTotalIPI - FTotalDescontoProduto - FTotalDescontos +
                                                          FValorServico + FTotalICMSSubstituicao + FEncargoFinanceiro - XValEntrada,XValEntrada,1)
           else
              vvalori[ix] := CalculaValorParcelaPorFracao(XNumParcela,FTotalLiquido - FTotalCreditoDevolucao - FTotalCreditoFidelidade +
                                                          FTotalFretePD + FTotalFretePF + FTotalIPI - FTotalDescontoProduto + FTotalDescontos +
                                                          FValorServico + FTotalICMSSubstituicao + FEncargoFinanceiro - XValEntrada,XValEntrada,1);
           vvaldes[ix] := 0;
         end
      else
         begin
           if FTipper = 'Desconto' then
              vvalori[ix] := CalculaValorParcelaPorFracao(XNumParcela,FTotalLiquido - FTotalCreditoDevolucao - FTotalCreditoFidelidade +
                                                          FTotalFretePD + FTotalFretePF + FTotalIPI - FTotalDescontoProduto - FTotalDescontos +
                                                          FValorServico + FTotalICMSSubstituicao + FEncargoFinanceiro - XValEntrada,XValEntrada,1)
           else
              vvalori[ix] := CalculaValorParcelaPorFracao(XNumParcela,FTotalLiquido - FTotalCreditoDevolucao - FTotalCreditoFidelidade + FTotalFretePD +
                                                          FTotalFretePF + FTotalIPI - FTotalDescontoProduto + FTotalDescontos + FValorServico + FTotalICMSSubstituicao +
                                                          FEncargoFinanceiro - XValEntrada,XValEntrada,1);
           vvaldes[ix] := CalculaValorParcelaPorFracao(XNumParcela,wvaltot,XValEntrada,2);
         end;
      vvalret[ix] := ArredondaValorNew(((FTaxaRetencao * (vvalori[ix]+vvaldes[ix]))/100),2);
    end;
    if FSobra1 > 0.000 then
       begin
         wsobra  := round(FSobra1*100);
         FSobra1 := 0.000;
       end;
    if FSobra2 > 0.000 then
       begin
         wsobrax := round(FSobra2*100);
         FSobra2 := 0.000;
       end;
    for ix:=1 to XNumParcela do
    begin
      if FDatVen[ix] = 0 then
         Break;
      FDQueryParcela.Insert;
      FDQueryParcela.FieldByName('NumeroDocumentoParcela').asString   := FPrefixoLoja+FNumDocumento;
      FDQueryParcela.FieldByName('PrefixoOrigemParcela').asString     := FPrefixoLoja;
      FDQueryParcela.FieldByName('CodigoDocFiscalParcela').asInteger  := FNota;
      FDQueryParcela.FieldByName('CodigoEmpresaParcela').asInteger    := FEmpresa;
      FDQueryParcela.FieldByName('NumeroParcela').asInteger           := ix;
      FDQueryParcela.FieldByName('NumeroPagamentosParcela').asInteger := XNumParcela;
      FDQueryParcela.FieldByName('DataEmissaoParcela').asDateTime     := FEmissao;
      FDQueryParcela.FieldByName('DataVencimentoParcela').asDateTime  := StrToDate(FormatDateTime('dd/mm/yyyy',FDatVen[ix]));
      FDQueryParcela.FieldByName('ValorOriginalParcela').asFloat      := vvalori[ix];
      FDQueryParcela.FieldByName('TipoMovimentoParcela').asString     := 'R';
      FDQueryParcela.FieldByName('OrigemParcela').asString            := 'TSCaixa_R';
      FDQueryParcela.FieldByName('ValorIndiceParcela').asFloat        := vvaldes[ix];
      FDQueryParcela.FieldByName('ValorFinalParcela').asFloat         := FDQueryParcela.FieldByName('ValorOriginalParcela').Value+FDQueryParcela.FieldByName('ValorIndiceParcela').Value;
      FDQueryParcela.FieldByName('CodigoCondicaoParcela').asInteger   := FCondicao;
      FDQueryParcela.FieldByName('CodigoClienteParcela').asInteger    := FCodigoAlvo;
      FDQueryParcela.FieldByName('CodigoPortadorParcela').asInteger   := FPortador;
      FDQueryParcela.FieldByName('CodigoFornecedorParcela').Clear;
      FDQueryParcela.FieldByName('CodigoRepresentanteParcela').asInteger := FRepresentante;
      FDQueryParcela.FieldByName('TipoDocumentoParcela').asInteger       := FClassificacao;
      FDQueryParcela.FieldByName('CodigoDocumentoCobrancaParcela').asInteger := FDocumentoCobranca;
//      if FDQueryParcela.FieldByName('FormaPagamentoParcela').Value = 0 then
//         FDQueryParcela.FieldByName('FormaPagamentoParcela').Value       := FDQueryNotaFiscalXNumerarioCondicao.Value;
      if (FOperacao = 'Q') or (FTodasQuitadas) or ((FPrimeiraQuitada) and (ix=1)) then
         begin
           FDQueryParcela.FieldByName('PrefixoPagamentoParcela').asString := FPrefixoLoja;
           FDQueryParcela.FieldByName('TipoOperacaoParcela').asString     := 'Q';
           FDQueryParcela.FieldByName('DataOperacaoParcela').asDateTime   := FDatVen[ix];
           FDQueryParcela.FieldByName('OrigemQuitacaoParcela').asString   := 'TSCaixa_R';
         end
      else
         begin
           FDQueryParcela.FieldByName('TipoOperacaoParcela').asString     := 'E';
           FDQueryParcela.FieldByName('DataOperacaoParcela').Clear;
         end;
      FDQueryParcela.Post;
      vinterno[ix] := FDQueryParcela.FieldByName('CodigoInternoParcela').asInteger;
    end;
    while wsobra > 0 do
    begin
      with FDQueryParcela do
      begin
        DisableControls;
        First;
        while not EOF do
        begin
          if wsobra > 0 then
             begin
               if (XValEntrada>0) and (FDQueryParcela.FieldByName('NumeroParcela').asInteger=1) then
                  wsobra := wsobra+0
               else
                  begin
                    Edit;
                    FDQueryParcela.FieldByName('ValorOriginalParcela').asFloat := FDQueryParcela.FieldByName('ValorOriginalParcela').asFloat+0.01;
                    FDQueryParcela.FieldByName('ValorFinalParcela').asFloat    := FDQueryParcela.FieldByName('ValorOriginalParcela').asFloat+FDQueryParcela.FieldByName('ValorIndiceParcela').asFloat;
                    dec(wsobra);
                    Post;
                  end;
             end;
          Next;
        end;
        First;
        EnableControls;
      end;
    end;
    if FTaxaRetencao>0 then
       for ix:=1 to XNumParcela do
       begin
         if FDQueryParcela.Locate('CodigoInternoParcela',vinterno[ix],[]) then
            begin
              FDQueryParcela.Edit;
              if FDQueryParcela.FieldByName('TipoOperacaoParcela').asString = 'Q' then
                 begin
                   FDQueryParcela.FieldByName('PercentualDescontoParcela').asFloat := FTaxaRetencao;
                   FDQueryParcela.FieldByName('ValorDescontoParcela').asFloat      := vvalret[ix];
                   FDQueryParcela.FieldByName('ValorFinalParcela').asFloat         := FDQueryParcela.FieldByName('ValorFinalParcela').asFloat - vvalret[ix];
                 end
              else
                 begin
                   FDQueryParcela.FieldByName('PercentualDescontoParcela').asFloat := 0;
                   FDQueryParcela.FieldByName('ValorDescontoParcela').asFloat      := 0;
                 end;
              FDQueryParcela.Post;
            end;
       end;

    while wsobrax > 0 do
    begin
      with FDQueryParcela do
      begin
        DisableControls;
        First;
        while not EOF do
        begin
          if wsobrax > 0 then
             begin
               if (XValEntrada>0) and (FDQueryParcela.FieldByName('NumeroParcela').asInteger=1) then
                  wsobrax := wsobrax+0
               else
                  begin
                    Edit;
                    FDQueryParcela.FieldByName('ValorIndiceParcela').asFloat := FDQueryParcela.FieldByName('ValorIndiceParcela').asFloat+0.01;
                    if FDQueryParcela.FieldByName('TipoOperacaoParcela').asString = 'Q' then
                       FDQueryParcela.FieldByName('ValorFinalParcela').asFloat  := FDQueryParcela.FieldByName('ValorOriginalParcela').asFloat+
                                                                                   FDQueryParcela.FieldByName('ValorIndiceParcela').asFloat-
                                                                                   FDQueryParcela.FieldByName('ValorDescontoParcela').asFloat
                    else
                       FDQueryParcela.FieldByName('ValorFinalParcela').asFloat  := FDQueryParcela.FieldByName('ValorOriginalParcela').asFloat+
                                                                                   FDQueryParcela.FieldByName('ValorIndiceParcela').asFloat;
                    dec(wsobrax);
                    Post;
                  end;
             end;
          Next;
        end;
        First;
        EnableControls;
      end;
    end;
    FDQueryParcela.EnableControls;

    with FDQueryParcela do
    begin
      Connection := FConexao.FDConnectionApi;
      DisableControls;
      Close;
      SQL.Clear;
      Params.Clear;
      SQL.Add('select "CodigoInternoParcela" as id,');
      SQL.Add('       "CodigoDocFiscalParcela" as idnfe,');
      SQL.Add('       "NumeroParcela" as numero,');
      SQL.Add('       "ValorFinalParcela" as valor,');
      SQL.Add('       "DataEmissaoParcela" as emissao,');
      SQL.Add('       "DataVencimentoParcela" as vencimento,');
      SQL.Add('       "DataOperacaoParcela" as operacao,');
      SQL.Add('       "TipoOperacaoParcela" as situacao ');
      SQL.Add('from "Parcela" where "CodigoDocFiscalParcela"=:xidnfe ');
      ParamByName('xidnfe').AsInteger := FNota;
      Open;
      EnableControls;
    end;
  except
  end;
end;
end.
