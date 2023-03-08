unit dat.cadPessoasContatos;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaContato(XId: integer): TJSONObject;
function RetornaListaContatos(const XQuery: TDictionary<string, string>; XIdPessoa: integer): TJSONArray;
function IncluiContato(XContato: TJSONObject; XIdPessoa: integer): TJSONObject;
function AlteraContato(XIdContato: integer; XContato: TJSONObject): TJSONObject;
function ApagaContato(XIdContato: integer): TJSONObject;
function VerificaRequisicao(XContato: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaContato(XId: integer): TJSONObject;
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
         SQL.Add('select "CodigoInternoContatos"   as id,');
         SQL.Add('       "CodigoPessoaContatos"    as idpessoa,');
         SQL.Add('       "TelefoneContatos"        as telefone,');
         SQL.Add('       "NomeContatos"            as nome,');
         SQL.Add('       "EmailContatos"           as email,');
         SQL.Add('       "CodigoAtividadeContatos" as idatividade,');
         SQL.Add('       "WhatsAppContatos"        as whatsapp,');
         SQL.Add('       "EmailMKTContatos"        as emailmkt ');
         SQL.Add('from "PessoaContatos" ');
         SQL.Add('where "CodigoInternoContatos"=:xid ');
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
        wret.AddPair('description','Nenhum Contato encontrado');
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

function RetornaListaContatos(const XQuery: TDictionary<string, string>; XIdPessoa: integer): TJSONArray;
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
         SQL.Add('select "CodigoInternoContatos"   as id,');
         SQL.Add('       "CodigoPessoaContatos"    as idpessoa,');
         SQL.Add('       "TelefoneContatos"        as telefone,');
         SQL.Add('       "NomeContatos"            as nome,');
         SQL.Add('       "EmailContatos"           as email,');
         SQL.Add('       "CodigoAtividadeContatos" as idatividade,');
         SQL.Add('       "WhatsAppContatos"        as whatsapp,');
         SQL.Add('       "EmailMKTContatos"        as emailmkt ');
         SQL.Add('from "PessoaContatos" where "CodigoPessoaContatos"=:xidpessoa ');
         ParamByName('xidpessoa').AsInteger := XIdPessoa;;
         if XQuery.ContainsKey('telefone') then // filtro por telefone
            begin
              SQL.Add('and lower("TelefoneContatos") like lower(:xtelefone) ');
              ParamByName('xtelefone').AsString := XQuery.Items['telefone']+'%';
              SQL.Add('order by "TelefoneContatos" ');
            end;
         if XQuery.ContainsKey('nome') then // filtro por nome
            begin
              SQL.Add('and lower("NomeContatos") like lower(:xnome) ');
              ParamByName('xnome').AsString := XQuery.Items['nome']+'%';
              SQL.Add('order by "NomeContatos" ');
            end;
         if XQuery.ContainsKey('email') then // filtro por email
            begin
              SQL.Add('and lower("EmailContatos") like lower(:xemail) ');
              ParamByName('xemail').AsString := XQuery.Items['email']+'%';
              SQL.Add('order by "EmailContatos" ');
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
         wobj.AddPair('description','Nenhum Contato encontrado');
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

function IncluiContato(XContato: TJSONObject; XIdPessoa: integer): TJSONObject;
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
           SQL.Add('Insert into "PessoaContatos" ("CodigoPessoaContatos","TelefoneContatos","NomeContatos","EmailContatos",');
           SQL.Add('"CodigoAtividadeContatos","WhatsAppContatos","EmailMKTContatos") ');
           SQL.Add('values (:xidpessoa,:xtelefone,:xnome,:xemail,');
           SQL.Add('(case when :xidatividade>0 then :xidatividade else null end),:xwhatsapp,:xemailmkt) ');
           ParamByName('xidpessoa').AsInteger   := XIdPessoa;
           if XContato.TryGetValue('telefone',wval) then
              ParamByName('xtelefone').AsString := XContato.GetValue('telefone').Value
           else
              ParamByName('xtelefone').AsString := '';
           if XContato.TryGetValue('nome',wval) then
              ParamByName('xnome').AsString := XContato.GetValue('nome').Value
           else
              ParamByName('xnome').AsString := '';
           if XContato.TryGetValue('email',wval) then
              ParamByName('xemail').AsString := XContato.GetValue('email').Value
           else
              ParamByName('xemail').AsString := '';
           if XContato.TryGetValue('idatividade',wval) then
              ParamByName('xidatividade').AsInteger := strtointdef(XContato.GetValue('idatividade').Value,0)
           else
              ParamByName('xidatividade').AsInteger := 0;
           if XContato.TryGetValue('whatsapp',wval) then
              ParamByName('xwhatsapp').AsBoolean := strtobooldef(XContato.GetValue('whatsapp').Value,false)
           else
              ParamByName('xwhatsapp').AsBoolean := false;
           if XContato.TryGetValue('emailmkt',wval) then
              ParamByName('xemailmkt').AsBoolean := strtobooldef(XContato.GetValue('emailmkt').Value,false)
           else
              ParamByName('xemailmkt').AsBoolean := false;
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
                SQL.Add('select "CodigoInternoContatos"   as id,');
                SQL.Add('       "CodigoPessoaContatos"    as idpessoa,');
                SQL.Add('       "TelefoneContatos"        as telefone,');
                SQL.Add('       "NomeContatos"            as nome,');
                SQL.Add('       "EmailContatos"           as email,');
                SQL.Add('       "CodigoAtividadeContatos" as idatividade,');
                SQL.Add('       "WhatsAppContatos"        as whatsapp,');
                SQL.Add('       "EmailMKTContatos"        as emailmkt ');
                SQL.Add('from "PessoaContatos" where "CodigoPessoaContatos"=:xidpessoa and "TelefoneContatos"=:xtelefone ');
                ParamByName('xidpessoa').AsInteger  := XIdPessoa;
                if XContato.TryGetValue('telefone',wval) then
                   ParamByName('xtelefone').AsString := XContato.GetValue('telefone').Value
                else
                   ParamByName('xtelefone').AsString := '';
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Contato incluído');
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


function AlteraContato(XIdContato: integer; XContato: TJSONObject): TJSONObject;
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
    if XContato.TryGetValue('telefone',wval) then
       begin
         if wcampos='' then
            wcampos := '"TelefoneContatos"=:xtelefone'
         else
            wcampos := wcampos+',"TelefoneContatos"=:xtelefone';
       end;
    if XContato.TryGetValue('nome',wval) then
       begin
         if wcampos='' then
            wcampos := '"NomeContatos"=:xnome'
         else
            wcampos := wcampos+',"NomeContatos"=:xnome';
       end;
    if XContato.TryGetValue('email',wval) then
       begin
         if wcampos='' then
            wcampos := '"EmailContatos"=:xemail'
         else
            wcampos := wcampos+',"EmailContatos"=:xemail';
       end;
    if XContato.TryGetValue('idatividade',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoAtividadeContatos"=:xidatividade'
         else
            wcampos := wcampos+',"CodigoAtividadeContatos"=:xidatividade';
       end;
    if XContato.TryGetValue('whatsapp',wval) then
       begin
         if wcampos='' then
            wcampos := '"WhatsAppContatos"=:xwhatsapp'
         else
            wcampos := wcampos+',"WhatsAppContatos"=:xwhatsapp';
       end;
    if XContato.TryGetValue('emailmkt',wval) then
       begin
         if wcampos='' then
            wcampos := '"EmailMKTContatos"=:xemailmkt'
         else
            wcampos := wcampos+',"EmailMKTContatos"=:xemailmkt';
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
           SQL.Add('Update "PessoaContatos" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoContatos"=:xid ');
           ParamByName('xid').AsInteger             := XIdContato;
           if XContato.TryGetValue('nome',wval) then
              ParamByName('xnome').AsString         := XContato.GetValue('nome').Value;
           if XContato.TryGetValue('telefone',wval) then
              ParamByName('xtelefone').AsString     := XContato.GetValue('telefone').Value;
           if XContato.TryGetValue('email',wval) then
              ParamByName('xemail').AsString        := XContato.GetValue('email').Value;
           if XContato.TryGetValue('idatividade',wval) then
              ParamByName('xidatividade').AsInteger := strtointdef(XContato.GetValue('idatividade').Value,0);
           if XContato.TryGetValue('whatsapp',wval) then
              ParamByName('xwhatsapp').AsBoolean    := strtobooldef(XContato.GetValue('whatsapp').Value,false);
           if XContato.TryGetValue('emailmkt',wval) then
              ParamByName('xemailmkt').AsBoolean    := strtobooldef(XContato.GetValue('emailmkt').Value,false);
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
              SQL.Add('select "CodigoInternoContatos"   as id,');
              SQL.Add('       "CodigoPessoaContatos"    as idpessoa,');
              SQL.Add('       "TelefoneContatos"        as telefone,');
              SQL.Add('       "NomeContatos"            as nome,');
              SQL.Add('       "EmailContatos"           as email,');
              SQL.Add('       "CodigoAtividadeContatos" as idatividade,');
              SQL.Add('       "WhatsAppContatos"        as whatsapp,');
              SQL.Add('       "EmailMKTContatos"        as emailmkt ');
              SQL.Add('from "PessoaContatos" ');
              SQL.Add('where "CodigoInternoContatos" =:xid ');
              ParamByName('xid').AsInteger := XIdContato;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Contato alterado');
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

function VerificaRequisicao(XContato: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XContato.TryGetValue('nome',wval) then
       wret := false;
  finally
  end;
  Result := wret;
end;

function ApagaContato(XIdContato: integer): TJSONObject;
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
         SQL.Add('delete from "PessoaContatos" where "CodigoInternoContatos"=:xid ');
         ParamByName('xid').AsInteger := XIdContato;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Contato excluído com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhum Contato excluído');
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
