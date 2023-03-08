unit dat.cadPessoasDescFabricantes;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaDescFabricante(XId: integer): TJSONObject;
function RetornaListaDescFabricantes(const XQuery: TDictionary<string, string>; XIdPessoa: integer): TJSONArray;
function IncluiDescFabricante(XDescFabricante: TJSONObject; XIdPessoa: integer): TJSONObject;
function AlteraDescFabricante(XIdDescFabricante: integer; XDescFabricante: TJSONObject): TJSONObject;
function ApagaDescFabricante(XIdDescFabricante: integer): TJSONObject;
function VerificaRequisicao(XDescFabricante: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaDescFabricante(XId: integer): TJSONObject;
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
         SQL.Add('select  "CodigoInternoDescFabricante"    as id,');
         SQL.Add('        "CodigoPessoaDescFabricante"     as idpessoa,');
         SQL.Add('        "CodigoFabricanteDescFabricante" as idfabricante,');
         SQL.Add('        "PercentualDescFabricante"       as percdesc,');
         SQL.Add('        "DataValidadeDescFabricante"     as datavalidade ');
         SQL.Add('from "PessoaDescFabricante" ');
         SQL.Add('where "CodigoInternoDescFabricante"=:xid ');
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
        wret.AddPair('description','Nenhum Desc Fabricante encontrado');
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

function RetornaListaDescFabricantes(const XQuery: TDictionary<string, string>; XIdPessoa: integer): TJSONArray;
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
         SQL.Add('select  "CodigoInternoDescFabricante"    as id,');
         SQL.Add('        "CodigoPessoaDescFabricante"     as idpessoa,');
         SQL.Add('        "CodigoFabricanteDescFabricante" as idfabricante,');
         SQL.Add('        "PercentualDescFabricante"       as percdesc,');
         SQL.Add('        "DataValidadeDescFabricante"     as datavalidade ');
         SQL.Add('from "PessoaDescFabricante" where "CodigoPessoaDescFabricante"=:xidpessoa ');
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
         wobj.AddPair('description','Nenhum Desc Fabricante encontrado');
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

function IncluiDescFabricante(XDescFabricante: TJSONObject; XIdPessoa: integer): TJSONObject;
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
           SQL.Add('Insert into "PessoaDescFabricante" ("CodigoPessoaDescFabricante","CodigoFabricanteDescFabricante",');
           SQL.Add('"PercentualDescFabricante","DataValidadeDescFabricante") ');
           SQL.Add('values (:xidpessoa,:xidfabricante,');
           SQL.Add(':xpercdesc,:xdatavalidade) ');
           ParamByName('xidpessoa').AsInteger   := XIdPessoa;
           if XDescFabricante.TryGetValue('idfabricante',wval) then
              ParamByName('xidfabricante').AsInteger := strtointdef(XDescFabricante.GetValue('idfabricante').Value,0)
           else
              ParamByName('xidfabricante').AsInteger := 0;
           if XDescFabricante.TryGetValue('percdesc',wval) then
              ParamByName('xpercdesc').AsFloat := strtofloatdef(XDescFabricante.GetValue('percdesc').Value,0)
           else
              ParamByName('xpercdesc').AsFloat := 0;
           if XDescFabricante.TryGetValue('datavalidade',wval) then
              ParamByName('xdatavalidade').AsDate := strtodatedef(XDescFabricante.GetValue('datavalidade').Value,0)
           else
              ParamByName('xdatavalidade').AsDate := 0;
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
                SQL.Add('select  "CodigoInternoDescFabricante"    as id,');
                SQL.Add('        "CodigoPessoaDescFabricante"     as idpessoa,');
                SQL.Add('        "CodigoFabricanteDescFabricante" as idfabricante,');
                SQL.Add('        "PercentualDescFabricante"       as percdesc,');
                SQL.Add('        "DataValidadeDescFabricante"     as datavalidade ');
                SQL.Add('from "PessoaDescFabricante" where "CodigoPessoaDescFabricante"=:xidpessoa and "PercentualDescFabricante"=:xpercdesc ');
                ParamByName('xidpessoa').AsInteger  := XIdPessoa;
                if XDescFabricante.TryGetValue('percdesc',wval) then
                   ParamByName('xpercdesc').AsFloat := strtofloatdef(XDescFabricante.GetValue('percdesc').Value,0)
                else
                   ParamByName('xpercdesc').AsFloat := 0;
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Desc Fabricante incluído');
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


function AlteraDescFabricante(XIdDescFabricante: integer; XDescFabricante: TJSONObject): TJSONObject;
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
    if XDescFabricante.TryGetValue('idfabricante',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoFabricanteDescFabricante"=:xidfabricante'
         else
            wcampos := wcampos+',"CodigoFabricanteDescFabricante"=:xidfabricante';
       end;
    if XDescFabricante.TryGetValue('percdesc',wval) then
       begin
         if wcampos='' then
            wcampos := '"PercentualDescFabricante"=:xpercdesc'
         else
            wcampos := wcampos+',"PercentualDescFabricante"=:xpercdesc';
       end;
    if XDescFabricante.TryGetValue('datavalidade',wval) then
       begin
         if wcampos='' then
            wcampos := '"DataValidadeDescFabricante"=:xdatavalidade'
         else
            wcampos := wcampos+',"DataValidadeDescFabricante"=:xdatavalidade';
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
           SQL.Add('Update "PessoaDescFabricante" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoDescFabricante"=:xid ');
           ParamByName('xid').AsInteger               := XIdDescFabricante;
           if XDescFabricante.TryGetValue('idfabricante',wval) then
              ParamByName('xidfabricante').AsInteger  := strtointdef(XDescFabricante.GetValue('idfabricante').Value,0);
           if XDescFabricante.TryGetValue('percdesc',wval) then
              ParamByName('xpercdesc').AsFloat        := strtofloatdef(XDescFabricante.GetValue('percdesc').Value,0);
           if XDescFabricante.TryGetValue('datavalidade',wval) then
              ParamByName('xdatavalidade').AsDate     := strtodatedef(XDescFabricante.GetValue('datavalidade').Value,0);
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
              SQL.Add('select  "CodigoInternoDescFabricante"    as id,');
              SQL.Add('        "CodigoPessoaDescFabricante"     as idpessoa,');
              SQL.Add('        "CodigoFabricanteDescFabricante" as idfabricante,');
              SQL.Add('        "PercentualDescFabricante"       as percdesc,');
              SQL.Add('        "DataValidadeDescFabricante"     as datavalidade ');
              SQL.Add('from "PessoaDescFabricante" ');
              SQL.Add('where "CodigoInternoDescFabricante" =:xid ');
              ParamByName('xid').AsInteger := XIdDescFabricante;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Desc Fabricante alterado');
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

function VerificaRequisicao(XDescFabricante: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XDescFabricante.TryGetValue('percdesc',wval) then
       wret := false;
    if not XDescFabricante.TryGetValue('idfabricante',wval) then
       wret := false;
  finally
  end;
  Result := wret;
end;

function ApagaDescFabricante(XIdDescFabricante: integer): TJSONObject;
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
         SQL.Add('delete from "PessoaDescFabricante" where "CodigoInternoDescFabricante"=:xid ');
         ParamByName('xid').AsInteger := XIdDescFabricante;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Desc Fabricante excluído com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhum Desc Fabricante excluído');
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
