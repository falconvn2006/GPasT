unit dat.cadPessoasFidelidades;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaFidelidade(XId: integer): TJSONObject;
function RetornaListaFidelidades(const XQuery: TDictionary<string, string>; XIdPessoa: integer): TJSONArray;
function IncluiFidelidade(XFidelidade: TJSONObject; XIdPessoa: integer): TJSONObject;
function AlteraFidelidade(XIdFidelidade: integer; XFidelidade: TJSONObject): TJSONObject;
function ApagaFidelidade(XIdFidelidade: integer): TJSONObject;
function VerificaRequisicao(XFidelidade: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaFidelidade(XId: integer): TJSONObject;
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
         SQL.Add('select "CodigoInternoFidelidade"          as id,');
         SQL.Add('       "CodigoBonusFidelidade"            as idbonus,');
         SQL.Add('       "CodigoPessoaFidelidade"           as idpessoa,');
         SQL.Add('       "CodigoNotaFidelidade"             as idnota,');
         SQL.Add('       "CodigoConfiguracaoFidelidade"     as idconfiguracao,');
         SQL.Add('       "DataFidelidade"                   as data,');
         SQL.Add('       "HoraFidelidade"                   as hora,');
         SQL.Add('       "PontoFidelidade"                  as ponto,');
         SQL.Add('       "ValorFidelidade"                  as valor,');
         SQL.Add('       "TipoContaFidelidade"              as tipoconta,');
         SQL.Add('       "ObservacaoFidelidade"             as observacao,');
         SQL.Add('       "ValorOrigemFidelidade"            as valororigem,');
         SQL.Add('       "NumeroDocProcessaBonusFidelidade" as numdoc,');
         SQL.Add('       "EncerramentoExercicioFidelidade"  as encerramento,');
         SQL.Add('       "CodigoEmpresaGeracaoFidelidade"   as idempresageracao,');
         SQL.Add('       "DataEfetivacaoFidelidade"         as dataefetivacao ');
         SQL.Add('from "PessoaFidelidade" ');
         SQL.Add('where "CodigoInternoFidelidade"=:xid ');
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
        wret.AddPair('description','Nenhuma Fidelidade encontrada');
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

function RetornaListaFidelidades(const XQuery: TDictionary<string, string>; XIdPessoa: integer): TJSONArray;
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
         SQL.Add('select "CodigoInternoFidelidade"          as id,');
         SQL.Add('       "CodigoBonusFidelidade"            as idbonus,');
         SQL.Add('       "CodigoPessoaFidelidade"           as idpessoa,');
         SQL.Add('       "CodigoNotaFidelidade"             as idnota,');
         SQL.Add('       "CodigoConfiguracaoFidelidade"     as idconfiguracao,');
         SQL.Add('       "DataFidelidade"                   as data,');
         SQL.Add('       "HoraFidelidade"                   as hora,');
         SQL.Add('       "PontoFidelidade"                  as ponto,');
         SQL.Add('       "ValorFidelidade"                  as valor,');
         SQL.Add('       "TipoContaFidelidade"              as tipoconta,');
         SQL.Add('       "ObservacaoFidelidade"             as observacao,');
         SQL.Add('       "ValorOrigemFidelidade"            as valororigem,');
         SQL.Add('       "NumeroDocProcessaBonusFidelidade" as numdoc,');
         SQL.Add('       "EncerramentoExercicioFidelidade"  as encerramento,');
         SQL.Add('       "CodigoEmpresaGeracaoFidelidade"   as idempresageracao,');
         SQL.Add('       "DataEfetivacaoFidelidade"         as dataefetivacao ');
         SQL.Add('from "PessoaFidelidade" where "CodigoPessoaFidelidade"=:xidpessoa ');
         ParamByName('xidpessoa').AsInteger := XIdPessoa;;
         if XQuery.ContainsKey('data') then // filtro por data
            begin
              SQL.Add('and "DataFidelidade" =:xdata ');
              ParamByName('xdata').AsDate:= strtodatedef(XQuery.Items['data'],0);
              SQL.Add('order by "DataFidelidade" ');
            end;
         Open;
         EnableControls;
       end;
    if wqueryLista.RecordCount>0 then
       wret := wqueryLista.ToJSONArray()
    else
       begin
         wobj := TJSONObject.Create;
         wobj.AddPair('status','500');
         wobj.AddPair('description','Nenhuma Fidelidade encontrada');
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

function IncluiFidelidade(XFidelidade: TJSONObject; XIdPessoa: integer): TJSONObject;
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
           SQL.Add('Insert into "PessoaFidelidade" ("CodigoBonusFidelidade","CodigoPessoaFidelidade","CodigoNotaFidelidade","CodigoConfiguracaoFidelidade",');
           SQL.Add('"DataFidelidade","HoraFidelidade","PontoFidelidade","ValorFidelidade","TipoContaFidelidade","ObservacaoFidelidade",');
           SQL.Add('"ValorOrigemFidelidade","NumeroDocProcessaBonusFidelidade","EncerramentoExercicioFidelidade","CodigoEmpresaGeracaoFidelidade","DataEfetivacaoFidelidade") ');
           SQL.Add('values (:xidbonus,:xidpessoa,(case when :xidnota>0 then :xidnota else null end),(case when :xidconfiguracao>0 then :xidconfiguracao else null end),');
           SQL.Add(':xdata,:xhora,:xponto,:xvalor,:xtipoconta,:xobservacao,');
           SQL.Add(':xvalororigem,:xnumdoc,:xencerramento,:xidempresageracao,:xdataefetivacao) ');
           ParamByName('xidpessoa').AsInteger   := XIdPessoa;
           if XFidelidade.TryGetValue('idbonus',wval) then
              ParamByName('xidbonus').AsInteger := strtointdef(XFidelidade.GetValue('idbonus').Value,0)
           else
              ParamByName('xidbonus').AsInteger := 0;
           if XFidelidade.TryGetValue('idnota',wval) then
              ParamByName('xidnota').AsInteger := strtointdef(XFidelidade.GetValue('idnota').Value,0)
           else
              ParamByName('xidnota').AsInteger := 0;
           if XFidelidade.TryGetValue('idconfiguracao',wval) then
              ParamByName('xidconfiguracao').AsInteger := strtointdef(XFidelidade.GetValue('idconfiguracao').Value,0)
           else
              ParamByName('xidconfiguracao').AsInteger := 0;
           if XFidelidade.TryGetValue('data',wval) then
              ParamByName('xdata').AsDate := strtodatedef(XFidelidade.GetValue('data').Value,0)
           else
              ParamByName('xdata').AsDate := 0;
           if XFidelidade.TryGetValue('hora',wval) then
              ParamByName('xhora').AsString := XFidelidade.GetValue('hora').Value
           else
              ParamByName('xhora').AsString := '';
           if XFidelidade.TryGetValue('ponto',wval) then
              ParamByName('xponto').AsFloat := strtofloatdef(XFidelidade.GetValue('ponto').Value,0)
           else
              ParamByName('xponto').AsFloat := 0;
           if XFidelidade.TryGetValue('valor',wval) then
              ParamByName('xvalor').AsFloat := strtofloatdef(XFidelidade.GetValue('valor').Value,0)
           else
              ParamByName('xvalor').AsFloat := 0;
           if XFidelidade.TryGetValue('tipoconta',wval) then
              ParamByName('xtipoconta').AsString := XFidelidade.GetValue('tipoconta').Value
           else
              ParamByName('xtipoconta').AsString := '';
           if XFidelidade.TryGetValue('observacao',wval) then
              ParamByName('xobservacao').AsString := XFidelidade.GetValue('observacao').Value
           else
              ParamByName('xobservacao').AsString := '';
           if XFidelidade.TryGetValue('valororigem',wval) then
              ParamByName('xvalororigem').AsFloat := strtofloatdef(XFidelidade.GetValue('valororigem').Value,0)
           else
              ParamByName('xvalororigem').AsFloat := 0;
           if XFidelidade.TryGetValue('numdoc',wval) then
              ParamByName('xnumdoc').AsInteger := strtointdef(XFidelidade.GetValue('numdoc').Value,0)
           else
              ParamByName('xnumdoc').AsInteger := 0;
           if XFidelidade.TryGetValue('encerramento',wval) then
              ParamByName('xencerramento').AsBoolean := strtobooldef(XFidelidade.GetValue('encerramento').Value,false)
           else
              ParamByName('xencerramento').AsBoolean := false;
           if XFidelidade.TryGetValue('idempresageracao',wval) then
              ParamByName('xidempresageracao').AsInteger := strtointdef(XFidelidade.GetValue('idempresageracao').Value,0)
           else
              ParamByName('xidempresageracao').AsInteger := 0;
           if XFidelidade.TryGetValue('dataefetivacao',wval) then
              ParamByName('xdataefetivacao').AsDate := strtodatedef(XFidelidade.GetValue('dataefetivacao').Value,0)
           else
              ParamByName('xdataefetivacao').AsDate := 0;
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
                SQL.Add('select "CodigoInternoFidelidade"          as id,');
                SQL.Add('       "CodigoBonusFidelidade"            as idbonus,');
                SQL.Add('       "CodigoPessoaFidelidade"           as idpessoa,');
                SQL.Add('       "CodigoNotaFidelidade"             as idnota,');
                SQL.Add('       "CodigoConfiguracaoFidelidade"     as idconfiguracao,');
                SQL.Add('       "DataFidelidade"                   as data,');
                SQL.Add('       "HoraFidelidade"                   as hora,');
                SQL.Add('       "PontoFidelidade"                  as ponto,');
                SQL.Add('       "ValorFidelidade"                  as valor,');
                SQL.Add('       "TipoContaFidelidade"              as tipoconta,');
                SQL.Add('       "ObservacaoFidelidade"             as observacao,');
                SQL.Add('       "ValorOrigemFidelidade"            as valororigem,');
                SQL.Add('       "NumeroDocProcessaBonusFidelidade" as numdoc,');
                SQL.Add('       "EncerramentoExercicioFidelidade"  as encerramento,');
                SQL.Add('       "CodigoEmpresaGeracaoFidelidade"   as idempresageracao,');
                SQL.Add('       "DataEfetivacaoFidelidade"         as dataefetivacao ');
                SQL.Add('from "PessoaFidelidade" where "CodigoPessoaFidelidade"=:xidpessoa and "DataFidelidade"=:xdata and "ValorFidelidade"=:xvalor ');
                ParamByName('xidpessoa').AsInteger  := XIdPessoa;
                if XFidelidade.TryGetValue('data',wval) then
                   ParamByName('xdata').AsDate := strtodatedef(XFidelidade.GetValue('data').Value,0)
                else
                   ParamByName('xdata').AsDate := 0;
                if XFidelidade.TryGetValue('valor',wval) then
                   ParamByName('xvalor').AsFloat := strtofloatdef(XFidelidade.GetValue('valor').Value,0)
                else
                   ParamByName('xvalor').AsFloat := 0;
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhuma Fidelidade incluída');
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


function AlteraFidelidade(XIdFidelidade: integer; XFidelidade: TJSONObject): TJSONObject;
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
    if XFidelidade.TryGetValue('idbonus',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoBonusFidelidade"=:xidbonus'
         else
            wcampos := wcampos+',"CodigoBonusFidelidade"=:xidbonus';
       end;
    if XFidelidade.TryGetValue('idnota',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoNotaFidelidade"=:xidnota'
         else
            wcampos := wcampos+',"CodigoNotaFidelidade"=:xidnota';
       end;
    if XFidelidade.TryGetValue('idconfiguracao',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoConfiguracaoFidelidade"=:xidconfiguracao'
         else
            wcampos := wcampos+',"CodigoConfiguracaoFidelidade"=:xidconfiguracao';
       end;
    if XFidelidade.TryGetValue('data',wval) then
       begin
         if wcampos='' then
            wcampos := '"DataFidelidade"=:xdata'
         else
            wcampos := wcampos+',"DataFidelidade"=:xdata';
       end;
    if XFidelidade.TryGetValue('hora',wval) then
       begin
         if wcampos='' then
            wcampos := '"HoraFidelidade"=:xhora'
         else
            wcampos := wcampos+',"HoraFidelidade"=:xhora';
       end;
    if XFidelidade.TryGetValue('ponto',wval) then
       begin
         if wcampos='' then
            wcampos := '"PontoFidelidade"=:xponto'
         else
            wcampos := wcampos+',"PontoFidelidade"=:xponto';
       end;
    if XFidelidade.TryGetValue('valor',wval) then
       begin
         if wcampos='' then
            wcampos := '"ValorFidelidade"=:xvalor'
         else
            wcampos := wcampos+',"ValorFidelidade"=:xvalor';
       end;
    if XFidelidade.TryGetValue('tipoconta',wval) then
       begin
         if wcampos='' then
            wcampos := '"TipoContaFidelidade"=:xtipoconta'
         else
            wcampos := wcampos+',"TipoContaFidelidade"=:xtipoconta';
       end;
    if XFidelidade.TryGetValue('observacao',wval) then
       begin
         if wcampos='' then
            wcampos := '"ObservacaoFidelidade"=:xobservacao'
         else
            wcampos := wcampos+',"ObservacaoFidelidade"=:xobservacao';
       end;
    if XFidelidade.TryGetValue('valororigem',wval) then
       begin
         if wcampos='' then
            wcampos := '"ValorOrigemFidelidade"=:xvalororigem'
         else
            wcampos := wcampos+',"ValorOrigemFidelidade"=:xvalororigem';
       end;
    if XFidelidade.TryGetValue('numdoc',wval) then
       begin
         if wcampos='' then
            wcampos := '"NumeroDocProcessaBonusFidelidade"=:xnumdoc'
         else
            wcampos := wcampos+',"NumeroDocProcessaBonusFidelidade"=:xnumdoc';
       end;
    if XFidelidade.TryGetValue('encerramento',wval) then
       begin
         if wcampos='' then
            wcampos := '"EncerramentoExercicioFidelidade"=:xencerramento'
         else
            wcampos := wcampos+',"EncerramentoExercicioFidelidade"=:xencerramento';
       end;
    if XFidelidade.TryGetValue('idempresageracao',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoEmpresaGeracaoFidelidade"=:xidempresageracao'
         else
            wcampos := wcampos+',"CodigoEmpresaGeracaoFidelidade"=:xidempresageracao';
       end;
    if XFidelidade.TryGetValue('dataefetivacao',wval) then
       begin
         if wcampos='' then
            wcampos := '"DataEfetivacaoFidelidade"=:xdataefetivacao'
         else
            wcampos := wcampos+',"DataEfetivacaoFidelidade"=:xdataefetivacao';
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
           SQL.Add('Update "PessoaFidelidade" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoFidelidade"=:xid ');
           ParamByName('xid').AsInteger                := XIdFidelidade;
           if XFidelidade.TryGetValue('idbonus',wval) then
              ParamByName('xidbonus').AsInteger        := strtointdef(XFidelidade.GetValue('idbonus').Value,0);
           if XFidelidade.TryGetValue('idnota',wval) then
              ParamByName('xidnota').AsInteger         := strtointdef(XFidelidade.GetValue('idnota').Value,0);
           if XFidelidade.TryGetValue('idconfiguracao',wval) then
              ParamByName('xidconfiguracao').AsInteger := strtointdef(XFidelidade.GetValue('idconfiguracao').Value,0);
           if XFidelidade.TryGetValue('data',wval) then
              ParamByName('xdata').AsDate              := strtodatedef(XFidelidade.GetValue('data').Value,0);
           if XFidelidade.TryGetValue('hora',wval) then
              ParamByName('xhora').AsString            := XFidelidade.GetValue('hora').Value;
           if XFidelidade.TryGetValue('ponto',wval) then
              ParamByName('xponto').AsFloat            := strtofloatdef(XFidelidade.GetValue('ponto').Value,0);
           if XFidelidade.TryGetValue('valor',wval) then
              ParamByName('xvalor').AsFloat            := strtofloatdef(XFidelidade.GetValue('valor').Value,0);
           if XFidelidade.TryGetValue('tipoconta',wval) then
              ParamByName('xtipoconta').AsString       := XFidelidade.GetValue('tipoconta').Value;
           if XFidelidade.TryGetValue('observacao',wval) then
              ParamByName('xobservacao').AsString      := XFidelidade.GetValue('observacao').Value;
           if XFidelidade.TryGetValue('valororigem',wval) then
              ParamByName('xvalororigem').AsFloat      := strtofloatdef(XFidelidade.GetValue('valororigem').Value,0);
           if XFidelidade.TryGetValue('numdoc',wval) then
              ParamByName('xnumdoc').AsInteger         := strtointdef(XFidelidade.GetValue('numdoc').Value,0);
           if XFidelidade.TryGetValue('encerramento',wval) then
              ParamByName('xencerramento').AsBoolean   := strtobooldef(XFidelidade.GetValue('encerramento').Value,false);
           if XFidelidade.TryGetValue('idempresageracao',wval) then
              ParamByName('xidempresageracao').AsInteger := strtointdef(XFidelidade.GetValue('idempresageracao').Value,0);
           if XFidelidade.TryGetValue('dataefetivacao',wval) then
              ParamByName('xdataefetivacao').AsDate    := strtodatedef(XFidelidade.GetValue('dataefetivacao').Value,0);
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
              SQL.Add('select "CodigoInternoFidelidade"          as id,');
              SQL.Add('       "CodigoBonusFidelidade"            as idbonus,');
              SQL.Add('       "CodigoPessoaFidelidade"           as idpessoa,');
              SQL.Add('       "CodigoNotaFidelidade"             as idnota,');
              SQL.Add('       "CodigoConfiguracaoFidelidade"     as idconfiguracao,');
              SQL.Add('       "DataFidelidade"                   as data,');
              SQL.Add('       "HoraFidelidade"                   as hora,');
              SQL.Add('       "PontoFidelidade"                  as ponto,');
              SQL.Add('       "ValorFidelidade"                  as valor,');
              SQL.Add('       "TipoContaFidelidade"              as tipoconta,');
              SQL.Add('       "ObservacaoFidelidade"             as observacao,');
              SQL.Add('       "ValorOrigemFidelidade"            as valororigem,');
              SQL.Add('       "NumeroDocProcessaBonusFidelidade" as numdoc,');
              SQL.Add('       "EncerramentoExercicioFidelidade"  as encerramento,');
              SQL.Add('       "CodigoEmpresaGeracaoFidelidade"   as idempresageracao,');
              SQL.Add('       "DataEfetivacaoFidelidade"         as dataefetivacao ');
              SQL.Add('from "PessoaFidelidade" ');
              SQL.Add('where "CodigoInternoFidelidade" =:xid ');
              ParamByName('xid').AsInteger := XIdFidelidade;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhuma Fidelidade alterada');
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

function VerificaRequisicao(XFidelidade: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XFidelidade.TryGetValue('data',wval) then
       wret := false;
    if not XFidelidade.TryGetValue('hora',wval) then
       wret := false;
    if not XFidelidade.TryGetValue('ponto',wval) then
       wret := false;
    if not XFidelidade.TryGetValue('valor',wval) then
       wret := false;
    if not XFidelidade.TryGetValue('tipoconta',wval) then
       wret := false;
  finally
  end;
  Result := wret;
end;

function ApagaFidelidade(XIdFidelidade: integer): TJSONObject;
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
         SQL.Add('delete from "PessoaFidelidade" where "CodigoInternoFidelidade"=:xid ');
         ParamByName('xid').AsInteger := XIdFidelidade;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Fidelidade excluída com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhuma Fidelidade excluída');
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
