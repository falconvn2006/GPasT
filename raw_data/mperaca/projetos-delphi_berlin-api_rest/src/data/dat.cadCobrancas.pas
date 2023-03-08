unit dat.cadCobrancas;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaCobranca(XId: integer): TJSONObject;
function RetornaListaCobrancas(const XQuery: TDictionary<string, string>; XLimit,XOffset: integer): TJSONArray;
function RetornaTotalCobrancas(const XQuery: TDictionary<string, string>): TJSONObject;
function IncluiCobranca(XCobranca: TJSONObject): TJSONObject;
function VerificaRequisicao(XCobranca: TJSONObject): boolean;
function AlteraCobranca(XIdCobranca: integer; XCobranca: TJSONObject): TJSONObject;
function ApagaCobranca(XIdCobranca: integer): TJSONObject;

implementation

uses prv.dataModuleConexao;

function RetornaCobranca(XId: integer): TJSONObject;
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
         SQL.Add('select "CodigoInternoCobranca" as id,');
         SQL.Add('       "NomeDocumentoCobranca" as nome, ');
         SQL.Add('       "TipoDocumentoCobranca" as tipo, ');
         SQL.Add('       "CodigoBancoCobranca"   as codbanco, ');
         SQL.Add('       "NomeBancoCobranca"     as nomebanco, ');
         SQL.Add('       "AgenciaBancoCobranca"  as agcbanco, ');
         SQL.Add('       "DigitoVerificadorAgenciaCobranca"  as digverificadoragencia, ');
         SQL.Add('       "NumeroContaCorrenteCobranca" as contacorrente, ');
         SQL.Add('       "DigitoVerificadorContaCorrenteCobranca"  as digverificadorctacorrente, ');
         SQL.Add('       "DigitoVerificadorAgenciaContaCorrenteCobranca"  as digverificadoragcctacorrente, ');
         SQL.Add('       "CodigoCedenteCobranca" as codcedente, ');
         SQL.Add('       "DiretorioRemessaCobranca" as diretorioremessa, ');
         SQL.Add('       "OperacaoCobranca"      as operacao, ');
         SQL.Add('       "CaminhoFormularioCobranca" as caminhoformulario, ');
         SQL.Add('       "VersaoLayoutArquivoCobranca" as versaolayoutarquivo, ');
         SQL.Add('       "Mensagem1BloquetoCobranca" as mensagem1bloqueto, ');
         SQL.Add('       "Mensagem2BloquetoCobranca" as mensagem2bloqueto, ');
         SQL.Add('       "CodigoMovimentoCobranca" as codmovimento, ');
         SQL.Add('       "CodigoCarteiraCobranca" as codcarteira, ');
         SQL.Add('       "FormaCadastramentoTituloCobranca" as formacadtitulo, ');
         SQL.Add('       "EmissorBloquetoCobranca" as emissorbloqueto, ');
         SQL.Add('       "EspecieTituloCobranca" as especietitulo, ');
         SQL.Add('       "TipoAceiteNaoAceiteCobranca" as tipoaceite, ');
         SQL.Add('       "CodigoJurosCobranca" as codjuros, ');
         SQL.Add('       "CodigoProtestoCobranca" as codprotesto, ');
         SQL.Add('       "ValorJurosMoraDia" as jurosmora, ');
         SQL.Add('       "GerarRemessaCobranca" as geraremessa, ');
         SQL.Add('       "CodigoBaixaDevolucaoCobranca" as codbaixadevolucao, ');
         SQL.Add('       "NumeroDiasBaixaDevolucaoCobranca" as numdiasbaixadevolucao, ');
         SQL.Add('       "ValorMultaCobranca" as valormulta, ');
         SQL.Add('       "NumeroDiasMultaCobranca" as numdiasmulta, ');
         SQL.Add('       "MetodoSequenciaCobranca" as metodosequencia, ');
         SQL.Add('       "CaminhoFormularioCobrancaParcela" as caminhoformularioparcela, ');
         SQL.Add('       "DigitoIdentificadorRemessaCobranca" as digremessa, ');
         SQL.Add('       "NumerarioQuitacaoCobranca" as idnumerarioquitacao, ');
         SQL.Add('       "CaminhoTratarArquivoCobranca" as caminhotratararquivo ');
         SQL.Add('from "DocumentoCobranca" ');
         SQL.Add('where "CodigoInternoCobranca"=:xid ');
         ParamByName('xid').AsInteger := XId;
         Open;
         EnableControls;
       end;

   if wquery.RecordCount>0 then
      wret := wquery.ToJSONObject()
   else
      begin
        wret := TJSONObject.Create;
        wret.AddPair('status','404');
        wret.AddPair('description','Nenhuma cobrança encontrada');
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

function RetornaTotalCobrancas(const XQuery: TDictionary<string, string>): TJSONObject;
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
         SQL.Add('from "DocumentoCobranca" where "CodigoEmpresaCobranca"=:xempresa ');
         if XQuery.ContainsKey('nome') then // filtro por nome
            begin
              SQL.Add('and lower("NomeDocumentoCobranca") like lower(:xnome) ');
              ParamByName('xnome').AsString := XQuery.Items['nome']+'%';
            end;
         ParamByName('xempresa').AsInteger := wconexao.FIdEmpresaCobranca;
         Open;
         EnableControls;
       end;

   if wquery.RecordCount>0 then
      wret := wquery.ToJSONObject()
   else
      begin
        wret := TJSONObject.Create;
        wret.AddPair('status','500');
        wret.AddPair('description','Nenhum documento cobrança encontrado');
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


function RetornaListaCobrancas(const XQuery: TDictionary<string, string>; XLimit,XOffset: integer): TJSONArray;
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
         SQL.Add('select "CodigoInternoCobranca" as id,');
         SQL.Add('       "NomeDocumentoCobranca" as nome, ');
         SQL.Add('       "TipoDocumentoCobranca" as tipo, ');
         SQL.Add('       "CodigoBancoCobranca"   as codbanco, ');
         SQL.Add('       "NomeBancoCobranca"     as nomebanco, ');
         SQL.Add('       "AgenciaBancoCobranca"  as agcbanco, ');
         SQL.Add('       "DigitoVerificadorAgenciaCobranca"  as digverificadoragencia, ');
         SQL.Add('       "NumeroContaCorrenteCobranca" as contacorrente, ');
         SQL.Add('       "DigitoVerificadorContaCorrenteCobranca"  as digverificadorctacorrente, ');
         SQL.Add('       "DigitoVerificadorAgenciaContaCorrenteCobranca"  as digverificadoragcctacorrente, ');
         SQL.Add('       "CodigoCedenteCobranca" as codcedente, ');
         SQL.Add('       "DiretorioRemessaCobranca" as diretorioremessa, ');
         SQL.Add('       "OperacaoCobranca"      as operacao, ');
         SQL.Add('       "CaminhoFormularioCobranca" as caminhoformulario, ');
         SQL.Add('       "VersaoLayoutArquivoCobranca" as versaolayoutarquivo, ');
         SQL.Add('       "Mensagem1BloquetoCobranca" as mensagem1bloqueto, ');
         SQL.Add('       "Mensagem2BloquetoCobranca" as mensagem2bloqueto, ');
         SQL.Add('       "CodigoMovimentoCobranca" as codmovimento, ');
         SQL.Add('       "CodigoCarteiraCobranca" as codcarteira, ');
         SQL.Add('       "FormaCadastramentoTituloCobranca" as formacadtitulo, ');
         SQL.Add('       "EmissorBloquetoCobranca" as emissorbloqueto, ');
         SQL.Add('       "EspecieTituloCobranca" as especietitulo, ');
         SQL.Add('       "TipoAceiteNaoAceiteCobranca" as tipoaceite, ');
         SQL.Add('       "CodigoJurosCobranca" as codjuros, ');
         SQL.Add('       "CodigoProtestoCobranca" as codprotesto, ');
         SQL.Add('       "ValorJurosMoraDia" as jurosmora, ');
         SQL.Add('       "GerarRemessaCobranca" as geraremessa, ');
         SQL.Add('       "CodigoBaixaDevolucaoCobranca" as codbaixadevolucao, ');
         SQL.Add('       "NumeroDiasBaixaDevolucaoCobranca" as numdiasbaixadevolucao, ');
         SQL.Add('       "ValorMultaCobranca" as valormulta, ');
         SQL.Add('       "NumeroDiasMultaCobranca" as numdiasmulta, ');
         SQL.Add('       "MetodoSequenciaCobranca" as metodosequencia, ');
         SQL.Add('       "CaminhoFormularioCobrancaParcela" as caminhoformularioparcela, ');
         SQL.Add('       "DigitoIdentificadorRemessaCobranca" as digremessa, ');
         SQL.Add('       "NumerarioQuitacaoCobranca" as idnumerarioquitacao, ');
         SQL.Add('       "CaminhoTratarArquivoCobranca" as caminhotratararquivo ');

         SQL.Add('from "DocumentoCobranca" where "CodigoEmpresaCobranca"=:xempresa ');
         ParamByName('xempresa').AsInteger := wconexao.FIdEmpresaCobranca;

         if XQuery.ContainsKey('nome') then // filtro por nome
            begin
              SQL.Add('and lower("NomeDocumentoCobranca") like lower(:xnome) ');
              ParamByName('xnome').AsString := XQuery.Items['nome']+'%';
            end;
         SQL.Add('order by "NomeDocumentoCobranca" ');
         Open;
         EnableControls;
       end;
    if wqueryLista.RecordCount>0 then
       wret := wqueryLista.ToJSONArray()
    else
       begin
         wobj := TJSONObject.Create;
         wobj.AddPair('status','404');
         wobj.AddPair('description','Nenhuma cobrança encontrada');
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

function IncluiCobranca(XCobranca: TJSONObject): TJSONObject;
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
           SQL.Add('Insert into "DocumentoCobranca" ("CodigoEmpresaCobranca","NomeDocumentoCobranca","TipoDocumentoCobranca","CodigoBancoCobranca","NomeBancoCobranca",');
           SQL.Add('"CodigoCedenteCobranca","DiretorioRemessaCobranca","OperacaoCobranca","CaminhoFormularioCobranca","ImpressoraDestinoCobranca","AgenciaBancoCobranca",');
           SQL.Add('"DigitoVerificadorAgenciaCobranca","NumeroContaCorrenteCobranca","DigitoVerificadorContaCorrenteCobranca","VersaoLayoutArquivoCobranca",');
           SQL.Add('"Mensagem1BloquetoCobranca","Mensagem2BloquetoCobranca","CodigoMovimentoCobranca","CodigoCarteiraCobranca","FormaCadastramentoTituloCobranca",');
           SQL.Add('"EmissorBloquetoCobranca","EspecieTituloCobranca","TipoAceiteNaoAceiteCobranca","CodigoJurosCobranca","CodigoProtestoCobranca","NumeroDiasProtestoCobranca",');
           SQL.Add('"ValorJurosMoraDia","GerarRemessaCobranca","DigitoVerificadorAgenciaContaCorrenteCobranca","CodigoBaixaDevolucaoCobranca","NumeroDiasBaixaDevolucaoCobranca",');
           SQL.Add('"ValorMultaCobranca","NumeroDiasMultaCobranca","MetodoSequenciaCobranca","CaminhoFormularioCobrancaParcela","DigitoIdentificadorRemessaCobranca",');
           SQL.Add('"NumerarioQuitacaoCobranca","CaminhoTratarArquivoCobranca") ');

           SQL.Add('values (:xidempresa,:xnome,:xtipo,:xcodbanco,:xnomebanco,');
           SQL.Add(':xcodcedente,:xdiretorioremessa,:xoperacao,:xcaminhoformulario,:ximpressoradestino,:xagcbanco,');
           SQL.Add(':xdigverificadoragencia,:xcontacorrente,:xdigverificadorcontacorrente,:xversaolayoutarquivo,');
           SQL.Add(':xmensagem1bloqueto,:xmensagem2bloqueto,:xcodmovimento,:xcodcarteira,:xformacadtitulo,');
           SQL.Add(':xemissorbloqueto,:xespecietitulo,:xtipoaceite,:xcodjuros,:xcodprotesto,:xnumdiasprotesto,');
           SQL.Add(':xvalorjurosmora,:xgeraremessa,:xdigverificadoragcctacorrente,:xcodbaixadevolucao,:xnumdiasbaixadevolucao,');
           SQL.Add(':xvalormulta,:xnumdiasmulta,:xmetodosequencia,:xcaminhoformularioparcela,:xdigremessa,');
           SQL.Add(':xidnumerarioquitacao,:xcaminhotratararquivo) ');

           ParamByName('xidempresa').AsInteger   := wconexao.FIdEmpresaCobranca;
           ParamByName('xnome').AsString         := XCobranca.GetValue('nome').Value;
           ParamByName('xtipo').AsString         := XCobranca.GetValue('tipo').Value;
           if XCobranca.TryGetValue('codbanco',wval) then
              ParamByName('xcodbanco').AsString  := XCobranca.GetValue('codbanco').Value
           else
              ParamByName('xcodbanco').AsString  := '';
           if XCobranca.TryGetValue('nomebanco',wval) then
              ParamByName('xnomebanco').AsString  := XCobranca.GetValue('nomebanco').Value
           else
              ParamByName('xnomebanco').AsString  := '';
           if XCobranca.TryGetValue('codcedente',wval) then
              ParamByName('xcodcedente').AsString  := XCobranca.GetValue('codcedente').Value
           else
              ParamByName('xcodcedente').AsString  := '';
           if XCobranca.TryGetValue('diretorioremessa',wval) then
              ParamByName('xdiretorioremessa').AsString  := XCobranca.GetValue('diretorioremessa').Value
           else
              ParamByName('xdiretorioremessa').AsString  := '';
           if XCobranca.TryGetValue('operacao',wval) then
              ParamByName('xoperacao').AsString  := XCobranca.GetValue('operacao').Value
           else
              ParamByName('xoperacao').AsString  := 'E';
           if XCobranca.TryGetValue('caminhoformulario',wval) then
              ParamByName('xcaminhoformulario').AsString  := XCobranca.GetValue('caminhoformulario').Value
           else
              ParamByName('xcaminhoformulario').AsString  := '';
           if XCobranca.TryGetValue('impressoradestino',wval) then
              ParamByName('ximpressoradestino').AsString  := XCobranca.GetValue('impressoradestino').Value
           else
              ParamByName('ximpressoradestino').AsString  := '';
           if XCobranca.TryGetValue('agcbanco',wval) then
              ParamByName('xagcbanco').AsString  := XCobranca.GetValue('agcbanco').Value
           else
              ParamByName('xagcbanco').AsString  := '';
           if XCobranca.TryGetValue('digverificadoragencia',wval) then
              ParamByName('xdigverificadoragencia').AsString  := XCobranca.GetValue('digverificadoragencia').Value
           else
              ParamByName('xdigverificadoragencia').AsString  := '';
           if XCobranca.TryGetValue('contacorrente',wval) then
              ParamByName('xcontacorrente').AsString  := XCobranca.GetValue('contacorrente').Value
           else
              ParamByName('xcontacorrente').AsString  := '';
           if XCobranca.TryGetValue('digverificadorcontacorrente',wval) then
              ParamByName('xdigverificadorcontacorrente').AsString  := XCobranca.GetValue('digverificadorcontacorrente').Value
           else
              ParamByName('xdigverificadorcontacorrente').AsString  := '';
           if XCobranca.TryGetValue('versaolayoutarquivo',wval) then
              ParamByName('xversaolayoutarquivo').AsString  := XCobranca.GetValue('versaolayoutarquivo').Value
           else
              ParamByName('xversaolayoutarquivo').AsString  := '';
           if XCobranca.TryGetValue('mensagem1bloqueto',wval) then
              ParamByName('xmensagem1bloqueto').AsString  := XCobranca.GetValue('mensagem1bloqueto').Value
           else
              ParamByName('xmensagem1bloqueto').AsString  := '';
           if XCobranca.TryGetValue('mensagem2bloqueto',wval) then
              ParamByName('xmensagem2bloqueto').AsString  := XCobranca.GetValue('mensagem2bloqueto').Value
           else
              ParamByName('xmensagem2bloqueto').AsString  := '';
           if XCobranca.TryGetValue('codmovimento',wval) then
              ParamByName('xcodmovimento').AsString  := XCobranca.GetValue('codmovimento').Value
           else
              ParamByName('xcodmovimento').AsString  := '';
           if XCobranca.TryGetValue('codcarteira',wval) then
              ParamByName('xcodcarteira').AsString  := XCobranca.GetValue('codcarteira').Value
           else
              ParamByName('xcodcarteira').AsString  := '';
           if XCobranca.TryGetValue('formacadtitulo',wval) then
              ParamByName('xformacadtitulo').AsString  := XCobranca.GetValue('formacadtitulo').Value
           else
              ParamByName('xformacadtitulo').AsString  := '';
           if XCobranca.TryGetValue('emissorbloqueto',wval) then
              ParamByName('xemissorbloqueto').AsString  := XCobranca.GetValue('emissorbloqueto').Value
           else
              ParamByName('xemissorbloqueto').AsString  := '';
           if XCobranca.TryGetValue('especietitulo',wval) then
              ParamByName('xespecietitulo').AsString  := XCobranca.GetValue('especietitulo').Value
           else
              ParamByName('xespecietitulo').AsString  := '';
           if XCobranca.TryGetValue('tipoaceite',wval) then
              ParamByName('xtipoaceite').AsString  := XCobranca.GetValue('tipoaceite').Value
           else
              ParamByName('xtipoaceite').AsString  := '';
           if XCobranca.TryGetValue('codjuros',wval) then
              ParamByName('xcodjuros').AsString  := XCobranca.GetValue('codjuros').Value
           else
              ParamByName('xcodjuros').AsString  := '';
           if XCobranca.TryGetValue('codprotesto',wval) then
              ParamByName('xcodprotesto').AsString  := XCobranca.GetValue('codprotesto').Value
           else
              ParamByName('xcodprotesto').AsString  := '';
           if XCobranca.TryGetValue('numdiasprotesto',wval) then
              ParamByName('xnumdiasprotesto').AsString  := XCobranca.GetValue('numdiasprotesto').Value
           else
              ParamByName('xnumdiasprotesto').AsString  := '';
           if XCobranca.TryGetValue('valorjurosmora',wval) then
              ParamByName('xvalorjurosmora').AsFloat  := strtofloatdef(XCobranca.GetValue('valorjurosmorao').Value,0)
           else
              ParamByName('xvalorjurosmora').AsFloat  := 0;
           if XCobranca.TryGetValue('geraremessa',wval) then
              ParamByName('xgeraremessa').AsBoolean  := strtobooldef(XCobranca.GetValue('geraremessa').Value,false)
           else
              ParamByName('xgeraremessa').AsBoolean  := false;
           if XCobranca.TryGetValue('digverificadoragcctacorrente',wval) then
              ParamByName('xdigverificadoragcctacorrente').AsString  := XCobranca.GetValue('digverificadoragcctacorrente').Value
           else
              ParamByName('xdigverificadoragcctacorrente').AsString  := '';
           if XCobranca.TryGetValue('codbaixadevolucao',wval) then
              ParamByName('xcodbaixadevolucao').AsString  := XCobranca.GetValue('codbaixadevolucao').Value
           else
              ParamByName('xcodbaixadevolucao').AsString  := '';
           if XCobranca.TryGetValue('numdiasbaixadevolucao',wval) then
              ParamByName('xnumdiasbaixadevolucao').AsString  := XCobranca.GetValue('numdiasbaixadevolucao').Value
           else
              ParamByName('xnumdiasbaixadevolucao').AsString  := '';
           if XCobranca.TryGetValue('valormulta',wval) then
              ParamByName('xvalormulta').AsFloat  := strtofloatdef(XCobranca.GetValue('valormulta').Value,0)
           else
              ParamByName('xvalormulta').AsFloat  := 0;
           if XCobranca.TryGetValue('numdiasmulta',wval) then
              ParamByName('xnumdiasmulta').AsInteger  := strtointdef(XCobranca.GetValue('numdiasmulta').Value,0)
           else
              ParamByName('xnumdiasmulta').AsInteger  := 0;
           if XCobranca.TryGetValue('metodosequencia',wval) then
              ParamByName('xmetodosequencia').AsInteger  := strtointdef(XCobranca.GetValue('metodosequencia').Value,0)
           else
              ParamByName('xmetodosequencia').AsInteger  := 0;
           if XCobranca.TryGetValue('caminhoformularioparcela',wval) then
              ParamByName('xcaminhoformularioparcela').AsString  := XCobranca.GetValue('caminhoformularioparcela').Value
           else
              ParamByName('xcaminhoformularioparcela').AsString  := '';
           if XCobranca.TryGetValue('digremessa',wval) then
              ParamByName('xdigremessa').AsString  := XCobranca.GetValue('digremessa').Value
           else
              ParamByName('xdigremessa').AsString  := '';
           if XCobranca.TryGetValue('idnumerarioquitacao',wval) then
              ParamByName('xidnumerarioquitacao').AsInteger  := strtointdef(XCobranca.GetValue('idnumerarioquitacao').Value,0)
           else
              ParamByName('xidnumerarioquitacao').AsInteger  := 0;
           if XCobranca.TryGetValue('caminhotratararquivo',wval) then
              ParamByName('xcaminhotratararquivo').AsString  := XCobranca.GetValue('caminhotratararquivo').Value
           else
              ParamByName('xcaminhotratararquivo').AsString  := '';

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
                SQL.Add('select "CodigoInternoCobranca" as id,');
                SQL.Add('       "NomeDocumentoCobranca" as nome, ');
                SQL.Add('       "TipoDocumentoCobranca" as tipo, ');
                SQL.Add('       "CodigoBancoCobranca"   as codbanco, ');
                SQL.Add('       "NomeBancoCobranca"     as nomebanco, ');
                SQL.Add('       "AgenciaBancoCobranca"  as agcbanco, ');
                SQL.Add('       "DigitoVerificadorAgenciaCobranca"  as digverificadoragencia, ');
                SQL.Add('       "NumeroContaCorrenteCobranca" as contacorrente, ');
                SQL.Add('       "DigitoVerificadorContaCorrenteCobranca"  as digverificadorctacorrente, ');
                SQL.Add('       "DigitoVerificadorAgenciaContaCorrenteCobranca"  as digverificadoragcctacorrente, ');
                SQL.Add('       "CodigoCedenteCobranca" as codcedente, ');
                SQL.Add('       "DiretorioRemessaCobranca" as diretorioremessa, ');
                SQL.Add('       "OperacaoCobranca"      as operacao, ');
                SQL.Add('       "CaminhoFormularioCobranca" as caminhoformulario, ');
                SQL.Add('       "VersaoLayoutArquivoCobranca" as versaolayoutarquivo, ');
                SQL.Add('       "Mensagem1BloquetoCobranca" as mensagem1bloqueto, ');
                SQL.Add('       "Mensagem2BloquetoCobranca" as mensagem2bloqueto, ');
                SQL.Add('       "CodigoMovimentoCobranca" as codmovimento, ');
                SQL.Add('       "CodigoCarteiraCobranca" as codcarteira, ');
                SQL.Add('       "FormaCadastramentoTituloCobranca" as formacadtitulo, ');
                SQL.Add('       "EmissorBloquetoCobranca" as emissorbloqueto, ');
                SQL.Add('       "EspecieTituloCobranca" as especietitulo, ');
                SQL.Add('       "TipoAceiteNaoAceiteCobranca" as tipoaceite, ');
                SQL.Add('       "CodigoJurosCobranca" as codjuros, ');
                SQL.Add('       "CodigoProtestoCobranca" as codprotesto, ');
                SQL.Add('       "ValorJurosMoraDia" as jurosmora, ');
                SQL.Add('       "GerarRemessaCobranca" as geraremessa, ');
                SQL.Add('       "CodigoBaixaDevolucaoCobranca" as codbaixadevolucao, ');
                SQL.Add('       "NumeroDiasBaixaDevolucaoCobranca" as numdiasbaixadevolucao, ');
                SQL.Add('       "ValorMultaCobranca" as valormulta, ');
                SQL.Add('       "NumeroDiasMultaCobranca" as numdiasmulta, ');
                SQL.Add('       "MetodoSequenciaCobranca" as metodosequencia, ');
                SQL.Add('       "CaminhoFormularioCobrancaParcela" as caminhoformularioparcela, ');
                SQL.Add('       "DigitoIdentificadorRemessaCobranca" as digremessa, ');
                SQL.Add('       "NumerarioQuitacaoCobranca" as idnumerarioquitacao, ');
                SQL.Add('       "CaminhoTratarArquivoCobranca" as caminhotratararquivo ');

                SQL.Add('from "DocumentoCobranca" where "CodigoEmpresaCobranca"=:xempresa and "NomeDocumentoCobranca"=:xnome ');
                ParamByName('xempresa').AsInteger := wconexao.FIdEmpresaCobranca;
                ParamByName('xnome').AsString     := XCobranca.GetValue('nome').Value;
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhuma Cobrança incluída');
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

function VerificaRequisicao(XCobranca: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XCobranca.TryGetValue('nome',wval) then
       wret := false;
    if not XCobranca.TryGetValue('tipo',wval) then
       wret := false;
    if not XCobranca.TryGetValue('operacao',wval) then
       wret := false;
  finally
  end;
  Result := wret;
end;

function AlteraCobranca(XIdCobranca: integer; XCobranca: TJSONObject): TJSONObject;
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
    if XCobranca.TryGetValue('nome',wval) then
       begin
         if wcampos='' then
            wcampos := '"NomeDocumentoCobranca"=:xnome'
         else
            wcampos := wcampos+',"NomeDocumentoCobranca"=:xnome';
       end;
    if XCobranca.TryGetValue('tipo',wval) then
       begin
         if wcampos='' then
            wcampos := '"TipoDocumentoCobranca"=:xtipo'
         else
            wcampos := wcampos+',"TipoDocumentoCobranca"=:xtipo';
       end;
    if XCobranca.TryGetValue('codbanco',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoBancoCobranca"=:xcodbanco'
         else
            wcampos := wcampos+',"CodigoBancoCobranca"=:xcodbanco';
       end;
    if XCobranca.TryGetValue('nomebanco',wval) then
       begin
         if wcampos='' then
            wcampos := '"NomeBancoCobranca"=:xnomebanco'
         else
            wcampos := wcampos+',"NomeBancoCobranca"=:xnomebanco';
       end;
    if XCobranca.TryGetValue('codcedente',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoCedenteCobranca"=:xcodcedente'
         else
            wcampos := wcampos+',"CodigoCedenteCobranca"=:xcodcedente';
       end;
    if XCobranca.TryGetValue('diretorioremessa',wval) then
       begin
         if wcampos='' then
            wcampos := '"DiretorioRemessaCobranca"=:xdiretorioremessa'
         else
            wcampos := wcampos+',"DiretorioRemessaCobranca"=:xdiretorioremessa';
       end;
    if XCobranca.TryGetValue('operacao',wval) then
       begin
         if wcampos='' then
            wcampos := '"OperacaoCobranca"=:xoperacao'
         else
            wcampos := wcampos+',"OperacaoCobranca"=:xoperacao';
       end;
    if XCobranca.TryGetValue('caminhoformulario',wval) then
       begin
         if wcampos='' then
            wcampos := '"CaminhoFormularioCobranca"=:xcaminhoformulario'
         else
            wcampos := wcampos+',"CaminhoFormularioCobranca"=:xcaminhoformulario';
       end;
    if XCobranca.TryGetValue('impressoradestino',wval) then
       begin
         if wcampos='' then
            wcampos := '"ImpressoraDestinoCobranca"=:ximpressoradestino'
         else
            wcampos := wcampos+',"ImpressoraDestinoCobranca"=:ximpressoradestino';
       end;
    if XCobranca.TryGetValue('agcbanco',wval) then
       begin
         if wcampos='' then
            wcampos := '"AgenciaBancoCobranca"=:xagcbanco'
         else
            wcampos := wcampos+',"AgenciaBancoCobranca"=:xagcbanco';
       end;
    if XCobranca.TryGetValue('digverificadoragencia',wval) then
       begin
         if wcampos='' then
            wcampos := '"DigitoVerificadorAgenciaCobranca"=:xdigverificadoragencia'
         else
            wcampos := wcampos+',"DigitoVerificadorAgenciaCobranca"=:xdigverificadoragencia';
       end;
    if XCobranca.TryGetValue('contacorrente',wval) then
       begin
         if wcampos='' then
            wcampos := '"NumeroContaCorrenteCobranca"=:xcontacorrente'
         else
            wcampos := wcampos+',"NumeroContaCorrenteCobranca"=:xcontacorrente';
       end;
    if XCobranca.TryGetValue('digverificadorcontacorrente',wval) then
       begin
         if wcampos='' then
            wcampos := '"DigitoVerificadorContaCorrenteCobranca"=:xdigverificadorcontacorrente'
         else
            wcampos := wcampos+',"DigitoVerificadorContaCorrenteCobranca"=:xdigverificadorcontacorrente';
       end;
    if XCobranca.TryGetValue('versaolayoutarquivo',wval) then
       begin
         if wcampos='' then
            wcampos := '"VersaoLayoutArquivoCobranca"=:xversaolayoutarquivo'
         else
            wcampos := wcampos+',"VersaoLayoutArquivoCobranca"=:xversaolayoutarquivo';
       end;
    if XCobranca.TryGetValue('mensagem1bloqueto',wval) then
       begin
         if wcampos='' then
            wcampos := '"Mensagem1BloquetoCobranca"=:xmensagem1bloqueto'
         else
            wcampos := wcampos+',"Mensagem1BloquetoCobranca"=:xmensagem1bloqueto';
       end;
    if XCobranca.TryGetValue('mensagem2bloqueto',wval) then
       begin
         if wcampos='' then
            wcampos := '"Mensagem2BloquetoCobranca"=:xmensagem2bloqueto'
         else
            wcampos := wcampos+',"Mensagem2BloquetoCobranca"=:xmensagem2bloqueto';
       end;
    if XCobranca.TryGetValue('codmovimento',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoMovimentoCobranca"=:xcodmovimento'
         else
            wcampos := wcampos+',"CodigoMovimentoCobranca"=:xcodmovimento';
       end;
    if XCobranca.TryGetValue('codcarteira',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoCarteiraCobranca"=:xcodcarteira'
         else
            wcampos := wcampos+',"CodigoCarteiraCobranca"=:xcodcarteira';
       end;
    if XCobranca.TryGetValue('formacadtitulo',wval) then
       begin
         if wcampos='' then
            wcampos := '"FormaCadastramentoTituloCobranca"=:xformacadtitulo'
         else
            wcampos := wcampos+',"FormaCadastramentoTituloCobranca"=:xformacadtitulo';
       end;
    if XCobranca.TryGetValue('emissorbloqueto',wval) then
       begin
         if wcampos='' then
            wcampos := '"EmissorBloquetoCobranca"=:xemissorbloqueto'
         else
            wcampos := wcampos+',"EmissorBloquetoCobranca"=:xemissorbloqueto';
       end;
    if XCobranca.TryGetValue('especietitulo',wval) then
       begin
         if wcampos='' then
            wcampos := '"EspecieTituloCobranca"=:xespecietitulo'
         else
            wcampos := wcampos+',"EspecieTituloCobranca"=:xespecietitulo';
       end;
    if XCobranca.TryGetValue('tipoaceite',wval) then
       begin
         if wcampos='' then
            wcampos := '"TipoAceiteNaoAceiteCobranca"=:xtipoaceite'
         else
            wcampos := wcampos+',"TipoAceiteNaoAceiteCobranca"=:xtipoaceite';
       end;
    if XCobranca.TryGetValue('codjuros',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoJurosCobranca"=:xcodjuros'
         else
            wcampos := wcampos+',"CodigoJurosCobranca"=:xcodjuros';
       end;
    if XCobranca.TryGetValue('codprotesto',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoProtestoCobranca"=:xcodprotesto'
         else
            wcampos := wcampos+',"CodigoProtestoCobranca"=:xcodprotesto';
       end;
    if XCobranca.TryGetValue('numdiasprotesto',wval) then
       begin
         if wcampos='' then
            wcampos := '"NumeroDiasProtestoCobranca"=:xnumdiasprotesto'
         else
            wcampos := wcampos+',"NumeroDiasProtestoCobranca"=:xnumdiasprotesto';
       end;
    if XCobranca.TryGetValue('valorjurosmora',wval) then
       begin
         if wcampos='' then
            wcampos := '"ValorJurosMoraDia"=:xvalorjurosmora'
         else
            wcampos := wcampos+',"ValorJurosMoraDia"=:xvalorjurosmora';
       end;
    if XCobranca.TryGetValue('geraremessa',wval) then
       begin
         if wcampos='' then
            wcampos := '"GerarRemessaCobranca"=:xgeraremessa'
         else
            wcampos := wcampos+',"GerarRemessaCobranca"=:xgeraremessa';
       end;
    if XCobranca.TryGetValue('digverificadoragcctacorrente',wval) then
       begin
         if wcampos='' then
            wcampos := '"DigitoVerificadorAgenciaContaCorrenteCobranca"=:xdigverificadoragcctacorrente'
         else
            wcampos := wcampos+',"DigitoVerificadorAgenciaContaCorrenteCobranca"=:xdigverificadoragcctacorrente';
       end;
    if XCobranca.TryGetValue('codbaixadevolucao',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoBaixaDevolucaoCobranca"=:xcodbaixadevolucao'
         else
            wcampos := wcampos+',"CodigoBaixaDevolucaoCobranca"=:xcodbaixadevolucao';
       end;
    if XCobranca.TryGetValue('numdiasbaixadevolucao',wval) then
       begin
         if wcampos='' then
            wcampos := '"NumeroDiasBaixaDevolucaoCobranca"=:xnumdiasbaixadevolucao'
         else
            wcampos := wcampos+',"NumeroDiasBaixaDevolucaoCobranca"=:xnumdiasbaixadevolucao';
       end;
    if XCobranca.TryGetValue('valormulta',wval) then
       begin
         if wcampos='' then
            wcampos := '"ValorMultaCobranca"=:xvalormulta'
         else
            wcampos := wcampos+',"ValorMultaCobranca"=:xvalormulta';
       end;
    if XCobranca.TryGetValue('numdiasmulta',wval) then
       begin
         if wcampos='' then
            wcampos := '"NumeroDiasMultaCobranca"=:xnumdiasmulta'
         else
            wcampos := wcampos+',"NumeroDiasMultaCobranca"=:xnumdiasmulta';
       end;
    if XCobranca.TryGetValue('metodosequencia',wval) then
       begin
         if wcampos='' then
            wcampos := '"MetodoSequenciaCobranca"=:xmetodosequencia'
         else
            wcampos := wcampos+',"MetodoSequenciaCobranca"=:xmetodosequencia';
       end;
    if XCobranca.TryGetValue('caminhoformularioparcela',wval) then
       begin
         if wcampos='' then
            wcampos := '"CaminhoFormularioCobrancaParcela"=:xcaminhoformularioparcela'
         else
            wcampos := wcampos+',"CaminhoFormularioCobrancaParcela"=:xcaminhoformularioparcela';
       end;
    if XCobranca.TryGetValue('digremessa',wval) then
       begin
         if wcampos='' then
            wcampos := '"DigitoIdentificadorRemessaCobranca"=:xdigremessa'
         else
            wcampos := wcampos+',"DigitoVerificadorRemessaCobranca"=:xdigremessa';
       end;
    if XCobranca.TryGetValue('idnumerarioquitacao',wval) then
       begin
         if wcampos='' then
            wcampos := '"NumerarioQuitacaoCobranca"=:xidnumerarioquitacao'
         else
            wcampos := wcampos+',"NumerarioQuitacaoCobranca"=:xidnumerarioquitacao';
       end;
    if XCobranca.TryGetValue('caminhotratararquivo',wval) then
       begin
         if wcampos='' then
            wcampos := '"CaminhoTratarArquivoCobranca"=:xcaminhotratararquivo'
         else
            wcampos := wcampos+',"CaminhoTratarArquivoCobranca"=:xcaminhotratararquivo';
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
           SQL.Add('Update "DocumentoCobranca" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoCobranca"=:xid ');
           ParamByName('xid').AsInteger      := XIdCobranca;
           if XCobranca.TryGetValue('nome',wval) then
              ParamByName('xnome').AsString  := XCobranca.GetValue('nome').Value;
           if XCobranca.TryGetValue('tipo',wval) then
              ParamByName('xtipo').AsString  := XCobranca.GetValue('tipo').Value;
           if XCobranca.TryGetValue('codbanco',wval) then
              ParamByName('xcodbanco').AsString  := XCobranca.GetValue('codbanco').Value;
           if XCobranca.TryGetValue('nomebanco',wval) then
              ParamByName('xnomebanco').AsString  := XCobranca.GetValue('nomebanco').Value;
           if XCobranca.TryGetValue('codcedente',wval) then
              ParamByName('xcodcedente').AsString  := XCobranca.GetValue('codcedente').Value;
           if XCobranca.TryGetValue('diretorioremessa',wval) then
              ParamByName('xdiretorioremessa').AsString  := XCobranca.GetValue('diretorioremessa').Value;
           if XCobranca.TryGetValue('operacao',wval) then
              ParamByName('xoperacao').AsString  := XCobranca.GetValue('operacao').Value;
           if XCobranca.TryGetValue('caminhoformulario',wval) then
              ParamByName('xcaminhoformulario').AsString  := XCobranca.GetValue('caminhoformulario').Value;
           if XCobranca.TryGetValue('impressoradestino',wval) then
              ParamByName('ximpressoradestino').AsString  := XCobranca.GetValue('impressoradestino').Value;
           if XCobranca.TryGetValue('agcbanco',wval) then
              ParamByName('xagcbanco').AsString  := XCobranca.GetValue('agcbanco').Value;
           if XCobranca.TryGetValue('digverificadoragencia',wval) then
              ParamByName('xdigverificadoragencia').AsString  := XCobranca.GetValue('digverificadoragencia').Value;
           if XCobranca.TryGetValue('contacorrente',wval) then
              ParamByName('xcontacorrente').AsString  := XCobranca.GetValue('contacorrente').Value;
           if XCobranca.TryGetValue('digverificadorcontacorrente',wval) then
              ParamByName('xdigverificadorcontacorrente').AsString  := XCobranca.GetValue('digverificadorcontacorrente').Value;
           if XCobranca.TryGetValue('versaolayoutarquivo',wval) then
              ParamByName('xversaolayoutarquivo').AsString  := XCobranca.GetValue('versaolayoutarquivo').Value;
           if XCobranca.TryGetValue('mensagem1bloqueto',wval) then
              ParamByName('xmensagem1bloqueto').AsString  := XCobranca.GetValue('mensagem1bloqueto').Value;
           if XCobranca.TryGetValue('mensagem2bloqueto',wval) then
              ParamByName('xmensagem2bloqueto').AsString  := XCobranca.GetValue('mensagem2bloqueto').Value;
           if XCobranca.TryGetValue('codmovimento',wval) then
              ParamByName('xcodmovimento').AsString  := XCobranca.GetValue('codmovimento').Value;
           if XCobranca.TryGetValue('codcarteira',wval) then
              ParamByName('xcodcarteira').AsString  := XCobranca.GetValue('codcarteira').Value;
           if XCobranca.TryGetValue('formacadtitulo',wval) then
              ParamByName('xformacadtitulo').AsString  := XCobranca.GetValue('formacadtitulo').Value;
           if XCobranca.TryGetValue('emissorbloqueto',wval) then
              ParamByName('xemissorbloqueto').AsString  := XCobranca.GetValue('emissorbloqueto').Value;
           if XCobranca.TryGetValue('especietitulo',wval) then
              ParamByName('xespecietitulo').AsString  := XCobranca.GetValue('especietitulo').Value;
           if XCobranca.TryGetValue('tipoaceite',wval) then
              ParamByName('xtipoaceite').AsString  := XCobranca.GetValue('tipoaceite').Value;
           if XCobranca.TryGetValue('codjuros',wval) then
              ParamByName('xcodjuros').AsString  := XCobranca.GetValue('codjuros').Value;
           if XCobranca.TryGetValue('codprotesto',wval) then
              ParamByName('xcodprotesto').AsString  := XCobranca.GetValue('codprotesto').Value;
           if XCobranca.TryGetValue('numdiasprotesto',wval) then
              ParamByName('xnumdiasprotesto').AsString  := XCobranca.GetValue('numdiasprotesto').Value;
           if XCobranca.TryGetValue('valorjurosmora',wval) then
              ParamByName('xvalorjurosmora').AsFloat  := strtofloatdef(XCobranca.GetValue('valorjurosmora').Value,0);
           if XCobranca.TryGetValue('geraremessa',wval) then
              ParamByName('xgeraremessa').AsBoolean  := strtobooldef(XCobranca.GetValue('geraremessa').Value,false);
           if XCobranca.TryGetValue('digverificadoragcctacorrente',wval) then
              ParamByName('xdigverificadoragcctacorrente').AsString  := XCobranca.GetValue('digverificadoragcctacorrente').Value;
           if XCobranca.TryGetValue('codbaixadevolucao',wval) then
              ParamByName('xcodbaixadevolucao').AsString  := XCobranca.GetValue('codbaixadevolucao').Value;
           if XCobranca.TryGetValue('numdiasbaixadevolucao',wval) then
              ParamByName('xnumdiasbaixadevolucao').AsString  := XCobranca.GetValue('numdiasbaixadevolucao').Value;
           if XCobranca.TryGetValue('valormulta',wval) then
              ParamByName('xvalormulta').AsFloat  := strtofloatdef(XCobranca.GetValue('valormulta').Value,0);
           if XCobranca.TryGetValue('numdiasmulta',wval) then
              ParamByName('xnumdiasmulta').AsInteger  := strtointdef(XCobranca.GetValue('numdiasmulta').Value,0);
           if XCobranca.TryGetValue('metodosequencia',wval) then
              ParamByName('xmetodosequencia').AsInteger  := strtointdef(XCobranca.GetValue('metodosequencia').Value,0);
           if XCobranca.TryGetValue('caminhoformularioparcela',wval) then
              ParamByName('xcaminhoformularioparcela').AsString  := XCobranca.GetValue('caminhoformularioparcela').Value;
           if XCobranca.TryGetValue('digremessa',wval) then
              ParamByName('xdigremessa').AsString  := XCobranca.GetValue('digremessa').Value;
           if XCobranca.TryGetValue('idnumerarioquitacao',wval) then
              ParamByName('xidnumerarioquitacao').AsInteger  := strtointdef(XCobranca.GetValue('idnumerarioquitacao').Value,0);
           if XCobranca.TryGetValue('caminhotratararquivo',wval) then
              ParamByName('xcaminhotratararquivo').AsString  := XCobranca.GetValue('caminhotratararquivo').Value;

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
              SQL.Add('select "CodigoInternoCobranca" as id,');
              SQL.Add('       "NomeDocumentoCobranca" as nome, ');
              SQL.Add('       "TipoDocumentoCobranca" as tipo, ');
              SQL.Add('       "CodigoBancoCobranca"   as codbanco, ');
              SQL.Add('       "NomeBancoCobranca"     as nomebanco, ');
              SQL.Add('       "AgenciaBancoCobranca"  as agcbanco, ');
              SQL.Add('       "DigitoVerificadorAgenciaCobranca"  as digverificadoragencia, ');
              SQL.Add('       "NumeroContaCorrenteCobranca" as contacorrente, ');
              SQL.Add('       "DigitoVerificadorContaCorrenteCobranca"  as digverificadorctacorrente, ');
              SQL.Add('       "DigitoVerificadorAgenciaContaCorrenteCobranca"  as digverificadoragcctacorrente, ');
              SQL.Add('       "CodigoCedenteCobranca" as codcedente, ');
              SQL.Add('       "DiretorioRemessaCobranca" as diretorioremessa, ');
              SQL.Add('       "OperacaoCobranca"      as operacao, ');
              SQL.Add('       "CaminhoFormularioCobranca" as caminhoformulario, ');
              SQL.Add('       "VersaoLayoutArquivoCobranca" as versaolayoutarquivo, ');
              SQL.Add('       "Mensagem1BloquetoCobranca" as mensagem1bloqueto, ');
              SQL.Add('       "Mensagem2BloquetoCobranca" as mensagem2bloqueto, ');
              SQL.Add('       "CodigoMovimentoCobranca" as codmovimento, ');
              SQL.Add('       "CodigoCarteiraCobranca" as codcarteira, ');
              SQL.Add('       "FormaCadastramentoTituloCobranca" as formacadtitulo, ');
              SQL.Add('       "EmissorBloquetoCobranca" as emissorbloqueto, ');
              SQL.Add('       "EspecieTituloCobranca" as especietitulo, ');
              SQL.Add('       "TipoAceiteNaoAceiteCobranca" as tipoaceite, ');
              SQL.Add('       "CodigoJurosCobranca" as codjuros, ');
              SQL.Add('       "CodigoProtestoCobranca" as codprotesto, ');
              SQL.Add('       "ValorJurosMoraDia" as jurosmora, ');
              SQL.Add('       "GerarRemessaCobranca" as geraremessa, ');
              SQL.Add('       "CodigoBaixaDevolucaoCobranca" as codbaixadevolucao, ');
              SQL.Add('       "NumeroDiasBaixaDevolucaoCobranca" as numdiasbaixadevolucao, ');
              SQL.Add('       "ValorMultaCobranca" as valormulta, ');
              SQL.Add('       "NumeroDiasMultaCobranca" as numdiasmulta, ');
              SQL.Add('       "MetodoSequenciaCobranca" as metodosequencia, ');
              SQL.Add('       "CaminhoFormularioCobrancaParcela" as caminhoformularioparcela, ');
              SQL.Add('       "DigitoIdentificadorRemessaCobranca" as digremessa, ');
              SQL.Add('       "NumerarioQuitacaoCobranca" as idnumerarioquitacao, ');
              SQL.Add('       "CaminhoTratarArquivoCobranca" as caminhotratararquivo ');
              SQL.Add('from "DocumentoCobranca" ');
              SQL.Add('where "CodigoInternoCobranca" =:xid ');
              ParamByName('xid').AsInteger := XIdCobranca;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhuma Cobrança alterada');
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

function ApagaCobranca(XIdCobranca: integer): TJSONObject;
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
         SQL.Add('delete from "DocumentoCobranca" where "CodigoInternoCobranca"=:xid ');
         ParamByName('xid').AsInteger := XIdCobranca;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Cobrança excluída com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhuma Cobrança excluída');
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
