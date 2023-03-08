unit dat.movDFeCiencias;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaCiencia(XId: integer): TJSONObject;
function RetornaListaCiencias(const XQuery: TDictionary<string, string>; XEmpresa,XLimit,XOffset: integer): TJSONArray;
function RetornaTotalCiencias(const XQuery: TDictionary<string, string>): TJSONObject;

implementation

uses prv.dataModuleConexao;

function RetornaCiencia(XId: integer): TJSONObject;
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
         SQL.Add('select "CodigoInternoDistribuicao" as id,');
         SQL.Add('       "CodigoEmpresaDistribuicao" as idempresa,');
         SQL.Add('       "UltimoNSUDistribuicao"     as ultnsu,');
         SQL.Add('       "NSUDistribuicao"           as nsu,');
         SQL.Add('       "ChaveNFeDistribuicao"      as chavenfe,');
         SQL.Add('       "StatusDistribuicao"        as status,');
         SQL.Add('       "ArquivoSalvoDistribuicao"  as arquivosalvo,');
         SQL.Add('       "DataEmissaoDistribuicao"   as dataemissao,');
         SQL.Add('       "ValorNFeDistribuicao"      as valornfe,');
         SQL.Add('       "XMLDistribuicao"           as xml,');
         SQL.Add('       "CNPJEmitenteDistribuicao"  as cnpjemitente,');
         SQL.Add('       "NomeEmitenteDistribuicao"  as nomeemitente,');
         SQL.Add('       "ProtocoloNFeDistribuicao"  as protocolo,');
         SQL.Add('       "AtorDistribuicao"          as ator ');
         SQL.Add('from "DistribuicaoDocumentoFiscal" where "CodigoInternoDistribuicao"=:xid  ');
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
        wret.AddPair('description','Nenhum registro encontrado');
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

function RetornaListaCiencias(const XQuery: TDictionary<string, string>; XEmpresa,XLimit,XOffset: integer): TJSONArray;
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
         SQL.Add('select "CodigoInternoDistribuicao" as id,');
         SQL.Add('       "CodigoEmpresaDistribuicao" as idempresa,');
         SQL.Add('       "UltimoNSUDistribuicao"     as ultnsu,');
         SQL.Add('       "NSUDistribuicao"           as nsu,');
         SQL.Add('       "ChaveNFeDistribuicao"      as chavenfe,');
         SQL.Add('       "StatusDistribuicao"        as status,');
         SQL.Add('       "ArquivoSalvoDistribuicao"  as arquivosalvo,');
         SQL.Add('       "DataEmissaoDistribuicao"   as dataemissao,');
         SQL.Add('       "ValorNFeDistribuicao"      as valornfe,');
         SQL.Add('       "XMLDistribuicao"           as xml,');
         SQL.Add('       "CNPJEmitenteDistribuicao"  as cnpjemitente,');
         SQL.Add('       "NomeEmitenteDistribuicao"  as nomeemitente,');
         SQL.Add('       "ProtocoloNFeDistribuicao"  as protocolo,');
         SQL.Add('       "AtorDistribuicao"          as ator ');
         SQL.Add('from "DistribuicaoDocumentoFiscal" where "CodigoEmpresaDistribuicao"=:xempresa and "StatusDistribuicao"=''2''  ');
         ParamByName('xempresa').AsInteger := XEmpresa;
         if XQuery.ContainsKey('dataemissao') then // filtro por data emissão
            begin
              SQL.Add('and "DataEmissaoDistribuicao" >=:xemissao ');
              ParamByName('xemissao').AsDate := strtodate(XQuery.Items['dataemissao']);
            end;
         if XQuery.ContainsKey('nsu') then // filtro por NSU
            begin
              SQL.Add('and cast("NSUDistribuicao as integer)" >=:xnsu ');
              ParamByName('xnsu').AsInteger := strtointdef(XQuery.Items['nsu'],0);
            end;
         if XQuery.ContainsKey('chavenfe') then // filtro por chave
            begin
              SQL.Add('and "ChaveNFeDistribuicao" like :xchave ');
              ParamByName('xchave').AsString := XQuery.Items['xchave']+'%';
            end;
         if XQuery.ContainsKey('cnpjemitente') then // filtro por CNPJ emitente
            begin
              SQL.Add('and "CNPJEmitenteDistribuicao" like :xcnpjemitente ');
              ParamByName('xcnpjemitente').AsString := XQuery.Items['cnpjemitente']+'%';
            end;
         if XQuery.ContainsKey('nomeemitente') then // filtro por Nome Emitente
            begin
              SQL.Add('and lower("NomeEmitenteDistribuicao") like lower(:xnomeemitente) ');
              ParamByName('xnomeemitente').AsString := XQuery.Items['nomeemitente']+'%';
            end;
         if XQuery.ContainsKey('valornfe') then // filtro por valor
            begin
              SQL.Add('and "ValorNFeDistribuicao" =:valornfe ');
              ParamByName('xvalornfe').AsFloat := strtofloatdef(XQuery.Items['valornfe'],0);
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
            SQL.Add('order by "NSUDistribuicao" ');
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
         wobj.AddPair('description','Nenhum registro encontrado');
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

function RetornaTotalCiencias(const XQuery: TDictionary<string, string>): TJSONObject;
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
         SQL.Add('from "DistribuicaoDocumentoFiscal" ');
         SQL.Add('Where "StatusDistribuicao"=''2'' ');
         if XQuery.ContainsKey('dataemissao') then // filtro por data emissão
            begin
              SQL.Add('and "DataEmissaoDistribuicao" >=:xemissao ');
              ParamByName('xemissao').AsDate := strtodate(XQuery.Items['dataemissao']);
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
        wret.AddPair('description','Nenhum registro encontrado');
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
