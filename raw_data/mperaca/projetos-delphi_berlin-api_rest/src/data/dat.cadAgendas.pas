unit dat.cadAgendas;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaAgenda(XId: integer): TJSONObject;
function RetornaListaAgendas(const XQuery: TDictionary<string, string>; XLimit,XOffset: integer): TJSONArray;
function RetornaTotalAgendas(const XQuery: TDictionary<string, string>): TJSONObject;
function IncluiAgenda(XAgenda: TJSONObject): TJSONObject;
function AlteraAgenda(XIdAgenda: integer; XAgenda: TJSONObject): TJSONObject;
function ApagaAgenda(XIdAgenda: integer): TJSONObject;
function VerificaRequisicao(XAgenda: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaAgenda(XId: integer): TJSONObject;
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
         SQL.Add('select "CodigoInternoAgenda"     as id,');
         SQL.Add('       "CodigoFuncionarioAgenda" as idfuncionario,');
         SQL.Add('       "CodigoClienteAgenda"     as idcliente,');
         SQL.Add('       "DataAgenda"              as data,');
         SQL.Add('       "HoraAgenda"              as hora,');
         SQL.Add('       "LocalAgenda"             as local,');
         SQL.Add('       "DescricaoAgenda"         as descricao,');
         SQL.Add('       "AlertaUsuarioAgenda"     as alertausuario ');
         SQL.Add('from   "Agenda" ');
         SQL.Add('where  "CodigoInternoAgenda"=:xid ');
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
        wret.AddPair('description','Nenhuma Agenda encontrada');
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
    end;
  end;
  wconexao.EncerraConexaoDB;
  Result := wret;
end;

function RetornaTotalAgendas(const XQuery: TDictionary<string, string>): TJSONObject;
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
         SQL.Add('from "Agenda" ');
         if XQuery.ContainsKey('data') then // filtro por data
            begin
              SQL.Add('Where "DataAgenda"=:xdata ');
              ParamByName('xdata').AsDate := strtodate(XQuery.Items['data']);
            end;
         if XQuery.ContainsKey('descricao') then // filtro por descricao
            begin
              SQL.Add('Where lower("DescricaoAgenda") like lower(:xdescricao) ');
              ParamByName('xdescricao').AsString := XQuery.Items['descricao']+'%';
            end;
         Open;
         EnableControls;
       end;

   if wquery.RecordCount>0 then
      wret := wquery.ToJSONObject()
   else
      begin
        wret := TJSONObject.Create;
        wret.AddPair('status','500');
        wret.AddPair('description','Nenhuma agenda encontrada');
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

function RetornaListaAgendas(const XQuery: TDictionary<string, string>; XLimit,XOffset: integer): TJSONArray;
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
//    showmessage(inttostr(wconexao.FIdEmpresaAtividade));

    if wconexao.EstabeleceConexaoDB then
       with wqueryLista do
       begin
         Connection := wconexao.FDConnectionApi;
         DisableControls;
         Close;
         SQL.Clear;
         Params.Clear;
         SQL.Add('select "CodigoInternoAgenda"     as id,');
         SQL.Add('       "CodigoFuncionarioAgenda" as idfuncionario,');
         SQL.Add('       "CodigoClienteAgenda"     as idcliente,');
         SQL.Add('       "DataAgenda"              as data,');
         SQL.Add('       "HoraAgenda"              as hora,');
         SQL.Add('       "LocalAgenda"             as local,');
         SQL.Add('       "DescricaoAgenda"         as descricao,');
         SQL.Add('       "AlertaUsuarioAgenda"     as alertausuario ');
         SQL.Add('from "Agenda" where "CodigoInternoAgenda">0 ');
         if XQuery.ContainsKey('data') then // filtro por data
            begin
              SQL.Add('and "DataAgenda" =:xdata ');
              ParamByName('xdata').AsDate := strtodate(XQuery.Items['data']);
            end
         else if XQuery.ContainsKey('descricao') then // filtro por descricao
            begin
              SQL.Add('and lower("DescricaoAgenda") like lower(:xdescricao) ');
              ParamByName('xdescricao').AsString := XQuery.Items['descricao']+'%';
            end;
         if XQuery.ContainsKey('order') then // ordenação
            begin
              if XQuery.Items['order']='descricao' then
                 wordem := 'order by upper("DescricaoAgenda") '
              else if XQuery.Items['order']='local' then
                 wordem := 'order by upper("LocalAgenda") '
              else if XQuery.Items['order']='data' then
                 wordem := 'order by "DataAgenda" ';
              if XQuery.ContainsKey('dir') then // direção
                 wordem := wordem +XQuery.Items['dir'];
              SQL.Add(wordem);
            end
         else
            SQL.Add('order by "DataAgenda" ');
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
         wobj.AddPair('description','Nenhuma Agenda encontrada');
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

function IncluiAgenda(XAgenda: TJSONObject): TJSONObject;
var wquery: TFDMemTable;
    wqueryInsert,wquerySelect: TFDQuery;
    wret: TJSONObject;
    wnum: integer;
    wconexao: TProviderDataModuleConexao;
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
           SQL.Add('Insert into "Agenda" ("DescricaoAgenda","DataAgenda") ');
           SQL.Add('values (:xdescricao,:xdata) ');
           ParamByName('xdescricao').AsString := XAgenda.GetValue('descricao').Value;
           ParamByName('xdata').AsDate        := StrToDate(XAgenda.GetValue('data').Value);
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
                SQL.Add('select "DescricaoAgenda" as descricao, ');
                SQL.Add('       "DataAgenda"      as data       ');
                SQL.Add('from   "Agenda" ');
                SQL.Add('where  "DescricaoAgenda" = :xdescricao ');
                SQL.Add('       and "DataAgenda"  = :xdata ');
                ParamByName('xdescricao').AsString := XAgenda.GetValue('descricao').Value;
                ParamByName('xdata').AsDate        := StrToDate(XAgenda.GetValue('data').Value);
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhuma Agenda incluída');
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

function AlteraAgenda(XIdAgenda: integer; XAgenda: TJSONObject): TJSONObject;
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
    if XAgenda.TryGetValue('descricao',wval) then
       begin
         if wcampos='' then
            wcampos := '"DescricaoAgenda"=:xdescricao'
         else
            wcampos := wcampos+',"DescricaoAgenda"=:xdescricao';
       end;
    if XAgenda.TryGetValue('data',wval) then
       begin
         if wcampos='' then
            wcampos := '"DataAgenda"=:xdata'
         else
            wcampos := wcampos+',"DataAgenda"=:xdata';
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
           SQL.Add('Update "Agenda" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoAgenda"=:xid ');
           ParamByName('xid').AsInteger      := XIdAgenda;
           if XAgenda.TryGetValue('descricao',wval) then
              ParamByName('xdescricao').AsString  := XAgenda.GetValue('descricao').Value;
           if XAgenda.TryGetValue('data',wval) then
              ParamByName('xdata').AsDate  := StrToDate(XAgenda.GetValue('data').Value);
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
              SQL.Add('select "CodigoInternoAgenda" as id,');
              SQL.Add('       "DescricaoAgenda"     as descricao, ');
              SQL.Add('       "DataAgenda"          as data ');
              SQL.Add('from   "Agenda" ');
              SQL.Add('where  "CodigoInternoAgenda" =:xid ');
              ParamByName('xid').AsInteger := XIdAgenda;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhuma Agenda alterada');
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


function VerificaRequisicao(XAgenda: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if (not XAgenda.TryGetValue('descricao',wval)) or
       (not XAgenda.TryGetValue('data',wval)) then
       wret := false;
  finally
  end;
  Result := wret;
end;

function ApagaAgenda(XIdAgenda: integer): TJSONObject;
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
         SQL.Add('delete from "Agenda" where "CodigoInternoAgenda"=:xid ');
         ParamByName('xid').AsInteger := XIdAgenda;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Agenda excluída com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhuma Agenda excluída');
       end;
    wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
  except
    On E: Exception do
    begin
      wconexao.EncerraConexaoDB;
      wret.AddPair('status','500');
      wret.AddPair('description',E.Message);
      wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
//      messagedlg('Problema ao excluir Agenda'+slinebreak+E.Message,mterror,[mbok],0);
    end;
  end;
  wconexao.EncerraConexaoDB;
  Result := wret;
end;
end.
