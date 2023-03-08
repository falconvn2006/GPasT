unit dat.cadPessoasDependentes;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaDependente(XId: integer): TJSONObject;
function RetornaListaDependentes(const XQuery: TDictionary<string, string>; XIdPessoa: integer): TJSONArray;
function IncluiDependente(XDependente: TJSONObject; XIdPessoa: integer): TJSONObject;
function AlteraDependente(XIdDependente: integer; XDependente: TJSONObject): TJSONObject;
function ApagaDependente(XIdDependente: integer): TJSONObject;
function VerificaRequisicao(XDependente: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaDependente(XId: integer): TJSONObject;
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
         SQL.Add('select "CodigoInternoDependente" as id,');
         SQL.Add('       "CodigoPessoaDependente"  as idpessoa,');
         SQL.Add('       "NomeDependente"          as nome,');
         SQL.Add('       "GrauDependente"          as grau,');
         SQL.Add('       "NascimentoDependente"    as datanascimento,');
         SQL.Add('       "SituacaoDependente"      as situacao,');
         SQL.Add('       "DataSituacaoDependente"  as datasituacao,');
         SQL.Add('       "ObservacaoDependente"    as observacao,');
         SQL.Add('       "CaminhoFotoDependente"   as caminhofoto,');
         SQL.Add('       "CpfDependente"           as cpf,');
         SQL.Add('       "IdentidadeDependente"    as rg,');
         SQL.Add('       "DataCadastramentoDependente" as datacadastramento ');
         SQL.Add('from "PessoaDependente" ');
         SQL.Add('where "CodigoInternoDependente"=:xid ');
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
        wret.AddPair('description','Nenhum Dependente encontrado');
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

function RetornaListaDependentes(const XQuery: TDictionary<string, string>; XIdPessoa: integer): TJSONArray;
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
         SQL.Add('select "CodigoInternoDependente" as id,');
         SQL.Add('       "CodigoPessoaDependente"  as idpessoa,');
         SQL.Add('       "NomeDependente"          as nome,');
         SQL.Add('       "GrauDependente"          as grau,');
         SQL.Add('       "NascimentoDependente"    as datanascimento,');
         SQL.Add('       "SituacaoDependente"      as situacao,');
         SQL.Add('       "DataSituacaoDependente"  as datasituacao,');
         SQL.Add('       "ObservacaoDependente"    as observacao,');
         SQL.Add('       "CaminhoFotoDependente"   as caminhofoto,');
         SQL.Add('       "CpfDependente"           as cpf,');
         SQL.Add('       "IdentidadeDependente"    as rg,');
         SQL.Add('       "DataCadastramentoDependente" as datacadastramento ');
         SQL.Add('from "PessoaDependente" where "CodigoPessoaDependente"=:xidpessoa ');
         ParamByName('xidpessoa').AsInteger := XIdPessoa;;
         if XQuery.ContainsKey('nome') then // filtro por nome
            begin
              SQL.Add('and lower("NomeDependente") like lower(:xnome) ');
              ParamByName('xnome').AsString := XQuery.Items['nome']+'%';
              SQL.Add('order by "NomeDependente" ');
            end;
         if XQuery.ContainsKey('cpf') then // filtro por cpf
            begin
              SQL.Add('and "CpfDependente" =:xcpf ');
              ParamByName('xcpf').AsString := XQuery.Items['cpf'];
              SQL.Add('order by "CpfDependente" ');
            end;
         if XQuery.ContainsKey('rg') then // filtro por rg
            begin
              SQL.Add('and "IdentidadeDependente" =:xrg ');
              ParamByName('xrg').AsString := XQuery.Items['rg'];
              SQL.Add('order by "IdentidadeDependente" ');
            end;
         if XQuery.ContainsKey('datanascimento') then // filtro por data nascimento
            begin
              SQL.Add('and "NascimentoDependente" =:xdatanascimento ');
              ParamByName('xdatanascimento').AsString := XQuery.Items['datanascimento'];
              SQL.Add('order by "NascimentoDependente" ');
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
         wobj.AddPair('description','Nenhum Dependente encontrado');
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

function IncluiDependente(XDependente: TJSONObject; XIdPessoa: integer): TJSONObject;
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
           SQL.Add('Insert into "PessoaDependente" ("CodigoPessoaDependente","NomeDependente","GrauDependente",');
           SQL.Add('"NascimentoDependente","SituacaoDependente","DataSituacaoDependente","ObservacaoDependente",');
           SQL.Add('"CaminhoFotoDependente","CpfDependente","IdentidadeDependente","DataCadastramentoDependente") ');
           SQL.Add('values (:xidpessoa,:xnome,:xgrau,');
           SQL.Add(':xdatanascimento,:xsituacao,:xdatasituacao,:xobservacao,');
           SQL.Add(':xcaminhofoto,:xcpf,:xrg,:xdatacadastramento) ');
           ParamByName('xidpessoa').AsInteger   := XIdPessoa;
           if XDependente.TryGetValue('nome',wval) then
              ParamByName('xnome').AsString := XDependente.GetValue('nome').Value
           else
              ParamByName('xnome').AsString := '';
           if XDependente.TryGetValue('grau',wval) then
              ParamByName('xgrau').AsString := XDependente.GetValue('grau').Value
           else
              ParamByName('xgrau').AsString := '';
           if XDependente.TryGetValue('datanascimento',wval) then
              ParamByName('xdatanascimento').AsDate := strtodatedef(XDependente.GetValue('datanascimento').Value,0)
           else
              ParamByName('xdatanascimento').AsDate := 0;
           if XDependente.TryGetValue('situacao',wval) then
              ParamByName('xsituacao').AsString := XDependente.GetValue('situacao').Value
           else
              ParamByName('xsituacao').AsString := '';
           if XDependente.TryGetValue('datasituacao',wval) then
              ParamByName('xdatasituacao').AsDate := strtodatedef(XDependente.GetValue('datasituacao').Value,0)
           else
              ParamByName('xdatasituacao').AsDate := 0;
           if XDependente.TryGetValue('observacao',wval) then
              ParamByName('xobservacao').AsString := XDependente.GetValue('observacao').Value
           else
              ParamByName('xobservacao').AsString := '';
           if XDependente.TryGetValue('caminhofoto',wval) then
              ParamByName('xcaminhofoto').AsString := XDependente.GetValue('caminhofoto').Value
           else
              ParamByName('xcaminhofoto').AsString := '';
           if XDependente.TryGetValue('cpf',wval) then
              ParamByName('xcpf').AsString := XDependente.GetValue('cpf').Value
           else
              ParamByName('xcpf').AsString := '';
           if XDependente.TryGetValue('rg',wval) then
              ParamByName('xrg').AsString := XDependente.GetValue('rg').Value
           else
              ParamByName('xrg').AsString := '';
           if XDependente.TryGetValue('datacadastramento',wval) then
              ParamByName('xdatacadastramento').AsDate := strtodatedef(XDependente.GetValue('datacadastramento').Value,date)
           else
              ParamByName('xdatacadastramento').AsDate := date;
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
                SQL.Add('select "CodigoInternoDependente" as id,');
                SQL.Add('       "CodigoPessoaDependente"  as idpessoa,');
                SQL.Add('       "NomeDependente"          as nome,');
                SQL.Add('       "GrauDependente"          as grau,');
                SQL.Add('       "NascimentoDependente"    as datanascimento,');
                SQL.Add('       "SituacaoDependente"      as situacao,');
                SQL.Add('       "DataSituacaoDependente"  as datasituacao,');
                SQL.Add('       "ObservacaoDependente"    as observacao,');
                SQL.Add('       "CaminhoFotoDependente"   as caminhofoto,');
                SQL.Add('       "CpfDependente"           as cpf,');
                SQL.Add('       "IdentidadeDependente"    as rg,');
                SQL.Add('       "DataCadastramentoDependente" as datacadastramento ');
                SQL.Add('from "PessoaDependente" where "CodigoPessoaDependente"=:xidpessoa and "NomeDependente"=:xnome ');
                ParamByName('xidpessoa').AsInteger  := XIdPessoa;
                if XDependente.TryGetValue('nome',wval) then
                   ParamByName('xnome').AsString := XDependente.GetValue('nome').Value
                else
                   ParamByName('xnome').AsString := '';
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Dependente incluído');
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


function AlteraDependente(XIdDependente: integer; XDependente: TJSONObject): TJSONObject;
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
    if XDependente.TryGetValue('nome',wval) then
       begin
         if wcampos='' then
            wcampos := '"NomeDependente"=:xnome'
         else
            wcampos := wcampos+',"NomeDependente"=:xnome';
       end;
    if XDependente.TryGetValue('grau',wval) then
       begin
         if wcampos='' then
            wcampos := '"GrauDependente"=:xgrau'
         else
            wcampos := wcampos+',"GrauDependente"=:xgrau';
       end;
    if XDependente.TryGetValue('datanascimento',wval) then
       begin
         if wcampos='' then
            wcampos := '"NascimentoDependente"=:xdatanascimento'
         else
            wcampos := wcampos+',"NascimentoDependente"=:xdatanascimento';
       end;
    if XDependente.TryGetValue('situacao',wval) then
       begin
         if wcampos='' then
            wcampos := '"SituacaoDependente"=:xsituacao'
         else
            wcampos := wcampos+',"SituacaoDependente"=:xsituacao';
       end;
    if XDependente.TryGetValue('datasituacao',wval) then
       begin
         if wcampos='' then
            wcampos := '"DataSituacaoDependente"=:xdatasituacao'
         else
            wcampos := wcampos+',"DataSituacaoDependente"=:xdatasituacao';
       end;
    if XDependente.TryGetValue('observacao',wval) then
       begin
         if wcampos='' then
            wcampos := '"ObservacaoDependente"=:xobservacao'
         else
            wcampos := wcampos+',"ObservacaoDependente"=:xobservacao';
       end;
    if XDependente.TryGetValue('caminhofoto',wval) then
       begin
         if wcampos='' then
            wcampos := '"CaminhoFotoDependente"=:xcaminhofoto'
         else
            wcampos := wcampos+',"CaminhoFotoDependente"=:xcaminhofoto';
       end;
    if XDependente.TryGetValue('cpf',wval) then
       begin
         if wcampos='' then
            wcampos := '"CpfDependente"=:xcpf'
         else
            wcampos := wcampos+',"CpfDependente"=:xcpf';
       end;
    if XDependente.TryGetValue('rg',wval) then
       begin
         if wcampos='' then
            wcampos := '"IdentidadeDependente"=:xrg'
         else
            wcampos := wcampos+',"IdentidadeDependente"=:xrg';
       end;
    if XDependente.TryGetValue('datacadastramento',wval) then
       begin
         if wcampos='' then
            wcampos := '"DataCadastramentoDependente"=:xdatacadastramento'
         else
            wcampos := wcampos+',"DataCadastramentoDependente"=:xdatacadastramento';
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
           SQL.Add('Update "PessoaDependente" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoDependente"=:xid ');
           ParamByName('xid').AsInteger             := XIdDependente;
           if XDependente.TryGetValue('nome',wval) then
              ParamByName('xnome').AsString         := XDependente.GetValue('nome').Value;
           if XDependente.TryGetValue('grau',wval) then
              ParamByName('xgrau').AsString         := XDependente.GetValue('grau').Value;
           if XDependente.TryGetValue('datanascimento',wval) then
              ParamByName('xdatanascimento').AsDate := strtodatedef(XDependente.GetValue('datanascimento').Value,0);
           if XDependente.TryGetValue('situacao',wval) then
              ParamByName('xsituacao').AsString     := XDependente.GetValue('situacao').Value;
           if XDependente.TryGetValue('datasituacao',wval) then
              ParamByName('xdatasituacao').AsDate   := strtodatedef(XDependente.GetValue('datasituacao').Value,0);
           if XDependente.TryGetValue('observacao',wval) then
              ParamByName('xobservacao').AsString   := XDependente.GetValue('observacao').Value;
           if XDependente.TryGetValue('caminhofoto',wval) then
              ParamByName('xcaminhofoto').AsString  := XDependente.GetValue('caminhofoto').Value;
           if XDependente.TryGetValue('cpf',wval) then
              ParamByName('xcpf').AsString          := XDependente.GetValue('cpf').Value;
           if XDependente.TryGetValue('rg',wval) then
              ParamByName('xrg').AsString           := XDependente.GetValue('rg').Value;
           if XDependente.TryGetValue('datacadastramento',wval) then
              ParamByName('xdatacadastramento').AsDate  := strtodatedef(XDependente.GetValue('datacadastramento').Value,0);
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
              SQL.Add('select "CodigoInternoDependente" as id,');
              SQL.Add('       "CodigoPessoaDependente"  as idpessoa,');
              SQL.Add('       "NomeDependente"          as nome,');
              SQL.Add('       "GrauDependente"          as grau,');
              SQL.Add('       "NascimentoDependente"    as datanascimento,');
              SQL.Add('       "SituacaoDependente"      as situacao,');
              SQL.Add('       "DataSituacaoDependente"  as datasituacao,');
              SQL.Add('       "ObservacaoDependente"    as observacao,');
              SQL.Add('       "CaminhoFotoDependente"   as caminhofoto,');
              SQL.Add('       "CpfDependente"           as cpf,');
              SQL.Add('       "IdentidadeDependente"    as rg,');
              SQL.Add('       "DataCadastramentoDependente" as datacadastramento ');
              SQL.Add('from "PessoaDependente" ');
              SQL.Add('where "CodigoInternoDependente" =:xid ');
              ParamByName('xid').AsInteger := XIdDependente;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Dependente alterado');
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

function VerificaRequisicao(XDependente: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XDependente.TryGetValue('nome',wval) then
       wret := false;
    if not XDependente.TryGetValue('datanascimento',wval) then
       wret := false;
  finally
  end;
  Result := wret;
end;

function ApagaDependente(XIdDependente: integer): TJSONObject;
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
         SQL.Add('delete from "PessoaDependente" where "CodigoInternoDependente"=:xid ');
         ParamByName('xid').AsInteger := XIdDependente;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Dependente excluído com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhum Dependente excluído');
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
