unit dat.movOrcamentos;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function ApagaOrcamento(XId: integer): TJSONObject;
function RetornaOrcamento(XId: integer): TJSONObject;
function RetornaListaOrcamentos(const XQuery: TDictionary<string, string>; XEmpresa,XLimit,XOffset: integer): TJSONArray;
function RetornaTotalOrcamentos(const XQuery: TDictionary<string, string>): TJSONObject;
function AlteraOrcamento(XIdOrcamento: integer; XOrcamento: TJSONObject): TJSONObject;
function VerificaRequisicao(XOrcamento: TJSONObject): boolean;
function IncluiOrcamento(XOrcamento: TJSONObject; XIdEmpresa: integer): TJSONObject;
function RetornaIdOrcamento(XFDConnection: TFDConnection): integer;
function RetornaNumeroPedido(XFDConnection: TFDConnection; XIdEmpresa: integer): integer;
function RetornaCondicaoBloqueada(XFDConnection: TFDConnection; XIdCondicao: integer): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaOrcamento(XId: integer): TJSONObject;
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
         SQL.Add('select "CodigoInternoOrcamento"         as id,');
         SQL.Add('       "CodigoEmpresaOrcamento"         as idempresa,');
         SQL.Add('       "NumeroOrcamento"                as numero,');
         SQL.Add('       "CodigoClienteOrcamento"         as idcliente,');
         SQL.Add('       ts_retornapessoanome("CodigoClienteOrcamento") as xcliente, ');
         SQL.Add('       "CodigoRepresentanteOrcamento"   as idvendedor,');
         SQL.Add('       ts_retornapessoanome("CodigoRepresentanteOrcamento") as xvendedor, ');
         SQL.Add('       "CodigoTransporteOrcamento"      as idtransportador,');
         SQL.Add('       ts_retornapessoanome("CodigoTransporteOrcamento") as xtransportador, ');
         SQL.Add('       "CodigoCondicaoOrcamento"        as idcondicao,');
         SQL.Add('       ts_retornacondicaodescricao("CodigoCondicaoOrcamento") as xcondicao, ');
         SQL.Add('       "DocumentoCobrancaOrcamento"     as idcobranca,');
         SQL.Add('       ts_retornadocumentocobrancadescricao("DocumentoCobrancaOrcamento") as xcobranca, ');
         SQL.Add('       ts_retornacondicaopreco("CodigoCondicaoOrcamento") as xprecocondicao, ');
         SQL.Add('       ts_retornacondicaocodigofiscal("CodigoCondicaoOrcamento") as xidcfopcondicao,');
         SQL.Add('       ts_retornacondicaocodigofiscalst("CodigoCondicaoOrcamento") as xidcfopstcondicao,');
         SQL.Add('       ts_retornafiscalcodigo(ts_retornacondicaocodigofiscal("CodigoCondicaoOrcamento")) as xcfopcondicao,');
         SQL.Add('       ts_retornafiscalcodigo(ts_retornacondicaocodigofiscalst("CodigoCondicaoOrcamento")) as xcfopstcondicao,');
         SQL.Add('       (case when ts_retornacondicaotipper("CodigoCondicaoOrcamento")=''D'' then ts_retornacondicaopercentual("CodigoCondicaoOrcamento") else 0 end) as xdesccondicao,');
         SQL.Add('       (case when ts_retornacondicaotipper("CodigoCondicaoOrcamento")=''A'' then ts_retornacondicaopercentual("CodigoCondicaoOrcamento") else 0 end) as xacrescccondicao,');
         SQL.Add('       "DataEmissaoOrcamento"           as dataemissao,');
         SQL.Add('       "DataValidadeOrcamento"          as datavalidade,');
         SQL.Add('       "TotalOrcamento"                 as total,');
         SQL.Add('       "TotalLiquidoOrcamento"          as subtotal,');
         SQL.Add('       "BaseICMSOrcamento"              as baseicms,');
         SQL.Add('       "TotalICMSOrcamento"             as totalicms,');
         SQL.Add('       "BaseICMSSubstituicaoOrcamento"  as basest,');
         SQL.Add('       "TotalICMSSubstituicaoOrcamento" as totalst,');
         SQL.Add('       "HoraOrcamento"                  as hora,');
         SQL.Add('       "TotalPISOrcamento"              as totalpis,');
         SQL.Add('       "TotalCOFINSOrcamento"           as totalcofins,');
         SQL.Add('       "PercentualDescontoOrcamento"    as percentualdesconto,');
         SQL.Add('       "TotalDescontoOrcamento"         as totaldesconto,');
         SQL.Add('       "TotalDespesaOrcamento"          as totaldespesa,');
         SQL.Add('       "ObservacaoOrcamento"            as observacao,');
         SQL.Add('       "PrecoUtilizadoOrcamento"        as precoutilizado,');
         SQL.Add('       "NumeroParcelasOrcamento"        as numeroparcelas,');
         SQL.Add('       "ValorEntradaOrcamento"          as valorentrada,');
         SQL.Add('       "OrigemPedidoOrcamento"          as origem,');
         SQL.Add('       "ValorFreteOrcamento"            as valorfrete,');
         SQL.Add('       "SituacaoFreteOrcamento"         as situacaofrete,');
         SQL.Add('       "FinalizadoOrcamento"            as finalizado,');
         SQL.Add('       "BloqueadoOrcamento"             as bloqueado,');
         SQL.Add('       "NotaGeradaOrcamento"            as idnotagerada,');
         SQL.Add('       (select "NotaFiscal"."NumeroDocumentoNota" From "NotaFiscal" where "NotaFiscal"."CodigoInternoNota"="NotaGeradaOrcamento") as xdocumentonota,');
         SQL.Add('       (select "NotaFiscal"."DataEmissaoNota"     From "NotaFiscal" where "NotaFiscal"."CodigoInternoNota"="NotaGeradaOrcamento") as xemissaonota,');
         SQL.Add('       "MaquinaOrigemOrcamento"         as maquinaorigem ');
         SQL.Add('from "Orcamento" where "CodigoInternoOrcamento"=:xid  ');
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
        wret.AddPair('description','Orçamento não encontrado');
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

function ApagaOrcamento(XId: integer): TJSONObject;
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
         SQL.Add('delete from "Orcamento" ');
         SQL.Add('where "CodigoInternoOrcamento"=:xid ');
         ParamByName('xid').AsInteger := XId;
         ExecSQL;
         EnableControls;
       end;

   if wquery.RowsAffected > 0 then
      begin
        wret := TJSONObject.Create;
        wret.AddPair('status','200');
        wret.AddPair('description','Orçamento excluído com sucesso');
        wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
      end
   else
      begin
        wret := TJSONObject.Create;
        wret.AddPair('status','500');
        wret.AddPair('description','Nenhuma pedido excluído');
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


function RetornaListaOrcamentos(const XQuery: TDictionary<string, string>; XEmpresa,XLimit,XOffset: integer): TJSONArray;
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
         SQL.Add('select "CodigoInternoOrcamento"         as id,');
         SQL.Add('       "CodigoEmpresaOrcamento"         as idempresa,');
         SQL.Add('       "NumeroOrcamento"                as numero,');
         SQL.Add('       "CodigoClienteOrcamento"         as idcliente,');
         SQL.Add('       ts_retornapessoanome("CodigoClienteOrcamento") as xcliente, ');
         SQL.Add('       "CodigoRepresentanteOrcamento"   as idvendedor,');
         SQL.Add('       ts_retornapessoanome("CodigoRepresentanteOrcamento") as xvendedor, ');
         SQL.Add('       "CodigoTransporteOrcamento"      as idtransportador,');
         SQL.Add('       ts_retornapessoanome("CodigoTransporteOrcamento") as xtransportador, ');
         SQL.Add('       "CodigoCondicaoOrcamento"        as idcondicao,');
         SQL.Add('       ts_retornacondicaodescricao("CodigoCondicaoOrcamento") as xcondicao, ');
         SQL.Add('       "DocumentoCobrancaOrcamento"     as idcobranca,');
         SQL.Add('       ts_retornadocumentocobrancadescricao("DocumentoCobrancaOrcamento") as xcobranca, ');
         SQL.Add('       ts_retornacondicaopreco("CodigoCondicaoOrcamento") as xprecocondicao, ');
         SQL.Add('       ts_retornacondicaocodigofiscal("CodigoCondicaoOrcamento") as xidcfopcondicao,');
         SQL.Add('       ts_retornacondicaocodigofiscalst("CodigoCondicaoOrcamento") as xidcfopstcondicao,');
         SQL.Add('       ts_retornafiscalcodigo(ts_retornacondicaocodigofiscal("CodigoCondicaoOrcamento")) as xcfopcondicao,');
         SQL.Add('       ts_retornafiscalcodigo(ts_retornacondicaocodigofiscalst("CodigoCondicaoOrcamento")) as xcfopstcondicao,');
         SQL.Add('       (case when ts_retornacondicaotipper("CodigoCondicaoOrcamento")=''D'' then ts_retornacondicaopercentual("CodigoCondicaoOrcamento") else 0 end) as xdesccondicao,');
         SQL.Add('       (case when ts_retornacondicaotipper("CodigoCondicaoOrcamento")=''A'' then ts_retornacondicaopercentual("CodigoCondicaoOrcamento") else 0 end) as xacrescccondicao,');
         SQL.Add('       "DataEmissaoOrcamento"           as dataemissao,');
         SQL.Add('       "DataValidadeOrcamento"          as datavalidade,');
         SQL.Add('       "TotalOrcamento"                 as total,');
         SQL.Add('       "TotalLiquidoOrcamento"          as subtotal,');
         SQL.Add('       "BaseICMSOrcamento"              as baseicms,');
         SQL.Add('       "TotalICMSOrcamento"             as totalicms,');
         SQL.Add('       "BaseICMSSubstituicaoOrcamento"  as basest,');
         SQL.Add('       "TotalICMSSubstituicaoOrcamento" as totalst,');
         SQL.Add('       "HoraOrcamento"                  as hora,');
         SQL.Add('       "TotalPISOrcamento"              as totalpis,');
         SQL.Add('       "TotalCOFINSOrcamento"           as totalcofins,');
         SQL.Add('       "PercentualDescontoOrcamento"    as percentualdesconto,');
         SQL.Add('       "TotalDescontoOrcamento"         as totaldesconto,');
         SQL.Add('       "TotalDespesaOrcamento"          as totaldespesa,');
         SQL.Add('       "ObservacaoOrcamento"            as observacao,');
         SQL.Add('       "PrecoUtilizadoOrcamento"        as precoutilizado,');
         SQL.Add('       "NumeroParcelasOrcamento"        as numeroparcelas,');
         SQL.Add('       "ValorEntradaOrcamento"          as valorentrada,');
         SQL.Add('       "OrigemPedidoOrcamento"          as origem,');
         SQL.Add('       "ValorFreteOrcamento"            as valorfrete,');
         SQL.Add('       "SituacaoFreteOrcamento"         as situacaofrete,');
         SQL.Add('       "FinalizadoOrcamento"            as finalizado,');
         SQL.Add('       "BloqueadoOrcamento"             as bloqueado,');
         SQL.Add('       "MaquinaOrigemOrcamento"         as maquinaorigem,');
         SQL.Add('       "NotaGeradaOrcamento"            as idnotagerada,');
         SQL.Add('       (select "NotaFiscal"."NumeroDocumentoNota" From "NotaFiscal" where "NotaFiscal"."CodigoInternoNota"="NotaGeradaOrcamento") as xdocumentonota,');
         SQL.Add('       (select "NotaFiscal"."DataEmissaoNota"     From "NotaFiscal" where "NotaFiscal"."CodigoInternoNota"="NotaGeradaOrcamento") as xemissaonota ');
//         SQL.Add('from "Orcamento" where "DataEmissaoOrcamento"=current_date ');
         SQL.Add('from "Orcamento" where "CodigoEmpresaOrcamento"=:xempresa ');
         ParamByName('xempresa').AsInteger := XEmpresa;
         if XQuery.ContainsKey('dataemissao') then // filtro por data emissão
            begin
              SQL.Add('and "DataEmissaoOrcamento"=:xemissao ');
              ParamByName('xemissao').AsDate := strtodate(XQuery.Items['dataemissao']);
            end;
         if XQuery.ContainsKey('numero') then // filtro por número
            begin
              SQL.Add('and "NumeroOrcamento"=:xnumero ');
              ParamByName('xnumero').AsString := XQuery.Items['numero'];
            end;
         if XQuery.ContainsKey('cliente') then // filtro por cliente
            begin
              SQL.Add('and lower(ts_retornapessoanome("CodigoClienteOrcamento")) like lower(:xcliente) ');
              ParamByName('xcliente').AsString := XQuery.Items['cliente']+'%';
            end;
         if XQuery.ContainsKey('vendedor') then // filtro por vendedor
            begin
              SQL.Add('and lower(ts_retornapessoanome("CodigoRepresentanteOrcamento")) like lower(:xvendedor) ');
              ParamByName('xvendedor').AsString := XQuery.Items['vendedor']+'%';
            end;
         if XQuery.ContainsKey('condicao') then // filtro por condicao
            begin
              SQL.Add('and lower(ts_retornacondicaodescricao("CodigoCondicaoOrcamento")) like lower(:xcondicao) ');
              ParamByName('xcondicao').AsString := XQuery.Items['condicao']+'%';
            end;
         if XQuery.ContainsKey('cobranca') then // filtro por cobrança
            begin
              SQL.Add('and lower(ts_retornadocumentocobrancadescricao("DocumentoCobrancaOrcamento")) like lower(:xcobranca) ');
              ParamByName('xcobranca').AsString := XQuery.Items['cobranca']+'%';
            end;
         if XQuery.ContainsKey('datavalidade') then // filtro por validade
            begin
              SQL.Add('and "DataValidadeOrcamento"=:xvalidade ');
              ParamByName('xvalidade').AsDate := strtodate(XQuery.Items['datavalidade']);
            end;
         if XQuery.ContainsKey('order') then // ordenação
            begin
              wordem := 'order by '+XQuery.Items['order']+' ';
//              if XQuery.Items['order']='numero' then
//                 wordem := 'order by "NumeroOrcamento" '
//              else if XQuery.Items['order']='dataemissao' then
//                 wordem := 'order by "DataEmissaoOrcamento" '
//              else if XQuery.Items['order']='total' then
//                 wordem := 'order by "TotalOrcamento" ';
              if XQuery.ContainsKey('dir') then // direção
                 wordem := wordem +XQuery.Items['dir'];
              SQL.Add(wordem);
            end
         else
            SQL.Add('order by "NumeroOrcamento" ');
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
         wobj.AddPair('description','Nenhum pedido encontrado');
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

function AlteraOrcamento(XIdOrcamento: integer; XOrcamento: TJSONObject): TJSONObject;
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
    if XOrcamento.TryGetValue('idcliente',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoClienteOrcamento"=:xidcliente'
         else
            wcampos := wcampos+',"CodigoClienteOrcamento"=:xidcliente';
       end;
    if XOrcamento.TryGetValue('idvendedor',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoRepresentanteOrcamento"=:xidvendedor'
         else
            wcampos := wcampos+',"CodigoRepresentanteOrcamento"=:xidvendedor';
       end;
    if XOrcamento.TryGetValue('idcondicao',wval) then
       begin
         if wconexao.EstabeleceConexaoDB then
            wbloqueado   := RetornaCondicaoBloqueada(wconexao.FDConnectionApi,strtoint(XOrcamento.GetValue('idcondicao').Value))
         else
            wbloqueado   := false;
         if wcampos='' then
            wcampos := '"CodigoCondicaoOrcamento"=:xidcondicao,"BloqueadoOrcamento"=:xbloqueado '
         else
            wcampos := wcampos+',"CodigoCondicaoOrcamento"=:xidcondicao,"BloqueadoOrcamento"=:xbloqueado ';
       end;
    if XOrcamento.TryGetValue('idcobranca',wval) then
       begin
         if wcampos='' then
            wcampos := '"DocumentoCobrancaOrcamento"=:xidcobranca'
         else
            wcampos := wcampos+',"DocumentoCobrancaOrcamento"=:xidcobranca';
       end;
    if XOrcamento.TryGetValue('dataemissao',wval) then
       begin
         if wcampos='' then
            wcampos := '"DataEmissaoOrcamento"=:xdataemissao'
         else
            wcampos := wcampos+',"DataEmissaoOrcamento"=:xdataemissao';
       end;
    if XOrcamento.TryGetValue('datavalidade',wval) then
       begin
         if wcampos='' then
            wcampos := '"DataValidadeOrcamento"=:xdatavalidade'
         else
            wcampos := wcampos+',"DataValidadeOrcamento"=:xdatavalidade';
       end;
    if XOrcamento.TryGetValue('finalizado',wval) then
       begin
         if wcampos='' then
            wcampos := '"FinalizadoOrcamento"=:xfinalizado'
         else
            wcampos := wcampos+',"FinalizadoOrcamento"=:xfinalizado';
       end;
    if XOrcamento.TryGetValue('observacao',wval) then
       begin
         if wcampos='' then
            wcampos := '"ObservacaoOrcamento"=:xobservacao'
         else
            wcampos := wcampos+',"ObservacaoOrcamento"=:xobservacao';
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
           SQL.Add('Update "Orcamento" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoOrcamento"=:xid ');
           ParamByName('xid').AsInteger      := XIdOrcamento;
           if XOrcamento.TryGetValue('idcliente',wval) then
              ParamByName('xidcliente').AsInteger  := strtoint(XOrcamento.GetValue('idcliente').Value);
           if XOrcamento.TryGetValue('idvendedor',wval) then
              ParamByName('xidvendedor').AsInteger  := strtoint(XOrcamento.GetValue('idvendedor').Value);
           if XOrcamento.TryGetValue('idcondicao',wval) then
              begin
                ParamByName('xidcondicao').AsInteger  := strtoint(XOrcamento.GetValue('idcondicao').Value);
                ParamByName('xbloqueado').AsBoolean   := wbloqueado;
              end;
           if XOrcamento.TryGetValue('idcobranca',wval) then
              ParamByName('xidcobranca').AsInteger  := strtoint(XOrcamento.GetValue('idcobranca').Value);
           if XOrcamento.TryGetValue('dataemissao',wval) then
              ParamByName('xdataemissao').AsDate     := strtodate(XOrcamento.GetValue('dataemissao').Value);
           if XOrcamento.TryGetValue('datavalidade',wval) then
              ParamByName('xdatavalidade').AsDate    := strtodate(XOrcamento.GetValue('datavalidade').Value);
           if XOrcamento.TryGetValue('finalizado',wval) then
              ParamByName('xfinalizado').AsBoolean   := StrToBool(XOrcamento.GetValue('finalizado').Value);
           if XOrcamento.TryGetValue('observacao',wval) then
              ParamByName('xobservacao').AsString    := XOrcamento.GetValue('observacao').Value;
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
              SQL.Add('select "CodigoInternoOrcamento"         as id,');
              SQL.Add('       "CodigoEmpresaOrcamento"         as idempresa,');
              SQL.Add('       "NumeroOrcamento"                as numero,');
              SQL.Add('       "CodigoClienteOrcamento"         as idcliente,');
              SQL.Add('       ts_retornapessoanome("CodigoClienteOrcamento") as xcliente, ');
              SQL.Add('       "CodigoRepresentanteOrcamento"   as idvendedor,');
              SQL.Add('       ts_retornapessoanome("CodigoRepresentanteOrcamento") as xvendedor, ');
              SQL.Add('       "CodigoTransporteOrcamento"      as idtransportador,');
              SQL.Add('       ts_retornapessoanome("CodigoTransporteOrcamento") as xtransportador, ');
              SQL.Add('       "CodigoCondicaoOrcamento"        as idcondicao,');
              SQL.Add('       ts_retornacondicaodescricao("CodigoCondicaoOrcamento") as xcondicao, ');
              SQL.Add('       "DocumentoCobrancaOrcamento"     as idcobranca,');
              SQL.Add('       ts_retornadocumentocobrancadescricao("DocumentoCobrancaOrcamento") as xcobranca, ');
              SQL.Add('       ts_retornacondicaopreco("CodigoCondicaoOrcamento") as xprecocondicao, ');
              SQL.Add('       ts_retornacondicaocodigofiscal("CodigoCondicaoOrcamento") as xidcfopcondicao,');
              SQL.Add('       ts_retornacondicaocodigofiscalst("CodigoCondicaoOrcamento") as xidcfopstcondicao,');
              SQL.Add('       ts_retornafiscalcodigo(ts_retornacondicaocodigofiscal("CodigoCondicaoOrcamento")) as xcfopcondicao,');
              SQL.Add('       ts_retornafiscalcodigo(ts_retornacondicaocodigofiscalst("CodigoCondicaoOrcamento")) as xcfopstcondicao,');
              SQL.Add('       (case when ts_retornacondicaotipper("CodigoCondicaoOrcamento")=''D'' then ts_retornacondicaopercentual("CodigoCondicaoOrcamento") else 0 end) as xdesccondicao,');
              SQL.Add('       (case when ts_retornacondicaotipper("CodigoCondicaoOrcamento")=''A'' then ts_retornacondicaopercentual("CodigoCondicaoOrcamento") else 0 end) as xacrescccondicao,');
              SQL.Add('       "DataEmissaoOrcamento"           as dataemissao,');
              SQL.Add('       "DataValidadeOrcamento"          as datavalidade,');
              SQL.Add('       "TotalOrcamento"                 as total,');
              SQL.Add('       "TotalLiquidoOrcamento"          as subtotal,');
              SQL.Add('       "BaseICMSOrcamento"              as baseicms,');
              SQL.Add('       "TotalICMSOrcamento"             as totalicms,');
              SQL.Add('       "BaseICMSSubstituicaoOrcamento"  as basest,');
              SQL.Add('       "TotalICMSSubstituicaoOrcamento" as totalst,');
              SQL.Add('       "HoraOrcamento"                  as hora,');
              SQL.Add('       "TotalPISOrcamento"              as totalpis,');
              SQL.Add('       "TotalCOFINSOrcamento"           as totalcofins,');
              SQL.Add('       "PercentualDescontoOrcamento"    as percentualdesconto,');
              SQL.Add('       "TotalDescontoOrcamento"         as totaldesconto,');
              SQL.Add('       "TotalDespesaOrcamento"          as totaldespesa,');
              SQL.Add('       "ObservacaoOrcamento"            as observacao,');
              SQL.Add('       "PrecoUtilizadoOrcamento"        as precoutilizado,');
              SQL.Add('       "NumeroParcelasOrcamento"        as numeroparcelas,');
              SQL.Add('       "ValorEntradaOrcamento"          as valorentrada,');
              SQL.Add('       "OrigemPedidoOrcamento"          as origem,');
              SQL.Add('       "ValorFreteOrcamento"            as valorfrete,');
              SQL.Add('       "SituacaoFreteOrcamento"         as situacaofrete,');
              SQL.Add('       "FinalizadoOrcamento"            as finalizado,');
              SQL.Add('       "BloqueadoOrcamento"             as bloqueado,');
              SQL.Add('       "NotaGeradaOrcamento"            as idnotagerada,');
              SQL.Add('       "MaquinaOrigemOrcamento"         as maquinaorigem,');
              SQL.Add('       (select "NotaFiscal"."NumeroDocumentoNota" From "NotaFiscal" where "NotaFiscal"."CodigoInternoNota"="NotaGeradaOrcamento") as xdocumentonota,');
              SQL.Add('       (select "NotaFiscal"."DataEmissaoNota"     From "NotaFiscal" where "NotaFiscal"."CodigoInternoNota"="NotaGeradaOrcamento") as xemissaonota ');
              SQL.Add('from "Orcamento" ');
              SQL.Add('where "CodigoInternoOrcamento" =:xid ');
              ParamByName('xid').AsInteger := XIdOrcamento;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum pedido alterado');
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

function VerificaRequisicao(XOrcamento: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XOrcamento.TryGetValue('dataemissao',wval) then
       wret := false;
    if not XOrcamento.TryGetValue('idcliente',wval) then
       wret := false;
    if not XOrcamento.TryGetValue('idvendedor',wval) then
       wret := false;
    if not XOrcamento.TryGetValue('idcondicao',wval) then
       wret := false;
    if not XOrcamento.TryGetValue('idcobranca',wval) then
       wret := false;
//    if not XOrcamento.TryGetValue('subtotal',wval) then
//       wret := false;
//    if not XOrcamento.TryGetValue('total',wval) then
//       wret := false;
  except
    On E: Exception do
    begin
      wret := false;
    end;
  end;
  Result := wret;
end;

function RetornaTotalOrcamentos(const XQuery: TDictionary<string, string>): TJSONObject;
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
         SQL.Add('from "Orcamento" ');
         SQL.Add('where "CodigoEmpresaOrcamento"=:xempresa ');
         if XQuery.ContainsKey('numero') then // filtro por código
            begin
              SQL.Add('and "NumeroOrcamento" =:xnumero ');
              ParamByName('xnumero').AsInteger := strtoint(XQuery.Items['numero']);
            end;
         if XQuery.ContainsKey('dataemissao') then // filtro por código
            begin
              SQL.Add('and "DataEmissaoOrcamento" =:xdataemissao ');
              ParamByName('xdataemissao').AsDate := strtodate(XQuery.Items['dataemissao']);
            end;
         ParamByName('xempresa').AsInteger := wconexao.FIdEmpresa;
         Open;
         EnableControls;
       end;

   if wquery.RecordCount>0 then
      wret := wquery.ToJSONObject()
   else
      begin
        wret := TJSONObject.Create;
        wret.AddPair('status','500');
        wret.AddPair('description','Nenhum orçamento encontrado');
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


function IncluiOrcamento(XOrcamento: TJSONObject; XIdEmpresa: integer): TJSONObject;
var wquery: TFDMemTable;
    wqueryInsert,wquerySelect: TFDQuery;
    wret: TJSONObject;
    wnum,wnumero,widorcamento: integer;
    wconexao: TProviderDataModuleConexao;
    wbloqueado: boolean;
begin
  try
    wconexao     := TProviderDataModuleConexao.Create(nil);
    wqueryInsert := TFDQuery.Create(nil);
    if wconexao.EstabeleceConexaoDB then
       begin
         widorcamento := RetornaIdOrcamento(wconexao.FDConnectionApi);
         wnumero      := RetornaNumeroPedido(wconexao.FDConnectionApi,XIdEmpresa);
         wbloqueado   := RetornaCondicaoBloqueada(wconexao.FDConnectionApi,strtoint(XOrcamento.GetValue('idcondicao').Value));
         with wqueryInsert do
         begin
           Connection := wconexao.FDConnectionApi;
           DisableControls;
           Close;
           SQL.Clear;
           Params.Clear;
           SQL.Add('Insert into "Orcamento" ("CodigoInternoOrcamento","NumeroOrcamento","CodigoEmpresaOrcamento","DataEmissaoOrcamento","DataValidadeOrcamento","CodigoCondicaoOrcamento","DocumentoCobrancaOrcamento",');
           SQL.Add('"CodigoClienteOrcamento","CodigoRepresentanteOrcamento","CodigoAlvoOrcamento","OrigemPedidoOrcamento","ModuloOrigemOrcamento","FinalizadoOrcamento","BloqueadoOrcamento","EhDevolucaoOrcamento") ');
           SQL.Add('values (:xidorcamento,:xnumero,:xidempresa,:xemissao,:xemissao,:xidcondicao,:xidcobranca,:xidcliente,:xidvendedor,:xidcliente,:xorigem,:xmoduloorigem,:xfinalizado,:xbloqueado,:xehdevolucao) ');
           ParamByName('xidorcamento').AsInteger  := widorcamento;
           ParamByName('xnumero').AsInteger       := wnumero;
           ParamByName('xidempresa').AsInteger    := XIdEmpresa;
           ParamByName('xemissao').AsDate         := strtodate(XOrcamento.GetValue('dataemissao').Value);
           ParamByName('xidcondicao').AsInteger   := strtoint(XOrcamento.GetValue('idcondicao').Value);
           ParamByName('xidcobranca').AsInteger   := strtoint(XOrcamento.GetValue('idcobranca').Value);
           ParamByName('xidcliente').AsInteger    := strtoint(XOrcamento.GetValue('idcliente').Value);
           ParamByName('xidvendedor').AsInteger   := strtoint(XOrcamento.GetValue('idvendedor').Value);
           ParamByName('xorigem').AsString        := 'D'; // digitação
           ParamByName('xmoduloorigem').AsString  := 'TS-Mobile';
           ParamByName('xfinalizado').AsBoolean   := false;
           ParamByName('xbloqueado').AsBoolean    := wbloqueado;
           ParamByName('xehdevolucao').AsBoolean  := false;
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
                SQL.Add('select "CodigoInternoOrcamento"         as id,');
                SQL.Add('       "CodigoEmpresaOrcamento"         as idempresa,');
                SQL.Add('       "NumeroOrcamento"                as numero,');
                SQL.Add('       "CodigoClienteOrcamento"         as idcliente,');
                SQL.Add('       ts_retornapessoanome("CodigoClienteOrcamento") as xcliente, ');
                SQL.Add('       "CodigoRepresentanteOrcamento"   as idvendedor,');
                SQL.Add('       ts_retornapessoanome("CodigoRepresentanteOrcamento") as xvendedor, ');
                SQL.Add('       "CodigoTransporteOrcamento"      as idtransportador,');
                SQL.Add('       ts_retornapessoanome("CodigoTransporteOrcamento") as xtransportador, ');
                SQL.Add('       "CodigoCondicaoOrcamento"        as idcondicao,');
                SQL.Add('       ts_retornacondicaodescricao("CodigoCondicaoOrcamento") as xcondicao, ');
                SQL.Add('       "DocumentoCobrancaOrcamento"     as idcobranca,');
                SQL.Add('       ts_retornadocumentocobrancadescricao("DocumentoCobrancaOrcamento") as xcobranca, ');
                SQL.Add('       ts_retornacondicaopreco("CodigoCondicaoOrcamento") as xprecocondicao, ');
                SQL.Add('       ts_retornacondicaocodigofiscal("CodigoCondicaoOrcamento") as xidcfopcondicao,');
                SQL.Add('       ts_retornacondicaocodigofiscalst("CodigoCondicaoOrcamento") as xidcfopstcondicao,');
                SQL.Add('       ts_retornafiscalcodigo(ts_retornacondicaocodigofiscal("CodigoCondicaoOrcamento")) as xcfopcondicao,');
                SQL.Add('       ts_retornafiscalcodigo(ts_retornacondicaocodigofiscalst("CodigoCondicaoOrcamento")) as xcfopstcondicao,');
                SQL.Add('       (case when ts_retornacondicaotipper("CodigoCondicaoOrcamento")=''D'' then ts_retornacondicaopercentual("CodigoCondicaoOrcamento") else 0 end) as xdesccondicao,');
                SQL.Add('       (case when ts_retornacondicaotipper("CodigoCondicaoOrcamento")=''A'' then ts_retornacondicaopercentual("CodigoCondicaoOrcamento") else 0 end) as xacrescccondicao,');
                SQL.Add('       "DataEmissaoOrcamento"           as dataemissao,');
                SQL.Add('       "DataValidadeOrcamento"          as datavalidade,');
                SQL.Add('       "TotalOrcamento"                 as total,');
                SQL.Add('       "TotalLiquidoOrcamento"          as subtotal,');
                SQL.Add('       "BaseICMSOrcamento"              as baseicms,');
                SQL.Add('       "TotalICMSOrcamento"             as totalicms,');
                SQL.Add('       "BaseICMSSubstituicaoOrcamento"  as basest,');
                SQL.Add('       "TotalICMSSubstituicaoOrcamento" as totalst,');
                SQL.Add('       "HoraOrcamento"                  as hora,');
                SQL.Add('       "TotalPISOrcamento"              as totalpis,');
                SQL.Add('       "TotalCOFINSOrcamento"           as totalcofins,');
                SQL.Add('       "PercentualDescontoOrcamento"    as percentualdesconto,');
                SQL.Add('       "TotalDescontoOrcamento"         as totaldesconto,');
                SQL.Add('       "TotalDespesaOrcamento"          as totaldespesa,');
                SQL.Add('       "ObservacaoOrcamento"            as observacao,');
                SQL.Add('       "PrecoUtilizadoOrcamento"        as precoutilizado,');
                SQL.Add('       "NumeroParcelasOrcamento"        as numeroparcelas,');
                SQL.Add('       "ValorEntradaOrcamento"          as valorentrada,');
                SQL.Add('       "OrigemPedidoOrcamento"          as origem,');
                SQL.Add('       "ValorFreteOrcamento"            as valorfrete,');
                SQL.Add('       "SituacaoFreteOrcamento"         as situacaofrete,');
                SQL.Add('       "FinalizadoOrcamento"            as finalizado,');
                SQL.Add('       "BloqueadoOrcamento"             as bloqueado,');
                SQL.Add('       "NotaGeradaOrcamento"            as idnotagerada,');
                SQL.Add('       "MaquinaOrigemOrcamento"         as maquinaorigem,');
                SQL.Add('       (select "NotaFiscal"."NumeroDocumentoNota" From "NotaFiscal" where "NotaFiscal"."CodigoInternoNota"="NotaGeradaOrcamento") as xdocumentonota,');
                SQL.Add('       (select "NotaFiscal"."DataEmissaoNota"     From "NotaFiscal" where "NotaFiscal"."CodigoInternoNota"="NotaGeradaOrcamento") as xemissaonota ');
                SQL.Add('from "Orcamento" ');
                SQL.Add('where "CodigoInternoOrcamento" =:xorcamento ');
                ParamByName('xorcamento').AsInteger := widorcamento;
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum pedido incluído');
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

function RetornaIdOrcamento(XFDConnection: TFDConnection): integer;
var wret: integer;
    wquery: TFDQuery;
    wsequence: string;
begin
  wsequence := '"Orcamento_CodigoInternoOrcamento_seq"';
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

function RetornaCondicaoBloqueada(XFDConnection: TFDConnection; XIdCondicao: integer): boolean;
var wret: boolean;
    wquery: TFDQuery;
begin
  wquery    := TFDQuery.Create(nil);
  with wquery do
  begin
    Connection := XFDConnection;
    DisableControls;
    Close;
    SQL.Clear;
    Params.Clear;
    SQL.Add('select * from "CondicaoPagamento" where "CodigoInternoCondicao"=:xid ');
    ParamByName('xid').asInteger := XIdCondicao;
    Open;
    EnableControls;
    if RecordCount > 0 then
       wret := wquery.FieldByName('DefinirPedidoBloqueadoCondicao').asBoolean
    else
       wret := false;
  end;
  Result := wret;
end;



function RetornaNumeroPedido(XFDConnection: TFDConnection; XIdEmpresa: integer): integer;
var wret: integer;
    wquery: TFDQuery;
    wsequence: string;
begin
  wsequence := '"UltimoPedidoTSPedido_'+inttostr(XIdEmpresa)+'_seq"';
  wquery    := TFDQuery.Create(nil);
  with wquery do
  begin
    Connection := XFDConnection;
    DisableControls;
    Close;
    SQL.Clear;
    Params.Clear;
    SQL.Add('Select "TS_PedidoXE5_RenumeraPedido"(:XEmpresa) as ult ');
    ParamByName('XEmpresa').AsInteger := XIdEmpresa;
//    SQL.Add('select nextval('+QuotedStr(wsequence)+') as ult ');
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
