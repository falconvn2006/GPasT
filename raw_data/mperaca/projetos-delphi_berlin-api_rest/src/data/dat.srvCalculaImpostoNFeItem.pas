unit dat.srvCalculaImpostoNFeItem;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function  CalculaImpostoItem(XIdNFe,XIdItem: integer): TJSONObject;
procedure CarregaDadosItem(XIdItem: integer);
procedure GravaImpostoItem(XIdItem: integer);
procedure GravaImpostoNota(XIdNFe: integer);

implementation

uses prv.dataModuleConexao;

var FConexao: TProviderDataModuleConexao;
    FDQueryProduto: TFDQuery;
    FValorBaseICMS,FValorICMS,FValorBaseST,FValorST,FPercentualICMS,FPercentualST,FPercentualBaseICMS,FPercentualBaseST,FValorBaseCalculoFCPSTRet,FPercentualFCPSTRet,FValorFCPSTRet: double;
    FPercentualIPI,FValorIPI,FPercentualPIS,FPercentualCOFINS,FPercentualBasePIS,FPercentualBaseCOFINS,FValorPIS,FValorCOFINS,FValorBasePIS,FValorBaseCOFINS: double;
    FPercentualComissao,FValorComissao,FPercentualFCP,FValorFCP,FValorBaseCalculoFCP,FValorBaseCalculoFCPST,FPercentualFCPST,FValorFCPST: double;

function CalculaImpostoItem(XIdNFe,XIdItem: integer): TJSONObject;
var wquery: TFDQuery;
    wret: TJSONObject;
begin
  try
    wret                  := TJSONObject.Create;
    FValorBaseICMS        := 0;
    FValorICMS            := 0;
    FValorBaseST          := 0;
    FValorST              := 0;
    FPercentualICMS       := 0;
    FPercentualST         := 0;
    FPercentualBaseICMS   := 0;
    FPercentualBaseST     := 0;
    FPercentualIPI        := 0;
    FValorIPI             := 0;
    FPercentualBasePIS    := 0;
    FPercentualBaseCOFINS := 0;
    FValorPIS             := 0;
    FValorCOFINS          := 0;
    FValorBasePIS         := 0;
    FValorBaseCOFINS      := 0;
    FPercentualPIS        := 0;
    FPercentualCOFINS     := 0;
    FPercentualComissao   := 0;
    FValorComissao        := 0;
    FPercentualFCP        := 0;
    FValorFCP             := 0;
    FValorBaseCalculoFCP  := 0;
    FValorBaseCalculoFCPST    := 0;
    FPercentualFCPST          := 0;
    FValorFCPST               := 0;
    FValorBaseCalculoFCPSTRet := 0;
    FPercentualFCPSTRet       := 0;
    FValorFCPSTRet            := 0;

// cria provider de conexão com BD
    FConexao := TProviderDataModuleConexao.Create(nil);
    if FConexao.EstabeleceConexaoDB then
       begin
         CarregaDadosItem(XIdItem);
         if FDQueryProduto.FieldByName('incidest').AsBoolean then
            begin
              if FDQueryProduto.FieldByName('calculast').AsBoolean then
                // Calcula ST
            end
         else
            begin
              if FDQueryProduto.FieldByName('calculaicms').AsBoolean then
                 begin
                   // Calcula ICMS
                   FPercentualBaseICMS := FDQueryProduto.FieldByName('percbaseicmsproduto').AsFloat;
                   FPercentualICMS     := FDQueryProduto.FieldByName('percicmsproduto').AsFloat;
                   FValorBaseICMS      := (FDQueryProduto.FieldByName('totalitem').AsFloat * FPercentualBaseICMS)/100;
                   FValorICMS          := (FValorBaseICMS * FPercentualICMS)/100;
                 end;
            end;
         if FDQueryProduto.FieldByName('incidepis').AsBoolean then
            begin
              if FDQueryProduto.FieldByName('calculapis').AsBoolean then
                 begin
                   // CalculaPIS
                   FPercentualPIS     := FDQueryProduto.FieldByName('percpis').AsFloat;
                   FPercentualBasePIS := FDQueryProduto.FieldByName('percbasepisproduto').AsFloat;
                   FValorBasePIS      := FDQueryProduto.FieldByName('totalitem').AsFloat +
                                         FDQueryProduto.FieldByName('valorfrete').asFloat +
                                         FDQueryProduto.FieldByName('valordespesa').asFloat +
                                         FDQueryProduto.FieldByName('encargofinanceiro').asFloat;
                   FValorPIS          := (FValorBasePIS * FPercentualPIS)/100;
                 end;
            end;
         if FDQueryProduto.FieldByName('incidecofins').AsBoolean then
            begin
              if FDQueryProduto.FieldByName('calculacofins').AsBoolean then
                 // CalculaCOFINS
                 begin
                   FPercentualCOFINS     := FDQueryProduto.FieldByName('perccofins').AsFloat;
                   FPercentualBaseCOFINS := FDQueryProduto.FieldByName('percbasepisproduto').AsFloat;
                   FValorBaseCOFINS      := FDQueryProduto.FieldByName('totalitem').AsFloat +
                                            FDQueryProduto.FieldByName('valorfrete').asFloat +
                                            FDQueryProduto.FieldByName('valordespesa').asFloat +
                                            FDQueryProduto.FieldByName('encargofinanceiro').asFloat;
                   FValorCOFINS          := (FValorBaseCOFINS * FPercentualCOFINS)/100;
                 end;
            end;
         if FDQueryProduto.FieldByName('calculaipi').AsBoolean then
            begin
              // Calcula IPI
              FPercentualIPI := FDQueryProduto.FieldByName('percipiproduto').AsFloat;
              FValorIPI      := (FDQueryProduto.FieldByName('totalitem').AsFloat * FPercentualIPI)/100;
            end;

         // Calcula Fundo Combate Pobreza
         if FDQueryProduto.FieldByName('percfcpproduto').AsFloat>0 then
            begin
              if Copy(FDQueryProduto.FieldByName('codsittrib').AsString,2,2) = '00' then
                 begin
                   FValorBaseCalculoFCP     := FDQueryProduto.FieldByName('totalitem').AsFloat;
                   FPercentualFCP           := FDQueryProduto.FieldByName('percfcpproduto').AsFloat;
                   FValorFCP                := (FDQueryProduto.FieldByName('totalitem').AsFloat * FPercentualFCP)/100;
                 end
              else if Copy(FDQueryProduto.FieldByName('codsittrib').AsString,2,2) = '10' then
                 begin
                   FValorBaseCalculoFCP     := FDQueryProduto.FieldByName('totalitem').AsFloat;
                   FPercentualFCP           := FDQueryProduto.FieldByName('percfcpproduto').AsFloat;
                   FValorFCP                := (FValorBaseCalculoFCP * FPercentualFCP)/100;
                   FValorBaseCalculoFCPST   := FDQueryProduto.FieldByName('valorbasest').AsFloat;
                   FPercentualFCPST         := 18;
                   FValorFCPST              := (FValorBaseCalculoFCPST * FPercentualFCPST)/100;
                 end
              else if Copy(FDQueryProduto.FieldByName('codsittrib').AsString,2,2) = '20' then
                 begin
                   FValorBaseCalculoFCP     := FDQueryProduto.FieldByName('totalitem').AsFloat;
                   FPercentualFCP           := FDQueryProduto.FieldByName('percfcpproduto').AsFloat;
                   FValorFCP                := (FValorBaseCalculoFCP * FPercentualFCP)/100;
                 end
              else if Copy(FDQueryProduto.FieldByName('codsittrib').AsString,2,2) = '30' then
                 begin
                   FValorBaseCalculoFCPST   := FDQueryProduto.FieldByName('valorbasest').AsFloat;
                   FPercentualFCPST         := 18;
                   FValorFCPST              := (FValorBaseCalculoFCPST * FPercentualFCPST)/100;
                 end
              else if Copy(FDQueryProduto.FieldByName('codsittrib').AsString,2,2) = '51' then
                 begin
                   FValorBaseCalculoFCP     := FDQueryProduto.FieldByName('totalitem').AsFloat;
                   FPercentualFCP           := FDQueryProduto.FieldByName('percfcpproduto').AsFloat;
                   FValorFCP                := (FValorBaseCalculoFCP * FPercentualFCP)/100;
                 end
              else if Copy(FDQueryProduto.FieldByName('codsittrib').AsString,2,2) = '60' then
                 begin
                   FValorBaseCalculoFCPSTRet := FDQueryProduto.FieldByName('totalitem').AsFloat;
                   FPercentualFCPSTRet       := FDQueryProduto.FieldByName('percfcpproduto').AsFloat;
                   FValorFCPSTRet            := (FValorBaseCalculoFCPSTRet * FValorFCPSTRet)/100;
                 end
              else if Copy(FDQueryProduto.FieldByName('codsittrib').AsString,2,2) = '70' then
                 begin
                   FValorBaseCalculoFCP      := FDQueryProduto.FieldByName('totalitem').AsFloat;
                   FPercentualFCP            := FDQueryProduto.FieldByName('percfcpproduto').AsFloat;
                   FValorFCP                 := (FValorBaseCalculoFCP * FPercentualFCP)/100;
                   FValorBaseCalculoFCPST    := FDQueryProduto.FieldByName('valorbasest').AsFloat;
                   FPercentualFCPST          := 18;
                   FValorFCPST               := (FValorBaseCalculoFCPST * FPercentualFCPST)/100;
                 end
              else if Copy(FDQueryProduto.FieldByName('codsittrib').AsString,2,2) = '90' then
                 begin
                   FValorBaseCalculoFCP      := FDQueryProduto.FieldByName('totalitem').AsFloat;
                   FPercentualFCP            := FDQueryProduto.FieldByName('percfcpproduto').AsFloat;
                   FValorFCP                 := (FValorBaseCalculoFCP * FPercentualFCP)/100;
                   FValorBaseCalculoFCPST    := FDQueryProduto.FieldByName('valorbasest').AsFloat;
                   FPercentualFCPST          := 18;
                   FValorFCPST               := (FValorBaseCalculoFCPST * FPercentualFCPST)/100;
                 end;
            end;

         // Calcula Comissão
         FPercentualComissao := FDQueryProduto.FieldByName('perccomissaoproduto').AsFloat;
         FValorComissao      := (FDQueryProduto.FieldByName('totalitem').AsFloat * FPercentualComissao)/100;

         //Grava Impostos no Item
         GravaImpostoItem(XIdItem);
         //Grava Impostos na Nota
         GravaImpostoItem(XIdNFe);
       end;
    wret.AddPair('id',inttostr(XIdItem));
    wret.AddPair('idnfe',inttostr(XIdNFe));
    wret.AddPair('percentualicm',floattostr(FPercentualICMS));
    wret.AddPair('valorbaseicm',floattostr(FValorBaseICMS));
    wret.AddPair('valoricm',floattostr(FValorICMS));
    wret.AddPair('percentualst',floattostr(FPercentualST));
    wret.AddPair('valorbasest',floattostr(FValorBaseST));
    wret.AddPair('valorst',floattostr(FValorST));
    wret.AddPair('percentualipi',floattostr(FPercentualIPI));
    wret.AddPair('valoripi',floattostr(FValorIPI));
    wret.AddPair('percentualpis',floattostr(FPercentualPIS));
    wret.AddPair('valorpis',floattostr(FValorPIS));
    wret.AddPair('percentualcofins',floattostr(FPercentualCOFINS));
    wret.AddPair('valorcofins',floattostr(FValorCOFINS));
    wret.AddPair('percentualcomissao',floattostr(FPercentualComissao));
    wret.AddPair('valorcomissao',floattostr(FValorComissao));
  except
    On E: Exception do
    begin
      wret.AddPair('status','500');
      wret.AddPair('description',E.Message);
      wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
      FConexao.EncerraConexaoDB;
    end;
  end;
  FConexao.EncerraConexaoDB;
  Result := wret;
end;

// carrega dados do item
procedure CarregaDadosItem(XIdItem: integer);
begin
  FDQueryProduto := TFDQuery.Create(nil);
  with FDQueryProduto do
  begin
    Connection := FConexao.FDConnectionApi;
    DisableControls;
    Close;
    SQL.Clear;
    Params.Clear;
    SQL.Add('select "NotaItem"."CodigoInternoItem"         as id,');
    SQL.Add('       "NotaItem"."CodigoProdutoItem"         as idproduto,');
    SQL.Add('       "NotaItem"."QuantidadeItem"            as quantidade,');
    SQL.Add('       "NotaItem"."ValorUnitarioItem"         as unitario,');
    SQL.Add('       "NotaItem"."ValorTotalItem"            as totalitem,');
    SQL.Add('       "NotaItem"."CodigoFiscalItem"          as codfiscal,');
    SQL.Add('       "NotaItem"."ValorFreteItem"            as valorfrete,');
    SQL.Add('       "NotaItem"."ValorDespesaItem"          as valordespesa,');
    SQL.Add('       "NotaItem"."ValorEncargoFinanceiroItem"    as encargofinanceiro,');
    SQL.Add('       "NotaItem"."ValorBaseICMSSubstituicaoItem" as valorbasest,');
    SQL.Add('       ts_retornafiscalcodigo("NotaItem"."CodigoFiscalItem") as cfop,');
    SQL.Add('       ts_retornafiscalicms("NotaItem"."CodigoFiscalItem")   as calculaicms,');
    SQL.Add('       ts_retornafiscalirt("NotaItem"."CodigoFiscalItem")    as calculast,');
    SQL.Add('       ts_retornafiscalipi("NotaItem"."CodigoFiscalItem")    as calculaipi,');
    SQL.Add('       ts_retornafiscalpis("NotaItem"."CodigoFiscalItem")    as calculapis,');
    SQL.Add('       ts_retornafiscalcofins("NotaItem"."CodigoFiscalItem") as calculacofins,');
    SQL.Add('       "Produto"."IncideSubstituicaoProduto"  as incidest,');
    SQL.Add('       "Produto"."IncidePISProduto"           as incidepis,');
    SQL.Add('       "Produto"."IncideCOFINSProduto"        as incidecofins,');
    SQL.Add('       "Produto"."IncideDiferimentoProduto"   as incidediferimento,');
    SQL.Add('       "Produto"."PercentualICMSProduto"      as percicmsproduto,');
    SQL.Add('       "Produto"."BaseCalculoProduto"         as percbaseicmsproduto,');
    SQL.Add('       "Produto"."AliquotaSTProduto"          as percstproduto,');
    SQL.Add('       "Produto"."PercentualReducaoSTProduto" as percreducaostproduto,');
    SQL.Add('       "Produto"."PercentualIPIProduto"       as percipiproduto,');
    SQL.Add('       "Produto"."BasePISSaidaProduto"        as percbasepisproduto,');
    SQL.Add('       "Produto"."BaseCOFINSSaidaProduto"     as percbasecofinsproduto,');
    SQL.Add('       "Produto"."CSTPISSaidaProduto"         as cstpisproduto,');
    SQL.Add('       "Produto"."CSTCOFINSSaidaProduto"      as cstcofinsproduto,');
    SQL.Add('       "Produto"."PercentualComissaoProduto"  as perccomissaoproduto,');
    SQL.Add('       ts_retornaclassificacaofiscalpercentualfcp("Produto"."ClassificacaoFiscalProduto") as percfcpproduto,');
    SQL.Add('       ts_retornasituacaotributariacodigo("NotaItem"."CodigoSituacaoTributariaItem") as codsittrib,');
    SQL.Add('       (select "PercentualPISConfigura"    from "ConfiguracaoTSCompras" where "CodigoEmpresaConfigura"="NotaItem"."CodigoEmpresaItem") as percpis,');
    SQL.Add('       (select "PercentualCofinsConfigura" from "ConfiguracaoTSCompras" where "CodigoEmpresaConfigura"="NotaItem"."CodigoEmpresaItem") as perccofins ');
    SQL.Add('from "NotaItem" inner join "Produto" on "NotaItem"."CodigoProdutoItem" = "Produto"."CodigoInternoProduto" ');
    SQL.Add('where "NotaItem"."CodigoInternoItem" =:xiditem ');
    ParamByName('xiditem').AsInteger := XIdItem;
    Open;
    EnableControls;
  end;
end;

// Grava Imposto no Item
procedure GravaImpostoItem(XIdItem: integer);
var FDQueryItem: TFDQuery;
begin
  FDQueryItem := TFDQuery.Create(nil);
  with FDQueryItem do
  begin
    Connection := FConexao.FDConnectionApi;
    DisableControls;
    Close;
    SQL.Clear;
    Params.Clear;
    SQL.Add('select * from "NotaItem" where "CodigoInternoItem"=:xid ');
    ParamByName('xid').AsInteger := XIdItem;
    Open;
    EnableControls;
    if RecordCount>0 then
       begin
         Edit;
         FieldByName('PercentualICMS').AsFloat                     := FPercentualICMS;
         FieldByName('ValorICMS').AsFloat                          := FValorICMS;
         FieldByName('ValorBaseICMSItem').AsFloat                  := FValorBaseICMS;
         FieldByName('PercentualIPI').AsFloat                      := FPercentualIPI;
         FieldByName('ValorIPI').AsFloat                           := FValorIPI;
         FieldByName('PercentualICMSSubstituicao').AsFloat         := FPercentualST;
         FieldByName('ValorICMSSubstituicao').AsFloat              := FValorST;
         FieldByName('ValorBaseICMSSubstituicaoItem').AsFloat      := FValorBaseST;
         FieldByName('PercentualBaseICMSSubstituicaoItem').AsFloat := FPercentualBaseST;
         FieldByName('PercentualPISItem').AsFloat                  := FPercentualPIS;
         FieldByName('ValorPISCreditadoItem').AsFloat              := FValorPIS;
         FieldByName('PercentualBasePISItem').AsFloat              := FPercentualBasePIS;
         FieldByName('PercentualCOFINSItem').AsFloat               := FPercentualCOFINS;
         FieldByName('ValorCofinsCreditadoItem').AsFloat           := FValorCOFINS;
         FieldByName('PercentualBaseCOFINSItem').AsFloat           := FPercentualBaseCOFINS;
         FieldByName('PercentualBasePISCofinsItem').AsFloat        := FPercentualBaseCOFINS;
         FieldByName('CodigoCSTPISItem').AsString                  := FDQueryProduto.FieldByName('cstpisproduto').AsString;
         FieldByName('CodigoCSTCOFINSItem').AsString               := FDQueryProduto.FieldByName('cstcofinsproduto').AsString;
         FieldByName('ValorBaseCalculoFCPItem').AsFloat            := FValorBaseCalculoFCP;
         FieldByName('PercentualFCPItem').AsFloat                  := FPercentualFCP;
         FieldByName('ValorFCPItem').AsFloat                       := FValorFCP;
         FieldByName('ValorBaseCalculoFCPSTItem').AsFloat          := FValorBaseCalculoFCPST;
         FieldByName('PercentualFCPSTItem').AsFloat                := FPercentualFCPST;
         FieldByName('ValorFCPSTItem').AsFloat                     := FValorFCPST;
         FieldByName('ValorBaseCalculoFCPSTRetItem').AsFloat       := FValorBaseCalculoFCPSTRet;
         FieldByName('PercentualFCPSTRetItem').AsFloat             := FPercentualFCPSTRet;
         FieldByName('ValorFCPSTRetItem').AsFloat                  := FValorFCPSTRet;
         FieldByName('PercentualComissaoItem').AsFloat             := FPercentualComissao;
         FieldByName('ValorComissaoItem').AsFloat                  := FValorComissao;
         Post;
       end;
  end;
end;

//Grava Imposto na Nota
procedure GravaImpostoNota(XIdNFe: integer);
var FDQueryItem,FDQueryNota: TFDQuery;
begin
  FDQueryItem := TFDQuery.Create(nil);
  FDQueryNota := TFDQuery.Create(nil);
  with FDQueryItem do
  begin
    Connection := FConexao.FDConnectionApi;
    DisableControls;
    Close;
    SQL.Clear;
    Params.Clear;
    SQL.Add('select sum(coalesce("ValorICMS",0)) as totalicms,');
    SQL.Add('       sum(coalesce("ValorBaseICMSItem",0)) as totalbaseicms,');
    SQL.Add('       sum(coalesce("ValorIPI",0)) as totalipi,');
    SQL.Add('       sum(coalesce("ValorICMSSubstituicao",0)) as totalicmsst,');
    SQL.Add('       sum(coalesce("ValorBaseICMSSubstituicaoItem",0)) as totalbaseicmsst,');
    SQL.Add('       sum(coalesce("ValorPISCreditadoItem",0)) as totalpis,');
    SQL.Add('       sum(coalesce("ValorCofinsCreditadoItem",0)) as totalcofins ');
    SQL.Add('from "NotaItem" where "CodigoNotaItem"=:xid ');
    ParamByName('xid').AsInteger := XIdNFe;
    Open;
    EnableControls;
  end;
  with FDQueryNota do
  begin
    Connection := FConexao.FDConnectionApi;
    DisableControls;
    Close;
    SQL.Clear;
    Params.Clear;
    SQL.Add('select * from "NotaFiscal" where "CodigoInternoNota"=:xid ');
    ParamByName('xid').AsInteger := XIdNFe;
    Open;
    EnableControls;
    if RecordCount>0 then
       begin
         Edit;
         FieldByName('BaseICMSNota').AsFloat               := FDQueryItem.FieldByName('totalbaseicms').AsFloat;
         FieldByName('TotalICMSNota').AsFloat              := FDQueryItem.FieldByName('totalicms').AsFloat;
         FieldByName('BaseICMSSubstituicaoNota').AsFloat   := FDQueryItem.FieldByName('totalbaseicmsst').AsFloat;
         FieldByName('TotalICMSSubstituicaoNota').AsFloat  := FDQueryItem.FieldByName('totalicmsst').AsFloat;
         FieldByName('TotalIPINota').AsFloat               := FDQueryItem.FieldByName('totalipi').AsFloat;
         FieldByName('TotalPISNota').AsFloat               := FDQueryItem.FieldByName('totalpis').AsFloat;
         FieldByName('TotalCOFINSNota').AsFloat            := FDQueryItem.FieldByName('totalcofins').AsFloat;
         Post;
       end;
  end;
end;



end.
