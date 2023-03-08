unit dat.cadTabelasPrecos;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaPreco(XId: integer): TJSONObject;
function RetornaListaPrecos(const XQuery: TDictionary<string, string>; XLimit,XOffset: integer): TJSONArray;
function RetornaTotalTabelas(const XQuery: TDictionary<string, string>): TJSONObject;
function IncluiPreco(XPreco: TJSONObject): TJSONObject;
function AlteraPreco(XIdPreco: integer; XPreco: TJSONObject): TJSONObject;
function ApagaPreco(XIdPreco: integer): TJSONObject;
function VerificaRequisicao(XPreco: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaPreco(XId: integer): TJSONObject;
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
         SQL.Add('select  "CodigoInternoTabela" as id,');
         SQL.Add('        "DescricaoTabela"     as descricao,');
         SQL.Add('        "DataFinalTabela"     as datafinal,');
         SQL.Add('        "DataInicialTabela"   as datainicial ');
         SQL.Add('from "TabelaPreco" ');
         SQL.Add('where "CodigoInternoTabela"=:xid ');
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
        wret.AddPair('description','Nenhuma Tabela Preço encontrada');
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

function RetornaTotalTabelas(const XQuery: TDictionary<string, string>): TJSONObject;
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
         SQL.Add('from "TabelaPreco" where "CodigoEmpresaTabela"=:xempresa ');
         if XQuery.ContainsKey('descricao') then // filtro por nome
            begin
              SQL.Add('and lower("DescricaoTabela") like lower(:xdescricao) ');
              ParamByName('xdescricao').AsString := XQuery.Items['descricao']+'%';
            end;
         ParamByName('xempresa').AsInteger := wconexao.FIdEmpresaTabelaPreco;
         Open;
         EnableControls;
       end;

   if wquery.RecordCount>0 then
      wret := wquery.ToJSONObject()
   else
      begin
        wret := TJSONObject.Create;
        wret.AddPair('status','500');
        wret.AddPair('description','Nenhuma tabela de preço encontrada');
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


function RetornaListaPrecos(const XQuery: TDictionary<string, string>; XLimit,XOffset: integer): TJSONArray;
var wqueryLista: TFDQuery;
    wconexao: TProviderDataModuleConexao;
    wobj: TJSONObject;
    wret: TJSONArray;
    wordem: string;
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
         SQL.Add('select  "CodigoInternoTabela" as id,');
         SQL.Add('        "DescricaoTabela"     as descricao,');
         SQL.Add('        "DataFinalTabela"     as datafinal,');
         SQL.Add('        "DataInicialTabela"   as datainicial ');
         SQL.Add('from "TabelaPreco" where "CodigoEmpresaTabela"=:xempresa ');
         ParamByName('xempresa').AsInteger := wconexao.FIdEmpresaTabelaPreco;
         if XQuery.ContainsKey('descricao') then // filtro por nome
            begin
              SQL.Add('and lower("DescricaoTabela") like lower(:xdescricao) ');
              ParamByName('xdescricao').AsString := XQuery.Items['descricao']+'%';
            end;
         if XQuery.ContainsKey('order') then // ordenação
            begin
              if XQuery.Items['order']='descricao' then
                 wordem := 'order by upper("DescricaoTabela") '
              else if XQuery.Items['order']='datainicial' then
                 wordem := 'order by "DataInicialTabela" '
              else if XQuery.Items['order']='datafinal' then
                 wordem := 'order by "DataFinalTabela" ';
              if XQuery.ContainsKey('dir') then // direção
                 wordem := wordem +XQuery.Items['dir'];
              SQL.Add(wordem);
            end
         else
            SQL.Add('order by upper("DescricaoTabela") ');
         if XLimit>0 then
            SQL.Add('Limit '+inttostr(XLimit)+' offset '+inttostr(XOffset));
         Open;
         EnableControls;
       end;
    if wqueryLista.RecordCount>0 then
       wret := wqueryLista.ToJSONArray()
    else
       begin
         wobj := TJSONObject.Create;
         wobj.AddPair('status','500');
         wobj.AddPair('description','Nenhuma Tabela Preço encontrada');
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

function IncluiPreco(XPreco: TJSONObject): TJSONObject;
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
           SQL.Add('Insert into "TabelaPreco" ("CodigoEmpresaTabela","DescricaoTabela","DataFinalTabela","DataInicialTabela") ');
           SQL.Add('values (:xidempresa,:xdescricao,:xdatafinal,:xdatainicial) ');
           ParamByName('xidempresa').AsInteger       := wconexao.FIdEmpresaTabelaPreco;
           if XPreco.TryGetValue('descricao',wval) then
              ParamByName('xdescricao').AsString  := XPreco.GetValue('descricao').Value
           else
              ParamByName('xdescricao').AsString  := '';
           if XPreco.TryGetValue('datafinal',wval) then
              ParamByName('xdatafinal').AsDate  := strtodatedef(XPreco.GetValue('datafinal').Value,0)
           else
              ParamByName('xdatafinal').AsDate  := 0;
           if XPreco.TryGetValue('datainicial',wval) then
              ParamByName('xdatainicial').AsDate  := strtodatedef(XPreco.GetValue('datainicial').Value,0)
           else
              ParamByName('xdatainicial').AsDate  := 0;
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
                SQL.Add('select  "CodigoInternoTabela" as id,');
                SQL.Add('        "DescricaoTabela"     as descricao,');
                SQL.Add('        "DataFinalTabela"     as datafinal,');
                SQL.Add('        "DataInicialTabela"   as datainicial ');
                SQL.Add('from "TabelaPreco" where "CodigoEmpresaTabela"=:xempresa and "DescricaoTabela"=:xdescricao ');
                ParamByName('xempresa').AsInteger  := wconexao.FIdEmpresaTabelaPreco;
                if XPreco.TryGetValue('descricao',wval) then
                   ParamByName('xdescricao').AsString  := XPreco.GetValue('descricao').Value
                else
                   ParamByName('xdescricao').AsString  := '';
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhuma Tabela Preço incluída');
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

function AlteraPreco(XIdPreco: integer; XPreco: TJSONObject): TJSONObject;
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
    if XPreco.TryGetValue('descricao',wval) then
       begin
         if wcampos='' then
            wcampos := '"DescricaoTabela"=:xdescricao'
         else
            wcampos := wcampos+',"DescricaoTabela"=:xdescricao';
       end;
    if XPreco.TryGetValue('datafinal',wval) then
       begin
         if wcampos='' then
            wcampos := '"DataFinalTabela"=:xdatafinal'
         else
            wcampos := wcampos+',"DataFinalTabela"=:xdatafinal';
       end;
    if XPreco.TryGetValue('datainicial',wval) then
       begin
         if wcampos='' then
            wcampos := '"DataInicialTabela"=:xdatainicial'
         else
            wcampos := wcampos+',"DataInicialTabela"=:xdatainicial';
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
           SQL.Add('Update "TabelaPreco" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoTabela"=:xid ');
           ParamByName('xid').AsInteger            := XIdPreco;
           if XPreco.TryGetValue('descricao',wval) then
              ParamByName('xdescricao').AsString   := XPreco.GetValue('descricao').Value;
           if XPreco.TryGetValue('datafinal',wval) then
              ParamByName('xdatafinal').AsDate     := Strtodatedef(XPreco.GetValue('datafinal').Value,0);
           if XPreco.TryGetValue('datainicial',wval) then
              ParamByName('xdatainicial').AsDate   := Strtodatedef(XPreco.GetValue('datainicial').Value,0);
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
              SQL.Add('select  "CodigoInternoTabela" as id,');
              SQL.Add('        "DescricaoTabela"     as descricao,');
              SQL.Add('        "DataFinalTabela"     as datafinal,');
              SQL.Add('        "DataInicialTabela"   as datainicial ');
              SQL.Add('from "TabelaPreco" ');
              SQL.Add('where "CodigoInternoTabela" =:xid ');
              ParamByName('xid').AsInteger := XIdPreco;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhuma Tabela Preço alterada');
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

function VerificaRequisicao(XPreco: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XPreco.TryGetValue('descricao',wval) then
       wret := false;
  finally
  end;
  Result := wret;
end;

function ApagaPreco(XIdPreco: integer): TJSONObject;
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
         SQL.Add('delete from "TabelaPreco" where "CodigoInternoTabela"=:xid ');
         ParamByName('xid').AsInteger := XIdPreco;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Tabela Preço excluída com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhuma Tabela Preço excluída');
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
