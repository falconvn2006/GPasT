unit dat.cadProdutosPrecos;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaPreco(XId: integer): TJSONObject;
function RetornaListaPrecos(const XQuery: TDictionary<string, string>; XIdProduto: integer): TJSONArray;
function IncluiPreco(XPreco: TJSONObject; XIdProduto: integer): TJSONObject;
function AlteraPreco(XIdPreco: integer; XPreco: TJSONObject): TJSONObject;
function ApagaPreco(XIdPreco: integer): TJSONObject;
function VerificaRequisicao(XPreco: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaPreco(XId: integer): TJSONObject;
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
         SQL.Add('select  "CodigoInternoProdutoPreco"         as id,');
         SQL.Add('        "CodigoEmpresaProdutoPreco"         as idempresa,');
         SQL.Add('        "CodigoProdutoPreco"                as idproduto,');
         SQL.Add('        "DataProdutoPreco"                  as data,');
         SQL.Add('        "CustoProdutoPreco"                 as custo,');
         SQL.Add('        "CustoContabilProdutoPreco"         as custocontabil,');
         SQL.Add('        "PrecoMinimoProdutoPreco"           as precominimo,');
         SQL.Add('        "Venda1ProdutoPreco"                as venda1,');
         SQL.Add('        "Venda2ProdutoPreco"                as venda2,');
         SQL.Add('        "Venda3ProdutoPreco"                as venda3,');
         SQL.Add('        "Venda4ProdutoPreco"                as venda4,');
         SQL.Add('        "Venda5ProdutoPreco"                as venda5,');
         SQL.Add('        "CodigoItemProdutoPreco"            as iditem,');
         SQL.Add('        "CodigoInventarioItemProdutoPreco"  as idinventarioitem,');
         SQL.Add('        "PrecoSugestaoProdutoPreco"         as precosugestao,');
         SQL.Add('        "Venda6ProdutoPreco"                as venda6,');
         SQL.Add('        "Venda7ProdutoPreco"                as venda7,');
         SQL.Add('        "Venda8ProdutoPreco"                as venda8,');
         SQL.Add('        "Venda9ProdutoPreco"                as venda9,');
         SQL.Add('        "Venda10ProdutoPreco"               as venda10,');
         SQL.Add('        "CustoNotaProdutoPreco"             as custonota,');
         SQL.Add('        "CustoTabelaProdutoPreco"           as custotabela,');
         SQL.Add('        "CustoUnitarioProdutoPreco"         as custounitario,');
         SQL.Add('        "PrimeiroDescontoProdutoPreco"      as primeirodesconto,');
         SQL.Add('        "SegundoDescontoProdutoPreco"       as segundodesconto,');
         SQL.Add('        "TerceiroDescontoProdutoPreco"      as terceirodesconto,');
         SQL.Add('        "QuartoDescontoProdutoPreco"        as quartodesconto,');
         SQL.Add('        "NomeTabelaProdutoPreco"            as nometabela,');
         SQL.Add('        "PercentualFreteProdutoPreco"       as percentualfrete,');
         SQL.Add('        "PercentualICMSSubstituicaoProdutoPreco" as percentualicmsst,');
         SQL.Add('        "CustoContabilMedioProdutoPreco"    as custocontabilmedio,');
         SQL.Add('        "ValorICMSProprioMedioProdutoPreco" as valoricmspropriomedio,');
         SQL.Add('        "ValorICMSSTMedioProdutoPreco"      as valoricmsstmedio,');
         SQL.Add('        "BaseICMSSTMedioProdutoPreco"       as baseicmsstmedio ');
         SQL.Add('from "ProdutoPreco" ');
         SQL.Add('where "CodigoInternoProdutoPreco"=:xid ');
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
        wret.AddPair('description','Nenhum Produto Preço encontrado');
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

function RetornaListaPrecos(const XQuery: TDictionary<string, string>; XIdProduto: integer): TJSONArray;
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
         SQL.Add('select  "CodigoInternoProdutoPreco"         as id,');
         SQL.Add('        "CodigoEmpresaProdutoPreco"         as idempresa,');
         SQL.Add('        "CodigoProdutoPreco"                as idproduto,');
         SQL.Add('        "DataProdutoPreco"                  as data,');
         SQL.Add('        "CustoProdutoPreco"                 as custo,');
         SQL.Add('        "CustoContabilProdutoPreco"         as custocontabil,');
         SQL.Add('        "PrecoMinimoProdutoPreco"           as precominimo,');
         SQL.Add('        "Venda1ProdutoPreco"                as venda1,');
         SQL.Add('        "Venda2ProdutoPreco"                as venda2,');
         SQL.Add('        "Venda3ProdutoPreco"                as venda3,');
         SQL.Add('        "Venda4ProdutoPreco"                as venda4,');
         SQL.Add('        "Venda5ProdutoPreco"                as venda5,');
         SQL.Add('        "CodigoItemProdutoPreco"            as iditem,');
         SQL.Add('        "CodigoInventarioItemProdutoPreco"  as idinventarioitem,');
         SQL.Add('        "PrecoSugestaoProdutoPreco"         as precosugestao,');
         SQL.Add('        "Venda6ProdutoPreco"                as venda6,');
         SQL.Add('        "Venda7ProdutoPreco"                as venda7,');
         SQL.Add('        "Venda8ProdutoPreco"                as venda8,');
         SQL.Add('        "Venda9ProdutoPreco"                as venda9,');
         SQL.Add('        "Venda10ProdutoPreco"               as venda10,');
         SQL.Add('        "CustoNotaProdutoPreco"             as custonota,');
         SQL.Add('        "CustoTabelaProdutoPreco"           as custotabela,');
         SQL.Add('        "CustoUnitarioProdutoPreco"         as custounitario,');
         SQL.Add('        "PrimeiroDescontoProdutoPreco"      as primeirodesconto,');
         SQL.Add('        "SegundoDescontoProdutoPreco"       as segundodesconto,');
         SQL.Add('        "TerceiroDescontoProdutoPreco"      as terceirodesconto,');
         SQL.Add('        "QuartoDescontoProdutoPreco"        as quartodesconto,');
         SQL.Add('        "NomeTabelaProdutoPreco"            as nometabela,');
         SQL.Add('        "PercentualFreteProdutoPreco"       as percentualfrete,');
         SQL.Add('        "PercentualICMSSubstituicaoProdutoPreco" as percentualicmsst,');
         SQL.Add('        "CustoContabilMedioProdutoPreco"    as custocontabilmedio,');
         SQL.Add('        "ValorICMSProprioMedioProdutoPreco" as valoricmspropriomedio,');
         SQL.Add('        "ValorICMSSTMedioProdutoPreco"      as valoricmsstmedio,');
         SQL.Add('        "BaseICMSSTMedioProdutoPreco"       as baseicmsstmedio ');
         SQL.Add('from "ProdutoPreco" where "CodigoEmpresaProdutoPreco"=:xidempresa and "CodigoProdutoPreco"=:xidproduto ');
         ParamByName('xidempresa').AsInteger := wconexao.FIdEmpresa;
         ParamByName('xidproduto').AsInteger := XIdProduto;
         Open;
         EnableControls;
       end;
    if wqueryLista.RecordCount>0 then
       wret := wqueryLista.ToJSONArray()
    else
       begin
         wobj := TJSONObject.Create;
         wobj.AddPair('status','500');
         wobj.AddPair('description','Nenhum Produto Preço encontrado');
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

function IncluiPreco(XPreco: TJSONObject; XIdProduto: integer): TJSONObject;
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
           SQL.Add('Insert into "ProdutoPreco"("CodigoEmpresaProdutoPreco","CodigoProdutoPreco","DataProdutoPreco","CustoProdutoPreco",');
           SQL.Add('"CustoContabilProdutoPreco","PrecoMinimoProdutoPreco","Venda1ProdutoPreco","Venda2ProdutoPreco","Venda3ProdutoPreco",');
           SQL.Add('"Venda4ProdutoPreco","Venda5ProdutoPreco","CodigoItemProdutoPreco","CodigoInventarioItemProdutoPreco","PrecoSugestaoProdutoPreco",');
           SQL.Add('"Venda6ProdutoPreco","Venda7ProdutoPreco","Venda8ProdutoPreco","Venda9ProdutoPreco","Venda10ProdutoPreco",');
           SQL.Add('"CustoNotaProdutoPreco","CustoTabelaProdutoPreco","CustoUnitarioProdutoPreco","PrimeiroDescontoProdutoPreco",');
           SQL.Add('"SegundoDescontoProdutoPreco","TerceiroDescontoProdutoPreco","QuartoDescontoProdutoPreco","NomeTabelaProdutoPreco",');
           SQL.Add('"PercentualFreteProdutoPreco","PercentualICMSSubstituicaoProdutoPreco","CustoContabilMedioProdutoPreco",');
           SQL.Add('"ValorICMSProprioMedioProdutoPreco","ValorICMSSTMedioProdutoPreco","BaseICMSSTMedioProdutoPreco") ');
           SQL.Add('values (:xidempresa,:xidproduto,:xdata,:xcusto,');
           SQL.Add(':xcustocontabil,:xprecominimo,:xvenda1,:xvenda2,:xvenda3,');
           SQL.Add(':xvenda4,:xvenda5,(case when :xiditem>0 then :xiditem else null end),(case when :xidinventarioitem>0 then :xidinventarioitem else null end),:xprecosugestao,');
           SQL.Add(':xvenda6,:xvenda7,:xvenda8,:xvenda9,:xvenda10,');
           SQL.Add(':xcustonota,:xcustotabela,:xcustounitario,:xprimeirodesconto,');
           SQL.Add(':xsegundodesconto,:xterceirodesconto,:xquartodesconto,:xnometabela,');
           SQL.Add(':xpercentualfrete,:xpercentualicmsst,:xcustocontabilmedio,');
           SQL.Add(':xvaloricmspropriomedio,:xvaloricmsstmedio,:xbaseicmsstmedio) ');
           ParamByName('xidempresa').AsInteger    := wconexao.FIdEmpresa;
           ParamByName('xidproduto').AsInteger    := XIdProduto;
           if XPreco.TryGetValue('data',wval) then
              ParamByName('xdata').AsDate := strtodatedef(XPreco.GetValue('data').Value,date)
           else
              ParamByName('xdata').AsDate := date;
           if XPreco.TryGetValue('custo',wval) then
              ParamByName('xcusto').AsFloat := strtofloatdef(XPreco.GetValue('custo').Value,0)
           else
              ParamByName('xcusto').AsFloat := 0;
           if XPreco.TryGetValue('custocontabil',wval) then
              ParamByName('xcustocontabil').AsFloat := strtofloatdef(XPreco.GetValue('custocontabil').Value,0)
           else
              ParamByName('xcustocontabil').AsFloat := 0;
           if XPreco.TryGetValue('precominimo',wval) then
              ParamByName('xprecominimo').AsFloat := strtofloatdef(XPreco.GetValue('precominimo').Value,0)
           else
              ParamByName('xprecominimo').AsFloat := 0;
           if XPreco.TryGetValue('venda1',wval) then
              ParamByName('xvenda1').AsFloat := strtofloatdef(XPreco.GetValue('venda1').Value,0)
           else
              ParamByName('xvenda1').AsFloat := 0;
           if XPreco.TryGetValue('venda2',wval) then
              ParamByName('xvenda2').AsFloat := strtofloatdef(XPreco.GetValue('venda2').Value,0)
           else
              ParamByName('xvenda2').AsFloat := 0;
           if XPreco.TryGetValue('venda3',wval) then
              ParamByName('xvenda3').AsFloat := strtofloatdef(XPreco.GetValue('venda3').Value,0)
           else
              ParamByName('xvenda3').AsFloat := 0;
           if XPreco.TryGetValue('venda4',wval) then
              ParamByName('xvenda4').AsFloat := strtofloatdef(XPreco.GetValue('venda4').Value,0)
           else
              ParamByName('xvenda4').AsFloat := 0;
           if XPreco.TryGetValue('venda5',wval) then
              ParamByName('xvenda5').AsFloat := strtofloatdef(XPreco.GetValue('venda5').Value,0)
           else
              ParamByName('xvenda5').AsFloat := 0;
           if XPreco.TryGetValue('iditem',wval) then
              ParamByName('xiditem').AsInteger := strtointdef(XPreco.GetValue('iditem').Value,0)
           else
              ParamByName('xiditem').AsInteger := 0;
           if XPreco.TryGetValue('idinventarioitem',wval) then
              ParamByName('xidinventarioitem').AsInteger := strtointdef(XPreco.GetValue('idinventarioitem').Value,0)
           else
              ParamByName('xidinventarioitem').AsInteger := 0;
           if XPreco.TryGetValue('precosugestao',wval) then
              ParamByName('xprecosugestao').AsFloat := strtofloatdef(XPreco.GetValue('precosugestao').Value,0)
           else
              ParamByName('xprecosugestao').AsFloat := 0;
           if XPreco.TryGetValue('venda6',wval) then
              ParamByName('xvenda6').AsFloat := strtofloatdef(XPreco.GetValue('venda6').Value,0)
           else
              ParamByName('xvenda6').AsFloat := 0;
           if XPreco.TryGetValue('venda7',wval) then
              ParamByName('xvenda7').AsFloat := strtofloatdef(XPreco.GetValue('venda7').Value,0)
           else
              ParamByName('xvenda7').AsFloat := 0;
           if XPreco.TryGetValue('venda8',wval) then
              ParamByName('xvenda8').AsFloat := strtofloatdef(XPreco.GetValue('venda8').Value,0)
           else
              ParamByName('xvenda8').AsFloat := 0;
           if XPreco.TryGetValue('venda9',wval) then
              ParamByName('xvenda9').AsFloat := strtofloatdef(XPreco.GetValue('venda9').Value,0)
           else
              ParamByName('xvenda9').AsFloat := 0;
           if XPreco.TryGetValue('venda10',wval) then
              ParamByName('xvenda10').AsFloat := strtofloatdef(XPreco.GetValue('venda10').Value,0)
           else
              ParamByName('xvenda10').AsFloat := 0;
           if XPreco.TryGetValue('custonota',wval) then
              ParamByName('xcustonota').AsFloat := strtofloatdef(XPreco.GetValue('custonota').Value,0)
           else
              ParamByName('xcustonota').AsFloat := 0;
           if XPreco.TryGetValue('custotabela',wval) then
              ParamByName('xcustotabela').AsFloat := strtofloatdef(XPreco.GetValue('custotabela').Value,0)
           else
              ParamByName('xcustotabela').AsFloat := 0;
           if XPreco.TryGetValue('custounitario',wval) then
              ParamByName('xcustounitario').AsFloat := strtofloatdef(XPreco.GetValue('custounitario').Value,0)
           else
              ParamByName('xcustounitario').AsFloat := 0;
           if XPreco.TryGetValue('primeirodesconto',wval) then
              ParamByName('xprimeirodesconto').AsFloat := strtofloatdef(XPreco.GetValue('primeirodesconto').Value,0)
           else
              ParamByName('xprimeirodesconto').AsFloat := 0;
           if XPreco.TryGetValue('segundodesconto',wval) then
              ParamByName('xsegundodesconto').AsFloat := strtofloatdef(XPreco.GetValue('segundodesconto').Value,0)
           else
              ParamByName('xsegundodesconto').AsFloat := 0;
           if XPreco.TryGetValue('terceirodesconto',wval) then
              ParamByName('xterceirodesconto').AsFloat := strtofloatdef(XPreco.GetValue('terceirodesconto').Value,0)
           else
              ParamByName('xterceirodesconto').AsFloat := 0;
           if XPreco.TryGetValue('quartodesconto',wval) then
              ParamByName('xquartodesconto').AsFloat := strtofloatdef(XPreco.GetValue('quartodesconto').Value,0)
           else
              ParamByName('xquartodesconto').AsFloat := 0;
           if XPreco.TryGetValue('nometabela',wval) then
              ParamByName('xnometabela').AsString := XPreco.GetValue('nometabela').Value
           else
              ParamByName('xnometabela').AsString := '';
           if XPreco.TryGetValue('percentualfrete',wval) then
              ParamByName('xpercentualfrete').AsFloat := strtofloatdef(XPreco.GetValue('percentualfrete').Value,0)
           else
              ParamByName('xpercentualfrete').AsFloat := 0;
           if XPreco.TryGetValue('percentualicmsst',wval) then
              ParamByName('xpercentualicmsst').AsFloat := strtofloatdef(XPreco.GetValue('percentualicmsst').Value,0)
           else
              ParamByName('xpercentualicmsst').AsFloat := 0;
           if XPreco.TryGetValue('custocontabilmedio',wval) then
              ParamByName('xcustocontabilmedio').AsFloat := strtofloatdef(XPreco.GetValue('custocontabilmedio').Value,0)
           else
              ParamByName('xcustocontabilmedio').AsFloat := 0;
           if XPreco.TryGetValue('valoricmspropriomedio',wval) then
              ParamByName('xvaloricmspropriomedio').AsFloat := strtofloatdef(XPreco.GetValue('valoricmspropriomedio').Value,0)
           else
              ParamByName('xvaloricmspropriomedio').AsFloat := 0;
           if XPreco.TryGetValue('valoricmsstmedio',wval) then
              ParamByName('xvaloricmsstmedio').AsFloat := strtofloatdef(XPreco.GetValue('valoricmsstmedio').Value,0)
           else
              ParamByName('xvaloricmsstmedio').AsFloat := 0;
           if XPreco.TryGetValue('baseicmsstmedio',wval) then
              ParamByName('xbaseicmsstmedio').AsFloat := strtofloatdef(XPreco.GetValue('baseicmsstmedio').Value,0)
           else
              ParamByName('xbaseicmsstmedio').AsFloat := 0;
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
                SQL.Add('select  "CodigoInternoProdutoPreco"         as id,');
                SQL.Add('        "CodigoEmpresaProdutoPreco"         as idempresa,');
                SQL.Add('        "CodigoProdutoPreco"                as idproduto,');
                SQL.Add('        "DataProdutoPreco"                  as data,');
                SQL.Add('        "CustoProdutoPreco"                 as custo,');
                SQL.Add('        "CustoContabilProdutoPreco"         as custocontabil,');
                SQL.Add('        "PrecoMinimoProdutoPreco"           as precominimo,');
                SQL.Add('        "Venda1ProdutoPreco"                as venda1,');
                SQL.Add('        "Venda2ProdutoPreco"                as venda2,');
                SQL.Add('        "Venda3ProdutoPreco"                as venda3,');
                SQL.Add('        "Venda4ProdutoPreco"                as venda4,');
                SQL.Add('        "Venda5ProdutoPreco"                as venda5,');
                SQL.Add('        "CodigoItemProdutoPreco"            as iditem,');
                SQL.Add('        "CodigoInventarioItemProdutoPreco"  as idinventarioitem,');
                SQL.Add('        "PrecoSugestaoProdutoPreco"         as precosugestao,');
                SQL.Add('        "Venda6ProdutoPreco"                as venda6,');
                SQL.Add('        "Venda7ProdutoPreco"                as venda7,');
                SQL.Add('        "Venda8ProdutoPreco"                as venda8,');
                SQL.Add('        "Venda9ProdutoPreco"                as venda9,');
                SQL.Add('        "Venda10ProdutoPreco"               as venda10,');
                SQL.Add('        "CustoNotaProdutoPreco"             as custonota,');
                SQL.Add('        "CustoTabelaProdutoPreco"           as custotabela,');
                SQL.Add('        "CustoUnitarioProdutoPreco"         as custounitario,');
                SQL.Add('        "PrimeiroDescontoProdutoPreco"      as primeirodesconto,');
                SQL.Add('        "SegundoDescontoProdutoPreco"       as segundodesconto,');
                SQL.Add('        "TerceiroDescontoProdutoPreco"      as terceirodesconto,');
                SQL.Add('        "QuartoDescontoProdutoPreco"        as quartodesconto,');
                SQL.Add('        "NomeTabelaProdutoPreco"            as nometabela,');
                SQL.Add('        "PercentualFreteProdutoPreco"       as percentualfrete,');
                SQL.Add('        "PercentualICMSSubstituicaoProdutoPreco" as percentualicmsst,');
                SQL.Add('        "CustoContabilMedioProdutoPreco"    as custocontabilmedio,');
                SQL.Add('        "ValorICMSProprioMedioProdutoPreco" as valoricmspropriomedio,');
                SQL.Add('        "ValorICMSSTMedioProdutoPreco"      as valoricmsstmedio,');
                SQL.Add('        "BaseICMSSTMedioProdutoPreco"       as baseicmsstmedio ');
                SQL.Add('from "ProdutoPreco" where "CodigoProdutoPreco"=:xidproduto and "DataProdutoPreco"=:xdata ');
                ParamByName('xidproduto').AsInteger     := XIdProduto;
                if XPreco.TryGetValue('data',wval) then
                   ParamByName('xdata').AsDate := strtodatedef(XPreco.GetValue('data').Value,date)
                else
                   ParamByName('xdata').AsDate := date;
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Produto Preço incluído');
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

function AlteraPreco(XIdPreco: integer; XPreco: TJSONObject): TJSONObject;
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
    if XPreco.TryGetValue('data',wval) then
       begin
         if wcampos='' then
            wcampos := '"DataProdutoPreco"=:xdata'
         else
            wcampos := wcampos+',"DataProdutoPreco"=:xdata';
       end;
    if XPreco.TryGetValue('custo',wval) then
       begin
         if wcampos='' then
            wcampos := '"CustoProdutoPreco"=:xcusto'
         else
            wcampos := wcampos+',"CustoProdutoPreco"=:xcusto';
       end;
    if XPreco.TryGetValue('custocontabil',wval) then
       begin
         if wcampos='' then
            wcampos := '"CustoContabilProdutoPreco"=:xcustocontabil'
         else
            wcampos := wcampos+',"CustoContabilProdutoPreco"=:xcustocontabil';
       end;
    if XPreco.TryGetValue('precominimo',wval) then
       begin
         if wcampos='' then
            wcampos := '"PrecoMinimoProdutoPreco"=:xcusto'
         else
            wcampos := wcampos+',"PrecoMinimoProdutoPreco"=:xcusto';
       end;
    if XPreco.TryGetValue('venda1',wval) then
       begin
         if wcampos='' then
            wcampos := '"Venda1ProdutoPreco"=:xvenda1'
         else
            wcampos := wcampos+',"Venda1ProdutoPreco"=:xvenda1';
       end;
    if XPreco.TryGetValue('venda2',wval) then
       begin
         if wcampos='' then
            wcampos := '"Venda2ProdutoPreco"=:xvenda2'
         else
            wcampos := wcampos+',"Venda2ProdutoPreco"=:xvenda2';
       end;
    if XPreco.TryGetValue('venda3',wval) then
       begin
         if wcampos='' then
            wcampos := '"Venda3ProdutoPreco"=:xvenda3'
         else
            wcampos := wcampos+',"Venda3ProdutoPreco"=:xvenda3';
       end;
    if XPreco.TryGetValue('venda4',wval) then
       begin
         if wcampos='' then
            wcampos := '"Venda4ProdutoPreco"=:xvenda4'
         else
            wcampos := wcampos+',"Venda4ProdutoPreco"=:xvenda4';
       end;
    if XPreco.TryGetValue('venda5',wval) then
       begin
         if wcampos='' then
            wcampos := '"Venda5ProdutoPreco"=:xvenda5'
         else
            wcampos := wcampos+',"Venda5ProdutoPreco"=:xvenda5';
       end;
    if XPreco.TryGetValue('iditem',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoItemProdutoPreco"=:xiditem'
         else
            wcampos := wcampos+',"CodigoItemProdutoPreco"=:xiditem';
       end;
    if XPreco.TryGetValue('idinventarioitem',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoInventarioItemProdutoPreco"=:xidinventarioitem'
         else
            wcampos := wcampos+',"CodigoInventarioItemProdutoPreco"=:xidinventarioitem';
       end;
    if XPreco.TryGetValue('precosugestao',wval) then
       begin
         if wcampos='' then
            wcampos := '"PrecoSugestaoProdutoPreco"=:xprecosugestao'
         else
            wcampos := wcampos+',"PrecoSugestaoProdutoPreco"=:xprecosugestao';
       end;
    if XPreco.TryGetValue('venda6',wval) then
       begin
         if wcampos='' then
            wcampos := '"Venda6ProdutoPreco"=:xvenda6'
         else
            wcampos := wcampos+',"Venda6ProdutoPreco"=:xvenda6';
       end;
    if XPreco.TryGetValue('venda7',wval) then
       begin
         if wcampos='' then
            wcampos := '"Venda7ProdutoPreco"=:xvenda7'
         else
            wcampos := wcampos+',"Venda7ProdutoPreco"=:xvenda7';
       end;
    if XPreco.TryGetValue('venda8',wval) then
       begin
         if wcampos='' then
            wcampos := '"Venda8ProdutoPreco"=:xvenda8'
         else
            wcampos := wcampos+',"Venda8ProdutoPreco"=:xvenda8';
       end;
    if XPreco.TryGetValue('venda9',wval) then
       begin
         if wcampos='' then
            wcampos := '"Venda9ProdutoPreco"=:xvenda9'
         else
            wcampos := wcampos+',"Venda9ProdutoPreco"=:xvenda9';
       end;
    if XPreco.TryGetValue('venda10',wval) then
       begin
         if wcampos='' then
            wcampos := '"Venda10ProdutoPreco"=:xvenda10'
         else
            wcampos := wcampos+',"Venda10ProdutoPreco"=:xvenda10';
       end;
    if XPreco.TryGetValue('custonota',wval) then
       begin
         if wcampos='' then
            wcampos := '"CustoNotaProdutoPreco"=:xcustonota'
         else
            wcampos := wcampos+',"CustoNotaProdutoPreco"=:xcustonota';
       end;
    if XPreco.TryGetValue('custotabela',wval) then
       begin
         if wcampos='' then
            wcampos := '"CustoTabelaProdutoPreco"=:xcustotabela'
         else
            wcampos := wcampos+',"CustoTabelaProdutoPreco"=:xcustotabela';
       end;
    if XPreco.TryGetValue('custounitario',wval) then
       begin
         if wcampos='' then
            wcampos := '"CustoUnitarioProdutoPreco"=:xcustounitario'
         else
            wcampos := wcampos+',"CustoUnitarioProdutoPreco"=:xcustounitario';
       end;
    if XPreco.TryGetValue('primeirodesconto',wval) then
       begin
         if wcampos='' then
            wcampos := '"PrimeiroDescontoProdutoPreco"=:xprimeirodesconto'
         else
            wcampos := wcampos+',"PrimeiroDescontoProdutoPreco"=:xprimeirodesconto';
       end;
    if XPreco.TryGetValue('segundodesconto',wval) then
       begin
         if wcampos='' then
            wcampos := '"SegundoDescontoProdutoPreco"=:xsegundodesconto'
         else
            wcampos := wcampos+',"SegundoDescontoProdutoPreco"=:xsegundodesconto';
       end;
    if XPreco.TryGetValue('terceirodesconto',wval) then
       begin
         if wcampos='' then
            wcampos := '"TerceiroDescontoProdutoPreco"=:xterceirodesconto'
         else
            wcampos := wcampos+',"TerceiroDescontoProdutoPreco"=:xterceirodesconto';
       end;
    if XPreco.TryGetValue('quartodesconto',wval) then
       begin
         if wcampos='' then
            wcampos := '"QuartoDescontoProdutoPreco"=:xquartodesconto'
         else
            wcampos := wcampos+',"QuartoDescontoProdutoPreco"=:xquartodesconto';
       end;
    if XPreco.TryGetValue('nometabela',wval) then
       begin
         if wcampos='' then
            wcampos := '"NomeTabelaProdutoPreco"=:xnometabela'
         else
            wcampos := wcampos+',"NomeTabelaProdutoPreco"=:xnometabela';
       end;
    if XPreco.TryGetValue('percentualfrete',wval) then
       begin
         if wcampos='' then
            wcampos := '"PercentualFreteProdutoPreco"=:xpercentualfrete'
         else
            wcampos := wcampos+',"PercentualFreteProdutoPreco"=:xpercentualfrete';
       end;
    if XPreco.TryGetValue('percentualicmsst',wval) then
       begin
         if wcampos='' then
            wcampos := '"PercentualICMSSubstituicaoProdutoPreco"=:xpercentualicmsst'
         else
            wcampos := wcampos+',"PercentualICMSSubstituicaoProdutoPreco"=:xpercentualicmsst';
       end;
    if XPreco.TryGetValue('custocontabilmedio',wval) then
       begin
         if wcampos='' then
            wcampos := '"CustoContabilMedioProdutoPreco"=:xcustocontabilmedio'
         else
            wcampos := wcampos+',"CustoContabilMedioProdutoPreco"=:xcustocontabilmedio';
       end;
    if XPreco.TryGetValue('valoricmspropriomedio',wval) then
       begin
         if wcampos='' then
            wcampos := '"ValorICMSProprioMedioProdutoPreco"=:xvaloricmspropriomedio'
         else
            wcampos := wcampos+',"ValorICMSProprioMedioProdutoPreco"=:xvaloricmspropriomedio';
       end;
    if XPreco.TryGetValue('valoricmsstmedio',wval) then
       begin
         if wcampos='' then
            wcampos := '"ValorICMSSTMedioProdutoPreco"=:xvaloricmsstmedio'
         else
            wcampos := wcampos+',"ValorICMSSTMedioProdutoPreco"=:xvaloricmsstmedio';
       end;
    if XPreco.TryGetValue('baseicmsstmedio',wval) then
       begin
         if wcampos='' then
            wcampos := '"BaseICMSSTMedioProdutoPreco"=:xbaseicmsstmedio'
         else
            wcampos := wcampos+',"BaseICMSSTMedioProdutoPreco"=:xbaseicmsstmedio';
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
           SQL.Add('Update "ProdutoPreco" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoProdutoPreco"=:xid ');
           ParamByName('xid').AsInteger       := XIdPreco;
           if XPreco.TryGetValue('data',wval) then
              ParamByName('xdata').AsDate     := strtodatedef(XPreco.GetValue('data').Value,date);
           if XPreco.TryGetValue('custo',wval) then
              ParamByName('xcusto').AsFloat   := strtofloatdef(XPreco.GetValue('custo').Value,0);
           if XPreco.TryGetValue('custocontabil',wval) then
              ParamByName('xcustocontabil').AsFloat := strtofloatdef(XPreco.GetValue('custocontabil').Value,0);
           if XPreco.TryGetValue('precominimo',wval) then
              ParamByName('xprecominimo').AsFloat   := strtofloatdef(XPreco.GetValue('precominimo').Value,0);
           if XPreco.TryGetValue('venda1',wval) then
              ParamByName('xvenda1').AsFloat        := strtofloatdef(XPreco.GetValue('venda1').Value,0);
           if XPreco.TryGetValue('venda2',wval) then
              ParamByName('xvenda2').AsFloat        := strtofloatdef(XPreco.GetValue('venda2').Value,0);
           if XPreco.TryGetValue('venda3',wval) then
              ParamByName('xvenda3').AsFloat        := strtofloatdef(XPreco.GetValue('venda3').Value,0);
           if XPreco.TryGetValue('venda4',wval) then
              ParamByName('xvenda4').AsFloat        := strtofloatdef(XPreco.GetValue('venda4').Value,0);
           if XPreco.TryGetValue('venda5',wval) then
              ParamByName('xvenda5').AsFloat        := strtofloatdef(XPreco.GetValue('venda5').Value,0);
           if XPreco.TryGetValue('iditem',wval) then
              ParamByName('xiditem').AsInteger      := strtointdef(XPreco.GetValue('iditem').Value,0);
           if XPreco.TryGetValue('idinventarioitem',wval) then
              ParamByName('xidinventarioitem').AsInteger := strtointdef(XPreco.GetValue('idinventarioitem').Value,0);
           if XPreco.TryGetValue('precosugestao',wval) then
              ParamByName('xprecosugestao').AsFloat := strtofloatdef(XPreco.GetValue('precosugestao').Value,0);
           if XPreco.TryGetValue('venda6',wval) then
              ParamByName('xvenda6').AsFloat        := strtofloatdef(XPreco.GetValue('venda6').Value,0);
           if XPreco.TryGetValue('venda7',wval) then
              ParamByName('xvenda7').AsFloat        := strtofloatdef(XPreco.GetValue('venda7').Value,0);
           if XPreco.TryGetValue('venda8',wval) then
              ParamByName('xvenda8').AsFloat        := strtofloatdef(XPreco.GetValue('venda8').Value,0);
           if XPreco.TryGetValue('venda9',wval) then
              ParamByName('xvenda9').AsFloat        := strtofloatdef(XPreco.GetValue('venda9').Value,0);
           if XPreco.TryGetValue('venda10',wval) then
              ParamByName('xvenda10').AsFloat       := strtofloatdef(XPreco.GetValue('venda10').Value,0);
           if XPreco.TryGetValue('custonota',wval) then
              ParamByName('xcustonota').AsFloat     := strtofloatdef(XPreco.GetValue('custonota').Value,0);
           if XPreco.TryGetValue('custotabela',wval) then
              ParamByName('xcustotabela').AsFloat   := strtofloatdef(XPreco.GetValue('custotabela').Value,0);
           if XPreco.TryGetValue('custounitario',wval) then
              ParamByName('xcustounitario').AsFloat := strtofloatdef(XPreco.GetValue('custounitario').Value,0);
           if XPreco.TryGetValue('primeirodesconto',wval) then
              ParamByName('xprimeirodesconto').AsFloat := strtofloatdef(XPreco.GetValue('primeirodesconto').Value,0);
           if XPreco.TryGetValue('segundodesconto',wval) then
              ParamByName('xsegundodesconto').AsFloat  := strtofloatdef(XPreco.GetValue('segundodesconto').Value,0);
           if XPreco.TryGetValue('terceirodesconto',wval) then
              ParamByName('xterceirodesconto').AsFloat := strtofloatdef(XPreco.GetValue('terceirodesconto').Value,0);
           if XPreco.TryGetValue('quartodesconto',wval) then
              ParamByName('xquartodesconto').AsFloat := strtofloatdef(XPreco.GetValue('quartodesconto').Value,0);
           if XPreco.TryGetValue('nometabela',wval) then
              ParamByName('xnometabela').AsString    := XPreco.GetValue('nometabela').Value;
           if XPreco.TryGetValue('percentualfrete',wval) then
              ParamByName('xpercentualfrete').AsFloat := strtofloatdef(XPreco.GetValue('percentualfrete').Value,0);
           if XPreco.TryGetValue('percentualicmsst',wval) then
              ParamByName('xpercentualicmsst').AsFloat := strtofloatdef(XPreco.GetValue('percentualicmsst').Value,0);
           if XPreco.TryGetValue('custocontabilmedio',wval) then
              ParamByName('xcustocontabilmedio').AsFloat := strtofloatdef(XPreco.GetValue('custocontabilmedio').Value,0);
           if XPreco.TryGetValue('valoricmspropriomedio',wval) then
              ParamByName('xvaloricmspropriomedio').AsFloat := strtofloatdef(XPreco.GetValue('valoricmspropriomedio').Value,0);
           if XPreco.TryGetValue('valoricmsstmedio',wval) then
              ParamByName('xvaloricmsstmedio').AsFloat := strtofloatdef(XPreco.GetValue('valoricmsstmedio').Value,0);
           if XPreco.TryGetValue('baseicmsstmedio',wval) then
              ParamByName('xbaseicmsstmedio').AsFloat := strtofloatdef(XPreco.GetValue('baseicmsstmedio').Value,0);
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
              SQL.Add('select  "CodigoInternoProdutoPreco"         as id,');
              SQL.Add('        "CodigoEmpresaProdutoPreco"         as idempresa,');
              SQL.Add('        "CodigoProdutoPreco"                as idproduto,');
              SQL.Add('        "DataProdutoPreco"                  as data,');
              SQL.Add('        "CustoProdutoPreco"                 as custo,');
              SQL.Add('        "CustoContabilProdutoPreco"         as custocontabil,');
              SQL.Add('        "PrecoMinimoProdutoPreco"           as precominimo,');
              SQL.Add('        "Venda1ProdutoPreco"                as venda1,');
              SQL.Add('        "Venda2ProdutoPreco"                as venda2,');
              SQL.Add('        "Venda3ProdutoPreco"                as venda3,');
              SQL.Add('        "Venda4ProdutoPreco"                as venda4,');
              SQL.Add('        "Venda5ProdutoPreco"                as venda5,');
              SQL.Add('        "CodigoItemProdutoPreco"            as iditem,');
              SQL.Add('        "CodigoInventarioItemProdutoPreco"  as idinventarioitem,');
              SQL.Add('        "PrecoSugestaoProdutoPreco"         as precosugestao,');
              SQL.Add('        "Venda6ProdutoPreco"                as venda6,');
              SQL.Add('        "Venda7ProdutoPreco"                as venda7,');
              SQL.Add('        "Venda8ProdutoPreco"                as venda8,');
              SQL.Add('        "Venda9ProdutoPreco"                as venda9,');
              SQL.Add('        "Venda10ProdutoPreco"               as venda10,');
              SQL.Add('        "CustoNotaProdutoPreco"             as custonota,');
              SQL.Add('        "CustoTabelaProdutoPreco"           as custotabela,');
              SQL.Add('        "CustoUnitarioProdutoPreco"         as custounitario,');
              SQL.Add('        "PrimeiroDescontoProdutoPreco"      as primeirodesconto,');
              SQL.Add('        "SegundoDescontoProdutoPreco"       as segundodesconto,');
              SQL.Add('        "TerceiroDescontoProdutoPreco"      as terceirodesconto,');
              SQL.Add('        "QuartoDescontoProdutoPreco"        as quartodesconto,');
              SQL.Add('        "NomeTabelaProdutoPreco"            as nometabela,');
              SQL.Add('        "PercentualFreteProdutoPreco"       as percentualfrete,');
              SQL.Add('        "PercentualICMSSubstituicaoProdutoPreco" as percentualicmsst,');
              SQL.Add('        "CustoContabilMedioProdutoPreco"    as custocontabilmedio,');
              SQL.Add('        "ValorICMSProprioMedioProdutoPreco" as valoricmspropriomedio,');
              SQL.Add('        "ValorICMSSTMedioProdutoPreco"      as valoricmsstmedio,');
              SQL.Add('        "BaseICMSSTMedioProdutoPreco"       as baseicmsstmedio ');
              SQL.Add('from "ProdutoPreco" ');
              SQL.Add('where "CodigoInternoProdutoPreco" =:xid ');
              ParamByName('xid').AsInteger := XIdPreco;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Produto Preço alterado');
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

function VerificaRequisicao(XPreco: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
//    if not XPreco.TryGetValue('idfornecedor',wval) then
//       wret := false;
  finally
  end;
  Result := wret;
end;

function ApagaPreco(XIdPreco: integer): TJSONObject;
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
         SQL.Add('delete from "ProdutoPreco" where "CodigoInternoProdutoPreco"=:xid ');
         ParamByName('xid').AsInteger := XIdPreco;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Produto Preço excluído com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhum Produto Preço excluído');
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
