unit dat.movNFePendentes;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function ApagaNFePendente(XId: integer): TJSONObject;
function RetornaNFePendente(XId: integer): TJSONObject;
function RetornaListaNFePendentes(const XQuery: TDictionary<string, string>): TJSONArray;
function VerificaRequisicao(XNFePendente: TJSONObject): boolean;
function IncluiNFePendente(XNFePendente: TJSONObject; XIdEmpresa: integer): TJSONObject;
function RetornaIdNota(XFDConnection: TFDConnection): integer;
function RetornaCliente(XFDConnection: TFDConnection; XCliente: string): integer;
function RetornaVendedor(XFDConnection: TFDConnection; XVendedor: string): integer;
function RetornaCondicao(XFDConnection: TFDConnection; XCondicao: string): integer;
function RetornaCobranca(XFDConnection: TFDConnection; XCobranca: string): integer;
function RetornaOperacaoEstoque(XFDConnection: TFDConnection; XCondicao: integer): integer;
function RetornaEspecieNota(XFDConnection: TFDConnection; XEspecie: string): integer;
function RetornaClassificacao(XFDConnection: TFDConnection; XCondicao: integer): integer;
function RetornaNumeroPedido(XFDConnection: TFDConnection; XIdEmpresa: integer): integer;

implementation

uses prv.dataModuleConexao;

function RetornaNFePendente(XId: integer): TJSONObject;
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
         SQL.Add('select "CodigoInternoNota"         as id,');
         SQL.Add('       "PedidoClienteNota"         as pedido,');
         SQL.Add('       "DataEmissaoNota"           as dataemissao,');
         SQL.Add('       "TotalLiquidoNota"          as subtotal,');
         SQL.Add('       "BaseICMSNota"              as baseicms,');
         SQL.Add('       "TotalICMSNota"             as totalicms,');
         SQL.Add('       "TotalIPINota"              as totalipi,');
         SQL.Add('       "BaseICMSSubstituicaoNota"  as basest,');
         SQL.Add('       "TotalICMSSubstituicaoNota" as totalst,');
         SQL.Add('       "TotalPISNota"              as totalpis,');
         SQL.Add('       "TotalCOFINSNota"           as totalcofins,');
         SQL.Add('       "TotalNota"                 as total,');
         SQL.Add('       ts_retornapessoanome("CodigoClienteNota") as cliente, ');
         SQL.Add('       "NumeroDocumentoNota"     as numdoc, ');
         SQL.Add('       "IdNFeNota"               as chave, ');
         SQL.Add('       "SituacaoNota"            as situacao ');
         SQL.Add('from "NotaFiscal" where "CodigoInternoNota"=:xid and  ');
         SQL.Add('"ModuloOrigemNota"=''TS-Fature'' and "ModeloDocumentoFiscal"=''55'' and "IdNFeNota" is null ');
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
        wret.AddPair('description','Nenhuma nfe pendente encontrada');
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

function ApagaNFePendente(XId: integer): TJSONObject;
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
        wret.AddPair('description','NFe pendente excluída com sucesso');
        wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
      end
   else
      begin
        wret := TJSONObject.Create;
        wret.AddPair('status','500');
        wret.AddPair('description','Nenhuma nfe pendente excluída');
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



function RetornaListaNFePendentes(const XQuery: TDictionary<string, string>): TJSONArray;
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
         SQL.Add('select "CodigoInternoNota"         as id,');
         SQL.Add('       "PedidoClienteNota"         as pedido,');
         SQL.Add('       "DataEmissaoNota"           as dataemissao,');
         SQL.Add('       "TotalLiquidoNota"          as subtotal,');
         SQL.Add('       "BaseICMSNota"              as baseicms,');
         SQL.Add('       "TotalICMSNota"             as totalicms,');
         SQL.Add('       "TotalIPINota"              as totalipi,');
         SQL.Add('       "BaseICMSSubstituicaoNota"  as basest,');
         SQL.Add('       "TotalICMSSubstituicaoNota" as totalst,');
         SQL.Add('       "TotalPISNota"              as totalpis,');
         SQL.Add('       "TotalCOFINSNota"           as totalcofins,');
         SQL.Add('       "TotalNota"                 as total,');
         SQL.Add('       ts_retornapessoanome("CodigoClienteNota") as cliente, ');
         SQL.Add('       "NumeroDocumentoNota"     as numdoc, ');
         SQL.Add('       "IdNFeNota"               as chave, ');
         SQL.Add('       "SituacaoNota"            as situacao ');
         SQL.Add('from "NotaFiscal" where "DataEmissaoNota"=current_date and ');
         SQL.Add('"ModuloOrigemNota"=''TS-Fature'' and "ModeloDocumentoFiscal"=''55'' and "IdNFeNota" is null ');

{         if XQuery.ContainsKey('nome') then // filtro por nome
            begin
              SQL.Add('and lower("NomeLocalidade")=lower(:xnome) ');
              ParamByName('xnome').AsString := XQuery.Items['nome'];
            end;
         if XQuery.ContainsKey('uf') then // filtro por uf
            begin
              SQL.Add('and lower("EstadoLocalidade")=lower(:xuf) ');
              ParamByName('xuf').AsString := XQuery.Items['uf'];
            end;
         if XQuery.ContainsKey('regiao') then // filtro por região
            begin
              SQL.Add('and lower("RegiaoLocalidade")=lower(:xregiao) ');
              ParamByName('xregiao').AsString := XQuery.Items['regiao'];
            end;
         if XQuery.ContainsKey('codibge') then // filtro por código ibge
            begin
              SQL.Add('and "CodigoLocalidade"=:xcodibge ');
              ParamByName('xcodibge').AsString := XQuery.Items['codibge'];
            end;}
         Open;
         EnableControls;
       end;
    if wqueryLista.RecordCount>0 then
       wret := wqueryLista.ToJSONArray()
    else
       begin
         wobj := TJSONObject.Create;
         wobj.AddPair('status','500');
         wobj.AddPair('description','Nenhuma nfe pendente encontrada');
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

function VerificaRequisicao(XNFePendente: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XNFePendente.TryGetValue('dataemissao',wval) then
       wret := false;
    if not XNFePendente.TryGetValue('cliente',wval) then
       wret := false;
    if not XNFePendente.TryGetValue('vendedor',wval) then
       wret := false;
    if not XNFePendente.TryGetValue('condicao',wval) then
       wret := false;
    if not XNFePendente.TryGetValue('cobranca',wval) then
       wret := false;
  except
    On E: Exception do
    begin
      wret := false;
    end;
  end;
  Result := wret;
end;

function IncluiNFePendente(XNFePendente: TJSONObject; XIdEmpresa: integer): TJSONObject;
var wquery: TFDMemTable;
    wqueryInsert,wquerySelect: TFDQuery;
    wret: TJSONObject;
    wnum,wnumped,woperacao,wespecie,widnota,wcliente,wvendedor,wcondicao,wcobranca,wclassificacao: integer;
    wconexao: TProviderDataModuleConexao;
begin
  try
    wconexao     := TProviderDataModuleConexao.Create(nil);
    wqueryInsert := TFDQuery.Create(nil);
    if wconexao.EstabeleceConexaoDB then
       begin
         widnota   := RetornaIdNota(wconexao.FDConnectionApi);
         wnumped   := RetornaNumeroPedido(wconexao.FDConnectionApi,XIdEmpresa);
         wcliente  := RetornaCliente(wconexao.FDConnectionApi,XNFePendente.GetValue('cliente').Value);
         wvendedor := RetornaVendedor(wconexao.FDConnectionApi,XNFePendente.GetValue('vendedor').Value);
         wcondicao := RetornaCondicao(wconexao.FDConnectionApi,XNFePendente.GetValue('condicao').Value);
         wcobranca := RetornaCobranca(wconexao.FDConnectionApi,XNFePendente.GetValue('cobranca').Value);
         woperacao := RetornaOperacaoEstoque(wconexao.FDConnectionApi,wcondicao);
         wclassificacao := RetornaClassificacao(wconexao.FDConnectionApi,wcondicao);
         wespecie  := RetornaEspecieNota(wconexao.FDConnectionApi,'NFe');
         with wqueryInsert do
         begin
           Connection := wconexao.FDConnectionApi;
           DisableControls;
           Close;
           SQL.Clear;
           Params.Clear;
           SQL.Add('Insert into "NotaFiscal" ("CodigoInternoNota","PedidoClienteNota","CodigoEmpresaNota","DataEmissaoNota","DataSaidaNota","CodigoCondicaoNota","CodigoOperacaoEstoqueNota","CodigoDocumentoCobrancaNota",');
           SQL.Add('"CodigoClienteNota","CodigoRepresentanteNota","CodigoAlvoNota","ModuloOrigemNota","ModeloDocumentoFiscal","EspecieDocumentoNota","SerieSubSerieNota","ClassificacaoReceitaDespesaNota","DataMovimentoNota",');
           SQL.Add('"CodigoPortadorDocumentoNota") ');
           SQL.Add('values (:xidnota,:xnumped,:xidempresa,:xemissao,:xemissao,:xidcondicao,:xidoperacao,:xidcobranca,:xidcliente,:xidvendedor,:xidcliente,:xmodulo,:xmodelo,:xespecie,null,:xclassificacao,:xdatamov,:xportador) ');
           ParamByName('xidnota').AsInteger     := widnota;
           ParamByName('xnumped').AsInteger     := wnumped;
           ParamByName('xidempresa').AsInteger  := XIdEmpresa;
           ParamByName('xemissao').AsDate       := strtodate(XNFePendente.GetValue('dataemissao').Value);
           ParamByName('xidcondicao').AsInteger := wcondicao;
           ParamByName('xidoperacao').AsInteger := woperacao;
           ParamByName('xidcobranca').AsInteger := wcobranca;
           ParamByName('xidcliente').AsInteger  := wcliente;
           ParamByName('xidvendedor').AsInteger := wvendedor;
           ParamByName('xmodulo').AsString      := 'TS-Fature';
           ParamByName('xmodelo').AsString      := '55';
           ParamByName('xespecie').AsInteger    := wespecie;
           ParamByName('xclassificacao').AsInteger := wclassificacao;
           ParamByName('xdatamov').AsDateTime   := StrToDateTime(XNFePendente.GetValue('dataemissao').Value+' '+formatdatetime('hh:nn:ss',now));
           ParamByName('xportador').AsInteger   := XIdEmpresa;
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
                SQL.Add('select "CodigoInternoNota" as id,"DataEmissaoNota" as emissao,ts_retornacondicaodescricao("CodigoCondicaoNota") as condicao,');
                SQL.Add('ts_retornapessoanome("CodigoClienteNota") as cliente, ts_retornapessoanome("CodigoRepresentanteNota") as idvendedor,"ModeloDocumentoFiscal" as modelo ');
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
              wret.AddPair('description','Nenhuma NFe incluída');
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

function RetornaCliente(XFDConnection: TFDConnection; XCliente: string): integer;
var wret: integer;
    wquery: TFDQuery;
begin
  wquery := TFDQuery.Create(nil);
  with wquery do
  begin
    Connection := XFDConnection;
    DisableControls;
    Close;
    SQL.Clear;
    Params.Clear;
    SQL.Add('select "CodigoInternoPessoa" as id from "PessoaGeral" where "NomePessoa"=:xcliente and "AtivoPessoa"=''true'' and "EhClientePessoa"=''true'' ');
    ParamByName('xcliente').AsString := XCliente;
    Open;
    EnableControls;
    if RecordCount>0 then
       wret := FieldByName('id').AsInteger
    else
       wret := 0;
  end;
  Result := wret;
end;

function RetornaVendedor(XFDConnection: TFDConnection; XVendedor: string): integer;
var wret: integer;
    wquery: TFDQuery;
begin
  wquery := TFDQuery.Create(nil);
  with wquery do
  begin
    Connection := XFDConnection;
    DisableControls;
    Close;
    SQL.Clear;
    Params.Clear;
    SQL.Add('select "CodigoInternoPessoa" as id from "PessoaGeral" where "NomePessoa"=:xvendedor and "AtivoPessoa"=''true'' and "EhRepresentantePessoa"=''true'' ');
    ParamByName('xvendedor').AsString := XVendedor;
    Open;
    EnableControls;
    if RecordCount>0 then
       wret := FieldByName('id').AsInteger
    else
       wret := 0;
  end;
  Result := wret;
end;

function RetornaCondicao(XFDConnection: TFDConnection; XCondicao: string): integer;
var wret: integer;
    wquery: TFDQuery;
begin
  wquery := TFDQuery.Create(nil);
  with wquery do
  begin
    Connection := XFDConnection;
    DisableControls;
    Close;
    SQL.Clear;
    Params.Clear;
    SQL.Add('select "CodigoInternoCondicao" as id from "CondicaoPagamento" where "DescricaoCondicao"=:xcondicao and "EhSaidaCondicao"=''true'' ');
    ParamByName('xcondicao').AsString := XCondicao;
    Open;
    EnableControls;
    if RecordCount>0 then
       wret := FieldByName('id').AsInteger
    else
       wret := 0;
  end;
  Result := wret;
end;

function RetornaCobranca(XFDConnection: TFDConnection; XCobranca: string): integer;
var wret: integer;
    wquery: TFDQuery;
begin
  wquery := TFDQuery.Create(nil);
  with wquery do
  begin
    Connection := XFDConnection;
    DisableControls;
    Close;
    SQL.Clear;
    Params.Clear;
    SQL.Add('select "CodigoInternoCobranca" as id from "DocumentoCobranca" where "NomeDocumentoCobranca"=:xcobranca ');
    ParamByName('xcobranca').AsString := XCobranca;
    Open;
    EnableControls;
    if RecordCount>0 then
       wret := FieldByName('id').AsInteger
    else
       wret := 0;
  end;
  Result := wret;
end;

function RetornaOperacaoEstoque(XFDConnection: TFDConnection; XCondicao: integer): integer;
var wret: integer;
    wquery: TFDQuery;
begin
  wquery := TFDQuery.Create(nil);
  with wquery do
  begin
    Connection := XFDConnection;
    DisableControls;
    Close;
    SQL.Clear;
    Params.Clear;
    SQL.Add('select "CodigoOperacaoCondicao" as id from "CondicaoPagamento" where "CodigoInternoCondicao"=:xcondicao ');
    ParamByName('xcondicao').AsInteger := XCondicao;
    Open;
    EnableControls;
    if RecordCount>0 then
       wret := FieldByName('id').AsInteger
    else
       wret := 0;
  end;
  Result := wret;
end;


function RetornaEspecieNota(XFDConnection: TFDConnection; XEspecie: string): integer;
var wret: integer;
    wquery: TFDQuery;
begin
  wquery := TFDQuery.Create(nil);
  with wquery do
  begin
    Connection := XFDConnection;
    DisableControls;
    Close;
    SQL.Clear;
    Params.Clear;
    SQL.Add('select "CodigoInternoValidacao" as id from "Validacao" where "TipoValidacao"=''E'' and "AbreviaValidacao"=:xespecie ');
    ParamByName('xespecie').AsString := XEspecie;
    Open;
    EnableControls;
    if RecordCount>0 then
       wret := FieldByName('id').AsInteger
    else
       wret := 0;
  end;
  Result := wret;
end;

function RetornaClassificacao(XFDConnection: TFDConnection; XCondicao: integer): integer;
var wret: integer;
    wquery: TFDQuery;
begin
  wquery := TFDQuery.Create(nil);
  with wquery do
  begin
    Connection := XFDConnection;
    DisableControls;
    Close;
    SQL.Clear;
    Params.Clear;
    SQL.Add('select "ClassificacaoFiscalCondicao" as id from "CondicaoPagamento" where "CodigoInternoCondicao"=:xcondicao ');
    ParamByName('xcondicao').AsInteger := XCondicao;
    Open;
    EnableControls;
    if RecordCount>0 then
       wret := FieldByName('id').AsInteger
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
