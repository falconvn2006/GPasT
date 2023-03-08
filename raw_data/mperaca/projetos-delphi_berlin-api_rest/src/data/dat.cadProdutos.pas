unit dat.cadProdutos;

interface

uses Vcl.Dialogs, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,JPEG,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections, Winapi.Windows, Vcl.Graphics, Soap.EncdDecd, IdCoderMIME,
  ExtCtrls, Synacode, IniFiles;


function RetornaProduto(XId: integer): TJSONObject;
function RetornaListaProdutos(const XQuery: TDictionary<string, string>; XPagina,XLimit,XOffset: integer): TJSONArray;
function RetornaTotalProdutos(const XQuery: TDictionary<string, string>): TJSONObject;
procedure AtribuiFotoProduto(XCodigo,XCaminho: string; XMaximo: integer; XQuery: TFDQuery);
function RetornaBase64(XArquivo: string; XMaximo: integer): widestring;
function IncluiProduto(XProduto: TJSONObject): TJSONObject;
function VerificaRequisicao(XProduto: TJSONObject): boolean;
function AlteraProduto(XIdProduto: integer; XProduto: TJSONObject): TJSONObject;
function ApagaProduto(XIdProduto: integer): TJSONObject;

//function RetornaFotoBase64(XFoto: string): string;

implementation

uses prv.dataModuleConexao, Vcl.Controls, System.UITypes, System.NetEncoding,
  prv.fotoProduto;

function RetornaProduto(XId: integer): TJSONObject;
var wquery: TFDQuery;
    wconexao: TProviderDataModuleConexao;
    wret: TJSONObject;
    warqini: TInifile;
    wexibefoto: boolean;
    wcaminho: string;
    wmaximo: integer;
begin
  try
// cria provider de conexão com BD
    wconexao := TProviderDataModuleConexao.Create(nil);

    wquery   := TFDQuery.Create(nil);

    if FileExists(GetCurrentDir+'\TrabinApi.ini') then
       begin
         warqini    := TIniFile.Create(GetCurrentDir+'\TrabinApi.ini');
         wexibefoto := UpperCase(warqini.ReadString('Fotos','Exibir','Não'))='SIM';
         wcaminho   := warqini.ReadString('Fotos','Caminho','');
         wmaximo    := warqini.ReadInteger('Fotos','TamanhoMaximo(Kb)',300);
       end
    else
       begin
         wexibefoto := false;
         wcaminho   := '';
         wmaximo    := 0;
       end;

    if wconexao.EstabeleceConexaoDB then
       with wquery do
       begin
         Connection := wconexao.FDConnectionApi;
         DisableControls;
         Close;
         SQL.Clear;
         Params.Clear;
         SQL.Add('select "CodigoInternoProduto" as id,');
         SQL.Add('       "CodigoProduto"        as codigo,');
         SQL.Add('       "DescricaoProduto"     as descricao, ');
         SQL.Add('       "ReferenciaProduto"    as referencia, ');
         SQL.Add('       "AtivoProduto"         as ativo, ');
         SQL.Add('       "UnidadeProduto"       as unidade, ');
         SQL.Add('       "CodigoEstruturalProduto" as idestrutura, ');
         SQL.Add('       ts_retornaplanodeestoqueestrutural("CodigoEstruturalProduto") as xestrutura, ');
         SQL.Add('       "MinimoProduto"        as pontominimo, ');
         SQL.Add('       "PedidoProduto"        as pontopedido, ');
         SQL.Add('       "MaximoProduto"        as pontomaximo, ');
         SQL.Add('       "PesoBrutoProduto"     as pesobruto, ');
         SQL.Add('       "PesoLiquidoProduto"   as pesoliquido, ');
         SQL.Add('       "QuantidadeEmbalagemProduto" as qtdembalagem, ');
         SQL.Add('       "BaseCalculoProduto"         as basecalculoicms, ');
         SQL.Add('       "PercentualICMSProduto"      as percentualicms, ');
         SQL.Add('       "PercentualIPIProduto"       as percentualipi, ');
         SQL.Add('       "ClassificacaoProduto"       as classificacao, ');
         SQL.Add('       "CustoProduto"               as precocusto, ');
         SQL.Add('       "Venda1Produto"              as preco1, ');
         SQL.Add('       "Venda2Produto"              as preco2, ');
         SQL.Add('       "Venda3Produto"              as preco3, ');
         SQL.Add('       "Venda4Produto"              as preco4, ');
         SQL.Add('       "Venda5Produto"              as preco5, ');
         SQL.Add('       "Venda6Produto"              as preco6, ');
         SQL.Add('       "Venda7Produto"              as preco7, ');
         SQL.Add('       "Venda8Produto"              as preco8, ');
         SQL.Add('       "Venda9Produto"              as preco9, ');
         SQL.Add('       "Venda10Produto"             as preco10, ');
         SQL.Add('       "FormulaCalculoProduto"      as idformula, ');
         SQL.Add('       "NumeroSerieProduto"         as numserie, ');
         SQL.Add('       "AplicacaoProduto"           as aplicacao, ');
         SQL.Add('       "ObservacaoProduto"          as observacao, ');
         SQL.Add('       "DataCadastramentoProduto"   as datacadastramento, ');
         SQL.Add('       "EstoqueProduto"             as qtdestoque, ');
         SQL.Add('       "EncomendadoProduto"         as qtdencomendado, ');
         SQL.Add('       "TotalCustoProduto"          as totalcusto, ');
         SQL.Add('       "TotalVendaProduto"          as totalvenda, ');
         SQL.Add('       "DataEntradaProduto"         as dataentrada, ');
         SQL.Add('       "OperacaoEntradaProduto"     as idoperacaoentrada, ');
         SQL.Add('       "QuantidadeEntradaProduto"   as qtdentrada, ');
         SQL.Add('       "DataSaidaProduto"           as datasaida, ');
         SQL.Add('       "OperacaoSaidaProduto"       as idoperacaosaida, ');
         SQL.Add('       "QuantidadeSaidaProduto"     as qtdsaida, ');
         SQL.Add('       "TotalEntradaProduto"        as totalentrada, ');
         SQL.Add('       "TotalSaidaProduto"          as totalsaida, ');
         SQL.Add('       "TipoProduto"                    as tipo, ');
         SQL.Add('       "PrazoValidadeProduto"            as prazovalidade, ');
         SQL.Add('       "TeclaAssociadaProduto"           as teclaassociada, ');
         SQL.Add('       "DescricaoReduzidaProduto"        as descricaoreduzida, ');
         SQL.Add('       "QtdeEtiquetaProduto"             as qtdetiqueta, ');
         SQL.Add('       "HoraUltimaAlteracaoProduto"      as horaultimaalteracao, ');
         SQL.Add('       "CodigoAliquotaProduto"           as idaliquota, ');
         SQL.Add('       ts_retornaaliquotacodigo("CodigoAliquotaProduto")       as xcodaliquotaicm, ');
         SQL.Add('       ts_retornaaliquotabasecalculo("CodigoAliquotaProduto")  as xbaseicm,');
         SQL.Add('       ts_retornaaliquotapercentualrs("CodigoAliquotaProduto") as xpercaliquotaicm,');
         SQL.Add('       (ts_retornaaliquotacodigo("CodigoAliquotaProduto")||'' - ''||to_char(ts_retornaaliquotapercentualrs("CodigoAliquotaProduto"),''fm999G990D00%'')) as xaliquotaicm,');
         SQL.Add('       "MargemLucroProduto"              as margemlucro, ');
         SQL.Add('       "CodigoSetorProduto"              as idsetor, ');
         SQL.Add('       "IncideSubstituicaoProduto"       as incidest, ');
         SQL.Add('       "FabricanteProduto"               as fabricante, ');
         SQL.Add('       "CodigoFabricanteProduto"         as idfabricante, ');
         SQL.Add('       "SituacaoTributariaProduto"       as idsituacaotributaria, ');
         SQL.Add('       ts_retornasituacaotributariacodigo("SituacaoTributariaProduto") as xsituacaotributaria,');
         SQL.Add('       "BitolaProduto"                   as bitola, ');
         SQL.Add('       "MarcaProduto"                    as marca, ');
         SQL.Add('       "CaminhoFotoProduto"              as caminhofoto, ');
         SQL.Add('       "PercentualComissaoProduto"       as percentualcomissao, ');
         SQL.Add('       "CodigoBarraProduto"              as cean,');
         SQL.Add('       "SaldoEstoqueProduto"             as saldoestoque,');
         SQL.Add('       "PercentualValorAgregadoProduto"  as mva,');
         SQL.Add('       "PercentualICMSDestinoProduto"    as icmdestino,');
         SQL.Add('       coalesce("CodigoGradeProduto",0)  as grade, ');
         SQL.Add('       "PercentualPromocionalProduto"    as percentualpromocao,');
         SQL.Add('       "CaracteristicaProduto"           as caracteristica,');
         SQL.Add('       "QuantidadeFracionadaProduto"     as qtdfracionada,');
         SQL.Add('       "EhCompostoProduto"               as ehcomposto,');
         SQL.Add('       "EhCalculadoProduto"              as ehcalculado,');
         SQL.Add('       "PercentualQuebraProduto"         as percquebra,');
         SQL.Add('       "IncidePISProduto"                as incidepis,');
         SQL.Add('       "IncideCOFINSProduto"             as incidecofins,');
         SQL.Add('       "ClassificacaoFiscalProduto"      as idclassificacaofiscal,');
         SQL.Add('       "PercentualICMSAnteriorProduto"   as percicmsanterior,');
         SQL.Add('       "TipoCadastroProduto"             as tipocadastro,');
         SQL.Add('       "BasePISEntradaProduto"           as basepisentrada,');
         SQL.Add('       "BaseCOFINSEntradaProduto"        as basecofinsentrada,');
         SQL.Add('       "BasePISSaidaProduto"             as basepissaida,');
         SQL.Add('       "BaseCOFINSSaidaProduto"          as basecofinssaida,');
         SQL.Add('       "CSTPISEntradaProduto"            as cstpisentrada,');
         SQL.Add('       "CSTCOFINSEntradaProduto"         as cstcofinsentrada,');
         SQL.Add('       "CSTPISSaidaProduto"              as cstpissaida,');
         SQL.Add('       "CSTCOFINSSaidaProduto"           as cstcofinssaida,');
         SQL.Add('       cast((select "PercentualPISConfigura" from "ConfiguracaoTSCompras" where "CodigoEmpresaConfigura"=:xidempresa) as numeric) as xpercpis,');
         SQL.Add('       cast((select "PercentualCofinsConfigura" from "ConfiguracaoTSCompras" where "CodigoEmpresaConfigura"=:xidempresa) as numeric) as xperccofins,');
         SQL.Add('       "PercentualMargemFixaProduto"     as margemfixa,');
         SQL.Add('       "CodigoContabilProduto"           as idcodigocontabil,');
         SQL.Add('       "PercentualDescontoProduto"       as percdesconto,');
         SQL.Add('       "QuantidadeDescontoProduto"       as qtddesconto,');
         SQL.Add('       "FonteCaracteristicaProduto"      as fontecaracteristica,');
         SQL.Add('       "QuantidadeUnidadePUMProduto"     as qtdunidadepum,');
         SQL.Add('       "UnidadeQuantidadePUMProduto"     as unidadeqtdepum,');
         SQL.Add('       "UnidadeReferencialPUMProduto"    as unidaderefpum,');
         SQL.Add('       "EnviaSiteProduto"                as enviasite,');
         SQL.Add('       "DataEnvioSiteProduto"            as dataenviosite,');
         SQL.Add('       "UsuarioEnvioSiteProduto"         as idusuarioenviosite,');
         SQL.Add('       "NumeroFCIProduto"                as numerofci,');
         SQL.Add('       "TemFotoProduto"                  as temfoto,');
         SQL.Add('       "DCTFPisProduto"                  as dctfpis,');
         SQL.Add('       "DCTFCofinsProduto"               as dctfcofins,');
         SQL.Add('       "CodigoNaturezaProduto"           as codnatureza,');
         SQL.Add('       "IncideDiferimentoProduto"        as incidediferimento,');
         SQL.Add('       "CodigoFamiliaProduto"            as idfamilia,');
         SQL.Add('       "DescricaoExtendidaProduto"       as descricaoextendida,');
         SQL.Add('       "AliquotaSTProduto"               as idaliquotast,');
         SQL.Add('       "PercentualReducaoSTProduto"      as percreducaost,');
         SQL.Add('       "CodigoBeneficioFiscalProduto"    as cbnef,');
         SQL.Add('       "ComprimentoProduto"              as comprimento,');
         SQL.Add('       "AlturaProduto"                   as altura,');
         SQL.Add('       "ProfundidadeProduto"             as profundidade,');
         SQL.Add('       "CodigoCategoriaProduto"          as idcategoria,');
         SQL.Add('       "PercentualMargemVendaProduto"    as margemvenda,');
         SQL.Add('       "PercentualFreteProduto"          as percfrete,');
         SQL.Add('       cast('''' as text)  as foto, ');
         SQL.Add('       cast(0 as numeric)  as xsaldo ');
         SQL.Add('from "Produto" ');
         SQL.Add('where "CodigoInternoProduto"=:xid and "AtivoProduto"=''true'' ');
         ParamByName('xid').AsInteger := XId;
         ParamByName('xidempresa').AsInteger := wconexao.FIdEmpresa;
         Open;
         EnableControls;
       end;

   if wquery.RecordCount>0 then
      begin
        if wexibefoto then
           AtribuiFotoProduto(wquery.FieldByName('codigo').AsString,wcaminho,wmaximo,wquery);
        wret := wquery.ToJSONObject()
      end
   else
      begin
        wret := TJSONObject.Create;
        wret.AddPair('status','404');
        wret.AddPair('description','Nenhum produto encontrado');
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

function RetornaListaProdutos(const XQuery: TDictionary<string, string>; XPagina,XLimit,XOffset: integer): TJSONArray;
var wqueryLista: TFDQuery;
    wconexao: TProviderDataModuleConexao;
    wobj: TJSONObject;
    wret: TJSONArray;
    wexibefoto: boolean;
    warqini: TIniFile;
    wcaminho,wordem: string;
    wmaximo: integer;
begin
  try
// cria provider de conexão com BD
    wconexao    := TProviderDataModuleConexao.Create(nil);
    wqueryLista := TFDQuery.Create(nil);
    if FileExists(GetCurrentDir+'\TrabinApi.ini') then
       begin
         warqini    := TIniFile.Create(GetCurrentDir+'\TrabinApi.ini');
         wexibefoto := UpperCase(warqini.ReadString('Fotos','Exibir','Não'))='SIM';
         wcaminho   := warqini.ReadString('Fotos','Caminho','');
         wmaximo    := warqini.ReadInteger('Fotos','TamanhoMaximo(Kb)',300);
       end
    else
       begin
         wexibefoto := false;
         wcaminho   := '';
         wmaximo    := 0;
       end;

    if wconexao.EstabeleceConexaoDB then
       with wqueryLista do
       begin
         Connection := wconexao.FDConnectionApi;
         DisableControls;
         Close;
         SQL.Clear;
         Params.Clear;
         SQL.Add('select "CodigoInternoProduto" as id,');
         SQL.Add('       "CodigoProduto"        as codigo,');
         SQL.Add('       "DescricaoProduto"     as descricao, ');
         SQL.Add('       "ReferenciaProduto"    as referencia, ');
         SQL.Add('       "AtivoProduto"         as ativo, ');
         SQL.Add('       "UnidadeProduto"       as unidade, ');
         SQL.Add('       "CodigoEstruturalProduto" as idestrutura, ');
         SQL.Add('       ts_retornaplanodeestoqueestrutural("CodigoEstruturalProduto") as xestrutura, ');
         SQL.Add('       "MinimoProduto"        as pontominimo, ');
         SQL.Add('       "PedidoProduto"        as pontopedido, ');
         SQL.Add('       "MaximoProduto"        as pontomaximo, ');
         SQL.Add('       "PesoBrutoProduto"     as pesobruto, ');
         SQL.Add('       "PesoLiquidoProduto"   as pesoliquido, ');
         SQL.Add('       "QuantidadeEmbalagemProduto" as qtdembalagem, ');
         SQL.Add('       "BaseCalculoProduto"         as basecalculoicms, ');
         SQL.Add('       "PercentualICMSProduto"      as percentualicms, ');
         SQL.Add('       "PercentualIPIProduto"       as percentualipi, ');
         SQL.Add('       "ClassificacaoProduto"       as classificacao, ');
         SQL.Add('       "CustoProduto"               as precocusto, ');
         SQL.Add('       "Venda1Produto"              as preco1, ');
         SQL.Add('       "Venda2Produto"              as preco2, ');
         SQL.Add('       "Venda3Produto"              as preco3, ');
         SQL.Add('       "Venda4Produto"              as preco4, ');
         SQL.Add('       "Venda5Produto"              as preco5, ');
         SQL.Add('       "Venda6Produto"              as preco6, ');
         SQL.Add('       "Venda7Produto"              as preco7, ');
         SQL.Add('       "Venda8Produto"              as preco8, ');
         SQL.Add('       "Venda9Produto"              as preco9, ');
         SQL.Add('       "Venda10Produto"             as preco10, ');
         SQL.Add('       "FormulaCalculoProduto"      as idformula, ');
         SQL.Add('       "NumeroSerieProduto"         as numserie, ');
         SQL.Add('       "AplicacaoProduto"           as aplicacao, ');
         SQL.Add('       "ObservacaoProduto"          as observacao, ');
         SQL.Add('       "DataCadastramentoProduto"   as datacadastramento, ');
         SQL.Add('       "EstoqueProduto"             as qtdestoque, ');
         SQL.Add('       "EncomendadoProduto"         as qtdencomendado, ');
         SQL.Add('       "TotalCustoProduto"          as totalcusto, ');
         SQL.Add('       "TotalVendaProduto"          as totalvenda, ');
         SQL.Add('       "DataEntradaProduto"         as dataentrada, ');
         SQL.Add('       "OperacaoEntradaProduto"     as idoperacaoentrada, ');
         SQL.Add('       "QuantidadeEntradaProduto"   as qtdentrada, ');
         SQL.Add('       "DataSaidaProduto"           as datasaida, ');
         SQL.Add('       "OperacaoSaidaProduto"       as idoperacaosaida, ');
         SQL.Add('       "QuantidadeSaidaProduto"     as qtdsaida, ');
         SQL.Add('       "TotalEntradaProduto"        as totalentrada, ');
         SQL.Add('       "TotalSaidaProduto"          as totalsaida, ');
         SQL.Add('       "TipoProduto"                    as tipo, ');
         SQL.Add('       "PrazoValidadeProduto"            as prazovalidade, ');
         SQL.Add('       "TeclaAssociadaProduto"           as teclaassociada, ');
         SQL.Add('       "DescricaoReduzidaProduto"        as descricaoreduzida, ');
         SQL.Add('       "QtdeEtiquetaProduto"             as qtdetiqueta, ');
         SQL.Add('       "HoraUltimaAlteracaoProduto"      as horaultimaalteracao, ');
         SQL.Add('       "CodigoAliquotaProduto"           as idaliquota, ');
         SQL.Add('       ts_retornaaliquotacodigo("CodigoAliquotaProduto")       as xcodaliquotaicm, ');
         SQL.Add('       ts_retornaaliquotabasecalculo("CodigoAliquotaProduto")  as xbaseicm,');
         SQL.Add('       ts_retornaaliquotapercentualrs("CodigoAliquotaProduto") as xpercaliquotaicm,');
         SQL.Add('       (ts_retornaaliquotacodigo("CodigoAliquotaProduto")||'' - ''||to_char(ts_retornaaliquotapercentualrs("CodigoAliquotaProduto"),''fm999G990D00%'')) as xaliquotaicm,');
         SQL.Add('       "MargemLucroProduto"              as margemlucro, ');
         SQL.Add('       "CodigoSetorProduto"              as idsetor, ');
         SQL.Add('       "IncideSubstituicaoProduto"       as incidest, ');
         SQL.Add('       "FabricanteProduto"               as fabricante, ');
         SQL.Add('       "CodigoFabricanteProduto"         as idfabricante, ');
         SQL.Add('       "SituacaoTributariaProduto"       as idsituacaotributaria, ');
         SQL.Add('       ts_retornasituacaotributariacodigo("SituacaoTributariaProduto") as xsituacaotributaria,');
         SQL.Add('       "BitolaProduto"                   as bitola, ');
         SQL.Add('       "MarcaProduto"                    as marca, ');
         SQL.Add('       "CaminhoFotoProduto"              as caminhofoto, ');
         SQL.Add('       "PercentualComissaoProduto"       as percentualcomissao, ');
         SQL.Add('       "CodigoBarraProduto"              as cean,');
         SQL.Add('       "SaldoEstoqueProduto"             as saldoestoque,');
         SQL.Add('       "PercentualValorAgregadoProduto"  as mva,');
         SQL.Add('       "PercentualICMSDestinoProduto"    as icmdestino,');
         SQL.Add('       coalesce("CodigoGradeProduto",0)  as grade, ');
         SQL.Add('       "PercentualPromocionalProduto"    as percentualpromocao,');
         SQL.Add('       "CaracteristicaProduto"           as caracteristica,');
         SQL.Add('       "QuantidadeFracionadaProduto"     as qtdfracionada,');
         SQL.Add('       "EhCompostoProduto"               as ehcomposto,');
         SQL.Add('       "EhCalculadoProduto"              as ehcalculado,');
         SQL.Add('       "PercentualQuebraProduto"         as percquebra,');
         SQL.Add('       "IncidePISProduto"                as incidepis,');
         SQL.Add('       "IncideCOFINSProduto"             as incidecofins,');
         SQL.Add('       "ClassificacaoFiscalProduto"      as idclassificacaofiscal,');
         SQL.Add('       "PercentualICMSAnteriorProduto"   as percicmsanterior,');
         SQL.Add('       "TipoCadastroProduto"             as tipocadastro,');
         SQL.Add('       "BasePISEntradaProduto"           as basepisentrada,');
         SQL.Add('       "BaseCOFINSEntradaProduto"        as basecofinsentrada,');
         SQL.Add('       "BasePISSaidaProduto"             as basepissaida,');
         SQL.Add('       "BaseCOFINSSaidaProduto"          as basecofinssaida,');
         SQL.Add('       "CSTPISEntradaProduto"            as cstpisentrada,');
         SQL.Add('       "CSTCOFINSEntradaProduto"         as cstcofinsentrada,');
         SQL.Add('       "CSTPISSaidaProduto"              as cstpissaida,');
         SQL.Add('       "CSTCOFINSSaidaProduto"           as cstcofinssaida,');
         SQL.Add('       cast((select "PercentualPISConfigura" from "ConfiguracaoTSCompras" where "CodigoEmpresaConfigura"=:xidempresa) as numeric) as xpercpis,');
         SQL.Add('       cast((select "PercentualCofinsConfigura" from "ConfiguracaoTSCompras" where "CodigoEmpresaConfigura"=:xidempresa) as numeric) as xperccofins,');
         SQL.Add('       "PercentualMargemFixaProduto"     as margemfixa,');
         SQL.Add('       "CodigoContabilProduto"           as idcodigocontabil,');
         SQL.Add('       "PercentualDescontoProduto"       as percdesconto,');
         SQL.Add('       "QuantidadeDescontoProduto"       as qtddesconto,');
         SQL.Add('       "FonteCaracteristicaProduto"      as fontecaracteristica,');
         SQL.Add('       "QuantidadeUnidadePUMProduto"     as qtdunidadepum,');
         SQL.Add('       "UnidadeQuantidadePUMProduto"     as unidadeqtdepum,');
         SQL.Add('       "UnidadeReferencialPUMProduto"    as unidaderefpum,');
         SQL.Add('       "EnviaSiteProduto"                as enviasite,');
         SQL.Add('       "DataEnvioSiteProduto"            as dataenviosite,');
         SQL.Add('       "UsuarioEnvioSiteProduto"         as idusuarioenviosite,');
         SQL.Add('       "NumeroFCIProduto"                as numerofci,');
         SQL.Add('       "TemFotoProduto"                  as temfoto,');
         SQL.Add('       "DCTFPisProduto"                  as dctfpis,');
         SQL.Add('       "DCTFCofinsProduto"               as dctfcofins,');
         SQL.Add('       "CodigoNaturezaProduto"           as codnatureza,');
         SQL.Add('       "IncideDiferimentoProduto"        as incidediferimento,');
         SQL.Add('       "CodigoFamiliaProduto"            as idfamilia,');
         SQL.Add('       "DescricaoExtendidaProduto"       as descricaoextendida,');
         SQL.Add('       "AliquotaSTProduto"               as idaliquotast,');
         SQL.Add('       "PercentualReducaoSTProduto"      as percreducaost,');
         SQL.Add('       "CodigoBeneficioFiscalProduto"    as cbnef,');
         SQL.Add('       "ComprimentoProduto"              as comprimento,');
         SQL.Add('       "AlturaProduto"                   as altura,');
         SQL.Add('       "ProfundidadeProduto"             as profundidade,');
         SQL.Add('       "CodigoCategoriaProduto"          as idcategoria,');
         SQL.Add('       "PercentualMargemVendaProduto"    as margemvenda,');
         SQL.Add('       "PercentualFreteProduto"          as percfrete,');
         SQL.Add('       cast('''' as text)  as foto, ');
         SQL.Add('       cast(0 as numeric)  as xsaldo ');
         SQL.Add('from "Produto" where "CodigoEmpresaProduto"=:xempresa and "AtivoProduto"=''true'' ');
         ParamByName('xempresa').AsInteger   := wconexao.FIdEmpresaProduto;
         ParamByName('xidempresa').AsInteger := wconexao.FIdEmpresa;

         if XQuery.ContainsKey('descricao') then // filtro por descrição
            begin
              SQL.Add('and lower("DescricaoProduto") like lower(:xdescricao) ');
              ParamByName('xdescricao').AsString := XQuery.Items['descricao']+'%';
            end;
         if XQuery.ContainsKey('codigo') then // filtro por código
            begin
              SQL.Add('and "CodigoProduto" like :xcodigo ');
              ParamByName('xcodigo').AsString := XQuery.Items['codigo']+'%';
            end;
         if XQuery.ContainsKey('codigobarra') then // filtro por código de barras
            begin
              SQL.Add('and "CodigoBarraProduto" like :xcodigobarra ');
              ParamByName('xcodigobarra').AsString := XQuery.Items['codigobarra']+'%';
            end;
         if XQuery.ContainsKey('idestrutura') then // filtro por estrtura
            begin
              SQL.Add('and "CodigoEstruturalProduto" =:xidestrutura ');
              ParamByName('xidestrutura').AsInteger := strtointdef(XQuery.Items['idestrutura'],0);
            end;
         if XQuery.ContainsKey('unidade') then // filtro por unidade
            begin
              SQL.Add('and lower("UnidadeProduto") like lower(:xunidade) ');
              ParamByName('xunidade').AsString := XQuery.Items['unidade']+'%';
            end;
         if XQuery.ContainsKey('marca') then // filtro por marca
            begin
              SQL.Add('and lower("MarcaProduto") like lower(:xmarca) ');
              ParamByName('xmarca').AsString := XQuery.Items['marca']+'%';
            end;
         if XQuery.ContainsKey('fabricante') then // filtro por fabricante
            begin
              SQL.Add('and lower("FabricanteProduto") like lower(:xfabricante) ');
              ParamByName('xfabricante').AsString := XQuery.Items['fabricante']+'%';
            end;

         if XQuery.ContainsKey('order') then // ordenação
            begin
              wordem := 'Order by '+XQuery.Items['order'];
              if XQuery.ContainsKey('dir') then // direção
                 wordem := wordem +' '+XQuery.Items['dir'];
              SQL.Add(wordem);
            end
         else if XQuery.ContainsKey('codigo') then // filtro por código
            SQL.Add('order by "CodigoProduto","CodigoInternoProduto" ')
         else if XQuery.ContainsKey('codigobarra') then // filtro por código de barra
            SQL.Add('order by "CodigoBarraProduto","CodigoInternoProduto" ')
         else
            SQL.Add('order by "DescricaoProduto","CodigoInternoProduto" ');

         if XPagina>=0 then
            SQL.Add('Limit 20 offset '+inttostr(XPagina*20));
         if XLimit>0 then
            SQL.Add('Limit '+inttostr(XLimit)+' offset '+inttostr(XOffset));
         Open;
         EnableControls;
       end;
    if wqueryLista.RecordCount>0 then
       begin
         wqueryLista.DisableControls;
         wqueryLista.First;
         while not wqueryLista.Eof do
         begin
           if wexibefoto then
              AtribuiFotoProduto(wqueryLista.FieldByName('codigo').AsString,wcaminho,wmaximo,wqueryLista);
           wqueryLista.Next;
         end;
         wqueryLista.EnableControls;
         wret := wqueryLista.ToJSONArray();
       end
    else
       begin
         wobj := TJSONObject.Create;
         wobj.AddPair('status','404');
         wobj.AddPair('description','Nenhum produto encontrado');
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


function RetornaTotalProdutos(const XQuery: TDictionary<string, string>): TJSONObject;
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
         SQL.Add('from "Produto" ');
         SQL.Add('where "CodigoEmpresaProduto"=:xempresa and "AtivoProduto"=''true'' ');
         if XQuery.ContainsKey('descricao') then // filtro por descrição
            begin
              SQL.Add('and lower("DescricaoProduto") like lower(:xdescricao) ');
              ParamByName('xdescricao').AsString := XQuery.Items['descricao']+'%';
            end;
         if XQuery.ContainsKey('codigo') then // filtro por código
            begin
              SQL.Add('and "CodigoProduto" like :xcodigo ');
              ParamByName('xcodigo').AsString := XQuery.Items['codigo']+'%';
            end;
         if XQuery.ContainsKey('codigobarra') then // filtro por código de barras
            begin
              SQL.Add('and "CodigoBarraProduto" like :xcodigobarra ');
              ParamByName('xcodigobarra').AsString := XQuery.Items['codigobarra']+'%';
            end;
         if XQuery.ContainsKey('idestrutura') then // filtro por estrtura
            begin
              SQL.Add('and "CodigoEstruturalProduto" =:xidestrutura ');
              ParamByName('xidestrutura').AsInteger := strtointdef(XQuery.Items['idestrutura'],0);
            end;
         if XQuery.ContainsKey('unidade') then // filtro por unidade
            begin
              SQL.Add('and lower("UnidadeProduto") like lower(:xunidade) ');
              ParamByName('xunidade').AsString := XQuery.Items['unidade']+'%';
            end;
         if XQuery.ContainsKey('marca') then // filtro por marca
            begin
              SQL.Add('and lower("MarcaProduto") like lower(:xmarca) ');
              ParamByName('xmarca').AsString := XQuery.Items['marca']+'%';
            end;
         if XQuery.ContainsKey('fabricante') then // filtro por fabricante
            begin
              SQL.Add('and lower("FabricanteProduto") like lower(:xfabricante) ');
              ParamByName('xfabricante').AsString := XQuery.Items['fabricante']+'%';
            end;
         ParamByName('xempresa').AsInteger := wconexao.FIdEmpresaProduto;
         Open;
         EnableControls;
       end;

   if wquery.RecordCount>0 then
      wret := wquery.ToJSONObject()
   else
      begin
        wret := TJSONObject.Create;
        wret.AddPair('status','500');
        wret.AddPair('description','Nenhum produto encontrado');
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


procedure AtribuiFotoProduto(XCodigo,XCaminho: string; XMaximo: integer; XQuery: TFDQuery);
var warquivo: string;
    wbase64: widestring;
    wmaximo: integer;
begin
{  if FileExists(GetCurrentDir+'\TrabinApi.ini') then
     begin
       warqini  := TIniFile.Create(GetCurrentDir+'\TrabinApi.ini');
       wcaminho := warqini.ReadString('Fotos','Caminho','');
       wmaximo  := warqini.ReadInteger('Fotos','TamanhoMaximo(Kb)',300);
     end
  else
     begin
       wcaminho   := GetCurrentDir+'\fotos';
       wmaximo    := 300;
     end;}

  if fileexists(XCaminho+'\'+XCodigo+'_1.jpg') then
     warquivo := XCaminho+'\'+XCodigo+'_1.jpg'
  else
     warquivo := XCaminho+'\'+XCodigo+'.jpg';

  if FileExists(warquivo) then
     begin
       wbase64 := RetornaBase64(warquivo,XMaximo);
       XQuery.Edit;
       XQuery.FieldByName('foto').ReadOnly     := false;
       XQuery.FieldByName('foto').AsWideString := wbase64;
       XQuery.Post;
     end;
end;

function RetornaBase64(XArquivo: string;XMaximo: integer): widestring;
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
end;

function IncluiProduto(XProduto: TJSONObject): TJSONObject;
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
           SQL.Add('Insert into "Produto" ("CodigoEmpresaProduto","CodigoProduto","DescricaoProduto","ReferenciaProduto","AtivoProduto",');
           SQL.Add('"UnidadeProduto","CodigoEstruturalProduto","MinimoProduto","PedidoProduto","MaximoProduto","PesoBrutoProduto","PesoLiquidoProduto",');
           SQL.Add('"QuantidadeEmbalagemProduto","BaseCalculoProduto","PercentualICMSProduto","PercentualIPIProduto","ClassificacaoProduto",');
           SQL.Add('"CustoProduto","Venda1Produto","Venda2Produto","Venda3Produto","Venda4Produto","Venda5Produto","Venda6Produto","Venda7Produto","Venda8Produto","Venda9Produto","Venda10Produto",');
           SQL.Add('"FormulaCalculoProduto","NumeroSerieProduto","AplicacaoProduto","ObservacaoProduto","DataCadastramentoProduto","EstoqueProduto","EncomendadoProduto",');
           SQL.Add('"TotalCustoProduto","TotalVendaProduto","DataEntradaProduto","OperacaoEntradaProduto","QuantidadeEntradaProduto",');
           SQL.Add('"DataSaidaProduto","OperacaoSaidaProduto","QuantidadeSaidaProduto","TotalEntradaProduto","TotalSaidaProduto","TipoProduto",');
           SQL.Add('"PrazoValidadeProduto","TeclaAssociadaProduto","DescricaoReduzidaProduto","QtdeEtiquetaProduto",');
           SQL.Add('"HoraUltimaAlteracaoProduto","CodigoAliquotaProduto","MargemLucroProduto","CodigoSetorProduto","IncideSubstituicaoProduto","FabricanteProduto",');
           SQL.Add('"CodigoFabricanteProduto","SituacaoTributariaProduto","BitolaProduto","MarcaProduto","CaminhoFotoProduto","PercentualComissaoProduto",');
           SQL.Add('"CodigoBarraProduto","SaldoEstoqueProduto","PercentualValorAgregadoProduto","PercentualICMSDestinoProduto","CodigoGradeProduto",');
           SQL.Add('"PercentualPromocionalProduto","CaracteristicaProduto","QuantidadeFracionadaProduto","EhCompostoProduto","EhCalculadoProduto",');
           SQL.Add('"PercentualQuebraProduto","IncidePISProduto","IncideCOFINSProduto","ClassificacaoFiscalProduto","PercentualICMSAnteriorProduto",');
           SQL.Add('"TipoCadastroProduto","BasePISEntradaProduto","BaseCOFINSEntradaProduto","BasePISSaidaProduto","BaseCOFINSSaidaProduto","CSTPISEntradaProduto",');
           SQL.Add('"CSTCOFINSEntradaProduto","CSTPISSaidaProduto","CSTCOFINSSaidaProduto","PercentualMargemFixaProduto","CodigoContabilProduto",');
           SQL.Add('"PercentualDescontoProduto","QuantidadeDescontoProduto","FonteCaracteristicaProduto","QuantidadeUnidadePUMProduto","UnidadeQuantidadePUMProduto",');
           SQL.Add('"UnidadeReferencialPUMProduto","EnviaSiteProduto","DataEnvioSiteProduto","UsuarioEnvioSiteProduto","NumeroFCIProduto","TemFotoProduto","DCTFPisProduto",');
           SQL.Add('"DCTFCofinsProduto","CodigoNaturezaProduto","IncideDiferimentoProduto","CodigoFamiliaProduto","DescricaoExtendidaProduto","AliquotaSTProduto",');
           SQL.Add('"PercentualReducaoSTProduto","CodigoBeneficioFiscalProduto","ComprimentoProduto","AlturaProduto","ProfundidadeProduto","CodigoCategoriaProduto","PercentualMargemVendaProduto","PercentualFreteProduto") ');


           SQL.Add('values (:xidempresa,:xcodigo,:xdescricao,:xreferencia,:xativo,');
           SQL.Add(':xunidade,(case when :xidestrutura>0 then :xidestrutura else null end),:xpontominimo,:xpontopedido,:xpontomaximo,:xpesobruto,:xpesoliquido,');
           SQL.Add(':xqtdembalagem,:xbasecalculoicms,:xpercentualicms,:xpercentualipi,:xclassificacao,');
           SQL.Add(':xprecocusto,:xpreco1,:xpreco2,:xpreco3,:xpreco4,:xpreco5,:xpreco6,:xpreco7,:xpreco8,:xpreco9,:xpreco10,');
           SQL.Add('(case when :xidformula>0 then :xidformula else null end),:xnumserie,:xaplicacao,:xobservacao,:xdatacadastramento,:xqtdestoque,:xqtdencomendado,');
           SQL.Add(':xtotalcusto,:xtotalvenda,:xdataentrada,:xidoperacaoentrada,:xqtdentrada,');
           SQL.Add(':xdatasaida,:xidoperacaosaida,:xqtdsaida,:xtotalentrada,:xtotalsaida,:xtipo,');
           SQL.Add(':xprazovalidade,:xteclaassociada,:xdescricaoreduzida,:xqtdetiqueta,');
           SQL.Add(':xhoraultimaalteracao,:xidaliquota,:xmargemlucro,(case when :xidsetor>0 then :xidsetor else null end),:xincidest,:xfabricante,');
           SQL.Add('(case when :xidfabricante>0 then :xidfabricante else null end),:xidsituacaotributaria,:xbitola,:xmarca,:xcaminhofoto,:xpercentualcomissao,');
           SQL.Add(':xcean,:xsaldoestoque,:xmva,:xicmdestino,(case when :xgrade>0 then :xgrade else null end),');
           SQL.Add(':xpercentualpromocao,:xcaracteristica,:xqtdfracionada,:xehcomposto,:xehcalculado,');
           SQL.Add(':xpercquebra,:xincidepis,:xincidecofins,(case when :xidclassificacaofiscal>0 then :xidclassificacaofiscal else null end),:xpercicmsanterior,');
           SQL.Add(':xtipocadastro,:xbasepisentrada,:xbasecofinsentrada,:xbasepissaida,:xbasecofinssaida,:xcstpisentrada,');
           SQL.Add(':xcstcofinsentrada,:xcstpissaida,:xcstcofinssaida,:xmargemfixa,(case when :xidcodigocontabil>0 then :xidcodigocontabil else null end),');
           SQL.Add(':xpercdesconto,:xqtddesconto,:xfontecaracteristica,:xqtdunidadepum,:xunidadeqtdepum,');
           SQL.Add(':xunidaderefpum,:xenviasite,:xdataenviosite,:xidusuarioenviosite,:xnumerofci,:xtemfoto,:xdctfpis,');
           SQL.Add(':xdctfcofins,:xcodnatureza,:xincidediferimento,(case when :xidfamilia>0 then :xidfamilia else null end),:xdescricaoextendida,:xidaliquotast,');
           SQL.Add(':xpercreducaost,:xcbnef,:xcomprimento,:xaltura,:xprofundidade,:xidcategoria,:xmargemvenda,:xpercfrete) ');

           ParamByName('xidempresa').AsInteger   := wconexao.FIdEmpresaProduto;
           ParamByName('xcodigo').AsString       := XProduto.GetValue('codigo').Value;
           ParamByName('xdescricao').AsString    := XProduto.GetValue('descricao').Value;
           if XProduto.TryGetValue('referencia',wval) then
              ParamByName('xreferencia').AsString  := XProduto.GetValue('referencia').Value
           else
              ParamByName('xreferencia').AsString  := '';
           if XProduto.TryGetValue('ativo',wval) then
              ParamByName('xativo').AsBoolean      := strtobooldef(XProduto.GetValue('ativo').Value,true)
           else
              ParamByName('xativo').AsBoolean      := true;
           if XProduto.TryGetValue('unidade',wval) then
              ParamByName('xunidade').AsString  := XProduto.GetValue('unidade').Value
           else
              ParamByName('xunidade').AsString  := 'Un';
           if XProduto.TryGetValue('idestrutura',wval) then
              ParamByName('xidestrutura').AsInteger  := strtointdef(XProduto.GetValue('idestrutura').Value,0)
           else
              ParamByName('xidestrutura').AsInteger  := 0;
           if XProduto.TryGetValue('pontominimo',wval) then
              ParamByName('xpontominimo').AsFloat  := strtofloatdef(XProduto.GetValue('pontominimo').Value,0)
           else
              ParamByName('xpontominimo').AsFloat  := 0;
           if XProduto.TryGetValue('pontopedido',wval) then
              ParamByName('xpontopedido').AsFloat  := strtofloatdef(XProduto.GetValue('pontopedido').Value,0)
           else
              ParamByName('xpontopedido').AsFloat  := 0;
           if XProduto.TryGetValue('pontomaximo',wval) then
              ParamByName('xpontomaximo').AsFloat  := strtofloatdef(XProduto.GetValue('pontomaximo').Value,0)
           else
              ParamByName('xpontomaximo').AsFloat  := 0;
           if XProduto.TryGetValue('pesobruto',wval) then
              ParamByName('xpesobruto').AsFloat  := strtofloatdef(XProduto.GetValue('pesobruto').Value,0)
           else
              ParamByName('xpesobruto').AsFloat  := 0;
           if XProduto.TryGetValue('pesoliquido',wval) then
              ParamByName('xpesoliquido').AsFloat  := strtofloatdef(XProduto.GetValue('pesoliquido').Value,0)
           else
              ParamByName('xpesoliquido').AsFloat  := 0;
           if XProduto.TryGetValue('qtdembalagem',wval) then
              ParamByName('xqtdembalagem').AsFloat  := strtofloatdef(XProduto.GetValue('qtdembalagem').Value,0)
           else
              ParamByName('xqtdembalagem').AsFloat  := 0;
           if XProduto.TryGetValue('basecalculoicms',wval) then
              ParamByName('xbasecalculoicms').AsFloat  := strtofloatdef(XProduto.GetValue('basecalculoicms').Value,0)
           else
              ParamByName('xbasecalculoicms').AsFloat  := 0;
           if XProduto.TryGetValue('percentualicms',wval) then
              ParamByName('xpercentualicms').AsFloat  := strtofloatdef(XProduto.GetValue('percentualicms').Value,0)
           else
              ParamByName('xpercentualicms').AsFloat  := 0;
           if XProduto.TryGetValue('percentualipi',wval) then
              ParamByName('xpercentualipi').AsFloat  := strtofloatdef(XProduto.GetValue('percentualipi').Value,0)
           else
              ParamByName('xpercentualipi').AsFloat  := 0;
           if XProduto.TryGetValue('classificacao',wval) then
              ParamByName('xclassificacao').AsString  := XProduto.GetValue('classificacao').Value
           else
              ParamByName('xclassificacao').AsString  := '';
           if XProduto.TryGetValue('precocusto',wval) then
              ParamByName('xprecocusto').AsFloat  := strtofloatdef(XProduto.GetValue('precocusto').Value,0)
           else
              ParamByName('xprecocusto').AsFloat  := 0;
           if XProduto.TryGetValue('preco1',wval) then
              ParamByName('xpreco1').AsFloat  := strtofloatdef(XProduto.GetValue('preco1').Value,0)
           else
              ParamByName('xpreco1').AsFloat  := 0;
           if XProduto.TryGetValue('preco2',wval) then
              ParamByName('xpreco2').AsFloat  := strtofloatdef(XProduto.GetValue('preco2').Value,0)
           else
              ParamByName('xpreco2').AsFloat  := 0;
           if XProduto.TryGetValue('preco3',wval) then
              ParamByName('xpreco3').AsFloat  := strtofloatdef(XProduto.GetValue('preco3').Value,0)
           else
              ParamByName('xpreco3').AsFloat  := 0;
           if XProduto.TryGetValue('preco4',wval) then
              ParamByName('xpreco4').AsFloat  := strtofloatdef(XProduto.GetValue('preco4').Value,0)
           else
              ParamByName('xpreco4').AsFloat  := 0;
           if XProduto.TryGetValue('preco5',wval) then
              ParamByName('xpreco5').AsFloat  := strtofloatdef(XProduto.GetValue('preco5').Value,0)
           else
              ParamByName('xpreco5').AsFloat  := 0;
           if XProduto.TryGetValue('preco6',wval) then
              ParamByName('xpreco6').AsFloat  := strtofloatdef(XProduto.GetValue('preco6').Value,0)
           else
              ParamByName('xpreco6').AsFloat  := 0;
           if XProduto.TryGetValue('preco7',wval) then
              ParamByName('xpreco7').AsFloat  := strtofloatdef(XProduto.GetValue('preco7').Value,0)
           else
              ParamByName('xpreco7').AsFloat  := 0;
           if XProduto.TryGetValue('preco8',wval) then
              ParamByName('xpreco8').AsFloat  := strtofloatdef(XProduto.GetValue('preco8').Value,0)
           else
              ParamByName('xpreco8').AsFloat  := 0;
           if XProduto.TryGetValue('preco9',wval) then
              ParamByName('xpreco9').AsFloat  := strtofloatdef(XProduto.GetValue('preco9').Value,0)
           else
              ParamByName('xpreco9').AsFloat  := 0;
           if XProduto.TryGetValue('preco10',wval) then
              ParamByName('xpreco10').AsFloat  := strtofloatdef(XProduto.GetValue('preco10').Value,0)
           else
              ParamByName('xpreco10').AsFloat  := 0;
           if XProduto.TryGetValue('idformula',wval) then
              ParamByName('xidformula').AsInteger  := strtointdef(XProduto.GetValue('idformula').Value,0)
           else
              ParamByName('xidformula').AsInteger  := 0;
           if XProduto.TryGetValue('numserie',wval) then
              ParamByName('xnumserie').AsInteger  := strtointdef(XProduto.GetValue('numserie').Value,0)
           else
              ParamByName('xnumserie').AsInteger  := 0;
           if XProduto.TryGetValue('aplicacao',wval) then
              ParamByName('xaplicacao').AsString  := XProduto.GetValue('aplicacao').Value
           else
              ParamByName('xaplicacao').AsString  := '';
           if XProduto.TryGetValue('observacao',wval) then
              ParamByName('xobservacao').AsString  := XProduto.GetValue('observacao').Value
           else
              ParamByName('xobservacao').AsString  := '';
           if XProduto.TryGetValue('datacadastramento',wval) then
              ParamByName('xdatacadastramento').AsDate  := StrToDateDef(XProduto.GetValue('datacadastramento').Value,date)
           else
              ParamByName('xdatacadastramento').AsDate  := date;
           if XProduto.TryGetValue('qtdestoque',wval) then
              ParamByName('xqtdestoque').AsFloat  := strtofloatdef(XProduto.GetValue('qtdestoque').Value,0)
           else
              ParamByName('xqtdestoque').AsFloat  := 0;
           if XProduto.TryGetValue('qtdencomendado',wval) then
              ParamByName('xqtdencomendado').AsFloat  := strtofloatdef(XProduto.GetValue('qtdencomendado').Value,0)
           else
              ParamByName('xqtdencomendado').AsFloat  := 0;
           if XProduto.TryGetValue('totalcusto',wval) then
              ParamByName('xtotalcusto').AsFloat  := strtofloatdef(XProduto.GetValue('totalcusto').Value,0)
           else
              ParamByName('xtotalcusto').AsFloat  := 0;
           if XProduto.TryGetValue('totalvenda',wval) then
              ParamByName('xtotalvenda').AsFloat  := strtofloatdef(XProduto.GetValue('totalvenda').Value,0)
           else
              ParamByName('xtotalvenda').AsFloat  := 0;
           if XProduto.TryGetValue('dataentrada',wval) then
              ParamByName('xdataentrada').AsDate  := StrToDateDef(XProduto.GetValue('dataentrada').Value,date)
           else
              ParamByName('xdataentrada').AsDate  := date;
           if XProduto.TryGetValue('idoperacaoentrada',wval) then
              ParamByName('xidoperacaoentrada').AsInteger  := strtointdef(XProduto.GetValue('idoperacaoentrada').Value,0)
           else
              ParamByName('xidoperacaoentrada').AsInteger  := 0;
           if XProduto.TryGetValue('qtdentrada',wval) then
              ParamByName('xqtdentrada').AsFloat  := strtofloatdef(XProduto.GetValue('qtdentrada').Value,0)
           else
              ParamByName('xqtdentrada').AsFloat  := 0;
           if XProduto.TryGetValue('datasaida',wval) then
              ParamByName('xdatasaida').AsDate  := StrToDateDef(XProduto.GetValue('datasaida').Value,date)
           else
              ParamByName('xdatasaida').AsDate  := date;
           if XProduto.TryGetValue('idoperacaosaida',wval) then
              ParamByName('xidoperacaosaida').AsInteger  := strtointdef(XProduto.GetValue('idoperacaosaida').Value,0)
           else
              ParamByName('xidoperacaosaida').AsInteger  := 0;
           if XProduto.TryGetValue('qtdsaida',wval) then
              ParamByName('xqtdsaida').AsFloat  := strtofloatdef(XProduto.GetValue('qtdsaida').Value,0)
           else
              ParamByName('xqtdsaida').AsFloat  := 0;
           if XProduto.TryGetValue('totalentrada',wval) then
              ParamByName('xtotalentrada').AsFloat  := strtofloatdef(XProduto.GetValue('totalentrada').Value,0)
           else
              ParamByName('xtotalentrada').AsFloat  := 0;
           if XProduto.TryGetValue('totalsaida',wval) then
              ParamByName('xtotalsaida').AsFloat  := strtofloatdef(XProduto.GetValue('totalsaida').Value,0)
           else
              ParamByName('xtotalsaida').AsFloat  := 0;
           if XProduto.TryGetValue('tipo',wval) then
              ParamByName('xtipo').AsString  := XProduto.GetValue('tipo').Value
           else
              ParamByName('xtipo').AsString  := 'N';
           if XProduto.TryGetValue('prazovalidade',wval) then
              ParamByName('xprazovalidade').AsInteger  := strtointdef(XProduto.GetValue('prazovalidade').Value,0)
           else
              ParamByName('xprazovalidade').AsInteger  := 0;
           if XProduto.TryGetValue('teclaassociada',wval) then
              ParamByName('xteclaassociada').AsString  := XProduto.GetValue('teclaassociada').Value
           else
              ParamByName('xteclaassociada').AsString  := '';
           if XProduto.TryGetValue('descricaoreduzida',wval) then
              ParamByName('xdescricaoreduzida').AsString  := XProduto.GetValue('descricaoreduzida').Value
           else
              ParamByName('xdescricaoreduzida').AsString  := '';
           if XProduto.TryGetValue('qtdetiqueta',wval) then
              ParamByName('xqtdetiqueta').AsInteger  := strtointdef(XProduto.GetValue('qtdetiqueta').Value,0)
           else
              ParamByName('xqtdetiqueta').AsInteger  := 0;
           if XProduto.TryGetValue('horaultimaalteracao',wval) then
              ParamByName('xhoraultimaalteracao').AsString  := XProduto.GetValue('horaultimaalteracao').Value
           else
              ParamByName('xhoraultimaalteracao').AsString  := '';
           if XProduto.TryGetValue('idaliquota',wval) then
              ParamByName('xidaliquota').AsInteger  := strtointdef(XProduto.GetValue('idaliquota').Value,0)
           else
              ParamByName('xidaliquota').AsInteger  := 0;
           if XProduto.TryGetValue('margemlucro',wval) then
              ParamByName('xmargemlucro').AsFloat  := strtofloatdef(XProduto.GetValue('margemlucro').Value,0)
           else
              ParamByName('xmargemlucro').AsFloat  := 0;
           if XProduto.TryGetValue('idsetor',wval) then
              ParamByName('xidsetor').AsInteger  := strtointdef(XProduto.GetValue('idsetor').Value,0)
           else
              ParamByName('xidsetor').AsInteger  := 0;
           if XProduto.TryGetValue('incidest',wval) then
              ParamByName('xincidest').AsBoolean  := strtobooldef(XProduto.GetValue('incidest').Value,false)
           else
              ParamByName('xincidest').AsBoolean  := false;
           if XProduto.TryGetValue('fabricante',wval) then
              ParamByName('xfabricante').AsString  := XProduto.GetValue('fabricante').Value
           else
              ParamByName('xfabricante').AsString  := '';
           if XProduto.TryGetValue('idfabricante',wval) then
              ParamByName('xidfabricante').AsInteger  := strtointdef(XProduto.GetValue('idfabricante').Value,0)
           else
              ParamByName('xidfabricante').AsInteger  := 0;
           if XProduto.TryGetValue('idsituacaotributaria',wval) then
              ParamByName('xidsituacaotributaria').AsInteger  := strtointdef(XProduto.GetValue('idsituacaotributaria').Value,0)
           else
              ParamByName('xidsituacaotributaria').AsInteger  := 0;
           if XProduto.TryGetValue('bitola',wval) then
              ParamByName('xbitola').AsString  := XProduto.GetValue('bitola').Value
           else
              ParamByName('xbitola').AsString  := '';
           if XProduto.TryGetValue('marca',wval) then
              ParamByName('xmarca').AsString  := XProduto.GetValue('marca').Value
           else
              ParamByName('xmarca').AsString  := '';
           if XProduto.TryGetValue('caminhofoto',wval) then
              ParamByName('xcaminhofoto').AsString  := XProduto.GetValue('caminhofoto').Value
           else
              ParamByName('xcaminhofoto').AsString  := '';
           if XProduto.TryGetValue('percentualcomissao',wval) then
              ParamByName('xpercentualcomissao').AsFloat  := strtofloatdef(XProduto.GetValue('percentualcomissao').Value,0)
           else
              ParamByName('xpercentualcomissao').AsFloat  := 0;
           if XProduto.TryGetValue('cean',wval) then
              ParamByName('xcean').AsString  := XProduto.GetValue('cean').Value
           else
              ParamByName('xcean').AsString  := '';
           if XProduto.TryGetValue('saldoestoque',wval) then
              ParamByName('xsaldoestoque').AsFloat  := strtofloatdef(XProduto.GetValue('saldoestoque').Value,0)
           else
              ParamByName('xsaldoestoque').AsFloat  := 0;
           if XProduto.TryGetValue('mva',wval) then
              ParamByName('xmva').AsFloat  := strtofloatdef(XProduto.GetValue('mva').Value,0)
           else
              ParamByName('xmva').AsFloat  := 0;
           if XProduto.TryGetValue('icmdestino',wval) then
              ParamByName('xicmdestino').AsFloat  := strtofloatdef(XProduto.GetValue('icmdestino').Value,0)
           else
              ParamByName('xicmdestino').AsFloat  := 0;
           if XProduto.TryGetValue('grade',wval) then
              ParamByName('xgrade').AsInteger  := strtointdef(XProduto.GetValue('grade').Value,0)
           else
              ParamByName('xgrade').AsInteger  := 0;
           if XProduto.TryGetValue('percentualpromocao',wval) then
              ParamByName('xpercentualpromocao').AsFloat  := strtofloatdef(XProduto.GetValue('percentualpromocao').Value,0)
           else
              ParamByName('xpercentualpromocao').AsFloat  := 0;
           if XProduto.TryGetValue('caracteristica',wval) then
              ParamByName('xcaracteristica').AsString  := XProduto.GetValue('caracteristica').Value
           else
              ParamByName('xcaracteristica').AsString  := '';
           if XProduto.TryGetValue('qtdfracionada',wval) then
              ParamByName('xqtdfracionada').AsBoolean  := strtobooldef(XProduto.GetValue('qtdfracionada').Value,false)
           else
              ParamByName('xqtdfracionada').AsBoolean  := false;
           if XProduto.TryGetValue('ehcomposto',wval) then
              ParamByName('xehcomposto').AsBoolean  := strtobooldef(XProduto.GetValue('ehcomposto').Value,false)
           else
              ParamByName('xehcomposto').AsBoolean  := false;
           if XProduto.TryGetValue('ehcalculado',wval) then
              ParamByName('xehcalculado').AsBoolean  := strtobooldef(XProduto.GetValue('ehcalculado').Value,false)
           else
              ParamByName('xehcalculado').AsBoolean  := false;
           if XProduto.TryGetValue('percquebra',wval) then
              ParamByName('xpercquebra').AsFloat  := strtofloatdef(XProduto.GetValue('percquebra').Value,0)
           else
              ParamByName('xpercquebra').AsFloat  := 0;
           if XProduto.TryGetValue('incidepis',wval) then
              ParamByName('xincidepis').AsBoolean  := strtobooldef(XProduto.GetValue('incidepis').Value,false)
           else
              ParamByName('xincidepis').AsBoolean  := false;
           if XProduto.TryGetValue('incidecofins',wval) then
              ParamByName('xincidecofins').AsBoolean  := strtobooldef(XProduto.GetValue('incidecofins').Value,false)
           else
              ParamByName('xincidecofins').AsBoolean  := false;
           if XProduto.TryGetValue('idclassificacaofiscal',wval) then
              ParamByName('xidclassificacaofiscal').AsInteger  := strtointdef(XProduto.GetValue('idclassificacaofiscal').Value,0)
           else
              ParamByName('xidclassificacaofiscal').AsInteger  := 0;
           if XProduto.TryGetValue('percicmsanterior',wval) then
              ParamByName('xpercicmsanterior').AsFloat  := strtofloatdef(XProduto.GetValue('percicmsanterior').Value,0)
           else
              ParamByName('xpercicmsanterior').AsFloat  := 0;
           if XProduto.TryGetValue('tipocadastro',wval) then
              ParamByName('xtipocadastro').AsString  := XProduto.GetValue('tipocadastro').Value
           else
              ParamByName('xtipocadastro').AsString  := '';
           if XProduto.TryGetValue('basepisentrada',wval) then
              ParamByName('xbasepisentrada').AsFloat  := strtofloatdef(XProduto.GetValue('basepisentrada').Value,0)
           else
              ParamByName('xbasepisentrada').AsFloat  := 0;
           if XProduto.TryGetValue('basecofinsentrada',wval) then
              ParamByName('xbasecofinsentrada').AsFloat  := strtofloatdef(XProduto.GetValue('basecofinsentrada').Value,0)
           else
              ParamByName('xbasecofinsentrada').AsFloat  := 0;
           if XProduto.TryGetValue('basepissaida',wval) then
              ParamByName('xbasepissaida').AsFloat  := strtofloatdef(XProduto.GetValue('basepissaida').Value,0)
           else
              ParamByName('xbasepissaida').AsFloat  := 0;
           if XProduto.TryGetValue('basecofinssaida',wval) then
              ParamByName('xbasecofinssaida').AsFloat  := strtofloatdef(XProduto.GetValue('basecofinssaida').Value,0)
           else
              ParamByName('xbasecofinssaida').AsFloat  := 0;
           if XProduto.TryGetValue('cstpisentrada',wval) then
              ParamByName('xcstpisentrada').AsString  := XProduto.GetValue('cstpisentrada').Value
           else
              ParamByName('xcstpisentrada').AsString  := '';
           if XProduto.TryGetValue('cstcofinsentrada',wval) then
              ParamByName('xcstcofinsentrada').AsString  := XProduto.GetValue('cstcofinsentrada').Value
           else
              ParamByName('xcstcofinsentrada').AsString  := '';
           if XProduto.TryGetValue('cstpissaida',wval) then
              ParamByName('xcstpissaida').AsString  := XProduto.GetValue('cstpissaida').Value
           else
              ParamByName('xcstpissaida').AsString  := '';
           if XProduto.TryGetValue('cstcofinssaida',wval) then
              ParamByName('xcstcofinssaida').AsString  := XProduto.GetValue('cstcofinssaida').Value
           else
              ParamByName('xcstcofinssaida').AsString  := '';
           if XProduto.TryGetValue('margemfixa',wval) then
              ParamByName('xmargemfixa').AsFloat  := strtofloatdef(XProduto.GetValue('margemfixa').Value,0)
           else
              ParamByName('xmargemfixa').AsFloat  := 0;
           if XProduto.TryGetValue('idcodigocontabil',wval) then
              ParamByName('xidcodigocontabil').AsInteger  := strtointdef(XProduto.GetValue('idcodigocontabil').Value,0)
           else
              ParamByName('xidcodigocontabil').AsInteger  := 0;
           if XProduto.TryGetValue('percdesconto',wval) then
              ParamByName('xpercdesconto').AsFloat  := strtofloatdef(XProduto.GetValue('percdesconto').Value,0)
           else
              ParamByName('xpercdesconto').AsFloat  := 0;
           if XProduto.TryGetValue('qtddesconto',wval) then
              ParamByName('xqtddesconto').AsFloat  := strtofloatdef(XProduto.GetValue('qtddesconto').Value,0)
           else
              ParamByName('xqtddesconto').AsFloat  := 0;
           if XProduto.TryGetValue('fontecaracteristica',wval) then
              ParamByName('xfontecaracteristica').AsString  := XProduto.GetValue('fontecaracteristica').Value
           else
              ParamByName('xfontecaracteristica').AsString  := '';
           if XProduto.TryGetValue('qtdunidadepum',wval) then
              ParamByName('xqtdunidadepum').AsFloat  := strtofloatdef(XProduto.GetValue('qtdunidadepum').Value,0)
           else
              ParamByName('xqtdunidadepum').AsFloat  := 0;
           if XProduto.TryGetValue('unidadeqtdepum',wval) then
              ParamByName('xunidadeqtdepum').AsString  := XProduto.GetValue('unidadeqtdepum').Value
           else
              ParamByName('xunidadeqtdepum').AsString  := '';
           if XProduto.TryGetValue('unidaderefpum',wval) then
              ParamByName('xunidaderefpum').AsString  := XProduto.GetValue('unidaderefpum').Value
           else
              ParamByName('xunidaderefpum').AsString  := '';
           if XProduto.TryGetValue('enviasite',wval) then
              ParamByName('xenviasite').AsBoolean  := strtobooldef(XProduto.GetValue('enviasite').Value,false)
           else
              ParamByName('xenviasite').AsBoolean  := false;
           if XProduto.TryGetValue('dataenviosite',wval) then
              ParamByName('xdataenviosite').AsDate  := strtodatedef(XProduto.GetValue('dataenviosite').Value,0)
           else
              ParamByName('xdataenviosite').AsDate  := 0;
           if XProduto.TryGetValue('idusuarioenviosite',wval) then
              ParamByName('xidusuarioenviosite').AsInteger  := strtointdef(XProduto.GetValue('idusuarioenviosite').Value,0)
           else
              ParamByName('xidusuarioenviosite').AsInteger  := 0;
           if XProduto.TryGetValue('numerofci',wval) then
              ParamByName('xnumerofci').AsString  := XProduto.GetValue('numerofci').Value
           else
              ParamByName('xnumerofci').AsString  := '';
           if XProduto.TryGetValue('temfoto',wval) then
              ParamByName('xtemfoto').AsBoolean  := strtobooldef(XProduto.GetValue('temfoto').Value,false)
           else
              ParamByName('xtemfoto').AsBoolean  := false;
           if XProduto.TryGetValue('dctfpis',wval) then
              ParamByName('xdctfpis').AsString  := XProduto.GetValue('dctfpis').Value
           else
              ParamByName('xdctfpis').AsString  := '';
           if XProduto.TryGetValue('dctfcofins',wval) then
              ParamByName('xdctfcofins').AsString  := XProduto.GetValue('dctfcofins').Value
           else
              ParamByName('xdctfcofins').AsString  := '';
           if XProduto.TryGetValue('codnatureza',wval) then
              ParamByName('xcodnatureza').AsString  := XProduto.GetValue('codnatureza').Value
           else
              ParamByName('xcodnatureza').AsString  := '';
           if XProduto.TryGetValue('incidediferimento',wval) then
              ParamByName('xincidediferimento').AsBoolean  := strtobooldef(XProduto.GetValue('incidediferimento').Value,false)
           else
              ParamByName('xincidediferimento').AsBoolean  := false;
           if XProduto.TryGetValue('idfamilia',wval) then
              ParamByName('xidfamilia').AsInteger  := strtointdef(XProduto.GetValue('idfamilia').Value,0)
           else
              ParamByName('xidfamilia').AsInteger  := 0;
           if XProduto.TryGetValue('descricaoextendida',wval) then
              ParamByName('xdescricaoextendida').AsString  := XProduto.GetValue('descricaoextendida').Value
           else
              ParamByName('xdescricaoextendida').AsString  := '';
           if XProduto.TryGetValue('idaliquotast',wval) then
              ParamByName('xidaliquotast').AsInteger  := strtointdef(XProduto.GetValue('idaliquotast').Value,0)
           else
              ParamByName('xidaliquotast').AsInteger  := 0;
           if XProduto.TryGetValue('percreducaost',wval) then
              ParamByName('xpercreducaost').AsFloat  := strtofloatdef(XProduto.GetValue('percreducaost').Value,0)
           else
              ParamByName('xpercreducaost').AsFloat  := 0;
           if XProduto.TryGetValue('cbnef',wval) then
              ParamByName('xcbnef').AsString  := XProduto.GetValue('cbnef').Value
           else
              ParamByName('xcbnef').AsString  := '';
           if XProduto.TryGetValue('comprimento',wval) then
              ParamByName('xcomprimento').AsFloat  := strtofloatdef(XProduto.GetValue('comprimento').Value,0)
           else
              ParamByName('xcomprimento').AsFloat  := 0;
           if XProduto.TryGetValue('altura',wval) then
              ParamByName('xaltura').AsFloat  := strtofloatdef(XProduto.GetValue('altura').Value,0)
           else
              ParamByName('xaltura').AsFloat  := 0;
           if XProduto.TryGetValue('profundidade',wval) then
              ParamByName('xprofundidade').AsFloat  := strtofloatdef(XProduto.GetValue('profundidade').Value,0)
           else
              ParamByName('xprofundidade').AsFloat  := 0;
           if XProduto.TryGetValue('idcategoria',wval) then
              ParamByName('xidcategoria').AsInteger  := strtointdef(XProduto.GetValue('idcategoria').Value,0)
           else
              ParamByName('xidcategoria').AsInteger  := 0;
           if XProduto.TryGetValue('margemvenda',wval) then
              ParamByName('xmargemvenda').AsFloat  := strtofloatdef(XProduto.GetValue('margemvenda').Value,0)
           else
              ParamByName('xmargemvenda').AsFloat  := 0;
           if XProduto.TryGetValue('percfrete',wval) then
              ParamByName('xpercfrete').AsFloat  := strtofloatdef(XProduto.GetValue('percfrete').Value,0)
           else
              ParamByName('xpercfrete').AsFloat  := 0;
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
                SQL.Add('select "CodigoInternoProduto" as id,');
                SQL.Add('       "CodigoProduto"        as codigo,');
                SQL.Add('       "DescricaoProduto"     as descricao, ');
                SQL.Add('       "ReferenciaProduto"    as referencia, ');
                SQL.Add('       "AtivoProduto"         as ativo, ');
                SQL.Add('       "UnidadeProduto"       as unidade, ');
                SQL.Add('       "CodigoEstruturalProduto" as idestrutura, ');
                SQL.Add('       "MinimoProduto"        as pontominimo, ');
                SQL.Add('       "PedidoProduto"        as pontopedido, ');
                SQL.Add('       "MaximoProduto"        as pontomaximo, ');
                SQL.Add('       "PesoBrutoProduto"     as pesobruto, ');
                SQL.Add('       "PesoLiquidoProduto"   as pesoliquido, ');
                SQL.Add('       "QuantidadeEmbalagemProduto" as qtdembalagem, ');
                SQL.Add('       "BaseCalculoProduto"         as basecalculoicms, ');
                SQL.Add('       "PercentualICMSProduto"      as percentualicms, ');
                SQL.Add('       "PercentualIPIProduto"       as percentualipi, ');
                SQL.Add('       "ClassificacaoProduto"       as classificacao, ');
                SQL.Add('       "CustoProduto"               as precocusto, ');
                SQL.Add('       "Venda1Produto"              as preco1, ');
                SQL.Add('       "Venda2Produto"              as preco2, ');
                SQL.Add('       "Venda3Produto"              as preco3, ');
                SQL.Add('       "Venda4Produto"              as preco4, ');
                SQL.Add('       "Venda5Produto"              as preco5, ');
                SQL.Add('       "Venda6Produto"              as preco6, ');
                SQL.Add('       "Venda7Produto"              as preco7, ');
                SQL.Add('       "Venda8Produto"              as preco8, ');
                SQL.Add('       "Venda9Produto"              as preco9, ');
                SQL.Add('       "Venda10Produto"             as preco10, ');
                SQL.Add('       "FormulaCalculoProduto"      as idformula, ');
                SQL.Add('       "NumeroSerieProduto"         as numserie, ');
                SQL.Add('       "AplicacaoProduto"           as aplicacao, ');
                SQL.Add('       "ObservacaoProduto"          as observacao, ');
                SQL.Add('       "DataCadastramentoProduto"   as datacadastramento, ');
                SQL.Add('       "EstoqueProduto"             as qtdestoque, ');
                SQL.Add('       "EncomendadoProduto"         as qtdencomendado, ');
                SQL.Add('       "TotalCustoProduto"          as totalcusto, ');
                SQL.Add('       "TotalVendaProduto"          as totalvenda, ');
                SQL.Add('       "DataEntradaProduto"         as dataentrada, ');
                SQL.Add('       "OperacaoEntradaProduto"     as idoperacaoentrada, ');
                SQL.Add('       "QuantidadeEntradaProduto"   as qtdentrada, ');
                SQL.Add('       "DataSaidaProduto"           as datasaida, ');
                SQL.Add('       "OperacaoSaidaProduto"       as idoperacaosaida, ');
                SQL.Add('       "QuantidadeSaidaProduto"     as qtdsaida, ');
                SQL.Add('       "TotalEntradaProduto"        as totalentrada, ');
                SQL.Add('       "TotalSaidaProduto"          as totalsaida, ');
                SQL.Add('       "TipoProduto"                    as tipo, ');
                SQL.Add('       "PrazoValidadeProduto"            as prazovalidade, ');
                SQL.Add('       "TeclaAssociadaProduto"           as teclaassociada, ');
                SQL.Add('       "DescricaoReduzidaProduto"        as descricaoreduzida, ');
                SQL.Add('       "QtdeEtiquetaProduto"             as qtdetiqueta, ');
                SQL.Add('       "HoraUltimaAlteracaoProduto"      as horaultimaalteracao, ');
                SQL.Add('       "CodigoAliquotaProduto"           as idaliquota, ');
                SQL.Add('       "MargemLucroProduto"              as margemlucro, ');
                SQL.Add('       "CodigoSetorProduto"              as idsetor, ');
                SQL.Add('       "IncideSubstituicaoProduto"       as incidest, ');
                SQL.Add('       "FabricanteProduto"               as fabricante, ');
                SQL.Add('       "CodigoFabricanteProduto"         as idfabricante, ');
                SQL.Add('       "SituacaoTributariaProduto"       as idsituacaotributaria, ');
                SQL.Add('       "BitolaProduto"                   as bitola, ');
                SQL.Add('       "MarcaProduto"                    as marca, ');
                SQL.Add('       "CaminhoFotoProduto"              as caminhofoto, ');
                SQL.Add('       "PercentualComissaoProduto"       as percentualcomissao, ');
                SQL.Add('       "CodigoBarraProduto"              as cean,');
                SQL.Add('       "SaldoEstoqueProduto"             as saldoestoque,');
                SQL.Add('       "PercentualValorAgregadoProduto"  as mva,');
                SQL.Add('       "PercentualICMSDestinoProduto"    as icmdestino,');
                SQL.Add('       coalesce("CodigoGradeProduto",0)  as grade, ');
                SQL.Add('       "PercentualPromocionalProduto"    as percentualpromocao,');
                SQL.Add('       "CaracteristicaProduto"           as caracteristica,');
                SQL.Add('       "QuantidadeFracionadaProduto"     as qtdfracionada,');
                SQL.Add('       "EhCompostoProduto"               as ehcomposto,');
                SQL.Add('       "EhCalculadoProduto"              as ehcalculado,');
                SQL.Add('       "PercentualQuebraProduto"         as percquebra,');
                SQL.Add('       "IncidePISProduto"                as incidepis,');
                SQL.Add('       "IncideCOFINSProduto"             as incidecofins,');
                SQL.Add('       "ClassificacaoFiscalProduto"      as idclassificacaofiscal,');
                SQL.Add('       "PercentualICMSAnteriorProduto"   as percicmsanterior,');
                SQL.Add('       "TipoCadastroProduto"             as tipocadastro,');
                SQL.Add('       "BasePISEntradaProduto"           as basepisentrada,');
                SQL.Add('       "BaseCOFINSEntradaProduto"        as basecofinsentrada,');
                SQL.Add('       "BasePISSaidaProduto"             as basepissaida,');
                SQL.Add('       "BaseCOFINSSaidaProduto"          as basecofinssaida,');
                SQL.Add('       "CSTPISEntradaProduto"            as cstpisentrada,');
                SQL.Add('       "CSTCOFINSEntradaProduto"         as cstcofinsentrada,');
                SQL.Add('       "CSTPISSaidaProduto"              as cstpissaida,');
                SQL.Add('       "CSTCOFINSSaidaProduto"           as cstcofinssaida,');
                SQL.Add('       cast((select "PercentualPISConfigura" from "ConfiguracaoTSCompras" where "CodigoEmpresaConfigura"=:xidempresa) as numeric) as xpercpis,');
                SQL.Add('       cast((select "PercentualCofinsConfigura" from "ConfiguracaoTSCompras" where "CodigoEmpresaConfigura"=:xidempresa) as numeric) as xperccofins,');
                SQL.Add('       "PercentualMargemFixaProduto"     as margemfixa,');
                SQL.Add('       "CodigoContabilProduto"           as idcodigocontabil,');
                SQL.Add('       "PercentualDescontoProduto"       as percdesconto,');
                SQL.Add('       "QuantidadeDescontoProduto"       as qtddesconto,');
                SQL.Add('       "FonteCaracteristicaProduto"      as fontecaracteristica,');
                SQL.Add('       "QuantidadeUnidadePUMProduto"     as qtdunidadepum,');
                SQL.Add('       "UnidadeQuantidadePUMProduto"     as unidadeqtdepum,');
                SQL.Add('       "UnidadeReferencialPUMProduto"    as unidaderefpum,');
                SQL.Add('       "EnviaSiteProduto"                as enviasite,');
                SQL.Add('       "DataEnvioSiteProduto"            as dataenviosite,');
                SQL.Add('       "UsuarioEnvioSiteProduto"         as idusuarioenviosite,');
                SQL.Add('       "NumeroFCIProduto"                as numerofci,');
                SQL.Add('       "TemFotoProduto"                  as temfoto,');
                SQL.Add('       "DCTFPisProduto"                  as dctfpis,');
                SQL.Add('       "DCTFCofinsProduto"               as dctfcofins,');
                SQL.Add('       "CodigoNaturezaProduto"           as codnatureza,');
                SQL.Add('       "IncideDiferimentoProduto"        as incidediferimento,');
                SQL.Add('       "CodigoFamiliaProduto"            as idfamilia,');
                SQL.Add('       "DescricaoExtendidaProduto"       as descricaoextendida,');
                SQL.Add('       "AliquotaSTProduto"               as idaliquotast,');
                SQL.Add('       "PercentualReducaoSTProduto"      as percreducaost,');
                SQL.Add('       "CodigoBeneficioFiscalProduto"    as cbnef,');
                SQL.Add('       "ComprimentoProduto"              as comprimento,');
                SQL.Add('       "AlturaProduto"                   as altura,');
                SQL.Add('       "ProfundidadeProduto"             as profundidade,');
                SQL.Add('       "CodigoCategoriaProduto"          as idcategoria,');
                SQL.Add('       "PercentualMargemVendaProduto"    as margemvenda,');
                SQL.Add('       "PercentualFreteProduto"          as percfrete,');
                SQL.Add('       cast('''' as text)  as foto ');
                SQL.Add('from "Produto" where "CodigoEmpresaProduto"=:xempresa and "DescricaoProduto"=:xdescricao ');
                ParamByName('xempresa').AsInteger  := wconexao.FIdEmpresaProduto;
                ParamByName('xdescricao').AsString := XProduto.GetValue('descricao').Value;
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Produto incluído');
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

function VerificaRequisicao(XProduto: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XProduto.TryGetValue('codigo',wval) then
       wret := false;
    if not XProduto.TryGetValue('descricao',wval) then
       wret := false;
    if not XProduto.TryGetValue('preco1',wval) then
       wret := false;
    if not XProduto.TryGetValue('idaliquota',wval) then
       wret := false;
    if not XProduto.TryGetValue('idsituacaotributaria',wval) then
       wret := false;
  finally
  end;
  Result := wret;
end;


function AlteraProduto(XIdProduto: integer; XProduto: TJSONObject): TJSONObject;
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
    if XProduto.TryGetValue('codigo',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoProduto"=:xcodigo'
         else
            wcampos := wcampos+',"CodigoProduto"=:xcodigo';
       end;
    if XProduto.TryGetValue('descricao',wval) then
       begin
         if wcampos='' then
            wcampos := '"DescricaoProduto"=:xdescricao'
         else
            wcampos := wcampos+',"DescricaoProduto"=:xdescricao';
       end;
    if XProduto.TryGetValue('referencia',wval) then
       begin
         if wcampos='' then
            wcampos := '"ReferenciaProduto"=:xreferencia'
         else
            wcampos := wcampos+',"ReferenciaProduto"=:xreferencia';
       end;
    if XProduto.TryGetValue('ativo',wval) then
       begin
         if wcampos='' then
            wcampos := '"AtivoProduto"=:xativo'
         else
            wcampos := wcampos+',"AtivoProduto"=:xativo';
       end;
    if XProduto.TryGetValue('unidade',wval) then
       begin
         if wcampos='' then
            wcampos := '"UnidadeProduto"=:xunidade'
         else
            wcampos := wcampos+',"UnidadeProduto"=:xunidade';
       end;
    if XProduto.TryGetValue('idestrutura',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoEstruturalProduto"=:xidestrutura'
         else
            wcampos := wcampos+',"CodigoEstruturalProduto"=:xidestrutura';
       end;
    if XProduto.TryGetValue('pontominimo',wval) then
       begin
         if wcampos='' then
            wcampos := '"MinimoProduto"=:xpontominimo'
         else
            wcampos := wcampos+',"MinimoProduto"=:xpontominimo';
       end;
    if XProduto.TryGetValue('pontopedido',wval) then
       begin
         if wcampos='' then
            wcampos := '"PedidoProduto"=:xpontopedido'
         else
            wcampos := wcampos+',"PedidoProduto"=:xpontopedido';
       end;
    if XProduto.TryGetValue('pontomaximo',wval) then
       begin
         if wcampos='' then
            wcampos := '"MaximoProduto"=:xpontomaximo'
         else
            wcampos := wcampos+',"MaximoProduto"=:xpontomaximo';
       end;
    if XProduto.TryGetValue('pesobruto',wval) then
       begin
         if wcampos='' then
            wcampos := '"PesoBrutoProduto"=:xpesobruto'
         else
            wcampos := wcampos+',"PesoBrutoProduto"=:xpesobruto';
       end;
    if XProduto.TryGetValue('pesoliquido',wval) then
       begin
         if wcampos='' then
            wcampos := '"PesoLiquidoProduto"=:xpesoliquido'
         else
            wcampos := wcampos+',"PesoLiquidoProduto"=:xpesoliquido';
       end;
    if XProduto.TryGetValue('qtdembalagem',wval) then
       begin
         if wcampos='' then
            wcampos := '"QuantidadeEmbalagemProduto"=:xqtdembalagem'
         else
            wcampos := wcampos+',"QuantidadeEmbalagemProduto"=:xqtdembalagem';
       end;
    if XProduto.TryGetValue('basecalculoicms',wval) then
       begin
         if wcampos='' then
            wcampos := '"BaseCalculoProduto"=:xbasecalculoicms'
         else
            wcampos := wcampos+',"BaseCalculoProduto"=:xbasecalculoicms';
       end;
    if XProduto.TryGetValue('percentualicms',wval) then
       begin
         if wcampos='' then
            wcampos := '"PercentualICMSProduto"=:xpercentualicms'
         else
            wcampos := wcampos+',"PercentualICMSProduto"=:xpercentualicms';
       end;
    if XProduto.TryGetValue('percentualipi',wval) then
       begin
         if wcampos='' then
            wcampos := '"PercentualIPIProduto"=:xpercentualipi'
         else
            wcampos := wcampos+',"PercentualIPIProduto"=:xpercentualipi';
       end;
    if XProduto.TryGetValue('classificacao',wval) then
       begin
         if wcampos='' then
            wcampos := '"ClassificacaoProduto"=:xclassificacao'
         else
            wcampos := wcampos+',"ClassificacaoProduto"=:xclassificacao';
       end;
    if XProduto.TryGetValue('precocusto',wval) then
       begin
         if wcampos='' then
            wcampos := '"CustoProduto"=:xprecocusto'
         else
            wcampos := wcampos+',"CustoProduto"=:xprecocusto';
       end;
    if XProduto.TryGetValue('preco1',wval) then
       begin
         if wcampos='' then
            wcampos := '"Venda1Produto"=:xpreco1'
         else
            wcampos := wcampos+',"Venda1Produto"=:xpreco1';
       end;
    if XProduto.TryGetValue('preco2',wval) then
       begin
         if wcampos='' then
            wcampos := '"Venda2Produto"=:xpreco2'
         else
            wcampos := wcampos+',"Venda2Produto"=:xpreco2';
       end;
    if XProduto.TryGetValue('preco3',wval) then
       begin
         if wcampos='' then
            wcampos := '"Venda3Produto"=:xpreco3'
         else
            wcampos := wcampos+',"Venda3Produto"=:xpreco3';
       end;
    if XProduto.TryGetValue('preco4',wval) then
       begin
         if wcampos='' then
            wcampos := '"Venda4Produto"=:xpreco4'
         else
            wcampos := wcampos+',"Venda4Produto"=:xpreco4';
       end;
    if XProduto.TryGetValue('preco5',wval) then
       begin
         if wcampos='' then
            wcampos := '"Venda5Produto"=:xpreco5'
         else
            wcampos := wcampos+',"Venda5Produto"=:xpreco5';
       end;
    if XProduto.TryGetValue('preco6',wval) then
       begin
         if wcampos='' then
            wcampos := '"Venda6Produto"=:xpreco6'
         else
            wcampos := wcampos+',"Venda6Produto"=:xpreco6';
       end;
    if XProduto.TryGetValue('preco7',wval) then
       begin
         if wcampos='' then
            wcampos := '"Venda7Produto"=:xpreco7'
         else
            wcampos := wcampos+',"Venda7Produto"=:xpreco7';
       end;
    if XProduto.TryGetValue('preco8',wval) then
       begin
         if wcampos='' then
            wcampos := '"Venda8Produto"=:xpreco8'
         else
            wcampos := wcampos+',"Venda8Produto"=:xpreco8';
       end;
    if XProduto.TryGetValue('preco9',wval) then
       begin
         if wcampos='' then
            wcampos := '"Venda9Produto"=:xpreco9'
         else
            wcampos := wcampos+',"Venda9Produto"=:xpreco9';
       end;
    if XProduto.TryGetValue('preco10',wval) then
       begin
         if wcampos='' then
            wcampos := '"Venda10Produto"=:xpreco10'
         else
            wcampos := wcampos+',"Venda10Produto"=:xpreco10';
       end;
    if XProduto.TryGetValue('idformula',wval) then
       begin
         if wcampos='' then
            wcampos := '"FormulaCalculoProduto"=:xidformula'
         else
            wcampos := wcampos+',"FormulaCalculoProduto"=:xidformula';
       end;
    if XProduto.TryGetValue('numserie',wval) then
       begin
         if wcampos='' then
            wcampos := '"NumeroSerieProduto"=:xnumserie'
         else
            wcampos := wcampos+',"NumeroSerieProduto"=:xnumserie';
       end;
    if XProduto.TryGetValue('aplicacao',wval) then
       begin
         if wcampos='' then
            wcampos := '"Venda10Produto"=:xpreco10'
         else
            wcampos := wcampos+',"Venda10Produto"=:xpreco10';
       end;
    if XProduto.TryGetValue('observacao',wval) then
       begin
         if wcampos='' then
            wcampos := '"ObservacaoProduto"=:xobservacao'
         else
            wcampos := wcampos+',"ObservacaoProduto"=:xobservacao';
       end;
    if XProduto.TryGetValue('datacadastramento',wval) then
       begin
         if wcampos='' then
            wcampos := '"DataCadastramentoProduto"=:xdatacadastramento'
         else
            wcampos := wcampos+',"DataCadastramentoProduto"=:xdatacadastramento';
       end;
    if XProduto.TryGetValue('qtdestoque',wval) then
       begin
         if wcampos='' then
            wcampos := '"EstoqueProduto"=:xqtdestoque'
         else
            wcampos := wcampos+',"EstoqueProduto"=:xqtdestoque';
       end;
    if XProduto.TryGetValue('qtdencomendado',wval) then
       begin
         if wcampos='' then
            wcampos := '"EncomendadoProduto"=:xqtdencomentado'
         else
            wcampos := wcampos+',"EncomendadoProduto"=:xqtdencomendado';
       end;
    if XProduto.TryGetValue('totalcusto',wval) then
       begin
         if wcampos='' then
            wcampos := '"TotalCustoProduto"=:xtotalcusto'
         else
            wcampos := wcampos+',"TotalCustoProduto"=:xtotalcusto';
       end;
    if XProduto.TryGetValue('totalvenda',wval) then
       begin
         if wcampos='' then
            wcampos := '"TotalVendaProduto"=:xtotalvenda'
         else
            wcampos := wcampos+',"TotalVendaProduto"=:xtotalvenda';
       end;
    if XProduto.TryGetValue('dataentrada',wval) then
       begin
         if wcampos='' then
            wcampos := '"DataEntradaProduto"=:xdataentrada'
         else
            wcampos := wcampos+',"DataEntradaProduto"=:xdataentrada';
       end;
    if XProduto.TryGetValue('idoperacaoentrada',wval) then
       begin
         if wcampos='' then
            wcampos := '"OperacaoEntradaProduto"=:xidoperacaoentrada'
         else
            wcampos := wcampos+',"OperacaoEntradaProduto"=:xidoperacaoentrada';
       end;
    if XProduto.TryGetValue('qtdentrada',wval) then
       begin
         if wcampos='' then
            wcampos := '"QuantidadeEntradaProduto"=:xqtdentrada'
         else
            wcampos := wcampos+',"QuantidadeEntradaProduto"=:xqtdentrada';
       end;
    if XProduto.TryGetValue('datasaida',wval) then
       begin
         if wcampos='' then
            wcampos := '"DataSaidaProduto"=:xdatasaida'
         else
            wcampos := wcampos+',"DataSaidaProduto"=:xdatasaida';
       end;
    if XProduto.TryGetValue('idoperacaosaida',wval) then
       begin
         if wcampos='' then
            wcampos := '"OperacaoSaidaProduto"=:xidoperacaosaida'
         else
            wcampos := wcampos+',"OperacaoSaidaProduto"=:xidoperacaosaida';
       end;
    if XProduto.TryGetValue('qtdsaida',wval) then
       begin
         if wcampos='' then
            wcampos := '"QuantidadeSaidaProduto"=:xqtdsaida'
         else
            wcampos := wcampos+',"QuantidadeSaidaProduto"=:xqtdsaida';
       end;
    if XProduto.TryGetValue('totalentrada',wval) then
       begin
         if wcampos='' then
            wcampos := '"TotalEntradaProduto"=:xtotalentrada'
         else
            wcampos := wcampos+',"TotalEntradaProduto"=:xtotalentrada';
       end;
    if XProduto.TryGetValue('totalsaida',wval) then
       begin
         if wcampos='' then
            wcampos := '"TotalSaidaProduto"=:xtotalsaida'
         else
            wcampos := wcampos+',"TotalSaidaProduto"=:xtotalsaida';
       end;
    if XProduto.TryGetValue('tipo',wval) then
       begin
         if wcampos='' then
            wcampos := '"TipoProduto"=:xtipo'
         else
            wcampos := wcampos+',"TipoProduto"=:xtipo';
       end;
    if XProduto.TryGetValue('prazovalidade',wval) then
       begin
         if wcampos='' then
            wcampos := '"PrazoValidadeProduto"=:xprazovalidade'
         else
            wcampos := wcampos+',"PrazoValidadeProduto"=:xprazovalidade';
       end;
    if XProduto.TryGetValue('teclaassociada',wval) then
       begin
         if wcampos='' then
            wcampos := '"TeclaAssociadaProduto"=:xteclassociada'
         else
            wcampos := wcampos+',"TeclaAssociadaProduto"=:xteclaassociada';
       end;
    if XProduto.TryGetValue('descricaoreduzida',wval) then
       begin
         if wcampos='' then
            wcampos := '"DescricaoReduzidaProduto"=:xdescricaoreduzida'
         else
            wcampos := wcampos+',"DescricaoReduzidaProduto"=:xdescricaoreduzida';
       end;
    if XProduto.TryGetValue('qtdetiqueta',wval) then
       begin
         if wcampos='' then
            wcampos := '"QtdeEtiquetaProduto"=:xqtdetiqueta'
         else
            wcampos := wcampos+',"QtdeEtiquetaProduto"=:xqtdetiqueta';
       end;
    if XProduto.TryGetValue('horaultimaalteracao',wval) then
       begin
         if wcampos='' then
            wcampos := '"HoraUltimaAlteracaoProduto"=:xhoraultimaalteracao'
         else
            wcampos := wcampos+',"HoraUltimaAlteracaoProduto"=:xhoraultimaalteracao';
       end;
    if XProduto.TryGetValue('idaliquota',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoAliquotaProduto"=:xidaliquota'
         else
            wcampos := wcampos+',"CodigoAliquotaProduto"=:xidaliquota';
       end;
    if XProduto.TryGetValue('margemlucro',wval) then
       begin
         if wcampos='' then
            wcampos := '"MargemLucroProduto"=:xmargemlucro'
         else
            wcampos := wcampos+',"MargemLucroProduto"=:xmargemlucro';
       end;
    if XProduto.TryGetValue('idsetor',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoSetorProduto"=:xidsetor'
         else
            wcampos := wcampos+',"CodigoSetorProduto"=:xidsetor';
       end;
    if XProduto.TryGetValue('incidest',wval) then
       begin
         if wcampos='' then
            wcampos := '"IncideSubstituicaoProduto"=:xincidest'
         else
            wcampos := wcampos+',"IncideSubstituicaoProduto"=:xincidest';
       end;
    if XProduto.TryGetValue('fabricante',wval) then
       begin
         if wcampos='' then
            wcampos := '"FabricanteProduto"=:xfabricante'
         else
            wcampos := wcampos+',"FabricanteProduto"=:xfabricante';
       end;
    if XProduto.TryGetValue('idfabricante',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoFabricanteProduto"=:xidfabricante'
         else
            wcampos := wcampos+',"CodigoFabricanteProduto"=:xidfabricante';
       end;
    if XProduto.TryGetValue('idsituacaotributaria',wval) then
       begin
         if wcampos='' then
            wcampos := '"SituacaoTributariaProduto"=:xidsituacaotributaria'
         else
            wcampos := wcampos+',"SituacaoTributariaProduto"=:xidsituacaotributaria';
       end;
    if XProduto.TryGetValue('bitola',wval) then
       begin
         if wcampos='' then
            wcampos := '"BitolaProduto"=:xbitola'
         else
            wcampos := wcampos+',"BitolaProduto"=:xbitola';
       end;
    if XProduto.TryGetValue('marca',wval) then
       begin
         if wcampos='' then
            wcampos := '"MarcaProduto"=:xmarca'
         else
            wcampos := wcampos+',"MarcaProduto"=:xmarca';
       end;
    if XProduto.TryGetValue('caminhofoto',wval) then
       begin
         if wcampos='' then
            wcampos := '"CaminhoFotoProduto"=:xcaminhofoto'
         else
            wcampos := wcampos+',"CaminhoFotoProduto"=:xcaminhofoto';
       end;
    if XProduto.TryGetValue('percentualcomissao',wval) then
       begin
         if wcampos='' then
            wcampos := '"PercentualComissaoProduto"=:xpercentualcomissao'
         else
            wcampos := wcampos+',"PercentualComissaoProduto"=:xpercentualcomissao';
       end;
    if XProduto.TryGetValue('cean',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoBarraProduto"=:xcean'
         else
            wcampos := wcampos+',"CodigoBarraProduto"=:xcean';
       end;
     if XProduto.TryGetValue('saldoestoque',wval) then
       begin
         if wcampos='' then
            wcampos := '"SaldoEstoqueProduto"=:xsaldoestoque'
         else
            wcampos := wcampos+',"SaldoEstoqueProduto"=:xsaldoestoque';
       end;
    if XProduto.TryGetValue('mva',wval) then
       begin
         if wcampos='' then
            wcampos := '"PercentualValorAgregadoProduto"=:xmva'
         else
            wcampos := wcampos+',"PercentualValorAgregadoProduto"=:xmva';
       end;
    if XProduto.TryGetValue('icmdestino',wval) then
       begin
         if wcampos='' then
            wcampos := '"PercentualICMSDestinoProduto"=:xicmsdestino'
         else
            wcampos := wcampos+',"PercentualICMSDestinoProduto"=:xicmsdestino';
       end;
    if XProduto.TryGetValue('grade',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoGradeProduto"=:xgrade'
         else
            wcampos := wcampos+',"CodigoGradeProduto"=:xgrade';
       end;
    if XProduto.TryGetValue('percentualpromocao',wval) then
       begin
         if wcampos='' then
            wcampos := '"PercentualPromocionalProduto"=:xpercentualpromocao'
         else
            wcampos := wcampos+',"PercentualPromocionalProduto"=:xpercentualpromocao';
       end;
    if XProduto.TryGetValue('caracteristica',wval) then
       begin
         if wcampos='' then
            wcampos := '"CaracteristicaProduto"=:xcaracteristica'
         else
            wcampos := wcampos+',"CaracteristicaProduto"=:xcaracteristica';
       end;
    if XProduto.TryGetValue('qtdfracionada',wval) then
       begin
         if wcampos='' then
            wcampos := '"QuantidadeFracionadaProduto"=:xqtdfracionada'
         else
            wcampos := wcampos+',"QuantidadeFracionadaProduto"=:xqtdfracionada';
       end;
    if XProduto.TryGetValue('ehcomposto',wval) then
       begin
         if wcampos='' then
            wcampos := '"EhCompostoProduto"=:xehcomposto'
         else
            wcampos := wcampos+',"EhCompostoProduto"=:xehcomposto';
       end;
    if XProduto.TryGetValue('ehcalculado',wval) then
       begin
         if wcampos='' then
            wcampos := '"EhCalculadoProduto"=:xehcalculado'
         else
            wcampos := wcampos+',"EhCalculadoProduto"=:xehcalculado';
       end;
    if XProduto.TryGetValue('percquebra',wval) then
       begin
         if wcampos='' then
            wcampos := '"PercentualQuebraProduto"=:xpercquebra'
         else
             wcampos := wcampos+',"PercentualQuebraProduto"=:xpercquebra';
       end;
    if XProduto.TryGetValue('incidepis',wval) then
       begin
         if wcampos='' then
            wcampos := '"IncidePISProduto"=:xincidepis'
         else
            wcampos := wcampos+',"IncidePISProduto"=:xincidepis';
       end;
    if XProduto.TryGetValue('incidecofins',wval) then
       begin
         if wcampos='' then
            wcampos := '"IncideCOFINSProduto"=:xincidecofins'
         else
            wcampos := wcampos+',"IncideCOFINSProduto"=:xincidecofins';
       end;
    if XProduto.TryGetValue('idclassificacaofiscal',wval) then
       begin
         if wcampos='' then
            wcampos := '"ClassificacaoFiscalProduto"=:xidclassificacaofiscal'
         else
            wcampos := wcampos+',"ClassificacacaoFiscalProduto"=:xidclassificacaofiscal';
       end;
    if XProduto.TryGetValue('percicmsanterior',wval) then
       begin
         if wcampos='' then
            wcampos := '"PercentualICMSAnteriorProduto"=:xpercicmsanterior'
         else
            wcampos := wcampos+',"PercentualICMSAnteriorProduto"=:xpercicmsanterior';
       end;
    if XProduto.TryGetValue('tipocadastro',wval) then
       begin
         if wcampos='' then
            wcampos := '"TipoCadastroProduto"=:xtipocadastro'
         else
            wcampos := wcampos+',"TipoCadastroProduto"=:xtipocadastro';
       end;
    if XProduto.TryGetValue('basepisentrada',wval) then
       begin
         if wcampos='' then
            wcampos := '"BasePISEntradaProduto"=:xbasepisentrada'
         else
            wcampos := wcampos+',"BasePISEntradaProduto"=:xbasepisentrada';
       end;
    if XProduto.TryGetValue('basecofinsentrada',wval) then
       begin
         if wcampos='' then
            wcampos := '"BaseCOFINSEntradaProduto"=:xbasecofinsentrada'
         else
            wcampos := wcampos+',"BaseCOFINSEntradaProduto"=:xbasecofinsentrada';
       end;
    if XProduto.TryGetValue('basepissaida',wval) then
       begin
         if wcampos='' then
            wcampos := '"BasePISSaidaProduto"=:xbasepissaida'
         else
            wcampos := wcampos+',"BasePISSaidaProduto"=:xbasepissaida';
       end;
    if XProduto.TryGetValue('basecofinssaida',wval) then
       begin
         if wcampos='' then
            wcampos := '"BaseCOFINSSaidaProduto"=:xbasecofinssaida'
         else
            wcampos := wcampos+',"BaseCOFINSSaidaProduto"=:xbasecofinssaida';
       end;
    if XProduto.TryGetValue('cstpisentrada',wval) then
       begin
         if wcampos='' then
            wcampos := '"CSTPISEntradaProduto"=:xcstpisentrada'
         else
            wcampos := wcampos+',"CSTPISEntradaProduto"=:xcstpisentrada';
       end;
    if XProduto.TryGetValue('cstcofinsentrada',wval) then
       begin
         if wcampos='' then
            wcampos := '"CSTCOFINSEntradaProduto"=:xcstcofinsentrada'
         else
            wcampos := wcampos+',"CSTCOFINSEntradaProduto"=:xcstcofinsentrada';
       end;
    if XProduto.TryGetValue('cstpissaida',wval) then
       begin
         if wcampos='' then
            wcampos := '"CSTPISSaidaProduto"=:xcstpissaida'
         else
            wcampos := wcampos+',"CSTPISSaidaProduto"=:xcstpissaida';
       end;
    if XProduto.TryGetValue('cstcofinssaida',wval) then
       begin
         if wcampos='' then
            wcampos := '"CSTCOFINSSaidaProduto"=:xcstcofinssaida'
         else
            wcampos := wcampos+',"CSTCOFINSSaidaProduto"=:xcstcofinssaida';
       end;
    if XProduto.TryGetValue('margemfixa',wval) then
       begin
         if wcampos='' then
            wcampos := '"PercentualMargemFixaProduto"=:xmargemfixa'
         else
            wcampos := wcampos+',"PercentualMargemFixaProduto"=:xmargemfixa';
       end;
    if XProduto.TryGetValue('idcodigocontabil',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoContabilProduto"=:xidcodigocontabil'
         else
            wcampos := wcampos+',"CodigoContabilProduto"=:xidcodigocontabil';
       end;
    if XProduto.TryGetValue('percdesconto',wval) then
       begin
         if wcampos='' then
            wcampos := '"PercentualDescontoProduto"=:xpercdesconto'
         else
            wcampos := wcampos+',"PercentualDescontoProduto"=:xpercdesconto';
       end;
    if XProduto.TryGetValue('qtddesconto',wval) then
       begin
         if wcampos='' then
            wcampos := '"QuantidadeDescontoProduto"=:xqtddesconto'
         else
            wcampos := wcampos+',"QuantidadeDescontoProduto"=:xqtddesconto';
       end;
    if XProduto.TryGetValue('fontecaracteristica',wval) then
       begin
         if wcampos='' then
            wcampos := '"FonteCaracteristicaProduto"=:xfontecaracteristica'
         else
            wcampos := wcampos+',"FonteCaracteristicaProduto"=:xfontecaracteristica';
       end;
    if XProduto.TryGetValue('qtdunidadepum',wval) then
       begin
         if wcampos='' then
            wcampos := '"QuantidadeUnidadePUMProduto"=:xqtdunidadepum'
         else
            wcampos := wcampos+',"QuantidadeUnidadePUMProduto"=:xqtdunidadepum';
       end;
    if XProduto.TryGetValue('unidadeqtdepum',wval) then
       begin
         if wcampos='' then
            wcampos := '"UnidadeQuantidadePUMProduto"=:xunidadeqtdepum'
         else
            wcampos := wcampos+',"UnidadeQuantidadePUMProduto"=:xunidadeqtdepum';
       end;
    if XProduto.TryGetValue('unidaderefpum',wval) then
       begin
         if wcampos='' then
            wcampos := '"UnidadeReferencialPUMProduto"=:xunidaderefpum'
         else
            wcampos := wcampos+',"UnidadeReferencialPUMProduto"=:xunidaderefpum';
       end;
    if XProduto.TryGetValue('enviasite',wval) then
       begin
         if wcampos='' then
            wcampos := '"EnviaSiteProduto"=:xenviasite'
         else
            wcampos := wcampos+',"EnviaSiteProduto"=:xenviasite';
       end;
    if XProduto.TryGetValue('dataenviosite',wval) then
       begin
         if wcampos='' then
            wcampos := '"DataEnvioSiteProduto"=:xdataenviosite'
         else
            wcampos := wcampos+',"DataEnvioSiteProduto"=:xdataenviosite';
       end;
    if XProduto.TryGetValue('idusuarioenviosite',wval) then
       begin
         if wcampos='' then
            wcampos := '"UsuarioEnvioSiteProduto"=:xidusuarioenviosite'
         else
            wcampos := wcampos+',"UsuarioEnvioSiteProduto"=:xidusuarioenviosite';
       end;
    if XProduto.TryGetValue('numerofci',wval) then
       begin
         if wcampos='' then
            wcampos := '"NumeroFCIProduto"=:xnumerofci'
         else
            wcampos := wcampos+',"NumeroFCIProduto"=:xnumerofci';
       end;
    if XProduto.TryGetValue('temfoto',wval) then
       begin
         if wcampos='' then
            wcampos := '"TemFotoProduto"=:xtemfoto'
         else
            wcampos := wcampos+',"TemFotoProduto"=:xtemfoto';
       end;
    if XProduto.TryGetValue('dctfpis',wval) then
       begin
         if wcampos='' then
            wcampos := '"DCTFPisProduto"=:xdctfpis'
         else
            wcampos := wcampos+',"DCTFPisProduto"=:xdctfpis';
       end;
    if XProduto.TryGetValue('dctfcofins',wval) then
       begin
         if wcampos='' then
            wcampos := '"DCTFCofinsProduto"=:xdctfcofins'
         else
            wcampos := wcampos+',"DCTFCofinsProduto"=:xdctfcofins';
       end;
    if XProduto.TryGetValue('codnatureza',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoNaturezaProduto"=:xcodnatureza'
         else
            wcampos := wcampos+',"CodigoNaturezaProduto"=:xcodnatureza';
       end;
    if XProduto.TryGetValue('incidediferimento',wval) then
       begin
         if wcampos='' then
            wcampos := '"IncideDiferimentoProduto"=:xincidediferimento'
         else
            wcampos := wcampos+',"IncideDiferimentoProduto"=:xincidediferimento';
       end;
    if XProduto.TryGetValue('idfamilia',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoFamiliaProduto"=:xidfamilia'
         else
            wcampos := wcampos+',"CodigoFamiliaProduto"=:xidfamilia';
       end;
    if XProduto.TryGetValue('descricaoextendida',wval) then
       begin
         if wcampos='' then
            wcampos := '"DescricaoExtendidaProduto"=:xdescricaoextendida'
         else
            wcampos := wcampos+',"DescricaoExtendidaProduto"=:xdescricaoextendida';
       end;
    if XProduto.TryGetValue('idaliquotast',wval) then
       begin
         if wcampos='' then
            wcampos := '"AliquotaSTProduto"=:xidaliquotast'
         else
            wcampos := wcampos+',"AliquotaSTProduto"=:xidaliquotast';
       end;
    if XProduto.TryGetValue('percreducaost',wval) then
       begin
         if wcampos='' then
            wcampos := '"PercentualReducaoSTProduto"=:xpercreducaost'
         else
            wcampos := wcampos+',"PercentualReducaoSTProduto"=:xpercreducaost';
       end;
    if XProduto.TryGetValue('cbnef',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoBeneficioFiscalProduto"=:xcbnef'
         else
            wcampos := wcampos+',"CodigoBeneficioFiscalProduto"=:xcbnef';
       end;
    if XProduto.TryGetValue('comprimento',wval) then
       begin
         if wcampos='' then
            wcampos := '"ComprimentoProduto"=:xcomprimento'
         else
            wcampos := wcampos+',"ComprimentoProduto"=:xcomprimento';
       end;
    if XProduto.TryGetValue('altura',wval) then
       begin
         if wcampos='' then
            wcampos := '"AlturaProduto"=:xaltura'
         else
            wcampos := wcampos+',"AlturaProduto"=:xaltura';
       end;
    if XProduto.TryGetValue('profundidade',wval) then
       begin
         if wcampos='' then
            wcampos := '"ProfundidadeProduto"=:xprofundidade'
         else
            wcampos := wcampos+',"ProfundidadeProduto"=:xprofundidade';
       end;
    if XProduto.TryGetValue('idcategoria',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoCategoriaProduto"=:xidcategoria'
         else
            wcampos := wcampos+',"CodigoCategoriaProduto"=:xidcategoria';
       end;
     if XProduto.TryGetValue('margemvenda',wval) then
       begin
         if wcampos='' then
            wcampos := '"PercentualMargemVendaProduto"=:xmargemvenda'
         else
            wcampos := wcampos+',"PercentualMargemVendaProduto"=:xmargemvenda';
       end;
    if XProduto.TryGetValue('percfrete',wval) then
       begin
         if wcampos='' then
            wcampos := '"PercentualFreteProduto"=:xpercfrete'
         else
            wcampos := wcampos+',"PercentualFreteProduto"=:xpercfrete';
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
           SQL.Add('Update "Produto" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoProduto"=:xid ');
           ParamByName('xid').AsInteger                  := XIdProduto;
           if XProduto.TryGetValue('codigo',wval) then
              ParamByName('xcodigo').AsString            := XProduto.GetValue('codigo').Value;
           if XProduto.TryGetValue('descricao',wval) then
              ParamByName('xdescricao').AsString         := XProduto.GetValue('descricao').Value;
           if XProduto.TryGetValue('referencia',wval) then
              ParamByName('xreferencia').AsString        := XProduto.GetValue('referencia').Value;
           if XProduto.TryGetValue('ativo',wval) then
              ParamByName('xativo').AsBoolean            := strtobooldef(XProduto.GetValue('ativo').Value,true);
           if XProduto.TryGetValue('unidade',wval) then
              ParamByName('xunidade').AsString           := XProduto.GetValue('unidade').Value;
           if XProduto.TryGetValue('idestrutura',wval) then
              ParamByName('xidestrutura').AsInteger      := strtointdef(XProduto.GetValue('idestrutura').Value,0);
           if XProduto.TryGetValue('pontominimo',wval) then
              ParamByName('xpontominimo').AsFloat        := strtofloatdef(XProduto.GetValue('pontominimo').Value,0);
           if XProduto.TryGetValue('pontopedido',wval) then
              ParamByName('xpontopedido').AsFloat        := strtofloatdef(XProduto.GetValue('pontopedido').Value,0);
           if XProduto.TryGetValue('pontomaximo',wval) then
              ParamByName('xpontomaximo').AsFloat        := strtofloatdef(XProduto.GetValue('pontomaximo').Value,0);
           if XProduto.TryGetValue('pesobruto',wval) then
              ParamByName('xpesobruto').AsFloat          := strtofloatdef(XProduto.GetValue('pesobruto').Value,0);
           if XProduto.TryGetValue('pesoliquido',wval) then
              ParamByName('xpesoliquido').AsFloat        := strtofloatdef(XProduto.GetValue('pesoliquido').Value,0);
           if XProduto.TryGetValue('qtdembalagem',wval) then
              ParamByName('xqtdembalagem').AsFloat       := strtofloatdef(XProduto.GetValue('qtdembalagem').Value,0);
           if XProduto.TryGetValue('basecalculoicms',wval) then
              ParamByName('xbasecalculoicms').AsFloat    := strtofloatdef(XProduto.GetValue('basecalculoicms').Value,0);
           if XProduto.TryGetValue('percentualicms',wval) then
              ParamByName('xpercentualicms').AsFloat     := strtofloatdef(XProduto.GetValue('percentualicms').Value,0);
           if XProduto.TryGetValue('percentualipi',wval) then
              ParamByName('xpercentualipi').AsFloat      := strtofloatdef(XProduto.GetValue('percentualipi').Value,0);
           if XProduto.TryGetValue('classificacao',wval) then
              ParamByName('xclassificacao').AsString     := XProduto.GetValue('classificacao').Value;
           if XProduto.TryGetValue('precocusto',wval) then
              ParamByName('xprecocusto').AsFloat         := strtofloatdef(XProduto.GetValue('precocusto').Value,0);
           if XProduto.TryGetValue('preco1',wval) then
              ParamByName('xpreco1').AsFloat             := strtofloatdef(XProduto.GetValue('preco1').Value,0);
           if XProduto.TryGetValue('preco2',wval) then
              ParamByName('xpreco2').AsFloat             := strtofloatdef(XProduto.GetValue('preco2').Value,0);
           if XProduto.TryGetValue('preco3',wval) then
              ParamByName('xpreco3').AsFloat             := strtofloatdef(XProduto.GetValue('preco3').Value,0);
           if XProduto.TryGetValue('preco4',wval) then
              ParamByName('xpreco4').AsFloat             := strtofloatdef(XProduto.GetValue('preco4').Value,0);
           if XProduto.TryGetValue('preco5',wval) then
              ParamByName('xpreco5').AsFloat             := strtofloatdef(XProduto.GetValue('preco5').Value,0);
           if XProduto.TryGetValue('preco6',wval) then
              ParamByName('xpreco6').AsFloat             := strtofloatdef(XProduto.GetValue('preco6').Value,0);
           if XProduto.TryGetValue('preco7',wval) then
              ParamByName('xpreco7').AsFloat             := strtofloatdef(XProduto.GetValue('preco7').Value,0);
           if XProduto.TryGetValue('preco8',wval) then
              ParamByName('xpreco8').AsFloat             := strtofloatdef(XProduto.GetValue('preco8').Value,0);
           if XProduto.TryGetValue('preco9',wval) then
              ParamByName('xpreco9').AsFloat             := strtofloatdef(XProduto.GetValue('preco9').Value,0);
           if XProduto.TryGetValue('preco10',wval) then
              ParamByName('xpreco10').AsFloat            := strtofloatdef(XProduto.GetValue('preco10').Value,0);
           if XProduto.TryGetValue('idformula',wval) then
              ParamByName('xidformula').AsInteger        := strtointdef(XProduto.GetValue('idformula').Value,0);
           if XProduto.TryGetValue('numserie',wval) then
              ParamByName('xnumserie').AsInteger         := strtointdef(XProduto.GetValue('numserie').Value,0);
           if XProduto.TryGetValue('aplicacao',wval) then
              ParamByName('xaplicacao').AsString         := XProduto.GetValue('aplicacao').Value;
           if XProduto.TryGetValue('observacao',wval) then
              ParamByName('xobservacao').AsString        := XProduto.GetValue('observacao').Value;
           if XProduto.TryGetValue('datacadastramento',wval) then
              ParamByName('xdatacadastramento').AsDate   := StrToDateDef(XProduto.GetValue('datacadastramento').Value,date);
           if XProduto.TryGetValue('qtdestoque',wval) then
              ParamByName('xqtdestoque').AsFloat         := strtofloatdef(XProduto.GetValue('qtdestoque').Value,0);
           if XProduto.TryGetValue('qtdencomendado',wval) then
              ParamByName('xqtdencomendado').AsFloat     := strtofloatdef(XProduto.GetValue('qtdencomendado').Value,0);
           if XProduto.TryGetValue('totalcusto',wval) then
              ParamByName('xtotalcusto').AsFloat         := strtofloatdef(XProduto.GetValue('totalcusto').Value,0);
           if XProduto.TryGetValue('totalvenda',wval) then
              ParamByName('xtotalvenda').AsFloat         := strtofloatdef(XProduto.GetValue('totalvenda').Value,0);
           if XProduto.TryGetValue('dataentrada',wval) then
              ParamByName('xdataentrada').AsDate         := strtodatedef(XProduto.GetValue('dataentrada').Value,0);
           if XProduto.TryGetValue('idoperacaoentrada',wval) then
              ParamByName('xidoperacaoentrada').AsInteger:= strtointdef(XProduto.GetValue('idoperacaoentrada').Value,0);
           if XProduto.TryGetValue('qtdentrada',wval) then
              ParamByName('xqtdentrada').AsFloat         := strtofloatdef(XProduto.GetValue('qtdentrada').Value,0);
           if XProduto.TryGetValue('datasaida',wval) then
              ParamByName('xdatasaida').AsDate           := strtodatedef(XProduto.GetValue('datasaida').Value,0);
           if XProduto.TryGetValue('idoperacaosaida',wval) then
              ParamByName('xidoperacaosaida').AsInteger  := strtointdef(XProduto.GetValue('idoperacaosaida').Value,0);
           if XProduto.TryGetValue('qtdsaida',wval) then
              ParamByName('xqtdsaida').AsFloat           := strtofloatdef(XProduto.GetValue('qtdsaida').Value,0);
           if XProduto.TryGetValue('totalentrada',wval) then
              ParamByName('xtotalentrada').AsFloat       := strtofloatdef(XProduto.GetValue('totalentrada').Value,0);
           if XProduto.TryGetValue('totalsaida',wval) then
              ParamByName('xtotalsaida').AsFloat         := strtofloatdef(XProduto.GetValue('totalsaida').Value,0);
           if XProduto.TryGetValue('tipo',wval) then
              ParamByName('xtipo').AsString              := XProduto.GetValue('tipo').Value;
           if XProduto.TryGetValue('prazovalidade',wval) then
              ParamByName('xprazovalidade').AsInteger    := strtointdef(XProduto.GetValue('idprazovalidade').Value,0);
           if XProduto.TryGetValue('teclaassociada',wval) then
              ParamByName('xteclassociada').AsString     := XProduto.GetValue('teclaassociada').Value;
           if XProduto.TryGetValue('descricaoreduzida',wval) then
              ParamByName('xdescricaoreduzida').AsString := XProduto.GetValue('descricaoreduzida').Value;
           if XProduto.TryGetValue('qtdetiqueta',wval) then
              ParamByName('xqtdetiqueta').AsInteger      := strtointdef(XProduto.GetValue('qtdetiqueta').Value,0);
           if XProduto.TryGetValue('horaultimaalteracao',wval) then
              ParamByName('xhoraultimaalteracao').AsString := XProduto.GetValue('horaultimaalteracao').Value;
           if XProduto.TryGetValue('idaliquota',wval) then
              ParamByName('xidaliquota').AsInteger       := strtointdef(XProduto.GetValue('idaliquota').Value,0);
           if XProduto.TryGetValue('margemlucro',wval) then
              ParamByName('xmargemlucro').AsFloat        := strtofloatdef(XProduto.GetValue('margemlucro').Value,0);
           if XProduto.TryGetValue('idsetor',wval) then
              ParamByName('xidsetor').AsInteger          := strtointdef(XProduto.GetValue('idsetor').Value,0);
           if XProduto.TryGetValue('incidest',wval) then
              ParamByName('xincidest').AsBoolean         := strtobooldef(XProduto.GetValue('incidest').Value,false);
           if XProduto.TryGetValue('fabricante',wval) then
              ParamByName('xfabricante').AsString        := XProduto.GetValue('fabricante').Value;
           if XProduto.TryGetValue('idfabricante',wval) then
              ParamByName('xidfabricante').AsInteger     := strtointdef(XProduto.GetValue('idfabricante').Value,0);
           if XProduto.TryGetValue('idsituacaotributaria',wval) then
              ParamByName('xidsituacaotributaria').AsInteger := strtointdef(XProduto.GetValue('idsituacaotributaria').Value,0);
           if XProduto.TryGetValue('bitola',wval) then
              ParamByName('xbitola').AsString            := XProduto.GetValue('bitola').Value;
           if XProduto.TryGetValue('marca',wval) then
              ParamByName('xmarca').AsString             := XProduto.GetValue('marca').Value;
           if XProduto.TryGetValue('caminhofoto',wval) then
              ParamByName('xcaminhofoto').AsString       := XProduto.GetValue('caminhofoto').Value;
           if XProduto.TryGetValue('percentualcomissao',wval) then
              ParamByName('xpercentualcomissao').AsFloat := strtofloatdef(XProduto.GetValue('percentualcomissao').Value,0);
           if XProduto.TryGetValue('cean',wval) then
              ParamByName('xcean').AsString              := XProduto.GetValue('cean').Value;
           if XProduto.TryGetValue('saldoestoque',wval) then
              ParamByName('xsaldoestoque').AsFloat       := strtofloatdef(XProduto.GetValue('saldoestoque').Value,0);
           if XProduto.TryGetValue('mva',wval) then
              ParamByName('xmva').AsFloat                := strtofloatdef(XProduto.GetValue('mva').Value,0);
           if XProduto.TryGetValue('icmdestino',wval) then
              ParamByName('xicmdestino').AsFloat         := strtofloatdef(XProduto.GetValue('icmdestino').Value,0);
           if XProduto.TryGetValue('grade',wval) then
              ParamByName('xgrade').AsInteger            := strtointdef(XProduto.GetValue('grade').Value,0);
           if XProduto.TryGetValue('percentualpromocao',wval) then
              ParamByName('xpercentualpromocao').AsFloat := strtofloatdef(XProduto.GetValue('percentualpromocao').Value,0);
           if XProduto.TryGetValue('caracteristica',wval) then
              ParamByName('xcaracteristica').AsString    := XProduto.GetValue('caracteristica').Value;
           if XProduto.TryGetValue('qtdfracionada',wval) then
              ParamByName('xqtdfracionada').AsBoolean    := strtobooldef(XProduto.GetValue('qtdfracionada').Value,false);
           if XProduto.TryGetValue('ehcomposto',wval) then
              ParamByName('xehcomposto').AsBoolean       := strtobooldef(XProduto.GetValue('ehcomposto').Value,false);
           if XProduto.TryGetValue('ehcalculado',wval) then
              ParamByName('xehcalculado').AsBoolean      := strtobooldef(XProduto.GetValue('ehcalculado').Value,false);
           if XProduto.TryGetValue('percquebra',wval) then
              ParamByName('xpercquebra').AsFloat         := strtofloatdef(XProduto.GetValue('percquebra').Value,0);
           if XProduto.TryGetValue('incidepis',wval) then
              ParamByName('xincidepis').AsBoolean        := strtobooldef(XProduto.GetValue('incidepis').Value,false);
           if XProduto.TryGetValue('incidecofins',wval) then
              ParamByName('xincidecofins').AsBoolean     := strtobooldef(XProduto.GetValue('incidecofins').Value,false);
           if XProduto.TryGetValue('idclassificacaofiscal',wval) then
              ParamByName('xidclassificacaofiscal').AsInteger := strtointdef(XProduto.GetValue('idclassificacaofiscal').Value,0);
           if XProduto.TryGetValue('percicmsanterior',wval) then
              ParamByName('xpercicmsanterior').AsFloat   := strtofloatdef(XProduto.GetValue('percicmsanterior').Value,0);
           if XProduto.TryGetValue('tipocadastro',wval) then
              ParamByName('xtipocadastro').AsString      := XProduto.GetValue('tipocadastro').Value;
           if XProduto.TryGetValue('basepisentrada',wval) then
              ParamByName('xbasepisentrada').AsFloat     := strtofloatdef(XProduto.GetValue('basepisentrada').Value,0);
           if XProduto.TryGetValue('basecofinsentrada',wval) then
              ParamByName('xbasecofinsentrada').AsFloat  := strtofloatdef(XProduto.GetValue('basecofinsentrada').Value,0);
           if XProduto.TryGetValue('basepissaida',wval) then
              ParamByName('xbasepissaida').AsFloat       := strtofloatdef(XProduto.GetValue('basepissaida').Value,0);
           if XProduto.TryGetValue('basecofinssaida',wval) then
              ParamByName('xbasecofinssaida').AsFloat    := strtofloatdef(XProduto.GetValue('basecofinssaida').Value,0);
           if XProduto.TryGetValue('cstpisentrada',wval) then
              ParamByName('xcstpisentrada').AsString     := XProduto.GetValue('cstpisentrada').Value;
           if XProduto.TryGetValue('cstcofinsentrada',wval) then
              ParamByName('xcstcofinsentrada').AsString  := XProduto.GetValue('cstcofinsentrada').Value;
           if XProduto.TryGetValue('cstpissaida',wval) then
              ParamByName('xcstpissaida').AsString       := XProduto.GetValue('cstpissaida').Value;
           if XProduto.TryGetValue('cstcofinssaida',wval) then
              ParamByName('xcstcofinssaida').AsString    := XProduto.GetValue('cstcofinssaida').Value;
           if XProduto.TryGetValue('margemfixa',wval) then
              ParamByName('xmargemfixa').AsFloat         := strtofloatdef(XProduto.GetValue('margemfixa').Value,0);
           if XProduto.TryGetValue('idcodigocontabil',wval) then
              ParamByName('xidcodigocontabil').AsInteger := strtointdef(XProduto.GetValue('idcodigocontabil').Value,0);
           if XProduto.TryGetValue('percdesconto',wval) then
              ParamByName('xpercdesconto').AsFloat       := strtofloatdef(XProduto.GetValue('percdesconto').Value,0);
           if XProduto.TryGetValue('qtddesconto',wval) then
              ParamByName('xqtddesconto').AsFloat        := strtofloatdef(XProduto.GetValue('qtddesconto').Value,0);
           if XProduto.TryGetValue('fontecaracteristica',wval) then
              ParamByName('xfontecaracteristica').AsString := XProduto.GetValue('fontecaracteristica').Value;
           if XProduto.TryGetValue('qtdunidadepum',wval) then
              ParamByName('xqtdunidadepum').AsFloat        := strtofloatdef(XProduto.GetValue('qtdunidadepum').Value,0);
           if XProduto.TryGetValue('unidadeqtdepum',wval) then
              ParamByName('xunidadeqtdepum').AsString      := XProduto.GetValue('unidadeqtdepum').Value;
           if XProduto.TryGetValue('unidaderefpum',wval) then
              ParamByName('xunidaderefpum').AsString       := XProduto.GetValue('unidaderefpum').Value;
           if XProduto.TryGetValue('enviasite',wval) then
              ParamByName('xenviasite').AsBoolean          := strtobooldef(XProduto.GetValue('enviasite').Value,false);
           if XProduto.TryGetValue('dataenviosite',wval) then
              ParamByName('xdataenviosite').AsDate         := strtodatedef(XProduto.GetValue('dataenviosite').Value,0);
           if XProduto.TryGetValue('idusuarioenviosite',wval) then
              ParamByName('xidusuarioenviosite').AsInteger := strtointdef(XProduto.GetValue('idusuarioenviosite').Value,0);
           if XProduto.TryGetValue('numerofci',wval) then
              ParamByName('xnumerofci').AsString           := XProduto.GetValue('numerofci').Value;
           if XProduto.TryGetValue('temfoto',wval) then
              ParamByName('xtemfoto').AsBoolean            := strtobooldef(XProduto.GetValue('temfoto').Value,false);
           if XProduto.TryGetValue('dctfpis',wval) then
              ParamByName('xdctfpis').AsString             := XProduto.GetValue('dctfpis').Value;
           if XProduto.TryGetValue('dctfcofins',wval) then
              ParamByName('xdctfcofins').AsString          := XProduto.GetValue('dctfcofins').Value;
           if XProduto.TryGetValue('codnatureza',wval) then
              ParamByName('xcodnatureza').AsString         := XProduto.GetValue('codnatureza').Value;
           if XProduto.TryGetValue('incidediferimento',wval) then
              ParamByName('xincidediferimento').AsBoolean  := strtobooldef(XProduto.GetValue('incidediferimento').Value,false);
           if XProduto.TryGetValue('idfamilia',wval) then
              ParamByName('xidfamilia').AsInteger          := strtointdef(XProduto.GetValue('idfamilia').Value,0);
           if XProduto.TryGetValue('descricaoextendida',wval) then
              ParamByName('xdescricaoextendida').AsString  := XProduto.GetValue('descricaoextendida').Value;
           if XProduto.TryGetValue('idaliquotast',wval) then
              ParamByName('xidaliquotast').AsInteger       := strtointdef(XProduto.GetValue('idaliquotast').Value,0);
           if XProduto.TryGetValue('percreducaost',wval) then
              ParamByName('xpercreducaost').AsFloat        := strtofloatdef(XProduto.GetValue('percreducaost').Value,0);
           if XProduto.TryGetValue('cbnef',wval) then
              ParamByName('xcbnef').AsString               := XProduto.GetValue('cbnef').Value;
           if XProduto.TryGetValue('comprimento',wval) then
              ParamByName('xcomprimento').AsFloat          := strtofloatdef(XProduto.GetValue('comprimento').Value,0);
           if XProduto.TryGetValue('altura',wval) then
              ParamByName('xaltura').AsFloat               := strtofloatdef(XProduto.GetValue('altura').Value,0);
           if XProduto.TryGetValue('profundidade',wval) then
              ParamByName('xprofundidade').AsFloat         := strtofloatdef(XProduto.GetValue('profundidade').Value,0);
           if XProduto.TryGetValue('idcategoria',wval) then
               ParamByName('xidcategoria').AsInteger       := strtointdef(XProduto.GetValue('idcategoria').Value,0);
           if XProduto.TryGetValue('margemvenda',wval) then
              ParamByName('xmargemvenda').AsFloat          := strtofloatdef(XProduto.GetValue('margemvenda').Value,0);
           if XProduto.TryGetValue('percfrete',wval) then
              ParamByName('xpercfrete').AsFloat            := strtofloatdef(XProduto.GetValue('percfrete').Value,0);
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
              SQL.Add('select "CodigoInternoProduto" as id,');
              SQL.Add('       "CodigoProduto"        as codigo,');
              SQL.Add('       "DescricaoProduto"     as descricao, ');
              SQL.Add('       "ReferenciaProduto"    as referencia, ');
              SQL.Add('       "AtivoProduto"         as ativo, ');
              SQL.Add('       "UnidadeProduto"       as unidade, ');
              SQL.Add('       "CodigoEstruturalProduto" as idestrutura, ');
              SQL.Add('       "MinimoProduto"        as pontominimo, ');
              SQL.Add('       "PedidoProduto"        as pontopedido, ');
              SQL.Add('       "MaximoProduto"        as pontomaximo, ');
              SQL.Add('       "PesoBrutoProduto"     as pesobruto, ');
              SQL.Add('       "PesoLiquidoProduto"   as pesoliquido, ');
              SQL.Add('       "QuantidadeEmbalagemProduto" as qtdembalagem, ');
              SQL.Add('       "BaseCalculoProduto"         as basecalculoicms, ');
              SQL.Add('       "PercentualICMSProduto"      as percentualicms, ');
              SQL.Add('       "PercentualIPIProduto"       as percentualipi, ');
              SQL.Add('       "ClassificacaoProduto"       as classificacao, ');
              SQL.Add('       "CustoProduto"               as precocusto, ');
              SQL.Add('       "Venda1Produto"              as preco1, ');
              SQL.Add('       "Venda2Produto"              as preco2, ');
              SQL.Add('       "Venda3Produto"              as preco3, ');
              SQL.Add('       "Venda4Produto"              as preco4, ');
              SQL.Add('       "Venda5Produto"              as preco5, ');
              SQL.Add('       "Venda6Produto"              as preco6, ');
              SQL.Add('       "Venda7Produto"              as preco7, ');
              SQL.Add('       "Venda8Produto"              as preco8, ');
              SQL.Add('       "Venda9Produto"              as preco9, ');
              SQL.Add('       "Venda10Produto"             as preco10, ');
              SQL.Add('       "FormulaCalculoProduto"      as idformula, ');
              SQL.Add('       "NumeroSerieProduto"         as numserie, ');
              SQL.Add('       "AplicacaoProduto"           as aplicacao, ');
              SQL.Add('       "ObservacaoProduto"          as observacao, ');
              SQL.Add('       "DataCadastramentoProduto"   as datacadastramento, ');
              SQL.Add('       "EstoqueProduto"             as qtdestoque, ');
              SQL.Add('       "EncomendadoProduto"         as qtdencomendado, ');
              SQL.Add('       "TotalCustoProduto"          as totalcusto, ');
              SQL.Add('       "TotalVendaProduto"          as totalvenda, ');
              SQL.Add('       "DataEntradaProduto"         as dataentrada, ');
              SQL.Add('       "OperacaoEntradaProduto"     as idoperacaoentrada, ');
              SQL.Add('       "QuantidadeEntradaProduto"   as qtdentrada, ');
              SQL.Add('       "DataSaidaProduto"           as datasaida, ');
              SQL.Add('       "OperacaoSaidaProduto"       as idoperacaosaida, ');
              SQL.Add('       "QuantidadeSaidaProduto"     as qtdsaida, ');
              SQL.Add('       "TotalEntradaProduto"        as totalentrada, ');
              SQL.Add('       "TotalSaidaProduto"          as totalsaida, ');
              SQL.Add('       "TipoProduto"                    as tipo, ');
              SQL.Add('       "PrazoValidadeProduto"            as prazovalidade, ');
              SQL.Add('       "TeclaAssociadaProduto"           as teclaassociada, ');
              SQL.Add('       "DescricaoReduzidaProduto"        as descricaoreduzida, ');
              SQL.Add('       "QtdeEtiquetaProduto"             as qtdetiqueta, ');
              SQL.Add('       "HoraUltimaAlteracaoProduto"      as horaultimaalteracao, ');
              SQL.Add('       "CodigoAliquotaProduto"           as idaliquota, ');
              SQL.Add('       "MargemLucroProduto"              as margemlucro, ');
              SQL.Add('       "CodigoSetorProduto"              as idsetor, ');
              SQL.Add('       "IncideSubstituicaoProduto"       as incidest, ');
              SQL.Add('       "FabricanteProduto"               as fabricante, ');
              SQL.Add('       "CodigoFabricanteProduto"         as idfabricante, ');
              SQL.Add('       "SituacaoTributariaProduto"       as idsituacaotributaria, ');
              SQL.Add('       "BitolaProduto"                   as bitola, ');
              SQL.Add('       "MarcaProduto"                    as marca, ');
              SQL.Add('       "CaminhoFotoProduto"              as caminhofoto, ');
              SQL.Add('       "PercentualComissaoProduto"       as percentualcomissao, ');
              SQL.Add('       "CodigoBarraProduto"              as cean,');
              SQL.Add('       "SaldoEstoqueProduto"             as saldoestoque,');
              SQL.Add('       "PercentualValorAgregadoProduto"  as mva,');
              SQL.Add('       "PercentualICMSDestinoProduto"    as icmdestino,');
              SQL.Add('       coalesce("CodigoGradeProduto",0)  as grade, ');
              SQL.Add('       "PercentualPromocionalProduto"    as percentualpromocao,');
              SQL.Add('       "CaracteristicaProduto"           as caracteristica,');
              SQL.Add('       "QuantidadeFracionadaProduto"     as qtdfracionada,');
              SQL.Add('       "EhCompostoProduto"               as ehcomposto,');
              SQL.Add('       "EhCalculadoProduto"              as ehcalculado,');
              SQL.Add('       "PercentualQuebraProduto"         as percquebra,');
              SQL.Add('       "IncidePISProduto"                as incidepis,');
              SQL.Add('       "IncideCOFINSProduto"             as incidecofins,');
              SQL.Add('       "ClassificacaoFiscalProduto"      as idclassificacaofiscal,');
              SQL.Add('       "PercentualICMSAnteriorProduto"   as percicmsanterior,');
              SQL.Add('       "TipoCadastroProduto"             as tipocadastro,');
              SQL.Add('       "BasePISEntradaProduto"           as basepisentrada,');
              SQL.Add('       "BaseCOFINSEntradaProduto"        as basecofinsentrada,');
              SQL.Add('       "BasePISSaidaProduto"             as basepissaida,');
              SQL.Add('       "BaseCOFINSSaidaProduto"          as basecofinssaida,');
              SQL.Add('       "CSTPISEntradaProduto"            as cstpisentrada,');
              SQL.Add('       "CSTCOFINSEntradaProduto"         as cstcofinsentrada,');
              SQL.Add('       "CSTPISSaidaProduto"              as cstpissaida,');
              SQL.Add('       "CSTCOFINSSaidaProduto"           as cstcofinssaida,');
              SQL.Add('       cast((select "PercentualPISConfigura" from "ConfiguracaoTSCompras" where "CodigoEmpresaConfigura"=:xidempresa) as numeric) as xpercpis,');
              SQL.Add('       cast((select "PercentualCofinsConfigura" from "ConfiguracaoTSCompras" where "CodigoEmpresaConfigura"=:xidempresa) as numeric) as xperccofins,');
              SQL.Add('       "PercentualMargemFixaProduto"     as margemfixa,');
              SQL.Add('       "CodigoContabilProduto"           as idcodigocontabil,');
              SQL.Add('       "PercentualDescontoProduto"       as percdesconto,');
              SQL.Add('       "QuantidadeDescontoProduto"       as qtddesconto,');
              SQL.Add('       "FonteCaracteristicaProduto"      as fontecaracteristica,');
              SQL.Add('       "QuantidadeUnidadePUMProduto"     as qtdunidadepum,');
              SQL.Add('       "UnidadeQuantidadePUMProduto"     as unidadeqtdepum,');
              SQL.Add('       "UnidadeReferencialPUMProduto"    as unidaderefpum,');
              SQL.Add('       "EnviaSiteProduto"                as enviasite,');
              SQL.Add('       "DataEnvioSiteProduto"            as dataenviosite,');
              SQL.Add('       "UsuarioEnvioSiteProduto"         as idusuarioenviosite,');
              SQL.Add('       "NumeroFCIProduto"                as numerofci,');
              SQL.Add('       "TemFotoProduto"                  as temfoto,');
              SQL.Add('       "DCTFPisProduto"                  as dctfpis,');
              SQL.Add('       "DCTFCofinsProduto"               as dctfcofins,');
              SQL.Add('       "CodigoNaturezaProduto"           as codnatureza,');
              SQL.Add('       "IncideDiferimentoProduto"        as incidediferimento,');
              SQL.Add('       "CodigoFamiliaProduto"            as idfamilia,');
              SQL.Add('       "DescricaoExtendidaProduto"       as descricaoextendida,');
              SQL.Add('       "AliquotaSTProduto"               as idaliquotast,');
              SQL.Add('       "PercentualReducaoSTProduto"      as percreducaost,');
              SQL.Add('       "CodigoBeneficioFiscalProduto"    as cbnef,');
              SQL.Add('       "ComprimentoProduto"              as comprimento,');
              SQL.Add('       "AlturaProduto"                   as altura,');
              SQL.Add('       "ProfundidadeProduto"             as profundidade,');
              SQL.Add('       "CodigoCategoriaProduto"          as idcategoria,');
              SQL.Add('       "PercentualMargemVendaProduto"    as margemvenda,');
              SQL.Add('       "PercentualFreteProduto"          as percfrete,');
              SQL.Add('       cast('''' as text)  as foto ');
              SQL.Add('from "Produto" ');
              SQL.Add('where "CodigoInternoProduto" =:xid ');
              ParamByName('xid').AsInteger := XIdProduto;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Produto alterado');
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

function ApagaProduto(XIdProduto: integer): TJSONObject;
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
         SQL.Add('delete from "Produto" where "CodigoInternoProduto"=:xid ');
         ParamByName('xid').AsInteger := XIdProduto;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Produto excluído com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhuma Produto excluído');
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
