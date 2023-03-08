unit dat.cadTabelasCores;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaTabela(XId: integer): TJSONObject;
function RetornaListaTabelas(const XQuery: TDictionary<string, string>): TJSONArray;
function IncluiTabela(XTabela: TJSONObject): TJSONObject;
function AlteraTabela(XIdTabela: integer; XTabela: TJSONObject): TJSONObject;
function ApagaTabela(XIdTabela: integer): TJSONObject;
function VerificaRequisicao(XTabela: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaTabela(XId: integer): TJSONObject;
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
         SQL.Add('select  "CodigoInternoCor" as id,');
         SQL.Add('        "CodigoCor"        as codigo,');
         SQL.Add('        "NomeCor"          as nome ');
         SQL.Add('from "TabelaCor" ');
         SQL.Add('where "CodigoInternoCor"=:xid ');
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
        wret.AddPair('description','Nenhuma Tabela Cor encontrada');
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

function RetornaListaTabelas(const XQuery: TDictionary<string, string>): TJSONArray;
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
         SQL.Add('select  "CodigoInternoCor" as id,');
         SQL.Add('        "CodigoCor"        as codigo,');
         SQL.Add('        "NomeCor"          as nome ');
         SQL.Add('from "TabelaCor" where "CodigoEmpresaCor"=:xempresa ');
         ParamByName('xempresa').AsInteger := wconexao.FIdEmpresaCor;
         if XQuery.ContainsKey('codigo') then // filtro por codigo
            begin
              SQL.Add('and "CodigoCor" =:xcodigo ');
              ParamByName('xcodigo').AsString := XQuery.Items['codigo'];
              SQL.Add('order by "CodigoCor" ');
            end;
         if XQuery.ContainsKey('nome') then // filtro por nome
            begin
              SQL.Add('and lower("NomeCor") like lower(:xnome) ');
              ParamByName('xnome').AsString := XQuery.Items['nome']+'%';
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
         wobj.AddPair('description','Nenhuma Tabela Cor encontrada');
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

function IncluiTabela(XTabela: TJSONObject): TJSONObject;
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
           SQL.Add('Insert into "TabelaCor" ("CodigoEmpresaCor","CodigoCor","NomeCor") ');
           SQL.Add('values (:xidempresa,:xcodigo,:xnome) ');
           ParamByName('xidempresa').AsInteger     := wconexao.FIdEmpresaCor;
           if XTabela.TryGetValue('codigo',wval) then
              ParamByName('xcodigo').AsInteger  := strtointdef(XTabela.GetValue('codigo').Value,0)
           else
              ParamByName('xcodigo').AsInteger  := 0;
           if XTabela.TryGetValue('nome',wval) then
              ParamByName('xnome').AsString  := XTabela.GetValue('nome').Value
           else
              ParamByName('xnome').AsString  := '';
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
                SQL.Add('select  "CodigoInternoCor" as id,');
                SQL.Add('        "CodigoCor"        as codigo,');
                SQL.Add('        "NomeCor"          as nome ');
                SQL.Add('from "TabelaCor" where "CodigoEmpresaCor"=:xempresa and "CodigoCor"=:xcodigo ');
                ParamByName('xempresa').AsInteger  := wconexao.FIdEmpresaCor;
                if XTabela.TryGetValue('codigo',wval) then
                   ParamByName('xcodigo').AsInteger  := strtointdef(XTabela.GetValue('codigo').Value,0)
                else
                   ParamByName('xcodigo').AsInteger  := 0;
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhuma Tabela Cor incluída');
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


function AlteraTabela(XIdTabela: integer; XTabela: TJSONObject): TJSONObject;
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
    if XTabela.TryGetValue('codigo',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoCor"=:xcodigo'
         else
            wcampos := wcampos+',"CodigoCor"=:xcodigo';
       end;
    if XTabela.TryGetValue('nome',wval) then
       begin
         if wcampos='' then
            wcampos := '"NomeCor"=:xnome'
         else
            wcampos := wcampos+',"NomeCor"=:xnome';
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
           SQL.Add('Update "TabelaCor" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoCor"=:xid ');
           ParamByName('xid').AsInteger            := XIdTabela;
           if XTabela.TryGetValue('codigo',wval) then
              ParamByName('xcodigo').AsInteger     := strtointdef(XTabela.GetValue('codigo').Value,0);
           if XTabela.TryGetValue('nome',wval) then
              ParamByName('xnome').AsString := XTabela.GetValue('nome').Value;
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
              SQL.Add('select  "CodigoInternoCor" as id,');
              SQL.Add('        "CodigoCor"        as codigo,');
              SQL.Add('        "NomeCor"          as nome ');
              SQL.Add('from "TabelaCor" ');
              SQL.Add('where "CodigoInternoCor" =:xid ');
              ParamByName('xid').AsInteger := XIdTabela;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhuma Tabela Cor alterada');
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

function VerificaRequisicao(XTabela: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XTabela.TryGetValue('codigo',wval) then
       wret := false;
    if not XTabela.TryGetValue('nome',wval) then
       wret := false;
  finally
  end;
  Result := wret;
end;

function ApagaTabela(XIdTabela: integer): TJSONObject;
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
         SQL.Add('delete from "TabelaCor" where "CodigoInternoCor"=:xid ');
         ParamByName('xid').AsInteger := XIdTabela;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Tabela Cor excluída com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhuma Tabela Cor excluída');
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
