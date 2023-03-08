unit dat.cadPessoasContratosSociais;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaContrato(XId: integer): TJSONObject;
function RetornaListaContratos(const XQuery: TDictionary<string, string>; XIdPessoa: integer): TJSONArray;
function IncluiContrato(XContrato: TJSONObject; XIdPessoa: integer): TJSONObject;
function AlteraContrato(XIdContrato: integer; XContrato: TJSONObject): TJSONObject;
function ApagaContrato(XIdContrato: integer): TJSONObject;
function VerificaRequisicao(XContrato: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaContrato(XId: integer): TJSONObject;
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
         SQL.Add('select "CodigoInternoContratoSocial" as id,');
         SQL.Add('       "CodigoPessoaContratoSocial"  as idpessoa,');
         SQL.Add('       "TipoContratoSocial"          as tipo,');
         SQL.Add('       "DataContratoSocial"          as data,');
         SQL.Add('       "ValorCapitalContratoSocial"  as valorcapital ');
         SQL.Add('from "PessoaContratoSocial" ');
         SQL.Add('where "CodigoInternoContratoSocial"=:xid ');
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
        wret.AddPair('description','Nenhum Contrato encontrado');
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

function RetornaListaContratos(const XQuery: TDictionary<string, string>; XIdPessoa: integer): TJSONArray;
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
         SQL.Add('select "CodigoInternoContratoSocial" as id,');
         SQL.Add('       "CodigoPessoaContratoSocial"  as idpessoa,');
         SQL.Add('       "TipoContratoSocial"          as tipo,');
         SQL.Add('       "DataContratoSocial"          as data,');
         SQL.Add('       "ValorCapitalContratoSocial"  as valorcapital ');
         SQL.Add('from "PessoaContratoSocial" where "CodigoPessoaContratoSocial"=:xidpessoa ');
         ParamByName('xidpessoa').AsInteger := XIdPessoa;;
         if XQuery.ContainsKey('tipo') then // filtro por tipo
            begin
              SQL.Add('and lower("TipoContratoSocial") = lower(:xtipo) ');
              ParamByName('xtipo').AsString := XQuery.Items['tipo'];
              SQL.Add('order by "TipoContratoSocial" ');
            end;
         if XQuery.ContainsKey('data') then // filtro por data
            begin
              SQL.Add('and "DataContratoSocial" =:xdata ');
              ParamByName('xdata').AsDate := strtodatedef(XQuery.Items['data'],0);
              SQL.Add('order by "DataContratoSocial" ');
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
         wobj.AddPair('description','Nenhum Contrato encontrado');
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

function IncluiContrato(XContrato: TJSONObject; XIdPessoa: integer): TJSONObject;
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
           SQL.Add('Insert into "PessoaContratoSocial" ("CodigoPessoaContratoSocial","TipoContratoSocial","DataContratoSocial","ValorCapitalContratoSocial") ');
           SQL.Add('values (:xidpessoa,:xtipo,:xdata,:xvalorcapital) ');
           ParamByName('xidpessoa').AsInteger   := XIdPessoa;
           if XContrato.TryGetValue('tipo',wval) then
              ParamByName('xtipo').AsString := XContrato.GetValue('tipo').Value
           else
              ParamByName('xtipo').AsString := '';
           if XContrato.TryGetValue('data',wval) then
              ParamByName('xdata').AsDate := strtodatedef(XContrato.GetValue('data').Value,0)
           else
              ParamByName('xdata').AsDate := 0;
           if XContrato.TryGetValue('valorcapital',wval) then
              ParamByName('xvalorcapital').AsFloat := strtofloatdef(XContrato.GetValue('valorcapital').Value,0)
           else
              ParamByName('xvalorcapital').AsFloat := 0;
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
                SQL.Add('select "CodigoInternoContratoSocial" as id,');
                SQL.Add('       "CodigoPessoaContratoSocial"  as idpessoa,');
                SQL.Add('       "TipoContratoSocial"          as tipo,');
                SQL.Add('       "DataContratoSocial"          as data,');
                SQL.Add('       "ValorCapitalContratoSocial"  as valorcapital ');
                SQL.Add('from "PessoaContratoSocial" where "CodigoPessoaContratoSocial"=:xidpessoa and "DataContratoSocial"=:xdata ');
                ParamByName('xidpessoa').AsInteger  := XIdPessoa;
                if XContrato.TryGetValue('data',wval) then
                   ParamByName('xdata').AsDate := strtodatedef(XContrato.GetValue('data').Value,0)
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
              wret.AddPair('description','Nenhum Contrato incluído');
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


function AlteraContrato(XIdContrato: integer; XContrato: TJSONObject): TJSONObject;
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
    if XContrato.TryGetValue('tipo',wval) then
       begin
         if wcampos='' then
            wcampos := '"TipoContratoSocial"=:xtipo'
         else
            wcampos := wcampos+',"TipoContratoSocial"=:xtipo';
       end;
    if XContrato.TryGetValue('data',wval) then
       begin
         if wcampos='' then
            wcampos := '"DataContratoSocial"=:xdata'
         else
            wcampos := wcampos+',"DataContratoSocial"=:xdata';
       end;
    if XContrato.TryGetValue('valorcapital',wval) then
       begin
         if wcampos='' then
            wcampos := '"ValorCapitalContratoSocial"=:xvalorcapital'
         else
            wcampos := wcampos+',"ValorCapitalContratoSocial"=:xvalorcapital';
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
           SQL.Add('Update "PessoaContratoSocial" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoContratoSocial"=:xid ');
           ParamByName('xid').AsInteger             := XIdContrato;
           if XContrato.TryGetValue('tipo',wval) then
              ParamByName('xtipo').AsString         := XContrato.GetValue('tipo').Value;
           if XContrato.TryGetValue('data',wval) then
              ParamByName('xdata').AsDate           := strtodatedef(XContrato.GetValue('data').Value,0);
           if XContrato.TryGetValue('valorcapital',wval) then
              ParamByName('xvalorcapital').AsFloat  := strtofloatdef(XContrato.GetValue('valorcapital').Value,0);
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
              SQL.Add('select "CodigoInternoContratoSocial" as id,');
              SQL.Add('       "CodigoPessoaContratoSocial"  as idpessoa,');
              SQL.Add('       "TipoContratoSocial"          as tipo,');
              SQL.Add('       "DataContratoSocial"          as data,');
              SQL.Add('       "ValorCapitalContratoSocial"  as valorcapital ');
              SQL.Add('from "PessoaContratoSocial" ');
              SQL.Add('where "CodigoInternoContratoSocial" =:xid ');
              ParamByName('xid').AsInteger := XIdContrato;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Contrato alterado');
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

function VerificaRequisicao(XContrato: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XContrato.TryGetValue('data',wval) then
       wret := false;
    if not XContrato.TryGetValue('tipo',wval) then
       wret := false;
  finally
  end;
  Result := wret;
end;

function ApagaContrato(XIdContrato: integer): TJSONObject;
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
         SQL.Add('delete from "PessoaContratoSocial" where "CodigoInternoContratoSocial"=:xid ');
         ParamByName('xid').AsInteger := XIdContrato;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Contrato excluído com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhum Contrato excluído');
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
