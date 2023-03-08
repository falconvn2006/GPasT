unit dat.cadPessoasSPC;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaSPC(XId: integer): TJSONObject;
function RetornaListaSPC(const XQuery: TDictionary<string, string>; XIdPessoa: integer): TJSONArray;
function IncluiSPC(XSPC: TJSONObject; XIdPessoa: integer): TJSONObject;
function AlteraSPC(XIdSPC: integer; XSPC: TJSONObject): TJSONObject;
function ApagaSPC(XIdSPC: integer): TJSONObject;
function VerificaRequisicao(XSPC: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaSPC(XId: integer): TJSONObject;
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
         SQL.Add('select  "CodigoInternoControle"           as id,');
         SQL.Add('        "CodigoPessoaControle"            as idpessoa,');
         SQL.Add('        "DataEntradaControle"             as dataentrada,');
         SQL.Add('        "DataSaidaControle"               as datasaida,');
         SQL.Add('        "NumeroDocumentoControle"         as numerodocumento,');
         SQL.Add('        "ValorDocumentoControle"          as valordocumento,');
         SQL.Add('        "ObservacaoControle"              as observacao,');
         SQL.Add('        "DataEmissaoDocumentoControle"    as dataemissao,');
         SQL.Add('        "DataVencimentoDocumentoControle" as datavencimento,');
         SQL.Add('        "ParcelaDocumentoControle"        as parcela,');
         SQL.Add('        "TipoInclusaoDocumentoControle"   as tipoinclusao,');
         SQL.Add('        "ValorParcelaDocumentoControle"   as valorparcela,');
         SQL.Add('        "CodigoParcelaControle"           as idparcela ');
         SQL.Add('from "PessoaSPC" ');
         SQL.Add('where "CodigoInternoControle"=:xid ');
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
        wret.AddPair('description','Nenhum Controle encontrado');
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

function RetornaListaSPC(const XQuery: TDictionary<string, string>; XIdPessoa: integer): TJSONArray;
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
         SQL.Add('select  "CodigoInternoControle"           as id,');
         SQL.Add('        "CodigoPessoaControle"            as idpessoa,');
         SQL.Add('        "DataEntradaControle"             as dataentrada,');
         SQL.Add('        "DataSaidaControle"               as datasaida,');
         SQL.Add('        "NumeroDocumentoControle"         as numerodocumento,');
         SQL.Add('        "ValorDocumentoControle"          as valordocumento,');
         SQL.Add('        "ObservacaoControle"              as observacao,');
         SQL.Add('        "DataEmissaoDocumentoControle"    as dataemissao,');
         SQL.Add('        "DataVencimentoDocumentoControle" as datavencimento,');
         SQL.Add('        "ParcelaDocumentoControle"        as parcela,');
         SQL.Add('        "TipoInclusaoDocumentoControle"   as tipoinclusao,');
         SQL.Add('        "ValorParcelaDocumentoControle"   as valorparcela,');
         SQL.Add('        "CodigoParcelaControle"           as idparcela ');
         SQL.Add('from "PessoaSPC" where "CodigoPessoaControle"=:xidpessoa ');
         ParamByName('xidpessoa').AsInteger := XIdPessoa;;
         Open;
         EnableControls;
       end;
    if wqueryLista.RecordCount>0 then
       wret := wqueryLista.ToJSONArray()
    else
       begin
         wobj := TJSONObject.Create;
         wobj.AddPair('status','500');
         wobj.AddPair('description','Nenhum Controle encontrado');
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

function IncluiSPC(XSPC: TJSONObject; XIdPessoa: integer): TJSONObject;
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
           SQL.Add('Insert into "PessoaSPC" ("CodigoPessoaControle","DataEntradaControle","DataSaidaControle","NumeroDocumentoControle","ValorDocumentoControle",');
           SQL.Add('"ObservacaoControle","DataEmissaoDocumentoControle","DataVencimentoDocumentoControle","ParcelaDocumentoControle",');
           SQL.Add('"TipoInclusaoDocumentoControle","ValorParcelaDocumentoControle","CodigoParcelaControle") ');
           SQL.Add('values (:xidpessoa,:xdataentrada,:xdatasaida,:xnumerodocumento,:xvalordocumento,');
           SQL.Add(':xobservacao,:xdataemissao,:xdatavencimento,:xparcela,');
           SQL.Add(':xtipoinclusao,:xvalorparcela,:xidparcela) ');
           ParamByName('xidpessoa').AsInteger   := XIdPessoa;
           if XSPC.TryGetValue('dataentrada',wval) then
              ParamByName('xdataentrada').AsDate := strtodatedef(XSPC.GetValue('dataentrada').Value,0)
           else
              ParamByName('xdataentrada').AsDate := 0;
           if XSPC.TryGetValue('datasaida',wval) then
              ParamByName('xdatasaida').AsDate := strtodatedef(XSPC.GetValue('datasaida').Value,0)
           else
              ParamByName('xdatasaida').AsDate := 0;
           if XSPC.TryGetValue('numerodocumento',wval) then
              ParamByName('xnumerodocumento').AsString := XSPC.GetValue('numerodocumento').Value
           else
              ParamByName('xnumerodocumento').AsString := '';
           if XSPC.TryGetValue('valordocumento',wval) then
              ParamByName('xvalordocumento').AsFloat := strtofloatdef(XSPC.GetValue('valordocumento').Value,0)
           else
              ParamByName('xvalordocumento').AsFloat := 0;
           if XSPC.TryGetValue('observacao',wval) then
              ParamByName('xobservacao').AsString := XSPC.GetValue('observacao').Value
           else
              ParamByName('xobservacao').AsString := '';
           if XSPC.TryGetValue('dataemissao',wval) then
              ParamByName('xdataemissao').AsDate := strtodatedef(XSPC.GetValue('dataemissao').Value,0)
           else
              ParamByName('xdataemissao').AsDate := 0;
           if XSPC.TryGetValue('datavencimento',wval) then
              ParamByName('xdatavencimento').AsDate := strtodatedef(XSPC.GetValue('datavencimento').Value,0)
           else
              ParamByName('xdatavencimento').AsDate := 0;
           if XSPC.TryGetValue('parcela',wval) then
              ParamByName('xparcela').AsString := XSPC.GetValue('parcela').Value
           else
              ParamByName('xparcela').AsString := '';
           if XSPC.TryGetValue('tipoinclusao',wval) then
              ParamByName('xtipoinclusao').AsString := XSPC.GetValue('tipoinclusao').Value
           else
              ParamByName('xtipoinclusao').AsString := '';
           if XSPC.TryGetValue('valorparcela',wval) then
              ParamByName('xvalorparcela').AsFloat := strtofloatdef(XSPC.GetValue('valorparcela').Value,0)
           else
              ParamByName('xvalorparcela').AsFloat := 0;
           if XSPC.TryGetValue('idparcela',wval) then
              ParamByName('xidparcela').AsInteger := strtointdef(XSPC.GetValue('idparcela').Value,0)
           else
              ParamByName('xidparcela').AsInteger := 0;
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
                SQL.Add('select  "CodigoInternoControle"           as id,');
                SQL.Add('        "CodigoPessoaControle"            as idpessoa,');
                SQL.Add('        "DataEntradaControle"             as dataentrada,');
                SQL.Add('        "DataSaidaControle"               as datasaida,');
                SQL.Add('        "NumeroDocumentoControle"         as numerodocumento,');
                SQL.Add('        "ValorDocumentoControle"          as valordocumento,');
                SQL.Add('        "ObservacaoControle"              as observacao,');
                SQL.Add('        "DataEmissaoDocumentoControle"    as dataemissao,');
                SQL.Add('        "DataVencimentoDocumentoControle" as datavencimento,');
                SQL.Add('        "ParcelaDocumentoControle"        as parcela,');
                SQL.Add('        "TipoInclusaoDocumentoControle"   as tipoinclusao,');
                SQL.Add('        "ValorParcelaDocumentoControle"   as valorparcela,');
                SQL.Add('        "CodigoParcelaControle"           as idparcela ');
                SQL.Add('from "PessoaSPC" where "CodigoPessoaControle"=:xidpessoa and "DataEntradaControle"=:xdataentrada ');
                ParamByName('xidpessoa').AsInteger  := XIdPessoa;
                if XSPC.TryGetValue('dataentrada',wval) then
                   ParamByName('xdataentrada').AsDate := strtodatedef(XSPC.GetValue('dataentrada').Value,0)
                else
                   ParamByName('xdataentrada').AsDate := 0;
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Controle incluído');
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


function AlteraSPC(XIdSPC: integer; XSPC: TJSONObject): TJSONObject;
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
    if XSPC.TryGetValue('dataentrada',wval) then
       begin
         if wcampos='' then
            wcampos := '"DataEntradaControle"=:xdataentrada'
         else
            wcampos := wcampos+',"DataEntradaControle"=:xdataentrada';
       end;
    if XSPC.TryGetValue('datasaida',wval) then
       begin
         if wcampos='' then
            wcampos := '"DataSaidaControle"=:xdatasaida'
         else
            wcampos := wcampos+',"DataSaidaControle"=:xdatasaida';
       end;
    if XSPC.TryGetValue('numerodocumento',wval) then
       begin
         if wcampos='' then
            wcampos := '"NumeroDocumentoControle"=:xnumerodocumento'
         else
            wcampos := wcampos+',"NumeroDocumentoControle"=:xnumerodocumento';
       end;
    if XSPC.TryGetValue('valordocumento',wval) then
       begin
         if wcampos='' then
            wcampos := '"ValorDocumentoControle"=:xvalordocumento'
         else
            wcampos := wcampos+',"ValorDocumentoControle"=:xvalordocumento';
       end;
    if XSPC.TryGetValue('observacao',wval) then
       begin
         if wcampos='' then
            wcampos := '"ObservacaoControle"=:xobservacao'
         else
            wcampos := wcampos+',"ObservacaoControle"=:xobservacao';
       end;
    if XSPC.TryGetValue('dataemissao',wval) then
       begin
         if wcampos='' then
            wcampos := '"DataEmissaoDocumentoControle"=:xdataemissao'
         else
            wcampos := wcampos+',"DataEmissaoDocumentoControle"=:xdataemissao';
       end;
    if XSPC.TryGetValue('datavencimento',wval) then
       begin
         if wcampos='' then
            wcampos := '"DataVencimentoDocumentoControle"=:xdatavencimento'
         else
            wcampos := wcampos+',"DataVencimentoDocumentoControle"=:xdatavencimento';
       end;
    if XSPC.TryGetValue('parcela',wval) then
       begin
         if wcampos='' then
            wcampos := '"ParcelaDocumentoControle"=:xparcela'
         else
            wcampos := wcampos+',"ParcelaDocumentoControle"=:xparcela';
       end;
    if XSPC.TryGetValue('tipoinclusao',wval) then
       begin
         if wcampos='' then
            wcampos := '"TipoInclusaoDocumentoControle"=:xtipoinclusao'
         else
            wcampos := wcampos+',"TipoInclusaoDocumentoControle"=:xtipoinclusao';
       end;
    if XSPC.TryGetValue('valorparcela',wval) then
       begin
         if wcampos='' then
            wcampos := '"ValorParcelaDocumentoControle"=:xvalorparcela'
         else
            wcampos := wcampos+',"ValorParcelaDocumentoControle"=:xvalorparcela';
       end;
    if XSPC.TryGetValue('idparcela',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoParcelaControle"=:xidparcela'
         else
            wcampos := wcampos+',"CodigoParcelaControle"=:xidparcela';
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
           SQL.Add('Update "PessoaSPC" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoControle"=:xid ');
           ParamByName('xid').AsInteger               := XIdSPC;

           if XSPC.TryGetValue('dataentrada',wval) then
              ParamByName('xdataentrada').AsDate           := strtodatedef(XSPC.GetValue('dataentrada').Value,0);
           if XSPC.TryGetValue('datasaida',wval) then
              ParamByName('xdatasaida').AsDate             := strtodatedef(XSPC.GetValue('datasaida').Value,0);
           if XSPC.TryGetValue('numerodocumento',wval) then
              ParamByName('xnumerodocumento').AsString     := XSPC.GetValue('numerodocumento').Value;
           if XSPC.TryGetValue('valordocumento',wval) then
              ParamByName('xvalordocumento').AsFloat       := strtofloatdef(XSPC.GetValue('valordocumento').Value,0);
           if XSPC.TryGetValue('observacao',wval) then
              ParamByName('xobservacao').AsString          := XSPC.GetValue('observacao').Value;
           if XSPC.TryGetValue('dataemissao',wval) then
              ParamByName('xdataemissao').AsDate           := strtodatedef(XSPC.GetValue('dataemissao').Value,0);
           if XSPC.TryGetValue('datavencimento',wval) then
              ParamByName('xdatavencimento').AsDate        := strtodatedef(XSPC.GetValue('datavencimento').Value,0);
           if XSPC.TryGetValue('parcela',wval) then
              ParamByName('xparcela').AsString             := XSPC.GetValue('parcela').Value;
           if XSPC.TryGetValue('tipoinclusao',wval) then
              ParamByName('xtipoinclusao').AsString        := XSPC.GetValue('tipoinclusao').Value;
           if XSPC.TryGetValue('valorparcela',wval) then
              ParamByName('xvalorparcela').AsFloat         := strtofloatdef(XSPC.GetValue('valorparcela').Value,0);
           if XSPC.TryGetValue('idparcela',wval) then
              ParamByName('xidparcela').AsInteger          := strtointdef(XSPC.GetValue('idparcela').Value,0);
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
              SQL.Add('select  "CodigoInternoControle"           as id,');
              SQL.Add('        "CodigoPessoaControle"            as idpessoa,');
              SQL.Add('        "DataEntradaControle"             as dataentrada,');
              SQL.Add('        "DataSaidaControle"               as datasaida,');
              SQL.Add('        "NumeroDocumentoControle"         as numerodocumento,');
              SQL.Add('        "ValorDocumentoControle"          as valordocumento,');
              SQL.Add('        "ObservacaoControle"              as observacao,');
              SQL.Add('        "DataEmissaoDocumentoControle"    as dataemissao,');
              SQL.Add('        "DataVencimentoDocumentoControle" as datavencimento,');
              SQL.Add('        "ParcelaDocumentoControle"        as parcela,');
              SQL.Add('        "TipoInclusaoDocumentoControle"   as tipoinclusao,');
              SQL.Add('        "ValorParcelaDocumentoControle"   as valorparcela,');
              SQL.Add('        "CodigoParcelaControle"           as idparcela ');
              SQL.Add('from "PessoaSPC" ');
              SQL.Add('where "CodigoInternoControle" =:xid ');
              ParamByName('xid').AsInteger := XIdSPC;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Controle alterado');
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

function VerificaRequisicao(XSPC: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XSPC.TryGetValue('dataentrada',wval) then
       wret := false;
    if not XSPC.TryGetValue('valordocumento',wval) then
       wret := false;
  finally
  end;
  Result := wret;
end;

function ApagaSPC(XIdSPC: integer): TJSONObject;
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
         SQL.Add('delete from "PessoaSPC" where "CodigoInternoControle"=:xid ');
         ParamByName('xid').AsInteger := XIdSPC;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Controle excluído com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhum Controle excluído');
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
