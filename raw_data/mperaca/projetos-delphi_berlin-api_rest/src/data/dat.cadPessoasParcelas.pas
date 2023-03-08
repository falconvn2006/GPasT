unit dat.cadPessoasParcelas;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaListaParcelas(const XQuery: TDictionary<string, string>; XIdPessoa,XLimit,XOffset: integer): TJSONArray;
function RetornaTotalParcelas(const XQuery: TDictionary<string, string>; XIdPessoa: integer): TJSONObject;
function RetornaResumoParcelas(const XQuery: TDictionary<string, string>; XIdPessoa: integer): TJSONObject;

implementation

uses prv.dataModuleConexao;


function RetornaListaParcelas(const XQuery: TDictionary<string, string>; XIdPessoa,XLimit,XOffset: integer): TJSONArray;
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
         SQL.Add('Select "CodigoInternoParcela" as id, "Origem" as origem, "NumeroDocumentoParcela" as numerodocumento, "DataEmissaoParcela" as emissao, "DataVencimentoParcela" as vencimento,');
         SQL.Add('"DataOperacaoParcela" as operacao, "XAtraso" as atraso, "NumeroParcela" as numparcela, "OrdemServicoParcela" as ordemservico,');
         SQL.Add('"NumeroPagamentosParcela" as numpag, "ValorOriginalParcela" as valororiginal, "ValorFinalParcela" as valorfinal, "ValorIndiceParcela" as valorindice,');
         SQL.Add('"ValorDescontoParcela" as valordesconto, "PrefixoPagamentoParcela" as prefixopagamento, "PrefixoOrigemParcela" as prefixoorigem,');
         SQL.Add('"TipoOperacaoParcela" as tipooperacao, "ValorCorrecaoParcela" as valorcorrecao, "TipoMovimentoParcela" as tipomovimento,');
         SQL.Add('"CodigoCondicaoParcela" as idcondicao, "DescricaoPagamento" as descricaopagamento, "ValorMultaParcela" as valormulta, "ValorJuroParcela" as valorjuro,');
         SQL.Add('"TotalRetencoesParcela" as totalretencao, "XTotalOriginal" as xtotaloriginal, "XTotalDesconto" as xtotaldesconto, "XTotalJuros" as xtotaljuros,');
         SQL.Add('"XTotalMulta" as xtotalmulta, "XTotalTotal" as xtotaltotal, "XQtdeC" as xqtdecancelado, "XQtdeQ" as xtotalquitado, "XQtdeE" as xtotalemaberto,');
         SQL.Add('"XTotalC" as xtotalcancelado, "XTotalQ" as xtotalquitado, "XTotalE" as xtotalemaberto ');
         SQL.Add('From "TS_RetornaParcelasCliente"(:xempresa,:xidpessoa,:xdias) ');
         ParamByName('xempresa').AsInteger  := wconexao.FIdEmpresa;
         ParamByName('xidpessoa').AsInteger := XIdPessoa;
         ParamByName('xdias').AsInteger     := 0;
         if XQuery.ContainsKey('order') then // ordenação
            begin
              wordem := 'order by '+XQuery.Items['order'];
              if XQuery.ContainsKey('dir') then // direção
                 wordem := wordem+' '+XQuery.Items['dir'];
              SQL.Add(wordem);
            end
         else
            SQL.Add('order by id ');
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
         wobj.AddPair('description','Nenhuma Parcela encontrada');
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

function RetornaTotalParcelas(const XQuery: TDictionary<string, string>; XIdPessoa: integer): TJSONObject;
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
         SQL.Add('From "TS_RetornaParcelasCliente"(:xempresa,:xidpessoa,:xdias) ');
         ParamByName('xempresa').AsInteger  := wconexao.FIdEmpresa;
         ParamByName('xidpessoa').AsInteger := XIdPessoa;
         ParamByName('xdias').AsInteger     := 0;
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

function RetornaResumoParcelas(const XQuery: TDictionary<string, string>; XIdPessoa: integer): TJSONObject;
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
         SQL.Add('Select "XQtdeC" as xqtdecancelado, "XQtdeQ" as xqtdequitado, "XQtdeE" as xqtdeemaberto,');
         SQL.Add('"XTotalC" as xtotalcancelado, "XTotalQ" as xtotalquitado, "XTotalE" as xtotalemaberto ');
         SQL.Add('From "TS_RetornaParcelasCliente"(:xempresa,:xidpessoa,:xdias) limit 1 ');
         ParamByName('xempresa').AsInteger  := wconexao.FIdEmpresa;
         ParamByName('xidpessoa').AsInteger := XIdPessoa;
         ParamByName('xdias').AsInteger     := 0;
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


end.
