unit dat.cadPessoasDevolucoes;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaDevolucao(XId: integer): TJSONObject;
function RetornaListaDevolucoes(const XQuery: TDictionary<string, string>; XIdPessoa: integer): TJSONArray;
function IncluiDevolucao(XDevolucao: TJSONObject; XIdPessoa: integer): TJSONObject;
function AlteraDevolucao(XIdDevolucao: integer; XDevolucao: TJSONObject): TJSONObject;
function ApagaDevolucao(XIdDevolucao: integer): TJSONObject;
function VerificaRequisicao(XDevolucao: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaDevolucao(XId: integer): TJSONObject;
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
         SQL.Add('select  "CodigoInternoPessoaDevolucao"   as id,');
         SQL.Add('        "CodigoPessoaDevolucao"          as idpessoa,');
         SQL.Add('        "DataPessoaDevolucao"            as data,');
         SQL.Add('        "ValorAVistaPessoaDevolucao"     as valoravista,');
         SQL.Add('        "ValorAPrazoPessoaDevolucao"     as valoraprazo,');
         SQL.Add('        "TipoContaPessoaDevolucao"       as tipoconta,');
         SQL.Add('        "CodigoDevolucaoPessoaDevolucao" as iddevolucao,');
         SQL.Add('        "CodigoNotaPessoaDevolucao"      as idnota,');
         SQL.Add('        "CodigoEmpresaOrigemDevolucao"   as idempresa,');
         SQL.Add('        "CodigoOrcamentoPessoaDevolucao" as idorcamento,');
         SQL.Add('        "OrigemPessoaDevolucao"          as origem,');
         SQL.Add('        "ObservacaoPessoaDevolucao"      as observacao,');
         SQL.Add('        "ValorTabelaPessoaDevolucao"     as valortabela,');
         SQL.Add('        "UtilizadoTabelaPessoaDevolucao" as utilizadotabela,');
         SQL.Add('        "TipoOrigemPessoaDevolucao"      as tipoorigem ');
         SQL.Add('from "PessoaDevolucao" ');
         SQL.Add('where "CodigoInternoPessoaDevolucao"=:xid ');
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
        wret.AddPair('description','Nenhuma Devolução encontrada');
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

function RetornaListaDevolucoes(const XQuery: TDictionary<string, string>; XIdPessoa: integer): TJSONArray;
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
         SQL.Add('select  "CodigoInternoPessoaDevolucao"   as id,');
         SQL.Add('        "CodigoPessoaDevolucao"          as idpessoa,');
         SQL.Add('        "DataPessoaDevolucao"            as data,');
         SQL.Add('        "ValorAVistaPessoaDevolucao"     as valoravista,');
         SQL.Add('        "ValorAPrazoPessoaDevolucao"     as valoraprazo,');
         SQL.Add('        "TipoContaPessoaDevolucao"       as tipoconta,');
         SQL.Add('        "CodigoDevolucaoPessoaDevolucao" as iddevolucao,');
         SQL.Add('        "CodigoNotaPessoaDevolucao"      as idnota,');
         SQL.Add('        "CodigoEmpresaOrigemDevolucao"   as idempresa,');
         SQL.Add('        "CodigoOrcamentoPessoaDevolucao" as idorcamento,');
         SQL.Add('        "OrigemPessoaDevolucao"          as origem,');
         SQL.Add('        "ObservacaoPessoaDevolucao"      as observacao,');
         SQL.Add('        "ValorTabelaPessoaDevolucao"     as valortabela,');
         SQL.Add('        "UtilizadoTabelaPessoaDevolucao" as utilizadotabela,');
         SQL.Add('        "TipoOrigemPessoaDevolucao"      as tipoorigem ');
         SQL.Add('from "PessoaDevolucao" where "CodigoPessoaDevolucao"=:xidpessoa ');
         ParamByName('xidpessoa').AsInteger := XIdPessoa;;
         if XQuery.ContainsKey('tipoconta') then // filtro por tipoconta
            begin
              SQL.Add('and "TipoContaPessoaDevolucao" =:xtipoconta ');
              ParamByName('xtipoconta').AsString := XQuery.Items['tipoconta'];
              SQL.Add('order by "TipoContaPessoaDevolucao" ');
            end;
         if XQuery.ContainsKey('data') then // filtro por data
            begin
              SQL.Add('and "DataPessoaDevolucao" =:xdata ');
              ParamByName('xdata').AsDate := strtodatedef(XQuery.Items['data'],0);
              SQL.Add('order by "DataPessoaDevolucao" ');
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
         wobj.AddPair('description','Nenhuma Devolução encontrada');
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

function IncluiDevolucao(XDevolucao: TJSONObject; XIdPessoa: integer): TJSONObject;
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
           SQL.Add('Insert into "PessoaDevolucao" ("CodigoPessoaDevolucao","DataPessoaDevolucao","ValorAVistaPessoaDevolucao","ValorAPrazoPessoaDevolucao",');
           SQL.Add('"TipoContaPessoaDevolucao","CodigoDevolucaoPessoaDevolucao","CodigoNotaPessoaDevolucao","CodigoEmpresaOrigemDevolucao","CodigoOrcamentoPessoaDevolucao",');
           SQL.Add('"OrigemPessoaDevolucao","ObservacaoPessoaDevolucao","ValorTabelaPessoaDevolucao","UtilizadoTabelaPessoaDevolucao","TipoOrigemPessoaDevolucao") ');
           SQL.Add('values (:xidpessoa,:xdata,:xvaloravista,:xvaloraprazo,');
           SQL.Add(':xtipoconta,(case when :xiddevolucao>0 then :xiddevolucao else null end),(case when :xidnota>0 then :xidnota else null end),:xidempresa,(case when :xidorcamento>0 then :xidorcamento else null end),');
           SQL.Add(':xorigem,:xobservacao,:xvalortabela,:xutilizadotabela,:xtipoorigem) ');
           ParamByName('xidpessoa').AsInteger   := XIdPessoa;
           if XDevolucao.TryGetValue('data',wval) then
              ParamByName('xdata').AsDate := strtodatedef(XDevolucao.GetValue('data').Value,0)
           else
              ParamByName('xdata').AsDate := 0;
           if XDevolucao.TryGetValue('valoravista',wval) then
              ParamByName('xvaloravista').AsFloat := strtofloatdef(XDevolucao.GetValue('valoravista').Value,0)
           else
              ParamByName('xvaloravista').AsFloat := 0;
           if XDevolucao.TryGetValue('valoraprazo',wval) then
              ParamByName('xvaloraprazo').AsFloat := strtofloatdef(XDevolucao.GetValue('valoraprazo').Value,0)
           else
              ParamByName('xvaloraprazo').AsFloat := 0;
           if XDevolucao.TryGetValue('tipoconta',wval) then
              ParamByName('xtipoconta').AsString := XDevolucao.GetValue('tipoconta').Value
           else
              ParamByName('xtipoconta').AsString := '';
           if XDevolucao.TryGetValue('iddevolucao',wval) then
              ParamByName('xiddevolucao').AsInteger := strtointdef(XDevolucao.GetValue('iddevolucao').Value,0)
           else
              ParamByName('xiddevolucao').AsInteger := 0;
           if XDevolucao.TryGetValue('idnota',wval) then
              ParamByName('xidnota').AsInteger := strtointdef(XDevolucao.GetValue('idnota').Value,0)
           else
              ParamByName('xidnota').AsInteger := 0;
           if XDevolucao.TryGetValue('idempresa',wval) then
              ParamByName('xidempresa').AsInteger := strtointdef(XDevolucao.GetValue('idempresa').Value,0)
           else
              ParamByName('xidempresa').AsInteger := 0;
           if XDevolucao.TryGetValue('idorcamento',wval) then
              ParamByName('xidorcamento').AsInteger := strtointdef(XDevolucao.GetValue('idorcamento').Value,0)
           else
              ParamByName('xidorcamento').AsInteger := 0;
           if XDevolucao.TryGetValue('origem',wval) then
              ParamByName('xorigem').AsString := XDevolucao.GetValue('origem').Value
           else
              ParamByName('xorigem').AsString := '';
           if XDevolucao.TryGetValue('observacao',wval) then
              ParamByName('xobservacao').AsString := XDevolucao.GetValue('observacao').Value
           else
              ParamByName('xobservacao').AsString := '';
           if XDevolucao.TryGetValue('valortabela',wval) then
              ParamByName('xvalortabela').AsFloat := strtofloatdef(XDevolucao.GetValue('valortabela').Value,0)
           else
              ParamByName('xvalortabela').AsFloat := 0;
           if XDevolucao.TryGetValue('utilizadotabela',wval) then
              ParamByName('xutilizadotabela').AsFloat := strtofloatdef(XDevolucao.GetValue('utilizadotabela').Value,0)
           else
              ParamByName('xutilizadotabela').AsFloat := 0;
           if XDevolucao.TryGetValue('tipoorigem',wval) then
              ParamByName('xtipoorigem').AsString := XDevolucao.GetValue('tipoorigem').Value
           else
              ParamByName('xtipoorigem').AsString := '';
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
                SQL.Add('select  "CodigoInternoPessoaDevolucao"   as id,');
                SQL.Add('        "CodigoPessoaDevolucao"          as idpessoa,');
                SQL.Add('        "DataPessoaDevolucao"            as data,');
                SQL.Add('        "ValorAVistaPessoaDevolucao"     as valoravista,');
                SQL.Add('        "ValorAPrazoPessoaDevolucao"     as valoraprazo,');
                SQL.Add('        "TipoContaPessoaDevolucao"       as tipoconta,');
                SQL.Add('        "CodigoDevolucaoPessoaDevolucao" as iddevolucao,');
                SQL.Add('        "CodigoNotaPessoaDevolucao"      as idnota,');
                SQL.Add('        "CodigoEmpresaOrigemDevolucao"   as idempresa,');
                SQL.Add('        "CodigoOrcamentoPessoaDevolucao" as idorcamento,');
                SQL.Add('        "OrigemPessoaDevolucao"          as origem,');
                SQL.Add('        "ObservacaoPessoaDevolucao"      as observacao,');
                SQL.Add('        "ValorTabelaPessoaDevolucao"     as valortabela,');
                SQL.Add('        "UtilizadoTabelaPessoaDevolucao" as utilizadotabela,');
                SQL.Add('        "TipoOrigemPessoaDevolucao"      as tipoorigem ');
                SQL.Add('from "PessoaDevolucao" where "CodigoPessoaDevolucao"=:xidpessoa and "DataPessoaDevolucao"=:xdata ');
                ParamByName('xidpessoa').AsInteger  := XIdPessoa;
                if XDevolucao.TryGetValue('data',wval) then
                   ParamByName('xdata').AsDate := strtodatedef(XDevolucao.GetValue('data').Value,0)
                else
                   ParamByName('xdata').AsDate := 0;
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhuma Devolução incluída');
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


function AlteraDevolucao(XIdDevolucao: integer; XDevolucao: TJSONObject): TJSONObject;
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
    if XDevolucao.TryGetValue('data',wval) then
       begin
         if wcampos='' then
            wcampos := '"DataPessoaDevolucao"=:xdata'
         else
            wcampos := wcampos+',"DataPessoaDevolucao"=:xdata';
       end;
    if XDevolucao.TryGetValue('valoravista',wval) then
       begin
         if wcampos='' then
            wcampos := '"ValorAVistaPessoaDevolucao"=:xvaloravista'
         else
            wcampos := wcampos+',"ValorAVistaPessoaDevolucao"=:xvaloravista';
       end;
    if XDevolucao.TryGetValue('valoraprazo',wval) then
       begin
         if wcampos='' then
            wcampos := '"ValorAPrazoPessoaDevolucao"=:xvaloraprazo'
         else
            wcampos := wcampos+',"ValorAPrazoPessoaDevolucao"=:xvaloraprazo';
       end;
    if XDevolucao.TryGetValue('tipoconta',wval) then
       begin
         if wcampos='' then
            wcampos := '"TipoContaPessoaDevolucao"=:xtipoconta'
         else
            wcampos := wcampos+',"TipoContaPessoaDevolucao"=:xtipoconta';
       end;
    if XDevolucao.TryGetValue('iddevolucao',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoDevolucaoPessoaDevolucao"=:xiddevolucao'
         else
            wcampos := wcampos+',"CodigoDevolucaoPessoaDevolucao"=:xiddevolucao';
       end;
    if XDevolucao.TryGetValue('idnota',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoNotaPessoaDevolucao"=:xidnota'
         else
            wcampos := wcampos+',"CodigoNotaPessoaDevolucao"=:xidnota';
       end;
    if XDevolucao.TryGetValue('idempresa',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoEmpresaOrigemDevolucao"=:xidempresa'
         else
            wcampos := wcampos+',"CodigoEmpresaOrigemDevolucao"=:xidempresa';
       end;
    if XDevolucao.TryGetValue('idorcamento',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoOrcamentoPessoaDevolucao"=:xidorcamento'
         else
            wcampos := wcampos+',"CodigoOrcamentoPessoaDevolucao"=:xidorcamento';
       end;
    if XDevolucao.TryGetValue('origem',wval) then
       begin
         if wcampos='' then
            wcampos := '"OrigemPessoaDevolucao"=:xorigem'
         else
            wcampos := wcampos+',"OrigemPessoaDevolucao"=:xorigem';
       end;
    if XDevolucao.TryGetValue('observacao',wval) then
       begin
         if wcampos='' then
            wcampos := '"ObservacaoPessoaDevolucao"=:xobservacao'
         else
            wcampos := wcampos+',"ObservacaoPessoaDevolucao"=:xobservacao';
       end;
    if XDevolucao.TryGetValue('valortabela',wval) then
       begin
         if wcampos='' then
            wcampos := '"ValorTabelaPessoaDevolucao"=:xvalortabela'
         else
            wcampos := wcampos+',"ValorTabelaPessoaDevolucao"=:xvalortabela';
       end;
    if XDevolucao.TryGetValue('utilizadotabela',wval) then
       begin
         if wcampos='' then
            wcampos := '"UtilizadoTabelaPessoaDevolucao"=:xutilizadotabela'
         else
            wcampos := wcampos+',"UtilizadoTabelaPessoaDevolucao"=:xutilizadotabela';
       end;
    if XDevolucao.TryGetValue('tipoorigem',wval) then
       begin
         if wcampos='' then
            wcampos := '"TipoOrigemPessoaDevolucao"=:xtipoorigem'
         else
            wcampos := wcampos+',"TipoOrigemPessoaDevolucao"=:xtipoorigem';
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
           SQL.Add('Update "PessoaDevolucao" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoPessoaDevolucao"=:xid ');
           ParamByName('xid').AsInteger             := XIdDevolucao;
           if XDevolucao.TryGetValue('data',wval) then
              ParamByName('xdata').AsDate           := strtodatedef(XDevolucao.GetValue('data').Value,0);
           if XDevolucao.TryGetValue('valoravista',wval) then
              ParamByName('xvaloravista').AsFloat   := strtofloatdef(XDevolucao.GetValue('valoravista').Value,0);
           if XDevolucao.TryGetValue('valoraprazo',wval) then
              ParamByName('xvaloraprazo').AsFloat   := strtofloatdef(XDevolucao.GetValue('valoraprazo').Value,0);
           if XDevolucao.TryGetValue('tipoconta',wval) then
              ParamByName('xtipoconta').AsString    := XDevolucao.GetValue('tipoconta').Value;
           if XDevolucao.TryGetValue('iddevolucao',wval) then
              ParamByName('xiddevolucao').AsInteger := strtointdef(XDevolucao.GetValue('iddevolucao').Value,0);
           if XDevolucao.TryGetValue('idnota',wval) then
              ParamByName('xidnota').AsInteger      := strtointdef(XDevolucao.GetValue('idnota').Value,0);
           if XDevolucao.TryGetValue('idempresa',wval) then
              ParamByName('xidempresa').AsInteger   := strtointdef(XDevolucao.GetValue('idempresa').Value,0);
           if XDevolucao.TryGetValue('idorcamento',wval) then
              ParamByName('xidorcamento').AsInteger := strtointdef(XDevolucao.GetValue('idorcamento').Value,0);
           if XDevolucao.TryGetValue('origem',wval) then
              ParamByName('xorigem').AsString       := XDevolucao.GetValue('origem').Value;
           if XDevolucao.TryGetValue('observacao',wval) then
              ParamByName('xobservacao').AsString   := XDevolucao.GetValue('observacao').Value;
           if XDevolucao.TryGetValue('valortabela',wval) then
              ParamByName('xvalortabela').AsFloat   := strtofloatdef(XDevolucao.GetValue('valortabela').Value,0);
           if XDevolucao.TryGetValue('utilizadotabela',wval) then
              ParamByName('xutilizadotabela').AsFloat   := strtofloatdef(XDevolucao.GetValue('utilizadotabela').Value,0);
           if XDevolucao.TryGetValue('tipoorigem',wval) then
              ParamByName('xtipoorigem').AsString       := XDevolucao.GetValue('tipoorigem').Value;
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
              SQL.Add('select  "CodigoInternoPessoaDevolucao"   as id,');
              SQL.Add('        "CodigoPessoaDevolucao"          as idpessoa,');
              SQL.Add('        "DataPessoaDevolucao"            as data,');
              SQL.Add('        "ValorAVistaPessoaDevolucao"     as valoravista,');
              SQL.Add('        "ValorAPrazoPessoaDevolucao"     as valoraprazo,');
              SQL.Add('        "TipoContaPessoaDevolucao"       as tipoconta,');
              SQL.Add('        "CodigoDevolucaoPessoaDevolucao" as iddevolucao,');
              SQL.Add('        "CodigoNotaPessoaDevolucao"      as idnota,');
              SQL.Add('        "CodigoEmpresaOrigemDevolucao"   as idempresa,');
              SQL.Add('        "CodigoOrcamentoPessoaDevolucao" as idorcamento,');
              SQL.Add('        "OrigemPessoaDevolucao"          as origem,');
              SQL.Add('        "ObservacaoPessoaDevolucao"      as observacao,');
              SQL.Add('        "ValorTabelaPessoaDevolucao"     as valortabela,');
              SQL.Add('        "UtilizadoTabelaPessoaDevolucao" as utilizadotabela,');
              SQL.Add('        "TipoOrigemPessoaDevolucao"      as tipoorigem ');
              SQL.Add('from "PessoaDevolucao" ');
              SQL.Add('where "CodigoInternoPessoaDevolucao" =:xid ');
              ParamByName('xid').AsInteger := XIdDevolucao;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhuma Devolução alterada');
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

function VerificaRequisicao(XDevolucao: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XDevolucao.TryGetValue('data',wval) then
       wret := false;
    if not XDevolucao.TryGetValue('tipoconta',wval) then
       wret := false;
    if not XDevolucao.TryGetValue('origem',wval) then
       wret := false;
  finally
  end;
  Result := wret;
end;

function ApagaDevolucao(XIdDevolucao: integer): TJSONObject;
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
         SQL.Add('delete from "PessoaDevolucao" where "CodigoInternoPessoaDevolucao"=:xid ');
         ParamByName('xid').AsInteger := XIdDevolucao;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Devolução excluída com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhuma Devolução excluída');
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
