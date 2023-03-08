unit dat.movDFeConsultados;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,System.StrUtils,System.Math,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaConsultado(XId: integer): TJSONObject;
function RetornaListaConsultados(const XQuery: TDictionary<string, string>; XEmpresa,XLimit,XOffset: integer): TJSONArray;
function RetornaTotalConsultados(const XQuery: TDictionary<string, string>): TJSONObject;
function VerificaRequisicao(XConsultado: TJSONObject): boolean;
function IncluiConsultado(XConsultado: TJSONObject; XStatus: string): TJSONObject;
function AtualizaUltimoNSU(XUltNSU,XMaxNSU: integer): boolean;
function ArquivaDocumentoDFe(XNSU: integer): boolean;
function RetornaUltimoNSU: TJSONObject;
function VerificaChaveNFe(XChaveNFe: string): boolean;
function AlteraArquivoConsultado(XChaveNFe,XNSU,XStatus: string; XSalvo: boolean): boolean;
function ArquivaDocumentoDFe2(XChave,XStatus: string): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaConsultado(XId: integer): TJSONObject;
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

function RetornaListaConsultados(const XQuery: TDictionary<string, string>; XEmpresa,XLimit,XOffset: integer): TJSONArray;
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
         SQL.Add('from "DistribuicaoDocumentoFiscal" where "CodigoEmpresaDistribuicao"=:xempresa and "StatusDistribuicao"=''1''  ');
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

function VerificaRequisicao(XConsultado: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XConsultado.TryGetValue('ultnsu',wval) then
       wret := false;
    if not XConsultado.TryGetValue('nsu',wval) then
       wret := false;
    if not XConsultado.TryGetValue('chavenfe',wval) then
       wret := false;
    if not XConsultado.TryGetValue('status',wval) then
       wret := false;
    if not XConsultado.TryGetValue('dataemissao',wval) then
       wret := false;
    if not XConsultado.TryGetValue('valornfe',wval) then
       wret := false;
    if not XConsultado.TryGetValue('cnpjemitente',wval) then
       wret := false;
    if not XConsultado.TryGetValue('nomeemitente',wval) then
       wret := false;
    if not XConsultado.TryGetValue('protocolo',wval) then
       wret := false;
    if not XConsultado.TryGetValue('ator',wval) then
       wret := false;
  finally
  end;
  Result := wret;
end;

function IncluiConsultado(XConsultado: TJSONObject; XStatus: string): TJSONObject;
var wquery: TFDMemTable;
    wqueryInsert,wquerySelect: TFDQuery;
    wret: TJSONObject;
    wnum: integer;
    wconexao: TProviderDataModuleConexao;
    wvalor: string;
begin
  try
    wconexao     := TProviderDataModuleConexao.Create(nil);
    wqueryInsert := TFDQuery.Create(nil);
    if wconexao.EstabeleceConexaoDB then
       begin
         wvalor := StringReplace(XConsultado.GetValue('ValorNFeDistribuicao').Value,'.','',[rfReplaceAll]);
         with wqueryInsert do
         begin
           Connection := wconexao.FDConnectionApi;
           DisableControls;
           Close;
           SQL.Clear;
           Params.Clear;
           SQL.Add('Insert into "DistribuicaoDocumentoFiscal" ("CodigoEmpresaDistribuicao","UltimoNSUDistribuicao","NSUDistribuicao",');
           SQL.Add('"ChaveNFeDistribuicao","StatusDistribuicao","ArquivoSalvoDistribuicao","DataEmissaoDistribuicao","ValorNFeDistribuicao",');
           if XStatus='1' then
              SQL.Add('"XMLDistribuicao","CNPJEmitenteDistribuicao","NomeEmitenteDistribuicao","ProtocoloNFeDistribuicao","AtorDistribuicao") ')
           else
              SQL.Add('"CNPJEmitenteDistribuicao","NomeEmitenteDistribuicao","ProtocoloNFeDistribuicao","AtorDistribuicao") ');
           SQL.Add('values (:xidempresa,:xultnsu,:xnsu,:xchavenfe,:xstatus,:xarquivosalvo,:xdataemissao,');
           if XStatus='1' then
              SQL.Add(':xvalornfe,:xxml,:xcnpjemitente,:xnomeemitente,:xprotocolo,:xator) ')
           else
              SQL.Add(':xvalornfe,:xcnpjemitente,:xnomeemitente,:xprotocolo,:xator) ');
           ParamByName('xidempresa').AsInteger    := wconexao.FIdEmpresa;
           ParamByName('xultnsu').AsInteger       := strtointdef(XConsultado.GetValue('UltimoNSUDistribuicao').Value,0);
           ParamByName('xnsu').AsString           := XConsultado.GetValue('NSUDistribuicao').Value;
           ParamByName('xchavenfe').AsString      := Copy(XConsultado.GetValue('ChaveNFeDistribuicao').Value,1,50);
           ParamByName('xstatus').AsString        := XStatus;
           if XStatus='1' then
              ParamByName('xarquivosalvo').AsBoolean := false
           else
              ParamByName('xarquivosalvo').AsBoolean := true;
           ParamByName('xdataemissao').AsDateTime := strtodatedef(XConsultado.GetValue('DataEmissaoDistribuicao').Value,now);
           ParamByName('xvalornfe').AsFloat       := strtofloat(wvalor);
           if XStatus='1' then
              ParamByName('xxml').AsString           := XConsultado.GetValue('XMLDistribuicao').Value;
           ParamByName('xcnpjemitente').AsString  := XConsultado.GetValue('CNPJEmitenteDistribuicao').Value;
           ParamByName('xnomeemitente').AsString  := Copy(XConsultado.GetValue('NomeEmitenteDistribuicao').Value,1,50);
           ParamByName('xprotocolo').AsString     := Copy(XConsultado.GetValue('ProtocoloNFeDistribuicao').Value,1,50);
           ParamByName('xator').AsString          := IfThen(XStatus='1','Indefinido','Destinatário');
//           showmessage('flag0');
           ExecSQL;
//           showmessage('flag1');
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
                SQL.Add('from "DistribuicaoDocumentoFiscal" where "NSUDistribuicao"=:xnsu  ');
                ParamByName('xnsu').AsString := XConsultado.GetValue('NSUDistribuicao').Value;
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Registro incluído');
              wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
            end;
         wconexao.EncerraConexaoDB;
        end;
  except
    On E: Exception do
    begin
      wconexao.EncerraConexaoDB;
      wret := TJSONObject.Create;
      showmessage('flag5 '+E.Message);
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

function AtualizaUltimoNSU(XUltNSU,XMaxNSU: integer): boolean;
var wquery: TFDMemTable;
    wqueryInsert,wquerySelect: TFDQuery;
    wret: boolean;
    wnum: integer;
    wconexao: TProviderDataModuleConexao;
begin
  try
    wconexao     := TProviderDataModuleConexao.Create(nil);
    wqueryInsert := TFDQuery.Create(nil);
    wquerySelect := TFDQuery.Create(nil);
    if wconexao.EstabeleceConexaoDB then
       begin
         with wquerySelect do
         begin
           Connection := wconexao.FDConnectionApi;
           DisableControls;
           Close;
           SQL.Clear;
           Params.Clear;
           SQL.Add('select * from  "UltimoNSUDFe" where "CodigoEmpresaUltimoNSU"=:xidempresa ');
           ParamByName('xidempresa').AsInteger := wconexao.FIdEmpresa;
           Open;
           EnableControls;
         end;
         with wqueryInsert do
         begin
           Connection := wconexao.FDConnectionApi;
           DisableControls;
           Close;
           SQL.Clear;
           Params.Clear;
           if wquerySelect.RecordCount>0 then
              begin
                SQL.Add('update "UltimoNSUDFe" set "UltimoNSU"=:xultnsu, "MaximoNSU"=:xmaxnsu, "DataHoraUltimaConsulta"=:xdatahora ');
                SQL.Add('where "CodigoInternoUltimoNSU"=:xid ');
                ParamByName('xid').AsInteger        := wquerySelect.FieldByName('CodigoInternoUltimoNSU').AsInteger;
              end
           else
              begin
                SQL.Add('Insert into "UltimoNSUDFe" ("CodigoEmpresaUltimoNSU","UltimoNSU","MaximoNSU","DataHoraUltimaConsulta") ');
                SQL.Add('values (:xidempresa,:xultnsu,:xmaxnsu,:xdatahora) ');
                ParamByName('xid').AsInteger        := wconexao.FIdEmpresa;
              end;
           ParamByName('xultnsu').AsInteger    := XUltNSU;
           ParamByName('xmaxnsu').AsInteger    := XMaxNSU;
           ParamByName('xdatahora').AsDateTime := now;
           ExecSQL;
           EnableControls;
           wnum := RowsAffected;
         end;
         wret := wnum>0;
       end
    else
       wret := false;
  except
    On E: Exception do
    begin
      wconexao.EncerraConexaoDB;
      wret := false;
    end;
  end;
  wconexao.EncerraConexaoDB;
  Result := wret;
//  wquery.Free;
end;

function ArquivaDocumentoDFe2(XChave,XStatus: string): boolean;
var wquery: TFDMemTable;
    wqueryUpdate: TFDQuery;
    wret: boolean;
    wnum: integer;
    wconexao: TProviderDataModuleConexao;
begin
  try
    wconexao     := TProviderDataModuleConexao.Create(nil);
    wqueryUpdate := TFDQuery.Create(nil);
    if wconexao.EstabeleceConexaoDB then
       begin
         with wqueryUpdate do
         begin
           Connection := wconexao.FDConnectionApi;
           DisableControls;
           Close;
           SQL.Clear;
           Params.Clear;
           SQL.Add('update "DistribuicaoDocumentoFiscal" set "StatusDistribuicao"=:xstatus ');
           SQL.Add('where "CodigoEmpresaDistribuicao"=:xidempresa and "ChaveNFeDistribuicao"=:xchave ');
           ParamByName('xchave').AsString      := XChave;
           ParamByName('xstatus').AsString     := XStatus;
           ParamByName('xidempresa').AsInteger := wconexao.FIdEmpresa;
           ExecSQL;
           EnableControls;
           wnum := RowsAffected;
         end;
         wret := wnum>0;
       end
    else
       wret := false;
  except
    On E: Exception do
    begin
      wconexao.EncerraConexaoDB;
      wret := false;
    end;
  end;
  wconexao.EncerraConexaoDB;
  Result := wret;
//  wquery.Free;
end;


function ArquivaDocumentoDFe(XNSU: integer): boolean;
var wquery: TFDMemTable;
    wqueryUpdate: TFDQuery;
    wret: boolean;
    wnum: integer;
    wconexao: TProviderDataModuleConexao;
begin
  try
    wconexao     := TProviderDataModuleConexao.Create(nil);
    wqueryUpdate := TFDQuery.Create(nil);
    if wconexao.EstabeleceConexaoDB then
       begin
         with wqueryUpdate do
         begin
           Connection := wconexao.FDConnectionApi;
           DisableControls;
           Close;
           SQL.Clear;
           Params.Clear;
           SQL.Add('update "DistribuicaoDocumentoFiscal" set "StatusDistribuicao"=:xstatus ');
           SQL.Add('where "CodigoEmpresaDistribuicao"=:xidempresa and "NSUDistribuicao"=:xnsu ');
           ParamByName('xnsu').AsString        := inttostr(XNSU);
           ParamByName('xstatus').AsString     := '7';
           ParamByName('xidempresa').AsInteger := wconexao.FIdEmpresa;
           ExecSQL;
           EnableControls;
           wnum := RowsAffected;
         end;
         wret := wnum>0;
       end
    else
       wret := false;
  except
    On E: Exception do
    begin
      wconexao.EncerraConexaoDB;
      wret := false;
    end;
  end;
  wconexao.EncerraConexaoDB;
  Result := wret;
//  wquery.Free;
end;


function RetornaUltimoNSU: TJSONObject;
var wret: TJSONObject;
    wquerySelect: TFDQuery;
    wconexao: TProviderDataModuleConexao;
begin
  try
    wret := TJSONObject.Create;
    wconexao     := TProviderDataModuleConexao.Create(nil);
    wquerySelect := TFDQuery.Create(nil);
    if wconexao.EstabeleceConexaoDB then
       begin
         with wquerySelect do
         begin
           Connection := wconexao.FDConnectionApi;
           DisableControls;
           Close;
           SQL.Clear;
           Params.Clear;
           SQL.Add('select * from  "UltimoNSUDFe" where "CodigoEmpresaUltimoNSU"=:xidempresa ');
           ParamByName('xidempresa').AsInteger := wconexao.FIdEmpresa;
           Open;
           EnableControls;
           if RecordCount>0 then
              begin
                wret.AddPair('UltNSU',wquerySelect.FieldByName('UltimoNSU').AsString);
                wret.AddPair('MaxNSU',wquerySelect.FieldByName('MaximoNSU').AsString);
              end
           else
              begin
                wret.AddPair('UltNSU','0');
                wret.AddPair('MaxNSU','0');
              end;
         end;
       end;
  except
    On E: Exception do
    begin
      wret.AddPair('UltNSU','0');
      wret.AddPair('MaxNSU','0');
    end;
  end;
  Result := wret;
end;

function VerificaChaveNFe(XChaveNFe: string): boolean;
var wret: boolean;
    wquerySelect: TFDQuery;
    wconexao: TProviderDataModuleConexao;
begin
  try
    wconexao     := TProviderDataModuleConexao.Create(nil);
    wquerySelect := TFDQuery.Create(nil);
    if wconexao.EstabeleceConexaoDB then
       begin
         with wquerySelect do
         begin
           Connection := wconexao.FDConnectionApi;
           DisableControls;
           Close;
           SQL.Clear;
           Params.Clear;
           SQL.Add('Select "CodigoInternoDistribuicao" from "DistribuicaoDocumentoFiscal" where "ChaveNFeDistribuicao"=:XChave');
           ParamByName('XChave').asString := XChaveNFe;
           Open;
           EnableControls;
           if RecordCount=0 then
              wret := false
           else
              wret := true;
         end;
         wconexao.EncerraConexaoDB;
       end
    else
       wret := false;
  except
    wret := false;
  end;
  Result := wret;
end;

function AlteraArquivoConsultado(XChaveNFe,XNSU,XStatus: string; XSalvo: boolean): boolean;
var wret: boolean;
    wqueryUpdate: TFDQuery;
    wconexao: TProviderDataModuleConexao;
begin
  try
    wconexao     := TProviderDataModuleConexao.Create(nil);
    wqueryUpdate := TFDQuery.Create(nil);
    if wconexao.EstabeleceConexaoDB then
       begin
         with wqueryUpdate do
         begin
           Connection := wconexao.FDConnectionApi;
           DisableControls;
           Close;
           SQL.Clear;
           Params.Clear;
           SQL.Add('Update "DistribuicaoDocumentoFiscal" set "NSUDistribuicao"=:xnsu,"StatusDistribuicao"=:xstatus,"ArquivoSalvoDistribuicao"=:xsalvo ');
           SQL.Add('where "ChaveNFeDistribuicao"=:XChave');
           ParamByName('XChave').asString  := XChaveNFe;
           ParamByName('xnsu').asString    := XNSU;
           ParamByName('xstatus').asString := XStatus;
           ParamByName('xsalvo').AsBoolean := XSalvo;
           ExecSQL;
           EnableControls;
           wret := true;
         end;
         wconexao.EncerraConexaoDB;
       end
    else
       wret := false;
  except
    wret := false;
  end;
end;

function RetornaTotalConsultados(const XQuery: TDictionary<string, string>): TJSONObject;
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
         SQL.Add('Where "StatusDistribuicao"=''1'' ');
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
