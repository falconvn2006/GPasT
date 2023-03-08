unit dat.cadPessoasCNAES;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaCNAE(XId: integer): TJSONObject;
function RetornaListaCNAES(const XQuery: TDictionary<string, string>; XIdPessoa: integer): TJSONArray;
function IncluiCNAE(XCNAE: TJSONObject; XIdPessoa: integer): TJSONObject;
function AlteraCNAE(XIdCNAE: integer; XCNAE: TJSONObject): TJSONObject;
function ApagaCNAE(XIdCNAE: integer): TJSONObject;
function VerificaRequisicao(XCNAE: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaCNAE(XId: integer): TJSONObject;
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
         SQL.Add('select "CodigoInternoPessoaCNAE" as id,');
         SQL.Add('       "CodigoPessoaCNAE"        as idpessoa,');
         SQL.Add('       "TabelaPessoaCNAE"        as idtabela,');
         SQL.Add('       "DataPessoaCNAE"          as data ');
         SQL.Add('from "PessoaCNAE" ');
         SQL.Add('where "CodigoInternoPessoaCNAE"=:xid ');
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
        wret.AddPair('description','Nenhum CNAE encontrado');
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

function RetornaListaCNAES(const XQuery: TDictionary<string, string>; XIdPessoa: integer): TJSONArray;
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
         SQL.Add('select "CodigoInternoPessoaCNAE" as id,');
         SQL.Add('       "CodigoPessoaCNAE"        as idpessoa,');
         SQL.Add('       "TabelaPessoaCNAE"        as idtabela,');
         SQL.Add('       "DataPessoaCNAE"          as data ');
         SQL.Add('from "PessoaCNAE" where "CodigoPessoaCNAE"=:xidpessoa ');
         ParamByName('xidpessoa').AsInteger := XIdPessoa;;
         if XQuery.ContainsKey('data') then // filtro por data
            begin
              SQL.Add('and "DataPessoaCNAE" =:xdata ');
              ParamByName('xdata').AsDate := strtodatedef(XQuery.Items['data'],0);
              SQL.Add('order by "TelefoneContatos" ');
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
         wobj.AddPair('description','Nenhum CNAE encontrado');
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

function IncluiCNAE(XCNAE: TJSONObject; XIdPessoa: integer): TJSONObject;
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
           SQL.Add('Insert into "PessoaCNAE" ("CodigoPessoaCNAE","TabelaPessoaCNAE","DataPessoaCNAE") ');
           SQL.Add('values (:xidpessoa,(case when :xidtabela>0 then :xidtabela else null end),:xdata) ');
           ParamByName('xidpessoa').AsInteger   := XIdPessoa;
           if XCNAE.TryGetValue('idtabela',wval) then
              ParamByName('xidtabela').AsInteger := strtointdef(XCNAE.GetValue('idtabela').Value,0)
           else
              ParamByName('xidtabela').AsInteger := 0;
           if XCNAE.TryGetValue('data',wval) then
              ParamByName('xdata').AsDate := strtodatedef(XCNAE.GetValue('data').Value,0)
           else
              ParamByName('xdata').AsDate := 0;
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
                SQL.Add('select "CodigoInternoPessoaCNAE" as id,');
                SQL.Add('       "CodigoPessoaCNAE"        as idpessoa,');
                SQL.Add('       "TabelaPessoaCNAE"        as idtabela,');
                SQL.Add('       "DataPessoaCNAE"          as data ');
                SQL.Add('from "PessoaCNAE" where "CodigoPessoaCNAE"=:xidpessoa and "DataPessoaCNAE"=:xdata ');
                ParamByName('xidpessoa').AsInteger  := XIdPessoa;
                if XCNAE.TryGetValue('data',wval) then
                   ParamByName('xdata').AsDate := strtodatedef(XCNAE.GetValue('data').Value,0)
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
              wret.AddPair('description','Nenhum CNAE incluído');
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


function AlteraCNAE(XIdCNAE: integer; XCNAE: TJSONObject): TJSONObject;
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
    if XCNAE.TryGetValue('data',wval) then
       begin
         if wcampos='' then
            wcampos := '"DataPessoaCNAE"=:xdata'
         else
            wcampos := wcampos+',"DataPessoaCNAE"=:xdata';
       end;
    if XCNAE.TryGetValue('idtabela',wval) then
       begin
         if wcampos='' then
            wcampos := '"TabelaPessoaCNAE"=:xidtabela'
         else
            wcampos := wcampos+',"TabelaPessoaCNAE"=:xidtabela';
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
           SQL.Add('Update "PessoaCNAE" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoPessoaCNAE"=:xid ');
           ParamByName('xid').AsInteger             := XIdCNAE;
           if XCNAE.TryGetValue('data',wval) then
              ParamByName('xdata').AsDate           := strtodate(XCNAE.GetValue('data').Value);
           if XCNAE.TryGetValue('idtabela',wval) then
              ParamByName('xidtabela').AsInteger    := strtointdef(XCNAE.GetValue('idtabela').Value,0);
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
              SQL.Add('select "CodigoInternoPessoaCNAE" as id,');
              SQL.Add('       "CodigoPessoaCNAE"        as idpessoa,');
              SQL.Add('       "TabelaPessoaCNAE"        as idtabela,');
              SQL.Add('       "DataPessoaCNAE"          as data ');
              SQL.Add('from "PessoaCNAE" ');
              SQL.Add('where "CodigoInternoPessoaCNAE" =:xid ');
              ParamByName('xid').AsInteger := XIdCNAE;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum CNAE alterado');
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

function VerificaRequisicao(XCNAE: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XCNAE.TryGetValue('data',wval) then
       wret := false;
  finally
  end;
  Result := wret;
end;

function ApagaCNAE(XIdCNAE: integer): TJSONObject;
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
         SQL.Add('delete from "PessoaCNAE" where "CodigoInternoPessoaCNAE"=:xid ');
         ParamByName('xid').AsInteger := XIdCNAE;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','CNAE excluído com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhum CNAE excluído');
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
